#include "c.h"

static char rcsid[] = "$Id$";

static void pragma(void);
static void resynch(void);

static int bsize;
static unsigned char buffer[MAXLINE+1 + BUFSIZE+1];
unsigned char *cp;	/* current input character */
char *file;		/* current input file name */
char *firstfile;	/* first input file */
unsigned char *limit;	/* points to last character + 1 */
char *line;		/* current line */
int lineno;		/* line number of current line */

/* SaturnCompiler backend hook for unrecognized #pragma directives. */
void (*shc_pragma_hook)(char *name) = 0;

/* Pragmas encountered before shc_pragma_hook is wired (which happens
 * in the backend's progbeg, AFTER main.c reads the first lookahead
 * token) are deferred and replayed on flush_deferred_pragmas(). The
 * original implementation stored only the pragma name, which worked
 * for argument-less pragmas like `#pragma gbr_param` but silently
 * dropped any parenthesized argument list. We now capture the rest
 * of the line verbatim and redirect `cp` into that saved buffer at
 * replay time so the hook's parser sees identical input. */
struct deferred_pragma {
	char *name;
	char *args;   /* rest-of-line after name, null-terminated */
	struct deferred_pragma *next;
};
static struct deferred_pragma *deferred_pragmas;

void nextline(void) {
	do {
		if (cp >= limit) {
			fillbuf();
			if (cp >= limit)
				cp = limit;
			if (cp == limit)
				return;
		} else {
			lineno++;
			for (line = (char *)cp; *cp==' ' || *cp=='\t'; cp++)
				;
			if (*cp == '#') {
				resynch();
				nextline();
			}
		}
	} while (*cp == '\n' && cp == limit);
}
void fillbuf(void) {
	if (bsize == 0)
		return;
	if (cp >= limit)
		cp = &buffer[MAXLINE+1];
	else
		{
			int n = limit - cp;
			unsigned char *s = &buffer[MAXLINE+1] - n;
			assert(s >= buffer);
			line = (char *)s - ((char *)cp - line);
			while (cp < limit)
				*s++ = *cp++;
			cp = &buffer[MAXLINE+1] - n;
		}
	if (feof(stdin))
		bsize = 0;
	else
		bsize = fread(&buffer[MAXLINE+1], 1, BUFSIZE, stdin);
	if (bsize < 0) {
		error("read error\n");
		exit(EXIT_FAILURE);
	}
	limit = &buffer[MAXLINE+1+bsize];
	*limit = '\n';
}
void input_init(int argc, char *argv[]) {
	static int inited;

	if (inited)
		return;
	inited = 1;
	main_init(argc, argv);
	limit = cp = &buffer[MAXLINE+1];
	bsize = -1;
	lineno = 0;
	file = NULL;
	fillbuf();
	if (cp >= limit)
		cp = limit;
	nextline();
}

/* ident - handle #ident "string" */
static void ident(void) {
	while (*cp != '\n' && *cp != '\0')
		cp++;
}

/* pragma - handle #pragma ref id... */
static void pragma(void) {
	if ((t = gettok()) == ID && strcmp(token, "ref") == 0) {
		for (;;) {
			while (*cp == ' ' || *cp == '\t')
				cp++;
			if (*cp == '\n' || *cp == 0)
				break;
			if ((t = gettok()) == ID && tsym) {
				tsym->ref++;
				use(tsym, src);
			}
		}
	} else if (t == ID && shc_pragma_hook) {
		/* Saturn backend pragmas (gbr_base, gbr_param) mutate globals
		 * that codegen consults at function-emit time. A mid-function
		 * pragma would split a function across two pragma states and
		 * silently corrupt output. Reject rather than paper over. */
		if (cfunc) {
			error("#pragma %s must appear at file scope, not inside "
			      "a function body\n", token);
		} else {
			(*shc_pragma_hook)(token);
		}
	} else if (t == ID && !shc_pragma_hook) {
		struct deferred_pragma *e;
		char *start = (char *)cp, *end = start;
		while (*end && *end != '\n')
			end++;
		NEW(e, PERM);
		e->name = string(token);
		e->args = stringn(start, end - start);
		/* Prepended; flush reverses for FIFO replay order. */
		e->next = deferred_pragmas;
		deferred_pragmas = e;
	}
}

void flush_deferred_pragmas(void) {
	struct deferred_pragma *e, *prev = 0, *next;
	unsigned char *saved_cp, *saved_limit;
	if (!shc_pragma_hook)
		return;
	/* Reverse the list so pragmas fire in source order. */
	for (e = deferred_pragmas; e; e = next) {
		next = e->next;
		e->next = prev;
		prev = e;
	}
	deferred_pragmas = prev;
	saved_cp = cp;
	saved_limit = limit;
	for (e = deferred_pragmas; e; e = e->next) {
		cp = (unsigned char *)e->args;
		/* limit must be past the null terminator so the lexer /
		 * pragma parsers won't wander past the saved buffer. */
		limit = cp + strlen(e->args) + 1;
		(*shc_pragma_hook)(e->name);
	}
	cp = saved_cp;
	limit = saved_limit;
	deferred_pragmas = 0;
}

/* resynch - set line number/file name in # n [ "file" ], #pragma, etc. */
static void resynch(void) {
	for (cp++; *cp == ' ' || *cp == '\t'; )
		cp++;
	if (limit - cp < MAXLINE)
		fillbuf();
	if (strncmp((char *)cp, "pragma", 6) == 0) {
		cp += 6;
		pragma();
	} else if (strncmp((char *)cp, "ident", 5) == 0) {
		cp += 5;
		ident();
	} else if (*cp >= '0' && *cp <= '9') {
	line:	for (lineno = 0; *cp >= '0' && *cp <= '9'; )
			lineno = 10*lineno + *cp++ - '0';
		lineno--;
		while (*cp == ' ' || *cp == '\t')
			cp++;
		if (*cp == '"') {
			file = (char *)++cp;
			while (*cp && *cp != '"' && *cp != '\n')
				cp++;
			file = stringn(file, (char *)cp - file);
			if (*cp == '\n')
				warning("missing \" in preprocessor line\n");
			if (firstfile == 0)
				firstfile = file;
		}
	} else if (strncmp((char *)cp, "line", 4) == 0) {
		for (cp += 4; *cp == ' ' || *cp == '\t'; )
			cp++;
		if (*cp >= '0' && *cp <= '9')
			goto line;
		if (Aflag >= 2)
			warning("unrecognized control line\n");
	} else if (Aflag >= 2 && *cp != '\n')
		warning("unrecognized control line\n");
	while (*cp)
		if (*cp++ == '\n')
			if (cp == limit + 1) {
				nextline();
				if (cp == limit)
					break;
			} else
				break;
}

