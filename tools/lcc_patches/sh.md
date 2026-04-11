%{
/* sh.md - Hitachi-style SH-2 backend for LCC v4.2 (SaturnCompiler).
 *
 * Phase 1B: minimal lburg grammar. Goal is to compile
 *     int add(int a, int b) { return a + b; }
 * to something assemblable by sh-elf-as. Many ops are stubbed with
 * placeholder templates; Phase 1C will flesh out the full ISA.
 *
 * Register model (SH-2, Hitachi ABI):
 *   R0          return value, scratch
 *   R1-R3       caller-saved scratch
 *   R4-R7       first four args in / caller-saved
 *   R8-R13      callee-saved
 *   R14         frame pointer (callee-saved, Hitachi style)
 *   R15         stack pointer
 *   PR          procedure return (link register)
 *
 * Callee-saved save order is DESCENDING (r14 -> r13 -> ... -> r8),
 * matching Hitachi SHC output. Restore order ascends.
 */
#include "c.h"
#define NODEPTR_TYPE Node
#define OP_LABEL(p) ((p)->op)
#define LEFT_CHILD(p) ((p)->kids[0])
#define RIGHT_CHILD(p) ((p)->kids[1])
#define STATE_LABEL(p) ((p)->x.state)

/* Register allocation masks.
 * Bit i corresponds to register Ri.
 *
 * R0 is the return register; kept out of the normal pool and
 * targeted explicitly via rtarget(RET, ...) / setreg(CALL, ...).
 * R1-R3 are caller-saved scratch and live in INTTMP.
 * R4-R7 are argument registers; pinned via askregvar during function()
 * and NOT included in the allocator's free pool.
 * R8-R14 are callee-saved and live in INTVAR; the prologue saves the
 * subset actually used, in descending order (Hitachi style).
 * R15 is the stack pointer.
 */
#define INTTMP  0x0000000e  /* R1..R3                          */
#define INTVAR  0x00003f00  /* R8..R13 (R14 reserved for FP)   */
#define INTRET  0x00000001  /* R0                              */

static void address(Symbol, Symbol, long);
static void blkfetch(int, int, int, int);
static void blkloop(int, int, int, int, int, int[]);
static void blkstore(int, int, int, int);
static void defaddress(Symbol);
static void defconst(int, int, Value);
static void defstring(int, char *);
static void defsymbol(Symbol);
static void doarg(Node);
static void emit2(Node);
static void export(Symbol);
static void clobber(Node);
static void function(Symbol, Symbol[], Symbol[], int);
static void global(Symbol);
static void import(Symbol);
static void local(Symbol);
static void progbeg(int, char **);
static void progend(void);
static void segment(int);
static void space(int);
static void target(Node);
static Symbol argreg(int);
static void sh_pragma(char *name);

extern void (*shc_pragma_hook)(char *name);

/* ireg is sized to 32 because gen.c's askreg() walks a wildcard's
 * register array from index 31 down to 0. On SH-2 we only populate
 * slots 0-15, but the tail slots must be readable (NULL) or the
 * allocator dereferences past the end and segfaults. */
static Symbol ireg[32];
static Symbol iregw;
static int tmpregs[] = {1, 2, 3};
static int cseg;

/* Frame metrics made visible to emit2() after function() has run
 * gencode(). The direct `mov.l @(disp,Rn),Rm` rules for ADDRFP4 and
 * ADDRLP4 need the sizeisave/localsize values to turn an LCC offset
 * into an r14- or r15-relative displacement. */
static int sh_sizeisave;
static int sh_localsize;

/* Literal pool: per-function table of 32-bit constants and symbol
 * addresses that can't be loaded with an inline 8-bit immediate.
 * Each entry gets a generated label; emit2() prints a
 * `mov.l @(disp,PC),Rn` that references the label, and function()
 * dumps the pool after the epilogue so forward PC-relative
 * displacements resolve.
 *
 * SH-2's mov.l @(disp,PC),Rn reaches (PC+4)+4*disp with an 8-bit
 * unsigned disp, so the pool must sit within ~1020 bytes of the
 * furthest load that references it. For short functions dumping once
 * at the tail is fine; long functions that overflow the range are a
 * Phase 1C+ problem. */
#define SH_MAX_LITERALS 64

struct shlit {
        int label;
        int is_symbol;          /* 0 = numeric, 1 = symbol name */
        int value;
        char *name;
};
static struct shlit shlits[SH_MAX_LITERALS];
static int nshlit;

static int shlit_num(int val);
static int shlit_sym(char *name);
static void shlit_flush(void);

/* GBR-relative addressing pool.
 *
 * Hitachi SHC's `#pragma gbr_base (name)` directive declares a
 * specific global as the origin of a GBR-reachable pool. Globals
 * that land in the same pool are then accessed with
 * `mov.? @(disp,GBR),R0` (opcodes C000/C100/C200 for stores and
 * C400/C500/C600 for loads), where disp is the byte offset from the
 * base. This is a Hitachi signature feature — no other SH compiler
 * emits it automatically, and reproducing it is the single most
 * important hurdle between us and byte-matching Daytona CCE.
 *
 * Phase 1C MVP: we skip real pragma parsing and instead take the
 * gbr base name from a command-line flag `-gbr-base=NAME`. When set,
 * we treat every non-function global that goes through global() as
 * a member of the pool, emit them all into a single `.gbr_data`
 * section with explicit layout (not .comm), and lower loads and
 * stores of those globals as GBR-relative instructions whose
 * displacement is the assembly-time expression `_sym-_base`. The
 * assembler can evaluate this to a constant because both symbols
 * live in the same section.
 *
 * Phase 2 will wire this to a real #pragma gbr_base parser and
 * handle cross-TU references, linker layout, and the sizeof-aware
 * opcode selection Hitachi does for auto-sized GBR access. */
/* Large "never pick me" cost used in composite GBR rule predicates.
 * lburg stores costs in a signed short and computes rule cost as
 * sum-of-child-costs + predicate, so using LBURG_MAX (== SHRT_MAX)
 * here overflows into a negative number that looks cheapest. 30000
 * is large enough to dominate any real sum but leaves headroom. */
#define SH_GBR_REJECT 30000
#define SH_MAX_GBR 256
static char *gbr_base_cname;
static char gbr_base_asmbuf[258];

struct shgbr {
        char *cname;
        char *asmname;
        int size;
        int align;
};
static struct shgbr gbr_pool[SH_MAX_GBR];
static int ngbr_pool;

static int gbr_is_eligible(Node p);
static char *gbr_base_asmname(void);
%}
%start stmt

