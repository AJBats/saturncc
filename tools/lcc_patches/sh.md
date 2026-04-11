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
#define INTVAR  0x00007f00  /* R8..R14                         */
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

/* ireg is sized to 32 because gen.c's askreg() walks a wildcard's
 * register array from index 31 down to 0. On SH-2 we only populate
 * slots 0-15, but the tail slots must be readable (NULL) or the
 * allocator dereferences past the end and segfaults. */
static Symbol ireg[32];
static Symbol iregw;
static int tmpregs[] = {1, 2, 3};
static int cseg;
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

reg:  CNSTI1  "# zero\n"  range(a, 0, 0)
reg:  CNSTI2  "# zero\n"  range(a, 0, 0)
reg:  CNSTI4  "# zero\n"  range(a, 0, 0)
reg:  CNSTU1  "# zero\n"  range(a, 0, 0)
reg:  CNSTU2  "# zero\n"  range(a, 0, 0)
reg:  CNSTU4  "# zero\n"  range(a, 0, 0)
reg:  CNSTP4  "# zero\n"  range(a, 0, 0)

reg:  CNSTI1  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTI2  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTI4  "\tmov\t#%a,r%c\n"  range(a, -128, 127)
reg:  CNSTU1  "\tmov\t#%a,r%c\n"  range(a, 0, 127)
reg:  CNSTU2  "\tmov\t#%a,r%c\n"  range(a, 0, 127)
reg:  CNSTU4  "\tmov\t#%a,r%c\n"  range(a, 0, 127)

addr: ADDRGP4  "%a"
addr: ADDRFP4  "%a+%F,r14"
addr: ADDRLP4  "%a+%F,r15"

reg:  ADDRGP4  "\tmov.l\t.L_%a,r%c\n"  2
reg:  ADDRFP4  "\tmov\tr14,r%c\n\tadd\t#%a+%F,r%c\n"  3
reg:  ADDRLP4  "\tmov\tr15,r%c\n\tadd\t#%a+%F,r%c\n"  3

reg:  ADDI4(reg,reg)  "\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  2
reg:  ADDU4(reg,reg)  "\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  2
reg:  ADDP4(reg,reg)  "\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  2

reg:  SUBI4(reg,reg)  "\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  2
reg:  SUBU4(reg,reg)  "\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  2
reg:  SUBP4(reg,reg)  "\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  2

reg:  BANDI4(reg,reg)  "\tmov\tr%0,r%c\n\tand\tr%1,r%c\n"  2
reg:  BANDU4(reg,reg)  "\tmov\tr%0,r%c\n\tand\tr%1,r%c\n"  2
reg:  BORI4(reg,reg)   "\tmov\tr%0,r%c\n\tor\tr%1,r%c\n"   2
reg:  BORU4(reg,reg)   "\tmov\tr%0,r%c\n\tor\tr%1,r%c\n"   2
reg:  BXORI4(reg,reg)  "\tmov\tr%0,r%c\n\txor\tr%1,r%c\n"  2
reg:  BXORU4(reg,reg)  "\tmov\tr%0,r%c\n\txor\tr%1,r%c\n"  2

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

stmt: ASGNI1(reg,reg)  "\tmov.b\tr%1,@r%0\n"  1
stmt: ASGNU1(reg,reg)  "\tmov.b\tr%1,@r%0\n"  1
stmt: ASGNI2(reg,reg)  "\tmov.w\tr%1,@r%0\n"  1
stmt: ASGNU2(reg,reg)  "\tmov.w\tr%1,@r%0\n"  1
stmt: ASGNI4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1
stmt: ASGNU4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1
stmt: ASGNP4(reg,reg)  "\tmov.l\tr%1,@r%0\n"  1

reg:  CVII4(reg)  "\texts.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVII4(reg)  "\texts.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)

stmt: LABELV  "%a:\n"
stmt: JUMPV(addr)  "\tbra\t%0\n\tnop\n"  2

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

ar:   ADDRGP4  "%a"

reg:  CALLI4(ar)  "\tbsr\t%0\n\tnop\n"  2
reg:  CALLU4(ar)  "\tbsr\t%0\n\tnop\n"  2
reg:  CALLP4(ar)  "\tbsr\t%0\n\tnop\n"  2
stmt: CALLV(ar)   "\tbsr\t%0\n\tnop\n"  2

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
static void progend(void) {}

static void progbeg(int argc, char *argv[]) {
        int i;
        {
                union { char c; int i; } u;
                u.i = 0; u.c = 1;
                swap = ((int)(u.i == 1)) != IR->little_endian;
        }
        parseflags(argc, argv);
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
        case CNST+I: case CNST+U: case CNST+P:
                if (range(p, 0, 0) == 0) {
                        setreg(p, ireg[0]);
                        p->x.registered = 1;
                }
                break;
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

static void emit2(Node p) {}

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

static void function(Symbol f, Symbol caller[], Symbol callee[], int ncalls) {
        int i, saved;
        Symbol r, argregs[4];

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
                } else if (askregvar(p, rmap(ttob(p->type)))
                           && r != NULL
                           && (isint(p->type) || p->type == q->type)) {
                        p->sclass = q->sclass = REGISTER;
                        q->type = p->type;
                }
        }
        assert(!caller[i]);
        offset = 0;
        gencode(caller, callee);

        /* Restrict to callee-saved mask. */
        usedmask[IREG] &= INTVAR;
        maxargoffset = roundup(maxargoffset, 4);
        framesize = roundup(maxargoffset + maxoffset, 4);

        segment(CODE);
        print("\t.align 2\n");
        print("%s:\n", f->x.name);

        /* Hitachi descending callee-saved push order: r14, r13, ..., r8. */
        saved = 0;
        if (ncalls) {
                print("\tsts.l\tpr,@-r15\n");
                saved += 4;
        }
        for (i = 14; i >= 8; i--) {
                if (usedmask[IREG] & (1u << i)) {
                        print("\tmov.l\tr%d,@-r15\n", i);
                        saved += 4;
                }
        }
        if (framesize > 0)
                print("\tadd\t#%d,r15\n", -framesize);

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

        /* Epilogue: restore in ascending order. */
        if (framesize > 0)
                print("\tadd\t#%d,r15\n", framesize);
        for (i = 8; i <= 14; i++) {
                if (usedmask[IREG] & (1u << i)) {
                        print("\tmov.l\t@r15+,r%d\n", i);
                }
        }
        if (ncalls)
                print("\tlds.l\t@r15+,pr\n");
        print("\trts\n");
        print("\tnop\n");
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
        case CODE: print("\t.text\n");  break;
        case DATA: print("\t.data\n");  break;
        case BSS:  print("\t.bss\n");   break;
        case LIT:  print("\t.rdata\n"); break;
        }
}

static void space(int n) {
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
