# NTI: Inter-procedural predicate summaries

## What it is

Each analyzed function gets a *summary*: a structured object that
captures, in compact form, the function's input/output behavior
in terms the analyzer can carry across calls. Today's `writes_r4`
verdict is the simplest possible summary — one Boolean per
function. The full version is richer:

```
Summary {
    inputs:    constraints we assume hold on entry (precondition)
    clobbers:  registers / memory the function may write
    outputs:   constraints that hold on exit (postcondition)
    exits:     per-exit-block summaries when the function has
               multiple exit shapes
}
```

When a caller analyzes a call site, it:
1. Provides the callee with its own current state's constraints
   as the callee's input precondition.
2. Receives the callee's exit summary back, refined for that
   precondition.
3. Continues with its own state updated per the summary's
   clobbers and outputs.

A function with two exit shapes (one r4-writing, one r4-preserving)
gets two exit summaries. The caller picks the one whose entry
precondition matches the call site's actual state.

## Why we need it

This is the technique that closes the FUN_06044060 e2e proof.

FUN_060457DC has two exit blocks visible to static analysis:
- `.L_06045820`: writes r4 from a memory load (reachable from
  some callers).
- The unlabeled rts at function tail: preserves r4 (reachable
  from FUN_06044060).

The branch that selects between them, `cmp/hs r1, r0; bt
.L_06045820`, depends on `r0`/`r1` derived from `*(gbr+136)`.
Whether the branch is taken depends on what the caller's caller
set up in that global slot.

Single-function path-sensitivity (see
[`path_sensitive_walker.md`](path_sensitive_walker.md)) can't
prove the bt doesn't fire because it sees `*(gbr+136)` as
unknown. It needs to receive a precondition from FUN_06044060's
analysis — which itself needs a precondition from FUN_06044060's
caller (FUN_06043384, with its specific dispatcher logic) — etc.

Predicate summaries are how that precondition propagates across
call boundaries.

A retail-debugger probe in the same 2026-04-27 session confirmed
this: `.L_06045820` is hit 586 times during a recorded run from
various call stacks but zero times from FUN_06044060's call
stack. The condition that gates `.L_06045820`'s reachability is
caller-dependent. A path-sensitive intra-procedural analyzer
sees both paths as feasible; a predicate-summary analyzer
distinguishes the call sites.

## Literature / reference material

This is the central technique in modern interprocedural verifiers:

- **Sharir & Pnueli, "Two approaches to interprocedural data flow
  analysis," in *Program Flow Analysis: Theory and Applications*,
  1981.** The foundational framing: functional vs. call-string
  approaches. Predicate summaries are the functional approach.
- **Reps, Horwitz, Sagiv, "Precise interprocedural dataflow
  analysis via graph reachability," POPL 1995.** The IFDS
  framework — graph-based summary computation that's both
  precise and tractable. The technique generalizes to IDE
  (inter-procedural distributive environments) for richer
  summary domains.
- **Ball, Majumdar, Millstein, Rajamani, "Automatic predicate
  abstraction of C programs," PLDI 2001.** The SLAM project at
  Microsoft Research. Practical predicate-summary computation
  for C, used in production for Windows Driver Verifier. The
  summary structure described here is essentially SLAM's.
- **Henzinger, Jhala, Majumdar, Sutre, "Lazy abstraction," POPL
  2002.** BLAST. Same ideas as SLAM but with on-demand
  refinement — predicates are added only as they're needed for
  a query, not enumerated up front.
- **Cousot & Cousot, "Modular static program analysis,"
  Compiler Construction 2002.** The modularity / separate-
  compilation angle. Argues for summaries as the bridge between
  per-function analysis and whole-program reasoning.

For open-source implementations:

- **SPARTA's interprocedural framework** — extends the per-function
  fixpoint iterator to compute summaries with a worklist over the
  call graph. The same shape we'd want.
- **Crab's `path-based-analyzers`** — implements path-sensitive
  + summary-based analysis for LLVM IR. Closer to a working
  reference than the papers.
- **CodeQL's data-flow library** — computes interprocedural
  summary-based reachability at scale on real codebases. The
  performance engineering is instructive even if the analysis
  domain differs.

## How it integrates

This is a structural shift; not a small extension. Outline:

### Phase A becomes summary-driven

Today: `sh_analyze_writes_r4` walks `sh_scc_order` reverse-topo,
sets each entry's `writes_r4`. One Boolean per function.

After: same walk order, but each entry produces a summary object
instead of a Boolean. Summary contains:

```
SHFnSummary {
    /* The set of register-state constraints we'll assume on
     * entry (or "no preconditions" = analyze in maximally-
     * general state). */
    preconditions: [SHConstraint]

    /* For each exit (rts) the function reaches, what's the
     * exit state's relationship to entry state? */
    exits: [
        SHExit {
            /* What constraints on entry state make this exit
             * the reachable one? Empty = always-reachable. */
            entry_conds: [SHConstraint]

            /* Register-by-register exit value: preserved /
             * clobbered / set to a specific abstract value. */
            r_effects: [16] of (PRESERVED | CLOBBERED | CONST(K))

            /* Memory effects (clobbers, optionally with known
             * values). */
            mem_effects: [SHMemEffect]
        }
    ]
}
```

