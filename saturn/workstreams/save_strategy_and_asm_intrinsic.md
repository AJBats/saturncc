# Save-default inversion + `__asm` intrinsic

A strategy for closing Gap #1 (save-all-range prologue) and eliminating
the need for per-function pragma forests, by:

1. **Inverting** our compiler's default save strategy to match SHC's
   "save `[lowest_written..r14]`" rule.
2. Adding an **`__asm(...)` intrinsic** for per-site exceptions.
3. Keeping the existing whole-function pragmas (`noregsave`, `noregalloc`,
   `sh_alloc_lowfirst`) for genuinely function-wide behavioral overrides.

Grounded in corpus evidence from
`saturn/tools/classify_save_matrix.py` run across all 2,308 non-skeleton
Daytona CCE prod functions (~3,744 counting label-only stubs).

## Project framing (important context)

The byte-match goal is a **verification technique**, not the end goal.
The real project is decompiling Daytona CCE so engineers can remove and
reorganise code safely. The binary is full of multi-entry functions,
shared-entrypoint patterns, and live-dead-code ambiguity that are
*vastly* easier to reason about in C than in raw .s.

Engineer-friendliness therefore constrains the strategy:

- **`.s` fallbacks are poison**: they sit outside Ghidra's call graph,
  outside C's type system, outside grep-for-callers, outside every
  tool. Splitting a function between `.c` and `.s` forks the mental
  model.
- **Pragma forests cost forever**: every `#pragma callee_preserves_r4`
  etc. is noise a future maintainer has to internalise when touching
  the function. Acceptable in small doses, corrosive at scale.
- **Inline `__asm(...)` is the sweet spot**: the function is still a C
  function for every tool. The one weird byte-match-required op gets
  to be one weird op, written verbatim, with a comment, at the point
  of use.

The right shape is what a 1996 Sega engineer would have accepted: C for
everything the compiler can match, hand-written asm dropped in exactly
where the compiler can't. Nothing more, nothing hidden.

## Corpus data (what the 2,308-function bucket study shows)

Buckets from `classify_save_matrix.py` after two bug-fixes (interleaved
prologue pushes, `.byte` raw-instruction recovery):

| Bucket          | Count |  % | Rule |
|-----------------|------:|---:|------|
| `FULL_RANGE`    |   852 | 37 | save `[lowest_written..r14]` contiguously, highest-first |
| `LEAF`          |   588 | 25 | no calls, no saves |
| `NO_SAVES`      |   755 | 33 | has `sts.l pr` but no callee-saved touched |
| `SPARSE`        |   110 |  5 | non-contiguous save pattern — different compile mode |
| `REVERSE_ORDER` |     3 | <1 | edge case |

**Simple rule coverage**: the single rule "save `[lowest_written..r14]`"
matches:

- **584 of 812 non-empty `FULL_RANGE`** (72%)
- **438 of 755 `NO_SAVES` "clean"** (58%) — empty save-set degenerate case
- **all 588 `LEAF`** — empty save-set degenerate case

Total: **1,610 of 2,308 functions (≈70% of the corpus) match by one rule
applied with zero per-function input.**

## Exceptions (why 70%, not 100%)

The residual 30% splits into three sub-populations:

### Interprocedural exceptions (~545 functions)

The biggest subclass. Bidirectional IPA that can't be detected locally:

- **Undersave** (317 `NO_SAVES` violators): functions that write
  callee-saved regs *without* saving them. SHC knew those specific
  callers didn't need the preservation. Example:
  `backup/FUN_06006880` writes r9/r10/r11/r13 but saves only r14.
- **Oversave / scheduled pushes** (228 `FULL_RANGE` mismatches): either
  pushes scheduled deeper than my scanner's window, or SHC saves extras
  beyond strict need. Example: `backup/FUN_06004A66` has
  `mov.l r12,@-r15` mid-body long after the apparent prologue.

Neither is tractable by local analysis. Requires either full IPA
(multi-week effort) or answer-key tagging.

### Different compile mode (~110 functions)

The `SPARSE` bucket. Non-contiguous save sets (e.g. `[r14, r12]`
skipping r13, or `[r11, r13]` skipping r12). Heavily clustered in the
`main` module (134 of 494 = **27%** vs 3-6% elsewhere), with ~5×
higher pool-entry density (mean 26 vs 6).

