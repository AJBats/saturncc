#!/usr/bin/env python3
"""Extract text from the v2.0 manual for diff comparison against v5.0."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from pypdf import PdfReader

V2_PDF = r"D:\Projects\SaturnCompiler\resources\manuals\hitachi_shc_v2.0_1995-03_HS0700CLCU1SE.pdf"
V2_OUT = r"D:\Projects\SaturnCompiler\resources\manuals\hitachi_shc_v2.0_fulltext.txt"

r = PdfReader(V2_PDF)
print(f"Pages: {len(r.pages)}")

full = ""
for i in range(len(r.pages)):
    full += f"\n===PAGE {i+1}===\n" + (r.pages[i].extract_text() or "")

with open(V2_OUT, "w", encoding="utf-8", errors="replace") as f:
    f.write(full)
print(f"Wrote {len(full):,} chars to {V2_OUT}")
