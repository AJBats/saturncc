# Current State of Research — Saturn Compiler Hunt

**Last updated**: 2026-04-11
**Status**: Active investigation, Phase 0 empirical data gathered, prime suspect identification pending

---

## 0. Mission

**Decompile Daytona USA CCE** (Sega Saturn, August 1996, JP) to
maintainable C. The historical "identify the compiler" investigation
this doc tracks was step zero of that mission — without a matching
compiler, decomp reduces to "C that looks like the asm" and the
round-trip-to-bytes guarantee is lost. Saturncc is the compiler we
built after the survey ruled out every available alternative; it
exists to byte-match the original Hitachi SHC v5.0 output so that
each lifted function can be verified against the retail binary.

**Project framing as of 2026-04-30:** saturncc holds the wheel for
the decomp work. The earlier framing of saturncc as a side
investigation that "supports" decomp on the DaytonaCCEReverse side
is superseded — saturncc-side now drives the decomp itself, with
DaytonaCCEReverse-side asm-edit / mod-build work paused until the
milestone (≥50% of race.bin lifted to C).

**Prior eras, already concluded as failed**:
- **GCC 2.6.3 patching era** (DaytonaUSAExplorer, SaturnReverseTest): 26 backend patches applied to Cygnus-adjacent GCC 2.6.3, reached 48/867 PASS (5.5%), marked "decomp era concluded." See [DaytonaUSAExplorer/workstreams/ICEBOX_compiler_patches.md](../../DaytonaUSAExplorer/workstreams/ICEBOX_compiler_patches.md) and [docs/gcc26_internals.md](../../DaytonaUSAExplorer/docs/gcc26_internals.md).
- **Cygnus 2.7-96q3 direct-use era** (SaturnReverseTest): abandoned because register allocation order differs (target descends r14→r13→r12, 2.7 ascends r8→r9→r10).

**This era (SaturnCompiler)**: systematic survey of every publicly available Saturn-adjacent C compiler, begun as a side investigation by a prior Claude session and continuing here.

---

## 1. The test function — FUN_06044834

This is the canonical benchmark. It lives in the race module of Daytona USA CCE at 0x06044834.

**Source**: [D:\Projects\DaytonaCCEReverse\src\race\FUN_06044834.s](../../DaytonaCCEReverse/src/race/FUN_06044834.s)

**Production assembly** (10 instructions, 20 bytes):
```
FUN_06044834:
    mov.w @(14, r4), r0    ; 8547  -- displacement mode, offset 14
    mov   r0, r1           ; 6103
    mov   #0x1A, r0        ; E01A
    mov.w @(r0, r4), r0    ; 014D  -- INDEXED mode, offset 26
    add   r0, r1           ; 310C
    mov   #0x1E, r0        ; E01E
    mov.w @(r0, r4), r0    ; 014D  -- INDEXED mode, offset 30
    add   r0, r1           ; 310C
    rts                    ; 000B
    neg   r1, r0           ; 610B  -- delay slot
```

Returns `-(a + b + c)` where a, b, c are 16-bit signed shorts at offsets 14, 26, 30 from the pointer argument.

**The fingerprint**: This function mixes two addressing modes for what C would express as equivalent struct-field loads. Offset 14 uses `mov.w @(disp, Rn)` (displacement mode). Offsets 26 and 30 use `mov.w @(r0, Rn)` (indexed mode) via a `mov #imm, r0` load first. **Both 26 and 30 fit the 4-bit displacement encoding** (disp × 2, reach 0..30) — there is no forced reason to use indexed mode here.

**Test C source** (`C:\Users\albat\saturndev\test1.c`):
```c
int test_func(int param_1) {
    return -(*(short *)(param_1 + 0xe) + *(short *)(param_1 + 0x1a) + *(short *)(param_1 + 0x1e));
}
```

---

## 2. SH-2 addressing-mode primer

Critical reference. The matching question is fundamentally about this instruction set detail.

