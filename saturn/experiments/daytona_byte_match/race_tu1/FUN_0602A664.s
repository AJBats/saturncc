	.global _FUN_0602A664
	.text
	.align 2
_FUN_0602A664:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-12,r15
	mov.l	L15,r1
	mov	#17,r2
	mov.b	r2,@r1
	mov.l	L16,r1
	mov.l	@r1,r1
	jsr	@r1
	nop
	mov.l	L17,r1
	mov.l	@r1,r14
	mov	r14,r1
	mov.l	@(4,r1),r13
	mov.l	@(8,r1),r12
	mov.l	@(12,r1),r11
	mov.l	@(16,r1),r10
	mov.l	@(20,r1),r9
L2:
	mov.l	@r12,r8
	add	#4,r12
	mov	r8,r1
	add	r11,r1
	mov.l	@r1,r8
	mov	r8,r1
	add	r10,r1
	mov.l	r1,@(8,r15)
	tst	r8,r8
	bt	L5
L7:
	mov.l	@(8,r15),r1
	mov.w	@r1,r2
	mov	r2,r0
	mov.w	r0,@(6,r15)
	add	#2,r1
	mov.l	r1,@(8,r15)
	mov.w	@(6,r15),r0
	mov	r0,r1
	mov	r1,r0
	cmp/eq	#-1,r0
	bf	L11
	bra	L9
	nop
L11:
	mov.l	L18,r1
	mov.l	@r1,r1
	mov.w	@(6,r15),r0
	exts.w	r0,r0
	mov	r0,r2
	add	r2,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r1
	mov.b	@r1,r1
	tst	r1,r1
	bf	L7
	mov.l	@(0,r15),r1
	mov	#1,r2
	mov.b	r2,@r1
	mov.l	L19,r1
	mov.l	@r1,r1
	jsr	@r1
	nop
	bra	L7
	nop
L9:
L5:
	dt	r9
L3:
	bf	L2
	mov	r11,r0
L1:
	add	#12,r15
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
L15:	.long	_DAT_0602A6C8
L16:	.long	_DAT_0602A6CC
L17:	.long	_DAT_0602A6D0
L18:	.long	_DAT_0602A6D4
L19:	.long	_DAT_0602A6DC
