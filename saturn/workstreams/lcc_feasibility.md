# Workstream: LCC feasibility probe

**Date**: 2026-04-11
**Status**: **COMPLETE** — verdict: **GO**
**Time to verdict**: ~2 hours

## Goal

Before committing to LCC as the base for a custom Hitachi-style SH-2 byte-matching compiler, verify that the existing LCC compiler:
1. Actually builds on our development environment
2. Actually works (produces assembly from C)
3. Has a machine-description format we can realistically target for SH-2 with Hitachi-style codegen
4. Is licensed in a way compatible with our use case

## What I did

1. Cloned `drh/lcc` from GitHub (master branch, lcc version 4.2).
2. Read `README` and `CPYRIGHT`.
3. Surveyed the source tree and identified the core files.
4. Built `rcc` (the core compiler) from scratch in WSL/Ubuntu 24.04 with gcc 13.3 and GNU Make 4.3.
5. Ran `rcc` on a trivial test C file and inspected both x86 output and symbolic IR dump.
6. Read the MIPS machine-description file end-to-end (mips.md, 1120 lines) to understand the rule syntax.
7. Sketched ~30 lburg rules for a minimal Hitachi-style SH-2 backend as a proof of concept ([sh_sketch.md](../tools/lcc/src/sh_sketch.md)).

## Results

### Build

- Only one real gotcha: git checked out the source with CRLF line endings because we're on Windows. Fixed with a one-liner: `find . -type f ... -exec sed -i 's/\r$//' {} +`
- After that, the default unix makefile builds cleanly with `make BUILDDIR=./build HOSTFILE=etc/linux.c TARGET=x86/linux CC=gcc LD=gcc all`.
- Build time: **under 30 seconds** on WSL.
- Artifacts produced:

| Binary | Size | Purpose |
|---|---|---|
| `rcc` | 1.28 MB | The compiler proper. Takes C source, emits target assembly. |
| `cpp` | ~150 KB | Standalone C preprocessor. |
| `lburg` | ~100 KB | Compiles machine-description files to C. |
| `lcc` | ~60 KB | Driver that invokes cpp + rcc + as + ld (we likely won't use it). |
| `bprint` | ~30 KB | Bytecode output pretty-printer (tangential). |

Warnings during build are cosmetic (signed/unsigned comparisons, implicit function declarations in the trailing C sections of the `.md` files). No errors.

### Proof of life

Compiled this C:
```c
int add(int a, int b) { return a + b; }
int sum_of_three(int a, int b, int c) { return a + b + c; }
```

**x86 output** (`rcc -target=x86/linux`):
```
add:
pushl %ebp
pushl %ebx
pushl %esi
pushl %edi
movl %esp,%ebp
movl 20(%ebp),%edi
movl 24(%ebp),%esi
leal (%esi,%edi),%eax
.LC1:
movl %ebp,%esp
popl %edi
popl %esi
popl %ebx
popl %ebp
ret
```

Single-pass, greedy register allocation, saves all callee-saved conservatively. Notice the `leal (%esi,%edi),%eax` — LCC uses `lea` as an add even though the optimization is local. This is *exactly* the style of codegen we want for Hitachi matching: simple, predictable, close to the source.

**Symbolic output** (`rcc -target=symbolic`):
```
function add type=int function(int,int) sclass=auto scope=GLOBAL
caller a type=int sclass=auto scope=PARAM flags=0 offset=0
caller b type=int sclass=auto scope=PARAM flags=0 offset=4
callee a type=int sclass=auto scope=PARAM flags=0 offset=0
callee b type=int sclass=auto scope=PARAM flags=0 offset=4
blockbeg off=0
blockend off=0
 4. ADDRFP4 a
 3. INDIRI4 #4
 6. ADDRFP4 b
 5. INDIRI4 #6
 2. ADDI4 #3 #5
 1' RETI4 #2
```

This is the IR my SH backend will receive. Each DAG node (`ADDRFP4`, `INDIRI4`, `ADDI4`, `RETI4`) is one lburg rule. The suffixes (`I4`, `P4`, `F8`) encode type+size. A Hitachi-style backend writes one or more rules for each DAG operation.

### Backend size analysis

Counted the existing MIPS backend since it's the closest-architecture existing backend to SH (both RISC, 32 integer regs [LCC's MIPS uses 32, SH has 16], branch delay slots, similar load/store model):

| Section | Lines |
|---|---|
| Top C header (`%{...%}`) | 57 |
| lburg rules | 180 |
| Trailing C (function layout, prologue/epilogue, runtime hooks) | 794 |
| **Total mips.md** | **1120** |

