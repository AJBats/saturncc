# Register pinning across calls — IPA-derived caller-save semantics

## Status

Stub. **TODO finish design.** Analyzer prerequisites already drafted at
[`path_sensitive_walker.md`](path_sensitive_walker.md) and
[`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md).

## What this is, in plain terms

Standard SH-2 calling convention: r4..r7 are caller-saved (volatile
across calls); r8..r14 are callee-saved (callee preserves them).

SHC's same-TU calling convention is more aggressive: the compiler
performs whole-TU analysis and sometimes determines that a callee
*also* preserves a caller-saved register (e.g., r4 across a specific
`jsr`). Callers exploit this by leaving live values in r4..r7 across
calls without saving — *only* for calls into same-TU functions where
the analysis proved preservation.

The result is fewer stack pushes/pops at hot call sites, at the cost
of needing whole-TU knowledge to verify the preservation.

## Why we need it: corpus evidence

**Cat 6 of the SHC annotation census — 10% of the race module** (~83
functions). Concentrated in the largest TUs (FUN_06044060.s,
FUN_0603C304.s, FUN_060351CC.s) where SHC had the most
cross-function visibility.

Without IPA pinning support:

- Lifted C compiles to standard caller-save convention; every live
  caller-save value gets pushed before each call.
- Byte-match diverges (extra pushes).
- More importantly: editing a TU member that *was* preserving r4 to a
  version that no longer preserves it would silently break callers
  that relied on the preservation. **This is one of the
  hard-to-detect-error classes** that justifies implementing the
  feature properly rather than leaving as `__asm`.

## Important: derive, don't annotate

Per user feedback (memory: `feedback_derive_dont_annotate`),
cross-function properties like "preserves r10 across this call" come
from **parsed IR analysis, not hand-written `#pragma`**. The
analyzer reads the callee's body and derives the preservation fact;
the caller consults the derived fact and routes registers
accordingly.

This means IPA register pinning is **not a new pragma**; it's an
analyzer feature that the existing instruction selector and allocator
consult.

## How it integrates

- **Analyzer prerequisites:**
  [`path_sensitive_walker.md`](path_sensitive_walker.md) gives the
  abstract execution that follows actually-reachable branches.
  [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md)
  gives per-function input/output predicate summaries that propagate
  callee-preservation facts to callers.
- **Allocator consumes the summary.** Where today it sees "this is a
  caller-save register, must spill across the call," it will see
  "this is a caller-save register, but the callee's summary says it
  preserves it; treat as callee-save for this call site."
- **TU boundary**: facts derived from same-TU bodies. Cross-TU calls
  fall back to standard convention. Whole-program LTO is out of
  scope.

## TODO finish design

- Define the summary format: per-callee, which registers are
  preserved across the call.
- Define the propagation algorithm: presumably fixpoint over the
  call graph, since A's preservation set depends on what A's
  callees preserve.
- Define how the allocator queries summaries (lookup function in
  the `gen.c` ralloc path).
- Define what happens on summary mismatch — e.g., the analyzer says
  callee preserves r10 but the callee body actually clobbers r10.
  Hard error or silent miscompile?
- Decide on incremental analysis: TU change recomputes the affected
  summaries, not the whole graph.

## Cross-references

- [`path_sensitive_walker.md`](path_sensitive_walker.md) — branch-aware
  abstract execution prerequisite.
- [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md)
  — per-function summary infrastructure prerequisite.
- [`nonstandard_register_conventions.md`](nonstandard_register_conventions.md)
  — sister feature for function-signature-level non-standard register
  use (annotation-driven, vs IPA pinning's analysis-driven).
- [`gap_catalog.md`](../workstreams/gap_catalog.md) Gap 1B — partial
  motivation; full closure requires this feature.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. References existing analyzer prerequisite docs. |
