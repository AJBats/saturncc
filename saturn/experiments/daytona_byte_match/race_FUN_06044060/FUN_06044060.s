	.global _FUN_06044060
	.text
	.align 2
_FUN_06044060:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r5,r9
	mov	r6,r10
	mov	r7,r11
	mov.l	L4,r3
	jsr	@r3
	add	#48,r4
	mov.l	L5,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2
	mov #1, r6
	shll16 r6
	neg r6, r5
	mov.l	L6,r3
	jsr	@r3
	mov r6, r7
L2:
	mov.l	L7,r3
	jsr	@r3
	mov r9, r5
	mov.l	L8,r3
	jsr	@r3
	mov r11, r0
	mov.l	L9,r3
	jsr	@r3
	mov r10, r0
	mov	r8,r4
	add	#48,r4
	mov.l	L10,r5
	mov.l	L11,r3
	jsr	@r3
	mov.l	@r5,r5
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
L4:	.long	_FUN_06044D80
L5:	.long	101009701
L6:	.long	_FUN_06044F30
L7:	.long	_FUN_06044E3C
L8:	.long	_FUN_060450F2
L9:	.long	_FUN_06045006
L10:	.long	101018036
L11:	.long	_FUN_060457DC
	.global _FUN_060440e0
	.align 2
_FUN_060440e0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r4,r8
	mov	#4,r9
L13:
	add	#48,r8
	mov	r8,r4
	mov.l	L16,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L17,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L18,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	add	#-48,r8
	dt	r9
	bf	L13
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
L16:	.long	_pcRam06044128
L17:	.long	_pcRam0604412c
L18:	.long	_pcRam06044134
	.global _FUN_06044138
	.align 2
_FUN_06044138:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-36,r15
	mov.l	L36,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	L37,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r0,r3
	jsr	@r3
	nop
	mov.l	L38,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#12,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L39,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L40,r0
	mov.l	@r0,r12
	mov.l	L41,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov	#0,r0
	mov.l	r0,@(32,r15)
	mov.l	L42,r0
	mov.l	@r0,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov.l	L43,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r15)
	mov.l	L44,r0
	mov.l	@r0,r13
	mov.l	L45,r0
	mov.l	@r0,r0
	mov.l	r0,@(0,r15)
	mov.l	L46,r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r15)
	mov.l	L47,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
