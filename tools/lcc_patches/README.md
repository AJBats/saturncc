# LCC patches — SaturnCompiler Hitachi SH-2 backend

Our custom-compiler work lives as a set of patches against upstream `drh/lcc`. The upstream source is not vendored into this repo ([tools/lcc/](../lcc/) is gitignored) — it's cloned on demand by `tools/setup_lcc.sh`, which then applies these patches.

## Files

| File | Purpose |
|---|---|
| [`sh.c`](sh.c) | Phase 1A stub backend. Dropped into `tools/lcc/src/sh.c`. All Interface functions are no-ops; registers the `sh/hitachi` target so it appears in `rcc -h` and runs without crashing. |
| [`bind.c.patch`](bind.c.patch) | Adds `xx(sh/hitachi, shIR)` to the target-binding table in `src/bind.c`. |
| [`makefile.patch`](makefile.patch) | Adds `sh.o` to `RCCOBJS` and a build rule for `src/sh.c`. |

## Applying

```bash
bash tools/setup_lcc.sh
```

That script clones drh/lcc, strips CRLF line endings from the Windows checkout, copies `sh.c` into `src/`, applies the two patches, and builds. Running it again is idempotent (re-applies patches if they were reverted, skips re-clone).

## Status

**Phase 1A — scaffold — complete.** The `sh/hitachi` target:
- Appears in `rcc -h` output
- Runs without crashing on trivial C input
- Emits no code (intentional — all backend functions are stubs)

**Phase 1B — real backend** — not started. Will replace `sh.c` with `sh.md` (an lburg grammar) containing:
- Terminal declarations for all the DAG ops we need
- ~150-200 lburg rules for integer codegen
- Trailing C section with real function prologue/epilogue (descending register save order), progbeg/progend, segment switching, and eventually Hitachi pragmas and intrinsics

Phase 1B changes the file extension (`.c` → `.md`) and the Makefile rule (compile via lburg first), so the patch set will grow. We may split the patch into multiple sequential patches at that point.

## Why patches instead of vendoring LCC

1. **License**: LCC's CPYRIGHT file requires attribution and has mild commercial restrictions. Vendoring the whole source tree would mean carrying those obligations in our repo forever. Patching keeps upstream clearly separated.
2. **Upstream tracking**: If drh/lcc pushes a bugfix, we can re-clone and re-apply. Vendoring would make that painful.
3. **Diff clarity**: Reviewers can see exactly what we changed without scrolling through 15,000 lines of upstream code.
4. **Size**: The patches are ~100 lines total. Vendoring LCC would add ~2 MB and thousands of files to the repo.
