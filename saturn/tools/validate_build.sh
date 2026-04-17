#!/bin/bash
# validate_build.sh — mechanical pre-commit validation
#
# Checks:
# 1. Compiler builds and passes its smoke test
# 2. All experiment C files compile without crashing
# 3. Existing .s outputs are bit-identical to their last-committed versions
# 4. Regression tests for known-fixed bugs
# 5. Tier-1 byte-match: per-function diff count vs pinned baselines
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
echo "[1/5] Building compiler..."
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
echo "[2/5] Compiling experiment sources..."
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

# ── 3. Stable outputs (diff against last commit) ─────────
# Add new stable files here as functions reach their match ceiling.
echo "[3/5] Checking .s stability vs HEAD..."
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
echo "[4/5] Regression tests..."

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
echo "[5/5] Byte-match regression check..."
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
