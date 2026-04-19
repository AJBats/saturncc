#!/usr/bin/env python3
"""A/B test each TU function with #pragma sh_alloc_lowfirst.

For each function in the TU (excluding skips and already-byte-matched),
add a sh_alloc_lowfirst tag, recompile the TU, measure that function's
diff, compare to baseline. Emit tag if delta is improvement.

Mutates the TU source file in-place between compiles, restores it
at the end. Run from repo root.

Output: one function name per line for tags that net improvement,
plus a per-function summary on stderr."""

from pathlib import Path
import re
import subprocess
import sys

ROOT = Path("/mnt/d/Projects/saturncc")
SRC = ROOT / "saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c"
PROD = Path("/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s")
RCC = ROOT / "build/rcc"
NORMALIZE = ROOT / "saturn/tools/asm_normalize.py"
TU_OUT = Path("/tmp/lowfirst_tu.s")

FN_HEADER = re.compile(
    r"^(?:undefined\d*|void|u?int\d*|u?short|u?char|u?long|byte|bool|FUN_[0-9a-fA-F]+\s*\*?)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)


def tu_functions():
    """All function names defined in the TU source, in definition order."""
    text = SRC.read_text()
    fns = []
    seen = set()
    for line in text.splitlines():
        m = FN_HEADER.match(line)
        if m:
            fn = m.group(1)
            if fn not in seen:
                fns.append(fn)
                seen.add(fn)
    return fns


def diff_for(fn):
    """Compile current TU, normalize the named function, return diff count
    against prod. Returns -1 if compile failed or function wasn't emitted."""
    # Preprocess first (matches validate_byte_match_tu.sh).
    pp = subprocess.run(
        ["cpp", "-P", str(SRC), "/tmp/_pp.c"],
        capture_output=True, text=True
    )
    if pp.returncode != 0:
        return -1
    rcc_result = subprocess.run(
        [str(RCC), "-target=sh/hitachi", "/tmp/_pp.c", str(TU_OUT)],
        capture_output=True, text=True
    )
    if rcc_result.returncode != 0:
        return -1
    # Normalize ours
    ours = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, str(TU_OUT)],
        capture_output=True, text=True
    )
    if ours.returncode != 0 or not ours.stdout.strip():
        return -1
    # Normalize prod
    prod = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, str(PROD)],
        capture_output=True, text=True
    )
    if prod.returncode != 0:
        return -1
    # diff
    Path("/tmp/_a.s").write_text(ours.stdout)
    Path("/tmp/_b.s").write_text(prod.stdout)
    diff = subprocess.run(
        ["diff", "/tmp/_a.s", "/tmp/_b.s"], capture_output=True, text=True
    )
    return sum(1 for line in diff.stdout.splitlines()
               if line.startswith("<") or line.startswith(">"))


def add_pragma(fn):
    """Add #pragma sh_alloc_lowfirst(fn) to source file. Returns the
    backup of the original file content."""
    text = SRC.read_text()
    # Insert after the last existing pragma block; find a stable anchor
    anchor = "#pragma noregsave(FUN_06047d46)"
    new = text.replace(
        anchor,
        f"{anchor}\n#pragma sh_alloc_lowfirst({fn})  /* A/B probe */"
    )
    SRC.write_text(new)
    return text


def restore(orig_text):
    SRC.write_text(orig_text)


def main():
    print("# A/B testing #pragma sh_alloc_lowfirst per TU function", file=sys.stderr)
    orig = SRC.read_text()
    fns = tu_functions()
    print(f"# Total functions in TU: {len(fns)}", file=sys.stderr)

    # Baseline diffs (no extra tags)
    baseline = {}
    for i, fn in enumerate(fns):
        d = diff_for(fn)
        baseline[fn] = d
        if i % 20 == 0:
            print(f"  baseline {i}/{len(fns)}", file=sys.stderr)
    print(f"# Baseline measurements done", file=sys.stderr)

    # Per-function tag test
    wins = []
    for i, fn in enumerate(fns):
        if baseline[fn] in (-1, 0):
            # Skip already-matched or skip-not-emitted
            continue
        # Tag this function only
        backup = add_pragma(fn)
        try:
            d_tagged = diff_for(fn)
        finally:
            restore(backup)
        if d_tagged < 0:
            print(f"  {fn}: tagged compile failed", file=sys.stderr)
            continue
        delta = d_tagged - baseline[fn]
        if delta < 0:
            print(f"  {fn}: WIN  {baseline[fn]} -> {d_tagged} ({delta})",
                  file=sys.stderr)
            wins.append((fn, baseline[fn], d_tagged))
        elif delta > 0:
            pass  # silent on regressions
        # else: no change, silent
        if (i + 1) % 20 == 0:
            print(f"  tested {i+1}/{len(fns)} ({len(wins)} wins so far)",
                  file=sys.stderr)

    print(f"# Total wins: {len(wins)}", file=sys.stderr)
    total_lines = sum(b - a for _, b, a in wins)
    print(f"# Aggregate lines closed: {total_lines}", file=sys.stderr)

    for fn, b, a in wins:
        print(fn)


if __name__ == "__main__":
    main()
