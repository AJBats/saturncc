# Saturn research project

The reverse-engineering / compiler-matching project this fork of
drh/lcc exists to serve. The LCC tree at the repo root is our
saturncc compiler; everything under `saturn/` is the research
project that drives its development.

## What lives here

| Path | What it is |
|---|---|
| [workstreams/](workstreams/) | Research notes, state-of-investigation docs, phase plans |
| [experiments/](experiments/) | Byte-match attempts against real Daytona CCE functions |
| [resources/](resources/) | Hitachi SHC manuals, Sega SBL build-flag evidence, exhibit files |
| [tools/](tools/) | Build wrapper for the compiler |
| [docs/](docs/) | Handoff notes, exploratory docs, old claude conversation transcripts |

## What we're trying to do

Byte-match decompiled Daytona CCE (Saturn, 1996) C source back to
its original SH-2 object code, using a custom compiler we built
because the original Hitachi SHC v5.0 compiler isn't available
and the closest open-source alternatives (GCC 2.6-era, Cygnus 2.7)
were both ruled out after empirical testing. See
[workstreams/current_state_of_research.md](workstreams/current_state_of_research.md)
for the full investigation.

The compiler is an LCC fork with a custom SH-2 backend at
`../src/sh.md` (i.e., at the root of this repo, not under
`saturn/`). See [workstreams/lcc_feasibility.md](workstreams/lcc_feasibility.md)
for why LCC was the right base.

## Building

From anywhere in the repo:

```bash
bash saturn/tools/build.sh
```

Requires WSL Ubuntu or any Linux with gcc + make. Produces
`build/rcc` at the repo root.

Usage:

```bash
build/rcc -target=sh/hitachi input.c output.s
sh-elf-as --isa=sh2 --big -o output.o output.s
sh-elf-objdump -d output.o
```

## Byte-match experiments

See [experiments/daytona_byte_match/README.md](experiments/daytona_byte_match/README.md)
for the running results. As of the Phase 1C wrap-up in this
migration commit we're at instruction-count parity (or shorter)
on all three targets we've tried; true byte-for-byte match is
still gated on the register allocator picking the same registers
Hitachi does, which is the next big Phase 2 push.
