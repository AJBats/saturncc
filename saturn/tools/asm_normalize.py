#!/usr/bin/env python3
"""
asm_normalize.py — canonical form of one SH-2 function's .s for diffing.

Applied symmetrically to both our compiler output and prod's assembly, two
semantically-equivalent functions produce byte-identical output from this
pass. Any remaining diff is a real divergence (different mnemonic,
register, immediate, addressing mode, or control-flow structure).

Normalization:
  - If the input .s contains multiple functions (an SHC TU file), extract
    only the range for --function=NAME, from `^FUN_NAME:` through the
    line before the next `^FUN_xxxxxxxx:` or `^sub_xxxxxxxx:`.
  - Strip presentation-only directives: .section, .type, .global, .globl,
    .align, .text, .file, .ident.
  - Strip /* ... */ and trailing ! comments.
  - Classify labels as entry (first one), code, or pool (followed by
    .long / .short / .word / .byte / .4byte).
  - Rename labels canonically: entry → bare function name (no leading _);
    code labels → L0, L1, L2, ...; pool labels → LP0, LP1, ....
    Substitution is longest-first to avoid prefix overlap.
  - Convert `sym_XXXXXXXX` symbolic addresses to their decimal numeric
    form (prod uses sym_; ours uses raw numbers — this equates them).
  - Convert 0xNN hex literals to decimal.
  - Rewrite .4byte → .long.
  - Emit each statement as `\tmnemonic\toperands` with all internal
    operand whitespace stripped.

Usage:
    python3 asm_normalize.py --function FUN_06044834 path/to/file.s
"""

import argparse
import re
import sys

DROP_DIR_RE = re.compile(
    r'^\s*\.(section|type|global|globl|align|text|file|ident)\b'
)
LABEL_DEF_RE = re.compile(r'^\s*([._A-Za-z][._A-Za-z0-9]*)\s*:')
POOL_NEXT_RE = re.compile(r'\.(long|short|word|byte|4byte)\b')
ENTRY_RE = re.compile(r'^_?((?:FUN|sub)_[0-9A-Fa-f]+)\s*:')
COMMENT_BLOCK_RE = re.compile(r'/\*.*?\*/', re.DOTALL)


def extract_function(lines, name):
    # Case-insensitive compare: rcc emits lowercase hex in labels, prod
    # uses uppercase. Treat FUN_060440e0 and FUN_060440E0 as the same name.
    target = name.lower()
    start = None
    for i, line in enumerate(lines):
        m = ENTRY_RE.match(line)
        if m and m.group(1).lower() == target:
            start = i
            break
    if start is None:
        return []
    end = len(lines)
    for i in range(start + 1, len(lines)):
        m = ENTRY_RE.match(lines[i])
        if m and m.group(1).lower() != target:
            end = i
            break
    return lines[start:end]


def classify_labels(lines):
    order = []
    first = True
    for i, line in enumerate(lines):
        m = LABEL_DEF_RE.match(line)
        if not m:
            continue
        name = m.group(1)
        if first:
            order.append((name, 'entry'))
            first = False
            continue
        kind = 'code'
        # Same-line suffix after the colon (e.g. `L1: .long ...` — our
        # emitter inlines the pool directive; prod tends to put it on
        # the next line). Check that first.
        same_line_tail = line[m.end():].strip()
        if POOL_NEXT_RE.search(same_line_tail):
            kind = 'pool'
        else:
            for j in range(i + 1, min(i + 5, len(lines))):
                nxt = lines[j].strip()
                if not nxt or nxt.startswith('/*') or nxt.startswith('!'):
                    continue
                if POOL_NEXT_RE.search(nxt):
                    kind = 'pool'
                break
        order.append((name, kind))
    return order


def build_label_map(order, func_name):
    m = {}
    code_n = 0
    pool_n = 0
    for name, kind in order:
        if kind == 'entry':
            m[name] = func_name
        elif kind == 'code':
            m[name] = f'L{code_n}'
            code_n += 1
        else:
            m[name] = f'LP{pool_n}'
            pool_n += 1
    return m


