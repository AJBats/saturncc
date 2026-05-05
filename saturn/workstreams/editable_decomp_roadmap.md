# Editable-decomp roadmap

Master rollup for the editable-decomp project. Tracks status of every item
across Bucket A (must-implement features), Bucket B (normalizer
transformations), Bucket C (Tier 3a `__asm` safety), and Bucket D
(cross-cutting infrastructure). Format modeled on
`methodology_remediation.md` — rollup table is the canonical state, narrative
sections are detail, progress log appended at every commit that touches any
item.

This is the **first thing each new session reads** alongside `git log -10`
and `wsl bash saturn/tools/validate_byte_match.sh dashboard`.

## Framing

The editable-decomp project (reframed 2026-05-05, commit `4a10180`)
positions saturncc as the compiler driving Daytona CCE's decomp. Goal is a
recompile-to-runnable source tree where engineers can edit, add, or delete
code without playing watchpoint archaeology against the binary.

Byte-match is the **verification gate** for individual lifts, not the
project's finish line:

- **Tier 1** — strict byte-match after canonical normalization (today's
  metric).
- **Tier 2** — relaxed byte-match after sound semantic-equivalence-
  preserving transformations applied by the verifier (Bucket B). Same
  verification strength as Tier 1; broader surface.
- **Tier 3a** — `__asm` block with lint coverage (Bucket C). Safe only for
  stylistic-divergence functions; **not** safe for functions with cross-
  function ABI / gbr-base / IPA-pinning quirks (those must be Bucket A
  features).

The work partitions into four buckets:

- **A — must-implement compiler features.** 9 items. Functions with these
  quirks cannot lift to plain C; their absence makes Tier 3a unsafe because
  error-detection cost ≈ feature-implementation cost. Designed in
  `saturn/nti/`.
- **B — normalizer transformations.** Sound semantic-equivalence rewrites
  that absorb compiler-stylistic divergence (register choice, pool layout,
  branch reformatting). Tune the verifier, not the compiler. Most of
  `gap_catalog.md` lives here.
- **C — Tier 3a `__asm` safety.** Lint pass + partition criteria for
  functions that stay as `__asm` blocks rather than lift to C.
- **D — Cross-cutting infrastructure.** TU compilation, equivalence-metric
  spec, rcc robustness, lift dashboard.

## Rollup

### Bucket A — Must-implement compiler features

| ID | Feature | Corpus | NTI doc | Status |
|----|---|---:|---|---|
| A1 | Multi-entry functions | 27% | [`multi_entry_functions.md`](../nti/multi_entry_functions.md) | **nti-design (full); promotion-ready** |
| A2 | `#pragma gbr_base` / `gbr_base1` | majority of 36% | [`gbr_base_addressing.md`](../nti/gbr_base_addressing.md) | nti-stub |
| A3 | `#pragma global_register` | minority of 36% | [`global_register_pinning.md`](../nti/global_register_pinning.md) | nti-stub |
| A4 | Save-strategy pragmas | 13% | [`save_strategy_pragmas.md`](../nti/save_strategy_pragmas.md) | partial — `#pragma regsave` shipped; rest stub |
| A5 | Fallthrough functions | 13% | [`fallthrough_functions.md`](../nti/fallthrough_functions.md) | nti-stub |
| A6 | IPA register pinning | 10% | [`register_pinning_ipa.md`](../nti/register_pinning_ipa.md) | nti-stub; analyzer prereqs drafted |
| A7 | MAC/SR intrinsics | 4 fns blocking | [`mac_unit_sr_intrinsics.md`](../nti/mac_unit_sr_intrinsics.md) | nti-stub |
| A8 | Non-standard register conventions | overlaps A6 | [`nonstandard_register_conventions.md`](../nti/nonstandard_register_conventions.md) | nti-stub |
| A9 | R0-shim calling convention | 3% | [`r0_shim_calling_convention.md`](../nti/r0_shim_calling_convention.md) | nti-stub; may merge into A8 |

