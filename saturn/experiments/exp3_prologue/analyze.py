#!/usr/bin/env python3
"""Experiment 3: Prologue/epilogue fingerprint analysis.

For every race-module function, extract the first ~5 instructions and bucket.
Check if GBR-using files use a different prologue shape than non-GBR files.
"""
import os, re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

RACE = r"D:\Projects\DaytonaCCEReverse\src\race"

func_label = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):\s*$", re.M)
gbr_pat = re.compile(r"mov\.[bwl]\s+[^,\n]*@\(\s*\d+\s*,\s*gbr\b", re.I)

files = sorted(f for f in os.listdir(RACE) if f.endswith('.s'))

funcs = []
for f in files:
    path = os.path.join(RACE, f)
    with open(path, encoding='utf-8', errors='replace') as fp:
        text = fp.read()
    lines = text.split('\n')
    gbr_count = len(gbr_pat.findall(text))

    for i, line in enumerate(lines):
        m = func_label.match(line)
        if not m: continue
        name = m.group(1)
        if not name.startswith('FUN_'): continue

        prologue = []
        j = i + 1
        while j < len(lines) and len(prologue) < 5:
            ll = lines[j].strip()
            if not ll or ll.startswith(';') or ll.startswith('.') or ':' in ll:
                j += 1
                continue
            toks = ll.split(None, 1)
            if toks:
                op = toks[0].lower()
                if len(toks) > 1:
                    prologue.append(f"{op} {toks[1]}")
                else:
                    prologue.append(op)
            j += 1
        if prologue:
            funcs.append({
                'file': f,
                'name': name,
                'prologue': tuple(prologue),
                'gbr_count': gbr_count,
            })

print(f"Analyzed {len(funcs)} functions in {len(files)} files\n")

from collections import Counter
first_inst = Counter(f['prologue'][0] if f['prologue'] else '' for f in funcs)
print("Top 15 first-instruction patterns:")
for inst, count in first_inst.most_common(15):
    print(f"  {count:4d}x  {inst}")

print("\nTop 20 first-THREE-instruction patterns (prologue fingerprints):")
fp3 = Counter(tuple(f['prologue'][:3]) for f in funcs if len(f['prologue']) >= 3)
for fp, count in fp3.most_common(20):
    print(f"\n  {count:4d}x:")
    for line in fp:
        print(f"        {line}")

print("\n" + "=" * 60)
print("PROLOGUE PATTERN vs GBR USAGE")
print("=" * 60)
gbr_files = set(f['file'] for f in funcs if f['gbr_count'] > 0)
print(f"Files with GBR usage: {len(gbr_files)}")

gbr_first = Counter()
nongbr_first = Counter()
for f in funcs:
    if not f['prologue']: continue
    if f['file'] in gbr_files:
        gbr_first[f['prologue'][0]] += 1
    else:
        nongbr_first[f['prologue'][0]] += 1

print(f"\nTop 10 first-instructions in GBR-using files ({sum(gbr_first.values())} funcs):")
for inst, count in gbr_first.most_common(10):
    print(f"  {count:4d}x  {inst}")

print(f"\nTop 10 first-instructions in non-GBR files ({sum(nongbr_first.values())} funcs):")
for inst, count in nongbr_first.most_common(10):
    print(f"  {count:4d}x  {inst}")
