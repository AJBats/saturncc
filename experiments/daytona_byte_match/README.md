# Daytona CCE byte-match experiments

Hand-written C source, compiled with our custom LCC sh/hitachi
backend, compared against the reference bytes extracted from the
real Daytona USA CCE binary (sister project `DaytonaCCEReverse`).

## How this works

Each attempt lives in a `FUN_<addr>.c` file with the reference C
(from Ghidra's decompilation) and reference assembly (from the
`DaytonaCCEReverse/src/` Ghidra-extracted .s files) inlined as a
block comment at the top of the file. The goal is to rewrite the
C until our backend produces the same instruction sequence — or
to identify exactly which backend gap prevents the match.

To compile an attempt:

```bash
./tools/lcc/build/rcc -target=sh/hitachi \
    experiments/daytona_byte_match/FUN_<addr>.c \
    experiments/daytona_byte_match/FUN_<addr>.s
```

Then assemble and disassemble:

```bash
sh-elf-as --isa=sh2 --big -o FUN_<addr>.o FUN_<addr>.s
sh-elf-objdump -d FUN_<addr>.o
```

## Attempts

### FUN_06000AF8 — indirect call + counter increment

**Source**: `backup` module (loads at 0x06028000), a thin wrapper
around an indirect function pointer plus a counter byte.

Status: **18 instructions vs 17 in the reference**.

What's matching (after the improvements in commit 2a44ae8):
- The high-level shape: save PR, load arg pointers, deref short,
  call through pointer, read+increment+write counter, return.
- `add #1,rN` for the counter increment (was `mov #1,rX; add rX,rN`).
- Single sign/zero extension for the byte load (was two
  back-to-back extensions).
- Function call goes through the literal-pool/jsr path.

What's not matching:
1. **Wasted `r13` save**. LCC's allocator assigns the
   `result` temporary to r13 as a callee-saved home, the
   round-trip peephole then eliminates the use, but the prologue
   save/restore stays because `usedmask` is computed before the
   peephole runs. Fixing this cleanly requires recomputing
   `sizeisave` after the peephole, which then invalidates the
   r14-relative offsets emit2 already baked into the body. So
   right now it's just two wasted instructions.
2. **`nop` in the jsr delay slot**. The reference fills it with
   `extu.w r4,r4` — moving the zero-extension into the slot.
   Our leaf delay-slot filler only runs for the rts epilogue,
   not jsr inside the body. A general-purpose delay-slot scheduler
   that can pull safe instructions forward into any jsr/bsr slot
   is a bigger change.
3. **Literal pool layout**. The reference interleaves the pool
   immediately after the branches that reference it (so the
   `mov.l @(disp,PC)` instructions use very small disp values).
   Our backend dumps the entire pool after the function epilogue,
   so every disp byte in the pool loads differs from the reference
   — even when the instruction opcodes are identical in structure.
4. **`tst r4,r4` dead instruction**. The reference emits a test
   whose flag is never consumed, suggesting the original C had a
   branch on the result that the optimizer collapsed because both
   sides produced the same effect. Reproducing this requires
   knowing what the source actually looked like.

### What the experiment surfaced in the backend

Two concrete fixes came out of this attempt and shipped in
commit 2a44ae8:

1. **Double-extension on byte loads**. My `INDIRI1`/`INDIRU1`
   rules were emitting `mov.b + extu.b` and then the subsequent
   `CVUI4` rule fired a second `extu.b` on top. Dropped the
   extension from the load rules — mov.b already sign-extends
   into the destination register.
2. **No immediate-add path**. Every `a + <small const>` was
   going through `mov #imm,rX; add rX,rY` instead of the
   single-instruction `add #imm,rY`. Added `immi8`/`immu8`
   nonterminals and `reg: ADDI4(reg,immi8)` rules at cost 0
   so the constant-add path wins.

Those two together took the function from ~20+ instructions down
to 18.

## Open questions

- Is byte-match even the right goal, or is "semantically matching
  output that passes the same tests" good enough? The two
  structural differences (r13 save, literal pool layout) may
  never be fixable without a large refactor.
- Could we drive the linker from the ghidra .s reference files
  directly, producing a hybrid output that uses the reference
  pool layout but our codegen for instructions?
