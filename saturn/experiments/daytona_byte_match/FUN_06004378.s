	.global _FUN_06004378
	.text
	.align 2
_FUN_06004378:
	mov.l	r14,@-r15
	extu.b	r4,r14
	mov	#47,r1
	cmp/hs	r14,r1
	bt	L2
	mov	#58,r1
	cmp/hs	r1,r14
	bt	L2
	mov.l	L14,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r4,r1
	bra	L1
	mov	r1,r0
L2:
	mov	#64,r1
	cmp/hs	r14,r1
	bt	L4
	mov	#91,r1
	cmp/hs	r1,r14
	bt	L4
	mov.l	L15,r1
	mov.w	@r1,r1
	exts.w	r1,r1
	add	r4,r1
	bra	L1
	mov	r1,r0
L4:
	mov	r14,r0
	cmp/eq	#34,r0
	bf	L6
	bra	L1
	mov	#37,r0
L6:
	mov	r14,r0
	cmp/eq	#39,r0
	bf	L8
	bra	L1
	mov	#36,r0
L8:
	mov	r14,r0
	cmp/eq	#45,r0
	bf	L10
	bra	L1
	mov	#38,r0
L10:
	mov	r14,r0
	cmp/eq	#46,r0
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
