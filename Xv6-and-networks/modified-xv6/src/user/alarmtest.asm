
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:
}

volatile static int count;

void periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	ff87a783          	lw	a5,-8(a5) # 1000 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	fef72723          	sw	a5,-18(a4) # 1000 <count>
    printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	ca650513          	addi	a0,a0,-858 # cc0 <malloc+0x108>
  22:	00001097          	auipc	ra,0x1
  26:	ada080e7          	jalr	-1318(ra) # afc <printf>
    sigreturn();
  2a:	00001097          	auipc	ra,0x1
  2e:	80c080e7          	jalr	-2036(ra) # 836 <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
        printf("test2 passed\n");
    }
}

void slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
    count++;
  44:	00001497          	auipc	s1,0x1
  48:	fbc48493          	addi	s1,s1,-68 # 1000 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	fb47a783          	lw	a5,-76(a5) # 1000 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
    printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	c6850513          	addi	a0,a0,-920 # cc0 <malloc+0x108>
  60:	00001097          	auipc	ra,0x1
  64:	a9c080e7          	jalr	-1380(ra) # afc <printf>
    if (count > 1)
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
        printf("test2 failed: alarm handler called more than once\n");
        exit(1);
    }
    for (int i = 0; i < 1000 * 500000; i++)
    {
        asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
    for (int i = 0; i < 1000 * 500000; i++)
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
    }
    sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	7aa080e7          	jalr	1962(ra) # 82e <sigalarm>
    sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	7aa080e7          	jalr	1962(ra) # 836 <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
        printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	c2a50513          	addi	a0,a0,-982 # cc8 <malloc+0x110>
  a6:	00001097          	auipc	ra,0x1
  aa:	a56080e7          	jalr	-1450(ra) # afc <printf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	6ce080e7          	jalr	1742(ra) # 77e <exit>

00000000000000b8 <dummy_handler>:

