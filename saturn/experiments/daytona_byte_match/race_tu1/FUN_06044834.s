	.global _FUN_06044834
	.text
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
