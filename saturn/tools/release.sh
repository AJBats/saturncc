#!/bin/bash
# release.sh — produce a stamped release artifact for downstream consumers.
#
# Builds rcc (via build.sh) and copies it to build/release/rcc, then
# writes build/release/VERSION with the git short-sha + date. This
# directory is the rubber-stamp boundary: external projects (notably
# DaytonaCCEReverse) reference build/release/rcc and never reach into
# build/rcc directly. That keeps "what's released" decoupled from
# "what's in my working tree right now."
#
# Run from anywhere:
#   bash saturn/tools/release.sh
#
# Output:
#   build/release/rcc        — copy of build/rcc (NOT a symlink)
#   build/release/VERSION    — git short-sha + ISO date + dirty flag
#
# Both build/ and build/release/ are gitignored.

set -e

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUILDDIR="$REPO_ROOT/build"
RELEASEDIR="$BUILDDIR/release"

echo "=== saturncc release ==="
echo "Repo root:    $REPO_ROOT"
echo "Build dir:    $BUILDDIR"
echo "Release dir:  $RELEASEDIR"
echo ""

echo "[1/3] Building compiler..."
bash "$SCRIPT_DIR/build.sh" > /dev/null
if [ ! -x "$BUILDDIR/rcc" ]; then
    echo "  FAIL - $BUILDDIR/rcc not produced by build.sh"
    exit 1
fi
echo "  OK - $BUILDDIR/rcc built"

echo "[2/3] Stamping release artifact..."
mkdir -p "$RELEASEDIR"
cp "$BUILDDIR/rcc" "$RELEASEDIR/rcc"

cd "$REPO_ROOT"
SHA="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
DIRTY=""
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    DIRTY=" (dirty)"
fi

cat > "$RELEASEDIR/VERSION" <<EOF
saturncc release
sha:   $SHA$DIRTY
date:  $DATE
EOF

echo "  OK - $RELEASEDIR/rcc"
echo "  OK - $RELEASEDIR/VERSION"

echo "[3/3] Smoke-testing released binary..."
cat > /tmp/saturncc_release_smoke.c <<'EOF'
int add(int a, int b) { return a + b; }
EOF
if "$RELEASEDIR/rcc" -target=sh/hitachi /tmp/saturncc_release_smoke.c /tmp/saturncc_release_smoke.s 2>/dev/null; then
    echo "  OK - released rcc compiles -target=sh/hitachi"
else
    echo "  FAIL - released rcc crashed on smoke test"
    rm -f /tmp/saturncc_release_smoke.c /tmp/saturncc_release_smoke.s
    exit 1
fi
rm -f /tmp/saturncc_release_smoke.c /tmp/saturncc_release_smoke.s

echo ""
echo "=== Released ==="
cat "$RELEASEDIR/VERSION"
echo ""
echo "Consumers should reference:"
echo "  $RELEASEDIR/rcc"
