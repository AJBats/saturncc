# First-class dispatch-table construct

**Status:** design draft (2026-06-12), written for circulation to the
DaytonaCCEReverse engineer before implementation. Tracked at
[editable_decomp_roadmap.md#C1](../workstreams/editable_decomp_roadmap.md).

**Provenance:** the 2-mod-4 silent braf corruption incident
([braf_dispatch_lint.md](../workstreams/braf_dispatch_lint.md)) and the
downstream three-silences critique. Direct quote of the goal: "the
label pair becomes an implementation detail rcc generates rather than
a ritual humans perform."

## What, in plain terms

The SH-2 jump-table idiom today takes four cooperating hand-written
pieces: a `mova` to the table, a `braf`, an anchor label that must sit
at exactly braf+4, and delta entries anchored to that label — with the
correctness hanging on line ordering relative to an *invisible*
`.balign` the compiler injects. The lint makes wrong variations refuse
to compile, but the right variation still looks like a no-op
(two labels at one address) and must be maintained by vigilance.

The construct replaces the ritual with a declaration: the human writes
*which targets the table dispatches to*; rcc — which knows where
braf+4 is — synthesizes the anchor, the alignment, the tripwire
bookmarks, and the delta arithmetic.

## Why now

- 19 braf table sites in race.bin; every one currently hand-maintained
  in the label-pair form (or awaiting re-anchor into it).
- Compiled C `switch` statements need the identical pad-immune
  emission (`sh_emit_switch_dispatch` is self-anchored today — every
  lifted function containing a `switch` is non-relocatable). One
  rcc-owned "emit a braf table correctly" routine serves both.
- The Ghidra-export generator downstream wants a target to emit; a
  declared construct is mechanically generatable.

## Proposed surface (line-based, mirrors `.asm_entry` precedent)

```asm
    shll r0
    mov r0, r1
    mova .L_pool_06045B80, r0
    mov.w @(r0, r1), r1
    braf r1
    sts.l pr, @-r15
    .dispatch_table .L_pool_06045B80
    .case .L_06045BC4
    .case FUN_06046024
    .case .L_06046074
    .end_dispatch
```

Semantics:

- `.dispatch_table NAME` must be the **first size-bearing record after
  the delay slot** of a `braf`/`bsrf`. rcc verifies this structurally
  (walk back: delay-slot insn, then the dispatch insn) — hard error
  otherwise, since the synthesized anchor is only correct at braf+4.
- `NAME` is the table label, still author-chosen: the human's `mova`
  references it, and rcc cross-checks that a `mova NAME, r0` feeding
  the dispatch register exists (reusing the lint's dataflow walk).
- `.case TARGET` — one per slot, in index order. Any symbol.
- `.end_dispatch` closes the list.

Expansion (generated, never hand-written):

```asm
.L_disp_anchor_K:                  ! synthesized — at braf+4 by the
                                   ! position rule above
saturncc_pad_probe_N:
	.balign 4
saturncc_pad_mark_N_<site>:
.L_pool_06045B80:
	.2byte .L_06045BC4 - .L_disp_anchor_K
	.2byte FUN_06046024 - .L_disp_anchor_K
	.2byte .L_06046074 - .L_disp_anchor_K
```

Byte-identical to the hand-written pad-immune form at baseline
(anchor address == table address → same delta values), correct at
every parity (anchor pinned to the instruction stream; the assembler
re-prices entries when a pad materializes). Entry width is `.2byte`
(the corpus form); a 32-bit variant is deferred until a corpus case
exists.

## Lint interplay

- Construct-generated tables are correct by construction; the lint
  skips them.
- Hand-written braf tables remain lint-gated exactly as today.
- Long-term option (downstream's call, post-migration): a strict mode
  where hand-written braf tables are rejected outright and the
  construct is the only accepted spelling.

## Stages

1. **Parser** — recognize the three directives into `sh_asm_insn`
   records; validate position (first record after the delay slot) and
   pairing (`.dispatch_table` … `.end_dispatch`, no interleaved
   non-`.case` records).
2. **Emission** — expansion in the asm-body emit path, integrated with
   the pad-probe machinery; synthesized anchor names unique per TU.
3. **Cross-checks** — mova-feeds-dispatch dataflow check; error
   messages with the same site-naming quality as the lint's.
4. **Regtests** — expansion shape; byte-identity against the
   hand-written pad-immune form; position-violation errors; two
   tables in one body (FUN_06045B74 shape); bsrf variant.
5. **Downstream pilot** — generator emits the construct for
   FUN_06045B74; byte-identical at baseline; SHIFT=2 boot test.
6. **(Separate workstream)** `sh_emit_switch_dispatch` converges on
   the same emission routine — needs its own byte-match cycle and
   possibly a normalizer tweak.

## Implementation requirement — loud comments (user direction, 2026-06-12)

The construct does not remove the cross-build-stage dependency — it
*ingests and owns* it: rcc still relies on GAS's layout-time label
re-pricing and the hardware's instr+4 rule, and the synthesized
anchor/table pair is the same double label, now generated. User
review accepted this with one condition: **every piece of code
participating in the contract must carry a banner comment naming the
full four-stage chain** (rcc emits the alignment possibility → GAS
materializes the pad → GAS re-prices label arithmetic → hardware adds
from instr+4), because the dependency is invisible from within any
single stage and "super visible to claudes reading this" is the
requirement. The canonical banner lives above
`sh_pool_align_for_label` in src/sh.md; the construct's parser,
expansion, and verifier code must point back to it rather than
paraphrase it partially.

## Open questions for DaytonaCCEReverse

1. **Generator fit** — the Ghidra exporter already emits these tables;
   is the table extent + case list reliably recoverable so it can emit
   `.case` lines instead? (Presumed yes — it authors the entries
   today.)
2. **Table naming** — keep `.L_pool_*` names (minimal churn; the
   construct emits its own alignment so the naming trigger no longer
   matters for these labels) or introduce `.L_disp_*`? Proposal: keep.
3. **bsrf call-tables** — any in the corpus? Construct supports both;
   a real test case would be better than a synthetic one.
4. **Directive spelling** — `.dispatch_table/.case/.end_dispatch` at
   asm level proposed (shims are asm); is a C-level `__dispatch_table__`
   form wanted for lifted code, or does switch-emitter convergence
   cover that side entirely?
5. **Strict mode timing** — after the 19 sites migrate, should
   hand-written braf tables become errors outright?

## Append log

| Date | Note |
|------|------|
| 2026-06-12 | Initial draft from the braf-incident session; circulated to DaytonaCCEReverse for generator-side review. |
