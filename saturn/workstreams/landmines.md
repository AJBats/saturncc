# Compiler landmines

Latent issues in the SH-2 backend / lburg / build pipeline that
sessions keep tripping on. Distinct from `gap_catalog.md` (which
tracks intentional divergences from prod): these are bugs we've
already paid for once and don't want to pay for again.

Each entry has: a one-line headline, what triggers it, what fixed
it (or how to avoid it), and the relevant commit / file pointers.
When a regression test exists for an entry, link it; when one
doesn't, that's a TODO worth filing.

Several of these entries are tracked under
[methodology_remediation.md](methodology_remediation.md) item M3
("Landmines have no regression tests") for conversion into
stage-4 entries of `validate_build.sh`. Until that lands, the
defence is just "read this doc."

---

## Compiler / lburg

### `vmask` and `tmask` must be disjoint

**Trigger:** widening `vmask[IREG]` (callee-saved set) to include
bits from `tmask[IREG]` (caller-saved/scratch set).

**Result:** `spillee` assertion fires; CSE tracking corrupts.

**Why:** LCC's allocator assumes the variable-register set and
the temporary-register set don't overlap. Putting the same
register in both breaks the spill model.

**Workaround:** rejected experimentally — we use post-allocation
peephole rename (`sh_leaf_rename_callee_saved`, see
[gap_catalog.md](gap_catalog.md) Gap 1A) instead.

---

### `sh_rewrite_bool_fp` injects r14 assuming r14 is saved

**Trigger:** running `sh_rewrite_bool_fp` after a pass that has
freed r14 from the prologue save list.

**Result:** generated code references r14 without first storing
the caller's r14 — corruption on return.

**Fix shipped:** guard added in `752a344` that bails the rewrite
if r14 isn't in `usedmask`. Don't re-open this guard without
thinking about both passes together.

**See also:** the next entry — same incident chain.

---

### `sh_restructure_eq_chain` hardcoded r14 as the pop register

**Trigger:** any leaf function where `sh_leaf_rename_callee_saved`
freed r14 — `sh_restructure_eq_chain`'s pop string still said
`r14` because nobody noticed the always-wrong string until r14
stopped always being live.

**Fix shipped:** `752a344` — string now derived from the actual
allocated register. Don't reintroduce the hardcode.

---

### lburg rules for short-typed DAG nodes are sparser than for int

**Trigger (historical):** any short literal outside −128..127, or
any int→short narrowing expressible as a DAG node.

**Result (historical):** `getrule` assertion crashed rcc.

**Fix shipped:** `47616fa` — added `CNSTI2`/`CNSTU2` large-const
fallback rules and `CVII1/CVII2/CVUU1/CVUU2` register-level
narrowing rules.

**Caveat:** even after the fix, short rules remain sparser than
int. Don't assume feature parity when adding new short-typed code
paths.

---

### lburg grammar-section comments don't re-parse unless `sh.c` is regenerated

**Trigger:** add `/* ... */` comments to the lburg grammar section
of `src/sh.md`, then rebuild without removing `build/sh.c`.

**Result:** comments stay in `src/sh.md` but are not seen because
make caches `build/sh.c`. Latent breakage if the comments would
have triggered a parse error, or silent loss of intent.

**History:** `47616fa` added comments; `e22de96` made `lburg/gram.y`
actually accept them. Between those two commits, the grammar
comments were latent-broken.

**Workaround:** force regeneration with
`rm build/sh.c build/sh.o build/rcc` when modifying the grammar
section.

---

### `build/rcc` can be stale

**Trigger:** edit `src/sh.md` (or another input to lburg → sh.c)
and re-run the build script.

**Result:** make doesn't always see `src/sh.md` as newer than
`build/sh.o`, so a rule change can have no effect on the next
build.

**Diagnosis:** check `ls -la build/rcc` timestamps after building.

**Workaround:** force rebuild with `rm build/sh.o build/rcc`.

---

## Build / harness

### `$(pwd)` mangling under WSL-invoked Bash

**Trigger:** running a bash command through `wsl.exe` that uses
`$(pwd)` or backtick `` `pwd` `` inside a quoted argument.

**Result:** the substitution mangles to a Windows-style path mid
command line, breaking downstream tools that expect POSIX paths.

**Workaround:** use absolute paths derived from
`readlink -f "$0"`. `saturn/tools/build.sh` does this; copy the
pattern when adding new bash entry points.

---

### Experiment `.c` files require `cpp -P` preprocessing

**Trigger:** running `rcc` directly on a `.c` under
`saturn/experiments/daytona_byte_match/` without preprocessing.

**Result:** "undeclared identifier" on Gap 0's `#define DAT_XXX`
macros — `rcc` doesn't run cpp.

**Workaround:** `validate_build.sh` and `validate_byte_match.sh`
both pre-cpp before feeding to rcc. When debugging a single
candidate manually, mirror the pipeline:

```bash
cpp -P foo.c /tmp/pp.c && build/rcc -target=sh/hitachi /tmp/pp.c out.s
```
