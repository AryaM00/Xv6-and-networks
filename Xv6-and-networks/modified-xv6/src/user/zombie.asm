
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2d4080e7          	jalr	724(ra) # 2dc <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2ce080e7          	jalr	718(ra) # 2e4 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	354080e7          	jalr	852(ra) # 374 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2a8080e7          	jalr	680(ra) # 2e4 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	addi	a1,a1,1
  50:	0785                	addi	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0xa>
    ;
  return os;
}
  5c:	60a2                	ld	ra,8(sp)
  5e:	6402                	ld	s0,0(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6c:	00054783          	lbu	a5,0(a0)
  70:	cb91                	beqz	a5,84 <strcmp+0x20>
  72:	0005c703          	lbu	a4,0(a1)
  76:	00f71763          	bne	a4,a5,84 <strcmp+0x20>
    p++, q++;
  7a:	0505                	addi	a0,a0,1
  7c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	fbe5                	bnez	a5,72 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  84:	0005c503          	lbu	a0,0(a1)
}
  88:	40a7853b          	subw	a0,a5,a0
  8c:	60a2                	ld	ra,8(sp)
  8e:	6402                	ld	s0,0(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strlen>:

uint
strlen(const char *s)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cf99                	beqz	a5,be <strlen+0x2a>
  a2:	0505                	addi	a0,a0,1
  a4:	87aa                	mv	a5,a0
  a6:	86be                	mv	a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	ff65                	bnez	a4,a6 <strlen+0x12>
  b0:	40a6853b          	subw	a0,a3,a0
  b4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret
  for(n = 0; s[n]; n++)
  be:	4501                	li	a0,0
  c0:	bfdd                	j	b6 <strlen+0x22>

00000000000000c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ca:	ca19                	beqz	a2,e0 <memset+0x1e>
  cc:	87aa                	mv	a5,a0
  ce:	1602                	slli	a2,a2,0x20
  d0:	9201                	srli	a2,a2,0x20
  d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  da:	0785                	addi	a5,a5,1
  dc:	fee79de3          	bne	a5,a4,d6 <memset+0x14>
  }
  return dst;
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cf81                	beqz	a5,10c <strchr+0x24>
    if(*s == c)
  f6:	00f58763          	beq	a1,a5,104 <strchr+0x1c>
  for(; *s; s++)
  fa:	0505                	addi	a0,a0,1
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbfd                	bnez	a5,f6 <strchr+0xe>
      return (char*)s;
  return 0;
 102:	4501                	li	a0,0
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  return 0;
 10c:	4501                	li	a0,0
 10e:	bfdd                	j	104 <strchr+0x1c>

0000000000000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	7159                	addi	sp,sp,-112
 112:	f486                	sd	ra,104(sp)
 114:	f0a2                	sd	s0,96(sp)
 116:	eca6                	sd	s1,88(sp)
 118:	e8ca                	sd	s2,80(sp)
 11a:	e4ce                	sd	s3,72(sp)
 11c:	e0d2                	sd	s4,64(sp)
 11e:	fc56                	sd	s5,56(sp)
 120:	f85a                	sd	s6,48(sp)
 122:	f45e                	sd	s7,40(sp)
 124:	f062                	sd	s8,32(sp)
 126:	ec66                	sd	s9,24(sp)
 128:	e86a                	sd	s10,16(sp)
 12a:	1880                	addi	s0,sp,112
 12c:	8caa                	mv	s9,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
 134:	f9f40b13          	addi	s6,s0,-97
 138:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4ba9                	li	s7,10
 13c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 13e:	8d26                	mv	s10,s1
 140:	0014899b          	addiw	s3,s1,1
 144:	84ce                	mv	s1,s3
 146:	0349d763          	bge	s3,s4,174 <gets+0x64>
    cc = read(0, &c, 1);
 14a:	8656                	mv	a2,s5
 14c:	85da                	mv	a1,s6
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	1ac080e7          	jalr	428(ra) # 2fc <read>
    if(cc < 1)
 158:	00a05e63          	blez	a0,174 <gets+0x64>
    buf[i++] = c;
 15c:	f9f44783          	lbu	a5,-97(s0)
 160:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 164:	01778763          	beq	a5,s7,172 <gets+0x62>
 168:	0905                	addi	s2,s2,1
 16a:	fd879ae3          	bne	a5,s8,13e <gets+0x2e>
    buf[i++] = c;
 16e:	8d4e                	mv	s10,s3
 170:	a011                	j	174 <gets+0x64>
 172:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 174:	9d66                	add	s10,s10,s9
 176:	000d0023          	sb	zero,0(s10)
  return buf;
}
 17a:	8566                	mv	a0,s9
 17c:	70a6                	ld	ra,104(sp)
 17e:	7406                	ld	s0,96(sp)
 180:	64e6                	ld	s1,88(sp)
 182:	6946                	ld	s2,80(sp)
 184:	69a6                	ld	s3,72(sp)
 186:	6a06                	ld	s4,64(sp)
 188:	7ae2                	ld	s5,56(sp)
 18a:	7b42                	ld	s6,48(sp)
 18c:	7ba2                	ld	s7,40(sp)
 18e:	7c02                	ld	s8,32(sp)
 190:	6ce2                	ld	s9,24(sp)
 192:	6d42                	ld	s10,16(sp)
 194:	6165                	addi	sp,sp,112
 196:	8082                	ret

