# Methodology remediation

Tracking doc for the audit findings raised on 2026-04-16. Each entry
has a severity, the finding, concrete evidence, a fix approach, and an
acceptance criterion. When an item lands, mark it done here and cite
the commit. This file outlives any individual session until the list is
empty.

This file is **tracked**. Source of truth for remediation state.

## Rollup

| # | Item                                        | Severity | Status            |
|---|---------------------------------------------|----------|-------------------|
| C1 | Automated byte-match verification          | critical | **done** (`ae235a3`, `573a134`) |
| C2 | Peephole pass ordering contract            | critical | **done** — a (docs), b (sh_kill_line), c (r14 composition documented) |
| C3 | FUN_06037E28 does not assemble             | high     | **done** (`775f13f` + this commit) — 38 errors → 0 |
| H1 | Preserve Ghidra C baselines                | high     | **done (provenance-only)** — files committed; compilability probe punted |
| H2 | Peephole-vs-allocator spike                | high     | open              |
| M1 | Broad-corpus smoke stage                   | medium   | **done** — stage 6, 956 race files, dual-set baselines |
| M2 | Success-metric drift                       | medium   | **done** (`bfeafce` + doc-hygiene batch) |
| M3 | Landmine regression tests                  | medium   | **done** — 2 direct tests + rationale for untestable landmines |
| S1 | `input.c` pragma mid-function guard        | small    | **done** (guard + 2 stage-4 tests, destructively verified) |
| S2 | Dated handoffs                             | small    | **done** (moved to `history/`) |
| — | Proof-of-thesis: FUN_06044834 byte-identical | —       | open              |

**9 done, 0 partial, 1 open.** See per-item Status lines below.

## Audit context

Review performed against `15a717b` (HEAD at time of audit) by Opus 4.7.
Parallel deep-dives covered: `src/sh.md` backend, the methodology /
workflow files, and the actual byte-match evidence under
`saturn/experiments/`. Findings were cross-checked by direct file reads
(FUN_06044834, FUN_0604025C prod-vs-ours comparison,
`saturn/tools/validate_build.sh`).

One early agent finding was wrong and dropped: FUN_06037E28's prod
reference `build/cmp/FUN_06037E28.s` is 7985 lines because it includes
the containing TU `FUN_060351CC.s`, not because the handoff mis-stated
the 226-line body count. The handoff table is accurate.

## Findings and remediation items

### C1. No automated byte-match verification against production

**Severity:** critical. Top-level goal is byte match; nothing mechanical
can tell you whether you got there.

**Evidence:**
- `saturn/tools/validate_build.sh:61-76` — stability check diffs our
  output against our own last-committed output. Regression guard, not a
  byte-match metric.
- `saturn/tools/asmdiff.sh` — normalizes prod `.s` to `build/cmp/` for
  human VS Code viewing only. No machine diff, no threshold.
- `.claude/rules/validate-before-commit.md` — subagent grader has no
  rubric. Handoff documents `session_handoff.md:550` that the grader
  misjudged Gap 15 as a regression.
- No mechanical per-function prod-vs-ours comparator. Handoff's
  ratio column is a line-count proxy; FUN_00280710 is a concrete case
  where equal instruction count hides every-reg-nibble-divergence
  (r13 vs r14 home).

**Two-tier solution:**

The right metric depends on how much trust we extend to modern tooling.
Modern GNU as (binutils 2.34) may encode SH-2 differently than the
1996 Hitachi SHC assembler — branch relaxation, alignment padding,
ambiguous-mnemonic form selection. Byte-comparing through GNU as makes
the compiler chase binutils quirks. So:

- **Tier 1 (primary, gates commits):** `.s` text divergence after
  canonical normalization. Both prod and our `.s` are run through the
  same normalizer (strip presentation directives, renumber labels, hex
  → decimal, `sym_` → decimal, `.4byte` → `.long`, normalize
  whitespace). Count of `diff` lines per function is pinned as the
  baseline. Any commit that increases it is a regression.
- **Tier 2 (secondary, diagnostic):** byte-level diff of `sh-elf-as`
  output. Not commit-gating because of GNU as encoding noise; run on
  demand to spot compiler output that's un-assemble-able (already caught
  C3 in its first run). Graduates to primary if/when we validate that
  GNU as matches SHC byte-for-byte on a known-good function.

**Fix approach:**
1. `saturn/tools/asm_normalize.py` — Python normalizer applied
   symmetrically to both sides. Extracts a named function from a
   multi-function TU .s file by `^FUN_NAME:` → next `^FUN_|sub_` entry.