Strong evidence that `main` is mostly **hand-written assembly** linked
alongside the compiled modules — or at minimum, compiled under
different SHC flags (e.g. `-Os`). Treating it as hand-asm may be the
honest call.

### Genuine small edge cases (~40 functions)

`FULL_RANGE` functions that save but whose body has no detectable
writes. Likely artifacts of SHC's pessimistic policy (saved pre-
emptively, optimised away during build, never returned to the ledger).
Low-priority to understand.

## Three-tier implementation plan

### Tier 1: Invert the save-default in `sh.md`

Our current `sh.md` emits prologue pushes based on per-register
liveness: `usedmask[IREG] & INTVAR`. This matches no function in prod
unless every callee-saved reg we touch just happens to also be the
"lowest one dirtied" that SHC would pick.

Change: when a function dirties any callee-saved register, extend the
save-set to the contiguous range `[lowest..r14]` by default. This is
exactly what `#pragma regsave` already does — we flip it from opt-in
to default-on. Implementation hint: the logic in `sh.md`'s function()
around line 6066 that currently conditions on
`sh_func_has_attr(f->name, SH_ATTR_REGSAVE)` becomes unconditional, and
a new opt-out attribute (say `SH_ATTR_EXACTSAVE`) covers the rare
"keep the per-register precision" cases if needed.

**Expected impact**: ≈1,610 functions start matching prod's save shape
by default. All existing `#pragma regsave(...)` tags in TU source become
redundant and can be bulk-stripped. The `#pragma noregsave(...)` tags
*remain* and now express the "undersave" exception — exactly their
original SHC semantics.

### Tier 2: Keep existing whole-function pragmas

No changes needed:
- `#pragma noregsave(FN)` — function skips prologue/epilogue preservation
  (for the 317 undersave NO_SAVES violators)
