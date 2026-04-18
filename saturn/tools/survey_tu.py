#!/usr/bin/env python3
"""Phase 0 survey for a full production TU.

For each function in a prod TU .s:
  - Does a Ghidra C reference exist?
  - Does cpp preprocess OK (via shim header)?
  - Does rcc compile cleanly (no crash, no error)?
  - If compiled: what's the tier-1 normalized diff count vs prod?

Output: markdown dashboard + raw per-function detail.

Usage:  python3 saturn/tools/survey_tu.py <prod_tu_path> [output_dir]
"""
import os, re, subprocess, sys, glob

if len(sys.argv) < 2:
    print("usage: survey_tu.py <prod_tu_path> [output_dir]", file=sys.stderr)
    sys.exit(1)

TU_PATH = sys.argv[1]
OUT_DIR = sys.argv[2] if len(sys.argv) > 2 else "/tmp/tu_survey"
REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
RCC = os.path.join(REPO, "build", "rcc")
SHIM = os.path.join(REPO,
    "saturn/experiments/daytona_byte_match/race_tu1/ghidra_shim.h")
GHIDRA_REF = "/mnt/d/Projects/DaytonaCCEReverse/ghidra_reference/race"
NORMALIZER = os.path.join(REPO, "saturn/tools/asm_normalize.py")

os.makedirs(OUT_DIR, exist_ok=True)

# Step 1: enumerate functions + their instruction counts in TU
with open(TU_PATH) as f:
    tu_text = f.read()

# Find each function's start position
func_matches = list(re.finditer(r'^(FUN_[0-9a-fA-F]+):', tu_text, re.MULTILINE))
funcs = []
for i, m in enumerate(func_matches):
    name = m.group(1)
    start = m.end()
    end = func_matches[i+1].start() if i+1 < len(func_matches) else len(tu_text)
    body = tu_text[start:end]
    # Count instructions: non-empty lines that start with whitespace and
    # have an alpha char (not a directive or label)
    ninstr = 0
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith('.') or stripped.startswith('/*'):
            continue
        if ':' in stripped.split(';')[0][:20]:
            continue
        if stripped and stripped[0].isalpha():
            ninstr += 1
    funcs.append({"name": name, "ninstr": ninstr})

print(f"Enumerated {len(funcs)} functions in {TU_PATH}")

# Step 2: per-function survey
results = []
for i, fn in enumerate(funcs):
    name = fn["name"]
    if (i + 1) % 20 == 0:
        print(f"  [{i+1}/{len(funcs)}] processing {name}...", file=sys.stderr)

    r = dict(name=name, ninstr=fn["ninstr"], status=None, diff=None, note="")

    ghidra_c = os.path.join(GHIDRA_REF, f"{name}.c")
    if not os.path.exists(ghidra_c):
        r["status"] = "no_ghidra_c"
        results.append(r)
        continue

    pp_path = os.path.join(OUT_DIR, f"{name}.pp.c")
    cpp_res = subprocess.run(
        ["cpp", "-P", "-include", SHIM, ghidra_c, pp_path],
        capture_output=True, text=True, timeout=30)
    if cpp_res.returncode != 0:
        r["status"] = "cpp_fail"
        results.append(r)
        continue

    s_path = os.path.join(OUT_DIR, f"{name}.s")
    try:
        rcc_res = subprocess.run(
            [RCC, "-target=sh/hitachi", pp_path, s_path],
            capture_output=True, text=True, timeout=30)
    except subprocess.TimeoutExpired:
        r["status"] = "rcc_timeout"
        results.append(r)
        continue

    if rcc_res.returncode < 0 or rcc_res.returncode >= 128:
        r["status"] = "rcc_crash"
        results.append(r)
        continue
    if rcc_res.returncode != 0:
        r["status"] = "rcc_fail"
        r["note"] = rcc_res.stderr.strip().split("\n")[0][:80]
        results.append(r)
        continue

    our_norm = os.path.join(OUT_DIR, f"{name}.our.norm")
    prod_norm = os.path.join(OUT_DIR, f"{name}.prod.norm")

    norm_our = subprocess.run(
        ["python3", NORMALIZER, "--function", name, s_path],
        capture_output=True, text=True)
    if norm_our.returncode != 0:
        r["status"] = "our_norm_fail"
        results.append(r)
        continue
    with open(our_norm, "w") as f:
        f.write(norm_our.stdout)

    norm_prod = subprocess.run(
        ["python3", NORMALIZER, "--function", name, TU_PATH],
        capture_output=True, text=True)
    if norm_prod.returncode != 0:
        r["status"] = "prod_norm_fail"
        results.append(r)
        continue
    with open(prod_norm, "w") as f:
        f.write(norm_prod.stdout)

    diff_res = subprocess.run(
        ["diff", prod_norm, our_norm],
        capture_output=True, text=True)
    r["diff"] = sum(1 for l in diff_res.stdout.splitlines()
                    if l.startswith("<") or l.startswith(">"))
    r["status"] = "ok"
    results.append(r)