//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void dummy_handler()
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
    sigalarm(0, 0);
  c0:	4581                	li	a1,0
  c2:	4501                	li	a0,0
  c4:	00000097          	auipc	ra,0x0
  c8:	76a080e7          	jalr	1898(ra) # 82e <sigalarm>
    sigreturn();
  cc:	00000097          	auipc	ra,0x0
  d0:	76a080e7          	jalr	1898(ra) # 836 <sigreturn>
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <test0>:
{
  dc:	715d                	addi	sp,sp,-80
  de:	e486                	sd	ra,72(sp)
  e0:	e0a2                	sd	s0,64(sp)
  e2:	fc26                	sd	s1,56(sp)
  e4:	f84a                	sd	s2,48(sp)
  e6:	f44e                	sd	s3,40(sp)
  e8:	f052                	sd	s4,32(sp)
  ea:	ec56                	sd	s5,24(sp)
  ec:	e85a                	sd	s6,16(sp)
  ee:	e45e                	sd	s7,8(sp)
  f0:	e062                	sd	s8,0(sp)
  f2:	0880                	addi	s0,sp,80
    printf("test0 start\n");
  f4:	00001517          	auipc	a0,0x1
  f8:	c0c50513          	addi	a0,a0,-1012 # d00 <malloc+0x148>
  fc:	00001097          	auipc	ra,0x1
 100:	a00080e7          	jalr	-1536(ra) # afc <printf>
    count = 0;
 104:	00001797          	auipc	a5,0x1
 108:	ee07ae23          	sw	zero,-260(a5) # 1000 <count>
    sigalarm(2, periodic);
 10c:	00000597          	auipc	a1,0x0
 110:	ef458593          	addi	a1,a1,-268 # 0 <periodic>
 114:	4509                	li	a0,2
 116:	00000097          	auipc	ra,0x0
 11a:	718080e7          	jalr	1816(ra) # 82e <sigalarm>
    for (i = 0; i < 1000 * 500000; i++)
 11e:	4481                	li	s1,0
        if ((i % 1000000) == 0)
 120:	431be9b7          	lui	s3,0x431be
 124:	e8398993          	addi	s3,s3,-381 # 431bde83 <base+0x431bce73>
 128:	000f4937          	lui	s2,0xf4
 12c:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf3230>
            write(2, ".", 1);
 130:	4c05                	li	s8,1
 132:	00001b97          	auipc	s7,0x1
 136:	bdeb8b93          	addi	s7,s7,-1058 # d10 <malloc+0x158>
 13a:	4b09                	li	s6,2
        if (count > 0)
 13c:	00001a97          	auipc	s5,0x1
 140:	ec4a8a93          	addi	s5,s5,-316 # 1000 <count>
    for (i = 0; i < 1000 * 500000; i++)
 144:	1dcd6a37          	lui	s4,0x1dcd6
 148:	500a0a13          	addi	s4,s4,1280 # 1dcd6500 <base+0x1dcd54f0>
 14c:	a809                	j	15e <test0+0x82>
        if (count > 0)
 14e:	000aa783          	lw	a5,0(s5)
 152:	2781                	sext.w	a5,a5
 154:	02f04863          	bgtz	a5,184 <test0+0xa8>
    for (i = 0; i < 1000 * 500000; i++)
 158:	2485                	addiw	s1,s1,1
 15a:	03448563          	beq	s1,s4,184 <test0+0xa8>
        if ((i % 1000000) == 0)
 15e:	033487b3          	mul	a5,s1,s3
 162:	97c9                	srai	a5,a5,0x32
 164:	41f4d71b          	sraiw	a4,s1,0x1f
 168:	9f99                	subw	a5,a5,a4
 16a:	02f907bb          	mulw	a5,s2,a5
 16e:	40f487bb          	subw	a5,s1,a5
 172:	fff1                	bnez	a5,14e <test0+0x72>
            write(2, ".", 1);
 174:	8662                	mv	a2,s8
 176:	85de                	mv	a1,s7
 178:	855a                	mv	a0,s6
 17a:	00000097          	auipc	ra,0x0
 17e:	624080e7          	jalr	1572(ra) # 79e <write>
 182:	b7f1                	j	14e <test0+0x72>
    sigalarm(0, 0);
 184:	4581                	li	a1,0
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	6a6080e7          	jalr	1702(ra) # 82e <sigalarm>
    if (count > 0)
 190:	00001797          	auipc	a5,0x1
 194:	e707a783          	lw	a5,-400(a5) # 1000 <count>
 198:	02f05663          	blez	a5,1c4 <test0+0xe8>
        printf("test0 passed\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b7c50513          	addi	a0,a0,-1156 # d18 <malloc+0x160>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	958080e7          	jalr	-1704(ra) # afc <printf>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret
        printf("\ntest0 failed: the kernel never called the alarm handler\n");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	b6450513          	addi	a0,a0,-1180 # d28 <malloc+0x170>
 1cc:	00001097          	auipc	ra,0x1
 1d0:	930080e7          	jalr	-1744(ra) # afc <printf>
}
 1d4:	bfe1                	j	1ac <test0+0xd0>

00000000000001d6 <foo>:
{
 1d6:	1101                	addi	sp,sp,-32
 1d8:	ec06                	sd	ra,24(sp)
 1da:	e822                	sd	s0,16(sp)
 1dc:	e426                	sd	s1,8(sp)
 1de:	1000                	addi	s0,sp,32
 1e0:	84ae                	mv	s1,a1
    if ((i % 2500000) == 0)
 1e2:	6b5fd7b7          	lui	a5,0x6b5fd
 1e6:	a6b78793          	addi	a5,a5,-1429 # 6b5fca6b <base+0x6b5fba5b>
 1ea:	02f507b3          	mul	a5,a0,a5
 1ee:	97d1                	srai	a5,a5,0x34
 1f0:	41f5571b          	sraiw	a4,a0,0x1f
 1f4:	9f99                	subw	a5,a5,a4
 1f6:	00262737          	lui	a4,0x262
 1fa:	5a07071b          	addiw	a4,a4,1440 # 2625a0 <base+0x261590>
 1fe:	02f707bb          	mulw	a5,a4,a5
 202:	9d1d                	subw	a0,a0,a5
 204:	c909                	beqz	a0,216 <foo+0x40>
    *j += 1;
 206:	409c                	lw	a5,0(s1)
 208:	2785                	addiw	a5,a5,1
 20a:	c09c                	sw	a5,0(s1)
}
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	64a2                	ld	s1,8(sp)
 212:	6105                	addi	sp,sp,32
 214:	8082                	ret
        write(2, ".", 1);
 216:	4605                	li	a2,1
 218:	00001597          	auipc	a1,0x1
 21c:	af858593          	addi	a1,a1,-1288 # d10 <malloc+0x158>
 220:	4509                	li	a0,2
 222:	00000097          	auipc	ra,0x0
 226:	57c080e7          	jalr	1404(ra) # 79e <write>
 22a:	bff1                	j	206 <foo+0x30>

000000000000022c <test1>:
{
 22c:	715d                	addi	sp,sp,-80
 22e:	e486                	sd	ra,72(sp)
 230:	e0a2                	sd	s0,64(sp)
 232:	fc26                	sd	s1,56(sp)
 234:	f84a                	sd	s2,48(sp)
 236:	f44e                	sd	s3,40(sp)
 238:	f052                	sd	s4,32(sp)
 23a:	ec56                	sd	s5,24(sp)
 23c:	0880                	addi	s0,sp,80
    printf("test1 start\n");
 23e:	00001517          	auipc	a0,0x1
 242:	b2a50513          	addi	a0,a0,-1238 # d68 <malloc+0x1b0>
 246:	00001097          	auipc	ra,0x1
 24a:	8b6080e7          	jalr	-1866(ra) # afc <printf>
    count = 0;
 24e:	00001797          	auipc	a5,0x1
 252:	da07a923          	sw	zero,-590(a5) # 1000 <count>
    j = 0;
 256:	fa042e23          	sw	zero,-68(s0)
    sigalarm(2, periodic);
 25a:	00000597          	auipc	a1,0x0
 25e:	da658593          	addi	a1,a1,-602 # 0 <periodic>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	5ca080e7          	jalr	1482(ra) # 82e <sigalarm>
    for (i = 0; i < 500000000; i++)
 26c:	4481                	li	s1,0
        if (count >= 10)
 26e:	00001a17          	auipc	s4,0x1
 272:	d92a0a13          	addi	s4,s4,-622 # 1000 <count>
 276:	49a5                	li	s3,9
        foo(i, &j);
 278:	fbc40a93          	addi	s5,s0,-68
    for (i = 0; i < 500000000; i++)
 27c:	1dcd6937          	lui	s2,0x1dcd6
 280:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd54f0>
        if (count >= 10)
 284:	000a2783          	lw	a5,0(s4)
 288:	2781                	sext.w	a5,a5
 28a:	00f9cb63          	blt	s3,a5,2a0 <test1+0x74>
        foo(i, &j);
 28e:	85d6                	mv	a1,s5
 290:	8526                	mv	a0,s1
 292:	00000097          	auipc	ra,0x0
 296:	f44080e7          	jalr	-188(ra) # 1d6 <foo>
    for (i = 0; i < 500000000; i++)
 29a:	2485                	addiw	s1,s1,1
 29c:	ff2494e3          	bne	s1,s2,284 <test1+0x58>
    if (count < 10)
 2a0:	00001717          	auipc	a4,0x1
 2a4:	d6072703          	lw	a4,-672(a4) # 1000 <count>
 2a8:	47a5                	li	a5,9
 2aa:	02e7d763          	bge	a5,a4,2d8 <test1+0xac>
    else if (i != j)
 2ae:	fbc42783          	lw	a5,-68(s0)
 2b2:	02978c63          	beq	a5,s1,2ea <test1+0xbe>
        printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	af250513          	addi	a0,a0,-1294 # da8 <malloc+0x1f0>
 2be:	00001097          	auipc	ra,0x1
 2c2:	83e080e7          	jalr	-1986(ra) # afc <printf>
}
 2c6:	60a6                	ld	ra,72(sp)
 2c8:	6406                	ld	s0,64(sp)
 2ca:	74e2                	ld	s1,56(sp)
 2cc:	7942                	ld	s2,48(sp)
 2ce:	79a2                	ld	s3,40(sp)
 2d0:	7a02                	ld	s4,32(sp)
 2d2:	6ae2                	ld	s5,24(sp)
 2d4:	6161                	addi	sp,sp,80
 2d6:	8082                	ret
        printf("\ntest1 failed: too few calls to the handler\n");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	aa050513          	addi	a0,a0,-1376 # d78 <malloc+0x1c0>
 2e0:	00001097          	auipc	ra,0x1
 2e4:	81c080e7          	jalr	-2020(ra) # afc <printf>
 2e8:	bff9                	j	2c6 <test1+0x9a>
        printf("test1 passed\n");
 2ea:	00001517          	auipc	a0,0x1
 2ee:	afe50513          	addi	a0,a0,-1282 # de8 <malloc+0x230>
 2f2:	00001097          	auipc	ra,0x1
 2f6:	80a080e7          	jalr	-2038(ra) # afc <printf>
}
 2fa:	b7f1                	j	2c6 <test1+0x9a>

