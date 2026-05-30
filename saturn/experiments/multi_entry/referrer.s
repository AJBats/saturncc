	.global referrer
	.global _shared_target
	.text
referrer:
	mov.l	RP0,r12
	jsr	@r12
	nop
	rts
	nop
_shared_target:
	rts
	nop
	.align 2
RP0:	.long	FUN_inner
