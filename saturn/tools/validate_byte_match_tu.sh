#!/bin/bash
# validate_byte_match_tu.sh — TIER 1 byte-match, per-function, across a TU
#
# Compile a TU .c file once, then for every function entry in the
# matching production .s TU, slice both sides via asm_normalize.py and
# count diverging lines. Result is per-function so a single backend
# change's fan-out (improves some functions, regresses others) is
# visible per-name instead of collapsed into one aggregate.
#
# Baselines live at:
#   saturn/experiments/byte_match_baselines/<tu_dir>/<FUN>.diff_count
#
# Usage (must run under WSL — rcc is a Linux ELF):
#   wsl bash saturn/tools/validate_byte_match_tu.sh <tu_dir>             # check
#   wsl bash saturn/tools/validate_byte_match_tu.sh <tu_dir> pin         # overwrite baselines
#   wsl bash saturn/tools/validate_byte_match_tu.sh <tu_dir> verbose     # check + first 30 diff lines per non-zero
#   wsl bash saturn/tools/validate_byte_match_tu.sh <tu_dir> dashboard   # markdown table to stdout
#
#   <tu_dir> is a directory under saturn/experiments/daytona_byte_match/
#   containing exactly one FUN_*.c at the top level (the TU source).
#
# Env overrides:
#   DAYTONA_SRC  path to DaytonaCCEReverse/src/ (raw prod .s files)

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
RCC="$REPO/build/rcc"
NORMALIZE="$SCRIPT_DIR/asm_normalize.py"
PROD_SRC="${DAYTONA_SRC:-/mnt/d/Projects/DaytonaCCEReverse/src}"

TU_DIR="${1:-}"
MODE="${2:-check}"

if [ -z "$TU_DIR" ]; then
    echo "Usage: $0 <tu_dir> [check|pin|verbose|dashboard]" >&2
    exit 2
fi
case "$MODE" in
    check|pin|verbose|dashboard) ;;
    *) echo "Usage: $0 <tu_dir> [check|pin|verbose|dashboard]" >&2; exit 2 ;;
esac

TU_PATH="$REPO/saturn/experiments/daytona_byte_match/$TU_DIR"
if [ ! -d "$TU_PATH" ]; then
    echo "ERROR: TU dir not found: $TU_PATH" >&2
    exit 2
fi

TU_C=$(find "$TU_PATH" -maxdepth 1 -name "FUN_*.c" | head -n1)
if [ -z "$TU_C" ] || [ ! -f "$TU_C" ]; then
    echo "ERROR: no FUN_*.c found in $TU_PATH" >&2
    exit 2
fi
TU_NAME=$(basename "$TU_C" .c)

PROD_S=$(find "$PROD_SRC" -maxdepth 3 -name "${TU_NAME}.s" -print -quit 2>/dev/null)
if [ -z "$PROD_S" ]; then
    echo "ERROR: prod TU .s not found for $TU_NAME under $PROD_SRC" >&2
    exit 2
fi

if [ ! -x "$RCC" ]; then
    echo "ERROR: $RCC not built. Run saturn/tools/build.sh first." >&2
    exit 2
fi

BASELINE_DIR="$REPO/saturn/experiments/byte_match_baselines/$TU_DIR"
mkdir -p "$BASELINE_DIR"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# Compile our TU once.
pp_c="$TMPDIR/tu.pp.c"
our_s="$TMPDIR/tu.s"
if ! cpp -P "$TU_C" > "$pp_c" 2>"$TMPDIR/cpp.err"; then
    echo "ERROR: cpp failed on $TU_C" >&2
    cat "$TMPDIR/cpp.err" >&2
    exit 2
fi
if ! "$RCC" -target=sh/hitachi "$pp_c" "$our_s" 2>"$TMPDIR/rcc.err"; then
    echo "ERROR: rcc failed on TU compile" >&2
    cat "$TMPDIR/rcc.err" >&2
    exit 2
fi

# Enumerate function entries on both sides.
# Prod uses bare FUN_xxx: labels with uppercase hex; our emitter uses
# _FUN_xxx: with lowercase hex. Normalize both to uppercase for
# comparison; canonical display name follows prod (uppercase).
canon_funcs() {
    # stdin: lines from .s; stdout: unique FUN_XXXX (uppercase hex).
    grep -E '^_?(FUN|sub)_[0-9A-Fa-f]+:' \
        | sed -E 's/^_?((FUN|sub)_[0-9A-Fa-f]+):.*$/\1/' \
        | awk '{
            prefix = substr($0, 1, 4);   # FUN_ or sub_
            hex = substr($0, 5);
            print prefix toupper(hex);
          }' \
        | awk '!seen[$0]++'
}
mapfile -t PROD_FUNCS < <(canon_funcs < "$PROD_S")
mapfile -t OUR_FUNCS  < <(canon_funcs < "$our_s")

# Build an associative set of OUR_FUNCS for fast membership tests.
declare -A OUR_HAS
for f in "${OUR_FUNCS[@]}"; do OUR_HAS[$f]=1; done

TOTAL=0
OK=0
IMPROVED=0
REGRESSED=0
SKIPPED=0
NEW=0
FAIL_REPORT=""
DASHBOARD_ROWS=""

dash_row() {
    DASHBOARD_ROWS+="| $1 | $2 | $3 | $4 |"$'\n'
}

if [ "$MODE" != "dashboard" ]; then
    printf "%-18s  %-7s  %s\n" "function" "status" "diff (baseline)"
    printf "%-18s  %-7s  %s\n" "------------------" "-------" "---------------"
