# FUN_06044060 byte-match blockers

Function #001 in the race_FUN_06044060 TU. Current state: 70 diff
lines after the Gap 0 rewrite + normalizer unification (commit
`450eb02`). The remaining gap is backend-level — C-source edits
alone cannot close it. Documenting what we found and what each
gap implies, so the work can be scheduled against the broader
backend backlog rather than chased per-function.

## The three backend gaps

### 1. Save-all-callee-saved prologue / epilogue

**Prod behavior:** SHC emits a **fixed** callee-saved register
save set the moment the function uses *any* callee-saved reg.
Prod's FUN_06044060 only uses r8, r9, r10 (to stash param_2,
param_3, param_4 across the call chain) but saves r8-r14 — all
seven callee-saved registers — in the prologue and restores them
all in the epilogue.

**LCC behavior:** precise usage analysis — saves only the regs it
actually spills to. If it spills three things to r11, r12, r13,
the prologue has three pushes, not seven.

**Diff contribution:** 4 missing pushes + 4 missing pops = 8 lines
minimum, plus downstream register-name mismatches on the saves it
does emit.

**Fix surface:** `src/sh.md` prologue/epilogue emission. Candidates:
- Unconditional "save all callee-saved" pass when *any* r8-r14 is
  used (SHC-style, simplest)
- A pragma (`#pragma sh_preserve_all`) scoped per-function
- Reverse-engineer SHC's actual rule — it may be tied to whether
  the function calls other functions (most Daytona functions do)

### 2. Register allocator priority (low-numbered first)

**Prod behavior:** when it needs callee-saved registers for
spills, picks r8 → r9 → r10 → r11 → ... (lowest numbered first).

**LCC behavior:** picks r11/r12/r13/r14 first. Investigation-worthy
detail: unknown whether this is the LCC core allocator's general
behavior or something about how the SH backend describes its
callee-saved pool.

**Diff contribution:** every `mov rX, rY` save/restore uses
different register numbers between prod and ours. On #001: 3 lines
of param saves + 7 pushes + 7 pops × reg-name differences.

**Fix surface:** almost certainly in `src/sh.md` (the register
classes / priority ordering for callee-saved allocation), or in
the generic `lcc/alloc.c` if LCC has a configurable priority hook.

### 3. In-place literal construction for power-of-two operands

**Prod behavior:** to pass the constants (-0x10000, 0x10000,
0x10000) to FUN_06044F30, prod builds them inline:
```
mov #1, r6       ; r6 = 1
shll16 r6        ; r6 = 0x10000
neg r6, r5       ; r5 = -0x10000
...
mov r6, r7       ; r7 = 0x10000 (in delay slot)
```
Zero pool entries for these constants.

**LCC behavior:** loads the literal values from the constant pool,
one `.long` per unique value (-65536, 65536).

**Diff contribution:** 2 extra pool entries, 2 extra `mov.l LP,rN`
loads, and our constant-construction path doesn't fill the jsr
delay slot with `mov r6,r7`. ~6 lines.

**Fix surface:** lburg peephole or codegen rule. SH-2 specific
optimization — recognize small power-of-2 literals and emit the
`mov #K; shll16/shll8/shll2` sequence instead of a pool load.

### 4. Shim-entry function calls (the fourth, already known)

FUN_060450F2 and FUN_06045006 are not "real" functions — they're
one-instruction shim entries (e.g., `mov r0,r5`) that fall through
into the actual function body. Prod uses these shims to fit the
r0-setup into the jsr delay slot.

Tracked separately — will need an `#pragma entry_alias` mechanism
or equivalent. See `saturn/workstreams/entry_alias.md` (to be
written when that workstream starts).

**Diff contribution on #001:** ~6 lines (2 call sites, ~3 lines
each).

## Estimated gap breakdown (of current 70)

| Gap | Lines |
|---|---:|
| 1. Save-all-callee-saved | ~14 |
| 2. Reg allocator priority | ~10-14 |
| 3. In-place literal construction | ~6 |
| 4. Shim-entry calls | ~6 |
| Small / unclassified | ~30 |

Totals don't sum to 70 because some gaps interact (e.g., fix #1
first and the diff shifts, revealing what #2 actually costs in
isolation).

## Proposed sequencing

1. **Gap #1 first** — simplest, likely highest ROI across the
   whole TU. Every function in the TU that touches callee-saved
   regs has this gap.
2. **Gap #2 next** — once we're saving all 7, allocator priority
   is the remaining reg-name mismatch.
3. **Gap #3** — peephole-local, should be a small focused change.
4. **Gap #4** — entry_alias workstream, larger design effort.

## Non-blocker notes

- FUN_06044060's Ghidra signature says 1 param, but prod treats it
  as 4 params (uses r5, r6, r7 as callee-saved-stashed inputs).
  Attempting to model this in C by declaring 4 params caused
  LCC to emit partial-save-set prologue (r11/r12/r13 saves,
  missing the r8/r9/r10 saves prod does) which made the diff
  *worse* (70 → 85). Deferring signature-accuracy until after
  Gap #1 + #2 land.
- The `add #-48,r4` before the epilogue (prod) is prod preserving
  r4 across the whole function minus the initial +0x30 offset. We
  don't emit this because our C doesn't return r4. Unclear if
  semantically meaningful or SHC-artifact.