0000000000000198 <stat>:

int
stat(const char *n, struct stat *st)
{
 198:	1101                	addi	sp,sp,-32
 19a:	ec06                	sd	ra,24(sp)
 19c:	e822                	sd	s0,16(sp)
 19e:	e04a                	sd	s2,0(sp)
 1a0:	1000                	addi	s0,sp,32
 1a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	4581                	li	a1,0
 1a6:	00000097          	auipc	ra,0x0
 1aa:	17e080e7          	jalr	382(ra) # 324 <open>
  if(fd < 0)
 1ae:	02054663          	bltz	a0,1da <stat+0x42>
 1b2:	e426                	sd	s1,8(sp)
 1b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b6:	85ca                	mv	a1,s2
 1b8:	00000097          	auipc	ra,0x0
 1bc:	184080e7          	jalr	388(ra) # 33c <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	148080e7          	jalr	328(ra) # 30c <close>
  return r;
 1cc:	64a2                	ld	s1,8(sp)
}
 1ce:	854a                	mv	a0,s2
 1d0:	60e2                	ld	ra,24(sp)
 1d2:	6442                	ld	s0,16(sp)
 1d4:	6902                	ld	s2,0(sp)
 1d6:	6105                	addi	sp,sp,32
 1d8:	8082                	ret
    return -1;
 1da:	597d                	li	s2,-1
 1dc:	bfcd                	j	1ce <stat+0x36>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e6:	00054683          	lbu	a3,0(a0)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	4625                	li	a2,9
 1f4:	02f66963          	bltu	a2,a5,226 <atoi+0x48>
 1f8:	872a                	mv	a4,a0
  n = 0;
 1fa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fc:	0705                	addi	a4,a4,1
 1fe:	0025179b          	slliw	a5,a0,0x2
 202:	9fa9                	addw	a5,a5,a0
 204:	0017979b          	slliw	a5,a5,0x1
 208:	9fb5                	addw	a5,a5,a3
 20a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20e:	00074683          	lbu	a3,0(a4)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef671e3          	bgeu	a2,a5,1fc <atoi+0x1e>
  return n;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfdd                	j	21e <atoi+0x40>

