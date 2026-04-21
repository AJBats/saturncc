# IPA design — interprocedural register preservation

Design discussion doc for adding interprocedural analysis (IPA) to
the SH-2 backend, specifically to model per-callee register
preservation guarantees that go beyond standard SH-2 ABI.

**Status:** problem statement only. No implementation. Awaiting
design discussion before any code is written.

## Handoff protocol for fresh sessions

If you are picking this up in a new session, do these four things
in order before writing any code:

1. **Read this doc end to end** — the problem statement, the three
   axes of design space, and the open questions at the bottom.
2. **Read the linked toolkit context** — recent commits and the
   workstream docs listed under "Context for fresh sessions"
   below. You need to know what infrastructure already exists
   (save-default inversion, `__asm` intrinsic, normalizer folds,
   r0 allocator heuristic) before proposing an IPA mechanism that
   sits on top of it.
3. **Read the auto-memory entries**, especially
   `feedback_byte_matched_functions_are_the_oracle.md`. The
   strategic framing — that each byte-matched function becomes a
   teaching surface via future regressions — is why the IPA work
   matters beyond #001.
4. **Discuss the design choices with the user BEFORE writing
   code.** The source axis (S1–S5), allocator axis (A1–A5), and
   granularity axis (G1–G3) are deliberately left open. The doc's
   "Recommended next steps" gives one viable starting point
   (S1+A4+G1) but that is a suggestion, not a decision. The user
   wants the axis choices resolved in conversation before any
   implementation work begins.

## The concrete problem (#001's class C residual)

After Phase 1 (save-default inversion), Phase 2 (`__asm` intrinsic),
and the r0-allocator work, FUN_06044060 sits at 21 diff lines vs
prod. Of those, ~15 lines are in a single behavioral cluster:

**Prod's pattern:**
```
mov r5,r8     ; stash p2 to r8 (callee-saved)
mov r6,r9     ; stash p3 to r9
mov r7,r10    ; stash p4 to r10
mov.l LP0,r0  ; first call: FUN_06044D80
jsr   @r0
add   #48,r4  ; r4 = p1 + 0x30 (in delay slot — and r4 STAYS this way)
... 4 more calls ...
mov.l LP6,r5  ; setup arg2 for last call
mov.l LP7,r3
jsr   @r3
mov.l @r5,r5  ; delay slot
add   #-48,r4 ; restore r4 to original p1 (preserved through all 5 calls!)
```

**Our pattern (post-Phase-2):**
```
mov r5,r9     ; stash p2 to r9 (off-by-one)
mov r6,r10    ; stash p3 to r10
mov r7,r11    ; stash p4 to r11
mov.l LP0,r3  ; first call: FUN_06044D80
jsr   @r3
add   #48,r4  ; r4 = p1 + 0x30 (delay slot)
... 4 more calls ...
mov r8,r4     ; reconstruct p1 from r8 stash    <-- 2 extra
add #48,r4    ;                                 <-- 2 extra
mov.l LP6,r5
mov.l LP7,r3
jsr   @r3
mov.l @r5,r5
              ; (no add #-48,r4 — we don't preserve r4)
```

**Why prod can do this:** SHC has interprocedural knowledge that
all five callees (FUN_06044D80, FUN_06044F30, FUN_06044E3C,
FUN_060450F2, FUN_06045006) preserve r4 across their bodies. This
is *beyond* the standard SH-2 ABI (which says r4 is caller-saved /
clobberable). SHC observes the actual callees' bodies, sees they
don't write r4, and assumes that fact when compiling FUN_06044060.

**Why our compiler can't:** lcc's allocator treats every CALL as
clobbering all of r0..r7 (per the standard ABI). With no per-callsite
clobber knowledge, lcc must promote any value living across a call
to a callee-saved reg (r8..r14). That's why p1 gets stashed to r8
(then r9 because of off-by-one cascade), driving the entire 15-line
diff cluster.

## Why this matters as arsenal

Per the [byte-matched-functions-are-the-oracle][oracle] principle,
each new byte-matched function is a teaching surface that reveals
SHC's rules through future regressions. Closing the IPA gap on #001
gives us the FIRST function that demonstrates the IPA mechanism
works. Other functions in the corpus likely have similar IPA
patterns we haven't surfaced yet — without a working IPA mechanism,
those gaps are invisible (they look like "weird leftover diff" not
"specific IPA fact").

This is also categorically different from the patterns we've already
encoded (save-default, allocator priority, scratch-vs-persistent).
IPA is a new dimension of SHC behavior. Adding it expands what kinds
of byte-match wins are reachable across the whole corpus.

[oracle]: ../../C:/Users/albat/.claude/projects/d--Projects-saturncc/memory/feedback_byte_matched_functions_are_the_oracle.md

## The design space

