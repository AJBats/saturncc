#!/bin/bash
# broad_corpus_smoke.sh — regression-detect compiler failures / crashes
# across a wide corpus of Ghidra-decompiled C files from the sister
# project DaytonaCCEReverse.
#
# Addresses methodology_remediation M1 ("corpus is too narrow for
# peephole confidence"): gives us ~150+ additional compile targets
# per module to catch peephole passes that quietly break untested
# patterns.
#
# Per-file classification:
#   pass     — cpp + rcc complete cleanly (exit 0)
#   fail     — normal rejection (cpp error, or rcc non-zero exit
#              for parse / type / unresolved-identifier reasons).
#              Most Ghidra placeholder-type issues land here; not a
#              compiler bug.
#   crash    — rcc segfault / abort (exit ≥ 128). Real compiler bug.
#
# Baselines live at saturn/experiments/broad_corpus_baselines/:
#   <module>.passing.txt   (one FUN_XXX per line, sorted)
#   <module>.crashing.txt  (same, for crashes)
#
# Regression conditions (exit 1):
#   - A function in <module>.passing.txt no longer passes.
#   - A function that wasn't in <module>.crashing.txt now crashes.
#
# Improvements (exit 0, noted): newly-passing or no-longer-crashing.
#
# Usage (must run under WSL — rcc is a Linux ELF):
#   wsl bash saturn/tools/broad_corpus_smoke.sh            # check
#   wsl bash saturn/tools/broad_corpus_smoke.sh pin        # overwrite baselines
#
# Env overrides:
#   GHIDRA_REF     path to DaytonaCCEReverse/ghidra_reference/

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
RCC="$REPO/build/rcc"
SHIM="$REPO/saturn/experiments/daytona_byte_match/race_tu1/ghidra_shim.h"
GHIDRA_REF="${GHIDRA_REF:-/mnt/d/Projects/DaytonaCCEReverse/ghidra_reference}"
BASELINE_DIR="$REPO/saturn/experiments/broad_corpus_baselines"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

MODE="${1:-check}"
case "$MODE" in
    check|pin) ;;
    *) echo "Usage: $0 [check|pin]" >&2; exit 2 ;;
esac

# For now: race module only. Other modules are candidates once the
# shim-and-naming coverage is understood — the race shim at
# $SHIM was tuned for race-module identifier prefixes.
MODULES=(race)

if [ ! -x "$RCC" ]; then
    echo "ERROR: $RCC not built. Run saturn/tools/build.sh first." >&2
    exit 2
fi
if [ ! -f "$SHIM" ]; then
    echo "ERROR: $SHIM not found." >&2
    exit 2
fi
if [ ! -d "$GHIDRA_REF" ]; then
    echo "ERROR: $GHIDRA_REF not found. Set GHIDRA_REF." >&2
    exit 2
fi

mkdir -p "$BASELINE_DIR"

TOTAL_REGR=0
TOTAL_IMPR=0

