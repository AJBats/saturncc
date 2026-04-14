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

---

## 2026-04-14 update — investigation findings

Read `gen.c` carefully (`mkwildcard`, `askreg`, `getreg`, `rtarget`,
`spillee`, `ralloc`).  The picture is more nuanced than the doc above
suggests.

### What works as expected

- **Singleton wildcards work mechanically.** `mkwildcard()` takes a
  `Symbol*` array of length 32; nothing prevents us from putting R0
  in one slot and NULL in the rest.  `askreg()` walks the array and
  returns R0 if free.

- **`rtarget(p, n, ireg[0])` does fix the kid to R0.** It either
  setregs an existing wildcard kid to R0, or wraps in a LOAD node.
  This works today — that's how `cmp/eq #imm,R0` gets R0.

### What doesn't work as expected

- **R0 is not currently allocatable via the wildcard path.**  `tmask[IREG]
  = INTTMP = 0xe`.  R0's mask bit (0x1) is not in tmask, so
  `askreg(iregw, tmask)` filters R0 out.  R0 only appears via explicit
  `setreg/rtarget`, never via wildcard allocation.

- **lburg cost is static — period.**  A rule's cost is computed at
  label-time, before any register allocation.  There is no way in
  lburg to express "cost 1 if R0 is free at this point, cost 2
  otherwise."  This is the *core* of why our compound-rule + target()
  approach broke.

- **`rtarget()` blindly forces, then `spillee` cleans up.** When the
  forced register is taken, `getreg()` calls `spillee()` which evicts
  the longest-distance-to-next-use value. For long-lived callee-saved
  registers, this is exactly the cascading-spill disaster we saw in
  FUN_06044BCC (+51 lines).

### What this means for Option A

Adding `iregw_r0` and `r0reg` is straightforward (a few dozen lines).
But it **would not fix the cost problem** by itself.  We'd still be
emitting compound rules at static cost, still calling `rtarget()`, still
risking the spill cascade.

The real fix would be one of:

1. **Modify lburg to support dynamic costs.**  Have the cost function
   consult `freemask[]` at rule-selection time.  This is a real change
   to lburg infrastructure, would diverge us from upstream more than we
   already are, and the rule-selection pass currently runs *before*
   register allocation, so `freemask` doesn't reflect the final state.
   Significant scope.

2. **Defer the R0 routing decision until after allocation.**  Generate
   normal code, then run a peephole that converts add+indirect to
   indexed addressing when R0 happens to be dead at that point.  This
   is the Option B from the discussion — and after this investigation
   it's looking like the *only* practical option that doesn't require
   surgery on lburg.

3. **Hybrid: lburg compound rules with conservative cost (already
   tried), plus a follow-up peephole that opportunistically routes
   values through R0 to enable additional firings.**  The compound
   rule fires when R0 is naturally free.  The peephole identifies
   places where re-routing a constant load or a copy through R0 would
   enable a downstream indexed/displacement instruction.

### Revised recommendation

The original Option A (register classes in LCC) sounded like 1-2
sessions of mechanical work.  After investigation, it's actually
1-2 sessions for the *infrastructure*, plus deeper lburg changes
to make it useful, plus risk of breaking things in gen.c that we
don't fully understand yet.

The pragmatic path is **Option 3 (hybrid)** above:

- Restore the lburg compound rules for indexed/etc. with conservative
  cost — they fire safely when R0 is naturally available.
- Add a peephole pass `sh_route_via_r0()` that runs after register
  allocation and either:
  - Converts free-floating add+indirect to indexed when R0 is dead, OR
  - Looks one instruction back to find a constant-load that *could*
    have gone to R0 and rewrites both lines together.

This gives us most of the benefit of Option A without modifying
gen.c or lburg.  And it leaves the door open: if we hit a wall where
the peephole can't see enough context, we can promote to a deeper
solution then, with concrete failure cases to guide the design.

### Open question, restated

Is there a real-world function we can't byte-match through hybrid
peepholes alone?  If yes, that's the trigger to go deeper.  If no,
we don't need to.

We don't know yet.  Going hybrid first lets us find out cheaply.

### Status

- **Option A as originally specified:** rejected.  Doesn't actually
  fix the cost problem without deeper lburg changes.
- **Option B (peephole only):** viable but limited (can only rewrite
  what allocator already produced).
- **Option 3 (hybrid):** abandoned in implementation.  Compound rules
  for `INDIR(ADD(reg,reg))` cause register conflicts because the
  destination register can collide with one of the input registers
  (lburg consumed the ADD's intermediate, leaving emit2 no separate
  temp register to use).  See "Why compound rules failed" below.
- **Final implementation:** Option B only.  No compound rules for
  indexed addressing.  The `sh_route_via_r0()` peephole rewrites
  `mov rA,rT; add rB,rT; mov.X @rT,rD` to `mov rA,r0;
  mov.X @(r0,rB),rD` when R0 is dead at that point.

### Why compound rules failed

Tried: `reg: INDIR(ADD(reg,reg))` with cost 1, emit2 fallback that
uses `dst` as the address-computation temp.

Bug: when the destination register collides with one of the address
inputs, the emit2 fallback corrupts the address.  Example: emit2
generates `mov r14,r2; add r2,r2; mov.l @r2,r2` when the allocator
chose r2 for the destination and r14, r2 as the inputs.  The
`add r2,r2` doubles r2 instead of adding the second input.

Root cause: lburg compound rules consume the intermediate node and
its associated register slot.  emit2 has no way to request a
separate temp register because the rule didn't allocate one.  Using
`dst` as temp only works when dst differs from both inputs, which
isn't guaranteed.

This is a structural limitation, not a fixable bug.  Compound rules
work fine when no temp is needed (displacement, GBR, etc.) but fail
for indexed addressing where address computation requires a register.

### What we actually implemented

`sh_route_via_r0()` runs after register allocation and converts the
regular `add+indirect` output to indexed form when R0 is dead.

Impact on existing functions: 2 indexed instructions added in
FUN_06037E28 (no line change, same instruction count, but using the
correct addressing mode that production also uses).  Other functions
unchanged.

This is a small but real improvement.  Production uses 100+ indexed
instructions in E28, most of them as part of SHC's deliberate R0
routing strategy.  Our peephole can only catch cases where R0
happens to be dead naturally.

### Future work

To capture more of production's R0 routing patterns, we'd need to
*proactively* route values through R0, not just opportunistically
detect when R0 is free.  This could be:

- A second peephole pass that identifies pool-load destinations that
  could be R0 instead, and rewrites them when doing so enables a
  downstream indexed/displacement instruction.

- A pre-allocation hint mechanism that biases the register allocator
  toward R0 for short-lived address-component values.

- The full register class implementation originally proposed (still
  has the lburg cost-awareness problem, but worth revisiting once we
  have concrete patterns from real failures).

For now, the simple opportunistic peephole is good enough.  We
revisit if/when a specific function's byte-match is blocked by
missing R0 routing.
