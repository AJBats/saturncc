	.global _FUN_0604025C
	.text
	.align 2
_FUN_0604025C:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L2,r3
	jsr	@r3
	nop
	add	#16,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r14,r0
	add	#19,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov	r14,r0
	add	#18,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov.l	r14,@(20,r14)
	mov	r14,r0
	add	#16,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2:	.long	100744056
