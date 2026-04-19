#!/usr/bin/env python3
"""Classify TU functions by prod save pattern.

For each function in race_FUN_06044060.s, look at the prologue saves
of R8..R14 in the prod assembly. Emit one line per function:

  FUN_xxx  saves=<lowest>..14   |  saves=none

This lets us auto-derive the noregsave/regsave classification:
- "saves=none" → noregsave candidate
- "saves=N..14" → regsave candidate (with lowest_dirty=N)
"""

from pathlib import Path
import re
import sys

PROD = Path("/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s")

FN_LABEL = re.compile(r"^(FUN_[0-9a-fA-F]+):\s*$")
SAVE_RN = re.compile(r"^\s*mov\.l\s+r(\d+)\s*,\s*@-r15\s*$")


def main():
    text = PROD.read_text(errors="replace")
    lines = text.splitlines()
    i = 0
    n = len(lines)
    classifications = []
    while i < n:
        m = FN_LABEL.match(lines[i])
        if not m:
            i += 1
            continue
        fn = m.group(1)
        saves_in_callee_range = set()
        # Look at the next ~20 lines for prologue saves
        j = i + 1
        in_prologue = True
        while j < n and in_prologue and j - i < 20:
            line = lines[j]
            sm = SAVE_RN.match(line)
            if sm:
                rn = int(sm.group(1))
                if 8 <= rn <= 14:
                    saves_in_callee_range.add(rn)
            elif "@-r15" not in line and "sts.l" not in line:
                # Past prologue — stop looking
                if line.strip() and not line.strip().startswith("."):
                    in_prologue = False
            j += 1
        if saves_in_callee_range:
            lowest = min(saves_in_callee_range)
            classifications.append((fn, "regsave", lowest))
        else:
            classifications.append((fn, "noregsave", None))
        i = j

    for fn, cls, lowest in classifications:
        if cls == "noregsave":
            print(f"{fn}\tnoregsave")
        else:
            print(f"{fn}\tregsave\tlowest=r{lowest}")
    counts = {}
    for _, cls, _ in classifications:
        counts[cls] = counts.get(cls, 0) + 1
    print(f"--- total: {sum(counts.values())}, "
          f"noregsave={counts.get('noregsave', 0)}, "
          f"regsave={counts.get('regsave', 0)}", file=sys.stderr)


if __name__ == "__main__":
    main()