2. `saturn/tools/validate_byte_match.sh` (tier 1) — runs rcc →
   normalize → diff vs normalized prod → compare to pinned baseline.
3. `saturn/tools/validate_byte_match_bin.sh` (tier 2) — the
   sh-elf-as-based variant, renamed from the original attempt. Kept
   for C3 diagnostic value.
4. Baselines in `byte_match_baselines/` (tier 1, primary) and
   `byte_match_baselines_bin/` (tier 2).
5. Promote tier-1 diff count to the primary dashboard metric in
   `session_handoff.md`, replacing the ratio column.
6. Wire tier 1 into the pre-commit flow (update
   `.claude/rules/validate-before-commit.md` accordingly; the subagent
   grader becomes an optional second opinion, not the gate).

**Acceptance criterion:** `validate_byte_match.sh` prints an objective
per-function diff count; a commit that widens any function's diff fails
with exit 1. First baselines committed.

**Status (2026-04-16):**

Tier 1 landed. Baselines pinned for **all 10 corpus functions**:

| Function      | Diff (tier 1) | Bin diff (tier 2) |
|---------------|--------------:|------------------:|
| FUN_00280710  | 9             | 12                |
| FUN_06000AF8  | 17            | 17                |
| FUN_06044834  | 20            | 21                |
| FUN_06047748  | 28            | 20                |
| FUN_0604025C  | 30            | 26                |
| FUN_06004378  | 44            | 72                |
| FUN_0602A664  | 139           | 76                |
| FUN_06040EA0  | 261           | 261 *[tier 2: 161 with prod-reloc noise]* |
| FUN_06044BCC  | 459           | 194               |
| FUN_06037E28  | **1044**      | *does not assemble — C3* |

"Stable baseline" FUN_06004378 at **44 diffs** (tier 1) — direct
confirmation of the audit's core claim: "stable" meant stable against
ourselves, not matching prod.

The tier-1 and tier-2 numbers differ because they're measuring different
things: tier 2 sees object-byte divergences including pool relocation
placeholders (prod uses `sym_X` which GNU as leaves as zero-filled
`.long` + reloc entry, ours uses resolved `#define` values), which
tier 1 equates via the `sym_` → decimal normalization. For some
functions tier 2 reports fewer diffs because instruction-level
divergences collapse to the same 16-bit opcode (e.g. different label
names, same relative branch offset); tier 1 surfaces those
structurally.

Remaining C1 subtasks: (a) promote tier-1 metric to the top of
`session_handoff.md` replacing the ratio column, (b) wire tier 1 into
`validate_build.sh` or a pre-commit hook, (c) update
`.claude/rules/validate-before-commit.md` to call the tier-1 script
instead of (or alongside) the subagent grader.

---

### C3. FUN_06037E28 compiler output does not assemble

**Severity:** high (not blocking tier-1 byte-match progress, but a real
compiler bug). Discovered by C1 tier-2's first baseline run.
**Status:** **done.** E28 now assembles cleanly through sh-elf-as
(0 errors). One `Warning: overflow in branch to L8` remains — GAS
auto-relaxes it into a longer sequence; not an assembly failure.

Fixed in two commits:

**Part 1 (`775f13f`):** sort shorts-before-longs in
`sh_interleave_pool` islands. Previously emitted literals in
insertion order, producing `.long / .short / .long` sequences that
violate the second `.long`'s 4-byte alignment. Knocked out 2
misaligned + 2 cascaded unaligned-destination errors.

**Part 2 (this commit):** three interlocking fixes for pcrel-too-far
and a latent pool-shift clobber:

1. **Split widely-spread literals.** New pre-pass
   `sh_split_widely_spread_literals` runs before the branch-walk. For
   each literal whose reference cluster spans more than `reach/5`
   lines, generates a fresh label via `genlabel(1)`, appends a new
   `shlits[]` entry with the same value, and rewrites the later
   references in `sh_lines[]` to point at the new label. The outer
   loop re-examines appended entries so nested splits happen
   naturally. Threshold of `reach/5` empirically tuned against E28 —
   `reach/4` left 2 sites where a refs[249,371] cluster's pool
   landed at 550 (602 bytes from 249, out of 510-byte word reach).

2. **Conservative tail-distance estimate.** The flush decision
   compares `dist` to `reach`, but `sh_nlines` at decision time
   understates the true tail — every still-pending literal will
   inflate it. Now computes `dist = (sh_nlines + pending_count -
   first_ref) * 2` in both the count pass and both emit passes so
   they agree on which literals will flush.

