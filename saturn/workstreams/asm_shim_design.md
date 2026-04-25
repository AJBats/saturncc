# asm-shim design — `asm { ... }` for unity-build IPA

Design doc for the next major workstream: extend the SH-2 frontend with
a unified `asm { ... }` construct so prod functions can be brought into
our TUs as asm shims that participate in IPA analysis. This unblocks
the per-TU "unity build" needed to make the IPA r4 mechanism (Phase
E.1b, landed) actually fire on real corpus functions.

## Handoff for next session

**Status:** design landed, no implementation yet. IPA Phase E.1b
infrastructure is on master (commits `943a487` + `a33e79e`); the
asm-shim work is the bridge from "infrastructure exists" to
"infrastructure fires on the corpus."

**If you're picking this up now, your task is Session 1 of the
asm-shim plan: implement the `asm { ... }` lexer + parser.** See the
TODO checklist in section 12 below for concrete items.

### Starting points before writing code

1. **Read this doc end to end.** Decisions in section 1 are locked.
   Open questions in section 14 are still open and need to be settled
   in conversation with the user, not inferred.
2. **Read the race-module SHC-annotation census** at
   `D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
   for empirical context on how this work fits into the broader project.
3. **Read `src/expr.c:411`** (`asm_intrinsic()`) — the existing
   `__asm("...")` parser. Your `asm { ... }` work will reuse the
   downstream machinery (the `ASMB+V` tree node, the Symbol-with-text
   pattern). This is the closest existing template.
4. **Read `src/lex.c`** to understand the tokenizer. Section 4 of this
   doc spec'd a "raw-text mode" mode-switch — that's where it lives.
5. **Read `src/decl.c`** for function-definition parsing. File-scope
   `int FOO(int p) asm { ... }` as a function body needs a hookup
   there.
6. **Validate with `wsl bash saturn/tools/validate_build.sh`** every
   iteration. 42/42 must keep passing plus any new asm-shim regtests.
7. **Talk to the user before coding.** Section 14's open questions —
   inferred-naked vs `#pragma naked`, statement-level placement
   rules, empty-block handling — should be settled in conversation.

### What NOT to do

- Don't try to do all three sessions in one go. Each has its own
  validation gate; ship them independently.
- Don't touch the IPA backend (Phases A through E.1b). It's done and
  validated. The asm-shim work feeds it new data; it doesn't modify
  it.
- Don't touch other backends (alpha.md, mips.md, sparc.md, x86.md,
  x86linux.md). Lexer changes in `src/lex.c` are shared, so be
  careful: the `asm` keyword recognition has to be SH-only or
  guarded by an Xinterface flag so the other targets see no
  behavior change.
- Don't auto-generate shims from prod yet (out-of-scope per
  section 13).
- Don't implement multi-entry-point support (out-of-scope; will
  come later as a separate workstream).
- Don't recommend prod-.s sidecar strategies (per
  `feedback_no_prod_sidecar_strategies.md` in user memory).

## 0. Position in one paragraph

Add a single new C-level construct `asm { ... }` that captures a block
of raw text as a function body (or as a statement-level instruction
sequence inside a C function). The lexer enters a raw-text mode on
seeing `asm{`, slurps characters until the matching `}`, and emits the
captured bytes verbatim at code-emit time (no prologue/epilogue
wrapping for whole-function shims). Phase C's `writes_r4` analysis
gains an asm-body scanner that reads the captured text and answers
the same question it answers for DAG-bodied functions. The result:
prod functions become first-class participants in the IPA cgraph
without requiring C decompilation, the round-trip is bytes-in =
bytes-out for shim bodies, and the catch-22 that today gates IPA on
FUN_06044060 dissolves.

## 1. Decisions locked in

**D1 (syntax surface):** `asm { ... }`. Replaces the existing
`__asm("...")` one-liner. Single unified construct for both one-line
inline asm and multi-line whole-function bodies. Rationale: per-line
quoting tax on string-literal forms doesn't scale to 900-function
mass import; one syntax avoids "messy room" coexistence; raw block
content gives bytes-in = bytes-out by construction (no
lexer-unescape-then-reescape round-trip risk).

