#!/bin/bash
# validate_byte_match_bin.sh — TIER 2 (secondary/diagnostic)
#
# Per-function machine-byte diff vs. production, via modern GNU as + objdump.
# This is *not* the primary byte-match metric — see validate_byte_match.sh
# (tier 1, .s text diff). This script exists to:
#   (a) catch compiler-output that sh-elf-as can't assemble at all
#       (already caught FUN_06037E28's misaligned pool + pcrel-too-far);
#   (b) provide an aspirational upper bar, becoming primary if/when we
#       trust that modern GNU as encodes SH-2 identically to 1996 SHC as.
#
# Known sources of tier-2 false positives (why it isn't primary yet):
#   - GNU as 2.34 silently relaxes out-of-range branches
#     ("overflow in branch to L; converted into longer sequence").
#   - Pool-literal bytes in prod .o are zero-filled relocation placeholders;
#     ours are resolved #define values.
#   - Alignment-pad handling may differ.
#   - Ambiguous-mnemonic instruction-form selection may differ.
#
# Flow:
#   1. compile .c with rcc → .s (in tmpdir)
#   2. assemble with sh-elf-as → .o
#   3. objdump -d --disassemble=SYMBOL on both our .o and prod's .o
#   4. normalize (strip addresses + linker-resolution comments)
#   5. diff, count diverging lines
#
# Baselines: saturn/experiments/byte_match_baselines_bin/*.diff_count
# Regression (diff increase, or was-assembling-now-fails) exits 1.
#
# Usage (must run under WSL):
#   wsl bash saturn/tools/validate_byte_match_bin.sh          # check
#   wsl bash saturn/tools/validate_byte_match_bin.sh pin      # overwrite
#   wsl bash saturn/tools/validate_byte_match_bin.sh verbose  # check + diff
#
# Env overrides:
#   SH_ELF_TOOLCHAIN  path to sh-elf-as / sh-elf-objdump
#   DAYTONA_BUILD     path to DaytonaCCEReverse/build/

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/../.." && pwd)"
TOOLCHAIN="${SH_ELF_TOOLCHAIN:-/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin}"
AS="$TOOLCHAIN/sh-elf-as.exe"
OBJDUMP="$TOOLCHAIN/sh-elf-objdump.exe"
PROD_BUILD="${DAYTONA_BUILD:-/mnt/d/Projects/DaytonaCCEReverse/build}"

# sh-elf-as.exe and sh-elf-objdump.exe are Windows binaries — they can't
# read /mnt/* paths. Every file path we pass to them must be converted
# to a Windows-style path via wslpath.
winpath() { wslpath -w "$1"; }
BASELINE_DIR="$REPO/saturn/experiments/byte_match_baselines_bin"
RCC="$REPO/build/rcc"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

MODE="${1:-check}"
case "$MODE" in
    check|pin|verbose) ;;
    *) echo "Usage: $0 [check|pin|verbose]" >&2; exit 2 ;;
esac

# Corpus: .c files that have a matching prod .o somewhere under $PROD_BUILD.
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

# ── toolchain sanity ─────────────────────────────────────────
for tool in "$AS" "$OBJDUMP"; do
    if [ ! -x "$tool" ]; then
        echo "ERROR: $tool not executable. Set SH_ELF_TOOLCHAIN." >&2
        exit 2
    fi
done
if [ ! -x "$RCC" ]; then
    echo "ERROR: $RCC not built. Run saturn/tools/build.sh first." >&2
    exit 2
fi
if [ ! -d "$PROD_BUILD" ]; then
    echo "ERROR: $PROD_BUILD not found. Set DAYTONA_BUILD." >&2
    exit 2
fi

mkdir -p "$BASELINE_DIR"

