	.global FUN_00280710
	.text
	.align 2
FUN_00280710:
	mov.l	r14,@-r15
	mov.l	L5,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	tst	r0,r0
	bf/s	L4
	mov	r15,r14
	bra	Lm4
	mov	#0,r0
L4:
	mov	#1,r0
Lm4:
	mov	r14,r15
	rts
	mov.l	@r15+,r14
	.align 2
L5:	.long	dat_0028072C
