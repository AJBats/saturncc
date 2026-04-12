/*
 * FUN_06044834 — leaf function, struct field access.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_06044834.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06044834.c
 *
 * Production uses:
 *   mov.w @(14, r4), r0    — displacement mode (offset 0xE)
 *   mov #0x1A, r0; mov.w @(r0, r4), r0  — indexed mode (offset 0x1A)
 *   mov #0x1E, r0; mov.w @(r0, r4), r0  — indexed mode (offset 0x1E)
 *
 * The SH-2 mov.w @(disp, Rn), Rm constraint: Rm MUST be R0 for
 * displacement mode. After r0 is consumed by add, subsequent loads
 * use indexed mode through r0.
 */

int FUN_06044834(int param_1) {
    return -((int)*(short *)(param_1 + 0xe)
           + (int)*(short *)(param_1 + 0x1a)
           + (int)*(short *)(param_1 + 0x1e));
}