# Extract instruction lines from objdump output.
# Input:   "   0:\taa bb  \tmnem ops\t! comment"
# Output:  "aa bb  mnem ops"
normalize() {
    # Drop lines that aren't instruction rows (headers, blank, section,
    # symbol labels). Keep the bytes + mnemonic; strip the ! commentary.
    sed -n 's/^[[:space:]]*[0-9a-f]\{1,\}:[[:space:]]*//p' | \
        sed 's/[[:space:]]*![[:space:]].*$//' | \
        sed 's/[[:space:]]\+$//'
}

find_prod_o() {
    local name="$1"
    find "$PROD_BUILD" -maxdepth 2 -name "${name}.o" -print -quit 2>/dev/null
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

    if [ ! -f "$our_c" ]; then
        printf "%-16s  %-7s  %s\n" "$name" "MISS" "(no .c)"
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    prod_o="$(find_prod_o "$name")"
    if [ -z "$prod_o" ]; then
        printf "%-16s  %-7s  %s\n" "$name" "SKIP" "(no prod .o)"
        SKIPPED=$((SKIPPED+1))
        continue
    fi

    # Compile .c → .s in tmpdir (cpp -P first; rcc doesn't handle #define).
    pp_c="$TMPDIR/${name}.pp.c"
    sfile="$TMPDIR/${name}.s"
    if ! cpp -P "$our_c" > "$pp_c" 2>/dev/null; then
        cp "$our_c" "$pp_c"
    fi
    # Pre-check baseline so toolchain failures can be classified as
    # regressions (used to work, now broken) vs. pre-existing (no baseline).
    baseline_file="$BASELINE_DIR/${name}.diff_count"
    baseline=""
    [ -f "$baseline_file" ] && baseline="$(cat "$baseline_file")"

    if ! "$RCC" -target=sh/hitachi "$pp_c" "$sfile" 2>"$TMPDIR/rcc.err"; then
        if [ -n "$baseline" ]; then
            printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "RCC!" "(was assembling at diff=$baseline)"
            FAIL_REPORT+="${name}: rcc failed (was assembling at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            printf "%-16s  %-7s  %s\n" "$name" "RCC!" "(see $TMPDIR/rcc.err)"
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi

    # Assemble our .s → .o. sh-elf-as.exe is a Windows binary; paths need
    # Windows-style conversion.
    our_o="$TMPDIR/${name}.our.o"
    if ! "$AS" --isa=sh2 --big -o "$(winpath "$our_o")" "$(winpath "$sfile")" 2>"$TMPDIR/as.err"; then
        if [ -n "$baseline" ]; then
            printf "%-16s  %-7s  %s  *** REGRESSION ***\n" "$name" "AS!" "(was assembling at diff=$baseline)"
            FAIL_REPORT+="${name}: sh-elf-as failed (was assembling at diff=${baseline})\n"
            REGRESSED=$((REGRESSED+1))
        else
            printf "%-16s  %-7s  %s\n" "$name" "AS!" "(see $TMPDIR/as.err)"
            SKIPPED=$((SKIPPED+1))
        fi
        continue
    fi

    # Disassemble both, filtered to just this function's symbol.
    # Our compiler emits `_FUN_xxx`; prod's objects have `FUN_xxx`.
    our_dump="$TMPDIR/${name}.our.dump"
    prod_dump="$TMPDIR/${name}.prod.dump"
    "$OBJDUMP" -d --disassemble="_${name}" "$(winpath "$our_o")"   2>/dev/null | normalize > "$our_dump"
    "$OBJDUMP" -d --disassemble="${name}"  "$(winpath "$prod_o")"  2>/dev/null | normalize > "$prod_dump"

    # Diff count: lines present in one but not the other.
    diff_count=$(diff "$prod_dump" "$our_dump" 2>/dev/null | grep -c '^[<>]')

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
        diff -u "$prod_dump" "$our_dump" | head -30 | sed 's/^/    /'
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
    echo "(NEW functions have no baseline. Run with 'pin' to record the current diff count)"
fi

exit 0
