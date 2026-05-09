# Multi-entry function implementation (A1)

**Status:** active. Promoted from
[`saturn/nti/multi_entry_functions.md`](../nti/multi_entry_functions.md)
on 2026-05-05.

**Roadmap row:**
[editable_decomp_roadmap.md#A1](editable_decomp_roadmap.md). Milestone
[M1](editable_decomp_roadmap.md) — first multi-entry function lifted
end-to-end.

**Design doc:** see the NTI doc above. This workstream owns
implementation stages; design changes should round-trip through the NTI
doc.

## Why this exists (the brass tacks)

The DaytonaCCEReverse side documented the dispositive case in
[`decomp_request_dead_code_safety_FUN_06036BB8_case.md`](../../../DaytonaCCEReverse/workstreams/transplant/decomp_request_dead_code_safety_FUN_06036BB8_case.md).
Two attract-demo regressions traced to one structural bug: the deletion-
safety audit operates per-`FUN_X`-symbol, but multiple `FUN_X` labels
describe one shared body. Attempts to remove dead code corrupted live
code in ways that didn't surface until a specific runtime path fired
nine frames deep in the per-frame dispatch.

Concretely, the FUN_06036BB8 case has four "functions" in source order:

| Source line | Symbol | Bytes | rts? |
|---|---|---:|---|
| 3770 | `FUN_06036B60` | 14 | **no** — falls through |
| 3780 | `FUN_06036B6E` | ~74 | yes |
| 3822 | `FUN_06036BB8` | 14 | **no** — falls through |
| 3832 | `FUN_06036BC6` | ~306 | yes |

…plus 12 orphan bytes inside `FUN_06036BC6`'s body, exposed only via
`PROVIDE(DAT_06036CEC = FUN_06036BC6 + 0x126)` in `race.ld` — no source-
level symbol at all.

The two no-rts entries are register-save prologue chunks that fall
through into the next function. `FUN_06036B60` pre-pushes the seven
registers `FUN_06036B6E`'s 1-push prologue is missing; the shared
epilogue at `FUN_06036B6E`'s tail pops all eight. The pattern matches
NTI Pattern A (mid-prologue entry) verbatim. Same structural shape:
`FUN_06036BB8 → FUN_06036BC6`. The orphan 12 bytes is data hanging off
`FUN_06036BC6`'s end.

`grep` for `bsr FUN_06036B6E|FUN_06036BB8|FUN_06036BC6` in the decomp
tree returns **zero direct callers**. The only static reference is one
pool entry in `FUN_06037E28`'s dispatch (`.4byte DAT_06036BB8`) loaded
into r12 and `jsr @r12`'d. This is why per-symbol auditing fails: the
caller-side reference is a pool entry, not a `bsr` instruction.

**The trivialization:** this workstream's deliverable is that a lifted
version of this file declares the two multi-entry functions explicitly.
A `bsr ALIAS` reference, an indirect-via-pool reference, or a `PROVIDE`
all bind the alias's lifetime to the parent. Removing the parent fails
the link with an undefined-symbol error citing the still-referenced
alias and the call site. No watchpoint archaeology needed; the linker
runs the audit.

## In and out of scope for v1

**In scope.** Patterns A, B, C from the NTI doc. Naked-asm function
bodies with `__entry_alias__` declarations. Stage 1–4 below.

**Adjacent but separate.** The orphan 12 bytes in the FUN_06036BB8 case
is a *data alias*, not an entry alias. It points into trailing bytes
that are read as data, not executed. NTI doc §D8 defers these to a
future `__data_alias__` feature. The deletion-safety story for the
FUN_06036BB8 case requires both — entry alias for `FUN_06036BB8 →
FUN_06036BC6`, data alias for `DAT_06036CEC = FUN_06036BC6 + 0x126`.
Tracking the data-alias gap in the roadmap as a follow-up; not blocking
M1.

## Stages

Stages mirror the NTI doc. Each stage's exit criterion is the test
listed; promote to the next stage only after green.

### Stage 1 — front-end recognition

**Goal.** Parse `__entry_alias__(FN, offset, "ALIAS")` at file scope into
a TU-level alias table.

**Implementation.**

- New lexer keyword (or `__keyword__`-style identifier reservation)
  recognized by `input.c`'s `shc_pragma_hook` or by lcc's front-end
  declarator parser. Choose based on which is cleaner — the
  `__keyword__` form needs to live in C scope, not the pragma hook;
  pragma hook is for `#pragma`-spelled extensions. Multi-entry is a
  declaration, not a pragma.
- Alias table entry: `{ symbol *FN, int offset, const char *alias }`.
- Validation at parse time: FN is a declared function in the current
  TU; alias name is unique.

**Exit test.** Compile a TU containing one `__entry_alias__(FN, 14,
"ALIAS")`. Inspect the alias table; confirm the entry exists with the
right FN binding, offset, and alias name. Mismatched offset (e.g., not
on instruction boundary — checked in Stage 2) is fine to defer; just
parse and store.

### Stage 2 — IR attachment

**Goal.** After instruction selection for `FN`, walk its Node list,
count emitted instruction bytes, find the Node whose boundary equals
each alias's declared offset, and attach the alias name as a sentinel
on that Node.

**Implementation.**

- Walk lcc's emit-time Node list with a running byte counter using
  per-Node sizing already known to the asm-shim parser (every SH-2
  instruction is 2 or 4 bytes).
- For each alias whose `FN` matches the function being processed, look
  up the Node at `offset` and attach the alias.
- Hard error if `offset` doesn't land on an instruction boundary.

**Exit test.** Naked-asm `FN` with one alias. Confirm the alias Node is
correctly placed in the IR (instrument the emit pass to log alias
attachments).

### Stage 3 — emission

**Goal.** `emit2` recognizes alias sentinels and emits `.global ALIAS\n`
+ `ALIAS:\n` immediately before the instruction at the alias offset.

**Implementation.**

- One sentinel-Node case in `emit2`. Output is two lines per alias.

**Exit test.** End-to-end:

1. Naked-asm function `FN` with `__entry_alias__(FN, 14, "ALIAS")`.
2. Compile through rcc → sh-elf-as → produce `.o`.
3. `nm FN.o` shows both `FN` and `ALIAS` as defined globals at the
   expected offsets.
4. Caller TU references `ALIAS`; sh-elf-ld links cleanly.

### Stage 4 — deletion-safety regtest

**Goal.** Pin the editing-safety contract as a regression test. This is
the test that proves the FUN_06036BB8 case is trivialized.

**Implementation.**

- TU A: defines `FN` with `__entry_alias__(FN, 14, "ALIAS")`.
- TU B: declares `extern void ALIAS(void);` and calls `ALIAS()`.
- Both link and run in the test harness.
- Delete `FN` from TU A. Re-link.
- Expected: undefined-symbol link error naming `ALIAS` and citing TU
  B as the referrer.

**Exit test.** The above scenario as a `validate_byte_match`-class
regtest under `saturn/experiments/multi_entry/`. Green = M1 ready to
land.

### Stage 5 — alias inside a C statement (deferred)

Per NTI §D5 third bullet, a future v2 feature for mixed-mode bodies
where the alias point lands inside a C-lowered region. Not required
for any of the three corpus patterns (A, B, C are all naked-asm-shaped
in lifted form).

## M1 acceptance — first multi-entry function lifted

After Stages 1–4 pass:

1. Pick one corpus Cat 1 function. **Candidate:** the FUN_06036BB8
   pair (`FUN_06036BB8 → FUN_06036BC6`). Smaller and simpler than
   `FUN_06029A78` / `FUN_06034BDC`; directly addresses the case that
   motivated the workstream.
2. Lift its TU to C with `__entry_alias__` declarations.
3. `rcc → sh-elf-as → sh-elf-ld` reproduces the prod bytes (tier-1
   strict or tier-2 normalized — either is acceptable for M1; the
   thesis is editability, not byte-perfection of one function).
4. Caller TU (`FUN_06037E28`'s pool entry → `.4byte DAT_06036BB8` →
   `jsr @r12`) links cleanly against the lifted output.
5. Mutation test: delete `FUN_06036BB8` from the C source. Re-link.
   Expected: link fails with undefined-symbol error citing `ALIAS` and
   the pool entry's location.

When all five hold, M1 is shipped. Move A1 status to `shipped`. Update
[`editable_decomp_roadmap.md`](editable_decomp_roadmap.md) progress log.

## Open questions

- **Pool entry as alias reference.** The FUN_06037E28 pool entry
  `.4byte DAT_06036BB8` — does ld treat this as a strong reference for
  undefined-symbol detection? Test before assuming. (`.4byte SYMBOL`
  inside a `.text` section's pool should produce a `R_SH_DIR32` reloc
  that ld resolves; confirming.)
- **PROVIDE-style data alias for `DAT_06036CEC`.** Out of M1 scope but
  needs design before any lift of FUN_06036BC6's TU is fully clean.
  Tracked as `A1.5 — data aliases` (TBD) in the roadmap rollup;
  separate NTI doc when promoted.

## Progress log

Newest first.

- `2026-05-05` — workstream opened. A1 promoted from NTI to active. M1
  acceptance criteria anchored to FUN_06036BB8 case.
