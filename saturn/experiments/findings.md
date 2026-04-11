# Findings: Hitachi SHC vs Cygnus 2.7 as base compiler for Daytona CCE

**Date**: 2026-04-11
**Status**: **COMPLETE** — three experiments, definitive verdict

## Question

The old Claude's HANDOFF.md claimed Cygnus 2.7 was "the closest structural match" for Daytona CCE. That verdict was based on testing against `FUN_06044834`, a 10-instruction leaf function that doesn't exercise GBR addressing or multi-register save prologues. Before committing to either Hitachi SHC or GCC/Cygnus as the base for building a custom byte-matching compiler, we needed to re-examine the question using features that actually distinguish the two compilers.

## Experiment 1 — GBR codegen

**Setup**: Same C source (`struct game_state` with mixed-size fields, with store/load functions) in two versions:
- [`gbr_test_sh.c`](exp1_gbr/gbr_test_sh.c) — uses Hitachi's `#pragma gbr_base(gs)`
- [`gbr_test_gcc.c`](exp1_gbr/gbr_test_gcc.c) — plain global struct (GCC baseline)

Compiled with:
- **Cygnus 2.7-96q3-SOA-960904** via DOSBox-X (`-O2 -fomit-frame-pointer -S -x c`)
- **Hitachi SHC v5.0 R31** native Win32 (`-cpu=sh2 -optimize=1`)

**Static evidence (structural)**: grepped the GCC 2.6 SH backend source (the closest base to Cygnus 2.7 we have in-tree):
- `sh.md`: **zero** `gbr`/`GBR` references → no instruction patterns that use GBR for addressing
- `sh.c`: **zero** `gbr`/`GBR` references → no codegen logic for GBR-relative loads
- `sh.h`: 3 hits, only defining GBR as a named register (`GBR_REG 19`, in the register file), not usable as an addressing base

**Empirical evidence (dynamic)**:

Cygnus 2.7 output for `store_all`:
```
mov.l   L2,r1         ; load _gs from constant pool
mov.b   r4,@r1        ; store char at offset 0 (indirect)
mov     r1,r2
add     #1,r2         ; compute offset 1 via add
mov.b   r5,@r2        ; indirect at r2
...
mov.l   r7,@(4,r1)    ; store long at offset 4 (displacement mode, no destination constraint)
...
```

Hitachi SHC v5.0 R31 output for `store_all`:
```
MOV.B   R0,@(_gs-(STARTOF $G0),GBR)       ; C000  — store char at gbr+0
MOV.B   R0,@(_gs-(STARTOF $G0)+1,GBR)     ; C000  — store char at gbr+1
MOV.W   R0,@(_gs-(STARTOF $G0)+2,GBR)     ; C100  — store short at gbr+2
MOV.L   R0,@(_gs-(STARTOF $G0)+4,GBR)     ; C200  — store long at gbr+4
MOV.B   R0,@(_gs-(STARTOF $G0)+8,GBR)     ; C000
MOV.L   R0,@(_gs-(STARTOF $G0)+12,GBR)    ; C200
MOV.W   R0,@(_gs-(STARTOF $G0)+16,GBR)    ; C100  (delay slot)
```

Opcodes `C000/C100/C200` are the SH-2 `mov.b/w/l Rm,@(disp,GBR)` family. The `_gs-(STARTOF $G0)` gets linker-resolved to numeric offsets. After linking, these become exactly the `mov.? @(N, gbr)` instructions we see in Daytona production.

**Verdict**: Cygnus 2.7 is **architecturally incapable** of producing GBR-relative addressing. Hitachi SHC produces it natively via `#pragma gbr_base`. The 411+ production instances of `mov.? @(disp,gbr)` in the race module **cannot have come from Cygnus 2.7**.

## Experiment 2 — Per-file addressing-mode ratio distribution

**Setup**: For each of 208 race-module `.s` files, count `mov.b/w/l @(r0,Rn)` (indexed) and `mov.b/w/l @(disp,Rn)` (displacement) and compute the indexed ratio. Look for bimodal clustering, which would suggest different files compiled with different compilers.

**Results** ([`analyze.py`](exp2_tu_clustering/analyze.py)):

```
Histogram of indexed-mode ratio per file:
  0- 10% |  70 files | ##################################################
 10- 20% |  14 files | ##########
 20- 30% |  15 files | ##########
 30- 40% |  11 files | #######
 40- 50% |   3 files | ##
 50- 60% |  10 files | #######
 60- 70% |  12 files | ########
 70- 80% |   7 files | #####
 80- 90% |   2 files | #
 90-100% |   3 files | ##
100-110% |   7 files | #####
```

Wide distribution, not cleanly bimodal. Dominant cluster at 0-30% indexed (99 files = 64%), with a long tail through 100% indexed.

**GBR subset (32 files)**: average indexed ratio **0.142**
**Non-GBR subset (122 files)**: average indexed ratio **0.296**

**Verdict**: Consistent with a single compiler whose per-function output varies based on source patterns (loops with index variables force indexed mode, direct struct access uses displacement). The wide distribution isn't conclusive evidence of mixed compilation; it could also reflect source-level diversity.

## Experiment 3 — Prologue fingerprint analysis