**D2 (source ownership):** prod-derived asm shims are checked in as
owned source code in the appropriate TU's `.c` file. Mass conversion
from prod is one-time translation (manual or one-off script);
results live in our tree. NOT a sidecar / manifest / runtime-loaded
artifact (per `feedback_no_prod_sidecar_strategies.md`).

**D3 (guinea pig):** FUN_06044F30, brought into the
`race_FUN_06044060` TU. This is the one extern callee blocking
Phase E.1b's IPA pin from engaging on FUN_06044060. FUN_06044F30
is a secondary entry into FUN_06044E3C (offset +0xF4); the shim
body is the prod byte slice from that offset down to the rts/nop.
End-to-end success criterion: the IPA pin engages on FUN_06044060
and its diff vs prod drops materially.

## 2. Why we need this

### 2a. The catch-22 today

Phase C's writes_r4 cache is populated by walking each in-queue
function's captured DAG. Functions outside the TU (`extern`) get
the conservative ABI default (`writes_r4 = 1`). For FUN_06044060
specifically: 4 of 5 callees correctly answer `preserves r4`; the
fifth (FUN_06044F30) is extern and vetoes the predicate. The IPA
pin therefore never engages, and the 15-line behavioral cluster
the IPA design predicted closing stays closed.

The naive fix is "compile all 900 functions in one TU so everyone
is in-queue." But that requires every function to be decompiled
to C — which would mean the IPA mechanism only helps after the
project is essentially done. Catch-22.

### 2b. The asm-shim cut

Don't require C. Bring uncompleted functions into the TU as
asm-bodied shims defined in `asm { ... }` blocks. Each shim:

  - Creates a Symbol (so the cgraph has the edge).
  - Has a body the compiler can analyze (Phase C scans the asm
    text instead of walking a DAG).
  - Emits as the prod bytes verbatim at drain time.

When a shim eventually graduates to a real C decomp, the C version
replaces the shim in the same `.c` file. Phase C transparently
switches from asm-text scanning to DAG walking. No call-graph
rewiring needed.

### 2c. Beyond IPA

The unity-build asm-shim mechanism is the foundation for any
future analysis that needs cross-function visibility:
register-clobber narrowing for non-r4 registers, MAC-state
tracking, GBR-pinning analysis, ... All of those today face the
same extern-veto problem. Solving it once, generally, is worth
more than another per-pragma workaround.

### 2d. Scope of the asm-shim era — what the census tells us

`D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
(2026-04-24, 850-function census across all 39 race-module TUs)
gives concrete shape to how long the asm-shim era lasts and which
functions stay shimmed permanently:

  - **~33% of race-module functions decomp to ordinary C with
    zero SHC-specific annotations.** These graduate from asm-shim
    to real C decomp first; the shim is purely a temporary
    scaffold for them.
  - **~33% need a single annotation** — usually `__entry_alias__`
    for a Cat 1 multi-entry pair. Mechanism set we already have
    or are about to build covers them. Also temporary scaffold.
  - **~35% need 2+ annotations.** These are the painful cases,
    and they are NOT uniformly distributed: they cluster in four
    specific TUs (FUN_060351CC.s, FUN_0603C304.s, FUN_0604D380.s,
    and the FUN_0604C76C.s software-pipelined chain). Most of
    those 35% are still decomp-able with effort; a small subset
    may not be economical.
  - **A small permanent-shim minority (~5-10%, anchor case:
    FUN_0604C76C's 7-entry software-pipelined chain) are
    legitimately uneconomical to express in C.** The asm-shim is
    their permanent home, not a scaffold.

The single biggest annotation burden is **Cat 3 (gbr /
unsaved-callee-save) at ~36% of all functions**. Our existing
`#pragma global_register` mechanism is gating more than a third
of the corpus — it has to be robust at scale. The asm-shim work
doesn't change this directly, but the census makes it the
top-priority pragma to harden as decomp ramps up.

**Strategic implication for asm-shim:** the work is genuinely a
scaffold for ~90% of the corpus and a permanent answer for ~5-10%.
That ratio is healthier than the worry suggested — most of the
asm-shim infrastructure pays off across the project lifetime, not
just during a brief bring-in window. The permanent-shim minority
also justifies investing in good asm-shim ergonomics (the
`asm { ... }` syntax, round-trip preservation guarantees) rather
than treating it as a throwaway intermediate format.