There are at least two orthogonal axes: **how IPA facts are sourced**
and **how the allocator uses those facts**.

### Axis 1: Source of IPA facts

**S1: Per-callee pragma (back-of-book).**
```c
#pragma preserves_r4(FUN_06044D80, FUN_06044F30, FUN_06044E3C, ...)
```
User declares per-callee what each preserves beyond ABI. The
compiler trusts the declaration; correctness comes from byte-match
verification (if the pragma is wrong, output diverges from prod).

- Pros: simple to implement; granular; matches "Ron Swanson + back-
  of-book" framing already established in the project
- Cons: needs to be declared everywhere; can't easily cover the
  whole corpus by hand

**S2: Per-caller pragma (opt-in trust).**
```c
#pragma keep_p1_in_r4(FUN_06044060)
```
User declares for each *caller* function that its body's calls all
preserve r4. Implicitly trusting that all callees do the right thing.

- Pros: simpler annotation surface (one pragma per affected caller)
- Cons: less granular; weaker correctness story; "trust me" without
  the per-callee evidence

**S3: Combined.** Both pragmas required: per-callee declares the
fact, per-caller opts into using the fact for that function.

- Pros: explicit on both sides; correctness traceable
- Cons: more pragmas; more bookkeeping

**S4: Inferred (real IPA).** Walk callee bodies; determine
preserved-register set automatically. No pragmas.

- Pros: zero manual annotation; principled
- Cons: requires call-graph analysis; many edge cases (recursion,
  function pointers, calls to externs); significant compiler work

**S5: Per-callsite pragma.**
```c
__pragma_preserves_r4 FUN_06044D80(arg);
```
Annotate individual call sites. Most surgical but most invasive
to the source.

- Pros: maximally precise
- Cons: noisy in source; hard to express in C syntax cleanly

### Axis 2: Allocator integration

**A1: Bind p1 to r4 explicitly at param homing.**
At `function()` time, instead of promoting p1 to a callee-saved
wildcard, call `askregvar(p, ireg[4])`. p1 stays in r4 throughout.

- Pros: surgical; uses existing askregvar mechanism
- Cons: bypasses lcc's natural lifetime analysis; we must separately
  ensure r4 isn't spilled across calls

