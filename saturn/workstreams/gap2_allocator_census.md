# Gap #2 census — allocator-priority flip failure modes

Investigation under branch `gap2-allocator-investigation`. Goal:
before refactoring backend passes to support a low-first allocator
order, enumerate every regression caused by a global flip and
classify by cause. Tells us scope and shape of the work.

## Method

Baseline: master @ `8ac14eb` (post-noregsave batches; 25,377 TU diff
across 196 functions, 10 standalone corpus byte-matched at pinned
counts).

Probe: in-branch flip of `ireg_prio[22..28]` from r14..r8 to r8..r14.
Re-ran `validate_byte_match.sh` (standalone) and
`validate_byte_match_tu.sh` (TU). Captured each regression's normalized
asmdiff. Reverted before census write-up.

## Regressions captured

**Standalone corpus (10 functions): 4 regressed.**

| Function     | Before → After | Δ    | Mode |
|--------------|---------------:|------|------|
| FUN_00280710 |    4 → 16      | +12  | FM-B |
| FUN_06004378 |   42 → 70      | +28  | FM-A |
| FUN_06037E28 | 1039 → 1101    | +62  | FM-C |
| FUN_06040EA0 |  260 → 262     | +2   | FM-A |

**TU corpus (196 functions): 15 regressed.**

| Function     | Δ    | Mode |
|--------------|------|------|
| FUN_060440E0 | +2   | FM-A |
| FUN_060446F4 | +2   | FM-A |
| FUN_06044848 | +8   | FM-A |
| FUN_060449B6 | +4   | FM-A |
| FUN_06045678 | +2   | FM-A |
| FUN_06045C9C | +2   | FM-A |
| FUN_0604670C | +2   | FM-A |
| FUN_060467B4 | +2   | FM-A |
| FUN_060468B0 | +2   | FM-A |
| FUN_06047332 | +2   | FM-A |
| FUN_0604737A | +2   | FM-A |
| FUN_060473CA | +2   | FM-A |
| FUN_06047414 | +2   | FM-A |
| FUN_06047460 | +2   | FM-A |
| FUN_060474D4 | +2   | FM-A |

**Aggregate regression cost across both corpora: +138 lines.**
Aggregate improvement: +14 lines (2 standalone improved, 9 TU
improved by ~1-2 lines each — gains were small because the post-RA
peephole passes don't get the speed-up benefit they would under a
co-designed allocator).

## Failure modes

### FM-A — "prod r14, ours r8" reg-name swap (dominant: 16 of 19 regressions)

**Symptom.** A single var that prod homed in r14 our compiler now
homes in r8. Diff is a uniform `r14` → `r8` substitution across all
references in the function.

**Why prod chose r14 specifically.** SHC's choice for *single-callee-saved
leaf functions* is r14, not r8. The reason is the rts delay slot:
prod prologue pushes r14 first (= last popped), so the final
`mov.l @r15+, r14` lands in the rts delay slot for free. Picking r8
would push r8 first → pop last → not a delay-slot fit.

**Confirmation.** FUN_06004378 has 6 rts sites and is the canonical
"multi-return leaf" case. FUN_060440E0 / FUN_060446F4 / most TU
regressions follow the same shape: one or two callee-saved registers,
one of which is r14, with the pop-as-delay-slot pattern in prod.

**Implication.** SHC does NOT use a uniformly low-first allocator.
It has at least two allocation policies:
- **Multi-callee-saved (regsave functions):** r8..r14 ascending
  (the contiguous save-range we already implemented for `regsave`).
- **Single-callee-saved leaf with multi-return:** r14 (for the
  delay-slot trick).

Our existing high-first allocator naturally matches the second case.
A global low-first flip breaks it.

**Fix shape.** Per-function allocator order, gated. Functions tagged
`#pragma regsave` get low-first; others stay high-first. This is NOT
a "bandage that will spread" (the framing the research agent used) —
it's matching SHC's actual dual-policy behavior.

The mechanic from C.3's `noregalloc` already proves we can mutate
allocator state per function: save tmask/vmask at function entry,
narrow them, restore at exit. Same pattern here: save the wildcard
priority array, swap to low-first, restore at exit.

