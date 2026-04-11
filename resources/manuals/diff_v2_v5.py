#!/usr/bin/env python3
"""Structural diff of v2.0 vs v5.0 Hitachi SH C compiler manuals.

Extracts option tables, intrinsic function lists, interrupt pragma syntax,
calling convention details, and section handling to surface documented
behavior changes that would bracket v3.x and v4.x behavior.
"""
import re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

V2 = r"D:\Projects\SaturnCompiler\resources\manuals\hitachi_shc_v2.0_fulltext.txt"
V5 = r"D:\Projects\SaturnCompiler\resources\manuals\hitachi_shc_v5.0_fulltext.txt"

with open(V2, encoding='utf-8', errors='replace') as f: v2 = f.read()
with open(V5, encoding='utf-8', errors='replace') as f: v5 = f.read()

print(f"v2.0: {len(v2):,} chars")
print(f"v5.0: {len(v5):,} chars")
print()

# --- Compiler options (flag table) ---
def extract_options(text):
    """Find all -option / -option= references."""
    opts = set()
    for m in re.finditer(r"(?<![a-zA-Z])-([a-zA-Z][a-zA-Z0-9_]*)\s*(?:=|\s|,|$)", text):
        name = m.group(1).lower()
        if 3 <= len(name) <= 20:
            opts.add(name)
    return opts

v2_opts = extract_options(v2)
v5_opts = extract_options(v5)

# Filter known non-option noise
noise = {'version','note','only','this','that','does','make','from','code','then','with','also','when','where','what','such','some','used','will','have','been','each','etc','and','for','the','not','all','can','its','may','any','own','one','two','use','are','see','new','end','out','ref','per','set','get','add','sub','div','mul','mov','jmp','bra','bsr','rts','rte','sh1','sh2','sh3','one','two','etc','err','low','max','min','reg','arg','dll','lib','src','obj','asm'}
v2_opts -= noise
v5_opts -= noise

# Find intentional SHC flags from our Sega .SHC files
known_flags = {'cpu','optimize','opt','string','section','div','include','define','def','show','listfile','nolistfile','objectfile','code','debug','nodebug','help','macsave','pic','endian','double','comment','abs16','align16','align','inline','noinline','speed','nospeed','size','loop','noloop','rtnext','nortnext','sp','st','op','se','i','cp'}

print("=" * 70)
print("COMPILER OPTIONS DIFF")
print("=" * 70)
v2_known = v2_opts & known_flags
v5_known = v5_opts & known_flags
print(f"\nOptions in v2.0 (known): {sorted(v2_known)}")
print(f"\nOptions in v5.0 (known): {sorted(v5_known)}")
print(f"\nNew in v5.0 (not in v2.0): {sorted(v5_known - v2_known)}")
print(f"\nRemoved from v2.0 (not in v5.0): {sorted(v2_known - v5_known)}")

# --- Intrinsic functions ---
print("\n" + "=" * 70)
print("INTRINSIC FUNCTIONS DIFF")
print("=" * 70)
intrinsics_pat = re.compile(r"\b(set_cr|get_cr|set_imask|get_imask|set_vbr|get_vbr|set_gbr|get_gbr|gbr_read_byte|gbr_read_word|gbr_read_long|gbr_write_byte|gbr_write_word|gbr_write_long|gbr_and_byte|gbr_or_byte|gbr_xor_byte|gbr_tst_byte|sleep|tas|trapa|set_fpscr|get_fpscr|set_fpul|get_fpul|macl|mach|end_of_module|set_prc_reg|swapb|swapw|xtrct)\b")
v2_intrin = set(intrinsics_pat.findall(v2))
v5_intrin = set(intrinsics_pat.findall(v5))
print(f"v2.0 intrinsics: {sorted(v2_intrin)}")
print(f"v5.0 intrinsics: {sorted(v5_intrin)}")
print(f"NEW in v5.0: {sorted(v5_intrin - v2_intrin)}")
print(f"REMOVED: {sorted(v2_intrin - v5_intrin)}")

# --- #pragma directives ---
print("\n" + "=" * 70)
print("#PRAGMA DIRECTIVES DIFF")
print("=" * 70)
pragma_pat = re.compile(r"#pragma\s+(\w+)")
v2_pragmas = set(m.lower() for m in pragma_pat.findall(v2))
v5_pragmas = set(m.lower() for m in pragma_pat.findall(v5))
print(f"v2.0 #pragmas: {sorted(v2_pragmas)}")
print(f"v5.0 #pragmas: {sorted(v5_pragmas)}")
print(f"NEW in v5.0: {sorted(v5_pragmas - v2_pragmas)}")
print(f"REMOVED: {sorted(v2_pragmas - v5_pragmas)}")

# --- CPU coverage ---
print("\n" + "=" * 70)
print("CPU COVERAGE DIFF")
print("=" * 70)
cpu_pat = re.compile(r"\bSH[1-4][EA-Z]?\b")
v2_cpus = sorted(set(cpu_pat.findall(v2)))
v5_cpus = sorted(set(cpu_pat.findall(v5)))
print(f"v2.0 CPUs mentioned: {v2_cpus}")
print(f"v5.0 CPUs mentioned: {v5_cpus}")

# --- TOC comparison ---
print("\n" + "=" * 70)
print("TABLE OF CONTENTS ('Section' headings)")
print("=" * 70)
section_pat = re.compile(r"(Section\s+\d+(?:\.\d+)*\s+[A-Z][^.\n]{5,60}?)(?:\.{2,}|\s+\d+$|\n)", re.M)
v2_sections = set(s.strip() for s in section_pat.findall(v2[:20000]))  # TOC usually at front
v5_sections = set(s.strip() for s in section_pat.findall(v5[:20000]))
print(f"\nv2.0 sections ({len(v2_sections)}):")
for s in sorted(v2_sections)[:40]: print(f"  {s}")
print(f"\nv5.0 sections ({len(v5_sections)}):")
for s in sorted(v5_sections)[:40]: print(f"  {s}")

# --- Error code ranges ---
print("\n" + "=" * 70)
print("ERROR CODE RANGES")
print("=" * 70)
err_pat = re.compile(r"\b([1-9]\d{3})\s+(?:\(W\)|\(E\)|\(F\))")
v2_errs = set(int(m) for m in err_pat.findall(v2))
v5_errs = set(int(m) for m in err_pat.findall(v5))
if v2_errs:
    print(f"v2.0 error codes: {len(v2_errs)} codes, range {min(v2_errs)}-{max(v2_errs)}")
if v5_errs:
    print(f"v5.0 error codes: {len(v5_errs)} codes, range {min(v5_errs)}-{max(v5_errs)}")
print(f"New codes in v5.0: {sorted(v5_errs - v2_errs)[:20]}")

# --- Look for explicit version markers ---
print("\n" + "=" * 70)
print("VERSION MARKERS")
print("=" * 70)
for label, text in [("v2.0", v2), ("v5.0", v5)]:
    vers = set(re.findall(r"Ver\.?\s*\d+\.\d+", text))
    dates = set(re.findall(r"(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+\d{4}", text))
    print(f"{label}: Versions={sorted(vers)}, Dates={sorted(dates)[:8]}")
