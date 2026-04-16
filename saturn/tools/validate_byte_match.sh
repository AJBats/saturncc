#!/bin/bash
# validate_byte_match.sh — TIER 1 (primary)
#
# Per-function .s-text divergence vs. production. Measures how close our
# compiler's output is to prod's on a canonical-normalized, label-matched
# line-by-line diff.
#
# This is the primary byte-match regression gate. A companion tier-2
# script (validate_byte_match_bin.sh) goes all the way to sh-elf-as +
# objdump and is useful as a diagnostic upper bar, but its noise from
# GNU-as encoding choices makes it unsuitable as the commit gate.
#
# Flow for each corpus function:
#   1. compile .c with rcc → .s (in tmpdir; does not touch the tree)
#   2. normalize both ours and prod via saturn/tools/asm_normalize.py
#        (strip directives, renumber labels, hex → dec, sym_ → decimal,
#         .4byte → .long, normalize whitespace)
#   3. diff, count diverging lines
#   4. compare to pinned baseline in byte_match_baselines/
#
# Regression conditions (exit 1):
#   - diff count grew since baseline,
#   - rcc crashed on a function that previously compiled,
#   - normalization failed on a function that previously normalized.
#
# Usage (must run under WSL — rcc is a Linux ELF):
#   wsl bash saturn/tools/validate_byte_match.sh             # check
#   wsl bash saturn/tools/validate_byte_match.sh pin         # overwrite
#   wsl bash saturn/tools/validate_byte_match.sh verbose     # check + diff preview
#   wsl bash saturn/tools/validate_byte_match.sh dashboard   # markdown table to stdout
#                                                            # (redirect to refresh
#                                                            # byte_match_dashboard.md)
#
# Env overrides:
#   DAYTONA_SRC  path to DaytonaCCEReverse/src/ (raw prod .s files)

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
RCC="$REPO/build/rcc"
NORMALIZE="$SCRIPT_DIR/asm_normalize.py"
PROD_SRC="${DAYTONA_SRC:-/mnt/d/Projects/DaytonaCCEReverse/src}"
BASELINE_DIR="$REPO/saturn/experiments/byte_match_baselines"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

MODE="${1:-check}"
case "$MODE" in
    check|pin|verbose|dashboard) ;;
    *) echo "Usage: $0 [check|pin|verbose|dashboard]" >&2; exit 2 ;;
esac

# `dashboard` mode emits a markdown table to stdout. Re-direct to a
# tracked file (saturn/workstreams/byte_match_dashboard.md) to refresh
# the published metric. Always exits 0 since it's a reporting mode.
DASHBOARD_ROWS=""

# Corpus: .c files that have a matching prod .s somewhere under $PROD_SRC
# (either standalone FUN_xxx.s or inlined in a TU file).
CORPUS=(
    "saturn/experiments/daytona_byte_match/FUN_06000AF8.c"
    "saturn/experiments/daytona_byte_match/FUN_00280710.c"
    "saturn/experiments/daytona_byte_match/FUN_06004378.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_0602A664.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_06037E28.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_0604025C.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_06040EA0.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_06044834.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_06044BCC.c"
    "saturn/experiments/daytona_byte_match/race_tu1/FUN_06047748.c"
)

# ── sanity ────────────────────────────────────────────────────
if [ ! -x "$RCC" ]; then
    echo "ERROR: $RCC not built. Run saturn/tools/build.sh first." >&2
    exit 2
fi
if [ ! -f "$NORMALIZE" ]; then
    echo "ERROR: $NORMALIZE not found." >&2
    exit 2
fi
if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 required." >&2
    exit 2
fi
if [ ! -d "$PROD_SRC" ]; then
    echo "ERROR: $PROD_SRC not found. Set DAYTONA_SRC." >&2
    exit 2
fi

mkdir -p "$BASELINE_DIR"

