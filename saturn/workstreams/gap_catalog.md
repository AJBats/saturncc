# Gap catalog

Canonical reference for the gaps between our SH-2 backend's output and
Hitachi SHC 1996's. Each gap has a stable numeric id, a layer tag, a
status, a fix approach, and cross-references to related gaps.

This doc is the **tracked source of truth** for what's known to diverge
and how. For prioritisation of what to work on next, read `git log` and
the current `session_handoff.md` (intentionally untracked). For broader
methodology work orthogonal to the gaps (validation infrastructure,
test coverage, doc hygiene), see `methodology_remediation.md`.

## Layer taxonomy

Every gap is tagged with a **layer** indicating where the right fix
likely lives:

- **C source** — the decompiled `.c` is wrong or sub-optimal; fix the
  C, not the compiler.
- **front-end** — LCC's C parsing / DAG building in `dag.c`, `simp.c`,
  `stmt.c`.
- **allocator** — LCC's `gen.c` register allocation.
- **instruction-selector** — lburg rules in `src/sh.md`.
- **peephole** — post-allocation passes in the C section of
  `src/sh.md`.
- **lburg-infrastructure** — changes to the lburg tool itself.

A gap may span layers (e.g. "allocator or peephole" when both are
workable, with different trade-offs).

## Dependency graph

Solid arrows = "A must happen before B is tractable". Dashed = "A and B
are aspects of the same underlying problem".

```
  ┌─────────────────────────────────────────┐
  │ Gap 0: C-source decl fidelity      ✓   │  SHIPPED (47616fa,
  │                                        │  57d9d9b, 051e657)
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 1A: leaf callee-saved elision  ✓   │  SHIPPED (752a344)
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 17: addr-literal compaction    ✓   │  SHIPPED (e22de96)
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 7B: base→displacement fold     ✓   │  SHIPPED (15a717b)
  │ Gap 7A: param-reg reuse (partial)  ~   │  SHIPPED (385eafb);
  │                                        │  base-factoring CSE
  │                                        │  still open at
  │                                        │  peephole layer
  └──────────────────┬──────────────────────┘
                     │ shared root with Gap 4 (allocator
                     │ doesn't keep long-lived derived
                     │ values in regs)
  ┌──────────────────▼──────────────────────┐
  │ Gap 4: loop-invariant spill elimination │
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 1B: caller-save-around-call        │
  └──────────────────┬──────────────────────┘
                     │ depends on
                     ▼
  ┌─────────────────────────────────────────┐
  │ Gap 15: TU reconstruction + pragma     │
  │         for non-standard conventions   │
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 5: proactive R0 routing (indexed)   │
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 2: indexed-over-fitting-disp    ✓   │  RESOLVED via
  │        (no generalizable rule;          │  #pragma sh_weird_rule_1
  │         opt-in pragma)                  │  (b67fe7e)
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 11: loop inversion                  │
  └──────────────────┬──────────────────────┘
                     │   gates
                     ▼
  ┌─────────────────────────────────────────┐
  │ Gap 6: forward-moving cond delay fill   │
  └─────────────────────────────────────────┘

  ┌─────────────────────────────────────────┐
  │ Gap 12: compound rules need scratch     │
  └──────────────────┬──────────────────────┘
                     │   blocks compound-rule
                     │   approaches to many gaps
                     ▼
  ┌─────────────────────────────────────────┐
  │ Gap 13: lburg cost model isn't         │
  │         register-state aware            │
  └─────────────────────────────────────────┘
```

## Gaps

### Gap 0. C-source declaration fidelity &nbsp;&nbsp;**[layer: C source]**

**Status:** shipped — `47616fa`, `57d9d9b`, `051e657` (batched across
race_tu1).

Some byte-match divergences trace to the decompiled C, not the
compiler. Ghidra's default `extern` declarations for memory-mapped
DATs force runtime indirection (`mov.l pool_addr,rT; mov.l @rT,rN` —
2 loads). Prod's pool entries for the same DATs are marked "init
cross-ref, fixed" — SHC resolved them to compile-time literals
(`mov.l literal_pool,rN` — 1 load).