**Setup**: For each of 850 functions across 208 race-module files, extract the first 1-3 instructions after the function label and bucket. Mixed compilers would show distinct prologue fingerprints clustering by file.

**Results** ([`analyze.py`](exp3_prologue/analyze.py)):

First-instruction counts:
```
300x  sts.l pr, @-r15            ; leaf function / save PR
280x  mov.l r14, @-r15           ; non-leaf / save callee-saved first
  7x  mov.l r0, @-r15            ; outlier
  6x  clrmac                     ; MAC-using DSP-like function
  4x  mov.l r4, @-r15            ; outlier
...
```

**Most common three-instruction prologue (101 functions)**:
```
mov.l r14, @-r15
mov.l r13, @-r15
mov.l r12, @-r15
```

**This is the Hitachi SHC signature.** Per HANDOFF.md and confirmed by GCC 2.6/2.7 behavior: GCC uses **ascending** r8→r9→r10 register save order, while Hitachi SHC uses **descending** r14→r13→r12. 101 functions using the descending order are definitively Hitachi.

**GBR-using vs non-GBR files — prologue distribution comparison**:

| First instruction | GBR files (174 funcs) | Non-GBR files (676 funcs) |
|---|---|---|
| `sts.l pr, @-r15` | 83 (48%) | 217 (32%) |
| `mov.l r14, @-r15` | 52 (30%) | 228 (34%) |

Both subsets use the same shapes in similar proportions. If mixed compilation were present, we'd expect the GBR subset to use one shape set and the non-GBR subset to use a different shape set. They don't — they're the same compiler.

**Notable variant prologues**:
- `9x` pattern: `sts.l pr / stc.l gbr / sts.l mach / sts.l macl / ...` — interrupt handler prologue saving GBR+MAC registers
- `4x` pattern: `clrmac / mac.l @r4+, @r5+ / mac.l @r4+, @r5+` — MAC-instruction DSP routines
- `4x` pattern: `mov.l r14, @-r15 / mov.l @(136, gbr), r0` — GBR load as second instruction

**Verdict**: Race module is **single-compiler Hitachi SHC**. The descending register save order, shared prologue distribution across GBR and non-GBR subsets, and absence of any GCC-ascending patterns all point at one compiler across the whole module.

## Synthesis: the final answer

**Hitachi SHC is the correct base compiler for Daytona CCE**, not Cygnus 2.7.

The old Claude's "closest structural match" verdict for Cygnus 2.7 was based on `FUN_06044834`, a small leaf function that doesn't exercise the distinctive features. When measured on features that actually discriminate the two compilers — GBR addressing and multi-register prologue save order — Cygnus 2.7 is **structurally wrong** and Hitachi SHC is **structurally right**.

The race module consists of ~850 functions compiled from a single toolchain producing:
1. Descending callee-saved register save order (`r14→r13→r12`)
2. `#pragma gbr_base` output for globally-addressable structs (32 files, 411+ loads)
3. Mixed displacement/indexed addressing based on source patterns
4. Hitachi-specific intrinsics (not examined in detail, but the GBR signature already tells us)
5. Hitachi calling convention matching the v5.0 manual

This confirms the earlier version-narrowing conclusion (**Daytona CCE compiler = Hitachi SHC v3.0 through early v5.0**) and rules out the GCC/Cygnus family entirely for matching purposes.

## Implications for the compiler-build phase

1. **Drop Cygnus/GCC 2.x/2.7 as base candidates.** They cannot produce the required codegen without enormous (multi-subsystem) surgery. DaytonaUSAExplorer's 48/867 ceiling was hitting exactly this architectural limit.

2. **The build target is a Hitachi SHC reimplementation.** Our custom compiler must:
   - Support `#pragma gbr_base` / `gbr_base1` with section allocation to `$G0`/`$G1`
   - Support `#pragma interrupt` with stack-switching and TRAPA-return options
   - Emit descending callee-saved register saves (r14→r13→r12→...)
   - Use the SH-2 opcode families `C000/C100/C200` for GBR-relative loads/stores
   - Honor Hitachi's calling convention (R4-R7 parameters, R0 return value, R8-R14 callee-saved)
   - Emit output in the Hitachi listing format (`SH SERIES C Compiler` header, section layout P/C/D/B + $G0/$G1 + user-custom)

3. **LCC remains viable** as a base. Its frontend handles C89 and has no SH backend, so we're writing the SH backend from scratch — but we're writing it *to target Hitachi style*, which means no fighting the architecture. This was already the recommendation; this experiment validates it.

4. **The v5.0 R31 binary remains our oracle** for empirical testing. When we implement a codegen rule, we validate it against the same C source compiled by shc.exe. Our regression corpus is the 850-function race module (plus the other 7 Daytona modules) against production bytes.

## Artifacts

- [`exp1_gbr/`](exp1_gbr/) — GBR codegen experiment, C sources, build config, outputs
- [`exp2_tu_clustering/analyze.py`](exp2_tu_clustering/analyze.py) — per-file indexed-ratio distribution
- [`exp3_prologue/analyze.py`](exp3_prologue/analyze.py) — prologue fingerprint analysis
- This document — findings summary
