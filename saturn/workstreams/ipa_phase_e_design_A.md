# IPA Phase E design (A): in-place mutation of a vbl-pinned arg register

## Position in one paragraph

Pin p1 to r4 at param-homing when `sh_ipa_all_callees_preserve_r4()`
is true (as Phase D already wants to). Teach the shared allocator
about one new concept — a **"vbl-mutating ARG kid"** — expressed as
a single new `Xnode` bit (`x.vbl_mutate`) set by the SH backend's
`target()` hook and honored in exactly two places inside `gen.c`
(`ralloc` and `spillee`). All three capabilities (in-place mutation,
cross-call liveness, restore emission) fall out of one invariant:
**while the bit is set on a kid of an ARG whose rtarget is the same
register the vbl currently occupies, the allocator must neither spill
the vbl nor clear its `vbl` binding, and must return that register
from `getreg`.** The restore (`add #-48,r4`) is then an sh.md peephole
that runs post-emit, keyed off the same per-function "p1 pinned to
r4" fact. The other five backends never see the bit set (their
`target()` hooks don't set it) and their behavior is bit-identical.

The strategy collapses FUN_06044060's cluster in one session because
every piece is load-bearing: remove the pin and the ADDs move to r8;
remove the mutate bit and we assert; remove the restore peephole and
we're short `add #-48,r4`. Nothing is speculative.

## 1. Data model

### 1a. New Xnode bit (config.h)

Add one bit to the `Xnode` struct in `src/config.h`:

```
unsigned vbl_mutate:1;   /* ARG kid that mutates a vbl-pinned reg in place */
```

This is the one cross-backend change. It costs one bit per node in
every backend's compilation, which is already fine — `Xnode` has
seven `unsigned:1` fields today; an eighth packs into the same word.

**Semantics.** `p->x.vbl_mutate == 1` means: "this node is an ADD /
SUB / arithmetic op whose result is feeding an ARG, whose left kid
is a VREG for a symbol `s` currently bound (`s->x.regnode->vbl == s`)
to the same hard register the ARG is rtargeted to, and the backend
asserts that mutating that register in place is the intended codegen
— the vbl's original value is not required after the CALL chain."
Only the SH backend ever sets it (see section 2). Default zero keeps
the other five backends on their existing path.

### 1b. Per-function sh.md state

`struct sh_ipa_fn` (already present, sh.md ~line 142) gains:

```
Symbol   vbl_pinned_sym;      /* the Symbol ralloc-pinned to r4, or NULL */
int      vbl_pinned_regno;    /* 4 for r4 (leaves room to generalize) */
int      vbl_pinned_delta;    /* net signed byte offset applied in-place */
int      vbl_pinned_needs_restore; /* 1 iff symbol is live after last call */
```

Populated during parse in the enhanced param-homing block (section 5);
consumed by the post-emit restore peephole (section 4). Zero by default
— the common case where IPA is not firing is unchanged.

### 1c. Symbol.x, Regnode: no changes

