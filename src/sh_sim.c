/* sh_sim.c — symbolic simulator for the SH-2 backend.
 *
 * Walks the parsed instructions of a function, tracking each
 * register's value as one of:
 *   - a constant integer,
 *   - input register N plus a constant offset, or
 *   - unknown.
 *
 * Used to answer questions like "does this function preserve r4
 * across all rts paths?" without having to pattern-match every
 * SHC idiom by hand.
 *
 * Approach (textbook abstract interpretation, sized to our corpus):
 *   - Forward walk of the instructions starting at a given index.
 *   - Each instruction updates the abstract register state per its
 *     known semantics. Unrecognized writes mark the destination
 *     unknown.
 *   - At conditional branches, both paths are walked. State at
 *     join points is merged: registers agreeing across paths keep
 *     their value, otherwise become unknown.
 *   - Loops terminate via a visited-set keyed on (instruction
 *     index, register-state hash). On revisit, the loop has
 *     converged for that path.
 *   - When the visited-set grows past a cap, or when re-entering
 *     a state with a different abstract value, widen to unknown
 *     to guarantee termination.
 *   - Calls (bsr/jsr) consult an external oracle: caller tells us
 *     whether the target preserves r4. If preserved, abstract
 *     state survives the call (other caller-saves are clobbered);
 *     if not, r4 becomes unknown (along with normal caller-saves).
 *   - At each rts encountered, record r4's abstract value.
 *
 * Reports SH_SIM_PRESERVES iff every recorded rts has r4 = (input
 * r4 + 0). Otherwise SH_SIM_WRITES.
 *
 * Reference: saturn/workstreams/asm_shim_design.md and the
 * 2026-04-27 design conversation. Same shape Boomerang / SPARTA /
 * Crab use; targeted at our corpus rather than general-purpose.
 */

#include "sh_sim.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ── Abstract value model ─────────────────────────────────────── */

enum sh_av_kind {
        AV_UNKNOWN = 0,    /* anything could be here */
        AV_CONST,          /* a literal integer */
        AV_INPUT_OFF,      /* input register N's entry value plus an offset */
        AV_FUNCADDR        /* address of a named function symbol —
                            * produced by a `mov.l <pool>, rN` whose
                            * pool entry resolves to a function. Used
                            * by the call handler to figure out which
                            * function `jsr @rN` is calling. */
};

struct sh_av {
        enum sh_av_kind kind;
        int input_reg;     /* AV_INPUT_OFF: which input register (0..15) */
        long value;        /* AV_CONST: the integer; AV_INPUT_OFF: the offset */
        const char *symbol;/* AV_FUNCADDR: the function symbol name */
};

/* Convenience constructors. Used pervasively below — kept short to
 * keep the instruction-handler code readable. */
static struct sh_av av_unknown(void) {
        struct sh_av a;
        a.kind = AV_UNKNOWN;
        a.input_reg = 0;
        a.value = 0;
        a.symbol = NULL;
        return a;
}

static struct sh_av av_const(long v) {
        struct sh_av a;
        a.kind = AV_CONST;
        a.input_reg = 0;
        a.value = v;
        a.symbol = NULL;
        return a;
}

static struct sh_av av_input(int reg, long off) {
        struct sh_av a;
        a.kind = AV_INPUT_OFF;
        a.input_reg = reg;
        a.value = off;
        a.symbol = NULL;
        return a;
}

static struct sh_av av_funcaddr(const char *sym) {
        struct sh_av a;
        a.kind = AV_FUNCADDR;
        a.input_reg = 0;
        a.value = 0;
        a.symbol = sym;
        return a;
}

static int str_eq(const char *a, const char *b) {
        if (a == b) return 1;
        if (!a || !b) return 0;
        return strcmp(a, b) == 0;
}

static int av_eq(struct sh_av a, struct sh_av b) {
        if (a.kind != b.kind) return 0;
        switch (a.kind) {
        case AV_UNKNOWN:    return 1;
        case AV_CONST:      return a.value == b.value;
        case AV_INPUT_OFF:  return a.input_reg == b.input_reg
                                 && a.value == b.value;
        case AV_FUNCADDR:   return str_eq(a.symbol, b.symbol);
        }
        return 0;
}

/* Merge (the "join" in the literature): when two analysis paths
 * meet, each register takes the value both paths agree on, else
 * unknown. */
static struct sh_av av_meet(struct sh_av a, struct sh_av b) {
        if (av_eq(a, b)) return a;
        return av_unknown();
}

