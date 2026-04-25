/* $Id$ */

/* Forward decls of the SH-side parsed-asm types. Defined in sh.md.
 * Other backends never construct or consume these; the pointers live
 * here as opaque types so c.h's Xinterface / Xsymbol can carry them.
 * See saturn/workstreams/asm_shim_design.md §5a-§5b. */
struct sh_asm_body;
struct sh_asm_insn;

typedef struct {
	unsigned char max_unaligned_load;
	Symbol (*rmap)(int);

	void (*blkfetch)(int size, int off, int reg, int tmp);
	void (*blkstore)(int size, int off, int reg, int tmp);
	void (*blkloop)(int dreg, int doff,
	                 int sreg, int soff,
	                 int size, int tmps[]);
	void (*_label)(Node);
	int (*_rule)(void*, int);
	short **_nts;
	void (*_kids)(Node, int, Node*);
	char **_string;
	char **_templates;
	char *_isinstruction;
	char **_ntname;
	void (*emit2)(Node);
	void (*doarg)(Node);
	void (*target)(Node);
	void (*clobber)(Node);
	/* prealloc_mask: optional target hook called just before ralloc
	 * picks a register. Receives the symbol being allocated, the
	 * node where allocation happens, and the current availability
	 * mask; returns a possibly-narrowed mask. Backends use this to
	 * encode architecture-specific allocator heuristics that depend
	 * on the symbol's lifetime (e.g. avoid r0 on SH-2 when the
	 * value would live across an r0-clobbering operation). Leave
	 * NULL if the target has no such preferences. */
	unsigned (*prealloc_mask)(Symbol, Node, unsigned);
	/* retain_func_arena: if set, decl.c skips deallocate(FUNC) between
	 * functions. Backends that need per-function state to persist past
	 * IR->function() (e.g. IPA defer queues holding Code linked lists
	 * and Node DAGs) set this. See saturn/workstreams/ipa_design.md. */
	unsigned retain_func_arena:1;
	/* parse_asm: optional backend hook for parsing the captured text
	 * of an `asm { ... }` block into a structured instruction list.
	 * SH fills this in with sh_parse_asm_text; backends without an
	 * asm parser leave it null (the asm body falls back to the
	 * legacy text-blob emit path). expr.c's asm_block() invokes
	 * this hook at tree-build time and stashes the result via
	 * Xsymbol on the ASMB tree node's Symbol. See
	 * saturn/workstreams/asm_shim_design.md §5a. */
	struct sh_asm_body *(*parse_asm)(const char *text);
} Xinterface;
extern int     askregvar(Symbol, Symbol);
extern void    blkcopy(int, int, int, int, int, int[]);
extern unsigned emitasm(Node, int);
extern int     getregnum(Node);
extern int     mayrecalc(Node);
extern int     mkactual(int, int);
extern void    mkauto(Symbol);
extern Symbol  mkreg(char *, int, int, int);
extern Symbol  mkwildcard(Symbol *);
extern int     move(Node);
extern int     notarget(Node);
extern void    parseflags(int, char **);
extern int     range(Node, int, int);
extern unsigned regloc(Symbol);  /* omit */
extern void    rtarget(Node, int, Symbol);
extern void    setreg(Node, Symbol);
extern void    spill(unsigned, int, Node);
extern int     widens(Node);

extern int      argoffset, maxargoffset;
extern int      bflag, dflag;
extern int      dalign, salign;
extern int      framesize;
extern unsigned freemask[], usedmask[];
extern int      offset, maxoffset;
extern int      swap;
extern unsigned tmask[], vmask[];
typedef struct {
	unsigned listed:1;
	unsigned registered:1;
	unsigned emitted:1;
	unsigned copy:1;
	unsigned equatable:1;
	unsigned spills:1;
	unsigned mayrecalc:1;
	void *state;
	short inst;
	Node kids[3];
	Node prev, next;
	Node prevuse;
	short argno;
} Xnode;
typedef struct {
	Symbol vbl;
	short set;
	short number;
	unsigned mask;
} *Regnode;
enum { IREG=0, FREG=1 };
typedef struct {
	char *name;
	unsigned int eaddr;  /* omit */
	int offset;
	Node lastuse;
	int usecount;
	Regnode regnode;
	Symbol *wildcard;
	/* asm_body: parsed `asm { ... }` block attached to the Symbol
	 * that the ASMB tree node carries. Set by expr.c's asm_block()
	 * via the IR->x.parse_asm hook (SH only); listnodes() ASMB
	 * lowering reads it to produce N ASM_INSN Nodes. NULL on
	 * Symbols that aren't asm-block carriers, and on backends that
	 * leave parse_asm null. */
	struct sh_asm_body *asm_body;
	/* asm_insn: per-instruction parsed record attached to the
	 * Symbol on each ASM_INSN+V Node. Read by emit2's ASM_INSN
	 * case to canonically re-format; queried by analysis passes
	 * (Stage 3+) for reads/writes masks. The record's storage
	 * lives in the parent sh_asm_body's insn array; ASM_INSN
	 * Symbols hold a pointer into that array. */
	struct sh_asm_insn *asm_insn;
} Xsymbol;
enum { RX=2 };
typedef struct {
	int offset;
	unsigned freemask[2];
} Env;

#define LBURG_MAX SHRT_MAX

enum { VREG=(44<<4) };

/* Exported for the front end */
extern void             blockbeg(Env *);
extern void             blockend(Env *);
extern void             emit(Node);
extern Node             gen(Node);

extern unsigned         emitbin(Node, int);

#ifdef NDEBUG
#define debug(x) (void)0
#else
#define debug(x) (void)(dflag&&((x),0))
#endif
