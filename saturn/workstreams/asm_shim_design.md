# asm-shim design — `asm { ... }` as a first-class IR participant

Design doc for the asm-shim workstream: extend the SH-2 backend so
that `asm { ... }` blocks parse into the same Node-list intermediate
that C lowers to, with each asm instruction becoming an analyzable
record alongside C-derived Nodes. This is **not** a "stash text and
emit verbatim" scheme — it's a unification of asm and C in a single
intermediate so register flow, write-set analysis, and call-site
lowering all see one truth.

The faithful-byte-reproduction requirement is preserved: each parsed
asm record carries its source text, and emit replays that text
unchanged. Analysis sees structure; emit sees bytes.

## Handoff for next session

**Status:** Stage 1 (parser + IR struct) landed at commit `57e771a`.
Stage 2 is the active task: wire the parser into the IR, switch to
canonical `\t<mn>\t<ops>\n` emit, retire `__asm("...")`, mechanically
migrate FUN_06044060.c. Stage 1's parser is a self-contained library
(invoked under `-d-asm`, result discarded); Stage 2 plumbs it
end-to-end.

**The earlier scanner-based plan was retired in conversation.** A
text-only `sh_asm_writes_reg` scanner would have answered one
question (writes_r4) by re-scanning text every time, leaving every
future analysis to invent its own scanner. Worse, it would not have
addressed the actual smell in the corpus: call sites in
`FUN_06044060.c` lines 75-83 that lie about callee signatures and
rely on adjacent `__asm("...")` blocks to set up registers manually.
The compiler has no way to know those registers carry meaningful
values. Replacing the scanner with a parsed-IR foundation is the
work.

### Starting points before writing code

1. **Read this doc end to end.** The 7-stage plan in section 12 is
   the contract — each stage gets a design pass with the user
   before code lands.
2. **Read `src/sh.md`'s line-level helpers** — `sh_regs_used()`,
   `sh_parse_regmov()`, `sh_branch_target_reg()`, `sh_is_delay_safe()`.
   The Stage 1 parser shares conventions with these (SH-2 mnemonic
   matching, operand parsing).
3. **Read [FUN_06044060.c lines 70-98]
   (saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c)**
   — the "filthy" pattern this work eliminates. `FUN_06044F30()` is
   declared no-args; the call site lies; `__asm` blocks set up r5,
   r6, r7 manually; the compiler doesn't model any of this. Stage 5
   is what makes that pattern unnecessary.
4. **Read the race-module SHC-annotation census** at
   `D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
   for empirical scope (~850 race functions, 5-10% are permanent
   shims).
5. **Validate with `wsl bash saturn/tools/validate_build.sh`** every
   iteration. New regtests added per stage; existing tests stay
   green.
6. **Discuss before coding at every stage.** The temptation is to
   take shortcuts that re-introduce the scanner shape (text-level
   special-case branches). Don't.

### What NOT to do

- **Don't introduce a parallel mnemonic table.** The destination-
  detection rules live in one place — the Stage 1 parser — and
  every analysis queries `insn->writes` / `insn->reads`. New
  analyses do not get their own scanners.
- **Don't take shortcuts at stage boundaries.** Each stage has a
  validation gate that pins behavior. Skipping a stage to land a
  visible win sooner just defers the unification cost.
- **Don't touch other backends.** Lexer changes from Session 1 are
  already gated on `IR == &shIR`. The Stage 1 parser is sh.md-
  internal; no risk.
- **Don't recommend prod-.s sidecar strategies** (per
  `feedback_no_prod_sidecar_strategies.md` in user memory).
- **Don't auto-generate shims yet.** Hand-extraction of the guinea
  pig (FUN_06044F30) is fine for Stage 5. A generation script
  comes later, separately.
- **Don't pursue idiom-recognition codegen as part of asm-shim.**
  SHC-faithful arg setup (`mov #1; shll16` for 0x10000) is a
  related but separate Phase E.x workstream. Stage 5 only requires
  that proper-signature calls *work* — not that they byte-match
  prod.

## 0. Position in one paragraph

`asm { ... }` is parsed at the frontend into a list of per-
instruction records (`sh_asm_insn`), each carrying its source text
plus parsed mnemonic, operands, and reads/writes register masks.
These records become Nodes in the same Node-list intermediate where
gencoded C lowers — one Node per asm instruction, indistinguishable
in shape from C-derived Nodes for every analysis pass. The allocator
sees fixed-register usage in asm bodies and routes around it.
Phase C and future cross-function analyses (clobber narrowing, MAC,
GBR pinning) walk the Node list uniformly. At emit time, asm-derived
Nodes print their source text verbatim; C-derived Nodes go through
the normal `IR->emit2`. The result: prod functions become first-class
IR participants without C decompilation, mixed C+asm functions stop
needing call-site lies, and the IPA mechanism fires on real corpus
functions.

