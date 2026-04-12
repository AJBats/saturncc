	.global _FUN_06037E28
	.text
	.align 2
_FUN_06037E28:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	mov	r15,r14
	add	#-4,r15
	mov.l	L35,r1
	jsr	@r1
	mov	r4,r8
	mov.w	L36,r1
	mov	r8,r2
	extu.w	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	L37,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r1,r13
	mov.w	L38,r2
	add	r13,r2
	mov.l	@r2,r11
	mov	r13,r1
	add	#92,r1
	mov.l	@r1,r12
	mov	r12,r0
	cmp/eq	#10,r0
	bf	L2
	mov	#10,r0
	mov	r14,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2:
	mov	r13,r1
	add	#92,r1
	mov.l	@r1,r12
	mov	r12,r0
	cmp/eq	#6,r0
	bt	L4
	mov	r12,r0
	cmp/eq	#7,r0
	bt	L4
	mov	r12,r0
	cmp/eq	#8,r0
	bt	L4
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L39,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L40,r1
	jsr	@r1
	nop
	bra	L7
	nop
L6:
	mov	r13,r4
	add	#18,r4
	mov.b	@r4,r4
	mov.l	L41,r1
	jsr	@r1
	exts.b	r4,r4
L7:
L4:
	mov	#9,r1
	cmp/gt	r1,r12
	bt	L8
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L10 - Lswt0
	.short	L10 - Lswt0
	.short	L11 - Lswt0
	.short	L12 - Lswt0
	.short	L13 - Lswt0
	.short	L16 - Lswt0
	.short	L21 - Lswt0
	.short	L24 - Lswt0
	.short	L25 - Lswt0
	.short	L26 - Lswt0
	bra	L8
	nop
L10:
	mov.l	L42,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L43,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L45,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L46,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L47,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L48,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#0,r4
	mov.l	L54,r1
	jsr	@r1
	mov	r13,r5
	mov.l	L55,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L56,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L60,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L61,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L11:
	mov.l	L62,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L63,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L64,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L65,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L12:
	mov.l	L67,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L68,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L45,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L63,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L64,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L65,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#0,r4
	mov.l	L54,r1
	jsr	@r1
	mov	r13,r5
	mov.l	L55,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L69,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L70,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L71,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L13:
	mov.l	L72,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L73,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r13,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r13,r1
	add	#92,r1
	mov	#5,r2
	mov.l	r2,@r1
	mov.l	L74,r1
	mov.w	@r1,r10
	mov.l	L75,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	exts.b	r1,r0
	cmp/eq	#2,r0
	bf	L14
	mov.l	L76,r1
	mov.w	@r1,r10
L14:
	mov.l	L77,r1
	jsr	@r1
	exts.w	r10,r4
L16:
	mov.l	L78,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r13,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov.l	L79,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L80,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L45,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L81,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L82,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L83,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#3,r1
	mov.l	L84,r2
	mov.w	@r2,r2
	exts.w	r2,r2
	add	r13,r2
	mov.w	@r2,r2
	extu.w	r2,r2
	cmp/ge	r2,r1
	bt	L17
	mov	#0,r4
	mov.l	L54,r1
	jsr	@r1
	mov	r13,r5
	mov.l	L78,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r13,r1
	mov.b	@r1,r1
	exts.b	r1,r0
	cmp/eq	#1,r0
	bf	L19
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
L19:
L17:
	mov.l	L55,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L85,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L86,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L21:
	mov.l	L87,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#92,r1
	mov	#7,r2
	mov.l	r2,@r1
	mov.l	L88,r1
	mov.w	@r1,r10
	mov.l	L89,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	exts.b	r1,r0
	cmp/eq	#2,r0
	bf	L22
	mov.l	L90,r1
	mov.w	@r1,r10
L22:
	mov.l	L91,r1
	jsr	@r1
	exts.w	r10,r4
L24:
	mov.l	L62,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L92,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L93,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L45,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L94,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L95,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L96,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L97,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L25:
	mov.l	L62,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L94,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L95,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L96,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L57,r1
	jsr	@r1
	bra	L9
	mov	r13,r4
L26:
	mov.l	L98,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r13,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov	r13,r1
	add	#36,r1
	mov	#0,r2
	mov.l	r2,@r1
	mov.l	L44,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L94,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L95,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.l	L96,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	and	r3,r2
	mov.w	L49,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L99,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L100,r1
	mov.l	@r1,r10
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L27
	mov.l	L101,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L27
	mov.l	L102,r1
	mov.l	@r1,r1
	mov	#12,r2
	mov.l	L100,r3
	mov.l	@r3,r3
	mov.b	@r3,r3
	exts.b	r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	add	r2,r1
	mov.l	@r1,r1
	mov.l	r1,@r13
	mov	r13,r1
	add	#8,r1
	mov.l	r1,@(0,r15)
	mov.l	L102,r2
	mov.l	@r2,r2
	mov	#12,r3
	mov.b	@r10,r1
	exts.b	r1,r1
	muls.w	r1,r3
	sts	macl,r1
	exts.b	r1,r1
	add	r1,r2
	mov	r2,r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	@(0,r15),r2
	bra	L28
	mov.l	r1,@r2
