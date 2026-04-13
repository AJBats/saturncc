/*
 * FUN_0602A664 — visibility/portal traversal, 77-line production asm.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_0602A664.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_0602A664.c
 *
 * Production features we can't match yet:
 *   - mov.l @r10+,r2 / mov.w @r2+,r3 (post-increment)
 *   - mov.l @(r0,r2),r2 (indexed addressing)
 *   - bt/s delay-slot branch
 *   - manual push/pop of callee-saved regs around inner call
 *     (SHC interprocedural register allocation)
 *   - dt r7 for outer loop (we have dt folding, may match)
 *
 * Displacement loads from the base struct (offsets 4..20) should
 * now use our new mov.l @(disp,Rn),Rm rules.
 */

extern char DAT_0602A6C8;
extern void (*DAT_0602A6CC)(void);
extern int DAT_0602A6D0;
extern int DAT_0602A6D4;
extern int *DAT_0602A6D8;
extern void (*DAT_0602A6DC)(void);

int FUN_0602A664(void) {
    int base;
    int callback_param;
    int *iter;
    int offset;
    int list_base;
    int count;
    int entry;
    short *list_ptr;
    short val;
    char *flag;

    DAT_0602A6C8 = 0x11;
    DAT_0602A6CC();

    base = DAT_0602A6D0;
    callback_param = ((int *)base)[1];
    iter      = ((int **)base)[2];
    offset    = ((int *)base)[3];
    list_base = ((int *)base)[4];
    count     = ((int *)base)[5];

    do {
        entry = *iter;
        iter = iter + 1;
        entry = *(int *)(entry + offset);
        list_ptr = (short *)(entry + list_base);
        if (entry != 0) {
            for (;;) {
                val = *list_ptr;
                list_ptr = list_ptr + 1;
                if (val == -1) break;
                flag = (char *)(DAT_0602A6D4 + (int)val);
                if (*flag == 0) {
                    *flag = 1;
                    DAT_0602A6DC();
                }
            }
        }
        count = count + -1;
    } while (count != 0);
    return offset;
}
