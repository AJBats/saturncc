	.global FUN_0602A664
	.text
	.align 2
FUN_0602A664:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-12,r15
	mov.l	L15,r0
	mov	#17,r1
	mov.b	r1,@r0
	mov.l	L16,r0
	jsr	@r0
	nop
	mov.l	L17,r8
	mov	r8,r0
	mov.l	@(4,r0),r9
	mov.l	@(8,r0),r10
	mov.l	@(12,r0),r11
	mov.l	@(16,r0),r12
	mov.l	@(20,r0),r13
L2:
	mov.l	@r10+,r14
	mov	r14,r0
	mov.l	@(r0,r11),r14
	mov	r14,r0
	add	r12,r0
	tst	r14,r14
	bt/s	L5
	mov.l	r0,@(8,r15)
L7:
	mov.l	@(8,r15),r0
	mov.w	@r0,r1
	mov	r1,r0
	mov.w	r0,@(6,r15)
	add	#2,r0
	mov.l	r0,@(8,r15)
	mov.w	@(6,r15),r0
	cmp/eq	#-1,r0
	bf	L11
	bra	L9
	nop
L11:
	mov.w	@(6,r15),r0
	mov.l	L18,r1
	add	r1,r0
	mov.l	r0,@(0,r15)
	mov.l	@(0,r15),r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L7
	mov.l	@(0,r15),r0
	mov	#1,r1
	mov.b	r1,@r0
	mov.l	L19,r0
	jsr	@r0
	nop
	bra	L7
	nop
L9:
L5:
	dt	r13
	bf	L2
	mov	r11,r0
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
L15:	.long	-366
L16:	.long	100947608
L17:	.long	100847872
L18:	.long	637867836
L19:	.long	100948312
