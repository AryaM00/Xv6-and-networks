
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a4010113          	addi	sp,sp,-1472 # 80008a40 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	8b078793          	addi	a5,a5,-1872 # 80008900 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	2be78793          	addi	a5,a5,702 # 80006320 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd988f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e4278793          	addi	a5,a5,-446 # 80000ef0 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    8000010c:	04c05c63          	blez	a2,80000164 <consolewrite+0x62>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00002097          	auipc	ra,0x2
    80000138:	5be080e7          	jalr	1470(ra) # 800026f2 <either_copyin>
    8000013c:	03550663          	beq	a0,s5,80000168 <consolewrite+0x66>
      break;
    uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7da080e7          	jalr	2010(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	894e                	mv	s2,s3
    80000156:	64a6                	ld	s1,72(sp)
    80000158:	79e2                	ld	s3,56(sp)
    8000015a:	7a42                	ld	s4,48(sp)
    8000015c:	7aa2                	ld	s5,40(sp)
    8000015e:	7b02                	ld	s6,32(sp)
    80000160:	6be2                	ld	s7,24(sp)
    80000162:	a809                	j	80000174 <consolewrite+0x72>
    80000164:	4901                	li	s2,0
    80000166:	a039                	j	80000174 <consolewrite+0x72>
    80000168:	64a6                	ld	s1,72(sp)
    8000016a:	79e2                	ld	s3,56(sp)
    8000016c:	7a42                	ld	s4,48(sp)
    8000016e:	7aa2                	ld	s5,40(sp)
    80000170:	7b02                	ld	s6,32(sp)
    80000172:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80000174:	854a                	mv	a0,s2
    80000176:	60e6                	ld	ra,88(sp)
    80000178:	6446                	ld	s0,80(sp)
    8000017a:	6906                	ld	s2,64(sp)
    8000017c:	6125                	addi	sp,sp,96
    8000017e:	8082                	ret

0000000080000180 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000180:	711d                	addi	sp,sp,-96
    80000182:	ec86                	sd	ra,88(sp)
    80000184:	e8a2                	sd	s0,80(sp)
    80000186:	e4a6                	sd	s1,72(sp)
    80000188:	e0ca                	sd	s2,64(sp)
    8000018a:	fc4e                	sd	s3,56(sp)
    8000018c:	f852                	sd	s4,48(sp)
    8000018e:	f456                	sd	s5,40(sp)
    80000190:	f05a                	sd	s6,32(sp)
    80000192:	1080                	addi	s0,sp,96
    80000194:	8aaa                	mv	s5,a0
    80000196:	8a2e                	mv	s4,a1
    80000198:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000019a:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    8000019c:	00011517          	auipc	a0,0x11
    800001a0:	8a450513          	addi	a0,a0,-1884 # 80010a40 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	a9a080e7          	jalr	-1382(ra) # 80000c3e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	89448493          	addi	s1,s1,-1900 # 80010a40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	92490913          	addi	s2,s2,-1756 # 80010ad8 <cons+0x98>
  while(n > 0){
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
    while(cons.r == cons.w){
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
      if(killed(myproc())){
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	89c080e7          	jalr	-1892(ra) # 80001a68 <myproc>
    800001d4:	00002097          	auipc	ra,0x2
    800001d8:	36e080e7          	jalr	878(ra) # 80002542 <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	07e080e7          	jalr	126(ra) # 80002260 <sleep>
    while(cons.r == cons.w){
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00011717          	auipc	a4,0x11
    800001fc:	84870713          	addi	a4,a4,-1976 # 80010a40 <cons>
    80000200:	0017869b          	addiw	a3,a5,1
    80000204:	08d72c23          	sw	a3,152(a4)
    80000208:	07f7f693          	andi	a3,a5,127
    8000020c:	9736                	add	a4,a4,a3
    8000020e:	01874703          	lbu	a4,24(a4)
    80000212:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000216:	4691                	li	a3,4
    80000218:	04db8a63          	beq	s7,a3,8000026c <consoleread+0xec>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000021c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000220:	4685                	li	a3,1
    80000222:	faf40613          	addi	a2,s0,-81
    80000226:	85d2                	mv	a1,s4
    80000228:	8556                	mv	a0,s5
    8000022a:	00002097          	auipc	ra,0x2
    8000022e:	472080e7          	jalr	1138(ra) # 8000269c <either_copyout>
    80000232:	57fd                	li	a5,-1
    80000234:	04f50863          	beq	a0,a5,80000284 <consoleread+0x104>
      break;

    dst++;
    80000238:	0a05                	addi	s4,s4,1
    --n;
    8000023a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000023c:	47a9                	li	a5,10
    8000023e:	04fb8f63          	beq	s7,a5,8000029c <consoleread+0x11c>
    80000242:	6be2                	ld	s7,24(sp)
    80000244:	bfa5                	j	800001bc <consoleread+0x3c>
        release(&cons.lock);
    80000246:	00010517          	auipc	a0,0x10
    8000024a:	7fa50513          	addi	a0,a0,2042 # 80010a40 <cons>
    8000024e:	00001097          	auipc	ra,0x1
    80000252:	aa0080e7          	jalr	-1376(ra) # 80000cee <release>
        return -1;
    80000256:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000258:	60e6                	ld	ra,88(sp)
    8000025a:	6446                	ld	s0,80(sp)
    8000025c:	64a6                	ld	s1,72(sp)
    8000025e:	6906                	ld	s2,64(sp)
    80000260:	79e2                	ld	s3,56(sp)
    80000262:	7a42                	ld	s4,48(sp)
    80000264:	7aa2                	ld	s5,40(sp)
    80000266:	7b02                	ld	s6,32(sp)
    80000268:	6125                	addi	sp,sp,96
    8000026a:	8082                	ret
      if(n < target){
    8000026c:	0169fa63          	bgeu	s3,s6,80000280 <consoleread+0x100>
        cons.r--;
    80000270:	00011717          	auipc	a4,0x11
    80000274:	86f72423          	sw	a5,-1944(a4) # 80010ad8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000286:	00010517          	auipc	a0,0x10
    8000028a:	7ba50513          	addi	a0,a0,1978 # 80010a40 <cons>
    8000028e:	00001097          	auipc	ra,0x1
    80000292:	a60080e7          	jalr	-1440(ra) # 80000cee <release>
  return target - n;
    80000296:	413b053b          	subw	a0,s6,s3
    8000029a:	bf7d                	j	80000258 <consoleread+0xd8>
    8000029c:	6be2                	ld	s7,24(sp)
    8000029e:	b7e5                	j	80000286 <consoleread+0x106>

00000000800002a0 <consputc>:
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800002a8:	10000793          	li	a5,256
    800002ac:	00f50a63          	beq	a0,a5,800002c0 <consputc+0x20>
    uartputc_sync(c);
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	590080e7          	jalr	1424(ra) # 80000840 <uartputc_sync>
}
    800002b8:	60a2                	ld	ra,8(sp)
    800002ba:	6402                	ld	s0,0(sp)
    800002bc:	0141                	addi	sp,sp,16
    800002be:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002c0:	4521                	li	a0,8
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	02000513          	li	a0,32
    800002ce:	00000097          	auipc	ra,0x0
    800002d2:	572080e7          	jalr	1394(ra) # 80000840 <uartputc_sync>
    800002d6:	4521                	li	a0,8
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	568080e7          	jalr	1384(ra) # 80000840 <uartputc_sync>
    800002e0:	bfe1                	j	800002b8 <consputc+0x18>

00000000800002e2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002e2:	7179                	addi	sp,sp,-48
    800002e4:	f406                	sd	ra,40(sp)
    800002e6:	f022                	sd	s0,32(sp)
    800002e8:	ec26                	sd	s1,24(sp)
    800002ea:	1800                	addi	s0,sp,48
    800002ec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ee:	00010517          	auipc	a0,0x10
    800002f2:	75250513          	addi	a0,a0,1874 # 80010a40 <cons>
    800002f6:	00001097          	auipc	ra,0x1
    800002fa:	948080e7          	jalr	-1720(ra) # 80000c3e <acquire>

  switch(c){
    800002fe:	47d5                	li	a5,21
    80000300:	0af48463          	beq	s1,a5,800003a8 <consoleintr+0xc6>
    80000304:	0297c963          	blt	a5,s1,80000336 <consoleintr+0x54>
    80000308:	47a1                	li	a5,8
    8000030a:	10f48063          	beq	s1,a5,8000040a <consoleintr+0x128>
    8000030e:	47c1                	li	a5,16
    80000310:	12f49363          	bne	s1,a5,80000436 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80000314:	00002097          	auipc	ra,0x2
    80000318:	434080e7          	jalr	1076(ra) # 80002748 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031c:	00010517          	auipc	a0,0x10
    80000320:	72450513          	addi	a0,a0,1828 # 80010a40 <cons>
    80000324:	00001097          	auipc	ra,0x1
    80000328:	9ca080e7          	jalr	-1590(ra) # 80000cee <release>
}
    8000032c:	70a2                	ld	ra,40(sp)
    8000032e:	7402                	ld	s0,32(sp)
    80000330:	64e2                	ld	s1,24(sp)
    80000332:	6145                	addi	sp,sp,48
    80000334:	8082                	ret
  switch(c){
    80000336:	07f00793          	li	a5,127
    8000033a:	0cf48863          	beq	s1,a5,8000040a <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000033e:	00010717          	auipc	a4,0x10
    80000342:	70270713          	addi	a4,a4,1794 # 80010a40 <cons>
    80000346:	0a072783          	lw	a5,160(a4)
    8000034a:	09872703          	lw	a4,152(a4)
    8000034e:	9f99                	subw	a5,a5,a4
    80000350:	07f00713          	li	a4,127
    80000354:	fcf764e3          	bltu	a4,a5,8000031c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80000358:	47b5                	li	a5,13
    8000035a:	0ef48163          	beq	s1,a5,8000043c <consoleintr+0x15a>
      consputc(c);
    8000035e:	8526                	mv	a0,s1
    80000360:	00000097          	auipc	ra,0x0
    80000364:	f40080e7          	jalr	-192(ra) # 800002a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000368:	00010797          	auipc	a5,0x10
    8000036c:	6d878793          	addi	a5,a5,1752 # 80010a40 <cons>
    80000370:	0a07a683          	lw	a3,160(a5)
    80000374:	0016871b          	addiw	a4,a3,1
    80000378:	863a                	mv	a2,a4
    8000037a:	0ae7a023          	sw	a4,160(a5)
    8000037e:	07f6f693          	andi	a3,a3,127
    80000382:	97b6                	add	a5,a5,a3
    80000384:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000388:	47a9                	li	a5,10
    8000038a:	0cf48f63          	beq	s1,a5,80000468 <consoleintr+0x186>
    8000038e:	4791                	li	a5,4
    80000390:	0cf48c63          	beq	s1,a5,80000468 <consoleintr+0x186>
    80000394:	00010797          	auipc	a5,0x10
    80000398:	7447a783          	lw	a5,1860(a5) # 80010ad8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800003ac:	00010717          	auipc	a4,0x10
    800003b0:	69470713          	addi	a4,a4,1684 # 80010a40 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003bc:	00010497          	auipc	s1,0x10
    800003c0:	68448493          	addi	s1,s1,1668 # 80010a40 <cons>
    while(cons.e != cons.w &&
    800003c4:	4929                	li	s2,10
      consputc(BACKSPACE);
    800003c6:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800003ca:	02f70a63          	beq	a4,a5,800003fe <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003ce:	37fd                	addiw	a5,a5,-1
    800003d0:	07f7f713          	andi	a4,a5,127
    800003d4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003d6:	01874703          	lbu	a4,24(a4)
    800003da:	03270563          	beq	a4,s2,80000404 <consoleintr+0x122>
      cons.e--;
    800003de:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003e2:	854e                	mv	a0,s3
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	ebc080e7          	jalr	-324(ra) # 800002a0 <consputc>
    while(cons.e != cons.w &&
    800003ec:	0a04a783          	lw	a5,160(s1)
    800003f0:	09c4a703          	lw	a4,156(s1)
    800003f4:	fcf71de3          	bne	a4,a5,800003ce <consoleintr+0xec>
    800003f8:	6942                	ld	s2,16(sp)
    800003fa:	69a2                	ld	s3,8(sp)
    800003fc:	b705                	j	8000031c <consoleintr+0x3a>
    800003fe:	6942                	ld	s2,16(sp)
    80000400:	69a2                	ld	s3,8(sp)
    80000402:	bf29                	j	8000031c <consoleintr+0x3a>
    80000404:	6942                	ld	s2,16(sp)
    80000406:	69a2                	ld	s3,8(sp)
    80000408:	bf11                	j	8000031c <consoleintr+0x3a>
    if(cons.e != cons.w){
    8000040a:	00010717          	auipc	a4,0x10
    8000040e:	63670713          	addi	a4,a4,1590 # 80010a40 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
      cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00010717          	auipc	a4,0x10
    80000424:	6cf72023          	sw	a5,1728(a4) # 80010ae0 <cons+0xa0>
      consputc(BACKSPACE);
    80000428:	10000513          	li	a0,256
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	e74080e7          	jalr	-396(ra) # 800002a0 <consputc>
    80000434:	b5e5                	j	8000031c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000436:	ee0483e3          	beqz	s1,8000031c <consoleintr+0x3a>
    8000043a:	b711                	j	8000033e <consoleintr+0x5c>
      consputc(c);
    8000043c:	4529                	li	a0,10
    8000043e:	00000097          	auipc	ra,0x0
    80000442:	e62080e7          	jalr	-414(ra) # 800002a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000446:	00010797          	auipc	a5,0x10
    8000044a:	5fa78793          	addi	a5,a5,1530 # 80010a40 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000468:	00010797          	auipc	a5,0x10
    8000046c:	66c7aa23          	sw	a2,1652(a5) # 80010adc <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00010517          	auipc	a0,0x10
    80000474:	66850513          	addi	a0,a0,1640 # 80010ad8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	e4c080e7          	jalr	-436(ra) # 800022c4 <wakeup>
    80000480:	bd71                	j	8000031c <consoleintr+0x3a>

0000000080000482 <consoleinit>:

void
consoleinit(void)
{
    80000482:	1141                	addi	sp,sp,-16
    80000484:	e406                	sd	ra,8(sp)
    80000486:	e022                	sd	s0,0(sp)
    80000488:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000048a:	00008597          	auipc	a1,0x8
    8000048e:	b7658593          	addi	a1,a1,-1162 # 80008000 <etext>
    80000492:	00010517          	auipc	a0,0x10
    80000496:	5ae50513          	addi	a0,a0,1454 # 80010a40 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	710080e7          	jalr	1808(ra) # 80000baa <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	00024797          	auipc	a5,0x24
    800004ae:	92e78793          	addi	a5,a5,-1746 # 80023dd8 <devsw>
    800004b2:	00000717          	auipc	a4,0x0
    800004b6:	cce70713          	addi	a4,a4,-818 # 80000180 <consoleread>
    800004ba:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004bc:	00000717          	auipc	a4,0x0
    800004c0:	c4670713          	addi	a4,a4,-954 # 80000102 <consolewrite>
    800004c4:	ef98                	sd	a4,24(a5)
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret

00000000800004ce <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ce:	7179                	addi	sp,sp,-48
    800004d0:	f406                	sd	ra,40(sp)
    800004d2:	f022                	sd	s0,32(sp)
    800004d4:	ec26                	sd	s1,24(sp)
    800004d6:	e84a                	sd	s2,16(sp)
    800004d8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004da:	c219                	beqz	a2,800004e0 <printint+0x12>
    800004dc:	06054e63          	bltz	a0,80000558 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800004e0:	4e01                	li	t3,0

  i = 0;
    800004e2:	fd040313          	addi	t1,s0,-48
    x = xx;
    800004e6:	869a                	mv	a3,t1
  i = 0;
    800004e8:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800004ea:	00008817          	auipc	a6,0x8
    800004ee:	23e80813          	addi	a6,a6,574 # 80008728 <digits>
    800004f2:	88be                	mv	a7,a5
    800004f4:	0017861b          	addiw	a2,a5,1
    800004f8:	87b2                	mv	a5,a2
    800004fa:	02b5773b          	remuw	a4,a0,a1
    800004fe:	1702                	slli	a4,a4,0x20
    80000500:	9301                	srli	a4,a4,0x20
    80000502:	9742                	add	a4,a4,a6
    80000504:	00074703          	lbu	a4,0(a4)
    80000508:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000050c:	872a                	mv	a4,a0
    8000050e:	02b5553b          	divuw	a0,a0,a1
    80000512:	0685                	addi	a3,a3,1
    80000514:	fcb77fe3          	bgeu	a4,a1,800004f2 <printint+0x24>

  if(sign)
    80000518:	000e0c63          	beqz	t3,80000530 <printint+0x62>
    buf[i++] = '-';
    8000051c:	fe060793          	addi	a5,a2,-32
    80000520:	00878633          	add	a2,a5,s0
    80000524:	02d00793          	li	a5,45
    80000528:	fef60823          	sb	a5,-16(a2)
    8000052c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80000530:	fff7891b          	addiw	s2,a5,-1
    80000534:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80000538:	fff4c503          	lbu	a0,-1(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d64080e7          	jalr	-668(ra) # 800002a0 <consputc>
  while(--i >= 0)
    80000544:	397d                	addiw	s2,s2,-1
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	fe0958e3          	bgez	s2,80000538 <printint+0x6a>
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	64e2                	ld	s1,24(sp)
    80000552:	6942                	ld	s2,16(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4e05                	li	t3,1
    x = -xx;
    8000055e:	b751                	j	800004e2 <printint+0x14>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00010797          	auipc	a5,0x10
    80000570:	5807aa23          	sw	zero,1428(a5) # 80010b00 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	00008717          	auipc	a4,0x8
    800005a4:	32f72023          	sw	a5,800(a4) # 800088c0 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d97          	auipc	s11,0x10
    800005ce:	536dad83          	lw	s11,1334(s11) # 80010b00 <pr+0x18>
  if(locking)
    800005d2:	040d9463          	bnez	s11,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050c63          	beqz	a0,8000077e <printf+0x1d4>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	f06a                	sd	s10,32(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	07800c93          	li	s9,120
    8000060a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060c:	00008a97          	auipc	s5,0x8
    80000610:	11ca8a93          	addi	s5,s5,284 # 80008728 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00010517          	auipc	a0,0x10
    8000061e:	4ce50513          	addi	a0,a0,1230 # 80010ae8 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	61c080e7          	jalr	1564(ra) # 80000c3e <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c52080e7          	jalr	-942(ra) # 800002a0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	0019879b          	addiw	a5,s3,1
    8000065a:	89be                	mv	s3,a5
    8000065c:	97d2                	add	a5,a5,s4
    8000065e:	0007c503          	lbu	a0,0(a5)
    80000662:	10050563          	beqz	a0,8000076c <printf+0x1c2>
    if(c != '%'){
    80000666:	ff6514e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000066a:	0019879b          	addiw	a5,s3,1
    8000066e:	89be                	mv	s3,a5
    80000670:	97d2                	add	a5,a5,s4
    80000672:	0007c783          	lbu	a5,0(a5)
    80000676:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000067a:	10078a63          	beqz	a5,8000078e <printf+0x1e4>
    switch(c){
    8000067e:	05778a63          	beq	a5,s7,800006d2 <printf+0x128>
    80000682:	02fbf463          	bgeu	s7,a5,800006aa <printf+0x100>
    80000686:	09878763          	beq	a5,s8,80000714 <printf+0x16a>
    8000068a:	0d979663          	bne	a5,s9,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85ea                	mv	a1,s10
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e2e080e7          	jalr	-466(ra) # 800004ce <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	0b678063          	beq	a5,s6,8000074a <printf+0x1a0>
    800006ae:	06400713          	li	a4,100
    800006b2:	0ae79263          	bne	a5,a4,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b6:	f8843783          	ld	a5,-120(s0)
    800006ba:	00878713          	addi	a4,a5,8
    800006be:	f8e43423          	sd	a4,-120(s0)
    800006c2:	4605                	li	a2,1
    800006c4:	45a9                	li	a1,10
    800006c6:	4388                	lw	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	e06080e7          	jalr	-506(ra) # 800004ce <printint>
      break;
    800006d0:	b759                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d2:	f8843783          	ld	a5,-120(s0)
    800006d6:	00878713          	addi	a4,a5,8
    800006da:	f8e43423          	sd	a4,-120(s0)
    800006de:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e2:	03000513          	li	a0,48
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	bba080e7          	jalr	-1094(ra) # 800002a0 <consputc>
  consputc('x');
    800006ee:	8566                	mv	a0,s9
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	bb0080e7          	jalr	-1104(ra) # 800002a0 <consputc>
    800006f8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	03c95793          	srli	a5,s2,0x3c
    800006fe:	97d6                	add	a5,a5,s5
    80000700:	0007c503          	lbu	a0,0(a5)
    80000704:	00000097          	auipc	ra,0x0
    80000708:	b9c080e7          	jalr	-1124(ra) # 800002a0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0912                	slli	s2,s2,0x4
    8000070e:	34fd                	addiw	s1,s1,-1
    80000710:	f4ed                	bnez	s1,800006fa <printf+0x150>
    80000712:	b791                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	6384                	ld	s1,0(a5)
    80000722:	cc89                	beqz	s1,8000073c <printf+0x192>
      for(; *s; s++)
    80000724:	0004c503          	lbu	a0,0(s1)
    80000728:	d51d                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b76080e7          	jalr	-1162(ra) # 800002a0 <consputc>
      for(; *s; s++)
    80000732:	0485                	addi	s1,s1,1
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	f96d                	bnez	a0,8000072a <printf+0x180>
    8000073a:	bf31                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073c:	00008497          	auipc	s1,0x8
    80000740:	8dc48493          	addi	s1,s1,-1828 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000744:	02800513          	li	a0,40
    80000748:	b7cd                	j	8000072a <printf+0x180>
      consputc('%');
    8000074a:	855a                	mv	a0,s6
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	b54080e7          	jalr	-1196(ra) # 800002a0 <consputc>
      break;
    80000754:	b709                	j	80000656 <printf+0xac>
      consputc('%');
    80000756:	855a                	mv	a0,s6
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	b48080e7          	jalr	-1208(ra) # 800002a0 <consputc>
      consputc(c);
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	b3e080e7          	jalr	-1218(ra) # 800002a0 <consputc>
      break;
    8000076a:	b5f5                	j	80000656 <printf+0xac>
    8000076c:	74a6                	ld	s1,104(sp)
    8000076e:	7906                	ld	s2,96(sp)
    80000770:	69e6                	ld	s3,88(sp)
    80000772:	6aa6                	ld	s5,72(sp)
    80000774:	6b06                	ld	s6,64(sp)
    80000776:	7be2                	ld	s7,56(sp)
    80000778:	7c42                	ld	s8,48(sp)
    8000077a:	7ca2                	ld	s9,40(sp)
    8000077c:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077e:	020d9263          	bnez	s11,800007a2 <printf+0x1f8>
}
    80000782:	70e6                	ld	ra,120(sp)
    80000784:	7446                	ld	s0,112(sp)
    80000786:	6a46                	ld	s4,80(sp)
    80000788:	6de2                	ld	s11,24(sp)
    8000078a:	6129                	addi	sp,sp,192
    8000078c:	8082                	ret
    8000078e:	74a6                	ld	s1,104(sp)
    80000790:	7906                	ld	s2,96(sp)
    80000792:	69e6                	ld	s3,88(sp)
    80000794:	6aa6                	ld	s5,72(sp)
    80000796:	6b06                	ld	s6,64(sp)
    80000798:	7be2                	ld	s7,56(sp)
    8000079a:	7c42                	ld	s8,48(sp)
    8000079c:	7ca2                	ld	s9,40(sp)
    8000079e:	7d02                	ld	s10,32(sp)
    800007a0:	bff9                	j	8000077e <printf+0x1d4>
    release(&pr.lock);
    800007a2:	00010517          	auipc	a0,0x10
    800007a6:	34650513          	addi	a0,a0,838 # 80010ae8 <pr>
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	544080e7          	jalr	1348(ra) # 80000cee <release>
}
    800007b2:	bfc1                	j	80000782 <printf+0x1d8>

00000000800007b4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007be:	00010497          	auipc	s1,0x10
    800007c2:	32a48493          	addi	s1,s1,810 # 80010ae8 <pr>
    800007c6:	00008597          	auipc	a1,0x8
    800007ca:	86a58593          	addi	a1,a1,-1942 # 80008030 <etext+0x30>
    800007ce:	8526                	mv	a0,s1
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	3da080e7          	jalr	986(ra) # 80000baa <initlock>
  pr.locking = 1;
    800007d8:	4785                	li	a5,1
    800007da:	cc9c                	sw	a5,24(s1)
}
    800007dc:	60e2                	ld	ra,24(sp)
    800007de:	6442                	ld	s0,16(sp)
    800007e0:	64a2                	ld	s1,8(sp)
    800007e2:	6105                	addi	sp,sp,32
    800007e4:	8082                	ret

00000000800007e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e406                	sd	ra,8(sp)
    800007ea:	e022                	sd	s0,0(sp)
    800007ec:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ee:	100007b7          	lui	a5,0x10000
    800007f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f6:	10000737          	lui	a4,0x10000
    800007fa:	f8000693          	li	a3,-128
    800007fe:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000802:	468d                	li	a3,3
    80000804:	10000637          	lui	a2,0x10000
    80000808:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000810:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000814:	8732                	mv	a4,a2
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00010517          	auipc	a0,0x10
    8000082c:	2e050513          	addi	a0,a0,736 # 80010b08 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	37a080e7          	jalr	890(ra) # 80000baa <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a6080e7          	jalr	934(ra) # 80000bf2 <push_off>

  if(panicked){
    80000854:	00008797          	auipc	a5,0x8
    80000858:	06c7a783          	lw	a5,108(a5) # 800088c0 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	418080e7          	jalr	1048(ra) # 80000c92 <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	00008797          	auipc	a5,0x8
    80000892:	03a7b783          	ld	a5,58(a5) # 800088c8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	03a73703          	ld	a4,58(a4) # 800088d0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00010a97          	auipc	s5,0x10
    800008c0:	24ca8a93          	addi	s5,s5,588 # 80010b08 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	00448493          	addi	s1,s1,4 # 800088c8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	00098993          	mv	s3,s3
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	9d2080e7          	jalr	-1582(ra) # 800022c4 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3) # 800088d0 <uart_tx_w>
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00010517          	auipc	a0,0x10
    80000934:	1d850513          	addi	a0,a0,472 # 80010b08 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	306080e7          	jalr	774(ra) # 80000c3e <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	f807a783          	lw	a5,-128(a5) # 800088c0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	f8673703          	ld	a4,-122(a4) # 800088d0 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	f767b783          	ld	a5,-138(a5) # 800088c8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	1aa98993          	addi	s3,s3,426 # 80010b08 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	f6248493          	addi	s1,s1,-158 # 800088c8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	f6290913          	addi	s2,s2,-158 # 800088d0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	8e2080e7          	jalr	-1822(ra) # 80002260 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	17448493          	addi	s1,s1,372 # 80010b08 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	f2e7b423          	sd	a4,-216(a5) # 800088d0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	334080e7          	jalr	820(ra) # 80000cee <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e406                	sd	ra,8(sp)
    800009d8:	e022                	sd	s0,0(sp)
    800009da:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb89                	beqz	a5,800009f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    return -1;
    800009f8:	557d                	li	a0,-1
    800009fa:	bfdd                	j	800009f0 <uartgetc+0x1c>

00000000800009fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fc:	1101                	addi	sp,sp,-32
    800009fe:	ec06                	sd	ra,24(sp)
    80000a00:	e822                	sd	s0,16(sp)
    80000a02:	e426                	sd	s1,8(sp)
    80000a04:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a06:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	fcc080e7          	jalr	-52(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a10:	00950763          	beq	a0,s1,80000a1e <uartintr+0x22>
      break;
    consoleintr(c);
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	8ce080e7          	jalr	-1842(ra) # 800002e2 <consoleintr>
  while(1){
    80000a1c:	b7f5                	j	80000a08 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1e:	00010497          	auipc	s1,0x10
    80000a22:	0ea48493          	addi	s1,s1,234 # 80010b08 <uart_tx_lock>
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	216080e7          	jalr	534(ra) # 80000c3e <acquire>
  uartstart();
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	e5e080e7          	jalr	-418(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	2b4080e7          	jalr	692(ra) # 80000cee <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret

0000000080000a4c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4c:	1101                	addi	sp,sp,-32
    80000a4e:	ec06                	sd	ra,24(sp)
    80000a50:	e822                	sd	s0,16(sp)
    80000a52:	e426                	sd	s1,8(sp)
    80000a54:	e04a                	sd	s2,0(sp)
    80000a56:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a58:	03451793          	slli	a5,a0,0x34
    80000a5c:	ebb9                	bnez	a5,80000ab2 <kfree+0x66>
    80000a5e:	84aa                	mv	s1,a0
    80000a60:	00024797          	auipc	a5,0x24
    80000a64:	51078793          	addi	a5,a5,1296 # 80024f70 <end>
    80000a68:	04f56563          	bltu	a0,a5,80000ab2 <kfree+0x66>
    80000a6c:	47c5                	li	a5,17
    80000a6e:	07ee                	slli	a5,a5,0x1b
    80000a70:	04f57163          	bgeu	a0,a5,80000ab2 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a74:	6605                	lui	a2,0x1
    80000a76:	4585                	li	a1,1
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	2be080e7          	jalr	702(ra) # 80000d36 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a80:	00010917          	auipc	s2,0x10
    80000a84:	0c090913          	addi	s2,s2,192 # 80010b40 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	1b4080e7          	jalr	436(ra) # 80000c3e <acquire>
  r->next = kmem.freelist;
    80000a92:	01893783          	ld	a5,24(s2)
    80000a96:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a98:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9c:	854a                	mv	a0,s2
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	250080e7          	jalr	592(ra) # 80000cee <release>
}
    80000aa6:	60e2                	ld	ra,24(sp)
    80000aa8:	6442                	ld	s0,16(sp)
    80000aaa:	64a2                	ld	s1,8(sp)
    80000aac:	6902                	ld	s2,0(sp)
    80000aae:	6105                	addi	sp,sp,32
    80000ab0:	8082                	ret
    panic("kfree");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	58e50513          	addi	a0,a0,1422 # 80008040 <etext+0x40>
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	aa6080e7          	jalr	-1370(ra) # 80000560 <panic>

0000000080000ac2 <freerange>:
{
    80000ac2:	7179                	addi	sp,sp,-48
    80000ac4:	f406                	sd	ra,40(sp)
    80000ac6:	f022                	sd	s0,32(sp)
    80000ac8:	ec26                	sd	s1,24(sp)
    80000aca:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000acc:	6785                	lui	a5,0x1
    80000ace:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad2:	00e504b3          	add	s1,a0,a4
    80000ad6:	777d                	lui	a4,0xfffff
    80000ad8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94be                	add	s1,s1,a5
    80000adc:	0295e463          	bltu	a1,s1,80000b04 <freerange+0x42>
    80000ae0:	e84a                	sd	s2,16(sp)
    80000ae2:	e44e                	sd	s3,8(sp)
    80000ae4:	e052                	sd	s4,0(sp)
    80000ae6:	892e                	mv	s2,a1
    kfree(p);
    80000ae8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aea:	89be                	mv	s3,a5
    kfree(p);
    80000aec:	01448533          	add	a0,s1,s4
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	f5c080e7          	jalr	-164(ra) # 80000a4c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af8:	94ce                	add	s1,s1,s3
    80000afa:	fe9979e3          	bgeu	s2,s1,80000aec <freerange+0x2a>
    80000afe:	6942                	ld	s2,16(sp)
    80000b00:	69a2                	ld	s3,8(sp)
    80000b02:	6a02                	ld	s4,0(sp)
}
    80000b04:	70a2                	ld	ra,40(sp)
    80000b06:	7402                	ld	s0,32(sp)
    80000b08:	64e2                	ld	s1,24(sp)
    80000b0a:	6145                	addi	sp,sp,48
    80000b0c:	8082                	ret

0000000080000b0e <kinit>:
{
    80000b0e:	1141                	addi	sp,sp,-16
    80000b10:	e406                	sd	ra,8(sp)
    80000b12:	e022                	sd	s0,0(sp)
    80000b14:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b16:	00007597          	auipc	a1,0x7
    80000b1a:	53258593          	addi	a1,a1,1330 # 80008048 <etext+0x48>
    80000b1e:	00010517          	auipc	a0,0x10
    80000b22:	02250513          	addi	a0,a0,34 # 80010b40 <kmem>
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	084080e7          	jalr	132(ra) # 80000baa <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2e:	45c5                	li	a1,17
    80000b30:	05ee                	slli	a1,a1,0x1b
    80000b32:	00024517          	auipc	a0,0x24
    80000b36:	43e50513          	addi	a0,a0,1086 # 80024f70 <end>
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	f88080e7          	jalr	-120(ra) # 80000ac2 <freerange>
}
    80000b42:	60a2                	ld	ra,8(sp)
    80000b44:	6402                	ld	s0,0(sp)
    80000b46:	0141                	addi	sp,sp,16
    80000b48:	8082                	ret

0000000080000b4a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b54:	00010497          	auipc	s1,0x10
    80000b58:	fec48493          	addi	s1,s1,-20 # 80010b40 <kmem>
    80000b5c:	8526                	mv	a0,s1
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	0e0080e7          	jalr	224(ra) # 80000c3e <acquire>
  r = kmem.freelist;
    80000b66:	6c84                	ld	s1,24(s1)
  if(r)
    80000b68:	c885                	beqz	s1,80000b98 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b6a:	609c                	ld	a5,0(s1)
    80000b6c:	00010517          	auipc	a0,0x10
    80000b70:	fd450513          	addi	a0,a0,-44 # 80010b40 <kmem>
    80000b74:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	178080e7          	jalr	376(ra) # 80000cee <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	4595                	li	a1,5
    80000b82:	8526                	mv	a0,s1
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	1b2080e7          	jalr	434(ra) # 80000d36 <memset>
  return (void*)r;
}
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	60e2                	ld	ra,24(sp)
    80000b90:	6442                	ld	s0,16(sp)
    80000b92:	64a2                	ld	s1,8(sp)
    80000b94:	6105                	addi	sp,sp,32
    80000b96:	8082                	ret
  release(&kmem.lock);
    80000b98:	00010517          	auipc	a0,0x10
    80000b9c:	fa850513          	addi	a0,a0,-88 # 80010b40 <kmem>
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	14e080e7          	jalr	334(ra) # 80000cee <release>
  if(r)
    80000ba8:	b7d5                	j	80000b8c <kalloc+0x42>

0000000080000baa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000baa:	1141                	addi	sp,sp,-16
    80000bac:	e406                	sd	ra,8(sp)
    80000bae:	e022                	sd	s0,0(sp)
    80000bb0:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bb2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb8:	00053823          	sd	zero,16(a0)
}
    80000bbc:	60a2                	ld	ra,8(sp)
    80000bbe:	6402                	ld	s0,0(sp)
    80000bc0:	0141                	addi	sp,sp,16
    80000bc2:	8082                	ret

0000000080000bc4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bc4:	411c                	lw	a5,0(a0)
    80000bc6:	e399                	bnez	a5,80000bcc <holding+0x8>
    80000bc8:	4501                	li	a0,0
  return r;
}
    80000bca:	8082                	ret
{
    80000bcc:	1101                	addi	sp,sp,-32
    80000bce:	ec06                	sd	ra,24(sp)
    80000bd0:	e822                	sd	s0,16(sp)
    80000bd2:	e426                	sd	s1,8(sp)
    80000bd4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd6:	6904                	ld	s1,16(a0)
    80000bd8:	00001097          	auipc	ra,0x1
    80000bdc:	e70080e7          	jalr	-400(ra) # 80001a48 <mycpu>
    80000be0:	40a48533          	sub	a0,s1,a0
    80000be4:	00153513          	seqz	a0,a0
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	addi	sp,sp,32
    80000bf0:	8082                	ret

0000000080000bf2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bf2:	1101                	addi	sp,sp,-32
    80000bf4:	ec06                	sd	ra,24(sp)
    80000bf6:	e822                	sd	s0,16(sp)
    80000bf8:	e426                	sd	s1,8(sp)
    80000bfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bfc:	100024f3          	csrr	s1,sstatus
    80000c00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c04:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c06:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c0a:	00001097          	auipc	ra,0x1
    80000c0e:	e3e080e7          	jalr	-450(ra) # 80001a48 <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	cf89                	beqz	a5,80000c2e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c16:	00001097          	auipc	ra,0x1
    80000c1a:	e32080e7          	jalr	-462(ra) # 80001a48 <mycpu>
    80000c1e:	5d3c                	lw	a5,120(a0)
    80000c20:	2785                	addiw	a5,a5,1
    80000c22:	dd3c                	sw	a5,120(a0)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    mycpu()->intena = old;
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	e1a080e7          	jalr	-486(ra) # 80001a48 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c36:	8085                	srli	s1,s1,0x1
    80000c38:	8885                	andi	s1,s1,1
    80000c3a:	dd64                	sw	s1,124(a0)
    80000c3c:	bfe9                	j	80000c16 <push_off+0x24>

0000000080000c3e <acquire>:
{
    80000c3e:	1101                	addi	sp,sp,-32
    80000c40:	ec06                	sd	ra,24(sp)
    80000c42:	e822                	sd	s0,16(sp)
    80000c44:	e426                	sd	s1,8(sp)
    80000c46:	1000                	addi	s0,sp,32
    80000c48:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	fa8080e7          	jalr	-88(ra) # 80000bf2 <push_off>
  if(holding(lk))
    80000c52:	8526                	mv	a0,s1
    80000c54:	00000097          	auipc	ra,0x0
    80000c58:	f70080e7          	jalr	-144(ra) # 80000bc4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5c:	4705                	li	a4,1
  if(holding(lk))
    80000c5e:	e115                	bnez	a0,80000c82 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c60:	87ba                	mv	a5,a4
    80000c62:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c66:	2781                	sext.w	a5,a5
    80000c68:	ffe5                	bnez	a5,80000c60 <acquire+0x22>
  __sync_synchronize();
    80000c6a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c6e:	00001097          	auipc	ra,0x1
    80000c72:	dda080e7          	jalr	-550(ra) # 80001a48 <mycpu>
    80000c76:	e888                	sd	a0,16(s1)
}
    80000c78:	60e2                	ld	ra,24(sp)
    80000c7a:	6442                	ld	s0,16(sp)
    80000c7c:	64a2                	ld	s1,8(sp)
    80000c7e:	6105                	addi	sp,sp,32
    80000c80:	8082                	ret
    panic("acquire");
    80000c82:	00007517          	auipc	a0,0x7
    80000c86:	3ce50513          	addi	a0,a0,974 # 80008050 <etext+0x50>
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	8d6080e7          	jalr	-1834(ra) # 80000560 <panic>

0000000080000c92 <pop_off>:

void
pop_off(void)
{
    80000c92:	1141                	addi	sp,sp,-16
    80000c94:	e406                	sd	ra,8(sp)
    80000c96:	e022                	sd	s0,0(sp)
    80000c98:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c9a:	00001097          	auipc	ra,0x1
    80000c9e:	dae080e7          	jalr	-594(ra) # 80001a48 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ca2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca6:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca8:	e39d                	bnez	a5,80000cce <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000caa:	5d3c                	lw	a5,120(a0)
    80000cac:	02f05963          	blez	a5,80000cde <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000cb0:	37fd                	addiw	a5,a5,-1
    80000cb2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb4:	eb89                	bnez	a5,80000cc6 <pop_off+0x34>
    80000cb6:	5d7c                	lw	a5,124(a0)
    80000cb8:	c799                	beqz	a5,80000cc6 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret
    panic("pop_off - interruptible");
    80000cce:	00007517          	auipc	a0,0x7
    80000cd2:	38a50513          	addi	a0,a0,906 # 80008058 <etext+0x58>
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	88a080e7          	jalr	-1910(ra) # 80000560 <panic>
    panic("pop_off");
    80000cde:	00007517          	auipc	a0,0x7
    80000ce2:	39250513          	addi	a0,a0,914 # 80008070 <etext+0x70>
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	87a080e7          	jalr	-1926(ra) # 80000560 <panic>

0000000080000cee <release>:
{
    80000cee:	1101                	addi	sp,sp,-32
    80000cf0:	ec06                	sd	ra,24(sp)
    80000cf2:	e822                	sd	s0,16(sp)
    80000cf4:	e426                	sd	s1,8(sp)
    80000cf6:	1000                	addi	s0,sp,32
    80000cf8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	eca080e7          	jalr	-310(ra) # 80000bc4 <holding>
    80000d02:	c115                	beqz	a0,80000d26 <release+0x38>
  lk->cpu = 0;
    80000d04:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d08:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0c:	0310000f          	fence	rw,w
    80000d10:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	f7e080e7          	jalr	-130(ra) # 80000c92 <pop_off>
}
    80000d1c:	60e2                	ld	ra,24(sp)
    80000d1e:	6442                	ld	s0,16(sp)
    80000d20:	64a2                	ld	s1,8(sp)
    80000d22:	6105                	addi	sp,sp,32
    80000d24:	8082                	ret
    panic("release");
    80000d26:	00007517          	auipc	a0,0x7
    80000d2a:	35250513          	addi	a0,a0,850 # 80008078 <etext+0x78>
    80000d2e:	00000097          	auipc	ra,0x0
    80000d32:	832080e7          	jalr	-1998(ra) # 80000560 <panic>

0000000080000d36 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d36:	1141                	addi	sp,sp,-16
    80000d38:	e406                	sd	ra,8(sp)
    80000d3a:	e022                	sd	s0,0(sp)
    80000d3c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3e:	ca19                	beqz	a2,80000d54 <memset+0x1e>
    80000d40:	87aa                	mv	a5,a0
    80000d42:	1602                	slli	a2,a2,0x20
    80000d44:	9201                	srli	a2,a2,0x20
    80000d46:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d4a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4e:	0785                	addi	a5,a5,1
    80000d50:	fee79de3          	bne	a5,a4,80000d4a <memset+0x14>
  }
  return dst;
}
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d5c:	1141                	addi	sp,sp,-16
    80000d5e:	e406                	sd	ra,8(sp)
    80000d60:	e022                	sd	s0,0(sp)
    80000d62:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d64:	ca0d                	beqz	a2,80000d96 <memcmp+0x3a>
    80000d66:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d6a:	1682                	slli	a3,a3,0x20
    80000d6c:	9281                	srli	a3,a3,0x20
    80000d6e:	0685                	addi	a3,a3,1
    80000d70:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d72:	00054783          	lbu	a5,0(a0)
    80000d76:	0005c703          	lbu	a4,0(a1)
    80000d7a:	00e79863          	bne	a5,a4,80000d8a <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d7e:	0505                	addi	a0,a0,1
    80000d80:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d82:	fed518e3          	bne	a0,a3,80000d72 <memcmp+0x16>
  }

  return 0;
    80000d86:	4501                	li	a0,0
    80000d88:	a019                	j	80000d8e <memcmp+0x32>
      return *s1 - *s2;
    80000d8a:	40e7853b          	subw	a0,a5,a4
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret
  return 0;
    80000d96:	4501                	li	a0,0
    80000d98:	bfdd                	j	80000d8e <memcmp+0x32>

0000000080000d9a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d9a:	1141                	addi	sp,sp,-16
    80000d9c:	e406                	sd	ra,8(sp)
    80000d9e:	e022                	sd	s0,0(sp)
    80000da0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000da2:	c205                	beqz	a2,80000dc2 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000da4:	02a5e363          	bltu	a1,a0,80000dca <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000da8:	1602                	slli	a2,a2,0x20
    80000daa:	9201                	srli	a2,a2,0x20
    80000dac:	00c587b3          	add	a5,a1,a2
{
    80000db0:	872a                	mv	a4,a0
      *d++ = *s++;
    80000db2:	0585                	addi	a1,a1,1
    80000db4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda091>
    80000db6:	fff5c683          	lbu	a3,-1(a1)
    80000dba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dbe:	feb79ae3          	bne	a5,a1,80000db2 <memmove+0x18>

  return dst;
}
    80000dc2:	60a2                	ld	ra,8(sp)
    80000dc4:	6402                	ld	s0,0(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret
  if(s < d && s + n > d){
    80000dca:	02061693          	slli	a3,a2,0x20
    80000dce:	9281                	srli	a3,a3,0x20
    80000dd0:	00d58733          	add	a4,a1,a3
    80000dd4:	fce57ae3          	bgeu	a0,a4,80000da8 <memmove+0xe>
    d += n;
    80000dd8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dda:	fff6079b          	addiw	a5,a2,-1
    80000dde:	1782                	slli	a5,a5,0x20
    80000de0:	9381                	srli	a5,a5,0x20
    80000de2:	fff7c793          	not	a5,a5
    80000de6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000de8:	177d                	addi	a4,a4,-1
    80000dea:	16fd                	addi	a3,a3,-1
    80000dec:	00074603          	lbu	a2,0(a4)
    80000df0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000df4:	fee79ae3          	bne	a5,a4,80000de8 <memmove+0x4e>
    80000df8:	b7e9                	j	80000dc2 <memmove+0x28>

0000000080000dfa <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dfa:	1141                	addi	sp,sp,-16
    80000dfc:	e406                	sd	ra,8(sp)
    80000dfe:	e022                	sd	s0,0(sp)
    80000e00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e02:	00000097          	auipc	ra,0x0
    80000e06:	f98080e7          	jalr	-104(ra) # 80000d9a <memmove>
}
    80000e0a:	60a2                	ld	ra,8(sp)
    80000e0c:	6402                	ld	s0,0(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e406                	sd	ra,8(sp)
    80000e16:	e022                	sd	s0,0(sp)
    80000e18:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e1a:	ce11                	beqz	a2,80000e36 <strncmp+0x24>
    80000e1c:	00054783          	lbu	a5,0(a0)
    80000e20:	cf89                	beqz	a5,80000e3a <strncmp+0x28>
    80000e22:	0005c703          	lbu	a4,0(a1)
    80000e26:	00f71a63          	bne	a4,a5,80000e3a <strncmp+0x28>
    n--, p++, q++;
    80000e2a:	367d                	addiw	a2,a2,-1
    80000e2c:	0505                	addi	a0,a0,1
    80000e2e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e30:	f675                	bnez	a2,80000e1c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e32:	4501                	li	a0,0
    80000e34:	a801                	j	80000e44 <strncmp+0x32>
    80000e36:	4501                	li	a0,0
    80000e38:	a031                	j	80000e44 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e3a:	00054503          	lbu	a0,0(a0)
    80000e3e:	0005c783          	lbu	a5,0(a1)
    80000e42:	9d1d                	subw	a0,a0,a5
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e54:	87aa                	mv	a5,a0
    80000e56:	86b2                	mv	a3,a2
    80000e58:	367d                	addiw	a2,a2,-1
    80000e5a:	02d05563          	blez	a3,80000e84 <strncpy+0x38>
    80000e5e:	0785                	addi	a5,a5,1
    80000e60:	0005c703          	lbu	a4,0(a1)
    80000e64:	fee78fa3          	sb	a4,-1(a5)
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	f775                	bnez	a4,80000e56 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e6c:	873e                	mv	a4,a5
    80000e6e:	00c05b63          	blez	a2,80000e84 <strncpy+0x38>
    80000e72:	9fb5                	addw	a5,a5,a3
    80000e74:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e76:	0705                	addi	a4,a4,1
    80000e78:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e7c:	40e786bb          	subw	a3,a5,a4
    80000e80:	fed04be3          	bgtz	a3,80000e76 <strncpy+0x2a>
  return os;
}
    80000e84:	60a2                	ld	ra,8(sp)
    80000e86:	6402                	ld	s0,0(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e94:	02c05363          	blez	a2,80000eba <safestrcpy+0x2e>
    80000e98:	fff6069b          	addiw	a3,a2,-1
    80000e9c:	1682                	slli	a3,a3,0x20
    80000e9e:	9281                	srli	a3,a3,0x20
    80000ea0:	96ae                	add	a3,a3,a1
    80000ea2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ea4:	00d58963          	beq	a1,a3,80000eb6 <safestrcpy+0x2a>
    80000ea8:	0585                	addi	a1,a1,1
    80000eaa:	0785                	addi	a5,a5,1
    80000eac:	fff5c703          	lbu	a4,-1(a1)
    80000eb0:	fee78fa3          	sb	a4,-1(a5)
    80000eb4:	fb65                	bnez	a4,80000ea4 <safestrcpy+0x18>
    ;
  *s = 0;
    80000eb6:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret

0000000080000ec2 <strlen>:

int
strlen(const char *s)
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e406                	sd	ra,8(sp)
    80000ec6:	e022                	sd	s0,0(sp)
    80000ec8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eca:	00054783          	lbu	a5,0(a0)
    80000ece:	cf99                	beqz	a5,80000eec <strlen+0x2a>
    80000ed0:	0505                	addi	a0,a0,1
    80000ed2:	87aa                	mv	a5,a0
    80000ed4:	86be                	mv	a3,a5
    80000ed6:	0785                	addi	a5,a5,1
    80000ed8:	fff7c703          	lbu	a4,-1(a5)
    80000edc:	ff65                	bnez	a4,80000ed4 <strlen+0x12>
    80000ede:	40a6853b          	subw	a0,a3,a0
    80000ee2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ee4:	60a2                	ld	ra,8(sp)
    80000ee6:	6402                	ld	s0,0(sp)
    80000ee8:	0141                	addi	sp,sp,16
    80000eea:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eec:	4501                	li	a0,0
    80000eee:	bfdd                	j	80000ee4 <strlen+0x22>

0000000080000ef0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ef0:	1141                	addi	sp,sp,-16
    80000ef2:	e406                	sd	ra,8(sp)
    80000ef4:	e022                	sd	s0,0(sp)
    80000ef6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ef8:	00001097          	auipc	ra,0x1
    80000efc:	b3c080e7          	jalr	-1220(ra) # 80001a34 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f00:	00008717          	auipc	a4,0x8
    80000f04:	9d870713          	addi	a4,a4,-1576 # 800088d8 <started>
  if(cpuid() == 0){
    80000f08:	c139                	beqz	a0,80000f4e <main+0x5e>
    while(started == 0)
    80000f0a:	431c                	lw	a5,0(a4)
    80000f0c:	2781                	sext.w	a5,a5
    80000f0e:	dff5                	beqz	a5,80000f0a <main+0x1a>
      ;
    __sync_synchronize();
    80000f10:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	b20080e7          	jalr	-1248(ra) # 80001a34 <cpuid>
    80000f1c:	85aa                	mv	a1,a0
    80000f1e:	00007517          	auipc	a0,0x7
    80000f22:	17a50513          	addi	a0,a0,378 # 80008098 <etext+0x98>
    80000f26:	fffff097          	auipc	ra,0xfffff
    80000f2a:	684080e7          	jalr	1668(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f2e:	00000097          	auipc	ra,0x0
    80000f32:	0d8080e7          	jalr	216(ra) # 80001006 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	afc080e7          	jalr	-1284(ra) # 80002a32 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	426080e7          	jalr	1062(ra) # 80006364 <plicinithart>
  }

  scheduler();        
    80000f46:	00001097          	auipc	ra,0x1
    80000f4a:	168080e7          	jalr	360(ra) # 800020ae <scheduler>
    consoleinit();
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	534080e7          	jalr	1332(ra) # 80000482 <consoleinit>
    printfinit();
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	85e080e7          	jalr	-1954(ra) # 800007b4 <printfinit>
    printf("\n");
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	0b250513          	addi	a0,a0,178 # 80008010 <etext+0x10>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	644080e7          	jalr	1604(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f6e:	00007517          	auipc	a0,0x7
    80000f72:	11250513          	addi	a0,a0,274 # 80008080 <etext+0x80>
    80000f76:	fffff097          	auipc	ra,0xfffff
    80000f7a:	634080e7          	jalr	1588(ra) # 800005aa <printf>
    printf("\n");
    80000f7e:	00007517          	auipc	a0,0x7
    80000f82:	09250513          	addi	a0,a0,146 # 80008010 <etext+0x10>
    80000f86:	fffff097          	auipc	ra,0xfffff
    80000f8a:	624080e7          	jalr	1572(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	b80080e7          	jalr	-1152(ra) # 80000b0e <kinit>
    kvminit();       // create kernel page table
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	32a080e7          	jalr	810(ra) # 800012c0 <kvminit>
    kvminithart();   // turn on paging
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	068080e7          	jalr	104(ra) # 80001006 <kvminithart>
    procinit();      // process table
    80000fa6:	00001097          	auipc	ra,0x1
    80000faa:	9d2080e7          	jalr	-1582(ra) # 80001978 <procinit>
    trapinit();      // trap vectors
    80000fae:	00002097          	auipc	ra,0x2
    80000fb2:	a5c080e7          	jalr	-1444(ra) # 80002a0a <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	a7c080e7          	jalr	-1412(ra) # 80002a32 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	38c080e7          	jalr	908(ra) # 8000634a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc6:	00005097          	auipc	ra,0x5
    80000fca:	39e080e7          	jalr	926(ra) # 80006364 <plicinithart>
    binit();         // buffer cache
    80000fce:	00002097          	auipc	ra,0x2
    80000fd2:	424080e7          	jalr	1060(ra) # 800033f2 <binit>
    iinit();         // inode table
    80000fd6:	00003097          	auipc	ra,0x3
    80000fda:	ab4080e7          	jalr	-1356(ra) # 80003a8a <iinit>
    fileinit();      // file table
    80000fde:	00004097          	auipc	ra,0x4
    80000fe2:	a86080e7          	jalr	-1402(ra) # 80004a64 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	486080e7          	jalr	1158(ra) # 8000646c <virtio_disk_init>
    userinit();      // first user process
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	da2080e7          	jalr	-606(ra) # 80001d90 <userinit>
    __sync_synchronize();
    80000ff6:	0330000f          	fence	rw,rw
    started = 1;
    80000ffa:	4785                	li	a5,1
    80000ffc:	00008717          	auipc	a4,0x8
    80001000:	8cf72e23          	sw	a5,-1828(a4) # 800088d8 <started>
    80001004:	b789                	j	80000f46 <main+0x56>

0000000080001006 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001006:	1141                	addi	sp,sp,-16
    80001008:	e406                	sd	ra,8(sp)
    8000100a:	e022                	sd	s0,0(sp)
    8000100c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000100e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001012:	00008797          	auipc	a5,0x8
    80001016:	8ce7b783          	ld	a5,-1842(a5) # 800088e0 <kernel_pagetable>
    8000101a:	83b1                	srli	a5,a5,0xc
    8000101c:	577d                	li	a4,-1
    8000101e:	177e                	slli	a4,a4,0x3f
    80001020:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001022:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001026:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000102a:	60a2                	ld	ra,8(sp)
    8000102c:	6402                	ld	s0,0(sp)
    8000102e:	0141                	addi	sp,sp,16
    80001030:	8082                	ret

0000000080001032 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001032:	7139                	addi	sp,sp,-64
    80001034:	fc06                	sd	ra,56(sp)
    80001036:	f822                	sd	s0,48(sp)
    80001038:	f426                	sd	s1,40(sp)
    8000103a:	f04a                	sd	s2,32(sp)
    8000103c:	ec4e                	sd	s3,24(sp)
    8000103e:	e852                	sd	s4,16(sp)
    80001040:	e456                	sd	s5,8(sp)
    80001042:	e05a                	sd	s6,0(sp)
    80001044:	0080                	addi	s0,sp,64
    80001046:	84aa                	mv	s1,a0
    80001048:	89ae                	mv	s3,a1
    8000104a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001052:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001054:	04b7e263          	bltu	a5,a1,80001098 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001058:	0149d933          	srl	s2,s3,s4
    8000105c:	1ff97913          	andi	s2,s2,511
    80001060:	090e                	slli	s2,s2,0x3
    80001062:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001064:	00093483          	ld	s1,0(s2)
    80001068:	0014f793          	andi	a5,s1,1
    8000106c:	cf95                	beqz	a5,800010a8 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000106e:	80a9                	srli	s1,s1,0xa
    80001070:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001072:	3a5d                	addiw	s4,s4,-9
    80001074:	ff6a12e3          	bne	s4,s6,80001058 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001078:	00c9d513          	srli	a0,s3,0xc
    8000107c:	1ff57513          	andi	a0,a0,511
    80001080:	050e                	slli	a0,a0,0x3
    80001082:	9526                	add	a0,a0,s1
}
    80001084:	70e2                	ld	ra,56(sp)
    80001086:	7442                	ld	s0,48(sp)
    80001088:	74a2                	ld	s1,40(sp)
    8000108a:	7902                	ld	s2,32(sp)
    8000108c:	69e2                	ld	s3,24(sp)
    8000108e:	6a42                	ld	s4,16(sp)
    80001090:	6aa2                	ld	s5,8(sp)
    80001092:	6b02                	ld	s6,0(sp)
    80001094:	6121                	addi	sp,sp,64
    80001096:	8082                	ret
    panic("walk");
    80001098:	00007517          	auipc	a0,0x7
    8000109c:	01850513          	addi	a0,a0,24 # 800080b0 <etext+0xb0>
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	4c0080e7          	jalr	1216(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010a8:	020a8663          	beqz	s5,800010d4 <walk+0xa2>
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	a9e080e7          	jalr	-1378(ra) # 80000b4a <kalloc>
    800010b4:	84aa                	mv	s1,a0
    800010b6:	d579                	beqz	a0,80001084 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010b8:	6605                	lui	a2,0x1
    800010ba:	4581                	li	a1,0
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	c7a080e7          	jalr	-902(ra) # 80000d36 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010c4:	00c4d793          	srli	a5,s1,0xc
    800010c8:	07aa                	slli	a5,a5,0xa
    800010ca:	0017e793          	ori	a5,a5,1
    800010ce:	00f93023          	sd	a5,0(s2)
    800010d2:	b745                	j	80001072 <walk+0x40>
        return 0;
    800010d4:	4501                	li	a0,0
    800010d6:	b77d                	j	80001084 <walk+0x52>

00000000800010d8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010d8:	57fd                	li	a5,-1
    800010da:	83e9                	srli	a5,a5,0x1a
    800010dc:	00b7f463          	bgeu	a5,a1,800010e4 <walkaddr+0xc>
    return 0;
    800010e0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010e2:	8082                	ret
{
    800010e4:	1141                	addi	sp,sp,-16
    800010e6:	e406                	sd	ra,8(sp)
    800010e8:	e022                	sd	s0,0(sp)
    800010ea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ec:	4601                	li	a2,0
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f44080e7          	jalr	-188(ra) # 80001032 <walk>
  if(pte == 0)
    800010f6:	c105                	beqz	a0,80001116 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010f8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010fa:	0117f693          	andi	a3,a5,17
    800010fe:	4745                	li	a4,17
    return 0;
    80001100:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001102:	00e68663          	beq	a3,a4,8000110e <walkaddr+0x36>
}
    80001106:	60a2                	ld	ra,8(sp)
    80001108:	6402                	ld	s0,0(sp)
    8000110a:	0141                	addi	sp,sp,16
    8000110c:	8082                	ret
  pa = PTE2PA(*pte);
    8000110e:	83a9                	srli	a5,a5,0xa
    80001110:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001114:	bfcd                	j	80001106 <walkaddr+0x2e>
    return 0;
    80001116:	4501                	li	a0,0
    80001118:	b7fd                	j	80001106 <walkaddr+0x2e>

000000008000111a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000111a:	715d                	addi	sp,sp,-80
    8000111c:	e486                	sd	ra,72(sp)
    8000111e:	e0a2                	sd	s0,64(sp)
    80001120:	fc26                	sd	s1,56(sp)
    80001122:	f84a                	sd	s2,48(sp)
    80001124:	f44e                	sd	s3,40(sp)
    80001126:	f052                	sd	s4,32(sp)
    80001128:	ec56                	sd	s5,24(sp)
    8000112a:	e85a                	sd	s6,16(sp)
    8000112c:	e45e                	sd	s7,8(sp)
    8000112e:	e062                	sd	s8,0(sp)
    80001130:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001132:	ca21                	beqz	a2,80001182 <mappages+0x68>
    80001134:	8aaa                	mv	s5,a0
    80001136:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001138:	777d                	lui	a4,0xfffff
    8000113a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000113e:	fff58993          	addi	s3,a1,-1
    80001142:	99b2                	add	s3,s3,a2
    80001144:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001148:	893e                	mv	s2,a5
    8000114a:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000114e:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001150:	6c05                	lui	s8,0x1
    80001152:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001156:	865e                	mv	a2,s7
    80001158:	85ca                	mv	a1,s2
    8000115a:	8556                	mv	a0,s5
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	ed6080e7          	jalr	-298(ra) # 80001032 <walk>
    80001164:	cd1d                	beqz	a0,800011a2 <mappages+0x88>
    if(*pte & PTE_V)
    80001166:	611c                	ld	a5,0(a0)
    80001168:	8b85                	andi	a5,a5,1
    8000116a:	e785                	bnez	a5,80001192 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000116c:	80b1                	srli	s1,s1,0xc
    8000116e:	04aa                	slli	s1,s1,0xa
    80001170:	0164e4b3          	or	s1,s1,s6
    80001174:	0014e493          	ori	s1,s1,1
    80001178:	e104                	sd	s1,0(a0)
    if(a == last)
    8000117a:	05390163          	beq	s2,s3,800011bc <mappages+0xa2>
    a += PGSIZE;
    8000117e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001180:	bfc9                	j	80001152 <mappages+0x38>
    panic("mappages: size");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	f3650513          	addi	a0,a0,-202 # 800080b8 <etext+0xb8>
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	3d6080e7          	jalr	982(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001192:	00007517          	auipc	a0,0x7
    80001196:	f3650513          	addi	a0,a0,-202 # 800080c8 <etext+0xc8>
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	3c6080e7          	jalr	966(ra) # 80000560 <panic>
      return -1;
    800011a2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011a4:	60a6                	ld	ra,72(sp)
    800011a6:	6406                	ld	s0,64(sp)
    800011a8:	74e2                	ld	s1,56(sp)
    800011aa:	7942                	ld	s2,48(sp)
    800011ac:	79a2                	ld	s3,40(sp)
    800011ae:	7a02                	ld	s4,32(sp)
    800011b0:	6ae2                	ld	s5,24(sp)
    800011b2:	6b42                	ld	s6,16(sp)
    800011b4:	6ba2                	ld	s7,8(sp)
    800011b6:	6c02                	ld	s8,0(sp)
    800011b8:	6161                	addi	sp,sp,80
    800011ba:	8082                	ret
  return 0;
    800011bc:	4501                	li	a0,0
    800011be:	b7dd                	j	800011a4 <mappages+0x8a>

00000000800011c0 <kvmmap>:
{
    800011c0:	1141                	addi	sp,sp,-16
    800011c2:	e406                	sd	ra,8(sp)
    800011c4:	e022                	sd	s0,0(sp)
    800011c6:	0800                	addi	s0,sp,16
    800011c8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011ca:	86b2                	mv	a3,a2
    800011cc:	863e                	mv	a2,a5
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f4c080e7          	jalr	-180(ra) # 8000111a <mappages>
    800011d6:	e509                	bnez	a0,800011e0 <kvmmap+0x20>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret
    panic("kvmmap");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	ef850513          	addi	a0,a0,-264 # 800080d8 <etext+0xd8>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	378080e7          	jalr	888(ra) # 80000560 <panic>

00000000800011f0 <kvmmake>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	94e080e7          	jalr	-1714(ra) # 80000b4a <kalloc>
    80001204:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001206:	6605                	lui	a2,0x1
    80001208:	4581                	li	a1,0
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	b2c080e7          	jalr	-1236(ra) # 80000d36 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001212:	4719                	li	a4,6
    80001214:	6685                	lui	a3,0x1
    80001216:	10000637          	lui	a2,0x10000
    8000121a:	85b2                	mv	a1,a2
    8000121c:	8526                	mv	a0,s1
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	fa2080e7          	jalr	-94(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001226:	4719                	li	a4,6
    80001228:	6685                	lui	a3,0x1
    8000122a:	10001637          	lui	a2,0x10001
    8000122e:	85b2                	mv	a1,a2
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	f8e080e7          	jalr	-114(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000123a:	4719                	li	a4,6
    8000123c:	004006b7          	lui	a3,0x400
    80001240:	0c000637          	lui	a2,0xc000
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f78080e7          	jalr	-136(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001250:	00007917          	auipc	s2,0x7
    80001254:	db090913          	addi	s2,s2,-592 # 80008000 <etext>
    80001258:	4729                	li	a4,10
    8000125a:	80007697          	auipc	a3,0x80007
    8000125e:	da668693          	addi	a3,a3,-602 # 8000 <_entry-0x7fff8000>
    80001262:	4605                	li	a2,1
    80001264:	067e                	slli	a2,a2,0x1f
    80001266:	85b2                	mv	a1,a2
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f56080e7          	jalr	-170(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001272:	4719                	li	a4,6
    80001274:	46c5                	li	a3,17
    80001276:	06ee                	slli	a3,a3,0x1b
    80001278:	412686b3          	sub	a3,a3,s2
    8000127c:	864a                	mv	a2,s2
    8000127e:	85ca                	mv	a1,s2
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	f3e080e7          	jalr	-194(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000128a:	4729                	li	a4,10
    8000128c:	6685                	lui	a3,0x1
    8000128e:	00006617          	auipc	a2,0x6
    80001292:	d7260613          	addi	a2,a2,-654 # 80007000 <_trampoline>
    80001296:	040005b7          	lui	a1,0x4000
    8000129a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000129c:	05b2                	slli	a1,a1,0xc
    8000129e:	8526                	mv	a0,s1
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	f20080e7          	jalr	-224(ra) # 800011c0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012a8:	8526                	mv	a0,s1
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	624080e7          	jalr	1572(ra) # 800018ce <proc_mapstacks>
}
    800012b2:	8526                	mv	a0,s1
    800012b4:	60e2                	ld	ra,24(sp)
    800012b6:	6442                	ld	s0,16(sp)
    800012b8:	64a2                	ld	s1,8(sp)
    800012ba:	6902                	ld	s2,0(sp)
    800012bc:	6105                	addi	sp,sp,32
    800012be:	8082                	ret

00000000800012c0 <kvminit>:
{
    800012c0:	1141                	addi	sp,sp,-16
    800012c2:	e406                	sd	ra,8(sp)
    800012c4:	e022                	sd	s0,0(sp)
    800012c6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	f28080e7          	jalr	-216(ra) # 800011f0 <kvmmake>
    800012d0:	00007797          	auipc	a5,0x7
    800012d4:	60a7b823          	sd	a0,1552(a5) # 800088e0 <kernel_pagetable>
}
    800012d8:	60a2                	ld	ra,8(sp)
    800012da:	6402                	ld	s0,0(sp)
    800012dc:	0141                	addi	sp,sp,16
    800012de:	8082                	ret

00000000800012e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012e0:	715d                	addi	sp,sp,-80
    800012e2:	e486                	sd	ra,72(sp)
    800012e4:	e0a2                	sd	s0,64(sp)
    800012e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012e8:	03459793          	slli	a5,a1,0x34
    800012ec:	e39d                	bnez	a5,80001312 <uvmunmap+0x32>
    800012ee:	f84a                	sd	s2,48(sp)
    800012f0:	f44e                	sd	s3,40(sp)
    800012f2:	f052                	sd	s4,32(sp)
    800012f4:	ec56                	sd	s5,24(sp)
    800012f6:	e85a                	sd	s6,16(sp)
    800012f8:	e45e                	sd	s7,8(sp)
    800012fa:	8a2a                	mv	s4,a0
    800012fc:	892e                	mv	s2,a1
    800012fe:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001300:	0632                	slli	a2,a2,0xc
    80001302:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001306:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001308:	6b05                	lui	s6,0x1
    8000130a:	0935fb63          	bgeu	a1,s3,800013a0 <uvmunmap+0xc0>
    8000130e:	fc26                	sd	s1,56(sp)
    80001310:	a8a9                	j	8000136a <uvmunmap+0x8a>
    80001312:	fc26                	sd	s1,56(sp)
    80001314:	f84a                	sd	s2,48(sp)
    80001316:	f44e                	sd	s3,40(sp)
    80001318:	f052                	sd	s4,32(sp)
    8000131a:	ec56                	sd	s5,24(sp)
    8000131c:	e85a                	sd	s6,16(sp)
    8000131e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	dc050513          	addi	a0,a0,-576 # 800080e0 <etext+0xe0>
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	238080e7          	jalr	568(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001330:	00007517          	auipc	a0,0x7
    80001334:	dc850513          	addi	a0,a0,-568 # 800080f8 <etext+0xf8>
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	228080e7          	jalr	552(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001340:	00007517          	auipc	a0,0x7
    80001344:	dc850513          	addi	a0,a0,-568 # 80008108 <etext+0x108>
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	218080e7          	jalr	536(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001350:	00007517          	auipc	a0,0x7
    80001354:	dd050513          	addi	a0,a0,-560 # 80008120 <etext+0x120>
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	208080e7          	jalr	520(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001360:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001364:	995a                	add	s2,s2,s6
    80001366:	03397c63          	bgeu	s2,s3,8000139e <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000136a:	4601                	li	a2,0
    8000136c:	85ca                	mv	a1,s2
    8000136e:	8552                	mv	a0,s4
    80001370:	00000097          	auipc	ra,0x0
    80001374:	cc2080e7          	jalr	-830(ra) # 80001032 <walk>
    80001378:	84aa                	mv	s1,a0
    8000137a:	d95d                	beqz	a0,80001330 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000137c:	6108                	ld	a0,0(a0)
    8000137e:	00157793          	andi	a5,a0,1
    80001382:	dfdd                	beqz	a5,80001340 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001384:	3ff57793          	andi	a5,a0,1023
    80001388:	fd7784e3          	beq	a5,s7,80001350 <uvmunmap+0x70>
    if(do_free){
    8000138c:	fc0a8ae3          	beqz	s5,80001360 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001390:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001392:	0532                	slli	a0,a0,0xc
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	6b8080e7          	jalr	1720(ra) # 80000a4c <kfree>
    8000139c:	b7d1                	j	80001360 <uvmunmap+0x80>
    8000139e:	74e2                	ld	s1,56(sp)
    800013a0:	7942                	ld	s2,48(sp)
    800013a2:	79a2                	ld	s3,40(sp)
    800013a4:	7a02                	ld	s4,32(sp)
    800013a6:	6ae2                	ld	s5,24(sp)
    800013a8:	6b42                	ld	s6,16(sp)
    800013aa:	6ba2                	ld	s7,8(sp)
  }
}
    800013ac:	60a6                	ld	ra,72(sp)
    800013ae:	6406                	ld	s0,64(sp)
    800013b0:	6161                	addi	sp,sp,80
    800013b2:	8082                	ret

00000000800013b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013be:	fffff097          	auipc	ra,0xfffff
    800013c2:	78c080e7          	jalr	1932(ra) # 80000b4a <kalloc>
    800013c6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013c8:	c519                	beqz	a0,800013d6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013ca:	6605                	lui	a2,0x1
    800013cc:	4581                	li	a1,0
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	968080e7          	jalr	-1688(ra) # 80000d36 <memset>
  return pagetable;
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret

00000000800013e2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013e2:	7179                	addi	sp,sp,-48
    800013e4:	f406                	sd	ra,40(sp)
    800013e6:	f022                	sd	s0,32(sp)
    800013e8:	ec26                	sd	s1,24(sp)
    800013ea:	e84a                	sd	s2,16(sp)
    800013ec:	e44e                	sd	s3,8(sp)
    800013ee:	e052                	sd	s4,0(sp)
    800013f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013f2:	6785                	lui	a5,0x1
    800013f4:	04f67863          	bgeu	a2,a5,80001444 <uvmfirst+0x62>
    800013f8:	8a2a                	mv	s4,a0
    800013fa:	89ae                	mv	s3,a1
    800013fc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	74c080e7          	jalr	1868(ra) # 80000b4a <kalloc>
    80001406:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001408:	6605                	lui	a2,0x1
    8000140a:	4581                	li	a1,0
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	92a080e7          	jalr	-1750(ra) # 80000d36 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001414:	4779                	li	a4,30
    80001416:	86ca                	mv	a3,s2
    80001418:	6605                	lui	a2,0x1
    8000141a:	4581                	li	a1,0
    8000141c:	8552                	mv	a0,s4
    8000141e:	00000097          	auipc	ra,0x0
    80001422:	cfc080e7          	jalr	-772(ra) # 8000111a <mappages>
  memmove(mem, src, sz);
    80001426:	8626                	mv	a2,s1
    80001428:	85ce                	mv	a1,s3
    8000142a:	854a                	mv	a0,s2
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	96e080e7          	jalr	-1682(ra) # 80000d9a <memmove>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret
    panic("uvmfirst: more than a page");
    80001444:	00007517          	auipc	a0,0x7
    80001448:	cf450513          	addi	a0,a0,-780 # 80008138 <etext+0x138>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	114080e7          	jalr	276(ra) # 80000560 <panic>

0000000080001454 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001454:	1101                	addi	sp,sp,-32
    80001456:	ec06                	sd	ra,24(sp)
    80001458:	e822                	sd	s0,16(sp)
    8000145a:	e426                	sd	s1,8(sp)
    8000145c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000145e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001460:	00b67d63          	bgeu	a2,a1,8000147a <uvmdealloc+0x26>
    80001464:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001466:	6785                	lui	a5,0x1
    80001468:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000146a:	00f60733          	add	a4,a2,a5
    8000146e:	76fd                	lui	a3,0xfffff
    80001470:	8f75                	and	a4,a4,a3
    80001472:	97ae                	add	a5,a5,a1
    80001474:	8ff5                	and	a5,a5,a3
    80001476:	00f76863          	bltu	a4,a5,80001486 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000147a:	8526                	mv	a0,s1
    8000147c:	60e2                	ld	ra,24(sp)
    8000147e:	6442                	ld	s0,16(sp)
    80001480:	64a2                	ld	s1,8(sp)
    80001482:	6105                	addi	sp,sp,32
    80001484:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001486:	8f99                	sub	a5,a5,a4
    80001488:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000148a:	4685                	li	a3,1
    8000148c:	0007861b          	sext.w	a2,a5
    80001490:	85ba                	mv	a1,a4
    80001492:	00000097          	auipc	ra,0x0
    80001496:	e4e080e7          	jalr	-434(ra) # 800012e0 <uvmunmap>
    8000149a:	b7c5                	j	8000147a <uvmdealloc+0x26>

000000008000149c <uvmalloc>:
  if(newsz < oldsz)
    8000149c:	0ab66f63          	bltu	a2,a1,8000155a <uvmalloc+0xbe>
{
    800014a0:	715d                	addi	sp,sp,-80
    800014a2:	e486                	sd	ra,72(sp)
    800014a4:	e0a2                	sd	s0,64(sp)
    800014a6:	f052                	sd	s4,32(sp)
    800014a8:	ec56                	sd	s5,24(sp)
    800014aa:	e85a                	sd	s6,16(sp)
    800014ac:	0880                	addi	s0,sp,80
    800014ae:	8b2a                	mv	s6,a0
    800014b0:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800014b2:	6785                	lui	a5,0x1
    800014b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	77fd                	lui	a5,0xfffff
    800014ba:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014be:	0aca7063          	bgeu	s4,a2,8000155e <uvmalloc+0xc2>
    800014c2:	fc26                	sd	s1,56(sp)
    800014c4:	f84a                	sd	s2,48(sp)
    800014c6:	f44e                	sd	s3,40(sp)
    800014c8:	e45e                	sd	s7,8(sp)
    800014ca:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800014cc:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014ce:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	678080e7          	jalr	1656(ra) # 80000b4a <kalloc>
    800014da:	84aa                	mv	s1,a0
    if(mem == 0){
    800014dc:	c915                	beqz	a0,80001510 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    800014de:	864e                	mv	a2,s3
    800014e0:	4581                	li	a1,0
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	854080e7          	jalr	-1964(ra) # 80000d36 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014ea:	875e                	mv	a4,s7
    800014ec:	86a6                	mv	a3,s1
    800014ee:	864e                	mv	a2,s3
    800014f0:	85ca                	mv	a1,s2
    800014f2:	855a                	mv	a0,s6
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	c26080e7          	jalr	-986(ra) # 8000111a <mappages>
    800014fc:	ed0d                	bnez	a0,80001536 <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014fe:	994e                	add	s2,s2,s3
    80001500:	fd5969e3          	bltu	s2,s5,800014d2 <uvmalloc+0x36>
  return newsz;
    80001504:	8556                	mv	a0,s5
    80001506:	74e2                	ld	s1,56(sp)
    80001508:	7942                	ld	s2,48(sp)
    8000150a:	79a2                	ld	s3,40(sp)
    8000150c:	6ba2                	ld	s7,8(sp)
    8000150e:	a829                	j	80001528 <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    80001510:	8652                	mv	a2,s4
    80001512:	85ca                	mv	a1,s2
    80001514:	855a                	mv	a0,s6
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	f3e080e7          	jalr	-194(ra) # 80001454 <uvmdealloc>
      return 0;
    8000151e:	4501                	li	a0,0
    80001520:	74e2                	ld	s1,56(sp)
    80001522:	7942                	ld	s2,48(sp)
    80001524:	79a2                	ld	s3,40(sp)
    80001526:	6ba2                	ld	s7,8(sp)
}
    80001528:	60a6                	ld	ra,72(sp)
    8000152a:	6406                	ld	s0,64(sp)
    8000152c:	7a02                	ld	s4,32(sp)
    8000152e:	6ae2                	ld	s5,24(sp)
    80001530:	6b42                	ld	s6,16(sp)
    80001532:	6161                	addi	sp,sp,80
    80001534:	8082                	ret
      kfree(mem);
    80001536:	8526                	mv	a0,s1
    80001538:	fffff097          	auipc	ra,0xfffff
    8000153c:	514080e7          	jalr	1300(ra) # 80000a4c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001540:	8652                	mv	a2,s4
    80001542:	85ca                	mv	a1,s2
    80001544:	855a                	mv	a0,s6
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	f0e080e7          	jalr	-242(ra) # 80001454 <uvmdealloc>
      return 0;
    8000154e:	4501                	li	a0,0
    80001550:	74e2                	ld	s1,56(sp)
    80001552:	7942                	ld	s2,48(sp)
    80001554:	79a2                	ld	s3,40(sp)
    80001556:	6ba2                	ld	s7,8(sp)
    80001558:	bfc1                	j	80001528 <uvmalloc+0x8c>
    return oldsz;
    8000155a:	852e                	mv	a0,a1
}
    8000155c:	8082                	ret
  return newsz;
    8000155e:	8532                	mv	a0,a2
    80001560:	b7e1                	j	80001528 <uvmalloc+0x8c>

0000000080001562 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001562:	7179                	addi	sp,sp,-48
    80001564:	f406                	sd	ra,40(sp)
    80001566:	f022                	sd	s0,32(sp)
    80001568:	ec26                	sd	s1,24(sp)
    8000156a:	e84a                	sd	s2,16(sp)
    8000156c:	e44e                	sd	s3,8(sp)
    8000156e:	e052                	sd	s4,0(sp)
    80001570:	1800                	addi	s0,sp,48
    80001572:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001574:	84aa                	mv	s1,a0
    80001576:	6905                	lui	s2,0x1
    80001578:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000157a:	4985                	li	s3,1
    8000157c:	a829                	j	80001596 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000157e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001580:	00c79513          	slli	a0,a5,0xc
    80001584:	00000097          	auipc	ra,0x0
    80001588:	fde080e7          	jalr	-34(ra) # 80001562 <freewalk>
      pagetable[i] = 0;
    8000158c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001590:	04a1                	addi	s1,s1,8
    80001592:	03248163          	beq	s1,s2,800015b4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001596:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001598:	00f7f713          	andi	a4,a5,15
    8000159c:	ff3701e3          	beq	a4,s3,8000157e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015a0:	8b85                	andi	a5,a5,1
    800015a2:	d7fd                	beqz	a5,80001590 <freewalk+0x2e>
      panic("freewalk: leaf");
    800015a4:	00007517          	auipc	a0,0x7
    800015a8:	bb450513          	addi	a0,a0,-1100 # 80008158 <etext+0x158>
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	fb4080e7          	jalr	-76(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800015b4:	8552                	mv	a0,s4
    800015b6:	fffff097          	auipc	ra,0xfffff
    800015ba:	496080e7          	jalr	1174(ra) # 80000a4c <kfree>
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6a02                	ld	s4,0(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015ce:	1101                	addi	sp,sp,-32
    800015d0:	ec06                	sd	ra,24(sp)
    800015d2:	e822                	sd	s0,16(sp)
    800015d4:	e426                	sd	s1,8(sp)
    800015d6:	1000                	addi	s0,sp,32
    800015d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800015da:	e999                	bnez	a1,800015f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015dc:	8526                	mv	a0,s1
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	f84080e7          	jalr	-124(ra) # 80001562 <freewalk>
}
    800015e6:	60e2                	ld	ra,24(sp)
    800015e8:	6442                	ld	s0,16(sp)
    800015ea:	64a2                	ld	s1,8(sp)
    800015ec:	6105                	addi	sp,sp,32
    800015ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015f0:	6785                	lui	a5,0x1
    800015f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015f4:	95be                	add	a1,a1,a5
    800015f6:	4685                	li	a3,1
    800015f8:	00c5d613          	srli	a2,a1,0xc
    800015fc:	4581                	li	a1,0
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	ce2080e7          	jalr	-798(ra) # 800012e0 <uvmunmap>
    80001606:	bfd9                	j	800015dc <uvmfree+0xe>

0000000080001608 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001608:	ca69                	beqz	a2,800016da <uvmcopy+0xd2>
{
    8000160a:	715d                	addi	sp,sp,-80
    8000160c:	e486                	sd	ra,72(sp)
    8000160e:	e0a2                	sd	s0,64(sp)
    80001610:	fc26                	sd	s1,56(sp)
    80001612:	f84a                	sd	s2,48(sp)
    80001614:	f44e                	sd	s3,40(sp)
    80001616:	f052                	sd	s4,32(sp)
    80001618:	ec56                	sd	s5,24(sp)
    8000161a:	e85a                	sd	s6,16(sp)
    8000161c:	e45e                	sd	s7,8(sp)
    8000161e:	e062                	sd	s8,0(sp)
    80001620:	0880                	addi	s0,sp,80
    80001622:	8baa                	mv	s7,a0
    80001624:	8b2e                	mv	s6,a1
    80001626:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001628:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162a:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000162c:	4601                	li	a2,0
    8000162e:	85ce                	mv	a1,s3
    80001630:	855e                	mv	a0,s7
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a00080e7          	jalr	-1536(ra) # 80001032 <walk>
    8000163a:	c529                	beqz	a0,80001684 <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    8000163c:	6118                	ld	a4,0(a0)
    8000163e:	00177793          	andi	a5,a4,1
    80001642:	cba9                	beqz	a5,80001694 <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    80001644:	00a75593          	srli	a1,a4,0xa
    80001648:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000164c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	4fa080e7          	jalr	1274(ra) # 80000b4a <kalloc>
    80001658:	892a                	mv	s2,a0
    8000165a:	c931                	beqz	a0,800016ae <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    8000165c:	8652                	mv	a2,s4
    8000165e:	85e2                	mv	a1,s8
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	73a080e7          	jalr	1850(ra) # 80000d9a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001668:	8726                	mv	a4,s1
    8000166a:	86ca                	mv	a3,s2
    8000166c:	8652                	mv	a2,s4
    8000166e:	85ce                	mv	a1,s3
    80001670:	855a                	mv	a0,s6
    80001672:	00000097          	auipc	ra,0x0
    80001676:	aa8080e7          	jalr	-1368(ra) # 8000111a <mappages>
    8000167a:	e50d                	bnez	a0,800016a4 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    8000167c:	99d2                	add	s3,s3,s4
    8000167e:	fb59e7e3          	bltu	s3,s5,8000162c <uvmcopy+0x24>
    80001682:	a081                	j	800016c2 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	ae450513          	addi	a0,a0,-1308 # 80008168 <etext+0x168>
    8000168c:	fffff097          	auipc	ra,0xfffff
    80001690:	ed4080e7          	jalr	-300(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	af450513          	addi	a0,a0,-1292 # 80008188 <etext+0x188>
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	ec4080e7          	jalr	-316(ra) # 80000560 <panic>
      kfree(mem);
    800016a4:	854a                	mv	a0,s2
    800016a6:	fffff097          	auipc	ra,0xfffff
    800016aa:	3a6080e7          	jalr	934(ra) # 80000a4c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016ae:	4685                	li	a3,1
    800016b0:	00c9d613          	srli	a2,s3,0xc
    800016b4:	4581                	li	a1,0
    800016b6:	855a                	mv	a0,s6
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	c28080e7          	jalr	-984(ra) # 800012e0 <uvmunmap>
  return -1;
    800016c0:	557d                	li	a0,-1
}
    800016c2:	60a6                	ld	ra,72(sp)
    800016c4:	6406                	ld	s0,64(sp)
    800016c6:	74e2                	ld	s1,56(sp)
    800016c8:	7942                	ld	s2,48(sp)
    800016ca:	79a2                	ld	s3,40(sp)
    800016cc:	7a02                	ld	s4,32(sp)
    800016ce:	6ae2                	ld	s5,24(sp)
    800016d0:	6b42                	ld	s6,16(sp)
    800016d2:	6ba2                	ld	s7,8(sp)
    800016d4:	6c02                	ld	s8,0(sp)
    800016d6:	6161                	addi	sp,sp,80
    800016d8:	8082                	ret
  return 0;
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret

00000000800016de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016de:	1141                	addi	sp,sp,-16
    800016e0:	e406                	sd	ra,8(sp)
    800016e2:	e022                	sd	s0,0(sp)
    800016e4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016e6:	4601                	li	a2,0
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	94a080e7          	jalr	-1718(ra) # 80001032 <walk>
  if(pte == 0)
    800016f0:	c901                	beqz	a0,80001700 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016f2:	611c                	ld	a5,0(a0)
    800016f4:	9bbd                	andi	a5,a5,-17
    800016f6:	e11c                	sd	a5,0(a0)
}
    800016f8:	60a2                	ld	ra,8(sp)
    800016fa:	6402                	ld	s0,0(sp)
    800016fc:	0141                	addi	sp,sp,16
    800016fe:	8082                	ret
    panic("uvmclear");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	aa850513          	addi	a0,a0,-1368 # 800081a8 <etext+0x1a8>
    80001708:	fffff097          	auipc	ra,0xfffff
    8000170c:	e58080e7          	jalr	-424(ra) # 80000560 <panic>

0000000080001710 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001710:	c6bd                	beqz	a3,8000177e <copyout+0x6e>
{
    80001712:	715d                	addi	sp,sp,-80
    80001714:	e486                	sd	ra,72(sp)
    80001716:	e0a2                	sd	s0,64(sp)
    80001718:	fc26                	sd	s1,56(sp)
    8000171a:	f84a                	sd	s2,48(sp)
    8000171c:	f44e                	sd	s3,40(sp)
    8000171e:	f052                	sd	s4,32(sp)
    80001720:	ec56                	sd	s5,24(sp)
    80001722:	e85a                	sd	s6,16(sp)
    80001724:	e45e                	sd	s7,8(sp)
    80001726:	e062                	sd	s8,0(sp)
    80001728:	0880                	addi	s0,sp,80
    8000172a:	8b2a                	mv	s6,a0
    8000172c:	8c2e                	mv	s8,a1
    8000172e:	8a32                	mv	s4,a2
    80001730:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001732:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001734:	6a85                	lui	s5,0x1
    80001736:	a015                	j	8000175a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001738:	9562                	add	a0,a0,s8
    8000173a:	0004861b          	sext.w	a2,s1
    8000173e:	85d2                	mv	a1,s4
    80001740:	41250533          	sub	a0,a0,s2
    80001744:	fffff097          	auipc	ra,0xfffff
    80001748:	656080e7          	jalr	1622(ra) # 80000d9a <memmove>

    len -= n;
    8000174c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001750:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001752:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001756:	02098263          	beqz	s3,8000177a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000175a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175e:	85ca                	mv	a1,s2
    80001760:	855a                	mv	a0,s6
    80001762:	00000097          	auipc	ra,0x0
    80001766:	976080e7          	jalr	-1674(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    8000176a:	cd01                	beqz	a0,80001782 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000176c:	418904b3          	sub	s1,s2,s8
    80001770:	94d6                	add	s1,s1,s5
    if(n > len)
    80001772:	fc99f3e3          	bgeu	s3,s1,80001738 <copyout+0x28>
    80001776:	84ce                	mv	s1,s3
    80001778:	b7c1                	j	80001738 <copyout+0x28>
  }
  return 0;
    8000177a:	4501                	li	a0,0
    8000177c:	a021                	j	80001784 <copyout+0x74>
    8000177e:	4501                	li	a0,0
}
    80001780:	8082                	ret
      return -1;
    80001782:	557d                	li	a0,-1
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret

000000008000179c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000179c:	caa5                	beqz	a3,8000180c <copyin+0x70>
{
    8000179e:	715d                	addi	sp,sp,-80
    800017a0:	e486                	sd	ra,72(sp)
    800017a2:	e0a2                	sd	s0,64(sp)
    800017a4:	fc26                	sd	s1,56(sp)
    800017a6:	f84a                	sd	s2,48(sp)
    800017a8:	f44e                	sd	s3,40(sp)
    800017aa:	f052                	sd	s4,32(sp)
    800017ac:	ec56                	sd	s5,24(sp)
    800017ae:	e85a                	sd	s6,16(sp)
    800017b0:	e45e                	sd	s7,8(sp)
    800017b2:	e062                	sd	s8,0(sp)
    800017b4:	0880                	addi	s0,sp,80
    800017b6:	8b2a                	mv	s6,a0
    800017b8:	8a2e                	mv	s4,a1
    800017ba:	8c32                	mv	s8,a2
    800017bc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017be:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017c0:	6a85                	lui	s5,0x1
    800017c2:	a01d                	j	800017e8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017c4:	018505b3          	add	a1,a0,s8
    800017c8:	0004861b          	sext.w	a2,s1
    800017cc:	412585b3          	sub	a1,a1,s2
    800017d0:	8552                	mv	a0,s4
    800017d2:	fffff097          	auipc	ra,0xfffff
    800017d6:	5c8080e7          	jalr	1480(ra) # 80000d9a <memmove>

    len -= n;
    800017da:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017de:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017e0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017e4:	02098263          	beqz	s3,80001808 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017e8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017ec:	85ca                	mv	a1,s2
    800017ee:	855a                	mv	a0,s6
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	8e8080e7          	jalr	-1816(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    800017f8:	cd01                	beqz	a0,80001810 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017fa:	418904b3          	sub	s1,s2,s8
    800017fe:	94d6                	add	s1,s1,s5
    if(n > len)
    80001800:	fc99f2e3          	bgeu	s3,s1,800017c4 <copyin+0x28>
    80001804:	84ce                	mv	s1,s3
    80001806:	bf7d                	j	800017c4 <copyin+0x28>
  }
  return 0;
    80001808:	4501                	li	a0,0
    8000180a:	a021                	j	80001812 <copyin+0x76>
    8000180c:	4501                	li	a0,0
}
    8000180e:	8082                	ret
      return -1;
    80001810:	557d                	li	a0,-1
}
    80001812:	60a6                	ld	ra,72(sp)
    80001814:	6406                	ld	s0,64(sp)
    80001816:	74e2                	ld	s1,56(sp)
    80001818:	7942                	ld	s2,48(sp)
    8000181a:	79a2                	ld	s3,40(sp)
    8000181c:	7a02                	ld	s4,32(sp)
    8000181e:	6ae2                	ld	s5,24(sp)
    80001820:	6b42                	ld	s6,16(sp)
    80001822:	6ba2                	ld	s7,8(sp)
    80001824:	6c02                	ld	s8,0(sp)
    80001826:	6161                	addi	sp,sp,80
    80001828:	8082                	ret

000000008000182a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    8000182a:	715d                	addi	sp,sp,-80
    8000182c:	e486                	sd	ra,72(sp)
    8000182e:	e0a2                	sd	s0,64(sp)
    80001830:	fc26                	sd	s1,56(sp)
    80001832:	f84a                	sd	s2,48(sp)
    80001834:	f44e                	sd	s3,40(sp)
    80001836:	f052                	sd	s4,32(sp)
    80001838:	ec56                	sd	s5,24(sp)
    8000183a:	e85a                	sd	s6,16(sp)
    8000183c:	e45e                	sd	s7,8(sp)
    8000183e:	0880                	addi	s0,sp,80
    80001840:	8aaa                	mv	s5,a0
    80001842:	89ae                	mv	s3,a1
    80001844:	8bb2                	mv	s7,a2
    80001846:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001848:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000184a:	6a05                	lui	s4,0x1
    8000184c:	a02d                	j	80001876 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000184e:	00078023          	sb	zero,0(a5)
    80001852:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001854:	0017c793          	xori	a5,a5,1
    80001858:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000185c:	60a6                	ld	ra,72(sp)
    8000185e:	6406                	ld	s0,64(sp)
    80001860:	74e2                	ld	s1,56(sp)
    80001862:	7942                	ld	s2,48(sp)
    80001864:	79a2                	ld	s3,40(sp)
    80001866:	7a02                	ld	s4,32(sp)
    80001868:	6ae2                	ld	s5,24(sp)
    8000186a:	6b42                	ld	s6,16(sp)
    8000186c:	6ba2                	ld	s7,8(sp)
    8000186e:	6161                	addi	sp,sp,80
    80001870:	8082                	ret
    srcva = va0 + PGSIZE;
    80001872:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001876:	c8a1                	beqz	s1,800018c6 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001878:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000187c:	85ca                	mv	a1,s2
    8000187e:	8556                	mv	a0,s5
    80001880:	00000097          	auipc	ra,0x0
    80001884:	858080e7          	jalr	-1960(ra) # 800010d8 <walkaddr>
    if(pa0 == 0)
    80001888:	c129                	beqz	a0,800018ca <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    8000188a:	41790633          	sub	a2,s2,s7
    8000188e:	9652                	add	a2,a2,s4
    if(n > max)
    80001890:	00c4f363          	bgeu	s1,a2,80001896 <copyinstr+0x6c>
    80001894:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001896:	412b8bb3          	sub	s7,s7,s2
    8000189a:	9baa                	add	s7,s7,a0
    while(n > 0){
    8000189c:	da79                	beqz	a2,80001872 <copyinstr+0x48>
    8000189e:	87ce                	mv	a5,s3
      if(*p == '\0'){
    800018a0:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    800018a4:	964e                	add	a2,a2,s3
    800018a6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018a8:	00f68733          	add	a4,a3,a5
    800018ac:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda090>
    800018b0:	df59                	beqz	a4,8000184e <copyinstr+0x24>
        *dst = *p;
    800018b2:	00e78023          	sb	a4,0(a5)
      dst++;
    800018b6:	0785                	addi	a5,a5,1
    while(n > 0){
    800018b8:	fec797e3          	bne	a5,a2,800018a6 <copyinstr+0x7c>
    800018bc:	14fd                	addi	s1,s1,-1
    800018be:	94ce                	add	s1,s1,s3
      --max;
    800018c0:	8c8d                	sub	s1,s1,a1
    800018c2:	89be                	mv	s3,a5
    800018c4:	b77d                	j	80001872 <copyinstr+0x48>
    800018c6:	4781                	li	a5,0
    800018c8:	b771                	j	80001854 <copyinstr+0x2a>
      return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	bf41                	j	8000185c <copyinstr+0x32>

00000000800018ce <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    800018ce:	715d                	addi	sp,sp,-80
    800018d0:	e486                	sd	ra,72(sp)
    800018d2:	e0a2                	sd	s0,64(sp)
    800018d4:	fc26                	sd	s1,56(sp)
    800018d6:	f84a                	sd	s2,48(sp)
    800018d8:	f44e                	sd	s3,40(sp)
    800018da:	f052                	sd	s4,32(sp)
    800018dc:	ec56                	sd	s5,24(sp)
    800018de:	e85a                	sd	s6,16(sp)
    800018e0:	e45e                	sd	s7,8(sp)
    800018e2:	e062                	sd	s8,0(sp)
    800018e4:	0880                	addi	s0,sp,80
    800018e6:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800018e8:	0000f497          	auipc	s1,0xf
    800018ec:	6a848493          	addi	s1,s1,1704 # 80010f90 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    800018f0:	8c26                	mv	s8,s1
    800018f2:	8af8b7b7          	lui	a5,0x8af8b
    800018f6:	f8b78793          	addi	a5,a5,-117 # ffffffff8af8af8b <end+0xffffffff0af6601b>
    800018fa:	af8b0937          	lui	s2,0xaf8b0
    800018fe:	8b090913          	addi	s2,s2,-1872 # ffffffffaf8af8b0 <end+0xffffffff2f88a940>
    80001902:	1902                	slli	s2,s2,0x20
    80001904:	993e                	add	s2,s2,a5
    80001906:	040009b7          	lui	s3,0x4000
    8000190a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000190c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000190e:	4b99                	li	s7,6
    80001910:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++)
    80001912:	00018a97          	auipc	s5,0x18
    80001916:	27ea8a93          	addi	s5,s5,638 # 80019b90 <tickslock>
    char *pa = kalloc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	230080e7          	jalr	560(ra) # 80000b4a <kalloc>
    80001922:	862a                	mv	a2,a0
    if (pa == 0)
    80001924:	c131                	beqz	a0,80001968 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int)(p - proc));
    80001926:	418485b3          	sub	a1,s1,s8
    8000192a:	8591                	srai	a1,a1,0x4
    8000192c:	032585b3          	mul	a1,a1,s2
    80001930:	2585                	addiw	a1,a1,1
    80001932:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001936:	875e                	mv	a4,s7
    80001938:	86da                	mv	a3,s6
    8000193a:	40b985b3          	sub	a1,s3,a1
    8000193e:	8552                	mv	a0,s4
    80001940:	00000097          	auipc	ra,0x0
    80001944:	880080e7          	jalr	-1920(ra) # 800011c0 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001948:	23048493          	addi	s1,s1,560
    8000194c:	fd5497e3          	bne	s1,s5,8000191a <proc_mapstacks+0x4c>
  }
}
    80001950:	60a6                	ld	ra,72(sp)
    80001952:	6406                	ld	s0,64(sp)
    80001954:	74e2                	ld	s1,56(sp)
    80001956:	7942                	ld	s2,48(sp)
    80001958:	79a2                	ld	s3,40(sp)
    8000195a:	7a02                	ld	s4,32(sp)
    8000195c:	6ae2                	ld	s5,24(sp)
    8000195e:	6b42                	ld	s6,16(sp)
    80001960:	6ba2                	ld	s7,8(sp)
    80001962:	6c02                	ld	s8,0(sp)
    80001964:	6161                	addi	sp,sp,80
    80001966:	8082                	ret
      panic("kalloc");
    80001968:	00007517          	auipc	a0,0x7
    8000196c:	85050513          	addi	a0,a0,-1968 # 800081b8 <etext+0x1b8>
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	bf0080e7          	jalr	-1040(ra) # 80000560 <panic>

0000000080001978 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001978:	7139                	addi	sp,sp,-64
    8000197a:	fc06                	sd	ra,56(sp)
    8000197c:	f822                	sd	s0,48(sp)
    8000197e:	f426                	sd	s1,40(sp)
    80001980:	f04a                	sd	s2,32(sp)
    80001982:	ec4e                	sd	s3,24(sp)
    80001984:	e852                	sd	s4,16(sp)
    80001986:	e456                	sd	s5,8(sp)
    80001988:	e05a                	sd	s6,0(sp)
    8000198a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000198c:	00007597          	auipc	a1,0x7
    80001990:	83458593          	addi	a1,a1,-1996 # 800081c0 <etext+0x1c0>
    80001994:	0000f517          	auipc	a0,0xf
    80001998:	1cc50513          	addi	a0,a0,460 # 80010b60 <pid_lock>
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	20e080e7          	jalr	526(ra) # 80000baa <initlock>
  initlock(&wait_lock, "wait_lock");
    800019a4:	00007597          	auipc	a1,0x7
    800019a8:	82458593          	addi	a1,a1,-2012 # 800081c8 <etext+0x1c8>
    800019ac:	0000f517          	auipc	a0,0xf
    800019b0:	1cc50513          	addi	a0,a0,460 # 80010b78 <wait_lock>
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	1f6080e7          	jalr	502(ra) # 80000baa <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    800019bc:	0000f497          	auipc	s1,0xf
    800019c0:	5d448493          	addi	s1,s1,1492 # 80010f90 <proc>
  {
    initlock(&p->lock, "proc");
    800019c4:	00007b17          	auipc	s6,0x7
    800019c8:	814b0b13          	addi	s6,s6,-2028 # 800081d8 <etext+0x1d8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    800019cc:	8aa6                	mv	s5,s1
    800019ce:	8af8b7b7          	lui	a5,0x8af8b
    800019d2:	f8b78793          	addi	a5,a5,-117 # ffffffff8af8af8b <end+0xffffffff0af6601b>
    800019d6:	af8b0937          	lui	s2,0xaf8b0
    800019da:	8b090913          	addi	s2,s2,-1872 # ffffffffaf8af8b0 <end+0xffffffff2f88a940>
    800019de:	1902                	slli	s2,s2,0x20
    800019e0:	993e                	add	s2,s2,a5
    800019e2:	040009b7          	lui	s3,0x4000
    800019e6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019e8:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    800019ea:	00018a17          	auipc	s4,0x18
    800019ee:	1a6a0a13          	addi	s4,s4,422 # 80019b90 <tickslock>
    initlock(&p->lock, "proc");
    800019f2:	85da                	mv	a1,s6
    800019f4:	8526                	mv	a0,s1
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	1b4080e7          	jalr	436(ra) # 80000baa <initlock>
    p->state = UNUSED;
    800019fe:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001a02:	415487b3          	sub	a5,s1,s5
    80001a06:	8791                	srai	a5,a5,0x4
    80001a08:	032787b3          	mul	a5,a5,s2
    80001a0c:	2785                	addiw	a5,a5,1
    80001a0e:	00d7979b          	slliw	a5,a5,0xd
    80001a12:	40f987b3          	sub	a5,s3,a5
    80001a16:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001a18:	23048493          	addi	s1,s1,560
    80001a1c:	fd449be3          	bne	s1,s4,800019f2 <procinit+0x7a>
  }
}
    80001a20:	70e2                	ld	ra,56(sp)
    80001a22:	7442                	ld	s0,48(sp)
    80001a24:	74a2                	ld	s1,40(sp)
    80001a26:	7902                	ld	s2,32(sp)
    80001a28:	69e2                	ld	s3,24(sp)
    80001a2a:	6a42                	ld	s4,16(sp)
    80001a2c:	6aa2                	ld	s5,8(sp)
    80001a2e:	6b02                	ld	s6,0(sp)
    80001a30:	6121                	addi	sp,sp,64
    80001a32:	8082                	ret

0000000080001a34 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001a34:	1141                	addi	sp,sp,-16
    80001a36:	e406                	sd	ra,8(sp)
    80001a38:	e022                	sd	s0,0(sp)
    80001a3a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a3c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a3e:	2501                	sext.w	a0,a0
    80001a40:	60a2                	ld	ra,8(sp)
    80001a42:	6402                	ld	s0,0(sp)
    80001a44:	0141                	addi	sp,sp,16
    80001a46:	8082                	ret

0000000080001a48 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001a48:	1141                	addi	sp,sp,-16
    80001a4a:	e406                	sd	ra,8(sp)
    80001a4c:	e022                	sd	s0,0(sp)
    80001a4e:	0800                	addi	s0,sp,16
    80001a50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a52:	2781                	sext.w	a5,a5
    80001a54:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a56:	0000f517          	auipc	a0,0xf
    80001a5a:	13a50513          	addi	a0,a0,314 # 80010b90 <cpus>
    80001a5e:	953e                	add	a0,a0,a5
    80001a60:	60a2                	ld	ra,8(sp)
    80001a62:	6402                	ld	s0,0(sp)
    80001a64:	0141                	addi	sp,sp,16
    80001a66:	8082                	ret

0000000080001a68 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001a68:	1101                	addi	sp,sp,-32
    80001a6a:	ec06                	sd	ra,24(sp)
    80001a6c:	e822                	sd	s0,16(sp)
    80001a6e:	e426                	sd	s1,8(sp)
    80001a70:	1000                	addi	s0,sp,32
  push_off();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	180080e7          	jalr	384(ra) # 80000bf2 <push_off>
    80001a7a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a7c:	2781                	sext.w	a5,a5
    80001a7e:	079e                	slli	a5,a5,0x7
    80001a80:	0000f717          	auipc	a4,0xf
    80001a84:	0e070713          	addi	a4,a4,224 # 80010b60 <pid_lock>
    80001a88:	97ba                	add	a5,a5,a4
    80001a8a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	206080e7          	jalr	518(ra) # 80000c92 <pop_off>
  return p;
}
    80001a94:	8526                	mv	a0,s1
    80001a96:	60e2                	ld	ra,24(sp)
    80001a98:	6442                	ld	s0,16(sp)
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret

0000000080001aa0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001aa0:	1141                	addi	sp,sp,-16
    80001aa2:	e406                	sd	ra,8(sp)
    80001aa4:	e022                	sd	s0,0(sp)
    80001aa6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001aa8:	00000097          	auipc	ra,0x0
    80001aac:	fc0080e7          	jalr	-64(ra) # 80001a68 <myproc>
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	23e080e7          	jalr	574(ra) # 80000cee <release>

  if (first)
    80001ab8:	00007797          	auipc	a5,0x7
    80001abc:	da87a783          	lw	a5,-600(a5) # 80008860 <first.1>
    80001ac0:	eb89                	bnez	a5,80001ad2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001ac2:	00001097          	auipc	ra,0x1
    80001ac6:	f8c080e7          	jalr	-116(ra) # 80002a4e <usertrapret>
}
    80001aca:	60a2                	ld	ra,8(sp)
    80001acc:	6402                	ld	s0,0(sp)
    80001ace:	0141                	addi	sp,sp,16
    80001ad0:	8082                	ret
    first = 0;
    80001ad2:	00007797          	auipc	a5,0x7
    80001ad6:	d807a723          	sw	zero,-626(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80001ada:	4505                	li	a0,1
    80001adc:	00002097          	auipc	ra,0x2
    80001ae0:	f2e080e7          	jalr	-210(ra) # 80003a0a <fsinit>
    80001ae4:	bff9                	j	80001ac2 <forkret+0x22>

0000000080001ae6 <allocpid>:
{
    80001ae6:	1101                	addi	sp,sp,-32
    80001ae8:	ec06                	sd	ra,24(sp)
    80001aea:	e822                	sd	s0,16(sp)
    80001aec:	e426                	sd	s1,8(sp)
    80001aee:	e04a                	sd	s2,0(sp)
    80001af0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001af2:	0000f917          	auipc	s2,0xf
    80001af6:	06e90913          	addi	s2,s2,110 # 80010b60 <pid_lock>
    80001afa:	854a                	mv	a0,s2
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	142080e7          	jalr	322(ra) # 80000c3e <acquire>
  pid = nextpid;
    80001b04:	00007797          	auipc	a5,0x7
    80001b08:	d6c78793          	addi	a5,a5,-660 # 80008870 <nextpid>
    80001b0c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b0e:	0014871b          	addiw	a4,s1,1
    80001b12:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b14:	854a                	mv	a0,s2
    80001b16:	fffff097          	auipc	ra,0xfffff
    80001b1a:	1d8080e7          	jalr	472(ra) # 80000cee <release>
}
    80001b1e:	8526                	mv	a0,s1
    80001b20:	60e2                	ld	ra,24(sp)
    80001b22:	6442                	ld	s0,16(sp)
    80001b24:	64a2                	ld	s1,8(sp)
    80001b26:	6902                	ld	s2,0(sp)
    80001b28:	6105                	addi	sp,sp,32
    80001b2a:	8082                	ret

0000000080001b2c <proc_pagetable>:
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	e04a                	sd	s2,0(sp)
    80001b36:	1000                	addi	s0,sp,32
    80001b38:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b3a:	00000097          	auipc	ra,0x0
    80001b3e:	87a080e7          	jalr	-1926(ra) # 800013b4 <uvmcreate>
    80001b42:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001b44:	c121                	beqz	a0,80001b84 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b46:	4729                	li	a4,10
    80001b48:	00005697          	auipc	a3,0x5
    80001b4c:	4b868693          	addi	a3,a3,1208 # 80007000 <_trampoline>
    80001b50:	6605                	lui	a2,0x1
    80001b52:	040005b7          	lui	a1,0x4000
    80001b56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b58:	05b2                	slli	a1,a1,0xc
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	5c0080e7          	jalr	1472(ra) # 8000111a <mappages>
    80001b62:	02054863          	bltz	a0,80001b92 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b66:	4719                	li	a4,6
    80001b68:	05893683          	ld	a3,88(s2)
    80001b6c:	6605                	lui	a2,0x1
    80001b6e:	020005b7          	lui	a1,0x2000
    80001b72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b74:	05b6                	slli	a1,a1,0xd
    80001b76:	8526                	mv	a0,s1
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	5a2080e7          	jalr	1442(ra) # 8000111a <mappages>
    80001b80:	02054163          	bltz	a0,80001ba2 <proc_pagetable+0x76>
}
    80001b84:	8526                	mv	a0,s1
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret
    uvmfree(pagetable, 0);
    80001b92:	4581                	li	a1,0
    80001b94:	8526                	mv	a0,s1
    80001b96:	00000097          	auipc	ra,0x0
    80001b9a:	a38080e7          	jalr	-1480(ra) # 800015ce <uvmfree>
    return 0;
    80001b9e:	4481                	li	s1,0
    80001ba0:	b7d5                	j	80001b84 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ba2:	4681                	li	a3,0
    80001ba4:	4605                	li	a2,1
    80001ba6:	040005b7          	lui	a1,0x4000
    80001baa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bac:	05b2                	slli	a1,a1,0xc
    80001bae:	8526                	mv	a0,s1
    80001bb0:	fffff097          	auipc	ra,0xfffff
    80001bb4:	730080e7          	jalr	1840(ra) # 800012e0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bb8:	4581                	li	a1,0
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00000097          	auipc	ra,0x0
    80001bc0:	a12080e7          	jalr	-1518(ra) # 800015ce <uvmfree>
    return 0;
    80001bc4:	4481                	li	s1,0
    80001bc6:	bf7d                	j	80001b84 <proc_pagetable+0x58>

0000000080001bc8 <proc_freepagetable>:
{
    80001bc8:	1101                	addi	sp,sp,-32
    80001bca:	ec06                	sd	ra,24(sp)
    80001bcc:	e822                	sd	s0,16(sp)
    80001bce:	e426                	sd	s1,8(sp)
    80001bd0:	e04a                	sd	s2,0(sp)
    80001bd2:	1000                	addi	s0,sp,32
    80001bd4:	84aa                	mv	s1,a0
    80001bd6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bd8:	4681                	li	a3,0
    80001bda:	4605                	li	a2,1
    80001bdc:	040005b7          	lui	a1,0x4000
    80001be0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001be2:	05b2                	slli	a1,a1,0xc
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	6fc080e7          	jalr	1788(ra) # 800012e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bec:	4681                	li	a3,0
    80001bee:	4605                	li	a2,1
    80001bf0:	020005b7          	lui	a1,0x2000
    80001bf4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bf6:	05b6                	slli	a1,a1,0xd
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	6e6080e7          	jalr	1766(ra) # 800012e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c02:	85ca                	mv	a1,s2
    80001c04:	8526                	mv	a0,s1
    80001c06:	00000097          	auipc	ra,0x0
    80001c0a:	9c8080e7          	jalr	-1592(ra) # 800015ce <uvmfree>
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6902                	ld	s2,0(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <freeproc>:
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001c26:	6d28                	ld	a0,88(a0)
    80001c28:	c509                	beqz	a0,80001c32 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	e22080e7          	jalr	-478(ra) # 80000a4c <kfree>
  p->trapframe = 0;
    80001c32:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001c36:	68a8                	ld	a0,80(s1)
    80001c38:	c511                	beqz	a0,80001c44 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c3a:	64ac                	ld	a1,72(s1)
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	f8c080e7          	jalr	-116(ra) # 80001bc8 <proc_freepagetable>
  p->pagetable = 0;
    80001c44:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c48:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c4c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c50:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c54:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c58:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c5c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c60:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c64:	0004ac23          	sw	zero,24(s1)
}
    80001c68:	60e2                	ld	ra,24(sp)
    80001c6a:	6442                	ld	s0,16(sp)
    80001c6c:	64a2                	ld	s1,8(sp)
    80001c6e:	6105                	addi	sp,sp,32
    80001c70:	8082                	ret

0000000080001c72 <allocproc>:
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	e04a                	sd	s2,0(sp)
    80001c7c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001c7e:	0000f497          	auipc	s1,0xf
    80001c82:	31248493          	addi	s1,s1,786 # 80010f90 <proc>
    80001c86:	00018917          	auipc	s2,0x18
    80001c8a:	f0a90913          	addi	s2,s2,-246 # 80019b90 <tickslock>
    acquire(&p->lock);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	fae080e7          	jalr	-82(ra) # 80000c3e <acquire>
    if (p->state == UNUSED)
    80001c98:	4c9c                	lw	a5,24(s1)
    80001c9a:	cf81                	beqz	a5,80001cb2 <allocproc+0x40>
      release(&p->lock);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	050080e7          	jalr	80(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ca6:	23048493          	addi	s1,s1,560
    80001caa:	ff2492e3          	bne	s1,s2,80001c8e <allocproc+0x1c>
  return 0;
    80001cae:	4481                	li	s1,0
    80001cb0:	a04d                	j	80001d52 <allocproc+0xe0>
  p->pid = allocpid();
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	e34080e7          	jalr	-460(ra) # 80001ae6 <allocpid>
    80001cba:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cbc:	4785                	li	a5,1
    80001cbe:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	e8a080e7          	jalr	-374(ra) # 80000b4a <kalloc>
    80001cc8:	892a                	mv	s2,a0
    80001cca:	eca8                	sd	a0,88(s1)
    80001ccc:	c951                	beqz	a0,80001d60 <allocproc+0xee>
  p->pagetable = proc_pagetable(p);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	e5c080e7          	jalr	-420(ra) # 80001b2c <proc_pagetable>
    80001cd8:	892a                	mv	s2,a0
    80001cda:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001cdc:	cd51                	beqz	a0,80001d78 <allocproc+0x106>
  memset(&p->context, 0, sizeof(p->context));
    80001cde:	07000613          	li	a2,112
    80001ce2:	4581                	li	a1,0
    80001ce4:	06048513          	addi	a0,s1,96
    80001ce8:	fffff097          	auipc	ra,0xfffff
    80001cec:	04e080e7          	jalr	78(ra) # 80000d36 <memset>
  p->context.ra = (uint64)forkret;
    80001cf0:	00000797          	auipc	a5,0x0
    80001cf4:	db078793          	addi	a5,a5,-592 # 80001aa0 <forkret>
    80001cf8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cfa:	60bc                	ld	a5,64(s1)
    80001cfc:	6705                	lui	a4,0x1
    80001cfe:	97ba                	add	a5,a5,a4
    80001d00:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001d02:	1e04a423          	sw	zero,488(s1)
  p->etime = 0;
    80001d06:	1e04a823          	sw	zero,496(s1)
  p->ctime = ticks;
    80001d0a:	00007797          	auipc	a5,0x7
    80001d0e:	bea7a783          	lw	a5,-1046(a5) # 800088f4 <ticks>
    80001d12:	1ef4a623          	sw	a5,492(s1)
  p->alaramflag=0;
    80001d16:	2004ac23          	sw	zero,536(s1)
  p->alarmcount=0;
    80001d1a:	2004a023          	sw	zero,512(s1)
  p->clockcyclepassed=0;
    80001d1e:	1e04bc23          	sd	zero,504(s1)
  p->handleraddress=0;
    80001d22:	2004b423          	sd	zero,520(s1)
  p->tickets=1;
    80001d26:	4785                	li	a5,1
    80001d28:	20f4ae23          	sw	a5,540(s1)
  p->entrytime=sudotime;
    80001d2c:	00007797          	auipc	a5,0x7
    80001d30:	bc47a783          	lw	a5,-1084(a5) # 800088f0 <sudotime>
    80001d34:	22f4a023          	sw	a5,544(s1)
  p->queue=0;
    80001d38:	2204a223          	sw	zero,548(s1)
  p->tickstaken=0;
    80001d3c:	2204a423          	sw	zero,552(s1)
  for(int i=0;i<32;i++)
    80001d40:	16848793          	addi	a5,s1,360
    80001d44:	1e848713          	addi	a4,s1,488
    p->syscall_counts[i]=0;
    80001d48:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<32;i++)
    80001d4c:	0791                	addi	a5,a5,4
    80001d4e:	fee79de3          	bne	a5,a4,80001d48 <allocproc+0xd6>
}
    80001d52:	8526                	mv	a0,s1
    80001d54:	60e2                	ld	ra,24(sp)
    80001d56:	6442                	ld	s0,16(sp)
    80001d58:	64a2                	ld	s1,8(sp)
    80001d5a:	6902                	ld	s2,0(sp)
    80001d5c:	6105                	addi	sp,sp,32
    80001d5e:	8082                	ret
    freeproc(p);
    80001d60:	8526                	mv	a0,s1
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	eb8080e7          	jalr	-328(ra) # 80001c1a <freeproc>
    release(&p->lock);
    80001d6a:	8526                	mv	a0,s1
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	f82080e7          	jalr	-126(ra) # 80000cee <release>
    return 0;
    80001d74:	84ca                	mv	s1,s2
    80001d76:	bff1                	j	80001d52 <allocproc+0xe0>
    freeproc(p);
    80001d78:	8526                	mv	a0,s1
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	ea0080e7          	jalr	-352(ra) # 80001c1a <freeproc>
    release(&p->lock);
    80001d82:	8526                	mv	a0,s1
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	f6a080e7          	jalr	-150(ra) # 80000cee <release>
    return 0;
    80001d8c:	84ca                	mv	s1,s2
    80001d8e:	b7d1                	j	80001d52 <allocproc+0xe0>

0000000080001d90 <userinit>:
{
    80001d90:	1101                	addi	sp,sp,-32
    80001d92:	ec06                	sd	ra,24(sp)
    80001d94:	e822                	sd	s0,16(sp)
    80001d96:	e426                	sd	s1,8(sp)
    80001d98:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	ed8080e7          	jalr	-296(ra) # 80001c72 <allocproc>
    80001da2:	84aa                	mv	s1,a0
  initproc = p;
    80001da4:	00007797          	auipc	a5,0x7
    80001da8:	b4a7b223          	sd	a0,-1212(a5) # 800088e8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001dac:	03400613          	li	a2,52
    80001db0:	00007597          	auipc	a1,0x7
    80001db4:	ad058593          	addi	a1,a1,-1328 # 80008880 <initcode>
    80001db8:	6928                	ld	a0,80(a0)
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	628080e7          	jalr	1576(ra) # 800013e2 <uvmfirst>
  p->sz = PGSIZE;
    80001dc2:	6785                	lui	a5,0x1
    80001dc4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001dc6:	6cb8                	ld	a4,88(s1)
    80001dc8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001dcc:	6cb8                	ld	a4,88(s1)
    80001dce:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001dd0:	4641                	li	a2,16
    80001dd2:	00006597          	auipc	a1,0x6
    80001dd6:	40e58593          	addi	a1,a1,1038 # 800081e0 <etext+0x1e0>
    80001dda:	15848513          	addi	a0,s1,344
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	0ae080e7          	jalr	174(ra) # 80000e8c <safestrcpy>
  p->cwd = namei("/");
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	40a50513          	addi	a0,a0,1034 # 800081f0 <etext+0x1f0>
    80001dee:	00002097          	auipc	ra,0x2
    80001df2:	684080e7          	jalr	1668(ra) # 80004472 <namei>
    80001df6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001dfa:	478d                	li	a5,3
    80001dfc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dfe:	8526                	mv	a0,s1
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	eee080e7          	jalr	-274(ra) # 80000cee <release>
}
    80001e08:	60e2                	ld	ra,24(sp)
    80001e0a:	6442                	ld	s0,16(sp)
    80001e0c:	64a2                	ld	s1,8(sp)
    80001e0e:	6105                	addi	sp,sp,32
    80001e10:	8082                	ret

0000000080001e12 <growproc>:
{
    80001e12:	1101                	addi	sp,sp,-32
    80001e14:	ec06                	sd	ra,24(sp)
    80001e16:	e822                	sd	s0,16(sp)
    80001e18:	e426                	sd	s1,8(sp)
    80001e1a:	e04a                	sd	s2,0(sp)
    80001e1c:	1000                	addi	s0,sp,32
    80001e1e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	c48080e7          	jalr	-952(ra) # 80001a68 <myproc>
    80001e28:	84aa                	mv	s1,a0
  sz = p->sz;
    80001e2a:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001e2c:	01204c63          	bgtz	s2,80001e44 <growproc+0x32>
  else if (n < 0)
    80001e30:	02094663          	bltz	s2,80001e5c <growproc+0x4a>
  p->sz = sz;
    80001e34:	e4ac                	sd	a1,72(s1)
  return 0;
    80001e36:	4501                	li	a0,0
}
    80001e38:	60e2                	ld	ra,24(sp)
    80001e3a:	6442                	ld	s0,16(sp)
    80001e3c:	64a2                	ld	s1,8(sp)
    80001e3e:	6902                	ld	s2,0(sp)
    80001e40:	6105                	addi	sp,sp,32
    80001e42:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001e44:	4691                	li	a3,4
    80001e46:	00b90633          	add	a2,s2,a1
    80001e4a:	6928                	ld	a0,80(a0)
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	650080e7          	jalr	1616(ra) # 8000149c <uvmalloc>
    80001e54:	85aa                	mv	a1,a0
    80001e56:	fd79                	bnez	a0,80001e34 <growproc+0x22>
      return -1;
    80001e58:	557d                	li	a0,-1
    80001e5a:	bff9                	j	80001e38 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e5c:	00b90633          	add	a2,s2,a1
    80001e60:	6928                	ld	a0,80(a0)
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	5f2080e7          	jalr	1522(ra) # 80001454 <uvmdealloc>
    80001e6a:	85aa                	mv	a1,a0
    80001e6c:	b7e1                	j	80001e34 <growproc+0x22>

0000000080001e6e <fork>:
{
    80001e6e:	7139                	addi	sp,sp,-64
    80001e70:	fc06                	sd	ra,56(sp)
    80001e72:	f822                	sd	s0,48(sp)
    80001e74:	f04a                	sd	s2,32(sp)
    80001e76:	e456                	sd	s5,8(sp)
    80001e78:	0080                	addi	s0,sp,64
  sudotime++;
    80001e7a:	00007717          	auipc	a4,0x7
    80001e7e:	a7670713          	addi	a4,a4,-1418 # 800088f0 <sudotime>
    80001e82:	431c                	lw	a5,0(a4)
    80001e84:	2785                	addiw	a5,a5,1 # 1001 <_entry-0x7fffefff>
    80001e86:	c31c                	sw	a5,0(a4)
  struct proc *p = myproc();
    80001e88:	00000097          	auipc	ra,0x0
    80001e8c:	be0080e7          	jalr	-1056(ra) # 80001a68 <myproc>
    80001e90:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	de0080e7          	jalr	-544(ra) # 80001c72 <allocproc>
    80001e9a:	12050a63          	beqz	a0,80001fce <fork+0x160>
    80001e9e:	ec4e                	sd	s3,24(sp)
    80001ea0:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001ea2:	048ab603          	ld	a2,72(s5)
    80001ea6:	692c                	ld	a1,80(a0)
    80001ea8:	050ab503          	ld	a0,80(s5)
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	75c080e7          	jalr	1884(ra) # 80001608 <uvmcopy>
    80001eb4:	04054a63          	bltz	a0,80001f08 <fork+0x9a>
    80001eb8:	f426                	sd	s1,40(sp)
    80001eba:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001ebc:	048ab783          	ld	a5,72(s5)
    80001ec0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001ec4:	058ab683          	ld	a3,88(s5)
    80001ec8:	87b6                	mv	a5,a3
    80001eca:	0589b703          	ld	a4,88(s3)
    80001ece:	12068693          	addi	a3,a3,288
    80001ed2:	0007b803          	ld	a6,0(a5)
    80001ed6:	6788                	ld	a0,8(a5)
    80001ed8:	6b8c                	ld	a1,16(a5)
    80001eda:	6f90                	ld	a2,24(a5)
    80001edc:	01073023          	sd	a6,0(a4)
    80001ee0:	e708                	sd	a0,8(a4)
    80001ee2:	eb0c                	sd	a1,16(a4)
    80001ee4:	ef10                	sd	a2,24(a4)
    80001ee6:	02078793          	addi	a5,a5,32
    80001eea:	02070713          	addi	a4,a4,32
    80001eee:	fed792e3          	bne	a5,a3,80001ed2 <fork+0x64>
  np->trapframe->a0 = 0;
    80001ef2:	0589b783          	ld	a5,88(s3)
    80001ef6:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001efa:	0d0a8493          	addi	s1,s5,208
    80001efe:	0d098913          	addi	s2,s3,208
    80001f02:	150a8a13          	addi	s4,s5,336
    80001f06:	a015                	j	80001f2a <fork+0xbc>
    freeproc(np);
    80001f08:	854e                	mv	a0,s3
    80001f0a:	00000097          	auipc	ra,0x0
    80001f0e:	d10080e7          	jalr	-752(ra) # 80001c1a <freeproc>
    release(&np->lock);
    80001f12:	854e                	mv	a0,s3
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	dda080e7          	jalr	-550(ra) # 80000cee <release>
    return -1;
    80001f1c:	597d                	li	s2,-1
    80001f1e:	69e2                	ld	s3,24(sp)
    80001f20:	a045                	j	80001fc0 <fork+0x152>
  for (i = 0; i < NOFILE; i++)
    80001f22:	04a1                	addi	s1,s1,8
    80001f24:	0921                	addi	s2,s2,8
    80001f26:	01448b63          	beq	s1,s4,80001f3c <fork+0xce>
    if (p->ofile[i])
    80001f2a:	6088                	ld	a0,0(s1)
    80001f2c:	d97d                	beqz	a0,80001f22 <fork+0xb4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f2e:	00003097          	auipc	ra,0x3
    80001f32:	bc8080e7          	jalr	-1080(ra) # 80004af6 <filedup>
    80001f36:	00a93023          	sd	a0,0(s2)
    80001f3a:	b7e5                	j	80001f22 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001f3c:	150ab503          	ld	a0,336(s5)
    80001f40:	00002097          	auipc	ra,0x2
    80001f44:	d10080e7          	jalr	-752(ra) # 80003c50 <idup>
    80001f48:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f4c:	4641                	li	a2,16
    80001f4e:	158a8593          	addi	a1,s5,344
    80001f52:	15898513          	addi	a0,s3,344
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	f36080e7          	jalr	-202(ra) # 80000e8c <safestrcpy>
  pid = np->pid;
    80001f5e:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001f62:	854e                	mv	a0,s3
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	d8a080e7          	jalr	-630(ra) # 80000cee <release>
  acquire(&wait_lock);
    80001f6c:	0000f497          	auipc	s1,0xf
    80001f70:	c0c48493          	addi	s1,s1,-1012 # 80010b78 <wait_lock>
    80001f74:	8526                	mv	a0,s1
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	cc8080e7          	jalr	-824(ra) # 80000c3e <acquire>
  np->parent = p;
    80001f7e:	0359bc23          	sd	s5,56(s3)
  np->tickets=p->tickets;
    80001f82:	21caa783          	lw	a5,540(s5)
    80001f86:	20f9ae23          	sw	a5,540(s3)
  release(&wait_lock);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	d62080e7          	jalr	-670(ra) # 80000cee <release>
  acquire(&np->lock);
    80001f94:	854e                	mv	a0,s3
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	ca8080e7          	jalr	-856(ra) # 80000c3e <acquire>
  np->state = RUNNABLE;
    80001f9e:	478d                	li	a5,3
    80001fa0:	00f9ac23          	sw	a5,24(s3)
  np->entrytime=sudotime;
    80001fa4:	00007797          	auipc	a5,0x7
    80001fa8:	94c7a783          	lw	a5,-1716(a5) # 800088f0 <sudotime>
    80001fac:	22f9a023          	sw	a5,544(s3)
  release(&np->lock);
    80001fb0:	854e                	mv	a0,s3
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	d3c080e7          	jalr	-708(ra) # 80000cee <release>
  return pid;
    80001fba:	74a2                	ld	s1,40(sp)
    80001fbc:	69e2                	ld	s3,24(sp)
    80001fbe:	6a42                	ld	s4,16(sp)
}
    80001fc0:	854a                	mv	a0,s2
    80001fc2:	70e2                	ld	ra,56(sp)
    80001fc4:	7442                	ld	s0,48(sp)
    80001fc6:	7902                	ld	s2,32(sp)
    80001fc8:	6aa2                	ld	s5,8(sp)
    80001fca:	6121                	addi	sp,sp,64
    80001fcc:	8082                	ret
    return -1;
    80001fce:	597d                	li	s2,-1
    80001fd0:	bfc5                	j	80001fc0 <fork+0x152>

0000000080001fd2 <random_number>:
int random_number(int a, int b) {
    80001fd2:	1141                	addi	sp,sp,-16
    80001fd4:	e406                	sd	ra,8(sp)
    80001fd6:	e022                	sd	s0,0(sp)
    80001fd8:	0800                	addi	s0,sp,16
    seed = (seed * 16807) % 2147483641;  // Changed multiplier and modulus
    80001fda:	00007617          	auipc	a2,0x7
    80001fde:	88e60613          	addi	a2,a2,-1906 # 80008868 <seed>
    80001fe2:	621c                	ld	a5,0(a2)
    80001fe4:	6811                	lui	a6,0x4
    80001fe6:	1a780813          	addi	a6,a6,423 # 41a7 <_entry-0x7fffbe59>
    80001fea:	030787b3          	mul	a5,a5,a6
    80001fee:	471d                	li	a4,7
    80001ff0:	1706                	slli	a4,a4,0x21
    80001ff2:	0c570713          	addi	a4,a4,197
    80001ff6:	02e7b6b3          	mulhu	a3,a5,a4
    80001ffa:	40d788b3          	sub	a7,a5,a3
    80001ffe:	0018d893          	srli	a7,a7,0x1
    80002002:	96c6                	add	a3,a3,a7
    80002004:	82f9                	srli	a3,a3,0x1e
    80002006:	01c69893          	slli	a7,a3,0x1c
    8000200a:	40d888b3          	sub	a7,a7,a3
    8000200e:	088e                	slli	a7,a7,0x3
    80002010:	96c6                	add	a3,a3,a7
    80002012:	8f95                	sub	a5,a5,a3
    80002014:	030787b3          	mul	a5,a5,a6
    80002018:	02e7b6b3          	mulhu	a3,a5,a4
    8000201c:	40d788b3          	sub	a7,a5,a3
    80002020:	0018d893          	srli	a7,a7,0x1
    80002024:	96c6                	add	a3,a3,a7
    80002026:	82f9                	srli	a3,a3,0x1e
    80002028:	01c69893          	slli	a7,a3,0x1c
    8000202c:	40d888b3          	sub	a7,a7,a3
    80002030:	088e                	slli	a7,a7,0x3
    80002032:	96c6                	add	a3,a3,a7
    80002034:	8f95                	sub	a5,a5,a3
    80002036:	030787b3          	mul	a5,a5,a6
    8000203a:	02e7b6b3          	mulhu	a3,a5,a4
    8000203e:	40d788b3          	sub	a7,a5,a3
    80002042:	0018d893          	srli	a7,a7,0x1
    80002046:	96c6                	add	a3,a3,a7
    80002048:	82f9                	srli	a3,a3,0x1e
    8000204a:	01c69893          	slli	a7,a3,0x1c
    8000204e:	40d888b3          	sub	a7,a7,a3
    80002052:	088e                	slli	a7,a7,0x3
    80002054:	96c6                	add	a3,a3,a7
    80002056:	8f95                	sub	a5,a5,a3
    80002058:	030787b3          	mul	a5,a5,a6
    8000205c:	02e7b6b3          	mulhu	a3,a5,a4
    80002060:	40d788b3          	sub	a7,a5,a3
    80002064:	0018d893          	srli	a7,a7,0x1
    80002068:	96c6                	add	a3,a3,a7
    8000206a:	82f9                	srli	a3,a3,0x1e
    8000206c:	01c69893          	slli	a7,a3,0x1c
    80002070:	40d888b3          	sub	a7,a7,a3
    80002074:	088e                	slli	a7,a7,0x3
    80002076:	96c6                	add	a3,a3,a7
    80002078:	8f95                	sub	a5,a5,a3
    8000207a:	030787b3          	mul	a5,a5,a6
    8000207e:	02e7b733          	mulhu	a4,a5,a4
    80002082:	40e786b3          	sub	a3,a5,a4
    80002086:	8285                	srli	a3,a3,0x1
    80002088:	9736                	add	a4,a4,a3
    8000208a:	8379                	srli	a4,a4,0x1e
    8000208c:	01c71693          	slli	a3,a4,0x1c
    80002090:	8e99                	sub	a3,a3,a4
    80002092:	068e                	slli	a3,a3,0x3
    80002094:	9736                	add	a4,a4,a3
    80002096:	40e78733          	sub	a4,a5,a4
  for (int i = 0; i < 5; i++) {
    8000209a:	e218                	sd	a4,0(a2)
  return a + now % (b - a + 1);
    8000209c:	9d89                	subw	a1,a1,a0
    8000209e:	2585                	addiw	a1,a1,1
    800020a0:	02b7673b          	remw	a4,a4,a1
}
    800020a4:	9d39                	addw	a0,a0,a4
    800020a6:	60a2                	ld	ra,8(sp)
    800020a8:	6402                	ld	s0,0(sp)
    800020aa:	0141                	addi	sp,sp,16
    800020ac:	8082                	ret

00000000800020ae <scheduler>:
{
    800020ae:	7139                	addi	sp,sp,-64
    800020b0:	fc06                	sd	ra,56(sp)
    800020b2:	f822                	sd	s0,48(sp)
    800020b4:	f426                	sd	s1,40(sp)
    800020b6:	f04a                	sd	s2,32(sp)
    800020b8:	ec4e                	sd	s3,24(sp)
    800020ba:	e852                	sd	s4,16(sp)
    800020bc:	e456                	sd	s5,8(sp)
    800020be:	e05a                	sd	s6,0(sp)
    800020c0:	0080                	addi	s0,sp,64
    800020c2:	8792                	mv	a5,tp
  int id = r_tp();
    800020c4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800020c6:	00779a93          	slli	s5,a5,0x7
    800020ca:	0000f717          	auipc	a4,0xf
    800020ce:	a9670713          	addi	a4,a4,-1386 # 80010b60 <pid_lock>
    800020d2:	9756                	add	a4,a4,s5
    800020d4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800020d8:	0000f717          	auipc	a4,0xf
    800020dc:	ac070713          	addi	a4,a4,-1344 # 80010b98 <cpus+0x8>
    800020e0:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800020e2:	498d                	li	s3,3
        p->state = RUNNING;
    800020e4:	4b11                	li	s6,4
        c->proc = p;
    800020e6:	079e                	slli	a5,a5,0x7
    800020e8:	0000fa17          	auipc	s4,0xf
    800020ec:	a78a0a13          	addi	s4,s4,-1416 # 80010b60 <pid_lock>
    800020f0:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020fa:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800020fe:	0000f497          	auipc	s1,0xf
    80002102:	e9248493          	addi	s1,s1,-366 # 80010f90 <proc>
    80002106:	00018917          	auipc	s2,0x18
    8000210a:	a8a90913          	addi	s2,s2,-1398 # 80019b90 <tickslock>
    8000210e:	a811                	j	80002122 <scheduler+0x74>
      release(&p->lock);
    80002110:	8526                	mv	a0,s1
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	bdc080e7          	jalr	-1060(ra) # 80000cee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000211a:	23048493          	addi	s1,s1,560
    8000211e:	fd248ae3          	beq	s1,s2,800020f2 <scheduler+0x44>
      acquire(&p->lock);
    80002122:	8526                	mv	a0,s1
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	b1a080e7          	jalr	-1254(ra) # 80000c3e <acquire>
      if (p->state == RUNNABLE)
    8000212c:	4c9c                	lw	a5,24(s1)
    8000212e:	ff3791e3          	bne	a5,s3,80002110 <scheduler+0x62>
        p->state = RUNNING;
    80002132:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002136:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000213a:	06048593          	addi	a1,s1,96
    8000213e:	8556                	mv	a0,s5
    80002140:	00001097          	auipc	ra,0x1
    80002144:	860080e7          	jalr	-1952(ra) # 800029a0 <swtch>
        c->proc = 0;
    80002148:	020a3823          	sd	zero,48(s4)
    8000214c:	b7d1                	j	80002110 <scheduler+0x62>

000000008000214e <sched>:
{
    8000214e:	7179                	addi	sp,sp,-48
    80002150:	f406                	sd	ra,40(sp)
    80002152:	f022                	sd	s0,32(sp)
    80002154:	ec26                	sd	s1,24(sp)
    80002156:	e84a                	sd	s2,16(sp)
    80002158:	e44e                	sd	s3,8(sp)
    8000215a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	90c080e7          	jalr	-1780(ra) # 80001a68 <myproc>
    80002164:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	a5e080e7          	jalr	-1442(ra) # 80000bc4 <holding>
    8000216e:	c93d                	beqz	a0,800021e4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002170:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002172:	2781                	sext.w	a5,a5
    80002174:	079e                	slli	a5,a5,0x7
    80002176:	0000f717          	auipc	a4,0xf
    8000217a:	9ea70713          	addi	a4,a4,-1558 # 80010b60 <pid_lock>
    8000217e:	97ba                	add	a5,a5,a4
    80002180:	0a87a703          	lw	a4,168(a5)
    80002184:	4785                	li	a5,1
    80002186:	06f71763          	bne	a4,a5,800021f4 <sched+0xa6>
  if (p->state == RUNNING)
    8000218a:	4c98                	lw	a4,24(s1)
    8000218c:	4791                	li	a5,4
    8000218e:	06f70b63          	beq	a4,a5,80002204 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002192:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002196:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002198:	efb5                	bnez	a5,80002214 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000219a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000219c:	0000f917          	auipc	s2,0xf
    800021a0:	9c490913          	addi	s2,s2,-1596 # 80010b60 <pid_lock>
    800021a4:	2781                	sext.w	a5,a5
    800021a6:	079e                	slli	a5,a5,0x7
    800021a8:	97ca                	add	a5,a5,s2
    800021aa:	0ac7a983          	lw	s3,172(a5)
    800021ae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800021b0:	2781                	sext.w	a5,a5
    800021b2:	079e                	slli	a5,a5,0x7
    800021b4:	0000f597          	auipc	a1,0xf
    800021b8:	9e458593          	addi	a1,a1,-1564 # 80010b98 <cpus+0x8>
    800021bc:	95be                	add	a1,a1,a5
    800021be:	06048513          	addi	a0,s1,96
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	7de080e7          	jalr	2014(ra) # 800029a0 <swtch>
    800021ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800021cc:	2781                	sext.w	a5,a5
    800021ce:	079e                	slli	a5,a5,0x7
    800021d0:	993e                	add	s2,s2,a5
    800021d2:	0b392623          	sw	s3,172(s2)
}
    800021d6:	70a2                	ld	ra,40(sp)
    800021d8:	7402                	ld	s0,32(sp)
    800021da:	64e2                	ld	s1,24(sp)
    800021dc:	6942                	ld	s2,16(sp)
    800021de:	69a2                	ld	s3,8(sp)
    800021e0:	6145                	addi	sp,sp,48
    800021e2:	8082                	ret
    panic("sched p->lock");
    800021e4:	00006517          	auipc	a0,0x6
    800021e8:	01450513          	addi	a0,a0,20 # 800081f8 <etext+0x1f8>
    800021ec:	ffffe097          	auipc	ra,0xffffe
    800021f0:	374080e7          	jalr	884(ra) # 80000560 <panic>
    panic("sched locks");
    800021f4:	00006517          	auipc	a0,0x6
    800021f8:	01450513          	addi	a0,a0,20 # 80008208 <etext+0x208>
    800021fc:	ffffe097          	auipc	ra,0xffffe
    80002200:	364080e7          	jalr	868(ra) # 80000560 <panic>
    panic("sched running");
    80002204:	00006517          	auipc	a0,0x6
    80002208:	01450513          	addi	a0,a0,20 # 80008218 <etext+0x218>
    8000220c:	ffffe097          	auipc	ra,0xffffe
    80002210:	354080e7          	jalr	852(ra) # 80000560 <panic>
    panic("sched interruptible");
    80002214:	00006517          	auipc	a0,0x6
    80002218:	01450513          	addi	a0,a0,20 # 80008228 <etext+0x228>
    8000221c:	ffffe097          	auipc	ra,0xffffe
    80002220:	344080e7          	jalr	836(ra) # 80000560 <panic>

0000000080002224 <yield>:
{
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	e426                	sd	s1,8(sp)
    8000222c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000222e:	00000097          	auipc	ra,0x0
    80002232:	83a080e7          	jalr	-1990(ra) # 80001a68 <myproc>
    80002236:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	a06080e7          	jalr	-1530(ra) # 80000c3e <acquire>
  p->state = RUNNABLE;
    80002240:	478d                	li	a5,3
    80002242:	cc9c                	sw	a5,24(s1)
  sched();
    80002244:	00000097          	auipc	ra,0x0
    80002248:	f0a080e7          	jalr	-246(ra) # 8000214e <sched>
  release(&p->lock);
    8000224c:	8526                	mv	a0,s1
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	aa0080e7          	jalr	-1376(ra) # 80000cee <release>
}
    80002256:	60e2                	ld	ra,24(sp)
    80002258:	6442                	ld	s0,16(sp)
    8000225a:	64a2                	ld	s1,8(sp)
    8000225c:	6105                	addi	sp,sp,32
    8000225e:	8082                	ret

0000000080002260 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002260:	7179                	addi	sp,sp,-48
    80002262:	f406                	sd	ra,40(sp)
    80002264:	f022                	sd	s0,32(sp)
    80002266:	ec26                	sd	s1,24(sp)
    80002268:	e84a                	sd	s2,16(sp)
    8000226a:	e44e                	sd	s3,8(sp)
    8000226c:	1800                	addi	s0,sp,48
    8000226e:	89aa                	mv	s3,a0
    80002270:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	7f6080e7          	jalr	2038(ra) # 80001a68 <myproc>
    8000227a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	9c2080e7          	jalr	-1598(ra) # 80000c3e <acquire>
  release(lk);
    80002284:	854a                	mv	a0,s2
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	a68080e7          	jalr	-1432(ra) # 80000cee <release>

  // Go to sleep.
  p->chan = chan;
    8000228e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002292:	4789                	li	a5,2
    80002294:	cc9c                	sw	a5,24(s1)

  sched();
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	eb8080e7          	jalr	-328(ra) # 8000214e <sched>

  // Tidy up.
  p->chan = 0;
    8000229e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800022a2:	8526                	mv	a0,s1
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	a4a080e7          	jalr	-1462(ra) # 80000cee <release>
  acquire(lk);
    800022ac:	854a                	mv	a0,s2
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	990080e7          	jalr	-1648(ra) # 80000c3e <acquire>
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6145                	addi	sp,sp,48
    800022c2:	8082                	ret

00000000800022c4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800022c4:	7139                	addi	sp,sp,-64
    800022c6:	fc06                	sd	ra,56(sp)
    800022c8:	f822                	sd	s0,48(sp)
    800022ca:	f426                	sd	s1,40(sp)
    800022cc:	f04a                	sd	s2,32(sp)
    800022ce:	ec4e                	sd	s3,24(sp)
    800022d0:	e852                	sd	s4,16(sp)
    800022d2:	e456                	sd	s5,8(sp)
    800022d4:	0080                	addi	s0,sp,64
    800022d6:	8a2a                	mv	s4,a0
  struct proc *p;
  sudotime++;
    800022d8:	00006717          	auipc	a4,0x6
    800022dc:	61870713          	addi	a4,a4,1560 # 800088f0 <sudotime>
    800022e0:	431c                	lw	a5,0(a4)
    800022e2:	2785                	addiw	a5,a5,1
    800022e4:	c31c                	sw	a5,0(a4)

  for (p = proc; p < &proc[NPROC]; p++)
    800022e6:	0000f497          	auipc	s1,0xf
    800022ea:	caa48493          	addi	s1,s1,-854 # 80010f90 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800022ee:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800022f0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800022f2:	00018917          	auipc	s2,0x18
    800022f6:	89e90913          	addi	s2,s2,-1890 # 80019b90 <tickslock>
    800022fa:	a811                	j	8000230e <wakeup+0x4a>
        #ifdef  SCHED_MLFQ
        p->entrytime=sudotime;
        #endif
      }
      release(&p->lock);
    800022fc:	8526                	mv	a0,s1
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	9f0080e7          	jalr	-1552(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002306:	23048493          	addi	s1,s1,560
    8000230a:	03248663          	beq	s1,s2,80002336 <wakeup+0x72>
    if (p != myproc())
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	75a080e7          	jalr	1882(ra) # 80001a68 <myproc>
    80002316:	fea488e3          	beq	s1,a0,80002306 <wakeup+0x42>
      acquire(&p->lock);
    8000231a:	8526                	mv	a0,s1
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	922080e7          	jalr	-1758(ra) # 80000c3e <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80002324:	4c9c                	lw	a5,24(s1)
    80002326:	fd379be3          	bne	a5,s3,800022fc <wakeup+0x38>
    8000232a:	709c                	ld	a5,32(s1)
    8000232c:	fd4798e3          	bne	a5,s4,800022fc <wakeup+0x38>
        p->state = RUNNABLE;
    80002330:	0154ac23          	sw	s5,24(s1)
    80002334:	b7e1                	j	800022fc <wakeup+0x38>
    }
  }
}
    80002336:	70e2                	ld	ra,56(sp)
    80002338:	7442                	ld	s0,48(sp)
    8000233a:	74a2                	ld	s1,40(sp)
    8000233c:	7902                	ld	s2,32(sp)
    8000233e:	69e2                	ld	s3,24(sp)
    80002340:	6a42                	ld	s4,16(sp)
    80002342:	6aa2                	ld	s5,8(sp)
    80002344:	6121                	addi	sp,sp,64
    80002346:	8082                	ret

0000000080002348 <reparent>:
{
    80002348:	7179                	addi	sp,sp,-48
    8000234a:	f406                	sd	ra,40(sp)
    8000234c:	f022                	sd	s0,32(sp)
    8000234e:	ec26                	sd	s1,24(sp)
    80002350:	e84a                	sd	s2,16(sp)
    80002352:	e44e                	sd	s3,8(sp)
    80002354:	e052                	sd	s4,0(sp)
    80002356:	1800                	addi	s0,sp,48
    80002358:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000235a:	0000f497          	auipc	s1,0xf
    8000235e:	c3648493          	addi	s1,s1,-970 # 80010f90 <proc>
      pp->parent = initproc;
    80002362:	00006a17          	auipc	s4,0x6
    80002366:	586a0a13          	addi	s4,s4,1414 # 800088e8 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000236a:	00018997          	auipc	s3,0x18
    8000236e:	82698993          	addi	s3,s3,-2010 # 80019b90 <tickslock>
    80002372:	a029                	j	8000237c <reparent+0x34>
    80002374:	23048493          	addi	s1,s1,560
    80002378:	01348d63          	beq	s1,s3,80002392 <reparent+0x4a>
    if (pp->parent == p)
    8000237c:	7c9c                	ld	a5,56(s1)
    8000237e:	ff279be3          	bne	a5,s2,80002374 <reparent+0x2c>
      pp->parent = initproc;
    80002382:	000a3503          	ld	a0,0(s4)
    80002386:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002388:	00000097          	auipc	ra,0x0
    8000238c:	f3c080e7          	jalr	-196(ra) # 800022c4 <wakeup>
    80002390:	b7d5                	j	80002374 <reparent+0x2c>
}
    80002392:	70a2                	ld	ra,40(sp)
    80002394:	7402                	ld	s0,32(sp)
    80002396:	64e2                	ld	s1,24(sp)
    80002398:	6942                	ld	s2,16(sp)
    8000239a:	69a2                	ld	s3,8(sp)
    8000239c:	6a02                	ld	s4,0(sp)
    8000239e:	6145                	addi	sp,sp,48
    800023a0:	8082                	ret

00000000800023a2 <exit>:
{
    800023a2:	7179                	addi	sp,sp,-48
    800023a4:	f406                	sd	ra,40(sp)
    800023a6:	f022                	sd	s0,32(sp)
    800023a8:	ec26                	sd	s1,24(sp)
    800023aa:	e84a                	sd	s2,16(sp)
    800023ac:	e44e                	sd	s3,8(sp)
    800023ae:	e052                	sd	s4,0(sp)
    800023b0:	1800                	addi	s0,sp,48
    800023b2:	89aa                	mv	s3,a0
  struct proc *p = myproc();
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	6b4080e7          	jalr	1716(ra) # 80001a68 <myproc>
    800023bc:	892a                	mv	s2,a0
  struct proc *parent = p->parent;
    800023be:	7d0c                	ld	a1,56(a0)
  if (parent) {
    800023c0:	cd99                	beqz	a1,800023de <exit+0x3c>
    800023c2:	16858793          	addi	a5,a1,360
    800023c6:	16850693          	addi	a3,a0,360
    800023ca:	1e858593          	addi	a1,a1,488
            parent->syscall_counts[i] += p->syscall_counts[i];
    800023ce:	4390                	lw	a2,0(a5)
    800023d0:	4298                	lw	a4,0(a3)
    800023d2:	9f31                	addw	a4,a4,a2
    800023d4:	c398                	sw	a4,0(a5)
      for (int i = 0; i < 32; i++) {  // Assuming a maximum of 32 syscalls
    800023d6:	0791                	addi	a5,a5,4
    800023d8:	0691                	addi	a3,a3,4
    800023da:	feb79ae3          	bne	a5,a1,800023ce <exit+0x2c>
  if (p == initproc)
    800023de:	00006797          	auipc	a5,0x6
    800023e2:	50a7b783          	ld	a5,1290(a5) # 800088e8 <initproc>
    800023e6:	0d090493          	addi	s1,s2,208
    800023ea:	15090a13          	addi	s4,s2,336
    800023ee:	01279d63          	bne	a5,s2,80002408 <exit+0x66>
    panic("init exiting");
    800023f2:	00006517          	auipc	a0,0x6
    800023f6:	e4e50513          	addi	a0,a0,-434 # 80008240 <etext+0x240>
    800023fa:	ffffe097          	auipc	ra,0xffffe
    800023fe:	166080e7          	jalr	358(ra) # 80000560 <panic>
  for (int fd = 0; fd < NOFILE; fd++)
    80002402:	04a1                	addi	s1,s1,8
    80002404:	01448b63          	beq	s1,s4,8000241a <exit+0x78>
    if (p->ofile[fd])
    80002408:	6088                	ld	a0,0(s1)
    8000240a:	dd65                	beqz	a0,80002402 <exit+0x60>
      fileclose(f);
    8000240c:	00002097          	auipc	ra,0x2
    80002410:	73c080e7          	jalr	1852(ra) # 80004b48 <fileclose>
      p->ofile[fd] = 0;
    80002414:	0004b023          	sd	zero,0(s1)
    80002418:	b7ed                	j	80002402 <exit+0x60>
  begin_op();
    8000241a:	00002097          	auipc	ra,0x2
    8000241e:	25e080e7          	jalr	606(ra) # 80004678 <begin_op>
  iput(p->cwd);
    80002422:	15093503          	ld	a0,336(s2)
    80002426:	00002097          	auipc	ra,0x2
    8000242a:	a26080e7          	jalr	-1498(ra) # 80003e4c <iput>
  end_op();
    8000242e:	00002097          	auipc	ra,0x2
    80002432:	2c4080e7          	jalr	708(ra) # 800046f2 <end_op>
  p->cwd = 0;
    80002436:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    8000243a:	0000e497          	auipc	s1,0xe
    8000243e:	73e48493          	addi	s1,s1,1854 # 80010b78 <wait_lock>
    80002442:	8526                	mv	a0,s1
    80002444:	ffffe097          	auipc	ra,0xffffe
    80002448:	7fa080e7          	jalr	2042(ra) # 80000c3e <acquire>
  reparent(p);
    8000244c:	854a                	mv	a0,s2
    8000244e:	00000097          	auipc	ra,0x0
    80002452:	efa080e7          	jalr	-262(ra) # 80002348 <reparent>
  wakeup(p->parent);
    80002456:	03893503          	ld	a0,56(s2)
    8000245a:	00000097          	auipc	ra,0x0
    8000245e:	e6a080e7          	jalr	-406(ra) # 800022c4 <wakeup>
  acquire(&p->lock);
    80002462:	854a                	mv	a0,s2
    80002464:	ffffe097          	auipc	ra,0xffffe
    80002468:	7da080e7          	jalr	2010(ra) # 80000c3e <acquire>
  p->xstate = status;
    8000246c:	03392623          	sw	s3,44(s2)
  p->state = ZOMBIE;
    80002470:	4795                	li	a5,5
    80002472:	00f92c23          	sw	a5,24(s2)
  p->etime = ticks;
    80002476:	00006797          	auipc	a5,0x6
    8000247a:	47e7a783          	lw	a5,1150(a5) # 800088f4 <ticks>
    8000247e:	1ef92823          	sw	a5,496(s2)
  release(&wait_lock);
    80002482:	8526                	mv	a0,s1
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	86a080e7          	jalr	-1942(ra) # 80000cee <release>
  sched();
    8000248c:	00000097          	auipc	ra,0x0
    80002490:	cc2080e7          	jalr	-830(ra) # 8000214e <sched>
  panic("zombie exit");
    80002494:	00006517          	auipc	a0,0x6
    80002498:	dbc50513          	addi	a0,a0,-580 # 80008250 <etext+0x250>
    8000249c:	ffffe097          	auipc	ra,0xffffe
    800024a0:	0c4080e7          	jalr	196(ra) # 80000560 <panic>

00000000800024a4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).

int kill(int pid)
{
    800024a4:	7179                	addi	sp,sp,-48
    800024a6:	f406                	sd	ra,40(sp)
    800024a8:	f022                	sd	s0,32(sp)
    800024aa:	ec26                	sd	s1,24(sp)
    800024ac:	e84a                	sd	s2,16(sp)
    800024ae:	e44e                	sd	s3,8(sp)
    800024b0:	1800                	addi	s0,sp,48
    800024b2:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800024b4:	0000f497          	auipc	s1,0xf
    800024b8:	adc48493          	addi	s1,s1,-1316 # 80010f90 <proc>
    800024bc:	00017997          	auipc	s3,0x17
    800024c0:	6d498993          	addi	s3,s3,1748 # 80019b90 <tickslock>
  {
    acquire(&p->lock);
    800024c4:	8526                	mv	a0,s1
    800024c6:	ffffe097          	auipc	ra,0xffffe
    800024ca:	778080e7          	jalr	1912(ra) # 80000c3e <acquire>
    if (p->pid == pid)
    800024ce:	589c                	lw	a5,48(s1)
    800024d0:	01278d63          	beq	a5,s2,800024ea <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	818080e7          	jalr	-2024(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800024de:	23048493          	addi	s1,s1,560
    800024e2:	ff3491e3          	bne	s1,s3,800024c4 <kill+0x20>
  }
  return -1;
    800024e6:	557d                	li	a0,-1
    800024e8:	a829                	j	80002502 <kill+0x5e>
      p->killed = 1;
    800024ea:	4785                	li	a5,1
    800024ec:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800024ee:	4c98                	lw	a4,24(s1)
    800024f0:	4789                	li	a5,2
    800024f2:	00f70f63          	beq	a4,a5,80002510 <kill+0x6c>
      release(&p->lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	7f6080e7          	jalr	2038(ra) # 80000cee <release>
      return 0;
    80002500:	4501                	li	a0,0
}
    80002502:	70a2                	ld	ra,40(sp)
    80002504:	7402                	ld	s0,32(sp)
    80002506:	64e2                	ld	s1,24(sp)
    80002508:	6942                	ld	s2,16(sp)
    8000250a:	69a2                	ld	s3,8(sp)
    8000250c:	6145                	addi	sp,sp,48
    8000250e:	8082                	ret
        p->state = RUNNABLE;
    80002510:	478d                	li	a5,3
    80002512:	cc9c                	sw	a5,24(s1)
    80002514:	b7cd                	j	800024f6 <kill+0x52>

0000000080002516 <setkilled>:

void setkilled(struct proc *p)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002522:	ffffe097          	auipc	ra,0xffffe
    80002526:	71c080e7          	jalr	1820(ra) # 80000c3e <acquire>
  p->killed = 1;
    8000252a:	4785                	li	a5,1
    8000252c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000252e:	8526                	mv	a0,s1
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	7be080e7          	jalr	1982(ra) # 80000cee <release>
}
    80002538:	60e2                	ld	ra,24(sp)
    8000253a:	6442                	ld	s0,16(sp)
    8000253c:	64a2                	ld	s1,8(sp)
    8000253e:	6105                	addi	sp,sp,32
    80002540:	8082                	ret

0000000080002542 <killed>:

int killed(struct proc *p)
{
    80002542:	1101                	addi	sp,sp,-32
    80002544:	ec06                	sd	ra,24(sp)
    80002546:	e822                	sd	s0,16(sp)
    80002548:	e426                	sd	s1,8(sp)
    8000254a:	e04a                	sd	s2,0(sp)
    8000254c:	1000                	addi	s0,sp,32
    8000254e:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	6ee080e7          	jalr	1774(ra) # 80000c3e <acquire>
  k = p->killed;
    80002558:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000255c:	8526                	mv	a0,s1
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	790080e7          	jalr	1936(ra) # 80000cee <release>
  return k;
}
    80002566:	854a                	mv	a0,s2
    80002568:	60e2                	ld	ra,24(sp)
    8000256a:	6442                	ld	s0,16(sp)
    8000256c:	64a2                	ld	s1,8(sp)
    8000256e:	6902                	ld	s2,0(sp)
    80002570:	6105                	addi	sp,sp,32
    80002572:	8082                	ret

0000000080002574 <wait>:
{
    80002574:	715d                	addi	sp,sp,-80
    80002576:	e486                	sd	ra,72(sp)
    80002578:	e0a2                	sd	s0,64(sp)
    8000257a:	fc26                	sd	s1,56(sp)
    8000257c:	f84a                	sd	s2,48(sp)
    8000257e:	f44e                	sd	s3,40(sp)
    80002580:	f052                	sd	s4,32(sp)
    80002582:	ec56                	sd	s5,24(sp)
    80002584:	e85a                	sd	s6,16(sp)
    80002586:	e45e                	sd	s7,8(sp)
    80002588:	0880                	addi	s0,sp,80
    8000258a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	4dc080e7          	jalr	1244(ra) # 80001a68 <myproc>
    80002594:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002596:	0000e517          	auipc	a0,0xe
    8000259a:	5e250513          	addi	a0,a0,1506 # 80010b78 <wait_lock>
    8000259e:	ffffe097          	auipc	ra,0xffffe
    800025a2:	6a0080e7          	jalr	1696(ra) # 80000c3e <acquire>
        if (pp->state == ZOMBIE)
    800025a6:	4a15                	li	s4,5
        havekids = 1;
    800025a8:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800025aa:	00017997          	auipc	s3,0x17
    800025ae:	5e698993          	addi	s3,s3,1510 # 80019b90 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800025b2:	0000eb97          	auipc	s7,0xe
    800025b6:	5c6b8b93          	addi	s7,s7,1478 # 80010b78 <wait_lock>
    800025ba:	a0c9                	j	8000267c <wait+0x108>
          pid = pp->pid;
    800025bc:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800025c0:	000b0e63          	beqz	s6,800025dc <wait+0x68>
    800025c4:	4691                	li	a3,4
    800025c6:	02c48613          	addi	a2,s1,44
    800025ca:	85da                	mv	a1,s6
    800025cc:	05093503          	ld	a0,80(s2)
    800025d0:	fffff097          	auipc	ra,0xfffff
    800025d4:	140080e7          	jalr	320(ra) # 80001710 <copyout>
    800025d8:	04054063          	bltz	a0,80002618 <wait+0xa4>
          freeproc(pp);
    800025dc:	8526                	mv	a0,s1
    800025de:	fffff097          	auipc	ra,0xfffff
    800025e2:	63c080e7          	jalr	1596(ra) # 80001c1a <freeproc>
          release(&pp->lock);
    800025e6:	8526                	mv	a0,s1
    800025e8:	ffffe097          	auipc	ra,0xffffe
    800025ec:	706080e7          	jalr	1798(ra) # 80000cee <release>
          release(&wait_lock);
    800025f0:	0000e517          	auipc	a0,0xe
    800025f4:	58850513          	addi	a0,a0,1416 # 80010b78 <wait_lock>
    800025f8:	ffffe097          	auipc	ra,0xffffe
    800025fc:	6f6080e7          	jalr	1782(ra) # 80000cee <release>
}
    80002600:	854e                	mv	a0,s3
    80002602:	60a6                	ld	ra,72(sp)
    80002604:	6406                	ld	s0,64(sp)
    80002606:	74e2                	ld	s1,56(sp)
    80002608:	7942                	ld	s2,48(sp)
    8000260a:	79a2                	ld	s3,40(sp)
    8000260c:	7a02                	ld	s4,32(sp)
    8000260e:	6ae2                	ld	s5,24(sp)
    80002610:	6b42                	ld	s6,16(sp)
    80002612:	6ba2                	ld	s7,8(sp)
    80002614:	6161                	addi	sp,sp,80
    80002616:	8082                	ret
            release(&pp->lock);
    80002618:	8526                	mv	a0,s1
    8000261a:	ffffe097          	auipc	ra,0xffffe
    8000261e:	6d4080e7          	jalr	1748(ra) # 80000cee <release>
            release(&wait_lock);
    80002622:	0000e517          	auipc	a0,0xe
    80002626:	55650513          	addi	a0,a0,1366 # 80010b78 <wait_lock>
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	6c4080e7          	jalr	1732(ra) # 80000cee <release>
            return -1;
    80002632:	59fd                	li	s3,-1
    80002634:	b7f1                	j	80002600 <wait+0x8c>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002636:	23048493          	addi	s1,s1,560
    8000263a:	03348463          	beq	s1,s3,80002662 <wait+0xee>
      if (pp->parent == p)
    8000263e:	7c9c                	ld	a5,56(s1)
    80002640:	ff279be3          	bne	a5,s2,80002636 <wait+0xc2>
        acquire(&pp->lock);
    80002644:	8526                	mv	a0,s1
    80002646:	ffffe097          	auipc	ra,0xffffe
    8000264a:	5f8080e7          	jalr	1528(ra) # 80000c3e <acquire>
        if (pp->state == ZOMBIE)
    8000264e:	4c9c                	lw	a5,24(s1)
    80002650:	f74786e3          	beq	a5,s4,800025bc <wait+0x48>
        release(&pp->lock);
    80002654:	8526                	mv	a0,s1
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	698080e7          	jalr	1688(ra) # 80000cee <release>
        havekids = 1;
    8000265e:	8756                	mv	a4,s5
    80002660:	bfd9                	j	80002636 <wait+0xc2>
    if (!havekids || killed(p))
    80002662:	c31d                	beqz	a4,80002688 <wait+0x114>
    80002664:	854a                	mv	a0,s2
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	edc080e7          	jalr	-292(ra) # 80002542 <killed>
    8000266e:	ed09                	bnez	a0,80002688 <wait+0x114>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002670:	85de                	mv	a1,s7
    80002672:	854a                	mv	a0,s2
    80002674:	00000097          	auipc	ra,0x0
    80002678:	bec080e7          	jalr	-1044(ra) # 80002260 <sleep>
    havekids = 0;
    8000267c:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000267e:	0000f497          	auipc	s1,0xf
    80002682:	91248493          	addi	s1,s1,-1774 # 80010f90 <proc>
    80002686:	bf65                	j	8000263e <wait+0xca>
      release(&wait_lock);
    80002688:	0000e517          	auipc	a0,0xe
    8000268c:	4f050513          	addi	a0,a0,1264 # 80010b78 <wait_lock>
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	65e080e7          	jalr	1630(ra) # 80000cee <release>
      return -1;
    80002698:	59fd                	li	s3,-1
    8000269a:	b79d                	j	80002600 <wait+0x8c>

000000008000269c <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000269c:	7179                	addi	sp,sp,-48
    8000269e:	f406                	sd	ra,40(sp)
    800026a0:	f022                	sd	s0,32(sp)
    800026a2:	ec26                	sd	s1,24(sp)
    800026a4:	e84a                	sd	s2,16(sp)
    800026a6:	e44e                	sd	s3,8(sp)
    800026a8:	e052                	sd	s4,0(sp)
    800026aa:	1800                	addi	s0,sp,48
    800026ac:	84aa                	mv	s1,a0
    800026ae:	892e                	mv	s2,a1
    800026b0:	89b2                	mv	s3,a2
    800026b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026b4:	fffff097          	auipc	ra,0xfffff
    800026b8:	3b4080e7          	jalr	948(ra) # 80001a68 <myproc>
  if (user_dst)
    800026bc:	c08d                	beqz	s1,800026de <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    800026be:	86d2                	mv	a3,s4
    800026c0:	864e                	mv	a2,s3
    800026c2:	85ca                	mv	a1,s2
    800026c4:	6928                	ld	a0,80(a0)
    800026c6:	fffff097          	auipc	ra,0xfffff
    800026ca:	04a080e7          	jalr	74(ra) # 80001710 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800026ce:	70a2                	ld	ra,40(sp)
    800026d0:	7402                	ld	s0,32(sp)
    800026d2:	64e2                	ld	s1,24(sp)
    800026d4:	6942                	ld	s2,16(sp)
    800026d6:	69a2                	ld	s3,8(sp)
    800026d8:	6a02                	ld	s4,0(sp)
    800026da:	6145                	addi	sp,sp,48
    800026dc:	8082                	ret
    memmove((char *)dst, src, len);
    800026de:	000a061b          	sext.w	a2,s4
    800026e2:	85ce                	mv	a1,s3
    800026e4:	854a                	mv	a0,s2
    800026e6:	ffffe097          	auipc	ra,0xffffe
    800026ea:	6b4080e7          	jalr	1716(ra) # 80000d9a <memmove>
    return 0;
    800026ee:	8526                	mv	a0,s1
    800026f0:	bff9                	j	800026ce <either_copyout+0x32>

00000000800026f2 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800026f2:	7179                	addi	sp,sp,-48
    800026f4:	f406                	sd	ra,40(sp)
    800026f6:	f022                	sd	s0,32(sp)
    800026f8:	ec26                	sd	s1,24(sp)
    800026fa:	e84a                	sd	s2,16(sp)
    800026fc:	e44e                	sd	s3,8(sp)
    800026fe:	e052                	sd	s4,0(sp)
    80002700:	1800                	addi	s0,sp,48
    80002702:	892a                	mv	s2,a0
    80002704:	84ae                	mv	s1,a1
    80002706:	89b2                	mv	s3,a2
    80002708:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000270a:	fffff097          	auipc	ra,0xfffff
    8000270e:	35e080e7          	jalr	862(ra) # 80001a68 <myproc>
  if (user_src)
    80002712:	c08d                	beqz	s1,80002734 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002714:	86d2                	mv	a3,s4
    80002716:	864e                	mv	a2,s3
    80002718:	85ca                	mv	a1,s2
    8000271a:	6928                	ld	a0,80(a0)
    8000271c:	fffff097          	auipc	ra,0xfffff
    80002720:	080080e7          	jalr	128(ra) # 8000179c <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002724:	70a2                	ld	ra,40(sp)
    80002726:	7402                	ld	s0,32(sp)
    80002728:	64e2                	ld	s1,24(sp)
    8000272a:	6942                	ld	s2,16(sp)
    8000272c:	69a2                	ld	s3,8(sp)
    8000272e:	6a02                	ld	s4,0(sp)
    80002730:	6145                	addi	sp,sp,48
    80002732:	8082                	ret
    memmove(dst, (char *)src, len);
    80002734:	000a061b          	sext.w	a2,s4
    80002738:	85ce                	mv	a1,s3
    8000273a:	854a                	mv	a0,s2
    8000273c:	ffffe097          	auipc	ra,0xffffe
    80002740:	65e080e7          	jalr	1630(ra) # 80000d9a <memmove>
    return 0;
    80002744:	8526                	mv	a0,s1
    80002746:	bff9                	j	80002724 <either_copyin+0x32>

0000000080002748 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002748:	715d                	addi	sp,sp,-80
    8000274a:	e486                	sd	ra,72(sp)
    8000274c:	e0a2                	sd	s0,64(sp)
    8000274e:	fc26                	sd	s1,56(sp)
    80002750:	f84a                	sd	s2,48(sp)
    80002752:	f44e                	sd	s3,40(sp)
    80002754:	f052                	sd	s4,32(sp)
    80002756:	ec56                	sd	s5,24(sp)
    80002758:	e85a                	sd	s6,16(sp)
    8000275a:	e45e                	sd	s7,8(sp)
    8000275c:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    8000275e:	00006517          	auipc	a0,0x6
    80002762:	8b250513          	addi	a0,a0,-1870 # 80008010 <etext+0x10>
    80002766:	ffffe097          	auipc	ra,0xffffe
    8000276a:	e44080e7          	jalr	-444(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    8000276e:	0000f497          	auipc	s1,0xf
    80002772:	97a48493          	addi	s1,s1,-1670 # 800110e8 <proc+0x158>
    80002776:	00017917          	auipc	s2,0x17
    8000277a:	57290913          	addi	s2,s2,1394 # 80019ce8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000277e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002780:	00006997          	auipc	s3,0x6
    80002784:	ae098993          	addi	s3,s3,-1312 # 80008260 <etext+0x260>
    printf("%d %s %s %d ", p->pid, state, p->name,p->tickets);
    80002788:	00006a97          	auipc	s5,0x6
    8000278c:	ae0a8a93          	addi	s5,s5,-1312 # 80008268 <etext+0x268>
    printf("\n");
    80002790:	00006a17          	auipc	s4,0x6
    80002794:	880a0a13          	addi	s4,s4,-1920 # 80008010 <etext+0x10>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002798:	00006b97          	auipc	s7,0x6
    8000279c:	fa8b8b93          	addi	s7,s7,-88 # 80008740 <states.0>
    800027a0:	a01d                	j	800027c6 <procdump+0x7e>
    printf("%d %s %s %d ", p->pid, state, p->name,p->tickets);
    800027a2:	0c46a703          	lw	a4,196(a3)
    800027a6:	ed86a583          	lw	a1,-296(a3)
    800027aa:	8556                	mv	a0,s5
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	dfe080e7          	jalr	-514(ra) # 800005aa <printf>
    printf("\n");
    800027b4:	8552                	mv	a0,s4
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	df4080e7          	jalr	-524(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800027be:	23048493          	addi	s1,s1,560
    800027c2:	03248263          	beq	s1,s2,800027e6 <procdump+0x9e>
    if (p->state == UNUSED)
    800027c6:	86a6                	mv	a3,s1
    800027c8:	ec04a783          	lw	a5,-320(s1)
    800027cc:	dbed                	beqz	a5,800027be <procdump+0x76>
      state = "???";
    800027ce:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027d0:	fcfb69e3          	bltu	s6,a5,800027a2 <procdump+0x5a>
    800027d4:	02079713          	slli	a4,a5,0x20
    800027d8:	01d75793          	srli	a5,a4,0x1d
    800027dc:	97de                	add	a5,a5,s7
    800027de:	6390                	ld	a2,0(a5)
    800027e0:	f269                	bnez	a2,800027a2 <procdump+0x5a>
      state = "???";
    800027e2:	864e                	mv	a2,s3
    800027e4:	bf7d                	j	800027a2 <procdump+0x5a>
  }
}
    800027e6:	60a6                	ld	ra,72(sp)
    800027e8:	6406                	ld	s0,64(sp)
    800027ea:	74e2                	ld	s1,56(sp)
    800027ec:	7942                	ld	s2,48(sp)
    800027ee:	79a2                	ld	s3,40(sp)
    800027f0:	7a02                	ld	s4,32(sp)
    800027f2:	6ae2                	ld	s5,24(sp)
    800027f4:	6b42                	ld	s6,16(sp)
    800027f6:	6ba2                	ld	s7,8(sp)
    800027f8:	6161                	addi	sp,sp,80
    800027fa:	8082                	ret

00000000800027fc <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    800027fc:	711d                	addi	sp,sp,-96
    800027fe:	ec86                	sd	ra,88(sp)
    80002800:	e8a2                	sd	s0,80(sp)
    80002802:	e4a6                	sd	s1,72(sp)
    80002804:	e0ca                	sd	s2,64(sp)
    80002806:	fc4e                	sd	s3,56(sp)
    80002808:	f852                	sd	s4,48(sp)
    8000280a:	f456                	sd	s5,40(sp)
    8000280c:	f05a                	sd	s6,32(sp)
    8000280e:	ec5e                	sd	s7,24(sp)
    80002810:	e862                	sd	s8,16(sp)
    80002812:	e466                	sd	s9,8(sp)
    80002814:	1080                	addi	s0,sp,96
    80002816:	8b2a                	mv	s6,a0
    80002818:	8bae                	mv	s7,a1
    8000281a:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    8000281c:	fffff097          	auipc	ra,0xfffff
    80002820:	24c080e7          	jalr	588(ra) # 80001a68 <myproc>
    80002824:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002826:	0000e517          	auipc	a0,0xe
    8000282a:	35250513          	addi	a0,a0,850 # 80010b78 <wait_lock>
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	410080e7          	jalr	1040(ra) # 80000c3e <acquire>
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002836:	4a15                	li	s4,5
        havekids = 1;
    80002838:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    8000283a:	00017997          	auipc	s3,0x17
    8000283e:	35698993          	addi	s3,s3,854 # 80019b90 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002842:	0000ec97          	auipc	s9,0xe
    80002846:	336c8c93          	addi	s9,s9,822 # 80010b78 <wait_lock>
    8000284a:	a8e1                	j	80002922 <waitx+0x126>
          pid = np->pid;
    8000284c:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002850:	1e84a783          	lw	a5,488(s1)
    80002854:	00fc2023          	sw	a5,0(s8) # 1000 <_entry-0x7ffff000>
          *wtime = np->etime - np->ctime - np->rtime;
    80002858:	1ec4a703          	lw	a4,492(s1)
    8000285c:	9f3d                	addw	a4,a4,a5
    8000285e:	1f04a783          	lw	a5,496(s1)
    80002862:	9f99                	subw	a5,a5,a4
    80002864:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002868:	000b0e63          	beqz	s6,80002884 <waitx+0x88>
    8000286c:	4691                	li	a3,4
    8000286e:	02c48613          	addi	a2,s1,44
    80002872:	85da                	mv	a1,s6
    80002874:	05093503          	ld	a0,80(s2)
    80002878:	fffff097          	auipc	ra,0xfffff
    8000287c:	e98080e7          	jalr	-360(ra) # 80001710 <copyout>
    80002880:	04054263          	bltz	a0,800028c4 <waitx+0xc8>
          freeproc(np);
    80002884:	8526                	mv	a0,s1
    80002886:	fffff097          	auipc	ra,0xfffff
    8000288a:	394080e7          	jalr	916(ra) # 80001c1a <freeproc>
          release(&np->lock);
    8000288e:	8526                	mv	a0,s1
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	45e080e7          	jalr	1118(ra) # 80000cee <release>
          release(&wait_lock);
    80002898:	0000e517          	auipc	a0,0xe
    8000289c:	2e050513          	addi	a0,a0,736 # 80010b78 <wait_lock>
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	44e080e7          	jalr	1102(ra) # 80000cee <release>
  }
}
    800028a8:	854e                	mv	a0,s3
    800028aa:	60e6                	ld	ra,88(sp)
    800028ac:	6446                	ld	s0,80(sp)
    800028ae:	64a6                	ld	s1,72(sp)
    800028b0:	6906                	ld	s2,64(sp)
    800028b2:	79e2                	ld	s3,56(sp)
    800028b4:	7a42                	ld	s4,48(sp)
    800028b6:	7aa2                	ld	s5,40(sp)
    800028b8:	7b02                	ld	s6,32(sp)
    800028ba:	6be2                	ld	s7,24(sp)
    800028bc:	6c42                	ld	s8,16(sp)
    800028be:	6ca2                	ld	s9,8(sp)
    800028c0:	6125                	addi	sp,sp,96
    800028c2:	8082                	ret
            release(&np->lock);
    800028c4:	8526                	mv	a0,s1
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	428080e7          	jalr	1064(ra) # 80000cee <release>
            release(&wait_lock);
    800028ce:	0000e517          	auipc	a0,0xe
    800028d2:	2aa50513          	addi	a0,a0,682 # 80010b78 <wait_lock>
    800028d6:	ffffe097          	auipc	ra,0xffffe
    800028da:	418080e7          	jalr	1048(ra) # 80000cee <release>
            return -1;
    800028de:	59fd                	li	s3,-1
    800028e0:	b7e1                	j	800028a8 <waitx+0xac>
    for (np = proc; np < &proc[NPROC]; np++)
    800028e2:	23048493          	addi	s1,s1,560
    800028e6:	03348463          	beq	s1,s3,8000290e <waitx+0x112>
      if (np->parent == p)
    800028ea:	7c9c                	ld	a5,56(s1)
    800028ec:	ff279be3          	bne	a5,s2,800028e2 <waitx+0xe6>
        acquire(&np->lock);
    800028f0:	8526                	mv	a0,s1
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	34c080e7          	jalr	844(ra) # 80000c3e <acquire>
        if (np->state == ZOMBIE)
    800028fa:	4c9c                	lw	a5,24(s1)
    800028fc:	f54788e3          	beq	a5,s4,8000284c <waitx+0x50>
        release(&np->lock);
    80002900:	8526                	mv	a0,s1
    80002902:	ffffe097          	auipc	ra,0xffffe
    80002906:	3ec080e7          	jalr	1004(ra) # 80000cee <release>
        havekids = 1;
    8000290a:	8756                	mv	a4,s5
    8000290c:	bfd9                	j	800028e2 <waitx+0xe6>
    if (!havekids || p->killed)
    8000290e:	c305                	beqz	a4,8000292e <waitx+0x132>
    80002910:	02892783          	lw	a5,40(s2)
    80002914:	ef89                	bnez	a5,8000292e <waitx+0x132>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002916:	85e6                	mv	a1,s9
    80002918:	854a                	mv	a0,s2
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	946080e7          	jalr	-1722(ra) # 80002260 <sleep>
    havekids = 0;
    80002922:	4701                	li	a4,0
    for (np = proc; np < &proc[NPROC]; np++)
    80002924:	0000e497          	auipc	s1,0xe
    80002928:	66c48493          	addi	s1,s1,1644 # 80010f90 <proc>
    8000292c:	bf7d                	j	800028ea <waitx+0xee>
      release(&wait_lock);
    8000292e:	0000e517          	auipc	a0,0xe
    80002932:	24a50513          	addi	a0,a0,586 # 80010b78 <wait_lock>
    80002936:	ffffe097          	auipc	ra,0xffffe
    8000293a:	3b8080e7          	jalr	952(ra) # 80000cee <release>
      return -1;
    8000293e:	59fd                	li	s3,-1
    80002940:	b7a5                	j	800028a8 <waitx+0xac>

0000000080002942 <update_time>:

void update_time()
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002950:	0000e497          	auipc	s1,0xe
    80002954:	64048493          	addi	s1,s1,1600 # 80010f90 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002958:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    8000295a:	00017917          	auipc	s2,0x17
    8000295e:	23690913          	addi	s2,s2,566 # 80019b90 <tickslock>
    80002962:	a811                	j	80002976 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002964:	8526                	mv	a0,s1
    80002966:	ffffe097          	auipc	ra,0xffffe
    8000296a:	388080e7          	jalr	904(ra) # 80000cee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000296e:	23048493          	addi	s1,s1,560
    80002972:	03248063          	beq	s1,s2,80002992 <update_time+0x50>
    acquire(&p->lock);
    80002976:	8526                	mv	a0,s1
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	2c6080e7          	jalr	710(ra) # 80000c3e <acquire>
    if (p->state == RUNNING)
    80002980:	4c9c                	lw	a5,24(s1)
    80002982:	ff3791e3          	bne	a5,s3,80002964 <update_time+0x22>
      p->rtime++;
    80002986:	1e84a783          	lw	a5,488(s1)
    8000298a:	2785                	addiw	a5,a5,1
    8000298c:	1ef4a423          	sw	a5,488(s1)
    80002990:	bfd1                	j	80002964 <update_time+0x22>
  }
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret

00000000800029a0 <swtch>:
    800029a0:	00153023          	sd	ra,0(a0)
    800029a4:	00253423          	sd	sp,8(a0)
    800029a8:	e900                	sd	s0,16(a0)
    800029aa:	ed04                	sd	s1,24(a0)
    800029ac:	03253023          	sd	s2,32(a0)
    800029b0:	03353423          	sd	s3,40(a0)
    800029b4:	03453823          	sd	s4,48(a0)
    800029b8:	03553c23          	sd	s5,56(a0)
    800029bc:	05653023          	sd	s6,64(a0)
    800029c0:	05753423          	sd	s7,72(a0)
    800029c4:	05853823          	sd	s8,80(a0)
    800029c8:	05953c23          	sd	s9,88(a0)
    800029cc:	07a53023          	sd	s10,96(a0)
    800029d0:	07b53423          	sd	s11,104(a0)
    800029d4:	0005b083          	ld	ra,0(a1)
    800029d8:	0085b103          	ld	sp,8(a1)
    800029dc:	6980                	ld	s0,16(a1)
    800029de:	6d84                	ld	s1,24(a1)
    800029e0:	0205b903          	ld	s2,32(a1)
    800029e4:	0285b983          	ld	s3,40(a1)
    800029e8:	0305ba03          	ld	s4,48(a1)
    800029ec:	0385ba83          	ld	s5,56(a1)
    800029f0:	0405bb03          	ld	s6,64(a1)
    800029f4:	0485bb83          	ld	s7,72(a1)
    800029f8:	0505bc03          	ld	s8,80(a1)
    800029fc:	0585bc83          	ld	s9,88(a1)
    80002a00:	0605bd03          	ld	s10,96(a1)
    80002a04:	0685bd83          	ld	s11,104(a1)
    80002a08:	8082                	ret

0000000080002a0a <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002a0a:	1141                	addi	sp,sp,-16
    80002a0c:	e406                	sd	ra,8(sp)
    80002a0e:	e022                	sd	s0,0(sp)
    80002a10:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a12:	00006597          	auipc	a1,0x6
    80002a16:	89658593          	addi	a1,a1,-1898 # 800082a8 <etext+0x2a8>
    80002a1a:	00017517          	auipc	a0,0x17
    80002a1e:	17650513          	addi	a0,a0,374 # 80019b90 <tickslock>
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	188080e7          	jalr	392(ra) # 80000baa <initlock>
}
    80002a2a:	60a2                	ld	ra,8(sp)
    80002a2c:	6402                	ld	s0,0(sp)
    80002a2e:	0141                	addi	sp,sp,16
    80002a30:	8082                	ret

0000000080002a32 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002a32:	1141                	addi	sp,sp,-16
    80002a34:	e406                	sd	ra,8(sp)
    80002a36:	e022                	sd	s0,0(sp)
    80002a38:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a3a:	00004797          	auipc	a5,0x4
    80002a3e:	85678793          	addi	a5,a5,-1962 # 80006290 <kernelvec>
    80002a42:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a46:	60a2                	ld	ra,8(sp)
    80002a48:	6402                	ld	s0,0(sp)
    80002a4a:	0141                	addi	sp,sp,16
    80002a4c:	8082                	ret

0000000080002a4e <usertrapret>:
//
// return to user space
//

void usertrapret(void)
{
    80002a4e:	1141                	addi	sp,sp,-16
    80002a50:	e406                	sd	ra,8(sp)
    80002a52:	e022                	sd	s0,0(sp)
    80002a54:	0800                	addi	s0,sp,16

  struct proc *p = myproc();
    80002a56:	fffff097          	auipc	ra,0xfffff
    80002a5a:	012080e7          	jalr	18(ra) # 80001a68 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a62:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a64:	10079073          	csrw	sstatus,a5
  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a68:	00004697          	auipc	a3,0x4
    80002a6c:	59868693          	addi	a3,a3,1432 # 80007000 <_trampoline>
    80002a70:	00004717          	auipc	a4,0x4
    80002a74:	59070713          	addi	a4,a4,1424 # 80007000 <_trampoline>
    80002a78:	8f15                	sub	a4,a4,a3
    80002a7a:	040007b7          	lui	a5,0x4000
    80002a7e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002a80:	07b2                	slli	a5,a5,0xc
    80002a82:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a84:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a88:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a8a:	18002673          	csrr	a2,satp
    80002a8e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a90:	6d30                	ld	a2,88(a0)
    80002a92:	6138                	ld	a4,64(a0)
    80002a94:	6585                	lui	a1,0x1
    80002a96:	972e                	add	a4,a4,a1
    80002a98:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a9a:	6d38                	ld	a4,88(a0)
    80002a9c:	00000617          	auipc	a2,0x0
    80002aa0:	14660613          	addi	a2,a2,326 # 80002be2 <usertrap>
    80002aa4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002aa6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002aa8:	8612                	mv	a2,tp
    80002aaa:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aac:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ab0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ab4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ab8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002abc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002abe:	6f18                	ld	a4,24(a4)
    80002ac0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002ac4:	6928                	ld	a0,80(a0)
    80002ac6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002ac8:	00004717          	auipc	a4,0x4
    80002acc:	5d470713          	addi	a4,a4,1492 # 8000709c <userret>
    80002ad0:	8f15                	sub	a4,a4,a3
    80002ad2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ad4:	577d                	li	a4,-1
    80002ad6:	177e                	slli	a4,a4,0x3f
    80002ad8:	8d59                	or	a0,a0,a4
    80002ada:	9782                	jalr	a5
};
    80002adc:	60a2                	ld	ra,8(sp)
    80002ade:	6402                	ld	s0,0(sp)
    80002ae0:	0141                	addi	sp,sp,16
    80002ae2:	8082                	ret

0000000080002ae4 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	e04a                	sd	s2,0(sp)
    80002aee:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002af0:	00017917          	auipc	s2,0x17
    80002af4:	0a090913          	addi	s2,s2,160 # 80019b90 <tickslock>
    80002af8:	854a                	mv	a0,s2
    80002afa:	ffffe097          	auipc	ra,0xffffe
    80002afe:	144080e7          	jalr	324(ra) # 80000c3e <acquire>
  ticks++;
    80002b02:	00006497          	auipc	s1,0x6
    80002b06:	df248493          	addi	s1,s1,-526 # 800088f4 <ticks>
    80002b0a:	409c                	lw	a5,0(s1)
    80002b0c:	2785                	addiw	a5,a5,1
    80002b0e:	c09c                	sw	a5,0(s1)
  update_time();
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	e32080e7          	jalr	-462(ra) # 80002942 <update_time>
// }




  wakeup(&ticks);
    80002b18:	8526                	mv	a0,s1
    80002b1a:	fffff097          	auipc	ra,0xfffff
    80002b1e:	7aa080e7          	jalr	1962(ra) # 800022c4 <wakeup>
  release(&tickslock);
    80002b22:	854a                	mv	a0,s2
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	1ca080e7          	jalr	458(ra) # 80000cee <release>
}
    80002b2c:	60e2                	ld	ra,24(sp)
    80002b2e:	6442                	ld	s0,16(sp)
    80002b30:	64a2                	ld	s1,8(sp)
    80002b32:	6902                	ld	s2,0(sp)
    80002b34:	6105                	addi	sp,sp,32
    80002b36:	8082                	ret

0000000080002b38 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b38:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002b3c:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002b3e:	0a07d163          	bgez	a5,80002be0 <devintr+0xa8>
{
    80002b42:	1101                	addi	sp,sp,-32
    80002b44:	ec06                	sd	ra,24(sp)
    80002b46:	e822                	sd	s0,16(sp)
    80002b48:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80002b4a:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002b4e:	46a5                	li	a3,9
    80002b50:	00d70c63          	beq	a4,a3,80002b68 <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80002b54:	577d                	li	a4,-1
    80002b56:	177e                	slli	a4,a4,0x3f
    80002b58:	0705                	addi	a4,a4,1
    return 0;
    80002b5a:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002b5c:	06e78163          	beq	a5,a4,80002bbe <devintr+0x86>
  }
}
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret
    80002b68:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002b6a:	00004097          	auipc	ra,0x4
    80002b6e:	832080e7          	jalr	-1998(ra) # 8000639c <plic_claim>
    80002b72:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002b74:	47a9                	li	a5,10
    80002b76:	00f50963          	beq	a0,a5,80002b88 <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80002b7a:	4785                	li	a5,1
    80002b7c:	00f50b63          	beq	a0,a5,80002b92 <devintr+0x5a>
    return 1;
    80002b80:	4505                	li	a0,1
    else if (irq)
    80002b82:	ec89                	bnez	s1,80002b9c <devintr+0x64>
    80002b84:	64a2                	ld	s1,8(sp)
    80002b86:	bfe9                	j	80002b60 <devintr+0x28>
      uartintr();
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	e74080e7          	jalr	-396(ra) # 800009fc <uartintr>
    if (irq)
    80002b90:	a839                	j	80002bae <devintr+0x76>
      virtio_disk_intr();
    80002b92:	00004097          	auipc	ra,0x4
    80002b96:	cfe080e7          	jalr	-770(ra) # 80006890 <virtio_disk_intr>
    if (irq)
    80002b9a:	a811                	j	80002bae <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b9c:	85a6                	mv	a1,s1
    80002b9e:	00005517          	auipc	a0,0x5
    80002ba2:	71250513          	addi	a0,a0,1810 # 800082b0 <etext+0x2b0>
    80002ba6:	ffffe097          	auipc	ra,0xffffe
    80002baa:	a04080e7          	jalr	-1532(ra) # 800005aa <printf>
      plic_complete(irq);
    80002bae:	8526                	mv	a0,s1
    80002bb0:	00004097          	auipc	ra,0x4
    80002bb4:	810080e7          	jalr	-2032(ra) # 800063c0 <plic_complete>
    return 1;
    80002bb8:	4505                	li	a0,1
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	b755                	j	80002b60 <devintr+0x28>
    if (cpuid() == 0)
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	e76080e7          	jalr	-394(ra) # 80001a34 <cpuid>
    80002bc6:	c901                	beqz	a0,80002bd6 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002bc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002bcc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002bce:	14479073          	csrw	sip,a5
    return 2;
    80002bd2:	4509                	li	a0,2
    80002bd4:	b771                	j	80002b60 <devintr+0x28>
      clockintr();
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	f0e080e7          	jalr	-242(ra) # 80002ae4 <clockintr>
    80002bde:	b7ed                	j	80002bc8 <devintr+0x90>
}
    80002be0:	8082                	ret

0000000080002be2 <usertrap>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bee:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002bf2:	1007f793          	andi	a5,a5,256
    80002bf6:	e3b1                	bnez	a5,80002c3a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bf8:	00003797          	auipc	a5,0x3
    80002bfc:	69878793          	addi	a5,a5,1688 # 80006290 <kernelvec>
    80002c00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c04:	fffff097          	auipc	ra,0xfffff
    80002c08:	e64080e7          	jalr	-412(ra) # 80001a68 <myproc>
    80002c0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c10:	14102773          	csrr	a4,sepc
    80002c14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c16:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002c1a:	47a1                	li	a5,8
    80002c1c:	02f70763          	beq	a4,a5,80002c4a <usertrap+0x68>
  else if ((which_dev = devintr()) != 0)
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	f18080e7          	jalr	-232(ra) # 80002b38 <devintr>
    80002c28:	892a                	mv	s2,a0
    80002c2a:	c92d                	beqz	a0,80002c9c <usertrap+0xba>
  if (killed(p))
    80002c2c:	8526                	mv	a0,s1
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	914080e7          	jalr	-1772(ra) # 80002542 <killed>
    80002c36:	c555                	beqz	a0,80002ce2 <usertrap+0x100>
    80002c38:	a045                	j	80002cd8 <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80002c3a:	00005517          	auipc	a0,0x5
    80002c3e:	69650513          	addi	a0,a0,1686 # 800082d0 <etext+0x2d0>
    80002c42:	ffffe097          	auipc	ra,0xffffe
    80002c46:	91e080e7          	jalr	-1762(ra) # 80000560 <panic>
    if (killed(p))
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	8f8080e7          	jalr	-1800(ra) # 80002542 <killed>
    80002c52:	ed1d                	bnez	a0,80002c90 <usertrap+0xae>
    p->trapframe->epc += 4;
    80002c54:	6cb8                	ld	a4,88(s1)
    80002c56:	6f1c                	ld	a5,24(a4)
    80002c58:	0791                	addi	a5,a5,4
    80002c5a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c64:	10079073          	csrw	sstatus,a5
    syscall();
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	314080e7          	jalr	788(ra) # 80002f7c <syscall>
  if (killed(p))
    80002c70:	8526                	mv	a0,s1
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	8d0080e7          	jalr	-1840(ra) # 80002542 <killed>
    80002c7a:	ed31                	bnez	a0,80002cd6 <usertrap+0xf4>
  usertrapret();
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	dd2080e7          	jalr	-558(ra) # 80002a4e <usertrapret>
};
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6902                	ld	s2,0(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret
      exit(-1);
    80002c90:	557d                	li	a0,-1
    80002c92:	fffff097          	auipc	ra,0xfffff
    80002c96:	710080e7          	jalr	1808(ra) # 800023a2 <exit>
    80002c9a:	bf6d                	j	80002c54 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c9c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002ca0:	5890                	lw	a2,48(s1)
    80002ca2:	00005517          	auipc	a0,0x5
    80002ca6:	64e50513          	addi	a0,a0,1614 # 800082f0 <etext+0x2f0>
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	900080e7          	jalr	-1792(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cb2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cb6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002cba:	00005517          	auipc	a0,0x5
    80002cbe:	66650513          	addi	a0,a0,1638 # 80008320 <etext+0x320>
    80002cc2:	ffffe097          	auipc	ra,0xffffe
    80002cc6:	8e8080e7          	jalr	-1816(ra) # 800005aa <printf>
    setkilled(p);
    80002cca:	8526                	mv	a0,s1
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	84a080e7          	jalr	-1974(ra) # 80002516 <setkilled>
    80002cd4:	bf71                	j	80002c70 <usertrap+0x8e>
  if (killed(p))
    80002cd6:	4901                	li	s2,0
    exit(-1);
    80002cd8:	557d                	li	a0,-1
    80002cda:	fffff097          	auipc	ra,0xfffff
    80002cde:	6c8080e7          	jalr	1736(ra) # 800023a2 <exit>
  if (which_dev == 2 )
    80002ce2:	4789                	li	a5,2
    80002ce4:	f8f91ce3          	bne	s2,a5,80002c7c <usertrap+0x9a>
    if(p->alaramflag)
    80002ce8:	2184a783          	lw	a5,536(s1)
    80002cec:	cf81                	beqz	a5,80002d04 <usertrap+0x122>
      p->clockcyclepassed++;
    80002cee:	1f84b783          	ld	a5,504(s1)
    80002cf2:	0785                	addi	a5,a5,1
    80002cf4:	1ef4bc23          	sd	a5,504(s1)
      if(p->alarmcount>(0*zero+one*zero) &&p->clockcyclepassed >= p->alarmcount)
    80002cf8:	2004a703          	lw	a4,512(s1)
    80002cfc:	00e05463          	blez	a4,80002d04 <usertrap+0x122>
    80002d00:	00e7f763          	bgeu	a5,a4,80002d0e <usertrap+0x12c>
    yield();
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	520080e7          	jalr	1312(ra) # 80002224 <yield>
    80002d0c:	bf85                	j	80002c7c <usertrap+0x9a>
        struct trapframe* tempi = kalloc();
    80002d0e:	ffffe097          	auipc	ra,0xffffe
    80002d12:	e3c080e7          	jalr	-452(ra) # 80000b4a <kalloc>
    80002d16:	892a                	mv	s2,a0
        memmove(tempi,p->trapframe,PGSIZE);
    80002d18:	6605                	lui	a2,0x1
    80002d1a:	6cac                	ld	a1,88(s1)
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	07e080e7          	jalr	126(ra) # 80000d9a <memmove>
        p->savedtrapframe=tempi;
    80002d24:	2124b823          	sd	s2,528(s1)
        p->alaramflag = (0*zero+one)*zero;
    80002d28:	2004ac23          	sw	zero,536(s1)
        p->clockcyclepassed = zero*(0*zero+one);
    80002d2c:	1e04bc23          	sd	zero,504(s1)
        p->trapframe->epc=p->handleraddress;
    80002d30:	6cbc                	ld	a5,88(s1)
    80002d32:	2084b703          	ld	a4,520(s1)
    80002d36:	ef98                	sd	a4,24(a5)
    80002d38:	b7f1                	j	80002d04 <usertrap+0x122>

0000000080002d3a <kerneltrap>:
{
    80002d3a:	7179                	addi	sp,sp,-48
    80002d3c:	f406                	sd	ra,40(sp)
    80002d3e:	f022                	sd	s0,32(sp)
    80002d40:	ec26                	sd	s1,24(sp)
    80002d42:	e84a                	sd	s2,16(sp)
    80002d44:	e44e                	sd	s3,8(sp)
    80002d46:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d48:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d4c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d50:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002d54:	1004f793          	andi	a5,s1,256
    80002d58:	cb85                	beqz	a5,80002d88 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d5a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d5e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002d60:	ef85                	bnez	a5,80002d98 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	dd6080e7          	jalr	-554(ra) # 80002b38 <devintr>
    80002d6a:	cd1d                	beqz	a0,80002da8 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d6c:	4789                	li	a5,2
    80002d6e:	06f50a63          	beq	a0,a5,80002de2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d72:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d76:	10049073          	csrw	sstatus,s1
}
    80002d7a:	70a2                	ld	ra,40(sp)
    80002d7c:	7402                	ld	s0,32(sp)
    80002d7e:	64e2                	ld	s1,24(sp)
    80002d80:	6942                	ld	s2,16(sp)
    80002d82:	69a2                	ld	s3,8(sp)
    80002d84:	6145                	addi	sp,sp,48
    80002d86:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	5b850513          	addi	a0,a0,1464 # 80008340 <etext+0x340>
    80002d90:	ffffd097          	auipc	ra,0xffffd
    80002d94:	7d0080e7          	jalr	2000(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d98:	00005517          	auipc	a0,0x5
    80002d9c:	5d050513          	addi	a0,a0,1488 # 80008368 <etext+0x368>
    80002da0:	ffffd097          	auipc	ra,0xffffd
    80002da4:	7c0080e7          	jalr	1984(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002da8:	85ce                	mv	a1,s3
    80002daa:	00005517          	auipc	a0,0x5
    80002dae:	5de50513          	addi	a0,a0,1502 # 80008388 <etext+0x388>
    80002db2:	ffffd097          	auipc	ra,0xffffd
    80002db6:	7f8080e7          	jalr	2040(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dbe:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dc2:	00005517          	auipc	a0,0x5
    80002dc6:	5d650513          	addi	a0,a0,1494 # 80008398 <etext+0x398>
    80002dca:	ffffd097          	auipc	ra,0xffffd
    80002dce:	7e0080e7          	jalr	2016(ra) # 800005aa <printf>
    panic("kerneltrap");
    80002dd2:	00005517          	auipc	a0,0x5
    80002dd6:	5de50513          	addi	a0,a0,1502 # 800083b0 <etext+0x3b0>
    80002dda:	ffffd097          	auipc	ra,0xffffd
    80002dde:	786080e7          	jalr	1926(ra) # 80000560 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002de2:	fffff097          	auipc	ra,0xfffff
    80002de6:	c86080e7          	jalr	-890(ra) # 80001a68 <myproc>
    80002dea:	d541                	beqz	a0,80002d72 <kerneltrap+0x38>
    80002dec:	fffff097          	auipc	ra,0xfffff
    80002df0:	c7c080e7          	jalr	-900(ra) # 80001a68 <myproc>
    80002df4:	4d18                	lw	a4,24(a0)
    80002df6:	4791                	li	a5,4
    80002df8:	f6f71de3          	bne	a4,a5,80002d72 <kerneltrap+0x38>
    yield();
    80002dfc:	fffff097          	auipc	ra,0xfffff
    80002e00:	428080e7          	jalr	1064(ra) # 80002224 <yield>
    80002e04:	b7bd                	j	80002d72 <kerneltrap+0x38>

0000000080002e06 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	c56080e7          	jalr	-938(ra) # 80001a68 <myproc>
  switch (n) {
    80002e1a:	4795                	li	a5,5
    80002e1c:	0497e163          	bltu	a5,s1,80002e5e <argraw+0x58>
    80002e20:	048a                	slli	s1,s1,0x2
    80002e22:	00006717          	auipc	a4,0x6
    80002e26:	94e70713          	addi	a4,a4,-1714 # 80008770 <states.0+0x30>
    80002e2a:	94ba                	add	s1,s1,a4
    80002e2c:	409c                	lw	a5,0(s1)
    80002e2e:	97ba                	add	a5,a5,a4
    80002e30:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e32:	6d3c                	ld	a5,88(a0)
    80002e34:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e36:	60e2                	ld	ra,24(sp)
    80002e38:	6442                	ld	s0,16(sp)
    80002e3a:	64a2                	ld	s1,8(sp)
    80002e3c:	6105                	addi	sp,sp,32
    80002e3e:	8082                	ret
    return p->trapframe->a1;
    80002e40:	6d3c                	ld	a5,88(a0)
    80002e42:	7fa8                	ld	a0,120(a5)
    80002e44:	bfcd                	j	80002e36 <argraw+0x30>
    return p->trapframe->a2;
    80002e46:	6d3c                	ld	a5,88(a0)
    80002e48:	63c8                	ld	a0,128(a5)
    80002e4a:	b7f5                	j	80002e36 <argraw+0x30>
    return p->trapframe->a3;
    80002e4c:	6d3c                	ld	a5,88(a0)
    80002e4e:	67c8                	ld	a0,136(a5)
    80002e50:	b7dd                	j	80002e36 <argraw+0x30>
    return p->trapframe->a4;
    80002e52:	6d3c                	ld	a5,88(a0)
    80002e54:	6bc8                	ld	a0,144(a5)
    80002e56:	b7c5                	j	80002e36 <argraw+0x30>
    return p->trapframe->a5;
    80002e58:	6d3c                	ld	a5,88(a0)
    80002e5a:	6fc8                	ld	a0,152(a5)
    80002e5c:	bfe9                	j	80002e36 <argraw+0x30>
  panic("argraw");
    80002e5e:	00005517          	auipc	a0,0x5
    80002e62:	56250513          	addi	a0,a0,1378 # 800083c0 <etext+0x3c0>
    80002e66:	ffffd097          	auipc	ra,0xffffd
    80002e6a:	6fa080e7          	jalr	1786(ra) # 80000560 <panic>

0000000080002e6e <fetchaddr>:
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	e04a                	sd	s2,0(sp)
    80002e78:	1000                	addi	s0,sp,32
    80002e7a:	84aa                	mv	s1,a0
    80002e7c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e7e:	fffff097          	auipc	ra,0xfffff
    80002e82:	bea080e7          	jalr	-1046(ra) # 80001a68 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002e86:	653c                	ld	a5,72(a0)
    80002e88:	02f4f863          	bgeu	s1,a5,80002eb8 <fetchaddr+0x4a>
    80002e8c:	00848713          	addi	a4,s1,8
    80002e90:	02e7e663          	bltu	a5,a4,80002ebc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e94:	46a1                	li	a3,8
    80002e96:	8626                	mv	a2,s1
    80002e98:	85ca                	mv	a1,s2
    80002e9a:	6928                	ld	a0,80(a0)
    80002e9c:	fffff097          	auipc	ra,0xfffff
    80002ea0:	900080e7          	jalr	-1792(ra) # 8000179c <copyin>
    80002ea4:	00a03533          	snez	a0,a0
    80002ea8:	40a0053b          	negw	a0,a0
}
    80002eac:	60e2                	ld	ra,24(sp)
    80002eae:	6442                	ld	s0,16(sp)
    80002eb0:	64a2                	ld	s1,8(sp)
    80002eb2:	6902                	ld	s2,0(sp)
    80002eb4:	6105                	addi	sp,sp,32
    80002eb6:	8082                	ret
    return -1;
    80002eb8:	557d                	li	a0,-1
    80002eba:	bfcd                	j	80002eac <fetchaddr+0x3e>
    80002ebc:	557d                	li	a0,-1
    80002ebe:	b7fd                	j	80002eac <fetchaddr+0x3e>

0000000080002ec0 <fetchstr>:
{
    80002ec0:	7179                	addi	sp,sp,-48
    80002ec2:	f406                	sd	ra,40(sp)
    80002ec4:	f022                	sd	s0,32(sp)
    80002ec6:	ec26                	sd	s1,24(sp)
    80002ec8:	e84a                	sd	s2,16(sp)
    80002eca:	e44e                	sd	s3,8(sp)
    80002ecc:	1800                	addi	s0,sp,48
    80002ece:	892a                	mv	s2,a0
    80002ed0:	84ae                	mv	s1,a1
    80002ed2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ed4:	fffff097          	auipc	ra,0xfffff
    80002ed8:	b94080e7          	jalr	-1132(ra) # 80001a68 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002edc:	86ce                	mv	a3,s3
    80002ede:	864a                	mv	a2,s2
    80002ee0:	85a6                	mv	a1,s1
    80002ee2:	6928                	ld	a0,80(a0)
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	946080e7          	jalr	-1722(ra) # 8000182a <copyinstr>
    80002eec:	00054e63          	bltz	a0,80002f08 <fetchstr+0x48>
  return strlen(buf);
    80002ef0:	8526                	mv	a0,s1
    80002ef2:	ffffe097          	auipc	ra,0xffffe
    80002ef6:	fd0080e7          	jalr	-48(ra) # 80000ec2 <strlen>
}
    80002efa:	70a2                	ld	ra,40(sp)
    80002efc:	7402                	ld	s0,32(sp)
    80002efe:	64e2                	ld	s1,24(sp)
    80002f00:	6942                	ld	s2,16(sp)
    80002f02:	69a2                	ld	s3,8(sp)
    80002f04:	6145                	addi	sp,sp,48
    80002f06:	8082                	ret
    return -1;
    80002f08:	557d                	li	a0,-1
    80002f0a:	bfc5                	j	80002efa <fetchstr+0x3a>

0000000080002f0c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002f0c:	1101                	addi	sp,sp,-32
    80002f0e:	ec06                	sd	ra,24(sp)
    80002f10:	e822                	sd	s0,16(sp)
    80002f12:	e426                	sd	s1,8(sp)
    80002f14:	1000                	addi	s0,sp,32
    80002f16:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	eee080e7          	jalr	-274(ra) # 80002e06 <argraw>
    80002f20:	c088                	sw	a0,0(s1)
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret

0000000080002f2c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	e426                	sd	s1,8(sp)
    80002f34:	1000                	addi	s0,sp,32
    80002f36:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	ece080e7          	jalr	-306(ra) # 80002e06 <argraw>
    80002f40:	e088                	sd	a0,0(s1)
}
    80002f42:	60e2                	ld	ra,24(sp)
    80002f44:	6442                	ld	s0,16(sp)
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	6105                	addi	sp,sp,32
    80002f4a:	8082                	ret

0000000080002f4c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f4c:	1101                	addi	sp,sp,-32
    80002f4e:	ec06                	sd	ra,24(sp)
    80002f50:	e822                	sd	s0,16(sp)
    80002f52:	e426                	sd	s1,8(sp)
    80002f54:	e04a                	sd	s2,0(sp)
    80002f56:	1000                	addi	s0,sp,32
    80002f58:	84ae                	mv	s1,a1
    80002f5a:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	eaa080e7          	jalr	-342(ra) # 80002e06 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002f64:	864a                	mv	a2,s2
    80002f66:	85a6                	mv	a1,s1
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	f58080e7          	jalr	-168(ra) # 80002ec0 <fetchstr>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6902                	ld	s2,0(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret

0000000080002f7c <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
    80002f7c:	7179                	addi	sp,sp,-48
    80002f7e:	f406                	sd	ra,40(sp)
    80002f80:	f022                	sd	s0,32(sp)
    80002f82:	ec26                	sd	s1,24(sp)
    80002f84:	e84a                	sd	s2,16(sp)
    80002f86:	e44e                	sd	s3,8(sp)
    80002f88:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	ade080e7          	jalr	-1314(ra) # 80001a68 <myproc>
    80002f92:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f94:	05853983          	ld	s3,88(a0)
    80002f98:	0a89b783          	ld	a5,168(s3)
    80002f9c:	0007891b          	sext.w	s2,a5
  if(num==SYS_read)
    80002fa0:	4715                	li	a4,5
    80002fa2:	02e90a63          	beq	s2,a4,80002fd6 <syscall+0x5a>
  {
    p->syscall_counts[num]++;
  }
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fa6:	37fd                	addiw	a5,a5,-1
    80002fa8:	4765                	li	a4,25
    80002faa:	04f76363          	bltu	a4,a5,80002ff0 <syscall+0x74>
    80002fae:	00391713          	slli	a4,s2,0x3
    80002fb2:	00005797          	auipc	a5,0x5
    80002fb6:	7d678793          	addi	a5,a5,2006 # 80008788 <syscalls>
    80002fba:	97ba                	add	a5,a5,a4
    80002fbc:	6398                	ld	a4,0(a5)
    80002fbe:	cb0d                	beqz	a4,80002ff0 <syscall+0x74>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    // printf("num :%d",&num);
    p->trapframe->a0 = syscalls[num]();
    80002fc0:	9702                	jalr	a4
    80002fc2:	06a9b823          	sd	a0,112(s3)
    p->syscall_counts[num]++;
    80002fc6:	090a                	slli	s2,s2,0x2
    80002fc8:	9926                	add	s2,s2,s1
    80002fca:	16892783          	lw	a5,360(s2)
    80002fce:	2785                	addiw	a5,a5,1
    80002fd0:	16f92423          	sw	a5,360(s2)
    80002fd4:	a82d                	j	8000300e <syscall+0x92>
    p->syscall_counts[num]++;
    80002fd6:	17c52703          	lw	a4,380(a0)
    80002fda:	2705                	addiw	a4,a4,1
    80002fdc:	16e52e23          	sw	a4,380(a0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fe0:	37fd                	addiw	a5,a5,-1
    80002fe2:	46e5                	li	a3,25
    80002fe4:	00003717          	auipc	a4,0x3
    80002fe8:	8b670713          	addi	a4,a4,-1866 # 8000589a <sys_read>
    80002fec:	fcf6fae3          	bgeu	a3,a5,80002fc0 <syscall+0x44>
    // printf("num:%d syscall_count",num,p->syscall_counts[num]);
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ff0:	86ca                	mv	a3,s2
    80002ff2:	15848613          	addi	a2,s1,344
    80002ff6:	588c                	lw	a1,48(s1)
    80002ff8:	00005517          	auipc	a0,0x5
    80002ffc:	3d050513          	addi	a0,a0,976 # 800083c8 <etext+0x3c8>
    80003000:	ffffd097          	auipc	ra,0xffffd
    80003004:	5aa080e7          	jalr	1450(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003008:	6cbc                	ld	a5,88(s1)
    8000300a:	577d                	li	a4,-1
    8000300c:	fbb8                	sd	a4,112(a5)
  }
}
    8000300e:	70a2                	ld	ra,40(sp)
    80003010:	7402                	ld	s0,32(sp)
    80003012:	64e2                	ld	s1,24(sp)
    80003014:	6942                	ld	s2,16(sp)
    80003016:	69a2                	ld	s3,8(sp)
    80003018:	6145                	addi	sp,sp,48
    8000301a:	8082                	ret

000000008000301c <sys_exit>:
#define zerooo 0 
#define oneee 1
// i am doing this just to not get mossed with others i am not copying or demossing anyones code 
uint64
sys_exit(void)
{
    8000301c:	1101                	addi	sp,sp,-32
    8000301e:	ec06                	sd	ra,24(sp)
    80003020:	e822                	sd	s0,16(sp)
    80003022:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003024:	fec40593          	addi	a1,s0,-20
    80003028:	4501                	li	a0,0
    8000302a:	00000097          	auipc	ra,0x0
    8000302e:	ee2080e7          	jalr	-286(ra) # 80002f0c <argint>



  exit(n);
    80003032:	fec42503          	lw	a0,-20(s0)
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	36c080e7          	jalr	876(ra) # 800023a2 <exit>
  return 0; // not reached
}
    8000303e:	4501                	li	a0,0
    80003040:	60e2                	ld	ra,24(sp)
    80003042:	6442                	ld	s0,16(sp)
    80003044:	6105                	addi	sp,sp,32
    80003046:	8082                	ret

0000000080003048 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003048:	1141                	addi	sp,sp,-16
    8000304a:	e406                	sd	ra,8(sp)
    8000304c:	e022                	sd	s0,0(sp)
    8000304e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	a18080e7          	jalr	-1512(ra) # 80001a68 <myproc>
}
    80003058:	5908                	lw	a0,48(a0)
    8000305a:	60a2                	ld	ra,8(sp)
    8000305c:	6402                	ld	s0,0(sp)
    8000305e:	0141                	addi	sp,sp,16
    80003060:	8082                	ret

0000000080003062 <sys_fork>:

uint64
sys_fork(void)
{
    80003062:	1141                	addi	sp,sp,-16
    80003064:	e406                	sd	ra,8(sp)
    80003066:	e022                	sd	s0,0(sp)
    80003068:	0800                	addi	s0,sp,16
  return fork();
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	e04080e7          	jalr	-508(ra) # 80001e6e <fork>
}
    80003072:	60a2                	ld	ra,8(sp)
    80003074:	6402                	ld	s0,0(sp)
    80003076:	0141                	addi	sp,sp,16
    80003078:	8082                	ret

000000008000307a <sys_wait>:

uint64
sys_wait(void)
{
    8000307a:	1101                	addi	sp,sp,-32
    8000307c:	ec06                	sd	ra,24(sp)
    8000307e:	e822                	sd	s0,16(sp)
    80003080:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003082:	fe840593          	addi	a1,s0,-24
    80003086:	4501                	li	a0,0
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	ea4080e7          	jalr	-348(ra) # 80002f2c <argaddr>
  return wait(p);
    80003090:	fe843503          	ld	a0,-24(s0)
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	4e0080e7          	jalr	1248(ra) # 80002574 <wait>
}
    8000309c:	60e2                	ld	ra,24(sp)
    8000309e:	6442                	ld	s0,16(sp)
    800030a0:	6105                	addi	sp,sp,32
    800030a2:	8082                	ret

00000000800030a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030a4:	7179                	addi	sp,sp,-48
    800030a6:	f406                	sd	ra,40(sp)
    800030a8:	f022                	sd	s0,32(sp)
    800030aa:	ec26                	sd	s1,24(sp)
    800030ac:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800030ae:	fdc40593          	addi	a1,s0,-36
    800030b2:	4501                	li	a0,0
    800030b4:	00000097          	auipc	ra,0x0
    800030b8:	e58080e7          	jalr	-424(ra) # 80002f0c <argint>
  addr = myproc()->sz;
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	9ac080e7          	jalr	-1620(ra) # 80001a68 <myproc>
    800030c4:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800030c6:	fdc42503          	lw	a0,-36(s0)
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	d48080e7          	jalr	-696(ra) # 80001e12 <growproc>
    800030d2:	00054863          	bltz	a0,800030e2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800030d6:	8526                	mv	a0,s1
    800030d8:	70a2                	ld	ra,40(sp)
    800030da:	7402                	ld	s0,32(sp)
    800030dc:	64e2                	ld	s1,24(sp)
    800030de:	6145                	addi	sp,sp,48
    800030e0:	8082                	ret
    return -1;
    800030e2:	54fd                	li	s1,-1
    800030e4:	bfcd                	j	800030d6 <sys_sbrk+0x32>

00000000800030e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800030e6:	7139                	addi	sp,sp,-64
    800030e8:	fc06                	sd	ra,56(sp)
    800030ea:	f822                	sd	s0,48(sp)
    800030ec:	f04a                	sd	s2,32(sp)
    800030ee:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800030f0:	fcc40593          	addi	a1,s0,-52
    800030f4:	4501                	li	a0,0
    800030f6:	00000097          	auipc	ra,0x0
    800030fa:	e16080e7          	jalr	-490(ra) # 80002f0c <argint>
  acquire(&tickslock);
    800030fe:	00017517          	auipc	a0,0x17
    80003102:	a9250513          	addi	a0,a0,-1390 # 80019b90 <tickslock>
    80003106:	ffffe097          	auipc	ra,0xffffe
    8000310a:	b38080e7          	jalr	-1224(ra) # 80000c3e <acquire>
  ticks0 = ticks;
    8000310e:	00005917          	auipc	s2,0x5
    80003112:	7e692903          	lw	s2,2022(s2) # 800088f4 <ticks>
  while (ticks - ticks0 < n)
    80003116:	fcc42783          	lw	a5,-52(s0)
    8000311a:	c3b9                	beqz	a5,80003160 <sys_sleep+0x7a>
    8000311c:	f426                	sd	s1,40(sp)
    8000311e:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003120:	00017997          	auipc	s3,0x17
    80003124:	a7098993          	addi	s3,s3,-1424 # 80019b90 <tickslock>
    80003128:	00005497          	auipc	s1,0x5
    8000312c:	7cc48493          	addi	s1,s1,1996 # 800088f4 <ticks>
    if (killed(myproc()))
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	938080e7          	jalr	-1736(ra) # 80001a68 <myproc>
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	40a080e7          	jalr	1034(ra) # 80002542 <killed>
    80003140:	ed15                	bnez	a0,8000317c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003142:	85ce                	mv	a1,s3
    80003144:	8526                	mv	a0,s1
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	11a080e7          	jalr	282(ra) # 80002260 <sleep>
  while (ticks - ticks0 < n)
    8000314e:	409c                	lw	a5,0(s1)
    80003150:	412787bb          	subw	a5,a5,s2
    80003154:	fcc42703          	lw	a4,-52(s0)
    80003158:	fce7ece3          	bltu	a5,a4,80003130 <sys_sleep+0x4a>
    8000315c:	74a2                	ld	s1,40(sp)
    8000315e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003160:	00017517          	auipc	a0,0x17
    80003164:	a3050513          	addi	a0,a0,-1488 # 80019b90 <tickslock>
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	b86080e7          	jalr	-1146(ra) # 80000cee <release>
  return 0;
    80003170:	4501                	li	a0,0
}
    80003172:	70e2                	ld	ra,56(sp)
    80003174:	7442                	ld	s0,48(sp)
    80003176:	7902                	ld	s2,32(sp)
    80003178:	6121                	addi	sp,sp,64
    8000317a:	8082                	ret
      release(&tickslock);
    8000317c:	00017517          	auipc	a0,0x17
    80003180:	a1450513          	addi	a0,a0,-1516 # 80019b90 <tickslock>
    80003184:	ffffe097          	auipc	ra,0xffffe
    80003188:	b6a080e7          	jalr	-1174(ra) # 80000cee <release>
      return -1;
    8000318c:	557d                	li	a0,-1
    8000318e:	74a2                	ld	s1,40(sp)
    80003190:	69e2                	ld	s3,24(sp)
    80003192:	b7c5                	j	80003172 <sys_sleep+0x8c>

0000000080003194 <sys_kill>:

uint64
sys_kill(void)
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000319c:	fec40593          	addi	a1,s0,-20
    800031a0:	4501                	li	a0,0
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	d6a080e7          	jalr	-662(ra) # 80002f0c <argint>
  return kill(pid);
    800031aa:	fec42503          	lw	a0,-20(s0)
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	2f6080e7          	jalr	758(ra) # 800024a4 <kill>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	6105                	addi	sp,sp,32
    800031bc:	8082                	ret

00000000800031be <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031be:	1101                	addi	sp,sp,-32
    800031c0:	ec06                	sd	ra,24(sp)
    800031c2:	e822                	sd	s0,16(sp)
    800031c4:	e426                	sd	s1,8(sp)
    800031c6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031c8:	00017517          	auipc	a0,0x17
    800031cc:	9c850513          	addi	a0,a0,-1592 # 80019b90 <tickslock>
    800031d0:	ffffe097          	auipc	ra,0xffffe
    800031d4:	a6e080e7          	jalr	-1426(ra) # 80000c3e <acquire>
  xticks = ticks;
    800031d8:	00005497          	auipc	s1,0x5
    800031dc:	71c4a483          	lw	s1,1820(s1) # 800088f4 <ticks>
  release(&tickslock);
    800031e0:	00017517          	auipc	a0,0x17
    800031e4:	9b050513          	addi	a0,a0,-1616 # 80019b90 <tickslock>
    800031e8:	ffffe097          	auipc	ra,0xffffe
    800031ec:	b06080e7          	jalr	-1274(ra) # 80000cee <release>
  return xticks;
}
    800031f0:	02049513          	slli	a0,s1,0x20
    800031f4:	9101                	srli	a0,a0,0x20
    800031f6:	60e2                	ld	ra,24(sp)
    800031f8:	6442                	ld	s0,16(sp)
    800031fa:	64a2                	ld	s1,8(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret

0000000080003200 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003200:	715d                	addi	sp,sp,-80
    80003202:	e486                	sd	ra,72(sp)
    80003204:	e0a2                	sd	s0,64(sp)
    80003206:	fc26                	sd	s1,56(sp)
    80003208:	f84a                	sd	s2,48(sp)
    8000320a:	f44e                	sd	s3,40(sp)
    8000320c:	0880                	addi	s0,sp,80
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000320e:	fc840593          	addi	a1,s0,-56
    80003212:	4501                	li	a0,0
    80003214:	00000097          	auipc	ra,0x0
    80003218:	d18080e7          	jalr	-744(ra) # 80002f2c <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000321c:	fc040593          	addi	a1,s0,-64
    80003220:	4505                	li	a0,1
    80003222:	00000097          	auipc	ra,0x0
    80003226:	d0a080e7          	jalr	-758(ra) # 80002f2c <argaddr>
  argaddr(2, &addr2);
    8000322a:	fb840593          	addi	a1,s0,-72
    8000322e:	4509                	li	a0,2
    80003230:	00000097          	auipc	ra,0x0
    80003234:	cfc080e7          	jalr	-772(ra) # 80002f2c <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    80003238:	fb440993          	addi	s3,s0,-76
    8000323c:	fb040613          	addi	a2,s0,-80
    80003240:	85ce                	mv	a1,s3
    80003242:	fc843503          	ld	a0,-56(s0)
    80003246:	fffff097          	auipc	ra,0xfffff
    8000324a:	5b6080e7          	jalr	1462(ra) # 800027fc <waitx>
    8000324e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003250:	fffff097          	auipc	ra,0xfffff
    80003254:	818080e7          	jalr	-2024(ra) # 80001a68 <myproc>
    80003258:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000325a:	4691                	li	a3,4
    8000325c:	864e                	mv	a2,s3
    8000325e:	fc043583          	ld	a1,-64(s0)
    80003262:	6928                	ld	a0,80(a0)
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	4ac080e7          	jalr	1196(ra) # 80001710 <copyout>
    return -1;
    8000326c:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000326e:	00054f63          	bltz	a0,8000328c <sys_waitx+0x8c>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003272:	4691                	li	a3,4
    80003274:	fb040613          	addi	a2,s0,-80
    80003278:	fb843583          	ld	a1,-72(s0)
    8000327c:	68a8                	ld	a0,80(s1)
    8000327e:	ffffe097          	auipc	ra,0xffffe
    80003282:	492080e7          	jalr	1170(ra) # 80001710 <copyout>
    80003286:	00054b63          	bltz	a0,8000329c <sys_waitx+0x9c>
    return -1;
  return ret;
    8000328a:	87ca                	mv	a5,s2
}
    8000328c:	853e                	mv	a0,a5
    8000328e:	60a6                	ld	ra,72(sp)
    80003290:	6406                	ld	s0,64(sp)
    80003292:	74e2                	ld	s1,56(sp)
    80003294:	7942                	ld	s2,48(sp)
    80003296:	79a2                	ld	s3,40(sp)
    80003298:	6161                	addi	sp,sp,80
    8000329a:	8082                	ret
    return -1;
    8000329c:	57fd                	li	a5,-1
    8000329e:	b7fd                	j	8000328c <sys_waitx+0x8c>

00000000800032a0 <sys_getsyscount>:
uint64
sys_getsyscount(void)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	1000                	addi	s0,sp,32
  int num;
  argint(0, &num);
    800032a8:	fec40593          	addi	a1,s0,-20
    800032ac:	4501                	li	a0,0
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	c5e080e7          	jalr	-930(ra) # 80002f0c <argint>
  num=num+zerooo;
  num=num*oneee+zerooo;
  struct proc *p = myproc();
    800032b6:	ffffe097          	auipc	ra,0xffffe
    800032ba:	7b2080e7          	jalr	1970(ra) # 80001a68 <myproc>
  int count=0;
  count=count*oneee+zerooo;
  for(int i=0;i<32;i++){
    if(num==(1<<i)){
    800032be:	fec42603          	lw	a2,-20(s0)
  for(int i=0;i<32;i++){
    800032c2:	4781                	li	a5,0
    if(num==(1<<i)){
    800032c4:	4685                	li	a3,1
  for(int i=0;i<32;i++){
    800032c6:	02000593          	li	a1,32
    if(num==(1<<i)){
    800032ca:	00f6973b          	sllw	a4,a3,a5
    800032ce:	00c70763          	beq	a4,a2,800032dc <sys_getsyscount+0x3c>
  for(int i=0;i<32;i++){
    800032d2:	2785                	addiw	a5,a5,1
    800032d4:	feb79be3          	bne	a5,a1,800032ca <sys_getsyscount+0x2a>
  count=count*oneee+zerooo;
    800032d8:	4501                	li	a0,0
    800032da:	a809                	j	800032ec <sys_getsyscount+0x4c>
      
      count=p->syscall_counts[i];
    800032dc:	05878713          	addi	a4,a5,88
    800032e0:	070a                	slli	a4,a4,0x2
    800032e2:	953a                	add	a0,a0,a4
    800032e4:	4508                	lw	a0,8(a0)
      if(i==1)
    800032e6:	4705                	li	a4,1
    800032e8:	00e78663          	beq	a5,a4,800032f4 <sys_getsyscount+0x54>
      }
      break;
    }
  }
  return count;
}
    800032ec:	60e2                	ld	ra,24(sp)
    800032ee:	6442                	ld	s0,16(sp)
    800032f0:	6105                	addi	sp,sp,32
    800032f2:	8082                	ret
        count--;
    800032f4:	357d                	addiw	a0,a0,-1
    800032f6:	bfdd                	j	800032ec <sys_getsyscount+0x4c>

00000000800032f8 <sys_sigalarm>:
uint64
sys_sigalarm(void)
{
    800032f8:	1101                	addi	sp,sp,-32
    800032fa:	ec06                	sd	ra,24(sp)
    800032fc:	e822                	sd	s0,16(sp)
    800032fe:	1000                	addi	s0,sp,32
  int num;
  uint64 handler;
  argint(0,&num);
    80003300:	fec40593          	addi	a1,s0,-20
    80003304:	4501                	li	a0,0
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	c06080e7          	jalr	-1018(ra) # 80002f0c <argint>
  if(num<0)
    8000330e:	fec42783          	lw	a5,-20(s0)
  return -1;
    80003312:	557d                	li	a0,-1
  if(num<0)
    80003314:	0207c963          	bltz	a5,80003346 <sys_sigalarm+0x4e>
  argaddr(1,&handler);
    80003318:	fe040593          	addi	a1,s0,-32
    8000331c:	4505                	li	a0,1
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	c0e080e7          	jalr	-1010(ra) # 80002f2c <argaddr>
  struct proc* p=myproc();
    80003326:	ffffe097          	auipc	ra,0xffffe
    8000332a:	742080e7          	jalr	1858(ra) # 80001a68 <myproc>
  p->alaramflag=1;
    8000332e:	4785                	li	a5,1
    80003330:	20f52c23          	sw	a5,536(a0)
  p->handleraddress=handler;
    80003334:	fe043783          	ld	a5,-32(s0)
    80003338:	20f53423          	sd	a5,520(a0)
  p->alarmcount=num;
    8000333c:	fec42783          	lw	a5,-20(s0)
    80003340:	20f52023          	sw	a5,512(a0)
  // p->clockcyclepassed=0;
  return 0;
    80003344:	4501                	li	a0,0


}
    80003346:	60e2                	ld	ra,24(sp)
    80003348:	6442                	ld	s0,16(sp)
    8000334a:	6105                	addi	sp,sp,32
    8000334c:	8082                	ret

000000008000334e <sys_sigreturn>:
uint64 
sys_sigreturn(void){
    8000334e:	1101                	addi	sp,sp,-32
    80003350:	ec06                	sd	ra,24(sp)
    80003352:	e822                	sd	s0,16(sp)
    80003354:	e426                	sd	s1,8(sp)
    80003356:	1000                	addi	s0,sp,32
  struct proc * p=myproc();
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	710080e7          	jalr	1808(ra) # 80001a68 <myproc>
    80003360:	84aa                	mv	s1,a0
  p->alaramflag=1;
    80003362:	4785                	li	a5,1
    80003364:	20f52c23          	sw	a5,536(a0)
  p->clockcyclepassed=0;
    80003368:	1e053c23          	sd	zero,504(a0)
  // p->trapframe=p->svedtrapframe;
  memmove(p->trapframe,p->savedtrapframe,PGSIZE);
    8000336c:	6605                	lui	a2,0x1
    8000336e:	21053583          	ld	a1,528(a0)
    80003372:	6d28                	ld	a0,88(a0)
    80003374:	ffffe097          	auipc	ra,0xffffe
    80003378:	a26080e7          	jalr	-1498(ra) # 80000d9a <memmove>
  kfree(p->savedtrapframe);
    8000337c:	2104b503          	ld	a0,528(s1)
    80003380:	ffffd097          	auipc	ra,0xffffd
    80003384:	6cc080e7          	jalr	1740(ra) # 80000a4c <kfree>
  usertrapret();
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	6c6080e7          	jalr	1734(ra) # 80002a4e <usertrapret>
  return 0;
}
    80003390:	4501                	li	a0,0
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	64a2                	ld	s1,8(sp)
    80003398:	6105                	addi	sp,sp,32
    8000339a:	8082                	ret

000000008000339c <sys_settickets>:
int
sys_settickets(void)
{
    8000339c:	7179                	addi	sp,sp,-48
    8000339e:	f406                	sd	ra,40(sp)
    800033a0:	f022                	sd	s0,32(sp)
    800033a2:	ec26                	sd	s1,24(sp)
    800033a4:	1800                	addi	s0,sp,48
  int n;
  struct proc *p = myproc();  // Get the current process
    800033a6:	ffffe097          	auipc	ra,0xffffe
    800033aa:	6c2080e7          	jalr	1730(ra) # 80001a68 <myproc>
    800033ae:	84aa                	mv	s1,a0

  // Retrieve the argument (number of tickets) passed by the user
  argint(0, &n) ;  // Invalid ticket count
    800033b0:	fdc40593          	addi	a1,s0,-36
    800033b4:	4501                	li	a0,0
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	b56080e7          	jalr	-1194(ra) # 80002f0c <argint>
    // return -1;
  if(n<=0)
    800033be:	fdc42783          	lw	a5,-36(s0)
    800033c2:	02f05663          	blez	a5,800033ee <sys_settickets+0x52>
  return -1;
  // Set the ticket count for the current process
  acquire(&p->lock);
    800033c6:	8526                	mv	a0,s1
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	876080e7          	jalr	-1930(ra) # 80000c3e <acquire>
  p->tickets = n;
    800033d0:	fdc42783          	lw	a5,-36(s0)
    800033d4:	20f4ae23          	sw	a5,540(s1)
  release(&p->lock);
    800033d8:	8526                	mv	a0,s1
    800033da:	ffffe097          	auipc	ra,0xffffe
    800033de:	914080e7          	jalr	-1772(ra) # 80000cee <release>
  // printf("Process with PID %d has been assigned %d tickets\n", p->pid, n);
  
  return 0;  // Success
    800033e2:	4501                	li	a0,0
}
    800033e4:	70a2                	ld	ra,40(sp)
    800033e6:	7402                	ld	s0,32(sp)
    800033e8:	64e2                	ld	s1,24(sp)
    800033ea:	6145                	addi	sp,sp,48
    800033ec:	8082                	ret
  return -1;
    800033ee:	557d                	li	a0,-1
    800033f0:	bfd5                	j	800033e4 <sys_settickets+0x48>

00000000800033f2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033f2:	7179                	addi	sp,sp,-48
    800033f4:	f406                	sd	ra,40(sp)
    800033f6:	f022                	sd	s0,32(sp)
    800033f8:	ec26                	sd	s1,24(sp)
    800033fa:	e84a                	sd	s2,16(sp)
    800033fc:	e44e                	sd	s3,8(sp)
    800033fe:	e052                	sd	s4,0(sp)
    80003400:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003402:	00005597          	auipc	a1,0x5
    80003406:	fe658593          	addi	a1,a1,-26 # 800083e8 <etext+0x3e8>
    8000340a:	00016517          	auipc	a0,0x16
    8000340e:	79e50513          	addi	a0,a0,1950 # 80019ba8 <bcache>
    80003412:	ffffd097          	auipc	ra,0xffffd
    80003416:	798080e7          	jalr	1944(ra) # 80000baa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000341a:	0001e797          	auipc	a5,0x1e
    8000341e:	78e78793          	addi	a5,a5,1934 # 80021ba8 <bcache+0x8000>
    80003422:	0001f717          	auipc	a4,0x1f
    80003426:	9ee70713          	addi	a4,a4,-1554 # 80021e10 <bcache+0x8268>
    8000342a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000342e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003432:	00016497          	auipc	s1,0x16
    80003436:	78e48493          	addi	s1,s1,1934 # 80019bc0 <bcache+0x18>
    b->next = bcache.head.next;
    8000343a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000343c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000343e:	00005a17          	auipc	s4,0x5
    80003442:	fb2a0a13          	addi	s4,s4,-78 # 800083f0 <etext+0x3f0>
    b->next = bcache.head.next;
    80003446:	2b893783          	ld	a5,696(s2)
    8000344a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000344c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003450:	85d2                	mv	a1,s4
    80003452:	01048513          	addi	a0,s1,16
    80003456:	00001097          	auipc	ra,0x1
    8000345a:	4e4080e7          	jalr	1252(ra) # 8000493a <initsleeplock>
    bcache.head.next->prev = b;
    8000345e:	2b893783          	ld	a5,696(s2)
    80003462:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003464:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003468:	45848493          	addi	s1,s1,1112
    8000346c:	fd349de3          	bne	s1,s3,80003446 <binit+0x54>
  }
}
    80003470:	70a2                	ld	ra,40(sp)
    80003472:	7402                	ld	s0,32(sp)
    80003474:	64e2                	ld	s1,24(sp)
    80003476:	6942                	ld	s2,16(sp)
    80003478:	69a2                	ld	s3,8(sp)
    8000347a:	6a02                	ld	s4,0(sp)
    8000347c:	6145                	addi	sp,sp,48
    8000347e:	8082                	ret

0000000080003480 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
    80003490:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003492:	00016517          	auipc	a0,0x16
    80003496:	71650513          	addi	a0,a0,1814 # 80019ba8 <bcache>
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	7a4080e7          	jalr	1956(ra) # 80000c3e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034a2:	0001f497          	auipc	s1,0x1f
    800034a6:	9be4b483          	ld	s1,-1602(s1) # 80021e60 <bcache+0x82b8>
    800034aa:	0001f797          	auipc	a5,0x1f
    800034ae:	96678793          	addi	a5,a5,-1690 # 80021e10 <bcache+0x8268>
    800034b2:	02f48f63          	beq	s1,a5,800034f0 <bread+0x70>
    800034b6:	873e                	mv	a4,a5
    800034b8:	a021                	j	800034c0 <bread+0x40>
    800034ba:	68a4                	ld	s1,80(s1)
    800034bc:	02e48a63          	beq	s1,a4,800034f0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800034c0:	449c                	lw	a5,8(s1)
    800034c2:	ff279ce3          	bne	a5,s2,800034ba <bread+0x3a>
    800034c6:	44dc                	lw	a5,12(s1)
    800034c8:	ff3799e3          	bne	a5,s3,800034ba <bread+0x3a>
      b->refcnt++;
    800034cc:	40bc                	lw	a5,64(s1)
    800034ce:	2785                	addiw	a5,a5,1
    800034d0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034d2:	00016517          	auipc	a0,0x16
    800034d6:	6d650513          	addi	a0,a0,1750 # 80019ba8 <bcache>
    800034da:	ffffe097          	auipc	ra,0xffffe
    800034de:	814080e7          	jalr	-2028(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    800034e2:	01048513          	addi	a0,s1,16
    800034e6:	00001097          	auipc	ra,0x1
    800034ea:	48e080e7          	jalr	1166(ra) # 80004974 <acquiresleep>
      return b;
    800034ee:	a8b9                	j	8000354c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034f0:	0001f497          	auipc	s1,0x1f
    800034f4:	9684b483          	ld	s1,-1688(s1) # 80021e58 <bcache+0x82b0>
    800034f8:	0001f797          	auipc	a5,0x1f
    800034fc:	91878793          	addi	a5,a5,-1768 # 80021e10 <bcache+0x8268>
    80003500:	00f48863          	beq	s1,a5,80003510 <bread+0x90>
    80003504:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003506:	40bc                	lw	a5,64(s1)
    80003508:	cf81                	beqz	a5,80003520 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000350a:	64a4                	ld	s1,72(s1)
    8000350c:	fee49de3          	bne	s1,a4,80003506 <bread+0x86>
  panic("bget: no buffers");
    80003510:	00005517          	auipc	a0,0x5
    80003514:	ee850513          	addi	a0,a0,-280 # 800083f8 <etext+0x3f8>
    80003518:	ffffd097          	auipc	ra,0xffffd
    8000351c:	048080e7          	jalr	72(ra) # 80000560 <panic>
      b->dev = dev;
    80003520:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003524:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003528:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000352c:	4785                	li	a5,1
    8000352e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003530:	00016517          	auipc	a0,0x16
    80003534:	67850513          	addi	a0,a0,1656 # 80019ba8 <bcache>
    80003538:	ffffd097          	auipc	ra,0xffffd
    8000353c:	7b6080e7          	jalr	1974(ra) # 80000cee <release>
      acquiresleep(&b->lock);
    80003540:	01048513          	addi	a0,s1,16
    80003544:	00001097          	auipc	ra,0x1
    80003548:	430080e7          	jalr	1072(ra) # 80004974 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000354c:	409c                	lw	a5,0(s1)
    8000354e:	cb89                	beqz	a5,80003560 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003550:	8526                	mv	a0,s1
    80003552:	70a2                	ld	ra,40(sp)
    80003554:	7402                	ld	s0,32(sp)
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	6942                	ld	s2,16(sp)
    8000355a:	69a2                	ld	s3,8(sp)
    8000355c:	6145                	addi	sp,sp,48
    8000355e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003560:	4581                	li	a1,0
    80003562:	8526                	mv	a0,s1
    80003564:	00003097          	auipc	ra,0x3
    80003568:	104080e7          	jalr	260(ra) # 80006668 <virtio_disk_rw>
    b->valid = 1;
    8000356c:	4785                	li	a5,1
    8000356e:	c09c                	sw	a5,0(s1)
  return b;
    80003570:	b7c5                	j	80003550 <bread+0xd0>

0000000080003572 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003572:	1101                	addi	sp,sp,-32
    80003574:	ec06                	sd	ra,24(sp)
    80003576:	e822                	sd	s0,16(sp)
    80003578:	e426                	sd	s1,8(sp)
    8000357a:	1000                	addi	s0,sp,32
    8000357c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000357e:	0541                	addi	a0,a0,16
    80003580:	00001097          	auipc	ra,0x1
    80003584:	48e080e7          	jalr	1166(ra) # 80004a0e <holdingsleep>
    80003588:	cd01                	beqz	a0,800035a0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000358a:	4585                	li	a1,1
    8000358c:	8526                	mv	a0,s1
    8000358e:	00003097          	auipc	ra,0x3
    80003592:	0da080e7          	jalr	218(ra) # 80006668 <virtio_disk_rw>
}
    80003596:	60e2                	ld	ra,24(sp)
    80003598:	6442                	ld	s0,16(sp)
    8000359a:	64a2                	ld	s1,8(sp)
    8000359c:	6105                	addi	sp,sp,32
    8000359e:	8082                	ret
    panic("bwrite");
    800035a0:	00005517          	auipc	a0,0x5
    800035a4:	e7050513          	addi	a0,a0,-400 # 80008410 <etext+0x410>
    800035a8:	ffffd097          	auipc	ra,0xffffd
    800035ac:	fb8080e7          	jalr	-72(ra) # 80000560 <panic>

00000000800035b0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035b0:	1101                	addi	sp,sp,-32
    800035b2:	ec06                	sd	ra,24(sp)
    800035b4:	e822                	sd	s0,16(sp)
    800035b6:	e426                	sd	s1,8(sp)
    800035b8:	e04a                	sd	s2,0(sp)
    800035ba:	1000                	addi	s0,sp,32
    800035bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035be:	01050913          	addi	s2,a0,16
    800035c2:	854a                	mv	a0,s2
    800035c4:	00001097          	auipc	ra,0x1
    800035c8:	44a080e7          	jalr	1098(ra) # 80004a0e <holdingsleep>
    800035cc:	c535                	beqz	a0,80003638 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800035ce:	854a                	mv	a0,s2
    800035d0:	00001097          	auipc	ra,0x1
    800035d4:	3fa080e7          	jalr	1018(ra) # 800049ca <releasesleep>

  acquire(&bcache.lock);
    800035d8:	00016517          	auipc	a0,0x16
    800035dc:	5d050513          	addi	a0,a0,1488 # 80019ba8 <bcache>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	65e080e7          	jalr	1630(ra) # 80000c3e <acquire>
  b->refcnt--;
    800035e8:	40bc                	lw	a5,64(s1)
    800035ea:	37fd                	addiw	a5,a5,-1
    800035ec:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035ee:	e79d                	bnez	a5,8000361c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035f0:	68b8                	ld	a4,80(s1)
    800035f2:	64bc                	ld	a5,72(s1)
    800035f4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800035f6:	68b8                	ld	a4,80(s1)
    800035f8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035fa:	0001e797          	auipc	a5,0x1e
    800035fe:	5ae78793          	addi	a5,a5,1454 # 80021ba8 <bcache+0x8000>
    80003602:	2b87b703          	ld	a4,696(a5)
    80003606:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003608:	0001f717          	auipc	a4,0x1f
    8000360c:	80870713          	addi	a4,a4,-2040 # 80021e10 <bcache+0x8268>
    80003610:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003612:	2b87b703          	ld	a4,696(a5)
    80003616:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003618:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000361c:	00016517          	auipc	a0,0x16
    80003620:	58c50513          	addi	a0,a0,1420 # 80019ba8 <bcache>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	6ca080e7          	jalr	1738(ra) # 80000cee <release>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6902                	ld	s2,0(sp)
    80003634:	6105                	addi	sp,sp,32
    80003636:	8082                	ret
    panic("brelse");
    80003638:	00005517          	auipc	a0,0x5
    8000363c:	de050513          	addi	a0,a0,-544 # 80008418 <etext+0x418>
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	f20080e7          	jalr	-224(ra) # 80000560 <panic>

0000000080003648 <bpin>:

void
bpin(struct buf *b) {
    80003648:	1101                	addi	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	e426                	sd	s1,8(sp)
    80003650:	1000                	addi	s0,sp,32
    80003652:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003654:	00016517          	auipc	a0,0x16
    80003658:	55450513          	addi	a0,a0,1364 # 80019ba8 <bcache>
    8000365c:	ffffd097          	auipc	ra,0xffffd
    80003660:	5e2080e7          	jalr	1506(ra) # 80000c3e <acquire>
  b->refcnt++;
    80003664:	40bc                	lw	a5,64(s1)
    80003666:	2785                	addiw	a5,a5,1
    80003668:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000366a:	00016517          	auipc	a0,0x16
    8000366e:	53e50513          	addi	a0,a0,1342 # 80019ba8 <bcache>
    80003672:	ffffd097          	auipc	ra,0xffffd
    80003676:	67c080e7          	jalr	1660(ra) # 80000cee <release>
}
    8000367a:	60e2                	ld	ra,24(sp)
    8000367c:	6442                	ld	s0,16(sp)
    8000367e:	64a2                	ld	s1,8(sp)
    80003680:	6105                	addi	sp,sp,32
    80003682:	8082                	ret

0000000080003684 <bunpin>:

void
bunpin(struct buf *b) {
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	1000                	addi	s0,sp,32
    8000368e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003690:	00016517          	auipc	a0,0x16
    80003694:	51850513          	addi	a0,a0,1304 # 80019ba8 <bcache>
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	5a6080e7          	jalr	1446(ra) # 80000c3e <acquire>
  b->refcnt--;
    800036a0:	40bc                	lw	a5,64(s1)
    800036a2:	37fd                	addiw	a5,a5,-1
    800036a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036a6:	00016517          	auipc	a0,0x16
    800036aa:	50250513          	addi	a0,a0,1282 # 80019ba8 <bcache>
    800036ae:	ffffd097          	auipc	ra,0xffffd
    800036b2:	640080e7          	jalr	1600(ra) # 80000cee <release>
}
    800036b6:	60e2                	ld	ra,24(sp)
    800036b8:	6442                	ld	s0,16(sp)
    800036ba:	64a2                	ld	s1,8(sp)
    800036bc:	6105                	addi	sp,sp,32
    800036be:	8082                	ret

00000000800036c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036c0:	1101                	addi	sp,sp,-32
    800036c2:	ec06                	sd	ra,24(sp)
    800036c4:	e822                	sd	s0,16(sp)
    800036c6:	e426                	sd	s1,8(sp)
    800036c8:	e04a                	sd	s2,0(sp)
    800036ca:	1000                	addi	s0,sp,32
    800036cc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800036ce:	00d5d79b          	srliw	a5,a1,0xd
    800036d2:	0001f597          	auipc	a1,0x1f
    800036d6:	bb25a583          	lw	a1,-1102(a1) # 80022284 <sb+0x1c>
    800036da:	9dbd                	addw	a1,a1,a5
    800036dc:	00000097          	auipc	ra,0x0
    800036e0:	da4080e7          	jalr	-604(ra) # 80003480 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800036e4:	0074f713          	andi	a4,s1,7
    800036e8:	4785                	li	a5,1
    800036ea:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800036ee:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800036f0:	90d9                	srli	s1,s1,0x36
    800036f2:	00950733          	add	a4,a0,s1
    800036f6:	05874703          	lbu	a4,88(a4)
    800036fa:	00e7f6b3          	and	a3,a5,a4
    800036fe:	c69d                	beqz	a3,8000372c <bfree+0x6c>
    80003700:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003702:	94aa                	add	s1,s1,a0
    80003704:	fff7c793          	not	a5,a5
    80003708:	8f7d                	and	a4,a4,a5
    8000370a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000370e:	00001097          	auipc	ra,0x1
    80003712:	148080e7          	jalr	328(ra) # 80004856 <log_write>
  brelse(bp);
    80003716:	854a                	mv	a0,s2
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	e98080e7          	jalr	-360(ra) # 800035b0 <brelse>
}
    80003720:	60e2                	ld	ra,24(sp)
    80003722:	6442                	ld	s0,16(sp)
    80003724:	64a2                	ld	s1,8(sp)
    80003726:	6902                	ld	s2,0(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret
    panic("freeing free block");
    8000372c:	00005517          	auipc	a0,0x5
    80003730:	cf450513          	addi	a0,a0,-780 # 80008420 <etext+0x420>
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	e2c080e7          	jalr	-468(ra) # 80000560 <panic>

000000008000373c <balloc>:
{
    8000373c:	715d                	addi	sp,sp,-80
    8000373e:	e486                	sd	ra,72(sp)
    80003740:	e0a2                	sd	s0,64(sp)
    80003742:	fc26                	sd	s1,56(sp)
    80003744:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003746:	0001f797          	auipc	a5,0x1f
    8000374a:	b267a783          	lw	a5,-1242(a5) # 8002226c <sb+0x4>
    8000374e:	10078863          	beqz	a5,8000385e <balloc+0x122>
    80003752:	f84a                	sd	s2,48(sp)
    80003754:	f44e                	sd	s3,40(sp)
    80003756:	f052                	sd	s4,32(sp)
    80003758:	ec56                	sd	s5,24(sp)
    8000375a:	e85a                	sd	s6,16(sp)
    8000375c:	e45e                	sd	s7,8(sp)
    8000375e:	e062                	sd	s8,0(sp)
    80003760:	8baa                	mv	s7,a0
    80003762:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003764:	0001fb17          	auipc	s6,0x1f
    80003768:	b04b0b13          	addi	s6,s6,-1276 # 80022268 <sb>
      m = 1 << (bi % 8);
    8000376c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000376e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003770:	6c09                	lui	s8,0x2
    80003772:	a049                	j	800037f4 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003774:	97ca                	add	a5,a5,s2
    80003776:	8e55                	or	a2,a2,a3
    80003778:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000377c:	854a                	mv	a0,s2
    8000377e:	00001097          	auipc	ra,0x1
    80003782:	0d8080e7          	jalr	216(ra) # 80004856 <log_write>
        brelse(bp);
    80003786:	854a                	mv	a0,s2
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	e28080e7          	jalr	-472(ra) # 800035b0 <brelse>
  bp = bread(dev, bno);
    80003790:	85a6                	mv	a1,s1
    80003792:	855e                	mv	a0,s7
    80003794:	00000097          	auipc	ra,0x0
    80003798:	cec080e7          	jalr	-788(ra) # 80003480 <bread>
    8000379c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000379e:	40000613          	li	a2,1024
    800037a2:	4581                	li	a1,0
    800037a4:	05850513          	addi	a0,a0,88
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	58e080e7          	jalr	1422(ra) # 80000d36 <memset>
  log_write(bp);
    800037b0:	854a                	mv	a0,s2
    800037b2:	00001097          	auipc	ra,0x1
    800037b6:	0a4080e7          	jalr	164(ra) # 80004856 <log_write>
  brelse(bp);
    800037ba:	854a                	mv	a0,s2
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	df4080e7          	jalr	-524(ra) # 800035b0 <brelse>
}
    800037c4:	7942                	ld	s2,48(sp)
    800037c6:	79a2                	ld	s3,40(sp)
    800037c8:	7a02                	ld	s4,32(sp)
    800037ca:	6ae2                	ld	s5,24(sp)
    800037cc:	6b42                	ld	s6,16(sp)
    800037ce:	6ba2                	ld	s7,8(sp)
    800037d0:	6c02                	ld	s8,0(sp)
}
    800037d2:	8526                	mv	a0,s1
    800037d4:	60a6                	ld	ra,72(sp)
    800037d6:	6406                	ld	s0,64(sp)
    800037d8:	74e2                	ld	s1,56(sp)
    800037da:	6161                	addi	sp,sp,80
    800037dc:	8082                	ret
    brelse(bp);
    800037de:	854a                	mv	a0,s2
    800037e0:	00000097          	auipc	ra,0x0
    800037e4:	dd0080e7          	jalr	-560(ra) # 800035b0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037e8:	015c0abb          	addw	s5,s8,s5
    800037ec:	004b2783          	lw	a5,4(s6)
    800037f0:	06faf063          	bgeu	s5,a5,80003850 <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    800037f4:	41fad79b          	sraiw	a5,s5,0x1f
    800037f8:	0137d79b          	srliw	a5,a5,0x13
    800037fc:	015787bb          	addw	a5,a5,s5
    80003800:	40d7d79b          	sraiw	a5,a5,0xd
    80003804:	01cb2583          	lw	a1,28(s6)
    80003808:	9dbd                	addw	a1,a1,a5
    8000380a:	855e                	mv	a0,s7
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	c74080e7          	jalr	-908(ra) # 80003480 <bread>
    80003814:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003816:	004b2503          	lw	a0,4(s6)
    8000381a:	84d6                	mv	s1,s5
    8000381c:	4701                	li	a4,0
    8000381e:	fca4f0e3          	bgeu	s1,a0,800037de <balloc+0xa2>
      m = 1 << (bi % 8);
    80003822:	00777693          	andi	a3,a4,7
    80003826:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000382a:	41f7579b          	sraiw	a5,a4,0x1f
    8000382e:	01d7d79b          	srliw	a5,a5,0x1d
    80003832:	9fb9                	addw	a5,a5,a4
    80003834:	4037d79b          	sraiw	a5,a5,0x3
    80003838:	00f90633          	add	a2,s2,a5
    8000383c:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003840:	00c6f5b3          	and	a1,a3,a2
    80003844:	d985                	beqz	a1,80003774 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003846:	2705                	addiw	a4,a4,1
    80003848:	2485                	addiw	s1,s1,1
    8000384a:	fd471ae3          	bne	a4,s4,8000381e <balloc+0xe2>
    8000384e:	bf41                	j	800037de <balloc+0xa2>
    80003850:	7942                	ld	s2,48(sp)
    80003852:	79a2                	ld	s3,40(sp)
    80003854:	7a02                	ld	s4,32(sp)
    80003856:	6ae2                	ld	s5,24(sp)
    80003858:	6b42                	ld	s6,16(sp)
    8000385a:	6ba2                	ld	s7,8(sp)
    8000385c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000385e:	00005517          	auipc	a0,0x5
    80003862:	bda50513          	addi	a0,a0,-1062 # 80008438 <etext+0x438>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	d44080e7          	jalr	-700(ra) # 800005aa <printf>
  return 0;
    8000386e:	4481                	li	s1,0
    80003870:	b78d                	j	800037d2 <balloc+0x96>

0000000080003872 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003872:	7179                	addi	sp,sp,-48
    80003874:	f406                	sd	ra,40(sp)
    80003876:	f022                	sd	s0,32(sp)
    80003878:	ec26                	sd	s1,24(sp)
    8000387a:	e84a                	sd	s2,16(sp)
    8000387c:	e44e                	sd	s3,8(sp)
    8000387e:	1800                	addi	s0,sp,48
    80003880:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003882:	47ad                	li	a5,11
    80003884:	02b7e563          	bltu	a5,a1,800038ae <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003888:	02059793          	slli	a5,a1,0x20
    8000388c:	01e7d593          	srli	a1,a5,0x1e
    80003890:	00b504b3          	add	s1,a0,a1
    80003894:	0504a903          	lw	s2,80(s1)
    80003898:	06091b63          	bnez	s2,8000390e <bmap+0x9c>
      addr = balloc(ip->dev);
    8000389c:	4108                	lw	a0,0(a0)
    8000389e:	00000097          	auipc	ra,0x0
    800038a2:	e9e080e7          	jalr	-354(ra) # 8000373c <balloc>
    800038a6:	892a                	mv	s2,a0
      if(addr == 0)
    800038a8:	c13d                	beqz	a0,8000390e <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    800038aa:	c8a8                	sw	a0,80(s1)
    800038ac:	a08d                	j	8000390e <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038ae:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800038b2:	0ff00793          	li	a5,255
    800038b6:	0897e363          	bltu	a5,s1,8000393c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800038ba:	08052903          	lw	s2,128(a0)
    800038be:	00091d63          	bnez	s2,800038d8 <bmap+0x66>
      addr = balloc(ip->dev);
    800038c2:	4108                	lw	a0,0(a0)
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	e78080e7          	jalr	-392(ra) # 8000373c <balloc>
    800038cc:	892a                	mv	s2,a0
      if(addr == 0)
    800038ce:	c121                	beqz	a0,8000390e <bmap+0x9c>
    800038d0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800038d2:	08a9a023          	sw	a0,128(s3)
    800038d6:	a011                	j	800038da <bmap+0x68>
    800038d8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800038da:	85ca                	mv	a1,s2
    800038dc:	0009a503          	lw	a0,0(s3)
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	ba0080e7          	jalr	-1120(ra) # 80003480 <bread>
    800038e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038ea:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038ee:	02049713          	slli	a4,s1,0x20
    800038f2:	01e75593          	srli	a1,a4,0x1e
    800038f6:	00b784b3          	add	s1,a5,a1
    800038fa:	0004a903          	lw	s2,0(s1)
    800038fe:	02090063          	beqz	s2,8000391e <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003902:	8552                	mv	a0,s4
    80003904:	00000097          	auipc	ra,0x0
    80003908:	cac080e7          	jalr	-852(ra) # 800035b0 <brelse>
    return addr;
    8000390c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000390e:	854a                	mv	a0,s2
    80003910:	70a2                	ld	ra,40(sp)
    80003912:	7402                	ld	s0,32(sp)
    80003914:	64e2                	ld	s1,24(sp)
    80003916:	6942                	ld	s2,16(sp)
    80003918:	69a2                	ld	s3,8(sp)
    8000391a:	6145                	addi	sp,sp,48
    8000391c:	8082                	ret
      addr = balloc(ip->dev);
    8000391e:	0009a503          	lw	a0,0(s3)
    80003922:	00000097          	auipc	ra,0x0
    80003926:	e1a080e7          	jalr	-486(ra) # 8000373c <balloc>
    8000392a:	892a                	mv	s2,a0
      if(addr){
    8000392c:	d979                	beqz	a0,80003902 <bmap+0x90>
        a[bn] = addr;
    8000392e:	c088                	sw	a0,0(s1)
        log_write(bp);
    80003930:	8552                	mv	a0,s4
    80003932:	00001097          	auipc	ra,0x1
    80003936:	f24080e7          	jalr	-220(ra) # 80004856 <log_write>
    8000393a:	b7e1                	j	80003902 <bmap+0x90>
    8000393c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000393e:	00005517          	auipc	a0,0x5
    80003942:	b1250513          	addi	a0,a0,-1262 # 80008450 <etext+0x450>
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	c1a080e7          	jalr	-998(ra) # 80000560 <panic>

000000008000394e <iget>:
{
    8000394e:	7179                	addi	sp,sp,-48
    80003950:	f406                	sd	ra,40(sp)
    80003952:	f022                	sd	s0,32(sp)
    80003954:	ec26                	sd	s1,24(sp)
    80003956:	e84a                	sd	s2,16(sp)
    80003958:	e44e                	sd	s3,8(sp)
    8000395a:	e052                	sd	s4,0(sp)
    8000395c:	1800                	addi	s0,sp,48
    8000395e:	89aa                	mv	s3,a0
    80003960:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003962:	0001f517          	auipc	a0,0x1f
    80003966:	92650513          	addi	a0,a0,-1754 # 80022288 <itable>
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	2d4080e7          	jalr	724(ra) # 80000c3e <acquire>
  empty = 0;
    80003972:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003974:	0001f497          	auipc	s1,0x1f
    80003978:	92c48493          	addi	s1,s1,-1748 # 800222a0 <itable+0x18>
    8000397c:	00020697          	auipc	a3,0x20
    80003980:	3b468693          	addi	a3,a3,948 # 80023d30 <log>
    80003984:	a039                	j	80003992 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003986:	02090b63          	beqz	s2,800039bc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000398a:	08848493          	addi	s1,s1,136
    8000398e:	02d48a63          	beq	s1,a3,800039c2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003992:	449c                	lw	a5,8(s1)
    80003994:	fef059e3          	blez	a5,80003986 <iget+0x38>
    80003998:	4098                	lw	a4,0(s1)
    8000399a:	ff3716e3          	bne	a4,s3,80003986 <iget+0x38>
    8000399e:	40d8                	lw	a4,4(s1)
    800039a0:	ff4713e3          	bne	a4,s4,80003986 <iget+0x38>
      ip->ref++;
    800039a4:	2785                	addiw	a5,a5,1
    800039a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039a8:	0001f517          	auipc	a0,0x1f
    800039ac:	8e050513          	addi	a0,a0,-1824 # 80022288 <itable>
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	33e080e7          	jalr	830(ra) # 80000cee <release>
      return ip;
    800039b8:	8926                	mv	s2,s1
    800039ba:	a03d                	j	800039e8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039bc:	f7f9                	bnez	a5,8000398a <iget+0x3c>
      empty = ip;
    800039be:	8926                	mv	s2,s1
    800039c0:	b7e9                	j	8000398a <iget+0x3c>
  if(empty == 0)
    800039c2:	02090c63          	beqz	s2,800039fa <iget+0xac>
  ip->dev = dev;
    800039c6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800039ca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800039ce:	4785                	li	a5,1
    800039d0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800039d4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800039d8:	0001f517          	auipc	a0,0x1f
    800039dc:	8b050513          	addi	a0,a0,-1872 # 80022288 <itable>
    800039e0:	ffffd097          	auipc	ra,0xffffd
    800039e4:	30e080e7          	jalr	782(ra) # 80000cee <release>
}
    800039e8:	854a                	mv	a0,s2
    800039ea:	70a2                	ld	ra,40(sp)
    800039ec:	7402                	ld	s0,32(sp)
    800039ee:	64e2                	ld	s1,24(sp)
    800039f0:	6942                	ld	s2,16(sp)
    800039f2:	69a2                	ld	s3,8(sp)
    800039f4:	6a02                	ld	s4,0(sp)
    800039f6:	6145                	addi	sp,sp,48
    800039f8:	8082                	ret
    panic("iget: no inodes");
    800039fa:	00005517          	auipc	a0,0x5
    800039fe:	a6e50513          	addi	a0,a0,-1426 # 80008468 <etext+0x468>
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	b5e080e7          	jalr	-1186(ra) # 80000560 <panic>

0000000080003a0a <fsinit>:
fsinit(int dev) {
    80003a0a:	7179                	addi	sp,sp,-48
    80003a0c:	f406                	sd	ra,40(sp)
    80003a0e:	f022                	sd	s0,32(sp)
    80003a10:	ec26                	sd	s1,24(sp)
    80003a12:	e84a                	sd	s2,16(sp)
    80003a14:	e44e                	sd	s3,8(sp)
    80003a16:	1800                	addi	s0,sp,48
    80003a18:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a1a:	4585                	li	a1,1
    80003a1c:	00000097          	auipc	ra,0x0
    80003a20:	a64080e7          	jalr	-1436(ra) # 80003480 <bread>
    80003a24:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a26:	0001f997          	auipc	s3,0x1f
    80003a2a:	84298993          	addi	s3,s3,-1982 # 80022268 <sb>
    80003a2e:	02000613          	li	a2,32
    80003a32:	05850593          	addi	a1,a0,88
    80003a36:	854e                	mv	a0,s3
    80003a38:	ffffd097          	auipc	ra,0xffffd
    80003a3c:	362080e7          	jalr	866(ra) # 80000d9a <memmove>
  brelse(bp);
    80003a40:	8526                	mv	a0,s1
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	b6e080e7          	jalr	-1170(ra) # 800035b0 <brelse>
  if(sb.magic != FSMAGIC)
    80003a4a:	0009a703          	lw	a4,0(s3)
    80003a4e:	102037b7          	lui	a5,0x10203
    80003a52:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a56:	02f71263          	bne	a4,a5,80003a7a <fsinit+0x70>
  initlog(dev, &sb);
    80003a5a:	0001f597          	auipc	a1,0x1f
    80003a5e:	80e58593          	addi	a1,a1,-2034 # 80022268 <sb>
    80003a62:	854a                	mv	a0,s2
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	b7c080e7          	jalr	-1156(ra) # 800045e0 <initlog>
}
    80003a6c:	70a2                	ld	ra,40(sp)
    80003a6e:	7402                	ld	s0,32(sp)
    80003a70:	64e2                	ld	s1,24(sp)
    80003a72:	6942                	ld	s2,16(sp)
    80003a74:	69a2                	ld	s3,8(sp)
    80003a76:	6145                	addi	sp,sp,48
    80003a78:	8082                	ret
    panic("invalid file system");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	9fe50513          	addi	a0,a0,-1538 # 80008478 <etext+0x478>
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	ade080e7          	jalr	-1314(ra) # 80000560 <panic>

0000000080003a8a <iinit>:
{
    80003a8a:	7179                	addi	sp,sp,-48
    80003a8c:	f406                	sd	ra,40(sp)
    80003a8e:	f022                	sd	s0,32(sp)
    80003a90:	ec26                	sd	s1,24(sp)
    80003a92:	e84a                	sd	s2,16(sp)
    80003a94:	e44e                	sd	s3,8(sp)
    80003a96:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a98:	00005597          	auipc	a1,0x5
    80003a9c:	9f858593          	addi	a1,a1,-1544 # 80008490 <etext+0x490>
    80003aa0:	0001e517          	auipc	a0,0x1e
    80003aa4:	7e850513          	addi	a0,a0,2024 # 80022288 <itable>
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	102080e7          	jalr	258(ra) # 80000baa <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ab0:	0001f497          	auipc	s1,0x1f
    80003ab4:	80048493          	addi	s1,s1,-2048 # 800222b0 <itable+0x28>
    80003ab8:	00020997          	auipc	s3,0x20
    80003abc:	28898993          	addi	s3,s3,648 # 80023d40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ac0:	00005917          	auipc	s2,0x5
    80003ac4:	9d890913          	addi	s2,s2,-1576 # 80008498 <etext+0x498>
    80003ac8:	85ca                	mv	a1,s2
    80003aca:	8526                	mv	a0,s1
    80003acc:	00001097          	auipc	ra,0x1
    80003ad0:	e6e080e7          	jalr	-402(ra) # 8000493a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003ad4:	08848493          	addi	s1,s1,136
    80003ad8:	ff3498e3          	bne	s1,s3,80003ac8 <iinit+0x3e>
}
    80003adc:	70a2                	ld	ra,40(sp)
    80003ade:	7402                	ld	s0,32(sp)
    80003ae0:	64e2                	ld	s1,24(sp)
    80003ae2:	6942                	ld	s2,16(sp)
    80003ae4:	69a2                	ld	s3,8(sp)
    80003ae6:	6145                	addi	sp,sp,48
    80003ae8:	8082                	ret

0000000080003aea <ialloc>:
{
    80003aea:	7139                	addi	sp,sp,-64
    80003aec:	fc06                	sd	ra,56(sp)
    80003aee:	f822                	sd	s0,48(sp)
    80003af0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003af2:	0001e717          	auipc	a4,0x1e
    80003af6:	78272703          	lw	a4,1922(a4) # 80022274 <sb+0xc>
    80003afa:	4785                	li	a5,1
    80003afc:	06e7f463          	bgeu	a5,a4,80003b64 <ialloc+0x7a>
    80003b00:	f426                	sd	s1,40(sp)
    80003b02:	f04a                	sd	s2,32(sp)
    80003b04:	ec4e                	sd	s3,24(sp)
    80003b06:	e852                	sd	s4,16(sp)
    80003b08:	e456                	sd	s5,8(sp)
    80003b0a:	e05a                	sd	s6,0(sp)
    80003b0c:	8aaa                	mv	s5,a0
    80003b0e:	8b2e                	mv	s6,a1
    80003b10:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003b12:	0001ea17          	auipc	s4,0x1e
    80003b16:	756a0a13          	addi	s4,s4,1878 # 80022268 <sb>
    80003b1a:	00495593          	srli	a1,s2,0x4
    80003b1e:	018a2783          	lw	a5,24(s4)
    80003b22:	9dbd                	addw	a1,a1,a5
    80003b24:	8556                	mv	a0,s5
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	95a080e7          	jalr	-1702(ra) # 80003480 <bread>
    80003b2e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b30:	05850993          	addi	s3,a0,88
    80003b34:	00f97793          	andi	a5,s2,15
    80003b38:	079a                	slli	a5,a5,0x6
    80003b3a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b3c:	00099783          	lh	a5,0(s3)
    80003b40:	cf9d                	beqz	a5,80003b7e <ialloc+0x94>
    brelse(bp);
    80003b42:	00000097          	auipc	ra,0x0
    80003b46:	a6e080e7          	jalr	-1426(ra) # 800035b0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b4a:	0905                	addi	s2,s2,1
    80003b4c:	00ca2703          	lw	a4,12(s4)
    80003b50:	0009079b          	sext.w	a5,s2
    80003b54:	fce7e3e3          	bltu	a5,a4,80003b1a <ialloc+0x30>
    80003b58:	74a2                	ld	s1,40(sp)
    80003b5a:	7902                	ld	s2,32(sp)
    80003b5c:	69e2                	ld	s3,24(sp)
    80003b5e:	6a42                	ld	s4,16(sp)
    80003b60:	6aa2                	ld	s5,8(sp)
    80003b62:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003b64:	00005517          	auipc	a0,0x5
    80003b68:	93c50513          	addi	a0,a0,-1732 # 800084a0 <etext+0x4a0>
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	a3e080e7          	jalr	-1474(ra) # 800005aa <printf>
  return 0;
    80003b74:	4501                	li	a0,0
}
    80003b76:	70e2                	ld	ra,56(sp)
    80003b78:	7442                	ld	s0,48(sp)
    80003b7a:	6121                	addi	sp,sp,64
    80003b7c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b7e:	04000613          	li	a2,64
    80003b82:	4581                	li	a1,0
    80003b84:	854e                	mv	a0,s3
    80003b86:	ffffd097          	auipc	ra,0xffffd
    80003b8a:	1b0080e7          	jalr	432(ra) # 80000d36 <memset>
      dip->type = type;
    80003b8e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b92:	8526                	mv	a0,s1
    80003b94:	00001097          	auipc	ra,0x1
    80003b98:	cc2080e7          	jalr	-830(ra) # 80004856 <log_write>
      brelse(bp);
    80003b9c:	8526                	mv	a0,s1
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	a12080e7          	jalr	-1518(ra) # 800035b0 <brelse>
      return iget(dev, inum);
    80003ba6:	0009059b          	sext.w	a1,s2
    80003baa:	8556                	mv	a0,s5
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	da2080e7          	jalr	-606(ra) # 8000394e <iget>
    80003bb4:	74a2                	ld	s1,40(sp)
    80003bb6:	7902                	ld	s2,32(sp)
    80003bb8:	69e2                	ld	s3,24(sp)
    80003bba:	6a42                	ld	s4,16(sp)
    80003bbc:	6aa2                	ld	s5,8(sp)
    80003bbe:	6b02                	ld	s6,0(sp)
    80003bc0:	bf5d                	j	80003b76 <ialloc+0x8c>

0000000080003bc2 <iupdate>:
{
    80003bc2:	1101                	addi	sp,sp,-32
    80003bc4:	ec06                	sd	ra,24(sp)
    80003bc6:	e822                	sd	s0,16(sp)
    80003bc8:	e426                	sd	s1,8(sp)
    80003bca:	e04a                	sd	s2,0(sp)
    80003bcc:	1000                	addi	s0,sp,32
    80003bce:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003bd0:	415c                	lw	a5,4(a0)
    80003bd2:	0047d79b          	srliw	a5,a5,0x4
    80003bd6:	0001e597          	auipc	a1,0x1e
    80003bda:	6aa5a583          	lw	a1,1706(a1) # 80022280 <sb+0x18>
    80003bde:	9dbd                	addw	a1,a1,a5
    80003be0:	4108                	lw	a0,0(a0)
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	89e080e7          	jalr	-1890(ra) # 80003480 <bread>
    80003bea:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003bec:	05850793          	addi	a5,a0,88
    80003bf0:	40d8                	lw	a4,4(s1)
    80003bf2:	8b3d                	andi	a4,a4,15
    80003bf4:	071a                	slli	a4,a4,0x6
    80003bf6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003bf8:	04449703          	lh	a4,68(s1)
    80003bfc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c00:	04649703          	lh	a4,70(s1)
    80003c04:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c08:	04849703          	lh	a4,72(s1)
    80003c0c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c10:	04a49703          	lh	a4,74(s1)
    80003c14:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c18:	44f8                	lw	a4,76(s1)
    80003c1a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c1c:	03400613          	li	a2,52
    80003c20:	05048593          	addi	a1,s1,80
    80003c24:	00c78513          	addi	a0,a5,12
    80003c28:	ffffd097          	auipc	ra,0xffffd
    80003c2c:	172080e7          	jalr	370(ra) # 80000d9a <memmove>
  log_write(bp);
    80003c30:	854a                	mv	a0,s2
    80003c32:	00001097          	auipc	ra,0x1
    80003c36:	c24080e7          	jalr	-988(ra) # 80004856 <log_write>
  brelse(bp);
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	974080e7          	jalr	-1676(ra) # 800035b0 <brelse>
}
    80003c44:	60e2                	ld	ra,24(sp)
    80003c46:	6442                	ld	s0,16(sp)
    80003c48:	64a2                	ld	s1,8(sp)
    80003c4a:	6902                	ld	s2,0(sp)
    80003c4c:	6105                	addi	sp,sp,32
    80003c4e:	8082                	ret

0000000080003c50 <idup>:
{
    80003c50:	1101                	addi	sp,sp,-32
    80003c52:	ec06                	sd	ra,24(sp)
    80003c54:	e822                	sd	s0,16(sp)
    80003c56:	e426                	sd	s1,8(sp)
    80003c58:	1000                	addi	s0,sp,32
    80003c5a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c5c:	0001e517          	auipc	a0,0x1e
    80003c60:	62c50513          	addi	a0,a0,1580 # 80022288 <itable>
    80003c64:	ffffd097          	auipc	ra,0xffffd
    80003c68:	fda080e7          	jalr	-38(ra) # 80000c3e <acquire>
  ip->ref++;
    80003c6c:	449c                	lw	a5,8(s1)
    80003c6e:	2785                	addiw	a5,a5,1
    80003c70:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c72:	0001e517          	auipc	a0,0x1e
    80003c76:	61650513          	addi	a0,a0,1558 # 80022288 <itable>
    80003c7a:	ffffd097          	auipc	ra,0xffffd
    80003c7e:	074080e7          	jalr	116(ra) # 80000cee <release>
}
    80003c82:	8526                	mv	a0,s1
    80003c84:	60e2                	ld	ra,24(sp)
    80003c86:	6442                	ld	s0,16(sp)
    80003c88:	64a2                	ld	s1,8(sp)
    80003c8a:	6105                	addi	sp,sp,32
    80003c8c:	8082                	ret

0000000080003c8e <ilock>:
{
    80003c8e:	1101                	addi	sp,sp,-32
    80003c90:	ec06                	sd	ra,24(sp)
    80003c92:	e822                	sd	s0,16(sp)
    80003c94:	e426                	sd	s1,8(sp)
    80003c96:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c98:	c10d                	beqz	a0,80003cba <ilock+0x2c>
    80003c9a:	84aa                	mv	s1,a0
    80003c9c:	451c                	lw	a5,8(a0)
    80003c9e:	00f05e63          	blez	a5,80003cba <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003ca2:	0541                	addi	a0,a0,16
    80003ca4:	00001097          	auipc	ra,0x1
    80003ca8:	cd0080e7          	jalr	-816(ra) # 80004974 <acquiresleep>
  if(ip->valid == 0){
    80003cac:	40bc                	lw	a5,64(s1)
    80003cae:	cf99                	beqz	a5,80003ccc <ilock+0x3e>
}
    80003cb0:	60e2                	ld	ra,24(sp)
    80003cb2:	6442                	ld	s0,16(sp)
    80003cb4:	64a2                	ld	s1,8(sp)
    80003cb6:	6105                	addi	sp,sp,32
    80003cb8:	8082                	ret
    80003cba:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003cbc:	00004517          	auipc	a0,0x4
    80003cc0:	7fc50513          	addi	a0,a0,2044 # 800084b8 <etext+0x4b8>
    80003cc4:	ffffd097          	auipc	ra,0xffffd
    80003cc8:	89c080e7          	jalr	-1892(ra) # 80000560 <panic>
    80003ccc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cce:	40dc                	lw	a5,4(s1)
    80003cd0:	0047d79b          	srliw	a5,a5,0x4
    80003cd4:	0001e597          	auipc	a1,0x1e
    80003cd8:	5ac5a583          	lw	a1,1452(a1) # 80022280 <sb+0x18>
    80003cdc:	9dbd                	addw	a1,a1,a5
    80003cde:	4088                	lw	a0,0(s1)
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	7a0080e7          	jalr	1952(ra) # 80003480 <bread>
    80003ce8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cea:	05850593          	addi	a1,a0,88
    80003cee:	40dc                	lw	a5,4(s1)
    80003cf0:	8bbd                	andi	a5,a5,15
    80003cf2:	079a                	slli	a5,a5,0x6
    80003cf4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003cf6:	00059783          	lh	a5,0(a1)
    80003cfa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003cfe:	00259783          	lh	a5,2(a1)
    80003d02:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d06:	00459783          	lh	a5,4(a1)
    80003d0a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d0e:	00659783          	lh	a5,6(a1)
    80003d12:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d16:	459c                	lw	a5,8(a1)
    80003d18:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d1a:	03400613          	li	a2,52
    80003d1e:	05b1                	addi	a1,a1,12
    80003d20:	05048513          	addi	a0,s1,80
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	076080e7          	jalr	118(ra) # 80000d9a <memmove>
    brelse(bp);
    80003d2c:	854a                	mv	a0,s2
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	882080e7          	jalr	-1918(ra) # 800035b0 <brelse>
    ip->valid = 1;
    80003d36:	4785                	li	a5,1
    80003d38:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d3a:	04449783          	lh	a5,68(s1)
    80003d3e:	c399                	beqz	a5,80003d44 <ilock+0xb6>
    80003d40:	6902                	ld	s2,0(sp)
    80003d42:	b7bd                	j	80003cb0 <ilock+0x22>
      panic("ilock: no type");
    80003d44:	00004517          	auipc	a0,0x4
    80003d48:	77c50513          	addi	a0,a0,1916 # 800084c0 <etext+0x4c0>
    80003d4c:	ffffd097          	auipc	ra,0xffffd
    80003d50:	814080e7          	jalr	-2028(ra) # 80000560 <panic>

0000000080003d54 <iunlock>:
{
    80003d54:	1101                	addi	sp,sp,-32
    80003d56:	ec06                	sd	ra,24(sp)
    80003d58:	e822                	sd	s0,16(sp)
    80003d5a:	e426                	sd	s1,8(sp)
    80003d5c:	e04a                	sd	s2,0(sp)
    80003d5e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d60:	c905                	beqz	a0,80003d90 <iunlock+0x3c>
    80003d62:	84aa                	mv	s1,a0
    80003d64:	01050913          	addi	s2,a0,16
    80003d68:	854a                	mv	a0,s2
    80003d6a:	00001097          	auipc	ra,0x1
    80003d6e:	ca4080e7          	jalr	-860(ra) # 80004a0e <holdingsleep>
    80003d72:	cd19                	beqz	a0,80003d90 <iunlock+0x3c>
    80003d74:	449c                	lw	a5,8(s1)
    80003d76:	00f05d63          	blez	a5,80003d90 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d7a:	854a                	mv	a0,s2
    80003d7c:	00001097          	auipc	ra,0x1
    80003d80:	c4e080e7          	jalr	-946(ra) # 800049ca <releasesleep>
}
    80003d84:	60e2                	ld	ra,24(sp)
    80003d86:	6442                	ld	s0,16(sp)
    80003d88:	64a2                	ld	s1,8(sp)
    80003d8a:	6902                	ld	s2,0(sp)
    80003d8c:	6105                	addi	sp,sp,32
    80003d8e:	8082                	ret
    panic("iunlock");
    80003d90:	00004517          	auipc	a0,0x4
    80003d94:	74050513          	addi	a0,a0,1856 # 800084d0 <etext+0x4d0>
    80003d98:	ffffc097          	auipc	ra,0xffffc
    80003d9c:	7c8080e7          	jalr	1992(ra) # 80000560 <panic>

0000000080003da0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003da0:	7179                	addi	sp,sp,-48
    80003da2:	f406                	sd	ra,40(sp)
    80003da4:	f022                	sd	s0,32(sp)
    80003da6:	ec26                	sd	s1,24(sp)
    80003da8:	e84a                	sd	s2,16(sp)
    80003daa:	e44e                	sd	s3,8(sp)
    80003dac:	1800                	addi	s0,sp,48
    80003dae:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003db0:	05050493          	addi	s1,a0,80
    80003db4:	08050913          	addi	s2,a0,128
    80003db8:	a021                	j	80003dc0 <itrunc+0x20>
    80003dba:	0491                	addi	s1,s1,4
    80003dbc:	01248d63          	beq	s1,s2,80003dd6 <itrunc+0x36>
    if(ip->addrs[i]){
    80003dc0:	408c                	lw	a1,0(s1)
    80003dc2:	dde5                	beqz	a1,80003dba <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003dc4:	0009a503          	lw	a0,0(s3)
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	8f8080e7          	jalr	-1800(ra) # 800036c0 <bfree>
      ip->addrs[i] = 0;
    80003dd0:	0004a023          	sw	zero,0(s1)
    80003dd4:	b7dd                	j	80003dba <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003dd6:	0809a583          	lw	a1,128(s3)
    80003dda:	ed99                	bnez	a1,80003df8 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ddc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003de0:	854e                	mv	a0,s3
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	de0080e7          	jalr	-544(ra) # 80003bc2 <iupdate>
}
    80003dea:	70a2                	ld	ra,40(sp)
    80003dec:	7402                	ld	s0,32(sp)
    80003dee:	64e2                	ld	s1,24(sp)
    80003df0:	6942                	ld	s2,16(sp)
    80003df2:	69a2                	ld	s3,8(sp)
    80003df4:	6145                	addi	sp,sp,48
    80003df6:	8082                	ret
    80003df8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003dfa:	0009a503          	lw	a0,0(s3)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	682080e7          	jalr	1666(ra) # 80003480 <bread>
    80003e06:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e08:	05850493          	addi	s1,a0,88
    80003e0c:	45850913          	addi	s2,a0,1112
    80003e10:	a021                	j	80003e18 <itrunc+0x78>
    80003e12:	0491                	addi	s1,s1,4
    80003e14:	01248b63          	beq	s1,s2,80003e2a <itrunc+0x8a>
      if(a[j])
    80003e18:	408c                	lw	a1,0(s1)
    80003e1a:	dde5                	beqz	a1,80003e12 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e1c:	0009a503          	lw	a0,0(s3)
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	8a0080e7          	jalr	-1888(ra) # 800036c0 <bfree>
    80003e28:	b7ed                	j	80003e12 <itrunc+0x72>
    brelse(bp);
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	784080e7          	jalr	1924(ra) # 800035b0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e34:	0809a583          	lw	a1,128(s3)
    80003e38:	0009a503          	lw	a0,0(s3)
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	884080e7          	jalr	-1916(ra) # 800036c0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e44:	0809a023          	sw	zero,128(s3)
    80003e48:	6a02                	ld	s4,0(sp)
    80003e4a:	bf49                	j	80003ddc <itrunc+0x3c>

0000000080003e4c <iput>:
{
    80003e4c:	1101                	addi	sp,sp,-32
    80003e4e:	ec06                	sd	ra,24(sp)
    80003e50:	e822                	sd	s0,16(sp)
    80003e52:	e426                	sd	s1,8(sp)
    80003e54:	1000                	addi	s0,sp,32
    80003e56:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e58:	0001e517          	auipc	a0,0x1e
    80003e5c:	43050513          	addi	a0,a0,1072 # 80022288 <itable>
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	dde080e7          	jalr	-546(ra) # 80000c3e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e68:	4498                	lw	a4,8(s1)
    80003e6a:	4785                	li	a5,1
    80003e6c:	02f70263          	beq	a4,a5,80003e90 <iput+0x44>
  ip->ref--;
    80003e70:	449c                	lw	a5,8(s1)
    80003e72:	37fd                	addiw	a5,a5,-1
    80003e74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e76:	0001e517          	auipc	a0,0x1e
    80003e7a:	41250513          	addi	a0,a0,1042 # 80022288 <itable>
    80003e7e:	ffffd097          	auipc	ra,0xffffd
    80003e82:	e70080e7          	jalr	-400(ra) # 80000cee <release>
}
    80003e86:	60e2                	ld	ra,24(sp)
    80003e88:	6442                	ld	s0,16(sp)
    80003e8a:	64a2                	ld	s1,8(sp)
    80003e8c:	6105                	addi	sp,sp,32
    80003e8e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e90:	40bc                	lw	a5,64(s1)
    80003e92:	dff9                	beqz	a5,80003e70 <iput+0x24>
    80003e94:	04a49783          	lh	a5,74(s1)
    80003e98:	ffe1                	bnez	a5,80003e70 <iput+0x24>
    80003e9a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003e9c:	01048913          	addi	s2,s1,16
    80003ea0:	854a                	mv	a0,s2
    80003ea2:	00001097          	auipc	ra,0x1
    80003ea6:	ad2080e7          	jalr	-1326(ra) # 80004974 <acquiresleep>
    release(&itable.lock);
    80003eaa:	0001e517          	auipc	a0,0x1e
    80003eae:	3de50513          	addi	a0,a0,990 # 80022288 <itable>
    80003eb2:	ffffd097          	auipc	ra,0xffffd
    80003eb6:	e3c080e7          	jalr	-452(ra) # 80000cee <release>
    itrunc(ip);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	ee4080e7          	jalr	-284(ra) # 80003da0 <itrunc>
    ip->type = 0;
    80003ec4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	cf8080e7          	jalr	-776(ra) # 80003bc2 <iupdate>
    ip->valid = 0;
    80003ed2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ed6:	854a                	mv	a0,s2
    80003ed8:	00001097          	auipc	ra,0x1
    80003edc:	af2080e7          	jalr	-1294(ra) # 800049ca <releasesleep>
    acquire(&itable.lock);
    80003ee0:	0001e517          	auipc	a0,0x1e
    80003ee4:	3a850513          	addi	a0,a0,936 # 80022288 <itable>
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	d56080e7          	jalr	-682(ra) # 80000c3e <acquire>
    80003ef0:	6902                	ld	s2,0(sp)
    80003ef2:	bfbd                	j	80003e70 <iput+0x24>

0000000080003ef4 <iunlockput>:
{
    80003ef4:	1101                	addi	sp,sp,-32
    80003ef6:	ec06                	sd	ra,24(sp)
    80003ef8:	e822                	sd	s0,16(sp)
    80003efa:	e426                	sd	s1,8(sp)
    80003efc:	1000                	addi	s0,sp,32
    80003efe:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	e54080e7          	jalr	-428(ra) # 80003d54 <iunlock>
  iput(ip);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	f42080e7          	jalr	-190(ra) # 80003e4c <iput>
}
    80003f12:	60e2                	ld	ra,24(sp)
    80003f14:	6442                	ld	s0,16(sp)
    80003f16:	64a2                	ld	s1,8(sp)
    80003f18:	6105                	addi	sp,sp,32
    80003f1a:	8082                	ret

0000000080003f1c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f1c:	1141                	addi	sp,sp,-16
    80003f1e:	e406                	sd	ra,8(sp)
    80003f20:	e022                	sd	s0,0(sp)
    80003f22:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f24:	411c                	lw	a5,0(a0)
    80003f26:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f28:	415c                	lw	a5,4(a0)
    80003f2a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f2c:	04451783          	lh	a5,68(a0)
    80003f30:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f34:	04a51783          	lh	a5,74(a0)
    80003f38:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f3c:	04c56783          	lwu	a5,76(a0)
    80003f40:	e99c                	sd	a5,16(a1)
}
    80003f42:	60a2                	ld	ra,8(sp)
    80003f44:	6402                	ld	s0,0(sp)
    80003f46:	0141                	addi	sp,sp,16
    80003f48:	8082                	ret

0000000080003f4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f4a:	457c                	lw	a5,76(a0)
    80003f4c:	10d7e063          	bltu	a5,a3,8000404c <readi+0x102>
{
    80003f50:	7159                	addi	sp,sp,-112
    80003f52:	f486                	sd	ra,104(sp)
    80003f54:	f0a2                	sd	s0,96(sp)
    80003f56:	eca6                	sd	s1,88(sp)
    80003f58:	e0d2                	sd	s4,64(sp)
    80003f5a:	fc56                	sd	s5,56(sp)
    80003f5c:	f85a                	sd	s6,48(sp)
    80003f5e:	f45e                	sd	s7,40(sp)
    80003f60:	1880                	addi	s0,sp,112
    80003f62:	8b2a                	mv	s6,a0
    80003f64:	8bae                	mv	s7,a1
    80003f66:	8a32                	mv	s4,a2
    80003f68:	84b6                	mv	s1,a3
    80003f6a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f6c:	9f35                	addw	a4,a4,a3
    return 0;
    80003f6e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f70:	0cd76563          	bltu	a4,a3,8000403a <readi+0xf0>
    80003f74:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003f76:	00e7f463          	bgeu	a5,a4,80003f7e <readi+0x34>
    n = ip->size - off;
    80003f7a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f7e:	0a0a8563          	beqz	s5,80004028 <readi+0xde>
    80003f82:	e8ca                	sd	s2,80(sp)
    80003f84:	f062                	sd	s8,32(sp)
    80003f86:	ec66                	sd	s9,24(sp)
    80003f88:	e86a                	sd	s10,16(sp)
    80003f8a:	e46e                	sd	s11,8(sp)
    80003f8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f8e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f92:	5c7d                	li	s8,-1
    80003f94:	a82d                	j	80003fce <readi+0x84>
    80003f96:	020d1d93          	slli	s11,s10,0x20
    80003f9a:	020ddd93          	srli	s11,s11,0x20
    80003f9e:	05890613          	addi	a2,s2,88
    80003fa2:	86ee                	mv	a3,s11
    80003fa4:	963e                	add	a2,a2,a5
    80003fa6:	85d2                	mv	a1,s4
    80003fa8:	855e                	mv	a0,s7
    80003faa:	ffffe097          	auipc	ra,0xffffe
    80003fae:	6f2080e7          	jalr	1778(ra) # 8000269c <either_copyout>
    80003fb2:	05850963          	beq	a0,s8,80004004 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fb6:	854a                	mv	a0,s2
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	5f8080e7          	jalr	1528(ra) # 800035b0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fc0:	013d09bb          	addw	s3,s10,s3
    80003fc4:	009d04bb          	addw	s1,s10,s1
    80003fc8:	9a6e                	add	s4,s4,s11
    80003fca:	0559f963          	bgeu	s3,s5,8000401c <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80003fce:	00a4d59b          	srliw	a1,s1,0xa
    80003fd2:	855a                	mv	a0,s6
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	89e080e7          	jalr	-1890(ra) # 80003872 <bmap>
    80003fdc:	85aa                	mv	a1,a0
    if(addr == 0)
    80003fde:	c539                	beqz	a0,8000402c <readi+0xe2>
    bp = bread(ip->dev, addr);
    80003fe0:	000b2503          	lw	a0,0(s6)
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	49c080e7          	jalr	1180(ra) # 80003480 <bread>
    80003fec:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fee:	3ff4f793          	andi	a5,s1,1023
    80003ff2:	40fc873b          	subw	a4,s9,a5
    80003ff6:	413a86bb          	subw	a3,s5,s3
    80003ffa:	8d3a                	mv	s10,a4
    80003ffc:	f8e6fde3          	bgeu	a3,a4,80003f96 <readi+0x4c>
    80004000:	8d36                	mv	s10,a3
    80004002:	bf51                	j	80003f96 <readi+0x4c>
      brelse(bp);
    80004004:	854a                	mv	a0,s2
    80004006:	fffff097          	auipc	ra,0xfffff
    8000400a:	5aa080e7          	jalr	1450(ra) # 800035b0 <brelse>
      tot = -1;
    8000400e:	59fd                	li	s3,-1
      break;
    80004010:	6946                	ld	s2,80(sp)
    80004012:	7c02                	ld	s8,32(sp)
    80004014:	6ce2                	ld	s9,24(sp)
    80004016:	6d42                	ld	s10,16(sp)
    80004018:	6da2                	ld	s11,8(sp)
    8000401a:	a831                	j	80004036 <readi+0xec>
    8000401c:	6946                	ld	s2,80(sp)
    8000401e:	7c02                	ld	s8,32(sp)
    80004020:	6ce2                	ld	s9,24(sp)
    80004022:	6d42                	ld	s10,16(sp)
    80004024:	6da2                	ld	s11,8(sp)
    80004026:	a801                	j	80004036 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004028:	89d6                	mv	s3,s5
    8000402a:	a031                	j	80004036 <readi+0xec>
    8000402c:	6946                	ld	s2,80(sp)
    8000402e:	7c02                	ld	s8,32(sp)
    80004030:	6ce2                	ld	s9,24(sp)
    80004032:	6d42                	ld	s10,16(sp)
    80004034:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004036:	854e                	mv	a0,s3
    80004038:	69a6                	ld	s3,72(sp)
}
    8000403a:	70a6                	ld	ra,104(sp)
    8000403c:	7406                	ld	s0,96(sp)
    8000403e:	64e6                	ld	s1,88(sp)
    80004040:	6a06                	ld	s4,64(sp)
    80004042:	7ae2                	ld	s5,56(sp)
    80004044:	7b42                	ld	s6,48(sp)
    80004046:	7ba2                	ld	s7,40(sp)
    80004048:	6165                	addi	sp,sp,112
    8000404a:	8082                	ret
    return 0;
    8000404c:	4501                	li	a0,0
}
    8000404e:	8082                	ret

0000000080004050 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004050:	457c                	lw	a5,76(a0)
    80004052:	10d7e963          	bltu	a5,a3,80004164 <writei+0x114>
{
    80004056:	7159                	addi	sp,sp,-112
    80004058:	f486                	sd	ra,104(sp)
    8000405a:	f0a2                	sd	s0,96(sp)
    8000405c:	e8ca                	sd	s2,80(sp)
    8000405e:	e0d2                	sd	s4,64(sp)
    80004060:	fc56                	sd	s5,56(sp)
    80004062:	f85a                	sd	s6,48(sp)
    80004064:	f45e                	sd	s7,40(sp)
    80004066:	1880                	addi	s0,sp,112
    80004068:	8aaa                	mv	s5,a0
    8000406a:	8bae                	mv	s7,a1
    8000406c:	8a32                	mv	s4,a2
    8000406e:	8936                	mv	s2,a3
    80004070:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004072:	00e687bb          	addw	a5,a3,a4
    80004076:	0ed7e963          	bltu	a5,a3,80004168 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000407a:	00043737          	lui	a4,0x43
    8000407e:	0ef76763          	bltu	a4,a5,8000416c <writei+0x11c>
    80004082:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004084:	0c0b0863          	beqz	s6,80004154 <writei+0x104>
    80004088:	eca6                	sd	s1,88(sp)
    8000408a:	f062                	sd	s8,32(sp)
    8000408c:	ec66                	sd	s9,24(sp)
    8000408e:	e86a                	sd	s10,16(sp)
    80004090:	e46e                	sd	s11,8(sp)
    80004092:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004094:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004098:	5c7d                	li	s8,-1
    8000409a:	a091                	j	800040de <writei+0x8e>
    8000409c:	020d1d93          	slli	s11,s10,0x20
    800040a0:	020ddd93          	srli	s11,s11,0x20
    800040a4:	05848513          	addi	a0,s1,88
    800040a8:	86ee                	mv	a3,s11
    800040aa:	8652                	mv	a2,s4
    800040ac:	85de                	mv	a1,s7
    800040ae:	953e                	add	a0,a0,a5
    800040b0:	ffffe097          	auipc	ra,0xffffe
    800040b4:	642080e7          	jalr	1602(ra) # 800026f2 <either_copyin>
    800040b8:	05850e63          	beq	a0,s8,80004114 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800040bc:	8526                	mv	a0,s1
    800040be:	00000097          	auipc	ra,0x0
    800040c2:	798080e7          	jalr	1944(ra) # 80004856 <log_write>
    brelse(bp);
    800040c6:	8526                	mv	a0,s1
    800040c8:	fffff097          	auipc	ra,0xfffff
    800040cc:	4e8080e7          	jalr	1256(ra) # 800035b0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040d0:	013d09bb          	addw	s3,s10,s3
    800040d4:	012d093b          	addw	s2,s10,s2
    800040d8:	9a6e                	add	s4,s4,s11
    800040da:	0569f263          	bgeu	s3,s6,8000411e <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800040de:	00a9559b          	srliw	a1,s2,0xa
    800040e2:	8556                	mv	a0,s5
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	78e080e7          	jalr	1934(ra) # 80003872 <bmap>
    800040ec:	85aa                	mv	a1,a0
    if(addr == 0)
    800040ee:	c905                	beqz	a0,8000411e <writei+0xce>
    bp = bread(ip->dev, addr);
    800040f0:	000aa503          	lw	a0,0(s5)
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	38c080e7          	jalr	908(ra) # 80003480 <bread>
    800040fc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040fe:	3ff97793          	andi	a5,s2,1023
    80004102:	40fc873b          	subw	a4,s9,a5
    80004106:	413b06bb          	subw	a3,s6,s3
    8000410a:	8d3a                	mv	s10,a4
    8000410c:	f8e6f8e3          	bgeu	a3,a4,8000409c <writei+0x4c>
    80004110:	8d36                	mv	s10,a3
    80004112:	b769                	j	8000409c <writei+0x4c>
      brelse(bp);
    80004114:	8526                	mv	a0,s1
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	49a080e7          	jalr	1178(ra) # 800035b0 <brelse>
  }

  if(off > ip->size)
    8000411e:	04caa783          	lw	a5,76(s5)
    80004122:	0327fb63          	bgeu	a5,s2,80004158 <writei+0x108>
    ip->size = off;
    80004126:	052aa623          	sw	s2,76(s5)
    8000412a:	64e6                	ld	s1,88(sp)
    8000412c:	7c02                	ld	s8,32(sp)
    8000412e:	6ce2                	ld	s9,24(sp)
    80004130:	6d42                	ld	s10,16(sp)
    80004132:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004134:	8556                	mv	a0,s5
    80004136:	00000097          	auipc	ra,0x0
    8000413a:	a8c080e7          	jalr	-1396(ra) # 80003bc2 <iupdate>

  return tot;
    8000413e:	854e                	mv	a0,s3
    80004140:	69a6                	ld	s3,72(sp)
}
    80004142:	70a6                	ld	ra,104(sp)
    80004144:	7406                	ld	s0,96(sp)
    80004146:	6946                	ld	s2,80(sp)
    80004148:	6a06                	ld	s4,64(sp)
    8000414a:	7ae2                	ld	s5,56(sp)
    8000414c:	7b42                	ld	s6,48(sp)
    8000414e:	7ba2                	ld	s7,40(sp)
    80004150:	6165                	addi	sp,sp,112
    80004152:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004154:	89da                	mv	s3,s6
    80004156:	bff9                	j	80004134 <writei+0xe4>
    80004158:	64e6                	ld	s1,88(sp)
    8000415a:	7c02                	ld	s8,32(sp)
    8000415c:	6ce2                	ld	s9,24(sp)
    8000415e:	6d42                	ld	s10,16(sp)
    80004160:	6da2                	ld	s11,8(sp)
    80004162:	bfc9                	j	80004134 <writei+0xe4>
    return -1;
    80004164:	557d                	li	a0,-1
}
    80004166:	8082                	ret
    return -1;
    80004168:	557d                	li	a0,-1
    8000416a:	bfe1                	j	80004142 <writei+0xf2>
    return -1;
    8000416c:	557d                	li	a0,-1
    8000416e:	bfd1                	j	80004142 <writei+0xf2>

0000000080004170 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004170:	1141                	addi	sp,sp,-16
    80004172:	e406                	sd	ra,8(sp)
    80004174:	e022                	sd	s0,0(sp)
    80004176:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004178:	4639                	li	a2,14
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	c98080e7          	jalr	-872(ra) # 80000e12 <strncmp>
}
    80004182:	60a2                	ld	ra,8(sp)
    80004184:	6402                	ld	s0,0(sp)
    80004186:	0141                	addi	sp,sp,16
    80004188:	8082                	ret

000000008000418a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000418a:	711d                	addi	sp,sp,-96
    8000418c:	ec86                	sd	ra,88(sp)
    8000418e:	e8a2                	sd	s0,80(sp)
    80004190:	e4a6                	sd	s1,72(sp)
    80004192:	e0ca                	sd	s2,64(sp)
    80004194:	fc4e                	sd	s3,56(sp)
    80004196:	f852                	sd	s4,48(sp)
    80004198:	f456                	sd	s5,40(sp)
    8000419a:	f05a                	sd	s6,32(sp)
    8000419c:	ec5e                	sd	s7,24(sp)
    8000419e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041a0:	04451703          	lh	a4,68(a0)
    800041a4:	4785                	li	a5,1
    800041a6:	00f71f63          	bne	a4,a5,800041c4 <dirlookup+0x3a>
    800041aa:	892a                	mv	s2,a0
    800041ac:	8aae                	mv	s5,a1
    800041ae:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800041b0:	457c                	lw	a5,76(a0)
    800041b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041b4:	fa040a13          	addi	s4,s0,-96
    800041b8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800041ba:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800041be:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041c0:	e79d                	bnez	a5,800041ee <dirlookup+0x64>
    800041c2:	a88d                	j	80004234 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800041c4:	00004517          	auipc	a0,0x4
    800041c8:	31450513          	addi	a0,a0,788 # 800084d8 <etext+0x4d8>
    800041cc:	ffffc097          	auipc	ra,0xffffc
    800041d0:	394080e7          	jalr	916(ra) # 80000560 <panic>
      panic("dirlookup read");
    800041d4:	00004517          	auipc	a0,0x4
    800041d8:	31c50513          	addi	a0,a0,796 # 800084f0 <etext+0x4f0>
    800041dc:	ffffc097          	auipc	ra,0xffffc
    800041e0:	384080e7          	jalr	900(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041e4:	24c1                	addiw	s1,s1,16
    800041e6:	04c92783          	lw	a5,76(s2)
    800041ea:	04f4f463          	bgeu	s1,a5,80004232 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ee:	874e                	mv	a4,s3
    800041f0:	86a6                	mv	a3,s1
    800041f2:	8652                	mv	a2,s4
    800041f4:	4581                	li	a1,0
    800041f6:	854a                	mv	a0,s2
    800041f8:	00000097          	auipc	ra,0x0
    800041fc:	d52080e7          	jalr	-686(ra) # 80003f4a <readi>
    80004200:	fd351ae3          	bne	a0,s3,800041d4 <dirlookup+0x4a>
    if(de.inum == 0)
    80004204:	fa045783          	lhu	a5,-96(s0)
    80004208:	dff1                	beqz	a5,800041e4 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000420a:	85da                	mv	a1,s6
    8000420c:	8556                	mv	a0,s5
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	f62080e7          	jalr	-158(ra) # 80004170 <namecmp>
    80004216:	f579                	bnez	a0,800041e4 <dirlookup+0x5a>
      if(poff)
    80004218:	000b8463          	beqz	s7,80004220 <dirlookup+0x96>
        *poff = off;
    8000421c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004220:	fa045583          	lhu	a1,-96(s0)
    80004224:	00092503          	lw	a0,0(s2)
    80004228:	fffff097          	auipc	ra,0xfffff
    8000422c:	726080e7          	jalr	1830(ra) # 8000394e <iget>
    80004230:	a011                	j	80004234 <dirlookup+0xaa>
  return 0;
    80004232:	4501                	li	a0,0
}
    80004234:	60e6                	ld	ra,88(sp)
    80004236:	6446                	ld	s0,80(sp)
    80004238:	64a6                	ld	s1,72(sp)
    8000423a:	6906                	ld	s2,64(sp)
    8000423c:	79e2                	ld	s3,56(sp)
    8000423e:	7a42                	ld	s4,48(sp)
    80004240:	7aa2                	ld	s5,40(sp)
    80004242:	7b02                	ld	s6,32(sp)
    80004244:	6be2                	ld	s7,24(sp)
    80004246:	6125                	addi	sp,sp,96
    80004248:	8082                	ret

000000008000424a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000424a:	711d                	addi	sp,sp,-96
    8000424c:	ec86                	sd	ra,88(sp)
    8000424e:	e8a2                	sd	s0,80(sp)
    80004250:	e4a6                	sd	s1,72(sp)
    80004252:	e0ca                	sd	s2,64(sp)
    80004254:	fc4e                	sd	s3,56(sp)
    80004256:	f852                	sd	s4,48(sp)
    80004258:	f456                	sd	s5,40(sp)
    8000425a:	f05a                	sd	s6,32(sp)
    8000425c:	ec5e                	sd	s7,24(sp)
    8000425e:	e862                	sd	s8,16(sp)
    80004260:	e466                	sd	s9,8(sp)
    80004262:	e06a                	sd	s10,0(sp)
    80004264:	1080                	addi	s0,sp,96
    80004266:	84aa                	mv	s1,a0
    80004268:	8b2e                	mv	s6,a1
    8000426a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000426c:	00054703          	lbu	a4,0(a0)
    80004270:	02f00793          	li	a5,47
    80004274:	02f70363          	beq	a4,a5,8000429a <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	7f0080e7          	jalr	2032(ra) # 80001a68 <myproc>
    80004280:	15053503          	ld	a0,336(a0)
    80004284:	00000097          	auipc	ra,0x0
    80004288:	9cc080e7          	jalr	-1588(ra) # 80003c50 <idup>
    8000428c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000428e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004292:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004294:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004296:	4b85                	li	s7,1
    80004298:	a87d                	j	80004356 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000429a:	4585                	li	a1,1
    8000429c:	852e                	mv	a0,a1
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	6b0080e7          	jalr	1712(ra) # 8000394e <iget>
    800042a6:	8a2a                	mv	s4,a0
    800042a8:	b7dd                	j	8000428e <namex+0x44>
      iunlockput(ip);
    800042aa:	8552                	mv	a0,s4
    800042ac:	00000097          	auipc	ra,0x0
    800042b0:	c48080e7          	jalr	-952(ra) # 80003ef4 <iunlockput>
      return 0;
    800042b4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800042b6:	8552                	mv	a0,s4
    800042b8:	60e6                	ld	ra,88(sp)
    800042ba:	6446                	ld	s0,80(sp)
    800042bc:	64a6                	ld	s1,72(sp)
    800042be:	6906                	ld	s2,64(sp)
    800042c0:	79e2                	ld	s3,56(sp)
    800042c2:	7a42                	ld	s4,48(sp)
    800042c4:	7aa2                	ld	s5,40(sp)
    800042c6:	7b02                	ld	s6,32(sp)
    800042c8:	6be2                	ld	s7,24(sp)
    800042ca:	6c42                	ld	s8,16(sp)
    800042cc:	6ca2                	ld	s9,8(sp)
    800042ce:	6d02                	ld	s10,0(sp)
    800042d0:	6125                	addi	sp,sp,96
    800042d2:	8082                	ret
      iunlock(ip);
    800042d4:	8552                	mv	a0,s4
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	a7e080e7          	jalr	-1410(ra) # 80003d54 <iunlock>
      return ip;
    800042de:	bfe1                	j	800042b6 <namex+0x6c>
      iunlockput(ip);
    800042e0:	8552                	mv	a0,s4
    800042e2:	00000097          	auipc	ra,0x0
    800042e6:	c12080e7          	jalr	-1006(ra) # 80003ef4 <iunlockput>
      return 0;
    800042ea:	8a4e                	mv	s4,s3
    800042ec:	b7e9                	j	800042b6 <namex+0x6c>
  len = path - s;
    800042ee:	40998633          	sub	a2,s3,s1
    800042f2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800042f6:	09ac5863          	bge	s8,s10,80004386 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800042fa:	8666                	mv	a2,s9
    800042fc:	85a6                	mv	a1,s1
    800042fe:	8556                	mv	a0,s5
    80004300:	ffffd097          	auipc	ra,0xffffd
    80004304:	a9a080e7          	jalr	-1382(ra) # 80000d9a <memmove>
    80004308:	84ce                	mv	s1,s3
  while(*path == '/')
    8000430a:	0004c783          	lbu	a5,0(s1)
    8000430e:	01279763          	bne	a5,s2,8000431c <namex+0xd2>
    path++;
    80004312:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004314:	0004c783          	lbu	a5,0(s1)
    80004318:	ff278de3          	beq	a5,s2,80004312 <namex+0xc8>
    ilock(ip);
    8000431c:	8552                	mv	a0,s4
    8000431e:	00000097          	auipc	ra,0x0
    80004322:	970080e7          	jalr	-1680(ra) # 80003c8e <ilock>
    if(ip->type != T_DIR){
    80004326:	044a1783          	lh	a5,68(s4)
    8000432a:	f97790e3          	bne	a5,s7,800042aa <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000432e:	000b0563          	beqz	s6,80004338 <namex+0xee>
    80004332:	0004c783          	lbu	a5,0(s1)
    80004336:	dfd9                	beqz	a5,800042d4 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004338:	4601                	li	a2,0
    8000433a:	85d6                	mv	a1,s5
    8000433c:	8552                	mv	a0,s4
    8000433e:	00000097          	auipc	ra,0x0
    80004342:	e4c080e7          	jalr	-436(ra) # 8000418a <dirlookup>
    80004346:	89aa                	mv	s3,a0
    80004348:	dd41                	beqz	a0,800042e0 <namex+0x96>
    iunlockput(ip);
    8000434a:	8552                	mv	a0,s4
    8000434c:	00000097          	auipc	ra,0x0
    80004350:	ba8080e7          	jalr	-1112(ra) # 80003ef4 <iunlockput>
    ip = next;
    80004354:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004356:	0004c783          	lbu	a5,0(s1)
    8000435a:	01279763          	bne	a5,s2,80004368 <namex+0x11e>
    path++;
    8000435e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004360:	0004c783          	lbu	a5,0(s1)
    80004364:	ff278de3          	beq	a5,s2,8000435e <namex+0x114>
  if(*path == 0)
    80004368:	cb9d                	beqz	a5,8000439e <namex+0x154>
  while(*path != '/' && *path != 0)
    8000436a:	0004c783          	lbu	a5,0(s1)
    8000436e:	89a6                	mv	s3,s1
  len = path - s;
    80004370:	4d01                	li	s10,0
    80004372:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004374:	01278963          	beq	a5,s2,80004386 <namex+0x13c>
    80004378:	dbbd                	beqz	a5,800042ee <namex+0xa4>
    path++;
    8000437a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000437c:	0009c783          	lbu	a5,0(s3)
    80004380:	ff279ce3          	bne	a5,s2,80004378 <namex+0x12e>
    80004384:	b7ad                	j	800042ee <namex+0xa4>
    memmove(name, s, len);
    80004386:	2601                	sext.w	a2,a2
    80004388:	85a6                	mv	a1,s1
    8000438a:	8556                	mv	a0,s5
    8000438c:	ffffd097          	auipc	ra,0xffffd
    80004390:	a0e080e7          	jalr	-1522(ra) # 80000d9a <memmove>
    name[len] = 0;
    80004394:	9d56                	add	s10,s10,s5
    80004396:	000d0023          	sb	zero,0(s10)
    8000439a:	84ce                	mv	s1,s3
    8000439c:	b7bd                	j	8000430a <namex+0xc0>
  if(nameiparent){
    8000439e:	f00b0ce3          	beqz	s6,800042b6 <namex+0x6c>
    iput(ip);
    800043a2:	8552                	mv	a0,s4
    800043a4:	00000097          	auipc	ra,0x0
    800043a8:	aa8080e7          	jalr	-1368(ra) # 80003e4c <iput>
    return 0;
    800043ac:	4a01                	li	s4,0
    800043ae:	b721                	j	800042b6 <namex+0x6c>

00000000800043b0 <dirlink>:
{
    800043b0:	715d                	addi	sp,sp,-80
    800043b2:	e486                	sd	ra,72(sp)
    800043b4:	e0a2                	sd	s0,64(sp)
    800043b6:	f84a                	sd	s2,48(sp)
    800043b8:	ec56                	sd	s5,24(sp)
    800043ba:	e85a                	sd	s6,16(sp)
    800043bc:	0880                	addi	s0,sp,80
    800043be:	892a                	mv	s2,a0
    800043c0:	8aae                	mv	s5,a1
    800043c2:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800043c4:	4601                	li	a2,0
    800043c6:	00000097          	auipc	ra,0x0
    800043ca:	dc4080e7          	jalr	-572(ra) # 8000418a <dirlookup>
    800043ce:	e129                	bnez	a0,80004410 <dirlink+0x60>
    800043d0:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043d2:	04c92483          	lw	s1,76(s2)
    800043d6:	cca9                	beqz	s1,80004430 <dirlink+0x80>
    800043d8:	f44e                	sd	s3,40(sp)
    800043da:	f052                	sd	s4,32(sp)
    800043dc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043de:	fb040a13          	addi	s4,s0,-80
    800043e2:	49c1                	li	s3,16
    800043e4:	874e                	mv	a4,s3
    800043e6:	86a6                	mv	a3,s1
    800043e8:	8652                	mv	a2,s4
    800043ea:	4581                	li	a1,0
    800043ec:	854a                	mv	a0,s2
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	b5c080e7          	jalr	-1188(ra) # 80003f4a <readi>
    800043f6:	03351363          	bne	a0,s3,8000441c <dirlink+0x6c>
    if(de.inum == 0)
    800043fa:	fb045783          	lhu	a5,-80(s0)
    800043fe:	c79d                	beqz	a5,8000442c <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004400:	24c1                	addiw	s1,s1,16
    80004402:	04c92783          	lw	a5,76(s2)
    80004406:	fcf4efe3          	bltu	s1,a5,800043e4 <dirlink+0x34>
    8000440a:	79a2                	ld	s3,40(sp)
    8000440c:	7a02                	ld	s4,32(sp)
    8000440e:	a00d                	j	80004430 <dirlink+0x80>
    iput(ip);
    80004410:	00000097          	auipc	ra,0x0
    80004414:	a3c080e7          	jalr	-1476(ra) # 80003e4c <iput>
    return -1;
    80004418:	557d                	li	a0,-1
    8000441a:	a0a9                	j	80004464 <dirlink+0xb4>
      panic("dirlink read");
    8000441c:	00004517          	auipc	a0,0x4
    80004420:	0e450513          	addi	a0,a0,228 # 80008500 <etext+0x500>
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	13c080e7          	jalr	316(ra) # 80000560 <panic>
    8000442c:	79a2                	ld	s3,40(sp)
    8000442e:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004430:	4639                	li	a2,14
    80004432:	85d6                	mv	a1,s5
    80004434:	fb240513          	addi	a0,s0,-78
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	a14080e7          	jalr	-1516(ra) # 80000e4c <strncpy>
  de.inum = inum;
    80004440:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004444:	4741                	li	a4,16
    80004446:	86a6                	mv	a3,s1
    80004448:	fb040613          	addi	a2,s0,-80
    8000444c:	4581                	li	a1,0
    8000444e:	854a                	mv	a0,s2
    80004450:	00000097          	auipc	ra,0x0
    80004454:	c00080e7          	jalr	-1024(ra) # 80004050 <writei>
    80004458:	1541                	addi	a0,a0,-16
    8000445a:	00a03533          	snez	a0,a0
    8000445e:	40a0053b          	negw	a0,a0
    80004462:	74e2                	ld	s1,56(sp)
}
    80004464:	60a6                	ld	ra,72(sp)
    80004466:	6406                	ld	s0,64(sp)
    80004468:	7942                	ld	s2,48(sp)
    8000446a:	6ae2                	ld	s5,24(sp)
    8000446c:	6b42                	ld	s6,16(sp)
    8000446e:	6161                	addi	sp,sp,80
    80004470:	8082                	ret

0000000080004472 <namei>:

struct inode*
namei(char *path)
{
    80004472:	1101                	addi	sp,sp,-32
    80004474:	ec06                	sd	ra,24(sp)
    80004476:	e822                	sd	s0,16(sp)
    80004478:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000447a:	fe040613          	addi	a2,s0,-32
    8000447e:	4581                	li	a1,0
    80004480:	00000097          	auipc	ra,0x0
    80004484:	dca080e7          	jalr	-566(ra) # 8000424a <namex>
}
    80004488:	60e2                	ld	ra,24(sp)
    8000448a:	6442                	ld	s0,16(sp)
    8000448c:	6105                	addi	sp,sp,32
    8000448e:	8082                	ret

0000000080004490 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004490:	1141                	addi	sp,sp,-16
    80004492:	e406                	sd	ra,8(sp)
    80004494:	e022                	sd	s0,0(sp)
    80004496:	0800                	addi	s0,sp,16
    80004498:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000449a:	4585                	li	a1,1
    8000449c:	00000097          	auipc	ra,0x0
    800044a0:	dae080e7          	jalr	-594(ra) # 8000424a <namex>
}
    800044a4:	60a2                	ld	ra,8(sp)
    800044a6:	6402                	ld	s0,0(sp)
    800044a8:	0141                	addi	sp,sp,16
    800044aa:	8082                	ret

00000000800044ac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044ac:	1101                	addi	sp,sp,-32
    800044ae:	ec06                	sd	ra,24(sp)
    800044b0:	e822                	sd	s0,16(sp)
    800044b2:	e426                	sd	s1,8(sp)
    800044b4:	e04a                	sd	s2,0(sp)
    800044b6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800044b8:	00020917          	auipc	s2,0x20
    800044bc:	87890913          	addi	s2,s2,-1928 # 80023d30 <log>
    800044c0:	01892583          	lw	a1,24(s2)
    800044c4:	02892503          	lw	a0,40(s2)
    800044c8:	fffff097          	auipc	ra,0xfffff
    800044cc:	fb8080e7          	jalr	-72(ra) # 80003480 <bread>
    800044d0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800044d2:	02c92603          	lw	a2,44(s2)
    800044d6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800044d8:	00c05f63          	blez	a2,800044f6 <write_head+0x4a>
    800044dc:	00020717          	auipc	a4,0x20
    800044e0:	88470713          	addi	a4,a4,-1916 # 80023d60 <log+0x30>
    800044e4:	87aa                	mv	a5,a0
    800044e6:	060a                	slli	a2,a2,0x2
    800044e8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800044ea:	4314                	lw	a3,0(a4)
    800044ec:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800044ee:	0711                	addi	a4,a4,4
    800044f0:	0791                	addi	a5,a5,4
    800044f2:	fec79ce3          	bne	a5,a2,800044ea <write_head+0x3e>
  }
  bwrite(buf);
    800044f6:	8526                	mv	a0,s1
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	07a080e7          	jalr	122(ra) # 80003572 <bwrite>
  brelse(buf);
    80004500:	8526                	mv	a0,s1
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	0ae080e7          	jalr	174(ra) # 800035b0 <brelse>
}
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6902                	ld	s2,0(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret

0000000080004516 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004516:	00020797          	auipc	a5,0x20
    8000451a:	8467a783          	lw	a5,-1978(a5) # 80023d5c <log+0x2c>
    8000451e:	0cf05063          	blez	a5,800045de <install_trans+0xc8>
{
    80004522:	715d                	addi	sp,sp,-80
    80004524:	e486                	sd	ra,72(sp)
    80004526:	e0a2                	sd	s0,64(sp)
    80004528:	fc26                	sd	s1,56(sp)
    8000452a:	f84a                	sd	s2,48(sp)
    8000452c:	f44e                	sd	s3,40(sp)
    8000452e:	f052                	sd	s4,32(sp)
    80004530:	ec56                	sd	s5,24(sp)
    80004532:	e85a                	sd	s6,16(sp)
    80004534:	e45e                	sd	s7,8(sp)
    80004536:	0880                	addi	s0,sp,80
    80004538:	8b2a                	mv	s6,a0
    8000453a:	00020a97          	auipc	s5,0x20
    8000453e:	826a8a93          	addi	s5,s5,-2010 # 80023d60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004542:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004544:	0001f997          	auipc	s3,0x1f
    80004548:	7ec98993          	addi	s3,s3,2028 # 80023d30 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000454c:	40000b93          	li	s7,1024
    80004550:	a00d                	j	80004572 <install_trans+0x5c>
    brelse(lbuf);
    80004552:	854a                	mv	a0,s2
    80004554:	fffff097          	auipc	ra,0xfffff
    80004558:	05c080e7          	jalr	92(ra) # 800035b0 <brelse>
    brelse(dbuf);
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	052080e7          	jalr	82(ra) # 800035b0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004566:	2a05                	addiw	s4,s4,1
    80004568:	0a91                	addi	s5,s5,4
    8000456a:	02c9a783          	lw	a5,44(s3)
    8000456e:	04fa5d63          	bge	s4,a5,800045c8 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004572:	0189a583          	lw	a1,24(s3)
    80004576:	014585bb          	addw	a1,a1,s4
    8000457a:	2585                	addiw	a1,a1,1
    8000457c:	0289a503          	lw	a0,40(s3)
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	f00080e7          	jalr	-256(ra) # 80003480 <bread>
    80004588:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000458a:	000aa583          	lw	a1,0(s5)
    8000458e:	0289a503          	lw	a0,40(s3)
    80004592:	fffff097          	auipc	ra,0xfffff
    80004596:	eee080e7          	jalr	-274(ra) # 80003480 <bread>
    8000459a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000459c:	865e                	mv	a2,s7
    8000459e:	05890593          	addi	a1,s2,88
    800045a2:	05850513          	addi	a0,a0,88
    800045a6:	ffffc097          	auipc	ra,0xffffc
    800045aa:	7f4080e7          	jalr	2036(ra) # 80000d9a <memmove>
    bwrite(dbuf);  // write dst to disk
    800045ae:	8526                	mv	a0,s1
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	fc2080e7          	jalr	-62(ra) # 80003572 <bwrite>
    if(recovering == 0)
    800045b8:	f80b1de3          	bnez	s6,80004552 <install_trans+0x3c>
      bunpin(dbuf);
    800045bc:	8526                	mv	a0,s1
    800045be:	fffff097          	auipc	ra,0xfffff
    800045c2:	0c6080e7          	jalr	198(ra) # 80003684 <bunpin>
    800045c6:	b771                	j	80004552 <install_trans+0x3c>
}
    800045c8:	60a6                	ld	ra,72(sp)
    800045ca:	6406                	ld	s0,64(sp)
    800045cc:	74e2                	ld	s1,56(sp)
    800045ce:	7942                	ld	s2,48(sp)
    800045d0:	79a2                	ld	s3,40(sp)
    800045d2:	7a02                	ld	s4,32(sp)
    800045d4:	6ae2                	ld	s5,24(sp)
    800045d6:	6b42                	ld	s6,16(sp)
    800045d8:	6ba2                	ld	s7,8(sp)
    800045da:	6161                	addi	sp,sp,80
    800045dc:	8082                	ret
    800045de:	8082                	ret

00000000800045e0 <initlog>:
{
    800045e0:	7179                	addi	sp,sp,-48
    800045e2:	f406                	sd	ra,40(sp)
    800045e4:	f022                	sd	s0,32(sp)
    800045e6:	ec26                	sd	s1,24(sp)
    800045e8:	e84a                	sd	s2,16(sp)
    800045ea:	e44e                	sd	s3,8(sp)
    800045ec:	1800                	addi	s0,sp,48
    800045ee:	892a                	mv	s2,a0
    800045f0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045f2:	0001f497          	auipc	s1,0x1f
    800045f6:	73e48493          	addi	s1,s1,1854 # 80023d30 <log>
    800045fa:	00004597          	auipc	a1,0x4
    800045fe:	f1658593          	addi	a1,a1,-234 # 80008510 <etext+0x510>
    80004602:	8526                	mv	a0,s1
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	5a6080e7          	jalr	1446(ra) # 80000baa <initlock>
  log.start = sb->logstart;
    8000460c:	0149a583          	lw	a1,20(s3)
    80004610:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004612:	0109a783          	lw	a5,16(s3)
    80004616:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004618:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	e62080e7          	jalr	-414(ra) # 80003480 <bread>
  log.lh.n = lh->n;
    80004626:	4d30                	lw	a2,88(a0)
    80004628:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000462a:	00c05f63          	blez	a2,80004648 <initlog+0x68>
    8000462e:	87aa                	mv	a5,a0
    80004630:	0001f717          	auipc	a4,0x1f
    80004634:	73070713          	addi	a4,a4,1840 # 80023d60 <log+0x30>
    80004638:	060a                	slli	a2,a2,0x2
    8000463a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000463c:	4ff4                	lw	a3,92(a5)
    8000463e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004640:	0791                	addi	a5,a5,4
    80004642:	0711                	addi	a4,a4,4
    80004644:	fec79ce3          	bne	a5,a2,8000463c <initlog+0x5c>
  brelse(buf);
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	f68080e7          	jalr	-152(ra) # 800035b0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004650:	4505                	li	a0,1
    80004652:	00000097          	auipc	ra,0x0
    80004656:	ec4080e7          	jalr	-316(ra) # 80004516 <install_trans>
  log.lh.n = 0;
    8000465a:	0001f797          	auipc	a5,0x1f
    8000465e:	7007a123          	sw	zero,1794(a5) # 80023d5c <log+0x2c>
  write_head(); // clear the log
    80004662:	00000097          	auipc	ra,0x0
    80004666:	e4a080e7          	jalr	-438(ra) # 800044ac <write_head>
}
    8000466a:	70a2                	ld	ra,40(sp)
    8000466c:	7402                	ld	s0,32(sp)
    8000466e:	64e2                	ld	s1,24(sp)
    80004670:	6942                	ld	s2,16(sp)
    80004672:	69a2                	ld	s3,8(sp)
    80004674:	6145                	addi	sp,sp,48
    80004676:	8082                	ret

0000000080004678 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004678:	1101                	addi	sp,sp,-32
    8000467a:	ec06                	sd	ra,24(sp)
    8000467c:	e822                	sd	s0,16(sp)
    8000467e:	e426                	sd	s1,8(sp)
    80004680:	e04a                	sd	s2,0(sp)
    80004682:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004684:	0001f517          	auipc	a0,0x1f
    80004688:	6ac50513          	addi	a0,a0,1708 # 80023d30 <log>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	5b2080e7          	jalr	1458(ra) # 80000c3e <acquire>
  while(1){
    if(log.committing){
    80004694:	0001f497          	auipc	s1,0x1f
    80004698:	69c48493          	addi	s1,s1,1692 # 80023d30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000469c:	4979                	li	s2,30
    8000469e:	a039                	j	800046ac <begin_op+0x34>
      sleep(&log, &log.lock);
    800046a0:	85a6                	mv	a1,s1
    800046a2:	8526                	mv	a0,s1
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	bbc080e7          	jalr	-1092(ra) # 80002260 <sleep>
    if(log.committing){
    800046ac:	50dc                	lw	a5,36(s1)
    800046ae:	fbed                	bnez	a5,800046a0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046b0:	5098                	lw	a4,32(s1)
    800046b2:	2705                	addiw	a4,a4,1
    800046b4:	0027179b          	slliw	a5,a4,0x2
    800046b8:	9fb9                	addw	a5,a5,a4
    800046ba:	0017979b          	slliw	a5,a5,0x1
    800046be:	54d4                	lw	a3,44(s1)
    800046c0:	9fb5                	addw	a5,a5,a3
    800046c2:	00f95963          	bge	s2,a5,800046d4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046c6:	85a6                	mv	a1,s1
    800046c8:	8526                	mv	a0,s1
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	b96080e7          	jalr	-1130(ra) # 80002260 <sleep>
    800046d2:	bfe9                	j	800046ac <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800046d4:	0001f517          	auipc	a0,0x1f
    800046d8:	65c50513          	addi	a0,a0,1628 # 80023d30 <log>
    800046dc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800046de:	ffffc097          	auipc	ra,0xffffc
    800046e2:	610080e7          	jalr	1552(ra) # 80000cee <release>
      break;
    }
  }
}
    800046e6:	60e2                	ld	ra,24(sp)
    800046e8:	6442                	ld	s0,16(sp)
    800046ea:	64a2                	ld	s1,8(sp)
    800046ec:	6902                	ld	s2,0(sp)
    800046ee:	6105                	addi	sp,sp,32
    800046f0:	8082                	ret

00000000800046f2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800046f2:	7139                	addi	sp,sp,-64
    800046f4:	fc06                	sd	ra,56(sp)
    800046f6:	f822                	sd	s0,48(sp)
    800046f8:	f426                	sd	s1,40(sp)
    800046fa:	f04a                	sd	s2,32(sp)
    800046fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800046fe:	0001f497          	auipc	s1,0x1f
    80004702:	63248493          	addi	s1,s1,1586 # 80023d30 <log>
    80004706:	8526                	mv	a0,s1
    80004708:	ffffc097          	auipc	ra,0xffffc
    8000470c:	536080e7          	jalr	1334(ra) # 80000c3e <acquire>
  log.outstanding -= 1;
    80004710:	509c                	lw	a5,32(s1)
    80004712:	37fd                	addiw	a5,a5,-1
    80004714:	893e                	mv	s2,a5
    80004716:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004718:	50dc                	lw	a5,36(s1)
    8000471a:	e7b9                	bnez	a5,80004768 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    8000471c:	06091263          	bnez	s2,80004780 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004720:	0001f497          	auipc	s1,0x1f
    80004724:	61048493          	addi	s1,s1,1552 # 80023d30 <log>
    80004728:	4785                	li	a5,1
    8000472a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	5c0080e7          	jalr	1472(ra) # 80000cee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004736:	54dc                	lw	a5,44(s1)
    80004738:	06f04863          	bgtz	a5,800047a8 <end_op+0xb6>
    acquire(&log.lock);
    8000473c:	0001f497          	auipc	s1,0x1f
    80004740:	5f448493          	addi	s1,s1,1524 # 80023d30 <log>
    80004744:	8526                	mv	a0,s1
    80004746:	ffffc097          	auipc	ra,0xffffc
    8000474a:	4f8080e7          	jalr	1272(ra) # 80000c3e <acquire>
    log.committing = 0;
    8000474e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004752:	8526                	mv	a0,s1
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	b70080e7          	jalr	-1168(ra) # 800022c4 <wakeup>
    release(&log.lock);
    8000475c:	8526                	mv	a0,s1
    8000475e:	ffffc097          	auipc	ra,0xffffc
    80004762:	590080e7          	jalr	1424(ra) # 80000cee <release>
}
    80004766:	a81d                	j	8000479c <end_op+0xaa>
    80004768:	ec4e                	sd	s3,24(sp)
    8000476a:	e852                	sd	s4,16(sp)
    8000476c:	e456                	sd	s5,8(sp)
    8000476e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80004770:	00004517          	auipc	a0,0x4
    80004774:	da850513          	addi	a0,a0,-600 # 80008518 <etext+0x518>
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	de8080e7          	jalr	-536(ra) # 80000560 <panic>
    wakeup(&log);
    80004780:	0001f497          	auipc	s1,0x1f
    80004784:	5b048493          	addi	s1,s1,1456 # 80023d30 <log>
    80004788:	8526                	mv	a0,s1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	b3a080e7          	jalr	-1222(ra) # 800022c4 <wakeup>
  release(&log.lock);
    80004792:	8526                	mv	a0,s1
    80004794:	ffffc097          	auipc	ra,0xffffc
    80004798:	55a080e7          	jalr	1370(ra) # 80000cee <release>
}
    8000479c:	70e2                	ld	ra,56(sp)
    8000479e:	7442                	ld	s0,48(sp)
    800047a0:	74a2                	ld	s1,40(sp)
    800047a2:	7902                	ld	s2,32(sp)
    800047a4:	6121                	addi	sp,sp,64
    800047a6:	8082                	ret
    800047a8:	ec4e                	sd	s3,24(sp)
    800047aa:	e852                	sd	s4,16(sp)
    800047ac:	e456                	sd	s5,8(sp)
    800047ae:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800047b0:	0001fa97          	auipc	s5,0x1f
    800047b4:	5b0a8a93          	addi	s5,s5,1456 # 80023d60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047b8:	0001fa17          	auipc	s4,0x1f
    800047bc:	578a0a13          	addi	s4,s4,1400 # 80023d30 <log>
    memmove(to->data, from->data, BSIZE);
    800047c0:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047c4:	018a2583          	lw	a1,24(s4)
    800047c8:	012585bb          	addw	a1,a1,s2
    800047cc:	2585                	addiw	a1,a1,1
    800047ce:	028a2503          	lw	a0,40(s4)
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	cae080e7          	jalr	-850(ra) # 80003480 <bread>
    800047da:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800047dc:	000aa583          	lw	a1,0(s5)
    800047e0:	028a2503          	lw	a0,40(s4)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	c9c080e7          	jalr	-868(ra) # 80003480 <bread>
    800047ec:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800047ee:	865a                	mv	a2,s6
    800047f0:	05850593          	addi	a1,a0,88
    800047f4:	05848513          	addi	a0,s1,88
    800047f8:	ffffc097          	auipc	ra,0xffffc
    800047fc:	5a2080e7          	jalr	1442(ra) # 80000d9a <memmove>
    bwrite(to);  // write the log
    80004800:	8526                	mv	a0,s1
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	d70080e7          	jalr	-656(ra) # 80003572 <bwrite>
    brelse(from);
    8000480a:	854e                	mv	a0,s3
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	da4080e7          	jalr	-604(ra) # 800035b0 <brelse>
    brelse(to);
    80004814:	8526                	mv	a0,s1
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	d9a080e7          	jalr	-614(ra) # 800035b0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000481e:	2905                	addiw	s2,s2,1
    80004820:	0a91                	addi	s5,s5,4
    80004822:	02ca2783          	lw	a5,44(s4)
    80004826:	f8f94fe3          	blt	s2,a5,800047c4 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	c82080e7          	jalr	-894(ra) # 800044ac <write_head>
    install_trans(0); // Now install writes to home locations
    80004832:	4501                	li	a0,0
    80004834:	00000097          	auipc	ra,0x0
    80004838:	ce2080e7          	jalr	-798(ra) # 80004516 <install_trans>
    log.lh.n = 0;
    8000483c:	0001f797          	auipc	a5,0x1f
    80004840:	5207a023          	sw	zero,1312(a5) # 80023d5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004844:	00000097          	auipc	ra,0x0
    80004848:	c68080e7          	jalr	-920(ra) # 800044ac <write_head>
    8000484c:	69e2                	ld	s3,24(sp)
    8000484e:	6a42                	ld	s4,16(sp)
    80004850:	6aa2                	ld	s5,8(sp)
    80004852:	6b02                	ld	s6,0(sp)
    80004854:	b5e5                	j	8000473c <end_op+0x4a>

0000000080004856 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004856:	1101                	addi	sp,sp,-32
    80004858:	ec06                	sd	ra,24(sp)
    8000485a:	e822                	sd	s0,16(sp)
    8000485c:	e426                	sd	s1,8(sp)
    8000485e:	e04a                	sd	s2,0(sp)
    80004860:	1000                	addi	s0,sp,32
    80004862:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004864:	0001f917          	auipc	s2,0x1f
    80004868:	4cc90913          	addi	s2,s2,1228 # 80023d30 <log>
    8000486c:	854a                	mv	a0,s2
    8000486e:	ffffc097          	auipc	ra,0xffffc
    80004872:	3d0080e7          	jalr	976(ra) # 80000c3e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004876:	02c92603          	lw	a2,44(s2)
    8000487a:	47f5                	li	a5,29
    8000487c:	06c7c563          	blt	a5,a2,800048e6 <log_write+0x90>
    80004880:	0001f797          	auipc	a5,0x1f
    80004884:	4cc7a783          	lw	a5,1228(a5) # 80023d4c <log+0x1c>
    80004888:	37fd                	addiw	a5,a5,-1
    8000488a:	04f65e63          	bge	a2,a5,800048e6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000488e:	0001f797          	auipc	a5,0x1f
    80004892:	4c27a783          	lw	a5,1218(a5) # 80023d50 <log+0x20>
    80004896:	06f05063          	blez	a5,800048f6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000489a:	4781                	li	a5,0
    8000489c:	06c05563          	blez	a2,80004906 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048a0:	44cc                	lw	a1,12(s1)
    800048a2:	0001f717          	auipc	a4,0x1f
    800048a6:	4be70713          	addi	a4,a4,1214 # 80023d60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048aa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048ac:	4314                	lw	a3,0(a4)
    800048ae:	04b68c63          	beq	a3,a1,80004906 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800048b2:	2785                	addiw	a5,a5,1
    800048b4:	0711                	addi	a4,a4,4
    800048b6:	fef61be3          	bne	a2,a5,800048ac <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048ba:	0621                	addi	a2,a2,8
    800048bc:	060a                	slli	a2,a2,0x2
    800048be:	0001f797          	auipc	a5,0x1f
    800048c2:	47278793          	addi	a5,a5,1138 # 80023d30 <log>
    800048c6:	97b2                	add	a5,a5,a2
    800048c8:	44d8                	lw	a4,12(s1)
    800048ca:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800048cc:	8526                	mv	a0,s1
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	d7a080e7          	jalr	-646(ra) # 80003648 <bpin>
    log.lh.n++;
    800048d6:	0001f717          	auipc	a4,0x1f
    800048da:	45a70713          	addi	a4,a4,1114 # 80023d30 <log>
    800048de:	575c                	lw	a5,44(a4)
    800048e0:	2785                	addiw	a5,a5,1
    800048e2:	d75c                	sw	a5,44(a4)
    800048e4:	a82d                	j	8000491e <log_write+0xc8>
    panic("too big a transaction");
    800048e6:	00004517          	auipc	a0,0x4
    800048ea:	c4250513          	addi	a0,a0,-958 # 80008528 <etext+0x528>
    800048ee:	ffffc097          	auipc	ra,0xffffc
    800048f2:	c72080e7          	jalr	-910(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800048f6:	00004517          	auipc	a0,0x4
    800048fa:	c4a50513          	addi	a0,a0,-950 # 80008540 <etext+0x540>
    800048fe:	ffffc097          	auipc	ra,0xffffc
    80004902:	c62080e7          	jalr	-926(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004906:	00878693          	addi	a3,a5,8
    8000490a:	068a                	slli	a3,a3,0x2
    8000490c:	0001f717          	auipc	a4,0x1f
    80004910:	42470713          	addi	a4,a4,1060 # 80023d30 <log>
    80004914:	9736                	add	a4,a4,a3
    80004916:	44d4                	lw	a3,12(s1)
    80004918:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000491a:	faf609e3          	beq	a2,a5,800048cc <log_write+0x76>
  }
  release(&log.lock);
    8000491e:	0001f517          	auipc	a0,0x1f
    80004922:	41250513          	addi	a0,a0,1042 # 80023d30 <log>
    80004926:	ffffc097          	auipc	ra,0xffffc
    8000492a:	3c8080e7          	jalr	968(ra) # 80000cee <release>
}
    8000492e:	60e2                	ld	ra,24(sp)
    80004930:	6442                	ld	s0,16(sp)
    80004932:	64a2                	ld	s1,8(sp)
    80004934:	6902                	ld	s2,0(sp)
    80004936:	6105                	addi	sp,sp,32
    80004938:	8082                	ret

000000008000493a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000493a:	1101                	addi	sp,sp,-32
    8000493c:	ec06                	sd	ra,24(sp)
    8000493e:	e822                	sd	s0,16(sp)
    80004940:	e426                	sd	s1,8(sp)
    80004942:	e04a                	sd	s2,0(sp)
    80004944:	1000                	addi	s0,sp,32
    80004946:	84aa                	mv	s1,a0
    80004948:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000494a:	00004597          	auipc	a1,0x4
    8000494e:	c1658593          	addi	a1,a1,-1002 # 80008560 <etext+0x560>
    80004952:	0521                	addi	a0,a0,8
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	256080e7          	jalr	598(ra) # 80000baa <initlock>
  lk->name = name;
    8000495c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004960:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004964:	0204a423          	sw	zero,40(s1)
}
    80004968:	60e2                	ld	ra,24(sp)
    8000496a:	6442                	ld	s0,16(sp)
    8000496c:	64a2                	ld	s1,8(sp)
    8000496e:	6902                	ld	s2,0(sp)
    80004970:	6105                	addi	sp,sp,32
    80004972:	8082                	ret

0000000080004974 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004974:	1101                	addi	sp,sp,-32
    80004976:	ec06                	sd	ra,24(sp)
    80004978:	e822                	sd	s0,16(sp)
    8000497a:	e426                	sd	s1,8(sp)
    8000497c:	e04a                	sd	s2,0(sp)
    8000497e:	1000                	addi	s0,sp,32
    80004980:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004982:	00850913          	addi	s2,a0,8
    80004986:	854a                	mv	a0,s2
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	2b6080e7          	jalr	694(ra) # 80000c3e <acquire>
  while (lk->locked) {
    80004990:	409c                	lw	a5,0(s1)
    80004992:	cb89                	beqz	a5,800049a4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004994:	85ca                	mv	a1,s2
    80004996:	8526                	mv	a0,s1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	8c8080e7          	jalr	-1848(ra) # 80002260 <sleep>
  while (lk->locked) {
    800049a0:	409c                	lw	a5,0(s1)
    800049a2:	fbed                	bnez	a5,80004994 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049a4:	4785                	li	a5,1
    800049a6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049a8:	ffffd097          	auipc	ra,0xffffd
    800049ac:	0c0080e7          	jalr	192(ra) # 80001a68 <myproc>
    800049b0:	591c                	lw	a5,48(a0)
    800049b2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049b4:	854a                	mv	a0,s2
    800049b6:	ffffc097          	auipc	ra,0xffffc
    800049ba:	338080e7          	jalr	824(ra) # 80000cee <release>
}
    800049be:	60e2                	ld	ra,24(sp)
    800049c0:	6442                	ld	s0,16(sp)
    800049c2:	64a2                	ld	s1,8(sp)
    800049c4:	6902                	ld	s2,0(sp)
    800049c6:	6105                	addi	sp,sp,32
    800049c8:	8082                	ret

00000000800049ca <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049ca:	1101                	addi	sp,sp,-32
    800049cc:	ec06                	sd	ra,24(sp)
    800049ce:	e822                	sd	s0,16(sp)
    800049d0:	e426                	sd	s1,8(sp)
    800049d2:	e04a                	sd	s2,0(sp)
    800049d4:	1000                	addi	s0,sp,32
    800049d6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049d8:	00850913          	addi	s2,a0,8
    800049dc:	854a                	mv	a0,s2
    800049de:	ffffc097          	auipc	ra,0xffffc
    800049e2:	260080e7          	jalr	608(ra) # 80000c3e <acquire>
  lk->locked = 0;
    800049e6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049ea:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	8d4080e7          	jalr	-1836(ra) # 800022c4 <wakeup>
  release(&lk->lk);
    800049f8:	854a                	mv	a0,s2
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	2f4080e7          	jalr	756(ra) # 80000cee <release>
}
    80004a02:	60e2                	ld	ra,24(sp)
    80004a04:	6442                	ld	s0,16(sp)
    80004a06:	64a2                	ld	s1,8(sp)
    80004a08:	6902                	ld	s2,0(sp)
    80004a0a:	6105                	addi	sp,sp,32
    80004a0c:	8082                	ret

0000000080004a0e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a0e:	7179                	addi	sp,sp,-48
    80004a10:	f406                	sd	ra,40(sp)
    80004a12:	f022                	sd	s0,32(sp)
    80004a14:	ec26                	sd	s1,24(sp)
    80004a16:	e84a                	sd	s2,16(sp)
    80004a18:	1800                	addi	s0,sp,48
    80004a1a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a1c:	00850913          	addi	s2,a0,8
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	21c080e7          	jalr	540(ra) # 80000c3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a2a:	409c                	lw	a5,0(s1)
    80004a2c:	ef91                	bnez	a5,80004a48 <holdingsleep+0x3a>
    80004a2e:	4481                	li	s1,0
  release(&lk->lk);
    80004a30:	854a                	mv	a0,s2
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	2bc080e7          	jalr	700(ra) # 80000cee <release>
  return r;
}
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	70a2                	ld	ra,40(sp)
    80004a3e:	7402                	ld	s0,32(sp)
    80004a40:	64e2                	ld	s1,24(sp)
    80004a42:	6942                	ld	s2,16(sp)
    80004a44:	6145                	addi	sp,sp,48
    80004a46:	8082                	ret
    80004a48:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a4a:	0284a983          	lw	s3,40(s1)
    80004a4e:	ffffd097          	auipc	ra,0xffffd
    80004a52:	01a080e7          	jalr	26(ra) # 80001a68 <myproc>
    80004a56:	5904                	lw	s1,48(a0)
    80004a58:	413484b3          	sub	s1,s1,s3
    80004a5c:	0014b493          	seqz	s1,s1
    80004a60:	69a2                	ld	s3,8(sp)
    80004a62:	b7f9                	j	80004a30 <holdingsleep+0x22>

0000000080004a64 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a64:	1141                	addi	sp,sp,-16
    80004a66:	e406                	sd	ra,8(sp)
    80004a68:	e022                	sd	s0,0(sp)
    80004a6a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a6c:	00004597          	auipc	a1,0x4
    80004a70:	b0458593          	addi	a1,a1,-1276 # 80008570 <etext+0x570>
    80004a74:	0001f517          	auipc	a0,0x1f
    80004a78:	40450513          	addi	a0,a0,1028 # 80023e78 <ftable>
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	12e080e7          	jalr	302(ra) # 80000baa <initlock>
}
    80004a84:	60a2                	ld	ra,8(sp)
    80004a86:	6402                	ld	s0,0(sp)
    80004a88:	0141                	addi	sp,sp,16
    80004a8a:	8082                	ret

0000000080004a8c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a8c:	1101                	addi	sp,sp,-32
    80004a8e:	ec06                	sd	ra,24(sp)
    80004a90:	e822                	sd	s0,16(sp)
    80004a92:	e426                	sd	s1,8(sp)
    80004a94:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a96:	0001f517          	auipc	a0,0x1f
    80004a9a:	3e250513          	addi	a0,a0,994 # 80023e78 <ftable>
    80004a9e:	ffffc097          	auipc	ra,0xffffc
    80004aa2:	1a0080e7          	jalr	416(ra) # 80000c3e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aa6:	0001f497          	auipc	s1,0x1f
    80004aaa:	3ea48493          	addi	s1,s1,1002 # 80023e90 <ftable+0x18>
    80004aae:	00020717          	auipc	a4,0x20
    80004ab2:	38270713          	addi	a4,a4,898 # 80024e30 <disk>
    if(f->ref == 0){
    80004ab6:	40dc                	lw	a5,4(s1)
    80004ab8:	cf99                	beqz	a5,80004ad6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aba:	02848493          	addi	s1,s1,40
    80004abe:	fee49ce3          	bne	s1,a4,80004ab6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004ac2:	0001f517          	auipc	a0,0x1f
    80004ac6:	3b650513          	addi	a0,a0,950 # 80023e78 <ftable>
    80004aca:	ffffc097          	auipc	ra,0xffffc
    80004ace:	224080e7          	jalr	548(ra) # 80000cee <release>
  return 0;
    80004ad2:	4481                	li	s1,0
    80004ad4:	a819                	j	80004aea <filealloc+0x5e>
      f->ref = 1;
    80004ad6:	4785                	li	a5,1
    80004ad8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004ada:	0001f517          	auipc	a0,0x1f
    80004ade:	39e50513          	addi	a0,a0,926 # 80023e78 <ftable>
    80004ae2:	ffffc097          	auipc	ra,0xffffc
    80004ae6:	20c080e7          	jalr	524(ra) # 80000cee <release>
}
    80004aea:	8526                	mv	a0,s1
    80004aec:	60e2                	ld	ra,24(sp)
    80004aee:	6442                	ld	s0,16(sp)
    80004af0:	64a2                	ld	s1,8(sp)
    80004af2:	6105                	addi	sp,sp,32
    80004af4:	8082                	ret

0000000080004af6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004af6:	1101                	addi	sp,sp,-32
    80004af8:	ec06                	sd	ra,24(sp)
    80004afa:	e822                	sd	s0,16(sp)
    80004afc:	e426                	sd	s1,8(sp)
    80004afe:	1000                	addi	s0,sp,32
    80004b00:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b02:	0001f517          	auipc	a0,0x1f
    80004b06:	37650513          	addi	a0,a0,886 # 80023e78 <ftable>
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	134080e7          	jalr	308(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004b12:	40dc                	lw	a5,4(s1)
    80004b14:	02f05263          	blez	a5,80004b38 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b18:	2785                	addiw	a5,a5,1
    80004b1a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b1c:	0001f517          	auipc	a0,0x1f
    80004b20:	35c50513          	addi	a0,a0,860 # 80023e78 <ftable>
    80004b24:	ffffc097          	auipc	ra,0xffffc
    80004b28:	1ca080e7          	jalr	458(ra) # 80000cee <release>
  return f;
}
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	60e2                	ld	ra,24(sp)
    80004b30:	6442                	ld	s0,16(sp)
    80004b32:	64a2                	ld	s1,8(sp)
    80004b34:	6105                	addi	sp,sp,32
    80004b36:	8082                	ret
    panic("filedup");
    80004b38:	00004517          	auipc	a0,0x4
    80004b3c:	a4050513          	addi	a0,a0,-1472 # 80008578 <etext+0x578>
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	a20080e7          	jalr	-1504(ra) # 80000560 <panic>

0000000080004b48 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b48:	7139                	addi	sp,sp,-64
    80004b4a:	fc06                	sd	ra,56(sp)
    80004b4c:	f822                	sd	s0,48(sp)
    80004b4e:	f426                	sd	s1,40(sp)
    80004b50:	0080                	addi	s0,sp,64
    80004b52:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b54:	0001f517          	auipc	a0,0x1f
    80004b58:	32450513          	addi	a0,a0,804 # 80023e78 <ftable>
    80004b5c:	ffffc097          	auipc	ra,0xffffc
    80004b60:	0e2080e7          	jalr	226(ra) # 80000c3e <acquire>
  if(f->ref < 1)
    80004b64:	40dc                	lw	a5,4(s1)
    80004b66:	04f05a63          	blez	a5,80004bba <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	c0dc                	sw	a5,4(s1)
    80004b6e:	06f04263          	bgtz	a5,80004bd2 <fileclose+0x8a>
    80004b72:	f04a                	sd	s2,32(sp)
    80004b74:	ec4e                	sd	s3,24(sp)
    80004b76:	e852                	sd	s4,16(sp)
    80004b78:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b7a:	0004a903          	lw	s2,0(s1)
    80004b7e:	0094ca83          	lbu	s5,9(s1)
    80004b82:	0104ba03          	ld	s4,16(s1)
    80004b86:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b8a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b8e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b92:	0001f517          	auipc	a0,0x1f
    80004b96:	2e650513          	addi	a0,a0,742 # 80023e78 <ftable>
    80004b9a:	ffffc097          	auipc	ra,0xffffc
    80004b9e:	154080e7          	jalr	340(ra) # 80000cee <release>

  if(ff.type == FD_PIPE){
    80004ba2:	4785                	li	a5,1
    80004ba4:	04f90463          	beq	s2,a5,80004bec <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004ba8:	3979                	addiw	s2,s2,-2
    80004baa:	4785                	li	a5,1
    80004bac:	0527fb63          	bgeu	a5,s2,80004c02 <fileclose+0xba>
    80004bb0:	7902                	ld	s2,32(sp)
    80004bb2:	69e2                	ld	s3,24(sp)
    80004bb4:	6a42                	ld	s4,16(sp)
    80004bb6:	6aa2                	ld	s5,8(sp)
    80004bb8:	a02d                	j	80004be2 <fileclose+0x9a>
    80004bba:	f04a                	sd	s2,32(sp)
    80004bbc:	ec4e                	sd	s3,24(sp)
    80004bbe:	e852                	sd	s4,16(sp)
    80004bc0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004bc2:	00004517          	auipc	a0,0x4
    80004bc6:	9be50513          	addi	a0,a0,-1602 # 80008580 <etext+0x580>
    80004bca:	ffffc097          	auipc	ra,0xffffc
    80004bce:	996080e7          	jalr	-1642(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004bd2:	0001f517          	auipc	a0,0x1f
    80004bd6:	2a650513          	addi	a0,a0,678 # 80023e78 <ftable>
    80004bda:	ffffc097          	auipc	ra,0xffffc
    80004bde:	114080e7          	jalr	276(ra) # 80000cee <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004be2:	70e2                	ld	ra,56(sp)
    80004be4:	7442                	ld	s0,48(sp)
    80004be6:	74a2                	ld	s1,40(sp)
    80004be8:	6121                	addi	sp,sp,64
    80004bea:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004bec:	85d6                	mv	a1,s5
    80004bee:	8552                	mv	a0,s4
    80004bf0:	00000097          	auipc	ra,0x0
    80004bf4:	3ac080e7          	jalr	940(ra) # 80004f9c <pipeclose>
    80004bf8:	7902                	ld	s2,32(sp)
    80004bfa:	69e2                	ld	s3,24(sp)
    80004bfc:	6a42                	ld	s4,16(sp)
    80004bfe:	6aa2                	ld	s5,8(sp)
    80004c00:	b7cd                	j	80004be2 <fileclose+0x9a>
    begin_op();
    80004c02:	00000097          	auipc	ra,0x0
    80004c06:	a76080e7          	jalr	-1418(ra) # 80004678 <begin_op>
    iput(ff.ip);
    80004c0a:	854e                	mv	a0,s3
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	240080e7          	jalr	576(ra) # 80003e4c <iput>
    end_op();
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	ade080e7          	jalr	-1314(ra) # 800046f2 <end_op>
    80004c1c:	7902                	ld	s2,32(sp)
    80004c1e:	69e2                	ld	s3,24(sp)
    80004c20:	6a42                	ld	s4,16(sp)
    80004c22:	6aa2                	ld	s5,8(sp)
    80004c24:	bf7d                	j	80004be2 <fileclose+0x9a>

0000000080004c26 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c26:	715d                	addi	sp,sp,-80
    80004c28:	e486                	sd	ra,72(sp)
    80004c2a:	e0a2                	sd	s0,64(sp)
    80004c2c:	fc26                	sd	s1,56(sp)
    80004c2e:	f44e                	sd	s3,40(sp)
    80004c30:	0880                	addi	s0,sp,80
    80004c32:	84aa                	mv	s1,a0
    80004c34:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	e32080e7          	jalr	-462(ra) # 80001a68 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c3e:	409c                	lw	a5,0(s1)
    80004c40:	37f9                	addiw	a5,a5,-2
    80004c42:	4705                	li	a4,1
    80004c44:	04f76a63          	bltu	a4,a5,80004c98 <filestat+0x72>
    80004c48:	f84a                	sd	s2,48(sp)
    80004c4a:	f052                	sd	s4,32(sp)
    80004c4c:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c4e:	6c88                	ld	a0,24(s1)
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	03e080e7          	jalr	62(ra) # 80003c8e <ilock>
    stati(f->ip, &st);
    80004c58:	fb840a13          	addi	s4,s0,-72
    80004c5c:	85d2                	mv	a1,s4
    80004c5e:	6c88                	ld	a0,24(s1)
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	2bc080e7          	jalr	700(ra) # 80003f1c <stati>
    iunlock(f->ip);
    80004c68:	6c88                	ld	a0,24(s1)
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	0ea080e7          	jalr	234(ra) # 80003d54 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c72:	46e1                	li	a3,24
    80004c74:	8652                	mv	a2,s4
    80004c76:	85ce                	mv	a1,s3
    80004c78:	05093503          	ld	a0,80(s2)
    80004c7c:	ffffd097          	auipc	ra,0xffffd
    80004c80:	a94080e7          	jalr	-1388(ra) # 80001710 <copyout>
    80004c84:	41f5551b          	sraiw	a0,a0,0x1f
    80004c88:	7942                	ld	s2,48(sp)
    80004c8a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004c8c:	60a6                	ld	ra,72(sp)
    80004c8e:	6406                	ld	s0,64(sp)
    80004c90:	74e2                	ld	s1,56(sp)
    80004c92:	79a2                	ld	s3,40(sp)
    80004c94:	6161                	addi	sp,sp,80
    80004c96:	8082                	ret
  return -1;
    80004c98:	557d                	li	a0,-1
    80004c9a:	bfcd                	j	80004c8c <filestat+0x66>

0000000080004c9c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c9c:	7179                	addi	sp,sp,-48
    80004c9e:	f406                	sd	ra,40(sp)
    80004ca0:	f022                	sd	s0,32(sp)
    80004ca2:	e84a                	sd	s2,16(sp)
    80004ca4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ca6:	00854783          	lbu	a5,8(a0)
    80004caa:	cbc5                	beqz	a5,80004d5a <fileread+0xbe>
    80004cac:	ec26                	sd	s1,24(sp)
    80004cae:	e44e                	sd	s3,8(sp)
    80004cb0:	84aa                	mv	s1,a0
    80004cb2:	89ae                	mv	s3,a1
    80004cb4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cb6:	411c                	lw	a5,0(a0)
    80004cb8:	4705                	li	a4,1
    80004cba:	04e78963          	beq	a5,a4,80004d0c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cbe:	470d                	li	a4,3
    80004cc0:	04e78f63          	beq	a5,a4,80004d1e <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cc4:	4709                	li	a4,2
    80004cc6:	08e79263          	bne	a5,a4,80004d4a <fileread+0xae>
    ilock(f->ip);
    80004cca:	6d08                	ld	a0,24(a0)
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	fc2080e7          	jalr	-62(ra) # 80003c8e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004cd4:	874a                	mv	a4,s2
    80004cd6:	5094                	lw	a3,32(s1)
    80004cd8:	864e                	mv	a2,s3
    80004cda:	4585                	li	a1,1
    80004cdc:	6c88                	ld	a0,24(s1)
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	26c080e7          	jalr	620(ra) # 80003f4a <readi>
    80004ce6:	892a                	mv	s2,a0
    80004ce8:	00a05563          	blez	a0,80004cf2 <fileread+0x56>
      f->off += r;
    80004cec:	509c                	lw	a5,32(s1)
    80004cee:	9fa9                	addw	a5,a5,a0
    80004cf0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004cf2:	6c88                	ld	a0,24(s1)
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	060080e7          	jalr	96(ra) # 80003d54 <iunlock>
    80004cfc:	64e2                	ld	s1,24(sp)
    80004cfe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d00:	854a                	mv	a0,s2
    80004d02:	70a2                	ld	ra,40(sp)
    80004d04:	7402                	ld	s0,32(sp)
    80004d06:	6942                	ld	s2,16(sp)
    80004d08:	6145                	addi	sp,sp,48
    80004d0a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d0c:	6908                	ld	a0,16(a0)
    80004d0e:	00000097          	auipc	ra,0x0
    80004d12:	41a080e7          	jalr	1050(ra) # 80005128 <piperead>
    80004d16:	892a                	mv	s2,a0
    80004d18:	64e2                	ld	s1,24(sp)
    80004d1a:	69a2                	ld	s3,8(sp)
    80004d1c:	b7d5                	j	80004d00 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d1e:	02451783          	lh	a5,36(a0)
    80004d22:	03079693          	slli	a3,a5,0x30
    80004d26:	92c1                	srli	a3,a3,0x30
    80004d28:	4725                	li	a4,9
    80004d2a:	02d76a63          	bltu	a4,a3,80004d5e <fileread+0xc2>
    80004d2e:	0792                	slli	a5,a5,0x4
    80004d30:	0001f717          	auipc	a4,0x1f
    80004d34:	0a870713          	addi	a4,a4,168 # 80023dd8 <devsw>
    80004d38:	97ba                	add	a5,a5,a4
    80004d3a:	639c                	ld	a5,0(a5)
    80004d3c:	c78d                	beqz	a5,80004d66 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004d3e:	4505                	li	a0,1
    80004d40:	9782                	jalr	a5
    80004d42:	892a                	mv	s2,a0
    80004d44:	64e2                	ld	s1,24(sp)
    80004d46:	69a2                	ld	s3,8(sp)
    80004d48:	bf65                	j	80004d00 <fileread+0x64>
    panic("fileread");
    80004d4a:	00004517          	auipc	a0,0x4
    80004d4e:	84650513          	addi	a0,a0,-1978 # 80008590 <etext+0x590>
    80004d52:	ffffc097          	auipc	ra,0xffffc
    80004d56:	80e080e7          	jalr	-2034(ra) # 80000560 <panic>
    return -1;
    80004d5a:	597d                	li	s2,-1
    80004d5c:	b755                	j	80004d00 <fileread+0x64>
      return -1;
    80004d5e:	597d                	li	s2,-1
    80004d60:	64e2                	ld	s1,24(sp)
    80004d62:	69a2                	ld	s3,8(sp)
    80004d64:	bf71                	j	80004d00 <fileread+0x64>
    80004d66:	597d                	li	s2,-1
    80004d68:	64e2                	ld	s1,24(sp)
    80004d6a:	69a2                	ld	s3,8(sp)
    80004d6c:	bf51                	j	80004d00 <fileread+0x64>

0000000080004d6e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004d6e:	00954783          	lbu	a5,9(a0)
    80004d72:	12078c63          	beqz	a5,80004eaa <filewrite+0x13c>
{
    80004d76:	711d                	addi	sp,sp,-96
    80004d78:	ec86                	sd	ra,88(sp)
    80004d7a:	e8a2                	sd	s0,80(sp)
    80004d7c:	e0ca                	sd	s2,64(sp)
    80004d7e:	f456                	sd	s5,40(sp)
    80004d80:	f05a                	sd	s6,32(sp)
    80004d82:	1080                	addi	s0,sp,96
    80004d84:	892a                	mv	s2,a0
    80004d86:	8b2e                	mv	s6,a1
    80004d88:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d8a:	411c                	lw	a5,0(a0)
    80004d8c:	4705                	li	a4,1
    80004d8e:	02e78963          	beq	a5,a4,80004dc0 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d92:	470d                	li	a4,3
    80004d94:	02e78c63          	beq	a5,a4,80004dcc <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d98:	4709                	li	a4,2
    80004d9a:	0ee79a63          	bne	a5,a4,80004e8e <filewrite+0x120>
    80004d9e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004da0:	0cc05563          	blez	a2,80004e6a <filewrite+0xfc>
    80004da4:	e4a6                	sd	s1,72(sp)
    80004da6:	fc4e                	sd	s3,56(sp)
    80004da8:	ec5e                	sd	s7,24(sp)
    80004daa:	e862                	sd	s8,16(sp)
    80004dac:	e466                	sd	s9,8(sp)
    int i = 0;
    80004dae:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004db0:	6b85                	lui	s7,0x1
    80004db2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004db6:	6c85                	lui	s9,0x1
    80004db8:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dbc:	4c05                	li	s8,1
    80004dbe:	a849                	j	80004e50 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80004dc0:	6908                	ld	a0,16(a0)
    80004dc2:	00000097          	auipc	ra,0x0
    80004dc6:	24a080e7          	jalr	586(ra) # 8000500c <pipewrite>
    80004dca:	a85d                	j	80004e80 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004dcc:	02451783          	lh	a5,36(a0)
    80004dd0:	03079693          	slli	a3,a5,0x30
    80004dd4:	92c1                	srli	a3,a3,0x30
    80004dd6:	4725                	li	a4,9
    80004dd8:	0cd76b63          	bltu	a4,a3,80004eae <filewrite+0x140>
    80004ddc:	0792                	slli	a5,a5,0x4
    80004dde:	0001f717          	auipc	a4,0x1f
    80004de2:	ffa70713          	addi	a4,a4,-6 # 80023dd8 <devsw>
    80004de6:	97ba                	add	a5,a5,a4
    80004de8:	679c                	ld	a5,8(a5)
    80004dea:	c7e1                	beqz	a5,80004eb2 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80004dec:	4505                	li	a0,1
    80004dee:	9782                	jalr	a5
    80004df0:	a841                	j	80004e80 <filewrite+0x112>
      if(n1 > max)
    80004df2:	2981                	sext.w	s3,s3
      begin_op();
    80004df4:	00000097          	auipc	ra,0x0
    80004df8:	884080e7          	jalr	-1916(ra) # 80004678 <begin_op>
      ilock(f->ip);
    80004dfc:	01893503          	ld	a0,24(s2)
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	e8e080e7          	jalr	-370(ra) # 80003c8e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e08:	874e                	mv	a4,s3
    80004e0a:	02092683          	lw	a3,32(s2)
    80004e0e:	016a0633          	add	a2,s4,s6
    80004e12:	85e2                	mv	a1,s8
    80004e14:	01893503          	ld	a0,24(s2)
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	238080e7          	jalr	568(ra) # 80004050 <writei>
    80004e20:	84aa                	mv	s1,a0
    80004e22:	00a05763          	blez	a0,80004e30 <filewrite+0xc2>
        f->off += r;
    80004e26:	02092783          	lw	a5,32(s2)
    80004e2a:	9fa9                	addw	a5,a5,a0
    80004e2c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e30:	01893503          	ld	a0,24(s2)
    80004e34:	fffff097          	auipc	ra,0xfffff
    80004e38:	f20080e7          	jalr	-224(ra) # 80003d54 <iunlock>
      end_op();
    80004e3c:	00000097          	auipc	ra,0x0
    80004e40:	8b6080e7          	jalr	-1866(ra) # 800046f2 <end_op>

      if(r != n1){
    80004e44:	02999563          	bne	s3,s1,80004e6e <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80004e48:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004e4c:	015a5963          	bge	s4,s5,80004e5e <filewrite+0xf0>
      int n1 = n - i;
    80004e50:	414a87bb          	subw	a5,s5,s4
    80004e54:	89be                	mv	s3,a5
      if(n1 > max)
    80004e56:	f8fbdee3          	bge	s7,a5,80004df2 <filewrite+0x84>
    80004e5a:	89e6                	mv	s3,s9
    80004e5c:	bf59                	j	80004df2 <filewrite+0x84>
    80004e5e:	64a6                	ld	s1,72(sp)
    80004e60:	79e2                	ld	s3,56(sp)
    80004e62:	6be2                	ld	s7,24(sp)
    80004e64:	6c42                	ld	s8,16(sp)
    80004e66:	6ca2                	ld	s9,8(sp)
    80004e68:	a801                	j	80004e78 <filewrite+0x10a>
    int i = 0;
    80004e6a:	4a01                	li	s4,0
    80004e6c:	a031                	j	80004e78 <filewrite+0x10a>
    80004e6e:	64a6                	ld	s1,72(sp)
    80004e70:	79e2                	ld	s3,56(sp)
    80004e72:	6be2                	ld	s7,24(sp)
    80004e74:	6c42                	ld	s8,16(sp)
    80004e76:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004e78:	034a9f63          	bne	s5,s4,80004eb6 <filewrite+0x148>
    80004e7c:	8556                	mv	a0,s5
    80004e7e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e80:	60e6                	ld	ra,88(sp)
    80004e82:	6446                	ld	s0,80(sp)
    80004e84:	6906                	ld	s2,64(sp)
    80004e86:	7aa2                	ld	s5,40(sp)
    80004e88:	7b02                	ld	s6,32(sp)
    80004e8a:	6125                	addi	sp,sp,96
    80004e8c:	8082                	ret
    80004e8e:	e4a6                	sd	s1,72(sp)
    80004e90:	fc4e                	sd	s3,56(sp)
    80004e92:	f852                	sd	s4,48(sp)
    80004e94:	ec5e                	sd	s7,24(sp)
    80004e96:	e862                	sd	s8,16(sp)
    80004e98:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004e9a:	00003517          	auipc	a0,0x3
    80004e9e:	70650513          	addi	a0,a0,1798 # 800085a0 <etext+0x5a0>
    80004ea2:	ffffb097          	auipc	ra,0xffffb
    80004ea6:	6be080e7          	jalr	1726(ra) # 80000560 <panic>
    return -1;
    80004eaa:	557d                	li	a0,-1
}
    80004eac:	8082                	ret
      return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	bfc1                	j	80004e80 <filewrite+0x112>
    80004eb2:	557d                	li	a0,-1
    80004eb4:	b7f1                	j	80004e80 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80004eb6:	557d                	li	a0,-1
    80004eb8:	7a42                	ld	s4,48(sp)
    80004eba:	b7d9                	j	80004e80 <filewrite+0x112>

0000000080004ebc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004ebc:	7179                	addi	sp,sp,-48
    80004ebe:	f406                	sd	ra,40(sp)
    80004ec0:	f022                	sd	s0,32(sp)
    80004ec2:	ec26                	sd	s1,24(sp)
    80004ec4:	e052                	sd	s4,0(sp)
    80004ec6:	1800                	addi	s0,sp,48
    80004ec8:	84aa                	mv	s1,a0
    80004eca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ecc:	0005b023          	sd	zero,0(a1)
    80004ed0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ed4:	00000097          	auipc	ra,0x0
    80004ed8:	bb8080e7          	jalr	-1096(ra) # 80004a8c <filealloc>
    80004edc:	e088                	sd	a0,0(s1)
    80004ede:	cd49                	beqz	a0,80004f78 <pipealloc+0xbc>
    80004ee0:	00000097          	auipc	ra,0x0
    80004ee4:	bac080e7          	jalr	-1108(ra) # 80004a8c <filealloc>
    80004ee8:	00aa3023          	sd	a0,0(s4)
    80004eec:	c141                	beqz	a0,80004f6c <pipealloc+0xb0>
    80004eee:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ef0:	ffffc097          	auipc	ra,0xffffc
    80004ef4:	c5a080e7          	jalr	-934(ra) # 80000b4a <kalloc>
    80004ef8:	892a                	mv	s2,a0
    80004efa:	c13d                	beqz	a0,80004f60 <pipealloc+0xa4>
    80004efc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004efe:	4985                	li	s3,1
    80004f00:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f04:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f08:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f0c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f10:	00003597          	auipc	a1,0x3
    80004f14:	6a058593          	addi	a1,a1,1696 # 800085b0 <etext+0x5b0>
    80004f18:	ffffc097          	auipc	ra,0xffffc
    80004f1c:	c92080e7          	jalr	-878(ra) # 80000baa <initlock>
  (*f0)->type = FD_PIPE;
    80004f20:	609c                	ld	a5,0(s1)
    80004f22:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f26:	609c                	ld	a5,0(s1)
    80004f28:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f2c:	609c                	ld	a5,0(s1)
    80004f2e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f32:	609c                	ld	a5,0(s1)
    80004f34:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f38:	000a3783          	ld	a5,0(s4)
    80004f3c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f40:	000a3783          	ld	a5,0(s4)
    80004f44:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f48:	000a3783          	ld	a5,0(s4)
    80004f4c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f50:	000a3783          	ld	a5,0(s4)
    80004f54:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f58:	4501                	li	a0,0
    80004f5a:	6942                	ld	s2,16(sp)
    80004f5c:	69a2                	ld	s3,8(sp)
    80004f5e:	a03d                	j	80004f8c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f60:	6088                	ld	a0,0(s1)
    80004f62:	c119                	beqz	a0,80004f68 <pipealloc+0xac>
    80004f64:	6942                	ld	s2,16(sp)
    80004f66:	a029                	j	80004f70 <pipealloc+0xb4>
    80004f68:	6942                	ld	s2,16(sp)
    80004f6a:	a039                	j	80004f78 <pipealloc+0xbc>
    80004f6c:	6088                	ld	a0,0(s1)
    80004f6e:	c50d                	beqz	a0,80004f98 <pipealloc+0xdc>
    fileclose(*f0);
    80004f70:	00000097          	auipc	ra,0x0
    80004f74:	bd8080e7          	jalr	-1064(ra) # 80004b48 <fileclose>
  if(*f1)
    80004f78:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f7c:	557d                	li	a0,-1
  if(*f1)
    80004f7e:	c799                	beqz	a5,80004f8c <pipealloc+0xd0>
    fileclose(*f1);
    80004f80:	853e                	mv	a0,a5
    80004f82:	00000097          	auipc	ra,0x0
    80004f86:	bc6080e7          	jalr	-1082(ra) # 80004b48 <fileclose>
  return -1;
    80004f8a:	557d                	li	a0,-1
}
    80004f8c:	70a2                	ld	ra,40(sp)
    80004f8e:	7402                	ld	s0,32(sp)
    80004f90:	64e2                	ld	s1,24(sp)
    80004f92:	6a02                	ld	s4,0(sp)
    80004f94:	6145                	addi	sp,sp,48
    80004f96:	8082                	ret
  return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	bfcd                	j	80004f8c <pipealloc+0xd0>

0000000080004f9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f9c:	1101                	addi	sp,sp,-32
    80004f9e:	ec06                	sd	ra,24(sp)
    80004fa0:	e822                	sd	s0,16(sp)
    80004fa2:	e426                	sd	s1,8(sp)
    80004fa4:	e04a                	sd	s2,0(sp)
    80004fa6:	1000                	addi	s0,sp,32
    80004fa8:	84aa                	mv	s1,a0
    80004faa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	c92080e7          	jalr	-878(ra) # 80000c3e <acquire>
  if(writable){
    80004fb4:	02090d63          	beqz	s2,80004fee <pipeclose+0x52>
    pi->writeopen = 0;
    80004fb8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004fbc:	21848513          	addi	a0,s1,536
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	304080e7          	jalr	772(ra) # 800022c4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004fc8:	2204b783          	ld	a5,544(s1)
    80004fcc:	eb95                	bnez	a5,80005000 <pipeclose+0x64>
    release(&pi->lock);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	ffffc097          	auipc	ra,0xffffc
    80004fd4:	d1e080e7          	jalr	-738(ra) # 80000cee <release>
    kfree((char*)pi);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	a72080e7          	jalr	-1422(ra) # 80000a4c <kfree>
  } else
    release(&pi->lock);
}
    80004fe2:	60e2                	ld	ra,24(sp)
    80004fe4:	6442                	ld	s0,16(sp)
    80004fe6:	64a2                	ld	s1,8(sp)
    80004fe8:	6902                	ld	s2,0(sp)
    80004fea:	6105                	addi	sp,sp,32
    80004fec:	8082                	ret
    pi->readopen = 0;
    80004fee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ff2:	21c48513          	addi	a0,s1,540
    80004ff6:	ffffd097          	auipc	ra,0xffffd
    80004ffa:	2ce080e7          	jalr	718(ra) # 800022c4 <wakeup>
    80004ffe:	b7e9                	j	80004fc8 <pipeclose+0x2c>
    release(&pi->lock);
    80005000:	8526                	mv	a0,s1
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	cec080e7          	jalr	-788(ra) # 80000cee <release>
}
    8000500a:	bfe1                	j	80004fe2 <pipeclose+0x46>

000000008000500c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000500c:	7159                	addi	sp,sp,-112
    8000500e:	f486                	sd	ra,104(sp)
    80005010:	f0a2                	sd	s0,96(sp)
    80005012:	eca6                	sd	s1,88(sp)
    80005014:	e8ca                	sd	s2,80(sp)
    80005016:	e4ce                	sd	s3,72(sp)
    80005018:	e0d2                	sd	s4,64(sp)
    8000501a:	fc56                	sd	s5,56(sp)
    8000501c:	1880                	addi	s0,sp,112
    8000501e:	84aa                	mv	s1,a0
    80005020:	8aae                	mv	s5,a1
    80005022:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	a44080e7          	jalr	-1468(ra) # 80001a68 <myproc>
    8000502c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000502e:	8526                	mv	a0,s1
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	c0e080e7          	jalr	-1010(ra) # 80000c3e <acquire>
  while(i < n){
    80005038:	0f405063          	blez	s4,80005118 <pipewrite+0x10c>
    8000503c:	f85a                	sd	s6,48(sp)
    8000503e:	f45e                	sd	s7,40(sp)
    80005040:	f062                	sd	s8,32(sp)
    80005042:	ec66                	sd	s9,24(sp)
    80005044:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005046:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005048:	f9f40c13          	addi	s8,s0,-97
    8000504c:	4b85                	li	s7,1
    8000504e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005050:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005054:	21c48c93          	addi	s9,s1,540
    80005058:	a099                	j	8000509e <pipewrite+0x92>
      release(&pi->lock);
    8000505a:	8526                	mv	a0,s1
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	c92080e7          	jalr	-878(ra) # 80000cee <release>
      return -1;
    80005064:	597d                	li	s2,-1
    80005066:	7b42                	ld	s6,48(sp)
    80005068:	7ba2                	ld	s7,40(sp)
    8000506a:	7c02                	ld	s8,32(sp)
    8000506c:	6ce2                	ld	s9,24(sp)
    8000506e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005070:	854a                	mv	a0,s2
    80005072:	70a6                	ld	ra,104(sp)
    80005074:	7406                	ld	s0,96(sp)
    80005076:	64e6                	ld	s1,88(sp)
    80005078:	6946                	ld	s2,80(sp)
    8000507a:	69a6                	ld	s3,72(sp)
    8000507c:	6a06                	ld	s4,64(sp)
    8000507e:	7ae2                	ld	s5,56(sp)
    80005080:	6165                	addi	sp,sp,112
    80005082:	8082                	ret
      wakeup(&pi->nread);
    80005084:	856a                	mv	a0,s10
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	23e080e7          	jalr	574(ra) # 800022c4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000508e:	85a6                	mv	a1,s1
    80005090:	8566                	mv	a0,s9
    80005092:	ffffd097          	auipc	ra,0xffffd
    80005096:	1ce080e7          	jalr	462(ra) # 80002260 <sleep>
  while(i < n){
    8000509a:	05495e63          	bge	s2,s4,800050f6 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    8000509e:	2204a783          	lw	a5,544(s1)
    800050a2:	dfc5                	beqz	a5,8000505a <pipewrite+0x4e>
    800050a4:	854e                	mv	a0,s3
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	49c080e7          	jalr	1180(ra) # 80002542 <killed>
    800050ae:	f555                	bnez	a0,8000505a <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050b0:	2184a783          	lw	a5,536(s1)
    800050b4:	21c4a703          	lw	a4,540(s1)
    800050b8:	2007879b          	addiw	a5,a5,512
    800050bc:	fcf704e3          	beq	a4,a5,80005084 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050c0:	86de                	mv	a3,s7
    800050c2:	01590633          	add	a2,s2,s5
    800050c6:	85e2                	mv	a1,s8
    800050c8:	0509b503          	ld	a0,80(s3)
    800050cc:	ffffc097          	auipc	ra,0xffffc
    800050d0:	6d0080e7          	jalr	1744(ra) # 8000179c <copyin>
    800050d4:	05650463          	beq	a0,s6,8000511c <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800050d8:	21c4a783          	lw	a5,540(s1)
    800050dc:	0017871b          	addiw	a4,a5,1
    800050e0:	20e4ae23          	sw	a4,540(s1)
    800050e4:	1ff7f793          	andi	a5,a5,511
    800050e8:	97a6                	add	a5,a5,s1
    800050ea:	f9f44703          	lbu	a4,-97(s0)
    800050ee:	00e78c23          	sb	a4,24(a5)
      i++;
    800050f2:	2905                	addiw	s2,s2,1
    800050f4:	b75d                	j	8000509a <pipewrite+0x8e>
    800050f6:	7b42                	ld	s6,48(sp)
    800050f8:	7ba2                	ld	s7,40(sp)
    800050fa:	7c02                	ld	s8,32(sp)
    800050fc:	6ce2                	ld	s9,24(sp)
    800050fe:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005100:	21848513          	addi	a0,s1,536
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	1c0080e7          	jalr	448(ra) # 800022c4 <wakeup>
  release(&pi->lock);
    8000510c:	8526                	mv	a0,s1
    8000510e:	ffffc097          	auipc	ra,0xffffc
    80005112:	be0080e7          	jalr	-1056(ra) # 80000cee <release>
  return i;
    80005116:	bfa9                	j	80005070 <pipewrite+0x64>
  int i = 0;
    80005118:	4901                	li	s2,0
    8000511a:	b7dd                	j	80005100 <pipewrite+0xf4>
    8000511c:	7b42                	ld	s6,48(sp)
    8000511e:	7ba2                	ld	s7,40(sp)
    80005120:	7c02                	ld	s8,32(sp)
    80005122:	6ce2                	ld	s9,24(sp)
    80005124:	6d42                	ld	s10,16(sp)
    80005126:	bfe9                	j	80005100 <pipewrite+0xf4>

0000000080005128 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005128:	711d                	addi	sp,sp,-96
    8000512a:	ec86                	sd	ra,88(sp)
    8000512c:	e8a2                	sd	s0,80(sp)
    8000512e:	e4a6                	sd	s1,72(sp)
    80005130:	e0ca                	sd	s2,64(sp)
    80005132:	fc4e                	sd	s3,56(sp)
    80005134:	f852                	sd	s4,48(sp)
    80005136:	f456                	sd	s5,40(sp)
    80005138:	1080                	addi	s0,sp,96
    8000513a:	84aa                	mv	s1,a0
    8000513c:	892e                	mv	s2,a1
    8000513e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005140:	ffffd097          	auipc	ra,0xffffd
    80005144:	928080e7          	jalr	-1752(ra) # 80001a68 <myproc>
    80005148:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000514a:	8526                	mv	a0,s1
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	af2080e7          	jalr	-1294(ra) # 80000c3e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005154:	2184a703          	lw	a4,536(s1)
    80005158:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000515c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005160:	02f71b63          	bne	a4,a5,80005196 <piperead+0x6e>
    80005164:	2244a783          	lw	a5,548(s1)
    80005168:	c3b1                	beqz	a5,800051ac <piperead+0x84>
    if(killed(pr)){
    8000516a:	8552                	mv	a0,s4
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	3d6080e7          	jalr	982(ra) # 80002542 <killed>
    80005174:	e50d                	bnez	a0,8000519e <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005176:	85a6                	mv	a1,s1
    80005178:	854e                	mv	a0,s3
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	0e6080e7          	jalr	230(ra) # 80002260 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005182:	2184a703          	lw	a4,536(s1)
    80005186:	21c4a783          	lw	a5,540(s1)
    8000518a:	fcf70de3          	beq	a4,a5,80005164 <piperead+0x3c>
    8000518e:	f05a                	sd	s6,32(sp)
    80005190:	ec5e                	sd	s7,24(sp)
    80005192:	e862                	sd	s8,16(sp)
    80005194:	a839                	j	800051b2 <piperead+0x8a>
    80005196:	f05a                	sd	s6,32(sp)
    80005198:	ec5e                	sd	s7,24(sp)
    8000519a:	e862                	sd	s8,16(sp)
    8000519c:	a819                	j	800051b2 <piperead+0x8a>
      release(&pi->lock);
    8000519e:	8526                	mv	a0,s1
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	b4e080e7          	jalr	-1202(ra) # 80000cee <release>
      return -1;
    800051a8:	59fd                	li	s3,-1
    800051aa:	a895                	j	8000521e <piperead+0xf6>
    800051ac:	f05a                	sd	s6,32(sp)
    800051ae:	ec5e                	sd	s7,24(sp)
    800051b0:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051b2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051b4:	faf40c13          	addi	s8,s0,-81
    800051b8:	4b85                	li	s7,1
    800051ba:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051bc:	05505363          	blez	s5,80005202 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    800051c0:	2184a783          	lw	a5,536(s1)
    800051c4:	21c4a703          	lw	a4,540(s1)
    800051c8:	02f70d63          	beq	a4,a5,80005202 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051cc:	0017871b          	addiw	a4,a5,1
    800051d0:	20e4ac23          	sw	a4,536(s1)
    800051d4:	1ff7f793          	andi	a5,a5,511
    800051d8:	97a6                	add	a5,a5,s1
    800051da:	0187c783          	lbu	a5,24(a5)
    800051de:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051e2:	86de                	mv	a3,s7
    800051e4:	8662                	mv	a2,s8
    800051e6:	85ca                	mv	a1,s2
    800051e8:	050a3503          	ld	a0,80(s4)
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	524080e7          	jalr	1316(ra) # 80001710 <copyout>
    800051f4:	01650763          	beq	a0,s6,80005202 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051f8:	2985                	addiw	s3,s3,1
    800051fa:	0905                	addi	s2,s2,1
    800051fc:	fd3a92e3          	bne	s5,s3,800051c0 <piperead+0x98>
    80005200:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005202:	21c48513          	addi	a0,s1,540
    80005206:	ffffd097          	auipc	ra,0xffffd
    8000520a:	0be080e7          	jalr	190(ra) # 800022c4 <wakeup>
  release(&pi->lock);
    8000520e:	8526                	mv	a0,s1
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	ade080e7          	jalr	-1314(ra) # 80000cee <release>
    80005218:	7b02                	ld	s6,32(sp)
    8000521a:	6be2                	ld	s7,24(sp)
    8000521c:	6c42                	ld	s8,16(sp)
  return i;
}
    8000521e:	854e                	mv	a0,s3
    80005220:	60e6                	ld	ra,88(sp)
    80005222:	6446                	ld	s0,80(sp)
    80005224:	64a6                	ld	s1,72(sp)
    80005226:	6906                	ld	s2,64(sp)
    80005228:	79e2                	ld	s3,56(sp)
    8000522a:	7a42                	ld	s4,48(sp)
    8000522c:	7aa2                	ld	s5,40(sp)
    8000522e:	6125                	addi	sp,sp,96
    80005230:	8082                	ret

0000000080005232 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005232:	1141                	addi	sp,sp,-16
    80005234:	e406                	sd	ra,8(sp)
    80005236:	e022                	sd	s0,0(sp)
    80005238:	0800                	addi	s0,sp,16
    8000523a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000523c:	0035151b          	slliw	a0,a0,0x3
    80005240:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005242:	8b89                	andi	a5,a5,2
    80005244:	c399                	beqz	a5,8000524a <flags2perm+0x18>
      perm |= PTE_W;
    80005246:	00456513          	ori	a0,a0,4
    return perm;
}
    8000524a:	60a2                	ld	ra,8(sp)
    8000524c:	6402                	ld	s0,0(sp)
    8000524e:	0141                	addi	sp,sp,16
    80005250:	8082                	ret

0000000080005252 <exec>:

int
exec(char *path, char **argv)
{
    80005252:	de010113          	addi	sp,sp,-544
    80005256:	20113c23          	sd	ra,536(sp)
    8000525a:	20813823          	sd	s0,528(sp)
    8000525e:	20913423          	sd	s1,520(sp)
    80005262:	21213023          	sd	s2,512(sp)
    80005266:	1400                	addi	s0,sp,544
    80005268:	892a                	mv	s2,a0
    8000526a:	dea43823          	sd	a0,-528(s0)
    8000526e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	7f6080e7          	jalr	2038(ra) # 80001a68 <myproc>
    8000527a:	84aa                	mv	s1,a0

  begin_op();
    8000527c:	fffff097          	auipc	ra,0xfffff
    80005280:	3fc080e7          	jalr	1020(ra) # 80004678 <begin_op>

  if((ip = namei(path)) == 0){
    80005284:	854a                	mv	a0,s2
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	1ec080e7          	jalr	492(ra) # 80004472 <namei>
    8000528e:	c525                	beqz	a0,800052f6 <exec+0xa4>
    80005290:	fbd2                	sd	s4,496(sp)
    80005292:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	9fa080e7          	jalr	-1542(ra) # 80003c8e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000529c:	04000713          	li	a4,64
    800052a0:	4681                	li	a3,0
    800052a2:	e5040613          	addi	a2,s0,-432
    800052a6:	4581                	li	a1,0
    800052a8:	8552                	mv	a0,s4
    800052aa:	fffff097          	auipc	ra,0xfffff
    800052ae:	ca0080e7          	jalr	-864(ra) # 80003f4a <readi>
    800052b2:	04000793          	li	a5,64
    800052b6:	00f51a63          	bne	a0,a5,800052ca <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800052ba:	e5042703          	lw	a4,-432(s0)
    800052be:	464c47b7          	lui	a5,0x464c4
    800052c2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800052c6:	02f70e63          	beq	a4,a5,80005302 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800052ca:	8552                	mv	a0,s4
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	c28080e7          	jalr	-984(ra) # 80003ef4 <iunlockput>
    end_op();
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	41e080e7          	jalr	1054(ra) # 800046f2 <end_op>
  }
  return -1;
    800052dc:	557d                	li	a0,-1
    800052de:	7a5e                	ld	s4,496(sp)
}
    800052e0:	21813083          	ld	ra,536(sp)
    800052e4:	21013403          	ld	s0,528(sp)
    800052e8:	20813483          	ld	s1,520(sp)
    800052ec:	20013903          	ld	s2,512(sp)
    800052f0:	22010113          	addi	sp,sp,544
    800052f4:	8082                	ret
    end_op();
    800052f6:	fffff097          	auipc	ra,0xfffff
    800052fa:	3fc080e7          	jalr	1020(ra) # 800046f2 <end_op>
    return -1;
    800052fe:	557d                	li	a0,-1
    80005300:	b7c5                	j	800052e0 <exec+0x8e>
    80005302:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005304:	8526                	mv	a0,s1
    80005306:	ffffd097          	auipc	ra,0xffffd
    8000530a:	826080e7          	jalr	-2010(ra) # 80001b2c <proc_pagetable>
    8000530e:	8b2a                	mv	s6,a0
    80005310:	2c050163          	beqz	a0,800055d2 <exec+0x380>
    80005314:	ffce                	sd	s3,504(sp)
    80005316:	f7d6                	sd	s5,488(sp)
    80005318:	efde                	sd	s7,472(sp)
    8000531a:	ebe2                	sd	s8,464(sp)
    8000531c:	e7e6                	sd	s9,456(sp)
    8000531e:	e3ea                	sd	s10,448(sp)
    80005320:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005322:	e7042683          	lw	a3,-400(s0)
    80005326:	e8845783          	lhu	a5,-376(s0)
    8000532a:	10078363          	beqz	a5,80005430 <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000532e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005330:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005332:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005336:	6c85                	lui	s9,0x1
    80005338:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000533c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005340:	6a85                	lui	s5,0x1
    80005342:	a0b5                	j	800053ae <exec+0x15c>
      panic("loadseg: address should exist");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	27450513          	addi	a0,a0,628 # 800085b8 <etext+0x5b8>
    8000534c:	ffffb097          	auipc	ra,0xffffb
    80005350:	214080e7          	jalr	532(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005354:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005356:	874a                	mv	a4,s2
    80005358:	009c06bb          	addw	a3,s8,s1
    8000535c:	4581                	li	a1,0
    8000535e:	8552                	mv	a0,s4
    80005360:	fffff097          	auipc	ra,0xfffff
    80005364:	bea080e7          	jalr	-1046(ra) # 80003f4a <readi>
    80005368:	26a91963          	bne	s2,a0,800055da <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000536c:	009a84bb          	addw	s1,s5,s1
    80005370:	0334f463          	bgeu	s1,s3,80005398 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005374:	02049593          	slli	a1,s1,0x20
    80005378:	9181                	srli	a1,a1,0x20
    8000537a:	95de                	add	a1,a1,s7
    8000537c:	855a                	mv	a0,s6
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	d5a080e7          	jalr	-678(ra) # 800010d8 <walkaddr>
    80005386:	862a                	mv	a2,a0
    if(pa == 0)
    80005388:	dd55                	beqz	a0,80005344 <exec+0xf2>
    if(sz - i < PGSIZE)
    8000538a:	409987bb          	subw	a5,s3,s1
    8000538e:	893e                	mv	s2,a5
    80005390:	fcfcf2e3          	bgeu	s9,a5,80005354 <exec+0x102>
    80005394:	8956                	mv	s2,s5
    80005396:	bf7d                	j	80005354 <exec+0x102>
    sz = sz1;
    80005398:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000539c:	2d05                	addiw	s10,s10,1
    8000539e:	e0843783          	ld	a5,-504(s0)
    800053a2:	0387869b          	addiw	a3,a5,56
    800053a6:	e8845783          	lhu	a5,-376(s0)
    800053aa:	08fd5463          	bge	s10,a5,80005432 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053ae:	e0d43423          	sd	a3,-504(s0)
    800053b2:	876e                	mv	a4,s11
    800053b4:	e1840613          	addi	a2,s0,-488
    800053b8:	4581                	li	a1,0
    800053ba:	8552                	mv	a0,s4
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	b8e080e7          	jalr	-1138(ra) # 80003f4a <readi>
    800053c4:	21b51963          	bne	a0,s11,800055d6 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    800053c8:	e1842783          	lw	a5,-488(s0)
    800053cc:	4705                	li	a4,1
    800053ce:	fce797e3          	bne	a5,a4,8000539c <exec+0x14a>
    if(ph.memsz < ph.filesz)
    800053d2:	e4043483          	ld	s1,-448(s0)
    800053d6:	e3843783          	ld	a5,-456(s0)
    800053da:	22f4e063          	bltu	s1,a5,800055fa <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053de:	e2843783          	ld	a5,-472(s0)
    800053e2:	94be                	add	s1,s1,a5
    800053e4:	20f4ee63          	bltu	s1,a5,80005600 <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    800053e8:	de843703          	ld	a4,-536(s0)
    800053ec:	8ff9                	and	a5,a5,a4
    800053ee:	20079c63          	bnez	a5,80005606 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800053f2:	e1c42503          	lw	a0,-484(s0)
    800053f6:	00000097          	auipc	ra,0x0
    800053fa:	e3c080e7          	jalr	-452(ra) # 80005232 <flags2perm>
    800053fe:	86aa                	mv	a3,a0
    80005400:	8626                	mv	a2,s1
    80005402:	85ca                	mv	a1,s2
    80005404:	855a                	mv	a0,s6
    80005406:	ffffc097          	auipc	ra,0xffffc
    8000540a:	096080e7          	jalr	150(ra) # 8000149c <uvmalloc>
    8000540e:	dea43c23          	sd	a0,-520(s0)
    80005412:	1e050d63          	beqz	a0,8000560c <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005416:	e2843b83          	ld	s7,-472(s0)
    8000541a:	e2042c03          	lw	s8,-480(s0)
    8000541e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005422:	00098463          	beqz	s3,8000542a <exec+0x1d8>
    80005426:	4481                	li	s1,0
    80005428:	b7b1                	j	80005374 <exec+0x122>
    sz = sz1;
    8000542a:	df843903          	ld	s2,-520(s0)
    8000542e:	b7bd                	j	8000539c <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005430:	4901                	li	s2,0
  iunlockput(ip);
    80005432:	8552                	mv	a0,s4
    80005434:	fffff097          	auipc	ra,0xfffff
    80005438:	ac0080e7          	jalr	-1344(ra) # 80003ef4 <iunlockput>
  end_op();
    8000543c:	fffff097          	auipc	ra,0xfffff
    80005440:	2b6080e7          	jalr	694(ra) # 800046f2 <end_op>
  p = myproc();
    80005444:	ffffc097          	auipc	ra,0xffffc
    80005448:	624080e7          	jalr	1572(ra) # 80001a68 <myproc>
    8000544c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000544e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005452:	6985                	lui	s3,0x1
    80005454:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005456:	99ca                	add	s3,s3,s2
    80005458:	77fd                	lui	a5,0xfffff
    8000545a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000545e:	4691                	li	a3,4
    80005460:	6609                	lui	a2,0x2
    80005462:	964e                	add	a2,a2,s3
    80005464:	85ce                	mv	a1,s3
    80005466:	855a                	mv	a0,s6
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	034080e7          	jalr	52(ra) # 8000149c <uvmalloc>
    80005470:	8a2a                	mv	s4,a0
    80005472:	e115                	bnez	a0,80005496 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005474:	85ce                	mv	a1,s3
    80005476:	855a                	mv	a0,s6
    80005478:	ffffc097          	auipc	ra,0xffffc
    8000547c:	750080e7          	jalr	1872(ra) # 80001bc8 <proc_freepagetable>
  return -1;
    80005480:	557d                	li	a0,-1
    80005482:	79fe                	ld	s3,504(sp)
    80005484:	7a5e                	ld	s4,496(sp)
    80005486:	7abe                	ld	s5,488(sp)
    80005488:	7b1e                	ld	s6,480(sp)
    8000548a:	6bfe                	ld	s7,472(sp)
    8000548c:	6c5e                	ld	s8,464(sp)
    8000548e:	6cbe                	ld	s9,456(sp)
    80005490:	6d1e                	ld	s10,448(sp)
    80005492:	7dfa                	ld	s11,440(sp)
    80005494:	b5b1                	j	800052e0 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005496:	75f9                	lui	a1,0xffffe
    80005498:	95aa                	add	a1,a1,a0
    8000549a:	855a                	mv	a0,s6
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	242080e7          	jalr	578(ra) # 800016de <uvmclear>
  stackbase = sp - PGSIZE;
    800054a4:	7bfd                	lui	s7,0xfffff
    800054a6:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800054a8:	e0043783          	ld	a5,-512(s0)
    800054ac:	6388                	ld	a0,0(a5)
  sp = sz;
    800054ae:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800054b0:	4481                	li	s1,0
    ustack[argc] = sp;
    800054b2:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800054b6:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800054ba:	c135                	beqz	a0,8000551e <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    800054bc:	ffffc097          	auipc	ra,0xffffc
    800054c0:	a06080e7          	jalr	-1530(ra) # 80000ec2 <strlen>
    800054c4:	0015079b          	addiw	a5,a0,1
    800054c8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800054cc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800054d0:	15796163          	bltu	s2,s7,80005612 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800054d4:	e0043d83          	ld	s11,-512(s0)
    800054d8:	000db983          	ld	s3,0(s11)
    800054dc:	854e                	mv	a0,s3
    800054de:	ffffc097          	auipc	ra,0xffffc
    800054e2:	9e4080e7          	jalr	-1564(ra) # 80000ec2 <strlen>
    800054e6:	0015069b          	addiw	a3,a0,1
    800054ea:	864e                	mv	a2,s3
    800054ec:	85ca                	mv	a1,s2
    800054ee:	855a                	mv	a0,s6
    800054f0:	ffffc097          	auipc	ra,0xffffc
    800054f4:	220080e7          	jalr	544(ra) # 80001710 <copyout>
    800054f8:	10054f63          	bltz	a0,80005616 <exec+0x3c4>
    ustack[argc] = sp;
    800054fc:	00349793          	slli	a5,s1,0x3
    80005500:	97e6                	add	a5,a5,s9
    80005502:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffda090>
  for(argc = 0; argv[argc]; argc++) {
    80005506:	0485                	addi	s1,s1,1
    80005508:	008d8793          	addi	a5,s11,8
    8000550c:	e0f43023          	sd	a5,-512(s0)
    80005510:	008db503          	ld	a0,8(s11)
    80005514:	c509                	beqz	a0,8000551e <exec+0x2cc>
    if(argc >= MAXARG)
    80005516:	fb8493e3          	bne	s1,s8,800054bc <exec+0x26a>
  sz = sz1;
    8000551a:	89d2                	mv	s3,s4
    8000551c:	bfa1                	j	80005474 <exec+0x222>
  ustack[argc] = 0;
    8000551e:	00349793          	slli	a5,s1,0x3
    80005522:	f9078793          	addi	a5,a5,-112
    80005526:	97a2                	add	a5,a5,s0
    80005528:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000552c:	00148693          	addi	a3,s1,1
    80005530:	068e                	slli	a3,a3,0x3
    80005532:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005536:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000553a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000553c:	f3796ce3          	bltu	s2,s7,80005474 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005540:	e9040613          	addi	a2,s0,-368
    80005544:	85ca                	mv	a1,s2
    80005546:	855a                	mv	a0,s6
    80005548:	ffffc097          	auipc	ra,0xffffc
    8000554c:	1c8080e7          	jalr	456(ra) # 80001710 <copyout>
    80005550:	f20542e3          	bltz	a0,80005474 <exec+0x222>
  p->trapframe->a1 = sp;
    80005554:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005558:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000555c:	df043783          	ld	a5,-528(s0)
    80005560:	0007c703          	lbu	a4,0(a5)
    80005564:	cf11                	beqz	a4,80005580 <exec+0x32e>
    80005566:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005568:	02f00693          	li	a3,47
    8000556c:	a029                	j	80005576 <exec+0x324>
  for(last=s=path; *s; s++)
    8000556e:	0785                	addi	a5,a5,1
    80005570:	fff7c703          	lbu	a4,-1(a5)
    80005574:	c711                	beqz	a4,80005580 <exec+0x32e>
    if(*s == '/')
    80005576:	fed71ce3          	bne	a4,a3,8000556e <exec+0x31c>
      last = s+1;
    8000557a:	def43823          	sd	a5,-528(s0)
    8000557e:	bfc5                	j	8000556e <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005580:	4641                	li	a2,16
    80005582:	df043583          	ld	a1,-528(s0)
    80005586:	158a8513          	addi	a0,s5,344
    8000558a:	ffffc097          	auipc	ra,0xffffc
    8000558e:	902080e7          	jalr	-1790(ra) # 80000e8c <safestrcpy>
  oldpagetable = p->pagetable;
    80005592:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005596:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000559a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000559e:	058ab783          	ld	a5,88(s5)
    800055a2:	e6843703          	ld	a4,-408(s0)
    800055a6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800055a8:	058ab783          	ld	a5,88(s5)
    800055ac:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800055b0:	85ea                	mv	a1,s10
    800055b2:	ffffc097          	auipc	ra,0xffffc
    800055b6:	616080e7          	jalr	1558(ra) # 80001bc8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800055ba:	0004851b          	sext.w	a0,s1
    800055be:	79fe                	ld	s3,504(sp)
    800055c0:	7a5e                	ld	s4,496(sp)
    800055c2:	7abe                	ld	s5,488(sp)
    800055c4:	7b1e                	ld	s6,480(sp)
    800055c6:	6bfe                	ld	s7,472(sp)
    800055c8:	6c5e                	ld	s8,464(sp)
    800055ca:	6cbe                	ld	s9,456(sp)
    800055cc:	6d1e                	ld	s10,448(sp)
    800055ce:	7dfa                	ld	s11,440(sp)
    800055d0:	bb01                	j	800052e0 <exec+0x8e>
    800055d2:	7b1e                	ld	s6,480(sp)
    800055d4:	b9dd                	j	800052ca <exec+0x78>
    800055d6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800055da:	df843583          	ld	a1,-520(s0)
    800055de:	855a                	mv	a0,s6
    800055e0:	ffffc097          	auipc	ra,0xffffc
    800055e4:	5e8080e7          	jalr	1512(ra) # 80001bc8 <proc_freepagetable>
  if(ip){
    800055e8:	79fe                	ld	s3,504(sp)
    800055ea:	7abe                	ld	s5,488(sp)
    800055ec:	7b1e                	ld	s6,480(sp)
    800055ee:	6bfe                	ld	s7,472(sp)
    800055f0:	6c5e                	ld	s8,464(sp)
    800055f2:	6cbe                	ld	s9,456(sp)
    800055f4:	6d1e                	ld	s10,448(sp)
    800055f6:	7dfa                	ld	s11,440(sp)
    800055f8:	b9c9                	j	800052ca <exec+0x78>
    800055fa:	df243c23          	sd	s2,-520(s0)
    800055fe:	bff1                	j	800055da <exec+0x388>
    80005600:	df243c23          	sd	s2,-520(s0)
    80005604:	bfd9                	j	800055da <exec+0x388>
    80005606:	df243c23          	sd	s2,-520(s0)
    8000560a:	bfc1                	j	800055da <exec+0x388>
    8000560c:	df243c23          	sd	s2,-520(s0)
    80005610:	b7e9                	j	800055da <exec+0x388>
  sz = sz1;
    80005612:	89d2                	mv	s3,s4
    80005614:	b585                	j	80005474 <exec+0x222>
    80005616:	89d2                	mv	s3,s4
    80005618:	bdb1                	j	80005474 <exec+0x222>

000000008000561a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000561a:	7179                	addi	sp,sp,-48
    8000561c:	f406                	sd	ra,40(sp)
    8000561e:	f022                	sd	s0,32(sp)
    80005620:	ec26                	sd	s1,24(sp)
    80005622:	e84a                	sd	s2,16(sp)
    80005624:	1800                	addi	s0,sp,48
    80005626:	892e                	mv	s2,a1
    80005628:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000562a:	fdc40593          	addi	a1,s0,-36
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	8de080e7          	jalr	-1826(ra) # 80002f0c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005636:	fdc42703          	lw	a4,-36(s0)
    8000563a:	47bd                	li	a5,15
    8000563c:	02e7eb63          	bltu	a5,a4,80005672 <argfd+0x58>
    80005640:	ffffc097          	auipc	ra,0xffffc
    80005644:	428080e7          	jalr	1064(ra) # 80001a68 <myproc>
    80005648:	fdc42703          	lw	a4,-36(s0)
    8000564c:	01a70793          	addi	a5,a4,26
    80005650:	078e                	slli	a5,a5,0x3
    80005652:	953e                	add	a0,a0,a5
    80005654:	611c                	ld	a5,0(a0)
    80005656:	c385                	beqz	a5,80005676 <argfd+0x5c>
    return -1;
  if(pfd)
    80005658:	00090463          	beqz	s2,80005660 <argfd+0x46>
    *pfd = fd;
    8000565c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005660:	4501                	li	a0,0
  if(pf)
    80005662:	c091                	beqz	s1,80005666 <argfd+0x4c>
    *pf = f;
    80005664:	e09c                	sd	a5,0(s1)
}
    80005666:	70a2                	ld	ra,40(sp)
    80005668:	7402                	ld	s0,32(sp)
    8000566a:	64e2                	ld	s1,24(sp)
    8000566c:	6942                	ld	s2,16(sp)
    8000566e:	6145                	addi	sp,sp,48
    80005670:	8082                	ret
    return -1;
    80005672:	557d                	li	a0,-1
    80005674:	bfcd                	j	80005666 <argfd+0x4c>
    80005676:	557d                	li	a0,-1
    80005678:	b7fd                	j	80005666 <argfd+0x4c>

000000008000567a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000567a:	1101                	addi	sp,sp,-32
    8000567c:	ec06                	sd	ra,24(sp)
    8000567e:	e822                	sd	s0,16(sp)
    80005680:	e426                	sd	s1,8(sp)
    80005682:	1000                	addi	s0,sp,32
    80005684:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005686:	ffffc097          	auipc	ra,0xffffc
    8000568a:	3e2080e7          	jalr	994(ra) # 80001a68 <myproc>
    8000568e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005690:	0d050793          	addi	a5,a0,208
    80005694:	4501                	li	a0,0
    80005696:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005698:	6398                	ld	a4,0(a5)
    8000569a:	cb19                	beqz	a4,800056b0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000569c:	2505                	addiw	a0,a0,1
    8000569e:	07a1                	addi	a5,a5,8
    800056a0:	fed51ce3          	bne	a0,a3,80005698 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800056a4:	557d                	li	a0,-1
}
    800056a6:	60e2                	ld	ra,24(sp)
    800056a8:	6442                	ld	s0,16(sp)
    800056aa:	64a2                	ld	s1,8(sp)
    800056ac:	6105                	addi	sp,sp,32
    800056ae:	8082                	ret
      p->ofile[fd] = f;
    800056b0:	01a50793          	addi	a5,a0,26
    800056b4:	078e                	slli	a5,a5,0x3
    800056b6:	963e                	add	a2,a2,a5
    800056b8:	e204                	sd	s1,0(a2)
      return fd;
    800056ba:	b7f5                	j	800056a6 <fdalloc+0x2c>

00000000800056bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800056bc:	715d                	addi	sp,sp,-80
    800056be:	e486                	sd	ra,72(sp)
    800056c0:	e0a2                	sd	s0,64(sp)
    800056c2:	fc26                	sd	s1,56(sp)
    800056c4:	f84a                	sd	s2,48(sp)
    800056c6:	f44e                	sd	s3,40(sp)
    800056c8:	ec56                	sd	s5,24(sp)
    800056ca:	e85a                	sd	s6,16(sp)
    800056cc:	0880                	addi	s0,sp,80
    800056ce:	8b2e                	mv	s6,a1
    800056d0:	89b2                	mv	s3,a2
    800056d2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800056d4:	fb040593          	addi	a1,s0,-80
    800056d8:	fffff097          	auipc	ra,0xfffff
    800056dc:	db8080e7          	jalr	-584(ra) # 80004490 <nameiparent>
    800056e0:	84aa                	mv	s1,a0
    800056e2:	14050e63          	beqz	a0,8000583e <create+0x182>
    return 0;

  ilock(dp);
    800056e6:	ffffe097          	auipc	ra,0xffffe
    800056ea:	5a8080e7          	jalr	1448(ra) # 80003c8e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800056ee:	4601                	li	a2,0
    800056f0:	fb040593          	addi	a1,s0,-80
    800056f4:	8526                	mv	a0,s1
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	a94080e7          	jalr	-1388(ra) # 8000418a <dirlookup>
    800056fe:	8aaa                	mv	s5,a0
    80005700:	c539                	beqz	a0,8000574e <create+0x92>
    iunlockput(dp);
    80005702:	8526                	mv	a0,s1
    80005704:	ffffe097          	auipc	ra,0xffffe
    80005708:	7f0080e7          	jalr	2032(ra) # 80003ef4 <iunlockput>
    ilock(ip);
    8000570c:	8556                	mv	a0,s5
    8000570e:	ffffe097          	auipc	ra,0xffffe
    80005712:	580080e7          	jalr	1408(ra) # 80003c8e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005716:	4789                	li	a5,2
    80005718:	02fb1463          	bne	s6,a5,80005740 <create+0x84>
    8000571c:	044ad783          	lhu	a5,68(s5)
    80005720:	37f9                	addiw	a5,a5,-2
    80005722:	17c2                	slli	a5,a5,0x30
    80005724:	93c1                	srli	a5,a5,0x30
    80005726:	4705                	li	a4,1
    80005728:	00f76c63          	bltu	a4,a5,80005740 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000572c:	8556                	mv	a0,s5
    8000572e:	60a6                	ld	ra,72(sp)
    80005730:	6406                	ld	s0,64(sp)
    80005732:	74e2                	ld	s1,56(sp)
    80005734:	7942                	ld	s2,48(sp)
    80005736:	79a2                	ld	s3,40(sp)
    80005738:	6ae2                	ld	s5,24(sp)
    8000573a:	6b42                	ld	s6,16(sp)
    8000573c:	6161                	addi	sp,sp,80
    8000573e:	8082                	ret
    iunlockput(ip);
    80005740:	8556                	mv	a0,s5
    80005742:	ffffe097          	auipc	ra,0xffffe
    80005746:	7b2080e7          	jalr	1970(ra) # 80003ef4 <iunlockput>
    return 0;
    8000574a:	4a81                	li	s5,0
    8000574c:	b7c5                	j	8000572c <create+0x70>
    8000574e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005750:	85da                	mv	a1,s6
    80005752:	4088                	lw	a0,0(s1)
    80005754:	ffffe097          	auipc	ra,0xffffe
    80005758:	396080e7          	jalr	918(ra) # 80003aea <ialloc>
    8000575c:	8a2a                	mv	s4,a0
    8000575e:	c531                	beqz	a0,800057aa <create+0xee>
  ilock(ip);
    80005760:	ffffe097          	auipc	ra,0xffffe
    80005764:	52e080e7          	jalr	1326(ra) # 80003c8e <ilock>
  ip->major = major;
    80005768:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000576c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005770:	4905                	li	s2,1
    80005772:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005776:	8552                	mv	a0,s4
    80005778:	ffffe097          	auipc	ra,0xffffe
    8000577c:	44a080e7          	jalr	1098(ra) # 80003bc2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005780:	032b0d63          	beq	s6,s2,800057ba <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005784:	004a2603          	lw	a2,4(s4)
    80005788:	fb040593          	addi	a1,s0,-80
    8000578c:	8526                	mv	a0,s1
    8000578e:	fffff097          	auipc	ra,0xfffff
    80005792:	c22080e7          	jalr	-990(ra) # 800043b0 <dirlink>
    80005796:	08054163          	bltz	a0,80005818 <create+0x15c>
  iunlockput(dp);
    8000579a:	8526                	mv	a0,s1
    8000579c:	ffffe097          	auipc	ra,0xffffe
    800057a0:	758080e7          	jalr	1880(ra) # 80003ef4 <iunlockput>
  return ip;
    800057a4:	8ad2                	mv	s5,s4
    800057a6:	7a02                	ld	s4,32(sp)
    800057a8:	b751                	j	8000572c <create+0x70>
    iunlockput(dp);
    800057aa:	8526                	mv	a0,s1
    800057ac:	ffffe097          	auipc	ra,0xffffe
    800057b0:	748080e7          	jalr	1864(ra) # 80003ef4 <iunlockput>
    return 0;
    800057b4:	8ad2                	mv	s5,s4
    800057b6:	7a02                	ld	s4,32(sp)
    800057b8:	bf95                	j	8000572c <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800057ba:	004a2603          	lw	a2,4(s4)
    800057be:	00003597          	auipc	a1,0x3
    800057c2:	e1a58593          	addi	a1,a1,-486 # 800085d8 <etext+0x5d8>
    800057c6:	8552                	mv	a0,s4
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	be8080e7          	jalr	-1048(ra) # 800043b0 <dirlink>
    800057d0:	04054463          	bltz	a0,80005818 <create+0x15c>
    800057d4:	40d0                	lw	a2,4(s1)
    800057d6:	00003597          	auipc	a1,0x3
    800057da:	e0a58593          	addi	a1,a1,-502 # 800085e0 <etext+0x5e0>
    800057de:	8552                	mv	a0,s4
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	bd0080e7          	jalr	-1072(ra) # 800043b0 <dirlink>
    800057e8:	02054863          	bltz	a0,80005818 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800057ec:	004a2603          	lw	a2,4(s4)
    800057f0:	fb040593          	addi	a1,s0,-80
    800057f4:	8526                	mv	a0,s1
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	bba080e7          	jalr	-1094(ra) # 800043b0 <dirlink>
    800057fe:	00054d63          	bltz	a0,80005818 <create+0x15c>
    dp->nlink++;  // for ".."
    80005802:	04a4d783          	lhu	a5,74(s1)
    80005806:	2785                	addiw	a5,a5,1
    80005808:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000580c:	8526                	mv	a0,s1
    8000580e:	ffffe097          	auipc	ra,0xffffe
    80005812:	3b4080e7          	jalr	948(ra) # 80003bc2 <iupdate>
    80005816:	b751                	j	8000579a <create+0xde>
  ip->nlink = 0;
    80005818:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000581c:	8552                	mv	a0,s4
    8000581e:	ffffe097          	auipc	ra,0xffffe
    80005822:	3a4080e7          	jalr	932(ra) # 80003bc2 <iupdate>
  iunlockput(ip);
    80005826:	8552                	mv	a0,s4
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	6cc080e7          	jalr	1740(ra) # 80003ef4 <iunlockput>
  iunlockput(dp);
    80005830:	8526                	mv	a0,s1
    80005832:	ffffe097          	auipc	ra,0xffffe
    80005836:	6c2080e7          	jalr	1730(ra) # 80003ef4 <iunlockput>
  return 0;
    8000583a:	7a02                	ld	s4,32(sp)
    8000583c:	bdc5                	j	8000572c <create+0x70>
    return 0;
    8000583e:	8aaa                	mv	s5,a0
    80005840:	b5f5                	j	8000572c <create+0x70>

0000000080005842 <sys_dup>:
{
    80005842:	7179                	addi	sp,sp,-48
    80005844:	f406                	sd	ra,40(sp)
    80005846:	f022                	sd	s0,32(sp)
    80005848:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000584a:	fd840613          	addi	a2,s0,-40
    8000584e:	4581                	li	a1,0
    80005850:	4501                	li	a0,0
    80005852:	00000097          	auipc	ra,0x0
    80005856:	dc8080e7          	jalr	-568(ra) # 8000561a <argfd>
    return -1;
    8000585a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000585c:	02054763          	bltz	a0,8000588a <sys_dup+0x48>
    80005860:	ec26                	sd	s1,24(sp)
    80005862:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005864:	fd843903          	ld	s2,-40(s0)
    80005868:	854a                	mv	a0,s2
    8000586a:	00000097          	auipc	ra,0x0
    8000586e:	e10080e7          	jalr	-496(ra) # 8000567a <fdalloc>
    80005872:	84aa                	mv	s1,a0
    return -1;
    80005874:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005876:	00054f63          	bltz	a0,80005894 <sys_dup+0x52>
  filedup(f);
    8000587a:	854a                	mv	a0,s2
    8000587c:	fffff097          	auipc	ra,0xfffff
    80005880:	27a080e7          	jalr	634(ra) # 80004af6 <filedup>
  return fd;
    80005884:	87a6                	mv	a5,s1
    80005886:	64e2                	ld	s1,24(sp)
    80005888:	6942                	ld	s2,16(sp)
}
    8000588a:	853e                	mv	a0,a5
    8000588c:	70a2                	ld	ra,40(sp)
    8000588e:	7402                	ld	s0,32(sp)
    80005890:	6145                	addi	sp,sp,48
    80005892:	8082                	ret
    80005894:	64e2                	ld	s1,24(sp)
    80005896:	6942                	ld	s2,16(sp)
    80005898:	bfcd                	j	8000588a <sys_dup+0x48>

000000008000589a <sys_read>:
{
    8000589a:	7179                	addi	sp,sp,-48
    8000589c:	f406                	sd	ra,40(sp)
    8000589e:	f022                	sd	s0,32(sp)
    800058a0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058a2:	fd840593          	addi	a1,s0,-40
    800058a6:	4505                	li	a0,1
    800058a8:	ffffd097          	auipc	ra,0xffffd
    800058ac:	684080e7          	jalr	1668(ra) # 80002f2c <argaddr>
  argint(2, &n);
    800058b0:	fe440593          	addi	a1,s0,-28
    800058b4:	4509                	li	a0,2
    800058b6:	ffffd097          	auipc	ra,0xffffd
    800058ba:	656080e7          	jalr	1622(ra) # 80002f0c <argint>
  if(argfd(0, 0, &f) < 0)
    800058be:	fe840613          	addi	a2,s0,-24
    800058c2:	4581                	li	a1,0
    800058c4:	4501                	li	a0,0
    800058c6:	00000097          	auipc	ra,0x0
    800058ca:	d54080e7          	jalr	-684(ra) # 8000561a <argfd>
    800058ce:	87aa                	mv	a5,a0
    return -1;
    800058d0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058d2:	0007cc63          	bltz	a5,800058ea <sys_read+0x50>
  return fileread(f, p, n);
    800058d6:	fe442603          	lw	a2,-28(s0)
    800058da:	fd843583          	ld	a1,-40(s0)
    800058de:	fe843503          	ld	a0,-24(s0)
    800058e2:	fffff097          	auipc	ra,0xfffff
    800058e6:	3ba080e7          	jalr	954(ra) # 80004c9c <fileread>
}
    800058ea:	70a2                	ld	ra,40(sp)
    800058ec:	7402                	ld	s0,32(sp)
    800058ee:	6145                	addi	sp,sp,48
    800058f0:	8082                	ret

00000000800058f2 <sys_write>:
{
    800058f2:	7179                	addi	sp,sp,-48
    800058f4:	f406                	sd	ra,40(sp)
    800058f6:	f022                	sd	s0,32(sp)
    800058f8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800058fa:	fd840593          	addi	a1,s0,-40
    800058fe:	4505                	li	a0,1
    80005900:	ffffd097          	auipc	ra,0xffffd
    80005904:	62c080e7          	jalr	1580(ra) # 80002f2c <argaddr>
  argint(2, &n);
    80005908:	fe440593          	addi	a1,s0,-28
    8000590c:	4509                	li	a0,2
    8000590e:	ffffd097          	auipc	ra,0xffffd
    80005912:	5fe080e7          	jalr	1534(ra) # 80002f0c <argint>
  if(argfd(0, 0, &f) < 0)
    80005916:	fe840613          	addi	a2,s0,-24
    8000591a:	4581                	li	a1,0
    8000591c:	4501                	li	a0,0
    8000591e:	00000097          	auipc	ra,0x0
    80005922:	cfc080e7          	jalr	-772(ra) # 8000561a <argfd>
    80005926:	87aa                	mv	a5,a0
    return -1;
    80005928:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000592a:	0007cc63          	bltz	a5,80005942 <sys_write+0x50>
  return filewrite(f, p, n);
    8000592e:	fe442603          	lw	a2,-28(s0)
    80005932:	fd843583          	ld	a1,-40(s0)
    80005936:	fe843503          	ld	a0,-24(s0)
    8000593a:	fffff097          	auipc	ra,0xfffff
    8000593e:	434080e7          	jalr	1076(ra) # 80004d6e <filewrite>
}
    80005942:	70a2                	ld	ra,40(sp)
    80005944:	7402                	ld	s0,32(sp)
    80005946:	6145                	addi	sp,sp,48
    80005948:	8082                	ret

000000008000594a <sys_close>:
{
    8000594a:	1101                	addi	sp,sp,-32
    8000594c:	ec06                	sd	ra,24(sp)
    8000594e:	e822                	sd	s0,16(sp)
    80005950:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005952:	fe040613          	addi	a2,s0,-32
    80005956:	fec40593          	addi	a1,s0,-20
    8000595a:	4501                	li	a0,0
    8000595c:	00000097          	auipc	ra,0x0
    80005960:	cbe080e7          	jalr	-834(ra) # 8000561a <argfd>
    return -1;
    80005964:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005966:	02054463          	bltz	a0,8000598e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	0fe080e7          	jalr	254(ra) # 80001a68 <myproc>
    80005972:	fec42783          	lw	a5,-20(s0)
    80005976:	07e9                	addi	a5,a5,26
    80005978:	078e                	slli	a5,a5,0x3
    8000597a:	953e                	add	a0,a0,a5
    8000597c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005980:	fe043503          	ld	a0,-32(s0)
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	1c4080e7          	jalr	452(ra) # 80004b48 <fileclose>
  return 0;
    8000598c:	4781                	li	a5,0
}
    8000598e:	853e                	mv	a0,a5
    80005990:	60e2                	ld	ra,24(sp)
    80005992:	6442                	ld	s0,16(sp)
    80005994:	6105                	addi	sp,sp,32
    80005996:	8082                	ret

0000000080005998 <sys_fstat>:
{
    80005998:	1101                	addi	sp,sp,-32
    8000599a:	ec06                	sd	ra,24(sp)
    8000599c:	e822                	sd	s0,16(sp)
    8000599e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800059a0:	fe040593          	addi	a1,s0,-32
    800059a4:	4505                	li	a0,1
    800059a6:	ffffd097          	auipc	ra,0xffffd
    800059aa:	586080e7          	jalr	1414(ra) # 80002f2c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800059ae:	fe840613          	addi	a2,s0,-24
    800059b2:	4581                	li	a1,0
    800059b4:	4501                	li	a0,0
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	c64080e7          	jalr	-924(ra) # 8000561a <argfd>
    800059be:	87aa                	mv	a5,a0
    return -1;
    800059c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800059c2:	0007ca63          	bltz	a5,800059d6 <sys_fstat+0x3e>
  return filestat(f, st);
    800059c6:	fe043583          	ld	a1,-32(s0)
    800059ca:	fe843503          	ld	a0,-24(s0)
    800059ce:	fffff097          	auipc	ra,0xfffff
    800059d2:	258080e7          	jalr	600(ra) # 80004c26 <filestat>
}
    800059d6:	60e2                	ld	ra,24(sp)
    800059d8:	6442                	ld	s0,16(sp)
    800059da:	6105                	addi	sp,sp,32
    800059dc:	8082                	ret

00000000800059de <sys_link>:
{
    800059de:	7169                	addi	sp,sp,-304
    800059e0:	f606                	sd	ra,296(sp)
    800059e2:	f222                	sd	s0,288(sp)
    800059e4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059e6:	08000613          	li	a2,128
    800059ea:	ed040593          	addi	a1,s0,-304
    800059ee:	4501                	li	a0,0
    800059f0:	ffffd097          	auipc	ra,0xffffd
    800059f4:	55c080e7          	jalr	1372(ra) # 80002f4c <argstr>
    return -1;
    800059f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059fa:	12054663          	bltz	a0,80005b26 <sys_link+0x148>
    800059fe:	08000613          	li	a2,128
    80005a02:	f5040593          	addi	a1,s0,-176
    80005a06:	4505                	li	a0,1
    80005a08:	ffffd097          	auipc	ra,0xffffd
    80005a0c:	544080e7          	jalr	1348(ra) # 80002f4c <argstr>
    return -1;
    80005a10:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a12:	10054a63          	bltz	a0,80005b26 <sys_link+0x148>
    80005a16:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a18:	fffff097          	auipc	ra,0xfffff
    80005a1c:	c60080e7          	jalr	-928(ra) # 80004678 <begin_op>
  if((ip = namei(old)) == 0){
    80005a20:	ed040513          	addi	a0,s0,-304
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	a4e080e7          	jalr	-1458(ra) # 80004472 <namei>
    80005a2c:	84aa                	mv	s1,a0
    80005a2e:	c949                	beqz	a0,80005ac0 <sys_link+0xe2>
  ilock(ip);
    80005a30:	ffffe097          	auipc	ra,0xffffe
    80005a34:	25e080e7          	jalr	606(ra) # 80003c8e <ilock>
  if(ip->type == T_DIR){
    80005a38:	04449703          	lh	a4,68(s1)
    80005a3c:	4785                	li	a5,1
    80005a3e:	08f70863          	beq	a4,a5,80005ace <sys_link+0xf0>
    80005a42:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005a44:	04a4d783          	lhu	a5,74(s1)
    80005a48:	2785                	addiw	a5,a5,1
    80005a4a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a4e:	8526                	mv	a0,s1
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	172080e7          	jalr	370(ra) # 80003bc2 <iupdate>
  iunlock(ip);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	2fa080e7          	jalr	762(ra) # 80003d54 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005a62:	fd040593          	addi	a1,s0,-48
    80005a66:	f5040513          	addi	a0,s0,-176
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	a26080e7          	jalr	-1498(ra) # 80004490 <nameiparent>
    80005a72:	892a                	mv	s2,a0
    80005a74:	cd35                	beqz	a0,80005af0 <sys_link+0x112>
  ilock(dp);
    80005a76:	ffffe097          	auipc	ra,0xffffe
    80005a7a:	218080e7          	jalr	536(ra) # 80003c8e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a7e:	00092703          	lw	a4,0(s2)
    80005a82:	409c                	lw	a5,0(s1)
    80005a84:	06f71163          	bne	a4,a5,80005ae6 <sys_link+0x108>
    80005a88:	40d0                	lw	a2,4(s1)
    80005a8a:	fd040593          	addi	a1,s0,-48
    80005a8e:	854a                	mv	a0,s2
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	920080e7          	jalr	-1760(ra) # 800043b0 <dirlink>
    80005a98:	04054763          	bltz	a0,80005ae6 <sys_link+0x108>
  iunlockput(dp);
    80005a9c:	854a                	mv	a0,s2
    80005a9e:	ffffe097          	auipc	ra,0xffffe
    80005aa2:	456080e7          	jalr	1110(ra) # 80003ef4 <iunlockput>
  iput(ip);
    80005aa6:	8526                	mv	a0,s1
    80005aa8:	ffffe097          	auipc	ra,0xffffe
    80005aac:	3a4080e7          	jalr	932(ra) # 80003e4c <iput>
  end_op();
    80005ab0:	fffff097          	auipc	ra,0xfffff
    80005ab4:	c42080e7          	jalr	-958(ra) # 800046f2 <end_op>
  return 0;
    80005ab8:	4781                	li	a5,0
    80005aba:	64f2                	ld	s1,280(sp)
    80005abc:	6952                	ld	s2,272(sp)
    80005abe:	a0a5                	j	80005b26 <sys_link+0x148>
    end_op();
    80005ac0:	fffff097          	auipc	ra,0xfffff
    80005ac4:	c32080e7          	jalr	-974(ra) # 800046f2 <end_op>
    return -1;
    80005ac8:	57fd                	li	a5,-1
    80005aca:	64f2                	ld	s1,280(sp)
    80005acc:	a8a9                	j	80005b26 <sys_link+0x148>
    iunlockput(ip);
    80005ace:	8526                	mv	a0,s1
    80005ad0:	ffffe097          	auipc	ra,0xffffe
    80005ad4:	424080e7          	jalr	1060(ra) # 80003ef4 <iunlockput>
    end_op();
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	c1a080e7          	jalr	-998(ra) # 800046f2 <end_op>
    return -1;
    80005ae0:	57fd                	li	a5,-1
    80005ae2:	64f2                	ld	s1,280(sp)
    80005ae4:	a089                	j	80005b26 <sys_link+0x148>
    iunlockput(dp);
    80005ae6:	854a                	mv	a0,s2
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	40c080e7          	jalr	1036(ra) # 80003ef4 <iunlockput>
  ilock(ip);
    80005af0:	8526                	mv	a0,s1
    80005af2:	ffffe097          	auipc	ra,0xffffe
    80005af6:	19c080e7          	jalr	412(ra) # 80003c8e <ilock>
  ip->nlink--;
    80005afa:	04a4d783          	lhu	a5,74(s1)
    80005afe:	37fd                	addiw	a5,a5,-1
    80005b00:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b04:	8526                	mv	a0,s1
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	0bc080e7          	jalr	188(ra) # 80003bc2 <iupdate>
  iunlockput(ip);
    80005b0e:	8526                	mv	a0,s1
    80005b10:	ffffe097          	auipc	ra,0xffffe
    80005b14:	3e4080e7          	jalr	996(ra) # 80003ef4 <iunlockput>
  end_op();
    80005b18:	fffff097          	auipc	ra,0xfffff
    80005b1c:	bda080e7          	jalr	-1062(ra) # 800046f2 <end_op>
  return -1;
    80005b20:	57fd                	li	a5,-1
    80005b22:	64f2                	ld	s1,280(sp)
    80005b24:	6952                	ld	s2,272(sp)
}
    80005b26:	853e                	mv	a0,a5
    80005b28:	70b2                	ld	ra,296(sp)
    80005b2a:	7412                	ld	s0,288(sp)
    80005b2c:	6155                	addi	sp,sp,304
    80005b2e:	8082                	ret

0000000080005b30 <sys_unlink>:
{
    80005b30:	7111                	addi	sp,sp,-256
    80005b32:	fd86                	sd	ra,248(sp)
    80005b34:	f9a2                	sd	s0,240(sp)
    80005b36:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80005b38:	08000613          	li	a2,128
    80005b3c:	f2040593          	addi	a1,s0,-224
    80005b40:	4501                	li	a0,0
    80005b42:	ffffd097          	auipc	ra,0xffffd
    80005b46:	40a080e7          	jalr	1034(ra) # 80002f4c <argstr>
    80005b4a:	1c054063          	bltz	a0,80005d0a <sys_unlink+0x1da>
    80005b4e:	f5a6                	sd	s1,232(sp)
  begin_op();
    80005b50:	fffff097          	auipc	ra,0xfffff
    80005b54:	b28080e7          	jalr	-1240(ra) # 80004678 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005b58:	fa040593          	addi	a1,s0,-96
    80005b5c:	f2040513          	addi	a0,s0,-224
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	930080e7          	jalr	-1744(ra) # 80004490 <nameiparent>
    80005b68:	84aa                	mv	s1,a0
    80005b6a:	c165                	beqz	a0,80005c4a <sys_unlink+0x11a>
  ilock(dp);
    80005b6c:	ffffe097          	auipc	ra,0xffffe
    80005b70:	122080e7          	jalr	290(ra) # 80003c8e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b74:	00003597          	auipc	a1,0x3
    80005b78:	a6458593          	addi	a1,a1,-1436 # 800085d8 <etext+0x5d8>
    80005b7c:	fa040513          	addi	a0,s0,-96
    80005b80:	ffffe097          	auipc	ra,0xffffe
    80005b84:	5f0080e7          	jalr	1520(ra) # 80004170 <namecmp>
    80005b88:	16050263          	beqz	a0,80005cec <sys_unlink+0x1bc>
    80005b8c:	00003597          	auipc	a1,0x3
    80005b90:	a5458593          	addi	a1,a1,-1452 # 800085e0 <etext+0x5e0>
    80005b94:	fa040513          	addi	a0,s0,-96
    80005b98:	ffffe097          	auipc	ra,0xffffe
    80005b9c:	5d8080e7          	jalr	1496(ra) # 80004170 <namecmp>
    80005ba0:	14050663          	beqz	a0,80005cec <sys_unlink+0x1bc>
    80005ba4:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ba6:	f1c40613          	addi	a2,s0,-228
    80005baa:	fa040593          	addi	a1,s0,-96
    80005bae:	8526                	mv	a0,s1
    80005bb0:	ffffe097          	auipc	ra,0xffffe
    80005bb4:	5da080e7          	jalr	1498(ra) # 8000418a <dirlookup>
    80005bb8:	892a                	mv	s2,a0
    80005bba:	12050863          	beqz	a0,80005cea <sys_unlink+0x1ba>
    80005bbe:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005bc0:	ffffe097          	auipc	ra,0xffffe
    80005bc4:	0ce080e7          	jalr	206(ra) # 80003c8e <ilock>
  if(ip->nlink < 1)
    80005bc8:	04a91783          	lh	a5,74(s2)
    80005bcc:	08f05663          	blez	a5,80005c58 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005bd0:	04491703          	lh	a4,68(s2)
    80005bd4:	4785                	li	a5,1
    80005bd6:	08f70b63          	beq	a4,a5,80005c6c <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80005bda:	fb040993          	addi	s3,s0,-80
    80005bde:	4641                	li	a2,16
    80005be0:	4581                	li	a1,0
    80005be2:	854e                	mv	a0,s3
    80005be4:	ffffb097          	auipc	ra,0xffffb
    80005be8:	152080e7          	jalr	338(ra) # 80000d36 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bec:	4741                	li	a4,16
    80005bee:	f1c42683          	lw	a3,-228(s0)
    80005bf2:	864e                	mv	a2,s3
    80005bf4:	4581                	li	a1,0
    80005bf6:	8526                	mv	a0,s1
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	458080e7          	jalr	1112(ra) # 80004050 <writei>
    80005c00:	47c1                	li	a5,16
    80005c02:	0af51f63          	bne	a0,a5,80005cc0 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80005c06:	04491703          	lh	a4,68(s2)
    80005c0a:	4785                	li	a5,1
    80005c0c:	0cf70463          	beq	a4,a5,80005cd4 <sys_unlink+0x1a4>
  iunlockput(dp);
    80005c10:	8526                	mv	a0,s1
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	2e2080e7          	jalr	738(ra) # 80003ef4 <iunlockput>
  ip->nlink--;
    80005c1a:	04a95783          	lhu	a5,74(s2)
    80005c1e:	37fd                	addiw	a5,a5,-1
    80005c20:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c24:	854a                	mv	a0,s2
    80005c26:	ffffe097          	auipc	ra,0xffffe
    80005c2a:	f9c080e7          	jalr	-100(ra) # 80003bc2 <iupdate>
  iunlockput(ip);
    80005c2e:	854a                	mv	a0,s2
    80005c30:	ffffe097          	auipc	ra,0xffffe
    80005c34:	2c4080e7          	jalr	708(ra) # 80003ef4 <iunlockput>
  end_op();
    80005c38:	fffff097          	auipc	ra,0xfffff
    80005c3c:	aba080e7          	jalr	-1350(ra) # 800046f2 <end_op>
  return 0;
    80005c40:	4501                	li	a0,0
    80005c42:	74ae                	ld	s1,232(sp)
    80005c44:	790e                	ld	s2,224(sp)
    80005c46:	69ee                	ld	s3,216(sp)
    80005c48:	a86d                	j	80005d02 <sys_unlink+0x1d2>
    end_op();
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	aa8080e7          	jalr	-1368(ra) # 800046f2 <end_op>
    return -1;
    80005c52:	557d                	li	a0,-1
    80005c54:	74ae                	ld	s1,232(sp)
    80005c56:	a075                	j	80005d02 <sys_unlink+0x1d2>
    80005c58:	e9d2                	sd	s4,208(sp)
    80005c5a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80005c5c:	00003517          	auipc	a0,0x3
    80005c60:	98c50513          	addi	a0,a0,-1652 # 800085e8 <etext+0x5e8>
    80005c64:	ffffb097          	auipc	ra,0xffffb
    80005c68:	8fc080e7          	jalr	-1796(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c6c:	04c92703          	lw	a4,76(s2)
    80005c70:	02000793          	li	a5,32
    80005c74:	f6e7f3e3          	bgeu	a5,a4,80005bda <sys_unlink+0xaa>
    80005c78:	e9d2                	sd	s4,208(sp)
    80005c7a:	e5d6                	sd	s5,200(sp)
    80005c7c:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c7e:	f0840a93          	addi	s5,s0,-248
    80005c82:	4a41                	li	s4,16
    80005c84:	8752                	mv	a4,s4
    80005c86:	86ce                	mv	a3,s3
    80005c88:	8656                	mv	a2,s5
    80005c8a:	4581                	li	a1,0
    80005c8c:	854a                	mv	a0,s2
    80005c8e:	ffffe097          	auipc	ra,0xffffe
    80005c92:	2bc080e7          	jalr	700(ra) # 80003f4a <readi>
    80005c96:	01451d63          	bne	a0,s4,80005cb0 <sys_unlink+0x180>
    if(de.inum != 0)
    80005c9a:	f0845783          	lhu	a5,-248(s0)
    80005c9e:	eba5                	bnez	a5,80005d0e <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ca0:	29c1                	addiw	s3,s3,16
    80005ca2:	04c92783          	lw	a5,76(s2)
    80005ca6:	fcf9efe3          	bltu	s3,a5,80005c84 <sys_unlink+0x154>
    80005caa:	6a4e                	ld	s4,208(sp)
    80005cac:	6aae                	ld	s5,200(sp)
    80005cae:	b735                	j	80005bda <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005cb0:	00003517          	auipc	a0,0x3
    80005cb4:	95050513          	addi	a0,a0,-1712 # 80008600 <etext+0x600>
    80005cb8:	ffffb097          	auipc	ra,0xffffb
    80005cbc:	8a8080e7          	jalr	-1880(ra) # 80000560 <panic>
    80005cc0:	e9d2                	sd	s4,208(sp)
    80005cc2:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005cc4:	00003517          	auipc	a0,0x3
    80005cc8:	95450513          	addi	a0,a0,-1708 # 80008618 <etext+0x618>
    80005ccc:	ffffb097          	auipc	ra,0xffffb
    80005cd0:	894080e7          	jalr	-1900(ra) # 80000560 <panic>
    dp->nlink--;
    80005cd4:	04a4d783          	lhu	a5,74(s1)
    80005cd8:	37fd                	addiw	a5,a5,-1
    80005cda:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005cde:	8526                	mv	a0,s1
    80005ce0:	ffffe097          	auipc	ra,0xffffe
    80005ce4:	ee2080e7          	jalr	-286(ra) # 80003bc2 <iupdate>
    80005ce8:	b725                	j	80005c10 <sys_unlink+0xe0>
    80005cea:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005cec:	8526                	mv	a0,s1
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	206080e7          	jalr	518(ra) # 80003ef4 <iunlockput>
  end_op();
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	9fc080e7          	jalr	-1540(ra) # 800046f2 <end_op>
  return -1;
    80005cfe:	557d                	li	a0,-1
    80005d00:	74ae                	ld	s1,232(sp)
}
    80005d02:	70ee                	ld	ra,248(sp)
    80005d04:	744e                	ld	s0,240(sp)
    80005d06:	6111                	addi	sp,sp,256
    80005d08:	8082                	ret
    return -1;
    80005d0a:	557d                	li	a0,-1
    80005d0c:	bfdd                	j	80005d02 <sys_unlink+0x1d2>
    iunlockput(ip);
    80005d0e:	854a                	mv	a0,s2
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	1e4080e7          	jalr	484(ra) # 80003ef4 <iunlockput>
    goto bad;
    80005d18:	790e                	ld	s2,224(sp)
    80005d1a:	69ee                	ld	s3,216(sp)
    80005d1c:	6a4e                	ld	s4,208(sp)
    80005d1e:	6aae                	ld	s5,200(sp)
    80005d20:	b7f1                	j	80005cec <sys_unlink+0x1bc>

0000000080005d22 <sys_open>:

uint64
sys_open(void)
{
    80005d22:	7131                	addi	sp,sp,-192
    80005d24:	fd06                	sd	ra,184(sp)
    80005d26:	f922                	sd	s0,176(sp)
    80005d28:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d2a:	f4c40593          	addi	a1,s0,-180
    80005d2e:	4505                	li	a0,1
    80005d30:	ffffd097          	auipc	ra,0xffffd
    80005d34:	1dc080e7          	jalr	476(ra) # 80002f0c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d38:	08000613          	li	a2,128
    80005d3c:	f5040593          	addi	a1,s0,-176
    80005d40:	4501                	li	a0,0
    80005d42:	ffffd097          	auipc	ra,0xffffd
    80005d46:	20a080e7          	jalr	522(ra) # 80002f4c <argstr>
    80005d4a:	87aa                	mv	a5,a0
    return -1;
    80005d4c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d4e:	0a07cf63          	bltz	a5,80005e0c <sys_open+0xea>
    80005d52:	f526                	sd	s1,168(sp)

  begin_op();
    80005d54:	fffff097          	auipc	ra,0xfffff
    80005d58:	924080e7          	jalr	-1756(ra) # 80004678 <begin_op>

  if(omode & O_CREATE){
    80005d5c:	f4c42783          	lw	a5,-180(s0)
    80005d60:	2007f793          	andi	a5,a5,512
    80005d64:	cfdd                	beqz	a5,80005e22 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005d66:	4681                	li	a3,0
    80005d68:	4601                	li	a2,0
    80005d6a:	4589                	li	a1,2
    80005d6c:	f5040513          	addi	a0,s0,-176
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	94c080e7          	jalr	-1716(ra) # 800056bc <create>
    80005d78:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d7a:	cd49                	beqz	a0,80005e14 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d7c:	04449703          	lh	a4,68(s1)
    80005d80:	478d                	li	a5,3
    80005d82:	00f71763          	bne	a4,a5,80005d90 <sys_open+0x6e>
    80005d86:	0464d703          	lhu	a4,70(s1)
    80005d8a:	47a5                	li	a5,9
    80005d8c:	0ee7e263          	bltu	a5,a4,80005e70 <sys_open+0x14e>
    80005d90:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d92:	fffff097          	auipc	ra,0xfffff
    80005d96:	cfa080e7          	jalr	-774(ra) # 80004a8c <filealloc>
    80005d9a:	892a                	mv	s2,a0
    80005d9c:	cd65                	beqz	a0,80005e94 <sys_open+0x172>
    80005d9e:	ed4e                	sd	s3,152(sp)
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	8da080e7          	jalr	-1830(ra) # 8000567a <fdalloc>
    80005da8:	89aa                	mv	s3,a0
    80005daa:	0c054f63          	bltz	a0,80005e88 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dae:	04449703          	lh	a4,68(s1)
    80005db2:	478d                	li	a5,3
    80005db4:	0ef70d63          	beq	a4,a5,80005eae <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005db8:	4789                	li	a5,2
    80005dba:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005dbe:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005dc2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005dc6:	f4c42783          	lw	a5,-180(s0)
    80005dca:	0017f713          	andi	a4,a5,1
    80005dce:	00174713          	xori	a4,a4,1
    80005dd2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005dd6:	0037f713          	andi	a4,a5,3
    80005dda:	00e03733          	snez	a4,a4
    80005dde:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005de2:	4007f793          	andi	a5,a5,1024
    80005de6:	c791                	beqz	a5,80005df2 <sys_open+0xd0>
    80005de8:	04449703          	lh	a4,68(s1)
    80005dec:	4789                	li	a5,2
    80005dee:	0cf70763          	beq	a4,a5,80005ebc <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005df2:	8526                	mv	a0,s1
    80005df4:	ffffe097          	auipc	ra,0xffffe
    80005df8:	f60080e7          	jalr	-160(ra) # 80003d54 <iunlock>
  end_op();
    80005dfc:	fffff097          	auipc	ra,0xfffff
    80005e00:	8f6080e7          	jalr	-1802(ra) # 800046f2 <end_op>

  return fd;
    80005e04:	854e                	mv	a0,s3
    80005e06:	74aa                	ld	s1,168(sp)
    80005e08:	790a                	ld	s2,160(sp)
    80005e0a:	69ea                	ld	s3,152(sp)
}
    80005e0c:	70ea                	ld	ra,184(sp)
    80005e0e:	744a                	ld	s0,176(sp)
    80005e10:	6129                	addi	sp,sp,192
    80005e12:	8082                	ret
      end_op();
    80005e14:	fffff097          	auipc	ra,0xfffff
    80005e18:	8de080e7          	jalr	-1826(ra) # 800046f2 <end_op>
      return -1;
    80005e1c:	557d                	li	a0,-1
    80005e1e:	74aa                	ld	s1,168(sp)
    80005e20:	b7f5                	j	80005e0c <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005e22:	f5040513          	addi	a0,s0,-176
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	64c080e7          	jalr	1612(ra) # 80004472 <namei>
    80005e2e:	84aa                	mv	s1,a0
    80005e30:	c90d                	beqz	a0,80005e62 <sys_open+0x140>
    ilock(ip);
    80005e32:	ffffe097          	auipc	ra,0xffffe
    80005e36:	e5c080e7          	jalr	-420(ra) # 80003c8e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e3a:	04449703          	lh	a4,68(s1)
    80005e3e:	4785                	li	a5,1
    80005e40:	f2f71ee3          	bne	a4,a5,80005d7c <sys_open+0x5a>
    80005e44:	f4c42783          	lw	a5,-180(s0)
    80005e48:	d7a1                	beqz	a5,80005d90 <sys_open+0x6e>
      iunlockput(ip);
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	ffffe097          	auipc	ra,0xffffe
    80005e50:	0a8080e7          	jalr	168(ra) # 80003ef4 <iunlockput>
      end_op();
    80005e54:	fffff097          	auipc	ra,0xfffff
    80005e58:	89e080e7          	jalr	-1890(ra) # 800046f2 <end_op>
      return -1;
    80005e5c:	557d                	li	a0,-1
    80005e5e:	74aa                	ld	s1,168(sp)
    80005e60:	b775                	j	80005e0c <sys_open+0xea>
      end_op();
    80005e62:	fffff097          	auipc	ra,0xfffff
    80005e66:	890080e7          	jalr	-1904(ra) # 800046f2 <end_op>
      return -1;
    80005e6a:	557d                	li	a0,-1
    80005e6c:	74aa                	ld	s1,168(sp)
    80005e6e:	bf79                	j	80005e0c <sys_open+0xea>
    iunlockput(ip);
    80005e70:	8526                	mv	a0,s1
    80005e72:	ffffe097          	auipc	ra,0xffffe
    80005e76:	082080e7          	jalr	130(ra) # 80003ef4 <iunlockput>
    end_op();
    80005e7a:	fffff097          	auipc	ra,0xfffff
    80005e7e:	878080e7          	jalr	-1928(ra) # 800046f2 <end_op>
    return -1;
    80005e82:	557d                	li	a0,-1
    80005e84:	74aa                	ld	s1,168(sp)
    80005e86:	b759                	j	80005e0c <sys_open+0xea>
      fileclose(f);
    80005e88:	854a                	mv	a0,s2
    80005e8a:	fffff097          	auipc	ra,0xfffff
    80005e8e:	cbe080e7          	jalr	-834(ra) # 80004b48 <fileclose>
    80005e92:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e94:	8526                	mv	a0,s1
    80005e96:	ffffe097          	auipc	ra,0xffffe
    80005e9a:	05e080e7          	jalr	94(ra) # 80003ef4 <iunlockput>
    end_op();
    80005e9e:	fffff097          	auipc	ra,0xfffff
    80005ea2:	854080e7          	jalr	-1964(ra) # 800046f2 <end_op>
    return -1;
    80005ea6:	557d                	li	a0,-1
    80005ea8:	74aa                	ld	s1,168(sp)
    80005eaa:	790a                	ld	s2,160(sp)
    80005eac:	b785                	j	80005e0c <sys_open+0xea>
    f->type = FD_DEVICE;
    80005eae:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005eb2:	04649783          	lh	a5,70(s1)
    80005eb6:	02f91223          	sh	a5,36(s2)
    80005eba:	b721                	j	80005dc2 <sys_open+0xa0>
    itrunc(ip);
    80005ebc:	8526                	mv	a0,s1
    80005ebe:	ffffe097          	auipc	ra,0xffffe
    80005ec2:	ee2080e7          	jalr	-286(ra) # 80003da0 <itrunc>
    80005ec6:	b735                	j	80005df2 <sys_open+0xd0>

0000000080005ec8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ec8:	7175                	addi	sp,sp,-144
    80005eca:	e506                	sd	ra,136(sp)
    80005ecc:	e122                	sd	s0,128(sp)
    80005ece:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ed0:	ffffe097          	auipc	ra,0xffffe
    80005ed4:	7a8080e7          	jalr	1960(ra) # 80004678 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ed8:	08000613          	li	a2,128
    80005edc:	f7040593          	addi	a1,s0,-144
    80005ee0:	4501                	li	a0,0
    80005ee2:	ffffd097          	auipc	ra,0xffffd
    80005ee6:	06a080e7          	jalr	106(ra) # 80002f4c <argstr>
    80005eea:	02054963          	bltz	a0,80005f1c <sys_mkdir+0x54>
    80005eee:	4681                	li	a3,0
    80005ef0:	4601                	li	a2,0
    80005ef2:	4585                	li	a1,1
    80005ef4:	f7040513          	addi	a0,s0,-144
    80005ef8:	fffff097          	auipc	ra,0xfffff
    80005efc:	7c4080e7          	jalr	1988(ra) # 800056bc <create>
    80005f00:	cd11                	beqz	a0,80005f1c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f02:	ffffe097          	auipc	ra,0xffffe
    80005f06:	ff2080e7          	jalr	-14(ra) # 80003ef4 <iunlockput>
  end_op();
    80005f0a:	ffffe097          	auipc	ra,0xffffe
    80005f0e:	7e8080e7          	jalr	2024(ra) # 800046f2 <end_op>
  return 0;
    80005f12:	4501                	li	a0,0
}
    80005f14:	60aa                	ld	ra,136(sp)
    80005f16:	640a                	ld	s0,128(sp)
    80005f18:	6149                	addi	sp,sp,144
    80005f1a:	8082                	ret
    end_op();
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	7d6080e7          	jalr	2006(ra) # 800046f2 <end_op>
    return -1;
    80005f24:	557d                	li	a0,-1
    80005f26:	b7fd                	j	80005f14 <sys_mkdir+0x4c>

0000000080005f28 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f28:	7135                	addi	sp,sp,-160
    80005f2a:	ed06                	sd	ra,152(sp)
    80005f2c:	e922                	sd	s0,144(sp)
    80005f2e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f30:	ffffe097          	auipc	ra,0xffffe
    80005f34:	748080e7          	jalr	1864(ra) # 80004678 <begin_op>
  argint(1, &major);
    80005f38:	f6c40593          	addi	a1,s0,-148
    80005f3c:	4505                	li	a0,1
    80005f3e:	ffffd097          	auipc	ra,0xffffd
    80005f42:	fce080e7          	jalr	-50(ra) # 80002f0c <argint>
  argint(2, &minor);
    80005f46:	f6840593          	addi	a1,s0,-152
    80005f4a:	4509                	li	a0,2
    80005f4c:	ffffd097          	auipc	ra,0xffffd
    80005f50:	fc0080e7          	jalr	-64(ra) # 80002f0c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f54:	08000613          	li	a2,128
    80005f58:	f7040593          	addi	a1,s0,-144
    80005f5c:	4501                	li	a0,0
    80005f5e:	ffffd097          	auipc	ra,0xffffd
    80005f62:	fee080e7          	jalr	-18(ra) # 80002f4c <argstr>
    80005f66:	02054b63          	bltz	a0,80005f9c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f6a:	f6841683          	lh	a3,-152(s0)
    80005f6e:	f6c41603          	lh	a2,-148(s0)
    80005f72:	458d                	li	a1,3
    80005f74:	f7040513          	addi	a0,s0,-144
    80005f78:	fffff097          	auipc	ra,0xfffff
    80005f7c:	744080e7          	jalr	1860(ra) # 800056bc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f80:	cd11                	beqz	a0,80005f9c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f82:	ffffe097          	auipc	ra,0xffffe
    80005f86:	f72080e7          	jalr	-142(ra) # 80003ef4 <iunlockput>
  end_op();
    80005f8a:	ffffe097          	auipc	ra,0xffffe
    80005f8e:	768080e7          	jalr	1896(ra) # 800046f2 <end_op>
  return 0;
    80005f92:	4501                	li	a0,0
}
    80005f94:	60ea                	ld	ra,152(sp)
    80005f96:	644a                	ld	s0,144(sp)
    80005f98:	610d                	addi	sp,sp,160
    80005f9a:	8082                	ret
    end_op();
    80005f9c:	ffffe097          	auipc	ra,0xffffe
    80005fa0:	756080e7          	jalr	1878(ra) # 800046f2 <end_op>
    return -1;
    80005fa4:	557d                	li	a0,-1
    80005fa6:	b7fd                	j	80005f94 <sys_mknod+0x6c>

0000000080005fa8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005fa8:	7135                	addi	sp,sp,-160
    80005faa:	ed06                	sd	ra,152(sp)
    80005fac:	e922                	sd	s0,144(sp)
    80005fae:	e14a                	sd	s2,128(sp)
    80005fb0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005fb2:	ffffc097          	auipc	ra,0xffffc
    80005fb6:	ab6080e7          	jalr	-1354(ra) # 80001a68 <myproc>
    80005fba:	892a                	mv	s2,a0
  
  begin_op();
    80005fbc:	ffffe097          	auipc	ra,0xffffe
    80005fc0:	6bc080e7          	jalr	1724(ra) # 80004678 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005fc4:	08000613          	li	a2,128
    80005fc8:	f6040593          	addi	a1,s0,-160
    80005fcc:	4501                	li	a0,0
    80005fce:	ffffd097          	auipc	ra,0xffffd
    80005fd2:	f7e080e7          	jalr	-130(ra) # 80002f4c <argstr>
    80005fd6:	04054d63          	bltz	a0,80006030 <sys_chdir+0x88>
    80005fda:	e526                	sd	s1,136(sp)
    80005fdc:	f6040513          	addi	a0,s0,-160
    80005fe0:	ffffe097          	auipc	ra,0xffffe
    80005fe4:	492080e7          	jalr	1170(ra) # 80004472 <namei>
    80005fe8:	84aa                	mv	s1,a0
    80005fea:	c131                	beqz	a0,8000602e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005fec:	ffffe097          	auipc	ra,0xffffe
    80005ff0:	ca2080e7          	jalr	-862(ra) # 80003c8e <ilock>
  if(ip->type != T_DIR){
    80005ff4:	04449703          	lh	a4,68(s1)
    80005ff8:	4785                	li	a5,1
    80005ffa:	04f71163          	bne	a4,a5,8000603c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ffe:	8526                	mv	a0,s1
    80006000:	ffffe097          	auipc	ra,0xffffe
    80006004:	d54080e7          	jalr	-684(ra) # 80003d54 <iunlock>
  iput(p->cwd);
    80006008:	15093503          	ld	a0,336(s2)
    8000600c:	ffffe097          	auipc	ra,0xffffe
    80006010:	e40080e7          	jalr	-448(ra) # 80003e4c <iput>
  end_op();
    80006014:	ffffe097          	auipc	ra,0xffffe
    80006018:	6de080e7          	jalr	1758(ra) # 800046f2 <end_op>
  p->cwd = ip;
    8000601c:	14993823          	sd	s1,336(s2)
  return 0;
    80006020:	4501                	li	a0,0
    80006022:	64aa                	ld	s1,136(sp)
}
    80006024:	60ea                	ld	ra,152(sp)
    80006026:	644a                	ld	s0,144(sp)
    80006028:	690a                	ld	s2,128(sp)
    8000602a:	610d                	addi	sp,sp,160
    8000602c:	8082                	ret
    8000602e:	64aa                	ld	s1,136(sp)
    end_op();
    80006030:	ffffe097          	auipc	ra,0xffffe
    80006034:	6c2080e7          	jalr	1730(ra) # 800046f2 <end_op>
    return -1;
    80006038:	557d                	li	a0,-1
    8000603a:	b7ed                	j	80006024 <sys_chdir+0x7c>
    iunlockput(ip);
    8000603c:	8526                	mv	a0,s1
    8000603e:	ffffe097          	auipc	ra,0xffffe
    80006042:	eb6080e7          	jalr	-330(ra) # 80003ef4 <iunlockput>
    end_op();
    80006046:	ffffe097          	auipc	ra,0xffffe
    8000604a:	6ac080e7          	jalr	1708(ra) # 800046f2 <end_op>
    return -1;
    8000604e:	557d                	li	a0,-1
    80006050:	64aa                	ld	s1,136(sp)
    80006052:	bfc9                	j	80006024 <sys_chdir+0x7c>

0000000080006054 <sys_exec>:

uint64
sys_exec(void)
{
    80006054:	7105                	addi	sp,sp,-480
    80006056:	ef86                	sd	ra,472(sp)
    80006058:	eba2                	sd	s0,464(sp)
    8000605a:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000605c:	e2840593          	addi	a1,s0,-472
    80006060:	4505                	li	a0,1
    80006062:	ffffd097          	auipc	ra,0xffffd
    80006066:	eca080e7          	jalr	-310(ra) # 80002f2c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000606a:	08000613          	li	a2,128
    8000606e:	f3040593          	addi	a1,s0,-208
    80006072:	4501                	li	a0,0
    80006074:	ffffd097          	auipc	ra,0xffffd
    80006078:	ed8080e7          	jalr	-296(ra) # 80002f4c <argstr>
    8000607c:	87aa                	mv	a5,a0
    return -1;
    8000607e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006080:	0e07ce63          	bltz	a5,8000617c <sys_exec+0x128>
    80006084:	e7a6                	sd	s1,456(sp)
    80006086:	e3ca                	sd	s2,448(sp)
    80006088:	ff4e                	sd	s3,440(sp)
    8000608a:	fb52                	sd	s4,432(sp)
    8000608c:	f756                	sd	s5,424(sp)
    8000608e:	f35a                	sd	s6,416(sp)
    80006090:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006092:	e3040a13          	addi	s4,s0,-464
    80006096:	10000613          	li	a2,256
    8000609a:	4581                	li	a1,0
    8000609c:	8552                	mv	a0,s4
    8000609e:	ffffb097          	auipc	ra,0xffffb
    800060a2:	c98080e7          	jalr	-872(ra) # 80000d36 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060a6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800060a8:	89d2                	mv	s3,s4
    800060aa:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060ac:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060b0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800060b2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060b6:	00391513          	slli	a0,s2,0x3
    800060ba:	85d6                	mv	a1,s5
    800060bc:	e2843783          	ld	a5,-472(s0)
    800060c0:	953e                	add	a0,a0,a5
    800060c2:	ffffd097          	auipc	ra,0xffffd
    800060c6:	dac080e7          	jalr	-596(ra) # 80002e6e <fetchaddr>
    800060ca:	02054a63          	bltz	a0,800060fe <sys_exec+0xaa>
    if(uarg == 0){
    800060ce:	e2043783          	ld	a5,-480(s0)
    800060d2:	cbb1                	beqz	a5,80006126 <sys_exec+0xd2>
    argv[i] = kalloc();
    800060d4:	ffffb097          	auipc	ra,0xffffb
    800060d8:	a76080e7          	jalr	-1418(ra) # 80000b4a <kalloc>
    800060dc:	85aa                	mv	a1,a0
    800060de:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800060e2:	cd11                	beqz	a0,800060fe <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060e4:	865a                	mv	a2,s6
    800060e6:	e2043503          	ld	a0,-480(s0)
    800060ea:	ffffd097          	auipc	ra,0xffffd
    800060ee:	dd6080e7          	jalr	-554(ra) # 80002ec0 <fetchstr>
    800060f2:	00054663          	bltz	a0,800060fe <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    800060f6:	0905                	addi	s2,s2,1
    800060f8:	09a1                	addi	s3,s3,8
    800060fa:	fb791ee3          	bne	s2,s7,800060b6 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060fe:	100a0a13          	addi	s4,s4,256
    80006102:	6088                	ld	a0,0(s1)
    80006104:	c525                	beqz	a0,8000616c <sys_exec+0x118>
    kfree(argv[i]);
    80006106:	ffffb097          	auipc	ra,0xffffb
    8000610a:	946080e7          	jalr	-1722(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000610e:	04a1                	addi	s1,s1,8
    80006110:	ff4499e3          	bne	s1,s4,80006102 <sys_exec+0xae>
  return -1;
    80006114:	557d                	li	a0,-1
    80006116:	64be                	ld	s1,456(sp)
    80006118:	691e                	ld	s2,448(sp)
    8000611a:	79fa                	ld	s3,440(sp)
    8000611c:	7a5a                	ld	s4,432(sp)
    8000611e:	7aba                	ld	s5,424(sp)
    80006120:	7b1a                	ld	s6,416(sp)
    80006122:	6bfa                	ld	s7,408(sp)
    80006124:	a8a1                	j	8000617c <sys_exec+0x128>
      argv[i] = 0;
    80006126:	0009079b          	sext.w	a5,s2
    8000612a:	e3040593          	addi	a1,s0,-464
    8000612e:	078e                	slli	a5,a5,0x3
    80006130:	97ae                	add	a5,a5,a1
    80006132:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006136:	f3040513          	addi	a0,s0,-208
    8000613a:	fffff097          	auipc	ra,0xfffff
    8000613e:	118080e7          	jalr	280(ra) # 80005252 <exec>
    80006142:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006144:	100a0a13          	addi	s4,s4,256
    80006148:	6088                	ld	a0,0(s1)
    8000614a:	c901                	beqz	a0,8000615a <sys_exec+0x106>
    kfree(argv[i]);
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	900080e7          	jalr	-1792(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006154:	04a1                	addi	s1,s1,8
    80006156:	ff4499e3          	bne	s1,s4,80006148 <sys_exec+0xf4>
  return ret;
    8000615a:	854a                	mv	a0,s2
    8000615c:	64be                	ld	s1,456(sp)
    8000615e:	691e                	ld	s2,448(sp)
    80006160:	79fa                	ld	s3,440(sp)
    80006162:	7a5a                	ld	s4,432(sp)
    80006164:	7aba                	ld	s5,424(sp)
    80006166:	7b1a                	ld	s6,416(sp)
    80006168:	6bfa                	ld	s7,408(sp)
    8000616a:	a809                	j	8000617c <sys_exec+0x128>
  return -1;
    8000616c:	557d                	li	a0,-1
    8000616e:	64be                	ld	s1,456(sp)
    80006170:	691e                	ld	s2,448(sp)
    80006172:	79fa                	ld	s3,440(sp)
    80006174:	7a5a                	ld	s4,432(sp)
    80006176:	7aba                	ld	s5,424(sp)
    80006178:	7b1a                	ld	s6,416(sp)
    8000617a:	6bfa                	ld	s7,408(sp)
}
    8000617c:	60fe                	ld	ra,472(sp)
    8000617e:	645e                	ld	s0,464(sp)
    80006180:	613d                	addi	sp,sp,480
    80006182:	8082                	ret

0000000080006184 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006184:	7139                	addi	sp,sp,-64
    80006186:	fc06                	sd	ra,56(sp)
    80006188:	f822                	sd	s0,48(sp)
    8000618a:	f426                	sd	s1,40(sp)
    8000618c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000618e:	ffffc097          	auipc	ra,0xffffc
    80006192:	8da080e7          	jalr	-1830(ra) # 80001a68 <myproc>
    80006196:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006198:	fd840593          	addi	a1,s0,-40
    8000619c:	4501                	li	a0,0
    8000619e:	ffffd097          	auipc	ra,0xffffd
    800061a2:	d8e080e7          	jalr	-626(ra) # 80002f2c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800061a6:	fc840593          	addi	a1,s0,-56
    800061aa:	fd040513          	addi	a0,s0,-48
    800061ae:	fffff097          	auipc	ra,0xfffff
    800061b2:	d0e080e7          	jalr	-754(ra) # 80004ebc <pipealloc>
    return -1;
    800061b6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800061b8:	0c054463          	bltz	a0,80006280 <sys_pipe+0xfc>
  fd0 = -1;
    800061bc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800061c0:	fd043503          	ld	a0,-48(s0)
    800061c4:	fffff097          	auipc	ra,0xfffff
    800061c8:	4b6080e7          	jalr	1206(ra) # 8000567a <fdalloc>
    800061cc:	fca42223          	sw	a0,-60(s0)
    800061d0:	08054b63          	bltz	a0,80006266 <sys_pipe+0xe2>
    800061d4:	fc843503          	ld	a0,-56(s0)
    800061d8:	fffff097          	auipc	ra,0xfffff
    800061dc:	4a2080e7          	jalr	1186(ra) # 8000567a <fdalloc>
    800061e0:	fca42023          	sw	a0,-64(s0)
    800061e4:	06054863          	bltz	a0,80006254 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800061e8:	4691                	li	a3,4
    800061ea:	fc440613          	addi	a2,s0,-60
    800061ee:	fd843583          	ld	a1,-40(s0)
    800061f2:	68a8                	ld	a0,80(s1)
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	51c080e7          	jalr	1308(ra) # 80001710 <copyout>
    800061fc:	02054063          	bltz	a0,8000621c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006200:	4691                	li	a3,4
    80006202:	fc040613          	addi	a2,s0,-64
    80006206:	fd843583          	ld	a1,-40(s0)
    8000620a:	95b6                	add	a1,a1,a3
    8000620c:	68a8                	ld	a0,80(s1)
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	502080e7          	jalr	1282(ra) # 80001710 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006216:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006218:	06055463          	bgez	a0,80006280 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000621c:	fc442783          	lw	a5,-60(s0)
    80006220:	07e9                	addi	a5,a5,26
    80006222:	078e                	slli	a5,a5,0x3
    80006224:	97a6                	add	a5,a5,s1
    80006226:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000622a:	fc042783          	lw	a5,-64(s0)
    8000622e:	07e9                	addi	a5,a5,26
    80006230:	078e                	slli	a5,a5,0x3
    80006232:	94be                	add	s1,s1,a5
    80006234:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006238:	fd043503          	ld	a0,-48(s0)
    8000623c:	fffff097          	auipc	ra,0xfffff
    80006240:	90c080e7          	jalr	-1780(ra) # 80004b48 <fileclose>
    fileclose(wf);
    80006244:	fc843503          	ld	a0,-56(s0)
    80006248:	fffff097          	auipc	ra,0xfffff
    8000624c:	900080e7          	jalr	-1792(ra) # 80004b48 <fileclose>
    return -1;
    80006250:	57fd                	li	a5,-1
    80006252:	a03d                	j	80006280 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006254:	fc442783          	lw	a5,-60(s0)
    80006258:	0007c763          	bltz	a5,80006266 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000625c:	07e9                	addi	a5,a5,26
    8000625e:	078e                	slli	a5,a5,0x3
    80006260:	97a6                	add	a5,a5,s1
    80006262:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006266:	fd043503          	ld	a0,-48(s0)
    8000626a:	fffff097          	auipc	ra,0xfffff
    8000626e:	8de080e7          	jalr	-1826(ra) # 80004b48 <fileclose>
    fileclose(wf);
    80006272:	fc843503          	ld	a0,-56(s0)
    80006276:	fffff097          	auipc	ra,0xfffff
    8000627a:	8d2080e7          	jalr	-1838(ra) # 80004b48 <fileclose>
    return -1;
    8000627e:	57fd                	li	a5,-1
}
    80006280:	853e                	mv	a0,a5
    80006282:	70e2                	ld	ra,56(sp)
    80006284:	7442                	ld	s0,48(sp)
    80006286:	74a2                	ld	s1,40(sp)
    80006288:	6121                	addi	sp,sp,64
    8000628a:	8082                	ret
    8000628c:	0000                	unimp
	...

0000000080006290 <kernelvec>:
    80006290:	7111                	addi	sp,sp,-256
    80006292:	e006                	sd	ra,0(sp)
    80006294:	e40a                	sd	sp,8(sp)
    80006296:	e80e                	sd	gp,16(sp)
    80006298:	ec12                	sd	tp,24(sp)
    8000629a:	f016                	sd	t0,32(sp)
    8000629c:	f41a                	sd	t1,40(sp)
    8000629e:	f81e                	sd	t2,48(sp)
    800062a0:	fc22                	sd	s0,56(sp)
    800062a2:	e0a6                	sd	s1,64(sp)
    800062a4:	e4aa                	sd	a0,72(sp)
    800062a6:	e8ae                	sd	a1,80(sp)
    800062a8:	ecb2                	sd	a2,88(sp)
    800062aa:	f0b6                	sd	a3,96(sp)
    800062ac:	f4ba                	sd	a4,104(sp)
    800062ae:	f8be                	sd	a5,112(sp)
    800062b0:	fcc2                	sd	a6,120(sp)
    800062b2:	e146                	sd	a7,128(sp)
    800062b4:	e54a                	sd	s2,136(sp)
    800062b6:	e94e                	sd	s3,144(sp)
    800062b8:	ed52                	sd	s4,152(sp)
    800062ba:	f156                	sd	s5,160(sp)
    800062bc:	f55a                	sd	s6,168(sp)
    800062be:	f95e                	sd	s7,176(sp)
    800062c0:	fd62                	sd	s8,184(sp)
    800062c2:	e1e6                	sd	s9,192(sp)
    800062c4:	e5ea                	sd	s10,200(sp)
    800062c6:	e9ee                	sd	s11,208(sp)
    800062c8:	edf2                	sd	t3,216(sp)
    800062ca:	f1f6                	sd	t4,224(sp)
    800062cc:	f5fa                	sd	t5,232(sp)
    800062ce:	f9fe                	sd	t6,240(sp)
    800062d0:	a6bfc0ef          	jal	80002d3a <kerneltrap>
    800062d4:	6082                	ld	ra,0(sp)
    800062d6:	6122                	ld	sp,8(sp)
    800062d8:	61c2                	ld	gp,16(sp)
    800062da:	7282                	ld	t0,32(sp)
    800062dc:	7322                	ld	t1,40(sp)
    800062de:	73c2                	ld	t2,48(sp)
    800062e0:	7462                	ld	s0,56(sp)
    800062e2:	6486                	ld	s1,64(sp)
    800062e4:	6526                	ld	a0,72(sp)
    800062e6:	65c6                	ld	a1,80(sp)
    800062e8:	6666                	ld	a2,88(sp)
    800062ea:	7686                	ld	a3,96(sp)
    800062ec:	7726                	ld	a4,104(sp)
    800062ee:	77c6                	ld	a5,112(sp)
    800062f0:	7866                	ld	a6,120(sp)
    800062f2:	688a                	ld	a7,128(sp)
    800062f4:	692a                	ld	s2,136(sp)
    800062f6:	69ca                	ld	s3,144(sp)
    800062f8:	6a6a                	ld	s4,152(sp)
    800062fa:	7a8a                	ld	s5,160(sp)
    800062fc:	7b2a                	ld	s6,168(sp)
    800062fe:	7bca                	ld	s7,176(sp)
    80006300:	7c6a                	ld	s8,184(sp)
    80006302:	6c8e                	ld	s9,192(sp)
    80006304:	6d2e                	ld	s10,200(sp)
    80006306:	6dce                	ld	s11,208(sp)
    80006308:	6e6e                	ld	t3,216(sp)
    8000630a:	7e8e                	ld	t4,224(sp)
    8000630c:	7f2e                	ld	t5,232(sp)
    8000630e:	7fce                	ld	t6,240(sp)
    80006310:	6111                	addi	sp,sp,256
    80006312:	10200073          	sret
    80006316:	00000013          	nop
    8000631a:	00000013          	nop
    8000631e:	0001                	nop

0000000080006320 <timervec>:
    80006320:	34051573          	csrrw	a0,mscratch,a0
    80006324:	e10c                	sd	a1,0(a0)
    80006326:	e510                	sd	a2,8(a0)
    80006328:	e914                	sd	a3,16(a0)
    8000632a:	6d0c                	ld	a1,24(a0)
    8000632c:	7110                	ld	a2,32(a0)
    8000632e:	6194                	ld	a3,0(a1)
    80006330:	96b2                	add	a3,a3,a2
    80006332:	e194                	sd	a3,0(a1)
    80006334:	4589                	li	a1,2
    80006336:	14459073          	csrw	sip,a1
    8000633a:	6914                	ld	a3,16(a0)
    8000633c:	6510                	ld	a2,8(a0)
    8000633e:	610c                	ld	a1,0(a0)
    80006340:	34051573          	csrrw	a0,mscratch,a0
    80006344:	30200073          	mret
	...

000000008000634a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000634a:	1141                	addi	sp,sp,-16
    8000634c:	e406                	sd	ra,8(sp)
    8000634e:	e022                	sd	s0,0(sp)
    80006350:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006352:	0c000737          	lui	a4,0xc000
    80006356:	4785                	li	a5,1
    80006358:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000635a:	c35c                	sw	a5,4(a4)
}
    8000635c:	60a2                	ld	ra,8(sp)
    8000635e:	6402                	ld	s0,0(sp)
    80006360:	0141                	addi	sp,sp,16
    80006362:	8082                	ret

0000000080006364 <plicinithart>:

void
plicinithart(void)
{
    80006364:	1141                	addi	sp,sp,-16
    80006366:	e406                	sd	ra,8(sp)
    80006368:	e022                	sd	s0,0(sp)
    8000636a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	6c8080e7          	jalr	1736(ra) # 80001a34 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006374:	0085171b          	slliw	a4,a0,0x8
    80006378:	0c0027b7          	lui	a5,0xc002
    8000637c:	97ba                	add	a5,a5,a4
    8000637e:	40200713          	li	a4,1026
    80006382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006386:	00d5151b          	slliw	a0,a0,0xd
    8000638a:	0c2017b7          	lui	a5,0xc201
    8000638e:	97aa                	add	a5,a5,a0
    80006390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006394:	60a2                	ld	ra,8(sp)
    80006396:	6402                	ld	s0,0(sp)
    80006398:	0141                	addi	sp,sp,16
    8000639a:	8082                	ret

000000008000639c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000639c:	1141                	addi	sp,sp,-16
    8000639e:	e406                	sd	ra,8(sp)
    800063a0:	e022                	sd	s0,0(sp)
    800063a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063a4:	ffffb097          	auipc	ra,0xffffb
    800063a8:	690080e7          	jalr	1680(ra) # 80001a34 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063ac:	00d5151b          	slliw	a0,a0,0xd
    800063b0:	0c2017b7          	lui	a5,0xc201
    800063b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800063b6:	43c8                	lw	a0,4(a5)
    800063b8:	60a2                	ld	ra,8(sp)
    800063ba:	6402                	ld	s0,0(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret

00000000800063c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800063c0:	1101                	addi	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	addi	s0,sp,32
    800063ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	668080e7          	jalr	1640(ra) # 80001a34 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800063d4:	00d5179b          	slliw	a5,a0,0xd
    800063d8:	0c201737          	lui	a4,0xc201
    800063dc:	97ba                	add	a5,a5,a4
    800063de:	c3c4                	sw	s1,4(a5)
}
    800063e0:	60e2                	ld	ra,24(sp)
    800063e2:	6442                	ld	s0,16(sp)
    800063e4:	64a2                	ld	s1,8(sp)
    800063e6:	6105                	addi	sp,sp,32
    800063e8:	8082                	ret

00000000800063ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800063ea:	1141                	addi	sp,sp,-16
    800063ec:	e406                	sd	ra,8(sp)
    800063ee:	e022                	sd	s0,0(sp)
    800063f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800063f2:	479d                	li	a5,7
    800063f4:	04a7cc63          	blt	a5,a0,8000644c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800063f8:	0001f797          	auipc	a5,0x1f
    800063fc:	a3878793          	addi	a5,a5,-1480 # 80024e30 <disk>
    80006400:	97aa                	add	a5,a5,a0
    80006402:	0187c783          	lbu	a5,24(a5)
    80006406:	ebb9                	bnez	a5,8000645c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006408:	00451693          	slli	a3,a0,0x4
    8000640c:	0001f797          	auipc	a5,0x1f
    80006410:	a2478793          	addi	a5,a5,-1500 # 80024e30 <disk>
    80006414:	6398                	ld	a4,0(a5)
    80006416:	9736                	add	a4,a4,a3
    80006418:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000641c:	6398                	ld	a4,0(a5)
    8000641e:	9736                	add	a4,a4,a3
    80006420:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006424:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006428:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000642c:	97aa                	add	a5,a5,a0
    8000642e:	4705                	li	a4,1
    80006430:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006434:	0001f517          	auipc	a0,0x1f
    80006438:	a1450513          	addi	a0,a0,-1516 # 80024e48 <disk+0x18>
    8000643c:	ffffc097          	auipc	ra,0xffffc
    80006440:	e88080e7          	jalr	-376(ra) # 800022c4 <wakeup>
}
    80006444:	60a2                	ld	ra,8(sp)
    80006446:	6402                	ld	s0,0(sp)
    80006448:	0141                	addi	sp,sp,16
    8000644a:	8082                	ret
    panic("free_desc 1");
    8000644c:	00002517          	auipc	a0,0x2
    80006450:	1dc50513          	addi	a0,a0,476 # 80008628 <etext+0x628>
    80006454:	ffffa097          	auipc	ra,0xffffa
    80006458:	10c080e7          	jalr	268(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000645c:	00002517          	auipc	a0,0x2
    80006460:	1dc50513          	addi	a0,a0,476 # 80008638 <etext+0x638>
    80006464:	ffffa097          	auipc	ra,0xffffa
    80006468:	0fc080e7          	jalr	252(ra) # 80000560 <panic>

000000008000646c <virtio_disk_init>:
{
    8000646c:	1101                	addi	sp,sp,-32
    8000646e:	ec06                	sd	ra,24(sp)
    80006470:	e822                	sd	s0,16(sp)
    80006472:	e426                	sd	s1,8(sp)
    80006474:	e04a                	sd	s2,0(sp)
    80006476:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006478:	00002597          	auipc	a1,0x2
    8000647c:	1d058593          	addi	a1,a1,464 # 80008648 <etext+0x648>
    80006480:	0001f517          	auipc	a0,0x1f
    80006484:	ad850513          	addi	a0,a0,-1320 # 80024f58 <disk+0x128>
    80006488:	ffffa097          	auipc	ra,0xffffa
    8000648c:	722080e7          	jalr	1826(ra) # 80000baa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006490:	100017b7          	lui	a5,0x10001
    80006494:	4398                	lw	a4,0(a5)
    80006496:	2701                	sext.w	a4,a4
    80006498:	747277b7          	lui	a5,0x74727
    8000649c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064a0:	16f71463          	bne	a4,a5,80006608 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064a4:	100017b7          	lui	a5,0x10001
    800064a8:	43dc                	lw	a5,4(a5)
    800064aa:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064ac:	4709                	li	a4,2
    800064ae:	14e79d63          	bne	a5,a4,80006608 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064b2:	100017b7          	lui	a5,0x10001
    800064b6:	479c                	lw	a5,8(a5)
    800064b8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064ba:	14e79763          	bne	a5,a4,80006608 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800064be:	100017b7          	lui	a5,0x10001
    800064c2:	47d8                	lw	a4,12(a5)
    800064c4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800064c6:	554d47b7          	lui	a5,0x554d4
    800064ca:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800064ce:	12f71d63          	bne	a4,a5,80006608 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064d2:	100017b7          	lui	a5,0x10001
    800064d6:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800064da:	4705                	li	a4,1
    800064dc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064de:	470d                	li	a4,3
    800064e0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800064e2:	10001737          	lui	a4,0x10001
    800064e6:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800064e8:	c7ffe6b7          	lui	a3,0xc7ffe
    800064ec:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd97ef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800064f0:	8f75                	and	a4,a4,a3
    800064f2:	100016b7          	lui	a3,0x10001
    800064f6:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064f8:	472d                	li	a4,11
    800064fa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800064fc:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006500:	439c                	lw	a5,0(a5)
    80006502:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006506:	8ba1                	andi	a5,a5,8
    80006508:	10078863          	beqz	a5,80006618 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000650c:	100017b7          	lui	a5,0x10001
    80006510:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006514:	43fc                	lw	a5,68(a5)
    80006516:	2781                	sext.w	a5,a5
    80006518:	10079863          	bnez	a5,80006628 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000651c:	100017b7          	lui	a5,0x10001
    80006520:	5bdc                	lw	a5,52(a5)
    80006522:	2781                	sext.w	a5,a5
  if(max == 0)
    80006524:	10078a63          	beqz	a5,80006638 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006528:	471d                	li	a4,7
    8000652a:	10f77f63          	bgeu	a4,a5,80006648 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000652e:	ffffa097          	auipc	ra,0xffffa
    80006532:	61c080e7          	jalr	1564(ra) # 80000b4a <kalloc>
    80006536:	0001f497          	auipc	s1,0x1f
    8000653a:	8fa48493          	addi	s1,s1,-1798 # 80024e30 <disk>
    8000653e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006540:	ffffa097          	auipc	ra,0xffffa
    80006544:	60a080e7          	jalr	1546(ra) # 80000b4a <kalloc>
    80006548:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000654a:	ffffa097          	auipc	ra,0xffffa
    8000654e:	600080e7          	jalr	1536(ra) # 80000b4a <kalloc>
    80006552:	87aa                	mv	a5,a0
    80006554:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006556:	6088                	ld	a0,0(s1)
    80006558:	10050063          	beqz	a0,80006658 <virtio_disk_init+0x1ec>
    8000655c:	0001f717          	auipc	a4,0x1f
    80006560:	8dc73703          	ld	a4,-1828(a4) # 80024e38 <disk+0x8>
    80006564:	cb75                	beqz	a4,80006658 <virtio_disk_init+0x1ec>
    80006566:	cbed                	beqz	a5,80006658 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006568:	6605                	lui	a2,0x1
    8000656a:	4581                	li	a1,0
    8000656c:	ffffa097          	auipc	ra,0xffffa
    80006570:	7ca080e7          	jalr	1994(ra) # 80000d36 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006574:	0001f497          	auipc	s1,0x1f
    80006578:	8bc48493          	addi	s1,s1,-1860 # 80024e30 <disk>
    8000657c:	6605                	lui	a2,0x1
    8000657e:	4581                	li	a1,0
    80006580:	6488                	ld	a0,8(s1)
    80006582:	ffffa097          	auipc	ra,0xffffa
    80006586:	7b4080e7          	jalr	1972(ra) # 80000d36 <memset>
  memset(disk.used, 0, PGSIZE);
    8000658a:	6605                	lui	a2,0x1
    8000658c:	4581                	li	a1,0
    8000658e:	6888                	ld	a0,16(s1)
    80006590:	ffffa097          	auipc	ra,0xffffa
    80006594:	7a6080e7          	jalr	1958(ra) # 80000d36 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006598:	100017b7          	lui	a5,0x10001
    8000659c:	4721                	li	a4,8
    8000659e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065a0:	4098                	lw	a4,0(s1)
    800065a2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065a6:	40d8                	lw	a4,4(s1)
    800065a8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065ac:	649c                	ld	a5,8(s1)
    800065ae:	0007869b          	sext.w	a3,a5
    800065b2:	10001737          	lui	a4,0x10001
    800065b6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800065ba:	9781                	srai	a5,a5,0x20
    800065bc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800065c0:	689c                	ld	a5,16(s1)
    800065c2:	0007869b          	sext.w	a3,a5
    800065c6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800065ca:	9781                	srai	a5,a5,0x20
    800065cc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800065d0:	4785                	li	a5,1
    800065d2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800065d4:	00f48c23          	sb	a5,24(s1)
    800065d8:	00f48ca3          	sb	a5,25(s1)
    800065dc:	00f48d23          	sb	a5,26(s1)
    800065e0:	00f48da3          	sb	a5,27(s1)
    800065e4:	00f48e23          	sb	a5,28(s1)
    800065e8:	00f48ea3          	sb	a5,29(s1)
    800065ec:	00f48f23          	sb	a5,30(s1)
    800065f0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800065f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800065f8:	07272823          	sw	s2,112(a4)
}
    800065fc:	60e2                	ld	ra,24(sp)
    800065fe:	6442                	ld	s0,16(sp)
    80006600:	64a2                	ld	s1,8(sp)
    80006602:	6902                	ld	s2,0(sp)
    80006604:	6105                	addi	sp,sp,32
    80006606:	8082                	ret
    panic("could not find virtio disk");
    80006608:	00002517          	auipc	a0,0x2
    8000660c:	05050513          	addi	a0,a0,80 # 80008658 <etext+0x658>
    80006610:	ffffa097          	auipc	ra,0xffffa
    80006614:	f50080e7          	jalr	-176(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006618:	00002517          	auipc	a0,0x2
    8000661c:	06050513          	addi	a0,a0,96 # 80008678 <etext+0x678>
    80006620:	ffffa097          	auipc	ra,0xffffa
    80006624:	f40080e7          	jalr	-192(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006628:	00002517          	auipc	a0,0x2
    8000662c:	07050513          	addi	a0,a0,112 # 80008698 <etext+0x698>
    80006630:	ffffa097          	auipc	ra,0xffffa
    80006634:	f30080e7          	jalr	-208(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006638:	00002517          	auipc	a0,0x2
    8000663c:	08050513          	addi	a0,a0,128 # 800086b8 <etext+0x6b8>
    80006640:	ffffa097          	auipc	ra,0xffffa
    80006644:	f20080e7          	jalr	-224(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	09050513          	addi	a0,a0,144 # 800086d8 <etext+0x6d8>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	f10080e7          	jalr	-240(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	0a050513          	addi	a0,a0,160 # 800086f8 <etext+0x6f8>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>

0000000080006668 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006668:	711d                	addi	sp,sp,-96
    8000666a:	ec86                	sd	ra,88(sp)
    8000666c:	e8a2                	sd	s0,80(sp)
    8000666e:	e4a6                	sd	s1,72(sp)
    80006670:	e0ca                	sd	s2,64(sp)
    80006672:	fc4e                	sd	s3,56(sp)
    80006674:	f852                	sd	s4,48(sp)
    80006676:	f456                	sd	s5,40(sp)
    80006678:	f05a                	sd	s6,32(sp)
    8000667a:	ec5e                	sd	s7,24(sp)
    8000667c:	e862                	sd	s8,16(sp)
    8000667e:	1080                	addi	s0,sp,96
    80006680:	89aa                	mv	s3,a0
    80006682:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006684:	00c52b83          	lw	s7,12(a0)
    80006688:	001b9b9b          	slliw	s7,s7,0x1
    8000668c:	1b82                	slli	s7,s7,0x20
    8000668e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006692:	0001f517          	auipc	a0,0x1f
    80006696:	8c650513          	addi	a0,a0,-1850 # 80024f58 <disk+0x128>
    8000669a:	ffffa097          	auipc	ra,0xffffa
    8000669e:	5a4080e7          	jalr	1444(ra) # 80000c3e <acquire>
  for(int i = 0; i < NUM; i++){
    800066a2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066a4:	0001ea97          	auipc	s5,0x1e
    800066a8:	78ca8a93          	addi	s5,s5,1932 # 80024e30 <disk>
  for(int i = 0; i < 3; i++){
    800066ac:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800066ae:	5c7d                	li	s8,-1
    800066b0:	a885                	j	80006720 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800066b2:	00fa8733          	add	a4,s5,a5
    800066b6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800066ba:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800066bc:	0207c563          	bltz	a5,800066e6 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    800066c0:	2905                	addiw	s2,s2,1
    800066c2:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800066c4:	07490263          	beq	s2,s4,80006728 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    800066c8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800066ca:	0001e717          	auipc	a4,0x1e
    800066ce:	76670713          	addi	a4,a4,1894 # 80024e30 <disk>
    800066d2:	4781                	li	a5,0
    if(disk.free[i]){
    800066d4:	01874683          	lbu	a3,24(a4)
    800066d8:	fee9                	bnez	a3,800066b2 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800066da:	2785                	addiw	a5,a5,1
    800066dc:	0705                	addi	a4,a4,1
    800066de:	fe979be3          	bne	a5,s1,800066d4 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    800066e2:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800066e6:	03205163          	blez	s2,80006708 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800066ea:	fa042503          	lw	a0,-96(s0)
    800066ee:	00000097          	auipc	ra,0x0
    800066f2:	cfc080e7          	jalr	-772(ra) # 800063ea <free_desc>
      for(int j = 0; j < i; j++)
    800066f6:	4785                	li	a5,1
    800066f8:	0127d863          	bge	a5,s2,80006708 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    800066fc:	fa442503          	lw	a0,-92(s0)
    80006700:	00000097          	auipc	ra,0x0
    80006704:	cea080e7          	jalr	-790(ra) # 800063ea <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006708:	0001f597          	auipc	a1,0x1f
    8000670c:	85058593          	addi	a1,a1,-1968 # 80024f58 <disk+0x128>
    80006710:	0001e517          	auipc	a0,0x1e
    80006714:	73850513          	addi	a0,a0,1848 # 80024e48 <disk+0x18>
    80006718:	ffffc097          	auipc	ra,0xffffc
    8000671c:	b48080e7          	jalr	-1208(ra) # 80002260 <sleep>
  for(int i = 0; i < 3; i++){
    80006720:	fa040613          	addi	a2,s0,-96
    80006724:	4901                	li	s2,0
    80006726:	b74d                	j	800066c8 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006728:	fa042503          	lw	a0,-96(s0)
    8000672c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006730:	0001e797          	auipc	a5,0x1e
    80006734:	70078793          	addi	a5,a5,1792 # 80024e30 <disk>
    80006738:	00a50713          	addi	a4,a0,10
    8000673c:	0712                	slli	a4,a4,0x4
    8000673e:	973e                	add	a4,a4,a5
    80006740:	01603633          	snez	a2,s6
    80006744:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006746:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000674a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000674e:	6398                	ld	a4,0(a5)
    80006750:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006752:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006756:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006758:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000675a:	6390                	ld	a2,0(a5)
    8000675c:	00d605b3          	add	a1,a2,a3
    80006760:	4741                	li	a4,16
    80006762:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006764:	4805                	li	a6,1
    80006766:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000676a:	fa442703          	lw	a4,-92(s0)
    8000676e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006772:	0712                	slli	a4,a4,0x4
    80006774:	963a                	add	a2,a2,a4
    80006776:	05898593          	addi	a1,s3,88
    8000677a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000677c:	0007b883          	ld	a7,0(a5)
    80006780:	9746                	add	a4,a4,a7
    80006782:	40000613          	li	a2,1024
    80006786:	c710                	sw	a2,8(a4)
  if(write)
    80006788:	001b3613          	seqz	a2,s6
    8000678c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006790:	01066633          	or	a2,a2,a6
    80006794:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006798:	fa842583          	lw	a1,-88(s0)
    8000679c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067a0:	00250613          	addi	a2,a0,2
    800067a4:	0612                	slli	a2,a2,0x4
    800067a6:	963e                	add	a2,a2,a5
    800067a8:	577d                	li	a4,-1
    800067aa:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800067ae:	0592                	slli	a1,a1,0x4
    800067b0:	98ae                	add	a7,a7,a1
    800067b2:	03068713          	addi	a4,a3,48
    800067b6:	973e                	add	a4,a4,a5
    800067b8:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800067bc:	6398                	ld	a4,0(a5)
    800067be:	972e                	add	a4,a4,a1
    800067c0:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800067c4:	4689                	li	a3,2
    800067c6:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800067ca:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800067ce:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800067d2:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800067d6:	6794                	ld	a3,8(a5)
    800067d8:	0026d703          	lhu	a4,2(a3)
    800067dc:	8b1d                	andi	a4,a4,7
    800067de:	0706                	slli	a4,a4,0x1
    800067e0:	96ba                	add	a3,a3,a4
    800067e2:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800067e6:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800067ea:	6798                	ld	a4,8(a5)
    800067ec:	00275783          	lhu	a5,2(a4)
    800067f0:	2785                	addiw	a5,a5,1
    800067f2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800067f6:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800067fa:	100017b7          	lui	a5,0x10001
    800067fe:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006802:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006806:	0001e917          	auipc	s2,0x1e
    8000680a:	75290913          	addi	s2,s2,1874 # 80024f58 <disk+0x128>
  while(b->disk == 1) {
    8000680e:	84c2                	mv	s1,a6
    80006810:	01079c63          	bne	a5,a6,80006828 <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006814:	85ca                	mv	a1,s2
    80006816:	854e                	mv	a0,s3
    80006818:	ffffc097          	auipc	ra,0xffffc
    8000681c:	a48080e7          	jalr	-1464(ra) # 80002260 <sleep>
  while(b->disk == 1) {
    80006820:	0049a783          	lw	a5,4(s3)
    80006824:	fe9788e3          	beq	a5,s1,80006814 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006828:	fa042903          	lw	s2,-96(s0)
    8000682c:	00290713          	addi	a4,s2,2
    80006830:	0712                	slli	a4,a4,0x4
    80006832:	0001e797          	auipc	a5,0x1e
    80006836:	5fe78793          	addi	a5,a5,1534 # 80024e30 <disk>
    8000683a:	97ba                	add	a5,a5,a4
    8000683c:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006840:	0001e997          	auipc	s3,0x1e
    80006844:	5f098993          	addi	s3,s3,1520 # 80024e30 <disk>
    80006848:	00491713          	slli	a4,s2,0x4
    8000684c:	0009b783          	ld	a5,0(s3)
    80006850:	97ba                	add	a5,a5,a4
    80006852:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006856:	854a                	mv	a0,s2
    80006858:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000685c:	00000097          	auipc	ra,0x0
    80006860:	b8e080e7          	jalr	-1138(ra) # 800063ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006864:	8885                	andi	s1,s1,1
    80006866:	f0ed                	bnez	s1,80006848 <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006868:	0001e517          	auipc	a0,0x1e
    8000686c:	6f050513          	addi	a0,a0,1776 # 80024f58 <disk+0x128>
    80006870:	ffffa097          	auipc	ra,0xffffa
    80006874:	47e080e7          	jalr	1150(ra) # 80000cee <release>
}
    80006878:	60e6                	ld	ra,88(sp)
    8000687a:	6446                	ld	s0,80(sp)
    8000687c:	64a6                	ld	s1,72(sp)
    8000687e:	6906                	ld	s2,64(sp)
    80006880:	79e2                	ld	s3,56(sp)
    80006882:	7a42                	ld	s4,48(sp)
    80006884:	7aa2                	ld	s5,40(sp)
    80006886:	7b02                	ld	s6,32(sp)
    80006888:	6be2                	ld	s7,24(sp)
    8000688a:	6c42                	ld	s8,16(sp)
    8000688c:	6125                	addi	sp,sp,96
    8000688e:	8082                	ret

0000000080006890 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006890:	1101                	addi	sp,sp,-32
    80006892:	ec06                	sd	ra,24(sp)
    80006894:	e822                	sd	s0,16(sp)
    80006896:	e426                	sd	s1,8(sp)
    80006898:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000689a:	0001e497          	auipc	s1,0x1e
    8000689e:	59648493          	addi	s1,s1,1430 # 80024e30 <disk>
    800068a2:	0001e517          	auipc	a0,0x1e
    800068a6:	6b650513          	addi	a0,a0,1718 # 80024f58 <disk+0x128>
    800068aa:	ffffa097          	auipc	ra,0xffffa
    800068ae:	394080e7          	jalr	916(ra) # 80000c3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800068b2:	100017b7          	lui	a5,0x10001
    800068b6:	53bc                	lw	a5,96(a5)
    800068b8:	8b8d                	andi	a5,a5,3
    800068ba:	10001737          	lui	a4,0x10001
    800068be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800068c0:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800068c4:	689c                	ld	a5,16(s1)
    800068c6:	0204d703          	lhu	a4,32(s1)
    800068ca:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800068ce:	04f70863          	beq	a4,a5,8000691e <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800068d2:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800068d6:	6898                	ld	a4,16(s1)
    800068d8:	0204d783          	lhu	a5,32(s1)
    800068dc:	8b9d                	andi	a5,a5,7
    800068de:	078e                	slli	a5,a5,0x3
    800068e0:	97ba                	add	a5,a5,a4
    800068e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800068e4:	00278713          	addi	a4,a5,2
    800068e8:	0712                	slli	a4,a4,0x4
    800068ea:	9726                	add	a4,a4,s1
    800068ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800068f0:	e721                	bnez	a4,80006938 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800068f2:	0789                	addi	a5,a5,2
    800068f4:	0792                	slli	a5,a5,0x4
    800068f6:	97a6                	add	a5,a5,s1
    800068f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800068fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800068fe:	ffffc097          	auipc	ra,0xffffc
    80006902:	9c6080e7          	jalr	-1594(ra) # 800022c4 <wakeup>

    disk.used_idx += 1;
    80006906:	0204d783          	lhu	a5,32(s1)
    8000690a:	2785                	addiw	a5,a5,1
    8000690c:	17c2                	slli	a5,a5,0x30
    8000690e:	93c1                	srli	a5,a5,0x30
    80006910:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006914:	6898                	ld	a4,16(s1)
    80006916:	00275703          	lhu	a4,2(a4)
    8000691a:	faf71ce3          	bne	a4,a5,800068d2 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    8000691e:	0001e517          	auipc	a0,0x1e
    80006922:	63a50513          	addi	a0,a0,1594 # 80024f58 <disk+0x128>
    80006926:	ffffa097          	auipc	ra,0xffffa
    8000692a:	3c8080e7          	jalr	968(ra) # 80000cee <release>
}
    8000692e:	60e2                	ld	ra,24(sp)
    80006930:	6442                	ld	s0,16(sp)
    80006932:	64a2                	ld	s1,8(sp)
    80006934:	6105                	addi	sp,sp,32
    80006936:	8082                	ret
      panic("virtio_disk_intr status");
    80006938:	00002517          	auipc	a0,0x2
    8000693c:	dd850513          	addi	a0,a0,-552 # 80008710 <etext+0x710>
    80006940:	ffffa097          	auipc	ra,0xffffa
    80006944:	c20080e7          	jalr	-992(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
