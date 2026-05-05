# `#pragma gbr_base` / `#pragma gbr_base1` — GBR-relative globals

## Status

Stub. **TODO finish design.**

## What this is, in plain terms

SH-2 has a dedicated GBR (Global Base Register) used for short-form
addressing: `mov.X @(disp, gbr), rN` is one instruction with an 8-bit
displacement scaled by the operand size. SHC let the source declare
specific globals as "GBR-anchored," after which every access to those
globals compiles to a one-instruction GBR-relative load instead of the
standard two-instruction sequence (pool-load + indirect-load).

`#pragma gbr_base` covers offsets 0..127 (allocated to section `$G0`).
`#pragma gbr_base1` covers 128..255 (section `$G1`). Variables declared
under either pragma are accessed via the short form; everything else
keeps standard pool-relative access.

## Why we need it: corpus evidence

Cat 3 of the SHC annotation census ("global_register / gbr / unsaved
callee-save") accounts for **36% of the race module** — the largest
single annotation burden. The gbr-relative subset is most of that.
Without `#pragma gbr_base`, every access to a GBR-anchored global
compiles to a 2-instruction pool-load sequence — wrong shape, can't
byte-match prod, and the program's global-section layout diverges from
prod's expected memory map.

This is a **must-implement feature** under the editable-decomp framing.
It's documented in the SHC manual; we don't need to invent anything,
just implement what the manual says.

## SHC manual reference

[hitachi_shc_v5.0_fulltext.txt:2980-2998](../resources/manuals/hitachi_shc_v5.0_fulltext.txt).
Documented: declaration syntax, section allocation (`$G0`, `$G1`),
address constraints, offset ranges. The spec is unusually clean for
SHC.

## How it integrates

- **Front-end** (`input.c`, `shc_pragma_hook`): recognises `#pragma
  gbr_base(var, ...)` and `#pragma gbr_base1(var, ...)`, marks each
  named variable as gbr-anchored with its offset slot.
- **Back-end** (`src/sh.md` instruction selector): when emitting a
  load/store of a gbr-anchored variable, selects the
  `mov.X @(disp, gbr), rN` rule instead of the pool-load + indirect-load
  pair. Lburg cost selection should make the gbr form free.
- **Linker** (or startup code): variables placed in `$G0` / `$G1`
  sections; the program's startup must initialise GBR to point at the
  base of `$G0`.

## TODO finish design

- Confirm Daytona's startup code initialises GBR — probe the retail
  binary's reset vector to find where `ldc rN, gbr` happens.
- Decide how `gbr_base1` interacts with `gbr_base` in the same TU
  (separate sections; different displacement ranges; selection rule
  must pick the right form).
- Decide on offset-overflow diagnostics — what happens if the source
  declares more `gbr_base` variables than fit in 0..127.
- Decide on byte/word/long alignment within `$G0` — SH-2's gbr-disp
  encodings scale by operand size, so alignment matters.

## Cross-references

- [`shc_annotation_census_race.md`](../../../DaytonaCCEReverse/docs/shc_annotation_census_race.md)
  Cat 3 — corpus evidence.
- SHC v5.0 manual §gbr_base.
- [`global_register_pinning.md`](global_register_pinning.md) — sister
  pragma; both are documented in the same SHC manual section.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