000000000000022a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57563          	bgeu	a0,a1,25c <memmove+0x32>
    while(n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x2a>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 262:	fec059e3          	blez	a2,254 <memmove+0x2a>
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 280:	fef71ae3          	bne	a4,a5,274 <memmove+0x4a>
 284:	bfc1                	j	254 <memmove+0x2a>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ca0d                	beqz	a2,2c0 <memcmp+0x3a>
 290:	fff6069b          	addiw	a3,a2,-1
 294:	1682                	slli	a3,a3,0x20
 296:	9281                	srli	a3,a3,0x20
 298:	0685                	addi	a3,a3,1
 29a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	addi	a0,a0,1
    p2++;
 2aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x16>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x32>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <memcmp+0x32>

00000000000002c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2cc:	00000097          	auipc	ra,0x0
 2d0:	f5e080e7          	jalr	-162(ra) # 22a <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2dc:	4885                	li	a7,1
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e4:	4889                	li	a7,2
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ec:	488d                	li	a7,3
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f4:	4891                	li	a7,4
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <read>:
.global read
read:
 li a7, SYS_read
 2fc:	4895                	li	a7,5
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <write>:
.global write
write:
 li a7, SYS_write
 304:	48c1                	li	a7,16
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <close>:
.global close
close:
 li a7, SYS_close
 30c:	48d5                	li	a7,21
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <kill>:
.global kill
kill:
 li a7, SYS_kill
 314:	4899                	li	a7,6
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exec>:
.global exec
exec:
 li a7, SYS_exec
 31c:	489d                	li	a7,7
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <open>:
.global open
open:
 li a7, SYS_open
 324:	48bd                	li	a7,15
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32c:	48c5                	li	a7,17
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 334:	48c9                	li	a7,18
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33c:	48a1                	li	a7,8
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <link>:
.global link
link:
 li a7, SYS_link
 344:	48cd                	li	a7,19
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34c:	48d1                	li	a7,20
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 354:	48a5                	li	a7,9
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dup>:
.global dup
dup:
 li a7, SYS_dup
 35c:	48a9                	li	a7,10
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 364:	48ad                	li	a7,11
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36c:	48b1                	li	a7,12
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 374:	48b5                	li	a7,13
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37c:	48b9                	li	a7,14
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 384:	48d9                	li	a7,22
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 38c:	48dd                	li	a7,23
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 394:	48e1                	li	a7,24
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 39c:	48e5                	li	a7,25
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 3a4:	48e9                	li	a7,26
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	00000097          	auipc	ra,0x0
 3c2:	f46080e7          	jalr	-186(ra) # 304 <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	7139                	addi	sp,sp,-64
 3d0:	fc06                	sd	ra,56(sp)
 3d2:	f822                	sd	s0,48(sp)
 3d4:	f426                	sd	s1,40(sp)
 3d6:	f04a                	sd	s2,32(sp)
 3d8:	ec4e                	sd	s3,24(sp)
 3da:	0080                	addi	s0,sp,64
 3dc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	c299                	beqz	a3,3e4 <printint+0x16>
 3e0:	0805c063          	bltz	a1,460 <printint+0x92>
  neg = 0;
 3e4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3ea:	869a                	mv	a3,t1
  i = 0;
 3ec:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ee:	00000817          	auipc	a6,0x0
 3f2:	49280813          	addi	a6,a6,1170 # 880 <digits>
 3f6:	88be                	mv	a7,a5
 3f8:	0017851b          	addiw	a0,a5,1
 3fc:	87aa                	mv	a5,a0
 3fe:	02c5f73b          	remuw	a4,a1,a2
 402:	1702                	slli	a4,a4,0x20
 404:	9301                	srli	a4,a4,0x20
 406:	9742                	add	a4,a4,a6
 408:	00074703          	lbu	a4,0(a4)
 40c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 410:	872e                	mv	a4,a1
 412:	02c5d5bb          	divuw	a1,a1,a2
 416:	0685                	addi	a3,a3,1
 418:	fcc77fe3          	bgeu	a4,a2,3f6 <printint+0x28>
  if(neg)
 41c:	000e0c63          	beqz	t3,434 <printint+0x66>
    buf[i++] = '-';
 420:	fd050793          	addi	a5,a0,-48
 424:	00878533          	add	a0,a5,s0
 428:	02d00793          	li	a5,45
 42c:	fef50823          	sb	a5,-16(a0)
 430:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 434:	fff7899b          	addiw	s3,a5,-1
 438:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 43c:	fff4c583          	lbu	a1,-1(s1)
 440:	854a                	mv	a0,s2
 442:	00000097          	auipc	ra,0x0
 446:	f6a080e7          	jalr	-150(ra) # 3ac <putc>
  while(--i >= 0)
 44a:	39fd                	addiw	s3,s3,-1
 44c:	14fd                	addi	s1,s1,-1
 44e:	fe09d7e3          	bgez	s3,43c <printint+0x6e>
}
 452:	70e2                	ld	ra,56(sp)
 454:	7442                	ld	s0,48(sp)
 456:	74a2                	ld	s1,40(sp)
 458:	7902                	ld	s2,32(sp)
 45a:	69e2                	ld	s3,24(sp)
 45c:	6121                	addi	sp,sp,64
 45e:	8082                	ret
    x = -xx;
 460:	40b005bb          	negw	a1,a1
    neg = 1;
 464:	4e05                	li	t3,1
    x = -xx;
 466:	b741                	j	3e6 <printint+0x18>

