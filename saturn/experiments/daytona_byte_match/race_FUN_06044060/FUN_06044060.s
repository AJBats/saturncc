	.global FUN_06044060
	.text
	.align 2
FUN_06044060:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r4,r8
	mov	r5,r9
	mov	r6,r10
	mov	r7,r11
	mov	r8,r12
	add	#48,r12
	mov.l	L2344,r3
	jsr	@r3
	mov	r12,r4
	mov.l	L2345,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2
	mov	#1,r6
	shll16	r6
	neg	r6,r5
	mov	r6,r7
	mov.l	L2346,r3
	jsr	@r3
	mov	r12,r4
L2:
	mov	r9,r5
	mov.l	L2347,r3
	jsr	@r3
	mov	r12,r4
	mov	r11,r0
	mov.l	L2348,r3
	jsr	@r3
	mov	r12,r4
	mov	r10,r0
	mov.l	L2349,r3
	jsr	@r3
	mov	r12,r4
	mov	r12,r4
	mov.l	L2350,r5
	mov.l	L2351,r3
	jsr	@r3
	mov.l	@r5,r5
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2344:	.long	FUN_06044D80
L2345:	.long	101009701
L2346:	.long	FUN_06044F30
L2347:	.long	FUN_06044E3C
L2348:	.long	FUN_060450F2
L2349:	.long	FUN_06045006
L2350:	.long	101018036
L2351:	.long	FUN_060457DC
	.global FUN_060440e0
	.align 2
FUN_060440e0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r4,r8
	mov	#4,r9
L5:
	add	#48,r8
	mov	r8,r4
	mov.l	L2352,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2353,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2354,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	add	#-48,r8
	dt	r9
	bf	L5
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2352:	.long	pcRam06044128
L2353:	.long	pcRam0604412c
L2354:	.long	pcRam06044134
	.global FUN_06044138
	.align 2
FUN_06044138:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-36,r15
	mov.l	L2355,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	L2356,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r0,r3
	jsr	@r3
	nop
	mov.l	L2357,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#12,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L2358,r4
	mov.l	@r4,r4
	mov	#0,r5
	mov	#24,r6
	mov	r14,r3
	jsr	@r3
	nop
	mov.l	L2359,r0
	mov.l	@r0,r12
	mov.l	L2360,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov	#0,r0
	mov.l	r0,@(32,r15)
	mov.l	L2361,r0
	mov.l	@r0,r0
	mov	#0,r1
	mov.b	r1,@r0
	mov.l	L2362,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r15)
	mov.l	L2363,r0
	mov.l	@r0,r13
	mov.l	L2364,r0
	mov.l	@r0,r0
	mov.l	r0,@(0,r15)
	mov.l	L2365,r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r15)
	mov.l	L2366,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