L20:
	mov.l	@(32,r15),r0
	mov	#6,r1
	mov	r0,r2
	exts.b	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(24,r15)
	mov.l	@(24,r15),r1
	mov.l	@(0,r15),r2
	add	r2,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(32,r15),r0
	mov	r0,r1
	add	#1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(24,r15),r1
	add	#1,r1
	add	r13,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(4,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(2,r1)
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(3,r1)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(4,r1)
	mov.l	@(24,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(28,r15),r0
	mov	#6,r1
	mov	r0,r2
	exts.b	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(24,r15)
	mov.l	@(24,r15),r1
	mov.l	@(0,r15),r2
	add	r2,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(28,r15),r0
	add	r13,r0
	mov.b	@r0,r0
	mov.b	r0,@(1,r1)
	mov.l	@(32,r15),r0
	add	#2,r0
	mov.l	r0,@(32,r15)
	mov.l	@(24,r15),r0
	mov	r0,r1
	add	#2,r1
	mov.l	@(4,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(3,r1)
	mov.l	@(16,r15),r0
	add	#2,r0
	mov.l	r0,@(16,r15)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(4,r1)
	mov.l	@(8,r15),r0
	add	#2,r0
	mov.l	r0,@(8,r15)
	mov.l	@(24,r15),r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r0
	add	#2,r0
	mov.l	r0,@(4,r15)
	mov.l	@(32,r15),r0
	mov	#2,r1
	cmp/ge	r1,r0
	bf	L20
	mov.l	L48,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	tst	r0,r0
	bf	L23
	mov.l	L49,r0
	mov.l	@r0,r0
	mov.l	L50,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov.l	L51,r0
	mov.l	@r0,r11
	mov.l	L52,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L25
	mov	#2,r1
	mov.l	L53,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/ge	r0,r1
	bt	L27
	mov	#0,r0
	mov.l	r0,@(0,r15)
	mov.l	L41,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov.l	L54,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r15)
	mov.l	L55,r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r15)
L29:
	mov	#6,r0
	mov.l	@(0,r15),r1
	exts.b	r1,r1
	muls.w	r1,r0
	sts	macl,r0
	exts.b	r0,r0
	add	r12,r0
	mov.l	r0,@(4,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(2,r1)
	mov	#6,r0
	mov.l	@(0,r15),r0
	mov	r0,r1
	exts.b	r1,r1
	mul.l	r1,r0
	sts	macl,r1
	add	#6,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(4,r15)
	add	#2,r0
	mov.l	r0,@(0,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(2,r1)
	mov.l	@(20,r15),r0
	add	#2,r0
	mov.l	r0,@(20,r15)
	mov.l	@(16,r15),r0
	add	#2,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	add	#2,r0
	mov.l	r0,@(8,r15)
	mov.l	@(0,r15),r0
	mov	#2,r1
	cmp/ge	r1,r0
	bf	L29
L27:
	mov.l	L56,r0
	mov.l	@r0,r10
	mov	#1,r0
	mov.l	r0,@r11
	mov	#20,r0
	mov.l	r0,@(4,r11)
	mov.b	@r12,r0
	mov.b	r0,@(8,r11)
	mov	r11,r1
	add	#9,r1
	mov.b	@(1,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#10,r1
	mov.b	@(2,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#11,r1
	mov.b	@(3,r12),r0
	mov.b	r0,@r1
	mov.b	@(4,r12),r0
	mov.b	r0,@(12,r11)
	mov	r11,r1
	add	#13,r1
	mov.b	@(5,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#14,r1
	mov.b	@(6,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#15,r1
	mov.b	@(7,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#16,r1
	mov.b	@(8,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#17,r1
	mov.b	@(9,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#18,r1
	mov.b	@(10,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#19,r1
	mov.b	@(11,r12),r0
	mov.b	r0,@r1
	mov.l	L57,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	mov	r0,r9
	mov.l	L58,r0
	mov.l	@r0,r8
	mov	r9,r0
	tst	r0,r0
	bf	L32
	mov.l	L59,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.w	L60,r1
	mov.l	L61,r2
	mov.l	@r2,r2
	mov.b	@r2,r2
	mul.l	r2,r1
	sts	macl,r1
	shll2	r1
	mov	r1,r8
	add	r0,r8
L32:
	mov	r8,r0
	mov.l	r0,@r10
	mov.l	L65,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov.l	L53,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L26
	mov.l	L62,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L26
	mov.l	L63,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#6,r0
	bt	L26
	mov.l	@r10,r0
	mov	r0,r9
	mov.l	@r9,r0
	tst	r0,r0
	bt	L26
	mov.l	@r10,r0
	mov.l	r0,@(0,r15)
	mov.l	@(0,r15),r0
	add	#8,r0
	mov.b	@r0,r0
	mov.b	r0,@(6,r12)
	mov.l	@(0,r15),r0
	add	#9,r0
	mov.b	@r0,r0
	mov.b	r0,@(7,r12)
	mov.l	@(0,r15),r0
	add	#10,r0
	mov.b	@r0,r0
	mov.b	r0,@(8,r12)
	mov.l	@(0,r15),r0
	add	#11,r0
	mov.b	@r0,r0
	mov.b	r0,@(9,r12)
	mov.l	@(0,r15),r0
	add	#12,r0
	mov.b	@r0,r0
	mov.b	r0,@(10,r12)
	mov.l	L64,r0
	mov.l	@r0,r8
	mov.l	@(0,r15),r0
	add	#13,r0
	mov.b	@r0,r1
	mov	r1,r9
	mov.b	@r0,r0
	mov.b	r0,@(11,r12)
	mov.l	@r10,r0
	add	#20,r0
	mov.l	r0,@r8
	mov.l	@(8,r15),r0
	mov	#1,r1
	bra	L26
	mov.b	r1,@r0
L25:
	mov.l	L66,r0
	mov.l	@r0,r0
	mov	r0,r1
	add	#14,r1
	mov.l	r1,@(8,r15)
	mov.b	@(8,r0),r0
	mov.b	r0,@r12
	mov.b	@(9,r11),r0
	mov.b	r0,@(1,r12)
	mov.b	@(10,r11),r0
	mov.b	r0,@(2,r12)
	mov.b	@(11,r11),r0
	mov.b	r0,@(3,r12)
	mov.b	@(12,r11),r0
	mov.b	r0,@(4,r12)
	mov.b	@(13,r11),r0
	mov.b	r0,@(5,r12)
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(6,r12)
	mov.b	@(15,r11),r0
	mov.b	r0,@(7,r12)
	mov	r11,r0
	add	#16,r0
	mov.b	@r0,r0
	mov.b	r0,@(8,r12)
	mov	r11,r0
	add	#17,r0
	mov.b	@r0,r0
	mov.b	r0,@(9,r12)
	mov	r11,r0
	add	#18,r0
	mov.b	@r0,r0
	mov.b	r0,@(10,r12)
	mov	r11,r0
	add	#19,r0
	mov.b	@r0,r1
	mov	r1,r9
	mov.b	@r0,r0
	mov.b	r0,@(11,r12)
L26:
L23:
	mov	r9,r0
	add	#36,r15
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
L60:	.short	3072
	.align 2
L36:	.long	_DAT_060443b0
L37:	.long	_DAT_060443b4
L38:	.long	_DAT_060443b8
L39:	.long	_DAT_060443bc
L40:	.long	_DAT_060443dc
L41:	.long	_DAT_060443c4
L42:	.long	_DAT_060443c0
L43:	.long	_DAT_060443d8
L44:	.long	_DAT_060443d4
L45:	.long	_DAT_060443d0
L46:	.long	_DAT_060443c8
L47:	.long	_DAT_060443cc
L48:	.long	_DAT_060443e0
L49:	.long	_DAT_060443e8
L50:	.long	_DAT_060443e4
L51:	.long	_DAT_060443ec
L52:	.long	_DAT_060443f0
L53:	.long	_DAT_060443f4
L54:	.long	_DAT_060443f8
L55:	.long	_DAT_060443fc
L56:	.long	_DAT_06044400
L57:	.long	_DAT_06044404
L58:	.long	_DAT_06044410
L59:	.long	_DAT_0604440c
L61:	.long	_DAT_06044408
L62:	.long	_DAT_06044414
L63:	.long	_DAT_06044418
L64:	.long	_DAT_0604441c
L65:	.long	_DAT_060443c0
L66:	.long	_DAT_060443ec
	.global _FUN_06044344
	.align 2
_FUN_06044344:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	macl,@-r15
	add	#-60,r15
	mov.l	L112,r0
	mov.l	@r0,r10
	mov.l	L113,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	tst	r0,r0
	bt	L68
	mov.l	L113,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	add	#60,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L68:
	mov	#1,r0
	mov.l	r0,@(20,r15)
	mov	r4,r11
	mov	#12,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	r0,@(52,r15)
	mov.l	@(52,r15),r0
	mov.l	L114,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(48,r15)
	mov.l	L115,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	mov	r0,r8
	mov.l	L116,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L70
	mov.l	@(48,r15),r0
	mov.l	@r0,r1
	mov.l	r1,@(4,r15)
	mov.l	@(4,r0),r1
	mov.l	r1,@(0,r15)
	mov.b	@(8,r0),r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L72
	mov	#0,r0
	mov	r15,r1
	add	#27,r1
	mov.b	r0,@r1
	mov.l	L117,r0
	mov.l	@r0,r0
	mov	r8,r1
	mov.l	@(4,r0),r2
	add	r0,r2
	mov	r2,r0
	cmp/hs	r0,r1
	bt	L74
	mov.b	@r8+,r0
	mov	r15,r1
	add	#39,r1
	mov.b	r0,@r1
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	exts.b	r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L76
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov	#127,r1
	extu.b	r0,r0
	and	r1,r0
	mov	r15,r1
	add	#27,r1
	bra	L73
	mov.b	r0,@r1
L76:
	mov	r15,r0
	add	#4,r0
	bra	L81
	mov.l	r0,@(16,r15)
L78:
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L82
	mov.b	@r8+,r13
	mov.l	@(16,r15),r1
	mov.b	r13,@r1
L82:
	mov.l	@(16,r15),r0
	add	#1,r0
	mov.l	r0,@(16,r15)
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	exts.b	r0,r0
	shar	r0
	mov	r15,r1
	add	#39,r1
	mov.b	r0,@r1
L81:
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L78
	bra	L73
	nop
L74:
	mov.l	@(0,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(0,r15)
	mov	#0,r0
	bra	L73
	mov.l	r0,@(4,r15)
L72:
	mov.l	@(48,r15),r0
	mov.b	@(8,r0),r0
	mov	#1,r1
	extu.b	r0,r0
	sub	r1,r0
	mov	r15,r1
	add	#27,r1
	mov.b	r0,@r1
L73:
	mov.l	@(48,r15),r1
	mov	r15,r0
	add	#27,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.b	r0,@(8,r1)
	bra	L84
	mov.l	r8,@(28,r15)
L70:
	mov.l	L118,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#3,r0
	bf	L85
	mov	#20,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L119,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(44,r15)
	mov.l	@(44,r15),r0
	mov.w	@r0,r14
	mov.l	@(8,r0),r0
	mov.l	r0,@(4,r15)
L87:
	mov.l	@(44,r15),r0
	mov.b	@(12,r0),r0
	extu.b	r0,r0
	extu.w	r0,r0
	shll8	r0
	mov.l	@(0,r15),r1
	extu.b	r1,r1
	or	r1,r0
	mov.w	r0,@(2,r15)
	extu.w	r14,r0
	mov	r0,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	extu.w	r0,r0
	or	r0,r1
	bra	L86
	mov.l	r1,@(0,r15)
L85:
	mov.l	L118,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#4,r0
	bf	L90
	mov	#20,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L120,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(44,r15)
	mov.l	@(44,r15),r0
	mov.w	@r0,r14
	mov.l	@(8,r0),r0
	bra	L87
	mov.l	r0,@(4,r15)
L90:
	mov.l	@(52,r15),r0
	mov.l	L121,r1
	mov.l	@r1,r1
	add	r1,r0
	add	#8,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
	mov.l	L122,r0
	mov.l	@r0,r0
	mov	r4,r0
	add	r0,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.w	r0,r0
	shll8	r0
	mov.l	@(0,r15),r1
	extu.b	r1,r1
	or	r1,r0
	mov.w	r0,@(2,r15)
	mov.l	@(52,r15),r0
	mov.l	L121,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	r0,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	extu.w	r0,r0
	or	r0,r1
	mov.l	r1,@(0,r15)
L86:
	mov.l	L123,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	and	r1,r0
	mov.l	r0,@(4,r15)
	mov.l	r8,@(28,r15)
	mov	r8,r0
	tst	r0,r0
	bt	L94
	mov.l	@(48,r15),r0
	mov.l	@(8,r0),r1
	mov.l	r1,@(40,r15)
	mov	#0,r1
	mov.l	r1,@(32,r15)
	mov	r8,r1
	add	#1,r1
	mov.l	r1,@(28,r15)
	mov	r15,r1
	add	#4,r1
	mov.l	r1,@(12,r15)
	mov.l	r0,@(8,r15)
L96:
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	extu.b	r0,r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	extu.b	r0,r0
	cmp/eq	r0,r1
	bt	L99
	mov	r10,r0
	mov.l	@(28,r15),r1
	cmp/hi	r1,r0
	bt	L101
	bra	L103
	nop
L101:
	mov.l	@(28,r15),r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(32,r15),r0
	mov.l	@(20,r15),r1
	or	r1,r0
	mov.l	r0,@(32,r15)
	mov.l	@(28,r15),r0
	add	#1,r0
	mov.l	r0,@(28,r15)
L99:
	mov.l	@(20,r15),r0
	shll	r0
	mov.l	r0,@(20,r15)
	mov.l	@(12,r15),r0
	add	#1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(8,r15)
	mov.l	@(20,r15),r0
	mov	#127,r1
	and	r1,r0
	tst	r0,r0
	bf	L96
	mov.l	@(32,r15),r0
	tst	r0,r0
	bf	L104
	mov.l	@(40,r15),r0
	mov	r0,r1
	tst	r1,r1
	bt	L108
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.w	L124,r1
	cmp/eq	r1,r0
	bf	L106
L108:
	mov	r10,r0
	mov	r8,r1
	cmp/hi	r1,r0
	bt	L109
L103:
	mov.l	L125,r0
	mov.l	r0,@(28,r15)
	mov.l	L132,r0
	mov.l	@r0,r0
	mov	#0,r1
	bra	L84
	mov.l	r1,@r0
L109:
	mov.w	L126,r0
	mov.b	r0,@r8
	mov	r8,r0
	add	#1,r0
	mov.l	r0,@(28,r15)
	bra	L105
	mov.l	r8,@(40,r15)
L106:
	mov.l	@(40,r15),r0
	mov.b	@r0,r1
	add	#1,r1
	mov.b	r1,@r0
	bra	L105
	mov.l	r8,@(28,r15)
L104:
	mov.l	@(32,r15),r0
	mov.b	r0,@r8
	mov.l	L125,r0
	mov.l	r0,@(40,r15)
L105:
	mov.l	L127,r0
	mov.l	@r0,r0
	mov.l	L128,r1
	mov.l	@r1,r1
	mov.l	@(28,r15),r2
	add	r2,r1
	mov.l	r1,@r0
	mov.l	@(48,r15),r0
	mov.l	@(40,r15),r1
	mov.l	r1,@(8,r0)
L94:
L84:
	mov.l	L129,r0
	mov.l	@r0,r9
	mov.l	L130,r0
	mov.l	@r0,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	mov.l	@(52,r15),r0
	add	r9,r0
	mov.l	r0,@(56,r15)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov.w	r0,@r1
	mov.l	@(48,r15),r0
	mov.w	@(4,r0),r0
	mov.l	@(56,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	not	r0,r0
	and	r0,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	L131,r0
	mov.l	@r0,r0
	mov.l	r0,@(52,r15)
	mov	#6,r1
	exts.b	r11,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r0,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(56,r15),r0
	mov.l	@(4,r15),r1
	mov.l	r1,@(8,r0)
	mov.l	@(48,r15),r0
	mov.l	@(4,r15),r1
	mov.l	r1,@r0
	mov.l	@(48,r15),r0
	mov.l	@(0,r15),r1
	mov.l	r1,@(4,r0)
	mov.l	@(52,r15),r0
L67:
	add	#60,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L124:	.short	255
L126:	.short	128
L112:	.long	_DAT_0604462c
L113:	.long	_DAT_060443e0
L114:	.long	_DAT_060443b4
L115:	.long	_DAT_060443e8
L116:	.long	_DAT_060443f0
L117:	.long	_DAT_06044638
L118:	.long	_DAT_060443f4
L119:	.long	_DAT_06044424
L120:	.long	_DAT_06044620
L121:	.long	_DAT_06044624
L122:	.long	_DAT_06044628
L123:	.long	_DAT_06044420
L125:	.long	0
L127:	.long	_DAT_06044634
L128:	.long	_DAT_06044630
L129:	.long	_DAT_06044640
L130:	.long	_DAT_0604463c
L131:	.long	_DAT_06044644
L132:	.long	_DAT_06044638
	.global _FUN_06044588
	.align 2
_FUN_06044588:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	add	#-16,r15
	mov.l	L147,r0
	mov.l	@r0,r0
	mov	r0,r12
	mov	r15,r1
	add	#4,r1
	mov.l	r1,@(8,r15)
	mov.l	L148,r1
	mov.l	@r1,r1
	mov.l	@r1,r8
	mov.l	@r0,r1
	mov.l	r1,@(4,r15)
	mov.l	@(4,r0),r1
	mov.l	r1,@(0,r15)
	mov.b	@(8,r0),r0
	tst	r0,r0
	bf	L134
	mov	#0,r0
	mov.b	r0,@(15,r15)
	mov.l	L149,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	mov	r8,r1
	mov.l	@(4,r0),r2
	add	r0,r2
	mov	r2,r0
	cmp/hs	r0,r1
	bt	L136
	mov.b	@r8+,r9
	extu.b	r9,r0
	exts.b	r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L143
	mov	#127,r1
	extu.b	r9,r0
	and	r1,r0
	bra	L135
	mov.b	r0,@(15,r15)
L140:
	mov	#1,r1
	extu.b	r9,r0
	and	r1,r0
	tst	r0,r0
	bt	L144
	mov.b	@r8+,r14
	mov.l	@(8,r15),r1
	mov.b	r14,@r1
L144:
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(8,r15)
	extu.b	r9,r0
	exts.b	r0,r0
	shar	r0
	mov	r0,r9
L143:
	extu.b	r9,r0
	tst	r0,r0
	bf	L140
	bra	L135
	nop
L136:
	mov.l	@(0,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(0,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
	mov.l	L150,r0
	mov.l	@r0,r0
	mov	#0,r1
	bra	L135
	mov.b	r1,@r0
L134:
	mov.l	L147,r0
	mov.l	@r0,r0
	mov.b	@(8,r0),r0
	mov	#1,r1
	sub	r1,r0
	mov.b	r0,@(15,r15)
L135:
	mov.l	L151,r0
	mov.l	@r0,r10
	mov.l	L148,r0
	mov.l	@r0,r11
	mov.b	@(15,r15),r0
	extu.b	r0,r0
	mov.b	r0,@(8,r12)
	mov	r8,r0
	mov.l	r0,@r11
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov.w	r0,@r10
	mov.w	@(4,r12),r0
	mov.w	r0,@(6,r10)
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	extu.w	r0,r1
	extu.w	r13,r0
	not	r0,r0
	and	r0,r1
	mov	r1,r0
	mov.w	r0,@(2,r10)
	mov.l	L152,r0
	mov.l	@r0,r0
	add	#5,r0
	mov	r0,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r0
	mov.l	r0,@(8,r10)
	mov.l	@(4,r15),r0
	mov.l	r0,@r12
	mov.l	@(0,r15),r0
	mov.l	r0,@(4,r12)
	add	#16,r15
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L147:	.long	_DAT_06044648
L148:	.long	_DAT_0604464c
L149:	.long	_DAT_06044650
L150:	.long	_DAT_06044654
L151:	.long	_DAT_06044658
L152:	.long	_DAT_0604465c
	.global _FUN_060446f4
	.align 2
_FUN_060446f4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L162,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	@r0,r0
	mov	r0,r11
	mov.l	L163,r0
	mov.l	@r0,r0
	mov.w	r0,@r11
	mov.l	L164,r0
	mov.l	@r0,r0
	mov	r0,r10
	mov.l	L166,r3
	mov.l	L165,r0
	mov.l	@r0,r0
	mov.l	L166,r3
	jsr	@r3
	mov.l	r10,@(20,r11)
	mov.l	L167,r0
	mov.l	@r0,r0
	mov.l	@r0,r13
	mov.l	L168,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	bra	L157
	mov	r0,r12
L154:
	mov.l	L169,r3
	jsr	@r3
	mov	r13,r4
	mov.l	L170,r0
	mov.l	@r0,r0
	mov	r13,r0
	add	r0,r0
	mov.l	@r0,r13
	add	#-1,r12
L157:
	tst	r12,r12
	bf	L154
	mov.l	L171,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bt	L158
	mov.l	L172,r0
	mov.l	@r0,r0
	mov	r0,r10
	mov	r8,r0
	add	#18,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L160
	mov.l	L173,r0
	mov.l	@r0,r0
	mov	r0,r10
L160:
	mov.l	L169,r3
	jsr	@r3
	mov	r10,r4
L158:
	mov	r11,r0
	add	#32,r0
	mov.l	r0,@r9
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
L162:	.long	_DAT_06044768
L163:	.long	_DAT_06044762
L164:	.long	_DAT_06044784
L165:	.long	_DAT_06044780
L166:	.long	_FUN_06044834
L167:	.long	_DAT_0604476c
L168:	.long	_DAT_06044770
L169:	.long	_FUN_06044788
L170:	.long	_DAT_06044764
L171:	.long	_DAT_06044774
L172:	.long	_DAT_06044778
L173:	.long	_DAT_0604477c
	.global _FUN_06044788
	.align 2
_FUN_06044788:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov.l	@(0,r15),r0
	mov.l	@r14,r1
	mov.l	@r0,r2
	sub	r2,r1
	mov	r1,r10
	add	#8,r0
	mov.l	@r0,r0
	mov.l	@(8,r14),r1
	sub	r1,r0
	mov	r0,r9
	mov	r10,r12
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L175
	not	r10,r0
	mov	r0,r12
	add	#1,r12
L175:
	mov	r12,r0
	mov.l	L185,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L177
	mov	r9,r12
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L179
	not	r9,r0
	mov	r0,r12
	add	#1,r12
L179:
	mov	r12,r0
	mov.l	L185,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L181
	mov.l	L186,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r0
	mov.l	L187,r3
	jsr	@r3
	neg	r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r12
	sub	r0,r12
	mov.l	L188,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L183
	not	r12,r0
	mov	r0,r12
	add	#1,r12
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L183:
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	mov	#7,r1
	and	r1,r0
	mov.l	L189,r1
	add	r1,r0
	mov.b	@r0,r13
	mov.l	L190,r0
	mov.l	@r0,r1
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	shlr2	r0
	mov	#3,r2
	and	r2,r0
	mov.l	L191,r2
	add	r2,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	or	r0,r1
	mov	r1,r0
	mov.w	r0,@r8
	mov.l	L192,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r8)
	mov.l	L193,r0
	mov.l	@r0,r1
	mov	r13,r0
	shll16	r0
	add	r0,r1
	mov.l	r1,@(8,r8)
	mov.l	L194,r0
	mov.l	@r0,r0
	mov	r10,r1
	shlr16	r1
	exts.w	r1,r1
	add	r1,r0
	mov.w	r0,@(12,r8)
	mov.l	L195,r0
	mov.l	@r0,r0
	mov	r9,r1
	shlr16	r1
	mov	r0,r0
	add	r1,r0
	mov.w	r0,@(14,r8)
L181:
L177:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L185:	.long	_DAT_06044814
L186:	.long	_FUN_06044834
L187:	.long	_PTR_FUN_06044818
L188:	.long	_DAT_0604481c
L189:	.long	_DAT_06044828
L190:	.long	_DAT_0604480c
L191:	.long	_DAT_06044830
L192:	.long	_DAT_06044820
L193:	.long	_DAT_06044824
L194:	.long	_DAT_0604480e
L195:	.long	_DAT_06044810
	.global _FUN_06044834
	.align 2
_FUN_06044834:
	mov.w	@(14,r4),r0
	mov	r0,r1
	mov	#26,r0
	mov.w	@(r0,r4),r0
	add	r0,r1
	mov	#30,r0
	mov.w	@(r0,r4),r0
	add	r0,r1
	rts
	neg	r1,r0
	.global _FUN_06044848
	.align 2
_FUN_06044848:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r4,r8
	mov.l	L208,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	@r0,r12
	mov.l	L209,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L198
	mov.l	L210,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L200
	mov.l	L211,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L200
	mov.l	L212,r0
	mov.l	@r0,r11
	mov.l	L213,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L202
	mov.l	L214,r0
	mov.l	@r0,r11
L202:
	mov.l	L215,r0
	mov.l	@r0,r1
	mov.l	L216,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	shll8	r0
	mov	r1,r4
	add	r0,r4
	mov.l	L217,r3
	jsr	@r3
	mov	r11,r5
L200:
	mov.l	L218,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L204
	mov.l	L220,r5
	mov.l	L219,r4
	mov.l	L217,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
L204:
	mov	r8,r4
	mov.l	L221,r0
	mov.w	@r0,r0
	mov	r8,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L222,r5
	add	r0,r5
	mov.l	L217,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	r12,@r9
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L198:
	mov	r8,r4
	mov.l	L223,r0
	mov.w	@r0,r0
	mov	r8,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L222,r5
	add	r0,r5
	mov.l	L217,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L224,r0
	mov.l	@r0,r10
	mov	r8,r0
	add	#18,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L206
	mov.l	L225,r0
	mov.l	@r0,r10
L206:
	mov	r10,r4
	mov.l	L223,r0
	mov.w	@r0,r0
	mov	r10,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L222,r5
	add	r0,r5
	mov.l	L226,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	r12,@r9
L197:
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
L222:	.short	100944200
	.align 2
L208:	.long	_puRam060448d0
L209:	.long	_pcRam060448d8
L210:	.long	_pcRam060448dc
L211:	.long	_pcRam060448e0
L212:	.long	_uRam060448ec
L213:	.long	_pcRam060448f0
L214:	.long	_uRam060448f4
L215:	.long	_iRam060448e8
L216:	.long	_pcRam060448e4
L217:	.long	_FUN_060449ac
L218:	.long	_pcRam060448f8
L219:	.long	_uRam060448fc
L220:	.long	_uRam06044900
L221:	.long	_sRam060448ce
L223:	.long	_sRam0604493e
L224:	.long	_iRam06044940
L225:	.long	_iRam06044944
L226:	.long	_FUN_060449a0
	.global _FUN_060449a0
	.align 2
_FUN_060449a0:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r10
	mov.l	@r14,r8
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L230,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L231,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L232,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r10
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r9
	mov.w	@(10,r0),r0
	dmuls.l	r0,r8
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(10,r15)
	mov.l	L233,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L228
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L228:
	mov.l	@(0,r15),r0
	exts.w	r9,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	add	#2,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L234,r0
	mov.w	@r0,r0
	mov	r0,r8
	mov	r8,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov	r0,r10
	mov.l	@(4,r15),r0
	mov.l	L235,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	L236,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(4,r15),r0
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov.l	@(4,r15),r1
	mov.l	L237,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L238,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L239,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L240,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L241,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L242,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L243,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L244,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L242:	.short	100944529
L244:	.short	100944531
L230:	.long	_pcRam06044a70
L231:	.long	_FUN_06044834
L232:	.long	_sRam06044a68
L233:	.long	_pcRam06044a74
L234:	.long	_sRam06044a6a
L235:	.long	_uRam06044a6c
L236:	.long	_uRam06044a78
L237:	.long	100944524
L238:	.long	100944525
L239:	.long	100944526
L240:	.long	100944527
L241:	.long	100944528
L243:	.long	100944530
	.global _FUN_060449ac
	.align 2
_FUN_060449ac:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r10
	mov.l	@r14,r8
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L248,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L249,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L250,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r10
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r9
	mov.w	@(10,r0),r0
	dmuls.l	r0,r8
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(10,r15)
	mov.l	L251,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L246
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L246:
	mov.l	@(0,r15),r0
	exts.w	r9,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	add	#2,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L252,r0
	mov.w	@r0,r0
	mov	r0,r8
	mov	r8,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov	r0,r10
	mov.l	@(4,r15),r0
	mov.l	L253,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	L254,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(4,r15),r0
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov.l	@(4,r15),r1
	mov.l	L255,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L256,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L257,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L258,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L259,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L260,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L261,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L262,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L260:	.short	100944513
L262:	.short	100944515
L248:	.long	_pcRam06044a70
L249:	.long	_FUN_06044834
L250:	.long	_sRam06044a68
L251:	.long	_pcRam06044a74
L252:	.long	_sRam06044a6a
L253:	.long	_uRam06044a6c
L254:	.long	_uRam06044a78
L255:	.long	100944508
L256:	.long	100944509
L257:	.long	100944510
L258:	.long	100944511
L259:	.long	100944512
L261:	.long	100944514
	.global _FUN_060449b6
	.align 2
_FUN_060449b6:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-20,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r9
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L266,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L267,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L268,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r9
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r8
	mov.w	@(10,r0),r0
	mov.l	@(16,r15),r1
	dmuls.l	r0,r1
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(14,r15)
	mov.l	L269,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L264
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r8
	mov.w	@(14,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
L264:
	mov.l	@(0,r15),r0
	exts.w	r8,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r8
	mov.w	@(14,r15),r0
	mov	r0,r1
	mov.w	@(2,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
	mov.l	L270,r0
	mov.w	@r0,r0
	mov	r0,r9
	mov.l	@(8,r15),r0
	mov.l	L271,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(8,r15),r0
	mov.l	L272,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(8,r15),r0
	mov	r9,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov	r9,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r10
	mov.l	@(8,r15),r1
	mov.b	@r10,r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(8,r15),r1
	mov.b	@(1,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(8,r15),r1
	mov.b	@(2,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(8,r15),r1
	mov.b	@(3,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(8,r15),r1
	mov.b	@(4,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(8,r15),r1
	mov.b	@(5,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(8,r15),r1
	mov.b	@(6,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(8,r15),r1
	mov.b	@(7,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#20,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L266:	.long	_pcRam06044a70
L267:	.long	_FUN_06044834
L268:	.long	_sRam06044a68
L269:	.long	_pcRam06044a74
L270:	.long	_sRam06044a6a
L271:	.long	_uRam06044a6c
L272:	.long	_uRam06044a78
	.global _FUN_06044a9a
	.align 2
_FUN_06044a9a:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov.l	L274,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	@r0,r0
	mov	r0,r12
	mov.l	L275,r0
	mov.l	@r0,r0
	mov.w	r0,@r12
	mov.l	L276,r0
	mov.l	@r0,r0
	mov	r0,r13
	mov.l	L278,r4
	mov.l	L279,r3
	mov.l	L277,r0
	mov.l	@r0,r0
	mov.l	L278,r4
	mov.l	L279,r3
	jsr	@r3
	mov.l	L280,r4
	mov.l	L281,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r0
	add	#32,r0
	mov.l	L275,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	L282,r0
	mov.l	@r0,r0
	mov	r0,r13
	mov.l	L280,r4
	mov.l	L279,r3
	mov.l	L283,r0
	mov.l	@r0,r0
	mov.l	L280,r4
	mov.l	L279,r3
	jsr	@r3
	mov.l	L278,r4
	mov.l	L281,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r0
	add	#64,r0
	mov.l	r0,@r14
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L274:	.long	_DAT_06044b04
L275:	.long	_DAT_06044afe
L276:	.long	_DAT_06044b14
L277:	.long	_DAT_06044b10
L278:	.long	_DAT_06044b08
L279:	.long	_FUN_06044834
L280:	.long	_DAT_06044b0c
L281:	.long	_FUN_06044b20
L282:	.long	_DAT_06044b1c
L283:	.long	_DAT_06044b18
	.global _FUN_06044ada
	.align 2
_FUN_06044ada:
	sts.l	pr,@-r15
	mov.l	L285,r4
	mov.l	L286,r3
	jsr	@r3
	mov.l	L287,r4
	mov.l	L288,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r14
	.align 2
L285:	.long	_DAT_06044b0c
L286:	.long	_FUN_06044834
L287:	.long	_DAT_06044b08
L288:	.long	_FUN_06044b20
	.global _FUN_06044b20
	.align 2
_FUN_06044b20:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	@(0,r15),r0
	mov.l	@r14,r1
	mov.l	@r0,r2
	sub	r2,r1
	mov	r1,r10
	add	#8,r0
	mov.l	@r0,r0
	mov.l	@(8,r14),r1
	sub	r1,r0
	mov	r0,r9
	mov	r10,r12
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L290
	not	r10,r0
	mov	r0,r12
	add	#1,r12
L290:
	mov	r12,r0
	mov.l	L300,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L292
	mov	r9,r12
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L294
	not	r9,r0
	mov	r0,r12
	add	#1,r12
L294:
	mov	r12,r0
	mov.l	L300,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L296
	mov.l	L301,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r0
	mov.l	L302,r3
	jsr	@r3
	neg	r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r12
	sub	r0,r12
	mov.l	L303,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L298
	not	r12,r0
	mov	r0,r12
	add	#1,r12
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L298:
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	mov	#7,r1
	and	r1,r0
	mov.l	L304,r1
	add	r1,r0
	mov.b	@r0,r13
	mov.l	L305,r0
	mov.l	@r0,r1
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	shlr2	r0
	mov	#3,r2
	and	r2,r0
	mov.l	L306,r2
	add	r2,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	or	r0,r1
	mov	r1,r0
	mov.w	r0,@r8
	mov.l	L307,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r8)
	mov.l	L308,r0
	mov.l	@r0,r1
	mov	r13,r0
	shll16	r0
	add	r0,r1
	mov.l	r1,@(8,r8)
	mov.l	L309,r0
	mov.l	@r0,r0
	mov	r10,r1
	shlr16	r1
	shlr	r1
	extu.w	r1,r1
	add	r1,r0
	mov.w	r0,@(12,r8)
	mov	r9,r0
	shlr16	r0
	shlr	r0
	mov.l	@(8,r15),r1
	mov	r0,r0
	add	r1,r0
	mov.w	r0,@(14,r8)
L296:
L292:
	add	#12,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L300:	.long	_DAT_06044bac
L301:	.long	_FUN_06044834
L302:	.long	_PTR_FUN_06044bb0
L303:	.long	_DAT_06044bb4
L304:	.long	_DAT_06044bc0
L305:	.long	_DAT_06044ba8
L306:	.long	_DAT_06044bc8
L307:	.long	_DAT_06044bb8
L308:	.long	_DAT_06044bbc
L309:	.long	_DAT_06044baa
	.global _FUN_06044bcc
	.align 2
_FUN_06044bcc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	mov.l	L323,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
	mov.l	L324,r0
	mov.l	@r0,r12
	mov.l	L325,r0
	mov.l	@r0,r11
	mov.l	L326,r0
	mov.l	@r0,r10
	mov.l	L327,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	L328,r1
	mov.l	@r1,r14
	mov.b	@r0,r0
	tst	r0,r0
	bf	L311
	mov	#0,r0
	mov.l	r0,@(4,r15)
	mov	#0,r0
	mov.l	r0,@(16,r15)
L313:
	mov.l	L329,r0
	mov.l	@r0,r0
	mov	r0,r8
	mov.l	@(16,r15),r1
	mov	r14,r3
	extu.b	r1,r2
	mov	r2,r3
	add	r3,r3
	mov.l	r3,@(20,r15)
	mov	#3,r3
	mov.b	@r10,r4
	muls.w	r4,r3
	sts	macl,r3
	mov.b	@r11,r4
	exts.w	r4,r4
	add	r4,r3
	mul.l	r0,r3
	sts	macl,r0
	exts.w	r0,r0
	add	r12,r0
	add	r2,r0
	mov	r0,r13
	mov	r1,r0
	add	#12,r0
	extu.b	r0,r0
	mov.l	r0,@(8,r15)
	mov.l	@(20,r15),r0
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov.l	@(8,r15),r0
	mov	r14,r1
	mov	r0,r1
	add	r1,r1
	mov.l	r1,@(20,r15)
	mov.l	@(4,r15),r1
	add	#2,r1
	mov.l	r1,@(4,r15)
	mov	#3,r1
	mov.b	@r10,r2
	muls.w	r2,r1
	sts	macl,r1
	mov.b	@r11,r2
	exts.w	r2,r2
	add	r2,r1
	exts.w	r8,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	add	r12,r1
	add	r0,r1
	mov	r1,r13
	mov.l	@(20,r15),r0
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov.l	@(16,r15),r0
	add	#24,r0
	mov.l	r0,@(16,r15)
	mov.l	@(4,r15),r0
	mov	#20,r1
	cmp/ge	r1,r0
	bf	L313
	bra	L312
	nop
L311:
	mov.l	L328,r0
	mov.l	@r0,r0
	mov	r0,r13
	add	#60,r13
	mov	#0,r0
	bra	L319
	mov.b	r0,@(3,r15)
L316:
	mov	#60,r1
	mov.b	@r10,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.w	r0,r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.b	@(3,r15),r0
	mov	r2,r0
	add	r0,r0
	mov.l	r0,@(20,r15)
	mov.l	@(20,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@r14
	mov	r14,r0
	add	#4,r0
	mov.l	@(20,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#8,r0
	mov.l	@(20,r15),r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#12,r0
	mov.b	r0,@(3,r15)
	add	#12,r14
L319:
	mov	r14,r0
	mov	r13,r1
	cmp/hs	r1,r0
	bf	L316
L312:
	mov.l	L330,r0
	mov.l	@r0,r12
	mov.l	L331,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov	#0,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov	r1,r0
	mov.b	r0,@(3,r15)
	mov	#24,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	extu.b	r1,r1
	mov.l	L332,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r1,r13
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#12,r0
	mov.l	@(12,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#16,r0
	mov.l	@(16,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#20,r0
	mov.l	@(20,r13),r1
	mov.l	r1,@r0
	mov.l	L333,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
L320:
	mov.b	@(3,r15),r0
	mov	r0,r13
	add	r12,r13
	mov	#48,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	exts.w	r3,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.l	@r14,r0
	mov.l	r0,@r13
	mov	r13,r0
	add	#4,r0
	mov.l	@(4,r14),r1
	mov.l	r1,@r0
	mov	r13,r0
	add	#8,r0
	mov.l	@(8,r14),r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#12,r0
	exts.b	r0,r0
	mov	r0,r13
	add	r12,r13
	mov.l	@(12,r15),r1
	add	#2,r1
	mov.l	r1,@(12,r15)
	mov	#48,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	exts.w	r3,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.l	@r14,r0
	mov.l	r0,@r13
	mov	r13,r0
	add	#4,r0
	mov.l	@(4,r14),r1
	mov.l	r1,@r0
	mov	r13,r0
	add	#8,r0
	mov.l	@(8,r14),r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#24,r0
	mov.b	r0,@(3,r15)
	mov.l	@(12,r15),r0
	mov	#4,r1
	cmp/ge	r1,r0
	bf	L320
	add	#24,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L323:	.long	_DAT_06044d50
L324:	.long	_DAT_06044c64
L325:	.long	_DAT_06044c60
L326:	.long	_DAT_06044c5c
L327:	.long	_DAT_06044c58
L328:	.long	_DAT_06044c54
L329:	.long	_DAT_06044c52
L330:	.long	_DAT_06044d5c
L331:	.long	_DAT_06044d58
L332:	.long	_DAT_06044d54
L333:	.long	_DAT_06044d60
	.global _FUN_06044d64
	.align 2
_FUN_06044d64:
	sts.l	pr,@-r15
	mov.l	L335,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L335:	.long	_FUN_06044d74
	.global _FUN_06044d74
	.align 2
_FUN_06044d74:
	mov.l	L339,r0
	mov.l	@r0,r7
	mov.l	L340,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L337
	mov.l	L341,r0
	mov.l	@r0,r7
L337:
	mov.l	L342,r0
	mov.l	r0,@r7
	mov	#0,r0
	mov.l	r0,@(4,r14)
	mov	#0,r0
	mov.l	r0,@(8,r14)
	mov	#0,r0
	mov.l	r0,@(12,r14)
	mov	#0,r0
	mov.l	r0,@(16,r14)
	mov.l	L342,r0
	mov.l	r0,@(20,r14)
	mov	#0,r0
	mov.l	r0,@(24,r14)
	mov	#0,r0
	mov.l	r0,@(28,r14)
	mov	#0,r0
	mov.l	r0,@(32,r14)
	mov	#0,r0
	mov.l	r0,@(36,r14)
	mov.l	L342,r0
	mov.l	r0,@(40,r14)
	mov	#0,r0
	rts
	mov.l	r0,@(44,r14)
	.align 2
L339:	.long	_DAT_06044da0
L340:	.long	__DAT_ffffffe2
L341:	.long	_DAT_06044da4
L342:	.long	65536
	.global _FUN_06044d80
	.align 2
_FUN_06044d80:
	mov.l	L344,r0
	mov.l	r0,@r4
	mov	#0,r0
	mov.l	r0,@(4,r4)
	mov	#0,r0
	mov.l	r0,@(8,r4)
	mov	#0,r0
	mov.l	r0,@(12,r4)
	mov	#0,r0
	mov.l	r0,@(16,r4)
	mov.l	L344,r0
	mov.l	r0,@(20,r4)
	mov	#0,r0
	mov.l	r0,@(24,r4)
	mov	#0,r0
	mov.l	r0,@(28,r4)
	mov	#0,r0
	mov.l	r0,@(32,r4)
	mov	#0,r0
	mov.l	r0,@(36,r4)
	mov.l	L344,r0
	mov.l	r0,@(40,r4)
	mov	#0,r0
	rts
	mov.l	r0,@(44,r4)
	.align 2
L344:	.long	65536
	.global _FUN_06044da8
	.align 2
_FUN_06044da8:
	sts.l	pr,@-r15
	mov.l	L346,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L346:	.long	_FUN_06044db8
	.global _FUN_06044db8
	.align 2
_FUN_06044db8:
	mov.l	@r4,r0
	mov.l	r0,@(48,r4)
	mov.l	@(4,r4),r0
	mov.l	r0,@(52,r4)
	mov.l	@(8,r4),r0
	mov.l	r0,@(56,r4)
	mov.l	@(12,r4),r0
	mov.l	r0,@(60,r4)
	mov	r4,r0
	add	#64,r0
	mov.l	@(16,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#68,r0
	mov.l	@(20,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#72,r0
	mov.l	@(24,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov.l	@(28,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#80,r0
	mov.l	@(32,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#84,r0
	mov.l	@(36,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov.l	@(40,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#92,r0
	mov.l	@(44,r4),r1
	rts
	mov.l	r1,@r0
	.global _FUN_06044e28
	.align 2
_FUN_06044e28:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	r13,@(0,r15)
	mov	r12,r9
	mov	r11,r8
	mov	r15,r5
	mov.l	L349,r3
	jsr	@r3
	add	#4,r15
	lds.l	@r15+,pr
	rts
	add	#0,r5
	.align 2
L349:	.long	_FUN_06044e3c
	.global _FUN_06044e3c
	.align 2
_FUN_06044e3c:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-20,r15
	mov	#3,r8
L351:
	mov.l	@r5,r10
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r10,r9
	xor	r0,r9
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L354
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L354:
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L356
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L356:
	mov.l	@(12,r15),r0
	extu.w	r0,r1
	extu.w	r10,r2
	mul.l	r2,r1
	sts	macl,r6
	shlr16	r0
	mul.l	r2,r0
	sts	macl,r0
	mov	r0,r11
	mov	#0,r0
	mov	r0,r7
	mov	r11,r0
	mov	r10,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r14
	tst	r11,r11
	bt/s	L358
	add	r1,r14
	mov.l	L432,r7
L358:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L362
	mov	#1,r14
L361:
	mov	#0,r14
L362:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov.l	@(12,r15),r1
	shlr16	r1
	mov	r10,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L367
	mov	r15,r14
	bra	Lm76
	mov	#0,r0
L367:
	mov	#1,r0
Lm76:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L363
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L368
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L369
	mov.l	r0,@(12,r15)
L368:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L369:
L363:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L370
	mov.l	@(12,r15),r0
	mov.w	L433,r1
	cmp/ge	r1,r0
	bt	L372
	mov.w	L433,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L372:
	mov.w	L434,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L374
	mov.w	L434,r0
	mov.l	r0,@(12,r15)
	mov.w	L435,r0
	mov.l	r0,@(8,r15)
L374:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L370:
	mov.l	@(4,r5),r9
	mov.l	@(4,r4),r10
	mov	r9,r14
	xor	r10,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L376
	not	r9,r0
	mov	r0,r9
	add	#1,r9
L376:
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L378
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L378:
	extu.w	r10,r0
	extu.w	r9,r1
	mul.l	r1,r0
	sts	macl,r2
	mov.l	r2,@(0,r15)
	mov	r10,r2
	shlr16	r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r11
	mov	#0,r1
	mov	r1,r7
	mov	r11,r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r0
	sts	macl,r0
	mov	r1,r6
	tst	r11,r11
	bt/s	L380
	add	r0,r6
	mov.l	L432,r7
L380:
	mov.l	@(0,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L384
	mov	#1,r14
L383:
	mov	#0,r14
L384:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r10
	add	r1,r10
	mov	r14,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L389
	mov	r15,r14
	bra	Lm207
	mov	#0,r0
	.align 2
L433:	.short	-32768
L434:	.short	32767
L435:	.short	-1
L389:
	mov	#1,r0
Lm207:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L385
	not	r10,r10
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L390
	bra	L391
	add	#1,r10
L390:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L391:
L385:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L392
	mov.l	@(8,r15),r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L396
	mov	r15,r14
	bra	Lm246
	mov	#0,r0
L396:
	mov	#1,r0
Lm246:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	add	r0,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L438,r1
	cmp/ge	r1,r0
	bt	L397
	mov.w	L438,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L397:
	mov.w	L439,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L399
	mov.w	L439,r0
	mov.l	r0,@(12,r15)
	mov.w	L440,r0
	mov.l	r0,@(4,r15)
L399:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L393
	mov.l	r0,@(12,r15)
L392:
	mov.l	@(8,r15),r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L403
	mov	r15,r14
	bra	Lm289
	mov	#0,r0
L403:
	mov	#1,r0
Lm289:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	add	r0,r1
	mov.l	r1,@(12,r15)
L393:
	mov.l	@(8,r5),r9
	mov.l	@(8,r4),r10
	mov	r9,r14
	xor	r10,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L404
	not	r9,r0
	mov	r0,r9
	add	#1,r9
L404:
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L406
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L406:
	extu.w	r10,r0
	extu.w	r9,r1
	mul.l	r1,r0
	sts	macl,r2
	mov.l	r2,@(8,r15)
	mov	r10,r2
	shlr16	r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r11
	mov	#0,r1
	mov	r1,r7
	mov	r11,r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r0
	sts	macl,r0
	mov	r1,r6
	tst	r11,r11
	bt/s	L408
	add	r0,r6
	mov.l	L437,r7
L408:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L412
	mov	#1,r14
L411:
	mov	#0,r14
L412:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r10
	add	r1,r10
	mov	r14,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L417
	mov	r15,r14
	bra	Lm375
	mov	#0,r0
L417:
	mov	#1,r0
Lm375:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L413
	not	r10,r10
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L418
	bra	L419
	add	#1,r10
L418:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L419:
L413:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L420
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L424
	mov	r15,r14
	bra	Lm414
	mov	#0,r0
L424:
	mov	#1,r0
Lm414:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	add	r0,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L441,r1
	cmp/ge	r1,r0
	bt	L425
	mov.w	L441,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L425:
	mov.w	L442,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L427
	mov.w	L442,r0
	mov.l	r0,@(12,r15)
	mov.w	L443,r0
	mov.l	r0,@(0,r15)
L427:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L421
	mov.l	r0,@(12,r15)
L420:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L431
	mov	r15,r14
	bra	Lm457
	mov	#0,r0
L431:
	mov	#1,r0
Lm457:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	add	r0,r1
	mov.l	r1,@(12,r15)
L421:
	mov	r4,r0
	add	#12,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	@r0,r2
	add	r2,r1
	mov.l	r1,@r0
	add	#-1,r8
	mov.l	@(16,r15),r0
	mov.w	L436,r1
	and	r1,r0
	mov.l	r0,@(16,r15)
	add	#16,r4
	tst	r8,r8
	bf	L351
	add	#20,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L436:	.short	-2
L438:	.short	-32768
L439:	.short	32767
L440:	.short	-1
L441:	.short	-32768
L442:	.short	32767
L443:	.short	-1
	.align 2
L432:	.long	65536
L437:	.long	65536
	.global _FUN_06045006
	.align 2
_FUN_06045006:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L550,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L445
	mov.l	L550,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L550:	.long	_DAT_06045070
L445:
	mov.l	L551,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L447:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L450
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L450:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L452
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L452:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L454
	add	r0,r14
	mov.l	L552,r7
L454:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L458
	mov	#1,r14
L457:
	mov	#0,r14
L458:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L463
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L551:	.short	-2
L463:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L459
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L464
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L465
	mov.l	r0,@(16,r15)
L464:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L465:
L459:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L466
	mov.l	@(16,r15),r0
	mov.w	L553,r1
	cmp/ge	r1,r0
	bt	L468
	mov.w	L553,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L468:
	mov.w	L554,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L470
	mov.w	L554,r0
	mov.l	r0,@(16,r15)
	mov.w	L555,r0
	mov.l	r0,@(8,r15)
L470:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L466:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L472
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L472:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L474
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L474:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L476
	add	r0,r6
	mov.l	L552,r7
L476:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L480
	mov	#1,r14
L479:
	mov	#0,r14
L480:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L485
	mov	r15,r14
	bra	Lm251
	mov	#0,r0
	.align 2
L553:	.short	-32768
L554:	.short	32767
L555:	.short	-1
	.align 2
L552:	.long	65536
L485:
	mov	#1,r0
Lm251:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L481
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L486
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L487
	mov.l	r0,@(12,r15)
L486:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L487:
L481:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L488
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L492
	mov	#1,r14
L491:
	mov	#0,r14
L492:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L559,r1
	cmp/ge	r1,r0
	bt	L493
	mov.w	L559,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L493:
	mov.w	L560,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L495
	mov.w	L560,r0
	mov.l	r0,@(16,r15)
	mov.w	L561,r0
	mov.l	r0,@(0,r15)
L495:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L489
	mov.l	r0,@(16,r15)
	.align 2
L559:	.short	-32768
L560:	.short	32767
L561:	.short	-1
L488:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L499
	mov	#1,r14
L498:
	mov	#0,r14
L499:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L489:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L500
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L500:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L502
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L502:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L504
	add	r0,r6
	mov.l	L558,r7
L504:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L508
	mov	#1,r14
L507:
	mov	#0,r14
L508:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L513
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
L513:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L509
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L514
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L515
	mov.l	r0,@(12,r15)
L514:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L515:
L509:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L516
	mov.l	@(12,r15),r0
	mov.w	L562,r1
	cmp/ge	r1,r0
	bt	L518
	mov.w	L562,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L518:
	mov.w	L563,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L520
	mov.w	L563,r0
	mov.l	r0,@(12,r15)
	mov.w	L564,r0
	mov.l	r0,@(4,r15)
L520:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L516:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L522
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L522:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L524
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L524:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L526
	add	r0,r6
	mov.l	L558,r7
L526:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L530
	mov	#1,r14
L529:
	mov	#0,r14
L530:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L535
	mov	r15,r14
	bra	Lm570
	mov	#0,r0
L535:
	mov	#1,r0
Lm570:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L531
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L536
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L537
	mov.l	r0,@(16,r15)
L536:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L537:
L531:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L538
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L542
	mov	#1,r14
L541:
	mov	#0,r14
L542:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L565,r1
	cmp/ge	r1,r0
	bt	L543
	mov.w	L565,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L543:
	mov.w	L566,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L545
	mov.w	L566,r0
	mov.l	r0,@(16,r15)
	mov.w	L567,r0
	mov.l	r0,@(0,r15)
L545:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L556,r2
	and	r2,r1
	or	r1,r0
	bra	L539
	mov.l	r0,@(12,r15)
L538:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L549
	mov	#1,r14
L548:
	mov	#0,r14
L549:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L539:
	add	#-1,r8
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L557,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L447
	mov.l	@(12,r15),r0
L444:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L556:	.short	-65536
L562:	.short	-32768
L563:	.short	32767
L564:	.short	-1
L565:	.short	-32768
L566:	.short	32767
L567:	.short	-1
	.align 2
L557:	.long	_PTR_DAT_06045074
L558:	.long	65536
	.global _FUN_06045008
	.align 2
_FUN_06045008:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L674,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L569
	mov.l	L674,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L674:	.short	-65536
L569:
	mov.l	L675,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L571:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L574
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L574:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L576
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L576:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L578
	add	r0,r14
	mov.l	L676,r7
L578:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L582
	mov	#1,r14
L581:
	mov	#0,r14
L582:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L587
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L675:	.short	-2
L587:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L583
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L588
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L589
	mov.l	r0,@(16,r15)
L588:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L589:
L583:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L590
	mov.l	@(16,r15),r0
	mov.w	L677,r1
	cmp/ge	r1,r0
	bt	L592
	mov.w	L677,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L592:
	mov.w	L678,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L594
	mov.w	L678,r0
	mov.l	r0,@(16,r15)
	mov.w	L679,r0
	mov.l	r0,@(8,r15)
L594:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L590:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L596
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L596:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L598
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L598:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L600
	add	r0,r6
	mov.l	L676,r7
L600:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L604
	mov	#1,r14
L603:
	mov	#0,r14
L604:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L609
	mov	r15,r14
	bra	Lm249
	mov	#0,r0
	.align 2
L677:	.short	-32768
L678:	.short	32767
L679:	.short	-1
	.align 2
L676:	.long	65536
L609:
	mov	#1,r0
Lm249:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L605
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L610
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L611
	mov.l	r0,@(12,r15)
L610:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L611:
L605:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L612
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L616
	mov	#1,r14
L615:
	mov	#0,r14
L616:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L683,r1
	cmp/ge	r1,r0
	bt	L617
	mov.w	L683,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L617:
	mov.w	L684,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L619
	mov.w	L684,r0
	mov.l	r0,@(16,r15)
	mov.w	L685,r0
	mov.l	r0,@(0,r15)
L619:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L613
	mov.l	r0,@(16,r15)
	.align 2
L683:	.short	-32768
L684:	.short	32767
L685:	.short	-1
L612:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L623
	mov	#1,r14
L622:
	mov	#0,r14
L623:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L613:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L624
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L624:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L626
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L626:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L628
	add	r0,r6
	mov.l	L682,r7
L628:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L632
	mov	#1,r14
L631:
	mov	#0,r14
L632:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L637
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
L637:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L633
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L638
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L639
	mov.l	r0,@(12,r15)
L638:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L639:
L633:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L640
	mov.l	@(12,r15),r0
	mov.w	L686,r1
	cmp/ge	r1,r0
	bt	L642
	mov.w	L686,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L642:
	mov.w	L687,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L644
	mov.w	L687,r0
	mov.l	r0,@(12,r15)
	mov.w	L688,r0
	mov.l	r0,@(4,r15)
L644:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L640:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L646
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L646:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L648
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L648:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L650
	add	r0,r6
	mov.l	L682,r7
L650:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L654
	mov	#1,r14
L653:
	mov	#0,r14
L654:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L659
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L659:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L655
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L660
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L661
	mov.l	r0,@(16,r15)
L660:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L661:
L655:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L662
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L666
	mov	#1,r14
L665:
	mov	#0,r14
L666:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L689,r1
	cmp/ge	r1,r0
	bt	L667
	mov.w	L689,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L667:
	mov.w	L690,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L669
	mov.w	L690,r0
	mov.l	r0,@(16,r15)
	mov.w	L691,r0
	mov.l	r0,@(0,r15)
L669:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L680,r2
	and	r2,r1
	or	r1,r0
	bra	L663
	mov.l	r0,@(12,r15)
L662:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L673
	mov	#1,r14
L672:
	mov	#0,r14
L673:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L663:
	add	#-1,r9
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L681,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L571
	mov.l	@(12,r15),r0
L568:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L680:	.short	-65536
L686:	.short	-32768
L687:	.short	32767
L688:	.short	-1
L689:	.short	-32768
L690:	.short	32767
L691:	.short	-1
	.align 2
L681:	.long	_PTR_DAT_06045074
L682:	.long	65536
	.global _FUN_06045020
	.align 2
_FUN_06045020:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L693:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L696
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L696:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L698
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L698:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L700
	add	r0,r14
	mov.l	L796,r7
L700:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L704
	mov	#1,r14
L703:
	mov	#0,r14
L704:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L709
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L796:	.short	65536
L709:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L705
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L710
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L711
	mov.l	r0,@(16,r15)
L710:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L711:
L705:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L712
	mov.l	@(16,r15),r0
	mov.w	L797,r1
	cmp/ge	r1,r0
	bt	L714
	mov.w	L797,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L714:
	mov.w	L798,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L716
	mov.w	L798,r0
	mov.l	r0,@(16,r15)
	mov.w	L799,r0
	mov.l	r0,@(8,r15)
L716:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L712:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L718
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L718:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L720
	mov	r5,r14
L720:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L722
	add	r0,r12
	mov.l	L801,r7
L722:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L726
	mov	#1,r14
L725:
	mov	#0,r14
L726:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L731
	mov	r15,r14
	bra	Lm210
	mov	#0,r0
	.align 2
L797:	.short	-32768
L798:	.short	32767
L799:	.short	-1
L801:	.short	65536
L731:
	mov	#1,r0
Lm210:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L727
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L732
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L733
	mov.l	r0,@(12,r15)
L732:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L733:
L727:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L734
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L738
	mov	#1,r14
L737:
	mov	#0,r14
L738:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L802,r1
	cmp/ge	r1,r0
	bt	L739
	mov.w	L802,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L739:
	mov.w	L803,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L741
	mov.w	L803,r0
	mov.l	r0,@(16,r15)
	mov.w	L804,r0
	mov.l	r0,@(0,r15)
L741:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L735
	mov.l	r0,@(16,r15)
	.align 2
L802:	.short	-32768
L803:	.short	32767
L804:	.short	-1
L734:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L745
	mov	#1,r14
L744:
	mov	#0,r14
L745:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L735:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L746
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L746:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L748
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L748:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L750
	add	r0,r12
	mov.l	L805,r7
L750:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L754
	mov	#1,r14
L753:
	mov	#0,r14
L754:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L759
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L805:	.short	65536
L759:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L755
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L760
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L761
	mov.l	r0,@(12,r15)
L760:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L761:
L755:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L762
	mov.l	@(12,r15),r0
	mov.w	L806,r1
	cmp/ge	r1,r0
	bt	L764
	mov.w	L806,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L764:
	mov.w	L807,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L766
	mov.w	L807,r0
	mov.l	r0,@(12,r15)
	mov.w	L808,r0
	mov.l	r0,@(4,r15)
L766:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L762:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L768
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L768:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L770
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L770:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L772
	add	r0,r12
	mov.l	L809,r7
L772:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L776
	mov	#1,r14
L775:
	mov	#0,r14
L776:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L781
	mov	r15,r14
	bra	Lm523
	mov	#0,r0
L781:
	mov	#1,r0
Lm523:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L777
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L782
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L783
	mov.l	r0,@(16,r15)
L782:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L783:
L777:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L784
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L788
	mov	#1,r14
L787:
	mov	#0,r14
L788:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L810,r1
	cmp/ge	r1,r0
	bt	L789
	mov.w	L810,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L789:
	mov.w	L811,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L791
	mov.w	L811,r0
	mov.l	r0,@(12,r15)
	mov.w	L812,r0
	mov.l	r0,@(0,r15)
L791:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L785
	mov.l	r0,@(12,r15)
L784:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L795
	mov	#1,r14
L794:
	mov	#0,r14
L795:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L785:
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L800,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	tst	r8,r8
	bf	L693
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L800:	.short	-2
L806:	.short	-32768
L807:	.short	32767
L808:	.short	-1
L809:	.short	65536
L810:	.short	-32768
L811:	.short	32767
L812:	.short	-1
	.global _FUN_0604507e
	.align 2
_FUN_0604507e:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L919,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L814
	mov.l	L919,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L919:	.short	-2
L814:
	mov.l	L920,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L816:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L819
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L819:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L821
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L821:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L823
	add	r0,r14
	mov.l	L921,r7
L823:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L827
	mov	#1,r14
L826:
	mov	#0,r14
L827:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L832
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L920:	.short	-32768
L921:	.short	65536
L832:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L828
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L833
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L834
	mov.l	r0,@(16,r15)
L833:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L834:
L828:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L835
	mov.l	@(16,r15),r0
	mov.w	L926,r1
	cmp/ge	r1,r0
	bt	L837
	mov.w	L926,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L837:
	mov.w	L922,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L839
	mov.w	L922,r0
	mov.l	r0,@(16,r15)
	mov.w	L923,r0
	mov.l	r0,@(8,r15)
L839:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L835:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L841
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L841:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L843
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L843:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L845
	add	r0,r6
	mov.l	L927,r7
L845:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L849
	mov	#1,r14
L848:
	mov	#0,r14
L849:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L854
	mov	r15,r14
	bra	Lm253
	mov	#0,r0
	.align 2
L922:	.short	32767
L923:	.short	-1
L926:	.short	-32768
L927:	.short	65536
L854:
	mov	#1,r0
Lm253:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L850
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L855
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L856
	mov.l	r0,@(12,r15)
L855:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L856:
L850:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L857
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L861
	mov	#1,r14
L860:
	mov	#0,r14
L861:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L930,r1
	cmp/ge	r1,r0
	bt	L862
	mov.w	L930,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L862:
	mov.w	L928,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L864
	mov.w	L928,r0
	mov.l	r0,@(16,r15)
	mov.w	L929,r0
	mov.l	r0,@(0,r15)
L864:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L858
	mov.l	r0,@(16,r15)
	.align 2
L928:	.short	32767
L929:	.short	-1
L930:	.short	-32768
L857:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L868
	mov	#1,r14
L867:
	mov	#0,r14
L868:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L858:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L869
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L869:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L871
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L871:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L873
	add	r0,r6
	mov.l	L931,r7
L873:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L877
	mov	#1,r14
L876:
	mov	#0,r14
L877:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L882
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
	.align 2
L931:	.short	65536
L882:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L878
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L883
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L884
	mov.l	r0,@(12,r15)
L883:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L884:
L878:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L885
	mov.l	@(12,r15),r0
	mov.w	L934,r1
	cmp/ge	r1,r0
	bt	L887
	mov.w	L934,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L887:
	mov.w	L932,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L889
	mov.w	L932,r0
	mov.l	r0,@(12,r15)
	mov.w	L933,r0
	mov.l	r0,@(4,r15)
L889:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L885:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L891
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L891:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L893
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L893:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L895
	add	r0,r6
	mov.l	L935,r7
L895:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L899
	mov	#1,r14
L898:
	mov	#0,r14
L899:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L904
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L904:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L900
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L905
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L906
	mov.l	r0,@(16,r15)
L905:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L906:
L900:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L907
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L911
	mov	#1,r14
L910:
	mov	#0,r14
L911:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L938,r1
	cmp/ge	r1,r0
	bt	L912
	mov.w	L938,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L912:
	mov.w	L936,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L914
	mov.w	L936,r0
	mov.l	r0,@(16,r15)
	mov.w	L937,r0
	mov.l	r0,@(0,r15)
L914:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L924,r2
	and	r2,r1
	or	r1,r0
	bra	L908
	mov.l	r0,@(12,r15)
L907:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L918
	mov	#1,r14
L917:
	mov	#0,r14
L918:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L908:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L925,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L816
	mov.l	@(12,r15),r0
L813:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L924:	.short	-65536
L932:	.short	32767
L933:	.short	-1
L935:	.short	65536
L936:	.short	32767
L937:	.short	-1
L925:	.long	_DAT_060450e4
L934:	.long	_PTR_DAT_060450e8
L938:	.long	_PTR_DAT_060450e8
	.global _FUN_06045080
	.align 2
_FUN_06045080:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L1045,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L940
	mov.l	L1045,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1045:	.short	-65536
L940:
	mov.l	L1046,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L942:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L945
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L945:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L947
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L947:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L949
	add	r0,r14
	mov.l	L1047,r7
L949:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L953
	mov	#1,r14
L952:
	mov	#0,r14
L953:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L958
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L1046:	.short	-2
L1047:	.short	65536
L958:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L954
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L959
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L960
	mov.l	r0,@(16,r15)
L959:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L960:
L954:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L961
	mov.l	@(16,r15),r0
	mov.w	L1048,r1
	cmp/ge	r1,r0
	bt	L963
	mov.w	L1048,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L963:
	mov.w	L1049,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L965
	mov.w	L1049,r0
	mov.l	r0,@(16,r15)
	mov.w	L1050,r0
	mov.l	r0,@(8,r15)
L965:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L961:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L967
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L967:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L969
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L969:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L971
	add	r0,r6
	mov.l	L1053,r7
L971:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L975
	mov	#1,r14
L974:
	mov	#0,r14
L975:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L980
	mov	r15,r14
	bra	Lm252
	mov	#0,r0
	.align 2
L1048:	.short	-32768
L1049:	.short	32767
L1050:	.short	-1
L1053:	.short	65536
L980:
	mov	#1,r0
Lm252:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L976
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L981
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L982
	mov.l	r0,@(12,r15)
L981:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L982:
L976:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L983
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L987
	mov	#1,r14
L986:
	mov	#0,r14
L987:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1054,r1
	cmp/ge	r1,r0
	bt	L988
	mov.w	L1054,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L988:
	mov.w	L1055,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L990
	mov.w	L1055,r0
	mov.l	r0,@(16,r15)
	mov.w	L1056,r0
	mov.l	r0,@(0,r15)
L990:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L984
	mov.l	r0,@(16,r15)
	.align 2
L1054:	.short	-32768
L1055:	.short	32767
L1056:	.short	-1
L983:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L994
	mov	#1,r14
L993:
	mov	#0,r14
L994:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L984:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L995
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L995:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L997
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L997:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L999
	add	r0,r6
	mov.l	L1057,r7
L999:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1003
	mov	#1,r14
L1002:
	mov	#0,r14
L1003:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1008
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
	.align 2
L1057:	.short	65536
L1008:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1004
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1009
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1010
	mov.l	r0,@(12,r15)
L1009:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1010:
L1004:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1011
	mov.l	@(12,r15),r0
	mov.w	L1058,r1
	cmp/ge	r1,r0
	bt	L1013
	mov.w	L1058,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1013:
	mov.w	L1059,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1015
	mov.w	L1059,r0
	mov.l	r0,@(12,r15)
	mov.w	L1060,r0
	mov.l	r0,@(4,r15)
L1015:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1011:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1017
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1017:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1019
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1019:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1021
	add	r0,r6
	mov.l	L1061,r7
L1021:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1025
	mov	#1,r14
L1024:
	mov	#0,r14
L1025:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1030
	mov	r15,r14
	bra	Lm566
	mov	#0,r0
L1030:
	mov	#1,r0
Lm566:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1026
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1031
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1032
	mov.l	r0,@(16,r15)
L1031:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1032:
L1026:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1033
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1037
	mov	#1,r14
L1036:
	mov	#0,r14
L1037:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1062,r1
	cmp/ge	r1,r0
	bt	L1038
	mov.w	L1062,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1038:
	mov.w	L1063,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1040
	mov.w	L1063,r0
	mov.l	r0,@(16,r15)
	mov.w	L1064,r0
	mov.l	r0,@(0,r15)
L1040:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L1051,r2
	and	r2,r1
	or	r1,r0
	bra	L1034
	mov.l	r0,@(12,r15)
L1033:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1044
	mov	#1,r14
L1043:
	mov	#0,r14
L1044:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1034:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L1052,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L942
	mov.l	@(12,r15),r0
L939:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L1051:	.short	-65536
L1058:	.short	-32768
L1059:	.short	32767
L1060:	.short	-1
L1061:	.short	65536
L1062:	.short	-32768
L1063:	.short	32767
L1064:	.short	-1
L1052:	.long	_PTR_DAT_060450e8
	.global _FUN_06045098
	.align 2
_FUN_06045098:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L1066:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1069
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1069:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1071
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L1071:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L1073
	add	r0,r14
	mov.l	L1169,r7
L1073:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L1077
	mov	#1,r14
L1076:
	mov	#0,r14
L1077:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1082
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L1169:	.short	65536
L1082:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1078
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1083
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1084
	mov.l	r0,@(16,r15)
L1083:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1084:
L1078:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1085
	mov.l	@(16,r15),r0
	mov.w	L1170,r1
	cmp/ge	r1,r0
	bt	L1087
	mov.w	L1170,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1087:
	mov.w	L1171,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1089
	mov.w	L1171,r0
	mov.l	r0,@(16,r15)
	mov.w	L1172,r0
	mov.l	r0,@(8,r15)
L1089:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1085:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1091
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1091:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1093
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L1093:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1095
	add	r0,r12
	mov.l	L1174,r7
L1095:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1099
	mov	#1,r14
L1098:
	mov	#0,r14
L1099:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1104
	mov	r15,r14
	bra	Lm212
	mov	#0,r0
	.align 2
L1170:	.short	-32768
L1171:	.short	32767
L1172:	.short	-1
L1174:	.short	65536
L1104:
	mov	#1,r0
Lm212:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1100
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1105
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1106
	mov.l	r0,@(12,r15)
L1105:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1106:
L1100:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1107
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1111
	mov	#1,r14
L1110:
	mov	#0,r14
L1111:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1175,r1
	cmp/ge	r1,r0
	bt	L1112
	mov.w	L1175,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1112:
	mov.w	L1176,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1114
	mov.w	L1176,r0
	mov.l	r0,@(16,r15)
	mov.w	L1177,r0
	mov.l	r0,@(0,r15)
L1114:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1108
	mov.l	r0,@(16,r15)
	.align 2
L1175:	.short	-32768
L1176:	.short	32767
L1177:	.short	-1
L1107:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1118
	mov	#1,r14
L1117:
	mov	#0,r14
L1118:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1108:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1119
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1119:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1121
	mov	r5,r14
L1121:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1123
	add	r0,r12
	mov.l	L1178,r7
L1123:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1127
	mov	#1,r14
L1126:
	mov	#0,r14
L1127:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1132
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L1178:	.short	65536
L1132:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1128
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1133
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1134
	mov.l	r0,@(12,r15)
L1133:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1134:
L1128:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1135
	mov.l	@(12,r15),r0
	mov.w	L1179,r1
	cmp/ge	r1,r0
	bt	L1137
	mov.w	L1179,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1137:
	mov.w	L1180,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1139
	mov.w	L1180,r0
	mov.l	r0,@(12,r15)
	mov.w	L1181,r0
	mov.l	r0,@(4,r15)
L1139:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1135:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1141
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1141:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1143
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L1143:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1145
	add	r0,r12
	mov.l	L1182,r7
L1145:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1149
	mov	#1,r14
L1148:
	mov	#0,r14
L1149:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1154
	mov	r15,r14
	bra	Lm521
	mov	#0,r0
L1154:
	mov	#1,r0
Lm521:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1150
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1155
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1156
	mov.l	r0,@(16,r15)
L1155:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1156:
L1150:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1157
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1161
	mov	#1,r14
L1160:
	mov	#0,r14
L1161:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L1183,r1
	cmp/ge	r1,r0
	bt	L1162
	mov.w	L1183,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1162:
	mov.w	L1184,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1164
	mov.w	L1184,r0
	mov.l	r0,@(12,r15)
	mov.w	L1185,r0
	mov.l	r0,@(0,r15)
L1164:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1158
	mov.l	r0,@(12,r15)
L1157:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1168
	mov	#1,r14
L1167:
	mov	#0,r14
L1168:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1158:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L1173,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L1066
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L1173:	.short	-2
L1179:	.short	-32768
L1180:	.short	32767
L1181:	.short	-1
L1182:	.short	65536
L1183:	.short	-32768
L1184:	.short	32767
L1185:	.short	-1
	.global _FUN_060450f2
	.align 2
_FUN_060450f2:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L1292,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L1187
	mov.l	L1292,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1292:	.short	-2
L1187:
	mov.l	L1293,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L1189:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1192
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1192:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1194
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L1194:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L1196
	add	r0,r14
	mov.l	L1294,r7
L1196:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L1200
	mov	#1,r14
L1199:
	mov	#0,r14
L1200:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1205
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L1293:	.short	-32768
L1294:	.short	65536
L1205:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1201
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1206
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1207
	mov.l	r0,@(16,r15)
L1206:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1207:
L1201:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1208
	mov.l	@(16,r15),r0
	mov.w	L1299,r1
	cmp/ge	r1,r0
	bt	L1210
	mov.w	L1299,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1210:
	mov.w	L1295,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1212
	mov.w	L1295,r0
	mov.l	r0,@(16,r15)
	mov.w	L1296,r0
	mov.l	r0,@(8,r15)
L1212:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1208:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1214
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1214:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1216
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L1216:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L1218
	add	r0,r6
	mov.l	L1300,r7
L1218:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1222
	mov	#1,r14
L1221:
	mov	#0,r14
L1222:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1227
	mov	r15,r14
	bra	Lm251
	mov	#0,r0
	.align 2
L1295:	.short	32767
L1296:	.short	-1
L1299:	.short	-32768
L1300:	.short	65536
L1227:
	mov	#1,r0
Lm251:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1223
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1228
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1229
	mov.l	r0,@(12,r15)
L1228:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1229:
L1223:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1230
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1234
	mov	#1,r14
L1233:
	mov	#0,r14
L1234:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1303,r1
	cmp/ge	r1,r0
	bt	L1235
	mov.w	L1303,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1235:
	mov.w	L1301,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1237
	mov.w	L1301,r0
	mov.l	r0,@(16,r15)
	mov.w	L1302,r0
	mov.l	r0,@(0,r15)
L1237:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1231
	mov.l	r0,@(16,r15)
	.align 2
L1301:	.short	32767
L1302:	.short	-1
L1303:	.short	-32768
L1230:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1241
	mov	#1,r14
L1240:
	mov	#0,r14
L1241:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1231:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1242
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1242:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1244
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1244:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L1246
	add	r0,r6
	mov.l	L1304,r7
L1246:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1250
	mov	#1,r14
L1249:
	mov	#0,r14
L1250:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1255
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
	.align 2
L1304:	.short	65536
L1255:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1251
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1256
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1257
	mov.l	r0,@(12,r15)
L1256:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1257:
L1251:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1258
	mov.l	@(12,r15),r0
	mov.w	L1307,r1
	cmp/ge	r1,r0
	bt	L1260
	mov.w	L1307,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1260:
	mov.w	L1305,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1262
	mov.w	L1305,r0
	mov.l	r0,@(12,r15)
	mov.w	L1306,r0
	mov.l	r0,@(4,r15)
L1262:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1258:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1264
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1264:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1266
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1266:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L1268
	add	r0,r6
	mov.l	L1308,r7
L1268:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1272
	mov	#1,r14
L1271:
	mov	#0,r14
L1272:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1277
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L1277:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1273
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1278
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1279
	mov.l	r0,@(16,r15)
L1278:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1279:
L1273:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1280
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1284
	mov	#1,r14
L1283:
	mov	#0,r14
L1284:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1311,r1
	cmp/ge	r1,r0
	bt	L1285
	mov.w	L1311,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1285:
	mov.w	L1309,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1287
	mov.w	L1309,r0
	mov.l	r0,@(16,r15)
	mov.w	L1310,r0
	mov.l	r0,@(0,r15)
L1287:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L1297,r2
	and	r2,r1
	or	r1,r0
	bra	L1281
	mov.l	r0,@(12,r15)
L1280:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1291
	mov	#1,r14
L1290:
	mov	#0,r14
L1291:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1281:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L1298,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L1189
	mov.l	@(12,r15),r0
L1186:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L1297:	.short	-65536
L1305:	.short	32767
L1306:	.short	-1
L1308:	.short	65536
L1309:	.short	32767
L1310:	.short	-1
L1298:	.long	_DAT_0604514c
L1307:	.long	_PTR_DAT_06045150
L1311:	.long	_PTR_DAT_06045150
	.global _FUN_060450f4
	.align 2
_FUN_060450f4:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L1418,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L1313
	mov.l	L1418,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1418:	.short	-65536
L1313:
	mov.l	L1419,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L1315:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1318
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1318:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1320
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L1320:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L1322
	add	r0,r14
	mov.l	L1420,r7
L1322:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L1326
	mov	#1,r14
L1325:
	mov	#0,r14
L1326:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1331
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L1419:	.short	-2
L1420:	.short	65536
L1331:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1327
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1332
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1333
	mov.l	r0,@(16,r15)
L1332:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1333:
L1327:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1334
	mov.l	@(16,r15),r0
	mov.w	L1421,r1
	cmp/ge	r1,r0
	bt	L1336
	mov.w	L1421,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1336:
	mov.w	L1422,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1338
	mov.w	L1422,r0
	mov.l	r0,@(16,r15)
	mov.w	L1423,r0
	mov.l	r0,@(8,r15)
L1338:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1334:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1340
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1340:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1342
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L1342:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1344
	add	r0,r6
	mov.l	L1426,r7
L1344:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1348
	mov	#1,r14
L1347:
	mov	#0,r14
L1348:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1353
	mov	r15,r14
	bra	Lm249
	mov	#0,r0
	.align 2
L1421:	.short	-32768
L1422:	.short	32767
L1423:	.short	-1
L1426:	.short	65536
L1353:
	mov	#1,r0
Lm249:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1349
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1354
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1355
	mov.l	r0,@(12,r15)
L1354:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1355:
L1349:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1356
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1360
	mov	#1,r14
L1359:
	mov	#0,r14
L1360:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1427,r1
	cmp/ge	r1,r0
	bt	L1361
	mov.w	L1427,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1361:
	mov.w	L1428,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1363
	mov.w	L1428,r0
	mov.l	r0,@(16,r15)
	mov.w	L1429,r0
	mov.l	r0,@(0,r15)
L1363:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1357
	mov.l	r0,@(16,r15)
	.align 2
L1427:	.short	-32768
L1428:	.short	32767
L1429:	.short	-1
L1356:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1367
	mov	#1,r14
L1366:
	mov	#0,r14
L1367:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1357:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1368
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1368:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1370
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1370:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1372
	add	r0,r6
	mov.l	L1430,r7
L1372:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1376
	mov	#1,r14
L1375:
	mov	#0,r14
L1376:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1381
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
	.align 2
L1430:	.short	65536
L1381:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1377
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1382
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1383
	mov.l	r0,@(12,r15)
L1382:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1383:
L1377:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1384
	mov.l	@(12,r15),r0
	mov.w	L1431,r1
	cmp/ge	r1,r0
	bt	L1386
	mov.w	L1431,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1386:
	mov.w	L1432,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1388
	mov.w	L1432,r0
	mov.l	r0,@(12,r15)
	mov.w	L1433,r0
	mov.l	r0,@(4,r15)
L1388:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1384:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1390
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1390:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1392
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1392:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1394
	add	r0,r6
	mov.l	L1434,r7
L1394:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1398
	mov	#1,r14
L1397:
	mov	#0,r14
L1398:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1403
	mov	r15,r14
	bra	Lm566
	mov	#0,r0
L1403:
	mov	#1,r0
Lm566:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1399
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1404
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1405
	mov.l	r0,@(16,r15)
L1404:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1405:
L1399:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1406
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1410
	mov	#1,r14
L1409:
	mov	#0,r14
L1410:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1435,r1
	cmp/ge	r1,r0
	bt	L1411
	mov.w	L1435,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1411:
	mov.w	L1436,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1413
	mov.w	L1436,r0
	mov.l	r0,@(16,r15)
	mov.w	L1437,r0
	mov.l	r0,@(0,r15)
L1413:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L1424,r2
	and	r2,r1
	or	r1,r0
	bra	L1407
	mov.l	r0,@(12,r15)
L1406:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1417
	mov	#1,r14
L1416:
	mov	#0,r14
L1417:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1407:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L1425,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L1315
	mov.l	@(12,r15),r0
L1312:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L1424:	.short	-65536
L1431:	.short	-32768
L1432:	.short	32767
L1433:	.short	-1
L1434:	.short	65536
L1435:	.short	-32768
L1436:	.short	32767
L1437:	.short	-1
L1425:	.long	_PTR_DAT_06045150
	.global _FUN_0604510c
	.align 2
_FUN_0604510c:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L1439:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1442
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1442:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1444
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L1444:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L1446
	add	r0,r14
	mov.l	L1542,r7
L1446:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L1450
	mov	#1,r14
L1449:
	mov	#0,r14
L1450:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1455
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L1542:	.short	65536
L1455:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1451
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1456
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1457
	mov.l	r0,@(16,r15)
L1456:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1457:
L1451:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1458
	mov.l	@(16,r15),r0
	mov.w	L1543,r1
	cmp/ge	r1,r0
	bt	L1460
	mov.w	L1543,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1460:
	mov.w	L1544,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1462
	mov.w	L1544,r0
	mov.l	r0,@(16,r15)
	mov.w	L1545,r0
	mov.l	r0,@(8,r15)
L1462:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1458:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1464
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1464:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1466
	mov	r5,r14
L1466:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1468
	add	r0,r12
	mov.l	L1547,r7
L1468:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1472
	mov	#1,r14
L1471:
	mov	#0,r14
L1472:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1477
	mov	r15,r14
	bra	Lm210
	mov	#0,r0
	.align 2
L1543:	.short	-32768
L1544:	.short	32767
L1545:	.short	-1
L1547:	.short	65536
L1477:
	mov	#1,r0
Lm210:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1473
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1478
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1479
	mov.l	r0,@(12,r15)
L1478:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1479:
L1473:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1480
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1484
	mov	#1,r14
L1483:
	mov	#0,r14
L1484:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1548,r1
	cmp/ge	r1,r0
	bt	L1485
	mov.w	L1548,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1485:
	mov.w	L1549,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1487
	mov.w	L1549,r0
	mov.l	r0,@(16,r15)
	mov.w	L1550,r0
	mov.l	r0,@(0,r15)
L1487:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1481
	mov.l	r0,@(16,r15)
	.align 2
L1548:	.short	-32768
L1549:	.short	32767
L1550:	.short	-1
L1480:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1491
	mov	#1,r14
L1490:
	mov	#0,r14
L1491:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1481:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1492
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1492:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1494
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L1494:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1496
	add	r0,r12
	mov.l	L1551,r7
L1496:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1500
	mov	#1,r14
L1499:
	mov	#0,r14
L1500:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1505
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L1551:	.short	65536
L1505:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1501
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1506
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1507
	mov.l	r0,@(12,r15)
L1506:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1507:
L1501:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1508
	mov.l	@(12,r15),r0
	mov.w	L1552,r1
	cmp/ge	r1,r0
	bt	L1510
	mov.w	L1552,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1510:
	mov.w	L1553,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1512
	mov.w	L1553,r0
	mov.l	r0,@(12,r15)
	mov.w	L1554,r0
	mov.l	r0,@(4,r15)
L1512:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1508:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1514
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1514:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1516
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L1516:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1518
	add	r0,r12
	mov.l	L1555,r7
L1518:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1522
	mov	#1,r14
L1521:
	mov	#0,r14
L1522:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1527
	mov	r15,r14
	bra	Lm521
	mov	#0,r0
L1527:
	mov	#1,r0
Lm521:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1523
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1528
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1529
	mov.l	r0,@(16,r15)
L1528:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1529:
L1523:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1530
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1534
	mov	#1,r14
L1533:
	mov	#0,r14
L1534:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L1556,r1
	cmp/ge	r1,r0
	bt	L1535
	mov.w	L1556,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1535:
	mov.w	L1557,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1537
	mov.w	L1557,r0
	mov.l	r0,@(12,r15)
	mov.w	L1558,r0
	mov.l	r0,@(0,r15)
L1537:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1531
	mov.l	r0,@(12,r15)
L1530:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1541
	mov	#1,r14
L1540:
	mov	#0,r14
L1541:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1531:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L1546,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L1439
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L1546:	.short	-2
L1552:	.short	-32768
L1553:	.short	32767
L1554:	.short	-1
L1555:	.short	65536
L1556:	.short	-32768
L1557:	.short	32767
L1558:	.short	-1
	.global _FUN_06045198
	.align 2
_FUN_06045198:
	sts.l	pr,@-r15
	mov.l	L1560,r3
	jsr	@r3
	mov	r4,r8
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L1560:	.long	_FUN_060451bc
	.global _FUN_060451aa
	.align 2
_FUN_060451aa:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L1562,r3
	jsr	@r3
	mov	r4,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L1562:	.long	_FUN_060451be
	.global _FUN_060451bc
	.align 2
_FUN_060451bc:
	sts.l	pr,@-r15
	mov.l	L1564,r4
	mov.l	L1565,r3
	jsr	@r3
	mov.l	L1566,r3
	jsr	@r3
	mov.l	L1567,r3
	jsr	@r3
	mov.l	L1568,r3
	jsr	@r3
	mov.l	L1569,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.l	@r4,r4
	.align 2
L1564:	.long	_uRam060451f4
L1565:	.long	_func_0x06044d80
L1566:	.long	_func_0x060450f2
L1567:	.long	_func_0x06045006
L1568:	.long	_func_0x0604507e
L1569:	.long	_func_0x06044e3c
	.global _FUN_060451be
	.align 2
_FUN_060451be:
	sts.l	pr,@-r15
	mov	r15,r14
	add	#-4,r15
	mov.l	L1571,r0
	jsr	@r0
	nop
	mov.l	L1572,r3
	jsr	@r3
	nop
	mov.l	L1573,r3
	jsr	@r3
	nop
	mov.l	L1574,r3
	jsr	@r3
	nop
	mov.l	@r12,r0
	neg	r0,r0
	mov.l	r0,@(0,r15)
	mov.l	@(4,r12),r0
	neg	r0,r11
	mov.l	@(8,r12),r0
	neg	r0,r10
	mov	r15,r5
	mov.l	L1575,r3
	jsr	@r3
	mov	r14,r15
	lds.l	@r15+,pr
	rts
	add	#0,r5
	.align 2
L1571:	.long	_FUN_06044d80
L1572:	.long	_FUN_060450f2
L1573:	.long	_FUN_06045006
L1574:	.long	_FUN_0604507e
L1575:	.long	_FUN_06044e3c
	.global _FUN_060451fa
	.align 2
_FUN_060451fa:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1680,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L1681,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1577:
	mov.l	@(4,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1580
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1580:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1582
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1582:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1584
	add	r0,r13
	mov.l	L1682,r12
L1584:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1588
	mov	#1,r14
L1587:
	mov	#0,r14
L1588:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1593
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L1680:	.short	-2
L1681:	.short	-32768
L1682:	.short	65536
L1593:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1589
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1594
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1595
	mov.l	r0,@(16,r15)
L1594:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1595:
L1589:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1596
	mov.l	@(16,r15),r0
	mov.w	L1686,r1
	cmp/ge	r1,r0
	bt	L1598
	mov.w	L1686,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1598:
	mov.w	L1683,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1600
	mov.w	L1683,r0
	mov.l	r0,@(16,r15)
	mov.w	L1684,r0
	mov.l	r0,@(8,r15)
L1600:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1596:
	mov.l	@(8,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1602
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1602:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1604
	mov.l	@(32,r15),r13
L1604:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1606
	add	r0,r11
	mov.l	L1687,r12
L1606:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1610
	mov	#1,r14
L1609:
	mov	#0,r14
L1610:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1615
	mov	r15,r14
	bra	Lm226
	mov	#0,r0
	.align 2
L1683:	.short	32767
L1684:	.short	-1
L1686:	.short	-32768
L1687:	.short	65536
L1615:
	mov	#1,r0
Lm226:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1611
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1616
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1617
	mov.l	r0,@(12,r15)
L1616:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1617:
L1611:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1618
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1622
	mov	#1,r14
L1621:
	mov	#0,r14
L1622:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1690,r1
	cmp/ge	r1,r0
	bt	L1623
	mov.w	L1690,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1623:
	mov.w	L1688,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1625
	mov.w	L1688,r0
	mov.l	r0,@(16,r15)
	mov.w	L1689,r0
	mov.l	r0,@(0,r15)
L1625:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1619
	mov.l	r0,@(16,r15)
	.align 2
L1688:	.short	32767
L1689:	.short	-1
L1690:	.short	-32768
L1618:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1629
	mov	#1,r14
L1628:
	mov	#0,r14
L1629:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1619:
	mov.l	@(4,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1630
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1630:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1632
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1632:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1634
	add	r0,r11
	mov.l	L1691,r12
L1634:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1638
	mov	#1,r14
L1637:
	mov	#0,r14
L1638:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1643
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L1691:	.short	65536
L1643:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1639
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1644
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1645
	mov.l	r0,@(12,r15)
L1644:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1645:
L1639:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1646
	mov.l	@(12,r15),r0
	mov.w	L1694,r1
	cmp/ge	r1,r0
	bt	L1648
	mov.w	L1694,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1648:
	mov.w	L1692,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1650
	mov.w	L1692,r0
	mov.l	r0,@(12,r15)
	mov.w	L1693,r0
	mov.l	r0,@(4,r15)
L1650:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1646:
	mov	r14,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1652
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1652:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1654
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1654:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1656
	add	r0,r11
	mov.l	L1695,r12
L1656:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1660
	mov	#1,r14
L1659:
	mov	#0,r14
L1660:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1665
	mov	r15,r14
	bra	Lm543
	mov	#0,r0
L1665:
	mov	#1,r0
Lm543:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1661
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1666
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1667
	mov.l	r0,@(16,r15)
L1666:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1667:
L1661:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1668
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1672
	mov	#1,r14
L1671:
	mov	#0,r14
L1672:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L1698,r1
	cmp/ge	r1,r0
	bt	L1673
	mov.w	L1698,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1673:
	mov.w	L1696,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1675
	mov.w	L1696,r0
	mov.l	r0,@(12,r15)
	mov.w	L1697,r0
	mov.l	r0,@(0,r15)
L1675:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1669
	mov.l	r0,@(12,r15)
L1668:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1679
	mov	#1,r14
L1678:
	mov	#0,r14
L1679:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1669:
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L1685,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	mov	r14,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1577
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L1692:	.short	32767
L1693:	.short	-1
L1695:	.short	65536
L1696:	.short	32767
L1697:	.short	-1
	.align 2
L1685:	.long	_pcRam06045258
L1694:	.long	_pcRam0604525c
L1698:	.long	_pcRam0604525c
	.global _FUN_0604521a
	.align 2
_FUN_0604521a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1803,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L1804,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1700:
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1703
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1703:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1705
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1705:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1707
	add	r0,r13
	mov.l	L1805,r12
L1707:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1711
	mov	#1,r14
L1710:
	mov	#0,r14
L1711:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1716
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L1803:	.short	-2
L1804:	.short	32767
L1805:	.short	65536
L1716:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1712
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1717
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1718
	mov.l	r0,@(16,r15)
L1717:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1718:
L1712:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1719
	mov.l	@(16,r15),r0
	mov.w	L1806,r1
	cmp/ge	r1,r0
	bt	L1721
	mov.w	L1806,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1721:
	mov.w	L1809,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1723
	mov.w	L1809,r0
	mov.l	r0,@(16,r15)
	mov.w	L1807,r0
	mov.l	r0,@(8,r15)
L1723:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1719:
	mov.l	@(8,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1725
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1725:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1727
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1727:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1729
	add	r0,r11
	mov.l	L1810,r12
L1729:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1733
	mov	#1,r14
L1732:
	mov	#0,r14
L1733:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1738
	mov	r15,r14
	bra	Lm230
	mov	#0,r0
	.align 2
L1806:	.short	-32768
L1807:	.short	-1
L1809:	.short	32767
L1810:	.short	65536
L1738:
	mov	#1,r0
Lm230:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1734
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1739
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1740
	mov.l	r0,@(12,r15)
L1739:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1740:
L1734:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1741
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1745
	mov	#1,r14
L1744:
	mov	#0,r14
L1745:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1811,r1
	cmp/ge	r1,r0
	bt	L1746
	mov.w	L1811,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1746:
	mov.w	L1813,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1748
	mov.w	L1813,r0
	mov.l	r0,@(16,r15)
	mov.w	L1812,r0
	mov.l	r0,@(0,r15)
L1748:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1742
	mov.l	r0,@(16,r15)
	.align 2
L1811:	.short	-32768
L1812:	.short	-1
L1813:	.short	32767
L1741:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1752
	mov	#1,r14
L1751:
	mov	#0,r14
L1752:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1742:
	mov.l	@r14,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1753
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1753:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1755
	mov.l	@(32,r15),r13
L1755:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1757
	add	r0,r11
	mov.l	L1814,r12
L1757:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1761
	mov	#1,r14
L1760:
	mov	#0,r14
L1761:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1766
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L1814:	.short	65536
L1766:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1762
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1767
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1768
	mov.l	r0,@(12,r15)
L1767:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1768:
L1762:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1769
	mov.l	@(12,r15),r0
	mov.w	L1815,r1
	cmp/ge	r1,r0
	bt	L1771
	mov.w	L1815,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1771:
	mov.w	L1817,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1773
	mov.w	L1817,r0
	mov.l	r0,@(12,r15)
	mov.w	L1816,r0
	mov.l	r0,@(4,r15)
L1773:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1769:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r14
	mov.l	@(8,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1775
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1775:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1777
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1777:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1779
	add	r0,r11
	mov.l	L1818,r12
L1779:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1783
	mov	#1,r14
L1782:
	mov	#0,r14
L1783:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1788
	mov	r15,r14
	bra	Lm541
	mov	#0,r0
L1788:
	mov	#1,r0
Lm541:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1784
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1789
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1790
	mov.l	r0,@(16,r15)
L1789:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1790:
L1784:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1791
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1795
	mov	#1,r14
L1794:
	mov	#0,r14
L1795:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L1819,r1
	cmp/ge	r1,r0
	bt	L1796
	mov.w	L1819,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1796:
	mov.w	L1821,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1798
	mov.w	L1821,r0
	mov.l	r0,@(12,r15)
	mov.w	L1820,r0
	mov.l	r0,@(0,r15)
L1798:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1792
	mov.l	r0,@(12,r15)
L1791:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1802
	mov	#1,r14
L1801:
	mov	#0,r14
L1802:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1792:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r14)
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L1808,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1700
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L1815:	.short	-32768
L1816:	.short	-1
L1818:	.short	65536
L1819:	.short	-32768
L1820:	.short	-1
	.align 2
L1808:	.long	_pcRam06045258
L1817:	.long	_pcRam0604525c
L1821:	.long	_pcRam0604525c
	.global _FUN_0604523a
	.align 2
_FUN_0604523a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1926,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L1927,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1823:
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1826
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1826:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1828
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1828:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1830
	add	r0,r13
	mov.l	L1928,r12
L1830:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1834
	mov	#1,r14
L1833:
	mov	#0,r14
L1834:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1839
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L1926:	.short	-2
L1927:	.short	-32768
L1928:	.short	65536
L1839:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1835
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1840
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1841
	mov.l	r0,@(16,r15)
L1840:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1841:
L1835:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1842
	mov.l	@(16,r15),r0
	mov.w	L1932,r1
	cmp/ge	r1,r0
	bt	L1844
	mov.w	L1932,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1844:
	mov.w	L1929,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1846
	mov.w	L1929,r0
	mov.l	r0,@(16,r15)
	mov.w	L1930,r0
	mov.l	r0,@(8,r15)
L1846:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1842:
	mov.l	@(4,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1848
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1848:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1850
	mov.l	@(32,r15),r13
L1850:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1852
	add	r0,r11
	mov.l	L1933,r12
L1852:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1856
	mov	#1,r14
L1855:
	mov	#0,r14
L1856:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1861
	mov	r15,r14
	bra	Lm226
	mov	#0,r0
	.align 2
L1929:	.short	32767
L1930:	.short	-1
L1932:	.short	-32768
L1933:	.short	65536
L1861:
	mov	#1,r0
Lm226:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1857
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1862
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1863
	mov.l	r0,@(12,r15)
L1862:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1863:
L1857:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1864
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1868
	mov	#1,r14
L1867:
	mov	#0,r14
L1868:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L1936,r1
	cmp/ge	r1,r0
	bt	L1869
	mov.w	L1936,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1869:
	mov.w	L1934,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1871
	mov.w	L1934,r0
	mov.l	r0,@(16,r15)
	mov.w	L1935,r0
	mov.l	r0,@(0,r15)
L1871:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1865
	mov.l	r0,@(16,r15)
	.align 2
L1934:	.short	32767
L1935:	.short	-1
L1936:	.short	-32768
L1864:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1875
	mov	#1,r14
L1874:
	mov	#0,r14
L1875:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1865:
	mov.l	@r14,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1876
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1876:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1878
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1878:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1880
	add	r0,r11
	mov.l	L1937,r12
L1880:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1884
	mov	#1,r14
L1883:
	mov	#0,r14
L1884:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1889
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L1937:	.short	65536
L1889:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1885
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1890
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1891
	mov.l	r0,@(12,r15)
L1890:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1891:
L1885:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1892
	mov.l	@(12,r15),r0
	mov.w	L1940,r1
	cmp/ge	r1,r0
	bt	L1894
	mov.w	L1940,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1894:
	mov.w	L1938,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1896
	mov.w	L1938,r0
	mov.l	r0,@(12,r15)
	mov.w	L1939,r0
	mov.l	r0,@(4,r15)
L1896:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1892:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r14
	mov.l	@(4,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1898
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1898:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1900
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1900:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1902
	add	r0,r11
	mov.l	L1941,r12
L1902:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1906
	mov	#1,r14
L1905:
	mov	#0,r14
L1906:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1911
	mov	r15,r14
	bra	Lm541
	mov	#0,r0
L1911:
	mov	#1,r0
Lm541:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1907
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1912
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1913
	mov.l	r0,@(16,r15)
L1912:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1913:
L1907:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1914
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1918
	mov	#1,r14
L1917:
	mov	#0,r14
L1918:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L1944,r1
	cmp/ge	r1,r0
	bt	L1919
	mov.w	L1944,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1919:
	mov.w	L1942,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1921
	mov.w	L1942,r0
	mov.l	r0,@(12,r15)
	mov.w	L1943,r0
	mov.l	r0,@(0,r15)
L1921:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1915
	mov.l	r0,@(12,r15)
L1914:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1925
	mov	#1,r14
L1924:
	mov	#0,r14
L1925:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1915:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r14)
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L1931,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1823
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L1938:	.short	32767
L1939:	.short	-1
L1941:	.short	65536
L1942:	.short	32767
L1943:	.short	-1
	.align 2
L1931:	.long	_pcRam06045258
L1940:	.long	_pcRam0604525c
L1944:	.long	_pcRam0604525c
	.global _FUN_060452f0
	.align 2
_FUN_060452f0:
	sts.l	pr,@-r15
	mov.l	L1946,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1946:	.long	_FUN_06045368
	.global _FUN_06045318
	.align 2
_FUN_06045318:
	sts.l	pr,@-r15
	mov.l	L1948,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1948:	.long	_FUN_060453c8
	.global _FUN_06045340
	.align 2
_FUN_06045340:
	sts.l	pr,@-r15
	mov.l	L1950,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1950:	.long	_FUN_060453b8
	.global _FUN_06045368
	.align 2
_FUN_06045368:
	sts.l	pr,@-r15
	mov.l	L1952,r3
	jsr	@r3
	nop
	mov.l	L1953,r3
	jsr	@r3
	nop
	mov.l	L1954,r4
	mov.l	L1955,r3
	jsr	@r3
	mov.l	L1956,r4
	mov.l	L1957,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L1958,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L1959,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L1952:	.long	_PTR_FUN_0604539c
L1953:	.long	_PTR_SUB_060453a0
L1954:	.long	_PTR_DAT_060453a4
L1955:	.long	_FUN_060453c8
L1956:	.long	_PTR_DAT_060453ac
L1957:	.long	_func_0x060453cc
L1958:	.long	_PTR_FUN_060453b4
L1959:	.long	_FUN_06045ccc
	.global _FUN_06045378
	.align 2
_FUN_06045378:
	sts.l	pr,@-r15
	mov.l	L1961,r4
	mov.l	L1962,r3
	jsr	@r3
	mov.l	L1963,r4
	mov.l	L1962,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L1964,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L1965,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L1961:	.long	_PTR_DAT_060453a4
L1962:	.long	_FUN_060453cc
L1963:	.long	_PTR_DAT_060453ac
L1964:	.long	_PTR_FUN_060453b4
L1965:	.long	_FUN_06045ccc
	.global _FUN_060453b8
	.align 2
_FUN_060453b8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L1970,r0
	mov.l	@r0,r13
	mov.l	L1971,r0
	mov.l	@r0,r12
L1967:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1967
	mov.l	L1972,r3
	jsr	@r3
	nop
	mov.l	L1973,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L1970:	.long	_puRam060453c4
L1971:	.long	_puRam060453c0
L1972:	.long	_func_0x060456cc
L1973:	.long	_FUN_06045ccc
	.global _FUN_060453c8
	.align 2
_FUN_060453c8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L1978,r0
	mov.l	@r0,r13
	mov.l	L1979,r0
	mov.l	@r0,r12
L1975:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1975
	mov.l	L1980,r3
	jsr	@r3
	nop
	mov.l	L1981,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L1978:	.long	_puRam06045598
L1979:	.long	_puRam06045594
L1980:	.long	_func_0x060456cc
L1981:	.long	_FUN_06045ccc
	.global _FUN_060453cc
	.align 2
_FUN_060453cc:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#48,r12
L1983:
	mov.l	@r14+,r13
	mov.l	r13,@r11
	dt	r12
	add	#4,r11
	bf	L1983
	mov.l	L1986,r3
	jsr	@r3
	nop
	mov.l	L1987,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L1986:	.long	_FUN_060456cc
L1987:	.long	_FUN_06045ccc
	.global _FUN_0604556c
	.align 2
_FUN_0604556c:
	sts.l	pr,@-r15
	mov.l	L1989,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1989:	.long	_FUN_0604559c
	.global _FUN_0604559c
	.align 2
_FUN_0604559c:
	sts.l	pr,@-r15
	mov.l	L1991,r3
	jsr	@r3
	nop
	mov.l	L1992,r3
	jsr	@r3
	nop
	mov.l	L1993,r3
	jsr	@r3
	nop
	mov.l	L1994,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov	r1,r14
	mov.l	L1997,r4
	mov.l	L1995,r1
	mov.l	L1996,r0
	mov.l	L1998,r0
	mov.l	@r1,r1
	mov.l	r0,@r1
	mov.l	@r0,r1
	extu.w	r14,r0
	mov.l	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L1999,r0
	mov.l	@r0,r0
	mov.w	L2000,r1
	add	r1,r0
	mov.l	L2002,r3
	mov.l	L2001,r1
	mov.l	@r1,r1
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r0
	.align 2
L2000:	.short	140
	.align 2
L1991:	.long	_PTR_FUN_060455f4
L1992:	.long	_PTR_FUN_060455f8
L1993:	.long	_func_0x06045378
L1994:	.long	_DAT_060455ee
L1995:	.long	_DAT_060455fc
L1996:	.long	_DAT_06045600
L1997:	.long	_PTR_LAB_06045604
L1998:	.long	_DAT_06045608
L1999:	.long	_DAT_0604560c
L2001:	.long	_DAT_060455f0
L2002:	.long	_func_0x060456cc
	.global _FUN_060455d0
	.align 2
_FUN_060455d0:
	sts.l	pr,@-r15
	mov.l	L2004,r0
	mov.l	@r0,r0
	mov.w	L2005,r1
	add	r1,r0
	mov.l	L2007,r3
	mov.l	L2006,r1
	mov.l	@r1,r1
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r0
	.align 2
L2005:	.short	140
	.align 2
L2004:	.long	_DAT_06045610
L2006:	.long	_DAT_060455f0
L2007:	.long	_FUN_060456cc
	.global _FUN_060455e2
	.align 2
_FUN_060455e2:
	sts.l	pr,@-r15
	mov.l	L2009,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2009:	.long	_FUN_0604562c
	.global _FUN_06045614
	.align 2
_FUN_06045614:
	sts.l	pr,@-r15
	mov.l	L2011,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2011:	.long	_FUN_06045650
	.global _FUN_06045620
	.align 2
_FUN_06045620:
	sts.l	pr,@-r15
	mov.l	L2013,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2013:	.long	_func_0x06045664
	.global _FUN_0604562c
	.align 2
_FUN_0604562c:
	sts.l	pr,@-r15
	mov.l	L2015,r4
	mov.l	L2016,r0
	mov.l	@r4,r4
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2017,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2015:	.long	_uRam06045644
L2016:	.long	_pcRam06045648
L2017:	.long	_pcRam0604564c
	.global _FUN_06045650
	.align 2
_FUN_06045650:
	mov.l	L2019,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.w	L2020,r1
	add	r1,r0
	mov.l	L2021,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2022,r0
	add	r7,r0
	mov.l	L2023,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2024,r0
	add	r7,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.w	L2025,r0
	add	r7,r0
	mov	#0,r1
	rts
	mov.l	r1,@r0
	.align 2
L2020:	.short	136
L2022:	.short	144
L2024:	.short	132
L2025:	.short	168
L2019:	.long	_iRam06045690
L2021:	.long	_uRam06045688
L2023:	.long	_uRam0604568a
	.global _FUN_06045664
	.align 2
_FUN_06045664:
	mov.l	L2027,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.w	L2028,r1
	add	r1,r0
	mov.l	L2029,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2030,r0
	add	r7,r0
	mov.l	L2031,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2032,r0
	add	r7,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.w	L2033,r0
	add	r7,r0
	mov	#0,r1
	rts
	mov.l	r1,@r0
	.align 2
L2028:	.short	136
L2030:	.short	144
L2032:	.short	132
L2033:	.short	168
L2027:	.long	_iRam06045694
L2029:	.long	_uRam0604568c
L2031:	.long	_uRam0604568e
	.global _FUN_06045678
	.align 2
_FUN_06045678:
	sts.l	pr,@-r15
	mov.l	L2035,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2035:	.long	_FUN_06045698
	.global _FUN_06045698
	.align 2
_FUN_06045698:
	rts
	nop
	.global _FUN_060456aa
	.align 2
_FUN_060456aa:
	sts.l	pr,@-r15
	mov.l	L2038,r3
	jsr	@r3
	nop
	mov.l	L2038,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2038:	.long	_FUN_060456c2
	.global _FUN_060456ac
	.align 2
_FUN_060456ac:
	sts.l	pr,@-r15
	mov.l	L2040,r3
	jsr	@r3
	nop
	mov.l	L2040,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2040:	.long	_FUN_060456c2
	.global _FUN_060456c2
	.align 2
_FUN_060456c2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2042,r1
	add	r13,r1
	mov.l	L2043,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r14,@r1
	.align 2
L2042:	.short	140
	.align 2
L2043:	.long	_FUN_060456cc
	.global _FUN_060456cc
	.align 2
_FUN_060456cc:
	mov.l	L2045,r0
	mov.l	@r7,r1
	mov.l	r1,@r0
	mov.l	L2046,r1
	mov.w	L2045,r2
	add	r7,r2
	mov.w	@r2,r0
	mov.l	r0,@r1
	mov.l	L2047,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.l	L2048,r0
	mov.l	@r0,r0
	rts
	mov.l	r0,@(12,r14)
	.align 2
L2045:	.long	__DAT_ffffff00
L2046:	.long	__DAT_ffffff10
L2047:	.long	__DAT_ffffff14
L2048:	.long	__DAT_ffffff1c
	.global _FUN_060456ec
	.align 2
_FUN_060456ec:
	mov.w	L2050,r0
	add	r7,r0
	mov.l	L2051,r1
	mov.l	@r1,r1
	rts
	mov.w	r1,@r0
	.align 2
L2050:	.short	146
	.align 2
L2051:	.long	_uRam060456f8
	.global _FUN_060456f2
	.align 2
_FUN_060456f2:
	mov.w	L2053,r0
	add	r7,r0
	mov.l	L2054,r1
	mov.l	@r1,r1
	rts
	mov.w	r1,@r0
	.align 2
L2053:	.short	146
	.align 2
L2054:	.long	_uRam060456fa
	.global _FUN_060456fc
	.align 2
_FUN_060456fc:
	mov.l	L2058,r0
	mov.l	@r0,r7
	mov.l	L2059,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L2056
	mov.l	L2060,r0
	mov.l	@r0,r7
L2056:
	rts
	mov.l	r4,@r7
	.align 2
L2058:	.long	_puRam0604570c
L2059:	.long	__DAT_ffffffe2
L2060:	.long	_puRam06045710
	.global _FUN_06045714
	.align 2
_FUN_06045714:
	sts.l	pr,@-r15
	mov.l	L2062,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2062:	.long	_FUN_06045738
	.global _FUN_06045738
	.align 2
_FUN_06045738:
	sts.l	pr,@-r15
	add	#-16,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2078,r0
	mov.l	@r0,r0
	mov	r0,r11
	mov.l	@r0,r0
	tst	r0,r0
	bf	L2064
	mov	#12,r8
	mov.l	L2079,r0
	mov.l	@r0,r9
L2066:
	mov.l	@r14+,r10
	mov.l	r10,@r9
	dt	r8
	add	#4,r9
	bf	L2066
	mov.l	L2079,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r11)
	mov.l	r13,@(8,r11)
	mov.l	L2080,r0
	mov.l	r0,@r11
	mov.l	L2081,r0
	mov.l	@r0,r0
	mov.w	L2082,r1
	mov.l	r1,@r0
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L2064:
	mov.l	L2083,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r0
	mov.w	L2079,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2063
	mov.l	L2084,r3
	jsr	@r3
	nop
	mov.l	L2085,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r8
	mov.l	@(8,r8),r0
	add	r8,r0
	mov.l	r0,@(12,r15)
	mov.w	@(2,r8),r0
	mov	r0,r8
L2071:
	mov.l	@(0,r15),r0
	mov.w	L2079,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2074
	nop
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L2074:
	mov.l	@(12,r15),r0
	mov.w	@r0+,r12
	mov.l	r0,@(8,r15)
	mov.l	@(0,r15),r0
	mov.w	L2086,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(12,r15),r0
	add	#4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	mov.w	L2087,r1
	add	r1,r0
	mov	r0,r1
	mov.l	@(8,r15),r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	extu.w	r12,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2076
	mov.l	L2088,r3
	jsr	@r3
	nop
	bra	L2077
	nop
L2076:
	mov.l	L2089,r3
	jsr	@r3
	nop
L2077:
	dt	r8
	bf	L2071
L2063:
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2082:	.short	22368
L2086:	.short	128
L2087:	.short	130
	.align 2
L2078:	.long	_piRam06045770
L2079:	.long	_puRam06045774
L2080:	.long	_FUN_06045760
L2081:	.long	_puRam06045778
L2083:	.long	_FUN_060459c4
L2084:	.long	_FUN_060463e4
L2085:	.long	_FUN_06046602
L2088:	.long	_FUN_06045a2c
L2089:	.long	_FUN_06045a7e
	.global _FUN_06045760
	.align 2
_FUN_06045760:
	sts.l	pr,@-r15
	mov.l	L2100,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	@(4,r0),r4
	mov.l	L2102,r3
	mov.l	L2101,r0
	mov.l	r1,@r0
	mov.l	@r0,r0
	jsr	@r3
	mov.l	@(8,r0),r5
	mov.w	L2101,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2090
	mov.l	L2103,r3
	jsr	@r3
	nop
	mov.l	L2104,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L2093:
	mov.w	L2101,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2096
	nop
	lds.l	@r15+,pr
	rts
	nop
L2096:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2105,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2106,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2098
	mov.l	L2107,r3
	jsr	@r3
	nop
	bra	L2099
	nop
L2098:
	mov.l	L2108,r3
	jsr	@r3
	nop
L2099:
	dt	r13
	bf	L2093
L2090:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2105:	.short	128
L2106:	.short	130
L2100:	.long	_puRam0604577c
L2101:	.long	_iRam06045780
L2102:	.long	_FUN_060459c4
L2103:	.long	_FUN_060463e4
L2104:	.long	_FUN_06046602
L2107:	.long	_FUN_06045a2c
L2108:	.long	_FUN_06045a7e
	.global _FUN_06045784
	.align 2
_FUN_06045784:
	sts.l	pr,@-r15
	mov.l	L2110,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2110:	.long	_FUN_060457a8
	.global _FUN_060457aa
	.align 2
_FUN_060457aa:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2121,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2122,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r0
	mov.w	L2123,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2111
	mov.l	L2124,r3
	jsr	@r3
	nop
	mov.l	L2125,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r10
	mov.l	@(8,r10),r0
	add	r10,r0
	mov	r0,r9
	mov.w	@(2,r10),r0
	mov	r0,r10
L2114:
	mov.l	@(0,r15),r0
	mov.w	L2123,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2117
	nop
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
L2117:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r0
	mov.w	L2126,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r0
	mov.w	L2127,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r8,r0
	mov.w	r0,@r1
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2119
	mov.l	L2128,r3
	jsr	@r3
	nop
	bra	L2120
	nop
L2119:
	mov.l	L2129,r3
	jsr	@r3
	nop
L2120:
	dt	r10
	bf	L2114
L2111:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2122:	.short	148
L2123:	.short	136
L2126:	.short	128
L2127:	.short	130
L2121:	.long	_FUN_060459c4
L2124:	.long	_FUN_060463e4
L2125:	.long	_FUN_06046602
L2128:	.long	_FUN_06045a2c
L2129:	.long	_FUN_06045a7e
	.global _FUN_060457ac
	.align 2
_FUN_060457ac:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2140,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2141,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r0
	mov.w	L2142,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2130
	mov.l	L2143,r3
	jsr	@r3
	nop
	mov.l	L2144,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r10
	mov.l	@(8,r10),r0
	add	r10,r0
	mov	r0,r9
	mov.w	@(2,r10),r0
	mov	r0,r10
L2133:
	mov.l	@(0,r15),r0
	mov.w	L2142,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2136
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2136:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r0
	mov.w	L2145,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r0
	mov.w	L2146,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r8,r0
	mov.w	r0,@r1
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2138
	mov.l	L2147,r3
	jsr	@r3
	nop
	bra	L2139
	nop
L2138:
	mov.l	L2148,r3
	jsr	@r3
	nop
L2139:
	dt	r10
	bf	L2133
L2130:
	add	#8,r15
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
L2141:	.short	148
L2142:	.short	136
L2145:	.short	128
L2146:	.short	130
L2140:	.long	_FUN_060459c4
L2143:	.long	_FUN_060463e4
L2144:	.long	_func_0x06046602
L2147:	.long	_func_0x06045a2c
L2148:	.long	_FUN_06045a7e
	.global _FUN_060457dc
	.align 2
_FUN_060457dc:
	sts.l	pr,@-r15
	mov.l	L2159,r3
	jsr	@r3
	nop
	mov.w	L2160,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2149
	mov.l	L2161,r3
	jsr	@r3
	nop
	mov.l	L2162,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L2152:
	mov.w	L2160,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2155
	nop
	lds.l	@r15+,pr
	rts
	nop
L2155:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2163,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2164,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2157
	mov.l	L2165,r3
	jsr	@r3
	nop
	bra	L2158
	nop
L2157:
	mov.l	L2166,r3
	jsr	@r3
	nop
L2158:
	dt	r13
	bf	L2152
L2149:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2160:	.short	136
L2163:	.short	128
L2164:	.short	130
	.align 2
L2159:	.long	_FUN_060459c4
L2161:	.long	_FUN_060463e4
L2162:	.long	_func_0x06046602
L2165:	.long	_func_0x06045a2c
L2166:	.long	_FUN_06045a7e
	.global _FUN_060457de
	.align 2
_FUN_060457de:
	sts.l	pr,@-r15
	mov.l	L2177,r3
	jsr	@r3
	nop
	mov.w	L2178,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2167
	mov.l	L2179,r3
	jsr	@r3
	nop
	mov.l	L2180,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L2170:
	mov.w	L2178,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2173
	nop
	lds.l	@r15+,pr
	rts
	nop
L2173:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2181,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2182,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2175
	mov.l	L2183,r3
	jsr	@r3
	nop
	bra	L2176
	nop
L2175:
	mov.l	L2184,r3
	jsr	@r3
	nop
L2176:
	dt	r13
	bf	L2170
L2167:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2178:	.short	136
L2181:	.short	128
L2182:	.short	130
	.align 2
L2177:	.long	_FUN_060459c4
L2179:	.long	_FUN_060463e4
L2180:	.long	_FUN_06046602
L2183:	.long	_FUN_06045a2c
L2184:	.long	_FUN_06045a7e
	.global _FUN_060457e2
	.align 2
_FUN_060457e2:
	sts.l	pr,@-r15
	mov.w	L2195,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2185
	mov.l	L2196,r3
	jsr	@r3
	nop
	mov.l	L2197,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L2188:
	mov.w	L2195,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2191
	nop
	lds.l	@r15+,pr
	rts
	nop
L2191:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2198,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2199,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2193
	mov.l	L2200,r3
	jsr	@r3
	nop
	bra	L2194
	nop
L2193:
	mov.l	L2201,r3
	jsr	@r3
	nop
L2194:
	dt	r13
	bf	L2188
L2185:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2195:	.short	136
L2198:	.short	128
L2199:	.short	130
	.align 2
L2196:	.long	_FUN_060463e4
L2197:	.long	_FUN_06046602
L2200:	.long	_FUN_06045a2c
L2201:	.long	_FUN_06045a7e
	.global _FUN_060457e4
	.align 2
_FUN_060457e4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.w	L2212,r0
	add	r13,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2202
	mov.l	L2213,r3
	jsr	@r3
	nop
	mov.l	L2214,r3
	jsr	@r3
	nop
	mov.l	@(48,r12),r9
	mov.l	@(8,r9),r0
	add	r9,r0
	mov	r0,r10
	mov.w	@(2,r9),r0
	mov	r0,r9
L2205:
	mov.w	L2212,r0
	add	r13,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2208
	nop
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2208:
	mov.w	@r10,r8
	mov	r10,r11
	add	#2,r11
	mov.w	L2215,r1
	add	r13,r1
	mov.w	r8,@r1
	add	#4,r10
	mov.w	L2216,r1
	add	r13,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r8,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2210
	mov.l	L2217,r3
	jsr	@r3
	nop
	bra	L2211
	nop
L2210:
	mov.l	L2218,r3
	jsr	@r3
	nop
L2211:
	dt	r9
	bf	L2205
L2202:
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
L2212:	.short	136
L2215:	.short	128
L2216:	.short	130
	.align 2
L2213:	.long	_FUN_060463e4
L2214:	.long	_func_0x06046602
L2217:	.long	_func_0x06045a2c
L2218:	.long	_FUN_06045a7e
	.global _FUN_06045858
	.align 2
_FUN_06045858:
	sts.l	pr,@-r15
	mov.l	L2234,r3
	jsr	@r3
	nop
	mov.w	L2234,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2220
	mov.l	L2235,r3
	jsr	@r3
	nop
	mov.l	L2236,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L2226
	mov	r0,r12
L2225:
	mov.w	L2234,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2228
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L2228:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2237,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2238,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L2230
	bra	L2227
	nop
L2230:
	mov.l	L2239,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2232
	nop
	lds.l	@r15+,pr
	rts
	nop
L2232:
L2226:
	bra	L2225
	nop
L2227:
	mov.l	L2240,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2226
L2220:
L2219:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2237:	.short	128
L2238:	.short	130
L2234:	.long	_FUN_060459c4
L2235:	.long	_func_0x06046478
L2236:	.long	_func_0x06046602
L2239:	.long	_FUN_0604670c
L2240:	.long	_func_0x0604674e
	.global _FUN_0604585c
	.align 2
_FUN_0604585c:
	sts.l	pr,@-r15
	mov.w	L2256,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2242
	mov.l	L2257,r3
	jsr	@r3
	nop
	mov.l	L2258,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L2248
	mov	r0,r12
L2247:
	mov.w	L2256,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2250
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L2250:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2259,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2260,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L2252
	bra	L2249
	nop
L2252:
	mov.l	L2261,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2254
	nop
	lds.l	@r15+,pr
	rts
	nop
L2254:
L2248:
	bra	L2247
	nop
L2249:
	mov.l	L2262,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2248
L2242:
L2241:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2256:	.short	136
L2259:	.short	128
L2260:	.short	130
	.align 2
L2257:	.long	_func_0x06046478
L2258:	.long	_func_0x06046602
L2261:	.long	_FUN_0604670c
L2262:	.long	_func_0x0604674e
	.global _FUN_060458da
	.align 2
_FUN_060458da:
	sts.l	pr,@-r15
	mov.l	L2278,r3
	jsr	@r3
	nop
	mov.w	L2278,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2264
	mov.l	L2279,r3
	jsr	@r3
	nop
	mov.l	L2280,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L2270
	mov	r0,r12
L2269:
	mov.w	L2278,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2272
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L2272:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2281,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2282,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L2274
	bra	L2271
	nop
L2274:
	mov.l	L2283,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2276
	nop
	lds.l	@r15+,pr
	rts
	nop
L2276:
L2270:
	bra	L2269
	nop
L2271:
	mov.l	L2284,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2270
L2264:
L2263:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2281:	.short	128
L2282:	.short	130
L2278:	.long	_FUN_060459c4
L2279:	.long	_FUN_06046478
L2280:	.long	_FUN_06046602
L2283:	.long	_FUN_06045a2c
L2284:	.long	_FUN_06045a7e
	.global _FUN_060458de
	.align 2
_FUN_060458de:
	sts.l	pr,@-r15
	mov.w	L2300,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2286
	mov.l	L2301,r3
	jsr	@r3
	nop
	mov.l	L2302,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L2292
	mov	r0,r12
L2291:
	mov.w	L2300,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2294
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L2294:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2303,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2304,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L2296
	bra	L2293
	nop
L2296:
	mov.l	L2305,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2298
	nop
	lds.l	@r15+,pr
	rts
	nop
L2298:
L2292:
	bra	L2291
	nop
L2293:
	mov.l	L2306,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2292
L2286:
L2285:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2300:	.short	136
L2303:	.short	128
L2304:	.short	130
	.align 2
L2301:	.long	_FUN_06046478
L2302:	.long	_FUN_06046602
L2305:	.long	_FUN_06045a2c
L2306:	.long	_FUN_06045a7e
	.global _FUN_0604595a
	.align 2
_FUN_0604595a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L2324,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r0
	mov.w	L2324,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2308
	mov.l	L2325,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	mov	r0,r12
L2310:
	mov.l	@(0,r15),r0
	mov.w	L2324,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2313
	mov	r13,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2313:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r0
	mov.w	L2326,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r14,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L2317
	mov	#1,r14
L2316:
	mov	#0,r14
L2317:
	mov	r14,r0
	mov	r0,r8
	add	#4,r11
	mov.l	@(0,r15),r0
	mov.w	L2327,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.b	r8,r0
	tst	r0,r0
	bt	L2318
	mov.l	L2328,r3
	jsr	@r3
	nop
	mov.l	L2329,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L2319
	mov.l	L2330,r3
	jsr	@r3
	nop
	bra	L2319
	mov	r0,r4
L2318:
	mov.l	L2331,r3
	jsr	@r3
	nop
	mov.l	L2332,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L2322
	mov.l	L2333,r3
	jsr	@r3
	nop
L2322:
L2319:
	dt	r12
	bf	L2310
L2308:
L2307:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2326:	.short	128
L2327:	.short	130
L2324:	.long	_FUN_060459c4
L2325:	.long	_FUN_06046520
L2328:	.long	_FUN_06045ac0
L2329:	.long	_FUN_06045b10
L2330:	.long	_FUN_06045b74
L2331:	.long	_FUN_06045adc
L2332:	.long	_FUN_06045b48
L2333:	.long	_FUN_06045ba0
	.global _FUN_0604595e
	.align 2
_FUN_0604595e:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(0,r15),r0
	mov.w	L2351,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L2335
	mov.l	L2352,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	mov	r0,r12
L2337:
	mov.l	@(0,r15),r0
	mov.w	L2351,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L2340
	mov	r13,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2340:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r0
	mov.w	L2353,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r14,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L2344
	mov	#1,r14
L2343:
	mov	#0,r14
L2344:
	mov	r14,r0
	mov	r0,r8
	add	#4,r11
	mov.l	@(0,r15),r0
	mov.w	L2354,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.b	r8,r0
	tst	r0,r0
	bt	L2345
	mov.l	L2355,r3
	jsr	@r3
	nop
	mov.l	L2356,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L2346
	mov.l	L2357,r3
	jsr	@r3
	nop
	bra	L2346
	mov	r0,r4
L2345:
	mov.l	L2358,r3
	jsr	@r3
	nop
	mov.l	L2359,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L2349
	mov.l	L2360,r3
	jsr	@r3
	nop
L2349:
L2346:
	dt	r12
	bf	L2337
L2335:
L2334:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2351:	.short	136
L2353:	.short	128
L2354:	.short	130
	.align 2
L2352:	.long	_FUN_06046520
L2355:	.long	_FUN_06045ac0
L2356:	.long	_FUN_06045b10
L2357:	.long	_FUN_06045b74
L2358:	.long	_FUN_06045adc
L2359:	.long	_FUN_06045b48
L2360:	.long	_FUN_06045ba0
	.global _FUN_060459c4
	.align 2
_FUN_060459c4:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	L2365,r0
	jsr	@r0
	mov	r5,r13
	mov.l	@(0,r15),r0
	mov.w	L2366,r1
	add	r1,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	add	#44,r0
	mov.l	r14,@r0
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	r13,@r0
	mov.l	@r13,r12
	mov.l	@(0,r15),r0
	mov.w	L2367,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r12,r2
	shlr16	r2
	exts.w	r2,r2
	add	r2,r1
	mov.w	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L2368,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r12,r2
	exts.w	r2,r2
	add	r2,r1
	mov.w	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L2369,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@(2,r13),r0
	mov.w	r0,@r1
	mov.l	@(4,r15),r0
	add	#40,r0
	mov	r13,r1
	mov.l	@(12,r13),r2
	add	r2,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.l	L2370,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r8
	mov	#3,r0
	mov.l	r0,@(8,r15)
L2362:
	mov.l	@(4,r14),r11
	mov.l	@(8,r14),r10
	mov	r14,r9
	add	#12,r9
	mov.l	@r14,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@r8
	mov	r11,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@(4,r8)
	mov	r10,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@(8,r8)
	add	#16,r14
	mov.l	@r9,r0
	mov.l	r0,@(12,r8)
	mov.l	@(8,r15),r0
	add	#-1,r0
	mov.l	r0,@(8,r15)
	add	#16,r8
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L2362
	add	#12,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2366:	.short	148
L2367:	.short	168
L2368:	.short	170
L2369:	.short	142
L2365:	.long	_FUN_06045698
L2370:	.long	_DAT_06045b0c
	.global _FUN_06045a2c
	.align 2
_FUN_06045a2c:
	sts.l	pr,@-r15
	add	#-20,r15
	mov	r15,r9
	mov.l	L2376,r3
	jsr	@r3
	add	#0,r9
	mov.l	@(4,r8),r0
	mov.l	@(16,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	@(8,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L2372
	mov.l	@(4,r15),r0
	mov.w	L2377,r1
	add	r1,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2374
	mov.l	L2378,r3
	jsr	@r3
	nop
	mov	r9,r10
L2374:
	mov.l	L2379,r3
	jsr	@r3
	nop
	mov.l	L2380,r3
	mov.l	@(16,r15),r0
	mov.l	@(12,r15),r0
	mov.l	@(8,r15),r0
	mov.l	@r0,r13
	mov.l	@r0,r12
	mov.l	@r0,r11
	mov.l	@r8,r0
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov.l	L2380,r3
	jsr	@r3
	mov.l	r11,@(24,r10)
	mov.l	@(4,r15),r0
	mov.w	L2381,r1
	add	r1,r0
	mov	#4,r1
	mov.l	L2382,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2376,r1
	add	r1,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov	r14,r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2372:
L2371:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2377:	.short	128
L2381:	.short	155
L2376:	.long	_FUN_06045ac0
L2378:	.long	_FUN_06045c9c
L2379:	.long	_FUN_06045e44
L2380:	.long	_FUN_06045d04
L2382:	.long	_FUN_06045e06
	.global _FUN_06045a7e
	.align 2
_FUN_06045a7e:
	sts.l	pr,@-r15
	mov.l	L2388,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L2384
	mov.w	L2389,r0
	add	r10,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2386
	mov.l	L2390,r3
	jsr	@r3
	nop
L2386:
	mov.l	L2391,r3
	jsr	@r3
	nop
	mov.l	L2392,r3
	jsr	@r3
	nop
	mov.l	L2393,r3
	jsr	@r3
	nop
	mov.w	L2393,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L2394,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.w	L2388,r0
	add	r10,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	nop
L2384:
L2383:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2389:	.short	128
	.align 2
L2388:	.long	_func_0x06045adc
L2390:	.long	_FUN_06045c9c
L2391:	.long	_FUN_06045e44
L2392:	.long	_FUN_06045c3c
L2393:	.long	_FUN_06045d80
L2394:	.long	_FUN_06045e06
	.global _FUN_06045ac0
	.align 2
_FUN_06045ac0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L2398,r0
	add	r10,r0
	mov.w	@r0,r0
	mov	#32,r1
	and	r1,r0
	tst	r0,r0
	bf	L2396
	mov.w	L2398,r0
	add	r10,r0
	mov.w	@r0,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2396:
	mov	r12,r0
	add	#10,r0
	mov.w	@r0,r14
	mov	r12,r0
	add	#12,r0
	mov.w	@r0,r13
	mov	r11,r1
	add	#64,r1
	mov.w	@(8,r12),r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r0
	add	#64,r0
L2395:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2398:	.short	128
	.align 2
	.global _FUN_06045adc
	.align 2
_FUN_06045adc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L2402,r0
	add	r10,r0
	mov.w	@r0,r0
	mov	#32,r1
	and	r1,r0
	tst	r0,r0
	bf	L2400
	mov.w	L2402,r0
	add	r10,r0
	mov.w	@r0,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2400:
	mov	r12,r0
	add	#8,r0
	mov.w	@r0,r14
	mov	r12,r0
	add	#10,r0
	mov.w	@r0,r13
	mov	r11,r1
	add	#64,r1
	mov.w	@(6,r12),r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r0
	add	#64,r0
L2399:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2402:	.short	128
	.align 2
	.global _FUN_06045af4
	.align 2
_FUN_06045af4:
	mov	r5,r0
	add	#2,r0
	mov.w	@r0,r7
	mov.w	@(4,r5),r0
	mov	r0,r6
	mov	r4,r1
	add	#64,r1
	mov.w	@r5,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r4,r1
	add	#68,r1
	mov	r7,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r4,r1
	add	#72,r1
	mov	r6,r0
	shll2	r0
	rts
	mov.l	r0,@r1
	.global _FUN_06045b10
	.align 2
_FUN_06045b10:
	add	#-4,r15
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2405
	mov	#2,r0
	mov	r7,r4
	and	r0,r4
	mov.b	@(7,r8),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2407
	mov	#2,r0
	mov	r7,r6
	and	r0,r6
	mov.b	@(7,r9),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2409
	mov	#2,r0
	mov	r7,r5
	and	r0,r5
	mov.b	@(7,r10),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2411
	mov	#2,r0
	mov	r7,r1
	and	r0,r1
	mov	r4,r0
	shll	r0
	or	r6,r0
	shll	r0
	or	r5,r0
	shll	r0
	mov	r1,r0
	or	r0,r0
	add	#4,r15
	rts
	nop
L2411:
L2409:
L2407:
L2405:
L2404:
	add	#4,r15
	rts
	mov	r7,r0
	.global _FUN_06045b48
	.align 2
_FUN_06045b48:
	mov.b	@(7,r9),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2414
	mov	#2,r0
	mov	r7,r5
	and	r0,r5
	mov.b	@(7,r10),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2416
	mov	#2,r0
	mov	r7,r6
	and	r0,r6
	mov.b	@(7,r4),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L2418
	mov	#2,r0
	mov	r7,r1
	and	r0,r1
	mov	r5,r0
	shll	r0
	or	r6,r0
	shll	r0
	mov	r1,r0
	or	r0,r0
	rts
	nop
L2418:
L2416:
L2414:
L2413:
	rts
	mov	r7,r0
	.global _FUN_06045b74
	.align 2
_FUN_06045b74:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r0
	extu.b	r10,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2421
	mov.l	L2427,r0
	mov	r13,r1
	shll2	r1
	add	r0,r1
	mov.w	@r1,r1
	shll2	r1
	mov	r1,r3
	add	r0,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2421:
	mov.w	L2427,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2423
	mov.l	L2428,r3
	jsr	@r3
	nop
L2423:
	mov.l	L2429,r3
	jsr	@r3
	nop
	mov	r11,r0
	add	#4,r0
	mov.l	@r0,r12
	cmp/ge	r12,r14
	bt	L2425
	mov.w	L2430,r0
	add	r9,r0
	mov.l	L2431,r3
	jsr	@r3
	mov.l	L2432,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2430,r4
	add	r9,r4
	mov.l	L2433,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2434,r0
	add	r9,r0
	mov.w	@r0,r1
	mov.w	L2432,r2
	add	r9,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2425:
L2420:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2430:	.short	156
L2434:	.short	136
L2427:	.long	_DAT_06045b80
L2428:	.long	_FUN_06045c9c
L2429:	.long	_FUN_06045d04
L2431:	.long	_FUN_06045e44
L2432:	.long	_FUN_0604698c
L2433:	.long	_FUN_06045e06
	.global _FUN_06045ba0
	.align 2
_FUN_06045ba0:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r0
	extu.b	r10,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2436
	mov.l	L2442,r0
	mov	r13,r1
	shll2	r1
	add	r0,r1
	mov.w	@r1,r1
	shll2	r1
	mov	r1,r3
	add	r0,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2436:
	mov.w	L2442,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2438
	mov.l	L2443,r3
	jsr	@r3
	nop
L2438:
	mov.l	L2444,r3
	jsr	@r3
	nop
	mov	r11,r0
	add	#4,r0
	mov.l	@r0,r12
	cmp/ge	r12,r14
	bt	L2440
	mov.w	L2445,r0
	add	r9,r0
	mov.l	L2446,r3
	jsr	@r3
	mov.l	L2447,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2445,r4
	add	r9,r4
	mov.l	L2448,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2449,r0
	add	r9,r0
	mov.w	@r0,r1
	mov.w	L2447,r2
	add	r9,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2440:
L2435:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2445:	.short	156
L2449:	.short	136
L2442:	.long	_DAT_06045bac
L2443:	.long	_FUN_06045c9c
L2444:	.long	_FUN_06045d80
L2446:	.long	_FUN_06045e44
L2447:	.long	_FUN_06046a20
L2448:	.long	_FUN_06045e06
	.global _FUN_06045bc4
	.align 2
_FUN_06045bc4:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2455,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2451
	mov.l	L2456,r3
	jsr	@r3
	nop
L2451:
	mov.l	L2457,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L2453
	mov.w	L2458,r0
	add	r11,r0
	mov.l	L2459,r3
	jsr	@r3
	mov.l	L2460,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2458,r4
	add	r11,r4
	mov.l	L2461,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2462,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L2460,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2453:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2455:	.short	128
L2458:	.short	156
L2462:	.short	136
	.align 2
L2456:	.long	_FUN_06045c9c
L2457:	.long	_FUN_06045d04
L2459:	.long	_FUN_06045e44
L2460:	.long	_FUN_0604698c
L2461:	.long	_FUN_06045e06
	.global _FUN_06045bc6
	.align 2
_FUN_06045bc6:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2468,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2464
	mov.l	L2469,r3
	jsr	@r3
	nop
L2464:
	mov.l	L2470,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L2466
	mov.w	L2471,r0
	add	r11,r0
	mov.l	L2472,r3
	jsr	@r3
	mov.l	L2473,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2471,r4
	add	r11,r4
	mov.l	L2474,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2475,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L2473,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2466:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2468:	.short	128
L2471:	.short	156
L2475:	.short	136
	.align 2
L2469:	.long	_FUN_06045c9c
L2470:	.long	_FUN_06045d04
L2472:	.long	_FUN_06045e44
L2473:	.long	_FUN_0604698c
L2474:	.long	_FUN_06045e06
	.global _FUN_06045c00
	.align 2
_FUN_06045c00:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2481,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2477
	mov.l	L2482,r3
	jsr	@r3
	nop
L2477:
	mov.l	L2483,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L2479
	mov.w	L2484,r0
	add	r11,r0
	mov.l	L2485,r3
	jsr	@r3
	mov.l	L2486,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2484,r4
	add	r11,r4
	mov.l	L2487,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2488,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L2486,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2479:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2481:	.short	128
L2484:	.short	156
L2488:	.short	136
	.align 2
L2482:	.long	_FUN_06045c9c
L2483:	.long	_FUN_06045d80
L2485:	.long	_FUN_06045e44
L2486:	.long	_FUN_06046a20
L2487:	.long	_FUN_06045e06
	.global _FUN_06045c02
	.align 2
_FUN_06045c02:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2494,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2490
	mov.l	L2495,r3
	jsr	@r3
	nop
L2490:
	mov.l	L2496,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L2492
	mov.w	L2497,r0
	add	r11,r0
	mov.l	L2498,r3
	jsr	@r3
	mov.l	L2499,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.w	L2497,r4
	add	r11,r4
	mov.l	L2500,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2501,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L2499,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L2492:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2494:	.short	128
L2497:	.short	156
L2501:	.short	136
	.align 2
L2495:	.long	_FUN_06045c9c
L2496:	.long	_FUN_06045d80
L2498:	.long	_FUN_06045e44
L2499:	.long	_FUN_06046a20
L2500:	.long	_FUN_06045e06
	.global _FUN_06045c3c
	.align 2
_FUN_06045c3c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	r4,r14
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	@(20,r15),r0
	mov.l	@r0,r9
	mov	#14,r0
	mov	r10,r1
	and	r0,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#10,r1
	cmp/gt	r1,r0
	bt	L2513
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2506 - Lswt0
	.short	L2503 - Lswt0
	.short	L2507 - Lswt0
	.short	L2503 - Lswt0
	.short	L2508 - Lswt0
	.short	L2503 - Lswt0
	.short	L2509 - Lswt0
	.short	L2503 - Lswt0
	.short	L2510 - Lswt0
	.short	L2503 - Lswt0
	.short	L2511 - Lswt0
L2513:
	mov.l	@(0,r15),r0
	cmp/eq	#14,r0
	bt	L2512
	bra	L2503
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(8,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(24,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	@(24,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r9,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	r9,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov	r14,r0
	add	#28,r0
	mov	#14,r1
	mov	r10,r2
	and	r1,r2
	mov.l	r2,@r0
	mov	r9,r0
	exts.b	r0,r0
	mov.b	r0,@r13
	mov.l	L2516,r0
	jsr	@r0
	nop
L2512:
	mov.l	L2516,r0
	jsr	@r0
	nop
L2503:
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2514
	mov.l	L2516,r0
	jsr	@r0
	nop
L2514:
	mov.l	L2516,r0
	jsr	@r0
	nop
L2502:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2516:	.long	_halt_baddata
	.global _FUN_06045c9c
	.align 2
_FUN_06045c9c:
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r9,r0
	add	#2,r0
	mov.w	@r0,r14
	mov.w	@(2,r8),r0
	mov	r0,r1
	mov	r14,r0
	sub	r0,r1
	mov	r1,r0
	exts.w	r0,r1
	mov.w	@r9,r0
	mov	r0,r2
	mov.w	@r4,r0
	sub	r0,r2
	mov	r2,r0
	exts.w	r0,r0
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(4,r15)
	mov	r4,r0
	add	#2,r0
	mov.w	@r0,r7
	mov	r5,r1
	add	#-2,r1
	mov.w	@r8,r0
	mov	r0,r2
	mov.w	@r9,r0
	sub	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov	r5,r1
	add	#-4,r1
	mov	r7,r2
	mov	r14,r0
	sub	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov	r5,r0
	add	#-4,r0
	mov.l	@r0,r0
	exts.w	r0,r0
	mov	r5,r1
	add	#-2,r1
	mov.l	@r1,r1
	exts.w	r1,r1
	mul.l	r1,r0
	sts	macl,r0
	mov.l	r0,@(0,r15)
	mov	#-1,r0
	mov.l	@(0,r15),r1
	cmp/ge	r1,r0
	bf/s	L2521
	mov	#1,r14
L2520:
	mov	#0,r14
L2521:
	mov.l	@(4,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L2523
	mov	#1,r7
L2522:
	mov	#0,r7
L2523:
	mov	r14,r6
	add	r7,r6
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	add	r1,r0
	mov.l	r0,@(0,r15)
	mov	#1,r0
	mov.l	@(8,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L2524
	mov.l	@(0,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L2531
	mov	#1,r14
L2530:
	mov	#0,r14
L2531:
	mov.l	@(4,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L2533
	mov	#1,r7
L2532:
	mov	#0,r7
L2533:
	mov	r14,r0
	add	r7,r0
	exts.b	r0,r0
	cmp/eq	#1,r0
	bf	L2525
	exts.b	r6,r0
	tst	r0,r0
	bf	L2534
	mov.l	L2541,r0
	bra	L2525
	mov.l	r0,@(0,r15)
L2534:
	exts.b	r6,r0
	cmp/eq	#2,r0
	bf	L2525
	mov.l	L2542,r0
	bra	L2525
	mov.l	r0,@(0,r15)
L2524:
	mov.l	@(0,r15),r0
	mov.l	@(4,r15),r1
	cmp/ge	r1,r0
	bf/s	L2540
	mov	#1,r14
L2539:
	mov	#0,r14
L2540:
	add	r14,r0
	mov.l	r0,@(0,r15)
L2525:
	add	#12,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(0,r15),r0
	.align 2
L2541:	.short	2147483647
L2542:	.short	-2147483648
	.global _FUN_06045ccc
	.align 2
_FUN_06045ccc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	L2549,r14
	tst	r4,r4
	bt	L2544
	mov.l	L2550,r14
L2544:
	mov	#5,r11
	mov.l	L2551,r0
	mov.l	@r0,r12
L2546:
	mov	r14,r13
	mov.w	@r13,r0
	mov.w	r0,@r12
	add	#-1,r11
	add	#2,r12
	mov	r13,r14
	add	#2,r14
	tst	r11,r11
	bf	L2546
	mov.l	L2552,r0
	mov.l	@r0,r1
	mov.w	@(2,r13),r0
	mov.w	r0,@r1
	mov	r13,r0
	add	#4,r0
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2549:	.long	_DAT_06045cec
L2550:	.long	_DAT_06045cf8
L2551:	.long	_PTR_DAT_06045de0
L2552:	.long	_PTR_DAT_06045de4
	.global _FUN_06045d04
	.align 2
_FUN_06045d04:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-8,r15
	mov.l	@(4,r15),r0
	add	#4,r0
	mov.l	@r0,r11
	mov.l	@(4,r8),r12
	mov.l	@(4,r10),r13
	mov	#14,r0
	mov	r14,r1
	and	r0,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L2554
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2567 - Lswt0
	.short	L2554 - Lswt0
	.short	L2568 - Lswt0
	.short	L2554 - Lswt0
	.short	L2557 - Lswt0
	.short	L2554 - Lswt0
	.short	L2564 - Lswt0
	.short	L2554 - Lswt0
	.short	L2565 - Lswt0
	.short	L2554 - Lswt0
	.short	L2566 - Lswt0
	.short	L2554 - Lswt0
	.short	L2567 - Lswt0
	.short	L2554 - Lswt0
	.short	L2568 - Lswt0
	bra	L2554
	nop
	cmp/ge	r11,r13
	bt	L2558
	mov	r11,r13
L2558:
	cmp/ge	r12,r13
	bt	L2560
	mov	r12,r13
L2560:
	mov.l	@(4,r9),r0
	cmp/ge	r0,r13
	bt	L2555
	mov.l	L2575,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L2575,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L2576,r3
	jsr	@r3
	nop
	mov.l	L2577,r0
	mov.l	@r0,r0
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L2575,r0
	add	r9,r0
	mov	r13,r1
	mov.b	r1,@r0
	mov.l	L2578,r0
	jsr	@r0
	nop
	mov.l	L2575,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	cmp/gt	r13,r11
	bt	L2569
	mov	r11,r13
L2569:
	cmp/gt	r13,r12
	bt	L2571
	mov	r12,r13
L2571:
	mov.l	@(4,r9),r0
	cmp/gt	r13,r0
	bt	L2573
	mov.l	L2575,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2573:
L2554:
L2555:
	mov.l	L2575,r0
L2553:
	add	#8,r15
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
L2575:	.long	_switchD_06045d12__switchdataD_06045df0
L2576:	.long	_FUN_06045D3C
L2577:	.long	_DAT_06045de8
L2578:	.long	_halt_baddata
	.global _FUN_06045D3C
	.align 2
_FUN_06045D3C:
	cmp/ge	r7,r4
	bt	L2580
	mov	r7,r4
L2580:
	cmp/ge	r6,r4
	bt	L2582
	mov	r6,r4
L2582:
	cmp/ge	r5,r4
L2579:
	rts
	nop
	.global _FUN_06045D6A
	.align 2
_FUN_06045D6A:
	sts.l	pr,@-r15
	mov.l	L2587,r3
	jsr	@r3
	nop
	mov.l	L2588,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r0,r0
	.align 2
L2587:	.long	_caseD_4
L2588:	.long	_DAT_06045de8
	.global _FUN_06045d80
	.align 2
_FUN_06045d80:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-16,r15
	mov.l	@(8,r15),r0
	add	#4,r0
	mov.l	@r0,r9
	mov	#14,r0
	mov	r14,r1
	and	r0,r1
	mov.l	L2609,r0
	add	r1,r0
	mov.w	@r0,r0
	mov	r0,r13
	mov.l	@(4,r8),r10
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L2590
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2593 - Lswt0
	.short	L2590 - Lswt0
	.short	L2594 - Lswt0
	.short	L2590 - Lswt0
	.short	L2599 - Lswt0
	.short	L2590 - Lswt0
	.short	L2604 - Lswt0
	.short	L2590 - Lswt0
	.short	L2605 - Lswt0
	.short	L2590 - Lswt0
	.short	L2606 - Lswt0
	.short	L2590 - Lswt0
	.short	L2607 - Lswt0
	.short	L2590 - Lswt0
	.short	L2608 - Lswt0
	bra	L2590
	nop
	mov.l	L2610,r0
	mov.l	@r0,r0
	add	#16,r15
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
L2610:	.short	-2147483648
	mov	r9,r0
	mov	r10,r1
	cmp/gt	r1,r0
	bt	L2595
	mov	r9,r10
L2595:
	mov.l	@(12,r15),r0
	add	#4,r0
	mov.l	@r0,r0
	mov	r10,r1
	cmp/gt	r1,r0
	bt	L2591
	mov.l	L2609,r0
	nop
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov	r10,r0
	mov	r9,r1
	cmp/ge	r1,r0
	bt	L2600
	mov	r9,r10
L2600:
	mov	r10,r0
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	cmp/ge	r1,r0
	bt	L2591
	mov.l	L2609,r0
	nop
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L2609,r0
	nop
	add	#16,r15
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
L2609:	.short	2147483647
	mov.l	L2611,r3
	jsr	@r3
	nop
	mov.l	L2612,r0
	mov.l	@r0,r0
	add	#16,r15
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
L2612:	.short	156
	mov.l	@(4,r15),r0
	mov.w	L2613,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2614,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2615,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2616,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2617,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2618,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2619,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2611,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2620,r1
	add	r1,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#120,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#92,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#68,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#44,r0
	mov.l	L2628,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#16,r0
	mov.l	L2628,r1
	mov.l	L2621,r0
	mov.l	r1,@r0
	jsr	@r0
	nop
	mov.l	L2622,r1
	add	r9,r1
	mov	#93,r0
	mov.b	r0,@r1
	mov.l	L2623,r1
	add	r9,r1
	mov	#-4,r0
	mov.b	r0,@r1
	mov.l	L2628,r0
	mov	r0,r1
	mov.b	@r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2628,r1
	mov.l	L2625,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L2626,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2628,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov	r12,r13
	add	#1,r13
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r12,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r11,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r1
	mov.l	L2625,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L2626,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov	r11,r13
	add	#1,r13
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r11,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r10,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r1
	mov.l	L2625,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L2626,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L2624,r1
	mov.w	r1,@r0
	mov.l	L2633,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L2630,r1
	mov.w	r1,@r0
	mov	r10,r13
	add	#1,r13
	mov.l	L2633,r0
	mov	r0,r1
	mov.b	@r10,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L2630,r1
	mov.w	r1,@r0
	mov.l	L2633,r1
	mov.l	L2631,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L2632,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L2630,r1
	mov.l	L2629,r0
	mov.w	r1,@r0
	jsr	@r0
	nop
	mov.l	@(4,r15),r0
	add	#18,r0
	mov.l	L2627,r1
	mov.l	L2629,r0
	mov.w	r1,@r0
	jsr	@r0
	nop
L2590:
L2591:
	mov.l	L2634,r0
L2589:
	add	#16,r15
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
L2613:	.short	356
L2614:	.short	328
L2615:	.short	300
L2616:	.short	276
L2617:	.short	248
L2618:	.short	220
L2619:	.short	196
L2620:	.short	144
L2622:	.short	100949500
L2623:	.short	100949501
L2624:	.short	24060
L2625:	.short	65280
L2626:	.short	-65536
L2627:	.short	42160
L2630:	.short	24060
L2631:	.short	65280
L2632:	.short	-65536
	.align 2
L2611:	.long	_FUN_06045DAA
L2621:	.long	_halt_baddata
L2628:	.long	_switchD_06045d8c__switchdataD_06045dfc
L2629:	.long	_halt_baddata
L2633:	.long	_switchD_06045d8c__switchdataD_06045dfc
L2634:	.long	_switchD_06045d8c__switchdataD_06045dfc
	.global _FUN_06045DAA
	.align 2
_FUN_06045DAA:
	cmp/ge	r6,r4
	bt	L2636
	mov	r6,r4
L2636:
	cmp/ge	r5,r4
L2635:
	rts
	nop
	.global _FUN_06045DCC
	.align 2
_FUN_06045DCC:
	sts.l	pr,@-r15
	mov.l	L2641,r3
	jsr	@r3
	nop
	mov.l	L2642,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r0,r0
	.align 2
L2641:	.long	_caseD_4
L2642:	.long	_DAT_06045de8
	.global _FUN_06045e06
	.align 2
_FUN_06045e06:
	mov.l	@(32,r5),r0
	mov	r4,r1
	shlr8	r1
	shlr2	r1
	mov.w	L2646,r2
	and	r2,r1
	add	r1,r0
	mov	r0,r6
	mov.w	@r6,r0
	tst	r0,r0
	bt	L2644
	mov.l	L2647,r0
	mov.l	@r0,r1
	mov.w	@(2,r6),r0
	shll2	r0
	shll	r0
	add	r0,r1
	mov	r1,r1
	add	#2,r1
	mov.w	r7,@r1
	mov.w	L2648,r0
	add	r11,r0
	mov.b	@r0,r0
	mov	r0,r1
	add	#-4,r1
	exts.w	r7,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(2,r6)
	rts
	nop
L2644:
	mov.w	r7,@r6
	mov.w	L2648,r0
	add	r11,r0
	mov.b	@r0,r0
	mov	r0,r1
	add	#-4,r1
	exts.w	r7,r0
	add	r0,r1
	mov	r1,r0
L2643:
	rts
	mov.w	r0,@(2,r6)
	.align 2
L2646:	.short	-8
L2648:	.short	155
L2647:	.long	_DAT_06045e40
	.global _FUN_06045e44
	.align 2
_FUN_06045e44:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L2662,r0
	mov.l	@r0,r0
	mov	r14,r1
	shll2	r1
	shll	r1
	add	r1,r0
	mov	r0,r10
	mov.w	L2663,r0
	add	r8,r0
	mov.w	@r0,r0
	shlr2	r0
	shlr2	r0
	mov	#30,r1
	and	r1,r0
	mov.l	r0,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#12,r1
	cmp/eq	#12,r0
	bt	L2657
	cmp/gt	r1,r0
	bt	L2660
	mov.l	@(0,r15),r0
	mov	#8,r1
	cmp/gt	r1,r0
	bt	L2650
L2660:
	mov.l	@(0,r15),r0
	mov	#24,r1
	cmp/gt	r1,r0
	bt	L2661
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2658 - Lswt0
	.short	L2650 - Lswt0
	.short	L2658 - Lswt0
	.short	L2650 - Lswt0
	.short	L2654 - Lswt0
	.short	L2650 - Lswt0
	.short	L2654 - Lswt0
	.short	L2650 - Lswt0
	.short	L2658 - Lswt0
L2661:
	mov.l	@(0,r15),r0
	cmp/eq	#28,r0
	bt	L2651
	bra	L2650
	nop
L2650:
	mov.w	L2664,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L2665,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L2666,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L2667,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2668,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L2669,r0
	mov.l	@r0,r1
	exts.w	r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r10)
	mov.w	L2664,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L2665,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L2666,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L2670,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2668,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L2669,r0
	mov.l	@r0,r1
	exts.w	r11,r0
	add	r0,r1
	mov	r1,r0
	bra	L2651
	mov.w	r0,@(28,r10)
	mov.w	L2664,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L2665,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L2666,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L2670,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	L2671,r3
	jsr	@r3
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2657:
	mov.l	L2671,r3
	jsr	@r3
	nop
	bra	L2651
	nop
	mov.w	L2675,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L2676,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L2677,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L2672,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2651:
	mov.l	@(40,r9),r1
	mov.w	L2675,r0
	add	r8,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r12
	mov.w	L2677,r0
	add	r8,r0
	mov.l	@r0,r0
	mov.l	@r12,r1
	or	r1,r0
	mov.l	r0,@(4,r10)
	mov.l	@(4,r12),r0
	mov.l	r0,@(8,r10)
	mov.l	L2673,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L2674,r0
	add	r8,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
L2649:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r10
	.align 2
L2663:	.short	128
L2664:	.short	130
L2665:	.short	146
L2666:	.short	148
L2674:	.short	128
L2675:	.short	130
L2676:	.short	146
L2677:	.short	148
L2662:	.long	_DAT_06045f20
L2667:	.long	_DAT_06045f16
L2668:	.long	_FUN_06045fc0
L2669:	.long	_DAT_06045f1a
L2670:	.long	_DAT_06045f1c
L2671:	.long	_FUN_06045f46
L2672:	.long	_DAT_06045f18
L2673:	.long	_DAT_06045f26
	.global _FUN_06045EA8
	.align 2
_FUN_06045EA8:
	sts.l	pr,@-r15
	mov.l	L2679,r3
	jsr	@r3
	mov.l	@(44,r12),r4
	mov.l	L2680,r0
	mov.l	@r0,r1
	exts.w	r14,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r13)
	mov.w	L2681,r0
	add	r11,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r13)
	mov.w	L2682,r0
	add	r11,r0
	mov.w	@r0,r0
	mov.w	r0,@r13
	mov.w	L2683,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L2684,r1
	mov.l	@r1,r1
	or	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(4,r13)
	.align 2
L2681:	.short	130
L2682:	.short	146
L2683:	.short	148
	.align 2
L2679:	.long	_FUN_06045fc0
L2680:	.long	_DAT_06045f1a
L2684:	.long	_DAT_06045f1c
	.global _FUN_06045EC8
	.align 2
_FUN_06045EC8:
	mov.l	@(40,r5),r1
	mov.w	L2686,r0
	add	r4,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r7
	mov.w	L2687,r0
	add	r4,r0
	mov.l	@r0,r0
	mov.l	@r7,r1
	or	r1,r0
	mov.l	r0,@(4,r6)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r6)
	mov.l	L2688,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L2689,r0
	add	r4,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	rts
	mov.w	r0,@r6
	.align 2
L2686:	.short	130
L2687:	.short	148
L2689:	.short	128
	.align 2
L2688:	.long	_DAT_06045f26
	.global _FUN_06045EE8
	.align 2
_FUN_06045EE8:
	sts.l	pr,@-r15
	mov.l	L2691,r3
	jsr	@r3
	mov.l	@(44,r11),r4
	mov.l	L2692,r0
	mov.l	@r0,r1
	exts.w	r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r12)
	mov.l	@(40,r11),r1
	mov.w	L2691,r0
	add	r10,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.w	L2692,r0
	add	r10,r0
	mov.l	@r0,r0
	mov.l	@r14,r1
	or	r1,r0
	mov.l	r0,@(4,r12)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r12)
	mov.l	L2693,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L2694,r0
	add	r10,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r12
	.align 2
L2694:	.short	128
	.align 2
L2691:	.long	_FUN_06045fc0
L2692:	.long	_DAT_06045f1a
L2693:	.long	_DAT_06045f26
	.global _FUN_06045F0C
	.align 2
_FUN_06045F0C:
	sts.l	pr,@-r15
	mov.l	L2696,r3
	jsr	@r3
	nop
	mov.l	@(40,r12),r1
	mov.w	L2696,r0
	add	r11,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.w	L2697,r0
	add	r11,r0
	mov.l	@r0,r0
	mov.l	@r14,r1
	or	r1,r0
	mov.l	r0,@(4,r13)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r13)
	mov.l	L2698,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L2699,r0
	add	r11,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r13
	.align 2
L2697:	.short	148
L2699:	.short	128
L2696:	.long	_FUN_06045f46
L2698:	.long	_DAT_06045f26
	.global _FUN_06045f46
	.align 2
_FUN_06045f46:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r4,r14
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	@(0,r15),r0
	mov.w	L2712,r1
	add	r1,r0
	mov.w	@r0,r8
	mov	r11,r1
	add	#28,r1
	mov.w	r8,@r1
	mov.l	@(0,r15),r0
	mov.w	L2712,r1
	add	r1,r0
	mov	r0,r1
	mov	r8,r0
	add	#1,r0
	mov.w	r0,@r1
	mov	r8,r0
	shll2	r0
	shll	r0
	mov.l	L2713,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(36,r15)
	mov.l	@(0,r15),r0
	mov.w	L2714,r1
	add	r1,r0
	mov.b	@r0,r0
	mov	#14,r1
	and	r1,r0
	mov.l	r0,@(32,r15)
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(32,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L2701
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2703 - Lswt0
	.short	L2701 - Lswt0
	.short	L2704 - Lswt0
	.short	L2701 - Lswt0
	.short	L2705 - Lswt0
	.short	L2701 - Lswt0
	.short	L2706 - Lswt0
	.short	L2701 - Lswt0
	.short	L2707 - Lswt0
	.short	L2701 - Lswt0
	.short	L2708 - Lswt0
	.short	L2701 - Lswt0
	.short	L2709 - Lswt0
	.short	L2701 - Lswt0
	.short	L2711 - Lswt0
	bra	L2701
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(8,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(32,r15),r0
	add	#20,r0
	mov.l	@(24,r15),r1
	mov.l	L2715,r0
	mov.l	r1,@r0
	jsr	@r0
	nop
	mov.l	@(24,r15),r0
	exts.b	r0,r0
	mov.b	r0,@r13
	mov.l	L2716,r0
	mov.l	@r0,r0
	mov.l	L2717,r1
	mov.l	@r1,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	r0,@(8,r12)
	mov.l	L2718,r0
	mov.l	@r0,r0
	mov.l	r0,@(40,r15)
	mov.l	L2719,r0
	mov.l	@r0,r0
	mov.l	@(12,r15),r1
	mov.l	r1,@r0
	mov.l	@(52,r15),r0
	mov.l	@(40,r15),r1
	add	r1,r0
	mov.l	r0,@(28,r15)
	mov.l	@(28,r15),r1
	mov	r15,r0
	add	#64,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.w	r0,@r1
	mov.w	@(4,r12),r0
	mov.l	@(28,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(28,r15),r1
	add	#64,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	extu.w	r0,r2
	extu.w	r10,r0
	not	r0,r0
	and	r0,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov	#6,r1
	exts.b	r14,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L2720,r1
	mov.l	@r1,r1
	add	r1,r0
	mov	r0,r1
	mov	r15,r0
	add	#66,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(28,r15),r0
	mov.l	@(60,r15),r1
	mov.l	r1,@(8,r0)
	mov.l	@(60,r15),r0
	mov.l	r0,@r12
	add	#64,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r12)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2715,r0
	jsr	@r0
	nop
L2701:
L2700:
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2712:	.short	144
L2714:	.short	128
L2713:	.long	_DAT_06045fb0
L2715:	.long	_halt_baddata
L2716:	.long	_DAT_06044634
L2717:	.long	_DAT_06044630
L2718:	.long	_DAT_06044640
L2719:	.long	_DAT_0604463c
L2720:	.long	_DAT_06044644
	.global _FUN_06046602
	.align 2
_FUN_06046602:
	sts.l	pr,@-r15
	mov.l	@(16,r13),r0
	tst	r0,r0
	bt	L2721
	mov.w	@r13,r0
	mov	r0,r14
	mov	r10,r0
	add	#28,r0
	mov.l	@r0,r11
L2724:
	mov.l	L2727,r0
	jsr	@r0
	nop
	mov.l	L2728,r3
	jsr	@r3
	mov.l	@(44,r10),r4
	mov	r11,r1
	add	#8,r1
	mov	r12,r0
	shll	r0
	shll2	r0
	mov.l	L2729,r2
	add	r2,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	dt	r14
	add	#16,r11
	bf	L2724
L2721:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2727:	.long	_FUN_06045af4
L2728:	.long	_FUN_06045fc0
L2729:	.long	_DAT_06046658
	.global _FUN_0604660a
	.align 2
_FUN_0604660a:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.w	@r10,r0
	mov	r0,r9
	mov	r13,r0
	add	#28,r0
	mov.l	@r0,r12
L2731:
	mov.l	L2734,r0
	jsr	@r0
	nop
	mov.l	L2735,r3
	jsr	@r3
	mov.l	@(44,r13),r4
	mov	r11,r0
	shll	r0
	shll2	r0
	mov.l	L2736,r1
	add	r1,r0
	mov.w	@r0,r8
	mov	r12,r1
	add	#8,r1
	mov.w	r8,@r1
	dt	r9
	add	#16,r12
	bf	L2731
	exts.w	r8,r0
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
L2734:	.long	_FUN_06045af4
L2735:	.long	_FUN_06045fc0
L2736:	.long	_DAT_06046658
	.global _FUN_0604669e
	.align 2
_FUN_0604669e:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2747,r0
	jsr	@r0
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2748,r1
	add	r1,r0
	mov	r0,r1
	mov.l	L2749,r0
	mov.l	@r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	or	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov.l	@(0,r15),r0
	mov.w	L2750,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2737
	mov.l	L2751,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2752,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r0
	mov.l	@(8,r0),r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r9
L2740:
	mov.l	@(0,r15),r0
	mov.w	L2750,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2743
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2743:
	mov.w	@r9,r11
	mov.l	@(0,r15),r0
	mov.w	L2749,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2745
	mov.l	L2753,r3
	jsr	@r3
	nop
	bra	L2746
	nop
L2745:
	mov.l	L2754,r3
	jsr	@r3
	nop
L2746:
	mov.l	@(0,r15),r0
	mov.w	L2755,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.w	r1,@r0
	tst	r10,r10
	bf	L2740
L2737:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2748:	.short	130
L2750:	.short	136
L2755:	.short	142
	.align 2
L2747:	.long	_FUN_060459c4
L2749:	.long	_uRam06046700
L2751:	.long	_pcRam06046704
L2752:	.long	_pcRam06046708
L2753:	.long	_FUN_0604670c
L2754:	.long	_FUN_0604674e
	.global _FUN_060466a0
	.align 2
_FUN_060466a0:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2766,r0
	jsr	@r0
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2767,r1
	add	r1,r0
	mov	r0,r1
	mov.l	L2768,r0
	mov.l	@r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	or	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov.l	@(0,r15),r0
	mov.w	L2769,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2756
	mov.l	L2770,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2771,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r0
	mov.l	@(8,r0),r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r9
L2759:
	mov.l	@(0,r15),r0
	mov.w	L2769,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L2762
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2762:
	mov.w	@r9,r11
	mov.l	@(0,r15),r0
	mov.w	L2768,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2764
	mov.l	L2772,r3
	jsr	@r3
	nop
	bra	L2765
	nop
L2764:
	mov.l	L2773,r3
	jsr	@r3
	nop
L2765:
	mov.l	@(0,r15),r0
	mov.w	L2774,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.w	r1,@r0
	tst	r10,r10
	bf	L2759
L2756:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2767:	.short	130
L2769:	.short	136
L2774:	.short	142
	.align 2
L2766:	.long	_FUN_060459c4
L2768:	.long	_uRam06046700
L2770:	.long	_pcRam06046704
L2771:	.long	_pcRam06046708
L2772:	.long	_FUN_0604670c
L2773:	.long	_func_0x0604674e
	.global _FUN_0604670c
	.align 2
_FUN_0604670c:
	sts.l	pr,@-r15
	mov.l	L2780,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	or	r1,r0
	mov.l	@(4,r10),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L2776
	mov.w	L2781,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2778
	mov.l	L2782,r3
	jsr	@r3
	nop
L2778:
	mov.l	L2783,r0
	jsr	@r0
	nop
	mov.l	L2784,r0
	jsr	@r0
	nop
	mov.l	L2785,r3
	jsr	@r3
	nop
	mov.w	L2786,r0
	add	r9,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	L2787,r0
	jsr	@r0
	nop
	mov.w	L2783,r0
	add	r9,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
L2776:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2781:	.short	128
L2786:	.short	155
L2780:	.long	_func_0x06045ac0
L2782:	.long	_FUN_06045c9c
L2783:	.long	_FUN_06045e44
L2784:	.long	_FUN_06045c3c
L2785:	.long	_FUN_06045d04
L2787:	.long	_FUN_06045e06
	.global _FUN_0604674e
	.align 2
_FUN_0604674e:
	sts.l	pr,@-r15
	mov.l	L2793,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L2789
	mov.w	L2794,r0
	add	r10,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L2791
	mov.l	L2795,r3
	jsr	@r3
	nop
L2791:
	mov.l	L2796,r0
	jsr	@r0
	nop
	mov.l	L2797,r0
	jsr	@r0
	nop
	mov.l	L2798,r3
	jsr	@r3
	nop
	mov.w	L2799,r0
	add	r10,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	L2800,r0
	jsr	@r0
	nop
	mov.w	L2796,r0
	add	r10,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
L2789:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2794:	.short	128
L2799:	.short	155
L2793:	.long	_FUN_06045adc
L2795:	.long	_FUN_06045c9c
L2796:	.long	_FUN_06045e44
L2797:	.long	_FUN_06045c3c
L2798:	.long	_FUN_06045d80
L2800:	.long	_FUN_06045e06
	.global _FUN_060467b2
	.align 2
_FUN_060467b2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2808,r0
	mov.l	@r0,r12
	mov.l	L2809,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L2802
	mov.l	L2810,r0
	mov.l	@r0,r12
L2802:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2811,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L2812,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L2813,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2801
	mov.l	L2814,r3
	jsr	@r3
	nop
	mov.w	L2813,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2801
	mov.l	@(48,r12),r0
	mov.w	L2809,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L2815,r3
	jsr	@r3
L2801:
	lds.l	@r15+,pr
	rts
	mov.l	r0,@r1
	.align 2
L2811:	.short	168
L2812:	.short	170
L2813:	.short	136
	.align 2
L2808:	.long	_DAT_060468a4
L2809:	.long	__DAT_ffffffe2
L2810:	.long	_DAT_060468a8
L2814:	.long	_FUN_0604680c
L2815:	.long	_FUN_06045a2c
	.global _FUN_060467b4
	.align 2
_FUN_060467b4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2823,r0
	mov.l	@r0,r12
	mov.l	L2824,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L2817
	mov.l	L2825,r0
	mov.l	@r0,r12
L2817:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2826,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L2827,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L2828,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2816
	mov.l	L2829,r3
	jsr	@r3
	nop
	mov.w	L2828,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2816
	mov.l	@(48,r12),r0
	mov.w	L2824,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L2830,r3
	jsr	@r3
	mov.l	r0,@r1
L2816:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2826:	.short	168
L2827:	.short	170
L2828:	.short	136
	.align 2
L2823:	.long	_DAT_060468a4
L2824:	.long	__DAT_ffffffe2
L2825:	.long	_DAT_060468a8
L2829:	.long	_func_0x0604680c
L2830:	.long	_func_0x06045a2c
	.global _FUN_060468ae
	.align 2
_FUN_060468ae:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2838,r0
	mov.l	@r0,r12
	mov.l	L2839,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L2832
	mov.l	L2840,r0
	mov.l	@r0,r12
L2832:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2841,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L2842,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L2843,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2831
	mov.l	L2844,r3
	jsr	@r3
	nop
	mov.w	L2843,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2831
	mov.l	@(48,r12),r0
	mov.w	L2839,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L2845,r3
	jsr	@r3
L2831:
	lds.l	@r15+,pr
	rts
	mov.l	r0,@r1
	.align 2
L2841:	.short	168
L2842:	.short	170
L2843:	.short	136
	.align 2
L2838:	.long	_iRam06046984
L2839:	.long	__DAT_ffffffe2
L2840:	.long	_iRam06046988
L2844:	.long	_FUN_06046908
L2845:	.long	_FUN_06045a2c
	.global _FUN_060468b0
	.align 2
_FUN_060468b0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2853,r0
	mov.l	@r0,r12
	mov.l	L2854,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L2847
	mov.l	L2855,r0
	mov.l	@r0,r12
L2847:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2856,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L2857,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L2858,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2846
	mov.l	L2859,r3
	jsr	@r3
	nop
	mov.w	L2858,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L2846
	mov.l	@(48,r12),r0
	mov.w	L2854,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L2860,r3
	jsr	@r3
	mov.l	r0,@r1
L2846:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2856:	.short	168
L2857:	.short	170
L2858:	.short	136
	.align 2
L2853:	.long	_iRam06046984
L2854:	.long	__DAT_ffffffe2
L2855:	.long	_iRam06046988
L2859:	.long	_func_0x06046908
L2860:	.long	_func_0x06045a2c
	.global _FUN_0604698c
	.align 2
_FUN_0604698c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	#64,r0
	mov	r13,r1
	and	r0,r1
	tst	r1,r1
	bf	L2863
	mov	#1,r0
	bra	L2864
	mov.l	r0,@(0,r15)
L2863:
	mov	#0,r0
	mov.l	r0,@(0,r15)
L2864:
	mov.l	@(0,r15),r14
	mov	r14,r0
	tst	r14,r14
	bt/s	L2865
	mov.l	r0,@(12,r15)
	mov.l	L2873,r3
	jsr	@r3
	nop
	nop
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2865:
	mov.l	L2874,r3
	jsr	@r3
	nop
	mov.l	L2875,r3
	jsr	@r3
	nop
	mov.l	@(12,r15),r0
	mov.b	r0,@(11,r15)
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2867
	mov	r8,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2876,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2877,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(28,r15),r0
	mov.l	@r0,r12
	mov.l	@(24,r15),r0
	mov.l	@r0,r11
	mov.l	@(20,r15),r0
	mov.l	@r0,r10
	mov.l	@(16,r15),r0
	mov.l	@r0,r9
	mov.l	r12,@(12,r8)
	mov.l	r11,@(16,r8)
	mov.l	r10,@(20,r8)
	mov	r8,r0
	add	#24,r0
	mov.l	r9,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2867:
	mov.l	L2878,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L2869
	mov	r12,r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2869:
	mov.l	L2879,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2871
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov.l	L2881,r3
	jsr	@r3
	mov	#4,r4
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2871:
	mov.l	@(4,r15),r0
	mov.w	L2877,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(16,r15),r4
	mov.l	L2882,r3
	jsr	@r3
L2861:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r4,r4
	.align 2
L2876:	.short	249
L2877:	.short	155
L2873:	.long	_FUN_06046a90
L2874:	.long	_FUN_06046b70
L2875:	.long	_FUN_06046bf4
L2878:	.long	_FUN_06046bd4
L2879:	.long	_FUN_06046c14
L2880:	.long	_FUN_06046b3c
L2881:	.long	_func_0x06046e0e
L2882:	.long	_FUN_06047588
	.global _FUN_06046990
	.align 2
_FUN_06046990:
	sts.l	pr,@-r15
	add	#-20,r15
	mov.l	L2890,r3
	jsr	@r3
	nop
	mov.l	L2891,r3
	jsr	@r3
	nop
	mov.l	@(8,r15),r0
	mov.b	r0,@(7,r15)
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2884
	mov	r10,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2892,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L2893,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@r9,r14
	mov.l	@r8,r13
	mov.l	@(16,r15),r0
	mov.l	@r0,r12
	mov.l	@(12,r15),r0
	mov.l	@r0,r11
	mov.l	r14,@(12,r10)
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov	r10,r0
	add	#24,r0
	mov.l	r11,@r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2884:
	mov.l	L2894,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2886
	mov.l	L2895,r3
	jsr	@r3
	nop
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2888
	mov.l	L2896,r3
	jsr	@r3
	nop
	mov.l	L2896,r3
	jsr	@r3
	nop
	mov.l	L2896,r3
	jsr	@r3
	nop
	mov.l	L2896,r3
	jsr	@r3
	nop
	mov.l	L2897,r3
	jsr	@r3
	mov	#4,r4
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2888:
	mov.l	@(0,r15),r0
	mov.w	L2893,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(12,r15),r4
	mov.l	L2898,r3
	jsr	@r3
	mov.l	@r4,r4
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2886:
L2883:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2892:	.short	249
L2893:	.short	155
L2890:	.long	_FUN_06046b70
L2891:	.long	_FUN_06046bf4
L2894:	.long	_FUN_06046bd4
L2895:	.long	_FUN_06046c14
L2896:	.long	_FUN_06046b3c
L2897:	.long	_FUN_06046e0e
L2898:	.long	_FUN_06047588
	.global _FUN_06046a20
	.align 2
_FUN_06046a20:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	#64,r0
	mov	r13,r1
	and	r0,r1
	tst	r1,r1
	bf	L2901
	mov	#1,r0
	bra	L2902
	mov.l	r0,@(0,r15)
L2901:
	mov	#0,r0
	mov.l	r0,@(0,r15)
L2902:
	mov.l	@(0,r15),r14
	mov	r14,r10
	tst	r14,r14
	bt	L2903
	mov.l	L2911,r3
	jsr	@r3
	nop
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2903:
	mov.l	L2912,r3
	jsr	@r3
	nop
	mov.l	L2913,r3
	jsr	@r3
	nop
	mov	r10,r9
	mov	#1,r0
	mov	r10,r1
	and	r0,r1
	tst	r1,r1
	bf	L2905
	mov	r11,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2913,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L2914,r0
	add	r8,r0
	mov	#4,r1
	mov.l	L2915,r3
	jsr	@r3
	mov.b	r1,@r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2905:
	mov.l	L2916,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r9,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L2907
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2907:
	mov.l	L2917,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r9,r0
	and	r1,r0
	tst	r0,r0
	bt	L2909
	mov.l	L2918,r3
	jsr	@r3
	nop
	mov.l	L2918,r3
	jsr	@r3
	nop
	mov.l	L2918,r3
	jsr	@r3
	nop
	mov.l	L2919,r3
	jsr	@r3
	mov	#3,r4
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2909:
	mov.w	L2914,r0
	add	r8,r0
	mov	#4,r1
	mov.l	L2920,r3
	jsr	@r3
	mov.l	L2921,r3
	jsr	@r3
L2899:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.b	r1,@r0
	.align 2
L2914:	.short	155
	.align 2
L2911:	.long	_FUN_06046ae8
L2912:	.long	_FUN_06046b64
L2913:	.long	_FUN_06046bf4
L2915:	.long	_FUN_06045c3c
L2916:	.long	_FUN_06046bd4
L2917:	.long	_FUN_06046c14
L2918:	.long	_FUN_06046b3c
L2919:	.long	_func_0x06046e0e
L2920:	.long	_FUN_06047548
L2921:	.long	_FUN_06047588
	.global _FUN_06046a24
	.align 2
_FUN_06046a24:
	sts.l	pr,@-r15
	mov.l	L2929,r3
	jsr	@r3
	nop
	mov.l	L2930,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2923
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2931,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L2932,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L2933,r3
	jsr	@r3
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	nop
L2923:
	mov.l	L2934,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2925
	mov.l	L2935,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r11,r0
	and	r1,r0
	tst	r0,r0
	bt	L2927
	mov.l	L2936,r3
	jsr	@r3
	nop
	mov.l	L2936,r3
	jsr	@r3
	nop
	mov.l	L2936,r3
	jsr	@r3
	nop
	mov.l	L2937,r3
	jsr	@r3
	mov	#3,r4
	lds.l	@r15+,pr
	rts
	nop
L2927:
	mov.w	L2932,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L2938,r3
	jsr	@r3
	mov.l	L2939,r3
	jsr	@r3
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	nop
L2925:
L2922:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2931:	.short	249
L2932:	.short	155
L2929:	.long	_FUN_06046b64
L2930:	.long	_FUN_06046bf4
L2933:	.long	_FUN_06045c3c
L2934:	.long	_FUN_06046bd4
L2935:	.long	_FUN_06046c14
L2936:	.long	_FUN_06046b3c
L2937:	.long	_FUN_06046e0e
L2938:	.long	_FUN_06047548
L2939:	.long	_FUN_06047588
	.global _FUN_06046a90
	.align 2
_FUN_06046a90:
	sts.l	pr,@-r15
	mov.l	L2945,r3
	jsr	@r3
	nop
	mov.l	L2946,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2941
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2947,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L2948,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L2949,r3
	jsr	@r3
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	nop
L2941:
	mov.l	L2950,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2943
	mov.l	L2951,r3
	jsr	@r3
	nop
	mov.l	L2951,r3
	jsr	@r3
	nop
	mov.l	L2951,r3
	jsr	@r3
	nop
	mov.l	L2951,r3
	jsr	@r3
	nop
	mov.l	L2952,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2943:
L2940:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2947:	.short	249
L2948:	.short	155
L2945:	.long	_FUN_06046b70
L2946:	.long	_FUN_06046bf4
L2949:	.long	_FUN_06045c3c
L2950:	.long	_FUN_06046bd4
L2951:	.long	_FUN_06046b3c
L2952:	.long	_FUN_06046e64
	.global _FUN_06046ae8
	.align 2
_FUN_06046ae8:
	sts.l	pr,@-r15
	mov.l	L2958,r3
	jsr	@r3
	nop
	mov.l	L2959,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2954
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L2960,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L2961,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L2962,r3
	jsr	@r3
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	nop
L2954:
	mov.l	L2963,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2956
	mov.l	L2964,r3
	jsr	@r3
	nop
	mov.l	L2964,r3
	jsr	@r3
	nop
	mov.l	L2964,r3
	jsr	@r3
	nop
	mov.l	L2965,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2956:
L2953:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2960:	.short	249
L2961:	.short	155
L2958:	.long	_FUN_06046b64
L2959:	.long	_FUN_06046bf4
L2962:	.long	_FUN_06045c3c
L2963:	.long	_FUN_06046bd4
L2964:	.long	_FUN_06046b3c
L2965:	.long	_FUN_06046e64
	.global _FUN_06046b3c
	.align 2
_FUN_06046b3c:
	mov.w	@(2,r4),r0
	mov	r0,r7
	neg	r6,r0
	cmp/ge	r0,r7
	bt	L2967
	mov	r7,r0
	rts
	nop
L2967:
L2966:
	rts
	mov	r7,r0
	.global _FUN_06046b64
	.align 2
_FUN_06046b64:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	mov.w	@r9,r0
	cmp/gt	r5,r0
	bt	L2970
	mov.w	@r9,r0
	mov	r0,r5
L2970:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r9),r0
	mov	r0,r1
	cmp/gt	r1,r0
	bt	L2972
	mov.w	@(2,r9),r0
	mov	r0,r4
L2972:
	mov.w	@r10,r0
	cmp/gt	r5,r0
	bt	L2974
	mov.w	@r10,r0
	mov	r0,r5
L2974:
	mov.w	@(2,r10),r0
	mov	r0,r7
	cmp/gt	r7,r4
L2969:
	rts
	nop
	.global _FUN_06046b70
	.align 2
_FUN_06046b70:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	mov.w	@r8,r0
	cmp/gt	r5,r0
	bt	L2979
	mov.w	@r8,r0
	mov	r0,r5
L2979:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r8),r0
	mov	r0,r1
	cmp/gt	r1,r0
	bt	L2981
	mov.w	@(2,r8),r0
	mov	r0,r4
L2981:
	mov.w	@r9,r0
	cmp/gt	r5,r0
	bt	L2983
	mov.w	@r9,r0
	mov	r0,r5
L2983:
	mov.w	@(2,r9),r0
	cmp/gt	r0,r4
	bt	L2985
	mov.w	@(2,r9),r0
	mov	r0,r4
L2985:
	mov.w	@r10,r0
	cmp/gt	r5,r0
	bt	L2987
	mov.w	@r10,r0
	mov	r0,r5
L2987:
	mov.w	@(2,r10),r0
	mov	r0,r7
	cmp/gt	r7,r4
L2978:
	rts
	nop
	.global _FUN_06046b96
	.align 2
_FUN_06046b96:
	mov.w	@(2,r5),r0
	cmp/gt	r0,r4
	bt	L2992
	mov.w	@(2,r5),r0
	mov	r0,r4
L2992:
	mov.w	@(2,r6),r0
	mov	r0,r7
	cmp/gt	r7,r4
	bt	L2994
	mov	r7,r0
	rts
	nop
L2994:
L2991:
	rts
	mov	r7,r0
	.global _FUN_06046bd4
	.align 2
_FUN_06046bd4:
	mov	r7,r0
	shlr16	r0
	exts.w	r0,r6
	cmp/ge	r6,r5
	bt	L2997
	neg	r6,r6
	cmp/gt	r4,r6
	bt	L2997
	exts.w	r0,r0
	cmp/ge	r0,r10
	bt	L2997
	mov	r6,r0
	rts
	nop
L2997:
L2996:
	rts
	mov	r6,r0
	.global _FUN_06046bf4
	.align 2
_FUN_06046bf4:
	mov	r7,r0
	shlr16	r0
	exts.w	r0,r6
	cmp/ge	r6,r11
	bt	L3000
	neg	r6,r6
	cmp/gt	r5,r6
	bt	L3000
	exts.w	r0,r0
	cmp/ge	r0,r4
	bt	L3000
	mov	r6,r0
	rts
	nop
L3000:
L2999:
	rts
	mov	r6,r0
	.global _FUN_06046c14
	.align 2
_FUN_06046c14:
	cmp/ge	r7,r5
	bt	L3003
	neg	r7,r7
	cmp/ge	r6,r7
	bt	L3003
	mov	r11,r0
	add	#20,r0
	mov.l	@r0,r7
	cmp/ge	r7,r4
	bt	L3003
	neg	r7,r0
	rts
	nop
L3003:
L3002:
	rts
	mov	r7,r0
	.global _FUN_06046cd0
	.align 2
_FUN_06046cd0:
	mov.l	@(12,r7),r5
	mov.l	@(20,r7),r6
	mov.l	@(16,r7),r1
	mov.l	r1,@r0
	mov.l	r5,@(16,r7)
	mov	r7,r0
	add	#20,r0
	mov.l	@(24,r7),r1
	mov.l	r1,@r0
	mov.l	r6,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3006,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#16,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3006:	.short	239
	.align 2
	.global _FUN_06046cf0
	.align 2
_FUN_06046cf0:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(20,r5),r1
	mov.l	r1,@r0
	mov	r5,r0
	add	#16,r0
	mov.l	@(24,r5),r1
	mov.l	r1,@r0
	mov.l	r7,@(20,r5)
	mov.l	r6,@(24,r5)
	mov	r5,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3008,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#48,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3008:	.short	207
	.align 2
	.global _FUN_06046d10
	.align 2
_FUN_06046d10:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(24,r5),r1
	mov.l	r1,@r0
	mov	r5,r0
	add	#16,r0
	mov.l	@(20,r5),r1
	mov.l	r1,@r0
	mov.l	r6,@(20,r5)
	mov.l	r7,@(24,r5)
	mov	r5,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3010,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#32,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3010:	.short	223
	.align 2
	.global _FUN_06046d30
	.align 2
_FUN_06046d30:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(24,r0),r4
	mov.l	L3028,r3
	mov.l	@(0,r15),r0
	jsr	@r3
	exts.w	r4,r4
	mov	r0,r4
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bf	L3012
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3012:
	mov.l	L3028,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bt	L3014
	mov.l	L3028,r3
	jsr	@r3
	nop
	mov	r9,r8
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bf	L3016
L3018:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3029,r3
	and	r3,r2
	not	r1,r1
	mov	#48,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(20,r10),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	#16,r0
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov.l	r12,@(20,r10)
	mov.l	r11,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3016:
	mov.l	L3028,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L3019
	mov.l	L3030,r3
	jsr	@r3
	nop
	mov	r0,r13
	tst	r13,r13
	bf	L3021
	mov	#0,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3021:
	mov	r13,r0
	cmp/eq	#1,r0
	bf	L3023
	bra	L3025
	nop
L3023:
	mov	r13,r0
	cmp/eq	#2,r0
	bf	L3026
	bra	L3018
	nop
L3026:
L3019:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3032,r3
	and	r3,r2
	not	r1,r1
	mov	#32,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	#16,r0
	mov.l	@(20,r10),r1
	mov.l	r1,@r0
	mov.l	r11,@(20,r10)
	mov.l	r12,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3014:
L3025:
	mov.l	@(12,r10),r12
	mov.l	@(20,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3031,r3
	and	r3,r2
	not	r1,r1
	mov	#16,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(16,r10),r1
	mov.l	r1,@r0
	mov.l	r12,@(16,r10)
	mov	r10,r0
	add	#20,r0
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov.l	r11,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
L3011:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3029:	.short	207
L3031:	.short	239
L3028:	.long	_FUN_06046d78
L3030:	.long	_FUN_06046d98
L3032:	.long	_FUN_06046d78
	.global _FUN_06046d78
	.align 2
_FUN_06046d78:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	cmp/gt	r11,r5
	bt	L3034
	neg	r11,r7
	cmp/gt	r5,r7
	bt	L3034
	exts.w	r0,r0
	cmp/gt	r4,r0
	bt	L3034
	neg	r4,r0
	rts
	nop
L3034:
L3033:
	rts
	mov	r7,r0
	.global _FUN_06046d98
	.align 2
_FUN_06046d98:
	mov.l	r14,@-r15
	mov	r9,r0
	add	#12,r0
	mov.l	@r0,r1
	exts.w	r1,r10
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r6
	mov	#1,r0
	cmp/ge	r0,r6
	bt	L3037
	neg	r6,r6
L3037:
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L3039
	neg	r10,r10
L3039:
	mov	r9,r0
	add	#16,r0
	mov.l	@r0,r1
	exts.w	r1,r4
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r5
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L3041
	neg	r5,r5
L3041:
	mov	#1,r0
	cmp/ge	r0,r4
	bt	L3043
	neg	r4,r4
L3043:
	mov	r4,r0
	add	r5,r0
	mov	r10,r1
	add	r6,r1
	cmp/gt	r1,r0
	bf/s	L3047
	mov	r15,r14
	bra	Lm39
	mov	#0,r0
L3047:
	mov	#1,r0
Lm39:
	mov	r14,r15
	mov	r0,r7
	add	r10,r6
	extu.b	r7,r0
	tst	r0,r0
	bt	L3048
	mov	r4,r6
	add	r5,r6
L3048:
	mov	r9,r0
	add	#20,r0
	mov.l	@r0,r1
	exts.w	r1,r5
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r10
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L3050
	neg	r10,r10
L3050:
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L3052
	neg	r5,r5
L3052:
	mov	r5,r0
	add	r10,r0
	cmp/gt	r6,r0
	bt	L3054
	mov	#2,r7
	mov	r5,r6
	add	r10,r6
L3054:
	mov	r9,r0
	add	#24,r0
	mov.l	@r0,r1
	exts.w	r1,r5
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r10
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L3056
	neg	r10,r10
L3056:
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L3058
	neg	r5,r5
L3058:
	mov	r5,r0
	add	r10,r0
	cmp/gt	r6,r0
	bt	L3060
	mov	#3,r7
L3060:
	extu.b	r7,r0
	rts
	mov.l	@r15+,r14
	.global _FUN_06046e0e
	.align 2
_FUN_06046e0e:
	sts.l	pr,@-r15
	mov.l	L3067,r3
	jsr	@r3
	nop
	mov.w	L3068,r0
	add	r12,r0
	mov.l	L3069,r3
	jsr	@r3
	mov.l	L3070,r3
	jsr	@r3
	mov.l	r13,@r0
	mov.w	L3071,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L3063
	mov.l	L3072,r3
	jsr	@r3
	nop
	mov.w	L3073,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L3065
	mov.l	L3074,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L3065:
L3063:
L3062:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3068:	.short	164
L3071:	.short	153
L3073:	.short	154
	.align 2
L3067:	.long	_FUN_06046ebc
L3069:	.long	_FUN_06046fd4
L3070:	.long	_FUN_06047014
L3072:	.long	_FUN_06047184
L3074:	.long	_FUN_060472cc
	.global _FUN_06046e64
	.align 2
_FUN_06046e64:
	sts.l	pr,@-r15
	mov.w	L3080,r0
	add	r12,r0
	mov.l	L3081,r3
	jsr	@r3
	mov.l	L3082,r3
	jsr	@r3
	mov.l	r13,@r0
	mov.w	L3083,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L3076
	mov.l	L3084,r3
	jsr	@r3
	nop
	mov.w	L3085,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L3078
	mov.l	L3086,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L3078:
L3076:
L3075:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3080:	.short	164
L3083:	.short	153
L3085:	.short	154
	.align 2
L3081:	.long	_FUN_06046fd4
L3082:	.long	_func_0x06047014
L3084:	.long	_FUN_06047184
L3086:	.long	_FUN_060472cc
	.global _FUN_06046ebc
	.align 2
_FUN_06046ebc:
	mov.b	@(7,r8),r0
	mov	#4,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L3087
	mov.b	@(7,r8),r0
L3088:
	mov.l	@(8,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3090
	mov.l	@(4,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L3092
L3094:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3130,r3
	and	r3,r2
	not	r1,r1
	mov	#48,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
	bra	L3087
	mov	r13,r0
L3092:
	mov	r4,r0
	cmp/eq	#3,r0
	bt	L3097
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3095
L3097:
	mov.l	@r8,r0
	exts.w	r0,r9
	mov.l	@r8,r0
	shlr16	r0
	exts.w	r0,r12
	mov	#1,r0
	cmp/ge	r0,r12
	bt	L3098
	neg	r12,r12
L3098:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3100
	neg	r9,r9
L3100:
	mov.l	@(8,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r10
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r11
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L3102
	neg	r11,r11
L3102:
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L3104
	neg	r10,r10
L3104:
	mov	r10,r0
	add	r11,r0
	mov	r9,r1
	add	r12,r1
	cmp/gt	r1,r0
	bf/s	L3108
	mov	#1,r12
L3107:
	mov	#0,r12
L3108:
	mov	r12,r14
	add	r9,r12
	exts.b	r14,r0
	tst	r0,r0
	bt	L3109
	mov	r10,r12
	add	r11,r12
L3109:
	mov.l	@(4,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r11
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3111
	neg	r9,r9
L3111:
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L3113
	neg	r11,r11
L3113:
	mov	r11,r0
	add	r9,r0
	cmp/gt	r12,r0
	bt	L3115
	mov	#2,r14
	mov	r11,r12
	add	r9,r12
L3115:
	mov.l	@(0,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r11
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3117
	neg	r9,r9
L3117:
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L3119
	neg	r11,r11
L3119:
	mov	r11,r0
	add	r9,r0
	cmp/gt	r12,r0
	bt	L3121
	mov	#3,r14
L3121:
	exts.b	r14,r0
	tst	r0,r0
	bt/s	L3087
	mov	#0,r0
L3123:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L3125
	bra	L3127
	nop
L3125:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L3128
	bra	L3094
	nop
L3128:
L3095:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3131,r3
	and	r3,r2
	not	r1,r1
	mov	#32,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
	bra	L3087
	mov	r13,r0
L3090:
L3127:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3132,r3
	and	r3,r2
	not	r1,r1
	mov	#16,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
L3087:
	rts
	mov	r13,r0
	.align 2
L3130:	.short	207
L3131:	.short	223
L3132:	.short	239
	.align 2
	.global _FUN_06046fd4
	.align 2
_FUN_06046fd4:
	add	#-16,r15
	mov.l	@(0,r15),r0
	mov.w	L3134,r1
	add	r1,r0
	mov	r0,r1
	mov.b	r6,@r1
	mov.l	L3135,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r5
	mov.l	@r9,r0
	mov.l	r0,@r5
	mov	r10,r0
	shlr16	r0
	shlr8	r0
	mov.b	r0,@(4,r5)
	mov.l	@r8,r0
	mov.l	r0,@(8,r5)
	mov	r10,r0
	shlr16	r0
	mov.b	r0,@(12,r5)
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r5)
	mov	r5,r0
	add	#20,r0
	mov	r10,r1
	shlr8	r1
	mov.b	r1,@r0
	mov.l	@(8,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(24,r5)
	mov	r5,r0
	add	#28,r0
	mov	r10,r1
	mov.b	r1,@r0
	mov.l	L3135,r0
	mov.l	@r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r0
	add	r0,r0
	mov.l	@r0,r0
	mov.l	r0,@(32,r5)
	mov.l	@(4,r15),r0
	mov	r4,r0
	add	r0,r0
	mov.b	@(4,r0),r0
	mov	r0,r7
	mov	r5,r1
	add	#36,r1
	mov.b	r7,@r1
	add	#16,r15
	rts
	mov	r7,r0
	.align 2
L3134:	.short	152
	.align 2
L3135:	.long	_DAT_0604717e
	.global _FUN_06047014
	.align 2
_FUN_06047014:
	sts.l	pr,@-r15
	mov.l	L3140,r0
	mov.l	@r0,r0
	mov	r0,r10
	add	r12,r10
	mov.l	L3141,r0
	mov.l	@r0,r11
	mov.w	L3142,r0
	add	r13,r0
	mov	#0,r1
	mov.b	r1,@r0
L3137:
	mov	#3,r0
	mov.b	@(4,r10),r0
	and	r0,r0
	mov	r0,r1
	shll2	r1
	mov.b	@(12,r10),r0
	and	r0,r0
	or	r0,r1
	mov	r1,r0
	shll	r0
	shll2	r0
	mov.l	L3143,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3144,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	add	#8,r10
	mov.w	L3140,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.b	r1,@r0
	tst	r9,r9
	bf	L3137
	mov.l	L3141,r0
	mov.l	@r0,r10
	mov	r11,r0
	add	r12,r0
	mov	r10,r0
	mov.l	@(r0,r12),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	r12,r0
	add	#4,r0
	mov.b	@r0,r8
	mov	r11,r1
	add	r12,r1
	add	#4,r1
	mov.b	r8,@r1
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L3142:	.short	153
L3144:	.short	100954170
L3140:	.long	_DAT_0604717e
L3141:	.long	_DAT_06047180
L3143:	.long	_DAT_06047058
	.global _FUN_0604708c
	.align 2
_FUN_0604708c:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3146,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3147,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3147:	.short	153
	.align 2
L3146:	.long	_FUN_06047118
	.global _FUN_060470a8
	.align 2
_FUN_060470a8:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3149,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3150,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3150:	.short	153
	.align 2
L3149:	.long	_FUN_06047118
	.global _FUN_060470c4
	.align 2
_FUN_060470c4:
	sts.l	pr,@-r15
	mov.l	L3152,r3
	jsr	@r3
	nop
	mov.w	L3153,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3153:	.short	153
	.align 2
L3152:	.long	_FUN_06047118
	.global _FUN_060470d6
	.align 2
_FUN_060470d6:
	sts.l	pr,@-r15
	mov.l	L3155,r3
	jsr	@r3
	nop
	mov.l	L3155,r3
	jsr	@r3
	nop
	mov.w	L3156,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3156:	.short	153
	.align 2
L3155:	.long	_func_0x06047118
	.global _FUN_060470ec
	.align 2
_FUN_060470ec:
	sts.l	pr,@-r15
	mov.l	L3158,r3
	jsr	@r3
	nop
	mov.w	L3159,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3159:	.short	153
	.align 2
L3158:	.long	_FUN_06047118
	.global _FUN_060470fe
	.align 2
_FUN_060470fe:
	sts.l	pr,@-r15
	mov.l	L3161,r3
	jsr	@r3
	nop
	mov.l	L3161,r3
	jsr	@r3
	nop
	mov.w	L3162,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3162:	.short	153
	.align 2
L3161:	.long	_func_0x06047118
	.global _FUN_06047118
	.align 2
_FUN_06047118:
	sts.l	pr,@-r15
	mov.l	L3168,r3
	jsr	@r3
	nop
	mov.l	r13,@r10
	mov	#0,r14
	mov	r13,r0
	shlr16	r0
	exts.w	r0,r12
	cmp/ge	r12,r11
	bt	L3164
	mov	#8,r14
L3164:
	neg	r11,r0
	cmp/ge	r0,r12
	bt	L3166
	exts.b	r14,r0
	add	#4,r0
L3166:
	mov.b	r0,@(4,r10)
	lds.l	@r15+,pr
	rts
	exts.b	r14,r0
	.align 2
L3168:	.long	_FUN_06047140
	.global _FUN_06047140
	.align 2
_FUN_06047140:
	sts.l	macl,@-r15
	mov	r7,r6
	mov	r5,r0
	exts.w	r0,r0
	mov	r7,r1
	exts.w	r1,r1
	cmp/ge	r1,r0
	bt	L3170
	mov	r5,r6
	mov	r7,r5
L3170:
	mov	r6,r10
	shlr16	r10
	mov	r6,r0
	exts.w	r0,r0
	mov.l	L3172,r1
	mov	r5,r2
	exts.w	r2,r2
	mov	r0,r3
	sub	r2,r3
	mov.l	r3,@r1
	exts.w	r10,r1
	mov.l	L3173,r2
	mov	r5,r3
	shlr16	r3
	exts.w	r3,r3
	mov	r1,r3
	sub	r3,r3
	exts.w	r3,r3
	exts.w	r11,r4
	sub	r0,r4
	mov	r4,r0
	exts.w	r0,r0
	mul.l	r0,r3
	sts	macl,r0
	mov.l	r0,@r2
	mov.l	L3174,r0
	mov.l	@r0,r0
	add	r1,r0
	shll16	r0
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L3172:	.long	__DAT_ffffff00
L3173:	.long	__DAT_ffffff04
L3174:	.long	__DAT_ffffff1c
	.global _FUN_06047184
	.align 2
_FUN_06047184:
	sts.l	pr,@-r15
	mov.l	L3179,r0
	mov.l	@r0,r0
	mov	r0,r13
	add	r12,r13
	mov.w	L3180,r0
	add	r11,r0
	mov	#0,r1
	mov.b	r1,@r0
L3176:
	mov	#12,r0
	mov.b	@(4,r13),r0
	mov	r0,r1
	and	r0,r1
	mov.b	@(12,r13),r0
	and	r0,r0
	shlr2	r0
	or	r0,r1
	mov	r1,r0
	shll	r0
	shll2	r0
	mov.l	L3181,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3182,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	add	#8,r13
	mov.w	L3181,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.b	r1,@r0
	tst	r14,r14
	bf	L3176
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3180:	.short	154
L3182:	.short	100954538
L3179:	.long	_DAT_060472c6
L3181:	.long	_DAT_060471bc
	.global _FUN_060471f0
	.align 2
_FUN_060471f0:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3184,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3185,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3185:	.short	154
	.align 2
L3184:	.long	_FUN_0604727c
	.global _FUN_0604720c
	.align 2
_FUN_0604720c:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3187,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3188,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3188:	.short	154
	.align 2
L3187:	.long	_FUN_0604727c
	.global _FUN_06047228
	.align 2
_FUN_06047228:
	sts.l	pr,@-r15
	mov.l	L3190,r3
	jsr	@r3
	nop
	mov.w	L3191,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3191:	.short	154
	.align 2
L3190:	.long	_FUN_0604727c
	.global _FUN_0604723a
	.align 2
_FUN_0604723a:
	sts.l	pr,@-r15
	mov.l	L3193,r3
	jsr	@r3
	nop
	mov.l	L3193,r3
	jsr	@r3
	nop
	mov.w	L3194,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3194:	.short	154
	.align 2
L3193:	.long	_func_0x0604727c
	.global _FUN_06047250
	.align 2
_FUN_06047250:
	sts.l	pr,@-r15
	mov.l	L3196,r3
	jsr	@r3
	nop
	mov.w	L3197,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3197:	.short	154
	.align 2
L3196:	.long	_FUN_0604727c
	.global _FUN_06047262
	.align 2
_FUN_06047262:
	sts.l	pr,@-r15
	mov.l	L3199,r3
	jsr	@r3
	nop
	mov.l	L3199,r3
	jsr	@r3
	nop
	mov.w	L3200,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3200:	.short	154
	.align 2
L3199:	.long	_func_0x0604727c
	.global _FUN_06047270
	.align 2
_FUN_06047270:
	mov.w	L3202,r1
	add	r6,r1
	rts
	mov.b	r7,@r1
	.align 2
L3202:	.short	154
	.align 2
	.global _FUN_0604727c
	.align 2
_FUN_0604727c:
	sts.l	pr,@-r15
	mov.l	L3204,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r12
	.align 2
L3204:	.long	_FUN_0604728e
	.global _FUN_0604728e
	.align 2
_FUN_0604728e:
	sts.l	macl,@-r15
	mov	r7,r6
	cmp/ge	r7,r5
	bt	L3206
	mov	r5,r6
	mov	r7,r5
L3206:
	mov	r6,r10
	shlr16	r10
	exts.w	r10,r0
	mov.l	L3208,r1
	mov	r5,r2
	shlr16	r2
	exts.w	r2,r2
	mov	r0,r3
	sub	r2,r3
	mov.l	r3,@r1
	mov	r6,r1
	exts.w	r1,r1
	mov.l	L3209,r2
	mov	r5,r3
	exts.w	r3,r3
	mov	r1,r3
	sub	r3,r3
	exts.w	r3,r3
	exts.w	r11,r4
	sub	r0,r4
	mov	r4,r0
	exts.w	r0,r0
	mul.l	r0,r3
	sts	macl,r0
	mov.l	r0,@r2
	mov.l	L3210,r0
	mov.l	@r0,r0
	add	r1,r0
	lds.l	@r15+,macl
	rts
	extu.w	r0,r0
	.align 2
L3208:	.long	__DAT_ffffff00
L3209:	.long	__DAT_ffffff04
L3210:	.long	__DAT_ffffff1c
	.global _FUN_060472cc
	.align 2
_FUN_060472cc:
	sts.l	pr,@-r15
	mov.w	L3212,r0
	add	r14,r0
	mov.b	@r0,r0
	shll	r0
	shll2	r0
	mov.l	L3213,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3214,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3212:	.short	154
L3214:	.short	100954846
L3213:	.long	_DAT_060472e0
	.global _FUN_06047332
	.align 2
_FUN_06047332:
	sts.l	pr,@-r15
	mov.l	L3216,r3
	mov.l	@r10,r0
	mov.l	@(32,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3216,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3217,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3216,r3
	mov.l	@(16,r10),r0
	mov.l	@(16,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3216,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3218,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3217:	.short	143
L3218:	.short	155
L3216:	.long	_FUN_06046d30
	.global _FUN_0604737a
	.align 2
_FUN_0604737a:
	sts.l	pr,@-r15
	mov.l	L3220,r3
	mov.l	@r10,r0
	mov.l	@(32,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3220,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3221,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3220,r3
	mov.l	@(8,r10),r0
	mov.l	@(8,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3220,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3222,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3221:	.short	143
L3222:	.short	155
L3220:	.long	_FUN_06046d30
	.global _FUN_060473ca
	.align 2
_FUN_060473ca:
	sts.l	pr,@-r15
	mov.l	L3224,r3
	mov.l	@r10,r0
	mov.l	@(40,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3224,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3225,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3224,r3
	mov.l	@(40,r10),r0
	mov.l	@(32,r10),r12
	mov.l	@(40,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3224,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3226,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3225:	.short	143
L3226:	.short	155
L3224:	.long	_FUN_06046d30
	.global _FUN_06047414
	.align 2
_FUN_06047414:
	sts.l	pr,@-r15
	mov.l	L3228,r3
	mov.l	@r10,r0
	mov.l	@(40,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3228,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3229,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3228,r3
	mov.l	@(8,r10),r0
	mov.l	@(32,r10),r12
	mov.l	@(8,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3228,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3230,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3229:	.short	143
L3230:	.short	155
L3228:	.long	_FUN_06046d30
	.global _FUN_06047460
	.align 2
_FUN_06047460:
	sts.l	pr,@-r15
	mov.l	L3232,r3
	mov.l	@r9,r0
	mov.l	@(40,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3232,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r0
	mov.l	r0,@r10
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3233,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3232,r3
	mov.l	@(8,r9),r0
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3232,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r0
	mov.l	r0,@(32,r10)
	mov.l	@(4,r10),r0
	mov.l	r0,@(36,r10)
	mov.l	@(8,r10),r0
	mov.l	r0,@(40,r10)
	mov.b	@r10,r0
	extu.b	r0,r0
	mov.w	L3233,r1
	and	r1,r0
	mov.b	r0,@r10
	mov.l	L3232,r3
	mov.l	@r9,r0
	mov.l	@r9,r0
	mov.l	r0,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3232,r3
	jsr	@r3
	mov.l	r13,@(56,r10)
	mov.w	L3234,r0
	add	r8,r0
	mov	#12,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3233:	.short	143
L3234:	.short	155
L3232:	.long	_FUN_06046d30
	.global _FUN_060474d4
	.align 2
_FUN_060474d4:
	sts.l	pr,@-r15
	mov.l	L3236,r3
	mov.l	@r9,r0
	mov.l	@(40,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3236,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r0
	mov.l	r0,@r10
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3237,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3236,r3
	mov.l	@(8,r9),r0
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3236,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r0
	mov.l	r0,@(32,r10)
	mov.l	@(4,r10),r0
	mov.l	r0,@(36,r10)
	mov.l	@(8,r10),r0
	mov.l	r0,@(40,r10)
	mov.b	@r10,r0
	extu.b	r0,r0
	mov.w	L3237,r1
	and	r1,r0
	mov.b	r0,@r10
	mov.l	L3236,r3
	mov.l	@r9,r0
	mov.l	@(56,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3236,r3
	jsr	@r3
	mov.l	r12,@(56,r10)
	mov.w	L3238,r0
	add	r8,r0
	mov	#12,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3237:	.short	143
L3238:	.short	155
L3236:	.long	_FUN_06046d30
	.global _FUN_06047548
	.align 2
_FUN_06047548:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-24,r15
	mov	r5,r13
	mov	r6,r12
	mov	#14,r0
	mov	r10,r1
	and	r0,r1
	mov.l	L3261,r0
	add	r1,r0
	mov.w	@r0,r11
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#12,r1
	cmp/gt	r1,r0
	bt	L3240
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
	.align 2
L3261:	.short	154
Lswt0:
	.short	L3243 - Lswt0
	.short	L3240 - Lswt0
	.short	L3244 - Lswt0
	.short	L3240 - Lswt0
	.short	L3245 - Lswt0
	.short	L3240 - Lswt0
	.short	L3246 - Lswt0
	.short	L3240 - Lswt0
	.short	L3247 - Lswt0
	.short	L3240 - Lswt0
	.short	L3248 - Lswt0
	.short	L3240 - Lswt0
	.short	L3249 - Lswt0
	bra	L3240
	nop
	mov.l	@(20,r15),r0
	mov.l	r13,@(12,r0)
	mov.l	@(12,r15),r1
	exts.w	r11,r0
	add	r0,r1
	mov	r1,r0
	mov	r13,r1
	mov.b	r1,@r0
	exts.w	r11,r0
	mov	r0,r9
	mov.l	@(4,r15),r0
	mov	r0,r1
	add	#82,r1
	mov.b	r9,@r1
	mov.l	@(20,r15),r1
	mov.l	L3262,r3
	jsr	@r3
	mov.b	r9,@r1
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r13,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	add	#82,r0
	mov	r4,r1
	exts.b	r1,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov	r4,r1
	exts.b	r1,r1
	mov.l	L3263,r3
	jsr	@r3
	mov.b	r1,@r0
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r0,r1
	mov.b	r12,@r1
	mov.l	@(4,r15),r0
	mov	r4,r1
	exts.b	r1,r1
	mov.l	L3264,r3
	jsr	@r3
	mov.b	r1,@r0
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r0,r1
	mov.b	r12,@r1
	mov.l	@(16,r15),r0
	mov.l	L3265,r0
	mov.l	r4,@r0
	jsr	@r0
	nop
	mov.l	L3265,r0
	jsr	@r0
	nop
L3240:
	mov	r14,r5
	mov.l	L3266,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3268,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3270,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3272,r5
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3268,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3270,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3273,r5
	mov.l	L3267,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3268,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3269,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3270,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov.l	L3278,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3279,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3280,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3281,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3282,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3283,r3
	jsr	@r3
	nop
	mov.l	L3279,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3281,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3283,r3
	jsr	@r3
	nop
	mov	r14,r4
	add	#-48,r4
	mov.l	L3274,r5
	mov.l	L3279,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3280,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3281,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3282,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3283,r3
	jsr	@r3
	nop
	mov.l	L3279,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3281,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3283,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#81,r0
	mov.b	@r0,r0
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3250
	mov.l	L3275,r3
	jsr	@r3
	nop
L3250:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#8,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3252
	mov.l	L3275,r3
	jsr	@r3
	nop
L3252:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#16,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt/s	L3256
	mov	r15,r14
	bra	Lm305
	mov	#0,r0
	.align 2
L3262:	.short	143
L3263:	.short	155
L3264:	.short	100954538
L3265:	.short	100954170
L3266:	.short	154
L3267:	.short	154
L3268:	.short	196
L3269:	.short	142
L3270:	.short	32767
L3256:
	mov	#1,r0
Lm305:
	mov	r14,r15
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L3239
	mov.l	L3284,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3285,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3276,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3239
	mov.l	L3277,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
L3239:
	add	#24,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L3271:	.long	_func_0x06043f10
L3272:	.long	_DAT_06044000
L3273:	.long	_DAT_06044024
L3274:	.long	_DAT_06044048
L3275:	.long	_func_0x06043f24
L3276:	.long	_PTR_FUN_06043ee0
L3277:	.long	_PTR_FUN_06043ee8
L3278:	.long	_PTR_FUN_06043ed8
L3279:	.long	_PTR_SUB_06043edc
L3280:	.long	_PTR_SUB_06043ed0
L3281:	.long	_PTR_SUB_06043ed4
L3282:	.long	_PTR_SUB_06043ecc
L3283:	.long	_func_0x06043f10
L3284:	.long	_PTR_FUN_06043ed8
L3285:	.long	_PTR_SUB_06043edc
	.global _FUN_06047588
	.align 2
_FUN_06047588:
	mov.l	@(12,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L3287
L3289:
	mov.l	r13,@(12,r7)
	mov.l	r12,@(16,r7)
	mov.l	r11,@(20,r7)
	mov	r7,r0
	add	#24,r0
	bra	L3286
	mov.l	r4,@r0
L3287:
	mov.l	@(8,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L3290
L3292:
	mov.l	r12,@(12,r7)
	mov.l	r13,@(16,r7)
	mov.l	r4,@(20,r7)
	mov.l	r11,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3329,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#16,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	bra	L3286
	mov.b	r1,@r0
L3290:
	mov.l	@(4,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L3293
L3295:
	mov.l	r11,@(12,r7)
	mov.l	r4,@(16,r7)
	mov.l	r13,@(20,r7)
	mov.l	r12,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3330,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#48,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	bra	L3286
	mov.b	r1,@r0
L3293:
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3296
	mov	r13,r0
	exts.w	r0,r10
	shlr16	r0
	exts.w	r0,r8
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L3298
	neg	r10,r10
L3298:
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L3300
	neg	r8,r8
L3300:
	mov	r12,r0
	exts.w	r0,r9
	shlr16	r0
	exts.w	r0,r0
	mov.l	r0,@(16,r15)
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3302
	neg	r9,r9
L3302:
	mov.l	@(16,r15),r0
	mov	#1,r1
	cmp/ge	r1,r0
	bt	L3304
	mov.l	@(16,r15),r0
	neg	r0,r0
	mov.l	r0,@(16,r15)
L3304:
	mov.l	@(16,r15),r0
	add	r9,r0
	mov	r8,r1
	add	r10,r1
	cmp/gt	r1,r0
	bf/s	L3308
	mov	#1,r13
L3307:
	mov	#0,r13
L3308:
	mov	r13,r14
	add	r8,r10
	exts.b	r14,r0
	tst	r0,r0
	bt	L3309
	mov.l	@(16,r15),r0
	mov	r0,r10
	add	r9,r10
L3309:
	mov	r11,r0
	exts.w	r0,r8
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L3311
	neg	r8,r8
L3311:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3313
	neg	r9,r9
L3313:
	mov	r9,r0
	add	r8,r0
	cmp/gt	r10,r0
	bt	L3315
	mov	#2,r14
	mov	r9,r10
	add	r8,r10
L3315:
	mov	r4,r0
	exts.w	r0,r8
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L3317
	neg	r8,r8
L3317:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L3319
	neg	r9,r9
L3319:
	mov	r9,r0
	add	r8,r0
	cmp/gt	r0,r10
	bt	L3321
	mov	#3,r14
L3321:
	exts.b	r14,r0
	tst	r0,r0
	bf	L3323
	bra	L3289
	nop
L3323:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L3325
	bra	L3292
	nop
L3325:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L3327
	bra	L3295
	nop
L3327:
L3296:
	mov.l	r4,@(12,r7)
	mov.l	r11,@(16,r7)
	mov.l	r12,@(20,r7)
	mov.l	r13,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3331,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#32,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
L3286:
	rts
	mov.b	r1,@r0
	.align 2
L3329:	.short	239
L3330:	.short	207
L3331:	.short	223
	.align 2
	.global _FUN_06047748
	.align 2
_FUN_06047748:
	mov.l	L3338,r0
	mov.l	@r0,r7
L3333:
	mov.w	@r5,r0
	tst	r0,r0
	bt	L3336
	mov	r4,r0
	shll2	r0
	shll	r0
	add	r7,r0
	add	#2,r0
	mov	r0,r1
	mov.w	@r5,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.w	r0,@r5
	mov.w	@(2,r5),r0
	mov	r0,r4
L3336:
	dt	r6
	add	#-4,r5
	bf	L3333
	rts
	nop
	.align 2
L3338:	.long	_DAT_0604776c
	.global _FUN_06047770
	.align 2
_FUN_06047770:
	mov.l	L3347,r0
	mov.l	@r0,r13
L3340:
	mov.w	@r4,r0
	tst	r0,r0
	bt	L3343
	mov	r7,r0
	shll2	r0
	shll	r0
	add	r13,r0
	add	#2,r0
	mov	r0,r1
	mov.w	@r4,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.w	r0,@r4
	mov.w	@(2,r4),r0
	mov	r0,r7
L3343:
	mov	r4,r0
	add	#-4,r0
	mov.w	@r0,r14
	mov	#0,r0
	mov	r0,r12
	mov	r14,r0
	tst	r0,r0
	bt	L3345
	mov	r6,r0
	shll2	r0
	shll	r0
	add	r13,r0
	add	#2,r0
	mov	r0,r1
	mov.w	r14,@r1
	mov	r4,r0
	add	#-4,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r0
	add	#-2,r0
	mov.w	@r0,r0
	mov	r0,r12
	mov	r12,r6
L3345:
	dt	r5
	add	#-8,r4
	bf	L3340
	rts
	mov	r12,r0
	.align 2
L3347:	.long	_DAT_060477b0
	.global _FUN_060477d4
	.align 2
_FUN_060477d4:
	sts.l	pr,@-r15
	mov.l	L3349,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3349:	.long	_FUN_060477fc
	.global _FUN_060477d6
	.align 2
_FUN_060477d6:
	sts.l	pr,@-r15
	mov.l	L3351,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3351:	.long	_FUN_060477fc
	.global _FUN_060477fc
	.align 2
_FUN_060477fc:
	sts.l	pr,@-r15
	mov.l	L3355,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	@r0,r13
	mov.l	@(4,r0),r0
	mov	r0,r1
	mov.l	L3356,r0
	mov.l	L3357,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3358,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3359,r0
	mov.l	@r0,r12
	mov.l	L3360,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L3353
	mov.l	L3361,r0
	mov.l	@r0,r0
	add	#4,r0
	mov	r0,r1
	mov.l	L3363,r4
	mov.l	L3362,r0
	mov.l	L3364,r0
	mov.w	@r0,r0
	mov.l	r0,@r1
	mov.l	@r4,r4
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3366,r5
	mov.l	L3365,r4
	mov.l	L3367,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov	r0,r4
	mov.l	L3368,r0
	mov.w	@r0,r0
	mov	r0,r12
	mov	r12,r4
	mov.l	L3366,r6
	mov.l	L3365,r5
	mov.l	L3369,r0
	mov.l	@r5,r5
	jsr	@r0
	mov.l	@r6,r6
	mov.l	L3370,r0
	mov.l	@r0,r0
	mov	r12,r1
	shll2	r1
	shll	r1
	add	r1,r0
	add	#2,r0
	mov	r0,r1
	mov.l	L3371,r0
	mov.l	L3357,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3358,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	@(4,r0),r4
	mov.l	L3372,r3
	mov.l	L3361,r0
	mov.l	r1,@r0
	mov.l	@r0,r0
	jsr	@r3
	mov	r4,r5
	lds.l	@r15+,pr
	rts
	nop
L3353:
	mov.l	L3373,r0
	mov.w	@r0,r0
	mov	r0,r10
	mov.l	L3359,r0
	mov.l	@r0,r0
	add	#4,r0
	mov	r0,r1
	mov.l	L3375,r4
	mov.l	L3374,r0
	mov.l	L3376,r0
	mov.w	@r0,r0
	mov.l	r0,@r1
	mov.l	@r4,r4
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3378,r5
	mov.l	L3377,r4
	mov.l	L3379,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3380,r0
	mov.w	@r0,r0
	mov	r0,r10
	mov.l	L3381,r0
	mov.w	@r0,r0
	mov	r0,r11
	mov.l	L3378,r5
	mov.l	L3377,r4
	mov.l	L3382,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3383,r0
	mov.l	@r0,r0
	mov	r0,r12
	mov	r10,r1
	shll2	r1
	shll	r1
	add	r0,r1
	mov	r1,r1
	add	#2,r1
	mov.l	L3384,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r11,r0
	shll2	r0
	shll	r0
	add	r12,r0
	add	#2,r0
	mov	r0,r1
	mov.l	L3385,r0
	mov.l	L3386,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3387,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
L3352:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3355:	.long	_DAT_0604788c
L3356:	.long	_DAT_06047884
L3357:	.long	_DAT_06047890
L3358:	.long	_DAT_06047894
L3359:	.long	_DAT_06047948
L3360:	.long	_DAT_06047898
L3361:	.long	_DAT_0604789c
L3362:	.long	_DAT_06047886
L3363:	.long	_PTR_LAB_060478a0
L3364:	.long	_DAT_060478a4
L3365:	.long	_DAT_060478a8
L3366:	.long	_DAT_060478ac
L3367:	.long	_func_0x06047986
L3368:	.long	_DAT_06047888
L3369:	.long	_FUN_06047748
L3370:	.long	_DAT_060478b0
L3371:	.long	_DAT_0604788a
L3372:	.long	_func_0x0604796c
L3373:	.long	_DAT_0604793c
L3374:	.long	_DAT_0604793a
L3375:	.long	_PTR_LAB_0604794c
L3376:	.long	_DAT_06047950
L3377:	.long	_DAT_06047954
L3378:	.long	_DAT_06047958
L3379:	.long	_FUN_060479a0
L3380:	.long	_DAT_0604793e
L3381:	.long	_DAT_06047940
L3382:	.long	_FUN_06047770
L3383:	.long	_DAT_0604795c
L3384:	.long	_DAT_06047942
L3385:	.long	_DAT_06047944
L3386:	.long	_DAT_06047960
L3387:	.long	_DAT_06047964
	.global _FUN_06047866
	.align 2
_FUN_06047866:
	sts.l	pr,@-r15
	mov.l	L3389,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3390,r0
	mov.l	@r0,r0
	add	#4,r0
	mov.l	@r0,r13
	mov	r13,r4
	mov.l	L3392,r6
	mov.l	L3391,r5
	mov.l	L3393,r3
	mov.l	@r5,r5
	jsr	@r3
	mov.l	@r6,r6
	mov	r0,r4
	mov.l	L3390,r0
	mov.l	@r0,r0
	add	#4,r0
	mov.l	r13,@r0
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3389:	.long	_DAT_06047894
L3390:	.long	_DAT_0604789c
L3391:	.long	_DAT_060478b4
L3392:	.long	_DAT_060478ac
L3393:	.long	_FUN_06047748
	.global _FUN_0604791a
	.align 2
_FUN_0604791a:
	sts.l	pr,@-r15
	mov.l	L3395,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3396,r0
	mov.l	@r0,r0
	mov	r0,r1
	add	#4,r1
	mov.l	@r1,r13
	add	#8,r0
	mov.l	L3398,r5
	mov.l	L3397,r4
	mov.l	L3399,r3
	mov.l	@r0,r12
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3396,r0
	mov.l	@r0,r0
	mov	r0,r14
	add	#4,r0
	mov.l	r13,@r0
	mov	r14,r0
	add	#8,r0
	lds.l	@r15+,pr
	rts
	mov.l	r12,@r0
	.align 2
L3395:	.long	_DAT_06047964
L3396:	.long	_DAT_06047948
L3397:	.long	_DAT_06047968
L3398:	.long	_DAT_06047958
L3399:	.long	_FUN_06047770
	.global _FUN_0604796c
	.align 2
_FUN_0604796c:
	mov	r4,r0
	shll2	r0
	shll	r0
	mov.l	L3405,r1
	mov.l	@r1,r1
	add	r1,r0
	bra	L3404
	mov	r0,r7
L3401:
	add	#32,r7
L3404:
	mov	r7,r0
	add	#-2,r0
	mov.b	@r0,r0
	mov	#112,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L3401
	rts
	mov.w	r5,@r7
	.align 2
L3405:	.long	_DAT_0604799c
	.global _FUN_06047986
	.align 2
_FUN_06047986:
L3407:
	mov.w	@r4,r0
	tst	r0,r0
	bt	L3410
	bra	L3406
	mov.w	@r4,r0
L3410:
	dt	r5
	add	#-4,r4
	bf	L3407
	mov.l	L3412,r0
L3406:
	rts
	mov.w	@r0,r0
	.align 2
L3412:	.long	_DAT_06047998
	.global _FUN_060479a0
	.align 2
_FUN_060479a0:
	mov	r4,r6
	add	#-4,r6
	mov	r5,r7
L3414:
	mov.w	@r6,r0
	mov	r0,r8
	tst	r8,r8
	bt	L3417
	bra	L3419
	nop
L3417:
	dt	r7
	add	#-8,r6
	bf	L3414
	mov.l	L3426,r0
	mov.w	@r0,r0
	mov	r0,r8
L3419:
L3420:
	mov.w	@r4,r0
	mov	r0,r7
	tst	r7,r7
	bt	L3423
	nop
	rts
	nop
L3423:
	dt	r5
	add	#-8,r4
	bf	L3420
	mov.l	L3427,r0
	mov.w	@r0,r0
L3413:
	rts
	mov	r0,r7
	.align 2
L3426:	.long	_DAT_060479d2
L3427:	.long	_DAT_060479d4
	.global _FUN_060479d6
	.align 2
_FUN_060479d6:
	sts.l	pr,@-r15
	mov.l	L3429,r0
	mov.l	@r0,r13
	mov.l	L3430,r0
	mov.l	@r0,r0
	mov	#0,r1
	mov.l	L3431,r3
	jsr	@r3
	mov.l	L3434,r3
	mov.l	L3432,r0
	mov.l	L3433,r0
	mov.l	r1,@r0
	mov.w	@r0,r0
	mov.w	r0,@r13
	mov.w	@r0,r0
	jsr	@r3
	mov.l	L3436,r5
	mov.l	L3435,r4
	mov.l	L3437,r3
	mov.l	@r4,r4
	mov.l	L3437,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.l	@r5,r5
	.align 2
L3429:	.long	_DAT_06047a54
L3430:	.long	_DAT_06047a50
L3431:	.long	_FUN_06047a84
L3432:	.long	_DAT_06047a48
L3433:	.long	_DAT_06047a4a
L3434:	.long	_FUN_06047ae0
L3435:	.long	_DAT_06047a58
L3436:	.long	_PTR_DAT_06047a5c
L3437:	.long	_FUN_06047b00
	.global _FUN_06047a08
	.align 2
_FUN_06047a08:
	sts.l	pr,@-r15
	mov.l	L3439,r0
	mov.l	@r0,r11
	mov.l	L3440,r0
	mov.l	@r0,r0
	mov	#1,r1
	mov.l	L3441,r3
	jsr	@r3
	mov.l	L3442,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.l	L3443,r0
	mov.w	@r0,r0
	mov.w	r0,@r11
	mov	r13,r0
	mov.w	r0,@(2,r11)
	mov	r11,r1
	add	#32,r1
	mov.l	L3443,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r11,r1
	add	#34,r1
	mov.l	L3444,r3
	jsr	@r3
	mov.l	L3446,r5
	mov.l	L3445,r4
	mov.l	L3447,r3
	mov.w	r12,@r1
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L3449,r5
	mov.l	L3448,r4
	mov.l	L3447,r3
	mov.l	@r5,r5
	mov.l	@r4,r4
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.l	@r5,r5
	.align 2
L3439:	.long	_DAT_06047a54
L3440:	.long	_DAT_06047a50
L3441:	.long	_FUN_06047a84
L3442:	.long	_func_0x06047b34
L3443:	.long	_DAT_06047a48
L3444:	.long	_FUN_06047ae0
L3445:	.long	_DAT_06047a58
L3446:	.long	_PTR_DAT_06047a60
L3447:	.long	_func_0x06047b00
L3448:	.long	_DAT_06047a64
L3449:	.long	_PTR_DAT_06047a68
	.global _FUN_06047a84
	.align 2
_FUN_06047a84:
	mov.l	L3453,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov.l	L3454,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3455,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.l	r0,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3456,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#68,r0
	mov.l	L3457,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov.l	L3458,r0
	mov.w	@r0,r6
	mov.l	L3459,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.w	L3460,r1
	and	r1,r0
	tst	r0,r0
	bt	L3451
	mov.l	L3458,r0
	mov.w	@r0,r0
	add	#-2,r0
	mov	r0,r6
L3451:
	mov	r4,r1
	add	#78,r1
	exts.w	r6,r0
	mov.w	r0,@r1
	mov	r4,r1
	add	#82,r1
	exts.w	r6,r0
	mov.w	r0,@r1
	mov.l	L3461,r0
	mov.w	@r0,r0
	mov	r0,r7
	mov	r4,r1
	add	#80,r1
	mov.w	r0,@r1
	mov	r4,r1
	add	#84,r1
	mov.w	r7,@r1
	mov.l	L3462,r0
	mov.w	@r0,r0
	mov	r0,r7
	mov	r4,r1
	add	#86,r1
	mov.w	r0,@r1
	mov	r4,r1
	add	#90,r1
	rts
	mov.w	r7,@r1
	.align 2
L3460:	.short	192
	.align 2
L3453:	.long	_DAT_06047ac6
L3454:	.long	_DAT_06047ad4
L3455:	.long	_DAT_06047ac8
L3456:	.long	_DAT_06047aca
L3457:	.long	_DAT_06047ad8
L3458:	.long	_DAT_06047acc
L3459:	.long	_DAT_06047adc
L3461:	.long	_DAT_06047ace
L3462:	.long	_DAT_06047ad0
	.global _FUN_06047ae0
	.align 2
_FUN_06047ae0:
	mov	r4,r1
	add	#32,r1
	mov.l	L3464,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#44,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov	r4,r6
	add	#64,r6
	mov.l	L3465,r0
	mov.w	@r0,r0
	mov.w	r0,@r6
	mov.l	L3466,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.l	r6,@r0
	mov	r6,r0
	rts
	mov.l	r0,@(4,r14)
	.align 2
L3464:	.long	_DAT_06047af8
L3465:	.long	_DAT_06047afa
L3466:	.long	_DAT_06047afc
	.global _FUN_06047b00
	.align 2
_FUN_06047b00:
	mov.l	L3468,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov.l	@r5,r0
	mov.l	r0,@(12,r4)
	mov.l	@(4,r5),r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3469,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@(8,r5),r0
	mov.l	r0,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3470,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#66,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r1
	add	#96,r1
	mov.l	L3471,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.w	L3472,r1
	add	r4,r1
	mov.l	L3470,r0
	mov.w	@r0,r0
	rts
	mov.w	r0,@r1
	.align 2
L3472:	.short	224
	.align 2
L3468:	.long	_DAT_06047b6c
L3469:	.long	_DAT_06047b6e
L3470:	.long	_DAT_06047b70
L3471:	.long	_DAT_06047b72
	.global _FUN_06047b34
	.align 2
_FUN_06047b34:
	mov.l	L3474,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov	#0,r0
	mov.l	r0,@(12,r4)
	mov.l	L3475,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3476,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.l	r0,@(44,r4)
	mov	r4,r0
	add	#64,r0
	mov.l	L3477,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#68,r0
	mov.l	L3478,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov.l	L3479,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#80,r0
	mov.l	L3480,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#84,r0
	mov.l	L3481,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov.l	L3482,r1
	mov.l	@r1,r1
	rts
	mov.l	r1,@r0
	.align 2
L3474:	.long	_DAT_06047b6c
L3475:	.long	_DAT_06047b74
L3476:	.long	_DAT_06047b6e
L3477:	.long	_DAT_06047b78
L3478:	.long	_DAT_06047b7c
L3479:	.long	_DAT_06047b80
L3480:	.long	_DAT_06047b84
L3481:	.long	_DAT_06047b88
L3482:	.long	_DAT_06047b8c
	.global _FUN_06047d3c
	.align 2
_FUN_06047d3c:
	mov.l	L3484,r0
	mov.l	@r0,r0
	mov	r4,r1
	add	#8,r1
	mov.l	L3485,r2
	mov.l	@r2,r2
	and	r2,r1
	shlr2	r1
	add	r1,r0
	mov.w	@r0,r0
	shll2	r0
	rts
	nop
	.align 2
L3484:	.long	_PTR_DAT_06047db8
L3485:	.long	_DAT_06047db0
	.global _FUN_06047d46
	.align 2
_FUN_06047d46:
	mov	r7,r0
	mov.w	@(r0,r4),r0
	shll2	r0
	rts
	nop
