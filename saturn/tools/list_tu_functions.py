#!/usr/bin/env python3
"""List all FUN_ names in a TU .s file, in the order they appear.
Used to generate the TODO list for TU sanitization work."""
import re, sys
if len(sys.argv) != 2:
    print("usage: list_tu_functions.py <tu.s>", file=sys.stderr); sys.exit(1)
with open(sys.argv[1]) as f:
    text = f.read()
for m in re.finditer(r'^(FUN_[0-9a-fA-F]+):', text, re.MULTILINE):
    print(m.group(1))
