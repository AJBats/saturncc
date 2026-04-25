	.global _FUN_06040EA0
	.text
	.align 2
_FUN_06040EA0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	stc.l	gbr,@-r15
	ldc	r4,gbr
	mov	r4,r14
	mov.l	@(52,gbr),r0
	tst	r0,r0
	bt	L2
	mov.l	@(40,gbr),r0
	tst	r0,r0
	bf	L2
	mov.l	L15,r0
	mov.l	@r0,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2
	mov.l	L16,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#2,r0
	sub	r0,r4
	mov	#0,r0
	cmp/ge	r0,r4
	bf	L4
	mov	r4,r12
	tst	r4,r4
	bf	L6
	mov.l	@(0,gbr),r0
	mov	r0,r4
	mov.l	L17,r6
	mov.l	L18,r3
	mov.l	@(8,gbr),r0
	jsr	@r3
	mov	r0,r5
	tst	r0,r0
	bt	L8
	mov.l	@(48,gbr),r0
	mov.l	L19,r1
	and	r1,r0
	tst	r0,r0
	bf	L12
	mov.l	@(48,gbr),r0
	mov	r0,r1
	mov.l	L19,r2
	or	r2,r1
	mov.l	r1,@r0
	mov	#0,r0
	mov	r0,r4
	mov	r0,r5
	mov.l	L20,r0
	jsr	@r0
	mov	#32,r6
	bra	L12
	nop
L8:
L6:
	mov.l	@(48,gbr),r0
	mov	r0,r1
	mov.l	L21,r2
	and	r2,r1
	mov.l	r1,@r0
L12:
	mov.b	@(18,gbr),r0
	mov.l	L22,r3
	jsr	@r3
	mov	r0,r4
	mov	r0,r4
	tst	r4,r4
	bt	L13
	mov.l	L23,r0
	jsr	@r0
	nop
	mov.l	L24,r0
	jsr	@r0
	mov	r14,r4
	mov.w	@(14,gbr),r0
	mov.w	L25,r1
	mov	r0,r4
	mov.l	L26,r0
	jsr	@r0
	add	r1,r4
	mov.w	@(12,gbr),r0
	mov	r0,r1
	mov.w	L27,r2
	add	r14,r2
	mov.w	@r2,r0
	mov	r1,r4
	sub	r0,r4
	mov.l	L28,r0
	jsr	@r0
	nop
	mov.w	@(16,gbr),r0
	neg	r0,r4
	mov.l	L29,r0
	jsr	@r0
	nop
	mov.w	@(26,gbr),r0
	mov	r0,r4
	mov.l	L26,r0
	jsr	@r0
	nop
	mov.l	L30,r0
	jsr	@r0
	nop
	mov	r12,r4
	mov.l	L31,r0
	jsr	@r0
	add	#20,r4
	mov	#4,r0
	mov.l	r0,@(4,r4)
	mov	r4,r0
	add	#16,r0
	mov.l	L15,r1
	mov.l	@r1,r1
	mov	#6,r2
	and	r2,r1
	shll	r1
	shll2	r1
	mov.l	L32,r2
	add	r2,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
L13:
L4:
L2:
	mov.b	@(18,gbr),r0
	mov	r0,r4
	mov.l	L33,r0
	jsr	@r0
	nop
	ldc.l	@r15+,gbr
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L25:	.short	-32768
L27:	.short	410
L15:	.long	101002840
L16:	.long	_FUN_06040A64
L17:	.long	3276800
L18:	.long	_FUN_060424B8
L19:	.long	67108864
L20:	.long	_FUN_0602F95A
L21:	.long	-67108865
L22:	.long	_FUN_06040CF0
L23:	.long	_FUN_06044D74
L24:	.long	_FUN_06044E3C
L26:	.long	_FUN_0604507E
L28:	.long	_FUN_06045006
L29:	.long	_FUN_060450F2
L30:	.long	_FUN_06044F14
L31:	.long	_FUN_06044DF4
L32:	.long	101017272
L33:	.long	_FUN_06040DCC