for module in "${MODULES[@]}"; do
    src_dir="$GHIDRA_REF/$module"
    if [ ! -d "$src_dir" ]; then
        echo "  skip $module (no source dir)"
        continue
    fi

    pass_f="$TMPDIR/${module}.passing.txt"
    crash_f="$TMPDIR/${module}.crashing.txt"
    : > "$pass_f"
    : > "$crash_f"

    pass=0; fail=0; crash=0; total=0
    # Redirect stderr of the whole per-file loop: rcc segfaults cause
    # bash to print "Aborted / Segmentation fault (core dumped)" from
    # the parent shell itself (not from rcc's stderr), which no
    # per-command redirection can suppress. Nothing legitimate inside
    # the loop writes to stderr, so this is safe.
    for gh in "$src_dir"/*.c; do
        [ -f "$gh" ] || continue
        total=$((total+1))
        name="$(basename "$gh" .c)"

        cat "$SHIM" > "$TMPDIR/combo.c"
        echo "" >> "$TMPDIR/combo.c"
        cat "$gh" >> "$TMPDIR/combo.c"

        if ! cpp -P "$TMPDIR/combo.c" > "$TMPDIR/combo.pp.c" 2>/dev/null; then
            fail=$((fail+1))
            continue
        fi

        "$RCC" -target=sh/hitachi "$TMPDIR/combo.pp.c" "$TMPDIR/out.s" >/dev/null 2>&1
        rc=$?
        if [ $rc -eq 0 ]; then
            pass=$((pass+1))
            echo "$name" >> "$pass_f"
        elif [ $rc -ge 128 ]; then
            crash=$((crash+1))
            echo "$name" >> "$crash_f"
        else
            fail=$((fail+1))
        fi
    done 2>/dev/null
    sort -o "$pass_f" "$pass_f"
    sort -o "$crash_f" "$crash_f"

    bl_pass="$BASELINE_DIR/${module}.passing.txt"
    bl_crash="$BASELINE_DIR/${module}.crashing.txt"

    if [ "$MODE" = "pin" ]; then
        cp "$pass_f"  "$bl_pass"
        cp "$crash_f" "$bl_crash"
        printf "  %s: %d pass, %d fail, %d crash (of %d)  PINNED\n" \
            "$module" "$pass" "$fail" "$crash" "$total"
        continue
    fi

    # Check mode.
    regressed_fails=""
    newly_passing=""
    new_crashes=""
    no_longer_crashing=""
    if [ -f "$bl_pass" ]; then
        regressed_fails="$(comm -23 "$bl_pass" "$pass_f")"
        newly_passing="$(comm -13 "$bl_pass" "$pass_f")"
    else
        regressed_fails=""
        newly_passing="$(cat "$pass_f")"
    fi
    if [ -f "$bl_crash" ]; then
        new_crashes="$(comm -13 "$bl_crash" "$crash_f")"
        no_longer_crashing="$(comm -23 "$bl_crash" "$crash_f")"
    else
        new_crashes="$(cat "$crash_f")"
        no_longer_crashing=""
    fi

    n_regr=$(echo -n "$regressed_fails" | grep -c .)
    n_impr_pass=$(echo -n "$newly_passing" | grep -c .)
    n_new_crash=$(echo -n "$new_crashes" | grep -c .)
    n_impr_crash=$(echo -n "$no_longer_crashing" | grep -c .)

    bl_pass_count=0
    [ -f "$bl_pass" ] && bl_pass_count=$(wc -l < "$bl_pass")
    bl_crash_count=0
    [ -f "$bl_crash" ] && bl_crash_count=$(wc -l < "$bl_crash")

    printf "  %s: %d pass (baseline %d), %d crash (baseline %d), %d fail, %d total\n" \
        "$module" "$pass" "$bl_pass_count" "$crash" "$bl_crash_count" "$fail" "$total"

    if [ "$n_regr" -gt 0 ] || [ "$n_new_crash" -gt 0 ]; then
        TOTAL_REGR=$((TOTAL_REGR + n_regr + n_new_crash))
        echo "    *** REGRESSION ***"
        if [ "$n_regr" -gt 0 ]; then
            echo "      $n_regr previously-passing function(s) now fail/crash:"
            echo "$regressed_fails" | head -5 | sed 's/^/        /'
            [ "$n_regr" -gt 5 ] && echo "        ... and $((n_regr - 5)) more"
        fi
        if [ "$n_new_crash" -gt 0 ]; then
            echo "      $n_new_crash new crash(es):"
            echo "$new_crashes" | head -5 | sed 's/^/        /'
            [ "$n_new_crash" -gt 5 ] && echo "        ... and $((n_new_crash - 5)) more"
        fi
    fi
    if [ "$n_impr_pass" -gt 0 ] || [ "$n_impr_crash" -gt 0 ]; then
        TOTAL_IMPR=$((TOTAL_IMPR + n_impr_pass + n_impr_crash))
        echo "    (improvement: $n_impr_pass newly passing, $n_impr_crash no longer crashing)"
    fi
done

echo ""
if [ "$MODE" = "pin" ]; then
    echo "=== Baselines pinned in $BASELINE_DIR/ ==="
    exit 0
fi

if [ "$TOTAL_REGR" -gt 0 ]; then
    echo "*** $TOTAL_REGR broad-corpus regression(s) ***"
    exit 1
fi
if [ "$TOTAL_IMPR" -gt 0 ]; then
    echo "($TOTAL_IMPR broad-corpus improvement(s) — consider re-pinning)"
fi
exit 0