/* ── Register-file abstract state ─────────────────────────────── */

#define SH_SIM_NREGS 16

struct sh_state {
        struct sh_av r[SH_SIM_NREGS];
};

static struct sh_state state_entry(void) {
        struct sh_state s;
        int i;
        /* Each input register's entry value is itself with offset 0.
         * After execution we'll check r4 against this baseline. */
        for (i = 0; i < SH_SIM_NREGS; i++)
                s.r[i] = av_input(i, 0);
        return s;
}

static int state_eq(const struct sh_state *a, const struct sh_state *b) {
        int i;
        for (i = 0; i < SH_SIM_NREGS; i++)
                if (!av_eq(a->r[i], b->r[i]))
                        return 0;
        return 1;
}

static struct sh_state state_meet(const struct sh_state *a,
                                  const struct sh_state *b) {
        struct sh_state out;
        int i;
        for (i = 0; i < SH_SIM_NREGS; i++)
                out.r[i] = av_meet(a->r[i], b->r[i]);
        return out;
}

/* ── Visited set — guards termination on loops and bounds the
 * search. (insn_index, state) pairs we've already analyzed are
 * not re-walked. The cap is a hard ceiling; on overflow the
 * simulator widens to unknown and returns the conservative
 * verdict. ───────────────────────────────────────────────────── */

#define SH_SIM_VISITED_CAP 4096

struct sh_visited_entry {
        int insn;
        struct sh_state state;
};

struct sh_visited {
        struct sh_visited_entry entries[SH_SIM_VISITED_CAP];
        int n;
        int overflowed;
};

static int visited_seen(struct sh_visited *v, int insn,
                        const struct sh_state *state) {
        int i;
        for (i = 0; i < v->n; i++)
                if (v->entries[i].insn == insn
                    && state_eq(&v->entries[i].state, state))
                        return 1;
        return 0;
}

static void visited_add(struct sh_visited *v, int insn,
                        const struct sh_state *state) {
        if (v->n >= SH_SIM_VISITED_CAP) {
                v->overflowed = 1;
                return;
        }
        v->entries[v->n].insn = insn;
        v->entries[v->n].state = *state;
        v->n++;
}

/* ── Walker context ───────────────────────────────────────────── */

/* Per-label first-visit state tracker. Used by the loop recognizer:
 * when we hit a backward branch, the loop's entry state is the
 * state we observed the FIRST time we walked through the loop's
 * top label. Subtracting that from the state at the branch gives
 * us per-iteration deltas — and a register that decremented by
 * exactly 1 is the SHC dt-loop counter. */
#define SH_SIM_LABELSTATE_CAP 512

struct sh_label_state {
        int insn;
        struct sh_state state;
};

struct sh_walker {
        struct sh_asm_insn **insns;
        int n_insns;
        sh_sim_callee_lookup lookup;
        void *user;
        struct sh_visited visited;

        struct sh_label_state label_states[SH_SIM_LABELSTATE_CAP];
        int n_label_states;

        /* rts exits we've reached, expressed as r4's abstract value
         * at the rts. The verdict at the end is the meet of all
         * these (must equal the entry r4). */
        int n_rts;
        struct sh_av rts_r4_values[256];

        /* Set when the simulator gives up — too many states, an
         * unrecognized branch shape, or any other path that can't
         * be analyzed safely. Forces the verdict to WRITES. */
        int gave_up;
};

/* Forward decl for mutual recursion within the walker. */
static void walk(struct sh_walker *w, int insn_index,
                 struct sh_state state);

/* ── Per-instruction effect ───────────────────────────────────── */

/* `mov rA, rB` — destination takes source's abstract value. */
static int handle_reg_mov(struct sh_state *s, struct sh_asm_insn *in) {
        if (in->n_operands != 2) return 0;
        if (in->operands[0].kind != SH_OP_REG) return 0;
        if (in->operands[1].kind != SH_OP_REG) return 0;
        s->r[in->operands[1].reg] = s->r[in->operands[0].reg];
        return 1;
}

/* `add #imm, rN` — if rN currently has a known value (constant or
 * input+offset), update it; otherwise stays unknown. */
static int handle_add_imm(struct sh_state *s, struct sh_asm_insn *in) {
        int dest;
        long imm;
        if (in->n_operands != 2) return 0;
        if (in->operands[0].kind != SH_OP_IMM) return 0;
        if (in->operands[1].kind != SH_OP_REG) return 0;
        dest = in->operands[1].reg;
        imm = in->operands[0].imm;
        switch (s->r[dest].kind) {
        case AV_CONST:
                s->r[dest].value += imm;
                break;
        case AV_INPUT_OFF:
                s->r[dest].value += imm;
                break;
        case AV_UNKNOWN:
                break;
        }
        return 1;
}

