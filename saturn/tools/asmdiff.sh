#!/bin/bash
# asmdiff.sh — normalize production .s for VS Code comparison
#
# Usage: bash saturn/tools/asmdiff.sh <function_name>
#   e.g.: bash saturn/tools/asmdiff.sh FUN_06044834
#
# Creates build/cmp/<name>.s with production assembly normalized
# to match our compiler's formatting (whitespace, decimal constants,
# sequential label names).  Then VS Code compare against the real
# file in saturn/experiments/.

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <function_name>"
    echo "  e.g.: $0 FUN_06044834"
    exit 1
fi

NAME="$1"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
DAYTONA="/mnt/d/Projects/DaytonaCCEReverse"
OUTDIR="$REPO/build/cmp"

PROD=$(find "$DAYTONA/src" -name "${NAME}.s" 2>/dev/null | head -1)
if [ -z "$PROD" ] || [ ! -f "$PROD" ]; then
    echo "Production file not found for $NAME in $DAYTONA/src/"
    exit 1
fi

mkdir -p "$OUTDIR"

# Find our file to count its labels for matching numbering
OUR=$(find "$REPO/saturn/experiments" -name "${NAME}.s" 2>/dev/null | head -1)

# Build label map from our file so production gets the SAME numbers
# for corresponding labels (by position in the function).
# Code labels and pool labels are numbered in separate sequences
# to avoid cross-interference from different pool placement.

# Step 1: Read production file, classify labels as code or pool,
#         renumber to match our L<n> / L<n> pool style.
python3 - "$PROD" "$OUTDIR/${NAME}.s" "$NAME" << 'PYEOF'
import sys, re

prod_path = sys.argv[1]
out_path = sys.argv[2]
func_name = sys.argv[3]  # e.g. FUN_06004378

with open(prod_path) as f:
    prod_lines = f.readlines()

# Classify production labels: a label followed by .long/.short/.word/.byte
# on the next non-blank line is a pool label; otherwise it's a code label.
prod_labels = []  # (name, kind) in definition order
label_re = re.compile(r'^[[:space:]]*([._A-Za-z][._A-Za-z0-9]*):')

for i, line in enumerate(prod_lines):
    # Match label definitions
    stripped = line.strip()
    m = re.match(r'^([._A-Za-z][._A-Za-z0-9]*)\s*:', stripped)
    if m:
        lname = m.group(1)
        # Check next non-blank line for pool data
        kind = 'code'
        for j in range(i+1, min(i+3, len(prod_lines))):
            nxt = prod_lines[j].strip()
            if nxt == '':
                continue
            if re.match(r'\.(long|short|word|byte|4byte)', nxt):
                kind = 'pool'
            break
        prod_labels.append((lname, kind))

# Assign sequential numbers: code labels get L0,L1,L2...
# pool labels get their own sequence starting after code labels
# to roughly match our compiler's numbering.
code_num = 1  # L0 is the function entry, L1 is first branch target
pool_num = None  # assigned after we know how many code labels exist
label_map = {}

# Function entry label (first label) -> use function name
func_label = prod_labels[0][0] if prod_labels else None

code_labels = [(n,k) for n,k in prod_labels if k == 'code']
pool_labels = [(n,k) for n,k in prod_labels if k == 'pool']

# Read our file's labels to build a position-matched mapping
our_code_labels = []
our_pool_labels = []
our_path = None
# Find our file
import glob
for pattern in [
    prod_path.replace(prod_path, ''),  # dummy
]:
    pass
import os
repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(out_path))))
for root, dirs, files in os.walk(os.path.join(repo, 'saturn', 'experiments')):
    for fn in files:
        if fn == func_name + '.s':
            our_path = os.path.join(root, fn)
            break

if our_path and os.path.exists(our_path):
    with open(our_path) as f:
        our_lines = f.readlines()
    for i, line in enumerate(our_lines):
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):\s*$', line.strip())
        if m:
            lname = m.group(1)
            if lname.startswith('_'):  # function entry
                continue
            # Check if next non-blank line is pool data
            is_pool = False
            for j in range(i+1, min(i+3, len(our_lines))):
                nxt = our_lines[j].strip()
                if nxt == '':
                    continue
                if re.match(r'\.(long|short|word|byte)', nxt):
                    is_pool = True
                break
            if is_pool:
                our_pool_labels.append(lname)
            else:
                our_code_labels.append(lname)

# Map function entry
if func_label:
    label_map[func_label] = '_' + func_name

# Map code labels by position: prod's 1st code label -> our 1st, etc.
for idx, (name, kind) in enumerate(code_labels[1:]):  # skip entry
    if idx < len(our_code_labels):
        label_map[name] = our_code_labels[idx]
    else:
        label_map[name] = 'L' + str(100 + idx)  # fallback

# Map pool labels by position
for idx, (name, kind) in enumerate(pool_labels):
    if idx < len(our_pool_labels):
        label_map[name] = our_pool_labels[idx]
    else:
        label_map[name] = 'LP' + str(idx)

# Now process the file: normalize whitespace, hex->decimal, apply label map
def replace_labels(text):
    # Sort by length descending to avoid partial matches
    for old in sorted(label_map.keys(), key=len, reverse=True):
        text = text.replace(old, label_map[old])
    return text

def hex_to_dec(text):
    def repl(m):
        return str(int(m.group(0), 16))
    return re.sub(r'0x[0-9A-Fa-f]+', repl, text)

out = []
for line in prod_lines:
    stripped = line.strip()

    # Blank lines
    if stripped == '':
        out.append('')
        continue

    # Comment lines
    if stripped.startswith('/*'):
        continue

    # Label definitions
    m = re.match(r'^[[:space:]]*([._A-Za-z][._A-Za-z0-9]*)\s*:(.*)', stripped)
    if m:
        lname = m.group(1)
        rest = m.group(2).strip()
        new_label = label_map.get(lname, lname)
        if rest:
            rest = replace_labels(rest)
            rest = hex_to_dec(rest)
            rest = re.sub(r'\.4byte', '.long', rest)
            out.append(new_label + ':\t' + rest)
        else:
            out.append(new_label + ':')
        continue

    # Skip directives (section, type, global, align — our file has its own)
    if re.match(r'\.(section|type|global|align|text)', stripped):
        continue

    # Data directives (keep: .long, .short, .word, .byte)
    if stripped.startswith('.'):
        d = replace_labels(stripped)
        d = hex_to_dec(d)
        d = re.sub(r'\.4byte', '.long', d)
        out.append('\t' + d)
        continue

    # Instructions: normalize whitespace and format
    m = re.match(r'^([a-z._/]+)\s*(.*)', stripped)
    if m:
        mnem = m.group(1)
        operands = m.group(2)
        # Strip all whitespace from operands
        operands = re.sub(r'\s+', '', operands)
        # Replace labels in operands
        operands = replace_labels(operands)
        # Hex to decimal
        operands = hex_to_dec(operands)
        out.append('\t' + mnem + ('\t' + operands if operands else ''))
    else:
        out.append(stripped)

with open(out_path, 'w', newline='\n') as f:
    for line in out:
        f.write(line + '\n')
PYEOF

echo "Created: build/cmp/${NAME}.s"
echo ""
if [ -n "$OUR" ]; then
    OUR_REL="${OUR#$REPO/}"
    echo "Compare in VS Code:"
    echo "  $OUR_REL"
    echo "  build/cmp/${NAME}.s"
fi
