# IPA Phase E design (B): pre-ralloc DAG rewrite into a pinned register variable

## Position in one paragraph

Do the entire transformation in a new **pre-ralloc IR-rewrite pass** that
runs inside `sh_process_deferred_fn` between `gencode()` argument capture
and the per-statement `rewrite()` / `ralloc()` loop. The rewrite promotes
p1 to a genuine SH-local **register variable** already bound to r4 via
the existing `askregvar` machinery, and rewrites every `ARG(ADD(VREG(p1),
K))` subtree into `ARG(VREG(p1))` preceded by an `ASGN(VREG(p1),
ADD(VREG(p1), K - running_delta))` statement emitted into the Code list.
The restore is similarly an explicit `ASGN(VREG(p1), ADD(VREG(p1), -total))`
node appended before the epilogue. By the time `ralloc()` sees any of
this, it looks exactly like a hand-written C function that declared
`register int * r4_var = p1; ... r4_var += 0x30; f1(r4_var); r4_var +=
0x10; f2(r4_var); ... r4_var -= total;` — a pattern the existing
allocator already handles correctly with zero changes.

**The central bet:** the cleanest cut is to stop asking "how do we teach
the shared allocator a new concept" and instead ask "can we restate the
problem in a form the shared allocator already solves correctly?" SH-2's
allocator already supports register-variable-pinned-to-r4 with ADDs that
mutate it in place — it does so every time a user writes
`register int x asm("r4"); x += 48;`. The IPA fact just authorizes the
backend to *synthesize* that user-visible shape.

## Why A's central mechanism is the wrong cut

Design A's centerpiece is a new `Xnode` bit (`vbl_mutate`) plus surgical
patches in `getreg()`. Read the mechanism carefully: A asks the allocator
to sometimes, conditionally, not clear `regnode->vbl` after allocating a
register. That is a change to the semantics of **what `vbl` means** —
today, `vbl != NULL` is the allocator's invariant "this register is
reserved for a register variable that lives across the whole function."
A's patch weakens this to "this register is reserved for a register
variable, UNLESS a downstream node opts in to mutating it." Three
consequences:

1. **The invariant becomes conditional.** Every other piece of gen.c
   that reads `regnode->vbl` — `spillee`'s assert, `uses()`, the
   debug printers, the wildcard-availability computation — was written
   assuming `vbl != NULL ⇒ don't touch`. A's guard only narrows one
   of those sites (`getreg`'s clear, and implicitly `spillee` by never
   reaching it). Every future gen.c maintainer who reasons about `vbl`
   now has to know about the `vbl_mutate` exception. This cost is
   permanent and cross-backend.

2. **The `x.vbl_mutate` node bit is a recomputation of a decision
   that already lives on the function.** A sets the bit during
   `target()` after looking at `sh_ipa_current->vbl_pinned_sym`, then
   reads the bit back in `getreg()` (called seconds later from
   `ralloc()`) to decide what to do — but `ralloc()` could just consult
   `sh_ipa_current` directly. The bit is a courier between two
   backend-aware code sites that happen to sit on either side of the
   shared allocator, and its only purpose is to sneak a decision
   across. That's a code smell: the bit is trying to hide that the
   shared allocator and the backend are coupling.

3. **A's delta bookkeeping via `sh_ipa_current->vbl_pinned_delta`
   read at emit time is a time-travel.** The first `ARG(ADD(p1, 48))`
   emits `add #48, r4` and sets delta to 48. The second
   `ARG(ADD(p1, 48))` computes `48 - 48 = 0` and elides. That is a
   stateful decode: the emit template reads a mutable global whose
   value depends on what was emitted earlier in the same function.
   Any change to drain ordering or any future CSE that removes one
   of the intermediate ADDs desynchronizes this. It is the exact
   class of latent state leak that bit us in Phase B.1 (`shlits`
   reverse-topo failure). Designing new such leaks when we're still
   papering over the old ones is the wrong direction.