/* `mov #imm, rN` — destination becomes a known constant. */
static int handle_mov_imm(struct sh_state *s, struct sh_asm_insn *in) {
        int dest;
        if (in->n_operands != 2) return 0;
        if (in->operands[0].kind != SH_OP_IMM) return 0;
        if (in->operands[1].kind != SH_OP_REG) return 0;
        dest = in->operands[1].reg;
        s->r[dest] = av_const(in->operands[0].imm);
        return 1;
}

/* Given the parsed `writes` mask, mark all written registers as
 * unknown. Used as a fallback when no specific handler applies. */
static void mark_writes_unknown(struct sh_state *s, struct sh_asm_insn *in) {
        unsigned mask = in->writes;
        int i;
        for (i = 0; i < SH_SIM_NREGS; i++)
                if (mask & (1u << i))
                        s->r[i] = av_unknown();
}

/* Compute the size in bytes implied by a mov/mac mnemonic suffix. */
static long sized_step(const char *m) {
        if (!m) return 4;
        if (strstr(m, ".b")) return 1;
        if (strstr(m, ".w")) return 2;
        return 4; /* .l default */
}

/* Apply a memory-operand's side effects on its base register
 * (post-increment, pre-decrement). The base reg's abstract value
 * advances by ±size; if it was already unknown, it stays unknown.
 *
 * Used by the mov.X / mac.X handler. The handler also marks any
 * load-destination register unknown — base-reg post-inc/pre-dec
 * is the *precisely trackable* side effect; the loaded value
 * coming from memory is what we don't track. */
static void apply_mem_side_effects(struct sh_state *s,
                                   struct sh_asm_insn *in) {
        long step = sized_step(in->mnemonic);
        int i;
        for (i = 0; i < in->n_operands; i++) {
                struct sh_operand *op = &in->operands[i];
                if (op->kind != SH_OP_MEM) continue;
                if (op->mem_mode == SH_MEM_POSTINC) {
                        struct sh_av *base = &s->r[op->reg];
                        if (base->kind != AV_UNKNOWN)
                                base->value += step;
                } else if (op->mem_mode == SH_MEM_PREDEC) {
                        struct sh_av *base = &s->r[op->reg];
                        if (base->kind != AV_UNKNOWN)
                                base->value -= step;
                }
        }
}

/* Memory-form mov.X / mac.X handler. Only the load-destination
 * register goes unknown; base registers with post-inc / pre-dec
 * update precisely. Returns 1 always (handled). */
static int handle_mem_op(struct sh_state *s, struct sh_asm_insn *in) {
        int i;
        /* Phase 1: precise side-effects on base regs. Done first so
         * the post-inc/pre-dec deltas are not lost if a destination
         * mark below races with a base mark. */
        apply_mem_side_effects(s, in);
        /* Phase 2: any operand that's a REG appearing as the load
         * destination becomes unknown. We approximate: if both a
         * MEM and a REG operand are present, the REG operand is
         * either the source (store) or the destination (load).
         * Stores don't change a GP reg; loads change the REG.
         *
         * Heuristic: in SH-2 syntax `mov.X mem, dst` has MEM as
         * operand 0 and REG as operand 1 → load. `mov.X src, mem`
         * has REG as operand 0 and MEM as operand 1 → store. So
         * REG-as-operand[1] with MEM-as-operand[0] = load
         * destination.
         *
         * mac.X has both operands as MEM and writes only mach/macl
         * (sregs we don't track) — no GP destination to mark. */
        if (in->n_operands >= 2
            && in->operands[0].kind == SH_OP_MEM
            && in->operands[1].kind == SH_OP_REG) {
                s->r[in->operands[1].reg] = av_unknown();
        }
        /* Defensive: if the parser also flagged any other GP write
         * we haven't accounted for, propagate it. (E.g., mov.X with
         * a third operand or other oddity.) Skip the base regs we
         * just updated precisely. */
        for (i = 0; i < SH_SIM_NREGS; i++) {
                int is_base = 0;
                int j;
                if (!(in->writes & (1u << i))) continue;
                for (j = 0; j < in->n_operands; j++)
                        if (in->operands[j].kind == SH_OP_MEM
                            && in->operands[j].reg == i
                            && (in->operands[j].mem_mode == SH_MEM_POSTINC
                                || in->operands[j].mem_mode
                                   == SH_MEM_PREDEC)) {
                                is_base = 1;
                                break;
                        }
                if (is_base) continue;
                if (in->n_operands >= 2
                    && in->operands[1].kind == SH_OP_REG
                    && in->operands[1].reg == i
                    && in->operands[0].kind == SH_OP_MEM)
                        continue; /* already marked above */
                s->r[i] = av_unknown();
        }
        return 1;
}

