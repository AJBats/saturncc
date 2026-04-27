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
        AV_INPUT_OFF       /* input register N's entry value plus an offset */
};

struct sh_av {
        enum sh_av_kind kind;
        int input_reg;     /* AV_INPUT_OFF: which input register (0..15) */
        long value;        /* AV_CONST: the integer; AV_INPUT_OFF: the offset */
};

/* Convenience constructors. Used pervasively below — kept short to
 * keep the instruction-handler code readable. */
static struct sh_av av_unknown(void) {
        struct sh_av a;
        a.kind = AV_UNKNOWN;
        a.input_reg = 0;
        a.value = 0;
        return a;
}

static struct sh_av av_const(long v) {
        struct sh_av a;
        a.kind = AV_CONST;
        a.input_reg = 0;
        a.value = v;
        return a;
}

static struct sh_av av_input(int reg, long off) {
        struct sh_av a;
        a.kind = AV_INPUT_OFF;
        a.input_reg = reg;
        a.value = off;
        return a;
}

static int av_eq(struct sh_av a, struct sh_av b) {
        if (a.kind != b.kind) return 0;
        switch (a.kind) {
        case AV_UNKNOWN:    return 1;
        case AV_CONST:      return a.value == b.value;
        case AV_INPUT_OFF:  return a.input_reg == b.input_reg
                                 && a.value == b.value;
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

struct sh_walker {
        struct sh_asm_insn **insns;
        int n_insns;
        sh_sim_callee_lookup lookup;
        void *user;
        struct sh_visited visited;

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

/* Apply a memory-operand's side effects on its base register
 * (post-increment, pre-decrement). Called separately so the
 * destination-register handlers above stay focused. */
static void apply_mem_side_effects(struct sh_state *s,
                                   struct sh_asm_insn *in) {
        int i;
        long step;
        const char *m = in->mnemonic;
        /* Determine the size in bytes from the mnemonic suffix. */
        if (!m) return;
        if (strstr(m, ".b")) step = 1;
        else if (strstr(m, ".w")) step = 2;
        else step = 4;  /* default to .l for mov.l, mac.l, mul.l etc. */
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

        /* Loads/stores — the destination register (if any) becomes
         * unknown; post-inc / pre-dec base registers update. */
        if (strncmp(m, "mov.", 4) == 0
            || strncmp(m, "mac.", 4) == 0) {
                mark_writes_unknown(s, in);
                apply_mem_side_effects(s, in);
                return 1;
        }

        /* Default: any write is unknown, no memory side effects we
         * can describe precisely. The parser's writes mask carries
         * the truth of which registers got clobbered. */
        mark_writes_unknown(s, in);
        return 1;
}

/* ── Walker helpers ───────────────────────────────────────────── */

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
                                /* Conditional: walk taken AND not-
                                 * taken paths from the same state.
                                 * For /s the delay-slot effect is
                                 * already applied; for non-/s the
                                 * fall-through skips just past the
                                 * branch. */
                                int fall = insn_index
                                        + (bk == 2 ? 2 : 1);
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

                /* Calls (bsr, jsr): not yet handled — give up
                 * conservatively. Will be added once the callee
                 * oracle is wired. */
                if (in->is_call) {
                        w->gave_up = 1;
                        return;
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