Status values:

- `nti-stub` — design parking-lot entry exists, TODO marker for the rest.
- `nti-design` — full design, ready to promote to active workstream.
- `active` — promoted; workstream doc owns implementation; sub-stages
  tracked there.
- `partial` — some stages shipped, others open.
- `shipped` — all stages done with regression coverage.
- `retired` — superseded; row stays for ID stability.

### Bucket B — Normalizer transformations

Each item is a sound semantic-equivalence-preserving extension to
`saturn/tools/asm_normalize.py`. None require compiler changes. Each entry
joins the equivalence-metric spec (D2) with a written soundness argument.

| ID | Transformation | Absorbs gaps | Status |
|----|---|---|---|
| B1 | Register-rename equivalence | 1A, 1B partial, 16 | not started — **highest leverage; cheap thesis test** |
| B2 | Pool-position normalization | 17 extensions, tail-distance variance | not started |
| B3 | Branch reformatting | 11 (loop inversion as semantic equivalence) | not started |
| B4 | Constant-reuse / redundant-ext / pre-dec | 8, 9, 10 | not started |
| B5 | Indexed-vs-disp swap | 5 (when both fit) | not started |
| B6 | Callee-save-order permutation | partial of 1 | not started |

### Bucket C — Tier 3a `__asm` safety

| ID | Item | Status |
|----|---|---|
| C1 | `__asm` block lint pass (save/restore symmetry, stack balance) | not started |
| C2 | Tier 3a partition criteria (when is `__asm` safe?) | not started |

### Bucket D — Cross-cutting infrastructure

| ID | Item | Status |
|----|---|---|
| D1 | TU-aware compilation path | backlog ([`backlog.md`](backlog.md)); not started |
| D2 | Equivalence-metric specification doc | not started — Bucket B's soundness contract |
| D3 | rcc robustness (no crash on bad C) | backlog; partial — 15 known crashes catalogued |
| D4 | Lift dashboard (per-function tier classification) | not started |

## Milestones

Numbered chronologically — M1 is earliest, M4 is the project endpoint.
Each milestone proves something specific about the thesis before the next
one starts.

- **M1 — First multi-entry function lifted.** A1 promoted, Stages 1–4
  shipped, one corpus Cat 1 function reproduced from declared C source
  (compiles, byte-matches prod after normalization, links cleanly).
  Validates the editable-decomp thesis for the 27% multi-entry fraction
  and exercises the C-level multi-entry surface end-to-end.
- **M2 — Equivalence-metric spec landed + B1 ratified.** D2 written; B1
  register-rename equivalence prototyped against FUN_06037E28 and
  measured. Tier 2 relaxed byte-match becomes a usable verification
  layer with a written soundness contract. Validates that "tune the
  verifier, not the compiler" has a sound foundation.
- **M3 — One full TU lifted end-to-end.** Pick a moderate-sized TU
  (FUN_06029D8C.s, 29 functions, 52% clean per the census), lift with
  whatever Bucket A features it needs, recompile to bytes, link-and-run
  cleanly. The first proof-of-thesis for the whole editable-decomp loop:
  delete a function from the TU and observe the link fail loudly; add a
  trivial new function and observe it integrate. The editing workflow
  Sega had, restored on one TU.
- **M4 — ≥50% of race.bin lifted to C.** Project endpoint. Lift counts
  measured via per-function manifest (D4) once that lands; hand-counted
  against the 850-function race-module census until then. Target
  functions chosen from racing-physics rivers-of-data flow
  (FUN_06037E28 → 060384C4 → 060386D8 → 06038A84) and broader
  race-main entry (FUN_06028000), expanding outward through call chains
  and data-pointer chains. Reassess scope at 50% — may extend, may stop.

## Per-item detail

