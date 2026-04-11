# Workstream: Narrowing the Hitachi SHC version used for Daytona CCE

**Date**: 2026-04-11
**Status**: **COMPLETE** — version range narrowed from "v1.0–v5.0 R31" to **"v3.0 or later, through early v5.0"**

## Questions this workstream answers

Previously we thought Daytona CCE's compiler could be anywhere from v1.0 (Feb 1994) through v5.0 R31 (Nov 1998). This workstream narrows that using documented feature evolution between the v2.0 and v5.0 manuals, cross-checked against actual production binary evidence.

## Four leads investigated

### 1. ✅ Diff v2.0 manual against v5.0 manual — **PRODUCED RESULTS**

Extracted full text from both PDFs and mechanically compared. Script and output preserved at:
- Script: [../resources/manuals/diff_v2_v5.py](../resources/manuals/diff_v2_v5.py)
- Output: [../resources/manuals/diff_v2_v5_output.txt](../resources/manuals/diff_v2_v5_output.txt)
- v2.0 text: [../resources/manuals/hitachi_shc_v2.0_fulltext.txt](../resources/manuals/hitachi_shc_v2.0_fulltext.txt)
- v5.0 text: [../resources/manuals/hitachi_shc_v5.0_fulltext.txt](../resources/manuals/hitachi_shc_v5.0_fulltext.txt)

**Key documented differences between v2.0 (Mar 1995) and v5.0 (Mar 1997)**:

| Axis | v2.0 | v5.0 |
|---|---|---|
| CPU coverage | SH1, SH2 (SH7000 series) | SH1, SH2, SH3, SH3E |
| `#pragma` directives | **Only `#pragma interrupt`** | `interrupt`, `section`, `inline`, `inline_asm`, `global_register`, `gbr_base`, `abs16`, `regsave`, `noregsave`, `noregalloc` |
| Intrinsic functions | 21 (set_cr/get_cr, set_imask, GBR family, sleep, tas, trapa, etc.) | 22 — only `macl` added |
| Options (new) | — | `pic`, `endian`, `double`, `comment=nest`, `align16`, section-change function |
| Error code range | ~similar | 1000–3320 (183 codes) |
| Page count | 188 | 228 |
| Document ID | `ADE-702-095` (no suffix) | `ADE-702-095A` (revised) |

**Takeaway**: The intrinsic function set barely changed (1 added). But the **`#pragma` surface expanded dramatically** — v2.0 only understood one pragma (`interrupt`), while v5.0 gained ~9 more. Any production binary that shows codegen coming from these newer pragmas is post-v2.0.

The "Ver.5.0" string that appears in the v2.0 manual fulltext is a red herring — it's in the troubleshooting section referencing "use linkage editor version 5.0 or higher". The **linker** had reached v5.0 by 1995; the **compiler** was still at v2.0. Each Hitachi tool versions independently. The 1998 toolchain we have pairs `shc.exe` v5.0 R31 with `lnk.exe` v6.0A and `lbr.exe` v2.0A.

### 2. ❌ Search for early v5.0 releases (R1, R2, R5, R10) — **NOTHING FOUND**

Searched archive.org, bitsavers, antime.kapsi.fi, SegaXtreme, Renesas, GitHub, and the open web. **No pre-R31 v5.0 binary is publicly archived.** Every reference to a Hitachi SHC binary cycles back to v5.0 R31 (Nov 1998) — the only publicly preserved version.

### 3. ❌ Search for v5.0 changelog / release notes — **NOTHING FOUND**

No public record of what changed between v5.0 R1 and v5.0 R31. Renesas has patch notes for its post-2003 "SuperH RISC engine C/C++ Compiler Package V6.0/V6.0A" but those are the Renesas rebrand line, not the original Hitachi numbering, and the documents date from well after our 1998 binary.

### 4. ❌ Hunt for SBL discs between 6.01 and 6.21 — **NOTHING FOUND**

Public SBL releases appear to be: **5.x → 6.01 → 6.21**. No intermediate public release (6.10, 6.11, 6.15, 6.20) exists in any archive I can find. Community preservation jumped directly from 6.01 (which bundles SHC v5.0 R31 in `SEGASMP/GFS/SMPGFS1A/`) to 6.21 (which bundles the same v5.0 R31 per MD5). Either the intermediate SBL versions weren't distributed publicly, weren't preserved, or don't differ in bundled-compiler version from their neighbors.

## Production binary evidence — Daytona CCE uses `#pragma gbr_base` extensively

The documented manual diff told us what features were added between v2.0 and v5.0. To narrow the version range further, I grepped the Daytona CCE race module disassembly for use of these v5.0-era features.

