
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d863          	bge	a5,a0,86 <main+0x86>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	84cb0b13          	addi	s6,s6,-1972 # 880 <malloc+0xfc>
  3c:	a819                	j	52 <main+0x52>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	00000097          	auipc	ra,0x0
  48:	326080e7          	jalr	806(ra) # 36a <write>
  for(i = 1; i < argc; i++){
  4c:	04a1                	addi	s1,s1,8
  4e:	03448c63          	beq	s1,s4,86 <main+0x86>
    write(1, argv[i], strlen(argv[i]));
  52:	0004b903          	ld	s2,0(s1)
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	0a2080e7          	jalr	162(ra) # fa <strlen>
  60:	862a                	mv	a2,a0
  62:	85ca                	mv	a1,s2
  64:	854e                	mv	a0,s3
  66:	00000097          	auipc	ra,0x0
  6a:	304080e7          	jalr	772(ra) # 36a <write>
    if(i + 1 < argc){
  6e:	fd5498e3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  72:	4605                	li	a2,1
  74:	00001597          	auipc	a1,0x1
  78:	81458593          	addi	a1,a1,-2028 # 888 <malloc+0x104>
  7c:	8532                	mv	a0,a2
  7e:	00000097          	auipc	ra,0x0
  82:	2ec080e7          	jalr	748(ra) # 36a <write>
    }
  }
  exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2c2080e7          	jalr	706(ra) # 34a <exit>

0000000000000090 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  90:	1141                	addi	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	addi	s0,sp,16
  extern int main();
  main();
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <main>
  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	2a8080e7          	jalr	680(ra) # 34a <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf99                	beqz	a5,124 <strlen+0x2a>
 108:	0505                	addi	a0,a0,1
 10a:	87aa                	mv	a5,a0
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
 11a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strlen+0x22>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	ca19                	beqz	a2,146 <memset+0x1e>
 132:	87aa                	mv	a5,a0
 134:	1602                	slli	a2,a2,0x20
 136:	9201                	srli	a2,a2,0x20
 138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 140:	0785                	addi	a5,a5,1
 142:	fee79de3          	bne	a5,a4,13c <memset+0x14>
  }
  return dst;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf81                	beqz	a5,172 <strchr+0x24>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1c>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xe>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strchr+0x1c>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	7159                	addi	sp,sp,-112
 178:	f486                	sd	ra,104(sp)
 17a:	f0a2                	sd	s0,96(sp)
 17c:	eca6                	sd	s1,88(sp)
 17e:	e8ca                	sd	s2,80(sp)
 180:	e4ce                	sd	s3,72(sp)
 182:	e0d2                	sd	s4,64(sp)
 184:	fc56                	sd	s5,56(sp)
 186:	f85a                	sd	s6,48(sp)
 188:	f45e                	sd	s7,40(sp)
 18a:	f062                	sd	s8,32(sp)
 18c:	ec66                	sd	s9,24(sp)
 18e:	e86a                	sd	s10,16(sp)
 190:	1880                	addi	s0,sp,112
 192:	8caa                	mv	s9,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	f9f40b13          	addi	s6,s0,-97
 19e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4ba9                	li	s7,10
 1a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a4:	8d26                	mv	s10,s1
 1a6:	0014899b          	addiw	s3,s1,1
 1aa:	84ce                	mv	s1,s3
 1ac:	0349d763          	bge	s3,s4,1da <gets+0x64>
    cc = read(0, &c, 1);
 1b0:	8656                	mv	a2,s5
 1b2:	85da                	mv	a1,s6
 1b4:	4501                	li	a0,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	1ac080e7          	jalr	428(ra) # 362 <read>
    if(cc < 1)
 1be:	00a05e63          	blez	a0,1da <gets+0x64>
    buf[i++] = c;
 1c2:	f9f44783          	lbu	a5,-97(s0)
 1c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ca:	01778763          	beq	a5,s7,1d8 <gets+0x62>
 1ce:	0905                	addi	s2,s2,1
 1d0:	fd879ae3          	bne	a5,s8,1a4 <gets+0x2e>
    buf[i++] = c;
 1d4:	8d4e                	mv	s10,s3
 1d6:	a011                	j	1da <gets+0x64>
 1d8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1da:	9d66                	add	s10,s10,s9
 1dc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1e0:	8566                	mv	a0,s9
 1e2:	70a6                	ld	ra,104(sp)
 1e4:	7406                	ld	s0,96(sp)
 1e6:	64e6                	ld	s1,88(sp)
 1e8:	6946                	ld	s2,80(sp)
 1ea:	69a6                	ld	s3,72(sp)
 1ec:	6a06                	ld	s4,64(sp)
 1ee:	7ae2                	ld	s5,56(sp)
 1f0:	7b42                	ld	s6,48(sp)
 1f2:	7ba2                	ld	s7,40(sp)
 1f4:	7c02                	ld	s8,32(sp)
 1f6:	6ce2                	ld	s9,24(sp)
 1f8:	6d42                	ld	s10,16(sp)
 1fa:	6165                	addi	sp,sp,112
 1fc:	8082                	ret