Design A is buildable. I'm claiming it's *more work to maintain* than B,
not *impossible*. The weight of the central bet — "add a semantic
exception to a shared allocator invariant" — is paid every time anyone
touches gen.c for the lifetime of the fork.

The cut B makes is different: **do the transformation as a source-level
DAG rewrite that emits normal-looking IR, so the allocator stays on its
standard path for well-understood register-variable semantics.**

## 1. Data model

### 1a. No config.h changes

The `Xnode` struct is untouched. The `Xsymbol` struct is untouched. The
`Xinterface` struct is untouched. The other five backends see
zero-byte-diff in any shared header.

### 1b. Per-function sh.md state

`struct sh_ipa_fn` (sh.md ~142) gains:

```
Symbol   pinned_param;       /* the parameter Symbol we pinned to r4, or NULL */
int      pinned_reg;         /* 4 (room to generalize later) */
int      total_delta;        /* net signed byte offset from original p1,
                                used to synthesize the restore ADD */
int      needs_restore;      /* 1 if any post-pin ARG site read p1 with a
                                non-zero offset; drives restore synthesis */
```

These are filled during the new rewrite pass (section 2). Zero by default
— no IPA pin, no state, no behavior change.

### 1c. Why the parameter Symbol is enough

The parameter Symbol (`callee[0]` / `caller[0]` in `sh_process_deferred_fn`)
is a regular front-end Symbol with `sclass == REGISTER` after param
homing. `askregvar(p, ireg[4])` binds it to r4 just like any other
register-class local. Every subsequent `VREG+P` load of p1 resolves
through that Symbol's `x.regnode` — the allocator's standard path. We
don't need a second "carrier" symbol; p1 *is* the carrier.

## 2. Allocator integration: there isn't any

The shared allocator is not modified. Not one line in `gen.c`. Not one
line in `config.h`. Instead we do **two** things, both inside sh.md and
both scoped to the one function that IPA has cleared:

### 2a. The rewrite pass: `sh_ipa_rewrite_arg_adds`

