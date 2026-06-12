# braf dispatch-table anchor lint

Response to the DaytonaCCEReverse briefing "silent off-by-2 braf
dispatch corruption under 2-mod-4 relocation" (2026-06-12), and the
workstream record for the guardrail that came out of it.

**Status: shipped.** Lint live in sh.md, regtests in
`validate_build.sh` 4y2, full suite 67/67, byte-match zero movement.

## 1. Answer to the briefing's open question

> Where in our pipe does the pad actually get decided (rcc emission
> vs GAS .align handling of mova targets)?

**rcc decides it; GAS only materializes it.** The pool-label
auto-alignment feature (`9c7cc50`/`74a8bd5`, wishlist item #6)
emits `.balign 4` before every `.L_pool_*` label in an asm body.
Compiling the unmodified `src/race/asm/FUN_06045B74.c` shim shows
it directly:

```
	.balign 4          ← rcc emitted this
.L_pool_06045B80:
	.2byte .L_06045BC4 - .L_pool_06045B80
```

At a 2-mod-4 section offset GAS resolves that directive to the
2-byte `0x0009` pad you byte-diffed. Without the directive, GAS
hard-errors on the misaligned mova target ("offset to unaligned
destination") — a loud build failure. So the alignment-absorption
feature you requested for literal pools is exactly what made this
failure *silent*: absorption is sound for literal pools (GAS
re-encodes the label displacements on both sides of the pad) and
unsound for braf delta tables (the hardware adds entries to
braf+4, which GAS knows nothing about). The `.L_pool_*` naming
convention can't distinguish the two; FUN_06045B74's tables matched
the literal-pool treatment.

Therefore the check belongs in rcc — it creates the hazard and has
the parsed-asm IR to detect the idiom.

## 2. The lint

`sh_lint_braf_tables` (sh.md, runs at asm-body parse time, after
`sh_compute_pool_alignment` so it can see where synthetic pads can
land). For every `braf`/`bsrf`:

1. Identify the delay slot (next instruction record).
2. Collect the **anchor set**: labels declared after the delay slot
   and before the first alignment point or size-bearing record —
   i.e. labels provably at braf+4. A `.L_pool_*` label is itself an
   alignment point (its auto-`.balign` precedes it), so it is never
   an anchor.
3. Trace the feeding `mova L, r0` (nearest, same straight-line
   block) and require a dataflow link: an insn between mova and
   braf that writes the braf register while reading r0.
   Conservatively-parsed insns pass the link for free.
4. Walk the table at L. Every `.2byte`/`.short`/`.word`/`.long`/
   `.4byte` entry must be `TARGET - ANCHOR` with ANCHOR in the
   anchor set. Anything else — self-anchored, anchored elsewhere,
   raw numeric, compound expression — is a **hard error** (nonzero
   exit), one per table, naming the table and the offending anchor
   with the re-anchor fix in the message.

The error fires regardless of current layout parity: at 0-mod-4 the
bytes happen to be right, but the style is latent corruption under
any odd shift, and the point is to catch the next phase-sensitive
idiom before a shift does.

Known limits (binary-level verification is the backstop):

- Only mova-traceable tables inside one asm body are checked.
  Hand-rolled PC arithmetic is invisible to a textual lint.
- A table label defined outside the body is skipped (mova can't
  reach another function's pool anyway).
- Reported line numbers drift ~2 on shims whose `asm {` opener is
  split across lines (pre-existing trait of the shared line
  mapping); the table/anchor names in the message are exact.

## 3. Corpus sweep — every race shim through the lint

757 shims in `DaytonaCCEReverse/src/race/asm`: **13 rejected,
744 pass.** Matches the briefing's accounting (19 braf sites; the
6 pad-immune cross-file tables all pass; the vulnerable locals
concentrate in 13 files, FUN_06045B74 carrying two tables):

```
FUN_06028000.c  FUN_06037E28.c  FUN_0603FAEA.c  FUN_060405CC.c
FUN_06042F2C.c  FUN_06045B74.c  FUN_06045C3C.c  FUN_06045D80.c
FUN_06045E44.c  FUN_06045F46.c  FUN_060472CC.c  FUN_06047548.c
FUN_06047E0C.c
```

The sweep surfaced a **third flavor** beyond the briefing's two
styles: raw-numeric delta tables (e.g. FUN_06028000's
`.L_pool_06028360: .2byte 0x0032, ...`) where the deltas are
frozen retail distances from braf+4 while the auto-`.balign` on
the table label can still move the table and the case code. Same
silent corruption class, also rejected.

## 4. Sequencing with the downstream re-anchor campaign

The lint is a hard error, so the 13 files above won't compile with
the new rcc until re-anchored. No warning-period machinery needed:
DaytonaCCEReverse consumes the frozen `build/release/rcc` stamp,
so finish the re-anchor campaign first, then pull the next
release. Re-anchored form the lint accepts (and the auto-align
stays sound on):

```
    braf r1
    sts.l pr, @-r15       ! delay slot
.L_braf_ret_X:            ! anchor — at braf+4, BEFORE any pad
.L_pool_X:                ! table — free to be auto-.balign'd
    .2byte .L_case0 - .L_braf_ret_X
    ...
```

Anchoring to `.L_pool_X` itself stays an error even after the
campaign — that label sits past its own alignment point.

## 5. Alternatives considered and punted

**Retail-parity pinning** (keep every function at its retail
address mod 4 so parity-sensitive idioms never see odd offsets):
census of the 753-function yaml map killed the simple version —
601 functions start ≡0 mod 4 but 152 start ≡2, so a blanket
`.balign 4` breaks baseline byte-match. The workable variant pins
each function to the parity encoded in its `FUN_` name, which
fails the moment the decomp renames functions (its entire
trajectory). Punted in favor of the lint; full reasoning and the
trailing-nop census in `tu_boundary_archaeology.md`.

## 5.5. Loud absorption — pad tripwires (shipped 2026-06-12)

Kills "silence #3" from the downstream three-silences critique: pads
used to materialize with no witness. Every synthetic `.balign` is now
bracketed by a zero-size symbol pair —

```
saturncc_pad_probe_N:            ← address before alignment
	.balign 4
saturncc_pad_mark_N_<site>:      ← address after alignment
.L_pool_X:
```

— and `saturn/tools/pad_report.sh` reads the pair out of the .o
symbol table, printing one `PAD: <n> byte(s) at <addr>  site <name>`
line per materialized pad, with `--strict` (nonzero exit on any pad)
for free-build identity gates where the expected count is zero.
Symbols are local and stripped by `objcopy -O binary` — image bytes
untouched in every case.

**Automatic adoption:** `saturn/tools/as_pad_wrap.sh` is a drop-in
assembler wrapper — point the build's `AS` at it once and every
assembly thereafter auto-reports (warnings to stderr, silent at zero
pads, `SATURNCC_PAD_STRICT=1` to fail the build on any pad). rcc
itself cannot run the report: the answer only exists after assembly,
which happens in the consumer's build. One-time `AS :=` change is
the minimum physics allows. Regtest 4y3(c).

**Design constraint discovered the hard way:** the obvious in-source
form — `.if (mark - probe) != 0` + `.warning` — is impossible. GAS
evaluates `.if` at parse time (one-pass), and any expression spanning
an alignment directive (including the function's own `.align` header)
is a "non-constant expression" hard error. Verified empirically
against sh-elf-as; do not retry. The symbol-pair + post-assembly
reporter is the nearest sound equivalent, and regtest 4y3(b) pins
both the clean assembly and the report.

**Interim-spelling proposal dropped (2026-06-12).** The blessed
compound form `.2byte TARGET - (BRAF_LABEL + 4)` (downstream menu
item 4) was considered and rejected: it's a nicer hand-written
ritual, but still a ritual, and blessing it would put a third
accepted style into the corpus while the first-class construct is
the agreed end state. The remaining files re-anchor in the existing
lint-gated label-pair form and migrate mechanically when the
construct lands.

## 6. Queued follow-ups

- **First-class dispatch construct** — the agreed end state for the
  whole idiom: a declared construct where rcc owns the anchor (it
  knows where braf+4 is), synthesizes the labels and deltas, and
  the human writes only the case list. The label-pair form becomes
  generated output, never a human ritual. Design doc next; written
  so `sh_emit_switch_dispatch` converges on the same emission path
  (one rcc-owned "emit a braf table correctly" routine serves both
  hand shims and compiled C `switch`). Needs downstream input —
  their shims come from a Ghidra-export generator that would
  target the construct.
- **Binary-level braf verifier** — disassemble the linked output;
  for each braf/bsrf assert (mova target) == braf+4. Catches what
  the textual lint can't (hand math, exotic encodings). Natural
  home: DaytonaCCEReverse `make validate`; could also live in
  `saturn/tools/`.
- **`sh_emit_switch_dispatch` pad-immune emission** — compiler-
  generated `switch` tables are currently self-anchored
  (`.short Lcase - LswtN`, sh.md). Loud failure mode (no auto-
  balign on `Lswt*` names → GAS error at odd parity), but it makes
  every lifted function containing a `switch` non-relocatable.
  Subsumed by the construct's shared emission path; if the
  construct slips, fix standalone (re-anchor + `.balign 4`,
  byte-identical at baseline, own byte-match cycle).
- **SHIFT=2 boot class** — downstream empirical backstop; lands on
  their side regardless of everything above.

## Append log

| Date | Note |
|------|------|
| 2026-06-12 | Created. Lint shipped + regtests (4y2 a–d); corpus sweep 13/757 rejected; briefing question answered (rcc emits the pad-triggering directive). |
| 2026-06-12 | Loud absorption shipped: probe/mark symbol pairs + `pad_report.sh` + regtests 4y3 (a–b). In-source `.if/.warning` form rejected by GAS (non-constant expression across alignment) — documented, don't retry. Compound-spelling interim (menu item 4) dropped; first-class construct promoted to top of queue. Suite 69/69. |
| 2026-06-12 | `as_pad_wrap.sh` added: drop-in AS wrapper so the pad report runs automatically on every assembly (user preference: automatic over opt-in). Regtest 4y3(c). Suite 70/70. |
