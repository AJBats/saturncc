#!/usr/bin/env python3
"""Count low-first vs high-first allocation across the prod corpus.

Signal: lowest register saved at prologue. Under SHC's contiguous
[lowest_dirty..r14] rule, lowest_saved == lowest_dirtied. So counting
the distribution of lowest_saved across FULL_RANGE functions tells us
which allocator direction is dominant.

Low-first (lowest ≤ r10): allocator picked r8 / r9 / r10 as first
  variable home. That pushes the save range down low (lots to save).
High-first (lowest ≥ r12): allocator picked r12 / r13 / r14 as first
  home. Save range stays tight to r14 (few regs saved).
"""
from collections import Counter
from pathlib import Path
import sys

# Reuse the TU scanner
sys.path.insert(0, str(Path(__file__).parent))
from classify_save_matrix import scan_file, PROD_ROOT

counts = Counter()
total = 0

for mod in sorted(p for p in PROD_ROOT.iterdir() if p.is_dir()):
    for s_file in sorted(mod.glob("*.s")):
        for feats in scan_file(s_file):
            if feats["bucket"] == "FULL_RANGE" and feats["save_order"]:
                counts[min(feats["save_order"])] += 1
                total += 1

print(f"FULL_RANGE functions (non-empty save set): {total}")
print()
print("Lowest saved register  |  count  |  share")
print("------------------------------------------")
for reg in range(8, 15):
    c = counts.get(reg, 0)
    pct = 100.0 * c / total if total else 0.0
    bar = "#" * int(pct / 2)
    print(f"  r{reg:<2}                  {c:6d}   {pct:5.1f}%  {bar}")

low_first = sum(counts.get(r, 0) for r in range(8, 11))
high_first = sum(counts.get(r, 0) for r in range(12, 15))
middle = counts.get(11, 0)
print()
print("Direction summary:")
print(f"  low-first-ish  (lowest ≤ r10): {low_first:5d}  "
      f"({100.0*low_first/total:.1f}%)")
print(f"  middle         (lowest == r11): {middle:5d}  "
      f"({100.0*middle/total:.1f}%)")
print(f"  high-first-ish (lowest ≥ r12): {high_first:5d}  "
      f"({100.0*high_first/total:.1f}%)")
