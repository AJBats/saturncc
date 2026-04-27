# NTI: Path-sensitive walker

## What it is

Today the symbolic simulator (`src/sh_sim.c`), at any conditional
branch (`bt`, `bf`, `bt/s`, `bf/s`), walks BOTH the taken and the
fall-through paths from the same abstract state. It's correct in
the "did anything ever write r4?" question but it's pessimistic
when one of the two paths is actually unreachable given the
state we already have.

The path-sensitive variant attaches the branch's *condition* to
the path's state as a constraint. When we walk the taken side,
the state carries "the comparison succeeded." When we walk the
fall-through, the state carries "the comparison failed." Later
operations on the constrained registers either:

- Strengthen what's known about a register the constraint pins,
  improving downstream precision, or
- Detect a contradiction with another constraint, marking the
  path as infeasible and abandoning it without recording its
  rts as a real exit.

## Why we need it

In the current corpus, two known cases motivate it:

1. **dt-loop counters whose value is guaranteed by the loop
   itself.** Our dt-loop recognizer already handles the typical
   shape, but more complex variants (loop with an early-exit
   `bt` branch on a value the loop body assigns) get marked
   conservative because the simulator can't prove the early-exit
   doesn't fire.

2. **Functions with locally-determined `cmp/eq` branches.**
   Sequences like `mov #1, r0; cmp/eq r0, r1; bt label` where
   `r1` was just set to a known constant route deterministically.
   The simulator currently walks both paths.

Neither of these closes the FUN_06044060 e2e proof on its own;
that requires the inter-procedural predicate summaries described
in [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md).
But path-sensitivity is a *prerequisite* for that work and
strengthens the analyzer broadly.

## Literature / reference material

The technique is standard in abstract interpretation. The cleanest
single reference for the foundations is:

- **Cousot & Cousot, "Abstract interpretation: a unified lattice
  model for static analysis of programs by construction or
  approximation of fixpoints," POPL 1977.** The original paper
  defining the framework. The constraint-state extension is a
  natural application of the framework's "abstraction function"
  with conditional refinement.

For path-sensitive single-function analyzers in production:

- **SPARTA (Meta)** — `github.com/facebook/SPARTA`. The
  `MonotonicFixpointIterator` and the abstract-domain interfaces
  cleanly support per-edge state refinement. SPARTA's docs walk
  through "interprocedural constant propagation" which is the
  same shape of analysis we'd want.
- **Crab (SeaHorn)** — `github.com/seahorn/crab`. Includes
  reference implementations of intervals, octagons, and zones
  domains, all of which support path constraints natively.
- **IKOS (NASA)** — `github.com/NASA-SW-VnV/ikos`. Used for C/C++
  static verification; same lineage.

For the specific predicate-tracking shape we'd want (Boolean
facts pinned by branches, simplified at re-assignment):

- **Graf & Saïdi, "Construction of abstract state graphs with
  PVS," CAV 1997** — the predicate-abstraction founding paper.
- **Henzinger, Jhala, Majumdar, Sutre, "Lazy abstraction," POPL
  2002** — BLAST's approach. Predicates are tracked per-program-
  point, refined on demand.

For the SH-2 specifics — there's no SH-2-specific compiler
literature on this; we rely on the architecture-agnostic results
above and our own per-mnemonic transfer functions.

## How it integrates

### Data model change

`struct sh_state` already carries register abstract values. We add:

```c
struct sh_constraint {
    enum sh_constraint_kind kind;  /* EQ, NEQ, LT, GE, ... */
    int reg_a;                      /* register operand */
    int reg_b;                      /* second register, or -1 for imm */
    long imm;                       /* immediate, when reg_b == -1 */
};

struct sh_state {
    struct sh_av r[16];
    struct sh_stack_slot stack[64];
    int n_stack;

    /* NEW */
    struct sh_constraint constraints[8];
    int n_constraints;
};
```

Constraint capacity is small (8) by intent. Once we hit capacity
we drop the oldest constraint — we want refinement, not a SAT
solver.

### Per-comparison constraint generators

SH-2 has ~10 comparison instructions. Each maps to one or two
constraint kinds:

| Mnemonic | T-set when | Constraint on T-taken path |
|---|---|---|
| `cmp/eq Rm, Rn` | Rm == Rn | EQ(Rm, Rn) |
| `cmp/eq #imm, R0` | R0 == imm | EQ_IMM(R0, imm) |
| `cmp/hs Rm, Rn` | Rn >= Rm (unsigned) | UGE(Rn, Rm) |
| `cmp/ge Rm, Rn` | Rn >= Rm (signed) | SGE(Rn, Rm) |
| `cmp/hi Rm, Rn` | Rn > Rm (unsigned) | UGT(Rn, Rm) |
| `cmp/gt Rm, Rn` | Rn > Rm (signed) | SGT(Rn, Rm) |
| `cmp/pl Rn` | Rn > 0 | SGT_IMM(Rn, 0) |
| `cmp/pz Rn` | Rn >= 0 | SGE_IMM(Rn, 0) |
| `tst Rm, Rn` | (Rm & Rn) == 0 | AND_ZERO(Rm, Rn) |
| `dt Rn` | Rn-1 == 0 (i.e. Rn was 1) | EQ_IMM(Rn_post, 0) |