**Estimated payoff.** All 16 FM-A regressions evaporate (per-function
gating means non-regsave functions keep current behavior). Gains on
the 27 prod-regsave functions where allocator currently picks high-
first: needs measurement, but FUN_06044060 (#001 target) and
similar should now naturally land on r8/r9/r10/... matching prod's
contiguous save range.

### FM-B — `sh_rewrite_bool_fp` doesn't fire (1 known case: FUN_00280710 +12)

**Symptom.** Prod uses an FP-ceremony idiom for boolean-to-int:
`bf/s L; mov r15,r14; bra Lm; mov #X,r0; L: mov #Y,r0; Lm:
mov r14,r15`. Under high-first our `sh_rewrite_bool_fp` injects this
idiom. Under low-first it bails because of its `usedmask & (1<<14)`
guard (which exists to protect against clobbering caller's r14 when
r14 isn't already saved by prologue).

**Why the guard exists.** The injection writes r14 (`mov r15,r14`).
If the prologue doesn't save r14, the injection corrupts the
caller's r14. The guard was added in `752a344` after a real outage
(see [landmines.md](landmines.md) "sh_rewrite_bool_fp injects r14
assuming r14 is saved").

**Why it bails under low-first.** Low-first allocator rarely picks
r14 as a var (it's last priority), so r14 isn't in usedmask, so the
prologue doesn't save it, so the guard correctly bails — but the
prod-matching idiom doesn't fire.

**Fix shape.** Two options:
1. **Force-add r14 to usedmask just before bool_fp fires.** Bool_fp
   wants to use r14 as FP; if it can do so, the prologue should
   save r14 unconditionally. Simple: `if (bool_fp_pattern_found)
   usedmask[IREG] |= (1<<14)` before the rewrite.
2. **Operate on a "FP role" register.** More invasive — the pass
   would have to coordinate with the FP-setup logic to use whatever
   reg the function picked as FP.

Option 1 is the principled fix and is small. The pass already knows
when it's about to inject; adding "+r14 to save list" pre-injection
is a one-line change.

**FM-B independence.** This is orthogonal to FM-A. Even with per-
function allocator gating, bool_fp may still misfire in the rare
non-regsave function that happens to use the bool pattern AND has
r14 free. Worth fixing once, won't regress further.

### FM-C — large-function compound failures (1 case: FUN_06037E28 +62)

**Symptom.** E28 went 1039 → 1101. Body is too large to classify
as one mode. Likely a mix of FM-A scaled across the function plus
some additional body-shape divergences.

**Status.** Skipping detailed classification. With FM-A fixed via
per-function gating, E28 stays at high-first (it's not currently
tagged regsave) and this regression vanishes.

## First conclusion (later overturned)

The initial reading of FM-A — "prod r14, ours r8" reg-name swap —
suggested SHC has *dual* allocator policies depending on function
shape:
- **Model A:** SHC picks low-first for regsave-tagged functions and
  picks r14-first for single-callee-saved leaf-multi-return cases.

Under Model A, the fix would be per-function gating on the regsave
attribute (Chunks 2+3+4 as initially drafted).

## Negative-space check

Before locking in Model A, an epistemic check: would the v5.0
manual document allocation order if SHC made it user-controllable?
[v5.0 SHC manual](../resources/manuals/hitachi_shc_v5.0_fulltext.txt)
§3.10–§3.11 documents only **save behavior** pragmas (regsave,
noregsave, noregalloc, global_register). **Nothing about
allocation order.** So whatever SHC does for allocation is built
into the compiler — not a per-function knob the programmer
selected. That rules out "the programmer picked low-first via
pragma" but leaves both:
- **Model A:** SHC has an internal heuristic that picks differently
  per function shape (no user knob, but two policies internally).
- **Model B:** SHC has a uniform allocator (low-first) + a post-RA
  peephole that renames r8→r14 for single-callee-saved leaf-multi-
  return cases (where the rts delay slot benefits).

Both models predict the same prod assembly. They differ in where
the "use r14 for the delay-slot trick" decision lives.

## The check that distinguished them

Under the in-branch low-first probe, **9 functions improved.** If
Model A were right, only the 27 prod-regsave functions should
improve (per-function gating would only flip them). If Model B is
right, improvements should be spread across functions of any shape
because the allocator is globally low-first.

Improved functions classified by current noregsave tag status
(in `race_FUN_06044060/FUN_06044060.c`):

| Function     | Δ    | noregsave tagged? |
|--------------|-----:|-------------------|
| FUN_06044BCC | -4   | no (regsave shape) |
| FUN_06045198 | -2   | no |
| FUN_06045714 | -2   | no |
| FUN_06045784 | -2   | no |
| FUN_060457E4 | -2   | excluded from noregsave (regressed under noregsave) |
| FUN_0604660A | -2   | excluded from noregsave (regressed under noregsave) |
| FUN_06046CD0 | -2   | no |
| FUN_06047014 | -2   | yes |
| FUN_060479A0 | -4   | no |

**Six of nine improvements are non-regsave functions.** Per-function
gating on regsave would lose those wins. **Model A is wrong.**

## Revised conclusion

**Model B is correct.** SHC's allocator is uniformly low-first; the
"r14 for single-callee-saved leaf" pattern is a separate post-RA
optimization. Mapped to our backend:

- Our existing `sh_leaf_rename_callee_saved` handles the OPPOSITE
  optimization: rename a sole-callee-saved reg DOWN to caller-saved
  scratch (r7..r4, r0) to eliminate the prologue save entirely.
  That's a real win when applicable but is the wrong policy when
  prod kept the callee-saved for the delay-slot pop.
- We need an additional post-RA pass (or a refinement of the
  existing one) that detects "leaf with multiple returns, one
  callee-saved dirty" and renames the dirty reg to **r14**
  specifically — to enable the rts-delay-slot pop pattern.
- And we should still flip the allocator to low-first.

## Revised plan

### Chunk 2 — post-RA delay-slot rename pass

Detect `single-callee-saved + N rts sites where N > 1` shape. Rename
the dirty callee-saved reg to r14 so its pop lands in the rts delay
slot. Operates on the captured body lines after gencode + existing
peepholes. Pattern after `sh_leaf_rename_callee_saved` but with
opposite target (r14 instead of r7..r4).

**Verification:** with allocator still high-first (no behavior change
yet), tag the regressed functions to opt them OUT of leaf_rename and
verify the new pass produces the prod-matching r14 pattern. Then run
full validate.

### Chunk 3 — FM-B fix (bool_fp + r14)

`sh_rewrite_bool_fp` requires `usedmask & (1<<14)` to ensure the
prologue saves r14. Under low-first r14 is rarely a var. Fix: when
the bool_fp pattern is detected and bool_fp is about to inject,
force-add r14 to usedmask so the prologue saves it.

This is a one-line guard change. Fully orthogonal to Chunk 2.

### Chunk 4 — audit other r14-assuming passes

[landmines.md](landmines.md) calls out at least:
- `sh_restructure_eq_chain` — uses r14 as scratch
- The speculative r14 reclaim in `function()` — already touched in
  C.4 for vmask awareness, may need similar treatment

Walk these passes; either confirm they're order-agnostic (the walk
direction is cosmetic) or refactor to pick targets relative to live
sets rather than naming r14.

### Chunk 5 — flip allocator to low-first, measure

Single one-line change in `ireg_prio[22..28]` once Chunks 2-4 land.
Re-pin baselines for all corpora. This is the make-or-fold moment:
expected outcome is the 19 census regressions gone (closed by
Chunks 2-4) plus the 9 improvements held PLUS additional wins on
the 27 prod-regsave functions where the contiguous save range now
naturally lands.

## Risk-revised confidence

- **Chunk 2:** medium-high. Post-RA rename pass is a known shape
  (we have the OPPOSITE pass already). Main risk is correctly
  identifying the leaf-multi-return shape without false positives.
- **Chunk 3:** high. One-line guard change.
- **Chunk 4:** medium. Each pass needs case-by-case audit; at least
  one of them is in `sh.md` body emit territory which is fragile.
- **Chunk 5:** medium. The remaining failure modes after 2+3+4 are
  unknown and may surface only when allocator actually flips.

## Decision-point shape

Chunks 2+3 are both bounded and reversible. Even Chunk 5 is
reversible (the flip is one line). The branch isolates the work.
Master stays clean throughout.

If after Chunk 5 the wins are smaller than expected (say, fewer
than 200 lines closed across the 27 prod-regsave functions plus
the existing 9 improved), the project verdict updates accordingly:
- Model B is right but its impact is dispersed/limited
- Other gaps (peephole, idiom-injection) become higher-leverage
- Or the branch is abandoned and master continues with high-first

## What we learned about epistemic process

The Model A → Model B flip happened because the user asked: "what
does the negative space of the documentation tell us?" That single
question identified an unfalsified-but-wrong model and saved a
chunk of misdirected work. Patterns to repeat:

1. When a hypothesis fits the obvious data, look for *what data
   would distinguish it from a competing hypothesis* before
   committing.
2. Documentation absences are evidence too. The lack of an
   allocation-order pragma in v5.0 specifically rules out
   programmer-controlled per-function order.
3. Post-RA peepholes are a generic alternative to allocator
   policy variation. If the visible output looks like "two
   policies," check whether one policy + one rename pass can
   produce the same output more parsimoniously.

