#!/bin/bash
# pad_report.sh — report alignment pads materialized at saturncc's
# synthetic .balign sites ("loud absorption").
#
# rcc brackets every synthetic `.balign` with a zero-size symbol pair
# (see sh_emit_pad_probe in src/sh.md):
#
#   saturncc_pad_probe_N:          ← address before alignment
#       .balign 4
#   saturncc_pad_mark_N_<site>:    ← address after alignment
#
# After assembly the pair's address difference IS the pad. GAS itself
# cannot report this (`.if` across an alignment directive is a
# "non-constant expression" hard error — one-pass parse-time
# evaluation), so the question is answered here, from the .o symbol
# table. The symbols are local, zero-size, and stripped by
# objcopy -O binary — image bytes are untouched.
#
# Usage:
#   bash pad_report.sh <object.o> [--strict]
#
#   --strict    exit 1 if any pad materialized. Use in free-build
#               identity gates, where the expected count is zero.
#
# Default nm is the saturn-sdk sh-elf toolchain (Windows exe — pass
# the object as a path that binary can read, or override with
# SH_NM=/path/to/nm for a native nm).

set -u

NM="${SH_NM:-/mnt/c/Users/albat/saturndev/saturn-sdk-8-4/toolchain/bin/sh-elf-nm.exe}"
OBJ="${1:-}"
STRICT=0
[ "${2:-}" = "--strict" ] && STRICT=1

if [ -z "$OBJ" ]; then
    echo "Usage: pad_report.sh <object.o> [--strict]" >&2
    exit 2
fi
if [ ! -e "$NM" ]; then
    echo "ERROR: nm not found at $NM (set SH_NM)" >&2
    exit 2
fi

"$NM" "$OBJ" | awk -v strict="$STRICT" '
    # nm may be a Windows exe emitting CRLF; strip the CR before
    # field-anchored matches or trailing-$ patterns silently fail.
    { sub(/\r$/, "") }
    $3 ~ /^saturncc_pad_probe_[0-9]+$/ {
        n = $3
        sub(/^saturncc_pad_probe_/, "", n)
        probe[n] = strtonum("0x" $1)
        have[n] = 1
    }
    $3 ~ /^saturncc_pad_mark_[0-9]+_/ {
        sym = $3
        n = sym
        sub(/^saturncc_pad_mark_/, "", n)
        sub(/_.*$/, "", n)
        site = sym
        sub(/^saturncc_pad_mark_[0-9]+_/, "", site)
        mark[n] = strtonum("0x" $1)
        name[n] = site
        have[n] = 1
    }
    END {
        PROCINFO["sorted_in"] = "@ind_num_asc"
        pads = 0
        pairs = 0
        for (n in have) {
            if (!(n in probe) || !(n in mark))
                continue
            pairs++
            if (mark[n] != probe[n]) {
                printf("PAD: %d byte(s) at 0x%08x  site %s\n",
                       mark[n] - probe[n], probe[n], name[n])
                pads++
            }
        }
        printf("pad sites checked: %d, pads materialized: %d\n",
               pairs, pads)
        if (strict && pads > 0)
            exit 1
    }
'
