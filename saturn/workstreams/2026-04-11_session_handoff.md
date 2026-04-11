# Session handoff — 2026-04-11

Context dump from the session that wrapped up Phase 1C and
migrated the project from `D:/Projects/SaturnCompiler/` (patch-based
LCC fork) to `D:/Projects/saturncc/` (proper vendored fork of
drh/lcc with `saturn/` as a subtree). If you're a new Claude
session picking up in saturncc, read this first — it tells you
where we left off, what was decided, and what the next concrete
step is.

## Where things stand

The SH-2 backend at `src/sh.md` is functional and **passes all
regression tests** (`saturn/experiments/daytona_byte_match/` and
the internal test cases). It emits real, assembler-clean SH-2
that matches or beats Hitachi SHC on instruction counts for the
three Daytona CCE functions we've tried to byte-match:

| Function | saturncc | Hitachi SHC | Gap |
|---|---|---|---|
| FUN_06000AF8 (backup) | 16 | 17 | saturncc −1 |
| FUN_00280710 (main) | 13 | 13 | 0 |
| FUN_06004378 (backup) | 49 | ~48 | saturncc +1 |

**Instruction count parity is achieved.** True byte-for-byte
match is not — and the blocker is register allocation, not
missing optimizations.

## The one remaining gap: register allocation order

Hitachi SHC picks r14 as its first callee-saved register home.
Our backend picks r13, because r14 is reserved as a possible
frame pointer and excluded from `vmask`. Every instruction in
my output that uses a callee-saved register differs from
Hitachi's by one nibble in its opcode byte — all correct, all
equivalent, none matching.

The user wants to close this gap via **speculative two-pass
register allocation**:
 1. Run gencode with a wide `vmask` that includes r14
 2. If the function turns out to need FP (`localsize > 0` OR
    any stack-passed incoming param OR any addressable local),
    redo the allocation with r14 excluded
 3. Otherwise, keep the wide-vmask result and we match Hitachi

The chicken-and-egg problem I hit mid-session: `sizeisave` and
every r14-relative disp the body bakes in are computed DURING
gencode, so "redo" isn't a simple restart. LCC's DAG mutates
during gencode (prelabel converts ADDRF → VREG+P, ralloc assigns
`syms[RX]`, `x.state`, etc.) and those mutations are hard to
roll back.

**The user has explicitly authorized major heart surgery on the
LCC backend itself** ("evergreen compiler" model). So deep
changes to gen.c, dag.c, etc. are fair game. The right answer
probably involves:

 - **Option A:** Save DAG state, run gencode, check conflict,
   restore state, rerun with narrow vmask. State restore is
   the hard part.
 - **Option B:** Preflight analysis — before gencode, walk the
   LCC symbol table to count non-addressable locals, scan
   callee[] for i ≥ 4, walk the AST (or preprocessed token
   stream) for calls that'll have > 4 args. Then set vmask
   correctly the first time. No retry needed, but the preflight
   is fiddly.
 - **Option C:** Allocate with wide vmask always, and if
   `need_fp` turns out true AND r14 was claimed, do a
   post-gencode rename pass on the captured line buffer to
   move r14's var uses to a free register. This is hybrid
   option 1 / option 2. Mechanically feasible because
   `sh_capture_begin/end/peephole/fill_branch_delays` already
   operate on the line buffer text. Needs care to distinguish
   r14-as-FP (the `mov r15,r14` setup and `@(disp,r14)` memory
   accesses) from r14-as-var (home moves and ALU ops).

My vote is **Option C**, because it's mostly mechanical text
rewriting and avoids the DAG-state-restore rabbit hole. But
Option B is cleanest if we can figure out the preflight.

## Things I hit earlier that informed where we landed

Going backward through the session:

1. **Branch delay-slot peephole** (`sh_fill_branch_delays`) fills
   `bra/bsr/jsr/jmp; nop` pairs by scanning back past PC-relative
   pool loads as transparent intermediates. Tracks an
   `intermediate_mask` of registers written by the pool loads and
   rejects candidates that share any register. For jsr/jmp,
   the candidate must also not write the target register.
   Lives in `src/sh.md` near the bottom.