**A2: Per-callsite clobber narrowing.**
The `clobber()` callback at each CALL is currently global ("spill
all caller-saved temps"). Modify to consult callee preservation
data: `spill((INTTMP|INTRET) & ~callee_preserves(callee), IREG, p)`.
Then lcc's natural lifetime tracking keeps the value in r4 because
no clobbering call requires it to move.

- Pros: principled; works with lcc's allocator natively
- Cons: requires looking up callee identity from the CALL node's
  function-pointer kid (sometimes ADDRG, sometimes pool load)

**A3: Both A1 and A2 together.**
Param-homing forces p1 to r4 (overrides default promotion); clobber
narrowing keeps it from being spilled.

- Pros: most explicit; both decisions traceable
- Cons: two coordinated mechanisms

**A4: Post-emit peephole rewrite.**
Compile normally (with stash/reconstruct), then rewrite the output:
detect "stash p1 to rN at entry, reconstruct rN→r4 before last call,
no other r4 use" and rewrite to keep p1 in r4 throughout.

- Pros: doesn't touch lcc allocator at all; entirely in our peephole
  layer; matches the "back-of-book peephole" patterns we've already
  built
- Cons: very pattern-specific; brittle for variations; hard to
  generalise across functions

**A5: A new IR-level annotation on CALL nodes.**
Add an x.preserves_mask field to Xnode. Set it during target() based
on callee identity + IPA pragmas. The clobber callback reads it.

- Pros: clean data flow; lifetime-aware allocator can use it
- Cons: requires upstream gen.c changes (not just sh.md)

### Axis 3: Granularity

**G1: r4 only.** Specific to the case we've observed in #001.
- Pros: simplest; minimal surface
- Cons: misses other arg regs (r5/r6/r7 might also be preserved
  for some callees)

**G2: Any caller-saved (r0-r7) per-register.** General mask
- Pros: matches reality (SHC tracks per-register)
- Cons: more complex pragma syntax

**G3: All-or-nothing per-callee.** Either a callee preserves all
caller-saved or none.
- Pros: simpler model
- Cons: too coarse — most callees preserve some but not all

## Open questions for design discussion

1. **Source axis:** S1, S2, S3, S4, or S5?
   - My initial sketch was S3 (combined per-callee + per-caller)
   - S4 is "real" IPA but multi-week effort
   - S1 alone might be enough if the allocator can aggregate
     facts across callsites

2. **Allocator axis:** A1, A2, A3, A4, or A5?
   - A1 + A2 (= A3) was where I was heading
   - A4 (peephole rewrite) is interesting because it doesn't touch
     lcc internals — might be the lowest-risk first cut
   - A5 is the cleanest but most code

3. **Granularity:** G1, G2, or G3?
   - G2 is correct but more work
   - G1 might be enough as a first cut

4. **Where do the IPA facts come from?**
   - Pragmas (manual declaration, back-of-book): possible today
   - Inference (real IPA): possible but expensive
   - Hybrid: pragmas as primary, with a tool to *generate* the
     pragma list by analyzing prod's binaries

5. **How do we verify our IPA assertions are correct?**
   - Byte-match acts as the oracle: if our IPA pragma is wrong,
     output diverges from prod. So byte-match IS the verifier.
   - But this only works for functions we're trying to byte-match.
     For untested functions, an incorrect IPA assertion silently
     produces wrong code.

6. **Scope creep watch:** what's the SMALLEST thing we can build
   that closes #001's class C cluster? That's the actual goal.
   Anything beyond that is arsenal-extension, fine to defer.

## Recommended next steps for the design session

1. **Pick a source/allocator/granularity combination.** Recommend
   starting with S1 + A4 + G1: per-callee pragma, peephole rewrite,
   r4-only. Lowest blast radius; entirely contained in sh.md;
   doesn't touch lcc upstream code.

2. **Sketch the peephole pattern.** What does it look for, what does
   it rewrite to, what are the edge cases?

3. **Pre-validate against #001.** Write the expected output by hand
   first; verify that's what prod produces; then implement.

4. **Define what "done" looks like.** A specific diff target on
   FUN_06044060 (e.g., "21 → ≤6") and a specific test that no other
   byte-matched function regresses.

## Context for fresh sessions

This doc was written as a checkpoint between sessions. The previous
session built up significant infrastructure that the IPA work will
sit on top of:

- **Phase 1**: save-default inversion + new `prealloc_mask` IR hook
- **Phase 2**: `__asm("...")` intrinsic for per-site fixes
- **Normalizer folds**: pool-format and zero-byte padding equivalence
- **r0 allocator heuristic**: lifetime-aware r0 preference

Read these to understand the available toolkit:
- [save_strategy_and_asm_intrinsic.md](save_strategy_and_asm_intrinsic.md)
- [gap_catalog.md](gap_catalog.md) — Gap 1C entry
- Recent commits: `9dfec64`, `db49db0`, `638edfc`, `99497b8`

The "byte-matched functions are the oracle" project framing is
captured in the auto-memory file
`feedback_byte_matched_functions_are_the_oracle.md` and is the
strategic principle this IPA work serves.

## Architectural pivot after B.1: analysis, not drain reordering

Phase B.1 landed the Tarjan SCC infrastructure as committed dead code.
The original plan was to switch the drain loop to reverse-topological
order so each function was emitted after its callees — but activating
that exposed 28 small shifts in unmatched functions. Root cause: LCC's
per-function globals (shlits lookups that don't check is_word, plus
undetermined others) only accidentally behaved correctly under source
order; reordering surfaced latent asymmetries.

Rather than chase every latent state leak, the design pivots to:

**Pre-pass analysis. Source-order drain unchanged.**

At drain time we run a new reverse-topological analytical pass that
answers, for every captured function, "which hard registers does your
body write?" That pass stores the write-set on the function's Symbol
(or the queue entry) and touches nothing else. The main source-order
drain then emits each function unchanged — except at CALL sites,
where `clobber()` consults the cached write-set to narrow the spill
mask. Output order is the A.1 output order, so all latent state
asymmetries stay papered over.

The question each function has to answer for IPA is purely "does
anything I transitively call write r4?" Caching that answer on the
symbol makes the function drainable in any order once the answer is
ready.

The Tarjan code from B.1 remains useful: the pre-pass needs the same
reverse-topo order to make cache lookups for callees always hit a
populated entry (within an SCC, all members pessimistically assume
ABI as each other's callee — standard GCC/LLVM fallback).

## Known A.1 side effect: section ordering in multi-function TUs

Phase A.1's deferral changes section ordering when a TU mixes code
and data declarations. Under A.0 (immediate processing), a source
layout like `fn1; data1; fn2; data2;` emitted as
`.text fn1 .data data1 .text fn2 .data data2`. Under A.1 the `.text`
emit is suppressed during parse (to keep `.global`/`.text` adjacent
to each function body at drain), so data sections print during parse
but function bodies land at the drain at end-of-TU. Resulting layout:
`.data data1 .data data2 .text fn1 fn2 …`.

**Per-function byte-match is unaffected** — the normalizer
(`asm_normalize.py`) extracts per-function slices independent of
section placement. But any future consumer that diffs raw `.s`
section structure will see this shift. Standalone single-function
corpora don't exhibit it.
