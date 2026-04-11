/*
 * Byte-match attempt for Daytona CCE FUN_00280710 (main module).
 *
 * Ghidra decompilation (ghidra_reference/main/FUN_00280710.c):
 *
 *   bool FUN_00280710(void)
 *   {
 *     return *DAT_0028072c != 0;
 *   }
 *
 * Where DAT_0028072c resolves to 0x2400045C.
 *
 * Reference assembly (src/main/FUN_00280710.s):
 *
 *   mov.l r14, @-r15
 *   mov.l .L_pool_0028072C, r1
 *   mov.w @r1, r1
 *   extu.w r1, r1
 *   tst r1, r1
 *   bf/s .L_00280722
 *   mov r15, r14          ; delay slot
 *   bra .L_00280724
 *   mov #0x0, r0          ; delay slot
 * .L_00280722:
 *   mov #0x1, r0
 * .L_00280724:
 *   mov r14, r15
 *   rts
 *   mov.l @r15+, r14      ; delay slot
 *
 * Current output from our backend (after adding the `tst rN,rN`
 * zero-compare rule in 2a44ae8): 14 real instructions vs 15 in
 * the reference. We're actually one SHORTER than Hitachi here —
 * the reference sets up r14 as an FP even though the function has
 * no locals and no stack-passed params, so the `mov r15,r14` and
 * matching `mov r14,r15` at the end are pure waste. Our
 * need_fp=false path correctly skips both.
 *
 * Remaining structural differences (all of them make us prettier,
 * not byte-matching):
 *  - Reference uses `bf/s` (delayed false-branch) with a useful
 *    `mov r15,r14` in the delay slot. We use plain `bt` with a
 *    nop-filled `bra`.
 *  - Reference writes the 0/1 result directly to r0 in both
 *    branches. We write to the allocator's pick (r13) and copy
 *    to r0 at the merge point.
 *  - Reference always saves/restores r14 as an FP. We only save
 *    callee-saved registers that the body actually uses.
 */

extern unsigned short dat_0028072C;   /* linked at 0x2400045C */

int FUN_00280710(void) {
    return dat_0028072C != 0;
}