00000000000001fe <stat>:

int
stat(const char *n, struct stat *st)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	00000097          	auipc	ra,0x0
 210:	17e080e7          	jalr	382(ra) # 38a <open>
  if(fd < 0)
 214:	02054663          	bltz	a0,240 <stat+0x42>
 218:	e426                	sd	s1,8(sp)
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	00000097          	auipc	ra,0x0
 222:	184080e7          	jalr	388(ra) # 3a2 <fstat>
 226:	892a                	mv	s2,a0
  close(fd);
 228:	8526                	mv	a0,s1
 22a:	00000097          	auipc	ra,0x0
 22e:	148080e7          	jalr	328(ra) # 372 <close>
  return r;
 232:	64a2                	ld	s1,8(sp)
}
 234:	854a                	mv	a0,s2
 236:	60e2                	ld	ra,24(sp)
 238:	6442                	ld	s0,16(sp)
 23a:	6902                	ld	s2,0(sp)
 23c:	6105                	addi	sp,sp,32
 23e:	8082                	ret
    return -1;
 240:	597d                	li	s2,-1
 242:	bfcd                	j	234 <stat+0x36>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	00054683          	lbu	a3,0(a0)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	4625                	li	a2,9
 25a:	02f66963          	bltu	a2,a5,28c <atoi+0x48>
 25e:	872a                	mv	a4,a0
  n = 0;
 260:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 262:	0705                	addi	a4,a4,1
 264:	0025179b          	slliw	a5,a0,0x2
 268:	9fa9                	addw	a5,a5,a0
 26a:	0017979b          	slliw	a5,a5,0x1
 26e:	9fb5                	addw	a5,a5,a3
 270:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 274:	00074683          	lbu	a3,0(a4)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	fef671e3          	bgeu	a2,a5,262 <atoi+0x1e>
  return n;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  n = 0;
 28c:	4501                	li	a0,0
 28e:	bfdd                	j	284 <atoi+0x40>