## 3. The `asm { ... }` syntax

### 3a. Two contexts

**Statement-level (inside a C function body):**
```c
void foo(void) {
    int x = 1;
    asm { mov r1, r2 }
    asm {
        mov #16, r3
        add r3, r4
    }
    return;
}
```
Replaces every existing `__asm("...")` site. Same semantics: emit
the captured text into the surrounding function's body at the
point of the asm block.

**File-scope (whole-function body):**
```c
#pragma naked(FUN_06044F30)
void FUN_06044F30(int p1) asm {
    sts.l   pr,@-r15
    mov.l   LP0,r3
    jsr     @r3
    nop
    /* ...the rest of the prod body verbatim... */
    rts
    nop
LP0:    .long   _func_0x06044d80
}
```
The function's body IS the asm block. No prologue/epilogue, no
register homing for params, no body codegen at all — drain emits
exactly the captured bytes.

### 3b. Block-content rules

Inside `{ ... }`:

  - All characters between the opening `{` and matching `}` are
    captured verbatim, including newlines, tabs, and comments.
  - Brace counting: `{` increments depth, `}` decrements. The
    block ends at depth-0 `}`. (SH-2 asm doesn't use `{`/`}`, so
    in practice the first `}` ends it. Brace counting just makes
    a defensive over-promise.)
  - The captured text is stored as a single string. Leading and
    trailing whitespace are NOT stripped (round-trip preservation).

### 3c. Preprocessor interaction

The build pipeline runs `cpp -P` before rcc (per
`saturn/tools/build.sh`). cpp will preprocess inside the asm
block too. For prod asm this is fine in practice:

  - `mov #0x10, r4` — `#` mid-line is not a directive trigger.
  - `mov.l #FOO, r5` — if FOO is `#define`d as a constant, it
    gets expanded. Acceptable.
  - `# comment` — `#` at start of line IS a directive trigger.
    Mitigation: write asm comments as `! comment` or `; comment`
    (both legal SH-2 asm comment chars), or `/* comment */`.

A regtest will lock down the cpp behavior we depend on.

### 3d. What `asm` is

The `asm` keyword is a new reserved identifier handled at parse
time. Not a macro. Not preprocessed away. Recognised at:

  - Statement position inside a function body.
  - As the right-hand side of a function definition (file scope,
    for whole-function shims).

## 4. Lexer: raw-text mode

### 4a. The mode switch

When the lexer sees the identifier `asm` followed (after optional
whitespace) by `{`, it:

  1. Returns an `ASM` token to the parser for the `asm` identifier.
  2. Returns a `{` token (or however the existing lexer represents
     it).
  3. Switches to raw-text mode for the next read.

In raw-text mode the lexer reads characters into a buffer until it
sees a `}` at depth 0. The buffer becomes a single string-token
(one Symbol with the text in `->name`).

### 4b. Why a mode switch (vs slurping until `}` at the parser)

Doing it at the parser level means tokenizing the asm body as if
it were C — the lexer would emit MOV-as-identifier, `r1`-as-
identifier, `,` as comma, etc. We'd then have to reconstruct the
text from the token stream. Lossy and slow. The mode switch keeps
the original characters intact.

### 4c. Existing lexer

`src/lex.c` is the only file that needs to learn the mode. The
parser's only contact is the new `ASM` token and the string-
typed argument the lexer hands it. Keep the change scoped to
~50 lines.

## 5. AST representation

### 5a. The `asm { ... }` node

Same as today's `__asm("...")` — an `ASMB+V` tree with `u.sym`
carrying the raw text in `->name`. Reuse the existing constant
and the existing emit path. The only change is who builds the
node: `expr.c`'s `asm_intrinsic()` becomes the parser's `asm`-
keyword handler.

### 5b. Whole-function asm-bodied definitions

A function whose body is a single `asm { ... }`:

  - The Symbol gets `sclass = EXTERN` (or STATIC, per the C
    declaration).
  - The body is a single Code-list entry (kind=Gen) containing
    one ASMB node.
  - The `naked` pragma (or per-function attribute, see 6a)
    suppresses prologue/epilogue.

For the captured-DAG / IPA queue: same machinery as a C function.
The function gets a queue entry, gets drained, emits its asm body
unwrapped.

