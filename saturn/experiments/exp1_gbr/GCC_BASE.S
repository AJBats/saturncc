	.file	"GCC_TES1.C"
	.data

! Hitachi SH cc1 (cygnus-2.7-96q3 SOA-960904) arguments: -O -fdefer-pop
! -fomit-frame-pointer -fcse-follow-jumps -fcse-skip-blocks
! -fexpensive-optimizations -fthread-jumps -fstrength-reduce -fpeephole
! -fforce-mem -ffunction-cse -finline -fkeep-static-consts -fcaller-saves
! -freg-struct-return -fdelayed-branch -frerun-cse-after-loop
! -fschedule-insns2 -fcommon -fgnu-linker

gcc2_compiled.:
___gnu_compiled_c:
	.text
	.align 2
	.global	_store_all
_store_all:
	mov.l	r8,@-r15
	mov.l	@(4,r15),r3
	mov.l	L2,r1
	mov.l	@(8,r15),r0
	mov	r1,r2
	mov.l	@(12,r15),r8
	add	#1,r2
	mov.b	r4,@r1
	mov.b	r5,@r2
	mov	r1,r2
	add	#2,r2
	mov.w	r6,@r2
	mov.l	r7,@(4,r1)
	mov	r1,r2
	add	#8,r2
	mov.b	r3,@r2
	mov.l	r0,@(12,r1)
	add	#16,r1
	mov.w	r8,@r1
	rts	
	mov.l	@r15+,r8
L3:
	.align 2
L2:
	.long	_gs
	.align 2
	.global	_load_sum
_load_sum:
	mov.l	L5,r2
	mov.b	@r2,r1
	extu.b	r1,r0
	mov	r2,r1
	add	#1,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	add	r1,r0
	mov	r2,r1
	add	#2,r1
	mov.w	@r1,r1
	extu.w	r1,r1
	add	r1,r0
	mov.l	@(4,r2),r1
	add	r1,r0
	mov	r2,r1
	add	#8,r1
	mov.b	@r1,r1
	extu.b	r1,r1
	add	r1,r0
	mov.l	@(12,r2),r1
	add	r1,r0
	add	#16,r2
	mov.w	@r2,r1
	extu.w	r1,r1
	rts	
	add	r1,r0
L6:
	.align 2
L5:
	.long	_gs
	.comm _gs,20