%term CNSTF4=4113
%term CNSTF8=8209
%term CNSTI1=1045
%term CNSTI2=2069
%term CNSTI4=4117
%term CNSTP4=4119
%term CNSTU1=1046
%term CNSTU2=2070
%term CNSTU4=4118

%term ARGB=41
%term ARGF4=4129
%term ARGF8=8225
%term ARGI4=4133
%term ARGP4=4135
%term ARGU4=4134

%term ASGNB=57
%term ASGNF4=4145
%term ASGNF8=8241
%term ASGNI1=1077
%term ASGNI2=2101
%term ASGNI4=4149
%term ASGNP4=4151
%term ASGNU1=1078
%term ASGNU2=2102
%term ASGNU4=4150

%term INDIRB=73
%term INDIRF4=4161
%term INDIRF8=8257
%term INDIRI1=1093
%term INDIRI2=2117
%term INDIRI4=4165
%term INDIRP4=4167
%term INDIRU1=1094
%term INDIRU2=2118
%term INDIRU4=4166

%term CVFF4=4209
%term CVFF8=8305
%term CVFI4=4213
%term CVIF4=4225
%term CVIF8=8321
%term CVII1=1157
%term CVII2=2181
%term CVII4=4229
%term CVIU1=1158
%term CVIU2=2182
%term CVIU4=4230
%term CVPP4=4247
%term CVPU4=4246
%term CVUI1=1205
%term CVUI2=2229
%term CVUI4=4277
%term CVUP4=4279
%term CVUU1=1206
%term CVUU2=2230
%term CVUU4=4278

%term NEGF4=4289
%term NEGF8=8385
%term NEGI4=4293

%term CALLB=217
%term CALLF4=4305
%term CALLF8=8401
%term CALLI4=4309
%term CALLP4=4311
%term CALLU4=4310
%term CALLV=216

%term RETF4=4337
%term RETF8=8433
%term RETI4=4341
%term RETP4=4343
%term RETU4=4342
%term RETV=248

%term ADDRGP4=4359
%term ADDRFP4=4375
%term ADDRLP4=4391

%term ADDF4=4401
%term ADDF8=8497
%term ADDI4=4405
%term ADDP4=4407
%term ADDU4=4406

%term SUBF4=4417
%term SUBF8=8513
%term SUBI4=4421
%term SUBP4=4423
%term SUBU4=4422

%term LSHI4=4437
%term LSHU4=4438

%term MODI4=4453
%term MODU4=4454

%term RSHI4=4469
%term RSHU4=4470

%term BANDI4=4485
%term BANDU4=4486

%term BCOMI4=4501
%term BCOMU4=4502

%term BORI4=4517
%term BORU4=4518

%term BXORI4=4533
%term BXORU4=4534

%term DIVF4=4545
%term DIVF8=8641
%term DIVI4=4549
%term DIVU4=4550

%term MULF4=4561
%term MULF8=8657
%term MULI4=4565
%term MULU4=4566

%term EQF4=4577
%term EQF8=8673
%term EQI4=4581
%term EQU4=4582

%term GEF4=4593
%term GEF8=8689
%term GEI4=4597
%term GEU4=4598

%term GTF4=4609
%term GTF8=8705
%term GTI4=4613
%term GTU4=4614

%term LEF4=4625
%term LEF8=8721
%term LEI4=4629
%term LEU4=4630

%term LTF4=4641
%term LTF8=8737
%term LTI4=4645
%term LTU4=4646

%term NEF4=4657
%term NEF8=8753
%term NEI4=4661
%term NEU4=4662