00000000000002fc <test2>:
{
 2fc:	711d                	addi	sp,sp,-96
 2fe:	ec86                	sd	ra,88(sp)
 300:	e8a2                	sd	s0,80(sp)
 302:	1080                	addi	s0,sp,96
    printf("test2 start\n");
 304:	00001517          	auipc	a0,0x1
 308:	af450513          	addi	a0,a0,-1292 # df8 <malloc+0x240>
 30c:	00000097          	auipc	ra,0x0
 310:	7f0080e7          	jalr	2032(ra) # afc <printf>
    if ((pid = fork()) < 0)
 314:	00000097          	auipc	ra,0x0
 318:	462080e7          	jalr	1122(ra) # 776 <fork>
 31c:	06054063          	bltz	a0,37c <test2+0x80>
 320:	e4a6                	sd	s1,72(sp)
 322:	84aa                	mv	s1,a0
    if (pid == 0)
 324:	e17d                	bnez	a0,40a <test2+0x10e>
 326:	e0ca                	sd	s2,64(sp)
 328:	fc4e                	sd	s3,56(sp)
 32a:	f852                	sd	s4,48(sp)
 32c:	f456                	sd	s5,40(sp)
 32e:	f05a                	sd	s6,32(sp)
 330:	ec5e                	sd	s7,24(sp)
 332:	e862                	sd	s8,16(sp)
        count = 0;
 334:	00001797          	auipc	a5,0x1
 338:	cc07a623          	sw	zero,-820(a5) # 1000 <count>
        sigalarm(2, slow_handler);
 33c:	00000597          	auipc	a1,0x0
 340:	cfe58593          	addi	a1,a1,-770 # 3a <slow_handler>
 344:	4509                	li	a0,2
 346:	00000097          	auipc	ra,0x0
 34a:	4e8080e7          	jalr	1256(ra) # 82e <sigalarm>
            if ((i % 1000000) == 0)
 34e:	431be9b7          	lui	s3,0x431be
 352:	e8398993          	addi	s3,s3,-381 # 431bde83 <base+0x431bce73>
 356:	000f4937          	lui	s2,0xf4
 35a:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf3230>
                write(2, ".", 1);
 35e:	4c05                	li	s8,1
 360:	00001b97          	auipc	s7,0x1
 364:	9b0b8b93          	addi	s7,s7,-1616 # d10 <malloc+0x158>
 368:	4b09                	li	s6,2
            if (count > 0)
 36a:	00001a97          	auipc	s5,0x1
 36e:	c96a8a93          	addi	s5,s5,-874 # 1000 <count>
        for (i = 0; i < 1000 * 500000; i++)
 372:	1dcd6a37          	lui	s4,0x1dcd6
 376:	500a0a13          	addi	s4,s4,1280 # 1dcd6500 <base+0x1dcd54f0>
 37a:	a835                	j	3b6 <test2+0xba>
        printf("test2: fork failed\n");
 37c:	00001517          	auipc	a0,0x1
 380:	a8c50513          	addi	a0,a0,-1396 # e08 <malloc+0x250>
 384:	00000097          	auipc	ra,0x0
 388:	778080e7          	jalr	1912(ra) # afc <printf>
    wait(&status);
 38c:	fac40513          	addi	a0,s0,-84
 390:	00000097          	auipc	ra,0x0
 394:	3f6080e7          	jalr	1014(ra) # 786 <wait>
    if (status == 0)
 398:	fac42783          	lw	a5,-84(s0)
 39c:	cbad                	beqz	a5,40e <test2+0x112>
}
 39e:	60e6                	ld	ra,88(sp)
 3a0:	6446                	ld	s0,80(sp)
 3a2:	6125                	addi	sp,sp,96
 3a4:	8082                	ret
            if (count > 0)
 3a6:	000aa783          	lw	a5,0(s5)
 3aa:	2781                	sext.w	a5,a5
 3ac:	02f04863          	bgtz	a5,3dc <test2+0xe0>
        for (i = 0; i < 1000 * 500000; i++)
 3b0:	2485                	addiw	s1,s1,1
 3b2:	03448563          	beq	s1,s4,3dc <test2+0xe0>
            if ((i % 1000000) == 0)
 3b6:	033487b3          	mul	a5,s1,s3
 3ba:	97c9                	srai	a5,a5,0x32
 3bc:	41f4d71b          	sraiw	a4,s1,0x1f
 3c0:	9f99                	subw	a5,a5,a4
 3c2:	02f907bb          	mulw	a5,s2,a5
 3c6:	40f487bb          	subw	a5,s1,a5
 3ca:	fff1                	bnez	a5,3a6 <test2+0xaa>
                write(2, ".", 1);
 3cc:	8662                	mv	a2,s8
 3ce:	85de                	mv	a1,s7
 3d0:	855a                	mv	a0,s6
 3d2:	00000097          	auipc	ra,0x0
 3d6:	3cc080e7          	jalr	972(ra) # 79e <write>
 3da:	b7f1                	j	3a6 <test2+0xaa>
        if (count == 0)
 3dc:	00001797          	auipc	a5,0x1
 3e0:	c247a783          	lw	a5,-988(a5) # 1000 <count>
 3e4:	ef91                	bnez	a5,400 <test2+0x104>
            printf("\ntest2 failed: alarm not called\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a3a50513          	addi	a0,a0,-1478 # e20 <malloc+0x268>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	70e080e7          	jalr	1806(ra) # afc <printf>
            exit(1);
 3f6:	4505                	li	a0,1
 3f8:	00000097          	auipc	ra,0x0
 3fc:	386080e7          	jalr	902(ra) # 77e <exit>
        exit(0);
 400:	4501                	li	a0,0
 402:	00000097          	auipc	ra,0x0
 406:	37c080e7          	jalr	892(ra) # 77e <exit>
 40a:	64a6                	ld	s1,72(sp)
 40c:	b741                	j	38c <test2+0x90>
        printf("test2 passed\n");
 40e:	00001517          	auipc	a0,0x1
 412:	a3a50513          	addi	a0,a0,-1478 # e48 <malloc+0x290>
 416:	00000097          	auipc	ra,0x0
 41a:	6e6080e7          	jalr	1766(ra) # afc <printf>
}
 41e:	b741                	j	39e <test2+0xa2>

0000000000000420 <test3>:

