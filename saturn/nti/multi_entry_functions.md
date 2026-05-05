# Multi-entry function — multiple `.global` entry points sharing one body

## Status

Design (full). Promoted from `saturn/workstreams/entry_alias_design.md`
(2026-04-27) under the editable-decomp reframe (2026-05-05). The promoted
version broadens scope from "alias as a wishlist item" to "multi-entry
function as a first-class feature SHC must have had."

No implementation yet. Naked-asm functions can already declare sub-entries
via the existing `.asm_entry` directive (asm-shim Stages 1–5, shipped); the
gap is the C-level declaration form and the integration that lets C bodies
participate.

## Position in one paragraph

A *multi-entry function* is a function with two or more `.global` symbols
that all land inside one shared body — call ALIAS, fall through (or jump)
into FN's instruction stream at offset K, run forward through FN's tail,
return via FN's `rts`. SHC produced this shape extensively in Daytona CCE
(~230 functions, 27% of the race module). C does not natively support it,
so we introduce a declared language-level form authors can use and the
compiler honours. Without this support, the ~230 race functions in this
shape cannot lift to C — they remain hand-asm and inherit asm-editing's
pain when the source is touched.

## What this is, in plain terms

A normal C function has one entry point: `FN`. Callers `jsr FN`, the
prologue saves registers, the body runs, the epilogue restores, `rts`.

A multi-entry function has more than one named entry. `FN_A` enters at
offset 0 (full prologue runs). `FN_B` enters at offset K (skips part of
the prologue). Both run forward through the same body and return via the
same epilogue. The "function" is one shared body of code with multiple
labelled entry points; each entry has its own externally-visible symbol.

The closest analog in mainstream language design is **Fortran's `ENTRY`
statement** (Fortran 77 standard, X3.9-1978 §15.7). Fortran procedures
could declare additional entry points with their own argument lists; all
entries shared the body and shared exit semantics. C never adopted this,
so we are inventing a C-level spelling for it.

This is *not* the same as:

- **Function aliasing** (`__attribute__((alias))`) — that's a same-symbol
  redirect: two names point at the same byte position. Multi-entry is
  different positions in one body.
- **Tail-merging optimisation** — that's compiler-discovered shared-tail
  code, not author-declared shared-body entries.
- **Function outlining** — extracts identical subsequences into helpers.
  Outlined code becomes its own callable, not a shared body with multiple
  entries.
- **Inline thunks** — each thunk has its own prologue that sets up state
  and falls through into a target. Multi-entry functions have *one*
  shared prologue; different entries skip different *amounts* of it.

## Why we need it: corpus evidence

The Daytona race module has ~230 functions in this shape (Cat 1 of the
[SHC annotation census](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md),
27% of the module). They occur in three distinguishable patterns. The
existence of these specific patterns is what makes the feature
load-bearing — none of them can be lifted to plain C without a multi-entry
declaration.

### Pattern A — mid-prologue entry

The simplest and most dispositive pattern. From
[FUN_06029A78.s:6-29](../../../DaytonaCCEReverse/src/race/FUN_06029A78.s):

```
FUN_06029A78:
    mov.l r14, @-r15        ; push r14
    mov.l r13, @-r15
    [... 13 more pushes — every GPR r0..r14 ...]

    .global FUN_06029A96
FUN_06029A96:
    sts.l pr, @-r15         ; push PR
    [body...]
    [shared epilogue pops r0..r14, then rts]
```

Calling `FUN_06029A78` pushes all 15 GPRs + PR. Calling `FUN_06029A96`
pushes only PR — but the shared epilogue still pops all 15 GPRs, meaning
callers of `FUN_06029A96` must have **pre-pushed r0..r14 before the
call**, or the shared epilogue corrupts their stack frame. This is a
caller-side ABI contract that is part of the program's design, not
something a compiler optimisation can synthesize.

### Pattern B — progressive argument setup

From [FUN_06033DC8.s:1974-1987](../../../DaytonaCCEReverse/src/race/FUN_06033DC8.s):

```
FUN_06034BDC:
    mov.l r14, @-r15
    mov r14, r7         ; pre-set r7 (4th arg) = 0
    .global FUN_06034BE0
FUN_06034BE0:
    mov.l r14, @-r15
    mov r14, r6
    mov r14, r5
    jsr @r3
    mov r14, r4
```