Runs inside `sh_process_deferred_fn` between the `askregvar(p, ireg[4])`
call (already there at sh.md:6494) and the `gencode()` call. Walks the
captured Code list (the function's linearized statement chain). For every
Code node that is a CALL statement, for every `ARG` kid of that CALL,
examines the ARG's subtree:

- If the ARG's subtree is `ARG(VREG(p1))` (no offset, p1 passed raw):
  no rewrite. The existing flow handles this perfectly today — the
  allocator sees p1 already in r4, emits no move.
- If the ARG's subtree is `ARG(ADDI(VREG(p1), CNST(K)))` where K is a
  signed byte constant and p1 is the pinned param:
  1. Compute `delta = K - running_delta_for_this_function`, where
     `running_delta` is tracked in the rewrite pass's loop state and
     mirrors what r4 *will* hold at this point in the emitted stream.
  2. If `delta == 0`: replace the ARG's kid with `VREG(p1)`. No ADD,
     no code emitted, ARG is a no-op (p1 already in r4).
  3. If `delta != 0`: synthesize an `ASGN(VREG(p1), ADDI(VREG(p1),
     CNST(delta)))` node and splice it into the Code list **as its
     own statement**, immediately before the CALL statement. Rewrite
     the ARG's kid to be a bare `VREG(p1)`. Update `running_delta += delta`.
- Any other ARG subtree: leave alone. Non-p1 args, non-mutation shapes,
  or complex expressions all flow through the existing allocator path.

Key architectural claim: **by splicing the ASGN out as its own Code
statement, the allocator sees it as a textbook `p1 = p1 + K` assignment
to a register-variable-pinned-to-r4.** `rewrite()` → `prelabel()` →
`ralloc()` handle this case correctly today. The emit template for
`ASGN+I(VREG(r4), ADDI(VREG(r4), CNST))` is the existing `add #K, r4`
rule. No new rule, no new mask, no new bit.

### 2b. The restore: also a synthetic ASGN

After the CALL-arg rewrite loop finishes, if `total_delta != 0` and
the parameter's Symbol has `lastuse` beyond the last CALL, or we simply
decide to unconditionally emit the restore (see 4b for the decision
logic), synthesize one more statement:

```
ASGN(VREG(p1), ADDI(VREG(p1), CNST(-total_delta)))
```

and splice it into the Code list immediately before the epilogue (the
Code node that emits the function return). Again, the allocator sees it
as an ordinary `register += constant` assignment and emits `add
#-total_delta, r4` from the standard template.

### 2c. Why this works without touching gen.c

The failure mode Phase D hit was: `askregvar(p1, ireg[4])` binds r4 to
p1, making r4 not available in `freemask`. The first `ARG(ADD(p1, 48))`
asks ralloc to place the ADD's result in r4. Ralloc calls `askfixedreg`,
which fails because r4 isn't in `freemask`. It falls through to
`spillee`, which asserts because r4 is `vbl`-bound.

In B, by the time ralloc runs on the CALL statement, the ADD is gone
from the ARG tree. The ARG's kid is a bare `VREG(p1)`. The allocator
sees: "this ARG wants its kid in r4; the kid is already in r4" — no
move, no allocation, no assertion. The ADD node we split out lives in
its own ASGN statement that runs *before* the CALL statement. That ASGN
tree is `ASGN(VREG(p1), ADDI(VREG(p1), CNST))`. Prelabel sees an ASGN
whose LHS is a VREG+P; it calls `rtarget(p, 1, VREG's Symbol)` (gen.c:464),
which targets the RHS (the ADD) into p1's regnode, i.e. r4. The ADD's
emit rule is `add #K, Rn` with `Rn` resolved from the register allocator.
Since p1 is `vbl`-bound to r4 and the RHS has been `rtarget`'d to p1's
regnode, the allocator places the ADD's result in r4 via the standard
"destination coincides with source" copy-elimination path (gen.c:673-674,
our own copy-elim relaxation). No assertion. No new bit.

## 3. Cross-call liveness

### 3a. It's already there

p1's Symbol has `sclass == REGISTER` and `x.regnode->vbl == p1` across
the whole function body, because that's what `askregvar` does today.
`clobber()` at every CALL calls `spill(INTTMP & ~INTRET, IREG, p)`.
`spill()` walks the affected registers and for each one, either it's
live somewhere past the CALL or it isn't. For r4, the register is
`vbl`-bound — `spill()` in gen.c checks `r->x.regnode->vbl != NULL` and
**never spills vbl-bound registers** (this is the existing, not-new
behavior). So r4 survives each CALL naturally.

The clobber callback in sh.md does *not* need to mask r4 out of the
spill mask. Even if `INTTMP` includes r4, the vbl binding on p1 makes
`spill()` skip it. The Phase D's prospective `clobber` narrowing hook is
unnecessary under B.

### 3b. Why Phase D crashed but B doesn't

Phase D did enable `askregvar(p, ireg[4])`, which on its own is correct.
The crash came from the subsequent ARG(ADD(p1, 48)) subtree: ralloc tried
to place the ADD's result in r4 via `getreg`, and r4 wasn't in
`freemask`. Under B, the ADD is never a kid of ARG when ralloc runs; it's
its own statement, and its RHS is rtarget'd to p1's Regnode by the
standard ASGN-to-VREG prelabel path (gen.c:462-464). That path doesn't
route through `askfixedreg` at all — it uses the regnode the Symbol
already owns.

### 3c. Running-delta invariant is static, not dynamic

Crucially, B's `running_delta` is a **compile-time invariant tracked by
the rewrite pass over the Code list**, not a value the emit template
reads at emit time. Once the rewrite pass is done, the emitted ADDs are
literal constants in the IR — `CNST(48)`, `CNST(0)`, `CNST(-48)` — that
happen to sum to zero (or to `-total_delta`, if we include the restore).
The IR is pure after the rewrite. No emit-time statefulness. This is the
architectural difference from A's section 3b: A reads mutable global
state from an emit template; B bakes the delta into the IR constants.

## 4. Restore emission

### 4a. Materialized as IR, not as peephole

The restore is an explicit `ASGN(VREG(p1), ADDI(VREG(p1), CNST(-total)))`
node synthesized into the Code list. It goes through `rewrite()` →
`ralloc()` → `emit()` like any other statement, producing `add #-48, r4`
via the standard template. No peephole, no post-emit text rewrite, no
delay-slot-filler coupling.

### 4b. When to emit it

The decision "is the symbol live after the last call?" is answered by
looking at the captured Code list: walk forward from the last CALL; if
any Code node references p1 before the epilogue, or if we choose the
conservative default, emit the restore. For FUN_06044060 specifically
prod emits the restore regardless of apparent liveness — probably
because SHC's invariant is "the symbol you received as p1 is still p1
at return, in case the caller or the ABI cares." B defaults to
unconditional restore when `total_delta != 0`, with a kill switch
pragma (#pragma no_ipa_restore(FUN_...)) if we later find a function
where this is wrong.

### 4c. Delay-slot placement

Prod puts the `add #-48, r4` into the last CALL's delay slot. B's
restore ASGN emits as `add #-48, r4` after the CALL. The existing
`sh_coalesce_move_chains` and the delay-slot filler (sh.md:3892,
sh.md:6906 region) already pull safe follow-up instructions into vacant
delay slots. Since the restore ADD doesn't read or write r0 (the CALL
target), doesn't read any of the last CALL's arg registers (the final
CALL has long since moved past ARGs by the time the restore is emitted),
and is pure register arithmetic, the filler will pull it into the slot
naturally. **If it doesn't — if an instruction that shouldn't end up in
the delay slot gets pulled first, blocking the restore — B's fallback is
to extend the filler's candidate ordering to prefer the restore when
`sh_ipa_current->pinned_param` is set.** That is a 3–5 line change local
to the delay-slot filler, not a new subsystem.

## 5. Backend isolation

### 5a. What changes in gen.c

**Nothing.** Zero edits to `gen.c`. Zero edits to `config.h`.

All six backends see bit-identical headers and bit-identical shared
allocator. No `#ifdef` for SH-only behavior in shared code. The
regression surface for alpha/mips/sparc/x86/x86linux is exactly zero
— mechanical to verify because there is literally no changed byte in
any file they compile against.

This is B's single biggest architectural advantage over A. A makes
three changes to shared code (two to `getreg`, one to `config.h`'s
`Xnode`); even with guards defaulting to false, those changes are
permanent cross-backend surface area. B has none.

### 5b. What changes in sh.md

1. `struct sh_ipa_fn`: four new fields (section 1b).
2. A new function `sh_ipa_rewrite_arg_adds(struct sh_ipa_fn *e)` that
   walks the Code list and performs the DAG surgery described in 2a.
3. A new function `sh_ipa_emit_restore(struct sh_ipa_fn *e)` that
   appends the restore ASGN if needed (section 4b).
4. `sh_process_deferred_fn`: one call to (2) after `askregvar` succeeds,
   and one call to (3) before `gencode()` emits the epilogue.
5. (Already landed in Phase D.) The `askregvar(p, ireg[4])` call guarded
   by `sh_ipa_all_callees_preserve_r4()`.

Everything is local to sh.md. The `Phase A–D` infrastructure is
unchanged.

### 5c. Validation

`wsl bash saturn/tools/validate_build.sh` gates every iteration. Because
B's only behavioral changes are (a) inside the IPA-cleared branch and
(b) synthesize only IR shapes the allocator already handles, the
regression surface on the other 40 byte-matched functions is minimal. If
any regress, they do so because the IPA predicate fires unexpectedly on
a function we previously thought wouldn't trigger it; section 6 covers
this.

## 6. Failure modes

### 6a. IPA predicate wrong (callee secretly writes r4)

Same mitigation as A. `sh_ipa_all_callees_preserve_r4` is conservative
on externs. Within the TU it's as correct as Phase C's writes_r4
analysis. If wrong, byte-match fails immediately on the caller and the
test reports a diff; the pin is off by default on any function whose
callees aren't all in-TU.

### 6b. The pin causes spill elsewhere in the function

Identical failure mode to A. If pinning p1 to r4 causes register
pressure to push another variable to the stack, we see a `mov.l rX,
@-r15` in the output. The kill switch is the same: disable
`sh_ipa_all_callees_preserve_r4` for that function via a
`#pragma no_ipa_pin(FUN_...)`.

### 6c. ARG subtree doesn't match the rewrite pattern

If the front end gives us `ARG(INDIR(ADDI(VREG(p1), CNST)))` (load from
p1+K, not the pointer p1+K itself — a different semantics) or
`ARG(ADDI(ADDI(VREG(p1), CNST), CNST))` (un-folded addition chain),
the rewrite doesn't fire and we fall back to today's stash-to-r8
behavior. **This is a graceful degradation**: we lose the IPA win on
that specific arg site but don't break anything. The rewrite pattern
matching lives in one function (`sh_ipa_rewrite_arg_adds`) and is
tightenable iteratively as we encounter corpus shapes.

Contrast with A: A's rewrite pattern is baked into `target()` and
spread across `getreg`'s conditional branches; tightening the pattern
means reasoning about the allocator's control flow. B's pattern
matching is all in one pass, one function, pure DAG surgery with no
allocator coupling.

### 6d. The restore ends up in wrong epilogue

The restore is spliced before the epilogue Code node. If the function
has multiple returns (not the case for FUN_06044060, but possible in
general), we need to splice the restore before each return path that's
reachable with non-zero `total_delta`. First cut: single-return only,
assert that the function has exactly one epilogue node; fall back to
"no restore" if not. Covers FUN_06044060 and the common case; failure
mode for multi-return is "restore missing," detectable by byte-match.

### 6e. Recursive IPA within an SCC

Phase C's writes_r4 analysis handles SCCs pessimistically (everyone in
an SCC assumes everyone else writes all regs). So
`sh_ipa_all_callees_preserve_r4` returns 0 for SCC members. No pin, no
rewrite, no surprise.