| Instruction | Displacement reach | Destination constraint |
|---|---|---|
| `mov.b @(disp, Rn), R0` | 0..15 (byte units) | **must be r0** |
| `mov.w @(disp, Rn), R0` | 0..30 (2-byte units) | **must be r0** |
| `mov.l @(disp, Rn), Rm` | 0..60 (4-byte units) | **any register** |
| `mov.b @(R0, Rn), Rm` | (indexed, any offset in R0) | any register |
| `mov.w @(R0, Rn), Rm` | (indexed, any offset in R0) | any register |
| `mov.l @(R0, Rn), Rm` | (indexed, any offset in R0) | any register |

**Key asymmetry**: `mov.l` in displacement mode can target any register with a 60-byte reach. `mov.b` and `mov.w` displacement mode must write to R0. This asymmetry matters for register-allocation hypotheses.

---

## 3. Compiler scorecard (summary from HANDOFF.md + subsequent work)

Every compiler tested against FUN_06044834 under 30–40 flag combinations. **None match.**

### Cygnus GCC family

| Version | Date | Source | Result |
|---|---|---|---|
| 2.5.90-940226 | 1994-04-04 | DTS 1994-06-21 / 4-4-94.GNU | no — `exts.w` bug present |
| 2.5.90-940415 | 1994-04-28 | DTS 1994-06-21 / 4-28-94.GNU | no — `exts.w` bug |
| 2.6.0-940805 | 1994-08-05 | DTS 1994-11-01 / GNU | **failed to run in DOSBox** (cause unknown) |
| 2.6-94q4 SOA-950215 | 1995-02-15 | DTS 1995-03-01 / GNU | no — `exts.w` bug |
| 2.6-95q1 SOA-950406 | 1995-04-06 | DTS 1995-06 / 040695 | no — `exts.w` bug |
| 2.6-95q1 SOA-950606 | 1995-06-06 | DTS 1995-06 / 060695 | no — `exts.w` bug |
| 2.6-95q1 SOA-950616 | 1995-06-16 | DTS 1995-06 / 061695 | no — `exts.w` bug |
| 2.7-95q4 SOA-951117 | 1995-11-17 | DTS 1995-11 | no — but closest structural match |
| 2.7-95q4 SOA-960130 | 1996-01-30 | DTS 1996-03 | no — **in-era candidate** |
| 2.7-96q3 SOA-960904 | 1996-09-04 | DTS 1996-11 | no — **in-era candidate** |

**All Cygnus versions**: `add #imm, Rn` + `mov.w @Rn` addressing (never displacement mode). No `mov.w @(disp, r4)` in any output. Register allocation ascends r8→r9→r10 (production descends r14→r13→r12).

**Daytona USA CCE shipped**: August 1996 (JP). In-era Cygnus candidates are **SOA-960130** and **SOA-960904**.

### SN Systems / Psy-Q

| Version | Source | Result |
|---|---|---|
| CCSH v3.06.0015 (Win32), "GCC 2.7-97r1a SN32.3.8.0006" | `C:\Users\albat\Downloads\psy-q\ccsh_extracted\` | no — destructively modifies r4 (`add #14, r4` etc.); interesting but wrong |

Based on GCC 2.7 with SN patches.

### Hitachi SHC

