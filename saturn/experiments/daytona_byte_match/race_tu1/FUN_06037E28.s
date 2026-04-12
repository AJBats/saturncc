	.global _FUN_06037E28
	.text
	.align 2
_FUN_06037E28:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	sts.l	pr,@-r15
	mov.l	L4,r1
	jsr	@r1
	mov	r4,r14
	mov.w	L5,r1
	extu.b	r14,r2
	mul.l	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	L6,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r1,r13
	mov.w	L7,r2
	add	r13,r2
	mov.l	@r2,r11
	mov	r13,r1
	add	#92,r1
	mov.l	@r1,r12
	mov	r12,r0
	cmp/eq	#10,r0
	bf	L2
	mov	#10,r0
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L4:	.long	_setup_func
L5:	.short	472
L6:	.long	_base_array
L7:	.short	352
L2:
	mov	r12,r0
L1:
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
