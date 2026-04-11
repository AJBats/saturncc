#!/bin/bash
# Helper to build LCC from inside WSL. Sidesteps the Claude Code Bash
# tool's quirk where $(...) command substitution gets stripped when
# passed through to wsl.
set -e
cd /mnt/d/Projects/SaturnCompiler/tools/lcc
rm -rf build
mkdir -p build
BUILDDIR="$PWD/build"
# $PWD is unreliable when this script is exec'd via wsl-c wrapper;
# fall back to the hardcoded path if empty.
if [ -z "$BUILDDIR" ] || [ "$BUILDDIR" = "/build" ]; then
    BUILDDIR=/mnt/d/Projects/SaturnCompiler/tools/lcc/build
fi
echo "BUILDDIR=$BUILDDIR"
make BUILDDIR="$BUILDDIR" HOSTFILE=etc/linux.c TARGET=x86/linux \
     CC=gcc LD=gcc all 2>&1 | tail -80
