# Experiment 1: GBR codegen — Cygnus 2.7 vs Hitachi SHC v5.0 R31

## Question

When given C source that describes GBR-relative memory access patterns, does **Cygnus 2.7** produce `mov.? @(disp,gbr)` output, or only **Hitachi SHC**? The 411 production instances of this addressing mode across 34 Daytona race-module files are our target behavior.

## Method

Same C intent, two compilers, two idiomatic input styles. Compare outputs side by side.

- **Hitachi test** (`gbr_test_sh.c`): Uses `#pragma gbr_base(var)` — the native v5.0+ syntax for declaring a variable as GBR-addressable.
- **GCC test** (`gbr_test_gcc.c`): Uses multiple Cygnus-idiomatic approaches:
  1. Plain global struct (what GCC does by default — baseline)
  2. Global register variable declared `asm("gbr")` (Cygnus-SH's closest equivalent to gbr_base)
  3. Inline asm reading GBR as a base pointer

Both test files describe the same memory layout (a `struct s` with mixed-size fields at interesting offsets) and perform the same semantic operations (load and store each field).

## Expected results

- **If Cygnus 2.7 cannot produce `mov.? @(disp,gbr)`**: confirms Hitachi SHC is the right base compiler for Daytona CCE matching, regardless of Cygnus being "structurally close" on simple functions.
- **If Cygnus 2.7 can produce equivalent output**: Cygnus is back on the table as a candidate base, and we need to re-examine whether "Hitachi SHC only" is actually true.
- **If neither produces the exact production pattern**: both are wrong in different ways, and we learn which axes each fails on.

## Files

- `gbr_test_sh.c` — Hitachi test source
- `gbr_test_gcc.c` — GCC test source (multiple strategies)
- `gbr_test_gcc_regvar.c` — GCC test using global register variable
- `build.conf` — DOSBox-X config for Cygnus 2.7
- `run_cygnus.sh` — Drives DOSBox-X headless to compile the GCC test
- `run_hitachi.sh` — Drives Hitachi SHC to compile the SH test
- `out_cygnus.s` — Cygnus 2.7 output (generated)
- `out_hitachi.lst` — Hitachi SHC output (generated)
- `findings.md` — Analysis and conclusion (generated)