Each comparison instruction's transfer function records the
*pending* constraint on the state. The next branch instruction
consumes it: the taken-path state inherits the constraint, the
fall-through inherits its negation.

### Branch handler change

Today's `walk()` in sh_sim.c clones state at branches and walks
both. The change:

1. After a comparison instruction sets the pending constraint,
   the `bt` / `bf` / `bt/s` / `bf/s` handler:
   - Computes the taken state by adding the constraint (or its
     negation, for `bf`) to a clone of the current state.
   - Runs constraint simplification on the new state. If
     contradicted, abandon the path and don't recurse.
   - Clones the fall-through state with the opposite constraint.
2. The constraint travels with the state through the visited-set
   key, so the same instruction reached on differently-constrained
   states is analyzed separately.

### Constraint simplification

Two fold rules to start:

1. **Constant + equality**: if state has `reg = AV_CONST(K)` and
   constraint says `EQ(reg, K')` then either fold to "no new info"
   if K==K' or "infeasible" if K!=K'.
2. **Constraint on a register that just got reassigned**: drop
   any constraint whose `reg_a` or `reg_b` was the destination
   of the most recent transfer. Stale constraints are unsound.

We do NOT do general SMT simplification. We do not chain
constraints arithmetically. The goal is to prune obviously-
infeasible paths, not prove arbitrary theorems.

### Validation gate

Three new regtests:

1. **dt-with-known-counter**: a function shaped
   `mov #1, rN; tst rN, rN; bt skip; <r4-write>; skip: rts`.
   Today: `writes_r4=1`. After: `writes_r4=0` (the bt always
   fires, the write is unreachable).

2. **cmp-eq pinned**: a function with `mov #5, r0; cmp/eq #3, r0;
   bt unreachable; <preserves r4>; rts; unreachable: <writes r4>;
   rts`. Today: `writes_r4=1`. After: `writes_r4=0`.

3. **constraint-survives-call**: a function with a constraint
   pinned, then a `bsr` to a callee whose oracle says preserves-r4
   but might clobber other registers. The constraint on r4 should
   survive the call (because the callee preserves r4); constraints
   on caller-saves should be dropped.

Plus all 51 existing regtests must stay green.

## Scope honestly

What this gives us:
- More functions in the corpus that the analyzer can prove
  preserves-r4 / writes-r4 precisely.
- Foundation for inter-procedural summaries (each summary's
  postcondition is a constraint set).
- Generally tighter abstract states throughout walks.

What this does *not* give us:
- It does NOT close FUN_06044060's e2e proof. The branch in
  FUN_060457E4's body reads from a global (`gbr+136`) whose
  value depends on the caller's caller's setup. Single-function
  path-sensitivity has nothing local to constrain that read.
- It does NOT add SMT-grade constraint solving. We won't be
  able to prove arbitrary theorems about constraint sets; we'll
  only catch the obvious infeasibilities.

## Open questions

- Which comparison instructions cover the corpus's actual usage?
  An audit of the unity build's `cmp/*` and `tst` distributions
  would tell us which transfer functions to prioritize.
- How many constraints typically accumulate? We've capped at 8;
  if real corpus paths regularly hit that, we'd need to widen
  or be smarter about which to keep.
- Should the visited-set key include constraint sets, or is
  state-equality enough? Including them is sound but state-space-
  blowing; excluding them risks merging infeasible-with-feasible
  paths. Probably include initially and tune if visited-cap
  becomes a problem.

## Provenance

Surfaced during the 2026-04-27 session that closed the writes_r4
→ Shape 2 codegen pipeline on the saturncc master branch.

A retail-debugger probe (Mednafen, Daytona CCE Japan, fresh boot,
in-race scripted scenario) confirmed that FUN_060457DC's
r4-writing exit at `.L_06045820` is hit 586 times across various
call stacks during the run but **zero** times from FUN_06044060's
call stack — the path is real but unreachable on this caller's
specific runtime preconditions. The conditions that gate it are
caller-context-derived (the dispatcher chain
FUN_06029A78 → FUN_06043384 → FUN_06044060 sets up state that
forces FUN_060457DC's body to take the r4-preserving exit).

Our analyzer can't prove this without path-sensitivity (this
file) and inter-procedural summaries (companion file). The
session ended by parking the FUN_06044060 e2e proof here as
NTI work and pivoting to other targets.
