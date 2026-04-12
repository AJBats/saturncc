	.global _FUN_06004378
	.text
	.align 2
_FUN_06004378:
	mov.l	r14,@-r15
	extu.b	r4,r14
	mov	#48,r2
	cmp/ge	r2,r14
	bf	L2
	mov	#57,r2
	cmp/gt	r2,r14
	bt	L2
	mov.w	L14,r0
	add	r4,r0
	rts
	mov.l	@r15+,r14
L2:
	mov	#65,r2
	cmp/ge	r2,r14
	bf	L4
	mov	#90,r2
	cmp/gt	r2,r14
	bt	L4
	mov.w	L15,r0
	add	r4,r0
	rts
	mov.l	@r15+,r14
	.align 2
L14:	.short	208
L15:	.short	201
L4:
	mov	r14,r0
	cmp/eq	#34,r0
	bt	L6
	cmp/eq	#39,r0
	bt	L8
	cmp/eq	#45,r0
	bt	L10
	cmp/eq	#46,r0
	bt	L12
	bra	Ld28
	nop
L6:
	mov	#37,r0
	rts
	mov.l	@r15+,r14
L8:
	mov	#36,r0
	rts
	mov.l	@r15+,r14
L10:
	mov	#38,r0
	rts
	mov.l	@r15+,r14
L12:
	mov	#39,r0
	rts
	mov.l	@r15+,r14
Ld28:
	mov	#41,r0
	rts
	mov.l	@r15+,r14
