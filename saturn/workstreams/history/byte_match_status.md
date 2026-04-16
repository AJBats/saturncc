# Byte-match status — 2026-04-11

Tracking byte-level match progress against Hitachi SHC reference
output for three Daytona CCE functions.

## Session commits (15 total)

| # | Commit | Change | Impact |
|---|--------|--------|--------|
| 1 | 6974853 | Speculative r14 allocation | Callee-saved regs match Hitachi order |
| 2 | b532a79 | Scratch priority r1-first | Scratch regs match FUN_00280710/AF8 |
| 3 | 9361993 | cmp/eq #imm8,R0 | Opcode 88xx matches Hitachi |
| 4 | 7a12b6f | Inline return epilogues | Duplicated rts at each exit |
| 5 | cdfe653 | Literal pool interleaving | Pool entries mid-function |
| 6 | 238ed1e | Arg register propagation | jsr delay slot filled |
| 7 | 43be55d | Redundant mov-r0 + bf/s + word pool | Three peepholes + .short pool |
| 8 | 78d262c | Register coalescing | Collapse mov+add+mov chains |
| 9 | 7f24083 | Flow-aware r0 tracking | Correct label-safe redundant-mov |
| 10 | 7fdecaa | Signed comparisons + pool-add swap | cmp/ge;bf opcodes + mov.w→r0 |
| 11 | 5e1a21d | Eq chain restructuring | Dispatch table + return blocks |
| 12 | da0f5be | Instruction ordering + scratch investigation | extu.b/mov swap |

## Current byte-match scores

| Function | Our bytes | Ref bytes | Matching | Match % | Notes |
|----------|-----------|-----------|----------|---------|-------|
| FUN_06004378 | 100 | 100 | ~83 | **~83%** | int type fix freed r1, 4+ bytes fixed |
| FUN_00280710 | 22 | 26 | 10 | **45%** | |
| FUN_06000AF8 | 30 | 34 | 4 | **13%** | |

## FUN_06004378 — remaining 21 mismatched bytes

### C source fixes (likely Ghidra decompilation errors)

- [ ] **Return block ordering** (2 bytes). Our blocks emit in test
  order (0x22, 0x27, 0x2D, 0x2E). Reference emits 0x27 before
  0x22. Either the original C had if-statements in a different
  order, or it was a switch statement with Hitachi-specific case
  ordering. Try reordering the if-chain in the C source.

- [x] **Unsigned cast creating LOAD** — FIXED (cb8dce3). Changed
  C source to `int c` / `int u`, eliminating the LOAD node.
  Constants now get r1 (first scratch) instead of r2. Second
  constant in each range (0x39, 0x5A) now byte-matches perfectly.
  First constant still r1 vs reference's r3.

### Compiler gaps

- [ ] **Scratch register selection** (8 bytes). We use r2 for all
  comparison constants. Reference uses r3 for range 1 lower bound,
  r1 for range 1 upper bound, r2 for range 2 lower bound, r1 for
  range 2 upper bound. Pattern: cmp/ge constants get descending
  scratches (r3, r2), cmp/gt constants always get r1. Cannot
  replicate without per-expression register hints or Hitachi
  allocator reverse-engineering. Global priority change (r3-first)
  was tested and rejected — it breaks FUN_00280710.

- [ ] **cmp/gt operand encoding** (4 bytes). Downstream of scratch
  register issue. Our `cmp/gt r2,r14` (3e27) vs reference
  `cmp/gt r14,r1` (31e7). Different register pair = different
  encoding of both bytes. Fixes automatically when scratch regs
  match.

### Downstream (auto-fix when above are resolved)

- [ ] **Branch displacements** (10 bytes). All bt/bf/bra offset
  bytes differ because return block ordering and pool position
  shift relative addresses. These auto-correct when layout matches.

## FUN_00280710 — remaining 12 mismatched bytes

### C source fixes

- [ ] **Boolean expression structure** (4 bytes). We compile
  `return dat != 0` as: compute boolean in r14, copy to r0.
  Reference compiles as: write r0 directly in each branch
  (`mov #0,r0` / `mov #1,r0`). The original C may have been
  structured as `return (x != 0) ? 1 : 0` or used a different
  idiom. Try different C formulations to get LCC to target r0
  directly.

### Compiler gaps

- [ ] **Always-FP idiom** (4 bytes). Hitachi SHC always sets up
  r14 as frame pointer with `mov r15,r14` / `mov r14,r15`, even
  when the function has no locals. Our compiler correctly skips FP
  when unnecessary. Would need an `-falways-fp` flag or pragma.
  The FP setup fills the bf/s delay slot in the reference.

- [ ] **bf/s delay slot content** (2 bytes). Downstream of the
  always-FP idiom. Reference puts `mov r15,r14` in the delay slot;
  we put `mov #1,r14`. Fixes if always-FP is implemented.

### Downstream

- [ ] **Pool displacement** (2 bytes). Function size differs (12 vs
  13 insns), so pool sits at different relative offset. Auto-fixes
  when instruction count matches.

## FUN_06000AF8 — remaining 26 mismatched bytes

### C source fixes

- [ ] **Dead `tst r4,r4`** (2 bytes). Reference tests the call
  result but never uses the flag. The original C likely had
  `if (result) ...` or an assignment that Ghidra simplified away.
  Add a dead `if (result)` to reproduce.

- [ ] **Dead `mov r0,r4`** (2 bytes). Reference saves call result
  to r4 before the counter logic. Connected to the dead tst above.
  The original C probably assigned the result to a variable.

- [ ] **Counter signedness** (2 bytes). We emit `exts.b r2,r2`
  (sign-extend). Reference doesn't sign-extend, suggesting the
  counter was `unsigned char` in the original, not `char`.

### Compiler gaps

- [ ] **Argument evaluation order** (8 bytes). Reference loads args
  right-to-left (r6, r5, r4, r3). LCC evaluates left-to-right
  (r4, r5, r6, r1). This is a fundamental LCC design choice in
  how `emitcode()` processes argument nodes. Would require
  changing gen.c's argument emission order.

- [ ] **Function pointer register** (2 bytes). Reference uses r3
  for the function pointer, we use r1. Downstream of scratch
  register priority and arg evaluation order.

- [ ] **Counter register choice** (6 bytes). Reference uses r5/r3
  for counter address/value, we use r1/r2. Register allocation
  difference.

- [ ] **rts delay slot content** (2 bytes). Reference: `mov r4,r0`
  (return saved result). Ours: `mov.b r2,@r1` (counter store).
  Different code shape from different C + register choices.

### Downstream

- [ ] **Various displacements** (2 bytes). Pool offsets differ.

## Priority assessment

**Highest ROI (C source fixes — free wins):**
1. FUN_06004378 return block reordering
2. FUN_06004378 eliminate (int) cast on u
3. FUN_06000AF8 counter signedness (unsigned char)
4. FUN_06000AF8 dead result variable + tst

**Medium ROI (compiler — targeted fixes):**
5. FUN_00280710 always-FP mode
6. FUN_06004378 scratch register per-expression hints

**Low ROI (compiler — deep structural):**
7. FUN_06000AF8 argument evaluation order
8. FUN_06000AF8 register allocation matching

## What "done" looks like

- FUN_06004378: ~90%+ achievable with C fixes + displacement
  auto-correction. 100% blocked by scratch register allocation.
- FUN_00280710: ~80% achievable with always-FP. 100% blocked by
  boolean result targeting.
- FUN_06000AF8: ~30% achievable with C fixes. Fundamentally limited
  by arg evaluation order and register allocation.
