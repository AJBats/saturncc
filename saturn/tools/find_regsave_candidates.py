#!/usr/bin/env python3
"""Find functions to tag #pragma regsave: prod saves R8..R14
contiguous starting from some lowest, function exists in C source,
not already tagged. Mirrors find_noregsave_candidates.py."""

from pathlib import Path
import re
import sys

ROOT = Path("/mnt/d/Projects/saturncc")
SRC = ROOT / "saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c"
PROD = Path("/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s")

FN_HEADER = re.compile(
    r"^(?:undefined\d*|void|u?int\d*|u?short|u?char|u?long|byte|bool|FUN_[0-9a-fA-F]+\s*\*?)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)
FN_LABEL = re.compile(r"^(FUN_[0-9a-fA-F]+):\s*$")
SAVE_RN = re.compile(r"^\s*mov\.l\s+r(\d+)\s*,\s*@-r15\s*$")


def main():
    src_text = SRC.read_text()
    src_fns = {}
    for line in src_text.splitlines():
        m = FN_HEADER.match(line)
        if m:
            fn = m.group(1)
            src_fns[fn.lower()] = fn

    tagged_regsave = set()
    tagged_noregsave = set()
    for line in src_text.splitlines():
        m = re.match(r"^\s*#pragma\s+regsave\s*\(\s*(\w+)\s*\)", line)
        if m:
            tagged_regsave.add(m.group(1).lower())
        m = re.match(r"^\s*#pragma\s+noregsave\s*\(\s*(\w+)\s*\)", line)
        if m:
            tagged_noregsave.add(m.group(1).lower())

    prod_text = PROD.read_text(errors="replace")
    prod_lines = prod_text.splitlines()
    regsave_fns = []
    i = 0
    n = len(prod_lines)
    while i < n:
        m = FN_LABEL.match(prod_lines[i])
        if not m:
            i += 1
            continue
        fn_prod = m.group(1)
        saves = set()
        j = i + 1
        in_prologue = True
        while j < n and in_prologue and j - i < 20:
            line = prod_lines[j]
            sm = SAVE_RN.match(line)
            if sm:
                rn = int(sm.group(1))
                if 8 <= rn <= 14:
                    saves.add(rn)
            elif "@-r15" not in line and "sts.l" not in line:
                if line.strip() and not line.strip().startswith("."):
                    in_prologue = False
            j += 1
        if saves:
            regsave_fns.append((fn_prod, min(saves)))
        i = j

    print(f"# Prod regsave-shaped: {len(regsave_fns)}", file=sys.stderr)
    candidates = []
    for fn_prod, lowest in regsave_fns:
        key = fn_prod.lower()
        if key in src_fns and key not in tagged_regsave and key not in tagged_noregsave:
            candidates.append((src_fns[key], lowest))

    for c, low in candidates:
        print(c)
    print(f"# Candidates (in src, not tagged): {len(candidates)}", file=sys.stderr)


if __name__ == "__main__":
    main()