## 1. Decisions locked in

**D1 (syntax surface):** `asm { ... }`. Replaces the existing
`__asm("...")` one-liner. Single unified construct for both one-line
inline asm and multi-line whole-function bodies. Landed in Session 1.

**D2 (source ownership):** prod-derived asm shims are checked in as
owned source code in the appropriate TU's `.c` file. NOT a sidecar
artifact. (Per `feedback_no_prod_sidecar_strategies.md`.)

**D3 (guinea pig):** FUN_06044F30 in the `race_FUN_06044060` TU. End-
to-end success criterion: Stage 5 lands, the call site at
FUN_06044060.c:73-84 stops using `__asm("...")` setups, the call
becomes `FUN_06044F30(p1+0x30, ...)` with proper args, the IPA pin
engages, FUN_06044060's diff drops materially, and byte-match holds.

**D4 (foundation, not scanner):** asm parses to a structured IR shared
with C. No parallel text scanners; one source of truth per analysis.
This is the substance of the redesign.

**D5 (normalization round-trip):** the contract is **assembled-byte
equivalence**, not source-text equivalence. The parser tokenizes the
asm body and discards presentational whitespace (alignment, leading
indent, trailing spaces). The emitter re-formats every asm
instruction in the same canonical layout the C-derived emit already
uses (`\t<mnemonic>\t<operands>\n`). Result: one uniform whitespace
style across the entire `.s` file; downstream `asm_normalize.py`
strips whitespace anyway; what matters is the assembled `.o` bytes
match prod, which they do because the canonical form contains
exactly the same instructions and operands as the input.

`src_text` survives in `sh_asm_insn` as a **diagnostic field**
(used by `-d-asm` dumps and for source-line context in error
messages). Emit does not read it.

**D6 (memory is not a constraint):** the host machine is not memory-
bound. If denormalizing data (carrying both raw text and parsed
records) simplifies architecture, do it.

## 2. Why we need this

### 2a. The lines-75-83 problem

`FUN_06044060.c` today has this pattern:

```c
__asm("mov #1, r6");
__asm("shll16 r6");
__asm("neg r6, r5");
__asm("mov r6, r7");
FUN_06044F30();   // declared no-args. lies.
```

The C call says no args. The `__asm` setups happen to leave r5, r6,
r7 in the right state. The compiler has no model of this — the
asm sites are opaque and the call site is bare. It works because:

  - The allocator doesn't know to allocate r5/r6/r7 between the asm
    setups and the call.
  - Nothing in the IR encodes "this asm produced an arg for the call
    below."
  - The delay-slot filler happens not to move anything that would
    clobber r5/r6/r7 into the gap.

Any one of those held coincidences breaks → silent miscompile. The
fix is to give the IR a model of asm register flow so the call site
can stop lying.

### 2b. The catch-22 today (still relevant)

Phase C's writes_r4 cache walks each in-queue function's captured
DAG. Externs default to conservative `writes_r4 = 1`. For
FUN_06044060 specifically, 4 of 5 callees correctly answer
"preserves r4"; the fifth (FUN_06044F30) is extern and vetoes the
predicate. The IPA pin therefore never engages.

The asm-shim cut: bring uncompleted callees into the TU as asm-
bodied functions. Each shim's parsed IR participates in Phase C's
analysis. When the analysis can answer "writes_r4=0" from the
parsed body, the pin engages. When the call site stops lying about
its signature (Stage 5), the surrounding C also gets the right
codegen.

### 2c. Beyond IPA — the foundation argument

Once asm parses into the same IR as C, every cross-function
analysis the project will eventually need works the same way:

  - **Register-clobber narrowing for non-r4 regs.** Same pattern as
    writes_r4 — query each function's parsed body for "does any
    instruction write rN?". One walk, all registers, all functions.
  - **MAC-state tracking.** Does this callee touch MACL/MACH? The
    asm Node's `writes_sreg` mask answers it.
  - **GBR-pinning analysis.** Does this callee preserve GBR? Same.
  - **Cross-call liveness for non-IPA cases.** The allocator's
    awareness of asm-side register usage (Stage 5) generalizes to
    any future "what's live across this call?" question.

Each of those analyses is a function over the parsed IR, not a new
scanner. That's the payoff.

### 2d. Scope of the asm-shim era — what the census tells us

