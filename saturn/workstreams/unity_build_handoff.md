# Unity-build session handoff

**Status: closed.** Branch `asm-shim/session-1-lexer-parser` (saturncc)
+ `master` (DaytonaCCEReverse) carry the full unity-build bring-in
of the race module. `make -C decomp validate` produces a race.bin
that is byte-identical to retail RACE.BIN.

This doc is for the *next* session that picks up where this one
ended — it captures what landed, what's deliberately deferred, and
the small cleanup items the user flagged in conversation.

## What this branch achieved

The race module of Daytona USA CCE is now built end-to-end through
saturncc as a unity build:

```
decomp/race/race.c (39 #include's of FUN_*.c)
  ↓ cpp -P
decomp/build/race/race.pp.c
  ↓ saturncc (build/release/rcc -target=sh/hitachi)
decomp/build/race/race.s   (~91k lines, single .text)
  ↓ sh-elf-as
decomp/build/race/race.o
  ↓ sh-elf-ld -T decomp/race/race.ld
decomp/build/race/race.elf
  ↓ sh-elf-objcopy -O binary
decomp/build/race/race.bin (169480 bytes, byte-identical to retail)
```

- 852 individual `int FUN_X(void) asm { ... }` C functions split
  across 39 TU files in `decomp/race/`.
- One-command build (`make -C decomp`) and validate
  (`make -C decomp validate` — cmps against
  `build/disc/files/DAYTONA/RACE.BIN`).
- Byte-shift validation **organically confirmed**: adding a real
  4-byte function in source caused 100% of downstream cross-function
  references to re-resolve correctly (1504 pool entries shifted by
  exactly +4, zero unexpected anomalies). Same property prod's
  `make 4shift` validates synthetically; we exercise it through
  actual code.

## Saturncc-side commits (asm-shim/session-1-lexer-parser)

In order, atop the previously-shipped Stage 1-5 asm-shim work:

- `505781e` — directive operand `#` prefix dropped (the
  per-operand emit conflated `mov #1, r3` with `.byte 0x30`;
  directive operands now print bare).
- `0b0b3ca` — directives emit verbatim from `src_text`. The
  parsed-operand path can't represent shapes like
  `.type X, @function` or `.4byte sym /* c */`; falling back to
  `src_text` makes the assembler the authority on directive
  syntax.
- `85e7d16` — drop leading underscore from C symbol names.
  Hitachi SHC convention is bare names; saturncc was mangling
  to `_FUN_X`. Was papered over at the per-function tier-1
  metric (asm_normalize.py strips both forms) but became fatal
  at link time when shim asm bodies referenced bare `bsr FUN_X`.
- `efe6bbb` — naked-emit `.align 1` (= 2-byte) instead of
  `.align 2` (= 4-byte). Required because per-entry split
  places multiple asm-bodied functions back-to-back, and prod
  function entries can sit at 2-mod-4 offsets (e.g.
  `FUN_0604DF12`); 4-byte alignment would shift those by 2.

`build/release/rcc` is the rubber-stamped artifact downstream
projects (CCE) consume. Re-stamp via `bash saturn/tools/release.sh`.

## DaytonaCCEReverse-side commits (master)

- `aadfb56b` — `decomp/` scaffolding + beachhead FUN_06029810.
- `f0e8ea70` — all 39 race TUs as naked asm shims +
  `decomp/tools/{gen_shim.py, diff_tu.sh}`.
- `048f7a25` — `diff_tu.sh` re-assembles prod from source for
  clean reference (avoids transplant overlays in `build/race/*.o`).
- `ebb2cdf2` — link unity race.bin (mega-block layout).
- `a661aa73` — `make validate` target against retail RACE.BIN.
- `3610f7ff` — split each TU into per-entry C functions
  (852 individual asm-bodied entries).

## Cleanup items the user flagged (next session)

These came up in the post-implementation review. **Each was
explicitly user-confirmed before being added here.**

### 1. Delete the bring-in scaffolding scripts

User: *"we don't need these generators anymore... source is now
THE SOURCE for the decomp project. We can probably kill all these
gen scripts."*

Files to delete (per project rules, requires `pineapple` safe-word
authorization at deletion time):

- `decomp/tools/gen_shim.py` — generated naked shims from prod `.s`
- `decomp/tools/diff_tu.sh` — per-TU diagnostic against pristine prod
- `decomp/tools/diff_bin.sh` — full-bin diagnostic against pristine prod

