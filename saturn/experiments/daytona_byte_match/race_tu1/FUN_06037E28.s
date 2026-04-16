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
	add	#-20,r15
	mov.l	L38,r1
	jsr	@r1
	mov	r4,r14
	mov.w	L39,r1
	mov	r14,r2
	extu.w	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	L40,r1
	add	r1,r1
	mov.w	L41,r2
	mov	r1,r0
	mov.l	@(r0,r2),r13
	add	#92,r1
	mov.l	@r1,r0
	cmp/eq	#10,r0
	bf	L2
	mov	#10,r0
	add	#20,r15
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
L38:	.long	_setup_func
L39:	.short	472
L40:	.long	100999756
L41:	.short	352
L2:
	mov	r14,r1
	add	#92,r1
	mov.l	@r1,r1
	mov	r1,r0
	cmp/eq	#6,r0
	bt	L4
	mov	r1,r0
	cmp/eq	#7,r0
	bt	L4
	mov	r1,r0
	cmp/eq	#8,r0
	bt	L4
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L42,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L43,r1
	jsr	@r1
	nop
	bra	L7
	nop
	.align 2
L43:	.long	_sub_06037EA4
L6:
	mov	r14,r1
	mov	r1,r4
	add	#18,r4
	mov.l	L44,r1
	jsr	@r1
	mov.b	@r4,r4
L7:
L4:
	mov.l	L45,r1
	mov	r1,r8
	mov	#0,r11
	mov.l	L46,r1
	mov	r1,r12
	mov.l	L47,r1
	mov	r1,r9
	mov.l	L48,r1
	mov	r1,r10
	mov	r14,r1
	add	#92,r1
	mov.l	@r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	#9,r2
	cmp/gt	r2,r1
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
L11:
	mov.l	L49,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L50,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov.l	L51,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r1
	jsr	@r1
	nop
	mov.l	L59,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L60,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	mov.l	L61,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L63,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L64,r1
	jsr	@r1
	bra	L9
	mov	r14,r4
	.align 2
L49:	.long	_sub_06038014
L50:	.long	_sub_06038018
L60:	.long	_sub_0603801C
L61:	.long	_sub_06038020
L63:	.long	_sub_06038024
L64:	.long	_sub_06038028
L12:
	mov.l	L65,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	bra	L9
	nop
L13:
	mov.l	L67,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L68,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov.l	L51,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r1
	jsr	@r1
	nop
	mov.l	L59,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L69,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	mov.l	L70,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L71,r1
	jsr	@r1
	bra	L9
	mov	r14,r4
	.align 2
L67:	.long	_sub_0603814C
L68:	.long	_sub_06038150
L69:	.long	_sub_06038154
L70:	.long	_sub_06038158
L71:	.long	_sub_0603815C
L14:
	mov.l	L72,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	mov.w	L73,r2
	add	r2,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r14,r1
	add	#92,r1
	mov	#5,r2
	mov.l	r2,@r1
	mov.l	L74,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#2,r0
	bf	L16
	mov.w	L75,r1
	bra	L17
	mov.l	r1,@(12,r15)
	.align 2
L72:	.long	_sub_06038160
L16:
	mov.w	L76,r1
	mov.l	r1,@(12,r15)
L17:
	mov.l	L77,r1
	jsr	@r1
	mov.l	@(12,r15),r4
L18:
	mov	r14,r1
	mov.w	L78,r2
	add	r2,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov.l	L79,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L80,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov.l	L51,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#3,r1
	mov	r14,r2
	mov.w	L73,r3
	add	r3,r2
	mov.w	@r2,r2
	extu.w	r2,r2
	cmp/ge	r2,r1
	bt	L19
	mov	r11,r4
	mov	r14,r5
	mov	r10,r1
	jsr	@r1
	nop
	mov	r14,r1
	mov.w	L78,r2
	add	r2,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L21
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
L21:
L19:
	mov.l	L59,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L81,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	mov.l	L82,r1
	jsr	@r1
	bra	L9
	mov	r14,r4
	.align 2
L73:	.short	424
L77:	.long	_sub_06038260
L79:	.long	_sub_06038264
L80:	.long	_sub_06038268
L23:
	mov.l	L83,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#92,r1
	mov	#7,r2
	mov.l	r2,@r1
	mov.l	L74,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#2,r0
	bf	L25
	mov.w	L75,r1
	bra	L26
	mov.l	r1,@(8,r15)
	.align 2
L74:	.long	3129907
L75:	.short	128
L25:
	mov.w	L76,r1
	mov.l	r1,@(8,r15)
L26:
	mov.l	L84,r1
	jsr	@r1
	mov.l	@(8,r15),r4
L27:
	mov.l	L65,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L85,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L86,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov.l	L51,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	mov.l	L87,r1
	jsr	@r1
	bra	L9
	mov	r14,r4
	.align 2
