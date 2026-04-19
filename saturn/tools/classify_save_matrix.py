#!/usr/bin/env python3
"""Build a feature matrix of every production function vs its save bucket.

Extracts per-function signals that might correlate with SHC's save-strategy
decision. Produces a bucket-vs-stat matrix plus detail drill-downs for
the anomaly buckets (SPARSE, REVERSE_ORDER).

Usage:
    python3 saturn/tools/classify_save_matrix.py                 # full report
    python3 saturn/tools/classify_save_matrix.py --module race
    python3 saturn/tools/classify_save_matrix.py --dump-csv out.csv
"""

import argparse
from collections import defaultdict, Counter
from pathlib import Path
import re
import statistics
import sys

PROD_ROOT = Path("/mnt/d/Projects/DaytonaCCEReverse/src")

FN_LABEL = re.compile(r"^(FUN_[0-9a-fA-F]+):\s*$")
SAVE_RN = re.compile(r"^\s*mov\.l\s+r(\d+)\s*,\s*@-r15\s*$")
POP_RN = re.compile(r"^\s*mov\.l\s+@r15\+\s*,\s*r(\d+)\s*$")
SAVE_PR = re.compile(r"^\s*sts\.l\s+pr\s*,\s*@-r15\s*$")
POP_PR = re.compile(r"^\s*lds\.l\s+@r15\+\s*,\s*pr\s*$")
JSR = re.compile(r"^\s*jsr\s")
RTS = re.compile(r"^\s*rts\s*$")
SUB_R15 = re.compile(r"^\s*add\s+#(-?\d+)\s*,\s*r15\s*$")
MOV_R15_R14 = re.compile(r"^\s*mov\s+r15\s*,\s*r14\s*$")
MACL = re.compile(r"\bmac\.l|\bsts\s+macl|\bsts\.l\s+macl\b")
GBR = re.compile(r"\bgbr\b", re.IGNORECASE)
DMULS = re.compile(r"\bdmuls\.l|\bdmulu\.l|\bmuls\.w|\bmulu\.w\b")
# Any register reference r0..r15 — both operand positions
ANY_RN = re.compile(r"\br(\d+)\b")
# Pre/post-increment address side effects (modify the reg in the addr mode)
PRE_DEC_RN = re.compile(r"@-r(\d+)")
POST_INC_RN = re.compile(r"@r(\d+)\+")
# Trailing register destination: ", rN" at end of operand string
TRAILING_DST_RN = re.compile(r",\s*r(\d+)\s*$")
# Store pattern: mov[.X] src, @...  (no register destination)
STORE_PATTERN = re.compile(r"^\s*[^,]+,\s*@")

# Mnemonics that never write any register (flags / control flow only)
NO_WRITE_MNEMONICS = {
    "cmp/eq", "cmp/hs", "cmp/ge", "cmp/hi", "cmp/gt", "cmp/pl", "cmp/pz",
    "cmp/str", "tst", "tst.b", "bt", "bf", "bt/s", "bf/s", "bra", "bra/s",
    "braf", "jsr", "jmp", "rts", "rte", "nop", "clrmac", "clrt", "sett",
    "sleep", "trapa", "ldc", "ldc.l",  # ldc writes SR/GBR/VBR, not GPRs
}

# Single-operand instructions that write their sole register operand
SINGLE_OP_WRITES = {
    "dt", "shll", "shll2", "shll8", "shll16",
    "shlr", "shlr2", "shlr8", "shlr16",
    "shal", "shar", "rotl", "rotr", "rotcl", "rotcr",
    "tas.b", "movt",
}


