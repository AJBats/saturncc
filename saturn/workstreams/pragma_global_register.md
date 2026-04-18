# Pragma workstream: SHC register-save + global-register mechanisms

Closes Gap 1 (save-all-range prologue) and its prerequisites. This
doc is the design + plan. The fix surface is [src/input.c](../../src/input.c)
(parser), [src/sh.md](../../src/sh.md) (backend consumption), and a
new TU pre-pass tool under [saturn/tools/](../tools/).

## Authority

Hitachi SH Series C/C++ Compiler User's Manual v5.0 (`HS0700CLCU4S`,
1997-03) at
[saturn/resources/manuals/hitachi_shc_v5.0_fulltext.txt](../resources/manuals/hitachi_shc_v5.0_fulltext.txt),
§3.10 (lines 3003–3045) and §3.11 (lines 3046–3073). Four pragmas,
two independent mechanisms:

### §3.10 Register save and recovery (per-function attribute)

- `#pragma noregsave(f)` — function does NOT save/restore R8–R14 at
  prologue/epilogue. Legal only when one of: (a) `f` is the top-level
  entry, (b) `f` is called from a `regsave` function, (c) `f` is called
  from a `regsave` function through a `noregalloc` bridge.
- `#pragma regsave(f)` — function saves/restores R8–R14 at prologue
  /epilogue AND around its own calls. The "I preserve state" contract.
- `#pragma noregalloc(f)` — transparent bridge: no save/restore, but
  the allocator does not touch R8–R14. Used to pass `regsave` state
  through intermediate call frames.

These compose per-function. Default (no pragma) is classical SH-2
calling convention: save what you clobber, standard callee-saved
R8–R14.

### §3.11 Global variable register allocation (TU-wide binding)

- `#pragma global_register(var=Rn)` — pins one of R8–R14 (or FR12–FR15
  on SH-3E) to the named global `var` across the whole TU. Constraints:
  simple/pointer type only, no initial value, no address-of, not
  linker-visible.

This is the mechanism for Sega engineers declaring "r10 is the current
context pointer for this whole TU." Independent of §3.10 — a function
could be `#pragma regsave` (saves non-pinned callee-saved regs normally)
but `global_register(ctx=R10)` means r10 is carved out of both the
allocator pool AND the save set for every function in this TU.

## Why Daytona CCE almost certainly uses these

Evidence already on disk:

- **SHC version narrowing** ([version_narrowing.md](version_narrowing.md)):
  Daytona CCE (Aug 1996) is SHC v3.x–early-v5.0, well after v2.0 which
  did NOT have these pragmas. The mechanism existed at the time.
- **Ghidra `unaff_*` annotations** in
  [race_FUN_06044060/FUN_06044060.c](../experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c):
  667 occurrences of `unaff_(r10|r11|r14|gbr)` across the TU. Per
  `98f8b0b`: r8=24, r9=59, r10=118, r11=85, r12=53, r13=60, r14=140,
  gbr=341. These are Ghidra's read-before-write liveness analysis
  output — the observable signature of `#pragma global_register` plus
  `#pragma noregsave`.
- **Prod save patterns**: each callee-saved reg is saved in 22–27
  functions per TU. No reg is universally unsaved → decisions are
  per-function (§3.10 per-function attributes), not universal TU-wide
  (§3.11 would zero one out). The two mechanisms are BOTH in use.
- **SBL build flags** ([sega_sbl_build_flags/](../resources/sega_sbl_build_flags/)):
  no register-pinning flags present. Sega did not enforce pinning via
  compiler CLI — all pinning was per-TU pragma.

## Hypothesis spike (Phase A) — PASSED

Three TU functions picked to span the space: one per expected category.
Predictions formed from Ghidra `unaff_*` + prod `.s` save pattern,
then cross-checked.

### FUN_06044060 (#001 target) — `regsave`

