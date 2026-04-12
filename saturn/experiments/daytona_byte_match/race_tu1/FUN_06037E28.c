/*
 * FUN_06037E28 — race module, first function in a 4-function TU.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/mods/transplant/race/FUN_06037E28.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06037E28.c
 */

extern void setup_func(void);
extern void sub_06037ED4(int);
extern void sub_06037EA4(void);

extern char dat_060540B4;
extern int base_array;

int FUN_06037E28(int param_1) {
    int *gs;
    int *secondary;
    int state;

    setup_func();

    /* Original types: (unsigned short)param_1 * (short)0x01D8 */
    gs = (int *)((short)((unsigned short)param_1 * (short)0x01D8) + base_array);

    secondary = *(int **)((char *)gs + 0x0160);

    state = *(int *)((char *)gs + 0x5C);
    if (state == 10) {
        return 10;
    }

    /* Pre-switch guard: skip call block for states 6, 7, 8 */
    state = *(int *)((char *)gs + 0x5C);
    if (state != 6 && state != 7 && state != 8) {
        if (*(char *)((char *)gs + 0x12) == 1 && dat_060540B4 == 1) {
            sub_06037EA4();
        } else {
            sub_06037ED4((int)*(char *)((char *)gs + 0x12));
        }
    }

    return state;
}