def regs_written_by_line(line):
    """Return set of register numbers this line writes to.

    Handles:
      - pre-decrement / post-increment address modes (modify the addr reg)
      - stores: `mov src, @...` writes memory, not a register
      - two-operand SH-2 ops: destination is the last operand
      - single-operand shifts / dt / movt: writes the single operand
      - `lds rN, ...`: rN is source; `sts ..., rN`: rN is dest
      - no-write mnemonics (cmp/*, tst, branches, jsr, etc.): nothing
    """
    s = line.strip()
    if not s or s.startswith(";") or s.startswith("!") \
            or s.startswith("."):
        return set()
    # Strip inline comment
    if ";" in s:
        s = s.split(";", 1)[0].strip()
    # Strip label prefix if any (label: instr)
    if ":" in s:
        after = s.split(":", 1)[1].strip()
        if after:
            s = after
        else:
            return set()
    parts = s.split(None, 1)
    if not parts:
        return set()
    mnemonic = parts[0].lower()
    operands = parts[1] if len(parts) > 1 else ""

    written = set()

    # Address-mode side effects first — these fire regardless of mnemonic
    for m in PRE_DEC_RN.finditer(operands):
        written.add(int(m.group(1)))
    for m in POST_INC_RN.finditer(operands):
        written.add(int(m.group(1)))

    if mnemonic in NO_WRITE_MNEMONICS:
        return written

    # Stores: `mov[.X] src, @...` — destination is memory, not a register
    if mnemonic.startswith("mov") and STORE_PATTERN.match(operands):
        return written

    # Single-op shifts / dt / movt
    if mnemonic in SINGLE_OP_WRITES:
        m = re.match(r"\s*r(\d+)\s*$", operands)
        if m:
            written.add(int(m.group(1)))
        return written

    # lds: source → system reg; lds rN,macl → rN is read, not written
    if mnemonic.startswith("lds"):
        return written

    # sts: system reg → dest reg; sts macl,rN → rN is written
    if mnemonic.startswith("sts"):
        m = TRAILING_DST_RN.search(operands)
        if m:
            written.add(int(m.group(1)))
        return written

    # Two-operand: destination is the trailing register (", rN" at end)
    m = TRAILING_DST_RN.search(operands)
    if m:
        written.add(int(m.group(1)))
        return written

    # Single unknown-mnemonic register operand — be conservative
    m = re.match(r"\s*r(\d+)\s*$", operands)
    if m:
        written.add(int(m.group(1)))
    return written
# Pool directives
POOL_LONG = re.compile(r"^\s*\.long\b")
POOL_WORD = re.compile(r"^\s*\.word\b")
POOL_4BYTE = re.compile(r"^\s*\.4byte\b")
LABEL = re.compile(r"^\s*[A-Za-z_][A-Za-z0-9_]*\s*:")
# Ghidra-emitted raw bytes with a comment showing the decoded instruction:
#   .byte 0xDD, 0x37  /* 06000B50: mov.l @(0xDC,PC),r13  {extras} */
# The instruction text sits between "<addr>: " and the next "{" or "*/".
BYTE_INSTR = re.compile(
    r"^\s*\.byte\b[^/]*?/\*\s*[0-9a-fA-F]+:\s*(?P<instr>[^{*]+?)\s*"
    r"(?:\{[^}]*\}\s*)?\*/\s*$")


def classify_bucket(save_order, saved_pr):
    if not save_order:
        return "LEAF" if not saved_pr else "NO_SAVES"
    saved_set = set(save_order)
    lowest = min(saved_set)
    expected = list(range(14, lowest - 1, -1))
    if save_order == expected:
        return "FULL_RANGE"
    if saved_set == set(expected):
        return "REVERSE_ORDER"
    return "SPARSE"


