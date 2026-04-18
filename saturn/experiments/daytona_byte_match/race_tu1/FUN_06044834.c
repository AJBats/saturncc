/*
 * FUN_06044834 — leaf function, struct field access.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_06044834.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06044834.c
 *
 * Parameter type rewritten from Ghidra's `int param_1` to `char *`.
 * LCC's front-end wraps `int + int_disp` results in LOAD(LOAD(...))
 * nodes when the result is cast to pointer for INDIR, blocking the
 * compound `INDIRI2(ADDI4(reg,immi8))` dispload rule. `char * + int`
 * produces ADDP4 directly with no LOAD wrappers — the dispload rule
 * matches cleanly. ABI-identical (both pass in r4 as 32-bit).
 *
 * Production uses:
 *   mov.w @(14, r4), r0    — displacement mode (offset 0xE)
 *   mov #0x1A, r0; mov.w @(r0, r4), r0  — indexed mode (offset 0x1A)
 *   mov #0x1E, r0; mov.w @(r0, r4), r0  — indexed mode (offset 0x1E)
 *
 * The SH-2 mov.w @(disp, Rn), Rm constraint: Rm MUST be R0 for
 * displacement mode. Gap 2 (currently open): production uses indexed
 * mode for offsets 0x1A and 0x1E even though both fit disp range
 * (≤30). SHC heuristic unverified — under investigation.
 */

#pragma sh_weird_rule_1
int FUN_06044834(char *param_1) {
    return -((int)*(short *)(param_1 + 0xe)
           + (int)*(short *)(param_1 + 0x1a)
           + (int)*(short *)(param_1 + 0x1e));
}
