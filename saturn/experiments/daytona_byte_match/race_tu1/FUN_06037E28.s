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
	add	#-4,r15
	mov.l	L38,r0
	jsr	@r0
	mov	r4,r14
	mov.w	L39,r0
	mov	r14,r1
	extu.w	r1,r1
	muls.w	r1,r0
	sts	macl,r0
	exts.w	r0,r0
	mov.l	L40,r0
	add	r0,r0
	mov.w	L41,r2
	add	r0,r2
	mov.l	@r2,r13
	add	#92,r0
	mov.l	@r0,r0
	cmp/eq	#10,r0
	bf	L2
	mov	#10,r0
	add	#4,r15
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
L39:	.short	472
L41:	.short	352
L38:	.long	_setup_func
L40:	.long	100999756
L2:
	mov	r14,r0
	add	#92,r0
	mov.l	@r0,r0
	mov.l	r0,@(0,r15)
	cmp/eq	#6,r0
	bt	L4
	mov.l	@(0,r15),r0
	cmp/eq	#7,r0
	bt	L4
	mov.l	@(0,r15),r0
	cmp/eq	#8,r0
	bt	L4
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L42,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L43,r0
	jsr	@r0
	nop
	bra	L7
	nop
	.align 2
L42:	.long	101007540
L43:	.long	_sub_06037EA4
L6:
	mov	r14,r0
	mov	r0,r4
	add	#18,r4
	mov.l	L44,r0
	jsr	@r0
	mov.b	@r4,r4
L7:
L4:
	mov.l	L45,r0
	mov	r0,r8
	mov	#0,r11
	mov.l	L46,r0
	mov	r0,r12
	mov.l	L47,r0
	mov	r0,r9
	mov.l	L48,r0
	mov	r0,r10
	mov	r14,r0
	add	#92,r0
	mov.l	@r0,r14
	mov	#9,r0
	cmp/gt	r0,r14
	bt	L8
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
	.align 2
L44:	.long	_sub_06037ED4
L45:	.long	_sub_06037ED8
L46:	.long	_sub_06037EE4
L47:	.long	_sub_06037EDC
L48:	.long	_sub_06037EE0
Lswt0:
	.short	L11 - Lswt0
	.short	L11 - Lswt0
	.short	L12 - Lswt0
	.short	L13 - Lswt0
	.short	L14 - Lswt0
	.short	L18 - Lswt0
	.short	L23 - Lswt0
	.short	L27 - Lswt0
	.short	L28 - Lswt0
	.short	L29 - Lswt0
	bra	L8
	nop
	mov.l	L49,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L50,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	L51,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@(48,r14),r1
	mov.w	L52,r2
	and	r2,r1
	mov.w	L53,r2
	and	r2,r1
	mov.w	L54,r2
	and	r2,r1
	mov.w	L55,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L56,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L57,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L58,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r0
	jsr	@r0
	nop
	mov.l	L59,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L60,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	mov.l	L61,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L62,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L63,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L64,r0
	jsr	@r0
	bra	L9
	mov	r14,r4
	.align 2
L49:	.long	_sub_06038014
L50:	.long	_sub_06038018
L60:	.long	_sub_0603801C
L61:	.long	_sub_06038020
L63:	.long	_sub_06038024
L64:	.long	_sub_06038028
	mov.l	L65,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	@(48,r14),r1
	mov.w	L52,r2
	and	r2,r1
	mov.w	L53,r2
	and	r2,r1
	mov.w	L54,r2
	and	r2,r1
	mov.w	L55,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L57,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L58,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L62,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L66,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	bra	L9
	nop
	.align 2
L52:	.short	-3
L53:	.short	-2
L54:	.short	32767
L55:	.short	-65
L65:	.long	_func_06038bc4
L66:	.long	_sub_06038390
	mov.l	L67,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L68,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	L51,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@(48,r14),r1
	mov.w	L97,r2
	and	r2,r1
	mov.w	L98,r2
	and	r2,r1
	mov.w	L99,r2
	and	r2,r1
	mov.w	L100,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L56,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L57,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L58,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r0
	jsr	@r0
	nop
	mov.l	L59,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L62,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L69,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	mov.l	L70,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L71,r0
	jsr	@r0
	bra	L9
	mov	r14,r4
	.align 2
