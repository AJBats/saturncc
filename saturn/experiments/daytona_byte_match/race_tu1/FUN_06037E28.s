	.global _FUN_06037E28
	.text
	.align 2
_FUN_06037E28:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	mov.l	L8,r1
	jsr	@r1
	mov	r4,r14
	mov.w	L9,r1
	mov	r14,r2
	extu.w	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	L10,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r1,r12
	mov.w	L11,r2
	add	r12,r2
	mov.l	@r2,r11
	mov	r12,r1
	add	#92,r1
	mov.l	@r1,r13
	mov	r13,r0
	cmp/eq	#10,r0
	bf	L2
	mov	#10,r0
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L2:
	mov	r12,r1
	add	#92,r1
	mov.l	@r1,r13
	mov	r13,r0
	cmp/eq	#6,r0
	bt	L4
	mov	r13,r0
	cmp/eq	#7,r0
	bt	L4
	mov	r13,r0
	cmp/eq	#8,r0
	bt	L4
	mov	r12,r1
	add	#18,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L12,r1
	mov.b	@r1,r1
	exts.b	r1,r1
	mov	r1,r0
	cmp/eq	#1,r0
	bf	L6
	mov.l	L13,r1
	jsr	@r1
	nop
	bra	L7
	nop
L6:
	mov	r12,r4
	add	#18,r4
	mov.b	@r4,r4
	mov.l	L14,r1
	jsr	@r1
	exts.b	r4,r4
L7:
L4:
	mov	r13,r0
L1:
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L8:	.long	_setup_func
L9:	.short	472
L10:	.long	_base_array
L11:	.short	352
L12:	.long	_dat_060540B4
L13:	.long	_sub_06037EA4
L14:	.long	_sub_06037ED4
