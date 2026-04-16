/*
 * FUN_06037E28 — race module, first function in a 4-function TU.
 *
 * Reference: D:/Projects/DaytonaCCEReverse/mods/transplant/race/FUN_06037E28.s
 * Ghidra C:  D:/Projects/DaytonaCCEReverse/ghidra_reference/race/FUN_06037E28.c
 */

extern void setup_func(void);
extern void sub_06037ED4(int);
extern void sub_06037EA4(void);

/* Gap 0: DAT externs → compile-time literals.
 *
 * In the Ghidra decomp, these appear as `extern` variables whose address
 * is the DAT's pool address.  In prod, SHC encoded them as pool literals
 * inside the function body: short masks/offsets as `.L_wpool_XXXX`
 * entries, int/pointer values as `.L_pool_XXXX` 4-byte entries.
 *
 * Declaring as extern forces two loads (pool_addr → value); #define
 * collapses to one (pool holds the literal directly). */
#define dat_060540B4 (*((char *)0x060540B4))
#define base_array   (0x0605224C)

/* Switch body externals — function pointers loaded pre-switch */
extern void sub_06037ED8(int *);      /* puVar2 */
extern void sub_06037EDC(int *);      /* puVar3 */
extern void sub_06037EE0(int, int *); /* puVar4 */
extern void sub_06037EE4(int, int *, int, int); /* puVar5 / render */
extern void sub_0603814C(int *);      /* puVar6 */

extern void FUN_06038dd8(int *);
extern void FUN_060384c4(int *);
extern void func_06038a82(int *);
extern void func_060385ce(int *);
extern void func_060386d8(int *);
extern void FUN_06038c64(int *);
extern void func_06038bc4(int *);

/* Case 0/1 externals */
extern void sub_06038014(int *);
extern void sub_06038018(int *);
extern void sub_0603801C(int *);
extern void sub_06038020(int *);
extern void sub_06038024(int *);
extern void sub_06038028(int *);

/* Case 3 externals */
extern void sub_06038150(int *);
extern void sub_06038154(int *);
extern void sub_06038158(int *);
extern void sub_0603815C(int *);

/* Case 4/5 externals */
extern void sub_06038160(int *);
extern void sub_06038260(int);
extern void sub_06038264(int *);
extern void sub_06038268(int *);
extern void sub_0603826C(int *);
extern void sub_06038270(int *);

/* Case 6/7 externals */
extern void sub_06038274(int *);
extern void sub_06038384(int);
extern void sub_06038388(int *);
extern void sub_0603838C(int *);
extern void sub_06038390(int *);
extern void sub_06038394(int *);

/* Case 9 externals */
extern void sub_06038398(int *);

/* Post-switch externals */
extern void sub_060384B4(int *);

/* Case-specific data — short masks (prod wpool literals) */
#define dat_0603800C ((short)0xFFFD)
#define dat_0603800E ((short)0xFFFE)
#define dat_06038010 ((short)0x7FFF)
#define dat_0603813E ((short)0xFFFD)
#define dat_06038140 ((short)0xFFFE)
#define dat_06038142 ((short)0x7FFF)
#define dat_06038256 ((short)0xFFFD)
#define dat_06038258 ((short)0xFFFE)
#define dat_0603825A ((short)0x7FFF)
#define dat_0603837A ((short)0xFFFD)
#define dat_0603837C ((short)0xFFFE)
#define dat_0603837E ((short)0x7FFF)
#define dat_060384B8 ((int)0xF7FFFFFF)

/* Case 4/5 data — short offsets (prod wpool literals) */
#define dat_06038164 ((char *)0x002FC233)
#define dat_06038146 ((short)0x01A8)
#define dat_06038148 ((short)0x0080)
#define dat_06038252 ((short)0x00E0)
#define dat_06038254 ((short)0x01C0)
#define dat_0603825C ((short)0x01A8)

/* Case 6/7 data */
#define dat_06038278 ((char *)0x002FC233)
#define dat_0603825E ((short)0x0080)
#define dat_06038378 ((short)0x00E0)
#define dat_06038380 ((short)0x01C0)

/* Case 9 data — note: dat_060383A4 is a char* in prod (points to
 * 0x060540B4, same byte as dat_060540B4), dereferenced at use. */
#define dat_0603839C ((char *)0x06054920)
#define dat_060383A4 ((char *)0x060540B4)
#define dat_060383A0 ((int)0x0604F7E4)
#define dat_060384B0 ((int)0x0604F7E4)
#define dat_060384AC ((short)0x01C0)

/* Post-switch data */
#define dat_060384BC ((int)0x060527D0)
#define dat_060384C0 ((int)0x060527D4)

/* After setup_func(), param_1 is overwritten with the gs address.
 * This macro lets us use 'gs' in the source while sharing param_1's
 * register — matching production's reuse of r14 for both roles. */
#define gs ((int *)param_1)