(Sections fill in as sessions touch each ID. New items: copy the row from
the rollup, add a brief `Why this now` note + link to the workstream doc
when promoted. Use the format below.)

### A1 — Multi-entry functions

**NTI doc:** [`multi_entry_functions.md`](../nti/multi_entry_functions.md).

**Why first:** highest corpus impact (27%); full design already drafted
with prod evidence and merge-optimizer rebuttal; substrate already in place
(asm-shim parses `.asm_entry`, simulator honours, naked-emit emits — only
the C-level declaration form is missing).

**Stages from the NTI doc:**

1. Front-end recognition (parse `__entry_alias__`).
2. IR attachment (find Node at offset, attach sentinel).
3. Emission (`emit2` prints `.global` + label).
4. Deletion-safety regtest.

Stage 5 (alias inside C statement) deferred.

**Promotion trigger:** ready now. When promoted, opens
`saturn/workstreams/multi_entry_implementation.md` with status header.

### A6 — IPA register pinning

**NTI doc:** [`register_pinning_ipa.md`](../nti/register_pinning_ipa.md).

**Analyzer prerequisites already drafted:**

- [`path_sensitive_walker.md`](../nti/path_sensitive_walker.md)
- [`interprocedural_predicate_summaries.md`](../nti/interprocedural_predicate_summaries.md)

**Why deferred:** depends on analyzer prereqs. Corpus impact (10%) is
concentrated in the largest TUs. Probably tackled after A1 lands.

### B1 — Register-rename equivalence

**Cheap thesis test.** Before investing in a full normalizer extension,
prototype against FUN_06037E28 (currently 1028 diffs at tier-1) and measure
how many collapse under consistent register-rename equivalence. >80% means
the thesis pays off → expand to B2/B3. <50% means register choice isn't the
dominant divergence and we rethink.

This experiment is independent of any Bucket A promotion; could run in
parallel.

### D2 — Equivalence-metric specification

The soundness contract that ratifies every Bucket B transformation. Living
document. Each entry: what the transformation is, why it preserves
semantics, what tests verify the preservation, what's explicitly *not*
allowed. Without this, Tier 2 relaxed byte-match is hand-waving; with it,
Tier 2 has the same verification strength as strict byte-match.

## Progress log

Newest first. Format: `commit_or_date — item_id — note`.

- `2026-05-05` — roadmap — this doc created. Rollup table seeded from the
  Bucket A NTI sweep + the gap-catalog → Bucket B remap from the same
  conversation. Sub-milestones M1..M4 defined.
- `dab61e3` — A1..A9 — Bucket A NTI sweep landed: full design for A1
  (multi-entry functions, folded in from retired `entry_alias_design.md`),
  stubs for A2–A5 + A7–A9, A6 stub references existing analyzer prereqs.
  NTI README reorganized into Bucket A index + analyzer prerequisites.
- `4a10180` — project reframe — saturncc drives the decomp directly;
  DaytonaCCEReverse mod-build paused until the M4 project endpoint.
  Byte-match is the verification gate, not the unit of progress.
- `099ebc4` — A1 — original `entry_alias_design.md` drafted in workstreams
  (later promoted to NTI in `dab61e3`).

## Conventions

- **Bucket IDs are permanent.** Don't renumber. Retired items keep their ID
  with status `retired` and a one-line note explaining what superseded
  them.
- **Status changes go in the rollup table** as the source of truth. Detail
  sections are narrative; the table is canonical.
- **Promotion path:** Bucket A item moves from `nti-design` to `active`
  when a session opens an implementation workstream doc. The workstream
  doc tracks stages; this rollup tracks the promotion.
- **Progress log entry per touching commit.** One line, newest first.
  Format: `commit_or_date — item_id — note`.
- **Cross-references back from NTI → roadmap.** When an NTI stub is
  populated, add a "Tracked at:
  [editable_decomp_roadmap.md#A2](editable_decomp_roadmap.md)" line to
  it. Avoids drift.