- Ghidra C: no `unaff_*`. Locals r8/r9/r10 stash incoming params r5/r6/r7.
- Prod .s ([FUN_06044060.s:9-57](/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s)):
  saves r14, r13, r12, r11, r10, r9, r8, pr (full range, 7 regs), pops
  symmetric. Body clobbers r8, r9, r10 only.
- **Predicted pragma:** `#pragma regsave(FUN_06044060)`.
  - Under SHC's rule, `regsave` saves `[lowest_dirty..r14]` — here
    r8 is lowest dirty so save range is r8..r14. Matches prod exactly.
  - This is the pattern LCC needs to emit; currently LCC saves only
    the regs it actually uses (the classical default). Difference is
    4 saves × 2 directions = 8 lines, plus register-naming differences
    from Gap #2.

### FUN_06044E28 (#022, "no callee-saved usage") — no pragma needed

- Ghidra C: no `unaff_*`. Body just passes 3 stack locals through to
  `FUN_06044E3C` via a stack-buffer pointer.
- Prod .s ([FUN_06044060.s:1951-1961](/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s)):
  saves pr, r7, r6, r5. These are caller-saved regs being spilled to
  form a stack array — not a callee-saved save. Zero of r8–r14 touched.
- **Predicted pragma:** none. Default behavior (save what you clobber)
  is already correct for this function. This confirms the `regsave`
  rule is a per-function attribute, not a TU-wide default.

### FUN_0604727C (#168, "global register user") — `noregsave`

- Ghidra C ([L9216-9231](../experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c)):
  `undefined4 *unaff_r11;` declared; function reads `*unaff_r11` (via
  `mov.l r3, @(0, r11)` in prod) and writes it (`add #0x8, r11`).
  `extraout_r3` marks call-return-via-r3 convention.
- Prod .s ([FUN_06044060.s:7434-7443](/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s)):
  saves pr only. Reads `@(0, r10)` and `@(8, r10)` live-in; reads and
  mutates r11 (`mov.l r3, @(0, r11); add #0x8, r11`) without save.
- **Predicted pragmas:** `#pragma noregsave(FUN_0604727C)` at per-function
  level, plus TU-wide `#pragma global_register(someptr=R11)` and
  probably `global_register(...=R10)` to keep the allocator from reusing
  them elsewhere.

Spike verdict: **the two-mechanism model fits the evidence.** Nothing
we've observed requires inventing a new pragma; every pattern maps to
either a §3.10 per-function attribute or a §3.11 TU-wide binding.

## Plan

### Phase B — parser + storage (1 commit)

- Add four pragma parsers to `src/input.c` following the existing
  `shc_pragma_hook` / `gbr_param` pattern.
- Per-function attribute storage (small hash or array keyed by
  function name).
- TU-wide global_register table (var → reg map).
- Stage-4 regression tests: positive (parses + stores correctly) and
  negative (mid-function rejection already guarded by S1).
- No codegen behavior change. Acceptance: all existing baselines
  unchanged.

### Phase C — backend consumption

Separate commits for separable risks. Each gated on `validate_build.sh`
plus a subagent review per the pre-commit rule.

**C.1 `#pragma regsave(f)`** — extend `usedmask` to `[lowest_dirty..r14]`
at prologue emit time when the function is tagged `regsave`. Mirror in
epilogue. This is the in-flight change reverted in `98f8b0b` — but now
only fires on the tagged subset, so the 8 false positives (which won't
be tagged `regsave`) don't regress.

**C.2 `#pragma noregsave(f)`** — skip prologue/epilogue save of R8–R14
entirely when tagged. Allocator still free to use those regs in the
function body.

**C.3 `#pragma noregalloc(f)`** — mask R8–R14 out of the allocator's
free pool for this function only. No save/restore.

**C.4 `#pragma global_register(var=Rn)`** — TU-level. Bind `var` to `Rn`,
emit a direct register reference whenever `var` is read/written, exclude
Rn from the allocator pool TU-wide. This one is the most involved — it
affects lburg rule selection. Consider doing it last after the three
per-function attributes land.

