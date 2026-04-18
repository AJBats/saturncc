#!/usr/bin/env python3
"""Survey race-module TU files for feature richness.

Outputs a ranked list with function count, total instruction count,
pool complexity, and feature markers (loops, switches, calls, unusual
mnemonics). Bigger + more varied = better proof-of-methodology target.

Also flags which of our 10 current corpus functions (ones with pinned
tier-1 baselines) live in each TU.
"""
import os, re, glob, sys
from collections import Counter

RACE_SRC = "/mnt/d/Projects/DaytonaCCEReverse/src/race"

CORPUS = {
    "FUN_00280710", "FUN_06000AF8", "FUN_06044834", "FUN_06047748",
    "FUN_0604025C", "FUN_06004378", "FUN_0602A664", "FUN_06040EA0",
    "FUN_06044BCC", "FUN_06037E28",
}

# Feature markers — each presence adds diversity value.
FEATURES = {
    "calls":       re.compile(r"\bjsr\s+@"),
    "switch":      re.compile(r"\bbraf\s+"),
    "loops":       re.compile(r"\b(bt|bf|bra)\s+\.L_[0-9a-f]+"),
    "macl":        re.compile(r"\b(mul(s|u)?\.(w|l)|mac\.(w|l)|dmul(s|u)\.l|sts\s+macl|lds\s+macl)\b"),
    "shift":       re.compile(r"\b(shl[lr][0-9]*|sha[lr])\b"),
    "gbr":         re.compile(r"@\([^,)]+,\s*gbr\)"),
    "dispb":       re.compile(r"mov\.b\s+@\([0-9xA-Fa-f]+,"),
    "dispw":       re.compile(r"mov\.w\s+@\([0-9xA-Fa-f]+,"),
    "displ":       re.compile(r"mov\.l\s+@\([0-9xA-Fa-f]+,"),
    "indexed":     re.compile(r"@\(r0,\s*r[0-9]+\)"),
    "postinc":     re.compile(r"@r[0-9]+\+"),
    "predec":      re.compile(r"@-r[0-9]+"),
    "fpreg":       re.compile(r"\br14\b"),
    "multirts":    re.compile(r"^\s*rts\b"),
    "asm_nop":     re.compile(r"^\s*nop\s*$"),
}

func_pat = re.compile(r"^FUN_([0-9a-fA-F]+):", re.MULTILINE)
instr_pat = re.compile(r"^\s+[a-zA-Z]")

results = []

for path in sorted(glob.glob(os.path.join(RACE_SRC, "*.s"))):
    with open(path) as f:
        text = f.read()
    lines = text.splitlines()
    funcs = func_pat.findall(text)
    nfuncs = len(funcs)
    if nfuncs == 0:
        continue
    ninstr = sum(1 for l in lines if instr_pat.match(l) and ":" not in l.split(";")[0][:20] and not l.strip().startswith("."))
    corpus_hit = [f"FUN_{n}" for n in funcs if f"FUN_{n}" in CORPUS]
    feature_counts = {k: len(v.findall(text)) for k, v in FEATURES.items()}
    feature_diversity = sum(1 for v in feature_counts.values() if v > 0)
    # Also count rts — multi-return functions matter
    nrts = feature_counts.get("multirts", 0)
    # Pool entries (rough)
    pool_lines = sum(1 for l in lines if ".long" in l or ".short" in l or ".byte" in l)
    results.append({
        "name": os.path.basename(path),
        "funcs": nfuncs,
        "instrs": ninstr,
        "pool": pool_lines,
        "features": feature_diversity,
        "corpus": corpus_hit,
        "fc": feature_counts,
    })

# Sort by richness: combined score of function count, instruction count,
# feature diversity. Not just size — a 1-function 2000-line monster is
# less generalizable than a 10-function 1500-line assortment.
def score(r):
    return (r["features"] * 50) + (r["funcs"] * 30) + r["instrs"]

results.sort(key=score, reverse=True)

# Print top 15
print(f"{'TU file':<28} {'funcs':>6} {'instrs':>7} {'pool':>5} {'feat/15':>8} {'corpus_hits':<40} score")
print("-" * 120)
for r in results[:15]:
    corpus_str = ",".join(r["corpus"])[:38] if r["corpus"] else ""
    print(f"{r['name']:<28} {r['funcs']:>6} {r['instrs']:>7} {r['pool']:>5} {r['features']:>5}/15 {corpus_str:<40} {score(r)}")

print()
print("=== Feature breakdown for top 5 ===")
for r in results[:5]:
    print(f"\n{r['name']}:")
    for k, v in sorted(r["fc"].items(), key=lambda kv: -kv[1]):
        if v > 0:
            print(f"    {k:<12} {v}")
