
user/_schedulertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define NFORK 10
#define IO 5

int main()
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  int n, pid;
  int wtime, rtime;
  int twtime = 0, trtime = 0;
  for (n = 0; n < NFORK; n++)
  12:	4481                	li	s1,0
  14:	4929                	li	s2,10
  {
    pid = fork();
  16:	00000097          	auipc	ra,0x0
  1a:	38c080e7          	jalr	908(ra) # 3a2 <fork>
    if (pid < 0)
  1e:	00054d63          	bltz	a0,38 <main+0x38>
      break;
    if (pid == 0)
  22:	cd31                	beqz	a0,7e <main+0x7e>
  for (n = 0; n < NFORK; n++)
  24:	2485                	addiw	s1,s1,1
  26:	ff2498e3          	bne	s1,s2,16 <main+0x16>
  2a:	4901                	li	s2,0
  2c:	4981                	li	s3,0
      exit(0);
    }
  }
  for (; n > 0; n--)
  {
    if (waitx(0, &wtime, &rtime) >= 0)
  2e:	fb840a93          	addi	s5,s0,-72
  32:	fbc40a13          	addi	s4,s0,-68
  36:	a859                	j	cc <main+0xcc>
  for (; n > 0; n--)
  38:	fe9049e3          	bgtz	s1,2a <main+0x2a>
  3c:	4901                	li	s2,0
  3e:	4981                	li	s3,0
    {
      trtime += rtime;
      twtime += wtime;
    }
  }
  printf("Average rtime %d,  wtime %d\n", trtime / NFORK, twtime / NFORK);
  40:	666665b7          	lui	a1,0x66666
  44:	66758593          	addi	a1,a1,1639 # 66666667 <base+0x66665657>
  48:	02b98633          	mul	a2,s3,a1
  4c:	9609                	srai	a2,a2,0x22
  4e:	41f9d99b          	sraiw	s3,s3,0x1f
  52:	02b905b3          	mul	a1,s2,a1
  56:	9589                	srai	a1,a1,0x22
  58:	41f9591b          	sraiw	s2,s2,0x1f
  5c:	4136063b          	subw	a2,a2,s3
  60:	412585bb          	subw	a1,a1,s2
  64:	00001517          	auipc	a0,0x1
  68:	87c50513          	addi	a0,a0,-1924 # 8e0 <malloc+0xfc>
  6c:	00000097          	auipc	ra,0x0
  70:	6bc080e7          	jalr	1724(ra) # 728 <printf>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	334080e7          	jalr	820(ra) # 3aa <exit>
      if (n < IO)
  7e:	4791                	li	a5,4
  80:	0297dd63          	bge	a5,s1,ba <main+0xba>
        for (volatile int i = 0; i < 1000000000; i++)
  84:	fa042a23          	sw	zero,-76(s0)
  88:	fb442703          	lw	a4,-76(s0)
  8c:	2701                	sext.w	a4,a4
  8e:	3b9ad7b7          	lui	a5,0x3b9ad
  92:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <base+0x3b9ab9ef>
  96:	00e7cd63          	blt	a5,a4,b0 <main+0xb0>
  9a:	873e                	mv	a4,a5
  9c:	fb442783          	lw	a5,-76(s0)
  a0:	2785                	addiw	a5,a5,1
  a2:	faf42a23          	sw	a5,-76(s0)
  a6:	fb442783          	lw	a5,-76(s0)
  aa:	2781                	sext.w	a5,a5
  ac:	fef758e3          	bge	a4,a5,9c <main+0x9c>
      exit(0);
  b0:	4501                	li	a0,0
  b2:	00000097          	auipc	ra,0x0
  b6:	2f8080e7          	jalr	760(ra) # 3aa <exit>
        sleep(200); // IO bound processes
  ba:	0c800513          	li	a0,200
  be:	00000097          	auipc	ra,0x0
  c2:	37c080e7          	jalr	892(ra) # 43a <sleep>
  c6:	b7ed                	j	b0 <main+0xb0>
  for (; n > 0; n--)
  c8:	34fd                	addiw	s1,s1,-1
  ca:	d8bd                	beqz	s1,40 <main+0x40>
    if (waitx(0, &wtime, &rtime) >= 0)
  cc:	8656                	mv	a2,s5
  ce:	85d2                	mv	a1,s4
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	378080e7          	jalr	888(ra) # 44a <waitx>
  da:	fe0547e3          	bltz	a0,c8 <main+0xc8>
      trtime += rtime;
  de:	fb842783          	lw	a5,-72(s0)
  e2:	0127893b          	addw	s2,a5,s2
      twtime += wtime;
  e6:	fbc42783          	lw	a5,-68(s0)
  ea:	013789bb          	addw	s3,a5,s3
  ee:	bfe9                	j	c8 <main+0xc8>