# Find the raw prod .s for a function. Prefers a standalone file of the
# same name; falls back to a grep for `^<name>:` inside any TU .s under
# $PROD_SRC.
find_prod_s() {
    local name="$1"
    local p
    p=$(find "$PROD_SRC" -maxdepth 3 -name "${name}.s" -print -quit 2>/dev/null)
    if [ -n "$p" ]; then
        echo "$p"
        return
    fi
    # Inlined — search for the entry label.
    grep -l "^${name}:" "$PROD_SRC"/*/*.s 2>/dev/null | head -n1
}

TOTAL=0
OK=0
IMPROVED=0
REGRESSED=0
SKIPPED=0
NEW=0
FAIL_REPORT=""

if [ "$MODE" != "dashboard" ]; then
    printf "%-16s  %-7s  %s\n" "function" "status" "diff (baseline)"
    printf "%-16s  %-7s  %s\n" "--------" "------" "---------------"
fi

# Helper: in dashboard mode, append a row instead of printing the table line.
# Args: function_name, current_diff_or_dash, baseline_or_dash, status_label
dash_row() {
    DASHBOARD_ROWS+="| $1 | $2 | $3 | $4 |"$'\n'
}

for our_c_rel in "${CORPUS[@]}"; do
    our_c="$REPO/$our_c_rel"
    name="$(basename "$our_c" .c)"
    TOTAL=$((TOTAL+1))

    baseline_file="$BASELINE_DIR/${name}.diff_count"
    baseline=""
    [ -f "$baseline_file" ] && baseline="$(cat "$baseline_file")"

    bl_cell="${baseline:--}"

    if [ ! -f "$our_c" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "—" "$bl_cell" "MISS"
        else
            printf "%-16s  %-7s  %s\n" "$name" "MISS" "(no .c)"
        fi
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    prod_s="$(find_prod_s "$name")"
    if [ -z "$prod_s" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "—" "$bl_cell" "SKIP (no prod .s)"
        else
            printf "%-16s  %-7s  %s\n" "$name" "SKIP" "(no prod .s)"
        fi
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    # Compile .c → .s in tmpdir.
    pp_c="$TMPDIR/${name}.pp.c"
    our_s="$TMPDIR/${name}.s"
    if ! cpp -P "$our_c" > "$pp_c" 2>/dev/null; then
        cp "$our_c" "$pp_c"
    fi
    if ! "$RCC" -target=sh/hitachi "$pp_c" "$our_s" 2>"$TMPDIR/rcc.err"; then
        if [ -n "$baseline" ]; then
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "RCC!" "$bl_cell" "REGR (rcc broke)"
            else
                printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "RCC!" "(was at diff=$baseline)"
            fi
            FAIL_REPORT+="${name}: rcc failed (was at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "RCC!" "$bl_cell" "skip (no baseline)"
            else
                printf "%-16s  %-7s  %s\n" "$name" "RCC!" "(see $TMPDIR/rcc.err)"
            fi
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi

    # Normalize both sides.
    our_norm="$TMPDIR/${name}.our.norm"
    prod_norm="$TMPDIR/${name}.prod.norm"
    if ! python3 "$NORMALIZE" --function "$name" "$our_s" > "$our_norm" 2>"$TMPDIR/norm.err"; then
        if [ -n "$baseline" ]; then
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "NORM!" "$bl_cell" "REGR (normalize broke)"
            else
                printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "NORM!" "(was at diff=$baseline)"
            fi
            FAIL_REPORT+="${name}: normalize failed on our .s (was at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            if [ "$MODE" = "dashboard" ]; then
                dash_row "$name" "NORM!" "$bl_cell" "skip (no baseline)"
            else
                printf "%-16s  %-7s  %s\n" "$name" "NORM!" "(normalize failed on ours; see $TMPDIR/norm.err)"
            fi
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi
    if ! python3 "$NORMALIZE" --function "$name" "$prod_s" > "$prod_norm" 2>"$TMPDIR/norm.err"; then
        # Prod-side normalizer failure is our bug, not a compiler regression.
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "NORM!" "$bl_cell" "skip (prod normalize)"
        else
            printf "%-16s  %-7s  %s\n" "$name" "NORM!" "(normalize failed on prod; see $TMPDIR/norm.err)"
        fi
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    # Diff count: lines that appear in exactly one side.
    diff_count=$(diff "$prod_norm" "$our_norm" 2>/dev/null | grep -c '^[<>]')

    if [ "$MODE" = "pin" ]; then
        echo "$diff_count" > "$baseline_file"
        printf "%-16s  %-7s  %d  (pinned)\n" "$name" "PIN" "$diff_count"
        continue
    fi

    if [ -z "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "—" "new"
        else
            printf "%-16s  %-7s  %d  (no baseline)\n" "$name" "NEW" "$diff_count"
        fi
        NEW=$((NEW+1))
    elif [ "$diff_count" -lt "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "improved"
        else
            printf "%-16s  %-7s  %d  (was %d)\n" "$name" "IMPR" "$diff_count" "$baseline"
        fi
        IMPROVED=$((IMPROVED+1))
    elif [ "$diff_count" -gt "$baseline" ]; then
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "REGRESSED"
        else
            printf "%-16s  %-7s  %d  (was %d)  *** REGRESSION ***\n" \
                "$name" "REGR" "$diff_count" "$baseline"
        fi
        REGRESSED=$((REGRESSED+1))
        FAIL_REPORT+="${name}: regressed from ${baseline} to ${diff_count}\n"
    else
        if [ "$MODE" = "dashboard" ]; then
            dash_row "$name" "$diff_count" "$baseline" "ok"
        else
            printf "%-16s  %-7s  %d\n" "$name" "OK" "$diff_count"
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
    # Sort by diff count ascending so the dashboard reads "closest to prod
    # at the top." Non-numeric statuses (RCC!/NORM!/MISS) sort last.
    sorted=$(printf "%b" "$DASHBOARD_ROWS" | awk -F'|' '{
        diff = $3
        gsub(/^ +| +$/, "", diff)
        if (diff ~ /^[0-9]+$/) printf "%010d %s\n", diff, $0
        else                   printf "9999999999 %s\n", $0
    }' | sort | sed 's/^[0-9]* //')

    cat <<EOF
# Byte-match dashboard

Auto-generated by \`saturn/tools/validate_byte_match.sh dashboard\`.
**Do not hand-edit** — re-run the script to refresh.

This is the **tier-1** byte-match metric: per-function count of
diverging lines after canonical \`.s\`-text normalization (see
\`asm_normalize.py\`). Both our compiler's output and prod's are
normalized through the same pipeline; remaining diff is real
divergence (instruction, register, immediate, addressing mode, or
control-flow).

The numbers \`(was N)\` show the pinned baseline at
\`saturn/experiments/byte_match_baselines/<name>.diff_count\`.
Improvements and regressions are both detected against those
baselines on every \`check\` run.

| Function | Diff | Baseline | Status |
|---|---:|---:|---|
$sorted

## Summary

- $OK ok, $IMPROVED improved, $REGRESSED regressed, $NEW new, $SKIPPED skipped (of $TOTAL)
- Tier 2 (sh-elf-as + objdump) baselines: see \`saturn/experiments/byte_match_baselines_bin/\`. Tier 2 is diagnostic, not commit-gating.
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