### Phase D — auto-generation tool (1 commit)

`saturn/tools/derive_pragmas.py`. Reads:

- A Ghidra `.c` file — detects `unaff_rN` declarations per function;
  counts occurrences to distinguish "named global that wants
  `global_register`" from "transient live-in that just wants `noregsave`".
- The matching prod `.s` — scans each function's prologue for
  `mov.l r8..r14, @-r15` and `sts.l pr, @-r15` patterns, classifies
  the save-set shape.

Emits a pragma block at the top of the TU source file. The Ghidra C is
INPUT ([MEMORY.md: rcc_owns_robustness](../../../../../../Users/albat/.claude/projects/d--Projects-saturncc/memory/feedback_rcc_owns_robustness.md)),
so the generated pragmas are added *alongside* the Ghidra decomp, not
patched into it.

Expected classifications:

- **`regsave`** — prod saves contiguous `[r_lowest..r14]` starting from
  some lowest. Tag every such function. Likely the majority.
- **`noregsave`** — prod saves nothing from r8–r14, Ghidra C has
  `unaff_rN` for specific n. Tag with the specific n list.
- **`noregalloc`** — harder to detect mechanically. Candidate: a function
  that doesn't touch r8–r14 at all AND is called by `regsave` callers.
  Heuristic; may need a skip-list for false positives.
- **`global_register(var=Rn)`** — TU-wide. Derive from `unaff_rN`
  occurrences that are consistent across many functions AND where the
  reg is never saved anywhere in the TU. For race_FUN_06044060, likely
  candidates are r10, r11, r14 (high unaff counts, but not universal —
  will need per-instance verification).

### Phase E — apply + re-baseline (1 commit)

Run `derive_pragmas.py` on race_FUN_06044060. Regenerate pragmas at top
of the TU `.c`. Re-pin all 189 non-zero baselines. Expected: aggregate
diff drop across the TU; maybe ~14 lines/function average on `regsave`
functions, more on `noregsave` ones. FUN_06044834 (currently byte-
identical) must stay at 0.

## Non-goals / out of scope

- **Gap 2 (allocator priority — r8 first)** — orthogonal. Pragmas don't
  fix the allocator's reach-for-r11 behavior. Separate workstream.
- **Gap 3 (in-place literal construction)** — orthogonal. Peephole/codegen.
- **Gap 4 (entry_alias / shim-entry)** — separate; invents a new pragma
  not in SHC.
- **Non-race TUs** — defer. The tooling generalizes but we only baseline
  race_FUN_06044060 for now.

## Risks / unknowns

1. **`global_register` and lburg rule selection** — if we bind `ctx=R10`,
   every memory load through ctx should emit `@(disp,r10)` directly,
   not `mov.l ctx_addr,rX; mov.l @rX,r10; mov.l @(disp,r10)`. That's a
   non-trivial rule-selection change. Phase C.4 may expand in scope.
2. **Transitive `noregsave` legality** — SHC's rule (§3.10 note 5) says
   `noregsave` callees must be called from `regsave` callers (possibly
   through `noregalloc` bridges). Auto-generation needs to propagate
   call graph info; if a function is `noregsave` but called from some
   caller we've tagged `noregsave`, that's invalid. We may need a
   graph analysis pass that falls back to no pragma if constraints
   can't be satisfied.
3. **Cross-TU calls** — a `regsave` function in this TU calls a
   non-`regsave` function in a different TU that we haven't tagged. The
   standard ABI assumption must still hold at TU boundaries. Verify
   against prod for at least one cross-TU call before committing C.2.

## Decision log

- **2026-04-18** — workstream opened after user confirmation that
  pragma is the right mechanism. Spike (Phase A) validated the
  two-mechanism model against prod + Ghidra evidence on three
  representative functions.
