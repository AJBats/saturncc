#!/usr/bin/env python3
"""Scan the race_FUN_06044060 TU for functions whose Ghidra body uses
unaff_rN annotations. Prints one function name per line.

These are the candidates for `#pragma noregsave` tagging — SHC marked
the callee-saved regs as pass-through in each of these, which means
prod's prologue saves none of R8..R14 for them."""

from pathlib import Path
import re
import sys

SRC = Path("saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c")

FN_HEADER = re.compile(
    r"^(?:undefined\d*|void|u?int\d*|u?short|u?char|u?long|byte|bool|FUN_[0-9a-fA-F]+\s*\*?)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)
UNAFF = re.compile(r"\bunaff_r\d+\b|\bunaff_gbr\b")


def main():
    text = SRC.read_text()
    lines = text.splitlines()
    i = 0
    n = len(lines)
    candidates = []
    while i < n:
        m = FN_HEADER.match(lines[i])
        if not m:
            i += 1
            continue
        fn = m.group(1)
        # Find the opening brace and scan body until matching close
        depth = 0
        has_unaff = False
        j = i
        while j < n:
            line = lines[j]
            if UNAFF.search(line):
                has_unaff = True
            for ch in line:
                if ch == "{":
                    depth += 1
                elif ch == "}":
                    depth -= 1
                    if depth == 0:
                        break
            if depth == 0 and j > i and "{" in "".join(lines[i : j + 1]):
                break
            j += 1
        if has_unaff:
            candidates.append(fn)
        i = j + 1
    for fn in candidates:
        print(fn)
    print(f"--- total: {len(candidates)} functions", file=sys.stderr)


if __name__ == "__main__":
    main()
