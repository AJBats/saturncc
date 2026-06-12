#!/usr/bin/env python3
"""braf_verify.py — post-assembly ground-truth check of braf/bsrf
dispatch tables. Trusts nothing textual: reads the assembled object.

rcc's dispatch-table lint stamps every blessed table with a zero-size
symbol family (see the cross-build-stage banner above
sh_pool_align_for_label in src/sh.md):

    saturncc_braf_K          — address of the braf/bsrf instruction (B)
    saturncc_braf_K_anchor   — address of the delta anchor label (A)
    saturncc_braf_K_tbl_N    — address of the table (T), N entries

Checks, per table K:

  ERROR  A != B+4              — the entire idiom's contract: hardware
                                 adds table entries to B+4; an anchor
                                 anywhere else means every dispatch is
                                 sheared by (A - (B+4)) bytes.
  ERROR  entry target is odd   — guaranteed illegal-instruction slot.
  ERROR  target inside table   — dispatching into your own table data:
                                 the exact 2026-06 FUN_06045B74 crash.
  WARN   target outside .text  — suspicious; may be legitimate for
                                 cross-section dispatch (none known).

Sweep: every braf/bsrf found by disassembling .text that has NO
saturncc_braf_K symbol is listed as INFO (unverifiable dispatch —
hand-rolled PC math the textual lint can't see). Data islands can
disassemble as false braf candidates, so INFO is informational, not
gating.

Exit codes: 0 = clean, 1 = ERRORs found, 2 = usage/tooling problem.

Usage:
    python3 braf_verify.py <object.o>
Env:
    SH_NM       nm binary       (default: saturn-sdk sh-elf-nm.exe)
    SH_OBJDUMP  objdump binary  (default: saturn-sdk sh-elf-objdump.exe)
"""
import os
import re
import struct
import subprocess
import sys

SDK_BIN = "/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin"
NM = os.environ.get("SH_NM", SDK_BIN + "/sh-elf-nm.exe")
OBJDUMP = os.environ.get("SH_OBJDUMP", SDK_BIN + "/sh-elf-objdump.exe")

SYM_RE = re.compile(
    r'^([0-9A-Fa-f]+)\s+\S\s+saturncc_braf_(\d+)(_anchor|_tbl_(\d+))?\s*$')
DISAS_RE = re.compile(r'^\s*([0-9a-f]+):.*?\b(braf|bsrf)\b')
SECTION_LINE_RE = re.compile(r'^ ([0-9a-f]+) ((?:[0-9a-f]{2,8} ?){1,4})')


def run(cmd):
    try:
        out = subprocess.run(cmd, capture_output=True, text=True)
    except FileNotFoundError as e:
        print("braf_verify: tool not found: %s" % e, file=sys.stderr)
        sys.exit(2)
    # Windows-exe tools emit CRLF; normalize before any regex work.
    return out.stdout.replace("\r\n", "\n"), out.returncode


def main():
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        sys.exit(2)
    obj = sys.argv[1]

    # 1. Symbol family from nm.
    nm_out, rc = run([NM, obj])
    if rc != 0:
        print("braf_verify: nm failed on %s" % obj, file=sys.stderr)
        sys.exit(2)
    tables = {}  # K -> dict(B=, A=, T=, N=)
    for line in nm_out.splitlines():
        m = SYM_RE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        k = int(m.group(2))
        t = tables.setdefault(k, {})
        if m.group(3) is None:
            t["B"] = addr
        elif m.group(3) == "_anchor":
            t["A"] = addr
        else:
            t["T"] = addr
            t["N"] = int(m.group(4))

    # 2. Raw .text bytes (objdump -s section dump).
    sec_out, rc = run([OBJDUMP, "-s", "-j", ".text", obj])
    if rc != 0:
        print("braf_verify: objdump -s failed on %s" % obj,
              file=sys.stderr)
        sys.exit(2)
    text = bytearray()
    for line in sec_out.splitlines():
        m = SECTION_LINE_RE.match(line)
        if not m:
            continue
        off = int(m.group(1), 16)
        data = bytes.fromhex(m.group(2).replace(" ", ""))
        if off > len(text):
            text.extend(b"\x00" * (off - len(text)))
        text[off:off + len(data)] = data

    errors = 0
    warns = 0
    for k in sorted(tables):
        t = tables[k]
        if "B" not in t or "A" not in t or "T" not in t:
            print("ERROR: braf table %d: incomplete symbol family "
                  "(%s)" % (k, sorted(t.keys())))
            errors += 1
            continue
        B, A, T, N = t["B"], t["A"], t["T"], t["N"]
        if A != B + 4:
            print("ERROR: braf table %d: anchor at 0x%08x but "
                  "dispatch base is 0x%08x (braf at 0x%08x + 4) — "
                  "every dispatch sheared by %+d bytes"
                  % (k, A, B + 4, B, A - (B + 4)))
            errors += 1
        for i in range(N):
            off = T + 2 * i
            if off + 2 > len(text):
                print("ERROR: braf table %d entry %d at 0x%08x is "
                      "outside .text" % (k, i, off))
                errors += 1
                continue
            (w,) = struct.unpack_from(">h", text, off)
            target = B + 4 + w
            if target & 1:
                print("ERROR: braf table %d entry %d: target 0x%08x "
                      "is odd (delta %d from base 0x%08x)"
                      % (k, i, target, w, B + 4))
                errors += 1
            elif T <= target < T + 2 * N:
                print("ERROR: braf table %d entry %d: target 0x%08x "
                      "lands INSIDE the table [0x%08x..0x%08x) — "
                      "dispatch into table data (the FUN_06045B74 "
                      "crash class)" % (k, i, target, T, T + 2 * N))
                errors += 1
            elif not (0 <= target < len(text)):
                print("WARN: braf table %d entry %d: target 0x%08x "
                      "outside .text (size 0x%x)"
                      % (k, i, target, len(text)))
                warns += 1

    # 3. Sweep: dispatches with no metadata.
    dis_out, rc = run([OBJDUMP, "-d", "-j", ".text", obj])
    if rc != 0:
        print("braf_verify: objdump -d failed on %s" % obj,
              file=sys.stderr)
        sys.exit(2)
    known = {t["B"] for t in tables.values() if "B" in t}
    unverified = []
    for line in dis_out.splitlines():
        m = DISAS_RE.match(line)
        if m and int(m.group(1), 16) not in known:
            unverified.append((int(m.group(1), 16), m.group(2)))
    for addr, mn in unverified:
        print("INFO: unverified %s at 0x%08x (no saturncc metadata — "
              "hand-rolled dispatch or data decoded as code)"
              % (mn, addr))

    print("braf tables verified: %d, errors: %d, warnings: %d, "
          "unverified dispatch sites: %d"
          % (len(tables), errors, warns, len(unverified)))
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
