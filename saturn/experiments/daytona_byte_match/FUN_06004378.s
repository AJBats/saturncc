	.global _FUN_06004378
	.text
	.align 2
_FUN_06004378:
	mov.l	r14,@-r15
	extu.b	r4,r14
	mov	#47,r3
	cmp/hs	r14,r3
	bt	L2
	mov	#58,r3
	cmp/hs	r3,r14
	bt	L2
	mov.l	L14,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	add	r4,r3
	bra	L1
	mov	r3,r0
L2:
	mov	#64,r3
	cmp/hs	r14,r3
	bt	L4
	mov	#91,r3
	cmp/hs	r3,r14
	bt	L4
	mov.l	L15,r3
	mov.w	@r3,r3
	exts.w	r3,r3
	add	r4,r3
	bra	L1
	mov	r3,r0
L4:
	mov	#34,r3
	cmp/eq	r3,r14
	bf	L6
	bra	L1
	mov	#37,r0
L6:
	mov	#39,r3
	cmp/eq	r3,r14
	bf	L8
	bra	L1
	mov	#36,r0
L8:
	mov	#45,r3
	cmp/eq	r3,r14
	bf	L10
	bra	L1
	mov	#38,r0
L10:
	mov	#46,r3
	cmp/eq	r3,r14
	bt	L12
	bra	L1
	mov	#41,r0
L12:
	mov	#39,r0
L1:
	rts
	mov.l	@r15+,r14
	.align 2
L14:	.long	_sRam0602c3cc
L15:	.long	_sRam0602c3ce
