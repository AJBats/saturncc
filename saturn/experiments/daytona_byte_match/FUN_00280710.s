	.global _FUN_00280710
	.text
	.align 2
_FUN_00280710:
	mov.l	r14,@-r15
	mov.l	L5,r3
	mov.w	@r3,r3
	extu.w	r3,r3
	tst	r3,r3
	bt	L3
	bra	L4
	mov	#1,r14
L3:
	mov	#0,r14
L4:
	mov	r14,r0
L1:
	rts
	mov.l	@r15+,r14
	.align 2
L5:	.long	_dat_0028072C