`D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
(2026-04-24, 850-function census across all 39 race-module TUs):

  - **~33% of race-module functions decomp to ordinary C.** Asm
    shims are temporary scaffolding for these.
  - **~33% need a single annotation.** Same — shim is a scaffold.
  - **~35% need 2+ annotations**, concentrated in 4 specific TUs.
    Most still decomp-able with effort.
  - **~5-10% legitimately uneconomical to express in C** (anchor:
    FUN_0604C76C's 7-entry software-pipelined chain). The shim is
    their permanent home.

Single biggest annotation burden: **Cat 3 (gbr / unsaved-callee-
save) at ~36% of all functions.** Hardening `#pragma global_register`
at scale is parallel to the asm-shim work; the parsed-IR foundation
also helps it (clobber analysis sees gbr writes via `writes_sreg`).

The 5-10% permanent-shim minority is part of why round-trip
preservation is a first-class design goal, not a transitional one.

## 3. The `asm { ... }` syntax (Session 1, landed)

Already implemented. See commit `7975c40` and tests 4ad–4ag in
validate_build.sh. Recap:

  - **Statement-level**: `asm { mov r1, r2 }` inside a C function.
    Captures the body verbatim, builds an ASMB tree node carrying
    raw text. Replaces `__asm("...")`.
  - **File-scope**: `int FUN_06044F30(int p1) asm { ... }` declares
    a function whose body is asm. Currently emits with prologue/
    epilogue wrap; Stage 4's naked emit will skip the wrap.
  - **Round-trip preservation through the lexer**: bytes between
    `{` and `}` are captured exactly; leading whitespace not
    stripped, escape sequences not interpreted.
  - **Empty `asm{}`** allowed, emits nothing.
  - **Gated to SH target** (`IR == &shIR`); other backends see
    `asm` as ID.

What Session 1 did **not** do: parse the captured text. That's
Stage 1.

## 4. Stage 1: parsed-asm IR + parser

The Stage 1 deliverable is the parser as a self-contained library —
data structures + parsing function + regtests. **No frontend
integration**, **no analysis hookup**, **no emit changes**. Output
of every existing test is byte-identical to before.

### 4a. Data structures (lives in `src/sh.md`)

```c
enum sh_operand_kind {
    SH_OP_NONE,
    SH_OP_REG,        /* r0..r15 */
    SH_OP_SREG,       /* pr, gbr, vbr, sr, mach, macl, t */
    SH_OP_IMM,        /* #imm */
    SH_OP_MEM,        /* @rN, @-rN, @rN+, @(disp,rN), @(R0,rN),
                       *   @(disp,GBR), @(disp,PC) */
    SH_OP_LABEL,      /* bare identifier — branch target, pool sym */
};

enum sh_mem_mode {
    SH_MEM_INDIR,     /* @rN */
    SH_MEM_PREDEC,    /* @-rN */
    SH_MEM_POSTINC,   /* @rN+ */
    SH_MEM_DISP,      /* @(disp,rN) */
    SH_MEM_R0IDX,     /* @(R0,rN) */
    SH_MEM_GBRDISP,   /* @(disp,GBR) */
    SH_MEM_PCDISP,    /* @(disp,PC) — PC-relative loads */
};

enum sh_sreg {
    SH_SR_PR=0, SH_SR_GBR, SH_SR_VBR, SH_SR_SR,
    SH_SR_MACH, SH_SR_MACL, SH_SR_T,
    SH_SR_COUNT,
};

struct sh_operand {
    enum sh_operand_kind kind;
    int reg;              /* SH_OP_REG, SH_OP_MEM: base/only reg */
    enum sh_sreg sreg;    /* SH_OP_SREG */
    long imm;             /* SH_OP_IMM, SH_OP_MEM disp */
    char *label;          /* SH_OP_LABEL: label name */
    enum sh_mem_mode mem_mode;  /* meaningful for SH_OP_MEM */
};

struct sh_asm_insn {
    char *src_text;       /* original source line — round-trip
                           * handle. Trailing newline included. */
    char *mnemonic;       /* canonicalized: "mov.l", "add",
                           * "jsr", ".long", ... NULL on
                           * unparseable lines (is_unknown=1). */
    int n_operands;       /* 0..3 */
    struct sh_operand operands[3];

    unsigned reads;       /* GP reg bitmask (bit N = rN read) */
    unsigned writes;      /* GP reg bitmask (bit N = rN written) */
    unsigned reads_sreg;  /* bitmask indexed by enum sh_sreg */
    unsigned writes_sreg; /* same */
    unsigned char is_branch;
    unsigned char is_call;     /* bsr/jsr — implicit pr write */
    unsigned char is_directive;
    unsigned char is_label;    /* whole line is a label def */
    unsigned char is_comment;  /* whole line comment / blank */
    unsigned char is_unknown;  /* parse failed; conservative masks */
    int line_no;
};

struct sh_asm_body {
    struct sh_asm_insn *insns;
    int n_insns;
    int n_capacity;
    char *raw_text;       /* original whole-block content */
};
```

