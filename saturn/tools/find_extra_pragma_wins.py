#!/usr/bin/env python3
"""For each currently-tagged TU function, A/B test adding an additional
pragma (noregalloc, regsave, etc.) and emit wins.

Tests these candidate additions:
  - noregalloc on functions currently tagged noregsave
  - regsave + sh_alloc_lowfirst on functions tagged noregsave
    (probably won't help — they're already noregsave)

Mutates source in-place between trials, restores at end."""

from pathlib import Path
import re
import subprocess
import sys

ROOT = Path("/mnt/d/Projects/saturncc")
SRC = ROOT / "saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c"
PROD = Path("/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s")
RCC = ROOT / "build/rcc"
NORMALIZE = ROOT / "saturn/tools/asm_normalize.py"
TU_OUT = Path("/tmp/_lf_extra.s")

FN_HEADER = re.compile(
    r"^(?:undefined\d*|void|u?int\d*|u?short|u?char|u?long|byte|bool|FUN_[0-9a-fA-F]+\s*\*?)"
    r"\s+(FUN_[0-9a-fA-F]+)\s*\("
)


def tu_functions():
    text = SRC.read_text()
    fns = []
    seen = set()
    for line in text.splitlines():
        m = FN_HEADER.match(line)
        if m and m.group(1) not in seen:
            fns.append(m.group(1))
            seen.add(m.group(1))
    return fns


def tagged_with(pragma):
    text = SRC.read_text()
    pat = re.compile(rf"^\s*#pragma\s+{pragma}\s*\(\s*(\w+)\s*\)", re.M)
    return set(m.group(1) for m in pat.finditer(text))


def diff_for(fn):
    pp = subprocess.run(
        ["cpp", "-P", str(SRC), "/tmp/_pp_extra.c"],
        capture_output=True, text=True
    )
    if pp.returncode != 0:
        return -1
    rcc = subprocess.run(
        [str(RCC), "-target=sh/hitachi", "/tmp/_pp_extra.c", str(TU_OUT)],
        capture_output=True, text=True
    )
    if rcc.returncode != 0:
        return -1
    ours = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, str(TU_OUT)],
        capture_output=True, text=True
    )
    if ours.returncode != 0 or not ours.stdout.strip():
        return -1
    prod = subprocess.run(
        ["python3", str(NORMALIZE), "--function", fn, str(PROD)],
        capture_output=True, text=True
    )
    if prod.returncode != 0:
        return -1
    Path("/tmp/_a.s").write_text(ours.stdout)
    Path("/tmp/_b.s").write_text(prod.stdout)
    diff = subprocess.run(
        ["diff", "/tmp/_a.s", "/tmp/_b.s"], capture_output=True, text=True
    )
    return sum(1 for line in diff.stdout.splitlines()
               if line.startswith("<") or line.startswith(">"))


def add_pragma(fn, pragma):
    text = SRC.read_text()
    backup = text
    anchor = "#pragma noregsave(FUN_06047d46)"
    new = text.replace(
        anchor,
        f"{anchor}\n#pragma {pragma}({fn})  /* extra A/B */"
    )
    SRC.write_text(new)
    return backup


def restore(text):
    SRC.write_text(text)


def main():
    fns = tu_functions()
    print(f"# {len(fns)} TU functions", file=sys.stderr)

    noregsave_tagged = tagged_with("noregsave")
    print(f"# {len(noregsave_tagged)} noregsave-tagged", file=sys.stderr)

    # Get baseline diffs
    baseline = {}
    for i, fn in enumerate(fns):
        baseline[fn] = diff_for(fn)
        if i % 30 == 0:
            print(f"  baseline {i}/{len(fns)}", file=sys.stderr)
    print("# Baselines done", file=sys.stderr)

    # Test noregalloc on each noregsave-tagged function
    wins = []
    candidates = [fn for fn in fns
                  if fn in noregsave_tagged and baseline.get(fn, 0) > 0]
    print(f"# Testing noregalloc on {len(candidates)} noregsave functions",
          file=sys.stderr)
    for i, fn in enumerate(candidates):
        backup = add_pragma(fn, "noregalloc")
        try:
            tagged = diff_for(fn)
        finally:
            restore(backup)
        if tagged < 0:
            continue
        delta = tagged - baseline[fn]
        if delta < 0:
            print(f"  {fn}: noregalloc WIN  {baseline[fn]} -> {tagged} ({delta})",
                  file=sys.stderr)
            wins.append((fn, baseline[fn], tagged))
        if (i + 1) % 30 == 0:
            print(f"  noregalloc tested {i+1}/{len(candidates)} ({len(wins)} wins)",
                  file=sys.stderr)

    print(f"# noregalloc wins: {len(wins)}", file=sys.stderr)
    if wins:
        total = sum(b - a for _, b, a in wins)
        print(f"# Aggregate: -{total} lines", file=sys.stderr)
    for fn, _, _ in wins:
        print(fn)


if __name__ == "__main__":
    main()
