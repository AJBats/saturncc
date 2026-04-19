#!/usr/bin/env python3
"""A/B test #pragma sh_alloc_lowfirst on each standalone corpus function.

For each .c in saturn/experiments/daytona_byte_match (top + race_tu1),
parse out the function name(s), add a #pragma sh_alloc_lowfirst tag
with each name, recompile, normalize-diff vs prod, and keep tags that
strictly improve.

Outputs (file, fn, baseline, tagged_diff) tuples for wins."""

from pathlib import Path
import re
import subprocess
import sys

ROOT = Path("/mnt/d/Projects/saturncc")
RCC = ROOT / "build/rcc"
NORMALIZE = ROOT / "saturn/tools/asm_normalize.py"
PROD_BASE = Path("/mnt/d/Projects/DaytonaCCEReverse/src")

# Standalone files to test
TARGETS = [
    ("saturn/experiments/daytona_byte_match/FUN_00280710.c", "main"),
    ("saturn/experiments/daytona_byte_match/FUN_06000AF8.c", "race"),
    ("saturn/experiments/daytona_byte_match/FUN_06004378.c", "backup"),
    ("saturn/experiments/daytona_byte_match/race_tu1/FUN_0602A664.c", "race"),
    ("saturn/experiments/daytona_byte_match/race_tu1/FUN_06037E28.c", "race"),
    ("saturn/experiments/daytona_byte_match/race_tu1/FUN_0604025C.c", "race"),
    ("saturn/experiments/daytona_byte_match/race_tu1/FUN_06040EA0.c", "race"),
    ("saturn/experiments/daytona_byte_match/race_tu1/FUN_06047748.c", "race"),
]

FN_DEF = re.compile(
    r"^(?:undefined\d*|void|u?int\d*|u?short|u?char|u?long|byte|bool|FUN_[0-9a-fA-F]+\s*\*?|extern\s+int)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)


def primary_fn(c_path):
    """Return the FUN_xxx that matches the file's basename."""
    base = Path(c_path).stem  # e.g. FUN_06044BCC
    text = (ROOT / c_path).read_text()
    for line in text.splitlines():
        m = FN_DEF.match(line)
        if m and m.group(1).lower() == base.lower():
            return m.group(1)
    return None


def diff_for(c_path, fn, prod_module):
    src = ROOT / c_path
    out_s = "/tmp/_one.s"
    pp = subprocess.run(
        ["cpp", "-P", str(src), "/tmp/_pp_one.c"],
        capture_output=True, text=True
    )
    if pp.returncode != 0:
        return -1
    rcc = subprocess.run(
        [str(RCC), "-target=sh/hitachi", "/tmp/_pp_one.c", out_s],
        capture_output=True, text=True
    )
    if rcc.returncode != 0:
        return -1
    # Find prod .s — could be in src/<module>/<FN>.s or inlined in a TU file.
    prod_path = PROD_BASE / prod_module / f"{fn}.s"
    if not prod_path.exists():
        # Search for the function entry in any .s in that module.
        for p in (PROD_BASE / prod_module).glob("*.s"):
            if re.search(rf"^{fn}:", p.read_text(errors='replace'), re.M):
                prod_path = p
                break
        else:
            return -2
    ours = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, out_s],
        capture_output=True, text=True
    )
    prod = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, str(prod_path)],
        capture_output=True, text=True
    )
    if ours.returncode != 0 or prod.returncode != 0:
        return -3
    Path("/tmp/_a.s").write_text(ours.stdout)
    Path("/tmp/_b.s").write_text(prod.stdout)
    diff = subprocess.run(
        ["diff", "/tmp/_a.s", "/tmp/_b.s"], capture_output=True, text=True
    )
    return sum(1 for line in diff.stdout.splitlines()
               if line.startswith("<") or line.startswith(">"))


def add_pragma(c_path, fn):
    src = ROOT / c_path
    text = src.read_text()
    backup = text
    # Insert after first /* ... */ comment block, before first declaration.
    new = f"#pragma sh_alloc_lowfirst({fn})\n" + text
    src.write_text(new)
    return backup


def restore(c_path, backup):
    (ROOT / c_path).write_text(backup)


def main():
    for c_path, mod in TARGETS:
        fn = primary_fn(c_path)
        if not fn:
            print(f"  {c_path}: no function found", file=sys.stderr)
            continue
        baseline = diff_for(c_path, fn, mod)
        if baseline <= 0:
            print(f"  {fn}: baseline={baseline} (skip)", file=sys.stderr)
            continue
        backup = add_pragma(c_path, fn)
        try:
            tagged = diff_for(c_path, fn, mod)
        finally:
            restore(c_path, backup)
        delta = tagged - baseline
        if delta < 0:
            print(f"  {fn}: WIN  {baseline} -> {tagged} ({delta})", file=sys.stderr)
            print(c_path, fn, baseline, tagged)
        elif delta > 0:
            print(f"  {fn}: regress {baseline} -> {tagged} (skip)", file=sys.stderr)
        else:
            print(f"  {fn}: no-op", file=sys.stderr)


if __name__ == "__main__":
    main()
