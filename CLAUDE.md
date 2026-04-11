# saturncc — Claude Code context

This repo is a fork of [drh/lcc](https://github.com/drh/lcc) with a
custom SH-2 backend. It's also the home of a Sega Saturn reverse
engineering research project that lives under `saturn/`.

**Primary goal:** byte-match Daytona USA CCE (1996) by hand-writing
C source that, when compiled through our custom backend, reproduces
the exact instruction bytes of the original Hitachi SHC output.

## Repo layout

```
/                          ← drh/lcc fork (compiler)
├── src/sh.md              ← our ~1700-line SH-2 backend
├── src/bind.c             ← patched: registers sh/hitachi target
├── src/input.c            ← patched: adds shc_pragma_hook
├── makefile               ← patched: lburg rule for sh.md
├── UPSTREAM.md            ← drh/lcc branching point + upstream sync workflow
│
└── saturn/                ← research project
    ├── README.md
    ├── workstreams/       ← research docs + session handoffs
    ├── experiments/       ← byte-match attempts against real Daytona functions
    ├── resources/         ← Hitachi manuals, Sega SBL evidence
    ├── docs/              ← older handoff notes
    └── tools/build.sh     ← build wrapper
```

## Build

```bash
bash saturn/tools/build.sh
```

Produces `build/rcc` at the repo root. Requires WSL Ubuntu with
gcc + make + patch. The script runs a smoke test after compiling.

## Using the compiler

```bash
build/rcc -target=sh/hitachi input.c output.s
```

Then assemble and disassemble the output with the sh-elf toolchain
at `C:\Users\albat\saturndev\saturn-sdk-8-4\toolchain\bin\` (see
`saturn/experiments/daytona_byte_match/README.md` for the full
pipeline).

## Where to start reading

**If you're picking up mid-stream**, read the newest dated file
under `saturn/workstreams/` for the current session handoff —
it'll tell you what's in progress, what's blocked, and what the
next concrete action is.

**For the longer context:**
- `saturn/README.md` — orients the research project
- `saturn/workstreams/current_state_of_research.md` — full
  investigation history, compiler survey findings, why LCC
- `saturn/workstreams/lcc_feasibility.md` — the "GO" probe for
  the LCC approach
- `saturn/experiments/daytona_byte_match/README.md` — byte-match
  results and current gaps
- `UPSTREAM.md` — what's ours vs what's upstream drh/lcc
- `git log -- saturn/tools/lcc_patches/sh.md` or
  `git log -- saturn/` — the granular Phase 1A → 1C development
  history from before the migration (search for "Phase 1")

## Constraints worth knowing

- **Windows + WSL.** The harness's Bash tool mangles `$(pwd)`
  substitution when commands go through wsl.exe. `saturn/tools/build.sh`
  sidesteps this with absolute paths from `readlink -f "$0"`.
  Don't use `$(pwd)` inside WSL-invoked commands.
- **Line endings.** `.gitattributes` forces LF on text files.
  Don't commit with autocrlf fighting back — if a file ends up
  CRLF in the working copy after checkout, do
  `rm <file> && git checkout -- <file>` to force re-checkout.
- **No taskkill ever.** User has a strict no-kill-processes rule
  (`~/.claude/rules/no-taskkill.md`).
- **No commits without user approval** in interactive mode. In
  nightshift mode, commit at logical stopping points without
  asking.
- **User has a "pineapple" safe-word** for any file deletion. No
  `rm`, `git rm`, or equivalent without it.
- **Saturn has no FPU.** Don't chase floating-point codegen; the
  user explicitly scoped it out.
