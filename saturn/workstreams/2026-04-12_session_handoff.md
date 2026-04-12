# Session handoff — 2026-04-12

## What happened this session

22 commits taking the SH-2 backend from instruction-count matching
to near-perfect byte matching on 3 Daytona CCE functions:

- FUN_06004378 (backup): 98/100 bytes match (98%)
- FUN_00280710 (main): 23/26 bytes match (88%)
- FUN_06000AF8 (backup): 29/34 bytes match (85%)

All remaining mismatches are pool displacement bytes from compiling
functions in isolation (TU context). Every instruction opcode
matches the Hitachi SHC reference byte-for-byte.

## Major backend changes made

1. **Speculative r14 allocation** — widened INTVAR to include r14,
   with post-peephole rename when FP conflicts arise
2. **Scratch register priority** — custom wildcard array (ireg_prio)
   for Hitachi-matching allocation order
3. **cmp/eq #imm8,R0** — immediate compare opcode 88xx with rtarget
4. **Inline return epilogues** — duplicated rts at each exit point
5. **Literal pool interleaving** — mid-function pool placement at
   dead zones, with 3rd-to-last heuristic for eq-chain position
6. **Arg register propagation** — rtarget through CVI/CVU/INDIR
   chains for jsr delay slot fill
7. **Signed comparison rules** — LTI4/LEI4 use cmp/ge;bf form
8. **Word pool** — .short entries for 16-bit constants via mov.w
9. **Eq chain restructuring** — dispatch table + gathered return
   blocks with swapped first-two-block ordering
10. **Boolean FP rewrite** — bf/s + mov r15,r14 always-FP pattern
11. **Pre-call arg reordering** — descending register order body
    buffer rewrite to match right-to-left evaluation
12. **Result-to-arg-reg** — rename callee-saved result to freed r4
13. **Post-call counter rewrite** — r5/r3 register reuse + tst
    interleaving
14. **Range register diversification** — r3/r2/r1 cycling for
    comparison constant registers
15. **Dead branch/extension elimination** — peepholes for empty
    if-bodies and byte load-add-store patterns
16. **Multiply + shift** — mul.l, shll, shll2, shlr, shar rules
17. **Function pointer targeting** — rtarget CALL kid to r3

## Files modified

- `src/sh.md` — the backend (main edit target, now ~3100 lines)
- `src/gen.c` — NOT modified (all changes through backend hooks)
- `saturn/experiments/daytona_byte_match/` — C sources + outputs
- `saturn/experiments/daytona_byte_match/race_tu1/` — new TU target
- `saturn/workstreams/byte_match_status.md` — tracking doc

## Where we left off

Started FUN_06037E28 from the race module — a 232-line function
in a 4-function TU at `D:/Projects/DaytonaCCEReverse/mods/transplant/race/FUN_06037E28.s`.

First compile of the C skeleton shows gaps:

1. **muls.w missing** — reference uses 16-bit signed multiply
   (muls.w Rm,Rn; sts macl,Rd). We emit mul.l (32-bit). Need a
   rule that fires when operands fit in 16 bits, or when the C
   uses short types.

2. **MACL save/restore** — reference saves/restores MACL in
   prologue/epilogue (sts.l macl,@-r15 / lds.l @r15+,macl). Our
   prologue doesn't handle MACL. Need to detect when MACL is used
   and add save/restore.

3. **Param stack spill** — reference spills param_1 to stack
   before the jsr call (mov.b r4,@r15), then reloads after
   (mov.b @r15,r14). Our code uses the jsr delay slot to copy
   param to r14. The reference can't do this because it calls
   setup_func first, then computes the struct pointer.

4. **The switch body** — 10 cases with complex control flow,
   function pointer calls, struct field modifications. Ghidra C
   at `D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06037E28.c`.

5. **Functions 2-4 in the TU** — FUN_06037FD6, FUN_06038202,
   FUN_0603833C share callee-saved registers set by FUN_06037E28.
   Need to understand the calling convention between them.

## Critical project context

**Byte matching is binary — 100% or nothing.** There is no partial
credit. The entire LCC codebase is fair game for modification
(gen.c, dag.c, etc.), not just the backend in sh.md. When hitting
an LCC design limitation, modify LCC itself.

## Key files to read

- `saturn/workstreams/byte_match_status.md` — detailed gap analysis
- `saturn/experiments/daytona_byte_match/race_tu1/FUN_06037E28.c` — current C skeleton
- `D:/Projects/DaytonaCCEReverse/mods/transplant/race/FUN_06037E28.s` — reference asm (954 lines)
- `D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06037E28.c` — Ghidra decompiled C
