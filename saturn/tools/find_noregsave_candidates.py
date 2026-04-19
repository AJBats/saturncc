#!/usr/bin/env python3
"""Find functions to tag #pragma noregsave.

Combines two signals:
- Prod .s save pattern: function saves nothing in R8..R14 (noregsave-shaped)
- C source function name in its actual casing (so the pragma matches)

Subtracts already-tagged functions and any explicitly excluded.
"""

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
    # Step 1: gather all functions defined in the C source with actual casing.
    src_text = SRC.read_text()
    src_fns = {}  # lowercase -> actual case from source
    for line in src_text.splitlines():
        m = FN_HEADER.match(line)
        if m:
            fn = m.group(1)
            src_fns[fn.lower()] = fn

    # Step 2: gather already-tagged pragmas from the source.
    tagged = set()
    for line in src_text.splitlines():
        m = re.match(r"^\s*#pragma\s+noregsave\s*\(\s*(\w+)\s*\)", line)
        if m:
            tagged.add(m.group(1).lower())

    # Step 3: classify prod functions by save pattern.
    prod_text = PROD.read_text(errors="replace")
    prod_lines = prod_text.splitlines()
    noregsave_fns = []
    i = 0
    n = len(prod_lines)
    while i < n:
        m = FN_LABEL.match(prod_lines[i])
        if not m:
            i += 1
            continue
        fn_prod = m.group(1)
        saves_callee = False
        j = i + 1
        in_prologue = True
        while j < n and in_prologue and j - i < 20:
            line = prod_lines[j]
            sm = SAVE_RN.match(line)
            if sm:
                rn = int(sm.group(1))
                if 8 <= rn <= 14:
                    saves_callee = True
                    break
            elif "@-r15" not in line and "sts.l" not in line:
                if line.strip() and not line.strip().startswith("."):
                    in_prologue = False
            j += 1
        if not saves_callee:
            noregsave_fns.append(fn_prod)
        i = j

    # Step 4: emit candidates that are in src + prod-noregsave + not yet tagged.
    candidates = []
    for fn_prod in noregsave_fns:
        key = fn_prod.lower()
        if key in src_fns and key not in tagged:
            candidates.append(src_fns[key])

    for c in candidates:
        print(c)
    print(f"--- candidates: {len(candidates)} (prod noregsave that aren't tagged yet)",
          file=sys.stderr)


if __name__ == "__main__":
    main()