Per [discussion]: per-operand `src_text` fields are dropped —
`insn->src_text` round-trips the whole line, that's enough.
Memory is not a constraint, but unused fields are still noise.

### 4b. Parser scope

The parser handles SH-2 instruction syntax actually present in the
race-module corpus:

  - **Mnemonics**: full SH-2 instruction set + size suffixes
    (`mov`, `mov.b/w/l`, `add`, `add.l`, `cmp/eq`, `cmp/hs`, ...,
    `bt`, `bt/s`, `bf`, `bf/s`, `bsr`, `bsr/s`, `jsr`, `rts`, `nop`,
    `dt`, `swap.b/w`, `xtrct`, `extu.b/w`, `exts.b/w`, `mac.l`,
    `mac.w`, `mul.l`, `dmuls.l`, `dmulu.l`, `muls.w`, `mulu.w`,
    `lds`, `lds.l`, `sts`, `sts.l`, `ldc`, `ldc.l`, `stc`, `stc.l`,
    `clrt`, `sett`, `clrmac`, `tst`, `tas.b`, `trapa`, `rotl`,
    `rotr`, `rotcl`, `rotcr`, `shll`, `shll2`, `shll8`, `shll16`,
    `shlr`, `shlr2`, `shlr8`, `shlr16`, `shal`, `shar`, `not`,
    `neg`, `negc`, `addc`, `addv`, `subc`, `subv`, `div0s`, `div0u`,
    `div1`, `and`, `or`, `xor`, ...).
  - **Register operands**: `r0`–`r15`. Special: `pr`, `sr`, `gbr`,
    `vbr`, `mach`, `macl`, `t`. `R0` and `r0` both accepted.
  - **Immediates**: `#1`, `#0x10`, `#-16`, `#FOO` (label-as-imm).
  - **Memory addressing**: full set in `sh_mem_mode`.
  - **Labels**: bare identifiers at operand position; `^label:`
    lines.
  - **Directives**: `.long N`, `.short N`, `.word N`, `.byte N`,
    `.align N`. Pool entries inside shims.
  - **Comments**: trailing `! ...`, trailing `; ...`, whole-line
    `/* ... */`.

**Conservative on parse failure**: any line the parser can't classify
gets `is_unknown=1`; `reads = writes = 0xFFFF` (all GP regs);
`reads_sreg = writes_sreg = ~0u`. Asm-shim work doesn't fail; analyses
just lose precision for that line.

### 4c. Destination detection (the rule that matters)

For each parsed mnemonic, the parser knows which operand slot is the
destination, plus any implicit register effects:

  - `mov rA, rB` → write rB.
  - `mov.X @rN+, rM` → write rM AND write rN (post-inc).
  - `mov.X rM, @-rN` → write rN (pre-dec); no GP-reg write target.
  - `add #imm, rN` → write rN.
  - `add rA, rB` → write rB.
  - `dt rN` → write rN, write t.
  - `shll{,2,8,16} rN`, `shlr*`, `swap.X rN` → write rN.
  - `cmp/eq rA, rB` → reads only; write t.
  - `jsr @rN` / `bsr label` → write pr.
  - `lds rA, pr` → write pr; reads rA.
  - `sts pr, rA` → write rA; reads pr.
  - `mul.l rA, rB` / `dmuls.l rA, rB` → write macl (and mach for
    `dmuls.l`/`dmulu.l`).
  - ...

The full table lives in the parser. Adding a mnemonic = adding one
table entry. No analysis-side rule duplication.

### 4d. The parsing function

```c
struct sh_asm_body *sh_parse_asm_text(const char *text);
```

Walks `text` line-by-line, splits each line on `\n`, runs each
through a tokenizer + per-mnemonic dispatch, accumulates into a
freshly-allocated `sh_asm_body`. PERM-allocated so it lives across
function-emit boundaries.

### 4e. `-d-asm` dump flag

Compiler flag `-d-asm` causes the parser, when invoked, to print a
human-readable dump of the parsed structure for each block:

```
[asm] FUN_06044F30 body, 6 insns:
  [0] sts.l   pr,@-r15      reads={r15} writes={r15} writes_sreg={pr}
  [1] mov.l   LP0,r3        reads={pc} writes={r3}
  [2] jsr     @r3           reads={r3} writes={pr} branch=yes call=yes
  [3] nop                   reads={} writes={}
  [4] rts                   reads={pr} writes={} branch=yes
  [5] LP0:    .long _func   directive=yes label=yes
```