2. **Post-peephole dead-register trim.** The round-trip peephole
   (`mov rA,rB; ... ; mov rB,rA`) eliminates moves but doesn't
   update `usedmask`, so r13 was still being saved in the prologue
   even when peephole had killed its only uses. Fixed by moving
   prologue emission to AFTER peephole, rebuilding usedmask from
   surviving body lines, and gating on "body contains no `(%d,r14)`
   or `@r14` reference" (if it does, sizeisave is locked and we
   can't safely shrink saves).

3. **rts PR hazard.** `lds.l @r15+,pr` in the rts delay slot is
   forbidden by the SH-2 architecture (rts reads PR at branch
   time, races with the delay slot writing it). The backend was
   emitting it when r14 got trimmed post-peephole and PR became
   the only remaining pop. Fixed by always emitting PR's pop
   BEFORE rts and only using register pops as the delay-slot
   filler.

4. **Flush-and-epilogue bug.** The old flush loop unconditionally
   skipped `delay_idx` on the assumption the epilogue would emit
   it as the rts delay slot. When the epilogue had real pops to
   use instead, `delay_idx` got ignored and the corresponding
   body line got silently dropped. Symptom: `return y + 1`
   compiled without the `add #1,r0`. Restructured so delay_idx
   is only claimed if no pop is available.

5. **`x & 0xff` / `x & 0xffff`.** Were going through the generic
   BAND-with-pool-load path (3 instructions + pool entry).
   Added `bmask` / `wmask` nonterminals and `BANDI4(reg,bmask)`
   rules that emit a single `extu.b` / `extu.w`.

6. **`tst Rn,Rn` for zero compares.** Was loading 0 into a temp
   and doing `cmp/eq` (2 insns + loaded constant). Added `zeroi`
   / `zerou` nonterminals and `EQI4(reg,zeroi)` rules that emit
   `tst Rn,Rn` directly.

7. **Immediate-add path.** `a + 1` was going through
   `mov #1,rX; add rX,rY` (2 insns). Added `immi8` / `immu8`
   nonterminals and `ADDI4(reg,immi8)` rules at cost 0 so the
   single-instruction `add #1,Rn` wins.

8. **No double sign/zero extension on byte loads.** `mov.b` already
   sign-extends into the destination register, so the INDIRI1 /
   INDIRU1 rules used to emit a redundant `extu.b` on top that
   the subsequent CVI4/CVU4 rule doubled. Fixed by stripping the
   extension from the load rules and letting the explicit convert
   handle it.

All eight landed as separate commits in the pre-migration
history. `git log -- saturn/tools/lcc_patches/sh.md` in the
new repo walks them chronologically.

## How the migration went

1. Forked drh/lcc → github.com/AJBats/saturncc, cloned locally
   to `D:/Projects/saturncc/`
2. `git subtree add --prefix=saturn <local SaturnCompiler>` to
   merge the research project under `saturn/` with full history
   preserved
3. Applied the three patches (bind.c, input.c, makefile) as real
   commits on top of the pristine upstream clone
4. Dropped `src/sh.md` in as one big commit (granular history
   stays queryable under saturn/)
5. Deleted the obsolete patch files and build scripts from
   `saturn/tools/`, replaced with a much simpler
   `saturn/tools/build.sh`
