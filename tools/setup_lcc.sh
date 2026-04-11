#!/bin/bash
# Clone, CRLF-fix, apply SaturnCompiler patches, and build drh/lcc.
#
# Run from project root (or anywhere — script resolves its own path):
#   bash tools/setup_lcc.sh
#
# Requires WSL or a Linux-style environment with gcc + make + patch.
# Output: tools/lcc/build/rcc (and friends), with sh/hitachi target wired in.
#
# LCC is licensed under a permissive-but-not-MIT license (see CPYRIGHT
# after clone). Terms summary:
#   - Free for personal research, instructional use, redistribution
#     with attribution
#   - Not for commercial sale or profit-motivated derived products
#
# See workstreams/lcc_feasibility.md for the probe that validated this approach
# and tools/lcc_patches/README.md for the patch set we apply.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LCC_DIR="${SCRIPT_DIR}/lcc"
PATCHES_DIR="${SCRIPT_DIR}/lcc_patches"

if [ ! -d "${LCC_DIR}" ]; then
    echo "[1/5] Cloning drh/lcc into ${LCC_DIR}"
    git clone --depth=1 https://github.com/drh/lcc.git "${LCC_DIR}"
else
    echo "[1/5] LCC already cloned at ${LCC_DIR}, skipping clone"
fi

echo "[2/5] Stripping CRLF line endings (git checkout may have added them)"
cd "${LCC_DIR}"
find . -type f \
    \( -name '*.c' -o -name '*.h' -o -name '*.md' -o -name '*.mk' \
    -o -name 'makefile*' -o -name 'Makefile*' -o -name 'run.sh' \) \
    -exec sed -i 's/\r$//' {} +

echo "[3/5] Applying SaturnCompiler patches from ${PATCHES_DIR}"
# sh.md: drop in directly (new file, not a patch). Phase 1B replaced
# the Phase 1A sh.c stub with an lburg grammar; the makefile patch
# swaps the object rule to generate $Bsh.c from src/sh.md via lburg.
cp "${PATCHES_DIR}/sh.md" "${LCC_DIR}/src/sh.md"
# Remove any leftover src/sh.c from a previous Phase 1A install so the
# build uses the lburg-generated $Bsh.c instead.
rm -f "${LCC_DIR}/src/sh.c"

# bind.c and makefile: apply patches, idempotent check first
for patch_file in bind.c.patch makefile.patch; do
    if patch -p1 --dry-run -R --silent < "${PATCHES_DIR}/${patch_file}" > /dev/null 2>&1; then
        echo "    ${patch_file} already applied, skipping"
    else
        echo "    applying ${patch_file}"
        patch -p1 --silent < "${PATCHES_DIR}/${patch_file}"
    fi
done

echo "[4/5] Building rcc (and friends) in ${LCC_DIR}/build"
rm -rf build
mkdir -p build
make BUILDDIR="$(pwd)/build" HOSTFILE=etc/linux.c TARGET=x86/linux \
     CC=gcc LD=gcc all 2>&1 | tail -15

echo "[5/5] Verifying sh/hitachi target is registered"
if ./build/rcc 2>&1 | grep -q 'sh/hitachi'; then
    echo "  OK - sh/hitachi target registered"
else
    echo "  FAIL - sh/hitachi target not found in rcc's target list"
    ./build/rcc 2>&1 | head -20
    exit 1
fi

# Smoke test: compile a trivial C file with the stub backend. Should
# exit cleanly (no crash) even though output will be empty.
cat > /tmp/sat_lcc_smoke.c <<'EOF'
int add(int a, int b) { return a + b; }
EOF
if ./build/rcc -target=sh/hitachi /tmp/sat_lcc_smoke.c /tmp/sat_lcc_smoke_sh.s 2>&1; then
    echo "  OK - rcc -target=sh/hitachi compiled trivial C"
    if [ -s /tmp/sat_lcc_smoke_sh.s ]; then
        echo "  --- /tmp/sat_lcc_smoke_sh.s ---"
        cat /tmp/sat_lcc_smoke_sh.s
        echo "  --------------------------------"
    else
        echo "  WARN - output file is empty"
    fi
else
    echo "  FAIL - rcc crashed on sh/hitachi target"
    exit 1
fi

echo ""
echo "LCC build complete with sh/hitachi Phase 1B backend."
echo "  Compiler:   ${LCC_DIR}/build/rcc"
echo "  List targets: ${LCC_DIR}/build/rcc  (run with no args)"
echo "  Symbolic IR: ./build/rcc -target=symbolic input.c output.txt"
echo "  SH output:   ./build/rcc -target=sh/hitachi input.c output.s"
echo ""
echo "See workstreams/lcc_feasibility.md for the roadmap."
