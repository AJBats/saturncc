# Session handoff — 2026-04-12 (session 2)

## What happened this session

4 commits advancing the SH-2 backend toward Hitachi SHC byte-matching:

### e1bd7b8 — muls.w via core LCC mul_src_width
Threaded pre-promotion operand width through LCC core (c.h → enode.c
→ dag.c) so the backend automatically emits `muls.w` when either
multiply operand originated from a type ≤ 2 bytes. No pragma needed —
normal C with `short` types produces the right instruction. This is a
principled core change, not a backend hack.

### bf6c039 — Fix && crash + validate_build.sh
Fixed segfault in emit2's cmp/eq #imm handler when the same constant
appears in a short-circuit && chain. LCC CSEs the constant into a
VREG; emit2 now follows the CSE pointer to recover the value.

Added `saturn/tools/validate_build.sh` — pre-commit gate that builds,
compiles all experiments, checks .s stability vs HEAD, and runs
regression tests. Rule in `.claude/rules/validate-before-commit.md`
requires it before every commit.

### 4fc53d7 — validate-before-commit rule

### 23f59e6 — braf jump table dispatch
Added `switchjump` target hook to LCC's Interface (c.h, stmt.c). The
SH-2 backend implements it to emit the Hitachi SHC braf dispatch:

```asm
shll r0           ; index * 2
mov  r0,r1
mova table,r0
mov.w @(r0,r1),r0
braf r0
nop
table:
.short case0 - table
...
```

Exact opcode match to FUN_06037E28's reference dispatch sequence.
Proven on switch_test.c. Blocked from use in FUN_06037E28 by the
crash below.

## Active blocker: switch + register argument crash

### Minimal reproducer
```c
extern void stub0(int);
extern void stub1(int);
extern void stub2(int);
extern void stub3(int);
extern void stub4(int);

int test(int state, int x) {
    switch (state) {       // 5 cases → table dispatch
    case 0: stub0(x); break;
    case 1: stub1(x); break;
    case 2: stub2(x); break;
    case 3: stub3(x); break;
    case 4: stub4(x); break;
    }
    return 0;
}
```

### What works / what doesn't
- `stub0(42)` (constant arg) — **works**
- `stub0()` (void, no args) — **works**
- `stub0(x)` where x is a param — **crashes**
- `stub0(state)` (switch var as arg) — **crashes**
- 3 cases (if-else mode, no table) with param arg — also **crashes**

### Diagnosis
The crash kills the entire WSL instance (SIGTERM/exit 15). It's
**pre-existing** — happens on the original compiler before any session
changes. The crash is in `gencode()` → `gen()` during instruction
selection/register allocation. The `ARG+I` node's `rtarget` (targeting
the argument to r4) conflicts with the switch dispatch machinery
when the argument is a register variable (not a constant).

GDB can't attach because the crash takes out the whole process. ASAN
also gets killed. The stack was confirmed not to be the issue (static
buffers, unlimited stack size tested).

### Likely root cause
In `gen.c`, `rewrite()` calls `prelabel()` → `target()` which sets
`rtarget` on ARG nodes. For 4+ case switches, the switch variable is
in a register that also needs to survive across the table dispatch.
When an argument also references a register, the combination of
rtargets creates an unresolvable conflict in `ralloc()`, causing
infinite looping or stack overflow in the register spiller.

### Suggested approach
1. Build with `-g -O0` and use `ulimit -s unlimited` + `ulimit -v 500000`
   (limit virtual memory to catch the crash before it kills WSL)
2. Check if `ralloc()` in gen.c enters an infinite spill loop
3. The fix may require adding a `JUMPV(reg)` rule to the backend as
   an alternative to the switchjump hook — letting gen.c handle the
   table dispatch through normal register allocation instead of
   bypassing it

### Key file for reproducing
`saturn/experiments/daytona_byte_match/race_tu1/crash_repro.c`

## FUN_06037E28 status

The C source has: prologue, multiply (muls.w), struct pointer,
secondary pointer load, early return for state==10, pre-switch guard
(states 6/7/8 bypass with && conditions). Switch body is blocked by
the crash above.

## Files modified this session
- `src/c.h` — mul_src_width field, switchjump hook
- `src/enode.c` — capture operand width in multree()
- `src/dag.c` — carry mul_src_width through DAG
- `src/stmt.c` — call switchjump hook from swcode()
- `src/sh.md` — muls.w emit, MACL save/restore, && CSE fix, braf
  dispatch, static peephole buffers
- `saturn/tools/validate_build.sh` — pre-commit validation
- `.claude/rules/validate-before-commit.md`
