	.global _FUN_0604025C
	.text
	.align 2
_FUN_0604025C:
	sts.l	pr,@-r15
	mov.l	L2,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	r4,r1
	add	#16,r1
	mov	#0,r2
	mov.w	r2,@r1
	mov	r4,r1
	add	#19,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov	r4,r1
	add	#18,r1
	mov	#0,r2
	mov.b	r2,@r1
	mov.l	r4,@(20,r4)
	mov	r4,r0
L1:
	lds.l	@r15+,pr
	rts
	add	#16,r0
	.align 2
L2:	.long	100744056