- `#pragma noregalloc(FN)` — additionally remove r8..r14 from allocation
- `#pragma sh_alloc_lowfirst(FN)` — low-first allocation (for matching
  SHC's r8→r14 priority)
- `#pragma global_register(var=Rn)` — TU-wide pinning (for the r10/r11/r14
  global-register patterns from `NO_SAVES` reads)

These are **whole-function** in scope — easy to grok, limited blast
radius, rarely stacked. The pragma-forest problem doesn't apply when
pragmas are few, per-function, and semantic.

### Tier 3: Add `__asm(...)` intrinsic for per-site answer-key

Minimal spec:

```c
void FUN_06044060(int p1, int p2, int p3, int p4) {
  FUN_06044D80(p1 + 0x30);
  if (*(char *)0x06054925 != '\0') {
    /* Prod: inline 0x10000 / -0x10000 construction, matches SHC pattern */
    __asm("mov   #1, r6");
    __asm("shll16 r6");
    __asm("neg   r6, r5");
    FUN_06044F30();  /* args already set in r5,r6 by asm above */
  }
  /* r0-shim call (FUN_060450F2 takes arg in r0, not r4) */
  __asm("mov.l LP_FUN_060450F2, r3");
  __asm("jsr   @r3");
  __asm("mov   r10, r0");  /* delay slot: p4 in r0 */
  // ...
}
```

#### Implementation sketch

1. Register `__asm` as a recognised builtin name at `progbeg`.
2. In `sh.md`'s CALL emission, intercept calls to `__asm` with a string-
   literal argument. Instead of emitting a real jsr, emit the string
   verbatim into the output stream.
3. Skip all the call machinery — no arg register setup, no PR save
   pressure, no clobber accounting. The string goes through as-is.
4. Pool literal support: if the asm references a `LP_...` label, our
   existing literal-pool machinery (`shlit_*`) can be invoked via a
   second builtin — e.g. `__asm_pool_ref("FUN_060450F2")` — that
   allocates a pool entry and yields a label name the programmer can
   reference.

**Deliberate non-goals:**

- **No operand binding.** We hardcode registers because we're matching
  prod byte-for-byte, not writing portable code.
- **No clobber tracking.** If the block trashes r3, either document it
  or bracket with explicit saves in asm. Not the compiler's concern.
- **No reg allocation around asm.** The block is a black box to the
  allocator. If the surrounding C needs r3 live across it, the
  programmer handles that explicitly.
- **No register naming conventions.** Write raw `r8`, not virtual
  names. This keeps the asm literal and auditable.

That's a 30-50 line compiler change plus one line in the lexer/parser
to allow the name. No new grammar production; `__asm` is just a
function call.

## Why this beats the alternatives

| Approach | Ergonomics | Byte-match coverage | Engineer overhead |
|----------|-----------|---------------------|-------------------|
| Default per-reg liveness + pragma for every exception | Bad | Variable | Perpetual pragma maintenance |
| Split function into .c + .s hybrid | Bad | 100% | Forks call graph, tooling |
| **Invert default + `__asm` for exceptions** | **Good** | **70%+** | **Weird bits visible at site of use** |
| Full interprocedural analysis | Great (eventually) | 90%+ | Weeks of compiler work |

The hybrid `__asm` architecture lands the ergonomic sweet spot and
lets the IPA / per-site fixes be **local, explicit, findable** rather
than hidden in a pragma directive at file top.

## Phased roll-out

**Phase 1**: Invert the save-default.
- ~20-line change in `sh.md`.
- Measure corpus impact; expect large aggregate diff-count reduction.
- Bulk-strip now-redundant `#pragma regsave` tags from TU source files.
- Keep pinned baselines updated for regression detection.

**Phase 2**: Add `__asm` intrinsic.
- ~30-50 lines in `sh.md`, no grammar change.
- Write one test function demonstrating each asm pattern we want to
  enable (inline literal, r0-shim call, r4-preservation sequence).
- Verify round-trip: C with `__asm` compiles to .s with the literal
  string emitted verbatim.

**Phase 3**: Byte-match #001 with the new tools.
- Rewrite `FUN_06044060` as a 4-param C function with `__asm` blocks
  for the r0-shim calls, inline 0x10000 construction, and the
  `add #-48,r4` restore. Expect this to go from 70 → 0.
- Use it as the proof-of-concept for the architecture.

**Phase 4**: Handle the IPA exception pool.
- 317 undersave NO_SAVES functions get `#pragma noregsave(FN)` tags
  (mechanical from the bucket data).
- The residual 228 `FULL_RANGE` mismatches need per-function review;
  most should resolve to either `noregsave` tags or `__asm` blocks.
- The 110 `SPARSE` (likely hand-written, mostly `main` module) may
  get flagged as "accept as-is" — inline asm the whole function body
  if needed, or skip from byte-match scope.

## Known per-function edge cases (race_FUN_06044060 TU)

Documented here rather than in the C source (which should show only
the final-state code). Empirically observed pre- and post-flip:

- **FUN_06044060 (#001)** — 4-param signature lost by Ghidra; requires
  the Phase 2/3 `__asm` toolkit to fully close. Currently 70 diff.
- **FUN_060457e4** — IPA undersave in prod (body writes r7/r8 but
  prologue saves nothing). Under the new default: +1 line residual.
  `#pragma noregsave` makes it worse (120 → 124) — paradoxical, not
  a straightforward fix. Left untagged, accepted residual.
- **FUN_060457ac** — `#pragma noregsave` regresses 102 → 109. Prod
  body appears to use some R8..R14 regs that are saved naturally by
  the default; the pragma-stripped variant collides with our codegen.
- **FUN_0604660a** — `#pragma noregsave` regresses 94 → 96. Similar
  to 060457ac.
- **FUN_06045198** — SPARSE bucket (prod saves r8 only, not the full
  range). Under the new default, needs `#pragma noregsave` to avoid
  the full-range over-save. Currently tagged; sits at 11 diff.
- **FUN_060451aa**, **FUN_06045678** — historically regressed under
  the old "regsave + sh_alloc_lowfirst" combination. Unknown state
  under the new default; both still sit at their pre-flip baselines
  as "OK" but worth re-checking when Phase 4 sweeps per-function
  IPA tagging.

These are not blockers — they're the kind of per-function annotation
noise that Phase 4 will address by case.

## References

- `saturn/tools/classify_save_corpus.py` — simple bucket classifier
- `saturn/tools/classify_save_matrix.py` — feature-matrix classifier,
  source of the corpus numbers above
- `saturn/workstreams/gap_catalog.md` — Gap #1 entry (this doc closes
  most of it)
- `saturn/workstreams/byte_match_001_blockers.md` — #001 blocker doc,
  superseded by this strategy
- `saturn/workstreams/pragma_global_register.md` — global-register
  pragma design, still relevant for the NO_SAVES read-only-r14 pattern
