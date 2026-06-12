#!/usr/bin/env python3
"""pool_graph_probe.py — find cross-function pool sharing (Case C) in unity race.s.

Ground truth, no heuristics:
  - Function boundaries come from the yaml subsegment map (the authoritative
    ~850-function boundary set), NOT the sparse .global FUN_ labels in the asm.
  - Every .L_pool_XXXXXXXX label carries its physical address in its name.
  - Every PC-relative load names the pool label it reads, and we know which
    subsegment (function) the load instruction lives in by tracking address.

Case C landmine: a pool word physically located inside function X's byte range,
referenced by a load instruction inside a different function Y. Delete X and Y
reads garbage. That is the silent-crash class saturncc exists to make loud.

Usage: python pool_graph_probe.py [race.s] [race.bin.yaml]
"""
import re
import sys
import bisect
from collections import defaultdict

POOLDEF_RE = re.compile(r'^(\.L_pool_([0-9A-Fa-f]{8})):')
POOLREF_RE = re.compile(r'\.L_pool_([0-9A-Fa-f]{8})')
# track current physical address from address-bearing labels in the asm:
#   FUN_06028000:  /  .L_06028B12:  /  .L_pool_06028AE4:
ADDR_LABEL_RE = re.compile(r'^(?:FUN_|\.L_(?:pool_)?)([0-9A-Fa-f]{8}):')
YAML_SUB_RE = re.compile(r'start:\s*0x([0-9A-Fa-f]+)')
YAML_END_RE = re.compile(r'end:\s*0x([0-9A-Fa-f]+)')
YAML_TYPE_RE = re.compile(r'type:\s*(\w+)')


def load_yaml_funcs(path):
    """Return sorted list of (start, end, type) subsegments."""
    subs = []
    cur = {}
    for line in open(path, encoding='utf-8', errors='replace'):
        m = YAML_SUB_RE.search(line)
        if m:
            if cur.get('start') is not None:
                subs.append(cur)
            cur = {'start': int(m.group(1), 16), 'end': None, 'type': None}
            continue
        m = YAML_END_RE.search(line)
        if m and cur:
            cur['end'] = int(m.group(1), 16)
        m = YAML_TYPE_RE.search(line)
        if m and cur:
            cur['type'] = m.group(1)
    if cur.get('start') is not None:
        subs.append(cur)
    subs.sort(key=lambda s: s['start'])
    return subs


def main(asm_path, yaml_path):
    subs = load_yaml_funcs(yaml_path)
    starts = [s['start'] for s in subs]
    code_subs = sum(1 for s in subs if s['type'] == 'code')

    def home(addr):
        """Which subsegment (function) physically contains addr."""
        i = bisect.bisect_right(starts, addr) - 1
        if i < 0:
            return None
        s = subs[i]
        if s['end'] is not None and addr > s['end']:
            return None
        return s['start']

    # Walk asm tracking the current physical address from address-bearing labels.
    cur_addr = None
    refs = []          # (pool_word_addr, load_instruction_addr)
    pool_locations = {}  # pool_word_addr -> its own physical addr (== name)

    for line in open(asm_path, encoding='utf-8', errors='replace'):
        s = line.strip()
        m = ADDR_LABEL_RE.match(s)
        if m:
            cur_addr = int(m.group(1), 16)
            pm = POOLDEF_RE.match(s)
            if pm:
                pool_locations[int(pm.group(2), 16)] = int(pm.group(2), 16)
            continue
        # a load referencing a pool word — attribute to current address's function
        for pm in POOLREF_RE.finditer(s):
            paddr = int(pm.group(1), 16)
            refs.append((paddr, cur_addr))

    # Build {pool_word -> set of home-functions of its referencing loads}
    ref_homes = defaultdict(set)
    ref_count = defaultdict(int)
    for paddr, laddr in refs:
        if laddr is None:
            continue
        ref_homes[paddr].add(home(laddr))
        ref_count[paddr] += 1

    shared = []
    private = 0
    for paddr, loader_homes in ref_homes.items():
        word_home = home(paddr)
        cross = {h for h in loader_homes if h != word_home}
        if cross:
            shared.append((paddr, word_home, sorted(h for h in loader_homes if h is not None)))
        else:
            private += 1

    print(f"yaml subsegments:        {len(subs)} ({code_subs} code)")
    print(f"distinct pool words ref'd:{len(ref_homes)}")
    print(f"private pool words:      {private}")
    print(f"CROSS-FUNCTION pool words (Case C/D landmines): {len(shared)}")
    print()
    print("Sample (pool word @ physical addr | home function | loaded by):")
    for paddr, whome, loaders in sorted(shared)[:30]:
        wh = f"FUN_{whome:08X}" if whome is not None else "(unmapped)"
        ld = ', '.join(f"FUN_{h:08X}" for h in loaders)
        print(f"  0x{paddr:08X}  home={wh}  loaded by: {ld}")


if __name__ == '__main__':
    asm = sys.argv[1] if len(sys.argv) > 1 else 'D:/Projects/DaytonaCCEReverse/asm/race/race.s'
    yml = sys.argv[2] if len(sys.argv) > 2 else 'D:/Projects/DaytonaCCEReverse/config/race.bin.yaml'
    main(asm, yml)