This is what regtests grep against — Stage 1 has no other observable
behavior.

### 4f. Wire the parser in (Stage 1 minimum)

To exercise the parser without committing to integration: in
`emit2`'s `LABEL+V` case (the existing ASMB-lowered Node), if the
sentinel matches AND `-d-asm` is on, run `sh_parse_asm_text(name)`
and print the dump. Discard the result. No other compiler behavior
changes.

This keeps Stage 1's blast radius zero — every existing `.s` file
output is byte-identical to before.

### 4g. Stage 1 validation gate

Three new regtests in validate_build.sh + the existing tests stay
green:

1. **Round-trip**: a representative asm slice is run through
   `sh_parse_asm_text` (via `-d-asm` dump), the dump's `src_text`
   fields are concatenated, and the result is compared to the
   original input. Byte-identical.
2. **Destination detection**: a hand-written corpus exercising every
   write-category from §4c. The dump's `writes` masks match the
   expected register set.
3. **Conservative-on-unknown**: a deliberately bad mnemonic produces
   `is_unknown=1` and `writes=0xFFFF` in the dump.

**Validation gate:** all 46 existing tests pass; 3 new regtests
pass; output `.s` byte-identical to HEAD on the whole corpus.

## 5. Stage 2: frontend wiring + canonical emit + retire `__asm`

Stage 2 absorbs the work that v1 deferred to Stage 7. By the end of
this stage: `__asm("...")` is gone, all sites in FUN_06044060.c are
rewritten to `asm { ... }`, and the IR carries parsed asm Nodes
through to a canonical re-emission.

### 5a. Frontend wiring

The `Interface` struct (c.h) gains a backend-specific hook:

```c
struct Xinterface {
    ...
    struct sh_asm_body *(*parse_asm)(const char *text);  /* nullable */
};
```

SH backend fills it in with `sh_parse_asm_text`; other backends
leave it null.

`asm_block(text)` in expr.c calls `IR->x.parse_asm(text)` if non-
null and stashes the result via `Xsymbol` on the ASMB tree node's
Symbol. Other backends keep the legacy text-only path.

### 5b. New op code + Node lowering

  - `ASM_INSN+V` added to `ops.h`, parallel to `LABEL+V`.
  - `listnodes()` ASMB lowering checks for an attached
    `sh_asm_body`. If present, it walks the parsed insn list and
    emits **one ASM_INSN Node per parsed instruction**, each with
    `syms[0]` carrying that instruction's `sh_asm_insn` record (via
    `Xsymbol`) plus `src_text` for diagnostic use.
  - If no parsed body is attached (e.g., non-SH backend, or future
    fallback), legacy LABEL+V emit still works.

### 5c. Canonical emit

`emit2`'s ASM_INSN+V case formats the parsed instruction in the
**same canonical layout C-derived emit produces**:

  - `\t<mnemonic>\t<operands>\n`
  - Operands joined by `,` with no surrounding whitespace.
  - Memory operands re-emitted in canonical form: `@rN`, `@-rN`,
    `@rN+`, `@(N,rN)`, `@(R0,rN)`, `@(N,GBR)`, `@(N,PC)`.
  - Immediates: `#N` (decimal) or `#0xN` (hex) — match what existing
    C-derived emit chooses for a given value.
  - Labels: bare label name, no decoration.
  - Directives (`.long _foo`): `\t.long\t_foo\n`.
  - Standalone label lines (`LP0:`): `LP0:\n`.

Result: every line in the output `.s` uses the same whitespace
convention regardless of whether it came from C codegen or asm
parsing. Easier to string-match against prod `.s` (after both go
through `asm_normalize.py`); downstream byte-match against `.o`
is unaffected because the assembled bytes only depend on the
instruction + operands, not the whitespace.

**Why this is safe**: the SH-2 assembler treats
`sts.l\tpr,@-r15`, `sts.l   pr, @-r15`, and `sts.l pr,@-r15` as the
same instruction. The user-visible goal (byte-matching `.o` files)
is invariant under this normalization.

### 5d. Retire `__asm("...")` + migrate FUN_06044060.c

  - Mechanically convert every `__asm("text")` call site in
    `FUN_06044060.c` to `asm { text }`.
  - Delete `asm_intrinsic()` from `src/expr.c` and its dispatch
    from `primary()`.
  - Delete the `__asm` regtest (4ac); replacement coverage is
    already provided by 4ad–4ag.
  - Update Session 1 regtests 4ad–4ag: their expected output
    changes from "user's original whitespace verbatim" to
    "canonical `\t<mn>\t<ops>\n`." Same content, different
    formatting expectation.

