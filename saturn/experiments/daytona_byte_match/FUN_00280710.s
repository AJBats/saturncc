	.global _FUN_00280710
	.text
	.align 2
_FUN_00280710:
	mov.l	r14,@-r15
	mov.l	L5,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	tst	r1,r1
	bf/s	L4
	mov	r15,r14
	bra	Lm4
	mov	#0,r0
L4:
	mov	#1,r0
Lm4:
	mov	r14,r15
L1:
	rts
	mov.l	@r15+,r14
	.align 2
L5:	.long	_dat_0028072C
