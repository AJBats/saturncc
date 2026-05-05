# Fallthrough function — function with no `rts`, falls into next function

## Status

Stub. **TODO finish design.**

## What this is, in plain terms

A fallthrough function has no epilogue and no `rts`. When control reaches
the end of its body, it simply falls through to whatever instruction
follows in the section — which is the start of the *next* function. The
next function's prologue runs as if it were called directly, and the
next function's `rts` returns to the original caller.

This is effectively a *manually inlined* tail call where the source
declares "function A's last act is to call function B; emit it as a
fallthrough rather than a `bra` + delay slot."

Saves at minimum two instructions per call site (the `bra` and its
delay slot, or the `jmp` + nop) plus the entire epilogue if there's
nothing left for A to do but return.

## Why we need it: corpus evidence

**Cat 2 of the SHC annotation census — 13% of the race module** (~113
functions). Concentrated in the same annotation-saturated TUs as
multi-entry: FUN_060351CC.s, FUN_0603C304.s, FUN_0604D380.s.

Without support, lifting a fallthrough function to plain C requires
either:

- Emitting a real call + return (changes the byte count, breaks
  byte-match)
- Manually inlining the callee body into the caller (loses
  modularity, prevents independent edits)

Neither is acceptable, so this is a must-implement feature.

## SHC manual reference

Not directly documented as a pragma. Likely either an undocumented
SHC behaviour, or expressed via `#pragma section` placing two functions
adjacent without an `rts` between them, or via raw `.s` modules.
**TODO** confirm by SHC manual close-read.

## How it integrates

Two possible surface syntaxes:

**Option A — pragma:**

```c
#pragma fallthrough(FN_A)
void FN_A(...) { ... } /* no return statement */
void FN_B(...) { ... }  /* must follow FN_A in section */
```

The pragma tells the compiler to suppress FN_A's epilogue/`rts`. The
linker / section rules ensure FN_B physically follows FN_A.

**Option B — attribute:**

```c
__attribute__((fallthrough_to(FN_B)))
void FN_A(...) { ... }
```

Names the destination explicitly. The compiler verifies they end up
adjacent.

Option B is more legible at the source level but requires the compiler
to coordinate with the linker about ordering. Option A is simpler but
relies on the file-order convention.

## TODO finish design

- Pick option A or B (or hybrid).
- Decide how the source signals "function ends without returning"
  cleanly. C has `__builtin_unreachable()` and `__attribute__((noreturn))`
  but those don't fit (the function *does* reach an exit, just not
  via `rts`).
- Section ordering guarantees: do we need `#pragma section
  fallthrough_pair` or similar to force adjacency?
- Interaction with `regsave`: FN_A's epilogue is omitted, but its
  `regsave` pushes still ran. FN_B's prologue runs again — which
  means double-pushes? Or does FN_B get a "shared prologue" treatment
  similar to multi-entry?
- Survey: in the corpus, do fallthrough chains ever exceed length 2
  (A→B→C)?
- Tooling: should `validate_byte_match.sh` understand fallthrough
  pairs as a *structural* unit so byte-match metrics span both
  functions?

## Open relationship to multi-entry

Fallthrough and multi-entry are kin: both are deliberate violations of
the "one function = one symbol = one prologue + body + epilogue"
shape. Worth designing them with shared infrastructure in mind — both
need the IR to model "function boundaries are not all symmetric."

## Cross-references

- [`multi_entry_functions.md`](multi_entry_functions.md) — kin
  feature; both involve unconventional prologue/epilogue handling.
- [`shc_annotation_census_race.md`](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md)
  Cat 2.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
