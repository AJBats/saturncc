# R0 register class — design proposal

**Status:** Proposal — no code yet
**Created:** 2026-04-14
**Motivating problem:** indexed addressing fell over because LCC has no
way to express "this operand needs R0" in a cost-aware way.

## The problem

SH-2 has a pervasive architectural quirk: many instruction forms require
R0 as a specific operand. This is not a rare edge case — it shows up
across the entire ISA:

| Instruction | R0 role |
|---|---|
| `mov.b/w @(disp,Rn),R0` | dest must be R0 |
| `mov.b/w R0,@(disp,Rn)` | src must be R0 |
| `mov.b/w/l @(R0,Rn),Rm` | one address reg must be R0 |
| `mov.b/w/l Rm,@(R0,Rn)` | one address reg must be R0 |
| `mov.b/w/l @(disp,GBR),R0` | dest must be R0 |
| `mov.b/w/l R0,@(disp,GBR)` | src must be R0 |
| `mova @(disp,PC),R0` | dest must be R0 |
| `cmp/eq #imm,R0` | dest of compare must be R0 |
| `tst #imm,R0` | dest of test must be R0 |
| `and/or/xor #imm,R0` | dest of bitwise must be R0 |
| `tst.b/and.b/or.b/xor.b #imm,@(R0,GBR)` | address must be R0 |

We currently handle these case-by-case:
- `cmp/eq #imm,R0`: ad-hoc `target()` forces R0 for the LHS
- GBR loads/stores: emit2() hard-codes `r0` and inserts mov fixups
- Displacement byte/word: emit2() emits `mov rN,r0` then `mov r0,rM` to
  bridge in/out of R0
- Indexed addressing: **failed** — `target()` forcing caused 51-line
  regression in FUN_06044BCC due to register pressure spills

The pattern is the same every time:
1. Add a compound lburg rule.
2. Use `target()` to force one operand to R0.
3. Discover the allocator has no idea this constraint has a cost.
4. Watch FUN_xxx regress because R0 was already in use and the allocator
   blindly evicted it across long live ranges.

LCC's allocator treats all registers in a class as equal. There is no
notion of "R0 is special and should be preferentially kept available."

## Why peephole rewrites aren't enough

Our previous-fallback plan (Option B) was to do a post-allocation
peephole that converts `add rA,rB; mov.X @rB,rD` → `mov rA,r0;
mov.X @(r0,rB),rD` only when R0 is provably dead at that point.

That plan works for indexed addressing in isolation, but it has a
ceiling we should be honest about:

- **It can't change allocation decisions.** If the allocator never put
  the right value near R0, the peephole has nothing to rewrite. SHC's
  output shows it deliberately routes values through R0 to enable
  back-to-back R0-form instructions. We can't replicate that pattern by
  rewriting; the value has to *be* in R0 when the instruction wants it.

- **Each new R0-form instruction needs a new peephole.** We'd
  accumulate one pass per instruction family. The complexity grows
  linearly with the ISA surface we need to match.

- **Liveness analysis on textual lines is fragile.** Branches, labels,
  and the existing peephole passes all interact with R0 differently.
  Getting it right for every case is more code than register classes
  would be.

The peephole approach is a tactical fix. The strategic fix is teaching
the allocator about R0.

## Proposed design

Add a real R0 register class to LCC's allocator. Express R0
constraints in lburg via a new wildcard symbol. Let the allocator do
cost-aware placement.

### Pieces

**1. A new register class `INTRET_ONLY` (or `R0CLASS`).**

Currently we have:
```
#define INTTMP  0x0000000e  /* R1..R3 */
#define INTVAR  0x00007f00  /* R8..R14 */
#define INTRET  0x00000001  /* R0 */
```

Add:
```
#define R0CLASS 0x00000001  /* R0 only */
```

`R0CLASS` is a singleton class — the only register in it is R0. This
already works in LCC's current model; what's missing is the surrounding
infrastructure to *use* it from compound rules.

**2. A new wildcard symbol `iregw_r0`.**

LCC's wildcard symbols (`iregw` in our backend) are how lburg rules
express "any register from this class." We need a parallel
`iregw_r0` that expresses "R0 specifically."

```c
static Symbol iregw_r0;
...
iregw_r0 = mkwildcard(some_singleton_array_with_just_r0);
```

The lburg rule template can then reference `iregw_r0` instead of `iregw`
for operands that must be R0.

**3. Lburg syntax to mark constrained operands.**

This is the meaty piece. Lburg's compound rule syntax is:
```
reg: INDIRI2(ADDP4(reg, reg))  "..."  cost
```

We need a way to say "the second `reg` must be R0." Options:

- **(3a) New nonterminal `r0reg`** that only matches via wildcard
  `iregw_r0`. Then rules become:
  ```
  reg: INDIRI2(ADDP4(reg, r0reg))  "..."  cost
  ```
  This is the cleanest expression. lburg would treat `r0reg` like any
  other nonterminal, but the underlying `reg: r0reg` reduction fires
  only when the value can be placed in R0.

