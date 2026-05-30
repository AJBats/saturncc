	.global FUN_outer
	.text
	.align 1
FUN_outer:
# 18 "saturn/experiments/multi_entry/naked_multiblock.c"
	mov.l	r14,@-r15
# 19 "saturn/experiments/multi_entry/naked_multiblock.c"
	mov.l	r13,@-r15
# 21 "saturn/experiments/multi_entry/naked_multiblock.c"
	.global	FUN_inner
FUN_inner:
# 23 "saturn/experiments/multi_entry/naked_multiblock.c"
	sts.l	pr,@-r15
# 24 "saturn/experiments/multi_entry/naked_multiblock.c"
	mov.l	LP0,r3
# 25 "saturn/experiments/multi_entry/naked_multiblock.c"
	jsr	@r3
# 26 "saturn/experiments/multi_entry/naked_multiblock.c"
	nop
# 27 "saturn/experiments/multi_entry/naked_multiblock.c"
	lds.l	@r15+,pr
# 28 "saturn/experiments/multi_entry/naked_multiblock.c"
	mov.l	@r15+,r13
# 29 "saturn/experiments/multi_entry/naked_multiblock.c"
	rts
# 30 "saturn/experiments/multi_entry/naked_multiblock.c"
	mov.l	@r15+,r14
# 31 "saturn/experiments/multi_entry/naked_multiblock.c"
LP0:    .long   _shared_target
