	.global _FUN_06047748
	.text
	.align 2
_FUN_06047748:
	mov.l	r14,@-r15
	mov.l	L7,r1
	mov.l	@r1,r14
L2:
	mov.w	@r5,r1
	exts.w	r1,r1
	tst	r1,r1
	bt	L5
	mov	r4,r1
	shll2	r1
	shll	r1
	add	r14,r1
	add	#2,r1
	mov.w	@r5,r2
	mov.w	r2,@r1
	mov	#0,r1
	mov.w	r1,@r5
	mov	r5,r1
	add	#2,r1
	mov.w	@r1,r1
	exts.w	r1,r4
L5:
	add	#-1,r6
	add	#-4,r5
L3:
	tst	r6,r6
	bf	L2
	mov	r4,r0
L1:
	rts
	mov.l	@r15+,r14
	.align 2
L7:	.long	_DAT_0604776c