L27:
	mov.l	L102,r1
	mov.l	@r1,r1
	mov	#12,r2
	mov.l	L100,r3
	mov.l	@r3,r3
	mov.b	@r3,r3
	exts.b	r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	add	r2,r1
	mov	#60,r2
	mov	r13,r3
	add	#18,r3
	mov.b	@r3,r3
	exts.b	r3,r3
	muls.w	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	@r1,r1
	mov.l	r1,@r13
	mov	r13,r1
	add	#8,r1
	mov.l	r1,@(0,r15)
	mov.l	L103,r2
	mov.l	@r2,r2
	mov	#12,r3
	mov.b	@r10,r1
	exts.b	r1,r1
	muls.w	r1,r3
	sts	macl,r1
	exts.b	r1,r1
	add	r1,r2
	mov	#60,r1
	mov	r13,r3
	add	#18,r3
	mov.b	@r3,r3
	exts.b	r3,r3
	muls.w	r3,r1
	sts	macl,r1
	add	r1,r2
	mov	r2,r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	@(0,r15),r2
	mov.l	r1,@r2
L28:
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L51,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L52,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#0,r4
	mov.l	L54,r1
	jsr	@r1
	mov	r13,r5
	mov.l	L104,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r13,r1
	mov.b	@r1,r1
	exts.b	r1,r0
	cmp/eq	#1,r0
	bf	L29
	mov.l	L50,r1
	jsr	@r1
	mov	r13,r4
	mov.l	@r11,r4
	mov	r13,r5
	mov	r11,r6
	add	#16,r6
	mov.l	@r6,r6
	mov.l	L53,r1
	jsr	@r1
	mov	#0,r7
	mov	#4,r1
	mov	r11,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#20,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r11,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#24,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r11,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r13,r5
	mov	r11,r6
	add	#28,r6
	mov.l	@r6,r6
	mov	r1,r7
	mov.l	L53,r1
	jsr	@r1
	nop
L29:
	mov.l	L55,r1
	jsr	@r1
	mov	r13,r4
	mov.l	L59,r1
	jsr	@r1
	mov	r13,r4
L8:
L9:
	mov.l	L105,r1
	jsr	@r1
	mov	r13,r4
	mov	r13,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L106,r3
	mov.l	@r3,r3
	and	r3,r2
	mov.l	r2,@r1
	mov	r13,r1
	add	#44,r1
	mov.l	@r1,r2
	mov	r13,r3
	add	#52,r3
	mov.l	@r3,r3
	add	r3,r2
	mov.l	r2,@r1
	mov.l	L107,r1
	mov.l	@r1,r9
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	shll	r1
	mov	r9,r1
	add	r1,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	tst	r1,r1
	bt	L31
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r10
	shll	r10
	mov	r9,r1
	add	r10,r1
	mov.w	@r1,r2
	exts.w	r2,r2
	add	#-1,r2
	mov.w	r2,@r1
L31:
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r10
	shll	r10
	mov.l	L108,r1
	mov.l	@r1,r1
	add	r10,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	tst	r1,r1
	bt	L33
	mov	r13,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r10
	shll	r10
	mov.l	L108,r1
	mov.l	@r1,r1
	add	r10,r1
	mov.w	@r1,r2
	exts.w	r2,r2
	add	#-1,r2
	mov.w	r2,@r1
L33:
	mov	r10,r0
L1:
	mov	r14,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L35:	.long	_setup_func
L36:	.short	472
L37:	.long	_base_array
L38:	.short	352
L39:	.long	_dat_060540B4
L40:	.long	_sub_06037EA4
L41:	.long	_sub_06037ED4
L42:	.long	_sub_06038014
L43:	.long	_sub_06038018
L44:	.long	_sub_06037EDC
L45:	.long	_FUN_06038dd8
L46:	.long	_dat_0603800C
L47:	.long	_dat_0603800E
L48:	.long	_dat_06038010
L49:	.short	-65
L50:	.long	_FUN_060384c4
L51:	.long	_func_06038a82
L52:	.long	_func_060385ce
L53:	.long	_sub_06037EE4
L54:	.long	_sub_06037EE0
L55:	.long	_func_060386d8
L56:	.long	_sub_0603801C
L57:	.long	_sub_06037ED8
L58:	.long	_sub_06038020
L59:	.long	_FUN_06038c64
L60:	.long	_sub_06038024
L61:	.long	_sub_06038028
L62:	.long	_func_06038bc4
L63:	.long	_dat_0603813E
L64:	.long	_dat_06038140
L65:	.long	_dat_06038142
L66:	.long	_sub_06038390
L67:	.long	_sub_0603814C
L68:	.long	_sub_06038150
L69:	.long	_sub_06038154
L70:	.long	_sub_06038158
L71:	.long	_sub_0603815C
L72:	.long	_sub_06038160
L73:	.long	_dat_06038146
L74:	.long	_dat_06038252
L75:	.long	_dat_06038164
L76:	.long	_dat_06038148
L77:	.long	_sub_06038260
L78:	.long	_dat_06038254
L79:	.long	_sub_06038264
L80:	.long	_sub_06038268
L81:	.long	_dat_06038256
L82:	.long	_dat_06038258
L83:	.long	_dat_0603825A
L84:	.long	_dat_0603825C
L85:	.long	_sub_0603826C
L86:	.long	_sub_06038270
L87:	.long	_sub_06038274
L88:	.long	_dat_06038378
L89:	.long	_dat_06038278
L90:	.long	_dat_0603825E
L91:	.long	_sub_06038384
L92:	.long	_sub_06038388
L93:	.long	_sub_0603838C
L94:	.long	_dat_0603837A
L95:	.long	_dat_0603837C
L96:	.long	_dat_0603837E
L97:	.long	_sub_06038394
L98:	.long	_dat_06038380
L99:	.long	_sub_06038398
L100:	.long	_dat_0603839C
L101:	.long	_dat_060383A4
L102:	.long	_dat_060383A0
L103:	.long	_dat_060384B0
L104:	.long	_dat_060384AC
L105:	.long	_sub_060384B4
L106:	.long	_dat_060384B8
L107:	.long	_dat_060384BC
L108:	.long	_dat_060384C0
