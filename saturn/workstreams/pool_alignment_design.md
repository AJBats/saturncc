# Pool-label auto-alignment — design

Design doc for emitting `.balign 4` before pool labels in asm-shim
bodies, so deletions that shift downstream pools don't crash the
assembler with "offset to unaligned destination".

**Origin:** DaytonaCCEReverse feature request
[saturncc_request_pool_alignment.md](../../../DaytonaCCEReverse/workstreams/transplant/saturncc_request_pool_alignment.md).
Wishlist item #6.

**Status:** design only. Awaiting design discussion before code.

## 0. Position in one paragraph

When asm-shim emits an `is_label` instruction record whose next
non-comment, non-directive-prefix successor is a 2- or 4-byte data
directive (`.long`, `.4byte`, `.short`, `.word`), it also emits
`.balign 4` immediately before the label. At the baseline (all
existing pools already 4-aligned) this is a zero-pad no-op; under
function-deletion-driven shrinks of non-4-aligned amounts it absorbs
the alignment debt automatically. The directive is normalized away
in `asm_normalize.py` so the saturncc tier-1 byte-match dashboard
sees no diff. Tier-2 binary diffs see at most 0–3 bytes of pad
appearing only when the upstream actually shifts.

## 1. Substrate that already exists

**Asm-shim parsed-IR records** (commit `57e771a`,
[sh.md:3780-3859](../../src/sh.md#L3780)). Every line of an
`asm { ... }` body becomes an `sh_asm_insn` carrying:

- `is_label` — bare `LABEL:` lines and `LABEL: directive` combined
  forms.
- `is_directive` — directive name in `mnemonic` (e.g. `.long`,
  `.4byte`, `.short`).
- `mnemonic` — the captured label name on label lines.
- `src_text` — the source line for verbatim emission.

A pre-emit peephole that walks this list and inserts synthetic
`.balign 4` Nodes is mechanically clean.

**Normalization is alignment-tolerant.**
[asm_normalize.py:38](../../tools/asm_normalize.py#L38) already
drops `.align` (alongside `.section`, `.type`, etc). Adding
`balign` to that regex is a one-line change. Tier-1 dashboard
diff stays at zero.

**Compiler-emitted pools are not in scope.** The internal literal
pool path at [sh.md:1048-1068](../../src/sh.md#L1048) emits
`.align 2` (4-byte alignment in GAS arithmetic) by construction.
This work is for *user-supplied* asm bodies that contain their
own pool labels.

## 2. Decisions to lock in

### D1 — trigger heuristic (revised after sha 9c7cc50 over-fired)

**Locked:** naming-based trigger. For every `is_label` insn, look
at the label name:

| Label name prefix | Emit         | Why                           |
|-------------------|--------------|-------------------------------|
| `.L_pool_`        | `.balign 4`  | mov.l target — 4-align needed |
| `.L_wpool_`       | `.balign 2`  | mov.w target — 2-align needed |
| (anything else)   | no auto-emit | not a pool by convention      |

**History — what we tried first and why it failed.** The first cut
(sha 9c7cc50) used a structural trigger: "any label whose next non-
comment record is `.long`/`.4byte`/`.short`/`.word`/`.byte` gets
`.balign 4`". Two over-firing classes broke
DaytonaCCEReverse's `make -C decomp validate`:

1. **`.L_wpool_*` over-emission** (1,246 sites). These labels are
   `mov.w` targets that need 2-byte alignment, not 4. The pristine
   layout placed many of them at 2-aligned-but-not-4-aligned
   offsets; forcing 4-align inserted up to 2 bytes of pad before
   each, cumulative shift up to ~2,492 bytes.
2. **Non-pool label over-emission** (22 sites). Labels like
   `.L_braf_ret_*` and `.L_data_*` happened to precede data
   directives in code paths but aren't pool targets — they
   shouldn't have been aligned at all.

The cumulative shift blew the 12-bit signed displacement budget
of long-distance `bsr`/`bra` (±4,096 bytes), failing assembly.

**Why naming wins here.** This whole feature is *for*
DaytonaCCEReverse, and they have a stable, documented naming
convention (`.L_pool_*` for `.long`-pools, `.L_wpool_*` for
`.word`-pools). The naming convention encodes the *access size*
that determines the alignment requirement — structural lookahead
over directives can see only the data shape, not the access shape.

**Future-proofing.** If another project consumes saturncc and uses
a different convention, they can either rename their labels to
match `.L_pool_*` / `.L_wpool_*`, or we re-add a configurable
prefix list. The corpus today doesn't need that, so the design
stays narrow.

### D2 — always emit vs conditional

**Proposed: always emit.** When the label is already at a 4-byte
boundary (all existing baselines), GAS resolves `.balign 4` to a
zero-pad no-op. When upstream shrinks have offset the label,
GAS pads correctly.

The conditional alternative — "only emit when offset isn't
already 4-aligned" — requires saturncc to byte-count the full
section, which it doesn't do for verbatim asm bodies. Always-emit
is simpler, has no behavioural cost, and the request doc accepts
it as the resolution of acceptance criterion #3.

### D3 — duplicate suppression

**Proposed:** skip the synthetic emission if the immediately
preceding insn is already a `.balign N` (any N ≥ 1) or `.align M`
directive. Cleaner output, no functional difference.

Implementation: trivial backwards-peek in the same peephole
pass.

### D4 — placement: peephole pass vs emit-time peek

Two options for *where* the `.balign 4` gets injected:

- **Pre-emit peephole pass.** Walk the parsed insn list, insert
  synthetic `sh_asm_insn` records with `is_directive=1`,
  `mnemonic=".balign"`, `src_text=".balign 4"`. Subsequent
  emit-time path is unchanged.
- **Emit-time peek.** No mutation of the insn list. When emitting
  an `is_label` insn, peek ahead in the list and conditionally
  print `.balign 4` immediately before the label's `src_text`.

**Proposed: emit-time peek.** Lower risk, keeps the parsed-IR
read-only, no surprises for analysis passes that already iterate
the list. The peephole-pass option is more "principled" but the
synthetic Nodes don't carry parsed reads/writes masks, which
could trip future analysis passes that don't gracefully skip
unrecognized directives.

### D5 — scope: which asm bodies

**Proposed: all `asm { ... }` bodies** that produce labels,
whether the function is naked or mixed-mode. The user case is
naked-asm shims for prod-imported functions, but a mixed-mode
function with an asm-block-internal pool gets the same treatment
for free.

### D6 — error reporting

If a label has no follow-on directive (e.g., trailing label at
the end of an asm body), no alignment is emitted. No error. The
label is treated as a normal symbol declaration; alignment
isn't relevant.

## 3. Open questions

1. **`.byte` pools.** A label followed by `.byte` is a byte
   array. No alignment requirement (SH-2 byte loads are fine
   at any address). Current proposal: don't emit `.balign 4`
   for `.byte`-only labels. Confirm — is there a use case for
   forcing 4-alignment on byte arrays inside asm bodies?
2. **Mixed-directive labels** (`.long` followed by `.byte`
   followed by `.long`). Trigger fires on the leading directive
   only. The middle `.byte` slot is naturally aligned because
   it follows a `.long`. Internal misalignment isn't our problem
   — the user authored the layout that way.
3. **Conditional emit policy** — if an existing project already
   has manual `.byte 0xFF, 0xFF` padding before its pools (the
   request doc mentions this case), our `.balign 4` becomes a
   no-op (zero-pad), but the `.s` output text gains the `.balign`
   line. asm_normalize.py strips it. Is there any project
   downstream that diffs raw saturncc `.s` output and would care?
   Probably not — but worth flagging.
4. **GAS `.balign` semantics across toolchain versions.** SH-2
   binutils generally accepts `.balign N` (byte-align to N
   bytes) and `.align N` (align to 2^N bytes — different
   semantics). We must use `.balign 4` explicitly to mean "4
   bytes," not `.align 4` (= 16 bytes). Current normalization
   strips both forms.

## 4. Stages

**Stage 1 — emit-time peek.** Add a helper
`sh_asm_emit_pool_alignment(insn, next)` to the asm-shim emit
path. Call it before emitting any `is_label` insn. Helper checks
the forward-skip heuristic per D1 and the backward-skip per D3,
prints `.balign 4\n` when warranted.

Test: a regtest TU with a naked-asm function containing
`.L_pool_x: .long sym`, compile, grep for `.balign 4` immediately
before the label.

**Stage 2 — normalize.** Add `balign` to
[asm_normalize.py:38](../../tools/asm_normalize.py#L38)'s
`DROP_DIR_RE`.

Test: re-run `validate_byte_match.sh check`. All 10 baselines
must stay at 0 movement.

**Stage 3 — TU validation.** Re-run
`validate_byte_match_tu.sh race_FUN_06044060 check`. The 190 ok
baselines must hold. (This TU has no labels-with-data-directives
inside asm bodies today, per a quick grep, so this stage is
mostly a sanity check that nothing regressed in the emit path.)

**Stage 4 — DaytonaCCEReverse smoke.** Build their `make validate`
across all 8 modules with the new saturncc. Per their acceptance
criterion #1, all 8 must stay byte-identical to retail at
baseline. Then they run the FUN_06036CF8 deletion test — that
turns the request from "feature request" into "acceptance signoff."
Done remotely on their side.

**Stage 5 — broad-corpus regression.** Run the broad-corpus pass
race compile, expect 183 pass / 0 crash to hold.

## 5. What NOT to do

- **Don't try to byte-count the section** to emit alignment only
  when needed. Asm-shim is verbatim text emit; it doesn't track
  byte positions. Always-emit is the right call.
- **Don't widen scope to compiler-emitted pools.** They already
  align by construction. Touching that path risks the existing
  byte-match baselines for no benefit.
- **Don't tie the trigger to label naming convention** (per D1
  rejected alternative). Convention drifts; structural triggers
  (next-token-is-data-directive) don't.
- **Don't insert `.balign 4` retroactively in existing checked-in
  TU `.c` files.** The point of putting it in the compiler is
  that source files don't carry layout knowledge.

## 6. Cross-references

- `asm_shim_design.md` — substrate this builds on.
- `entry_alias_design.md` — sibling wishlist item (#2). Both share
  the "asm-shim emit path" surface.
- DaytonaCCEReverse `saturncc_request_pool_alignment.md` — origin.
- DaytonaCCEReverse `saturncc_capability_response.md` — broader
  reply doc; this becomes wishlist item #6.

## Append log

| Date | Note |
|------|------|
| 2026-04-29 | Initial design. Five stages; emit-time peek over peephole-mutation. |
| 2026-04-30 | Revised D1 after the structural trigger over-fired in DaytonaCCEReverse's race build (1,246 wpool over-emissions + 22 non-pool over-emissions blew bsr displacement budget). Trigger now naming-based: `.L_pool_*` → `.balign 4`, `.L_wpool_*` → `.balign 2`, others → no emit. |