| Version | Source | Result |
|---|---|---|
| SHC 5.0 Release31 (1998) | [C:\Users\albat\Downloads\Hitachi\](C:/Users/albat/Downloads/Hitachi/) standalone + `Sega_Saturn_SDKs\SDKs\Official\Hitachi\` duplicate | no — always displacement mode, only 2 unique flag outputs across entire sweep |

**This is the only Hitachi compiler tested.** Only v5.0 R31 is publicly available. Older versions (3.x, 4.x) never found.

SBL 6.01 bundles an SHC that was identified as the same v5.0 but **never end-to-end tested or binary-diffed** against the standalone.

Env-var gotcha: must set `SHC_TMP` and `SHC_LIB` or it fails with "Illegal environment variable." Must clear inherited PATH or it picks up wrong dirs.

### Modern homebrew Saturn SDKs (the "SSDKInstaller" series)

**These are NOT Cygnus or Hitachi** — they are modern upstream `sh-elf-gcc` releases packaged by the Saturn homebrew community. Version numbers are GCC major.minor, not Sega SDK generation.

| Installer | GCC version | Path on disk | Status |
|---|---|---|---|
| SSDKInstaller.8.4 | 8.4.0 (2018) | [C:\Users\albat\saturndev\saturn-sdk-8-4\](C:/Users/albat/saturndev/saturn-sdk-8-4/) | **live**, flag-swept |
| SSDKInstaller9.3 | 9.3.0 (2019) | [C:\Users\albat\saturndev\saturn-sdk\](C:/Users/albat/saturndev/saturn-sdk/) | **live**, flag-swept |
| SSDKInstaller10.3 | 10.3 | — | installed, SH backend identity-verified, uninstalled |
| SSDKInstaller.12.2 | 12.2 | — | installed, SH backend identity-verified, uninstalled |

All four share an identical SH backend — flag sweeps on 10.3/12.2 would not reveal anything 8.4/9.3 didn't. Always displacement mode when the offset fits. No flag changes this. **Dead branch** of the investigation.

### Summary by compiler family

| Family | Addressing strategy | Status |
|---|---|---|
| Cygnus 2.5 / 2.6 | Always `add #imm, Rn` + `mov.w @Rn` | ruled out (exts.w bug) |
| Cygnus 2.7 | Same as above | closest structural but wrong mode |
| SN Psy-Q CCSH | Same as above, r4-destructive | ruled out (register clobbering) |
| Hitachi SHC 5.0 | Always displacement mode | ruled out (wrong — production mixes) |
| Modern sh-elf GCC 8+ | Always displacement mode | ruled out (wrong — production mixes) |
| **Production binary** | **Mixed displacement + indexed** | **no compiler tested does this** |

---

## 4. Phase 0 empirical data (new this session)

Ran full-race-module greps ([D:\Projects\DaytonaCCEReverse\src\race\](../../DaytonaCCEReverse/src/race/), 212 function files) to answer: is FUN_06044834's mixed-addressing pattern a one-off or a fingerprint?

### Addressing mode census

| Instruction | Indexed `@(r0, Rn)` | Displacement `@(N, Rn)` | ratio indexed:disp |
|---|---|---|---|
| `mov.b` | 356 (60 files) | 339 (50 files) | **1.05 : 1** |
| `mov.w` | 407 (61 files) | 815 (98 files) | **0.50 : 1** |
| `mov.l` | **485 (56 files)** | 1782 (120 files) | **0.27 : 1** |

**Conclusions from this census**:

1. **The mixed-mode pattern is pervasive, not a one-off.** ~70% of files that use indexed mode ALSO use displacement mode in the same function. FUN_06044834 is representative.

2. **`mov.l @(r0, Rn)` is used 485 times** — falsifies any hypothesis that indexed mode is chosen because of the `mov.b/.w` destination-must-be-r0 constraint. `mov.l` displacement has no such constraint and a 60-byte reach, but the compiler still picks indexed mode 485 times.