### 5c. Statement-level asm in a C function

Same as today's __asm — a Code-list Gen entry with one ASMB node.
Mixed C-and-asm functions stay as they are; the new syntax is
just a nicer way to write them.

## 6. Backend: naked function emission

### 6a. Naked attribute mechanism

Three options for how to mark an asm-bodied function as naked:

  - **`#pragma naked(NAME)`**, modeled on the existing
    `noregsave` / `noregalloc` / `gbr_param` pragmas. Simple
    extension of `sh_func_has_attr`.
  - **Inferred** — detect that the function's body is a single
    ASMB Code entry and skip the wrapping automatically. No
    pragma needed. Cleaner UX.
  - **Both** — the inference handles asm-only bodies; the pragma
    is the explicit override for unusual cases.

I lean inferred. The pragma is one more thing to forget. Inferred
also makes the C source self-documenting: if the body is asm,
that's WHY there's no prologue.

### 6b. The drain change

In `sh_process_deferred_fn`, after capturing the function's body
into `sh_lines[]`, check: is the body a single ASMB-emitted line
(or chain thereof) and nothing else? If so, skip the prologue
emit, the param-homing moves, the usedmask save/restore, and the
epilogue. Just emit the body lines and the function's terminating
label-region.

### 6c. The label

Whole-function asm shims need their own function label. Today the
backend emits the label as part of the prologue. For naked
functions, emit just the label (`_FUN_06044F30:`) and then the
asm body. The body is responsible for its own rts (it's prod
asm — it already has one).

### 6d. Pool emission

Prod asm shims include their own constant pool (`.long ...`
following the body). The backend's pool emission for a naked
function should be a no-op — the asm shim manages its own pool.

## 7. Phase C: asm-body writes_r4 scanner

### 7a. Detection

In `sh_analyze_writes_r4`, when iterating the function's captured
forest, detect "this body is asm-only" via the same check the
naked-emit logic uses. Branch to the scanner.

### 7b. The scanner

`int sh_asm_writes_reg(const char *text, int rN)`:

Walks the asm text line by line. For each line:

  - Skip empty lines, comment-only lines, label lines, directive
    lines (`.long`, `.align`, `.global`, etc.), and pool entries.
  - For instruction lines, parse the destination operand and
    check if it's `r<rN>`.

Destination operand cases that count as a write to `r<N>`:

  - `mov ...,rN` (and `mov.b/w/l` variants)
  - `add #imm,rN` / `add rX,rN`
  - `sub`, `and`, `or`, `xor`, `not`, `neg` with `,rN` dest
  - `extu.b/w`, `exts.b/w` with `,rN` dest
  - `swap.b/w` with `,rN` dest
  - `xtrct rX,rN`
  - `mov.l @rX+,rN` (post-increment load)
  - `mov.b/w/l @(disp,rX),rN`
  - `mov.b/w/l @(R0,rX),rN`
  - `mov.b/w/l @(disp,GBR),rN` (when N == 0)
  - `mov.b/w/l @(disp,PC),rN` — PC-rel load
  - `lds @rX+,...` / `lds rX,...` — these write SR/GBR/VBR/MACH/MACL/PR, not GP regs
  - `sts ...,rN` — writes from SR/GBR/etc. INTO rN
  - `movt rN`
  - `dt rN`
  - `shll/shlr/shal/shar/rotl/rotr/rotcl/rotcr rN` — shift-in-place writes rN

The scanner is conservative: when uncertain (unparseable line,
unknown mnemonic), assume it writes rN. Over-reporting means more
pins don't engage — graceful degradation, NOT miscompilation.

### 7c. Why text scanning, not assemble-then-disassemble

A real disassembler would be more correct but pulls in
significant code (or shells out to `sh-elf-objdump`). Text
scanning is bounded, in-process, and SH-2's syntax is regular
enough that the conservative scanner gets us most of the value
with negligible code.

### 7d. Where it lives

A new function in `src/sh.md` (alongside the other sh_*
helpers). Maybe ~80 lines of code plus a small unit-test
regtest.

## 8. Round-trip preservation guarantee

The bytes-in = bytes-out invariant is a first-class design goal:
for an asm-shim function whose body is captured from prod, the
emitted asm must match prod byte for byte (modulo
genuinely-equivalent whitespace per the asm_normalize tooling).