### 6f. DAG node identity during rewrite

Splicing ASGN nodes into the Code list touches `code->next`/`prev`
linkage but not the Node DAGs. The ASGN Node we synthesize is fresh
(via `newnode()`, the same constructor used by `genspill`). It has no
conflicting `prevuse`/`lastuse`; those are populated during ralloc. No
aliasing hazards with captured IPA state.

## 7. Rejected alternatives

### 7a. Design A

Covered in depth in "Why A's central mechanism is the wrong cut."
Summary: A works but adds permanent semantic exceptions to a
shared-header invariant (`Xnode` bit) and a shared allocator invariant
(conditional `vbl` clear). The cost is paid every time anyone touches
gen.c, forever, across all six backends. B avoids that cost entirely.

### 7b. Peephole over final text (A4 from ipa_design)

Same rejection as A's section 7b: the stash-to-r8 output has cascaded
off-by-one register choices that can't be cleanly undone by text
peephole without redoing allocation. B avoids this by never entering
the stash path in the first place.

### 7c. Relaxing `spillee`'s assert

Same rejection as A's section 7a: gives worse output (stack spills
with per-call reloads). B doesn't touch spillee; it routes around it.

### 7d. A new Xinterface callback

Same rejection as A's section 7c: pushes backend decisions into the
allocator's hot path and duplicates logic that already exists
elsewhere. B's dispatch is entirely pre-allocator, in sh.md, on the
Code list.

