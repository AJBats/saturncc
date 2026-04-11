# LCC patches — SaturnCompiler Hitachi SH-2 backend

Our custom-compiler work lives as a set of patches against upstream `drh/lcc`. The upstream source is not vendored into this repo ([tools/lcc/](../lcc/) is gitignored) — it's cloned on demand by `tools/setup_lcc.sh`, which then applies these patches.

## Files

| File | Purpose |
|---|---|
| [`sh.md`](sh.md) | Phase 1B lburg grammar. Dropped into `tools/lcc/src/sh.md`. Defines terminals, ~50 tree-pattern rules for basic integer codegen, and a trailing C section with prologue/epilogue, register setup, and the `shIR` Interface struct. |
| [`sh.c`](sh.c) | Phase 1A stub backend (historical). No longer copied in by `setup_lcc.sh`; kept here as the original reference. Will be removed in a future cleanup. |
| [`bind.c.patch`](bind.c.patch) | Adds `xx(sh/hitachi, shIR)` to the target-binding table in `src/bind.c`. |
| [`makefile.patch`](makefile.patch) | Adds `sh.o` to `RCCOBJS`, an lburg rule `$Bsh.c: src/sh.md`, and wires the generated `$Bsh.c` into the build. |

## Applying

```bash
bash tools/setup_lcc.sh
```

That script clones drh/lcc, strips CRLF line endings from the Windows checkout, copies `sh.md` into `src/`, applies the two patches, and builds. Running it again is idempotent.

## Status

**Phase 1A — scaffold — complete.** The `sh/hitachi` target registers and runs.

**Phase 1B — real lburg backend — first output works.** From `int add(int a, int b) { return a + b; }`, rcc emits:

```
	.global _add
	.text
	.align 2
_add:
	mov	r4,r0
	add	r5,r0
L1:
	rts
	nop
```

That assembles cleanly with `sh-elf-as --isa=sh2 --big` and disassembles to real SH-2 machine code (`60 43 30 5c 00 0b 00 09`).

Covered so far:
- Integer arithmetic: ADD / SUB / AND / OR / XOR / NOT / NEG (2-operand mov-then-op pattern)
- Loads / stores: `mov.b` / `mov.w` / `mov.l` via register-indirect addressing
- Small constants via `mov #imm,Rn`
- Integer compares: `cmp/eq`, `cmp/gt`, `cmp/ge`, `cmp/hi`, `cmp/hs`
- Branches: `bt` / `bf` / `bra` / `bsr`
- Returns with result in R0
- Argument pinning: first four integer args in R4-R7 via `askregvar`
- Hitachi-style prologue/epilogue: descending callee-saved save order (R14 → R8), ascending restore, PR-save when `ncalls > 0`

Not yet implemented (Phase 1C+):
- Floating point, long long, structs
- Stack arguments beyond R4-R7
- Function-pointer and indirect calls
- `#pragma gbr_base` and GBR-relative addressing (the thing that makes Daytona CCE output distinctive)
- Literal pools for large constants and global-symbol addresses
- Delay-slot filling and peephole optimization

## Why patches instead of vendoring LCC

1. **License**: LCC's CPYRIGHT file requires attribution and has mild commercial restrictions. Vendoring the whole source tree would mean carrying those obligations in our repo forever. Patching keeps upstream clearly separated.
2. **Upstream tracking**: If drh/lcc pushes a bugfix, we can re-clone and re-apply. Vendoring would make that painful.
3. **Diff clarity**: Reviewers can see exactly what we changed without scrolling through 15,000 lines of upstream code.
4. **Size**: The patches are ~600 lines total (mostly sh.md). Vendoring LCC would add ~2 MB and thousands of files to the repo.