/* `dt rN` — decrement rN by 1, set T flag. Tracked precisely so
 * the dt-loop recognizer can spot a counter going N → N-1. T-flag
 * tracking is out of scope for now (the recognizer infers loop
 * structure from the back-edge shape, not from T). */
static int handle_dt(struct sh_state *s, struct sh_asm_insn *in) {
        int dest;
        if (in->n_operands != 1) return 0;
        if (in->operands[0].kind != SH_OP_REG) return 0;
        dest = in->operands[0].reg;
        switch (s->r[dest].kind) {
        case AV_CONST:      s->r[dest].value -= 1; break;
        case AV_INPUT_OFF:  s->r[dest].value -= 1; break;
        case AV_UNKNOWN:    break;
        }
        return 1;
}

/* Master per-instruction transfer function. Returns 0 if the
 * instruction is recognized as something that can ONLY be handled
 * conservatively (e.g., it touches r4 in a way the simulator
 * can't track exactly); the walker turns that into a "writes"
 * verdict via mark_writes_unknown.
 *
 * Returns 1 if handled (precisely or conservatively); the state
 * has been updated. */
static int interpret(struct sh_state *s, struct sh_asm_insn *in) {
        const char *m = in->mnemonic;

        /* Comments, labels, directives — no register effect. */
        if (in->is_comment || in->is_label || in->is_directive)
                return 1;

        if (in->is_unknown || !m) {
                /* Parser couldn't classify; conservatively unknown
                 * for everything it claims to write. */
                mark_writes_unknown(s, in);
                return 1;
        }

        /* Instruction-specific handlers. */
        if (strcmp(m, "mov") == 0) {
                if (in->n_operands == 2
                    && in->operands[0].kind == SH_OP_REG
                    && in->operands[1].kind == SH_OP_REG) {
                        handle_reg_mov(s, in);
                        return 1;
                }
                if (in->n_operands == 2
                    && in->operands[0].kind == SH_OP_IMM
                    && in->operands[1].kind == SH_OP_REG) {
                        handle_mov_imm(s, in);
                        return 1;
                }
        }

        if (strcmp(m, "add") == 0
            && in->n_operands == 2
            && in->operands[0].kind == SH_OP_IMM
            && in->operands[1].kind == SH_OP_REG) {
                handle_add_imm(s, in);
                return 1;
        }

        if (strcmp(m, "dt") == 0)
                if (handle_dt(s, in))
                        return 1;

        /* Loads/stores — destination unknown; post-inc/pre-dec
         * base registers update precisely. Special-cased: a
         * `mov.l <label>, rN` whose label resolves to a function
         * symbol via the literal pool produces an AV_FUNCADDR in
         * rN, so a later `jsr @rN` can name its callee. */
        if (strncmp(m, "mov.", 4) == 0
            || strncmp(m, "mac.", 4) == 0)
                return handle_mem_op(s, in);

        /* Default: any write is unknown, no memory side effects we
         * can describe precisely. The parser's writes mask carries
         * the truth of which registers got clobbered. */
        mark_writes_unknown(s, in);
        return 1;
}

/* Look up / record the first state observed at a given instruction
 * index. Returns 1 if we found an existing entry (state written
 * into *out) or 0 otherwise. */
static int label_state_get(struct sh_walker *w, int insn,
                           struct sh_state *out) {
        int i;
        for (i = 0; i < w->n_label_states; i++)
                if (w->label_states[i].insn == insn) {
                        *out = w->label_states[i].state;
                        return 1;
                }
        return 0;
}

static void label_state_record(struct sh_walker *w, int insn,
                               const struct sh_state *state) {
        if (w->n_label_states >= SH_SIM_LABELSTATE_CAP) {
                w->gave_up = 1;
                return;
        }
        /* First-recorder wins; later visits compare against this. */
        {
                int i;
                for (i = 0; i < w->n_label_states; i++)
                        if (w->label_states[i].insn == insn)
                                return;
        }
        w->label_states[w->n_label_states].insn = insn;
        w->label_states[w->n_label_states].state = *state;
        w->n_label_states++;
}

