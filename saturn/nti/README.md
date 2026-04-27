# NTI — New Technology Integration

This directory holds research notes for compiler / analyzer
features we've identified as needed but haven't yet shipped.
Each file describes one feature in enough depth that a fresh
session can pick it up and execute without rebuilding the
investigation from scratch:

- **what** the feature is, in plain programming terms;
- **why** we need it (concrete corpus case that motivates it);
- **literature / open-source references** that show the technique
  is standard, not invention;
- **how it would integrate** into our existing compiler shape
  (saturncc's Phase A / sh_sim / Shape 2 plumbing);
- **what we'd validate** end-to-end to know it landed correctly;
- **scope honestly stated** — what's bounded, what isn't, what
  open questions remain.

These are *design parking lots*, not specs. The spec emerges
when we pick one up and walk through it with the user.

## Naming

Each file is `<topic>.md`. Topics cluster around a single
analyzer or codegen capability — not a single bug or function.
If a feature has sub-features, they go inline in the same file
under headers, not as separate files, so the design context
travels together.

## Provenance

Most entries originate from a debugging session where we hit a
gap, traced it carefully (often with retail-debugger probes),
and decided the gap was a real feature rather than a one-off.
Each file should cite the conversation / commit / probe doc
that produced it.

## Promotion to active work

When we adopt one of these, the file moves to
`saturn/workstreams/` with a status header and gets owned by the
session driving it. Until then it lives here as reference.

## Index

- [`path_sensitive_walker.md`](path_sensitive_walker.md) —
  extending sh_sim's branch handler so the abstract state
  carries the constraint implied by the branch condition. Makes
  branches whose conditions are locally pinned (constant
  comparisons, dt counters, etc.) take only the actually-reachable
  path. Prerequisite for the next feature.
- [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md) —
  the feature that would close the FUN_060457DC gap on
  FUN_06044060: each function gets an input/output predicate
  summary, callsites pass their callers' guarantees in, the
  function-under-analysis sees a refined starting state. Needed
  because FUN_060457DC's r4-writing exit is gated on a global
  read whose value depends on what the caller's caller's caller
  set up.
