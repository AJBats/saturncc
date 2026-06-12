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
fi

exit 0
