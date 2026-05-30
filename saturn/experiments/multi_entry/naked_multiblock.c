/* Naked multi-block asm function with an inline __entry_alias__ marker.
 *
 * Demonstrates the feature added on feature/naked-multiblock:
 *   - `__naked__` suppresses the synthetic return so a compound body
 *     made of multiple `asm { ... }` statements lowers to an all-
 *     ASM_INSN+V code list and emits via the SH-2 naked-shim fast path
 *     (no prologue/epilogue/synthetic return).
 *   - inline `__entry_alias__(NAME)` between the two asm blocks emits
 *     `.global NAME` + `NAME:` immediately before the second block's
 *     first instruction — its position IS the entry offset.
 *
 * Shape mirrors NTI Pattern A (mid-prologue entry): FUN_outer pushes
 * extra registers, falls through into FUN_inner which is the shared
 * mid-entry. Both run forward through the shared tail and `rts`.
 */
void FUN_outer(void) __naked__ {
    asm {
        mov.l   r14,@-r15
        mov.l   r13,@-r15
    }
    __entry_alias__(FUN_inner);
    asm {
        sts.l   pr,@-r15
        mov.l   LP0,r3
        jsr     @r3
        nop
        lds.l   @r15+,pr
        mov.l   @r15+,r13
        rts
        mov.l   @r15+,r14
LP0:    .long   _shared_target
    }
}
