	.global FUN_outer
	.text
FUN_outer:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	sts.l	pr,@-r15
	rts
	nop
