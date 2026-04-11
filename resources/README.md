# Resources

Everything useful we've pulled together for the compiler-matching effort, in one self-contained tree. If a file is in here, it's because we thought we might depend on it later.

**Why this directory exists**: the compiler hunt (see [../workstreams/current_state_of_research.md](../workstreams/current_state_of_research.md)) concluded that no existing compiler produces byte-matching code for Daytona USA CCE. The project is pivoting to **build our own byte-matching compiler**. The documents and binaries in here are the reference material we'll use to drive that build: specifications, evidence of compiler behavior, Sega's actual flag conventions, and a runnable (if wrong-version) reference compiler.

---

## [manuals/](manuals/)

Hitachi SH-series documentation. Two C compiler manuals from different eras, plus the CPU and library references.

| File | Document ID | Date | What it is |
|---|---|---|---|
| [hitachi_shc_v2.0_1995-03_HS0700CLCU1SE.pdf](manuals/hitachi_shc_v2.0_1995-03_HS0700CLCU1SE.pdf) | HS0700CLCU1SE / ADE-702-095 | Mar 1995 | **SH Series C Compiler User's Manual, 1st ed English, documenting Ver. 2.0.** Sourced from the 1996-03 DTS CD `DOCUMENT/HITACHI/SHCCOMP.PDF`. Covers SH1/SH2. This is the closest-in-time spec we have to Daytona CCE's build (Aug 1996). Bit field ordering, calling convention, struct alignment, section naming, interrupt/intrinsic semantics all come from here. |
| [hitachi_shc_v5.0_1997-03_HS0700CLCU4S.pdf](manuals/hitachi_shc_v5.0_1997-03_HS0700CLCU4S.pdf) | HS0700CLCU4S / ADE-702-095A | Mar 1997 | **SH Series C Compiler User's Manual, 2nd ed, documenting Ver. 5.0.** Downloaded from [bitsavers.org](https://www.bitsavers.org/components/hitachi/superH/). 228 pages, covers SH1/SH2/SH3/SH3E. Has new options (`pic`, `endian`, `double`, `comment=nest`, section change function) not in the v2.0 manual. Useful for diffing documented behavior v2.0→v5.0, which brackets what v3.x/v4.x must have done. |
| [hitachi_shc_v5.0_fulltext.txt](manuals/hitachi_shc_v5.0_fulltext.txt) | — | — | Full text extraction of the v5.0 manual (via pypdf). Grep-friendly. |
| [hitachi_sh7095_cpu_1995-10.pdf](manuals/hitachi_sh7095_cpu_1995-10.pdf) | — | Oct 1995 | **SH7095 (Saturn SH-2) programming manual.** CPU-level reference: instruction set, addressing modes, pipeline, delay slots, cache, exception model. Essential for the compiler's codegen backend and instruction selector. |
| [hitachi_sh7600pm_1994-12.pdf](manuals/hitachi_sh7600pm_1994-12.pdf) | — | Dec 1994 | SH7600 programming manual. Earlier/alternate CPU reference; SH7604 is a related chip variant. |
| [hitachi_hserlib_1995-06.pdf](manuals/hitachi_hserlib_1995-06.pdf) | — | Jun 1995 | HSER library reference. Standard library behaviors (useful for matching runtime startup / stub routines). |
| [hitachi_shsimdbg_1995-03.pdf](manuals/hitachi_shsimdbg_1995-03.pdf) | — | Mar 1995 | SH simulator/debugger manual. Not directly used for codegen but documents the object file formats Hitachi tools produced (COFF/SYSROF, S-records, absolute). |

**Key timeline established by these documents**:
- **v1.0** — Feb 1994 (from tutorial output listings, see [v1_existence_evidence/](v1_existence_evidence/))
- **v2.0** — Mar 1995 (the `1SE` manual above)
- **v3.x, v4.x** — unknown, must fall in 1995-1996 gap
- **v5.0** — by Mar 1997 (the `4S 2ed` manual above)
- **v5.0 Release 31** — Nov 1998 (the binary in [binaries/](binaries/), 31 releases into the v5.0 line)

Daytona USA CCE shipped **Aug 1996** — right in the v3.x/v4.x or very-early-v5.0 window.

---

## Binaries (not currently pulled in)