L9:
	mov.l	@(32,r15),r0
	mov	#6,r1
	mov	r0,r2
	exts.b	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(24,r15)
	mov.l	@(24,r15),r1
	mov.l	@(0,r15),r2
	add	r2,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(32,r15),r0
	mov	r0,r1
	add	#1,r1
	mov.l	r1,@(28,r15)
	mov.l	@(24,r15),r1
	add	#1,r1
	add	r13,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(4,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(2,r1)
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(3,r1)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(4,r1)
	mov.l	@(24,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(28,r15),r0
	mov	#6,r1
	mov	r0,r2
	exts.b	r2,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(24,r15)
	mov.l	@(24,r15),r1
	mov.l	@(0,r15),r2
	add	r2,r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(28,r15),r0
	add	r13,r0
	mov.b	@r0,r0
	mov.b	r0,@(1,r1)
	mov.l	@(32,r15),r0
	add	#2,r0
	mov.l	r0,@(32,r15)
	mov.l	@(24,r15),r0
	mov	r0,r1
	add	#2,r1
	mov.l	@(4,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@r1
	mov.l	@(24,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(3,r1)
	mov.l	@(16,r15),r0
	add	#2,r0
	mov.l	r0,@(16,r15)
	mov.l	@(24,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(4,r1)
	mov.l	@(8,r15),r0
	add	#2,r0
	mov.l	r0,@(8,r15)
	mov.l	@(24,r15),r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r0
	add	#2,r0
	mov.l	r0,@(4,r15)
	mov.l	@(32,r15),r0
	mov	#2,r1
	cmp/ge	r1,r0
	bf	L9
	mov.l	L2367,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	tst	r0,r0
	bf	L12
	mov.l	L2368,r0
	mov.l	@r0,r0
	mov.l	L2369,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov.l	L2370,r0
	mov.l	@r0,r11
	mov.l	L2371,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L14
	mov	#2,r1
	mov.l	L2372,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/ge	r0,r1
	bt	L16
	mov	#0,r0
	mov.l	r0,@(0,r15)
	mov.l	L2360,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov.l	L2373,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r15)
	mov.l	L2374,r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r15)
L18:
	mov	#6,r0
	mov.l	@(0,r15),r1
	exts.b	r1,r1
	muls.w	r1,r0
	sts	macl,r0
	exts.b	r0,r0
	add	r12,r0
	mov.l	r0,@(4,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(2,r1)
	mov	#6,r0
	mov.l	@(0,r15),r0
	mov	r0,r1
	exts.b	r1,r1
	mul.l	r1,r0
	sts	macl,r1
	add	#6,r1
	exts.b	r1,r1
	add	r12,r1
	mov.l	r1,@(4,r15)
	add	#2,r0
	mov.l	r0,@(0,r15)
	mov.l	@(4,r15),r1
	mov.l	@(8,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(5,r1)
	mov.l	@(4,r15),r1
	mov.l	@(16,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r1
	mov.l	@(20,r15),r0
	mov.b	@(1,r0),r0
	mov.b	r0,@(2,r1)
	mov.l	@(20,r15),r0
	add	#2,r0
	mov.l	r0,@(20,r15)
	mov.l	@(16,r15),r0
	add	#2,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	add	#2,r0
	mov.l	r0,@(8,r15)
	mov.l	@(0,r15),r0
	mov	#2,r1
	cmp/ge	r1,r0
	bf	L18
L16:
	mov.l	L2375,r0
	mov.l	@r0,r10
	mov	#1,r0
	mov.l	r0,@r11
	mov	#20,r0
	mov.l	r0,@(4,r11)
	mov.b	@r12,r0
	mov.b	r0,@(8,r11)
	mov	r11,r1
	add	#9,r1
	mov.b	@(1,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#10,r1
	mov.b	@(2,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#11,r1
	mov.b	@(3,r12),r0
	mov.b	r0,@r1
	mov.b	@(4,r12),r0
	mov.b	r0,@(12,r11)
	mov	r11,r1
	add	#13,r1
	mov.b	@(5,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#14,r1
	mov.b	@(6,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#15,r1
	mov.b	@(7,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#16,r1
	mov.b	@(8,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#17,r1
	mov.b	@(9,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#18,r1
	mov.b	@(10,r12),r0
	mov.b	r0,@r1
	mov	r11,r1
	add	#19,r1
	mov.b	@(11,r12),r0
	mov.b	r0,@r1
	mov.l	L2376,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	mov	r0,r9
	mov.l	L2377,r0
	mov.l	@r0,r8
	mov	r9,r0
	tst	r0,r0
	bf	L21
	mov.l	L2378,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.w	L2379,r1
	mov.l	L2380,r2
	mov.l	@r2,r2
	mov.b	@r2,r2
	mul.l	r2,r1
	sts	macl,r1
	shll2	r1
	mov	r1,r8
	add	r0,r8
L21:
	mov	r8,r0
	mov.l	r0,@r10
	mov.l	L2384,r0
	mov.l	@r0,r0
	mov.l	r0,@(8,r15)
	mov.l	L2372,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L15
	mov.l	L2381,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L15
	mov.l	L2382,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#6,r0
	bt	L15
	mov.l	@r10,r0
	mov	r0,r9
	mov.l	@r9,r0
	tst	r0,r0
	bt	L15
	mov.l	@r10,r0
	mov.l	r0,@(0,r15)
	mov.l	@(0,r15),r0
	add	#8,r0
	mov.b	@r0,r0
	mov.b	r0,@(6,r12)
	mov.l	@(0,r15),r0
	add	#9,r0
	mov.b	@r0,r0
	mov.b	r0,@(7,r12)
	mov.l	@(0,r15),r0
	add	#10,r0
	mov.b	@r0,r0
	mov.b	r0,@(8,r12)
	mov.l	@(0,r15),r0
	add	#11,r0
	mov.b	@r0,r0
	mov.b	r0,@(9,r12)
	mov.l	@(0,r15),r0
	add	#12,r0
	mov.b	@r0,r0
	mov.b	r0,@(10,r12)
	mov.l	L2383,r0
	mov.l	@r0,r8
	mov.l	@(0,r15),r0
	add	#13,r0
	mov.b	@r0,r1
	mov	r1,r9
	mov.b	@r0,r0
	mov.b	r0,@(11,r12)
	mov.l	@r10,r0
	add	#20,r0
	mov.l	r0,@r8
	mov.l	@(8,r15),r0
	mov	#1,r1
	bra	L15
	mov.b	r1,@r0
L14:
	mov.l	L2385,r0
	mov.l	@r0,r0
	mov	r0,r1
	add	#14,r1
	mov.l	r1,@(8,r15)
	mov.b	@(8,r0),r0
	mov.b	r0,@r12
	mov.b	@(9,r11),r0
	mov.b	r0,@(1,r12)
	mov.b	@(10,r11),r0
	mov.b	r0,@(2,r12)
	mov.b	@(11,r11),r0
	mov.b	r0,@(3,r12)
	mov.b	@(12,r11),r0
	mov.b	r0,@(4,r12)
	mov.b	@(13,r11),r0
	mov.b	r0,@(5,r12)
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@(6,r12)
	mov.b	@(15,r11),r0
	mov.b	r0,@(7,r12)
	mov	r11,r0
	add	#16,r0
	mov.b	@r0,r0
	mov.b	r0,@(8,r12)
	mov	r11,r0
	add	#17,r0
	mov.b	@r0,r0
	mov.b	r0,@(9,r12)
	mov	r11,r0
	add	#18,r0
	mov.b	@r0,r0
	mov.b	r0,@(10,r12)
	mov	r11,r0
	add	#19,r0
	mov.b	@r0,r1
	mov	r1,r9
	mov.b	@r0,r0
	mov.b	r0,@(11,r12)
L15:
L12:
	mov	r9,r0
	add	#36,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2379:	.short	3072
	.align 2
L2355:	.long	DAT_060443b0
L2356:	.long	DAT_060443b4
L2357:	.long	DAT_060443b8
L2358:	.long	DAT_060443bc
L2359:	.long	DAT_060443dc
L2360:	.long	DAT_060443c4
L2361:	.long	DAT_060443c0
L2362:	.long	DAT_060443d8
L2363:	.long	DAT_060443d4
L2364:	.long	DAT_060443d0
L2365:	.long	DAT_060443c8
L2366:	.long	DAT_060443cc
L2367:	.long	DAT_060443e0
L2368:	.long	DAT_060443e8
L2369:	.long	DAT_060443e4
L2370:	.long	DAT_060443ec
L2371:	.long	DAT_060443f0
L2372:	.long	DAT_060443f4
L2373:	.long	DAT_060443f8
L2374:	.long	DAT_060443fc
L2375:	.long	DAT_06044400
L2376:	.long	DAT_06044404
L2377:	.long	DAT_06044410
L2378:	.long	DAT_0604440c
L2380:	.long	DAT_06044408
L2381:	.long	DAT_06044414
L2382:	.long	DAT_06044418
L2383:	.long	DAT_0604441c
L2384:	.long	DAT_060443c0
L2385:	.long	DAT_060443ec
	.global FUN_06044344
	.align 2
FUN_06044344:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	macl,@-r15
	add	#-60,r15
	mov.l	L2386,r0
	mov.l	@r0,r10
	mov.l	L2387,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	tst	r0,r0
	bt	L26
	mov.l	L2387,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	add	#60,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L26:
	mov	#1,r0
	mov.l	r0,@(20,r15)
	mov	r4,r11
	mov	#12,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	r0,@(52,r15)
	mov.l	@(52,r15),r0
	mov.l	L2388,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(48,r15)
	mov.l	L2389,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	mov	r0,r8
	mov.l	L2390,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L28
	mov.l	@(48,r15),r0
	mov.l	@r0,r1
	mov.l	r1,@(4,r15)
	mov.l	@(4,r0),r1
	mov.l	r1,@(0,r15)
	mov.b	@(8,r0),r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L30
	mov	#0,r0
	mov	r15,r1
	add	#27,r1
	mov.b	r0,@r1
	mov.l	L2391,r0
	mov.l	@r0,r0
	mov	r8,r1
	mov.l	@(4,r0),r2
	add	r0,r2
	mov	r2,r0
	cmp/hs	r0,r1
	bt	L32
	mov.b	@r8+,r0
	mov	r15,r1
	add	#39,r1
	mov.b	r0,@r1
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	exts.b	r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L34
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov	#127,r1
	extu.b	r0,r0
	and	r1,r0
	mov	r15,r1
	add	#27,r1
	bra	L31
	mov.b	r0,@r1
L34:
	mov	r15,r0
	add	#4,r0
	bra	L39
	mov.l	r0,@(16,r15)
L36:
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L40
	mov.b	@r8+,r13
	mov.l	@(16,r15),r1
	mov.b	r13,@r1
L40:
	mov.l	@(16,r15),r0
	add	#1,r0
	mov.l	r0,@(16,r15)
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	exts.b	r0,r0
	shar	r0
	mov	r15,r1
	add	#39,r1
	mov.b	r0,@r1
L39:
	mov	r15,r0
	add	#39,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L36
	bra	L31
	nop
L32:
	mov.l	@(0,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(0,r15)
	mov	#0,r0
	bra	L31
	mov.l	r0,@(4,r15)
L30:
	mov.l	@(48,r15),r0
	mov.b	@(8,r0),r0
	mov	#1,r1
	extu.b	r0,r0
	sub	r1,r0
	mov	r15,r1
	add	#27,r1
	mov.b	r0,@r1
L31:
	mov.l	@(48,r15),r1
	mov	r15,r0
	add	#27,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.b	r0,@(8,r1)
	bra	L42
	mov.l	r8,@(28,r15)
L28:
	mov.l	L2392,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#3,r0
	bf	L43
	mov	#20,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L2393,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(44,r15)
	mov.l	@(44,r15),r0
	mov.w	@r0,r14
	mov.l	@(8,r0),r0
	mov.l	r0,@(4,r15)
L45:
	mov.l	@(44,r15),r0
	mov.b	@(12,r0),r0
	extu.b	r0,r0
	extu.w	r0,r0
	shll8	r0
	mov.l	@(0,r15),r1
	extu.b	r1,r1
	or	r1,r0
	mov.w	r0,@(2,r15)
	extu.w	r14,r0
	mov	r0,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	extu.w	r0,r0
	or	r0,r1
	bra	L44
	mov.l	r1,@(0,r15)
L43:
	mov.l	L2392,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#4,r0
	bf	L48
	mov	#20,r1
	exts.b	r11,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L2394,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(44,r15)
	mov.l	@(44,r15),r0
	mov.w	@r0,r14
	mov.l	@(8,r0),r0
	bra	L45
	mov.l	r0,@(4,r15)
L48:
	mov.l	@(52,r15),r0
	mov.l	L2395,r1
	mov.l	@r1,r1
	add	r1,r0
	add	#8,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
	mov.l	L2396,r0
	mov.l	@r0,r0
	mov	r4,r0
	add	r0,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	extu.w	r0,r0
	shll8	r0
	mov.l	@(0,r15),r1
	extu.b	r1,r1
	or	r1,r0
	mov.w	r0,@(2,r15)
	mov.l	@(52,r15),r0
	mov.l	L2395,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	r0,r1
	shll16	r1
	mov.w	@(2,r15),r0
	extu.w	r0,r0
	extu.w	r0,r0
	or	r0,r1
	mov.l	r1,@(0,r15)
L44:
	mov.l	L2397,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	and	r1,r0
	mov.l	r0,@(4,r15)
	mov.l	r8,@(28,r15)
	mov	r8,r0
	tst	r0,r0
	bt	L52
	mov.l	@(48,r15),r0
	mov.l	@(8,r0),r1
	mov.l	r1,@(40,r15)
	mov	#0,r1
	mov.l	r1,@(32,r15)
	mov	r8,r1
	add	#1,r1
	mov.l	r1,@(28,r15)
	mov	r15,r1
	add	#4,r1
	mov.l	r1,@(12,r15)
	mov.l	r0,@(8,r15)
L54:
	mov.l	@(8,r15),r0
	mov.b	@r0,r0
	extu.b	r0,r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	extu.b	r0,r0
	cmp/eq	r0,r1
	bt	L57
	mov	r10,r0
	mov.l	@(28,r15),r1
	cmp/hi	r1,r0
	bt	L59
	bra	L61
	nop
L59:
	mov.l	@(28,r15),r1
	mov.l	@(12,r15),r0
	mov.b	@r0,r0
	mov.b	r0,@r1
	mov.l	@(32,r15),r0
	mov.l	@(20,r15),r1
	or	r1,r0
	mov.l	r0,@(32,r15)
	mov.l	@(28,r15),r0
	add	#1,r0
	mov.l	r0,@(28,r15)
L57:
	mov.l	@(20,r15),r0
	shll	r0
	mov.l	r0,@(20,r15)
	mov.l	@(12,r15),r0
	add	#1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(8,r15)
	mov.l	@(20,r15),r0
	mov	#127,r1
	and	r1,r0
	tst	r0,r0
	bf	L54
	mov.l	@(32,r15),r0
	tst	r0,r0
	bf	L62
	mov.l	@(40,r15),r0
	mov	r0,r1
	tst	r1,r1
	bt	L66
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.w	L2398,r1
	cmp/eq	r1,r0
	bf	L64
L66:
	mov	r10,r0
	mov	r8,r1
	cmp/hi	r1,r0
	bt	L67
L61:
	mov.l	L2399,r0
	mov.l	r0,@(28,r15)
	mov.l	L2406,r0
	mov.l	@r0,r0
	mov	#0,r1
	bra	L42
	mov.l	r1,@r0
L67:
	mov.w	L2400,r0
	mov.b	r0,@r8
	mov	r8,r0
	add	#1,r0
	mov.l	r0,@(28,r15)
	bra	L63
	mov.l	r8,@(40,r15)
L64:
	mov.l	@(40,r15),r0
	mov.b	@r0,r1
	add	#1,r1
	mov.b	r1,@r0
	bra	L63
	mov.l	r8,@(28,r15)
L62:
	mov.l	@(32,r15),r0
	mov.b	r0,@r8
	mov.l	L2399,r0
	mov.l	r0,@(40,r15)
L63:
	mov.l	L2401,r0
	mov.l	@r0,r0
	mov.l	L2402,r1
	mov.l	@r1,r1
	mov.l	@(28,r15),r2
	add	r2,r1
	mov.l	r1,@r0
	mov.l	@(48,r15),r0
	mov.l	@(40,r15),r1
	mov.l	r1,@(8,r0)
L52:
L42:
	mov.l	L2403,r0
	mov.l	@r0,r9
	mov.l	L2404,r0
	mov.l	@r0,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	mov.l	@(52,r15),r0
	add	r9,r0
	mov.l	r0,@(56,r15)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov.w	r0,@r1
	mov.l	@(48,r15),r0
	mov.w	@(4,r0),r0
	mov.l	@(56,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(56,r15),r1
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	not	r0,r0
	and	r0,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov.l	L2405,r0
	mov.l	@r0,r0
	mov.l	r0,@(52,r15)
	mov	#6,r1
	exts.b	r11,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.b	r1,r1
	add	r0,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(56,r15),r0
	mov.l	@(4,r15),r1
	mov.l	r1,@(8,r0)
	mov.l	@(48,r15),r0
	mov.l	@(4,r15),r1
	mov.l	r1,@r0
	mov.l	@(48,r15),r0
	mov.l	@(0,r15),r1
	mov.l	r1,@(4,r0)
	mov.l	@(52,r15),r0
L25:
	add	#60,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2398:	.short	255
L2400:	.short	128
L2386:	.long	DAT_0604462c
L2387:	.long	DAT_060443e0
L2388:	.long	DAT_060443b4
L2389:	.long	DAT_060443e8
L2390:	.long	DAT_060443f0
L2391:	.long	DAT_06044638
L2392:	.long	DAT_060443f4
L2393:	.long	DAT_06044424
L2394:	.long	DAT_06044620
L2395:	.long	DAT_06044624
L2396:	.long	DAT_06044628
L2397:	.long	DAT_06044420
L2399:	.long	0
L2401:	.long	DAT_06044634
L2402:	.long	DAT_06044630
L2403:	.long	DAT_06044640
L2404:	.long	DAT_0604463c
L2405:	.long	DAT_06044644
L2406:	.long	DAT_06044638
	.global FUN_06044588
	.align 2
FUN_06044588:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	add	#-16,r15
	mov.l	L2407,r0
	mov.l	@r0,r0
	mov	r0,r12
	mov	r15,r1
	add	#4,r1
	mov.l	r1,@(8,r15)
	mov.l	L2408,r1
	mov.l	@r1,r1
	mov.l	@r1,r8
	mov.l	@r0,r1
	mov.l	r1,@(4,r15)
	mov.l	@(4,r0),r1
	mov.l	r1,@(0,r15)
	mov.b	@(8,r0),r0
	tst	r0,r0
	bf	L71
	mov	#0,r0
	mov.b	r0,@(15,r15)
	mov.l	L2409,r0
	mov.l	@r0,r0
	mov.l	@r0,r0
	mov	r8,r1
	mov.l	@(4,r0),r2
	add	r0,r2
	mov	r2,r0
	cmp/hs	r0,r1
	bt	L73
	mov.b	@r8+,r9
	extu.b	r9,r0
	exts.b	r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L80
	mov	#127,r1
	extu.b	r9,r0
	and	r1,r0
	bra	L72
	mov.b	r0,@(15,r15)
L77:
	mov	#1,r1
	extu.b	r9,r0
	and	r1,r0
	tst	r0,r0
	bt	L81
	mov.b	@r8+,r14
	mov.l	@(8,r15),r1
	mov.b	r14,@r1
L81:
	mov.l	@(8,r15),r0
	add	#1,r0
	mov.l	r0,@(8,r15)
	extu.b	r9,r0
	exts.b	r0,r0
	shar	r0
	mov	r0,r9
L80:
	extu.b	r9,r0
	tst	r0,r0
	bf	L77
	bra	L72
	nop
L73:
	mov.l	@(0,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(0,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
	mov.l	L2410,r0
	mov.l	@r0,r0
	mov	#0,r1
	bra	L72
	mov.b	r1,@r0
L71:
	mov.l	L2407,r0
	mov.l	@r0,r0
	mov.b	@(8,r0),r0
	mov	#1,r1
	sub	r1,r0
	mov.b	r0,@(15,r15)
L72:
	mov.l	L2411,r0
	mov.l	@r0,r10
	mov.l	L2408,r0
	mov.l	@r0,r11
	mov.b	@(15,r15),r0
	extu.b	r0,r0
	mov.b	r0,@(8,r12)
	mov	r8,r0
	mov.l	r0,@r11
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	mov.w	r0,@r10
	mov.w	@(4,r12),r0
	mov.w	r0,@(6,r10)
	mov.w	@(0,r15),r0
	extu.w	r0,r0
	extu.w	r0,r1
	extu.w	r13,r0
	not	r0,r0
	and	r0,r1
	mov	r1,r0
	mov.w	r0,@(2,r10)
	mov.l	L2412,r0
	mov.l	@r0,r0
	add	#5,r0
	mov	r0,r1
	mov.b	@(2,r15),r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(4,r15),r0
	mov.l	r0,@(8,r10)
	mov.l	@(4,r15),r0
	mov.l	r0,@r12
	mov.l	@(0,r15),r0
	mov.l	r0,@(4,r12)
	add	#16,r15
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2407:	.long	DAT_06044648
L2408:	.long	DAT_0604464c
L2409:	.long	DAT_06044650
L2410:	.long	DAT_06044654
L2411:	.long	DAT_06044658
L2412:	.long	DAT_0604465c
	.global FUN_060446f4
	.align 2
FUN_060446f4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.l	L2413,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	@r0,r0
	mov	r0,r11
	mov.l	L2414,r0
	mov.l	@r0,r0
	mov.w	r0,@r11
	mov.l	L2415,r0
	mov.l	@r0,r0
	mov	r0,r10
	mov.l	L2417,r3
	mov.l	L2416,r0
	mov.l	@r0,r0
	mov.l	L2417,r3
	jsr	@r3
	mov.l	r10,@(20,r11)
	mov.l	L2418,r0
	mov.l	@r0,r0
	mov.l	@r0,r13
	mov.l	L2419,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	bra	L88
	mov	r0,r12
L85:
	mov.l	L2420,r3
	jsr	@r3
	mov	r13,r4
	mov.l	L2421,r0
	mov.l	@r0,r0
	mov	r13,r0
	add	r0,r0
	mov.l	@r0,r13
	add	#-1,r12
L88:
	tst	r12,r12
	bf	L85
	mov.l	L2422,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bt	L89
	mov.l	L2423,r0
	mov.l	@r0,r0
	mov	r0,r10
	mov	r8,r0
	add	#18,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L91
	mov.l	L2424,r0
	mov.l	@r0,r0
	mov	r0,r10
L91:
	mov.l	L2420,r3
	jsr	@r3
	mov	r10,r4
L89:
	mov	r11,r0
	add	#32,r0
	mov.l	r0,@r9
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2413:	.long	DAT_06044768
L2414:	.long	DAT_06044762
L2415:	.long	DAT_06044784
L2416:	.long	DAT_06044780
L2417:	.long	FUN_06044834
L2418:	.long	DAT_0604476c
L2419:	.long	DAT_06044770
L2420:	.long	FUN_06044788
L2421:	.long	DAT_06044764
L2422:	.long	DAT_06044774
L2423:	.long	DAT_06044778
L2424:	.long	DAT_0604477c
	.global FUN_06044788
	.align 2
FUN_06044788:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov.l	@(0,r15),r0
	mov.l	@r14,r1
	mov.l	@r0,r2
	sub	r2,r1
	mov	r1,r10
	add	#8,r0
	mov.l	@r0,r0
	mov.l	@(8,r14),r1
	sub	r1,r0
	mov	r0,r9
	mov	r10,r12
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L94
	not	r10,r0
	mov	r0,r12
	add	#1,r12
L94:
	mov	r12,r0
	mov.l	L2425,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L96
	mov	r9,r12
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L98
	not	r9,r0
	mov	r0,r12
	add	#1,r12
L98:
	mov	r12,r0
	mov.l	L2425,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L100
	mov.l	L2426,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r0
	mov.l	L2427,r3
	jsr	@r3
	neg	r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r12
	sub	r0,r12
	mov.l	L2428,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L102
	not	r12,r0
	mov	r0,r12
	add	#1,r12
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L102:
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	mov	#7,r1
	and	r1,r0
	mov.l	L2429,r1
	add	r1,r0
	mov.b	@r0,r13
	mov.l	L2430,r0
	mov.l	@r0,r1
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	shlr2	r0
	mov	#3,r2
	and	r2,r0
	mov.l	L2431,r2
	add	r2,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	or	r0,r1
	mov	r1,r0
	mov.w	r0,@r8
	mov.l	L2432,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r8)
	mov.l	L2433,r0
	mov.l	@r0,r1
	mov	r13,r0
	shll16	r0
	add	r0,r1
	mov.l	r1,@(8,r8)
	mov.l	L2434,r0
	mov.l	@r0,r0
	mov	r10,r1
	shlr16	r1
	exts.w	r1,r1
	add	r1,r0
	mov.w	r0,@(12,r8)
	mov.l	L2435,r0
	mov.l	@r0,r0
	mov	r9,r1
	shlr16	r1
	mov	r0,r0
	add	r1,r0
	mov.w	r0,@(14,r8)
L100:
L96:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2425:	.long	DAT_06044814
L2426:	.long	FUN_06044834
L2427:	.long	PTR_FUN_06044818
L2428:	.long	DAT_0604481c
L2429:	.long	DAT_06044828
L2430:	.long	DAT_0604480c
L2431:	.long	DAT_06044830
L2432:	.long	DAT_06044820
L2433:	.long	DAT_06044824
L2434:	.long	DAT_0604480e
L2435:	.long	DAT_06044810
	.global FUN_06044834
	.align 2
FUN_06044834:
	mov.w	@(14,r4),r0
	mov	r0,r1
	mov	#26,r0
	mov.w	@(r0,r4),r0
	add	r0,r1
	mov	#30,r0
	mov.w	@(r0,r4),r0
	add	r0,r1
	rts
	neg	r1,r0
	.global FUN_06044848
	.align 2
FUN_06044848:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov	r4,r8
	mov.l	L2436,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	@r0,r12
	mov.l	L2437,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L106
	mov.l	L2438,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L108
	mov.l	L2439,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L108
	mov.l	L2440,r0
	mov.l	@r0,r11
	mov.l	L2441,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	cmp/eq	#1,r0
	bf	L110
	mov.l	L2442,r0
	mov.l	@r0,r11
L110:
	mov.l	L2443,r0
	mov.l	@r0,r1
	mov.l	L2444,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	shll8	r0
	mov	r1,r4
	add	r0,r4
	mov.l	L2445,r3
	jsr	@r3
	mov	r11,r5
L108:
	mov.l	L2446,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L112
	mov.l	L2448,r5
	mov.l	L2447,r4
	mov.l	L2445,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
L112:
	mov	r8,r4
	mov.l	L2449,r0
	mov.w	@r0,r0
	mov	r8,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L2450,r5
	add	r0,r5
	mov.l	L2445,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	r12,@r9
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L106:
	mov	r8,r4
	mov.l	L2451,r0
	mov.w	@r0,r0
	mov	r8,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L2450,r5
	add	r0,r5
	mov.l	L2445,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L2452,r0
	mov.l	@r0,r10
	mov	r8,r0
	add	#18,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L114
	mov.l	L2453,r0
	mov.l	@r0,r10
L114:
	mov	r10,r4
	mov.l	L2451,r0
	mov.w	@r0,r0
	mov	r10,r0
	add	r0,r0
	mov.w	@r0,r0
	shll2	r0
	mov.l	L2450,r5
	add	r0,r5
	mov.l	L2454,r3
	jsr	@r3
	mov.l	@r5,r5
	mov.l	r12,@r9
L105:
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2450:	.short	100944200
	.align 2
L2436:	.long	puRam060448d0
L2437:	.long	pcRam060448d8
L2438:	.long	pcRam060448dc
L2439:	.long	pcRam060448e0
L2440:	.long	uRam060448ec
L2441:	.long	pcRam060448f0
L2442:	.long	uRam060448f4
L2443:	.long	iRam060448e8
L2444:	.long	pcRam060448e4
L2445:	.long	FUN_060449ac
L2446:	.long	pcRam060448f8
L2447:	.long	uRam060448fc
L2448:	.long	uRam06044900
L2449:	.long	sRam060448ce
L2451:	.long	sRam0604493e
L2452:	.long	iRam06044940
L2453:	.long	iRam06044944
L2454:	.long	FUN_060449a0
	.global FUN_060449a0
	.align 2
FUN_060449a0:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r10
	mov.l	@r14,r8
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L2455,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2456,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L2457,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r10
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r9
	mov.w	@(10,r0),r0
	dmuls.l	r0,r8
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(10,r15)
	mov.l	L2458,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L117
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L117:
	mov.l	@(0,r15),r0
	exts.w	r9,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	add	#2,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L2459,r0
	mov.w	@r0,r0
	mov	r0,r8
	mov	r8,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov	r0,r10
	mov.l	@(4,r15),r0
	mov.l	L2460,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	L2461,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(4,r15),r0
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov.l	@(4,r15),r1
	mov.l	L2462,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L2463,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L2464,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L2465,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L2466,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L2467,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L2468,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L2469,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L2467:	.short	100944529
L2469:	.short	100944531
L2455:	.long	pcRam06044a70
L2456:	.long	FUN_06044834
L2457:	.long	sRam06044a68
L2458:	.long	pcRam06044a74
L2459:	.long	sRam06044a6a
L2460:	.long	uRam06044a6c
L2461:	.long	uRam06044a78
L2462:	.long	100944524
L2463:	.long	100944525
L2464:	.long	100944526
L2465:	.long	100944527
L2466:	.long	100944528
L2468:	.long	100944530
	.global FUN_060449ac
	.align 2
FUN_060449ac:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r10
	mov.l	@r14,r8
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L2470,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2471,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L2472,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r10
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r9
	mov.w	@(10,r0),r0
	dmuls.l	r0,r8
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(10,r15)
	mov.l	L2473,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L120
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
L120:
	mov.l	@(0,r15),r0
	exts.w	r9,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r9
	mov.w	@(10,r15),r0
	mov	r0,r1
	add	#2,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(10,r15)
	mov.l	L2474,r0
	mov.w	@r0,r0
	mov	r0,r8
	mov	r8,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov	r0,r10
	mov.l	@(4,r15),r0
	mov.l	L2475,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	L2476,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(4,r15),r0
	mov	r8,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov.l	@(4,r15),r1
	mov.l	L2477,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(4,r15),r1
	mov.l	L2478,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(4,r15),r1
	mov.l	L2479,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(4,r15),r1
	mov.l	L2480,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(4,r15),r1
	mov.l	L2481,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(4,r15),r1
	mov.l	L2482,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(4,r15),r1
	mov.l	L2483,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	exts.w	r9,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(4,r15),r1
	mov.l	L2484,r0
	add	r10,r0
	mov.b	@r0,r0
	mov	r0,r2
	mov.w	@(10,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#12,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L2482:	.short	100944513
L2484:	.short	100944515
L2470:	.long	pcRam06044a70
L2471:	.long	FUN_06044834
L2472:	.long	sRam06044a68
L2473:	.long	pcRam06044a74
L2474:	.long	sRam06044a6a
L2475:	.long	uRam06044a6c
L2476:	.long	uRam06044a78
L2477:	.long	100944508
L2478:	.long	100944509
L2479:	.long	100944510
L2480:	.long	100944511
L2481:	.long	100944512
L2483:	.long	100944514
	.global FUN_060449b6
	.align 2
FUN_060449b6:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-20,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	@(8,r14),r9
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r4
	mov.l	L2485,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2486,r3
	jsr	@r3
	mov	r14,r4
	mov	r0,r4
	mov.l	@(0,r15),r0
	mov.w	@(12,r0),r0
	mov	r0,r1
	mov	r4,r2
	add	r1,r2
	mov.l	L2487,r1
	mov.w	@r1,r1
	mov	r2,r4
	sub	r1,r4
	mov.w	@(8,r0),r0
	mov	r0,r1
	dmuls.l	r1,r9
	sts	mach,r1
	mov	r1,r12
	exts.w	r12,r1
	neg	r1,r1
	mov	r1,r8
	mov.w	@(10,r0),r0
	mov.l	@(16,r15),r1
	dmuls.l	r0,r1
	sts	mach,r0
	exts.w	r0,r0
	neg	r0,r0
	mov.w	r0,@(14,r15)
	mov.l	L2488,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L123
	neg	r4,r4
	mov.l	@(0,r15),r0
	exts.w	r12,r1
	mov.w	@(4,r0),r0
	add	r0,r1
	mov	r1,r8
	mov.w	@(14,r15),r0
	mov	r0,r1
	mov.w	@(6,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
L123:
	mov.l	@(0,r15),r0
	exts.w	r8,r1
	mov.w	@r0,r2
	add	r2,r1
	mov	r1,r8
	mov.w	@(14,r15),r0
	mov	r0,r1
	mov.w	@(2,r0),r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(14,r15)
	mov.l	L2489,r0
	mov.w	@r0,r0
	mov	r0,r9
	mov.l	@(8,r15),r0
	mov.l	L2490,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	@(8,r15),r0
	mov.l	L2491,r1
	mov.l	@r1,r1
	mov.l	r1,@(4,r0)
	mov.l	@(8,r15),r0
	mov	r9,r1
	add	r4,r1
	shll2	r1
	shll2	r1
	shlr16	r1
	mov	#3,r2
	and	r2,r1
	shll16	r1
	shll2	r1
	shll2	r1
	add	r13,r1
	mov.l	r1,@(8,r0)
	mov	r9,r0
	add	r4,r0
	shll2	r0
	shlr16	r0
	mov	#3,r1
	and	r1,r0
	shll	r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r10
	mov.l	@(8,r15),r1
	mov.b	@r10,r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(12,r1)
	mov.l	@(8,r15),r1
	mov.b	@(1,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(14,r1)
	mov.l	@(8,r15),r1
	mov.b	@(2,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(16,r1)
	mov.l	@(8,r15),r1
	mov.b	@(3,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(18,r1)
	mov.l	@(8,r15),r1
	mov.b	@(4,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(20,r1)
	mov.l	@(8,r15),r1
	mov.b	@(5,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(22,r1)
	mov.l	@(8,r15),r1
	mov.b	@(6,r10),r0
	mov	r0,r2
	exts.w	r8,r0
	add	r0,r2
	mov	r2,r0
	mov.w	r0,@(24,r1)
	mov.l	@(8,r15),r1
	mov.b	@(7,r10),r0
	mov	r0,r2
	mov.w	@(14,r15),r0
	add	r0,r2
	mov	r2,r0
	add	#20,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(26,r1)
	.align 2
L2485:	.long	pcRam06044a70
L2486:	.long	FUN_06044834
L2487:	.long	sRam06044a68
L2488:	.long	pcRam06044a74
L2489:	.long	sRam06044a6a
L2490:	.long	uRam06044a6c
L2491:	.long	uRam06044a78
	.global FUN_06044a9a
	.align 2
FUN_06044a9a:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov.l	L2492,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	@r0,r0
	mov	r0,r12
	mov.l	L2493,r0
	mov.l	@r0,r0
	mov.w	r0,@r12
	mov.l	L2494,r0
	mov.l	@r0,r0
	mov	r0,r13
	mov.l	L2496,r4
	mov.l	L2497,r3
	mov.l	L2495,r0
	mov.l	@r0,r0
	mov.l	L2496,r4
	mov.l	L2497,r3
	jsr	@r3
	mov.l	L2498,r4
	mov.l	L2499,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r0
	add	#32,r0
	mov.l	L2493,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.l	L2500,r0
	mov.l	@r0,r0
	mov	r0,r13
	mov.l	L2498,r4
	mov.l	L2497,r3
	mov.l	L2501,r0
	mov.l	@r0,r0
	mov.l	L2498,r4
	mov.l	L2497,r3
	jsr	@r3
	mov.l	L2496,r4
	mov.l	L2499,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov	r12,r0
	add	#64,r0
	mov.l	r0,@r14
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2492:	.long	DAT_06044b04
L2493:	.long	DAT_06044afe
L2494:	.long	DAT_06044b14
L2495:	.long	DAT_06044b10
L2496:	.long	DAT_06044b08
L2497:	.long	FUN_06044834
L2498:	.long	DAT_06044b0c
L2499:	.long	FUN_06044b20
L2500:	.long	DAT_06044b1c
L2501:	.long	DAT_06044b18
	.global FUN_06044ada
	.align 2
FUN_06044ada:
	sts.l	pr,@-r15
	mov.l	L2502,r4
	mov.l	L2503,r3
	jsr	@r3
	mov.l	L2504,r4
	mov.l	L2505,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r14
	.align 2
L2502:	.long	DAT_06044b0c
L2503:	.long	FUN_06044834
L2504:	.long	DAT_06044b08
L2505:	.long	FUN_06044b20
	.global FUN_06044b20
	.align 2
FUN_06044b20:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	@(0,r15),r0
	mov.l	@r14,r1
	mov.l	@r0,r2
	sub	r2,r1
	mov	r1,r10
	add	#8,r0
	mov.l	@r0,r0
	mov.l	@(8,r14),r1
	sub	r1,r0
	mov	r0,r9
	mov	r10,r12
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L128
	not	r10,r0
	mov	r0,r12
	add	#1,r12
L128:
	mov	r12,r0
	mov.l	L2506,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L130
	mov	r9,r12
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L132
	not	r9,r0
	mov	r0,r12
	add	#1,r12
L132:
	mov	r12,r0
	mov.l	L2506,r1
	mov.l	@r1,r1
	cmp/gt	r1,r0
	bt	L134
	mov.l	L2507,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov.l	@(4,r15),r0
	mov.l	L2508,r3
	jsr	@r3
	neg	r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r12
	sub	r0,r12
	mov.l	L2509,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L136
	not	r12,r0
	mov	r0,r12
	add	#1,r12
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L136:
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	mov	#7,r1
	and	r1,r0
	mov.l	L2510,r1
	add	r1,r0
	mov.b	@r0,r13
	mov.l	L2511,r0
	mov.l	@r0,r1
	mov	r12,r0
	shlr8	r0
	shlr2	r0
	shlr2	r0
	shlr2	r0
	mov	#3,r2
	and	r2,r0
	mov.l	L2512,r2
	add	r2,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	or	r0,r1
	mov	r1,r0
	mov.w	r0,@r8
	mov.l	L2513,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r8)
	mov.l	L2514,r0
	mov.l	@r0,r1
	mov	r13,r0
	shll16	r0
	add	r0,r1
	mov.l	r1,@(8,r8)
	mov.l	L2515,r0
	mov.l	@r0,r0
	mov	r10,r1
	shlr16	r1
	shlr	r1
	extu.w	r1,r1
	add	r1,r0
	mov.w	r0,@(12,r8)
	mov	r9,r0
	shlr16	r0
	shlr	r0
	mov.l	@(8,r15),r1
	mov	r0,r0
	add	r1,r0
	mov.w	r0,@(14,r8)
L134:
L130:
	add	#12,r15
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L2506:	.long	DAT_06044bac
L2507:	.long	FUN_06044834
L2508:	.long	PTR_FUN_06044bb0
L2509:	.long	DAT_06044bb4
L2510:	.long	DAT_06044bc0
L2511:	.long	DAT_06044ba8
L2512:	.long	DAT_06044bc8
L2513:	.long	DAT_06044bb8
L2514:	.long	DAT_06044bbc
L2515:	.long	DAT_06044baa
	.global FUN_06044bcc
	.align 2
FUN_06044bcc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	mov.l	L2516,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
	mov.l	L2517,r0
	mov.l	@r0,r12
	mov.l	L2518,r0
	mov.l	@r0,r11
	mov.l	L2519,r0
	mov.l	@r0,r10
	mov.l	L2520,r0
	mov.l	@r0,r0
	mov	r0,r9
	mov.l	L2521,r1
	mov.l	@r1,r14
	mov.b	@r0,r0
	tst	r0,r0
	bf	L139
	mov	#0,r0
	mov.l	r0,@(4,r15)
	mov	#0,r0
	mov.l	r0,@(16,r15)
L141:
	mov.l	L2522,r0
	mov.l	@r0,r0
	mov	r0,r8
	mov.l	@(16,r15),r1
	mov	r14,r3
	extu.b	r1,r2
	mov	r2,r3
	add	r3,r3
	mov.l	r3,@(20,r15)
	mov	#3,r3
	mov.b	@r10,r4
	muls.w	r4,r3
	sts	macl,r3
	mov.b	@r11,r4
	exts.w	r4,r4
	add	r4,r3
	mul.l	r0,r3
	sts	macl,r0
	exts.w	r0,r0
	add	r12,r0
	add	r2,r0
	mov	r0,r13
	mov	r1,r0
	add	#12,r0
	extu.b	r0,r0
	mov.l	r0,@(8,r15)
	mov.l	@(20,r15),r0
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov.l	@(8,r15),r0
	mov	r14,r1
	mov	r0,r1
	add	r1,r1
	mov.l	r1,@(20,r15)
	mov.l	@(4,r15),r1
	add	#2,r1
	mov.l	r1,@(4,r15)
	mov	#3,r1
	mov.b	@r10,r2
	muls.w	r2,r1
	sts	macl,r1
	mov.b	@r11,r2
	exts.w	r2,r2
	add	r2,r1
	exts.w	r8,r2
	muls.w	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	add	r12,r1
	add	r0,r1
	mov	r1,r13
	mov.l	@(20,r15),r0
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov.l	@(16,r15),r0
	add	#24,r0
	mov.l	r0,@(16,r15)
	mov.l	@(4,r15),r0
	mov	#20,r1
	cmp/ge	r1,r0
	bf	L141
	bra	L140
	nop
L139:
	mov.l	L2521,r0
	mov.l	@r0,r0
	mov	r0,r13
	add	#60,r13
	mov	#0,r0
	bra	L147
	mov.b	r0,@(3,r15)
L144:
	mov	#60,r1
	mov.b	@r10,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.w	r0,r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.b	@(3,r15),r0
	mov	r2,r0
	add	r0,r0
	mov.l	r0,@(20,r15)
	mov.l	@(20,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@r14
	mov	r14,r0
	add	#4,r0
	mov.l	@(20,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#8,r0
	mov.l	@(20,r15),r1
	add	#8,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#12,r0
	mov.b	r0,@(3,r15)
	add	#12,r14
L147:
	mov	r14,r0
	mov	r13,r1
	cmp/hs	r1,r0
	bf	L144
L140:
	mov.l	L2523,r0
	mov.l	@r0,r12
	mov.l	L2524,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov	#0,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	mov	r1,r0
	mov.b	r0,@(3,r15)
	mov	#24,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	extu.b	r1,r1
	mov.l	L2525,r2
	mov.l	@r2,r2
	add	r2,r1
	mov	r1,r13
	mov.l	@r13,r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#8,r0
	mov.l	@(8,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#12,r0
	mov.l	@(12,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#16,r0
	mov.l	@(16,r13),r1
	mov.l	r1,@r0
	mov	r14,r0
	add	#20,r0
	mov.l	@(20,r13),r1
	mov.l	r1,@r0
	mov.l	L2526,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r15)
L148:
	mov.b	@(3,r15),r0
	mov	r0,r13
	add	r12,r13
	mov	#48,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	exts.w	r3,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.l	@r14,r0
	mov.l	r0,@r13
	mov	r13,r0
	add	#4,r0
	mov.l	@(4,r14),r1
	mov.l	r1,@r0
	mov	r13,r0
	add	#8,r0
	mov.l	@(8,r14),r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#12,r0
	exts.b	r0,r0
	mov	r0,r13
	add	r12,r13
	mov.l	@(12,r15),r1
	add	#2,r1
	mov.l	r1,@(12,r15)
	mov	#48,r1
	mov	#5,r2
	mov.b	@r9,r3
	muls.w	r3,r2
	sts	macl,r2
	mov.b	@r10,r3
	exts.w	r3,r3
	add	r3,r2
	mul.l	r2,r1
	sts	macl,r1
	exts.w	r1,r1
	mov.l	@(4,r15),r2
	add	r2,r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.l	@r14,r0
	mov.l	r0,@r13
	mov	r13,r0
	add	#4,r0
	mov.l	@(4,r14),r1
	mov.l	r1,@r0
	mov	r13,r0
	add	#8,r0
	mov.l	@(8,r14),r1
	mov.l	r1,@r0
	mov.b	@(3,r15),r0
	add	#24,r0
	mov.b	r0,@(3,r15)
	mov.l	@(12,r15),r0
	mov	#4,r1
	cmp/ge	r1,r0
	bf	L148
	add	#24,r15
	lds.l	@r15+,macl
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2516:	.long	DAT_06044d50
L2517:	.long	DAT_06044c64
L2518:	.long	DAT_06044c60
L2519:	.long	DAT_06044c5c
L2520:	.long	DAT_06044c58
L2521:	.long	DAT_06044c54
L2522:	.long	DAT_06044c52
L2523:	.long	DAT_06044d5c
L2524:	.long	DAT_06044d58
L2525:	.long	DAT_06044d54
L2526:	.long	DAT_06044d60
	.global FUN_06044d64
	.align 2
FUN_06044d64:
	sts.l	pr,@-r15
	mov.l	L2527,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L2527:	.long	FUN_06044d74
	.global FUN_06044d74
	.align 2
FUN_06044d74:
	mov.l	L2528,r0
	mov.l	@r0,r7
	mov.l	L2529,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L153
	mov.l	L2530,r0
	mov.l	@r0,r7
L153:
	mov.l	L2531,r0
	mov.l	r0,@r7
	mov	#0,r0
	mov.l	r0,@(4,r14)
	mov	#0,r0
	mov.l	r0,@(8,r14)
	mov	#0,r0
	mov.l	r0,@(12,r14)
	mov	#0,r0
	mov.l	r0,@(16,r14)
	mov.l	L2531,r0
	mov.l	r0,@(20,r14)
	mov	#0,r0
	mov.l	r0,@(24,r14)
	mov	#0,r0
	mov.l	r0,@(28,r14)
	mov	#0,r0
	mov.l	r0,@(32,r14)
	mov	#0,r0
	mov.l	r0,@(36,r14)
	mov.l	L2531,r0
	mov.l	r0,@(40,r14)
	mov	#0,r0
	rts
	mov.l	r0,@(44,r14)
	.align 2
L2528:	.long	DAT_06044da0
L2529:	.long	_DAT_ffffffe2
L2530:	.long	DAT_06044da4
L2531:	.long	65536
	.global FUN_06044d80
	.align 2
FUN_06044d80:
	mov.l	L2532,r0
	mov.l	r0,@r4
	mov	#0,r0
	mov.l	r0,@(4,r4)
	mov	#0,r0
	mov.l	r0,@(8,r4)
	mov	#0,r0
	mov.l	r0,@(12,r4)
	mov	#0,r0
	mov.l	r0,@(16,r4)
	mov.l	L2532,r0
	mov.l	r0,@(20,r4)
	mov	#0,r0
	mov.l	r0,@(24,r4)
	mov	#0,r0
	mov.l	r0,@(28,r4)
	mov	#0,r0
	mov.l	r0,@(32,r4)
	mov	#0,r0
	mov.l	r0,@(36,r4)
	mov.l	L2532,r0
	mov.l	r0,@(40,r4)
	mov	#0,r0
	rts
	mov.l	r0,@(44,r4)
	.align 2
L2532:	.long	65536
	.global FUN_06044da8
	.align 2
FUN_06044da8:
	sts.l	pr,@-r15
	mov.l	L2533,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	@(4,r15),r0
	.align 2
L2533:	.long	FUN_06044db8
	.global FUN_06044db8
	.align 2
FUN_06044db8:
	mov.l	@r4,r0
	mov.l	r0,@(48,r4)
	mov.l	@(4,r4),r0
	mov.l	r0,@(52,r4)
	mov.l	@(8,r4),r0
	mov.l	r0,@(56,r4)
	mov.l	@(12,r4),r0
	mov.l	r0,@(60,r4)
	mov	r4,r0
	add	#64,r0
	mov.l	@(16,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#68,r0
	mov.l	@(20,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#72,r0
	mov.l	@(24,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov.l	@(28,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#80,r0
	mov.l	@(32,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#84,r0
	mov.l	@(36,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov.l	@(40,r4),r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#92,r0
	mov.l	@(44,r4),r1
	rts
	mov.l	r1,@r0
	.global FUN_06044e28
	.align 2
FUN_06044e28:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	r13,@(0,r15)
	mov	r12,r9
	mov	r11,r8
	mov	r15,r5
	mov.l	L2534,r3
	jsr	@r3
	add	#4,r15
	lds.l	@r15+,pr
	rts
	add	#0,r5
	.align 2
L2534:	.long	FUN_06044e3c
	.global FUN_06044e3c
	.align 2
FUN_06044e3c:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-20,r15
	mov	#3,r8
L160:
	mov.l	@r5,r10
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r10,r9
	xor	r0,r9
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L163
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L163:
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L165
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L165:
	mov.l	@(12,r15),r0
	extu.w	r0,r1
	extu.w	r10,r2
	mul.l	r2,r1
	sts	macl,r6
	shlr16	r0
	mul.l	r2,r0
	sts	macl,r0
	mov	r0,r11
	mov	#0,r0
	mov	r0,r7
	mov	r11,r0
	mov	r10,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r14
	tst	r11,r11
	bt/s	L167
	add	r1,r14
	mov.l	L2535,r7
L167:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L171
	mov	#1,r14
L170:
	mov	#0,r14
L171:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov.l	@(12,r15),r1
	shlr16	r1
	mov	r10,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L176
	mov	r15,r14
	bra	Lm76
	mov	#0,r0
L176:
	mov	#1,r0
Lm76:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L172
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L177
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L178
	mov.l	r0,@(12,r15)
L177:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L178:
L172:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L179
	mov.l	@(12,r15),r0
	mov.w	L2536,r1
	cmp/ge	r1,r0
	bt	L181
	mov.w	L2536,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L181:
	mov.w	L2537,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L183
	mov.w	L2537,r0
	mov.l	r0,@(12,r15)
	mov.w	L2538,r0
	mov.l	r0,@(8,r15)
L183:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L179:
	mov.l	@(4,r5),r9
	mov.l	@(4,r4),r10
	mov	r9,r14
	xor	r10,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L185
	not	r9,r0
	mov	r0,r9
	add	#1,r9
L185:
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L187
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L187:
	extu.w	r10,r0
	extu.w	r9,r1
	mul.l	r1,r0
	sts	macl,r2
	mov.l	r2,@(0,r15)
	mov	r10,r2
	shlr16	r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r11
	mov	#0,r1
	mov	r1,r7
	mov	r11,r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r0
	sts	macl,r0
	mov	r1,r6
	tst	r11,r11
	bt/s	L189
	add	r0,r6
	mov.l	L2535,r7
L189:
	mov.l	@(0,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L193
	mov	#1,r14
L192:
	mov	#0,r14
L193:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r10
	add	r1,r10
	mov	r14,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L198
	mov	r15,r14
	bra	Lm207
	mov	#0,r0
	.align 2
L2536:	.short	-32768
L2537:	.short	32767
L2538:	.short	-1
L198:
	mov	#1,r0
Lm207:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L194
	not	r10,r10
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L199
	bra	L200
	add	#1,r10
L199:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L200:
L194:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L201
	mov.l	@(8,r15),r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L205
	mov	r15,r14
	bra	Lm246
	mov	#0,r0
L205:
	mov	#1,r0
Lm246:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	add	r0,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2541,r1
	cmp/ge	r1,r0
	bt	L206
	mov.w	L2541,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L206:
	mov.w	L2542,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L208
	mov.w	L2542,r0
	mov.l	r0,@(12,r15)
	mov.w	L2543,r0
	mov.l	r0,@(4,r15)
L208:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L202
	mov.l	r0,@(12,r15)
L201:
	mov.l	@(8,r15),r0
	mov.l	@(4,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L212
	mov	r15,r14
	bra	Lm289
	mov	#0,r0
L212:
	mov	#1,r0
Lm289:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	add	r0,r1
	mov.l	r1,@(12,r15)
L202:
	mov.l	@(8,r5),r9
	mov.l	@(8,r4),r10
	mov	r9,r14
	xor	r10,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L213
	not	r9,r0
	mov	r0,r9
	add	#1,r9
L213:
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L215
	not	r10,r0
	mov	r0,r10
	add	#1,r10
L215:
	extu.w	r10,r0
	extu.w	r9,r1
	mul.l	r1,r0
	sts	macl,r2
	mov.l	r2,@(8,r15)
	mov	r10,r2
	shlr16	r2
	mul.l	r1,r2
	sts	macl,r1
	mov	r1,r11
	mov	#0,r1
	mov	r1,r7
	mov	r11,r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r0
	sts	macl,r0
	mov	r1,r6
	tst	r11,r11
	bt/s	L217
	add	r0,r6
	mov.l	L2540,r7
L217:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L221
	mov	#1,r14
L220:
	mov	#0,r14
L221:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov	r9,r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	mov	r0,r10
	add	r1,r10
	mov	r14,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L226
	mov	r15,r14
	bra	Lm375
	mov	#0,r0
L226:
	mov	#1,r0
Lm375:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L222
	not	r10,r10
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L227
	bra	L228
	add	#1,r10
L227:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L228:
L222:
	mov	#1,r0
	mov.l	@(16,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L229
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L233
	mov	r15,r14
	bra	Lm414
	mov	#0,r0
L233:
	mov	#1,r0
Lm414:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	add	r0,r1
	mov.l	r1,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2544,r1
	cmp/ge	r1,r0
	bt	L234
	mov.w	L2544,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L234:
	mov.w	L2545,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L236
	mov.w	L2545,r0
	mov.l	r0,@(12,r15)
	mov.w	L2546,r0
	mov.l	r0,@(0,r15)
L236:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L230
	mov.l	r0,@(12,r15)
L229:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L240
	mov	r15,r14
	bra	Lm457
	mov	#0,r0
L240:
	mov	#1,r0
Lm457:
	mov	r14,r15
	mov	r10,r1
	add	r0,r1
	mov.l	@(12,r15),r0
	add	r0,r1
	mov.l	r1,@(12,r15)
L230:
	mov	r4,r0
	add	#12,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	@r0,r2
	add	r2,r1
	mov.l	r1,@r0
	add	#-1,r8
	mov.l	@(16,r15),r0
	mov.w	L2539,r1
	and	r1,r0
	mov.l	r0,@(16,r15)
	add	#16,r4
	tst	r8,r8
	bf	L160
	add	#20,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2539:	.short	-2
L2541:	.short	-32768
L2542:	.short	32767
L2543:	.short	-1
L2544:	.short	-32768
L2545:	.short	32767
L2546:	.short	-1
	.align 2
L2535:	.long	65536
L2540:	.long	65536
	.global FUN_06045006
	.align 2
FUN_06045006:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L2547,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L242
	mov.l	L2547,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2547:	.long	DAT_06045070
L242:
	mov.l	L2548,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L244:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L247
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L247:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L249
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L249:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L251
	add	r0,r14
	mov.l	L2549,r7
L251:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L255
	mov	#1,r14
L254:
	mov	#0,r14
L255:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L260
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L2548:	.short	-2
L260:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L256
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L261
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L262
	mov.l	r0,@(16,r15)
L261:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L262:
L256:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L263
	mov.l	@(16,r15),r0
	mov.w	L2550,r1
	cmp/ge	r1,r0
	bt	L265
	mov.w	L2550,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L265:
	mov.w	L2551,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L267
	mov.w	L2551,r0
	mov.l	r0,@(16,r15)
	mov.w	L2552,r0
	mov.l	r0,@(8,r15)
L267:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L263:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L269
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L269:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L271
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L271:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L273
	add	r0,r6
	mov.l	L2549,r7
L273:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L277
	mov	#1,r14
L276:
	mov	#0,r14
L277:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L282
	mov	r15,r14
	bra	Lm251
	mov	#0,r0
	.align 2
L2550:	.short	-32768
L2551:	.short	32767
L2552:	.short	-1
	.align 2
L2549:	.long	65536
L282:
	mov	#1,r0
Lm251:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L278
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L283
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L284
	mov.l	r0,@(12,r15)
L283:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L284:
L278:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L285
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L289
	mov	#1,r14
L288:
	mov	#0,r14
L289:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2556,r1
	cmp/ge	r1,r0
	bt	L290
	mov.w	L2556,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L290:
	mov.w	L2557,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L292
	mov.w	L2557,r0
	mov.l	r0,@(16,r15)
	mov.w	L2558,r0
	mov.l	r0,@(0,r15)
L292:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L286
	mov.l	r0,@(16,r15)
	.align 2
L2556:	.short	-32768
L2557:	.short	32767
L2558:	.short	-1
L285:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L296
	mov	#1,r14
L295:
	mov	#0,r14
L296:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L286:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L297
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L297:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L299
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L299:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L301
	add	r0,r6
	mov.l	L2555,r7
L301:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L305
	mov	#1,r14
L304:
	mov	#0,r14
L305:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L310
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
L310:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L306
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L311
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L312
	mov.l	r0,@(12,r15)
L311:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L312:
L306:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L313
	mov.l	@(12,r15),r0
	mov.w	L2559,r1
	cmp/ge	r1,r0
	bt	L315
	mov.w	L2559,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L315:
	mov.w	L2560,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L317
	mov.w	L2560,r0
	mov.l	r0,@(12,r15)
	mov.w	L2561,r0
	mov.l	r0,@(4,r15)
L317:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L313:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L319
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L319:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L321
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L321:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L323
	add	r0,r6
	mov.l	L2555,r7
L323:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L327
	mov	#1,r14
L326:
	mov	#0,r14
L327:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L332
	mov	r15,r14
	bra	Lm570
	mov	#0,r0
L332:
	mov	#1,r0
Lm570:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L328
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L333
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L334
	mov.l	r0,@(16,r15)
L333:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L334:
L328:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L335
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L339
	mov	#1,r14
L338:
	mov	#0,r14
L339:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2562,r1
	cmp/ge	r1,r0
	bt	L340
	mov.w	L2562,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L340:
	mov.w	L2563,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L342
	mov.w	L2563,r0
	mov.l	r0,@(16,r15)
	mov.w	L2564,r0
	mov.l	r0,@(0,r15)
L342:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2553,r2
	and	r2,r1
	or	r1,r0
	bra	L336
	mov.l	r0,@(12,r15)
L335:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L346
	mov	#1,r14
L345:
	mov	#0,r14
L346:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L336:
	add	#-1,r8
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2554,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L244
	mov.l	@(12,r15),r0
L241:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2553:	.short	-65536
L2559:	.short	-32768
L2560:	.short	32767
L2561:	.short	-1
L2562:	.short	-32768
L2563:	.short	32767
L2564:	.short	-1
	.align 2
L2554:	.long	PTR_DAT_06045074
L2555:	.long	65536
	.global FUN_06045008
	.align 2
FUN_06045008:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L2565,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L348
	mov.l	L2565,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2565:	.short	-65536
L348:
	mov.l	L2566,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L350:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L353
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L353:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L355
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L355:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L357
	add	r0,r14
	mov.l	L2567,r7
L357:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L361
	mov	#1,r14
L360:
	mov	#0,r14
L361:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L366
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L2566:	.short	-2
L366:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L362
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L367
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L368
	mov.l	r0,@(16,r15)
L367:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L368:
L362:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L369
	mov.l	@(16,r15),r0
	mov.w	L2568,r1
	cmp/ge	r1,r0
	bt	L371
	mov.w	L2568,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L371:
	mov.w	L2569,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L373
	mov.w	L2569,r0
	mov.l	r0,@(16,r15)
	mov.w	L2570,r0
	mov.l	r0,@(8,r15)
L373:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L369:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L375
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L375:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L377
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L377:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L379
	add	r0,r6
	mov.l	L2567,r7
L379:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L383
	mov	#1,r14
L382:
	mov	#0,r14
L383:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L388
	mov	r15,r14
	bra	Lm249
	mov	#0,r0
	.align 2
L2568:	.short	-32768
L2569:	.short	32767
L2570:	.short	-1
	.align 2
L2567:	.long	65536
L388:
	mov	#1,r0
Lm249:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L384
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L389
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L390
	mov.l	r0,@(12,r15)
L389:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L390:
L384:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L391
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L395
	mov	#1,r14
L394:
	mov	#0,r14
L395:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2574,r1
	cmp/ge	r1,r0
	bt	L396
	mov.w	L2574,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L396:
	mov.w	L2575,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L398
	mov.w	L2575,r0
	mov.l	r0,@(16,r15)
	mov.w	L2576,r0
	mov.l	r0,@(0,r15)
L398:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L392
	mov.l	r0,@(16,r15)
	.align 2
L2574:	.short	-32768
L2575:	.short	32767
L2576:	.short	-1
L391:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L402
	mov	#1,r14
L401:
	mov	#0,r14
L402:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L392:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L403
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L403:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L405
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L405:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L407
	add	r0,r6
	mov.l	L2573,r7
L407:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L411
	mov	#1,r14
L410:
	mov	#0,r14
L411:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L416
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
L416:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L412
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L417
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L418
	mov.l	r0,@(12,r15)
L417:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L418:
L412:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L419
	mov.l	@(12,r15),r0
	mov.w	L2577,r1
	cmp/ge	r1,r0
	bt	L421
	mov.w	L2577,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L421:
	mov.w	L2578,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L423
	mov.w	L2578,r0
	mov.l	r0,@(12,r15)
	mov.w	L2579,r0
	mov.l	r0,@(4,r15)
L423:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L419:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L425
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L425:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L427
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L427:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L429
	add	r0,r6
	mov.l	L2573,r7
L429:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L433
	mov	#1,r14
L432:
	mov	#0,r14
L433:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L438
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L438:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L434
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L439
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L440
	mov.l	r0,@(16,r15)
L439:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L440:
L434:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L441
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L445
	mov	#1,r14
L444:
	mov	#0,r14
L445:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2580,r1
	cmp/ge	r1,r0
	bt	L446
	mov.w	L2580,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L446:
	mov.w	L2581,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L448
	mov.w	L2581,r0
	mov.l	r0,@(16,r15)
	mov.w	L2582,r0
	mov.l	r0,@(0,r15)
L448:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2571,r2
	and	r2,r1
	or	r1,r0
	bra	L442
	mov.l	r0,@(12,r15)
L441:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L452
	mov	#1,r14
L451:
	mov	#0,r14
L452:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L442:
	add	#-1,r9
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2572,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L350
	mov.l	@(12,r15),r0
L347:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2571:	.short	-65536
L2577:	.short	-32768
L2578:	.short	32767
L2579:	.short	-1
L2580:	.short	-32768
L2581:	.short	32767
L2582:	.short	-1
	.align 2
L2572:	.long	PTR_DAT_06045074
L2573:	.long	65536
	.global FUN_06045020
	.align 2
FUN_06045020:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L454:
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L457
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L457:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L459
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L459:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L461
	add	r0,r14
	mov.l	L2583,r7
L461:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L465
	mov	#1,r14
L464:
	mov	#0,r14
L465:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L470
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L2583:	.short	65536
L470:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L466
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L471
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L472
	mov.l	r0,@(16,r15)
L471:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L472:
L466:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L473
	mov.l	@(16,r15),r0
	mov.w	L2584,r1
	cmp/ge	r1,r0
	bt	L475
	mov.w	L2584,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L475:
	mov.w	L2585,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L477
	mov.w	L2585,r0
	mov.l	r0,@(16,r15)
	mov.w	L2586,r0
	mov.l	r0,@(8,r15)
L477:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L473:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L479
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L479:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L481
	mov	r5,r14
L481:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L483
	add	r0,r12
	mov.l	L2588,r7
L483:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L487
	mov	#1,r14
L486:
	mov	#0,r14
L487:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L492
	mov	r15,r14
	bra	Lm210
	mov	#0,r0
	.align 2
L2584:	.short	-32768
L2585:	.short	32767
L2586:	.short	-1
L2588:	.short	65536
L492:
	mov	#1,r0
Lm210:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L488
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L493
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L494
	mov.l	r0,@(12,r15)
L493:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L494:
L488:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L495
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L499
	mov	#1,r14
L498:
	mov	#0,r14
L499:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2589,r1
	cmp/ge	r1,r0
	bt	L500
	mov.w	L2589,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L500:
	mov.w	L2590,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L502
	mov.w	L2590,r0
	mov.l	r0,@(16,r15)
	mov.w	L2591,r0
	mov.l	r0,@(0,r15)
L502:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L496
	mov.l	r0,@(16,r15)
	.align 2
L2589:	.short	-32768
L2590:	.short	32767
L2591:	.short	-1
L495:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L506
	mov	#1,r14
L505:
	mov	#0,r14
L506:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L496:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L507
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L507:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L509
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L509:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L511
	add	r0,r12
	mov.l	L2592,r7
L511:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L515
	mov	#1,r14
L514:
	mov	#0,r14
L515:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L520
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L2592:	.short	65536
L520:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L516
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L521
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L522
	mov.l	r0,@(12,r15)
L521:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L522:
L516:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L523
	mov.l	@(12,r15),r0
	mov.w	L2593,r1
	cmp/ge	r1,r0
	bt	L525
	mov.w	L2593,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L525:
	mov.w	L2594,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L527
	mov.w	L2594,r0
	mov.l	r0,@(12,r15)
	mov.w	L2595,r0
	mov.l	r0,@(4,r15)
L527:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L523:
	mov	r4,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L529
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L529:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L531
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L531:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L533
	add	r0,r12
	mov.l	L2596,r7
L533:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L537
	mov	#1,r14
L536:
	mov	#0,r14
L537:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L542
	mov	r15,r14
	bra	Lm523
	mov	#0,r0
L542:
	mov	#1,r0
Lm523:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L538
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L543
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L544
	mov.l	r0,@(16,r15)
L543:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L544:
L538:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L545
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L549
	mov	#1,r14
L548:
	mov	#0,r14
L549:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2597,r1
	cmp/ge	r1,r0
	bt	L550
	mov.w	L2597,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L550:
	mov.w	L2598,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L552
	mov.w	L2598,r0
	mov.l	r0,@(12,r15)
	mov.w	L2599,r0
	mov.l	r0,@(0,r15)
L552:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L546
	mov.l	r0,@(12,r15)
L545:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L556
	mov	#1,r14
L555:
	mov	#0,r14
L556:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L546:
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L2587,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	mov	r4,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r4
	tst	r8,r8
	bf	L454
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2587:	.short	-2
L2593:	.short	-32768
L2594:	.short	32767
L2595:	.short	-1
L2596:	.short	65536
L2597:	.short	-32768
L2598:	.short	32767
L2599:	.short	-1
	.global FUN_0604507e
	.align 2
FUN_0604507e:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L2600,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L558
	mov.l	L2600,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2600:	.short	-2
L558:
	mov.l	L2601,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L560:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L563
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L563:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L565
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L565:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L567
	add	r0,r14
	mov.l	L2602,r7
L567:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L571
	mov	#1,r14
L570:
	mov	#0,r14
L571:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L576
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L2601:	.short	-32768
L2602:	.short	65536
L576:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L572
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L577
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L578
	mov.l	r0,@(16,r15)
L577:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L578:
L572:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L579
	mov.l	@(16,r15),r0
	mov.w	L2607,r1
	cmp/ge	r1,r0
	bt	L581
	mov.w	L2607,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L581:
	mov.w	L2603,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L583
	mov.w	L2603,r0
	mov.l	r0,@(16,r15)
	mov.w	L2604,r0
	mov.l	r0,@(8,r15)
L583:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L579:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L585
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L585:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L587
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L587:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L589
	add	r0,r6
	mov.l	L2608,r7
L589:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L593
	mov	#1,r14
L592:
	mov	#0,r14
L593:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L598
	mov	r15,r14
	bra	Lm253
	mov	#0,r0
	.align 2
L2603:	.short	32767
L2604:	.short	-1
L2607:	.short	-32768
L2608:	.short	65536
L598:
	mov	#1,r0
Lm253:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L594
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L599
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L600
	mov.l	r0,@(12,r15)
L599:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L600:
L594:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L601
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L605
	mov	#1,r14
L604:
	mov	#0,r14
L605:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2611,r1
	cmp/ge	r1,r0
	bt	L606
	mov.w	L2611,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L606:
	mov.w	L2609,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L608
	mov.w	L2609,r0
	mov.l	r0,@(16,r15)
	mov.w	L2610,r0
	mov.l	r0,@(0,r15)
L608:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L602
	mov.l	r0,@(16,r15)
	.align 2
L2609:	.short	32767
L2610:	.short	-1
L2611:	.short	-32768
L601:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L612
	mov	#1,r14
L611:
	mov	#0,r14
L612:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L602:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L613
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L613:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L615
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L615:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L617
	add	r0,r6
	mov.l	L2612,r7
L617:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L621
	mov	#1,r14
L620:
	mov	#0,r14
L621:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L626
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
	.align 2
L2612:	.short	65536
L626:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L622
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L627
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L628
	mov.l	r0,@(12,r15)
L627:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L628:
L622:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L629
	mov.l	@(12,r15),r0
	mov.w	L2615,r1
	cmp/ge	r1,r0
	bt	L631
	mov.w	L2615,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L631:
	mov.w	L2613,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L633
	mov.w	L2613,r0
	mov.l	r0,@(12,r15)
	mov.w	L2614,r0
	mov.l	r0,@(4,r15)
L633:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L629:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L635
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L635:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L637
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L637:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L639
	add	r0,r6
	mov.l	L2616,r7
L639:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L643
	mov	#1,r14
L642:
	mov	#0,r14
L643:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L648
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L648:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L644
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L649
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L650
	mov.l	r0,@(16,r15)
L649:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L650:
L644:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L651
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L655
	mov	#1,r14
L654:
	mov	#0,r14
L655:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2619,r1
	cmp/ge	r1,r0
	bt	L656
	mov.w	L2619,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L656:
	mov.w	L2617,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L658
	mov.w	L2617,r0
	mov.l	r0,@(16,r15)
	mov.w	L2618,r0
	mov.l	r0,@(0,r15)
L658:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2605,r2
	and	r2,r1
	or	r1,r0
	bra	L652
	mov.l	r0,@(12,r15)
L651:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L662
	mov	#1,r14
L661:
	mov	#0,r14
L662:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L652:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2606,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L560
	mov.l	@(12,r15),r0
L557:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2605:	.short	-65536
L2613:	.short	32767
L2614:	.short	-1
L2616:	.short	65536
L2617:	.short	32767
L2618:	.short	-1
L2606:	.long	DAT_060450e4
L2615:	.long	PTR_DAT_060450e8
L2619:	.long	PTR_DAT_060450e8
	.global FUN_06045080
	.align 2
FUN_06045080:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L2620,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L664
	mov.l	L2620,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2620:	.short	-65536
L664:
	mov.l	L2621,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L666:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L669
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L669:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L671
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L671:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L673
	add	r0,r14
	mov.l	L2622,r7
L673:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L677
	mov	#1,r14
L676:
	mov	#0,r14
L677:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L682
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L2621:	.short	-2
L2622:	.short	65536
L682:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L678
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L683
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L684
	mov.l	r0,@(16,r15)
L683:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L684:
L678:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L685
	mov.l	@(16,r15),r0
	mov.w	L2623,r1
	cmp/ge	r1,r0
	bt	L687
	mov.w	L2623,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L687:
	mov.w	L2624,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L689
	mov.w	L2624,r0
	mov.l	r0,@(16,r15)
	mov.w	L2625,r0
	mov.l	r0,@(8,r15)
L689:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L685:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L691
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L691:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L693
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L693:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L695
	add	r0,r6
	mov.l	L2628,r7
L695:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L699
	mov	#1,r14
L698:
	mov	#0,r14
L699:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L704
	mov	r15,r14
	bra	Lm252
	mov	#0,r0
	.align 2
L2623:	.short	-32768
L2624:	.short	32767
L2625:	.short	-1
L2628:	.short	65536
L704:
	mov	#1,r0
Lm252:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L700
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L705
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L706
	mov.l	r0,@(12,r15)
L705:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L706:
L700:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L707
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L711
	mov	#1,r14
L710:
	mov	#0,r14
L711:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2629,r1
	cmp/ge	r1,r0
	bt	L712
	mov.w	L2629,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L712:
	mov.w	L2630,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L714
	mov.w	L2630,r0
	mov.l	r0,@(16,r15)
	mov.w	L2631,r0
	mov.l	r0,@(0,r15)
L714:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L708
	mov.l	r0,@(16,r15)
	.align 2
L2629:	.short	-32768
L2630:	.short	32767
L2631:	.short	-1
L707:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L718
	mov	#1,r14
L717:
	mov	#0,r14
L718:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L708:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L719
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L719:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L721
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L721:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L723
	add	r0,r6
	mov.l	L2632,r7
L723:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L727
	mov	#1,r14
L726:
	mov	#0,r14
L727:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L732
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
	.align 2
L2632:	.short	65536
L732:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L728
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L733
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L734
	mov.l	r0,@(12,r15)
L733:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L734:
L728:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L735
	mov.l	@(12,r15),r0
	mov.w	L2633,r1
	cmp/ge	r1,r0
	bt	L737
	mov.w	L2633,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L737:
	mov.w	L2634,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L739
	mov.w	L2634,r0
	mov.l	r0,@(12,r15)
	mov.w	L2635,r0
	mov.l	r0,@(4,r15)
L739:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L735:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L741
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L741:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L743
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L743:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L745
	add	r0,r6
	mov.l	L2636,r7
L745:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L749
	mov	#1,r14
L748:
	mov	#0,r14
L749:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L754
	mov	r15,r14
	bra	Lm566
	mov	#0,r0
L754:
	mov	#1,r0
Lm566:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L750
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L755
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L756
	mov.l	r0,@(16,r15)
L755:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L756:
L750:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L757
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L761
	mov	#1,r14
L760:
	mov	#0,r14
L761:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2637,r1
	cmp/ge	r1,r0
	bt	L762
	mov.w	L2637,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L762:
	mov.w	L2638,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L764
	mov.w	L2638,r0
	mov.l	r0,@(16,r15)
	mov.w	L2639,r0
	mov.l	r0,@(0,r15)
L764:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2626,r2
	and	r2,r1
	or	r1,r0
	bra	L758
	mov.l	r0,@(12,r15)
L757:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L768
	mov	#1,r14
L767:
	mov	#0,r14
L768:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L758:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2627,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L666
	mov.l	@(12,r15),r0
L663:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2626:	.short	-65536
L2633:	.short	-32768
L2634:	.short	32767
L2635:	.short	-1
L2636:	.short	65536
L2637:	.short	-32768
L2638:	.short	32767
L2639:	.short	-1
L2627:	.long	PTR_DAT_060450e8
	.global FUN_06045098
	.align 2
FUN_06045098:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L770:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L773
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L773:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L775
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L775:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L777
	add	r0,r14
	mov.l	L2640,r7
L777:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L781
	mov	#1,r14
L780:
	mov	#0,r14
L781:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L786
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L2640:	.short	65536
L786:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L782
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L787
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L788
	mov.l	r0,@(16,r15)
L787:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L788:
L782:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L789
	mov.l	@(16,r15),r0
	mov.w	L2641,r1
	cmp/ge	r1,r0
	bt	L791
	mov.w	L2641,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L791:
	mov.w	L2642,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L793
	mov.w	L2642,r0
	mov.l	r0,@(16,r15)
	mov.w	L2643,r0
	mov.l	r0,@(8,r15)
L793:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L789:
	mov.l	@(8,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L795
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L795:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L797
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L797:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L799
	add	r0,r12
	mov.l	L2645,r7
L799:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L803
	mov	#1,r14
L802:
	mov	#0,r14
L803:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L808
	mov	r15,r14
	bra	Lm212
	mov	#0,r0
	.align 2
L2641:	.short	-32768
L2642:	.short	32767
L2643:	.short	-1
L2645:	.short	65536
L808:
	mov	#1,r0
Lm212:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L804
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L809
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L810
	mov.l	r0,@(12,r15)
L809:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L810:
L804:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L811
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L815
	mov	#1,r14
L814:
	mov	#0,r14
L815:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2646,r1
	cmp/ge	r1,r0
	bt	L816
	mov.w	L2646,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L816:
	mov.w	L2647,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L818
	mov.w	L2647,r0
	mov.l	r0,@(16,r15)
	mov.w	L2648,r0
	mov.l	r0,@(0,r15)
L818:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L812
	mov.l	r0,@(16,r15)
	.align 2
L2646:	.short	-32768
L2647:	.short	32767
L2648:	.short	-1
L811:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L822
	mov	#1,r14
L821:
	mov	#0,r14
L822:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L812:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L823
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L823:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L825
	mov	r5,r14
L825:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L827
	add	r0,r12
	mov.l	L2649,r7
L827:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L831
	mov	#1,r14
L830:
	mov	#0,r14
L831:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L836
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L2649:	.short	65536
L836:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L832
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L837
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L838
	mov.l	r0,@(12,r15)
L837:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L838:
L832:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L839
	mov.l	@(12,r15),r0
	mov.w	L2650,r1
	cmp/ge	r1,r0
	bt	L841
	mov.w	L2650,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L841:
	mov.w	L2651,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L843
	mov.w	L2651,r0
	mov.l	r0,@(12,r15)
	mov.w	L2652,r0
	mov.l	r0,@(4,r15)
L843:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L839:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(8,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L845
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L845:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L847
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L847:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L849
	add	r0,r12
	mov.l	L2653,r7
L849:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L853
	mov	#1,r14
L852:
	mov	#0,r14
L853:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L858
	mov	r15,r14
	bra	Lm521
	mov	#0,r0
L858:
	mov	#1,r0
Lm521:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L854
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L859
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L860
	mov.l	r0,@(16,r15)
L859:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L860:
L854:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L861
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L865
	mov	#1,r14
L864:
	mov	#0,r14
L865:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2654,r1
	cmp/ge	r1,r0
	bt	L866
	mov.w	L2654,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L866:
	mov.w	L2655,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L868
	mov.w	L2655,r0
	mov.l	r0,@(12,r15)
	mov.w	L2656,r0
	mov.l	r0,@(0,r15)
L868:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L862
	mov.l	r0,@(12,r15)
L861:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L872
	mov	#1,r14
L871:
	mov	#0,r14
L872:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L862:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r4)
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L2644,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L770
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2644:	.short	-2
L2650:	.short	-32768
L2651:	.short	32767
L2652:	.short	-1
L2653:	.short	65536
L2654:	.short	-32768
L2655:	.short	32767
L2656:	.short	-1
	.global FUN_060450f2
	.align 2
FUN_060450f2:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r9,r0
	add	#8,r0
	mov.l	L2657,r1
	mov.l	@r1,r1
	and	r1,r0
	mov.l	r0,@(40,r15)
	mov.l	@(40,r15),r0
	tst	r0,r0
	bf	L874
	mov.l	L2657,r0
	mov.l	@r0,r0
	add	#44,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2657:	.short	-2
L874:
	mov.l	L2658,r0
	mov.l	@r0,r0
	mov.l	@(40,r15),r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(40,r15)
	mov	#3,r8
L876:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L879
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L879:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L881
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L881:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r5,r5
	bt/s	L883
	add	r0,r14
	mov.l	L2659,r7
L883:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L887
	mov	#1,r14
L886:
	mov	#0,r14
L887:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L892
	mov	r15,r14
	bra	Lm117
	mov	#0,r0
	.align 2
L2658:	.short	-32768
L2659:	.short	65536
L892:
	mov	#1,r0
Lm117:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L888
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L893
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L894
	mov.l	r0,@(16,r15)
L893:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L894:
L888:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L895
	mov.l	@(16,r15),r0
	mov.w	L2664,r1
	cmp/ge	r1,r0
	bt	L897
	mov.w	L2664,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L897:
	mov.w	L2660,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L899
	mov.w	L2660,r0
	mov.l	r0,@(16,r15)
	mov.w	L2661,r0
	mov.l	r0,@(8,r15)
L899:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L895:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(40,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L901
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L901:
	mov.l	@(40,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L903
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L903:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L905
	add	r0,r6
	mov.l	L2665,r7
L905:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L909
	mov	#1,r14
L908:
	mov	#0,r14
L909:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L914
	mov	r15,r14
	bra	Lm251
	mov	#0,r0
	.align 2
L2660:	.short	32767
L2661:	.short	-1
L2664:	.short	-32768
L2665:	.short	65536
L914:
	mov	#1,r0
Lm251:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L910
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L915
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L916
	mov.l	r0,@(12,r15)
L915:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L916:
L910:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L917
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L921
	mov	#1,r14
L920:
	mov	#0,r14
L921:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2668,r1
	cmp/ge	r1,r0
	bt	L922
	mov.w	L2668,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L922:
	mov.w	L2666,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L924
	mov.w	L2666,r0
	mov.l	r0,@(16,r15)
	mov.w	L2667,r0
	mov.l	r0,@(0,r15)
L924:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L918
	mov.l	r0,@(16,r15)
	.align 2
L2666:	.short	32767
L2667:	.short	-1
L2668:	.short	-32768
L917:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L928
	mov	#1,r14
L927:
	mov	#0,r14
L928:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L918:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L929
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L929:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L931
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L931:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L933
	add	r0,r6
	mov.l	L2669,r7
L933:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L937
	mov	#1,r14
L936:
	mov	#0,r14
L937:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L942
	mov	r15,r14
	bra	Lm426
	mov	#0,r0
	.align 2
L2669:	.short	65536
L942:
	mov	#1,r0
Lm426:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L938
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L943
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L944
	mov.l	r0,@(12,r15)
L943:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L944:
L938:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L945
	mov.l	@(12,r15),r0
	mov.w	L2672,r1
	cmp/ge	r1,r0
	bt	L947
	mov.w	L2672,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L947:
	mov.w	L2670,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L949
	mov.w	L2670,r0
	mov.l	r0,@(12,r15)
	mov.w	L2671,r0
	mov.l	r0,@(4,r15)
L949:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L945:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L951
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L951:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L953
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L953:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r5
	mov	#0,r2
	mov	r2,r7
	mov	r5,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r5,r5
	bt/s	L955
	add	r0,r6
	mov.l	L2673,r7
L955:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L959
	mov	#1,r14
L958:
	mov	#0,r14
L959:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L964
	mov	r15,r14
	bra	Lm568
	mov	#0,r0
L964:
	mov	#1,r0
Lm568:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L960
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L965
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L966
	mov.l	r0,@(16,r15)
L965:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L966:
L960:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L967
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L971
	mov	#1,r14
L970:
	mov	#0,r14
L971:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2676,r1
	cmp/ge	r1,r0
	bt	L972
	mov.w	L2676,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L972:
	mov.w	L2674,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L974
	mov.w	L2674,r0
	mov.l	r0,@(16,r15)
	mov.w	L2675,r0
	mov.l	r0,@(0,r15)
L974:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2662,r2
	and	r2,r1
	or	r1,r0
	bra	L968
	mov.l	r0,@(12,r15)
L967:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L978
	mov	#1,r14
L977:
	mov	#0,r14
L978:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L968:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r8
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2663,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r8,r8
	bf	L876
	mov.l	@(12,r15),r0
L873:
	add	#44,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2662:	.short	-65536
L2670:	.short	32767
L2671:	.short	-1
L2673:	.short	65536
L2674:	.short	32767
L2675:	.short	-1
L2663:	.long	DAT_0604514c
L2672:	.long	PTR_DAT_06045150
L2676:	.long	PTR_DAT_06045150
	.global FUN_060450f4
	.align 2
FUN_060450f4:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r5,r0
	add	#8,r0
	mov.l	L2677,r1
	mov.l	@r1,r1
	mov	r0,r8
	and	r1,r8
	tst	r8,r8
	bf	L980
	mov.l	L2677,r0
	mov.l	@r0,r0
	add	#40,r15
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L2677:	.short	-65536
L980:
	mov.l	L2678,r0
	mov.l	@r0,r0
	mov	r8,r1
	shlr2	r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r1,r1
	mov.l	r1,@(36,r15)
	add	#2,r0
	mov.w	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(36,r15),r0
	mov	r0,r1
	shll2	r1
	mov.l	r1,@(32,r15)
	mov.l	@(28,r15),r1
	shll2	r1
	mov.l	r1,@(24,r15)
	mov	#-4,r1
	mul.l	r0,r1
	sts	macl,r0
	mov	r0,r8
	mov	#3,r9
L982:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L985
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L985:
	mov.l	@(24,r15),r0
	mov	r0,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L987
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r10
L987:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r6
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L989
	add	r0,r14
	mov.l	L2679,r7
L989:
	mov	r14,r0
	shll16	r0
	mov	r6,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r6,r0
	bf/s	L993
	mov	#1,r14
L992:
	mov	#0,r14
L993:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L998
	mov	r15,r14
	bra	Lm116
	mov	#0,r0
	.align 2
L2678:	.short	-2
L2679:	.short	65536
L998:
	mov	#1,r0
Lm116:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L994
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L999
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1000
	mov.l	r0,@(16,r15)
L999:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1000:
L994:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1001
	mov.l	@(16,r15),r0
	mov.w	L2680,r1
	cmp/ge	r1,r0
	bt	L1003
	mov.w	L2680,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1003:
	mov.w	L2681,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1005
	mov.w	L2681,r0
	mov.l	r0,@(16,r15)
	mov.w	L2682,r0
	mov.l	r0,@(8,r15)
L1005:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1001:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r8,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1007
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1007:
	mov	r8,r14
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1009
	mov.l	@(36,r15),r0
	shll2	r0
	mov	r0,r14
L1009:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1011
	add	r0,r6
	mov.l	L2685,r7
L1011:
	mov.l	@(4,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1015
	mov	#1,r14
L1014:
	mov	#0,r14
L1015:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1020
	mov	r15,r14
	bra	Lm249
	mov	#0,r0
	.align 2
L2680:	.short	-32768
L2681:	.short	32767
L2682:	.short	-1
L2685:	.short	65536
L1020:
	mov	#1,r0
Lm249:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1016
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1021
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1022
	mov.l	r0,@(12,r15)
L1021:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1022:
L1016:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1023
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1027
	mov	#1,r14
L1026:
	mov	#0,r14
L1027:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2686,r1
	cmp/ge	r1,r0
	bt	L1028
	mov.w	L2686,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1028:
	mov.w	L2687,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1030
	mov.w	L2687,r0
	mov.l	r0,@(16,r15)
	mov.w	L2688,r0
	mov.l	r0,@(0,r15)
L1030:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1024
	mov.l	r0,@(16,r15)
	.align 2
L2686:	.short	-32768
L2687:	.short	32767
L2688:	.short	-1
L1023:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1034
	mov	#1,r14
L1033:
	mov	#0,r14
L1034:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1024:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1035
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1035:
	mov.l	@(32,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1037
	mov	#-4,r0
	mov.l	@(36,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1037:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1039
	add	r0,r6
	mov.l	L2689,r7
L1039:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1043
	mov	#1,r14
L1042:
	mov	#0,r14
L1043:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1048
	mov	r15,r14
	bra	Lm424
	mov	#0,r0
	.align 2
L2689:	.short	65536
L1048:
	mov	#1,r0
Lm424:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1044
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1049
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1050
	mov.l	r0,@(12,r15)
L1049:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1050:
L1044:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1051
	mov.l	@(12,r15),r0
	mov.w	L2690,r1
	cmp/ge	r1,r0
	bt	L1053
	mov.w	L2690,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1053:
	mov.w	L2691,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1055
	mov.w	L2691,r0
	mov.l	r0,@(12,r15)
	mov.w	L2692,r0
	mov.l	r0,@(4,r15)
L1055:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1051:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(24,r15),r1
	mov	r0,r10
	xor	r1,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1057
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1057:
	mov.l	@(24,r15),r0
	mov	r0,r14
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1059
	mov	#-4,r0
	mov.l	@(28,r15),r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r0,r14
L1059:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r6
	tst	r11,r11
	bt/s	L1061
	add	r0,r6
	mov.l	L2693,r7
L1061:
	mov.l	@(8,r15),r0
	mov	r6,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1065
	mov	#1,r14
L1064:
	mov	#0,r14
L1065:
	mov	r7,r0
	add	r14,r0
	mov	r6,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1070
	mov	r15,r14
	bra	Lm566
	mov	#0,r0
L1070:
	mov	#1,r0
Lm566:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1066
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1071
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1072
	mov.l	r0,@(16,r15)
L1071:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1072:
L1066:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1073
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1077
	mov	#1,r14
L1076:
	mov	#0,r14
L1077:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2694,r1
	cmp/ge	r1,r0
	bt	L1078
	mov.w	L2694,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1078:
	mov.w	L2695,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1080
	mov.w	L2695,r0
	mov.l	r0,@(16,r15)
	mov.w	L2696,r0
	mov.l	r0,@(0,r15)
L1080:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	@(12,r15),r1
	mov.l	L2683,r2
	and	r2,r1
	or	r1,r0
	bra	L1074
	mov.l	r0,@(12,r15)
L1073:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1084
	mov	#1,r14
L1083:
	mov	#0,r14
L1084:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1074:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r9
	add	#16,r4
	mov.l	@(20,r15),r0
	mov.w	L2684,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	tst	r9,r9
	bf	L982
	mov.l	@(12,r15),r0
L979:
	add	#40,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2683:	.short	-65536
L2690:	.short	-32768
L2691:	.short	32767
L2692:	.short	-1
L2693:	.short	65536
L2694:	.short	-32768
L2695:	.short	32767
L2696:	.short	-1
L2684:	.long	PTR_DAT_06045150
	.global FUN_0604510c
	.align 2
FUN_0604510c:
	mov.l	r14,@-r15
	sts.l	macl,@-r15
	add	#-24,r15
	not	r5,r0
	mov	r0,r9
	add	#1,r9
	mov	#3,r8
L1086:
	mov.l	@r4,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r1
	xor	r6,r1
	mov.l	r1,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1089
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1089:
	mov	r6,r10
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1091
	not	r6,r0
	mov	r0,r10
	add	#1,r10
L1091:
	extu.w	r10,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r12
	mov	r10,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r14
	tst	r11,r11
	bt/s	L1093
	add	r0,r14
	mov.l	L2697,r7
L1093:
	mov	r14,r0
	shll16	r0
	mov	r12,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r12,r0
	bf/s	L1097
	mov	#1,r14
L1096:
	mov	#0,r14
L1097:
	mov	r7,r0
	add	r14,r0
	mov	r14,r1
	shlr16	r1
	add	r1,r0
	mov	r10,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1102
	mov	r15,r14
	bra	Lm79
	mov	#0,r0
	.align 2
L2697:	.short	65536
L1102:
	mov	#1,r0
Lm79:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1098
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1103
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1104
	mov.l	r0,@(16,r15)
L1103:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1104:
L1098:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1105
	mov.l	@(16,r15),r0
	mov.w	L2698,r1
	cmp/ge	r1,r0
	bt	L1107
	mov.w	L2698,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1107:
	mov.w	L2699,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1109
	mov.w	L2699,r0
	mov.l	r0,@(16,r15)
	mov.w	L2700,r0
	mov.l	r0,@(8,r15)
L1109:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1105:
	mov.l	@(4,r4),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r9,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1111
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1111:
	mov	r9,r14
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1113
	mov	r5,r14
L1113:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1115
	add	r0,r12
	mov.l	L2702,r7
L1115:
	mov.l	@(4,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1119
	mov	#1,r14
L1118:
	mov	#0,r14
L1119:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1124
	mov	r15,r14
	bra	Lm210
	mov	#0,r0
	.align 2
L2698:	.short	-32768
L2699:	.short	32767
L2700:	.short	-1
L2702:	.short	65536
L1124:
	mov	#1,r0
Lm210:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1120
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1125
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1126
	mov.l	r0,@(12,r15)
L1125:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1126:
L1120:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1127
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1131
	mov	#1,r14
L1130:
	mov	#0,r14
L1131:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2703,r1
	cmp/ge	r1,r0
	bt	L1132
	mov.w	L2703,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1132:
	mov.w	L2704,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1134
	mov.w	L2704,r0
	mov.l	r0,@(16,r15)
	mov.w	L2705,r0
	mov.l	r0,@(0,r15)
L1134:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1128
	mov.l	r0,@(16,r15)
	.align 2
L2703:	.short	-32768
L2704:	.short	32767
L2705:	.short	-1
L1127:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1138
	mov	#1,r14
L1137:
	mov	#0,r14
L1138:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1128:
	mov.l	@r4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r10
	xor	r5,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1139
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1139:
	mov	r5,r14
	mov	r5,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1141
	not	r5,r0
	mov	r0,r14
	add	#1,r14
L1141:
	extu.w	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1143
	add	r0,r12
	mov.l	L2706,r7
L1143:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1147
	mov	#1,r14
L1146:
	mov	#0,r14
L1147:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1152
	mov	r15,r14
	bra	Lm382
	mov	#0,r0
	.align 2
L2706:	.short	65536
L1152:
	mov	#1,r0
Lm382:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1148
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1153
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1154
	mov.l	r0,@(12,r15)
L1153:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1154:
L1148:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1155
	mov.l	@(12,r15),r0
	mov.w	L2707,r1
	cmp/ge	r1,r0
	bt	L1157
	mov.w	L2707,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1157:
	mov.w	L2708,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1159
	mov.w	L2708,r0
	mov.l	r0,@(12,r15)
	mov.w	L2709,r0
	mov.l	r0,@(4,r15)
L1159:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1155:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r4
	mov.l	@(4,r4),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov	r0,r10
	xor	r6,r10
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1161
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1161:
	mov	r6,r14
	mov	r6,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1163
	not	r6,r0
	mov	r0,r14
	add	#1,r14
L1163:
	extu.w	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r14,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r11
	mov	#0,r2
	mov	r2,r7
	mov	r11,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r12
	tst	r11,r11
	bt/s	L1165
	add	r0,r12
	mov.l	L2710,r7
L1165:
	mov.l	@(8,r15),r0
	mov	r12,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1169
	mov	#1,r14
L1168:
	mov	#0,r14
L1169:
	mov	r7,r0
	add	r14,r0
	mov	r12,r1
	shlr16	r1
	add	r1,r0
	mov	r14,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r10,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1174
	mov	r15,r14
	bra	Lm521
	mov	#0,r0
L1174:
	mov	#1,r0
Lm521:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1170
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1175
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1176
	mov.l	r0,@(16,r15)
L1175:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1176:
L1170:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1177
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1181
	mov	#1,r14
L1180:
	mov	#0,r14
L1181:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2711,r1
	cmp/ge	r1,r0
	bt	L1182
	mov.w	L2711,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1182:
	mov.w	L2712,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1184
	mov.w	L2712,r0
	mov.l	r0,@(12,r15)
	mov.w	L2713,r0
	mov.l	r0,@(0,r15)
L1184:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1178
	mov.l	r0,@(12,r15)
L1177:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1188
	mov	#1,r14
L1187:
	mov	#0,r14
L1188:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1178:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r4)
	add	#-1,r8
	mov.l	@(20,r15),r0
	mov.w	L2701,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r4
	tst	r8,r8
	bf	L1086
	add	#24,r15
	lds.l	@r15+,macl
	rts
	mov.l	@r15+,r14
	.align 2
L2701:	.short	-2
L2707:	.short	-32768
L2708:	.short	32767
L2709:	.short	-1
L2710:	.short	65536
L2711:	.short	-32768
L2712:	.short	32767
L2713:	.short	-1
	.global FUN_06045198
	.align 2
FUN_06045198:
	sts.l	pr,@-r15
	mov.l	L2714,r3
	jsr	@r3
	mov	r4,r8
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L2714:	.long	FUN_060451bc
	.global FUN_060451aa
	.align 2
FUN_060451aa:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	mov.l	L2715,r3
	jsr	@r3
	mov	r4,r14
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2715:	.long	FUN_060451be
	.global FUN_060451bc
	.align 2
FUN_060451bc:
	sts.l	pr,@-r15
	mov.l	L2716,r4
	mov.l	L2717,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L2718,r3
	jsr	@r3
	nop
	mov.l	L2719,r3
	jsr	@r3
	nop
	mov.l	L2720,r3
	jsr	@r3
	nop
	mov.l	L2721,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2716:	.long	uRam060451f4
L2717:	.long	func_0x06044d80
L2718:	.long	func_0x060450f2
L2719:	.long	func_0x06045006
L2720:	.long	func_0x0604507e
L2721:	.long	func_0x06044e3c
	.global FUN_060451be
	.align 2
FUN_060451be:
	sts.l	pr,@-r15
	mov	r15,r14
	add	#-4,r15
	mov.l	L2722,r0
	jsr	@r0
	nop
	mov.l	L2723,r3
	jsr	@r3
	nop
	mov.l	L2724,r3
	jsr	@r3
	nop
	mov.l	L2725,r3
	jsr	@r3
	nop
	mov.l	@r12,r0
	neg	r0,r0
	mov.l	r0,@(0,r15)
	mov.l	@(4,r12),r0
	neg	r0,r11
	mov.l	@(8,r12),r0
	neg	r0,r10
	mov	r15,r5
	mov.l	L2726,r3
	jsr	@r3
	mov	r14,r15
	lds.l	@r15+,pr
	rts
	add	#0,r5
	.align 2
L2722:	.long	FUN_06044d80
L2723:	.long	FUN_060450f2
L2724:	.long	FUN_06045006
L2725:	.long	FUN_0604507e
L2726:	.long	FUN_06044e3c
	.global FUN_060451fa
	.align 2
FUN_060451fa:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L2727,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L2728,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1194:
	mov.l	@(4,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1197
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1197:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1199
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1199:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1201
	add	r0,r13
	mov.l	L2729,r12
L1201:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1205
	mov	#1,r14
L1204:
	mov	#0,r14
L1205:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1210
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L2727:	.short	-2
L2728:	.short	-32768
L2729:	.short	65536
L1210:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1206
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1211
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1212
	mov.l	r0,@(16,r15)
L1211:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1212:
L1206:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1213
	mov.l	@(16,r15),r0
	mov.w	L2733,r1
	cmp/ge	r1,r0
	bt	L1215
	mov.w	L2733,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1215:
	mov.w	L2730,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1217
	mov.w	L2730,r0
	mov.l	r0,@(16,r15)
	mov.w	L2731,r0
	mov.l	r0,@(8,r15)
L1217:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1213:
	mov.l	@(8,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1219
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1219:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1221
	mov.l	@(32,r15),r13
L1221:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1223
	add	r0,r11
	mov.l	L2734,r12
L1223:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1227
	mov	#1,r14
L1226:
	mov	#0,r14
L1227:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1232
	mov	r15,r14
	bra	Lm226
	mov	#0,r0
	.align 2
L2730:	.short	32767
L2731:	.short	-1
L2733:	.short	-32768
L2734:	.short	65536
L1232:
	mov	#1,r0
Lm226:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1228
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1233
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1234
	mov.l	r0,@(12,r15)
L1233:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1234:
L1228:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1235
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1239
	mov	#1,r14
L1238:
	mov	#0,r14
L1239:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2737,r1
	cmp/ge	r1,r0
	bt	L1240
	mov.w	L2737,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1240:
	mov.w	L2735,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1242
	mov.w	L2735,r0
	mov.l	r0,@(16,r15)
	mov.w	L2736,r0
	mov.l	r0,@(0,r15)
L1242:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1236
	mov.l	r0,@(16,r15)
	.align 2
L2735:	.short	32767
L2736:	.short	-1
L2737:	.short	-32768
L1235:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1246
	mov	#1,r14
L1245:
	mov	#0,r14
L1246:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1236:
	mov.l	@(4,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1247
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1247:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1249
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1249:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1251
	add	r0,r11
	mov.l	L2738,r12
L1251:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1255
	mov	#1,r14
L1254:
	mov	#0,r14
L1255:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1260
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L2738:	.short	65536
L1260:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1256
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1261
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1262
	mov.l	r0,@(12,r15)
L1261:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1262:
L1256:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1263
	mov.l	@(12,r15),r0
	mov.w	L2741,r1
	cmp/ge	r1,r0
	bt	L1265
	mov.w	L2741,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1265:
	mov.w	L2739,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1267
	mov.w	L2739,r0
	mov.l	r0,@(12,r15)
	mov.w	L2740,r0
	mov.l	r0,@(4,r15)
L1267:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1263:
	mov	r14,r0
	add	#4,r0
	mov.l	@(16,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	mov.l	@(8,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1269
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1269:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1271
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1271:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1273
	add	r0,r11
	mov.l	L2742,r12
L1273:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1277
	mov	#1,r14
L1276:
	mov	#0,r14
L1277:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1282
	mov	r15,r14
	bra	Lm543
	mov	#0,r0
L1282:
	mov	#1,r0
Lm543:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1278
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1283
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1284
	mov.l	r0,@(16,r15)
L1283:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1284:
L1278:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1285
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1289
	mov	#1,r14
L1288:
	mov	#0,r14
L1289:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2745,r1
	cmp/ge	r1,r0
	bt	L1290
	mov.w	L2745,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1290:
	mov.w	L2743,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1292
	mov.w	L2743,r0
	mov.l	r0,@(12,r15)
	mov.w	L2744,r0
	mov.l	r0,@(0,r15)
L1292:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1286
	mov.l	r0,@(12,r15)
L1285:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1296
	mov	#1,r14
L1295:
	mov	#0,r14
L1296:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1286:
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L2732,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	mov	r14,r0
	add	#8,r0
	mov.l	@(12,r15),r1
	shll16	r1
	mov.l	@(0,r15),r2
	shlr16	r2
	or	r2,r1
	mov.l	r1,@r0
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1194
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2739:	.short	32767
L2740:	.short	-1
L2742:	.short	65536
L2743:	.short	32767
L2744:	.short	-1
	.align 2
L2732:	.long	pcRam06045258
L2741:	.long	pcRam0604525c
L2745:	.long	pcRam0604525c
	.global FUN_0604521a
	.align 2
FUN_0604521a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L2746,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L2747,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1298:
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1301
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1301:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1303
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1303:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1305
	add	r0,r13
	mov.l	L2748,r12
L1305:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1309
	mov	#1,r14
L1308:
	mov	#0,r14
L1309:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1314
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L2746:	.short	-2
L2747:	.short	32767
L2748:	.short	65536
L1314:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1310
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1315
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1316
	mov.l	r0,@(16,r15)
L1315:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1316:
L1310:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1317
	mov.l	@(16,r15),r0
	mov.w	L2749,r1
	cmp/ge	r1,r0
	bt	L1319
	mov.w	L2749,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1319:
	mov.w	L2752,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1321
	mov.w	L2752,r0
	mov.l	r0,@(16,r15)
	mov.w	L2750,r0
	mov.l	r0,@(8,r15)
L1321:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1317:
	mov.l	@(8,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1323
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1323:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1325
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1325:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1327
	add	r0,r11
	mov.l	L2753,r12
L1327:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1331
	mov	#1,r14
L1330:
	mov	#0,r14
L1331:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1336
	mov	r15,r14
	bra	Lm230
	mov	#0,r0
	.align 2
L2749:	.short	-32768
L2750:	.short	-1
L2752:	.short	32767
L2753:	.short	65536
L1336:
	mov	#1,r0
Lm230:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1332
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1337
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1338
	mov.l	r0,@(12,r15)
L1337:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1338:
L1332:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1339
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1343
	mov	#1,r14
L1342:
	mov	#0,r14
L1343:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2754,r1
	cmp/ge	r1,r0
	bt	L1344
	mov.w	L2754,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1344:
	mov.w	L2756,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1346
	mov.w	L2756,r0
	mov.l	r0,@(16,r15)
	mov.w	L2755,r0
	mov.l	r0,@(0,r15)
L1346:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1340
	mov.l	r0,@(16,r15)
	.align 2
L2754:	.short	-32768
L2755:	.short	-1
L2756:	.short	32767
L1339:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1350
	mov	#1,r14
L1349:
	mov	#0,r14
L1350:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1340:
	mov.l	@r14,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1351
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1351:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1353
	mov.l	@(32,r15),r13
L1353:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1355
	add	r0,r11
	mov.l	L2757,r12
L1355:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1359
	mov	#1,r14
L1358:
	mov	#0,r14
L1359:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1364
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L2757:	.short	65536
L1364:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1360
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1365
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1366
	mov.l	r0,@(12,r15)
L1365:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1366:
L1360:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1367
	mov.l	@(12,r15),r0
	mov.w	L2758,r1
	cmp/ge	r1,r0
	bt	L1369
	mov.w	L2758,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1369:
	mov.w	L2760,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1371
	mov.w	L2760,r0
	mov.l	r0,@(12,r15)
	mov.w	L2759,r0
	mov.l	r0,@(4,r15)
L1371:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1367:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r14
	mov.l	@(8,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1373
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1373:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1375
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1375:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1377
	add	r0,r11
	mov.l	L2761,r12
L1377:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1381
	mov	#1,r14
L1380:
	mov	#0,r14
L1381:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1386
	mov	r15,r14
	bra	Lm541
	mov	#0,r0
L1386:
	mov	#1,r0
Lm541:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1382
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1387
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1388
	mov.l	r0,@(16,r15)
L1387:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1388:
L1382:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1389
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1393
	mov	#1,r14
L1392:
	mov	#0,r14
L1393:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2762,r1
	cmp/ge	r1,r0
	bt	L1394
	mov.w	L2762,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1394:
	mov.w	L2764,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1396
	mov.w	L2764,r0
	mov.l	r0,@(12,r15)
	mov.w	L2763,r0
	mov.l	r0,@(0,r15)
L1396:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1390
	mov.l	r0,@(12,r15)
L1389:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1400
	mov	#1,r14
L1399:
	mov	#0,r14
L1400:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1390:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(8,r14)
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L2751,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1298
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2758:	.short	-32768
L2759:	.short	-1
L2761:	.short	65536
L2762:	.short	-32768
L2763:	.short	-1
	.align 2
L2751:	.long	pcRam06045258
L2760:	.long	pcRam0604525c
L2764:	.long	pcRam0604525c
	.global FUN_0604523a
	.align 2
FUN_0604523a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-40,r15
	mov	r4,r14
	mov.l	L2765,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(36,r15),r4
	mov.l	L2766,r0
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	r0,@(28,r15)
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r8
	add	#1,r8
	mov	#3,r0
	mov.l	r0,@(24,r15)
L1402:
	mov.l	@r14,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r2
	xor	r1,r2
	mov.l	r2,@(12,r15)
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1405
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1405:
	mov.l	@(28,r15),r0
	mov	r0,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1407
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r9
	add	#1,r9
L1407:
	extu.w	r9,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r11
	mov	r9,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r13
	tst	r10,r10
	bt/s	L1409
	add	r0,r13
	mov.l	L2767,r12
L1409:
	mov	r13,r0
	shll16	r0
	mov	r11,r1
	add	r0,r1
	mov.l	r1,@(8,r15)
	mov.l	@(8,r15),r0
	cmp/hs	r11,r0
	bf/s	L1413
	mov	#1,r14
L1412:
	mov	#0,r14
L1413:
	mov	r12,r0
	add	r14,r0
	mov	r13,r1
	shlr16	r1
	add	r1,r0
	mov	r9,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(12,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1418
	mov	r15,r14
	bra	Lm95
	mov	#0,r0
	.align 2
L2765:	.short	-2
L2766:	.short	-32768
L2767:	.short	65536
L1418:
	mov	#1,r0
Lm95:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1414
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1419
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1420
	mov.l	r0,@(16,r15)
L1419:
	mov.l	@(8,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(8,r15)
L1420:
L1414:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1421
	mov.l	@(16,r15),r0
	mov.w	L2771,r1
	cmp/ge	r1,r0
	bt	L1423
	mov.w	L2771,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(8,r15)
L1423:
	mov.w	L2768,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1425
	mov.w	L2768,r0
	mov.l	r0,@(16,r15)
	mov.w	L2769,r0
	mov.l	r0,@(8,r15)
L1425:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(16,r15)
L1421:
	mov.l	@(4,r14),r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov	r0,r9
	xor	r8,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1427
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1427:
	mov	r8,r13
	mov	r8,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1429
	mov.l	@(32,r15),r13
L1429:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(4,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1431
	add	r0,r11
	mov.l	L2772,r12
L1431:
	mov.l	@(4,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1435
	mov	#1,r14
L1434:
	mov	#0,r14
L1435:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1440
	mov	r15,r14
	bra	Lm226
	mov	#0,r0
	.align 2
L2768:	.short	32767
L2769:	.short	-1
L2771:	.short	-32768
L2772:	.short	65536
L1440:
	mov	#1,r0
Lm226:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1436
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1441
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1442
	mov.l	r0,@(12,r15)
L1441:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1442:
L1436:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1443
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1447
	mov	#1,r14
L1446:
	mov	#0,r14
L1447:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.w	L2775,r1
	cmp/ge	r1,r0
	bt	L1448
	mov.w	L2775,r0
	mov.l	r0,@(16,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1448:
	mov.w	L2773,r0
	mov.l	@(16,r15),r1
	cmp/ge	r1,r0
	bt	L1450
	mov.w	L2773,r0
	mov.l	r0,@(16,r15)
	mov.w	L2774,r0
	mov.l	r0,@(0,r15)
L1450:
	mov.l	@(16,r15),r0
	extu.w	r0,r0
	bra	L1444
	mov.l	r0,@(16,r15)
	.align 2
L2773:	.short	32767
L2774:	.short	-1
L2775:	.short	-32768
L1443:
	mov.l	@(8,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1454
	mov	#1,r14
L1453:
	mov	#0,r14
L1454:
	mov.l	@(12,r15),r0
	add	r14,r0
	mov.l	@(16,r15),r1
	add	r1,r0
	mov.l	r0,@(16,r15)
L1444:
	mov.l	@r14,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.l	@(32,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1455
	mov.l	@(12,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(12,r15)
L1455:
	mov.l	@(32,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1457
	mov.l	@(32,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1457:
	extu.w	r13,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1459
	add	r0,r11
	mov.l	L2776,r12
L1459:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(4,r15)
	mov.l	@(4,r15),r1
	cmp/hs	r0,r1
	bf/s	L1463
	mov	#1,r14
L1462:
	mov	#0,r14
L1463:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(12,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1468
	mov	r15,r14
	bra	Lm400
	mov	#0,r0
	.align 2
L2776:	.short	65536
L1468:
	mov	#1,r0
Lm400:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1464
	mov.l	@(12,r15),r0
	not	r0,r0
	mov.l	r0,@(12,r15)
	mov.l	@(4,r15),r0
	tst	r0,r0
	bf	L1469
	mov.l	@(12,r15),r0
	add	#1,r0
	bra	L1470
	mov.l	r0,@(12,r15)
L1469:
	mov.l	@(4,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(4,r15)
L1470:
L1464:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1471
	mov.l	@(12,r15),r0
	mov.w	L2779,r1
	cmp/ge	r1,r0
	bt	L1473
	mov.w	L2779,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(4,r15)
L1473:
	mov.w	L2777,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1475
	mov.w	L2777,r0
	mov.l	r0,@(12,r15)
	mov.w	L2778,r0
	mov.l	r0,@(4,r15)
L1475:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	mov.l	r0,@(12,r15)
L1471:
	mov.l	@(16,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@r14
	mov.l	@(4,r14),r0
	mov.l	r0,@(16,r15)
	mov.l	@(16,r15),r0
	mov.l	@(28,r15),r1
	mov	r0,r9
	xor	r1,r9
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1477
	mov.l	@(16,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(16,r15)
L1477:
	mov.l	@(28,r15),r0
	mov	r0,r13
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1479
	mov.l	@(28,r15),r0
	not	r0,r0
	mov	r0,r13
	add	#1,r13
L1479:
	extu.w	r13,r0
	mov.l	@(16,r15),r1
	extu.w	r1,r2
	mul.l	r2,r0
	sts	macl,r3
	mov.l	r3,@(8,r15)
	mov	r13,r3
	shlr16	r3
	mul.l	r2,r3
	sts	macl,r2
	mov	r2,r10
	mov	#0,r2
	mov	r2,r12
	mov	r10,r2
	shlr16	r1
	mul.l	r1,r0
	sts	macl,r0
	mov	r2,r11
	tst	r10,r10
	bt/s	L1481
	add	r0,r11
	mov.l	L2780,r12
L1481:
	mov.l	@(8,r15),r0
	mov	r11,r1
	shll16	r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1485
	mov	#1,r14
L1484:
	mov	#0,r14
L1485:
	mov	r12,r0
	add	r14,r0
	mov	r11,r1
	shlr16	r1
	add	r1,r0
	mov	r13,r1
	shlr16	r1
	mov.l	@(16,r15),r2
	shlr16	r2
	mul.l	r2,r1
	sts	macl,r1
	add	r1,r0
	mov.l	r0,@(16,r15)
	mov	r9,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1490
	mov	r15,r14
	bra	Lm541
	mov	#0,r0
L1490:
	mov	#1,r0
Lm541:
	mov	r14,r15
	not	r0,r0
	add	#1,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1486
	mov.l	@(16,r15),r0
	not	r0,r0
	mov.l	r0,@(16,r15)
	mov.l	@(0,r15),r0
	tst	r0,r0
	bf	L1491
	mov.l	@(16,r15),r0
	add	#1,r0
	bra	L1492
	mov.l	r0,@(16,r15)
L1491:
	mov.l	@(0,r15),r0
	not	r0,r0
	add	#1,r0
	mov.l	r0,@(0,r15)
L1492:
L1486:
	mov	#1,r0
	mov.l	@(20,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1493
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1497
	mov	#1,r14
L1496:
	mov	#0,r14
L1497:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	r0,@(12,r15)
	mov.l	@(12,r15),r0
	mov.w	L2783,r1
	cmp/ge	r1,r0
	bt	L1498
	mov.w	L2783,r0
	mov.l	r0,@(12,r15)
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1498:
	mov.w	L2781,r0
	mov.l	@(12,r15),r1
	cmp/ge	r1,r0
	bt	L1500
	mov.w	L2781,r0
	mov.l	r0,@(12,r15)
	mov.w	L2782,r0
	mov.l	r0,@(0,r15)
L1500:
	mov.l	@(12,r15),r0
	extu.w	r0,r0
	bra	L1494
	mov.l	r0,@(12,r15)
L1493:
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	mov	r0,r2
	add	r1,r2
	mov.l	r2,@(0,r15)
	mov.l	@(0,r15),r1
	cmp/hs	r0,r1
	bf/s	L1504
	mov	#1,r14
L1503:
	mov	#0,r14
L1504:
	mov.l	@(16,r15),r0
	add	r14,r0
	mov.l	@(12,r15),r1
	add	r1,r0
	mov.l	r0,@(12,r15)
L1494:
	mov.l	@(12,r15),r0
	shll16	r0
	mov.l	@(0,r15),r1
	shlr16	r1
	or	r1,r0
	mov.l	r0,@(4,r14)
	mov.l	@(24,r15),r0
	add	#-1,r0
	mov.l	r0,@(24,r15)
	mov.l	@(20,r15),r0
	mov.w	L2770,r1
	and	r1,r0
	mov.l	r0,@(20,r15)
	add	#16,r14
	mov.l	@(24,r15),r0
	tst	r0,r0
	bf	L1402
	add	#40,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2777:	.short	32767
L2778:	.short	-1
L2780:	.short	65536
L2781:	.short	32767
L2782:	.short	-1
	.align 2
L2770:	.long	pcRam06045258
L2779:	.long	pcRam0604525c
L2783:	.long	pcRam0604525c
	.global FUN_060452f0
	.align 2
FUN_060452f0:
	sts.l	pr,@-r15
	mov.l	L2784,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2784:	.long	FUN_06045368
	.global FUN_06045318
	.align 2
FUN_06045318:
	sts.l	pr,@-r15
	mov.l	L2785,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2785:	.long	FUN_060453c8
	.global FUN_06045340
	.align 2
FUN_06045340:
	sts.l	pr,@-r15
	mov.l	L2786,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2786:	.long	FUN_060453b8
	.global FUN_06045368
	.align 2
FUN_06045368:
	sts.l	pr,@-r15
	mov.l	L2787,r3
	jsr	@r3
	nop
	mov.l	L2788,r3
	jsr	@r3
	nop
	mov.l	L2789,r4
	mov.l	L2790,r3
	jsr	@r3
	mov.l	L2791,r4
	mov.l	L2792,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L2793,r3
	jsr	@r3
	nop
	mov.l	L2794,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L2787:	.long	PTR_FUN_0604539c
L2788:	.long	PTR_SUB_060453a0
L2789:	.long	PTR_DAT_060453a4
L2790:	.long	FUN_060453c8
L2791:	.long	PTR_DAT_060453ac
L2792:	.long	func_0x060453cc
L2793:	.long	PTR_FUN_060453b4
L2794:	.long	FUN_06045ccc
	.global FUN_06045378
	.align 2
FUN_06045378:
	sts.l	pr,@-r15
	mov.l	L2795,r4
	mov.l	L2796,r3
	jsr	@r3
	mov.l	L2797,r4
	mov.l	L2796,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r4,r4
	mov.l	L2798,r3
	jsr	@r3
	nop
	mov.l	L2799,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L2795:	.long	PTR_DAT_060453a4
L2796:	.long	FUN_060453cc
L2797:	.long	PTR_DAT_060453ac
L2798:	.long	PTR_FUN_060453b4
L2799:	.long	FUN_06045ccc
	.global FUN_060453b8
	.align 2
FUN_060453b8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L2800,r0
	mov.l	@r0,r13
	mov.l	L2801,r0
	mov.l	@r0,r12
L1511:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1511
	mov.l	L2802,r3
	jsr	@r3
	nop
	mov.l	L2803,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L2800:	.long	puRam060453c4
L2801:	.long	puRam060453c0
L2802:	.long	func_0x060456cc
L2803:	.long	FUN_06045ccc
	.global FUN_060453c8
	.align 2
FUN_060453c8:
	sts.l	pr,@-r15
	mov	#48,r11
	mov.l	L2804,r0
	mov.l	@r0,r13
	mov.l	L2805,r0
	mov.l	@r0,r12
L1515:
	mov.l	@r12+,r14
	mov.l	r14,@r13
	dt	r11
	add	#4,r13
	bf	L1515
	mov.l	L2806,r3
	jsr	@r3
	nop
	mov.l	L2807,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L2804:	.long	puRam06045598
L2805:	.long	puRam06045594
L2806:	.long	func_0x060456cc
L2807:	.long	FUN_06045ccc
	.global FUN_060453cc
	.align 2
FUN_060453cc:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#48,r12
L1519:
	mov.l	@r14+,r13
	mov.l	r13,@r11
	dt	r12
	add	#4,r11
	bf	L1519
	mov.l	L2808,r3
	jsr	@r3
	nop
	mov.l	L2809,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov	#0,r4
	.align 2
L2808:	.long	FUN_060456cc
L2809:	.long	FUN_06045ccc
	.global FUN_0604556c
	.align 2
FUN_0604556c:
	sts.l	pr,@-r15
	mov.l	L2810,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2810:	.long	FUN_0604559c
	.global FUN_0604559c
	.align 2
FUN_0604559c:
	sts.l	pr,@-r15
	mov.l	L2811,r3
	jsr	@r3
	nop
	mov.l	L2812,r3
	jsr	@r3
	nop
	mov.l	L2813,r3
	jsr	@r3
	nop
	mov.l	L2814,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov	r1,r14
	mov.l	L2817,r4
	mov.l	L2815,r1
	mov.l	L2816,r0
	mov.l	L2818,r0
	mov.l	@r1,r1
	mov.l	r0,@r1
	mov.l	@r0,r1
	extu.w	r14,r0
	mov.l	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2819,r0
	mov.l	@r0,r0
	mov.w	L2820,r1
	add	r1,r0
	mov.l	L2822,r3
	mov.l	L2821,r1
	mov.l	@r1,r1
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r0
	.align 2
L2820:	.short	140
	.align 2
L2811:	.long	PTR_FUN_060455f4
L2812:	.long	PTR_FUN_060455f8
L2813:	.long	func_0x06045378
L2814:	.long	DAT_060455ee
L2815:	.long	DAT_060455fc
L2816:	.long	DAT_06045600
L2817:	.long	PTR_LAB_06045604
L2818:	.long	DAT_06045608
L2819:	.long	DAT_0604560c
L2821:	.long	DAT_060455f0
L2822:	.long	func_0x060456cc
	.global FUN_060455d0
	.align 2
FUN_060455d0:
	sts.l	pr,@-r15
	mov.l	L2823,r0
	mov.l	@r0,r0
	mov.w	L2824,r1
	add	r1,r0
	mov.l	L2826,r3
	mov.l	L2825,r1
	mov.l	@r1,r1
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r1,@r0
	.align 2
L2824:	.short	140
	.align 2
L2823:	.long	DAT_06045610
L2825:	.long	DAT_060455f0
L2826:	.long	FUN_060456cc
	.global FUN_060455e2
	.align 2
FUN_060455e2:
	sts.l	pr,@-r15
	mov.l	L2827,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2827:	.long	FUN_0604562c
	.global FUN_06045614
	.align 2
FUN_06045614:
	sts.l	pr,@-r15
	mov.l	L2828,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2828:	.long	FUN_06045650
	.global FUN_06045620
	.align 2
FUN_06045620:
	sts.l	pr,@-r15
	mov.l	L2829,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2829:	.long	func_0x06045664
	.global FUN_0604562c
	.align 2
FUN_0604562c:
	sts.l	pr,@-r15
	mov.l	L2830,r4
	mov.l	L2831,r0
	mov.l	@r4,r4
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L2832,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2830:	.long	uRam06045644
L2831:	.long	pcRam06045648
L2832:	.long	pcRam0604564c
	.global FUN_06045650
	.align 2
FUN_06045650:
	mov.l	L2833,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.w	L2834,r1
	add	r1,r0
	mov.l	L2835,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2836,r0
	add	r7,r0
	mov.l	L2837,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2838,r0
	add	r7,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.w	L2839,r0
	add	r7,r0
	mov	#0,r1
	rts
	mov.l	r1,@r0
	.align 2
L2834:	.short	136
L2836:	.short	144
L2838:	.short	132
L2839:	.short	168
L2833:	.long	iRam06045690
L2835:	.long	uRam06045688
L2837:	.long	uRam0604568a
	.global FUN_06045664
	.align 2
FUN_06045664:
	mov.l	L2840,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.w	L2841,r1
	add	r1,r0
	mov.l	L2842,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2843,r0
	add	r7,r0
	mov.l	L2844,r1
	mov.l	@r1,r1
	mov.w	r1,@r0
	mov.w	L2845,r0
	add	r7,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.w	L2846,r0
	add	r7,r0
	mov	#0,r1
	rts
	mov.l	r1,@r0
	.align 2
L2841:	.short	136
L2843:	.short	144
L2845:	.short	132
L2846:	.short	168
L2840:	.long	iRam06045694
L2842:	.long	uRam0604568c
L2844:	.long	uRam0604568e
	.global FUN_06045678
	.align 2
FUN_06045678:
	sts.l	pr,@-r15
	mov.l	L2847,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2847:	.long	FUN_06045698
	.global FUN_06045698
	.align 2
FUN_06045698:
	rts
	nop
	.global FUN_060456aa
	.align 2
FUN_060456aa:
	sts.l	pr,@-r15
	mov.l	L2848,r3
	jsr	@r3
	nop
	mov.l	L2848,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2848:	.long	FUN_060456c2
	.global FUN_060456ac
	.align 2
FUN_060456ac:
	sts.l	pr,@-r15
	mov.l	L2849,r3
	jsr	@r3
	nop
	mov.l	L2849,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2849:	.long	FUN_060456c2
	.global FUN_060456c2
	.align 2
FUN_060456c2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L2850,r1
	add	r13,r1
	mov.l	L2851,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.w	r14,@r1
	.align 2
L2850:	.short	140
	.align 2
L2851:	.long	FUN_060456cc
	.global FUN_060456cc
	.align 2
FUN_060456cc:
	mov.l	L2852,r0
	mov.l	@r7,r1
	mov.l	r1,@r0
	mov.l	L2853,r1
	mov.w	L2852,r2
	add	r7,r2
	mov.w	@r2,r0
	mov.l	r0,@r1
	mov.l	L2854,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov.l	L2855,r0
	mov.l	@r0,r0
	rts
	mov.l	r0,@(12,r14)
	.align 2
L2852:	.long	_DAT_ffffff00
L2853:	.long	_DAT_ffffff10
L2854:	.long	_DAT_ffffff14
L2855:	.long	_DAT_ffffff1c
	.global FUN_060456ec
	.align 2
FUN_060456ec:
	mov.w	L2856,r0
	add	r7,r0
	mov.l	L2857,r1
	mov.l	@r1,r1
	rts
	mov.w	r1,@r0
	.align 2
L2856:	.short	146
	.align 2
L2857:	.long	uRam060456f8
	.global FUN_060456f2
	.align 2
FUN_060456f2:
	mov.w	L2858,r0
	add	r7,r0
	mov.l	L2859,r1
	mov.l	@r1,r1
	rts
	mov.w	r1,@r0
	.align 2
L2858:	.short	146
	.align 2
L2859:	.long	uRam060456fa
	.global FUN_060456fc
	.align 2
FUN_060456fc:
	mov.l	L2860,r0
	mov.l	@r0,r7
	mov.l	L2861,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1540
	mov.l	L2862,r0
	mov.l	@r0,r7
L1540:
	rts
	mov.l	r4,@r7
	.align 2
L2860:	.long	puRam0604570c
L2861:	.long	_DAT_ffffffe2
L2862:	.long	puRam06045710
	.global FUN_06045714
	.align 2
FUN_06045714:
	sts.l	pr,@-r15
	mov.l	L2863,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2863:	.long	FUN_06045738
	.global FUN_06045738
	.align 2
FUN_06045738:
	sts.l	pr,@-r15
	add	#-16,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2864,r0
	mov.l	@r0,r0
	mov	r0,r11
	mov.l	@r0,r0
	tst	r0,r0
	bf	L1544
	mov	#12,r8
	mov.l	L2865,r0
	mov.l	@r0,r9
L1546:
	mov.l	@r14+,r10
	mov.l	r10,@r9
	dt	r8
	add	#4,r9
	bf	L1546
	mov.l	L2865,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r11)
	mov.l	r13,@(8,r11)
	mov.l	L2866,r0
	mov.l	r0,@r11
	mov.l	L2867,r0
	mov.l	@r0,r0
	mov.w	L2868,r1
	mov.l	r1,@r0
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L1544:
	mov.l	L2869,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r0
	mov.w	L2865,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1543
	mov.l	L2870,r3
	jsr	@r3
	nop
	mov.l	L2871,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r8
	mov.l	@(8,r8),r0
	add	r8,r0
	mov.l	r0,@(12,r15)
	mov.w	@(2,r8),r0
	mov	r0,r8
L1551:
	mov.l	@(0,r15),r0
	mov.w	L2865,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1554
	nop
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
L1554:
	mov.l	@(12,r15),r0
	mov.w	@r0+,r12
	mov.l	r0,@(8,r15)
	mov.l	@(0,r15),r0
	mov.w	L2872,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(12,r15),r0
	add	#4,r0
	mov.l	r0,@(12,r15)
	mov.l	@(0,r15),r0
	mov.w	L2873,r1
	add	r1,r0
	mov	r0,r1
	mov.l	@(8,r15),r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	extu.w	r12,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1556
	mov.l	L2874,r3
	jsr	@r3
	nop
	bra	L1557
	nop
L1556:
	mov.l	L2875,r3
	jsr	@r3
	nop
L1557:
	dt	r8
	bf	L1551
L1543:
	add	#16,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2868:	.short	22368
L2872:	.short	128
L2873:	.short	130
	.align 2
L2864:	.long	piRam06045770
L2865:	.long	puRam06045774
L2866:	.long	FUN_06045760
L2867:	.long	puRam06045778
L2869:	.long	FUN_060459c4
L2870:	.long	FUN_060463e4
L2871:	.long	FUN_06046602
L2874:	.long	FUN_06045a2c
L2875:	.long	FUN_06045a7e
	.global FUN_06045760
	.align 2
FUN_06045760:
	sts.l	pr,@-r15
	mov.l	L2876,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	@(4,r0),r4
	mov.l	L2878,r3
	mov.l	L2877,r0
	mov.l	r1,@r0
	mov.l	@r0,r0
	jsr	@r3
	mov.l	@(8,r0),r5
	mov.w	L2877,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1558
	mov.l	L2879,r3
	jsr	@r3
	nop
	mov.l	L2880,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L1561:
	mov.w	L2877,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1564
	nop
	lds.l	@r15+,pr
	rts
	nop
L1564:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2881,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2882,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1566
	mov.l	L2883,r3
	jsr	@r3
	nop
	bra	L1567
	nop
L1566:
	mov.l	L2884,r3
	jsr	@r3
	nop
L1567:
	dt	r13
	bf	L1561
L1558:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2881:	.short	128
L2882:	.short	130
L2876:	.long	puRam0604577c
L2877:	.long	iRam06045780
L2878:	.long	FUN_060459c4
L2879:	.long	FUN_060463e4
L2880:	.long	FUN_06046602
L2883:	.long	FUN_06045a2c
L2884:	.long	FUN_06045a7e
	.global FUN_06045784
	.align 2
FUN_06045784:
	sts.l	pr,@-r15
	mov.l	L2885,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2885:	.long	FUN_060457a8
	.global FUN_060457aa
	.align 2
FUN_060457aa:
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2886,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2887,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r0
	mov.w	L2888,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1569
	mov.l	L2889,r3
	jsr	@r3
	nop
	mov.l	L2890,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r10
	mov.l	@(8,r10),r0
	add	r10,r0
	mov	r0,r9
	mov.w	@(2,r10),r0
	mov	r0,r10
L1572:
	mov.l	@(0,r15),r0
	mov.w	L2888,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1575
	nop
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
L1575:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r0
	mov.w	L2891,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r0
	mov.w	L2892,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r8,r0
	mov.w	r0,@r1
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1577
	mov.l	L2893,r3
	jsr	@r3
	nop
	bra	L1578
	nop
L1577:
	mov.l	L2894,r3
	jsr	@r3
	nop
L1578:
	dt	r10
	bf	L1572
L1569:
	add	#8,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2887:	.short	148
L2888:	.short	136
L2891:	.short	128
L2892:	.short	130
L2886:	.long	FUN_060459c4
L2889:	.long	FUN_060463e4
L2890:	.long	FUN_06046602
L2893:	.long	FUN_06045a2c
L2894:	.long	FUN_06045a7e
	.global FUN_060457ac
	.align 2
FUN_060457ac:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-8,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L2895,r3
	jsr	@r3
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L2896,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r12,@r1
	mov.l	@(0,r15),r0
	mov.w	L2897,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1579
	mov.l	L2898,r3
	jsr	@r3
	nop
	mov.l	L2899,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	@r0,r10
	mov.l	@(8,r10),r0
	add	r10,r0
	mov	r0,r9
	mov.w	@(2,r10),r0
	mov	r0,r10
L1582:
	mov.l	@(0,r15),r0
	mov.w	L2897,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1585
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L1585:
	mov.w	@r9,r11
	mov	r9,r8
	add	#2,r8
	mov.l	@(0,r15),r0
	mov.w	L2900,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	mov.l	@(0,r15),r0
	mov.w	L2901,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r8,r0
	mov.w	r0,@r1
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1587
	mov.l	L2902,r3
	jsr	@r3
	nop
	bra	L1588
	nop
L1587:
	mov.l	L2903,r3
	jsr	@r3
	nop
L1588:
	dt	r10
	bf	L1582
L1579:
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2896:	.short	148
L2897:	.short	136
L2900:	.short	128
L2901:	.short	130
L2895:	.long	FUN_060459c4
L2898:	.long	FUN_060463e4
L2899:	.long	func_0x06046602
L2902:	.long	func_0x06045a2c
L2903:	.long	FUN_06045a7e
	.global FUN_060457dc
	.align 2
FUN_060457dc:
	sts.l	pr,@-r15
	mov.l	L2904,r3
	jsr	@r3
	nop
	mov.w	L2905,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1589
	mov.l	L2906,r3
	jsr	@r3
	nop
	mov.l	L2907,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L1592:
	mov.w	L2905,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1595
	nop
	lds.l	@r15+,pr
	rts
	nop
L1595:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2908,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2909,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1597
	mov.l	L2910,r3
	jsr	@r3
	nop
	bra	L1598
	nop
L1597:
	mov.l	L2911,r3
	jsr	@r3
	nop
L1598:
	dt	r13
	bf	L1592
L1589:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2905:	.short	136
L2908:	.short	128
L2909:	.short	130
	.align 2
L2904:	.long	FUN_060459c4
L2906:	.long	FUN_060463e4
L2907:	.long	func_0x06046602
L2910:	.long	func_0x06045a2c
L2911:	.long	FUN_06045a7e
	.global FUN_060457de
	.align 2
FUN_060457de:
	sts.l	pr,@-r15
	mov.l	L2912,r3
	jsr	@r3
	nop
	mov.w	L2913,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1599
	mov.l	L2914,r3
	jsr	@r3
	nop
	mov.l	L2915,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L1602:
	mov.w	L2913,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1605
	nop
	lds.l	@r15+,pr
	rts
	nop
L1605:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2916,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2917,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1607
	mov.l	L2918,r3
	jsr	@r3
	nop
	bra	L1608
	nop
L1607:
	mov.l	L2919,r3
	jsr	@r3
	nop
L1608:
	dt	r13
	bf	L1602
L1599:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2913:	.short	136
L2916:	.short	128
L2917:	.short	130
	.align 2
L2912:	.long	FUN_060459c4
L2914:	.long	FUN_060463e4
L2915:	.long	FUN_06046602
L2918:	.long	FUN_06045a2c
L2919:	.long	FUN_06045a7e
	.global FUN_060457e2
	.align 2
FUN_060457e2:
	sts.l	pr,@-r15
	mov.w	L2920,r0
	add	r9,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1609
	mov.l	L2921,r3
	jsr	@r3
	nop
	mov.l	L2922,r3
	jsr	@r3
	nop
	mov.l	@(48,r10),r13
	mov.l	@(8,r13),r0
	add	r13,r0
	mov	r0,r12
	mov.w	@(2,r13),r0
	mov	r0,r13
L1612:
	mov.w	L2920,r0
	add	r9,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1615
	nop
	lds.l	@r15+,pr
	rts
	nop
L1615:
	mov.w	@r12,r14
	mov	r12,r11
	add	#2,r11
	mov.w	L2923,r1
	add	r9,r1
	mov.w	r14,@r1
	add	#4,r12
	mov.w	L2924,r1
	add	r9,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1617
	mov.l	L2925,r3
	jsr	@r3
	nop
	bra	L1618
	nop
L1617:
	mov.l	L2926,r3
	jsr	@r3
	nop
L1618:
	dt	r13
	bf	L1612
L1609:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2920:	.short	136
L2923:	.short	128
L2924:	.short	130
	.align 2
L2921:	.long	FUN_060463e4
L2922:	.long	FUN_06046602
L2925:	.long	FUN_06045a2c
L2926:	.long	FUN_06045a7e
	.global FUN_060457e4
	.align 2
FUN_060457e4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.w	L2927,r0
	add	r13,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1619
	mov.l	L2928,r3
	jsr	@r3
	nop
	mov.l	L2929,r3
	jsr	@r3
	nop
	mov.l	@(48,r12),r9
	mov.l	@(8,r9),r0
	add	r9,r0
	mov	r0,r10
	mov.w	@(2,r9),r0
	mov	r0,r9
L1622:
	mov.w	L2927,r0
	add	r13,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1625
	nop
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L1625:
	mov.w	@r10,r8
	mov	r10,r11
	add	#2,r11
	mov.w	L2930,r1
	add	r13,r1
	mov.w	r8,@r1
	add	#4,r10
	mov.w	L2931,r1
	add	r13,r1
	mov.w	@r11,r0
	mov.w	r0,@r1
	extu.w	r8,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1627
	mov.l	L2932,r3
	jsr	@r3
	nop
	bra	L1628
	nop
L1627:
	mov.l	L2933,r3
	jsr	@r3
	nop
L1628:
	dt	r9
	bf	L1622
L1619:
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L2927:	.short	136
L2930:	.short	128
L2931:	.short	130
	.align 2
L2928:	.long	FUN_060463e4
L2929:	.long	func_0x06046602
L2932:	.long	func_0x06045a2c
L2933:	.long	FUN_06045a7e
	.global FUN_06045858
	.align 2
FUN_06045858:
	sts.l	pr,@-r15
	mov.l	L2934,r3
	jsr	@r3
	nop
	mov.w	L2934,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1630
	mov.l	L2935,r3
	jsr	@r3
	nop
	mov.l	L2936,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L1636
	mov	r0,r12
L1635:
	mov.w	L2934,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1638
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L1638:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2937,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2938,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L1640
	bra	L1637
	nop
L1640:
	mov.l	L2939,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1642
	nop
	lds.l	@r15+,pr
	rts
	nop
L1642:
L1636:
	bra	L1635
	nop
L1637:
	mov.l	L2940,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1636
L1630:
L1629:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2937:	.short	128
L2938:	.short	130
L2934:	.long	FUN_060459c4
L2935:	.long	func_0x06046478
L2936:	.long	func_0x06046602
L2939:	.long	FUN_0604670c
L2940:	.long	func_0x0604674e
	.global FUN_0604585c
	.align 2
FUN_0604585c:
	sts.l	pr,@-r15
	mov.w	L2941,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1645
	mov.l	L2942,r3
	jsr	@r3
	nop
	mov.l	L2943,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L1651
	mov	r0,r12
L1650:
	mov.w	L2941,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1653
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L1653:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2944,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2945,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L1655
	bra	L1652
	nop
L1655:
	mov.l	L2946,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1657
	nop
	lds.l	@r15+,pr
	rts
	nop
L1657:
L1651:
	bra	L1650
	nop
L1652:
	mov.l	L2947,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1651
L1645:
L1644:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2941:	.short	136
L2944:	.short	128
L2945:	.short	130
	.align 2
L2942:	.long	func_0x06046478
L2943:	.long	func_0x06046602
L2946:	.long	FUN_0604670c
L2947:	.long	func_0x0604674e
	.global FUN_060458da
	.align 2
FUN_060458da:
	sts.l	pr,@-r15
	mov.l	L2948,r3
	jsr	@r3
	nop
	mov.w	L2948,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1660
	mov.l	L2949,r3
	jsr	@r3
	nop
	mov.l	L2950,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L1666
	mov	r0,r12
L1665:
	mov.w	L2948,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1668
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L1668:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2951,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2952,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L1670
	bra	L1667
	nop
L1670:
	mov.l	L2953,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1672
	nop
	lds.l	@r15+,pr
	rts
	nop
L1672:
L1666:
	bra	L1665
	nop
L1667:
	mov.l	L2954,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1666
L1660:
L1659:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2951:	.short	128
L2952:	.short	130
L2948:	.long	FUN_060459c4
L2949:	.long	FUN_06046478
L2950:	.long	FUN_06046602
L2953:	.long	FUN_06045a2c
L2954:	.long	FUN_06045a7e
	.global FUN_060458de
	.align 2
FUN_060458de:
	sts.l	pr,@-r15
	mov.w	L2955,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1675
	mov.l	L2956,r3
	jsr	@r3
	nop
	mov.l	L2957,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	bra	L1681
	mov	r0,r12
L1680:
	mov.w	L2955,r0
	add	r8,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1683
	mov	r13,r0
	lds.l	@r15+,pr
	rts
	nop
L1683:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.w	L2958,r1
	add	r8,r1
	mov.w	r14,@r1
	add	#4,r11
	mov.w	L2959,r1
	add	r8,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt	L1685
	bra	L1682
	nop
L1685:
	mov.l	L2960,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1687
	nop
	lds.l	@r15+,pr
	rts
	nop
L1687:
L1681:
	bra	L1680
	nop
L1682:
	mov.l	L2961,r3
	jsr	@r3
	nop
	dt	r12
	bf	L1681
L1675:
L1674:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2955:	.short	136
L2958:	.short	128
L2959:	.short	130
	.align 2
L2956:	.long	FUN_06046478
L2957:	.long	FUN_06046602
L2960:	.long	FUN_06045a2c
L2961:	.long	FUN_06045a7e
	.global FUN_0604595a
	.align 2
FUN_0604595a:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L2962,r3
	jsr	@r3
	nop
	mov.l	@(0,r15),r0
	mov.w	L2962,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1690
	mov.l	L2963,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	mov	r0,r12
L1692:
	mov.l	@(0,r15),r0
	mov.w	L2962,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1695
	mov	r13,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1695:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r0
	mov.w	L2964,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r14,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L1699
	mov	#1,r14
L1698:
	mov	#0,r14
L1699:
	mov	r14,r0
	mov	r0,r8
	add	#4,r11
	mov.l	@(0,r15),r0
	mov.w	L2965,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.b	r8,r0
	tst	r0,r0
	bt	L1700
	mov.l	L2966,r3
	jsr	@r3
	nop
	mov.l	L2967,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L1701
	mov.l	L2968,r3
	jsr	@r3
	nop
	bra	L1701
	mov	r0,r4
L1700:
	mov.l	L2969,r3
	jsr	@r3
	nop
	mov.l	L2970,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L1704
	mov.l	L2971,r3
	jsr	@r3
	nop
L1704:
L1701:
	dt	r12
	bf	L1692
L1690:
L1689:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2964:	.short	128
L2965:	.short	130
L2962:	.long	FUN_060459c4
L2963:	.long	FUN_06046520
L2966:	.long	FUN_06045ac0
L2967:	.long	FUN_06045b10
L2968:	.long	FUN_06045b74
L2969:	.long	FUN_06045adc
L2970:	.long	FUN_06045b48
L2971:	.long	FUN_06045ba0
	.global FUN_0604595e
	.align 2
FUN_0604595e:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(0,r15),r0
	mov.w	L2972,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hs	r0,r13
	bt	L1707
	mov.l	L2973,r3
	jsr	@r3
	nop
	mov.l	@(48,r9),r12
	mov.l	@(8,r12),r0
	add	r12,r0
	mov	r0,r11
	mov.w	@(2,r12),r0
	mov	r0,r12
L1709:
	mov.l	@(0,r15),r0
	mov.w	L2972,r1
	add	r1,r0
	mov.l	@r0,r1
	mov	r1,r13
	shlr16	r13
	mov.l	@r0,r0
	extu.w	r0,r0
	cmp/hi	r13,r0
	bt	L1712
	mov	r13,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1712:
	mov.w	@r11,r14
	mov	r11,r10
	add	#2,r10
	mov.l	@(0,r15),r0
	mov.w	L2974,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r14,@r1
	extu.w	r14,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L1716
	mov	#1,r14
L1715:
	mov	#0,r14
L1716:
	mov	r14,r0
	mov	r0,r8
	add	#4,r11
	mov.l	@(0,r15),r0
	mov.w	L2975,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@r10,r0
	mov.w	r0,@r1
	extu.b	r8,r0
	tst	r0,r0
	bt	L1717
	mov.l	L2976,r3
	jsr	@r3
	nop
	mov.l	L2977,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L1718
	mov.l	L2978,r3
	jsr	@r3
	nop
	bra	L1718
	mov	r0,r4
L1717:
	mov.l	L2979,r3
	jsr	@r3
	nop
	mov.l	L2980,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L1721
	mov.l	L2981,r3
	jsr	@r3
	nop
L1721:
L1718:
	dt	r12
	bf	L1709
L1707:
L1706:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L2972:	.short	136
L2974:	.short	128
L2975:	.short	130
	.align 2
L2973:	.long	FUN_06046520
L2976:	.long	FUN_06045ac0
L2977:	.long	FUN_06045b10
L2978:	.long	FUN_06045b74
L2979:	.long	FUN_06045adc
L2980:	.long	FUN_06045b48
L2981:	.long	FUN_06045ba0
	.global FUN_060459c4
	.align 2
FUN_060459c4:
	sts.l	pr,@-r15
	add	#-12,r15
	mov	r4,r14
	mov.l	L2982,r0
	jsr	@r0
	mov	r5,r13
	mov.l	@(0,r15),r0
	mov.w	L2983,r1
	add	r1,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov.l	@(4,r15),r0
	add	#44,r0
	mov.l	r14,@r0
	mov.l	@(4,r15),r0
	add	#48,r0
	mov.l	r13,@r0
	mov.l	@r13,r12
	mov.l	@(0,r15),r0
	mov.w	L2984,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r12,r2
	shlr16	r2
	exts.w	r2,r2
	add	r2,r1
	mov.w	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L2985,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r12,r2
	exts.w	r2,r2
	add	r2,r1
	mov.w	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L2986,r1
	add	r1,r0
	mov	r0,r1
	mov.w	@(2,r13),r0
	mov.w	r0,@r1
	mov.l	@(4,r15),r0
	add	#40,r0
	mov	r13,r1
	mov.l	@(12,r13),r2
	add	r2,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.l	L2987,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r8
	mov	#3,r0
	mov.l	r0,@(8,r15)
L1724:
	mov.l	@(4,r14),r11
	mov.l	@(8,r14),r10
	mov	r14,r9
	add	#12,r9
	mov.l	@r14,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@r8
	mov	r11,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@(4,r8)
	mov	r10,r0
	shll2	r0
	shll2	r0
	shll2	r0
	mov.l	r0,@(8,r8)
	add	#16,r14
	mov.l	@r9,r0
	mov.l	r0,@(12,r8)
	mov.l	@(8,r15),r0
	add	#-1,r0
	mov.l	r0,@(8,r15)
	add	#16,r8
	mov.l	@(8,r15),r0
	tst	r0,r0
	bf	L1724
	add	#12,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L2983:	.short	148
L2984:	.short	168
L2985:	.short	170
L2986:	.short	142
L2982:	.long	FUN_06045698
L2987:	.long	DAT_06045b0c
	.global FUN_06045a2c
	.align 2
FUN_06045a2c:
	sts.l	pr,@-r15
	add	#-20,r15
	mov	r15,r9
	mov.l	L2988,r3
	jsr	@r3
	add	#0,r9
	mov.l	@(4,r8),r0
	mov.l	@(16,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	@(8,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L1728
	mov.l	@(4,r15),r0
	mov.w	L2989,r1
	add	r1,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1730
	mov.l	L2990,r3
	jsr	@r3
	nop
	mov	r9,r10
L1730:
	mov.l	L2991,r3
	jsr	@r3
	nop
	mov.l	L2992,r3
	mov.l	@(16,r15),r0
	mov.l	@(12,r15),r0
	mov.l	@(8,r15),r0
	mov.l	@r0,r13
	mov.l	@r0,r12
	mov.l	@r0,r11
	mov.l	@r8,r0
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov.l	L2992,r3
	jsr	@r3
	mov.l	r11,@(24,r10)
	mov.l	@(4,r15),r0
	mov.w	L2993,r1
	add	r1,r0
	mov	#4,r1
	mov.l	L2994,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L2988,r1
	add	r1,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov	r14,r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L1728:
L1727:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2989:	.short	128
L2993:	.short	155
L2988:	.long	FUN_06045ac0
L2990:	.long	FUN_06045c9c
L2991:	.long	FUN_06045e44
L2992:	.long	FUN_06045d04
L2994:	.long	FUN_06045e06
	.global FUN_06045a7e
	.align 2
FUN_06045a7e:
	sts.l	pr,@-r15
	mov.l	L2995,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L1733
	mov.w	L2996,r0
	add	r10,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1735
	mov.l	L2997,r3
	jsr	@r3
	nop
L1735:
	mov.l	L2998,r3
	jsr	@r3
	nop
	mov.l	L2999,r3
	jsr	@r3
	nop
	mov.l	L3000,r3
	jsr	@r3
	nop
	mov.w	L3000,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L3001,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.w	L2995,r0
	add	r10,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov	r14,r0
	lds.l	@r15+,pr
	rts
	nop
L1733:
L1732:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L2996:	.short	128
	.align 2
L2995:	.long	func_0x06045adc
L2997:	.long	FUN_06045c9c
L2998:	.long	FUN_06045e44
L2999:	.long	FUN_06045c3c
L3000:	.long	FUN_06045d80
L3001:	.long	FUN_06045e06
	.global FUN_06045ac0
	.align 2
FUN_06045ac0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L3002,r0
	add	r10,r0
	mov.w	@r0,r0
	mov	#32,r1
	and	r1,r0
	tst	r0,r0
	bf	L1738
	mov.w	L3002,r0
	add	r10,r0
	mov.w	@r0,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L1738:
	mov	r12,r0
	add	#10,r0
	mov.w	@r0,r14
	mov	r12,r0
	add	#12,r0
	mov.w	@r0,r13
	mov	r11,r1
	add	#64,r1
	mov.w	@(8,r12),r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r0
	add	#64,r0
L1737:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3002:	.short	128
	.align 2
	.global FUN_06045adc
	.align 2
FUN_06045adc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.w	L3003,r0
	add	r10,r0
	mov.w	@r0,r0
	mov	#32,r1
	and	r1,r0
	tst	r0,r0
	bf	L1741
	mov.w	L3003,r0
	add	r10,r0
	mov.w	@r0,r0
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L1741:
	mov	r12,r0
	add	#8,r0
	mov.w	@r0,r14
	mov	r12,r0
	add	#10,r0
	mov.w	@r0,r13
	mov	r11,r1
	add	#64,r1
	mov.w	@(6,r12),r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#68,r1
	mov	r14,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r1
	add	#72,r1
	mov	r13,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r11,r0
	add	#64,r0
L1740:
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3003:	.short	128
	.align 2
	.global FUN_06045af4
	.align 2
FUN_06045af4:
	mov	r5,r0
	add	#2,r0
	mov.w	@r0,r7
	mov.w	@(4,r5),r0
	mov	r0,r6
	mov	r4,r1
	add	#64,r1
	mov.w	@r5,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r4,r1
	add	#68,r1
	mov	r7,r0
	shll2	r0
	mov.l	r0,@r1
	mov	r4,r1
	add	#72,r1
	mov	r6,r0
	shll2	r0
	rts
	mov.l	r0,@r1
	.global FUN_06045b10
	.align 2
FUN_06045b10:
	add	#-4,r15
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1745
	mov	#2,r0
	mov	r7,r4
	and	r0,r4
	mov.b	@(7,r8),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1747
	mov	#2,r0
	mov	r7,r6
	and	r0,r6
	mov.b	@(7,r9),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1749
	mov	#2,r0
	mov	r7,r5
	and	r0,r5
	mov.b	@(7,r10),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1751
	mov	#2,r0
	mov	r7,r1
	and	r0,r1
	mov	r4,r0
	shll	r0
	or	r6,r0
	shll	r0
	or	r5,r0
	shll	r0
	mov	r1,r0
	or	r0,r0
	add	#4,r15
	rts
	nop
L1751:
L1749:
L1747:
L1745:
L1744:
	add	#4,r15
	rts
	mov	r7,r0
	.global FUN_06045b48
	.align 2
FUN_06045b48:
	mov.b	@(7,r9),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1754
	mov	#2,r0
	mov	r7,r5
	and	r0,r5
	mov.b	@(7,r10),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1756
	mov	#2,r0
	mov	r7,r6
	and	r0,r6
	mov.b	@(7,r4),r0
	mov	r0,r7
	mov	#1,r0
	mov	r7,r1
	and	r0,r1
	tst	r1,r1
	bf	L1758
	mov	#2,r0
	mov	r7,r1
	and	r0,r1
	mov	r5,r0
	shll	r0
	or	r6,r0
	shll	r0
	mov	r1,r0
	or	r0,r0
	rts
	nop
L1758:
L1756:
L1754:
L1753:
	rts
	mov	r7,r0
	.global FUN_06045b74
	.align 2
FUN_06045b74:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r0
	extu.b	r10,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L1761
	mov.l	L3004,r0
	mov	r13,r1
	shll2	r1
	add	r0,r1
	mov.w	@r1,r1
	shll2	r1
	mov	r1,r3
	add	r0,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L1761:
	mov.w	L3004,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1763
	mov.l	L3005,r3
	jsr	@r3
	nop
L1763:
	mov.l	L3006,r3
	jsr	@r3
	nop
	mov	r11,r0
	add	#4,r0
	mov.l	@r0,r12
	cmp/ge	r12,r14
	bt	L1765
	mov.w	L3007,r0
	add	r9,r0
	mov.l	L3008,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3009,r3
	jsr	@r3
	nop
	mov.w	L3007,r4
	add	r9,r4
	mov.l	L3010,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3011,r0
	add	r9,r0
	mov.w	@r0,r1
	mov.w	L3009,r2
	add	r9,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1765:
L1760:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L3007:	.short	156
L3011:	.short	136
L3004:	.long	DAT_06045b80
L3005:	.long	FUN_06045c9c
L3006:	.long	FUN_06045d04
L3008:	.long	FUN_06045e44
L3009:	.long	FUN_0604698c
L3010:	.long	FUN_06045e06
	.global FUN_06045ba0
	.align 2
FUN_06045ba0:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	#1,r0
	extu.b	r10,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L1768
	mov.l	L3012,r0
	mov	r13,r1
	shll2	r1
	add	r0,r1
	mov.w	@r1,r1
	shll2	r1
	mov	r1,r3
	add	r0,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L1768:
	mov.w	L3012,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1770
	mov.l	L3013,r3
	jsr	@r3
	nop
L1770:
	mov.l	L3014,r3
	jsr	@r3
	nop
	mov	r11,r0
	add	#4,r0
	mov.l	@r0,r12
	cmp/ge	r12,r14
	bt	L1772
	mov.w	L3015,r0
	add	r9,r0
	mov.l	L3016,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3017,r3
	jsr	@r3
	nop
	mov.w	L3015,r4
	add	r9,r4
	mov.l	L3018,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3019,r0
	add	r9,r0
	mov.w	@r0,r1
	mov.w	L3017,r2
	add	r9,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1772:
L1767:
	lds.l	@r15+,pr
	rts
	mov	r12,r0
	.align 2
L3015:	.short	156
L3019:	.short	136
L3012:	.long	DAT_06045bac
L3013:	.long	FUN_06045c9c
L3014:	.long	FUN_06045d80
L3016:	.long	FUN_06045e44
L3017:	.long	FUN_06046a20
L3018:	.long	FUN_06045e06
	.global FUN_06045bc4
	.align 2
FUN_06045bc4:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L3020,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1775
	mov.l	L3021,r3
	jsr	@r3
	nop
L1775:
	mov.l	L3022,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L1777
	mov.w	L3023,r0
	add	r11,r0
	mov.l	L3024,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3025,r3
	jsr	@r3
	nop
	mov.w	L3023,r4
	add	r11,r4
	mov.l	L3026,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3027,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L3025,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1777:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L3020:	.short	128
L3023:	.short	156
L3027:	.short	136
	.align 2
L3021:	.long	FUN_06045c9c
L3022:	.long	FUN_06045d04
L3024:	.long	FUN_06045e44
L3025:	.long	FUN_0604698c
L3026:	.long	FUN_06045e06
	.global FUN_06045bc6
	.align 2
FUN_06045bc6:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L3028,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1780
	mov.l	L3029,r3
	jsr	@r3
	nop
L1780:
	mov.l	L3030,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L1782
	mov.w	L3031,r0
	add	r11,r0
	mov.l	L3032,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3033,r3
	jsr	@r3
	nop
	mov.w	L3031,r4
	add	r11,r4
	mov.l	L3034,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3035,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L3033,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1782:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L3028:	.short	128
L3031:	.short	156
L3035:	.short	136
	.align 2
L3029:	.long	FUN_06045c9c
L3030:	.long	FUN_06045d04
L3032:	.long	FUN_06045e44
L3033:	.long	FUN_0604698c
L3034:	.long	FUN_06045e06
	.global FUN_06045c00
	.align 2
FUN_06045c00:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L3036,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1785
	mov.l	L3037,r3
	jsr	@r3
	nop
L1785:
	mov.l	L3038,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L1787
	mov.w	L3039,r0
	add	r11,r0
	mov.l	L3040,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3041,r3
	jsr	@r3
	nop
	mov.w	L3039,r4
	add	r11,r4
	mov.l	L3042,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3043,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L3041,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1787:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L3036:	.short	128
L3039:	.short	156
L3043:	.short	136
	.align 2
L3037:	.long	FUN_06045c9c
L3038:	.long	FUN_06045d80
L3040:	.long	FUN_06045e44
L3041:	.long	FUN_06046a20
L3042:	.long	FUN_06045e06
	.global FUN_06045c02
	.align 2
FUN_06045c02:
	sts.l	pr,@-r15
	mov	r4,r14
	mov.w	L3044,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1790
	mov.l	L3045,r3
	jsr	@r3
	nop
L1790:
	mov.l	L3046,r3
	jsr	@r3
	nop
	mov	r12,r0
	add	#4,r0
	mov.l	@r0,r13
	cmp/ge	r13,r14
	bt	L1792
	mov.w	L3047,r0
	add	r11,r0
	mov.l	L3048,r3
	jsr	@r3
	mov.l	r14,@r0
	mov.l	L3049,r3
	jsr	@r3
	nop
	mov.w	L3047,r4
	add	r11,r4
	mov.l	L3050,r3
	jsr	@r3
	mov.l	@r4,r4
	mov.w	L3051,r0
	add	r11,r0
	mov.w	@r0,r1
	mov.w	L3049,r2
	add	r11,r2
	mov.b	@r2,r2
	mov	r1,r1
	add	r2,r1
	mov.w	r1,@r0
L1792:
	lds.l	@r15+,pr
	rts
	mov	r13,r0
	.align 2
L3044:	.short	128
L3047:	.short	156
L3051:	.short	136
	.align 2
L3045:	.long	FUN_06045c9c
L3046:	.long	FUN_06045d80
L3048:	.long	FUN_06045e44
L3049:	.long	FUN_06046a20
L3050:	.long	FUN_06045e06
	.global FUN_06045c3c
	.align 2
FUN_06045c3c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	r4,r14
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	@(20,r15),r0
	mov.l	@r0,r9
	mov	#14,r0
	mov	r10,r1
	and	r0,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#10,r1
	cmp/gt	r1,r0
	bt	L1805
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L1798 - Lswt0
	.short	L1795 - Lswt0
	.short	L1799 - Lswt0
	.short	L1795 - Lswt0
	.short	L1800 - Lswt0
	.short	L1795 - Lswt0
	.short	L1801 - Lswt0
	.short	L1795 - Lswt0
	.short	L1802 - Lswt0
	.short	L1795 - Lswt0
	.short	L1803 - Lswt0
L1805:
	mov.l	@(0,r15),r0
	cmp/eq	#14,r0
	bt	L1804
	bra	L1795
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	@(8,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(24,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	@(24,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r9,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov.l	r8,@(20,r11)
	mov	r11,r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(16,r15),r0
	mov.l	@r0,r8
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(28,r15)
	mov.l	r9,@(12,r11)
	mov.l	r8,@(16,r11)
	mov	r11,r0
	add	#20,r0
	mov.l	@(28,r15),r1
	mov.l	r1,@r0
	add	#24,r0
	mov.l	r9,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	mov	r14,r0
	add	#28,r0
	mov	#14,r1
	mov	r10,r2
	and	r1,r2
	mov.l	r2,@r0
	mov	r9,r0
	exts.b	r0,r0
	mov.b	r0,@r13
	mov.l	L3052,r0
	jsr	@r0
	nop
L1804:
	mov.l	L3052,r0
	jsr	@r0
	nop
L1795:
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L1806
	mov.l	L3052,r0
	jsr	@r0
	nop
L1806:
	mov.l	L3052,r0
	jsr	@r0
	nop
L1794:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3052:	.long	halt_baddata
	.global FUN_06045c9c
	.align 2
FUN_06045c9c:
	sts.l	macl,@-r15
	add	#-12,r15
	mov	r9,r0
	add	#2,r0
	mov.w	@r0,r14
	mov.w	@(2,r8),r0
	mov	r0,r1
	mov	r14,r0
	sub	r0,r1
	mov	r1,r0
	exts.w	r0,r1
	mov.w	@r9,r0
	mov	r0,r2
	mov.w	@r4,r0
	sub	r0,r2
	mov	r2,r0
	exts.w	r0,r0
	mul.l	r0,r1
	sts	macl,r0
	mov.l	r0,@(4,r15)
	mov	r4,r0
	add	#2,r0
	mov.w	@r0,r7
	mov	r5,r1
	add	#-2,r1
	mov.w	@r8,r0
	mov	r0,r2
	mov.w	@r9,r0
	sub	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov	r5,r1
	add	#-4,r1
	mov	r7,r2
	mov	r14,r0
	sub	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov	r5,r0
	add	#-4,r0
	mov.l	@r0,r0
	exts.w	r0,r0
	mov	r5,r1
	add	#-2,r1
	mov.l	@r1,r1
	exts.w	r1,r1
	mul.l	r1,r0
	sts	macl,r0
	mov.l	r0,@(0,r15)
	mov	#-1,r0
	mov.l	@(0,r15),r1
	cmp/ge	r1,r0
	bf/s	L1812
	mov	#1,r14
L1811:
	mov	#0,r14
L1812:
	mov.l	@(4,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1814
	mov	#1,r7
L1813:
	mov	#0,r7
L1814:
	mov	r14,r6
	add	r7,r6
	mov.l	@(4,r15),r0
	mov.l	@(0,r15),r1
	add	r1,r0
	mov.l	r0,@(0,r15)
	mov	#1,r0
	mov.l	@(8,r15),r0
	shlr	r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L1815
	mov.l	@(0,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1822
	mov	#1,r14
L1821:
	mov	#0,r14
L1822:
	mov.l	@(4,r15),r0
	mov	#0,r1
	cmp/ge	r1,r0
	bf/s	L1824
	mov	#1,r7
L1823:
	mov	#0,r7
L1824:
	mov	r14,r0
	add	r7,r0
	exts.b	r0,r0
	cmp/eq	#1,r0
	bf	L1816
	exts.b	r6,r0
	tst	r0,r0
	bf	L1825
	mov.l	L3053,r0
	bra	L1816
	mov.l	r0,@(0,r15)
L1825:
	exts.b	r6,r0
	cmp/eq	#2,r0
	bf	L1816
	mov.l	L3054,r0
	bra	L1816
	mov.l	r0,@(0,r15)
L1815:
	mov.l	@(0,r15),r0
	mov.l	@(4,r15),r1
	cmp/ge	r1,r0
	bf/s	L1831
	mov	#1,r14
L1830:
	mov	#0,r14
L1831:
	add	r14,r0
	mov.l	r0,@(0,r15)
L1816:
	add	#12,r15
	lds.l	@r15+,macl
	rts
	mov.l	@(0,r15),r0
	.align 2
L3053:	.short	2147483647
L3054:	.short	-2147483648
	.global FUN_06045ccc
	.align 2
FUN_06045ccc:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	L3055,r14
	tst	r4,r4
	bt	L1833
	mov.l	L3056,r14
L1833:
	mov	#5,r11
	mov.l	L3057,r0
	mov.l	@r0,r12
L1835:
	mov	r14,r13
	mov.w	@r13,r0
	mov.w	r0,@r12
	add	#-1,r11
	add	#2,r12
	mov	r13,r14
	add	#2,r14
	tst	r11,r11
	bf	L1835
	mov.l	L3058,r0
	mov.l	@r0,r1
	mov.w	@(2,r13),r0
	mov.w	r0,@r1
	mov	r13,r0
	add	#4,r0
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3055:	.long	DAT_06045cec
L3056:	.long	DAT_06045cf8
L3057:	.long	PTR_DAT_06045de0
L3058:	.long	PTR_DAT_06045de4
	.global FUN_06045d04
	.align 2
FUN_06045d04:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-8,r15
	mov.l	@(4,r15),r0
	add	#4,r0
	mov.l	@r0,r11
	mov.l	@(4,r8),r12
	mov.l	@(4,r10),r13
	mov	#14,r0
	mov	r14,r1
	and	r0,r1
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L1839
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L1852 - Lswt0
	.short	L1839 - Lswt0
	.short	L1853 - Lswt0
	.short	L1839 - Lswt0
	.short	L1842 - Lswt0
	.short	L1839 - Lswt0
	.short	L1849 - Lswt0
	.short	L1839 - Lswt0
	.short	L1850 - Lswt0
	.short	L1839 - Lswt0
	.short	L1851 - Lswt0
	.short	L1839 - Lswt0
	.short	L1852 - Lswt0
	.short	L1839 - Lswt0
	.short	L1853 - Lswt0
	bra	L1839
	nop
	cmp/ge	r11,r13
	bt	L1843
	mov	r11,r13
L1843:
	cmp/ge	r12,r13
	bt	L1845
	mov	r12,r13
L1845:
	mov.l	@(4,r9),r0
	cmp/ge	r0,r13
	bt	L1840
	mov.l	L3059,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L3059,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L3060,r3
	jsr	@r3
	nop
	mov.l	L3061,r0
	mov.l	@r0,r0
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L3059,r0
	add	r9,r0
	mov	r13,r1
	mov.b	r1,@r0
	mov.l	L3062,r0
	jsr	@r0
	nop
	mov.l	L3059,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	cmp/gt	r13,r11
	bt	L1854
	mov	r11,r13
L1854:
	cmp/gt	r13,r12
	bt	L1856
	mov	r12,r13
L1856:
	mov.l	@(4,r9),r0
	cmp/gt	r13,r0
	bt	L1858
	mov.l	L3059,r0
	nop
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
L1858:
L1839:
L1840:
	mov.l	L3059,r0
L1838:
	add	#8,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3059:	.long	switchD_06045d12__switchdataD_06045df0
L3060:	.long	FUN_06045D3C
L3061:	.long	DAT_06045de8
L3062:	.long	halt_baddata
	.global FUN_06045D3C
	.align 2
FUN_06045D3C:
	cmp/ge	r7,r4
	bt	L1861
	mov	r7,r4
L1861:
	cmp/ge	r6,r4
	bt	L1863
	mov	r6,r4
L1863:
	cmp/ge	r5,r4
L1860:
	rts
	nop
	.global FUN_06045D6A
	.align 2
FUN_06045D6A:
	sts.l	pr,@-r15
	mov.l	L3063,r3
	jsr	@r3
	nop
	mov.l	L3064,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r0,r0
	.align 2
L3063:	.long	caseD_4
L3064:	.long	DAT_06045de8
	.global FUN_06045d80
	.align 2
FUN_06045d80:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	add	#-16,r15
	mov.l	@(8,r15),r0
	add	#4,r0
	mov.l	@r0,r9
	mov	#14,r0
	mov	r14,r1
	and	r0,r1
	mov.l	L3065,r0
	add	r1,r0
	mov.w	@r0,r0
	mov	r0,r13
	mov.l	@(4,r8),r10
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L1869
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L1872 - Lswt0
	.short	L1869 - Lswt0
	.short	L1873 - Lswt0
	.short	L1869 - Lswt0
	.short	L1878 - Lswt0
	.short	L1869 - Lswt0
	.short	L1883 - Lswt0
	.short	L1869 - Lswt0
	.short	L1884 - Lswt0
	.short	L1869 - Lswt0
	.short	L1885 - Lswt0
	.short	L1869 - Lswt0
	.short	L1886 - Lswt0
	.short	L1869 - Lswt0
	.short	L1887 - Lswt0
	bra	L1869
	nop
	mov.l	L3066,r0
	mov.l	@r0,r0
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3066:	.short	-2147483648
	mov	r9,r0
	mov	r10,r1
	cmp/gt	r1,r0
	bt	L1874
	mov	r9,r10
L1874:
	mov.l	@(12,r15),r0
	add	#4,r0
	mov.l	@r0,r0
	mov	r10,r1
	cmp/gt	r1,r0
	bt	L1870
	mov.l	L3065,r0
	nop
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov	r10,r0
	mov	r9,r1
	cmp/ge	r1,r0
	bt	L1879
	mov	r9,r10
L1879:
	mov	r10,r0
	mov.l	@(12,r15),r1
	add	#4,r1
	mov.l	@r1,r1
	cmp/ge	r1,r0
	bt	L1870
	mov.l	L3065,r0
	nop
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	mov.l	L3065,r0
	nop
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3065:	.short	2147483647
	mov.l	L3067,r3
	jsr	@r3
	nop
	mov.l	L3068,r0
	mov.l	@r0,r0
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3068:	.short	156
	mov.l	@(4,r15),r0
	mov.w	L3069,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3070,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3071,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3072,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3073,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3074,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3075,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3067,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3076,r1
	add	r1,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#120,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#92,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#68,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#44,r0
	mov.l	L3084,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	add	#16,r0
	mov.l	L3084,r1
	mov.l	L3077,r0
	mov.l	r1,@r0
	jsr	@r0
	nop
	mov.l	L3078,r1
	add	r9,r1
	mov	#93,r0
	mov.b	r0,@r1
	mov.l	L3079,r1
	add	r9,r1
	mov	#-4,r0
	mov.b	r0,@r1
	mov.l	L3084,r0
	mov	r0,r1
	mov.b	@r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3084,r1
	mov.l	L3081,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L3082,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3084,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov	r12,r13
	add	#1,r13
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r12,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r11,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r1
	mov.l	L3081,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L3082,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov	r11,r13
	add	#1,r13
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r11,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r10,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r1
	mov.l	L3081,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L3082,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L3080,r1
	mov.w	r1,@r0
	mov.l	L3089,r0
	mov	r13,r1
	extu.b	r1,r1
	add	r1,r0
	mov.w	L3086,r1
	mov.w	r1,@r0
	mov	r10,r13
	add	#1,r13
	mov.l	L3089,r0
	mov	r0,r1
	mov.b	@r10,r0
	add	r0,r1
	mov	r1,r0
	mov.w	L3086,r1
	mov.w	r1,@r0
	mov.l	L3089,r1
	mov.l	L3087,r2
	mov	r13,r2
	and	r2,r2
	shlr8	r2
	extu.b	r13,r3
	shll8	r3
	or	r3,r2
	mov.l	L3088,r3
	mov	r13,r0
	and	r3,r0
	or	r0,r2
	mov	r1,r0
	add	r2,r0
	mov.w	L3086,r1
	mov.l	L3085,r0
	mov.w	r1,@r0
	jsr	@r0
	nop
	mov.l	@(4,r15),r0
	add	#18,r0
	mov.l	L3083,r1
	mov.l	L3085,r0
	mov.w	r1,@r0
	jsr	@r0
	nop
L1869:
L1870:
	mov.l	L3090,r0
L1868:
	add	#16,r15
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3069:	.short	356
L3070:	.short	328
L3071:	.short	300
L3072:	.short	276
L3073:	.short	248
L3074:	.short	220
L3075:	.short	196
L3076:	.short	144
L3078:	.short	100949500
L3079:	.short	100949501
L3080:	.short	24060
L3081:	.short	65280
L3082:	.short	-65536
L3083:	.short	42160
L3086:	.short	24060
L3087:	.short	65280
L3088:	.short	-65536
	.align 2
L3067:	.long	FUN_06045DAA
L3077:	.long	halt_baddata
L3084:	.long	switchD_06045d8c__switchdataD_06045dfc
L3085:	.long	halt_baddata
L3089:	.long	switchD_06045d8c__switchdataD_06045dfc
L3090:	.long	switchD_06045d8c__switchdataD_06045dfc
	.global FUN_06045DAA
	.align 2
FUN_06045DAA:
	cmp/ge	r6,r4
	bt	L1889
	mov	r6,r4
L1889:
	cmp/ge	r5,r4
L1888:
	rts
	nop
	.global FUN_06045DCC
	.align 2
FUN_06045DCC:
	sts.l	pr,@-r15
	mov.l	L3091,r3
	jsr	@r3
	nop
	mov.l	L3092,r0
	lds.l	@r15+,pr
	rts
	mov.l	@r0,r0
	.align 2
L3091:	.long	caseD_4
L3092:	.long	DAT_06045de8
	.global FUN_06045e06
	.align 2
FUN_06045e06:
	mov.l	@(32,r5),r0
	mov	r4,r1
	shlr8	r1
	shlr2	r1
	mov.w	L3093,r2
	and	r2,r1
	add	r1,r0
	mov	r0,r6
	mov.w	@r6,r0
	tst	r0,r0
	bt	L1895
	mov.l	L3094,r0
	mov.l	@r0,r1
	mov.w	@(2,r6),r0
	shll2	r0
	shll	r0
	add	r0,r1
	mov	r1,r1
	add	#2,r1
	mov.w	r7,@r1
	mov.w	L3095,r0
	add	r11,r0
	mov.b	@r0,r0
	mov	r0,r1
	add	#-4,r1
	exts.w	r7,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(2,r6)
	rts
	nop
L1895:
	mov.w	r7,@r6
	mov.w	L3095,r0
	add	r11,r0
	mov.b	@r0,r0
	mov	r0,r1
	add	#-4,r1
	exts.w	r7,r0
	add	r0,r1
	mov	r1,r0
L1894:
	rts
	mov.w	r0,@(2,r6)
	.align 2
L3093:	.short	-8
L3095:	.short	155
L3094:	.long	DAT_06045e40
	.global FUN_06045e44
	.align 2
FUN_06045e44:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	L3096,r0
	mov.l	@r0,r0
	mov	r14,r1
	shll2	r1
	shll	r1
	add	r1,r0
	mov	r0,r10
	mov.w	L3097,r0
	add	r8,r0
	mov.w	@r0,r0
	shlr2	r0
	shlr2	r0
	mov	#30,r1
	and	r1,r0
	mov.l	r0,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#12,r1
	cmp/eq	#12,r0
	bt	L1905
	cmp/gt	r1,r0
	bt	L1908
	mov.l	@(0,r15),r0
	mov	#8,r1
	cmp/gt	r1,r0
	bt	L1898
L1908:
	mov.l	@(0,r15),r0
	mov	#24,r1
	cmp/gt	r1,r0
	bt	L1909
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L1906 - Lswt0
	.short	L1898 - Lswt0
	.short	L1906 - Lswt0
	.short	L1898 - Lswt0
	.short	L1902 - Lswt0
	.short	L1898 - Lswt0
	.short	L1902 - Lswt0
	.short	L1898 - Lswt0
	.short	L1906 - Lswt0
L1909:
	mov.l	@(0,r15),r0
	cmp/eq	#28,r0
	bt	L1899
	bra	L1898
	nop
L1898:
	mov.w	L3098,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L3099,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L3100,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L3101,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L3102,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L3103,r0
	mov.l	@r0,r1
	exts.w	r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r10)
	mov.w	L3098,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L3099,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L3100,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L3104,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L3102,r3
	jsr	@r3
	mov.l	@(44,r9),r4
	mov.l	L3103,r0
	mov.l	@r0,r1
	exts.w	r11,r0
	add	r0,r1
	mov	r1,r0
	bra	L1899
	mov.w	r0,@(28,r10)
	mov.w	L3098,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L3099,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L3100,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L3104,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.l	L3105,r3
	jsr	@r3
	mov.w	r0,@(4,r10)
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1905:
	mov.l	L3105,r3
	jsr	@r3
	nop
	bra	L1899
	nop
	mov.w	L3109,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r10)
	mov.w	L3110,r0
	add	r8,r0
	mov.w	@r0,r0
	mov.w	r0,@r10
	mov.w	L3111,r0
	add	r8,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L3106,r1
	mov.l	@r1,r1
	or	r1,r0
	mov.w	r0,@(4,r10)
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1899:
	mov.l	@(40,r9),r1
	mov.w	L3109,r0
	add	r8,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r12
	mov.w	L3111,r0
	add	r8,r0
	mov.l	@r0,r0
	mov.l	@r12,r1
	or	r1,r0
	mov.l	r0,@(4,r10)
	mov.l	@(4,r12),r0
	mov.l	r0,@(8,r10)
	mov.l	L3107,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L3108,r0
	add	r8,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
L1897:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r10
	.align 2
L3097:	.short	128
L3098:	.short	130
L3099:	.short	146
L3100:	.short	148
L3108:	.short	128
L3109:	.short	130
L3110:	.short	146
L3111:	.short	148
L3096:	.long	DAT_06045f20
L3101:	.long	DAT_06045f16
L3102:	.long	FUN_06045fc0
L3103:	.long	DAT_06045f1a
L3104:	.long	DAT_06045f1c
L3105:	.long	FUN_06045f46
L3106:	.long	DAT_06045f18
L3107:	.long	DAT_06045f26
	.global FUN_06045EA8
	.align 2
FUN_06045EA8:
	sts.l	pr,@-r15
	mov.l	L3112,r3
	jsr	@r3
	mov.l	@(44,r12),r4
	mov.l	L3113,r0
	mov.l	@r0,r1
	exts.w	r14,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r13)
	mov.w	L3114,r0
	add	r11,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r13)
	mov.w	L3115,r0
	add	r11,r0
	mov.w	@r0,r0
	mov.w	r0,@r13
	mov.w	L3116,r0
	add	r11,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.l	L3117,r1
	mov.l	@r1,r1
	or	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@(4,r13)
	.align 2
L3114:	.short	130
L3115:	.short	146
L3116:	.short	148
	.align 2
L3112:	.long	FUN_06045fc0
L3113:	.long	DAT_06045f1a
L3117:	.long	DAT_06045f1c
	.global FUN_06045EC8
	.align 2
FUN_06045EC8:
	mov.l	@(40,r5),r1
	mov.w	L3118,r0
	add	r4,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r7
	mov.w	L3119,r0
	add	r4,r0
	mov.l	@r0,r0
	mov.l	@r7,r1
	or	r1,r0
	mov.l	r0,@(4,r6)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r6)
	mov.l	L3120,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L3121,r0
	add	r4,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	rts
	mov.w	r0,@r6
	.align 2
L3118:	.short	130
L3119:	.short	148
L3121:	.short	128
	.align 2
L3120:	.long	DAT_06045f26
	.global FUN_06045EE8
	.align 2
FUN_06045EE8:
	sts.l	pr,@-r15
	mov.l	L3122,r3
	jsr	@r3
	mov.l	@(44,r11),r4
	mov.l	L3123,r0
	mov.l	@r0,r1
	exts.w	r13,r0
	add	r0,r1
	mov	r1,r0
	mov.w	r0,@(28,r12)
	mov.l	@(40,r11),r1
	mov.w	L3122,r0
	add	r10,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.w	L3123,r0
	add	r10,r0
	mov.l	@r0,r0
	mov.l	@r14,r1
	or	r1,r0
	mov.l	r0,@(4,r12)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r12)
	mov.l	L3124,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L3125,r0
	add	r10,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r12
	.align 2
L3125:	.short	128
	.align 2
L3122:	.long	FUN_06045fc0
L3123:	.long	DAT_06045f1a
L3124:	.long	DAT_06045f26
	.global FUN_06045F0C
	.align 2
FUN_06045F0C:
	sts.l	pr,@-r15
	mov.l	L3126,r3
	jsr	@r3
	nop
	mov.l	@(40,r12),r1
	mov.w	L3126,r0
	add	r11,r0
	mov.w	@r0,r0
	add	r0,r1
	mov	r1,r0
	mov	r0,r14
	mov.w	L3127,r0
	add	r11,r0
	mov.l	@r0,r0
	mov.l	@r14,r1
	or	r1,r0
	mov.l	r0,@(4,r13)
	mov.l	@(4,r14),r0
	mov.l	r0,@(8,r13)
	mov.l	L3128,r0
	mov.l	@r0,r0
	mov	r0,r1
	mov.w	L3129,r0
	add	r11,r0
	mov.b	@r0,r0
	exts.w	r0,r0
	mov	#48,r2
	and	r2,r0
	or	r0,r1
	mov	r1,r0
	lds.l	@r15+,pr
	rts
	mov.w	r0,@r13
	.align 2
L3127:	.short	148
L3129:	.short	128
L3126:	.long	FUN_06045f46
L3128:	.long	DAT_06045f26
	.global FUN_06045f46
	.align 2
FUN_06045f46:
	sts.l	pr,@-r15
	sts.l	macl,@-r15
	add	#-44,r15
	mov	r4,r14
	mov	r5,r13
	mov	r6,r12
	mov	r7,r11
	mov.l	@(0,r15),r0
	mov.w	L3130,r1
	add	r1,r0
	mov.w	@r0,r8
	mov	r11,r1
	add	#28,r1
	mov.w	r8,@r1
	mov.l	@(0,r15),r0
	mov.w	L3130,r1
	add	r1,r0
	mov	r0,r1
	mov	r8,r0
	add	#1,r0
	mov.w	r0,@r1
	mov	r8,r0
	shll2	r0
	shll	r0
	mov.l	L3131,r1
	mov.l	@r1,r1
	add	r1,r0
	mov.l	r0,@(36,r15)
	mov.l	@(0,r15),r0
	mov.w	L3132,r1
	add	r1,r0
	mov.b	@r0,r0
	mov	#14,r1
	and	r1,r0
	mov.l	r0,@(32,r15)
	mov.l	@(20,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(32,r15),r0
	mov	#14,r1
	cmp/gt	r1,r0
	bt	L1915
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
Lswt0:
	.short	L1917 - Lswt0
	.short	L1915 - Lswt0
	.short	L1918 - Lswt0
	.short	L1915 - Lswt0
	.short	L1919 - Lswt0
	.short	L1915 - Lswt0
	.short	L1920 - Lswt0
	.short	L1915 - Lswt0
	.short	L1921 - Lswt0
	.short	L1915 - Lswt0
	.short	L1922 - Lswt0
	.short	L1915 - Lswt0
	.short	L1923 - Lswt0
	.short	L1915 - Lswt0
	.short	L1925 - Lswt0
	bra	L1915
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(8,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r9
	mov.l	@(36,r15),r1
	mov	r9,r0
	mov.w	r0,@(4,r1)
	mov.l	@(36,r15),r1
	mov.w	r0,@(6,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(36,r15),r1
	mov.w	r9,@r1
	mov.l	@(36,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(36,r15),r1
	mov.l	@(16,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(2,r1)
	mov.l	@(36,r15),r1
	mov.l	@(12,r15),r0
	add	#8,r0
	mov.w	@r0,r0
	mov.w	r0,@(4,r1)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	@(32,r15),r0
	add	#20,r0
	mov.l	@(24,r15),r1
	mov.l	L3133,r0
	mov.l	r1,@r0
	jsr	@r0
	nop
	mov.l	@(24,r15),r0
	exts.b	r0,r0
	mov.b	r0,@r13
	mov.l	L3134,r0
	mov.l	@r0,r0
	mov.l	L3135,r1
	mov.l	@r1,r1
	mov.l	@(12,r15),r2
	add	r2,r1
	mov.l	r1,@r0
	mov.l	@(4,r15),r0
	mov.l	r0,@(8,r12)
	mov.l	L3136,r0
	mov.l	@r0,r0
	mov.l	r0,@(40,r15)
	mov.l	L3137,r0
	mov.l	@r0,r0
	mov.l	@(12,r15),r1
	mov.l	r1,@r0
	mov.l	@(52,r15),r0
	mov.l	@(40,r15),r1
	add	r1,r0
	mov.l	r0,@(28,r15)
	mov.l	@(28,r15),r1
	mov	r15,r0
	add	#64,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov.w	r0,@r1
	mov.w	@(4,r12),r0
	mov.l	@(28,r15),r1
	mov.w	r0,@(6,r1)
	mov.l	@(28,r15),r1
	add	#64,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	extu.w	r0,r2
	extu.w	r10,r0
	not	r0,r0
	and	r0,r2
	mov	r2,r0
	mov.w	r0,@(2,r1)
	mov	#6,r1
	exts.b	r14,r0
	muls.w	r0,r1
	sts	macl,r0
	exts.b	r0,r0
	mov.l	L3138,r1
	mov.l	@r1,r1
	add	r1,r0
	mov	r0,r1
	mov	r15,r0
	add	#66,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.b	r0,@r1
	mov.l	@(28,r15),r0
	mov.l	@(60,r15),r1
	mov.l	r1,@(8,r0)
	mov.l	@(60,r15),r0
	mov.l	r0,@r12
	add	#64,r0
	mov.l	@r0,r0
	mov.l	r0,@(4,r12)
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	mov.l	L3133,r0
	jsr	@r0
	nop
L1915:
L1914:
	add	#44,r15
	lds.l	@r15+,macl
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3130:	.short	144
L3132:	.short	128
L3131:	.long	DAT_06045fb0
L3133:	.long	halt_baddata
L3134:	.long	DAT_06044634
L3135:	.long	DAT_06044630
L3136:	.long	DAT_06044640
L3137:	.long	DAT_0604463c
L3138:	.long	DAT_06044644
	.global FUN_06046602
	.align 2
FUN_06046602:
	sts.l	pr,@-r15
	mov.l	@(16,r13),r0
	tst	r0,r0
	bt	L1926
	mov.w	@r13,r0
	mov	r0,r14
	mov	r10,r0
	add	#28,r0
	mov.l	@r0,r11
L1929:
	mov.l	L3139,r0
	jsr	@r0
	nop
	mov.l	L3140,r3
	jsr	@r3
	mov.l	@(44,r10),r4
	mov	r11,r1
	add	#8,r1
	mov	r12,r0
	shll	r0
	shll2	r0
	mov.l	L3141,r2
	add	r2,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	dt	r14
	add	#16,r11
	bf	L1929
L1926:
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3139:	.long	FUN_06045af4
L3140:	.long	FUN_06045fc0
L3141:	.long	DAT_06046658
	.global FUN_0604660a
	.align 2
FUN_0604660a:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	mov.l	r11,@-r15
	mov.l	r10,@-r15
	mov.l	r9,@-r15
	mov.l	r8,@-r15
	sts.l	pr,@-r15
	mov.w	@r10,r0
	mov	r0,r9
	mov	r13,r0
	add	#28,r0
	mov.l	@r0,r12
L1933:
	mov.l	L3142,r0
	jsr	@r0
	nop
	mov.l	L3143,r3
	jsr	@r3
	mov.l	@(44,r13),r4
	mov	r11,r0
	shll	r0
	shll2	r0
	mov.l	L3144,r1
	add	r1,r0
	mov.w	@r0,r8
	mov	r12,r1
	add	#8,r1
	mov.w	r8,@r1
	dt	r9
	add	#16,r12
	bf	L1933
	exts.w	r8,r0
	lds.l	@r15+,pr
	mov.l	@r15+,r8
	mov.l	@r15+,r9
	mov.l	@r15+,r10
	mov.l	@r15+,r11
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3142:	.long	FUN_06045af4
L3143:	.long	FUN_06045fc0
L3144:	.long	DAT_06046658
	.global FUN_0604669e
	.align 2
FUN_0604669e:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3145,r0
	jsr	@r0
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L3146,r1
	add	r1,r0
	mov	r0,r1
	mov.l	L3147,r0
	mov.l	@r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	or	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov.l	@(0,r15),r0
	mov.w	L3148,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1936
	mov.l	L3149,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3150,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r0
	mov.l	@(8,r0),r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r9
L1939:
	mov.l	@(0,r15),r0
	mov.w	L3148,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1942
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1942:
	mov.w	@r9,r11
	mov.l	@(0,r15),r0
	mov.w	L3147,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1944
	mov.l	L3151,r3
	jsr	@r3
	nop
	bra	L1945
	nop
L1944:
	mov.l	L3152,r3
	jsr	@r3
	nop
L1945:
	mov.l	@(0,r15),r0
	mov.w	L3153,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.w	r1,@r0
	tst	r10,r10
	bf	L1939
L1936:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3146:	.short	130
L3148:	.short	136
L3153:	.short	142
	.align 2
L3145:	.long	FUN_060459c4
L3147:	.long	uRam06046700
L3149:	.long	pcRam06046704
L3150:	.long	pcRam06046708
L3151:	.long	FUN_0604670c
L3152:	.long	FUN_0604674e
	.global FUN_060466a0
	.align 2
FUN_060466a0:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3154,r0
	jsr	@r0
	mov	r6,r12
	mov.l	@(0,r15),r0
	mov.w	L3155,r1
	add	r1,r0
	mov	r0,r1
	mov.l	L3156,r0
	mov.l	@r0,r0
	extu.w	r0,r2
	extu.w	r12,r0
	or	r0,r2
	mov	r2,r0
	mov.w	r0,@r1
	mov.l	@(0,r15),r0
	mov.w	L3157,r1
	add	r1,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1946
	mov.l	L3158,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3159,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	@(48,r8),r0
	mov.l	@(8,r0),r1
	add	r0,r1
	mov	r1,r0
	mov	r0,r9
L1949:
	mov.l	@(0,r15),r0
	mov.w	L3157,r1
	add	r1,r0
	mov.l	@r0,r0
	extu.w	r0,r1
	shlr16	r0
	cmp/hi	r0,r1
	bt	L1952
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L1952:
	mov.w	@r9,r11
	mov.l	@(0,r15),r0
	mov.w	L3156,r1
	add	r1,r0
	mov	r0,r1
	mov.w	r11,@r1
	add	#4,r9
	extu.w	r11,r0
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L1954
	mov.l	L3160,r3
	jsr	@r3
	nop
	bra	L1955
	nop
L1954:
	mov.l	L3161,r3
	jsr	@r3
	nop
L1955:
	mov.l	@(0,r15),r0
	mov.w	L3162,r1
	add	r1,r0
	mov.w	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.w	r1,@r0
	tst	r10,r10
	bf	L1949
L1946:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3155:	.short	130
L3157:	.short	136
L3162:	.short	142
	.align 2
L3154:	.long	FUN_060459c4
L3156:	.long	uRam06046700
L3158:	.long	pcRam06046704
L3159:	.long	pcRam06046708
L3160:	.long	FUN_0604670c
L3161:	.long	func_0x0604674e
	.global FUN_0604670c
	.align 2
FUN_0604670c:
	sts.l	pr,@-r15
	mov.l	L3163,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	or	r1,r0
	mov.l	@(4,r10),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L1957
	mov.w	L3164,r0
	add	r9,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1959
	mov.l	L3165,r3
	jsr	@r3
	nop
L1959:
	mov.l	L3166,r0
	jsr	@r0
	nop
	mov.l	L3167,r0
	jsr	@r0
	nop
	mov.l	L3168,r3
	jsr	@r3
	nop
	mov.w	L3169,r0
	add	r9,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	L3170,r0
	jsr	@r0
	nop
	mov.w	L3166,r0
	add	r9,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
L1957:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3164:	.short	128
L3169:	.short	155
L3163:	.long	func_0x06045ac0
L3165:	.long	FUN_06045c9c
L3166:	.long	FUN_06045e44
L3167:	.long	FUN_06045c3c
L3168:	.long	FUN_06045d04
L3170:	.long	FUN_06045e06
	.global FUN_0604674e
	.align 2
FUN_0604674e:
	sts.l	pr,@-r15
	mov.l	L3171,r3
	jsr	@r3
	nop
	mov.l	@(4,r13),r0
	mov.l	@(4,r12),r1
	or	r1,r0
	mov.l	@(4,r11),r1
	mov	r0,r14
	or	r1,r14
	mov	#2,r0
	mov	r14,r1
	and	r0,r1
	tst	r1,r1
	bf	L1962
	mov.w	L3172,r0
	add	r10,r0
	mov.w	@r0,r0
	extu.w	r0,r0
	mov	#16,r1
	and	r1,r0
	tst	r0,r0
	bt	L1964
	mov.l	L3173,r3
	jsr	@r3
	nop
L1964:
	mov.l	L3174,r0
	jsr	@r0
	nop
	mov.l	L3175,r0
	jsr	@r0
	nop
	mov.l	L3176,r3
	jsr	@r3
	nop
	mov.w	L3177,r0
	add	r10,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	L3178,r0
	jsr	@r0
	nop
	mov.w	L3174,r0
	add	r10,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
L1962:
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3172:	.short	128
L3177:	.short	155
L3171:	.long	FUN_06045adc
L3173:	.long	FUN_06045c9c
L3174:	.long	FUN_06045e44
L3175:	.long	FUN_06045c3c
L3176:	.long	FUN_06045d80
L3178:	.long	FUN_06045e06
	.global FUN_060467b2
	.align 2
FUN_060467b2:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3179,r0
	mov.l	@r0,r12
	mov.l	L3180,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1967
	mov.l	L3181,r0
	mov.l	@r0,r12
L1967:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L3182,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L3183,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L3184,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1966
	mov.l	L3185,r3
	jsr	@r3
	nop
	mov.w	L3184,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1966
	mov.l	@(48,r12),r0
	mov.w	L3180,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L3186,r3
	jsr	@r3
L1966:
	lds.l	@r15+,pr
	rts
	mov.l	r0,@r1
	.align 2
L3182:	.short	168
L3183:	.short	170
L3184:	.short	136
	.align 2
L3179:	.long	DAT_060468a4
L3180:	.long	_DAT_ffffffe2
L3181:	.long	DAT_060468a8
L3185:	.long	FUN_0604680c
L3186:	.long	FUN_06045a2c
	.global FUN_060467b4
	.align 2
FUN_060467b4:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3187,r0
	mov.l	@r0,r12
	mov.l	L3188,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1974
	mov.l	L3189,r0
	mov.l	@r0,r12
L1974:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L3190,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L3191,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L3192,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1973
	mov.l	L3193,r3
	jsr	@r3
	nop
	mov.w	L3192,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1973
	mov.l	@(48,r12),r0
	mov.w	L3188,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L3194,r3
	jsr	@r3
	mov.l	r0,@r1
L1973:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3190:	.short	168
L3191:	.short	170
L3192:	.short	136
	.align 2
L3187:	.long	DAT_060468a4
L3188:	.long	_DAT_ffffffe2
L3189:	.long	DAT_060468a8
L3193:	.long	func_0x0604680c
L3194:	.long	func_0x06045a2c
	.global FUN_060468ae
	.align 2
FUN_060468ae:
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3195,r0
	mov.l	@r0,r12
	mov.l	L3196,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1981
	mov.l	L3197,r0
	mov.l	@r0,r12
L1981:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L3198,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L3199,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L3200,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1980
	mov.l	L3201,r3
	jsr	@r3
	nop
	mov.w	L3200,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1980
	mov.l	@(48,r12),r0
	mov.w	L3196,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L3202,r3
	jsr	@r3
L1980:
	lds.l	@r15+,pr
	rts
	mov.l	r0,@r1
	.align 2
L3198:	.short	168
L3199:	.short	170
L3200:	.short	136
	.align 2
L3195:	.long	iRam06046984
L3196:	.long	_DAT_ffffffe2
L3197:	.long	iRam06046988
L3201:	.long	FUN_06046908
L3202:	.long	FUN_06045a2c
	.global FUN_060468b0
	.align 2
FUN_060468b0:
	mov.l	r14,@-r15
	mov.l	r13,@-r15
	mov.l	r12,@-r15
	sts.l	pr,@-r15
	mov	r4,r14
	mov	r5,r13
	mov.l	L3203,r0
	mov.l	@r0,r12
	mov.l	L3204,r0
	mov.l	@r0,r0
	mov	#0,r1
	cmp/ge	r1,r0
	bt	L1988
	mov.l	L3205,r0
	mov.l	@r0,r12
L1988:
	mov.l	r14,@(44,r12)
	mov.l	r13,@(48,r12)
	mov.w	L3206,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#4,r1
	mov.w	r1,@r0
	mov.w	L3207,r0
	add	r12,r0
	mov.w	@r0,r1
	add	#1,r1
	mov.w	r1,@r0
	mov	r12,r0
	add	#40,r0
	mov.l	@(12,r13),r1
	add	r13,r1
	add	#8,r1
	mov.l	r1,@r0
	mov.w	L3208,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1987
	mov.l	L3209,r3
	jsr	@r3
	nop
	mov.w	L3208,r0
	add	r12,r0
	mov.l	@r0,r0
	mov	r0,r1
	shlr16	r1
	extu.w	r0,r0
	cmp/hs	r0,r1
	bt	L1987
	mov.l	@(48,r12),r0
	mov.w	L3204,r1
	add	r12,r1
	mov.l	@(8,r0),r2
	add	r0,r2
	mov	r2,r0
	mov.l	@r0,r0
	mov.l	L3210,r3
	jsr	@r3
	mov.l	r0,@r1
L1987:
	lds.l	@r15+,pr
	mov.l	@r15+,r12
	mov.l	@r15+,r13
	rts
	mov.l	@r15+,r14
	.align 2
L3206:	.short	168
L3207:	.short	170
L3208:	.short	136
	.align 2
L3203:	.long	iRam06046984
L3204:	.long	_DAT_ffffffe2
L3205:	.long	iRam06046988
L3209:	.long	func_0x06046908
L3210:	.long	func_0x06045a2c
	.global FUN_0604698c
	.align 2
FUN_0604698c:
	sts.l	pr,@-r15
	add	#-32,r15
	mov	#64,r0
	mov	r13,r1
	and	r0,r1
	tst	r1,r1
	bf	L1996
	mov	#1,r0
	bra	L1997
	mov.l	r0,@(0,r15)
L1996:
	mov	#0,r0
	mov.l	r0,@(0,r15)
L1997:
	mov.l	@(0,r15),r14
	mov	r14,r0
	tst	r14,r14
	bt/s	L1998
	mov.l	r0,@(12,r15)
	mov.l	L3211,r3
	jsr	@r3
	nop
	nop
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L1998:
	mov.l	L3212,r3
	jsr	@r3
	nop
	mov.l	L3213,r3
	jsr	@r3
	nop
	mov.l	@(12,r15),r0
	mov.b	r0,@(11,r15)
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2000
	mov	r8,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3214,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov.w	L3215,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(28,r15),r0
	mov.l	@r0,r12
	mov.l	@(24,r15),r0
	mov.l	@r0,r11
	mov.l	@(20,r15),r0
	mov.l	@r0,r10
	mov.l	@(16,r15),r0
	mov.l	@r0,r9
	mov.l	r12,@(12,r8)
	mov.l	r11,@(16,r8)
	mov.l	r10,@(20,r8)
	mov	r8,r0
	add	#24,r0
	mov.l	r9,@r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2000:
	mov.l	L3216,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L2002
	mov	r12,r0
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2002:
	mov.l	L3217,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2004
	mov.l	L3218,r3
	jsr	@r3
	nop
	mov.l	L3218,r3
	jsr	@r3
	nop
	mov.l	L3218,r3
	jsr	@r3
	nop
	mov.l	L3218,r3
	jsr	@r3
	nop
	mov.l	L3219,r3
	jsr	@r3
	mov	#4,r4
	nop
	add	#32,r15
	lds.l	@r15+,pr
	rts
	nop
L2004:
	mov.l	@(4,r15),r0
	mov.w	L3215,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(16,r15),r4
	mov.l	L3220,r3
	jsr	@r3
L1994:
	add	#32,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r4,r4
	.align 2
L3214:	.short	249
L3215:	.short	155
L3211:	.long	FUN_06046a90
L3212:	.long	FUN_06046b70
L3213:	.long	FUN_06046bf4
L3216:	.long	FUN_06046bd4
L3217:	.long	FUN_06046c14
L3218:	.long	FUN_06046b3c
L3219:	.long	func_0x06046e0e
L3220:	.long	FUN_06047588
	.global FUN_06046990
	.align 2
FUN_06046990:
	sts.l	pr,@-r15
	add	#-20,r15
	mov.l	L3221,r3
	jsr	@r3
	nop
	mov.l	L3222,r3
	jsr	@r3
	nop
	mov.l	@(8,r15),r0
	mov.b	r0,@(7,r15)
	mov	#1,r1
	and	r1,r0
	tst	r0,r0
	bf	L2007
	mov	r10,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3223,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.l	@(0,r15),r0
	mov.w	L3224,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@r9,r14
	mov.l	@r8,r13
	mov.l	@(16,r15),r0
	mov.l	@r0,r12
	mov.l	@(12,r15),r0
	mov.l	@r0,r11
	mov.l	r14,@(12,r10)
	mov.l	r13,@(16,r10)
	mov.l	r12,@(20,r10)
	mov	r10,r0
	add	#24,r0
	mov.l	r11,@r0
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2007:
	mov.l	L3225,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2009
	mov.l	L3226,r3
	jsr	@r3
	nop
	mov.b	@(7,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2011
	mov.l	L3227,r3
	jsr	@r3
	nop
	mov.l	L3227,r3
	jsr	@r3
	nop
	mov.l	L3227,r3
	jsr	@r3
	nop
	mov.l	L3227,r3
	jsr	@r3
	nop
	mov.l	L3228,r3
	jsr	@r3
	mov	#4,r4
	nop
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2011:
	mov.l	@(0,r15),r0
	mov.w	L3224,r1
	add	r1,r0
	mov	#4,r1
	mov.b	r1,@r0
	mov.l	@(12,r15),r4
	mov.l	L3229,r3
	jsr	@r3
	mov.l	@r4,r4
	nop
	add	#20,r15
	lds.l	@r15+,pr
	rts
	nop
L2009:
L2006:
	add	#20,r15
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3223:	.short	249
L3224:	.short	155
L3221:	.long	FUN_06046b70
L3222:	.long	FUN_06046bf4
L3225:	.long	FUN_06046bd4
L3226:	.long	FUN_06046c14
L3227:	.long	FUN_06046b3c
L3228:	.long	FUN_06046e0e
L3229:	.long	FUN_06047588
	.global FUN_06046a20
	.align 2
FUN_06046a20:
	sts.l	pr,@-r15
	add	#-4,r15
	mov	#64,r0
	mov	r13,r1
	and	r0,r1
	tst	r1,r1
	bf	L2015
	mov	#1,r0
	bra	L2016
	mov.l	r0,@(0,r15)
L2015:
	mov	#0,r0
	mov.l	r0,@(0,r15)
L2016:
	mov.l	@(0,r15),r14
	mov	r14,r10
	tst	r14,r14
	bt	L2017
	mov.l	L3230,r3
	jsr	@r3
	nop
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2017:
	mov.l	L3231,r3
	jsr	@r3
	nop
	mov.l	L3232,r3
	jsr	@r3
	nop
	mov	r10,r9
	mov	#1,r0
	mov	r10,r1
	and	r0,r1
	tst	r1,r1
	bf	L2019
	mov	r11,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3232,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L3233,r0
	add	r8,r0
	mov	#4,r1
	mov.l	L3234,r3
	jsr	@r3
	mov.b	r1,@r0
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2019:
	mov.l	L3235,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r9,r0
	and	r0,r0
	cmp/eq	#1,r0
	bf	L2021
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2021:
	mov.l	L3236,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r9,r0
	and	r1,r0
	tst	r0,r0
	bt	L2023
	mov.l	L3237,r3
	jsr	@r3
	nop
	mov.l	L3237,r3
	jsr	@r3
	nop
	mov.l	L3237,r3
	jsr	@r3
	nop
	mov.l	L3238,r3
	jsr	@r3
	mov	#3,r4
	nop
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2023:
	mov.w	L3233,r0
	add	r8,r0
	mov	#4,r1
	mov.l	L3239,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.l	L3240,r3
	jsr	@r3
	nop
L2013:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3233:	.short	155
	.align 2
L3230:	.long	FUN_06046ae8
L3231:	.long	FUN_06046b64
L3232:	.long	FUN_06046bf4
L3234:	.long	FUN_06045c3c
L3235:	.long	FUN_06046bd4
L3236:	.long	FUN_06046c14
L3237:	.long	FUN_06046b3c
L3238:	.long	func_0x06046e0e
L3239:	.long	FUN_06047548
L3240:	.long	FUN_06047588
	.global FUN_06046a24
	.align 2
FUN_06046a24:
	sts.l	pr,@-r15
	mov.l	L3241,r3
	jsr	@r3
	nop
	mov.l	L3242,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2026
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3243,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L3244,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L3245,r3
	jsr	@r3
	mov.b	r1,@r0
	nop
	lds.l	@r15+,pr
	rts
	nop
L2026:
	mov.l	L3246,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2028
	mov.l	L3247,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r11,r0
	and	r1,r0
	tst	r0,r0
	bt	L2030
	mov.l	L3248,r3
	jsr	@r3
	nop
	mov.l	L3248,r3
	jsr	@r3
	nop
	mov.l	L3248,r3
	jsr	@r3
	nop
	mov.l	L3249,r3
	jsr	@r3
	mov	#3,r4
	nop
	lds.l	@r15+,pr
	rts
	nop
L2030:
	mov.w	L3244,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L3250,r3
	jsr	@r3
	mov.b	r1,@r0
	mov.l	L3251,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2028:
L2025:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3243:	.short	249
L3244:	.short	155
L3241:	.long	FUN_06046b64
L3242:	.long	FUN_06046bf4
L3245:	.long	FUN_06045c3c
L3246:	.long	FUN_06046bd4
L3247:	.long	FUN_06046c14
L3248:	.long	FUN_06046b3c
L3249:	.long	FUN_06046e0e
L3250:	.long	FUN_06047548
L3251:	.long	FUN_06047588
	.global FUN_06046a90
	.align 2
FUN_06046a90:
	sts.l	pr,@-r15
	mov.l	L3252,r3
	jsr	@r3
	nop
	mov.l	L3253,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2033
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3254,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L3255,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L3256,r3
	jsr	@r3
	mov.b	r1,@r0
	nop
	lds.l	@r15+,pr
	rts
	nop
L2033:
	mov.l	L3257,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2035
	mov.l	L3258,r3
	jsr	@r3
	nop
	mov.l	L3258,r3
	jsr	@r3
	nop
	mov.l	L3258,r3
	jsr	@r3
	nop
	mov.l	L3258,r3
	jsr	@r3
	nop
	mov.l	L3259,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2035:
L2032:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3254:	.short	249
L3255:	.short	155
L3252:	.long	FUN_06046b70
L3253:	.long	FUN_06046bf4
L3256:	.long	FUN_06045c3c
L3257:	.long	FUN_06046bd4
L3258:	.long	FUN_06046b3c
L3259:	.long	FUN_06046e64
	.global FUN_06046ae8
	.align 2
FUN_06046ae8:
	sts.l	pr,@-r15
	mov.l	L3260,r3
	jsr	@r3
	nop
	mov.l	L3261,r3
	jsr	@r3
	nop
	mov	r12,r11
	mov	#1,r0
	mov	r12,r1
	and	r0,r1
	tst	r1,r1
	bf	L2038
	mov	r13,r0
	add	#4,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3262,r2
	and	r2,r1
	mov	#8,r2
	or	r2,r1
	mov.b	r1,@r0
	mov.w	L3263,r0
	add	r10,r0
	mov	#4,r1
	mov.l	L3264,r3
	jsr	@r3
	mov.b	r1,@r0
	nop
	lds.l	@r15+,pr
	rts
	nop
L2038:
	mov.l	L3265,r3
	jsr	@r3
	nop
	mov	r0,r4
	mov	#1,r0
	extu.b	r11,r0
	and	r0,r0
	cmp/eq	#1,r0
	bt	L2040
	mov.l	L3266,r3
	jsr	@r3
	nop
	mov.l	L3266,r3
	jsr	@r3
	nop
	mov.l	L3266,r3
	jsr	@r3
	nop
	mov.l	L3267,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2040:
L2037:
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3262:	.short	249
L3263:	.short	155
L3260:	.long	FUN_06046b64
L3261:	.long	FUN_06046bf4
L3264:	.long	FUN_06045c3c
L3265:	.long	FUN_06046bd4
L3266:	.long	FUN_06046b3c
L3267:	.long	FUN_06046e64
	.global FUN_06046b3c
	.align 2
FUN_06046b3c:
	mov.w	@(2,r4),r0
	mov	r0,r7
	neg	r6,r0
	cmp/ge	r0,r7
	bt	L2043
	mov	r7,r0
	rts
	nop
L2043:
L2042:
	rts
	mov	r7,r0
	.global FUN_06046b64
	.align 2
FUN_06046b64:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	mov.w	@r9,r0
	cmp/gt	r5,r0
	bt	L2046
	mov.w	@r9,r0
	mov	r0,r5
L2046:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r9),r0
	mov	r0,r1
	cmp/gt	r1,r0
	bt	L2048
	mov.w	@(2,r9),r0
	mov	r0,r4
L2048:
	mov.w	@r10,r0
	cmp/gt	r5,r0
	bt	L2050
	mov.w	@r10,r0
	mov	r0,r5
L2050:
	mov.w	@(2,r10),r0
	mov	r0,r7
	cmp/gt	r7,r4
L2045:
	rts
	nop
	.global FUN_06046b70
	.align 2
FUN_06046b70:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	mov.w	@r8,r0
	cmp/gt	r5,r0
	bt	L2055
	mov.w	@r8,r0
	mov	r0,r5
L2055:
	mov	r6,r4
	exts.w	r4,r4
	mov.w	@(2,r8),r0
	mov	r0,r1
	cmp/gt	r1,r0
	bt	L2057
	mov.w	@(2,r8),r0
	mov	r0,r4
L2057:
	mov.w	@r9,r0
	cmp/gt	r5,r0
	bt	L2059
	mov.w	@r9,r0
	mov	r0,r5
L2059:
	mov.w	@(2,r9),r0
	cmp/gt	r0,r4
	bt	L2061
	mov.w	@(2,r9),r0
	mov	r0,r4
L2061:
	mov.w	@r10,r0
	cmp/gt	r5,r0
	bt	L2063
	mov.w	@r10,r0
	mov	r0,r5
L2063:
	mov.w	@(2,r10),r0
	mov	r0,r7
	cmp/gt	r7,r4
L2054:
	rts
	nop
	.global FUN_06046b96
	.align 2
FUN_06046b96:
	mov.w	@(2,r5),r0
	cmp/gt	r0,r4
	bt	L2068
	mov.w	@(2,r5),r0
	mov	r0,r4
L2068:
	mov.w	@(2,r6),r0
	mov	r0,r7
	cmp/gt	r7,r4
	bt	L2070
	mov	r7,r0
	rts
	nop
L2070:
L2067:
	rts
	mov	r7,r0
	.global FUN_06046bd4
	.align 2
FUN_06046bd4:
	mov	r7,r0
	shlr16	r0
	exts.w	r0,r6
	cmp/ge	r6,r5
	bt	L2073
	neg	r6,r6
	cmp/gt	r4,r6
	bt	L2073
	exts.w	r0,r0
	cmp/ge	r0,r10
	bt	L2073
	mov	r6,r0
	rts
	nop
L2073:
L2072:
	rts
	mov	r6,r0
	.global FUN_06046bf4
	.align 2
FUN_06046bf4:
	mov	r7,r0
	shlr16	r0
	exts.w	r0,r6
	cmp/ge	r6,r11
	bt	L2076
	neg	r6,r6
	cmp/gt	r5,r6
	bt	L2076
	exts.w	r0,r0
	cmp/ge	r0,r4
	bt	L2076
	mov	r6,r0
	rts
	nop
L2076:
L2075:
	rts
	mov	r6,r0
	.global FUN_06046c14
	.align 2
FUN_06046c14:
	cmp/ge	r7,r5
	bt	L2079
	neg	r7,r7
	cmp/ge	r6,r7
	bt	L2079
	mov	r11,r0
	add	#20,r0
	mov.l	@r0,r7
	cmp/ge	r7,r4
	bt	L2079
	neg	r7,r0
	rts
	nop
L2079:
L2078:
	rts
	mov	r7,r0
	.global FUN_06046cd0
	.align 2
FUN_06046cd0:
	mov.l	@(12,r7),r5
	mov.l	@(20,r7),r6
	mov.l	@(16,r7),r1
	mov.l	r1,@r0
	mov.l	r5,@(16,r7)
	mov	r7,r0
	add	#20,r0
	mov.l	@(24,r7),r1
	mov.l	r1,@r0
	mov.l	r6,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3268,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#16,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3268:	.short	239
	.align 2
	.global FUN_06046cf0
	.align 2
FUN_06046cf0:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(20,r5),r1
	mov.l	r1,@r0
	mov	r5,r0
	add	#16,r0
	mov.l	@(24,r5),r1
	mov.l	r1,@r0
	mov.l	r7,@(20,r5)
	mov.l	r6,@(24,r5)
	mov	r5,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3269,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#48,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3269:	.short	207
	.align 2
	.global FUN_06046d10
	.align 2
FUN_06046d10:
	mov.l	@(12,r5),r7
	mov.l	@(16,r5),r6
	mov.l	@(24,r5),r1
	mov.l	r1,@r0
	mov	r5,r0
	add	#16,r0
	mov.l	@(20,r5),r1
	mov.l	r1,@r0
	mov.l	r6,@(20,r5)
	mov.l	r7,@(24,r5)
	mov	r5,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3270,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#32,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	rts
	mov.b	r1,@r0
	.align 2
L3270:	.short	223
	.align 2
	.global FUN_06046d30
	.align 2
FUN_06046d30:
	sts.l	pr,@-r15
	add	#-4,r15
	mov.l	@(24,r0),r4
	mov.l	L3271,r3
	mov.l	@(0,r15),r0
	jsr	@r3
	exts.w	r4,r4
	mov	r0,r4
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bf	L2085
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2085:
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bt	L2087
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov	r9,r8
	mov	#1,r0
	mov	r9,r1
	and	r0,r1
	tst	r1,r1
	bf	L2089
L2091:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3272,r3
	and	r3,r2
	not	r1,r1
	mov	#48,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(20,r10),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	#16,r0
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov.l	r12,@(20,r10)
	mov.l	r11,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2089:
	mov.l	L3271,r3
	jsr	@r3
	nop
	mov	#1,r1
	extu.b	r8,r0
	and	r1,r0
	tst	r0,r0
	bt	L2092
	mov.l	L3273,r3
	jsr	@r3
	nop
	mov	r0,r13
	tst	r13,r13
	bf	L2094
	mov	#0,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2094:
	mov	r13,r0
	cmp/eq	#1,r0
	bf	L2096
	bra	L2098
	nop
L2096:
	mov	r13,r0
	cmp/eq	#2,r0
	bf	L2099
	bra	L2091
	nop
L2099:
L2092:
	mov.l	@(12,r10),r12
	mov.l	@(16,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3275,r3
	and	r3,r2
	not	r1,r1
	mov	#32,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	#16,r0
	mov.l	@(20,r10),r1
	mov.l	r1,@r0
	mov.l	r11,@(20,r10)
	mov.l	r12,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
	mov	r4,r0
	add	#4,r15
	lds.l	@r15+,pr
	rts
	nop
L2087:
L2098:
	mov.l	@(12,r10),r12
	mov.l	@(20,r10),r11
	mov	r10,r1
	add	#1,r1
	mov.b	@r1,r1
	mov	r1,r2
	mov.w	L3274,r3
	and	r3,r2
	not	r1,r1
	mov	#16,r3
	and	r3,r1
	mov	r2,r4
	or	r1,r4
	mov.l	@(16,r10),r1
	mov.l	r1,@r0
	mov.l	r12,@(16,r10)
	mov	r10,r0
	add	#20,r0
	mov.l	@(24,r10),r1
	mov.l	r1,@r0
	mov.l	r11,@(24,r10)
	mov	r10,r0
	add	#1,r0
	mov	r4,r1
	mov.b	r1,@r0
L2084:
	add	#4,r15
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3272:	.short	207
L3274:	.short	239
L3271:	.long	FUN_06046d78
L3273:	.long	FUN_06046d98
L3275:	.long	FUN_06046d78
	.global FUN_06046d78
	.align 2
FUN_06046d78:
	mov	r6,r0
	shlr16	r0
	exts.w	r0,r5
	cmp/gt	r11,r5
	bt	L2102
	neg	r11,r7
	cmp/gt	r5,r7
	bt	L2102
	exts.w	r0,r0
	cmp/gt	r4,r0
	bt	L2102
	neg	r4,r0
	rts
	nop
L2102:
L2101:
	rts
	mov	r7,r0
	.global FUN_06046d98
	.align 2
FUN_06046d98:
	mov.l	r14,@-r15
	mov	r9,r0
	add	#12,r0
	mov.l	@r0,r1
	exts.w	r1,r10
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r6
	mov	#1,r0
	cmp/ge	r0,r6
	bt	L2105
	neg	r6,r6
L2105:
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L2107
	neg	r10,r10
L2107:
	mov	r9,r0
	add	#16,r0
	mov.l	@r0,r1
	exts.w	r1,r4
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r5
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L2109
	neg	r5,r5
L2109:
	mov	#1,r0
	cmp/ge	r0,r4
	bt	L2111
	neg	r4,r4
L2111:
	mov	r4,r0
	add	r5,r0
	mov	r10,r1
	add	r6,r1
	cmp/gt	r1,r0
	bf/s	L2115
	mov	r15,r14
	bra	Lm39
	mov	#0,r0
L2115:
	mov	#1,r0
Lm39:
	mov	r14,r15
	mov	r0,r7
	add	r10,r6
	extu.b	r7,r0
	tst	r0,r0
	bt	L2116
	mov	r4,r6
	add	r5,r6
L2116:
	mov	r9,r0
	add	#20,r0
	mov.l	@r0,r1
	exts.w	r1,r5
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r10
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L2118
	neg	r10,r10
L2118:
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L2120
	neg	r5,r5
L2120:
	mov	r5,r0
	add	r10,r0
	cmp/gt	r6,r0
	bt	L2122
	mov	#2,r7
	mov	r5,r6
	add	r10,r6
L2122:
	mov	r9,r0
	add	#24,r0
	mov.l	@r0,r1
	exts.w	r1,r5
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r10
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L2124
	neg	r10,r10
L2124:
	mov	#1,r0
	cmp/ge	r0,r5
	bt	L2126
	neg	r5,r5
L2126:
	mov	r5,r0
	add	r10,r0
	cmp/gt	r6,r0
	bt	L2128
	mov	#3,r7
L2128:
	extu.b	r7,r0
	rts
	mov.l	@r15+,r14
	.global FUN_06046e0e
	.align 2
FUN_06046e0e:
	sts.l	pr,@-r15
	mov.l	L3276,r3
	jsr	@r3
	nop
	mov.w	L3277,r0
	add	r12,r0
	mov.l	L3278,r3
	jsr	@r3
	mov.l	r13,@r0
	mov.l	L3279,r3
	jsr	@r3
	nop
	mov.w	L3280,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2131
	mov.l	L3281,r3
	jsr	@r3
	nop
	mov.w	L3282,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2133
	mov.l	L3283,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2133:
L2131:
L2130:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3277:	.short	164
L3280:	.short	153
L3282:	.short	154
	.align 2
L3276:	.long	FUN_06046ebc
L3278:	.long	FUN_06046fd4
L3279:	.long	FUN_06047014
L3281:	.long	FUN_06047184
L3283:	.long	FUN_060472cc
	.global FUN_06046e64
	.align 2
FUN_06046e64:
	sts.l	pr,@-r15
	mov.w	L3284,r0
	add	r12,r0
	mov.l	L3285,r3
	jsr	@r3
	mov.l	r13,@r0
	mov.l	L3286,r3
	jsr	@r3
	nop
	mov.w	L3287,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2136
	mov.l	L3288,r3
	jsr	@r3
	nop
	mov.w	L3289,r0
	add	r12,r0
	mov.b	@r0,r0
	tst	r0,r0
	bt	L2138
	mov.l	L3290,r3
	jsr	@r3
	nop
	nop
	lds.l	@r15+,pr
	rts
	nop
L2138:
L2136:
L2135:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3284:	.short	164
L3287:	.short	153
L3289:	.short	154
	.align 2
L3285:	.long	FUN_06046fd4
L3286:	.long	func_0x06047014
L3288:	.long	FUN_06047184
L3290:	.long	FUN_060472cc
	.global FUN_06046ebc
	.align 2
FUN_06046ebc:
	mov.b	@(7,r8),r0
	mov	#4,r1
	and	r1,r0
	tst	r0,r0
	bt/s	L2140
	mov.b	@(7,r8),r0
L2141:
	mov.l	@(8,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2143
	mov.l	@(4,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L2145
L2147:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3291,r3
	and	r3,r2
	not	r1,r1
	mov	#48,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
	bra	L2140
	mov	r13,r0
L2145:
	mov	r4,r0
	cmp/eq	#3,r0
	bt	L2150
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2148
L2150:
	mov.l	@r8,r0
	exts.w	r0,r9
	mov.l	@r8,r0
	shlr16	r0
	exts.w	r0,r12
	mov	#1,r0
	cmp/ge	r0,r12
	bt	L2151
	neg	r12,r12
L2151:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2153
	neg	r9,r9
L2153:
	mov.l	@(8,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r10
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r11
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L2155
	neg	r11,r11
L2155:
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L2157
	neg	r10,r10
L2157:
	mov	r10,r0
	add	r11,r0
	mov	r9,r1
	add	r12,r1
	cmp/gt	r1,r0
	bf/s	L2161
	mov	#1,r12
L2160:
	mov	#0,r12
L2161:
	mov	r12,r14
	add	r9,r12
	exts.b	r14,r0
	tst	r0,r0
	bt	L2162
	mov	r10,r12
	add	r11,r12
L2162:
	mov.l	@(4,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r11
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2164
	neg	r9,r9
L2164:
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L2166
	neg	r11,r11
L2166:
	mov	r11,r0
	add	r9,r0
	cmp/gt	r12,r0
	bt	L2168
	mov	#2,r14
	mov	r11,r12
	add	r9,r12
L2168:
	mov.l	@(0,r15),r0
	mov.l	@r0,r1
	exts.w	r1,r11
	mov.l	@r0,r0
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2170
	neg	r9,r9
L2170:
	mov	#1,r0
	cmp/ge	r0,r11
	bt	L2172
	neg	r11,r11
L2172:
	mov	r11,r0
	add	r9,r0
	cmp/gt	r12,r0
	bt	L2174
	mov	#3,r14
L2174:
	exts.b	r14,r0
	tst	r0,r0
	bt/s	L2140
	mov	#0,r0
L2176:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L2178
	bra	L2180
	nop
L2178:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L2181
	bra	L2147
	nop
L2181:
L2148:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3292,r3
	and	r3,r2
	not	r1,r1
	mov	#32,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
	bra	L2140
	mov	r13,r0
L2143:
L2180:
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	mov	r1,r2
	mov.w	L3293,r3
	and	r3,r2
	not	r1,r1
	mov	#16,r3
	and	r3,r1
	mov	r2,r1
	or	r1,r1
	mov.b	r1,@r0
L2140:
	rts
	mov	r13,r0
	.align 2
L3291:	.short	207
L3292:	.short	223
L3293:	.short	239
	.align 2
	.global FUN_06046fd4
	.align 2
FUN_06046fd4:
	add	#-16,r15
	mov.l	@(0,r15),r0
	mov.w	L3294,r1
	add	r1,r0
	mov	r0,r1
	mov.b	r6,@r1
	mov.l	L3295,r0
	mov.l	@r0,r0
	mov.l	@(4,r15),r1
	add	r1,r0
	mov	r0,r5
	mov.l	@r9,r0
	mov.l	r0,@r5
	mov	r10,r0
	shlr16	r0
	shlr8	r0
	mov.b	r0,@(4,r5)
	mov.l	@r8,r0
	mov.l	r0,@(8,r5)
	mov	r10,r0
	shlr16	r0
	mov.b	r0,@(12,r5)
	mov.l	@(12,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(16,r5)
	mov	r5,r0
	add	#20,r0
	mov	r10,r1
	shlr8	r1
	mov.b	r1,@r0
	mov.l	@(8,r15),r0
	mov.l	@r0,r0
	mov.l	r0,@(24,r5)
	mov	r5,r0
	add	#28,r0
	mov	r10,r1
	mov.b	r1,@r0
	mov.l	L3295,r0
	mov.l	@r0,r4
	mov.l	@(4,r15),r0
	mov	r4,r0
	add	r0,r0
	mov.l	@r0,r0
	mov.l	r0,@(32,r5)
	mov.l	@(4,r15),r0
	mov	r4,r0
	add	r0,r0
	mov.b	@(4,r0),r0
	mov	r0,r7
	mov	r5,r1
	add	#36,r1
	mov.b	r7,@r1
	add	#16,r15
	rts
	mov	r7,r0
	.align 2
L3294:	.short	152
	.align 2
L3295:	.long	DAT_0604717e
	.global FUN_06047014
	.align 2
FUN_06047014:
	sts.l	pr,@-r15
	mov.l	L3296,r0
	mov.l	@r0,r0
	mov	r0,r10
	add	r12,r10
	mov.l	L3297,r0
	mov.l	@r0,r11
	mov.w	L3298,r0
	add	r13,r0
	mov	#0,r1
	mov.b	r1,@r0
L2185:
	mov	#3,r0
	mov.b	@(4,r10),r0
	and	r0,r0
	mov	r0,r1
	shll2	r1
	mov.b	@(12,r10),r0
	and	r0,r0
	or	r0,r1
	mov	r1,r0
	shll	r0
	shll2	r0
	mov.l	L3299,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3300,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	add	#8,r10
	mov.w	L3296,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.b	r1,@r0
	tst	r9,r9
	bf	L2185
	mov.l	L3297,r0
	mov.l	@r0,r10
	mov	r11,r0
	add	r12,r0
	mov	r10,r0
	mov.l	@(r0,r12),r1
	mov.l	r1,@r0
	mov	r10,r0
	add	r12,r0
	add	#4,r0
	mov.b	@r0,r8
	mov	r11,r1
	add	r12,r1
	add	#4,r1
	mov.b	r8,@r1
	lds.l	@r15+,pr
	rts
	mov	r8,r0
	.align 2
L3298:	.short	153
L3300:	.short	100954170
L3296:	.long	DAT_0604717e
L3297:	.long	DAT_06047180
L3299:	.long	DAT_06047058
	.global FUN_0604708c
	.align 2
FUN_0604708c:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3301,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3302,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3302:	.short	153
	.align 2
L3301:	.long	FUN_06047118
	.global FUN_060470a8
	.align 2
FUN_060470a8:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3303,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3304,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3304:	.short	153
	.align 2
L3303:	.long	FUN_06047118
	.global FUN_060470c4
	.align 2
FUN_060470c4:
	sts.l	pr,@-r15
	mov.l	L3305,r3
	jsr	@r3
	nop
	mov.w	L3306,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3306:	.short	153
	.align 2
L3305:	.long	FUN_06047118
	.global FUN_060470d6
	.align 2
FUN_060470d6:
	sts.l	pr,@-r15
	mov.l	L3307,r3
	jsr	@r3
	nop
	mov.l	L3307,r3
	jsr	@r3
	nop
	mov.w	L3308,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3308:	.short	153
	.align 2
L3307:	.long	func_0x06047118
	.global FUN_060470ec
	.align 2
FUN_060470ec:
	sts.l	pr,@-r15
	mov.l	L3309,r3
	jsr	@r3
	nop
	mov.w	L3310,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3310:	.short	153
	.align 2
L3309:	.long	FUN_06047118
	.global FUN_060470fe
	.align 2
FUN_060470fe:
	sts.l	pr,@-r15
	mov.l	L3311,r3
	jsr	@r3
	nop
	mov.l	L3311,r3
	jsr	@r3
	nop
	mov.w	L3312,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3312:	.short	153
	.align 2
L3311:	.long	func_0x06047118
	.global FUN_06047118
	.align 2
FUN_06047118:
	sts.l	pr,@-r15
	mov.l	L3313,r3
	jsr	@r3
	nop
	mov.l	r13,@r10
	mov	#0,r14
	mov	r13,r0
	shlr16	r0
	exts.w	r0,r12
	cmp/ge	r12,r11
	bt	L2195
	mov	#8,r14
L2195:
	neg	r11,r0
	cmp/ge	r0,r12
	bt	L2197
	exts.b	r14,r0
	add	#4,r0
L2197:
	mov.b	r0,@(4,r10)
	lds.l	@r15+,pr
	rts
	exts.b	r14,r0
	.align 2
L3313:	.long	FUN_06047140
	.global FUN_06047140
	.align 2
FUN_06047140:
	sts.l	macl,@-r15
	mov	r7,r6
	mov	r5,r0
	exts.w	r0,r0
	mov	r7,r1
	exts.w	r1,r1
	cmp/ge	r1,r0
	bt	L2200
	mov	r5,r6
	mov	r7,r5
L2200:
	mov	r6,r10
	shlr16	r10
	mov	r6,r0
	exts.w	r0,r0
	mov.l	L3314,r1
	mov	r5,r2
	exts.w	r2,r2
	mov	r0,r3
	sub	r2,r3
	mov.l	r3,@r1
	exts.w	r10,r1
	mov.l	L3315,r2
	mov	r5,r3
	shlr16	r3
	exts.w	r3,r3
	mov	r1,r3
	sub	r3,r3
	exts.w	r3,r3
	exts.w	r11,r4
	sub	r0,r4
	mov	r4,r0
	exts.w	r0,r0
	mul.l	r0,r3
	sts	macl,r0
	mov.l	r0,@r2
	mov.l	L3316,r0
	mov.l	@r0,r0
	add	r1,r0
	shll16	r0
	lds.l	@r15+,macl
	rts
	nop
	.align 2
L3314:	.long	_DAT_ffffff00
L3315:	.long	_DAT_ffffff04
L3316:	.long	_DAT_ffffff1c
	.global FUN_06047184
	.align 2
FUN_06047184:
	sts.l	pr,@-r15
	mov.l	L3317,r0
	mov.l	@r0,r0
	mov	r0,r13
	add	r12,r13
	mov.w	L3318,r0
	add	r11,r0
	mov	#0,r1
	mov.b	r1,@r0
L2203:
	mov	#12,r0
	mov.b	@(4,r13),r0
	mov	r0,r1
	and	r0,r1
	mov.b	@(12,r13),r0
	and	r0,r0
	shlr2	r0
	or	r0,r1
	mov	r1,r0
	shll	r0
	shll2	r0
	mov.l	L3319,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3320,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	add	#8,r13
	mov.w	L3319,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#-1,r1
	mov.b	r1,@r0
	tst	r14,r14
	bf	L2203
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3318:	.short	154
L3320:	.short	100954538
L3317:	.long	DAT_060472c6
L3319:	.long	DAT_060471bc
	.global FUN_060471f0
	.align 2
FUN_060471f0:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3321,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3322,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3322:	.short	154
	.align 2
L3321:	.long	FUN_0604727c
	.global FUN_0604720c
	.align 2
FUN_0604720c:
	sts.l	pr,@-r15
	mov.l	@r13,r0
	mov.l	r0,@r12
	mov	r12,r0
	add	#4,r0
	mov.l	@(4,r13),r1
	mov.l	L3323,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.w	L3324,r0
	add	r11,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3324:	.short	154
	.align 2
L3323:	.long	FUN_0604727c
	.global FUN_06047228
	.align 2
FUN_06047228:
	sts.l	pr,@-r15
	mov.l	L3325,r3
	jsr	@r3
	nop
	mov.w	L3326,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3326:	.short	154
	.align 2
L3325:	.long	FUN_0604727c
	.global FUN_0604723a
	.align 2
FUN_0604723a:
	sts.l	pr,@-r15
	mov.l	L3327,r3
	jsr	@r3
	nop
	mov.l	L3327,r3
	jsr	@r3
	nop
	mov.w	L3328,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3328:	.short	154
	.align 2
L3327:	.long	func_0x0604727c
	.global FUN_06047250
	.align 2
FUN_06047250:
	sts.l	pr,@-r15
	mov.l	L3329,r3
	jsr	@r3
	nop
	mov.w	L3330,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#1,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3330:	.short	154
	.align 2
L3329:	.long	FUN_0604727c
	.global FUN_06047262
	.align 2
FUN_06047262:
	sts.l	pr,@-r15
	mov.l	L3331,r3
	jsr	@r3
	nop
	mov.l	L3331,r3
	jsr	@r3
	nop
	mov.w	L3332,r0
	add	r13,r0
	mov.b	@r0,r1
	mov	r1,r1
	add	#2,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	r14,r0
	.align 2
L3332:	.short	154
	.align 2
L3331:	.long	func_0x0604727c
	.global FUN_06047270
	.align 2
FUN_06047270:
	mov.w	L3333,r1
	add	r6,r1
	rts
	mov.b	r7,@r1
	.align 2
L3333:	.short	154
	.align 2
	.global FUN_0604727c
	.align 2
FUN_0604727c:
	sts.l	pr,@-r15
	mov.l	L3334,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	mov.l	r13,@r12
	.align 2
L3334:	.long	FUN_0604728e
	.global FUN_0604728e
	.align 2
FUN_0604728e:
	sts.l	macl,@-r15
	mov	r7,r6
	cmp/ge	r7,r5
	bt	L2215
	mov	r5,r6
	mov	r7,r5
L2215:
	mov	r6,r10
	shlr16	r10
	exts.w	r10,r0
	mov.l	L3335,r1
	mov	r5,r2
	shlr16	r2
	exts.w	r2,r2
	mov	r0,r3
	sub	r2,r3
	mov.l	r3,@r1
	mov	r6,r1
	exts.w	r1,r1
	mov.l	L3336,r2
	mov	r5,r3
	exts.w	r3,r3
	mov	r1,r3
	sub	r3,r3
	exts.w	r3,r3
	exts.w	r11,r4
	sub	r0,r4
	mov	r4,r0
	exts.w	r0,r0
	mul.l	r0,r3
	sts	macl,r0
	mov.l	r0,@r2
	mov.l	L3337,r0
	mov.l	@r0,r0
	add	r1,r0
	lds.l	@r15+,macl
	rts
	extu.w	r0,r0
	.align 2
L3335:	.long	_DAT_ffffff00
L3336:	.long	_DAT_ffffff04
L3337:	.long	_DAT_ffffff1c
	.global FUN_060472cc
	.align 2
FUN_060472cc:
	sts.l	pr,@-r15
	mov.w	L3338,r0
	add	r14,r0
	mov.b	@r0,r0
	shll	r0
	shll2	r0
	mov.l	L3339,r1
	add	r1,r0
	mov.w	@r0,r0
	mov.l	L3340,r1
	add	r1,r0
	mov	r0,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3338:	.short	154
L3340:	.short	100954846
L3339:	.long	DAT_060472e0
	.global FUN_06047332
	.align 2
FUN_06047332:
	sts.l	pr,@-r15
	mov.l	L3341,r3
	mov.l	@r10,r0
	mov.l	@(32,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3341,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3342,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3341,r3
	mov.l	@(16,r10),r0
	mov.l	@(16,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3341,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3343,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3342:	.short	143
L3343:	.short	155
L3341:	.long	FUN_06046d30
	.global FUN_0604737a
	.align 2
FUN_0604737a:
	sts.l	pr,@-r15
	mov.l	L3344,r3
	mov.l	@r10,r0
	mov.l	@(32,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3344,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3345,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3344,r3
	mov.l	@(8,r10),r0
	mov.l	@(8,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3344,r3
	jsr	@r3
	mov.l	r13,@(56,r11)
	mov.w	L3346,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3345:	.short	143
L3346:	.short	155
L3344:	.long	FUN_06046d30
	.global FUN_060473ca
	.align 2
FUN_060473ca:
	sts.l	pr,@-r15
	mov.l	L3347,r3
	mov.l	@r10,r0
	mov.l	@(40,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3347,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3348,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3347,r3
	mov.l	@(40,r10),r0
	mov.l	@(32,r10),r12
	mov.l	@(40,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3347,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3349,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3348:	.short	143
L3349:	.short	155
L3347:	.long	FUN_06046d30
	.global FUN_06047414
	.align 2
FUN_06047414:
	sts.l	pr,@-r15
	mov.l	L3350,r3
	mov.l	@r10,r0
	mov.l	@(40,r10),r12
	mov.l	@r10,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3350,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov.l	@r11,r0
	mov.l	r0,@(32,r11)
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3351,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3350,r3
	mov.l	@(8,r10),r0
	mov.l	@(32,r10),r12
	mov.l	@(8,r10),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3350,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.w	L3352,r0
	add	r9,r0
	mov	#8,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#8,r0
	.align 2
L3351:	.short	143
L3352:	.short	155
L3350:	.long	FUN_06046d30
	.global FUN_06047460
	.align 2
FUN_06047460:
	sts.l	pr,@-r15
	mov.l	L3353,r3
	mov.l	@r9,r0
	mov.l	@(40,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3353,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r0
	mov.l	r0,@r10
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3354,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3353,r3
	mov.l	@(8,r9),r0
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3353,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r0
	mov.l	r0,@(32,r10)
	mov.l	@(4,r10),r0
	mov.l	r0,@(36,r10)
	mov.l	@(8,r10),r0
	mov.l	r0,@(40,r10)
	mov.b	@r10,r0
	extu.b	r0,r0
	mov.w	L3354,r1
	and	r1,r0
	mov.b	r0,@r10
	mov.l	L3353,r3
	mov.l	@r9,r0
	mov.l	@r9,r0
	mov.l	r0,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3353,r3
	jsr	@r3
	mov.l	r13,@(56,r10)
	mov.w	L3355,r0
	add	r8,r0
	mov	#12,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3354:	.short	143
L3355:	.short	155
L3353:	.long	FUN_06046d30
	.global FUN_060474d4
	.align 2
FUN_060474d4:
	sts.l	pr,@-r15
	mov.l	L3356,r3
	mov.l	@r9,r0
	mov.l	@(40,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(12,r11)
	mov.l	r14,@(16,r11)
	mov.l	r13,@(20,r11)
	mov.l	L3356,r3
	jsr	@r3
	mov.l	r12,@(24,r11)
	mov	r11,r10
	add	#32,r10
	mov.l	@r11,r0
	mov.l	r0,@r10
	mov.l	@(4,r11),r0
	mov.l	r0,@(36,r11)
	mov.l	@(8,r11),r0
	mov.l	r0,@(40,r11)
	mov.b	@r11,r0
	extu.b	r0,r0
	mov.w	L3357,r1
	and	r1,r0
	mov.b	r0,@r11
	mov.l	L3356,r3
	mov.l	@(8,r9),r0
	mov.l	@(32,r9),r12
	mov.l	@(8,r9),r0
	mov.l	r0,@(44,r11)
	mov.l	r14,@(48,r11)
	mov.l	r13,@(52,r11)
	mov.l	L3356,r3
	jsr	@r3
	mov.l	r12,@(56,r11)
	mov.l	@r10,r0
	mov.l	r0,@(32,r10)
	mov.l	@(4,r10),r0
	mov.l	r0,@(36,r10)
	mov.l	@(8,r10),r0
	mov.l	r0,@(40,r10)
	mov.b	@r10,r0
	extu.b	r0,r0
	mov.w	L3357,r1
	and	r1,r0
	mov.b	r0,@r10
	mov.l	L3356,r3
	mov.l	@r9,r0
	mov.l	@(56,r9),r12
	mov.l	@r9,r0
	mov.l	r0,@(44,r10)
	mov.l	r14,@(48,r10)
	mov.l	r13,@(52,r10)
	mov.l	L3356,r3
	jsr	@r3
	mov.l	r12,@(56,r10)
	mov.w	L3358,r0
	add	r8,r0
	mov	#12,r1
	mov.b	r1,@r0
	lds.l	@r15+,pr
	rts
	mov	#12,r0
	.align 2
L3357:	.short	143
L3358:	.short	155
L3356:	.long	FUN_06046d30
	.global FUN_06047548
	.align 2
FUN_06047548:
	mov.l	r14,@-r15
	sts.l	pr,@-r15
	add	#-24,r15
	mov	r5,r13
	mov	r6,r12
	mov	#14,r0
	mov	r10,r1
	and	r0,r1
	mov.l	L3359,r0
	add	r1,r0
	mov.w	@r0,r11
	mov.l	r1,@(0,r15)
	mov.l	@(0,r15),r0
	mov	#12,r1
	cmp/gt	r1,r0
	bt	L2225
	shll	r0
	mov	r0,r1
	mova	Lswt0,r0
	mov.w	@(r0,r1),r0
	braf	r0
	nop
	.align 2
L3359:	.short	154
Lswt0:
	.short	L2228 - Lswt0
	.short	L2225 - Lswt0
	.short	L2229 - Lswt0
	.short	L2225 - Lswt0
	.short	L2230 - Lswt0
	.short	L2225 - Lswt0
	.short	L2231 - Lswt0
	.short	L2225 - Lswt0
	.short	L2232 - Lswt0
	.short	L2225 - Lswt0
	.short	L2233 - Lswt0
	.short	L2225 - Lswt0
	.short	L2234 - Lswt0
	bra	L2225
	nop
	mov.l	@(20,r15),r0
	mov.l	r13,@(12,r0)
	mov.l	@(12,r15),r1
	exts.w	r11,r0
	add	r0,r1
	mov	r1,r0
	mov	r13,r1
	mov.b	r1,@r0
	exts.w	r11,r0
	mov	r0,r9
	mov.l	@(4,r15),r0
	mov	r0,r1
	add	#82,r1
	mov.b	r9,@r1
	mov.l	@(20,r15),r1
	mov.l	L3360,r3
	jsr	@r3
	mov.b	r9,@r1
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r13,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	add	#82,r0
	mov	r4,r1
	exts.b	r1,r1
	mov.b	r1,@r0
	mov.l	@(4,r15),r0
	mov	r4,r1
	exts.b	r1,r1
	mov.l	L3361,r3
	jsr	@r3
	mov.b	r1,@r0
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r0,r1
	mov.b	r12,@r1
	mov.l	@(4,r15),r0
	mov	r4,r1
	exts.b	r1,r1
	mov.l	L3362,r3
	jsr	@r3
	mov.b	r1,@r0
	mov	r0,r4
	mov.l	@(12,r15),r0
	add	r4,r0
	mov	r0,r1
	mov.b	r12,@r1
	mov.l	@(16,r15),r0
	mov.l	L3363,r0
	mov.l	r4,@r0
	jsr	@r0
	nop
	mov.l	L3363,r0
	jsr	@r0
	nop
L2225:
	mov	r14,r5
	mov.l	L3364,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3366,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3368,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3370,r5
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3366,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3368,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	add	#-48,r14
	mov	r14,r4
	mov.l	L3371,r5
	mov.l	L3365,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3366,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3367,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3368,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3369,r3
	jsr	@r3
	nop
	mov.l	L3376,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3377,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3378,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3379,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3380,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3381,r3
	jsr	@r3
	nop
	mov.l	L3377,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3379,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3381,r3
	jsr	@r3
	nop
	mov	r14,r4
	add	#-48,r4
	mov.l	L3372,r5
	mov.l	L3377,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3378,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3379,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3380,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3381,r3
	jsr	@r3
	nop
	mov.l	L3377,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3379,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3381,r3
	jsr	@r3
	nop
	mov.l	@(4,r15),r0
	add	#81,r0
	mov.b	@r0,r0
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2235
	mov.l	L3373,r3
	jsr	@r3
	nop
L2235:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#8,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2237
	mov.l	L3373,r3
	jsr	@r3
	nop
L2237:
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#16,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt/s	L2241
	mov	r15,r14
	bra	Lm305
	mov	#0,r0
	.align 2
L3360:	.short	143
L3361:	.short	155
L3362:	.short	100954538
L3363:	.short	100954170
L3364:	.short	154
L3365:	.short	154
L3366:	.short	196
L3367:	.short	142
L3368:	.short	32767
L2241:
	mov	#1,r0
Lm305:
	mov	r14,r15
	mov.b	r0,@(11,r15)
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	extu.b	r0,r0
	tst	r0,r0
	bf	L2224
	mov.l	L3382,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3383,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3374,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.b	@(11,r15),r0
	extu.b	r0,r0
	mov	#1,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2224
	mov.l	L3375,r0
	mov.l	@r0,r3
	jsr	@r3
	nop
L2224:
	add	#24,r15
	lds.l	@r15+,pr
	rts
	mov.l	@r15+,r14
	.align 2
L3369:	.long	func_0x06043f10
L3370:	.long	DAT_06044000
L3371:	.long	DAT_06044024
L3372:	.long	DAT_06044048
L3373:	.long	func_0x06043f24
L3374:	.long	PTR_FUN_06043ee0
L3375:	.long	PTR_FUN_06043ee8
L3376:	.long	PTR_FUN_06043ed8
L3377:	.long	PTR_SUB_06043edc
L3378:	.long	PTR_SUB_06043ed0
L3379:	.long	PTR_SUB_06043ed4
L3380:	.long	PTR_SUB_06043ecc
L3381:	.long	func_0x06043f10
L3382:	.long	PTR_FUN_06043ed8
L3383:	.long	PTR_SUB_06043edc
	.global FUN_06047588
	.align 2
FUN_06047588:
	mov.l	@(12,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L2247
L2249:
	mov.l	r13,@(12,r7)
	mov.l	r12,@(16,r7)
	mov.l	r11,@(20,r7)
	mov	r7,r0
	add	#24,r0
	bra	L2246
	mov.l	r4,@r0
L2247:
	mov.l	@(8,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L2250
L2252:
	mov.l	r12,@(12,r7)
	mov.l	r13,@(16,r7)
	mov.l	r4,@(20,r7)
	mov.l	r11,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3384,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#16,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	bra	L2246
	mov.b	r1,@r0
L2250:
	mov.l	@(4,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bf	L2253
L2255:
	mov.l	r11,@(12,r7)
	mov.l	r4,@(16,r7)
	mov.l	r13,@(20,r7)
	mov.l	r12,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3385,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#48,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
	bra	L2246
	mov.b	r1,@r0
L2253:
	mov.l	@(0,r15),r0
	add	#7,r0
	mov.b	@r0,r0
	mov	#4,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2256
	mov	r13,r0
	exts.w	r0,r10
	shlr16	r0
	exts.w	r0,r8
	mov	#1,r0
	cmp/ge	r0,r10
	bt	L2258
	neg	r10,r10
L2258:
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L2260
	neg	r8,r8
L2260:
	mov	r12,r0
	exts.w	r0,r9
	shlr16	r0
	exts.w	r0,r0
	mov.l	r0,@(16,r15)
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2262
	neg	r9,r9
L2262:
	mov.l	@(16,r15),r0
	mov	#1,r1
	cmp/ge	r1,r0
	bt	L2264
	mov.l	@(16,r15),r0
	neg	r0,r0
	mov.l	r0,@(16,r15)
L2264:
	mov.l	@(16,r15),r0
	add	r9,r0
	mov	r8,r1
	add	r10,r1
	cmp/gt	r1,r0
	bf/s	L2268
	mov	#1,r13
L2267:
	mov	#0,r13
L2268:
	mov	r13,r14
	add	r8,r10
	exts.b	r14,r0
	tst	r0,r0
	bt	L2269
	mov.l	@(16,r15),r0
	mov	r0,r10
	add	r9,r10
L2269:
	mov	r11,r0
	exts.w	r0,r8
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L2271
	neg	r8,r8
L2271:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2273
	neg	r9,r9
L2273:
	mov	r9,r0
	add	r8,r0
	cmp/gt	r10,r0
	bt	L2275
	mov	#2,r14
	mov	r9,r10
	add	r8,r10
L2275:
	mov	r4,r0
	exts.w	r0,r8
	shlr16	r0
	exts.w	r0,r9
	mov	#1,r0
	cmp/ge	r0,r8
	bt	L2277
	neg	r8,r8
L2277:
	mov	#1,r0
	cmp/ge	r0,r9
	bt	L2279
	neg	r9,r9
L2279:
	mov	r9,r0
	add	r8,r0
	cmp/gt	r0,r10
	bt	L2281
	mov	#3,r14
L2281:
	exts.b	r14,r0
	tst	r0,r0
	bf	L2283
	bra	L2249
	nop
L2283:
	exts.b	r14,r0
	cmp/eq	#1,r0
	bf	L2285
	bra	L2252
	nop
L2285:
	exts.b	r14,r0
	cmp/eq	#2,r0
	bf	L2287
	bra	L2255
	nop
L2287:
L2256:
	mov.l	r4,@(12,r7)
	mov.l	r11,@(16,r7)
	mov.l	r12,@(20,r7)
	mov.l	r13,@(24,r7)
	mov	r7,r0
	add	#1,r0
	mov.b	@r0,r1
	extu.b	r1,r1
	mov.w	L3386,r2
	mov	r1,r3
	and	r2,r3
	not	r1,r1
	mov	#32,r2
	and	r2,r1
	mov	r3,r1
	or	r1,r1
L2246:
	rts
	mov.b	r1,@r0
	.align 2
L3384:	.short	239
L3385:	.short	207
L3386:	.short	223
	.align 2
	.global FUN_06047748
	.align 2
FUN_06047748:
	mov.l	L3387,r0
	mov.l	@r0,r7
L2290:
	mov.w	@r5,r0
	tst	r0,r0
	bt	L2293
	mov	r4,r0
	shll2	r0
	shll	r0
	add	r7,r0
	add	#2,r0
	mov	r0,r1
	mov.w	@r5,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.w	r0,@r5
	mov.w	@(2,r5),r0
	mov	r0,r4
L2293:
	dt	r6
	add	#-4,r5
	bf	L2290
	rts
	nop
	.align 2
L3387:	.long	DAT_0604776c
	.global FUN_06047770
	.align 2
FUN_06047770:
	mov.l	L3388,r0
	mov.l	@r0,r13
L2296:
	mov.w	@r4,r0
	tst	r0,r0
	bt	L2299
	mov	r7,r0
	shll2	r0
	shll	r0
	add	r13,r0
	add	#2,r0
	mov	r0,r1
	mov.w	@r4,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.w	r0,@r4
	mov.w	@(2,r4),r0
	mov	r0,r7
L2299:
	mov	r4,r0
	add	#-4,r0
	mov.w	@r0,r14
	mov	#0,r0
	mov	r0,r12
	mov	r14,r0
	tst	r0,r0
	bt	L2301
	mov	r6,r0
	shll2	r0
	shll	r0
	add	r13,r0
	add	#2,r0
	mov	r0,r1
	mov.w	r14,@r1
	mov	r4,r0
	add	#-4,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r0
	add	#-2,r0
	mov.w	@r0,r0
	mov	r0,r12
	mov	r12,r6
L2301:
	dt	r5
	add	#-8,r4
	bf	L2296
	rts
	mov	r12,r0
	.align 2
L3388:	.long	DAT_060477b0
	.global FUN_060477d4
	.align 2
FUN_060477d4:
	sts.l	pr,@-r15
	mov.l	L3389,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3389:	.long	FUN_060477fc
	.global FUN_060477d6
	.align 2
FUN_060477d6:
	sts.l	pr,@-r15
	mov.l	L3390,r3
	jsr	@r3
	nop
	lds.l	@r15+,pr
	rts
	nop
	.align 2
L3390:	.long	FUN_060477fc
	.global FUN_060477fc
	.align 2
FUN_060477fc:
	sts.l	pr,@-r15
	mov.l	L3391,r0
	mov.l	@r0,r0
	mov	r0,r14
	mov.l	@r0,r13
	mov.l	@(4,r0),r0
	mov	r0,r1
	mov.l	L3392,r0
	mov.l	L3393,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3394,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3395,r0
	mov.l	@r0,r12
	mov.l	L3396,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	tst	r0,r0
	bf	L2306
	mov.l	L3397,r0
	mov.l	@r0,r0
	add	#4,r0
	mov	r0,r1
	mov.l	L3399,r4
	mov.l	L3398,r0
	mov.l	L3400,r0
	mov.w	@r0,r0
	mov.l	r0,@r1
	mov.l	@r4,r4
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3402,r5
	mov.l	L3401,r4
	mov.l	L3403,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov	r0,r4
	mov.l	L3404,r0
	mov.w	@r0,r0
	mov	r0,r12
	mov	r12,r4
	mov.l	L3402,r6
	mov.l	L3401,r5
	mov.l	L3405,r0
	mov.l	@r5,r5
	jsr	@r0
	mov.l	@r6,r6
	mov.l	L3406,r0
	mov.l	@r0,r0
	mov	r12,r1
	shll2	r1
	shll	r1
	add	r1,r0
	add	#2,r0
	mov	r0,r1
	mov.l	L3407,r0
	mov.l	L3393,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3394,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	@(4,r0),r4
	mov.l	L3408,r3
	mov.l	L3397,r0
	mov.l	r1,@r0
	mov.l	@r0,r0
	jsr	@r3
	mov	r4,r5
	nop
	lds.l	@r15+,pr
	rts
	nop
L2306:
	mov.l	L3409,r0
	mov.w	@r0,r0
	mov	r0,r10
	mov.l	L3395,r0
	mov.l	@r0,r0
	add	#4,r0
	mov	r0,r1
	mov.l	L3411,r4
	mov.l	L3410,r0
	mov.l	L3412,r0
	mov.w	@r0,r0
	mov.l	r0,@r1
	mov.l	@r4,r4
	mov.l	@r0,r3
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3414,r5
	mov.l	L3413,r4
	mov.l	L3415,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3416,r0
	mov.w	@r0,r0
	mov	r0,r10
	mov.l	L3417,r0
	mov.w	@r0,r0
	mov	r0,r11
	mov.l	L3414,r5
	mov.l	L3413,r4
	mov.l	L3418,r3
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3419,r0
	mov.l	@r0,r0
	mov	r0,r12
	mov	r10,r1
	shll2	r1
	shll	r1
	add	r0,r1
	mov	r1,r1
	add	#2,r1
	mov.l	L3420,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r11,r0
	shll2	r0
	shll	r0
	add	r12,r0
	add	#2,r0
	mov	r0,r1
	mov.l	L3421,r0
	mov.l	L3422,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@r0,r3
	jsr	@r3
	nop
	mov.l	L3423,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
L2305:
	lds.l	@r15+,pr
	rts
	mov	#0,r0
	.align 2
L3391:	.long	DAT_0604788c
L3392:	.long	DAT_06047884
L3393:	.long	DAT_06047890
L3394:	.long	DAT_06047894
L3395:	.long	DAT_06047948
L3396:	.long	DAT_06047898
L3397:	.long	DAT_0604789c
L3398:	.long	DAT_06047886
L3399:	.long	PTR_LAB_060478a0
L3400:	.long	DAT_060478a4
L3401:	.long	DAT_060478a8
L3402:	.long	DAT_060478ac
L3403:	.long	func_0x06047986
L3404:	.long	DAT_06047888
L3405:	.long	FUN_06047748
L3406:	.long	DAT_060478b0
L3407:	.long	DAT_0604788a
L3408:	.long	func_0x0604796c
L3409:	.long	DAT_0604793c
L3410:	.long	DAT_0604793a
L3411:	.long	PTR_LAB_0604794c
L3412:	.long	DAT_06047950
L3413:	.long	DAT_06047954
L3414:	.long	DAT_06047958
L3415:	.long	FUN_060479a0
L3416:	.long	DAT_0604793e
L3417:	.long	DAT_06047940
L3418:	.long	FUN_06047770
L3419:	.long	DAT_0604795c
L3420:	.long	DAT_06047942
L3421:	.long	DAT_06047944
L3422:	.long	DAT_06047960
L3423:	.long	DAT_06047964
	.global FUN_06047866
	.align 2
FUN_06047866:
	sts.l	pr,@-r15
	mov.l	L3424,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3425,r0
	mov.l	@r0,r0
	add	#4,r0
	mov.l	@r0,r13
	mov	r13,r4
	mov.l	L3427,r6
	mov.l	L3426,r5
	mov.l	L3428,r3
	mov.l	@r5,r5
	jsr	@r3
	mov.l	@r6,r6
	mov	r0,r4
	mov.l	L3425,r0
	mov.l	@r0,r0
	add	#4,r0
	mov.l	r13,@r0
	lds.l	@r15+,pr
	rts
	mov	r4,r0
	.align 2
L3424:	.long	DAT_06047894
L3425:	.long	DAT_0604789c
L3426:	.long	DAT_060478b4
L3427:	.long	DAT_060478ac
L3428:	.long	FUN_06047748
	.global FUN_0604791a
	.align 2
FUN_0604791a:
	sts.l	pr,@-r15
	mov.l	L3429,r0
	mov.l	@r0,r0
	mov	#17,r1
	mov.l	r1,@r0
	mov.l	L3430,r0
	mov.l	@r0,r0
	mov	r0,r1
	add	#4,r1
	mov.l	@r1,r13
	add	#8,r0
	mov.l	L3432,r5
	mov.l	L3431,r4
	mov.l	L3433,r3
	mov.l	@r0,r12
	mov.l	@r4,r4
	jsr	@r3
	mov.l	@r5,r5
	mov.l	L3430,r0
	mov.l	@r0,r0
	mov	r0,r14
	add	#4,r0
	mov.l	r13,@r0
	mov	r14,r0
	add	#8,r0
	lds.l	@r15+,pr
	rts
	mov.l	r12,@r0
	.align 2
L3429:	.long	DAT_06047964
L3430:	.long	DAT_06047948
L3431:	.long	DAT_06047968
L3432:	.long	DAT_06047958
L3433:	.long	FUN_06047770
	.global FUN_0604796c
	.align 2
FUN_0604796c:
	mov	r4,r0
	shll2	r0
	shll	r0
	mov.l	L3434,r1
	mov.l	@r1,r1
	add	r1,r0
	bra	L2314
	mov	r0,r7
L2311:
	add	#32,r7
L2314:
	mov	r7,r0
	add	#-2,r0
	mov.b	@r0,r0
	mov	#112,r1
	extu.b	r0,r0
	and	r1,r0
	tst	r0,r0
	bt	L2311
	rts
	mov.w	r5,@r7
	.align 2
L3434:	.long	DAT_0604799c
	.global FUN_06047986
	.align 2
FUN_06047986:
L2316:
	mov.w	@r4,r0
	tst	r0,r0
	bt	L2319
	bra	L2315
	mov.w	@r4,r0
L2319:
	dt	r5
	add	#-4,r4
	bf	L2316
	mov.l	L3435,r0
L2315:
	rts
	mov.w	@r0,r0
	.align 2
L3435:	.long	DAT_06047998
	.global FUN_060479a0
	.align 2
FUN_060479a0:
	mov	r4,r6
	add	#-4,r6
	mov	r5,r7
L2322:
	mov.w	@r6,r0
	mov	r0,r8
	tst	r8,r8
	bt	L2325
	bra	L2327
	nop
L2325:
	dt	r7
	add	#-8,r6
	bf	L2322
	mov.l	L3436,r0
	mov.w	@r0,r0
	mov	r0,r8
L2327:
L2328:
	mov.w	@r4,r0
	mov	r0,r7
	tst	r7,r7
	bt	L2331
	nop
	rts
	nop
L2331:
	dt	r5
	add	#-8,r4
	bf	L2328
	mov.l	L3437,r0
	mov.w	@r0,r0
L2321:
	rts
	mov	r0,r7
	.align 2
L3436:	.long	DAT_060479d2
L3437:	.long	DAT_060479d4
	.global FUN_060479d6
	.align 2
FUN_060479d6:
	sts.l	pr,@-r15
	mov.l	L3438,r0
	mov.l	@r0,r13
	mov.l	L3439,r0
	mov.l	@r0,r0
	mov	#0,r1
	mov.l	L3440,r3
	jsr	@r3
	mov.l	L3443,r3
	mov.l	L3441,r0
	mov.l	L3442,r0
	mov.l	r1,@r0
	mov.w	@r0,r0
	mov.w	r0,@r13
	mov.w	@r0,r0
	jsr	@r3
	mov.l	L3445,r5
	mov.l	L3444,r4
	mov.l	L3446,r3
	mov.l	@r4,r4
	mov.l	L3446,r3
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.l	@r5,r5
	.align 2
L3438:	.long	DAT_06047a54
L3439:	.long	DAT_06047a50
L3440:	.long	FUN_06047a84
L3441:	.long	DAT_06047a48
L3442:	.long	DAT_06047a4a
L3443:	.long	FUN_06047ae0
L3444:	.long	DAT_06047a58
L3445:	.long	PTR_DAT_06047a5c
L3446:	.long	FUN_06047b00
	.global FUN_06047a08
	.align 2
FUN_06047a08:
	sts.l	pr,@-r15
	mov.l	L3447,r0
	mov.l	@r0,r11
	mov.l	L3448,r0
	mov.l	@r0,r0
	mov	#1,r1
	mov.l	L3449,r3
	jsr	@r3
	mov.l	r1,@r0
	mov.l	L3450,r3
	jsr	@r3
	nop
	mov.l	L3451,r0
	mov.w	@r0,r0
	mov.w	r0,@r11
	mov	r13,r0
	mov.w	r0,@(2,r11)
	mov	r11,r1
	add	#32,r1
	mov.l	L3451,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r11,r1
	add	#34,r1
	mov.l	L3452,r3
	jsr	@r3
	mov.l	L3454,r5
	mov.l	L3453,r4
	mov.l	L3455,r3
	mov.w	r12,@r1
	mov.l	@r4,r4
	jsr	@r3
	mov.l	L3457,r5
	mov.l	L3456,r4
	mov.l	L3455,r3
	mov.l	@r5,r5
	mov.l	@r4,r4
	jsr	@r3
	lds.l	@r15+,pr
	rts
	mov.l	@r5,r5
	.align 2
L3447:	.long	DAT_06047a54
L3448:	.long	DAT_06047a50
L3449:	.long	FUN_06047a84
L3450:	.long	func_0x06047b34
L3451:	.long	DAT_06047a48
L3452:	.long	FUN_06047ae0
L3453:	.long	DAT_06047a58
L3454:	.long	PTR_DAT_06047a60
L3455:	.long	func_0x06047b00
L3456:	.long	DAT_06047a64
L3457:	.long	PTR_DAT_06047a68
	.global FUN_06047a84
	.align 2
FUN_06047a84:
	mov.l	L3458,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov.l	L3459,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3460,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.l	r0,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3461,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#68,r0
	mov.l	L3462,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov.l	L3463,r0
	mov.w	@r0,r6
	mov.l	L3464,r0
	mov.l	@r0,r0
	mov.b	@r0,r0
	extu.b	r0,r0
	mov.w	L3465,r1
	and	r1,r0
	tst	r0,r0
	bt	L2337
	mov.l	L3463,r0
	mov.w	@r0,r0
	add	#-2,r0
	mov	r0,r6
L2337:
	mov	r4,r1
	add	#78,r1
	exts.w	r6,r0
	mov.w	r0,@r1
	mov	r4,r1
	add	#82,r1
	exts.w	r6,r0
	mov.w	r0,@r1
	mov.l	L3466,r0
	mov.w	@r0,r0
	mov	r0,r7
	mov	r4,r1
	add	#80,r1
	mov.w	r0,@r1
	mov	r4,r1
	add	#84,r1
	mov.w	r7,@r1
	mov.l	L3467,r0
	mov.w	@r0,r0
	mov	r0,r7
	mov	r4,r1
	add	#86,r1
	mov.w	r0,@r1
	mov	r4,r1
	add	#90,r1
	rts
	mov.w	r7,@r1
	.align 2
L3465:	.short	192
	.align 2
L3458:	.long	DAT_06047ac6
L3459:	.long	DAT_06047ad4
L3460:	.long	DAT_06047ac8
L3461:	.long	DAT_06047aca
L3462:	.long	DAT_06047ad8
L3463:	.long	DAT_06047acc
L3464:	.long	DAT_06047adc
L3466:	.long	DAT_06047ace
L3467:	.long	DAT_06047ad0
	.global FUN_06047ae0
	.align 2
FUN_06047ae0:
	mov	r4,r1
	add	#32,r1
	mov.l	L3468,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#44,r0
	mov	#0,r1
	mov.l	r1,@r0
	mov	r4,r6
	add	#64,r6
	mov.l	L3469,r0
	mov.w	@r0,r0
	mov.w	r0,@r6
	mov.l	L3470,r0
	mov.l	@r0,r0
	mov	r0,r7
	mov.l	r6,@r0
	mov	r6,r0
	rts
	mov.l	r0,@(4,r14)
	.align 2
L3468:	.long	DAT_06047af8
L3469:	.long	DAT_06047afa
L3470:	.long	DAT_06047afc
	.global FUN_06047b00
	.align 2
FUN_06047b00:
	mov.l	L3471,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov.l	@r5,r0
	mov.l	r0,@(12,r4)
	mov.l	@(4,r5),r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3472,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.l	@(8,r5),r0
	mov.l	r0,@(44,r4)
	mov	r4,r1
	add	#64,r1
	mov.l	L3473,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	r4,r0
	add	#66,r0
	mov	#0,r1
	mov.w	r1,@r0
	mov	r4,r1
	add	#96,r1
	mov.l	L3474,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov.w	L3475,r1
	add	r4,r1
	mov.l	L3473,r0
	mov.w	@r0,r0
	rts
	mov.w	r0,@r1
	.align 2
L3475:	.short	224
	.align 2
L3471:	.long	DAT_06047b6c
L3472:	.long	DAT_06047b6e
L3473:	.long	DAT_06047b70
L3474:	.long	DAT_06047b72
	.global FUN_06047b34
	.align 2
FUN_06047b34:
	mov.l	L3476,r0
	mov.w	@r0,r0
	mov.w	r0,@r4
	mov	#0,r0
	mov.l	r0,@(12,r4)
	mov.l	L3477,r0
	mov.l	@r0,r0
	mov.l	r0,@(20,r4)
	mov	r4,r1
	add	#32,r1
	mov.l	L3478,r0
	mov.w	@r0,r0
	mov.w	r0,@r1
	mov	#0,r0
	mov.l	r0,@(44,r4)
	mov	r4,r0
	add	#64,r0
	mov.l	L3479,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#68,r0
	mov.l	L3480,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#76,r0
	mov.l	L3481,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#80,r0
	mov.l	L3482,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#84,r0
	mov.l	L3483,r1
	mov.l	@r1,r1
	mov.l	r1,@r0
	mov	r4,r0
	add	#88,r0
	mov.l	L3484,r1
	mov.l	@r1,r1
	rts
	mov.l	r1,@r0
	.align 2
L3476:	.long	DAT_06047b6c
L3477:	.long	DAT_06047b74
L3478:	.long	DAT_06047b6e
L3479:	.long	DAT_06047b78
L3480:	.long	DAT_06047b7c
L3481:	.long	DAT_06047b80
L3482:	.long	DAT_06047b84
L3483:	.long	DAT_06047b88
L3484:	.long	DAT_06047b8c
	.global FUN_06047d3c
	.align 2
FUN_06047d3c:
	mov.l	L3485,r0
	mov.l	@r0,r0
	mov	r4,r1
	add	#8,r1
	mov.l	L3486,r2
	mov.l	@r2,r2
	and	r2,r1
	shlr2	r1
	add	r1,r0
	mov.w	@r0,r0
	shll2	r0
	rts
	nop
	.align 2
L3485:	.long	PTR_DAT_06047db8
L3486:	.long	DAT_06047db0
	.global FUN_06047d46
	.align 2
FUN_06047d46:
	mov	r7,r0
	mov.w	@(r0,r4),r0
	shll2	r0
	rts
	nop
