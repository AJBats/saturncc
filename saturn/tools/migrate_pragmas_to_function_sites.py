#!/usr/bin/env python3
"""Move per-function pragma tags from the file-top block to immediately
above each function's implementation.

Pragmas migrated (per saturn/workstreams/save_strategy_and_asm_intrinsic.md
style rule): noregsave, noregalloc, sh_alloc_lowfirst.

Pragmas left alone (TU-wide / file-scope):
  - #pragma gbr_base, gbr_param
  - #pragma global_register
  - #pragma sh_word_indexed_after_first
Plus any pragma whose referenced function isn't defined in this TU.

Usage:
    python3 saturn/tools/migrate_pragmas_to_function_sites.py PATH_TO_TU.c

The script edits the file in place. Idempotent when re-run: if a
pragma is already above its function and not duplicated at top, it
stays put.
"""

import re
import sys
from pathlib import Path


PRAGMA_LINE = re.compile(
    r"^#pragma\s+(noregsave|noregalloc|sh_alloc_lowfirst)"
    r"\s*\(\s*(FUN_[0-9a-fA-F]+)\s*\)\s*$"
)

# Function signature (definition, not declaration). Our TU conventions:
#   [modifiers] returntype FUN_xxxxxxxx(args)
# followed (possibly after blank lines/comments) by a `{`. For the
# migration we just need to find the SIGNATURE LINE — the first line
# of the function that contains `FUN_xxxxxxxx(` with the same name.
# We distinguish definition from declaration by following the signature
# forward and finding either a `{` (definition) or a `;` (declaration).
FN_SIG_LINE = re.compile(
    r"^(?:extern\s+|static\s+)?"
    r"(?:void|int|uint|short|ushort|char|uchar|long|ulong|signed|unsigned|"
    r"undefined\d?|code\s*\*|struct\s+\w+\s*\*?)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)

# The banner comment we want to sit our pragmas just ABOVE, if present.
BANNER_COMMENT = re.compile(
    r"^/\*\s*═+\s*\[\d+/\d+\]\s+FUN_[0-9a-fA-F]+\s*═+\s*\*/"
)


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: migrate_pragmas_to_function_sites.py PATH_TO_TU.c")
    path = Path(sys.argv[1])
    lines = path.read_text().splitlines(keepends=True)

    # Step 1: collect per-function pragmas from the top block. Only
    # consider pragmas that appear BEFORE the first function definition
    # — that's the file-top block. Any pragmas already sitting above a
    # function are presumed already migrated and we leave them in place.
    first_fn_idx = None
    for i, line in enumerate(lines):
        m = FN_SIG_LINE.match(line.lstrip())
        if not m:
            continue
        # Confirm this is a definition by scanning forward for `{`
        # before any `;`. Declarations terminate in `;` on the same or
        # a following line before a `{`.
        j = i
        is_def = False
        while j < len(lines) and j - i < 8:
            if "{" in lines[j]:
                is_def = True
                break
            if ";" in lines[j]:
                break
            j += 1
        if is_def:
            first_fn_idx = i
            break
    if first_fn_idx is None:
        sys.exit("no function definition found")

    # Extract per-function pragmas from the top block, normalised by
    # fn_name (case-insensitive since FUN_xxxxxxxx case varies).
    fn_pragmas = {}
    lines_to_drop = set()
    for i in range(first_fn_idx):
        m = PRAGMA_LINE.match(lines[i].rstrip())
        if not m:
            continue
        pragma_kind, fn_name = m.group(1), m.group(2)
        key = fn_name.lower()
        fn_pragmas.setdefault(key, []).append(lines[i])
        lines_to_drop.add(i)

    # Step 2: find each function DEFINITION site and insert the
    # collected pragmas immediately above the signature line (not above
    # the banner comment or doc block). User style rule: pragma should
    # sit flush against the line of code that starts the function.
    # Declarations (lines ending in `;` within a few lines) are skipped
    # so pragmas don't attach to externs.
    matched_keys = set()
    out = []
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        if i in lines_to_drop:
            i += 1
            continue
        m = FN_SIG_LINE.match(line.lstrip())
        if m:
            fn_name = m.group(1)
            key = fn_name.lower()
            # Distinguish definition from declaration: scan forward a
            # few lines for `{` (definition) vs `;` (declaration).
            j = i
            is_def = False
            while j < n and j - i < 8:
                if "{" in lines[j]:
                    is_def = True
                    break
                if ";" in lines[j]:
                    break
                j += 1
            if is_def and key in fn_pragmas and key not in matched_keys:
                # Insert pragmas flush against the signature line —
                # directly above `line`. No blank between pragma and
                # signature.
                for p in fn_pragmas[key]:
                    out.append(p)
                matched_keys.add(key)
        out.append(line)
        i += 1

    # Warn about any pragmas we didn't find function definitions for —
    # they stay at top; put them back.
    unmatched = [k for k in fn_pragmas if k not in matched_keys]
    if unmatched:
        # Find the end of the initial doc block (first non-comment,
        # non-pragma line after the header) to re-insert unmatched
        # pragmas. Simplest: prepend to output after the header.
        print(f"warn: {len(unmatched)} pragmas reference functions not"
              f" defined in this TU:", file=sys.stderr)
        for k in unmatched[:10]:
            print(f"  {k}", file=sys.stderr)
        # Insert them back right after the last initial comment/pragma
        # line before the first function. Conservative: put at line 0.
        header_end = 0
        for i, line in enumerate(out):
            m = FN_SIG_LINE.match(line.lstrip())
            if m:
                header_end = i
                break
        reinsert = []
        for k in unmatched:
            reinsert.extend(fn_pragmas[k])
        reinsert.append("\n")
        out = out[:header_end] + reinsert + out[header_end:]

    path.write_text("".join(out))
    migrated = sum(
        1 for k in fn_pragmas if k in matched_keys for _ in fn_pragmas[k]
    )
    total_pragmas = sum(len(v) for v in fn_pragmas.values())
    print(f"Migrated {migrated}/{total_pragmas} pragma lines to function"
          f" sites. {len(lines_to_drop)} top-block lines removed.")
    if unmatched:
        print(f"Kept {len(unmatched)} pragmas at top (referenced functions"
              f" not defined in this TU).")


if __name__ == "__main__":
    main()