The Hitachi SHC v5.0 R31 toolchain is not mirrored into this directory. It lives at [C:\Users\albat\Downloads\Hitachi\](C:/Users/albat/Downloads/Hitachi/) (27 binaries + error/help databases, 76,800-byte `shc.exe` dated Nov 3 1998, MD5 `2b25641bd66e65b323967f00b447bff3`). Two other byte-identical copies exist under `saturn_compilers\Sega_Saturn_SDKs\...\Hitachi\` and the SBL 6.01 samples dir.

Reference-only for this project: v5.0 R31 is too new for Daytona CCE (Aug 1996), and its codegen doesn't match production (always-disp addressing mode vs. production's mixed disp/indexed). We use it for cross-checking, not byte matching. Bring it into `resources/binaries/` if and when we need it in-tree for reproducible test runs.

**Invocation gotcha** (for when we do run it): requires `SHC_TMP` and `SHC_LIB` env vars set, and the process environment must be scrubbed of unrelated vars (`VSCODE_*`, `ProgramFiles(x86)`, etc.) or `shc.exe` fails with "Illegal environment variable." The working harness pattern is at [C:\Users\albat\Downloads\Hitachi\test\test_all_flags.py](C:/Users/albat/Downloads/Hitachi/test/test_all_flags.py).

---

## [sega_sbl_build_flags/](sega_sbl_build_flags/)

Sega's actual `.SHC` subcommand files, extracted from the SBL library source. These are what Sega *actually drove the compiler with* when building the SBL library — the ground-truth flag set for Saturn C code.

| File | Source | Era | Notable |
|---|---|---|---|
| [1995-06_sbl_gfs.shc](sega_sbl_build_flags/1995-06_sbl_gfs.shc) | DTS CD 1995-06 / SBL source | 1995 | **Short-flag dialect** — `/OP=1 /CP=7600 /ST=C /SE=p=SEGA_P,c=SEGA_C,d=SEGA_D,b=SEGA_B /I=../../sh/include,../include`. Note `/CP=7600` = the Hitachi chip model number for SH-2, *not* `cpu=sh2`. The older short-flag form. |
| [1995-06_sbl_sega_stm.shc](sega_sbl_build_flags/1995-06_sbl_sega_stm.shc) | same | 1995 | Variant for STM (stream) module. |
| [1997-08_sbl621_dbg.shc](sega_sbl_build_flags/1997-08_sbl621_dbg.shc) | Sep 1997 SDTK / SBL 6.21 | 1997 | **Long-flag dialect** — `-optimize=1 -cpu=sh2 -string=const -section=p=SEGA_P,c=SEGA_C,d=SEGA_D,b=SEGA_B -div=cpu -include=../../sh/include,../include -def=_SH,SATURN -macsave=0 -l`. This is the canonical Sega SHC flag set. Used unchanged for most SBL modules. |
| [1997-08_sbl621_int.shc](sega_sbl_build_flags/1997-08_sbl621_int.shc) | same | 1997 | INT (interrupt) module variant — uses short-flag form (`-opt=1 -nosp -st=c -div=peri -sh=(noso) -macsave=0`). Proves both flag dialects were accepted simultaneously by v5.0. Uses `-div=peri` (peripheral divide unit) instead of `-div=cpu`. |
| [1997-08_sbl621_mth.shc](sega_sbl_build_flags/1997-08_sbl621_mth.shc) | same | 1997 | MTH (math) module variant — `-div=peri` (same as INT). |
| [1997-08_sbl621_spr.shc](sega_sbl_build_flags/1997-08_sbl621_spr.shc) | same | 1997 | SPR (sprite) module variant. |

**The canonical production flag set** (derived from most of the 1997 `.SHC` files):
```
-optimize=1
-cpu=sh2
-string=const
-section=p=SEGA_P,c=SEGA_C,d=SEGA_D,b=SEGA_B
-div=cpu      (or -div=peri for math/interrupt)
-include=<paths>
-def=_SH,SATURN
-macsave=0
-l
```

Whatever compiler we build must accept this flag set and produce output matching Sega's production binaries when given the same C source.

---

## [v1_existence_evidence/](v1_existence_evidence/)

Proof that Hitachi SHC v1.0 existed and was in use by Feb 8, 1994. Source: `SEGA DTS CD (1994-05-19) / HITACHI / TUTORIAL / SH7030 / HITACHI /`. These are tutorial material that Sega bundled on their developer CDs — the C source, the listing output, and the object/absolute/S-record files.

| File | Content |
|---|---|
| [test.c](v1_existence_evidence/test.c) | A trivial C program (`fill()` and `clear()` writing to mmap'd hardware at 0x9000). Dated Feb 8 1994 in the comments. |
| [test_v1.0_1994-02-08.lst](v1_existence_evidence/test_v1.0_1994-02-08.lst) | Listing file. **First line**: `SH SERIES C Compiler (Ver. 1.0)` — with timestamp `08-Feb-1994 16:29:42`. Proves v1.0 was operational and running at Hitachi/Sega on Feb 8 1994. Includes the assembly output and object listing. |
| [test_v1.0.obj](v1_existence_evidence/test_v1.0.obj) | Compiled object file (COFF/SYSROF format). |
| [test_v1.0.abs](v1_existence_evidence/test_v1.0.abs) | Absolute (linked) output. |
| [test_v1.0.mot](v1_existence_evidence/test_v1.0.mot) | Motorola S-record version of the absolute. |

**Value**: we have no v1.0 *binary*, but we have **real output artifacts** from it. If we ever want to validate that our custom compiler reproduces v1.0-era behavior on known input, this is a gold-standard small test case with the ground-truth answer already present. The .LST file also gives us the canonical listing format Hitachi SHC produces, which is stable across versions (v5.0 R31 produces the same format).

---

## What we don't have

For posterity, the critical gaps in this resource tree:

- **No Hitachi SHC binary for versions v1.0, v2.0, v3.x, v4.x, or early v5.0 releases (R1-R30)**. Only v5.0 R31 (Nov 1998), which is too late for Daytona CCE (Aug 1996). Hunted thoroughly across bitsavers, archive.org, SegaXtreme, antime.kapsi.fi, GitHub, Renesas, and the open web — no public copy exists.
- **No v5.0 Release changelog** — no record of what codegen changes happened between R1 and R31, which would help us understand whether R31 is structurally different from an R1-era build.
- **No Sega-internal compiler patches** — if Sega had a custom fork of SHC (which is possible for a first-party title), we have no evidence of it.
- **No CodeWarrior Saturn** (Metrowerks) — known to have existed, never surfaced publicly.

These gaps are what we're building *around*, not *through*. The compiler we build will use the v2.0 and v5.0 manuals as specifications, the Sega flag files as invocation contracts, and the production binaries as regression ground-truth.

---

## Update policy

If we find more reference material (a better manual, a different compiler binary, release notes, etc.), it goes in here and gets indexed in this README. If something gets superseded, keep the old one but mark it SUPERSEDED in the description — historical versions may still matter for provenance or forensic cross-check.