The bare-signature call pattern at FUN_06044060.c lines 73-95
(`__asm` register setups followed by `FUN_06044F30()` with no args)
**stays as-is** for Stage 2 — it just uses the new syntax. The
structural fix (proper-signature calls + allocator awareness)
lands in Stage 5.

### 5e. Stage 2 validation gate

  - All 49 existing tests still pass after regtest updates for
    canonical-emit expectations.
  - `__asm` symbol gone from the codebase (`grep __asm src/*.c
    src/*.md` returns nothing functional).
  - `FUN_06044060.c` builds clean and the TU byte-match metric is
    stable (re-pin if canonical emit changes diff counts —
    documented in the commit, not ignored).
  - The IR pipeline plumbs parsed asm bodies end-to-end: Tree →
    Node list (N ASM_INSN Nodes) → emit (N canonical lines).

## 6. Stage 3: Phase C writes_r4 from IR

`sh_analyze_writes_r4` walks `e->code_head`'s Node list. For each
ASM_INSN Node, query the attached `sh_asm_insn->writes & (1u << 4)`.
For every other Node kind, fall back to the existing DAG-walking
logic.

End-to-end test: a synthetic TU with an asm-bodied callee that
visibly does or doesn't touch r4 — `-d ipa` shows writes_r4
correctly.

The same mechanism extends to other registers / clobbers /
sregs without changing the analysis frame. New analysis = new
function over Nodes; no new scanner.

**Stage 3 validation gate:** synthetic regtest proves writes_r4
correct for asm-bodied callees. All other behavior unchanged.

## 7. Stage 4: naked emit

When a function's body is **entirely** asm-derived (the IPA queue
entry's Gen Code has only ASM_INSN Nodes plus framing Code records,
no C-derived Nodes), `sh_process_deferred_fn` takes a fast path:

  1. Emit `.global` + `.text` + `.align` + `func_label:`.
  2. Emit each ASM_INSN's `src_text` verbatim.
  3. Skip prologue, epilogue, param homing, callee-saved push/pop,
     pool flush.
  4. Restore allocator masks, clear `sh_ipa_current`.

A whole-function shim with proper signature (file-scope `int
foo(int p1) asm { ... }`) emits its body bytewise unchanged.

**Stage 4 validation gate:** a 1-function naked asm-shim test file
emits exactly the input bytes. No prologue, no epilogue, no synthetic
return.

## 8. Stage 5: mixed C+asm — allocator visibility

The big one — the lines-75-83 fix.

For statement-level `asm { ... }` inside a C function, the parsed
ASM_INSN Nodes sit alongside C-derived Nodes in the same Gen Code.
The register allocator's freemask tracking honors each ASM_INSN's
`reads`/`writes` masks: registers used by asm are unavailable to the
allocator within the asm's live range.

This unlocks proper-signature calls. `FUN_06044060.c` lines 75-83
become:

```c
FUN_06044F30(p1 + 0x30, /* args set up by C codegen */);
```

with no `__asm` setup blocks. The compiler picks register sequences
that satisfy the call ABI; if those don't byte-match prod's
SHC-faithful idioms (e.g., `mov #1; shll16` vs pool load), the
existing per-call-site `__asm` pinpoint mechanism still works for
that gap. But the *signature is honest* and the allocator is
*aware*.

**Stage 5 validation gate:** FUN_06044060.c with proper signatures
for the `__asm`-setup-then-call cluster. `__asm` blocks for
register-arg setup are **deleted**; the call sites carry the args.
TU byte-match holds (ideally improves once IPA fires).

## 9. Stage 6: pool isolation

A whole-function asm shim's internal `.long _func_0x06044d80` pool
entries must NOT merge with the compiler's `shlit` pool. The
ASM_INSN-Node structure tags directives (`is_directive=1`) — naked
emit (Stage 4) already skips `shlit_flush`, so the shim's pool
entries print as part of its own ASM_INSN sequence.

For mixed C+asm functions where the C body uses the `shlit` pool and
the asm block also has directives, two pool sources coexist in
sh_lines but never collide because the asm-derived directives have
their own labels (`LP0:`, etc.) and the compiler's pool uses
genlabel'd `Lnnn:` labels in a different namespace.

**Stage 6 validation gate:** an asm-bodied shim with internal pool
entries emits with no merge / collision. A mixed C+asm function with
both pool sources emits both correctly.

## 10. Stage 7: (absorbed into Stage 2)

The mechanical migration of `__asm("...")` sites to `asm { ... }`
and deletion of `asm_intrinsic()` was originally Stage 7. Folded
into Stage 2 (§5d) per design v3 conversation: doing it later means
two emission paths coexist during transition (legacy raw-print for
`__asm`, canonical for `asm{}`) — pulling the migration forward
keeps the pipeline single-path from Stage 2 onward.

