	.global _FUN_06040EA0
	.text
	.align 2
_FUN_06040EA0:
	mov.l	r14,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	stc.l	gbr,@-r15
	ldc	r4,gbr
	mov	r4,r14
	mov.l	@(52,gbr),r0
	mov	r0,r1
	tst	r1,r1
	bt	L2
	mov.l	@(40,gbr),r0
	mov	r0,r1
	tst	r1,r1
	bf	L2
	mov.l	L15,r1
	mov.l	@r1,r1
	mov	#1,r2
	and	r2,r1
	tst	r1,r1
	bf	L2
	mov.l	L16,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#2,r1
	sub	r1,r4
	mov	#0,r1
	cmp/ge	r1,r4
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
	mov	r0,r1
	mov.l	L19,r2
	and	r2,r1
	tst	r1,r1
	bf	L12
	mov.l	@(48,gbr),r0
	mov	r0,r2
	mov.l	L19,r3
	or	r3,r2
	mov.l	r2,@r1
	mov	#0,r1
	mov	r1,r4
	mov	r1,r5
	mov.l	L20,r1
	jsr	@r1
	bra	L12
	mov	#32,r6
L8:
L6:
	mov.l	@(48,gbr),r0
	mov	r0,r2
	mov.l	L21,r3
	and	r3,r2
	mov.l	r2,@r1
L12:
	mov.b	@(18,gbr),r0
	mov	r0,r4
	mov.l	L22,r3
	jsr	@r3
	exts.b	r4,r4
	mov	r0,r4
	tst	r4,r4
	bt	L13
	mov.l	L23,r1
	jsr	@r1
	nop
	mov.l	L24,r1
	jsr	@r1
	mov	r14,r4
	mov.w	@(14,gbr),r0
	mov	r0,r1
	exts.w	r1,r1
	mov.l	L25,r2
	exts.w	r2,r2
	mov	r1,r4
	mov.l	L26,r1
	jsr	@r1
	add	r2,r4
	mov.w	@(12,gbr),r0
	mov	r0,r1
	exts.w	r1,r1
	mov.w	L27,r3
	add	r14,r3
	mov.w	@r3,r2
	exts.w	r2,r2
	mov	r1,r4
	mov.l	L28,r1
	jsr	@r1
	sub	r2,r4
	mov.w	@(16,gbr),r0
	mov	r0,r1
	exts.w	r1,r1
	neg	r1,r4
	mov.l	L29,r1
	jsr	@r1
	nop
	mov.w	@(26,gbr),r0
	mov	r0,r4
	mov.l	L26,r1
	jsr	@r1
	mov.l	L30,r1
	jsr	@r1
	exts.w	r4,r4
	mov	r12,r4
	mov.l	L31,r1
	jsr	@r1
	add	#20,r4
	mov	#4,r1
	mov	r4,r1
	add	#4,r1
	mov.l	r1,@r1
	mov	r4,r1
	add	#16,r1
	mov.l	L15,r2
	mov.l	@r2,r2
	mov	#6,r3
	and	r3,r2
	shll	r2
	shll2	r2
	mov.l	L32,r3
	mov.l	@r3,r3
	add	r3,r2
	mov.l	@r2,r2
	mov.l	r2,@r1
L13:
L4:
L2:
	mov.b	@(18,gbr),r0
	mov	r0,r4
	mov.l	L33,r1
	jsr	@r1
	exts.b	r4,r4
L1:
	ldc.l	@r15+,gbr
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	rts
	mov.l	@r15+,r14
	.align 2
L15:	.long	_DAT_06052E58
L16:	.long	_FUN_06040A64
L17:	.long	3276800
L18:	.long	_FUN_060424B8
L19:	.long	67108864
L20:	.long	_FUN_0602F95A
L21:	.long	-67108865
L22:	.long	_FUN_06040CF0
L23:	.long	_FUN_06044D74
L24:	.long	_FUN_06044E3C
L25:	.long	32768
L26:	.long	_FUN_0604507E
L27:	.short	410
L28:	.long	_FUN_06045006
L29:	.long	_FUN_060450F2
L30:	.long	_FUN_06044F14
L31:	.long	_FUN_06044DF4
L32:	.long	_DAT_060566B8
L33:	.long	_FUN_06040DCC
