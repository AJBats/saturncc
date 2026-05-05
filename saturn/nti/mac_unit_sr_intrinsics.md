# MAC-unit and SR-flag intrinsics — `mac.l`, `dmuls.l`, `sts macl/mach`, `clrmac`

## Status

Stub. **TODO finish design.**

## What this is, in plain terms

SH-2 has a hardware multiply-accumulate unit with two 32-bit registers
(`MACL`, `MACH`) that can hold a 64-bit accumulator. Several
instructions read/write the MAC unit:

- `mac.l @rA+, @rB+` — fused 32×32→64 multiply-accumulate with two
  post-increment loads. One instruction; integral to physics/matrix
  inner loops.
- `dmuls.l rA, rB` — signed 32×32→64 multiply, result in MACL/MACH.
- `sts macl, rN` / `sts mach, rN` — read MAC half into a GPR.
- `clrmac` — clear MACL/MACH.

Plus SR-register flag operations (`movt`, `bf`/`bt` reading the T flag,
etc.) that don't have clean C equivalents.

These can't be expressed in standard C. The hardware operations require
direct register-pair semantics that C's type system doesn't model.

## Why we need it: corpus evidence

**Gap 14 in the gap catalog** — currently three race-module functions
(plus four functions in FUN_06044060.s — the FUN_06045FC0 / FUN_060463E4
/ FUN_06046478 / FUN_06046520 family) cannot lift to C at all because
their bodies are dominated by `mac.l` chains.

[`gap_catalog.md`](../workstreams/gap_catalog.md) Gap 18 covers the
codegen story for these; Gap 14 covers the C-source expressivity.

Ghidra's de-fused output (50+ lines of explicit Karatsuba math per
fused `mac.l`) is technically C but unreadable and structurally
guarantees we'll never byte-match prod.

## How it integrates

Two complementary mechanisms:

**Inline `__asm` blocks.** The asm-shim path already supports embedding
arbitrary asm in a C function body. For per-function MAC-heavy code,
the entire computation is one `__asm { ... }` block with the prod
sequence inline. Lowest-effort, high-fidelity. Keeps the function
declared in C so call sites stay clean.

**`__builtin_*` intrinsics.** Compiler-recognised function calls that
lower to specific instructions:

- `__builtin_sh_mac_l(int *a, int *b)` — emits `mac.l @rA+, @rB+`,
  consumes the accumulator state implicitly.
- `__builtin_sh_dmuls_l(int a, int b)` — emits `dmuls.l rA, rB`.
- `__builtin_sh_sts_macl()` / `__builtin_sh_sts_mach()` — read MAC
  half.
- `__builtin_sh_clrmac()` — clear.

Intrinsics keep the source readable as C-shaped code (loops, control
flow) while letting the compiler emit the right instructions.

## TODO finish design

- Decide split between `__asm` and `__builtin_*`. Probably: tight
  inner loops use `__asm`; mixed-flow functions use builtins.
- Decide whether MAC accumulator state is implicit (a global the
  builtins manipulate) or explicit (a `mac_state_t` opaque type
  threaded through builtin calls). Implicit matches hardware;
  explicit lets the C type system catch some misuse.
- Lburg rules for the `dmuls.l + mac.l` chain pattern (Gap 18 in the
  gap catalog).
- Saturation logic (the `SR.S` paths in the FUN_06045FC0 family) —
  separate intrinsic or part of the chain rule?
- `sts.l mach, @-r15` (push MAC half to stack) — common idiom; needs
  its own builtin or covered by `__asm`.

## Cross-references

- [`gap_catalog.md`](../workstreams/gap_catalog.md) Gap 14
  (expressivity), Gap 18 (`mac.l` codegen).
- [`r0_shim_calling_convention.md`](r0_shim_calling_convention.md) —
  similar inline-`__asm`-vs-builtin tension at smaller scope.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