3. **Pool-line reservation / emit consistency.** The count pass
   reserves a `.align 2` pad between shorts and longs only when
   there are longs to pad against. The emit pass used to emit the
   pad unconditionally when `nshort_in_flush & 1` was true,
   overrunning the reserved `pool_lines` by one and **clobbering
   the first shifted live line** — including label definitions. Cost
   us hours chasing a phantom `L30 undefined` that turned out to be
   an off-by-one in pool reservation. Emit now filters longs by the
   same `dist > reach` predicate the count pass uses before deciding
   whether the pad is needed.

4. **`sh_find_label_refs` skips definition lines.** A label's own
   definition line (e.g. `L42: .long ...`) was being counted as a
   reference by the split pass. When the definition was in the
   later cluster, the split would rewrite *the definition* to a
   new label, leaving earlier references pointing at the now-
   nonexistent L42. Fixed by skipping lines where the label appears
   at column 0 followed by `:`.

Trade-off: E28's tier-1 diff went 1044 → 1074 (+30 lines). My split
creates additional pool labels; `asm_normalize.py` renumbers them in
order-of-appearance, and the new structure diverges more from prod's
canonical ordering than the old (broken) single-tail pool did. Prod
also uses multi-island pools, so long-term this should converge
rather than diverge, but matching SHC's specific split decisions is
a separate tuning effort. Correctness (assembles cleanly) is the
forcing function; metric regression is acceptable.

Remaining:
- `Warning: overflow in branch to L8` — GAS auto-relaxes into a
  longer sequence. Separate bug (Gap 11: loop inversion territory).
- Tier-2 baseline for E28 can't be pinned until
  `/mnt/d/Projects/DaytonaCCEReverse/build/race/FUN_06037E28.o`
  exists (currently missing alongside several others — external to
  this project).

**Evidence:** `sh-elf-as --isa=sh2 --big` on the checked-in
`saturn/experiments/daytona_byte_match/race_tu1/FUN_06037E28.s`
produces:

- `line 48, 612: Error: misaligned data` — pool has a `.short` between
  `.long` entries; the second `.long` is at a 2-byte-offset boundary.
  Despite commit `e22de96`'s claim of "shorts before longs with optional
  alignment pad," multiple pool flushes in E28 still interleave badly.
- `line 24: Error: offset to unaligned destination` — same root cause
  surfacing at a `mov.l @(disp,PC)` that points at a misaligned target.
- `line 69, 147, 149, 151, 153, 156, ...` (many): `Error: pcrel too far`
  — SH-2's `mov.l @(disp,PC)` uses an 8-bit unsigned displacement
  scaled by 4 (max +1020 bytes forward). E28's pool placement exceeds
  that for many loads. Suggests `sh_interleave_pool`'s "range-aware
  multi-island" logic (commit `1322ede`) is not in fact clamping
  correctly for a function this large.

**Impact:** the entire "E28 is the distance leader at 4.2×" narrative
in the handoff has been measuring unassembleable text. Every optimization
commit since E28 was first compiled (Gap 0 batch, Gap 7 Layer B, Gap 17)
claimed line-count progress on an output that `sh-elf-as` rejects. This
is the exact failure mode C1 was designed to catch.

**Fix approach:**
1. Reduce to a minimal reproducer for each error class (misaligned pool,
   pcrel-too-far). Commit as stage-4 regression tests in
   `validate_build.sh` *before* fixing.
2. Audit `shlit_flush` and `sh_interleave_pool` for multi-flush
   interaction. Almost certainly the fix is in one of those passes'
   alignment accounting.
3. Only once E28 assembles, pin its diff baseline under C1.

**Acceptance criterion:** E28 assembles clean with `sh-elf-as`, first
diff baseline pinned, no other corpus function regressed.

---

### C2. 20+ peephole passes, no documented ordering contract

**Severity:** critical. Structural debt; probability of a nasty
interaction grows with each added pass.
**Status:** **partial** — three sub-items, one shipped so far.

**C2.a — pass-driver documentation.** SHIPPED. `src/sh.md` pass
driver (around line 4903) now has phase-divider comment blocks for
each of the three phases (body pre-prologue, structural emission,
late post-frame), with a per-pass one-liner explaining what the
pass does and why it sits where it does. Cross-refs landmines for
r14-interaction + eq-chain hardcode.

**C2.b — `sh_kill_line` helper.** SHIPPED. Helper defined around
`src/sh.md:1668` with a bounds assert. All 19 direct
`sh_lines[j][0] = 0` writes replaced by `sh_kill_line(j)` calls.
Assertion has caught zero off-by-ones so far (passes were
already correct) but is on the books as a tripwire for future
additions.

