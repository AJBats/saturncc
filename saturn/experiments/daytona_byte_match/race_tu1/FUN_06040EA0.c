/*
 * FUN_06040EA0 — GBR-relative struct access, 175 lines production.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_06040EA0.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06040EA0.c
 *
 * Production sets GBR from param_1 (ldc r4,gbr) and uses
 * GBR-relative addressing for all struct field accesses.
 * This is the first function requiring runtime GBR support.
 *
 * GBR accesses in production:
 *   mov.l @(0/8/40/48/52, gbr), r0   — long loads
 *   mov.l r0, @(48, gbr)             — long stores
 *   mov.w @(12/14/16/26/410, gbr), r0 — word loads
 *   mov.b @(18, gbr), r0             — byte loads
 *   stc gbr, r5                      — pass struct ptr as arg
 */

#pragma gbr_param

extern int DAT_06052E58;
extern int FUN_06040A64(void);
extern int FUN_060424B8(int, int, int);
extern void FUN_0602F95A(int, int, int);
extern int FUN_06040CF0(int);
extern void FUN_06044D74(void);
extern void FUN_06044E3C(int);
extern void FUN_0604507E(int);
extern void FUN_06045006(int);
extern void FUN_060450F2(int);
extern void FUN_06044F14(void);
extern void FUN_06044DF4(int);
extern int *DAT_060566B8;
extern void FUN_06040DCC(int);

void FUN_06040EA0(int *param_1) {
    int iVar2;
    int r14_result;

    if (param_1[13] != 0 && param_1[10] == 0
        && (DAT_06052E58 & 1) == 0) {
        iVar2 = FUN_06040A64();
        iVar2 = iVar2 - 2;
        if (iVar2 >= 0) {
            r14_result = iVar2;
            if (iVar2 == 0) {
                if (FUN_060424B8(param_1[0], param_1[2],
                                 0x00320000) != 0) {
                    if ((0x04000000 & param_1[12]) == 0) {
                        param_1[12] = param_1[12] | 0x04000000;
                        FUN_0602F95A(0, 0, 0x20);
                    }
                    goto after_flag;
                }
            }
            param_1[12] = param_1[12] & ~0x04000000;
after_flag:
            iVar2 = FUN_06040CF0(
                        (int)((char *)param_1)[18]);
            if (iVar2 != 0) {
                FUN_06044D74();
                FUN_06044E3C((int)param_1);
                FUN_0604507E(
                    (int)((short *)param_1)[7]
                    + (int)(short)0x8000);
                FUN_06045006(
                    (int)((short *)param_1)[6]
                    - (int)((short *)param_1)[205]);
                FUN_060450F2(
                    -(int)((short *)param_1)[8]);
                FUN_0604507E(
                    (int)((short *)param_1)[13]);
                FUN_06044F14();
                FUN_06044DF4(0x14 + r14_result);
                *(int *)(iVar2 + 4) = 4;
                *(int *)(iVar2 + 16) =
                    DAT_060566B8[(DAT_06052E58 & 6) * 2];
            }
        }
    }
    FUN_06040DCC((int)((char *)param_1)[18]);
}