**Fix (shipped):** per-function C refactor — replace
`extern T *DAT_XXX;` with `#define DAT_XXX ((T *)0x...)` where `0x...`
comes from the prod pool comment. For int-typed DATs used as runtime
values (loop counters etc), keep as extern.

**See also:** methodology_remediation H1 — the original Ghidra C was
overwritten in the refactor; future work should preserve `.ghidra.c`
baselines alongside the refactored `.c` so a regression test can
prove the Gap 0 refactor isn't hiding a compiler deficit.

---

### Gap 1. Callee-saved register elision &nbsp;&nbsp;**[layer: allocator + peephole]**

Split into two phases.

#### Phase 1A — leaf single-callee-saved rename

**Status:** shipped — `752a344`.

For leaf functions with one callee-saved register in use, post-allocation
rename to a free caller-saved register. FUN_06047748 now matches prod
(uses r7, no prologue save).

#### Phase 1B — caller-save-around-call for non-leaf

**Status:** deferred. Blocked on Gap 15.

GCC has this mechanism (`-fcaller-saves`, cost model `4 * calls <
refs`). LCC doesn't — its allocator assumes disjoint `vmask`/`tmask`.
Emulating in the peephole layer is possible (similar to Phase 1A) but
matching prod requires knowing intra-TU calling conventions (which
callee-saved regs the callee actually preserves). That's Gap 15
territory.

**What's left unfixed even for leafs:** multi-callee-saved leaf
functions (e.g. FUN_06044BCC saves 7, prod 6). The extra save is
because prod uses r4–r7 for pool-value vars and our allocator can't
(`vmask = INTVAR` only). A post-allocation multi-rename was tried and
rejected — it diverges from prod's specific register choices when
prod keeps callee-saved. A future allocator-layer fix would address
this.

---

### Gap 2. SHC's indexed-for-fitting-displacement heuristic &nbsp;&nbsp;**[layer: C source / pragma]**

**Status:** resolved as "no generalizable rule exists; opt-in
pragma" (`b67fe7e`). Not the resolution originally expected.

**Empirical finding.** Surveyed all `mov #K,r0; mov.X @(r0,rN),rM`
patterns across 3873 prod functions in 10 modules — 19,087 total
disp-mode loads. Only 3 cases where SHC chose indexed when disp
would have fit: 2 in FUN_06044834 (offsets 26 and 30) and 1 in
FUN_06033DC8 (K=1 for .b). 0.016% anomaly rate — clearly not a
heuristic.

**Resolution.** Added `#pragma sh_weird_rule_1` (`b67fe7e`). Opt-in
per function; when present, the phase-1 driver runs
`sh_apply_weird_rule_1()` which converts every .w disp-to-r0 load
AFTER the first into indexed form. Narrow, declarative, honest
about the fact we're matching an engineer's intent rather than a
compiler rule.

**When to use.** Only in functions where prod evidence specifically
shows this pattern. Resist the urge to widen. If new anomalies
surface that don't fit the "first-disp-then-indexed" shape, file a
new numbered weird rule rather than broadening this one.

**Not the same as Gap 5.** Gap 5 is about producing indexed
instructions at all for accumulator/loop patterns (still open).
Gap 2 is specifically about choosing indexed when disp would fit,
which is empirically unique to 2 functions.

---

### Gap 3. Function pointer inlining &nbsp;&nbsp;**[layer: C source / pragma]**

**Status:** open.

Production: `mov.l .L_pool, r3; jsr @r3` (2 instr), pool contains the
function address directly. Ours:
`mov.l L_addr_of_ptr, r1; mov.l @r1, r3; jsr @r3` (3 instr) because
the C source uses `extern T (*DAT_XXX)()` — an indirect pointer
variable.

Same root cause as Gap 0. Least-invasive fix: C source convention
like `#define DAT_XXX known_func_name` to let LCC inline the call.

---

### Gap 4. Stack spill elimination in loops &nbsp;&nbsp;**[layer: allocator]**

**Status:** open. Shares root cause with Gap 7 Layer A.

Production keeps loop iterators in registers across iterations. Our
compiler spills to stack and reloads every iteration when register
pressure is moderate. FUN_0602A664 inner loop has about 3
spill/reload pairs per iteration; production has 0.

Allocator doesn't extend live ranges well across backward branches.