**Interpretation for SH**: a full Hitachi-style SH backend should land in the **1200-1800 line range**. The extra ~200-600 lines over MIPS come from:
- More addressing-mode rules (displacement vs indexed vs GBR variants)
- Pragma handling (`#pragma gbr_base`, `#pragma interrupt`, etc.)
- Hitachi intrinsic functions (`set_gbr`, `trapa`, MAC instructions)
- Delay slot filling peephole
- Descending register save order (explicit in the function() routine)
- Section naming for `$G0`/`$G1` GBR regions

Compare to alternatives:
- **LCC MIPS backend**: 1120 lines
- **LCC SPARC backend**: 1177 lines
- **LCC Alpha backend**: 1192 lines
- **LCC x86 backend**: 1012 lines
- **Our target (SH + Hitachi style)**: estimated 1200-1800 lines
- **DaytonaUSAExplorer's 26 GCC 2.6.3 patches**: roughly equivalent volume (hundreds of lines spread across multiple files in gcc/config/sh/) but plateaued at 5.5% pass rate

### lburg rule syntax (learned from mips.md)

Rule format:
```
nonterminal: pattern  "template"  cost
```

Examples from MIPS:
```
reg: INDIRI4(addr)     "lw $%c,%0\n"   1        ; indirect int4 load → "lw $N,addr"
reg: ADDI4(reg,rc)     "addu $%c,$%0,%1\n"  1   ; int4 add → "addu $N,$src,imm-or-reg"
stmt: ASGNI4(addr,reg) "sw $%1,%0\n"   1        ; int4 store → "sw $src,addr"
addr: ADDRFP4          "%a+%F($sp)"             ; frame-relative addr
```

Template substitutions:
- `%c` — destination register (allocated by lcc)
- `%0`, `%1` — first, second child's emitted text
- `%a` — immediate value (from a `con` match)
- `%F` — frame offset (from ADDRFP4/ADDRLP4)

Cost can be an integer literal or a C expression like `range(a, 0, 60)` which returns 0 when `a` is in the range (rule is applicable) or ∞ otherwise. This is how we'd encode Hitachi's addressing-mode constraints:

```
addr: ADDI4(reg,con)   "@(%1,r%0)"    range(a,0,60)   /* .l disp mode */
addr: ADDI4(reg,con)   "@(%1,r%0)"    range(a,0,30)   /* .w disp mode */
addr: ADDI4(reg,con)   "@(%1,r%0)"    range(a,0,15)   /* .b disp mode */
```

The rule matcher picks the cheapest applicable rule, so the disp-mode rule only fires when the displacement fits; otherwise the indexed-mode rule (higher cost or unconstrained) wins.

### License analysis

`CPYRIGHT` full text reviewed. **Not** MIT/BSD — custom license with these key terms:

- ✓ **Personal research and instructional use**: free under "fair use"
- ✓ **Redistribution of whole or part**: allowed, must include CPYRIGHT file and acknowledge source
- ✓ **Modifications**: allowed
- ✗ **Commercial sale of lcc or derivatives where lcc is "a significant part of the value"**: prohibited
- ~ **Using parts of lcc in commercial products**: allowed if you charge only for your own components
- ~ **Using lcc in products that compete with Addison-Wesley's interests** (e.g., building a C++ compiler): requires license agreement with Addison-Wesley

**Implication for our project**: We're fine. Saturn decomp is personal research / educational use, the derived compiler (a Hitachi-style SH-2 compiler) is not commercial, and if we distribute it within the Saturn community with attribution we're squarely in the "redistribute in whole or part" clause.

**One thing to note**: The compiler's OUTPUT (the assembly code and binaries it produces) is not a derivative work of LCC itself. This is standard compiler license interpretation — programs compiled by GCC are not GPL-encumbered, and programs compiled by LCC are not LCC-encumbered. So any Daytona CCE reimplementation we eventually build using our LCC-SH compiler is free of license friction.

**Not-MIT caveat**: I was wrong in the earlier feasibility framing when I said "MIT-style license, no friction." It's more restrictive than MIT. For our personal-research use case it's still fine, but if this project grows into something someone wants to commercialize later, they'd need to get an Addison-Wesley license for the compiler itself.

### Gotchas for future work

