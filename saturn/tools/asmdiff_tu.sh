#!/bin/bash
# asmdiff_tu.sh — per-function side-by-side for a TU-compiled function
#
# Usage: wsl bash saturn/tools/asmdiff_tu.sh <tu_dir> <function_name>
#   e.g.: wsl bash saturn/tools/asmdiff_tu.sh race_FUN_06044060 FUN_06044060
#
# Compiles the TU once, then emits two normalized files for VS Code
# side-by-side comparison:
#   build/cmp/<name>.prod.s  — production slice, normalized
#   build/cmp/<name>.our.s   — our slice, normalized
#
# Normalization via saturn/tools/asm_normalize.py (same pipeline as
# validate_byte_match_tu.sh), so what you see here is exactly what the
# diff count measures.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
RCC="$REPO/build/rcc"
NORMALIZE="$SCRIPT_DIR/asm_normalize.py"
PROD_SRC="${DAYTONA_SRC:-/mnt/d/Projects/DaytonaCCEReverse/src}"
OUTDIR="$REPO/build/cmp"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <tu_dir> <function_name>" >&2
    echo "  e.g.: $0 race_FUN_06044060 FUN_06044060" >&2
    exit 2
fi

TU_DIR="$1"
FUN="$2"

TU_PATH="$REPO/saturn/experiments/daytona_byte_match/$TU_DIR"
TU_C=$(find "$TU_PATH" -maxdepth 1 -name "FUN_*.c" | head -n1)
if [ -z "$TU_C" ]; then
    echo "ERROR: no FUN_*.c in $TU_PATH" >&2
    exit 2
fi
TU_NAME=$(basename "$TU_C" .c)
PROD_S=$(find "$PROD_SRC" -maxdepth 3 -name "${TU_NAME}.s" -print -quit 2>/dev/null)
if [ -z "$PROD_S" ]; then
    echo "ERROR: prod TU .s not found for $TU_NAME" >&2
    exit 2
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cpp -P "$TU_C" > "$TMPDIR/tu.pp.c"
"$RCC" -target=sh/hitachi "$TMPDIR/tu.pp.c" "$TMPDIR/tu.s"

mkdir -p "$OUTDIR"
python3 "$NORMALIZE" --function "$FUN" "$PROD_S"     > "$OUTDIR/${FUN}.prod.s"
python3 "$NORMALIZE" --function "$FUN" "$TMPDIR/tu.s" > "$OUTDIR/${FUN}.our.s"

diff_count=$(diff "$OUTDIR/${FUN}.prod.s" "$OUTDIR/${FUN}.our.s" | grep -c '^[<>]' || true)

echo "Created:"
echo "  build/cmp/${FUN}.prod.s"
echo "  build/cmp/${FUN}.our.s"
echo ""
echo "Diff lines: $diff_count"
echo ""
echo "Compare in VS Code:"
echo "  build/cmp/${FUN}.prod.s"
echo "  build/cmp/${FUN}.our.s"