L97:	.short	-3
L98:	.short	-2
L99:	.short	32767
L100:	.short	-65
L51:	.long	_FUN_06038dd8
L56:	.long	_FUN_060384c4
L57:	.long	_func_06038a82
L58:	.long	_func_060385ce
L59:	.long	_func_060386d8
L62:	.long	_FUN_06038c64
L67:	.long	_sub_0603814C
L68:	.long	_sub_06038150
L69:	.long	_sub_06038154
L70:	.long	_sub_06038158
L71:	.long	_sub_0603815C
	mov.l	L72,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r0
	mov.w	L73,r1
	add	r1,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r14,r0
	add	#92,r0
	mov	#5,r1
	mov.l	r1,@r0
	mov.l	L74,r0
	mov.b	@r0,r0
	cmp/eq	#2,r0
	bf	L16
	mov.w	L75,r14
	bra	L17
	nop
	.align 2
L75:	.short	128
	.align 2
L72:	.long	_sub_06038160
L16:
	mov.w	L76,r14
L17:
	mov.l	L77,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r0
	mov.w	L78,r1
	add	r1,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov.l	L79,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L80,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	L96,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@(48,r14),r1
	mov.w	L111,r2
	and	r2,r1
	mov.w	L112,r2
	and	r2,r1
	mov.w	L113,r2
	and	r2,r1
	mov.w	L114,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L101,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L102,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L103,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#3,r1
	mov	r14,r0
	mov.w	L73,r2
	add	r2,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	cmp/ge	r0,r1
	bt	L19
	mov	r11,r4
	mov	r14,r5
	mov	r10,r0
	jsr	@r0
	nop
	mov	r14,r0
	mov.w	L78,r1
	add	r1,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L21
	mov.l	L101,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
L21:
L19:
	mov.l	L104,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L105,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L81,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	mov.l	L82,r0
	jsr	@r0
	bra	L9
	mov	r14,r4
	.align 2
L73:	.short	424
L76:	.short	224
L78:	.short	448
L111:	.short	-3
L112:	.short	-2
L113:	.short	32767
L114:	.short	-65
	.align 2
L77:	.long	_sub_06038260
L79:	.long	_sub_06038264
L80:	.long	_sub_06038268
	mov.l	L83,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r0
	add	#92,r0
	mov	#7,r1
	mov.l	r1,@r0
	mov.l	L74,r0
	mov.b	@r0,r0
	cmp/eq	#2,r0
	bf	L25
	mov.w	L108,r14
	bra	L26
	nop
	.align 2
L108:	.short	128
	.align 2
L74:	.long	3129907
L101:	.long	_FUN_060384c4
L25:
	mov.w	L109,r14
L26:
	mov.l	L84,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L106,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L85,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L86,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	L96,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@(48,r14),r1
	mov.w	L121,r2
	and	r2,r1
	mov.w	L122,r2
	and	r2,r1
	mov.w	L123,r2
	and	r2,r1
	mov.w	L124,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L102,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L103,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L105,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L107,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	mov.l	L87,r0
	jsr	@r0
	bra	L9
	mov	r14,r4
	.align 2
L109:	.short	224
	.align 2
L96:	.long	_FUN_06038dd8
	mov.l	L106,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	@(48,r14),r1
	mov.w	L121,r2
	and	r2,r1
	mov.w	L122,r2
	and	r2,r1
	mov.w	L123,r2
	and	r2,r1
	mov.w	L124,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L102,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L103,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L105,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L107,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r4
	mov	r8,r0
	jsr	@r0
	nop
	bra	L9
	nop
	.align 2