6. Added `.gitattributes` forcing LF for text files (WSL build
   hates CRLF on sh.md — lburg's lexer chokes on `\r`)
7. Added `UPSTREAM.md` at repo root documenting the drh/lcc
   branching point (2b5cf358d9aa6759923dd7461f2df7f7f2a28471)
   and the `upstream` remote workflow
8. Added `saturn/README.md` orienting readers to the research
   project
9. Verified `build/rcc` builds cleanly and all three byte-match
   experiments still produce the expected output
10. Pushed to origin

Total migration time: ~30 minutes of my work, most of it
re-running the build to verify each step.

## If you're continuing, the next concrete action

**Go attempt Option C** (post-gencode r14 rename in the line
buffer), because it's the lowest-risk path to matching Hitachi's
register choices:

 1. In `src/sh.md`'s `progbeg`, widen `INTVAR` to include r14
    (change `0x3f00` → `0x7f00`) so the allocator can pick r14.
 2. After `sh_peephole()` and before emitting the prologue,
    detect the conflict: `need_fp` true AND `r14` appears in a
    non-FP role in the body (any line matching `r14` but NOT
    `@(disp,r14)` / `@r14` / `mov r15,r14`).
 3. If conflict, pick the lowest-numbered unused INTVAR bit and
    rename every non-FP r14 mention in the body to that reg.
    Update `usedmask` to include the new reg and exclude r14.
 4. If no conflict (r14 wasn't used as a var, or need_fp is
    false), keep r14 as allocated.
 5. Re-run the byte-match experiments and check whether
    FUN_00280710 (pure leaf, should match trivially) is now
    closer to byte-identical.

Expected wins: FUN_00280710 should drop from 13 instructions
shorter-than-Hitachi to something nearer the reference shape
since we'd pick r14 first. FUN_06000AF8 same story — its r13
save becomes r14, matching Hitachi's save-r14 prologue.

Byte match is still gated on other things too (bf/s delayed
branches, literal pool layout, control-flow structure
differences), but the register allocator move is the biggest
single lever.

## Files you should know exist

- `src/sh.md` — the backend, our main edit target
- `src/gen.c` — LCC's generic codegen; has `ralloc`, `askregvar`,
  `askreg`, `getreg`. Look at lines ~560-660 for the register
  allocation core. Currently unmodified but may need touching
  for Option A.
- `src/dag.c` — DAG construction, `emitcode`, `Code` struct,
  `codehead` list
- `saturn/experiments/daytona_byte_match/README.md` — byte-match
  results table, kept up to date
- `saturn/experiments/daytona_byte_match/FUN_*.c` and `.s` —
  hand-written source + compiled output for each attempt
- `saturn/workstreams/current_state_of_research.md` — the big
  research narrative
- `saturn/workstreams/lcc_feasibility.md` — why LCC was the
  right base

## Gotchas you'll hit

1. **$(pwd) through WSL.** The harness's Bash tool strips
   `$(...)` substitution when commands are proxied through
   wsl.exe. `saturn/tools/build.sh` avoids this with absolute
   paths from `readlink -f "$0"`. If you need the current
   directory inside a WSL-invoked command, write it as a
   literal `/mnt/d/Projects/saturncc` path rather than
   `$(pwd)`.

2. **CRLF on sh.md.** `.gitattributes` forces LF, but Windows
   autocrlf can still leave CRLF in a fresh working copy.
   If lburg errors with `invalid character \015`, do
   `rm src/sh.md && git checkout -- src/sh.md` to force
   re-checkout with LF.

3. **lburg cost overflow.** Costs are signed 16-bit. Using
   `LBURG_MAX` in a composite-rule cost expression causes wrap
   to negative when a child cost is added. Use `SH_GBR_REJECT`
   (== 30000) as the "never pick me" sentinel instead — big
   enough to dominate any real sum, small enough to not wrap.

4. **emit2 fall-through.** `INDIRxx(VREGP)` / `ASGNxx(VREGP,reg)`
   use `# read register` / `# write register` templates that
   intentionally route through emit2 but do nothing. The
   INDIR/ASGN cases in emit2 must early-return for any kid that
   isn't `ADDRG` / `ADDRF` / `ADDRL`, or they'll misinterpret
   the VREGP as a load/store target and crash.

5. **Nightshift mode.** When the user says "nightshift" they
   mean "keep going without asking — the procedure is the work,
   don't optimize it away." Autonomy means "don't wait for me,"
   not "don't be thorough."

6. **Commit discipline.** In interactive mode, don't commit
   without explicit user approval. In nightshift mode, commit
   at logical stopping points. Always include a meaningful
   multi-line commit message explaining WHY, not just WHAT.
