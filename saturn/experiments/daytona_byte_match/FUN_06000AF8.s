	.global _FUN_06000AF8
	.text
	.align 2
_FUN_06000AF8:
	sts.l	pr,@-r15
	mov.l	L6,r6
	mov.l	L5,r5
	mov.l	L4,r4
	mov.l	L7,r1
	mov.w	@r4,r4
	jsr	@r1
	extu.w	r4,r4
	mov	r0,r4
	tst	r4,r4
	bt	L2
L2:
	mov.l	L8,r1
	mov.b	@r1,r2
	extu.b	r2,r2
	add	#1,r2
	mov.b	r2,@r1
L1:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L4:	.long	_dat_06039FC8
L5:	.long	_daytona96_str
L6:	.long	_ram_06036F58_base
L7:	.long	_ext_func
L8:	.long	_cnt_06036F37