//
// tests that the return from sys_sigreturn() does not
// modify the a0 register
void test3()
{
 420:	1141                	addi	sp,sp,-16
 422:	e406                	sd	ra,8(sp)
 424:	e022                	sd	s0,0(sp)
 426:	0800                	addi	s0,sp,16
    uint64 a0;

    sigalarm(1, dummy_handler);
 428:	00000597          	auipc	a1,0x0
 42c:	c9058593          	addi	a1,a1,-880 # b8 <dummy_handler>
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	3fc080e7          	jalr	1020(ra) # 82e <sigalarm>
    printf("test3 start\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	a1e50513          	addi	a0,a0,-1506 # e58 <malloc+0x2a0>
 442:	00000097          	auipc	ra,0x0
 446:	6ba080e7          	jalr	1722(ra) # afc <printf>

    asm volatile("lui a5, 0");
 44a:	000007b7          	lui	a5,0x0
    asm volatile("addi a0, a5, 0xac" : : : "a0");
 44e:	0ac78513          	addi	a0,a5,172 # ac <slow_handler+0x72>
 452:	1dcd67b7          	lui	a5,0x1dcd6
 456:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
    for (int i = 0; i < 500000000; i++)
 45a:	37fd                	addiw	a5,a5,-1
 45c:	fffd                	bnez	a5,45a <test3+0x3a>
        ;
    asm volatile("mv %0, a0" : "=r"(a0));
 45e:	872a                	mv	a4,a0

    if (a0 != 0xac)
 460:	0ac00793          	li	a5,172
 464:	00f70e63          	beq	a4,a5,480 <test3+0x60>
        printf("test3 failed: register a0 changed\n");
 468:	00001517          	auipc	a0,0x1
 46c:	a0050513          	addi	a0,a0,-1536 # e68 <malloc+0x2b0>
 470:	00000097          	auipc	ra,0x0
 474:	68c080e7          	jalr	1676(ra) # afc <printf>
    else
        printf("test3 passed\n");
 478:	60a2                	ld	ra,8(sp)
 47a:	6402                	ld	s0,0(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret
        printf("test3 passed\n");
 480:	00001517          	auipc	a0,0x1
 484:	a1050513          	addi	a0,a0,-1520 # e90 <malloc+0x2d8>
 488:	00000097          	auipc	ra,0x0
 48c:	674080e7          	jalr	1652(ra) # afc <printf>
 490:	b7e5                	j	478 <test3+0x58>

0000000000000492 <main>:
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
    test0();
 49a:	00000097          	auipc	ra,0x0
 49e:	c42080e7          	jalr	-958(ra) # dc <test0>
    test1();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	d8a080e7          	jalr	-630(ra) # 22c <test1>
    test2();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e52080e7          	jalr	-430(ra) # 2fc <test2>
    test3();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f6e080e7          	jalr	-146(ra) # 420 <test3>
    exit(0);
 4ba:	4501                	li	a0,0
 4bc:	00000097          	auipc	ra,0x0
 4c0:	2c2080e7          	jalr	706(ra) # 77e <exit>

00000000000004c4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e406                	sd	ra,8(sp)
 4c8:	e022                	sd	s0,0(sp)
 4ca:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4cc:	00000097          	auipc	ra,0x0
 4d0:	fc6080e7          	jalr	-58(ra) # 492 <main>
  exit(0);
 4d4:	4501                	li	a0,0
 4d6:	00000097          	auipc	ra,0x0
 4da:	2a8080e7          	jalr	680(ra) # 77e <exit>

00000000000004de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4e6:	87aa                	mv	a5,a0
 4e8:	0585                	addi	a1,a1,1
 4ea:	0785                	addi	a5,a5,1
 4ec:	fff5c703          	lbu	a4,-1(a1)
 4f0:	fee78fa3          	sb	a4,-1(a5)
 4f4:	fb75                	bnez	a4,4e8 <strcpy+0xa>
    ;
  return os;
}
 4f6:	60a2                	ld	ra,8(sp)
 4f8:	6402                	ld	s0,0(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e406                	sd	ra,8(sp)
 502:	e022                	sd	s0,0(sp)
 504:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 506:	00054783          	lbu	a5,0(a0)
 50a:	cb91                	beqz	a5,51e <strcmp+0x20>
 50c:	0005c703          	lbu	a4,0(a1)
 510:	00f71763          	bne	a4,a5,51e <strcmp+0x20>
    p++, q++;
 514:	0505                	addi	a0,a0,1
 516:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 518:	00054783          	lbu	a5,0(a0)
 51c:	fbe5                	bnez	a5,50c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 51e:	0005c503          	lbu	a0,0(a1)
}
 522:	40a7853b          	subw	a0,a5,a0
 526:	60a2                	ld	ra,8(sp)
 528:	6402                	ld	s0,0(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret

000000000000052e <strlen>:

uint
strlen(const char *s)
{
 52e:	1141                	addi	sp,sp,-16
 530:	e406                	sd	ra,8(sp)
 532:	e022                	sd	s0,0(sp)
 534:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 536:	00054783          	lbu	a5,0(a0)
 53a:	cf99                	beqz	a5,558 <strlen+0x2a>
 53c:	0505                	addi	a0,a0,1
 53e:	87aa                	mv	a5,a0
 540:	86be                	mv	a3,a5
 542:	0785                	addi	a5,a5,1
 544:	fff7c703          	lbu	a4,-1(a5)
 548:	ff65                	bnez	a4,540 <strlen+0x12>
 54a:	40a6853b          	subw	a0,a3,a0
 54e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 550:	60a2                	ld	ra,8(sp)
 552:	6402                	ld	s0,0(sp)
 554:	0141                	addi	sp,sp,16
 556:	8082                	ret
  for(n = 0; s[n]; n++)
 558:	4501                	li	a0,0
 55a:	bfdd                	j	550 <strlen+0x22>

000000000000055c <memset>:

void*
memset(void *dst, int c, uint n)
{
 55c:	1141                	addi	sp,sp,-16
 55e:	e406                	sd	ra,8(sp)
 560:	e022                	sd	s0,0(sp)
 562:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 564:	ca19                	beqz	a2,57a <memset+0x1e>
 566:	87aa                	mv	a5,a0
 568:	1602                	slli	a2,a2,0x20
 56a:	9201                	srli	a2,a2,0x20
 56c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 570:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 574:	0785                	addi	a5,a5,1
 576:	fee79de3          	bne	a5,a4,570 <memset+0x14>
  }
  return dst;
}
 57a:	60a2                	ld	ra,8(sp)
 57c:	6402                	ld	s0,0(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret

0000000000000582 <strchr>:

char*
strchr(const char *s, char c)
{
 582:	1141                	addi	sp,sp,-16
 584:	e406                	sd	ra,8(sp)
 586:	e022                	sd	s0,0(sp)
 588:	0800                	addi	s0,sp,16
  for(; *s; s++)
 58a:	00054783          	lbu	a5,0(a0)
 58e:	cf81                	beqz	a5,5a6 <strchr+0x24>
    if(*s == c)
 590:	00f58763          	beq	a1,a5,59e <strchr+0x1c>
  for(; *s; s++)
 594:	0505                	addi	a0,a0,1
 596:	00054783          	lbu	a5,0(a0)
 59a:	fbfd                	bnez	a5,590 <strchr+0xe>
      return (char*)s;
  return 0;
 59c:	4501                	li	a0,0
}
 59e:	60a2                	ld	ra,8(sp)
 5a0:	6402                	ld	s0,0(sp)
 5a2:	0141                	addi	sp,sp,16
 5a4:	8082                	ret
  return 0;
 5a6:	4501                	li	a0,0
 5a8:	bfdd                	j	59e <strchr+0x1c>

00000000000005aa <gets>:

char*
gets(char *buf, int max)
{
 5aa:	7159                	addi	sp,sp,-112
 5ac:	f486                	sd	ra,104(sp)
 5ae:	f0a2                	sd	s0,96(sp)
 5b0:	eca6                	sd	s1,88(sp)
 5b2:	e8ca                	sd	s2,80(sp)
 5b4:	e4ce                	sd	s3,72(sp)
 5b6:	e0d2                	sd	s4,64(sp)
 5b8:	fc56                	sd	s5,56(sp)
 5ba:	f85a                	sd	s6,48(sp)
 5bc:	f45e                	sd	s7,40(sp)
 5be:	f062                	sd	s8,32(sp)
 5c0:	ec66                	sd	s9,24(sp)
 5c2:	e86a                	sd	s10,16(sp)
 5c4:	1880                	addi	s0,sp,112
 5c6:	8caa                	mv	s9,a0
 5c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5ca:	892a                	mv	s2,a0
 5cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 5ce:	f9f40b13          	addi	s6,s0,-97
 5d2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5d4:	4ba9                	li	s7,10
 5d6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 5d8:	8d26                	mv	s10,s1
 5da:	0014899b          	addiw	s3,s1,1
 5de:	84ce                	mv	s1,s3
 5e0:	0349d763          	bge	s3,s4,60e <gets+0x64>
    cc = read(0, &c, 1);
 5e4:	8656                	mv	a2,s5
 5e6:	85da                	mv	a1,s6
 5e8:	4501                	li	a0,0
 5ea:	00000097          	auipc	ra,0x0
 5ee:	1ac080e7          	jalr	428(ra) # 796 <read>
    if(cc < 1)
 5f2:	00a05e63          	blez	a0,60e <gets+0x64>
    buf[i++] = c;
 5f6:	f9f44783          	lbu	a5,-97(s0)
 5fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5fe:	01778763          	beq	a5,s7,60c <gets+0x62>
 602:	0905                	addi	s2,s2,1
 604:	fd879ae3          	bne	a5,s8,5d8 <gets+0x2e>
    buf[i++] = c;
 608:	8d4e                	mv	s10,s3
 60a:	a011                	j	60e <gets+0x64>
 60c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 60e:	9d66                	add	s10,s10,s9
 610:	000d0023          	sb	zero,0(s10)
  return buf;
}
 614:	8566                	mv	a0,s9
 616:	70a6                	ld	ra,104(sp)
 618:	7406                	ld	s0,96(sp)
 61a:	64e6                	ld	s1,88(sp)
 61c:	6946                	ld	s2,80(sp)
 61e:	69a6                	ld	s3,72(sp)
 620:	6a06                	ld	s4,64(sp)
 622:	7ae2                	ld	s5,56(sp)
 624:	7b42                	ld	s6,48(sp)
 626:	7ba2                	ld	s7,40(sp)
 628:	7c02                	ld	s8,32(sp)
 62a:	6ce2                	ld	s9,24(sp)
 62c:	6d42                	ld	s10,16(sp)
 62e:	6165                	addi	sp,sp,112
 630:	8082                	ret

0000000000000632 <stat>:

int
stat(const char *n, struct stat *st)
{
 632:	1101                	addi	sp,sp,-32
 634:	ec06                	sd	ra,24(sp)
 636:	e822                	sd	s0,16(sp)
 638:	e04a                	sd	s2,0(sp)
 63a:	1000                	addi	s0,sp,32
 63c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 63e:	4581                	li	a1,0
 640:	00000097          	auipc	ra,0x0
 644:	17e080e7          	jalr	382(ra) # 7be <open>
  if(fd < 0)
 648:	02054663          	bltz	a0,674 <stat+0x42>
 64c:	e426                	sd	s1,8(sp)
 64e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 650:	85ca                	mv	a1,s2
 652:	00000097          	auipc	ra,0x0
 656:	184080e7          	jalr	388(ra) # 7d6 <fstat>
 65a:	892a                	mv	s2,a0
  close(fd);
 65c:	8526                	mv	a0,s1
 65e:	00000097          	auipc	ra,0x0
 662:	148080e7          	jalr	328(ra) # 7a6 <close>
  return r;
 666:	64a2                	ld	s1,8(sp)
}
 668:	854a                	mv	a0,s2
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6902                	ld	s2,0(sp)
 670:	6105                	addi	sp,sp,32
 672:	8082                	ret
    return -1;
 674:	597d                	li	s2,-1
 676:	bfcd                	j	668 <stat+0x36>

0000000000000678 <atoi>:

int
atoi(const char *s)
{
 678:	1141                	addi	sp,sp,-16
 67a:	e406                	sd	ra,8(sp)
 67c:	e022                	sd	s0,0(sp)
 67e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 680:	00054683          	lbu	a3,0(a0)
 684:	fd06879b          	addiw	a5,a3,-48
 688:	0ff7f793          	zext.b	a5,a5
 68c:	4625                	li	a2,9
 68e:	02f66963          	bltu	a2,a5,6c0 <atoi+0x48>
 692:	872a                	mv	a4,a0
  n = 0;
 694:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 696:	0705                	addi	a4,a4,1
 698:	0025179b          	slliw	a5,a0,0x2
 69c:	9fa9                	addw	a5,a5,a0
 69e:	0017979b          	slliw	a5,a5,0x1
 6a2:	9fb5                	addw	a5,a5,a3
 6a4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6a8:	00074683          	lbu	a3,0(a4)
 6ac:	fd06879b          	addiw	a5,a3,-48
 6b0:	0ff7f793          	zext.b	a5,a5
 6b4:	fef671e3          	bgeu	a2,a5,696 <atoi+0x1e>
  return n;
}
 6b8:	60a2                	ld	ra,8(sp)
 6ba:	6402                	ld	s0,0(sp)
 6bc:	0141                	addi	sp,sp,16
 6be:	8082                	ret
  n = 0;
 6c0:	4501                	li	a0,0
 6c2:	bfdd                	j	6b8 <atoi+0x40>

00000000000006c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6c4:	1141                	addi	sp,sp,-16
 6c6:	e406                	sd	ra,8(sp)
 6c8:	e022                	sd	s0,0(sp)
 6ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6cc:	02b57563          	bgeu	a0,a1,6f6 <memmove+0x32>
    while(n-- > 0)
 6d0:	00c05f63          	blez	a2,6ee <memmove+0x2a>
 6d4:	1602                	slli	a2,a2,0x20
 6d6:	9201                	srli	a2,a2,0x20
 6d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 6de:	0585                	addi	a1,a1,1
 6e0:	0705                	addi	a4,a4,1
 6e2:	fff5c683          	lbu	a3,-1(a1)
 6e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6ea:	fee79ae3          	bne	a5,a4,6de <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6ee:	60a2                	ld	ra,8(sp)
 6f0:	6402                	ld	s0,0(sp)
 6f2:	0141                	addi	sp,sp,16
 6f4:	8082                	ret
    dst += n;
 6f6:	00c50733          	add	a4,a0,a2
    src += n;
 6fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6fc:	fec059e3          	blez	a2,6ee <memmove+0x2a>
 700:	fff6079b          	addiw	a5,a2,-1
 704:	1782                	slli	a5,a5,0x20
 706:	9381                	srli	a5,a5,0x20
 708:	fff7c793          	not	a5,a5
 70c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 70e:	15fd                	addi	a1,a1,-1
 710:	177d                	addi	a4,a4,-1
 712:	0005c683          	lbu	a3,0(a1)
 716:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 71a:	fef71ae3          	bne	a4,a5,70e <memmove+0x4a>
 71e:	bfc1                	j	6ee <memmove+0x2a>

0000000000000720 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 720:	1141                	addi	sp,sp,-16
 722:	e406                	sd	ra,8(sp)
 724:	e022                	sd	s0,0(sp)
 726:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 728:	ca0d                	beqz	a2,75a <memcmp+0x3a>
 72a:	fff6069b          	addiw	a3,a2,-1
 72e:	1682                	slli	a3,a3,0x20
 730:	9281                	srli	a3,a3,0x20
 732:	0685                	addi	a3,a3,1
 734:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 736:	00054783          	lbu	a5,0(a0)
 73a:	0005c703          	lbu	a4,0(a1)
 73e:	00e79863          	bne	a5,a4,74e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 742:	0505                	addi	a0,a0,1
    p2++;
 744:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 746:	fed518e3          	bne	a0,a3,736 <memcmp+0x16>
  }
  return 0;
 74a:	4501                	li	a0,0
 74c:	a019                	j	752 <memcmp+0x32>
      return *p1 - *p2;
 74e:	40e7853b          	subw	a0,a5,a4
}
 752:	60a2                	ld	ra,8(sp)
 754:	6402                	ld	s0,0(sp)
 756:	0141                	addi	sp,sp,16
 758:	8082                	ret
  return 0;
 75a:	4501                	li	a0,0
 75c:	bfdd                	j	752 <memcmp+0x32>

000000000000075e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e406                	sd	ra,8(sp)
 762:	e022                	sd	s0,0(sp)
 764:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 766:	00000097          	auipc	ra,0x0
 76a:	f5e080e7          	jalr	-162(ra) # 6c4 <memmove>
}
 76e:	60a2                	ld	ra,8(sp)
 770:	6402                	ld	s0,0(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 776:	4885                	li	a7,1
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <exit>:
.global exit
exit:
 li a7, SYS_exit
 77e:	4889                	li	a7,2
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <wait>:
.global wait
wait:
 li a7, SYS_wait
 786:	488d                	li	a7,3
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 78e:	4891                	li	a7,4
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <read>:
.global read
read:
 li a7, SYS_read
 796:	4895                	li	a7,5
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <write>:
.global write
write:
 li a7, SYS_write
 79e:	48c1                	li	a7,16
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <close>:
.global close
close:
 li a7, SYS_close
 7a6:	48d5                	li	a7,21
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 7ae:	4899                	li	a7,6
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7b6:	489d                	li	a7,7
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <open>:
.global open
open:
 li a7, SYS_open
 7be:	48bd                	li	a7,15
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7c6:	48c5                	li	a7,17
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7ce:	48c9                	li	a7,18
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7d6:	48a1                	li	a7,8
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <link>:
.global link
link:
 li a7, SYS_link
 7de:	48cd                	li	a7,19
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7e6:	48d1                	li	a7,20
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ee:	48a5                	li	a7,9
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7f6:	48a9                	li	a7,10
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7fe:	48ad                	li	a7,11
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 806:	48b1                	li	a7,12
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 80e:	48b5                	li	a7,13
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 816:	48b9                	li	a7,14
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 81e:	48d9                	li	a7,22
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 826:	48dd                	li	a7,23
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 82e:	48e1                	li	a7,24
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 836:	48e5                	li	a7,25
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 83e:	48e9                	li	a7,26
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 846:	1101                	addi	sp,sp,-32
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 852:	4605                	li	a2,1
 854:	fef40593          	addi	a1,s0,-17
 858:	00000097          	auipc	ra,0x0
 85c:	f46080e7          	jalr	-186(ra) # 79e <write>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6105                	addi	sp,sp,32
 866:	8082                	ret

0000000000000868 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	f04a                	sd	s2,32(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	0080                	addi	s0,sp,64
 876:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 878:	c299                	beqz	a3,87e <printint+0x16>
 87a:	0805c063          	bltz	a1,8fa <printint+0x92>
  neg = 0;
 87e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 880:	fc040313          	addi	t1,s0,-64
  neg = 0;
 884:	869a                	mv	a3,t1
  i = 0;
 886:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 888:	00000817          	auipc	a6,0x0
 88c:	67880813          	addi	a6,a6,1656 # f00 <digits>
 890:	88be                	mv	a7,a5
 892:	0017851b          	addiw	a0,a5,1
 896:	87aa                	mv	a5,a0
 898:	02c5f73b          	remuw	a4,a1,a2
 89c:	1702                	slli	a4,a4,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	9742                	add	a4,a4,a6
 8a2:	00074703          	lbu	a4,0(a4)
 8a6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 8aa:	872e                	mv	a4,a1
 8ac:	02c5d5bb          	divuw	a1,a1,a2
 8b0:	0685                	addi	a3,a3,1
 8b2:	fcc77fe3          	bgeu	a4,a2,890 <printint+0x28>
  if(neg)
 8b6:	000e0c63          	beqz	t3,8ce <printint+0x66>
    buf[i++] = '-';
 8ba:	fd050793          	addi	a5,a0,-48
 8be:	00878533          	add	a0,a5,s0
 8c2:	02d00793          	li	a5,45
 8c6:	fef50823          	sb	a5,-16(a0)
 8ca:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 8ce:	fff7899b          	addiw	s3,a5,-1
 8d2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 8d6:	fff4c583          	lbu	a1,-1(s1)
 8da:	854a                	mv	a0,s2
 8dc:	00000097          	auipc	ra,0x0
 8e0:	f6a080e7          	jalr	-150(ra) # 846 <putc>
  while(--i >= 0)
 8e4:	39fd                	addiw	s3,s3,-1
 8e6:	14fd                	addi	s1,s1,-1
 8e8:	fe09d7e3          	bgez	s3,8d6 <printint+0x6e>
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	7902                	ld	s2,32(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6121                	addi	sp,sp,64
 8f8:	8082                	ret
    x = -xx;
 8fa:	40b005bb          	negw	a1,a1
    neg = 1;
 8fe:	4e05                	li	t3,1
    x = -xx;
 900:	b741                	j	880 <printint+0x18>

0000000000000902 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 902:	715d                	addi	sp,sp,-80
 904:	e486                	sd	ra,72(sp)
 906:	e0a2                	sd	s0,64(sp)
 908:	f84a                	sd	s2,48(sp)
 90a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 90c:	0005c903          	lbu	s2,0(a1)
 910:	1a090a63          	beqz	s2,ac4 <vprintf+0x1c2>
 914:	fc26                	sd	s1,56(sp)
 916:	f44e                	sd	s3,40(sp)
 918:	f052                	sd	s4,32(sp)
 91a:	ec56                	sd	s5,24(sp)
 91c:	e85a                	sd	s6,16(sp)
 91e:	e45e                	sd	s7,8(sp)
 920:	8aaa                	mv	s5,a0
 922:	8bb2                	mv	s7,a2
 924:	00158493          	addi	s1,a1,1
  state = 0;
 928:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 92a:	02500a13          	li	s4,37
 92e:	4b55                	li	s6,21
 930:	a839                	j	94e <vprintf+0x4c>
        putc(fd, c);
 932:	85ca                	mv	a1,s2
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	f10080e7          	jalr	-240(ra) # 846 <putc>
 93e:	a019                	j	944 <vprintf+0x42>
    } else if(state == '%'){
 940:	01498d63          	beq	s3,s4,95a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 944:	0485                	addi	s1,s1,1
 946:	fff4c903          	lbu	s2,-1(s1)
 94a:	16090763          	beqz	s2,ab8 <vprintf+0x1b6>
    if(state == 0){
 94e:	fe0999e3          	bnez	s3,940 <vprintf+0x3e>
      if(c == '%'){
 952:	ff4910e3          	bne	s2,s4,932 <vprintf+0x30>
        state = '%';
 956:	89d2                	mv	s3,s4
 958:	b7f5                	j	944 <vprintf+0x42>
      if(c == 'd'){
 95a:	13490463          	beq	s2,s4,a82 <vprintf+0x180>
 95e:	f9d9079b          	addiw	a5,s2,-99
 962:	0ff7f793          	zext.b	a5,a5
 966:	12fb6763          	bltu	s6,a5,a94 <vprintf+0x192>
 96a:	f9d9079b          	addiw	a5,s2,-99
 96e:	0ff7f713          	zext.b	a4,a5
 972:	12eb6163          	bltu	s6,a4,a94 <vprintf+0x192>
 976:	00271793          	slli	a5,a4,0x2
 97a:	00000717          	auipc	a4,0x0
 97e:	52e70713          	addi	a4,a4,1326 # ea8 <malloc+0x2f0>
 982:	97ba                	add	a5,a5,a4
 984:	439c                	lw	a5,0(a5)
 986:	97ba                	add	a5,a5,a4
 988:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 98a:	008b8913          	addi	s2,s7,8
 98e:	4685                	li	a3,1
 990:	4629                	li	a2,10
 992:	000ba583          	lw	a1,0(s7)
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	ed0080e7          	jalr	-304(ra) # 868 <printint>
 9a0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	b745                	j	944 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9a6:	008b8913          	addi	s2,s7,8
 9aa:	4681                	li	a3,0
 9ac:	4629                	li	a2,10
 9ae:	000ba583          	lw	a1,0(s7)
 9b2:	8556                	mv	a0,s5
 9b4:	00000097          	auipc	ra,0x0
 9b8:	eb4080e7          	jalr	-332(ra) # 868 <printint>
 9bc:	8bca                	mv	s7,s2
      state = 0;
 9be:	4981                	li	s3,0
 9c0:	b751                	j	944 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 9c2:	008b8913          	addi	s2,s7,8
 9c6:	4681                	li	a3,0
 9c8:	4641                	li	a2,16
 9ca:	000ba583          	lw	a1,0(s7)
 9ce:	8556                	mv	a0,s5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	e98080e7          	jalr	-360(ra) # 868 <printint>
 9d8:	8bca                	mv	s7,s2
      state = 0;
 9da:	4981                	li	s3,0
 9dc:	b7a5                	j	944 <vprintf+0x42>
 9de:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9e0:	008b8c13          	addi	s8,s7,8
 9e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9e8:	03000593          	li	a1,48
 9ec:	8556                	mv	a0,s5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	e58080e7          	jalr	-424(ra) # 846 <putc>
  putc(fd, 'x');
 9f6:	07800593          	li	a1,120
 9fa:	8556                	mv	a0,s5
 9fc:	00000097          	auipc	ra,0x0
 a00:	e4a080e7          	jalr	-438(ra) # 846 <putc>
 a04:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a06:	00000b97          	auipc	s7,0x0
 a0a:	4fab8b93          	addi	s7,s7,1274 # f00 <digits>
 a0e:	03c9d793          	srli	a5,s3,0x3c
 a12:	97de                	add	a5,a5,s7
 a14:	0007c583          	lbu	a1,0(a5)
 a18:	8556                	mv	a0,s5
 a1a:	00000097          	auipc	ra,0x0
 a1e:	e2c080e7          	jalr	-468(ra) # 846 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a22:	0992                	slli	s3,s3,0x4
 a24:	397d                	addiw	s2,s2,-1
 a26:	fe0914e3          	bnez	s2,a0e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 a2a:	8be2                	mv	s7,s8
      state = 0;
 a2c:	4981                	li	s3,0
 a2e:	6c02                	ld	s8,0(sp)
 a30:	bf11                	j	944 <vprintf+0x42>
        s = va_arg(ap, char*);
 a32:	008b8993          	addi	s3,s7,8
 a36:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 a3a:	02090163          	beqz	s2,a5c <vprintf+0x15a>
        while(*s != 0){
 a3e:	00094583          	lbu	a1,0(s2)
 a42:	c9a5                	beqz	a1,ab2 <vprintf+0x1b0>
          putc(fd, *s);
 a44:	8556                	mv	a0,s5
 a46:	00000097          	auipc	ra,0x0
 a4a:	e00080e7          	jalr	-512(ra) # 846 <putc>
          s++;
 a4e:	0905                	addi	s2,s2,1
        while(*s != 0){
 a50:	00094583          	lbu	a1,0(s2)
 a54:	f9e5                	bnez	a1,a44 <vprintf+0x142>
        s = va_arg(ap, char*);
 a56:	8bce                	mv	s7,s3
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	b5ed                	j	944 <vprintf+0x42>
          s = "(null)";
 a5c:	00000917          	auipc	s2,0x0
 a60:	44490913          	addi	s2,s2,1092 # ea0 <malloc+0x2e8>
        while(*s != 0){
 a64:	02800593          	li	a1,40
 a68:	bff1                	j	a44 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 a6a:	008b8913          	addi	s2,s7,8
 a6e:	000bc583          	lbu	a1,0(s7)
 a72:	8556                	mv	a0,s5
 a74:	00000097          	auipc	ra,0x0
 a78:	dd2080e7          	jalr	-558(ra) # 846 <putc>
 a7c:	8bca                	mv	s7,s2
      state = 0;
 a7e:	4981                	li	s3,0
 a80:	b5d1                	j	944 <vprintf+0x42>
        putc(fd, c);
 a82:	02500593          	li	a1,37
 a86:	8556                	mv	a0,s5
 a88:	00000097          	auipc	ra,0x0
 a8c:	dbe080e7          	jalr	-578(ra) # 846 <putc>
      state = 0;
 a90:	4981                	li	s3,0
 a92:	bd4d                	j	944 <vprintf+0x42>
        putc(fd, '%');
 a94:	02500593          	li	a1,37
 a98:	8556                	mv	a0,s5
 a9a:	00000097          	auipc	ra,0x0
 a9e:	dac080e7          	jalr	-596(ra) # 846 <putc>
        putc(fd, c);
 aa2:	85ca                	mv	a1,s2
 aa4:	8556                	mv	a0,s5
 aa6:	00000097          	auipc	ra,0x0
 aaa:	da0080e7          	jalr	-608(ra) # 846 <putc>
      state = 0;
 aae:	4981                	li	s3,0
 ab0:	bd51                	j	944 <vprintf+0x42>
        s = va_arg(ap, char*);
 ab2:	8bce                	mv	s7,s3
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	b579                	j	944 <vprintf+0x42>
 ab8:	74e2                	ld	s1,56(sp)
 aba:	79a2                	ld	s3,40(sp)
 abc:	7a02                	ld	s4,32(sp)
 abe:	6ae2                	ld	s5,24(sp)
 ac0:	6b42                	ld	s6,16(sp)
 ac2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 ac4:	60a6                	ld	ra,72(sp)
 ac6:	6406                	ld	s0,64(sp)
 ac8:	7942                	ld	s2,48(sp)
 aca:	6161                	addi	sp,sp,80
 acc:	8082                	ret

0000000000000ace <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ace:	715d                	addi	sp,sp,-80
 ad0:	ec06                	sd	ra,24(sp)
 ad2:	e822                	sd	s0,16(sp)
 ad4:	1000                	addi	s0,sp,32
 ad6:	e010                	sd	a2,0(s0)
 ad8:	e414                	sd	a3,8(s0)
 ada:	e818                	sd	a4,16(s0)
 adc:	ec1c                	sd	a5,24(s0)
 ade:	03043023          	sd	a6,32(s0)
 ae2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ae6:	8622                	mv	a2,s0
 ae8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 aec:	00000097          	auipc	ra,0x0
 af0:	e16080e7          	jalr	-490(ra) # 902 <vprintf>
}
 af4:	60e2                	ld	ra,24(sp)
 af6:	6442                	ld	s0,16(sp)
 af8:	6161                	addi	sp,sp,80
 afa:	8082                	ret

0000000000000afc <printf>:

void
printf(const char *fmt, ...)
{
 afc:	711d                	addi	sp,sp,-96
 afe:	ec06                	sd	ra,24(sp)
 b00:	e822                	sd	s0,16(sp)
 b02:	1000                	addi	s0,sp,32
 b04:	e40c                	sd	a1,8(s0)
 b06:	e810                	sd	a2,16(s0)
 b08:	ec14                	sd	a3,24(s0)
 b0a:	f018                	sd	a4,32(s0)
 b0c:	f41c                	sd	a5,40(s0)
 b0e:	03043823          	sd	a6,48(s0)
 b12:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b16:	00840613          	addi	a2,s0,8
 b1a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b1e:	85aa                	mv	a1,a0
 b20:	4505                	li	a0,1
 b22:	00000097          	auipc	ra,0x0
 b26:	de0080e7          	jalr	-544(ra) # 902 <vprintf>
}
 b2a:	60e2                	ld	ra,24(sp)
 b2c:	6442                	ld	s0,16(sp)
 b2e:	6125                	addi	sp,sp,96
 b30:	8082                	ret

0000000000000b32 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b32:	1141                	addi	sp,sp,-16
 b34:	e406                	sd	ra,8(sp)
 b36:	e022                	sd	s0,0(sp)
 b38:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b3a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b3e:	00000797          	auipc	a5,0x0
 b42:	4ca7b783          	ld	a5,1226(a5) # 1008 <freep>
 b46:	a02d                	j	b70 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b48:	4618                	lw	a4,8(a2)
 b4a:	9f2d                	addw	a4,a4,a1
 b4c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b50:	6398                	ld	a4,0(a5)
 b52:	6310                	ld	a2,0(a4)
 b54:	a83d                	j	b92 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b56:	ff852703          	lw	a4,-8(a0)
 b5a:	9f31                	addw	a4,a4,a2
 b5c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b5e:	ff053683          	ld	a3,-16(a0)
 b62:	a091                	j	ba6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b64:	6398                	ld	a4,0(a5)
 b66:	00e7e463          	bltu	a5,a4,b6e <free+0x3c>
 b6a:	00e6ea63          	bltu	a3,a4,b7e <free+0x4c>
{
 b6e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b70:	fed7fae3          	bgeu	a5,a3,b64 <free+0x32>
 b74:	6398                	ld	a4,0(a5)
 b76:	00e6e463          	bltu	a3,a4,b7e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b7a:	fee7eae3          	bltu	a5,a4,b6e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 b7e:	ff852583          	lw	a1,-8(a0)
 b82:	6390                	ld	a2,0(a5)
 b84:	02059813          	slli	a6,a1,0x20
 b88:	01c85713          	srli	a4,a6,0x1c
 b8c:	9736                	add	a4,a4,a3
 b8e:	fae60de3          	beq	a2,a4,b48 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 b92:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b96:	4790                	lw	a2,8(a5)
 b98:	02061593          	slli	a1,a2,0x20
 b9c:	01c5d713          	srli	a4,a1,0x1c
 ba0:	973e                	add	a4,a4,a5
 ba2:	fae68ae3          	beq	a3,a4,b56 <free+0x24>
    p->s.ptr = bp->s.ptr;
 ba6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ba8:	00000717          	auipc	a4,0x0
 bac:	46f73023          	sd	a5,1120(a4) # 1008 <freep>
}
 bb0:	60a2                	ld	ra,8(sp)
 bb2:	6402                	ld	s0,0(sp)
 bb4:	0141                	addi	sp,sp,16
 bb6:	8082                	ret

0000000000000bb8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bb8:	7139                	addi	sp,sp,-64
 bba:	fc06                	sd	ra,56(sp)
 bbc:	f822                	sd	s0,48(sp)
 bbe:	f04a                	sd	s2,32(sp)
 bc0:	ec4e                	sd	s3,24(sp)
 bc2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bc4:	02051993          	slli	s3,a0,0x20
 bc8:	0209d993          	srli	s3,s3,0x20
 bcc:	09bd                	addi	s3,s3,15
 bce:	0049d993          	srli	s3,s3,0x4
 bd2:	2985                	addiw	s3,s3,1
 bd4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 bd6:	00000517          	auipc	a0,0x0
 bda:	43253503          	ld	a0,1074(a0) # 1008 <freep>
 bde:	c905                	beqz	a0,c0e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 be2:	4798                	lw	a4,8(a5)
 be4:	09377a63          	bgeu	a4,s3,c78 <malloc+0xc0>
 be8:	f426                	sd	s1,40(sp)
 bea:	e852                	sd	s4,16(sp)
 bec:	e456                	sd	s5,8(sp)
 bee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bf0:	8a4e                	mv	s4,s3
 bf2:	6705                	lui	a4,0x1
 bf4:	00e9f363          	bgeu	s3,a4,bfa <malloc+0x42>
 bf8:	6a05                	lui	s4,0x1
 bfa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bfe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c02:	00000497          	auipc	s1,0x0
 c06:	40648493          	addi	s1,s1,1030 # 1008 <freep>
  if(p == (char*)-1)
 c0a:	5afd                	li	s5,-1
 c0c:	a089                	j	c4e <malloc+0x96>
 c0e:	f426                	sd	s1,40(sp)
 c10:	e852                	sd	s4,16(sp)
 c12:	e456                	sd	s5,8(sp)
 c14:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c16:	00000797          	auipc	a5,0x0
 c1a:	3fa78793          	addi	a5,a5,1018 # 1010 <base>
 c1e:	00000717          	auipc	a4,0x0
 c22:	3ef73523          	sd	a5,1002(a4) # 1008 <freep>
 c26:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c28:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c2c:	b7d1                	j	bf0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 c2e:	6398                	ld	a4,0(a5)
 c30:	e118                	sd	a4,0(a0)
 c32:	a8b9                	j	c90 <malloc+0xd8>
  hp->s.size = nu;
 c34:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c38:	0541                	addi	a0,a0,16
 c3a:	00000097          	auipc	ra,0x0
 c3e:	ef8080e7          	jalr	-264(ra) # b32 <free>
  return freep;
 c42:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 c44:	c135                	beqz	a0,ca8 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c48:	4798                	lw	a4,8(a5)
 c4a:	03277363          	bgeu	a4,s2,c70 <malloc+0xb8>
    if(p == freep)
 c4e:	6098                	ld	a4,0(s1)
 c50:	853e                	mv	a0,a5
 c52:	fef71ae3          	bne	a4,a5,c46 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c56:	8552                	mv	a0,s4
 c58:	00000097          	auipc	ra,0x0
 c5c:	bae080e7          	jalr	-1106(ra) # 806 <sbrk>
  if(p == (char*)-1)
 c60:	fd551ae3          	bne	a0,s5,c34 <malloc+0x7c>
        return 0;
 c64:	4501                	li	a0,0
 c66:	74a2                	ld	s1,40(sp)
 c68:	6a42                	ld	s4,16(sp)
 c6a:	6aa2                	ld	s5,8(sp)
 c6c:	6b02                	ld	s6,0(sp)
 c6e:	a03d                	j	c9c <malloc+0xe4>
 c70:	74a2                	ld	s1,40(sp)
 c72:	6a42                	ld	s4,16(sp)
 c74:	6aa2                	ld	s5,8(sp)
 c76:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c78:	fae90be3          	beq	s2,a4,c2e <malloc+0x76>
        p->s.size -= nunits;
 c7c:	4137073b          	subw	a4,a4,s3
 c80:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c82:	02071693          	slli	a3,a4,0x20
 c86:	01c6d713          	srli	a4,a3,0x1c
 c8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c90:	00000717          	auipc	a4,0x0
 c94:	36a73c23          	sd	a0,888(a4) # 1008 <freep>
      return (void*)(p + 1);
 c98:	01078513          	addi	a0,a5,16
  }
}
 c9c:	70e2                	ld	ra,56(sp)
 c9e:	7442                	ld	s0,48(sp)
 ca0:	7902                	ld	s2,32(sp)
 ca2:	69e2                	ld	s3,24(sp)
 ca4:	6121                	addi	sp,sp,64
 ca6:	8082                	ret
 ca8:	74a2                	ld	s1,40(sp)
 caa:	6a42                	ld	s4,16(sp)
 cac:	6aa2                	ld	s5,8(sp)
 cae:	6b02                	ld	s6,0(sp)
 cb0:	b7f5                	j	c9c <malloc+0xe4>