L51:	.long	_FUN_06038dd8
L76:	.short	224
L28:
	mov.l	L65,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L66,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r4
	mov	r8,r1
	jsr	@r1
	nop
	bra	L9
	nop
	.align 2
L65:	.long	_func_06038bc4
L66:	.long	_sub_06038390
L29:
	mov	r14,r1
	mov.w	L78,r2
	add	r2,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov	r14,r1
	mov	#0,r2
	mov.l	r2,@(36,r1)
	mov	r14,r4
	mov	r9,r1
	jsr	@r1
	nop
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.w	L52,r3
	and	r3,r2
	mov.w	L53,r3
	and	r3,r2
	mov.w	L54,r3
	and	r3,r2
	mov.w	L55,r3
	and	r3,r2
	mov.l	r2,@r1
	mov.l	L88,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L30
	mov.l	L42,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L30
	mov	r14,r1
	mov	#12,r2
	mov.l	L89,r3
	mov.b	@r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	mov.l	L90,r3
	add	r3,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#8,r1
	mov	#12,r2
	mov.l	L89,r3
	mov.b	@r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	mov.l	L90,r3
	add	r3,r2
	add	#8,r2
	mov.l	@r2,r2
	bra	L31
	mov.l	r2,@r1
	.align 2
L42:	.long	101007540
L52:	.short	-3
L53:	.short	-2
L54:	.short	32767
L55:	.short	-65
L30:
	mov	r14,r1
	mov	#12,r2
	mov.l	L89,r3
	mov.b	@r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	mov.l	L90,r3
	add	r3,r2
	mov.l	r2,@(4,r15)
	mov	#60,r3
	mov	r1,r2
	add	#18,r2
	mov.b	@r2,r2
	muls.w	r2,r3
	sts	macl,r2
	mov.l	@(4,r15),r3
	add	r2,r3
	mov	r3,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r14,r1
	mov	r1,r2
	add	#8,r2
	mov.l	r2,@(0,r15)
	mov	#12,r3
	mov.l	L89,r2
	mov.b	@r2,r2
	muls.w	r2,r3
	sts	macl,r2
	exts.b	r2,r2
	mov.l	L90,r3
	add	r3,r2
	mov	#60,r3
	add	#18,r1
	mov.b	@r1,r1
	muls.w	r1,r3
	sts	macl,r1
	add	r1,r2
	mov	r2,r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	@(0,r15),r2
	mov.l	r1,@r2
L31:
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L57,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L58,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	r11,r4
	mov	r14,r5
	mov	r10,r1
	jsr	@r1
	nop
	mov	r14,r1
	mov.w	L78,r2
	add	r2,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L32
	mov.l	L56,r1
	jsr	@r1
	mov	r14,r4
	mov.l	@r13,r4
	mov	r14,r5
	mov.l	@(16,r13),r6
	mov	#0,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#4,r1
	mov	r13,r4
	add	#4,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(20,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#8,r1
	mov	r13,r4
	add	#8,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(24,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
	mov	#12,r1
	mov	r13,r4
	add	#12,r4
	mov.l	@r4,r4
	mov	r14,r5
	mov.l	@(28,r13),r6
	mov	r1,r7
	mov	r12,r1
	jsr	@r1
	nop
L32:
	mov.l	L59,r1
	jsr	@r1
	mov	r14,r4
	mov.l	L62,r1
	jsr	@r1
	mov	r14,r4
L8:
L9:
	mov.l	L91,r1
	jsr	@r1
	mov	r14,r4
	mov	r14,r1
	add	#48,r1
	mov.l	@r1,r2
	mov.l	L92,r3
	and	r3,r2
	mov.l	r2,@r1
	mov	r14,r1
	mov	r1,r2
	add	#44,r2
	mov.l	@r2,r3
	mov.l	@(52,r1),r1
	add	r1,r3
	mov.l	r3,@r2
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	shll	r1
	mov.l	L93,r2
	add	r2,r1
	mov.w	@r1,r1
	tst	r1,r1
	bt	L34
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	shll	r1
	mov.l	L93,r2
	add	r2,r1
	mov.w	@r1,r2
	add	#-1,r2
	mov.w	r2,@r1
L34:
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	shll	r1
	mov.l	L94,r2
	add	r2,r1
	mov.w	@r1,r1
	tst	r1,r1
	bt	L36
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	shll	r1
	mov.l	L94,r2
	add	r2,r1
	mov.w	@r1,r2
	add	#-1,r2
	mov.w	r2,@r1
L36:
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	mov	r1,r0
	shll	r0
L1:
	add	#20,r15
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
L78:	.short	448
	.align 2
L56:	.long	_FUN_060384c4
L57:	.long	_func_06038a82
L58:	.long	_func_060385ce
L59:	.long	_func_060386d8
L62:	.long	_FUN_06038c64
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