/* ── Walker helpers ───────────────────────────────────────────── */

/* Resolve a pool-load target. Given a label name (the operand of
 * `mov.l <label>, rN`), find that label's definition in the body
 * and return the function symbol it points to via the next
 * directive (`.4byte FUN_X` or similar).
 *
 * Returns the resolved symbol name (a pointer into the parser's
 * stringn'd storage, valid for the simulator's lifetime) or NULL
 * if the label couldn't be resolved or doesn't point to a single
 * symbolic value. */
static const char *resolve_pool_target(struct sh_asm_insn **insns,
                                       int n_insns,
                                       const char *label_name) {
        int i;
        for (i = 0; i < n_insns; i++) {
                struct sh_asm_insn *in = insns[i];
                int j;
                if (!in->is_label) continue;
                /* Same matching shape as find_label below. */
                if (!((in->mnemonic && strcmp(in->mnemonic, label_name) == 0)
                      || (in->n_operands > 0
                          && in->operands[0].kind == SH_OP_LABEL
                          && in->operands[0].label
                          && strcmp(in->operands[0].label,
                                    label_name) == 0)))
                        continue;
                /* Found the label. Walk forward to the next non-
                 * label instruction; if it's a directive with a
                 * single label operand, that's our target. */
                for (j = i + 1; j < n_insns; j++) {
                        struct sh_asm_insn *next = insns[j];
                        if (next->is_label || next->is_comment)
                                continue;
                        if (next->is_directive
                            && next->n_operands >= 1
                            && next->operands[0].kind == SH_OP_LABEL
                            && next->operands[0].label)
                                return next->operands[0].label;
                        return NULL;
                }
                return NULL;
        }
        return NULL;
}

/* Apply the effect of a call to a callee whose preserves-r4 status
 * has been resolved. The state's caller-save registers (r0-r7
 * minus r4 if preserved) all become unknown. r4 stays unchanged
 * if preserved; otherwise also unknown. r8-r15 are callee-saves
 * by ABI and stay unchanged. */
static void apply_call(struct sh_state *s, enum sh_sim_verdict v) {
        int i;
        for (i = 0; i < 8; i++) {
                if (i == 4 && v == SH_SIM_PRESERVES) continue;
                s->r[i] = av_unknown();
        }
}

/* Find the index of a label in the instruction array. Labels are
 * is_label == 1 and carry their name as the first operand's label
 * field (or the mnemonic, depending on parser shape — try both).
 * Returns -1 if not found. */
static int find_label(struct sh_asm_insn **insns, int n_insns,
                      const char *name) {
        int i;
        if (!name) return -1;
        for (i = 0; i < n_insns; i++) {
                struct sh_asm_insn *in = insns[i];
                if (!in->is_label) continue;
                /* The parser may put the label name in either the
                 * mnemonic or the first operand's label field;
                 * accept both. */
                if (in->mnemonic && strcmp(in->mnemonic, name) == 0)
                        return i;
                if (in->n_operands > 0
                    && in->operands[0].kind == SH_OP_LABEL
                    && in->operands[0].label
                    && strcmp(in->operands[0].label, name) == 0)
                        return i;
        }
        return -1;
}

/* SHC dt-loop recognizer.
 *
 * Hypothesis: the walker just reached a backward branch (target
 * before current insn) and the branch target was visited before
 * with state `entry`. Current state at the branch is `cur`.
 *
 * The SHC idiom we recognize:
 *   mov #N, rK     ! constant initializer somewhere before the loop
 *   loop:
 *     <body that advances some regs by constants>
 *     dt rK        ! decrement counter, set T flag if zero
 *     bf/s loop    ! branch back if T not set (i.e., not yet zero)
 *     <delay slot, runs every iter incl. last>
 *
 * Recognition: between entry and cur, exactly one register's
 * abstract value should have transitioned AV_CONST(N) → AV_CONST(N-1)
 * — that's the loop counter. Other registers may have changed by
 * a constant (the per-iteration delta) or not at all.
 *
 * On success, fills *post with the state after the loop has run
 * its full N iterations: counter = 0, each register that changed
 * by a constant Δ_per_iter advances to entry + N*Δ_per_iter, and
 * any register that's already AV_UNKNOWN stays unknown. Returns 1.
 *
 * On failure (no AV_CONST register decremented by 1, multiple
 * candidates, or per-iter deltas that aren't constant), returns 0.
 * The walker then falls back to giving up the loop conservatively. */