### 7e. Doing the rewrite in `target()` per-node

Tempting (it would remove the need for a separate pass), but `target()`
sees nodes one at a time and doesn't know whether this is the first ARG
using p1, the second, or the last. The running-delta bookkeeping needs
to walk statement order. A separate pass over the Code list is the
right granularity. It is also easier to unit-test than in-line target
hooks.

## 8. Scope for one session

- Hour 1: implement `sh_ipa_rewrite_arg_adds` pattern-matcher for the
  narrow `ARG(ADDI(VREG(p1), CNST))` shape. Plumb it into
  `sh_process_deferred_fn` behind `sh_ipa_all_callees_preserve_r4`.
- Hour 2: re-enable `askregvar(p, ireg[4])` (already coded from Phase D,
  just flip the guard back on). Run validate_build; confirm no
  allocator assertion (we've routed around it).
- Hour 3: implement `sh_ipa_emit_restore` and the single-return splice.
  Run validate_build; eyeball FUN_06044060's diff. Expectation: the
  cluster collapses to ≤6 lines.
- Hour 4: delay-slot filler check — does the restore naturally land in
  the last CALL's slot? If not, 3–5 line fix to the filler's candidate
  ordering (section 4c).
- Hour 5: chase the last few diff lines (pool ordering, LP label
  numbering, etc. — familiar territory).
- Hour 6: validate_build full suite; spot-check other byte-matched
  functions; write up notes.

If hour 3 shows the cluster collapsing but new diffs appear on
unrelated byte-matched functions, the rewrite pattern matcher is too
aggressive — tighten the guard (the IPA predicate itself, or an
additional "is this function's first call a known r4-preserving one"
check). No code is needed in gen.c for this tightening; it's all in
the pass.

## 9. What a hostile reviewer will probe

- **"You're doing IR surgery on a captured DAG — Phase A.1's whole
  point was that captured DAGs are fragile."** Fair. Mitigation: the
  surgery is *additive* (splice a new ASGN) and *subtractive* in one
  narrow shape (replace ARG's kid with bare VREG). No deletion of
  existing nodes; we only substitute kids. The captured DAG integrity
  (node identity, symbol references, the `Code` linked list) is
  preserved except for the two targeted mutations, each with a clear
  invariant.
- **"Splicing a statement before a CALL reorders emission; that
  interacts with Phase A.1's positional-pragma state."** It doesn't —
  the new ASGN is inserted *before* the CALL it supplies args to, so
  its emit happens at the same logical point as today's arg setup
  (just written differently). Pragma state captured at `function()`
  time is already preserved per-function; the rewrite pass runs
  *after* that capture and *before* `gencode()`, so it doesn't
  observe or affect pragma state.
- **"`running_delta` is still state — you just moved it from emit time
  to rewrite time."** Correct — but it's transient, single-pass,
  compile-time state, not emit-time state read by a template. Once the
  pass returns, the IR is pure: every ADD has its final literal
  constant baked in. This is the same class of state that any
  dataflow pass (constant propagation, copy propagation, etc.) uses,
  and it's isolated to one function in one pass.
- **"What if the front-end folds `ADDI(VREG(p1), CNST(0))`?"** Then
  we see `ARG(VREG(p1))` directly and the rewrite does nothing —
  which is the correct behavior (p1 is already in r4).
- **"What if `askregvar(p1, ireg[4])` fails because r4 is already
  bound to something?"** Phase D confirmed it succeeds for
  FUN_06044060. The guard `sh_ipa_all_callees_preserve_r4` +
  `ncalls > 0` is the entry criterion; on failure we fall back to
  today's behavior. Check is cheap and conservative.
- **"If the synthesized ASGN triggers `rtarget` on an already-
  registered VREG, does that duplicate work?"** `rtarget` on a VREG
  kid whose `syms[RX]` already matches the target is a no-op (gen.c:484
  guards on `r != q->syms[RX]`). Same as for manually-written register
  vars.

## 10. What's explicitly out of scope

- Generalization to r5/r6/r7 pins. Scalar r4 first.
- Multiple simultaneous pins (p1 to r4 AND p2 to r5). One pin per
  function.
- Multi-return function restore. Single-return first; fall back to "no
  restore" for multi-return until a corpus case forces it.
- Inferring IPA facts for extern callees. Phase C's conservative
  default stays.
- Re-designing Phase A–D. Fixed infrastructure.

## Where A wins

An honest accounting — things A does better than B, and why I still
prefer B:

1. **A's failure if the rewrite goes wrong is more localized.** B's
   DAG rewrite synthesizes new Code list nodes; a bug in B's splicing
   corrupts the linked list and could crash `gencode()` with a
   confusing null-pointer trace far from the rewrite. A's bug shows up
   as an allocator assertion, which at least fires at a known line in
   gen.c. *Why I still prefer B:* the splicing is ~30 lines; a Code
   list is a doubly linked list, not magic; any corruption surfaces
   immediately on the first validate_build. Meanwhile A's `vbl`-clear
   guard is a semantic change that might subtly miscompile code that
   *compiles fine* and produces wrong output, which is a much worse
   failure mode to diagnose.

2. **A's per-node `vbl_mutate` bit is more expressive.** If in the
   future we want "mutate a vbl-bound register" for reasons other than
   IPA (e.g. a hypothetical future optimization that does arithmetic
   in place on a callee-saved register), A's bit generalizes cleanly;
   B's rewrite pass is IPA-specific. *Why I still prefer B:* we don't
   have that future use case. YAGNI. If one appears, we can add that
   generality then. The cost of building for an unknown future is a
   permanent bit-per-Xnode across all backends.

3. **A keeps the transformation local to the node being processed.**
   B's pass walks the whole Code list and reasons globally. A's
   decisions are made at `target()` time per-node. For very large
   functions, B's pass is O(statements × args) while A is O(1) per
   node. *Why I still prefer B:* FUN_06044060 has 5 CALLs and ~20
   statements. Even if we do this on every IPA-cleared function in
   the whole Daytona corpus, it's microseconds of compile time. Not a
   real cost.

4. **A's restore peephole re-uses the existing peephole infrastructure.**
   B's IR synthesis is a new kind of thing (sh.md has no precedent for
   *creating* Code list statements post-parse — `genspill` is the only
   example, and it runs inside ralloc). The peephole layer is
   well-trodden territory; adding another pattern to it is lower-risk
   in a familiar way. *Why I still prefer B:* `genspill` (gen.c:773)
   is exactly the pattern B uses — synthesize an ASGN, linearize it
   into the Code list, let ralloc process it. It's not new territory;
   it's the allocator's own mechanism turned to a new purpose.
   Meanwhile A's peephole is a new heuristic with liveness detection
   built by hand ("walk the emitted instruction list from the last
   CALL forward...") — that's the new-kind-of-thing in A, not in B.

5. **A has an incremental fallback path.** If hour 6 in A fails, A
   ships the pin + clobber narrowing alone, landing 12 of 15 lines
   and deferring the restore. B is more monolithic — either the
   rewrite pass works end-to-end or it doesn't. *Why I still prefer
   B:* B also has a fallback. If the restore synthesis is buggy, skip
   emitting it; land the rewrite-only portion. That collapses the
   first ~12 lines the same way. The "all or nothing" framing is
   wrong.

### The summary judgment

A treats the shared allocator as a fixed structure to patch around.
B treats the shared allocator as a correct black box and reshapes the
input to something it already handles. A's cost is distributed
(shared-header bit, shared-allocator guard, shared-allocator
invariant weakening) and permanent. B's cost is concentrated (one
rewrite pass in sh.md) and reversible. For a project whose primary
thesis is that our compiler will teach us about SHC's rules through
byte-match regressions over time, avoiding permanent widening of the
shared-code surface is worth one day's worth of rewrite-pass
construction.

End of design.
