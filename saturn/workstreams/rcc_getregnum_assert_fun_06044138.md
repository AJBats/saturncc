# rcc `getregnum` assertion on FUN_06044138

> **Status: RESOLVED 2026-04-18.** Fixed in [src/gen.c](../../src/gen.c)'s
> `getregnum()` — when the kid has a CSE'd original and the original
> has a regnode, walk through and use that instead of aborting. FUN_06044138
> now compiles cleanly as part of the race_FUN_06044060 TU. See commit
> log for the rcc-side fix.

## Repro

1. In [race_FUN_06044060/FUN_06044060.c](../experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c),
   remove the `#if 0` / `#endif` bracketing the `[003/196]` block
   (FUN_06044138).
2. DAT externs for 060443b0–0604441c are already present in
   [ghidra_shim.h](../experiments/daytona_byte_match/race_FUN_06044060/ghidra_shim.h).
3. `cpp -P ... && build/rcc -target=sh/hitachi /tmp/tu.pp.c /tmp/tu.s`

## Symptom

```
rcc: src/gen.c:825: getregnum: Assertion
    `p && p->syms[RX] && p->syms[RX]->x.regnode' failed.
```

Exit 134 (SIGABRT from assert). No `.s` written.

## Context

- Surfaced 2026-04-18 during race_FUN_06044060 TU sanitization,
  nightshift loop.
- Preprocessing is clean; parse is clean; crash is in codegen.
- Function is reasonably complex: 16 local variables including
  `code *`, `undefined1 *`, `undefined4 *`, and `int *`; a
  dispatching `if/else` tree; two `do-while` loops with heavy
  pointer arithmetic; memset-like call via `(*DAT_060443b0)(...)`
  with `code *pcVar1` alias.
- Nothing in [landmines.md](landmines.md) points at this
  assertion — new finding.

## Hypothesis (unconfirmed)

`getregnum` is reached when the register allocator tries to look up
the register a symbol was assigned to, but the symbol's `x.regnode`
is NULL. In LCC, that typically means the allocator dequeued a
symbol that was never promoted into a register node — usually a
wide-tree expression where a subtree needed a register the
allocator didn't reserve.

Likely narrowing candidates:
- the triple-pointer chain `puVar10 = puVar3 + (char)((char)iVar8 * '\x06')`
  (multiple casts, byte-width mul, pointer add) may synthesize an
  intermediate the allocator doesn't track.
- `(*DAT_060443b0)(DAT_060443b4, 0, 0x18)` followed by
  `(*pcVar1)(DAT_060443b8, 0, 0xc)` where `pcVar1 = DAT_060443b0`
  is the function pointer aliased to a local — uncommon shape in
  the corpus so far.

## Investigation path (when picked up)

1. Write a minimal reproducer that triggers the assert with the
   fewest lines (start by commenting out sections of the body
   bisection-style until the crash goes away).
2. Add a stage-4 regtest that reproduces the minimal form.
3. Decide between: fix the allocator to handle the shape, or emit
   a clearer diagnostic + workaround in the Ghidra source.

## Scope discipline

Marked ⚠ in
[TODO.md](../experiments/daytona_byte_match/race_FUN_06044060/TODO.md)
entry 003 and re-wrapped `#if 0`. Shim DAT declarations retained
so a re-attempt doesn't redo that work.