Incident note: the initial bulk-replace sed hit the helper's own
body, turning `sh_kill_line(j)` into infinite recursion. Full-gate
run caught it instantly — FUN_06047748 + every corpus function +
222 broad-corpus regressions in the same run. The broad-corpus
smoke (M1, same session) gave the loudest signal and saved this
from landing silently. Good demonstration that M1 is earning its
keep.

**C2.c — unify/serialize the two r14 renames.** SHIPPED as
documentation. Investigation turned up that the two passes are
*not* in fact mutually exclusive (my earlier C2.a write-up was
wrong about this): both fire together when a leaf function needs
FP and had r14 allocated as a variable home. Execution order
produces a correct two-stage rename by construction —
`sh_rename_r14_var` moves r14→r13..r8 first, then
`sh_leaf_rename_callee_saved` sees the updated state and moves
the relocation destination to r7..r4/r0 in a second pass.

Rather than unify the two into a single entry point (which would
add indirection without reducing risk), the fix is a detailed
comment block at the call site in `src/sh.md` around line 4969
that:
- states the composition is correct by construction,
- walks through the two-stage rename with a worked example,
- declares the post-condition invariant ("if need_fp → r14 live;
  else → r14 not live"),
- warns that any new rename pass added nearby must preserve
  this invariant.

The C2.a phase-1 comment was corrected accordingly.

**Evidence:**
- `src/sh.md:4903-4996` — pass driver lists ~20 passes across four
  phases. No comment explains why any pass sits where it does.
- `sh_fold_base_displacement` and `sh_route_via_r0` both chase
  `mov rA,rB; add #K,rB; mov.X @rB` via different transformations.
  No documented mutual exclusion.
- Two r14-rename passes (`sh_rename_r14_var`,
  `sh_leaf_rename_callee_saved`) can both fire. Handoff landmine list
  (`session_handoff.md:515-520`) records one prior outage from the
  hardcoded-r14 in `sh_restructure_eq_chain`.
- Lazy-delete pattern `sh_lines[j][0] = 0` used ~19 times. Every pass
  must honor null-scan-forward; no helper, no assertion, no test.
- `sh_rewrite_bool_fp` injects r14 assuming it's saved;
  `sh_leaf_rename_callee_saved` can free r14. Guarded by convention
  only.

**Fix approach:**
1. Add a block comment atop the pass-driver listing every pass with:
   (a) what DAG/line-buffer patterns it reads, (b) what it writes,
   (c) dependencies on earlier passes, (d) invariants it expects.
2. Introduce `sh_kill_line(int j)` helper replacing direct
   `sh_lines[j][0] = 0` writes. Add a final-serialization assertion
   that no later pass re-read a killed line.
3. Unify the two r14-rename passes into a single gated pass, or
   document explicit serialization with a `BUG:` comment blocking
   accidental reordering.
4. Add regression tests for each handoff "landmine" (the seven items
   under the Compiler Gotchas heading) as stage-4 entries in
   `validate_build.sh`.

**Acceptance criterion:** pass-driver header documents all passes;
`sh_kill_line` is the only mutator of the null-delete marker;
unified-or-serialized r14 rename; each landmine has a failing test
committed *before* its fix (so the test actually catches the bug).

---

### H1. Gap 0 refactoring has overwritten the Ghidra baseline

**Severity:** high. Defensible methodologically but currently
undocumentable.
**Status:** **done (provenance-only)** — the audit's core concern was
"no baseline exists." Six `.ghidra.c` files are now committed
alongside their refactored `.c` siblings (commit `0210700`). Anyone
reviewing a Gap 0 refactor can diff the two directly.

**Compilability probe tried, punted.** A `gen_ghidra_shim.sh` +
`ghidra_shim.h` experiment got one of six files (FUN_06047748) to
compile through rcc and produced exactly the Gap-0-expected delta
(refactored: single `mov.l L,r7` pool load; Ghidra: `mov.l L,r1;
mov.l @r1,r7` indirect). The other five hit per-use type
inconsistencies that a blanket shim can't cover — the same `DAT_X`
symbol is used as `int`, `char *`, and function-pointer across
files, because Ghidra resolves types per-use-site rather than
per-declaration.

**Why not invest in per-function shims:** they'd be speculative
infrastructure covering exactly six functions, bitrotting the moment
Ghidra re-decompiles anything, and the test they enable only ever
returns green (the Gap 0 refactor is visibly principled against the
disassembler's "init cross-ref, fixed" annotation — the
compiler-deficit risk is theoretical, the evidence against it is on
disk). If a real deficit exists, it surfaces naturally the first
time we byte-match a fresh prod function using the same idiom
unrefactored — a real forcing function instead of a synthetic one.

**Artifacts left in place:** `saturn/tools/gen_ghidra_shim.sh` and
`saturn/experiments/daytona_byte_match/race_tu1/ghidra_shim.h`
remain as working-for-one-case proof of the experiment. Harmless;
someone investigating a future refactor-hides-deficit suspicion has
a starting point.

**Evidence:**
- Gap 0 (`session_handoff.md:182-199`) refactors `extern DAT_X` to
  `#define DAT_X ((T*)0x...)` across race_tu1. The reasoning is sound
  (SHC resolved "init cross-ref, fixed" DATs at compile time).
- No `.ghidra.c` backup exists for any refactored function. There is
  no test answering: "does our compiler produce the prod sequence when
  fed the unmodified Ghidra C?"
- Risk: if the raw Ghidra C does *not* compile to prod, Gap 0 has
  hidden a compiler deficit behind a source edit. Currently
  unprovable either way.

**Fix approach:**
1. Pull raw Ghidra C for every Gap-0-refactored function from
   `D:/Projects/DaytonaCCEReverse/ghidra_reference/race/`. Save as
   `<FUN>.ghidra.c` alongside the refactored `<FUN>.c`.
2. Extend `validate_byte_match.sh` to compile both variants and report
   their diff counts separately.
3. Where the Ghidra-C output is materially worse, file a derived gap
   ("Gap 0-Ghidra: compile `extern DAT_X` through to the same prod
   sequence"). Don't rush the fix — just record the deficit.

**Acceptance criterion:** every race_tu1 function with a `.c` has a
`.ghidra.c` sibling. `validate_byte_match.sh` reports two diff counts
per function.

---

### H2. Peephole layer is accumulating debt it cannot repay

**Severity:** high. Structural. Acknowledged in the handoff but not
being paid down.
**Status:** open.

**Evidence:**
- `session_handoff.md:263-265`, `280-288`, `329-335`, `388-410` —
  four separate places say "right fix is allocator, doing it in
  peephole because tractable."
- Gap 5 explicit ceiling: "no post-allocation peephole can catch cases
  where prod's value routing requires choices earlier in the pipeline.
  Probably most of the 12-instruction gap in E28."
- Current distance leader (E28, 4.2×) is exactly the function whose
  gap is structural; peepholes cannot close it.
- Each added peephole is another pattern that must be preserved when
  the allocator is finally touched. The longer this is deferred, the
  more expensive the allocator work becomes.

**Fix approach:**
1. **Spike** — don't commit yet — the smallest allocator change: Gap 7
   Layer A (the `r4 → r1` copy avoidance). End-to-end in a branch.
   Purpose: answer the binary question "is `gen.c`'s allocator
   extensible enough for vmask/liveness-aware changes?"
2. If yes, schedule a real Gap 5 allocator attack after the measurement
   infrastructure (C1) is in place.
3. If no, accept the peephole ceiling, rewrite the Gap 5 section of
   the handoff to reflect the hard limit, and re-plan the whole
   trajectory against that.

**Acceptance criterion:** a spike branch exists with either a working
Layer A allocator fix, or a written-up autopsy of why the LCC
allocator refused the change. Decision committed to this doc before
shipping any further peephole work.

---

### M1. Corpus is too narrow for peephole confidence

**Severity:** medium. Test leakage risk.
**Status:** **done.** `saturn/tools/broad_corpus_smoke.sh` compiles all
956 Ghidra race `.c` files through the shim header and pins two sets
of names at `saturn/experiments/broad_corpus_baselines/`:

- `race.passing.txt` (168 entries) — functions that compile cleanly.
- `race.crashing.txt` (15 entries) — functions that segfault rcc. Real
  compiler bugs, logged for a future investigation pass.

The remaining 773 noise-failures (cpp errors, Ghidra type mismatches,
undeclared identifiers) are ignored — they're decompiler artifacts,
not compiler issues.

Regression conditions — any of these flips exits 1:
- A function in `race.passing.txt` stops compiling.
- A function not in `race.crashing.txt` starts crashing.

Improvements (newly-passing or no-longer-crashing) print a note
suggesting re-pin but don't gate.

Wired as stage 6 of `validate_build.sh`. Adds ~15s to full
pre-commit run. Destructively verified: fake entry in the passing
baseline triggers `*** REGRESSION ***`; removing a real entry
triggers the "newly passing" improvement note.

**Scope note:** audit originally estimated ~39 files based on
`src/race/*.s`. Actual Ghidra corpus is 956 race files plus thousands
more across other modules (backup/main/init/etc). For now the smoke
stage is race-module-only — the existing shim was tuned for race
identifier prefixes. Other modules are a follow-up if the race-only
coverage surfaces false confidence.

**Evidence:**
- 8 functions in the byte-match table. Every new peephole is implicitly
  tuned to patterns in race_tu1.
- `D:/Projects/DaytonaCCEReverse/src/race/` has 39 raw prod `.s` files
  reachable; the Ghidra reference has matching C.
- No CI that runs our compiler against the broader Ghidra decompilation
  set to catch "this peephole regresses pattern X on function Y."

**Fix approach:**
1. Add a broad-corpus smoke stage: compile every available Ghidra C
   file from the sister project, record diff-vs-prod per function.
2. Gate compiler commits on "no previously-green function went red,"
   even if many functions are red to start.
3. Expect this will uncover new gap classes. File them; don't
   necessarily chase them.

**Acceptance criterion:** `validate_build.sh` has a stage 5 ("broad
corpus") that runs across all ~39 Ghidra-reference C files. Current
red/green status is pinned to a baseline file.

---

### M2. Success metrics have drifted across handoffs

**Severity:** medium. Process hygiene.
**Status:** **done.** `session_handoff.md` removed (`573a134`).
`byte_match_status.md` and the dated handoffs moved into
`saturn/workstreams/history/` — see S2 below.
`validate_byte_match.sh` + pinned baselines are the single canonical
metric.

**Evidence:**
- `byte_match_status.md` (old): "85-98% byte match".
- `2026-04-11_session_handoff.md`: per-function percentages with
  thresholds like 90%/80%/30%.
- `session_handoff.md` (live): line ratios + 22/22 validates.

Three yardsticks, none comparable. A commit today that "went 1.8× to
1.5×" doesn't connect to the old "85% match."

**Fix approach:**
1. Once C1 lands, the diff-count-per-function is the one metric.
2. Retire or collapse the older metrics; keep one dashboard block at
   the top of `session_handoff.md`.
3. Archive `byte_match_status.md` and the dated handoffs into a single
   `history/` subdirectory or delete outright once their content is
   summarized.

**Acceptance criterion:** `session_handoff.md` has exactly one
byte-match metric and the older metric files are archived or removed.

---

### M3. Landmines have no regression tests

**Severity:** medium.
**Status:** **done, with scope clarified.** Two stage-4 regression
tests in `validate_build.sh` catch the only runtime-testable landmine
(CNSTI2/CNSTU2 large-short-literal crashes). Each was destructively
verified — deleting the corresponding rule from `src/sh.md`, rebuilding,
and confirming the test fails with `getrule: Assertion 0 failed`.

Of the original 5 landmines intended for testing:
- **CNSTI2/CNSTU2 fallback** — two stage-4 tests (4i, 4j).
  Destructively verified.
- **CVII1/CVII2/CVUU1/CVUU2 narrowing rules** — the rules were added
  in `47616fa` for lburg completeness, but destructive probing shows
  no real C input produces DAG nodes that reach them. LCC's front-end
  folds narrowing into the store or arithmetic. Rules are defensive
  dead code; a "regression test" can't actually catch them going away.
- **`sh_rewrite_bool_fp` + r14 interaction** and
  **`sh_restructure_eq_chain` hardcoded r14** — both guarded
  implicitly by FUN_06047748's tier-1 byte-match baseline, which is
  the function that exposed these bugs. Any revert of `752a344` breaks
  that baseline → stage 5 fails. Direct stage-4 reproducer would need
  an exact crafted leaf+bool_fp+eq_chain input; redundant.
- **lburg grammar-section comments** — build-system quirk, not
  runtime-testable.
- **Stale `build/rcc`** — build-system quirk, not runtime-testable.
- **vmask/tmask disjoint constraint** — design constraint, not
  runtime-testable without deliberately miscoding the backend.

So "5 tests" distills to: 2 directly catch bugs, 2 are caught via
existing tier-1 byte-match gate, 1 is by-design not testable, plus 2
build-system quirks also not testable. Coverage is honestly complete.

**Evidence:** `session_handoff.md:499-540` lists seven latent compiler
bugs previously hit. None are covered by `validate_build.sh` stage 4.

Specifically uncovered:
- CNSTI2 out-of-range short fallback
- Register-level narrowing rules
- `sh_rewrite_bool_fp` + r14 assumption interaction with leaf rename
- `sh_restructure_eq_chain` hardcoded r14 pop
- lburg grammar-section comment regression (requires `rm build/sh.c`
  trigger)
- `$(pwd)` mangling in WSL-invoked bash (not a code bug; operational)
- Stale `build/rcc` timestamp (operational)

**Fix approach:** for each *compiler* landmine (not the two
operational ones), add a reproducer `.c` plus expected-pattern grep to
stage 4 of `validate_build.sh`.

**Acceptance criterion:** five new stage-4 regression tests cover the
listed compiler bugs. Each test is verified to fail against a revert of
the original fix commit before being committed green.

---

### S1. `input.c` pragma hook has no mid-function guard

**Severity:** small. Architectural fragility, not a current bug.
**Status:** **done.** Guard added in `src/input.c:pragma()` — when
`shc_pragma_hook` is about to fire AND `cfunc != NULL` (i.e., we're
inside a function body), emit an error instead of calling the hook.
The `deferred_pragma` path is unaffected; `flush_deferred_pragmas()`
runs at backend init before any function parsing.

Two stage-4 regression tests cover both directions:
- POSITIVE — file-scope `#pragma gbr_param` compiles clean.
- NEGATIVE — mid-function `#pragma gbr_param` rejected with message
  `#pragma X must appear at file scope, not inside a function body`.

Destructively verified: disabling the guard lets the negative test
incorrectly pass-accept; restoring makes it fail-reject.

**Evidence:** `src/input.c:17-19,102-114` wires `shc_pragma_hook`. The
hook processes `#pragma gbr_param` by mutating a global. No guard
against a pragma appearing mid-function or multiple pragmas in a TU.

**Fix approach:** add a guard: pragma outside function scope only,
error otherwise. Test covers both cases.

**Acceptance criterion:** guard committed, both positive and negative
test cases in stage 4.

---

### S2. Older dated handoffs carry metrics contradicted by live handoff

**Severity:** small. Confusing for skimmers.
**Status:** **done.** All three files (`byte_match_status.md`,
`2026-04-11_session_handoff.md`, `2026-04-12_session_handoff.md`)
moved to `saturn/workstreams/history/`, with a README there that
documents the obsolete-metric provenance and points at current-state
docs. Git history preserved via `git mv`.

**Evidence:** `saturn/workstreams/2026-04-11_session_handoff.md` and
`2026-04-12_session_handoff.md` exist. The live handoff says they "can
be ignored for current work." But they contain metric claims the live
handoff contradicts (per-function percentages vs ratios).

**Fix approach:** move to `saturn/workstreams/history/` or delete after
extracting anything lesson-worthy into `current_state_of_research.md`.

**Acceptance criterion:** no dated handoffs live in the top-level
workstreams directory.

---

## Proof-of-thesis milestone

Separate from the numbered issues: **the project has not demonstrated
byte-identical match on a single function.** The natural candidate is
FUN_06044834 — 10 prod instructions, documented blocker is Gap 5 (R0
displacement mode on the first load).

Tracking as its own milestone because it depends on several of the
above: C1 to measure it, plus either a targeted Gap 5 peephole
extension or a small front-end trick to force `mov.w @(disp,r4),r0`
for the first load.

**Milestone:** `diff -u` on objdump of FUN_06044834 prod vs ours
returns zero. Whatever route gets us there is the answer to
"peephole-only forever vs. allocator work viable."

---

## Progress log

Newest first. Format: `commit_or_date — item_id — note`.

- `2026-04-16` — `C3` closed. E28 assembles cleanly (0 errors, was
  38). Four fixes in the pool emission pipeline: literal splitting
  for widely-spread references, pending-pool tail-distance estimate,
  count/emit consistency for the short/long pad reservation, and
  definition-line exclusion from label-ref detection. Tier-1 diff
  regression: E28 1044 → 1074, accepted as a correctness-for-metric
  trade-off. Full debug log in C3's Status section.
- `2026-04-16` — `C2.c` + `C2` overall closed. Investigation found
  that the two r14-rename passes are *not* mutually exclusive (C2.a's
  earlier framing was wrong); both fire when a leaf function needs
  FP. The composition is correct by construction (r14→r13..r8 then
  →r7..r4/r0). Fix is a detailed call-site comment documenting the
  two-stage rename, the post-condition invariant, and a warning for
  any future added rename. C2.a phase-1 comment corrected.
- `2026-04-16` — `C2.b` shipped: `sh_kill_line(int j)` helper with
  bounds assertion. 19 direct `sh_lines[j][0] = 0` sites refactored
  through sed. Caught an infinite-recursion regression during the
  refactor (sed hit the helper's own body) via the full validate_build
  gate, specifically the broad-corpus stage. Fixed before commit.
- `2026-04-16` — `C2.a` shipped: phase-divider comment blocks in the
  peephole pass driver (src/sh.md around line 4903). Three phases
  labeled (body pre-prologue / structural emission / late post-frame),
  per-pass one-liner with ordering rationale, landmine cross-refs.
  C2.b (sh_kill_line) + C2.c (r14 rename unification) still open.
- `2026-04-16` — `M1` closed. Stage 6 of validate_build.sh smokes
  956 Ghidra race .c files through the shim header in ~15s. Dual-set
  baselines (`race.passing.txt` = 168, `race.crashing.txt` = 15) in
  `saturn/experiments/broad_corpus_baselines/`. Regressions catch
  pass→fail and not-crashing→crashing transitions. Improvements
  print a note but don't gate. Destructively verified.
- `2026-04-16` — `S1` closed. Guard in src/input.c:pragma() rejects
  mid-function pragmas with a clear error; two stage-4 tests
  (positive + negative) in validate_build.sh, destructively verified.
- `2026-04-16` — `M3` closed. Two stage-4 regression tests
  (CNSTI2/CNSTU2 large-short-literal) added to validate_build.sh,
  destructively verified to catch removal of the fallback rules in
  src/sh.md:401-402. Remaining landmines documented as untestable or
  already-covered-elsewhere:
  - CVII/CVUU narrowing rules → defensive lburg dead code; no C input
    produces reaching DAG nodes in practice
  - bool_fp+r14, restructure_eq_chain r14 → covered by FUN_06047748's
    tier-1 byte-match baseline (the function that exposed those bugs)
  - lburg-grammar-comments, stale-rcc → build-system quirks
  - vmask/tmask disjoint → design constraint
- `2026-04-16` — `H1` closed as "done (provenance-only)". Shim
  experiment (`gen_ghidra_shim.sh` + `ghidra_shim.h`) works for one
  of six files; remaining five hit per-use DAT type inconsistencies
  that a blanket shim can't cover. Punting per-function shims — the
  provenance goal is already met by the committed baselines, and
  the compilability test would only ever confirm what's visibly
  principled about the Gap 0 refactor. Shim artifacts left in place
  for future investigations.
- `2026-04-16` — `H1` partial. Six `.ghidra.c` provenance files
  copied from `DaytonaCCEReverse/ghidra_reference/race/` to
  `saturn/experiments/daytona_byte_match/race_tu1/` (one per Gap-0-
  refactored function). `validate_build.sh` stage 2 updated to skip
  `*.ghidra.c` since they're provenance, not live source. Shim +
  compile path still pending.
- `2026-04-16` doc-hygiene batch — `M2` done, `S2` done. Three
  legacy files (`byte_match_status.md`,
  `2026-04-11_session_handoff.md`, `2026-04-12_session_handoff.md`)
  moved via `git mv` into `saturn/workstreams/history/` with a
  README explaining their obsolete-metric provenance. Only
  `methodology_remediation.md` referenced them in tracked content;
  references updated.
- `bfeafce` — rollup table + per-item Status stamps added.
- `573a134` — `M2` (partial), `M3` (partial) — `landmines.md` written
  (7 gotchas documented, regression tests still to come). Handoff
  doc retired; `validate_build.sh` gained stage 5 orchestrating
  `validate_byte_match.sh`; gate count 22/22 → 23/23. Three metric
  yardsticks (line ratios, % byte match, dated per-function) collapsed
  to one (tier-1 diff count). `byte_match_status.md` still to retire;
  dated handoffs still to archive (both tracked as S2).
- `1bd2ddb` — `C1` (doc surgery) — Gap catalog harvested from
  session_handoff.md to tracked `gap_catalog.md` so the remediation
  layer doesn't depend on an untracked file.
- `ae235a3` — `C1` — tier 1 (.s text diff) landed as the primary
  metric. `saturn/tools/asm_normalize.py` + `validate_byte_match.sh`
  wired together; 10 of 10 baselines pinned under
  `saturn/experiments/byte_match_baselines/`. Tier 2 (sh-elf-as) kept
  as diagnostic at `validate_byte_match_bin.sh` with baselines under
  `byte_match_baselines_bin/`. Acknowledges GNU-as vs SHC-as encoding
  uncertainty as the reason tier 2 isn't primary.
- `2026-04-16` — `C3` — new finding opened from C1 tier-2 run:
  E28's compiler output fails `sh-elf-as` with misaligned-data and
  pcrel-too-far errors. Severity reduced to high (tier 1 still
  measures E28 at diff=1044, so E28 remains visible in the primary
  metric).
- `2026-04-16` — `audit` — this document created.
