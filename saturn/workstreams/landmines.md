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

### `sh_interleave_pool` pool_lines reservation must match emit output exactly

**Trigger:** change pool-island emission logic (add a new directive,
move around shorts vs longs, change pad conditions) without updating
the `pool_lines = 1 + flush_count + ...` reservation with the exact
matching condition.

**Result:** emit writes more lines than the pre-shift reservation
allocated. The shift loop at line ~4826 copies live content from
`[insert_at..sh_nlines-1]` forward by `pool_lines`. If emit then
writes past `insert_at+pool_lines-1`, it clobbers the first shifted
line — which can be a LABEL DEFINITION. Downstream error:
`displacement to undefined symbol L<N> overflows 8-bit field` at
every reference to the clobbered label.

**History:** C3 part 2 hit this when the short-count was odd and
zero longs followed. Count pass reserved `1 + flush_count` lines (no
pad), emit pass wrote `1 + flush_count + 1` (always-emit pad when
shorts odd). L30's definition was in the first shifted slot and got
overwritten with `.align 2`. Cost hours to diagnose because the
visible error (undefined L30) had no obvious relation to the actual
cause (off-by-one in pool reservation).

**Workaround:** count pass and emit pass must use identical
predicates for every conditional line they emit. See the pad-emit
loop that walks `nshlit` with the same `last_ref` / `dist > reach`
filter the count pass used.

---

### Label-rewrite passes must skip the label's own definition line

**Trigger:** a pass scans `sh_lines[]` looking for all references to
a label `L<N>` (for renaming, analysis, etc.) and treats EVERY line
containing `L<N>` as a reference.

**Result:** the label's own definition line (`L<N>: .long ...` or
`L<N>:`) is counted as a reference. When the pass then rewrites
"refs" to a new label, the definition itself moves — the original
label becomes undefined, earlier (unrewritten) references dangle.

**History:** C3 part 2's `sh_find_label_refs` originally counted
any line containing `L<N>`. When `sh_split_widely_spread_literals`
split a pool literal, it rewrote refs `[j..nrefs-1]` to a new label.
If the definition line was in that range, the definition got
renamed and the original label disappeared. Manifested as phantom
undefined-symbol errors even though our code "only rewrote
references."

**Workaround:** any label-scanning pass should skip lines where the
label appears at column 0 followed by `:`. Current implementation in
`sh_find_label_refs` strips leading whitespace, checks for
`<label_str>:` at position 0, and skips those lines.

---

### Parameter registers (r4-r7) are now freed at their last DAG use

**Trigger:** any pass added to `src/sh.md` that assumes an argument
register (r4–r7) holds the incoming parameter value for the entire
function body — for example, an emit-time lookup that says "if it's
an arg, rN is definitely still the caller's value here."

**Result:** may read a stale value. Since `385eafb` (H2 spike), the
allocator frees r4–r7 at their last DAG-node use and reuses them
for temporaries. After that point, rN holds whatever the allocator
put there — not the original parameter.

**Why:** `src/gen.c`'s `ralloc` now calls `putreg(r)` at last-use
for `sclass == REGISTER` symbols (previously temporary-only). The
extended `x.lastuse` tracking in `setup()` lets this fire for
parameters. `tmask` was widened (`0x0e | 0xf0`) so `askreg` picks
r4–r7 once freed.

**Workaround:** don't hand-wave "arg = rN" — use `usedmask` or
walk the emitted body. If you need to reference an original
parameter value after some unspecified point, explicitly keep it
live (e.g., pin via `target()` or rely on the compiler to spill).

**Invariant to preserve:** until the allocator's lastuse point for
a parameter, that parameter's rN is the caller's value. After,
treat rN as "any live-in temporary."

---

### Bulk `sed` over `src/sh.md` will rewrite a helper's own body

**Trigger:** running a `sed` substitution to refactor a widespread
pattern (e.g., replacing `sh_lines[j][0] = 0` with `sh_kill_line(j)`)
over the entire file.

**Result:** the new helper function's OWN body contains the old
pattern (to actually do the work). sed rewrites it too, producing
infinite recursion or other silent breakage.

**History:** C2.b's bulk refactor turned
`static void sh_kill_line(int j) { ...; sh_lines[j][0] = 0; }`
into `static void sh_kill_line(int j) { ...; sh_kill_line(j); }`.
Full corpus crashed; caught instantly by validate_build's
broad-corpus stage (168 pass → 57 pass, 111 new crashes) before
commit.

**Workaround:** after any bulk sed refactor of `src/sh.md`, grep for
self-referencing patterns in the changed helpers. Alternatively,
write helper bodies with a DIFFERENT underlying primitive than the
pattern being replaced (e.g., a different array access style) so
the sed can't match them.