def rewrite(text, label_map):
    # Strip inline /* ... */ comments first.
    text = COMMENT_BLOCK_RE.sub('', text)
    # Replace labels (longest first to avoid prefix collisions).
    # Use lookaround anchors instead of \b: some prod labels start with `.`
    # (e.g. `.L_pool_XXX`), which \b doesn't handle since `.` isn't \w.
    for old in sorted(label_map, key=len, reverse=True):
        text = re.sub(
            r'(?<![.\w])' + re.escape(old) + r'(?![.\w])',
            label_map[old],
            text,
        )
    # Unify Ghidra-assigned symbol prefixes referencing the same address.
    # Prod raw .s mixes DAT_/FUN_/sub_/PTR_FUN_/PTR_SUB_/PTR_DAT_ based on
    # what Ghidra inferred lived at each address; our emitter just uses
    # the C identifier (typically FUN_ or the underscore-prefixed form).
    # All of these resolve to the same address at link time, so collapse
    # them to a canonical sym_<hex> so the diff only sees the address.
    # Leading underscore (rcc's _FUN_xxx emit) is also absorbed.
    text = re.sub(
        r'(?<![.\w])_?(?:DAT|FUN|sub|PTR_FUN|PTR_SUB|PTR_DAT)_([0-9A-Fa-f]+)(?![.\w])',
        lambda m: 'sym_' + m.group(1),
        text,
    )
    # sym_HEX → decimal
    text = re.sub(
        r'\bsym_([0-9A-Fa-f]+)\b',
        lambda m: str(int(m.group(1), 16)),
        text,
    )
    # 0xHEX → decimal
    text = re.sub(
        r'\b0x[0-9A-Fa-f]+\b',
        lambda m: str(int(m.group(0), 16)),
        text,
    )
    # .4byte → .long
    text = re.sub(r'\.4byte\b', '.long', text)
    return text


def normalize(lines, func_name):
    order = classify_labels(lines)
    label_map = build_label_map(order, func_name)
    out = []
    for raw in lines:
        line = raw.rstrip()
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith('/*') and stripped.endswith('*/'):
            continue
        if stripped.startswith('/*') or stripped.startswith('!'):
            continue
        if DROP_DIR_RE.match(line):
            continue

        # Trailing ! comment. SH-2 doesn't use ! in immediates.
        bang = stripped.find('!')
        if bang >= 0:
            stripped = stripped[:bang].rstrip()
            if not stripped:
                continue

        # Label definition (possibly followed by same-line content).
        m = LABEL_DEF_RE.match(stripped)
        if m:
            lname = m.group(1)
            rest = stripped[m.end():].strip()
            canonical = label_map.get(lname, lname)
            if rest:
                rest = rewrite(rest, label_map).strip()
                out.append(f'{canonical}:\t{rest}')
            else:
                out.append(f'{canonical}:')
            continue

        # Directive or instruction.
        stripped = rewrite(stripped, label_map).strip()
        if not stripped:
            continue
        m = re.match(r'^(\S+)\s*(.*)$', stripped)
        if m:
            mnem = m.group(1)
            operands = re.sub(r'\s+', '', m.group(2))
            if operands:
                out.append(f'\t{mnem}\t{operands}')
            else:
                out.append(f'\t{mnem}')
        else:
            out.append(f'\t{stripped}')
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    ap.add_argument('--function', required=True,
                    help='Function name (e.g. FUN_06044834). Used for '
                         'canonical entry label and for extraction from '
                         'TU files containing multiple functions.')
    args = ap.parse_args()

    with open(args.file) as f:
        lines = f.readlines()

    entries = [l for l in lines if ENTRY_RE.match(l)]
    if len(entries) > 1:
        lines = extract_function(lines, args.function)
        if not lines:
            print(
                f'ERROR: {args.function} not found in {args.file}',
                file=sys.stderr,
            )
            sys.exit(1)

    for line in normalize(lines, args.function):
        print(line)


if __name__ == '__main__':
    main()
