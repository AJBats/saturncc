# R0-shim calling convention — first argument in r0

## Status

Stub. **TODO finish design.** Lowest priority of the must-implement
features — only 3% of the corpus, narrow surface, and inline `__asm`
already covers it pragmatically.

## What this is, in plain terms

Standard SH-2 convention: 1st argument in r4. Some Daytona functions
take their 1st argument in **r0** instead. Callers `mov` the value
into r0 before the `jsr`; callees expect r0 to hold the parameter on
entry.

SH-2's r0 has hardware-level privileges no other GPR has — it's the
required destination for `mov.b @(disp, rN), R0`, the required source
for indexed addressing, and the implicit operand of several arithmetic
instructions. So a function that immediately uses its parameter in
one of those contexts saves an instruction by having the parameter
arrive in r0 directly.

## Why we need it: corpus evidence

**Cat 7 of the SHC annotation census — 3% of the race module** (~24
functions). Detected by proxy via "`mov r0, rN` as first instruction"
(the survey notes this may under-count).

Smaller corpus footprint than the other Bucket-A features, but the
feature is necessary for those 24 functions to lift cleanly.

## How it integrates — two options

**Option A: subcase of non-standard register conventions.**

Express via the [`nonstandard_register_conventions.md`](nonstandard_register_conventions.md)
mechanism:

```c
#pragma sh_args(FUN_X, r0)
int FUN_X(int arg_in_r0);
```

Caller-side codegen routes the arg to r0; callee-side prologue
treats r0 as the parameter home. No special-casing.

**Option B: leave as inline `__asm`.**

Per user memory `feedback_inline_asm_over_pragma_forests`, per-site
SHC oddities get `__asm` blocks rather than new pragma classes. The
24 corpus functions could be lifted with `__asm` shims at the call
site:

```c
extern int FUN_X(int arg);
/* ... */
register int v __asm("r0") = computed_value;
result = FUN_X(v);
```

Plus an `__asm` block in the callee body that uses r0 directly as
the param.

This is uglier in source but doesn't require a new feature. Acceptable
if R0-shim turns out to be the only non-standard convention in the
corpus.

## TODO finish design

- Confirm Option A subsumes this cleanly — is r0-as-param really
  just one binding among many, or does its hardware-privilege
  semantics force special handling?
- If Option A: this stub merges into
  [`nonstandard_register_conventions.md`](nonstandard_register_conventions.md).
- If Option B: this stub becomes a how-to guide for hand-lifting
  the 24 affected functions and doesn't need a compiler feature.
- Survey: are the 24 detected functions actually all R0-shim, or
  are some false positives from the proxy detection?

## Cross-references

- [`nonstandard_register_conventions.md`](nonstandard_register_conventions.md)
  — likely parent feature.
- [`shc_annotation_census_race.md`](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md)
  Cat 7.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