Sources of potential drift to head off:

  - **Lexer escape processing** — block content is captured raw,
    no `\n` / `\t` interpretation. (This is a key reason
    `asm { ... }` is better than the string-literal form.)
  - **Trailing-whitespace stripping** — don't.
  - **Tab vs space normalization** — don't normalize at capture
    time. The asm_normalize.py pipeline handles cosmetic
    differences for diff purposes; the raw emit must be faithful.
  - **Pool-label rewrites** — we do label-renumbering across the
    output for our own emitted code. For asm-shim bodies, leave
    pool labels alone (they're inside the shim, not part of our
    label space).

A regtest will assert: a representative asm shim, when compiled
and emitted, produces output bytewise identical to the input
block content.

## 9. Failure modes

### 9a. Asm-scanner false negatives

The scanner reports `preserves r4` when the body actually writes
r4. Result: the IPA pin engages on a caller that shouldn't have
engaged it; the synthesized `add #K, r4` mutation gets stomped
mid-function by the callee's r4 write; byte-match fails (or worse,
runtime miscompile if the bytes happen to match by accident).

Mitigation: the scanner is conservative-by-default; uncertain
mnemonics report `writes`. The known-write list in 7b is
deliberately broad. New mnemonics encountered in the corpus get
added to the list.

### 9b. Asm-scanner false positives

The scanner reports `writes r4` when the body doesn't. Result:
IPA pin never engages on the caller; no IPA wins for that path.
Acceptable — same as today's status quo.

### 9c. Multi-entry functions in shims

FUN_06044F30 is a secondary entry into FUN_06044E3C (offset
+0xF4). If we shim FUN_06044F30 as its own function, those bytes
appear twice in the output (once when FUN_06044E3C is compiled,
once when FUN_06044F30 is shimmed). Total binary size grows by
the slice size.

For the guinea pig: acceptable. The mission is to prove the IPA
mechanism, not to byte-match the full binary. Multi-entry support
is a separate workstream; once it lands, the shim folds back into
the parent function's body.

### 9d. cpp expansion inside asm

If a prod asm body happens to contain text that cpp interprets
(e.g., a `#define` macro name), it gets expanded. Mitigation:
prod asm doesn't have such constructs in practice. If we hit one,
the workaround is to escape it, or to bypass cpp for the asm
file. A regtest will surface the breakage if it ever happens.

### 9e. Naked-function semantics

A naked function with a non-shim body (e.g., a C body marked
`#pragma naked`) would emit no prologue/epilogue around real
codegen, producing broken output. Mitigation: only the inferred
"body is single ASMB" path enables naked emission. A C body
never triggers it.

## 10. Migration of existing __asm() one-liners

`FUN_06044060.c` has 8 `__asm("...")` calls in the existing
`__asm` form. Mass-convert mechanically to `asm { ... }`:

```c
__asm("mov #1, r6");
__asm("shll16 r6");
```

becomes:

```c
asm { mov #1, r6 }
asm { shll16 r6 }
```

Or, if the user prefers to consolidate adjacent one-liners:

```c
asm {
    mov #1, r6
    shll16 r6
    neg r6, r5
    mov r6, r7
}
```

The old `__asm("...")` form is retired once the conversion lands.
A grace period where both forms work is fine but not necessary —
the conversion is mechanical, one PR.

## 11. Guinea pig: FUN_06044F30 in race_FUN_06044060

### 11a. The shim

Add a file-scope asm-bodied function definition for FUN_06044F30
to `FUN_06044060.c`:

```c
extern int FUN_06044F30(int p1);   /* signature now takes p1 — see 11b */

int FUN_06044F30(int p1) asm {
    /* prod bytes from FUN_06044E3C+0xF4 down to its rts/nop */
    sts.l   pr,@-r15
    /* ... */
    rts
    nop
}
```

The shim body is the literal byte slice from prod
(`/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s` —
secondary-entry slice of FUN_06044E3C). Hand-extract once for the
guinea pig; future shims get a script.

### 11b. C-source change for FUN_06044060