**Fix:** loop-liveness pass that detects values live across the
backward branch and biases them toward callee-saved registers with
long retention. Allocator-quality work in `gen.c` or a pre-pass to
it. Peephole is the wrong layer — you'd be re-threading data through
registers the allocator explicitly chose not to use.

---

### Gap 5. Proactive R0 routing for indexed addressing &nbsp;&nbsp;**[layer: peephole; ceiling acknowledged]**

**Status:** open; peephole approach bounded. Full fix blocked on
Gap 13. Investigation recorded in
[r0_register_class_design.md](r0_register_class_design.md).

Production threads values through R0 deliberately to enable
`mov.X @(r0,rN),rM` indexed instructions. Our compiler picks
registers without lookahead, so R0 is rarely available when needed.
`sh_route_via_r0` catches about 2 sites; production uses 14 in E28.

The R0 register class design investigation concluded that teaching
the allocator to prefer R0 for short-lived values with a downstream
indexed-eligible use requires changes to lburg's cost model
(Gap 13). Static cost selection can't say "cost 1 if R0 is free,
cost 2 otherwise."

**Fix (peephole, bounded):** aggressively extend `sh_route_via_r0`
with demand-based rewriting — scan for indexed-eligible patterns,
walk back to find where one of their operands was set, rewrite the
setter to target R0 if the destination is otherwise dead. Much more
aggressive than the current version.

**Ceiling:** no post-allocation peephole can catch cases where
prod's value routing requires choices earlier in the pipeline.
Probably most of the 12-instruction gap in E28.

**Fix (full):** Gap 13 — extend lburg's rule selection to consult
register state.

**Open question (from `r0_register_class_design.md`):** is there a
real-world function we can't byte-match through hybrid peepholes
alone? If yes, that's the trigger to go deeper. If no, we don't
need to. Going hybrid first lets us find out cheaply.

---

### Gap 6. Forward-moving conditional delay slot fill &nbsp;&nbsp;**[layer: peephole; depends on Gap 11]**

**Status:** open; gated by Gap 11 for the common case.

Production converts `bt L` to `bt/s L; <insn>` where `<insn>` is
the first instruction of the fall-through path AND whose destination
is dead on the branch-taken path. Our current cond-delay peephole
only scans backward.

Most of our `bt`/`bf` sites have labels immediately preceding the
cmp (from our loop structure), blocking the backward scan. Gap 11
fixes that blocker for the common case; Gap 6 is the forward-scan
case for non-loop branches.

**Fix:** peephole that for each `bt`/`bf` checks the next
instruction's delay-safety and checks liveness of its destination
at the branch target. If dest is dead at target, convert. Needs a
reusable "is register R dead at line L" helper — start by
generalizing `sh_r0_dead_at`.

---

### Gap 7. Base-pointer factoring &nbsp;&nbsp;**[layer: peephole / allocator]**

#### Layer B (load/store displacement) — shipped

**Status:** shipped — `15a717b`.

`sh_fold_base_displacement` peephole collapses `mov rA,rB;
add #K,rB; mov.X @rB,rC` (and the store mirror) into
`mov.X @(K,rA),rC` when K fits the size's displacement range. Net
−86 lines across the race_tu1 candidates; E28's clustered
`@(disp,r13)` loads now match prod idiom-for-idiom.

#### Layer B extensions — open, small scope

- Base rebuild with `add rA,rB` head instead of `mov rA,rB` (1
  site in E28 around line 800).
- Multi-access store chain (T2): `mov rA,rB; add #K1,rB; store;
  mov rA,rB; add #K2,rB; store; ...` collapses to a single base
  setup + two displacement stores. Rare (2 sites in FUN_0604025C,
  FUN_06040EA0) but principled; would need the constant-store value
  to be in R0 for byte/word stores.

#### Layer A (allocator) — partial, shipped

**Status:** partial — `385eafb` shipped parameter-register reuse
after last DAG use (methodology_remediation H2 spike). The
allocator now uses r4–r7 as additional scratch once parameters
are consumed, shrinking spill pressure on register-saturated
functions (FUN_06037E28 -12 lines, FUN_06044BCC -14 lines).