`FUN_06034BDC` and `FUN_06034BE0` are the same callable, but
`FUN_06034BDC` is the variant where the 4th argument is auto-set to 0.
This is the Fortran ENTRY shape: parameterless overloads expressed via
entry-point declaration.

### Pattern C — software-pipelined entries with internal cross-references

From [FUN_0604C76C.s:1142-1212](../../../DaytonaCCEReverse/src/race/FUN_0604C76C.s):
seven `.global` entries (FUN_0604CFD6, FUN_0604CFDE, FUN_0604D00C,
FUN_0604D03E, FUN_0604D042, FUN_0604D0F4, FUN_0604D112) packed into one
shared body, with the body itself branching to its own sibling entry
labels (lines 1111, 1133, 1217, 1263). This is hand-engineered software
pipelining — the seven entries form a coordinated state machine where
control flow walks between named entry points as a deliberate algorithm.

## Why merge-optimizer-shaped solutions are inadequate

A reasonable first hypothesis is that SHC produced this shape via some
merge optimisation pass. The corpus evidence rules that out. Three flavors
of merge optimisation exist:

1. **Function merging** (LLVM `MergeFunctions`, Edler von Koch / Seeker) —
   replaces semantically-identical functions with thunks. Doesn't apply:
   the functions aren't identical, and the result has thunks pointing at
   one body, not in-body globals.
2. **Function outlining** (LLVM `MachineOutliner`, Paquette 2017) —
   extracts duplicated subsequences into helper functions. Doesn't apply:
   outlined code becomes its own callable, not a shared body with
   multiple entries.
3. **Tail merging** (every modern compiler does this) — collapses
   identical-suffix paths to share an epilogue. Closest match, but
   structurally cannot:
   - Synthesize Pattern A's caller-side stack-push contract.
   - Add or remove arguments as in Pattern B.
   - Introduce internal control flow between merged regions as in
     Pattern C.

The prod evidence shows source-level coordination between caller, callee,
and multiple entry symbols — part of the program's ABI, not a transparent
optimisation. Sega's source must have declared the shape directly. Our
job is to honour an authored declaration, not to discover the shape from
plain C.

## Literature / prior art

- **Fortran 77 standard (X3.9-1978) §15.7** — canonical specification of
  the `ENTRY` statement. The intellectual ancestor of multi-entry
  functions.
- **GCC removal of nested-function multi-entry constructs** — historic
  gcc-patches discussion explaining why GCC dropped its few multi-entry-
  shaped features (debug info, exception handling, register-save
  bookkeeping complexity). The same concerns we're about to take on.
- **LLVM `MachineOutliner` (Paquette 2017)** — different intent (size
  optimisation) but same underlying problem of multiple
  `MachineBasicBlock` entry points within one `MachineFunction`. Worth
  modelling on for IR shape.
- **ELF symbol model + Linux's `linkage.h` `SYM_FUNC_ALIAS` macros** —
  the simplest possible implementation: emit two `.global` symbols
  pointing at offsets within one body. ELF doesn't care about the
  internal structure; symbols are (name, offset) pairs.
- **Ghidra's `Function.getEntryPoint()` model** — explicitly handles
  multiple entry points per function. Useful as the model the corpus
  evidence flows through (Ghidra-decompiled C drops the alias info, but
  the Function metadata retained it).

## How it integrates into our compiler shape

Substrate already in place:

- **`.asm_entry NAME` directive** — parsed at
  [sh.md:3801-3815](../../src/sh.md), stored on asm-shim instruction
  records, recognised by the simulator's `writes_r4` oracle
  ([sh.md:1716](../../src/sh.md)), per-entry verdicts emitted at
  [sh.md:3971](../../src/sh.md). Naked-asm functions can already declare
  sub-entries; this is what runs in the Stage 1–5 path today.
- **Asm-shim Node-list IR** — Stage 1's parser produces `sh_asm_insn`
  records carrying source text, mnemonic, operands, reads/writes masks.
  Each one becomes a Node in the same Node-list IR where C lowers. The
  right place to attach alias metadata.

The new work is:

