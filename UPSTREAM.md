# Upstream

This repo is a fork of [drh/lcc](https://github.com/drh/lcc)
developed as the compiler for the
[saturn reverse-engineering project](saturn/README.md).

## Branch point

The initial checkout was based on upstream commit:

```
2b5cf358d9aa6759923dd7461f2df7f7f2a28471
"Update cwf's home page URL."
```

## Pulling upstream changes

The `upstream` remote is configured to point at drh/lcc:

```
git remote add upstream https://github.com/drh/lcc.git
git fetch upstream
git merge upstream/master          # or cherry-pick specific commits
```

drh/lcc doesn't touch anything under `saturn/` and rarely
touches `src/bind.c`, `src/input.c`, or `makefile` (the three
files our patches modify), so merges should usually be clean.

## Our changes on top of upstream

A `git log --no-merges upstream/master..HEAD` will list everything
that's ours. The summary:

 - **`src/sh.md`** — Brand new SH-2 lburg backend (~1700 lines).
   This file does not exist in upstream.
 - **`src/bind.c`** — One-line hunk adding `xx(sh/hitachi, shIR)`
   to the target-binding table.
 - **`src/input.c`** — Three-hunk extension for the
   `shc_pragma_hook` so backends can handle non-ref pragmas.
 - **`makefile`** — Five hunks wiring `src/sh.md` through lburg
   into the build alongside the existing mips/sparc/alpha/x86
   backends.
 - **`saturn/`** — The reverse-engineering research project that
   drives this fork. Not part of the compiler itself. See
   [saturn/README.md](saturn/README.md).
 - **`.gitattributes`** — Forces LF line endings for text files
   so the WSL build doesn't need a CRLF-strip step.

## License

LCC is distributed under its original CPYRIGHT notice (see
[CPYRIGHT](CPYRIGHT)). The license is free for personal research
and educational use, with restrictions on selling the compiler
or derivatives. This fork is maintained for research purposes
tied to the saturn project and is not sold or included in any
commercial product.