Currently FUN_06044F30 is declared no-args and called no-args:
the r4/r5/r6/r7 setup is done via `__asm` lines. For the IPA pin
to actually rewrite anything, FUN_06044F30's call needs an ARG
node.

Change the declaration to take p1, and the call site to pass
`p1 + 0x30`:

```c
extern int FUN_06044F30(int p1);
...
FUN_06044F30(p1 + 0x30);
```

(The prod-asm pre-r5/r6/r7 setup via __asm stays — those args
aren't covered by IPA Phase E.1b, only the r4/p1 pin is.)

### 11c. Success criteria

  1. `asm { ... }` parses and emits FUN_06044F30 verbatim. Byte-
     match the standalone shim against prod's FUN_06044F30 slice.
  2. Phase C's asm-scanner reports `writes_r4 = 0` for the shim.
  3. Phase E.1b's pin engages on FUN_06044060 (verifiable via the
     `-d` IPA diagnostic).
  4. FUN_06044060's diff vs prod drops materially from 70 lines
     toward the IPA design's predicted ≤6.
  5. No previously byte-matched function regresses.
  6. The synthetic IPA Phase E.1b regtest still passes (it should
     — the regtest doesn't depend on this work).

## 12. Sequencing & TODOs

Three sessions, each with its own validation gate. Tick boxes as
items land. Don't combine sessions — each has independent
risk to surface and independent rollback if something goes
sideways.

### Session 1 — lexer + parser

Goal: `asm { ... }` parses everywhere it should and the captured
text round-trips bytes-in = bytes-out. Existing `__asm("...")`
intrinsic stays working in parallel for the migration window.

- [ ] Settle open question: statement-level `asm { ... }` placement
      — anywhere a statement can appear (recommended) vs only in
      specific contexts. Confirm with user before coding.
- [ ] Settle open question: empty `asm { }` block behavior — emit
      nothing, no error (recommended). Confirm.
- [ ] Add `ASM` token recognition in `src/lex.c` for the bare
      identifier `asm` at statement-start or declarator-tail
      position. Gate behind SH-only Xinterface flag so other
      backends see zero change.
- [ ] Implement raw-text mode in `src/lex.c`: on seeing `asm`
      followed (after whitespace) by `{`, slurp characters until
      matching `}` (depth-1 brace counting per section 3b). Return
      the captured text as a single string-typed Symbol.
- [ ] Statement-level parser hookup in `src/expr.c` — build an
      `ASMB+V` tree node carrying the text on `u.sym->name`. Reuse
      the existing emit path that `__asm("...")` uses today.
- [ ] File-scope hookup in `src/decl.c` — recognize
      `<type> <name>(<params>) asm { ... }` as a function
      definition where the body is the asm block (single Code-list
      Gen entry containing the ASMB node).
- [ ] Regtest: `asm { mov r1, r2 }` inside a C function emits
      literally `\tmov\tr1,r2\n` in the output (after
      `asm_normalize.py`).
- [ ] Regtest: round-trip preservation — capture a representative
      asm slice with labels, comments, pool entries, multiple
      instructions per line; assert bytes-out == bytes-in.
- [ ] Regtest: `asm { }` (empty block) emits nothing.

**Validation gate:** `wsl bash saturn/tools/validate_build.sh`
passes; both new regtests pass; existing `FUN_06044060.c` (with
its 8 `__asm("...")` calls) compiles unchanged.

### Session 2 — naked emit + asm-body scanner

Goal: a function whose body is a single `asm { ... }` block emits
as the bare bytes (no prologue/epilogue), and Phase C can answer
`writes_r4` for it via text scanning.

- [ ] Settle open question: inferred-naked vs `#pragma naked` —
      lean inferred (per section 6a). Confirm with user before
      coding.
- [ ] In `src/sh.md`: detect "this function's body is asm-only" —
      single ASMB Code entry, no other Gen statements. Add a
      helper like `sh_function_is_naked_shim(struct sh_ipa_fn *)`
      called early in `sh_process_deferred_fn`.
- [ ] In `sh_process_deferred_fn`: when naked, skip the prologue
      emit (sts.l pr, mov.l rN saves, fp setup, localsize), skip
      the param-homing moves, skip the epilogue (lds.l pr, rts).
      Just emit the function label + the asm body.
- [ ] Pool-emission no-op for naked functions (asm shim manages
      its own `.long` pool entries — see section 6d).
- [ ] Implement `int sh_asm_writes_reg(const char *text, int rN)`
      per section 7b. Conservative — over-report on parse failure
      or unknown mnemonic. Lives in `src/sh.md` near the existing
      `sh_is_delay_safe` mnemonic family.
- [ ] In `sh_analyze_writes_r4` (Phase C pre-pass): branch to the
      asm-scanner when the body is asm-only; cache result in
      `writes_r4`. DAG-walking path stays as-is for C-bodied
      functions.
- [ ] Unit-test regtests for `sh_asm_writes_reg`: handwritten
      fragments exercising each write category from section 7b
      (`mov`, `add`, `sub`, post-incr load, displaced load,
      `swap`, `xtrct`, `extu/exts`, `movt`, `dt`, shift-in-place).
- [ ] Regtest: a naked asm-bodied function compiled standalone
      emits exactly its body bytes (no prologue/epilogue
      wrapping).

**Validation gate:** `validate_build.sh` passes; asm-scanner
unit tests pass; a 1-function naked asm-shim test file compiles
to a known prod slice byte-for-byte.

### Session 3 — guinea pig + migration

Goal: FUN_06044F30 lives in the FUN_06044060 TU as a shim, the
IPA pin engages, FUN_06044060's diff drops materially, and the
old `__asm("...")` form is retired.

- [ ] Hand-extract FUN_06044F30's prod byte slice
      (`FUN_06044E3C + 0xF4` down to its `rts`/`nop`) from
      `/mnt/d/Projects/DaytonaCCEReverse/src/race/FUN_06044060.s`.
      That source file's prod label `FUN_06044E3C:` is at
      line 1965 (verified during this session).
- [ ] Add the FUN_06044F30 asm shim to
      `saturn/experiments/daytona_byte_match/race_FUN_06044060/FUN_06044060.c`.
- [ ] Change FUN_06044F30's C-side declaration to take `int p1`
      (currently no-args); change the call site at line 83 to
      pass `p1 + 0x30`.
- [ ] Verify Phase C reports `writes_r4 = 0` for the shim. Use
      the `-d` IPA diagnostic.
- [ ] Verify Phase E.1b's pin engages on FUN_06044060. Use the
      `-d` IPA diagnostic; confirm `sh_ipa_current->pinned_param`
      is set and `sh_ipa_apply_mutation_rewrite` runs.
- [ ] Measure FUN_06044060's diff vs prod — should drop
      materially from the current 70 toward the IPA design's
      predicted ≤6. Update `byte_match_001_blockers.md` with the
      new number.
- [ ] Mechanical conversion of all remaining `__asm("...")` calls
      in `FUN_06044060.c` to `asm { ... }` form (8 sites today,
      see section 10).
- [ ] Retire the `__asm("...")` intrinsic in `src/expr.c` —
      delete `asm_intrinsic()` and its dispatch from `primary()`.
      Update the existing
      `regtest: __asm("...") emits raw text` test to use the new
      form.
- [ ] Final `validate_build.sh` pass — all 42 existing regtests
      + the new asm-shim regtests + IPA Phase E.1b end-to-end
      regtest, no byte-matched function regressions.

**Validation gate:** FUN_06044060 closer to byte-match than HEAD;
IPA pin verifiably engaged via `-d` diagnostic; existing tests
still green; old `__asm("...")` form gone from the codebase.

## 13. Out of scope

  - **Auto-generation of shims from prod.** A script that reads
    a prod .s and emits a `.c` shim is useful but separate. For
    the guinea pig, hand-extraction of one function is fine.
    Census numbers (~850 functions in race) suggest a generation
    script will eventually be worth building, but not yet.
  - **Multi-entry-point support.** FUN_06044F30 ↔ FUN_06044E3C
    body sharing. The shim duplicates bytes for now; collapse
    happens in a separate workstream. Census places Cat 1
    multi-entry at ~27% of race-module functions, so this
    workstream IS coming — just not gating asm-shim itself.
  - **Asm globals / file-scope data via asm.** `asm { .long X }`
    at file scope outside a function definition. Not needed for
    the IPA mission. Defer.
  - **Inline expression substitution.** GCC's `asm("..." :
    outputs : inputs : clobbers)` syntax. Powerful but a much
    bigger surface. Stay with bare text capture.
  - **Asm-aware register allocation.** The scanner determines
    `writes_r4` by text matching — it doesn't model the asm's
    register usage in the allocator's freemask. Asm bodies are
    opaque to the allocator (which is fine for naked shims —
    they don't go through the allocator at all).
  - **Promoting permanent-shim functions to C.** Census flags
    ~5-10% of race functions (anchor: FUN_0604C76C's 7-entry
    software-pipelined chain) as legitimately uneconomical to
    express in C. These stay as asm shims forever. We don't
    pursue C decomps for them; the shim ergonomics in this
    design ARE their permanent representation.

## 14. Open questions for implementation

  - **Inferred-naked vs `#pragma naked`.** Lean inferred.
    Confirm during implementation.
  - **Statement-level `asm { ... }` placement rules.** Allowed
    anywhere a statement can appear? Inside expressions? (Today's
    __asm is an expression; statement-level uses it as an
    expression-statement. Likely keep that.)
  - **Empty asm block.** `asm { }` — probably emit nothing,
    no error. Confirm.
  - **Asm scanner mnemonic table — where does it live?** Probably
    a static table in sh.md alongside the existing
    `sh_is_delay_safe` mnemonic family. Rebuild when SH-2 ISA
    additions arise (rare).
  - **Round-trip regtest concretely tests what?** A handwritten
    asm slice that exercises labels, comments, pool entries, and
    multiple instructions per line. Bytes-in compared to bytes-
    out post-emit.

