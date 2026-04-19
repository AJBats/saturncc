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
	mov.l	L5,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L2
	mov.l	L6,r4
	mov.l	L7,r1
	mov	r1,r5
	mov.l	L8,r3
	jsr	@r3
	mov	r1,r6
L2:
	mov	#0,r4
	mov.l	L9,r3
	jsr	@r3
	mov	r9,r5
	mov.l	L10,r3
	jsr	@r3
	mov	r11,r4
	mov.l	L11,r3
	jsr	@r3
	mov	r10,r4
	mov	r8,r4
	add	#48,r4
	mov.l	L12,r5
	mov.l	L13,r3
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
L6:	.long	-65536
L7:	.long	65536
L8:	.long	_FUN_06044F30
L9:	.long	_FUN_06044E3C
L10:	.long	_FUN_060450F2
L11:	.long	_FUN_06045006
L12:	.long	101018036
L13:	.long	_FUN_060457DC
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
L15:
	add	#48,r8
	mov	r8,r4
	mov.l	L18,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L19,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L20,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	add	#-48,r8
	dt	r9
	bf	L15
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
L18:	.long	_pcRam06044128
L19:	.long	_pcRam0604412c
L20:	.long	_pcRam06044134
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
	mov.l	L38,r1
	mov.l	@r1,r1
	mov	r1,r14
	mov.l	L39,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r1,r3
	jsr	@r3
	nop
	mov.l	L40,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#12,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L41,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L42,r1
	mov.l	@r1,r12
	mov.l	L43,r1
	mov.l	@r1,r1
	mov.l	r1,@(8,r15)
	mov	#0,r1
	mov.l	r1,@(32,r15)
	mov.l	L44,r1
	mov.l	@r1,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov.l	L45,r1
	mov.l	@r1,r1
	mov.l	r1,@(20,r15)
	mov.l	L46,r1
	mov.l	@r1,r13
	mov.l	L47,r1
	mov.l	@r1,r1
	mov.l	r1,@(0,r15)
	mov.l	L48,r1
	mov.l	@r1,r1
	mov.l	r1,@(16,r15)
	mov.l	L49,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r15)
