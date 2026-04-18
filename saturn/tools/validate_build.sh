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
# decompiled functions. Kept separate because their #if 0 guards
# mean they compile only a subset, and a broken guard would be
# invisible to the per-function loop above.
for tu in "$EXPDIR"/race_FUN_*/FUN_*.c; do
    [ -f "$tu" ] || continue
    tu_dir="$(dirname "$tu")"
    tu_name="$(basename "$tu_dir")"
    # Write .s to /tmp rather than alongside the .c — TU .s is an
    # ever-changing output, not a stable reference artifact.
    if cpp -P "$tu" /tmp/validate_tu_pp.c 2>/dev/null \
       && "$RCC" -target=sh/hitachi /tmp/validate_tu_pp.c /tmp/validate_tu.s 2>/dev/null; then
        pass "compile TU $tu_name"
    else
        fail "compile TU $tu_name"
    fi
done
rm -f /tmp/validate_tu_pp.c /tmp/validate_tu.s

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

# 4t. POSITIVE: four pragmas at top-of-file (deferred-flush path).
cat > /tmp/regtest.c <<'EOF'
#pragma regsave(a, b)
#pragma noregsave(c)
#pragma noregalloc(d)
#pragma global_register(ctx=R10, scratch=R14)
int a(int x) { return x; }
int b(int x) { return x; }
int c(int x) { return x; }
int d(int x) { return x; }
EOF
pragma_err="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"
if [ ! -s "$pragma_err" ]; then
    pass "regtest: top-of-file regsave/noregsave/noregalloc/global_register accepted"
else
    fail "regtest: top-of-file pragmas rejected — $(head -1 "$pragma_err")"
fi
rm -f "$pragma_err"

# 4u. NEGATIVE: regsave missing '('.
cat > /tmp/regtest.c <<'EOF'
#pragma regsave
int a(int x) { return x; }
EOF
pragma_err="$(mktemp)"
"$RCC" -target=sh/hitachi /tmp/regtest.c /dev/null 2>"$pragma_err"
if grep -q "#pragma regsave expects '('" "$pragma_err"; then
    pass "regtest: #pragma regsave missing '(' rejected with expected message"
else
    fail "regtest: #pragma regsave missing '(' not rejected as expected"
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
