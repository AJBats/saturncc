#!/usr/bin/env python3
"""Experiment 2: TU-grouped addressing-mode ratio analysis.

Compute per-file ratio of indexed vs displacement addressing for mov.b/.w/.l
in the race module. If per-file ratios cluster bimodally (some files always
one style, some files always the other), that suggests different TUs were
compiled differently. If unimodal, single compiler with per-reference heuristic.
"""
import os, re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

RACE = r"D:\Projects\DaytonaCCEReverse\src\race"

indexed_pat = re.compile(r"\bmov\.([bwl])\s+[^,\n]*@\(r0\s*,", re.I)
disp_pat = re.compile(r"\bmov\.([bwl])\s+[^,\n]*@\(\s*(\d+)\s*,\s*r\d+", re.I)
gbr_pat = re.compile(r"\bmov\.([bwl])\s+[^,\n]*@\(\s*\d+\s*,\s*gbr\b", re.I)
ldc_gbr = re.compile(r"\b(ldc|stc)[^,\n]*gbr\b", re.I)

files = sorted(f for f in os.listdir(RACE) if f.endswith('.s'))
print(f"Analyzing {len(files)} files in race module\n")

rows = []
for f in files:
    path = os.path.join(RACE, f)
    with open(path, encoding='utf-8', errors='replace') as fp:
        text = fp.read()
    indexed = {'b': 0, 'w': 0, 'l': 0}
    disp = {'b': 0, 'w': 0, 'l': 0}
    for m in indexed_pat.finditer(text):
        indexed[m.group(1).lower()] += 1
    for m in disp_pat.finditer(text):
        disp[m.group(1).lower()] += 1
    gbr_count = len(gbr_pat.findall(text))
    gbr_control = len(ldc_gbr.findall(text))
    total_idx = sum(indexed.values())
    total_disp = sum(disp.values())
    total_mov = total_idx + total_disp
    if total_mov == 0:
        continue
    idx_ratio = total_idx / total_mov
    rows.append({
        'file': f,
        'idx': total_idx,
        'disp': total_disp,
        'idx_ratio': idx_ratio,
        'gbr': gbr_count,
        'gbr_ctl': gbr_control,
    })

print(f"{len(rows)} files had at least one mov.b/w/l load/store\n")

buckets = [0] * 11
for r in rows:
    b = min(10, int(r['idx_ratio'] * 10))
    buckets[b] += 1

print("Histogram of indexed-mode ratio per file (% of mov.b/w/l that use @(r0,Rn)):")
max_b = max(buckets)
for i, c in enumerate(buckets):
    lo = i * 10
    hi = (i + 1) * 10
    bar = "#" * int(c * 50 / max(1, max_b))
    print(f"  {lo:3d}-{hi:3d}% | {c:3d} files | {bar}")

rows.sort(key=lambda r: r['idx_ratio'])
print("\nTop 10 most DISPLACEMENT-heavy files (lowest indexed ratio):")
for r in rows[:10]:
    print(f"  {r['file']:28s}  idx={r['idx']:3d}  disp={r['disp']:3d}  "
          f"ratio={r['idx_ratio']:.2f}  gbr={r['gbr']:3d}")

print("\nTop 10 most INDEXED-heavy files (highest indexed ratio):")
for r in rows[-10:]:
    print(f"  {r['file']:28s}  idx={r['idx']:3d}  disp={r['disp']:3d}  "
          f"ratio={r['idx_ratio']:.2f}  gbr={r['gbr']:3d}")

print("\n" + "=" * 60)
print("GBR USAGE BY FILE")
print("=" * 60)
gbr_files = [r for r in rows if r['gbr'] > 0]
no_gbr_files = [r for r in rows if r['gbr'] == 0]
print(f"Files WITH mov.? @(disp,gbr): {len(gbr_files)}")
print(f"Files WITHOUT mov.? @(disp,gbr): {len(no_gbr_files)}")
if gbr_files:
    print(f"\nFiles with heaviest GBR usage:")
    for r in sorted(gbr_files, key=lambda x: -x['gbr'])[:15]:
        print(f"  {r['file']:28s}  gbr_loads={r['gbr']:4d}  gbr_ctl={r['gbr_ctl']:2d}  "
              f"idx_ratio={r['idx_ratio']:.2f}")

if gbr_files and no_gbr_files:
    gbr_avg_ratio = sum(r['idx_ratio'] for r in gbr_files) / len(gbr_files)
    no_gbr_avg_ratio = sum(r['idx_ratio'] for r in no_gbr_files) / len(no_gbr_files)
    print(f"\nAvg indexed-ratio, GBR-using files:     {gbr_avg_ratio:.3f}")
    print(f"Avg indexed-ratio, non-GBR files:       {no_gbr_avg_ratio:.3f}")
    print(f"Difference: {gbr_avg_ratio - no_gbr_avg_ratio:+.3f}")
