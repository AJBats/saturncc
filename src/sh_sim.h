/* sh_sim.h — small symbolic simulator for the SH-2 backend.
 *
 * Two roles in one header:
 *
 *   1. Shared types for the parsed-asm IR. The asm-shim parser in
 *      sh.md produces sh_asm_body / sh_asm_insn records. Both the
 *      backend (sh.md) and the simulator (sh_sim.c) operate on
 *      those records, so the type definitions live here so they
 *      have a single source of truth.
 *
 *   2. Public API of the simulator. The simulator answers questions
 *      of the form "starting from this entry point, does the
 *      register state at every rts satisfy property P?" by walking
 *      the parsed instructions while tracking each register's
 *      symbolic value (constant | input_reg + offset | unknown).
 *      Today only one query is implemented: "does this entry
 *      preserve r4?" (sh_sim_preserves_r4). Future cross-function
 *      analyses (clobber narrowing for r5/r6/r7, mach/macl tracking,
 *      gbr preservation) plug in as additional queries reusing the
 *      same walker.
 *
 * Reference: saturn/workstreams/asm_shim_design.md describes the
 * parsed-asm IR pipeline. The simulator is the next step beyond
 * "Phase A walks the writes mask once" — it tracks net effect
 * across rts boundaries via abstract interpretation with widening,
 * the standard recipe used by Boomerang / SPARTA / Crab / IKOS for
 * the same class of problem.
 */

#ifndef SH_SIM_H
#define SH_SIM_H

/* ── Operand and instruction shapes (parsed by sh.md, consumed by
 * sh_sim.c and the rest of the SH backend). ───────────────────── */

enum sh_operand_kind {
        SH_OP_NONE = 0,
        SH_OP_REG,        /* r0..r15 */
        SH_OP_SREG,       /* pr, gbr, vbr, sr, mach, macl, t */
        SH_OP_IMM,        /* #imm or bare number (directive arg) */
        SH_OP_MEM,        /* @rN family — see sh_mem_mode */
        SH_OP_LABEL       /* bare identifier — branch target, pool sym */
};

enum sh_mem_mode {
        SH_MEM_NONE = 0,
        SH_MEM_INDIR,     /* @rN */
        SH_MEM_PREDEC,    /* @-rN */
        SH_MEM_POSTINC,   /* @rN+ */
        SH_MEM_DISP,      /* @(disp,rN) */
        SH_MEM_R0IDX,     /* @(R0,rN) */
        SH_MEM_GBRDISP,   /* @(disp,GBR) */
        SH_MEM_PCDISP     /* @(disp,PC) */
};

enum sh_sreg_id {
        SH_SR_PR = 0, SH_SR_GBR, SH_SR_VBR, SH_SR_SR,
        SH_SR_MACH, SH_SR_MACL, SH_SR_T,
        SH_SR_COUNT
};

struct sh_operand {
        enum sh_operand_kind kind;
        int reg;                  /* SH_OP_REG, SH_OP_MEM: base/only reg */
        enum sh_sreg_id sreg;     /* SH_OP_SREG */
        long imm;                 /* SH_OP_IMM, SH_OP_MEM disp */
        char *label;              /* SH_OP_LABEL: stringn'd; also for
                                   *   #LABEL imm */
        enum sh_mem_mode mem_mode;
};

struct sh_asm_insn {
        char *src_text;       /* original line for diagnostics; emit
                               * does not read this in Stage 2+. */
        char *mnemonic;       /* canonicalized; NULL on parse failure.
                               * For is_label && !is_directive: the
                               * label name. For is_directive (with or
                               * without is_label): the directive name
                               * (e.g. ".long"). When both are set on
                               * a combined-line record (`LABEL:
                               * .directive`), mnemonic carries the
                               * directive — use `label_name` for the
                               * label. */
        char *label_name;     /* set whenever is_label is set; carries
                               * the label name uniformly across both
                               * standalone-label and combined-label
                               * forms. Naming-based passes (e.g.
                               * sh_compute_pool_alignment) consult
                               * this; the existing combined-line emit
                               * path prints from src_text verbatim
                               * and so doesn't need it. */
        int n_operands;
        struct sh_operand operands[3];