What's still open: **base-factoring CSE.** Production does more
than just mutate r4 — it identifies clustered `@(K_i, rA)`
accesses, hoists `add #K_center, rA` once when rA is dead-at-
epilogue, and rewrites the group as relative displacements off
the mutated base. FUN_0604025C is the canonical example: prod
does `add #0x10, r4` once, then expresses four subsequent stores
as `@(3,r4)`, `@(2,r4)`, `@(4,r4)`, return. That requires a
peephole-layer pass similar to the shipped `sh_fold_base_displacement`
but with cluster-detection logic. Allocator can't see it — the
offsets are visible per-node, not as a group.

Shares root cause with Gap 4 (loop-invariant spill elimination).

---

### Gap 8. Constant reuse across stores &nbsp;&nbsp;**[layer: allocator or peephole]**

**Status:** open.

Production loads `#0` once and reuses across multiple stores. We
reload each time.

**Fix (peephole):** cross-statement liveness tracking for constants
— if a constant-loaded register isn't clobbered between two use
sites, reuse instead of reloading. Tractable: scan for `mov #N, rA`
... `mov #N, rB` where the second can be replaced with `mov rA, rB`
if rA is live, or skipped entirely if rA is already in the target
position.

Compounds nicely with Gap 7 Layer B since its byte/word disp-mode
already needed R0.

---

### Gap 9. Redundant extension edge cases &nbsp;&nbsp;**[layer: peephole]**

**Status:** partial — `765db70` extended `sh_elim_redundant_ext` to
recognize .w/.b displacement-mode (`@(disp,rN)`) and indexed-mode
(`@(r0,rN)`) loads as sign-extending sources. Previously only the
indirect form (`@rN`), GBR-relative, and pool literal loads were
tracked. This generalized to 8 corpus functions improving (FUN_06044834,
FUN_00280710, FUN_06000AF8, FUN_06047748, FUN_0604025C, FUN_0602A664,
FUN_06040EA0, FUN_06044BCC, FUN_06037E28).

Remaining residual cases: the original audit note mentioned
FUN_06047748's surviving `exts.w r1, r4` chain. That function still
has 26 diffs vs prod — not all of them are exts.w, but any remaining
redundant-ext leaks fall under this gap until the pass is audited
end-to-end. Revisit if the diff stalls on redundant-ext patterns
specifically.

---

### Gap 10. Pre-decrement stores &nbsp;&nbsp;**[layer: peephole]**

**Status:** open, small.

Production uses `mov.X rM, @-rN` for stack pushes and similar
patterns. Our compiler emits `@-r15` for prologue pushes via direct
emit code but not for other pre-decrement patterns.

**Fix:** peephole symmetric to `sh_fold_post_increment` — fold
`add #-size, rN; mov.X rM, @rN` into `mov.X rM, @-rN` when nothing
between reads rN. Low-risk, mechanical.

---

### Gap 11. Loop inversion &nbsp;&nbsp;**[layer: front-end]**

**Status:** open; gates Gap 6.

Our compiler emits loops with the test at the top
(`bra test; body: ...; test: cmp; bf body`), placing a label before
the cmp — blocks our backward-scan delay slot fill. Production uses
test-at-bottom (`body: ...; cmp; bf body`) with no label between
the increment and the branch.

Emitted by LCC's `stmt.c` front-end when lowering `for`/`while`.

**Fix (right layer):** modify `stmt.c`'s loop emission to produce
test-at-bottom directly.

**Fix (peephole layer):** pattern-match the bra-to-test structure
and invert. 100+ lines of careful CFG rewrite.

---

### Gap 12. Address-register independence in compound rules &nbsp;&nbsp;**[layer: lburg-infrastructure]**

**Status:** open; structural.

Our indexed addressing compound rules failed because `emit2()` had
no separate temp register when the destination collided with an
input. Broader issue: lburg compound rules can't request scratch
registers.

**Fix:** mechanism for compound rules to request a scratch register
(new lburg syntax extension, or a `target()` hook that reserves a
scratch before emit2 runs). Real change to the lburg tool.

**Impact:** blocks compound-rule approaches for multi-input /
single-output patterns that need an intermediate register. Current
workaround — post-allocation peepholes — works for specific patterns
(indexed, displacement) but each new pattern needs its own peephole.

---

### Gap 13. R0 register class awareness in the lburg cost model &nbsp;&nbsp;**[layer: lburg-infrastructure]**

