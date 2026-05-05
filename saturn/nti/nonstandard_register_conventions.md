# Non-standard register parameter conventions — function-signature annotations

## Status

Stub. **TODO finish design.**

## What this is, in plain terms

Standard SH-2 calling convention: arguments in r4..r7 (in order),
returns in r0. SHC's whole-TU analysis sometimes chose *non-standard*
register bindings at function boundaries — e.g.:

- A function whose 1st arg arrives in r0 (not r4).
- A function whose return value is in r8 (not r0).
- A function that takes its 5th argument in a register (not stack).

These violate the standard convention but are internally consistent
within the TU because all callers and the callee agree on the binding.

This is **distinct from IPA register pinning**:

- IPA pinning is "this *register* is preserved across this *call*" —
  a property of the call edge, derived from the callee body.
- Non-standard register conventions are "this *function* takes/returns
  in these registers" — a property of the function signature,
  declared.

So this feature is *annotation-driven* (whole-function pragmas are
fine per user memory `feedback_inline_asm_over_pragma_forests`),
while IPA pinning is *analysis-driven*.

## Why we need it: corpus evidence

- **Gap 15 in the gap catalog** lists examples:
  - FUN_06047748's `rts; mov r4, r8` return shape — r8 as return
    register, non-standard.
  - FUN_0602A664's caller-save-around-`jsr` for r10/r13 — implicit
    declaration that the callee uses r10/r13 as parameters.
- **Cat 7 (R0-shim) at 3%** is a specific subcase: 1st arg in r0,
  not r4. Covered by [`r0_shim_calling_convention.md`](r0_shim_calling_convention.md).
- Without the feature, these functions can't lift cleanly. The lifted
  C either compiles to the standard convention (wrong code) or has
  to use `__asm` blocks to bridge each call (defeats the lift).

## Surface syntax sketch

```c
__attribute__((sh_args(r0, r4)))
__attribute__((sh_return(r8)))
int FUN_06047748(int arg_in_r0, int arg_in_r4);
```

Or pragma form:

```c
#pragma sh_args(FUN_06047748, r0, r4)
#pragma sh_return(FUN_06047748, r8)
```

The pragma form matches existing SHC-style declarations and survives
through other compilers as silent no-ops.

## How it integrates

- **Front-end**: pragma/attribute records the binding into the
  function's symbol-table entry.
- **Caller side** (`gen.c`): when lowering a call, route arguments
  to the declared registers (not the standard r4..r7).
- **Callee side**: prologue treats the declared registers as parameter
  homes; body uses them as such.
- **Allocator**: respects the declared register set as input/output.

## TODO finish design

- Pick attribute vs pragma syntax (probably pragma to match SHC).
- Decide how the feature interacts with multi-entry: does each
  alias have its own argument convention? (Pattern B from
  multi-entry says yes — entries differ by which args are pre-set.)
- Decide on graceful failure when caller-side and callee-side
  declarations disagree — link-time error or compile-time at the
  callsite?
- Define the set of allowed registers (probably r0..r14, excluding
  r15 = stack pointer and any `global_register`-pinned regs).
- Survey corpus for the actual conventions used — how many distinct
  patterns are there? Is it mostly r0-shim, or are there others?

## Cross-references

- [`r0_shim_calling_convention.md`](r0_shim_calling_convention.md) —
  most common subcase, narrow surface.
- [`register_pinning_ipa.md`](register_pinning_ipa.md) — sister
  feature; analysis-driven where this is annotation-driven.
- [`gap_catalog.md`](../workstreams/gap_catalog.md) Gap 15.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
