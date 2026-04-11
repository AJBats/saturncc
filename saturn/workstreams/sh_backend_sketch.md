/* sh_sketch.md — minimal Hitachi-style SH-2 backend sketch for LCC 4.2
 *
 * This is NOT a complete backend. It's a proof-of-concept showing how the
 * shape of a Hitachi-style SH-2 backend would look in lburg syntax. About
 * 30 rules covering the bare minimum:
 *
 *   - Integer load/store (mov.l, mov.w, mov.b)
 *   - Register-to-register add/sub
 *   - Register-to-register mov
 *   - Immediate add (add #imm, Rn)
 *   - Return
 *
 * Not implemented here:
 *   - Function prologue/epilogue (goes in the trailing C section)
 *   - Calls and argument passing
 *   - GBR addressing (#pragma gbr_base) — needs a separate nonterminal
 *   - Multiply, divide, shifts, logical ops
 *   - Float
 *   - Control flow (branches, jumps, labels)
 *   - Delay slot filling
 *
 * Purpose: demonstrate that the lburg rules we'd need to write are
 * roughly the shape we imagine and the cost is tractable.
 */

%{
#include "c.h"

#define NODEPTR_TYPE Node
#define OP_LABEL(p) ((p)->op)
#define LEFT_CHILD(p) ((p)->kids[0])
#define RIGHT_CHILD(p) ((p)->kids[1])
#define STATE_LABEL(p) ((p)->x.state)

/* SH-2 has 16 general purpose registers r0-r15.
 * r15 is stack pointer.
 * r14 is frame pointer (Hitachi convention).
 * r4-r7 are the first 4 parameters (per v2.0/v5.0 manuals).
 * r0 is return value.
 * r0-r7 are caller-saved.
 * r8-r14 are callee-saved (Hitachi saves in descending order r14->r13->r12...).
 */
%}

%start stmt

/* --- Token declarations (subset; real backend declares all DAG ops) --- */
/* For this sketch we declare only what the rules below use. */
/* In real lburg these come from ops.h and match the integer codes. */
%term ADDRFP4=4215
%term ADDRLP4=4231
%term ADDRGP4=4247
%term ADDI4=4401
%term SUBI4=4417
%term INDIRI1=1121
%term INDIRI2=2145
%term INDIRI4=4177
%term ASGNI1=1077
%term ASGNI2=2101
%term ASGNI4=4149
%term CNSTI4=4117
%term RETI4=4213
%term VREGP=711

%%

/* ---- Constants ---- */
con:     CNSTI4                "%a"
rc:      con                   "#%0"      /* immediate form for add */
rc:      reg                   "r%0"      /* register form */

/* ---- Address nonterminal ----
 * We need multiple shapes of address:
 *   @Rn                -- register indirect (baseline)
 *   @(disp, Rn)        -- displacement mode; only if disp fits:
 *                           .b: 0..15, .w: 0..30, .l: 0..60
 *   @(r0, Rn)          -- indexed mode (used when disp doesn't fit)
 *   @(disp, gbr)       -- GBR-relative (for #pragma gbr_base)
 *
 * This sketch only shows indirect and displacement.
 */

addr:    reg                   "@r%0"
/* addr:    ADDI4(reg,con)        "@(%1,r%0)" range(a,0,60) */  /* real rule with cost guard */

/* ---- Simple loads ----
 * Hitachi: mov.b/w/l @addr,rn — dest register must be r0 for disp-mode byte/word.
 * Real backend adds rule variants per size/constraint.
 */

reg:     INDIRI1(addr)          "mov.b %0,r%c\n"         1
reg:     INDIRI2(addr)          "mov.w %0,r%c\n"         1
reg:     INDIRI4(addr)          "mov.l %0,r%c\n"         1

/* ---- Simple stores ---- */
stmt:    ASGNI1(addr,reg)       "mov.b r%1,%0\n"         1
stmt:    ASGNI2(addr,reg)       "mov.w r%1,%0\n"         1
stmt:    ASGNI4(addr,reg)       "mov.l r%1,%0\n"         1

/* ---- Integer arithmetic ----
 * SH-2 add/sub are 2-operand: add rm,rn  means rn = rn + rm.
 * This forces a "move then add" pattern for result != operand.
 * The register allocator handles this via move-coalescing.
 */

reg:     ADDI4(reg,reg)         "add r%1,r%c\n"          1
reg:     SUBI4(reg,reg)         "sub r%1,r%c\n"          1

/* Immediate add: add #imm,rn -- only if imm fits signed 8-bit */
/* Real backend uses a range-guarded cost: */
/* reg: ADDI4(reg,con)          "add #%1,r%c\n"          range(a,-128,127) */

/* ---- Move (register copy) ---- */
reg:     ADDRFP4                "mov r14,r%c ; add #%a,r%c\n"   2   /* frame-relative address */

/* ---- Return ---- */
stmt:    RETI4(reg)             "mov r%0,r0\n"           1
/* Actual rts is emitted by the function epilogue in the trailing C section */

%%

/* ---- Trailing C section ----
 * Real backend implements:
 *   - progbeg/progend    -- output file header/footer
 *   - segment            -- .text/.data/.bss section switching
 *   - defsymbol/local/global -- variable declarations
 *   - function           -- emit prologue/epilogue around the body
 *   - address            -- address-of-variable helpers
 *   - doarg              -- argument passing
 *   - target             -- instruction selection hints
 *   - clobber            -- register clobbering
 *   - emit2              -- post-process emitted code
 *   - defaddress/defconst/defstring -- data definitions
 *
 * This sketch omits all of it. A full Hitachi-style backend would:
 *
 * 1. function():
 *    - Save callee-saved registers in DESCENDING order (r14, r13, r12, r11,
 *      r10, r9, r8) — Hitachi signature, matches 101 production prologues.
 *      Actually saved registers are chosen by the register allocator based
 *      on which ones the function actually uses.
 *    - Save pr via `sts.l pr, @-r15` for non-leaf functions.
 *    - Set up frame: `add #-N, r15` to allocate stack, no explicit frame
 *      pointer unless address-of-local forces it.
 *
 * 2. Epilogue:
 *    - Restore saved callee-saved registers in ASCENDING order (r8, r9, ...).
 *    - Restore pr via `lds.l @r15+, pr`.
 *    - Deallocate frame: `add #N, r15`.
 *    - Emit `rts` and a delay-slot instruction (the last useful one gets
 *      pulled into the slot by a peephole pass).
 *
 * 3. Hitachi pragmas:
 *    - #pragma interrupt -- emit rte instead of rts, save GBR+MAC+SR
 *    - #pragma gbr_base -- place in $G0 section, emit mov.? @(disp, gbr)
 *    - #pragma section -- override P/C/D/B default section names
 *    - #pragma inline_asm -- embed raw asm
 *    - #pragma global_register -- dedicate a register to a variable
 *
 * 4. Intrinsic functions (from <machine.h>):
 *    - set_cr/get_cr, set_imask/get_imask, set_vbr/get_vbr, set_gbr/get_gbr
 *    - gbr_read_byte/word/long, gbr_write_byte/word/long,
 *      gbr_and/or/xor/tst_byte
 *    - sleep, tas, trapa, macl
 *    All map to specific SH-2 instructions inlined at the call site.
 *
 * 5. Section naming:
 *    - Default P/C/D/B.
 *    - Sega override to SEGA_P/SEGA_C/SEGA_D/SEGA_B via -section flag.
 *    - #pragma gbr_base allocates to $G0 / $G1.
 */
