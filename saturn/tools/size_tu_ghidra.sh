#!/bin/bash
set -eu
cd "$(dirname "$0")/../.."

TU_PATH=/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s
GR=/mnt/d/Projects/DaytonaCCEReverse/ghidra_reference/race
total=0
missing=0

while read fn; do
    if [ -f "$GR/$fn.c" ]; then
        lines=$(wc -l < "$GR/$fn.c")
        total=$((total + lines))
    else
        missing=$((missing + 1))
    fi
done < <(python3 saturn/tools/list_tu_functions.py "$TU_PATH")

echo "Total lines across all Ghidra .c for this TU: $total"
echo "Functions missing Ghidra .c: $missing"