0000000000000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57563          	bgeu	a0,a1,2c2 <memmove+0x32>
    while(n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x2a>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b6:	fee79ae3          	bne	a5,a4,2aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec059e3          	blez	a2,2ba <memmove+0x2a>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x4a>
 2ea:	bfc1                	j	2ba <memmove+0x2a>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	ca0d                	beqz	a2,326 <memcmp+0x3a>
 2f6:	fff6069b          	addiw	a3,a2,-1
 2fa:	1682                	slli	a3,a3,0x20
 2fc:	9281                	srli	a3,a3,0x20
 2fe:	0685                	addi	a3,a3,1
 300:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x16>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x32>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <memcmp+0x32>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	00000097          	auipc	ra,0x0
 336:	f5e080e7          	jalr	-162(ra) # 290 <memmove>
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 342:	4885                	li	a7,1
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <exit>:
.global exit
exit:
 li a7, SYS_exit
 34a:	4889                	li	a7,2
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <wait>:
.global wait
wait:
 li a7, SYS_wait
 352:	488d                	li	a7,3
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35a:	4891                	li	a7,4
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <read>:
.global read
read:
 li a7, SYS_read
 362:	4895                	li	a7,5
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <write>:
.global write
write:
 li a7, SYS_write
 36a:	48c1                	li	a7,16
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <close>:
.global close
close:
 li a7, SYS_close
 372:	48d5                	li	a7,21
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <kill>:
.global kill
kill:
 li a7, SYS_kill
 37a:	4899                	li	a7,6
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exec>:
.global exec
exec:
 li a7, SYS_exec
 382:	489d                	li	a7,7
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <open>:
.global open
open:
 li a7, SYS_open
 38a:	48bd                	li	a7,15
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 392:	48c5                	li	a7,17
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39a:	48c9                	li	a7,18
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a2:	48a1                	li	a7,8
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <link>:
.global link
link:
 li a7, SYS_link
 3aa:	48cd                	li	a7,19
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b2:	48d1                	li	a7,20
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ba:	48a5                	li	a7,9
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c2:	48a9                	li	a7,10
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ca:	48ad                	li	a7,11
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d2:	48b1                	li	a7,12
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3da:	48b5                	li	a7,13
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e2:	48b9                	li	a7,14
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3ea:	48d9                	li	a7,22
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3f2:	48dd                	li	a7,23
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 3fa:	48e1                	li	a7,24
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 402:	48e5                	li	a7,25
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 40a:	48e9                	li	a7,26
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41e:	4605                	li	a2,1
 420:	fef40593          	addi	a1,s0,-17
 424:	00000097          	auipc	ra,0x0
 428:	f46080e7          	jalr	-186(ra) # 36a <write>
}
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6105                	addi	sp,sp,32
 432:	8082                	ret

0000000000000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	7139                	addi	sp,sp,-64
 436:	fc06                	sd	ra,56(sp)
 438:	f822                	sd	s0,48(sp)
 43a:	f426                	sd	s1,40(sp)
 43c:	f04a                	sd	s2,32(sp)
 43e:	ec4e                	sd	s3,24(sp)
 440:	0080                	addi	s0,sp,64
 442:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 444:	c299                	beqz	a3,44a <printint+0x16>
 446:	0805c063          	bltz	a1,4c6 <printint+0x92>
  neg = 0;
 44a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 44c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 450:	869a                	mv	a3,t1
  i = 0;
 452:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 454:	00000817          	auipc	a6,0x0
 458:	49c80813          	addi	a6,a6,1180 # 8f0 <digits>
 45c:	88be                	mv	a7,a5
 45e:	0017851b          	addiw	a0,a5,1
 462:	87aa                	mv	a5,a0
 464:	02c5f73b          	remuw	a4,a1,a2
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	9742                	add	a4,a4,a6
 46e:	00074703          	lbu	a4,0(a4)
 472:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 476:	872e                	mv	a4,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fcc77fe3          	bgeu	a4,a2,45c <printint+0x28>
  if(neg)
 482:	000e0c63          	beqz	t3,49a <printint+0x66>
    buf[i++] = '-';
 486:	fd050793          	addi	a5,a0,-48
 48a:	00878533          	add	a0,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef50823          	sb	a5,-16(a0)
 496:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 49a:	fff7899b          	addiw	s3,a5,-1
 49e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4a2:	fff4c583          	lbu	a1,-1(s1)
 4a6:	854a                	mv	a0,s2
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f6a080e7          	jalr	-150(ra) # 412 <putc>
  while(--i >= 0)
 4b0:	39fd                	addiw	s3,s3,-1
 4b2:	14fd                	addi	s1,s1,-1
 4b4:	fe09d7e3          	bgez	s3,4a2 <printint+0x6e>
}
 4b8:	70e2                	ld	ra,56(sp)
 4ba:	7442                	ld	s0,48(sp)
 4bc:	74a2                	ld	s1,40(sp)
 4be:	7902                	ld	s2,32(sp)
 4c0:	69e2                	ld	s3,24(sp)
 4c2:	6121                	addi	sp,sp,64
 4c4:	8082                	ret
    x = -xx;
 4c6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ca:	4e05                	li	t3,1
    x = -xx;
 4cc:	b741                	j	44c <printint+0x18>