---

### `cfunc` must be cleared before `expect('}')` in function tail

**Trigger:** a file-scope `#pragma` (e.g. `sh_word_indexed_after_first`) placed
immediately after a function's closing `}`, with no intervening
top-level declaration.

**Result:** `input.c`'s pragma gate errors with `"#pragma X must
appear at file scope, not inside a function body"` — because
`expect('}')` in [decl.c](../../src/decl.c) calls `gettok()` to
advance past the `}`, and the lookahead scans the following
`#pragma` directive while `cfunc` is still non-null.

**History:** Surfaced on 2026-04-18 when sanitizing
`FUN_06044060` in the race_FUN_06044060 TU — FUN_06044834
(already pragma'd) sat directly after the new function with no
other declarations between. When FUN_06044834 was the first
unwrapped function, nothing preceded the pragma so the bug was
invisible.

**Fix shipped:** move `cfunc = NULL;` to *before* `expect('}');`
in [decl.c](../../src/decl.c) function-body tail. Don't reorder
these back — the `}` lookahead must see `cfunc` already cleared.
Regression guard: `regtest: #pragma between two function bodies
accepted` in `validate_build.sh` stage 4q.

---

### Pool auto-align silently corrupts self-anchored braf tables

**Trigger:** a `braf`/`bsrf` dispatch table named `.L_pool_*` whose
`.2byte` deltas are anchored to the table label itself (or are raw
numbers), linked at a section offset ≡ 2 mod 4.

**Result:** the pool-align pass emits `.balign 4` before the table;
GAS materializes a 2-byte pad between the delay slot and the table;
the table-anchored arithmetic re-evaluates to the same deltas — but
the hardware adds them to braf+4, which is now table−2. Every
dispatch lands 2 bytes short. **No diagnostic anywhere in the
pipe** — this shipped a crashing DaytonaCCEReverse build (illegal
instruction exception in FUN_06045B74) and was only caught by
byte-diffing the binary. The bitter part: without our `.balign`,
GAS hard-errors on the misaligned mova target — the pool-align
feature (9c7cc50) converted that loud failure into silent
corruption for this one idiom class. Alignment absorption is sound
for literal pools (GAS re-encodes label displacements); it is
unsound for any data consumed by braf/bsrf hardware arithmetic
that GAS doesn't manage.

**Fix shipped:** `sh_lint_braf_tables` (sh.md, runs after
`sh_compute_pool_alignment`) — hard compile error unless every
entry of a braf-consumed delta table is `TARGET - ANCHOR` with
ANCHOR a label at braf+4 (declared after the delay slot, before
any alignment point). Fires regardless of current parity: the
style is latent corruption even when today's bytes are right.

**Regression tests:** `validate_build.sh` 4y2 (a)–(d).

**See also:** `pool_alignment_design.md` §4.5;
`braf_dispatch_lint.md` for the full incident + corpus sweep.

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

### `wsl bash -c` from the harness mangles leading-slash args and inline `$?`

**Trigger:** (a) a `wsl bash -c '...'` command string that BEGINS
with a `/mnt/...` path — Git Bash's MSYS layer rewrites it to
`C:/Program Files/Git/mnt/...` before wsl sees it (exit 127,
"C:/Program: No such file or directory"); (b) checking an exit
code with `...; echo $?` inside the quoted string — some layer of
the chain pre-expands it and **every `$?` prints 0**, including
after `false`.

**Result:** during the braf-lint work this produced a convincing
but entirely false "rcc exits 0 on errors" diagnosis — nearly an
unnecessary main.c patch. Shell variables (`$f`, arrays) inside
the quoted string are equally unreliable.

**Workaround:** start the `-c` string with a non-slash token
(`exec /mnt/...`, `cd /mnt/... && ...`); never read exit codes via
inline `$?` — make the command of interest the LAST command and
let the harness report the real exit code, or put multi-step logic
in a script file on disk and run `wsl bash -c 'bash /mnt/.../script.sh'`.

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

**Second reason (2026-06-12):** multi-line `/* ... */` block
comments inside `asm { }` bodies. The asm parser is line-based —
only the line *starting with* `/*` is classified as a comment; the
continuation lines parse as garbage unknown-instructions. That
poisons analysis passes (a comment continuation right after a braf
delay slot false-failed the dispatch lint on FUN_06045B74) and
would emit comment text as code. cpp strips all comments before
rcc in every supported pipeline, so this only bites direct-rcc
invocations — sweep harnesses and one-off probes included. Always
cpp first.
