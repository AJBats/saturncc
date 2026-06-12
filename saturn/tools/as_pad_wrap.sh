#!/bin/bash
# as_pad_wrap.sh — drop-in sh-elf-as wrapper that auto-reports
# saturncc pad tripwires after every assembly.
#
# rcc plants probe/mark symbol pairs around each synthetic .balign
# (loud absorption — see braf_dispatch_lint.md). The pad question is
# only answerable AFTER assembly, in the consumer's build, so the
# report can't run inside rcc. This wrapper makes it automatic
# anyway: point the build's AS at this script once —
#
#   AS := bash /mnt/d/Projects/saturncc/saturn/tools/as_pad_wrap.sh
#
# — and every assembly thereafter assembles exactly as before, then
# prints any materialized pads to stderr (warning-style: silent when
# the count is zero, which is the expected free-build state).
#
# Environment:
#   SATURNCC_AS          real assembler (default: saturn-sdk sh-elf-as.exe)
#   SH_NM                nm for pad_report.sh (default: sdk sh-elf-nm.exe)
#   SATURNCC_PAD_STRICT  =1 → fail the build (exit 1) if any pad
#                        materialized. For free-build identity gates.
#
# Exit code: the real assembler's, unless SATURNCC_PAD_STRICT=1 and
# pads materialized. Reporting problems (nm missing etc.) never fail
# a non-strict build — a broken reporter must not block assembly.

set -u

AS_REAL="${SATURNCC_AS:-/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-as.exe}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Find the -o argument: that's the object the report reads.
OBJ=""
prev=""
for a in "$@"; do
    if [ "$prev" = "-o" ]; then
        OBJ="$a"
    fi
    prev="$a"
done

"$AS_REAL" "$@"
as_rc=$?
if [ $as_rc -ne 0 ]; then
    exit $as_rc
fi

if [ -n "$OBJ" ]; then
    report="$(bash "$SCRIPT_DIR/pad_report.sh" "$OBJ" 2>/dev/null)"
    pads="$(printf '%s\n' "$report" | sed -n 's/.*pads materialized: \([0-9]*\)$/\1/p')"
    if [ -n "$pads" ] && [ "$pads" != "0" ]; then
        printf '%s\n' "$report" | grep '^PAD: ' | while IFS= read -r line; do
            echo "saturncc pad warning [$OBJ]: $line" >&2
        done
        if [ "${SATURNCC_PAD_STRICT:-0}" = "1" ]; then
            echo "saturncc: $pads pad(s) materialized and SATURNCC_PAD_STRICT=1" >&2
            exit 1
        fi
    fi

    # braf dispatch ground-truth verification (binary level — trusts
    # nothing textual). ERRORs here are real, guaranteed-broken
    # dispatch math, so they ALWAYS fail the build, strict or not.
    # A non-running verifier (exit 2: python/objdump missing) only
    # warns — a broken checker must not block assembly.
    braf_out="$(python3 "$SCRIPT_DIR/braf_verify.py" "$OBJ" 2>&1)"
    braf_rc=$?
    if [ $braf_rc -eq 1 ]; then
        printf '%s\n' "$braf_out" | grep -E '^(ERROR|braf tables)' | while IFS= read -r line; do
            echo "saturncc braf error [$OBJ]: $line" >&2
        done
        exit 1
    elif [ $braf_rc -ne 0 ]; then
        echo "saturncc: braf_verify.py could not run on $OBJ (rc=$braf_rc) — dispatch tables UNVERIFIED" >&2
    fi
fi

exit 0
