#!/bin/bash
# validate_build.sh — mechanical pre-commit validation
#
# Checks:
# 1. Compiler builds and passes its smoke test
# 2. All experiment C files compile without crashing
# 3. Existing .s outputs are bit-identical to their last-committed versions
# 4. Regression tests for known-fixed bugs
# 5. Tier-1 byte-match (standalone corpus): per-function diff count vs pinned baselines
# 6. Tier-1 byte-match (TU corpus): per-function diff count inside race_FUN_06044060 TU
# 7. Broad-corpus smoke: 956 Ghidra race C files; catches new crashes
#    and previously-passing regressions
#
# Run from the repo root:
#   wsl bash saturn/tools/validate_build.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
RCC="$REPO/build/rcc"
EXPDIR="$REPO/saturn/experiments/daytona_byte_match"
PASS=0
FAIL=0
TOTAL=0

pass() { PASS=$((PASS+1)); TOTAL=$((TOTAL+1)); printf "  PASS  %s\n" "$1"; }
fail() { FAIL=$((FAIL+1)); TOTAL=$((TOTAL+1)); printf "  FAIL  %s\n" "$1"; }

trap 'rm -f /tmp/regtest_and.c /tmp/regtest.c /tmp/regtest.s /tmp/regtest_overflow.c /tmp/regtest_overflow_err.txt' EXIT

echo "=== validate_build.sh ==="
echo ""

# ── 1. Build ──────────────────────────────────────────────
echo "[1/7] Building compiler..."
if bash "$REPO/saturn/tools/build.sh" > /dev/null 2>&1; then
    pass "compiler builds"
else
    fail "compiler builds"
    echo "       Build failed — cannot continue."
    exit 1
fi

# ── 2. Compile all experiment C files ─────────────────────
# Skips *.ghidra.c — those are raw Ghidra-decompiler baselines kept for
# Gap-0 provenance (H1) and aren't expected to compile directly with
# rcc. Their dedicated pipeline lives in validate_byte_match.sh.
echo "[2/7] Compiling experiment sources..."
for cfile in "$EXPDIR"/FUN_*.c "$EXPDIR"/race_tu1/FUN_*.c; do
    [ -f "$cfile" ] || continue
    case "$cfile" in *.ghidra.c) continue ;; esac
    sfile="${cfile%.c}.s"
    name="$(basename "$cfile")"
    # Preprocess first (rcc doesn't handle #define/#include)
    if cpp -P "$cfile" > /tmp/validate_pp.c 2>/dev/null; then
        input=/tmp/validate_pp.c
    else
        input="$cfile"
    fi
    if "$RCC" -target=sh/hitachi "$input" "$sfile" 2>/dev/null; then
        pass "compile $name"
    else
        fail "compile $name"
    fi
done
rm -f /tmp/validate_pp.c

# Per-TU master files — each is a single .c that bundles many
# decompiled functions. Write .s in place so the checked-in snapshot
# always reflects the current compiler's output for quick eyeballing.
# Git status will show a diff whenever C or compiler changes alter
# the output; that's the signal.
for tu in "$EXPDIR"/race_FUN_*/FUN_*.c; do
    [ -f "$tu" ] || continue
    tu_dir="$(dirname "$tu")"
    tu_name="$(basename "$tu_dir")"
    tu_sfile="${tu%.c}.s"
    if cpp -P "$tu" /tmp/validate_tu_pp.c 2>/dev/null \
       && "$RCC" -target=sh/hitachi /tmp/validate_tu_pp.c "$tu_sfile" 2>/dev/null; then
        pass "compile TU $tu_name"
    else
        fail "compile TU $tu_name"
    fi
done
rm -f /tmp/validate_tu_pp.c

# ── 3. Stable outputs (diff against last commit) ─────────
# Add new stable files here as functions reach their match ceiling.
echo "[3/7] Checking .s stability vs HEAD..."
STABLE_FILES=(
    "saturn/experiments/daytona_byte_match/FUN_06004378.s"
    "saturn/experiments/daytona_byte_match/FUN_00280710.s"
    "saturn/experiments/daytona_byte_match/FUN_06000AF8.s"
)
for rel in "${STABLE_FILES[@]}"; do
    name="$(basename "$rel")"
    if ! git show "HEAD:$rel" >/dev/null 2>&1; then
        fail "stable $name (not tracked in HEAD)"
    elif git show "HEAD:$rel" 2>/dev/null | diff -q - "$REPO/$rel" >/dev/null 2>&1; then
        pass "stable $name"
    else
        fail "stable $name (differs from HEAD — run: git diff $rel)"
    fi
done

# ── 4. Regression tests ──────────────────────────────────
echo "[4/7] Regression tests..."

# Helper: compile to temp file and grep for a pattern.
# Handles compiler crashes explicitly instead of grepping stale output.
regtest_grep() {
    local label="$1" pattern="$2" expect="$3"
    rm -f /tmp/regtest.s
    if ! "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>/dev/null; then
        fail "regtest: $label (compiler crashed)"
        return
    fi
    if grep -q "$pattern" /tmp/regtest.s 2>/dev/null; then
        [ "$expect" = "yes" ] && pass "regtest: $label" || fail "regtest: $label"
    else
        [ "$expect" = "no" ] && pass "regtest: $label" || fail "regtest: $label"
    fi
}