# Step 3: report
print(f"\n{'='*72}")
print(f"TU SURVEY: {os.path.basename(TU_PATH)}")
print(f"{'='*72}")

status_counts = {}
for r in results:
    status_counts[r["status"]] = status_counts.get(r["status"], 0) + 1
print(f"\nStatus summary ({len(results)} functions):")
for s in sorted(status_counts.keys()):
    print(f"  {s:<20} {status_counts[s]:>4}")

ok = [r for r in results if r["status"] == "ok"]
if ok:
    print(f"\nDiff bins (for {len(ok)} OK functions):")
    bins = {"0 (byte-match!)": 0, "1-5": 0, "6-20": 0, "21-50": 0,
            "51-200": 0, "200+": 0}
    for r in ok:
        d = r["diff"]
        if d == 0: bins["0 (byte-match!)"] += 1
        elif d <= 5: bins["1-5"] += 1
        elif d <= 20: bins["6-20"] += 1
        elif d <= 50: bins["21-50"] += 1
        elif d <= 200: bins["51-200"] += 1
        else: bins["200+"] += 1
    for k, v in bins.items():
        print(f"  {k:<22} {v:>4}")

    # Top-10 closest, top-10 farthest
    ok_sorted = sorted(ok, key=lambda r: r["diff"])
    print(f"\nClosest to byte-match (top 15):")
    print(f"  {'name':<20} {'ninstr':>6} {'diff':>6}")
    for r in ok_sorted[:15]:
        print(f"  {r['name']:<20} {r['ninstr']:>6} {r['diff']:>6}")
    print(f"\nFarthest from byte-match (top 15):")
    for r in reversed(ok_sorted[-15:]):
        print(f"  {r['name']:<20} {r['ninstr']:>6} {r['diff']:>6}")

# Full detail to file
dash_path = os.path.join(OUT_DIR, "dashboard.md")
with open(dash_path, "w") as f:
    f.write(f"# TU survey: {os.path.basename(TU_PATH)}\n\n")
    f.write(f"- Total functions: {len(results)}\n")
    for s in sorted(status_counts.keys()):
        f.write(f"- {s}: {status_counts[s]}\n")
    f.write("\n## Per-function detail (sorted by diff count)\n\n")
    f.write("| function | ninstr | status | diff | note |\n")
    f.write("|---|---:|---|---:|---|\n")
    # Sort: OK first (by diff), then others
    def keyf(r):
        if r["status"] == "ok": return (0, r["diff"])
        return (1, 0)
    for r in sorted(results, key=keyf):
        d = "—" if r["diff"] is None else str(r["diff"])
        f.write(f"| {r['name']} | {r['ninstr']} | {r['status']} | {d} | {r['note']} |\n")

print(f"\nFull dashboard written to: {dash_path}")
