
hsort.bin      檔案格式 binary


.data 區段的反組譯：

80000000 <.data>:
80000000:	00009197          	auipc	gp,0x9
80000004:	80018193          	addi	gp,gp,-2048 # 0x80008800
80000008:	00010117          	auipc	sp,0x10
8000000c:	ff710113          	addi	sp,sp,-9 # 0x8000ffff
80000010:	2c80006f          	jal	zero,0x800002d8
80000014:	ff810113          	addi	sp,sp,-8
80000018:	00a12023          	sw	a0,0(sp)
8000001c:	00b12223          	sw	a1,4(sp)
80000020:	00000073          	ecall
80000024:	00012503          	lw	a0,0(sp)
80000028:	00412583          	lw	a1,4(sp)
8000002c:	00810113          	addi	sp,sp,8
80000030:	00008067          	jalr	zero,0(ra)
80000034:	fd010113          	addi	sp,sp,-48
80000038:	02812623          	sw	s0,44(sp)
8000003c:	03010413          	addi	s0,sp,48
80000040:	fca42e23          	sw	a0,-36(s0)
80000044:	fcb42c23          	sw	a1,-40(s0)
80000048:	fdc42783          	lw	a5,-36(s0)
8000004c:	0007a783          	lw	a5,0(a5)
80000050:	fef42623          	sw	a5,-20(s0)
80000054:	fd842783          	lw	a5,-40(s0)
80000058:	0007a703          	lw	a4,0(a5)
8000005c:	fdc42783          	lw	a5,-36(s0)
80000060:	00e7a023          	sw	a4,0(a5)
80000064:	fd842783          	lw	a5,-40(s0)
80000068:	fec42703          	lw	a4,-20(s0)
8000006c:	00e7a023          	sw	a4,0(a5)
80000070:	00000013          	addi	zero,zero,0
80000074:	02c12403          	lw	s0,44(sp)
80000078:	03010113          	addi	sp,sp,48
8000007c:	00008067          	jalr	zero,0(ra)
80000080:	fd010113          	addi	sp,sp,-48
80000084:	02112623          	sw	ra,44(sp)
80000088:	02812423          	sw	s0,40(sp)
8000008c:	03010413          	addi	s0,sp,48
80000090:	fca42e23          	sw	a0,-36(s0)
80000094:	fcb42c23          	sw	a1,-40(s0)
80000098:	fcc42a23          	sw	a2,-44(s0)
8000009c:	fd442783          	lw	a5,-44(s0)
800000a0:	fef42623          	sw	a5,-20(s0)
800000a4:	fd442783          	lw	a5,-44(s0)
800000a8:	00179793          	slli	a5,a5,0x1
800000ac:	00178793          	addi	a5,a5,1
800000b0:	fef42423          	sw	a5,-24(s0)
800000b4:	fd442783          	lw	a5,-44(s0)
800000b8:	00178793          	addi	a5,a5,1
800000bc:	00179793          	slli	a5,a5,0x1
800000c0:	fef42223          	sw	a5,-28(s0)
800000c4:	fe842703          	lw	a4,-24(s0)
800000c8:	fd842783          	lw	a5,-40(s0)
800000cc:	02f75c63          	bge	a4,a5,0x80000104
800000d0:	fe842783          	lw	a5,-24(s0)
800000d4:	00279793          	slli	a5,a5,0x2
800000d8:	fdc42703          	lw	a4,-36(s0)
800000dc:	00f707b3          	add	a5,a4,a5
800000e0:	0007a703          	lw	a4,0(a5)
800000e4:	fec42783          	lw	a5,-20(s0)
800000e8:	00279793          	slli	a5,a5,0x2
800000ec:	fdc42683          	lw	a3,-36(s0)
800000f0:	00f687b3          	add	a5,a3,a5
800000f4:	0007a783          	lw	a5,0(a5)
800000f8:	00e7d663          	bge	a5,a4,0x80000104
800000fc:	fe842783          	lw	a5,-24(s0)
80000100:	fef42623          	sw	a5,-20(s0)
80000104:	fe442703          	lw	a4,-28(s0)
80000108:	fd842783          	lw	a5,-40(s0)
8000010c:	02f75c63          	bge	a4,a5,0x80000144
80000110:	fe442783          	lw	a5,-28(s0)
80000114:	00279793          	slli	a5,a5,0x2
80000118:	fdc42703          	lw	a4,-36(s0)
8000011c:	00f707b3          	add	a5,a4,a5
80000120:	0007a703          	lw	a4,0(a5)
80000124:	fec42783          	lw	a5,-20(s0)
80000128:	00279793          	slli	a5,a5,0x2
8000012c:	fdc42683          	lw	a3,-36(s0)
80000130:	00f687b3          	add	a5,a3,a5
80000134:	0007a783          	lw	a5,0(a5)
80000138:	00e7d663          	bge	a5,a4,0x80000144
8000013c:	fe442783          	lw	a5,-28(s0)
80000140:	fef42623          	sw	a5,-20(s0)
80000144:	fec42703          	lw	a4,-20(s0)
80000148:	fd442783          	lw	a5,-44(s0)
8000014c:	04f70063          	beq	a4,a5,0x8000018c
80000150:	fd442783          	lw	a5,-44(s0)
80000154:	00279793          	slli	a5,a5,0x2
80000158:	fdc42703          	lw	a4,-36(s0)
8000015c:	00f706b3          	add	a3,a4,a5
80000160:	fec42783          	lw	a5,-20(s0)
80000164:	00279793          	slli	a5,a5,0x2
80000168:	fdc42703          	lw	a4,-36(s0)
8000016c:	00f707b3          	add	a5,a4,a5
80000170:	00078593          	addi	a1,a5,0
80000174:	00068513          	addi	a0,a3,0
80000178:	ebdff0ef          	jal	ra,0x80000034
8000017c:	fec42603          	lw	a2,-20(s0)
80000180:	fd842583          	lw	a1,-40(s0)
80000184:	fdc42503          	lw	a0,-36(s0)
80000188:	ef9ff0ef          	jal	ra,0x80000080
8000018c:	00000013          	addi	zero,zero,0
80000190:	02c12083          	lw	ra,44(sp)
80000194:	02812403          	lw	s0,40(sp)
80000198:	03010113          	addi	sp,sp,48
8000019c:	00008067          	jalr	zero,0(ra)
800001a0:	fd010113          	addi	sp,sp,-48
800001a4:	02112623          	sw	ra,44(sp)
800001a8:	02812423          	sw	s0,40(sp)
800001ac:	03010413          	addi	s0,sp,48
800001b0:	fca42e23          	sw	a0,-36(s0)
800001b4:	fcb42c23          	sw	a1,-40(s0)
800001b8:	fd842783          	lw	a5,-40(s0)
800001bc:	01f7d713          	srli	a4,a5,0x1f
800001c0:	00f707b3          	add	a5,a4,a5
800001c4:	4017d793          	srai	a5,a5,0x1
800001c8:	fff78793          	addi	a5,a5,-1
800001cc:	fef42623          	sw	a5,-20(s0)
800001d0:	0200006f          	jal	zero,0x800001f0
800001d4:	fec42603          	lw	a2,-20(s0)
800001d8:	fd842583          	lw	a1,-40(s0)
800001dc:	fdc42503          	lw	a0,-36(s0)
800001e0:	ea1ff0ef          	jal	ra,0x80000080
800001e4:	fec42783          	lw	a5,-20(s0)
800001e8:	fff78793          	addi	a5,a5,-1
800001ec:	fef42623          	sw	a5,-20(s0)
800001f0:	fec42783          	lw	a5,-20(s0)
800001f4:	fe07d0e3          	bge	a5,zero,0x800001d4
800001f8:	fd842783          	lw	a5,-40(s0)
800001fc:	fff78793          	addi	a5,a5,-1
80000200:	fef42423          	sw	a5,-24(s0)
80000204:	03c0006f          	jal	zero,0x80000240
80000208:	fe842783          	lw	a5,-24(s0)
8000020c:	00279793          	slli	a5,a5,0x2
80000210:	fdc42703          	lw	a4,-36(s0)
80000214:	00f707b3          	add	a5,a4,a5
80000218:	00078593          	addi	a1,a5,0
8000021c:	fdc42503          	lw	a0,-36(s0)
80000220:	e15ff0ef          	jal	ra,0x80000034
80000224:	00000613          	addi	a2,zero,0
80000228:	fe842583          	lw	a1,-24(s0)
8000022c:	fdc42503          	lw	a0,-36(s0)
80000230:	e51ff0ef          	jal	ra,0x80000080
80000234:	fe842783          	lw	a5,-24(s0)
80000238:	fff78793          	addi	a5,a5,-1
8000023c:	fef42423          	sw	a5,-24(s0)
80000240:	fe842783          	lw	a5,-24(s0)
80000244:	fc07d2e3          	bge	a5,zero,0x80000208
80000248:	00000013          	addi	zero,zero,0
8000024c:	00000013          	addi	zero,zero,0
80000250:	02c12083          	lw	ra,44(sp)
80000254:	02812403          	lw	s0,40(sp)
80000258:	03010113          	addi	sp,sp,48
8000025c:	00008067          	jalr	zero,0(ra)
80000260:	fd010113          	addi	sp,sp,-48
80000264:	02112623          	sw	ra,44(sp)
80000268:	02812423          	sw	s0,40(sp)
8000026c:	03010413          	addi	s0,sp,48
80000270:	fca42e23          	sw	a0,-36(s0)
80000274:	fcb42c23          	sw	a1,-40(s0)
80000278:	fe042623          	sw	zero,-20(s0)
8000027c:	0340006f          	jal	zero,0x800002b0
80000280:	fec42783          	lw	a5,-20(s0)
80000284:	00279793          	slli	a5,a5,0x2
80000288:	fdc42703          	lw	a4,-36(s0)
8000028c:	00f707b3          	add	a5,a4,a5
80000290:	0007a783          	lw	a5,0(a5)
80000294:	00078593          	addi	a1,a5,0
80000298:	000087b7          	lui	a5,0x8
8000029c:	00078513          	addi	a0,a5,0 # 0x8000
800002a0:	204000ef          	jal	ra,0x800004a4
800002a4:	fec42783          	lw	a5,-20(s0)
800002a8:	00178793          	addi	a5,a5,1
800002ac:	fef42623          	sw	a5,-20(s0)
800002b0:	fec42703          	lw	a4,-20(s0)
800002b4:	fd842783          	lw	a5,-40(s0)
800002b8:	fcf744e3          	blt	a4,a5,0x80000280
800002bc:	00a00513          	addi	a0,zero,10
800002c0:	0bc000ef          	jal	ra,0x8000037c
800002c4:	00000013          	addi	zero,zero,0
800002c8:	02c12083          	lw	ra,44(sp)
800002cc:	02812403          	lw	s0,40(sp)
800002d0:	03010113          	addi	sp,sp,48
800002d4:	00008067          	jalr	zero,0(ra)
800002d8:	fd010113          	addi	sp,sp,-48
800002dc:	02112623          	sw	ra,44(sp)
800002e0:	02812423          	sw	s0,40(sp)
800002e4:	03010413          	addi	s0,sp,48
800002e8:	83018793          	addi	a5,gp,-2000
800002ec:	0007a503          	lw	a0,0(a5)
800002f0:	0047a583          	lw	a1,4(a5)
800002f4:	0087a603          	lw	a2,8(a5)
800002f8:	00c7a683          	lw	a3,12(a5)
800002fc:	0107a703          	lw	a4,16(a5)
80000300:	0147a783          	lw	a5,20(a5)
80000304:	fca42a23          	sw	a0,-44(s0)
80000308:	fcb42c23          	sw	a1,-40(s0)
8000030c:	fcc42e23          	sw	a2,-36(s0)
80000310:	fed42023          	sw	a3,-32(s0)
80000314:	fee42223          	sw	a4,-28(s0)
80000318:	fef42423          	sw	a5,-24(s0)
8000031c:	00600793          	addi	a5,zero,6
80000320:	fef42623          	sw	a5,-20(s0)
80000324:	80418513          	addi	a0,gp,-2044
80000328:	090000ef          	jal	ra,0x800003b8
8000032c:	fd440793          	addi	a5,s0,-44
80000330:	fec42583          	lw	a1,-20(s0)
80000334:	00078513          	addi	a0,a5,0
80000338:	f29ff0ef          	jal	ra,0x80000260
8000033c:	fd440793          	addi	a5,s0,-44
80000340:	fec42583          	lw	a1,-20(s0)
80000344:	00078513          	addi	a0,a5,0
80000348:	e59ff0ef          	jal	ra,0x800001a0
8000034c:	81c18513          	addi	a0,gp,-2020
80000350:	068000ef          	jal	ra,0x800003b8
80000354:	fd440793          	addi	a5,s0,-44
80000358:	fec42583          	lw	a1,-20(s0)
8000035c:	00078513          	addi	a0,a5,0
80000360:	f01ff0ef          	jal	ra,0x80000260
80000364:	2a0000ef          	jal	ra,0x80000604
80000368:	00000013          	addi	zero,zero,0
8000036c:	02c12083          	lw	ra,44(sp)
80000370:	02812403          	lw	s0,40(sp)
80000374:	03010113          	addi	sp,sp,48
80000378:	00008067          	jalr	zero,0(ra)
8000037c:	fe010113          	addi	sp,sp,-32
80000380:	00112e23          	sw	ra,28(sp)
80000384:	00812c23          	sw	s0,24(sp)
80000388:	02010413          	addi	s0,sp,32
8000038c:	00050793          	addi	a5,a0,0
80000390:	fef407a3          	sb	a5,-17(s0)
80000394:	fef44783          	lbu	a5,-17(s0)
80000398:	00078593          	addi	a1,a5,0
8000039c:	00100513          	addi	a0,zero,1
800003a0:	c75ff0ef          	jal	ra,0x80000014
800003a4:	00000013          	addi	zero,zero,0
800003a8:	01c12083          	lw	ra,28(sp)
800003ac:	01812403          	lw	s0,24(sp)
800003b0:	02010113          	addi	sp,sp,32
800003b4:	00008067          	jalr	zero,0(ra)
800003b8:	fe010113          	addi	sp,sp,-32
800003bc:	00112e23          	sw	ra,28(sp)
800003c0:	00812c23          	sw	s0,24(sp)
800003c4:	02010413          	addi	s0,sp,32
800003c8:	fea42623          	sw	a0,-20(s0)
800003cc:	01c0006f          	jal	zero,0x800003e8
800003d0:	fec42783          	lw	a5,-20(s0)
800003d4:	00178713          	addi	a4,a5,1
800003d8:	fee42623          	sw	a4,-20(s0)
800003dc:	0007c783          	lbu	a5,0(a5)
800003e0:	00078513          	addi	a0,a5,0
800003e4:	f99ff0ef          	jal	ra,0x8000037c
800003e8:	fec42783          	lw	a5,-20(s0)
800003ec:	0007c783          	lbu	a5,0(a5)
800003f0:	fe0790e3          	bne	a5,zero,0x800003d0
800003f4:	00000013          	addi	zero,zero,0
800003f8:	00000013          	addi	zero,zero,0
800003fc:	01c12083          	lw	ra,28(sp)
80000400:	01812403          	lw	s0,24(sp)
80000404:	02010113          	addi	sp,sp,32
80000408:	00008067          	jalr	zero,0(ra)
8000040c:	fe010113          	addi	sp,sp,-32
80000410:	00112e23          	sw	ra,28(sp)
80000414:	00812c23          	sw	s0,24(sp)
80000418:	02010413          	addi	s0,sp,32
8000041c:	fea42623          	sw	a0,-20(s0)
80000420:	fec42783          	lw	a5,-20(s0)
80000424:	0007dc63          	bge	a5,zero,0x8000043c
80000428:	02d00513          	addi	a0,zero,45
8000042c:	f51ff0ef          	jal	ra,0x8000037c
80000430:	fec42783          	lw	a5,-20(s0)
80000434:	40f007b3          	sub	a5,zero,a5
80000438:	fef42623          	sw	a5,-20(s0)
8000043c:	fec42783          	lw	a5,-20(s0)
80000440:	00978713          	addi	a4,a5,9
80000444:	01200793          	addi	a5,zero,18
80000448:	02e7f063          	bgeu	a5,a4,0x80000468
8000044c:	fec42783          	lw	a5,-20(s0)
80000450:	00a00593          	addi	a1,zero,10
80000454:	00078513          	addi	a0,a5,0
80000458:	1dc000ef          	jal	ra,0x80000634
8000045c:	00050793          	addi	a5,a0,0
80000460:	00078513          	addi	a0,a5,0
80000464:	fa9ff0ef          	jal	ra,0x8000040c
80000468:	fec42783          	lw	a5,-20(s0)
8000046c:	00a00593          	addi	a1,zero,10
80000470:	00078513          	addi	a0,a5,0
80000474:	244000ef          	jal	ra,0x800006b8
80000478:	00050793          	addi	a5,a0,0
8000047c:	0ff7f793          	andi	a5,a5,255
80000480:	03078793          	addi	a5,a5,48
80000484:	0ff7f793          	andi	a5,a5,255
80000488:	00078513          	addi	a0,a5,0
8000048c:	ef1ff0ef          	jal	ra,0x8000037c
80000490:	00000013          	addi	zero,zero,0
80000494:	01c12083          	lw	ra,28(sp)
80000498:	01812403          	lw	s0,24(sp)
8000049c:	02010113          	addi	sp,sp,32
800004a0:	00008067          	jalr	zero,0(ra)
800004a4:	fa010113          	addi	sp,sp,-96
800004a8:	02112e23          	sw	ra,60(sp)
800004ac:	02812c23          	sw	s0,56(sp)
800004b0:	04010413          	addi	s0,sp,64
800004b4:	fca42623          	sw	a0,-52(s0)
800004b8:	00b42223          	sw	a1,4(s0)
800004bc:	00c42423          	sw	a2,8(s0)
800004c0:	00d42623          	sw	a3,12(s0)
800004c4:	00e42823          	sw	a4,16(s0)
800004c8:	00f42a23          	sw	a5,20(s0)
800004cc:	01042c23          	sw	a6,24(s0)
800004d0:	01142e23          	sw	a7,28(s0)
800004d4:	fcc42783          	lw	a5,-52(s0)
800004d8:	fef42623          	sw	a5,-20(s0)
800004dc:	fe042423          	sw	zero,-24(s0)
800004e0:	02040793          	addi	a5,s0,32
800004e4:	fcf42423          	sw	a5,-56(s0)
800004e8:	fc842783          	lw	a5,-56(s0)
800004ec:	fe478793          	addi	a5,a5,-28
800004f0:	fcf42e23          	sw	a5,-36(s0)
800004f4:	0ec0006f          	jal	zero,0x800005e0
800004f8:	fec42783          	lw	a5,-20(s0)
800004fc:	0007c703          	lbu	a4,0(a5)
80000500:	02500793          	addi	a5,zero,37
80000504:	0af71a63          	bne	a4,a5,0x800005b8
80000508:	fec42783          	lw	a5,-20(s0)
8000050c:	00178793          	addi	a5,a5,1
80000510:	fef42623          	sw	a5,-20(s0)
80000514:	fec42783          	lw	a5,-20(s0)
80000518:	0007c783          	lbu	a5,0(a5)
8000051c:	06400713          	addi	a4,zero,100
80000520:	04e78e63          	beq	a5,a4,0x8000057c
80000524:	07300713          	addi	a4,zero,115
80000528:	06e79a63          	bne	a5,a4,0x8000059c
8000052c:	fdc42783          	lw	a5,-36(s0)
80000530:	00478713          	addi	a4,a5,4
80000534:	fce42e23          	sw	a4,-36(s0)
80000538:	0007a783          	lw	a5,0(a5)
8000053c:	fef42223          	sw	a5,-28(s0)
80000540:	02c0006f          	jal	zero,0x8000056c
80000544:	fe442783          	lw	a5,-28(s0)
80000548:	0007c783          	lbu	a5,0(a5)
8000054c:	00078513          	addi	a0,a5,0
80000550:	e2dff0ef          	jal	ra,0x8000037c
80000554:	fe842783          	lw	a5,-24(s0)
80000558:	00178793          	addi	a5,a5,1
8000055c:	fef42423          	sw	a5,-24(s0)
80000560:	fe442783          	lw	a5,-28(s0)
80000564:	00178793          	addi	a5,a5,1
80000568:	fef42223          	sw	a5,-28(s0)
8000056c:	fe442783          	lw	a5,-28(s0)
80000570:	0007c783          	lbu	a5,0(a5)
80000574:	fc0798e3          	bne	a5,zero,0x80000544
80000578:	0300006f          	jal	zero,0x800005a8
8000057c:	fdc42783          	lw	a5,-36(s0)
80000580:	00478713          	addi	a4,a5,4
80000584:	fce42e23          	sw	a4,-36(s0)
80000588:	0007a783          	lw	a5,0(a5)
8000058c:	fef42023          	sw	a5,-32(s0)
80000590:	fe042503          	lw	a0,-32(s0)
80000594:	e79ff0ef          	jal	ra,0x8000040c
80000598:	0100006f          	jal	zero,0x800005a8
8000059c:	84818513          	addi	a0,gp,-1976
800005a0:	e19ff0ef          	jal	ra,0x800003b8
800005a4:	00000013          	addi	zero,zero,0
800005a8:	fec42783          	lw	a5,-20(s0)
800005ac:	00178793          	addi	a5,a5,1
800005b0:	fef42623          	sw	a5,-20(s0)
800005b4:	02c0006f          	jal	zero,0x800005e0
800005b8:	fec42783          	lw	a5,-20(s0)
800005bc:	0007c783          	lbu	a5,0(a5)
800005c0:	00078513          	addi	a0,a5,0
800005c4:	db9ff0ef          	jal	ra,0x8000037c
800005c8:	fe842783          	lw	a5,-24(s0)
800005cc:	00178793          	addi	a5,a5,1
800005d0:	fef42423          	sw	a5,-24(s0)
800005d4:	fec42783          	lw	a5,-20(s0)
800005d8:	00178793          	addi	a5,a5,1
800005dc:	fef42623          	sw	a5,-20(s0)
800005e0:	fec42783          	lw	a5,-20(s0)
800005e4:	0007c783          	lbu	a5,0(a5)
800005e8:	f00798e3          	bne	a5,zero,0x800004f8
800005ec:	00000013          	addi	zero,zero,0
800005f0:	00000013          	addi	zero,zero,0
800005f4:	03c12083          	lw	ra,60(sp)
800005f8:	03812403          	lw	s0,56(sp)
800005fc:	06010113          	addi	sp,sp,96
80000600:	00008067          	jalr	zero,0(ra)
80000604:	ff010113          	addi	sp,sp,-16
80000608:	00112623          	sw	ra,12(sp)
8000060c:	00812423          	sw	s0,8(sp)
80000610:	01010413          	addi	s0,sp,16
80000614:	00000593          	addi	a1,zero,0
80000618:	00000513          	addi	a0,zero,0
8000061c:	9f9ff0ef          	jal	ra,0x80000014
80000620:	00000013          	addi	zero,zero,0
80000624:	00c12083          	lw	ra,12(sp)
80000628:	00812403          	lw	s0,8(sp)
8000062c:	01010113          	addi	sp,sp,16
80000630:	00008067          	jalr	zero,0(ra)
80000634:	06054063          	blt	a0,zero,0x80000694
80000638:	0605c663          	blt	a1,zero,0x800006a4
8000063c:	00058613          	addi	a2,a1,0
80000640:	00050593          	addi	a1,a0,0
80000644:	fff00513          	addi	a0,zero,-1
80000648:	02060c63          	beq	a2,zero,0x80000680
8000064c:	00100693          	addi	a3,zero,1
80000650:	00b67a63          	bgeu	a2,a1,0x80000664
80000654:	00c05863          	bge	zero,a2,0x80000664
80000658:	00161613          	slli	a2,a2,0x1
8000065c:	00169693          	slli	a3,a3,0x1
80000660:	feb66ae3          	bltu	a2,a1,0x80000654
80000664:	00000513          	addi	a0,zero,0
80000668:	00c5e663          	bltu	a1,a2,0x80000674
8000066c:	40c585b3          	sub	a1,a1,a2
80000670:	00d56533          	or	a0,a0,a3
80000674:	0016d693          	srli	a3,a3,0x1
80000678:	00165613          	srli	a2,a2,0x1
8000067c:	fe0696e3          	bne	a3,zero,0x80000668
80000680:	00008067          	jalr	zero,0(ra)
80000684:	00008293          	addi	t0,ra,0
80000688:	fb5ff0ef          	jal	ra,0x8000063c
8000068c:	00058513          	addi	a0,a1,0
80000690:	00028067          	jalr	zero,0(t0)
80000694:	40a00533          	sub	a0,zero,a0
80000698:	00b04863          	blt	zero,a1,0x800006a8
8000069c:	40b005b3          	sub	a1,zero,a1
800006a0:	f9dff06f          	jal	zero,0x8000063c
800006a4:	40b005b3          	sub	a1,zero,a1
800006a8:	00008293          	addi	t0,ra,0
800006ac:	f91ff0ef          	jal	ra,0x8000063c
800006b0:	40a00533          	sub	a0,zero,a0
800006b4:	00028067          	jalr	zero,0(t0)
800006b8:	00008293          	addi	t0,ra,0
800006bc:	0005ca63          	blt	a1,zero,0x800006d0
800006c0:	00054c63          	blt	a0,zero,0x800006d8
800006c4:	f79ff0ef          	jal	ra,0x8000063c
800006c8:	00058513          	addi	a0,a1,0
800006cc:	00028067          	jalr	zero,0(t0)
800006d0:	40b005b3          	sub	a1,zero,a1
800006d4:	fe0558e3          	bge	a0,zero,0x800006c4
800006d8:	40a00533          	sub	a0,zero,a0
800006dc:	f61ff0ef          	jal	ra,0x8000063c
800006e0:	40b00533          	sub	a0,zero,a1
800006e4:	00028067          	jalr	zero,0(t0)
800006e8:	6425                	c.lui	s0,0x9
800006ea:	0020                	c.addi4spn	s0,sp,8
800006ec:	7241                	c.lui	tp,0xffff0
800006ee:	6172                	c.flwsp	ft2,28(sp)
800006f0:	2079                	c.jal	0x8000077e
800006f2:	6562                	c.flwsp	fa0,24(sp)
800006f4:	6f66                	c.flwsp	ft10,88(sp)
800006f6:	6572                	c.flwsp	fa0,28(sp)
800006f8:	7320                	c.flw	fs0,96(a4)
800006fa:	6574726f          	jal	tp,0x80048550
800006fe:	2064                	c.fld	fs1,192(s0)
80000700:	7369                	c.lui	t1,0xffffa
80000702:	000a                	c.slli	zero,0x2
80000704:	74726f53          	.insn	4, 0x74726f53
80000708:	6465                	c.lui	s0,0x19
8000070a:	6120                	c.flw	fs0,64(a0)
8000070c:	7272                	c.flwsp	ft4,60(sp)
8000070e:	7961                	c.lui	s2,0xffff8
80000710:	6920                	c.flw	fs0,80(a0)
80000712:	00000a73          	.insn	4, 0x0a73
80000716:	0000                	c.unimp
80000718:	000c                	.insn	2, 0x000c
8000071a:	0000                	c.unimp
8000071c:	0000000b          	.insn	4, 0x000b
80000720:	000d                	c.addi	zero,3
80000722:	0000                	c.unimp
80000724:	0005                	c.addi	zero,1
80000726:	0000                	c.unimp
80000728:	0006                	c.slli	zero,0x1
8000072a:	0000                	c.unimp
8000072c:	00000007          	.insn	4, 0x0007
80000730:	7245                	c.lui	tp,0xffff1
80000732:	6f72                	c.flwsp	ft10,28(sp)
80000734:	2172                	c.fldsp	ft2,280(sp)
	...
