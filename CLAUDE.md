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

**For current state of work:**
- `wsl bash saturn/tools/validate_byte_match.sh dashboard` — prints
  current per-function byte-match diff counts as a markdown table.
- `git log --oneline master -10` — what's shipped recently.
- `saturn/workstreams/methodology_remediation.md` — open audit /
  infrastructure items.

**Stable references:**
- `saturn/workstreams/gap_catalog.md` — canonical catalog of the
  18 known backend gaps (Gaps 0–17), layer taxonomy, dependency
  graph, per-gap status. Read this before working on any gap.
- `saturn/workstreams/landmines.md` — latent compiler / build
  pitfalls. Read before touching peephole ordering, register
  rename passes, or the lburg grammar section.

**For the longer context:**
- `saturn/README.md` — orients the research project.
- `saturn/workstreams/current_state_of_research.md` — full
  investigation history, compiler survey findings, why LCC.
- `saturn/workstreams/lcc_feasibility.md` — the "GO" probe for
  the LCC approach.
- `saturn/experiments/daytona_byte_match/README.md` — byte-match
  experiment layout and per-function notes.
- `UPSTREAM.md` — what's ours vs what's upstream drh/lcc.

## Working conventions

- **Subagent graders can be wrong.** Double-check verdicts against
  primary evidence (asmdiff + actual file reads) when in doubt.
  One historical case: a grader misattributed FUN_06047748's
  `r0 vs r8` return mismatch (Gap 15) as a regression caused by
  the leaf rename.
- **Human diff workflow.** `bash saturn/tools/asmdiff.sh FUNCNAME`
  normalizes prod into `build/cmp/<FUNCNAME>.s` for VS Code
  side-by-side viewing. Separate from `validate_byte_match.sh`'s
  mechanical diff — use this when you want to eyeball the
  difference, the other when you want a regression-gated number.
- **Don't measure progress by instruction count alone.** Shorter
  output using different instructions than production is not
  progress. Grade on matching production's specific sequences.
- **C source is not sacred.** The decompiled C in
  `saturn/experiments/` is a Ghidra best-guess and can be wrong
  in ways that force extra work on the compiler. Fix the C when
  it's the simpler path to a prod match (e.g., FUN_06044BCC's
  DAT refactor — Gap 0).
- **Cite specific line diffs when claiming progress.** Use
  asmdiff + actual file reads. The instinct to conflate
  session-level progress with commit-level progress caused
  overclaiming in earlier sessions.

## External references

- **Authoritative prod assembly:** the raw SHC output at
  `D:/Projects/DaytonaCCEReverse/src/race/FUN_*.s`. Some functions
  are inlined in larger TU files (e.g., FUN_06037E28 lives inside
  `FUN_060351CC.s`). `mods/transplant/race/*.s` are reassembled
  copies without the `init cross-ref, fixed` pool markers — the
  raw `src/race/*.s` is what you want for Gap 0 archaeology.
- **Authoritative prod object files:** `D:/Projects/DaytonaCCEReverse/build/<module>/FUN_*.o`
  — what tier-2 `validate_byte_match_bin.sh` diffs against.
- **Ghidra C reference:** `D:/Projects/DaytonaCCEReverse/ghidra_reference/race/*.c`.
  Useful for spot-checking whether our experiment C dropped a
  deref or mis-typed a DAT (we've caught one such bug —
  `dat_060383A4`).

## Constraints worth knowing

- **Windows + WSL.** The harness's Bash tool mangles `$(pwd)`
  substitution when commands go through wsl.exe. `saturn/tools/build.sh`
  sidesteps this with absolute paths from `readlink -f "$0"`.
  Don't use `$(pwd)` inside WSL-invoked commands. See
  `landmines.md` for the full pattern.
- **Line endings.** `.gitattributes` forces LF on text files.
  Don't commit with autocrlf fighting back — if a file ends up
  CRLF in the working copy after checkout, do
  `rm <file> && git checkout -- <file>` to force re-checkout.
- **No taskkill ever.** User has a strict no-kill-processes rule
  (`~/.claude/rules/no-taskkill.md`).
- **No commits without user approval** in interactive mode. In
  nightshift mode, commit at logical stopping points without
  asking.
- **`pineapple` safe-word for deletes.** No `rm`, `git rm`, or
  equivalent without it. The safe word authorizes a *specific*
  deletion, not a class.
- **Saturn has no FPU.** Don't chase floating-point codegen; the
  user explicitly scoped it out.