**GBR-relative addressing** (`mov.? @(disp,gbr)`):
- **411 occurrences across 34 files** in race module
- Example ([FUN_0603DF28.s:99-193](../../DaytonaCCEReverse/src/race/FUN_0603DF28.s#L99-L193)):
  ```
  ldc r14, gbr
  mov.l @(72, gbr), r0
  mov.w @(152, gbr), r0
  mov.w r0, @(154, gbr)
  mov.b r0, @(152, gbr)
  mov.b r0, @(153, gbr)
  mov.b @(159, gbr), r0
  mov.l @(132, gbr), r0
  ...
  ```

**Direct GBR manipulation** (`stc gbr`, `ldc ...,gbr`):
- 42 occurrences across 16 files

**Interpretation**: This mixed-size (`mov.b/.w/.l`), mixed-offset (from 72 through 193+) pattern across dozens of functions is NOT something a programmer writes by hand. It's the classic output of the compiler directly generating GBR-relative loads from a C struct declaration marked with `#pragma gbr_base`. In v2.0, GBR could only be touched via the intrinsic functions `set_gbr()`, `gbr_read_byte(offset)`, etc. — but those intrinsics required the offset as a constant in the call site, and the programmer had to manually invoke them. The production code looks like field-level access to a structured region that the compiler automatically translates to GBR-relative loads.

**`#pragma gbr_base` first appears in v5.0** (per the manual diff). It was NOT in v2.0.

## Conclusion

**Daytona USA CCE was built with Hitachi SHC v3.0 or later.** v1.0 and v2.0 are **definitively ruled out** because the production binary uses compiler-generated GBR-relative addressing that the v2.0 manual does not document as a supported feature.

The realistic version range is now **v3.x through early v5.0**, specifically:
- **v3.x or v4.x** released 1995-1996, unpreserved publicly
- **Early v5.0 releases (R1 through ~R10)** released late 1996 or early 1997, unpreserved publicly

Our available v5.0 R31 (Nov 1998) has the right feature set but represents 18+ months of release patches past whatever was current when Daytona CCE shipped (Aug 1996).

## Implications for the build-our-own-compiler phase

1. **The v5.0 manual is our primary specification** (not the v2.0 manual). Daytona CCE uses v5.0-era features (`#pragma gbr_base` at minimum), so our compiler must implement those.

2. **The v2.0 manual is useful as a "minimum baseline"** — its calling convention, struct layout, bit field ordering, intrinsic function semantics, and basic codegen rules haven't changed meaningfully between v2.0 and v5.0 (the manual diff shows stability on these axes). If we implement the v2.0-documented behaviors correctly, we get the core right.

3. **The ~9 new pragmas in v5.0 are what define "Hitachi v5.0-era codegen"**:
    - `#pragma gbr_base` — **critical, heavily used in Daytona CCE**
    - `#pragma section` — explicit per-function section assignment
    - `#pragma inline` / `#pragma inline_asm` — function-level inlining control
    - `#pragma global_register` — pin C variables to specific registers
    - `#pragma abs16` — force 16-bit absolute addressing for specific data
    - `#pragma regsave` / `#pragma noregsave` / `#pragma noregalloc` — register save/allocation hints

    Our custom compiler needs to implement at least `gbr_base` for Daytona CCE matching. The others we'll prioritize based on actual usage in the production binary.

4. **The v5.0 R31 binary is still our closest reference compiler**. The codegen mismatches we see (always-disp addressing for `mov.w`, wrong register allocation) are likely the result of ~30 release patches between R1 and R31. Some of those patches changed optimization heuristics — that's the gap we have to close by hand, using the manual as the spec.

5. **Next useful probe**: survey the race module (and other modules) for patterns that would distinguish v3.x vs v4.x vs early v5.x. For example, did any of the other v5.0 pragmas appear in earlier versions? If we can find documentation hinting when `#pragma section` or `#pragma inline_asm` were added, we can narrow further.

## Saved artifacts

- [../resources/manuals/diff_v2_v5.py](../resources/manuals/diff_v2_v5.py) — diff script (run to regenerate)
- [../resources/manuals/diff_v2_v5_output.txt](../resources/manuals/diff_v2_v5_output.txt) — diff output
- [../resources/manuals/hitachi_shc_v2.0_fulltext.txt](../resources/manuals/hitachi_shc_v2.0_fulltext.txt) — v2.0 manual text
- [../resources/manuals/hitachi_shc_v5.0_fulltext.txt](../resources/manuals/hitachi_shc_v5.0_fulltext.txt) — v5.0 manual text

The PDFs themselves are in [../resources/manuals/](../resources/manuals/).