1. **Front-end declaration form.** A C-level declaration
   `__entry_alias__(FN, offset, "ALIAS")` recognised at file scope.
   Parses to a TU-level alias table. One entry per alias: `{ FN, offset,
   ALIAS }`.
2. **IR attachment.** After instruction selection for `FN`, walk its
   Node list, count emitted instruction bytes, find the Node whose
   boundary equals each alias's declared offset, attach the alias name
   to that Node as a sentinel.
3. **Emission.** When `emit2` walks the Node list, the alias sentinel
   emits `.global ALIAS\n` + `ALIAS:\n` immediately before the
   instruction at the alias offset.

For naked-asm functions whose body is a single asm block, the asm-shim
parser already knows each instruction's byte size — straightforward to
find the right Node. For mixed asm/C functions where the alias point
falls inside a C-lowered region, this is harder; defer to v2.

## Surface syntax: decisions to lock in

### D1 — declaration form

```c
__entry_alias__(FN, offset, "ALIAS");
```

at file scope. Recognised by `shc_pragma_hook` in `input.c` or as a
registered top-level keyword. The `__keyword__` form matches GCC's
`__attribute__` style and is unambiguous against existing C.

Rejected alternatives:

- **`#pragma entry_alias(FN, offset, ALIAS)`** — silently ignored by
  other compilers, loses the deletion-fails-loud property at the source
  level. A real declaration is parsed and any mismatch (FN doesn't
  exist, offset off-boundary, etc.) is a hard error.
- **In-asm `.asm_entry NAME` only** — already exists, but requires the
  function body to be naked-asm; mixed-mode bodies can't use it
  directly. The C-level declaration subsumes it; the front-end can
  lower `__entry_alias__` to `.asm_entry` in the emitted asm when the
  alias point happens to land on an asm instruction.

### D2 — offset units

Bytes. SH-2 instructions are 2 bytes (16-bit) or 4 bytes (`.long` slots
in the function body); byte offsets are unambiguous. The offset must
land on an instruction boundary; fractional offset is a hard error.

### D3 — placement scope

The alias is emitted *inside* `FN`'s body. It does not become a
standalone function. It does not get its own prologue/epilogue. Calling
the alias enters `FN`'s body at the offset, executes forward through
`FN`'s instructions, and returns via whichever `rts` it hits.

This is consistent with how SHC produces these aliases in the prod
corpus — they are entry points into a shared body, often used to skip
prologue work or to reuse a tail.

### D4 — visibility

Default `.global`, matching SHC's behaviour. Restricting to local would
cripple the deletion-safety property (the value of the contract is that
*any* caller becomes a link error if the parent is removed).

### D5 — interaction with mixed asm/C functions

Per the asm-shim Stage 4 design, a function body can mix `__asm { ... }`
blocks with C statements under one prologue/epilogue. An alias at
offset `K` could land:

- **Inside an asm block.** Lowers to `.asm_entry ALIAS` at the matching
  instruction inside that block. No new mechanism needed.
- **Inside a C statement.** The C statement compiles to N instructions.
  We need to insert `.global ALIAS` + `ALIAS:` at the correct position
  in the *generated* output. Mechanically: emit a sentinel Node into the
  Node list at the alias position; emit2 prints the `.global` + label.
  Defer to v2 unless corpus evidence forces it.
- **At a function-body boundary** (prologue exit, post-rts). Same as
  the asm-block case if naked; same as the C case if mixed.

### D6 — validation

Parse-time:

- `FN` is a declared function in the TU.
- `ALIAS` is a unique symbol name (no clash with another function,
  another alias, or a `.global` from elsewhere in the TU).

Post-instruction-selection:

- `offset` lands on an instruction boundary inside `FN`'s emitted body.

Post-link (already free via sh-elf-ld):

- Removing `FN` removes its `__entry_alias__` declarations; any caller
  still referencing `ALIAS` becomes an undefined-symbol error naming
  the call site.

### D7 — multiple aliases at the same offset

Allowed. Two `.global` directives + two labels at the same instruction
position. Plausible if SHC ever emitted this; check the corpus before
v1.

### D8 — aliases past `rts`

Probably not allowed for *entry* aliases. Some prod functions have
alias entries past the apparent end of the body, into trailing data
slots or pool entries. Those are *data aliases* (function-pointer-table
entries), not entry points. A separate `__data_alias__` declaration is
the right home; out of scope for this doc.

