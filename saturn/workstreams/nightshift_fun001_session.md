# Nightshift session: FUN_06044060 byte-match attempts

Branch: `nightshift-fun001`. Picked up from master at `6ba9a18` (post
gap2 merge). User stepped away and asked for autonomous progress on
the original byte-match target #001 (`FUN_06044060`, baseline 70 diff).

## What landed

- **`30bf7ec`** — 4-param signature attempt, reverted with diagnostic.
- **`a4335b1`** — standalone lowfirst tags: FUN_06044BCC -2, FUN_0602A664 -2.

**Net branch progress: -4 diff lines across two standalone functions.**
FUN_06044060 itself unchanged at 70 baseline.

## Attempts and findings

### 1. FUN_06044060 4-param signature recovery

**Hypothesis:** Ghidra decompiled this as 1-param but prod prologue
stashes r5/r6/r7 → r8/r9/r10 proving 4 incoming args. With our new
regsave + sh_alloc_lowfirst tools, restoring the 4-param signature
should produce prod-matching prologue.

**Result:** 70 → 84 (+14 regression). Reverted.

**Why it regressed:**
- Param homing assigned p2 → r9, p3 → r10, p4 → r11 (off-by-one from
  prod's r8/r9/r10) because the allocator implicitly homed p1 in r8
  to preserve it across the FUN_06044D80 call. Prod doesn't preserve
  p1 (assumes FUN_06044D80 doesn't clobber r4 — non-standard SH-2
  ABI).
- Pool entries for -0x10000/0x10000 instead of inline `shll16+neg`.
- Call-arg setup uses standard ABI (r4) for FUN_060450F2 / FUN_06045006;
  prod uses r0 (shim entry).

**Path forward (out of scope for nightshift):**
- Mechanism for "this callee preserves r4" — would let our compiler
  leave p1 in r4 across the FUN_06044D80 call, eliminating the r8 stash.
- entry_alias mechanism for the r0-shim calling convention.
- Inline literal construction peephole (Gap #3 — see below).

### 2. Standalone corpus lowfirst tagging

A/B-tested `#pragma sh_alloc_lowfirst` on each non-byte-matched
standalone function via new `find_lowfirst_standalone.py` tool.

**Wins (committed in a4335b1):**
- FUN_06044BCC: 438 → 436 (-2)
- FUN_0602A664: 130 → 128 (-2)

**No-ops:** FUN_00280710, FUN_06004378, FUN_06047748 (lowfirst tag
fires but doesn't change codegen — typically because allocator
naturally chose r14 for single-callee-saved leaf).

**Persistent regression (untagged with note):**
- FUN_06037E28: 1039 → 1101 with any tag combo (regsave alone,
  lowfirst alone, both). Body-shape divergence not tag-fixable.
  Likely needs Gap #3 + entry_alias work.

### 3. Gap #3: in-place literal construction (attempt + revert)

**Hypothesis:** Across race_FUN_06044060 prod TU there are zero
`.long 65536` entries — SHC always builds 0x10000 inline via
`mov #1, rN; shll16 rN`. Our compiler emits 8 pool entries for the
same value. Implementing a peephole to inline single-use 0x10000
loads should close diff lines.

**Implementation:** `sh_inline_pool_constants` peephole pass between
`sh_swap_pool_add` and `sh_coalesce_move_chains`. Added `is_dead`
flag to `struct shlit` so `shlit_flush` skips replaced entries. Added
ref_count pre-pass to gate inlining on single-use only (multi-use
keeps pool sharing because that's what prod does too).

**Result:** Net **0 lines** (-33 from 13 improvements, +33 from 27
regressions). Reverted.

**Why net zero:**
- Improvements landed where expected: FUN_06045020 family of large
  functions each shed -2 lines from removed pool entry + matched
  inline pattern.
- Regressions are +1/+2 per function, scattered across 27 functions.
  Diagnosing one (FUN_060456CC) showed the divergence wasn't even
  about 65536 — looked like pool reordering (after removing a 65536
  pool entry) caused other peepholes to react differently. The
  cancel-out was coincidence, not signal.

**Lesson logged:** removing pool entries is not free even when no
direct user remains. Pool layout affects PC-relative reach
calculations and peephole interactions with the surrounding pool
flush points. A future attempt would need to either:
1. Run the inline pass MUCH later (after all pool-sensitive
   peepholes), or
2. Re-run the pool-affecting peepholes after inlining, or
3. Accept that some functions can't be byte-matched without
   restructuring the entire pool emit pipeline.

For nightshift, this is "exhausted the cheap version of the
generalizable fix." A serious Gap #3 attempt is its own
multi-session workstream.

## State for resume

- Branch `nightshift-fun001` has 2 commits since master.
- All baselines pinned. validate_build.sh: 42/42 pass.
- FUN_06044060 stays at 70 — same as master.
- Standalone corpus is 2 functions ahead of master.

## Recommended next moves (when resuming)

1. **Cherry-pick or merge `a4335b1`** — the -4 standalone gain is
   safe and proven.
2. **Skip the 4-param signature path** until the entry_alias and
   "callee preserves r4" mechanisms exist. They're prerequisites.
3. **Gap #3 needs a different approach** — likely run AFTER pool
   emit, rewriting the body to drop pool refs and restructure
   pool. Larger workstream.
4. **Per-function A/B testing for OTHER pragma combinations**
   (regsave + noregalloc + lowfirst, etc.) on the TU might yield
   more incremental wins. Tooling supports it.

## Process note

This nightshift was disciplined-bold per user framing:
- Attempted ambitious things (4-param sig, Gap #3 peephole)
- Reverted promptly when measurement showed net regression
- Committed reversion-with-diagnostic so the next session has the
  full failure context
- Locked in the safe wins (standalone tags) as a separate commit

The pragma-discipline gate (per gap2 user guidance) was also
respected: no new pragma classes added without exhausting the
generalizable fix first.