/* Function pointer call macros — locals are int to control register
 * allocation order (LCC reorders mixed types unpredictably). */
#define CALL2(fptr, a)          ((void (*)(int *))(fptr))((a))
#define CALL3(fptr, a, b)       ((void (*)(int, int *))(fptr))((a), (b))
#define CALL5(fptr, a, b, c, d) ((void (*)(int, int *, int, int))(fptr))((a), (b), (c), (d))

int FUN_06037E28(int param_1) {
    int *secondary;
    int puVar5;
    int zero;
    int puVar4;
    int puVar3;
    int puVar2;

    setup_func();

    /* Compute gs address into param_1 — production reuses r14 */
    param_1 = (int)((short)((unsigned short)param_1 * (short)0x01D8) + base_array);

    secondary = *(int **)((char *)gs + 0x0160);

    if (*(int *)((char *)gs + 0x5C) == 10) {
        return 10;
    }

    /* Pre-switch guard: skip call block for states 6, 7, 8 */
    if (*(int *)((char *)gs + 0x5C) != 6
        && *(int *)((char *)gs + 0x5C) != 7
        && *(int *)((char *)gs + 0x5C) != 8) {
        if (*(char *)((char *)gs + 0x12) == 1 && dat_060540B4 == 1) {
            sub_06037EA4();
        } else {
            sub_06037ED4((int)*(char *)((char *)gs + 0x12));
        }
    }

    puVar2 = (int)sub_06037ED8;
    zero = 0;
    puVar5 = (int)sub_06037EE4;
    puVar3 = (int)sub_06037EDC;
    puVar4 = (int)sub_06037EE0;

    switch (*(int *)((char *)gs + 0x5C)) {
    case 0:
    case 1:
        sub_06038014(gs);
        sub_06038018(gs);
        CALL2(puVar3, gs);
        FUN_06038dd8(gs);
        gs[0xc] = gs[0xc] & (int)dat_0603800C & (int)dat_0603800E
                           & (int)dat_06038010 & 0xffffffbf;
        FUN_060384c4(gs);
        func_06038a82(gs);
        func_060385ce(gs);
        CALL5(puVar5, secondary[0], gs, secondary[4], 0);
        CALL5(puVar5, secondary[1], gs, secondary[5], 4);
        CALL5(puVar5, secondary[2], gs, secondary[6], 8);
        CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
        CALL3(puVar4, zero, gs);
        func_060386d8(gs);
        sub_0603801C(gs);
        CALL2(puVar2, gs);
        sub_06038020(gs);
        FUN_06038c64(gs);
        sub_06038024(gs);
        sub_06038028(gs);
        break;
    case 2:
        func_06038bc4(gs);
        CALL2(puVar3, gs);
        gs[0xc] = gs[0xc] & (int)dat_0603813E & (int)dat_06038140
                           & (int)dat_06038142 & 0xffffffbf;
        func_06038a82(gs);
        func_060385ce(gs);
        FUN_06038c64(gs);
        /* Shared tail with case 8 (LAB_06038304 in reference) */
        sub_06038390(gs);
        CALL2(puVar2, gs);
        break;
    case 3:
        sub_0603814C(gs);
        sub_06038150(gs);
        CALL2(puVar3, gs);
        FUN_06038dd8(gs);
        gs[0xc] = gs[0xc] & (int)dat_0603813E & (int)dat_06038140
                           & (int)dat_06038142 & 0xffffffbf;
        FUN_060384c4(gs);
        func_06038a82(gs);
        func_060385ce(gs);
        CALL5(puVar5, secondary[0], gs, secondary[4], 0);
        CALL5(puVar5, secondary[1], gs, secondary[5], 4);
        CALL5(puVar5, secondary[2], gs, secondary[6], 8);
        CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
        CALL3(puVar4, zero, gs);
        func_060386d8(gs);
        FUN_06038c64(gs);
        sub_06038154(gs);
        CALL2(puVar2, gs);
        sub_06038158(gs);
        sub_0603815C(gs);
        break;
    case 4:
        sub_06038160(gs);
        *(short *)((char *)gs + (int)dat_06038146) = 0;
        gs[0x17] = 5;
        sub_06038260(*dat_06038164 == 2 ? (int)dat_06038148 : (int)dat_06038252);
    /* fall through */
    case 5:
        *(char *)((char *)gs + (int)dat_06038254) = 0;
        sub_06038264(gs);
        sub_06038268(gs);
        CALL2(puVar3, gs);
        FUN_06038dd8(gs);
        gs[0xc] = gs[0xc] & (int)dat_06038256 & (int)dat_06038258
                           & (int)dat_0603825A & 0xffffffbf;
        FUN_060384c4(gs);
        func_06038a82(gs);
        func_060385ce(gs);
        CALL5(puVar5, secondary[0], gs, secondary[4], 0);
        CALL5(puVar5, secondary[1], gs, secondary[5], 4);
        CALL5(puVar5, secondary[2], gs, secondary[6], 8);
        CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
        if (3 < *(unsigned short *)((char *)gs + (int)dat_0603825C)) {
            CALL3(puVar4, zero, gs);
            if (*(char *)((char *)gs + (int)dat_06038254) == 1) {
                FUN_060384c4(gs);
                CALL5(puVar5, secondary[0], gs, secondary[4], 0);
                CALL5(puVar5, secondary[1], gs, secondary[5], 4);
                CALL5(puVar5, secondary[2], gs, secondary[6], 8);
                CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
            }
        }
        func_060386d8(gs);
        FUN_06038c64(gs);
        sub_0603826C(gs);
        CALL2(puVar2, gs);
        sub_06038270(gs);
        break;
    case 6:
        sub_06038274(gs);
        gs[0x17] = 7;
        sub_06038384(*dat_06038278 == 2 ? (int)dat_0603825E : (int)dat_06038378);
    /* fall through */
    case 7:
        func_06038bc4(gs);
        sub_06038388(gs);
        sub_0603838C(gs);
        CALL2(puVar3, gs);
        FUN_06038dd8(gs);
        gs[0xc] = gs[0xc] & (int)dat_0603837A & (int)dat_0603837C
                           & (int)dat_0603837E & 0xffffffbf;
        func_06038a82(gs);
        func_060385ce(gs);
        FUN_06038c64(gs);
        sub_06038390(gs);
        CALL2(puVar2, gs);
        sub_06038394(gs);
        break;
    case 8:
        func_06038bc4(gs);
        CALL2(puVar3, gs);
        gs[0xc] = gs[0xc] & (int)dat_0603837A & (int)dat_0603837C
                           & (int)dat_0603837E & 0xffffffbf;
        func_06038a82(gs);
        func_060385ce(gs);
        FUN_06038c64(gs);
        /* Shared tail (LAB_06038304) */
        sub_06038390(gs);
        CALL2(puVar2, gs);
        break;
    case 9:
        *(char *)((char *)gs + (int)dat_06038380) = 0;
        gs[9] = 0;
        CALL2(puVar3, gs);
        gs[0xc] = gs[0xc] & (int)dat_0603837A & (int)dat_0603837C
                           & (int)dat_0603837E & 0xffffffbf;
        sub_06038398(gs);
        if (*(char *)((char *)gs + 0x12) == 1 && *dat_060383A4 == 1) {
            gs[0] = *(int *)(dat_060383A0 + (char)(*dat_0603839C * 12));
            gs[2] = *(int *)(dat_060383A0 + (char)(*dat_0603839C * 12) + 8);
        } else {
            gs[0] = *(int *)(dat_060383A0
                    + (int)(char)(*dat_0603839C * 12)
                    + *(char *)((char *)gs + 0x12) * 0x3c);
            gs[2] = *(int *)(dat_060384B0
                    + (int)(char)(*dat_0603839C * 12)
                    + *(char *)((char *)gs + 0x12) * 0x3c + 8);
        }
        FUN_060384c4(gs);
        func_06038a82(gs);
        func_060385ce(gs);
        CALL5(puVar5, secondary[0], gs, secondary[4], 0);
        CALL5(puVar5, secondary[1], gs, secondary[5], 4);
        CALL5(puVar5, secondary[2], gs, secondary[6], 8);
        CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
        CALL3(puVar4, zero, gs);
        if (*(char *)((char *)gs + (int)dat_060384AC) == 1) {
            FUN_060384c4(gs);
            CALL5(puVar5, secondary[0], gs, secondary[4], 0);
            CALL5(puVar5, secondary[1], gs, secondary[5], 4);
            CALL5(puVar5, secondary[2], gs, secondary[6], 8);
            CALL5(puVar5, secondary[3], gs, secondary[7], 0xc);
        }
        func_060386d8(gs);
        FUN_06038c64(gs);
        break;
    }

    /* Post-switch epilogue — shared by all paths */
    sub_060384B4(gs);
    gs[0xc] = gs[0xc] & dat_060384B8;
    gs[0xb] = gs[0xb] + gs[0xd];
    if (*(short *)(dat_060384BC + *(char *)((char *)gs + 0x12) * 2) != 0) {
        *(short *)(dat_060384BC + *(char *)((char *)gs + 0x12) * 2) =
            *(short *)(dat_060384BC + *(char *)((char *)gs + 0x12) * 2) + -1;
    }
    if (*(short *)(dat_060384C0 + *(char *)((char *)gs + 0x12) * 2) != 0) {
        *(short *)(dat_060384C0 + *(char *)((char *)gs + 0x12) * 2) =
            *(short *)(dat_060384C0 + *(char *)((char *)gs + 0x12) * 2) + -1;
    }
    return *(char *)((char *)gs + 0x12) * 2;
}
#undef gs