3. **Ratio trend `.b` > `.w` > `.l`**: the smaller the displacement reach, the more indexed mode is used. **This is confounded by data layout** (old Claude's Reply #3): smaller types pack tighter structs and more fields overflow the disp range. Don't over-interpret the ratio alone; it's consistent with any "use disp when it fits, indexed when it doesn't" compiler.

4. **Open question**: for each `mov #imm, r0 ; mov.? @(r0, Rn)` pair, what is the value of `imm`? If every `imm > disp_max` for the size, indexed mode is only used when forced (boring, doesn't help identify compiler). If some `imm` values fit the displacement range, the compiler has a discretionary heuristic we need to reverse-engineer. **FUN_06044834 demonstrates the second case exists** (offsets 26 and 30 both fit `.w` disp range 0..30) but we don't know how common it is at module scale.

### `exts.w` bug pattern verification

The bug: Cygnus 2.5/2.6 emits redundant `exts.w Rn, Rn` after every `mov.w @addr, Rn` — SH-2 `mov.w` already sign-extends, so the `exts.w` is useless. Cygnus 2.7+ does not emit this.

**Race module `exts.w` census**:
- 290 total `exts.w` instructions (65 files) — mostly legitimate explicit sign extensions
- 8 instances of `mov.w @... \n ... exts.w` (regex hits)
- Of those 8, **5 are real bug-pattern matches** (same register on both lines):

| File | Pattern | Real bug? |
|---|---|---|
| FUN_06036BB8:75-76 | `mov.w @(16,r7),r0` → `exts.w r0,r0` | **yes** |
| FUN_06036BB8:104-105 | `mov.w @(r0,r5),r1` → `exts.w r1,r1` | **yes** |
| FUN_060351CC:823-824 | `mov.w @(r0,r1),r3` → `exts.w r3,r3` | **yes** |
| FUN_060351CC:886-887 | `mov.w @(r0,r3),r1` → `exts.w r1,r1` | **yes** |
| FUN_060351CC:896-897 | `mov.w @(r0,r3),r1` → `exts.w r1,r1` | **yes** |
| FUN_0602B22C:1698-99 | `mov.w @(10,r12),r0` → `exts.w r13,r2` | no (different regs) |
| FUN_06032674:22-23 | `mov.w @r4,r2` → `exts.w r5,r1` | no (different regs) |
| FUN_06032674:152-153 | `mov.w @r4,r2` → `exts.w r5,r1` | no (different regs) |

**Conclusion**: 5 real bug-pattern hits / 1222 total `mov.w` loads = **0.4%**. Stock 2.5/2.6 would emit this at ~100% of sign-extending-load contexts. At 0.4% production cannot be stock 2.5/2.6.

The 5 hits are **clustered** in just 2 files (FUN_06036BB8, FUN_060351CC). Old Claude's Reply #3 noted: clustering argues for legitimate semantic sign extension (stock 2.7 still emits `exts.w` when the following instruction genuinely needs it — signed compare, signed divide, signed shift-right, cast to `long long`), not for a partially-patched 2.6 (which would scatter residuals across dozens of files).

**Final verdict on `exts.w`**: strong evidence that production compiler is ≥ 2.7-era or equivalent. The 5 hits are probably genuine semantic sign extensions, not compiler artifacts. (Not yet confirmed by inspecting what the register is used for next at each of the 5 sites.)

---

## 5. Hypotheses explored and killed

### H1: FUN_06044834 is hand-written assembly
**Status: killed.** The mixed-addressing-mode pattern appears in 43+ files across the race module. No human writes that many functions with that consistent an interleaving. It's a compiler output.

### H2: Production compiler picks indexed mode because `mov.b/.w` displacement requires r0 destination
**Status: killed** by `mov.l @(r0, Rn)` count of 485. `mov.l` displacement has no destination constraint, so register-allocation pressure cannot be the reason. The compiler has a different heuristic.

### H3: Production is stock Cygnus 2.5 or 2.6 (before the `exts.w` fix)
**Status: strong evidence against.** 5 bug-pattern hits out of 1222 `mov.w` loads is 0.4%, not the ~100% stock 2.5/2.6 would produce. Clustering in 2 files argues those 5 are legitimate semantic sign extensions in a ≥2.7 compiler.

### H4: FUN_06044834 is an outlier in its TU group
**Status: untested.** The parent project has TU reconstruction results (613 race files merged into 211 TU groups) at [DaytonaCCEReverse/docs/DONE_tu_reconstruction_work.md](../../DaytonaCCEReverse/docs/DONE_tu_reconstruction_work.md) and [tools/detect_tu_groups.py](../../DaytonaCCEReverse/tools/detect_tu_groups.py). Classifying addressing-mode mix ratio by TU group would tell us whether some TUs are pure-displacement and others pure-indexed (mixed-compiler hypothesis) or whether every TU has the module-wide ratio (single compiler with per-reference heuristic). Not yet done.

---

## 6. Open hypotheses / live questions

### Q1: Does Cygnus 2.7's SH backend even know `mov.w @(disp, r4)` as a valid instruction pattern? (**GATING QUESTION**)
If the answer is no — if Cygnus 2.7's machine description file doesn't contain the displacement-mode `mov.w` pattern — then no amount of register-allocator tuning can produce production's output, and the entire Cygnus 2.x lineage is structurally dead. This gates everything else.

**Test**: compile `short f(int p) { return *(short *)(p + 4); }` with Cygnus 2.7-96q3 under `-O2 -fomit-frame-pointer` in DOSBox and see whether it emits `mov.w @(4, r4), r0` or `add #4, r4 ; mov.w @r4, r0`. ~10 minutes.

**Not yet run this session.**

### Q2: What is the compiler's indexed-vs-displacement heuristic?
For every `mov #imm, r0 ; mov.? @(r0, Rn), rX` sequence in the race module, bucket by `(imm, Rn, size)`. If indexed is only used when `imm > disp_max_for_size`, the heuristic is trivial ("forced by range"). If some imm values fit within disp range, the heuristic is non-trivial and worth reverse-engineering. FUN_06044834 proves case 2 exists; we don't know how common it is.

Old Claude's Reply #3 suggested adding the **base register `Rn`** to the bucketing — if the compiler correlates mode choice with base-register identity (e.g., incoming args vs. spilled-and-reloaded registers), that would show up as a clean split.

**Not yet run this session.**

### Q3: Is the binary mixed-compiler (different TUs built by different compilers)?
See H4 above. TU-grouped addressing-mode ratios would answer this cheaply. **Not yet run.**

### Q4: Are the 5 `exts.w` bug-pattern hits real compiler bugs or legitimate semantic sign extensions?
Check the instruction after each `exts.w` at the 5 confirmed sites. If it's a signed compare/divide/shift-right/cast-to-long-long: legitimate 2.7 behavior. If it's a plain add/store: compiler quirk worth flagging. 5 minutes of work, not yet done.

---

## 7. Prime suspects still untested

Ordered by "plausibility + accessibility":

1. **Older Hitachi SHC v3.x / v4.x** (pre-1998). Only v5.0 has surfaced publicly. Older revisions would predate the displacement-always heuristic in v5.0 and are the prime suspect for "a Hitachi compiler that emits mixed-mode addressing." TrekkiesUnite118 (Saturn homebrew dev on Discord, cited in HANDOFF) said "the Hitachi compiler is in the SH directory on the latest SBL disc" — SBL 6.01 doesn't have one, SBL 6.21 (Sep '97 toolkit disc) doesn't either. There may be another SBL release that does. **Action: community inquiry to SegaXtreme forums / Saturn Discord.**

2. **CodeWarrior Saturn** (Metrowerks). Known to have existed, never tested. No specific lead on where to find it. **Action: search Internet Archive and SegaXtreme for "Metrowerks Saturn" / "CodeWarrior Saturn".** Priority: low (cold trail).

3. **Sega-internal / AM2-internal compiler fork**. Speculative — a patched version of GCC 2.7 or SHC 4.x maintained internally at Sega/AM2 for racing titles. No evidence it exists, but would explain a signature we can't find elsewhere. **Action: keep open as residual hypothesis; don't chase.**

4. **Cygnus 2.6.0-940805** (the one that failed to run in DOSBox). Lowest-priority lead — even if we get it running, Phase 0's `exts.w` analysis weakly rules out 2.6 anyway. **Action: only revisit if Q1 points back to the 2.x line.**

---

## 8. Dead ends (confirmed ruled out)

- **Cygnus 2.5 / 2.6 all builds** (stock) — `exts.w` bug incompatibility
- **Cygnus 2.7 all builds tested** (stock, unpatched) — always `add #imm, Rn` addressing, no displacement mode emitted, wrong register allocation order
- **SN Psy-Q CCSH 3.06** — GCC 2.7 fork, destroys r4 (production preserves it)
- **Hitachi SHC 5.0 Release31** — always displacement mode, no mixing, insensitive to flags
- **Modern sh-elf GCC 8.4.0 / 9.3.0 / 10.3 / 12.2** (SSDKInstaller series) — identical modern SH backend, always displacement mode, no flag influence
- **Claim "production has zero `exts.w`"** — wrong, production has 290 `exts.w` instructions (mostly legitimate). The correct claim is "production has ~zero redundant `mov.w ; exts.w` bug patterns" (5 real hits = 0.4%).

---

## 9. Toolchain infrastructure on disk

### Downloaded compilers

**Saturn-era (historical)** — `C:\Users\albat\Downloads\saturn_compilers\`:
- `DTS_1995\SATURN\PROGRAM\GNUTOOLS\` — Cygnus 2.7-95q4-SOA-951117
- `DTS_1996\PROGRAM\GNUTOOLS\` — Cygnus 2.7-96q3-SOA-960904
- `SEGA_DTS_CDs_Partial\` — 7 historical DTS discs spanning GCC 2.5.90 → 2.7-960130
- `Sega_Saturn_SDKs\SDKs\Official\Hitachi\` — Hitachi SHC 5.0 Release31 (1998)
- `Sega_Saturn_SDKs\SDKs\Official\Cygnus 2.7 Sega SATURN Compiler Toolchain\` — Cygnus 2.7-96q3 duplicate
- `Sega_Saturn_SDKs\SDKs\ThirdParty\PsyQ\` — Psy-Q tools

**Other standalone downloads**:
- [C:\Users\albat\Downloads\Hitachi\](C:/Users/albat/Downloads/Hitachi/) — Hitachi SHC 5.0 standalone (from SegaXtreme, DC dev kit) + [test\](C:/Users/albat/Downloads/Hitachi/test/) harness with test1.c / test2.c / test3.c and [test_all_flags.py](C:/Users/albat/Downloads/Hitachi/test/test_all_flags.py)
- `C:\Users\albat\Downloads\psy-q\ccsh_extracted\` — Psy-Q CCSH 3.06 Win32 native with added CPPSH/CC1SH from GNUSH archive
- `C:\Users\albat\Downloads\SEGASATURN_toolkit-pc\extracted\` — Sep '97 SDK toolkit disc (SBL/SGL libs, **no compiler**)
- `C:\Users\albat\Downloads\SBL601\` — SBL 6.01 (**no compiler bundled** that differs from standalone)
- `C:\Users\albat\Downloads\compiler_extracted\SATURN\` — Cygnus 2.7-96q3 duplicate
- [C:\Users\albat\Downloads\SSDKInstaller.8.4\](C:/Users/albat/Downloads/SSDKInstaller.8.4/) through [.12.2\](C:/Users/albat/Downloads/SSDKInstaller.12.2/) — modern homebrew sh-elf GCC installers (see §3.5)

### Installed toolchains

| Path | Version | Use |
|---|---|---|
| [C:\Users\albat\saturndev\saturn-sdk\](C:/Users/albat/saturndev/saturn-sdk/) | sh-elf-gcc 9.3.0 | modern GCC flag sweeps |
| [C:\Users\albat\saturndev\saturn-sdk-8-4\](C:/Users/albat/saturndev/saturn-sdk-8-4/) | sh-elf-gcc 8.4.0 | modern GCC flag sweeps |
| `C:\DOSBox-X\dosbox-x.exe` | DOSBox-X | required for all pre-1998 DOS compilers |
| `C:\Program Files\7-Zip\7z.exe` | 7-Zip | archive handling |

### Test scaffolding

- `C:\Users\albat\saturndev\test1.c` — canonical test function (FUN_06044834 equivalent)
- `C:\Users\albat\saturndev\test2.c` — variant for testing
- `C:\Users\albat\saturndev\cygnus_test\` — DOSBox working directory
- `C:\Users\albat\saturndev\test_all_cygnus.py` — batch tester for all Cygnus versions
- `C:\Users\albat\saturndev\test_cygnus.py` — single-run Cygnus tester
- `C:\Users\albat\saturndev\test_gcc84_flags.py` / `test_gcc_flags.py` — flag sweeps for sh-elf GCC 8.4 / 9.3
- [C:\Users\albat\Downloads\Hitachi\test\test_all_flags.py](C:/Users/albat/Downloads/Hitachi/test/test_all_flags.py) — Hitachi SHC flag sweep
- Pre-generated outputs in `saturndev\`: `test1_O0.s`, `test1_O1.s`, `test1_O2.s`, `test1_O3.s`, `test1_Os.s`, `out84.s`

### Ground-truth binaries

- [D:\Projects\DaytonaCCEReverse\src\race\](../../DaytonaCCEReverse/src/race/) — race module disassembly, 212 function files (post TU-reconstruction from 613)
- [D:\Projects\DaytonaCCEReverse\ghidra_reference\race\](../../DaytonaCCEReverse/ghidra_reference/race/) — Ghidra decompilation reference C for all race functions (783 originally)
- Canonical benchmark: [FUN_06044834.s](../../DaytonaCCEReverse/src/race/FUN_06044834.s)

---

## 10. Invocation recipes

### DOSBox-X for Cygnus 2.7

Cygnus 2.7 is DOS DJGPP — must run via DOSBox-X.

```ini
[dosbox]
memsize=16

[cpu]
cycles=max

[autoexec]
MOUNT S "C:\Users\albat\Downloads\saturn_compilers\DTS_1996\PROGRAM\GNUTOOLS"
MOUNT W "C:\Users\albat\saturndev\cygnus_test"
SET PATH=S:\BIN
SET GCC_EXEC_PREFIX=S:\LIB\
SET C_INCLUDE_PATH=S:\INCLUDE
SET TMPDIR=W:\
SET GO32=EMU S:\BIN\EMU387
W:
GCC -O2 -fomit-frame-pointer -S TEST1.C
EXIT
```

Run with: `C:\DOSBox-X\dosbox-x.exe -silent -fastlaunch -conf build.conf`

**Gotchas**:
- `-silent` only works with `-conf`, not `-c`
- Output filenames are uppercase on host filesystem (TEST1.S, not test1.s)
- Do NOT use the bundled `SETENV.BAT` — it hardcodes `D:\SATURN\` paths
- Symbols get `_` prefix (`test_func` → `_test_func`) — COFF convention
- Output format is Hitachi SH big-endian COFF, not ELF

**Recommended flags**:
- `-O2 -fomit-frame-pointer` — tight code, no frame-pointer overhead
- `-O` — less aggressive delay-slot scheduling than `-O2`
- `-Os` — **BROKEN** in this GCC, produces the same output as `-O0`. Do not use.

There is also a [`cygnus-dosbox-toolchain` skill](C:/Users/albat/.claude/skills/cygnus-dosbox-toolchain) available if this project needs it.

### Hitachi SHC 5.0

Native Win32, but needs environment scrubbing:

```powershell
$psi.EnvironmentVariables.Clear()
$psi.EnvironmentVariables['SHC_TMP'] = '<working_dir>'
$psi.EnvironmentVariables['SHC_LIB'] = '<shc_install_dir>'
$psi.EnvironmentVariables['PATH'] = '<shc_install_dir>;C:\Windows\system32'
```

Command: `shc.exe -cpu=sh2 -object=test.obj test.c`

Any `%ProgramFiles%`, `%VSCODE_*%`, etc. env vars cause "Illegal environment variable" failures. See [C:\Users\albat\Downloads\Hitachi\test\dump_after.bat](C:/Users/albat/Downloads/Hitachi/test/dump_after.bat) for the full env-scrub pattern.

Unique flag outputs across all tested combinations: **2** (default optimized + `-optimize=0`). Flags that do nothing to codegen: speed, size, loop, rtnext, align16, pic, macsave, abs16, inline, division.

### Modern sh-elf GCC

Must `cd` to the `bin` directory and set `PATH` before running, otherwise `cc1.exe` fails silently with exit code 1. See [C:\Users\albat\saturndev\test_gcc84_flags.py](C:/Users/albat/saturndev/test_gcc84_flags.py) for the pattern.

---

## 11. Recommended next actions (ordered)

1. **Q1 — Cygnus 2.7 backend capability test** (gating, 10 min). Compile `short f(int p) { return *(short *)(p + 4); }` with 2.7-96q3 under `-O2 -fomit-frame-pointer`. If no `mov.w @(4, r4)` — Cygnus lineage is structurally dead and #2 below becomes the critical path. If yes — the question becomes register allocation.

2. **Prime-suspect hunt**: older Hitachi SHC v3.x/v4.x. Community inquiry (SegaXtreme, Saturn Discord). Specifically: pre-1996 Hitachi SH dev kits, or any SBL release with an `SH\` directory containing `shc.exe`.

3. **Q2 — constant histogram**. Parse race module for every `mov #imm, r0 ; mov.? @(r0, Rn), rX` sequence. Bucket by `(imm, size, Rn)`. Determine what fraction of indexed-mode loads are at offsets that would fit in displacement mode. Identifies whether the compiler has a non-trivial heuristic.

4. **Q3 — TU-grouped addressing mode ratios**. Run [detect_tu_groups.py](../../DaytonaCCEReverse/tools/detect_tu_groups.py), bucket indexed/disp counts per TU. Tests the mixed-compiler hypothesis.

5. **Q4 — verify the 5 `exts.w` hits**. Check what each site does with the register after the `exts.w`. 5 minutes. Strengthens or weakens the "≥ 2.7" conclusion.

6. **CodeWarrior Saturn search**. Low priority, cold trail. Time-box to 30 minutes of archaeology before giving up.

7. **Cygnus 2.6.0-940805 DOSBox debug**. Lowest priority. Only revisit if Q1 or Q2 points back at the 2.x line.

**Time-box**: the old Claude's parting advice (REPLY_TO_NEW_CLAUDE_FINAL.md) was "if the answer is 'no publicly available compiler matches, functional equivalence is the fallback,' that's a valid result. Don't chase past diminishing returns."

---

## 12. Key facts that might matter later

- Daytona USA CCE has 8 code modules: `main` (LWR resident), `init` (HWR permanent dispatcher), `race`, `select`, `result2p`, `name`, `backup`, `ending`. All SH-2, big-endian.
- Race module base address: 0x06028000 (hot-swapped sub-module slot).
- Race module has 783 original functions, reduced to 211 TU groups post-TU-reconstruction.
- All 8 modules share an **identical prologue fingerprint**: `2F E6 24 48 2F D6 2F C6 2F B6`. Suggests single compiler across all modules.
- FUN_06044834 is at memory address 0x06044834 (inside race module at offset 0x1C834 from race base).
- The parent project's broader transplant goals do NOT depend on compiler matching — that's documented in [DaytonaCCEReverse/CLAUDE.md](../../DaytonaCCEReverse/CLAUDE.md).
- An earlier Claude session tested Cygnus 2.7-96Q3 specifically and concluded it doesn't match. The current-era Claude independently retested and confirmed.
- GCC 2.6.3 era (DaytonaUSAExplorer) reached 48/867 byte-matches (5.5%) with 26 backend patches. This is the ceiling for that approach. Documented in [DaytonaUSAExplorer/workstreams/ICEBOX_compiler_patches.md](../../DaytonaUSAExplorer/workstreams/ICEBOX_compiler_patches.md).

---

## 13. Source documents

Everything in this state document was consolidated from:

- [HANDOFF.md](../HANDOFF.md) — original deep-dive by prior Claude session (351 lines)
- [REPLY_FROM_NEW_CLAUDE.md](../REPLY_FROM_NEW_CLAUDE.md) — my Phase 0 grep results and hypothesis
- [REPLY_TO_NEW_CLAUDE.md](../REPLY_TO_NEW_CLAUDE.md) — old Claude's answers to my initial questions
- [REPLY_FROM_NEW_CLAUDE_2.md](../REPLY_FROM_NEW_CLAUDE_2.md) — `mov.l` falsifiability + exts.w verification
- [REPLY_TO_NEW_CLAUDE_2.md](../REPLY_TO_NEW_CLAUDE_2.md) — old Claude's SH-2 asymmetry correction
- [REPLY_TO_NEW_CLAUDE_3.md](../REPLY_TO_NEW_CLAUDE_3.md) — old Claude's data-layout caveat + histogram refinement
- [REPLY_TO_NEW_CLAUDE_FINAL.md](../REPLY_TO_NEW_CLAUDE_FINAL.md) — old Claude's signoff
- Live on-disk inspection of `C:\Users\albat\saturndev\` and `C:\Users\albat\Downloads\`

The sister-project references ([DaytonaUSAExplorer](../../DaytonaUSAExplorer/), [SaturnReverseTest](../../SaturnReverseTest/), [DaytonaCCEReverse](../../DaytonaCCEReverse/)) contain the prior GCC 2.6 era material and the ground-truth race module binaries.
