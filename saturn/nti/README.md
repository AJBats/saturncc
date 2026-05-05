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

### Bucket A — must-implement compiler features (editable-decomp roadmap)

These are the language-level features SHC offered (some documented, some
inferred from corpus evidence) that we must implement so the
~translation-blocking cases can lift to C. The list comes from
partitioning the [SHC annotation census](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md)
under the editable-decomp framing (2026-05-05) — see also
[`saturn/workstreams/gap_catalog.md`](../workstreams/gap_catalog.md) and
the conversation that landed in this repo's recent commit reframing.

- [`multi_entry_functions.md`](multi_entry_functions.md) — **A1.**
  Functions with multiple `.global` entry symbols sharing one body.
  27% of the race module. Full design folded in from the
  retired `entry_alias_design.md`. **Highest priority.**
- [`fallthrough_functions.md`](fallthrough_functions.md) — A5.
  Functions with no `rts` that fall through into the next function.
  13% of corpus. Stub.
- [`gbr_base_addressing.md`](gbr_base_addressing.md) — A2. SHC's
  `#pragma gbr_base` / `gbr_base1` for short-form GBR-relative globals.
  Largest documented annotation category. Stub.
- [`global_register_pinning.md`](global_register_pinning.md) — A3.
  SHC's `#pragma global_register` to bind a global C variable to a
  specific SH-2 register TU-wide. Stub.
- [`save_strategy_pragmas.md`](save_strategy_pragmas.md) — A4.
  `#pragma noregsave` / `regsave` / `noregalloc` family — invert
  the default to SHC's `[lowest_written..r14]` shape. Existing
  partial implementation in `saturn/workstreams/save_strategy_and_asm_intrinsic.md`.
  Stub here.
- [`register_pinning_ipa.md`](register_pinning_ipa.md) — A6. IPA
  caller-save semantics derived from analyzer summaries (NOT new
  pragmas — `feedback_derive_dont_annotate`). Stub; analyzer
  prerequisites already drafted.
- [`nonstandard_register_conventions.md`](nonstandard_register_conventions.md)
  — A8. Function-signature annotations for non-standard arg/return
  registers. Stub.
- [`mac_unit_sr_intrinsics.md`](mac_unit_sr_intrinsics.md) — A7.
  C-source expressivity for `mac.l`, `dmuls.l`, `sts macl/mach`,
  `clrmac`. Stub.
- [`r0_shim_calling_convention.md`](r0_shim_calling_convention.md)
  — A9. 1st-arg-in-r0 calling convention. Lowest priority; may merge
  into A8. Stub.

### Analyzer prerequisites for A6

- [`path_sensitive_walker.md`](path_sensitive_walker.md) —
  extending sh_sim's branch handler so the abstract state carries
  the constraint implied by the branch condition. Makes branches
  whose conditions are locally pinned (constant comparisons, dt
  counters, etc.) take only the actually-reachable path.
  Prerequisite for the next entry.
- [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md) —
  per-function input/output predicate summaries, callsites pass
  their callers' guarantees in, the function-under-analysis sees a
  refined starting state. Needed because some r4-writing exits are
  gated on global reads whose values depend on caller-of-caller
  state. The substrate for A6 register pinning.