L102:	.long	_func_06038a82
	mov	r14,r0
	mov.w	L110,r1
	add	r1,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov	r14,r0
	mov	#0,r1
	mov.l	r1,@(36,r0)
	mov	r14,r4
	mov	r9,r0
	jsr	@r0
	nop
	mov.l	@(48,r14),r1
	mov.w	L121,r2
	and	r2,r1
	mov.w	L122,r2
	and	r2,r1
	mov.w	L123,r2
	and	r2,r1
	mov.w	L124,r2
	and	r2,r1
	mov.l	r1,@r0
	mov.l	L88,r0
	jsr	@r0
	mov	r14,r4
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L30
	mov.l	L95,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L30
	mov	r14,r0
	mov	r0,r1
	mov	#12,r2
	mov.l	L89,r0
	mov.b	@r0,r0
	muls.w	r0,r2
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L90,r2
	add	r2,r0
	mov.l	@r0,r0
	mov.l	r0,@r1
	mov	r14,r0
	mov	r0,r1
	add	#8,r1
	mov	#12,r2
	mov.l	L89,r0
	mov.b	@r0,r0
	muls.w	r0,r2
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L90,r2
	add	r2,r0
	add	#8,r0
	mov.l	@r0,r0
	bra	L31
	mov.l	r0,@r1
	.align 2
L110:	.short	448
L121:	.short	-3
L122:	.short	-2
L123:	.short	32767
L124:	.short	-65
L30:
	mov	r14,r0
	mov	#12,r1
	mov.l	L89,r2
	mov.b	@r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	mov.l	L90,r2
	add	r2,r1
	mov	#60,r2
	mov	r0,r3
	add	#18,r3
	mov.b	@r3,r3
	muls.w	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r14,r0
	mov	r0,r1
	add	#8,r1
	mov	#12,r2
	mov.l	L89,r3
	mov.b	@r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	mov.l	L90,r3
	add	r3,r2
	mov	#60,r3
	add	#18,r0
	mov.b	@r0,r0
	muls.w	r0,r3
	sts	macl,r0
	add	r0,r2
	mov.l	@(8,r2),r0
	mov.l	r0,@r1
L31:
	mov.l	L115,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L116,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L117,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r0
	jsr	@r0
	nop
	mov	r14,r0
	mov.w	L120,r1
	add	r1,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L32
	mov.l	L115,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#4,r0
	mov.l	@(4,r13),r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#8,r0
	mov.l	@(8,r13),r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
	mov	#12,r0
	mov.l	@(12,r13),r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r0,r7
	mov	r12,r0
	jsr	@r0
	nop
L32:
	mov.l	L118,r0
	jsr	@r0
	mov	r14,r4
	mov.l	L119,r0
	jsr	@r0
	mov	r14,r4
L8:
L9:
	mov.l	L91,r0
	jsr	@r0
	mov	r14,r4
	mov.l	@(48,r14),r1
	mov.l	L92,r2
	and	r2,r1
	mov.l	r1,@r0
	mov	r14,r0
	mov.l	@(44,r0),r2
	mov.l	@(52,r0),r0
	add	r0,r2
	mov.l	r2,@r1
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	shll	r0
	mov.l	L93,r1
	add	r1,r0
	mov.w	@r0,r0
	tst	r0,r0
	bt	L34
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	shll	r0
	mov.l	L93,r1
	add	r1,r0
	mov.w	@r0,r1
	add	#-1,r1
	mov.w	r1,@r0
L34:
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	shll	r0
	mov.l	L94,r1
	add	r1,r0
	mov.w	@r0,r0
	tst	r0,r0
	bt	L36
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	shll	r0
	mov.l	L94,r1
	add	r1,r0
	mov.w	@r0,r1
	add	#-1,r1
	mov.w	r1,@r0
L36:
	mov	r14,r0
	add	#18,r0
	mov.b	@r0,r0
	shll	r0
L1:
	add	#4,r15
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
L120:	.short	448
	.align 2
L81:	.long	_sub_0603826C
L82:	.long	_sub_06038270
L83:	.long	_sub_06038274
L84:	.long	_sub_06038384
L85:	.long	_sub_06038388
L86:	.long	_sub_0603838C
L87:	.long	_sub_06038394
L88:	.long	_sub_06038398
L89:	.long	101009696
L90:	.long	100988900
L91:	.long	_sub_060384B4
L92:	.long	-134217729
L93:	.long	101001168
L94:	.long	101001172
L95:	.long	101007540
L103:	.long	_func_060385ce
L104:	.long	_func_060386d8
L105:	.long	_FUN_06038c64
L106:	.long	_func_06038bc4
L107:	.long	_sub_06038390
L115:	.long	_FUN_060384c4
L116:	.long	_func_06038a82
L117:	.long	_func_060385ce
L118:	.long	_func_060386d8
L119:	.long	_FUN_06038c64