The structural follow-up — converting bare-signature call patterns
(`__asm("mov X, rN"); FUN_X();`) to proper-signature calls
(`FUN_X(arg);`) — depends on Stage 5's allocator awareness and
stays in Stage 5.

## 11. Normalization round-trip invariant

The contract is **assembled-byte equivalence**, not source-text
equivalence:

  - For an asm-derived instruction with mnemonic M and operand
    list (op1, ..., opN), the emitted line assembles to the same
    bytes as the user-written input would have assembled to.
  - Whitespace is canonicalized to the project's standard layout.
    `asm_normalize.py` strips whitespace differences anyway; the
    `.o` byte-match (the actual project goal) is whitespace-blind.

Sources of potential drift to head off:

  - **Operand-form drift**: `mov.l @r4, r3` and `mov.l @(0,r4), r3`
    assemble to different bytes (different addressing modes). The
    parser preserves the user's choice; the emitter prints the
    SAME form. Don't auto-canonicalize `@(0,r4)` → `@r4` or vice
    versa.
  - **Immediate base drift**: `#16` and `#0x10` assemble to the
    same byte; pick one form per emitted line. Default: print
    decimal for small values, hex for typical-mask values
    (mirroring how existing C-derived emit chooses).
  - **Label rewrites**: don't rewrite labels embedded in asm bodies.
    `LP0:` defined inside an `asm { ... }` is part of that block's
    addressable contents; renumbering it (as the compiler's own
    `genlabel` machinery does for C-derived labels) breaks
    references inside the same block.
  - **Peephole rewrites of `sh_lines[]`** — asm-derived sh_lines
    entries are tagged immutable in Stage 5+. Peephole passes
    already test `sh_lines[j][0] == 0` for killed lines; we add a
    parallel "is from asm" mask that peephole respects.

A regtest at every stage asserts this for a representative asm slice
(parse + emit → run through `sh-elf-as` → compare assembled bytes
to a reference).

## 12. Sequencing & TODOs

Each stage is a session with its own design-pass-then-implementation
gate. **The user is in the loop at each design pass — no shortcut
to "next stage" without explicit agreement.**

### Stage 1 — parsed-asm IR + parser (active)

  - [ ] Define `sh_asm_insn`, `sh_asm_body`, `sh_operand`, enum
        types in `src/sh.md`.
  - [ ] Implement `sh_parse_asm_text(text)`: tokenize, mnemonic
        dispatch, operand parsing, reads/writes mask computation,
        directive/label/comment classification, conservative-on-
        unknown.
  - [ ] Add `-d-asm` flag handling in progbeg argv loop.
  - [ ] Wire parser invocation into `emit2`'s LABEL+V case under
        `-d-asm` (dump-only; result discarded).
  - [ ] Regtest: round-trip preservation (src_text concat == input).
  - [ ] Regtest: destination detection per write-category.
  - [ ] Regtest: conservative-on-unknown.
  - [ ] **Validation gate:** `validate_build.sh` 46/46, plus 3 new
        Stage 1 regtests, output `.s` byte-identical to HEAD.

### Stage 2 — frontend wiring + canonical emit + retire `__asm`

  - [ ] Add `IR->x.parse_asm` hook in c.h's `Xinterface`. SH fills
        it in with `sh_parse_asm_text`; other backends leave it
        null.
  - [ ] `asm_block()` in expr.c calls the hook (if non-null) and
        attaches the parsed body via `Xsymbol` on the ASMB tree
        node's Symbol.
  - [ ] New `ASM_INSN+V` op code in `ops.h`.
  - [ ] `listnodes()` ASMB lowering: produces N ASM_INSN Nodes
        when a parsed body is attached, one per insn. Each Node's
        `syms[0]` carries the `sh_asm_insn` record (Xsymbol) +
        diagnostic `src_text`.
  - [ ] `emit2` ASM_INSN+V case: re-formats from the parsed insn
        in canonical `\t<mn>\t<ops>\n` layout. Operand printers
        for REG / SREG / IMM / MEM / LABEL.
  - [ ] Delete `asm_intrinsic()` and its dispatch from `primary()`.
  - [ ] Mechanical migration: convert all `__asm("...")` sites in
        `FUN_06044060.c` to `asm { ... }` (one-to-one syntax swap).
  - [ ] Update Session 1 regtests 4ad–4ag to expect canonical-
        format output instead of user-original whitespace.
  - [ ] Delete regtest 4ac (the `__asm` regtest) — replaced by
        4ad–4ag.
  - [ ] **Validation gate:** all tests pass post-update; `__asm`
        symbol gone from the codebase; FUN_06044060 TU byte-match
        re-pinned with documented diff (canonical emit may shift
        whitespace-driven counts; the metric stays trustworthy
        because both prod and ours go through `asm_normalize.py`).