### D9 — negative offsets

Hard error by default. Loosen only if corpus evidence requires.

## Stages

**Stage 1 — front-end recognition.** Parse `__entry_alias__(...)` at
file scope, record into TU-level alias table. No codegen change yet.
Test: parse a TU with one alias, confirm the alias table has the right
entry.

**Stage 2 — IR attachment.** After instruction selection for `FN`, walk
the Node list, count instruction bytes, find the Node whose emitted
boundary equals each alias's offset, attach the alias name as a
sentinel. Naked-asm bodies only in v1. Test: a naked-asm `FN` with an
alias attached to one instruction; emit verifies the alias Node is
correctly placed.

**Stage 3 — emission.** `emit2` recognises alias sentinels, emits
`.global ALIAS\n` + `ALIAS:\n` immediately before the instruction at
the alias offset. Test: end-to-end — one alias in a naked-asm `FN`,
assemble through sh-elf-as, run `nm` on the .o, confirm `ALIAS` is a
defined global at the expected offset within `FN`. Run sh-elf-ld with
a caller TU that references `ALIAS` and confirm linkage succeeds.

**Stage 4 — deletion-safety regtest.** TU A defines `FN` with alias
`ALIAS`. TU B references `ALIAS`. Both link and run cleanly. Delete
`FN` from TU A. Re-link. Expect undefined-symbol error naming `ALIAS`
and citing TU B as the referrer. This is the editing-safety contract
that justifies the whole feature; pinning it as a regtest prevents
regression.

**Stage 5 (deferred) — alias inside a C statement.** Mixed-mode body
where the alias point lands inside a C-lowered region. Postponed
pending evidence from the DaytonaCCEReverse corpus that this case
actually occurs.

## What we'd validate end-to-end

1. A naked-asm function with one alias compiles; the assembled .o has
   both symbols at the expected offsets (`nm` check).
2. A second TU referencing the alias links cleanly through sh-elf-ld
   and runs in the emulator without divergence.
3. Deleting the parent function fails the link with a clear error
   naming the alias and the referencing site.
4. All three corpus patterns (A mid-prologue, B progressive args,
   C software-pipelined) compile from declared C source to byte-
   equivalent prod output (after Bucket B normalisation).

## Scope: honestly stated

**In scope for v1:**

- Naked-asm function bodies with `__entry_alias__` declarations.
- Multiple aliases per function (no fixed cap; bounded by the alias
  table).
- Aliases at instruction boundaries within the body.
- Default `.global` visibility.

**Deferred to v2:**

- Aliases landing inside C-statement-lowered regions of mixed-mode
  functions (D5 third bullet).
- `__data_alias__` for aliases pointing into `.long` data slots rather
  than instructions.

**Out of scope:**

- Discovering merge opportunities from plain C. We honour declarations;
  we don't invent them.
- GCC-style `__attribute__((alias))`. Different concept; sharing the
  name would confuse readers.
- Negative offsets or fractional offsets without explicit corpus
  evidence.

## Cross-references

- [`asm_shim_design.md`](../workstreams/asm_shim_design.md) — the
  parsed-asm IR substrate this rides on.
- [`path_sensitive_walker.md`](path_sensitive_walker.md) and
  [`interprocedural_predicate_summaries.md`](interprocedural_predicate_summaries.md)
  — analyzer capabilities that complement multi-entry but are
  independent features.
- [`shc_annotation_census_race.md`](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md)
  — the corpus survey that quantified Cat 1 at 27%.
- [`gap_catalog.md`](../workstreams/gap_catalog.md) — Cat 1 doesn't
  appear there because the gap catalog tracks codegen divergences;
  multi-entry is a *missing feature*, not a divergence.

## Append log

| Date | Note |
|------|------|
| 2026-04-27 | Original design as `entry_alias_design.md` in workstreams (Stages 1–4 in scope, Stage 5 deferred). |
| 2026-05-05 | Promoted to NTI under editable-decomp reframe. Folded in prod-evidence narrative for Patterns A/B/C. Added merge-optimizer rebuttal and literature/prior-art section. Original `entry_alias_design.md` reduced to a pointer at this file. |
