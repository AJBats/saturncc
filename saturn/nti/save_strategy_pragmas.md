# Save-strategy pragmas — `#pragma noregsave` / `regsave` / `noregalloc`

## Status

Stub. **TODO finish design.** Existing partial implementation: see
`saturn/workstreams/save_strategy_and_asm_intrinsic.md`.

## What this is, in plain terms

By default an SH-2 function pushes every callee-saved register it
writes, then pops them on exit. SHC offered three pragmas to override
this default:

- `#pragma regsave(FN)` — force-save the *full* `[lowest_written..r14]`
  contiguous range, highest-first. The dominant SHC convention for
  ~70% of the race corpus.
- `#pragma noregsave(FN)` — save *nothing*. The function is a leaf or
  trusts callers/callees to handle preservation.
- `#pragma noregalloc(FN)` — don't allocate any callee-saved register
  in this function (so no save is needed; everything fits in caller-
  saves).

The right default depends on the program's calling convention. Plain
GCC/LCC use per-register liveness. SHC's dominant pattern is `regsave`.

## Why we need it: corpus evidence

- **Cat 4 (noregsave family)** — 13% of the race module declares
  non-default save strategy.
- **Cat 1C planning doc** at
  [`saturn/workstreams/save_strategy_and_asm_intrinsic.md`](../workstreams/save_strategy_and_asm_intrinsic.md)
  shows that ~70% of SHC's corpus follows the `[lowest_written..r14]`
  contiguous-range rule (which is `regsave`-shaped). The corpus survey
  was 2,308 functions via `saturn/tools/classify_save_matrix.py`.

The strategic move (per the planning doc): **invert the default**.
Make `regsave` the standard save strategy, and use `noregsave` /
`noregalloc` as the documented opt-outs.

## SHC manual reference

[hitachi_shc_v5.0_fulltext.txt:3006-3046](../resources/manuals/hitachi_shc_v5.0_fulltext.txt).
All three pragmas documented with interaction rules.

## How it integrates

- **Already partial.** `#pragma regsave` shipped (gap-1C planning doc
  describes the strategy).
- **Remaining work**: implement `noregsave` (no-op prologue) and
  `noregalloc` (allocator restriction) as documented; add interaction
  rules between the three; flip the default to `regsave`-style across
  the whole compiler.

## TODO finish design

- Flip-the-default migration plan: how do existing test cases interact
  when default changes from per-reg-liveness to `regsave`-style?
- Interaction with `global_register` (a register reserved by
  `global_register` should not be in `[lowest_written..r14]`).
- Interaction with multi-entry functions: `regsave` range computed at
  the *full-prologue* entry; alternate entries skip portions.
- Decide on `#pragma regsave(FN1, FN2, ...)` vs whole-TU default.
- Per-call-site compatibility: a `regsave` function calling a
  `noregsave` callee — does the caller need extra protection around
  the call?

## Cross-references

- [`saturn/workstreams/save_strategy_and_asm_intrinsic.md`](../workstreams/save_strategy_and_asm_intrinsic.md)
  — full strategy write-up + corpus data.
- [`gap_catalog.md`](../workstreams/gap_catalog.md) Gap 1 — the layer
  taxonomy this fits into.
- [`global_register_pinning.md`](global_register_pinning.md) —
  interaction with reserved registers.
- SHC v5.0 manual §noregsave/regsave/noregalloc.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep; existing planning doc lives in workstreams. |
