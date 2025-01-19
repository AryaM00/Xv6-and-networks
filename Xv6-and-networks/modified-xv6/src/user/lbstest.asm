
user/_lbstest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <usless_work>:


#pragma GCC push_options
#pragma GCC optimize ("O0") // Causing wierd errors of moving things here and there

void usless_work() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    for (int i = 0; i < 1000 * 900000; i++) {
   8:	fe042623          	sw	zero,-20(s0)
   c:	a039                	j	1a <usless_work+0x1a>
        asm volatile("nop"); // avoid compiler optimizing away loop
   e:	0001                	nop
    for (int i = 0; i < 1000 * 900000; i++) {
  10:	fec42783          	lw	a5,-20(s0)
  14:	2785                	addiw	a5,a5,1
  16:	fef42623          	sw	a5,-20(s0)
  1a:	fec42783          	lw	a5,-20(s0)
  1e:	0007871b          	sext.w	a4,a5
  22:	35a4f7b7          	lui	a5,0x35a4f
  26:	8ff78793          	addi	a5,a5,-1793 # 35a4e8ff <base+0x35a4d8ef>
  2a:	fee7d2e3          	bge	a5,a4,e <usless_work+0xe>
    }
}
  2e:	0001                	nop
  30:	0001                	nop
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret

000000000000003a <test0>:

