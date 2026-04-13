/*
 * FUN_06044BCC — matrix copy / palette update, ~200 instr production.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/src/race/FUN_06044BCC.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06044BCC.c
 *
 * Production uses displacement loads/stores at @(4,Rn) and @(8,Rn)
 * for 12-byte block copies (3 longs).  Also uses @(12,Rn), @(16,Rn),
 * @(20,Rn) for a 24-byte copy.
 *
 * Uses muls.w (16-bit multiply) and macl for index computation.
 * Uses bf/s delay-slot branches for tight loops.
 */

extern short DAT_06044C52;
extern int *DAT_06044C54;
extern char *DAT_06044C58;
extern char *DAT_06044C5C;
extern char *DAT_06044C60;
extern int DAT_06044C64;
extern int DAT_06044D50;
extern int DAT_06044D54;
extern int *DAT_06044D58;
extern int DAT_06044D5C;
extern int DAT_06044D60;

void FUN_06044BCC(void) {
    short sVar1;
    char *pcVar2;
    char *pcVar3;
    char *pcVar4;
    int iVar5;
    int *puVar6;
    int *puVar7;
    int *puVar8;
    unsigned int uVar9;
    int iVar10;
    unsigned int uVar11;
    int iVar12;
    char cVar13;

    iVar12 = DAT_06044D50;
    iVar5 = DAT_06044C64;
    pcVar4 = DAT_06044C60;
    pcVar3 = DAT_06044C5C;
    pcVar2 = DAT_06044C58;
    puVar7 = DAT_06044C54;
    if (*DAT_06044C58 == 0) {
        iVar12 = 0;
        uVar9 = 0;
        do {
            sVar1 = DAT_06044C52;
            puVar8 = (int *)((uVar9 & 0xff) + (int)puVar7);
            puVar6 = (int *)
                     ((short)((*pcVar3 * 3 + (short)*pcVar4) * DAT_06044C52)
                      + iVar5 + (uVar9 & 0xff));
            uVar11 = (uVar9 + 0xc) & 0xff;
            *puVar8 = *puVar6;
            ((int *)puVar8)[1] = ((int *)puVar6)[1];
            ((int *)puVar8)[2] = ((int *)puVar6)[2];
            puVar8 = (int *)(uVar11 + (int)puVar7);
            iVar12 = iVar12 + 2;
            puVar6 = (int *)((short)((*pcVar3 * 3 + (short)*pcVar4) * sVar1)
                     + iVar5 + uVar11);
            *puVar8 = *puVar6;
            ((int *)puVar8)[1] = ((int *)puVar6)[1];
            ((int *)puVar8)[2] = ((int *)puVar6)[2];
            uVar9 = uVar9 + 0x18;
        } while (iVar12 < 0x14);
    }
    else {
        puVar6 = DAT_06044C54 + 0xf;
        cVar13 = 0;
        for (; puVar7 < puVar6; puVar7 = puVar7 + 3) {
            puVar8 = (int *)((short)(*pcVar3 * 0x3c) + iVar12 + (int)cVar13);
            *puVar7 = *puVar8;
            ((int *)puVar7)[1] = ((int *)puVar8)[1];
            ((int *)puVar7)[2] = ((int *)puVar8)[2];
            cVar13 = cVar13 + 0xc;
        }
    }
    iVar5 = DAT_06044D5C;
    puVar7 = DAT_06044D58;
    iVar10 = 0;
    cVar13 = 0;
    puVar6 = (int *)(((*pcVar2 * 5 + (int)*pcVar3) * 0x18 & 0xff)
             + DAT_06044D54);
    *DAT_06044D58 = *puVar6;
    puVar7[1] = puVar6[1];
    puVar7[2] = puVar6[2];
    puVar7[3] = puVar6[3];
    puVar7[4] = puVar6[4];
    puVar7[5] = puVar6[5];
    iVar12 = DAT_06044D60;
    do {
        puVar6 = (int *)(cVar13 + iVar5);
        puVar7 = (int *)((short)((*pcVar2 * 5 + (short)*pcVar3) * 0x30)
                 + iVar12 + (int)cVar13);
        *puVar6 = *puVar7;
        ((int *)puVar6)[1] = ((int *)puVar7)[1];
        ((int *)puVar6)[2] = ((int *)puVar7)[2];
        puVar6 = (int *)((char)(cVar13 + 0xc) + iVar5);
        iVar10 = iVar10 + 2;
        puVar7 = (int *)
                 ((short)((*pcVar2 * 5 + (short)*pcVar3) * 0x30)
                  + iVar12 + (int)(char)(cVar13 + 0xc));
        *puVar6 = *puVar7;
        ((int *)puVar6)[1] = ((int *)puVar7)[1];
        ((int *)puVar6)[2] = ((int *)puVar7)[2];
        cVar13 = cVar13 + 0x18;
    } while (iVar10 < 4);
}
