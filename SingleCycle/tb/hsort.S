
.section .data
.align 4
.global _data
_data:
    .word 0x25642000   # Array before sorted is
    .word 0x41727261
    .word 0x79206265
    .word 0x666f7265
    .word 0x20736f72
    .word 0x74656420
    .word 0x69730a00
    .word 0x536f7274
    .word 0x65642061
    .word 0x72726179
    .word 0x2069730a
    .word 0x00000000
    .word 0x0c000000
    .word 0x0b000000
    .word 0x0d000000
    .word 0x05000000
    .word 0x06000000
    .word 0x07000000
    .word 0x4572726f
    .word 0x72210000



.section .text
.global _start
_start:
   auipc	gp,0x9
   addi	gp,gp,-2048 # 0x8800
   auipc	sp,0x10
   addi	sp,sp,-9 # 0xffff
   jal	zero,0x2d8
   addi	sp,sp,-8
   sw	a0,0(sp)
   sw	a1,4(sp)
   ecall
   lw	a0,0(sp)
   lw	a1,4(sp)
   addi	sp,sp,8
   jalr	zero,0(ra)
   addi	sp,sp,-48
   sw	s0,44(sp)
   addi	s0,sp,48
   sw	a0,-36(s0)
   sw	a1,-40(s0)
   lw	a5,-36(s0)
   lw	a5,0(a5)
   sw	a5,-20(s0)
   lw	a5,-40(s0)
   lw	a4,0(a5)
   lw	a5,-36(s0)
   sw	a4,0(a5)
   lw	a5,-40(s0)
   lw	a4,-20(s0)
   sw	a4,0(a5)
   addi	zero,zero,0
   lw	s0,44(sp)
   addi	sp,sp,48
   jalr	zero,0(ra)
   addi	sp,sp,-48
   sw	ra,44(sp)
   sw	s0,40(sp)
   addi	s0,sp,48
   sw	a0,-36(s0)
   sw	a1,-40(s0)
   sw	a2,-44(s0)
   lw	a5,-44(s0)
   sw	a5,-20(s0)
   lw	a5,-44(s0)
   slli	a5,a5,0x1
   addi	a5,a5,1
   sw	a5,-24(s0)
   lw	a5,-44(s0)
   addi	a5,a5,1
   slli	a5,a5,0x1
   sw	a5,-28(s0)
   lw	a4,-24(s0)
   lw	a5,-40(s0)
   bge	a4,a5,0x104
   lw	a5,-24(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a5,a4,a5
   lw	a4,0(a5)
   lw	a5,-20(s0)
   slli	a5,a5,0x2
   lw	a3,-36(s0)
   add	a5,a3,a5
   lw	a5,0(a5)
   bge	a5,a4,0x104
   lw	a5,-24(s0)
   sw	a5,-20(s0)
   lw	a4,-28(s0)
   lw	a5,-40(s0)
   bge	a4,a5,0x144
   lw	a5,-28(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a5,a4,a5
   lw	a4,0(a5)
   lw	a5,-20(s0)
   slli	a5,a5,0x2
   lw	a3,-36(s0)
   add	a5,a3,a5
   lw	a5,0(a5)
   bge	a5,a4,0x144
   lw	a5,-28(s0)
   sw	a5,-20(s0)
   lw	a4,-20(s0)
   lw	a5,-44(s0)
   beq	a4,a5,0x18c
   lw	a5,-44(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a3,a4,a5
   lw	a5,-20(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a5,a4,a5
   addi	a1,a5,0
   addi	a0,a3,0
   jal	ra,0x34
   lw	a2,-20(s0)
   lw	a1,-40(s0)
   lw	a0,-36(s0)
   jal	ra,0x80
   addi	zero,zero,0
   lw	ra,44(sp)
   lw	s0,40(sp)
   addi	sp,sp,48
   jalr	zero,0(ra)
   addi	sp,sp,-48
   sw	ra,44(sp)
   sw	s0,40(sp)
   addi	s0,sp,48
   sw	a0,-36(s0)
   sw	a1,-40(s0)
   lw	a5,-40(s0)
   srli	a4,a5,0x1f
   add	a5,a4,a5
   srai	a5,a5,0x1
   addi	a5,a5,-1
   sw	a5,-20(s0)
   jal	zero,0x1f0
   lw	a2,-20(s0)
   lw	a1,-40(s0)
   lw	a0,-36(s0)
   jal	ra,0x80
   lw	a5,-20(s0)
   addi	a5,a5,-1
   sw	a5,-20(s0)
   lw	a5,-20(s0)
   bge	a5,zero,0x1d4
   lw	a5,-40(s0)
   addi	a5,a5,-1
   sw	a5,-24(s0)
   jal	zero,0x240
   lw	a5,-24(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a5,a4,a5
   addi	a1,a5,0
   lw	a0,-36(s0)
   jal	ra,0x34
   addi	a2,zero,0
   lw	a1,-24(s0)
   lw	a0,-36(s0)
   jal	ra,0x80
   lw	a5,-24(s0)
   addi	a5,a5,-1
   sw	a5,-24(s0)
   lw	a5,-24(s0)
   bge	a5,zero,0x208
   addi	zero,zero,0
   addi	zero,zero,0
   lw	ra,44(sp)
   lw	s0,40(sp)
   addi	sp,sp,48
   jalr	zero,0(ra)
   addi	sp,sp,-48
   sw	ra,44(sp)
   sw	s0,40(sp)
   addi	s0,sp,48
   sw	a0,-36(s0)
   sw	a1,-40(s0)
   sw	zero,-20(s0)
   jal	zero,0x2b0
   lw	a5,-20(s0)
   slli	a5,a5,0x2
   lw	a4,-36(s0)
   add	a5,a4,a5
   lw	a5,0(a5)
   addi	a1,a5,0
   lui	a5,0x8
   addi	a0,a5,0 # 0x8000
   jal	ra,0x4a4
   lw	a5,-20(s0)
   addi	a5,a5,1
   sw	a5,-20(s0)
   lw	a4,-20(s0)
   lw	a5,-40(s0)
   blt	a4,a5,0x280
   addi	a0,zero,10
   jal	ra,0x37c
   addi	zero,zero,0
   lw	ra,44(sp)
   lw	s0,40(sp)
   addi	sp,sp,48
   jalr	zero,0(ra)
   addi	sp,sp,-48
   sw	ra,44(sp)
   sw	s0,40(sp)
   addi	s0,sp,48
   addi	a5,gp,-2000
   lw	a0,0(a5)
   lw	a1,4(a5)
   lw	a2,8(a5)
   lw	a3,12(a5)
   lw	a4,16(a5)
   lw	a5,20(a5)
   sw	a0,-44(s0)
   sw	a1,-40(s0)
   sw	a2,-36(s0)
   sw	a3,-32(s0)
   sw	a4,-28(s0)
   sw	a5,-24(s0)
   addi	a5,zero,6
   sw	a5,-20(s0)
   addi	a0,gp,-2044
   jal	ra,0x3b8
   addi	a5,s0,-44
   lw	a1,-20(s0)
   addi	a0,a5,0
   jal	ra,0x260
   addi	a5,s0,-44
   lw	a1,-20(s0)
   addi	a0,a5,0
   jal	ra,0x1a0
   addi	a0,gp,-2020
   jal	ra,0x3b8
   addi	a5,s0,-44
   lw	a1,-20(s0)
   addi	a0,a5,0
   jal	ra,0x260
   jal	ra,0x604
   addi	zero,zero,0
   lw	ra,44(sp)
   lw	s0,40(sp)
   addi	sp,sp,48
   jalr	zero,0(ra)
   addi	sp,sp,-32
   sw	ra,28(sp)
   sw	s0,24(sp)
   addi	s0,sp,32
   addi	a5,a0,0
   sb	a5,-17(s0)
   lbu	a5,-17(s0)
   addi	a1,a5,0
   addi	a0,zero,1
   jal	ra,0x14
   addi	zero,zero,0
   lw	ra,28(sp)
   lw	s0,24(sp)
   addi	sp,sp,32
   jalr	zero,0(ra)
   addi	sp,sp,-32
   sw	ra,28(sp)
   sw	s0,24(sp)
   addi	s0,sp,32
   sw	a0,-20(s0)
   jal	zero,0x3e8
   lw	a5,-20(s0)
   addi	a4,a5,1
   sw	a4,-20(s0)
   lbu	a5,0(a5)
   addi	a0,a5,0
   jal	ra,0x37c
   lw	a5,-20(s0)
   lbu	a5,0(a5)
   bne	a5,zero,0x3d0
   addi	zero,zero,0
   addi	zero,zero,0
   lw	ra,28(sp)
   lw	s0,24(sp)
   addi	sp,sp,32
   jalr	zero,0(ra)
   addi	sp,sp,-32
   sw	ra,28(sp)
   sw	s0,24(sp)
   addi	s0,sp,32
   sw	a0,-20(s0)
   lw	a5,-20(s0)
   bge	a5,zero,0x43c
   addi	a0,zero,45
   jal	ra,0x37c
   lw	a5,-20(s0)
   sub	a5,zero,a5
   sw	a5,-20(s0)
   lw	a5,-20(s0)
   addi	a4,a5,9
   addi	a5,zero,18
   bgeu	a5,a4,0x468
   lw	a5,-20(s0)
   addi	a1,zero,10
   addi	a0,a5,0
   jal	ra,0x634
   addi	a5,a0,0
   addi	a0,a5,0
   jal	ra,0x40c
   lw	a5,-20(s0)
   addi	a1,zero,10
   addi	a0,a5,0
   jal	ra,0x6b8
   addi	a5,a0,0
   andi	a5,a5,255
   addi	a5,a5,48
   andi	a5,a5,255
   addi	a0,a5,0
   jal	ra,0x37c
   addi	zero,zero,0
   lw	ra,28(sp)
   lw	s0,24(sp)
   addi	sp,sp,32
   jalr	zero,0(ra)
   addi	sp,sp,-96
   sw	ra,60(sp)
   sw	s0,56(sp)
   addi	s0,sp,64
   sw	a0,-52(s0)
   sw	a1,4(s0)
   sw	a2,8(s0)
   sw	a3,12(s0)
   sw	a4,16(s0)
   sw	a5,20(s0)
   sw	a6,24(s0)
   sw	a7,28(s0)
   lw	a5,-52(s0)
   sw	a5,-20(s0)
   sw	zero,-24(s0)
   addi	a5,s0,32
   sw	a5,-56(s0)
   lw	a5,-56(s0)
   addi	a5,a5,-28
   sw	a5,-36(s0)
   jal	zero,0x5e0
   lw	a5,-20(s0)
   lbu	a4,0(a5)
   addi	a5,zero,37
   bne	a4,a5,0x5b8
   lw	a5,-20(s0)
   addi	a5,a5,1
   sw	a5,-20(s0)
   lw	a5,-20(s0)
   lbu	a5,0(a5)
   addi	a4,zero,100
   beq	a5,a4,0x57c
   addi	a4,zero,115
   bne	a5,a4,0x59c
   lw	a5,-36(s0)
   addi	a4,a5,4
   sw	a4,-36(s0)
   lw	a5,0(a5)
   sw	a5,-28(s0)
   jal	zero,0x56c
   lw	a5,-28(s0)
   lbu	a5,0(a5)
   addi	a0,a5,0
   jal	ra,0x37c
   lw	a5,-24(s0)
   addi	a5,a5,1
   sw	a5,-24(s0)
   lw	a5,-28(s0)
   addi	a5,a5,1
   sw	a5,-28(s0)
   lw	a5,-28(s0)
   lbu	a5,0(a5)
   bne	a5,zero,0x544
   jal	zero,0x5a8
   lw	a5,-36(s0)
   addi	a4,a5,4
   sw	a4,-36(s0)
   lw	a5,0(a5)
   sw	a5,-32(s0)
   lw	a0,-32(s0)
   jal	ra,0x40c
   jal	zero,0x5a8
   addi	a0,gp,-1976
   jal	ra,0x3b8
   addi	zero,zero,0
   lw	a5,-20(s0)
   addi	a5,a5,1
   sw	a5,-20(s0)
   jal	zero,0x5e0
   lw	a5,-20(s0)
   lbu	a5,0(a5)
   addi	a0,a5,0
   jal	ra,0x37c
   lw	a5,-24(s0)
   addi	a5,a5,1
   sw	a5,-24(s0)
   lw	a5,-20(s0)
   addi	a5,a5,1
   sw	a5,-20(s0)
   lw	a5,-20(s0)
   lbu	a5,0(a5)
   bne	a5,zero,0x4f8
   addi	zero,zero,0
   addi	zero,zero,0
   lw	ra,60(sp)
   lw	s0,56(sp)
   addi	sp,sp,96
   jalr	zero,0(ra)
   addi	sp,sp,-16
   sw	ra,12(sp)
   sw	s0,8(sp)
   addi	s0,sp,16
   addi	a1,zero,0
   addi	a0,zero,0
   jal	ra,0x14
   addi	zero,zero,0
   lw	ra,12(sp)
   lw	s0,8(sp)
   addi	sp,sp,16
   jalr	zero,0(ra)
   blt	a0,zero,0x694
   blt	a1,zero,0x6a4
   addi	a2,a1,0
   addi	a1,a0,0
   addi	a0,zero,-1
   beq	a2,zero,0x680
   addi	a3,zero,1
   bgeu	a2,a1,0x664
   bge	zero,a2,0x664
   slli	a2,a2,0x1
   slli	a3,a3,0x1
   bltu	a2,a1,0x654
   addi	a0,zero,0
   bltu	a1,a2,0x674
   sub	a1,a1,a2
   or	a0,a0,a3
   srli	a3,a3,0x1
   srli	a2,a2,0x1
   bne	a3,zero,0x668
   jalr	zero,0(ra)
   addi	t0,ra,0
   jal	ra,0x63c
   addi	a0,a1,0
   jalr	zero,0(t0)
   sub	a0,zero,a0
   blt	zero,a1,0x6a8
   sub	a1,zero,a1
   jal	zero,0x63c
   sub	a1,zero,a1
   addi	t0,ra,0
   jal	ra,0x63c
   sub	a0,zero,a0
   jalr	zero,0(t0)
   addi	t0,ra,0
   blt	a1,zero,0x6d0
   blt	a0,zero,0x6d8
   jal	ra,0x63c
   addi	a0,a1,0
   jalr	zero,0(t0)
   sub	a1,zero,a1
   bge	a0,zero,0x6c4
   sub	a0,zero,a0
   jal	ra,0x63c
   sub	a0,zero,a1
   jalr	zero,0(t0)
   