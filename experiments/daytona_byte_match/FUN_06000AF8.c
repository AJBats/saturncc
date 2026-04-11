/*
 * Byte-match attempt for Daytona USA CCE FUN_06000AF8 (backup module).
 *
 * Ghidra decompilation (ghidra_reference/backup/FUN_06028AF8.c):
 *
 *   uVar1 = (*(code *)PTR_FUN_06028c20)(*(undefined2 *)PTR_DAT_06028c1c,
 *                                       PTR_s_DAYTONA96_0_06028c18,
 *                                       PTR_DAT_06028c14);
 *   *PTR_DAT_06028c24 = *PTR_DAT_06028c24 + '\x01';
 *   return uVar1;
 *
 * Reference assembly (src/backup/FUN_06000AF8.s):
 *
 *   sts.l pr, @-r15
 *   mov.l @(0x118,PC),r6   ; r6 = 0x06036F58
 *   mov.l @(0x118,PC),r5   ; r5 = 0x06036808
 *   mov.l @(0x11C,PC),r4   ; r4 = 0x06039FC8
 *   mov.l @(0x11C,PC),r3   ; r3 = 0x0603ED64
 *   mov.w @r4, r4          ; r4 = *(u16 *)0x06039FC8
 *   jsr @r3
 *   extu.w r4, r4          ; delay slot
 *   mov.l @(0x118,PC),r5   ; r5 = 0x06036F37
 *   mov r0, r4             ; r4 = result
 *   mov.b @r5, r3
 *   tst r4, r4
 *   add #0x1, r3
 *   mov.b r3, @r5
 *   lds.l @r15+, pr
 *   rts
 *   mov r4, r0             ; delay slot
 */

extern int ext_func(unsigned short, const char *, void *);

/* Placed by the linker at the exact Daytona CCE addresses so the
 * literal-pool values produced by the compiler match the reference. */
extern unsigned short dat_06039FC8;
extern const char daytona96_str[];     /* 0x06036808 */
extern char ram_06036F58_base;         /* 0x06036F58 */
extern char cnt_06036F37;              /* 0x06036F37 */

int FUN_06000AF8(void) {
    int result;
    result = ext_func(dat_06039FC8, daytona96_str,
                      (void *)&ram_06036F58_base);
    cnt_06036F37 = cnt_06036F37 + 1;
    return result;
}
