	.global _FUN_06047748
	.text
	.align 2
_FUN_06047748:
	mov.l	L7,r7
L2:
	mov.w	@r5,r0
	tst	r0,r0
	bt	L5
	mov	r4,r0
	shll2	r0
	shll	r0
	add	r7,r0
	add	#2,r0
	mov	r0,r1
	mov.w	@r5,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.w	r0,@r5
	mov.w	@(2,r5),r0
	mov	r0,r4
L5:
	dt	r6
	add	#-4,r5
	bf	L2
	rts
	mov	r4,r0
	.align 2
L7:	.long	100773888