00000000000004ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ce:	715d                	addi	sp,sp,-80
 4d0:	e486                	sd	ra,72(sp)
 4d2:	e0a2                	sd	s0,64(sp)
 4d4:	f84a                	sd	s2,48(sp)
 4d6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d8:	0005c903          	lbu	s2,0(a1)
 4dc:	1a090a63          	beqz	s2,690 <vprintf+0x1c2>
 4e0:	fc26                	sd	s1,56(sp)
 4e2:	f44e                	sd	s3,40(sp)
 4e4:	f052                	sd	s4,32(sp)
 4e6:	ec56                	sd	s5,24(sp)
 4e8:	e85a                	sd	s6,16(sp)
 4ea:	e45e                	sd	s7,8(sp)
 4ec:	8aaa                	mv	s5,a0
 4ee:	8bb2                	mv	s7,a2
 4f0:	00158493          	addi	s1,a1,1
  state = 0;
 4f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f6:	02500a13          	li	s4,37
 4fa:	4b55                	li	s6,21
 4fc:	a839                	j	51a <vprintf+0x4c>
        putc(fd, c);
 4fe:	85ca                	mv	a1,s2
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	f10080e7          	jalr	-240(ra) # 412 <putc>
 50a:	a019                	j	510 <vprintf+0x42>
    } else if(state == '%'){
 50c:	01498d63          	beq	s3,s4,526 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 510:	0485                	addi	s1,s1,1
 512:	fff4c903          	lbu	s2,-1(s1)
 516:	16090763          	beqz	s2,684 <vprintf+0x1b6>
    if(state == 0){
 51a:	fe0999e3          	bnez	s3,50c <vprintf+0x3e>
      if(c == '%'){
 51e:	ff4910e3          	bne	s2,s4,4fe <vprintf+0x30>
        state = '%';
 522:	89d2                	mv	s3,s4
 524:	b7f5                	j	510 <vprintf+0x42>
      if(c == 'd'){
 526:	13490463          	beq	s2,s4,64e <vprintf+0x180>
 52a:	f9d9079b          	addiw	a5,s2,-99
 52e:	0ff7f793          	zext.b	a5,a5
 532:	12fb6763          	bltu	s6,a5,660 <vprintf+0x192>
 536:	f9d9079b          	addiw	a5,s2,-99
 53a:	0ff7f713          	zext.b	a4,a5
 53e:	12eb6163          	bltu	s6,a4,660 <vprintf+0x192>
 542:	00271793          	slli	a5,a4,0x2
 546:	00000717          	auipc	a4,0x0
 54a:	35270713          	addi	a4,a4,850 # 898 <malloc+0x114>
 54e:	97ba                	add	a5,a5,a4
 550:	439c                	lw	a5,0(a5)
 552:	97ba                	add	a5,a5,a4
 554:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8913          	addi	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	ed0080e7          	jalr	-304(ra) # 434 <printint>
 56c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56e:	4981                	li	s3,0
 570:	b745                	j	510 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b8913          	addi	s2,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	eb4080e7          	jalr	-332(ra) # 434 <printint>
 588:	8bca                	mv	s7,s2
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b751                	j	510 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 58e:	008b8913          	addi	s2,s7,8
 592:	4681                	li	a3,0
 594:	4641                	li	a2,16
 596:	000ba583          	lw	a1,0(s7)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e98080e7          	jalr	-360(ra) # 434 <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b7a5                	j	510 <vprintf+0x42>
 5aa:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ac:	008b8c13          	addi	s8,s7,8
 5b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b4:	03000593          	li	a1,48
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e58080e7          	jalr	-424(ra) # 412 <putc>
  putc(fd, 'x');
 5c2:	07800593          	li	a1,120
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e4a080e7          	jalr	-438(ra) # 412 <putc>
 5d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d2:	00000b97          	auipc	s7,0x0
 5d6:	31eb8b93          	addi	s7,s7,798 # 8f0 <digits>
 5da:	03c9d793          	srli	a5,s3,0x3c
 5de:	97de                	add	a5,a5,s7
 5e0:	0007c583          	lbu	a1,0(a5)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e2c080e7          	jalr	-468(ra) # 412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ee:	0992                	slli	s3,s3,0x4
 5f0:	397d                	addiw	s2,s2,-1
 5f2:	fe0914e3          	bnez	s2,5da <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5f6:	8be2                	mv	s7,s8
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	6c02                	ld	s8,0(sp)
 5fc:	bf11                	j	510 <vprintf+0x42>
        s = va_arg(ap, char*);
 5fe:	008b8993          	addi	s3,s7,8
 602:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 606:	02090163          	beqz	s2,628 <vprintf+0x15a>
        while(*s != 0){
 60a:	00094583          	lbu	a1,0(s2)
 60e:	c9a5                	beqz	a1,67e <vprintf+0x1b0>
          putc(fd, *s);
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e00080e7          	jalr	-512(ra) # 412 <putc>
          s++;
 61a:	0905                	addi	s2,s2,1
        while(*s != 0){
 61c:	00094583          	lbu	a1,0(s2)
 620:	f9e5                	bnez	a1,610 <vprintf+0x142>
        s = va_arg(ap, char*);
 622:	8bce                	mv	s7,s3
      state = 0;
 624:	4981                	li	s3,0
 626:	b5ed                	j	510 <vprintf+0x42>
          s = "(null)";
 628:	00000917          	auipc	s2,0x0
 62c:	26890913          	addi	s2,s2,616 # 890 <malloc+0x10c>
        while(*s != 0){
 630:	02800593          	li	a1,40
 634:	bff1                	j	610 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 636:	008b8913          	addi	s2,s7,8
 63a:	000bc583          	lbu	a1,0(s7)
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	dd2080e7          	jalr	-558(ra) # 412 <putc>
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b5d1                	j	510 <vprintf+0x42>
        putc(fd, c);
 64e:	02500593          	li	a1,37
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	dbe080e7          	jalr	-578(ra) # 412 <putc>
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd4d                	j	510 <vprintf+0x42>
        putc(fd, '%');
 660:	02500593          	li	a1,37
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	dac080e7          	jalr	-596(ra) # 412 <putc>
        putc(fd, c);
 66e:	85ca                	mv	a1,s2
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	da0080e7          	jalr	-608(ra) # 412 <putc>
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd51                	j	510 <vprintf+0x42>
        s = va_arg(ap, char*);
 67e:	8bce                	mv	s7,s3
      state = 0;
 680:	4981                	li	s3,0
 682:	b579                	j	510 <vprintf+0x42>
 684:	74e2                	ld	s1,56(sp)
 686:	79a2                	ld	s3,40(sp)
 688:	7a02                	ld	s4,32(sp)
 68a:	6ae2                	ld	s5,24(sp)
 68c:	6b42                	ld	s6,16(sp)
 68e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 690:	60a6                	ld	ra,72(sp)
 692:	6406                	ld	s0,64(sp)
 694:	7942                	ld	s2,48(sp)
 696:	6161                	addi	sp,sp,80
 698:	8082                	ret

000000000000069a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 69a:	715d                	addi	sp,sp,-80
 69c:	ec06                	sd	ra,24(sp)
 69e:	e822                	sd	s0,16(sp)
 6a0:	1000                	addi	s0,sp,32
 6a2:	e010                	sd	a2,0(s0)
 6a4:	e414                	sd	a3,8(s0)
 6a6:	e818                	sd	a4,16(s0)
 6a8:	ec1c                	sd	a5,24(s0)
 6aa:	03043023          	sd	a6,32(s0)
 6ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b2:	8622                	mv	a2,s0
 6b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e16080e7          	jalr	-490(ra) # 4ce <vprintf>
}
 6c0:	60e2                	ld	ra,24(sp)
 6c2:	6442                	ld	s0,16(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret

00000000000006c8 <printf>:

void
printf(const char *fmt, ...)
{
 6c8:	711d                	addi	sp,sp,-96
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e40c                	sd	a1,8(s0)
 6d2:	e810                	sd	a2,16(s0)
 6d4:	ec14                	sd	a3,24(s0)
 6d6:	f018                	sd	a4,32(s0)
 6d8:	f41c                	sd	a5,40(s0)
 6da:	03043823          	sd	a6,48(s0)
 6de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	00840613          	addi	a2,s0,8
 6e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ea:	85aa                	mv	a1,a0
 6ec:	4505                	li	a0,1
 6ee:	00000097          	auipc	ra,0x0
 6f2:	de0080e7          	jalr	-544(ra) # 4ce <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6125                	addi	sp,sp,96
 6fc:	8082                	ret

00000000000006fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fe:	1141                	addi	sp,sp,-16
 700:	e406                	sd	ra,8(sp)
 702:	e022                	sd	s0,0(sp)
 704:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 706:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	00001797          	auipc	a5,0x1
 70e:	8f67b783          	ld	a5,-1802(a5) # 1000 <freep>
 712:	a02d                	j	73c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 714:	4618                	lw	a4,8(a2)
 716:	9f2d                	addw	a4,a4,a1
 718:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	6398                	ld	a4,0(a5)
 71e:	6310                	ld	a2,0(a4)
 720:	a83d                	j	75e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 722:	ff852703          	lw	a4,-8(a0)
 726:	9f31                	addw	a4,a4,a2
 728:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 72a:	ff053683          	ld	a3,-16(a0)
 72e:	a091                	j	772 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	6398                	ld	a4,0(a5)
 732:	00e7e463          	bltu	a5,a4,73a <free+0x3c>
 736:	00e6ea63          	bltu	a3,a4,74a <free+0x4c>
{
 73a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	fed7fae3          	bgeu	a5,a3,730 <free+0x32>
 740:	6398                	ld	a4,0(a5)
 742:	00e6e463          	bltu	a3,a4,74a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	fee7eae3          	bltu	a5,a4,73a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 74a:	ff852583          	lw	a1,-8(a0)
 74e:	6390                	ld	a2,0(a5)
 750:	02059813          	slli	a6,a1,0x20
 754:	01c85713          	srli	a4,a6,0x1c
 758:	9736                	add	a4,a4,a3
 75a:	fae60de3          	beq	a2,a4,714 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 762:	4790                	lw	a2,8(a5)
 764:	02061593          	slli	a1,a2,0x20
 768:	01c5d713          	srli	a4,a1,0x1c
 76c:	973e                	add	a4,a4,a5
 76e:	fae68ae3          	beq	a3,a4,722 <free+0x24>
    p->s.ptr = bp->s.ptr;
 772:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 774:	00001717          	auipc	a4,0x1
 778:	88f73623          	sd	a5,-1908(a4) # 1000 <freep>
}
 77c:	60a2                	ld	ra,8(sp)
 77e:	6402                	ld	s0,0(sp)
 780:	0141                	addi	sp,sp,16
 782:	8082                	ret

0000000000000784 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 784:	7139                	addi	sp,sp,-64
 786:	fc06                	sd	ra,56(sp)
 788:	f822                	sd	s0,48(sp)
 78a:	f04a                	sd	s2,32(sp)
 78c:	ec4e                	sd	s3,24(sp)
 78e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 790:	02051993          	slli	s3,a0,0x20
 794:	0209d993          	srli	s3,s3,0x20
 798:	09bd                	addi	s3,s3,15
 79a:	0049d993          	srli	s3,s3,0x4
 79e:	2985                	addiw	s3,s3,1
 7a0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a2:	00001517          	auipc	a0,0x1
 7a6:	85e53503          	ld	a0,-1954(a0) # 1000 <freep>
 7aa:	c905                	beqz	a0,7da <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ae:	4798                	lw	a4,8(a5)
 7b0:	09377a63          	bgeu	a4,s3,844 <malloc+0xc0>
 7b4:	f426                	sd	s1,40(sp)
 7b6:	e852                	sd	s4,16(sp)
 7b8:	e456                	sd	s5,8(sp)
 7ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7bc:	8a4e                	mv	s4,s3
 7be:	6705                	lui	a4,0x1
 7c0:	00e9f363          	bgeu	s3,a4,7c6 <malloc+0x42>
 7c4:	6a05                	lui	s4,0x1
 7c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ce:	00001497          	auipc	s1,0x1
 7d2:	83248493          	addi	s1,s1,-1998 # 1000 <freep>
  if(p == (char*)-1)
 7d6:	5afd                	li	s5,-1
 7d8:	a089                	j	81a <malloc+0x96>
 7da:	f426                	sd	s1,40(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e2:	00001797          	auipc	a5,0x1
 7e6:	82e78793          	addi	a5,a5,-2002 # 1010 <base>
 7ea:	00001717          	auipc	a4,0x1
 7ee:	80f73b23          	sd	a5,-2026(a4) # 1000 <freep>
 7f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f8:	b7d1                	j	7bc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7fa:	6398                	ld	a4,0(a5)
 7fc:	e118                	sd	a4,0(a0)
 7fe:	a8b9                	j	85c <malloc+0xd8>
  hp->s.size = nu;
 800:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 804:	0541                	addi	a0,a0,16
 806:	00000097          	auipc	ra,0x0
 80a:	ef8080e7          	jalr	-264(ra) # 6fe <free>
  return freep;
 80e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 810:	c135                	beqz	a0,874 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 814:	4798                	lw	a4,8(a5)
 816:	03277363          	bgeu	a4,s2,83c <malloc+0xb8>
    if(p == freep)
 81a:	6098                	ld	a4,0(s1)
 81c:	853e                	mv	a0,a5
 81e:	fef71ae3          	bne	a4,a5,812 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 822:	8552                	mv	a0,s4
 824:	00000097          	auipc	ra,0x0
 828:	bae080e7          	jalr	-1106(ra) # 3d2 <sbrk>
  if(p == (char*)-1)
 82c:	fd551ae3          	bne	a0,s5,800 <malloc+0x7c>
        return 0;
 830:	4501                	li	a0,0
 832:	74a2                	ld	s1,40(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
 83a:	a03d                	j	868 <malloc+0xe4>
 83c:	74a2                	ld	s1,40(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 844:	fae90be3          	beq	s2,a4,7fa <malloc+0x76>
        p->s.size -= nunits;
 848:	4137073b          	subw	a4,a4,s3
 84c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84e:	02071693          	slli	a3,a4,0x20
 852:	01c6d713          	srli	a4,a3,0x1c
 856:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 858:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85c:	00000717          	auipc	a4,0x0
 860:	7aa73223          	sd	a0,1956(a4) # 1000 <freep>
      return (void*)(p + 1);
 864:	01078513          	addi	a0,a5,16
  }
}
 868:	70e2                	ld	ra,56(sp)
 86a:	7442                	ld	s0,48(sp)
 86c:	7902                	ld	s2,32(sp)
 86e:	69e2                	ld	s3,24(sp)
 870:	6121                	addi	sp,sp,64
 872:	8082                	ret
 874:	74a2                	ld	s1,40(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	b7f5                	j	868 <malloc+0xe4>
