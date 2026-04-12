/*
 * FUN_06037E28 — race module, first function in a 4-function TU.
 *
 * This is a per-player state machine dispatcher. param_1 is the
 * player index (0-7). It computes a struct pointer from a base
 * array using a multiply stride, loads a secondary pointer from
 * that struct, then dispatches on a state field (offset 0x5C)
 * through a 10-case switch.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/mods/transplant/race/FUN_06037E28.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06037E28.c
 */

/* External functions called through pool pointers */
extern void setup_func(void);              /* pool 06037E98 */
extern void sub_06037ED4(int);             /* pool 06037ED4 */
extern void sub_06037EA4(void);            /* pool 06037EA4 */

/* External data */
extern char dat_060540B4;                  /* pool 06037EA0 */
extern int base_array;                     /* pool 06037E9C = 0x0605224C */

int FUN_06037E28(int param_1) {
    int *gs;       /* game state struct pointer → r14 */
    int *secondary; /* secondary pointer → r13 */
    int state;

    setup_func();

    /* Compute struct pointer: base + (byte)param_1 * stride
     * Reference uses muls.w for 16-bit signed multiply */
    gs = (int *)((short)((param_1 & 0xff) * 0x01D8) + base_array);

    /* Load secondary pointer from struct offset 0x160 */
    secondary = *(int **)((char *)gs + 0x0160);

    /* Check for state 10 (early return) */
    state = *(int *)((char *)gs + 0x5C);
    if (state == 10) {
        return 10;
    }

    /* TODO: rest of the switch statement */
    return state;
}
