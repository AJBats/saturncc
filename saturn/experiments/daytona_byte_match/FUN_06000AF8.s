	.global _FUN_06000AF8
	.text
	.align 2
_FUN_06000AF8:
	sts.l	pr,@-r15
	mov.l	L2,r1
	mov.w	@r1,r1
	extu.w	r1,r4
	mov.l	L3,r5
	mov.l	L4,r6
	mov.l	L5,r1
	jsr	@r1
	nop
	mov.l	L6,r1
	mov.b	@r1,r2
	exts.b	r2,r2
	add	#1,r2
L1:
	lds.l	@r15+,pr
	rts
	mov.b	r2,@r1
	.align 2
L2:	.long	_dat_06039FC8
L3:	.long	_daytona96_str
L4:	.long	_ram_06036F58_base
L5:	.long	_ext_func
L6:	.long	_cnt_06036F37
