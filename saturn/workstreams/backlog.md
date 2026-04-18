# Backlog

Future workstreams deferred in favor of current priorities. Each
entry has a trigger (what would escalate it), a rough size estimate,
and context for when it came up.

## Compiler robustness: never crash, always diagnose

**Trigger to escalate:** the FUN_06044060 TU survey turned up 8
rcc crashes out of 196 functions (~4%). Every crash is a lost
debug cycle — you can't distinguish "bad C source" from "broken
compiler" from a SIGSEGV. As the corpus grows beyond the 10-function
stable set, crashes become the dominant friction.

**Desired end state:** rcc never crashes on malformed C. Every bad
input produces a diagnostic like `error: <file>:<line>: <reason>`
and exits non-zero. Matches what modern compilers (gcc, clang) do
— not what LCC originally shipped.

**Rough size estimate:** medium-to-large. Needs a review pass over
every `assert()` / null-deref path in `gen.c`, `simp.c`, `dag.c`,
and `src/sh.md`. Categorize each: (a) truly can't happen → keep;
(b) can happen on bad C → convert to diagnostic; (c) can happen on
compiler bug → keep as assert but add context. Then triage the 8
known rcc_crash cases from the TU survey as concrete forcing
functions.

**Context from this session (2026-04-18):** user raised it while
we were planning the FUN_06044060 TU grind. Agreed it's real but
could easily balloon. Deferred until per-function sanitization
work surfaces enough crash cases that they become the blocker.

## TU-aware compilation path

**Trigger to escalate:** after ~50 functions in FUN_06044060.c are
sanitized and individually byte-match against prod.

**Desired end state:** rcc emits a single .s for a multi-function
TU .c in prod's function order, with pool entries placed to match
prod's layout. Currently our compilation path is per-function;
TU-level emission with correct pool grouping is a separate
problem (touches `shlit_flush`, `sh_interleave_pool`, and the
function-order question).

**Rough size estimate:** medium. Most of the plumbing exists —
the compiler already handles multi-function .c files. What
doesn't exist is prod-order pool placement + TU-level section
directives matching prod.

## Tier-2 promotion (GNU as vs SHC as)

**Trigger to escalate:** all TU functions byte-match at tier-1
and we want to produce a drop-in .o.

**Desired end state:** `validate_byte_match_bin.sh` becomes a
commit-gate (currently diagnostic). Requires resolving GNU as vs
SHC as encoding differences (branch relaxation, ambiguous mnemonic
form, alignment padding). May require writing our own assembler
or constraining GNU as behavior.

**Rough size estimate:** large, uncertain. Research needed.