0000000000000468 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 468:	715d                	addi	sp,sp,-80
 46a:	e486                	sd	ra,72(sp)
 46c:	e0a2                	sd	s0,64(sp)
 46e:	f84a                	sd	s2,48(sp)
 470:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c903          	lbu	s2,0(a1)
 476:	1a090a63          	beqz	s2,62a <vprintf+0x1c2>
 47a:	fc26                	sd	s1,56(sp)
 47c:	f44e                	sd	s3,40(sp)
 47e:	f052                	sd	s4,32(sp)
 480:	ec56                	sd	s5,24(sp)
 482:	e85a                	sd	s6,16(sp)
 484:	e45e                	sd	s7,8(sp)
 486:	8aaa                	mv	s5,a0
 488:	8bb2                	mv	s7,a2
 48a:	00158493          	addi	s1,a1,1
  state = 0;
 48e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 490:	02500a13          	li	s4,37
 494:	4b55                	li	s6,21
 496:	a839                	j	4b4 <vprintf+0x4c>
        putc(fd, c);
 498:	85ca                	mv	a1,s2
 49a:	8556                	mv	a0,s5
 49c:	00000097          	auipc	ra,0x0
 4a0:	f10080e7          	jalr	-240(ra) # 3ac <putc>
 4a4:	a019                	j	4aa <vprintf+0x42>
    } else if(state == '%'){
 4a6:	01498d63          	beq	s3,s4,4c0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4aa:	0485                	addi	s1,s1,1
 4ac:	fff4c903          	lbu	s2,-1(s1)
 4b0:	16090763          	beqz	s2,61e <vprintf+0x1b6>
    if(state == 0){
 4b4:	fe0999e3          	bnez	s3,4a6 <vprintf+0x3e>
      if(c == '%'){
 4b8:	ff4910e3          	bne	s2,s4,498 <vprintf+0x30>
        state = '%';
 4bc:	89d2                	mv	s3,s4
 4be:	b7f5                	j	4aa <vprintf+0x42>
      if(c == 'd'){
 4c0:	13490463          	beq	s2,s4,5e8 <vprintf+0x180>
 4c4:	f9d9079b          	addiw	a5,s2,-99
 4c8:	0ff7f793          	zext.b	a5,a5
 4cc:	12fb6763          	bltu	s6,a5,5fa <vprintf+0x192>
 4d0:	f9d9079b          	addiw	a5,s2,-99
 4d4:	0ff7f713          	zext.b	a4,a5
 4d8:	12eb6163          	bltu	s6,a4,5fa <vprintf+0x192>
 4dc:	00271793          	slli	a5,a4,0x2
 4e0:	00000717          	auipc	a4,0x0
 4e4:	34870713          	addi	a4,a4,840 # 828 <malloc+0x10a>
 4e8:	97ba                	add	a5,a5,a4
 4ea:	439c                	lw	a5,0(a5)
 4ec:	97ba                	add	a5,a5,a4
 4ee:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4685                	li	a3,1
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ed0080e7          	jalr	-304(ra) # 3ce <printint>
 506:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 508:	4981                	li	s3,0
 50a:	b745                	j	4aa <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 50c:	008b8913          	addi	s2,s7,8
 510:	4681                	li	a3,0
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	eb4080e7          	jalr	-332(ra) # 3ce <printint>
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	b751                	j	4aa <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 528:	008b8913          	addi	s2,s7,8
 52c:	4681                	li	a3,0
 52e:	4641                	li	a2,16
 530:	000ba583          	lw	a1,0(s7)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	e98080e7          	jalr	-360(ra) # 3ce <printint>
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
 542:	b7a5                	j	4aa <vprintf+0x42>
 544:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 546:	008b8c13          	addi	s8,s7,8
 54a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 54e:	03000593          	li	a1,48
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e58080e7          	jalr	-424(ra) # 3ac <putc>
  putc(fd, 'x');
 55c:	07800593          	li	a1,120
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e4a080e7          	jalr	-438(ra) # 3ac <putc>
 56a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56c:	00000b97          	auipc	s7,0x0
 570:	314b8b93          	addi	s7,s7,788 # 880 <digits>
 574:	03c9d793          	srli	a5,s3,0x3c
 578:	97de                	add	a5,a5,s7
 57a:	0007c583          	lbu	a1,0(a5)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e2c080e7          	jalr	-468(ra) # 3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 588:	0992                	slli	s3,s3,0x4
 58a:	397d                	addiw	s2,s2,-1
 58c:	fe0914e3          	bnez	s2,574 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 590:	8be2                	mv	s7,s8
      state = 0;
 592:	4981                	li	s3,0
 594:	6c02                	ld	s8,0(sp)
 596:	bf11                	j	4aa <vprintf+0x42>
        s = va_arg(ap, char*);
 598:	008b8993          	addi	s3,s7,8
 59c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5a0:	02090163          	beqz	s2,5c2 <vprintf+0x15a>
        while(*s != 0){
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	c9a5                	beqz	a1,618 <vprintf+0x1b0>
          putc(fd, *s);
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e00080e7          	jalr	-512(ra) # 3ac <putc>
          s++;
 5b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5b6:	00094583          	lbu	a1,0(s2)
 5ba:	f9e5                	bnez	a1,5aa <vprintf+0x142>
        s = va_arg(ap, char*);
 5bc:	8bce                	mv	s7,s3
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b5ed                	j	4aa <vprintf+0x42>
          s = "(null)";
 5c2:	00000917          	auipc	s2,0x0
 5c6:	25e90913          	addi	s2,s2,606 # 820 <malloc+0x102>
        while(*s != 0){
 5ca:	02800593          	li	a1,40
 5ce:	bff1                	j	5aa <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	000bc583          	lbu	a1,0(s7)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	dd2080e7          	jalr	-558(ra) # 3ac <putc>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b5d1                	j	4aa <vprintf+0x42>
        putc(fd, c);
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	dbe080e7          	jalr	-578(ra) # 3ac <putc>
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bd4d                	j	4aa <vprintf+0x42>
        putc(fd, '%');
 5fa:	02500593          	li	a1,37
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dac080e7          	jalr	-596(ra) # 3ac <putc>
        putc(fd, c);
 608:	85ca                	mv	a1,s2
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	da0080e7          	jalr	-608(ra) # 3ac <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	bd51                	j	4aa <vprintf+0x42>
        s = va_arg(ap, char*);
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b579                	j	4aa <vprintf+0x42>
 61e:	74e2                	ld	s1,56(sp)
 620:	79a2                	ld	s3,40(sp)
 622:	7a02                	ld	s4,32(sp)
 624:	6ae2                	ld	s5,24(sp)
 626:	6b42                	ld	s6,16(sp)
 628:	6ba2                	ld	s7,8(sp)
    }
  }
}
 62a:	60a6                	ld	ra,72(sp)
 62c:	6406                	ld	s0,64(sp)
 62e:	7942                	ld	s2,48(sp)
 630:	6161                	addi	sp,sp,80
 632:	8082                	ret

0000000000000634 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 634:	715d                	addi	sp,sp,-80
 636:	ec06                	sd	ra,24(sp)
 638:	e822                	sd	s0,16(sp)
 63a:	1000                	addi	s0,sp,32
 63c:	e010                	sd	a2,0(s0)
 63e:	e414                	sd	a3,8(s0)
 640:	e818                	sd	a4,16(s0)
 642:	ec1c                	sd	a5,24(s0)
 644:	03043023          	sd	a6,32(s0)
 648:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 64c:	8622                	mv	a2,s0
 64e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 652:	00000097          	auipc	ra,0x0
 656:	e16080e7          	jalr	-490(ra) # 468 <vprintf>
}
 65a:	60e2                	ld	ra,24(sp)
 65c:	6442                	ld	s0,16(sp)
 65e:	6161                	addi	sp,sp,80
 660:	8082                	ret

0000000000000662 <printf>:

void
printf(const char *fmt, ...)
{
 662:	711d                	addi	sp,sp,-96
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	1000                	addi	s0,sp,32
 66a:	e40c                	sd	a1,8(s0)
 66c:	e810                	sd	a2,16(s0)
 66e:	ec14                	sd	a3,24(s0)
 670:	f018                	sd	a4,32(s0)
 672:	f41c                	sd	a5,40(s0)
 674:	03043823          	sd	a6,48(s0)
 678:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 67c:	00840613          	addi	a2,s0,8
 680:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 684:	85aa                	mv	a1,a0
 686:	4505                	li	a0,1
 688:	00000097          	auipc	ra,0x0
 68c:	de0080e7          	jalr	-544(ra) # 468 <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6125                	addi	sp,sp,96
 696:	8082                	ret

0000000000000698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 698:	1141                	addi	sp,sp,-16
 69a:	e406                	sd	ra,8(sp)
 69c:	e022                	sd	s0,0(sp)
 69e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	00001797          	auipc	a5,0x1
 6a8:	95c7b783          	ld	a5,-1700(a5) # 1000 <freep>
 6ac:	a02d                	j	6d6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ae:	4618                	lw	a4,8(a2)
 6b0:	9f2d                	addw	a4,a4,a1
 6b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b6:	6398                	ld	a4,0(a5)
 6b8:	6310                	ld	a2,0(a4)
 6ba:	a83d                	j	6f8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6bc:	ff852703          	lw	a4,-8(a0)
 6c0:	9f31                	addw	a4,a4,a2
 6c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c4:	ff053683          	ld	a3,-16(a0)
 6c8:	a091                	j	70c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e7e463          	bltu	a5,a4,6d4 <free+0x3c>
 6d0:	00e6ea63          	bltu	a3,a4,6e4 <free+0x4c>
{
 6d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	fed7fae3          	bgeu	a5,a3,6ca <free+0x32>
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e6e463          	bltu	a3,a4,6e4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	fee7eae3          	bltu	a5,a4,6d4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 6e4:	ff852583          	lw	a1,-8(a0)
 6e8:	6390                	ld	a2,0(a5)
 6ea:	02059813          	slli	a6,a1,0x20
 6ee:	01c85713          	srli	a4,a6,0x1c
 6f2:	9736                	add	a4,a4,a3
 6f4:	fae60de3          	beq	a2,a4,6ae <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fc:	4790                	lw	a2,8(a5)
 6fe:	02061593          	slli	a1,a2,0x20
 702:	01c5d713          	srli	a4,a1,0x1c
 706:	973e                	add	a4,a4,a5
 708:	fae68ae3          	beq	a3,a4,6bc <free+0x24>
    p->s.ptr = bp->s.ptr;
 70c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 70e:	00001717          	auipc	a4,0x1
 712:	8ef73923          	sd	a5,-1806(a4) # 1000 <freep>
}
 716:	60a2                	ld	ra,8(sp)
 718:	6402                	ld	s0,0(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret

000000000000071e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71e:	7139                	addi	sp,sp,-64
 720:	fc06                	sd	ra,56(sp)
 722:	f822                	sd	s0,48(sp)
 724:	f04a                	sd	s2,32(sp)
 726:	ec4e                	sd	s3,24(sp)
 728:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72a:	02051993          	slli	s3,a0,0x20
 72e:	0209d993          	srli	s3,s3,0x20
 732:	09bd                	addi	s3,s3,15
 734:	0049d993          	srli	s3,s3,0x4
 738:	2985                	addiw	s3,s3,1
 73a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 73c:	00001517          	auipc	a0,0x1
 740:	8c453503          	ld	a0,-1852(a0) # 1000 <freep>
 744:	c905                	beqz	a0,774 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 748:	4798                	lw	a4,8(a5)
 74a:	09377a63          	bgeu	a4,s3,7de <malloc+0xc0>
 74e:	f426                	sd	s1,40(sp)
 750:	e852                	sd	s4,16(sp)
 752:	e456                	sd	s5,8(sp)
 754:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 756:	8a4e                	mv	s4,s3
 758:	6705                	lui	a4,0x1
 75a:	00e9f363          	bgeu	s3,a4,760 <malloc+0x42>
 75e:	6a05                	lui	s4,0x1
 760:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 764:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 768:	00001497          	auipc	s1,0x1
 76c:	89848493          	addi	s1,s1,-1896 # 1000 <freep>
  if(p == (char*)-1)
 770:	5afd                	li	s5,-1
 772:	a089                	j	7b4 <malloc+0x96>
 774:	f426                	sd	s1,40(sp)
 776:	e852                	sd	s4,16(sp)
 778:	e456                	sd	s5,8(sp)
 77a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 77c:	00001797          	auipc	a5,0x1
 780:	89478793          	addi	a5,a5,-1900 # 1010 <base>
 784:	00001717          	auipc	a4,0x1
 788:	86f73e23          	sd	a5,-1924(a4) # 1000 <freep>
 78c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 792:	b7d1                	j	756 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	e118                	sd	a4,0(a0)
 798:	a8b9                	j	7f6 <malloc+0xd8>
  hp->s.size = nu;
 79a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 79e:	0541                	addi	a0,a0,16
 7a0:	00000097          	auipc	ra,0x0
 7a4:	ef8080e7          	jalr	-264(ra) # 698 <free>
  return freep;
 7a8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7aa:	c135                	beqz	a0,80e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ae:	4798                	lw	a4,8(a5)
 7b0:	03277363          	bgeu	a4,s2,7d6 <malloc+0xb8>
    if(p == freep)
 7b4:	6098                	ld	a4,0(s1)
 7b6:	853e                	mv	a0,a5
 7b8:	fef71ae3          	bne	a4,a5,7ac <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7bc:	8552                	mv	a0,s4
 7be:	00000097          	auipc	ra,0x0
 7c2:	bae080e7          	jalr	-1106(ra) # 36c <sbrk>
  if(p == (char*)-1)
 7c6:	fd551ae3          	bne	a0,s5,79a <malloc+0x7c>
        return 0;
 7ca:	4501                	li	a0,0
 7cc:	74a2                	ld	s1,40(sp)
 7ce:	6a42                	ld	s4,16(sp)
 7d0:	6aa2                	ld	s5,8(sp)
 7d2:	6b02                	ld	s6,0(sp)
 7d4:	a03d                	j	802 <malloc+0xe4>
 7d6:	74a2                	ld	s1,40(sp)
 7d8:	6a42                	ld	s4,16(sp)
 7da:	6aa2                	ld	s5,8(sp)
 7dc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7de:	fae90be3          	beq	s2,a4,794 <malloc+0x76>
        p->s.size -= nunits;
 7e2:	4137073b          	subw	a4,a4,s3
 7e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e8:	02071693          	slli	a3,a4,0x20
 7ec:	01c6d713          	srli	a4,a3,0x1c
 7f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80a73523          	sd	a0,-2038(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fe:	01078513          	addi	a0,a5,16
  }
}
 802:	70e2                	ld	ra,56(sp)
 804:	7442                	ld	s0,48(sp)
 806:	7902                	ld	s2,32(sp)
 808:	69e2                	ld	s3,24(sp)
 80a:	6121                	addi	sp,sp,64
 80c:	8082                	ret
 80e:	74a2                	ld	s1,40(sp)
 810:	6a42                	ld	s4,16(sp)
 812:	6aa2                	ld	s5,8(sp)
 814:	6b02                	ld	s6,0(sp)
 816:	b7f5                	j	802 <malloc+0xe4>
