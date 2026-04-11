#!/bin/bash
# Clone, CRLF-fix, and build drh/lcc for use as our custom-SH-backend base.
#
# Run from project root:
#   bash tools/setup_lcc.sh
#
# Requires WSL or a Linux-style environment with gcc + make.
# Output: tools/lcc/build/rcc (and friends)
#
# LCC is licensed under a permissive-but-not-MIT license (see CPYRIGHT
# after clone). Terms summary:
#   - Free for personal research, instructional use, redistribution
#     with attribution
#   - Not for commercial sale or profit-motivated derived products
#
# See workstreams/lcc_feasibility.md for the probe that validated this approach.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LCC_DIR="${SCRIPT_DIR}/lcc"

if [ ! -d "${LCC_DIR}" ]; then
    echo "[1/4] Cloning drh/lcc into ${LCC_DIR}"
    git clone --depth=1 https://github.com/drh/lcc.git "${LCC_DIR}"
else
    echo "[1/4] LCC already cloned at ${LCC_DIR}, skipping"
fi

echo "[2/4] Stripping CRLF line endings (git checkout may have added them)"
cd "${LCC_DIR}"
find . -type f \
    \( -name '*.c' -o -name '*.h' -o -name '*.md' -o -name '*.mk' \
    -o -name 'makefile*' -o -name 'Makefile*' -o -name 'run.sh' \) \
    -exec sed -i 's/\r$//' {} +

echo "[3/4] Building rcc (and friends) in ${LCC_DIR}/build"
rm -rf build
mkdir -p build
make BUILDDIR="$(pwd)/build" HOSTFILE=etc/linux.c TARGET=x86/linux \
     CC=gcc LD=gcc all 2>&1 | tail -20

echo "[4/4] Smoke test: compile a trivial C file with rcc"
cat > /tmp/sat_lcc_smoke.c <<'EOF'
int add(int a, int b) { return a + b; }
EOF
./build/rcc -target=x86/linux /tmp/sat_lcc_smoke.c /tmp/sat_lcc_smoke.s
if grep -q 'leal\|movl' /tmp/sat_lcc_smoke.s; then
    echo "  OK - rcc produces x86 output"
else
    echo "  FAIL - rcc output looks wrong, check /tmp/sat_lcc_smoke.s"
    exit 1
fi

echo ""
echo "LCC build complete."
echo "  Compiler:  ${LCC_DIR}/build/rcc"
echo "  Targets:   ./build/rcc -h  (to list)"
echo "  Symbolic:  ./build/rcc -target=symbolic input.c output.txt"
echo ""
echo "Our custom SH-2 backend will live at ${LCC_DIR}/src/sh.md (not yet created)."
echo "See workstreams/lcc_feasibility.md and workstreams/sh_backend_sketch.md."
