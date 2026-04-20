/* $Id$ */
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
