/*
 * FUN_0604025C — allocator wrapper, initializes struct header.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_0604025C.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_0604025C.c
 */

extern int (*DAT_0604027c)(void);

short *FUN_0604025C(void) {
    int blk;

    blk = DAT_0604027c();
    *(short *)(blk + 0x10) = 0;
    *(char *)(blk + 0x13) = 0;
    *(char *)(blk + 0x12) = 0;
    *(int *)(blk + 0x14) = blk;
    return (short *)(blk + 0x10);
}