1. **CRLF on Windows checkout**. Must strip before WSL build. Trivially scriptable.
2. **Trailing C section needs backend support code** — ~800 lines for a real backend. That's the bulk of the work.
3. **Modern GCC warnings** when compiling LCC source — implicit function declarations, signed/unsigned comparisons. All cosmetic, can add `-Wno-error` or clean up gradually.
4. **`ar ruv` deprecation warning** from ranlib. Cosmetic.
5. **The `lcc` driver looks for target-specific `cpp`** at `build/gcc/cpp` or similar subdirectory paths. For our purposes we'd call `rcc` directly and skip the driver, so this doesn't matter.
6. **No built-in SH test files** in `tst/`. We'd write our own test corpus. Our regression corpus is ready: 212 functions in Daytona CCE race module.
7. **LCC is v4.2**; the Fraser/Hanson book (1995) documents v3.x. The IR and backend interface differ between versions. The current repo points at [interface4.pdf](https://drh.github.io/lcc/documents/interface4.pdf) for the v4 interface reference — **this is the primary document we need to study**, not just the old book.

## Feasibility verdict

### GO.

All four criteria met:
1. ✓ **Builds on our environment** (WSL/Ubuntu, one CRLF fix, gcc 13.3, ~30s build)
2. ✓ **Works end-to-end** (rcc produces x86 assembly from trivial C in single-pass Hitachi-like style)
3. ✓ **Machine description format is tractable** (180 rules + 800 lines C for MIPS; estimated 1200-1800 for our SH target; fraction of the code DaytonaUSAExplorer had in their 26 GCC patches)
4. ✓ **License is compatible** with personal research / Saturn decomp community redistribution with attribution

### Estimated cost to a minimum viable SH backend

**Definition of "minimum viable"**: can compile a trivial C function like `int add(int a, int b) { return a + b; }` into valid SH-2 assembly that runs on an emulator. Does NOT need to match Hitachi bytes yet.

| Task | Est. effort |
|---|---|
| Write lburg grammar for integer ops (add/sub/mul/shifts/logical/load/store/branch/return) | 2-3 days |
| Write function prologue/epilogue in trailing C with descending r14→r13→... save order | 1-2 days |
| Wire up rcc's `-target=sh/hitachi` and register the backend with the build | 0.5 days |
| Smoke test: compile trivial C → SH-2 assembly → run through sh-elf-as → binary → run in emulator | 0.5 days |
| **Subtotal: MVP** | **4-6 days** |

**Definition of "matching"**: produces byte-identical output to production code for ≥50% of the Daytona CCE race module.

| Task | Est. effort |
|---|---|
| `#pragma gbr_base` parser extension + `$G0/$G1` section handling | 2-3 days |
| `#pragma interrupt` with RTE epilogue + GBR/MAC save | 1-2 days |
| Hitachi intrinsic functions via builtin recognition | 2-3 days |
| Delay slot filling peephole | 2-3 days |
| Addressing-mode heuristic (disp vs indexed vs GBR) with correct cost model | 1-2 days |
| Regression harness: diff rcc output against shc.exe R31 output, track pass rate per race function | 1-2 days |
| Tune to 50%+ pass rate | 2-4 weeks (open-ended) |
| **Subtotal: matching phase** | **4-7 weeks** |

**Total to first meaningful matches**: 5-8 weeks of focused work. Compare to DaytonaUSAExplorer's GCC path which invested months and plateaued at 5.5% (48/867). With LCC we start at 0% but with an architecture that isn't fighting us.

## Recommended next actions

1. **Commit this probe** — working LCC build, sketch, and feasibility doc
2. **Download `interface4.pdf`** (the v4 interface document drh.github.io/lcc/documents/interface4.pdf) into `resources/`. It's the primary spec for writing v4 backends, and we should treat it the same way we treat the Hitachi manuals.
3. **Phase 1A: scaffolding** — create `src/sh.md` with the minimum viable rule set, wire it into the makefile, and get `rcc -target=sh/hitachi` to produce *some* output on a trivial C file. Doesn't have to be correct Hitachi style yet, just has to run and not crash.
4. **Phase 1B: validate the output** — feed the generated assembly through `sh-elf-as` (from our existing saturn-sdk-8-4 toolchain) to make sure it's syntactically valid SH-2 assembly.
5. **Phase 1C: first real function** — compile `FUN_06044834` (the 10-instruction leaf benchmark) and diff against production bytes. Set up the regression harness.
6. Then, and only then, start adding Hitachi-specific features (pragmas, GBR, etc).

This probe answers "yes, LCC is a viable base." The actual build is the next workstream, not this one.

## Artifacts

- [`../tools/lcc/`](../tools/lcc/) — cloned LCC 4.2 source tree (CRLF stripped in-place)
- [`../tools/lcc/build/rcc`](../tools/lcc/build/rcc) — built core compiler (1.28 MB, WSL-built, not committed)
- [`../tools/lcc/test_trivial.c`](../tools/lcc/test_trivial.c) — smoke test C file
- [`../tools/lcc/src/sh_sketch.md`](../tools/lcc/src/sh_sketch.md) — ~30-rule proof-of-concept SH backend sketch (not yet compilable; just demonstrates the shape)
- This document — the feasibility verdict
