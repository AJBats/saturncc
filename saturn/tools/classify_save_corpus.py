#!/usr/bin/env python3
"""Classify the prologue-save strategy of every production function.

Walks every .s file under DaytonaCCEReverse/src/<module>/, extracts per-
function prologue saves (mov.l rN,@-r15 for N in 8..14, plus sts.l pr,@-r15),
and assigns each function to a bucket.

Buckets are mutually exclusive and are chosen to distinguish SHC's standard
"save [lowest_dirty..r14] contiguously in highest-first order" from any
deviations we find in the corpus.

Usage:
    python3 saturn/tools/classify_save_corpus.py                 # corpus-wide summary
    python3 saturn/tools/classify_save_corpus.py --per-function  # per-function dump
    python3 saturn/tools/classify_save_corpus.py --module race   # single module
"""

import argparse
from collections import defaultdict, Counter
from pathlib import Path
import re
import sys

PROD_ROOT = Path("/mnt/d/Projects/DaytonaCCEReverse/src")

FN_LABEL = re.compile(r"^(FUN_[0-9a-fA-F]+):\s*$")
SAVE_RN = re.compile(r"^\s*mov\.l\s+r(\d+)\s*,\s*@-r15\s*$")
SAVE_PR = re.compile(r"^\s*sts\.l\s+pr\s*,\s*@-r15\s*$")


def classify(save_order, saved_pr):
    """Return (bucket, detail) for a function.

    save_order: list of register numbers pushed in source order (top-to-
                bottom through the prologue), restricted to 8..14
    saved_pr: True if sts.l pr appears in the prologue
    """
    if not save_order:
        return ("LEAF" if not saved_pr else "NO_SAVES", None)

    saved_set = set(save_order)
    lowest = min(saved_set)
    expected_full = list(range(14, lowest - 1, -1))  # [14, 13, ..., lowest]

    if save_order == expected_full:
        return ("FULL_RANGE", f"r{lowest}..r14")

    # Contiguous range but different order (e.g., lowest first)
    if saved_set == set(expected_full):
        return ("REVERSE_ORDER", f"r{lowest}..r14 order={save_order}")

    # Not contiguous to r14
    return ("SPARSE", f"set={sorted(saved_set)} order={save_order}")


def scan_file(path):
    """Yield (fn_name, bucket, detail) for each function in `path`."""
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
        save_order = []
        saved_pr = False
        j = i + 1
        # Scan up to ~25 lines into the function body for prologue saves.
        # Stop the moment we hit a line that is neither a save nor a
        # comment/directive — that's the body starting.
        while j < n and j - i < 25:
            line = lines[j]
            sm = SAVE_RN.match(line)
            pm = SAVE_PR.match(line)
            if sm:
                rn = int(sm.group(1))
                if 8 <= rn <= 14:
                    save_order.append(rn)
                j += 1
                continue
            if pm:
                saved_pr = True
                j += 1
                continue
            s = line.strip()
            # Skip blanks, comments, and assembler directives
            if not s or s.startswith(";") or s.startswith(".") \
                    or s.startswith("!") or s.endswith(":"):
                j += 1
                continue
            # First real instruction → prologue done
            break
        bucket, detail = classify(save_order, saved_pr)
        yield fn, bucket, detail, saved_pr
        i = j


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--module", help="limit to one module (e.g. race)")
    ap.add_argument("--per-function", action="store_true",
                    help="dump one line per function")
    ap.add_argument("--bucket",
                    help="filter output to just one bucket name")
    args = ap.parse_args()

    if args.module:
        mods = [PROD_ROOT / args.module]
    else:
        mods = sorted(p for p in PROD_ROOT.iterdir() if p.is_dir())

    total = 0
    bucket_counts = Counter()
    per_module = defaultdict(Counter)
    bucket_samples = defaultdict(list)

    for mod in mods:
        mod_name = mod.name
        for s_file in sorted(mod.glob("*.s")):
            for fn, bucket, detail, saved_pr in scan_file(s_file):
                total += 1
                bucket_counts[bucket] += 1
                per_module[mod_name][bucket] += 1
                if len(bucket_samples[bucket]) < 5:
                    bucket_samples[bucket].append(
                        (mod_name, fn, detail, saved_pr))
                if args.per_function and (
                        not args.bucket or args.bucket == bucket):
                    print(f"{mod_name}\t{fn}\t{bucket}"
                          f"\tpr={int(saved_pr)}\t{detail or ''}")

    if args.per_function:
        return

    print(f"Corpus: {total} functions across {len(mods)} module(s)")
    print()
    print("Bucket counts (sorted):")
    for bucket, count in bucket_counts.most_common():
        pct = 100.0 * count / total if total else 0.0
        print(f"  {bucket:15s} {count:6d}  ({pct:5.1f}%)")
    print()
    print("Samples from each bucket:")
    for bucket, samples in bucket_samples.items():
        print(f"  [{bucket}]")
        for mod_name, fn, detail, saved_pr in samples:
            pr_flag = "pr" if saved_pr else "--"
            print(f"    {mod_name}/{fn}  {pr_flag}  {detail or ''}")
    print()
    print("Per-module breakdown:")
    header = f"  {'module':10s}  " + "  ".join(
        f"{b:12s}" for b in bucket_counts)
    print(header)
    for mod_name in sorted(per_module):
        row = f"  {mod_name:10s}  " + "  ".join(
            f"{per_module[mod_name].get(b, 0):12d}" for b in bucket_counts)
        print(row)


if __name__ == "__main__":
    main()