static int try_recognize_dt_loop(const struct sh_state *entry,
                                 const struct sh_state *cur,
                                 struct sh_state *post) {
        int counter_reg = -1;
        long counter_n = 0;
        int i;

        /* Find the counter: a register that went AV_CONST(N) →
         * AV_CONST(N-1) for some N >= 1. */
        for (i = 0; i < SH_SIM_NREGS; i++) {
                if (entry->r[i].kind == AV_CONST
                    && cur->r[i].kind == AV_CONST
                    && entry->r[i].value >= 1
                    && cur->r[i].value == entry->r[i].value - 1) {
                        if (counter_reg != -1)
                                return 0; /* ambiguous — bail */
                        counter_reg = i;
                        counter_n = entry->r[i].value;
                }
        }
        if (counter_reg < 0)
                return 0;

        /* Compute post-loop state. The counter ends at 0; every
         * other register that has a constant-Δ relationship with
         * its entry value advances by N * Δ_per_iter. */
        *post = *cur;
        post->r[counter_reg] = av_const(0);

        for (i = 0; i < SH_SIM_NREGS; i++) {
                struct sh_av e = entry->r[i];
                struct sh_av c = cur->r[i];
                long delta;

                if (i == counter_reg)
                        continue;

                /* If both abstract values are the same kind and
                 * differ only in `value`, treat the difference as
                 * a per-iteration delta. */
                if (e.kind == c.kind
                    && (e.kind == AV_CONST
                        || (e.kind == AV_INPUT_OFF
                            && e.input_reg == c.input_reg))) {
                        delta = c.value - e.value;
                        if (delta == 0) {
                                /* No change — keep entry value
                                 * (== cur value here). */
                                post->r[i] = e;
                        } else {
                                /* The current state already shows
                                 * one iteration's worth of delta.
                                 * Apply (N-1) more on top of cur
                                 * to get the full N iterations'
                                 * effect. */
                                struct sh_av v = c;
                                v.value += (counter_n - 1) * delta;
                                post->r[i] = v;
                        }
                } else {
                        /* Kind/input changed — can't precisely
                         * project. Conservative. */
                        post->r[i] = av_unknown();
                }
        }
        return 1;
}

/* Recognize a branch's mnemonic. Returns one of:
 *   0 — not a branch we handle precisely.
 *   1 — conditional branch (bt, bf), no delay slot.
 *   2 — conditional branch with delay slot (bt/s, bf/s).
 *   3 — unconditional branch (bra) with delay slot.
 *   4 — unconditional branch (bra) without delay slot — none in SH-2;
 *       reserved.
 *
 * `bsr` is a call, handled separately. */
static int classify_branch(const char *m) {
        if (!m) return 0;
        if (strcmp(m, "bt") == 0) return 1;
        if (strcmp(m, "bf") == 0) return 1;
        if (strcmp(m, "bt/s") == 0) return 2;
        if (strcmp(m, "bf/s") == 0) return 2;
        if (strcmp(m, "bra") == 0) return 3;
        if (strcmp(m, "bra/s") == 0) return 3;  /* alias safety */
        return 0;
}

/* ── Walker ───────────────────────────────────────────────────── */

static void record_rts(struct sh_walker *w, struct sh_state *s) {
        if (w->n_rts >= (int)(sizeof w->rts_r4_values
                              / sizeof w->rts_r4_values[0])) {
                w->gave_up = 1;
                return;
        }
        w->rts_r4_values[w->n_rts++] = s->r[4];
}