void test0(){
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	1000                	addi	s0,sp,32
    settickets(600);// So that parent will get the higher priority and the forks can run at once
  42:	25800513          	li	a0,600
  46:	00000097          	auipc	ra,0x0
  4a:	6ec080e7          	jalr	1772(ra) # 732 <settickets>
    printf("TEST 0\n"); // To check the randomness
  4e:	00001517          	auipc	a0,0x1
  52:	b6250513          	addi	a0,a0,-1182 # bb0 <malloc+0x104>
  56:	00001097          	auipc	ra,0x1
  5a:	99a080e7          	jalr	-1638(ra) # 9f0 <printf>
    int prog1_tickets = 20;
  5e:	47d1                	li	a5,20
  60:	fef42623          	sw	a5,-20(s0)
    int prog2_tickets = 40;
  64:	02800793          	li	a5,40
  68:	fef42423          	sw	a5,-24(s0)
    int prog3_tickets = 2;
  6c:	4789                	li	a5,2
  6e:	fef42223          	sw	a5,-28(s0)
    int prog4_tickets = 80;
  72:	05000793          	li	a5,80
  76:	fef42023          	sw	a5,-32(s0)
    printf("Child 1 has %d tickets.\nChild 2 has %d tickets\nChild 3 has %d tickets\nChild 4 has %d tickets\n",
  7a:	fe042703          	lw	a4,-32(s0)
  7e:	fe442683          	lw	a3,-28(s0)
  82:	fe842603          	lw	a2,-24(s0)
  86:	fec42783          	lw	a5,-20(s0)
  8a:	85be                	mv	a1,a5
  8c:	00001517          	auipc	a0,0x1
  90:	b2c50513          	addi	a0,a0,-1236 # bb8 <malloc+0x10c>
  94:	00001097          	auipc	ra,0x1
  98:	95c080e7          	jalr	-1700(ra) # 9f0 <printf>
           prog1_tickets, prog2_tickets, prog3_tickets, prog4_tickets);

    if (fork() == 0) {
  9c:	00000097          	auipc	ra,0x0
  a0:	5ce080e7          	jalr	1486(ra) # 66a <fork>
  a4:	87aa                	mv	a5,a0
  a6:	e7b1                	bnez	a5,f2 <test0+0xb8>
        printf("Child 1 started\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	b7050513          	addi	a0,a0,-1168 # c18 <malloc+0x16c>
  b0:	00001097          	auipc	ra,0x1
  b4:	940080e7          	jalr	-1728(ra) # 9f0 <printf>
        sleep(1);
  b8:	4505                	li	a0,1
  ba:	00000097          	auipc	ra,0x0
  be:	648080e7          	jalr	1608(ra) # 702 <sleep>
        settickets(prog1_tickets);
  c2:	fec42783          	lw	a5,-20(s0)
  c6:	853e                	mv	a0,a5
  c8:	00000097          	auipc	ra,0x0
  cc:	66a080e7          	jalr	1642(ra) # 732 <settickets>
        usless_work();
  d0:	00000097          	auipc	ra,0x0
  d4:	f30080e7          	jalr	-208(ra) # 0 <usless_work>
        printf("Child 1 exited\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	b5850513          	addi	a0,a0,-1192 # c30 <malloc+0x184>
  e0:	00001097          	auipc	ra,0x1
  e4:	910080e7          	jalr	-1776(ra) # 9f0 <printf>
        exit(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	588080e7          	jalr	1416(ra) # 672 <exit>

    }
    if (fork() == 0) {
  f2:	00000097          	auipc	ra,0x0
  f6:	578080e7          	jalr	1400(ra) # 66a <fork>
  fa:	87aa                	mv	a5,a0
  fc:	e7b1                	bnez	a5,148 <test0+0x10e>
        printf("Child 2 started\n");
  fe:	00001517          	auipc	a0,0x1
 102:	b4250513          	addi	a0,a0,-1214 # c40 <malloc+0x194>
 106:	00001097          	auipc	ra,0x1
 10a:	8ea080e7          	jalr	-1814(ra) # 9f0 <printf>
        sleep(1);
 10e:	4505                	li	a0,1
 110:	00000097          	auipc	ra,0x0
 114:	5f2080e7          	jalr	1522(ra) # 702 <sleep>
        settickets(prog2_tickets);
 118:	fe842783          	lw	a5,-24(s0)
 11c:	853e                	mv	a0,a5
 11e:	00000097          	auipc	ra,0x0
 122:	614080e7          	jalr	1556(ra) # 732 <settickets>
        usless_work();
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <usless_work>
        printf("Child 2 exited\n");
 12e:	00001517          	auipc	a0,0x1
 132:	b2a50513          	addi	a0,a0,-1238 # c58 <malloc+0x1ac>
 136:	00001097          	auipc	ra,0x1
 13a:	8ba080e7          	jalr	-1862(ra) # 9f0 <printf>
        exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	532080e7          	jalr	1330(ra) # 672 <exit>
    }
    if (fork() == 0) {
 148:	00000097          	auipc	ra,0x0
 14c:	522080e7          	jalr	1314(ra) # 66a <fork>
 150:	87aa                	mv	a5,a0
 152:	e7b1                	bnez	a5,19e <test0+0x164>
        printf("Child 3 started\n");
 154:	00001517          	auipc	a0,0x1
 158:	b1450513          	addi	a0,a0,-1260 # c68 <malloc+0x1bc>
 15c:	00001097          	auipc	ra,0x1
 160:	894080e7          	jalr	-1900(ra) # 9f0 <printf>
        sleep(1);
 164:	4505                	li	a0,1
 166:	00000097          	auipc	ra,0x0
 16a:	59c080e7          	jalr	1436(ra) # 702 <sleep>
        settickets(prog3_tickets);
 16e:	fe442783          	lw	a5,-28(s0)
 172:	853e                	mv	a0,a5
 174:	00000097          	auipc	ra,0x0
 178:	5be080e7          	jalr	1470(ra) # 732 <settickets>
        usless_work();
 17c:	00000097          	auipc	ra,0x0
 180:	e84080e7          	jalr	-380(ra) # 0 <usless_work>
        printf("Child 3 exited\n");
 184:	00001517          	auipc	a0,0x1
 188:	afc50513          	addi	a0,a0,-1284 # c80 <malloc+0x1d4>
 18c:	00001097          	auipc	ra,0x1
 190:	864080e7          	jalr	-1948(ra) # 9f0 <printf>
        exit(0);
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	4dc080e7          	jalr	1244(ra) # 672 <exit>
    }
    if (fork() == 0) {
 19e:	00000097          	auipc	ra,0x0
 1a2:	4cc080e7          	jalr	1228(ra) # 66a <fork>
 1a6:	87aa                	mv	a5,a0
 1a8:	e7b1                	bnez	a5,1f4 <test0+0x1ba>
        printf("Child 4 started\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	ae650513          	addi	a0,a0,-1306 # c90 <malloc+0x1e4>
 1b2:	00001097          	auipc	ra,0x1
 1b6:	83e080e7          	jalr	-1986(ra) # 9f0 <printf>
        sleep(1);
 1ba:	4505                	li	a0,1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	546080e7          	jalr	1350(ra) # 702 <sleep>
        settickets(prog4_tickets);
 1c4:	fe042783          	lw	a5,-32(s0)
 1c8:	853e                	mv	a0,a5
 1ca:	00000097          	auipc	ra,0x0
 1ce:	568080e7          	jalr	1384(ra) # 732 <settickets>
        usless_work();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	e2e080e7          	jalr	-466(ra) # 0 <usless_work>
        printf("Child 4 exited\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	ace50513          	addi	a0,a0,-1330 # ca8 <malloc+0x1fc>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	80e080e7          	jalr	-2034(ra) # 9f0 <printf>
        exit(0);
 1ea:	4501                	li	a0,0
 1ec:	00000097          	auipc	ra,0x0
 1f0:	486080e7          	jalr	1158(ra) # 672 <exit>
    }
    wait(0);
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	484080e7          	jalr	1156(ra) # 67a <wait>
    wait(0);
 1fe:	4501                	li	a0,0
 200:	00000097          	auipc	ra,0x0
 204:	47a080e7          	jalr	1146(ra) # 67a <wait>
    wait(0);
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	470080e7          	jalr	1136(ra) # 67a <wait>
    wait(0);
 212:	4501                	li	a0,0
 214:	00000097          	auipc	ra,0x0
 218:	466080e7          	jalr	1126(ra) # 67a <wait>
    printf("The correct order should be ideally 4,2,1 and then 3.\n");
 21c:	00001517          	auipc	a0,0x1
 220:	a9c50513          	addi	a0,a0,-1380 # cb8 <malloc+0x20c>
 224:	00000097          	auipc	ra,0x0
 228:	7cc080e7          	jalr	1996(ra) # 9f0 <printf>

}
 22c:	0001                	nop
 22e:	60e2                	ld	ra,24(sp)
 230:	6442                	ld	s0,16(sp)
 232:	6105                	addi	sp,sp,32
 234:	8082                	ret

0000000000000236 <test1>:

void test1(){
 236:	1101                	addi	sp,sp,-32
 238:	ec06                	sd	ra,24(sp)
 23a:	e822                	sd	s0,16(sp)
 23c:	1000                	addi	s0,sp,32
    printf("TEST1\n"); // To check the FCFS part of the implementation
 23e:	00001517          	auipc	a0,0x1
 242:	ab250513          	addi	a0,a0,-1358 # cf0 <malloc+0x244>
 246:	00000097          	auipc	ra,0x0
 24a:	7aa080e7          	jalr	1962(ra) # 9f0 <printf>
    int tickets = 30; // To check for this finish times
 24e:	47f9                	li	a5,30
 250:	fef42623          	sw	a5,-20(s0)
    settickets(30); // So that now, the parent will always get the main priority to set up its children
 254:	4579                	li	a0,30
 256:	00000097          	auipc	ra,0x0
 25a:	4dc080e7          	jalr	1244(ra) # 732 <settickets>
    sleep(1); // So that this will have a different ctime than others. Ctime is not entirely very accurate
 25e:	4505                	li	a0,1
 260:	00000097          	auipc	ra,0x0
 264:	4a2080e7          	jalr	1186(ra) # 702 <sleep>

    printf("Child 1 started\n");
 268:	00001517          	auipc	a0,0x1
 26c:	9b050513          	addi	a0,a0,-1616 # c18 <malloc+0x16c>
 270:	00000097          	auipc	ra,0x0
 274:	780080e7          	jalr	1920(ra) # 9f0 <printf>
    if (fork() == 0) {
 278:	00000097          	auipc	ra,0x0
 27c:	3f2080e7          	jalr	1010(ra) # 66a <fork>
 280:	87aa                	mv	a5,a0
 282:	eb8d                	bnez	a5,2b4 <test1+0x7e>
        settickets(tickets);
 284:	fec42783          	lw	a5,-20(s0)
 288:	853e                	mv	a0,a5
 28a:	00000097          	auipc	ra,0x0
 28e:	4a8080e7          	jalr	1192(ra) # 732 <settickets>
        usless_work();
 292:	00000097          	auipc	ra,0x0
 296:	d6e080e7          	jalr	-658(ra) # 0 <usless_work>
        printf("Child 1 ended\n");
 29a:	00001517          	auipc	a0,0x1
 29e:	a5e50513          	addi	a0,a0,-1442 # cf8 <malloc+0x24c>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	74e080e7          	jalr	1870(ra) # 9f0 <printf>
        exit(0);
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	3c6080e7          	jalr	966(ra) # 672 <exit>
    }
    printf("Child 2 started\n");
 2b4:	00001517          	auipc	a0,0x1
 2b8:	98c50513          	addi	a0,a0,-1652 # c40 <malloc+0x194>
 2bc:	00000097          	auipc	ra,0x0
 2c0:	734080e7          	jalr	1844(ra) # 9f0 <printf>
    if (fork() == 0) {
 2c4:	00000097          	auipc	ra,0x0
 2c8:	3a6080e7          	jalr	934(ra) # 66a <fork>
 2cc:	87aa                	mv	a5,a0
 2ce:	eb8d                	bnez	a5,300 <test1+0xca>
        settickets(tickets);
 2d0:	fec42783          	lw	a5,-20(s0)
 2d4:	853e                	mv	a0,a5
 2d6:	00000097          	auipc	ra,0x0
 2da:	45c080e7          	jalr	1116(ra) # 732 <settickets>
        usless_work();
 2de:	00000097          	auipc	ra,0x0
 2e2:	d22080e7          	jalr	-734(ra) # 0 <usless_work>
        printf("Child 2 ended\n");
 2e6:	00001517          	auipc	a0,0x1
 2ea:	a2250513          	addi	a0,a0,-1502 # d08 <malloc+0x25c>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	702080e7          	jalr	1794(ra) # 9f0 <printf>
        exit(0);
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	37a080e7          	jalr	890(ra) # 672 <exit>
    }
    printf("Child 3 started\n");
 300:	00001517          	auipc	a0,0x1
 304:	96850513          	addi	a0,a0,-1688 # c68 <malloc+0x1bc>
 308:	00000097          	auipc	ra,0x0
 30c:	6e8080e7          	jalr	1768(ra) # 9f0 <printf>
    if (fork() == 0) {
 310:	00000097          	auipc	ra,0x0
 314:	35a080e7          	jalr	858(ra) # 66a <fork>
 318:	87aa                	mv	a5,a0
 31a:	eb8d                	bnez	a5,34c <test1+0x116>
        settickets(tickets);
 31c:	fec42783          	lw	a5,-20(s0)
 320:	853e                	mv	a0,a5
 322:	00000097          	auipc	ra,0x0
 326:	410080e7          	jalr	1040(ra) # 732 <settickets>
        usless_work();
 32a:	00000097          	auipc	ra,0x0
 32e:	cd6080e7          	jalr	-810(ra) # 0 <usless_work>
        printf("Child 3 ended\n");
 332:	00001517          	auipc	a0,0x1
 336:	9e650513          	addi	a0,a0,-1562 # d18 <malloc+0x26c>
 33a:	00000097          	auipc	ra,0x0
 33e:	6b6080e7          	jalr	1718(ra) # 9f0 <printf>
        exit(0);
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	32e080e7          	jalr	814(ra) # 672 <exit>
    }
    wait(0);
 34c:	4501                	li	a0,0
 34e:	00000097          	auipc	ra,0x0
 352:	32c080e7          	jalr	812(ra) # 67a <wait>
    wait(0);
 356:	4501                	li	a0,0
 358:	00000097          	auipc	ra,0x0
 35c:	322080e7          	jalr	802(ra) # 67a <wait>
    wait(0);
 360:	4501                	li	a0,0
 362:	00000097          	auipc	ra,0x0
 366:	318080e7          	jalr	792(ra) # 67a <wait>
    printf("The order should be 1,2 and then 3 since all tickets have same value\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	9be50513          	addi	a0,a0,-1602 # d28 <malloc+0x27c>
 372:	00000097          	auipc	ra,0x0
 376:	67e080e7          	jalr	1662(ra) # 9f0 <printf>
}
 37a:	0001                	nop
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret

0000000000000384 <main>:
int main() {
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
    test0();
 38c:	00000097          	auipc	ra,0x0
 390:	cae080e7          	jalr	-850(ra) # 3a <test0>
    test1();
 394:	00000097          	auipc	ra,0x0
 398:	ea2080e7          	jalr	-350(ra) # 236 <test1>
    printf("Finished all tests\n");
 39c:	00001517          	auipc	a0,0x1
 3a0:	9d450513          	addi	a0,a0,-1580 # d70 <malloc+0x2c4>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	64c080e7          	jalr	1612(ra) # 9f0 <printf>

    return 0;
 3ac:	4781                	li	a5,0
 3ae:	853e                	mv	a0,a5
 3b0:	60a2                	ld	ra,8(sp)
 3b2:	6402                	ld	s0,0(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c0:	00000097          	auipc	ra,0x0
 3c4:	fc4080e7          	jalr	-60(ra) # 384 <main>
  exit(0);
 3c8:	4501                	li	a0,0
 3ca:	00000097          	auipc	ra,0x0
 3ce:	2a8080e7          	jalr	680(ra) # 672 <exit>

00000000000003d2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e406                	sd	ra,8(sp)
 3d6:	e022                	sd	s0,0(sp)
 3d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3da:	87aa                	mv	a5,a0
 3dc:	0585                	addi	a1,a1,1
 3de:	0785                	addi	a5,a5,1
 3e0:	fff5c703          	lbu	a4,-1(a1)
 3e4:	fee78fa3          	sb	a4,-1(a5)
 3e8:	fb75                	bnez	a4,3dc <strcpy+0xa>
    ;
  return os;
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cb91                	beqz	a5,412 <strcmp+0x20>
 400:	0005c703          	lbu	a4,0(a1)
 404:	00f71763          	bne	a4,a5,412 <strcmp+0x20>
    p++, q++;
 408:	0505                	addi	a0,a0,1
 40a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbe5                	bnez	a5,400 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 412:	0005c503          	lbu	a0,0(a1)
}
 416:	40a7853b          	subw	a0,a5,a0
 41a:	60a2                	ld	ra,8(sp)
 41c:	6402                	ld	s0,0(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret

0000000000000422 <strlen>:

uint
strlen(const char *s)
{
 422:	1141                	addi	sp,sp,-16
 424:	e406                	sd	ra,8(sp)
 426:	e022                	sd	s0,0(sp)
 428:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 42a:	00054783          	lbu	a5,0(a0)
 42e:	cf99                	beqz	a5,44c <strlen+0x2a>
 430:	0505                	addi	a0,a0,1
 432:	87aa                	mv	a5,a0
 434:	86be                	mv	a3,a5
 436:	0785                	addi	a5,a5,1
 438:	fff7c703          	lbu	a4,-1(a5)
 43c:	ff65                	bnez	a4,434 <strlen+0x12>
 43e:	40a6853b          	subw	a0,a3,a0
 442:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 444:	60a2                	ld	ra,8(sp)
 446:	6402                	ld	s0,0(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  for(n = 0; s[n]; n++)
 44c:	4501                	li	a0,0
 44e:	bfdd                	j	444 <strlen+0x22>

0000000000000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 458:	ca19                	beqz	a2,46e <memset+0x1e>
 45a:	87aa                	mv	a5,a0
 45c:	1602                	slli	a2,a2,0x20
 45e:	9201                	srli	a2,a2,0x20
 460:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 464:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 468:	0785                	addi	a5,a5,1
 46a:	fee79de3          	bne	a5,a4,464 <memset+0x14>
  }
  return dst;
}
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <strchr>:

char*
strchr(const char *s, char c)
{
 476:	1141                	addi	sp,sp,-16
 478:	e406                	sd	ra,8(sp)
 47a:	e022                	sd	s0,0(sp)
 47c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 47e:	00054783          	lbu	a5,0(a0)
 482:	cf81                	beqz	a5,49a <strchr+0x24>
    if(*s == c)
 484:	00f58763          	beq	a1,a5,492 <strchr+0x1c>
  for(; *s; s++)
 488:	0505                	addi	a0,a0,1
 48a:	00054783          	lbu	a5,0(a0)
 48e:	fbfd                	bnez	a5,484 <strchr+0xe>
      return (char*)s;
  return 0;
 490:	4501                	li	a0,0
}
 492:	60a2                	ld	ra,8(sp)
 494:	6402                	ld	s0,0(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
  return 0;
 49a:	4501                	li	a0,0
 49c:	bfdd                	j	492 <strchr+0x1c>

000000000000049e <gets>:

char*
gets(char *buf, int max)
{
 49e:	7159                	addi	sp,sp,-112
 4a0:	f486                	sd	ra,104(sp)
 4a2:	f0a2                	sd	s0,96(sp)
 4a4:	eca6                	sd	s1,88(sp)
 4a6:	e8ca                	sd	s2,80(sp)
 4a8:	e4ce                	sd	s3,72(sp)
 4aa:	e0d2                	sd	s4,64(sp)
 4ac:	fc56                	sd	s5,56(sp)
 4ae:	f85a                	sd	s6,48(sp)
 4b0:	f45e                	sd	s7,40(sp)
 4b2:	f062                	sd	s8,32(sp)
 4b4:	ec66                	sd	s9,24(sp)
 4b6:	e86a                	sd	s10,16(sp)
 4b8:	1880                	addi	s0,sp,112
 4ba:	8caa                	mv	s9,a0
 4bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4be:	892a                	mv	s2,a0
 4c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 4c2:	f9f40b13          	addi	s6,s0,-97
 4c6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4c8:	4ba9                	li	s7,10
 4ca:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 4cc:	8d26                	mv	s10,s1
 4ce:	0014899b          	addiw	s3,s1,1
 4d2:	84ce                	mv	s1,s3
 4d4:	0349d763          	bge	s3,s4,502 <gets+0x64>
    cc = read(0, &c, 1);
 4d8:	8656                	mv	a2,s5
 4da:	85da                	mv	a1,s6
 4dc:	4501                	li	a0,0
 4de:	00000097          	auipc	ra,0x0
 4e2:	1ac080e7          	jalr	428(ra) # 68a <read>
    if(cc < 1)
 4e6:	00a05e63          	blez	a0,502 <gets+0x64>
    buf[i++] = c;
 4ea:	f9f44783          	lbu	a5,-97(s0)
 4ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4f2:	01778763          	beq	a5,s7,500 <gets+0x62>
 4f6:	0905                	addi	s2,s2,1
 4f8:	fd879ae3          	bne	a5,s8,4cc <gets+0x2e>
    buf[i++] = c;
 4fc:	8d4e                	mv	s10,s3
 4fe:	a011                	j	502 <gets+0x64>
 500:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 502:	9d66                	add	s10,s10,s9
 504:	000d0023          	sb	zero,0(s10)
  return buf;
}
 508:	8566                	mv	a0,s9
 50a:	70a6                	ld	ra,104(sp)
 50c:	7406                	ld	s0,96(sp)
 50e:	64e6                	ld	s1,88(sp)
 510:	6946                	ld	s2,80(sp)
 512:	69a6                	ld	s3,72(sp)
 514:	6a06                	ld	s4,64(sp)
 516:	7ae2                	ld	s5,56(sp)
 518:	7b42                	ld	s6,48(sp)
 51a:	7ba2                	ld	s7,40(sp)
 51c:	7c02                	ld	s8,32(sp)
 51e:	6ce2                	ld	s9,24(sp)
 520:	6d42                	ld	s10,16(sp)
 522:	6165                	addi	sp,sp,112
 524:	8082                	ret

0000000000000526 <stat>:

int
stat(const char *n, struct stat *st)
{
 526:	1101                	addi	sp,sp,-32
 528:	ec06                	sd	ra,24(sp)
 52a:	e822                	sd	s0,16(sp)
 52c:	e04a                	sd	s2,0(sp)
 52e:	1000                	addi	s0,sp,32
 530:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 532:	4581                	li	a1,0
 534:	00000097          	auipc	ra,0x0
 538:	17e080e7          	jalr	382(ra) # 6b2 <open>
  if(fd < 0)
 53c:	02054663          	bltz	a0,568 <stat+0x42>
 540:	e426                	sd	s1,8(sp)
 542:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 544:	85ca                	mv	a1,s2
 546:	00000097          	auipc	ra,0x0
 54a:	184080e7          	jalr	388(ra) # 6ca <fstat>
 54e:	892a                	mv	s2,a0
  close(fd);
 550:	8526                	mv	a0,s1
 552:	00000097          	auipc	ra,0x0
 556:	148080e7          	jalr	328(ra) # 69a <close>
  return r;
 55a:	64a2                	ld	s1,8(sp)
}
 55c:	854a                	mv	a0,s2
 55e:	60e2                	ld	ra,24(sp)
 560:	6442                	ld	s0,16(sp)
 562:	6902                	ld	s2,0(sp)
 564:	6105                	addi	sp,sp,32
 566:	8082                	ret
    return -1;
 568:	597d                	li	s2,-1
 56a:	bfcd                	j	55c <stat+0x36>

000000000000056c <atoi>:

int
atoi(const char *s)
{
 56c:	1141                	addi	sp,sp,-16
 56e:	e406                	sd	ra,8(sp)
 570:	e022                	sd	s0,0(sp)
 572:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 574:	00054683          	lbu	a3,0(a0)
 578:	fd06879b          	addiw	a5,a3,-48
 57c:	0ff7f793          	zext.b	a5,a5
 580:	4625                	li	a2,9
 582:	02f66963          	bltu	a2,a5,5b4 <atoi+0x48>
 586:	872a                	mv	a4,a0
  n = 0;
 588:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 58a:	0705                	addi	a4,a4,1
 58c:	0025179b          	slliw	a5,a0,0x2
 590:	9fa9                	addw	a5,a5,a0
 592:	0017979b          	slliw	a5,a5,0x1
 596:	9fb5                	addw	a5,a5,a3
 598:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 59c:	00074683          	lbu	a3,0(a4)
 5a0:	fd06879b          	addiw	a5,a3,-48
 5a4:	0ff7f793          	zext.b	a5,a5
 5a8:	fef671e3          	bgeu	a2,a5,58a <atoi+0x1e>
  return n;
}
 5ac:	60a2                	ld	ra,8(sp)
 5ae:	6402                	ld	s0,0(sp)
 5b0:	0141                	addi	sp,sp,16
 5b2:	8082                	ret
  n = 0;
 5b4:	4501                	li	a0,0
 5b6:	bfdd                	j	5ac <atoi+0x40>

00000000000005b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b8:	1141                	addi	sp,sp,-16
 5ba:	e406                	sd	ra,8(sp)
 5bc:	e022                	sd	s0,0(sp)
 5be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5c0:	02b57563          	bgeu	a0,a1,5ea <memmove+0x32>
    while(n-- > 0)
 5c4:	00c05f63          	blez	a2,5e2 <memmove+0x2a>
 5c8:	1602                	slli	a2,a2,0x20
 5ca:	9201                	srli	a2,a2,0x20
 5cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 5d2:	0585                	addi	a1,a1,1
 5d4:	0705                	addi	a4,a4,1
 5d6:	fff5c683          	lbu	a3,-1(a1)
 5da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5de:	fee79ae3          	bne	a5,a4,5d2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5e2:	60a2                	ld	ra,8(sp)
 5e4:	6402                	ld	s0,0(sp)
 5e6:	0141                	addi	sp,sp,16
 5e8:	8082                	ret
    dst += n;
 5ea:	00c50733          	add	a4,a0,a2
    src += n;
 5ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5f0:	fec059e3          	blez	a2,5e2 <memmove+0x2a>
 5f4:	fff6079b          	addiw	a5,a2,-1
 5f8:	1782                	slli	a5,a5,0x20
 5fa:	9381                	srli	a5,a5,0x20
 5fc:	fff7c793          	not	a5,a5
 600:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 602:	15fd                	addi	a1,a1,-1
 604:	177d                	addi	a4,a4,-1
 606:	0005c683          	lbu	a3,0(a1)
 60a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 60e:	fef71ae3          	bne	a4,a5,602 <memmove+0x4a>
 612:	bfc1                	j	5e2 <memmove+0x2a>

0000000000000614 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 614:	1141                	addi	sp,sp,-16
 616:	e406                	sd	ra,8(sp)
 618:	e022                	sd	s0,0(sp)
 61a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 61c:	ca0d                	beqz	a2,64e <memcmp+0x3a>
 61e:	fff6069b          	addiw	a3,a2,-1
 622:	1682                	slli	a3,a3,0x20
 624:	9281                	srli	a3,a3,0x20
 626:	0685                	addi	a3,a3,1
 628:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 62a:	00054783          	lbu	a5,0(a0)
 62e:	0005c703          	lbu	a4,0(a1)
 632:	00e79863          	bne	a5,a4,642 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 636:	0505                	addi	a0,a0,1
    p2++;
 638:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 63a:	fed518e3          	bne	a0,a3,62a <memcmp+0x16>
  }
  return 0;
 63e:	4501                	li	a0,0
 640:	a019                	j	646 <memcmp+0x32>
      return *p1 - *p2;
 642:	40e7853b          	subw	a0,a5,a4
}
 646:	60a2                	ld	ra,8(sp)
 648:	6402                	ld	s0,0(sp)
 64a:	0141                	addi	sp,sp,16
 64c:	8082                	ret
  return 0;
 64e:	4501                	li	a0,0
 650:	bfdd                	j	646 <memcmp+0x32>

0000000000000652 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 652:	1141                	addi	sp,sp,-16
 654:	e406                	sd	ra,8(sp)
 656:	e022                	sd	s0,0(sp)
 658:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 65a:	00000097          	auipc	ra,0x0
 65e:	f5e080e7          	jalr	-162(ra) # 5b8 <memmove>
}
 662:	60a2                	ld	ra,8(sp)
 664:	6402                	ld	s0,0(sp)
 666:	0141                	addi	sp,sp,16
 668:	8082                	ret

000000000000066a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 66a:	4885                	li	a7,1
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <exit>:
.global exit
exit:
 li a7, SYS_exit
 672:	4889                	li	a7,2
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <wait>:
.global wait
wait:
 li a7, SYS_wait
 67a:	488d                	li	a7,3
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 682:	4891                	li	a7,4
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <read>:
.global read
read:
 li a7, SYS_read
 68a:	4895                	li	a7,5
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <write>:
.global write
write:
 li a7, SYS_write
 692:	48c1                	li	a7,16
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <close>:
.global close
close:
 li a7, SYS_close
 69a:	48d5                	li	a7,21
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6a2:	4899                	li	a7,6
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 6aa:	489d                	li	a7,7
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <open>:
.global open
open:
 li a7, SYS_open
 6b2:	48bd                	li	a7,15
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6ba:	48c5                	li	a7,17
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6c2:	48c9                	li	a7,18
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6ca:	48a1                	li	a7,8
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <link>:
.global link
link:
 li a7, SYS_link
 6d2:	48cd                	li	a7,19
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6da:	48d1                	li	a7,20
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6e2:	48a5                	li	a7,9
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 6ea:	48a9                	li	a7,10
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6f2:	48ad                	li	a7,11
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6fa:	48b1                	li	a7,12
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 702:	48b5                	li	a7,13
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 70a:	48b9                	li	a7,14
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 712:	48d9                	li	a7,22
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 71a:	48dd                	li	a7,23
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 722:	48e1                	li	a7,24
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 72a:	48e5                	li	a7,25
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 732:	48e9                	li	a7,26
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 73a:	1101                	addi	sp,sp,-32
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 746:	4605                	li	a2,1
 748:	fef40593          	addi	a1,s0,-17
 74c:	00000097          	auipc	ra,0x0
 750:	f46080e7          	jalr	-186(ra) # 692 <write>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6105                	addi	sp,sp,32
 75a:	8082                	ret

000000000000075c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	0080                	addi	s0,sp,64
 76a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 76c:	c299                	beqz	a3,772 <printint+0x16>
 76e:	0805c063          	bltz	a1,7ee <printint+0x92>
  neg = 0;
 772:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 774:	fc040313          	addi	t1,s0,-64
  neg = 0;
 778:	869a                	mv	a3,t1
  i = 0;
 77a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 77c:	00000817          	auipc	a6,0x0
 780:	66c80813          	addi	a6,a6,1644 # de8 <digits>
 784:	88be                	mv	a7,a5
 786:	0017851b          	addiw	a0,a5,1
 78a:	87aa                	mv	a5,a0
 78c:	02c5f73b          	remuw	a4,a1,a2
 790:	1702                	slli	a4,a4,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	9742                	add	a4,a4,a6
 796:	00074703          	lbu	a4,0(a4)
 79a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 79e:	872e                	mv	a4,a1
 7a0:	02c5d5bb          	divuw	a1,a1,a2
 7a4:	0685                	addi	a3,a3,1
 7a6:	fcc77fe3          	bgeu	a4,a2,784 <printint+0x28>
  if(neg)
 7aa:	000e0c63          	beqz	t3,7c2 <printint+0x66>
    buf[i++] = '-';
 7ae:	fd050793          	addi	a5,a0,-48
 7b2:	00878533          	add	a0,a5,s0
 7b6:	02d00793          	li	a5,45
 7ba:	fef50823          	sb	a5,-16(a0)
 7be:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 7c2:	fff7899b          	addiw	s3,a5,-1
 7c6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 7ca:	fff4c583          	lbu	a1,-1(s1)
 7ce:	854a                	mv	a0,s2
 7d0:	00000097          	auipc	ra,0x0
 7d4:	f6a080e7          	jalr	-150(ra) # 73a <putc>
  while(--i >= 0)
 7d8:	39fd                	addiw	s3,s3,-1
 7da:	14fd                	addi	s1,s1,-1
 7dc:	fe09d7e3          	bgez	s3,7ca <printint+0x6e>
}
 7e0:	70e2                	ld	ra,56(sp)
 7e2:	7442                	ld	s0,48(sp)
 7e4:	74a2                	ld	s1,40(sp)
 7e6:	7902                	ld	s2,32(sp)
 7e8:	69e2                	ld	s3,24(sp)
 7ea:	6121                	addi	sp,sp,64
 7ec:	8082                	ret
    x = -xx;
 7ee:	40b005bb          	negw	a1,a1
    neg = 1;
 7f2:	4e05                	li	t3,1
    x = -xx;
 7f4:	b741                	j	774 <printint+0x18>

00000000000007f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7f6:	715d                	addi	sp,sp,-80
 7f8:	e486                	sd	ra,72(sp)
 7fa:	e0a2                	sd	s0,64(sp)
 7fc:	f84a                	sd	s2,48(sp)
 7fe:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 800:	0005c903          	lbu	s2,0(a1)
 804:	1a090a63          	beqz	s2,9b8 <vprintf+0x1c2>
 808:	fc26                	sd	s1,56(sp)
 80a:	f44e                	sd	s3,40(sp)
 80c:	f052                	sd	s4,32(sp)
 80e:	ec56                	sd	s5,24(sp)
 810:	e85a                	sd	s6,16(sp)
 812:	e45e                	sd	s7,8(sp)
 814:	8aaa                	mv	s5,a0
 816:	8bb2                	mv	s7,a2
 818:	00158493          	addi	s1,a1,1
  state = 0;
 81c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 81e:	02500a13          	li	s4,37
 822:	4b55                	li	s6,21
 824:	a839                	j	842 <vprintf+0x4c>
        putc(fd, c);
 826:	85ca                	mv	a1,s2
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	f10080e7          	jalr	-240(ra) # 73a <putc>
 832:	a019                	j	838 <vprintf+0x42>
    } else if(state == '%'){
 834:	01498d63          	beq	s3,s4,84e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 838:	0485                	addi	s1,s1,1
 83a:	fff4c903          	lbu	s2,-1(s1)
 83e:	16090763          	beqz	s2,9ac <vprintf+0x1b6>
    if(state == 0){
 842:	fe0999e3          	bnez	s3,834 <vprintf+0x3e>
      if(c == '%'){
 846:	ff4910e3          	bne	s2,s4,826 <vprintf+0x30>
        state = '%';
 84a:	89d2                	mv	s3,s4
 84c:	b7f5                	j	838 <vprintf+0x42>
      if(c == 'd'){
 84e:	13490463          	beq	s2,s4,976 <vprintf+0x180>
 852:	f9d9079b          	addiw	a5,s2,-99
 856:	0ff7f793          	zext.b	a5,a5
 85a:	12fb6763          	bltu	s6,a5,988 <vprintf+0x192>
 85e:	f9d9079b          	addiw	a5,s2,-99
 862:	0ff7f713          	zext.b	a4,a5
 866:	12eb6163          	bltu	s6,a4,988 <vprintf+0x192>
 86a:	00271793          	slli	a5,a4,0x2
 86e:	00000717          	auipc	a4,0x0
 872:	52270713          	addi	a4,a4,1314 # d90 <malloc+0x2e4>
 876:	97ba                	add	a5,a5,a4
 878:	439c                	lw	a5,0(a5)
 87a:	97ba                	add	a5,a5,a4
 87c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 87e:	008b8913          	addi	s2,s7,8
 882:	4685                	li	a3,1
 884:	4629                	li	a2,10
 886:	000ba583          	lw	a1,0(s7)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	ed0080e7          	jalr	-304(ra) # 75c <printint>
 894:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 896:	4981                	li	s3,0
 898:	b745                	j	838 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89a:	008b8913          	addi	s2,s7,8
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	000ba583          	lw	a1,0(s7)
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	eb4080e7          	jalr	-332(ra) # 75c <printint>
 8b0:	8bca                	mv	s7,s2
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b751                	j	838 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 8b6:	008b8913          	addi	s2,s7,8
 8ba:	4681                	li	a3,0
 8bc:	4641                	li	a2,16
 8be:	000ba583          	lw	a1,0(s7)
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e98080e7          	jalr	-360(ra) # 75c <printint>
 8cc:	8bca                	mv	s7,s2
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b7a5                	j	838 <vprintf+0x42>
 8d2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8d4:	008b8c13          	addi	s8,s7,8
 8d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8dc:	03000593          	li	a1,48
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	e58080e7          	jalr	-424(ra) # 73a <putc>
  putc(fd, 'x');
 8ea:	07800593          	li	a1,120
 8ee:	8556                	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e4a080e7          	jalr	-438(ra) # 73a <putc>
 8f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fa:	00000b97          	auipc	s7,0x0
 8fe:	4eeb8b93          	addi	s7,s7,1262 # de8 <digits>
 902:	03c9d793          	srli	a5,s3,0x3c
 906:	97de                	add	a5,a5,s7
 908:	0007c583          	lbu	a1,0(a5)
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	e2c080e7          	jalr	-468(ra) # 73a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 916:	0992                	slli	s3,s3,0x4
 918:	397d                	addiw	s2,s2,-1
 91a:	fe0914e3          	bnez	s2,902 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 91e:	8be2                	mv	s7,s8
      state = 0;
 920:	4981                	li	s3,0
 922:	6c02                	ld	s8,0(sp)
 924:	bf11                	j	838 <vprintf+0x42>
        s = va_arg(ap, char*);
 926:	008b8993          	addi	s3,s7,8
 92a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 92e:	02090163          	beqz	s2,950 <vprintf+0x15a>
        while(*s != 0){
 932:	00094583          	lbu	a1,0(s2)
 936:	c9a5                	beqz	a1,9a6 <vprintf+0x1b0>
          putc(fd, *s);
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e00080e7          	jalr	-512(ra) # 73a <putc>
          s++;
 942:	0905                	addi	s2,s2,1
        while(*s != 0){
 944:	00094583          	lbu	a1,0(s2)
 948:	f9e5                	bnez	a1,938 <vprintf+0x142>
        s = va_arg(ap, char*);
 94a:	8bce                	mv	s7,s3
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b5ed                	j	838 <vprintf+0x42>
          s = "(null)";
 950:	00000917          	auipc	s2,0x0
 954:	43890913          	addi	s2,s2,1080 # d88 <malloc+0x2dc>
        while(*s != 0){
 958:	02800593          	li	a1,40
 95c:	bff1                	j	938 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 95e:	008b8913          	addi	s2,s7,8
 962:	000bc583          	lbu	a1,0(s7)
 966:	8556                	mv	a0,s5
 968:	00000097          	auipc	ra,0x0
 96c:	dd2080e7          	jalr	-558(ra) # 73a <putc>
 970:	8bca                	mv	s7,s2
      state = 0;
 972:	4981                	li	s3,0
 974:	b5d1                	j	838 <vprintf+0x42>
        putc(fd, c);
 976:	02500593          	li	a1,37
 97a:	8556                	mv	a0,s5
 97c:	00000097          	auipc	ra,0x0
 980:	dbe080e7          	jalr	-578(ra) # 73a <putc>
      state = 0;
 984:	4981                	li	s3,0
 986:	bd4d                	j	838 <vprintf+0x42>
        putc(fd, '%');
 988:	02500593          	li	a1,37
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	dac080e7          	jalr	-596(ra) # 73a <putc>
        putc(fd, c);
 996:	85ca                	mv	a1,s2
 998:	8556                	mv	a0,s5
 99a:	00000097          	auipc	ra,0x0
 99e:	da0080e7          	jalr	-608(ra) # 73a <putc>
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	bd51                	j	838 <vprintf+0x42>
        s = va_arg(ap, char*);
 9a6:	8bce                	mv	s7,s3
      state = 0;
 9a8:	4981                	li	s3,0
 9aa:	b579                	j	838 <vprintf+0x42>
 9ac:	74e2                	ld	s1,56(sp)
 9ae:	79a2                	ld	s3,40(sp)
 9b0:	7a02                	ld	s4,32(sp)
 9b2:	6ae2                	ld	s5,24(sp)
 9b4:	6b42                	ld	s6,16(sp)
 9b6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 9b8:	60a6                	ld	ra,72(sp)
 9ba:	6406                	ld	s0,64(sp)
 9bc:	7942                	ld	s2,48(sp)
 9be:	6161                	addi	sp,sp,80
 9c0:	8082                	ret

00000000000009c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c2:	715d                	addi	sp,sp,-80
 9c4:	ec06                	sd	ra,24(sp)
 9c6:	e822                	sd	s0,16(sp)
 9c8:	1000                	addi	s0,sp,32
 9ca:	e010                	sd	a2,0(s0)
 9cc:	e414                	sd	a3,8(s0)
 9ce:	e818                	sd	a4,16(s0)
 9d0:	ec1c                	sd	a5,24(s0)
 9d2:	03043023          	sd	a6,32(s0)
 9d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9da:	8622                	mv	a2,s0
 9dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9e0:	00000097          	auipc	ra,0x0
 9e4:	e16080e7          	jalr	-490(ra) # 7f6 <vprintf>
}
 9e8:	60e2                	ld	ra,24(sp)
 9ea:	6442                	ld	s0,16(sp)
 9ec:	6161                	addi	sp,sp,80
 9ee:	8082                	ret

00000000000009f0 <printf>:

void
printf(const char *fmt, ...)
{
 9f0:	711d                	addi	sp,sp,-96
 9f2:	ec06                	sd	ra,24(sp)
 9f4:	e822                	sd	s0,16(sp)
 9f6:	1000                	addi	s0,sp,32
 9f8:	e40c                	sd	a1,8(s0)
 9fa:	e810                	sd	a2,16(s0)
 9fc:	ec14                	sd	a3,24(s0)
 9fe:	f018                	sd	a4,32(s0)
 a00:	f41c                	sd	a5,40(s0)
 a02:	03043823          	sd	a6,48(s0)
 a06:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a0a:	00840613          	addi	a2,s0,8
 a0e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a12:	85aa                	mv	a1,a0
 a14:	4505                	li	a0,1
 a16:	00000097          	auipc	ra,0x0
 a1a:	de0080e7          	jalr	-544(ra) # 7f6 <vprintf>
}
 a1e:	60e2                	ld	ra,24(sp)
 a20:	6442                	ld	s0,16(sp)
 a22:	6125                	addi	sp,sp,96
 a24:	8082                	ret

0000000000000a26 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a26:	1141                	addi	sp,sp,-16
 a28:	e406                	sd	ra,8(sp)
 a2a:	e022                	sd	s0,0(sp)
 a2c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a32:	00000797          	auipc	a5,0x0
 a36:	5ce7b783          	ld	a5,1486(a5) # 1000 <freep>
 a3a:	a02d                	j	a64 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a3c:	4618                	lw	a4,8(a2)
 a3e:	9f2d                	addw	a4,a4,a1
 a40:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a44:	6398                	ld	a4,0(a5)
 a46:	6310                	ld	a2,0(a4)
 a48:	a83d                	j	a86 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a4a:	ff852703          	lw	a4,-8(a0)
 a4e:	9f31                	addw	a4,a4,a2
 a50:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a52:	ff053683          	ld	a3,-16(a0)
 a56:	a091                	j	a9a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a58:	6398                	ld	a4,0(a5)
 a5a:	00e7e463          	bltu	a5,a4,a62 <free+0x3c>
 a5e:	00e6ea63          	bltu	a3,a4,a72 <free+0x4c>
{
 a62:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a64:	fed7fae3          	bgeu	a5,a3,a58 <free+0x32>
 a68:	6398                	ld	a4,0(a5)
 a6a:	00e6e463          	bltu	a3,a4,a72 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6e:	fee7eae3          	bltu	a5,a4,a62 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a72:	ff852583          	lw	a1,-8(a0)
 a76:	6390                	ld	a2,0(a5)
 a78:	02059813          	slli	a6,a1,0x20
 a7c:	01c85713          	srli	a4,a6,0x1c
 a80:	9736                	add	a4,a4,a3
 a82:	fae60de3          	beq	a2,a4,a3c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a86:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a8a:	4790                	lw	a2,8(a5)
 a8c:	02061593          	slli	a1,a2,0x20
 a90:	01c5d713          	srli	a4,a1,0x1c
 a94:	973e                	add	a4,a4,a5
 a96:	fae68ae3          	beq	a3,a4,a4a <free+0x24>
    p->s.ptr = bp->s.ptr;
 a9a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56f73223          	sd	a5,1380(a4) # 1000 <freep>
}
 aa4:	60a2                	ld	ra,8(sp)
 aa6:	6402                	ld	s0,0(sp)
 aa8:	0141                	addi	sp,sp,16
 aaa:	8082                	ret

0000000000000aac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aac:	7139                	addi	sp,sp,-64
 aae:	fc06                	sd	ra,56(sp)
 ab0:	f822                	sd	s0,48(sp)
 ab2:	f04a                	sd	s2,32(sp)
 ab4:	ec4e                	sd	s3,24(sp)
 ab6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab8:	02051993          	slli	s3,a0,0x20
 abc:	0209d993          	srli	s3,s3,0x20
 ac0:	09bd                	addi	s3,s3,15
 ac2:	0049d993          	srli	s3,s3,0x4
 ac6:	2985                	addiw	s3,s3,1
 ac8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 aca:	00000517          	auipc	a0,0x0
 ace:	53653503          	ld	a0,1334(a0) # 1000 <freep>
 ad2:	c905                	beqz	a0,b02 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad6:	4798                	lw	a4,8(a5)
 ad8:	09377a63          	bgeu	a4,s3,b6c <malloc+0xc0>
 adc:	f426                	sd	s1,40(sp)
 ade:	e852                	sd	s4,16(sp)
 ae0:	e456                	sd	s5,8(sp)
 ae2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ae4:	8a4e                	mv	s4,s3
 ae6:	6705                	lui	a4,0x1
 ae8:	00e9f363          	bgeu	s3,a4,aee <malloc+0x42>
 aec:	6a05                	lui	s4,0x1
 aee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af6:	00000497          	auipc	s1,0x0
 afa:	50a48493          	addi	s1,s1,1290 # 1000 <freep>
  if(p == (char*)-1)
 afe:	5afd                	li	s5,-1
 b00:	a089                	j	b42 <malloc+0x96>
 b02:	f426                	sd	s1,40(sp)
 b04:	e852                	sd	s4,16(sp)
 b06:	e456                	sd	s5,8(sp)
 b08:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b0a:	00000797          	auipc	a5,0x0
 b0e:	50678793          	addi	a5,a5,1286 # 1010 <base>
 b12:	00000717          	auipc	a4,0x0
 b16:	4ef73723          	sd	a5,1262(a4) # 1000 <freep>
 b1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b1c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b20:	b7d1                	j	ae4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b22:	6398                	ld	a4,0(a5)
 b24:	e118                	sd	a4,0(a0)
 b26:	a8b9                	j	b84 <malloc+0xd8>
  hp->s.size = nu;
 b28:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b2c:	0541                	addi	a0,a0,16
 b2e:	00000097          	auipc	ra,0x0
 b32:	ef8080e7          	jalr	-264(ra) # a26 <free>
  return freep;
 b36:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b38:	c135                	beqz	a0,b9c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3c:	4798                	lw	a4,8(a5)
 b3e:	03277363          	bgeu	a4,s2,b64 <malloc+0xb8>
    if(p == freep)
 b42:	6098                	ld	a4,0(s1)
 b44:	853e                	mv	a0,a5
 b46:	fef71ae3          	bne	a4,a5,b3a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b4a:	8552                	mv	a0,s4
 b4c:	00000097          	auipc	ra,0x0
 b50:	bae080e7          	jalr	-1106(ra) # 6fa <sbrk>
  if(p == (char*)-1)
 b54:	fd551ae3          	bne	a0,s5,b28 <malloc+0x7c>
        return 0;
 b58:	4501                	li	a0,0
 b5a:	74a2                	ld	s1,40(sp)
 b5c:	6a42                	ld	s4,16(sp)
 b5e:	6aa2                	ld	s5,8(sp)
 b60:	6b02                	ld	s6,0(sp)
 b62:	a03d                	j	b90 <malloc+0xe4>
 b64:	74a2                	ld	s1,40(sp)
 b66:	6a42                	ld	s4,16(sp)
 b68:	6aa2                	ld	s5,8(sp)
 b6a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b6c:	fae90be3          	beq	s2,a4,b22 <malloc+0x76>
        p->s.size -= nunits;
 b70:	4137073b          	subw	a4,a4,s3
 b74:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b76:	02071693          	slli	a3,a4,0x20
 b7a:	01c6d713          	srli	a4,a3,0x1c
 b7e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b80:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b84:	00000717          	auipc	a4,0x0
 b88:	46a73e23          	sd	a0,1148(a4) # 1000 <freep>
      return (void*)(p + 1);
 b8c:	01078513          	addi	a0,a5,16
  }
}
 b90:	70e2                	ld	ra,56(sp)
 b92:	7442                	ld	s0,48(sp)
 b94:	7902                	ld	s2,32(sp)
 b96:	69e2                	ld	s3,24(sp)
 b98:	6121                	addi	sp,sp,64
 b9a:	8082                	ret
 b9c:	74a2                	ld	s1,40(sp)
 b9e:	6a42                	ld	s4,16(sp)
 ba0:	6aa2                	ld	s5,8(sp)
 ba2:	6b02                	ld	s6,0(sp)
 ba4:	b7f5                	j	b90 <malloc+0xe4>
