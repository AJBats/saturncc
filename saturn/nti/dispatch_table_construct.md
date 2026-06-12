# First-class dispatch-table construct

**Status: implemented, unified form** (2026-06-12). One syntax
covers all 18 corpus sites: the construct sits where the table
physically lives; the anchor is never positional — resolution finds
the table's unique `mova`, walks to the consuming braf/bsrf, and
welds `.L_disp_anchor_K` onto whatever record sits at dispatch+4
(for braf-adjacent sites that's the construct itself; for the 4 bsrf
call sites it's the live return-point code). Byte-identity
regtest-pinned for both shapes — the bsrf shape validated against
the real FUN_0603E394, text bytes and relocs identical to the
hand-written form. The split form (`.dispatch_anchor` /
`.dispatch_table_for`) is **retired unbuilt**: the downstream
metadata sweep showed every table is co-located with its dispatch in
the same shim ("cross-file" in the original audit meant cross-file
*targets*, which are just global symbols in the unity TU). Strict
mode (hand-written braf tables become outright errors) is queued
behind the downstream migration of all 18 + 4 mod-copy sites.
Tracked at
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

## Cross-file tables need a second form (found 2026-06-12)

The drafted construct emits the table immediately after the delay
slot — correct for the common idiom, but the 6 cross-file retail
sites have the table physically inside a *different* function's
byte range, and byte identity forbids moving it. Those sites need a
split spelling, sketch:

```asm
    braf r1
    sts.l pr, @-r15
    .dispatch_anchor .L_disp_7        ! declares anchor at braf+4
```
```asm
    ! ...in the shim that physically holds the table...
    .dispatch_table_for .L_disp_7 .L_pool_X
    .case .L_case0
    .end_dispatch
```

Both halves live in one unity TU, so the name resolves at compile
time. This also closes the verifier's known gap (per-body lint
can't see cross-file tables → no metadata → INFO only). Alternative
or interim closer: a TU-wide second resolution pass over the
existing cross-body insn array (A1 substrate, commit 82cd08d).
Sequencing: implement the local form first (covers the 13 single-
file sites including FUN_06045B74's two tables); the split form
follows once the engineer confirms the 6 sites' generator shape.

## Downstream pilot guide (try it on one site)

Prereqs: pull the current saturncc test release (`build/release/rcc`,
VERSION marked dirty until the construct commit lands); the pad/braf
checks run automatically if your `AS` already points at
`as_pad_wrap.sh`.

1. Pick a single-file site — FUN_06045B74 is the poetic choice.
   Replace the anchor/table label pair AND the entry lines with the
   declaration; keep the mova/braf code untouched:

   ```asm
       braf r1
       sts.l pr, @-r15
       .dispatch_table .L_pool_06045B80
       .case .L_06045BC4
       .case FUN_06046024
       ...                          ! one .case per entry, in order
       .end_dispatch
   ```

   Delete: `.L_braf_ret_06045B80:`, `.L_pool_06045B80:`, every
   `.2byte` line. Keep: the table label *name* (it moves into the
   `.dispatch_table` operand — your mova still references it).

2. Rules the compiler enforces (all hard errors with file:line):
   the declaration sits wherever the table physically lives (for
   braf sites that's right after the delay slot; for bsrf call
   sites it's wherever the table is — typically after the
   epilogue, since bsrf+4 is the live return point and rcc welds
   the anchor there automatically); exactly one `mova <table-name>`
   in the body, consumed by a braf/bsrf with a dataflow link; only
   `.case` lines until `.end_dispatch`; at least one case; stray
   `.case`/`.end_dispatch` outside a block.

3. Acceptance: your `make validate` must stay byte-identical at
   baseline (the expansion is regtest-pinned byte-identical to the
   hand-written pad-immune form on our side), and `braf_verify`
   (auto via the AS wrapper) should show the site as a verified
   table with zero errors.

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
| 2026-06-12 | Cross-file split form sketched (`.dispatch_anchor` / `.dispatch_table_for`) — the drafted local form can't express the 6 cross-file retail sites without moving bytes. |
| 2026-06-12 | Local form implemented: `.dispatch_table`/`.case`/`.end_dispatch` resolution + expansion in sh.md; expansion byte-identical to the hand-written pad-immune form (regtest-pinned); construct output carries full tripwire + braf_verify metadata; all violations are hard errors with file:line. Suite 77/77. |
| 2026-06-12 | Downstream pilot passed (FUN_06045B74 both tables, byte-identical, plus a genuine 2-mod-4 MOD layout: pad absorbed, dispatch correct, game runs). Engineer's metadata sweep killed the split form's premise — all 18 tables co-located with their dispatch; "cross-file" meant targets only. |
| 2026-06-12 | Unified placement shipped: positional rule replaced by computed anchor welding (disp_anchor_id on the record at dispatch+4). bsrf call sites (table after the epilogue, anchor on live return-point code) now expressible with the same syntax — validated byte+reloc-identical against the real FUN_0603E394. Shared-table guard (multiple mova) is a hard error per the engineer's none-exist confirmation. Regtests 4y5 a–e; suite 78/78. Strict mode queued behind migration. |