The `make validate` target (which cmps against the retail extract)
is the live test going forward; the `diff_*` tools were
bring-in-only diagnostics. `gen_shim.py` is single-use scaffolding;
hand edits to `decomp/race/*.c` are now the source of truth.

If a regen ever becomes useful, the scripts are recoverable from
commits `f0e8ea70` / `ebb2cdf2`.

### 2. The `int FUN_X(void)` signature is a placeholder

User-confirmed deferred. Most prod functions take real arguments;
the `(void)` lie is harmless today because every caller is also an
asm shim using SH-2 ABI directly. Becomes a real concern only when
non-shim C callers want to call lifted functions — which is the
"real C decomp" workstream, explicitly out of scope for this branch.

### 3. Hardcoded saturncc path in the decomp Makefile

`SATURNCC := /mnt/d/Projects/saturncc/build/release/rcc` is
WSL-specific and ties the two repo paths. Acknowledged as
"icky but right at this stage" during planning. Not blocking. If
saturncc moves on disk, edit one line. If CI ever happens, lift
to a configurable variable.

### 4. Saturncc emits `.text` per asm-bodied function

852 occurrences of `\t.text\n` in the unified .s. Cosmetic only —
re-entering an already-active section is a no-op. Wasteful in
source-text size, harmless in assembled bytes. Very low priority.

### 5. CRLF/LF line ending warnings on commit

Python writes whatever default the host OS uses (CRLF on Windows);
git auto-normalizes to LF on commit per `.gitattributes`. Cosmetic
warnings only, no real impact. Very low priority.

## Things to be aware of

### `build/race/*.o` carries transplant overlays

The user has parallel transplant work (`mods/transplant/`,
commits like `ba9cf0de`) that modifies `build/race/race_free.bin`.
Our `make -C decomp validate` targets the retail extract
(`build/disc/files/DAYTONA/RACE.BIN`) directly — that's
pristine, not transplanted, and never changes regardless of
parallel work state. As long as `make validate` is the
authoritative test, transplant state is irrelevant to us.

### The PROVIDE chain in race.ld

1797 lines of `PROVIDE(DAT_X = 0xX)` and
`PROVIDE(DAT_X = FUN_Y + offset)`. Inherited from prod's
`race_free.ld`. The asm bodies use symbolic names (`.4byte
DAT_X`); the linker resolves them via these PROVIDEs.

Could be eliminated by rewriting the symbolic forms to literal
addresses in the shim bodies. Bytes are identical either way.
Future cleanup if it ever becomes a readability issue. Not on
the docket.

### Mod overlay system is not compatible with `decomp/`

User note: *"the entire modding overlay system is not compatible
at all with our decomp dir, this is why it's in decomp and not
src, and we didn't choose to build it as a mod itself. This is
totally okay to ignore the modding system, and the transplant
mod."*

Anyone trying to use `make MOD=transplant` style commands with the
`decomp/` tree will be confused. They're separate worlds. The
decomp build is its own pipeline, not a mod overlay.

## What's NOT in scope for this branch

Explicitly deferred (per user framing):

- **Lifting naked shims to ordinary C.** "Our goal here is to get
  the unity build working with C functions + asm bodies. (b) is
  actually not part of this effort at all." When/if that
  workstream starts, the 852 C function signatures are the
  per-function lifting unit.
- **Other 7 modules** (main, init, select, result2p, name, backup,
  ending). User confirmed eye-on-the-prize-just-race. The pattern
  is replicable but no plan to do it on this branch.
- **Disc-level byte-match.** The race.bin is byte-identical;
  feeding it through the existing `inject_disc.py` infrastructure
  alongside prod's other 7 modules is mechanical and outside the
  decomp tree.

## Quick orientation for next session

If you're picking this up cold:

1. Read this doc end to end.
2. Read [asm_shim_design.md](asm_shim_design.md) — the design that
   made the unity build possible. Stages 1-5 + Stage 4 naked emit
   are the load-bearing infrastructure.
3. `wsl bash saturn/tools/validate_build.sh` should pass 51/51.
4. `wsl make -C /mnt/d/Projects/DaytonaCCEReverse/decomp validate`
   should print `PASS race.bin byte-identical to retail`.
5. Browse `decomp/race/FUN_*.c` to see what 852 per-entry asm
   shims look like. Open `decomp/race/race.c` to see the unity
   master include list.

If both validates are green, the system is in its known-good state.
Anything that's red points to where to start digging.