**Status:** open; structural. Blocks full fix of Gap 5. Combined
with Gap 12, the two deep lburg limitations.

Rule selection is static. We can't express "cost 1 if R0 is free,
cost 2 otherwise." This is why forced R0 via `target()` causes
cascading spills.

**Fix:** extend lburg's rule selection to consult register state,
or do two-phase selection where allocation feedback affects rule
choice. Deep infrastructure change.

---

### Gap 14. MAC unit / SR flag intrinsics &nbsp;&nbsp;**[layer: front-end or pragma]**

**Status:** open; enables three currently non-compilable race
functions.

Three race-module functions use MAC unit ops (`dmuls.l`,
`sts macl/mach`, `clrmac`) or SR flag dependencies. Not expressible
in standard C.

**Fix:** pragma support or `__asm`-style intrinsics that let C
source specify these operations directly. Requires tokenizer/parser
extensions in `input.c` or `lex.c`.

---

### Gap 15. Non-standard register parameter conventions &nbsp;&nbsp;**[layer: front-end + TU reconstruction]**

**Status:** open; prereq for Gap 1B.

15 of 25 complete race-module functions use registers other than
r4–r7 for implicit parameters — SHC's interprocedural register
allocation across same-TU functions. Not expressible in standard C.

Examples:
- FUN_06047748's `rts; mov r4,r8` return (r8 as return register).
- FUN_0602A664's caller-save-around-jsr for r10/r13 (intra-TU
  caller-saves knowledge).

**Fix:** TU reconstruction (separate DaytonaCCEReverse workstream)
plus pragma support for specifying register bindings at function
boundaries.

---

### Gap 16. Register-rename bridging moves &nbsp;&nbsp;**[layer: allocator or peephole]**

**Status:** open.

Our output has `mov rA, rB` followed by an operation on rB where
production would rewrite the successor's operand to use rA directly.
FUN_06047748: `mov r0, r1` then `exts.w r1, r4` where production
does `exts.w r0, r4`.

The allocator's virtual-to-physical mapping changes across nodes,
and when a VREG gets different physical registers at producer vs
consumer, LCC emits a `mov` to bridge. SHC apparently either avoids
the mapping change or coalesces the move away.

`sh_coalesce_move_chains` already does some of this. Residual cases.

**Fix:** extend `sh_coalesce_move_chains` to handle more patterns,
or address the root cause in `gen.c`'s `ralloc` by coalescing VREG
assignments across basic block boundaries. Allocator fix is more
principled; peephole is more tractable.

---

### Gap 17. Address-literal compaction diverges from SHC &nbsp;&nbsp;**[layer: lburg-infrastructure]**

**Status:** shipped — `e22de96`.

Two principled fixes in one commit:

- `emit2`'s CNST+P path now always uses `mov.l + .4byte`. Previously
  CNST+P shared emit2's CNST+I handler and got value-based
  compaction to `mov.w + .short` when the address happened to
  sign-extend from 16 bits (e.g. `0xFFFFFE92`). Dispatch is now on
  DAG node type, not value — matches SHC's consistent pointer-literal
  idiom.
- `sh_fold_mov_extw_to_movw` peephole folds `mov.l Lx,rN;
  exts.w rN,rN` into `mov.w Lx,rN` and shrinks the pool entry from
  `.long` to `.short` (low 16 bits). Only fires when ALL readers of
  Lx match the pattern; partial-fold cases fall through cleanly.

Supporting work: `shlit_flush` reorders pool output (shorts first,
then longs with alignment pad if needed) so mid-pool shrink doesn't
misalign subsequent `.long` entries. lburg gained `/* */` comment
support — the grammar-section comments added in `47616fa` were
latent-broken until this forced lburg to re-parse.

---

### Gap 18. `mac.l` dot-product codegen &nbsp;&nbsp;**[layer: C source + instruction-selector]**

**Status:** deferred; scoped for the byte-match pass. Distinct from
Gap 14 (which is about C-source expressivity for explicit MAC-unit
intrinsics); this gap is about backend pattern-matching the
accumulator idiom.

