/*
 * FUN_0604025C — allocator wrapper, initializes struct header.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_0604025C.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_0604025C.c
 */

/* Gap 0: DAT_0604027c is a fixed function-pointer literal in prod's
 * pool (sym_06013B78, "init cross-ref, fixed") — not a pointer
 * variable at some address.  #define collapses the double-deref from
 * the extern form into prod's single mov.l pool; jsr @r3. */
#define DAT_0604027c ((int (*)(void))0x06013B78)

short *FUN_0604025C(void) {
    int blk;

    blk = DAT_0604027c();
    *(short *)(blk + 0x10) = 0;
    *(char *)(blk + 0x13) = 0;
    *(char *)(blk + 0x12) = 0;
    *(int *)(blk + 0x14) = blk;
    return (short *)(blk + 0x10);
}