### Stage 3 — Phase C writes_r4 from IR

  - [ ] `sh_analyze_writes_r4` walks Nodes; ASM_INSN Nodes query
        attached `insn->writes & (1<<4)`.
  - [ ] Synthetic regtest: asm-bodied callees with/without r4
        writes — `-d ipa` shows writes_r4 correctly.
  - [ ] **Validation gate:** synthetic regtest passes; all other
        tests unchanged.

### Stage 4 — naked emit

  - [ ] `sh_function_is_naked_shim(e)` helper: returns 1 iff the
        function body's Gen Code contains only ASM_INSN Nodes.
  - [ ] `sh_process_deferred_fn` fast-path: skip prologue/epilogue/
        pool flush; emit ASM_INSN nodes' `src_text` directly.
  - [ ] Regtest: naked function emits exact input bytes (no wrap).
  - [ ] **Validation gate:** existing tests green; naked-emit
        regtest passes.

### Stage 5 — mixed C+asm allocator awareness

  - [ ] Allocator's freemask honors ASM_INSN Nodes' reads/writes
        masks within their live range.
  - [ ] FUN_06044060.c: replace `__asm` register-arg-setup blocks
        with proper-signature C calls. Old `__asm("mov X, rN")`
        sites for arg setup go away.
  - [ ] **Validation gate:** TU byte-match holds; IPA pin engages;
        FUN_06044060 diff drops materially.

### Stage 6 — pool isolation

  - [ ] Mixed C+asm: shim pool labels coexist with `shlit` pool
        without collision.
  - [ ] Regtest: a representative shim with internal pool emits
        cleanly inside a TU that also has C-derived pool entries.
  - [ ] **Validation gate:** new regtest passes; existing pool-
        emission regtests unchanged.

### Stage 7 — (absorbed into Stage 2)

The mechanical `__asm("...")` retirement and FUN_06044060.c
syntax migration are now part of Stage 2 (§5d). The structural
follow-up — converting bare-signature call patterns to proper-
signature calls — depends on Stage 5's allocator awareness and
remains in Stage 5.

## 13. Out of scope (stays out)

  - **Auto-generation of shims from prod.** Hand-extraction of one
    function (FUN_06044F30 for Stage 5) is the bring-up. A
    generation script comes later as its own workstream.
  - **Multi-entry-point support.** FUN_06044F30 ↔ FUN_06044E3C
    body sharing. The shim duplicates bytes for now; collapse
    happens in a separate workstream.
  - **Asm globals / file-scope data via asm.** `asm { .long X }`
    at file scope outside a function definition. Not needed.
  - **GCC-style `asm("..." : outputs : inputs : clobbers)` syntax.**
    Powerful but a much bigger surface; the parsed `sh_asm_insn`
    masks are sufficient for our use case.
  - **SHC-faithful idiom recognition in arg setup** (`mov #1;
    shll16` for 0x10000 vs pool load). A separate codegen workstream
    enabled by but not part of asm-shim.
  - **Promoting permanent-shim functions to C.** The 5-10% that
    are uneconomical to express in C stay as asm shims forever.

## 14. Open questions for implementation

  - **`-d-asm` dump format**: human-readable for grep regtests, or
    structured (JSON / TSV) for tooling? Default: human-readable
    until tooling demands change.
  - **ASM_INSN Node Symbol payload**: extend Symbol's union with
    a new struct, or use Xsymbol to attach the parsed insn? Lean
    Xsymbol — keeps Symbol clean.
  - **Mnemonic table location**: static struct array in sh.md, or
    pulled into a header? Default: static in sh.md, near the
    line-level helpers (`sh_regs_used`, `sh_parse_regmov`, etc.).

## 15. Strategic context — race-module census (unchanged)

`D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
(2026-04-24) — the empirical baseline. Headlines:

  - 850 functions across 39 race-module TUs.
  - ~33% completely clean.
  - ~33% one annotation.
  - ~35% 2+ annotations, concentrated in 4 specific TUs.
  - ~5-10% legitimately permanent shims.

Cat 3 (gbr / unsaved-callee-save) at ~36% of all functions remains
the single biggest annotation burden. The parsed-IR foundation also
helps `#pragma global_register` hardening — clobber analysis sees
gbr writes via `writes_sreg`, eliminating a class of false-positives
where extern callees are conservatively assumed to clobber gbr.

End of design.
