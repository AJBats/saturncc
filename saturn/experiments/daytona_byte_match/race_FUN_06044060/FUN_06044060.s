	.global _FUN_06044060
	.text
	.align 2
_FUN_06044060:
	sts.l	pr,@-r15
	add	#48,r4
	mov.l	L4,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L5,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L2
	mov.l	L6,r3
	jsr	@r3
	nop
L2:
	mov.l	L7,r3
	jsr	@r3
	nop
	mov.l	L8,r3
	jsr	@r3
	nop
	mov.l	L9,r3
	jsr	@r3
	nop
	mov.l	L10,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L4:	.long	_pcRam060440c0
L5:	.long	_pcRam060440c4
L6:	.long	_PTR_FUN_060440c8
L7:	.long	_PTR_SUB_060440cc
L8:	.long	_PTR_SUB_060440d0
L9:	.long	_PTR_SUB_060440d4
L10:	.long	_pcRam060440dc
	.global _FUN_060440e0
	.align 2
_FUN_060440e0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#4,r13
L12:
	add	#48,r14
	mov	r14,r4
	mov.l	L15,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L16,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	mov.l	L17,r1
	mov.l	@r1,r3
	jsr	@r3
	nop
	add	#-48,r14
	dt	r13
	bf	L12
	lds.l	@r15+,pr
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L15:	.long	_pcRam06044128
L16:	.long	_pcRam0604412c
L17:	.long	_pcRam06044134
	.global _FUN_060446f4
	.align 2
_FUN_060446f4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	sts.l	pr,@-r15
	mov.l	L27,r1
	mov.l	@r1,r1
	mov	r1,r13
	mov.l	@r1,r1
	mov	r1,r11
	mov.l	L28,r1
	mov.l	@r1,r1
	mov.w	r1,@r11
	mov.l	L29,r1
	mov.l	@r1,r1
	mov	r1,r12
	mov.l	L31,r3
	mov.l	L30,r1
	mov.l	@r1,r1
	mov.l	L31,r3
	jsr	@r3
	mov.l	r12,@(20,r11)
	mov.l	L32,r1
	mov.l	@r1,r1
	mov.l	@r1,r9
	mov.l	L33,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	bra	L22
	mov	r1,r10
L19:
	mov.l	L34,r3
	jsr	@r3
	mov	r9,r4
	mov.l	L35,r1
	mov.l	@r1,r1
	mov	r9,r1
	add	r1,r1
	mov.l	@r1,r9
	add	#-1,r10
L22:
	tst	r10,r10
	bf	L19
	mov.l	L36,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bt	L23
	mov.l	L37,r1
	mov.l	@r1,r1
	mov	r1,r12
	mov	r14,r1
	add	#18,r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L25
	mov.l	L38,r1
	mov.l	@r1,r1
	mov	r1,r12
L25:
	mov.l	L34,r3
	jsr	@r3
	mov	r12,r4
L23:
	mov	r11,r1
	add	#32,r1
	mov.l	r1,@r13
	lds.l	@r15+,pr
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L27:	.long	_DAT_06044768
L28:	.long	_DAT_06044762
L29:	.long	_DAT_06044784
L30:	.long	_DAT_06044780
L31:	.long	_FUN_06044834
L32:	.long	_DAT_0604476c
L33:	.long	_DAT_06044770
L34:	.long	_FUN_06044788
L35:	.long	_DAT_06044764
L36:	.long	_DAT_06044774
L37:	.long	_DAT_06044778
L38:	.long	_DAT_0604477c
	.global _FUN_06044788
	.align 2
_FUN_06044788:
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
	bt	L40
	not	r10,r1
	mov	r1,r12
	add	#1,r12
L40:
	mov	r12,r1
	mov.l	L50,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L42
	mov	r9,r12
	mov	r9,r1
	mov	#0,r2
	cmp/ge	r2,r1
	bt	L44
	not	r9,r1
	mov	r1,r12
	add	#1,r12
L44:
	mov	r12,r1
	mov.l	L50,r2
	mov.l	@r2,r2
	cmp/gt	r2,r1
	bt	L46
	mov.l	L51,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r1
	mov.l	L52,r3
	jsr	@r3
	neg	r1,r4
	mov.l	@(4,r15),r1
	mov	r4,r12
	sub	r1,r12
	mov.l	L53,r1
	mov.l	@r1,r1
	mov.b	@r1,r1
	tst	r1,r1
	bt	L48
	not	r12,r1
	mov	r1,r12
	add	#1,r12
	not	r10,r1
	mov	r1,r10
	add	#1,r10
L48:
	mov	r12,r1
	shlr8	r1
	shlr2	r1
	shlr2	r1
	mov	#7,r2
	and	r2,r1
	mov.l	L54,r2
	add	r2,r1
	mov.b	@r1,r13
	mov.l	L55,r1
	mov.l	@r1,r1
	mov	r12,r2
	shlr8	r2
	shlr2	r2
	shlr2	r2
	shlr2	r2
	mov	#3,r3
	and	r3,r2
	mov.l	L56,r3
	add	r3,r2
	mov.b	@r2,r2
	exts.w	r2,r2
	or	r2,r1
	mov.w	r1,@r8
	mov.l	L57,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r8)
	mov.l	L58,r1
	mov.l	@r1,r1
	mov	r13,r2
	shll16	r2
	add	r2,r1
	mov.l	r1,@(8,r8)
	mov.l	L59,r1
	mov.l	@r1,r1
	mov	r10,r2
	shlr16	r2
	exts.w	r2,r2
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(12,r8)
	mov.l	L60,r1
	mov.l	@r1,r1
	mov	r9,r2
	shlr16	r2
	mov	r1,r1
	add	r2,r1
	mov	r1,r0
	mov.w	r0,@(14,r8)
L46:
L42:
	mov	r12,r0
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
L50:	.long	_DAT_06044814
L51:	.long	_FUN_06044834
L52:	.long	_PTR_FUN_06044818
L53:	.long	_DAT_0604481c
L54:	.long	_DAT_06044828
L55:	.long	_DAT_0604480c
L56:	.long	_DAT_06044830
L57:	.long	_DAT_06044820
L58:	.long	_DAT_06044824
L59:	.long	_DAT_0604480e
L60:	.long	_DAT_06044810
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