00000000000000f0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e406                	sd	ra,8(sp)
  f4:	e022                	sd	s0,0(sp)
  f6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f8:	00000097          	auipc	ra,0x0
  fc:	f08080e7          	jalr	-248(ra) # 0 <main>
  exit(0);
 100:	4501                	li	a0,0
 102:	00000097          	auipc	ra,0x0
 106:	2a8080e7          	jalr	680(ra) # 3aa <exit>

000000000000010a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0xa>
    ;
  return os;
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x20>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x20>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf99                	beqz	a5,184 <strlen+0x2a>
 168:	0505                	addi	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	86be                	mv	a3,a5
 16e:	0785                	addi	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	ff65                	bnez	a4,16c <strlen+0x12>
 176:	40a6853b          	subw	a0,a3,a0
 17a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17c:	60a2                	ld	ra,8(sp)
 17e:	6402                	ld	s0,0(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  for(n = 0; s[n]; n++)
 184:	4501                	li	a0,0
 186:	bfdd                	j	17c <strlen+0x22>

0000000000000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 190:	ca19                	beqz	a2,1a6 <memset+0x1e>
 192:	87aa                	mv	a5,a0
 194:	1602                	slli	a2,a2,0x20
 196:	9201                	srli	a2,a2,0x20
 198:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x14>
  }
  return dst;
}
 1a6:	60a2                	ld	ra,8(sp)
 1a8:	6402                	ld	s0,0(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cf81                	beqz	a5,1d2 <strchr+0x24>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1c>
  for(; *s; s++)
 1c0:	0505                	addi	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xe>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfdd                	j	1ca <strchr+0x1c>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	7159                	addi	sp,sp,-112
 1d8:	f486                	sd	ra,104(sp)
 1da:	f0a2                	sd	s0,96(sp)
 1dc:	eca6                	sd	s1,88(sp)
 1de:	e8ca                	sd	s2,80(sp)
 1e0:	e4ce                	sd	s3,72(sp)
 1e2:	e0d2                	sd	s4,64(sp)
 1e4:	fc56                	sd	s5,56(sp)
 1e6:	f85a                	sd	s6,48(sp)
 1e8:	f45e                	sd	s7,40(sp)
 1ea:	f062                	sd	s8,32(sp)
 1ec:	ec66                	sd	s9,24(sp)
 1ee:	e86a                	sd	s10,16(sp)
 1f0:	1880                	addi	s0,sp,112
 1f2:	8caa                	mv	s9,a0
 1f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	892a                	mv	s2,a0
 1f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1fa:	f9f40b13          	addi	s6,s0,-97
 1fe:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 200:	4ba9                	li	s7,10
 202:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 204:	8d26                	mv	s10,s1
 206:	0014899b          	addiw	s3,s1,1
 20a:	84ce                	mv	s1,s3
 20c:	0349d763          	bge	s3,s4,23a <gets+0x64>
    cc = read(0, &c, 1);
 210:	8656                	mv	a2,s5
 212:	85da                	mv	a1,s6
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	1ac080e7          	jalr	428(ra) # 3c2 <read>
    if(cc < 1)
 21e:	00a05e63          	blez	a0,23a <gets+0x64>
    buf[i++] = c;
 222:	f9f44783          	lbu	a5,-97(s0)
 226:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22a:	01778763          	beq	a5,s7,238 <gets+0x62>
 22e:	0905                	addi	s2,s2,1
 230:	fd879ae3          	bne	a5,s8,204 <gets+0x2e>
    buf[i++] = c;
 234:	8d4e                	mv	s10,s3
 236:	a011                	j	23a <gets+0x64>
 238:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 23a:	9d66                	add	s10,s10,s9
 23c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 240:	8566                	mv	a0,s9
 242:	70a6                	ld	ra,104(sp)
 244:	7406                	ld	s0,96(sp)
 246:	64e6                	ld	s1,88(sp)
 248:	6946                	ld	s2,80(sp)
 24a:	69a6                	ld	s3,72(sp)
 24c:	6a06                	ld	s4,64(sp)
 24e:	7ae2                	ld	s5,56(sp)
 250:	7b42                	ld	s6,48(sp)
 252:	7ba2                	ld	s7,40(sp)
 254:	7c02                	ld	s8,32(sp)
 256:	6ce2                	ld	s9,24(sp)
 258:	6d42                	ld	s10,16(sp)
 25a:	6165                	addi	sp,sp,112
 25c:	8082                	ret

000000000000025e <stat>:

int
stat(const char *n, struct stat *st)
{
 25e:	1101                	addi	sp,sp,-32
 260:	ec06                	sd	ra,24(sp)
 262:	e822                	sd	s0,16(sp)
 264:	e04a                	sd	s2,0(sp)
 266:	1000                	addi	s0,sp,32
 268:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	4581                	li	a1,0
 26c:	00000097          	auipc	ra,0x0
 270:	17e080e7          	jalr	382(ra) # 3ea <open>
  if(fd < 0)
 274:	02054663          	bltz	a0,2a0 <stat+0x42>
 278:	e426                	sd	s1,8(sp)
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	00000097          	auipc	ra,0x0
 282:	184080e7          	jalr	388(ra) # 402 <fstat>
 286:	892a                	mv	s2,a0
  close(fd);
 288:	8526                	mv	a0,s1
 28a:	00000097          	auipc	ra,0x0
 28e:	148080e7          	jalr	328(ra) # 3d2 <close>
  return r;
 292:	64a2                	ld	s1,8(sp)
}
 294:	854a                	mv	a0,s2
 296:	60e2                	ld	ra,24(sp)
 298:	6442                	ld	s0,16(sp)
 29a:	6902                	ld	s2,0(sp)
 29c:	6105                	addi	sp,sp,32
 29e:	8082                	ret
    return -1;
 2a0:	597d                	li	s2,-1
 2a2:	bfcd                	j	294 <stat+0x36>

00000000000002a4 <atoi>:

int
atoi(const char *s)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ac:	00054683          	lbu	a3,0(a0)
 2b0:	fd06879b          	addiw	a5,a3,-48
 2b4:	0ff7f793          	zext.b	a5,a5
 2b8:	4625                	li	a2,9
 2ba:	02f66963          	bltu	a2,a5,2ec <atoi+0x48>
 2be:	872a                	mv	a4,a0
  n = 0;
 2c0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c2:	0705                	addi	a4,a4,1
 2c4:	0025179b          	slliw	a5,a0,0x2
 2c8:	9fa9                	addw	a5,a5,a0
 2ca:	0017979b          	slliw	a5,a5,0x1
 2ce:	9fb5                	addw	a5,a5,a3
 2d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d4:	00074683          	lbu	a3,0(a4)
 2d8:	fd06879b          	addiw	a5,a3,-48
 2dc:	0ff7f793          	zext.b	a5,a5
 2e0:	fef671e3          	bgeu	a2,a5,2c2 <atoi+0x1e>
  return n;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  n = 0;
 2ec:	4501                	li	a0,0
 2ee:	bfdd                	j	2e4 <atoi+0x40>

00000000000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f8:	02b57563          	bgeu	a0,a1,322 <memmove+0x32>
    while(n-- > 0)
 2fc:	00c05f63          	blez	a2,31a <memmove+0x2a>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 308:	872a                	mv	a4,a0
      *dst++ = *src++;
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 316:	fee79ae3          	bne	a5,a4,30a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
    dst += n;
 322:	00c50733          	add	a4,a0,a2
    src += n;
 326:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 328:	fec059e3          	blez	a2,31a <memmove+0x2a>
 32c:	fff6079b          	addiw	a5,a2,-1
 330:	1782                	slli	a5,a5,0x20
 332:	9381                	srli	a5,a5,0x20
 334:	fff7c793          	not	a5,a5
 338:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33a:	15fd                	addi	a1,a1,-1
 33c:	177d                	addi	a4,a4,-1
 33e:	0005c683          	lbu	a3,0(a1)
 342:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 346:	fef71ae3          	bne	a4,a5,33a <memmove+0x4a>
 34a:	bfc1                	j	31a <memmove+0x2a>

000000000000034c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca0d                	beqz	a2,386 <memcmp+0x3a>
 356:	fff6069b          	addiw	a3,a2,-1
 35a:	1682                	slli	a3,a3,0x20
 35c:	9281                	srli	a3,a3,0x20
 35e:	0685                	addi	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x16>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x32>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  return 0;
 386:	4501                	li	a0,0
 388:	bfdd                	j	37e <memcmp+0x32>

000000000000038a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 392:	00000097          	auipc	ra,0x0
 396:	f5e080e7          	jalr	-162(ra) # 2f0 <memmove>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 46a:	48e9                	li	a7,26
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f46080e7          	jalr	-186(ra) # 3ca <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c063          	bltz	a1,526 <printint+0x92>
  neg = 0;
 4aa:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4ac:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4b0:	869a                	mv	a3,t1
  i = 0;
 4b2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4b4:	00000817          	auipc	a6,0x0
 4b8:	4ac80813          	addi	a6,a6,1196 # 960 <digits>
 4bc:	88be                	mv	a7,a5
 4be:	0017851b          	addiw	a0,a5,1
 4c2:	87aa                	mv	a5,a0
 4c4:	02c5f73b          	remuw	a4,a1,a2
 4c8:	1702                	slli	a4,a4,0x20
 4ca:	9301                	srli	a4,a4,0x20
 4cc:	9742                	add	a4,a4,a6
 4ce:	00074703          	lbu	a4,0(a4)
 4d2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4d6:	872e                	mv	a4,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fcc77fe3          	bgeu	a4,a2,4bc <printint+0x28>
  if(neg)
 4e2:	000e0c63          	beqz	t3,4fa <printint+0x66>
    buf[i++] = '-';
 4e6:	fd050793          	addi	a5,a0,-48
 4ea:	00878533          	add	a0,a5,s0
 4ee:	02d00793          	li	a5,45
 4f2:	fef50823          	sb	a5,-16(a0)
 4f6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4fa:	fff7899b          	addiw	s3,a5,-1
 4fe:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 502:	fff4c583          	lbu	a1,-1(s1)
 506:	854a                	mv	a0,s2
 508:	00000097          	auipc	ra,0x0
 50c:	f6a080e7          	jalr	-150(ra) # 472 <putc>
  while(--i >= 0)
 510:	39fd                	addiw	s3,s3,-1
 512:	14fd                	addi	s1,s1,-1
 514:	fe09d7e3          	bgez	s3,502 <printint+0x6e>
}
 518:	70e2                	ld	ra,56(sp)
 51a:	7442                	ld	s0,48(sp)
 51c:	74a2                	ld	s1,40(sp)
 51e:	7902                	ld	s2,32(sp)
 520:	69e2                	ld	s3,24(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret
    x = -xx;
 526:	40b005bb          	negw	a1,a1
    neg = 1;
 52a:	4e05                	li	t3,1
    x = -xx;
 52c:	b741                	j	4ac <printint+0x18>

000000000000052e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52e:	715d                	addi	sp,sp,-80
 530:	e486                	sd	ra,72(sp)
 532:	e0a2                	sd	s0,64(sp)
 534:	f84a                	sd	s2,48(sp)
 536:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c903          	lbu	s2,0(a1)
 53c:	1a090a63          	beqz	s2,6f0 <vprintf+0x1c2>
 540:	fc26                	sd	s1,56(sp)
 542:	f44e                	sd	s3,40(sp)
 544:	f052                	sd	s4,32(sp)
 546:	ec56                	sd	s5,24(sp)
 548:	e85a                	sd	s6,16(sp)
 54a:	e45e                	sd	s7,8(sp)
 54c:	8aaa                	mv	s5,a0
 54e:	8bb2                	mv	s7,a2
 550:	00158493          	addi	s1,a1,1
  state = 0;
 554:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 556:	02500a13          	li	s4,37
 55a:	4b55                	li	s6,21
 55c:	a839                	j	57a <vprintf+0x4c>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	f10080e7          	jalr	-240(ra) # 472 <putc>
 56a:	a019                	j	570 <vprintf+0x42>
    } else if(state == '%'){
 56c:	01498d63          	beq	s3,s4,586 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 570:	0485                	addi	s1,s1,1
 572:	fff4c903          	lbu	s2,-1(s1)
 576:	16090763          	beqz	s2,6e4 <vprintf+0x1b6>
    if(state == 0){
 57a:	fe0999e3          	bnez	s3,56c <vprintf+0x3e>
      if(c == '%'){
 57e:	ff4910e3          	bne	s2,s4,55e <vprintf+0x30>
        state = '%';
 582:	89d2                	mv	s3,s4
 584:	b7f5                	j	570 <vprintf+0x42>
      if(c == 'd'){
 586:	13490463          	beq	s2,s4,6ae <vprintf+0x180>
 58a:	f9d9079b          	addiw	a5,s2,-99
 58e:	0ff7f793          	zext.b	a5,a5
 592:	12fb6763          	bltu	s6,a5,6c0 <vprintf+0x192>
 596:	f9d9079b          	addiw	a5,s2,-99
 59a:	0ff7f713          	zext.b	a4,a5
 59e:	12eb6163          	bltu	s6,a4,6c0 <vprintf+0x192>
 5a2:	00271793          	slli	a5,a4,0x2
 5a6:	00000717          	auipc	a4,0x0
 5aa:	36270713          	addi	a4,a4,866 # 908 <malloc+0x124>
 5ae:	97ba                	add	a5,a5,a4
 5b0:	439c                	lw	a5,0(a5)
 5b2:	97ba                	add	a5,a5,a4
 5b4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ed0080e7          	jalr	-304(ra) # 494 <printint>
 5cc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b745                	j	570 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	eb4080e7          	jalr	-332(ra) # 494 <printint>
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b751                	j	570 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e98080e7          	jalr	-360(ra) # 494 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	b7a5                	j	570 <vprintf+0x42>
 60a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 60c:	008b8c13          	addi	s8,s7,8
 610:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 614:	03000593          	li	a1,48
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e58080e7          	jalr	-424(ra) # 472 <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e4a080e7          	jalr	-438(ra) # 472 <putc>
 630:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	32eb8b93          	addi	s7,s7,814 # 960 <digits>
 63a:	03c9d793          	srli	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e2c080e7          	jalr	-468(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	slli	s3,s3,0x4
 650:	397d                	addiw	s2,s2,-1
 652:	fe0914e3          	bnez	s2,63a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 656:	8be2                	mv	s7,s8
      state = 0;
 658:	4981                	li	s3,0
 65a:	6c02                	ld	s8,0(sp)
 65c:	bf11                	j	570 <vprintf+0x42>
        s = va_arg(ap, char*);
 65e:	008b8993          	addi	s3,s7,8
 662:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 666:	02090163          	beqz	s2,688 <vprintf+0x15a>
        while(*s != 0){
 66a:	00094583          	lbu	a1,0(s2)
 66e:	c9a5                	beqz	a1,6de <vprintf+0x1b0>
          putc(fd, *s);
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e00080e7          	jalr	-512(ra) # 472 <putc>
          s++;
 67a:	0905                	addi	s2,s2,1
        while(*s != 0){
 67c:	00094583          	lbu	a1,0(s2)
 680:	f9e5                	bnez	a1,670 <vprintf+0x142>
        s = va_arg(ap, char*);
 682:	8bce                	mv	s7,s3
      state = 0;
 684:	4981                	li	s3,0
 686:	b5ed                	j	570 <vprintf+0x42>
          s = "(null)";
 688:	00000917          	auipc	s2,0x0
 68c:	27890913          	addi	s2,s2,632 # 900 <malloc+0x11c>
        while(*s != 0){
 690:	02800593          	li	a1,40
 694:	bff1                	j	670 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 696:	008b8913          	addi	s2,s7,8
 69a:	000bc583          	lbu	a1,0(s7)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	dd2080e7          	jalr	-558(ra) # 472 <putc>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5d1                	j	570 <vprintf+0x42>
        putc(fd, c);
 6ae:	02500593          	li	a1,37
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	dbe080e7          	jalr	-578(ra) # 472 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd4d                	j	570 <vprintf+0x42>
        putc(fd, '%');
 6c0:	02500593          	li	a1,37
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dac080e7          	jalr	-596(ra) # 472 <putc>
        putc(fd, c);
 6ce:	85ca                	mv	a1,s2
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	da0080e7          	jalr	-608(ra) # 472 <putc>
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bd51                	j	570 <vprintf+0x42>
        s = va_arg(ap, char*);
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b579                	j	570 <vprintf+0x42>
 6e4:	74e2                	ld	s1,56(sp)
 6e6:	79a2                	ld	s3,40(sp)
 6e8:	7a02                	ld	s4,32(sp)
 6ea:	6ae2                	ld	s5,24(sp)
 6ec:	6b42                	ld	s6,16(sp)
 6ee:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6f0:	60a6                	ld	ra,72(sp)
 6f2:	6406                	ld	s0,64(sp)
 6f4:	7942                	ld	s2,48(sp)
 6f6:	6161                	addi	sp,sp,80
 6f8:	8082                	ret

00000000000006fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fa:	715d                	addi	sp,sp,-80
 6fc:	ec06                	sd	ra,24(sp)
 6fe:	e822                	sd	s0,16(sp)
 700:	1000                	addi	s0,sp,32
 702:	e010                	sd	a2,0(s0)
 704:	e414                	sd	a3,8(s0)
 706:	e818                	sd	a4,16(s0)
 708:	ec1c                	sd	a5,24(s0)
 70a:	03043023          	sd	a6,32(s0)
 70e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	8622                	mv	a2,s0
 714:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 718:	00000097          	auipc	ra,0x0
 71c:	e16080e7          	jalr	-490(ra) # 52e <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6161                	addi	sp,sp,80
 726:	8082                	ret

0000000000000728 <printf>:

void
printf(const char *fmt, ...)
{
 728:	711d                	addi	sp,sp,-96
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	addi	s0,sp,32
 730:	e40c                	sd	a1,8(s0)
 732:	e810                	sd	a2,16(s0)
 734:	ec14                	sd	a3,24(s0)
 736:	f018                	sd	a4,32(s0)
 738:	f41c                	sd	a5,40(s0)
 73a:	03043823          	sd	a6,48(s0)
 73e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	00840613          	addi	a2,s0,8
 746:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74a:	85aa                	mv	a1,a0
 74c:	4505                	li	a0,1
 74e:	00000097          	auipc	ra,0x0
 752:	de0080e7          	jalr	-544(ra) # 52e <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e406                	sd	ra,8(sp)
 762:	e022                	sd	s0,0(sp)
 764:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	00001797          	auipc	a5,0x1
 76e:	8967b783          	ld	a5,-1898(a5) # 1000 <freep>
 772:	a02d                	j	79c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 774:	4618                	lw	a4,8(a2)
 776:	9f2d                	addw	a4,a4,a1
 778:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	6310                	ld	a2,0(a4)
 780:	a83d                	j	7be <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9f31                	addw	a4,a4,a2
 788:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053683          	ld	a3,-16(a0)
 78e:	a091                	j	7d2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	6398                	ld	a4,0(a5)
 792:	00e7e463          	bltu	a5,a4,79a <free+0x3c>
 796:	00e6ea63          	bltu	a3,a4,7aa <free+0x4c>
{
 79a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	fed7fae3          	bgeu	a5,a3,790 <free+0x32>
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e6e463          	bltu	a3,a4,7aa <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	fee7eae3          	bltu	a5,a4,79a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059813          	slli	a6,a1,0x20
 7b4:	01c85713          	srli	a4,a6,0x1c
 7b8:	9736                	add	a4,a4,a3
 7ba:	fae60de3          	beq	a2,a4,774 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061593          	slli	a1,a2,0x20
 7c8:	01c5d713          	srli	a4,a1,0x1c
 7cc:	973e                	add	a4,a4,a5
 7ce:	fae68ae3          	beq	a3,a4,782 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
}
 7dc:	60a2                	ld	ra,8(sp)
 7de:	6402                	ld	s0,0(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret

00000000000007e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e4:	7139                	addi	sp,sp,-64
 7e6:	fc06                	sd	ra,56(sp)
 7e8:	f822                	sd	s0,48(sp)
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	ec4e                	sd	s3,24(sp)
 7ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	02051993          	slli	s3,a0,0x20
 7f4:	0209d993          	srli	s3,s3,0x20
 7f8:	09bd                	addi	s3,s3,15
 7fa:	0049d993          	srli	s3,s3,0x4
 7fe:	2985                	addiw	s3,s3,1
 800:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 802:	00000517          	auipc	a0,0x0
 806:	7fe53503          	ld	a0,2046(a0) # 1000 <freep>
 80a:	c905                	beqz	a0,83a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	09377a63          	bgeu	a4,s3,8a4 <malloc+0xc0>
 814:	f426                	sd	s1,40(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81c:	8a4e                	mv	s4,s3
 81e:	6705                	lui	a4,0x1
 820:	00e9f363          	bgeu	s3,a4,826 <malloc+0x42>
 824:	6a05                	lui	s4,0x1
 826:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82e:	00000497          	auipc	s1,0x0
 832:	7d248493          	addi	s1,s1,2002 # 1000 <freep>
  if(p == (char*)-1)
 836:	5afd                	li	s5,-1
 838:	a089                	j	87a <malloc+0x96>
 83a:	f426                	sd	s1,40(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 842:	00000797          	auipc	a5,0x0
 846:	7ce78793          	addi	a5,a5,1998 # 1010 <base>
 84a:	00000717          	auipc	a4,0x0
 84e:	7af73b23          	sd	a5,1974(a4) # 1000 <freep>
 852:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 854:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 858:	b7d1                	j	81c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 85a:	6398                	ld	a4,0(a5)
 85c:	e118                	sd	a4,0(a0)
 85e:	a8b9                	j	8bc <malloc+0xd8>
  hp->s.size = nu;
 860:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 864:	0541                	addi	a0,a0,16
 866:	00000097          	auipc	ra,0x0
 86a:	ef8080e7          	jalr	-264(ra) # 75e <free>
  return freep;
 86e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 870:	c135                	beqz	a0,8d4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	03277363          	bgeu	a4,s2,89c <malloc+0xb8>
    if(p == freep)
 87a:	6098                	ld	a4,0(s1)
 87c:	853e                	mv	a0,a5
 87e:	fef71ae3          	bne	a4,a5,872 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 882:	8552                	mv	a0,s4
 884:	00000097          	auipc	ra,0x0
 888:	bae080e7          	jalr	-1106(ra) # 432 <sbrk>
  if(p == (char*)-1)
 88c:	fd551ae3          	bne	a0,s5,860 <malloc+0x7c>
        return 0;
 890:	4501                	li	a0,0
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	a03d                	j	8c8 <malloc+0xe4>
 89c:	74a2                	ld	s1,40(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8a4:	fae90be3          	beq	s2,a4,85a <malloc+0x76>
        p->s.size -= nunits;
 8a8:	4137073b          	subw	a4,a4,s3
 8ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ae:	02071693          	slli	a3,a4,0x20
 8b2:	01c6d713          	srli	a4,a3,0x1c
 8b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74a73223          	sd	a0,1860(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c4:	01078513          	addi	a0,a5,16
  }
}
 8c8:	70e2                	ld	ra,56(sp)
 8ca:	7442                	ld	s0,48(sp)
 8cc:	7902                	ld	s2,32(sp)
 8ce:	69e2                	ld	s3,24(sp)
 8d0:	6121                	addi	sp,sp,64
 8d2:	8082                	ret
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	b7f5                	j	8c8 <malloc+0xe4>
