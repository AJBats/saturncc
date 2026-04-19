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

## Conclusion

The "global flip" hypothesis is wrong. SHC has dual allocator
policies depending on function shape, not a uniform low-first
order. Matching it requires per-function gating.

**Revised plan:**

- **Chunk 2:** implement per-function allocator priority (regsave →
  low-first). Pattern after C.3's tmask/vmask save-restore. Should
  eliminate all 16 FM-A regressions automatically and only affect
  the 27 prod-regsave functions.
- **Chunk 3:** fix FM-B (force r14 into usedmask before bool_fp
  injects). Independent of Chunk 2.
- **Chunk 4:** flip per-function for the 27 regsave functions, tag
  them in the TU source, measure. This is where the actual byte-
  match wins should appear — current regsave-tagged functions are
  pinned at allocator-mismatch baselines that the gating will close.

**Reframing the research agent's verdict.** The agent said per-
function pragma is "a bandage that will spread." That conclusion
was right under the assumption that SHC uses a single allocation
policy. Census evidence shows SHC has TWO policies, so per-function
gating *is* the correct model — not a bandage.

**Confidence.** High that Chunks 2+3 close the regressions.
Uncertain on the size of the wins from Chunk 4 — that's the actual
byte-match question. If Chunk 4 lands less than ~200 lines on the
27 functions, we'll know the allocator-order policy isn't the
biggest remaining lever and can re-plan.

## Next decision point

Approve the revised Chunk 2 (per-function allocator priority) and I
implement it. Or hold here if a different direction is preferred.
