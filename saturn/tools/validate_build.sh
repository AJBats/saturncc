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

# 4ac. CODEGEN: __asm("...") intrinsic emits the literal string
# verbatim with no string-literal storage (.rodata), no pool entries
# for a string-ptr or __asm extern, no jsr/arg-setup, and no
# callee-saved promotion forced by a phantom call. The backend
# prepends a single tab; asm_intrinsic() strips user-provided leading
# whitespace so no double-tabs regardless of source style.
# See src/expr.c asm_intrinsic() and src/dag.c listnodes() ASMB case.
cat > /tmp/regtest.c <<'EOF'
int hello(int x) {
    __asm("nop");
    return x + 1;
}
EOF
asm_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>/dev/null
ok=1
grep -q $'^\tnop$' "$asm_out" || ok=0           # single tab + asm text
grep -q "\.rodata" "$asm_out" && ok=0           # no .rodata pollution
grep -q "___asm" "$asm_out" && ok=0             # no extern __asm symbol
grep -q "jsr" "$asm_out" && ok=0                # no jsr at all (pure leaf)
grep -q "@-r15" "$asm_out" && ok=0              # no callee-saved push
if [ "$ok" = "1" ]; then
    pass "regtest: __asm(\"...\") emits raw text with no pool/rodata/call"
else
    fail "regtest: __asm intrinsic polluted the output — inspect $asm_out"
fi
rm -f "$asm_out"

# 4ad. asm { ... } statement-level construct (Session 1 of asm-shim
# work). Same downstream codepath as __asm("...") — both build an
# ASMB tree wrapping the raw text — but the construct captures the
# block content verbatim instead of going through string-literal
# escape processing. See saturn/workstreams/asm_shim_design.md and
# src/lex.c lex_asm_body().
cat > /tmp/regtest.c <<'EOF'
int hello(int x) {
    asm { mov r1, r2 }
    return x + 1;
}
EOF
asm_out="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c "$asm_out" 2>/dev/null
ok=1
grep -q '^	 mov r1, r2 $' "$asm_out" || ok=0   # body verbatim incl. surrounding spaces
grep -q "\.rodata" "$asm_out" && ok=0
grep -q "jsr" "$asm_out" && ok=0
grep -q "@-r15" "$asm_out" && ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm { ... } statement emits captured text verbatim"
else
    fail "regtest: asm { ... } statement output wrong — inspect $asm_out"
fi
rm -f "$asm_out"

# 4ae. asm { ... } round-trip preservation: a multi-line block with
# labels, comments, and pool entries inside a regular C function.
# Each non-empty line of the body must appear in the output unmodified
# (whitespace, indentation, comment chars all preserved). This is the
# correctness invariant for prod-derived asm shims (Session 3 of the
# asm-shim plan).
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
grep -qE '^[[:space:]]+mov\.l[[:space:]]+LP0,r3' "$asm_out" || ok=0
grep -qE '^[[:space:]]+jsr[[:space:]]+@r3' "$asm_out" || ok=0
grep -qE '^[[:space:]]+! a comment' "$asm_out" || ok=0
grep -qE '^LP0:[[:space:]]+\.long[[:space:]]+_target' "$asm_out" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm { ... } round-trips multi-line content (labels, comments, pool)"
else
    fail "regtest: asm { ... } round-trip lost content — inspect $asm_out"
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
    grep -q '^_FUN_test:' "$asm_out" || ok=0      # function label emitted
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

# 4ah. Parser round-trip (Stage 1 of asm-shim work).
# sh_parse_asm_text captures each line's src_text exactly. The
# -d-asm dump prints `[asm-dump]     src: <src_text>` for each
# parsed insn. Round-trip means the extracted src_text concatenated
# matches the original block content.
cat > /tmp/regtest.c <<'EOF'
int test(int x) {
    asm { mov r1, r2 }
    return x;
}
EOF
asm_dump="$(mktemp)"
"$RCC" -target=sh/hitachi -d-asm /tmp/regtest.c /dev/null 2>"$asm_dump"
if grep -q '^\[asm-dump\]     src:  mov r1, r2 $' "$asm_dump"; then
    pass "regtest: asm parser round-trips line content via src_text"
else
    fail "regtest: asm parser round-trip failed — inspect $asm_dump"
fi
rm -f "$asm_dump"

# 4ai. Parser destination detection — every write category in
# sh_p_apply_kind must produce the right writes mask.
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
grep -qE 'mn=mov reads=0x10 writes=0x20' "$asm_dump" || ok=0
grep -qE 'mn=add reads=0x1 writes=0x1' "$asm_dump" || ok=0
grep -qE 'mn=mov\.l reads=0x10 writes=0x18' "$asm_dump" || ok=0
grep -qE 'mn=sts\.l reads=0x8000 writes=0x8000 sr_r=0x1' "$asm_dump" || ok=0
grep -qE '\[BC\] mn=jsr reads=0x40 writes=0x0 sr_r=0x0 sr_w=0x1' "$asm_dump" || ok=0
grep -qE 'mn=dt reads=0x20 writes=0x20 sr_r=0x0 sr_w=0x40' "$asm_dump" || ok=0
if [ "$ok" = "1" ]; then
    pass "regtest: asm parser destination detection per write-category"
else
    fail "regtest: asm parser destination detection wrong — inspect $asm_dump"
fi
rm -f "$asm_dump"

# 4aj. Conservative-on-unknown: a deliberately bad mnemonic must
# get is_unknown=1 and reads/writes default to 0xffff so any
# downstream analysis sees it as "could clobber anything." False-
# clean answers would silently break byte-match.
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
if grep -qE '\[U\] mn=zzzfake reads=0xffff writes=0xffff' "$asm_dump"; then
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
    # Extract the caller's body: from _caller: until the next label.
    # Note: helpers _helper_a / _helper_b emit before _caller in source-
    # order drain, so the awk must arm `flag` only at _caller and stop
    # at the next top-level `_<name>:` label. The earlier shorthand
    # `flag; /^_[a-zA-Z]/{if(seen)exit; seen=1}` exited at _helper_b
    # before flag was ever set, returning empty body.
    caller_body="$(awk '
        /^_caller:/ {flag=1; print; next}
        flag && /^_[a-zA-Z][a-zA-Z0-9_]*:/ {exit}
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
