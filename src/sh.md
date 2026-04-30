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
#include <unistd.h>
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
 *
 * R14 is also the frame pointer when any local needs a stack slot or
 * when any incoming param lands at an r14-relative disp. The allocator
 * is allowed to pick r14 as a variable home speculatively — if FP
 * later turns out to be needed AND r14 was claimed as a var, the
 * conflict is resolved post-gencode by renaming every non-FP r14
 * mention in the captured body to the highest-numbered free callee-
 * saved reg. See function() for the detection and rename dance.
 */
#define INTTMP  0x0000000f  /* R0..R3 — SHC uses r0 as a general    */
                            /* scratch despite its dual role as the */
                            /* return-value register. r0 has        */
                            /* privileged addressing (@(R0,Rn),     */
                            /* tst #imm,r0) so keeping scratch in   */
                            /* it preserves optimisation potential. */
                            /* Return-value binding still handled   */
                            /* explicitly via setreg at CALL/RET.   */
                            /* The gen.c ralloc copy-elim path was  */
                            /* relaxed to handle the case where a   */
                            /* wildcard-allocated kid lands in a    */
                            /* register that matches a specific     */
                            /* setreg target. */
#define INTVAR  0x00007f00  /* R8..R14 (R14 may be reclaimed as FP) */
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
static unsigned sh_prealloc_mask(Symbol, Node, unsigned);
struct sh_ipa_fn;  /* forward: full defn lower, with the queue globals */
static void function(Symbol, Symbol[], Symbol[], int);
static void sh_process_deferred_fn(struct sh_ipa_fn *e);

/* asm-shim parser + emitter — types live in src/sh_sim.h, shared
 * with the symbolic simulator (sh_sim.c). Forward decls of the
 * sh.md-internal helpers stay here because emit2's ASM_INSN+V case
 * dereferences sh_asm_insn fields and emit2 lives upstream of the
 * helpers in the source. See saturn/workstreams/asm_shim_design.md
 * §4-§5. */
#include "sh_sim.h"

struct sh_asm_body *sh_parse_asm_text(const char *text);
static void sh_dump_asm_body(const struct sh_asm_body *body,
                             const char *label);
static void sh_emit_asm_insn(const struct sh_asm_insn *in);
int sh_asm_body_n_insns(struct sh_asm_body *body);
struct sh_asm_insn *sh_asm_body_insn(struct sh_asm_body *body, int i);
char *sh_asm_insn_src_text(struct sh_asm_insn *in);
static void sh_drain_ipa_queue(void);
static int sh_function_is_naked_shim(struct sh_ipa_fn *e);
static int sh_lookup_writes_r4(const char *name);
static enum sh_sim_verdict sh_phase_a_oracle(const char *name, void *user);
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
static int sh_switchjump(Swtch, long *, int, int, Symbol *, Symbol, int, int);

extern void (*shc_pragma_hook)(char *name);

/* ireg is sized to 32 because gen.c's askreg() walks a wildcard's
 * register array from index 31 down to 0. On SH-2 we only populate
 * slots 0-15, but the tail slots must be readable (NULL) or the
 * allocator dereferences past the end and segfaults. */
static Symbol ireg[32];
static Symbol ireg_prio[32];
static Symbol iregw;
static int tmpregs[] = {1, 2, 3};
static int cseg;

/* Frame metrics made visible to emit2() after function() has run
 * gencode(). The direct `mov.l @(disp,Rn),Rm` rules for ADDRFP4 and
 * ADDRLP4 need the sizeisave/localsize values to turn an LCC offset
 * into an r14- or r15-relative displacement. */
static int sh_sizeisave;
static int sh_localsize;
static int sh_fp_active;
static int sh_sp_locals_only;  /* locals exist but FP is not used (SP-relative) */
static int sh_all_returns_inlined;
static int sh_uses_macl;
static int sh_gbr_param;  /* #pragma gbr_param: emit ldc r4,gbr prologue */
static int sh_word_indexed_after_first;  /* #pragma sh_word_indexed_after_first: see sh_apply_word_indexed_after_first */

/* -d-asm: dump every parsed asm body to stderr at emit time. Used
 * by Stage 1 regtests in saturn/workstreams/asm_shim_design.md to
 * verify the parser's destination detection and round-trip
 * behavior. Stage 1 only invokes the parser when this flag is on;
 * Stage 2 will invoke it unconditionally at frontend time. */
static int sh_dflag_asm;

/* -d-sim: run the symbolic simulator on every parsed asm body and
 * print its r4-preservation verdict to stderr. Used by sim
 * regtests to confirm the analyzer's verdict on hand-written
 * test cases without yet wiring it into Phase A's hot path. */
static int sh_dflag_sim;

/* Test-only callee oracle for -d-sim. Treats any name starting
 * with "PRESERVES_" as a preserves-r4 callee, anything else as
 * a writer. Used by sim regtests to author test cases that
 * exercise the oracle path without yet plumbing real inter-
 * procedural state through (which lands when Phase A is wired). */
static enum sh_sim_verdict sh_sim_dbg_oracle(const char *name,
                                             void *user) {
        (void)user;
        if (!name) return SH_SIM_WRITES;
        if (strncmp(name, "PRESERVES_", 10) == 0)
                return SH_SIM_PRESERVES;
        return SH_SIM_WRITES;
}

/* Per-sub-entry verdict printer for -d-sim. Iteration continues
 * (return 1) after every emitted line. */
static int sh_sim_dbg_visit_entry(const char *name,
                                  enum sh_sim_verdict v,
                                  void *user) {
        (void)user;
        fprint(stderr, "[sim entry %s] %s\n",
               name ? name : "?",
               v == SH_SIM_PRESERVES ? "PRESERVES_R4"
                                     : "WRITES_R4");
        return 1;
}

/* Switch-dispatch state recorded by sh_switchjump() during front-end
 * processing, emitted by sh_emit_switch_dispatch() after body capture.
 * Only one switch table per function is supported (enough for Daytona).
 * Named struct so sh_ipa_fn can capture a copy per-function. */
#define SH_MAX_SWITCH_LABELS 64
struct sh_switch_state {
        int active;
        int dispatch_lab;         /* label where braf dispatch goes */
        int deflab;               /* default/out-of-range label */
        int ncases;               /* number of table entries */
        int min_val;              /* minimum case value */
        char labels[SH_MAX_SWITCH_LABELS][64]; /* case label names */
        char deflabel[64];        /* default label name */
        char hilabel[64];         /* upper bounds-check label name */
};

/* IPA defer queue (Phase A.0): captures per-function state at each
 * IR->function() call so end-of-TU processing can walk the queue in
 * reverse-topological order. Phase A.0 is capture-only — still
 * processes immediately in source order. FUNC arena is retained
 * (Xinterface.retain_func_arena) so the Code linked list and Node
 * DAGs referenced here stay live until progend drains the queue.
 * See saturn/workstreams/ipa_design.md for the full roadmap. */
struct sh_ipa_fn {
        Symbol f;
        Symbol *caller;
        Symbol *callee;
        int ncalls;
        struct code code_head;
        /* Positional pragma flags captured at function() time. These
         * are "applies to the next function compiled" pragmas that set
         * a scalar global during parse and are consumed by the next
         * IR->function() call. Under deferred drain, all parse-time
         * pragmas fire before any drain, so a raw scalar gets consumed
         * by the wrong (source-order-first) function. Capturing the
         * flag value here at function() time binds it to THIS specific
         * function — we reset the global immediately after capture so
         * the next function starts clean, and restore the captured
         * value at drain before sh_process_deferred_fn runs. */
        int gbr_param;
        int word_indexed_after_first;
        /* Switch-dispatch state populated by sh_switchjump() during
         * front-end parsing, consumed by sh_emit_switch_dispatch() at
         * codegen. Same positional-state bug as the pragma flags: a
         * single global struct gets overwritten by later functions'
         * switch parsing, so capture per-function and restore at drain. */
        struct sh_switch_state switch_state;
        /* Phase B: direct-call edges, collected at capture time by
         * walking the DAG for CALL nodes whose function-pointer kid
         * is an ADDRG. Indirect calls (function pointers, pool loads)
         * have no compile-time callee — we omit them and rely on the
         * ABI-conservative clobber fallback at the CALL site. */
        Symbol *direct_callees;   /* array of callee Symbols, dedup'd */
        int n_direct_callees;
        /* Phase C: the cached answer to "does this function's body,
         * or anything it transitively calls, write r4?" Populated by
         * sh_analyze_writes_r4 in reverse-topological order at the
         * start of sh_drain_ipa_queue. Default 1 (conservative: we
         * know nothing yet). Clobber() in Phase D consults this so
         * a CALL whose target has writes_r4=0 can skip the r4 spill.
         *
         * Currently optimistic at the leaf: a leaf function with no
         * direct callees reports 0 even though its body might use r4
         * as scratch. If that turns out to over-declare preservation
         * and we see byte-match regressions when Phase D lands, the
         * analysis gets tightened — but by the oracle principle, any
         * such regression is a concrete teaching case we can handle
         * surgically rather than by pessimizing everything up front. */
        int writes_r4;
        /* Phase E (IPA allocator): state threaded through the
         * pre-ralloc rewrite pass (sh_ipa_rewrite_arg_adds) and the
         * restore-emission pass (sh_ipa_emit_restore).
         *
         * pinned_param: the parameter Symbol we bound to r4 via
         *   askregvar in the non-leaf param-homing path when
         *   sh_ipa_all_callees_preserve_r4(e) is true. NULL when the
         *   IPA predicate didn't fire for this function (the common
         *   case) — leaves downstream rewrites as no-ops.
         * pinned_reg: hard register number of the pin (4 for r4);
         *   carried so future generalization to r5/r6/r7 can reuse
         *   the same state.
         * total_delta: net signed byte offset applied to pinned_param
         *   across all ARG sites in this function after rewrite. Drives
         *   the restore synthesis (add #-total_delta, rN) before the
         *   epilogue.
         * needs_restore: 1 iff the rewrite pass observed at least one
         *   non-zero-offset ARG mutation. Scalar gate for whether to
         *   synthesize the restore ASGN. */
        Symbol pinned_param;
        int    pinned_reg;
        int    total_delta;
        int    needs_restore;
        /* Phase E.2 (Shape 2): an alternative to pinned_param.
         * pinned_local is set when the function defines a local
         * variable initialized exactly once from `param + K`
         * (or just `param`), never reassigned, and used as the
         * first argument of every direct call. Pinning the local
         * to r4 lets the C codegen produce one-time setup and
         * zero-cost arg passing across the entire call sequence.
         * Mutually exclusive with pinned_param: the function gets
         * one or the other, decided at param-homing time. */
        Symbol pinned_local;
        struct sh_ipa_fn *next;
};
static struct sh_ipa_fn *sh_ipa_queue;
static struct sh_ipa_fn *sh_ipa_tail;
static int sh_ipa_nqueued;
/* True while sh_drain_ipa_queue is processing. Controls whether
 * function-related output (function exports, .text switches) emits
 * immediately or waits for drain so the layout stays adjacent
 * .global/.text/body per function (matches A.0 output). */
static int sh_ipa_in_drain;

/* Phase E (IPA): the queue entry currently inside
 * sh_process_deferred_fn. Read by target() to learn whether this
 * function has its first-argument register pinned to a specific
 * parameter Symbol via askregvar (pinned_param set), so ARG+X(argno=0)
 * can rtarget to that Symbol directly instead of to the plain register
 * Symbol ireg[4]. NULL outside the deferred-function pipeline. */
static struct sh_ipa_fn *sh_ipa_current;

static struct sh_switch_state sh_switch;

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
#define SH_MAX_LITERALS 256

struct shlit {
        int label;
        int is_symbol;          /* 0 = numeric, 1 = symbol name */
        int is_word;            /* 1 = .word (16-bit), 0 = .long  */
        int value;
        char *name;
};
static struct shlit shlits[SH_MAX_LITERALS];
static int nshlit;

static int shlit_num(int val);
static int shlit_sym(char *name);
static void shlit_flush(void);
static void sh_fold_mov_extw_to_movw(void);
static void sh_fold_base_displacement(void);

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
static int sh_disp_cost(Node a, int sz);
%}
%start stmt

%term CNSTF4=4113
%term CNSTF8=8209
%term CNSTI1=1045
%term CNSTI2=2069
%term CNSTI4=4117
%term CNSTI8=8213
%term CNSTP4=4119
%term CNSTU1=1046
%term CNSTU2=2070
%term CNSTU4=4118
%term CNSTU8=8214

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
%term ASGNI8=8245
%term ASGNU8=8246
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
%term INDIRI8=8261
%term INDIRU8=8262
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
%term CVII8=8325
%term CVIU1=1158
%term CVIU2=2182
%term CVIU4=4230
%term CVIU8=8326
%term CVPP4=4247
%term CVPU4=4246
%term CVUI1=1205
%term CVUI2=2229
%term CVUI4=4277
%term CVUI8=8373
%term CVUP4=4279
%term CVUU1=1206
%term CVUU2=2230
%term CVUU4=4278
%term CVUU8=8374

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
%term RSHI8=8565
%term RSHU4=4470
%term RSHU8=8566

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
%term MULI8=8661
%term MULU4=4566
%term MULU8=8662

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

%term ASM_INSNV=728

%term LOADB=233
%term LOADF4=4321
%term LOADF8=8417
%term LOADI1=1253
%term LOADI2=2277
%term LOADI4=4325
%term LOADI8=8421
%term LOADP4=4327
%term LOADU1=1254
%term LOADU2=2278
%term LOADU4=4326
%term LOADU8=8422

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
/* Fallback for short constants outside -128..127. emit2's CNST+I
 * handler already emits a mov.w from a word-pool literal for values
 * that fit in short range, so the same code path works here. */
reg:  CNSTI2  "# large const\n"  2
reg:  CNSTU2  "# large const\n"  2

/* Fallback for byte constants outside -128..127/0..127. emit via
 * the same pool path as larger types — safe because SH-2 loads
 * bytes with sign-extension and the assembler widens the literal
 * as needed. */
reg:  CNSTI1  "# large const\n"  2
reg:  CNSTU1  "# large const\n"  2

reg:  ADDRGP4  "# addrg\n"  2

reg:  ADDRFP4  "# addrfp\n"  2
reg:  ADDRLP4  "# addrlp\n"  2

reg:  INDIRI4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRU4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRP4(ADDRFP4)  "# fpload_l\n"  1
reg:  INDIRI4(ADDRLP4)  "# lpload_l\n"  1
reg:  INDIRU4(ADDRLP4)  "# lpload_l\n"  1
reg:  INDIRP4(ADDRLP4)  "# lpload_l\n"  1

reg:  INDIRI1(ADDRFP4)  "# fpload_b\n"  2
reg:  INDIRU1(ADDRFP4)  "# fpload_b\n"  2
reg:  INDIRI2(ADDRFP4)  "# fpload_w\n"  2
reg:  INDIRU2(ADDRFP4)  "# fpload_w\n"  2
reg:  INDIRI1(ADDRLP4)  "# lpload_b\n"  2
reg:  INDIRU1(ADDRLP4)  "# lpload_b\n"  2
reg:  INDIRI2(ADDRLP4)  "# lpload_w\n"  2
reg:  INDIRU2(ADDRLP4)  "# lpload_w\n"  2

stmt: ASGNI4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNU4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNP4(ADDRFP4,reg)  "# fpstore_l\n"  1
stmt: ASGNI4(ADDRLP4,reg)  "# lpstore_l\n"  1
stmt: ASGNU4(ADDRLP4,reg)  "# lpstore_l\n"  1
stmt: ASGNP4(ADDRLP4,reg)  "# lpstore_l\n"  1

stmt: ASGNI1(ADDRFP4,reg)  "# fpstore_b\n"  2
stmt: ASGNU1(ADDRFP4,reg)  "# fpstore_b\n"  2
stmt: ASGNI2(ADDRFP4,reg)  "# fpstore_w\n"  2
stmt: ASGNU2(ADDRFP4,reg)  "# fpstore_w\n"  2
stmt: ASGNI1(ADDRLP4,reg)  "# lpstore_b\n"  2
stmt: ASGNU1(ADDRLP4,reg)  "# lpstore_b\n"  2
stmt: ASGNI2(ADDRLP4,reg)  "# lpstore_w\n"  2
stmt: ASGNU2(ADDRLP4,reg)  "# lpstore_w\n"  2

immi8: CNSTI4  "%a"  range(a, -128, 127)
immu8: CNSTU4  "%a"  range(a, 0, 127)

zeroi: CNSTI4  ""  (range(a, 0, 0) == 0 ? 0 : SH_GBR_REJECT)
zerou: CNSTU4  ""  (range(a, 0, 0) == 0 ? 0 : SH_GBR_REJECT)

bmask: CNSTI4  ""  (range(a, 0xff, 0xff) == 0 ? 0 : SH_GBR_REJECT)
bmasu: CNSTU4  ""  (range(a, 0xff, 0xff) == 0 ? 0 : SH_GBR_REJECT)
wmask: CNSTI4  ""  (range(a, 0xffff, 0xffff) == 0 ? 0 : SH_GBR_REJECT)
wmasu: CNSTU4  ""  (range(a, 0xffff, 0xffff) == 0 ? 0 : SH_GBR_REJECT)

reg:  ADDI4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1
reg:  ADDU4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1
reg:  ADDP4(reg,reg)  "?\tmov\tr%0,r%c\n\tadd\tr%1,r%c\n"  1

reg:  ADDI4(reg,immi8)  "?\tmov\tr%0,r%c\n\tadd\t#%1,r%c\n"  0
reg:  ADDU4(reg,immu8)  "?\tmov\tr%0,r%c\n\tadd\t#%1,r%c\n"  0
reg:  ADDP4(reg,immi8)  "?\tmov\tr%0,r%c\n\tadd\t#%1,r%c\n"  0

reg:  SUBI4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1
reg:  SUBU4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1
reg:  SUBP4(reg,reg)  "?\tmov\tr%0,r%c\n\tsub\tr%1,r%c\n"  1

reg:  MULI4(reg,reg)  "# mul32\n"  3
reg:  MULU4(reg,reg)  "# mul32\n"  3

/* ── 64-bit multiply-high idiom (SH-2 dmuls.l / dmulu.l) ──────
 * SH-2 has no native 64-bit arithmetic, but has 32×32→64 widening
 * multiplies that write MACH:MACL. Ghidra decompiles the resulting
 * instruction pair back into C as
 *     (T)(((longlong)a * (longlong)b) >> 32)
 * i.e. take the high word of the 64-bit product. We match this
 * whole tree shape in one lburg rule and emit dmuls.l/dmulu.l +
 * sts mach in the RSH emit case below. Any other 64-bit arithmetic
 * use will still fail with "Bad terminal" — we intentionally do
 * not claim general long-long support.
 *
 * LCC wraps the MULI8/MULU8 in LOAD and/or CV nodes depending on
 * surrounding expression context, so mulhi_s / mulhi_u are
 * recursive wrapper nonterminals that peel those off. Emit code
 * walks back down to the MULI8/MULU8 to get the source regs. */
c32i:  CNSTI4  "%a"  (range(a, 32, 32) == 0 ? 0 : SH_GBR_REJECT)
c32i:  CNSTI8  "%a"  (range(a, 32, 32) == 0 ? 0 : SH_GBR_REJECT)
c32u:  CNSTU4  "%a"  (range(a, 32, 32) == 0 ? 0 : SH_GBR_REJECT)
c32u:  CNSTU8  "%a"  (range(a, 32, 32) == 0 ? 0 : SH_GBR_REJECT)

/* Extension to 8-byte from any 4-byte int/uint source. */
ext8s:  CVII8(reg)  ""  0
ext8s:  CVUI8(reg)  ""  0
ext8u:  CVIU8(reg)  ""  0
ext8u:  CVUU8(reg)  ""  0

mulhi_s:  MULI8(ext8s, ext8s)  ""  0
mulhi_s:  LOADI8(mulhi_s)      ""  0
mulhi_s:  LOADU8(mulhi_s)      ""  0
mulhi_s:  CVIU8(mulhi_s)       ""  0
mulhi_s:  CVUU8(mulhi_s)       ""  0

mulhi_u:  MULU8(ext8u, ext8u)  ""  0
mulhi_u:  LOADI8(mulhi_u)      ""  0
mulhi_u:  LOADU8(mulhi_u)      ""  0
mulhi_u:  CVIU8(mulhi_u)       ""  0
mulhi_u:  CVUU8(mulhi_u)       ""  0

reg:  RSHU8(mulhi_s, c32i)  "# mul_hi32_s\n"  3
reg:  RSHU8(mulhi_u, c32i)  "# mul_hi32_u\n"  3
reg:  RSHU8(mulhi_s, c32u)  "# mul_hi32_s\n"  3
reg:  RSHU8(mulhi_u, c32u)  "# mul_hi32_u\n"  3

/* 64-bit multiply-low idiom. Ghidra also emits the LOW word of a
 * widening multiply: `(uint)((longlong)a * (longlong)b)`. SH-2
 * emits this with the same dmuls.l/dmulu.l but `sts macl` instead
 * of `sts mach`. Trees come through as CVxI4(MULI8/MULU8(...)).
 * Handle in the RSH+I/RSH+U emit case as a sibling of mul-high. */
reg:  CVII4(mulhi_s)  "# mul_lo32_s\n"  3
reg:  CVII4(mulhi_u)  "# mul_lo32_u\n"  3
reg:  CVUI4(mulhi_s)  "# mul_lo32_s\n"  3
reg:  CVUI4(mulhi_u)  "# mul_lo32_u\n"  3

/* LCC's prelabel rewrites narrowing CV to LOAD (gen.c case
 * CVI/CVU/CVP).  After the rewrite, `(uint)((longlong)a *
 * (longlong)b)` is LOADU4(MULI8(...)), not CVUI4(MULI8(...)).
 * Cover that shape too — cost 3 matches the CV siblings. */
reg:  LOADI4(mulhi_s)  "# mul_lo32_s\n"  3
reg:  LOADI4(mulhi_u)  "# mul_lo32_u\n"  3
reg:  LOADU4(mulhi_s)  "# mul_lo32_s\n"  3
reg:  LOADU4(mulhi_u)  "# mul_lo32_u\n"  3

/* 8-byte local-storage support — pattern-matched to Ghidra's
 * "longlong lVar = a*b; hi = lVar>>32; lo = (uint)lVar" idiom.
 * ASGNI8/U8 to a local slot emits dmuls.l + sts macl + sts mach
 * into the two 4-byte halves of the slot. Subsequent INDIRI8
 * reads then shift/cast pick up the appropriate half.
 *
 * No general 64-bit register support: an INDIRI8 that isn't
 * under RSHU8(...,32) or a CVxI4(...) narrow will still fail
 * with "Bad terminal" — which is the correct diagnostic. */
stmt: ASGNI8(ADDRLP4, mulhi_s)  "# mulstore8_local_s\n"  4
stmt: ASGNI8(ADDRLP4, mulhi_u)  "# mulstore8_local_u\n"  4
stmt: ASGNU8(ADDRLP4, mulhi_s)  "# mulstore8_local_s\n"  4
stmt: ASGNU8(ADDRLP4, mulhi_u)  "# mulstore8_local_u\n"  4

reg:  RSHU8(INDIRI8(ADDRLP4), c32i)  "# load8_local_hi\n"  2
reg:  RSHU8(INDIRU8(ADDRLP4), c32i)  "# load8_local_hi\n"  2
reg:  CVUI4(INDIRI8(ADDRLP4))        "# load8_local_lo\n"  2
reg:  CVII4(INDIRI8(ADDRLP4))        "# load8_local_lo\n"  2
reg:  CVUI4(INDIRU8(ADDRLP4))        "# load8_local_lo\n"  2
reg:  CVII4(INDIRU8(ADDRLP4))        "# load8_local_lo\n"  2

/* 8-byte VREG support for CSE'd widened 4-byte values.
 * lcc hoists repeated `(longlong)x` subtrees out of mul
 * expressions into an 8-byte VREG. We support only the
 * narrow case: the VREG is written by CVII8/CVUI8/CVIU8/
 * CVUU8 of a 4-byte reg, and read back via INDIRI8/U8
 * inside a MULI8/MULU8 operand or CVxI4 low-half narrow.
 * The allocator maps the VREG to a single 4-byte physical
 * reg holding the source value — no register pair. */
reg:   INDIRI8(VREGP)  "# read register\n"  0
reg:   INDIRU8(VREGP)  "# read register\n"  0

stmt:  ASGNI8(VREGP, ext8s)  "# write register\n"  0
stmt:  ASGNI8(VREGP, ext8u)  "# write register\n"  0
stmt:  ASGNU8(VREGP, ext8s)  "# write register\n"  0
stmt:  ASGNU8(VREGP, ext8u)  "# write register\n"  0

/* Allow INDIRI8(VREGP) to compose with mulhi_s/u when used
 * as a MULI8 operand, and with CVxI4 narrow for the low half. */
ext8s: INDIRI8(VREGP)  ""  0
ext8u: INDIRU8(VREGP)  ""  0

con1:  CNSTI4  "%a"  (range(a, 1, 1) == 0 ? 0 : SH_GBR_REJECT)
con1:  CNSTU4  "%a"  (range(a, 1, 1) == 0 ? 0 : SH_GBR_REJECT)
con2:  CNSTI4  "%a"  (range(a, 2, 2) == 0 ? 0 : SH_GBR_REJECT)
con2:  CNSTU4  "%a"  (range(a, 2, 2) == 0 ? 0 : SH_GBR_REJECT)
con8i:  CNSTI4  "%a"  (range(a, 8, 8) == 0 ? 0 : SH_GBR_REJECT)
con16i: CNSTI4  "%a"  (range(a, 16, 16) == 0 ? 0 : SH_GBR_REJECT)

/* Generic shift-amount nonterminal — matches any non-negative
 * shift constant up to 31. The LSH/RSH emit code already
 * decomposes arbitrary n into shll16/shll8/shll2/shll (and the
 * shlr family / repeated shar). The specific con1/con2/con8i/
 * con16i rules still win on cost when applicable. */
conshi: CNSTI4  "%a"  (range(a, 0, 31) == 0 ? 0 : SH_GBR_REJECT)
conshi: CNSTU4  "%a"  (range(a, 0, 31) == 0 ? 0 : SH_GBR_REJECT)

reg:  LSHI4(reg,con1)   "# lsh\n"  1
reg:  LSHU4(reg,con1)   "# lsh\n"  1
reg:  LSHI4(reg,con2)   "# lsh\n"  1
reg:  LSHU4(reg,con2)   "# lsh\n"  1
reg:  LSHI4(reg,con8i)  "# lsh\n"  1
reg:  LSHU4(reg,con8i)  "# lsh\n"  1
reg:  LSHI4(reg,con16i) "# lsh\n"  1
reg:  LSHU4(reg,con16i) "# lsh\n"  1
reg:  RSHI4(reg,con1)   "# rsh\n"  1
reg:  RSHU4(reg,con1)   "# rsh\n"  1
reg:  RSHI4(reg,con2)   "# rsh\n"  1
reg:  RSHU4(reg,con2)   "# rsh\n"  1

/* Fallback: any non-negative constant shift. Emit loops through
 * the SH-2 shift instructions to cover arbitrary amounts. Cost
 * higher than the specific rules so those still win when they
 * can match. */
reg:  LSHI4(reg,conshi)  "# lsh\n"  4
reg:  LSHU4(reg,conshi)  "# lsh\n"  4
reg:  RSHI4(reg,conshi)  "# rsh\n"  4
reg:  RSHU4(reg,conshi)  "# rsh\n"  4

reg:  BANDI4(reg,bmask)  "\textu.b\tr%0,r%c\n"  0
reg:  BANDU4(reg,bmasu)  "\textu.b\tr%0,r%c\n"  0
reg:  BANDI4(reg,wmask)  "\textu.w\tr%0,r%c\n"  0
reg:  BANDU4(reg,wmasu)  "\textu.w\tr%0,r%c\n"  0

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
/* 8-byte LOAD pass-through — only reachable when an 8-byte
 * subtree has already been fully matched by the mul-hi32 rule,
 * so the reg holds a 32-bit narrow result and a plain `mov`
 * is correct. Any other 64-bit LOAD use would silently lose
 * the high word; that's OK because the only 64-bit pattern we
 * claim is mul-high. */
reg:  LOADI8(reg)  "\tmov\tr%0,r%c\n"  move(a)
reg:  LOADU8(reg)  "\tmov\tr%0,r%c\n"  move(a)

reg:  INDIRI1(reg)  "\tmov.b\t@r%0,r%c\n"  1
reg:  INDIRU1(reg)  "\tmov.b\t@r%0,r%c\n"  1
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

reg:  INDIRI1(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRU1(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRI2(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRU2(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRI4(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRU4(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRP4(ADDI4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRI1(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRU1(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRI2(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRU2(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRI4(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRU4(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRP4(ADDU4(reg,immu8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRI1(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRU1(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,1)
reg:  INDIRI2(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRU2(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,2)
reg:  INDIRI4(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRU4(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)
reg:  INDIRP4(ADDP4(reg,immi8))  "# dispload\n"  sh_disp_cost(a,4)

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

stmt: ASGNI1(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNU1(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNI2(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNU2(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNI4(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNU4(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNP4(ADDI4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNI1(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNU1(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNI2(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNU2(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNI4(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNU4(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNP4(ADDU4(reg,immu8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNI1(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNU1(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,1)
stmt: ASGNI2(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNU2(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,2)
stmt: ASGNI4(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNU4(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)
stmt: ASGNP4(ADDP4(reg,immi8),reg)  "# dispstore\n"  sh_disp_cost(a,4)

reg:  CVII4(reg)  "\texts.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVII4(reg)  "\texts.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUI4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.b\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==1?1:LBURG_MAX)
reg:  CVUU4(reg)  "\textu.w\tr%0,r%c\n"  (a->syms[0]->u.c.v.i==2?1:LBURG_MAX)

/* 8-byte source → 4-byte narrow conversions. Only reachable
 * when the 8-byte subtree has collapsed via the mul-hi32 rule,
 * so the reg already holds a 32-bit value — narrow is a no-op. */
reg:  CVII4(reg)  "# narrow_i8_i4\n"  (a->syms[0]->u.c.v.i==8?1:LBURG_MAX)
reg:  CVUI4(reg)  "# narrow_u8_i4\n"  (a->syms[0]->u.c.v.i==8?1:LBURG_MAX)
reg:  CVUU4(reg)  "# narrow_u8_u4\n"  (a->syms[0]->u.c.v.i==8?1:LBURG_MAX)

/* Same-size CV pass-through. lcc emits these when Ghidra's
 * type annotations triggered a size-preserving conversion that
 * the frontend didn't fold (e.g. int -> uint, int* -> char*,
 * reinterpret casts). They should parse without a separate
 * instruction since the register already holds the value. */
reg:  CVII4(reg)  "# cv4_passthrough\n"  (a->syms[0]->u.c.v.i==4?1:LBURG_MAX)
reg:  CVUI4(reg)  "# cv4_passthrough\n"  (a->syms[0]->u.c.v.i==4?1:LBURG_MAX)
reg:  CVUU4(reg)  "# cv4_passthrough\n"  (a->syms[0]->u.c.v.i==4?1:LBURG_MAX)

/* Narrowing conversions (int → short, int → char, etc). On SH-2 the
 * reg already holds the 32-bit value; narrowing is implicit when we
 * later store via mov.w/mov.b or when an arithmetic op consumes only
 * the low bits. No instruction needed at the register level — just
 * re-label the reg. */
reg:  CVII1(reg)  "# truncate\n"  1
reg:  CVII2(reg)  "# truncate\n"  1
reg:  CVUU1(reg)  "# truncate\n"  1
reg:  CVUU2(reg)  "# truncate\n"  1
reg:  CVUI1(reg)  "# truncate\n"  1
reg:  CVUI2(reg)  "# truncate\n"  1

stmt: LABELV  "#\n"

stmt: ASM_INSNV  "#\n"

jtarget: ADDRGP4  "%a"
stmt: JUMPV(jtarget)  "\tbra\t%0\n\tnop\n"  2

stmt: EQI4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbt\t%a\n"  2
stmt: EQU4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbt\t%a\n"  2
stmt: NEI4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbf\t%a\n"  2
stmt: NEU4(reg,reg)  "\tcmp/eq\tr%1,r%0\n\tbf\t%a\n"  2

stmt: EQI4(reg,zeroi)  "\ttst\tr%0,r%0\n\tbt\t%a\n"  1
stmt: EQU4(reg,zerou)  "\ttst\tr%0,r%0\n\tbt\t%a\n"  1
stmt: NEI4(reg,zeroi)  "\ttst\tr%0,r%0\n\tbf\t%a\n"  1
stmt: NEU4(reg,zerou)  "\ttst\tr%0,r%0\n\tbf\t%a\n"  1
stmt: EQI4(reg,immi8)  "# cmp_eq_imm_bt\n"  1
stmt: EQU4(reg,immu8)  "# cmp_eq_imm_bt\n"  1
stmt: NEI4(reg,immi8)  "# cmp_eq_imm_bf\n"  1
stmt: NEU4(reg,immu8)  "# cmp_eq_imm_bf\n"  1
stmt: LTI4(reg,reg)  "\tcmp/ge\tr%1,r%0\n\tbf\t%a\n"  2
stmt: LEI4(reg,reg)  "\tcmp/gt\tr%1,r%0\n\tbf\t%a\n"  2
stmt: GTI4(reg,reg)  "\tcmp/gt\tr%1,r%0\n\tbt\t%a\n"  2
stmt: GEI4(reg,reg)  "\tcmp/ge\tr%1,r%0\n\tbt\t%a\n"  2
stmt: LTU4(reg,reg)  "\tcmp/hs\tr%1,r%0\n\tbf\t%a\n"  2
stmt: LEU4(reg,reg)  "\tcmp/hi\tr%1,r%0\n\tbf\t%a\n"  2
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

static int shlit_word(int val) {
        int i;
        for (i = 0; i < nshlit; i++)
                if (shlits[i].is_word && shlits[i].value == val)
                        return shlits[i].label;
        assert(nshlit < SH_MAX_LITERALS);
        shlits[nshlit].label = genlabel(1);
        shlits[nshlit].is_symbol = 0;
        shlits[nshlit].is_word = 1;
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
        int i, nshort = 0;
        if (nshlit == 0)
                return;
        print("\t.align 2\n");
        /* Emit .short (word) entries first so any subsequent .long
         * entries start on a 4-byte boundary regardless of how many
         * words precede them.  GAS .align 2 aligns to 2^2 = 4 bytes
         * on sh-elf, so we only need one padding directive between
         * the groups when the word count is odd. */
        for (i = 0; i < nshlit; i++) {
                if (!shlits[i].is_symbol && shlits[i].is_word) {
                        print("L%d:\t.short\t%d\n",
                              shlits[i].label, shlits[i].value);
                        nshort++;
                }
        }
        if (nshort & 1)
                print("\t.align 2\n");
        for (i = 0; i < nshlit; i++) {
                if (shlits[i].is_symbol)
                        print("L%d:\t.long\t%s\n",
                              shlits[i].label, shlits[i].name);
                else if (!shlits[i].is_word)
                        print("L%d:\t.long\t%d\n",
                              shlits[i].label, shlits[i].value);
        }
        nshlit = 0;
}

static char *gbr_base_asmname(void) {
        if (!gbr_base_cname)
                return NULL;
        if (gbr_base_asmbuf[0] == 0) {
                /* Match defsymbol: bare names, no leading
                 * underscore (Hitachi SHC convention). */
                strncpy(gbr_base_asmbuf, gbr_base_cname,
                        sizeof(gbr_base_asmbuf) - 1);
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

/* Cost function for displacement addressing compound rules.
 * Returns 0 when the ADD's constant child fits the SH-2
 * displacement range for the given access size, SH_GBR_REJECT
 * otherwise. Ranges: byte 0..15, word 0..30 (even), long 0..60
 * (4-aligned). Node `a` is the INDIR or ASGN root; the ADD is
 * a->kids[0] and the constant is a->kids[0]->kids[1]. */
static int sh_disp_cost(Node a, int sz) {
        int v;
        if (!a->kids[0] || !a->kids[0]->kids[1]
            || !a->kids[0]->kids[1]->syms[0])
                return SH_GBR_REJECT;
        v = (int)a->kids[0]->kids[1]->syms[0]->u.c.v.i;
        if (v < 0)
                return SH_GBR_REJECT;
        if (sz == 1 && v <= 15)  return 0;
        if (sz == 2 && v <= 30 && (v & 1) == 0)  return 0;
        if (sz == 4 && v <= 60 && (v & 3) == 0)  return 0;
        return SH_GBR_REJECT;
}

/* Per-function register-save attribute storage. Populated by
 * #pragma noregsave / noregalloc / sh_alloc_lowfirst during parse;
 * consumed by prologue/epilogue emission and the allocator.
 * PERM-arena allocated so entries persist for the whole TU. Names
 * are interned via stringn() so pointer equality is lookup-safe. */
#define SH_ATTR_NOREGSAVE  0x02
#define SH_ATTR_NOREGALLOC 0x04
/* SH-specific (not in SHC manual): per-function flip of the
 * INTVAR allocation order (r8..r14 instead of r14..r8). Used to
 * match prod functions where SHC happened to allocate low-first.
 * Per-function gated because the allocator's order interacts with
 * peephole passes (sh_rewrite_bool_fp, leaf_rename); flipping it
 * for the wrong function regresses output. The pragma transcribes
 * the per-function answer-key from prod evidence. */
#define SH_ATTR_LOWFIRST   0x08

struct sh_func_attr {
        char *name;
        int flags;
        struct sh_func_attr *next;
};
static struct sh_func_attr *sh_func_attrs;

/* TU-wide global-register bindings from #pragma global_register.
 * Allowed registers are R8..R14 per SHC v5.0 §3.11. */
struct sh_global_reg {
        char *varname;
        int regnum;
        struct sh_global_reg *next;
};
static struct sh_global_reg *sh_global_regs;

static void sh_record_func_attr(char *name, int attr) {
        struct sh_func_attr *a;
        for (a = sh_func_attrs; a; a = a->next)
                if (a->name == name) { a->flags |= attr; return; }
        NEW(a, PERM);
        a->name = name;
        a->flags = attr;
        a->next = sh_func_attrs;
        sh_func_attrs = a;
}

/* Returns nonzero if the function named `name` was declared with any
 * attr bit in `attrs`. Uses strcmp rather than pointer-equality
 * because the interning paths for the pragma parser and the C
 * frontend are both the global string table — same pointer in
 * theory, but strcmp is cheap and keeps this robust under refactor. */
static int sh_func_has_attr(const char *name, int attrs) {
        struct sh_func_attr *a;
        if (!name) return 0;
        for (a = sh_func_attrs; a; a = a->next)
                if (strcmp(a->name, name) == 0)
                        return (a->flags & attrs) != 0;
        return 0;
}

/* Save-range extension: find lowest set bit in [r8..r14] of `mask`;
 * if any, set every bit in [lowest..14]. Implements SHC's rule of
 * saving the contiguous range from lowest dirtied callee-saved up
 * through r14. Idempotent, so it's safe to call both before the
 * body-liveness rebuild and again after (the rebuild AND's with
 * live-set and would otherwise strip the extended-but-unused bits
 * that prod saves anyway). */
static unsigned sh_regsave_extend(unsigned mask) {
        int j, lowest = -1;
        struct sh_global_reg *g;
        for (j = 8; j <= 14; j++)
                if (mask & (1u << j)) { lowest = j; break; }
        if (lowest >= 0)
                for (j = lowest; j <= 14; j++)
                        mask |= 1u << j;
        /* Save-default inversion: globally-pinned registers (via
         * #pragma global_register) must NOT be saved/restored — they're
         * TU-wide homes that cross function boundaries by design.
         * Carve them back out of the extended mask so the prologue
         * doesn't stomp the contract. */
        for (g = sh_global_regs; g; g = g->next)
                if (g->regnum >= 8 && g->regnum <= 14)
                        mask &= ~(1u << g->regnum);
        return mask;
}

static void sh_record_global_reg(char *varname, int regnum) {
        struct sh_global_reg *g;
        for (g = sh_global_regs; g; g = g->next)
                if (g->varname == varname) {
                        if (g->regnum != regnum)
                                warning("#pragma global_register: %s rebound "
                                        "from R%d to R%d\n",
                                        varname, g->regnum, regnum);
                        g->regnum = regnum;
                        return;
                }
        NEW(g, PERM);
        g->varname = varname;
        g->regnum = regnum;
        g->next = sh_global_regs;
        sh_global_regs = g;
}

/* Raw-pointer ident read off cp. Returns interned string or NULL.
 * Does not call gettok(), so it cannot accidentally cross a newline
 * into the next source line. Stops at the first non-ident char. */
static char *sh_pragma_read_ident(void) {
        char *start;
        while (*cp == ' ' || *cp == '\t')
                cp++;
        if (!((*cp >= 'A' && *cp <= 'Z') ||
              (*cp >= 'a' && *cp <= 'z') ||
              *cp == '_'))
                return NULL;
        start = (char *)cp;
        while ((*cp >= 'A' && *cp <= 'Z') ||
               (*cp >= 'a' && *cp <= 'z') ||
               (*cp >= '0' && *cp <= '9') ||
               *cp == '_')
                cp++;
        return stringn(start, (char *)cp - start);
}

static void sh_pragma_skip_spaces(void) {
        while (*cp == ' ' || *cp == '\t')
                cp++;
}

/* Parse `(f1, f2, ...)` and set `attr` on each named function. */
static void sh_parse_func_list(const char *pragma_name, int attr) {
        char *fname;
        sh_pragma_skip_spaces();
        if (*cp != '(') {
                error("#pragma %s expects '('\n", pragma_name);
                return;
        }
        cp++;
        for (;;) {
                sh_pragma_skip_spaces();
                if (*cp == ')') { cp++; return; }
                if (*cp == '\n' || *cp == 0) {
                        error("#pragma %s missing ')'\n", pragma_name);
                        return;
                }
                fname = sh_pragma_read_ident();
                if (!fname) {
                        error("#pragma %s expects function identifier\n",
                              pragma_name);
                        return;
                }
                sh_record_func_attr(fname, attr);
                sh_pragma_skip_spaces();
                if (*cp == ',') { cp++; continue; }
                if (*cp == ')') { cp++; return; }
                error("#pragma %s expects ',' or ')'\n", pragma_name);
                return;
        }
}

/* Parse `(var1=Rn, var2=Rm, ...)`. Rn must be R8..R14. */
static void sh_parse_global_register(void) {
        char *var, *reg;
        int regnum;
        sh_pragma_skip_spaces();
        if (*cp != '(') {
                error("#pragma global_register expects '('\n");
                return;
        }
        cp++;
        for (;;) {
                sh_pragma_skip_spaces();
                if (*cp == ')') { cp++; return; }
                if (*cp == '\n' || *cp == 0) {
                        error("#pragma global_register missing ')'\n");
                        return;
                }
                var = sh_pragma_read_ident();
                if (!var) {
                        error("#pragma global_register expects variable name\n");
                        return;
                }
                sh_pragma_skip_spaces();
                if (*cp != '=') {
                        error("#pragma global_register expects '=' after %s\n",
                              var);
                        return;
                }
                cp++;
                reg = sh_pragma_read_ident();
                if (!reg) {
                        error("#pragma global_register expects register name\n");
                        return;
                }
                /* Parse Rn or rn where n is 8..14. */
                regnum = -1;
                if ((reg[0] == 'R' || reg[0] == 'r') &&
                    reg[1] >= '0' && reg[1] <= '9') {
                        regnum = reg[1] - '0';
                        if (reg[2] >= '0' && reg[2] <= '9') {
                                regnum = regnum * 10 + (reg[2] - '0');
                                if (reg[3] != 0)
                                        regnum = -1;
                        } else if (reg[2] != 0) {
                                regnum = -1;
                        }
                }
                if (regnum < 8 || regnum > 14) {
                        error("#pragma global_register: register must be "
                              "R8..R14, got %s\n", reg);
                        return;
                }
                sh_record_global_reg(var, regnum);
                sh_pragma_skip_spaces();
                if (*cp == ',') { cp++; continue; }
                if (*cp == ')') { cp++; return; }
                error("#pragma global_register expects ',' or ')'\n");
                return;
        }
}

/* #pragma handler wired up through the input.c hook. Recognizes:
 *   - `#pragma gbr_base (name)` — Hitachi GBR base symbol
 *   - `#pragma gbr_param` — Saturn-specific GBR prologue
 *   - `#pragma sh_word_indexed_after_first` — see sh_apply_word_indexed_after_first
 *   - `#pragma noregsave (f1, f2, ...)` — SHC v5.0 §3.10: skip
 *     prologue/epilogue save of R8..R14
 *   - `#pragma noregalloc (f1, f2, ...)` — SHC v5.0 §3.10: allocator
 *     does not touch R8..R14 (bridge pragma)
 *   - `#pragma global_register (var=Rn, ...)` — SHC v5.0 §3.11:
 *     TU-wide binding of a global variable to one of R8..R14
 *   - `#pragma sh_alloc_lowfirst (f1, ...)` — SH-specific low-first
 *     INTVAR allocation order
 *
 * Unknown pragmas are silently ignored (same behavior as unmodified
 * LCC). */
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
        } else if (strcmp(name, "gbr_param") == 0) {
                sh_gbr_param = 1;
        } else if (strcmp(name, "sh_word_indexed_after_first") == 0) {
                sh_word_indexed_after_first = 1;
        } else if (strcmp(name, "noregsave") == 0) {
                sh_parse_func_list("noregsave", SH_ATTR_NOREGSAVE);
        } else if (strcmp(name, "noregalloc") == 0) {
                sh_parse_func_list("noregalloc", SH_ATTR_NOREGALLOC);
        } else if (strcmp(name, "global_register") == 0) {
                sh_parse_global_register();
        } else if (strcmp(name, "sh_alloc_lowfirst") == 0) {
                sh_parse_func_list("sh_alloc_lowfirst", SH_ATTR_LOWFIRST);
        }
}

/* Switch jump table hook. Called from swcode() in stmt.c when a
 * dense switch range has 4+ cases. Emits bounds check + records
 * table metadata for post-capture emission of the SH-2 braf idiom. */
static int sh_switchjump(Swtch swp, long *v, int l, int u,
                         Symbol *labels, Symbol deflab,
                         int lolab, int hilab)
{
        int i, tablesize;
        Type ty = signedint(swp->sym->type);

        tablesize = (int)(v[u] - v[l] + 1);
        if (tablesize > SH_MAX_SWITCH_LABELS)
                return 0;

        /* Emit bounds checks. For a single dense bucket (lo/hi
         * both point to default), one GT check suffices. For split
         * buckets, emit both LT and GT. */
        {
                Type ty = signedint(swp->sym->type);
                if (lolab != deflab->u.l.label) {
                        listnodes(eqtree(LT,
                                cast(idtree(swp->sym), ty),
                                cnsttree(ty, v[l])),
                                lolab, 0);
                }
                listnodes(eqtree(GT,
                        cast(idtree(swp->sym), ty),
                        cnsttree(ty, v[u])),
                        hilab, 0);
                walk(NULL, 0, 0);
        }

        /* No definelab here — branch() in swstmt would equate
         * and remove it.  The post-capture pass finds the insertion
         * point by matching the bounds-check pattern instead. */

        /* Record metadata for the post-capture pass. */
        sh_switch.active = 1;
        sh_switch.min_val = (int)v[l];
        sh_switch.ncases = tablesize;
        snprintf(sh_switch.deflabel, sizeof sh_switch.deflabel,
                 "%s", deflab->x.name);
        snprintf(sh_switch.hilabel, sizeof sh_switch.hilabel,
                 "%s", findlabel(hilab)->x.name);
        {
                int idx = 0;
                long val;
                for (val = v[l]; val <= v[u]; val++) {
                        /* Find the label for this value, or use default. */
                        int found = 0;
                        for (i = l; i <= u; i++) {
                                if (v[i] == val) {
                                        snprintf(sh_switch.labels[idx],
                                                 sizeof sh_switch.labels[idx],
                                                 "%s", labels[i]->x.name);
                                        found = 1;
                                        break;
                                }
                        }
                        if (!found)
                                snprintf(sh_switch.labels[idx],
                                         sizeof sh_switch.labels[idx],
                                         "%s", deflab->x.name);
                        idx++;
                }
        }

        return 1;
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

/* Phase A.1 drain: process every captured function in source order.
 * Reverse-topo sort (callees before callers) lands in Phase B.
 * Each iteration restores codehead from the entry's snapshot inside
 * sh_process_deferred_fn so gencode()/emitcode() see the right
 * Code linked list. */
/* Phase B.1: Tarjan's strongly-connected-components algorithm.
 * Emits SCCs in reverse-topological order (callees before callers),
 * which is exactly the drain order we want. Recursion calls emit
 * SCCs into sh_scc_order[]; single-node SCCs are typical, cycles
 * (direct or mutual recursion) collapse into multi-node SCCs that
 * the write-set pass in Phase D will treat with the ABI-conservative
 * fallback among their members. */
#define SH_TARJAN_UNVISITED -1
static int *sh_tarjan_index;
static int *sh_tarjan_lowlink;
static char *sh_tarjan_onstack;
static int *sh_tarjan_stack;
static int sh_tarjan_stack_top;
static int sh_tarjan_next_idx;
static int *sh_scc_order;     /* indices into sh_ipa_arr, reverse-topo */
static int sh_scc_order_len;
static struct sh_ipa_fn **sh_ipa_arr;
static int sh_ipa_count;
static int **sh_cgraph;        /* cgraph[v] = int[]: callee indices in arr */
static int *sh_cgraph_nedges;

static void sh_tarjan_scc(int v) {
        int i, w;
        sh_tarjan_index[v] = sh_tarjan_next_idx;
        sh_tarjan_lowlink[v] = sh_tarjan_next_idx;
        sh_tarjan_next_idx++;
        sh_tarjan_stack[sh_tarjan_stack_top++] = v;
        sh_tarjan_onstack[v] = 1;
        for (i = 0; i < sh_cgraph_nedges[v]; i++) {
                w = sh_cgraph[v][i];
                if (sh_tarjan_index[w] == SH_TARJAN_UNVISITED) {
                        sh_tarjan_scc(w);
                        if (sh_tarjan_lowlink[w] < sh_tarjan_lowlink[v])
                                sh_tarjan_lowlink[v] =
                                        sh_tarjan_lowlink[w];
                } else if (sh_tarjan_onstack[w]) {
                        if (sh_tarjan_index[w] < sh_tarjan_lowlink[v])
                                sh_tarjan_lowlink[v] =
                                        sh_tarjan_index[w];
                }
        }
        if (sh_tarjan_lowlink[v] == sh_tarjan_index[v]) {
                do {
                        w = sh_tarjan_stack[--sh_tarjan_stack_top];
                        sh_tarjan_onstack[w] = 0;
                        sh_scc_order[sh_scc_order_len++] = w;
                } while (w != v);
        }
}

/* Build the cgraph from queue entries: array of entry pointers,
 * plus per-entry list of callee indices (skipping externs not in
 * the queue). Then run Tarjan to get reverse-topo order. */
static void sh_build_cgraph_and_order(void) {
        int i, j, k;
        struct sh_ipa_fn *e;
        sh_ipa_count = sh_ipa_nqueued;
        if (sh_ipa_count == 0)
                return;
        sh_ipa_arr = allocate(sh_ipa_count *
                              sizeof(struct sh_ipa_fn *), PERM);
        sh_cgraph = allocate(sh_ipa_count * sizeof(int *), PERM);
        sh_cgraph_nedges = allocate(sh_ipa_count * sizeof(int), PERM);
        i = 0;
        for (e = sh_ipa_queue; e; e = e->next)
                sh_ipa_arr[i++] = e;
        /* For each entry, translate direct_callees (Symbol *) to
         * indices in sh_ipa_arr by pointer equality of f. Callees
         * not in the queue (externs) are skipped — they get the
         * ABI-conservative fallback at their CALL sites. */
        for (i = 0; i < sh_ipa_count; i++) {
                int max = sh_ipa_arr[i]->n_direct_callees;
                int cnt = 0;
                int *buf;
                if (max == 0) {
                        sh_cgraph[i] = NULL;
                        sh_cgraph_nedges[i] = 0;
                        continue;
                }
                buf = allocate(max * sizeof(int), PERM);
                for (j = 0; j < max; j++) {
                        Symbol tgt = sh_ipa_arr[i]->direct_callees[j];
                        for (k = 0; k < sh_ipa_count; k++)
                                if (sh_ipa_arr[k]->f == tgt) {
                                        buf[cnt++] = k;
                                        break;
                                }
                }
                sh_cgraph[i] = buf;
                sh_cgraph_nedges[i] = cnt;
        }
        /* Run Tarjan */
        sh_tarjan_index = allocate(sh_ipa_count * sizeof(int), PERM);
        sh_tarjan_lowlink = allocate(sh_ipa_count * sizeof(int), PERM);
        sh_tarjan_onstack = allocate(sh_ipa_count * sizeof(char), PERM);
        sh_tarjan_stack = allocate(sh_ipa_count * sizeof(int), PERM);
        sh_scc_order = allocate(sh_ipa_count * sizeof(int), PERM);
        for (i = 0; i < sh_ipa_count; i++) {
                sh_tarjan_index[i] = SH_TARJAN_UNVISITED;
                sh_tarjan_lowlink[i] = 0;
                sh_tarjan_onstack[i] = 0;
        }
        sh_tarjan_next_idx = 0;
        sh_tarjan_stack_top = 0;
        sh_scc_order_len = 0;
        for (i = 0; i < sh_ipa_count; i++)
                if (sh_tarjan_index[i] == SH_TARJAN_UNVISITED)
                        sh_tarjan_scc(i);
}

/* Count ASM_INSN nodes in a single queue entry's Code list. */
static int sh_count_asm_insns(struct sh_ipa_fn *e) {
        Code cp;
        int n = 0;
        for (cp = e->code_head.next; cp; cp = cp->next) {
                Node node;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (node = cp->u.forest; node; node = node->link)
                        if (specific(node->op) == ASM_INSN+V)
                                n++;
        }
        return n;
}

/* Append ASM_INSN nodes from a single queue entry's Code list
 * into `arr`, returning the new count. Skips non-ASM_INSN
 * Nodes. Caller is responsible for capacity. */
static int sh_append_asm_insns(struct sh_ipa_fn *e,
                               struct sh_asm_insn **arr, int n) {
        Code cp;
        for (cp = e->code_head.next; cp; cp = cp->next) {
                Node node;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (node = cp->u.forest; node; node = node->link) {
                        struct sh_asm_insn *in;
                        if (specific(node->op) != ASM_INSN+V)
                                continue;
                        in = node->syms[0]
                             ? node->syms[0]->x.asm_insn : NULL;
                        if (!in) continue;
                        arr[n++] = in;
                }
        }
        return n;
}

/* Does this insn array contain an `rts`? Used to decide whether
 * the SHC drop-through chain has terminated. */
static int sh_array_has_rts(struct sh_asm_insn **arr, int n) {
        int i;
        for (i = 0; i < n; i++)
                if (arr[i]->mnemonic
                    && strcmp(arr[i]->mnemonic, "rts") == 0)
                        return 1;
        return 0;
}

/* Build a flat array of sh_asm_insn pointers for analysis.
 *
 * SHC multi-entry-point convention: short asm shims (one or two
 * instructions, no rts) drop through into the next function's
 * body. To analyze e's preserves-r4 status correctly, we have to
 * walk past e's last instruction into the adjacent functions
 * defined after it, until a body containing at least one rts is
 * seen. This mirrors the actual program flow at runtime.
 *
 * We chain up to SH_SIM_MAX_CHAIN entries to bound work; if no
 * rts appears in that window, the simulator's own walker will
 * eventually run off the end and bail conservatively.
 *
 * Caller provides a `start` queue entry. Returns the assembled
 * array (PERM-allocated) and the count via *n_out. */
/* TU-wide concatenated insn array. Built once per drain by
 * sh_build_tu_insn_array; freed at end of analysis. All naked-
 * shim entries' parsed instructions are concatenated in source
 * (queue) order. Labels, branches, and drop-through chains all
 * resolve naturally inside this array because the unity build's
 * naked emit produces them as one big .text section anyway.
 *
 * sh_tu_insn_start_of[i] holds the index where queue entry
 * sh_ipa_arr[i]'s first instruction lives in sh_tu_insns. -1
 * means the entry isn't a naked shim (mixed C+asm or no asm
 * nodes) and isn't represented in the concatenated array. */
static struct sh_asm_insn **sh_tu_insns;
static int sh_tu_insns_n;
static int *sh_tu_insn_start_of;

static void sh_build_tu_insn_array(void) {
        int i, n = 0, total = 0;
        sh_tu_insns = NULL;
        sh_tu_insns_n = 0;
        sh_tu_insn_start_of = NULL;
        if (sh_ipa_count == 0) return;
        sh_tu_insn_start_of = allocate(sh_ipa_count * sizeof(int), PERM);
        for (i = 0; i < sh_ipa_count; i++)
                sh_tu_insn_start_of[i] = -1;

        /* Iterate sh_ipa_queue in capture (source) order and
         * append each naked-shim entry's parsed insns. Mixed
         * bodies are skipped because the simulator can't analyze
         * C-derived Nodes. */
        {
                struct sh_ipa_fn *e;
                for (e = sh_ipa_queue; e; e = e->next)
                        if (sh_function_is_naked_shim(e))
                                total += sh_count_asm_insns(e);
        }
        if (total == 0) return;
        sh_tu_insns = allocate(total * sizeof(*sh_tu_insns), PERM);
        {
                struct sh_ipa_fn *e;
                for (e = sh_ipa_queue; e; e = e->next) {
                        if (!sh_function_is_naked_shim(e)) continue;
                        /* Find the queue entry's index in
                         * sh_ipa_arr to record the start. */
                        for (i = 0; i < sh_ipa_count; i++)
                                if (sh_ipa_arr[i] == e) {
                                        sh_tu_insn_start_of[i] = n;
                                        break;
                                }
                        n = sh_append_asm_insns(e, sh_tu_insns, n);
                }
        }
        sh_tu_insns_n = n;
}

/* Recursion guard for the on-demand sub-entry oracle path.
 * Real recursion is unlikely in our corpus (sub-entries don't
 * call back into the same parent's primary in a cycle), but
 * the guard prevents pathological inputs from wedging the
 * compiler. */
static int sh_phase_a_oracle_depth;
#define SH_PHASE_A_ORACLE_MAX_DEPTH 8

/* Look up the writes_r4 verdict for a callee by name.
 *
 *   1. Scan sh_ipa_arr for a primary entry matching the name.
 *      Use that entry's cached writes_r4. The reverse-topo
 *      analysis order ensures the answer is already computed
 *      for any direct callee a function asks about.
 *
 *   2. Otherwise, scan every queue entry's body for a
 *      `.asm_entry <name>` directive. If one matches, simulate
 *      from that directive's position to get a sub-entry verdict
 *      on demand. The recursion-depth guard stops runaway calls.
 *
 *   3. Otherwise, conservative: return 1 (writes). Externs
 *      outside the queue fall here.
 *
 * Returns 0 (preserves) or 1 (writes / unknown).
 */
static int sh_lookup_writes_r4(const char *name) {
        int i;
        if (!name) return 1;

        /* Primary entry. */
        for (i = 0; i < sh_ipa_count; i++) {
                struct sh_ipa_fn *e = sh_ipa_arr[i];
                if (e && e->f && e->f->name
                    && strcmp(e->f->name, name) == 0)
                        return e->writes_r4 ? 1 : 0;
        }

        /* Sub-entry: scan the TU-wide concatenated insn array for
         * a `.asm_entry <name>` directive. If found, simulate from
         * that position. Falls through to conservative WRITES if
         * the name isn't found anywhere in the TU. */
        if (sh_phase_a_oracle_depth >= SH_PHASE_A_ORACLE_MAX_DEPTH)
                return 1;
        sh_phase_a_oracle_depth++;
        if (sh_tu_insns && sh_tu_insns_n > 0) {
                int j;
                for (j = 0; j < sh_tu_insns_n; j++) {
                        struct sh_asm_insn *in = sh_tu_insns[j];
                        enum sh_sim_verdict v;
                        if (!in->is_entry) continue;
                        if (in->n_operands < 1
                            || in->operands[0].kind != SH_OP_LABEL
                            || !in->operands[0].label
                            || strcmp(in->operands[0].label, name)
                                  != 0)
                                continue;
                        v = sh_sim_preserves_r4(sh_tu_insns,
                                                sh_tu_insns_n, j,
                                                sh_phase_a_oracle,
                                                NULL);
                        sh_phase_a_oracle_depth--;
                        return v == SH_SIM_PRESERVES ? 0 : 1;
                }
        }
        sh_phase_a_oracle_depth--;
        return 1;
}

static enum sh_sim_verdict sh_phase_a_oracle(const char *name,
                                             void *user) {
        (void)user;
        return sh_lookup_writes_r4(name) ? SH_SIM_WRITES
                                         : SH_SIM_PRESERVES;
}

/* Phase C: reverse-topological analysis pass that populates
 * writes_r4 on every queue entry. Drain order is NOT changed by
 * this; only the cached answer is set. The main drain loop still
 * runs in source order (A.1 behavior) so no cross-function state
 * leaks surface. sh_build_cgraph_and_order() has already run and
 * sh_scc_order[] holds indices in reverse-topological order when
 * we're invoked.
 *
 * asm-shim Stage 3 — saturn/workstreams/asm_shim_design.md §6:
 * before inheriting from callees, walk the function's captured
 * Code list for ASM_INSN+V Nodes and OR in their parsed `writes`
 * masks. An asm instruction that writes r4 (e.g., `mov #X, r4` or
 * a load-into-r4) makes the enclosing function writes_r4 even if
 * it has no callees. This is what unlocks the IPA pin's correct
 * answer on asm-bodied functions like the FUN_06044F30 shim
 * Stage 4 will bring in. */
static void sh_analyze_writes_r4(void) {
        int i, j;
        for (i = 0; i < sh_scc_order_len; i++) {
                struct sh_ipa_fn *e = sh_ipa_arr[sh_scc_order[i]];
                Code cp;
                e->writes_r4 = 0;

                /* Naked-shim path: simulate against the TU-wide
                 * concatenated insn array so cross-body labels
                 * (a `bt label` whose target is in another
                 * function's body) and drop-through chains both
                 * resolve naturally. The unity build's naked
                 * emit already produces one big .text section,
                 * so this matches the actual program layout.
                 *
                 * Replaces the old "any ASM_INSN write → conservative"
                 * check, which was too coarse for functions like
                 * FUN_06044E3C that advance r4 across a counted
                 * loop and restore it before rts. */
                if (sh_function_is_naked_shim(e)) {
                        int idx = sh_scc_order[i];
                        int start;
                        enum sh_sim_verdict v = SH_SIM_WRITES;
                        start = (idx >= 0 && idx < sh_ipa_count)
                                ? sh_tu_insn_start_of[idx] : -1;
                        if (sh_tu_insns && sh_tu_insns_n > 0
                            && start >= 0) {
                                v = sh_sim_preserves_r4(
                                        sh_tu_insns,
                                        sh_tu_insns_n, start,
                                        sh_phase_a_oracle, NULL);
                        }
                        e->writes_r4 = v == SH_SIM_PRESERVES ? 0 : 1;
                        continue;
                }

                /* Mixed body path: the existing per-Node walk for
                 * direct writes from asm-derived Nodes in the
                 * captured DAG. The simulator isn't applicable
                 * here because C-derived Nodes aren't in its
                 * vocabulary. Inheritance from callees uses the
                 * same lookup helper the simulator's oracle does,
                 * so sub-entries (.asm_entry FUN_X labels inside
                 * other queue entries' asm bodies) are findable
                 * even though they aren't standalone queue
                 * entries. */
                for (cp = e->code_head.next; cp && !e->writes_r4;
                     cp = cp->next) {
                        Node n;
                        if (cp->kind != Gen && cp->kind != Jump
                            && cp->kind != Label)
                                continue;
                        for (n = cp->u.forest; n; n = n->link) {
                                if (specific(n->op) != ASM_INSN+V)
                                        continue;
                                if (n->syms[0]
                                    && n->syms[0]->x.asm_insn
                                    && (n->syms[0]->x.asm_insn->writes
                                        & (1u << 4))) {
                                        e->writes_r4 = 1;
                                        break;
                                }
                        }
                }
                if (e->writes_r4)
                        continue;

                /* Inheritance from callees. Each direct callee is
                 * a Symbol pointer; resolve to a writes_r4 verdict
                 * by name via sh_lookup_writes_r4 (handles
                 * primaries + sub-entries + extern fallback). */
                for (j = 0; j < e->n_direct_callees; j++) {
                        Symbol tgt = e->direct_callees[j];
                        if (!tgt || !tgt->name) {
                                e->writes_r4 = 1;
                                break;
                        }
                        if (sh_lookup_writes_r4(tgt->name)) {
                                e->writes_r4 = 1;
                                break;
                        }
                }
        }
}

static void sh_drain_ipa_queue(void) {
        struct sh_ipa_fn *e;
        int i;
        if (dflag && sh_ipa_nqueued > 0) {
                fprint(stderr, "[ipa] draining %d function(s)\n",
                       sh_ipa_nqueued);
                for (e = sh_ipa_queue; e; e = e->next) {
                        fprint(stderr, "[ipa]   %s ->",
                               e->f->name);
                        for (i = 0; i < e->n_direct_callees; i++)
                                fprint(stderr, " %s",
                                       e->direct_callees[i]->name);
                        fprint(stderr, "\n");
                }
        }
        /* Phase B.1: build cgraph and reverse-topo order via Tarjan
         * SCC. Phase C: use that order to populate writes_r4 on each
         * entry. Phase D: clobber() consults writes_r4 to narrow the
         * spill mask at CALL sites. The actual drain below stays in
         * source order — analysis is reverse-topo, emission is not. */
        sh_build_cgraph_and_order();
        sh_build_tu_insn_array();
        sh_analyze_writes_r4();
        if (dflag && sh_scc_order_len > 0) {
                fprint(stderr, "[ipa] writes_r4 analysis:\n");
                for (i = 0; i < sh_scc_order_len; i++) {
                        struct sh_ipa_fn *ee =
                                sh_ipa_arr[sh_scc_order[i]];
                        fprint(stderr, "[ipa]   %s writes_r4=%d\n",
                               ee->f->name, ee->writes_r4);
                }
        }
        sh_ipa_in_drain = 1;
        /* cseg tracks the section during parse-suppressed calls, so it
         * may already read CODE from a suppressed swtoseg(CODE) at
         * decl.c:812. Invalidate here so the first drain iteration's
         * segment(CODE) call actually emits the .text directive. */
        cseg = -1;
        /* B.1 infrastructure is built (cgraph + Tarjan SCC available
         * via sh_scc_order / sh_ipa_arr) but the drain still runs in
         * source order. Switching to reverse-topo order exposes more
         * cross-function state leaks than we can currently enumerate;
         * deferred to a follow-on once Phase D establishes whether we
         * actually need reverse-topo drain or can compute write-sets
         * in a pre-pass that keeps source-order emission. */
        (void)i;
        (void)sh_scc_order;
        for (e = sh_ipa_queue; e; e = e->next)
                sh_process_deferred_fn(e);
        sh_ipa_in_drain = 0;
}

static void progend(void) {
        int i, base_idx = -1;
        sh_drain_ipa_queue();
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
                else if (strcmp(argv[i], "-d-asm") == 0)
                        sh_dflag_asm = 1;
                else if (strcmp(argv[i], "-d-sim") == 0)
                        sh_dflag_sim = 1;
        shc_pragma_hook = sh_pragma;
        flush_deferred_pragmas();
        for (i = 0; i < 16; i++)
                ireg[i] = mkreg("%d", i, 1, IREG);
        ireg[15]->x.name = "15";
        /* Build a priority-ordered wildcard array so askreg's 31→0
         * scan picks registers in the order Hitachi SHC uses:
         *   INTTMP: r0, r1, r2, r3      (slots 31-28)
         *   INTVAR descending: r14..r8  (slots 27-21)
         * r0 first matches SHC's scratch preference (privileged
         * addressing modes make r0 valuable). Other regs (r4-r7
         * args, r15 SP) are placed at lower indices — they're
         * rarely allocated through the wildcard but must be present
         * for spill/reload paths. */
        for (i = 0; i < 32; i++)
                ireg_prio[i] = NULL;
        ireg_prio[31] = ireg[0];
        ireg_prio[30] = ireg[1];
        ireg_prio[29] = ireg[2];
        ireg_prio[28] = ireg[3];
        ireg_prio[27] = ireg[14];
        ireg_prio[26] = ireg[13];
        ireg_prio[25] = ireg[12];
        ireg_prio[24] = ireg[11];
        ireg_prio[23] = ireg[10];
        ireg_prio[22] = ireg[9];
        ireg_prio[21] = ireg[8];
        ireg_prio[20] = ireg[4];
        ireg_prio[19] = ireg[5];
        ireg_prio[18] = ireg[6];
        ireg_prio[17] = ireg[7];
        ireg_prio[16] = ireg[15];
        iregw = mkwildcard(ireg_prio);
        tmask[IREG] = INTTMP | 0x000000f0;  /* H2 spike: include r4-r7 as caller-saved scratch once freed by putreg */
        vmask[IREG] = INTVAR;
        tmask[FREG] = 0;
        vmask[FREG] = 0;

        /* #pragma global_register(var=Rn): SHC v5.0 §3.11 — pin a
         * named global to one of R8..R14 TU-wide. flush_deferred_pragmas
         * above has already populated sh_global_regs for pragmas that
         * appeared before this point; any later pragma runs through
         * the live sh_pragma hook. Either way we can carve the pinned
         * registers out of both tmask and vmask here so the allocator
         * never places anything else in them.
         *
         * NOTE: full binding semantics (reads/writes of the named var
         * emitting direct register accesses) are a separate workstream
         * item — this step only guarantees the reservation. Without
         * binding, Phase E's TU auto-generation will still need to
         * pair global_register with compiler-recognized register-home
         * declarations on the C side. The exclusion is correct and
         * useful on its own for preventing allocator stomps. */
        {
                struct sh_global_reg *g;
                for (g = sh_global_regs; g; g = g->next) {
                        unsigned bit = 1u << g->regnum;
                        tmask[IREG] &= ~bit;
                        vmask[IREG] &= ~bit;
                }
        }
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
                rtarget(p, 0, ireg[3]);
                break;
        case RET+I: case RET+U: case RET+P:
                rtarget(p, 0, ireg[0]);
                break;
        /* LOAD target propagation skipped — VREG symbols can't
         * be passed to rtarget (assertion). The register coalescing
         * peephole in sh_coalesce_move_chains() handles this case
         * instead by collapsing mov rA,rB; <op> rX,rB; mov rB,rC
         * sequences in the captured body. */
        case ARG+I: case ARG+P: case ARG+U: {
                Symbol q = argreg(p->x.argno);
                /* Phase E.1a: redirect ARG(argno=0) rtarget from
                 * ireg[argno] to the pinned parameter Symbol when
                 * IPA has engaged the r4 pin for the current
                 * function. ireg[4] has sclass=0 (from mkreg's
                 * NEW0), so rtargeting ARG's kid chain to ireg[4]
                 * either inserts a LOAD wrapper (when the kid's
                 * syms[RX] is the non-wildcard pinned Symbol) or
                 * drives allocation through getreg → askfixedreg
                 * → spillee's vbl-bound assert (Phase D's crash).
                 * Rtargeting to pinned_param instead yields
                 * r == q->syms[RX] inside gen.c's rtarget, which
                 * skips the LOAD wrap, and ralloc short-circuits
                 * at gen.c:655 because pinned_param is REGISTER-
                 * class. pinned_param is populated only after a
                 * successful askregvar in sh_ipa_try_engage_pin
                 * (Phase E.1b); until then this branch is dead. */
                if (sh_ipa_current
                    && sh_ipa_current->pinned_param
                    && sh_ipa_current->pinned_reg == 4
                    && p->x.argno == 0)
                        q = sh_ipa_current->pinned_param;
                /* Phase E.2: Shape 2's pinned local plays the
                 * same role as Shape 1's pinned parameter at the
                 * ARG site. The redirect lets the existing kid-
                 * chain rtarget walk propagate the local's
                 * register down through INDIR(ADDRL(local)) and
                 * elide the redundant load-into-r4 that would
                 * otherwise appear before every call. */
                else if (sh_ipa_current
                         && sh_ipa_current->pinned_local
                         && sh_ipa_current->pinned_reg == 4
                         && p->x.argno == 0)
                        q = sh_ipa_current->pinned_local;
                if (q) {
                        rtarget(p, 0, q);
                        /* Propagate the arg register down through
                         * simple convert/load chains so the entire
                         * expression uses the arg register, enabling
                         * the delay-slot filler to move the final
                         * convert across pool loads into a jsr delay
                         * slot without register conflicts.
                         *
                         * Stop propagation when the child is already
                         * in a non-wildcard register (e.g. a VREG for
                         * a register variable or parameter). In that
                         * case rtarget would insert a LOAD wrapper,
                         * and following n->kids[0] into the wrapper
                         * creates an infinite allocation loop. */
                        {
                                Node n = p->kids[0];
                                while (n && n->kids[0]) {
                                        int g = generic(n->op);
                                        if (g == CVI || g == CVU
                                            || g == CVP || g == INDIR
                                            || g == LOAD) {
                                                Symbol kid_r = n->kids[0]->syms[RX];
                                                if (kid_r && !kid_r->x.wildcard
                                                    && kid_r != q)
                                                        break;
                                                rtarget(n, 0, q);
                                        } else
                                                break;
                                        n = n->kids[0];
                                }
                        }
                }
                break;
                }
        case EQ+I: case NE+I: case EQ+U: case NE+U: {
                Node k1 = p->kids[1];
                if (k1 && generic(k1->op) == CNST) {
                        int v = (int)k1->syms[0]->u.c.v.i;
                        if (v != 0 && v >= -128 && v <= 127)
                                rtarget(p, 0, ireg[0]);
                }
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

/* sh_prealloc_mask: SHC's r0-preference heuristic.
 *
 * SHC uses r0 as a general scratch register because of r0's
 * privileged addressing modes (@(R0,Rn) indexed, tst #imm,r0,
 * gbr-relative byte loads). But values that must persist across
 * r0-clobbering operations can't live in r0 — the next indexed
 * load or CALL would corrupt them. SHC's allocator handles this
 * via lifetime awareness; we reproduce the effect here by masking
 * r0 out of the availability set when the symbol's lifetime crosses
 * an r0-clobbering node.
 *
 * Hazardous intermediate nodes:
 *   - generic(op) == CALL: writes r0 with the return value
 *   - syms[RX] targets r0 via setreg/rtarget: explicit r0 binding
 *
 * Walking the linear chain from p->x.next to sym->x.lastuse lets us
 * see the value's entire forward lifetime. Short-lived values
 * (lastuse == p) bypass the walk entirely — r0 stays available,
 * matching SHC's pattern of using r0 for immediately-consumed loads. */
static unsigned sh_prealloc_mask(Symbol sym, Node p, unsigned m) {
        Node n, last = NULL;
        int i;
        if (!sym || !p)
                return m;

        /* asm-shim Stage 5 (saturn/workstreams/asm_shim_design.md §8):
         * walk backward through the linear Node sequence accumulating
         * register writes from any ASM_INSN+V Nodes encountered. Stop
         * at the first CALL going backward — the call's ABI clobber
         * is presumed to have consumed any prior asm-set values, so
         * we only care about asm writes since the last call. The
         * accumulated mask is registers the asm has just written and
         * a downstream consumer (typically the next call) is expected
         * to read; allocation onto these registers between asm and
         * consumer would silently stomp the asm-set value. */
        {
                unsigned blocked_by_asm = 0;
                for (n = p->x.prev; n; n = n->x.prev) {
                        if (generic(n->op) == CALL)
                                break;
                        if (specific(n->op) == ASM_INSN+V
                            && n->syms[0]
                            && n->syms[0]->x.asm_insn)
                                blocked_by_asm |=
                                        n->syms[0]->x.asm_insn->writes;
                }
                m &= ~blocked_by_asm;
        }
        /* Find p's lastuse by walking the linear forest forward, looking
         * for the last node that references p in its kids. We can't rely
         * on sym->x.lastuse because the symbol here is typically a
         * wildcard (not a real temporary), and wildcards don't track
         * lastuse. Kid-pointer scan is O(n) per allocation but accurate. */
        for (n = p->x.next; n; n = n->x.next)
                for (i = 0; i < NELEMS(n->x.kids) && n->x.kids[i]; i++)
                        if (n->x.kids[i] == p) {
                                last = n;
                                break;
                        }
        if (!last)
                return m;  /* no future use — value is dead after p, r0 safe */
        /* r0 is hazardous if any intermediate node (strictly between p
         * and last) writes r0. Three cases catch the common patterns:
         *
         *  (a) CALL: writes r0 with return value.
         *  (b) Specific r0 target bound via setreg/rtarget.
         *  (c) 1/2-byte INDIR loads — SH-2 has no mov.b/mov.w disp form
         *      that targets anything but r0, so our emit hardcodes r0
         *      as the load's landing register and may copy out to the
         *      allocator-assigned dst afterwards. From a lifetime
         *      analysis POV these ops WRITE r0 regardless of dst.
         *
         * Matches SHC's "mov.w @(...), r0; mov r0, r1" idiom — if the
         * load's value must persist across later r0-writing ops, it
         * goes to r1+. r0 only for immediately-consumed loads. */
        for (n = p->x.next; n && n != last; n = n->x.next) {
                if (generic(n->op) == CALL)
                        return m & ~0x1u;
                if (n->syms[RX] && n->syms[RX]->x.regnode
                    && n->syms[RX]->x.regnode->number == 0
                    && n->syms[RX]->x.regnode->set == IREG)
                        return m & ~0x1u;
                if (generic(n->op) == INDIR) {
                        int sz = opsize(n->op);
                        if (sz == 1 || sz == 2)
                                return m & ~0x1u;
                }
        }
        return m;
}

static void emit2(Node p) {
        int lab, dst, src;
        int sz;
        char *suf;
        Symbol s;
        char *base;
        switch (specific(p->op)) {
        case LABEL+V: {
                /* Two flavors of LABEL+V reach us: normal labels
                 * (u.l.label >= 1, from genlabel()) emit as `Lnn:`,
                 * and the legacy asm-fallback pseudo-label
                 * (u.l.label == 0) emits the symbol's name with a
                 * single leading tab. The asm-shim Stage 2 path
                 * uses ASM_INSN+V Nodes instead; LABEL+V with
                 * sentinel only fires when a parsed asm body
                 * isn't present (e.g., a backend with no parser,
                 * or a future path that constructs ASMB without
                 * going through asm_block's hook). */
                Symbol ls = p->syms[0];
                if (ls->u.l.label == 0) {
                        /* Legacy fallback: print captured text raw
                         * with one tab. */
                        print("\t%s\n", ls->name);
                } else
                        print("%s:\n", ls->x.name);
                break;
                }
        case ASM_INSN+V: {
                /* asm-shim Stage 2: canonical re-emit from the parsed
                 * insn record. One uniform `\t<mn>\t<ops>\n` layout
                 * for every asm-derived line. Source whitespace is
                 * discarded; assembled-byte equivalence is preserved
                 * (same instruction, same operands, same encoding).
                 * See saturn/workstreams/asm_shim_design.md §5c. */
                Symbol ls = p->syms[0];
                struct sh_asm_insn *in = ls->x.asm_insn;
                if (sh_dflag_asm) {
                        /* Per-insn dump for regtest greppability.
                         * Flags: B=branch C=call D=directive L=label
                         * M=comment U=unknown. */
                        char flags[16];
                        int fl = 0;
                        flags[fl++] = '[';
                        if (in->is_branch)    flags[fl++] = 'B';
                        if (in->is_call)      flags[fl++] = 'C';
                        if (in->is_directive) flags[fl++] = 'D';
                        if (in->is_label)     flags[fl++] = 'L';
                        if (in->is_comment)   flags[fl++] = 'M';
                        if (in->is_unknown)   flags[fl++] = 'U';
                        flags[fl++] = ']';
                        flags[fl] = 0;
                        fprint(stderr,
                               "[asm-emit] %s mn=%s reads=0x%x writes=0x%x sr_r=0x%x sr_w=0x%x\n",
                               flags,
                               in->mnemonic ? in->mnemonic : "(none)",
                               (unsigned)in->reads,
                               (unsigned)in->writes,
                               (unsigned)in->reads_sreg,
                               (unsigned)in->writes_sreg);
                }
                sh_emit_asm_insn(in);
                break;
                }
        case CNST+I: case CNST+U: {
                int val = (int)p->syms[0]->u.c.v.i;
                dst = getregnum(p);
                if ((int)(short)val == val) {
                        lab = shlit_word(val);
                        print("\tmov.w\tL%d,r%d\n", lab, dst);
                } else {
                        lab = shlit_num(val);
                        print("\tmov.l\tL%d,r%d\n", lab, dst);
                }
                break;
                }
        case CNST+P: {
                /* Pointer-typed literals always use mov.l + .4byte,
                 * regardless of whether the value happens to fit in
                 * sign-extended 16 bits.  SHC's idiom is consistent:
                 * addresses go through the long pool.  Compacting
                 * them to mov.w would save 2 bytes but shift every
                 * later pool offset and diverge from prod's byte
                 * layout with no semantic benefit. */
                int val = (int)p->syms[0]->u.c.v.i;
                dst = getregnum(p);
                lab = shlit_num(val);
                print("\tmov.l\tL%d,r%d\n", lab, dst);
                break;
                }
        case ADDRG+P:
                lab = shlit_sym(p->syms[0]->x.name);
                dst = getregnum(p);
                print("\tmov.l\tL%d,r%d\n", lab, dst);
                break;
        case ADDRF+P: {
                int disp, off;
                char *b;
                off = p->syms[0] ? p->syms[0]->x.offset : 0;
                dst = getregnum(p);
                /* Standalone ADDRFP4 (i.e., &param used as a value)
                 * computes the caller-frame address. With FP active
                 * the base is r14 and disp = off + sizeisave; when
                 * FP is skipped r15 still sits at orig_sp -
                 * sizeisave, so r15 + off + sizeisave points at the
                 * same slot. */
                if (sh_fp_active) {
                        b = "r14";
                        disp = off + sh_sizeisave;
                } else {
                        b = "r15";
                        disp = off + sh_sizeisave;
                }
                print("\tmov\t%s,r%d\n", b, dst);
                print("\tadd\t#%d,r%d\n", disp, dst);
                break;
                }
        case ADDRL+P: {
                int disp;
                dst = getregnum(p);
                disp = sh_localsize
                       + (p->syms[0] ? p->syms[0]->x.offset : 0);
                print("\tmov\tr15,r%d\n", dst);
                print("\tadd\t#%d,r%d\n", disp, dst);
                break;
                }
        case INDIR+I: case INDIR+U: case INDIR+P: {
                int disp, off;
                int kop;
                if (!p->kids[0])
                        break;
                kop = generic(p->kids[0]->op);
                /* INDIR(VREGP) uses a `# read register` template
                 * that routes through emit2 but is intentionally a
                 * no-op: the value already lives in the register
                 * assigned to the node. Only ADDRG/ADDRF/ADDRL/ADD
                 * kids want real code emission here. */
                if (kop == ADD) {
                        /* Displacement load via INDIR(ADD(reg,immi8)).
                         * Indexed loads (ADD reg+reg) are NOT handled
                         * via compound rules — they cause register
                         * conflicts when the destination collides with
                         * an input. Instead, indexed conversion is
                         * done by sh_route_via_r0() peephole on the
                         * regular add+indirect output. */
                        int breg = getregnum(p->x.kids[0]);
                        int dval = (int)p->kids[0]->kids[1]
                                        ->syms[0]->u.c.v.i;
                        dst = getregnum(p);
                        sz = opsize(p->op);
                        suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                        if (sz == 4) {
                                print("\tmov.l\t@(%d,r%d),r%d\n",
                                      dval, breg, dst);
                        } else {
                                print("\tmov.%s\t@(%d,r%d),r0\n",
                                      suf, dval, breg);
                                if (dst != 0)
                                        print("\tmov\tr0,r%d\n", dst);
                        }
                        break;
                }
                if (kop != ADDRG && kop != ADDRF && kop != ADDRL)
                        break;
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
                 * localsize + offset. The disp field in
                 * mov.? @(disp,Rn),Rm is 4 bits scaled by the access
                 * size, so the usable range is 0..15 bytes / 0..30
                 * words / 0..60 longs. Anything outside that falls
                 * back to the compute-address-then-indirect form. */
                off = s ? s->x.offset : 0;
                if (kop == ADDRF) {
                        disp = off + sh_sizeisave;
                        if (!sh_fp_active && sh_sp_locals_only)
                                disp += sh_localsize;
                        base = sh_fp_active ? "r14" : "r15";
                } else {
                        disp = sh_localsize + off;
                        base = "r15";
                }
                suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                {
                        int max_disp = sz == 1 ? 15 : sz == 2 ? 30 : 60;
                        int fits = disp >= 0 && disp <= max_disp
                                   && (disp % sz) == 0;
                        if (!fits) {
                                print("\tmov\t%s,r%d\n", base, dst);
                                print("\tadd\t#%d,r%d\n", disp, dst);
                                print("\tmov.%s\t@r%d,r%d\n",
                                      suf, dst, dst);
                                if (sz < 4 && optype(p->op) == I)
                                        print("\texts.%s\tr%d,r%d\n",
                                              suf, dst, dst);
                                else if (sz < 4 && optype(p->op) == U)
                                        print("\textu.%s\tr%d,r%d\n",
                                              suf, dst, dst);
                                break;
                        }
                }
                if (sz == 4) {
                        print("\tmov.l\t@(%d,%s),r%d\n", disp, base, dst);
                } else {
                        print("\tmov.%s\t@(%d,%s),r0\n", suf, disp, base);
                        if (optype(p->op) == I)
                                print("\texts.%s\tr0,r0\n", suf);
                        else
                                print("\textu.%s\tr0,r0\n", suf);
                        if (dst != 0)
                                print("\tmov\tr0,r%d\n", dst);
                }
                break;
                }
        case ASGN+I: case ASGN+U: case ASGN+P: {
                int disp, off;
                int kop;
                if (!p->kids[0])
                        break;
                /* 8-byte mulstore: ASGNI8/U8(ADDRLP4, mulhi_{s,u}).
                 * Stores dmuls.l/dmulu.l result into two 4-byte
                 * halves of a longlong local — low word (MACL) at
                 * offset 0, high word (MACH) at offset 4. */
                if (opsize(p->op) == 8
                    && specific(p->kids[0]->op) == ADDRL+P
                    && p->kids[1]) {
                        Node mul = p->kids[1];
                        while (mul && (generic(mul->op) == LOAD
                                    || generic(mul->op) == CVI
                                    || generic(mul->op) == CVU))
                                mul = mul->kids[0];
                        if (mul && generic(mul->op) == MUL
                            && opsize(mul->op) == 8) {
                                int r1 = getregnum(mul->kids[0]->kids[0]);
                                int r2 = getregnum(mul->kids[1]->kids[0]);
                                int soff = p->kids[0]->syms[0]->x.offset
                                    + framesize;
                                sh_uses_macl = 1;
                                print("\t%s\tr%d,r%d\n",
                                    optype(mul->op) == I
                                        ? "dmuls.l" : "dmulu.l",
                                    r1, r2);
                                print("\tsts\tmacl,@(%d,r14)\n", soff);
                                print("\tsts\tmach,@(%d,r14)\n", soff + 4);
                                break;
                        }
                }
                kop = generic(p->kids[0]->op);
                /* Same no-op bail-out as INDIR: ASGN(VREGP,reg)
                 * routes through emit2 but doesn't need any output
                 * — the value is already in the destination register. */
                if (kop == ADD) {
                        /* Displacement store via ASGN(ADD(reg,immi8),reg). */
                        int breg = getregnum(p->x.kids[0]);
                        int dval = (int)p->kids[0]->kids[1]
                                        ->syms[0]->u.c.v.i;
                        sz = opsize(p->op);
                        suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                        src = getregnum(p->kids[1]);
                        if (sz == 4) {
                                print("\tmov.l\tr%d,@(%d,r%d)\n",
                                      src, dval, breg);
                        } else {
                                if (src != 0)
                                        print("\tmov\tr%d,r0\n", src);
                                print("\tmov.%s\tr0,@(%d,r%d)\n",
                                      suf, dval, breg);
                        }
                        break;
                }
                if (kop != ADDRG && kop != ADDRF && kop != ADDRL)
                        break;
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
                        if (!sh_fp_active && sh_sp_locals_only)
                                disp += sh_localsize;
                        base = sh_fp_active ? "r14" : "r15";
                } else {
                        disp = sh_localsize + off;
                        base = "r15";
                }
                suf = sz == 1 ? "b" : sz == 2 ? "w" : "l";
                {
                        int max_disp = sz == 1 ? 15 : sz == 2 ? 30 : 60;
                        int fits = disp >= 0 && disp <= max_disp
                                   && (disp % sz) == 0;
                        if (!fits) {
                                /* Use r1 as a scratch address register.
                                 * r1 is in INTTMP and clobber() has
                                 * already spilled it around calls. */
                                print("\tmov\t%s,r1\n", base);
                                print("\tadd\t#%d,r1\n", disp);
                                print("\tmov.%s\tr%d,@r1\n", suf, src);
                                break;
                        }
                }
                if (sz == 4) {
                        print("\tmov.l\tr%d,@(%d,%s)\n", src, disp, base);
                } else {
                        if (src != 0)
                                print("\tmov\tr%d,r0\n", src);
                        print("\tmov.%s\tr0,@(%d,%s)\n", suf, disp, base);
                }
                break;
                }
        case ARG+I: case ARG+U: case ARG+P:
                /* argno 0..3 pass in r4..r7 (handled by target()
                 * via rtarget). argno >= 4 go on the caller's
                 * outgoing-arg area. doarg() records the raw
                 * mkactual offset (including the 16 bytes nominally
                 * reserved for the four register-passed slots);
                 * subtract 16 here so the actual store lands at
                 * @(0,r15) for the first stack arg. */
                if (p->x.argno < 4)
                        break;
                src = getregnum(p->x.kids[0]);
                print("\tmov.l\tr%d,@(%d,r15)\n",
                      src, (int)p->syms[2]->u.c.v.i - 16);
                break;
        case EQ+I: case EQ+U: case NE+I: case NE+U: {
                /* Get the immediate value from kids[1].  Normally
                 * kids[1] is a CNSTI4 with the value in syms[0].
                 * When the same constant appears in a short-circuit
                 * && chain, LCC CSEs it into a VREG; kids[1] becomes
                 * INDIRI4(VREG+P) and syms[0] is NULL.  Recover the
                 * value by following the VREG's CSE pointer back to
                 * the original CNSTI4 node. */
                Node imm = p->kids[1];
                if (imm->syms[0] == NULL
                    && generic(imm->op) == INDIR
                    && imm->kids[0]
                    && imm->kids[0]->syms[0]
                    && imm->kids[0]->syms[0]->u.t.cse)
                        imm = imm->kids[0]->syms[0]->u.t.cse;
                assert(imm->syms[0]);
                src = getregnum(p->kids[0]);
                if (src != 0)
                        print("\tmov\tr%d,r0\n", src);
                print("\tcmp/eq\t#%d,r0\n",
                      (int)imm->syms[0]->u.c.v.i);
                print("\t%s\t%s\n",
                      (generic(p->op) == EQ) ? "bt" : "bf",
                      p->syms[0]->x.name);
                break;
                }
        case MUL+I: case MUL+U:
                dst = getregnum(p);
                sh_uses_macl = 1;
                if (p->mul_src_width && p->mul_src_width <= 2) {
                        print("\tmuls.w\tr%d,r%d\n",
                              getregnum(p->kids[1]),
                              getregnum(p->kids[0]));
                } else {
                        print("\tmul.l\tr%d,r%d\n",
                              getregnum(p->kids[1]),
                              getregnum(p->kids[0]));
                }
                print("\tsts\tmacl,r%d\n", dst);
                break;
        case CVI+I: case CVU+I: case CVI+U: case CVU+U:
        case LOAD+I: case LOAD+U: {
                /* 64-bit multiply-LOW idiom: narrowing from an 8-byte
                 * MULI8/MULU8 tree to a 4-byte result. Ghidra emits
                 * `(uint)((longlong)a * (longlong)b)` / `(int)...` and
                 * lcc lowers that to CVxI4/CVxU4(MULI8(...)); then the
                 * prelabel CVI/CVU-narrowing rewrite in gen.c turns
                 * those into LOAD_I4 / LOAD_U4 wrappers. Dispatch all
                 * four pre-rewrite shapes and the two post-rewrite
                 * shapes through this handler so the emit stays the
                 * same: dmuls.l / dmulu.l + sts MACL. The mul-HIGH
                 * sibling lives in case RSH+U (opsize 8).
                 *
                 * CVxI4(INDIRI8/U8(ADDRLP4)) — load low 4 bytes of an
                 * 8-byte local slot (stored earlier by the ASGNI8
                 * mulstore8 rules). Just emit mov.l @(off,fp),r. */
                Node k = p->kids[0];
                if (k && (generic(k->op) == INDIR)
                    && k->kids[0]
                    && (specific(k->kids[0]->op) == ADDRL+P)) {
                        int off = k->kids[0]->syms[0]->x.offset + framesize;
                        dst = getregnum(p);
                        print("\tmov.l\t@(%d,r14),r%d\n", off, dst);
                        break;
                }
                while (k && (generic(k->op) == LOAD
                          || generic(k->op) == CVI
                          || generic(k->op) == CVU))
                        k = k->kids[0];
                if (k && generic(k->op) == MUL && opsize(k->op) == 8
                    && k->kids[0] && k->kids[1]
                    && k->kids[0]->kids[0] && k->kids[1]->kids[0]) {
                        int r1 = getregnum(k->kids[0]->kids[0]);
                        int r2 = getregnum(k->kids[1]->kids[0]);
                        dst = getregnum(p);
                        sh_uses_macl = 1;
                        print("\t%s\tr%d,r%d\n",
                              optype(k->op) == I ? "dmuls.l" : "dmulu.l",
                              r1, r2);
                        print("\tsts\tmacl,r%d\n", dst);
                        break;
                }
                /* Fall through: other CVI+I / CVU+I cases (size-4
                 * passthrough, size-8 narrow) emit nothing — the
                 * register was already the right width. */
                break;
        }
        case LSH+I: case LSH+U: {
                /* Composite left shift — decompose into shll/shll2/
                 * shll8/shll16 sequences. */
                int n;
                Node rhs;
                dst = getregnum(p);
                src = getregnum(p->kids[0]);
                /* p->kids[1] is normally a CNST, but CSE may have
                 * rewritten it to INDIRI4(VREGP) that inherited a
                 * conshi label from the original. Walk through
                 * syms[RX]->u.t.cse to reach the real CNST node. */
                rhs = p->kids[1];
                if (!rhs->syms[0] && rhs->syms[RX]
                    && rhs->syms[RX]->u.t.cse)
                        rhs = rhs->syms[RX]->u.t.cse;
                n = (int)rhs->syms[0]->u.c.v.i;
                if (dst != src)
                        print("\tmov\tr%d,r%d\n", src, dst);
                while (n >= 16) { print("\tshll16\tr%d\n", dst); n -= 16; }
                while (n >= 8)  { print("\tshll8\tr%d\n", dst);  n -= 8; }
                while (n >= 2)  { print("\tshll2\tr%d\n", dst);  n -= 2; }
                while (n >= 1)  { print("\tshll\tr%d\n", dst);   n -= 1; }
                break;
        }
        case RSH+I: case RSH+U: {
                /* Composite right shift. Unsigned uses shlr/shlr2/
                 * shlr8/shlr16; signed uses repeated shar (no
                 * multi-bit arithmetic right shift on SH-2). */
                int n, is_signed;

                /* 64-bit mul-high idiom: RSHU8(MULI8/MULU8(...), 32)
                 * LCC wraps the mul in LOAD and/or CV nodes; the
                 * lburg mulhi_s / mulhi_u nonterminals peel them
                 * off, and here we walk down past the same wrappers
                 * to reach the MULI8/MULU8 node itself. Emit
                 * dmuls.l (signed) or dmulu.l (unsigned) + sts mach.
                 * Any other 64-bit arithmetic use will fail with
                 * "Bad terminal" — we intentionally do not claim
                 * general long-long support. */
                if (opsize(p->op) == 8
                    && p->kids[0]
                    && generic(p->kids[0]->op) == INDIR
                    && p->kids[0]->kids[0]
                    && specific(p->kids[0]->kids[0]->op) == ADDRL+P) {
                        /* RSHU8(INDIRI8/U8(ADDRLP4), 32) — load high
                         * half of an 8-byte local (written earlier by
                         * mulstore8). Just mov.l the +4 slot. */
                        int off = p->kids[0]->kids[0]->syms[0]->x.offset
                            + framesize;
                        dst = getregnum(p);
                        print("\tmov.l\t@(%d,r14),r%d\n", off + 4, dst);
                        break;
                }
                if (opsize(p->op) == 8) {
                        Node mul = p->kids[0];
                        int r1, r2, is_signed_mul;
                        while (generic(mul->op) == LOAD
                               || generic(mul->op) == CVI
                               || generic(mul->op) == CVU)
                                mul = mul->kids[0];
                        is_signed_mul = (optype(mul->op) == I);
                        /* inputs are CVII8(reg) / CVIU8(reg) pairs */
                        r1 = getregnum(mul->kids[0]->kids[0]);
                        r2 = getregnum(mul->kids[1]->kids[0]);
                        dst = getregnum(p);
                        sh_uses_macl = 1;
                        print("\t%s\tr%d,r%d\n",
                              is_signed_mul ? "dmuls.l" : "dmulu.l",
                              r1, r2);
                        print("\tsts\tmach,r%d\n", dst);
                        break;
                }

                dst = getregnum(p);
                src = getregnum(p->kids[0]);
                {
                        Node rhs = p->kids[1];
                        if (!rhs->syms[0] && rhs->syms[RX]
                            && rhs->syms[RX]->u.t.cse)
                                rhs = rhs->syms[RX]->u.t.cse;
                        n = (int)rhs->syms[0]->u.c.v.i;
                }
                is_signed = (generic(p->op) == RSH)
                            && (optype(p->op) == I);
                if (dst != src)
                        print("\tmov\tr%d,r%d\n", src, dst);
                if (is_signed) {
                        while (n >= 1) {
                                print("\tshar\tr%d\n", dst);
                                n -= 1;
                        }
                } else {
                        while (n >= 16) { print("\tshlr16\tr%d\n", dst); n -= 16; }
                        while (n >= 8)  { print("\tshlr8\tr%d\n", dst);  n -= 8; }
                        while (n >= 2)  { print("\tshlr2\tr%d\n", dst);  n -= 2; }
                        while (n >= 1)  { print("\tshlr\tr%d\n", dst);   n -= 1; }
                }
                break;
        }
        }
}

static void doarg(Node p) {
        /* argoffset is advanced for every arg (including the
         * register-passed ones) so LCC's per-call reset logic
         * (if (argoffset == 0) argno = 0) keeps working. The
         * returned slot offset is then shifted by -16 at
         * emit-time in emit2() for stack-passed args, so the
         * caller's outgoing-arg area only holds the args 4+ and
         * doesn't waste 16 bytes on the register-passed slots. */
        static int argno;
        if (argoffset == 0)
                argno = 0;
        p->x.argno = argno++;
        p->syms[2] = intconst(mkactual(4, p->syms[0]->u.c.v.i));
}

static void local(Symbol p) {
        /* LCC calls IR->local for two flavors of symbol: real
         * user-declared locals (from `int x;` in the source) and
         * CSE temporaries that need spill storage. The temporary
         * path must go through askregvar so LCC's per-temporary
         * handling fires (sets x.name = "?" and hands the symbol
         * off to the per-node allocator later). Real locals need a
         * force-promote to REGISTER or they default to AUTO and
         * land on the stack even when vmask has room. */
        if (p->temporary) {
                if (askregvar(p, rmap(ttob(p->type))) == 0)
                        mkauto(p);
                return;
        }
        if (!p->addressed) {
                p->sclass = REGISTER;
                if (askregvar(p, rmap(ttob(p->type))))
                        return;
                p->sclass = AUTO;
        }
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

/* Delay-slot peephole helpers. For leaf functions we buffer
 * emitcode()'s output to a temp file by dup2'ing fd 1, then
 * rewrite the buffer to swap the last body instruction into the
 * rts delay slot. Non-leaf functions use the epilogue-pop delay
 * slot fill done directly in function(). */
#define SH_MAX_LINES  2048
#define SH_MAX_LINELEN 256
static char sh_lines[SH_MAX_LINES][SH_MAX_LINELEN];
static int sh_nlines;

static int sh_is_uncond_branch(const char *);  /* forward decl */

static int sh_is_label_line(const char *s) {
        const char *p;
        while (*s == ' ' || *s == '\t') s++;
        p = strchr(s, ':');
        if (!p) return 0;
        /* Allow trailing whitespace/newline after the colon. */
        p++;
        while (*p == ' ' || *p == '\t' || *p == '\n' || *p == '\r') p++;
        return *p == 0;
}

static int sh_has_prefix(const char *s, const char *pre) {
        while (*s == ' ' || *s == '\t') s++;
        while (*pre) {
                if (*s++ != *pre++) return 0;
        }
        /* Must be followed by whitespace, tab, newline, or end of
         * string. Operand-less instructions like `nop` terminate
         * immediately with a newline; operand-having ones put a
         * tab before the first operand. */
        return *s == ' ' || *s == '\t' || *s == '\n'
               || *s == '\r' || *s == 0;
}

/* Return a mask of the r0..r15 register numbers that appear anywhere
 * in this instruction text. Conservative: flags both reads and
 * writes. Used by the peephole pass to check whether a range of
 * instructions between a pair of candidate dead-move lines touches
 * the registers involved. */
static unsigned sh_regs_used(const char *line) {
        unsigned mask = 0;
        const char *s = line;
        while (*s) {
                if (*s == 'r' && s[1] >= '0' && s[1] <= '9') {
                        int n = s[1] - '0';
                        s += 2;
                        if (*s >= '0' && *s <= '9') {
                                n = n * 10 + (*s - '0');
                                s++;
                        }
                        if (n >= 0 && n < 16)
                                mask |= 1u << n;
                } else {
                        s++;
                }
        }
        return mask;
}

/* Parse `[\\t ]*mov\\tr<A>,r<B>\\n` and fill *rA/*rB. Returns 1 on
 * success, 0 otherwise. The size-suffixed forms (mov.b, mov.w,
 * mov.l) and immediate moves are intentionally rejected — we only
 * want the register-to-register plain mov. */
static int sh_parse_regmov(const char *s, int *rA, int *rB) {
        while (*s == ' ' || *s == '\t') s++;
        if (s[0] != 'm' || s[1] != 'o' || s[2] != 'v') return 0;
        if (s[3] != ' ' && s[3] != '\t') return 0;
        s += 3;
        while (*s == ' ' || *s == '\t') s++;
        if (*s++ != 'r') return 0;
        if (*s < '0' || *s > '9') return 0;
        *rA = *s++ - '0';
        if (*s >= '0' && *s <= '9')
                *rA = *rA * 10 + *s++ - '0';
        if (*s++ != ',') return 0;
        if (*s++ != 'r') return 0;
        if (*s < '0' || *s > '9') return 0;
        *rB = *s++ - '0';
        if (*s >= '0' && *s <= '9')
                *rB = *rB * 10 + *s++ - '0';
        return 1;
}

static int sh_is_delay_safe(const char *s);

/* Return 1 if this line is a PC-relative long load — i.e.
 * `mov.l L<n>,Rn` or the explicit `mov.l @(<disp>,PC),Rn` form.
 * Those are forbidden in delay slots because the CPU's PC-relative
 * addressing mode misbehaves there. */
static int sh_is_pc_rel_load(const char *s) {
        while (*s == ' ' || *s == '\t') s++;
        if (!(s[0] == 'm' && s[1] == 'o' && s[2] == 'v'
              && (s[3] == '.') && (s[4] == 'l' || s[4] == 'w')
              && (s[5] == ' ' || s[5] == '\t')))
                return 0;
        s += 6;
        while (*s == ' ' || *s == '\t') s++;
        /* `mov.l L<digit>,...` — our literal-pool load convention. */
        if (s[0] == 'L' && s[1] >= '0' && s[1] <= '9')
                return 1;
        /* `mov.l @(<anything>,PC),...` — GAS syntax. */
        if (strstr(s, ",PC)") || strstr(s, ",pc)"))
                return 1;
        return 0;
}

/* Pick apart a `jsr @rN` / `jmp @rN` line and return N, or -1 for
 * branches that don't have a register target. */
static int sh_branch_target_reg(const char *s) {
        while (*s == ' ' || *s == '\t') s++;
        if ((s[0] == 'j' && s[1] == 's' && s[2] == 'r')
            || (s[0] == 'j' && s[1] == 'm' && s[2] == 'p')) {
                s += 3;
                while (*s == ' ' || *s == '\t') s++;
                if (*s != '@') return -1;
                s++;
                if (*s != 'r') return -1;
                s++;
                if (*s < '0' || *s > '9') return -1;
                {
                        int n = *s - '0';
                        if (s[1] >= '0' && s[1] <= '9')
                                n = n * 10 + (s[1] - '0');
                        return n;
                }
        }
        return -1;
}

static int sh_is_branch_line(const char *s) {
        while (*s == ' ' || *s == '\t') s++;
        if (sh_has_prefix(s, "jsr"))  return 1;
        if (sh_has_prefix(s, "jmp"))  return 1;
        if (sh_has_prefix(s, "bra"))  return 1;
        if (sh_has_prefix(s, "bsr"))  return 1;
        return 0;
}

/* Return 1 if `line` writes to register `rN` (destination operand).
 * For the SH-2 syntax we emit, the destination is the last register
 * before the newline; a simple scan-from-end works. */
static int sh_writes_reg(const char *line, int rN) {
        const char *s = line;
        const char *last_r = NULL;
        while (*s) {
                if (*s == 'r' && s[1] >= '0' && s[1] <= '9')
                        last_r = s;
                s++;
        }
        if (!last_r) return 0;
        last_r++;
        {
                int n = *last_r - '0';
                if (last_r[1] >= '0' && last_r[1] <= '9')
                        n = n * 10 + (last_r[1] - '0');
                return n == rN;
        }
}

/* Return 1 if `line` reads register `rN` — i.e., rN appears as an
 * operand at any position other than the destination.  Destination
 * is the LAST rN on the line per sh_writes_reg's convention; any
 * earlier occurrence is a read. */
static int sh_reads_reg(const char *line, int rN) {
        char needle[8];
        int nlen;
        const char *p, *last_r = NULL;
        const char *s = line;
        snprintf(needle, sizeof needle, "r%d", rN);
        nlen = (int)strlen(needle);
        while (*s) {
                if (*s == 'r' && s[1] >= '0' && s[1] <= '9')
                        last_r = s;
                s++;
        }
        p = line;
        while ((p = strstr(p, needle)) != NULL) {
                char c = p[nlen];
                if (!(c >= '0' && c <= '9')) {
                        /* Whole-token match for r<N>.  A match at a
                         * position other than the line's last register
                         * is a read. */
                        if (p != last_r)
                                return 1;
                }
                p++;
        }
        return 0;
}

/* ──────────────────────────────────────────────────────────
 * Asm-shim parsed IR (Stage 1, foundation for §4 of
 * saturn/workstreams/asm_shim_design.md)
 *
 * sh_parse_asm_text() consumes the raw text of an `asm { ... }`
 * block and returns a struct sh_asm_body — a list of per-line
 * sh_asm_insn records with parsed mnemonic, operands, and
 * reads/writes register masks. Every cross-function analysis
 * (Stage 3 writes_r4, future clobber narrowing, MAC/GBR tracking)
 * queries these masks; no analysis re-scans text or carries its
 * own mnemonic table.
 *
 * Stage 1 ships this as a self-contained library: the parser
 * runs only when -d-asm is on, dumps to stderr, and the result
 * is discarded. Stage 2 wires the parser into the frontend so
 * each ASM_INSN Node carries its parsed insn record.
 *
 * Conservative-on-unknown: any line the parser can't classify
 * gets is_unknown=1 and reads/writes set to ~0 — analyses
 * default to "this line could clobber anything" rather than
 * silently underreporting and breaking byte-match.
 * ────────────────────────────────────────────────────────── */

/* ── parser tokenizer helpers ─────────────────────────── */

static const char *sh_p_skip_ws(const char *p) {
        while (*p == ' ' || *p == '\t') p++;
        return p;
}

/* Match `rN` (N in [0,15]). On success, advance *p and set *out. */
static int sh_p_match_reg(const char **p, int *out) {
        const char *s = *p;
        int n;
        if (*s != 'r' && *s != 'R') return 0;
        s++;
        if (*s < '0' || *s > '9') return 0;
        n = *s++ - '0';
        if (*s >= '0' && *s <= '9') n = n * 10 + (*s++ - '0');
        if (n < 0 || n > 15) return 0;
        /* Don't match `r0pad` as r0 — must be followed by a non-
         * identifier character. */
        if ((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z')
            || *s == '_' || *s == '.')
                return 0;
        *p = s;
        *out = n;
        return 1;
}

static int sh_p_match_sreg(const char **p, enum sh_sreg_id *out) {
        static const struct {
                const char *name;
                int len;
                enum sh_sreg_id id;
        } tab[] = {
                { "mach", 4, SH_SR_MACH }, { "MACH", 4, SH_SR_MACH },
                { "macl", 4, SH_SR_MACL }, { "MACL", 4, SH_SR_MACL },
                { "gbr",  3, SH_SR_GBR  }, { "GBR",  3, SH_SR_GBR  },
                { "vbr",  3, SH_SR_VBR  }, { "VBR",  3, SH_SR_VBR  },
                { "pr",   2, SH_SR_PR   }, { "PR",   2, SH_SR_PR   },
                { "sr",   2, SH_SR_SR   }, { "SR",   2, SH_SR_SR   },
                { "t",    1, SH_SR_T    }, { "T",    1, SH_SR_T    }
        };
        int i;
        for (i = 0; i < (int)(sizeof tab / sizeof tab[0]); i++) {
                if (strncmp(*p, tab[i].name, tab[i].len) == 0) {
                        char nxt = (*p)[tab[i].len];
                        if (!((nxt >= 'a' && nxt <= 'z')
                              || (nxt >= 'A' && nxt <= 'Z')
                              || (nxt >= '0' && nxt <= '9')
                              || nxt == '_' || nxt == '.')) {
                                *p += tab[i].len;
                                *out = tab[i].id;
                                return 1;
                        }
                }
        }
        return 0;
}

/* Numeric immediate: optional sign, optional 0x prefix. Decimal or
 * hex digits required. */
static int sh_p_match_num(const char **p, long *out) {
        const char *s = *p;
        long sign = 1, val = 0;
        int saw_digit = 0;
        if (*s == '-') { sign = -1; s++; }
        else if (*s == '+') { s++; }
        if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
                s += 2;
                while (1) {
                        int d;
                        if (*s >= '0' && *s <= '9') d = *s - '0';
                        else if (*s >= 'a' && *s <= 'f') d = *s - 'a' + 10;
                        else if (*s >= 'A' && *s <= 'F') d = *s - 'A' + 10;
                        else break;
                        val = val * 16 + d;
                        s++;
                        saw_digit = 1;
                }
        } else {
                while (*s >= '0' && *s <= '9') {
                        val = val * 10 + (*s - '0');
                        s++;
                        saw_digit = 1;
                }
        }
        if (!saw_digit) return 0;
        *out = sign * val;
        *p = s;
        return 1;
}

/* Read an identifier (label-like). Returns 1 and a stringn'd copy on
 * success; otherwise 0. */
static int sh_p_match_ident(const char **p, char **out) {
        const char *s = *p;
        const char *start = s;
        if (!((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z')
              || *s == '_' || *s == '.'))
                return 0;
        while ((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z')
               || (*s >= '0' && *s <= '9') || *s == '_' || *s == '.')
                s++;
        *out = stringn((char *)start, s - start);
        *p = s;
        return 1;
}

/* Parse one operand starting at *p. Sets *op and advances *p. */
static int sh_p_parse_operand(const char **p, struct sh_operand *op) {
        const char *s;
        int reg;
        enum sh_sreg_id sreg;
        long imm;
        char *label;

        memset(op, 0, sizeof(*op));
        s = sh_p_skip_ws(*p);

        /* SH_OP_IMM: #... */
        if (*s == '#') {
                const char *q = s + 1;
                if (sh_p_match_num(&q, &imm)) {
                        op->kind = SH_OP_IMM;
                        op->imm = imm;
                        *p = q;
                        return 1;
                }
                if (sh_p_match_ident(&q, &label)) {
                        op->kind = SH_OP_IMM;
                        op->label = label;
                        *p = q;
                        return 1;
                }
                return 0;
        }

        /* SH_OP_MEM: @... */
        if (*s == '@') {
                const char *q = s + 1;
                if (*q == '-') {
                        q++;
                        if (sh_p_match_reg(&q, &reg)) {
                                op->kind = SH_OP_MEM;
                                op->mem_mode = SH_MEM_PREDEC;
                                op->reg = reg;
                                *p = q;
                                return 1;
                        }
                        return 0;
                }
                if (*q == '(') {
                        /* @(disp,X) or @(R0,rN) */
                        const char *save;
                        q++;
                        q = sh_p_skip_ws(q);
                        save = q;
                        /* @(R0,rN) form */
                        {
                                int r0;
                                if (sh_p_match_reg(&q, &r0) && r0 == 0) {
                                        q = sh_p_skip_ws(q);
                                        if (*q == ',') {
                                                q++;
                                                q = sh_p_skip_ws(q);
                                                if (sh_p_match_reg(&q, &reg)) {
                                                        q = sh_p_skip_ws(q);
                                                        if (*q == ')') {
                                                                q++;
                                                                op->kind = SH_OP_MEM;
                                                                op->mem_mode = SH_MEM_R0IDX;
                                                                op->reg = reg;
                                                                *p = q;
                                                                return 1;
                                                        }
                                                }
                                        }
                                }
                                q = save;
                        }
                        /* @(disp,X) */
                        if (sh_p_match_num(&q, &imm)) {
                                q = sh_p_skip_ws(q);
                                if (*q == ',') {
                                        q++;
                                        q = sh_p_skip_ws(q);
                                        if (sh_p_match_reg(&q, &reg)) {
                                                q = sh_p_skip_ws(q);
                                                if (*q == ')') {
                                                        q++;
                                                        op->kind = SH_OP_MEM;
                                                        op->mem_mode = SH_MEM_DISP;
                                                        op->reg = reg;
                                                        op->imm = imm;
                                                        *p = q;
                                                        return 1;
                                                }
                                        } else if (strncmp(q, "GBR", 3) == 0
                                                   || strncmp(q, "gbr", 3) == 0) {
                                                q += 3;
                                                q = sh_p_skip_ws(q);
                                                if (*q == ')') {
                                                        q++;
                                                        op->kind = SH_OP_MEM;
                                                        op->mem_mode = SH_MEM_GBRDISP;
                                                        op->imm = imm;
                                                        *p = q;
                                                        return 1;
                                                }
                                        } else if (strncmp(q, "PC", 2) == 0
                                                   || strncmp(q, "pc", 2) == 0) {
                                                q += 2;
                                                q = sh_p_skip_ws(q);
                                                if (*q == ')') {
                                                        q++;
                                                        op->kind = SH_OP_MEM;
                                                        op->mem_mode = SH_MEM_PCDISP;
                                                        op->imm = imm;
                                                        *p = q;
                                                        return 1;
                                                }
                                        }
                                }
                        }
                        return 0;
                }
                /* @rN or @rN+ */
                if (sh_p_match_reg(&q, &reg)) {
                        op->kind = SH_OP_MEM;
                        op->reg = reg;
                        if (*q == '+') {
                                op->mem_mode = SH_MEM_POSTINC;
                                q++;
                        } else {
                                op->mem_mode = SH_MEM_INDIR;
                        }
                        *p = q;
                        return 1;
                }
                return 0;
        }

        /* SH_OP_REG: rN */
        {
                const char *q = s;
                if (sh_p_match_reg(&q, &reg)) {
                        op->kind = SH_OP_REG;
                        op->reg = reg;
                        *p = q;
                        return 1;
                }
        }

        /* SH_OP_SREG */
        {
                const char *q = s;
                if (sh_p_match_sreg(&q, &sreg)) {
                        op->kind = SH_OP_SREG;
                        op->sreg = sreg;
                        *p = q;
                        return 1;
                }
        }

        /* Bare numeric immediate (directive args like `.long 4`) */
        {
                const char *q = s;
                if (sh_p_match_num(&q, &imm)) {
                        op->kind = SH_OP_IMM;
                        op->imm = imm;
                        *p = q;
                        return 1;
                }
        }

        /* SH_OP_LABEL: identifier. Branch targets, pool refs. */
        {
                const char *q = s;
                if (sh_p_match_ident(&q, &label)) {
                        op->kind = SH_OP_LABEL;
                        op->label = label;
                        *p = q;
                        return 1;
                }
        }

        op->kind = SH_OP_NONE;
        return 0;
}

static int sh_p_parse_operands(const char **p,
                               struct sh_operand operands[3]) {
        int n = 0;
        const char *s = *p;
        s = sh_p_skip_ws(s);
        if (*s == 0 || *s == '\n' || *s == '\r' || *s == '!'
            || *s == ';' || (*s == '/' && s[1] == '*')) {
                *p = s;
                return 0;
        }
        while (n < 3) {
                if (!sh_p_parse_operand(&s, &operands[n])) break;
                n++;
                s = sh_p_skip_ws(s);
                if (*s == ',') {
                        s++;
                        s = sh_p_skip_ws(s);
                        continue;
                }
                break;
        }
        *p = s;
        return n;
}

/* ── mnemonic dispatch ────────────────────────────────── */

enum sh_mn_kind {
        MK_UNKNOWN,
        MK_NOP,            /* no GP-reg effects */
        MK_NOP_T,          /* clrt/sett — write T */
        MK_NOP_MAC,        /* clrmac — write MACH+MACL */
        MK_BIN_LAST_DEST,  /* `op A,B` — read A, read+write B */
        MK_UNARY_DEST,     /* `op N` — read+write N */
        MK_DT,             /* dt rN — read+write rN, write T */
        MK_MOVT,           /* movt rN — write rN, read T */
        MK_MOV,            /* mov / mov.b/w/l — refined per operand */
        MK_CMP,            /* cmp/* rA,rB — read; write T */
        MK_CMP_UNARY,      /* cmp/pl/pz rN — read; write T */
        MK_TST,            /* tst rA,rB / tst #imm,r0 — read; write T */
        MK_BRANCH_LABEL,   /* bra/bsr/bt/bf label */
        MK_BRANCH_INDIR,   /* jmp/jsr @rN */
        MK_RTS,            /* rts — read PR */
        MK_LDS,            /* lds rA,sreg */
        MK_LDS_L,          /* lds.l @rN+,sreg */
        MK_STS,            /* sts sreg,rA */
        MK_STS_L,          /* sts.l sreg,@-rN */
        MK_LDC,            /* ldc rA,sreg (gbr/vbr/sr) */
        MK_LDC_L,          /* ldc.l @rN+,sreg */
        MK_STC,            /* stc sreg,rA */
        MK_STC_L,          /* stc.l sreg,@-rN */
        MK_MUL,            /* mul.l rA,rB */
        MK_DMUL,           /* dmuls.l/dmulu.l */
        MK_MULSW,          /* muls.w/mulu.w */
        MK_MAC,            /* mac.l/mac.w @rA+,@rB+ */
        MK_DIV1,           /* div1 rA,rB */
        MK_TAS,            /* tas.b @rN */
        MK_SWAP_XTRCT,     /* swap.X rA,rB / xtrct rA,rB */
        MK_EXT,            /* extu/exts.X rA,rB */
        MK_SLEEP_TRAPA     /* opaque, conservative */
};

static const struct {
        const char *name;
        enum sh_mn_kind kind;
} sh_mnemonic_table[] = {
        { "nop",     MK_NOP },
        { "clrt",    MK_NOP_T },
        { "sett",    MK_NOP_T },
        { "clrmac",  MK_NOP_MAC },
        { "shll",    MK_UNARY_DEST }, { "shll2",  MK_UNARY_DEST },
        { "shll8",   MK_UNARY_DEST }, { "shll16", MK_UNARY_DEST },
        { "shlr",    MK_UNARY_DEST }, { "shlr2",  MK_UNARY_DEST },
        { "shlr8",   MK_UNARY_DEST }, { "shlr16", MK_UNARY_DEST },
        { "shal",    MK_UNARY_DEST }, { "shar",   MK_UNARY_DEST },
        { "rotl",    MK_UNARY_DEST }, { "rotr",   MK_UNARY_DEST },
        { "rotcl",   MK_UNARY_DEST }, { "rotcr",  MK_UNARY_DEST },
        { "movt",    MK_MOVT },
        { "dt",      MK_DT },
        { "add",     MK_BIN_LAST_DEST }, { "addc",  MK_BIN_LAST_DEST },
        { "addv",    MK_BIN_LAST_DEST },
        { "sub",     MK_BIN_LAST_DEST }, { "subc",  MK_BIN_LAST_DEST },
        { "subv",    MK_BIN_LAST_DEST },
        { "and",     MK_BIN_LAST_DEST }, { "or",    MK_BIN_LAST_DEST },
        { "xor",     MK_BIN_LAST_DEST },
        { "neg",     MK_BIN_LAST_DEST }, { "negc",  MK_BIN_LAST_DEST },
        { "not",     MK_BIN_LAST_DEST },
        { "mov",     MK_MOV }, { "mov.b", MK_MOV },
        { "mov.w",   MK_MOV }, { "mov.l", MK_MOV },
        { "cmp/eq",  MK_CMP }, { "cmp/hs", MK_CMP },
        { "cmp/ge",  MK_CMP }, { "cmp/hi", MK_CMP },
        { "cmp/gt",  MK_CMP }, { "cmp/str",MK_CMP },
        { "cmp/pl",  MK_CMP_UNARY }, { "cmp/pz",  MK_CMP_UNARY },
        { "tst",     MK_TST },
        { "bra",     MK_BRANCH_LABEL }, { "bsr",   MK_BRANCH_LABEL },
        { "bsr/s",   MK_BRANCH_LABEL },
        { "bt",      MK_BRANCH_LABEL }, { "bf",    MK_BRANCH_LABEL },
        { "bt/s",    MK_BRANCH_LABEL }, { "bf/s",  MK_BRANCH_LABEL },
        { "jsr",     MK_BRANCH_INDIR }, { "jmp",   MK_BRANCH_INDIR },
        { "rts",     MK_RTS },
        { "lds",     MK_LDS },   { "lds.l", MK_LDS_L },
        { "sts",     MK_STS },   { "sts.l", MK_STS_L },
        { "ldc",     MK_LDC },   { "ldc.l", MK_LDC_L },
        { "stc",     MK_STC },   { "stc.l", MK_STC_L },
        { "mul.l",   MK_MUL },
        { "dmuls.l", MK_DMUL },  { "dmulu.l", MK_DMUL },
        { "muls.w",  MK_MULSW }, { "mulu.w",  MK_MULSW },
        { "mac.l",   MK_MAC },   { "mac.w",   MK_MAC },
        { "div0s",   MK_CMP }, /* read both, write T (Q) — close enough */
        { "div0u",   MK_NOP },
        { "div1",    MK_DIV1 },
        { "swap.b",  MK_SWAP_XTRCT }, { "swap.w", MK_SWAP_XTRCT },
        { "xtrct",   MK_SWAP_XTRCT },
        { "extu.b",  MK_EXT }, { "extu.w", MK_EXT },
        { "exts.b",  MK_EXT }, { "exts.w", MK_EXT },
        { "tas.b",   MK_TAS },
        { "sleep",   MK_SLEEP_TRAPA }, { "trapa", MK_SLEEP_TRAPA }
};

static enum sh_mn_kind sh_lookup_mnemonic(const char *mn) {
        int i;
        int n = (int)(sizeof sh_mnemonic_table
                      / sizeof sh_mnemonic_table[0]);
        for (i = 0; i < n; i++)
                if (strcmp(mn, sh_mnemonic_table[i].name) == 0)
                        return sh_mnemonic_table[i].kind;
        return MK_UNKNOWN;
}

/* Helper: add reg-flow effects of a memory operand.
 * For a SOURCE memory operand: read base; if post-inc, also write base.
 * For a DEST memory operand: read base; if pre-dec or post-inc, also
 * write base. */
static void sh_p_mem_effects(const struct sh_operand *op,
                             struct sh_asm_insn *insn,
                             int as_dest) {
        if (op->kind != SH_OP_MEM) return;
        insn->reads |= 1u << op->reg;
        if (op->mem_mode == SH_MEM_PREDEC
            || op->mem_mode == SH_MEM_POSTINC)
                insn->writes |= 1u << op->reg;
        if (op->mem_mode == SH_MEM_R0IDX) {
                insn->reads |= 1u << 0;  /* r0 is the index */
        }
        if (op->mem_mode == SH_MEM_GBRDISP)
                insn->reads_sreg |= 1u << SH_SR_GBR;
        (void)as_dest;
}

/* Apply read/write semantics for a parsed mnemonic + operands. */
static void sh_p_apply_kind(struct sh_asm_insn *insn,
                            enum sh_mn_kind kind) {
        struct sh_operand *o = insn->operands;
        int n = insn->n_operands;
        switch (kind) {
        case MK_UNKNOWN:
                /* Conservative: any GP reg / sreg may be touched. */
                insn->is_unknown = 1;
                insn->reads = 0xFFFFu;
                insn->writes = 0xFFFFu;
                insn->reads_sreg = (1u << SH_SR_COUNT) - 1;
                insn->writes_sreg = (1u << SH_SR_COUNT) - 1;
                break;
        case MK_NOP:
                break;
        case MK_NOP_T:
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_NOP_MAC:
                insn->writes_sreg |= (1u << SH_SR_MACH)
                                   | (1u << SH_SR_MACL);
                break;
        case MK_UNARY_DEST:
                if (n >= 1 && o[0].kind == SH_OP_REG) {
                        insn->reads  |= 1u << o[0].reg;
                        insn->writes |= 1u << o[0].reg;
                }
                break;
        case MK_DT:
                if (n >= 1 && o[0].kind == SH_OP_REG) {
                        insn->reads  |= 1u << o[0].reg;
                        insn->writes |= 1u << o[0].reg;
                }
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_MOVT:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->writes |= 1u << o[0].reg;
                insn->reads_sreg |= 1u << SH_SR_T;
                break;
        case MK_BIN_LAST_DEST:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG) {
                        insn->reads  |= 1u << o[1].reg;
                        insn->writes |= 1u << o[1].reg;
                } else if (n == 1 && o[0].kind == SH_OP_REG) {
                        /* `neg rN` style — single-operand variant. */
                        insn->writes |= 1u << o[0].reg;
                }
                /* Some forms (addc/subc/negc) read/write T, but we
                 * only need that for sreg-precise analyses; conservative
                 * additions as needed. */
                if (insn->mnemonic
                    && (strcmp(insn->mnemonic, "addc") == 0
                        || strcmp(insn->mnemonic, "subc") == 0
                        || strcmp(insn->mnemonic, "negc") == 0)) {
                        insn->reads_sreg  |= 1u << SH_SR_T;
                        insn->writes_sreg |= 1u << SH_SR_T;
                }
                if (insn->mnemonic
                    && (strcmp(insn->mnemonic, "addv") == 0
                        || strcmp(insn->mnemonic, "subv") == 0))
                        insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_MOV: {
                /* Disambiguate by operand kinds:
                 *   mov rA, rB         → read A, write B
                 *   mov #imm, rN       → write N
                 *   mov.X mem, rN      → load:  read mem, write N
                 *   mov.X rN, mem      → store: read N, mem effects
                 *   mov.X label, rN    → PC-rel load: write N
                 */
                if (n != 2) {
                        insn->is_unknown = 1;
                        insn->reads = 0xFFFFu;
                        insn->writes = 0xFFFFu;
                        break;
                }
                /* Source effects */
                switch (o[0].kind) {
                case SH_OP_REG:
                        insn->reads |= 1u << o[0].reg;
                        break;
                case SH_OP_IMM:
                        break;
                case SH_OP_MEM:
                        sh_p_mem_effects(&o[0], insn, 0);
                        break;
                case SH_OP_LABEL:
                        /* PC-rel literal load — no GP-reg read */
                        break;
                default:
                        break;
                }
                /* Dest effects */
                switch (o[1].kind) {
                case SH_OP_REG:
                        insn->writes |= 1u << o[1].reg;
                        break;
                case SH_OP_MEM:
                        sh_p_mem_effects(&o[1], insn, 1);
                        break;
                default:
                        insn->is_unknown = 1;
                        insn->writes = 0xFFFFu;
                        break;
                }
                break;
        }
        case MK_CMP:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                if (n >= 1 && o[0].kind == SH_OP_IMM
                    && n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_CMP_UNARY:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_TST:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                if (n >= 1 && o[0].kind == SH_OP_IMM
                    && n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_BRANCH_LABEL:
                insn->is_branch = 1;
                if (insn->mnemonic
                    && (insn->mnemonic[0] == 'b'
                        && insn->mnemonic[1] == 's')) {
                        insn->is_call = 1;
                        insn->writes_sreg |= 1u << SH_SR_PR;
                }
                if (insn->mnemonic
                    && (insn->mnemonic[0] == 'b'
                        && (insn->mnemonic[1] == 't'
                            || insn->mnemonic[1] == 'f')))
                        insn->reads_sreg |= 1u << SH_SR_T;
                break;
        case MK_BRANCH_INDIR:
                insn->is_branch = 1;
                if (n >= 1 && o[0].kind == SH_OP_MEM)
                        insn->reads |= 1u << o[0].reg;
                if (insn->mnemonic && insn->mnemonic[0] == 'j'
                    && insn->mnemonic[1] == 's') {
                        insn->is_call = 1;
                        insn->writes_sreg |= 1u << SH_SR_PR;
                }
                break;
        case MK_RTS:
                insn->is_branch = 1;
                insn->reads_sreg |= 1u << SH_SR_PR;
                break;
        case MK_LDS:
                /* lds rA, sreg */
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_SREG)
                        insn->writes_sreg |= 1u << o[1].sreg;
                break;
        case MK_LDS_L:
                /* lds.l @rN+, sreg */
                if (n >= 1) sh_p_mem_effects(&o[0], insn, 0);
                if (n >= 2 && o[1].kind == SH_OP_SREG)
                        insn->writes_sreg |= 1u << o[1].sreg;
                break;
        case MK_STS:
                /* sts sreg, rA */
                if (n >= 1 && o[0].kind == SH_OP_SREG)
                        insn->reads_sreg |= 1u << o[0].sreg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->writes |= 1u << o[1].reg;
                break;
        case MK_STS_L:
                /* sts.l sreg, @-rN */
                if (n >= 1 && o[0].kind == SH_OP_SREG)
                        insn->reads_sreg |= 1u << o[0].sreg;
                if (n >= 2) sh_p_mem_effects(&o[1], insn, 1);
                break;
        case MK_LDC:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_SREG)
                        insn->writes_sreg |= 1u << o[1].sreg;
                break;
        case MK_LDC_L:
                if (n >= 1) sh_p_mem_effects(&o[0], insn, 0);
                if (n >= 2 && o[1].kind == SH_OP_SREG)
                        insn->writes_sreg |= 1u << o[1].sreg;
                break;
        case MK_STC:
                if (n >= 1 && o[0].kind == SH_OP_SREG)
                        insn->reads_sreg |= 1u << o[0].sreg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->writes |= 1u << o[1].reg;
                break;
        case MK_STC_L:
                if (n >= 1 && o[0].kind == SH_OP_SREG)
                        insn->reads_sreg |= 1u << o[0].sreg;
                if (n >= 2) sh_p_mem_effects(&o[1], insn, 1);
                break;
        case MK_MUL:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                insn->writes_sreg |= 1u << SH_SR_MACL;
                break;
        case MK_DMUL:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                insn->writes_sreg |= (1u << SH_SR_MACH)
                                   | (1u << SH_SR_MACL);
                break;
        case MK_MULSW:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->reads |= 1u << o[1].reg;
                insn->writes_sreg |= 1u << SH_SR_MACL;
                break;
        case MK_MAC:
                if (n >= 1) sh_p_mem_effects(&o[0], insn, 0);
                if (n >= 2) sh_p_mem_effects(&o[1], insn, 0);
                insn->reads_sreg  |= (1u << SH_SR_MACH)
                                   | (1u << SH_SR_MACL);
                insn->writes_sreg |= (1u << SH_SR_MACH)
                                   | (1u << SH_SR_MACL);
                break;
        case MK_DIV1:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG) {
                        insn->reads  |= 1u << o[1].reg;
                        insn->writes |= 1u << o[1].reg;
                }
                insn->reads_sreg  |= 1u << SH_SR_T;
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_TAS:
                if (n >= 1) sh_p_mem_effects(&o[0], insn, 1);
                insn->writes_sreg |= 1u << SH_SR_T;
                break;
        case MK_SWAP_XTRCT:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG) {
                        insn->reads  |= 1u << o[1].reg;
                        insn->writes |= 1u << o[1].reg;
                }
                break;
        case MK_EXT:
                if (n >= 1 && o[0].kind == SH_OP_REG)
                        insn->reads |= 1u << o[0].reg;
                if (n >= 2 && o[1].kind == SH_OP_REG)
                        insn->writes |= 1u << o[1].reg;
                break;
        case MK_SLEEP_TRAPA:
                /* Opaque: assume it could clobber anything. */
                insn->is_unknown = 1;
                insn->reads = 0xFFFFu;
                insn->writes = 0xFFFFu;
                insn->reads_sreg = (1u << SH_SR_COUNT) - 1;
                insn->writes_sreg = (1u << SH_SR_COUNT) - 1;
                break;
        }
}

/* ── per-line classification ──────────────────────────── */

static int sh_p_line_is_blank_or_comment(const char *p) {
        p = sh_p_skip_ws(p);
        if (*p == 0 || *p == '\n' || *p == '\r') return 1;
        if (*p == '!' || *p == ';') return 1;
        if (p[0] == '/' && p[1] == '*') return 1;
        return 0;
}

/* Classify one line into the insn record. */
static void sh_parse_one_line(struct sh_asm_insn *insn,
                              const char *line) {
        const char *p = line;
        const char *content;
        char *mnemonic = NULL;

        if (sh_p_line_is_blank_or_comment(p)) {
                insn->is_comment = 1;
                return;
        }

        p = sh_p_skip_ws(p);
        content = p;

        /* Label-only line? Use existing helper. */
        if (sh_is_label_line(content)) {
                insn->is_label = 1;
                /* Capture the label name for completeness. */
                {
                        const char *e = strchr(content, ':');
                        if (e) {
                                insn->mnemonic = stringn((char *)content,
                                                         e - content);
                                insn->label_name = insn->mnemonic;
                        }
                }
                return;
        }

        /* Directive? */
        if (*p == '.') {
                const char *start = p;
                /* Disambiguate: a `.`-prefixed identifier followed
                 * by `:` is a GNU local label (e.g. `.L_pool_X:`),
                 * NOT a directive. The combined-line branch below
                 * handles that case. Without this lookahead the
                 * combined-line `.L_pool_X: .long Y` form parses
                 * `.L_pool_X` as the directive name and silently
                 * loses the label, which was masked by the
                 * standalone-form-only regtest until 74a8bd5's
                 * code review caught it. */
                {
                        const char *q = p;
                        while ((*q >= 'a' && *q <= 'z')
                               || (*q >= 'A' && *q <= 'Z')
                               || *q == '.' || *q == '_'
                               || (*q >= '0' && *q <= '9')) q++;
                        if (*q == ':') {
                                /* Fall through to combined-line. */
                                goto combined_label;
                        }
                }
                /* Read the directive name (`.long`, `.short`, etc.) */
                while ((*p >= 'a' && *p <= 'z')
                       || (*p >= 'A' && *p <= 'Z')
                       || *p == '.' || *p == '_'
                       || (*p >= '0' && *p <= '9')) p++;
                insn->mnemonic = stringn((char *)start, p - start);
                insn->is_directive = 1;
                /* Operands for diagnostic dump only — directives have
                 * no register effects. */
                insn->n_operands = sh_p_parse_operands(&p, insn->operands);
                /* `.asm_entry FUN_X` — sub-entry alias inside an asm
                 * body. The directive's first operand is the symbol
                 * name; emit will expand to `.global FUN_X` +
                 * `FUN_X:` so the linker exports the entry. Phase A
                 * treats the position as a sub-entry start point. */
                if (insn->mnemonic
                    && strcmp(insn->mnemonic, ".asm_entry") == 0
                    && insn->n_operands >= 1
                    && insn->operands[0].kind == SH_OP_LABEL) {
                        insn->is_entry = 1;
                }
                return;
        }

        /* Combined `LABEL: instruction` form (e.g. `LP0: .long _x`).
         * For Stage 1, treat the line as if the instruction part
         * starts after the colon. Reachable both fall-through from
         * the standard parse order (LABEL doesn't start with `.`)
         * and via `goto combined_label` from the directive branch
         * (LABEL starts with `.` like `.L_pool_X:`). */
        combined_label:
        {
                const char *colon = NULL, *q = content;
                while (((*q >= 'a' && *q <= 'z') || (*q >= 'A' && *q <= 'Z')
                        || (*q >= '0' && *q <= '9') || *q == '_'
                        || *q == '.'))
                        q++;
                if (*q == ':') {
                        colon = q;
                        q++;
                        q = sh_p_skip_ws(q);
                        if (*q && *q != '\n' && *q != '\r'
                            && *q != '!' && *q != ';') {
                                insn->is_label = 1;
                                /* Capture the label name (text from
                                 * `content` up to the colon) so the
                                 * naming-based pool-alignment pass
                                 * can find it; mnemonic below will
                                 * be overwritten with the directive
                                 * name. */
                                insn->label_name = stringn((char *)content,
                                                           colon - content);
                                p = q;
                                content = q;
                                /* Re-check directive after the colon */
                                if (*p == '.') {
                                        const char *start = p;
                                        while ((*p >= 'a' && *p <= 'z')
                                               || (*p >= 'A' && *p <= 'Z')
                                               || *p == '.' || *p == '_'
                                               || (*p >= '0' && *p <= '9'))
                                                p++;
                                        insn->mnemonic = stringn((char *)start,
                                                                 p - start);
                                        insn->is_directive = 1;
                                        insn->n_operands = sh_p_parse_operands(
                                                &p, insn->operands);
                                        return;
                                }
                        }
                        (void)colon;
                }
        }

        /* Mnemonic — read up to whitespace or end-of-line. */
        {
                const char *start = p;
                while (((*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z')
                        || (*p >= '0' && *p <= '9') || *p == '/'
                        || *p == '.'))
                        p++;
                if (p == start) {
                        insn->is_unknown = 1;
                        sh_p_apply_kind(insn, MK_UNKNOWN);
                        return;
                }
                mnemonic = stringn((char *)start, p - start);
                insn->mnemonic = mnemonic;
        }

        /* Operands */
        insn->n_operands = sh_p_parse_operands(&p, insn->operands);

        /* Dispatch by mnemonic kind. */
        sh_p_apply_kind(insn, sh_lookup_mnemonic(mnemonic));
}

/* ── public API ───────────────────────────────────────── */

/* Accessors for dag.c — let target-agnostic code walk the parsed
 * body without seeing the opaque struct internals. */
int sh_asm_body_n_insns(struct sh_asm_body *body) {
        return body ? body->n_insns : 0;
}

struct sh_asm_insn *sh_asm_body_insn(struct sh_asm_body *body, int i) {
        if (!body || i < 0 || i >= body->n_insns) return NULL;
        return &body->insns[i];
}

char *sh_asm_insn_src_text(struct sh_asm_insn *in) {
        return in ? in->src_text : NULL;
}

/* Is `mn` an alignment directive whose presence before a label
 * already supplies alignment, so we should suppress our synthetic
 * emit? Per D3: any `.balign N` or `.align M` for any N/M.
 * The corpus has no cases that need finer-grained "align ≥ 4"
 * matching, so a simple presence check suffices. */
static int sh_is_align_directive(const char *mn) {
        if (!mn) return 0;
        return strcmp(mn, ".balign") == 0
            || strcmp(mn, ".align") == 0;
}

/* Look at the label name and return the alignment we should emit
 * before it (4 or 2), or 0 if no auto-alignment is warranted.
 *
 * Naming-based trigger per the project convention used by
 * DaytonaCCEReverse:
 *
 *   `.L_pool_*`  — mov.l target, 4-byte alignment required.
 *   `.L_wpool_*` — mov.w target, 2-byte alignment required.
 *   anything else — no auto-emit.
 *
 * History: the first cut (sha 9c7cc50) used a structural trigger —
 * "any label followed by .long/.4byte/.short/.word/.byte gets
 * .balign 4". That over-fired on .L_wpool_* labels (forced 4-align
 * where 2-align was correct) and on non-pool labels (.L_braf_ret_*,
 * .L_data_*, etc.) that happened to precede data directives in
 * code. Cumulative shift across 1,268 over-emissions blew the
 * 12-bit displacement budget on long-distance bsr/bra in the race
 * module. The naming convention is stable and encodes the access
 * size; using it removes both classes of false positives. */
static int sh_pool_align_for_label(const char *name) {
        if (!name) return 0;
        /* Check .L_wpool_ first because .L_pool_ is a strict prefix
         * substring — but only of strings starting with ".L_pool_".
         * ".L_wpool_" begins with ".L_w" so it can't match the
         * ".L_pool_" prefix; either order is safe in practice. */
        if (strncmp(name, ".L_wpool_", 9) == 0)
                return 2;
        if (strncmp(name, ".L_pool_", 8) == 0)
                return 4;
        return 0;
}

/* After parse, walk `body->insns[]` and set `pool_align` on each
 * `is_label` record whose name matches the project pool-naming
 * convention AND whose nearest preceding non-comment record is not
 * already an alignment directive (D3 dedup).
 *
 * Pre-attaching the value at parse time lets sh_emit_asm_insn fire
 * uniformly whether it's invoked from the per-Node ASM_INSN+V case
 * in emit2 (mixed-mode asm blocks) or from the naked-shim direct
 * call path — neither emit context has cheap access to a list-
 * iterator-style "next instruction" peek, so the lookup happens
 * once at parse time and the emit just reads a flag. */
static void sh_compute_pool_alignment(struct sh_asm_body *body) {
        int i, j;
        if (!body) return;
        for (i = 0; i < body->n_insns; i++) {
                struct sh_asm_insn *in = &body->insns[i];
                struct sh_asm_insn *prev = NULL;
                int align;

                if (!in->is_label) continue;
                /* Sub-entry expansions (`.asm_entry FUN_X`) are
                 * entry points to executable code, not pool labels.
                 * The naming check would naturally exclude them
                 * (FUN_X doesn't start with .L_pool_) but skip
                 * explicitly for clarity. */
                if (in->is_entry) continue;

                /* `label_name` is set by sh_parse_one_line for both
                 * standalone-label and combined-label-with-directive
                 * records. mnemonic carries the directive name on
                 * combined records, so reading it here would have
                 * silently missed `.L_pool_X: .long Y` one-liners
                 * (caught in code review of 74a8bd5). */
                align = sh_pool_align_for_label(in->label_name);
                if (align == 0) continue;

                /* Backward scan: skip comments. If the nearest
                 * preceding real record is an alignment directive,
                 * the source already supplied alignment; suppress
                 * the synthetic emit per D3. */
                for (j = i - 1; j >= 0; j--) {
                        if (body->insns[j].is_comment) continue;
                        prev = &body->insns[j];
                        break;
                }
                if (prev && prev->is_directive
                    && sh_is_align_directive(prev->mnemonic))
                        continue;

                in->pool_align = (unsigned char)align;
        }
}

struct sh_asm_body *sh_parse_asm_text(const char *text) {
        struct sh_asm_body *body;
        const char *p = text;
        int line_no = 1;

        NEW0(body, PERM);
        body->raw_text = stringn((char *)text, strlen(text));
        body->n_capacity = 16;
        body->insns = allocate(body->n_capacity
                               * sizeof(struct sh_asm_insn), PERM);
        body->n_insns = 0;

        while (*p) {
                const char *line_start = p;
                const char *line_end;
                int len;
                struct sh_asm_insn *insn;
                char *src_text;

                for (line_end = p; *line_end && *line_end != '\n';
                     line_end++) ;
                len = line_end - line_start
                      + (*line_end == '\n' ? 1 : 0);
                src_text = stringn((char *)line_start, len);

                if (body->n_insns >= body->n_capacity) {
                        int new_cap = body->n_capacity * 2;
                        struct sh_asm_insn *new_arr;
                        new_arr = allocate(new_cap
                                           * sizeof(struct sh_asm_insn),
                                           PERM);
                        memcpy(new_arr, body->insns,
                               body->n_insns
                               * sizeof(struct sh_asm_insn));
                        body->insns = new_arr;
                        body->n_capacity = new_cap;
                }

                insn = &body->insns[body->n_insns++];
                memset(insn, 0, sizeof(*insn));
                insn->src_text = src_text;
                insn->line_no = line_no;

                sh_parse_one_line(insn, src_text);

                p = line_end;
                if (*p == '\n') {
                        p++;
                        line_no++;
                }
        }

        /* Pool-label auto-alignment: post-parse, attach the
         * needs_4byte_align flag to every label whose next non-
         * comment record is a pool data directive. See
         * pool_alignment_design.md. The compute pass runs
         * unconditionally so the flag is set whether or not -d-sim
         * is enabled. */
        sh_compute_pool_alignment(body);

        /* -d-sim: post-parse, run the symbolic simulator on this
         * body and report its r4-preservation verdict. The result
         * is informational only — Phase A's hot path doesn't
         * consult the simulator yet. The verdict format is one
         * line per body, ready to grep:
         *
         *   [sim] PRESERVES_R4 (n_insns=12)
         *   [sim] WRITES_R4    (n_insns=8)
         */
        if (sh_dflag_sim) {
                enum sh_sim_verdict v =
                        sh_sim_preserves_r4_body(body,
                                                 sh_sim_dbg_oracle,
                                                 NULL);
                fprint(stderr, "[sim] %s (n_insns=%d)\n",
                       v == SH_SIM_PRESERVES ? "PRESERVES_R4"
                                             : "WRITES_R4",
                       body->n_insns);
                /* Each .asm_entry sub-entry gets its own verdict
                 * line, printed in source order. */
                sh_sim_visit_entries(body, sh_sim_dbg_oracle, NULL,
                                     sh_sim_dbg_visit_entry, NULL);
        }
        return body;
}

/* ── canonical emit (Stage 2) ─────────────────────────
 *
 * Re-format a parsed instruction in the same `\t<mn>\t<ops>\n`
 * layout C-derived emit produces. Source whitespace is discarded;
 * the assembled .o bytes are unchanged because the SH-2 assembler
 * doesn't care about whitespace within the instruction.
 *
 * Operand printers below produce the canonical form for each
 * operand kind. Comments / blank lines / labels emit their
 * original src_text (no canonical form for them). Directives emit
 * `\t<directive>\t<operands>\n`.
 * ──────────────────────────────────────────────────── */

static const char *sh_sreg_name(enum sh_sreg_id id) {
        switch (id) {
        case SH_SR_PR:   return "pr";
        case SH_SR_GBR:  return "gbr";
        case SH_SR_VBR:  return "vbr";
        case SH_SR_SR:   return "sr";
        case SH_SR_MACH: return "mach";
        case SH_SR_MACL: return "macl";
        case SH_SR_T:    return "t";
        default:         return "?";
        }
}

static void sh_emit_operand(const struct sh_operand *op, int as_directive) {
        switch (op->kind) {
        case SH_OP_NONE:
                break;
        case SH_OP_REG:
                print("r%d", op->reg);
                break;
        case SH_OP_SREG:
                print("%s", sh_sreg_name(op->sreg));
                break;
        case SH_OP_IMM:
                /* Directive operands (`.byte 0x30`, `.long 4`) print
                 * as bare values — the SH-2 assembler rejects `#`
                 * outside instruction immediate context. Instruction
                 * operands (`mov #1, r3`) keep the `#` prefix. */
                if (op->label)
                        print(as_directive ? "%s" : "#%s", op->label);
                else
                        print(as_directive ? "%d" : "#%d", (int)op->imm);
                break;
        case SH_OP_LABEL:
                print("%s", op->label ? op->label : "?");
                break;
        case SH_OP_MEM:
                switch (op->mem_mode) {
                case SH_MEM_INDIR:
                        print("@r%d", op->reg);
                        break;
                case SH_MEM_PREDEC:
                        print("@-r%d", op->reg);
                        break;
                case SH_MEM_POSTINC:
                        print("@r%d+", op->reg);
                        break;
                case SH_MEM_DISP:
                        print("@(%d,r%d)", (int)op->imm, op->reg);
                        break;
                case SH_MEM_R0IDX:
                        print("@(r0,r%d)", op->reg);
                        break;
                case SH_MEM_GBRDISP:
                        print("@(%d,gbr)", (int)op->imm);
                        break;
                case SH_MEM_PCDISP:
                        print("@(%d,pc)", (int)op->imm);
                        break;
                default:
                        print("@?");
                        break;
                }
                break;
        }
}

static void sh_emit_asm_insn(const struct sh_asm_insn *in) {
        int i;
        if (!in) return;
        if (in->is_comment) {
                /* Blank or comment line — skip emission entirely.
                 * The assembled output doesn't need decorative
                 * whitespace from the source. */
                return;
        }
        if (in->is_label && !in->is_directive) {
                /* Standalone `LABEL:` line. */
                if (in->pool_align == 4)
                        print("\t.balign 4\n");
                else if (in->pool_align == 2)
                        print("\t.balign 2\n");
                print("%s:\n", in->mnemonic ? in->mnemonic : "?");
                return;
        }
        if (in->is_entry) {
                /* `.asm_entry FUN_X` expands into the assembler-
                 * visible form: `.global FUN_X` then `FUN_X:`. The
                 * source-level directive name doesn't survive emit
                 * — the linker only sees the global label. */
                const char *name = (in->n_operands >= 1
                                    && in->operands[0].kind == SH_OP_LABEL
                                    && in->operands[0].label)
                                   ? in->operands[0].label
                                   : "?";
                print("\t.global\t%s\n", name);
                print("%s:\n", name);
                return;
        }
        if (in->is_directive) {
                /* Directives don't fit the SH-2 instruction operand
                 * grammar. Forms like `.type X, @function` and
                 * `.string "..."` have shapes the per-operand parser
                 * can't represent without growing in unbounded
                 * directions. Emit directives verbatim from src_text:
                 * the assembler is the authority on operand syntax.
                 *
                 * Indent: bare directives get a leading tab
                 * (assembler convention); LABEL-prefixed directive
                 * lines start at column 0 (the label is its own
                 * statement). */
                const char *s = in->src_text;
                while (*s == ' ' || *s == '\t') s++;
                if (in->is_label) {
                        if (in->pool_align == 4)
                                print("\t.balign 4\n");
                        else if (in->pool_align == 2)
                                print("\t.balign 2\n");
                        print("%s", s);
                } else {
                        print("\t%s", s);
                }
                if (s[0] == 0 || s[strlen(s) - 1] != '\n')
                        print("\n");
                return;
        }
        if (in->is_unknown || !in->mnemonic) {
                /* Unparseable line — fall back to the original
                 * src_text so we don't drop content. */
                const char *s = in->src_text;
                while (*s == ' ' || *s == '\t') s++;
                print("\t%s", s);
                if (s[0] == 0 || s[strlen(s) - 1] != '\n')
                        print("\n");
                return;
        }
        /* Standard `\t<mn>\t<op1>,<op2>\n` form. */
        print("\t%s", in->mnemonic);
        if (in->n_operands > 0) {
                print("\t");
                for (i = 0; i < in->n_operands; i++) {
                        if (i > 0) print(",");
                        sh_emit_operand(&in->operands[i], 0);
                }
        }
        print("\n");
}

/* Dump the parsed body to stderr in a stable, grep-friendly format
 * for the Stage 1 regtests. Each insn is one [asm-dump] line. */
static void sh_dump_asm_body(const struct sh_asm_body *body,
                             const char *label) {
        int i;
        fprint(stderr, "[asm-dump] BLOCK %s: %d insns\n",
               label ? label : "(anon)", body->n_insns);
        for (i = 0; i < body->n_insns; i++) {
                const struct sh_asm_insn *in = &body->insns[i];
                char flags[16];
                int fl = 0;
                flags[fl++] = '[';
                if (in->is_branch)    flags[fl++] = 'B';
                if (in->is_call)      flags[fl++] = 'C';
                if (in->is_directive) flags[fl++] = 'D';
                if (in->is_label)     flags[fl++] = 'L';
                if (in->is_comment)   flags[fl++] = 'M';
                if (in->is_unknown)   flags[fl++] = 'U';
                flags[fl++] = ']';
                flags[fl] = 0;
                fprint(stderr,
                       "[asm-dump]   %d %s mn=%s reads=0x%x writes=0x%x sr_r=0x%x sr_w=0x%x\n",
                       i, flags,
                       in->mnemonic ? in->mnemonic : "(none)",
                       (unsigned)in->reads, (unsigned)in->writes,
                       (unsigned)in->reads_sreg,
                       (unsigned)in->writes_sreg);
                fprint(stderr, "[asm-dump]     src: %s",
                       in->src_text);
                if (in->src_text[0]
                    && in->src_text[strlen(in->src_text) - 1] != '\n')
                        fprint(stderr, "\n");
        }
}

/* Return 1 if register `rN` is dead immediately after sh_lines[start]
 * — that is, the next reference to rN (forward scan) is a write
 * without an intervening read.  Conservative: bails (returns 0) at
 * any label or branch, since control flow may merge on paths we
 * haven't scanned.  If the scan reaches the end of the buffer
 * without seeing rN, the register is considered dead. */
static int sh_reg_dead_after(int start, int rN) {
        int i;
        for (i = start; i < sh_nlines; i++) {
                const char *s = sh_lines[i];
                if (s[0] == 0) continue;
                if (sh_is_label_line(s)) return 0;
                if (sh_has_prefix(s, "bt") || sh_has_prefix(s, "bf")
                    || sh_has_prefix(s, "bra") || sh_has_prefix(s, "jmp")
                    || sh_has_prefix(s, "jsr") || sh_has_prefix(s, "bsr")
                    || sh_has_prefix(s, "rts"))
                        return 0;
                if (sh_reads_reg(s, rN)) return 0;
                if (sh_writes_reg(s, rN)) return 1;
        }
        return 1;
}

/* Fold a base-rebuild + access sequence into a single displacement-
 * mode access.
 *
 *   mov rA, rB           →   mov.X @(K, rA), rC     (load)
 *   add #K, rB
 *   mov.X @rB, rC
 *
 *   mov rA, rB           →   mov.X rM, @(K, rA)     (store)
 *   add #K, rB
 *   mov.X rM, @rB
 *
 * SH-2 displacement constraints:
 *   mov.b disp 0..15, other reg must be R0
 *   mov.w disp 0..30 (even), other reg must be R0
 *   mov.l disp 0..60 (×4), any Rm
 *
 * Safety: rB must be dead immediately after the access (scan
 * forward until a write to rB without intervening read, or bail at
 * labels/branches).  Closes the load/store side of Gap 7 — the
 * "clustered base + same-base multi-access" pattern that SHC
 * compiles to displacement mode where LCC currently rebuilds the
 * base for each access.
 *
 * The rarer T2 store-chain pattern (multiple stores sharing a base
 * via repeated mov/add) is handled implicitly when rB dies between
 * the store and the next rebuild: each link collapses independently
 * because the next `mov rA, rB` is a pure write to rB. */

/* Mark sh_lines[j] as killed. All passes that scan sh_lines[] skip
 * entries whose first byte is 0. Centralizing this idiom (formerly
 * `sh_lines[j][0] = 0` sprinkled across ~19 sites) gives us:
 *   - a bounds assertion that catches off-by-one bugs in pass code
 *   - a single point to instrument if we ever add an invariant check
 *     (e.g. "no pass may read a line it previously killed").
 * See methodology_remediation C2.b for the rationale. */
static void sh_kill_line(int j) {
        assert(j >= 0 && j < sh_nlines);
        sh_lines[j][0] = 0;
}

static void sh_fold_base_displacement(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines; i++) {
                int rA, rB1, K, rB2;
                char size;
                int rB3, r_other;
                int is_store = 0;
                int disp_ok = 0;

                if (sh_lines[i][0] == 0) continue;
                if (sscanf(sh_lines[i], "\tmov\tr%d,r%d\n",
                           &rA, &rB1) != 2)
                        continue;
                if (rA == rB1) continue;

                j = i + 1;
                while (j < sh_nlines && sh_lines[j][0] == 0) j++;
                if (j >= sh_nlines) continue;
                if (sscanf(sh_lines[j], "\tadd\t#%d,r%d\n",
                           &K, &rB2) != 2
                    || rB2 != rB1)
                        continue;

                k = j + 1;
                while (k < sh_nlines && sh_lines[k][0] == 0) k++;
                if (k >= sh_nlines) continue;

                /* Try load first: mov.X @rB, rC */
                if (sscanf(sh_lines[k], "\tmov.%c\t@r%d,r%d\n",
                           &size, &rB3, &r_other) == 3
                    && rB3 == rB1) {
                        is_store = 0;
                } else if (sscanf(sh_lines[k], "\tmov.%c\tr%d,@r%d\n",
                                  &size, &r_other, &rB3) == 3
                           && rB3 == rB1) {
                        is_store = 1;
                } else {
                        continue;
                }

                /* Displacement fits the size's constraints? */
                if (size == 'l') {
                        disp_ok = (K >= 0 && K <= 60
                                   && (K % 4) == 0);
                } else if (size == 'w') {
                        disp_ok = (K >= 0 && K <= 30
                                   && (K % 2) == 0
                                   && r_other == 0);
                } else if (size == 'b') {
                        disp_ok = (K >= 0 && K <= 15
                                   && r_other == 0);
                }
                if (!disp_ok) continue;

                /* Safety: the transform leaves rB1 with its pre-load
                 * value (= whatever was in rB1 before `mov rA,rB1`).
                 * The original sequence leaves rB1 with either the
                 * loaded value (rB1==rC, load case) or rA+K (rB1!=rC
                 * load, or store).
                 *
                 * When the original and transformed post-values for
                 * rB1 agree — i.e., rB1==rC for a load, because the
                 * load writes the same register the transform writes
                 * via rC — no liveness check is needed.  Otherwise
                 * rB1 must be dead after the access for the rewrite
                 * to be semantics-preserving. */
                if (!(is_store == 0 && r_other == rB1)
                    && !sh_reg_dead_after(k + 1, rB1))
                        continue;

                /* Apply. */
                if (is_store) {
                        snprintf(sh_lines[k], SH_MAX_LINELEN,
                                 "\tmov.%c\tr%d,@(%d,r%d)\n",
                                 size, r_other, K, rA);
                } else {
                        snprintf(sh_lines[k], SH_MAX_LINELEN,
                                 "\tmov.%c\t@(%d,r%d),r%d\n",
                                 size, K, rA, r_other);
                }
                sh_kill_line(i);
                sh_kill_line(j);
        }
}

/* Peephole: fill the nop delay slot after each bra/bsr/jsr/jmp
 * with a safe preceding instruction. Scans backward from the
 * branch, allowing the walk to pass OVER PC-relative pool loads
 * (they're our own emission pattern and never really block motion
 * as long as the candidate doesn't share registers with them).
 * Halts on any label, branch, or non-delay-safe instruction.
 *
 * When a candidate is found we verify:
 *   - Its register set is disjoint from every intermediate pool
 *     load's destination register (else moving it past them would
 *     see a stale input or clobber a later read).
 *   - For jsr/jmp, it doesn't rewrite the branch's target register
 *     (the CPU reads the target at branch time, which is AFTER the
 *     delay slot runs).
 */
static void sh_fill_branch_delays(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines - 1; i++) {
                int tgt_reg;
                unsigned intermediate_mask = 0;
                int cand = -1;
                if (sh_lines[i][0] == 0)
                        continue;
                if (!sh_is_branch_line(sh_lines[i]))
                        continue;
                for (j = i + 1; j < sh_nlines; j++) {
                        if (sh_lines[j][0] == 0)
                                continue;
                        break;
                }
                if (j >= sh_nlines)
                        continue;
                if (!sh_has_prefix(sh_lines[j], "nop"))
                        continue;
                tgt_reg = sh_branch_target_reg(sh_lines[i]);

                for (k = i - 1; k >= 0; k--) {
                        unsigned cand_regs;
                        if (sh_lines[k][0] == 0)
                                continue;
                        if (sh_is_label_line(sh_lines[k]))
                                break;
                        if (sh_is_branch_line(sh_lines[k]))
                                break;
                        if (!sh_is_delay_safe(sh_lines[k]))
                                break;
                        cand_regs = sh_regs_used(sh_lines[k]);
                        if (sh_is_pc_rel_load(sh_lines[k])) {
                                intermediate_mask |= cand_regs;
                                continue;
                        }
                        if (cand_regs & intermediate_mask)
                                break;
                        if (tgt_reg >= 0
                            && sh_writes_reg(sh_lines[k], tgt_reg))
                                break;
                        /* Reject k if it occupies another branch's
                         * delay slot.  Stealing it un-fills the earlier
                         * branch — and because the candidate-search
                         * skips empty lines on output, the branch's
                         * NEXT lexical neighbour silently slides into
                         * the now-vacated slot position.  When that
                         * neighbour is itself a branch (a `bra L` two
                         * lines after a `jsr @r0` after the steal),
                         * the emitted stream ends up with a branch in
                         * a delay slot — illegal SH-2 per SH7604
                         * §branch-instructions ("any branch, MOVA, or
                         * TRAPA in a delay slot is forbidden"). */
                        {
                                int p, in_delay = 0;
                                for (p = k - 1; p >= 0; p--) {
                                        if (sh_lines[p][0] == 0)
                                                continue;
                                        if (sh_is_branch_line(sh_lines[p]))
                                                in_delay = 1;
                                        break;
                                }
                                if (in_delay)
                                        break;
                        }
                        cand = k;
                        break;
                }
                if (cand < 0)
                        continue;
                strncpy(sh_lines[j], sh_lines[cand],
                        SH_MAX_LINELEN - 1);
                sh_lines[j][SH_MAX_LINELEN - 1] = 0;
                sh_kill_line(cand);
        }
}

/* Delay-slot safety for CONDITIONAL branches (bt/s, bf/s).
 * Stricter than sh_is_delay_safe: also excludes T-flag-modifying
 * instructions, because they originally set the T bit that the
 * branch reads, and moving them past the branch would mean the
 * branch reads the wrong T.
 *
 * Excluded beyond sh_is_delay_safe: shll, shlr, shar (1-bit
 * forms), addc/addv, subc/subv, negc, and all the cmp/tst forms
 * that sh_is_delay_safe already rejects.  Multi-bit shift forms
 * (shll2/shll8/shll16 etc.) don't modify T and are safe. */
static int sh_is_cond_delay_safe(const char *s) {
        if (!sh_is_delay_safe(s)) return 0;
        while (*s == ' ' || *s == '\t') s++;
        /* 1-bit shll/shlr/shar modify T.  sh_has_prefix already
         * rejects shll2/8/16 because those don't end after "shll".
         * But sh_has_prefix(s,"shll") matches "shll" followed by
         * whitespace — the 1-bit form.  That's what we need to
         * reject here. */
        if (sh_has_prefix(s, "shll")
            || sh_has_prefix(s, "shlr")
            || sh_has_prefix(s, "shar"))
                return 0;
        /* addc/addv/subc/subv modify T. */
        if ((sh_has_prefix(s, "add") && (s[3] == 'c' || s[3] == 'v'))
            || (sh_has_prefix(s, "sub") && (s[3] == 'c' || s[3] == 'v'))
            || (sh_has_prefix(s, "neg") && s[3] == 'c'))
                return 0;
        return 1;
}

/* Fill bt/bf delay slots: convert `<insn>; bt L` to `bt/s L; <insn>`
 * when <insn> is safe to execute in the delay slot.  Requires an
 * insert-after-branch, so we rebuild via new_lines[]. */
static void sh_fill_cond_delays(void) {
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        static int cand_for_branch[SH_MAX_LINES];
        static int branch_for_cand[SH_MAX_LINES];
        int i, k, nout = 0;

        for (i = 0; i < sh_nlines; i++) {
                cand_for_branch[i] = -1;
                branch_for_cand[i] = -1;
        }

        /* Pass 1: identify (branch, candidate) pairs. */
        for (i = 0; i < sh_nlines; i++) {
                unsigned intermediate_mask = 0;
                int cand = -1;
                const char *p;
                if (sh_lines[i][0] == 0) continue;
                p = sh_lines[i];
                while (*p == ' ' || *p == '\t') p++;
                /* Must be bt or bf (not bt/s, bf/s). */
                if (!(p[0] == 'b' && (p[1] == 't' || p[1] == 'f')))
                        continue;
                if (p[2] == '/' && p[3] == 's') continue;
                if (p[2] != '\t' && p[2] != ' ') continue;

                for (k = i - 1; k >= 0; k--) {
                        unsigned cand_regs;
                        const char *q;
                        if (sh_lines[k][0] == 0) continue;
                        if (cand_for_branch[k] >= 0) break;
                        if (branch_for_cand[k] >= 0) break;
                        if (sh_is_label_line(sh_lines[k])) break;
                        if (sh_is_branch_line(sh_lines[k])) break;
                        q = sh_lines[k];
                        while (*q == ' ' || *q == '\t') q++;
                        if (q[0] == 'b' && (q[1] == 't' || q[1] == 'f'))
                                break;
                        /* Pass over the cmp/tst/dt that set T — the
                         * candidate instruction we seek lies BEFORE
                         * them.  Track their register mentions in
                         * intermediate_mask so the candidate check
                         * rejects conflicting candidates. */
                        if (sh_has_prefix(sh_lines[k], "cmp")
                            || sh_has_prefix(sh_lines[k], "tst")
                            || sh_has_prefix(sh_lines[k], "dt")) {
                                intermediate_mask |=
                                        sh_regs_used(sh_lines[k]);
                                continue;
                        }
                        if (!sh_is_cond_delay_safe(sh_lines[k])) break;
                        cand_regs = sh_regs_used(sh_lines[k]);
                        if (sh_is_pc_rel_load(sh_lines[k])) {
                                intermediate_mask |= cand_regs;
                                continue;
                        }
                        if (cand_regs & intermediate_mask) break;
                        cand = k;
                        break;
                }

                if (cand >= 0) {
                        cand_for_branch[i] = cand;
                        branch_for_cand[cand] = i;
                }
        }

        /* Pass 2: rebuild with bt→bt/s and delay slot inserted. */
        for (i = 0; i < sh_nlines; i++) {
                if (nout >= SH_MAX_LINES - 2) break;
                if (branch_for_cand[i] >= 0) {
                        /* Moved candidate — skip. */
                        continue;
                }
                if (cand_for_branch[i] >= 0) {
                        const char *p = sh_lines[i];
                        const char *rest;
                        char bname[8];
                        while (*p == ' ' || *p == '\t') p++;
                        if (p[1] == 't') strcpy(bname, "bt/s");
                        else strcpy(bname, "bf/s");
                        rest = p + 2;
                        while (*rest == ' ' || *rest == '\t') rest++;
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\t%s\t%s", bname, rest);
                        strcpy(new_lines[nout++],
                               sh_lines[cand_for_branch[i]]);
                        continue;
                }
                if (sh_lines[i][0] == 0) {
                        new_lines[nout++][0] = 0;
                        continue;
                }
                strcpy(new_lines[nout++], sh_lines[i]);
        }

        memcpy(sh_lines, new_lines, sizeof sh_lines);
        sh_nlines = nout;
}

/* Peephole: delete `mov rA,rB` ... `mov rB,rA` pairs when no
 * instruction between them touches rA or rB. LCC's register
 * allocator leaves this pattern after every call (the call result
 * lands in r0, gets copied to the node's destination, and then
 * copied back to r0 for use by the next expression) and after some
 * arithmetic chains. Empty lines are written as `\\0` in place so
 * the flush loop can skip them. */
static void sh_peephole(void) {
        int i, j;
        for (i = 0; i < sh_nlines; i++) {
                int rA, rB, rX, rY;
                if (!sh_parse_regmov(sh_lines[i], &rA, &rB))
                        continue;
                if (rA == rB)
                        continue;
                for (j = i + 1; j < sh_nlines; j++) {
                        unsigned mask;
                        if (sh_lines[j][0] == 0)
                                continue;
                        if (sh_parse_regmov(sh_lines[j], &rX, &rY)
                            && rX == rB && rY == rA) {
                                sh_kill_line(i);
                                sh_kill_line(j);
                                break;
                        }
                        mask = sh_regs_used(sh_lines[j]);
                        if (mask & ((1u << rA) | (1u << rB)))
                                break;
                }
        }
}

/* Rewrite displacement-from-param-register to GBR-relative.
 * When #pragma gbr_param is active, the first parameter (r4) is
 * loaded into GBR via `ldc r4,gbr` in the prologue.  This pass
 * finds the callee-saved register holding r4 and converts
 * `mov.X @(disp,rP),rD` to `mov.X @(disp,gbr),r0` (+ mov if
 * rD != r0).  Also converts add+indirect sequences for offsets
 * that fit GBR displacement but not regular displacement. */
static void sh_rewrite_gbr_param(void) {
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int i, nout = 0, param_reg = -1;

        /* Find the param register: look for `mov r4,rN` near start. */
        for (i = 0; i < sh_nlines && i < 10; i++) {
                int rn;
                if (sh_lines[i][0] == 0) continue;
                if (sscanf(sh_lines[i], "\tmov\tr4,r%d\n", &rn) == 1) {
                        param_reg = rn;
                        break;
                }
        }
        if (param_reg < 0)
                return;

        for (i = 0; i < sh_nlines; i++) {
                int disp, rd, rs, rt, n;
                char suf;
                int handled = 0;

                if (nout >= SH_MAX_LINES - 4) break;
                if (sh_lines[i][0] == 0) {
                        new_lines[nout][0] = 0; nout++;
                        continue;
                }

                /* Pattern A0: simple indirect load @rP (offset 0). */
                if (sscanf(sh_lines[i], "\tmov.%c\t@r%d,r%d\n",
                           &suf, &rs, &rd) == 3
                    && rs == param_reg) {
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov.%c\t@(0,gbr),r0\n", suf);
                        if (rd != 0)
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov\tr0,r%d\n", rd);
                        handled = 1;
                }

                /* Pattern A: displacement load from param reg. */
                if (!handled
                    && sscanf(sh_lines[i], "\tmov.%c\t@(%d,r%d),r%d\n",
                           &suf, &disp, &rs, &rd) == 4
                    && rs == param_reg) {
                        int maxd = suf=='b'?255 : suf=='w'?510 : 1020;
                        if (disp >= 0 && disp <= maxd) {
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.%c\t@(%d,gbr),r0\n",
                                         suf, disp);
                                if (rd != 0)
                                        snprintf(new_lines[nout++],
                                                 SH_MAX_LINELEN,
                                                 "\tmov\tr0,r%d\n", rd);
                                handled = 1;
                        }
                }

                /* Pattern B: displacement store to param reg. */
                if (!handled
                    && sscanf(sh_lines[i], "\tmov.%c\tr%d,@(%d,r%d)\n",
                              &suf, &rs, &disp, &rd) == 4
                    && rd == param_reg) {
                        int maxd = suf=='b'?255 : suf=='w'?510 : 1020;
                        if (disp >= 0 && disp <= maxd) {
                                if (rs != 0)
                                        snprintf(new_lines[nout++],
                                                 SH_MAX_LINELEN,
                                                 "\tmov\tr%d,r0\n", rs);
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.%c\tr0,@(%d,gbr)\n",
                                         suf, disp);
                                handled = 1;
                        }
                }

                /* Pattern C: add+indirect load from param reg copy.
                 * mov rP,rT; add #N,rT; mov.X @rT,rD */
                if (!handled && i + 2 < sh_nlines
                    && sscanf(sh_lines[i], "\tmov\tr%d,r%d\n",
                              &rs, &rt) == 2
                    && rs == param_reg
                    && sh_lines[i+1][0] != 0
                    && sscanf(sh_lines[i+1], "\tadd\t#%d,r%d\n",
                              &n, &rd) == 2
                    && rd == rt
                    && sh_lines[i+2][0] != 0
                    && sscanf(sh_lines[i+2], "\tmov.%c\t@r%d,r%d\n",
                              &suf, &rs, &rd) == 3
                    && rs == rt) {
                        int maxd = suf=='b'?255 : suf=='w'?510 : 1020;
                        if (n >= 0 && n <= maxd) {
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.%c\t@(%d,gbr),r0\n",
                                         suf, n);
                                if (rd != 0)
                                        snprintf(new_lines[nout++],
                                                 SH_MAX_LINELEN,
                                                 "\tmov\tr0,r%d\n", rd);
                                i += 2;
                                handled = 1;
                        }
                }

                /* Pattern D: add+indirect store from param reg copy.
                 * mov rP,rT; add #N,rT; mov.X rS,@rT */
                if (!handled && i + 2 < sh_nlines
                    && sscanf(sh_lines[i], "\tmov\tr%d,r%d\n",
                              &rs, &rt) == 2
                    && rs == param_reg
                    && sh_lines[i+1][0] != 0
                    && sscanf(sh_lines[i+1], "\tadd\t#%d,r%d\n",
                              &n, &rd) == 2
                    && rd == rt
                    && sh_lines[i+2][0] != 0
                    && sscanf(sh_lines[i+2], "\tmov.%c\tr%d,@r%d\n",
                              &suf, &rs, &rd) == 3
                    && rd == rt) {
                        int maxd = suf=='b'?255 : suf=='w'?510 : 1020;
                        if (n >= 0 && n <= maxd) {
                                if (rs != 0)
                                        snprintf(new_lines[nout++],
                                                 SH_MAX_LINELEN,
                                                 "\tmov\tr%d,r0\n", rs);
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.%c\tr0,@(%d,gbr)\n",
                                         suf, n);
                                i += 2;
                                handled = 1;
                        }
                }

                if (!handled) {
                        strcpy(new_lines[nout++], sh_lines[i]);
                }
        }

        memcpy(sh_lines, new_lines, sizeof sh_lines);
        sh_nlines = nout;
}

/* Eliminate redundant sign/zero extensions after loads.
 * SH-2 mov.w sign-extends to 32 bits and mov.b sign-extends to 32
 * bits.  LCC emits a separate CVII4 → exts.w/exts.b even though
 * the hardware already did it.  This pass tracks which registers
 * hold sign-extended values (from .w/.b loads or copies thereof)
 * and deletes the redundant exts, or replaces exts rN,rM with
 * mov rN,rM when it's a cross-register sign-extend-and-copy. */
static void sh_elim_redundant_ext(void) {
        int i;
        unsigned w_ext = 0;   /* regs holding sign-extended .w values */
        unsigned b_ext = 0;   /* regs holding sign-extended .b values */

        for (i = 0; i < sh_nlines; i++) {
                int r1, r2;
                char suf;
                const char *s = sh_lines[i];

                if (s[0] == 0) continue;

                /* Labels reset tracking — control can arrive from
                 * anywhere, so we can't know extension state. */
                if (sh_is_label_line(s)) {
                        w_ext = b_ext = 0;
                        continue;
                }

                /* mov.w load: dest is sign-extended from 16 bits.
                 * Covers: @rN (indirect), @(disp,rN) displacement mode,
                 * @(r0,rN) indexed mode, @(disp,gbr) GBR-relative, and
                 * Lx literal-pool loads. All five forms sign-extend
                 * the 16-bit value into the 32-bit destination. */
                if (sscanf(s, "\tmov.w\t@r%*d,r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.w\t@(%*d,r%*d),r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.w\t@(r0,r%*d),r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.w\t@(%*d,gbr),r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.w\tL%*d,r%d\n", &r1) == 1) {
                        w_ext |= 1u << r1;
                        b_ext &= ~(1u << r1);
                        continue;
                }

                /* mov.b load: dest is sign-extended from 8 bits. */
                if (sscanf(s, "\tmov.b\t@r%*d,r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.b\t@(%*d,r%*d),r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.b\t@(r0,r%*d),r%d\n", &r1) == 1
                    || sscanf(s, "\tmov.b\t@(%*d,gbr),r%d\n", &r1) == 1) {
                        b_ext |= 1u << r1;
                        w_ext &= ~(1u << r1);
                        continue;
                }

                /* mov rN,rM: propagate extension tracking. */
                if (sscanf(s, "\tmov\tr%d,r%d\n", &r1, &r2) == 2) {
                        unsigned new_w = 0, new_b = 0;
                        if (w_ext & (1u << r1)) new_w = 1u << r2;
                        if (b_ext & (1u << r1)) new_b = 1u << r2;
                        /* Clear r2's old state, set new. */
                        w_ext = (w_ext & ~(1u << r2)) | new_w;
                        b_ext = (b_ext & ~(1u << r2)) | new_b;
                        continue;
                }

                /* exts.w rN,rM: redundant if rN is already .w
                 * sign-extended. */
                if (sscanf(s, "\texts.w\tr%d,r%d\n", &r1, &r2) == 2
                    && (w_ext & (1u << r1))) {
                        if (r1 == r2) {
                                sh_kill_line(i);   /* delete */
                        } else {
                                snprintf(sh_lines[i], SH_MAX_LINELEN,
                                         "\tmov\tr%d,r%d\n", r1, r2);
                                w_ext |= 1u << r2;
                        }
                        continue;
                }

                /* exts.b rN,rM: redundant if rN is already .b
                 * sign-extended. */
                if (sscanf(s, "\texts.b\tr%d,r%d\n", &r1, &r2) == 2
                    && (b_ext & (1u << r1))) {
                        if (r1 == r2) {
                                sh_kill_line(i);
                        } else {
                                snprintf(sh_lines[i], SH_MAX_LINELEN,
                                         "\tmov\tr%d,r%d\n", r1, r2);
                                b_ext |= 1u << r2;
                        }
                        continue;
                }

                /* exts.w / exts.b that survive: the dest IS now
                 * extended (the instruction does the work). */
                if (sscanf(s, "\texts.%c\tr%d,r%d\n", &suf, &r1, &r2) == 3) {
                        if (suf == 'w') w_ext |= 1u << r2;
                        if (suf == 'b') b_ext |= 1u << r2;
                        continue;
                }

                /* Any other instruction that writes a register:
                 * clear that register's extension state. Use the
                 * last register on the line as the destination
                 * (same heuristic as sh_writes_reg). */
                {
                        const char *p = s;
                        const char *last_r = NULL;
                        int rn;
                        while (*p) {
                                if (*p == 'r' && p[1] >= '0' && p[1] <= '9')
                                        last_r = p;
                                p++;
                        }
                        if (last_r) {
                                last_r++;
                                rn = *last_r - '0';
                                if (last_r[1] >= '0' && last_r[1] <= '9')
                                        rn = rn * 10 + (last_r[1] - '0');
                                if (rn < 16) {
                                        w_ext &= ~(1u << rn);
                                        b_ext &= ~(1u << rn);
                                }
                        }
                }

                /* Calls clobber caller-saved regs r0-r7. */
                if (sh_has_prefix(s, "jsr") || sh_has_prefix(s, "bsr")) {
                        w_ext &= ~0xFFu;
                        b_ext &= ~0xFFu;
                }
        }
}

/* Count references to pool label Lnn across all sh_lines[].  Used
 * by sh_fold_mov_extw_to_movw to decide whether shrinking a pool
 * entry from .long to .short is safe — must be exactly 1 reader.
 *
 * Matches "L<n>" as a whole-token, so L1 doesn't spuriously match
 * inside L10 / L11.  Pool definitions themselves live in the
 * shlits[] array, not sh_lines, so we only count code references. */
static int sh_pool_label_refcount(int lab) {
        int i, count = 0;
        char needle[16];
        int nlen;
        snprintf(needle, sizeof needle, "L%d", lab);
        nlen = (int)strlen(needle);
        for (i = 0; i < sh_nlines; i++) {
                const char *s = sh_lines[i];
                const char *p = s;
                if (s[0] == 0) continue;
                while ((p = strstr(p, needle))) {
                        char c = p[nlen];
                        /* Whole-token: following char must not
                         * extend the label (i.e., not a digit). */
                        if (!(c >= '0' && c <= '9'))
                                count++;
                        p++;
                }
        }
        return count;
}

/* Fold `mov.l Lx,rN; exts.w rN,rN` into a single `mov.w Lx,rN`
 * and shrink the pool entry from .long to .short.
 *
 * mov.w sign-extends the 16-bit pool value to 32 bits on load —
 * the same thing the following exts.w was doing.  When the
 * consumer only needs the sign-extended low 16 bits (signalled by
 * CVII4 emitting exts.w right after the constant load), the
 * two-instruction sequence is equivalent to a single sign-
 * extending word load with a narrower pool entry.
 *
 * This is what SHC emits for patterns like `x & (int)(short)C`
 * where C doesn't fit directly in signed short range at parse
 * time: LCC's CNST+I path loads the full 32 bits via .long and
 * then CVII4 emits exts.w; SHC collapses to mov.w + .short with
 * the low 16 bits.  Same runtime value, 2 fewer bytes of code and
 * 2 fewer bytes of pool.
 *
 * Safety: when a pool entry has multiple readers, ALL of them
 * must be `mov.l + exts.w (self)` pairs — otherwise shrinking
 * would break the 32-bit readers.  Also requires src == dst on
 * the exts.w so no other register's live value is lost. */
static void sh_fold_mov_extw_to_movw(void) {
        int j;
        /* Iterate by shlit entry — evaluate "are ALL readers of
         * this label fold-eligible" atomically before touching
         * anything.  For any pool entry where every reference is
         * a `mov.l Lx,rN; exts.w rN,rN` pair, rewrite all sites
         * to `mov.w Lx,rN` and shrink the pool to .short. */
        for (j = 0; j < nshlit; j++) {
                int lab = shlits[j].label;
                int i, k, total_refs;
                int match_lines[SH_MAX_LITERALS];
                int match_count = 0;
                int all_ok = 1;

                if (shlits[j].is_symbol) continue;
                if (shlits[j].is_word) continue;
                total_refs = sh_pool_label_refcount(lab);
                if (total_refs == 0) continue;

                /* Walk the code finding every `mov.l Lx,rA` site;
                 * each one must be immediately followed by a
                 * matching `exts.w rA,rA`. */
                for (i = 0; i < sh_nlines && all_ok; i++) {
                        int lab2, rA, rB, rC;
                        if (sh_lines[i][0] == 0) continue;
                        if (sscanf(sh_lines[i], "\tmov.l\tL%d,r%d\n",
                                   &lab2, &rA) != 2)
                                continue;
                        if (lab2 != lab) continue;
                        k = i + 1;
                        while (k < sh_nlines && sh_lines[k][0] == 0)
                                k++;
                        if (k >= sh_nlines
                            || sscanf(sh_lines[k],
                                      "\texts.w\tr%d,r%d\n",
                                      &rB, &rC) != 2
                            || rA != rB || rB != rC) {
                                all_ok = 0;
                                break;
                        }
                        if (match_count < SH_MAX_LITERALS)
                                match_lines[match_count++] = i;
                }
                if (!all_ok) continue;

                /* All mov.l readers fit the pattern.  If there are
                 * additional reference forms (mova, .short tables,
                 * etc.) that the refcount saw but we didn't match,
                 * bail — we can't shrink safely. */
                if (match_count != total_refs) continue;

                /* Apply. */
                for (i = 0; i < match_count; i++) {
                        int line_i = match_lines[i];
                        int lab2, rA;
                        sscanf(sh_lines[line_i],
                               "\tmov.l\tL%d,r%d\n", &lab2, &rA);
                        snprintf(sh_lines[line_i], SH_MAX_LINELEN,
                                 "\tmov.w\tL%d,r%d\n", lab, rA);
                        k = line_i + 1;
                        while (k < sh_nlines && sh_lines[k][0] == 0)
                                k++;
                        if (k < sh_nlines)
                                sh_kill_line(k);
                }
                shlits[j].is_word = 1;
                shlits[j].value = (short)shlits[j].value;
        }
}

/* Check whether R0 is dead at sh_lines[start_idx] — that is,
 * whether we can clobber R0 without losing a value we'll need.
 * R0 is dead if the next reference to R0 (forward scan) is a
 * write before any read.  Returns 1 if dead, 0 if live or
 * uncertain.  Conservative: bails (returns 0) at the first
 * label or branch encountered, since control flow merges may
 * make R0 live on some path. */
static int sh_r0_dead_at(int start_idx) {
        int i;
        for (i = start_idx; i < sh_nlines; i++) {
                const char *s = sh_lines[i];
                if (s[0] == 0) continue;
                /* Stop at any label or branch — conservative. */
                if (sh_is_label_line(s)) return 0;
                if (sh_has_prefix(s, "bt") || sh_has_prefix(s, "bf")
                    || sh_has_prefix(s, "bra") || sh_has_prefix(s, "jmp")
                    || sh_has_prefix(s, "jsr") || sh_has_prefix(s, "bsr")
                    || sh_has_prefix(s, "rts"))
                        return 0;
                /* Does this line read R0? Look for "r0" used as a
                 * source — appears in operand positions like ",r0",
                 * "r0,", "@r0", "@(r0,". A write to R0 has it as
                 * the LAST register on the line (sh_writes_reg
                 * convention). Heuristic: R0 is read if it appears
                 * not in the destination position. */
                {
                        unsigned regs = sh_regs_used(s);
                        int writes_r0 = sh_writes_reg(s, 0);
                        int reads_r0 = (regs & 1u) && !writes_r0;
                        /* Special case: instructions that write to
                         * R0 but also read R0 (like "add r1,r0"). We
                         * conservatively treat any "r0," appearance
                         * as a read. */
                        if (strstr(s, "r0,") && !sh_has_prefix(s, "mov\tr0,")
                            && !sh_has_prefix(s, "mov.l\tr0,@")
                            && !sh_has_prefix(s, "mov.w\tr0,@")
                            && !sh_has_prefix(s, "mov.b\tr0,@"))
                                reads_r0 = 1;
                        /* @(r0,...) is a read. */
                        if (strstr(s, "@(r0,"))
                                reads_r0 = 1;
                        if (reads_r0) return 0;
                        if (writes_r0) return 1;
                }
        }
        return 1;  /* End of body: R0 doesn't matter anymore. */
}

/* Convert add+indirect sequences to true indexed addressing when
 * R0 is dead at that point.  The regular ADDI4(reg,reg)+INDIR(reg)
 * pattern produces:
 *
 *     mov rA,rT       (the conditional ? mov from ADDI4 template)
 *     add rB,rT
 *     mov.X @rT,rD
 *
 * This pass converts to:
 *
 *     mov rA,r0
 *     mov.X @(r0,rB),rD
 *
 * saving one instruction per match.  Also handles the variant
 * without the leading mov (when rT == rA already, so the
 * conditional ? mov was omitted). */
static void sh_route_via_r0(void) {
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int i, nout = 0;

        for (i = 0; i < sh_nlines; i++) {
                int rA, rT, rB, rT2, rT3, rD;
                char suf;
                int matched = 0;

                if (sh_lines[i][0] == 0) {
                        new_lines[nout++][0] = 0;
                        continue;
                }

                /* Three-line: mov rA,rT; add rB,rT; mov.X @rT,rD */
                if (i + 2 < sh_nlines
                    && sscanf(sh_lines[i], "\tmov\tr%d,r%d\n",
                              &rA, &rT) == 2
                    && sh_lines[i+1][0] != 0
                    && sscanf(sh_lines[i+1], "\tadd\tr%d,r%d\n",
                              &rB, &rT2) == 2
                    && rT2 == rT
                    && sh_lines[i+2][0] != 0
                    && sscanf(sh_lines[i+2], "\tmov.%c\t@r%d,r%d\n",
                              &suf, &rT3, &rD) == 3
                    && rT3 == rT
                    && sh_r0_dead_at(i)) {
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov\tr%d,r0\n", rA);
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov.%c\t@(r0,r%d),r%d\n",
                                 suf, rB, rD);
                        i += 2;
                        matched = 1;
                }

                if (!matched)
                        strcpy(new_lines[nout++], sh_lines[i]);
        }

        memcpy(sh_lines, new_lines, sizeof sh_lines);
        sh_nlines = nout;
}

/* Delete label-only lines whose label is never referenced. LCC
 * emits a function-end label (e.g. L1:) before the epilogue so
 * mid-function return statements can branch to a shared exit. For
 * single-return functions that label is dead — nothing branches to
 * it and prod's output has no equivalent.
 *
 * Scope: only label-only lines (sh_is_label_line true). Pool-entry
 * lines like `L3: .long ...` are never considered for deletion,
 * since they define both label and data.
 *
 * Reference detection is token-based: the label name must appear
 * on another line not adjacent to an alphanumeric/underscore (so
 * `L1` in `L10:` isn't confused for a reference). */
static void sh_elim_dead_labels(void) {
        int i, j;
        for (i = 0; i < sh_nlines; i++) {
                char label[32];
                int llen, refcount;
                const char *s = sh_lines[i];
                const char *p;

                if (s[0] == 0) continue;
                if (!sh_is_label_line(s)) continue;

                p = s;
                while (*p == ' ' || *p == '\t') p++;
                llen = 0;
                while (p[llen] && p[llen] != ':' && llen < 30) {
                        label[llen] = p[llen];
                        llen++;
                }
                label[llen] = 0;
                if (llen == 0) continue;

                refcount = 0;
                for (j = 0; j < sh_nlines && refcount == 0; j++) {
                        const char *q = sh_lines[j];
                        if (j == i) continue;
                        if (q[0] == 0) continue;
                        while ((q = strstr(q, label)) != NULL) {
                                char next = q[llen];
                                if (!((next >= 'a' && next <= 'z')
                                      || (next >= 'A' && next <= 'Z')
                                      || (next >= '0' && next <= '9')
                                      || next == '_')) {
                                        refcount = 1;
                                        break;
                                }
                                q++;
                        }
                }

                if (refcount == 0)
                        sh_kill_line(i);
        }
}

/* Fuse `mov rA,rB; add rB,rC` into `add rA,rC` when rB is dead
 * after the add. Common shape after dispload + accumulator: the
 * load lands in r0, gets copied to a temp rN, then `add rN,accum`.
 * When rN is only the courier — not read again before being
 * overwritten — the copy is pure waste and can be replaced by a
 * direct `add rA,accum`.
 *
 * Liveness check: scan forward from the add; if rB is read before
 * being written, not safe. Stop at labels and branches (can't see
 * through control flow). */
static void sh_fuse_mov_into_add(void) {
        int i;
        for (i = 0; i + 1 < sh_nlines; i++) {
                int rA, rB, rB2, rC;
                int j, k;
                int dead;

                if (sh_lines[i][0] == 0) continue;
                if (sscanf(sh_lines[i], "\tmov\tr%d,r%d\n",
                           &rA, &rB) != 2)
                        continue;
                if (rA == rB) continue;

                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (sscanf(sh_lines[j], "\tadd\tr%d,r%d\n",
                           &rB2, &rC) != 2)
                        continue;
                if (rB2 != rB) continue;

                dead = 1;
                for (k = j + 1; k < sh_nlines; k++) {
                        if (sh_lines[k][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[k])) break;
                        if (sh_is_branch_line(sh_lines[k])) break;
                        if (sh_reads_reg(sh_lines[k], rB)) {
                                dead = 0;
                                break;
                        }
                        if (sh_writes_reg(sh_lines[k], rB))
                                break;
                }
                if (!dead) continue;

                snprintf(sh_lines[j], SH_MAX_LINELEN,
                         "\tadd\tr%d,r%d\n", rA, rC);
                sh_kill_line(i);
        }
}

/* #pragma sh_word_indexed_after_first implementation.
 *
 * Across the full Daytona CCE prod corpus (3873 functions, 19,087
 * disp-mode loads), there are exactly 3 cases where SHC chose
 * indexed addressing when displacement would have fit. Two of the
 * three are adjacent .w loads in FUN_06044834:
 *
 *     mov.w @(14,r4),r0     ; first .w disp — kept as disp
 *     mov r0,r1
 *     mov #0x1A,r0
 *     mov.w @(r0,r4),r0     ; would have fit disp, SHC chose indexed
 *     add r0,r1
 *     mov #0x1E,r0
 *     mov.w @(r0,r4),r0     ; same
 *     add r0,r1
 *
 * No generalizable rule explains this — it's one function out of
 * 3873 showing a pattern that costs 2 extra bytes per load for no
 * visible benefit. Most likely explanation: a Sega engineer wrote
 * this function (or annotated it with a compiler hint we don't
 * have) for reasons we cannot recover from the binary.
 *
 * This pragma is the opt-in mechanism to replicate that exact
 * SHC output shape on a per-function basis. The C source declares
 * intent; the compiler executes it.
 *
 * Rule: after the first .w displacement load targeting r0, convert
 * every subsequent .w disp-load to indexed form
 * (mov #K,r0; mov.w @(r0,rN),r0). Applies only to the function
 * decorated with `#pragma sh_word_indexed_after_first`. Cleared at function
 * end, so no TU-wide leakage.
 *
 * If new prod anomalies surface that don't fit this pattern, they
 * get their own numbered weird rule — don't widen this one. */
static void sh_apply_word_indexed_after_first(void) {
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int i, nout = 0, first_seen = 0;

        for (i = 0; i < sh_nlines; i++) {
                int disp, rN;

                if (sh_lines[i][0] == 0) {
                        new_lines[nout++][0] = 0;
                        continue;
                }
                if (sscanf(sh_lines[i],
                           "\tmov.w\t@(%d,r%d),r0\n",
                           &disp, &rN) == 2) {
                        if (!first_seen) {
                                first_seen = 1;
                                strcpy(new_lines[nout++], sh_lines[i]);
                                continue;
                        }
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov\t#%d,r0\n", disp);
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov.w\t@(r0,r%d),r0\n", rN);
                        continue;
                }
                strcpy(new_lines[nout++], sh_lines[i]);
        }
        memcpy(sh_lines, new_lines, sizeof sh_lines);
        sh_nlines = nout;
}

/* Fold `mov.X @rN,rM; ...; add #sz,rN` into `mov.X @rN+,rM`
 * (post-increment addressing) when no intervening instruction reads
 * or writes rN, and sz matches the access size (1/2/4).
 *
 * SH-2 post-increment updates rN as part of the load.  This
 * requires rN != rM (same register is undefined behavior).
 * The fold saves one instruction per loop iteration in pointer
 * walks. */
static void sh_fold_post_increment(void) {
        int i;
        for (i = 0; i + 1 < sh_nlines; i++) {
                char suf;
                int rN, rM, rN2, imm;
                int size, k;

                if (sh_lines[i][0] == 0) continue;

                if (sscanf(sh_lines[i], "\tmov.%c\t@r%d,r%d\n",
                           &suf, &rN, &rM) != 3)
                        continue;
                if (rN == rM) continue;  /* post-inc requires distinct */
                size = (suf == 'b') ? 1 : (suf == 'w') ? 2 : 4;

                /* Scan forward for matching `add #size, rN`.
                 * Bail at labels, branches, or any instruction that
                 * touches rN. */
                for (k = i + 1; k < sh_nlines; k++) {
                        unsigned regs;
                        if (sh_lines[k][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[k])) break;
                        if (sh_is_branch_line(sh_lines[k])) break;
                        {
                                const char *q = sh_lines[k];
                                while (*q == ' ' || *q == '\t') q++;
                                if (q[0] == 'b' && (q[1] == 't'
                                    || q[1] == 'f'))
                                        break;
                        }
                        if (sscanf(sh_lines[k], "\tadd\t#%d,r%d\n",
                                   &imm, &rN2) == 2
                            && rN2 == rN && imm == size) {
                                char buf[SH_MAX_LINELEN];
                                snprintf(buf, sizeof buf,
                                         "\tmov.%c\t@r%d+,r%d\n",
                                         suf, rN, rM);
                                strcpy(sh_lines[i], buf);
                                sh_kill_line(k);
                                break;
                        }
                        regs = sh_regs_used(sh_lines[k]);
                        if (regs & (1u << rN)) break;
                }
        }
}

/* Fold `add #-1,rN; tst rN,rN` into `dt rN`.
 * SH-2's dt instruction decrements and sets T if the result is zero.
 * Handles the case where an independent instruction sits between the
 * add and tst (reorders them to make the fold possible). */
static void sh_fold_dt(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines; i++) {
                int reg_add;
                const char *p;
                char tst_pat[32];

                if (sh_lines[i][0] == 0)
                        continue;
                /* Match `add #-1,rN` */
                p = sh_lines[i];
                while (*p == ' ' || *p == '\t') p++;
                if (!(p[0]=='a' && p[1]=='d' && p[2]=='d'))
                        continue;
                p += 3;
                while (*p == ' ' || *p == '\t') p++;
                if (!(p[0]=='#' && p[1]=='-' && p[2]=='1' && p[3]==','))
                        continue;
                p += 4;
                if (*p != 'r') continue;
                reg_add = atoi(p + 1);

                /* Look for `tst rN,rN` within the next few lines. */
                snprintf(tst_pat, sizeof tst_pat,
                         "\ttst\tr%d,r%d\n", reg_add, reg_add);
                for (j = i + 1; j < sh_nlines && j <= i + 3; j++) {
                        if (sh_lines[j][0] == 0)
                                continue;
                        if (strcmp(sh_lines[j], tst_pat) == 0) {
                                /* Check any intervening instruction
                                 * doesn't use rN. */
                                int safe = 1;
                                for (k = i + 1; k < j; k++) {
                                        if (sh_lines[k][0] == 0)
                                                continue;
                                        if (sh_regs_used(sh_lines[k])
                                            & (1u << reg_add)) {
                                                safe = 0;
                                                break;
                                        }
                                }
                                if (!safe)
                                        break;
                                /* Replace add with dt, delete tst. */
                                snprintf(sh_lines[i], SH_MAX_LINELEN,
                                         "\tdt\tr%d\n", reg_add);
                                sh_kill_line(j);
                                break;
                        }
                        /* If we hit a branch, stop. If we hit a label,
                         * check whether it's referenced anywhere — dead
                         * labels (from LCC codegen) are safe to skip. */
                        if (sh_is_uncond_branch(sh_lines[j]))
                                break;
                        if (sh_has_prefix(sh_lines[j], "bt")
                            || sh_has_prefix(sh_lines[j], "bf"))
                                break;
                        if (sh_is_label_line(sh_lines[j])) {
                                /* Extract label name and check if any
                                 * line in the body references it. */
                                char lbl[64];
                                int m, referenced = 0;
                                const char *lp = sh_lines[j];
                                int li = 0;
                                while (*lp && *lp != ':' && li < 62)
                                        lbl[li++] = *lp++;
                                lbl[li] = 0;
                                for (m = 0; m < sh_nlines; m++) {
                                        if (m == j || sh_lines[m][0] == 0)
                                                continue;
                                        if (sh_is_label_line(sh_lines[m]))
                                                continue;
                                        if (strstr(sh_lines[m], lbl)) {
                                                referenced = 1;
                                                break;
                                        }
                                }
                                if (referenced)
                                        break;
                                /* Dead label — safe to skip over. */
                                continue;
                        }
                        if (sh_has_prefix(sh_lines[j], "bt")
                            || sh_has_prefix(sh_lines[j], "bf"))
                                break;
                }
        }
}

/* Fold `bt/bf L1; bra L2; <insn>; L1: <overwrite>` into
 * `bf/s/bt/s L2; <insn>; L1: <overwrite>` when <insn> and
 * <overwrite> write the same destination register. The delay slot
 * of bf/s always executes; on the fall-through path, <overwrite>
 * replaces the delay slot's result. Saves one instruction (bra). */
static void sh_fold_conditional_delays(void) {
        int i, j, k, m, n;
        for (i = 0; i < sh_nlines; i++) {
                int is_bt, is_bf;
                char label1[64], label2[64];
                int ds_dst, ow_dst;
                char *p;

                if (sh_lines[i][0] == 0)
                        continue;
                is_bt = sh_has_prefix(sh_lines[i], "bt");
                is_bf = sh_has_prefix(sh_lines[i], "bf");
                if (!is_bt && !is_bf)
                        continue;
                /* Don't match bt/s or bf/s (already delayed). */
                p = sh_lines[i];
                while (*p == ' ' || *p == '\t') p++;
                if ((p[2] == '/' && p[3] == 's')
                    || (p[2] == '.' && p[3] == 's'))
                        continue;

                /* Extract bt/bf target label. */
                p += 2;
                while (*p == ' ' || *p == '\t') p++;
                {
                        int len = 0;
                        while (p[len] && p[len] != '\n'
                               && p[len] != ' ' && p[len] != '\t')
                                len++;
                        if (len == 0 || len >= (int)sizeof label1)
                                continue;
                        memcpy(label1, p, (size_t)len);
                        label1[len] = 0;
                }

                /* Next non-empty: must be `bra <label2>`. */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines
                    || !sh_has_prefix(sh_lines[j], "bra"))
                        continue;
                p = sh_lines[j];
                while (*p == ' ' || *p == '\t') p++;
                p += 3;
                while (*p == ' ' || *p == '\t') p++;
                {
                        int len = 0;
                        while (p[len] && p[len] != '\n'
                               && p[len] != ' ' && p[len] != '\t')
                                len++;
                        if (len == 0 || len >= (int)sizeof label2)
                                continue;
                        memcpy(label2, p, (size_t)len);
                        label2[len] = 0;
                }

                /* Next non-empty: delay slot of bra. */
                for (k = j + 1; k < sh_nlines; k++)
                        if (sh_lines[k][0] != 0) break;
                if (k >= sh_nlines
                    || !sh_is_delay_safe(sh_lines[k]))
                        continue;

                /* Next non-empty: must be `label1:`. */
                for (m = k + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines
                    || !sh_is_label_line(sh_lines[m]))
                        continue;
                {
                        char expected[64];
                        snprintf(expected, sizeof expected,
                                 "%s:\n", label1);
                        if (strcmp(sh_lines[m], expected) != 0)
                                continue;
                }

                /* Next non-empty: overwrite instruction. */
                for (n = m + 1; n < sh_nlines; n++)
                        if (sh_lines[n][0] != 0) break;
                if (n >= sh_nlines)
                        continue;

                /* Both delay insn and overwrite must write the
                 * same destination register. */
                {
                        const char *s1 = sh_lines[k];
                        const char *s2 = sh_lines[n];
                        const char *r1 = NULL, *r2 = NULL;
                        while (*s1) {
                                if (*s1 == 'r' && s1[1] >= '0'
                                    && s1[1] <= '9')
                                        r1 = s1;
                                s1++;
                        }
                        while (*s2) {
                                if (*s2 == 'r' && s2[1] >= '0'
                                    && s2[1] <= '9')
                                        r2 = s2;
                                s2++;
                        }
                        if (!r1 || !r2) continue;
                        r1++; r2++;
                        ds_dst = *r1 - '0';
                        if (r1[1] >= '0' && r1[1] <= '9')
                                ds_dst = ds_dst * 10 + (r1[1] - '0');
                        ow_dst = *r2 - '0';
                        if (r2[1] >= '0' && r2[1] <= '9')
                                ow_dst = ow_dst * 10 + (r2[1] - '0');
                        if (ds_dst != ow_dst) continue;
                }

                /* Transform: replace bt→bf/s or bf→bt/s,
                 * targeting label2 (the bra target). */
                snprintf(sh_lines[i], SH_MAX_LINELEN,
                         "\t%s\t%s\n",
                         is_bt ? "bf/s" : "bt/s", label2);
                /* Move delay insn into slot after the new bf/s.
                 * (It's already at position k, which is right
                 * after j. Blank the old bra line.) */
                sh_kill_line(j);
        }
}

/* Coalesce `mov rA,rB; <op> rX,rB; mov rB,rC` into
 * `mov rA,rC; <op> rX,rC` — eliminates the dead temporary rB.
 * Fires on the `return CONST + c` pattern where LCC routes
 * through an intermediate register instead of targeting the
 * return register directly. */
static void sh_coalesce_move_chains(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines; i++) {
                int rA, rB, rX, rY, rP, rQ;
                char buf[SH_MAX_LINELEN];
                char *dst;
                if (sh_lines[i][0] == 0) continue;
                if (!sh_parse_regmov(sh_lines[i], &rA, &rB))
                        continue;
                if (rA == rB) continue;
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_writes_reg(sh_lines[j], rB)) continue;
                if (sh_is_branch_line(sh_lines[j])) continue;
                if (sh_is_label_line(sh_lines[j])) continue;
                for (k = j + 1; k < sh_nlines; k++)
                        if (sh_lines[k][0] != 0) break;
                if (k >= sh_nlines) continue;
                if (!sh_parse_regmov(sh_lines[k], &rP, &rQ))
                        continue;
                if (rP != rB) continue;
                if (rQ == rB) continue;
                /* Pattern matched. Replace rB → rQ in lines i and j.
                 * Delete line k. */
                {
                        char old_reg[8], new_reg[8];
                        const char *in;
                        snprintf(old_reg, sizeof old_reg, "r%d", rB);
                        snprintf(new_reg, sizeof new_reg, "r%d", rQ);
                        /* Rewrite line i: mov rA,rB → mov rA,rQ */
                        in = sh_lines[i];
                        dst = buf;
                        while (*in) {
                                if (*in == 'r'
                                    && strncmp(in, old_reg,
                                               strlen(old_reg)) == 0
                                    && !(in[strlen(old_reg)] >= '0'
                                         && in[strlen(old_reg)] <= '9')
                                    && in > sh_lines[i]
                                    && in[-1] == ',') {
                                        int n = snprintf(dst,
                                                sizeof buf - (size_t)(dst - buf),
                                                "%s", new_reg);
                                        dst += n;
                                        in += strlen(old_reg);
                                } else {
                                        *dst++ = *in++;
                                }
                        }
                        *dst = 0;
                        strncpy(sh_lines[i], buf, SH_MAX_LINELEN - 1);
                        /* Rewrite line j: replace all rB with rQ */
                        in = sh_lines[j];
                        dst = buf;
                        while (*in) {
                                if (*in == 'r'
                                    && strncmp(in, old_reg,
                                               strlen(old_reg)) == 0
                                    && !(in[strlen(old_reg)] >= '0'
                                         && in[strlen(old_reg)] <= '9')) {
                                        int n = snprintf(dst,
                                                sizeof buf - (size_t)(dst - buf),
                                                "%s", new_reg);
                                        dst += n;
                                        in += strlen(old_reg);
                                } else {
                                        *dst++ = *in++;
                                }
                        }
                        *dst = 0;
                        strncpy(sh_lines[j], buf, SH_MAX_LINELEN - 1);
                        sh_kill_line(k);
                }
        }
}

/* Returns 1 if the body contains at least one bool_fp pattern
 * (any destination register, not specifically r14). Used by
 * sh_rewrite_bool_fp's r14-force-add gate. Mirrors the pattern
 * check in sh_rewrite_bool_fp's main loop, just non-destructively. */
static int sh_body_has_any_bool_fp_pattern(void) {
        int i, j, k, m, n;
        int rB, rP, rQ;
        for (i = 0; i < sh_nlines; i++) {
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "bf/s")
                    && !sh_has_prefix(sh_lines[i], "bt/s"))
                        continue;
                /* Find delay slot line. */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                /* Extract destination register from delay slot mov. */
                {
                        const char *r = NULL, *s = sh_lines[j];
                        while (*s) {
                                if (*s == 'r' && s[1] >= '0'
                                    && s[1] <= '9')
                                        r = s;
                                s++;
                        }
                        if (!r) continue;
                        r++;
                        rB = *r - '0';
                        if (r[1] >= '0' && r[1] <= '9')
                                rB = rB * 10 + (r[1] - '0');
                }
                /* Find overwrite line. */
                for (k = j + 1; k < sh_nlines; k++) {
                        if (sh_lines[k][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[k])) continue;
                        break;
                }
                if (k >= sh_nlines) continue;
                if (!sh_writes_reg(sh_lines[k], rB)) continue;
                /* Find label. */
                for (m = k + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) continue;
                if (!sh_is_label_line(sh_lines[m])) continue;
                /* Find mov rN, r0. */
                for (n = m + 1; n < sh_nlines; n++)
                        if (sh_lines[n][0] != 0) break;
                if (n >= sh_nlines) continue;
                if (!sh_parse_regmov(sh_lines[n], &rP, &rQ)) continue;
                if (rP != rB || rQ != 0) continue;
                return 1;
        }
        return 0;
}

/* Rewrite the boolean bf/s pattern to match Hitachi SHC's always-FP
 * idiom. Detects:
 *   bf/s L; mov #X,rN; mov #Y,rN; L: mov rN,r0; [exit]: rts; pop
 * Rewrites to:
 *   bf/s L_new; mov r15,r14; bra L_merge; mov #Y,r0; L_new:
 *   mov #X,r0; L_merge: mov r14,r15; rts; pop
 *
 * This adds FP setup/teardown (matching Hitachi's always-FP idiom)
 * and moves the boolean directly to r0. Only fires when the function
 * wouldn't otherwise need FP (need_fp == 0). */
static void sh_rewrite_bool_fp(int need_fp) {
        int i, j, k, m, n;
        int rA, rB, rX, rY, rP, rQ;
        char label_bfs[64], label_merge[64];
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int nout = 0;

        if (need_fp) return;
        /* Injects `mov r15,r14` / `mov r14,r15` which clobber r14,
         * so the prologue must save r14. Historically we bailed when
         * r14 wasn't in usedmask. That worked under high-first
         * allocation (r14 was usually a var) but breaks under
         * low-first (r14 rarely a var → injection skipped → prod
         * idiom not produced). Fix: if the body genuinely has the
         * bool_fp pattern, force-add r14 to usedmask so the prologue
         * saves it. The injection then proceeds safely. If no pattern
         * matches, skip the force-add (no waste). */
        if (!(usedmask[IREG] & (1u << 14))) {
                if (!sh_body_has_any_bool_fp_pattern()) return;
                usedmask[IREG] |= 1u << 14;
        }

        for (i = 0; i < sh_nlines; i++) {
                if (nout >= SH_MAX_LINES - 10) {
                        fprintf(stderr,
                                "sh_rewrite_bool_fp: "
                                "line buffer overflow "
                                "(%d/%d), output truncated\n",
                                nout, SH_MAX_LINES);
                        break;
                }
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "bf/s")
                    && !sh_has_prefix(sh_lines[i], "bt/s")) {
                        strncpy(new_lines[nout], sh_lines[i],
                                SH_MAX_LINELEN - 1);
                        new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                        nout++;
                        continue;
                }
                /* Found bf/s or bt/s. Check pattern:
                 * next: mov #X,rN (delay slot)
                 * next: mov #Y,rN (overwrite, same dest)
                 * next: Label:
                 * next: mov rN,r0 */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) goto copy_line;
                if (!sh_parse_regmov(sh_lines[j], &rA, &rB)) {
                        /* Check if it's a mov #imm,rN */
                        const char *p = sh_lines[j];
                        while (*p == ' ' || *p == '\t') p++;
                        if (!(p[0]=='m'&&p[1]=='o'&&p[2]=='v'
                              &&(p[3]==' '||p[3]=='\t')))
                                goto copy_line;
                        p += 3;
                        while (*p == ' ' || *p == '\t') p++;
                        if (*p != '#') goto copy_line;
                        /* Get dest register */
                        {
                                const char *r = NULL, *s = sh_lines[j];
                                while (*s) {
                                        if (*s == 'r' && s[1] >= '0'
                                            && s[1] <= '9')
                                                r = s;
                                        s++;
                                }
                                if (!r) goto copy_line;
                                r++;
                                rB = *r - '0';
                                if (r[1] >= '0' && r[1] <= '9')
                                        rB = rB * 10 + (r[1] - '0');
                        }
                }
                /* j = delay slot: mov #X,rN (rN = rB) */
                /* Skip any intermediate labels to find overwrite. */
                for (k = j + 1; k < sh_nlines; k++) {
                        if (sh_lines[k][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[k])) continue;
                        break;
                }
                if (k >= sh_nlines) goto copy_line;
                /* k = overwrite: mov #Y,rN (same rB) */
                if (!sh_writes_reg(sh_lines[k], rB)) goto copy_line;
                for (m = k + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) goto copy_line;
                /* m = label */
                if (!sh_is_label_line(sh_lines[m])) goto copy_line;
                {
                        const char *lp = sh_lines[m];
                        int len = 0;
                        while (*lp == ' ' || *lp == '\t') lp++;
                        while (lp[len] && lp[len] != ':'
                               && lp[len] != '\n') len++;
                        if (len <= 0 || len >= (int)sizeof label_bfs)
                                goto copy_line;
                        memcpy(label_bfs, lp, (size_t)len);
                        label_bfs[len] = 0;
                }
                for (n = m + 1; n < sh_nlines; n++)
                        if (sh_lines[n][0] != 0) break;
                if (n >= sh_nlines) goto copy_line;
                /* n = mov rN,r0 */
                if (!sh_parse_regmov(sh_lines[n], &rP, &rQ))
                        goto copy_line;
                if (rP != rB || rQ != 0) goto copy_line;

                /* Pattern matched! Rewrite. Generate a merge label. */
                snprintf(label_merge, sizeof label_merge,
                         "Lm%d", i);

                /* bf/s → bf/s <new_true_label> */
                {
                        const char *p = sh_lines[i];
                        char prefix[8];
                        while (*p == ' ' || *p == '\t') p++;
                        if (p[1] == 'f') strncpy(prefix, "bf/s", 5);
                        else strncpy(prefix, "bt/s", 5);
                        /* Keep the same branch — it goes to the
                         * TRUE case label (reuse original). */
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\t%s\t%s\n", prefix, label_bfs);
                }
                /* Delay slot: mov r15,r14 (FP setup) */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tmov\tr15,r14\n");
                /* bra merge; mov #Y,r0 (false in delay slot) */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tbra\t%s\n", label_merge);
                /* Replace rN with r0 in the overwrite line */
                {
                        char buf[SH_MAX_LINELEN];
                        char old_r[8], new_r[4];
                        const char *in;
                        char *out;
                        snprintf(old_r, sizeof old_r, "r%d", rB);
                        snprintf(new_r, sizeof new_r, "r0");
                        in = sh_lines[k];
                        out = buf;
                        while (*in) {
                                if (*in == 'r'
                                    && strncmp(in, old_r,
                                               strlen(old_r)) == 0
                                    && !(in[strlen(old_r)] >= '0'
                                         && in[strlen(old_r)] <= '9')) {
                                        int nn = snprintf(out,
                                                sizeof buf-(size_t)(out-buf),
                                                "%s", new_r);
                                        out += nn;
                                        in += strlen(old_r);
                                } else {
                                        *out++ = *in++;
                                }
                        }
                        *out = 0;
                        strncpy(new_lines[nout++], buf,
                                SH_MAX_LINELEN - 1);
                }
                /* Label: true case */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "%s:\n", label_bfs);
                /* mov #X,r0 (true value, replace rN with r0) */
                {
                        char buf[SH_MAX_LINELEN];
                        char old_r[8], new_r[4];
                        const char *in;
                        char *out;
                        snprintf(old_r, sizeof old_r, "r%d", rB);
                        snprintf(new_r, sizeof new_r, "r0");
                        in = sh_lines[j];
                        out = buf;
                        while (*in) {
                                if (*in == 'r'
                                    && strncmp(in, old_r,
                                               strlen(old_r)) == 0
                                    && !(in[strlen(old_r)] >= '0'
                                         && in[strlen(old_r)] <= '9')) {
                                        int nn = snprintf(out,
                                                sizeof buf-(size_t)(out-buf),
                                                "%s", new_r);
                                        out += nn;
                                        in += strlen(old_r);
                                } else {
                                        *out++ = *in++;
                                }
                        }
                        *out = 0;
                        strncpy(new_lines[nout++], buf,
                                SH_MAX_LINELEN - 1);
                }
                /* Merge label + FP teardown */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "%s:\n", label_merge);
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tmov\tr14,r15\n");
                /* Skip the original lines we consumed */
                i = n;
                continue;
copy_line:
                strncpy(new_lines[nout], sh_lines[i],
                        SH_MAX_LINELEN - 1);
                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                nout++;
                continue;
        }
        if (nout != sh_nlines) {
                for (i = 0; i < nout; i++)
                        strncpy(sh_lines[i], new_lines[i],
                                SH_MAX_LINELEN - 1);
                sh_nlines = nout;
        }
}

/* Remove byte extensions (extu.b/exts.b) when the value is only
 * used for arithmetic + byte store. The extension is dead because
 * mov.b only writes the low byte. Pattern:
 *   mov.b @rA,rB; ext.b rB,rB; add #imm,rB; mov.b rB,@rC */
static void sh_elim_dead_byte_ext(void) {
        int i, j, k, m;
        for (i = 0; i < sh_nlines; i++) {
                int rB;
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "extu.b")
                    && !sh_has_prefix(sh_lines[i], "exts.b"))
                        continue;
                /* Get the dest register (same as source for ext rN,rN) */
                {
                        const char *r = NULL, *s = sh_lines[i];
                        while (*s) {
                                if (*s == 'r' && s[1] >= '0' && s[1] <= '9')
                                        r = s;
                                s++;
                        }
                        if (!r) continue;
                        r++;
                        rB = *r - '0';
                        if (r[1] >= '0' && r[1] <= '9')
                                rB = rB * 10 + (r[1] - '0');
                }
                /* Check preceding line: must be mov.b @rX,rB */
                for (j = i - 1; j >= 0; j--)
                        if (sh_lines[j][0] != 0) break;
                if (j < 0) continue;
                if (!sh_has_prefix(sh_lines[j], "mov.b")) continue;
                if (!sh_writes_reg(sh_lines[j], rB)) continue;
                /* Check following lines: add #imm,rB then mov.b rB,@rX */
                for (k = i + 1; k < sh_nlines; k++)
                        if (sh_lines[k][0] != 0) break;
                if (k >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[k], "add")) continue;
                if (!sh_writes_reg(sh_lines[k], rB)) continue;
                for (m = k + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[m], "mov.b")) continue;
                if (!(sh_regs_used(sh_lines[m]) & (1u << rB))) continue;
                /* Pattern matched — extension is dead. */
                sh_kill_line(i);
        }
}

/* Delete `bt/bf Label` when Label is the immediately next non-empty
 * line. This is dead code from empty if-bodies like `if (x) {}`. */
static void sh_elim_dead_branches(void) {
        int i, j;
        for (i = 0; i < sh_nlines; i++) {
                char label[64], expected[68];
                const char *p;
                int len;
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "bt")
                    && !sh_has_prefix(sh_lines[i], "bf"))
                        continue;
                if (sh_has_prefix(sh_lines[i], "bt/s")
                    || sh_has_prefix(sh_lines[i], "bf/s"))
                        continue;
                p = sh_lines[i];
                while (*p == ' ' || *p == '\t') p++;
                p += 2;
                while (*p == ' ' || *p == '\t') p++;
                len = 0;
                while (p[len] && p[len] != '\n' && p[len] != ' '
                       && p[len] != '\t') len++;
                if (len <= 0 || len >= (int)sizeof label) continue;
                memcpy(label, p, (size_t)len);
                label[len] = 0;
                snprintf(expected, sizeof expected, "%s:\n", label);
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j < sh_nlines
                    && strcmp(sh_lines[j], expected) == 0)
                        sh_kill_line(i);
        }
}

/* After a jsr, if the call result is saved to a callee-saved reg
 * (mov r0,rN) and only used to return later (mov rN,r0), rename
 * to r4 (the freed first arg register). This avoids a callee-saved
 * push/pop and matches Hitachi SHC's pattern of reusing the arg
 * register for the result. */
static void sh_result_to_arg_reg(void) {
        int i, j;
        for (i = 0; i < sh_nlines; i++) {
                int rA, rB;
                int jsr_found = 0;
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "jsr")) continue;
                /* Skip delay slot. */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                j++;
                /* Look for `mov r0,rN` where rN is callee-saved. */
                for (; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_parse_regmov(sh_lines[j], &rA, &rB)) continue;
                if (rA != 0) continue;
                if (rB < 8 || rB > 14) continue;
                /* rB is the callee-saved result reg. Rename to r4
                 * throughout the rest of the body. */
                {
                        char old_r[8], new_r[4];
                        int k;
                        snprintf(old_r, sizeof old_r, "r%d", rB);
                        snprintf(new_r, sizeof new_r, "r4");
                        for (k = j; k < sh_nlines; k++) {
                                char buf[SH_MAX_LINELEN];
                                const char *in;
                                char *out;
                                if (sh_lines[k][0] == 0) continue;
                                if (!strstr(sh_lines[k], old_r)) continue;
                                in = sh_lines[k];
                                out = buf;
                                while (*in) {
                                        if (*in == 'r'
                                            && strncmp(in, old_r,
                                                       strlen(old_r)) == 0
                                            && !(in[strlen(old_r)] >= '0'
                                                 && in[strlen(old_r)] <= '9')) {
                                                int n = snprintf(out,
                                                        sizeof buf-(size_t)(out-buf),
                                                        "%s", new_r);
                                                out += n;
                                                in += strlen(old_r);
                                        } else {
                                                *out++ = *in++;
                                        }
                                }
                                *out = 0;
                                strncpy(sh_lines[k], buf,
                                        SH_MAX_LINELEN - 1);
                        }
                }
                break;
        }
}

/* In range-check pairs (cmp/ge rN,rM; bf; cmp/gt rN,rM; bt), if
 * both comparisons share the same scratch register for their
 * constants, rename the first comparison's register to a higher
 * scratch register. Hitachi SHC uses different registers for the
 * two constants in each range check (e.g., r3 for lower bound,
 * r1 for upper bound). This pass fixes the first constant's
 * register assignment by walking backward to its mov #imm and
 * renaming both the mov and the cmp instruction. The replacement
 * register cycles: first range gets r3, second gets r2. */
static void sh_diversify_range_regs(void) {
        int i, j, k;
        int range_count = 0;
        int replacement[] = {3, 2, 1};

        for (i = 0; i < sh_nlines; i++) {
                int ge_line, bf_line, gt_line;
                int ge_reg, gt_reg;
                char old_r[8], new_r[8];

                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "cmp/ge")) continue;
                ge_line = i;
                ge_reg = -1;
                {
                        unsigned regs = sh_regs_used(sh_lines[i]);
                        for (j = 3; j >= 1; j--)
                                if (regs & (1u << j)) { ge_reg = j; break; }
                }
                if (ge_reg < 0) continue;

                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "bf")) continue;
                bf_line = j;

                for (k = j + 1; k < sh_nlines; k++) {
                        if (sh_lines[k][0] == 0) continue;
                        if (sh_has_prefix(sh_lines[k], "cmp/gt")) break;
                        if (sh_has_prefix(sh_lines[k], "mov")) continue;
                        k = sh_nlines; break;
                }
                if (k >= sh_nlines) continue;
                gt_line = k;
                gt_reg = -1;
                {
                        unsigned regs = sh_regs_used(sh_lines[k]);
                        for (j = 3; j >= 1; j--)
                                if (regs & (1u << j)) { gt_reg = j; break; }
                }

                if (ge_reg != gt_reg) continue;
                if (range_count >= 3) continue;
                {
                        int new_reg = replacement[range_count];
                        if (new_reg == ge_reg) { range_count++; continue; }

                        snprintf(old_r, sizeof old_r, "r%d", ge_reg);
                        snprintf(new_r, sizeof new_r, "r%d", new_reg);

                        /* Rename in the cmp/ge line. */
                        {
                                char buf[SH_MAX_LINELEN];
                                const char *in = sh_lines[ge_line];
                                char *out = buf;
                                int replaced = 0;
                                while (*in) {
                                        if (!replaced && *in == 'r'
                                            && strncmp(in, old_r, strlen(old_r)) == 0
                                            && !(in[strlen(old_r)] >= '0' && in[strlen(old_r)] <= '9')) {
                                                int n = snprintf(out, sizeof buf-(size_t)(out-buf), "%s", new_r);
                                                out += n;
                                                in += strlen(old_r);
                                                replaced = 1;
                                        } else { *out++ = *in++; }
                                }
                                *out = 0;
                                strncpy(sh_lines[ge_line], buf, SH_MAX_LINELEN-1);
                        }
                        /* Rename in the mov #imm preceding cmp/ge. */
                        for (j = ge_line - 1; j >= 0; j--) {
                                if (sh_lines[j][0] == 0) continue;
                                if (sh_writes_reg(sh_lines[j], ge_reg)) {
                                        char buf[SH_MAX_LINELEN];
                                        const char *in = sh_lines[j];
                                        char *out = buf;
                                        while (*in) {
                                                if (*in == 'r'
                                                    && strncmp(in, old_r, strlen(old_r)) == 0
                                                    && !(in[strlen(old_r)] >= '0' && in[strlen(old_r)] <= '9')
                                                    && in > sh_lines[j] && in[-1] == ',') {
                                                        int n = snprintf(out, sizeof buf-(size_t)(out-buf), "%s", new_r);
                                                        out += n;
                                                        in += strlen(old_r);
                                                } else { *out++ = *in++; }
                                        }
                                        *out = 0;
                                        strncpy(sh_lines[j], buf, SH_MAX_LINELEN-1);
                                        break;
                                }
                                break;
                        }
                }
                range_count++;
        }
}

/* Restructure the post-call counter-increment pattern to match
 * Hitachi SHC's interleaved ordering and register reuse. Detects:
 *   mov r0,rR; tst rR,rR; mov.l Ln,rA; mov.b @rA,rB; add #N,rB; mov.b rB,@rA
 * Rewrites to:
 *   mov.l Ln,r5; mov r0,rR; mov.b @r5,r3; tst rR,rR; add #N,r3; mov.b r3,@r5
 * This reuses r5 (freed arg reg) and r3 (freed func ptr reg). */
static void sh_reorder_post_call_counter(void) {
        int i, j;
        for (i = 0; i < sh_nlines; i++) {
                int rR, rA, rB, save_line, tst_line, pool_line;
                int load_line, add_line, store_line;
                int rP, rQ;

                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "jsr")) continue;
                /* Skip delay slot. */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                j++;
                /* Find: mov r0,rR */
                for (; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_parse_regmov(sh_lines[j], &rP, &rQ)) continue;
                if (rP != 0) continue;
                save_line = j; rR = rQ;
                /* Find: tst rR,rR */
                for (j++; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "tst")) continue;
                tst_line = j;
                /* Skip labels between tst and counter */
                for (j++; j < sh_nlines; j++) {
                        if (sh_lines[j][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[j])) continue;
                        break;
                }
                if (j >= sh_nlines) continue;
                /* Find: mov.l Ln,rA */
                if (!sh_has_prefix(sh_lines[j], "mov.l")) continue;
                if (!sh_is_pc_rel_load(sh_lines[j])) continue;
                pool_line = j;
                rA = -1;
                { const char *r=NULL, *s=sh_lines[j]; while(*s){if(*s=='r'&&s[1]>='0'&&s[1]<='9')r=s;s++;}
                  if(r){r++;rA=*r-'0';if(r[1]>='0'&&r[1]<='9')rA=rA*10+(r[1]-'0');} }
                if (rA < 0) continue;
                /* Find: mov.b @rA,rB */
                for (j++; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "mov.b")) continue;
                load_line = j;
                rB = -1;
                { const char *r=NULL, *s=sh_lines[j]; while(*s){if(*s=='r'&&s[1]>='0'&&s[1]<='9')r=s;s++;}
                  if(r){r++;rB=*r-'0';if(r[1]>='0'&&r[1]<='9')rB=rB*10+(r[1]-'0');} }
                if (rB < 0) continue;
                /* Find: add #N,rB */
                for (j++; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "add")) continue;
                add_line = j;
                /* Find: mov.b rB,@rA */
                for (j++; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "mov.b")) continue;
                store_line = j;

                /* Pattern matched. Rewrite: reorder + rename rA→r5, rB→r3 */
                {
                        char new_pool[SH_MAX_LINELEN];
                        char new_save[SH_MAX_LINELEN];
                        char new_load[SH_MAX_LINELEN];
                        char new_tst[SH_MAX_LINELEN];
                        char new_add[SH_MAX_LINELEN];
                        char new_store[SH_MAX_LINELEN];
                        char old_a[8], old_b[8];

                        snprintf(old_a, sizeof old_a, "r%d", rA);
                        snprintf(old_b, sizeof old_b, "r%d", rB);

                        /* Pool load: rename rA→r5 */
                        { const char *in=sh_lines[pool_line]; char *out=new_pool;
                          while(*in){if(*in=='r'&&strncmp(in,old_a,strlen(old_a))==0&&!(in[strlen(old_a)]>='0'&&in[strlen(old_a)]<='9')&&in>sh_lines[pool_line]&&in[-1]==','){int n=snprintf(out,SH_MAX_LINELEN-(out-new_pool),"r5");out+=n;in+=strlen(old_a);}else{*out++=*in++;}}*out=0; }
                        /* Byte load: rename rA→r5, rB→r3 */
                        { const char *in=sh_lines[load_line]; char *out=new_load;
                          while(*in){if(*in=='r'&&strncmp(in,old_a,strlen(old_a))==0&&!(in[strlen(old_a)]>='0'&&in[strlen(old_a)]<='9')){int n=snprintf(out,SH_MAX_LINELEN-(out-new_load),"r5");out+=n;in+=strlen(old_a);}else if(*in=='r'&&strncmp(in,old_b,strlen(old_b))==0&&!(in[strlen(old_b)]>='0'&&in[strlen(old_b)]<='9')){int n=snprintf(out,SH_MAX_LINELEN-(out-new_load),"r3");out+=n;in+=strlen(old_b);}else{*out++=*in++;}}*out=0; }
                        /* Add: rename rB→r3 */
                        { const char *in=sh_lines[add_line]; char *out=new_add;
                          while(*in){if(*in=='r'&&strncmp(in,old_b,strlen(old_b))==0&&!(in[strlen(old_b)]>='0'&&in[strlen(old_b)]<='9')){int n=snprintf(out,SH_MAX_LINELEN-(out-new_add),"r3");out+=n;in+=strlen(old_b);}else{*out++=*in++;}}*out=0; }
                        /* Store: rename rA→r5, rB→r3 */
                        { const char *in=sh_lines[store_line]; char *out=new_store;
                          while(*in){if(*in=='r'&&strncmp(in,old_a,strlen(old_a))==0&&!(in[strlen(old_a)]>='0'&&in[strlen(old_a)]<='9')){int n=snprintf(out,SH_MAX_LINELEN-(out-new_store),"r5");out+=n;in+=strlen(old_a);}else if(*in=='r'&&strncmp(in,old_b,strlen(old_b))==0&&!(in[strlen(old_b)]>='0'&&in[strlen(old_b)]<='9')){int n=snprintf(out,SH_MAX_LINELEN-(out-new_store),"r3");out+=n;in+=strlen(old_b);}else{*out++=*in++;}}*out=0; }

                        strncpy(new_save, sh_lines[save_line], SH_MAX_LINELEN-1);
                        strncpy(new_tst, sh_lines[tst_line], SH_MAX_LINELEN-1);

                        /* Write reordered: pool, save, load, tst, add, store */
                        strncpy(sh_lines[save_line], new_pool, SH_MAX_LINELEN-1);
                        strncpy(sh_lines[tst_line], new_save, SH_MAX_LINELEN-1);
                        strncpy(sh_lines[pool_line], new_load, SH_MAX_LINELEN-1);
                        strncpy(sh_lines[load_line], new_tst, SH_MAX_LINELEN-1);
                        strncpy(sh_lines[add_line], new_add, SH_MAX_LINELEN-1);
                        strncpy(sh_lines[store_line], new_store, SH_MAX_LINELEN-1);
                }
                break;
        }
}

/* Reorder pre-call argument loads to match Hitachi SHC's right-to-
 * left evaluation. Scans backward from each `jsr` to find pool
 * loads to arg registers (r4-r7) and the function pointer, then
 * sorts them in descending register order with any dereferences
 * (mov.w @rN,rN) placed after all pool loads. */
static void sh_reorder_pre_call_args(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines; i++) {
                int jsr_line, first_arg_line;
                struct { int line; int reg; int is_deref; } loads[16];
                int nloads = 0;

                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "jsr")) continue;
                jsr_line = i;

                /* Scan backward to collect pool loads and derefs. */
                for (j = i - 1; j >= 0 && nloads < 16; j--) {
                        if (sh_lines[j][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[j])) break;
                        if (sh_is_branch_line(sh_lines[j])) break;
                        if (sh_has_prefix(sh_lines[j], "sts.l")) break;
                        if (sh_has_prefix(sh_lines[j], "mov.l")
                            || sh_has_prefix(sh_lines[j], "mov.w")) {
                                int dst = -1;
                                const char *r = NULL, *s = sh_lines[j];
                                while (*s) {
                                        if (*s == 'r' && s[1] >= '0'
                                            && s[1] <= '9')
                                                r = s;
                                        s++;
                                }
                                if (r) {
                                        r++;
                                        dst = *r - '0';
                                        if (r[1] >= '0' && r[1] <= '9')
                                                dst = dst*10 + (r[1]-'0');
                                }
                                loads[nloads].line = j;
                                loads[nloads].reg = dst;
                                loads[nloads].is_deref =
                                        (strstr(sh_lines[j], "@r") != NULL
                                         && !sh_is_pc_rel_load(sh_lines[j]));
                                nloads++;
                        } else if (sh_has_prefix(sh_lines[j], "extu.w")
                                   || sh_has_prefix(sh_lines[j], "extu.b")) {
                                /* Extension — treat as deref. */
                                loads[nloads].line = j;
                                loads[nloads].reg = -1;
                                loads[nloads].is_deref = 1;
                                nloads++;
                        } else {
                                break;
                        }
                }

                if (nloads < 3) continue;
                first_arg_line = loads[nloads - 1].line;

                /* Sort: pool loads (non-deref) by descending register,
                 * then derefs at the end. Simple insertion sort. */
                {
                        char sorted[16][SH_MAX_LINELEN];
                        int ns = 0, m;
                        /* First: non-deref pool loads, highest reg first */
                        for (k = 7; k >= 0; k--) {
                                for (m = nloads - 1; m >= 0; m--) {
                                        if (!loads[m].is_deref
                                            && loads[m].reg == k) {
                                                strncpy(sorted[ns++],
                                                        sh_lines[loads[m].line],
                                                        SH_MAX_LINELEN - 1);
                                        }
                                }
                        }
                        /* Then: derefs in original order */
                        for (m = nloads - 1; m >= 0; m--) {
                                if (loads[m].is_deref) {
                                        strncpy(sorted[ns++],
                                                sh_lines[loads[m].line],
                                                SH_MAX_LINELEN - 1);
                                }
                        }
                        /* Write back */
                        for (m = 0; m < ns; m++) {
                                strncpy(sh_lines[first_arg_line + m],
                                        sorted[m], SH_MAX_LINELEN - 1);
                        }
                }
        }
}

/* Swap `extu.b rA,rB; mov #imm,rC` to `mov #imm,rC; extu.b rA,rB`
 * when the two instructions are independent (no register overlap).
 * Matches Hitachi SHC's evaluation order where comparison constants
 * are loaded before the byte extraction. */
static void sh_reorder_extu_mov(void) {
        int i, j;
        for (i = 0; i < sh_nlines - 1; i++) {
                unsigned regs_a, regs_b;
                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "extu.b")) continue;
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[j], "mov")) continue;
                if (sh_has_prefix(sh_lines[j], "mov.")) continue;
                regs_a = sh_regs_used(sh_lines[i]);
                regs_b = sh_regs_used(sh_lines[j]);
                if (regs_a & regs_b) continue;
                {
                        char tmp[SH_MAX_LINELEN];
                        strncpy(tmp, sh_lines[i], SH_MAX_LINELEN - 1);
                        tmp[SH_MAX_LINELEN - 1] = 0;
                        strncpy(sh_lines[i], sh_lines[j],
                                SH_MAX_LINELEN - 1);
                        strncpy(sh_lines[j], tmp, SH_MAX_LINELEN - 1);
                }
        }
}

/* Restructure cmp/eq chains from interleaved test-return blocks
 * into a dispatch table followed by gathered return blocks.
 *
 * Before: cmp/eq #X,r0; bf Lskip; mov #V,r0; rts; pop; Lskip: ...
 * After:  cmp/eq #X,r0; bt Lret; ... bra Ldefault; nop;
 *         Lret: mov #V,r0; rts; pop; ...
 *
 * This matches Hitachi SHC's switch-like dispatch pattern. */
static void sh_restructure_eq_chain(void) {
        int i, j, n;
        
        /* Detect: block starting with `cmp/eq #imm,r0; bf Label`
         * followed by `mov #val,r0; rts; pop; Label:` repeated. */
        struct eq_block {
                int cmp_line;
                int bf_line;
                int mov_line;
                int rts_line;
                int pop_line;
                int label_line;
                char label[64];
                int is_last_bt;
        };
        struct eq_block blocks[16];
        int nblocks = 0;
        int chain_start = -1;
        int estab_line = -1;

        for (i = 0; i < sh_nlines; i++) {
                int rA, rB;
                if (sh_lines[i][0] == 0) continue;
                if (sh_parse_regmov(sh_lines[i], &rA, &rB)
                    && rB == 0 && rA != 0) {
                        /* Potential establishment: mov rA,r0 */
                        for (j = i + 1; j < sh_nlines; j++)
                                if (sh_lines[j][0] != 0) break;
                        if (j < sh_nlines
                            && sh_has_prefix(sh_lines[j], "cmp/eq")) {
                                estab_line = i;
                                chain_start = j;
                                break;
                        }
                }
        }
        if (chain_start < 0) return;

        /* Collect blocks. Skip `mov rA,r0` re-establishments
         * between blocks (the redundant-mov pass removes them
         * later, but hasn't run yet). */
        i = chain_start;
        while (i < sh_nlines && nblocks < 16) {
                struct eq_block *b = &blocks[nblocks];
                int m;
                if (sh_lines[i][0] == 0) { i++; continue; }
                if (sh_is_label_line(sh_lines[i])) { i++; continue; }
                {
                        int rA, rB;
                        if (sh_parse_regmov(sh_lines[i], &rA, &rB)
                            && rB == 0) { i++; continue; }
                }
                if (!sh_has_prefix(sh_lines[i], "cmp/eq")) break;
                b->cmp_line = i;
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) break;
                b->is_last_bt = sh_has_prefix(sh_lines[j], "bt");
                if (!sh_has_prefix(sh_lines[j], "bf")
                    && !sh_has_prefix(sh_lines[j], "bt"))
                        break;
                b->bf_line = j;
                for (m = j + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) break;
                if (!sh_has_prefix(sh_lines[m], "mov")) break;
                b->mov_line = m;
                for (m = m + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) break;
                if (!sh_has_prefix(sh_lines[m], "rts")) break;
                b->rts_line = m;
                for (m = m + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) break;
                b->pop_line = m;
                for (m = m + 1; m < sh_nlines; m++)
                        if (sh_lines[m][0] != 0) break;
                if (m >= sh_nlines) break;
                if (!sh_is_label_line(sh_lines[m])) break;
                b->label_line = m;
                {
                        const char *lp = sh_lines[m];
                        int len = 0;
                        while (*lp == ' ' || *lp == '\t') lp++;
                        while (lp[len] && lp[len] != ':'
                               && lp[len] != '\n') len++;
                        if (len <= 0 || len >= (int)sizeof b->label)
                                break;
                        memcpy(b->label, lp, (size_t)len);
                        b->label[len] = 0;
                }
                nblocks++;
                i = m + 1;
        }

        if (nblocks < 2) return;

        /* Build new body section. First: dispatch table. */
        {
                static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
                int nout = 0;
                int chain_end;
                int default_mov = -1, default_rts = -1, default_pop = -1;

                /* Copy everything before the chain. */
                for (j = 0; j <= estab_line; j++) {
                        if (nout >= SH_MAX_LINES - 64) {
                                fprintf(stderr,
                                        "sh_restructure_eq_chain: "
                                        "line buffer overflow "
                                        "(%d/%d), output truncated\n",
                                        nout, SH_MAX_LINES);
                                break;
                        }
                        strncpy(new_lines[nout], sh_lines[j],
                                SH_MAX_LINELEN - 1);
                        new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                        nout++;
                }

                /* Emit dispatch: cmp/eq lines with bt to return labels.
                 * Reuse the existing labels as return block labels. */
                for (n = 0; n < nblocks; n++) {
                        strncpy(new_lines[nout], sh_lines[blocks[n].cmp_line],
                                SH_MAX_LINELEN - 1);
                        new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                        nout++;
                        snprintf(new_lines[nout], SH_MAX_LINELEN,
                                 "\tbt\t%s\n", blocks[n].label);
                        nout++;
                }

                /* Default: bra + nop to the label after the last block.
                 * The last block's label_line + 1 might have the default
                 * code or the exit label. */
                chain_end = blocks[nblocks - 1].label_line;

                /* Find default block: lines after the last chain label
                 * that aren't the exit label. */
                for (j = chain_end + 1; j < sh_nlines; j++) {
                        if (sh_lines[j][0] == 0) continue;
                        if (sh_is_label_line(sh_lines[j])) break;
                        if (default_mov < 0
                            && sh_has_prefix(sh_lines[j], "mov"))
                                default_mov = j;
                        else if (sh_has_prefix(sh_lines[j], "rts"))
                                default_rts = j;
                        else
                                default_pop = j;
                }

                {
                        char def_label[64];
                        struct eq_block *last = &blocks[nblocks - 1];
                        snprintf(def_label, sizeof def_label,
                                 "Ld%d", blocks[0].cmp_line);
                        snprintf(new_lines[nout], SH_MAX_LINELEN,
                                 "\tbra\t%s\n", def_label);
                        nout++;
                        snprintf(new_lines[nout], SH_MAX_LINELEN,
                                 "\tnop\n");
                        nout++;

                        /* Emit return blocks. For `bf` blocks, the
                         * body (mov/rts/pop) IS the match return. For
                         * the last `bt` block, the body is the DEFAULT
                         * and the match value is at the label.
                         *
                         * Hitachi SHC emits the first two return blocks
                         * in swapped order (second test's block first).
                         * Emit in order: 1, 0, 2, 3, ... to match. */
                        {
                                int order[16];
                                int m;
                                if (nblocks >= 2) {
                                        order[0] = 1;
                                        order[1] = 0;
                                        for (m = 2; m < nblocks; m++)
                                                order[m] = m;
                                } else {
                                        for (m = 0; m < nblocks; m++)
                                                order[m] = m;
                                }
                        for (n = 0; n < nblocks; n++) {
                                int idx = order[n];
                                snprintf(new_lines[nout], SH_MAX_LINELEN,
                                         "%s:\n", blocks[idx].label);
                                nout++;
                                if (blocks[idx].is_last_bt) {
                                        if (default_mov >= 0) {
                                                strncpy(new_lines[nout],
                                                        sh_lines[default_mov],
                                                        SH_MAX_LINELEN - 1);
                                                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                                nout++;
                                        }
                                } else {
                                        strncpy(new_lines[nout],
                                                sh_lines[blocks[idx].mov_line],
                                                SH_MAX_LINELEN - 1);
                                        new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                        nout++;
                                }
                                snprintf(new_lines[nout], SH_MAX_LINELEN,
                                         "\trts\n");
                                nout++;
                                /* Copy the block's captured delay/pop line
                                 * rather than hardcoding a r14 pop — the
                                 * leaf-rename pass may have turned it into
                                 * a nop (no save to restore). */
                                strncpy(new_lines[nout],
                                        sh_lines[blocks[idx].pop_line],
                                        SH_MAX_LINELEN - 1);
                                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                nout++;
                        }
                        } /* end order[] scope */

                        /* Default block: for the `bt` block, its body
                         * (mov/rts/pop) is the default. Otherwise use
                         * what was found after the chain. */
                        snprintf(new_lines[nout], SH_MAX_LINELEN,
                                 "%s:\n", def_label);
                        nout++;
                        if (last->is_last_bt) {
                                strncpy(new_lines[nout],
                                        sh_lines[last->mov_line],
                                        SH_MAX_LINELEN - 1);
                                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                nout++;
                        } else if (default_mov >= 0) {
                                strncpy(new_lines[nout],
                                        sh_lines[default_mov],
                                        SH_MAX_LINELEN - 1);
                                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                nout++;
                        }
                        snprintf(new_lines[nout], SH_MAX_LINELEN,
                                 "\trts\n");
                        nout++;
                        {
                                int src = last->is_last_bt
                                        ? last->pop_line
                                        : (default_pop >= 0
                                           ? default_pop
                                           : last->pop_line);
                                strncpy(new_lines[nout],
                                        sh_lines[src],
                                        SH_MAX_LINELEN - 1);
                                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                                nout++;
                        }
                }

                /* The restructured chain handles all returns; the
                 * original exit label and fall-through epilogue are
                 * dead code. Don't copy them. */
                sh_all_returns_inlined = 1;

                /* Copy back. */
                for (j = 0; j < nout; j++)
                        strncpy(sh_lines[j], new_lines[j],
                                SH_MAX_LINELEN - 1);
                sh_nlines = nout;
        }
}

/* Collapse `<pool_load> rA; mov rB,rC; add rA,rC` into
 * `<pool_load> rC; add rB,rC`. Swaps the pool load destination
 * into the result register and uses the other operand directly
 * in the add, saving one instruction. Only fires when the pool
 * load is a mov.w or mov.l with a label (PC-relative). */
static void sh_swap_pool_add(void) {
        int i, j, k;
        for (i = 0; i < sh_nlines; i++) {
                int rA_load, rB, rC, rA_add, rX;
                char *p;
                char old_reg[8], new_reg[8];

                if (sh_lines[i][0] == 0) continue;
                if (!sh_has_prefix(sh_lines[i], "mov.w")
                    && !sh_has_prefix(sh_lines[i], "mov.l"))
                        continue;
                p = sh_lines[i];
                while (*p == ' ' || *p == '\t') p++;
                p += 5;
                while (*p == ' ' || *p == '\t') p++;
                if (*p != 'L') continue;
                /* This is a pool load. Find dest register. */
                {
                        const char *r = NULL, *s = sh_lines[i];
                        while (*s) {
                                if (*s == 'r' && s[1] >= '0' && s[1] <= '9')
                                        r = s;
                                s++;
                        }
                        if (!r) continue;
                        r++;
                        rA_load = *r - '0';
                        if (r[1] >= '0' && r[1] <= '9')
                                rA_load = rA_load * 10 + (r[1] - '0');
                }

                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j >= sh_nlines) continue;
                if (!sh_parse_regmov(sh_lines[j], &rB, &rC))
                        continue;
                if (rC == rA_load) continue;

                for (k = j + 1; k < sh_nlines; k++)
                        if (sh_lines[k][0] != 0) break;
                if (k >= sh_nlines) continue;
                if (!sh_has_prefix(sh_lines[k], "add")) continue;
                if (!sh_writes_reg(sh_lines[k], rC)) continue;
                {
                        unsigned regs = sh_regs_used(sh_lines[k]);
                        if (!(regs & (1u << rA_load))) continue;
                }

                /* Check for trailing `mov rC,rD` — if present,
                 * target rD instead and delete the mov. */
                {
                        int m, rP, rQ;
                        for (m = k + 1; m < sh_nlines; m++)
                                if (sh_lines[m][0] != 0) break;
                        if (m < sh_nlines
                            && sh_parse_regmov(sh_lines[m], &rP, &rQ)
                            && rP == rC && rQ != rC) {
                                rC = rQ;
                                sh_kill_line(m);
                        }
                }

                /* Pattern matched. Rewrite pool load dest rA → rC,
                 * replace mov+add with just add rB,rC. */
                snprintf(old_reg, sizeof old_reg, "r%d", rA_load);
                snprintf(new_reg, sizeof new_reg, "r%d", rC);
                {
                        char buf[SH_MAX_LINELEN];
                        const char *in = sh_lines[i];
                        char *out = buf;
                        int replaced = 0;
                        while (*in) {
                                if (!replaced && *in == 'r'
                                    && strncmp(in, old_reg,
                                               strlen(old_reg)) == 0
                                    && !(in[strlen(old_reg)] >= '0'
                                         && in[strlen(old_reg)] <= '9')
                                    && in > sh_lines[i]
                                    && in[-1] == ',') {
                                        int n = snprintf(out,
                                                sizeof buf - (size_t)(out - buf),
                                                "%s", new_reg);
                                        out += n;
                                        in += strlen(old_reg);
                                        replaced = 1;
                                } else {
                                        *out++ = *in++;
                                }
                        }
                        *out = 0;
                        strncpy(sh_lines[i], buf, SH_MAX_LINELEN - 1);
                }
                snprintf(sh_lines[j], SH_MAX_LINELEN,
                         "\tadd\tr%d,r%d\n", rB, rC);
                sh_kill_line(k);
        }
}

/* Eliminate redundant `mov rA,r0` in cmp/eq #imm chains. When
 * multiple equality comparisons test the same variable against
 * different constants, each emits `mov rA,r0; cmp/eq #imm,r0`.
 * On the fall-through path (bf not taken), r0 still holds rA from
 * the first mov — subsequent movs are dead. The taken-match path
 * terminates via rts and doesn't reach the next comparison.
 *
 * Linear scan: track which register r0 mirrors. When we see a
 * `mov rA,r0` and r0 already holds rA, delete it. Instructions
 * that write r0 on a path ending in rts don't invalidate r0 for
 * the fall-through. */
static void sh_elim_redundant_mov_r0(void) {
        int i, j;
        int r0_src = -1;
        int r0_estab = -1;

        for (i = 0; i < sh_nlines; i++) {
                int rA, rB;
                if (sh_lines[i][0] == 0)
                        continue;
                if (sh_is_label_line(sh_lines[i])) {
                        if (r0_src >= 0) {
                                /* Check if any branch to this label
                                 * comes from before the establishment
                                 * point. If so, r0 is stale. */
                                char lname[64];
                                char search[68];
                                const char *lp = sh_lines[i];
                                int len = 0, safe = 1;
                                while (*lp == ' ' || *lp == '\t') lp++;
                                while (lp[len] && lp[len] != ':'
                                       && lp[len] != '\n') len++;
                                if (len > 0
                                    && len < (int)sizeof lname) {
                                        memcpy(lname, lp, (size_t)len);
                                        lname[len] = 0;
                                        snprintf(search, sizeof search,
                                                 "%s\n", lname);
                                        for (j = 0; j < sh_nlines; j++) {
                                                if (sh_lines[j][0] == 0)
                                                        continue;
                                                if (j == i) continue;
                                                if (!sh_is_branch_line(
                                                        sh_lines[j])
                                                    && !sh_has_prefix(
                                                        sh_lines[j], "bt")
                                                    && !sh_has_prefix(
                                                        sh_lines[j], "bf"))
                                                        continue;
                                                if (!strstr(sh_lines[j],
                                                            search))
                                                        continue;
                                                if (j < r0_estab) {
                                                        safe = 0;
                                                        break;
                                                }
                                        }
                                } else {
                                        safe = 0;
                                }
                                if (!safe)
                                        r0_src = -1;
                        }
                        continue;
                }
                if (sh_has_prefix(sh_lines[i], "cmp")
                    || sh_has_prefix(sh_lines[i], "tst"))
                        continue;
                if (sh_has_prefix(sh_lines[i], "bt")
                    || sh_has_prefix(sh_lines[i], "bf"))
                        continue;
                if (sh_has_prefix(sh_lines[i], "rts")) {
                        for (j = i + 1; j < sh_nlines; j++)
                                if (sh_lines[j][0] != 0) break;
                        if (j < sh_nlines) i = j;
                        continue;
                }
                if (!sh_parse_regmov(sh_lines[i], &rA, &rB)) {
                        /* If this insn writes the register r0
                         * is mirroring, the mirror is stale. */
                        if (r0_src >= 0
                            && sh_writes_reg(sh_lines[i], r0_src))
                                r0_src = -1;
                        if (sh_writes_reg(sh_lines[i], 0)) {
                                int k, terminates = 0;
                                for (k = i + 1; k < sh_nlines; k++) {
                                        if (sh_lines[k][0] == 0)
                                                continue;
                                        if (sh_has_prefix(sh_lines[k], "rts")) {
                                                terminates = 1;
                                                break;
                                        }
                                        if (sh_is_label_line(sh_lines[k])
                                            || sh_is_branch_line(sh_lines[k]))
                                                break;
                                }
                                if (!terminates)
                                        r0_src = -1;
                        }
                        continue;
                }
                if (rB != 0) {
                        if (rB == r0_src)
                                r0_src = -1;
                        continue;
                }
                if (rA == r0_src) {
                        sh_kill_line(i);
                } else {
                        r0_src = rA;
                        r0_estab = i;
                }
        }
}

/* Rename every non-FP use of r14 in the captured body to r<new_reg>.
 * An r14 token is considered an FP-indirect use iff it appears inside
 * `@(disp,r14)` — i.e., preceded by `,` and followed by `)`. Every
 * other occurrence (bare `r14`, `@r14`, `mov rX,r14`, etc.) is a
 * variable-home use left behind by ralloc and must move to new_reg.
 *
 * This runs only when the allocator picked r14 as a var home AND the
 * function also turns out to need FP. See function() for the call
 * site and the surrounding conflict-detection logic. */
/* Rewrite every standalone `r<old>` token in the captured body to
 * `r<new>`. Preserves `,r14)` frame-pointer indexed references when
 * old==14, since those carry FP semantics that must not be renamed.
 * Non-r14 renames have no such exception — `,rN)` for N != 14 is an
 * indexed addressing operand and is a legitimate rename target. */
static void sh_rename_reg(int old_reg, int new_reg) {
        char buf[SH_MAX_LINELEN];
        char old_digits[4];
        int old_len;
        int j;
        old_len = snprintf(old_digits, sizeof old_digits, "%d", old_reg);
        for (j = 0; j < sh_nlines; j++) {
                const char *in = sh_lines[j];
                char *out = buf;
                if (in[0] == 0)
                        continue;
                while (*in) {
                        if (*in == 'r'
                            && strncmp(in + 1, old_digits,
                                       (size_t)old_len) == 0
                            && !(in[1 + old_len] >= '0'
                                 && in[1 + old_len] <= '9')) {
                                int is_fp_indexed =
                                        (old_reg == 14
                                         && in > sh_lines[j]
                                         && in[-1] == ','
                                         && in[1 + old_len] == ')');
                                if (is_fp_indexed) {
                                        int k;
                                        for (k = 0; k <= old_len; k++)
                                                *out++ = *in++;
                                } else {
                                        int n = snprintf(out,
                                                sizeof buf - (size_t)(out - buf),
                                                "r%d", new_reg);
                                        out += n;
                                        in += 1 + old_len;
                                }
                        } else {
                                *out++ = *in++;
                        }
                }
                *out = 0;
                strncpy(sh_lines[j], buf, SH_MAX_LINELEN - 1);
                sh_lines[j][SH_MAX_LINELEN - 1] = 0;
        }
}

static void sh_rename_r14_var(int new_reg) {
        sh_rename_reg(14, new_reg);
}

/* Leaf-function callee-saved elision (Gap 1, Phase A).
 *
 * SHC's leaf functions with a single return point avoid callee-saved
 * registers entirely — FUN_06047748's base pointer lives in r7, not
 * r14. But leaf functions with MULTIPLE returns keep r14 (or another
 * callee-saved) because the pop fills each rts delay slot usefully
 * (FUN_06004378 has 6 rts sites). Renaming away the callee-saved
 * there trades 1 saved push for N wasted nops.
 *
 * Our allocator defaults to r14..r8 for variable homes (INTVAR =
 * 0x7f00) because LCC's gen.c assumes vmask and tmask are disjoint.
 * Widening vmask to include INTTMP breaks the allocator's invariants
 * (spillee assertion, CSE tracking corruption — confirmed
 * experimentally).
 *
 * Instead, do the rename as a post-allocation pass on the captured
 * body: for each callee-saved reg LCC picked, rewrite it to a
 * caller-saved reg that is genuinely unreferenced anywhere in the
 * body. The usedmask rebuild at the end of function() picks up the
 * renamed regs as INTTMP (stripped by &INTVAR) and drops the
 * prologue save.
 *
 * Gate: only fire when the body has at most one `bra <exit>` site
 * (which inline_returns will turn into an rts). With multiple
 * returns, the pops-as-delay-slot trick wins on code size and
 * matches prod.
 *
 * Rename-target priority: r7, r6, r5, r4 first (argregs that the
 * function doesn't consume), then r0. We do NOT target r1/r2/r3 —
 * they're INTTMP temps and are almost always live somewhere in the
 * body. */
static int sh_count_exit_bras(int exit_label_num) {
        char pat[32];
        int count = 0;
        int j;
        snprintf(pat, sizeof pat, "\tbra\tL%d\n", exit_label_num);
        for (j = 0; j < sh_nlines; j++) {
                if (sh_lines[j][0] == 0)
                        continue;
                if (strcmp(sh_lines[j], pat) == 0)
                        count++;
        }
        return count;
}

/* Return 1 if sh_rewrite_bool_fp would have a r14-using injection
 * site here: a bf/s or bt/s whose delay-slot `mov #X,rN` writes r14.
 * In that case renaming r14 breaks bool_fp's ability to produce the
 * prod-matching FP-ceremony sequence, so we leave r14 alone. */
/* Recognise bool_fp's pattern pre- or post-fold: the function picks
 * between two small constants via a branch and moves the result to
 * r0. Signature: at least two `mov #imm,r14` lines AND a `mov r14,r0`
 * line. sh_rewrite_bool_fp will fire on this shape after
 * sh_fold_conditional_delays runs — we pre-empt by leaving r14
 * intact so the FP ceremony can be generated. */
static int sh_body_has_bool_fp_r14_pattern(void) {
        int i;
        int const_moves_to_r14 = 0;
        int r14_to_r0 = 0;
        for (i = 0; i < sh_nlines; i++) {
                const char *p = sh_lines[i];
                if (p[0] == 0) continue;
                while (*p == ' ' || *p == '\t') p++;
                if (p[0] == 'm' && p[1] == 'o' && p[2] == 'v'
                    && (p[3] == ' ' || p[3] == '\t')) {
                        const char *q = p + 4;
                        while (*q == ' ' || *q == '\t') q++;
                        if (*q == '#' && sh_writes_reg(sh_lines[i], 14))
                                const_moves_to_r14++;
                        else if (*q == 'r' && q[1] == '1' && q[2] == '4'
                                 && q[3] == ','
                                 && sh_writes_reg(sh_lines[i], 0))
                                r14_to_r0 = 1;
                }
        }
        return const_moves_to_r14 >= 2 && r14_to_r0;
}

static void sh_leaf_rename_callee_saved(int need_fp, int exit_label_num) {
        static const int rename_prio[] = { 7, 6, 5, 4, 0 };
        unsigned live = 0;
        int j, src;
        int nexits;
        int has_boolfp_r14;
        int ncallee_saved;

        nexits = sh_count_exit_bras(exit_label_num);
        if (nexits > 1)
                return;
        /* Prod uses callee-saved regs (r14..r9) as variable homes
         * when pressure is high — matching HEAD's allocator choices.
         * Only rename when a single callee-saved is in use; multi-
         * reg functions match prod better if we leave allocation
         * alone. */
        ncallee_saved = bitcount(usedmask[IREG] & INTVAR);
        if (ncallee_saved > 1)
                return;
        has_boolfp_r14 = sh_body_has_bool_fp_r14_pattern();

        for (j = 0; j < sh_nlines; j++) {
                if (sh_lines[j][0] == 0)
                        continue;
                live |= sh_regs_used(sh_lines[j]);
        }

        for (src = 14; src >= 8; src--) {
                int k;
                if (!(live & (1u << src)))
                        continue;
                if (src == 14 && need_fp)
                        continue;
                if (src == 14 && has_boolfp_r14)
                        continue;
                for (k = 0;
                     k < (int)(sizeof rename_prio
                               / sizeof rename_prio[0]);
                     k++) {
                        int dst = rename_prio[k];
                        if (!(live & (1u << dst))) {
                                sh_rename_reg(src, dst);
                                live &= ~(1u << src);
                                live |= 1u << dst;
                                usedmask[IREG] &= ~(1u << src);
                                usedmask[IREG] |= 1u << dst;
                                break;
                        }
                }
        }
}

/* Post-RA delay-slot rename: complement of sh_leaf_rename_callee_saved.
 * For single-callee-saved leaf functions with MULTIPLE bra-to-exit
 * sites (which sh_inline_returns will turn into multiple inline rts),
 * rename the dirty callee-saved reg to r14 specifically so each rts
 * delay slot pops r14 for free.
 *
 * Mutually exclusive with leaf_rename above (which gates on
 * nexits <= 1). Both passes inspect the same shape — single dirty
 * callee-saved on a leaf — but pick different rename targets:
 *
 *   leaf_rename     (nexits <= 1):  dirty -> caller-saved scratch
 *                                   (eliminates the prologue save)
 *   delay_slot      (nexits  > 1):  dirty -> r14
 *                                   (so each rts pop fills delay slot)
 *
 * Trade-off prod follows: with N rts sites, N wasted nops (from
 * the eliminate-save approach) cost more than 1 saved push. SHC
 * keeps the callee-saved and uses the delay slot.
 *
 * Under our default high-first allocator, the dirty reg is naturally
 * r14 already → this pass is a no-op early-exit. Under a low-first
 * allocator (gap2 plan, future Chunk 5) the dirty reg is the lowest
 * picked (r8 under bare low-first) and this pass migrates it to r14
 * for the delay-slot pattern.
 *
 * Skips on has_boolfp_r14 to avoid colliding with sh_rewrite_bool_fp,
 * which writes r14 as FP scratch in its injection. Symmetric guard
 * to leaf_rename's. */
static void sh_rename_to_r14_for_delay_slot(int need_fp,
                                            int exit_label_num) {
        unsigned live = 0;
        int j, src, nexits, ncallee_saved;

        nexits = sh_count_exit_bras(exit_label_num);
        if (nexits <= 1)
                return;  /* leaf_rename's territory */
        ncallee_saved = bitcount(usedmask[IREG] & INTVAR);
        if (ncallee_saved != 1)
                return;  /* multi-callee-saved: save-range extension handles it */
        if (need_fp)
                return;  /* r14 occupied as FP */
        if (sh_body_has_bool_fp_r14_pattern())
                return;  /* bool_fp will write r14 as scratch */

        /* Find the single dirty callee-saved register. */
        src = -1;
        for (j = 8; j <= 14; j++) {
                if (usedmask[IREG] & (1u << j)) { src = j; break; }
        }
        if (src < 0 || src == 14)
                return;  /* nothing to rename, or already at r14 */

        /* r14 must be unreferenced in the body — otherwise renaming
         * src to r14 would alias two distinct values. Compute live
         * the same way leaf_rename does. */
        for (j = 0; j < sh_nlines; j++) {
                if (sh_lines[j][0] == 0)
                        continue;
                live |= sh_regs_used(sh_lines[j]);
        }
        if (live & (1u << 14))
                return;

        sh_rename_reg(src, 14);
        usedmask[IREG] &= ~(1u << src);
        usedmask[IREG] |= 1u << 14;
}

/* Replace each `bra <exit_label>; <delay_insn>` in the body with an
 * inline copy of the function epilogue: `<delay_insn>; [FP teardown];
 * [pops]; rts; <last_pop_as_delay_slot>`. This matches Hitachi SHC's
 * pattern of duplicating the epilogue at each return point instead of
 * branching to a shared exit block.
 *
 * The original exit label and function()-emitted epilogue remain for
 * the fall-through case at the end of the function body. */
static void sh_inline_returns(const char *exit_label,
                              int need_fp, int ncalls,
                              unsigned umask)
{
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int nout = 0;
        int i, j, k;
        char bra_pat[64];

        snprintf(bra_pat, sizeof bra_pat, "\tbra\t%s\n", exit_label);

        for (i = 0; i < sh_nlines; i++) {
                if (nout >= SH_MAX_LINES - 16) {
                        fprintf(stderr,
                                "sh_inline_returns: "
                                "line buffer overflow "
                                "(%d/%d), output truncated\n",
                                nout, SH_MAX_LINES);
                        break;
                }
                if (sh_lines[i][0] == 0)
                        continue;
                if (strcmp(sh_lines[i], bra_pat) != 0) {
                        strncpy(new_lines[nout], sh_lines[i],
                                SH_MAX_LINELEN - 1);
                        new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                        nout++;
                        continue;
                }
                /* Found `bra <exit>`. Next non-empty line is delay. */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0)
                                break;
                if (j >= sh_nlines)
                        break;
                /* Emit the delay instruction as a regular line. */
                strncpy(new_lines[nout], sh_lines[j],
                        SH_MAX_LINELEN - 1);
                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                nout++;
                /* Emit inline epilogue. */
                if (need_fp)
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tmov\tr14,r15\n");
                else if (sh_sp_locals_only && sh_localsize > 0)
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tadd\t#%d,r15\n", sh_localsize);
                if (sh_uses_macl)
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\tlds.l\t@r15+,macl\n");
                if (ncalls) {
                        int has_reg_pop = 0;
                        for (k = 8; k <= 14; k++)
                                if (umask & (1u << k))
                                        has_reg_pop = 1;
                        if (!has_reg_pop) {
                                /* PR is the only restore — can't go in
                                 * rts delay slot, emit before rts. */
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tlds.l\t@r15+,pr\n");
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\trts\n");
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tnop\n");
                        } else {
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tlds.l\t@r15+,pr\n");
                                for (k = 8; k <= 14; k++) {
                                        if (!(umask & (1u << k)))
                                                continue;
                                        if (k == 14 && !(umask & 0x3f00)) {
                                                /* r14 is the only reg pop —
                                                 * it goes in rts delay. */
                                                break;
                                        }
                                        /* Check if this is the last reg
                                         * pop — save it for delay slot. */
                                        {
                                                int last = 1;
                                                int m;
                                                for (m = k+1; m <= 14; m++)
                                                        if (umask & (1u<<m))
                                                                last = 0;
                                                if (last) break;
                                        }
                                        snprintf(new_lines[nout++],
                                                 SH_MAX_LINELEN,
                                                 "\tmov.l\t@r15+,r%d\n", k);
                                }
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\trts\n");
                                /* Last reg pop as delay slot. */
                                for (k = 14; k >= 8; k--)
                                        if (umask & (1u << k)) {
                                                snprintf(new_lines[nout++],
                                                         SH_MAX_LINELEN,
                                                         "\tmov.l\t@r15+,r%d\n", k);
                                                break;
                                        }
                        }
                } else {
                        /* No calls — just reg pops + rts. */
                        int last_pop = -1;
                        for (k = 14; k >= 8; k--)
                                if (umask & (1u << k)) {
                                        last_pop = k;
                                        break;
                                }
                        for (k = 8; k <= 14; k++) {
                                if (!(umask & (1u << k)))
                                        continue;
                                if (k == last_pop)
                                        continue;
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.l\t@r15+,r%d\n", k);
                        }
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\trts\n");
                        if (last_pop >= 0)
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tmov.l\t@r15+,r%d\n", last_pop);
                        else
                                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                         "\tnop\n");
                }
                /* Skip the original delay line. */
                i = j;
        }
        /* Copy remaining lines (exit label, etc.). */
        for (; i < sh_nlines; i++) {
                if (nout >= SH_MAX_LINES) break;
                strncpy(new_lines[nout], sh_lines[i], SH_MAX_LINELEN - 1);
                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                nout++;
        }
        /* Copy back. */
        for (i = 0; i < nout; i++)
                strncpy(sh_lines[i], new_lines[i], SH_MAX_LINELEN - 1);
        sh_nlines = nout;
}

/* Move literal pool entries from the end of the function into the
 * body at the first dead zone (after an rts + delay slot) that
 * follows all pool references. SH-2's `mov.l @(disp,PC)` can only
 * reach forward, so pool entries must come AFTER their last
 * referencing instruction.
 *
 * If no dead zone exists in the body (no inline returns), the pool
 * stays at the end and shlit_flush() handles it as before. */

/* Replace the dispatch label placeholder with the SH-2 braf jump
 * table idiom:
 *   shll r0          ; index * 2 (for .short entries)
 *   mov  r0,r1
 *   mova .Ltable,r0  ; table address
 *   mov.w @(r0,r1),r0 ; load offset
 *   braf r0          ; PC + 4 + offset
 *   nop
 * .Ltable:
 *   .short case0 - .Ltable
 *   .short case1 - .Ltable
 *   ...
 */
static void sh_emit_switch_dispatch(void) {
        int i, j, insert_after = -1;
        static char new_lines[SH_MAX_LINES][SH_MAX_LINELEN];
        int nout = 0;
        char table_label[32];
        char bt_pattern[64];

        if (!sh_switch.active)
                return;

        snprintf(table_label, sizeof table_label,
                 "Lswt%d", sh_switch.dispatch_lab);
        /* Match the upper bounds-check bt (GT → bt hilabel). */
        snprintf(bt_pattern, sizeof bt_pattern,
                 "\tbt\t%s\n", sh_switch.hilabel);

        /* Find the bounds-check bt instruction. The braf dispatch
         * replaces the bra+nop that follows it. */
        for (i = 0; i < sh_nlines; i++)
                if (sh_lines[i][0] != 0
                    && strcmp(sh_lines[i], bt_pattern) == 0) {
                        insert_after = i;
                        break;
                }

        if (insert_after < 0) {
                sh_switch.active = 0;
                return;
        }

        for (i = 0; i < sh_nlines; i++) {
                if (nout >= SH_MAX_LINES - 32) {
                        fprintf(stderr,
                                "sh_emit_switch_dispatch: "
                                "line buffer overflow "
                                "(%d/%d), output truncated\n",
                                nout, SH_MAX_LINES);
                        break;
                }
                if (sh_lines[i][0] == 0)
                        continue;
                strncpy(new_lines[nout], sh_lines[i],
                        SH_MAX_LINELEN - 1);
                new_lines[nout][SH_MAX_LINELEN - 1] = 0;
                nout++;

                if (i != insert_after)
                        continue;

                /* Skip the bra+nop that follows the bt (swstmt's
                 * fallthrough branch — unreachable with braf). */
                for (j = i + 1; j < sh_nlines; j++)
                        if (sh_lines[j][0] != 0) break;
                if (j < sh_nlines
                    && sh_has_prefix(sh_lines[j], "\tbra")) {
                        sh_kill_line(j);
                        for (j = j + 1; j < sh_nlines; j++)
                                if (sh_lines[j][0] != 0) break;
                        if (j < sh_nlines
                            && sh_has_prefix(sh_lines[j], "\tnop"))
                                sh_kill_line(j);
                }

                /* Insert braf dispatch idiom. */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tshll\tr0\n");
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tmov\tr0,r1\n");
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tmova\t%s,r0\n", table_label);
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tmov.w\t@(r0,r1),r0\n");
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tbraf\tr0\n");
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "\tnop\n");
                /* Emit the .short offset table. */
                snprintf(new_lines[nout++], SH_MAX_LINELEN,
                         "%s:\n", table_label);
                for (j = 0; j < sh_switch.ncases; j++) {
                        if (nout >= SH_MAX_LINES) {
                                fprintf(stderr,
                                        "sh_emit_switch_dispatch: "
                                        "line buffer overflow "
                                        "(%d/%d), output truncated\n",
                                        nout, SH_MAX_LINES);
                                break;
                        }
                        snprintf(new_lines[nout++], SH_MAX_LINELEN,
                                 "\t.short\t%s - %s\n",
                                 sh_switch.labels[j], table_label);
                }
        }

        /* Copy back. */
        sh_nlines = nout;
        for (i = 0; i < nout; i++) {
                strncpy(sh_lines[i], new_lines[i], SH_MAX_LINELEN - 1);
                sh_lines[i][SH_MAX_LINELEN - 1] = 0;
        }

        sh_switch.active = 0;
}

/* Range-aware pool interleaving.
 *
 * SH-2 PC-relative loads have limited reach:
 *   mov.l @(disp,PC),Rn  — 8-bit unsigned disp * 4 → max 1020 bytes
 *   mov.w @(disp,PC),Rn  — 8-bit unsigned disp * 2 → max  510 bytes
 *
 * For small functions where all literals can reach the tail, we leave
 * them for shlit_flush() (matches production's tail-pool pattern).
 * For large functions, we flush literals that would go out of range
 * at the next unconditional branch after their first reference.
 *
 * Each sh_lines[] entry is roughly one 2-byte SH-2 instruction, so
 * (sh_nlines - ref_line) * 2 approximates the byte distance from a
 * reference to the function tail.
 */
#define SH_REACH_LONG  1020
#define SH_REACH_WORD   510

static int sh_is_uncond_branch(const char *s) {
        while (*s == ' ' || *s == '\t') s++;
        if (s[0] == 'b' && s[1] == 'r' && s[2] == 'a'
            && (s[3] == ' ' || s[3] == '\t' || s[3] == '\n'))
                return 1;
        if (s[0] == 'b' && s[1] == 'r' && s[2] == 'a'
            && s[3] == 'f' && (s[4] == ' ' || s[4] == '\t' || s[4] == '\n'))
                return 1;
        if (s[0] == 'r' && s[1] == 't' && s[2] == 's'
            && (s[3] == '\n' || s[3] == '\0' || s[3] == ' ' || s[3] == '\t'))
                return 1;
        if (s[0] == 'j' && s[1] == 'm' && s[2] == 'p'
            && (s[3] == ' ' || s[3] == '\t'))
                return 1;
        return 0;
}

/* Label identifier boundary check — true if `c` could continue a
 * label identifier like L42 (we must NOT treat L42 as matching inside
 * L420 or L42B). Labels in our emitter are `L<digits>` so the
 * continuation set is [A-Za-z0-9_]. */
static int sh_is_label_char(int c) {
        return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z') || c == '_';
}

/* In sh_lines[], record every index that REFERENCES `label_str` as
 * a whole identifier. Excludes the definition line (where the label
 * appears at position 0 followed by `:`) — rewriting that would
 * turn a valid definition into a reference to a different label and
 * leave the original label undefined. Returns the number of indices
 * filled in `refs` (capped at max_refs). */
static int sh_find_label_refs(const char *label_str,
                              int *refs, int max_refs) {
        int n = 0, j;
        int lab_len = (int)strlen(label_str);
        for (j = 0; j < sh_nlines && n < max_refs; j++) {
                const char *p;
                if (sh_lines[j][0] == 0)
                        continue;
                p = sh_lines[j];
                /* Skip a leading `label_str:` (definition line). */
                {
                        const char *q = p;
                        while (*q == ' ' || *q == '\t')
                                q++;
                        if (strncmp(q, label_str, lab_len) == 0
                            && q[lab_len] == ':')
                                continue;
                }
                while ((p = strstr(p, label_str)) != NULL) {
                        if (!sh_is_label_char((unsigned char)p[lab_len])) {
                                refs[n++] = j;
                                break;
                        }
                        p += lab_len;
                }
        }
        return n;
}

/* In a single sh_lines entry, replace every whole-identifier
 * occurrence of `old_lab` with `new_lab`. Caller guarantees both
 * have the same `L<digits>` shape so buffer-size worries are
 * bounded: +few chars max. */
static void sh_rewrite_label_in_line(char *line, const char *old_lab,
                                     const char *new_lab) {
        int old_len = (int)strlen(old_lab);
        int new_len = (int)strlen(new_lab);
        char buf[SH_MAX_LINELEN];
        char *dst = buf;
        char *end = buf + SH_MAX_LINELEN - 1;
        const char *src = line;
        while (*src) {
                if (strncmp(src, old_lab, old_len) == 0
                    && !sh_is_label_char((unsigned char)src[old_len])) {
                        if (dst + new_len >= end)
                                return;  /* overflow; leave line unchanged */
                        memcpy(dst, new_lab, new_len);
                        dst += new_len;
                        src += old_len;
                } else {
                        if (dst >= end)
                                return;
                        *dst++ = *src++;
                }
        }
        *dst = 0;
        strncpy(line, buf, SH_MAX_LINELEN - 1);
        line[SH_MAX_LINELEN - 1] = 0;
}

/* Pre-pass for sh_interleave_pool: split any literal whose references
 * span more than `reach` bytes (approximated as reach/2 lines) into
 * multiple shlits entries with fresh labels. Rewrites out-of-range
 * references in sh_lines[] to point at the new labels.
 *
 * Without this, large functions like FUN_06037E28 produce pcrel-too-
 * far errors from sh-elf-as: SH-2's `mov.l @(disp,PC)` has an 8-bit
 * unsigned displacement scaled by 4 (max +1020 bytes forward). A
 * single label with references at line 69 and line 684 cannot
 * possibly sit at a pool location in range of both — two labels
 * with two pool copies is the only solution. See C3 in
 * methodology_remediation.md.
 *
 * The outer loop re-examines appended entries; a newly-split cluster
 * that is itself still too wide gets split again on a later
 * iteration. Terminates because each iteration strictly shrinks a
 * cluster's span OR doesn't split at all. */
static void sh_split_widely_spread_literals(void) {
        int i;
        static int refs[SH_MAX_LINES];
        for (i = 0; i < nshlit; i++) {
                int reach, reach_lines;
                char lab_str[32];
                int nrefs, j;

                reach = shlits[i].is_word ? SH_REACH_WORD : SH_REACH_LONG;
                /* reach/2 lines is the nominal lines-per-byte budget
                 * (2 bytes/insn). Use reach/5 as the split threshold:
                 * pool insertions inflate byte counts beyond 2/line
                 * (pool data is 4 bytes + align pads), and the pool
                 * position itself is placed AFTER all refs of a
                 * cluster — so first_ref's distance to the pool grows
                 * from `span` to `span + branch_to_pool_distance`.
                 * reach/5 gives enough margin to survive both.
                 * Empirically tuned against FUN_06037E28: reach/4
                 * left 2 pcrel-too-far sites where a refs[249, 371]
                 * cluster's pool landed at 550 (602 bytes from 249). */
                reach_lines = reach / 5;

                snprintf(lab_str, sizeof lab_str, "L%d",
                         shlits[i].label);
                nrefs = sh_find_label_refs(lab_str, refs, SH_MAX_LINES);
                if (nrefs < 2)
                        continue;

                for (j = 1; j < nrefs; j++) {
                        int newlab, r;
                        char new_lab_str[32];
                        if (refs[j] - refs[0] <= reach_lines)
                                continue;
                        /* Too-wide gap at refs[j]. Split: new label
                         * for refs[j..nrefs-1]; existing label keeps
                         * refs[0..j-1]. */
                        if (nshlit >= SH_MAX_LITERALS)
                                return;
                        newlab = genlabel(1);
                        snprintf(new_lab_str, sizeof new_lab_str,
                                 "L%d", newlab);
                        shlits[nshlit] = shlits[i];
                        shlits[nshlit].label = newlab;
                        nshlit++;
                        for (r = j; r < nrefs; r++) {
                                sh_rewrite_label_in_line(
                                        sh_lines[refs[r]],
                                        lab_str, new_lab_str);
                        }
                        break;
                }
        }
}

static void sh_interleave_pool(void) {
        int i, j, k;
        int first_ref[SH_MAX_LITERALS];
        int last_ref[SH_MAX_LITERALS];
        char labstr[32];
        int flushed[SH_MAX_LITERALS];

        if (nshlit == 0)
                return;

        /* Split widely-spread literals into single-cluster entries
         * so each pool instance is in reach of all its refs. */
        sh_split_widely_spread_literals();

        /* Step 1: for each literal, find first and last reference. */
        for (i = 0; i < nshlit; i++) {
                first_ref[i] = -1;
                last_ref[i] = -1;
                flushed[i] = 0;
                snprintf(labstr, sizeof labstr, "L%d",
                         shlits[i].label);
                for (j = 0; j < sh_nlines; j++) {
                        if (sh_lines[j][0] != 0
                            && strstr(sh_lines[j], labstr)) {
                                if (first_ref[i] < 0)
                                        first_ref[i] = j;
                                last_ref[i] = j;
                        }
                }
        }

        /* Step 2: walk forward, flushing at unconditional branches.
         *
         * At each branch+delay, check: would any pending literal go
         * out of range if deferred to the tail? If so, flush it now.
         * This naturally produces tail pools for small functions
         * (range is never violated) and multi-island for large ones. */
        for (j = 0; j < sh_nlines; j++) {
                int flush_count, pool_lines, insert_at;

                if (sh_lines[j][0] == 0)
                        continue;
                if (!sh_is_uncond_branch(sh_lines[j]))
                        continue;

                /* Skip the delay slot to find the insertion point.
                 * k lands on the delay-slot instruction; insert
                 * AFTER it (k+1) so the branch+delay pair stays
                 * intact. */
                for (k = j + 1; k < sh_nlines; k++)
                        if (sh_lines[k][0] != 0)
                                break;
                if (k >= sh_nlines)
                        insert_at = sh_nlines;
                else
                        insert_at = k + 1;

                /* Count literals that (a) have their last ref at or
                 * before this branch, AND (b) would be out of range
                 * if deferred to the tail. Track shorts separately so
                 * we can reserve an extra `.align 2` pad line between
                 * shorts and longs when the short count is odd.
                 *
                 * Pending-pool accounting: `sh_nlines` at decision
                 * time underestimates the true tail — every not-yet-
                 * flushed literal will add at least one line later
                 * (plus possible `.align 2` padding). Without this,
                 * a literal whose first_ref is just barely within
                 * reach of current sh_nlines gets deferred, and the
                 * real tail lands past its reach once other pools
                 * inflate the line count. */
                flush_count = 0;
                {
                        int flush_shorts = 0, flush_longs = 0;
                        int pending = 0;
                        int p;
                        for (p = 0; p < nshlit; p++)
                                if (!flushed[p])
                                        pending++;
                        for (i = 0; i < nshlit; i++) {
                                int reach, dist;
                                if (flushed[i] || last_ref[i] < 0
                                    || last_ref[i] > k)
                                        continue;
                                reach = shlits[i].is_word
                                        ? SH_REACH_WORD : SH_REACH_LONG;
                                /* Conservative tail estimate: current
                                 * sh_nlines + every still-pending
                                 * literal. Must match the formula
                                 * used in the emit passes below —
                                 * mismatching them causes the emit
                                 * to flush more entries than this
                                 * count reserved pool_lines for,
                                 * overrunning the shift and clobbering
                                 * live lines. */
                                dist = (sh_nlines + pending
                                        - first_ref[i]) * 2;
                                if (dist <= reach)
                                        continue;
                                if (shlits[i].is_word)
                                        flush_shorts++;
                                else
                                        flush_longs++;
                        }
                        flush_count = flush_shorts + flush_longs;
                        if (flush_count == 0)
                                continue;
                        /* .align 2 header + entries + optional .align
                         * 2 pad between shorts and longs when the
                         * short count is odd AND longs follow. */
                        pool_lines = 1 + flush_count
                                   + ((flush_shorts & 1) && flush_longs
                                        ? 1 : 0);
                }
                if (sh_nlines + pool_lines > SH_MAX_LINES)
                        return;

                /* Shift lines from insert_at onward. */
                for (k = sh_nlines - 1; k >= insert_at; k--) {
                        strncpy(sh_lines[k + pool_lines],
                                sh_lines[k], SH_MAX_LINELEN - 1);
                        sh_lines[k + pool_lines][SH_MAX_LINELEN - 1] = 0;
                }

                /* Insert the island. Emit shorts first then longs with
                 * an optional `.align 2` pad between, so .long entries
                 * always land on a 4-byte boundary regardless of how
                 * many .short entries preceded them in the same flush.
                 * This mirrors shlit_flush()'s layout — without the
                 * sort, pool_lines was computed assuming flush_count
                 * entries + one leading .align, but an interleaved
                 * long/short/long sequence would misalign the second
                 * long (C3 in methodology_remediation). */
                snprintf(sh_lines[insert_at], SH_MAX_LINELEN,
                         "\t.align 2\n");
                {
                        int slot = 1;
                        int nshort_in_flush = 0;
                        int pending = 0;
                        int p;
                        /* Same conservative tail-distance estimate as
                         * the counting pass above (see that comment). */
                        for (p = 0; p < nshlit; p++)
                                if (!flushed[p])
                                        pending++;
                        /* Pass 1: shorts. */
                        for (i = 0; i < nshlit; i++) {
                                int reach, dist;
                                if (flushed[i] || last_ref[i] < 0
                                    || last_ref[i] > insert_at - 1)
                                        continue;
                                if (!shlits[i].is_word)
                                        continue;
                                reach = SH_REACH_WORD;
                                dist = (sh_nlines + pending
                                        - first_ref[i]) * 2;
                                if (dist <= reach)
                                        continue;
                                snprintf(sh_lines[insert_at + slot],
                                         SH_MAX_LINELEN,
                                         "L%d:\t.short\t%d\n",
                                         shlits[i].label,
                                         shlits[i].value);
                                flushed[i] = 1;
                                slot++;
                                nshort_in_flush++;
                        }
                        /* Optional `.align 2` pad between shorts and
                         * longs when the short count is odd AND longs
                         * follow. MUST match exactly the count pass's
                         * pad reservation condition (same dist-filter)
                         * or we overrun pool_lines and clobber a live
                         * shifted line (cost hours in C3). */
                        if (nshort_in_flush & 1) {
                                int has_longs_for_flush = 0;
                                int q;
                                for (q = 0; q < nshlit; q++) {
                                        int qreach, qdist;
                                        if (flushed[q] || last_ref[q] < 0
                                            || last_ref[q] > insert_at - 1)
                                                continue;
                                        if (shlits[q].is_word)
                                                continue;
                                        qreach = SH_REACH_LONG;
                                        qdist = (sh_nlines + pending
                                                 - first_ref[q]) * 2;
                                        if (qdist <= qreach)
                                                continue;
                                        has_longs_for_flush = 1;
                                        break;
                                }
                                if (has_longs_for_flush) {
                                        snprintf(sh_lines[insert_at + slot],
                                                 SH_MAX_LINELEN,
                                                 "\t.align 2\n");
                                        slot++;
                                }
                        }
                        /* Pass 2: longs (symbols + int values). */
                        for (i = 0; i < nshlit; i++) {
                                int reach, dist;
                                if (flushed[i] || last_ref[i] < 0
                                    || last_ref[i] > insert_at - 1)
                                        continue;
                                if (shlits[i].is_word)
                                        continue;
                                reach = SH_REACH_LONG;
                                dist = (sh_nlines + pending
                                        - first_ref[i]) * 2;
                                if (dist <= reach)
                                        continue;
                                if (shlits[i].is_symbol)
                                        snprintf(sh_lines[insert_at + slot],
                                                 SH_MAX_LINELEN,
                                                 "L%d:\t.long\t%s\n",
                                                 shlits[i].label,
                                                 shlits[i].name);
                                else
                                        snprintf(sh_lines[insert_at + slot],
                                                 SH_MAX_LINELEN,
                                                 "L%d:\t.long\t%d\n",
                                                 shlits[i].label,
                                                 shlits[i].value);
                                flushed[i] = 1;
                                slot++;
                        }
                }
                sh_nlines += pool_lines;

                /* Adjust ref indices for un-flushed literals. */
                for (i = 0; i < nshlit; i++) {
                        if (!flushed[i]) {
                                if (first_ref[i] >= insert_at)
                                        first_ref[i] += pool_lines;
                                if (last_ref[i] >= insert_at)
                                        last_ref[i] += pool_lines;
                        }
                }
                j = insert_at + pool_lines - 1;
        }

        /* Step 4: compact shlits[], keeping only un-flushed entries
         * for shlit_flush() at the tail. */
        {
                int dst = 0;
                for (i = 0; i < nshlit; i++) {
                        if (!flushed[i]) {
                                if (dst != i)
                                        shlits[dst] = shlits[i];
                                dst++;
                        }
                }
                nshlit = dst;
        }
}

static int sh_is_delay_safe(const char *s) {
        /* Conservative whitelist: simple ALU and data moves only.
         * Excludes any branch, jmp/jsr/rts/bsr/bra/bt/bf, and the
         * few PC-relative or delay-slot-forbidden forms. */
        if (sh_has_prefix(s, "mov")) return 1;
        if (sh_has_prefix(s, "mov.b")) return 1;
        if (sh_has_prefix(s, "mov.w")) return 1;
        if (sh_has_prefix(s, "mov.l")) return 1;
        if (sh_has_prefix(s, "add")) return 1;
        if (sh_has_prefix(s, "sub")) return 1;
        if (sh_has_prefix(s, "and")) return 1;
        if (sh_has_prefix(s, "or")) return 1;
        if (sh_has_prefix(s, "xor")) return 1;
        if (sh_has_prefix(s, "not")) return 1;
        if (sh_has_prefix(s, "neg")) return 1;
        if (sh_has_prefix(s, "exts.b")) return 1;
        if (sh_has_prefix(s, "exts.w")) return 1;
        if (sh_has_prefix(s, "extu.b")) return 1;
        if (sh_has_prefix(s, "extu.w")) return 1;
        if (sh_has_prefix(s, "shll")) return 1;
        if (sh_has_prefix(s, "shlr")) return 1;
        if (sh_has_prefix(s, "shar")) return 1;
        return 0;
}

static int sh_capture_begin(FILE **tmp_out) {
        int savfd;
        FILE *tmp;
        fflush(stdout);
        savfd = dup(1);
        if (savfd < 0) return -1;
        tmp = tmpfile();
        if (!tmp) {
                close(savfd);
                return -1;
        }
        if (dup2(fileno(tmp), 1) < 0) {
                fclose(tmp);
                close(savfd);
                return -1;
        }
        *tmp_out = tmp;
        return savfd;
}

static void sh_capture_end(int savfd, FILE *tmp) {
        fflush(stdout);
        dup2(savfd, 1);
        close(savfd);
        rewind(tmp);
        sh_nlines = 0;
        while (sh_nlines < SH_MAX_LINES
            && fgets(sh_lines[sh_nlines], SH_MAX_LINELEN, tmp))
                sh_nlines++;
        if (sh_nlines >= SH_MAX_LINES && !feof(tmp))
                fprintf(stderr,
                        "sh_capture_end: line buffer overflow "
                        "(%d/%d), output truncated\n",
                        sh_nlines, SH_MAX_LINES);
        fclose(tmp);
}

/* Phase B.0: recursive DAG walk that collects every direct callee
 * (CALL whose function-pointer kid is an ADDRG). Indirect calls are
 * skipped — the ABI-conservative clobber at the call site handles
 * them. LCC's DAGs can share sub-nodes via hash-consing, so the same
 * CALL node may be reached via multiple paths; dedup is handled by
 * the caller (linear scan on a small callee list). */
#define SH_MAX_DIRECT_CALLEES 128
static void sh_collect_callees_rec(Node p, Symbol *buf, int *n, int max) {
        Node fp;
        int i;
        if (!p)
                return;
        if (generic(p->op) == CALL) {
                fp = p->kids[0];
                if (fp && generic(fp->op) == ADDRG && fp->syms[0]
                    && fp->syms[0]->name) {
                        Symbol tgt = fp->syms[0];
                        for (i = 0; i < *n; i++)
                                if (buf[i] == tgt)
                                        break;
                        if (i == *n && *n < max)
                                buf[(*n)++] = tgt;
                }
        }
        sh_collect_callees_rec(p->kids[0], buf, n, max);
        sh_collect_callees_rec(p->kids[1], buf, n, max);
}

/* Scan every Gen/Jump/Label Code in the current codehead's list,
 * walk each forest root chain via ->link, and collect direct callees.
 * Runs at function() capture time when codehead.next still points to
 * this function's code and DAGs are in parse-time form. */
static void sh_collect_direct_callees(struct sh_ipa_fn *e) {
        static Symbol buf[SH_MAX_DIRECT_CALLEES];
        Code cp;
        Node n;
        int count = 0;
        for (cp = codehead.next; cp; cp = cp->next) {
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (n = cp->u.forest; n; n = n->link)
                        sh_collect_callees_rec(n, buf, &count,
                                               SH_MAX_DIRECT_CALLEES);
        }
        if (count > 0) {
                e->direct_callees = allocate(
                        count * sizeof(Symbol), PERM);
                memcpy(e->direct_callees, buf,
                       count * sizeof(Symbol));
                e->n_direct_callees = count;
        }
}

/* IR->function() entry point — Phase A.1: capture only, defer all
 * codegen to sh_drain_ipa_queue() at progend. Snapshot of codehead
 * preserves the head of this function's Code linked list; retained
 * FUNC arena (Xinterface.retain_func_arena=1) keeps the list reachable
 * until the drain consumes it. Phase B.0 also walks the DAG to
 * extract this function's direct-call edges for the cgraph. */
static void function(Symbol f, Symbol caller[], Symbol callee[], int ncalls) {
        struct sh_ipa_fn *e;
        NEW0(e, PERM);
        e->f = f;
        e->caller = caller;
        e->callee = callee;
        e->ncalls = ncalls;
        e->code_head = codehead;
        /* Capture positional pragma flags bound to THIS function, then
         * reset globals so the next function starts clean (matches A.0
         * semantics where these pragmas applied to the next compile). */
        e->gbr_param = sh_gbr_param;
        e->word_indexed_after_first = sh_word_indexed_after_first;
        sh_gbr_param = 0;
        sh_word_indexed_after_first = 0;
        /* Same pattern for sh_switch: populated by sh_switchjump()
         * during the front-end, consumed by sh_emit_switch_dispatch()
         * at codegen. Capture the whole struct, then zero the global. */
        e->switch_state = sh_switch;
        memset(&sh_switch, 0, sizeof sh_switch);
        /* Phase B.0: extract direct-call edges from the DAG while it's
         * still reachable via codehead.next. Consumed by the cgraph
         * builder at drain time (Phase B.1). */
        sh_collect_direct_callees(e);
        if (!sh_ipa_queue)
                sh_ipa_queue = e;
        else
                sh_ipa_tail->next = e;
        sh_ipa_tail = e;
        sh_ipa_nqueued++;
}

/* Phase D: returns 1 iff every direct callee of `e` is known in the
 * queue AND has writes_r4 == 0 (set by Phase C's reverse-topo pass).
 * When true, the parameter-homing logic in sh_process_deferred_fn
 * can pin the first parameter to r4 (via askregvar with argreg(0))
 * instead of promoting it to a callee-saved INTVAR wildcard — the
 * "keep p1 in r4 across all calls" optimization SHC does when it
 * has IPA visibility. A leaf function (no calls) gets this for free
 * via the ncalls == 0 path; this helper is for the non-leaf case. */
static int sh_ipa_all_callees_preserve_r4(struct sh_ipa_fn *e) {
        int k;
        if (!e || e->n_direct_callees == 0)
                return 0;
        for (k = 0; k < e->n_direct_callees; k++) {
                Symbol tgt = e->direct_callees[k];
                /* sh_lookup_writes_r4 handles primary-entry,
                 * sub-entry (.asm_entry FUN_X inside another
                 * queue entry's body), and the conservative
                 * extern fallback in one place. */
                if (!tgt || !tgt->name)
                        return 0;
                if (sh_lookup_writes_r4(tgt->name))
                        return 0;
        }
        return 1;
}

/* Phase E.2: recursive search for any read of a Symbol via
 * INDIR(ADDRL(local)) in a subtree. Used by the Shape 2 detector
 * to verify the candidate local is referenced as an ordinary
 * pointer-valued local with no surprises. */
static int sh_ipa_subtree_reads_local(Node p, Symbol local) {
        int i;
        if (!p) return 0;
        if (generic(p->op) == INDIR
            && p->kids[0]
            && generic(p->kids[0]->op) == ADDRL
            && p->kids[0]->syms[0] == local)
                return 1;
        for (i = 0; i < NELEMS(p->kids); i++)
                if (p->kids[i]
                    && sh_ipa_subtree_reads_local(p->kids[i], local))
                        return 1;
        return 0;
}

/* Phase E.2: recursive check for ASGN whose LHS is ADDRL(local).
 * The Shape 2 candidate must be assigned exactly once across the
 * function body — additional writes invalidate the pin. */
static int sh_ipa_root_writes_local(Node p, Symbol local) {
        if (!p) return 0;
        if (generic(p->op) == ASGN
            && p->kids[0]
            && generic(p->kids[0]->op) == ADDRL
            && p->kids[0]->syms[0] == local)
                return 1;
        return 0;
}

/* Phase E.2: count ASGN-to-local roots across the captured body.
 * Returns the count. Caller checks count == 1 for Shape 2
 * eligibility. */
static int sh_ipa_count_local_assigns(Symbol local) {
        Code cp;
        int n = 0;
        for (cp = codehead.next; cp; cp = cp->next) {
                Node nd;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (nd = cp->u.forest; nd; nd = nd->link)
                        if (sh_ipa_root_writes_local(nd, local))
                                n++;
        }
        return n;
}

/* Phase E.2: scan the body and find a Shape-2-eligible local.
 *
 * Eligibility:
 *   - The local has pointer/integer type (4-byte register-sized).
 *   - It is assigned exactly once (sh_ipa_count_local_assigns ==
 *     1). The single assignment is the function's setup of this
 *     "threaded value."
 *   - It's not address-taken (`local->addressed == 0`) — pinning
 *     to a register is incompatible with addresses being held.
 *   - At least one CALL ARG-position references it via INDIR
 *     (ADDRL(local)) so the pin actually pays off.
 *
 * Returns the qualifying Symbol or NULL.
 *
 * The caller is expected to additionally verify
 * sh_ipa_all_callees_preserve_r4(e) before pinning, since Shape 2
 * is only safe when r4 stays put across every call. */
static Symbol sh_ipa_find_shape2_local(struct sh_ipa_fn *e) {
        Code cp;
        Symbol candidate = NULL;
        Symbol second = NULL;
        int saw_call_use = 0;

        /* Pass 1: enumerate all locals that have a single ASGN
         * root in the body. We need one and only one candidate;
         * if multiple locals qualify we'd need a heuristic to
         * pick (the one passed as ARG[0] of every call), which
         * is more bookkeeping than warranted right now. Bail in
         * that case. */
        for (cp = codehead.next; cp; cp = cp->next) {
                Node nd;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (nd = cp->u.forest; nd; nd = nd->link) {
                        Symbol l;
                        if (generic(nd->op) != ASGN
                            || !nd->kids[0]
                            || generic(nd->kids[0]->op) != ADDRL
                            || !nd->kids[0]->syms[0])
                                continue;
                        l = nd->kids[0]->syms[0];
                        if (l->addressed) continue;
                        /* Must be a pointer or integer (4-byte
                         * register-sized) — Shape 2 binds it to
                         * one r4. Other sizes / types aren't
                         * supported by this pass. */
                        if (!l->type
                            || l->type->size != 4)
                                continue;
                        if (sh_ipa_count_local_assigns(l) != 1)
                                continue;
                        if (candidate && candidate != l) {
                                /* More than one single-assign
                                 * candidate. Punt rather than
                                 * pick wrong. */
                                second = l;
                                break;
                        }
                        candidate = l;
                }
                if (second) break;
        }
        if (second || !candidate) return NULL;

        /* Pass 2: confirm the candidate is read in at least one
         * CALL ARG-position. */
        for (cp = codehead.next; cp; cp = cp->next) {
                Node nd;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (nd = cp->u.forest; nd; nd = nd->link) {
                        if (generic(nd->op) != ARG)
                                continue;
                        if (sh_ipa_subtree_reads_local(nd,
                                                       candidate)) {
                                saw_call_use = 1;
                                break;
                        }
                }
                if (saw_call_use) break;
        }
        if (!saw_call_use) return NULL;

        return candidate;
}

/* Phase E.1b: recursive search for any INDIR(ADDRF(pinned)) in a
 * subtree. Used to detect ARG subtrees that reference the pinned
 * parameter in a shape our rewrite doesn't recognize, so we can
 * veto the pin rather than produce miscompiled output. */
static int sh_ipa_subtree_reads_pinned(Node p, Symbol pinned) {
        int i;
        if (!p)
                return 0;
        if (generic(p->op) == INDIR
            && p->kids[0]
            && generic(p->kids[0]->op) == ADDRF
            && p->kids[0]->syms[0] == pinned)
                return 1;
        for (i = 0; i < NELEMS(p->kids); i++)
                if (p->kids[i]
                    && sh_ipa_subtree_reads_pinned(p->kids[i], pinned))
                        return 1;
        return 0;
}

/* Does this forest root write to pinned via ASGN(ADDRF(pinned), ...)?
 * Such writes veto the pin: the rewrite pass tracks delta arithmetic
 * relative to pinned's original value, which is invalidated once the
 * source program itself rebinds pinned. */
static int sh_ipa_root_writes_pinned(Node p, Symbol pinned) {
        if (!p)
                return 0;
        if (generic(p->op) == ASGN
            && p->kids[0]
            && generic(p->kids[0]->op) == ADDRF
            && p->kids[0]->syms[0] == pinned)
                return 1;
        return 0;
}

enum {
        SH_IPA_PAT_NONE = 0,  /* subtree doesn't reference pinned */
        SH_IPA_PAT_RAW  = 1,  /* ARG(INDIR(ADDRF(pinned))) */
        SH_IPA_PAT_ADD  = 2,  /* ARG(ADD(INDIR(ADDRF(pinned)), CNST)) */
        SH_IPA_PAT_BAIL = 3   /* references pinned in unsupported shape */
};

/* Classify an ARG root's kid subtree against the two supported
 * in-place-mutation shapes. For PAT_ADD, *out_k receives the CNST
 * immediate (signed). */
static int sh_ipa_classify_arg(Node arg, Symbol pinned, int *out_k) {
        Node sub;
        assert(arg && generic(arg->op) == ARG);
        sub = arg->kids[0];
        if (!sub)
                return SH_IPA_PAT_NONE;
        if (generic(sub->op) == INDIR
            && sub->kids[0]
            && generic(sub->kids[0]->op) == ADDRF
            && sub->kids[0]->syms[0] == pinned)
                return SH_IPA_PAT_RAW;
        if (generic(sub->op) == ADD
            && sub->kids[0]
            && sub->kids[1]
            && generic(sub->kids[0]->op) == INDIR
            && sub->kids[0]->kids[0]
            && generic(sub->kids[0]->kids[0]->op) == ADDRF
            && sub->kids[0]->kids[0]->syms[0] == pinned
            && generic(sub->kids[1]->op) == CNST) {
                *out_k = (int)sub->kids[1]->syms[0]->u.c.v.i;
                return SH_IPA_PAT_ADD;
        }
        if (sh_ipa_subtree_reads_pinned(sub, pinned))
                return SH_IPA_PAT_BAIL;
        return SH_IPA_PAT_NONE;
}

/* Build a fresh DAG:
 *     ASGN+ty(ADDRF+P4(pinned),
 *             ADD+ty(INDIR+ty(ADDRF+P4(pinned)), CNST+ty(delta)))
 * for splicing into a Gen forest as a sibling root. ty is the full
 * type+size byte of the ARG driving this mutation so the synthetic
 * tree matches the parameter's own kind (I4 for int, P4 for pointer). */
static Node sh_ipa_build_mutation_asgn(Symbol pinned, int ty, int delta) {
        int ptrop = P + sizeop(IR->ptrmetric.size);
        Node addrf1 = newnode(ADDRF + ptrop, NULL, NULL, pinned);
        Node addrf2 = newnode(ADDRF + ptrop, NULL, NULL, pinned);
        Node indir  = newnode(INDIR + ty, addrf2, NULL, NULL);
        Node cnst   = newnode(CNST + ty, NULL, NULL, intconst(delta));
        Node add    = newnode(ADD   + ty, indir, cnst, NULL);
        return newnode(ASGN + ty, addrf1, add, NULL);
}

/* Scan every captured forest for pin-incompatible shapes involving
 * pinned. Returns 1 iff the pin is SAFE AND PROFITABLE to engage:
 *   (a) every ARG root whose subtree touches pinned matches PAT_RAW
 *       or PAT_ADD, and no non-ARG root writes pinned (safety); AND
 *   (b) at least one ARG root matches PAT_ADD (profitability).
 *
 * Condition (b) is critical. Engaging the pin without any mutation
 * sites to rewrite still causes allocator cascades (r4 leaves the
 * wildcard pool, other values shift callee-saved slots, the r14-FP
 * rename path takes different branches) that surfaced as byte-match
 * regressions on PAT_RAW-only callers during E.1b validation. Those
 * functions would get nothing from the pin — skip them. */
static int sh_ipa_scan_pin_safety(Symbol pinned) {
        Code cp;
        int has_add_site = 0;
        for (cp = codehead.next; cp; cp = cp->next) {
                Node n;
                if (cp->kind != Gen && cp->kind != Jump
                    && cp->kind != Label)
                        continue;
                for (n = cp->u.forest; n; n = n->link) {
                        int k;
                        if (generic(n->op) == ARG) {
                                int pat = sh_ipa_classify_arg(
                                        n, pinned, &k);
                                if (pat == SH_IPA_PAT_BAIL)
                                        return 0;
                                if (pat == SH_IPA_PAT_ADD)
                                        has_add_site = 1;
                                continue;
                        }
                        if (sh_ipa_root_writes_pinned(n, pinned))
                                return 0;
                }
        }
        return has_add_site;
}

/* Destructive rewrite: for every ADD-pattern ARG in a Gen forest,
 * splice a synthesized ASGN mutation root BEFORE the ARG and drop
 * the ADD wrapper off the ARG's kid so it reads pinned's register
 * directly. Tracks a running net-delta across the whole function
 * so calls 2..N whose ARG is p+K with K matching the running delta
 * get no new ASGN (their value is already live in the pinned reg).
 *
 * The synthesized ASGN's LHS is ADDRF(pinned), whose prelabel case
 * (gen.c:454-456) converts to VREG+P because pinned->sclass is
 * REGISTER. The ASGN case (gen.c:462-464) then rtargets the RHS
 * ADD to pinned's Symbol directly. ralloc's REGISTER-class short-
 * circuit (gen.c:655) handles the mutation with no getreg / no
 * spillee / no vbl crash; the ADDI4(reg,immi8) `?` copy-elim rule
 * at sh.md:563 emits `add #delta, r<pinned>` because the result
 * and first-kid registers coincide. */
static void sh_ipa_apply_mutation_rewrite(struct sh_ipa_fn *e,
                                          Symbol pinned) {
        Code cp;
        int running = 0;
        for (cp = codehead.next; cp; cp = cp->next) {
                Node prev, n, next;
                if (cp->kind != Gen)
                        continue;
                prev = NULL;
                for (n = cp->u.forest; n; n = next) {
                        int k, pat;
                        next = n->link;
                        if (generic(n->op) != ARG) {
                                prev = n;
                                continue;
                        }
                        pat = sh_ipa_classify_arg(n, pinned, &k);
                        if (pat == SH_IPA_PAT_ADD) {
                                int delta = k - running;
                                running = k;
                                if (delta != 0) {
                                        int ty = opkind(n->op);
                                        Node asgn = sh_ipa_build_mutation_asgn(
                                                pinned, ty, delta);
                                        asgn->link = n;
                                        if (prev == NULL)
                                                cp->u.forest = asgn;
                                        else
                                                prev->link = asgn;
                                        prev = asgn;
                                }
                                /* ARG's new kid is the bare INDIR
                                 * subtree — drop the ADD wrapper.
                                 * The INDIR will read pinned's
                                 * register, and the ARG's target()
                                 * hook (E.1a) rtargets to
                                 * pinned_param directly, skipping
                                 * the LOAD-wrap that would otherwise
                                 * crash. */
                                n->kids[0] = n->kids[0]->kids[0];
                        }
                        prev = n;
                }
        }
        e->total_delta = running;
        e->needs_restore = (running != 0);
}

/* The full per-function codegen pipeline, formerly the body of
 * function(). Restores codehead from the captured snapshot so
 * gencode()/emitcode() iterate this function's Code list. */
/* asm-shim Stage 4 (saturn/workstreams/asm_shim_design.md §7):
 * a "naked shim" is a function whose body is nothing but
 * ASM_INSN+V Nodes — no C-derived RET, JUMP, ASGN, etc. We emit
 * such functions as just their body lines (canonical form) with
 * the function label and section directives, no prologue/epilogue
 * wrapping. The asm body's own `rts` terminates flow.
 *
 * Detection: walk the captured Code list; any Gen forest carrying
 * a non-ASM_INSN Node fails the check. Framing records
 * (Blockbeg/Blockend/Defpoint/Label) are skipped — they don't
 * represent emitted code. */
static int sh_function_is_naked_shim(struct sh_ipa_fn *e) {
        Code cp;
        int saw_asm_insn = 0;
        for (cp = e->code_head.next; cp; cp = cp->next) {
                Node n;
                if (cp->kind != Gen)
                        continue;
                for (n = cp->u.forest; n; n = n->link) {
                        if (specific(n->op) != ASM_INSN+V)
                                return 0;
                        saw_asm_insn = 1;
                }
        }
        return saw_asm_insn;
}

static void sh_process_deferred_fn(struct sh_ipa_fn *e) {
        Symbol f = e->f;
        Symbol *caller = e->caller;
        Symbol *callee = e->callee;
        int ncalls = e->ncalls;
        /* Phase E: publish the current queue entry so per-node hooks
         * (target(), clobber(), doarg()) can consult IPA state. Paired
         * with the reset at end of function; leaving it set after the
         * body would leak into the next function's processing. */
        sh_ipa_current = e;
        int i, localsize, sizeisave, need_fp, has_prologue;
        int need_r14_rename = 0;
        int r14_rename_to = -1;
        Symbol r, argregs[4];
        unsigned saved_tmask = tmask[IREG];
        unsigned saved_vmask = vmask[IREG];
        Symbol saved_intvar_prio[7];

        codehead = e->code_head;
        /* Restore per-function positional pragma state from the queue
         * entry. Captured at function() parse-time; the processing
         * body reads + clears these as if they had been set moments
         * before (matching A.0 semantics). */
        sh_gbr_param = e->gbr_param;
        sh_word_indexed_after_first = e->word_indexed_after_first;
        sh_switch = e->switch_state;

        /* Emit .global then .text, matching A.0's export→swtoseg(CODE)
         * sequence at decl.c:809-812. segment(CODE) fires only the
         * first time through the drain since cseg tracks the section.
         * We call segment() directly rather than swtoseg(CODE): init.c's
         * curseg is already CODE from parse-time swtoseg calls, so
         * swtoseg would early-return without invoking IR->segment.
         * Bypassing gets us to the suppression-aware sh.md segment()
         * with sh_ipa_in_drain=1, which emits correctly. */
        if (f->sclass != STATIC)
                print("\t.global %s\n", f->x.name);
        segment(CODE);

        /* asm-shim Stage 4: naked-shim fast path. Skip
         * prologue/epilogue/pool-flush/peephole/allocator entirely
         * and emit just the body's ASM_INSN Nodes in canonical
         * form. The body's own `rts` terminates flow; the function
         * exit label (cfunc->u.f.label) is unused for an all-asm
         * body — defined-but-not-emitted is fine. The result
         * round-trips a prod-derived shim's bytes (modulo canonical
         * whitespace, which asm_normalize.py strips). */
        if (sh_function_is_naked_shim(e)) {
                Code cp;
                /* `.align 1` = 2-byte alignment (the SH-2 instruction
                 * minimum) rather than `.align 2` = 4-byte. Prod
                 * function entries can sit at 2-mod-4 offsets (e.g.
                 * FUN_0604DF12 ends in 0x12, not 0x10 or 0x14). A
                 * 4-byte align between adjacent asm-bodied functions
                 * would round up by 2 bytes, shifting all subsequent
                 * code/pool offsets and breaking PC-relative loads
                 * downstream. The asm body's own `.byte` padding
                 * handles any explicit alignment prod requires. */
                print("\t.align 1\n");
                print("%s:\n", f->x.name);
                for (cp = e->code_head.next; cp; cp = cp->next) {
                        Node n;
                        if (cp->kind != Gen)
                                continue;
                        for (n = cp->u.forest; n; n = n->link) {
                                if (specific(n->op) != ASM_INSN+V)
                                        continue;
                                sh_emit_asm_insn(n->syms[0]
                                                 ? n->syms[0]->x.asm_insn
                                                 : NULL);
                        }
                }
                /* Restore Phase E state so the next function's
                 * processing starts clean. tmask/vmask and the
                 * wildcard priority array were not touched on this
                 * path. */
                sh_ipa_current = NULL;
                return;
        }

        nshlit = 0;
        sh_all_returns_inlined = 0;
        sh_uses_macl = 0;
        sh_sp_locals_only = 0;

        /* Save the INTVAR slots of the wildcard priority array so we
         * can restore at function exit. iregw stores ireg_prio by
         * pointer (mkwildcard doesn't copy), so mutations below are
         * visible to askreg. Slots 21..27 are the INTVAR range
         * (shifted down by one after r0 joined INTTMP at slot 31). */
        for (i = 0; i < 7; i++)
                saved_intvar_prio[i] = ireg_prio[21 + i];

        /* #pragma sh_alloc_lowfirst: per-function flip of the INTVAR
         * allocation order. SHC's r8-first allocation is matched by
         * making slot 27 (highest INTVAR priority) hold r8 and slot
         * 21 hold r14. Empirically tagged per-function — see the
         * per-function pragmas in the TU sources. Default is
         * r14-first. Restored before function() returns. */
        if (sh_func_has_attr(f->name, SH_ATTR_LOWFIRST)) {
                ireg_prio[27] = ireg[8];
                ireg_prio[26] = ireg[9];
                ireg_prio[25] = ireg[10];
                ireg_prio[24] = ireg[11];
                ireg_prio[23] = ireg[12];
                ireg_prio[22] = ireg[13];
                ireg_prio[21] = ireg[14];
        }

        /* #pragma noregalloc: SHC v5.0 §3.10 — the allocator does not
         * place anything in R8..R14 for this function. Bridge pragma:
         * pairs with noregsave callers that pass callee-saved state
         * through without disturbing it. Implementation: clear bits
         * 8..14 of tmask and vmask for the duration of this function
         * only, then
         * restore before returning. INTVAR is R8..R14 so vmask becomes
         * empty — parameter-only / pure-passthrough functions handle
         * this fine; register-pressured functions spill to stack. */
        if (sh_func_has_attr(f->name, SH_ATTR_NOREGALLOC)) {
                tmask[IREG] &= ~(0x7FU << 8);
                vmask[IREG] &= ~(0x7FU << 8);
        }

        usedmask[0] = usedmask[1] = 0;
        freemask[0] = freemask[1] = ~(unsigned)0;
        offset = maxoffset = maxargoffset = 0;

        for (i = 0; callee[i]; i++)
                ;
        {
                int stack_off = 0;
                for (i = 0; callee[i]; i++) {
                        Symbol p = callee[i];
                        Symbol q = caller[i];
                        assert(q);
                        r = argreg(i);
                        if (i < 4)
                                argregs[i] = r;
                        /* Register-passed incoming params have no
                         * stack slot. Only params 4+ get an offset
                         * (starting from 0), matching doarg()'s
                         * shifted layout on the caller side. */
                        if (i < 4) {
                                p->x.offset = q->x.offset = 0;
                                p->x.name = q->x.name = stringd(0);
                        } else {
                                stack_off = roundup(stack_off,
                                                    q->type->align);
                                p->x.offset = q->x.offset = stack_off;
                                p->x.name = q->x.name =
                                        stringd(stack_off);
                                stack_off = roundup(
                                        stack_off + q->type->size, 4);
                        }
                        if (i < 4 && !isstruct(q->type)
                            && !p->addressed && ncalls == 0) {
                                p->sclass = q->sclass = REGISTER;
                                askregvar(p, r);
                                assert(p->x.regnode
                                       && p->x.regnode->vbl == p);
                                q->x = p->x;
                                q->type = p->type;
                        } else if (i == 0 && !isstruct(q->type)
                                   && !p->addressed
                                   && sh_ipa_all_callees_preserve_r4(e)
                                   && sh_ipa_scan_pin_safety(p)) {
                                /* Phase E.1b: non-leaf, but IPA
                                 * proves every direct callee
                                 * preserves r4 AND every ARG site's
                                 * use of this parameter matches a
                                 * supported mutation pattern. Pin
                                 * the parameter to argreg(0) and
                                 * apply the pre-ralloc rewrite so
                                 * in-place ADDs reach the allocator
                                 * as standard ASGN(VREG, ADD(VREG,
                                 * CNST)) mutations. target()'s ARG
                                 * redirection (E.1a) then keeps the
                                 * ARG's LOAD-wrap from firing. */
                                p->sclass = q->sclass = REGISTER;
                                if (askregvar(p, r)) {
                                        assert(p->x.regnode
                                               && p->x.regnode->vbl == p);
                                        q->x = p->x;
                                        q->type = p->type;
                                        e->pinned_param = p;
                                        e->pinned_reg =
                                                r->x.regnode->number;
                                        sh_ipa_apply_mutation_rewrite(
                                                e, p);
                                } else {
                                        /* r4 unexpectedly taken —
                                         * fall back to wildcard. */
                                        p->sclass = REGISTER;
                                        if (askregvar(p,
                                                      rmap(ttob(p->type)))) {
                                                q->sclass = REGISTER;
                                                q->type = p->type;
                                        } else {
                                                p->sclass = AUTO;
                                        }
                                }
                        } else if (i < 4 && !isstruct(q->type)
                                   && !p->addressed) {
                                p->sclass = REGISTER;
                                if (askregvar(p,
                                              rmap(ttob(p->type)))) {
                                        q->sclass = REGISTER;
                                        q->type = p->type;
                                } else {
                                        p->sclass = AUTO;
                                }
                        }
                }
        }
        assert(!caller[i]);
        offset = 0;

        /* Phase E.2: Shape 2 derived-local pin. If Shape 1 didn't
         * engage (no pinned_param), the function isn't a leaf, and
         * every direct callee preserves r4, look for a single-
         * assigned read-only local used as the first ARG of every
         * call. Pin it to r4 directly so the call sequence elides
         * its redundant load-into-r4 setups.
         *
         * The pin is allowed to claim r4 even though r4 is the
         * argreg(0) for the FIRST instruction of the function (the
         * incoming p1). The local's setup expression naturally
         * computes p1+K into r4 because both p1 and the local
         * resolve to the same physical register; the codegen path
         * for ASGN(ADDRL(local), ADDP4(INDIR(ADDRF(p1)), CNST(K)))
         * lowers to `mov r4, r4 ; add #K, r4` which the existing
         * mov-to-self peephole then trims. */
        if (!sh_ipa_current->pinned_param
            && ncalls > 0
            && sh_ipa_all_callees_preserve_r4(e)) {
                Symbol cand = sh_ipa_find_shape2_local(e);
                if (dflag && cand)
                        fprint(stderr,
                               "[ipa-shape2] %s: cand=%s\n",
                               f->name, cand->name);
                if (cand && argregs[0]) {
                        cand->sclass = REGISTER;
                        if (askregvar(cand, argregs[0])) {
                                sh_ipa_current->pinned_local = cand;
                                sh_ipa_current->pinned_reg =
                                        argregs[0]->x.regnode->number;
                        } else {
                                /* r4 already taken — Shape 2 can't
                                 * fire. Restore default storage so
                                 * the local goes to its normal
                                 * stack home. */
                                cand->sclass = AUTO;
                        }
                }
        }

        gencode(caller, callee);

        usedmask[IREG] &= INTVAR;
        maxargoffset = roundup(maxargoffset, 4);
        /* Strip the 16-byte nominal reservation for the register-
         * passed arg slots — the real outgoing-arg area only needs
         * to hold args 4+ so we avoid reserving space nobody uses. */
        if (maxargoffset >= 16)
                maxargoffset -= 16;
        else
                maxargoffset = 0;
        localsize = roundup(maxargoffset + maxoffset, 4);
        sh_localsize = localsize;

        /* FP is only needed when there are locals on the stack
         * (register-promoted locals don't count). Stack-passed
         * incoming params could in principle be read via r15, but
         * for simplicity we still set up FP when any stack-arg is
         * present. */
        need_fp = (localsize > 0);
        for (i = 0; !need_fp && callee[i]; i++)
                if (i >= 4)
                        need_fp = 1;
        sh_fp_active = need_fp;

        /* Speculative r14 reclaim. INTVAR lets the allocator pick r14
         * as a variable home so leaf functions match Hitachi's
         * descending-from-r14 allocation. If the function also turns
         * out to need FP, that's a conflict: r14 can't be both the
         * frame pointer and a var at the same time. We steal the
         * highest-numbered free callee-saved reg as the new var home
         * and rewrite the captured body after peephole (see below).
         *
         * If ALL callee-saved regs are in use (no free rename target),
         * we resolve the conflict the other way: keep r14 as a var
         * and skip the FP entirely. Locals are already accessed via
         * r15 in our emit paths; the only FP duties are (a) saving
         * the pre-local SP for the epilogue — replaced by an explicit
         * `add #localsize,r15` — and (b) ADDRFP4 displacements for
         * stack-passed params, which get a localsize adjustment. */
        sh_sp_locals_only = 0;
        if (need_fp && (usedmask[IREG] & (1u << 14))) {
                int j;
                for (j = 13; j >= 8; j--) {
                        /* Candidate must be not-yet-used AND permitted
                         * by vmask. #pragma global_register clears its
                         * pinned bit from vmask; this rename pass must
                         * respect that exclusion or we'd stomp a reg
                         * the TU has reserved as a named global. */
                        if (!(usedmask[IREG] & (1u << j))
                            && (vmask[IREG] & (1u << j))) {
                                r14_rename_to = j;
                                break;
                        }
                }
                if (r14_rename_to >= 0) {
                        need_r14_rename = 1;
                        usedmask[IREG] &= ~(1u << 14);
                        usedmask[IREG] |= 1u << r14_rename_to;
                } else {
                        /* No free register — drop FP, keep r14 as var.
                         * The prologue will still allocate local space
                         * via SP, and the epilogue restores SP with an
                         * explicit add instead of mov r14,r15. */
                        need_fp = 0;
                        sh_fp_active = 0;
                        sh_sp_locals_only = 1;
                }
        }

        if (need_fp)
                usedmask[IREG] |= 1u << 14;

        /* Save-default: extend the save range to SHC's
         * [lowest_dirty..r14] contiguous rule. Corpus study
         * (2,308 prod functions) showed this single rule covers ~70%
         * of functions (FULL_RANGE + clean NO_SAVES + LEAF).
         * Leaves with no callee-saved writes pass through untouched
         * because sh_regsave_extend() is a no-op on empty masks.
         * Functions that need a different behavior opt out via
         * #pragma noregsave / noregalloc below.
         *
         * Inserted AFTER the speculative r14 rename so we don't force
         * r14 into usedmask before the rename decision is made — the
         * rename only fires when the allocator picked r14 as a var
         * home, and the extension shouldn't change that signal.
         * Re-applied after the post-peephole rebuild (see sizeisave
         * rebuild block below) because that rebuild AND's with body-
         * liveness and would otherwise strip the extended-but-never-
         * referenced regs back out. */
        usedmask[IREG] = sh_regsave_extend(usedmask[IREG]);

        /* #pragma noregsave / noregalloc: SHC v5.0 §3.10 — neither
         * saves R8..R14 at prologue/epilogue. noregsave says "trust
         * me, caller handles preservation." noregalloc is the bridge
         * variant that additionally excludes R8..R14 from allocation
         * (enforced in tmask/vmask above at function entry). The
         * save-set behavior is identical for both. Strip R8..R14 from
         * usedmask so the save/restore machinery emits nothing for
         * them. R14 may still appear as FP if need_fp forced it
         * above; that's a user concern — tagging noregalloc on a
         * function with stack locals breaks the bridge contract. */
        if (sh_func_has_attr(f->name,
                             SH_ATTR_NOREGSAVE | SH_ATTR_NOREGALLOC))
                usedmask[IREG] &= ~(0x7FU << 8);  /* clear bits 8..14 */

        sizeisave = 4 * bitcount(usedmask[IREG]);
        if (ncalls)
                sizeisave += 4;
        framesize = sizeisave;
        sh_sizeisave = sizeisave;

        /* Capture the body (param-home moves + emitcode) BEFORE
         * emitting anything to stdout. This lets the peephole
         * rewrite the body and the post-peephole live-set analysis
         * trim dead callee-saved saves before the prologue emits
         * its push list. */
        {
                FILE *tmp = NULL;
                int savfd = sh_capture_begin(&tmp);
                for (i = 0; i < 4 && callee[i]; i++) {
                        r = argregs[i];
                        if (r && callee[i]->sclass == REGISTER
                            && callee[i]->x.regnode
                            && callee[i]->x.regnode->number
                                != r->x.regnode->number) {
                                print("\tmov\tr%d,r%d\n",
                                      r->x.regnode->number,
                                      callee[i]->x.regnode->number);
                        }
                }
                emitcode();
                if (savfd >= 0)
                        sh_capture_end(savfd, tmp);
                else
                        sh_nlines = 0;

                /* ──────────────────────────────────────────────────
                 * Peephole pass driver — PHASE 1 (body, pre-prologue)
                 *
                 * Passes run top-down on sh_lines[]. Killed lines are
                 * marked via `sh_kill_line(j)` (see the helper's own
                 * comment near line 1662) and skipped by every
                 * downstream pass by testing `sh_lines[j][0] == 0`.
                 * Grep for that read pattern in any new pass you add.
                 *
                 * Ordering rationale for this phase:
                 *   sh_peephole              — general line-level cleanups;
                 *                              runs first so later passes
                 *                              see normalized instructions.
                 *   sh_rewrite_gbr_param     — only if #pragma gbr_param;
                 *                              rewrites r4 references.
                 *   sh_elim_redundant_ext    — drop exts.w/b that duplicate
                 *                              a preceding mov.w/b load.
                 *   sh_fold_mov_extw_to_movw — fold mov.l+exts.w → mov.w;
                 *                              may SHRINK a pool entry.
                 *                              MUST precede disp-range
                 *                              checks in the next pass.
                 *   sh_fold_base_displacement— collapse mov+add+mov.X into
                 *                              mov.X @(disp,Rn); disp range
                 *                              check depends on pool
                 *                              shrinks above being in.
                 *   sh_apply_word_indexed_after_first    — opt-in via #pragma; converts
                 *                              all but the first .w disp-to-r0
                 *                              load into indexed form. Only
                 *                              fires in functions where prod
                 *                              evidence shows this exact
                 *                              anomaly (FUN_06044834 at the
                 *                              moment; rare across the corpus).
                 *   sh_route_via_r0          — route operands through R0 to
                 *                              enable indexed addressing;
                 *                              runs after ext-elim so R0
                 *                              has the best chance of being
                 *                              free.
                 *   sh_fold_post_increment   — add+load → @rN+ .
                 *   sh_fill_branch_delays    — bra delay slot.
                 *   sh_fill_cond_delays      — bt/bf delay slot. MUST run
                 *                              after the folds above so it
                 *                              sees the final instruction
                 *                              sequence.
                 *   sh_rename_r14_var /      — register renames; run last
                 *   sh_leaf_rename_callee_     in phase 1 so they target
                 *   saved                     the final register choice.
                 *                              Both can fire on the same
                 *                              function; the two-stage
                 *                              composition is correct by
                 *                              construction — see the
                 *                              detailed comment next to
                 *                              the call sites below.
                 * ────────────────────────────────────────────────── */
                sh_peephole();
                if (sh_gbr_param)
                        sh_rewrite_gbr_param();
                sh_elim_redundant_ext();
                sh_fuse_mov_into_add();
                sh_fold_mov_extw_to_movw();
                sh_fold_base_displacement();
                if (sh_word_indexed_after_first)
                        sh_apply_word_indexed_after_first();
                sh_route_via_r0();
                sh_fold_post_increment();
                sh_fill_branch_delays();
                sh_fill_cond_delays();
                sh_elim_dead_labels();

                /* r14-rename composition (methodology_remediation C2.c).
                 *
                 * Both of the following can fire on the same function —
                 * the conditions are NOT mutually exclusive. The only
                 * case where both fire is a leaf function (ncalls == 0)
                 * that also needs FP and had r14 already allocated as a
                 * variable home (need_r14_rename set during prologue
                 * planning at lines ~4861–4872 above).
                 *
                 * In that case the execution order produces a correct
                 * two-stage rename:
                 *   1. sh_rename_r14_var moves r14 → r13..r8 (whichever
                 *      callee-saved was free at prologue planning time)
                 *      and records the move in usedmask.
                 *   2. sh_leaf_rename_callee_saved sees the post-step-1
                 *      live set: r14 is no longer live, so its own
                 *      r14 skip guard doesn't matter; it finds the sole
                 *      remaining callee-saved (the step-1 destination)
                 *      and moves it again to a caller-saved (r7..r4/r0).
                 * Net effect: r14 → r7 (or similar), reached in two
                 * passes instead of one. Inefficient but not incorrect.
                 *
                 * Invariant after both run:
                 *   - if need_fp: r14 is live (freed by step 1 for FP use)
                 *   - else:       r14 is not live
                 * A new rename pass added between these (or after) must
                 * preserve that invariant.
                 *
                 * Full unification into a single entry point was
                 * considered; the call-site composition is simple enough
                 * that unifying would only add indirection. */
                if (need_r14_rename)
                        sh_rename_r14_var(r14_rename_to);
                if (ncalls == 0)
                        sh_leaf_rename_callee_saved(need_fp,
                                                    f->u.f.label);
                /* Complement of leaf_rename for the multi-rts shape:
                 * see sh_rename_to_r14_for_delay_slot comment.
                 * Renames TO r14 (callee-saved) so the rename is safe
                 * across jsr calls — no ncalls gate required. No-op
                 * under high-first allocator (dirty reg is already
                 * r14). */
                sh_rename_to_r14_for_delay_slot(need_fp,
                                                f->u.f.label);
        }

        /* ──────────────────────────────────────────────────
         * Peephole pass driver — PHASE 2 (structural emission +
         *                                 usedmask rebuild)
         *
         * These passes emit or rewrite structural regions that don't
         * interact with the body-level register allocation. Order
         * within the phase is not load-bearing:
         *   sh_emit_switch_dispatch  — switch tables
         *   sh_result_to_arg_reg     — call return → arg reg for chained
         *                              calls
         *   sh_elim_dead_branches    — drop unreachable branches
         *   sh_elim_dead_byte_ext    — drop byte extensions the store
         *                              would re-narrow anyway
         *   sh_reorder_post_call_counter — counter incr after jsr
         *
         * Then the inline block below rebuilds usedmask so dead-after-
         * peephole registers drop off the prologue save list.
         * ────────────────────────────────────────────────── */
        sh_emit_switch_dispatch();
        sh_result_to_arg_reg();
        sh_elim_dead_branches();
        sh_elim_dead_byte_ext();
        sh_reorder_post_call_counter();

        /* Rebuild usedmask from surviving body lines so dead-after-
         * peephole registers drop off the save/restore list. This is
         * only safe when the body doesn't reference r14-relative FP
         * addresses — if it does, changing sizeisave would shift the
         * disps in those references and break correctness. The FP
         * direct-disp paths in emit2() emit `@(disp,r14)`, which is
         * the only form that pins sizeisave; bare `@r14` is always a
         * variable-pointer deref in our emitter and doesn't lock. */
        {
                unsigned live = 0;
                int fp_locked = 0;
                int j;
                for (j = 0; j < sh_nlines; j++) {
                        if (sh_lines[j][0] == 0)
                                continue;
                        live |= sh_regs_used(sh_lines[j]);
                        if (strstr(sh_lines[j], ",r14)"))
                                fp_locked = 1;
                }
                if (!fp_locked) {
                        unsigned keep = usedmask[IREG] & live;
                        if (need_fp)
                                keep |= 1u << 14;
                        /* Re-extension after post-peephole liveness trim:
                         * the body-liveness AND above would drop r8..r14
                         * bits that the save-default rule included but
                         * the body never references. Re-extend so the
                         * [lowest_dirty..r14] shape survives the trim. */
                        keep = sh_regsave_extend(keep);
                        /* noregsave / noregalloc re-strip: undo both
                         * the liveness keep (body may reference r14
                         * for FP setup) and the `need_fp` force-set
                         * above. */
                        if (sh_func_has_attr(f->name,
                                             SH_ATTR_NOREGSAVE
                                             | SH_ATTR_NOREGALLOC))
                                keep &= ~(0x7FU << 8);
                        if (keep != usedmask[IREG]) {
                                usedmask[IREG] = keep;
                                sizeisave = 4 * bitcount(usedmask[IREG]);
                                if (ncalls)
                                        sizeisave += 4;
                                framesize = sizeisave;
                                sh_sizeisave = sizeisave;
                        }
                }
        }

        if (sh_uses_macl) {
                sizeisave += 4;
                framesize = sizeisave;
                sh_sizeisave = sizeisave;
        }

        if (sh_gbr_param) {
                sizeisave += 4;
                framesize = sizeisave;
                sh_sizeisave = sizeisave;
        }

        has_prologue = need_fp || ncalls || usedmask[IREG] != 0
                       || sh_gbr_param;

        /* Inline epilogues at each `bra <exit>` to match Hitachi's
         * duplicated-return pattern. The exit label comes from the
         * function's return label allocated by the front end. */
        if (has_prologue) {
                char exit_lab[32];
                snprintf(exit_lab, sizeof exit_lab, "L%d",
                         f->u.f.label);
                sh_inline_returns(exit_lab, need_fp, ncalls,
                                  usedmask[IREG]);
        }

        /* ──────────────────────────────────────────────────
         * Peephole pass driver — PHASE 3 (late, post-frame)
         *
         * Runs after the prologue size is known (need_fp, sizeisave,
         * sh_uses_macl, sh_gbr_param, has_prologue all finalized).
         * Ordering rationale:
         *   sh_reorder_pre_call_args — arg-load shuffle just before jsr.
         *   sh_diversify_range_regs  — spread register use so disp-mode
         *                              addressing has headroom.
         *   sh_reorder_extu_mov      — small local extu+mov reorder.
         *   sh_restructure_eq_chain  — cmp/eq chain → dispatch table.
         *                              Landmine: historically hardcoded
         *                              r14 as pop register; now uses the
         *                              actually-allocated register.
         *   sh_fold_dt               — countdown-loop → dt instruction.
         *   sh_fold_conditional_delays— second bt/bf delay-slot pass that
         *                              sees the now-restructured eq
         *                              chains and dt folds.
         *   sh_rewrite_bool_fp       — bool_fp injection using r14.
         *                              MUST run AFTER phase 2's usedmask
         *                              rebuild AND AFTER any rename that
         *                              could free r14. Guards: bails if
         *                              r14 is not in usedmask.
         *   sh_swap_pool_add         — swap pool-load vs add order when
         *                              the swap creates a post-inc
         *                              opportunity.
         *   sh_coalesce_move_chains  — collapse redundant mov chains
         *                              exposed by earlier passes.
         *   sh_elim_redundant_mov_r0 — drop mov-r0 sequences that are
         *                              now dead after coalescing.
         *   sh_interleave_pool       — MUST BE LAST in phase 3. Emits
         *                              the literal pool inline at the
         *                              right spots; any later pass would
         *                              need pool-aware rewriting.
         * ────────────────────────────────────────────────── */
        sh_reorder_pre_call_args();
        sh_diversify_range_regs();
        sh_reorder_extu_mov();
        sh_restructure_eq_chain();
        sh_fold_dt();
        sh_fold_conditional_delays();
        sh_rewrite_bool_fp(need_fp);
        sh_swap_pool_add();
        sh_coalesce_move_chains();
        sh_elim_redundant_mov_r0();
        sh_interleave_pool();

        segment(CODE);
        print("\t.align 2\n");
        print("%s:\n", f->x.name);

        if (has_prologue) {
                /* Hitachi ordering (verified against Daytona CCE
                 * output): push r14 first, then r13, r12, ..., r8
                 * (descending register number), then PR last. */
                for (i = 14; i >= 8; i--)
                        if (usedmask[IREG] & (1u << i))
                                print("\tmov.l\tr%d,@-r15\n", i);
                if (ncalls)
                        print("\tsts.l\tpr,@-r15\n");
                if (sh_uses_macl)
                        print("\tsts.l\tmacl,@-r15\n");
                if (sh_gbr_param) {
                        print("\tstc.l\tgbr,@-r15\n");
                        print("\tldc\tr4,gbr\n");
                }
                if (need_fp) {
                        print("\tmov\tr15,r14\n");
                        if (localsize > 0)
                                print("\tadd\t#%d,r15\n",
                                      -localsize);
                } else if (sh_sp_locals_only && localsize > 0) {
                        /* No FP — allocate local space via SP only. */
                        print("\tadd\t#%d,r15\n", -localsize);
                }
        }

        /* Decide rts delay-slot filler. Priority:
         *   1. The last non-PR epilogue pop (always wins when the
         *      function saves any callee-saved reg).
         *   2. The last safe body instruction, if the epilogue has
         *      no pops to donate (or only PR, which is forbidden in
         *      rts delay slots).
         *   3. Plain nop. */
        {
                int delay_idx = -1;       /* body line to pull up */
                int last_reg_pop = -1;    /* pop index in epilogue */
                int npops = 0;
                int pop_regs[16];
                int j;

                if (has_prologue) {
                        int want_pr = ncalls;
                        if (want_pr)
                                pop_regs[npops++] = -1;
                        for (i = 8; i <= 14; i++)
                                if (usedmask[IREG] & (1u << i))
                                        pop_regs[npops++] = i;
                        for (i = npops - 1; i >= 0; i--)
                                if (pop_regs[i] != -1) {
                                        last_reg_pop = i;
                                        break;
                                }
                }

                if (last_reg_pop < 0) {
                        for (j = sh_nlines - 1; j >= 0; j--) {
                                if (sh_lines[j][0] == 0)
                                        continue;
                                if (sh_is_label_line(sh_lines[j]))
                                        continue;
                                if (sh_is_delay_safe(sh_lines[j]))
                                        delay_idx = j;
                                break;
                        }
                }

                for (j = 0; j < sh_nlines; j++) {
                        if (j == delay_idx)
                                continue;
                        if (sh_lines[j][0] == 0)
                                continue;
                        fputs(sh_lines[j], stdout);
                }

                if (has_prologue && !sh_all_returns_inlined) {
                        /* Pop order is the reverse of push order:
                         * PR first (if saved), then r8..r14. The
                         * SH-2 architectural rule `lds.l @r15+,pr`
                         * is forbidden in the rts delay slot
                         * because rts reads PR at branch time —
                         * so we pop PR strictly BEFORE rts and use
                         * the highest-numbered reg pop as the
                         * delay-slot filler. If PR is the only pop,
                         * fall through to a body line or nop. */
                        if (need_fp)
                                print("\tmov\tr14,r15\n");
                        else if (sh_sp_locals_only && localsize > 0)
                                print("\tadd\t#%d,r15\n", localsize);
                        if (sh_gbr_param)
                                print("\tldc.l\t@r15+,gbr\n");
                        if (sh_uses_macl)
                                print("\tlds.l\t@r15+,macl\n");
                        for (i = 0; i < npops; i++) {
                                if (i == last_reg_pop)
                                        continue;
                                if (pop_regs[i] == -1)
                                        print("\tlds.l\t@r15+,pr\n");
                                else
                                        print("\tmov.l\t@r15+,r%d\n",
                                              pop_regs[i]);
                        }
                        print("\trts\n");
                        if (last_reg_pop >= 0)
                                print("\tmov.l\t@r15+,r%d\n",
                                      pop_regs[last_reg_pop]);
                        else if (delay_idx >= 0)
                                fputs(sh_lines[delay_idx], stdout);
                        else
                                print("\tnop\n");
                } else if (!sh_all_returns_inlined) {
                        print("\trts\n");
                        if (delay_idx >= 0)
                                fputs(sh_lines[delay_idx], stdout);
                        else
                                print("\tnop\n");
                }
        }
        shlit_flush();
        sh_gbr_param = 0;
        sh_word_indexed_after_first = 0;
        /* Restore allocator masks in case noregalloc narrowed them. */
        tmask[IREG] = saved_tmask;
        vmask[IREG] = saved_vmask;
        /* Restore wildcard priority slots in case sh_alloc_lowfirst
         * swapped them. */
        for (i = 0; i < 7; i++)
                ireg_prio[21 + i] = saved_intvar_prio[i];
        /* Phase E: clear the current-entry pointer. Leaving it set
         * would leak our IPA pin into the next function's target()
         * calls via sh_ipa_current->pinned_param. */
        sh_ipa_current = NULL;
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
        /* Function exports are emitted by sh_process_deferred_fn at
         * drain time so .global stays adjacent to the function body
         * (matches A.0 layout). Non-function exports (data globals)
         * emit immediately — they're not deferred. */
        if (p->type && isfunc(p->type))
                return;
        print("\t.global %s\n", p->x.name);
}

static void import(Symbol p) {}

static void defsymbol(Symbol p) {
        /* Hitachi SHC didn't prepend a leading underscore to C
         * identifiers (unlike a.out / Mach-O conventions). For
         * the unity-build bring-in this matters: shim .c files
         * carry prod assembly verbatim, where `bsr FUN_X` and
         * `bra FUN_X` reference bare names. If we mangled to
         * _FUN_X here, every cross-TU branch would fail to
         * resolve. Match prod's convention — bare names. */
        if (p->scope >= LOCAL && p->sclass == STATIC)
                p->x.name = stringf("L%d", genlabel(1));
        else if (p->generated)
                p->x.name = stringf("L%s", p->name);
        else if (p->scope == CONSTANTS)
                p->x.name = p->name;
        else
                p->x.name = p->name;
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
        /* Suppress .text emission during parse — it would sit before
         * the deferred function body instead of adjacent to it. The
         * drain calls segment(CODE) itself for the first function so
         * .text ends up right between .global and body, matching A.0.
         * Still update cseg so subsequent in-parse segment() calls see
         * the correct current section (keeps our cseg in sync with
         * init.c's curseg, which swtoseg updates unconditionally). */
        if (n == CODE && !sh_ipa_in_drain) {
                cseg = n;
                return;
        }
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
        sh_switchjump,
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
                sh_prealloc_mask,
                1,  /* retain_func_arena: IPA Phase A.0 — keeps FUNC
                     * arena alive across functions so the defer queue
                     * can still reach Code lists at progend drain. */
                sh_parse_asm_text,  /* parse_asm: Stage 2 of asm-shim
                     * — see saturn/workstreams/asm_shim_design.md §5. */
        }
};