SH-2's `mac.l @rA+, @rB+` instruction performs a 32×32→64
multiply-accumulate with two post-increment memory loads in a
single instruction. Production uses it extensively in physics /
matrix code — 118 occurrences in `FUN_06044060.s` alone. Typical
prod sequence:

```asm
dmuls.l r0, r6         ; acc = r0 * r6
mac.l   @r4+, @r5+     ; acc += *r4++ * *r5++
mac.l   @r4+, @r5+     ; acc += *r4++ * *r5++
sts     mach, rX       ; hi 32
sts     macl, rY       ; lo 32
```

Ghidra cannot represent `mac.l` in C, so it de-fuses each
accumulation step into explicit 32×32→64 Karatsuba math plus manual
carry propagation — roughly 50 lines of de-fused C per fused
instruction. Four functions in the TU1 corpus hit this:
FUN_06045FC0, FUN_060463E4, FUN_06046478, FUN_06046520 (the `⚠
SKIPPED` entries at 112–115 in
`race_FUN_06044060/TODO.md`). rcc currently emits a clean
"unsupported DAG shape" error for these (`0e503b2`).

**Why register-pair VREG support is the wrong fix.** Adding real
8-byte VREGs to the allocator would let us *compile* Ghidra's
de-fused form — emitting one `dmuls.l` per product plus explicit
`add/addc` sequences for the carry arithmetic. That structurally
cannot byte-match a prod sequence of `dmuls.l` + `mac.l` chains;
it would bank ~200 lines of backend complexity with no byte-match
dividend.

**Fix approach:**
1. C-source side: hand-rewrite the de-fused Ghidra body back to a
   clean `acc += (int64_t)a * b` loop over the actual operand
   arrays. Scope: probably 10+ race functions; labour-intensive
   but mechanical. Semantic validation requires the byte-match
   metric — circular until step 2 lands.
2. Backend side: lburg rule for `ADDI8(INDIRI8(ADDRLP4),
   MULI8(CVII8, CVII8))` + pointer-postinc operand shape →
   emits `mac.l @rA+, @rB+`. Seed rule for the initial
   `dmuls.l`. New pattern class: pointer post-increment as an
   operand (not currently modelled in `src/sh.md`'s load family).
3. Composition: rewrite the C to express the dot product as a
   pointer-walk over two arrays; pattern emits `dmuls.l` +
   `mac.l` chain. Saturation logic (the `SR.S` paths in the
   skipped functions) lowers separately.

Neither half is useful without the other, which is why the whole
gap is deferred to the byte-match pass. Until then, the 4 skipped
functions remain `#if 0`-wrapped with pointers back here.

---

## TU reconstruction dependency

Several gaps trace back to SHC's whole-TU knowledge that we don't
have. Examples from the race module:

- **FUN_06047748** returns via `rts; mov r4,r8` — r8 as return
  register, non-standard. SHC used a private TU-level convention
  between this function and its caller (Gap 15).
- **FUN_0602A664** uses r10, r13 as loop state but saves them
  around a `jsr` to intra-TU `FUN_060458DE` — caller-save semantics,
  only possible because SHC knew the callee's convention (Gap 1B,
  depends on Gap 15).
- **FUN_06044BCC** "fixed" DAT pool entries — SHC's compile-time
  literal resolution is a TU-level constant-propagation decision.
  Encodable per-function via `#define` (Gap 0); driving it from
  reconstructed TU evidence would be cleaner.

The sister project `DaytonaCCEReverse` reconstructs TU boundaries
(783 raw race functions reduced to 211 TU groups). That's the
evidence base for Gap 1B and Gap 15. Until that evidence is encoded
as pragmas in our C sources, anything depending on TU knowledge is
guessing.

## Conventions for this doc

- **Gap numbers are permanent.** If a gap is retired or rescoped,
  update its entry — don't renumber. Shipped gaps stay in the list
  with their commit refs.
- **Layer tag can be multi-valued** when a gap is genuinely
  workable at two layers with different trade-offs (Gap 7, Gap 8,
  Gap 11, Gap 16). Say which is preferred and why.
- **Status values:** `shipped` (with commit), `open`, `deferred`
  (scheduled but not yet started), `blocked on X` (unblockable
  without another gap or workstream).
- **When adding a new gap,** cross-reference it from the dep graph
  above if it participates in any "A before B" relation.
