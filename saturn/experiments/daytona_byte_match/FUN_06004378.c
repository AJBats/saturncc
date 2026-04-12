/*
 * Byte-match attempt for Daytona CCE FUN_06004378 (backup module).
 *
 * Ghidra decompilation (ghidra_reference/backup/FUN_0602C378.c):
 *
 *   int FUN_0602c378(uint param_1)
 *   {
 *     uint uVar1 = param_1 & 0xff;
 *     if ((0x2f < uVar1) && (uVar1 < 0x3a))
 *       return (int)sRam0602c3cc + param_1;
 *     if ((0x40 < uVar1) && (uVar1 < 0x5b))
 *       return (int)sRam0602c3ce + param_1;
 *     if (uVar1 == 0x22) return 0x25;
 *     if (uVar1 == 0x27) return 0x24;
 *     if (uVar1 == 0x2d) return 0x26;
 *     if (uVar1 != 0x2e) return 0x29;
 *     return 0x27;
 *   }
 *
 * Reference .s (src/backup/FUN_06004378.s) is ~40 instructions —
 * too long to inline here. See the file directly.
 */

/* The Ghidra decompilation declared these as `extern short`, but the
 * reference binary loads them as compile-time constants via
 * `mov.w @(disp,PC)`. The actual values from the binary are 0x00D0
 * and 0x00C9 — known short constants, not runtime dereferences. */

int FUN_06004378(int c) {
    int u = c & 0xff;
    if (u >= 0x30 && u <= 0x39)
        return 0x00D0 + c;
    if (u >= 0x41 && u <= 0x5a)
        return 0x00C9 + c;
    if (u == 0x22) return 0x25;
    if (u == 0x27) return 0x24;
    if (u == 0x2d) return 0x26;
    if (u != 0x2e) return 0x29;
    return 0x27;
}