## 15. What this enables downstream

Beyond the IPA r4 mission:

  - Any future analysis that needs cross-TU visibility (clobber
    narrowing for non-r4 regs, MAC-state tracking, GBR pinning,
    cross-call liveness for non-IPA cases) gets to assume "the
    answer for this callee can be computed" instead of "extern,
    fall back to ABI."
  - Mass-import of prod TUs without paying the C-decompilation
    cost upfront. C decomps land function-by-function; until
    they do, the asm shims keep the TU compilable AND
    analyzable.
  - The "byte-matched functions are the oracle" principle scales:
    each new asm shim is a candidate for graduation to a real C
    decomp once we understand its shape. The shim provides a
    byte-exact baseline against which any C-decomp attempt is
    measured.
  - A bounded permanent home for the ~5-10% of functions the
    census flagged as uneconomical to decomp. Software-pipelined
    chains and other dense SHC-specific patterns get to live as
    first-class asm shims forever, with proper round-trip
    guarantees, instead of being treated as second-class
    intermediate state.

## 16. Strategic context — race-module census

`D:\Projects\DaytonaCCEReverse\docs\shc_annotation_census_race.md`
(2026-04-24) is the empirical baseline for how this work fits
into the broader project. Headline numbers, repeated here for
locality:

  - **850 functions** across 39 race-module TUs.
  - **~33% completely clean** (no SHC-specific annotations).
  - **~33% need exactly one annotation** (mostly Cat 1
    `__entry_alias__`).
  - **~35% need 2+ annotations**, concentrated in 4 specific
    TUs: FUN_060351CC.s, FUN_0603C304.s, FUN_0604D380.s,
    FUN_0604C76C.s.
  - **Avg 1.1 annotations per function.**

Single biggest annotation burden: **Cat 3 (gbr /
unsaved-callee-save) at ~36% of all functions.** Our existing
`#pragma global_register` mechanism is gating more than a third
of the corpus. Hardening it at scale is parallel to the asm-shim
work and similarly load-bearing for the project's overall
viability.

Smallest categories: **Cat 5 (low-first allocation) at ~2%** and
**Cat 7 (R0-shim calling convention) at ~3%**. Both small enough
to handle case-by-case (existing `#pragma sh_alloc_lowfirst` for
Cat 5; inline `asm { ... }` blocks for Cat 7) without a
generalized mechanism.

The census also surfaced an honest concession: **FUN_0604C76C's
software-pipelined chain (7 progressive entry points sharing one
prologue) may genuinely never decomp economically.** It is the
anchor case for permanent-shim functions, and one reason the
asm-shim design treats round-trip preservation as a first-class
goal rather than a transitional convenience.

End of design.