The existing `x.regnode->vbl` field is the entire cross-call liveness
story. We do not add a parallel "ipa-preserved" flag on Regnode —
that would force every backend to reason about it. The existing
vbl-bound semantics are exactly what we want (the register is not
in freemask, so arbitrary allocation won't steal it); we just need
the allocator to stop *resisting* that binding at the two points
where it currently does (section 2).

## 2. Allocator integration (gen.c)

### 2a. Setting the bit: sh.md `target(Node)`

When `target()` sees `ARG+I` with `argno == 0`, it already calls
`rtarget(p, 0, argreg(0))`. Add a check:

```
if p->kids[0] is ADDI/SUBI/ADDP/SUBP
   whose left kid is VREG+I/P referring to symbol s
   where s->x.regnode && s->x.regnode->vbl == s
   where s->x.regnode->number == 4  (i.e. r4)
   where argreg(p->x.argno) == ireg[4]
then mark p->kids[0]->x.vbl_mutate = 1
     and accumulate the signed constant kid into
         sh_ipa_current->vbl_pinned_delta
```

Only a VREG + CNST pattern qualifies (match the exact shape prod
uses). Anything else falls through the bit-unset path. The backend
is the right place for this decision — it knows which ops are
"mutate in place" (ADDI with CNST kid → `add #imm, Rn`) and which
need a distinct destination register.

### 2b. `ralloc` — respecting the bit (gen.c ~633)

`ralloc` today walks `p->x.kids[]` and, for each kid whose symbol's
`lastuse == kid`, calls `putreg(r)` to free it. That is the first
hazard: for our ADD kid, the left grandkid is the VREG load; its
`lastuse == p` (the ADD) releases r4 back to freemask — but the
binding `r4->vbl == p1_sym` persists. If the next use is not us,
this would normally be fine. For the vbl-mutate path we want the
same freemask release (so `askreg` can hand r4 to the ADD as its
destination) but **without** clearing `regnode->vbl`.

Good news: `putreg` already doesn't clear `vbl`. It only twiddles
freemask. So the existing flow is almost right; the failure is
further down in `getreg → spillee`.

Small `ralloc` addition: after the parent is `ralloc`'d, if any
child carried `x.vbl_mutate`, the register it landed in must have
its `vbl` binding preserved across the CALL. The allocator-visible
action is: **do not** execute `r->x.regnode->vbl = NULL` at gen.c:595
when the selected register is the pinned one. This is the key fix:

```c
/* in getreg(), replace unconditional vbl = NULL with: */
if (!(p && p->x.vbl_mutate
      && r->x.regnode->vbl
      && r->x.regnode->vbl->x.regnode == r->x.regnode))
    r->x.regnode->vbl = NULL;
```

In English: only nuke the vbl binding if we are *not* in a
vbl-mutate handoff. In the vbl-mutate case, the symbol keeps the
binding; the register keeps its "belongs to p1" flag through the
subsequent CALL's `clobber`.

### 2c. `spillee` — the assertion at gen.c:736

The assert is correct for general spilling. For our case we never
hit `spillee` at all, because:

1. `ralloc` releases r4 back to freemask via `putreg` on the kid
   whose `lastuse == kid` (this was already true pre-Phase D — our
   assertion crash was under a *different* flow where `askfixedreg`
   returned NULL because p1 was still live).
2. With the vbl-mutate kid marked, we add one early check in
   `askreg` / `askfixedreg`: if the requested specific register is
   the one currently vbl-bound to a kid annotated `vbl_mutate`,
   hand it back *without* going through freemask masking:

```c
/* in getreg, before the spillee fallback: */
if (r == NULL && set->sclass == REGISTER /* specific reg */
    && set->x.regnode->vbl
    && any_kid_with_vbl_mutate_on_this_regnode(p, set->x.regnode))
    return set;   /* reuse the vbl'd register */
```

This is narrower than relaxing the `spillee` assert: we short-circuit
before ever calling `spillee`. The assert stays intact for every
other backend and every other code path in the SH backend. In the
one case it fired historically (Phase D's crash), we don't reach it.

### 2d. `spillr` — unchanged

No changes. Spilling a vbl across blocks is still forbidden; we just
never ask to spill the vbl when the mutate bit is set.

### 2e. `askregvar` — unchanged

sh.md already calls `askregvar(p1, ireg[4])` at line 6494. With the
above changes, that call succeeds and stays in effect through the
function.

### 2f. Worked control-flow trace

Tree at first CALL: `CALL(CNSTP_addr), ARG(ADDI(VREG(p1), CNST(48)))`.

1. `prelabel` marks ARG, calls `target(ARG)`. sh.md's target sees
   `argreg(0) == ireg[4]`, vbl-bound to p1 at r4, left-grandkid is
   VREG(p1). Sets `ADD->x.vbl_mutate = 1`, calls `rtarget(ARG, 0, ireg[4])`.
2. `gen` linearizes; `ralloc` hits VREG(p1). VREG nodes are
   pre-`registered`; `ralloc` is a no-op for them.
3. `ralloc` hits CNST(48). Normal allocation to a temp reg (pool
   load handled separately; CNST fits #imm so no reg needed).
4. `ralloc` hits ADD. Parent's rtarget is ireg[4] via ARG. `set ==
   ireg[4]`; `askreg` calls `askfixedreg(ireg[4])` which fails
   because r4 is not in freemask (vbl-bound to p1). **Patched path:**
   `getreg` sees `p->x.vbl_mutate` and that ireg[4] is vbl-bound to
   p1's symbol whose regnode *is* ireg[4]->regnode — returns ireg[4]
   directly, skipping `spillee`. Crucially, the `vbl = NULL` line is
   skipped (section 2b), so r4 stays vbl-bound.
5. ADD emits as `add #48, r4`. Kid VREG(p1) is the same reg —
   `?mov` template elides the move.
6. `ralloc` hits ARG. Its kid is already in r4; ARG is a no-op.
7. `ralloc` hits CALL. `clobber(CALL)` spills INTTMP — but INTTMP
   masks off r0..r3 only in the SH backend (see sh.md line 1738:
   `spill(INTTMP & ~INTRET, IREG, p)`). r4 is in the argreg band;
   sh.md's INTTMP definition controls whether the clobber evicts it.
   See section 3 for the exact mask check.
8. After CALL, r4 is still vbl-bound to p1 with value p1+0x30.
   Next CALL's ARG sees VREG(p1) already in r4 with `vbl_mutate`
   not set on this sub-tree (because the delta is zero — see 3a).

## 3. Cross-call liveness

### 3a. The INTTMP mask and clobber

SH's `clobber` already does `spill(INTTMP & ~INTRET, IREG, p)`. The
critical question: does INTTMP's bitmask include r4..r7?

Check `ireg[]` / INTTMP definition in sh.md. If INTTMP already
excludes the arg band (r4..r7 live in INTVAR-adjacent storage or an
ARGREGS class), we are done — the CALL's clobber doesn't touch r4.

If it does not exclude r4..r7, we narrow `clobber` with one line:

```c
if (sh_ipa_current && sh_ipa_current->vbl_pinned_sym)
    spill_mask &= ~(1u << sh_ipa_current->vbl_pinned_regno);
spill(spill_mask, IREG, p);
```

This is the Phase D hook we already have; it stays in sh.md, not
gen.c. Because the `vbl` binding survives (section 2b), and the
clobber no longer spills r4 when the pin is active, `spill()` never
calls `spillr` on r4. Natural liveness carries r4 across all five
CALLs.

### 3b. Subsequent ARG(p1) references don't re-emit add #48

After the first CALL, the p1 symbol's value in the source is
logically still "p1 original." If the second CALL's arg is also
`p1 + 0x30`, the front end emits `ARG(ADDI(VREG(p1), 48))` again.
Our `target()` hook sees the mutate bit situation again — but now
r4's content is already p1+0x30, not p1. Re-emitting `add #48` would
produce p1+0x60.

Resolution: the per-function state tracks the current **net delta**
applied in-place (`vbl_pinned_delta`). When target() encounters a
second ARG(ADD(VREG(p1), K)), it compares K against the current
delta:

- If K == current delta, the ADD is a no-op; we mark the ADD with a
  new sibling bit `x.vbl_mutate_elide` (or reuse `vbl_mutate` plus a
  second per-node delta field; cheaper to reuse — see below) and the
  emit template prints nothing. ARG falls through — kid already in r4.
- If K != current delta, we emit `add #(K - delta), r4` and update
  `vbl_pinned_delta = K`.

Cleanest implementation: store the delta on the ADD node itself. We
don't want another Xnode field; encode it by leaving `vbl_mutate`
set and letting sh.md's emit template consult
`sh_ipa_current->vbl_pinned_delta` at emit time to compute the
printed immediate. The emit template for the mutate ADD is written
by sh.md and runs in sh.md; no gen.c change is needed for this
bookkeeping.

### 3c. What the five CALLs actually see

Because r4 stays vbl-bound across CALLs 1..5, and
`sh_ipa_current->vbl_pinned_delta` tracks what's in it, CALLs 2..5
whose arg is also p1+0x30 fire through the elide path — no extra
ADD. Prod byte-matches this exact sequence.

## 4. Restore emission (`add #-48, r4`)

### 4a. Peephole, not IR

The restore is not a C-level operation. The C source probably has
`return;` or nothing touching p1 after the last call. Making it an
IR node would require synthesizing an ADD in `gencode` that the
front end never produced — a layering violation.

Instead, sh.md adds a post-emit peephole over the captured Code
list for this function, run after the existing peephole passes:

```
if sh_ipa_current->vbl_pinned_sym != NULL
   and sh_ipa_current->vbl_pinned_delta != 0
   and the symbol is live-out of the last CALL
       (i.e. referenced after the last CALL in the emitted stream,
        or the function is expected to return p1 unmodified — see 4b)
then emit `add #(-delta), r4` immediately after the last CALL
     (or in the last CALL's delay slot if vacant — matches prod)
```

### 4b. "Live-out of last CALL"

Detector: walk the emitted instruction list from the last CALL
forward; if any instruction reads r4 (mov.l @r4, mov r4,rX, add
#k,r4 with the intent of using p1, etc.) before the next write to
r4, we need the restore. If r4 is dead (function returns, next insn
is epilogue), skip the restore entirely.

Prod for FUN_06044060 emits the restore in the last CALL's delay
slot (`mov.l @r5,r5 ; add #-48,r4`). That's a variant of the same
rule: the delay slot happens *during* the call, so after the call
returns r4 is p1-original. Our delay-slot filler already handles
"move a safe insn into the vacant slot"; adding the restore to its
candidate list when the pin is active is a three-line change.

### 4c. If p1 is dead after last call

Skip the restore. Prod likely does the same — check against another
corpus function where p1 goes out of scope before return. For
FUN_06044060 specifically, p1 is dead-ish (no post-call reads) but
prod emits the restore anyway. Safe default: emit the restore;
worst case it's one redundant insn, but byte-match drives the
decision.

## 5. Backend isolation

### 5a. What changes in gen.c

Exactly two touch points:

1. `getreg` (gen.c:586–597): two added lines — the vbl-mutate
   short-circuit before `spillee`, and the `vbl = NULL` guard.
2. `config.h`: one added `unsigned:1` field on Xnode.

Neither changes behavior when `p->x.vbl_mutate == 0`. All five other
backends' `target()` hooks don't set the bit; their nodes always
read `x.vbl_mutate == 0`; the new `if` branches both take the old
path. Zero behavior change.

### 5b. What changes in sh.md

1. `target()`: detect ARG+I/P/U with argno==0 whose kid is the
   mutate pattern; set `x.vbl_mutate`; record delta in
   `sh_ipa_current`.
2. `clobber()`: mask out the pinned reg bit when pin active.
3. `sh_ipa_fn`: the four new fields.
4. Param-homing (sh.md:6463 area): call `askregvar(p1, ireg[4])`
   when `sh_ipa_all_callees_preserve_r4(e)` is true, storing
   `vbl_pinned_sym = p1_sym` on the queue entry.
5. Post-emit peephole pass: the restore detector.

Five localized changes. The IPA analysis infrastructure
(Phases A–D) is untouched.

### 5c. Validation

`wsl bash saturn/tools/validate_build.sh` gates every iteration.
Every byte-matched function in the current stable set must continue
to match; FUN_06044060's diff drops from ~21 to ≤6.

## 6. Failure modes

### 6a. IPA predicate wrong (callee secretly writes r4)

`sh_ipa_all_callees_preserve_r4` is conservative on externs
(Phase C sets `writes_r4=1` for any callee not in the TU). Within
the TU the analysis walks the real DAG. The only way the predicate
is wrong is if a callee writes r4 via an `__asm` intrinsic the
writes_r4 analysis doesn't track. Mitigation: extend
`sh_analyze_writes_r4` to scan for `__asm` strings mentioning `r4`
as a destination — one-hour addition, not in critical path.

If it's still wrong, byte-match fails immediately and loudly: the
caller's emitted sequence diverges from prod, and the diff gated
regression test flags it.

### 6b. The pin causes spill elsewhere in the function

If register pressure inside FUN_06044060 is so high that losing r4
from the general pool triggers stack spills elsewhere, we'd see new
spill moves in the output. The existing non-IPA path (promote p1 to
INTVAR) would have been better. Detector: any `mov rX, @-r15` in a
function where none existed before. Validator: validate_build.sh
catches the regression on other functions; for FUN_06044060 itself
the diff tells us.

Kill-switch: `sh_ipa_all_callees_preserve_r4` returning 0 disables
everything. If a specific function hits this failure mode, a
per-function pragma `#pragma no_ipa_pin(FUN_...)` flips the
predicate off — three-line addition using the existing
`sh_func_has_attr` plumbing.

### 6c. The restore peephole misfires

Two bad outcomes: emits a restore when r4 is dead (one redundant
insn, byte-match-visible); misses a restore when r4 is live (wrong
code). The second is the dangerous one. Guard: the detector's
default is "emit the restore" when in doubt. A false positive
shows up as a diff; a false negative shows up as wrong code and
would be caught by the existing NOP-test loop for any function
we're exercising.

### 6d. Second-order vbl-mutate on a different arg

If a future function has both p1 pinned to r4 AND p2 pinned to r5
with both mutating, the `vbl_pinned_*` fields become per-regno,
not scalar. Scoping note: we ship the scalar version (r4 only) for
FUN_06044060 and generalize later. The per-function struct fields
already hint at this via `vbl_pinned_regno`, but only one slot is
implemented.

## 7. Rejected alternatives

### 7a. Relax the spillee assertion and let genspill run

Obvious reader's first instinct: remove the assert, let
`spill → spillr → genspill` emit a stack save of p1 and a reload
after each CALL. This gives *worse* output than today's stash-to-r8
behavior — we'd emit five reloads where today we emit one. The
stack spill is also in a different section of the frame than prod
uses, so even if byte-match were the goal we'd diverge. Rejected
because it solves the wrong problem: we don't want p1 anywhere
except r4.

### 7b. Post-emit peephole over the whole pattern (A4 from ipa_design)

The original doc's recommended-first-cut was S1+A4+G1: compile
normally (stash to r8), then post-emit-rewrite the stash into an
in-place mutation. Problem: the stash-to-r8 path in today's
allocator *consumes* r8, cascading the other stashes to r9/r10/r11
(the off-by-one visible in the current diff). Undoing the cascade
requires reasoning about which other values could go back to r8,
which is register allocation in disguise — and if we're doing
register allocation we should do it in the allocator, where it's
correct by construction. Rejected because a peephole that re-does
allocation is a worse allocator wearing a different hat.

### 7c. A new Xinterface callback (A5 from ipa_design)

Adding `(*vbl_mutate_ok)(Node, Symbol)` to Xinterface is cleaner in
one sense (no new Xnode bit) but worse in another: the allocator
would call the hook from inside `getreg`, meaning every allocation
in every backend pays a NULL-check cost. More importantly, the
decision "this node is a vbl-mutate" is made at `target()` time,
hundreds of lines upstream of `getreg`. Re-deriving it at the
allocation site duplicates logic. A bit on the node carries the
decision forward cheaply. Rejected for separation-of-layers.

### 7d. Per-callsite clobber narrowing only (A2, no pin)

If we only narrow `clobber` (don't change param-homing), the
allocator is free to place p1 wherever it wants. It will choose
r8 (as today) because that's what INTVAR priority says. Narrowing
the clobber has no effect when p1 isn't in an arg-band register in
the first place. Rejected because it treats the symptom (CALL
clobbers r4) without fixing the cause (p1 was never in r4 to
begin with).

## 8. Scope for one session

- Day-0 hour 1: Xnode bit in config.h, build all five backends to
  confirm no behavior change (they should all still pass their
  smoke tests).
- Hour 2: `target()` mutate detection + the per-function pin fields.
- Hour 3: `getreg` short-circuit + `vbl = NULL` guard.
- Hour 4: param-homing re-enable, delta tracking in emit.
- Hour 5: restore peephole + delay-slot filler integration.
- Hour 6: validate_build.sh loop; chase remaining diff on
  FUN_06044060 from ~21 to target ≤6.

If hour 6 shows byte-match is not reached and the residual is
stash-order / off-by-one of some other register (not r4/p1), cut
the restore peephole and ship the pin + clobber narrowing alone.
That lands 12 of the 15 cluster lines and defers the `add #-48, r4`
to a later session without blocking the rest of the IPA story.

If hour 6 shows a regression on a different byte-matched function,
the per-function kill-switch pragma (section 6b) holds it off
FUN_06044060 only until diagnosis.

## 9. What a hostile reviewer will probe

- **"The bit leaks to other backends."** It doesn't — only sh.md's
  `target()` ever sets it; other backends' target hooks don't
  mention it. The gen.c code that reads it is dominated by the
  `p->x.vbl_mutate` guard, which defaults false.
- **"You're reading sh_ipa_current from a generic emit template."**
  Accepted: sh.md already does this for other per-function pragma
  state (gbr_param, word_indexed_after_first). Adding three more
  fields is consistent.
- **"The restore peephole is heuristic."** Yes. The byte-match
  oracle constrains it. If a corpus function exposes a case the
  heuristic misses, that function teaches us the rule; we
  encode it.
- **"Delta tracking across CALLs breaks if a CALL's body
  *temporarily* writes r4 then restores."** The predicate
  `sh_ipa_all_callees_preserve_r4` asserts callees don't write
  r4 *at all*, not "net-preserve." Phase C's analysis is "does
  anything transitively write r4"; transient writes count. Safe.
- **"What if the user's C code actually needs p1's original value
  after the last call?"** Then the restore peephole emits
  `add #-48,r4` and the subsequent read finds the right value.
  This is the prod pattern.
- **"The `vbl = NULL` line in getreg exists for a reason."** Yes —
  it's the point where a wildcard allocation finalizes binding from
  "this register could go to anyone" to "this register is now this
  node's." Our guard fires only when the incoming register *already*
  has a vbl and the current node opted into mutating it; in that
  case the finalize-binding semantic is already done. We're not
  clearing a flag that should be set; we're preserving a flag that
  a stale unconditional clear would wrongly wipe.

## 10. What's explicitly out of scope

- Generalization to r5/r6/r7 pins (G2). Scalar r4 first.
- Multiple simultaneous pins. One pin per function.
- Inferring IPA facts for extern callees. Phase C's conservative
  default (externs write r4) stays.
- Re-designing Phase A–D. Fixed infrastructure.
- Changing drain order. A.1 source-order drain stays.

End of design.
