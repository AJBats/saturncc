	.global _FUN_06004378
	.text
	.align 2
_FUN_06004378:
	mov.l	r14,@-r15
	mov	#48,r3
	extu.b	r4,r14
	cmp/ge	r3,r14
	bf	L2
	mov	#57,r1
	cmp/gt	r1,r14
	bt	L2
	mov.w	L14,r0
	add	r4,r0
	rts
	mov.l	@r15+,r14
L2:
	mov	#65,r2
	cmp/ge	r2,r14
	bf	L4
	mov	#90,r1
	cmp/gt	r1,r14
	bt	L4
	mov.w	L15,r0
	add	r4,r0
	rts
	mov.l	@r15+,r14
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
	bra	Ld26
	nop
L8:
	mov	#36,r0
	rts
	mov.l	@r15+,r14
L6:
	mov	#37,r0
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
Ld26:
	mov	#41,r0
	rts
	mov.l	@r15+,r14
	.align 2
L14:	.short	208
L15:	.short	201