        unsigned reads;       /* GP regs read (bit N = rN) */
        unsigned writes;      /* GP regs written */
        unsigned reads_sreg;  /* bitmask indexed by enum sh_sreg_id */
        unsigned writes_sreg;
        unsigned char is_branch;
        unsigned char is_call;
        unsigned char is_directive;
        unsigned char is_label;
        unsigned char is_comment;
        unsigned char is_unknown;
        unsigned char is_entry;   /* `.asm_entry FUN_X` — declares an
                                   * additional entry point inside an
                                   * asm body. Emit expands this to
                                   * `.global FUN_X` + `FUN_X:`. Phase
                                   * A treats it as the start of a
                                   * separately-analyzable sub-entry
                                   * for preserves-r4 inference. The
                                   * entry-target name lives in
                                   * operands[0].label. */
        unsigned char pool_align; /* set by sh_compute_pool_alignment.
                                   * 0 = nothing emitted; 4 = emit
                                   * `.balign 4` (label is `.L_pool_*`
                                   * convention — mov.l target needs
                                   * 4-align); 2 = emit `.balign 2`
                                   * (label is `.L_wpool_*` convention
                                   * — mov.w target needs 2-align).
                                   * Naming-based trigger; structural
                                   * lookahead was tried (sha 9c7cc50)
                                   * and reverted — over-fired on
                                   * `.L_wpool_*` and on non-pool
                                   * labels that happened to precede
                                   * data directives, breaking
                                   * displacement budgets. */
        int line_no;
};

struct sh_asm_body {
        struct sh_asm_insn *insns;
        int n_insns;
        int n_capacity;
        char *raw_text;
};

/* ── Simulator public API. ────────────────────────────────────── */

/* Result of a preserves-X query. */
enum sh_sim_verdict {
        SH_SIM_PRESERVES = 1,  /* every reachable rts has X = X_entry */
        SH_SIM_WRITES = 0,     /* at least one rts has X != X_entry, or
                                * the analysis couldn't prove preservation
                                * (conservative). */
};

/* Callback the simulator uses to answer "does this called function
 * preserve r4?" — populated by Phase A's already-cached answer for
 * functions in the IPA queue. The callback receives the bare symbol
 * name (no underscore prefix) referenced by a bsr/jsr instruction
 * and returns SH_SIM_PRESERVES or SH_SIM_WRITES. NULL is permitted
 * and treated as SH_SIM_WRITES (conservative).
 *
 * The simulator never calls back recursively for the function it's
 * currently analyzing — Phase C drives walk order so this query
 * always has a cached answer for already-analyzed callees. */
typedef enum sh_sim_verdict (*sh_sim_callee_lookup)(const char *name,
                                                    void *user);

/* Simulate forward from `start` (an index into the insns array)
 * and return whether r4 at every reachable rts equals r4 at entry.
 *
 * `insns`       — array of pointers to parsed instructions in the
 *                 order they appear in the source. Pointers (not
 *                 inline records) so callers can assemble the array
 *                 from any source — a sh_asm_body's `insns[]`, an
 *                 IPA queue entry's Code list, etc. — without
 *                 copying the records themselves.
 * `n_insns`     — length of the array.
 * `start`       — index of the first instruction to execute. For a
 *                 whole-body analysis pass 0; for an asm_entry sub-
 *                 entry pass the instruction index immediately after
 *                 the asm_entry directive.
 * `lookup`      — callee preserves-r4 oracle (see typedef above).
 * `user`        — opaque pointer passed back to the lookup callback.
 *
 * Returns SH_SIM_PRESERVES iff the simulator was able to prove every
 * reachable rts exits with r4 holding its entry value AND no widened
 * "unknown" intervened between entry and any rts. SH_SIM_WRITES on
 * any of: a write to r4 that the simulator can't track precisely,
 * a call to a callee whose lookup returned WRITES, a loop that
 * doesn't match the recognized SHC dt-loop idiom, or a state-space
 * blow-up beyond the simulator's cap. */
enum sh_sim_verdict sh_sim_preserves_r4(struct sh_asm_insn **insns,
                                        int n_insns,
                                        int start,
                                        sh_sim_callee_lookup lookup,
                                        void *user);

/* Convenience: run sh_sim_preserves_r4 on every instruction of a
 * sh_asm_body starting at index 0. Used by -d-sim and by the
 * whole-function-asm-body case in Phase A. */
enum sh_sim_verdict sh_sim_preserves_r4_body(struct sh_asm_body *body,
                                             sh_sim_callee_lookup lookup,
                                             void *user);

/* Sub-entry visitor: invoke `cb` once per `.asm_entry FUN_X`
 * directive in the body, passing the entry's symbol name and the
 * preserves-r4 verdict computed by simulating from that entry's
 * position. Used by Phase A to compute writes_r4 for sub-entries
 * the linker exports via PROVIDE chains.
 *
 * The visitor does NOT visit the body's primary entry (index 0) —
 * that's the caller's responsibility via sh_sim_preserves_r4_body.
 *
 * Return 0 from the callback to stop iteration; non-zero to
 * continue. */
typedef int (*sh_sim_entry_visitor)(const char *entry_name,
                                    enum sh_sim_verdict v,
                                    void *user);

void sh_sim_visit_entries(struct sh_asm_body *body,
                          sh_sim_callee_lookup lookup,
                          void *lookup_user,
                          sh_sim_entry_visitor visit,
                          void *visit_user);

#endif /* SH_SIM_H */
