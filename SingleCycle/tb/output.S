
output.elf      檔案格式 elf32-littleriscv


.text 區段的反組譯：

00000000 <_start>:
   0:	00009197          	auipc	gp,0x9
   4:	80018193          	addi	gp,gp,-2048 # 8800 <__global_pointer$>
   8:	00010117          	auipc	sp,0x10
   c:	ff710113          	addi	sp,sp,-9 # ffff <__global_pointer$+0x77ff>
  10:	2c80006f          	j	2d8 <_start+0x2d8>
  14:	ff810113          	addi	sp,sp,-8
  18:	00a12023          	sw	a0,0(sp)
  1c:	00b12223          	sw	a1,4(sp)
  20:	00000073          	ecall
  24:	00012503          	lw	a0,0(sp)
  28:	00412583          	lw	a1,4(sp)
  2c:	00810113          	addi	sp,sp,8
  30:	00008067          	ret
  34:	fd010113          	addi	sp,sp,-48
  38:	02812623          	sw	s0,44(sp)
  3c:	03010413          	addi	s0,sp,48
  40:	fca42e23          	sw	a0,-36(s0)
  44:	fcb42c23          	sw	a1,-40(s0)
  48:	fdc42783          	lw	a5,-36(s0)
  4c:	0007a783          	lw	a5,0(a5)
  50:	fef42623          	sw	a5,-20(s0)
  54:	fd842783          	lw	a5,-40(s0)
  58:	0007a703          	lw	a4,0(a5)
  5c:	fdc42783          	lw	a5,-36(s0)
  60:	00e7a023          	sw	a4,0(a5)
  64:	fd842783          	lw	a5,-40(s0)
  68:	fec42703          	lw	a4,-20(s0)
  6c:	00e7a023          	sw	a4,0(a5)
  70:	00000013          	nop
  74:	02c12403          	lw	s0,44(sp)
  78:	03010113          	addi	sp,sp,48
  7c:	00008067          	ret
  80:	fd010113          	addi	sp,sp,-48
  84:	02112623          	sw	ra,44(sp)
  88:	02812423          	sw	s0,40(sp)
  8c:	03010413          	addi	s0,sp,48
  90:	fca42e23          	sw	a0,-36(s0)
  94:	fcb42c23          	sw	a1,-40(s0)
  98:	fcc42a23          	sw	a2,-44(s0)
  9c:	fd442783          	lw	a5,-44(s0)
  a0:	fef42623          	sw	a5,-20(s0)
  a4:	fd442783          	lw	a5,-44(s0)
  a8:	00179793          	slli	a5,a5,0x1
  ac:	00178793          	addi	a5,a5,1
  b0:	fef42423          	sw	a5,-24(s0)
  b4:	fd442783          	lw	a5,-44(s0)
  b8:	00178793          	addi	a5,a5,1
  bc:	00179793          	slli	a5,a5,0x1
  c0:	fef42223          	sw	a5,-28(s0)
  c4:	fe842703          	lw	a4,-24(s0)
  c8:	fd842783          	lw	a5,-40(s0)
  cc:	00f74463          	blt	a4,a5,d4 <_start+0xd4>
  d0:	0340006f          	j	104 <_start+0x104>
  d4:	fe842783          	lw	a5,-24(s0)
  d8:	00279793          	slli	a5,a5,0x2
  dc:	fdc42703          	lw	a4,-36(s0)
  e0:	00f707b3          	add	a5,a4,a5
  e4:	0007a703          	lw	a4,0(a5)
  e8:	fec42783          	lw	a5,-20(s0)
  ec:	00279793          	slli	a5,a5,0x2
  f0:	fdc42683          	lw	a3,-36(s0)
  f4:	00f687b3          	add	a5,a3,a5
  f8:	0007a783          	lw	a5,0(a5)
  fc:	00e7c463          	blt	a5,a4,104 <_start+0x104>
 100:	0040006f          	j	104 <_start+0x104>
 104:	fe842783          	lw	a5,-24(s0)
 108:	fef42623          	sw	a5,-20(s0)
 10c:	fe442703          	lw	a4,-28(s0)
 110:	fd842783          	lw	a5,-40(s0)
 114:	00f74463          	blt	a4,a5,11c <_start+0x11c>
 118:	02c0006f          	j	144 <_start+0x144>
 11c:	fe442783          	lw	a5,-28(s0)
 120:	00279793          	slli	a5,a5,0x2
 124:	fdc42703          	lw	a4,-36(s0)
 128:	00f707b3          	add	a5,a4,a5
 12c:	0007a703          	lw	a4,0(a5)
 130:	fec42783          	lw	a5,-20(s0)
 134:	00279793          	slli	a5,a5,0x2
 138:	fdc42683          	lw	a3,-36(s0)
 13c:	00f687b3          	add	a5,a3,a5
 140:	0007a783          	lw	a5,0(a5)
 144:	00e7c463          	blt	a5,a4,14c <_start+0x14c>
 148:	ffdff06f          	j	144 <_start+0x144>
 14c:	fe442783          	lw	a5,-28(s0)
 150:	fef42623          	sw	a5,-20(s0)
 154:	fec42703          	lw	a4,-20(s0)
 158:	fd442783          	lw	a5,-44(s0)
 15c:	00f71463          	bne	a4,a5,164 <_start+0x164>
 160:	02c0006f          	j	18c <_start+0x18c>
 164:	fd442783          	lw	a5,-44(s0)
 168:	00279793          	slli	a5,a5,0x2
 16c:	fdc42703          	lw	a4,-36(s0)
 170:	00f706b3          	add	a3,a4,a5
 174:	fec42783          	lw	a5,-20(s0)
 178:	00279793          	slli	a5,a5,0x2
 17c:	fdc42703          	lw	a4,-36(s0)
 180:	00f707b3          	add	a5,a4,a5
 184:	00078593          	mv	a1,a5
 188:	00068513          	mv	a0,a3
 18c:	ea9ff0ef          	jal	34 <_start+0x34>
 190:	fec42603          	lw	a2,-20(s0)
 194:	fd842583          	lw	a1,-40(s0)
 198:	fdc42503          	lw	a0,-36(s0)
 19c:	ee5ff0ef          	jal	80 <_start+0x80>
 1a0:	00000013          	nop
 1a4:	02c12083          	lw	ra,44(sp)
 1a8:	02812403          	lw	s0,40(sp)
 1ac:	03010113          	addi	sp,sp,48
 1b0:	00008067          	ret
 1b4:	fd010113          	addi	sp,sp,-48
 1b8:	02112623          	sw	ra,44(sp)
 1bc:	02812423          	sw	s0,40(sp)
 1c0:	03010413          	addi	s0,sp,48
 1c4:	fca42e23          	sw	a0,-36(s0)
 1c8:	fcb42c23          	sw	a1,-40(s0)
 1cc:	fd842783          	lw	a5,-40(s0)
 1d0:	01f7d713          	srli	a4,a5,0x1f
 1d4:	00f707b3          	add	a5,a4,a5
 1d8:	4017d793          	srai	a5,a5,0x1
 1dc:	fff78793          	addi	a5,a5,-1
 1e0:	fef42623          	sw	a5,-20(s0)
 1e4:	00c0006f          	j	1f0 <_start+0x1f0>
 1e8:	fec42603          	lw	a2,-20(s0)
 1ec:	fd842583          	lw	a1,-40(s0)
 1f0:	fdc42503          	lw	a0,-36(s0)
 1f4:	e8dff0ef          	jal	80 <_start+0x80>
 1f8:	fec42783          	lw	a5,-20(s0)
 1fc:	fff78793          	addi	a5,a5,-1
 200:	fef42623          	sw	a5,-20(s0)
 204:	fec42783          	lw	a5,-20(s0)
 208:	0007c463          	bltz	a5,210 <_start+0x210>
 20c:	fc9ff06f          	j	1d4 <_start+0x1d4>
 210:	fd842783          	lw	a5,-40(s0)
 214:	fff78793          	addi	a5,a5,-1
 218:	fef42423          	sw	a5,-24(s0)
 21c:	0240006f          	j	240 <_start+0x240>
 220:	fe842783          	lw	a5,-24(s0)
 224:	00279793          	slli	a5,a5,0x2
 228:	fdc42703          	lw	a4,-36(s0)
 22c:	00f707b3          	add	a5,a4,a5
 230:	00078593          	mv	a1,a5
 234:	fdc42503          	lw	a0,-36(s0)
 238:	dfdff0ef          	jal	34 <_start+0x34>
 23c:	00000613          	li	a2,0
 240:	fe842583          	lw	a1,-24(s0)
 244:	fdc42503          	lw	a0,-36(s0)
 248:	e39ff0ef          	jal	80 <_start+0x80>
 24c:	fe842783          	lw	a5,-24(s0)
 250:	fff78793          	addi	a5,a5,-1
 254:	fef42423          	sw	a5,-24(s0)
 258:	fe842783          	lw	a5,-24(s0)
 25c:	0007c463          	bltz	a5,264 <_start+0x264>
 260:	fa9ff06f          	j	208 <_start+0x208>
 264:	00000013          	nop
 268:	00000013          	nop
 26c:	02c12083          	lw	ra,44(sp)
 270:	02812403          	lw	s0,40(sp)
 274:	03010113          	addi	sp,sp,48
 278:	00008067          	ret
 27c:	fd010113          	addi	sp,sp,-48
 280:	02112623          	sw	ra,44(sp)
 284:	02812423          	sw	s0,40(sp)
 288:	03010413          	addi	s0,sp,48
 28c:	fca42e23          	sw	a0,-36(s0)
 290:	fcb42c23          	sw	a1,-40(s0)
 294:	fe042623          	sw	zero,-20(s0)
 298:	0180006f          	j	2b0 <_start+0x2b0>
 29c:	fec42783          	lw	a5,-20(s0)
 2a0:	00279793          	slli	a5,a5,0x2
 2a4:	fdc42703          	lw	a4,-36(s0)
 2a8:	00f707b3          	add	a5,a4,a5
 2ac:	0007a783          	lw	a5,0(a5)
 2b0:	00078593          	mv	a1,a5
 2b4:	000087b7          	lui	a5,0x8
 2b8:	00078513          	mv	a0,a5
 2bc:	1e8000ef          	jal	4a4 <_start+0x4a4>
 2c0:	fec42783          	lw	a5,-20(s0)
 2c4:	00178793          	addi	a5,a5,1 # 8001 <__DATA_BEGIN__+0x1>
 2c8:	fef42623          	sw	a5,-20(s0)
 2cc:	fec42703          	lw	a4,-20(s0)
 2d0:	fd842783          	lw	a5,-40(s0)
 2d4:	00f75463          	bge	a4,a5,2dc <_start+0x2dc>
 2d8:	fa9ff06f          	j	280 <_start+0x280>
 2dc:	00a00513          	li	a0,10
 2e0:	09c000ef          	jal	37c <_start+0x37c>
 2e4:	00000013          	nop
 2e8:	02c12083          	lw	ra,44(sp)
 2ec:	02812403          	lw	s0,40(sp)
 2f0:	03010113          	addi	sp,sp,48
 2f4:	00008067          	ret
 2f8:	fd010113          	addi	sp,sp,-48
 2fc:	02112623          	sw	ra,44(sp)
 300:	02812423          	sw	s0,40(sp)
 304:	03010413          	addi	s0,sp,48
 308:	83018793          	addi	a5,gp,-2000 # 8030 <__DATA_BEGIN__+0x30>
 30c:	0007a503          	lw	a0,0(a5)
 310:	0047a583          	lw	a1,4(a5)
 314:	0087a603          	lw	a2,8(a5)
 318:	00c7a683          	lw	a3,12(a5)
 31c:	0107a703          	lw	a4,16(a5)
 320:	0147a783          	lw	a5,20(a5)
 324:	fca42a23          	sw	a0,-44(s0)
 328:	fcb42c23          	sw	a1,-40(s0)
 32c:	fcc42e23          	sw	a2,-36(s0)
 330:	fed42023          	sw	a3,-32(s0)
 334:	fee42223          	sw	a4,-28(s0)
 338:	fef42423          	sw	a5,-24(s0)
 33c:	00600793          	li	a5,6
 340:	fef42623          	sw	a5,-20(s0)
 344:	80418513          	addi	a0,gp,-2044 # 8004 <__DATA_BEGIN__+0x4>
 348:	070000ef          	jal	3b8 <_start+0x3b8>
 34c:	fd440793          	addi	a5,s0,-44
 350:	fec42583          	lw	a1,-20(s0)
 354:	00078513          	mv	a0,a5
 358:	f09ff0ef          	jal	260 <_start+0x260>
 35c:	fd440793          	addi	a5,s0,-44
 360:	fec42583          	lw	a1,-20(s0)
 364:	00078513          	mv	a0,a5
 368:	e39ff0ef          	jal	1a0 <_start+0x1a0>
 36c:	81c18513          	addi	a0,gp,-2020 # 801c <__DATA_BEGIN__+0x1c>
 370:	048000ef          	jal	3b8 <_start+0x3b8>
 374:	fd440793          	addi	a5,s0,-44
 378:	fec42583          	lw	a1,-20(s0)
 37c:	00078513          	mv	a0,a5
 380:	ee1ff0ef          	jal	260 <_start+0x260>
 384:	280000ef          	jal	604 <_start+0x604>
 388:	00000013          	nop
 38c:	02c12083          	lw	ra,44(sp)
 390:	02812403          	lw	s0,40(sp)
 394:	03010113          	addi	sp,sp,48
 398:	00008067          	ret
 39c:	fe010113          	addi	sp,sp,-32
 3a0:	00112e23          	sw	ra,28(sp)
 3a4:	00812c23          	sw	s0,24(sp)
 3a8:	02010413          	addi	s0,sp,32
 3ac:	00050793          	mv	a5,a0
 3b0:	fef407a3          	sb	a5,-17(s0)
 3b4:	fef44783          	lbu	a5,-17(s0)
 3b8:	00078593          	mv	a1,a5
 3bc:	00100513          	li	a0,1
 3c0:	c55ff0ef          	jal	14 <_start+0x14>
 3c4:	00000013          	nop
 3c8:	01c12083          	lw	ra,28(sp)
 3cc:	01812403          	lw	s0,24(sp)
 3d0:	02010113          	addi	sp,sp,32
 3d4:	00008067          	ret
 3d8:	fe010113          	addi	sp,sp,-32
 3dc:	00112e23          	sw	ra,28(sp)
 3e0:	00812c23          	sw	s0,24(sp)
 3e4:	02010413          	addi	s0,sp,32
 3e8:	fea42623          	sw	a0,-20(s0)
 3ec:	ffdff06f          	j	3e8 <_start+0x3e8>
 3f0:	fec42783          	lw	a5,-20(s0)
 3f4:	00178713          	addi	a4,a5,1
 3f8:	fee42623          	sw	a4,-20(s0)
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	00078513          	mv	a0,a5
 404:	f79ff0ef          	jal	37c <_start+0x37c>
 408:	fec42783          	lw	a5,-20(s0)
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00078463          	beqz	a5,418 <_start+0x418>
 414:	fbdff06f          	j	3d0 <_start+0x3d0>
 418:	00000013          	nop
 41c:	00000013          	nop
 420:	01c12083          	lw	ra,28(sp)
 424:	01812403          	lw	s0,24(sp)
 428:	02010113          	addi	sp,sp,32
 42c:	00008067          	ret
 430:	fe010113          	addi	sp,sp,-32
 434:	00112e23          	sw	ra,28(sp)
 438:	00812c23          	sw	s0,24(sp)
 43c:	02010413          	addi	s0,sp,32
 440:	fea42623          	sw	a0,-20(s0)
 444:	fec42783          	lw	a5,-20(s0)
 448:	0007c463          	bltz	a5,450 <_start+0x450>
 44c:	ff1ff06f          	j	43c <_start+0x43c>
 450:	02d00513          	li	a0,45
 454:	f29ff0ef          	jal	37c <_start+0x37c>
 458:	fec42783          	lw	a5,-20(s0)
 45c:	40f007b3          	neg	a5,a5
 460:	fef42623          	sw	a5,-20(s0)
 464:	fec42783          	lw	a5,-20(s0)
 468:	00978713          	addi	a4,a5,9
 46c:	01200793          	li	a5,18
 470:	00e7e463          	bltu	a5,a4,478 <_start+0x478>
 474:	ff5ff06f          	j	468 <_start+0x468>
 478:	fec42783          	lw	a5,-20(s0)
 47c:	00a00593          	li	a1,10
 480:	00078513          	mv	a0,a5
 484:	1b0000ef          	jal	634 <_start+0x634>
 488:	00050793          	mv	a5,a0
 48c:	00078513          	mv	a0,a5
 490:	f7dff0ef          	jal	40c <_start+0x40c>
 494:	fec42783          	lw	a5,-20(s0)
 498:	00a00593          	li	a1,10
 49c:	00078513          	mv	a0,a5
 4a0:	218000ef          	jal	6b8 <_start+0x6b8>
 4a4:	00050793          	mv	a5,a0
 4a8:	0ff7f793          	zext.b	a5,a5
 4ac:	03078793          	addi	a5,a5,48
 4b0:	0ff7f793          	zext.b	a5,a5
 4b4:	00078513          	mv	a0,a5
 4b8:	ec5ff0ef          	jal	37c <_start+0x37c>
 4bc:	00000013          	nop
 4c0:	01c12083          	lw	ra,28(sp)
 4c4:	01812403          	lw	s0,24(sp)
 4c8:	02010113          	addi	sp,sp,32
 4cc:	00008067          	ret
 4d0:	fa010113          	addi	sp,sp,-96
 4d4:	02112e23          	sw	ra,60(sp)
 4d8:	02812c23          	sw	s0,56(sp)
 4dc:	04010413          	addi	s0,sp,64
 4e0:	fca42623          	sw	a0,-52(s0)
 4e4:	00b42223          	sw	a1,4(s0)
 4e8:	00c42423          	sw	a2,8(s0)
 4ec:	00d42623          	sw	a3,12(s0)
 4f0:	00e42823          	sw	a4,16(s0)
 4f4:	00f42a23          	sw	a5,20(s0)
 4f8:	01042c23          	sw	a6,24(s0)
 4fc:	01142e23          	sw	a7,28(s0)
 500:	fcc42783          	lw	a5,-52(s0)
 504:	fef42623          	sw	a5,-20(s0)
 508:	fe042423          	sw	zero,-24(s0)
 50c:	02040793          	addi	a5,s0,32
 510:	fcf42423          	sw	a5,-56(s0)
 514:	fc842783          	lw	a5,-56(s0)
 518:	fe478793          	addi	a5,a5,-28
 51c:	fcf42e23          	sw	a5,-36(s0)
 520:	0c00006f          	j	5e0 <_start+0x5e0>
 524:	fec42783          	lw	a5,-20(s0)
 528:	0007c703          	lbu	a4,0(a5)
 52c:	02500793          	li	a5,37
 530:	00f70463          	beq	a4,a5,538 <_start+0x538>
 534:	0840006f          	j	5b8 <_start+0x5b8>
 538:	fec42783          	lw	a5,-20(s0)
 53c:	00178793          	addi	a5,a5,1
 540:	fef42623          	sw	a5,-20(s0)
 544:	fec42783          	lw	a5,-20(s0)
 548:	0007c783          	lbu	a5,0(a5)
 54c:	06400713          	li	a4,100
 550:	00e79463          	bne	a5,a4,558 <_start+0x558>
 554:	0280006f          	j	57c <_start+0x57c>
 558:	07300713          	li	a4,115
 55c:	00e78463          	beq	a5,a4,564 <_start+0x564>
 560:	03c0006f          	j	59c <_start+0x59c>
 564:	fdc42783          	lw	a5,-36(s0)
 568:	00478713          	addi	a4,a5,4
 56c:	fce42e23          	sw	a4,-36(s0)
 570:	0007a783          	lw	a5,0(a5)
 574:	fef42223          	sw	a5,-28(s0)
 578:	ff5ff06f          	j	56c <_start+0x56c>
 57c:	fe442783          	lw	a5,-28(s0)
 580:	0007c783          	lbu	a5,0(a5)
 584:	00078513          	mv	a0,a5
 588:	df5ff0ef          	jal	37c <_start+0x37c>
 58c:	fe842783          	lw	a5,-24(s0)
 590:	00178793          	addi	a5,a5,1
 594:	fef42423          	sw	a5,-24(s0)
 598:	fe442783          	lw	a5,-28(s0)
 59c:	00178793          	addi	a5,a5,1
 5a0:	fef42223          	sw	a5,-28(s0)
 5a4:	fe442783          	lw	a5,-28(s0)
 5a8:	0007c783          	lbu	a5,0(a5)
 5ac:	00078463          	beqz	a5,5b4 <_start+0x5b4>
 5b0:	f95ff06f          	j	544 <_start+0x544>
 5b4:	ff5ff06f          	j	5a8 <_start+0x5a8>
 5b8:	fdc42783          	lw	a5,-36(s0)
 5bc:	00478713          	addi	a4,a5,4
 5c0:	fce42e23          	sw	a4,-36(s0)
 5c4:	0007a783          	lw	a5,0(a5)
 5c8:	fef42023          	sw	a5,-32(s0)
 5cc:	fe042503          	lw	a0,-32(s0)
 5d0:	e3dff0ef          	jal	40c <_start+0x40c>
 5d4:	fd5ff06f          	j	5a8 <_start+0x5a8>
 5d8:	84818513          	addi	a0,gp,-1976 # 8048 <__DATA_BEGIN__+0x48>
 5dc:	dddff0ef          	jal	3b8 <_start+0x3b8>
 5e0:	00000013          	nop
 5e4:	fec42783          	lw	a5,-20(s0)
 5e8:	00178793          	addi	a5,a5,1
 5ec:	fef42623          	sw	a5,-20(s0)
 5f0:	ff1ff06f          	j	5e0 <_start+0x5e0>
 5f4:	fec42783          	lw	a5,-20(s0)
 5f8:	0007c783          	lbu	a5,0(a5)
 5fc:	00078513          	mv	a0,a5
 600:	d7dff0ef          	jal	37c <_start+0x37c>
 604:	fe842783          	lw	a5,-24(s0)
 608:	00178793          	addi	a5,a5,1
 60c:	fef42423          	sw	a5,-24(s0)
 610:	fec42783          	lw	a5,-20(s0)
 614:	00178793          	addi	a5,a5,1
 618:	fef42623          	sw	a5,-20(s0)
 61c:	fec42783          	lw	a5,-20(s0)
 620:	0007c783          	lbu	a5,0(a5)
 624:	00078463          	beqz	a5,62c <_start+0x62c>
 628:	ed1ff06f          	j	4f8 <_start+0x4f8>
 62c:	00000013          	nop
 630:	00000013          	nop
 634:	03c12083          	lw	ra,60(sp)
 638:	03812403          	lw	s0,56(sp)
 63c:	06010113          	addi	sp,sp,96
 640:	00008067          	ret
 644:	ff010113          	addi	sp,sp,-16
 648:	00112623          	sw	ra,12(sp)
 64c:	00812423          	sw	s0,8(sp)
 650:	01010413          	addi	s0,sp,16
 654:	00000593          	li	a1,0
 658:	00000513          	li	a0,0
 65c:	9b9ff0ef          	jal	14 <_start+0x14>
 660:	00000013          	nop
 664:	00c12083          	lw	ra,12(sp)
 668:	00812403          	lw	s0,8(sp)
 66c:	01010113          	addi	sp,sp,16
 670:	00008067          	ret
 674:	00055463          	bgez	a0,67c <_start+0x67c>
 678:	01c0006f          	j	694 <_start+0x694>
 67c:	0005d463          	bgez	a1,684 <_start+0x684>
 680:	0240006f          	j	6a4 <_start+0x6a4>
 684:	00058613          	mv	a2,a1
 688:	00050593          	mv	a1,a0
 68c:	fff00513          	li	a0,-1
 690:	00061463          	bnez	a2,698 <_start+0x698>
 694:	fedff06f          	j	680 <_start+0x680>
 698:	00100693          	li	a3,1
 69c:	00b66463          	bltu	a2,a1,6a4 <_start+0x6a4>
 6a0:	fc5ff06f          	j	664 <_start+0x664>
 6a4:	00c04463          	bgtz	a2,6ac <_start+0x6ac>
 6a8:	fbdff06f          	j	664 <_start+0x664>
 6ac:	00161613          	slli	a2,a2,0x1
 6b0:	00169693          	slli	a3,a3,0x1
 6b4:	00b67463          	bgeu	a2,a1,6bc <_start+0x6bc>
 6b8:	f9dff06f          	j	654 <_start+0x654>
 6bc:	00000513          	li	a0,0
 6c0:	00c5f463          	bgeu	a1,a2,6c8 <_start+0x6c8>
 6c4:	fb1ff06f          	j	674 <_start+0x674>
 6c8:	40c585b3          	sub	a1,a1,a2
 6cc:	00d56533          	or	a0,a0,a3
 6d0:	0016d693          	srli	a3,a3,0x1
 6d4:	00165613          	srli	a2,a2,0x1
 6d8:	00068463          	beqz	a3,6e0 <_start+0x6e0>
 6dc:	f8dff06f          	j	668 <_start+0x668>
 6e0:	00008067          	ret
 6e4:	00008293          	mv	t0,ra
 6e8:	f55ff0ef          	jal	63c <_start+0x63c>
 6ec:	00058513          	mv	a0,a1
 6f0:	00028067          	jr	t0
 6f4:	40a00533          	neg	a0,a0
 6f8:	00b05463          	blez	a1,700 <_start+0x700>
 6fc:	fadff06f          	j	6a8 <_start+0x6a8>
 700:	40b005b3          	neg	a1,a1
 704:	f39ff06f          	j	63c <_start+0x63c>
 708:	40b005b3          	neg	a1,a1
 70c:	00008293          	mv	t0,ra
 710:	f2dff0ef          	jal	63c <_start+0x63c>
 714:	40a00533          	neg	a0,a0
 718:	00028067          	jr	t0
 71c:	00008293          	mv	t0,ra
 720:	0005d463          	bgez	a1,728 <_start+0x728>
 724:	fadff06f          	j	6d0 <_start+0x6d0>
 728:	00055463          	bgez	a0,730 <_start+0x730>
 72c:	fadff06f          	j	6d8 <_start+0x6d8>
 730:	f0dff0ef          	jal	63c <_start+0x63c>
 734:	00058513          	mv	a0,a1
 738:	00028067          	jr	t0
 73c:	40b005b3          	neg	a1,a1
 740:	00054463          	bltz	a0,748 <_start+0x748>
 744:	f81ff06f          	j	6c4 <_start+0x6c4>
 748:	40a00533          	neg	a0,a0
 74c:	ef1ff0ef          	jal	63c <_start+0x63c>
 750:	40b00533          	neg	a0,a1
 754:	00028067          	jr	t0
