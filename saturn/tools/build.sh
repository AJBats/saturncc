#!/bin/bash
# Build the saturncc compiler in WSL / Linux.
#
# This is the Saturn research project's wrapper around the lcc
# fork's existing makefile. It runs `make` with the right
# BUILDDIR, HOSTFILE, and TARGET for a Linux-hosted build of
# rcc + lburg + cpp. After it finishes you'll have a working
# compiler at <repo-root>/build/rcc that supports
# `-target=sh/hitachi`.
#
# Run from anywhere:
#   bash saturn/tools/build.sh
#
# Requires WSL Ubuntu (or any Linux with gcc + make + patch).
#
# The harness's Bash tool mangles $(pwd) / `pwd` command
# substitution when commands are proxied through wsl.exe on
# Windows, so this script uses absolute paths derived from the
# script's own location to sidestep that.

set -e

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUILDDIR="$REPO_ROOT/build"

echo "Repo root: $REPO_ROOT"
echo "Build dir: $BUILDDIR"

mkdir -p "$BUILDDIR"

cd "$REPO_ROOT"
make BUILDDIR="$BUILDDIR" HOSTFILE=etc/linux.c TARGET=x86/linux \
     CC=gcc LD=gcc all 2>&1 | tail -20

echo ""
echo "Verifying sh/hitachi target is registered..."
if "$BUILDDIR/rcc" 2>&1 | grep -q 'sh/hitachi'; then
    echo "  OK - sh/hitachi target registered"
else
    echo "  FAIL - sh/hitachi not in rcc's target list"
    "$BUILDDIR/rcc" 2>&1 | head -20
    exit 1
fi

cat > /tmp/sat_smoke.c <<'EOF'
int add(int a, int b) { return a + b; }
EOF

if "$BUILDDIR/rcc" -target=sh/hitachi /tmp/sat_smoke.c /tmp/sat_smoke.s 2>&1; then
    echo "  OK - rcc -target=sh/hitachi compiled a trivial test"
    echo "  --- /tmp/sat_smoke.s ---"
    cat /tmp/sat_smoke.s
    echo "  ------------------------"
else
    echo "  FAIL - rcc crashed"
    exit 1
fi

echo ""
echo "Build complete. Usage:"
echo "  $BUILDDIR/rcc -target=sh/hitachi input.c output.s"