fi

for name in "${PROD_FUNCS[@]}"; do
    TOTAL=$((TOTAL+1))
    baseline_file="$BASELINE_DIR/${name}.diff_count"
    baseline=""
    [ -f "$baseline_file" ] && baseline="$(cat "$baseline_file")"
    bl_cell="${baseline:--}"

    if [ -z "${OUR_HAS[$name]:-}" ]; then
        # Function not emitted by our compile — typically a #if 0 skip (Gap 18 etc.)
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "—" "$bl_cell" "skip (not emitted)"
        elif [ "$MODE" = "pin" ]; then
            printf "%-18s  %-7s  %s\n" "$name" "SKIP" "(not emitted — leaving baseline)"
        else
            printf "%-18s  %-7s  %s\n" "$name" "SKIP" "(not emitted)"
        fi
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    our_norm="$TMPDIR/${name}.our.norm"
    prod_norm="$TMPDIR/${name}.prod.norm"
    if ! python3 "$NORMALIZE" --function "$name" "$our_s" > "$our_norm" 2>"$TMPDIR/norm.err"; then
        if [ -n "$baseline" ]; then
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "NORM!" "$bl_cell" "REGR (normalize)"
            else
                printf "%-18s  %-7s  %s  *** REGRESSION ***\n" "$name" "NORM!" "(was diff=$baseline)"
            fi
            FAIL_REPORT+="${name}: normalize failed on ours (was diff=$baseline)"$'\n'
            REGRESSED=$((REGRESSED+1))
        else
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "NORM!" "$bl_cell" "skip (no baseline)"
            else
                printf "%-18s  %-7s  %s\n" "$name" "NORM!" "(see $TMPDIR/norm.err)"
            fi
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi
    if ! python3 "$NORMALIZE" --function "$name" "$PROD_S" > "$prod_norm" 2>"$TMPDIR/norm.err"; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "NORM!" "$bl_cell" "skip (prod normalize)"
        else
            printf "%-18s  %-7s  %s\n" "$name" "NORM!" "(prod normalize failed)"
        fi
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    diff_count=$(diff "$prod_norm" "$our_norm" 2>/dev/null | grep -c '^[<>]')

    if [ "$MODE" = "pin" ]; then
        echo "$diff_count" > "$baseline_file"
        printf "%-18s  %-7s  %d  (pinned)\n" "$name" "PIN" "$diff_count"
        continue
    fi

    if [ -z "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "—" "new"
        else
            printf "%-18s  %-7s  %d  (no baseline)\n" "$name" "NEW" "$diff_count"
        fi
        NEW=$((NEW+1))
    elif [ "$diff_count" -lt "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "improved"
        else
            printf "%-18s  %-7s  %d  (was %d)\n" "$name" "IMPR" "$diff_count" "$baseline"
        fi
        IMPROVED=$((IMPROVED+1))
    elif [ "$diff_count" -gt "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "REGRESSED"
        else
            printf "%-18s  %-7s  %d  (was %d)  *** REGRESSION ***\n" \
                "$name" "REGR" "$diff_count" "$baseline"
        fi
        REGRESSED=$((REGRESSED+1))
        FAIL_REPORT+="${name}: regressed from $baseline to $diff_count"$'\n'
    else
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "ok"
        else
            printf "%-18s  %-7s  %d\n" "$name" "OK" "$diff_count"
        fi
        OK=$((OK+1))
    fi

    if [ "$MODE" = "verbose" ] && [ "$diff_count" -gt 0 ]; then
        echo "  --- ${name}: first 30 lines of diff (prod vs ours) ---"
        diff -u "$prod_norm" "$our_norm" | head -30 | sed 's/^/    /'
        echo ""
    fi
done

if [ "$MODE" = "dashboard" ]; then
    sorted=$(printf "%b" "$DASHBOARD_ROWS" | awk -F'|' '{
        diff = $3
        gsub(/^ +| +$/, "", diff)
        if (diff ~ /^[0-9]+$/) printf "%010d %s\n", diff, $0
        else                   printf "9999999999 %s\n", $0
    }' | sort | sed 's/^[0-9]* //')

    cat <<EOF
# Byte-match dashboard — ${TU_DIR}

Auto-generated by \`saturn/tools/validate_byte_match_tu.sh ${TU_DIR} dashboard\`.
**Do not hand-edit** — re-run the script to refresh.

Tier-1 per-function diff count, measured against
\`${PROD_S#${PROD_SRC}/}\` in prod. Both sides normalized via
\`asm_normalize.py\`. Baselines at
\`saturn/experiments/byte_match_baselines/${TU_DIR}/<FUN>.diff_count\`.

| Function | Diff | Baseline | Status |
|---|---:|---:|---|
$sorted

## Summary

- $OK ok, $IMPROVED improved, $REGRESSED regressed, $NEW new, $SKIPPED skipped (of $TOTAL)
EOF
    exit 0
fi

echo ""
if [ "$MODE" = "pin" ]; then
    echo "=== Baselines pinned in $BASELINE_DIR/ ==="
    exit 0
fi

echo "=== $OK ok, $IMPROVED improved, $REGRESSED regressed, $NEW new, $SKIPPED skipped (of $TOTAL) ==="

if [ "$REGRESSED" -gt 0 ]; then
    echo ""
    echo "*** REGRESSION FAILURES ***"
    printf "%b" "$FAIL_REPORT"
    exit 1
fi

if [ "$NEW" -gt 0 ]; then
    echo ""
    echo "(NEW functions have no baseline. Run with 'pin' to record.)"
fi

exit 0