static void walk(struct sh_walker *w, int insn_index,
                 struct sh_state state) {
        if (w->gave_up) return;

        for (;;) {
                struct sh_asm_insn *in;

                if (insn_index < 0 || insn_index >= w->n_insns) {
                        /* Walked off the end without seeing rts.
                         * Conservative: treat as a non-preserving
                         * exit. */
                        w->gave_up = 1;
                        return;
                }

                if (visited_seen(&w->visited, insn_index, &state))
                        return;
                visited_add(&w->visited, insn_index, &state);
                if (w->visited.overflowed) {
                        w->gave_up = 1;
                        return;
                }
                /* Record the first state observed at this insn —
                 * the loop recognizer needs it as the loop's entry
                 * state when a back-edge later targets here. */
                label_state_record(w, insn_index, &state);
                if (w->gave_up) return;

                in = w->insns[insn_index];

                if (in->is_comment || in->is_label || in->is_directive) {
                        insn_index++;
                        continue;
                }

                /* rts is an exit. Record r4 here, stop the walk.
                 * The instruction after rts is its delay slot —
                 * we handle delay-slot semantics by interpreting
                 * the next instruction THEN recording, since the
                 * delay-slot instruction executes before the
                 * actual return. */
                if (in->mnemonic && strcmp(in->mnemonic, "rts") == 0) {
                        if (insn_index + 1 < w->n_insns) {
                                struct sh_asm_insn *delay =
                                        w->insns[insn_index + 1];
                                interpret(&state, delay);
                        }
                        record_rts(w, &state);
                        return;
                }

                /* Branches: conditional (bt/bf with optional /s
                 * delay slot) walk both paths; unconditional (bra)
                 * jumps with no fall-through.
                 *
                 * Path order: for /s variants the delay-slot
                 * instruction executes BEFORE the branch is taken,
                 * so its effect on the abstract state applies to
                 * both successor paths. */
                if (in->is_branch && !in->is_call) {
                        int bk = classify_branch(in->mnemonic);
                        const char *target_name = NULL;
                        int target_idx = -1;
                        struct sh_state branch_state = state;

                        if (bk == 0) {
                                /* Unrecognized branch shape — give
                                 * up rather than risk a wrong
                                 * verdict. Future: extend
                                 * classify_branch as we hit new
                                 * shapes in the corpus. */
                                w->gave_up = 1;
                                return;
                        }

                        /* Apply delay slot if this is a /s variant
                         * or unconditional. In SH-2, delay-slot
                         * instructions run regardless of whether
                         * the branch is taken; the value lands in
                         * the state both successors observe. */
                        if (bk == 2 || bk == 3 || bk == 4) {
                                if (insn_index + 1 < w->n_insns) {
                                        struct sh_asm_insn *delay =
                                                w->insns[insn_index + 1];
                                        interpret(&branch_state, delay);
                                }
                        }

                        /* Resolve branch target. */
                        if (in->n_operands > 0
                            && in->operands[0].kind == SH_OP_LABEL
                            && in->operands[0].label) {
                                target_name = in->operands[0].label;
                                target_idx = find_label(w->insns,
                                                        w->n_insns,
                                                        target_name);
                        }
                        if (target_idx < 0) {
                                /* Couldn't resolve label — bail. */
                                w->gave_up = 1;
                                return;
                        }

                        if (bk == 1 || bk == 2) {
                                /* Conditional. If this is a
                                 * backward branch that loops back
                                 * to a previously-visited label,
                                 * try the SHC dt-loop recognizer:
                                 * project the loop's full effect
                                 * onto the fall-through state and
                                 * skip re-walking. Otherwise,
                                 * conventional: walk both paths. */
                                int fall = insn_index
                                        + (bk == 2 ? 2 : 1);
                                if (target_idx < insn_index) {
                                        struct sh_state entry_at_loop;
                                        struct sh_state post;
                                        if (label_state_get(w, target_idx,
                                                            &entry_at_loop)
                                            && try_recognize_dt_loop(
                                                    &entry_at_loop,
                                                    &branch_state,
                                                    &post)) {
                                                /* Recognized. The
                                                 * not-taken path
                                                 * (fall-through)
                                                 * with the projected
                                                 * post-loop state
                                                 * is the only
                                                 * successor we need
                                                 * to analyze: when
                                                 * the loop exits,
                                                 * control proceeds
                                                 * to `fall`. */
                                                walk(w, fall, post);
                                                return;
                                        }
                                }
                                walk(w, target_idx, branch_state);
                                walk(w, fall, branch_state);
                                return;
                        }
                        if (bk == 3 || bk == 4) {
                                /* Unconditional: only the taken
                                 * path. */
                                walk(w, target_idx, branch_state);
                                return;
                        }
                }

                /* Calls (bsr, jsr) — figure out the callee, ask the
                 * oracle whether it preserves r4, apply the call's
                 * effect on caller-saves, and continue past the
                 * delay slot. */
                if (in->is_call) {
                        const char *callee_name = NULL;
                        struct sh_state call_state = state;

                        /* Apply delay slot first; SH-2 calls have a
                         * delay slot whose effects materialize
                         * before the call returns. */
                        if (insn_index + 1 < w->n_insns) {
                                struct sh_asm_insn *delay =
                                        w->insns[insn_index + 1];
                                interpret(&call_state, delay);
                        }

                        /* bsr label / bsr/s label: callee name is
                         * directly in operand[0]. */
                        if (in->mnemonic
                            && (strcmp(in->mnemonic, "bsr") == 0
                                || strcmp(in->mnemonic, "bsr/s") == 0)
                            && in->n_operands > 0
                            && in->operands[0].kind == SH_OP_LABEL) {
                                callee_name = in->operands[0].label;
                        }
                        /* jsr @rN: read rN's abstract value; if it's
                         * AV_FUNCADDR we know the callee. */
                        else if (in->mnemonic
                                 && strcmp(in->mnemonic, "jsr") == 0
                                 && in->n_operands > 0
                                 && in->operands[0].kind == SH_OP_MEM
                                 && in->operands[0].mem_mode
                                    == SH_MEM_INDIR) {
                                int rn = in->operands[0].reg;
                                if (state.r[rn].kind == AV_FUNCADDR)
                                        callee_name =
                                                state.r[rn].symbol;
                        }

                        if (!callee_name) {
                                /* Indirect call we can't resolve.
                                 * Conservative: r4 might or might
                                 * not survive — bail. */
                                w->gave_up = 1;
                                return;
                        }

                        {
                                enum sh_sim_verdict v = SH_SIM_WRITES;
                                if (w->lookup)
                                        v = w->lookup(callee_name,
                                                      w->user);
                                apply_call(&call_state, v);
                        }

                        /* Skip past the call + its delay slot. */
                        state = call_state;
                        insn_index += 2;
                        continue;
                }

                /* Pool-load shape: `mov.l <label>, rN` where the
                 * label points (via a directive) to a function
                 * symbol. Set rN to AV_FUNCADDR so a downstream
                 * `jsr @rN` can name its callee. Falls through to
                 * the normal interpret() if not a pool load. */
                if (in->mnemonic
                    && strcmp(in->mnemonic, "mov.l") == 0
                    && in->n_operands == 2
                    && in->operands[0].kind == SH_OP_LABEL
                    && in->operands[1].kind == SH_OP_REG) {
                        const char *target = resolve_pool_target(
                                w->insns, w->n_insns,
                                in->operands[0].label);
                        if (target) {
                                state.r[in->operands[1].reg] =
                                        av_funcaddr(target);
                                insn_index++;
                                continue;
                        }
                }

                interpret(&state, in);
                insn_index++;
        }
}