# 4a. && with cmp/eq #imm (was crashing before fix)
cat > /tmp/regtest_and.c <<'EOF'
extern void foo(void);
void test(int x, int y) {
    if (x == 1 && y == 1) foo();
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest_and.c /dev/null 2>/dev/null; then
    pass "regtest: && with cmp/eq #imm"
else
    fail "regtest: && with cmp/eq #imm (crash)"
fi

# 4b. muls.w from short types (no pragma needed)
cat > /tmp/regtest.c <<'EOF'
extern short stride;
int test(int x) { return x * stride; }
EOF
regtest_grep "muls.w from short operand" "muls.w" yes

# 4c. mul.l for int*int (must NOT emit muls.w)
cat > /tmp/regtest.c <<'EOF'
int test(int a, int b) { return a * b; }
EOF
regtest_grep "mul.l for int*int" "mul.l" yes

# 4d. MACL save/restore when multiply is used (needs a call to force PR save)
cat > /tmp/regtest.c <<'EOF'
extern short s;
extern void bar(void);
int test(int x) { bar(); return x * s; }
EOF
regtest_grep "MACL save in prologue" "macl" yes

# 4e. No MACL when no multiply
cat > /tmp/regtest.c <<'EOF'
extern void bar(int);
void test(int x) { bar(x + 1); }
EOF
regtest_grep "no MACL without multiply" "macl" no

# 4f. Multiple calls with array-deref args (was segfault in moveself, NULL x.kids[0])
cat > /tmp/regtest.c <<'EOF'
extern void f(int, int, int);
int test(int *p) { f(p[0], 1, 2); f(p[1], 3, 4); return 0; }
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>/dev/null; then
    pass "regtest: multi-call with array deref args"
else
    fail "regtest: multi-call with array deref args (crash)"
fi

# 4f2. Store to a pool-loaded address immediately followed by a void call.
# The void call's target address must NOT be allocated to r0, or it
# clobbers the store address (also in r0) before the store fires —
# silently redirecting the store to the call target (memory corruption,
# no diagnostic). See rcc_bug_store_before_call. Invariant: a direct
# call target never lands in r0, so `jsr @r0` must not appear.
cat > /tmp/regtest.c <<'EOF'
extern void f(void);
void g(unsigned int v) {
    *(volatile unsigned int *)0x0022E140 = v;
    f();
}
EOF
regtest_grep "store-to-global before void call keeps call target off r0" "jsr.*@r0" no

# 4f3. A store that precedes a void call must execute BEFORE the call, not
# get sunk into the rts delay slot (after the call returns). The store
# belongs in the jsr delay slot. This guards the rts delay-slot filler
# against stealing an instruction already placed in a branch delay slot.
# In a function with no callee-saved regs, the only post-rts instruction
# must be a nop — never a store (`,@`). See rcc_bug_store_before_call.
cat > /tmp/regtest.c <<'EOF'
extern void do_thing(void);
unsigned int g_store_seq;
void test(void) { g_store_seq = 5; do_thing(); }
EOF
rm -f /tmp/regtest.s
if "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>/dev/null; then
    if awk '/\trts\b/{seen=1; next} seen && /,@/{bad=1} END{exit(bad?1:0)}' /tmp/regtest.s; then
        pass "regtest: store before void call not sunk into rts delay slot"
    else
        fail "regtest: store before void call not sunk into rts delay slot"
    fi
else
    fail "regtest: store before void call not sunk into rts delay slot (crash)"
fi

# 4g. Body overflow diagnostic (compiler must not crash, must warn on stderr)
{
    echo "extern void f(void);"
    echo "void test(void) {"
    for i in $(seq 1 800); do echo "    f();"; done
    echo "}"
} > /tmp/regtest_overflow.c
if "$RCC" -target=sh/hitachi /tmp/regtest_overflow.c /dev/null 2>/tmp/regtest_overflow_err.txt; then
    if grep -q "line buffer overflow" /tmp/regtest_overflow_err.txt 2>/dev/null; then
        pass "regtest: body overflow diagnostic"
    else
        fail "regtest: body overflow diagnostic (no warning on stderr)"
    fi
else
    fail "regtest: body overflow diagnostic (crash)"
fi
rm -f /tmp/regtest_overflow.c /tmp/regtest_overflow_err.txt

# 4h. Displacement addressing modes (mov.w @(disp,Rn),R0 etc.)
cat > /tmp/regtest.c <<'EOF'
short test_disp_load(short *p) { return p[7]; }
void test_disp_store(int *p, int v) { p[2] = v; }
EOF
rm -f /tmp/regtest.s
if ! "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>/dev/null; then
    fail "regtest: displacement addressing (crash)"
else
    ok=1
    grep -q '@(14,r' /tmp/regtest.s 2>/dev/null || ok=0
    grep -q '@(8,r' /tmp/regtest.s 2>/dev/null || ok=0
    [ "$ok" = "1" ] && pass "regtest: displacement addressing" \
                     || fail "regtest: displacement addressing (missing @(disp,Rn) forms)"
fi

# ── Short-literal lburg rule coverage (landmines.md #4) ──
# Pre-47616fa, rcc asserted in getrule on ASGNI2 / ASGNU2 with a large
# int literal — no CNSTI2 fallback rule existed for values outside
# -128..127.  Crash mode:
#     (XXX->op=ASGNI2 at 1 is corrupt.)
#     rcc: src/gen.c:181: getrule: Assertion `0' failed.
#
# Verified destructively (2026-04-16): deleting the CNSTI2/CNSTU2
# "# large const" fallback rules from src/sh.md and rebuilding, each
# of these inputs aborts as above. With the rules present, they
# compile clean.
#
# The crash requires an actual store or local-variable assignment of a
# large int literal to a short — simple return paths are covered by
# CVII4 / emit2 fallbacks. The two 47616fa-also-added rule groups
# *not* covered here:
#   - CVII1/CVII2/CVUU1/CVUU2 "# truncate" register-level rules
#     (lines 599-602). Defensive lburg-completeness; no real C input
#     produces DAG nodes reaching them (LCC's front-end folds narrowing
#     into the store). Destructive-delete tested with several probes,
#     couldn't trigger a crash. Left in sh.md for safety.

# 4i. Short local variable assigned a large int literal (CNSTI2 + ASGNI2)
cat > /tmp/regtest.c <<'EOF'
short f(void) { short x = 300; return x; }
EOF
regtest_grep "CNSTI2 fallback: large short literal in local" 'mov\.w' yes

# 4j. Unsigned short store through pointer, large literal (CNSTU2 + ASGNU2)
cat > /tmp/regtest.c <<'EOF'
void f(unsigned short *p) { *p = 40000; }
EOF
regtest_grep "CNSTU2 fallback: large ushort literal via *p" 'mov\.w' yes

# ── Pragma scope guard (src/input.c, methodology_remediation S1) ──
# Saturn backend pragmas (gbr_base, gbr_param) mutate globals consumed
# at function-emit time. A mid-function pragma would split the function
# across two pragma states. Guard added 2026-04-16 rejects them with a
# clear error instead of silently producing wrong code.

# 4o. POSITIVE: file-scope #pragma compiles clean
cat > /tmp/regtest.c <<'EOF'
#pragma gbr_param
int f(int x) { return x; }
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>/dev/null; then
    pass "regtest: file-scope #pragma gbr_param accepted"
else
    fail "regtest: file-scope #pragma gbr_param rejected (should accept)"
fi

# 4p. NEGATIVE: mid-function #pragma errors out with the expected message
cat > /tmp/regtest.c <<'EOF'
int f(int x) {
#pragma gbr_param
    return x;
}
EOF
pragma_err="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"; then
    fail "regtest: mid-function #pragma incorrectly accepted"
elif grep -q "must appear at file scope" "$pragma_err" 2>/dev/null; then
    pass "regtest: mid-function #pragma rejected with expected message"
else
    fail "regtest: mid-function #pragma rejected but without expected message"
fi
rm -f "$pragma_err"

# 4q. POSITIVE: #pragma between two function bodies compiles clean.
# Regression guard for the cfunc/expect('}') lookahead bug — see
# landmines.md "cfunc must be cleared before expect('}') in function
# tail". If cfunc = NULL is moved back after expect('}'), the gettok()
# lookahead past the first function's '}' tokenizes this pragma while
# cfunc is still set, falsely rejecting it as mid-function.
cat > /tmp/regtest.c <<'EOF'
void f(void) {}
#pragma gbr_param
int g(int x) { return x; }
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>/dev/null; then
    pass "regtest: #pragma between two function bodies accepted"
else
    fail "regtest: #pragma between two function bodies rejected (should accept)"
fi

# SHC v5.0 §3.10 / §3.11 register-save + global-register pragmas
# (pragma_global_register.md workstream, Phase B).
# All four must parse without diagnostic at file scope, including when
# placed BEFORE any declaration — that path goes through deferred
# flush which historically dropped pragma args. Also covers argument
# parsing errors on malformed input.

# 4t. POSITIVE: three pragmas at top-of-file (deferred-flush path).
cat > /tmp/regtest.c <<'EOF'
#pragma noregsave(c)
#pragma noregalloc(d)
#pragma global_register(ctx=R10, scratch=R14)
int c(int x) { return x; }
int d(int x) { return x; }
EOF
pragma_err="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"
if [ ! -s "$pragma_err" ]; then
    pass "regtest: top-of-file noregsave/noregalloc/global_register accepted"
else
    fail "regtest: top-of-file pragmas rejected — $(head -1 "$pragma_err")"
fi
rm -f "$pragma_err"

# 4v. NEGATIVE: global_register with out-of-range register.
cat > /tmp/regtest.c <<'EOF'
#pragma global_register(ctx=R5)
int a(int x) { return x; }
EOF
pragma_err="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"
if grep -q "register must be R8..R14" "$pragma_err"; then
    pass "regtest: #pragma global_register out-of-range rejected with expected message"
else
    fail "regtest: #pragma global_register out-of-range not rejected as expected"
fi
rm -f "$pragma_err"

# 4w. NEGATIVE: global_register missing '=' between var and reg.
cat > /tmp/regtest.c <<'EOF'
#pragma global_register(ctx R10)
int a(int x) { return x; }
EOF
pragma_err="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"
if grep -q "#pragma global_register expects '='" "$pragma_err"; then
    pass "regtest: #pragma global_register missing '=' rejected with expected message"
else
    fail "regtest: #pragma global_register missing '=' not rejected as expected"
fi
rm -f "$pragma_err"

# 4y. CODEGEN: default save strategy is SHC's [lowest_written..r14]
# contiguous range (save-default inversion, see
# saturn/workstreams/save_strategy_and_asm_intrinsic.md). Under high
# register pressure, the body dirties enough callee-saved regs to
# drive `lowest` down to r8 — must push the full r8..r14 contiguous
# range. Verified by counting `mov.l rN,@-r15` pushes in the prologue.
cat > /tmp/regtest.c <<'EOF'
extern int ext(int);
int stress(int a, int b, int c, int d) {
    int x1 = ext(a); int x2 = ext(b); int x3 = ext(c);
    int x4 = ext(d); int x5 = ext(a + b); int x6 = ext(c + d);
    int x7 = ext(x1 + x2);
    return x1 + x2 + x3 + x4 + x5 + x6 + x7;
}
EOF
rs_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$rs_out" 2>/dev/null
full_range=1
for n in 14 13 12 11 10 9 8; do
    grep -q "mov.l[[:space:]]*r$n,@-r15" "$rs_out" || full_range=0
done
if [ "$full_range" = "1" ]; then
    pass "regtest: default save is [lowest_written..r14] full range"
else
    fail "regtest: default save missing full r8..r14 range"
fi
rm -f "$rs_out"

# 4z. CODEGEN: #pragma noregsave strips prologue/epilogue saves of
# R8..R14 entirely. Same stress body as 4x/4y. With noregsave, the
# allocator may still use those regs as scratch (allocator strip is
# Phase C.3), but no `mov.l rN,@-r15` for r8..r14 must appear in
# prologue and no matching `mov.l @r15+,rN` in epilogue.
cat > /tmp/regtest.c <<'EOF'
#pragma noregsave(stress)
extern int ext(int);
int stress(int a, int b, int c, int d) {
    int x1 = ext(a); int x2 = ext(b); int x3 = ext(c);
    int x4 = ext(d); int x5 = ext(a + b); int x6 = ext(c + d);
    int x7 = ext(x1 + x2);
    return x1 + x2 + x3 + x4 + x5 + x6 + x7;
}
EOF
nrs_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$nrs_out" 2>/dev/null
saw_save=0
for n in 14 13 12 11 10 9 8; do
    if grep -q "mov.l[[:space:]]*r$n,@-r15" "$nrs_out"; then
        saw_save=1; break
    fi
    if grep -q "mov.l[[:space:]]*@r15+,r$n" "$nrs_out"; then
        saw_save=1; break
    fi
done
if [ "$saw_save" = "0" ]; then
    pass "regtest: #pragma noregsave emits no R8..R14 prologue/epilogue saves"
else
    fail "regtest: #pragma noregsave still emitted an R8..R14 save"
fi
rm -f "$nrs_out"

# 4aa. CODEGEN: #pragma noregalloc keeps R8..R14 out of the allocator
# AND strips prologue/epilogue saves. Per SHC v5.0 §3.10, noregalloc
# functions are bridge shapes — they pass callee-saved state through
# from a standard-save caller to a noregsave callee without disturbing
# R8..R14.
# Test with a trivial pass-through body: no locals, no FP, nothing
# that would force the backend to touch r14.
cat > /tmp/regtest.c <<'EOF'
#pragma noregalloc(bridge)
extern int callee(int);
int bridge(int a) { return callee(a); }
EOF
nra_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$nra_out" 2>/dev/null
touched=0
for n in 14 13 12 11 10 9 8; do
    if grep -qE "[[:space:],]r$n([[:space:],)]|\$)" "$nra_out"; then
        touched=1; break
    fi
done
if [ "$touched" = "0" ]; then
    pass "regtest: #pragma noregalloc keeps R8..R14 out of allocator + save set"
else
    fail "regtest: #pragma noregalloc still touched R8..R14"
fi
rm -f "$nra_out"

# 4ab. CODEGEN: #pragma global_register(x=Rn) carves Rn from both
# vmask and tmask TU-wide AND the speculative r14-rename respects
# that exclusion. Compile a high-pressure function (would naturally
# use most of r8..r14 as variable homes) and verify the pinned reg
# r10 never appears in the output.
cat > /tmp/regtest.c <<'EOF'
#pragma global_register(ctx=R10)
extern int ext(int);
int heavy(int a, int b, int c, int d) {
    int x1 = ext(a); int x2 = ext(b); int x3 = ext(c);
    int x4 = ext(d); int x5 = ext(a + b); int x6 = ext(c + d);
    int x7 = ext(x1 + x2);
    return x1 + x2 + x3 + x4 + x5 + x6 + x7;
}
EOF
gr_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$gr_out" 2>/dev/null
if grep -qE "[[:space:],]r10([[:space:],)]|\$)" "$gr_out"; then
    fail "regtest: #pragma global_register(x=R10) still emitted r10 references"
else
    pass "regtest: #pragma global_register excludes R10 from allocator + r14-rename"
fi
rm -f "$gr_out"

# (4ac removed — `__asm("...")` retired in asm-shim Stage 2; the
#  asm{}-form regtest 4ad covers the equivalent canonical-emit case.)

# 4ad. asm { ... } statement-level construct, canonical emit.
# Stage 2 of asm-shim parses the block and re-emits in the same
# `\t<mn>\t<ops>\n` layout C-derived emit produces. Source whitespace
# is discarded (assembled-byte equivalence is preserved; the SH-2
# assembler is whitespace-blind for instruction tokens).
cat > /tmp/regtest.c <<'EOF'
int hello(int x) {
    asm { mov r1, r2 }
    return x + 1;
}
EOF
asm_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>/dev/null
ok=1
grep -qE $'^\tmov\tr1,r2$' "$asm_out" || ok=0    # canonical: tab-mn-tab-ops
grep -q "\.rodata" "$asm_out" && ok=0
grep -q "jsr" "$asm_out" && ok=0
grep -q "@-r15" "$asm_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm { ... } statement canonical emit"
else
    fail "regtest: asm { ... } statement output wrong — inspect $asm_out"
fi
rm -f "$asm_out"

# 4ae. asm { ... } multi-line block — canonical emit preserves each
# instruction's mnemonic + operands but normalizes whitespace. Pool
# entries (`.long`) are kept; whole-line comments are dropped (they
# don't assemble; canonical emit drops decorative whitespace).
cat > /tmp/regtest.c <<'EOF'
int multi(int x) {
    asm {
        mov.l   LP0,r3
        jsr     @r3
        nop
        ! a comment
LP0:    .long   _target
    }
    return x;
}
EOF
asm_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>/dev/null
ok=1
grep -qE $'^\tmov\\.l\tLP0,r3$' "$asm_out" || ok=0
grep -qE $'^\tjsr\t@r3$' "$asm_out" || ok=0
grep -qE '^LP0:[[:space:]]+\.long[[:space:]]+_target' "$asm_out" || ok=0
# The whole-line comment is dropped by canonical emit (intentional).
grep -qE '^[[:space:]]+! a comment' "$asm_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm { ... } multi-line canonical emit (instructions + pool kept, comments dropped)"
else
    fail "regtest: asm { ... } multi-line canonical emit wrong — inspect $asm_out"
fi
rm -f "$asm_out"

# 4af. Empty asm { } block emits no instructions and no error. The
# backend's `\t%s\n` print produces only whitespace for an empty
# body — asm_normalize.py drops that line from any diff. Regression
# guard against parse errors on the degenerate case.
cat > /tmp/regtest.c <<'EOF'
int empty(int x) {
    asm{}
    return x;
}
EOF
asm_out="$(mktemp)"
asm_err="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>"$asm_err"; then
    if [ ! -s "$asm_err" ]; then
        pass "regtest: empty asm { } accepted, no diagnostic"
    else
        fail "regtest: empty asm { } emitted unexpected diagnostic — $(head -1 "$asm_err")"
    fi
else
    fail "regtest: empty asm { } rejected (compiler crash or error)"
fi
rm -f "$asm_out" "$asm_err"

# 4ag. File-scope asm-bodied function: `int foo() asm { ... }` parses
# as a function definition with the asm block as the body. Session 1
# only proves the parser; Session 2 will skip the prologue/epilogue
# wrapping (naked emit) so the body byte-matches a prod slice.
cat > /tmp/regtest.c <<'EOF'
int FUN_test(int p1) asm {
    sts.l   pr,@-r15
    rts
    nop
}
EOF
asm_out="$(mktemp)"
asm_err="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>"$asm_err"; then
    ok=1
    grep -q '^FUN_test:' "$asm_out" || ok=0       # function label emitted (bare; Hitachi SHC convention)
    grep -qE '^[[:space:]]+sts\.l' "$asm_out" || ok=0   # body content present
    [ ! -s "$asm_err" ] || ok=0                   # no diagnostics
    if [ "$ok" = "1" ]; then
        pass "regtest: file-scope asm-bodied function parses and emits body"
    else
        fail "regtest: file-scope asm-bodied function wrong — inspect $asm_out / $asm_err"
    fi
else
    fail "regtest: file-scope asm-bodied function rejected (compiler crash)"
fi
rm -f "$asm_out" "$asm_err"

# 4ai. Parser destination detection — every write category in
# sh_p_apply_kind must produce the right writes mask. -d-asm prints
# one [asm-emit] line per parsed insn at emit time:
#   [asm-emit] [<flags>] mn=<name> reads=0x<m> writes=0x<m> sr_r=... sr_w=...
#
#   mov r4, r5      → writes r5 = 0x20
#   add #1, r0      → writes r0 = 0x1
#   mov.l @r4+, r3  → writes r3+r4 (post-inc base) = 0x18
#   sts.l pr,@-r15  → writes r15 (pre-dec) = 0x8000; reads pr
#   jsr @r6         → branch+call; reads r6 = 0x40; writes pr
#   dt r5           → reads+writes r5 = 0x20; writes T
cat > /tmp/regtest.c <<'EOF'
int test(int x) {
    asm {
        mov r4, r5
        add #1, r0
        mov.l @r4+, r3
        sts.l pr, @-r15
        jsr @r6
        dt r5
    }
    return x;
}
EOF
asm_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-asm /tmp/regtest.c /dev/null 2>"$asm_dump"
ok=1
grep -qE '\[asm-emit\] \[\] mn=mov reads=0x10 writes=0x20' "$asm_dump" || ok=0
grep -qE '\[asm-emit\] \[\] mn=add reads=0x1 writes=0x1' "$asm_dump" || ok=0
grep -qE '\[asm-emit\] \[\] mn=mov\.l reads=0x10 writes=0x18' "$asm_dump" || ok=0
grep -qE '\[asm-emit\] \[\] mn=sts\.l reads=0x8000 writes=0x8000 sr_r=0x1' "$asm_dump" || ok=0
grep -qE '\[asm-emit\] \[BC\] mn=jsr reads=0x40 writes=0x0 sr_r=0x0 sr_w=0x1' "$asm_dump" || ok=0
grep -qE '\[asm-emit\] \[\] mn=dt reads=0x20 writes=0x20 sr_r=0x0 sr_w=0x40' "$asm_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm parser destination detection per write-category"
else
    fail "regtest: asm parser destination detection wrong — inspect $asm_dump"
fi
rm -f "$asm_dump"

# 4aj. Conservative-on-unknown: a deliberately bad mnemonic must
# get is_unknown=1 (U flag in the dump) and reads/writes default to
# 0xffff so any downstream analysis sees it as "could clobber
# anything." False-clean answers would silently break byte-match.
cat > /tmp/regtest.c <<'EOF'
int test(int x) {
    asm {
        nop
        zzzfake r1, r2
        nop
    }
    return x;
}
EOF
asm_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-asm /tmp/regtest.c /dev/null 2>"$asm_dump"
if grep -qE '\[asm-emit\] \[U\] mn=zzzfake reads=0xffff writes=0xffff' "$asm_dump"; then
    pass "regtest: asm parser conservative on unknown mnemonic"
else
    fail "regtest: asm parser unknown-mnemonic handling wrong — inspect $asm_dump"
fi
rm -f "$asm_dump"

# 4r. 64-bit multiply-high idiom (SH-2 dmuls.l / dmulu.l + sts mach).
# Ghidra decompiles the dmuls.l/sts mach pair as
#     (T)(((ulonglong)((longlong)a * (longlong)b)) >> 32)
# Backend collapses the whole shape (including LCC-inserted LOAD and
# CV wrappers) to a single dmuls.l + sts mach emission. Regression
# guard against bitrot in the mulhi_s / mulhi_u lburg nonterminals
# or the RSH+U8 case in the emit switch.
cat > /tmp/regtest.c <<'EOF'
typedef unsigned long long ulonglong;
typedef long long longlong;
short mulhi_s(int a, int b) {
    return (short)((ulonglong)((longlong)a * (longlong)b) >> 32);
}
short mulhi_u(unsigned a, unsigned b) {
    return (short)((ulonglong)((ulonglong)a * (ulonglong)b) >> 32);
}
EOF
mulhi_out="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c "$mulhi_out" 2>/dev/null \
   && grep -q "dmuls.l" "$mulhi_out" \
   && grep -q "dmulu.l" "$mulhi_out" \
   && [ "$(grep -c 'sts.*mach' "$mulhi_out")" = "2" ]; then
    pass "regtest: 64-bit mul-high emits dmuls.l/dmulu.l + sts mach"
else
    fail "regtest: 64-bit mul-high did not emit expected dmuls/dmulu + sts mach"
fi
rm -f "$mulhi_out"

# 4s. Ghidra-dialect scalar-as-struct field access.
# Ghidra decompiles partial-word reads/writes on undefined4 locals
# as `x._N_M_` where N is the byte offset and M the access width.
# Strict C rejects this (scalar has no members), but rcc's expr.c
# parses `_N_M_` on int types as sugar for byte-offset pointer
# arithmetic. Verify the subfield write lowers to a `mov.b`/`mov.w`
# at the correct stack displacement.
cat > /tmp/regtest.c <<'EOF'
typedef unsigned long undefined4;
void f(void) {
    undefined4 x;
    x._0_2_ = 0x1234;
    x._2_1_ = 0x56;
}
EOF
sf_out="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c "$sf_out" 2>/dev/null \
   && grep -q "mov.w" "$sf_out" \
   && grep -q "mov.b" "$sf_out"; then
    pass "regtest: Ghidra scalar-as-struct access (_N_M_) lowers to partial-word store"
else
    fail "regtest: Ghidra scalar-as-struct field parse or emit broken"
fi
rm -f "$sf_out"

# 4t. IPA Phase E.1b: mechanism end-to-end — pinned p1 to r4 across
# all helper calls, with the ADD mutation CSE'd to a single
# `add #K, r4` that executes BEFORE both calls (in call 1's delay
# slot or earlier). Exercises the full pipeline: Phase C writes_r4
# analysis on leaf helpers, sh_ipa_all_callees_preserve_r4 predicate,
# the pin engagement in param-homing, sh_ipa_apply_mutation_rewrite's
# ASGN splice, and the running-delta CSE across calls 2..N.
#
# The test corpus has no natural trigger for this path: every
# IPA-qualifying caller in race_FUN_06044060.c has an extern callee
# that vetoes Phase C's predicate. A synthetic case is the only way
# to gate the mechanism.
#
# KNOWN FAILURE: the delay-slot filler (sh_fill_branch_delays) chain-
# moves the synthesized `add #16, r4` across both jsrs into the rts
# delay slot, so both helper calls execute with the un-mutated p1.
# A naive guard ("don't steal from any delay slot") regresses ~10
# byte-matched functions that rely on chain-moves for prod-matching.
# The correct fix is the subject of a separate investigation; this
# test documents the gap mechanically so the fix lands with proof.
cat > /tmp/regtest.c <<'EOF'
void helper_a(int x) { }
void helper_b(int x) { }
void caller(int p1) {
    helper_a(p1 + 16);
    helper_b(p1 + 16);
}
EOF
ipa_out="$(mktemp)"
if ! "$RCC" -target=sh/hitachi /tmp/regtest.c "$ipa_out" 2>/dev/null; then
    fail "regtest: IPA Phase E.1b mechanism end-to-end (compiler crash)"
else
    # Extract the caller's body: from caller: until the next label.
    # Note: helpers helper_a / helper_b emit before caller in source-
    # order drain, so the awk must arm `flag` only at caller: and stop
    # at the next top-level `<name>:` label.
    caller_body="$(awk '
        /^caller:/ {flag=1; print; next}
        flag && /^[a-zA-Z][a-zA-Z0-9_]*:/ {exit}
        flag {print}
    ' "$ipa_out")"
    # Count `add #16,r4` occurrences — CSE should collapse to one.
    n_adds=$(printf '%s\n' "$caller_body" \
             | grep -cE 'add[[:space:]]+#16,r4')
    # The ADD must appear BEFORE the second jsr to affect it. Find
    # line number of the add and the second jsr.
    first_jsr_line=$(printf '%s\n' "$caller_body" \
                     | grep -nE 'jsr[[:space:]]+@r' \
                     | head -n1 | cut -d: -f1)
    second_jsr_line=$(printf '%s\n' "$caller_body" \
                      | grep -nE 'jsr[[:space:]]+@r' \
                      | sed -n '2p' | cut -d: -f1)
    add_line=$(printf '%s\n' "$caller_body" \
               | grep -nE 'add[[:space:]]+#16,r4' \
               | head -n1 | cut -d: -f1)
    # No stash of p1 to a callee-saved register.
    stash_present=0
    printf '%s\n' "$caller_body" \
        | grep -qE 'mov[[:space:]]+r4,r(8|9|1[0-4])' \
        && stash_present=1
    ok=1
    [ "$n_adds" = "1" ] || ok=0
    [ -n "$add_line" ] || ok=0
    [ -n "$first_jsr_line" ] || ok=0
    [ -n "$second_jsr_line" ] || ok=0
    # The add must land at or before the SECOND jsr's position: a
    # delay-slot position (one line after jsr 1) is fine, because the
    # SH-2 delay slot executes before the branch jumps to the target.
    if [ "$ok" = "1" ]; then
        # add_line < second_jsr_line, AND
        # (add_line <= first_jsr_line + 1) for call 1 to also see it.
        [ "$add_line" -lt "$second_jsr_line" ] || ok=0
        [ "$add_line" -le "$((first_jsr_line + 1))" ] || ok=0
    fi
    [ "$stash_present" = "0" ] || ok=0
    [ "$ok" = "1" ] \
        && pass "regtest: IPA Phase E.1b mechanism end-to-end" \
        || fail "regtest: IPA Phase E.1b mechanism end-to-end (delay-slot filler chain-move; see validate_build.sh 4t)"
fi
rm -f "$ipa_out"

# 4u. asm-shim Stage 3: Phase C walks ASM_INSN Nodes and reads
# their parsed writes mask. Two asm-bodied callees in the same
# TU — one explicitly writes r4, one doesn't. Phase C's `-d`
# diagnostic should report writes_r4=1 for the first and
# writes_r4=0 for the second. See
# saturn/workstreams/asm_shim_design.md §6.
cat > /tmp/regtest.c <<'EOF'
extern int callee_writes_r4(int p);
extern int callee_preserves_r4(int p);

int caller(int p) {
    return callee_writes_r4(p) + callee_preserves_r4(p);
}

int callee_writes_r4(int p) asm {
    mov #5, r4
    rts
    nop
}

int callee_preserves_r4(int p) asm {
    mov #1, r0
    rts
    nop
}
EOF
ipa_d="$(mktemp)"
"$RCC" -target=sh/hitachi -d /tmp/regtest.c /dev/null 2>"$ipa_d"
ok=1
grep -qE 'callee_writes_r4 writes_r4=1' "$ipa_d" || ok=0
grep -qE 'callee_preserves_r4 writes_r4=0' "$ipa_d" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: Phase C reads ASM_INSN writes mask (Stage 3)"
else
    fail "regtest: Phase C asm writes_r4 detection wrong — inspect $ipa_d"
fi
rm -f "$ipa_d"

# 4v. asm-shim Stage 4: a whole-function asm shim
# (`int foo() asm { ... }`) emits as exactly its body content with
# no prologue, no epilogue, no synthetic return, no compiler pool
# entries. The body's own `rts` terminates flow. See
# saturn/workstreams/asm_shim_design.md §7.
cat > /tmp/regtest.c <<'EOF'
int FUN_naked_shim(int p) asm {
    sts.l   pr,@-r15
    mov.l   LP0,r3
    jsr     @r3
    nop
    rts
    nop
LP0:    .long   _some_target
}
EOF
naked_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$naked_out" 2>/dev/null
ok=1
# Function label present.
grep -qE '^FUN_naked_shim:' "$naked_out" || ok=0
# Body lines present in canonical form.
grep -qE $'^\tsts\\.l\tpr,@-r15$' "$naked_out" || ok=0
grep -qE $'^\tmov\\.l\tLP0,r3$' "$naked_out" || ok=0
grep -qE $'^\tjsr\t@r3$' "$naked_out" || ok=0
grep -qE '^LP0:[[:space:]]+\.long[[:space:]]+_some_target' "$naked_out" || ok=0
# No prologue: no callee-saved push other than the body's sts.l pr.
# Count `mov.l rN,@-r15` — should be ZERO (the body has no such push).
n_pushes=$(grep -cE 'mov\.l[[:space:]]+r[0-9]+,@-r15' "$naked_out")
[ "$n_pushes" = "0" ] || ok=0
# No epilogue: no callee-saved pop. Count `mov.l @r15+,rN` — ZERO.
n_pops=$(grep -cE 'mov\.l[[:space:]]+@r15\+,r[0-9]+' "$naked_out")
[ "$n_pops" = "0" ] || ok=0
# Exactly ONE rts (the body's own); a synthetic epilogue return
# would add a second.
n_rts=$(grep -cE '^[[:space:]]+rts$' "$naked_out")
[ "$n_rts" = "1" ] || ok=0
# No compiler-generated pool labels (`Lnnn:` from genlabel). The
# shim's own LP0 is fine; the test verifies no L<digit>: labels
# from the compiler's machinery.
grep -qE '^L[0-9]+:' "$naked_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: naked asm shim emits body verbatim, no prologue/epilogue"
else
    fail "regtest: naked asm shim wrong (n_pushes=$n_pushes n_pops=$n_pops n_rts=$n_rts) — inspect $naked_out"
fi
rm -f "$naked_out"

# 4w. asm-shim Stage 5: allocator awareness for adjacent ASM_INSN
# reads/writes. Within the window between an asm block and the next
# call/branch, the allocator must NOT pick a register the asm just
# wrote. See saturn/workstreams/asm_shim_design.md §8.
#
# The probe: a function with several local C variables (forces the
# allocator to dip into r0..r3 for short-lived temporaries), plus
# an asm block that writes r2, followed by an extern call. If the
# mechanism works, no instruction between the asm and the jsr
# writes r2 with a non-asm value.
cat > /tmp/regtest.c <<'EOF'
extern void hungry(int a, int b, int c);
extern int produce(void);
void caller(int seed) {
    int a = produce() + seed;
    int b = produce() + a;
    int c = produce() + b;
    asm { mov #99, r2 }
    hungry(a, b, c);
    /* Use a/b/c after to keep them live across the asm/call. */
    if (a + b + c == 0) hungry(0, 0, 0);
}
EOF
alloc_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$alloc_out" 2>/dev/null
ok=1
# The asm block emits `mov #99, r2`. Find that line.
asm_line=$(grep -nE 'mov[[:space:]]+#99,r2' "$alloc_out" | head -n1 | cut -d: -f1)
# Find the next jsr after the asm.
if [ -n "$asm_line" ]; then
    after_asm=$(sed -n "${asm_line},\$p" "$alloc_out")
    # Between the asm line and the next jsr, there must be no
    # instruction that writes r2. Match `<mn>\tX,r2$` (any
    # destination is r2 form). Excluding the asm line itself.
    inner=$(printf '%s\n' "$after_asm" | sed -n '2,/jsr/p')
    if printf '%s\n' "$inner" \
       | grep -qE $'^\t[a-z]+(\\.[bwl])?\t[^,]+,r2$'; then
        ok=0
    fi
else
    ok=0
fi
if [ "$ok" = "1" ]; then
    pass "regtest: allocator honors adjacent ASM_INSN writes (Stage 5)"
else
    fail "regtest: allocator picked an asm-written register — inspect $alloc_out"
fi
rm -f "$alloc_out"

# 4x. asm-shim directive emission: directives (`.byte`, `.4byte`,
# `.type`, etc.) must emit as bare verbatim text — not as
# instruction-style operands. Two failure modes that motivated this
# regtest:
#   - `.byte 0x30, 0x00` previously emitted `.byte #48,#0` because
#     SH_OP_IMM was unconditionally `#`-prefixed. sh-elf-as rejects
#     `#` outside instruction immediate context.
#   - `.type FUN_X, @function` previously dropped `@function`
#     silently because `@<ident>` doesn't fit the SH-2 operand
#     grammar. Assembler then rejects `.type` with no type expr.
# The fix is upstream: directives emit from src_text verbatim, the
# assembler is authority on operand syntax. Discovered while
# bringing up the unity-build beachhead (decomp/race in CCE).
cat > /tmp/regtest.c <<'EOF'
int FUN_dir_ops(void) asm {
    rts
    nop
LP0:
    .byte   0x30, 0x00
    .4byte  4
    .type   FUN_dir_ops, @function
}
EOF
dir_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$dir_out" 2>/dev/null
ok=1
# All three directives must appear in the output, with their
# operands intact.
grep -qE '\.byte[[:space:]]+0x30,[[:space:]]*0x00' "$dir_out" || ok=0
grep -qE '\.4byte[[:space:]]+4' "$dir_out" || ok=0
grep -qE '\.type[[:space:]]+FUN_dir_ops,[[:space:]]*@function' "$dir_out" || ok=0
# Negative: no `#` should appear on any directive line.
grep -qE '^[[:space:]]+\.(byte|4byte|long|short|word|type)[[:space:]].*#' "$dir_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: directive emission is verbatim (no `#`, no operand drop)"
else
    fail "regtest: directive emission wrong — inspect $dir_out"
fi
rm -f "$dir_out"

# 4y. Pool-label auto-alignment: the compiler must emit `.balign 4`
# immediately before `.L_pool_*` labels (mov.l targets, 4-align
# required) and `.balign 2` immediately before `.L_wpool_*` labels
# (mov.w targets, 2-align required). Naming-based trigger; non-pool
# labels and source-supplied alignment do NOT trigger emission.
# Driven by the DaytonaCCEReverse FUN_06036CF8 deletion case — see
# saturn/workstreams/pool_alignment_design.md.
#
# Five trigger cases in one body:
#   .L_pool_a   → mov.l pool       → expect .balign 4
#   .L_wpool_b  → mov.w pool       → expect .balign 2
#   .L_other_c  → non-pool label   → expect no auto-emit (Class B
#                                    bug from sha 9c7cc50)
#   .L_pool_d   → preceded by      → expect no second .balign 4
#                  .balign 4         (D3 source-align dedup)
#   .L_no_data  → label + insn,    → expect no auto-emit
#                  no follow-on
cat > /tmp/regtest.c <<'EOF'
int FUN_pool_align(void) asm {
    rts
    nop
.L_pool_a:
    .4byte  0x12345678
.L_wpool_b:
    .byte   0x01, 0x02
.L_other_c:
    .4byte  0xCAFE0BAD
    .balign 4
.L_pool_d:
    .4byte  0xDEADBEEF
.L_no_data:
    rts
    nop
.L_pool_e: .long 0xCAFEBABE
.L_wpool_f: .byte 0x03, 0x04
.L_other_g: .4byte 0x00000000
.L_wpool_pin:
    .long 0xFEEDFACE
}
EOF
pool_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$pool_out" 2>/dev/null
# Strip cpp-style line directives the compiler now emits between
# instructions (so GAS errors cite C source). They're irrelevant
# to alignment-adjacency checks but break naive "previous line"
# tests; remove them up front so the awk patterns below see the
# pure instruction stream. If a future change to line-directive
# emission shape breaks this strip, both this and asm_normalize.py
# need an update.
pool_out_clean="$(mktemp)"
# Also strip the saturncc instrumentation symbols (pad-tripwire
# probe/mark pairs + braf-verify metadata) — zero-size symbols that sit
# adjacent to every synthetic .balign and would break the "directly
# before label" awk adjacency checks below. They have their own
# regtests (4y3, 4y4).
grep -v '^# [0-9]' "$pool_out" | grep -v '^saturncc_' > "$pool_out_clean"
ok=1
# Verify: directive `dir` ($1) appears immediately before label `lbl` ($2).
check_emits() {
    local dir="$1" lbl="$2"
    awk -v dir="$dir" -v lbl="$lbl:" '
        $0 ~ dir { aligned[NR+1]=1 }
        $0 ~ "^" lbl { if (aligned[NR]) found=1 }
        END { exit found ? 0 : 1 }
    ' "$pool_out_clean"
}
# Verify: label `lbl` is NOT immediately preceded by any .balign.
check_no_emit() {
    local lbl="$1"
    awk -v lbl="$lbl:" '
        /\.balign/ { aligned[NR+1]=1 }
        $0 ~ "^" lbl { if (aligned[NR]) bad=1 }
        END { exit bad ? 1 : 0 }
    ' "$pool_out_clean"
}
check_emits  '\.balign 4' '.L_pool_a'   || ok=0
check_emits  '\.balign 2' '.L_wpool_b'  || ok=0
check_no_emit             '.L_other_c'  || ok=0   # not a pool name
check_no_emit             '.L_no_data'  || ok=0   # no follow-on data
# Combined-line form (`LABEL: directive` on one line). The parser
# stores label_name separately from the directive mnemonic; the
# pool-alignment pass reads label_name. Without that field, naming
# check would silently miss combined records. Caught in 74a8bd5
# code review.
check_emits  '\.balign 4' '.L_pool_e'   || ok=0   # combined .L_pool_*
check_emits  '\.balign 2' '.L_wpool_f'  || ok=0   # combined .L_wpool_*
check_no_emit             '.L_other_g'  || ok=0   # combined non-pool
# Trigger-semantic pin: a `.L_wpool_*` label followed by `.long`
# data. Under naming-based trigger this emits `.balign 2` (mov.w
# access). Under a regression to structural-lookahead-on-.long it
# would emit `.balign 4`. The check below FAILS if anyone reverts
# to structural — that's the point. Originally over-fired on 1,246
# wpool sites in DaytonaCCEReverse race build.
check_emits  '\.balign 2' '.L_wpool_pin' || ok=0
awk -v lbl='.L_wpool_pin:' '
    /\.balign 4/ { aligned4[NR+1]=1 }
    $0 ~ "^" lbl { if (aligned4[NR]) bad=1 }
    END { exit bad ? 1 : 0 }
' "$pool_out_clean" || ok=0
# .L_pool_d: source already has .balign 4; ours must NOT add a second.
# Count adjacent .balign 4 lines preceding .L_pool_d. Use the cleaned
# stream (line directives stripped) so a `# N "file"` between the
# source .balign and the label doesn't break the streak counter.
n_pool_d_align=$(awk '
    /\.balign 4/ { run++; next }
    /^\.L_pool_d:/ { print run; exit }
    { run=0 }
' "$pool_out_clean")
[ "$n_pool_d_align" = "1" ] || ok=0   # exactly one (the source one)
if [ "$ok" = "1" ]; then
    pass "regtest: pool-label auto-alignment (naming-based trigger + D3 dedup)"
else
    fail "regtest: pool-label auto-alignment wrong — inspect $pool_out (raw) / $pool_out_clean (line-dirs stripped)"
fi
rm -f "$pool_out" "$pool_out_clean"

# 4y2. braf/bsrf dispatch-table anchor lint: every entry of a braf-
# consumed delta table must be `TARGET - ANCHOR` label arithmetic
# with ANCHOR a label sitting at braf+4 (declared immediately after
# the delay slot, before any alignment point). Self-anchored tables
# (the FUN_06045B74 silent-corruption class) and raw-numeric tables
# (the FUN_06028000 class) are hard compile errors with NONZERO EXIT
# — the exit code is the load-bearing assertion, since the failure
# this guards against was a build that stayed green while braf
# dispatch sheared 2 bytes under a 2-mod-4 link shift. The pad-immune
# re-anchored style and ordinary mova literal pools must still pass.

# (a) must-FAIL: self-anchored dispatch table.
cat > /tmp/regtest.c <<'EOF'
void FUN_braf_selfanchor(void) asm {
    mov r0, r1
    mova .L_pool_tbl, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_pool_tbl:
    .2byte .L_case0 - .L_pool_tbl
    .2byte .L_case1 - .L_pool_tbl
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
lint_err="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>"$lint_err"; then
    fail "regtest: braf lint must reject self-anchored table (got exit 0) — inspect $lint_err"
elif grep -q 'dispatch table' "$lint_err"; then
    pass "regtest: braf lint rejects self-anchored dispatch table (nonzero exit)"
else
    fail "regtest: braf lint exited nonzero but with unexpected diagnostics — inspect $lint_err"
fi

# (b) must-FAIL: raw numeric table entries (frozen retail distances;
# unverifiable against the braf+4 base).
cat > /tmp/regtest.c <<'EOF'
void FUN_braf_rawnum(void) asm {
    mov r0, r1
    mova .L_pool_tbl, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_pool_tbl:
    .2byte 0x0032
    .2byte 0x0046
    rts
    nop
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>"$lint_err"; then
    fail "regtest: braf lint must reject raw-numeric table (got exit 0) — inspect $lint_err"
elif grep -q 'TARGET - ANCHOR' "$lint_err"; then
    pass "regtest: braf lint rejects raw-numeric dispatch table (nonzero exit)"
else
    fail "regtest: braf lint exited nonzero but with unexpected diagnostics — inspect $lint_err"
fi

# (c) must-PASS: pad-immune style — entries anchored to a plain label
# at braf+4; the .L_pool_* table label itself still gets its auto
# .balign 4 (lint and pool-align coexist on the same body).
cat > /tmp/regtest.c <<'EOF'
void FUN_braf_immune(void) asm {
    mov r0, r1
    mova .L_pool_tbl, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_ret:
.L_pool_tbl:
    .2byte .L_case0 - .L_ret
    .2byte .L_case1 - .L_ret
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>"$lint_err" \
   && ! grep -q 'dispatch table' "$lint_err" \
   && grep -v -e '^# [0-9]' -e '^saturncc_' /tmp/regtest.s | grep -B1 '^\.L_pool_tbl:' | grep -q '\.balign 4'; then
    pass "regtest: braf lint accepts pad-immune re-anchored table (auto-.balign intact)"
else
    fail "regtest: braf lint rejected pad-immune style or dropped .balign — inspect $lint_err / /tmp/regtest.s"
fi

# (d) must-PASS: ordinary literal pool — mova present, no braf.
cat > /tmp/regtest.c <<'EOF'
void FUN_braf_litpool(void) asm {
    mova .L_pool_data, r0
    mov.l @r0, r1
    rts
    nop
.L_pool_data:
    .long 0x06028000
    .long 0x0000FFFF
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /tmp/regtest.s 2>"$lint_err" \
   && ! grep -q 'dispatch table' "$lint_err"; then
    pass "regtest: braf lint silent on plain mova literal pool"
else
    fail "regtest: braf lint misfired on a literal pool — inspect $lint_err"
fi
rm -f "$lint_err"

# 4y3. Pad tripwires ("loud absorption"): every synthetic .balign is
# bracketed by a probe/mark symbol pair so materialized pads can be
# reported per-site from the .o symbol table (saturn/tools/
# pad_report.sh). NOTE: do NOT "simplify" this to an in-source
# `.if (mark - probe) != 0` + `.warning` — GAS hard-errors with
# "non-constant expression" on any .if spanning an alignment
# directive (one-pass parse-time evaluation; verified empirically).
#
# (a) emission shape: probe, .balign, mark, pool label — in order.
cat > /tmp/regtest.c <<'EOF'
void FUN_tripwire(void) asm {
    rts
    nop
    .byte 0x01
.L_pool_p:
    .long 0x12345678
}
EOF
trip_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$trip_out" 2>/dev/null
if awk '
    /^saturncc_pad_probe_0:/                { probe = NR }
    /\.balign 4/                            { if (probe) balign = NR }
    /^saturncc_pad_mark_0__L_pool_p:/       { mark = NR }
    /^\.L_pool_p:/                          { label = NR }
    END { exit (probe && balign > probe && mark > balign \
                && label > mark) ? 0 : 1 }
' "$trip_out"; then
    pass "regtest: pad-tripwire probe/mark pair brackets synthetic .balign"
else
    fail "regtest: pad-tripwire emission shape wrong — inspect $trip_out"
fi
rm -f "$trip_out"

# (b) end-to-end through GAS + nm: the misaligned body must assemble
# CLEAN (regression guard for the rejected .if/.warning form), report
# exactly one 3-byte pad, and --strict must gate on it; the aligned
# body must report zero pads and pass --strict.
SH_AS_TRIP="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-as.exe"
SH_NM_TRIP="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-nm.exe"
TRIP_WSL="/mnt/d/Projects/saturncc/build/cmp/tripwire_regtest"
TRIP_WIN="D:\\Projects\\saturncc\\build\\cmp\\tripwire_regtest"
if [ -x "$SH_AS_TRIP" ] && [ -e "$SH_NM_TRIP" ]; then
    mkdir -p "$TRIP_WSL"
    cat > "$TRIP_WSL/padfire.c" <<'EOF'
void FUN_padfire(void) asm {
    rts
    nop
    .byte 0x01
.L_pool_p:
    .long 0x12345678
}
EOF
    cat > "$TRIP_WSL/padquiet.c" <<'EOF'
void FUN_padquiet(void) asm {
    rts
    nop
.L_pool_q:
    .long 0x12345678
}
EOF
    trip_ok=1
    "$RCC" -target=sh/hitachi "$TRIP_WSL/padfire.c" "$TRIP_WSL/padfire.s" 2>/dev/null || trip_ok=0
    "$RCC" -target=sh/hitachi "$TRIP_WSL/padquiet.c" "$TRIP_WSL/padquiet.s" 2>/dev/null || trip_ok=0
    "$SH_AS_TRIP" -big -o "${TRIP_WIN}\\padfire.o" "${TRIP_WIN}\\padfire.s" 2>/dev/null || trip_ok=0
    "$SH_AS_TRIP" -big -o "${TRIP_WIN}\\padquiet.o" "${TRIP_WIN}\\padquiet.s" 2>/dev/null || trip_ok=0
    fire_rep="$(SH_NM="$SH_NM_TRIP" bash "$SCRIPT_DIR/pad_report.sh" "${TRIP_WIN}\\padfire.o")" || true
    echo "$fire_rep" | grep -q '^PAD: 3 byte(s)' || trip_ok=0
    echo "$fire_rep" | grep -q 'pads materialized: 1' || trip_ok=0
    if SH_NM="$SH_NM_TRIP" bash "$SCRIPT_DIR/pad_report.sh" "${TRIP_WIN}\\padfire.o" --strict >/dev/null; then
        trip_ok=0    # strict must FAIL on a materialized pad
    fi
    quiet_rep="$(SH_NM="$SH_NM_TRIP" bash "$SCRIPT_DIR/pad_report.sh" "${TRIP_WIN}\\padquiet.o" --strict)" || trip_ok=0
    echo "$quiet_rep" | grep -q 'pads materialized: 0' || trip_ok=0
    if [ "$trip_ok" = "1" ]; then
        pass "regtest: pad tripwires end-to-end (GAS clean, 3-byte pad reported, strict gates)"
    else
        fail "regtest: pad tripwires end-to-end wrong — inspect $TRIP_WSL"
    fi

    # (c) as_pad_wrap.sh — the automatic form consumers adopt by
    # pointing AS at the wrapper. Pad case: assembles, warns on
    # stderr, exit 0 (and exit 1 under SATURNCC_PAD_STRICT=1).
    # Aligned case: assembles, silent, exit 0.
    wrap_ok=1
    wrap_err="$(mktemp)"
    SH_NM="$SH_NM_TRIP" SATURNCC_AS="$SH_AS_TRIP" \
        bash "$SCRIPT_DIR/as_pad_wrap.sh" -big \
        -o "${TRIP_WIN}\\padfire.o" "${TRIP_WIN}\\padfire.s" \
        2>"$wrap_err" || wrap_ok=0
    grep -q 'saturncc pad warning .*PAD: 3 byte(s)' "$wrap_err" || wrap_ok=0
    if SH_NM="$SH_NM_TRIP" SATURNCC_AS="$SH_AS_TRIP" SATURNCC_PAD_STRICT=1 \
        bash "$SCRIPT_DIR/as_pad_wrap.sh" -big \
        -o "${TRIP_WIN}\\padfire.o" "${TRIP_WIN}\\padfire.s" \
        2>/dev/null; then
        wrap_ok=0    # strict must FAIL on a materialized pad
    fi
    SH_NM="$SH_NM_TRIP" SATURNCC_AS="$SH_AS_TRIP" \
        bash "$SCRIPT_DIR/as_pad_wrap.sh" -big \
        -o "${TRIP_WIN}\\padquiet.o" "${TRIP_WIN}\\padquiet.s" \
        2>"$wrap_err" || wrap_ok=0
    [ -s "$wrap_err" ] && wrap_ok=0    # aligned case must be silent
    if [ "$wrap_ok" = "1" ]; then
        pass "regtest: as_pad_wrap.sh auto-reports pads (warn/strict/silent)"
    else
        fail "regtest: as_pad_wrap.sh behavior wrong — inspect $TRIP_WSL / $wrap_err"
    fi
    rm -f "$wrap_err"
else
    pass "regtest: pad tripwires end-to-end (sh-elf toolchain absent — skipped)"
fi

# 4y4. Binary braf verification: the lint stamps blessed dispatch
# tables with a saturncc_braf_K / _anchor / _tbl_N symbol family;
# braf_verify.py checks ground truth in the assembled object (anchor
# == braf+4, entry targets sane, unverified dispatches swept).
# as_pad_wrap.sh runs it automatically and ALWAYS fails the build on
# verifier errors — they are guaranteed-broken dispatch math.
#
# (a) emission shape: the three symbols appear at their sites.
cat > /tmp/regtest.c <<'EOF'
void FUN_braf_meta(void) asm {
    mov r0, r1
    mova .L_pool_tbl, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_ret:
.L_pool_tbl:
    .2byte .L_case0 - .L_ret
    .2byte .L_case1 - .L_ret
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
meta_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$meta_out" 2>/dev/null
ok=1
grep -q '^saturncc_braf_1:$' "$meta_out" || ok=0
grep -q '^saturncc_braf_1_anchor:$' "$meta_out" || ok=0
grep -q '^saturncc_braf_1_tbl_2:$' "$meta_out" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: braf-verify metadata symbols emitted (dispatch/anchor/tbl_N)"
else
    fail "regtest: braf-verify metadata emission wrong — inspect $meta_out"
fi

# (b)-(d) end-to-end through GAS + nm + objdump, gated on the SDK.
SH_AS_BV="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-as.exe"
SH_NM_BV="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-nm.exe"
SH_OD_BV="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-objdump.exe"
BV_WSL="/mnt/d/Projects/saturncc/build/cmp/brafverify_regtest"
BV_WIN="D:\\Projects\\saturncc\\build\\cmp\\brafverify_regtest"
if [ -x "$SH_AS_BV" ] && [ -e "$SH_NM_BV" ] && [ -e "$SH_OD_BV" ]; then
    mkdir -p "$BV_WSL"
    bv_ok=1
    cp "$meta_out" "$BV_WSL/good.s"
    # (b) good object: 1 table verified, 0 errors, exit 0.
    "$SH_AS_BV" -big -o "${BV_WIN}\\good.o" "${BV_WIN}\\good.s" 2>/dev/null || bv_ok=0
    bv_rep="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${BV_WIN}\\good.o")" || bv_ok=0
    echo "$bv_rep" | grep -q 'braf tables verified: 1, errors: 0' || bv_ok=0
    # (c) corrupted anchor (nop wedged between delay slot and anchor):
    # verifier must report the shear and exit 1; the wrapper must
    # fail the build even without strict mode.
    sed '/^saturncc_braf_1_anchor:/i\	nop' "$BV_WSL/good.s" > "$BV_WSL/bad.s"
    "$SH_AS_BV" -big -o "${BV_WIN}\\bad.o" "${BV_WIN}\\bad.s" 2>/dev/null || bv_ok=0
    if bv_bad="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${BV_WIN}\\bad.o")"; then
        bv_ok=0    # must exit nonzero
    fi
    echo "$bv_bad" | grep -q 'sheared by +2 bytes' || bv_ok=0
    if SH_NM="$SH_NM_BV" SATURNCC_AS="$SH_AS_BV" SH_OBJDUMP="$SH_OD_BV" \
        bash "$SCRIPT_DIR/as_pad_wrap.sh" -big \
        -o "${BV_WIN}\\bad.o" "${BV_WIN}\\bad.s" 2>/dev/null; then
        bv_ok=0    # wrapper must fail the build on braf errors
    fi
    # (d) metadata-less braf: INFO line, exit 0.
    cat > "$BV_WSL/nometa.c" <<'EOF'
void FUN_nometa(void) asm {
    mov r4, r1
    braf r1
    nop
    rts
    nop
}
EOF
    "$RCC" -target=sh/hitachi "$BV_WSL/nometa.c" "$BV_WSL/nometa.s" 2>/dev/null || bv_ok=0
    "$SH_AS_BV" -big -o "${BV_WIN}\\nometa.o" "${BV_WIN}\\nometa.s" 2>/dev/null || bv_ok=0
    bv_nm="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${BV_WIN}\\nometa.o")" || bv_ok=0
    echo "$bv_nm" | grep -q 'INFO: unverified braf' || bv_ok=0
    if [ "$bv_ok" = "1" ]; then
        pass "regtest: braf_verify end-to-end (good passes, sheared anchor caught + fails build, no-metadata swept)"
    else
        fail "regtest: braf_verify end-to-end wrong — inspect $BV_WSL"
    fi
else
    pass "regtest: braf_verify end-to-end (sh-elf toolchain absent — skipped)"
fi
rm -f "$meta_out"

# 4y5. First-class dispatch construct (.dispatch_table / .case /
# .end_dispatch): rcc owns anchor placement, alignment, tripwires,
# metadata, and delta arithmetic; the human declares the case list.
# Design: saturn/nti/dispatch_table_construct.md. The keystone
# assertion is (b): the expansion is byte-identical to the
# hand-written pad-immune label-pair form.
#
# (a) expansion shape.
cat > /tmp/regtest.c <<'EOF'
void FUN_dispatch(void) asm {
    mov r0, r1
    mova .L_pool_t, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
    .dispatch_table .L_pool_t
    .case .L_case0
    .case .L_case1
    .end_dispatch
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
dc_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$dc_out" 2>/dev/null
ok=1
grep -q '^\.L_disp_anchor_1:$' "$dc_out" || ok=0
grep -q '^saturncc_braf_1:$' "$dc_out" || ok=0
grep -q '^saturncc_braf_1_anchor:$' "$dc_out" || ok=0
grep -q '^saturncc_braf_1_tbl_2:$' "$dc_out" || ok=0
grep -q '\.2byte .L_case0 - .L_disp_anchor_1' "$dc_out" || ok=0
grep -q '\.2byte .L_case1 - .L_disp_anchor_1' "$dc_out" || ok=0
grep -q '^\.L_pool_t:$' "$dc_out" || ok=0
# .case/.end_dispatch must NOT survive into the output.
grep -qE '^\s*\.(case|end_dispatch)\b' "$dc_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: .dispatch_table expands to anchor + aligned table + anchored deltas"
else
    fail "regtest: .dispatch_table expansion wrong — inspect $dc_out"
fi

# (d) error cases (ungated — pure rcc).
dc_err="$(mktemp)"
cat > /tmp/regtest.c <<'EOF'
void FUN_badpos(void) asm {
    rts
    nop
    .dispatch_table .L_pool_t
    .case .L_case0
    .end_dispatch
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$dc_err"; then
    fail "regtest: .dispatch_table without feeding mova not rejected"
elif grep -q 'no `mova' "$dc_err"; then
    pass "regtest: .dispatch_table without feeding mova rejected (nonzero exit)"
else
    fail "regtest: .dispatch_table no-mova error message wrong — inspect $dc_err"
fi
cat > /tmp/regtest.c <<'EOF'
void FUN_orphan(void) asm {
    rts
    nop
    .case .L_x
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$dc_err"; then
    fail "regtest: orphan .case not rejected"
elif grep -q 'outside a `.dispatch_table` block' "$dc_err"; then
    pass "regtest: orphan .case rejected (nonzero exit)"
else
    fail "regtest: orphan .case error message wrong — inspect $dc_err"
fi
cat > /tmp/regtest.c <<'EOF'
void FUN_noclose(void) asm {
    mov r0, r1
    mova .L_pool_t, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
    .dispatch_table .L_pool_t
    .case .L_case0
}
EOF
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$dc_err"; then
    fail "regtest: unterminated .dispatch_table not rejected"
elif grep -q 'no `.end_dispatch`' "$dc_err"; then
    pass "regtest: unterminated .dispatch_table rejected (nonzero exit)"
else
    fail "regtest: unterminated .dispatch_table error message wrong — inspect $dc_err"
fi
rm -f "$dc_err"

# (b)+(c) byte-identity vs the hand-written pad-immune form, and
# braf_verify acceptance of the construct object. Gated on the SDK.
DC_WSL="/mnt/d/Projects/saturncc/build/cmp/dispatch_regtest"
DC_WIN="D:\\Projects\\saturncc\\build\\cmp\\dispatch_regtest"
if [ -x "$SH_AS_BV" ] && [ -e "$SH_NM_BV" ] && [ -e "$SH_OD_BV" ]; then
    mkdir -p "$DC_WSL"
    dc_ok=1
    cp "$dc_out" "$DC_WSL/construct.s"
    cat > "$DC_WSL/hand.c" <<'EOF'
void FUN_dispatch(void) asm {
    mov r0, r1
    mova .L_pool_t, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_ret:
.L_pool_t:
    .2byte .L_case0 - .L_ret
    .2byte .L_case1 - .L_ret
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
    "$RCC" -target=sh/hitachi "$DC_WSL/hand.c" "$DC_WSL/hand.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\construct.o" "${DC_WIN}\\construct.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\hand.o" "${DC_WIN}\\hand.s" 2>/dev/null || dc_ok=0
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\construct.o" | tail -n +4 > "$DC_WSL/construct.hex"
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\hand.o" | tail -n +4 > "$DC_WSL/hand.hex"
    diff -q "$DC_WSL/construct.hex" "$DC_WSL/hand.hex" >/dev/null || dc_ok=0
    dc_rep="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${DC_WIN}\\construct.o")" || dc_ok=0
    echo "$dc_rep" | grep -q 'braf tables verified: 1, errors: 0' || dc_ok=0
    if [ "$dc_ok" = "1" ]; then
        pass "regtest: construct expansion byte-identical to hand-written form + braf_verify clean"
    else
        fail "regtest: construct byte-identity / verification wrong — inspect $DC_WSL"
    fi

    # (e) bsrf call site with separated table: bsrf+4 is the live
    # return point (anchor welded there), the table lives after the
    # epilogue. Byte-identity against the hand-written pad-immune
    # equivalent. Modeled on the real FUN_0603E394 shape.
    dc_ok=1
    cat > "$DC_WSL/bsrf_c.c" <<'EOF'
void FUN_bsrf_disp(void) asm {
    sts.l pr, @-r15
    mov r4, r1
    mova .L_pool_b, r0
    mov.w @(r0, r1), r0
    bsrf r0
    nop
.L_retpt:
    lds.l @r15+, pr
    rts
    nop
    .dispatch_table .L_pool_b
    .case .L_sub0
    .case .L_sub1
    .end_dispatch
.L_sub0:
    rts
    nop
.L_sub1:
    rts
    nop
}
EOF
    cat > "$DC_WSL/bsrf_h.c" <<'EOF'
void FUN_bsrf_disp(void) asm {
    sts.l pr, @-r15
    mov r4, r1
    mova .L_pool_b, r0
    mov.w @(r0, r1), r0
    bsrf r0
    nop
.L_retpt:
    lds.l @r15+, pr
    rts
    nop
.L_pool_b:
    .2byte .L_sub0 - .L_retpt
    .2byte .L_sub1 - .L_retpt
.L_sub0:
    rts
    nop
.L_sub1:
    rts
    nop
}
EOF
    "$RCC" -target=sh/hitachi "$DC_WSL/bsrf_c.c" "$DC_WSL/bsrf_c.s" 2>/dev/null || dc_ok=0
    "$RCC" -target=sh/hitachi "$DC_WSL/bsrf_h.c" "$DC_WSL/bsrf_h.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\bsrf_c.o" "${DC_WIN}\\bsrf_c.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\bsrf_h.o" "${DC_WIN}\\bsrf_h.s" 2>/dev/null || dc_ok=0
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\bsrf_c.o" | tail -n +4 > "$DC_WSL/bsrf_c.hex"
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\bsrf_h.o" | tail -n +4 > "$DC_WSL/bsrf_h.hex"
    diff -q "$DC_WSL/bsrf_c.hex" "$DC_WSL/bsrf_h.hex" >/dev/null || dc_ok=0
    dc_rep="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${DC_WIN}\\bsrf_c.o")" || dc_ok=0
    echo "$dc_rep" | grep -q 'braf tables verified: 1, errors: 0' || dc_ok=0
    if [ "$dc_ok" = "1" ]; then
        pass "regtest: bsrf construct (separated table, welded anchor) byte-identical + verified"
    else
        fail "regtest: bsrf construct wrong — inspect $DC_WSL"
    fi

    # (f) pool-word gap (FUN_06028000 shape, from the downstream
    # site inventory): auto-aligned pool words sit BETWEEN the
    # welded anchor (braf+4) and the table — multiple independent
    # pads between the hardware base and the entries, all absorbed
    # by re-pricing. Byte-identity against the hand-written form.
    dc_ok=1
    cat > "$DC_WSL/poolgap_c.c" <<'EOF'
void FUN_poolgap(void) asm {
    mov r0, r1
    mova .L_pool_t, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_pool_a:
    .4byte 0x12345678
.L_pool_b:
    .4byte 0xCAFEBABE
    .dispatch_table .L_pool_t
    .case .L_case0
    .case .L_case1
    .end_dispatch
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
    cat > "$DC_WSL/poolgap_h.c" <<'EOF'
void FUN_poolgap(void) asm {
    mov r0, r1
    mova .L_pool_t, r0
    mov.w @(r0, r1), r1
    braf r1
    nop
.L_ret:
.L_pool_a:
    .4byte 0x12345678
.L_pool_b:
    .4byte 0xCAFEBABE
.L_pool_t:
    .2byte .L_case0 - .L_ret
    .2byte .L_case1 - .L_ret
.L_case0:
    rts
    nop
.L_case1:
    rts
    nop
}
EOF
    "$RCC" -target=sh/hitachi "$DC_WSL/poolgap_c.c" "$DC_WSL/poolgap_c.s" 2>/dev/null || dc_ok=0
    "$RCC" -target=sh/hitachi "$DC_WSL/poolgap_h.c" "$DC_WSL/poolgap_h.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\poolgap_c.o" "${DC_WIN}\\poolgap_c.s" 2>/dev/null || dc_ok=0
    "$SH_AS_BV" -big -o "${DC_WIN}\\poolgap_h.o" "${DC_WIN}\\poolgap_h.s" 2>/dev/null || dc_ok=0
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\poolgap_c.o" | tail -n +4 > "$DC_WSL/poolgap_c.hex"
    "$SH_OD_BV" -s -j .text "${DC_WIN}\\poolgap_h.o" | tail -n +4 > "$DC_WSL/poolgap_h.hex"
    diff -q "$DC_WSL/poolgap_c.hex" "$DC_WSL/poolgap_h.hex" >/dev/null || dc_ok=0
    dc_rep="$(SH_NM="$SH_NM_BV" SH_OBJDUMP="$SH_OD_BV" python3 "$SCRIPT_DIR/braf_verify.py" "${DC_WIN}\\poolgap_c.o")" || dc_ok=0
    echo "$dc_rep" | grep -q 'braf tables verified: 1, errors: 0' || dc_ok=0
    if [ "$dc_ok" = "1" ]; then
        pass "regtest: pool-word-gap construct (pads between anchor and table) byte-identical + verified"
    else
        fail "regtest: pool-word-gap construct wrong — inspect $DC_WSL"
    fi
else
    pass "regtest: construct byte-identity (sh-elf toolchain absent — skipped)"
fi
rm -f "$dc_out"

# 4z. Line directive emission: saturncc emits cpp-style
# `# <line> "<file>"` directives ahead of each asm-body instruction
# so GAS error messages cite the original C source instead of the
# generated .s file. End-to-end test: compile a body with a known-
# undefined `bsr`, assemble through sh-elf-as, verify the error
# names the C source path and the C line of the bsr. This is the
# whole acceptance signal for the feature.
SH_AS_REG="/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-as.exe"
LINE_WORK_WIN="D:\\Projects\\saturncc\\build\\cmp\\linedir_regtest"
LINE_WORK_WSL="/mnt/d/Projects/saturncc/build/cmp/linedir_regtest"
mkdir -p "$LINE_WORK_WSL"
cat > "$LINE_WORK_WSL/probe.c" <<'EOF'
extern int FUN_already_deleted(void);
int FUN_caller(void) asm {
    rts
    nop
    bsr  FUN_already_deleted
    nop
}
EOF
"$RCC" -target=sh/hitachi "$LINE_WORK_WSL/probe.c" "$LINE_WORK_WSL/probe.s" 2>/dev/null
line_ok=1
# Compiler-side check ALWAYS runs: must emit a `# 5 "...probe.c"`
# directive (the bsr is on source line 5). Independent of whether
# sh-elf-as is installed. Without this hoist, a CI without the SDK
# would silently pass-through and miss real regressions.
grep -qE "^# 5 \".*probe\.c\"$" "$LINE_WORK_WSL/probe.s" || line_ok=0
# End-to-end check (GAS round trip) only when sh-elf-as is available.
if [ -x "$SH_AS_REG" ]; then
    as_err="$("$SH_AS_REG" -big -o "${LINE_WORK_WIN}\\probe.o" "${LINE_WORK_WIN}\\probe.s" 2>&1)"
    echo "$as_err" | grep -qE "probe\.c:5: Error: .*FUN_already_deleted" || line_ok=0
fi
if [ "$line_ok" = "1" ]; then
    if [ -x "$SH_AS_REG" ]; then
        pass "regtest: cpp-style line directives propagate GAS errors to C source"
    else
        pass "regtest: cpp-style line directives emitted (sh-elf-as absent — end-to-end skipped)"
    fi
else
    fail "regtest: line directive propagation wrong — inspect $LINE_WORK_WSL/probe.s"
fi

# 4z'. Same-line one-liner: pin behavior for `int FUN_X(void) asm { rts }`
# where the entire body is on the same source line as the `asm` keyword.
# The off-by-one in sh_asm_insn_src_line (`src_line_base + line_no - 1`)
# was designed around multi-line bodies where line_no=1 corresponds to
# the empty content right after `{`. For a one-liner, the single insn
# is line_no=1 too, and its directive should still cite the keyword's
# line — not keyword+1. Without this regtest the same-line shape was
# untested.
cat > "$LINE_WORK_WSL/oneliner.c" <<'EOF'
int FUN_oneliner(void) asm { rts }
EOF
"$RCC" -target=sh/hitachi "$LINE_WORK_WSL/oneliner.c" "$LINE_WORK_WSL/oneliner.s" 2>/dev/null
# `asm` is on line 1; the rts should be attributed to line 1 too.
if grep -qE "^# 1 \".*oneliner\.c\"$" "$LINE_WORK_WSL/oneliner.s"; then
    pass "regtest: line directive correct for same-line one-liner asm body"
else
    fail "regtest: same-line one-liner missing or mis-numbered directive — inspect $LINE_WORK_WSL/oneliner.s"
fi

# 4ba. __entry_alias__ Stage 1 — front-end recognition. Two declarations
# at file scope must parse and land in the backend table with correct
# fn_name / offset / alias. The -d-entry-alias flag dumps the table at
# progend; we grep its lines.
cat > /tmp/regtest.c <<'EOF'
int real_func(int x) {
    return x + 1;
}
__entry_alias__(real_func, 4, "alt_entry");
__entry_alias__(real_func, 8, "third_entry");
EOF
ea_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-entry-alias /tmp/regtest.c /dev/null 2>"$ea_dump"
ok=1
grep -qE '^\[entry-alias\] 2 entries$' "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] real_func @ \+4 -> alt_entry$' "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] real_func @ \+8 -> third_entry$' "$ea_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 1 parses + populates backend table"
else
    fail "regtest: __entry_alias__ Stage 1 wrong — inspect $ea_dump"
fi
rm -f "$ea_dump"

# 4bc. __entry_alias__ Stage 2 — IR attachment resolves declared
# offsets to insn indices in the asm body. Three happy-path offsets
# at 0, 2, 4 against a 3-insn body should resolve cleanly.
cat > /tmp/regtest.c <<'EOF'
int real_func(void) asm {
    mov r4, r0
    rts
    nop
}
__entry_alias__(real_func, 0, "alt_entry");
__entry_alias__(real_func, 2, "alt_mid");
__entry_alias__(real_func, 4, "alt_end");
EOF
ea_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-entry-alias /tmp/regtest.c /dev/null 2>"$ea_dump"
ok=1
grep -qE '^\[entry-alias\] resolve fn=real_func n=3' "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] resolve real_func @ \+0 -> alt_entry at insn_idx=0$' "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] resolve real_func @ \+2 -> alt_mid at insn_idx=[0-9]+$' "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] resolve real_func @ \+4 -> alt_end at insn_idx=[0-9]+$' "$ea_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 2 resolves offsets to insn indices"
else
    fail "regtest: __entry_alias__ Stage 2 wrong — inspect $ea_dump"
fi
rm -f "$ea_dump"

# 4bd. __entry_alias__ Stage 2 — off-boundary offset (1, between
# 0-byte mov and 2-byte rts) errors and is NOT included in resolved
# count. The diagnostic must name the nearest boundaries.
cat > /tmp/regtest.c <<'EOF'
int real_func(void) asm {
    mov r4, r0
    rts
    nop
}
__entry_alias__(real_func, 1, "off_boundary");
EOF
ea_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-entry-alias /tmp/regtest.c /dev/null 2>"$ea_dump"
ok=1
grep -q "does not land on an instruction boundary" "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] resolve fn=real_func n=0' "$ea_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 2 errors on off-boundary offset"
else
    fail "regtest: __entry_alias__ Stage 2 boundary check wrong — inspect $ea_dump"
fi
rm -f "$ea_dump"

# 4bg. __entry_alias__ Stage 4 — link-time deletion-safety contract.
# Two TUs: tu_a defines real_func with alias alt_entry at offset 2;
# tu_b references alt_entry via a pool entry. With tu_a's alias
# declaration intact, both TUs link cleanly. With real_func + its
# alias declaration removed, the link must fail with an undefined-
# symbol error citing alt_entry.
#
# This is the editing-safety contract from the FUN_06036BB8 case
# (DaytonaCCEReverse/.../decomp_request_dead_code_safety_FUN_06036BB8_case.md):
# deletion of the parent function makes any caller's link fail loudly
# instead of silently corrupting the build.
SH_AS=/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-as.exe
SH_LD=/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-ld.exe
SH_NM=/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-nm.exe
if [ -x "$SH_AS" ] && [ -x "$SH_LD" ] && [ -x "$SH_NM" ]; then
    EA_WORK="$REPO/build/s4_test"
    rm -rf "$EA_WORK" && mkdir -p "$EA_WORK"
    EA_WIN="${EA_WORK//\/mnt\/d/D:}"; EA_WIN="${EA_WIN//\//\\}"
    cat > "$EA_WORK/tu_a.c" <<'EOF'
int real_func(void) asm {
    mov r4, r0
    rts
    nop
}
__entry_alias__(real_func, 2, "alt_entry");
EOF
    cat > "$EA_WORK/tu_b.c" <<'EOF'
int caller(void) asm {
    mov.l alt_entry_ptr, r0
    jsr @r0
    nop
    rts
    nop
.balign 4
alt_entry_ptr:
    .long alt_entry
}
EOF
    cat > "$EA_WORK/tu_a_empty.c" <<'EOF'
/* real_func deleted; alias declaration also gone since it referenced real_func */
EOF
    "$RCC" -target=sh/hitachi "$EA_WORK/tu_a.c" "$EA_WORK/tu_a.s" 2>/dev/null
    "$RCC" -target=sh/hitachi "$EA_WORK/tu_b.c" "$EA_WORK/tu_b.s" 2>/dev/null
    "$RCC" -target=sh/hitachi "$EA_WORK/tu_a_empty.c" "$EA_WORK/tu_a_empty.s" 2>/dev/null
    "$SH_AS" -little -o "$EA_WIN\\tu_a.o" "$EA_WIN\\tu_a.s" 2>/dev/null
    "$SH_AS" -little -o "$EA_WIN\\tu_b.o" "$EA_WIN\\tu_b.s" 2>/dev/null
    "$SH_AS" -little -o "$EA_WIN\\tu_a_empty.o" "$EA_WIN\\tu_a_empty.s" 2>/dev/null
    ok=1
    # Exit codes from .exe tools invoked through WSL are unreliable to
    # capture via $?. Use produced-file presence + link-error content
    # to gate success/failure instead.
    rm -f "$EA_WORK/linked.elf" "$EA_WORK/linked2.elf"
    # Phase 1: link with alias defined — linked.elf must exist after.
    "$SH_LD" -EL -Ttext=0x06000000 -e real_func -o "$EA_WIN\\linked.elf" \
        "$EA_WIN\\tu_a.o" "$EA_WIN\\tu_b.o" >/dev/null 2>"$EA_WORK/link1.err"
    [ -s "$EA_WORK/linked.elf" ] || ok=0
    [ ! -s "$EA_WORK/link1.err" ] || ok=0
    # alt_entry must be defined in tu_a.o at real_func + 2.
    "$SH_NM" "$EA_WIN\\tu_a.o" 2>/dev/null \
        | tr -d '\r' | grep -qE '^00000002 T alt_entry$' || ok=0
    # Phase 2: link with real_func + alias removed — linked2.elf must
    # NOT be created, and link2.err must carry the undefined-symbol
    # diagnostic naming alt_entry.
    "$SH_LD" -EL -Ttext=0x06000000 -e caller -o "$EA_WIN\\linked2.elf" \
        "$EA_WIN\\tu_a_empty.o" "$EA_WIN\\tu_b.o" >/dev/null 2>"$EA_WORK/link2.err"
    [ ! -s "$EA_WORK/linked2.elf" ] || ok=0
    grep -q "undefined reference to .alt_entry." "$EA_WORK/link2.err" || ok=0
    if [ "$ok" = "1" ]; then
        pass "regtest: __entry_alias__ Stage 4 deletion-safety (link breaks loudly)"
    else
        fail "regtest: __entry_alias__ Stage 4 wrong — inspect $EA_WORK/"
    fi
else
    # sh-elf toolchain unavailable — Stage 4 needs the linker; skip
    # rather than fail. CI machines without the SDK still get value
    # from Stages 1-3.
    echo "  SKIP  regtest: __entry_alias__ Stage 4 (sh-elf toolchain not found)"
fi

# 4bf. __entry_alias__ Stage 3 — `.global ALIAS\n` + `ALIAS:\n` are
# emitted at each resolved insn-index in the asm body. Four aliases
# at offsets 0/2/4/6 cover entry, mid-body, and post-last-insn.
cat > /tmp/regtest.c <<'EOF'
int real_func(void) asm {
    mov r4, r0
    rts
    nop
}
__entry_alias__(real_func, 0, "alt_at_entry");
__entry_alias__(real_func, 2, "alt_after_mov");
__entry_alias__(real_func, 4, "alt_after_rts");
__entry_alias__(real_func, 6, "alt_at_end");
EOF
asm_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>/dev/null
ok=1
# Each alias must produce both directive lines, in order.
awk '
/^\treal_func:?$|^real_func:$/    { seen["real_func"]=NR }
/^\t\.global\talt_at_entry$/      { glb["alt_at_entry"]=NR }
/^alt_at_entry:$/                 { lbl["alt_at_entry"]=NR }
/^\t\.global\talt_after_mov$/     { glb["alt_after_mov"]=NR }
/^alt_after_mov:$/                { lbl["alt_after_mov"]=NR }
/^\t\.global\talt_after_rts$/     { glb["alt_after_rts"]=NR }
/^alt_after_rts:$/                { lbl["alt_after_rts"]=NR }
/^\t\.global\talt_at_end$/        { glb["alt_at_end"]=NR }
/^alt_at_end:$/                   { lbl["alt_at_end"]=NR }
END {
    for (a in glb) if (!(a in lbl) || lbl[a] != glb[a]+1) exit 1
    if (lbl["alt_at_entry"] >= lbl["alt_after_mov"]) exit 2
    if (lbl["alt_after_mov"] >= lbl["alt_after_rts"]) exit 3
    if (lbl["alt_after_rts"] >= lbl["alt_at_end"]) exit 4
    exit 0
}' "$asm_out" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 3 emits .global+label at each resolved position"
else
    fail "regtest: __entry_alias__ Stage 3 wrong — inspect $asm_out"
fi
rm -f "$asm_out"

# 4be. __entry_alias__ Stage 2 — out-of-range offset (1000 vs 6-byte
# body) errors with the body size in the message.
cat > /tmp/regtest.c <<'EOF'
int real_func(void) asm {
    mov r4, r0
    rts
    nop
}
__entry_alias__(real_func, 1000, "way_too_far");
EOF
ea_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-entry-alias /tmp/regtest.c /dev/null 2>"$ea_dump"
ok=1
grep -q "offset exceeds function body size" "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] resolve fn=real_func n=0' "$ea_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 2 errors on out-of-range offset"
else
    fail "regtest: __entry_alias__ Stage 2 OOR check wrong — inspect $ea_dump"
fi
rm -f "$ea_dump"

# 4bb. __entry_alias__ Stage 1 — malformed declarations error and
# recover without polluting the table. Missing-comma case picked from
# the parser's recovery path.
cat > /tmp/regtest.c <<'EOF'
int real_func(int x) { return x + 1; }
__entry_alias__(real_func, 4 "missing_comma");
EOF
ea_err="$(mktemp)"
ea_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-entry-alias /tmp/regtest.c /dev/null 2>"$ea_dump"
ok=1
grep -q "expects \`,' after offset" "$ea_dump" || ok=0
grep -qE '^\[entry-alias\] 0 entries$' "$ea_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __entry_alias__ Stage 1 errors+recovers on malformed decl"
else
    fail "regtest: __entry_alias__ Stage 1 recovery wrong — inspect $ea_dump"
fi
rm -f "$ea_err" "$ea_dump"

# 4bh. __naked__ multi-block asm function with an INLINE __entry_alias__
# marker (feature/naked-multiblock). Distinct from the file-scope
# __entry_alias__(FN, offset, "ALIAS") form: the inline form takes a
# bare entry NAME, no offset — its position between the asm blocks IS
# the offset. `__naked__` suppresses the synthetic return so a compound
# body of multiple asm{} statements lowers to an all-ASM_INSN+V code
# list and the naked-shim fast path fires.
#
# Verifies:
#   - both asm blocks emit verbatim, in source order,
#   - no prologue/epilogue/synthetic return (only the body's own
#     pushes/pops/rts — exactly one rts, no compiler pool labels),
#   - `.global ALT_ENTRY` + `ALT_ENTRY:` land at the boundary,
#     immediately before the second block's first instruction.
cat > /tmp/regtest.c <<'EOF'
void FUN_mb(void) __naked__ {
    asm {
        mov.l   r14,@-r15
        mov.l   r13,@-r15
    }
    __entry_alias__(ALT_ENTRY);
    asm {
        sts.l   pr,@-r15
        rts
        mov.l   @r15+,r14
    }
}
EOF
mb_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$mb_out" 2>/dev/null
ok=1
# Function entry label present.
grep -qE '^FUN_mb:' "$mb_out" || ok=0
# Both blocks' instructions present in source order.
grep -qE $'^\tmov\\.l\tr14,@-r15$' "$mb_out" || ok=0
grep -qE $'^\tmov\\.l\tr13,@-r15$' "$mb_out" || ok=0
grep -qE $'^\tsts\\.l\tpr,@-r15$' "$mb_out" || ok=0
# Inline marker emits .global + label.
grep -qE $'^\t\\.global\tALT_ENTRY$' "$mb_out" || ok=0
grep -qE '^ALT_ENTRY:$' "$mb_out" || ok=0
# The marker label must sit BETWEEN the two blocks: the line number of
# ALT_ENTRY: must be after r13's push and before pr's push.
ln_r13=$(grep -nE $'^\tmov\\.l\tr13,@-r15$' "$mb_out" | head -1 | cut -d: -f1)
ln_alias=$(grep -nE '^ALT_ENTRY:$' "$mb_out" | head -1 | cut -d: -f1)
ln_pr=$(grep -nE $'^\tsts\\.l\tpr,@-r15$' "$mb_out" | head -1 | cut -d: -f1)
[ -n "$ln_r13" ] && [ -n "$ln_alias" ] && [ -n "$ln_pr" ] || ok=0
[ "$ok" = "1" ] && { [ "$ln_r13" -lt "$ln_alias" ] && [ "$ln_alias" -lt "$ln_pr" ] || ok=0; }
# Exactly ONE rts (the body's own); a synthetic return would add another.
n_rts=$(grep -cE '^[[:space:]]+rts$' "$mb_out")
[ "$n_rts" = "1" ] || ok=0
# No compiler-generated pool labels (Lnnn:).
grep -qE '^L[0-9]+:' "$mb_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: __naked__ multi-block asm + inline __entry_alias__ marker"
else
    fail "regtest: __naked__ multi-block wrong (n_rts=$n_rts r13@$ln_r13 alias@$ln_alias pr@$ln_pr) — inspect $mb_out"
fi
rm -f "$mb_out"

# 4bi. __naked__ on a non-definition (no body) is rejected.
cat > /tmp/regtest.c <<'EOF'
void FUN_nobody(void) __naked__;
EOF
nk_err="$(mktemp)"
if "$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$nk_err"; then
    fail "regtest: __naked__ on non-definition incorrectly accepted"
elif grep -q "applies only to a function definition" "$nk_err" 2>/dev/null; then
    pass "regtest: __naked__ on non-definition rejected with expected message"
else
    fail "regtest: __naked__ on non-definition rejected but wrong message — inspect $nk_err"
fi
rm -f "$nk_err"

# ── Landmine coverage not duplicated here ──────────────────
# Landmines in saturn/workstreams/landmines.md for which a dedicated
# stage-4 reproducer would be redundant or impractical:
#
#   - `sh_rewrite_bool_fp` + r14 interaction (fixed in 752a344).
#     Currently guarded by FUN_06047748's tier-1 byte-match baseline —
#     reverting the guard corrupts that function's output, which fails
#     stage 5. Dedicated reproducer would need an exact crafted input.
#
#   - `sh_restructure_eq_chain` hardcoded r14 pop (fixed in 752a344).
#     Same — guarded implicitly by FUN_06047748's baseline.
#
#   - LCC's vmask/tmask disjoint constraint. Design-level; not
#     runtime-testable without deliberately miscoding the backend.
#
#   - lburg grammar-section comments re-parse only on sh.c regen.
#     Build-system quirk; tested by the existence of the comments in
#     src/sh.md parsing through in the very first build.
#
#   - stale build/rcc. Build-system quirk; same reasoning.

# ── 5. Tier-1 byte-match check ────────────────────────────
# Delegates to validate_byte_match.sh; one PASS/FAIL line so the
# established 22/22 number stays meaningful (becomes 23/23).
echo "[5/7] Byte-match regression check (standalone corpus)..."
bm_log="$(mktemp)"
if bash "$SCRIPT_DIR/validate_byte_match.sh" > "$bm_log" 2>&1; then
    bm_summary=$(grep -E '^=== [0-9]+ ok' "$bm_log" | head -n1)
    pass "byte-match: ${bm_summary:-no regressions}"
else
    fail "byte-match: regression detected — re-run validate_byte_match.sh for details"
    echo "       --- last 8 lines of byte-match output ---"
    tail -n 8 "$bm_log" | sed 's/^/       /'
fi
rm -f "$bm_log"

# ── 6. Tier-1 byte-match check, TU corpus ─────────────────
# Same mechanic as step 5 but measures the 196-function TU
# race_FUN_06044060 per-function. Each TU becomes one PASS/FAIL line.
# Add new TUs here as they reach the measured phase.
echo "[6/7] Byte-match regression check (TU corpus)..."
TU_CORPUS=(
    "race_FUN_06044060"
)
for tu in "${TU_CORPUS[@]}"; do
    bm_log="$(mktemp)"
    if bash "$SCRIPT_DIR/validate_byte_match_tu.sh" "$tu" > "$bm_log" 2>&1; then
        bm_summary=$(grep -E '^=== [0-9]+ ok' "$bm_log" | head -n1)
        pass "byte-match TU $tu: ${bm_summary:-no regressions}"
    else
        fail "byte-match TU $tu: regression detected — re-run validate_byte_match_tu.sh $tu"
        echo "       --- last 10 lines of TU byte-match output ---"
        tail -n 10 "$bm_log" | sed 's/^/       /'
    fi
    rm -f "$bm_log"
done

# ── 6. Broad-corpus smoke (M1) ────────────────────────────
# 956 Ghidra race C files compiled through the shim header. Two
# baselines pinned at saturn/experiments/broad_corpus_baselines/:
# the passing set and the crashing set. Regression if a previously-
# passing function starts failing, or if a file not in the crash
# baseline now crashes rcc. ~15s runtime.
echo "[7/7] Broad-corpus smoke..."
bc_log="$(mktemp)"
if bash "$SCRIPT_DIR/broad_corpus_smoke.sh" > "$bc_log" 2>&1; then
    bc_summary=$(grep -E '^  race:' "$bc_log" | head -n1 | sed 's/^  //')
    pass "broad-corpus: ${bc_summary:-no regressions}"
else
    fail "broad-corpus: regression detected — re-run broad_corpus_smoke.sh for details"
    echo "       --- last 10 lines of broad-corpus output ---"
    tail -n 10 "$bc_log" | sed 's/^/       /'
fi
rm -f "$bc_log"

# ── Summary ───────────────────────────────────────────────
echo ""
echo "=== $PASS/$TOTAL passed ==="
if [ $FAIL -gt 0 ]; then
    echo "*** $FAIL FAILURE(S) ***"
    exit 1
else
    echo "All clear."
    exit 0
fi