def extract_fn(lines, start):
    """Extract prologue + body + epilogue bounds for function starting at
    line `start` (the label line).

    Returns a dict of collected features, or None if the function is
    malformed (no rts found).
    """
    n = len(lines)
    # Phase 1: prologue scan (saves + sts.l pr)
    #
    # SHC interleaves pushes with other body instructions for pipeline
    # scheduling — see e.g. backup/FUN_06000000, where `tst r4,r4` lands
    # between the r14 and r13 pushes. We can't just stop at the first
    # non-push. Instead, we define the "prologue scheduling window" as
    # "everything up to the first control-flow op (jsr/branch/rts) or
    # the first label", and collect all saves found within that window.
    save_order = []
    saved_pr = False
    i = start + 1
    while i < n:
        line = lines[i]
        s = line.strip()
        # Skip blanks / comments / directives / labels
        if not s or s.startswith(";") or s.startswith("!") \
                or s.startswith("."):
            i += 1
            continue
        # Another function label or a local label ends the prologue window
        if FN_LABEL.match(line):
            break
        if LABEL.match(line):
            break
        # Control-flow instruction ends the prologue window
        if JSR.match(line) or RTS.match(line):
            break
        # bt/bf/bra/braf/jmp
        first = s.split(None, 1)[0].lower()
        if first in ("bt", "bf", "bt/s", "bf/s", "bra", "bra/s", "braf",
                     "jmp"):
            break
        # Recognize pushes anywhere in this window
        if SAVE_RN.match(line):
            rn = int(SAVE_RN.match(line).group(1))
            if 8 <= rn <= 14:
                save_order.append(rn)
            i += 1
            continue
        if SAVE_PR.match(line):
            saved_pr = True
            i += 1
            continue
        # Ordinary instruction interleaved in the prologue window — keep
        # scanning for more pushes.
        i += 1
    # Reset the scanner to the start of the function so the body-pass
    # sees every instruction INCLUDING those interleaved inside the
    # prologue window. The prologue pass above only collected pushes;
    # any other instructions scheduled between pushes (like `tst r4,r4`
    # or `mov r12,r8`) are real body work and must be counted.
    i = start + 1
    body_start = i

    # Phase 2: scan body + epilogue until rts
    body_end = None
    epilogue_pops = []
    num_calls = 0
    num_rts = 0
    callee_saved_touched = set()
    params_read = set()   # r4..r7 seen as source before being written
    params_written = set()
    has_frame_ptr = False
    has_stack_alloc = False
    stack_alloc_bytes = 0
    has_macl = False
    has_gbr = False
    has_mul = False
    instr_count = 0
    pool_entries = 0
    # Param-count heuristic: track r4..r7 that appear as SOURCE before they
    # are written. An incoming param is readable at entry; if a function
    # writes to r4 before reading it, r4 isn't being used as an incoming arg.
    param_read_before_write = set()
    param_already_written = set()

    def update_param_tracking(line_str, written_set):
        # "read" = any mention not on the destination side
        # crude but workable: if rN appears in the line AND isn't in
        # written_set, count it as read; if it IS in written_set, count it
        # as write-first only if not already read.
        for mm in ANY_RN.finditer(line_str):
            rn = int(mm.group(1))
            if not (4 <= rn <= 7):
                continue
            if rn in written_set and rn not in param_read_before_write:
                # Written this line; if never read before, it's write-first
                param_already_written.add(rn)
            elif rn not in param_already_written:
                param_read_before_write.add(rn)

    while i < n:
        line = lines[i]
        # Next function label → function ends here
        if FN_LABEL.match(line):
            break
        s = line.strip()

        if POOL_LONG.match(line) or POOL_WORD.match(line) \
                or POOL_4BYTE.match(line):
            pool_entries += 1
            i += 1
            continue

        # Ghidra raw-byte instruction: recover the instruction text from
        # its "/* ADDR: INSTR */" comment so the write-detector can run
        # on it. These appear for addressing modes the assembler won't
        # accept directly (PC-relative loads, r0-indexed modes).
        bm = BYTE_INSTR.match(line)
        if bm:
            instr_count += 1
            written = regs_written_by_line(bm.group("instr"))
            for rn in written:
                if 8 <= rn <= 14:
                    callee_saved_touched.add(rn)
            update_param_tracking(bm.group("instr"), written)
            i += 1
            continue

        if not s or s.startswith(";") or s.startswith("!") \
                or s.startswith("."):
            i += 1
            continue

        if LABEL.match(line):
            i += 1
            continue

        # Real instruction
        instr_count += 1

        if RTS.match(line):
            num_rts += 1
            # There may be a delay slot after rts; include it then stop
            if i + 1 < n:
                dslot_line = lines[i + 1]
                dslot = dslot_line.strip()
                if dslot and not dslot.startswith(".") \
                        and not dslot.startswith(";"):
                    instr_count += 1
                    dslot_written = regs_written_by_line(dslot_line)
                    for rn in dslot_written:
                        if 8 <= rn <= 14:
                            callee_saved_touched.add(rn)
                    update_param_tracking(dslot, dslot_written)
            body_end = i + 1
            i += 2
            continue

        if JSR.match(line):
            num_calls += 1
        if MACL.search(line):
            has_macl = True
        if GBR.search(line):
            has_gbr = True
        if DMULS.search(line):
            has_mul = True
        if MOV_R15_R14.match(line):
            has_frame_ptr = True
        sm = SUB_R15.match(line)
        if sm:
            has_stack_alloc = True
            stack_alloc_bytes = abs(int(sm.group(1)))

        # Track callee-saved *writes* outside prologue pushes & epilogue
        # pops. Pushes/pops don't write registers — they read (for push)
        # or restore them to their caller's value (for pop), so neither
        # should count as a dirty write in the body.
        if not SAVE_RN.match(line) and not POP_RN.match(line):
            written = regs_written_by_line(line)
            for rn in written:
                if 8 <= rn <= 14:
                    callee_saved_touched.add(rn)
            update_param_tracking(line, written)

        # Track epilogue pops
        if POP_RN.match(line):
            rn = int(POP_RN.match(line).group(1))
            if 8 <= rn <= 14:
                epilogue_pops.append(rn)

        i += 1

    # Commit the read-before-write set into params_read for reporting
    params_read = param_read_before_write

    if body_end is None:
        # No rts seen — malformed. Skip.
        return None

    # "Highest consumed param" heuristic: the highest r4..r7 that appears
    # in the function code tells us the minimum param count.
    highest_param = max(params_read) if params_read else None
    if highest_param is None:
        param_count_est = 0
    else:
        param_count_est = highest_param - 3  # r4→1, r5→2, r6→3, r7→4

    bucket = classify_bucket(save_order, saved_pr)

    return {
        "bucket": bucket,
        "save_order": save_order,
        "saved_pr": saved_pr,
        "instr_count": instr_count,
        "num_calls": num_calls,
        "num_rts": num_rts,
        "callee_saved_used": sorted(callee_saved_touched),
        "num_callee_saved_used": len(callee_saved_touched),
        "params_read": sorted(params_read),
        "param_count_est": param_count_est,
        "has_frame_ptr": has_frame_ptr,
        "has_stack_alloc": has_stack_alloc,
        "stack_alloc_bytes": stack_alloc_bytes,
        "has_macl": has_macl,
        "has_gbr": has_gbr,
        "has_mul": has_mul,
        "pool_entries": pool_entries,
        "epilogue_pops": epilogue_pops,
        "next_i": i,
    }