L22:
	mov.l	@(32,r15),r1
	mov	#6,r2
	mov	r1,r3
	exts.b	r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	add	r12,r2
	mov.l	r2,@(24,r15)
	mov.l	@(24,r15),r2
	mov.l	@(0,r15),r3
	add	r3,r1
	mov.b	@r1,r1
	mov.b	r1,@r2
	mov.l	@(32,r15),r1
	mov	r1,r2
	add	#1,r2
	mov.l	r2,@(28,r15)
	mov.l	@(24,r15),r2
	add	#1,r2
	add	r13,r1
	mov.b	@r1,r1
	mov.b	r1,@r2
	mov.l	@(24,r15),r1
	mov.l	@(4,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(2,r1)
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(3,r1)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(4,r1)
	mov.l	@(24,r15),r1
	mov.l	@(8,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(5,r1)
	mov.l	@(8,r15),r1
	add	#1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(28,r15),r1
	mov	#6,r2
	mov	r1,r3
	exts.b	r3,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	add	r12,r2
	mov.l	r2,@(24,r15)
	mov.l	@(24,r15),r2
	mov.l	@(0,r15),r3
	add	r3,r1
	mov.b	@r1,r1
	mov.b	r1,@r2
	mov.l	@(24,r15),r1
	mov.l	@(28,r15),r2
	add	r13,r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(1,r1)
	mov.l	@(32,r15),r1
	add	#2,r1
	mov.l	r1,@(32,r15)
	mov.l	@(24,r15),r1
	add	#2,r1
	mov.l	@(4,r15),r2
	mov.b	@(1,r2),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r2
	mov.b	@(1,r2),r0
	mov.b	r0,@(3,r1)
	mov.l	@(16,r15),r1
	add	#2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(4,r1)
	mov.l	@(8,r15),r1
	add	#2,r1
	mov.l	r1,@(8,r15)
	mov.l	@(24,r15),r1
	mov.l	@(12,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	add	#2,r1
	mov.l	r1,@(4,r15)
	mov.l	@(32,r15),r1
	mov	#2,r2
	cmp/ge	r2,r1
	bf	L22
	mov.l	L50,r1
	mov.l	@r1,r1
	mov.l	@r1,r1
	tst	r1,r1
	bf	L25
	mov.l	L51,r1
	mov.l	@r1,r1
	mov.l	L52,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov.l	L53,r1
	mov.l	@r1,r11
	mov.l	L54,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L27
	mov	#2,r1
	mov.l	L55,r2
	mov.l	@r2,r2
	mov.b	@r2,r2
	cmp/ge	r2,r1
	bt	L29
	mov	#0,r1
	mov.l	r1,@(0,r15)
	mov.l	L43,r1
	mov.l	@r1,r1
	mov.l	r1,@(8,r15)
	mov.l	L56,r1
	mov.l	@r1,r1
	mov.l	r1,@(20,r15)
	mov.l	L57,r1
	mov.l	@r1,r1
	mov.l	r1,@(16,r15)
L31:
	mov	#6,r1
	mov.l	@(0,r15),r2
	exts.b	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(4,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r2
	mov.b	@r2,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r2
	mov.b	@r2,r2
	mov	r2,r0
	mov.b	r0,@(2,r1)
	mov	#6,r1
	mov.l	@(0,r15),r1
	mov	r1,r2
	exts.b	r2,r2
	mul.l	r2,r1
	sts	macl,r2
	add	#6,r2
	exts.b	r2,r2
	add	r12,r2
	mov.l	r2,@(4,r15)
	add	#2,r1
	mov.l	r1,@(0,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r2
	mov.b	@(1,r2),r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r2
	mov.b	@(1,r2),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r2
	mov.b	@(1,r2),r0
	mov.b	r0,@(2,r1)
	mov.l	@(20,r15),r1
	add	#2,r1
	mov.l	r1,@(20,r15)
	mov.l	@(16,r15),r1
	add	#2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	add	#2,r1
	mov.l	r1,@(8,r15)
	mov.l	@(0,r15),r1
	mov	#2,r2
	cmp/ge	r2,r1
	bf	L31
L29:
	mov.l	L58,r1
	mov.l	@r1,r10
	mov	#1,r1
	mov.l	r1,@r11
	mov	#20,r1
	mov.l	r1,@(4,r11)
	mov.b	@r12,r1
	mov	r1,r0
	mov.b	r0,@(8,r11)
	mov	r11,r1
	add	#9,r1
	mov.b	@(1,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#10,r1
	mov.b	@(2,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#11,r1
	mov.b	@(3,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.b	@(4,r12),r0
	mov.b	r0,@(12,r11)
	mov	r11,r1
	add	#13,r1
	mov.b	@(5,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#14,r1
	mov.b	@(6,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#15,r1
	mov.b	@(7,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#16,r1
	mov.b	@(8,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#17,r1
	mov.b	@(9,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#18,r1
	mov.b	@(10,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov	r11,r1
	add	#19,r1
	mov.b	@(11,r12),r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.l	L59,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r9
	mov.l	L60,r1
	mov.l	@r1,r8
	mov	r9,r1
	tst	r1,r1
	bf	L34
	mov.l	L61,r1
	mov.l	@r1,r1
	mov	r1,r9
	mov.w	L62,r2
	mov.l	L63,r3
	mov.l	@r3,r3
	mov.b	@r3,r3
	mul.l	r3,r2
	sts	macl,r2
	shll2	r2
	mov	r2,r8
	add	r1,r8
L34:
	mov	r8,r1
	mov.l	r1,@r10
	mov.l	L67,r1
	mov.l	@r1,r1
	mov.l	r1,@(8,r15)
	mov.l	L55,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L28
	mov.l	L64,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L28
	mov.l	L65,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r9
	mov	r9,r0
	cmp/eq	#6,r0
	bt	L28
	mov.l	@r10,r1
	mov	r1,r9
	mov.l	@r9,r1
	tst	r1,r1
	bt	L28
	mov.l	@r10,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r1
	add	#8,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(6,r12)
	mov.l	@(0,r15),r1
	add	#9,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(7,r12)
	mov.l	@(0,r15),r1
	add	#10,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(8,r12)
	mov.l	@(0,r15),r1
	add	#11,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(9,r12)
	mov.l	@(0,r15),r1
	add	#12,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(10,r12)
	mov.l	L66,r1
	mov.l	@r1,r8
	mov.l	@(0,r15),r1
	add	#13,r1
	mov.b	@r1,r2
	mov	r2,r9
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(11,r12)
	mov.l	@r10,r1
	add	#20,r1
	mov.l	r1,@r8
	mov.l	@(8,r15),r1
	mov	#1,r2
	bra	L28
	mov.b	r2,@r1
L27:
	mov.l	L68,r1
	mov.l	@r1,r1
	mov	r1,r2
	add	#14,r2
	mov.l	r2,@(8,r15)
	mov.b	@(8,r1),r0
	mov	r0,r1
	mov.b	r1,@r12
	mov	r11,r1
	add	#9,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(1,r12)
	mov	r11,r1
	add	#10,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(2,r12)
	mov	r11,r1
	add	#11,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(3,r12)
	mov.b	@(12,r11),r0
	mov.b	r0,@(4,r12)
	mov	r11,r1
	add	#13,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(5,r12)
	mov.l	@(8,r15),r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(6,r12)
	mov	r11,r1
	add	#15,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(7,r12)
	mov	r11,r1
	add	#16,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(8,r12)
	mov	r11,r1
	add	#17,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(9,r12)
	mov	r11,r1
	add	#18,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(10,r12)
	mov	r11,r1
	add	#19,r1
	mov.b	@r1,r2
	mov	r2,r9
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(11,r12)
L28:
L25:
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
L62:	.short	3072
	.align 2
L38:	.long	_DAT_060443b0
L39:	.long	_DAT_060443b4
L40:	.long	_DAT_060443b8
L41:	.long	_DAT_060443bc
L42:	.long	_DAT_060443dc
L43:	.long	_DAT_060443c4
L44:	.long	_DAT_060443c0
L45:	.long	_DAT_060443d8
L46:	.long	_DAT_060443d4
L47:	.long	_DAT_060443d0
L48:	.long	_DAT_060443c8
L49:	.long	_DAT_060443cc
L50:	.long	_DAT_060443e0
L51:	.long	_DAT_060443e8
L52:	.long	_DAT_060443e4
L53:	.long	_DAT_060443ec
L54:	.long	_DAT_060443f0
L55:	.long	_DAT_060443f4
L56:	.long	_DAT_060443f8
L57:	.long	_DAT_060443fc
L58:	.long	_DAT_06044400
L59:	.long	_DAT_06044404
L60:	.long	_DAT_06044410
L61:	.long	_DAT_0604440c
L63:	.long	_DAT_06044408
L64:	.long	_DAT_06044414
L65:	.long	_DAT_06044418
L66:	.long	_DAT_0604441c
L67:	.long	_DAT_060443c0
L68:	.long	_DAT_060443ec
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
	mov.l	L114,r1
	mov.l	@r1,r10
	mov.l	L115,r1
	mov.l	@r1,r1
	mov.l	@r1,r1
	tst	r1,r1
	bt	L70
	mov.l	L115,r1
	mov.l	@r1,r1
	mov.l	@r1,r0
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
L70:
	mov	#1,r1
	mov.l	r1,@(20,r15)
	mov	r4,r11
	mov	#12,r1
	exts.b	r11,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	mov.l	r1,@(52,r15)
	mov.l	@(52,r15),r1
	mov.l	L116,r2
	mov.l	@r2,r2
	add	r2,r1
	mov.l	r1,@(48,r15)
	mov.l	L117,r1
	mov.l	@r1,r1
	mov.l	@r1,r1
	mov	r1,r8
	mov.l	L118,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L72
	mov.l	@(48,r15),r1
	mov.l	@r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r1),r2
	mov.l	r2,@(0,r15)
	mov.b	@(8,r1),r0
	mov	r0,r1
	extu.b	r1,r1
	tst	r1,r1
	bf	L74
	mov	#0,r1
	mov	r15,r1
	add	#27,r1
	mov.b	r1,@r1
	mov.l	L119,r1
	mov.l	@r1,r1
	mov	r8,r2
	mov.l	@(4,r1),r3
	add	r1,r3
	mov	r3,r1
	cmp/hs	r1,r2
	bt	L76
	mov.b	@r8+,r1
	mov	r15,r1
	add	#39,r1
	mov.b	r1,@r1
	mov	r15,r1
	add	#39,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	extu.b	r1,r1
	exts.b	r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L78
	mov	r15,r1
	add	#39,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	mov	#127,r2
	extu.b	r1,r1
	and	r2,r1
	mov	r15,r1
	add	#27,r1
	bra	L75
	mov.b	r1,@r1
L78:
	mov	r15,r1
	add	#4,r1
	bra	L83
	mov.l	r1,@(16,r15)
L80:
	mov	r15,r1
	add	#39,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	mov	#1,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L84
	mov.b	@r8+,r13
	mov.l	@(16,r15),r1
	mov.b	r13,@r1
L84:
	mov.l	@(16,r15),r1
	add	#1,r1
	mov.l	r1,@(16,r15)
	mov	r15,r1
	add	#39,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	extu.b	r1,r1
	exts.b	r1,r1
	shar	r1
	mov	r15,r1
	add	#39,r1
	mov.b	r1,@r1
L83:
	mov	r15,r1
	add	#39,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	extu.b	r1,r1
	tst	r1,r1
	bf	L80
	bra	L75
	nop
L76:
	mov.l	@(0,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(0,r15)
	mov	#0,r1
	bra	L75
	mov.l	r1,@(4,r15)
L74:
	mov.l	@(48,r15),r1
	mov.b	@(8,r1),r0
	mov	r0,r1
	mov	#1,r2
	extu.b	r1,r1
	sub	r2,r1
	mov	r15,r1
	add	#27,r1
	mov.b	r1,@r1
L75:
	mov.l	@(48,r15),r1
	mov	r15,r2
	add	#27,r2
	mov.b	@r2,r2
	extu.b	r2,r2
	mov	r2,r0
	mov.b	r0,@(8,r1)
	bra	L86
	mov.l	r8,@(28,r15)
L72:
	mov.l	L120,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#3,r0
	bf	L87
	mov	#20,r1
	exts.b	r11,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	mov.l	L121,r2
	mov.l	@r2,r2
	add	r2,r1
	mov.l	r1,@(44,r15)
	mov.l	@(44,r15),r1
	mov.w	@r1,r14
	mov.l	@(8,r1),r1
	mov.l	r1,@(4,r15)
L89:
	mov.l	@(44,r15),r1
	mov.b	@(12,r1),r0
	mov	r0,r1
	extu.b	r1,r1
	extu.w	r1,r1
	shll8	r1
	mov.l	@(0,r15),r2
	extu.b	r2,r2
	or	r2,r1
	mov	r1,r0
	mov.w	r0,@(2,r15)
	extu.w	r14,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	mov	r0,r2
	extu.w	r2,r2
	or	r2,r1
	bra	L88
	mov.l	r1,@(0,r15)
L87:
	mov.l	L120,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#4,r0
	bf	L92
	mov	#20,r1
	exts.b	r11,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	mov.l	L122,r2
	mov.l	@r2,r2
	add	r2,r1
	mov.l	r1,@(44,r15)
	mov.l	@(44,r15),r1
	mov.w	@r1,r14
	mov.l	@(8,r1),r1
	bra	L89
	mov.l	r1,@(4,r15)
L92:
	mov.l	@(52,r15),r1
	mov.l	L123,r2
	mov.l	@r2,r2
	add	r2,r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r15)
	mov.l	L124,r1
	mov.l	@r1,r1
	mov	r4,r1
	add	r1,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	extu.w	r1,r1
	shll8	r1
	mov.l	@(0,r15),r2
	extu.b	r2,r2
	or	r2,r1
	mov	r1,r0
	mov.w	r0,@(2,r15)
	mov.l	@(52,r15),r1
	mov.l	L123,r2
	mov.l	@r2,r2
	add	r2,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	mov	r0,r2
	extu.w	r2,r2
	or	r2,r1
	mov.l	r1,@(0,r15)
L88:
	mov.l	L125,r1
	mov.l	@r1,r1
	mov.l	@(4,r15),r2
	and	r2,r1
	mov.l	r1,@(4,r15)
	mov.l	r8,@(28,r15)
	mov	r8,r1
	tst	r1,r1
	bt	L96
	mov.l	@(48,r15),r1
	mov.l	@(8,r1),r2
	mov.l	r2,@(40,r15)
	mov	#0,r2
	mov.l	r2,@(32,r15)
	mov	r8,r2
	add	#1,r2
	mov.l	r2,@(28,r15)
	mov	r15,r2
	add	#4,r2
	mov.l	r2,@(12,r15)
	mov.l	r1,@(8,r15)
L98:
	mov.l	@(8,r15),r1
	mov.b	@r1,r1
	extu.b	r1,r1
	mov.l	@(12,r15),r2
	mov.b	@r2,r2
	extu.b	r2,r2
	cmp/eq	r2,r1
	bt	L101
	mov	r10,r1
	mov.l	@(28,r15),r2
	cmp/hi	r2,r1
	bt	L103
	bra	L105
	nop
L103:
	mov.l	@(28,r15),r1
	mov.l	@(12,r15),r2
	mov.b	@r2,r2
	mov.b	r2,@r1
	mov.l	@(32,r15),r1
	mov.l	@(20,r15),r2
	or	r2,r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	add	#1,r1
	mov.l	r1,@(28,r15)
L101:
	mov.l	@(20,r15),r1
	shll	r1
	mov.l	r1,@(20,r15)
	mov.l	@(12,r15),r1
	add	#1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(8,r15),r1
	add	#1,r1
	mov.l	r1,@(8,r15)
	mov.l	@(20,r15),r1
	mov	#127,r2
	and	r2,r1
	tst	r1,r1
	bf	L98
	mov.l	@(32,r15),r1
	tst	r1,r1
	bf	L106
	mov.l	@(40,r15),r1
	mov	r1,r2
	tst	r2,r2
	bt	L110
	mov.b	@r1,r1
	extu.b	r1,r1
	mov.w	L126,r2
	cmp/eq	r2,r1
	bf	L108
L110:
	mov	r10,r1
	mov	r8,r2
	cmp/hi	r2,r1
	bt	L111
L105:
	mov.l	L127,r1
	mov.l	r1,@(28,r15)
	mov.l	L134,r1
	mov.l	@r1,r1
	mov	#0,r2
	bra	L86
	mov.l	r2,@r1
L111:
	mov.w	L128,r1
	mov.b	r1,@r8
	mov	r8,r1
	add	#1,r1
	mov.l	r1,@(28,r15)
	bra	L107
	mov.l	r8,@(40,r15)
L108:
	mov.l	@(40,r15),r1
	mov.b	@r1,r2
	add	#1,r2
	mov.b	r2,@r1
	bra	L107
	mov.l	r8,@(28,r15)
L106:
	mov.l	@(32,r15),r1
	mov.b	r1,@r8
	mov.l	L127,r1
	mov.l	r1,@(40,r15)
L107:
	mov.l	L129,r1
	mov.l	@r1,r1
	mov.l	L130,r2
	mov.l	@r2,r2
	mov.l	@(28,r15),r3
	add	r3,r2
	mov.l	r2,@r1
	mov.l	@(48,r15),r1
	mov.l	@(40,r15),r2
	mov.l	r2,@(8,r1)
L96:
L86:
	mov.l	L131,r1
	mov.l	@r1,r9
	mov.l	L132,r1
	mov.l	@r1,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	mov.l	@(52,r15),r1
	add	r9,r1
	mov.l	r1,@(56,r15)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov	r0,r2
	mov.w	r2,@r1
	mov.l	@(48,r15),r1
	mov.w	@(4,r1),r0
	mov.l	@(56,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov	r0,r2
	extu.w	r2,r2
	extu.w	r12,r3
	not	r3,r3
	and	r3,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	L133,r1
	mov.l	@r1,r1
	mov.l	r1,@(52,r15)
	mov	#6,r2
	exts.b	r11,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.b	r2,r2
	add	r1,r2
	mov	r2,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.l	@(56,r15),r1
	mov.l	@(4,r15),r2
	mov.l	r2,@(8,r1)
	mov.l	@(48,r15),r1
	mov.l	@(4,r15),r2
	mov.l	r2,@r1
	mov.l	@(48,r15),r1
	mov.l	@(0,r15),r2
	mov.l	r2,@(4,r1)
	mov.l	@(52,r15),r0
L69:
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
L126:	.short	255
L128:	.short	128
L114:	.long	_DAT_0604462c
L115:	.long	_DAT_060443e0
L116:	.long	_DAT_060443b4
L117:	.long	_DAT_060443e8
L118:	.long	_DAT_060443f0
L119:	.long	_DAT_06044638
L120:	.long	_DAT_060443f4
L121:	.long	_DAT_06044424
L122:	.long	_DAT_06044620
L123:	.long	_DAT_06044624
L124:	.long	_DAT_06044628
L125:	.long	_DAT_06044420
L127:	.long	0
L129:	.long	_DAT_06044634
L130:	.long	_DAT_06044630
L131:	.long	_DAT_06044640
L132:	.long	_DAT_0604463c
L133:	.long	_DAT_06044644
L134:	.long	_DAT_06044638
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
	mov.l	L149,r1
	mov.l	@r1,r1
	mov	r1,r12
	mov	r15,r2
	add	#4,r2
	mov.l	r2,@(8,r15)
	mov.l	L150,r2
	mov.l	@r2,r2
	mov.l	@r2,r8
	mov.l	@r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r1),r2
	mov.l	r2,@(0,r15)
	mov.b	@(8,r1),r0
	mov	r0,r1
	tst	r1,r1
	bf	L136
	mov	#0,r1
	mov	r1,r0
	mov.b	r0,@(15,r15)
	mov.l	L151,r1
	mov.l	@r1,r1
	mov.l	@r1,r1
	mov	r8,r2
	mov.l	@(4,r1),r3
	add	r1,r3
	mov	r3,r1
	cmp/hs	r1,r2
	bt	L138
	mov.b	@r8+,r9
	extu.b	r9,r1
	exts.b	r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L145
	mov	#127,r2
	extu.b	r9,r1
	and	r2,r1
	mov	r1,r0
	bra	L137
	mov.b	r0,@(15,r15)
L142:
	mov	#1,r2
	extu.b	r9,r1
	and	r2,r1
	tst	r1,r1
	bt	L146
	mov.b	@r8+,r14
	mov.l	@(8,r15),r1
	mov.b	r14,@r1
L146:
	mov.l	@(8,r15),r1
	add	#1,r1
	mov.l	r1,@(8,r15)
	extu.b	r9,r1
	exts.b	r1,r1
	shar	r1
	mov	r1,r9
L145:
	extu.b	r9,r1
	tst	r1,r1
	bf	L142
	bra	L137
	nop
L138:
	mov.l	@(0,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(0,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
	mov.l	L152,r1
	mov.l	@r1,r1
	mov	#0,r2
	bra	L137
	mov.b	r2,@r1
L136:
	mov.l	L149,r1
	mov.l	@r1,r1
	mov.b	@(8,r1),r0
	mov	r0,r1
	mov	#1,r2
	sub	r2,r1
	mov	r1,r0
	mov.b	r0,@(15,r15)
L137:
	mov.l	L153,r1
	mov.l	@r1,r10
	mov.l	L150,r1
	mov.l	@r1,r11
	mov.b	@(15,r15),r0
	extu.b	r0,r0
	mov.b	r0,@(8,r12)
	mov	r8,r1
	mov.l	r1,@r11
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov	r0,r1
	mov.w	r1,@r10
	mov.w	@(4,r12),r0
	mov.w	r0,@(6,r10)
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov	r0,r1
	extu.w	r1,r1
	extu.w	r13,r2
	not	r2,r2
	and	r2,r1
	mov	r1,r0
	mov.w	r0,@(2,r10)
	mov.l	L154,r1
	mov.l	@r1,r1
	add	#5,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov	r0,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	r1,@(8,r10)
	mov.l	@(4,r15),r1
	mov.l	r1,@r12
	mov.l	@(0,r15),r1
	mov.l	r1,@(4,r12)
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
L149:	.long	_DAT_06044648
L150:	.long	_DAT_0604464c
L151:	.long	_DAT_06044650
L152:	.long	_DAT_06044654
L153:	.long	_DAT_06044658
L154:	.long	_DAT_0604465c
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
	mov.l	L164,r1
	mov.l	@r1,r1
	mov	r1,r9
	mov.l	@r1,r1
	mov	r1,r11
	mov.l	L165,r1
	mov.l	@r1,r1
	mov.w	r1,@r11
	mov.l	L166,r1
	mov.l	@r1,r1
	mov	r1,r10
	mov.l	L168,r3
	mov.l	L167,r1
	mov.l	@r1,r1
	mov.l	L168,r3
	jsr	@r3
	mov.l	r10,@(20,r11)
	mov.l	L169,r1
	mov.l	@r1,r1
	mov.l	@r1,r13
	mov.l	L170,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	bra	L159
	mov	r1,r12
L156:
	mov.l	L171,r3
	jsr	@r3
	mov	r13,r4
	mov.l	L172,r1
	mov.l	@r1,r1
	mov	r13,r1
	add	r1,r1
	mov.l	@r1,r13
	add	#-1,r12
L159:
	tst	r12,r12
	bf	L156
	mov.l	L173,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L160
	mov.l	L174,r1
	mov.l	@r1,r1
	mov	r1,r10
	mov	r8,r1
	add	#18,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L162
	mov.l	L175,r1
	mov.l	@r1,r1
	mov	r1,r10
L162:
	mov.l	L171,r3
	jsr	@r3
	mov	r10,r4
L160:
	mov	r11,r1
	add	#32,r1
	mov.l	r1,@r9
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
L164:	.long	_DAT_06044768
L165:	.long	_DAT_06044762
L166:	.long	_DAT_06044784
L167:	.long	_DAT_06044780
L168:	.long	_FUN_06044834
L169:	.long	_DAT_0604476c
L170:	.long	_DAT_06044770
L171:	.long	_FUN_06044788
L172:	.long	_DAT_06044764
L173:	.long	_DAT_06044774
L174:	.long	_DAT_06044778
L175:	.long	_DAT_0604477c
	.global _FUN_06044788
	.align 2
_FUN_06044788:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov.l	@(0,r15),r1
	mov.l	@r14,r2
	mov.l	@r1,r3
	sub	r3,r2
	mov	r2,r10
	add	#8,r1
	mov.l	@r1,r1
	mov.l	@(8,r14),r2
	sub	r2,r1
	mov	r1,r9
	mov	r10,r12
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L177
	not	r10,r1
	mov	r1,r12
	add	#1,r12
L177:
	mov	r12,r1
	mov.l	L187,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L179
	mov	r9,r12
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L181
	not	r9,r1
	mov	r1,r12
	add	#1,r12
L181:
	mov	r12,r1
	mov.l	L187,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L183
	mov.l	L188,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r1
	mov.l	L189,r3
	jsr	@r3
	neg	r1,r4
	mov.l	@(4,r15),r1
	mov	r4,r12
	sub	r1,r12
	mov.l	L190,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L185
	not	r12,r1
	mov	r1,r12
	add	#1,r12
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L185:
	mov	r12,r1
	shlr8	r1
	shlr2	r1
	shlr2	r1
	mov	#7,r2
	and	r2,r1
	mov.l	L191,r2
	add	r2,r1
	mov.b	@r1,r13
	mov.l	L192,r1
	mov.l	@r1,r1
	mov	r12,r2
	shlr8	r2
	shlr2	r2
	shlr2	r2
	shlr2	r2
	mov	#3,r3
	and	r3,r2
	mov.l	L193,r3
	add	r3,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	or	r2,r1
	mov.w	r1,@r8
	mov.l	L194,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r8)
	mov.l	L195,r1
	mov.l	@r1,r1
	mov	r13,r2
	shll16	r2
	add	r2,r1
	mov.l	r1,@(8,r8)
	mov.l	L196,r1
	mov.l	@r1,r1
	mov	r10,r2
	shlr16	r2
	exts.w	r2,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(12,r8)
	mov.l	L197,r1
	mov.l	@r1,r1
	mov	r9,r2
	shlr16	r2
	mov	r1,r1
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(14,r8)
L183:
L179:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L187:	.long	_DAT_06044814
L188:	.long	_FUN_06044834
L189:	.long	_PTR_FUN_06044818
L190:	.long	_DAT_0604481c
L191:	.long	_DAT_06044828
L192:	.long	_DAT_0604480c
L193:	.long	_DAT_06044830
L194:	.long	_DAT_06044820
L195:	.long	_DAT_06044824
L196:	.long	_DAT_0604480e
L197:	.long	_DAT_06044810
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
	mov.l	L210,r1
	mov.l	@r1,r1
	mov	r1,r9
	mov.l	@r1,r12
	mov.l	L211,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L200
	mov.l	L212,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L202
	mov.l	L213,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L202
	mov.l	L214,r1
	mov.l	@r1,r11
	mov.l	L215,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L204
	mov.l	L216,r1
	mov.l	@r1,r11
L204:
	mov.l	L217,r1
	mov.l	@r1,r1
	mov.l	L218,r2
	mov.l	@r2,r2
	mov.b	@r2,r2
	shll8	r2
	mov	r1,r4
	add	r2,r4
	mov.l	L219,r3
	jsr	@r3
	mov	r11,r5
L202:
	mov.l	L220,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L206
	mov.l	L222,r5
	mov.l	L221,r4
	mov.l	L219,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
L206:
	mov	r8,r4
	mov.l	L223,r1
	mov.w	@r1,r1
	mov	r8,r1
	add	r1,r1
	mov.w	@r1,r1
	shll2	r1
	mov.l	L224,r5
	add	r1,r5
	mov.l	L219,r3
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
L200:
	mov	r8,r4
	mov.l	L225,r1
	mov.w	@r1,r1
	mov	r8,r1
	add	r1,r1
	mov.w	@r1,r1
	shll2	r1
	mov.l	L224,r5
	add	r1,r5
	mov.l	L219,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L226,r1
	mov.l	@r1,r10
	mov	r8,r1
	add	#18,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L208
	mov.l	L227,r1
	mov.l	@r1,r10
L208:
	mov	r10,r4
	mov.l	L225,r1
	mov.w	@r1,r1
	mov	r10,r1
	add	r1,r1
	mov.w	@r1,r1
	shll2	r1
	mov.l	L224,r5
	add	r1,r5
	mov.l	L228,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	r12,@r9
L199:
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
L224:	.short	100944200
	.align 2
L210:	.long	_puRam060448d0
L211:	.long	_pcRam060448d8
L212:	.long	_pcRam060448dc
L213:	.long	_pcRam060448e0
L214:	.long	_uRam060448ec
L215:	.long	_pcRam060448f0
L216:	.long	_uRam060448f4
L217:	.long	_iRam060448e8
L218:	.long	_pcRam060448e4
L219:	.long	_FUN_060449ac
L220:	.long	_pcRam060448f8
L221:	.long	_uRam060448fc
L222:	.long	_uRam06044900
L223:	.long	_sRam060448ce
L225:	.long	_sRam0604493e
L226:	.long	_iRam06044940
L227:	.long	_iRam06044944
L228:	.long	_FUN_060449a0
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
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r4
	mov.l	L232,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L233,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r2
	mov	r4,r3
	add	r2,r3
	mov.l	L234,r2
	mov.w	@r2,r2
	mov	r3,r4
	sub	r2,r4
	mov.w	@(8,r1),r0
	mov	r0,r2
	dmuls.l	r2,r10
	sts	mach,r2
	mov	r2,r12
	exts.w	r12,r2
	neg	r2,r2
	mov	r2,r9
	mov.w	@(10,r1),r0
	mov	r0,r1
	dmuls.l	r1,r8
	sts	mach,r1
	exts.w	r1,r1
	neg	r1,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L235,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L230
	neg	r4,r4
	mov.l	@(0,r15),r1
	exts.w	r12,r2
	mov.w	@(4,r1),r0
	add	r0,r2
	mov	r2,r9
	mov.w	@(10,r15),r0
	mov	r0,r2
	mov.w	@(6,r1),r0
	add	r0,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L230:
	mov.l	@(0,r15),r1
	exts.w	r9,r2
	mov.w	@r1+,r3
	add	r3,r2
	mov	r2,r9
	mov.w	@(10,r15),r0
	mov	r0,r2
	mov.w	@r1,r1
	add	r1,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L236,r1
	mov.w	@r1,r1
	mov	r1,r8
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll	r1
	mov	r1,r10
	mov.l	@(4,r15),r1
	mov.l	L237,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	L238,r2
	mov.l	@r2,r2
	mov.l	r2,@(4,r1)
	mov.l	@(4,r15),r1
	mov	r8,r2
	add	r4,r2
	shll2	r2
	shll2	r2
	shlr16	r2
	mov	#3,r3
	and	r3,r2
	shll16	r2
	shll2	r2
	shll2	r2
	add	r13,r2
	mov.l	r2,@(8,r1)
	mov.l	@(4,r15),r1
	mov.l	L239,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L240,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L241,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L242,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L243,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L244,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L245,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L246,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L244:	.short	100944529
L246:	.short	100944531
L232:	.long	_pcRam06044a70
L233:	.long	_FUN_06044834
L234:	.long	_sRam06044a68
L235:	.long	_pcRam06044a74
L236:	.long	_sRam06044a6a
L237:	.long	_uRam06044a6c
L238:	.long	_uRam06044a78
L239:	.long	100944524
L240:	.long	100944525
L241:	.long	100944526
L242:	.long	100944527
L243:	.long	100944528
L245:	.long	100944530
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
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r4
	mov.l	L250,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L251,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r2
	mov	r4,r3
	add	r2,r3
	mov.l	L252,r2
	mov.w	@r2,r2
	mov	r3,r4
	sub	r2,r4
	mov.w	@(8,r1),r0
	mov	r0,r2
	dmuls.l	r2,r10
	sts	mach,r2
	mov	r2,r12
	exts.w	r12,r2
	neg	r2,r2
	mov	r2,r9
	mov.w	@(10,r1),r0
	mov	r0,r1
	dmuls.l	r1,r8
	sts	mach,r1
	exts.w	r1,r1
	neg	r1,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L253,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L248
	neg	r4,r4
	mov.l	@(0,r15),r1
	exts.w	r12,r2
	mov.w	@(4,r1),r0
	add	r0,r2
	mov	r2,r9
	mov.w	@(10,r15),r0
	mov	r0,r2
	mov.w	@(6,r1),r0
	add	r0,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L248:
	mov.l	@(0,r15),r1
	exts.w	r9,r2
	mov.w	@r1+,r3
	add	r3,r2
	mov	r2,r9
	mov.w	@(10,r15),r0
	mov	r0,r2
	mov.w	@r1,r1
	add	r1,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L254,r1
	mov.w	@r1,r1
	mov	r1,r8
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll	r1
	mov	r1,r10
	mov.l	@(4,r15),r1
	mov.l	L255,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	L256,r2
	mov.l	@r2,r2
	mov.l	r2,@(4,r1)
	mov.l	@(4,r15),r1
	mov	r8,r2
	add	r4,r2
	shll2	r2
	shll2	r2
	shlr16	r2
	mov	#3,r3
	and	r3,r2
	shll16	r2
	shll2	r2
	shll2	r2
	add	r13,r2
	mov.l	r2,@(8,r1)
	mov.l	@(4,r15),r1
	mov.l	L257,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L258,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L259,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L260,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L261,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L262,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L263,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r9,r3
	add	r3,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L264,r2
	add	r10,r2
	mov.b	@r2,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L262:	.short	100944513
L264:	.short	100944515
L250:	.long	_pcRam06044a70
L251:	.long	_FUN_06044834
L252:	.long	_sRam06044a68
L253:	.long	_pcRam06044a74
L254:	.long	_sRam06044a6a
L255:	.long	_uRam06044a6c
L256:	.long	_uRam06044a78
L257:	.long	100944508
L258:	.long	100944509
L259:	.long	100944510
L260:	.long	100944511
L261:	.long	100944512
L263:	.long	100944514
	.global _FUN_060449b6
	.align 2
_FUN_060449b6:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-20,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r9
	mov.l	@r14,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r4
	mov.l	L268,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L269,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r1
	mov.w	@(12,r1),r0
	mov	r0,r2
	mov	r4,r3
	add	r2,r3
	mov.l	L270,r2
	mov.w	@r2,r2
	mov	r3,r4
	sub	r2,r4
	mov.w	@(8,r1),r0
	mov	r0,r2
	dmuls.l	r2,r9
	sts	mach,r2
	mov	r2,r12
	exts.w	r12,r2
	neg	r2,r2
	mov	r2,r8
	mov.w	@(10,r1),r0
	mov	r0,r1
	mov.l	@(16,r15),r2
	dmuls.l	r1,r2
	sts	mach,r1
	exts.w	r1,r1
	neg	r1,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
	mov.l	L271,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L266
	neg	r4,r4
	mov.l	@(0,r15),r1
	exts.w	r12,r2
	mov.w	@(4,r1),r0
	add	r0,r2
	mov	r2,r8
	mov.w	@(14,r15),r0
	mov	r0,r2
	mov.w	@(6,r1),r0
	add	r0,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
L266:
	mov.l	@(0,r15),r1
	exts.w	r8,r2
	mov.w	@r1,r3
	add	r3,r2
	mov	r2,r8
	mov.w	@(14,r15),r0
	mov	r0,r2
	mov.w	@(2,r1),r0
	add	r0,r2
	mov	r2,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
	mov.l	L272,r1
	mov.w	@r1,r1
	mov	r1,r9
	mov.l	@(8,r15),r1
	mov.l	L273,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.l	@(8,r15),r1
	mov.l	L274,r2
	mov.l	@r2,r2
	mov.l	r2,@(4,r1)
	mov.l	@(8,r15),r1
	mov	r9,r2
	add	r4,r2
	shll2	r2
	shll2	r2
	shlr16	r2
	mov	#3,r3
	and	r3,r2
	shll16	r2
	shll2	r2
	shll2	r2
	add	r13,r2
	mov.l	r2,@(8,r1)
	mov	r9,r1
	add	r4,r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll	r1
	mov.l	@(4,r15),r2
	add	r2,r1
	mov	r1,r10
	mov.l	@(8,r15),r1
	mov.b	@r10,r2
	exts.w	r8,r3
	add	r3,r2
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
	exts.w	r8,r3
	add	r3,r2
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
	exts.w	r8,r3
	add	r3,r2
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
	exts.w	r8,r3
	add	r3,r2
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
L268:	.long	_pcRam06044a70
L269:	.long	_FUN_06044834
L270:	.long	_sRam06044a68
L271:	.long	_pcRam06044a74
L272:	.long	_sRam06044a6a
L273:	.long	_uRam06044a6c
L274:	.long	_uRam06044a78
	.global _FUN_06044a9a
	.align 2
_FUN_06044a9a:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov.l	L276,r1
	mov.l	@r1,r1
	mov	r1,r14
	mov.l	@r1,r1
	mov	r1,r12
	mov.l	L277,r1
	mov.l	@r1,r1
	mov.w	r1,@r12
	mov.l	L278,r1
	mov.l	@r1,r1
	mov	r1,r13
	mov.l	L280,r4
	mov.l	L281,r3
	mov.l	L279,r1
	mov.l	@r1,r1
	mov.l	L280,r4
	mov.l	L281,r3
	jsr	@r3
	mov.l	L282,r4
	mov.l	L283,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r1
	add	#32,r1
	mov.l	L277,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.l	L284,r1
	mov.l	@r1,r1
	mov	r1,r13
	mov.l	L282,r4
	mov.l	L281,r3
	mov.l	L285,r1
	mov.l	@r1,r1
	mov.l	L282,r4
	mov.l	L281,r3
	jsr	@r3
	mov.l	L280,r4
	mov.l	L283,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r1
	add	#64,r1
	mov.l	r1,@r14
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L276:	.long	_DAT_06044b04
L277:	.long	_DAT_06044afe
L278:	.long	_DAT_06044b14
L279:	.long	_DAT_06044b10
L280:	.long	_DAT_06044b08
L281:	.long	_FUN_06044834
L282:	.long	_DAT_06044b0c
L283:	.long	_FUN_06044b20
L284:	.long	_DAT_06044b1c
L285:	.long	_DAT_06044b18
	.global _FUN_06044ada
	.align 2
_FUN_06044ada:
	sts.l	pr,@-r15
	mov.l	L287,r4
	mov.l	L288,r3
	jsr	@r3
	mov.l	L289,r4
	mov.l	L290,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r14
	.align 2
L287:	.long	_DAT_06044b0c
L288:	.long	_FUN_06044834
L289:	.long	_DAT_06044b08
L290:	.long	_FUN_06044b20
	.global _FUN_06044b20
	.align 2
_FUN_06044b20:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	@(0,r15),r1
	mov.l	@r14,r2
	mov.l	@r1,r3
	sub	r3,r2
	mov	r2,r10
	add	#8,r1
	mov.l	@r1,r1
	mov.l	@(8,r14),r2
	sub	r2,r1
	mov	r1,r9
	mov	r10,r12
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L292
	not	r10,r1
	mov	r1,r12
	add	#1,r12
L292:
	mov	r12,r1
	mov.l	L302,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L294
	mov	r9,r12
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L296
	not	r9,r1
	mov	r1,r12
	add	#1,r12
L296:
	mov	r12,r1
	mov.l	L302,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L298
	mov.l	L303,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r1
	mov.l	L304,r3
	jsr	@r3
	neg	r1,r4
	mov.l	@(4,r15),r1
	mov	r4,r12
	sub	r1,r12
	mov.l	L305,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L300
	not	r12,r1
	mov	r1,r12
	add	#1,r12
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L300:
	mov	r12,r1
	shlr8	r1
	shlr2	r1
	shlr2	r1
	mov	#7,r2
	and	r2,r1
	mov.l	L306,r2
	add	r2,r1
	mov.b	@r1,r13
	mov.l	L307,r1
	mov.l	@r1,r1
	mov	r12,r2
	shlr8	r2
	shlr2	r2
	shlr2	r2
	shlr2	r2
	mov	#3,r3
	and	r3,r2
	mov.l	L308,r3
	add	r3,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	or	r2,r1
	mov.w	r1,@r8
	mov.l	L309,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r8)
	mov.l	L310,r1
	mov.l	@r1,r1
	mov	r13,r2
	shll16	r2
	add	r2,r1
	mov.l	r1,@(8,r8)
	mov.l	L311,r1
	mov.l	@r1,r1
	mov	r10,r2
	shlr16	r2
	shlr	r2
	extu.w	r2,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(12,r8)
	mov	r9,r1
	shlr16	r1
	shlr	r1
	mov.l	@(8,r15),r2
	mov	r1,r1
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(14,r8)
L298:
L294:
	add	#12,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L302:	.long	_DAT_06044bac
L303:	.long	_FUN_06044834
L304:	.long	_PTR_FUN_06044bb0
L305:	.long	_DAT_06044bb4
L306:	.long	_DAT_06044bc0
L307:	.long	_DAT_06044ba8
L308:	.long	_DAT_06044bc8
L309:	.long	_DAT_06044bb8
L310:	.long	_DAT_06044bbc
L311:	.long	_DAT_06044baa
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
	mov.l	L325,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r15)
	mov.l	L326,r1
	mov.l	@r1,r12
	mov.l	L327,r1
	mov.l	@r1,r11
	mov.l	L328,r1
	mov.l	@r1,r10
	mov.l	L329,r1
	mov.l	@r1,r1
	mov	r1,r9
	mov.l	L330,r2
	mov.l	@r2,r14
	mov.b	@r1,r1
	tst	r1,r1
	bf	L313
	mov	#0,r1
	mov.l	r1,@(4,r15)
	mov	#0,r1
	mov.l	r1,@(16,r15)
L315:
	mov.l	L331,r1
	mov.l	@r1,r1
	mov	r1,r8
	mov.l	@(16,r15),r2
	mov	r14,r4
	extu.b	r2,r3
	mov	r3,r4
	add	r4,r4
	mov.l	r4,@(20,r15)
	mov	#3,r4
	mov.b	@r10,r5
	muls.w	r5,r4
	sts	macl,r4
	mov.b	@r11,r5
	exts.w	r5,r5
	add	r5,r4
	mul.l	r1,r4
	sts	macl,r1
	exts.w	r1,r1
	add	r12,r1
	add	r3,r1
	mov	r1,r13
	mov	r2,r1
	add	#12,r1
	extu.b	r1,r1
	mov.l	r1,@(8,r15)
	mov.l	@(20,r15),r1
	mov.l	@r13,r2
	mov.l	r2,@r1
	mov.l	@(20,r15),r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	r2,@r1
	mov.l	@(20,r15),r1
	add	#8,r1
	mov.l	@(8,r13),r2
	mov.l	r2,@r1
	mov.l	@(8,r15),r1
	mov	r14,r2
	mov	r1,r2
	add	r2,r2
	mov.l	r2,@(20,r15)
	mov.l	@(4,r15),r2
	add	#2,r2
	mov.l	r2,@(4,r15)
	mov	#3,r2
	mov.b	@r10,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r11,r3
	exts.w	r3,r3
	add	r3,r2
	exts.w	r8,r3
	muls.w	r3,r2
	sts	macl,r2
	exts.w	r2,r2
	add	r12,r2
	add	r1,r2
	mov	r2,r13
	mov.l	@(20,r15),r1
	mov.l	@r13,r2
	mov.l	r2,@r1
	mov.l	@(20,r15),r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	r2,@r1
	mov.l	@(20,r15),r1
	add	#8,r1
	mov.l	@(8,r13),r2
	mov.l	r2,@r1
	mov.l	@(16,r15),r1
	add	#24,r1
	mov.l	r1,@(16,r15)
	mov.l	@(4,r15),r1
	mov	#20,r2
	cmp/ge	r2,r1
	bf	L315
	bra	L314
	nop
L313:
	mov.l	L330,r1
	mov.l	@r1,r1
	mov	r1,r13
	add	#60,r13
	mov	#0,r1
	mov	r1,r0
	bra	L321
	mov.b	r0,@(3,r15)
L318:
	mov	#60,r1
	mov.b	@r10,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	mov.b	@(3,r15),r0
	add	r0,r1
	mov.l	r1,@(20,r15)
	mov.l	@(20,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@r14
	mov	r14,r1
	add	#4,r1
	mov.l	@(20,r15),r2
	add	#4,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#8,r1
	mov.l	@(20,r15),r2
	add	#8,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov.b	@(3,r15),r0
	mov	r0,r0
	add	#12,r0
	mov.b	r0,@(3,r15)
	add	#12,r14
L321:
	mov	r14,r1
	mov	r13,r2
	cmp/hs	r2,r1
	bf	L318
L314:
	mov.l	L332,r1
	mov.l	@r1,r12
	mov.l	L333,r1
	mov.l	@r1,r1
	mov	r1,r14
	mov	#0,r2
	mov.l	r2,@(12,r15)
	mov	#0,r2
	mov	r2,r0
	mov.b	r0,@(3,r15)
	mov	#24,r2
	mov	#5,r3
	mov.b	@r9,r4
	muls.w	r4,r3
	sts	macl,r3
	mov.b	@r10,r4
	add	r4,r3
	mul.l	r3,r2
	sts	macl,r2
	extu.b	r2,r2
	mov.l	L334,r3
	mov.l	@r3,r3
	add	r3,r2
	mov	r2,r13
	mov.l	@r13,r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#8,r1
	mov.l	@(8,r13),r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#12,r1
	mov.l	@(12,r13),r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#16,r1
	mov.l	@(16,r13),r2
	mov.l	r2,@r1
	mov	r14,r1
	add	#20,r1
	mov.l	@(20,r13),r2
	mov.l	r2,@r1
	mov.l	L335,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r15)
L322:
	mov.b	@(3,r15),r0
	mov	r0,r1
	mov	r1,r13
	add	r12,r13
	mov	#48,r2
	mov	#5,r3
	mov.b	@r9,r4
	muls.w	r4,r3
	sts	macl,r3
	mov.b	@r10,r4
	exts.w	r4,r4
	add	r4,r3
	mul.l	r3,r2
	sts	macl,r2
	exts.w	r2,r2
	mov.l	@(4,r15),r3
	add	r3,r2
	add	r1,r2
	mov	r2,r1
	mov	r1,r14
	mov.l	@r14,r1
	mov.l	r1,@r13
	mov	r13,r1
	add	#4,r1
	mov.l	@(4,r14),r2
	mov.l	r2,@r1
	mov	r13,r1
	add	#8,r1
	mov.l	@(8,r14),r2
	mov.l	r2,@r1
	mov.b	@(3,r15),r0
	mov	r0,r1
	add	#12,r1
	exts.b	r1,r1
	mov	r1,r13
	add	r12,r13
	mov.l	@(12,r15),r2
	add	#2,r2
	mov.l	r2,@(12,r15)
	mov	#48,r2
	mov	#5,r3
	mov.b	@r9,r4
	muls.w	r4,r3
	sts	macl,r3
	mov.b	@r10,r4
	exts.w	r4,r4
	add	r4,r3
	mul.l	r3,r2
	sts	macl,r2
	exts.w	r2,r2
	mov.l	@(4,r15),r3
	add	r3,r2
	add	r1,r2
	mov	r2,r1
	mov	r1,r14
	mov.l	@r14,r1
	mov.l	r1,@r13
	mov	r13,r1
	add	#4,r1
	mov.l	@(4,r14),r2
	mov.l	r2,@r1
	mov	r13,r1
	add	#8,r1
	mov.l	@(8,r14),r2
	mov.l	r2,@r1
	mov.b	@(3,r15),r0
	mov	r0,r0
	add	#24,r0
	mov.b	r0,@(3,r15)
	mov.l	@(12,r15),r1
	mov	#4,r2
	cmp/ge	r2,r1
	bf	L322
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
L325:	.long	_DAT_06044d50
L326:	.long	_DAT_06044c64
L327:	.long	_DAT_06044c60
L328:	.long	_DAT_06044c5c
L329:	.long	_DAT_06044c58
L330:	.long	_DAT_06044c54
L331:	.long	_DAT_06044c52
L332:	.long	_DAT_06044d5c
L333:	.long	_DAT_06044d58
L334:	.long	_DAT_06044d54
L335:	.long	_DAT_06044d60
	.global _FUN_06044d64
	.align 2
_FUN_06044d64:
	sts.l	pr,@-r15
	mov.l	L337,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L337:	.long	_FUN_06044d74
	.global _FUN_06044d74
	.align 2
_FUN_06044d74:
	mov.l	L341,r1
	mov.l	@r1,r7
	mov.l	L342,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L339
	mov.l	L343,r1
	mov.l	@r1,r7
L339:
	mov.l	L344,r1
	mov.l	r1,@r7
	mov	#0,r1
	mov.l	r1,@(4,r14)
	mov	#0,r1
	mov.l	r1,@(8,r14)
	mov	#0,r1
	mov.l	r1,@(12,r14)
	mov	#0,r1
	mov.l	r1,@(16,r14)
	mov.l	L344,r1
	mov.l	r1,@(20,r14)
	mov	#0,r1
	mov.l	r1,@(24,r14)
	mov	#0,r1
	mov.l	r1,@(28,r14)
	mov	#0,r1
	mov.l	r1,@(32,r14)
	mov	#0,r1
	mov.l	r1,@(36,r14)
	mov.l	L344,r1
	mov.l	r1,@(40,r14)
	mov	#0,r1
	rts
	mov.l	r1,@(44,r14)
	.align 2
L341:	.long	_DAT_06044da0
L342:	.long	__DAT_ffffffe2
L343:	.long	_DAT_06044da4
L344:	.long	65536
	.global _FUN_06044d80
	.align 2
_FUN_06044d80:
	mov.l	L346,r1
	mov.l	r1,@r4
	mov	#0,r1
	mov.l	r1,@(4,r4)
	mov	#0,r1
	mov.l	r1,@(8,r4)
	mov	#0,r1
	mov.l	r1,@(12,r4)
	mov	#0,r1
	mov.l	r1,@(16,r4)
	mov.l	L346,r1
	mov.l	r1,@(20,r4)
	mov	#0,r1
	mov.l	r1,@(24,r4)
	mov	#0,r1
	mov.l	r1,@(28,r4)
	mov	#0,r1
	mov.l	r1,@(32,r4)
	mov	#0,r1
	mov.l	r1,@(36,r4)
	mov.l	L346,r1
	mov.l	r1,@(40,r4)
	mov	#0,r1
	rts
	mov.l	r1,@(44,r4)
	.align 2
L346:	.long	65536
	.global _FUN_06044da8
	.align 2
_FUN_06044da8:
	sts.l	pr,@-r15
	mov.l	L348,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L348:	.long	_FUN_06044db8
	.global _FUN_06044db8
	.align 2
_FUN_06044db8:
	mov.l	@r4,r1
	mov.l	r1,@(48,r4)
	mov.l	@(4,r4),r1
	mov.l	r1,@(52,r4)
	mov.l	@(8,r4),r1
	mov.l	r1,@(56,r4)
	mov.l	@(12,r4),r1
	mov.l	r1,@(60,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	@(16,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#68,r1
	mov.l	@(20,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#72,r1
	mov.l	@(24,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#76,r1
	mov.l	@(28,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#80,r1
	mov.l	@(32,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#84,r1
	mov.l	@(36,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#88,r1
	mov.l	@(40,r4),r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#92,r1
	mov.l	@(44,r4),r2
	rts
	mov.l	r2,@r1
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
	mov.l	L351,r3
	jsr	@r3
	add	#0,r5
	mov	r0,r1
	mov	r1,r10
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov	r10,r0
	.align 2
L351:	.long	_FUN_06044e3c
	.global _FUN_06044e3c
	.align 2
_FUN_06044e3c:
	sts.l	macl,@-r15
	add	#-20,r15
	mov	#3,r8
L353:
	mov.l	@r5,r10
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r10,r9
	xor	r1,r9
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L356
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L356:
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L358
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L358:
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	extu.w	r10,r3
	mul.l	r3,r2
	sts	macl,r12
	shlr16	r1
	mul.l	r3,r1
	sts	macl,r1
	mov	r1,r11
	mov	#0,r1
	mov	r1,r6
	mov	r11,r1
	mov	r10,r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	mov	r1,r7
	tst	r11,r11
	bt/s	L360
	add	r2,r7
	mov.l	L434,r6
L360:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L364
	mov	#1,r7
L363:
	mov	#0,r7
L364:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mov	r10,r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L369
	mov	#1,r6
L368:
	mov	#0,r6
L369:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L365
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L370
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L371
	mov.l	r1,@(12,r15)
L370:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L371:
L365:
	mov	#1,r1
	mov.l	@(16,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L372
	mov.l	@(12,r15),r1
	mov.w	L435,r2
	cmp/ge	r2,r1
	bt	L374
	mov.w	L435,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L374:
	mov.w	L436,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L376
	mov.w	L436,r1
	mov.l	r1,@(12,r15)
	mov.w	L437,r1
	mov.l	r1,@(8,r15)
L376:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L372:
	mov.l	@(4,r5),r9
	mov.l	@(4,r4),r10
	mov	r9,r7
	xor	r10,r7
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L378
	not	r9,r1
	mov	r1,r9
	add	#1,r9
L378:
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L380
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L380:
	extu.w	r10,r1
	extu.w	r9,r2
	mul.l	r2,r1
	sts	macl,r3
	mov.l	r3,@(0,r15)
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r6
	mov	r11,r2
	mov	r9,r3
	shlr16	r3
	mul.l	r3,r1
	sts	macl,r1
	mov	r2,r12
	tst	r11,r11
	bt/s	L382
	add	r1,r12
	mov.l	L434,r6
L382:
	mov.l	@(0,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L386
	mov	#1,r7
L385:
	mov	#0,r7
L386:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov	r9,r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	mov	r1,r10
	add	r2,r10
	mov	r7,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L391
	mov	#1,r6
L390:
	mov	#0,r6
L391:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L387
	not	r10,r10
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L392
	bra	L393
	add	#1,r10
	.align 2
L435:	.short	-32768
L436:	.short	32767
L437:	.short	-1
L392:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L393:
L387:
	mov	#1,r1
	mov.l	@(16,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L394
	mov.l	@(8,r15),r1
	mov.l	@(4,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L398
	mov	#1,r7
L397:
	mov	#0,r7
L398:
	mov	r7,r1
	mov	r10,r2
	add	r1,r2
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r2
	mov.l	r2,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L440,r2
	cmp/ge	r2,r1
	bt	L399
	mov.w	L440,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L399:
	mov.w	L441,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L401
	mov.w	L441,r1
	mov.l	r1,@(12,r15)
	mov.w	L442,r1
	mov.l	r1,@(4,r15)
L401:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L395
	mov.l	r1,@(12,r15)
L394:
	mov.l	@(8,r15),r1
	mov.l	@(4,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L405
	mov	#1,r7
L404:
	mov	#0,r7
L405:
	mov	r7,r1
	mov	r10,r2
	add	r1,r2
	mov.l	@(12,r15),r1
	add	r1,r2
	mov.l	r2,@(12,r15)
L395:
	mov.l	@(8,r5),r9
	mov.l	@(8,r4),r10
	mov	r9,r7
	xor	r10,r7
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L406
	not	r9,r1
	mov	r1,r9
	add	#1,r9
L406:
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L408
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L408:
	extu.w	r10,r1
	extu.w	r9,r2
	mul.l	r2,r1
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r6
	mov	r11,r2
	mov	r9,r3
	shlr16	r3
	mul.l	r3,r1
	sts	macl,r1
	mov	r2,r12
	tst	r11,r11
	bt/s	L410
	add	r1,r12
	mov.l	L439,r6
L410:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L414
	mov	#1,r7
L413:
	mov	#0,r7
L414:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov	r9,r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	mov	r1,r10
	add	r2,r10
	mov	r7,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L419
	mov	#1,r6
L418:
	mov	#0,r6
L419:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L415
	not	r10,r10
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L420
	bra	L421
	add	#1,r10
L420:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L421:
L415:
	mov	#1,r1
	mov.l	@(16,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L422
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L426
	mov	#1,r7
L425:
	mov	#0,r7
L426:
	mov	r7,r1
	mov	r10,r2
	add	r1,r2
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r2
	mov.l	r2,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L443,r2
	cmp/ge	r2,r1
	bt	L427
	mov.w	L443,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L427:
	mov.w	L444,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L429
	mov.w	L444,r1
	mov.l	r1,@(12,r15)
	mov.w	L445,r1
	mov.l	r1,@(0,r15)
L429:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L423
	mov.l	r1,@(12,r15)
L422:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L433
	mov	#1,r7
L432:
	mov	#0,r7
L433:
	mov	r7,r1
	mov	r10,r2
	add	r1,r2
	mov.l	@(12,r15),r1
	add	r1,r2
	mov.l	r2,@(12,r15)
L423:
	mov	r4,r1
	add	#12,r1
	mov.l	@(12,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	@r1,r3
	add	r3,r2
	mov.l	r2,@r1
	add	#-1,r8
	mov.l	@(16,r15),r1
	mov.w	L438,r2
	and	r2,r1
	mov.l	r1,@(16,r15)
	add	#16,r4
	tst	r8,r8
	bf	L353
	add	#20,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L438:	.short	-2
L440:	.short	-32768
L441:	.short	32767
L442:	.short	-1
L443:	.short	-32768
L444:	.short	32767
L445:	.short	-1
	.align 2
L434:	.long	65536
L439:	.long	65536
	.global _FUN_06045006
	.align 2
_FUN_06045006:
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r1
	add	#8,r1
	mov.l	L552,r2
	mov.l	@r2,r2
	and	r2,r1
	mov.l	r1,@(40,r15)
	mov.l	@(40,r15),r1
	tst	r1,r1
	bf	L447
	mov.l	L552,r1
	mov.l	@r1,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L552:	.long	_DAT_06045070
L447:
	mov.l	L553,r1
	mov.l	@r1,r1
	mov.l	@(40,r15),r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov.l	r1,@(40,r15)
	mov	#3,r8
L449:
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L452
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L452:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L454
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L454:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r5
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L456
	add	r1,r7
	mov.l	L554,r6
L456:
	mov	r7,r1
	shll16	r1
	mov	r5,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r5,r1
	bf/s	L460
	mov	#1,r7
L459:
	mov	#0,r7
L460:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L465
	mov	#1,r6
L464:
	mov	#0,r6
L465:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L461
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L466
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L467
	mov.l	r1,@(16,r15)
	.align 2
L553:	.short	-2
L466:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L467:
L461:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L468
	mov.l	@(16,r15),r1
	mov.w	L555,r2
	cmp/ge	r2,r1
	bt	L470
	mov.w	L555,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L470:
	mov.w	L556,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L472
	mov.w	L556,r1
	mov.l	r1,@(16,r15)
	mov.w	L557,r1
	mov.l	r1,@(8,r15)
L472:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L468:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(40,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L474
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L474:
	mov.l	@(40,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L476
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L476:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L478
	add	r1,r5
	mov.l	L554,r6
L478:
	mov.l	@(4,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L482
	mov	#1,r7
L481:
	mov	#0,r7
L482:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L487
	mov	#1,r6
L486:
	mov	#0,r6
L487:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L483
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L488
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L489
	mov.l	r1,@(12,r15)
	.align 2
L555:	.short	-32768
L556:	.short	32767
L557:	.short	-1
	.align 2
L554:	.long	65536
L488:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L489:
L483:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L490
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L494
	mov	#1,r7
L493:
	mov	#0,r7
L494:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L561,r2
	cmp/ge	r2,r1
	bt	L495
	mov.w	L561,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L495:
	mov.w	L562,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L497
	mov.w	L562,r1
	mov.l	r1,@(16,r15)
	mov.w	L563,r1
	mov.l	r1,@(0,r15)
L497:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L491
	mov.l	r1,@(16,r15)
	.align 2
L561:	.short	-32768
L562:	.short	32767
L563:	.short	-1
L490:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L501
	mov	#1,r7
L500:
	mov	#0,r7
L501:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L491:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L502
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L502:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L504
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L504:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L506
	add	r1,r5
	mov.l	L560,r6
L506:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L510
	mov	#1,r7
L509:
	mov	#0,r7
L510:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L515
	mov	#1,r6
L514:
	mov	#0,r6
L515:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L511
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L516
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L517
	mov.l	r1,@(12,r15)
L516:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L517:
L511:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L518
	mov.l	@(12,r15),r1
	mov.w	L564,r2
	cmp/ge	r2,r1
	bt	L520
	mov.w	L564,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L520:
	mov.w	L565,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L522
	mov.w	L565,r1
	mov.l	r1,@(12,r15)
	mov.w	L566,r1
	mov.l	r1,@(4,r15)
L522:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L518:
	mov	r4,r1
	add	#4,r1
	mov.l	@(16,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L524
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L524:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L526
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L526:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L528
	add	r1,r5
	mov.l	L560,r6
L528:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L532
	mov	#1,r7
L531:
	mov	#0,r7
L532:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L537
	mov	#1,r6
L536:
	mov	#0,r6
L537:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L533
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L538
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L539
	mov.l	r1,@(16,r15)
L538:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L539:
L533:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L540
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L544
	mov	#1,r7
L543:
	mov	#0,r7
L544:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L567,r2
	cmp/ge	r2,r1
	bt	L545
	mov.w	L567,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L545:
	mov.w	L568,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L547
	mov.w	L568,r1
	mov.l	r1,@(16,r15)
	mov.w	L569,r1
	mov.l	r1,@(0,r15)
L547:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L558,r3
	and	r3,r2
	or	r2,r1
	bra	L541
	mov.l	r1,@(12,r15)
L540:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L551
	mov	#1,r7
L550:
	mov	#0,r7
L551:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L541:
	add	#-1,r8
	mov	r4,r1
	add	#8,r1
	mov.l	@(12,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L559,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r8,r8
	bf	L449
L446:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L558:	.short	-65536
L564:	.short	-32768
L565:	.short	32767
L566:	.short	-1
L567:	.short	-32768
L568:	.short	32767
L569:	.short	-1
	.align 2
L559:	.long	_PTR_DAT_06045074
L560:	.long	65536
	.global _FUN_06045008
	.align 2
_FUN_06045008:
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r1
	add	#8,r1
	mov.l	L676,r2
	mov.l	@r2,r2
	mov	r1,r8
	and	r2,r8
	tst	r8,r8
	bf	L571
	mov.l	L676,r1
	mov.l	@r1,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L676:	.short	-65536
L571:
	mov.l	L677,r1
	mov.l	@r1,r1
	mov	r8,r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r8
	mov	#3,r9
L573:
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L576
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L576:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L578
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L578:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L580
	add	r1,r7
	mov.l	L678,r6
L580:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L584
	mov	#1,r7
L583:
	mov	#0,r7
L584:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L589
	mov	#1,r6
L588:
	mov	#0,r6
L589:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L585
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L590
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L591
	mov.l	r1,@(16,r15)
	.align 2
L677:	.short	-2
L590:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L591:
L585:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L592
	mov.l	@(16,r15),r1
	mov.w	L679,r2
	cmp/ge	r2,r1
	bt	L594
	mov.w	L679,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L594:
	mov.w	L680,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L596
	mov.w	L680,r1
	mov.l	r1,@(16,r15)
	mov.w	L681,r1
	mov.l	r1,@(8,r15)
L596:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L592:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r8,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L598
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L598:
	mov	r8,r7
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L600
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L600:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L602
	add	r1,r12
	mov.l	L678,r6
L602:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L606
	mov	#1,r7
L605:
	mov	#0,r7
L606:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L611
	mov	#1,r6
L610:
	mov	#0,r6
L611:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L607
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L612
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L613
	mov.l	r1,@(12,r15)
	.align 2
L679:	.short	-32768
L680:	.short	32767
L681:	.short	-1
	.align 2
L678:	.long	65536
L612:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L613:
L607:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L614
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L618
	mov	#1,r7
L617:
	mov	#0,r7
L618:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L685,r2
	cmp/ge	r2,r1
	bt	L619
	mov.w	L685,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L619:
	mov.w	L686,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L621
	mov.w	L686,r1
	mov.l	r1,@(16,r15)
	mov.w	L687,r1
	mov.l	r1,@(0,r15)
L621:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L615
	mov.l	r1,@(16,r15)
	.align 2
L685:	.short	-32768
L686:	.short	32767
L687:	.short	-1
L614:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L625
	mov	#1,r7
L624:
	mov	#0,r7
L625:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L615:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L626
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L626:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L628
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L628:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L630
	add	r1,r12
	mov.l	L684,r6
L630:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L634
	mov	#1,r7
L633:
	mov	#0,r7
L634:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L639
	mov	#1,r6
L638:
	mov	#0,r6
L639:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L635
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L640
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L641
	mov.l	r1,@(12,r15)
L640:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L641:
L635:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L642
	mov.l	@(12,r15),r1
	mov.w	L688,r2
	cmp/ge	r2,r1
	bt	L644
	mov.w	L688,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L644:
	mov.w	L689,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L646
	mov.w	L689,r1
	mov.l	r1,@(12,r15)
	mov.w	L690,r1
	mov.l	r1,@(4,r15)
L646:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L642:
	mov	r4,r1
	add	#4,r1
	mov.l	@(16,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L648
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L648:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L650
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L650:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L652
	add	r1,r12
	mov.l	L684,r6
L652:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L656
	mov	#1,r7
L655:
	mov	#0,r7
L656:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L661
	mov	#1,r6
L660:
	mov	#0,r6
L661:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L657
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L662
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L663
	mov.l	r1,@(16,r15)
L662:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L663:
L657:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L664
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L668
	mov	#1,r7
L667:
	mov	#0,r7
L668:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L691,r2
	cmp/ge	r2,r1
	bt	L669
	mov.w	L691,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L669:
	mov.w	L692,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L671
	mov.w	L692,r1
	mov.l	r1,@(16,r15)
	mov.w	L693,r1
	mov.l	r1,@(0,r15)
L671:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L682,r3
	and	r3,r2
	or	r2,r1
	bra	L665
	mov.l	r1,@(12,r15)
L664:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L675
	mov	#1,r7
L674:
	mov	#0,r7
L675:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L665:
	add	#-1,r9
	mov	r4,r1
	add	#8,r1
	mov.l	@(12,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L683,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r9,r9
	bf	L573
L570:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L682:	.short	-65536
L688:	.short	-32768
L689:	.short	32767
L690:	.short	-1
L691:	.short	-32768
L692:	.short	32767
L693:	.short	-1
	.align 2
L683:	.long	_PTR_DAT_06045074
L684:	.long	65536
	.global _FUN_06045020
	.align 2
_FUN_06045020:
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r1
	mov	r1,r9
	add	#1,r9
	mov	#3,r8
L695:
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r2
	xor	r6,r2
	mov.l	r2,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L698
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L698:
	mov	r6,r10
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L700
	not	r6,r1
	mov	r1,r10
	add	#1,r10
L700:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L702
	add	r1,r7
	mov.l	L798,r13
L702:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L706
	mov	#1,r7
L705:
	mov	#0,r7
L706:
	mov	r13,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L711
	mov	#1,r13
L710:
	mov	#0,r13
L711:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L707
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L712
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L713
	mov.l	r1,@(16,r15)
	.align 2
L798:	.short	65536
L712:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L713:
L707:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L714
	mov.l	@(16,r15),r1
	mov.w	L799,r2
	cmp/ge	r2,r1
	bt	L716
	mov.w	L799,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L716:
	mov.w	L800,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L718
	mov.w	L800,r1
	mov.l	r1,@(16,r15)
	mov.w	L801,r1
	mov.l	r1,@(8,r15)
L718:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L714:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r9,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L720
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L720:
	mov	r9,r7
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L722
	mov	r5,r7
L722:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L724
	add	r1,r12
	mov.l	L803,r13
L724:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L728
	mov	#1,r7
L727:
	mov	#0,r7
L728:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L733
	mov	#1,r13
L732:
	mov	#0,r13
L733:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L729
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L734
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L735
	mov.l	r1,@(12,r15)
	.align 2
L799:	.short	-32768
L800:	.short	32767
L801:	.short	-1
L803:	.short	65536
L734:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L735:
L729:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L736
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L740
	mov	#1,r7
L739:
	mov	#0,r7
L740:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L804,r2
	cmp/ge	r2,r1
	bt	L741
	mov.w	L804,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L741:
	mov.w	L805,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L743
	mov.w	L805,r1
	mov.l	r1,@(16,r15)
	mov.w	L806,r1
	mov.l	r1,@(0,r15)
L743:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L737
	mov.l	r1,@(16,r15)
	.align 2
L804:	.short	-32768
L805:	.short	32767
L806:	.short	-1
L736:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L747
	mov	#1,r7
L746:
	mov	#0,r7
L747:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L737:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r5,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L748
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L748:
	mov	r5,r7
	mov	r5,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L750
	not	r5,r1
	mov	r1,r7
	add	#1,r7
L750:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L752
	add	r1,r12
	mov.l	L807,r13
L752:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L756
	mov	#1,r7
L755:
	mov	#0,r7
L756:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L761
	mov	#1,r13
L760:
	mov	#0,r13
L761:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L757
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L762
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L763
	mov.l	r1,@(12,r15)
	.align 2
L807:	.short	65536
L762:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L763:
L757:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L764
	mov.l	@(12,r15),r1
	mov.w	L808,r2
	cmp/ge	r2,r1
	bt	L766
	mov.w	L808,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L766:
	mov.w	L809,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L768
	mov.w	L809,r1
	mov.l	r1,@(12,r15)
	mov.w	L810,r1
	mov.l	r1,@(4,r15)
L768:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L764:
	mov	r4,r1
	add	#4,r1
	mov.l	@(16,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r10
	xor	r6,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L770
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L770:
	mov	r6,r7
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L772
	not	r6,r1
	mov	r1,r7
	add	#1,r7
L772:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L774
	add	r1,r12
	mov.l	L811,r13
L774:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L778
	mov	#1,r7
L777:
	mov	#0,r7
L778:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L783
	mov	#1,r13
L782:
	mov	#0,r13
L783:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L779
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L784
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L785
	mov.l	r1,@(16,r15)
L784:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L785:
L779:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L786
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L790
	mov	#1,r7
L789:
	mov	#0,r7
L790:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L812,r2
	cmp/ge	r2,r1
	bt	L791
	mov.w	L812,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L791:
	mov.w	L813,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L793
	mov.w	L813,r1
	mov.l	r1,@(12,r15)
	mov.w	L814,r1
	mov.l	r1,@(0,r15)
L793:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L787
	mov.l	r1,@(12,r15)
L786:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L797
	mov	#1,r7
L796:
	mov	#0,r7
L797:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L787:
	add	#-1,r8
	mov.l	@(20,r15),r1
	mov.w	L802,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	mov	r4,r1
	add	#8,r1
	mov.l	@(12,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	add	#16,r4
	tst	r8,r8
	bf	L695
	add	#24,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L802:	.short	-2
L808:	.short	-32768
L809:	.short	32767
L810:	.short	-1
L811:	.short	65536
L812:	.short	-32768
L813:	.short	32767
L814:	.short	-1
	.global _FUN_0604507e
	.align 2
_FUN_0604507e:
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r1
	add	#8,r1
	mov.l	L921,r2
	mov.l	@r2,r2
	and	r2,r1
	mov.l	r1,@(40,r15)
	mov.l	@(40,r15),r1
	tst	r1,r1
	bf	L816
	mov.l	L921,r1
	mov.l	@r1,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L921:	.short	-2
L816:
	mov.l	L922,r1
	mov.l	@r1,r1
	mov.l	@(40,r15),r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov.l	r1,@(40,r15)
	mov	#3,r8
L818:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L821
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L821:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L823
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L823:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r5
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L825
	add	r1,r7
	mov.l	L923,r6
L825:
	mov	r7,r1
	shll16	r1
	mov	r5,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r5,r1
	bf/s	L829
	mov	#1,r7
L828:
	mov	#0,r7
L829:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L834
	mov	#1,r6
L833:
	mov	#0,r6
L834:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L830
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L835
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L836
	mov.l	r1,@(16,r15)
	.align 2
L922:	.short	-32768
L923:	.short	65536
L835:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L836:
L830:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L837
	mov.l	@(16,r15),r1
	mov.w	L928,r2
	cmp/ge	r2,r1
	bt	L839
	mov.w	L928,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L839:
	mov.w	L924,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L841
	mov.w	L924,r1
	mov.l	r1,@(16,r15)
	mov.w	L925,r1
	mov.l	r1,@(8,r15)
L841:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L837:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L843
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L843:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L845
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L845:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L847
	add	r1,r5
	mov.l	L929,r6
L847:
	mov.l	@(4,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L851
	mov	#1,r7
L850:
	mov	#0,r7
L851:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L856
	mov	#1,r6
L855:
	mov	#0,r6
L856:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L852
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L857
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L858
	mov.l	r1,@(12,r15)
	.align 2
L924:	.short	32767
L925:	.short	-1
L928:	.short	-32768
L929:	.short	65536
L857:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L858:
L852:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L859
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L863
	mov	#1,r7
L862:
	mov	#0,r7
L863:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L932,r2
	cmp/ge	r2,r1
	bt	L864
	mov.w	L932,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L864:
	mov.w	L930,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L866
	mov.w	L930,r1
	mov.l	r1,@(16,r15)
	mov.w	L931,r1
	mov.l	r1,@(0,r15)
L866:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L860
	mov.l	r1,@(16,r15)
	.align 2
L930:	.short	32767
L931:	.short	-1
L932:	.short	-32768
L859:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L870
	mov	#1,r7
L869:
	mov	#0,r7
L870:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L860:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(40,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L871
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L871:
	mov.l	@(40,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L873
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L873:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L875
	add	r1,r5
	mov.l	L933,r6
L875:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L879
	mov	#1,r7
L878:
	mov	#0,r7
L879:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L884
	mov	#1,r6
L883:
	mov	#0,r6
L884:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L880
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L885
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L886
	mov.l	r1,@(12,r15)
	.align 2
L933:	.short	65536
L885:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L886:
L880:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L887
	mov.l	@(12,r15),r1
	mov.w	L936,r2
	cmp/ge	r2,r1
	bt	L889
	mov.w	L936,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L889:
	mov.w	L934,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L891
	mov.w	L934,r1
	mov.l	r1,@(12,r15)
	mov.w	L935,r1
	mov.l	r1,@(4,r15)
L891:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L887:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L893
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L893:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L895
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L895:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L897
	add	r1,r5
	mov.l	L937,r6
L897:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L901
	mov	#1,r7
L900:
	mov	#0,r7
L901:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L906
	mov	#1,r6
L905:
	mov	#0,r6
L906:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L902
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L907
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L908
	mov.l	r1,@(16,r15)
L907:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L908:
L902:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L909
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L913
	mov	#1,r7
L912:
	mov	#0,r7
L913:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L940,r2
	cmp/ge	r2,r1
	bt	L914
	mov.w	L940,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L914:
	mov.w	L938,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L916
	mov.w	L938,r1
	mov.l	r1,@(16,r15)
	mov.w	L939,r1
	mov.l	r1,@(0,r15)
L916:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L926,r3
	and	r3,r2
	or	r2,r1
	bra	L910
	mov.l	r1,@(12,r15)
L909:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L920
	mov	#1,r7
L919:
	mov	#0,r7
L920:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L910:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(8,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L927,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r8,r8
	bf	L818
L815:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L926:	.short	-65536
L934:	.short	32767
L935:	.short	-1
L937:	.short	65536
L938:	.short	32767
L939:	.short	-1
L927:	.long	_DAT_060450e4
L936:	.long	_PTR_DAT_060450e8
L940:	.long	_PTR_DAT_060450e8
	.global _FUN_06045080
	.align 2
_FUN_06045080:
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r1
	add	#8,r1
	mov.l	L1047,r2
	mov.l	@r2,r2
	mov	r1,r8
	and	r2,r8
	tst	r8,r8
	bf	L942
	mov.l	L1047,r1
	mov.l	@r1,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1047:	.short	-65536
L942:
	mov.l	L1048,r1
	mov.l	@r1,r1
	mov	r8,r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r8
	mov	#3,r9
L944:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L947
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L947:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L949
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L949:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L951
	add	r1,r7
	mov.l	L1049,r6
L951:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L955
	mov	#1,r7
L954:
	mov	#0,r7
L955:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L960
	mov	#1,r6
L959:
	mov	#0,r6
L960:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L956
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L961
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L962
	mov.l	r1,@(16,r15)
	.align 2
L1048:	.short	-2
L1049:	.short	65536
L961:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L962:
L956:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L963
	mov.l	@(16,r15),r1
	mov.w	L1050,r2
	cmp/ge	r2,r1
	bt	L965
	mov.w	L1050,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L965:
	mov.w	L1051,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L967
	mov.w	L1051,r1
	mov.l	r1,@(16,r15)
	mov.w	L1052,r1
	mov.l	r1,@(8,r15)
L967:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L963:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L969
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L969:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L971
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L971:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L973
	add	r1,r12
	mov.l	L1055,r6
L973:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L977
	mov	#1,r7
L976:
	mov	#0,r7
L977:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L982
	mov	#1,r6
L981:
	mov	#0,r6
L982:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L978
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L983
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L984
	mov.l	r1,@(12,r15)
	.align 2
L1050:	.short	-32768
L1051:	.short	32767
L1052:	.short	-1
L1055:	.short	65536
L983:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L984:
L978:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L985
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L989
	mov	#1,r7
L988:
	mov	#0,r7
L989:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1056,r2
	cmp/ge	r2,r1
	bt	L990
	mov.w	L1056,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L990:
	mov.w	L1057,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L992
	mov.w	L1057,r1
	mov.l	r1,@(16,r15)
	mov.w	L1058,r1
	mov.l	r1,@(0,r15)
L992:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L986
	mov.l	r1,@(16,r15)
	.align 2
L1056:	.short	-32768
L1057:	.short	32767
L1058:	.short	-1
L985:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L996
	mov	#1,r7
L995:
	mov	#0,r7
L996:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L986:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r8,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L997
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L997:
	mov	r8,r7
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L999
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L999:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1001
	add	r1,r12
	mov.l	L1059,r6
L1001:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1005
	mov	#1,r7
L1004:
	mov	#0,r7
L1005:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1010
	mov	#1,r6
L1009:
	mov	#0,r6
L1010:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1006
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1011
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1012
	mov.l	r1,@(12,r15)
	.align 2
L1059:	.short	65536
L1011:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1012:
L1006:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1013
	mov.l	@(12,r15),r1
	mov.w	L1060,r2
	cmp/ge	r2,r1
	bt	L1015
	mov.w	L1060,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1015:
	mov.w	L1061,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1017
	mov.w	L1061,r1
	mov.l	r1,@(12,r15)
	mov.w	L1062,r1
	mov.l	r1,@(4,r15)
L1017:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1013:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1019
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1019:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1021
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L1021:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1023
	add	r1,r12
	mov.l	L1063,r6
L1023:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1027
	mov	#1,r7
L1026:
	mov	#0,r7
L1027:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1032
	mov	#1,r6
L1031:
	mov	#0,r6
L1032:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1028
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1033
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1034
	mov.l	r1,@(16,r15)
L1033:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1034:
L1028:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1035
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1039
	mov	#1,r7
L1038:
	mov	#0,r7
L1039:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1064,r2
	cmp/ge	r2,r1
	bt	L1040
	mov.w	L1064,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1040:
	mov.w	L1065,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1042
	mov.w	L1065,r1
	mov.l	r1,@(16,r15)
	mov.w	L1066,r1
	mov.l	r1,@(0,r15)
L1042:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L1053,r3
	and	r3,r2
	or	r2,r1
	bra	L1036
	mov.l	r1,@(12,r15)
L1035:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1046
	mov	#1,r7
L1045:
	mov	#0,r7
L1046:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1036:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(8,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L1054,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r9,r9
	bf	L944
L941:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L1053:	.short	-65536
L1060:	.short	-32768
L1061:	.short	32767
L1062:	.short	-1
L1063:	.short	65536
L1064:	.short	-32768
L1065:	.short	32767
L1066:	.short	-1
L1054:	.long	_PTR_DAT_060450e8
	.global _FUN_06045098
	.align 2
_FUN_06045098:
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r1
	mov	r1,r9
	add	#1,r9
	mov	#3,r8
L1068:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r2
	xor	r6,r2
	mov.l	r2,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1071
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1071:
	mov	r6,r10
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1073
	not	r6,r1
	mov	r1,r10
	add	#1,r10
L1073:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L1075
	add	r1,r7
	mov.l	L1171,r13
L1075:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L1079
	mov	#1,r7
L1078:
	mov	#0,r7
L1079:
	mov	r13,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1084
	mov	#1,r13
L1083:
	mov	#0,r13
L1084:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1080
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1085
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1086
	mov.l	r1,@(16,r15)
	.align 2
L1171:	.short	65536
L1085:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1086:
L1080:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1087
	mov.l	@(16,r15),r1
	mov.w	L1172,r2
	cmp/ge	r2,r1
	bt	L1089
	mov.w	L1172,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1089:
	mov.w	L1173,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1091
	mov.w	L1173,r1
	mov.l	r1,@(16,r15)
	mov.w	L1174,r1
	mov.l	r1,@(8,r15)
L1091:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1087:
	mov.l	@(8,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r5,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1093
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1093:
	mov	r5,r7
	mov	r5,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1095
	not	r5,r1
	mov	r1,r7
	add	#1,r7
L1095:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1097
	add	r1,r12
	mov.l	L1176,r13
L1097:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1101
	mov	#1,r7
L1100:
	mov	#0,r7
L1101:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1106
	mov	#1,r13
L1105:
	mov	#0,r13
L1106:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1102
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1107
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1108
	mov.l	r1,@(12,r15)
	.align 2
L1172:	.short	-32768
L1173:	.short	32767
L1174:	.short	-1
L1176:	.short	65536
L1107:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1108:
L1102:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1109
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1113
	mov	#1,r7
L1112:
	mov	#0,r7
L1113:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1177,r2
	cmp/ge	r2,r1
	bt	L1114
	mov.w	L1177,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1114:
	mov.w	L1178,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1116
	mov.w	L1178,r1
	mov.l	r1,@(16,r15)
	mov.w	L1179,r1
	mov.l	r1,@(0,r15)
L1116:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1110
	mov.l	r1,@(16,r15)
	.align 2
L1177:	.short	-32768
L1178:	.short	32767
L1179:	.short	-1
L1109:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1120
	mov	#1,r7
L1119:
	mov	#0,r7
L1120:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1110:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r9,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1121
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1121:
	mov	r9,r7
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1123
	mov	r5,r7
L1123:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1125
	add	r1,r12
	mov.l	L1180,r13
L1125:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1129
	mov	#1,r7
L1128:
	mov	#0,r7
L1129:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1134
	mov	#1,r13
L1133:
	mov	#0,r13
L1134:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1130
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1135
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1136
	mov.l	r1,@(12,r15)
	.align 2
L1180:	.short	65536
L1135:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1136:
L1130:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1137
	mov.l	@(12,r15),r1
	mov.w	L1181,r2
	cmp/ge	r2,r1
	bt	L1139
	mov.w	L1181,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1139:
	mov.w	L1182,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1141
	mov.w	L1182,r1
	mov.l	r1,@(12,r15)
	mov.w	L1183,r1
	mov.l	r1,@(4,r15)
L1141:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1137:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(8,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r10
	xor	r6,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1143
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1143:
	mov	r6,r7
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1145
	not	r6,r1
	mov	r1,r7
	add	#1,r7
L1145:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1147
	add	r1,r12
	mov.l	L1184,r13
L1147:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1151
	mov	#1,r7
L1150:
	mov	#0,r7
L1151:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1156
	mov	#1,r13
L1155:
	mov	#0,r13
L1156:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1152
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1157
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1158
	mov.l	r1,@(16,r15)
L1157:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1158:
L1152:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1159
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1163
	mov	#1,r7
L1162:
	mov	#0,r7
L1163:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L1185,r2
	cmp/ge	r2,r1
	bt	L1164
	mov.w	L1185,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1164:
	mov.w	L1186,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1166
	mov.w	L1186,r1
	mov.l	r1,@(12,r15)
	mov.w	L1187,r1
	mov.l	r1,@(0,r15)
L1166:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L1160
	mov.l	r1,@(12,r15)
L1159:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1170
	mov	#1,r7
L1169:
	mov	#0,r7
L1170:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1160:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(8,r4)
	add	#-1,r8
	mov.l	@(20,r15),r1
	mov.w	L1175,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L1068
	add	#24,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1175:	.short	-2
L1181:	.short	-32768
L1182:	.short	32767
L1183:	.short	-1
L1184:	.short	65536
L1185:	.short	-32768
L1186:	.short	32767
L1187:	.short	-1
	.global _FUN_060450f2
	.align 2
_FUN_060450f2:
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r1
	add	#8,r1
	mov.l	L1294,r2
	mov.l	@r2,r2
	and	r2,r1
	mov.l	r1,@(40,r15)
	mov.l	@(40,r15),r1
	tst	r1,r1
	bf	L1189
	mov.l	L1294,r1
	mov.l	@r1,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1294:	.short	-2
L1189:
	mov.l	L1295,r1
	mov.l	@r1,r1
	mov.l	@(40,r15),r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov.l	r1,@(40,r15)
	mov	#3,r8
L1191:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1194
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1194:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1196
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L1196:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r5
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L1198
	add	r1,r7
	mov.l	L1296,r6
L1198:
	mov	r7,r1
	shll16	r1
	mov	r5,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r5,r1
	bf/s	L1202
	mov	#1,r7
L1201:
	mov	#0,r7
L1202:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1207
	mov	#1,r6
L1206:
	mov	#0,r6
L1207:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1203
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1208
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1209
	mov.l	r1,@(16,r15)
	.align 2
L1295:	.short	-32768
L1296:	.short	65536
L1208:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1209:
L1203:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1210
	mov.l	@(16,r15),r1
	mov.w	L1301,r2
	cmp/ge	r2,r1
	bt	L1212
	mov.w	L1301,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1212:
	mov.w	L1297,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1214
	mov.w	L1297,r1
	mov.l	r1,@(16,r15)
	mov.w	L1298,r1
	mov.l	r1,@(8,r15)
L1214:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1210:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(40,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1216
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1216:
	mov.l	@(40,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1218
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L1218:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L1220
	add	r1,r5
	mov.l	L1302,r6
L1220:
	mov.l	@(4,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1224
	mov	#1,r7
L1223:
	mov	#0,r7
L1224:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1229
	mov	#1,r6
L1228:
	mov	#0,r6
L1229:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1225
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1230
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1231
	mov.l	r1,@(12,r15)
	.align 2
L1297:	.short	32767
L1298:	.short	-1
L1301:	.short	-32768
L1302:	.short	65536
L1230:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1231:
L1225:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1232
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1236
	mov	#1,r7
L1235:
	mov	#0,r7
L1236:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1305,r2
	cmp/ge	r2,r1
	bt	L1237
	mov.w	L1305,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1237:
	mov.w	L1303,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1239
	mov.w	L1303,r1
	mov.l	r1,@(16,r15)
	mov.w	L1304,r1
	mov.l	r1,@(0,r15)
L1239:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1233
	mov.l	r1,@(16,r15)
	.align 2
L1303:	.short	32767
L1304:	.short	-1
L1305:	.short	-32768
L1232:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1243
	mov	#1,r7
L1242:
	mov	#0,r7
L1243:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1233:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1244
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1244:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1246
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L1246:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L1248
	add	r1,r5
	mov.l	L1306,r6
L1248:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1252
	mov	#1,r7
L1251:
	mov	#0,r7
L1252:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1257
	mov	#1,r6
L1256:
	mov	#0,r6
L1257:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1253
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1258
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1259
	mov.l	r1,@(12,r15)
	.align 2
L1306:	.short	65536
L1258:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1259:
L1253:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1260
	mov.l	@(12,r15),r1
	mov.w	L1309,r2
	cmp/ge	r2,r1
	bt	L1262
	mov.w	L1309,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1262:
	mov.w	L1307,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1264
	mov.w	L1307,r1
	mov.l	r1,@(12,r15)
	mov.w	L1308,r1
	mov.l	r1,@(4,r15)
L1264:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1260:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1266
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1266:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1268
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L1268:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r5
	tst	r11,r11
	bt/s	L1270
	add	r1,r5
	mov.l	L1310,r6
L1270:
	mov.l	@(8,r15),r1
	mov	r5,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1274
	mov	#1,r7
L1273:
	mov	#0,r7
L1274:
	mov	r6,r1
	add	r7,r1
	mov	r5,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1279
	mov	#1,r6
L1278:
	mov	#0,r6
L1279:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1275
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1280
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1281
	mov.l	r1,@(16,r15)
L1280:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1281:
L1275:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1282
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1286
	mov	#1,r7
L1285:
	mov	#0,r7
L1286:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1313,r2
	cmp/ge	r2,r1
	bt	L1287
	mov.w	L1313,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1287:
	mov.w	L1311,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1289
	mov.w	L1311,r1
	mov.l	r1,@(16,r15)
	mov.w	L1312,r1
	mov.l	r1,@(0,r15)
L1289:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L1299,r3
	and	r3,r2
	or	r2,r1
	bra	L1283
	mov.l	r1,@(12,r15)
L1282:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1293
	mov	#1,r7
L1292:
	mov	#0,r7
L1293:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1283:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(4,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L1300,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r8,r8
	bf	L1191
L1188:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L1299:	.short	-65536
L1307:	.short	32767
L1308:	.short	-1
L1310:	.short	65536
L1311:	.short	32767
L1312:	.short	-1
L1300:	.long	_DAT_0604514c
L1309:	.long	_PTR_DAT_06045150
L1313:	.long	_PTR_DAT_06045150
	.global _FUN_060450f4
	.align 2
_FUN_060450f4:
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r1
	add	#8,r1
	mov.l	L1420,r2
	mov.l	@r2,r2
	mov	r1,r8
	and	r2,r8
	tst	r8,r8
	bf	L1315
	mov.l	L1420,r1
	mov.l	@r1,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1420:	.short	-65536
L1315:
	mov.l	L1421,r1
	mov.l	@r1,r1
	mov	r8,r2
	shlr2	r2
	add	r2,r1
	mov	r1,r2
	mov.w	@r2,r2
	mov.l	r2,@(36,r15)
	add	#2,r1
	mov.w	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(36,r15),r1
	mov	r1,r2
	shll2	r2
	mov.l	r2,@(32,r15)
	mov.l	@(28,r15),r2
	shll2	r2
	mov.l	r2,@(24,r15)
	mov	#-4,r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r8
	mov	#3,r9
L1317:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1320
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1320:
	mov.l	@(24,r15),r1
	mov	r1,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1322
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r10
L1322:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L1324
	add	r1,r7
	mov.l	L1422,r6
L1324:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L1328
	mov	#1,r7
L1327:
	mov	#0,r7
L1328:
	mov	r6,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1333
	mov	#1,r6
L1332:
	mov	#0,r6
L1333:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1329
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1334
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1335
	mov.l	r1,@(16,r15)
	.align 2
L1421:	.short	-2
L1422:	.short	65536
L1334:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1335:
L1329:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1336
	mov.l	@(16,r15),r1
	mov.w	L1423,r2
	cmp/ge	r2,r1
	bt	L1338
	mov.w	L1423,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1338:
	mov.w	L1424,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1340
	mov.w	L1424,r1
	mov.l	r1,@(16,r15)
	mov.w	L1425,r1
	mov.l	r1,@(8,r15)
L1340:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1336:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r8,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1342
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1342:
	mov	r8,r7
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1344
	mov.l	@(36,r15),r1
	shll2	r1
	mov	r1,r7
L1344:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1346
	add	r1,r12
	mov.l	L1428,r6
L1346:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1350
	mov	#1,r7
L1349:
	mov	#0,r7
L1350:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1355
	mov	#1,r6
L1354:
	mov	#0,r6
L1355:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1351
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1356
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1357
	mov.l	r1,@(12,r15)
	.align 2
L1423:	.short	-32768
L1424:	.short	32767
L1425:	.short	-1
L1428:	.short	65536
L1356:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1357:
L1351:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1358
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1362
	mov	#1,r7
L1361:
	mov	#0,r7
L1362:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1429,r2
	cmp/ge	r2,r1
	bt	L1363
	mov.w	L1429,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1363:
	mov.w	L1430,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1365
	mov.w	L1430,r1
	mov.l	r1,@(16,r15)
	mov.w	L1431,r1
	mov.l	r1,@(0,r15)
L1365:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1359
	mov.l	r1,@(16,r15)
	.align 2
L1429:	.short	-32768
L1430:	.short	32767
L1431:	.short	-1
L1358:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1369
	mov	#1,r7
L1368:
	mov	#0,r7
L1369:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1359:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1370
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1370:
	mov.l	@(32,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1372
	mov	#-4,r1
	mov.l	@(36,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L1372:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1374
	add	r1,r12
	mov.l	L1432,r6
L1374:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1378
	mov	#1,r7
L1377:
	mov	#0,r7
L1378:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1383
	mov	#1,r6
L1382:
	mov	#0,r6
L1383:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1379
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1384
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1385
	mov.l	r1,@(12,r15)
	.align 2
L1432:	.short	65536
L1384:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1385:
L1379:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1386
	mov.l	@(12,r15),r1
	mov.w	L1433,r2
	cmp/ge	r2,r1
	bt	L1388
	mov.w	L1433,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1388:
	mov.w	L1434,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1390
	mov.w	L1434,r1
	mov.l	r1,@(12,r15)
	mov.w	L1435,r1
	mov.l	r1,@(4,r15)
L1390:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1386:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(24,r15),r2
	mov	r1,r10
	xor	r2,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1392
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1392:
	mov.l	@(24,r15),r1
	mov	r1,r7
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1394
	mov	#-4,r1
	mov.l	@(28,r15),r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r1,r7
L1394:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r6
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1396
	add	r1,r12
	mov.l	L1436,r6
L1396:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1400
	mov	#1,r7
L1399:
	mov	#0,r7
L1400:
	mov	r6,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1405
	mov	#1,r6
L1404:
	mov	#0,r6
L1405:
	mov	r6,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1401
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1406
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1407
	mov.l	r1,@(16,r15)
L1406:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1407:
L1401:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1408
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1412
	mov	#1,r7
L1411:
	mov	#0,r7
L1412:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1437,r2
	cmp/ge	r2,r1
	bt	L1413
	mov.w	L1437,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1413:
	mov.w	L1438,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1415
	mov.w	L1438,r1
	mov.l	r1,@(16,r15)
	mov.w	L1439,r1
	mov.l	r1,@(0,r15)
L1415:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	@(12,r15),r2
	mov.l	L1426,r3
	and	r3,r2
	or	r2,r1
	bra	L1409
	mov.l	r1,@(12,r15)
L1408:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1419
	mov	#1,r7
L1418:
	mov	#0,r7
L1419:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1409:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(4,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r1
	mov.w	L1427,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	tst	r9,r9
	bf	L1317
L1314:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(12,r15),r0
	.align 2
L1426:	.short	-65536
L1433:	.short	-32768
L1434:	.short	32767
L1435:	.short	-1
L1436:	.short	65536
L1437:	.short	-32768
L1438:	.short	32767
L1439:	.short	-1
L1427:	.long	_PTR_DAT_06045150
	.global _FUN_0604510c
	.align 2
_FUN_0604510c:
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r1
	mov	r1,r9
	add	#1,r9
	mov	#3,r8
L1441:
	mov.l	@r4,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r2
	xor	r6,r2
	mov.l	r2,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1444
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1444:
	mov	r6,r10
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1446
	not	r6,r1
	mov	r1,r10
	add	#1,r10
L1446:
	extu.w	r10,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r12
	mov	r10,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r7
	tst	r11,r11
	bt/s	L1448
	add	r1,r7
	mov.l	L1544,r13
L1448:
	mov	r7,r1
	shll16	r1
	mov	r12,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r12,r1
	bf/s	L1452
	mov	#1,r7
L1451:
	mov	#0,r7
L1452:
	mov	r13,r1
	add	r7,r1
	mov	r7,r2
	shlr16	r2
	add	r2,r1
	mov	r10,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1457
	mov	#1,r13
L1456:
	mov	#0,r13
L1457:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1453
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1458
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1459
	mov.l	r1,@(16,r15)
	.align 2
L1544:	.short	65536
L1458:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1459:
L1453:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1460
	mov.l	@(16,r15),r1
	mov.w	L1545,r2
	cmp/ge	r2,r1
	bt	L1462
	mov.w	L1545,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1462:
	mov.w	L1546,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1464
	mov.w	L1546,r1
	mov.l	r1,@(16,r15)
	mov.w	L1547,r1
	mov.l	r1,@(8,r15)
L1464:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1460:
	mov.l	@(4,r4),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r9,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1466
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1466:
	mov	r9,r7
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1468
	mov	r5,r7
L1468:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1470
	add	r1,r12
	mov.l	L1549,r13
L1470:
	mov.l	@(4,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1474
	mov	#1,r7
L1473:
	mov	#0,r7
L1474:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1479
	mov	#1,r13
L1478:
	mov	#0,r13
L1479:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1475
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1480
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1481
	mov.l	r1,@(12,r15)
	.align 2
L1545:	.short	-32768
L1546:	.short	32767
L1547:	.short	-1
L1549:	.short	65536
L1480:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1481:
L1475:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1482
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1486
	mov	#1,r7
L1485:
	mov	#0,r7
L1486:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1550,r2
	cmp/ge	r2,r1
	bt	L1487
	mov.w	L1550,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1487:
	mov.w	L1551,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1489
	mov.w	L1551,r1
	mov.l	r1,@(16,r15)
	mov.w	L1552,r1
	mov.l	r1,@(0,r15)
L1489:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1483
	mov.l	r1,@(16,r15)
	.align 2
L1550:	.short	-32768
L1551:	.short	32767
L1552:	.short	-1
L1482:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1493
	mov	#1,r7
L1492:
	mov	#0,r7
L1493:
	mov.l	@(12,r15),r1
	add	r7,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1483:
	mov.l	@r4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r10
	xor	r5,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1494
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1494:
	mov	r5,r7
	mov	r5,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1496
	not	r5,r1
	mov	r1,r7
	add	#1,r7
L1496:
	extu.w	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1498
	add	r1,r12
	mov.l	L1553,r13
L1498:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1502
	mov	#1,r7
L1501:
	mov	#0,r7
L1502:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1507
	mov	#1,r13
L1506:
	mov	#0,r13
L1507:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1503
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1508
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1509
	mov.l	r1,@(12,r15)
	.align 2
L1553:	.short	65536
L1508:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1509:
L1503:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1510
	mov.l	@(12,r15),r1
	mov.w	L1554,r2
	cmp/ge	r2,r1
	bt	L1512
	mov.w	L1554,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1512:
	mov.w	L1555,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1514
	mov.w	L1555,r1
	mov.l	r1,@(12,r15)
	mov.w	L1556,r1
	mov.l	r1,@(4,r15)
L1514:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1510:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r4
	mov.l	@(4,r4),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov	r1,r10
	xor	r6,r10
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1516
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1516:
	mov	r6,r7
	mov	r6,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1518
	not	r6,r1
	mov	r1,r7
	add	#1,r7
L1518:
	extu.w	r7,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r7,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r11
	mov	#0,r3
	mov	r3,r13
	mov	r11,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r12
	tst	r11,r11
	bt/s	L1520
	add	r1,r12
	mov.l	L1557,r13
L1520:
	mov.l	@(8,r15),r1
	mov	r12,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1524
	mov	#1,r7
L1523:
	mov	#0,r7
L1524:
	mov	r13,r1
	add	r7,r1
	mov	r12,r2
	shlr16	r2
	add	r2,r1
	mov	r7,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r10,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1529
	mov	#1,r13
L1528:
	mov	#0,r13
L1529:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1525
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1530
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1531
	mov.l	r1,@(16,r15)
L1530:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1531:
L1525:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1532
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1536
	mov	#1,r7
L1535:
	mov	#0,r7
L1536:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L1558,r2
	cmp/ge	r2,r1
	bt	L1537
	mov.w	L1558,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1537:
	mov.w	L1559,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1539
	mov.w	L1559,r1
	mov.l	r1,@(12,r15)
	mov.w	L1560,r1
	mov.l	r1,@(0,r15)
L1539:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L1533
	mov.l	r1,@(12,r15)
L1532:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1543
	mov	#1,r7
L1542:
	mov	#0,r7
L1543:
	mov.l	@(16,r15),r1
	add	r7,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1533:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(4,r4)
	add	#-1,r8
	mov.l	@(20,r15),r1
	mov.w	L1548,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L1441
	add	#24,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L1548:	.short	-2
L1554:	.short	-32768
L1555:	.short	32767
L1556:	.short	-1
L1557:	.short	65536
L1558:	.short	-32768
L1559:	.short	32767
L1560:	.short	-1
	.global _FUN_06045198
	.align 2
_FUN_06045198:
	sts.l	pr,@-r15
	mov.l	L1562,r3
	jsr	@r3
	mov	r4,r8
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L1562:	.long	_FUN_060451bc
	.global _FUN_060451aa
	.align 2
_FUN_060451aa:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L1564,r3
	jsr	@r3
	mov	r4,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L1564:	.long	_FUN_060451be
	.global _FUN_060451bc
	.align 2
_FUN_060451bc:
	sts.l	pr,@-r15
	mov.l	L1566,r4
	mov.l	L1567,r3
	jsr	@r3
	mov.l	L1568,r3
	jsr	@r3
	mov.l	L1569,r3
	jsr	@r3
	mov.l	L1570,r3
	jsr	@r3
	mov.l	L1571,r3
	jsr	@r3
	mov.l	@r4,r4
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L1566:	.long	_uRam060451f4
L1567:	.long	_func_0x06044d80
L1568:	.long	_func_0x060450f2
L1569:	.long	_func_0x06045006
L1570:	.long	_func_0x0604507e
L1571:	.long	_func_0x06044e3c
	.global _FUN_060451be
	.align 2
_FUN_060451be:
	sts.l	pr,@-r15
	mov	r15,r14
	add	#-4,r15
	mov.l	L1573,r1
	jsr	@r1
	nop
	mov.l	L1574,r3
	jsr	@r3
	nop
	mov.l	L1575,r3
	jsr	@r3
	nop
	mov.l	L1576,r3
	jsr	@r3
	nop
	mov.l	@r12,r1
	neg	r1,r1
	mov.l	r1,@(0,r15)
	mov.l	@(4,r12),r1
	neg	r1,r11
	mov.l	@(8,r12),r1
	neg	r1,r10
	mov	r15,r5
	mov.l	L1577,r3
	jsr	@r3
	mov	r14,r15
	lds.l	@r15+,pr
	rts
	add	#0,r5
	.align 2
L1573:	.long	_FUN_06044d80
L1574:	.long	_FUN_060450f2
L1575:	.long	_FUN_06045006
L1576:	.long	_FUN_0604507e
L1577:	.long	_FUN_06044e3c
	.global _FUN_060451fa
	.align 2
_FUN_060451fa:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1682,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	@(36,r15),r4
	mov.l	L1683,r1
	mov.l	@r1,r3
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	r1,@(28,r15)
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r8
	add	#1,r8
	mov	#3,r1
	mov.l	r1,@(24,r15)
L1579:
	mov.l	@(4,r14),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1582
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1582:
	mov.l	@(28,r15),r1
	mov	r1,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1584
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r9
	add	#1,r9
L1584:
	extu.w	r9,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r11
	mov	r9,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r13
	tst	r10,r10
	bt/s	L1586
	add	r1,r13
	mov.l	L1684,r12
L1586:
	mov	r13,r1
	shll16	r1
	mov	r11,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r11,r1
	bf/s	L1590
	mov	#1,r14
L1589:
	mov	#0,r14
L1590:
	mov	r12,r1
	add	r14,r1
	mov	r13,r2
	shlr16	r2
	add	r2,r1
	mov	r9,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1595
	mov	#1,r13
L1594:
	mov	#0,r13
L1595:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1591
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1596
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1597
	mov.l	r1,@(16,r15)
	.align 2
L1682:	.short	-2
L1683:	.short	-32768
L1684:	.short	65536
L1596:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1597:
L1591:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1598
	mov.l	@(16,r15),r1
	mov.w	L1688,r2
	cmp/ge	r2,r1
	bt	L1600
	mov.w	L1688,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1600:
	mov.w	L1685,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1602
	mov.w	L1685,r1
	mov.l	r1,@(16,r15)
	mov.w	L1686,r1
	mov.l	r1,@(8,r15)
L1602:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1598:
	mov.l	@(8,r14),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r9
	xor	r8,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1604
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1604:
	mov	r8,r13
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1606
	mov.l	@(32,r15),r13
L1606:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1608
	add	r1,r11
	mov.l	L1689,r12
L1608:
	mov.l	@(4,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1612
	mov	#1,r14
L1611:
	mov	#0,r14
L1612:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1617
	mov	#1,r13
L1616:
	mov	#0,r13
L1617:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1613
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1618
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1619
	mov.l	r1,@(12,r15)
	.align 2
L1685:	.short	32767
L1686:	.short	-1
L1688:	.short	-32768
L1689:	.short	65536
L1618:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1619:
L1613:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1620
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1624
	mov	#1,r14
L1623:
	mov	#0,r14
L1624:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1692,r2
	cmp/ge	r2,r1
	bt	L1625
	mov.w	L1692,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1625:
	mov.w	L1690,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1627
	mov.w	L1690,r1
	mov.l	r1,@(16,r15)
	mov.w	L1691,r1
	mov.l	r1,@(0,r15)
L1627:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1621
	mov.l	r1,@(16,r15)
	.align 2
L1690:	.short	32767
L1691:	.short	-1
L1692:	.short	-32768
L1620:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1631
	mov	#1,r14
L1630:
	mov	#0,r14
L1631:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1621:
	mov.l	@(4,r14),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1632
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1632:
	mov.l	@(32,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1634
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1634:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1636
	add	r1,r11
	mov.l	L1693,r12
L1636:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1640
	mov	#1,r14
L1639:
	mov	#0,r14
L1640:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1645
	mov	#1,r13
L1644:
	mov	#0,r13
L1645:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1641
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1646
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1647
	mov.l	r1,@(12,r15)
	.align 2
L1693:	.short	65536
L1646:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1647:
L1641:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1648
	mov.l	@(12,r15),r1
	mov.w	L1696,r2
	cmp/ge	r2,r1
	bt	L1650
	mov.w	L1696,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1650:
	mov.w	L1694,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1652
	mov.w	L1694,r1
	mov.l	r1,@(12,r15)
	mov.w	L1695,r1
	mov.l	r1,@(4,r15)
L1652:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1648:
	mov	r14,r1
	add	#4,r1
	mov.l	@(16,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	mov.l	@(8,r14),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1654
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1654:
	mov.l	@(28,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1656
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1656:
	extu.w	r13,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1658
	add	r1,r11
	mov.l	L1697,r12
L1658:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1662
	mov	#1,r14
L1661:
	mov	#0,r14
L1662:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1667
	mov	#1,r13
L1666:
	mov	#0,r13
L1667:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1663
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1668
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1669
	mov.l	r1,@(16,r15)
L1668:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1669:
L1663:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1670
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1674
	mov	#1,r14
L1673:
	mov	#0,r14
L1674:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L1700,r2
	cmp/ge	r2,r1
	bt	L1675
	mov.w	L1700,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1675:
	mov.w	L1698,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1677
	mov.w	L1698,r1
	mov.l	r1,@(12,r15)
	mov.w	L1699,r1
	mov.l	r1,@(0,r15)
L1677:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L1671
	mov.l	r1,@(12,r15)
L1670:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1681
	mov	#1,r14
L1680:
	mov	#0,r14
L1681:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1671:
	mov.l	@(24,r15),r1
	add	#-1,r1
	mov.l	r1,@(24,r15)
	mov.l	@(20,r15),r1
	mov.w	L1687,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	mov	r14,r1
	add	#8,r1
	mov.l	@(12,r15),r2
	shll16	r2
	mov.l	@(0,r15),r3
	shlr16	r3
	or	r3,r2
	mov.l	r2,@r1
	add	#16,r14
	mov.l	@(24,r15),r1
	tst	r1,r1
	bf	L1579
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1694:	.short	32767
L1695:	.short	-1
L1697:	.short	65536
L1698:	.short	32767
L1699:	.short	-1
	.align 2
L1687:	.long	_pcRam06045258
L1696:	.long	_pcRam0604525c
L1700:	.long	_pcRam0604525c
	.global _FUN_0604521a
	.align 2
_FUN_0604521a:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1805,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	@(36,r15),r4
	mov.l	L1806,r1
	mov.l	@r1,r3
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	r1,@(28,r15)
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r8
	add	#1,r8
	mov	#3,r1
	mov.l	r1,@(24,r15)
L1702:
	mov.l	@r14,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1705
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1705:
	mov.l	@(28,r15),r1
	mov	r1,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1707
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r9
	add	#1,r9
L1707:
	extu.w	r9,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r11
	mov	r9,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r13
	tst	r10,r10
	bt/s	L1709
	add	r1,r13
	mov.l	L1807,r12
L1709:
	mov	r13,r1
	shll16	r1
	mov	r11,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r11,r1
	bf/s	L1713
	mov	#1,r14
L1712:
	mov	#0,r14
L1713:
	mov	r12,r1
	add	r14,r1
	mov	r13,r2
	shlr16	r2
	add	r2,r1
	mov	r9,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1718
	mov	#1,r13
L1717:
	mov	#0,r13
L1718:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1714
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1719
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1720
	mov.l	r1,@(16,r15)
	.align 2
L1805:	.short	-2
L1806:	.short	32767
L1807:	.short	65536
L1719:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1720:
L1714:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1721
	mov.l	@(16,r15),r1
	mov.w	L1808,r2
	cmp/ge	r2,r1
	bt	L1723
	mov.w	L1808,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1723:
	mov.w	L1811,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1725
	mov.w	L1811,r1
	mov.l	r1,@(16,r15)
	mov.w	L1809,r1
	mov.l	r1,@(8,r15)
L1725:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1721:
	mov.l	@(8,r14),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1727
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1727:
	mov.l	@(32,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1729
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1729:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1731
	add	r1,r11
	mov.l	L1812,r12
L1731:
	mov.l	@(4,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1735
	mov	#1,r14
L1734:
	mov	#0,r14
L1735:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1740
	mov	#1,r13
L1739:
	mov	#0,r13
L1740:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1736
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1741
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1742
	mov.l	r1,@(12,r15)
	.align 2
L1808:	.short	-32768
L1809:	.short	-1
L1811:	.short	32767
L1812:	.short	65536
L1741:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1742:
L1736:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1743
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1747
	mov	#1,r14
L1746:
	mov	#0,r14
L1747:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1813,r2
	cmp/ge	r2,r1
	bt	L1748
	mov.w	L1813,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1748:
	mov.w	L1815,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1750
	mov.w	L1815,r1
	mov.l	r1,@(16,r15)
	mov.w	L1814,r1
	mov.l	r1,@(0,r15)
L1750:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1744
	mov.l	r1,@(16,r15)
	.align 2
L1813:	.short	-32768
L1814:	.short	-1
L1815:	.short	32767
L1743:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1754
	mov	#1,r14
L1753:
	mov	#0,r14
L1754:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1744:
	mov.l	@r14,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r9
	xor	r8,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1755
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1755:
	mov	r8,r13
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1757
	mov.l	@(32,r15),r13
L1757:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1759
	add	r1,r11
	mov.l	L1816,r12
L1759:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1763
	mov	#1,r14
L1762:
	mov	#0,r14
L1763:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1768
	mov	#1,r13
L1767:
	mov	#0,r13
L1768:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1764
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1769
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1770
	mov.l	r1,@(12,r15)
	.align 2
L1816:	.short	65536
L1769:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1770:
L1764:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1771
	mov.l	@(12,r15),r1
	mov.w	L1817,r2
	cmp/ge	r2,r1
	bt	L1773
	mov.w	L1817,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1773:
	mov.w	L1819,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1775
	mov.w	L1819,r1
	mov.l	r1,@(12,r15)
	mov.w	L1818,r1
	mov.l	r1,@(4,r15)
L1775:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1771:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r14
	mov.l	@(8,r14),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1777
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1777:
	mov.l	@(28,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1779
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1779:
	extu.w	r13,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1781
	add	r1,r11
	mov.l	L1820,r12
L1781:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1785
	mov	#1,r14
L1784:
	mov	#0,r14
L1785:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1790
	mov	#1,r13
L1789:
	mov	#0,r13
L1790:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1786
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1791
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1792
	mov.l	r1,@(16,r15)
L1791:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1792:
L1786:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1793
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1797
	mov	#1,r14
L1796:
	mov	#0,r14
L1797:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L1821,r2
	cmp/ge	r2,r1
	bt	L1798
	mov.w	L1821,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1798:
	mov.w	L1823,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1800
	mov.w	L1823,r1
	mov.l	r1,@(12,r15)
	mov.w	L1822,r1
	mov.l	r1,@(0,r15)
L1800:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L1794
	mov.l	r1,@(12,r15)
L1793:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1804
	mov	#1,r14
L1803:
	mov	#0,r14
L1804:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1794:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(8,r14)
	mov.l	@(24,r15),r1
	add	#-1,r1
	mov.l	r1,@(24,r15)
	mov.l	@(20,r15),r1
	mov.w	L1810,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r1
	tst	r1,r1
	bf	L1702
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1817:	.short	-32768
L1818:	.short	-1
L1820:	.short	65536
L1821:	.short	-32768
L1822:	.short	-1
	.align 2
L1810:	.long	_pcRam06045258
L1819:	.long	_pcRam0604525c
L1823:	.long	_pcRam0604525c
	.global _FUN_0604523a
	.align 2
_FUN_0604523a:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L1928,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	@(36,r15),r4
	mov.l	L1929,r1
	mov.l	@r1,r3
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov.l	r1,@(28,r15)
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r8
	add	#1,r8
	mov	#3,r1
	mov.l	r1,@(24,r15)
L1825:
	mov.l	@r14,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r3
	xor	r2,r3
	mov.l	r3,@(12,r15)
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1828
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1828:
	mov.l	@(28,r15),r1
	mov	r1,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1830
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r9
	add	#1,r9
L1830:
	extu.w	r9,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r11
	mov	r9,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r13
	tst	r10,r10
	bt/s	L1832
	add	r1,r13
	mov.l	L1930,r12
L1832:
	mov	r13,r1
	shll16	r1
	mov	r11,r2
	add	r1,r2
	mov.l	r2,@(8,r15)
	mov.l	@(8,r15),r1
	cmp/hs	r11,r1
	bf/s	L1836
	mov	#1,r14
L1835:
	mov	#0,r14
L1836:
	mov	r12,r1
	add	r14,r1
	mov	r13,r2
	shlr16	r2
	add	r2,r1
	mov	r9,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(12,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1841
	mov	#1,r13
L1840:
	mov	#0,r13
L1841:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1837
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L1842
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1843
	mov.l	r1,@(16,r15)
	.align 2
L1928:	.short	-2
L1929:	.short	-32768
L1930:	.short	65536
L1842:
	mov.l	@(8,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(8,r15)
L1843:
L1837:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1844
	mov.l	@(16,r15),r1
	mov.w	L1934,r2
	cmp/ge	r2,r1
	bt	L1846
	mov.w	L1934,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(8,r15)
L1846:
	mov.w	L1931,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1848
	mov.w	L1931,r1
	mov.l	r1,@(16,r15)
	mov.w	L1932,r1
	mov.l	r1,@(8,r15)
L1848:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(16,r15)
L1844:
	mov.l	@(4,r14),r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov	r1,r9
	xor	r8,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1850
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1850:
	mov	r8,r13
	mov	r8,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1852
	mov.l	@(32,r15),r13
L1852:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(4,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1854
	add	r1,r11
	mov.l	L1935,r12
L1854:
	mov.l	@(4,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1858
	mov	#1,r14
L1857:
	mov	#0,r14
L1858:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1863
	mov	#1,r13
L1862:
	mov	#0,r13
L1863:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1859
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1864
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1865
	mov.l	r1,@(12,r15)
	.align 2
L1931:	.short	32767
L1932:	.short	-1
L1934:	.short	-32768
L1935:	.short	65536
L1864:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1865:
L1859:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1866
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1870
	mov	#1,r14
L1869:
	mov	#0,r14
L1870:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.w	L1938,r2
	cmp/ge	r2,r1
	bt	L1871
	mov.w	L1938,r1
	mov.l	r1,@(16,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1871:
	mov.w	L1936,r1
	mov.l	@(16,r15),r2
	cmp/ge	r2,r1
	bt	L1873
	mov.w	L1936,r1
	mov.l	r1,@(16,r15)
	mov.w	L1937,r1
	mov.l	r1,@(0,r15)
L1873:
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	bra	L1867
	mov.l	r1,@(16,r15)
	.align 2
L1936:	.short	32767
L1937:	.short	-1
L1938:	.short	-32768
L1866:
	mov.l	@(8,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1877
	mov	#1,r14
L1876:
	mov	#0,r14
L1877:
	mov.l	@(12,r15),r1
	add	r14,r1
	mov.l	@(16,r15),r2
	add	r2,r1
	mov.l	r1,@(16,r15)
L1867:
	mov.l	@r14,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.l	@(32,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1878
	mov.l	@(12,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(12,r15)
L1878:
	mov.l	@(32,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1880
	mov.l	@(32,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1880:
	extu.w	r13,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1882
	add	r1,r11
	mov.l	L1939,r12
L1882:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(4,r15)
	mov.l	@(4,r15),r2
	cmp/hs	r1,r2
	bf/s	L1886
	mov	#1,r14
L1885:
	mov	#0,r14
L1886:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(12,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1891
	mov	#1,r13
L1890:
	mov	#0,r13
L1891:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1887
	mov.l	@(12,r15),r1
	not	r1,r1
	mov.l	r1,@(12,r15)
	mov.l	@(4,r15),r1
	tst	r1,r1
	bf	L1892
	mov.l	@(12,r15),r1
	add	#1,r1
	bra	L1893
	mov.l	r1,@(12,r15)
	.align 2
L1939:	.short	65536
L1892:
	mov.l	@(4,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(4,r15)
L1893:
L1887:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1894
	mov.l	@(12,r15),r1
	mov.w	L1942,r2
	cmp/ge	r2,r1
	bt	L1896
	mov.w	L1942,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(4,r15)
L1896:
	mov.w	L1940,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1898
	mov.w	L1940,r1
	mov.l	r1,@(12,r15)
	mov.w	L1941,r1
	mov.l	r1,@(4,r15)
L1898:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	mov.l	r1,@(12,r15)
L1894:
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r14
	mov.l	@(4,r14),r1
	mov.l	r1,@(16,r15)
	mov.l	@(16,r15),r1
	mov.l	@(28,r15),r2
	mov	r1,r9
	xor	r2,r9
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1900
	mov.l	@(16,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(16,r15)
L1900:
	mov.l	@(28,r15),r1
	mov	r1,r13
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1902
	mov.l	@(28,r15),r1
	not	r1,r1
	mov	r1,r13
	add	#1,r13
L1902:
	extu.w	r13,r1
	mov.l	@(16,r15),r2
	extu.w	r2,r3
	mul.l	r3,r1
	sts	macl,r4
	mov.l	r4,@(8,r15)
	mov	r13,r4
	shlr16	r4
	mul.l	r3,r4
	sts	macl,r3
	mov	r3,r10
	mov	#0,r3
	mov	r3,r12
	mov	r10,r3
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r3,r11
	tst	r10,r10
	bt/s	L1904
	add	r1,r11
	mov.l	L1943,r12
L1904:
	mov.l	@(8,r15),r1
	mov	r11,r2
	shll16	r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1908
	mov	#1,r14
L1907:
	mov	#0,r14
L1908:
	mov	r12,r1
	add	r14,r1
	mov	r11,r2
	shlr16	r2
	add	r2,r1
	mov	r13,r2
	shlr16	r2
	mov.l	@(16,r15),r3
	shlr16	r3
	mul.l	r3,r2
	sts	macl,r2
	add	r2,r1
	mov.l	r1,@(16,r15)
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L1913
	mov	#1,r13
L1912:
	mov	#0,r13
L1913:
	mov	r13,r1
	not	r1,r1
	add	#1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L1909
	mov.l	@(16,r15),r1
	not	r1,r1
	mov.l	r1,@(16,r15)
	mov.l	@(0,r15),r1
	tst	r1,r1
	bf	L1914
	mov.l	@(16,r15),r1
	add	#1,r1
	bra	L1915
	mov.l	r1,@(16,r15)
L1914:
	mov.l	@(0,r15),r1
	not	r1,r1
	add	#1,r1
	mov.l	r1,@(0,r15)
L1915:
L1909:
	mov	#1,r1
	mov.l	@(20,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L1916
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1920
	mov	#1,r14
L1919:
	mov	#0,r14
L1920:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	extu.w	r2,r2
	add	r2,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r1
	mov.w	L1946,r2
	cmp/ge	r2,r1
	bt	L1921
	mov.w	L1946,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov.l	r1,@(0,r15)
L1921:
	mov.w	L1944,r1
	mov.l	@(12,r15),r2
	cmp/ge	r2,r1
	bt	L1923
	mov.w	L1944,r1
	mov.l	r1,@(12,r15)
	mov.w	L1945,r1
	mov.l	r1,@(0,r15)
L1923:
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	bra	L1917
	mov.l	r1,@(12,r15)
L1916:
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	mov	r1,r3
	add	r2,r3
	mov.l	r3,@(0,r15)
	mov.l	@(0,r15),r2
	cmp/hs	r1,r2
	bf/s	L1927
	mov	#1,r14
L1926:
	mov	#0,r14
L1927:
	mov.l	@(16,r15),r1
	add	r14,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@(12,r15)
L1917:
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@(4,r14)
	mov.l	@(24,r15),r1
	add	#-1,r1
	mov.l	r1,@(24,r15)
	mov.l	@(20,r15),r1
	mov.w	L1933,r2
	and	r2,r1
	mov.l	r1,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r1
	tst	r1,r1
	bf	L1825
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L1940:	.short	32767
L1941:	.short	-1
L1943:	.short	65536
L1944:	.short	32767
L1945:	.short	-1
	.align 2
L1933:	.long	_pcRam06045258
L1942:	.long	_pcRam0604525c
L1946:	.long	_pcRam0604525c
	.global _FUN_060452f0
	.align 2
_FUN_060452f0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L1948,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L1948:	.long	_FUN_06045368
	.global _FUN_06045318
	.align 2
_FUN_06045318:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L1950,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L1950:	.long	_FUN_060453c8
	.global _FUN_06045340
	.align 2
_FUN_06045340:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L1952,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L1952:	.long	_FUN_060453b8
	.global _FUN_06045368
	.align 2
_FUN_06045368:
	sts.l	pr,@-r15
	mov.l	L1954,r3
	jsr	@r3
	nop
	mov.l	L1955,r3
	jsr	@r3
	nop
	mov.l	L1956,r4
	mov.l	L1957,r3
	jsr	@r3
	mov.l	L1958,r4
	mov.l	L1959,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L1960,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L1961,r3
	jsr	@r3
	mov	#0,r4
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L1954:	.long	_PTR_FUN_0604539c
L1955:	.long	_PTR_SUB_060453a0
L1956:	.long	_PTR_DAT_060453a4
L1957:	.long	_FUN_060453c8
L1958:	.long	_PTR_DAT_060453ac
L1959:	.long	_func_0x060453cc
L1960:	.long	_PTR_FUN_060453b4
L1961:	.long	_FUN_06045ccc
	.global _FUN_06045378
	.align 2
_FUN_06045378:
	sts.l	pr,@-r15
	mov.l	L1963,r4
	mov.l	L1964,r3
	jsr	@r3
	mov.l	L1965,r4
	mov.l	L1964,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L1966,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L1967,r3
	jsr	@r3
	mov	#0,r4
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L1963:	.long	_PTR_DAT_060453a4
L1964:	.long	_FUN_060453cc
L1965:	.long	_PTR_DAT_060453ac
L1966:	.long	_PTR_FUN_060453b4
L1967:	.long	_FUN_06045ccc
	.global _FUN_060453b8
	.align 2
_FUN_060453b8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L1972,r1
	mov.l	@r1,r13
	mov.l	L1973,r1
	mov.l	@r1,r12
L1969:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1969
	mov.l	L1974,r3
	jsr	@r3
	nop
	mov.l	L1975,r3
	jsr	@r3
	mov	#0,r4
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L1972:	.long	_puRam060453c4
L1973:	.long	_puRam060453c0
L1974:	.long	_func_0x060456cc
L1975:	.long	_FUN_06045ccc
	.global _FUN_060453c8
	.align 2
_FUN_060453c8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L1980,r1
	mov.l	@r1,r13
	mov.l	L1981,r1
	mov.l	@r1,r12
L1977:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1977
	mov.l	L1982,r3
	jsr	@r3
	nop
	mov.l	L1983,r3
	jsr	@r3
	mov	#0,r4
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L1980:	.long	_puRam06045598
L1981:	.long	_puRam06045594
L1982:	.long	_func_0x060456cc
L1983:	.long	_FUN_06045ccc
	.global _FUN_060453cc
	.align 2
_FUN_060453cc:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#48,r12
L1985:
	mov.l	@r14+,r13
	mov.l	r13,@r11
	dt	r12
	add	#4,r11
	bf	L1985
	mov.l	L1988,r3
	jsr	@r3
	nop
	mov.l	L1989,r3
	jsr	@r3
	mov	#0,r4
	mov	r0,r1
	mov	r1,r13
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L1988:	.long	_FUN_060456cc
L1989:	.long	_FUN_06045ccc
	.global _FUN_0604556c
	.align 2
_FUN_0604556c:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L1991,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L1991:	.long	_FUN_0604559c
	.global _FUN_0604559c
	.align 2
_FUN_0604559c:
	sts.l	pr,@-r15
	mov.l	L1993,r3
	jsr	@r3
	nop
	mov.l	L1994,r3
	jsr	@r3
	nop
	mov.l	L1995,r3
	jsr	@r3
	nop
	mov.l	L1996,r1
	mov.l	@r1,r1
	mov	r1,r2
	mov	r2,r14
	mov.l	L1999,r4
	mov.l	L1997,r2
	mov.l	L1998,r1
	mov.l	L2000,r1
	mov.l	@r2,r2
	mov.l	r1,@r2
	mov.l	@r1,r1
	extu.w	r14,r2
	mov.l	r2,@r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L2001,r1
	mov.l	@r1,r1
	mov.w	L2002,r2
	add	r2,r1
	mov.l	L2004,r3
	mov.l	L2003,r2
	mov.l	@r2,r2
	jsr	@r3
	mov.w	r2,@r1
	mov	r0,r1
	mov	r1,r13
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2002:	.short	140
	.align 2
L1993:	.long	_PTR_FUN_060455f4
L1994:	.long	_PTR_FUN_060455f8
L1995:	.long	_func_0x06045378
L1996:	.long	_DAT_060455ee
L1997:	.long	_DAT_060455fc
L1998:	.long	_DAT_06045600
L1999:	.long	_PTR_LAB_06045604
L2000:	.long	_DAT_06045608
L2001:	.long	_DAT_0604560c
L2003:	.long	_DAT_060455f0
L2004:	.long	_func_0x060456cc
	.global _FUN_060455d0
	.align 2
_FUN_060455d0:
	sts.l	pr,@-r15
	mov.l	L2006,r1
	mov.l	@r1,r1
	mov.w	L2007,r2
	add	r2,r1
	mov.l	L2009,r3
	mov.l	L2008,r2
	mov.l	@r2,r2
	jsr	@r3
	mov.w	r2,@r1
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2007:	.short	140
	.align 2
L2006:	.long	_DAT_06045610
L2008:	.long	_DAT_060455f0
L2009:	.long	_FUN_060456cc
	.global _FUN_060455e2
	.align 2
_FUN_060455e2:
	sts.l	pr,@-r15
	mov.l	L2011,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2011:	.long	_FUN_0604562c
	.global _FUN_06045614
	.align 2
_FUN_06045614:
	sts.l	pr,@-r15
	mov.l	L2013,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2013:	.long	_FUN_06045650
	.global _FUN_06045620
	.align 2
_FUN_06045620:
	sts.l	pr,@-r15
	mov.l	L2015,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2015:	.long	_func_0x06045664
	.global _FUN_0604562c
	.align 2
_FUN_0604562c:
	sts.l	pr,@-r15
	mov.l	L2017,r4
	mov.l	L2018,r1
	mov.l	@r4,r4
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L2019,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2017:	.long	_uRam06045644
L2018:	.long	_pcRam06045648
L2019:	.long	_pcRam0604564c
	.global _FUN_06045650
	.align 2
_FUN_06045650:
	mov.l	L2021,r1
	mov.l	@r1,r1
	mov	r1,r7
	mov.w	L2022,r2
	add	r2,r1
	mov.l	L2023,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.w	L2024,r1
	add	r7,r1
	mov.l	L2025,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.w	L2026,r1
	add	r7,r1
	mov	#0,r2
	mov.l	r2,@r1
	mov.w	L2027,r1
	add	r7,r1
	mov	#0,r2
	rts
	mov.l	r2,@r1
	.align 2
L2022:	.short	136
L2024:	.short	144
L2026:	.short	132
L2027:	.short	168
L2021:	.long	_iRam06045690
L2023:	.long	_uRam06045688
L2025:	.long	_uRam0604568a
	.global _FUN_06045664
	.align 2
_FUN_06045664:
	mov.l	L2029,r1
	mov.l	@r1,r1
	mov	r1,r7
	mov.w	L2030,r2
	add	r2,r1
	mov.l	L2031,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.w	L2032,r1
	add	r7,r1
	mov.l	L2033,r2
	mov.l	@r2,r2
	mov.w	r2,@r1
	mov.w	L2034,r1
	add	r7,r1
	mov	#0,r2
	mov.l	r2,@r1
	mov.w	L2035,r1
	add	r7,r1
	mov	#0,r2
	rts
	mov.l	r2,@r1
	.align 2
L2030:	.short	136
L2032:	.short	144
L2034:	.short	132
L2035:	.short	168
L2029:	.long	_iRam06045694
L2031:	.long	_uRam0604568c
L2033:	.long	_uRam0604568e
	.global _FUN_06045678
	.align 2
_FUN_06045678:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L2037,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2037:	.long	_FUN_06045698
	.global _FUN_06045698
	.align 2
_FUN_06045698:
	rts
	nop
	.global _FUN_060456aa
	.align 2
_FUN_060456aa:
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
	.global _FUN_060456ac
	.align 2
_FUN_060456ac:
	sts.l	pr,@-r15
	mov.l	L2042,r3
	jsr	@r3
	nop
	mov.l	L2042,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2042:	.long	_FUN_060456c2
	.global _FUN_060456c2
	.align 2
_FUN_060456c2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2044,r1
	add	r13,r1
	mov.l	L2045,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r14,@r1
	.align 2
L2044:	.short	140
	.align 2
L2045:	.long	_FUN_060456cc
	.global _FUN_060456cc
	.align 2
_FUN_060456cc:
	mov.l	L2047,r1
	mov.l	@r7,r2
	mov.l	r2,@r1
	mov.l	L2048,r1
	mov.w	L2047,r3
	add	r7,r3
	mov.w	@r3,r2
	mov.l	r2,@r1
	mov.l	L2049,r1
	mov	#0,r2
	mov.l	r2,@r1
	mov.l	L2050,r1
	mov.l	@r1,r1
	rts
	mov.l	r1,@(12,r14)
	.align 2
L2047:	.long	__DAT_ffffff00
L2048:	.long	__DAT_ffffff10
L2049:	.long	__DAT_ffffff14
L2050:	.long	__DAT_ffffff1c
	.global _FUN_060456ec
	.align 2
_FUN_060456ec:
	mov.w	L2052,r1
	add	r7,r1
	mov.l	L2053,r2
	mov.l	@r2,r2
	rts
	mov.w	r2,@r1
	.align 2
L2052:	.short	146
	.align 2
L2053:	.long	_uRam060456f8
	.global _FUN_060456f2
	.align 2
_FUN_060456f2:
	mov.w	L2055,r1
	add	r7,r1
	mov.l	L2056,r2
	mov.l	@r2,r2
	rts
	mov.w	r2,@r1
	.align 2
L2055:	.short	146
	.align 2
L2056:	.long	_uRam060456fa
	.global _FUN_060456fc
	.align 2
_FUN_060456fc:
	mov.l	L2060,r1
	mov.l	@r1,r7
	mov.l	L2061,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L2058
	mov.l	L2062,r1
	mov.l	@r1,r7
L2058:
	rts
	mov.l	r4,@r7
	.align 2
L2060:	.long	_puRam0604570c
L2061:	.long	__DAT_ffffffe2
L2062:	.long	_puRam06045710
	.global _FUN_06045714
	.align 2
_FUN_06045714:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L2064,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L2064:	.long	_FUN_06045738
	.global _FUN_06045738
	.align 2
_FUN_06045738:
	sts.l	pr,@-r15
	add	#-16,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2080,r1
	mov.l	@r1,r1
	mov	r1,r11
	mov.l	@r1,r1
	tst	r1,r1
	bf	L2066
	mov	#12,r8
	mov.l	L2081,r1
	mov.l	@r1,r9
L2068:
	mov.l	@r14+,r10
	mov.l	r10,@r9
	dt	r8
	add	#4,r9
	bf	L2068
	mov.l	L2081,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r11)
	mov.l	r13,@(8,r11)
	mov.l	L2082,r1
	mov.l	r1,@r11
	mov.l	L2083,r1
	mov.l	@r1,r1
	mov.w	L2084,r2
	mov.l	r2,@r1
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L2066:
	mov.l	L2085,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r1
	mov.w	L2081,r2
	add	r2,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2065
	mov.l	L2086,r3
	jsr	@r3
	nop
	mov.l	L2087,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r1
	add	#48,r1
	mov.l	@r1,r8
	mov.l	@(8,r8),r1
	add	r8,r1
	mov.l	r1,@(12,r15)
	mov	r8,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r8
L2073:
	mov.l	@(0,r15),r1
	mov.w	L2081,r2
	add	r2,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2076
	nop
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L2076:
	mov.l	@(12,r15),r1
	mov.w	@r1+,r12
	mov.l	r1,@(8,r15)
	mov.l	@(0,r15),r1
	mov.w	L2088,r2
	add	r2,r1
	mov.w	r12,@r1
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	r1,@(12,r15)
	mov.l	@(0,r15),r1
	mov.w	L2089,r2
	add	r2,r1
	mov.l	@(8,r15),r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	extu.w	r12,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2078
	mov.l	L2090,r3
	jsr	@r3
	nop
	bra	L2079
	nop
L2078:
	mov.l	L2091,r3
	jsr	@r3
	nop
L2079:
	dt	r8
	bf	L2073
L2065:
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2084:	.short	22368
L2088:	.short	128
L2089:	.short	130
	.align 2
L2080:	.long	_piRam06045770
L2081:	.long	_puRam06045774
L2082:	.long	_FUN_06045760
L2083:	.long	_puRam06045778
L2085:	.long	_FUN_060459c4
L2086:	.long	_FUN_060463e4
L2087:	.long	_FUN_06046602
L2090:	.long	_FUN_06045a2c
L2091:	.long	_FUN_06045a7e
	.global _FUN_06045760
	.align 2
_FUN_06045760:
	sts.l	pr,@-r15
	mov.l	L2102,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	@(4,r1),r4
	mov.l	L2104,r3
	mov.l	L2103,r1
	mov.l	r2,@r1
	mov.l	@r1,r1
	jsr	@r3
	mov.l	@(8,r1),r5
	mov.w	L2103,r1
	add	r9,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2092
	mov.l	L2105,r3
	jsr	@r3
	nop
	mov.l	L2106,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r1
	add	r13,r1
	mov	r1,r12
	mov	r13,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r13
L2095:
	mov.w	L2103,r1
	add	r9,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2098
	nop
	lds.l	@r15+,pr
	rts
	nop
L2098:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2107,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2108,r1
	add	r9,r1
	mov.w	@r11,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2100
	mov.l	L2109,r3
	jsr	@r3
	nop
	bra	L2101
	nop
L2100:
	mov.l	L2110,r3
	jsr	@r3
	nop
L2101:
	dt	r13
	bf	L2095
L2092:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2107:	.short	128
L2108:	.short	130
L2102:	.long	_puRam0604577c
L2103:	.long	_iRam06045780
L2104:	.long	_FUN_060459c4
L2105:	.long	_FUN_060463e4
L2106:	.long	_FUN_06046602
L2109:	.long	_FUN_06045a2c
L2110:	.long	_FUN_06045a7e
	.global _FUN_06045784
	.align 2
_FUN_06045784:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L2112,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r8
	mov	r8,r0
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
L2112:	.long	_FUN_060457a8
	.global _FUN_060457aa
	.align 2
_FUN_060457aa:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2123,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r1
	mov.w	L2124,r2
	add	r2,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r1
	mov.w	L2125,r2
	add	r2,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2113
	mov.l	L2126,r3
	jsr	@r3
	nop
	mov.l	L2127,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r1
	add	#48,r1
	mov.l	@r1,r10
	mov.l	@(8,r10),r1
	add	r10,r1
	mov	r1,r9
	mov	r10,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r10
L2116:
	mov.l	@(0,r15),r1
	mov.w	L2125,r2
	add	r2,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2119
	nop
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
L2119:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r1
	mov.w	L2128,r2
	add	r2,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r1
	mov.w	L2129,r2
	add	r2,r1
	mov.w	@r8,r2
	mov.w	r2,@r1
	extu.w	r11,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2121
	mov.l	L2130,r3
	jsr	@r3
	nop
	bra	L2122
	nop
L2121:
	mov.l	L2131,r3
	jsr	@r3
	nop
L2122:
	dt	r10
	bf	L2116
L2113:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2124:	.short	148
L2125:	.short	136
L2128:	.short	128
L2129:	.short	130
L2123:	.long	_FUN_060459c4
L2126:	.long	_FUN_060463e4
L2127:	.long	_FUN_06046602
L2130:	.long	_FUN_06045a2c
L2131:	.long	_FUN_06045a7e
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
	mov.l	L2142,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r1
	mov.w	L2143,r2
	add	r2,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r1
	mov.w	L2144,r2
	add	r2,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2132
	mov.l	L2145,r3
	jsr	@r3
	nop
	mov.l	L2146,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r1
	add	#48,r1
	mov.l	@r1,r10
	mov.l	@(8,r10),r1
	add	r10,r1
	mov	r1,r9
	mov	r10,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r10
L2135:
	mov.l	@(0,r15),r1
	mov.w	L2144,r2
	add	r2,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2138
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
L2138:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r1
	mov.w	L2147,r2
	add	r2,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r1
	mov.w	L2148,r2
	add	r2,r1
	mov.w	@r8,r2
	mov.w	r2,@r1
	extu.w	r11,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2140
	mov.l	L2149,r3
	jsr	@r3
	nop
	bra	L2141
	nop
L2140:
	mov.l	L2150,r3
	jsr	@r3
	nop
L2141:
	dt	r10
	bf	L2135
L2132:
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
L2143:	.short	148
L2144:	.short	136
L2147:	.short	128
L2148:	.short	130
L2142:	.long	_FUN_060459c4
L2145:	.long	_FUN_060463e4
L2146:	.long	_func_0x06046602
L2149:	.long	_func_0x06045a2c
L2150:	.long	_FUN_06045a7e
	.global _FUN_060457dc
	.align 2
_FUN_060457dc:
	sts.l	pr,@-r15
	mov.l	L2161,r3
	jsr	@r3
	nop
	mov.w	L2162,r1
	add	r9,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2151
	mov.l	L2163,r3
	jsr	@r3
	nop
	mov.l	L2164,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r1
	add	r13,r1
	mov	r1,r12
	mov	r13,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r13
L2154:
	mov.w	L2162,r1
	add	r9,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2157
	nop
	lds.l	@r15+,pr
	rts
	nop
L2157:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2165,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2166,r1
	add	r9,r1
	mov.w	@r11,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2159
	mov.l	L2167,r3
	jsr	@r3
	nop
	bra	L2160
	nop
L2159:
	mov.l	L2168,r3
	jsr	@r3
	nop
L2160:
	dt	r13
	bf	L2154
L2151:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2162:	.short	136
L2165:	.short	128
L2166:	.short	130
	.align 2
L2161:	.long	_FUN_060459c4
L2163:	.long	_FUN_060463e4
L2164:	.long	_func_0x06046602
L2167:	.long	_func_0x06045a2c
L2168:	.long	_FUN_06045a7e
	.global _FUN_060457de
	.align 2
_FUN_060457de:
	sts.l	pr,@-r15
	mov.l	L2179,r3
	jsr	@r3
	nop
	mov.w	L2180,r1
	add	r9,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2169
	mov.l	L2181,r3
	jsr	@r3
	nop
	mov.l	L2182,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r1
	add	r13,r1
	mov	r1,r12
	mov	r13,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r13
L2172:
	mov.w	L2180,r1
	add	r9,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2175
	nop
	lds.l	@r15+,pr
	rts
	nop
L2175:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2183,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2184,r1
	add	r9,r1
	mov.w	@r11,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2177
	mov.l	L2185,r3
	jsr	@r3
	nop
	bra	L2178
	nop
L2177:
	mov.l	L2186,r3
	jsr	@r3
	nop
L2178:
	dt	r13
	bf	L2172
L2169:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2180:	.short	136
L2183:	.short	128
L2184:	.short	130
	.align 2
L2179:	.long	_FUN_060459c4
L2181:	.long	_FUN_060463e4
L2182:	.long	_FUN_06046602
L2185:	.long	_FUN_06045a2c
L2186:	.long	_FUN_06045a7e
	.global _FUN_060457e2
	.align 2
_FUN_060457e2:
	sts.l	pr,@-r15
	mov.w	L2197,r1
	add	r9,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2187
	mov.l	L2198,r3
	jsr	@r3
	nop
	mov.l	L2199,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r1
	add	r13,r1
	mov	r1,r12
	mov	r13,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r13
L2190:
	mov.w	L2197,r1
	add	r9,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2193
	nop
	lds.l	@r15+,pr
	rts
	nop
L2193:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2200,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2201,r1
	add	r9,r1
	mov.w	@r11,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2195
	mov.l	L2202,r3
	jsr	@r3
	nop
	bra	L2196
	nop
L2195:
	mov.l	L2203,r3
	jsr	@r3
	nop
L2196:
	dt	r13
	bf	L2190
L2187:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2197:	.short	136
L2200:	.short	128
L2201:	.short	130
	.align 2
L2198:	.long	_FUN_060463e4
L2199:	.long	_FUN_06046602
L2202:	.long	_FUN_06045a2c
L2203:	.long	_FUN_06045a7e
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
	mov.w	L2214,r1
	add	r13,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2204
	mov.l	L2215,r3
	jsr	@r3
	nop
	mov.l	L2216,r3
	jsr	@r3
	nop
	mov.l	@(48,r12),r9
	mov.l	@(8,r9),r1
	add	r9,r1
	mov	r1,r10
	mov	r9,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r9
L2207:
	mov.w	L2214,r1
	add	r13,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2210
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
L2210:
	mov.w	@r10,r8
	mov	r10,r11
	add	#2,r11
	mov.w	L2217,r1
	add	r13,r1
	mov.w	r8,@r1
	add	#4,r10
	mov.w	L2218,r1
	add	r13,r1
	mov.w	@r11,r2
	mov.w	r2,@r1
	extu.w	r8,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2212
	mov.l	L2219,r3
	jsr	@r3
	nop
	bra	L2213
	nop
L2212:
	mov.l	L2220,r3
	jsr	@r3
	nop
L2213:
	dt	r9
	bf	L2207
L2204:
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
L2214:	.short	136
L2217:	.short	128
L2218:	.short	130
	.align 2
L2215:	.long	_FUN_060463e4
L2216:	.long	_func_0x06046602
L2219:	.long	_func_0x06045a2c
L2220:	.long	_FUN_06045a7e
	.global _FUN_06045858
	.align 2
_FUN_06045858:
	sts.l	pr,@-r15
	mov.l	L2236,r3
	jsr	@r3
	nop
	mov.w	L2236,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2222
	mov.l	L2237,r3
	jsr	@r3
	nop
	mov.l	L2238,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	bra	L2228
	mov	r1,r12
L2227:
	mov.w	L2236,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2230
	nop
	lds.l	@r15+,pr
	rts
	nop
L2230:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2239,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2240,r1
	add	r8,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt	L2232
	bra	L2229
	nop
L2232:
	mov.l	L2241,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2234
	nop
	lds.l	@r15+,pr
	rts
	nop
L2234:
L2228:
	bra	L2227
	nop
L2229:
	mov.l	L2242,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2228
L2222:
L2221:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2239:	.short	128
L2240:	.short	130
L2236:	.long	_FUN_060459c4
L2237:	.long	_func_0x06046478
L2238:	.long	_func_0x06046602
L2241:	.long	_FUN_0604670c
L2242:	.long	_func_0x0604674e
	.global _FUN_0604585c
	.align 2
_FUN_0604585c:
	sts.l	pr,@-r15
	mov.w	L2258,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2244
	mov.l	L2259,r3
	jsr	@r3
	nop
	mov.l	L2260,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	bra	L2250
	mov	r1,r12
L2249:
	mov.w	L2258,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2252
	nop
	lds.l	@r15+,pr
	rts
	nop
L2252:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2261,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2262,r1
	add	r8,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt	L2254
	bra	L2251
	nop
L2254:
	mov.l	L2263,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2256
	nop
	lds.l	@r15+,pr
	rts
	nop
L2256:
L2250:
	bra	L2249
	nop
L2251:
	mov.l	L2264,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2250
L2244:
L2243:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2258:	.short	136
L2261:	.short	128
L2262:	.short	130
	.align 2
L2259:	.long	_func_0x06046478
L2260:	.long	_func_0x06046602
L2263:	.long	_FUN_0604670c
L2264:	.long	_func_0x0604674e
	.global _FUN_060458da
	.align 2
_FUN_060458da:
	sts.l	pr,@-r15
	mov.l	L2280,r3
	jsr	@r3
	nop
	mov.w	L2280,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2266
	mov.l	L2281,r3
	jsr	@r3
	nop
	mov.l	L2282,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	bra	L2272
	mov	r1,r12
L2271:
	mov.w	L2280,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2274
	nop
	lds.l	@r15+,pr
	rts
	nop
L2274:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2283,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2284,r1
	add	r8,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt	L2276
	bra	L2273
	nop
L2276:
	mov.l	L2285,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2278
	nop
	lds.l	@r15+,pr
	rts
	nop
L2278:
L2272:
	bra	L2271
	nop
L2273:
	mov.l	L2286,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2272
L2266:
L2265:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2283:	.short	128
L2284:	.short	130
L2280:	.long	_FUN_060459c4
L2281:	.long	_FUN_06046478
L2282:	.long	_FUN_06046602
L2285:	.long	_FUN_06045a2c
L2286:	.long	_FUN_06045a7e
	.global _FUN_060458de
	.align 2
_FUN_060458de:
	sts.l	pr,@-r15
	mov.w	L2302,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2288
	mov.l	L2303,r3
	jsr	@r3
	nop
	mov.l	L2304,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	bra	L2294
	mov	r1,r12
L2293:
	mov.w	L2302,r1
	add	r8,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2296
	nop
	lds.l	@r15+,pr
	rts
	nop
L2296:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2305,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2306,r1
	add	r8,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt	L2298
	bra	L2295
	nop
L2298:
	mov.l	L2307,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2300
	nop
	lds.l	@r15+,pr
	rts
	nop
L2300:
L2294:
	bra	L2293
	nop
L2295:
	mov.l	L2308,r3
	jsr	@r3
	nop
	dt	r12
	bf	L2294
L2288:
L2287:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2302:	.short	136
L2305:	.short	128
L2306:	.short	130
	.align 2
L2303:	.long	_FUN_06046478
L2304:	.long	_FUN_06046602
L2307:	.long	_FUN_06045a2c
L2308:	.long	_FUN_06045a7e
	.global _FUN_0604595a
	.align 2
_FUN_0604595a:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L2326,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r1
	mov.w	L2326,r2
	add	r2,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2310
	mov.l	L2327,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r12
L2312:
	mov.l	@(0,r15),r1
	mov.w	L2326,r2
	add	r2,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2315
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2315:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r1
	mov.w	L2328,r2
	add	r2,r1
	mov.w	r14,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt/s	L2319
	mov	#1,r14
L2318:
	mov	#0,r14
L2319:
	mov	r14,r1
	mov	r1,r8
	add	#4,r11
	mov.l	@(0,r15),r1
	mov.w	L2329,r2
	add	r2,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.b	r8,r1
	tst	r1,r1
	bt	L2320
	mov.l	L2330,r3
	jsr	@r3
	nop
	mov.l	L2331,r3
	jsr	@r3
	nop
	mov	#1,r2
	extu.b	r8,r1
	and	r2,r1
	tst	r1,r1
	bt	L2321
	mov.l	L2332,r3
	jsr	@r3
	nop
	bra	L2321
	mov	r0,r13
L2320:
	mov.l	L2333,r3
	jsr	@r3
	nop
	mov.l	L2334,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r2
	extu.b	r8,r1
	and	r2,r1
	tst	r1,r1
	bt	L2324
	mov.l	L2335,r3
	jsr	@r3
	nop
L2324:
L2321:
	dt	r12
	bf	L2312
L2310:
L2309:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2328:	.short	128
L2329:	.short	130
L2326:	.long	_FUN_060459c4
L2327:	.long	_FUN_06046520
L2330:	.long	_FUN_06045ac0
L2331:	.long	_FUN_06045b10
L2332:	.long	_FUN_06045b74
L2333:	.long	_FUN_06045adc
L2334:	.long	_FUN_06045b48
L2335:	.long	_FUN_06045ba0
	.global _FUN_0604595e
	.align 2
_FUN_0604595e:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(0,r15),r1
	mov.w	L2353,r2
	add	r2,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hs	r1,r13
	bt	L2337
	mov.l	L2354,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r1
	add	r12,r1
	mov	r1,r11
	mov	r12,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r12
L2339:
	mov.l	@(0,r15),r1
	mov.w	L2353,r2
	add	r2,r1
	mov.l	@r1,r2
	mov	r2,r13
	shlr16	r13
	mov.l	@r1,r1
	extu.w	r1,r1
	cmp/hi	r13,r1
	bt	L2342
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2342:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r1
	mov.w	L2355,r2
	add	r2,r1
	mov.w	r14,@r1
	extu.w	r14,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bt/s	L2346
	mov	#1,r14
L2345:
	mov	#0,r14
L2346:
	mov	r14,r1
	mov	r1,r8
	add	#4,r11
	mov.l	@(0,r15),r1
	mov.w	L2356,r2
	add	r2,r1
	mov.w	@r10,r2
	mov.w	r2,@r1
	extu.b	r8,r1
	tst	r1,r1
	bt	L2347
	mov.l	L2357,r3
	jsr	@r3
	nop
	mov.l	L2358,r3
	jsr	@r3
	nop
	mov	#1,r2
	extu.b	r8,r1
	and	r2,r1
	tst	r1,r1
	bt	L2348
	mov.l	L2359,r3
	jsr	@r3
	nop
	bra	L2348
	mov	r0,r13
L2347:
	mov.l	L2360,r3
	jsr	@r3
	nop
	mov.l	L2361,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r2
	extu.b	r8,r1
	and	r2,r1
	tst	r1,r1
	bt	L2351
	mov.l	L2362,r3
	jsr	@r3
	nop
L2351:
L2348:
	dt	r12
	bf	L2339
L2337:
L2336:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2353:	.short	136
L2355:	.short	128
L2356:	.short	130
	.align 2
L2354:	.long	_FUN_06046520
L2357:	.long	_FUN_06045ac0
L2358:	.long	_FUN_06045b10
L2359:	.long	_FUN_06045b74
L2360:	.long	_FUN_06045adc
L2361:	.long	_FUN_06045b48
L2362:	.long	_FUN_06045ba0
	.global _FUN_060459c4
	.align 2
_FUN_060459c4:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	L2367,r1
	jsr	@r1
	mov	r5,r13
	mov.l	@(0,r15),r1
	mov.w	L2368,r2
	add	r2,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov.l	@(4,r15),r1
	add	#44,r1
	mov.l	r14,@r1
	mov.l	@(4,r15),r1
	add	#48,r1
	mov.l	r13,@r1
	mov.l	@r13,r12
	mov.l	@(0,r15),r1
	mov.w	L2369,r2
	add	r2,r1
	mov.w	@r1,r2
	mov	r12,r3
	shlr16	r3
	exts.w	r3,r3
	add	r3,r2
	mov.w	r2,@r1
	mov.l	@(0,r15),r1
	mov.w	L2370,r2
	add	r2,r1
	mov.w	@r1,r2
	mov	r12,r3
	exts.w	r3,r3
	add	r3,r2
	mov.w	r2,@r1
	mov.l	@(0,r15),r1
	mov.w	L2371,r2
	add	r2,r1
	mov	r13,r2
	add	#2,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.l	@(4,r15),r1
	add	#40,r1
	mov	r13,r2
	mov.l	@(12,r13),r3
	add	r3,r2
	add	#8,r2
	mov.l	r2,@r1
	mov.l	L2372,r1
	mov.l	@r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	mov	r1,r8
	mov	#3,r1
	mov.l	r1,@(8,r15)
L2364:
	mov.l	@(4,r14),r11
	mov.l	@(8,r14),r10
	mov	r14,r9
	add	#12,r9
	mov.l	@r14,r1
	shll2	r1
	shll2	r1
	shll2	r1
	mov.l	r1,@r8
	mov	r11,r1
	shll2	r1
	shll2	r1
	shll2	r1
	mov.l	r1,@(4,r8)
	mov	r10,r1
	shll2	r1
	shll2	r1
	shll2	r1
	mov.l	r1,@(8,r8)
	add	#16,r14
	mov.l	@r9,r1
	mov.l	r1,@(12,r8)
	mov.l	@(8,r15),r1
	add	#-1,r1
	mov.l	r1,@(8,r15)
	add	#16,r8
	mov.l	@(8,r15),r1
	tst	r1,r1
	bf	L2364
	add	#12,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2368:	.short	148
L2369:	.short	168
L2370:	.short	170
L2371:	.short	142
L2367:	.long	_FUN_06045698
L2372:	.long	_DAT_06045b0c
	.global _FUN_06045a2c
	.align 2
_FUN_06045a2c:
	sts.l	pr,@-r15
	add	#-20,r15
	mov	r15,r9
	mov.l	L2378,r3
	jsr	@r3
	add	#0,r9
	mov.l	@(4,r8),r1
	mov.l	@(16,r15),r2
	add	#4,r2
	mov.l	@r2,r2
	or	r2,r1
	mov.l	@(12,r15),r2
	add	#4,r2
	mov.l	@r2,r2
	or	r2,r1
	mov.l	@(8,r15),r2
	add	#4,r2
	mov.l	@r2,r2
	mov	r1,r14
	or	r2,r14
	mov	#2,r1
	mov	r14,r2
	and	r1,r2
	tst	r2,r2
	bf	L2374
	mov.l	@(4,r15),r1
	mov.w	L2379,r2
	add	r2,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2376
	mov.l	L2380,r3
	jsr	@r3
	nop
	mov	r9,r10
L2376:
	mov.l	L2381,r3
	jsr	@r3
	nop
	mov.l	L2382,r3
	mov.l	@(16,r15),r1
	mov.l	@(12,r15),r1
	mov.l	@(8,r15),r1
	mov.l	@r1,r13
	mov.l	@r1,r12
	mov.l	@r1,r11
	mov.l	@r8,r1
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov.l	L2382,r3
	jsr	@r3
	mov.l	r11,@(24,r10)
	mov.l	@(4,r15),r1
	mov.w	L2383,r2
	add	r2,r1
	mov	#4,r2
	mov.l	L2384,r3
	jsr	@r3
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2378,r2
	add	r2,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov	r14,r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2374:
L2373:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2379:	.short	128
L2383:	.short	155
L2378:	.long	_FUN_06045ac0
L2380:	.long	_FUN_06045c9c
L2381:	.long	_FUN_06045e44
L2382:	.long	_FUN_06045d04
L2384:	.long	_FUN_06045e06
	.global _FUN_06045a7e
	.align 2
_FUN_06045a7e:
	sts.l	pr,@-r15
	mov.l	L2390,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r1
	mov.l	@(4,r12),r2
	or	r2,r1
	mov.l	@(4,r11),r2
	mov	r1,r14
	or	r2,r14
	mov	#2,r1
	mov	r14,r2
	and	r1,r2
	tst	r2,r2
	bf	L2386
	mov.w	L2391,r1
	add	r10,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2388
	mov.l	L2392,r3
	jsr	@r3
	nop
L2388:
	mov.l	L2393,r3
	jsr	@r3
	nop
	mov.l	L2394,r3
	jsr	@r3
	nop
	mov.l	L2395,r3
	jsr	@r3
	nop
	mov.w	L2395,r1
	add	r10,r1
	mov	#4,r2
	mov.l	L2396,r3
	jsr	@r3
	mov.b	r2,@r1
	mov.w	L2390,r1
	add	r10,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	nop
L2386:
L2385:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2391:	.short	128
	.align 2
L2390:	.long	_func_0x06045adc
L2392:	.long	_FUN_06045c9c
L2393:	.long	_FUN_06045e44
L2394:	.long	_FUN_06045c3c
L2395:	.long	_FUN_06045d80
L2396:	.long	_FUN_06045e06
	.global _FUN_06045ac0
	.align 2
_FUN_06045ac0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L2400,r1
	add	r10,r1
	mov.w	@r1,r1
	mov	#32,r2
	and	r2,r1
	tst	r1,r1
	bf	L2398
	mov.w	L2400,r1
	add	r10,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2398:
	mov	r12,r1
	add	#10,r1
	mov.w	@r1,r14
	mov	r12,r1
	add	#12,r1
	mov.w	@r1,r13
	mov	r11,r1
	add	#64,r1
	mov	r12,r2
	add	#8,r2
	mov.w	@r2,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r0
	add	#64,r0
L2397:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2400:	.short	128
	.align 2
	.global _FUN_06045adc
	.align 2
_FUN_06045adc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L2404,r1
	add	r10,r1
	mov.w	@r1,r1
	mov	#32,r2
	and	r2,r1
	tst	r1,r1
	bf	L2402
	mov.w	L2404,r1
	add	r10,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2402:
	mov	r12,r1
	add	#8,r1
	mov.w	@r1,r14
	mov	r12,r1
	add	#10,r1
	mov.w	@r1,r13
	mov	r11,r1
	add	#64,r1
	mov	r12,r2
	add	#6,r2
	mov.w	@r2,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r11,r0
	add	#64,r0
L2401:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2404:	.short	128
	.align 2
	.global _FUN_06045af4
	.align 2
_FUN_06045af4:
	mov	r5,r1
	add	#2,r1
	mov.w	@r1,r7
	mov.w	@(4,r5),r0
	mov	r0,r6
	mov	r4,r1
	add	#64,r1
	mov.w	@r5,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#68,r1
	mov	r7,r2
	shll2	r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#72,r1
	mov	r6,r2
	shll2	r2
	rts
	mov.l	r2,@r1
	.global _FUN_06045b10
	.align 2
_FUN_06045b10:
	add	#-4,r15
	mov.l	@(0,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2407
	mov	#2,r1
	mov	r7,r4
	and	r1,r4
	mov	r8,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2409
	mov	#2,r1
	mov	r7,r6
	and	r1,r6
	mov	r9,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2411
	mov	#2,r1
	mov	r7,r5
	and	r1,r5
	mov	r10,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2413
	mov	#2,r1
	mov	r7,r2
	and	r1,r2
	mov	r4,r1
	shll	r1
	or	r6,r1
	shll	r1
	or	r5,r1
	shll	r1
	mov	r2,r0
	or	r1,r0
	add	#4,r15
	rts
	nop
L2413:
L2411:
L2409:
L2407:
L2406:
	add	#4,r15
	rts
	mov	r7,r0
	.global _FUN_06045b48
	.align 2
_FUN_06045b48:
	mov	r9,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2416
	mov	#2,r1
	mov	r7,r5
	and	r1,r5
	mov	r10,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2418
	mov	#2,r1
	mov	r7,r6
	and	r1,r6
	mov	r4,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	r1,r7
	mov	#1,r1
	mov	r7,r2
	and	r1,r2
	tst	r2,r2
	bf	L2420
	mov	#2,r1
	mov	r7,r2
	and	r1,r2
	mov	r5,r1
	shll	r1
	or	r6,r1
	shll	r1
	mov	r2,r0
	or	r1,r0
	rts
	nop
L2420:
L2418:
L2416:
L2415:
	rts
	mov	r7,r0
	.global _FUN_06045b74
	.align 2
_FUN_06045b74:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r1
	extu.b	r10,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2423
	mov.l	L2429,r1
	mov	r13,r2
	shll2	r2
	add	r1,r2
	mov.w	@r2,r2
	shll2	r2
	mov	r2,r3
	add	r1,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2423:
	mov.w	L2429,r1
	add	r9,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2425
	mov.l	L2430,r3
	jsr	@r3
	nop
L2425:
	mov.l	L2431,r3
	jsr	@r3
	nop
	mov	r11,r1
	add	#4,r1
	mov.l	@r1,r12
	cmp/ge	r12,r14
	bt	L2427
	mov.w	L2432,r1
	add	r9,r1
	mov.l	L2433,r3
	jsr	@r3
	mov.l	L2434,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2432,r4
	add	r9,r4
	mov.l	L2435,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2436,r1
	add	r9,r1
	mov.w	@r1,r2
	mov.w	L2434,r3
	add	r9,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2427:
L2422:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2432:	.short	156
L2436:	.short	136
L2429:	.long	_DAT_06045b80
L2430:	.long	_FUN_06045c9c
L2431:	.long	_FUN_06045d04
L2433:	.long	_FUN_06045e44
L2434:	.long	_FUN_0604698c
L2435:	.long	_FUN_06045e06
	.global _FUN_06045ba0
	.align 2
_FUN_06045ba0:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r1
	extu.b	r10,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2438
	mov.l	L2444,r1
	mov	r13,r2
	shll2	r2
	add	r1,r2
	mov.w	@r2,r2
	shll2	r2
	mov	r2,r3
	add	r1,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2438:
	mov.w	L2444,r1
	add	r9,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2440
	mov.l	L2445,r3
	jsr	@r3
	nop
L2440:
	mov.l	L2446,r3
	jsr	@r3
	nop
	mov	r11,r1
	add	#4,r1
	mov.l	@r1,r12
	cmp/ge	r12,r14
	bt	L2442
	mov.w	L2447,r1
	add	r9,r1
	mov.l	L2448,r3
	jsr	@r3
	mov.l	L2449,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2447,r4
	add	r9,r4
	mov.l	L2450,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2451,r1
	add	r9,r1
	mov.w	@r1,r2
	mov.w	L2449,r3
	add	r9,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2442:
L2437:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2447:	.short	156
L2451:	.short	136
L2444:	.long	_DAT_06045bac
L2445:	.long	_FUN_06045c9c
L2446:	.long	_FUN_06045d80
L2448:	.long	_FUN_06045e44
L2449:	.long	_FUN_06046a20
L2450:	.long	_FUN_06045e06
	.global _FUN_06045bc4
	.align 2
_FUN_06045bc4:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2457,r1
	add	r11,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2453
	mov.l	L2458,r3
	jsr	@r3
	nop
L2453:
	mov.l	L2459,r3
	jsr	@r3
	nop
	mov	r12,r1
	add	#4,r1
	mov.l	@r1,r13
	cmp/ge	r13,r14
	bt	L2455
	mov.w	L2460,r1
	add	r11,r1
	mov.l	L2461,r3
	jsr	@r3
	mov.l	L2462,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2460,r4
	add	r11,r4
	mov.l	L2463,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2464,r1
	add	r11,r1
	mov.w	@r1,r2
	mov.w	L2462,r3
	add	r11,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2455:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2457:	.short	128
L2460:	.short	156
L2464:	.short	136
	.align 2
L2458:	.long	_FUN_06045c9c
L2459:	.long	_FUN_06045d04
L2461:	.long	_FUN_06045e44
L2462:	.long	_FUN_0604698c
L2463:	.long	_FUN_06045e06
	.global _FUN_06045bc6
	.align 2
_FUN_06045bc6:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2470,r1
	add	r11,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2466
	mov.l	L2471,r3
	jsr	@r3
	nop
L2466:
	mov.l	L2472,r3
	jsr	@r3
	nop
	mov	r12,r1
	add	#4,r1
	mov.l	@r1,r13
	cmp/ge	r13,r14
	bt	L2468
	mov.w	L2473,r1
	add	r11,r1
	mov.l	L2474,r3
	jsr	@r3
	mov.l	L2475,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2473,r4
	add	r11,r4
	mov.l	L2476,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2477,r1
	add	r11,r1
	mov.w	@r1,r2
	mov.w	L2475,r3
	add	r11,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2468:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2470:	.short	128
L2473:	.short	156
L2477:	.short	136
	.align 2
L2471:	.long	_FUN_06045c9c
L2472:	.long	_FUN_06045d04
L2474:	.long	_FUN_06045e44
L2475:	.long	_FUN_0604698c
L2476:	.long	_FUN_06045e06
	.global _FUN_06045c00
	.align 2
_FUN_06045c00:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2483,r1
	add	r11,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2479
	mov.l	L2484,r3
	jsr	@r3
	nop
L2479:
	mov.l	L2485,r3
	jsr	@r3
	nop
	mov	r12,r1
	add	#4,r1
	mov.l	@r1,r13
	cmp/ge	r13,r14
	bt	L2481
	mov.w	L2486,r1
	add	r11,r1
	mov.l	L2487,r3
	jsr	@r3
	mov.l	L2488,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2486,r4
	add	r11,r4
	mov.l	L2489,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2490,r1
	add	r11,r1
	mov.w	@r1,r2
	mov.w	L2488,r3
	add	r11,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2481:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2483:	.short	128
L2486:	.short	156
L2490:	.short	136
	.align 2
L2484:	.long	_FUN_06045c9c
L2485:	.long	_FUN_06045d80
L2487:	.long	_FUN_06045e44
L2488:	.long	_FUN_06046a20
L2489:	.long	_FUN_06045e06
	.global _FUN_06045c02
	.align 2
_FUN_06045c02:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2496,r1
	add	r11,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2492
	mov.l	L2497,r3
	jsr	@r3
	nop
L2492:
	mov.l	L2498,r3
	jsr	@r3
	nop
	mov	r12,r1
	add	#4,r1
	mov.l	@r1,r13
	cmp/ge	r13,r14
	bt	L2494
	mov.w	L2499,r1
	add	r11,r1
	mov.l	L2500,r3
	jsr	@r3
	mov.l	L2501,r3
	jsr	@r3
	mov.l	r14,@r1
	mov.w	L2499,r4
	add	r11,r4
	mov.l	L2502,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L2503,r1
	add	r11,r1
	mov.w	@r1,r2
	mov.w	L2501,r3
	add	r11,r3
	mov.b	@r3,r3
	mov	r2,r2
	add	r3,r2
	mov.w	r2,@r1
L2494:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L2496:	.short	128
L2499:	.short	156
L2503:	.short	136
	.align 2
L2497:	.long	_FUN_06045c9c
L2498:	.long	_FUN_06045d80
L2500:	.long	_FUN_06045e44
L2501:	.long	_FUN_06046a20
L2502:	.long	_FUN_06045e06
	.global _FUN_06045c3c
	.align 2
_FUN_06045c3c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	r4,r14
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	@(20,r15),r1
	mov.l	@r1,r9
	mov	#14,r1
	mov	r10,r2
	and	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	mov	#10,r2
	cmp/gt	r2,r1
	bt	L2515
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2508 - Lswt0
	.short	L2505 - Lswt0
	.short	L2509 - Lswt0
	.short	L2505 - Lswt0
	.short	L2510 - Lswt0
	.short	L2505 - Lswt0
	.short	L2511 - Lswt0
	.short	L2505 - Lswt0
	.short	L2512 - Lswt0
	.short	L2505 - Lswt0
	.short	L2513 - Lswt0
L2515:
	mov.l	@(0,r15),r1
	mov	r1,r0
	cmp/eq	#14,r0
	bt	L2514
	bra	L2505
	nop
	mov.l	@(16,r15),r1
	mov.l	@r1,r8
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(8,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(24,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r1
	add	#20,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#24,r1
	mov.l	@(24,r15),r2
	mov.l	r2,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r1
	mov.l	@r1,r8
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r9,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r1
	add	#24,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r1
	mov.l	@r1,r8
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r1
	add	#24,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r1
	mov.l	@r1,r8
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r1
	add	#20,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#24,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r1
	mov.l	@r1,r8
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r1
	add	#20,r1
	mov.l	@(28,r15),r2
	mov.l	r2,@r1
	mov	r11,r1
	add	#24,r1
	mov.l	r9,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov	r14,r1
	add	#28,r1
	mov	#14,r2
	mov	r10,r3
	and	r2,r3
	mov.l	r3,@r1
	mov	r9,r1
	exts.b	r1,r1
	mov.b	r1,@r13
	mov.l	L2518,r1
	jsr	@r1
	nop
L2514:
	mov.l	L2518,r1
	jsr	@r1
	nop
L2505:
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#1,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L2516
	mov.l	L2518,r1
	jsr	@r1
	nop
L2516:
	mov.l	L2518,r1
	jsr	@r1
	nop
L2504:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2518:	.long	_halt_baddata
	.global _FUN_06045c9c
	.align 2
_FUN_06045c9c:
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r9,r1
	add	#2,r1
	mov.w	@r1,r7
	mov	r8,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r7,r2
	sub	r2,r1
	exts.w	r1,r1
	mov.w	@r9,r2
	mov.w	@r10,r3
	sub	r3,r2
	exts.w	r2,r2
	mul.l	r2,r1
	sts	macl,r1
	mov.l	r1,@(4,r15)
	mov	r10,r1
	add	#2,r1
	mov.w	@r1,r6
	mov	r4,r1
	add	#-2,r1
	mov.w	@r8,r2
	mov.w	@r9,r3
	sub	r3,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#-4,r1
	mov	r6,r2
	mov	r7,r3
	sub	r3,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#-4,r1
	mov.l	@r1,r1
	exts.w	r1,r1
	mov	r4,r2
	add	#-2,r2
	mov.l	@r2,r2
	exts.w	r2,r2
	mul.l	r2,r1
	sts	macl,r1
	mov.l	r1,@(0,r15)
	mov	#-1,r1
	mov.l	@(0,r15),r2
	cmp/ge	r2,r1
	bf/s	L2523
	mov	#1,r7
L2522:
	mov	#0,r7
L2523:
	mov.l	@(4,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L2525
	mov	#1,r6
L2524:
	mov	#0,r6
L2525:
	mov	r7,r5
	add	r6,r5
	mov.l	@(4,r15),r1
	mov.l	@(0,r15),r2
	add	r2,r1
	mov.l	r1,@(0,r15)
	mov	#1,r1
	mov.l	@(8,r15),r1
	shlr	r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L2526
	mov.l	@(0,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L2533
	mov	#1,r7
L2532:
	mov	#0,r7
L2533:
	mov.l	@(4,r15),r1
	mov	#0,r2
	cmp/ge	r2,r1
	bf/s	L2535
	mov	#1,r6
L2534:
	mov	#0,r6
L2535:
	mov	r7,r1
	add	r6,r1
	exts.b	r1,r0
	cmp/eq	#1,r0
	bf	L2527
	exts.b	r5,r1
	tst	r1,r1
	bf	L2536
	mov.l	L2543,r1
	bra	L2527
	mov.l	r1,@(0,r15)
L2536:
	exts.b	r5,r0
	cmp/eq	#2,r0
	bf	L2527
	mov.l	L2544,r1
	bra	L2527
	mov.l	r1,@(0,r15)
L2526:
	mov.l	@(0,r15),r1
	mov.l	@(4,r15),r2
	cmp/ge	r2,r1
	bf/s	L2542
	mov	#1,r7
L2541:
	mov	#0,r7
L2542:
	add	r7,r1
	mov.l	r1,@(0,r15)
L2527:
	add	#12,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(0,r15),r0
	.align 2
L2543:	.short	2147483647
L2544:	.short	-2147483648
	.global _FUN_06045ccc
	.align 2
_FUN_06045ccc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	L2551,r14
	tst	r4,r4
	bt	L2546
	mov.l	L2552,r14
L2546:
	mov	#5,r11
	mov.l	L2553,r1
	mov.l	@r1,r12
L2548:
	mov	r14,r13
	mov.w	@r13,r1
	mov.w	r1,@r12
	add	#-1,r11
	add	#2,r12
	mov	r13,r14
	add	#2,r14
	tst	r11,r11
	bf	L2548
	mov.l	L2554,r1
	mov.l	@r1,r1
	mov.w	@(2,r13),r0
	mov	r0,r2
	mov.w	r2,@r1
	mov	r13,r0
	add	#4,r0
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2551:	.long	_DAT_06045cec
L2552:	.long	_DAT_06045cf8
L2553:	.long	_PTR_DAT_06045de0
L2554:	.long	_PTR_DAT_06045de4
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
	mov.l	@(4,r15),r1
	add	#4,r1
	mov.l	@r1,r11
	mov.l	@(4,r8),r12
	mov.l	@(4,r10),r13
	mov	#14,r1
	mov	r14,r2
	and	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	mov	#14,r2
	cmp/gt	r2,r1
	bt	L2556
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2569 - Lswt0
	.short	L2556 - Lswt0
	.short	L2570 - Lswt0
	.short	L2556 - Lswt0
	.short	L2559 - Lswt0
	.short	L2556 - Lswt0
	.short	L2566 - Lswt0
	.short	L2556 - Lswt0
	.short	L2567 - Lswt0
	.short	L2556 - Lswt0
	.short	L2568 - Lswt0
	.short	L2556 - Lswt0
	.short	L2569 - Lswt0
	.short	L2556 - Lswt0
	.short	L2570 - Lswt0
	bra	L2556
	nop
	cmp/ge	r11,r13
	bt	L2560
	mov	r11,r13
L2560:
	cmp/ge	r12,r13
	bt	L2562
	mov	r12,r13
L2562:
	mov.l	@(4,r9),r1
	cmp/ge	r1,r13
	bt	L2557
	mov.l	L2577,r0
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
	mov.l	L2577,r0
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
	mov.l	L2578,r3
	jsr	@r3
	nop
	mov.l	L2579,r1
	mov.l	@r1,r1
	mov	r1,r0
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
	mov.l	L2577,r1
	add	r9,r1
	mov	r13,r2
	mov.b	r2,@r1
	mov.l	L2580,r1
	jsr	@r1
	nop
	mov.l	L2577,r0
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
	bt	L2571
	mov	r11,r13
L2571:
	cmp/gt	r13,r12
	bt	L2573
	mov	r12,r13
L2573:
	mov.l	@(4,r9),r1
	cmp/gt	r13,r1
	bt	L2575
	mov.l	L2577,r0
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
L2575:
L2556:
L2557:
	mov.l	L2577,r0
L2555:
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
L2577:	.long	_switchD_06045d12__switchdataD_06045df0
L2578:	.long	_FUN_06045D3C
L2579:	.long	_DAT_06045de8
L2580:	.long	_halt_baddata
	.global _FUN_06045D3C
	.align 2
_FUN_06045D3C:
	cmp/ge	r7,r4
	bt	L2582
	mov	r7,r4
L2582:
	cmp/ge	r6,r4
	bt	L2584
	mov	r6,r4
L2584:
	cmp/ge	r5,r4
L2581:
	rts
	nop
	.global _FUN_06045D6A
	.align 2
_FUN_06045D6A:
	sts.l	pr,@-r15
	mov.l	L2589,r3
	jsr	@r3
	nop
	mov.l	L2590,r1
	mov.l	@r1,r1
	lds.l	@r15+,pr
	rts
	mov	r1,r0
	.align 2
L2589:	.long	_caseD_4
L2590:	.long	_DAT_06045de8
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
	mov.l	@(8,r15),r1
	add	#4,r1
	mov.l	@r1,r9
	mov	#14,r1
	mov	r14,r2
	and	r1,r2
	mov.l	L2611,r1
	add	r2,r1
	mov.w	@r1,r1
	mov	r1,r13
	mov.l	@(4,r8),r10
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	mov	#14,r2
	cmp/gt	r2,r1
	bt	L2592
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2595 - Lswt0
	.short	L2592 - Lswt0
	.short	L2596 - Lswt0
	.short	L2592 - Lswt0
	.short	L2601 - Lswt0
	.short	L2592 - Lswt0
	.short	L2606 - Lswt0
	.short	L2592 - Lswt0
	.short	L2607 - Lswt0
	.short	L2592 - Lswt0
	.short	L2608 - Lswt0
	.short	L2592 - Lswt0
	.short	L2609 - Lswt0
	.short	L2592 - Lswt0
	.short	L2610 - Lswt0
	bra	L2592
	nop
	mov.l	L2612,r1
	mov.l	@r1,r1
	mov	r1,r0
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
L2612:	.short	-2147483648
	mov	r9,r1
	mov	r10,r2
	cmp/gt	r2,r1
	bt	L2597
	mov	r9,r10
L2597:
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	mov	r10,r2
	cmp/gt	r2,r1
	bt	L2593
	mov.l	L2611,r0
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
	mov	r10,r1
	mov	r9,r2
	cmp/ge	r2,r1
	bt	L2602
	mov	r9,r10
L2602:
	mov	r10,r1
	mov.l	@(12,r15),r2
	add	#4,r2
	mov.l	@r2,r2
	cmp/ge	r2,r1
	bt	L2593
	mov.l	L2611,r0
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
	mov.l	L2611,r0
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
L2611:	.short	2147483647
	mov.l	L2613,r3
	jsr	@r3
	nop
	mov.l	L2614,r1
	mov.l	@r1,r1
	mov	r1,r0
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
L2614:	.short	156
	mov.l	@(4,r15),r1
	mov.w	L2615,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2616,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2617,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2618,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2619,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2620,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2621,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2613,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2622,r2
	add	r2,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	add	#120,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	add	#92,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	add	#68,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	add	#44,r1
	mov.l	L2630,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	add	#16,r1
	mov.l	L2630,r2
	mov.l	L2623,r1
	mov.l	r2,@r1
	jsr	@r1
	nop
	mov.l	L2624,r2
	add	r9,r2
	mov	#93,r1
	mov.b	r1,@r2
	mov.l	L2625,r2
	add	r9,r2
	mov	#-4,r1
	mov.b	r1,@r2
	mov.l	L2630,r1
	mov.b	@r13,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2630,r2
	mov.l	L2627,r3
	mov	r13,r3
	and	r3,r3
	shlr8	r3
	extu.b	r13,r4
	shll8	r4
	or	r4,r3
	mov.l	L2628,r4
	mov	r13,r1
	and	r4,r1
	or	r1,r3
	mov	r2,r1
	add	r3,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2630,r1
	mov	r13,r2
	extu.b	r2,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov	r12,r13
	add	#1,r13
	mov.l	L2635,r1
	mov.b	@r12,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r1
	mov.b	@r13,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r1
	mov.b	@r11,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r2
	mov.l	L2627,r3
	mov	r13,r3
	and	r3,r3
	shlr8	r3
	extu.b	r13,r4
	shll8	r4
	or	r4,r3
	mov.l	L2628,r4
	mov	r13,r1
	and	r4,r1
	or	r1,r3
	mov	r2,r1
	add	r3,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r1
	mov	r13,r2
	extu.b	r2,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov	r11,r13
	add	#1,r13
	mov.l	L2635,r1
	mov.b	@r11,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r1
	mov.b	@r10,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r2
	mov.l	L2627,r3
	mov	r13,r3
	and	r3,r3
	shlr8	r3
	extu.b	r13,r4
	shll8	r4
	or	r4,r3
	mov.l	L2628,r4
	mov	r13,r1
	and	r4,r1
	or	r1,r3
	mov	r2,r1
	add	r3,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov.l	L2635,r1
	mov	r13,r2
	extu.b	r2,r2
	add	r2,r1
	mov.w	L2626,r2
	mov.w	r2,@r1
	mov	r10,r13
	add	#1,r13
	mov.l	L2635,r1
	mov.b	@r10,r2
	add	r2,r1
	mov.w	L2632,r2
	mov.w	r2,@r1
	mov.l	L2635,r2
	mov.l	L2633,r3
	mov	r13,r3
	and	r3,r3
	shlr8	r3
	extu.b	r13,r4
	shll8	r4
	or	r4,r3
	mov.l	L2634,r4
	mov	r13,r1
	and	r4,r1
	or	r1,r3
	mov	r2,r1
	add	r3,r1
	mov.w	L2632,r2
	mov.l	L2631,r1
	mov.w	r2,@r1
	jsr	@r1
	nop
	mov.l	@(4,r15),r1
	add	#18,r1
	mov.l	L2629,r2
	mov.l	L2631,r1
	mov.w	r2,@r1
	jsr	@r1
	nop
L2592:
L2593:
	mov.l	L2636,r0
L2591:
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
L2615:	.short	356
L2616:	.short	328
L2617:	.short	300
L2618:	.short	276
L2619:	.short	248
L2620:	.short	220
L2621:	.short	196
L2622:	.short	144
L2624:	.short	100949500
L2625:	.short	100949501
L2626:	.short	24060
L2627:	.short	65280
L2628:	.short	-65536
L2629:	.short	42160
L2632:	.short	24060
L2633:	.short	65280
L2634:	.short	-65536
	.align 2
L2613:	.long	_FUN_06045DAA
L2623:	.long	_halt_baddata
L2630:	.long	_switchD_06045d8c__switchdataD_06045dfc
L2631:	.long	_halt_baddata
L2635:	.long	_switchD_06045d8c__switchdataD_06045dfc
L2636:	.long	_switchD_06045d8c__switchdataD_06045dfc
	.global _FUN_06045DAA
	.align 2
_FUN_06045DAA:
	cmp/ge	r6,r4
	bt	L2638
	mov	r6,r4
L2638:
	cmp/ge	r5,r4
L2637:
	rts
	nop
	.global _FUN_06045DCC
	.align 2
_FUN_06045DCC:
	sts.l	pr,@-r15
	mov.l	L2643,r3
	jsr	@r3
	nop
	mov.l	L2644,r1
	mov.l	@r1,r1
	lds.l	@r15+,pr
	rts
	mov	r1,r0
	.align 2
L2643:	.long	_caseD_4
L2644:	.long	_DAT_06045de8
	.global _FUN_06045e06
	.align 2
_FUN_06045e06:
	mov.l	@(32,r5),r1
	mov	r4,r2
	shlr8	r2
	shlr2	r2
	mov.w	L2648,r3
	and	r3,r2
	add	r2,r1
	mov	r1,r6
	mov.w	@r6,r1
	tst	r1,r1
	bt	L2646
	mov.l	L2649,r1
	mov.l	@r1,r1
	mov	r6,r2
	add	#2,r2
	mov.w	@r2,r2
	shll2	r2
	shll	r2
	add	r2,r1
	add	#2,r1
	mov.w	r7,@r1
	mov.w	L2650,r1
	add	r11,r1
	mov.b	@r1,r1
	add	#-4,r1
	exts.w	r7,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(2,r6)
	rts
	nop
L2646:
	mov.w	r7,@r6
	mov.w	L2650,r1
	add	r11,r1
	mov.b	@r1,r1
	add	#-4,r1
	exts.w	r7,r2
	add	r2,r1
	mov	r1,r0
L2645:
	rts
	mov.w	r0,@(2,r6)
	.align 2
L2648:	.short	-8
L2650:	.short	155
L2649:	.long	_DAT_06045e40
	.global _FUN_06045e44
	.align 2
_FUN_06045e44:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L2664,r1
	mov.l	@r1,r1
	mov	r14,r2
	shll2	r2
	shll	r2
	add	r2,r1
	mov	r1,r10
	mov.w	L2665,r1
	add	r8,r1
	mov.w	@r1,r1
	shlr2	r1
	shlr2	r1
	mov	#30,r2
	and	r2,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r1
	mov	#12,r2
	mov	r1,r0
	cmp/eq	#12,r0
	bt	L2659
	cmp/gt	r2,r1
	bt	L2662
	mov.l	@(0,r15),r1
	mov	#8,r2
	cmp/gt	r2,r1
	bt	L2652
L2662:
	mov.l	@(0,r15),r1
	mov	#24,r2
	cmp/gt	r2,r1
	bt	L2663
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L2660 - Lswt0
	.short	L2652 - Lswt0
	.short	L2660 - Lswt0
	.short	L2652 - Lswt0
	.short	L2656 - Lswt0
	.short	L2652 - Lswt0
	.short	L2656 - Lswt0
	.short	L2652 - Lswt0
	.short	L2660 - Lswt0
L2663:
	mov.l	@(0,r15),r1
	mov	r1,r0
	cmp/eq	#28,r0
	bt	L2653
	bra	L2652
	nop
L2652:
	mov.w	L2666,r1
	add	r8,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.w	r0,@(6,r10)
	mov.w	L2667,r1
	add	r8,r1
	mov.w	@r1,r1
	mov.w	r1,@r10
	mov.w	L2668,r1
	add	r8,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov.l	L2669,r2
	mov.l	@r2,r2
	or	r2,r1
	mov	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2670,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L2671,r1
	mov.l	@r1,r1
	exts.w	r13,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(28,r10)
	mov.w	L2666,r1
	add	r8,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.w	r0,@(6,r10)
	mov.w	L2667,r1
	add	r8,r1
	mov.w	@r1,r1
	mov.w	r1,@r10
	mov.w	L2668,r1
	add	r8,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov.l	L2672,r2
	mov.l	@r2,r2
	or	r2,r1
	mov	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2670,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L2671,r1
	mov.l	@r1,r1
	exts.w	r11,r2
	add	r2,r1
	mov	r1,r0
	bra	L2653
	mov.w	r0,@(28,r10)
	mov.w	L2666,r1
	add	r8,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.w	r0,@(6,r10)
	mov.w	L2667,r1
	add	r8,r1
	mov.w	@r1,r1
	mov.w	r1,@r10
	mov.w	L2668,r1
	add	r8,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov.l	L2672,r2
	mov.l	@r2,r2
	or	r2,r1
	mov	r1,r0
	mov.l	L2673,r3
	jsr	@r3
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2659:
	mov.l	L2673,r3
	jsr	@r3
	nop
	bra	L2653
	nop
	mov.w	L2677,r1
	add	r8,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.w	r0,@(6,r10)
	mov.w	L2678,r1
	add	r8,r1
	mov.w	@r1,r1
	mov.w	r1,@r10
	mov.w	L2679,r1
	add	r8,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov.l	L2674,r2
	mov.l	@r2,r2
	or	r2,r1
	mov	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2653:
	mov.l	@(40,r9),r1
	mov.w	L2677,r2
	add	r8,r2
	mov.w	@r2,r2
	add	r2,r1
	mov	r1,r12
	mov.w	L2679,r1
	add	r8,r1
	mov.l	@r1,r1
	mov.l	@r12,r2
	or	r2,r1
	mov.l	r1,@(4,r10)
	mov.l	@(4,r12),r1
	mov.l	r1,@(8,r10)
	mov.l	L2675,r1
	mov.l	@r1,r1
	mov.w	L2676,r2
	add	r8,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	mov	#48,r3
	and	r3,r2
	or	r2,r1
L2651:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r10
	.align 2
L2665:	.short	128
L2666:	.short	130
L2667:	.short	146
L2668:	.short	148
L2676:	.short	128
L2677:	.short	130
L2678:	.short	146
L2679:	.short	148
L2664:	.long	_DAT_06045f20
L2669:	.long	_DAT_06045f16
L2670:	.long	_FUN_06045fc0
L2671:	.long	_DAT_06045f1a
L2672:	.long	_DAT_06045f1c
L2673:	.long	_FUN_06045f46
L2674:	.long	_DAT_06045f18
L2675:	.long	_DAT_06045f26
	.global _FUN_06045EA8
	.align 2
_FUN_06045EA8:
	sts.l	pr,@-r15
	mov.l	L2681,r3
	jsr	@r3
	mov.l	@(44,r12),r4
	mov.l	L2682,r1
	mov.l	@r1,r1
	exts.w	r14,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(28,r13)
	mov.w	L2683,r1
	add	r11,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.w	r0,@(6,r13)
	mov.w	L2684,r1
	add	r11,r1
	mov.w	@r1,r1
	mov.w	r1,@r13
	mov.w	L2685,r1
	add	r11,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov.l	L2686,r2
	mov.l	@r2,r2
	or	r2,r1
	mov	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(4,r13)
	.align 2
L2683:	.short	130
L2684:	.short	146
L2685:	.short	148
	.align 2
L2681:	.long	_FUN_06045fc0
L2682:	.long	_DAT_06045f1a
L2686:	.long	_DAT_06045f1c
	.global _FUN_06045EC8
	.align 2
_FUN_06045EC8:
	mov.l	@(40,r5),r1
	mov.w	L2688,r2
	add	r4,r2
	mov.w	@r2,r2
	add	r2,r1
	mov	r1,r7
	mov.w	L2689,r1
	add	r4,r1
	mov.l	@r1,r1
	mov.l	@r7,r2
	or	r2,r1
	mov.l	r1,@(4,r6)
	mov.l	@(4,r14),r1
	mov.l	r1,@(8,r6)
	mov.l	L2690,r1
	mov.l	@r1,r1
	mov.w	L2691,r2
	add	r4,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	mov	#48,r3
	and	r3,r2
	or	r2,r1
	rts
	mov.w	r1,@r6
	.align 2
L2688:	.short	130
L2689:	.short	148
L2691:	.short	128
	.align 2
L2690:	.long	_DAT_06045f26
	.global _FUN_06045EE8
	.align 2
_FUN_06045EE8:
	sts.l	pr,@-r15
	mov.l	L2693,r3
	jsr	@r3
	mov.l	@(44,r11),r4
	mov.l	L2694,r1
	mov.l	@r1,r1
	exts.w	r13,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(28,r12)
	mov.l	@(40,r11),r1
	mov.w	L2693,r2
	add	r10,r2
	mov.w	@r2,r2
	add	r2,r1
	mov	r1,r14
	mov.w	L2694,r1
	add	r10,r1
	mov.l	@r1,r1
	mov.l	@r14,r2
	or	r2,r1
	mov.l	r1,@(4,r12)
	mov.l	@(4,r14),r1
	mov.l	r1,@(8,r12)
	mov.l	L2695,r1
	mov.l	@r1,r1
	mov.w	L2696,r2
	add	r10,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	mov	#48,r3
	and	r3,r2
	or	r2,r1
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r12
	.align 2
L2696:	.short	128
	.align 2
L2693:	.long	_FUN_06045fc0
L2694:	.long	_DAT_06045f1a
L2695:	.long	_DAT_06045f26
	.global _FUN_06045F0C
	.align 2
_FUN_06045F0C:
	sts.l	pr,@-r15
	mov.l	L2698,r3
	jsr	@r3
	nop
	mov.l	@(40,r12),r1
	mov.w	L2698,r2
	add	r11,r2
	mov.w	@r2,r2
	add	r2,r1
	mov	r1,r14
	mov.w	L2699,r1
	add	r11,r1
	mov.l	@r1,r1
	mov.l	@r14,r2
	or	r2,r1
	mov.l	r1,@(4,r13)
	mov.l	@(4,r14),r1
	mov.l	r1,@(8,r13)
	mov.l	L2700,r1
	mov.l	@r1,r1
	mov.w	L2701,r2
	add	r11,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	mov	#48,r3
	and	r3,r2
	or	r2,r1
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r13
	.align 2
L2699:	.short	148
L2701:	.short	128
L2698:	.long	_FUN_06045f46
L2700:	.long	_DAT_06045f26
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
	mov.l	@(0,r15),r1
	mov.w	L2714,r2
	add	r2,r1
	mov.w	@r1,r8
	mov	r11,r1
	add	#28,r1
	mov.w	r8,@r1
	mov.l	@(0,r15),r1
	mov.w	L2714,r2
	add	r2,r1
	mov	r8,r2
	add	#1,r2
	mov.w	r2,@r1
	mov	r8,r1
	shll2	r1
	shll	r1
	mov.l	L2715,r2
	mov.l	@r2,r2
	add	r2,r1
	mov.l	r1,@(36,r15)
	mov.l	@(0,r15),r1
	mov.w	L2716,r2
	add	r2,r1
	mov.b	@r1,r1
	mov	#14,r2
	and	r2,r1
	mov.l	r1,@(32,r15)
	mov.l	@(20,r15),r1
	add	#8,r1
	mov.w	@r1,r9
	mov.l	@(32,r15),r1
	mov	#14,r2
	cmp/gt	r2,r1
	bt	L2703
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
	.align 2
L2714:	.short	144
Lswt0:
	.short	L2705 - Lswt0
	.short	L2703 - Lswt0
	.short	L2706 - Lswt0
	.short	L2703 - Lswt0
	.short	L2707 - Lswt0
	.short	L2703 - Lswt0
	.short	L2708 - Lswt0
	.short	L2703 - Lswt0
	.short	L2709 - Lswt0
	.short	L2703 - Lswt0
	.short	L2710 - Lswt0
	.short	L2703 - Lswt0
	.short	L2711 - Lswt0
	.short	L2703 - Lswt0
	.short	L2713 - Lswt0
	bra	L2703
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(8,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
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
	mov.l	@(16,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(16,r15),r1
	add	#8,r1
	mov.w	@r1,r9
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	@(12,r15),r1
	add	#8,r1
	mov.w	@r1,r9
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
	mov.l	@(16,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r2
	add	#8,r2
	mov.w	@r2,r2
	mov	r2,r0
	mov.w	r0,@(4,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(32,r15),r1
	add	#20,r1
	mov.l	@(24,r15),r2
	mov.l	L2717,r1
	mov.l	r2,@r1
	jsr	@r1
	nop
	mov.l	@(24,r15),r1
	exts.b	r1,r1
	mov.b	r1,@r13
	mov.l	L2718,r1
	mov.l	@r1,r1
	mov.l	L2719,r2
	mov.l	@r2,r2
	mov.l	@(12,r15),r3
	add	r3,r2
	mov.l	r2,@r1
	mov.l	@(4,r15),r1
	mov.l	r1,@(8,r12)
	mov.l	L2720,r1
	mov.l	@r1,r1
	mov.l	r1,@(40,r15)
	mov.l	L2721,r1
	mov.l	@r1,r1
	mov.l	@(12,r15),r2
	mov.l	r2,@r1
	mov.l	@(52,r15),r1
	mov.l	@(40,r15),r2
	add	r2,r1
	mov.l	r1,@(28,r15)
	mov.l	@(28,r15),r1
	mov	r15,r2
	add	#64,r2
	mov.w	@r2,r2
	extu.w	r2,r2
	mov.w	r2,@r1
	mov.w	@(4,r12),r0
	mov.l	@(28,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(28,r15),r1
	mov	r15,r2
	add	#64,r2
	mov.w	@r2,r2
	extu.w	r2,r2
	extu.w	r2,r2
	extu.w	r10,r3
	not	r3,r3
	and	r3,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov	#6,r1
	exts.b	r14,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	mov.l	L2722,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r15,r2
	add	#66,r2
	mov.b	@r2,r2
	extu.b	r2,r2
	mov.b	r2,@r1
	mov.l	@(28,r15),r1
	mov.l	@(60,r15),r2
	mov.l	r2,@(8,r1)
	mov.l	@(60,r15),r1
	mov.l	r1,@r12
	mov	r15,r1
	add	#64,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r12)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L2717,r1
	jsr	@r1
	nop
L2703:
L2702:
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2716:	.short	128
	.align 2
L2715:	.long	_DAT_06045fb0
L2717:	.long	_halt_baddata
L2718:	.long	_DAT_06044634
L2719:	.long	_DAT_06044630
L2720:	.long	_DAT_06044640
L2721:	.long	_DAT_0604463c
L2722:	.long	_DAT_06044644
	.global _FUN_06046602
	.align 2
_FUN_06046602:
	sts.l	pr,@-r15
	mov.l	@(16,r13),r1
	tst	r1,r1
	bt	L2723
	mov.w	@r13,r1
	mov	r1,r14
	mov	r10,r1
	add	#28,r1
	mov.l	@r1,r11
L2726:
	mov.l	L2729,r1
	jsr	@r1
	nop
	mov.l	L2730,r3
	jsr	@r3
	mov.l	@(44,r10),r4
	mov	r11,r1
	add	#8,r1
	mov	r12,r2
	shll	r2
	shll2	r2
	mov.l	L2731,r3
	add	r3,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	dt	r14
	add	#16,r11
	bf	L2726
L2723:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2729:	.long	_FUN_06045af4
L2730:	.long	_FUN_06045fc0
L2731:	.long	_DAT_06046658
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
	mov.w	@r10,r1
	mov	r1,r9
	mov	r13,r1
	add	#28,r1
	mov.l	@r1,r12
L2733:
	mov.l	L2736,r1
	jsr	@r1
	nop
	mov.l	L2737,r3
	jsr	@r3
	mov.l	@(44,r13),r4
	mov	r11,r1
	shll	r1
	shll2	r1
	mov.l	L2738,r2
	add	r2,r1
	mov.w	@r1,r8
	mov	r12,r1
	add	#8,r1
	mov.w	r8,@r1
	dt	r9
	add	#16,r12
	bf	L2733
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
L2736:	.long	_FUN_06045af4
L2737:	.long	_FUN_06045fc0
L2738:	.long	_DAT_06046658
	.global _FUN_0604669e
	.align 2
_FUN_0604669e:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2749,r1
	jsr	@r1
	mov	r6,r12
	mov.l	@(0,r15),r1
	mov.w	L2750,r2
	add	r2,r1
	mov.l	L2751,r2
	mov.l	@r2,r2
	extu.w	r2,r2
	extu.w	r12,r3
	or	r3,r2
	mov.w	r2,@r1
	mov.l	@(0,r15),r1
	mov.w	L2752,r2
	add	r2,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2739
	mov.l	L2753,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L2754,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r1
	mov.l	@(8,r1),r2
	add	r1,r2
	mov	r2,r1
	mov	r1,r9
L2742:
	mov.l	@(0,r15),r1
	mov.w	L2752,r2
	add	r2,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2745
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2745:
	mov.w	@r9,r11
	mov.l	@(0,r15),r1
	mov.w	L2751,r2
	add	r2,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2747
	mov.l	L2755,r3
	jsr	@r3
	nop
	bra	L2748
	nop
L2747:
	mov.l	L2756,r3
	jsr	@r3
	nop
L2748:
	mov.l	@(0,r15),r1
	mov.w	L2757,r2
	add	r2,r1
	mov.w	@r1,r2
	mov	r2,r2
	add	#-1,r2
	mov.w	r2,@r1
	tst	r10,r10
	bf	L2742
L2739:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2750:	.short	130
L2752:	.short	136
L2757:	.short	142
	.align 2
L2749:	.long	_FUN_060459c4
L2751:	.long	_uRam06046700
L2753:	.long	_pcRam06046704
L2754:	.long	_pcRam06046708
L2755:	.long	_FUN_0604670c
L2756:	.long	_FUN_0604674e
	.global _FUN_060466a0
	.align 2
_FUN_060466a0:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2768,r1
	jsr	@r1
	mov	r6,r12
	mov.l	@(0,r15),r1
	mov.w	L2769,r2
	add	r2,r1
	mov.l	L2770,r2
	mov.l	@r2,r2
	extu.w	r2,r2
	extu.w	r12,r3
	or	r3,r2
	mov.w	r2,@r1
	mov.l	@(0,r15),r1
	mov.w	L2771,r2
	add	r2,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2758
	mov.l	L2772,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L2773,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r1
	mov.l	@(8,r1),r2
	add	r1,r2
	mov	r2,r1
	mov	r1,r9
L2761:
	mov.l	@(0,r15),r1
	mov.w	L2771,r2
	add	r2,r1
	mov.l	@r1,r1
	extu.w	r1,r2
	shlr16	r1
	cmp/hi	r1,r2
	bt	L2764
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2764:
	mov.w	@r9,r11
	mov.l	@(0,r15),r1
	mov.w	L2770,r2
	add	r2,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2766
	mov.l	L2774,r3
	jsr	@r3
	nop
	bra	L2767
	nop
L2766:
	mov.l	L2775,r3
	jsr	@r3
	nop
L2767:
	mov.l	@(0,r15),r1
	mov.w	L2776,r2
	add	r2,r1
	mov.w	@r1,r2
	mov	r2,r2
	add	#-1,r2
	mov.w	r2,@r1
	tst	r10,r10
	bf	L2761
L2758:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2769:	.short	130
L2771:	.short	136
L2776:	.short	142
	.align 2
L2768:	.long	_FUN_060459c4
L2770:	.long	_uRam06046700
L2772:	.long	_pcRam06046704
L2773:	.long	_pcRam06046708
L2774:	.long	_FUN_0604670c
L2775:	.long	_func_0x0604674e
	.global _FUN_0604670c
	.align 2
_FUN_0604670c:
	sts.l	pr,@-r15
	mov.l	L2782,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r1
	mov.l	@(4,r12),r2
	or	r2,r1
	mov.l	@(4,r11),r2
	or	r2,r1
	mov.l	@(4,r10),r2
	mov	r1,r14
	or	r2,r14
	mov	#2,r1
	mov	r14,r2
	and	r1,r2
	tst	r2,r2
	bf	L2778
	mov.w	L2783,r1
	add	r9,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2780
	mov.l	L2784,r3
	jsr	@r3
	nop
L2780:
	mov.l	L2785,r1
	jsr	@r1
	nop
	mov.l	L2786,r1
	jsr	@r1
	nop
	mov.l	L2787,r3
	jsr	@r3
	nop
	mov.w	L2788,r1
	add	r9,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	L2789,r1
	jsr	@r1
	nop
	mov.w	L2785,r1
	add	r9,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
L2778:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2783:	.short	128
L2788:	.short	155
L2782:	.long	_func_0x06045ac0
L2784:	.long	_FUN_06045c9c
L2785:	.long	_FUN_06045e44
L2786:	.long	_FUN_06045c3c
L2787:	.long	_FUN_06045d04
L2789:	.long	_FUN_06045e06
	.global _FUN_0604674e
	.align 2
_FUN_0604674e:
	sts.l	pr,@-r15
	mov.l	L2795,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r1
	mov.l	@(4,r12),r2
	or	r2,r1
	mov.l	@(4,r11),r2
	mov	r1,r14
	or	r2,r14
	mov	#2,r1
	mov	r14,r2
	and	r1,r2
	tst	r2,r2
	bf	L2791
	mov.w	L2796,r1
	add	r10,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	mov	#16,r2
	and	r2,r1
	tst	r1,r1
	bt	L2793
	mov.l	L2797,r3
	jsr	@r3
	nop
L2793:
	mov.l	L2798,r1
	jsr	@r1
	nop
	mov.l	L2799,r1
	jsr	@r1
	nop
	mov.l	L2800,r3
	jsr	@r3
	nop
	mov.w	L2801,r1
	add	r10,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	L2802,r1
	jsr	@r1
	nop
	mov.w	L2798,r1
	add	r10,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
L2791:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2796:	.short	128
L2801:	.short	155
L2795:	.long	_FUN_06045adc
L2797:	.long	_FUN_06045c9c
L2798:	.long	_FUN_06045e44
L2799:	.long	_FUN_06045c3c
L2800:	.long	_FUN_06045d80
L2802:	.long	_FUN_06045e06
	.global _FUN_060467b2
	.align 2
_FUN_060467b2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2810,r1
	mov.l	@r1,r12
	mov.l	L2811,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L2804
	mov.l	L2812,r1
	mov.l	@r1,r12
L2804:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2813,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov.w	L2814,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#1,r2
	mov.w	r2,@r1
	mov	r12,r1
	add	#40,r1
	mov.l	@(12,r13),r2
	add	r13,r2
	add	#8,r2
	mov.l	r2,@r1
	mov.w	L2815,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2803
	mov.l	L2816,r3
	jsr	@r3
	nop
	mov.w	L2815,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2803
	mov.l	@(48,r12),r1
	mov.w	L2811,r2
	add	r12,r2
	mov.l	@(8,r1),r3
	add	r1,r3
	mov	r3,r1
	mov.l	@r1,r1
	mov.l	L2817,r3
	jsr	@r3
L2803:
	lds.l	@r15+,pr
	rts
	mov.l	r1,@r2
	.align 2
L2813:	.short	168
L2814:	.short	170
L2815:	.short	136
	.align 2
L2810:	.long	_DAT_060468a4
L2811:	.long	__DAT_ffffffe2
L2812:	.long	_DAT_060468a8
L2816:	.long	_FUN_0604680c
L2817:	.long	_FUN_06045a2c
	.global _FUN_060467b4
	.align 2
_FUN_060467b4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2825,r1
	mov.l	@r1,r12
	mov.l	L2826,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L2819
	mov.l	L2827,r1
	mov.l	@r1,r12
L2819:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2828,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov.w	L2829,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#1,r2
	mov.w	r2,@r1
	mov	r12,r1
	add	#40,r1
	mov.l	@(12,r13),r2
	add	r13,r2
	add	#8,r2
	mov.l	r2,@r1
	mov.w	L2830,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2818
	mov.l	L2831,r3
	jsr	@r3
	nop
	mov.w	L2830,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2818
	mov.l	@(48,r12),r1
	mov.w	L2826,r2
	add	r12,r2
	mov.l	@(8,r1),r3
	add	r1,r3
	mov	r3,r1
	mov.l	@r1,r1
	mov.l	L2832,r3
	jsr	@r3
	mov.l	r1,@r2
L2818:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2828:	.short	168
L2829:	.short	170
L2830:	.short	136
	.align 2
L2825:	.long	_DAT_060468a4
L2826:	.long	__DAT_ffffffe2
L2827:	.long	_DAT_060468a8
L2831:	.long	_func_0x0604680c
L2832:	.long	_func_0x06045a2c
	.global _FUN_060468ae
	.align 2
_FUN_060468ae:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2840,r1
	mov.l	@r1,r12
	mov.l	L2841,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L2834
	mov.l	L2842,r1
	mov.l	@r1,r12
L2834:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2843,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov.w	L2844,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#1,r2
	mov.w	r2,@r1
	mov	r12,r1
	add	#40,r1
	mov.l	@(12,r13),r2
	add	r13,r2
	add	#8,r2
	mov.l	r2,@r1
	mov.w	L2845,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2833
	mov.l	L2846,r3
	jsr	@r3
	nop
	mov.w	L2845,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2833
	mov.l	@(48,r12),r1
	mov.w	L2841,r2
	add	r12,r2
	mov.l	@(8,r1),r3
	add	r1,r3
	mov	r3,r1
	mov.l	@r1,r1
	mov.l	L2847,r3
	jsr	@r3
L2833:
	lds.l	@r15+,pr
	rts
	mov.l	r1,@r2
	.align 2
L2843:	.short	168
L2844:	.short	170
L2845:	.short	136
	.align 2
L2840:	.long	_iRam06046984
L2841:	.long	__DAT_ffffffe2
L2842:	.long	_iRam06046988
L2846:	.long	_FUN_06046908
L2847:	.long	_FUN_06045a2c
	.global _FUN_060468b0
	.align 2
_FUN_060468b0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2855,r1
	mov.l	@r1,r12
	mov.l	L2856,r1
	mov.l	@r1,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L2849
	mov.l	L2857,r1
	mov.l	@r1,r12
L2849:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L2858,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#4,r2
	mov.w	r2,@r1
	mov.w	L2859,r1
	add	r12,r1
	mov.w	@r1,r2
	add	#1,r2
	mov.w	r2,@r1
	mov	r12,r1
	add	#40,r1
	mov.l	@(12,r13),r2
	add	r13,r2
	add	#8,r2
	mov.l	r2,@r1
	mov.w	L2860,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2848
	mov.l	L2861,r3
	jsr	@r3
	nop
	mov.w	L2860,r1
	add	r12,r1
	mov.l	@r1,r1
	mov	r1,r2
	shlr16	r2
	extu.w	r1,r1
	cmp/hs	r1,r2
	bt	L2848
	mov.l	@(48,r12),r1
	mov.w	L2856,r2
	add	r12,r2
	mov.l	@(8,r1),r3
	add	r1,r3
	mov	r3,r1
	mov.l	@r1,r1
	mov.l	L2862,r3
	jsr	@r3
	mov.l	r1,@r2
L2848:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2858:	.short	168
L2859:	.short	170
L2860:	.short	136
	.align 2
L2855:	.long	_iRam06046984
L2856:	.long	__DAT_ffffffe2
L2857:	.long	_iRam06046988
L2861:	.long	_func_0x06046908
L2862:	.long	_func_0x06045a2c
	.global _FUN_0604698c
	.align 2
_FUN_0604698c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	#64,r1
	mov	r13,r2
	and	r1,r2
	tst	r2,r2
	bf	L2865
	mov	#1,r1
	bra	L2866
	mov.l	r1,@(0,r15)
L2865:
	mov	#0,r1
	mov.l	r1,@(0,r15)
L2866:
	mov.l	@(0,r15),r14
	mov	r14,r1
	tst	r14,r14
	bt/s	L2867
	mov.l	r1,@(12,r15)
	mov.l	L2875,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r12
	mov	r12,r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2867:
	mov.l	L2876,r3
	jsr	@r3
	nop
	mov.l	L2877,r3
	jsr	@r3
	nop
	mov.l	@(12,r15),r1
	mov	r1,r2
	mov	r2,r0
	mov.b	r0,@(11,r15)
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2869
	mov	r8,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2878,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov.w	L2879,r2
	add	r2,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	@(28,r15),r1
	mov.l	@r1,r12
	mov.l	@(24,r15),r1
	mov.l	@r1,r11
	mov.l	@(20,r15),r1
	mov.l	@r1,r10
	mov.l	@(16,r15),r1
	mov.l	@r1,r9
	mov.l	r12,@(12,r8)
	mov.l	r11,@(16,r8)
	mov.l	r10,@(20,r8)
	mov	r8,r1
	add	#24,r1
	mov.l	r9,@r1
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2869:
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov	#1,r1
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L2871
	mov	r12,r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2871:
	mov.l	L2881,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#1,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L2873
	mov.l	L2882,r3
	jsr	@r3
	nop
	mov.l	L2882,r3
	jsr	@r3
	nop
	mov.l	L2882,r3
	jsr	@r3
	nop
	mov.l	L2882,r3
	jsr	@r3
	nop
	mov.l	L2883,r3
	jsr	@r3
	mov	#4,r4
	mov	r0,r1
	mov	r1,r12
	mov	r12,r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2873:
	mov.l	@(4,r15),r1
	mov.w	L2879,r2
	add	r2,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	@(16,r15),r4
	mov.l	L2884,r3
	jsr	@r3
	mov.l	@r4,r4
	mov	r0,r1
	mov	r1,r12
L2863:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2878:	.short	249
L2879:	.short	155
L2875:	.long	_FUN_06046a90
L2876:	.long	_FUN_06046b70
L2877:	.long	_FUN_06046bf4
L2880:	.long	_FUN_06046bd4
L2881:	.long	_FUN_06046c14
L2882:	.long	_FUN_06046b3c
L2883:	.long	_func_0x06046e0e
L2884:	.long	_FUN_06047588
	.global _FUN_06046990
	.align 2
_FUN_06046990:
	sts.l	pr,@-r15
	add	#-20,r15
	mov.l	L2892,r3
	jsr	@r3
	nop
	mov.l	L2893,r3
	jsr	@r3
	nop
	mov.l	@(8,r15),r1
	mov	r1,r2
	mov	r2,r0
	mov.b	r0,@(7,r15)
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2886
	mov	r10,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2894,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.l	@(0,r15),r1
	mov.w	L2895,r2
	add	r2,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	@r9,r14
	mov.l	@r8,r13
	mov.l	@(16,r15),r1
	mov.l	@r1,r12
	mov.l	@(12,r15),r1
	mov.l	@r1,r11
	mov.l	r14,@(12,r10)
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov	r10,r1
	add	#24,r1
	mov.l	r11,@r1
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2886:
	mov.l	L2896,r3
	jsr	@r3
	nop
	mov	#1,r1
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	extu.b	r1,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2888
	mov.l	L2897,r3
	jsr	@r3
	nop
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#1,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L2890
	mov.l	L2898,r3
	jsr	@r3
	nop
	mov.l	L2898,r3
	jsr	@r3
	nop
	mov.l	L2898,r3
	jsr	@r3
	nop
	mov.l	L2898,r3
	jsr	@r3
	nop
	mov.l	L2899,r3
	jsr	@r3
	mov	#4,r4
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2890:
	mov.l	@(0,r15),r1
	mov.w	L2895,r2
	add	r2,r1
	mov	#4,r2
	mov.b	r2,@r1
	mov.l	@(12,r15),r4
	mov.l	L2900,r3
	jsr	@r3
	mov.l	@r4,r4
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2888:
L2885:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2894:	.short	249
L2895:	.short	155
L2892:	.long	_FUN_06046b70
L2893:	.long	_FUN_06046bf4
L2896:	.long	_FUN_06046bd4
L2897:	.long	_FUN_06046c14
L2898:	.long	_FUN_06046b3c
L2899:	.long	_FUN_06046e0e
L2900:	.long	_FUN_06047588
	.global _FUN_06046a20
	.align 2
_FUN_06046a20:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	#64,r1
	mov	r13,r2
	and	r1,r2
	tst	r2,r2
	bf	L2903
	mov	#1,r1
	bra	L2904
	mov.l	r1,@(0,r15)
L2903:
	mov	#0,r1
	mov.l	r1,@(0,r15)
L2904:
	mov.l	@(0,r15),r14
	mov	r14,r10
	tst	r14,r14
	bt	L2905
	mov.l	L2913,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r12
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2905:
	mov.l	L2914,r3
	jsr	@r3
	nop
	mov.l	L2915,r3
	jsr	@r3
	nop
	mov	r10,r9
	mov	#1,r1
	mov	r10,r2
	and	r1,r2
	tst	r2,r2
	bf	L2907
	mov	r11,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2915,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.w	L2916,r1
	add	r8,r1
	mov	#4,r2
	mov.l	L2917,r3
	jsr	@r3
	mov.b	r2,@r1
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2907:
	mov.l	L2918,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r9,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L2909
	mov	r12,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2909:
	mov.l	L2919,r3
	jsr	@r3
	nop
	mov	#1,r2
	extu.b	r9,r1
	and	r2,r1
	tst	r1,r1
	bt	L2911
	mov.l	L2920,r3
	jsr	@r3
	nop
	mov.l	L2920,r3
	jsr	@r3
	nop
	mov.l	L2920,r3
	jsr	@r3
	nop
	mov.l	L2921,r3
	jsr	@r3
	mov	#3,r4
	mov	r0,r1
	mov	r1,r12
	mov	r12,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2911:
	mov.w	L2916,r1
	add	r8,r1
	mov	#4,r2
	mov.l	L2922,r3
	jsr	@r3
	mov.l	L2923,r3
	jsr	@r3
	mov.b	r2,@r1
	mov	r0,r1
	mov	r1,r12
L2901:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2916:	.short	155
	.align 2
L2913:	.long	_FUN_06046ae8
L2914:	.long	_FUN_06046b64
L2915:	.long	_FUN_06046bf4
L2917:	.long	_FUN_06045c3c
L2918:	.long	_FUN_06046bd4
L2919:	.long	_FUN_06046c14
L2920:	.long	_FUN_06046b3c
L2921:	.long	_func_0x06046e0e
L2922:	.long	_FUN_06047548
L2923:	.long	_FUN_06047588
	.global _FUN_06046a24
	.align 2
_FUN_06046a24:
	sts.l	pr,@-r15
	mov.l	L2931,r3
	jsr	@r3
	nop
	mov.l	L2932,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r1
	mov	r12,r2
	and	r1,r2
	tst	r2,r2
	bf	L2925
	mov	r13,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2933,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.w	L2934,r1
	add	r10,r1
	mov	#4,r2
	mov.l	L2935,r3
	jsr	@r3
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	nop
L2925:
	mov.l	L2936,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r11,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2927
	mov.l	L2937,r3
	jsr	@r3
	nop
	mov	#1,r2
	extu.b	r11,r1
	and	r2,r1
	tst	r1,r1
	bt	L2929
	mov.l	L2938,r3
	jsr	@r3
	nop
	mov.l	L2938,r3
	jsr	@r3
	nop
	mov.l	L2938,r3
	jsr	@r3
	nop
	mov.l	L2939,r3
	jsr	@r3
	mov	#3,r4
	mov	r0,r1
	mov	r1,r4
	mov	r4,r0
	lds.l	@r15+,pr
	rts
	nop
L2929:
	mov.w	L2934,r1
	add	r10,r1
	mov	#4,r2
	mov.l	L2940,r3
	jsr	@r3
	mov.l	L2941,r3
	jsr	@r3
	mov.b	r2,@r1
	mov	r0,r1
	mov	r1,r4
	mov	r4,r0
	lds.l	@r15+,pr
	rts
	nop
L2927:
L2924:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2933:	.short	249
L2934:	.short	155
L2931:	.long	_FUN_06046b64
L2932:	.long	_FUN_06046bf4
L2935:	.long	_FUN_06045c3c
L2936:	.long	_FUN_06046bd4
L2937:	.long	_FUN_06046c14
L2938:	.long	_FUN_06046b3c
L2939:	.long	_FUN_06046e0e
L2940:	.long	_FUN_06047548
L2941:	.long	_FUN_06047588
	.global _FUN_06046a90
	.align 2
_FUN_06046a90:
	sts.l	pr,@-r15
	mov.l	L2947,r3
	jsr	@r3
	nop
	mov.l	L2948,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r1
	mov	r12,r2
	and	r1,r2
	tst	r2,r2
	bf	L2943
	mov	r13,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2949,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.w	L2950,r1
	add	r10,r1
	mov	#4,r2
	mov.l	L2951,r3
	jsr	@r3
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	nop
L2943:
	mov.l	L2952,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r11,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2945
	mov.l	L2953,r3
	jsr	@r3
	nop
	mov.l	L2953,r3
	jsr	@r3
	nop
	mov.l	L2953,r3
	jsr	@r3
	nop
	mov.l	L2953,r3
	jsr	@r3
	nop
	mov.l	L2954,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r4
	mov	r4,r0
	lds.l	@r15+,pr
	rts
	nop
L2945:
L2942:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2949:	.short	249
L2950:	.short	155
L2947:	.long	_FUN_06046b70
L2948:	.long	_FUN_06046bf4
L2951:	.long	_FUN_06045c3c
L2952:	.long	_FUN_06046bd4
L2953:	.long	_FUN_06046b3c
L2954:	.long	_FUN_06046e64
	.global _FUN_06046ae8
	.align 2
_FUN_06046ae8:
	sts.l	pr,@-r15
	mov.l	L2960,r3
	jsr	@r3
	nop
	mov.l	L2961,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r1
	mov	r12,r2
	and	r1,r2
	tst	r2,r2
	bf	L2956
	mov	r13,r1
	add	#4,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L2962,r3
	and	r3,r2
	mov	#8,r3
	or	r3,r2
	mov.b	r2,@r1
	mov.w	L2963,r1
	add	r10,r1
	mov	#4,r2
	mov.l	L2964,r3
	jsr	@r3
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	nop
L2956:
	mov.l	L2965,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r11,r1
	and	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L2958
	mov.l	L2966,r3
	jsr	@r3
	nop
	mov.l	L2966,r3
	jsr	@r3
	nop
	mov.l	L2966,r3
	jsr	@r3
	nop
	mov.l	L2967,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r4
	mov	r4,r0
	lds.l	@r15+,pr
	rts
	nop
L2958:
L2955:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L2962:	.short	249
L2963:	.short	155
L2960:	.long	_FUN_06046b64
L2961:	.long	_FUN_06046bf4
L2964:	.long	_FUN_06045c3c
L2965:	.long	_FUN_06046bd4
L2966:	.long	_FUN_06046b3c
L2967:	.long	_FUN_06046e64
	.global _FUN_06046b3c
	.align 2
_FUN_06046b3c:
	mov	r4,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r7
	neg	r6,r1
	cmp/ge	r1,r7
	bt	L2969
	mov	r7,r0
	rts
	nop
L2969:
L2968:
	rts
	mov	r7,r0
	.global _FUN_06046b64
	.align 2
_FUN_06046b64:
	mov	r6,r1
	shlr16	r1
	exts.w	r1,r5
	mov.w	@r9,r1
	cmp/gt	r5,r1
	bt	L2972
	mov.w	@r9,r1
	mov	r1,r5
L2972:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r9),r0
	mov	r0,r2
	cmp/gt	r2,r1
	bt	L2974
	mov.w	@(2,r9),r0
	mov	r0,r1
	mov	r1,r4
L2974:
	mov.w	@r10,r1
	cmp/gt	r5,r1
	bt	L2976
	mov.w	@r10,r1
	mov	r1,r5
L2976:
	mov.w	@(2,r10),r0
	mov	r0,r1
	mov	r1,r7
	cmp/gt	r7,r4
L2971:
	rts
	nop
	.global _FUN_06046b70
	.align 2
_FUN_06046b70:
	mov	r6,r1
	shlr16	r1
	exts.w	r1,r5
	mov.w	@r8,r1
	cmp/gt	r5,r1
	bt	L2981
	mov.w	@r8,r1
	mov	r1,r5
L2981:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r8),r0
	mov	r0,r2
	cmp/gt	r2,r1
	bt	L2983
	mov.w	@(2,r8),r0
	mov	r0,r1
	mov	r1,r4
L2983:
	mov.w	@r9,r1
	cmp/gt	r5,r1
	bt	L2985
	mov.w	@r9,r1
	mov	r1,r5
L2985:
	mov.w	@(2,r9),r0
	mov	r0,r1
	cmp/gt	r1,r4
	bt	L2987
	mov.w	@(2,r9),r0
	mov	r0,r1
	mov	r1,r4
L2987:
	mov.w	@r10,r1
	cmp/gt	r5,r1
	bt	L2989
	mov.w	@r10,r1
	mov	r1,r5
L2989:
	mov.w	@(2,r10),r0
	mov	r0,r1
	mov	r1,r7
	cmp/gt	r7,r4
L2980:
	rts
	nop
	.global _FUN_06046b96
	.align 2
_FUN_06046b96:
	mov	r5,r1
	add	#2,r1
	mov.w	@r1,r1
	cmp/gt	r1,r4
	bt	L2994
	mov	r5,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r4
L2994:
	mov	r6,r1
	add	#2,r1
	mov.w	@r1,r1
	mov	r1,r7
	cmp/gt	r7,r4
	bt	L2996
	mov	r7,r0
	rts
	nop
L2996:
L2993:
	rts
	mov	r7,r0
	.global _FUN_06046bd4
	.align 2
_FUN_06046bd4:
	mov	r7,r1
	shlr16	r1
	exts.w	r1,r6
	cmp/ge	r6,r5
	bt	L2999
	neg	r6,r6
	cmp/gt	r4,r6
	bt	L2999
	mov	r7,r1
	exts.w	r1,r1
	cmp/ge	r1,r10
	bt	L2999
	mov	r6,r0
	rts
	nop
L2999:
L2998:
	rts
	mov	r6,r0
	.global _FUN_06046bf4
	.align 2
_FUN_06046bf4:
	mov	r7,r1
	shlr16	r1
	exts.w	r1,r6
	cmp/ge	r6,r11
	bt	L3002
	neg	r6,r6
	cmp/gt	r5,r6
	bt	L3002
	mov	r7,r1
	exts.w	r1,r1
	cmp/ge	r1,r4
	bt	L3002
	mov	r6,r0
	rts
	nop
L3002:
L3001:
	rts
	mov	r6,r0
	.global _FUN_06046c14
	.align 2
_FUN_06046c14:
	cmp/ge	r7,r5
	bt	L3005
	neg	r7,r7
	cmp/ge	r6,r7
	bt	L3005
	mov	r11,r1
	add	#20,r1
	mov.l	@r1,r7
	cmp/ge	r7,r4
	bt	L3005
	neg	r7,r0
	rts
	nop
L3005:
L3004:
	rts
	mov	r7,r0
	.global _FUN_06046cd0
	.align 2
_FUN_06046cd0:
	mov.l	@(12,r7),r5
	mov.l	@(20,r7),r6
	mov.l	@(16,r7),r2
	mov.l	r2,@r1
	mov.l	r5,@(16,r7)
	mov	r7,r1
	add	#20,r1
	mov.l	@(24,r7),r2
	mov.l	r2,@r1
	mov.l	r6,@(24,r7)
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3008,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#16,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
	rts
	mov.b	r2,@r1
	.align 2
L3008:	.short	239
	.align 2
	.global _FUN_06046cf0
	.align 2
_FUN_06046cf0:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(20,r5),r2
	mov.l	r2,@r1
	mov	r5,r1
	add	#16,r1
	mov.l	@(24,r5),r2
	mov.l	r2,@r1
	mov.l	r7,@(20,r5)
	mov.l	r6,@(24,r5)
	mov	r5,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3010,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#48,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
	rts
	mov.b	r2,@r1
	.align 2
L3010:	.short	207
	.align 2
	.global _FUN_06046d10
	.align 2
_FUN_06046d10:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(24,r5),r2
	mov.l	r2,@r1
	mov	r5,r1
	add	#16,r1
	mov.l	@(20,r5),r2
	mov.l	r2,@r1
	mov.l	r6,@(20,r5)
	mov.l	r7,@(24,r5)
	mov	r5,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3012,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#32,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
	rts
	mov.b	r2,@r1
	.align 2
L3012:	.short	223
	.align 2
	.global _FUN_06046d30
	.align 2
_FUN_06046d30:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(24,r1),r4
	mov.l	L3030,r3
	mov.l	@(0,r15),r1
	jsr	@r3
	exts.w	r4,r4
	mov	#1,r1
	mov	r9,r2
	and	r1,r2
	tst	r2,r2
	bf	L3014
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3014:
	mov.l	L3030,r3
	jsr	@r3
	nop
	mov	#1,r1
	mov	r9,r2
	and	r1,r2
	tst	r2,r2
	bt	L3016
	mov.l	L3030,r3
	jsr	@r3
	nop
	mov	r9,r8
	mov	#1,r1
	mov	r9,r2
	and	r1,r2
	tst	r2,r2
	bf	L3018
L3020:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r2
	add	#1,r2
	mov.b	@r2,r2
	mov	r2,r3
	mov.w	L3031,r4
	and	r4,r3
	not	r2,r2
	mov	#48,r4
	and	r4,r2
	mov	r3,r14
	or	r2,r14
	mov.l	@(20,r10),r2
	mov.l	r2,@r1
	mov	r10,r1
	add	#16,r1
	mov.l	@(24,r10),r2
	mov.l	r2,@r1
	mov.l	r12,@(20,r10)
	mov.l	r11,@(24,r10)
	mov	r10,r1
	add	#1,r1
	mov	r14,r2
	mov.b	r2,@r1
	mov	r14,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3018:
	mov.l	L3030,r3
	jsr	@r3
	nop
	mov	#1,r2
	extu.b	r8,r1
	and	r2,r1
	tst	r1,r1
	bt	L3021
	mov.l	L3032,r3
	jsr	@r3
	nop
	mov	r0,r4
	tst	r4,r4
	bf	L3023
	mov	#0,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3023:
	mov	r4,r0
	cmp/eq	#1,r0
	bf	L3025
	bra	L3027
	nop
L3025:
	mov	r4,r0
	cmp/eq	#2,r0
	bf	L3028
	bra	L3020
	nop
L3028:
L3021:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r2
	add	#1,r2
	mov.b	@r2,r2
	mov	r2,r3
	mov.w	L3034,r4
	and	r4,r3
	not	r2,r2
	mov	#32,r4
	and	r4,r2
	mov	r3,r14
	or	r2,r14
	mov.l	@(24,r10),r2
	mov.l	r2,@r1
	mov	r10,r1
	add	#16,r1
	mov.l	@(20,r10),r2
	mov.l	r2,@r1
	mov.l	r11,@(20,r10)
	mov.l	r12,@(24,r10)
	mov	r10,r1
	add	#1,r1
	mov	r14,r2
	mov.b	r2,@r1
	mov	r14,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L3016:
L3027:
	mov.l	@(12,r10),r12
	mov.l	@(20,r10),r11
	mov	r10,r2
	add	#1,r2
	mov.b	@r2,r2
	mov	r2,r3
	mov.w	L3033,r4
	and	r4,r3
	not	r2,r2
	mov	#16,r4
	and	r4,r2
	mov	r3,r14
	or	r2,r14
	mov.l	@(16,r10),r2
	mov.l	r2,@r1
	mov.l	r12,@(16,r10)
	mov	r10,r1
	add	#20,r1
	mov.l	@(24,r10),r2
	mov.l	r2,@r1
	mov.l	r11,@(24,r10)
	mov	r10,r1
	add	#1,r1
	mov	r14,r2
	mov.b	r2,@r1
L3013:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3031:	.short	207
L3033:	.short	239
L3030:	.long	_FUN_06046d78
L3032:	.long	_FUN_06046d98
L3034:	.long	_FUN_06046d78
	.global _FUN_06046d78
	.align 2
_FUN_06046d78:
	mov	r6,r1
	shlr16	r1
	exts.w	r1,r5
	cmp/gt	r11,r5
	bt	L3036
	neg	r11,r7
	cmp/gt	r5,r7
	bt	L3036
	mov	r6,r1
	exts.w	r1,r1
	cmp/gt	r4,r1
	bt	L3036
	neg	r4,r0
	rts
	nop
L3036:
L3035:
	rts
	mov	r7,r0
	.global _FUN_06046d98
	.align 2
_FUN_06046d98:
	mov	r9,r1
	add	#12,r1
	mov.l	@r1,r2
	exts.w	r2,r10
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r6
	mov	#1,r1
	cmp/ge	r1,r6
	bt	L3039
	neg	r6,r6
L3039:
	mov	#1,r1
	cmp/ge	r1,r10
	bt	L3041
	neg	r10,r10
L3041:
	mov	r9,r1
	add	#16,r1
	mov.l	@r1,r2
	exts.w	r2,r4
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r5
	mov	#1,r1
	cmp/ge	r1,r5
	bt	L3043
	neg	r5,r5
L3043:
	mov	#1,r1
	cmp/ge	r1,r4
	bt	L3045
	neg	r4,r4
L3045:
	mov	r4,r1
	add	r5,r1
	mov	r10,r2
	add	r6,r2
	cmp/gt	r2,r1
	bf/s	L3049
	mov	#1,r6
L3048:
	mov	#0,r6
L3049:
	mov	r6,r1
	mov	r1,r7
	add	r10,r6
	extu.b	r7,r1
	tst	r1,r1
	bt	L3050
	mov	r4,r6
	add	r5,r6
L3050:
	mov	r9,r1
	add	#20,r1
	mov.l	@r1,r2
	exts.w	r2,r5
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r10
	mov	#1,r1
	cmp/ge	r1,r10
	bt	L3052
	neg	r10,r10
L3052:
	mov	#1,r1
	cmp/ge	r1,r5
	bt	L3054
	neg	r5,r5
L3054:
	mov	r5,r1
	add	r10,r1
	cmp/gt	r6,r1
	bt	L3056
	mov	#2,r7
	mov	r5,r6
	add	r10,r6
L3056:
	mov	r9,r1
	add	#24,r1
	mov.l	@r1,r2
	exts.w	r2,r5
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r10
	mov	#1,r1
	cmp/ge	r1,r10
	bt	L3058
	neg	r10,r10
L3058:
	mov	#1,r1
	cmp/ge	r1,r5
	bt	L3060
	neg	r5,r5
L3060:
	mov	r5,r1
	add	r10,r1
	cmp/gt	r6,r1
	bt	L3062
	mov	#3,r7
L3062:
	rts
	extu.b	r7,r0
	.global _FUN_06046e0e
	.align 2
_FUN_06046e0e:
	sts.l	pr,@-r15
	mov.l	L3069,r3
	jsr	@r3
	nop
	mov.w	L3070,r1
	add	r12,r1
	mov.l	L3071,r3
	jsr	@r3
	mov.l	L3072,r3
	jsr	@r3
	mov.l	r13,@r1
	mov.w	L3073,r1
	add	r12,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L3065
	mov.l	L3074,r3
	jsr	@r3
	nop
	mov.w	L3075,r1
	add	r12,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L3067
	mov.l	L3076,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	nop
L3067:
L3065:
L3064:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3070:	.short	164
L3073:	.short	153
L3075:	.short	154
	.align 2
L3069:	.long	_FUN_06046ebc
L3071:	.long	_FUN_06046fd4
L3072:	.long	_FUN_06047014
L3074:	.long	_FUN_06047184
L3076:	.long	_FUN_060472cc
	.global _FUN_06046e64
	.align 2
_FUN_06046e64:
	sts.l	pr,@-r15
	mov.w	L3082,r1
	add	r12,r1
	mov.l	L3083,r3
	jsr	@r3
	mov.l	L3084,r3
	jsr	@r3
	mov.l	r13,@r1
	mov.w	L3085,r1
	add	r12,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L3078
	mov.l	L3086,r3
	jsr	@r3
	nop
	mov.w	L3087,r1
	add	r12,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L3080
	mov.l	L3088,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	nop
L3080:
L3078:
L3077:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3082:	.short	164
L3085:	.short	153
L3087:	.short	154
	.align 2
L3083:	.long	_FUN_06046fd4
L3084:	.long	_func_0x06047014
L3086:	.long	_FUN_06047184
L3088:	.long	_FUN_060472cc
	.global _FUN_06046ebc
	.align 2
_FUN_06046ebc:
	mov	r8,r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	and	r2,r1
	tst	r1,r1
	bf	L3090
	mov	r8,r1
	add	#7,r1
	mov.b	@r1,r1
	bra	L3089
	mov	r1,r0
L3090:
	mov.l	@(8,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3092
	mov.l	@(4,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bf	L3094
L3096:
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	mov	r2,r3
	mov.w	L3132,r7
	and	r7,r3
	not	r2,r2
	mov	#48,r7
	and	r7,r2
	mov	r3,r2
	or	r2,r2
	mov.b	r2,@r1
	bra	L3089
	mov	r13,r0
L3094:
	mov	r4,r0
	cmp/eq	#3,r0
	bt	L3099
	mov.l	@(0,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3097
L3099:
	mov.l	@r8,r1
	exts.w	r1,r9
	mov.l	@r8,r1
	shlr16	r1
	exts.w	r1,r12
	mov	#1,r1
	cmp/ge	r1,r12
	bt	L3100
	neg	r12,r12
L3100:
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3102
	neg	r9,r9
L3102:
	mov.l	@(8,r15),r1
	mov.l	@r1,r2
	exts.w	r2,r10
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r11
	mov	#1,r1
	cmp/ge	r1,r11
	bt	L3104
	neg	r11,r11
L3104:
	mov	#1,r1
	cmp/ge	r1,r10
	bt	L3106
	neg	r10,r10
L3106:
	mov	r10,r1
	add	r11,r1
	mov	r9,r2
	add	r12,r2
	cmp/gt	r2,r1
	bf/s	L3110
	mov	#1,r12
L3109:
	mov	#0,r12
L3110:
	mov	r12,r14
	add	r9,r12
	exts.b	r14,r1
	tst	r1,r1
	bt	L3111
	mov	r10,r12
	add	r11,r12
L3111:
	mov.l	@(4,r15),r1
	mov.l	@r1,r2
	exts.w	r2,r11
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r9
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3113
	neg	r9,r9
L3113:
	mov	#1,r1
	cmp/ge	r1,r11
	bt	L3115
	neg	r11,r11
L3115:
	mov	r11,r1
	add	r9,r1
	cmp/gt	r12,r1
	bt	L3117
	mov	#2,r14
	mov	r11,r12
	add	r9,r12
L3117:
	mov.l	@(0,r15),r1
	mov.l	@r1,r2
	exts.w	r2,r11
	mov.l	@r1,r1
	shlr16	r1
	exts.w	r1,r9
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3119
	neg	r9,r9
L3119:
	mov	#1,r1
	cmp/ge	r1,r11
	bt	L3121
	neg	r11,r11
L3121:
	mov	r11,r1
	add	r9,r1
	cmp/gt	r12,r1
	bt	L3123
	mov	#3,r14
L3123:
	exts.b	r14,r1
	tst	r1,r1
	bt/s	L3089
	mov	#0,r0
L3125:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L3127
	bra	L3129
	nop
L3127:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L3130
	bra	L3096
	nop
L3130:
L3097:
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	mov	r2,r3
	mov.w	L3133,r4
	and	r4,r3
	not	r2,r2
	mov	#32,r4
	and	r4,r2
	mov	r3,r2
	or	r2,r2
	mov.b	r2,@r1
	bra	L3089
	mov	r13,r0
L3092:
L3129:
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	mov	r2,r3
	mov.w	L3134,r7
	and	r7,r3
	not	r2,r2
	mov	#16,r7
	and	r7,r2
	mov	r3,r2
	or	r2,r2
	mov.b	r2,@r1
L3089:
	rts
	mov	r13,r0
	.align 2
L3132:	.short	207
L3133:	.short	223
L3134:	.short	239
	.align 2
	.global _FUN_06046fd4
	.align 2
_FUN_06046fd4:
	add	#-16,r15
	mov.l	@(0,r15),r1
	mov.w	L3136,r2
	add	r2,r1
	mov.b	r6,@r1
	mov.l	L3137,r1
	mov.l	@r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	mov	r1,r5
	mov.l	@r9,r1
	mov.l	r1,@r5
	mov	r10,r1
	shlr16	r1
	shlr8	r1
	mov	r1,r0
	mov.b	r0,@(4,r5)
	mov.l	@r8,r1
	mov.l	r1,@(8,r5)
	mov	r10,r0
	shlr16	r0
	mov.b	r0,@(12,r5)
	mov.l	@(12,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(16,r5)
	mov	r5,r1
	add	#20,r1
	mov	r10,r2
	shlr8	r2
	mov.b	r2,@r1
	mov.l	@(8,r15),r1
	mov.l	@r1,r1
	mov.l	r1,@(24,r5)
	mov	r5,r1
	add	#28,r1
	mov	r10,r2
	mov.b	r2,@r1
	mov.l	L3137,r1
	mov.l	@r1,r4
	mov.l	@(4,r15),r1
	mov	r4,r1
	add	r1,r1
	mov.l	@r1,r1
	mov.l	r1,@(32,r5)
	mov.l	@(4,r15),r1
	mov	r4,r1
	add	r1,r1
	mov.b	@(4,r1),r0
	mov	r0,r7
	mov	r5,r1
	add	#36,r1
	mov.b	r7,@r1
	add	#16,r15
	rts
	mov	r7,r0
	.align 2
L3136:	.short	152
	.align 2
L3137:	.long	_DAT_0604717e
	.global _FUN_06047014
	.align 2
_FUN_06047014:
	sts.l	pr,@-r15
	mov.l	L3142,r1
	mov.l	@r1,r1
	mov	r1,r10
	add	r12,r10
	mov.l	L3143,r1
	mov.l	@r1,r11
	mov.w	L3144,r1
	add	r13,r1
	mov	#0,r2
	mov.b	r2,@r1
L3139:
	mov	#3,r1
	mov	r10,r1
	add	#4,r1
	mov.b	@r1,r1
	and	r1,r1
	shll2	r1
	mov	r10,r2
	add	#12,r2
	mov.b	@r2,r2
	and	r1,r2
	or	r2,r1
	shll	r1
	shll2	r1
	mov.l	L3145,r2
	add	r2,r1
	mov.w	@r1,r1
	mov.l	L3146,r2
	add	r2,r1
	mov	r1,r3
	jsr	@r3
	nop
	add	#8,r10
	mov.w	L3142,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#-1,r2
	mov.b	r2,@r1
	tst	r9,r9
	bf	L3139
	mov.l	L3143,r1
	mov.l	@r1,r10
	mov	r11,r1
	add	r12,r1
	mov	r10,r0
	mov.l	@(r0,r12),r2
	mov.l	r2,@r1
	mov	r10,r1
	add	r12,r1
	add	#4,r1
	mov.b	@r1,r8
	mov	r11,r1
	add	r12,r1
	add	#4,r1
	mov.b	r8,@r1
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L3144:	.short	153
L3146:	.short	100954170
L3142:	.long	_DAT_0604717e
L3143:	.long	_DAT_06047180
L3145:	.long	_DAT_06047058
	.global _FUN_0604708c
	.align 2
_FUN_0604708c:
	sts.l	pr,@-r15
	mov.l	@r13,r1
	mov.l	r1,@r12
	mov	r12,r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	L3148,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.w	L3149,r1
	add	r11,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3149:	.short	153
	.align 2
L3148:	.long	_FUN_06047118
	.global _FUN_060470a8
	.align 2
_FUN_060470a8:
	sts.l	pr,@-r15
	mov.l	@r13,r1
	mov.l	r1,@r12
	mov	r12,r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	L3151,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.w	L3152,r1
	add	r11,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3152:	.short	153
	.align 2
L3151:	.long	_FUN_06047118
	.global _FUN_060470c4
	.align 2
_FUN_060470c4:
	sts.l	pr,@-r15
	mov.l	L3154,r3
	jsr	@r3
	nop
	mov.w	L3155,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#1,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3155:	.short	153
	.align 2
L3154:	.long	_FUN_06047118
	.global _FUN_060470d6
	.align 2
_FUN_060470d6:
	sts.l	pr,@-r15
	mov.l	L3157,r3
	jsr	@r3
	nop
	mov.l	L3157,r3
	jsr	@r3
	nop
	mov.w	L3158,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3158:	.short	153
	.align 2
L3157:	.long	_func_0x06047118
	.global _FUN_060470ec
	.align 2
_FUN_060470ec:
	sts.l	pr,@-r15
	mov.l	L3160,r3
	jsr	@r3
	nop
	mov.w	L3161,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#1,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3161:	.short	153
	.align 2
L3160:	.long	_FUN_06047118
	.global _FUN_060470fe
	.align 2
_FUN_060470fe:
	sts.l	pr,@-r15
	mov.l	L3163,r3
	jsr	@r3
	nop
	mov.l	L3163,r3
	jsr	@r3
	nop
	mov.w	L3164,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3164:	.short	153
	.align 2
L3163:	.long	_func_0x06047118
	.global _FUN_06047118
	.align 2
_FUN_06047118:
	sts.l	pr,@-r15
	mov.l	L3170,r3
	jsr	@r3
	nop
	mov.l	r13,@r10
	mov	#0,r14
	mov	r13,r1
	shlr16	r1
	exts.w	r1,r12
	cmp/ge	r12,r11
	bt	L3166
	mov	#8,r14
L3166:
	neg	r11,r1
	cmp/ge	r1,r12
	bt	L3168
	exts.b	r14,r1
	add	#4,r1
	mov	r1,r14
L3168:
	mov	r14,r0
	mov.b	r0,@(4,r10)
	lds.l	@r15+,pr
	rts
	exts.b	r14,r0
	.align 2
L3170:	.long	_FUN_06047140
	.global _FUN_06047140
	.align 2
_FUN_06047140:
	sts.l	macl,@-r15
	mov	r7,r6
	mov	r12,r1
	exts.w	r1,r1
	mov	r7,r2
	exts.w	r2,r2
	cmp/ge	r2,r1
	bt	L3172
	mov	r12,r6
	mov	r7,r12
L3172:
	mov	r6,r10
	shlr16	r10
	mov	r6,r1
	exts.w	r1,r1
	mov.l	L3174,r2
	mov	r12,r3
	exts.w	r3,r3
	mov	r1,r4
	sub	r3,r4
	mov.l	r4,@r2
	exts.w	r10,r2
	mov.l	L3175,r3
	mov	r12,r4
	shlr16	r4
	exts.w	r4,r4
	mov	r2,r4
	sub	r4,r4
	exts.w	r4,r4
	exts.w	r11,r5
	sub	r1,r5
	mov	r5,r1
	exts.w	r1,r1
	mul.l	r1,r4
	sts	macl,r1
	mov.l	r1,@r3
	mov.l	L3176,r1
	mov.l	@r1,r1
	add	r2,r1
	mov	r1,r0
	shll16	r0
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L3174:	.long	__DAT_ffffff00
L3175:	.long	__DAT_ffffff04
L3176:	.long	__DAT_ffffff1c
	.global _FUN_06047184
	.align 2
_FUN_06047184:
	sts.l	pr,@-r15
	mov.l	L3181,r1
	mov.l	@r1,r1
	mov	r1,r13
	add	r12,r13
	mov.w	L3182,r1
	add	r11,r1
	mov	#0,r2
	mov.b	r2,@r1
L3178:
	mov	#12,r1
	mov	r13,r1
	add	#4,r1
	mov.b	@r1,r1
	and	r1,r1
	mov	r13,r2
	add	#12,r2
	mov.b	@r2,r2
	and	r1,r2
	shlr2	r2
	or	r2,r1
	shll	r1
	shll2	r1
	mov.l	L3183,r2
	add	r2,r1
	mov.w	@r1,r1
	mov.l	L3184,r2
	add	r2,r1
	mov	r1,r3
	jsr	@r3
	nop
	add	#8,r13
	mov.w	L3183,r1
	add	r11,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#-1,r2
	mov.b	r2,@r1
	tst	r14,r14
	bf	L3178
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3182:	.short	154
L3184:	.short	100954538
L3181:	.long	_DAT_060472c6
L3183:	.long	_DAT_060471bc
	.global _FUN_060471f0
	.align 2
_FUN_060471f0:
	sts.l	pr,@-r15
	mov.l	@r13,r1
	mov.l	r1,@r12
	mov	r12,r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	L3186,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.w	L3187,r1
	add	r11,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3187:	.short	154
	.align 2
L3186:	.long	_FUN_0604727c
	.global _FUN_0604720c
	.align 2
_FUN_0604720c:
	sts.l	pr,@-r15
	mov.l	@r13,r1
	mov.l	r1,@r12
	mov	r12,r1
	add	#4,r1
	mov.l	@(4,r13),r2
	mov.l	L3189,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.w	L3190,r1
	add	r11,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3190:	.short	154
	.align 2
L3189:	.long	_FUN_0604727c
	.global _FUN_06047228
	.align 2
_FUN_06047228:
	sts.l	pr,@-r15
	mov.l	L3192,r3
	jsr	@r3
	nop
	mov.w	L3193,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#1,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3193:	.short	154
	.align 2
L3192:	.long	_FUN_0604727c
	.global _FUN_0604723a
	.align 2
_FUN_0604723a:
	sts.l	pr,@-r15
	mov.l	L3195,r3
	jsr	@r3
	nop
	mov.l	L3195,r3
	jsr	@r3
	nop
	mov.w	L3196,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3196:	.short	154
	.align 2
L3195:	.long	_func_0x0604727c
	.global _FUN_06047250
	.align 2
_FUN_06047250:
	sts.l	pr,@-r15
	mov.l	L3198,r3
	jsr	@r3
	nop
	mov.w	L3199,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#1,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3199:	.short	154
	.align 2
L3198:	.long	_FUN_0604727c
	.global _FUN_06047262
	.align 2
_FUN_06047262:
	sts.l	pr,@-r15
	mov.l	L3201,r3
	jsr	@r3
	nop
	mov.l	L3201,r3
	jsr	@r3
	nop
	mov.w	L3202,r1
	add	r13,r1
	mov.b	@r1,r2
	mov	r2,r2
	add	#2,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3202:	.short	154
	.align 2
L3201:	.long	_func_0x0604727c
	.global _FUN_06047270
	.align 2
_FUN_06047270:
	mov.w	L3204,r1
	add	r6,r1
	rts
	mov.b	r7,@r1
	.align 2
L3204:	.short	154
	.align 2
	.global _FUN_0604727c
	.align 2
_FUN_0604727c:
	sts.l	pr,@-r15
	mov.l	L3206,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r12
	.align 2
L3206:	.long	_FUN_0604728e
	.global _FUN_0604728e
	.align 2
_FUN_0604728e:
	sts.l	macl,@-r15
	mov	r7,r6
	cmp/ge	r7,r12
	bt	L3208
	mov	r12,r6
	mov	r7,r12
L3208:
	mov	r6,r10
	shlr16	r10
	exts.w	r10,r1
	mov.l	L3210,r2
	mov	r12,r3
	shlr16	r3
	exts.w	r3,r3
	mov	r1,r4
	sub	r3,r4
	mov.l	r4,@r2
	mov	r6,r2
	exts.w	r2,r2
	mov.l	L3211,r3
	mov	r12,r4
	exts.w	r4,r4
	mov	r2,r4
	sub	r4,r4
	exts.w	r4,r4
	exts.w	r11,r5
	sub	r1,r5
	mov	r5,r1
	exts.w	r1,r1
	mul.l	r1,r4
	sts	macl,r1
	mov.l	r1,@r3
	mov.l	L3212,r1
	mov.l	@r1,r1
	add	r2,r1
	extu.w	r1,r1
	lds.l	@r15+,macl
	rts
	mov	r1,r0
	.align 2
L3210:	.long	__DAT_ffffff00
L3211:	.long	__DAT_ffffff04
L3212:	.long	__DAT_ffffff1c
	.global _FUN_060472cc
	.align 2
_FUN_060472cc:
	sts.l	pr,@-r15
	mov.w	L3214,r1
	add	r14,r1
	mov.b	@r1,r1
	shll	r1
	shll2	r1
	mov.l	L3215,r2
	add	r2,r1
	mov.w	@r1,r1
	mov.l	L3216,r2
	add	r2,r1
	mov	r1,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3214:	.short	154
L3216:	.short	100954846
L3215:	.long	_DAT_060472e0
	.global _FUN_06047332
	.align 2
_FUN_06047332:
	sts.l	pr,@-r15
	mov.l	L3218,r3
	mov.l	@r10,r1
	mov.l	@(32,r10),r12
	mov.l	@r10,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3218,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r1
	mov.l	r1,@(32,r11)
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3219,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3218,r3
	mov.l	@(16,r10),r1
	mov.l	@(16,r10),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3218,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3220,r1
	add	r9,r1
	mov	#8,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3219:	.short	143
L3220:	.short	155
L3218:	.long	_FUN_06046d30
	.global _FUN_0604737a
	.align 2
_FUN_0604737a:
	sts.l	pr,@-r15
	mov.l	L3222,r3
	mov.l	@r10,r1
	mov.l	@(32,r10),r12
	mov.l	@r10,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3222,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r1
	mov.l	r1,@(32,r11)
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3223,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3222,r3
	mov.l	@(8,r10),r1
	mov.l	@(8,r10),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3222,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3224,r1
	add	r9,r1
	mov	#8,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3223:	.short	143
L3224:	.short	155
L3222:	.long	_FUN_06046d30
	.global _FUN_060473ca
	.align 2
_FUN_060473ca:
	sts.l	pr,@-r15
	mov.l	L3226,r3
	mov.l	@r10,r1
	mov.l	@(40,r10),r12
	mov.l	@r10,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3226,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r1
	mov.l	r1,@(32,r11)
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3227,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3226,r3
	mov.l	@(40,r10),r1
	mov.l	@(32,r10),r12
	mov.l	@(40,r10),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3226,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3228,r1
	add	r9,r1
	mov	#8,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3227:	.short	143
L3228:	.short	155
L3226:	.long	_FUN_06046d30
	.global _FUN_06047414
	.align 2
_FUN_06047414:
	sts.l	pr,@-r15
	mov.l	L3230,r3
	mov.l	@r10,r1
	mov.l	@(40,r10),r12
	mov.l	@r10,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3230,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r1
	mov.l	r1,@(32,r11)
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3231,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3230,r3
	mov.l	@(8,r10),r1
	mov.l	@(32,r10),r12
	mov.l	@(8,r10),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3230,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3232,r1
	add	r9,r1
	mov	#8,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3231:	.short	143
L3232:	.short	155
L3230:	.long	_FUN_06046d30
	.global _FUN_06047460
	.align 2
_FUN_06047460:
	sts.l	pr,@-r15
	mov.l	L3234,r3
	mov.l	@r9,r1
	mov.l	@(40,r9),r12
	mov.l	@r9,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3234,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r1
	mov.l	r1,@r10
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3235,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3234,r3
	mov.l	@(8,r9),r1
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3234,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r1
	mov.l	r1,@(32,r10)
	mov.l	@(4,r10),r1
	mov.l	r1,@(36,r10)
	mov.l	@(8,r10),r1
	mov.l	r1,@(40,r10)
	mov.b	@r10,r1
	extu.b	r1,r1
	mov.w	L3235,r2
	and	r2,r1
	mov.b	r1,@r10
	mov.l	L3234,r3
	mov.l	@r9,r1
	mov.l	@r9,r1
	mov.l	r1,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3234,r3
	jsr	@r3
	mov.l	r13,@(56,r10)
	mov.w	L3236,r1
	add	r8,r1
	mov	#12,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3235:	.short	143
L3236:	.short	155
L3234:	.long	_FUN_06046d30
	.global _FUN_060474d4
	.align 2
_FUN_060474d4:
	sts.l	pr,@-r15
	mov.l	L3238,r3
	mov.l	@r9,r1
	mov.l	@(40,r9),r12
	mov.l	@r9,r1
	mov.l	r1,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3238,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r1
	mov.l	r1,@r10
	mov.l	@(4,r11),r1
	mov.l	r1,@(36,r11)
	mov.l	@(8,r11),r1
	mov.l	r1,@(40,r11)
	mov.b	@r11,r1
	extu.b	r1,r1
	mov.w	L3239,r2
	and	r2,r1
	mov.b	r1,@r11
	mov.l	L3238,r3
	mov.l	@(8,r9),r1
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r1
	mov.l	r1,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3238,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r1
	mov.l	r1,@(32,r10)
	mov.l	@(4,r10),r1
	mov.l	r1,@(36,r10)
	mov.l	@(8,r10),r1
	mov.l	r1,@(40,r10)
	mov.b	@r10,r1
	extu.b	r1,r1
	mov.w	L3239,r2
	and	r2,r1
	mov.b	r1,@r10
	mov.l	L3238,r3
	mov.l	@r9,r1
	mov.l	@(56,r9),r12
	mov.l	@r9,r1
	mov.l	r1,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3238,r3
	jsr	@r3
	mov.l	r12,@(56,r10)
	mov.w	L3240,r1
	add	r8,r1
	mov	#12,r2
	mov.b	r2,@r1
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3239:	.short	143
L3240:	.short	155
L3238:	.long	_FUN_06046d30
	.global _FUN_06047548
	.align 2
_FUN_06047548:
	sts.l	pr,@-r15
	add	#-24,r15
	mov	r5,r13
	mov	r6,r12
	mov	#14,r1
	mov	r10,r2
	and	r1,r2
	mov.l	L3263,r1
	add	r2,r1
	mov.w	@r1,r11
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	mov	#12,r2
	cmp/gt	r2,r1
	bt	L3242
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
	.align 2
L3263:	.short	154
Lswt0:
	.short	L3245 - Lswt0
	.short	L3242 - Lswt0
	.short	L3246 - Lswt0
	.short	L3242 - Lswt0
	.short	L3247 - Lswt0
	.short	L3242 - Lswt0
	.short	L3248 - Lswt0
	.short	L3242 - Lswt0
	.short	L3249 - Lswt0
	.short	L3242 - Lswt0
	.short	L3250 - Lswt0
	.short	L3242 - Lswt0
	.short	L3251 - Lswt0
	bra	L3242
	nop
	mov.l	@(20,r15),r1
	mov.l	r13,@(12,r1)
	mov.l	@(12,r15),r1
	exts.w	r11,r2
	add	r2,r1
	mov	r13,r2
	mov.b	r2,@r1
	exts.w	r11,r1
	mov	r1,r9
	mov.l	@(4,r15),r1
	add	#82,r1
	mov.b	r9,@r1
	mov.l	@(20,r15),r1
	mov.l	L3264,r3
	jsr	@r3
	mov.b	r9,@r1
	mov	r0,r4
	mov.l	@(12,r15),r1
	add	r4,r1
	mov	r13,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	add	#82,r1
	mov	r4,r2
	exts.b	r2,r2
	mov.b	r2,@r1
	mov.l	@(4,r15),r1
	mov	r4,r2
	exts.b	r2,r2
	mov.l	L3265,r3
	jsr	@r3
	mov.b	r2,@r1
	mov	r0,r4
	mov.l	@(12,r15),r1
	add	r4,r1
	mov.b	r12,@r1
	mov.l	@(4,r15),r1
	mov	r4,r2
	exts.b	r2,r2
	mov.l	L3266,r3
	jsr	@r3
	mov.b	r2,@r1
	mov	r0,r4
	mov.l	@(12,r15),r1
	add	r4,r1
	mov.b	r12,@r1
	mov.l	@(16,r15),r1
	mov.l	L3267,r1
	mov.l	r4,@r1
	jsr	@r1
	nop
	mov.l	L3267,r1
	jsr	@r1
	nop
L3242:
	mov	r14,r5
	mov.l	L3268,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3270,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3272,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3274,r5
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3270,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3272,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3275,r5
	mov.l	L3269,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3270,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3271,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3272,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov.l	L3280,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3281,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3282,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3283,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3284,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3285,r3
	jsr	@r3
	nop
	mov.l	L3281,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3283,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3285,r3
	jsr	@r3
	nop
	mov	r14,r4
	add	#-48,r4
	mov.l	L3276,r5
	mov.l	L3281,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3282,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3283,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3284,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3285,r3
	jsr	@r3
	nop
	mov.l	L3281,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3283,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3285,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r1
	add	#81,r1
	mov.b	@r1,r1
	mov	r1,r0
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3252
	mov.l	L3277,r3
	jsr	@r3
	nop
L3252:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#8,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3254
	mov.l	L3277,r3
	jsr	@r3
	nop
L3254:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#16,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt/s	L3258
	mov	#1,r14
L3257:
	mov	#0,r14
L3258:
	mov	r14,r1
	mov	r1,r0
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	extu.b	r1,r1
	tst	r1,r1
	bf	L3241
	mov.l	L3286,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3287,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3278,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	r0,r1
	mov	#1,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3241
	mov.l	L3279,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
L3241:
	add	#24,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3264:	.long	_func_0x0604762f
L3265:	.long	_func_0x06047617
L3266:	.long	_func_0x0604761f
L3267:	.long	_halt_baddata
L3268:	.long	_PTR_FUN_06043ed8
L3269:	.long	_PTR_SUB_06043edc
L3270:	.long	_PTR_SUB_06043ed0
L3271:	.long	_PTR_SUB_06043ed4
L3272:	.long	_PTR_SUB_06043ecc
L3273:	.long	_func_0x06043f10
L3274:	.long	_DAT_06044000
L3275:	.long	_DAT_06044024
L3276:	.long	_DAT_06044048
L3277:	.long	_func_0x06043f24
L3278:	.long	_PTR_FUN_06043ee0
L3279:	.long	_PTR_FUN_06043ee8
L3280:	.long	_PTR_FUN_06043ed8
L3281:	.long	_PTR_SUB_06043edc
L3282:	.long	_PTR_SUB_06043ed0
L3283:	.long	_PTR_SUB_06043ed4
L3284:	.long	_PTR_SUB_06043ecc
L3285:	.long	_func_0x06043f10
L3286:	.long	_PTR_FUN_06043ed8
L3287:	.long	_PTR_SUB_06043edc
	.global _FUN_06047588
	.align 2
_FUN_06047588:
	mov.l	@(12,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bf	L3289
L3291:
	mov.l	r13,@(12,r7)
	mov.l	r12,@(16,r7)
	mov.l	r11,@(20,r7)
	mov	r7,r1
	add	#24,r1
	bra	L3288
	mov.l	r4,@r1
L3289:
	mov.l	@(8,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bf	L3292
L3294:
	mov.l	r12,@(12,r7)
	mov.l	r13,@(16,r7)
	mov.l	r4,@(20,r7)
	mov.l	r11,@(24,r7)
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3331,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#16,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
	bra	L3288
	mov.b	r2,@r1
L3292:
	mov.l	@(4,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bf	L3295
L3297:
	mov.l	r11,@(12,r7)
	mov.l	r4,@(16,r7)
	mov.l	r13,@(20,r7)
	mov.l	r12,@(24,r7)
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3332,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#48,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
	bra	L3288
	mov.b	r2,@r1
L3295:
	mov.l	@(0,r15),r1
	add	#7,r1
	mov.b	@r1,r1
	mov	#4,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3298
	mov	r13,r1
	exts.w	r1,r10
	mov	r13,r1
	shlr16	r1
	exts.w	r1,r8
	mov	#1,r1
	cmp/ge	r1,r10
	bt	L3300
	neg	r10,r10
L3300:
	mov	#1,r1
	cmp/ge	r1,r8
	bt	L3302
	neg	r8,r8
L3302:
	mov	r12,r1
	exts.w	r1,r9
	mov	r12,r1
	shlr16	r1
	exts.w	r1,r1
	mov.l	r1,@(16,r15)
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3304
	neg	r9,r9
L3304:
	mov.l	@(16,r15),r1
	mov	#1,r2
	cmp/ge	r2,r1
	bt	L3306
	mov.l	@(16,r15),r1
	neg	r1,r1
	mov.l	r1,@(16,r15)
L3306:
	mov.l	@(16,r15),r1
	add	r9,r1
	mov	r8,r2
	add	r10,r2
	cmp/gt	r2,r1
	bf/s	L3310
	mov	#1,r13
L3309:
	mov	#0,r13
L3310:
	mov	r13,r14
	add	r8,r10
	exts.b	r14,r1
	tst	r1,r1
	bt	L3311
	mov.l	@(16,r15),r1
	mov	r1,r10
	add	r9,r10
L3311:
	mov	r11,r1
	exts.w	r1,r8
	mov	r11,r1
	shlr16	r1
	exts.w	r1,r9
	mov	#1,r1
	cmp/ge	r1,r8
	bt	L3313
	neg	r8,r8
L3313:
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3315
	neg	r9,r9
L3315:
	mov	r9,r1
	add	r8,r1
	cmp/gt	r10,r1
	bt	L3317
	mov	#2,r14
	mov	r9,r10
	add	r8,r10
L3317:
	mov	r4,r1
	exts.w	r1,r8
	mov	r4,r1
	shlr16	r1
	exts.w	r1,r9
	mov	#1,r1
	cmp/ge	r1,r8
	bt	L3319
	neg	r8,r8
L3319:
	mov	#1,r1
	cmp/ge	r1,r9
	bt	L3321
	neg	r9,r9
L3321:
	mov	r9,r1
	add	r8,r1
	cmp/gt	r1,r10
	bt	L3323
	mov	#3,r14
L3323:
	exts.b	r14,r1
	tst	r1,r1
	bf	L3325
	bra	L3291
	nop
L3325:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L3327
	bra	L3294
	nop
L3327:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L3329
	bra	L3297
	nop
L3329:
L3298:
	mov.l	r4,@(12,r7)
	mov.l	r11,@(16,r7)
	mov.l	r12,@(20,r7)
	mov.l	r13,@(24,r7)
	mov	r7,r1
	add	#1,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	mov.w	L3333,r3
	mov	r2,r4
	and	r3,r4
	not	r2,r2
	mov	#32,r3
	and	r3,r2
	mov	r4,r2
	or	r2,r2
L3288:
	rts
	mov.b	r2,@r1
	.align 2
L3331:	.short	239
L3332:	.short	207
L3333:	.short	223
	.align 2
	.global _FUN_06047748
	.align 2
_FUN_06047748:
	mov.l	L3340,r1
	mov.l	@r1,r7
L3335:
	mov.w	@r5,r1
	tst	r1,r1
	bt	L3338
	mov	r4,r1
	shll2	r1
	shll	r1
	add	r7,r1
	add	#2,r1
	mov.w	@r5,r2
	mov.w	r2,@r1
	mov	#0,r1
	mov.w	r1,@r5
	mov.w	@(2,r5),r0
	mov	r0,r1
	mov	r1,r4
L3338:
	dt	r6
	add	#-4,r5
	bf	L3335
	rts
	nop
	.align 2
L3340:	.long	_DAT_0604776c
	.global _FUN_06047770
	.align 2
_FUN_06047770:
	mov.l	L3349,r1
	mov.l	@r1,r13
L3342:
	mov.w	@r4,r1
	tst	r1,r1
	bt	L3345
	mov	r7,r1
	shll2	r1
	shll	r1
	add	r13,r1
	add	#2,r1
	mov.w	@r4,r2
	mov.w	r2,@r1
	mov	#0,r1
	mov.w	r1,@r4
	mov.w	@(2,r4),r0
	mov	r0,r1
	mov	r1,r7
L3345:
	mov	r4,r1
	add	#-4,r1
	mov.w	@r1,r14
	mov	#0,r1
	mov	r1,r12
	mov	r14,r1
	tst	r1,r1
	bt	L3347
	mov	r6,r1
	shll2	r1
	shll	r1
	add	r13,r1
	add	#2,r1
	mov.w	r14,@r1
	mov	r4,r1
	add	#-4,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#-2,r1
	mov.w	@r1,r1
	mov	r1,r12
	mov	r12,r6
L3347:
	dt	r5
	add	#-8,r4
	bf	L3342
	rts
	mov	r12,r0
	.align 2
L3349:	.long	_DAT_060477b0
	.global _FUN_060477d4
	.align 2
_FUN_060477d4:
	sts.l	pr,@-r15
	mov.l	L3351,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3351:	.long	_FUN_060477fc
	.global _FUN_060477d6
	.align 2
_FUN_060477d6:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L3353,r3
	jsr	@r3
	nop
	mov	r0,r1
	mov	r1,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L3353:	.long	_FUN_060477fc
	.global _FUN_060477fc
	.align 2
_FUN_060477fc:
	sts.l	pr,@-r15
	mov.l	L3357,r1
	mov.l	@r1,r1
	mov	r1,r14
	mov.l	L3358,r2
	mov.l	@(4,r1),r1
	mov.l	L3359,r1
	mov.l	@r1,r13
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.l	@r1,r3
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3360,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	r2,@r1
	mov.l	L3361,r1
	mov.l	@r1,r12
	mov.l	L3362,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L3355
	mov.l	L3363,r1
	mov.l	@r1,r1
	add	#4,r1
	mov.l	L3365,r4
	mov.l	L3364,r2
	mov.l	L3366,r1
	mov.w	@r2,r2
	mov.l	r2,@r1
	mov.l	@r4,r4
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3368,r5
	mov.l	L3367,r4
	mov.l	L3369,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov	r0,r4
	mov.l	L3370,r1
	mov.w	@r1,r1
	mov	r1,r12
	mov	r12,r4
	mov.l	L3368,r6
	mov.l	L3367,r5
	mov.l	L3371,r1
	mov.l	@r5,r5
	jsr	@r1
	mov.l	@r6,r6
	mov.l	L3372,r1
	mov.l	@r1,r1
	mov	r12,r2
	shll2	r2
	shll	r2
	add	r2,r1
	add	#2,r1
	mov.l	L3373,r2
	mov.l	L3359,r1
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3360,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	@(4,r1),r4
	mov.l	L3374,r3
	mov.l	L3363,r1
	mov.l	r2,@r1
	mov.l	@r1,r1
	jsr	@r3
	mov	r4,r5
	mov	r0,r1
	mov	r1,r4
	mov	r4,r0
	lds.l	@r15+,pr
	rts
	nop
L3355:
	mov.l	L3375,r1
	mov.w	@r1,r1
	mov	r1,r10
	mov.l	L3361,r1
	mov.l	@r1,r1
	add	#4,r1
	mov.l	L3377,r4
	mov.l	L3376,r2
	mov.l	L3378,r1
	mov.w	@r2,r2
	mov.l	r2,@r1
	mov.l	@r4,r4
	mov.l	@r1,r3
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3380,r5
	mov.l	L3379,r4
	mov.l	L3381,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3382,r1
	mov.w	@r1,r1
	mov	r1,r10
	mov.l	L3383,r1
	mov.w	@r1,r1
	mov	r1,r11
	mov.l	L3380,r5
	mov.l	L3379,r4
	mov.l	L3384,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3385,r1
	mov.l	@r1,r1
	mov	r1,r12
	mov	r10,r2
	shll2	r2
	shll	r2
	add	r1,r2
	mov	r2,r1
	add	#2,r1
	mov.l	L3386,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	r11,r1
	shll2	r1
	shll	r1
	add	r12,r1
	add	#2,r1
	mov.l	L3387,r2
	mov.l	L3388,r1
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L3389,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	r2,@r1
L3354:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3357:	.long	_DAT_0604788c
L3358:	.long	_DAT_06047884
L3359:	.long	_DAT_06047890
L3360:	.long	_DAT_06047894
L3361:	.long	_DAT_06047948
L3362:	.long	_DAT_06047898
L3363:	.long	_DAT_0604789c
L3364:	.long	_DAT_06047886
L3365:	.long	_PTR_LAB_060478a0
L3366:	.long	_DAT_060478a4
L3367:	.long	_DAT_060478a8
L3368:	.long	_DAT_060478ac
L3369:	.long	_func_0x06047986
L3370:	.long	_DAT_06047888
L3371:	.long	_FUN_06047748
L3372:	.long	_DAT_060478b0
L3373:	.long	_DAT_0604788a
L3374:	.long	_func_0x0604796c
L3375:	.long	_DAT_0604793c
L3376:	.long	_DAT_0604793a
L3377:	.long	_PTR_LAB_0604794c
L3378:	.long	_DAT_06047950
L3379:	.long	_DAT_06047954
L3380:	.long	_DAT_06047958
L3381:	.long	_FUN_060479a0
L3382:	.long	_DAT_0604793e
L3383:	.long	_DAT_06047940
L3384:	.long	_FUN_06047770
L3385:	.long	_DAT_0604795c
L3386:	.long	_DAT_06047942
L3387:	.long	_DAT_06047944
L3388:	.long	_DAT_06047960
L3389:	.long	_DAT_06047964
	.global _FUN_06047866
	.align 2
_FUN_06047866:
	sts.l	pr,@-r15
	mov.l	L3391,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	r2,@r1
	mov.l	L3392,r1
	mov.l	@r1,r1
	add	#4,r1
	mov.l	@r1,r13
	mov	r13,r4
	mov.l	L3394,r6
	mov.l	L3393,r5
	mov.l	L3395,r3
	mov.l	@r5,r5
	jsr	@r3
	mov.l	@r6,r6
	mov.l	L3392,r1
	mov.l	@r1,r1
	add	#4,r1
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r1
	.align 2
L3391:	.long	_DAT_06047894
L3392:	.long	_DAT_0604789c
L3393:	.long	_DAT_060478b4
L3394:	.long	_DAT_060478ac
L3395:	.long	_FUN_06047748
	.global _FUN_0604791a
	.align 2
_FUN_0604791a:
	sts.l	pr,@-r15
	mov.l	L3397,r1
	mov.l	@r1,r1
	mov	#17,r2
	mov.l	r2,@r1
	mov.l	L3398,r1
	mov.l	@r1,r1
	mov	r1,r2
	add	#4,r2
	mov.l	@r2,r13
	add	#8,r1
	mov.l	L3400,r5
	mov.l	L3399,r4
	mov.l	L3401,r3
	mov.l	@r1,r12
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3398,r1
	mov.l	@r1,r1
	mov	r1,r14
	add	#4,r1
	mov.l	r13,@r1
	mov	r14,r1
	add	#8,r1
	lds.l	@r15+,pr
	rts
	mov.l	r12,@r1
	.align 2
L3397:	.long	_DAT_06047964
L3398:	.long	_DAT_06047948
L3399:	.long	_DAT_06047968
L3400:	.long	_DAT_06047958
L3401:	.long	_FUN_06047770
	.global _FUN_0604796c
	.align 2
_FUN_0604796c:
	mov	r4,r1
	shll2	r1
	shll	r1
	mov.l	L3407,r2
	mov.l	@r2,r2
	add	r2,r1
	bra	L3406
	mov	r1,r7
L3403:
	add	#32,r7
L3406:
	mov	r7,r1
	add	#-2,r1
	mov.b	@r1,r1
	mov	#112,r2
	extu.b	r1,r1
	and	r2,r1
	tst	r1,r1
	bt	L3403
	rts
	mov.w	r5,@r7
	.align 2
L3407:	.long	_DAT_0604799c
	.global _FUN_06047986
	.align 2
_FUN_06047986:
L3409:
	mov.w	@r4,r1
	tst	r1,r1
	bt	L3412
	mov.w	@r4,r1
	bra	L3408
	mov	r1,r0
L3412:
	dt	r5
	add	#-4,r4
	bf	L3409
	mov.l	L3414,r1
	mov.w	@r1,r1
L3408:
	rts
	mov	r1,r0
	.align 2
L3414:	.long	_DAT_06047998
	.global _FUN_060479a0
	.align 2
_FUN_060479a0:
	mov	r4,r6
	add	#-4,r6
	mov	r5,r7
L3416:
	mov.w	@r6,r1
	mov	r1,r0
	tst	r0,r0
	bt	L3419
	bra	L3421
	nop
L3419:
	dt	r7
	add	#-8,r6
	bf	L3416
	mov.l	L3428,r1
	mov.w	@r1,r1
	mov	r1,r0
L3421:
L3422:
	mov.w	@r4,r1
	mov	r1,r7
	tst	r7,r7
	bt	L3425
	nop
	rts
	nop
L3425:
	dt	r5
	add	#-8,r4
	bf	L3422
	mov.l	L3429,r1
	mov.w	@r1,r1
L3415:
	rts
	mov	r1,r7
	.align 2
L3428:	.long	_DAT_060479d2
L3429:	.long	_DAT_060479d4
	.global _FUN_060479d6
	.align 2
_FUN_060479d6:
	sts.l	pr,@-r15
	mov.l	L3431,r1
	mov.l	@r1,r13
	mov.l	L3432,r1
	mov.l	@r1,r1
	mov	#0,r2
	mov.l	L3433,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.l	L3434,r1
	mov.w	@r1,r1
	mov.w	r1,@r13
	mov.l	L3435,r1
	mov.w	@r1,r1
	mov	r1,r0
	mov.l	L3436,r3
	jsr	@r3
	mov.l	L3438,r5
	mov.l	L3437,r4
	mov.l	L3439,r3
	mov.l	@r4,r4
	mov.l	L3439,r3
	jsr	@r3
	mov.l	@r5,r5
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3431:	.long	_DAT_06047a54
L3432:	.long	_DAT_06047a50
L3433:	.long	_FUN_06047a84
L3434:	.long	_DAT_06047a48
L3435:	.long	_DAT_06047a4a
L3436:	.long	_FUN_06047ae0
L3437:	.long	_DAT_06047a58
L3438:	.long	_PTR_DAT_06047a5c
L3439:	.long	_FUN_06047b00
	.global _FUN_06047a08
	.align 2
_FUN_06047a08:
	sts.l	pr,@-r15
	mov.l	L3441,r1
	mov.l	@r1,r11
	mov.l	L3442,r1
	mov.l	@r1,r1
	mov	#1,r2
	mov.l	L3443,r3
	jsr	@r3
	mov.l	L3444,r3
	jsr	@r3
	mov.l	r2,@r1
	mov.l	L3445,r1
	mov.w	@r1,r1
	mov.w	r1,@r11
	mov	r13,r0
	mov.w	r0,@(2,r11)
	mov	r11,r1
	add	#32,r1
	mov.l	L3445,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	r11,r1
	add	#34,r1
	mov.l	L3446,r3
	jsr	@r3
	mov.l	L3448,r5
	mov.l	L3447,r4
	mov.l	L3449,r3
	mov.w	r12,@r1
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L3451,r5
	mov.l	L3450,r4
	mov.l	L3449,r3
	mov.l	@r5,r5
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov	r0,r1
	mov	r1,r14
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3441:	.long	_DAT_06047a54
L3442:	.long	_DAT_06047a50
L3443:	.long	_FUN_06047a84
L3444:	.long	_func_0x06047b34
L3445:	.long	_DAT_06047a48
L3446:	.long	_FUN_06047ae0
L3447:	.long	_DAT_06047a58
L3448:	.long	_PTR_DAT_06047a60
L3449:	.long	_func_0x06047b00
L3450:	.long	_DAT_06047a64
L3451:	.long	_PTR_DAT_06047a68
	.global _FUN_06047a84
	.align 2
_FUN_06047a84:
	mov.l	L3455,r1
	mov.w	@r1,r1
	mov.w	r1,@r4
	mov.l	L3456,r1
	mov.l	@r1,r1
	mov.l	r1,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3457,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	#0,r1
	mov.l	r1,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3458,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#68,r1
	mov.l	L3459,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#76,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#88,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov.l	L3460,r1
	mov.w	@r1,r6
	mov.l	L3461,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	mov.w	L3462,r2
	and	r2,r1
	tst	r1,r1
	bt	L3453
	mov.l	L3460,r1
	mov.w	@r1,r1
	add	#-2,r1
	mov	r1,r6
L3453:
	mov	r4,r1
	add	#78,r1
	exts.w	r6,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#82,r1
	exts.w	r6,r2
	mov.w	r2,@r1
	mov.l	L3463,r1
	mov.w	@r1,r1
	mov	r1,r7
	mov	r4,r2
	add	#80,r2
	mov.w	r1,@r2
	mov	r4,r1
	add	#84,r1
	mov.w	r7,@r1
	mov.l	L3464,r1
	mov.w	@r1,r1
	mov	r1,r7
	mov	r4,r2
	add	#86,r2
	mov.w	r1,@r2
	mov	r4,r1
	add	#90,r1
	rts
	mov.w	r7,@r1
	.align 2
L3462:	.short	192
	.align 2
L3455:	.long	_DAT_06047ac6
L3456:	.long	_DAT_06047ad4
L3457:	.long	_DAT_06047ac8
L3458:	.long	_DAT_06047aca
L3459:	.long	_DAT_06047ad8
L3460:	.long	_DAT_06047acc
L3461:	.long	_DAT_06047adc
L3463:	.long	_DAT_06047ace
L3464:	.long	_DAT_06047ad0
	.global _FUN_06047ae0
	.align 2
_FUN_06047ae0:
	mov	r4,r1
	add	#32,r1
	mov.l	L3466,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#44,r1
	mov	#0,r2
	mov.l	r2,@r1
	mov	r4,r6
	add	#64,r6
	mov.l	L3467,r1
	mov.w	@r1,r1
	mov.w	r1,@r6
	mov.l	L3468,r1
	mov.l	@r1,r1
	mov	r1,r7
	mov.l	r6,@r1
	mov	r6,r1
	rts
	mov.l	r1,@(4,r14)
	.align 2
L3466:	.long	_DAT_06047af8
L3467:	.long	_DAT_06047afa
L3468:	.long	_DAT_06047afc
	.global _FUN_06047b00
	.align 2
_FUN_06047b00:
	mov.l	L3470,r1
	mov.w	@r1,r1
	mov.w	r1,@r4
	mov.l	@r5,r1
	mov.l	r1,@(12,r4)
	mov.l	@(4,r5),r1
	mov.l	r1,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3471,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.l	@(8,r5),r1
	mov.l	r1,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3472,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#66,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#96,r1
	mov.l	L3473,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov.w	L3474,r2
	add	r4,r2
	mov.l	L3472,r1
	mov.w	@r1,r1
	rts
	mov.w	r1,@r2
	.align 2
L3474:	.short	224
	.align 2
L3470:	.long	_DAT_06047b6c
L3471:	.long	_DAT_06047b6e
L3472:	.long	_DAT_06047b70
L3473:	.long	_DAT_06047b72
	.global _FUN_06047b34
	.align 2
_FUN_06047b34:
	mov.l	L3476,r1
	mov.w	@r1,r1
	mov.w	r1,@r4
	mov	#0,r1
	mov.l	r1,@(12,r4)
	mov.l	L3477,r1
	mov.l	@r1,r1
	mov.l	r1,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3478,r2
	mov.w	@r2,r2
	mov.w	r2,@r1
	mov	#0,r1
	mov.l	r1,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3479,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#68,r1
	mov.l	L3480,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#76,r1
	mov.l	L3481,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#80,r1
	mov.l	L3482,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#84,r1
	mov.l	L3483,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
	mov	r4,r1
	add	#88,r1
	mov.l	L3484,r2
	mov.l	@r2,r2
	rts
	mov.l	r2,@r1
	.align 2
L3476:	.long	_DAT_06047b6c
L3477:	.long	_DAT_06047b74
L3478:	.long	_DAT_06047b6e
L3479:	.long	_DAT_06047b78
L3480:	.long	_DAT_06047b7c
L3481:	.long	_DAT_06047b80
L3482:	.long	_DAT_06047b84
L3483:	.long	_DAT_06047b88
L3484:	.long	_DAT_06047b8c
	.global _FUN_06047d3c
	.align 2
_FUN_06047d3c:
	mov.l	L3486,r1
	mov.l	@r1,r1
	mov	r4,r2
	add	#8,r2
	mov.l	L3487,r3
	mov.l	@r3,r3
	and	r3,r2
	shlr2	r2
	add	r2,r1
	mov.w	@r1,r1
	mov	r1,r0
	shll2	r0
	rts
	nop
	.align 2
L3486:	.long	_PTR_DAT_06047db8
L3487:	.long	_DAT_06047db0
	.global _FUN_06047d46
	.align 2
_FUN_06047d46:
	mov	r7,r0
	mov.w	@(r0,r4),r1
	mov	r1,r0
	shll2	r0
	rts
	nop
