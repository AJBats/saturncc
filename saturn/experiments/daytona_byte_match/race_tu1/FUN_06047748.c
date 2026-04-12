/*
 * FUN_06047748 — backward array copy into indexed table.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_06047748.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06047748.c
 *
 * Note: production writes final param_1 to r8 in the rts delay slot
 * (mov r4, r8). This is a caller-visible side-effect. The Ghidra C
 * doesn't capture it (void return). For now we return param_1 to
 * approximate this.
 */

extern int DAT_0604776c;

int FUN_06047748(int param_1, short *param_2, int param_3) {
    int base = DAT_0604776c;
    do {
        if (*param_2 != 0) {
            *(short *)(param_1 * 8 + base + 2) = *param_2;
            *param_2 = 0;
            param_1 = (int)param_2[1];
        }
        param_3 = param_3 + -1;
        param_2 = param_2 + -2;
    } while (param_3 != 0);
    return param_1;
}
