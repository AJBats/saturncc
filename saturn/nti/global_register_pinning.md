# `#pragma global_register` — register-pinned globals

## Status

Stub. **TODO finish design.**

## What this is, in plain terms

SHC let the source bind a specific global C variable to a specific
SH-2 register, TU-wide. Every read of the variable becomes a register
read; every write becomes a register write. The variable doesn't live
in memory at all (within the TU); it lives in the bound register, and
the register is reserved from allocation.

Used for "hot" globals where the load/store overhead would dominate
the actual work — typically pointers to large per-frame structures
that every function in the TU dereferences.

## Why we need it: corpus evidence

Cat 3 of the SHC annotation census includes the global_register subset.
Functions that use a global_register-bound variable compile to direct
register access; without this feature, every access becomes a pool-load
+ indirect-load + writeback sequence (3 instructions vs 1).

Cat 3 total is 36% of the race module. Splitting between gbr-base and
global_register requires a finer survey, but global_register is real
and load-bearing for at least the hot-path TUs.

## SHC manual reference

[hitachi_shc_v5.0_fulltext.txt:3049-3062](../resources/manuals/hitachi_shc_v5.0_fulltext.txt).
Documented declaration:

```
#pragma global_register(<variable name>=<register name>, ...)
```

Example from manual:

```
#pragma global_register(x=R13, y=R14)
```

## How it integrates

- **Front-end** (`input.c`): pragma binds variable name to register
  number. The variable's address-of becomes invalid (taking the address
  of a register is meaningless).
- **Back-end** (`src/sh.md`): the bound register is reserved (excluded
  from `vmask` and `tmask`). Every read/write of the variable lowers
  to direct register access.
- **Allocator**: must respect the reservation across the whole TU.
- **Calling convention**: bound register is *not* saved across calls
  to functions declared in the same TU (those functions also
  honour the binding). Calls to functions in *other* TUs that don't
  honour the binding require the caller to save/restore around the
  call.

## TODO finish design

- Decide how to handle calls into TUs that *don't* declare the binding.
  Probably auto-emit save/restore at such call sites.
- Decide whether the binding can change across TUs (clean separation)
  or must be project-wide (shared header).
- Audit existing `vmask`/`tmask` machinery in `src/sh.md` for
  reservation hooks. Should slot in cleanly.
- Survey corpus for the actual register choices — does Daytona use
  one global_register variable, or several? Which registers?

## Cross-references

- [`gbr_base_addressing.md`](gbr_base_addressing.md) — sister pragma;
  both reduce global-access overhead, different mechanisms.
- [`save_strategy_pragmas.md`](save_strategy_pragmas.md) — the
  noregsave family; interacts with global_register at call boundaries.
- SHC v5.0 manual §global_register.

## Append log

| Date | Note |
|------|------|
| 2026-05-05 | Stub created under editable-decomp NTI sweep. |