`writes_r4` is recovered as: "is there any exit with `r4` not
PRESERVED?" — but the summary carries strictly more information.

### Per-call-site summary application

When the simulator (or Phase A's mixed-body walker) hits a
`bsr label` or pool-load + `jsr`, it:

1. Looks up the callee's summary by name.
2. Computes the call site's *current* state's constraints.
3. Filters the callee's exits to those whose `entry_conds` are
   consistent with the call site's constraints. (If only one
   exit's conditions are consistent, that exit's effects apply.
   If multiple, take the meet of their effects.)
4. Updates the call site's state per the chosen effects.

For FUN_06044060 calling FUN_060457DC: the call site's state
has `r4 = obj = p1+0x30`, `*(gbr+136)` unknown. FUN_060457DC's
summary has two exits; one gated on `r0 >= r1` (the r4-writing
one) and one on `r0 < r1`. Without further refinement, both
are consistent with the call site's state, so we still take
the meet (= conservative `writes_r4=1`).

To close the gap, FUN_06044060 itself needs to be analyzed
with the precondition propagated from FUN_06043384, which
forwards `r0=0, r1=0xE1` setup, etc. The full call chain's
precondition narrows enough to make only one of FUN_060457DC's
exits consistent.

This is the **call-string** view: precondition is constructed
along the call path, not in isolation per function.

### Worklist / fixpoint

Reverse-topo single pass works for `writes_r4` (no recursion
in our corpus). For richer summaries, mutually-recursive
functions need fixpoint iteration: start each function with the
weakest summary (no constraints, all clobbers), iterate until
no summary changes. The worklist tracks which functions need
re-analysis based on which other summaries changed.

Our corpus has limited recursion (the unity build's race module
is mostly DAG-shaped with a few feedback loops). The worklist
overhead is bounded.

### Validation gate

Several new regtests:

1. **Per-exit summary basic**: a function with two `rts` blocks,
   one preserving r4 and one clobbering. Confirm the summary
   has two exits with distinguishable effects.

2. **Caller picks the right exit**: a function calling the above
   with state that pins one of the two exit conditions. Confirm
   the analyzer takes only that exit's effects.

3. **Mutually recursive functions converge**: synthetic A↔B
   recursion. Confirm fixpoint terminates and produces a sound
   summary for each.

4. **FUN_06044060 e2e**: with the unity build lift in place and
   the chain of preconditions from FUN_06029A78 → FUN_06043384
   → FUN_06044060, confirm FUN_060457DC's call site is analyzed
   with a state that pins it to the r4-preserving exit. Shape 2
   fires. `make -C decomp validate` byte-matches retail.

This last regtest is the closure of the e2e proof we paused on.

## Scope honestly

What this gives us:
- A genuine inter-procedural analyzer where call-site context
  matters. Different callers of the same function can get
  different verdicts on whether r4 is preserved.
- Foundation for many future analyses: clobber narrowing
  per call site, MAC/GBR-state tracking with caller context,
  alias analysis sketches, etc.
- Closes FUN_06044060 specifically and any other function whose
  callee preservation depends on caller-supplied invariants.

What this does *not* give us:
- It does NOT do general SMT-style reasoning. Summary fold rules
  are local and specific.
- It does NOT model the heap (memory beyond the stack frame
  shadow). Functions whose preservation depends on heap-state
  invariants stay opaque.
- It does NOT bound analyzer cost as tightly as the current
  forward walk. A naive worklist on 852 functions with rich
  summaries could blow up; we'd want call-graph SCCs and
  per-SCC fixpoint iteration to keep it bounded.

## Open questions

- **Summary granularity.** Per-rts is one design point; per-
  basic-block-on-the-exit-frontier is another (more precise,
  more expensive). Start with per-rts and refine if we hit a
  case that needs the finer grain.
- **Constraint domain.** We're using the same constraint kinds
  as the path-sensitive walker. If summaries need richer
  predicates (e.g., "register is one of {0, 1, 2}"), we'd
  extend the domain. Defer until we see an actual case.
- **Cost model.** What's the wall-clock cost of computing all
  852 summaries vs. today's per-function `writes_r4`? Probably
  fine but we should measure once we have a working impl.
- **Cache invalidation across compiles.** Summaries are derived
  from the parsed asm IR; they're naturally per-compile. No
  on-disk cache needed.

## Prerequisites

- [`path_sensitive_walker.md`](path_sensitive_walker.md). The
  per-instruction transfer functions for constraints are needed
  before summaries can carry them.
- A small upgrade to the IPA queue infrastructure to hold
  summary objects (currently it holds a single `writes_r4` int).

## Provenance

Same 2026-04-27 session as `path_sensitive_walker.md`. The
runtime probe (Mednafen, retail Daytona CCE Japan, fresh boot,
synthesized in-race scripted scenario) established that the gap
between static and runtime behavior on FUN_06044060's
FUN_060457DC call site is purely a function of caller-supplied
preconditions — exactly the gap predicate summaries are designed
to close. The summary-based analyzer is the principled answer to
the runtime probe's findings.