%term JUMPV=584

%term LABELV=600

%term LOADB=233
%term LOADF4=4321
%term LOADF8=8417
%term LOADI1=1253
%term LOADI2=2277
%term LOADI4=4325
%term LOADP4=4327
%term LOADU1=1254
%term LOADU2=2278
%term LOADU4=4326

%term VREGP=711
%%

stmt: reg    ""

reg:  INDIRI1(VREGP)  "# read register\n"
reg:  INDIRU1(VREGP)  "# read register\n"
reg:  INDIRI2(VREGP)  "# read register\n"
reg:  INDIRU2(VREGP)  "# read register\n"
reg:  INDIRI4(VREGP)  "# read register\n"
reg:  INDIRU4(VREGP)  "# read register\n"
reg:  INDIRP4(VREGP)  "# read register\n"

stmt: ASGNI1(VREGP,reg)  "# write register\n"
stmt: ASGNU1(VREGP,reg)  "# write register\n"
stmt: ASGNI2(VREGP,reg)  "# write register\n"
stmt: ASGNU2(VREGP,reg)  "# write register\n"
stmt: ASGNI4(VREGP,reg)  "# write register\n"
stmt: ASGNU4(VREGP,reg)  "# write register\n"
stmt: ASGNP4(VREGP,reg)  "# write register\n"

reg:  CNSTI1  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTI2  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTI4  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTU1  "\tmov\t#%a,r%c\n"  range(a, 0, 127)
reg:  CNSTU2  "\tmov\t#%a,r%c\n"  range(a, 0, 127)
reg:  CNSTU4  "\tmov\t#%a,r%c\n"  range(a, 0, 127)

reg:  CNSTI4  "# large const\n"  2
reg:  CNSTU4  "# large const\n"  2
reg:  CNSTP4  "# large const\n"  2

reg:  ADDRGP4  "# addrg\n"  2

reg:  ADDRFP4  "\tmov\tr14,r%c\n\tadd\t#%a+%F,r%c\n"  2
reg:  ADDRLP4  "\tmov\tr14,r%c\n\tadd\t#%a,r%c\n"     2

reg:  INDIRI4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRU4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRP4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRI4(ADDRLP4)  "# lpload_l\n"  1
reg:  INDIRU4(ADDRLP4)  "# lpload_l\n"  1
reg:  INDIRP4(ADDRLP4)  "# lpload_l\n"  1

stmt: ASGNI4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNU4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNP4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNI4(ADDRLP4,reg)  "# lpstore_l\n"  1
stmt: ASGNU4(ADDRLP4,reg)  "# lpstore_l\n"  1
stmt: ASGNP4(ADDRLP4,reg)  "# lpstore_l\n"  1

reg:  ADDI4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1
reg:  ADDU4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1
reg:  ADDP4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1

reg:  SUBI4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1
reg:  SUBU4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1
reg:  SUBP4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1

reg:  BANDI4(reg,reg)  "?\tmov\tr%0,r%c\n\tand\tr%1,r%c\n"  1
reg:  BANDU4(reg,reg)  "?\tmov\tr%0,r%c\n\tand\tr%1,r%c\n"  1
reg:  BORI4(reg,reg)   "?\tmov\tr%0,r%c\n\tor\tr%1,r%c\n"   1
reg:  BORU4(reg,reg)   "?\tmov\tr%0,r%c\n\tor\tr%1,r%c\n"   1
reg:  BXORI4(reg,reg)  "?\tmov\tr%0,r%c\n\txor\tr%1,r%c\n"  1
reg:  BXORU4(reg,reg)  "?\tmov\tr%0,r%c\n\txor\tr%1,r%c\n"  1

reg:  BCOMI4(reg)  "\tnot\tr%0,r%c\n"  1
reg:  BCOMU4(reg)  "\tnot\tr%0,r%c\n"  1
reg:  NEGI4(reg)   "\tneg\tr%0,r%c\n"  1

