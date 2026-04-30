# Entry alias design — `__entry_alias__` as a first-class declaration

Design doc for adding C-level mid-function entry alias declarations
to the SH-2 backend, so that "second `.global` inside another
function's body" — Cat 1 (~230 functions, 27% of the race module)
of the [SHC annotation census](https://example/shc_annotation_census)
— becomes a checked, mechanical, deletion-safe construct rather
than a hand-curated invariant.

**Origin:** [DaytonaCCEReverse removal_landing_zone.md](../../../DaytonaCCEReverse/workstreams/transplant/removal_landing_zone.md)
wishlist item #2. See also our reply doc
[saturncc_capability_response.md](../../../DaytonaCCEReverse/workstreams/transplant/saturncc_capability_response.md).

**Status:** design only. No implementation. Awaiting design
discussion before any code is written.

## 0. Position in one paragraph

A C-level declaration `__entry_alias__(FN, offset, "ALIAS")`
attaches a named symbol alias to a specific instruction offset
inside `FN`'s body. The alias travels with `FN` through saturncc's
Node-list IR — registered alongside `FN` at parse time, recorded
on the asm-shim instruction record at the matching offset, and
emitted as a `.global ALIAS` + `ALIAS:` label during asm-shim's
verbatim text emission. Deletion safety follows mechanically: if
`FN` is removed from the source, the alias declaration goes with
it; any caller still referencing `ALIAS` becomes a link-time
undefined-symbol error rather than a silent dangling reference
into deleted bytes.

## 1. Substrate that already exists

This work is not greenfield. Two existing pieces feed directly
into the design:

**Asm-shim parsed directive `.asm_entry <name>`.** Already parsed
into the asm-shim instruction record at
[sh.md:3801-3815](../../src/sh.md). Simulator treats `.asm_entry`
labels as real entry points when answering interprocedural queries —
the writes_r4 oracle at [sh.md:1716](../../src/sh.md) walks
`.asm_entry` directives across the TU-wide concatenated insn array
to resolve sub-entry callees, and per-entry verdicts are emitted
at [sh.md:3971](../../src/sh.md). Phase A of the simulator
integration treats `.asm_entry` symbols as first-class `.global`s
in the assembler-level output.

**Asm-shim Node-list IR** ([asm_shim_design.md](asm_shim_design.md)).
Stage 1's parser produces `sh_asm_insn` records carrying source
text, mnemonic, operands, reads/writes masks. Each instruction
becomes a Node in the same Node-list intermediate where C lowers.
This is the right place to attach alias metadata.

The new work is therefore:

- A C-level declaration form (front-end recognition).
- A mechanism to thread the declaration's offset into the right
  asm-shim instruction record at IR-build time.
- An emission rule that adds the `.global` + label at the right
  byte position.

Everything else — naked emit, simulator awareness, writes_rN
inheritance — already operates on `.asm_entry`-style sub-entries.

## 2. Decisions to lock in

### D1 — surface syntax

**Option A (proposed):** `__entry_alias__(FN, offset, "ALIAS")`
as a top-level declaration, recognized via the `shc_pragma_hook`
in `input.c` or as a registered top-level keyword in the parser.

```c
__entry_alias__(FUN_0604DD04, 0x30, "DAT_0604DD34");

void FUN_0604DD04(void)
asm {
    /* function body — 0x30 instruction offset is the alias point */
}
```

**Option B (rejected):** `#pragma entry_alias(FN, offset, ALIAS)`.
Pragmas are easier to add but are silently ignored by other
compilers, which loses the "deletion fails loudly" property at
the source level — if someone deletes `FN` but a stray `#pragma`
remains, no warning. A real declaration is parsed and any
mismatch (FN doesn't exist, etc.) is a hard error.

**Option C (deferred):** in-asm `.asm_entry <name>` directive at
the chosen offset. We *already have* this. But it requires the
function to be naked-asm; a mixed-mode function whose alias point
falls inside a C statement can't use it. Option A subsumes Option
C — the front-end can lower `__entry_alias__` to an `.asm_entry`
directive in the emitted asm when the alias point happens to land
on an asm instruction, but the C-level declaration is the surface.

**Decision needed:** confirm Option A. The `__keyword__` form
matches GCC's `__attribute__` style and is unambiguous against
existing C.

### D2 — offset units

The wishlist example writes `+0x30` — read as a byte offset. SH-2
instructions are 2 bytes (16-bit) or 4 bytes (`.long` data slots
in the function body), so byte offsets are unambiguous. We require
the offset to land on an instruction boundary; a fractional offset
is a hard error.

**Decision needed:** confirm bytes (not instruction count).
Bytes is what the prod evidence carries.

### D3 — placement scope

The alias is emitted *inside* `FN`'s body. It does not become a
standalone function. It does not get its own prologue/epilogue.
Calling the alias enters `FN`'s body at the offset, executes
forward through `FN`'s instructions, and returns via whichever
`rts` it hits.

This is consistent with how SHC produces these aliases in the
prod corpus — they're entry points into a shared body, often used
to skip a prologue or to reuse a tail.

**Decision needed:** is the alias allowed to be referenced from
outside the TU? Default proposal: yes — `.global ALIAS` is global,
matching SHC's behaviour. Restricting to local would cripple the
deletion-safety property (the value of #2 is that *any* caller
becomes a link error).

### D4 — interaction with mixed asm/C functions

Per #4 (already shipped), a function body can mix `asm { ... }`
blocks with C statements under one prologue/epilogue. An alias
at offset `K` could land:

- **Inside an asm block.** Lowers to `.asm_entry ALIAS` at the
  matching instruction inside that block. No new mechanism needed.
- **Inside a C statement.** The C statement compiles to N
  instructions. We need to insert `.global ALIAS` + `ALIAS:` at
  the correct position in the *generated* output. Mechanically:
  emit a sentinel Node into the Node list at the alias position,
  emit2 prints the `.global` + label.
- **At a function-body boundary** (prologue exit, post-rts).
  Same as the asm-block case if naked; same as the C case if
  mixed.

**Decision needed:** is "alias inside a C statement" a real
use case? In the existing corpus the alias points are almost
always at instruction-aligned register-setup gates — naked-asm
territory. Could defer the C-interior case to v2.

### D5 — validation

When `__entry_alias__(FN, offset, "ALIAS")` is parsed, we should
validate:

1. `FN` is a declared function in the TU.
2. `offset` is a non-negative integer that lands on an instruction
   boundary inside `FN`'s body. Requires knowing `FN`'s instruction
   layout, which is only known after instruction selection, not at
   parse time. So validation is a post-emit pass: walk `FN`'s
   Node list, count emitted instruction bytes, check the alias
   sits on a boundary. Mismatch is a hard error.
3. `ALIAS` is a unique symbol name (no clash with another function,
   another alias, or a `.global` from elsewhere in the TU).

### D6 — deletion-safety contract

The contract claimed in DaytonaCCEReverse's wishlist is:

> Deleting the function fails the build if any alias is still
> referenced.

How this falls out:

- Removing `FN`'s declaration from the C source removes its
  `__entry_alias__` declarations (they're attached to `FN`).
- The compiled output no longer emits `.global ALIAS`.
- Any other TU still has `.4byte ALIAS` or `jsr @rN` after a
  pool load of `ALIAS`. Linker complains: undefined symbol.
- Build fails loud, with a complete list of every site referencing
  `ALIAS`.

This is the behaviour wishlist #2 promises. No new policy needed —
sh-elf-ld already does this for any undefined symbol. The novelty
is that `__entry_alias__` makes the dependency *legible at the
source level* — you can grep for `ALIAS` and see every alias
declaration in the TU.

## 3. Open questions

1. **C-interior alias support (D4).** Defer to v2 or include in v1?
2. **Multiple aliases at the same offset.** Allowed?
   `__entry_alias__(FN, 0x30, "A"); __entry_alias__(FN, 0x30, "B");`
   Two `.global` + label entries at the same offset. Plausible if
   SHC ever emitted this; need to check the corpus.
3. **Aliases past `rts`.** Some prod functions have alias entries
   past the apparent end of the body, into trailing data slots
   or pool entries. Is the alias allowed to point at a `.long`
   data slot rather than an instruction? This matters for
   FUN_0604E0F6 + the trailing 262 PROVIDE aliases per the
   removal_landing_zone List 2 entry — those *are* data-table
   aliases, not entry points. Probably want a separate
   `__data_alias__` declaration for that case to keep semantics
   clean.
4. **Negative offsets.** Pre-prologue aliases? Almost certainly
   not real but worth confirming with corpus evidence before
   excluding.
5. **Validation timing.** Parse-time validation can only check
   `FN` exists and `ALIAS` is unique. Offset validation requires
   post-instruction-selection. This means a stray bad alias only
   fires its error very late. Acceptable, or do we want a separate
   pre-validation pass?

## 4. Stages

**Stage 1 — front-end recognition.** Add `__entry_alias__` as a
top-level declaration in `input.c`. Parse and record into a
TU-level alias table (`sh_alias_table`). One entry per alias:
`{ FN, offset, ALIAS }`. Validate that `FN` is declared (or
defer to Stage 3 if forward declaration is allowed).

Test: parse a TU with one alias, confirm the alias table has the
right entry, no codegen change yet.

**Stage 2 — IR attachment.** After instruction selection for `FN`,
walk its Node list, count instruction bytes, find the Node whose
emitted boundary equals each alias's offset, and attach the alias
name to that Node as a sentinel. For naked-asm `FN` whose body
is a single asm block, this is straightforward — the asm-shim
parser already knows each instruction's byte size. For mixed
asm/C `FN`, this is harder; defer to Stage 5 if D4 says we want
v1 to support naked-asm functions only.

Test: a naked-asm `FN` with an alias attached to one instruction;
emit verifies the alias Node is correctly placed.

**Stage 3 — emission.** When emit2 walks the Node list, the alias
sentinel emits `.global ALIAS\n` + `ALIAS:\n` immediately before
the instruction at the alias offset. Verbatim text comes from the
Node's source text or the C codegen as usual.

Test: end-to-end — one alias in a naked-asm `FN`, assemble through
sh-elf-as, run `nm` on the .o, confirm `ALIAS` is a defined global
at the expected offset within `FN`. Also run sh-elf-ld with a
caller TU that references `ALIAS` and confirm linkage succeeds.

**Stage 4 — deletion-safety end-to-end.** Add a regtest:

1. TU A defines `FN` with an alias `ALIAS`.
2. TU B references `ALIAS`.
3. Both link, run, exit cleanly.
4. Delete `FN` from TU A.
5. Re-link. Expect undefined-symbol error naming `ALIAS` and
   citing TU B as the referrer.

This is the *contract* wishlist #2 promises. Pinning it as a
regtest means we cannot accidentally regress it.

**Stage 5 (deferred per D4).** Mixed asm/C `FN` with alias
landing inside a C statement. Postponed pending evidence from the
DaytonaCCEReverse corpus that this case actually occurs.

## 5. What NOT to do

- **Don't make the alias a separate function symbol with its own
  prologue/epilogue.** That breaks the "calling the alias enters
  FN's body and reuses FN's tail" semantic. SHC doesn't do this;
  we shouldn't either.
- **Don't accept fractional or negative offsets** without explicit
  corpus evidence. Hard error by default; loosen only when we
  have a documented use case.
- **Don't introduce a sidecar manifest** of aliases per
  `feedback_no_prod_sidecar_strategies.md` (user memory).
  Aliases are declared in the C source they belong to.
- **Don't conflate with `__data_alias__` (Q3).** Data aliases
  point at `.long` slots; entry aliases point at instructions.
  Different validation, different emission rules. If we need
  data aliases, that's a separate declaration.
- **Don't widen scope to support GCC-style `__attribute__((alias))`.**
  GCC's alias is a same-symbol redirect, not a mid-function entry.
  Different concept; sharing the name would confuse readers.

## 6. Cross-references

- `asm_shim_design.md` — the parsed-asm IR substrate.
- `ipa_design.md` — the writes_r4 oracle that already consumes
  `.asm_entry` directives; aliases participate the same way.
- `gap_catalog.md` — Cat 1 is part of the corpus picture;
  entry aliases are the saturncc-side answer.
- `saturncc_capability_response.md` (in DaytonaCCEReverse) — the
  reply doc this design serves.

## Append log

| Date | Note |
|------|------|
| 2026-04-27 | Initial design. Stages 1–4 in scope for v1; Stage 5 deferred. |
