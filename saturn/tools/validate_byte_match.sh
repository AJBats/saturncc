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
#   wsl bash saturn/tools/validate_byte_match.sh          # check
#   wsl bash saturn/tools/validate_byte_match.sh pin      # overwrite
#   wsl bash saturn/tools/validate_byte_match.sh verbose  # check + diff preview
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
    check|pin|verbose) ;;
    *) echo "Usage: $0 [check|pin|verbose]" >&2; exit 2 ;;
esac

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

printf "%-16s  %-7s  %s\n" "function" "status" "diff (baseline)"
printf "%-16s  %-7s  %s\n" "--------" "------" "---------------"

for our_c_rel in "${CORPUS[@]}"; do
    our_c="$REPO/$our_c_rel"
    name="$(basename "$our_c" .c)"
    TOTAL=$((TOTAL+1))

    baseline_file="$BASELINE_DIR/${name}.diff_count"
    baseline=""
    [ -f "$baseline_file" ] && baseline="$(cat "$baseline_file")"

    if [ ! -f "$our_c" ]; then
        printf "%-16s  %-7s  %s\n" "$name" "MISS" "(no .c)"
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    prod_s="$(find_prod_s "$name")"
    if [ -z "$prod_s" ]; then
        printf "%-16s  %-7s  %s\n" "$name" "SKIP" "(no prod .s)"
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
            printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "RCC!" "(was at diff=$baseline)"
            FAIL_REPORT+="${name}: rcc failed (was at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            printf "%-16s  %-7s  %s\n" "$name" "RCC!" "(see $TMPDIR/rcc.err)"
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi

    # Normalize both sides.
    our_norm="$TMPDIR/${name}.our.norm"
    prod_norm="$TMPDIR/${name}.prod.norm"
    if ! python3 "$NORMALIZE" --function "$name" "$our_s" > "$our_norm" 2>"$TMPDIR/norm.err"; then
        if [ -n "$baseline" ]; then
            printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "NORM!" "(was at diff=$baseline)"
            FAIL_REPORT+="${name}: normalize failed on our .s (was at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            printf "%-16s  %-7s  %s\n" "$name" "NORM!" "(normalize failed on ours; see $TMPDIR/norm.err)"
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi
    if ! python3 "$NORMALIZE" --function "$name" "$prod_s" > "$prod_norm" 2>"$TMPDIR/norm.err"; then
        # Prod-side normalizer failure is our bug, not a compiler regression.
        printf "%-16s  %-7s  %s\n" "$name" "NORM!" "(normalize failed on prod; see $TMPDIR/norm.err)"
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
        printf "%-16s  %-7s  %d  (no baseline)\n" "$name" "NEW" "$diff_count"
        NEW=$((NEW+1))
    elif [ "$diff_count" -lt "$baseline" ]; then
        printf "%-16s  %-7s  %d  (was %d)\n" "$name" "IMPR" "$diff_count" "$baseline"
        IMPROVED=$((IMPROVED+1))
    elif [ "$diff_count" -gt "$baseline" ]; then
        printf "%-16s  %-7s  %d  (was %d)  *** REGRESSION ***\n" \
            "$name" "REGR" "$diff_count" "$baseline"
        REGRESSED=$((REGRESSED+1))
        FAIL_REPORT+="${name}: regressed from ${baseline} to ${diff_count}\n"
    else
        printf "%-16s  %-7s  %d\n" "$name" "OK" "$diff_count"
        OK=$((OK+1))
    fi

    if [ "$MODE" = "verbose" ] && [ "$diff_count" -gt 0 ]; then
        echo "  --- ${name}: first 30 lines of diff (prod vs ours) ---"
        diff -u "$prod_norm" "$our_norm" | head -30 | sed 's/^/    /'
        echo ""
    fi
done

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