/* ── Public entry points ──────────────────────────────────────── */

enum sh_sim_verdict sh_sim_preserves_r4(struct sh_asm_insn **insns,
                                        int n_insns,
                                        int start,
                                        sh_sim_callee_lookup lookup,
                                        void *user)
{
        struct sh_walker w;
        struct sh_state entry;
        int i;

        if (!insns || n_insns <= 0)
                return SH_SIM_WRITES;
        if (start < 0 || start >= n_insns)
                return SH_SIM_WRITES;

        memset(&w, 0, sizeof w);
        w.insns = insns;
        w.n_insns = n_insns;
        w.lookup = lookup;
        w.user = user;

        entry = state_entry();
        walk(&w, start, entry);

        if (w.gave_up || w.n_rts == 0)
                return SH_SIM_WRITES;

        /* Every observed rts must show r4 = input r4 + 0. */
        for (i = 0; i < w.n_rts; i++) {
                struct sh_av v = w.rts_r4_values[i];
                if (v.kind != AV_INPUT_OFF) return SH_SIM_WRITES;
                if (v.input_reg != 4) return SH_SIM_WRITES;
                if (v.value != 0) return SH_SIM_WRITES;
        }
        return SH_SIM_PRESERVES;
}

enum sh_sim_verdict sh_sim_preserves_r4_body(struct sh_asm_body *body,
                                             sh_sim_callee_lookup lookup,
                                             void *user)
{
        /* Build a pointer array on demand. The simulator uses pointers
         * so the same walker code serves both whole-asm-body callers
         * and Code-list callers — see sh_sim.h. */
        struct sh_asm_insn **arr;
        enum sh_sim_verdict v;
        int i;
        if (!body || body->n_insns <= 0)
                return SH_SIM_WRITES;
        arr = (struct sh_asm_insn **)malloc(body->n_insns
                                            * sizeof(*arr));
        if (!arr) return SH_SIM_WRITES;
        for (i = 0; i < body->n_insns; i++)
                arr[i] = &body->insns[i];
        v = sh_sim_preserves_r4(arr, body->n_insns, 0, lookup, user);
        free(arr);
        return v;
}
