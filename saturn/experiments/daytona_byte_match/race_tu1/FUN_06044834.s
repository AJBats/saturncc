	.global _FUN_06044834
	.text
	.align 2
_FUN_06044834:
	mov	r4,r1
	add	#14,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	mov	r4,r2
	add	#26,r2
	mov.w	@r2,r2
	exts.w	r2,r2
	add	r2,r1
	mov	r4,r2
	add	#30,r2
	mov.w	@r2,r2
	exts.w	r2,r2
	add	r2,r1
L1:
	rts
	neg	r1,r0