reg:  LOADI1(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADU1(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADI2(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADU2(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADI4(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADU4(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADP4(reg)  "\tmov\tr%0,r%c\n"  move(a)

reg:  INDIRI1(reg)  "\tmov.b\t@r%0,r%c\n\textu.b\tr%c,r%c\n"  2
reg:  INDIRU1(reg)  "\tmov.b\t@r%0,r%c\n\textu.b\tr%c,r%c\n"  2
reg:  INDIRI2(reg)  "\tmov.w\t@r%0,r%c\n"  1
reg:  INDIRU2(reg)  "\tmov.w\t@r%0,r%c\n"  1
reg:  INDIRI4(reg)  "\tmov.l\t@r%0,r%c\n"  1
reg:  INDIRU4(reg)  "\tmov.l\t@r%0,r%c\n"  1
reg:  INDIRP4(reg)  "\tmov.l\t@r%0,r%c\n"  1

reg:  INDIRI1(ADDRGP4)  "# gbr_load_b\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRU1(ADDRGP4)  "# gbr_load_b\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRI2(ADDRGP4)  "# gbr_load_w\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRU2(ADDRGP4)  "# gbr_load_w\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRI4(ADDRGP4)  "# gbr_load_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRU4(ADDRGP4)  "# gbr_load_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
reg:  INDIRP4(ADDRGP4)  "# gbr_load_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)

stmt: ASGNI1(reg,reg)  "\tmov.b\tr%1,@r%0\n"  1
stmt: ASGNU1(reg,reg)  "\tmov.b\tr%1,@r%0\n"  1
stmt: ASGNI2(reg,reg)  "\tmov.w\tr%1,@r%0\n"  1
stmt: ASGNU2(reg,reg)  "\tmov.w\tr%1,@r%0\n"  1
stmt: ASGNI4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1
stmt: ASGNU4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1
stmt: ASGNP4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1

stmt: ASGNI1(ADDRGP4,reg)  "# gbr_store_b\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNU1(ADDRGP4,reg)  "# gbr_store_b\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNI2(ADDRGP4,reg)  "# gbr_store_w\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNU2(ADDRGP4,reg)  "# gbr_store_w\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNI4(ADDRGP4,reg)  "# gbr_store_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNU4(ADDRGP4,reg)  "# gbr_store_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)
stmt: ASGNP4(ADDRGP4,reg)  "# gbr_store_l\n"  (gbr_is_eligible(a->kids[0]) ? 1 : SH_GBR_REJECT)

reg:  CVII4(reg)  "\texts.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVII4(reg)  "\texts.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)

stmt: LABELV  "%a:\n"

jtarget: ADDRGP4  "%a"
stmt: JUMPV(jtarget)  "\tbra\t%0\n\tnop\n"  2

stmt: EQI4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbt\t%a\n"  2
stmt: EQU4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbt\t%a\n"  2
stmt: NEI4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbf\t%a\n"  2
stmt: NEU4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbf\t%a\n"  2
stmt: LTI4(reg,reg)  "\tcmp/gt\tr%0,r%1\n\tbt\t%a\n"  2
stmt: LEI4(reg,reg)  "\tcmp/ge\tr%0,r%1\n\tbt\t%a\n"  2
stmt: GTI4(reg,reg)  "\tcmp/gt\tr%1,r%0\n\tbt\t%a\n"  2
stmt: GEI4(reg,reg)  "\tcmp/ge\tr%1,r%0\n\tbt\t%a\n"  2
stmt: LTU4(reg,reg)  "\tcmp/hi\tr%0,r%1\n\tbt\t%a\n"  2
stmt: LEU4(reg,reg)  "\tcmp/hs\tr%0,r%1\n\tbt\t%a\n"  2
stmt: GTU4(reg,reg)  "\tcmp/hi\tr%1,r%0\n\tbt\t%a\n"  2
stmt: GEU4(reg,reg)  "\tcmp/hs\tr%1,r%0\n\tbt\t%a\n"  2

reg:  CALLI4(reg)  "\tjsr\t@r%0\n\tnop\n"  3
reg:  CALLU4(reg)  "\tjsr\t@r%0\n\tnop\n"  3
reg:  CALLP4(reg)  "\tjsr\t@r%0\n\tnop\n"  3
stmt: CALLV(reg)   "\tjsr\t@r%0\n\tnop\n"  3

stmt: RETI4(reg)  "# ret\n"  1
stmt: RETU4(reg)  "# ret\n"  1
stmt: RETP4(reg)  "# ret\n"  1
stmt: RETV(reg)   "# ret\n"  1

stmt: ARGI4(reg)  "# arg\n"  1
stmt: ARGU4(reg)  "# arg\n"  1
stmt: ARGP4(reg)  "# arg\n"  1

stmt: ARGB(INDIRB(reg))       "# argb %0\n"      1
stmt: ASGNB(reg,INDIRB(reg))  "# asgnb %0 %1\n"  1

%%
static int shlit_num(int val) {
        int i;
        for (i = 0; i < nshlit; i++)
                if (!shlits[i].is_symbol && shlits[i].value == val)
                        return shlits[i].label;
        assert(nshlit < SH_MAX_LITERALS);
        shlits[nshlit].label = genlabel(1);
        shlits[nshlit].is_symbol = 0;
        shlits[nshlit].value = val;
        return shlits[nshlit++].label;
}

static int shlit_sym(char *name) {
        int i;
        for (i = 0; i < nshlit; i++)
                if (shlits[i].is_symbol && strcmp(shlits[i].name, name) == 0)
                        return shlits[i].label;
        assert(nshlit < SH_MAX_LITERALS);
        shlits[nshlit].label = genlabel(1);
        shlits[nshlit].is_symbol = 1;
        shlits[nshlit].name = name;
        return shlits[nshlit++].label;
}

static void shlit_flush(void) {
        int i;
        if (nshlit == 0)
                return;
        print("\t.align 2\n");
        for (i = 0; i < nshlit; i++) {
                if (shlits[i].is_symbol)
                        print("L%d:\t.long\t%s\n",
                              shlits[i].label, shlits[i].name);
                else
                        print("L%d:\t.long\t%d\n",
                              shlits[i].label, shlits[i].value);
        }
        nshlit = 0;
}

static char *gbr_base_asmname(void) {
        if (!gbr_base_cname)
                return NULL;
        if (gbr_base_asmbuf[0] == 0) {
                gbr_base_asmbuf[0] = '_';
                strncpy(gbr_base_asmbuf + 1, gbr_base_cname,
                        sizeof(gbr_base_asmbuf) - 2);
                gbr_base_asmbuf[sizeof(gbr_base_asmbuf) - 1] = 0;
        }
        return gbr_base_asmbuf;
}

static int gbr_is_eligible(Node p) {
        Symbol s;
        if (!gbr_base_cname || !p || !p->syms[0])
                return 0;
        s = p->syms[0];
        if (s->scope != GLOBAL)
                return 0;
        if (isfunc(s->type))
                return 0;
        return 1;
}

/* #pragma handler wired up through the input.c hook. Recognizes
 * `#pragma gbr_base (name)` — the syntax Hitachi SHC uses — and
 * records the identifier as the base symbol for GBR-relative
 * addressing. Unknown pragmas are silently ignored (same behavior
 * as unmodified LCC). */
static void sh_pragma(char *name) {
        if (strcmp(name, "gbr_base") == 0) {
                while (*cp == ' ' || *cp == '\t')
                        cp++;
                if (*cp == '(') {
                        cp++;
                        while (*cp == ' ' || *cp == '\t')
                                cp++;
                }
                if (gettok() == ID)
                        gbr_base_cname = string(token);
        }
}

static int sh_log2_align(int a) {
        switch (a) {
        case 1:  return 0;
        case 2:  return 1;
        case 4:  return 2;
        case 8:  return 3;
        case 16: return 4;
        default: return 2;
        }
}

static void sh_emit_gbr_entry(int i) {
        print("\t.align\t%d\n", sh_log2_align(gbr_pool[i].align));
        print("%s:\n", gbr_pool[i].asmname);
        print("\t.space\t%d\n", gbr_pool[i].size);
}

static void progend(void) {
        int i, base_idx = -1;
        if (ngbr_pool == 0)
                return;
        print("\t.section\t.gbr_data,\"aw\"\n");
        for (i = 0; i < ngbr_pool; i++)
                if (strcmp(gbr_pool[i].cname, gbr_base_cname) == 0) {
                        base_idx = i;
                        break;
                }
        if (base_idx >= 0)
                sh_emit_gbr_entry(base_idx);
        for (i = 0; i < ngbr_pool; i++)
                if (i != base_idx)
                        sh_emit_gbr_entry(i);
}

static void progbeg(int argc, char *argv[]) {
        int i;
        {
                union { char c; int i; } u;
                u.i = 0; u.c = 1;
                swap = ((int)(u.i == 1)) != IR->little_endian;
        }
        parseflags(argc, argv);
        for (i = 0; i < argc; i++)
                if (strncmp(argv[i], "-gbr-base=", 10) == 0)
                        gbr_base_cname = argv[i] + 10;
        shc_pragma_hook = sh_pragma;
        for (i = 0; i < 16; i++)
                ireg[i] = mkreg("%d", i, 1, IREG);
        ireg[15]->x.name = "15";
        iregw = mkwildcard(ireg);
        tmask[IREG] = INTTMP;
        vmask[IREG] = INTVAR;
        tmask[FREG] = 0;
        vmask[FREG] = 0;
}

static Symbol rmap(int opk) {
        switch (optype(opk)) {
        case I: case U: case P: case B:
                return iregw;
        default:
                return 0;
        }
}

static Symbol argreg(int argno) {
        if (argno >= 0 && argno < 4)
                return ireg[4 + argno];
        return NULL;
}

static void target(Node p) {
        assert(p);
        switch (specific(p->op)) {
        case CALL+I: case CALL+P: case CALL+U:
                setreg(p, ireg[0]);
                break;
        case RET+I: case RET+U: case RET+P:
                rtarget(p, 0, ireg[0]);
                break;
        case ARG+I: case ARG+P: case ARG+U: {
                Symbol q = argreg(p->x.argno);
                if (q)
                        rtarget(p, 0, q);
                break;
                }
        }
}

static void clobber(Node p) {
        assert(p);
        switch (specific(p->op)) {
        case CALL+I: case CALL+P: case CALL+U:
                spill(INTTMP & ~INTRET, IREG, p);
                break;
        case CALL+V:
                spill(INTTMP | INTRET, IREG, p);
                break;
        }
}

static void emit2(Node p) {
        int lab, dst, src;
        int sz;
        char *suf;
        Symbol s;
        char *base;
        switch (specific(p->op)) {
        case CNST+I: case CNST+U: case CNST+P:
                lab = shlit_num((int)p->syms[0]->u.c.v.i);
                dst = getregnum(p);
                print("\tmov.l\tL%d,r%d\n", lab, dst);
                break;
        case ADDRG+P:
                lab = shlit_sym(p->syms[0]->x.name);
                dst = getregnum(p);
                print("\tmov.l\tL%d,r%d\n", lab, dst);
                break;
        case INDIR+I: case INDIR+U: case INDIR+P: {
                int disp, off;
                int kop;
                if (!p->kids[0])
                        break;
                kop = generic(p->kids[0]->op);
                s = p->kids[0]->syms[0];
                sz = opsize(p->op);
                dst = getregnum(p);
                if (kop == ADDRG) {
                        suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                        base = gbr_base_asmname();
                        print("\tmov.%s\t@(%s-%s,gbr),r0\n",
                              suf, s->x.name, base);
                        if (sz < 4 && optype(p->op) == I)
                                print("\texts.%s\tr0,r0\n", suf);
                        else if (sz < 4 && optype(p->op) == U)
                                print("\textu.%s\tr0,r0\n", suf);
                        if (dst != 0)
                                print("\tmov\tr0,r%d\n", dst);
                        break;
                }
                /* ADDRFP4 / ADDRLP4 direct-disp load. For ADDRFP4 the
                 * symbol offset is the caller-frame offset and the
                 * instruction base is r14 (FP), disp = offset+sizeisave.
                 * For ADDRLP4 the symbol offset is negative relative
                 * to r14, so we use r15 as the base and disp =
                 * localsize + offset. Both paths only handle mov.l
                 * (disp field scales by 4, fits in 4 bits). */
                off = s ? s->x.offset : 0;
                if (kop == ADDRF) {
                        disp = off + sh_sizeisave;
                        print("\tmov.l\t@(%d,r14),r%d\n", disp, dst);
                } else if (kop == ADDRL) {
                        disp = sh_localsize + off;
                        print("\tmov.l\t@(%d,r15),r%d\n", disp, dst);
                }
                break;
                }
        case ASGN+I: case ASGN+U: case ASGN+P: {
                int disp, off;
                int kop;
                if (!p->kids[0])
                        break;
                kop = generic(p->kids[0]->op);
                s = p->kids[0]->syms[0];
                sz = opsize(p->op);
                src = getregnum(p->kids[1]);
                if (kop == ADDRG) {
                        suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                        base = gbr_base_asmname();
                        if (src != 0)
                                print("\tmov\tr%d,r0\n", src);
                        print("\tmov.%s\tr0,@(%s-%s,gbr)\n",
                              suf, s->x.name, base);
                        break;
                }
                off = s ? s->x.offset : 0;
                if (kop == ADDRF) {
                        disp = off + sh_sizeisave;
                        print("\tmov.l\tr%d,@(%d,r14)\n", src, disp);
                } else if (kop == ADDRL) {
                        disp = sh_localsize + off;
                        print("\tmov.l\tr%d,@(%d,r15)\n", src, disp);
                }
                break;
                }
        case ARG+I: case ARG+U: case ARG+P:
                /* argno 0..3 pass in r4..r7 (handled by target() via
                 * rtarget, so the kid was already loaded into the
                 * right register and this case emits nothing).
                 * argno >= 4 go on the caller's outgoing-arg area at
                 * offset p->syms[2]->u.c.v.i. The offset includes
                 * slots for the register-passed args too, so the
                 * first stack arg is at +16 for int params. */
                if (p->x.argno < 4)
                        break;
                src = getregnum(p->x.kids[0]);
                print("\tmov.l\tr%d,@(%d,r15)\n",
                      src, (int)p->syms[2]->u.c.v.i);
                break;
        }
}

static void doarg(Node p) {
        static int argno;
        if (argoffset == 0)
                argno = 0;
        p->x.argno = argno++;
        p->syms[2] = intconst(mkactual(4, p->syms[0]->u.c.v.i));
}

static void local(Symbol p) {
        if (askregvar(p, rmap(ttob(p->type))) == 0)
                mkauto(p);
}

static int bitcount(unsigned mask) {
        unsigned b;
        int n = 0;
        for (b = 1; b; b <<= 1)
                if (mask & b)
                        n++;
        return n;
}

static void function(Symbol f, Symbol caller[], Symbol callee[], int ncalls) {
        int i, localsize, sizeisave, need_fp;
        Symbol r, argregs[4];

        nshlit = 0;

        usedmask[0] = usedmask[1] = 0;
        freemask[0] = freemask[1] = ~(unsigned)0;
        offset = maxoffset = maxargoffset = 0;

        for (i = 0; callee[i]; i++)
                ;
        for (i = 0; callee[i]; i++) {
                Symbol p = callee[i];
                Symbol q = caller[i];
                assert(q);
                offset = roundup(offset, q->type->align);
                p->x.offset = q->x.offset = offset;
                p->x.name = q->x.name = stringd(offset);
                r = argreg(i);
                if (i < 4)
                        argregs[i] = r;
                offset = roundup(offset + q->type->size, 4);
                if (i < 4 && !isstruct(q->type) && !p->addressed && ncalls == 0) {
                        p->sclass = q->sclass = REGISTER;
                        askregvar(p, r);
                        assert(p->x.regnode && p->x.regnode->vbl == p);
                        q->x = p->x;
                        q->type = p->type;
                } else if (i < 4 && !isstruct(q->type) && !p->addressed) {
                        p->sclass = REGISTER;
                        if (askregvar(p, rmap(ttob(p->type)))) {
                                q->sclass = REGISTER;
                                q->type = p->type;
                        } else {
                                p->sclass = AUTO;
                        }
                }
        }
        assert(!caller[i]);
        offset = 0;
        gencode(caller, callee);

        usedmask[IREG] &= INTVAR;
        maxargoffset = roundup(maxargoffset, 4);
        localsize = roundup(maxargoffset + maxoffset, 4);
        sh_localsize = localsize;

        /* Set up FP whenever we need to reach anything on the stack:
         * locals, spilled params, a PR save, or stack-passed
         * incoming params (callee[i] for i >= 4). Leaf functions
         * that touch nothing but r0-r7 skip the prologue entirely. */
        need_fp = (ncalls || localsize > 0 || usedmask[IREG] != 0
                   || maxargoffset > 0);
        for (i = 0; i < 5 && !need_fp && callee[i]; i++)
                if (i >= 4)
                        need_fp = 1;

        sizeisave = 4 * bitcount(usedmask[IREG]);
        if (need_fp) {
                usedmask[IREG] |= 1u << 14;
                sizeisave = 4 * bitcount(usedmask[IREG]);
                if (ncalls)
                        sizeisave += 4;
        }
        framesize = sizeisave;
        sh_sizeisave = sizeisave;

        segment(CODE);
        print("\t.align 2\n");
        print("%s:\n", f->x.name);

        if (need_fp) {
                /* Hitachi ordering: push r8 first, ..., r14 last,
                 * then PR last of all. After all pushes, r15 points
                 * at the PR slot (or at r14 if no PR). Setting
                 * r14 = r15 makes r14 the frame pointer; addresses
                 * of caller params resolve to r14 + sizeisave + offset,
                 * and addresses of locals resolve to r14 + negative
                 * offset (locals sit below r14 in the reserved area). */
                for (i = 8; i <= 13; i++)
                        if (usedmask[IREG] & (1u << i))
                                print("\tmov.l\tr%d,@-r15\n", i);
                print("\tmov.l\tr14,@-r15\n");
                if (ncalls)
                        print("\tsts.l\tpr,@-r15\n");
                print("\tmov\tr15,r14\n");
                if (localsize > 0)
                        print("\tadd\t#%d,r15\n", -localsize);
        }

        /* Move incoming argument registers to their allocated home. */
        for (i = 0; i < 4 && callee[i]; i++) {
                r = argregs[i];
                if (r && callee[i]->sclass == REGISTER
                    && callee[i]->x.regnode
                    && callee[i]->x.regnode->number != r->x.regnode->number) {
                        print("\tmov\tr%d,r%d\n",
                              r->x.regnode->number,
                              callee[i]->x.regnode->number);
                }
        }

        emitcode();

        /* Epilogue with a minimal delay-slot fill. Collect the pop
         * instructions and use the last one as the rts delay slot
         * when we have at least one — SH-2's rts delay slot executes
         * before PC jumps to PR, and a `mov.l @r15+,rN` post-
         * increment load is a legal delay-slot instruction that
         * doesn't touch PC or branch state. For leaf functions with
         * no pops the delay slot stays a plain nop. */
        if (need_fp) {
                int npops = 0;
                int pop_regs[16];
                int want_pr = ncalls;
                print("\tmov\tr14,r15\n");
                if (want_pr)
                        pop_regs[npops++] = -1;      /* -1 means PR */
                pop_regs[npops++] = 14;
                for (i = 13; i >= 8; i--)
                        if (usedmask[IREG] & (1u << i))
                                pop_regs[npops++] = i;
                /* Emit all pops except the last, then rts, then the
                 * last pop in the delay slot. */
                for (i = 0; i < npops - 1; i++) {
                        if (pop_regs[i] == -1)
                                print("\tlds.l\t@r15+,pr\n");
                        else
                                print("\tmov.l\t@r15+,r%d\n", pop_regs[i]);
                }
                print("\trts\n");
                if (pop_regs[npops - 1] == -1)
                        print("\tlds.l\t@r15+,pr\n");
                else
                        print("\tmov.l\t@r15+,r%d\n",
                              pop_regs[npops - 1]);
        } else {
                print("\trts\n");
                print("\tnop\n");
        }
        shlit_flush();
}

static void defconst(int suffix, int size, Value v) {
        if (suffix == I && size == 1)
                print("\t.byte %d\n", (int)v.i);
        else if (suffix == U && size == 1)
                print("\t.byte %d\n", (unsigned)v.u);
        else if (suffix == I && size == 2)
                print("\t.word %d\n", (int)v.i);
        else if (suffix == U && size == 2)
                print("\t.word %d\n", (unsigned)v.u);
        else if (suffix == I && size == 4)
                print("\t.long %d\n", (int)v.i);
        else if (suffix == U && size == 4)
                print("\t.long %d\n", (unsigned)v.u);
        else if (suffix == P)
                print("\t.long 0x%x\n", (unsigned)v.p);
        else if (suffix == F && size == 4) {
                float f = v.d;
                print("\t.long 0x%x\n", *(unsigned *)&f);
        } else if (suffix == F && size == 8) {
                double d = v.d;
                unsigned *p = (unsigned *)&d;
                print("\t.long 0x%x\n\t.long 0x%x\n", p[swap], p[!swap]);
        }
}

static void defaddress(Symbol p) {
        print("\t.long %s\n", p->x.name);
}

static void defstring(int n, char *str) {
        char *s;
        for (s = str; s < str + n; s++)
                print("\t.byte %d\n", (*s) & 0377);
}

static void export(Symbol p) {
        print("\t.global %s\n", p->x.name);
}

static void import(Symbol p) {}

static void defsymbol(Symbol p) {
        if (p->scope >= LOCAL && p->sclass == STATIC)
                p->x.name = stringf("L%d", genlabel(1));
        else if (p->generated)
                p->x.name = stringf("L%s", p->name);
        else if (p->scope == CONSTANTS)
                p->x.name = p->name;
        else
                p->x.name = stringf("_%s", p->name);
}

static void address(Symbol q, Symbol p, long n) {
        if (p->scope == GLOBAL || p->sclass == STATIC || p->sclass == EXTERN)
                q->x.name = stringf("%s%s%D", p->x.name, n >= 0 ? "+" : "", n);
        else {
                assert(n <= INT_MAX && n >= INT_MIN);
                q->x.offset = p->x.offset + n;
                q->x.name = stringd(q->x.offset);
        }
}

static void global(Symbol p) {
        if (gbr_base_cname && !isfunc(p->type)) {
                /* Buffer the symbol so progend() can emit the whole
                 * .gbr_data section with the base symbol first. We
                 * emit nothing here; the matching space() / defconst()
                 * calls from the front end are also suppressed while
                 * gbr mode is active. Phase 1C MVP only supports
                 * zero-initialized (tentative BSS) gbr globals. */
                if (ngbr_pool < SH_MAX_GBR) {
                        gbr_pool[ngbr_pool].cname = p->name;
                        gbr_pool[ngbr_pool].asmname = p->x.name;
                        gbr_pool[ngbr_pool].size = p->type->size;
                        gbr_pool[ngbr_pool].align = p->type->align;
                        ngbr_pool++;
                }
                return;
        }
        print("\t.align %d\n", p->type->align > 4 ? 4 : p->type->align);
        if (p->u.seg == BSS) {
                if (p->sclass == STATIC)
                        print("\t.lcomm %s,%d\n", p->x.name, p->type->size);
                else
                        print("\t.comm %s,%d\n", p->x.name, p->type->size);
        } else {
                print("%s:\n", p->x.name);
        }
}

static void segment(int n) {
        if (n == cseg)
                return;
        cseg = n;
        switch (n) {
        case CODE: print("\t.text\n");            break;
        case DATA: print("\t.data\n");            break;
        case BSS:  print("\t.section\t.bss\n");   break;
        case LIT:  print("\t.section\t.rodata\n"); break;
        }
}

static void space(int n) {
        /* When gbr mode is on, every global is routed through the
         * deferred pool and the front end's post-global() space()
         * call would otherwise leak into whatever segment we're in.
         * Suppress it; progend() emits the matching space once it
         * lays out the .gbr_data section. */
        if (gbr_base_cname)
                return;
        if (cseg != BSS)
                print("\t.space %d\n", n);
}

static void blkfetch(int size, int off, int reg, int tmp) {}
static void blkstore(int size, int off, int reg, int tmp) {}
static void blkloop(int dreg, int doff, int sreg, int soff, int size, int tmps[]) {}

static void stabinit(char *, int, char *[]);
static void stabline(Coordinate *);
static void stabsym(Symbol);

static void stabinit(char *file, int argc, char *argv[]) {}
static void stabline(Coordinate *cp) {}
static void stabsym(Symbol p) {}

Interface shIR = {
        1, 1, 0,  /* char */
        2, 2, 0,  /* short */
        4, 4, 0,  /* int */
        4, 4, 0,  /* long */
        8, 4, 1,  /* long long */
        4, 4, 1,  /* float */
        8, 4, 1,  /* double */
        8, 4, 1,  /* long double */
        4, 4, 0,  /* T * */
        0, 4, 0,  /* struct */
        0,  /* little_endian */
        0,  /* mulops_calls */
        0,  /* wants_callb */
        1,  /* wants_argb */
        1,  /* left_to_right */
        0,  /* wants_dag */
        0,  /* unsigned_char */
        address,
        blockbeg,
        blockend,
        defaddress,
        defconst,
        defstring,
        defsymbol,
        emit,
        export,
        function,
        gen,
        global,
        import,
        local,
        progbeg,
        progend,
        segment,
        space,
        0, 0, 0, stabinit, stabline, stabsym, 0,
        {
                4,  /* max_unaligned_load */
                rmap,
                blkfetch, blkstore, blkloop,
                _label,
                _rule,
                _nts,
                _kids,
                _string,
                _templates,
                _isinstruction,
                _ntname,
                emit2,
                doarg,
                target,
                clobber,
        }
};