- **(3b) Per-position annotation** — extend lburg syntax so a rule can
  tag a child with a register class: `reg: INDIRI2(ADDP4(reg, reg{R0}))`.
  This requires modifying `lburg/gram.y`. More invasive.

Option (3a) is preferred — it reuses existing nonterminal infrastructure
and only requires backend changes, not lburg changes.

**4. Cost-aware allocation in `gen.c`.**

This is the part that fixes the FUN_06044BCC regression. When `askreg()`
sees a request for R0CLASS and R0 is currently in use, it needs to:

- Know whether the current R0 holder is short-lived (cheap to spill)
  or has a long live range (expensive to spill).
- If expensive, *preferentially* leave the value where it is and
  fall back to the non-R0 instruction form.

This requires either:
- A simple cost heuristic (live range length × use count), OR
- Multiple lburg rules at different costs — one for "R0 is free" (cost
  0) and one for "R0 is taken, fall back to add+indirect" (cost 2). The
  rule selector picks the cheaper one based on `askreg()` feedback.

The second approach is more lburg-native and avoids modifying the
allocator's heart. It does require lburg to expose register
availability at rule-selection time, which it currently doesn't —
costs are computed before allocation.

**Resolution:** start with the simpler approach. The compound R0 rule
has cost N. The fallback non-R0 rule (existing `ADDI4(reg,reg)` +
`INDIRI2(reg)` path) has cost N+1 or N+2 depending on size. As long as
N is set so the R0 path doesn't always win, the allocator naturally
chooses based on register availability via the existing `askreg`
spill-avoidance.

This won't perfectly match SHC's R0 routing, but it will avoid the
register-pressure disasters, which is the immediate blocker.

**5. Rule migration.**

Once the infrastructure exists, port the existing R0 hacks to use it:

| Current (ad-hoc) | After (R0 class) |
|---|---|
| `target()` forces R0 for `cmp/eq #imm` | `stmt: EQI4(r0reg, immi8)` |
| emit2() hard-codes r0 in GBR loads | `reg: INDIRI4(ADDRGP4)` produces r0reg |
| emit2() inserts mov around displacement byte/word | rule template uses r0reg directly |
| Indexed addressing (currently broken) | `reg: INDIRI4(ADDP4(reg, r0reg))` |

Each port is small and isolated. The migration can happen
incrementally — old hacks keep working until replaced.

## Scope estimate

- **gen.c changes:** small. The core `askreg()` already handles
  arbitrary masks. We mainly need to ensure singleton-class requests
  don't deadlock when R0 is held by another live value. Estimate: 30-50
  lines.

- **lburg infrastructure:** medium. Adding a new nonterminal that
  reduces only via wildcard is straightforward. Need to verify lburg's
  cost tables handle it correctly. Estimate: 50-100 lines, mostly
  mechanical.

- **sh.md migration:** large but mechanical. Convert each existing R0
  hack to the new infrastructure. Roughly 10-20 rules to add or
  modify, plus removing the corresponding emit2() workarounds.
  Estimate: 200 lines net change.

- **Testing:** existing validate_build.sh catches regressions. The
  stable .s files (FUN_06004378, FUN_00280710, FUN_06000AF8) act as
  regression checks. Adding 1-2 more stable files post-migration
  would lock in the new behavior.

**Total estimate:** 1-2 sessions of focused work. Risk is mostly in
gen.c — we maintain divergence from upstream there already, and the
file is small enough to understand fully.

## What this doesn't solve

- **Interprocedural register save elision.** SHC's output sometimes has
  the caller pre-save callee-saved registers because SHC knows the
  callee's exact register usage. We can't match that without
  whole-program analysis. Out of scope.

- **Constant reuse across statements.** SHC keeps `r0=0` live across
  multiple stores. This is liveness-aware constant propagation; not
  R0-specific. Separate workstream.

- **Base-pointer factoring.** SHC pre-computes `r4 = base + 0x10`
  and uses small offsets from r4. This is a high-level optimization
  unrelated to R0. Separate workstream.

R0 register class is necessary but not sufficient for byte-matching.
It removes one architectural blocker that's currently preventing us
from even *trying* certain instruction forms.

## Open questions

1. Does lburg's existing wildcard infrastructure support a singleton
   class without changes? Need to read `lburg/lburg.c` and verify
   `mkwildcard()` works for masks with only one bit set.

2. How does `askreg(R0CLASS, ...)` interact with the existing pinning
   of r4-r7 for arg passing and r0 for return? Need to make sure
   asking for R0 mid-function doesn't conflict with `setreg(CALL,
   ireg[0])` and `rtarget(RET, ..., ireg[0])`.

3. Should we add cost heuristics now or punt to a follow-up? Punt is
   probably right — get the basic infrastructure working first, then
   tune.

4. What's the right name for the new nonterminal? `r0reg` is short and
   clear but conflicts visually with normal `reg`. `regr0` is uglier
   but harder to mis-read. Bikeshedding can wait.

## Next step

Read `gen.c` and `lburg/lburg.c` to validate assumption #1 above.
If wildcards support singleton classes, the design is sound and we can
start implementing. If not, the design needs to grow to include lburg
infrastructure changes.