def scan_file(path):
    try:
        text = path.read_text(errors="replace")
    except OSError as e:
        print(f"warn: cannot read {path}: {e}", file=sys.stderr)
        return
    lines = text.splitlines()
    i = 0
    n = len(lines)
    while i < n:
        m = FN_LABEL.match(lines[i])
        if not m:
            i += 1
            continue
        fn = m.group(1)
        feats = extract_fn(lines, i)
        if feats is None:
            i += 1
            continue
        feats["module"] = path.parent.name
        feats["fn"] = fn
        feats["file"] = path.name
        yield feats
        i = feats["next_i"]


def pct(n, d):
    return 100.0 * n / d if d else 0.0


def summarize_numeric(values):
    if not values:
        return "n/a"
    return (f"mean={statistics.mean(values):.1f} "
            f"median={statistics.median(values):.0f} "
            f"min={min(values)} max={max(values)}")


def summarize_bool(values):
    if not values:
        return "n/a"
    t = sum(1 for v in values if v)
    return f"{t}/{len(values)} ({pct(t, len(values)):.1f}%)"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--module", help="limit to one module")
    ap.add_argument("--dump-csv", help="write full feature table to CSV")
    ap.add_argument("--drill", choices=["FULL_RANGE", "SPARSE",
                                        "REVERSE_ORDER", "NO_SAVES",
                                        "LEAF"],
                    help="show per-function detail for one bucket")
    args = ap.parse_args()

    mods = ([PROD_ROOT / args.module] if args.module
            else sorted(p for p in PROD_ROOT.iterdir() if p.is_dir()))

    all_feats = []
    for mod in mods:
        for s_file in sorted(mod.glob("*.s")):
            for feats in scan_file(s_file):
                all_feats.append(feats)

    if args.dump_csv:
        import csv
        fields = ["module", "fn", "bucket", "instr_count", "num_calls",
                  "num_rts", "num_callee_saved_used", "param_count_est",
                  "has_frame_ptr", "has_stack_alloc", "stack_alloc_bytes",
                  "has_macl", "has_gbr", "has_mul", "pool_entries",
                  "saved_pr"]
        with open(args.dump_csv, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=fields)
            w.writeheader()
            for f in all_feats:
                w.writerow({k: f[k] for k in fields})
        print(f"Wrote {len(all_feats)} rows to {args.dump_csv}")
        return

    buckets = defaultdict(list)
    for f in all_feats:
        buckets[f["bucket"]].append(f)

    if args.drill:
        print(f"=== Per-function drill for {args.drill} "
              f"({len(buckets[args.drill])}) ===\n")
        for f in sorted(buckets[args.drill],
                        key=lambda x: (x["module"], x["fn"])):
            saved = ",".join(f"r{r}" for r in f["save_order"]) or "-"
            used = ",".join(f"r{r}" for r in f["callee_saved_used"]) or "-"
            params = ",".join(f"r{r}" for r in f["params_read"]) or "-"
            extras = []
            if f["has_frame_ptr"]:
                extras.append("fp")
            if f["has_stack_alloc"]:
                extras.append(f"stk{f['stack_alloc_bytes']}")
            if f["has_macl"]:
                extras.append("macl")
            if f["has_gbr"]:
                extras.append("gbr")
            extra_s = f" [{','.join(extras)}]" if extras else ""
            print(f"  {f['module']}/{f['fn']}  "
                  f"instr={f['instr_count']:3d} calls={f['num_calls']:2d} "
                  f"rts={f['num_rts']} "
                  f"params={params:14s} "
                  f"used={used:20s} saved={saved}{extra_s}")
        return

    print(f"Total functions: {len(all_feats)}")
    print()

    # Matrix: bucket × stat
    stat_defs = [
        ("instr_count",   "numeric", "Function length (instructions)"),
        ("num_calls",     "numeric", "Number of jsr calls"),
        ("num_rts",       "numeric", "Number of rts (exit points)"),
        ("num_callee_saved_used", "numeric",
         "# of r8..r14 touched in body"),
        ("param_count_est", "numeric",
         "Est. param count (from r4..r7 reads)"),
        ("pool_entries",  "numeric", "Literal pool entries"),
        ("stack_alloc_bytes", "numeric",
         "Stack locals size (bytes; 0 = none)"),
        ("has_frame_ptr", "bool",    "Uses r14 as frame ptr"),
        ("has_stack_alloc", "bool",  "Allocates stack frame"),
        ("has_macl",      "bool",    "Uses mac.l / sts macl"),
        ("has_gbr",       "bool",    "Uses gbr"),
        ("has_mul",       "bool",    "Uses dmuls/dmulu/muls.w/mulu.w"),
        ("saved_pr",      "bool",    "Saves PR (makes calls)"),
    ]

    bucket_order = ["FULL_RANGE", "LEAF", "NO_SAVES", "SPARSE",
                    "REVERSE_ORDER"]

    print("Count per bucket:")
    for b in bucket_order:
        n = len(buckets[b])
        print(f"  {b:15s} {n:6d}  ({pct(n, len(all_feats)):5.1f}%)")
    print()

    for sk, sk_type, sk_desc in stat_defs:
        print(f"── {sk_desc}  [{sk}]")
        for b in bucket_order:
            vals = [f[sk] for f in buckets[b]]
            if sk_type == "numeric":
                print(f"    {b:15s} {summarize_numeric(vals)}")
            else:
                print(f"    {b:15s} {summarize_bool(vals)}")
        print()

    # FULL_RANGE correlation check: is lowest_saved always lowest_used?
    print("── FULL_RANGE consistency check: does lowest_saved == lowest_used?")
    fr = buckets["FULL_RANGE"]
    matches = 0
    mismatches = []
    for f in fr:
        if not f["callee_saved_used"]:
            continue  # saves full range but body touches none — separately interesting
        lowest_saved = min(f["save_order"])
        lowest_used = min(f["callee_saved_used"])
        if lowest_saved == lowest_used:
            matches += 1
        else:
            mismatches.append((f, lowest_saved, lowest_used))
    no_body_use = sum(1 for f in fr if not f["callee_saved_used"])
    print(f"    matches={matches}/{len(fr) - no_body_use}  "
          f"(plus {no_body_use} with empty body-use)")
    if mismatches:
        print(f"    {len(mismatches)} mismatches, samples:")
        for f, ls, lu in mismatches[:10]:
            print(f"      {f['module']}/{f['fn']}  "
                  f"saved=r{ls} but used-lowest=r{lu}  "
                  f"saves={f['save_order']} used={f['callee_saved_used']}")
    print()

    # NO_SAVES sanity: body should touch zero callee-saved regs
    print("── NO_SAVES sanity: does body really not touch r8..r14?")
    ns = buckets["NO_SAVES"]
    violators = [f for f in ns if f["callee_saved_used"]]
    print(f"    clean={len(ns) - len(violators)}/{len(ns)}  "
          f"violators={len(violators)}")
    if violators:
        print("    violators (likely global/pinned-register usage):")
        ctr = Counter()
        for f in violators:
            ctr[tuple(f["callee_saved_used"])] += 1
        for pattern, count in ctr.most_common(10):
            regs = ",".join(f"r{r}" for r in pattern)
            print(f"      used={regs:20s}  {count:4d} functions")
    print()

    # SPARSE: distribution of distinct (saved, used) patterns
    print("── SPARSE patterns (top distinct saved-set + used-set combos):")
    sp = buckets["SPARSE"]
    ctr = Counter()
    for f in sp:
        key = (tuple(f["save_order"]),
               tuple(sorted(f["callee_saved_used"])))
        ctr[key] += 1
    for (saved, used), count in ctr.most_common(15):
        saved_s = ",".join(f"r{r}" for r in saved) or "-"
        used_s = ",".join(f"r{r}" for r in used) or "-"
        print(f"    saved=[{saved_s:20s}] used=[{used_s:20s}]  "
              f"{count:4d} functions")
    print()

    # Param count correlation
    print("── Param count distribution per bucket:")
    for b in bucket_order:
        dist = Counter(f["param_count_est"] for f in buckets[b])
        total_b = len(buckets[b])
        line = f"    {b:15s} "
        for pc in range(0, 5):
            c = dist.get(pc, 0)
            line += f" p{pc}={c:4d}({pct(c, total_b):4.1f}%) "
        print(line)


if __name__ == "__main__":
    main()
