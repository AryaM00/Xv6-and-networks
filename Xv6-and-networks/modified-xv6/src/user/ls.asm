
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	35a080e7          	jalr	858(ra) # 366 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	32e080e7          	jalr	814(ra) # 366 <strlen>
  40:	47b5                	li	a5,13
  42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  46:	8526                	mv	a0,s1
  48:	70a2                	ld	ra,40(sp)
  4a:	7402                	ld	s0,32(sp)
  4c:	64e2                	ld	s1,24(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret
  52:	e84a                	sd	s2,16(sp)
  54:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  56:	8526                	mv	a0,s1
  58:	00000097          	auipc	ra,0x0
  5c:	30e080e7          	jalr	782(ra) # 366 <strlen>
  60:	862a                	mv	a2,a0
  62:	00001997          	auipc	s3,0x1
  66:	fae98993          	addi	s3,s3,-82 # 1010 <buf.0>
  6a:	85a6                	mv	a1,s1
  6c:	854e                	mv	a0,s3
  6e:	00000097          	auipc	ra,0x0
  72:	48e080e7          	jalr	1166(ra) # 4fc <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  76:	8526                	mv	a0,s1
  78:	00000097          	auipc	ra,0x0
  7c:	2ee080e7          	jalr	750(ra) # 366 <strlen>
  80:	892a                	mv	s2,a0
  82:	8526                	mv	a0,s1
  84:	00000097          	auipc	ra,0x0
  88:	2e2080e7          	jalr	738(ra) # 366 <strlen>
  8c:	1902                	slli	s2,s2,0x20
  8e:	02095913          	srli	s2,s2,0x20
  92:	4639                	li	a2,14
  94:	9e09                	subw	a2,a2,a0
  96:	02000593          	li	a1,32
  9a:	01298533          	add	a0,s3,s2
  9e:	00000097          	auipc	ra,0x0
  a2:	2f6080e7          	jalr	758(ra) # 394 <memset>
  return buf;
  a6:	84ce                	mv	s1,s3
  a8:	6942                	ld	s2,16(sp)
  aa:	69a2                	ld	s3,8(sp)
  ac:	bf69                	j	46 <fmtname+0x46>

00000000000000ae <ls>:

void
ls(char *path)
{
  ae:	d7010113          	addi	sp,sp,-656
  b2:	28113423          	sd	ra,648(sp)
  b6:	28813023          	sd	s0,640(sp)
  ba:	27213823          	sd	s2,624(sp)
  be:	0d00                	addi	s0,sp,656
  c0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c2:	4581                	li	a1,0
  c4:	00000097          	auipc	ra,0x0
  c8:	532080e7          	jalr	1330(ra) # 5f6 <open>
  cc:	06054b63          	bltz	a0,142 <ls+0x94>
  d0:	26913c23          	sd	s1,632(sp)
  d4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  d6:	d7840593          	addi	a1,s0,-648
  da:	00000097          	auipc	ra,0x0
  de:	534080e7          	jalr	1332(ra) # 60e <fstat>
  e2:	06054b63          	bltz	a0,158 <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  e6:	d8041783          	lh	a5,-640(s0)
  ea:	4705                	li	a4,1
  ec:	08e78863          	beq	a5,a4,17c <ls+0xce>
  f0:	37f9                	addiw	a5,a5,-2
  f2:	17c2                	slli	a5,a5,0x30
  f4:	93c1                	srli	a5,a5,0x30
  f6:	02f76663          	bltu	a4,a5,122 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
  fa:	854a                	mv	a0,s2
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <fmtname>
 104:	85aa                	mv	a1,a0
 106:	d8843703          	ld	a4,-632(s0)
 10a:	d7c42683          	lw	a3,-644(s0)
 10e:	d8041603          	lh	a2,-640(s0)
 112:	00001517          	auipc	a0,0x1
 116:	a0e50513          	addi	a0,a0,-1522 # b20 <malloc+0x130>
 11a:	00001097          	auipc	ra,0x1
 11e:	81a080e7          	jalr	-2022(ra) # 934 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 122:	8526                	mv	a0,s1
 124:	00000097          	auipc	ra,0x0
 128:	4ba080e7          	jalr	1210(ra) # 5de <close>
 12c:	27813483          	ld	s1,632(sp)
}
 130:	28813083          	ld	ra,648(sp)
 134:	28013403          	ld	s0,640(sp)
 138:	27013903          	ld	s2,624(sp)
 13c:	29010113          	addi	sp,sp,656
 140:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 142:	864a                	mv	a2,s2
 144:	00001597          	auipc	a1,0x1
 148:	9ac58593          	addi	a1,a1,-1620 # af0 <malloc+0x100>
 14c:	4509                	li	a0,2
 14e:	00000097          	auipc	ra,0x0
 152:	7b8080e7          	jalr	1976(ra) # 906 <fprintf>
    return;
 156:	bfe9                	j	130 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 158:	864a                	mv	a2,s2
 15a:	00001597          	auipc	a1,0x1
 15e:	9ae58593          	addi	a1,a1,-1618 # b08 <malloc+0x118>
 162:	4509                	li	a0,2
 164:	00000097          	auipc	ra,0x0
 168:	7a2080e7          	jalr	1954(ra) # 906 <fprintf>
    close(fd);
 16c:	8526                	mv	a0,s1
 16e:	00000097          	auipc	ra,0x0
 172:	470080e7          	jalr	1136(ra) # 5de <close>
    return;
 176:	27813483          	ld	s1,632(sp)
 17a:	bf5d                	j	130 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17c:	854a                	mv	a0,s2
 17e:	00000097          	auipc	ra,0x0
 182:	1e8080e7          	jalr	488(ra) # 366 <strlen>
 186:	2541                	addiw	a0,a0,16
 188:	20000793          	li	a5,512
 18c:	00a7fb63          	bgeu	a5,a0,1a2 <ls+0xf4>
      printf("ls: path too long\n");
 190:	00001517          	auipc	a0,0x1
 194:	9a050513          	addi	a0,a0,-1632 # b30 <malloc+0x140>
 198:	00000097          	auipc	ra,0x0
 19c:	79c080e7          	jalr	1948(ra) # 934 <printf>
      break;
 1a0:	b749                	j	122 <ls+0x74>
 1a2:	27313423          	sd	s3,616(sp)
 1a6:	27413023          	sd	s4,608(sp)
 1aa:	25513c23          	sd	s5,600(sp)
 1ae:	25613823          	sd	s6,592(sp)
 1b2:	25713423          	sd	s7,584(sp)
 1b6:	25813023          	sd	s8,576(sp)
 1ba:	23913c23          	sd	s9,568(sp)
 1be:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 1c2:	da040993          	addi	s3,s0,-608
 1c6:	85ca                	mv	a1,s2
 1c8:	854e                	mv	a0,s3
 1ca:	00000097          	auipc	ra,0x0
 1ce:	14c080e7          	jalr	332(ra) # 316 <strcpy>
    p = buf+strlen(buf);
 1d2:	854e                	mv	a0,s3
 1d4:	00000097          	auipc	ra,0x0
 1d8:	192080e7          	jalr	402(ra) # 366 <strlen>
 1dc:	1502                	slli	a0,a0,0x20
 1de:	9101                	srli	a0,a0,0x20
 1e0:	99aa                	add	s3,s3,a0
    *p++ = '/';
 1e2:	00198c93          	addi	s9,s3,1
 1e6:	02f00793          	li	a5,47
 1ea:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ee:	d9040a13          	addi	s4,s0,-624
 1f2:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1f4:	d9240c13          	addi	s8,s0,-622
 1f8:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1fa:	d7840b13          	addi	s6,s0,-648
 1fe:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 202:	00001d17          	auipc	s10,0x1
 206:	946d0d13          	addi	s10,s10,-1722 # b48 <malloc+0x158>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20a:	a811                	j	21e <ls+0x170>
        printf("ls: cannot stat %s\n", buf);
 20c:	85d6                	mv	a1,s5
 20e:	00001517          	auipc	a0,0x1
 212:	8fa50513          	addi	a0,a0,-1798 # b08 <malloc+0x118>
 216:	00000097          	auipc	ra,0x0
 21a:	71e080e7          	jalr	1822(ra) # 934 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 21e:	864a                	mv	a2,s2
 220:	85d2                	mv	a1,s4
 222:	8526                	mv	a0,s1
 224:	00000097          	auipc	ra,0x0
 228:	3aa080e7          	jalr	938(ra) # 5ce <read>
 22c:	05251863          	bne	a0,s2,27c <ls+0x1ce>
      if(de.inum == 0)
 230:	d9045783          	lhu	a5,-624(s0)
 234:	d7ed                	beqz	a5,21e <ls+0x170>
      memmove(p, de.name, DIRSIZ);
 236:	865e                	mv	a2,s7
 238:	85e2                	mv	a1,s8
 23a:	8566                	mv	a0,s9
 23c:	00000097          	auipc	ra,0x0
 240:	2c0080e7          	jalr	704(ra) # 4fc <memmove>
      p[DIRSIZ] = 0;
 244:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 248:	85da                	mv	a1,s6
 24a:	8556                	mv	a0,s5
 24c:	00000097          	auipc	ra,0x0
 250:	21e080e7          	jalr	542(ra) # 46a <stat>
 254:	fa054ce3          	bltz	a0,20c <ls+0x15e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 258:	8556                	mv	a0,s5
 25a:	00000097          	auipc	ra,0x0
 25e:	da6080e7          	jalr	-602(ra) # 0 <fmtname>
 262:	85aa                	mv	a1,a0
 264:	d8843703          	ld	a4,-632(s0)
 268:	d7c42683          	lw	a3,-644(s0)
 26c:	d8041603          	lh	a2,-640(s0)
 270:	856a                	mv	a0,s10
 272:	00000097          	auipc	ra,0x0
 276:	6c2080e7          	jalr	1730(ra) # 934 <printf>
 27a:	b755                	j	21e <ls+0x170>
 27c:	26813983          	ld	s3,616(sp)
 280:	26013a03          	ld	s4,608(sp)
 284:	25813a83          	ld	s5,600(sp)
 288:	25013b03          	ld	s6,592(sp)
 28c:	24813b83          	ld	s7,584(sp)
 290:	24013c03          	ld	s8,576(sp)
 294:	23813c83          	ld	s9,568(sp)
 298:	23013d03          	ld	s10,560(sp)
 29c:	b559                	j	122 <ls+0x74>

000000000000029e <main>:

int
main(int argc, char *argv[])
{
 29e:	1101                	addi	sp,sp,-32
 2a0:	ec06                	sd	ra,24(sp)
 2a2:	e822                	sd	s0,16(sp)
 2a4:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 2a6:	4785                	li	a5,1
 2a8:	02a7db63          	bge	a5,a0,2de <main+0x40>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	e04a                	sd	s2,0(sp)
 2b0:	00858493          	addi	s1,a1,8
 2b4:	ffe5091b          	addiw	s2,a0,-2
 2b8:	02091793          	slli	a5,s2,0x20
 2bc:	01d7d913          	srli	s2,a5,0x1d
 2c0:	05c1                	addi	a1,a1,16
 2c2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2c4:	6088                	ld	a0,0(s1)
 2c6:	00000097          	auipc	ra,0x0
 2ca:	de8080e7          	jalr	-536(ra) # ae <ls>
  for(i=1; i<argc; i++)
 2ce:	04a1                	addi	s1,s1,8
 2d0:	ff249ae3          	bne	s1,s2,2c4 <main+0x26>
  exit(0);
 2d4:	4501                	li	a0,0
 2d6:	00000097          	auipc	ra,0x0
 2da:	2e0080e7          	jalr	736(ra) # 5b6 <exit>
 2de:	e426                	sd	s1,8(sp)
 2e0:	e04a                	sd	s2,0(sp)
    ls(".");
 2e2:	00001517          	auipc	a0,0x1
 2e6:	87650513          	addi	a0,a0,-1930 # b58 <malloc+0x168>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	dc4080e7          	jalr	-572(ra) # ae <ls>
    exit(0);
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	2c2080e7          	jalr	706(ra) # 5b6 <exit>

00000000000002fc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  extern int main();
  main();
 304:	00000097          	auipc	ra,0x0
 308:	f9a080e7          	jalr	-102(ra) # 29e <main>
  exit(0);
 30c:	4501                	li	a0,0
 30e:	00000097          	auipc	ra,0x0
 312:	2a8080e7          	jalr	680(ra) # 5b6 <exit>

0000000000000316 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31e:	87aa                	mv	a5,a0
 320:	0585                	addi	a1,a1,1
 322:	0785                	addi	a5,a5,1
 324:	fff5c703          	lbu	a4,-1(a1)
 328:	fee78fa3          	sb	a4,-1(a5)
 32c:	fb75                	bnez	a4,320 <strcpy+0xa>
    ;
  return os;
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cb91                	beqz	a5,356 <strcmp+0x20>
 344:	0005c703          	lbu	a4,0(a1)
 348:	00f71763          	bne	a4,a5,356 <strcmp+0x20>
    p++, q++;
 34c:	0505                	addi	a0,a0,1
 34e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 350:	00054783          	lbu	a5,0(a0)
 354:	fbe5                	bnez	a5,344 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 356:	0005c503          	lbu	a0,0(a1)
}
 35a:	40a7853b          	subw	a0,a5,a0
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <strlen>:

uint
strlen(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf99                	beqz	a5,390 <strlen+0x2a>
 374:	0505                	addi	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	86be                	mv	a3,a5
 37a:	0785                	addi	a5,a5,1
 37c:	fff7c703          	lbu	a4,-1(a5)
 380:	ff65                	bnez	a4,378 <strlen+0x12>
 382:	40a6853b          	subw	a0,a3,a0
 386:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  for(n = 0; s[n]; n++)
 390:	4501                	li	a0,0
 392:	bfdd                	j	388 <strlen+0x22>

0000000000000394 <memset>:

void*
memset(void *dst, int c, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 39c:	ca19                	beqz	a2,3b2 <memset+0x1e>
 39e:	87aa                	mv	a5,a0
 3a0:	1602                	slli	a2,a2,0x20
 3a2:	9201                	srli	a2,a2,0x20
 3a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ac:	0785                	addi	a5,a5,1
 3ae:	fee79de3          	bne	a5,a4,3a8 <memset+0x14>
  }
  return dst;
}
 3b2:	60a2                	ld	ra,8(sp)
 3b4:	6402                	ld	s0,0(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret

00000000000003ba <strchr>:

char*
strchr(const char *s, char c)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	cf81                	beqz	a5,3de <strchr+0x24>
    if(*s == c)
 3c8:	00f58763          	beq	a1,a5,3d6 <strchr+0x1c>
  for(; *s; s++)
 3cc:	0505                	addi	a0,a0,1
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	fbfd                	bnez	a5,3c8 <strchr+0xe>
      return (char*)s;
  return 0;
 3d4:	4501                	li	a0,0
}
 3d6:	60a2                	ld	ra,8(sp)
 3d8:	6402                	ld	s0,0(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfdd                	j	3d6 <strchr+0x1c>

00000000000003e2 <gets>:

char*
gets(char *buf, int max)
{
 3e2:	7159                	addi	sp,sp,-112
 3e4:	f486                	sd	ra,104(sp)
 3e6:	f0a2                	sd	s0,96(sp)
 3e8:	eca6                	sd	s1,88(sp)
 3ea:	e8ca                	sd	s2,80(sp)
 3ec:	e4ce                	sd	s3,72(sp)
 3ee:	e0d2                	sd	s4,64(sp)
 3f0:	fc56                	sd	s5,56(sp)
 3f2:	f85a                	sd	s6,48(sp)
 3f4:	f45e                	sd	s7,40(sp)
 3f6:	f062                	sd	s8,32(sp)
 3f8:	ec66                	sd	s9,24(sp)
 3fa:	e86a                	sd	s10,16(sp)
 3fc:	1880                	addi	s0,sp,112
 3fe:	8caa                	mv	s9,a0
 400:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 402:	892a                	mv	s2,a0
 404:	4481                	li	s1,0
    cc = read(0, &c, 1);
 406:	f9f40b13          	addi	s6,s0,-97
 40a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 40c:	4ba9                	li	s7,10
 40e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 410:	8d26                	mv	s10,s1
 412:	0014899b          	addiw	s3,s1,1
 416:	84ce                	mv	s1,s3
 418:	0349d763          	bge	s3,s4,446 <gets+0x64>
    cc = read(0, &c, 1);
 41c:	8656                	mv	a2,s5
 41e:	85da                	mv	a1,s6
 420:	4501                	li	a0,0
 422:	00000097          	auipc	ra,0x0
 426:	1ac080e7          	jalr	428(ra) # 5ce <read>
    if(cc < 1)
 42a:	00a05e63          	blez	a0,446 <gets+0x64>
    buf[i++] = c;
 42e:	f9f44783          	lbu	a5,-97(s0)
 432:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 436:	01778763          	beq	a5,s7,444 <gets+0x62>
 43a:	0905                	addi	s2,s2,1
 43c:	fd879ae3          	bne	a5,s8,410 <gets+0x2e>
    buf[i++] = c;
 440:	8d4e                	mv	s10,s3
 442:	a011                	j	446 <gets+0x64>
 444:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 446:	9d66                	add	s10,s10,s9
 448:	000d0023          	sb	zero,0(s10)
  return buf;
}
 44c:	8566                	mv	a0,s9
 44e:	70a6                	ld	ra,104(sp)
 450:	7406                	ld	s0,96(sp)
 452:	64e6                	ld	s1,88(sp)
 454:	6946                	ld	s2,80(sp)
 456:	69a6                	ld	s3,72(sp)
 458:	6a06                	ld	s4,64(sp)
 45a:	7ae2                	ld	s5,56(sp)
 45c:	7b42                	ld	s6,48(sp)
 45e:	7ba2                	ld	s7,40(sp)
 460:	7c02                	ld	s8,32(sp)
 462:	6ce2                	ld	s9,24(sp)
 464:	6d42                	ld	s10,16(sp)
 466:	6165                	addi	sp,sp,112
 468:	8082                	ret

000000000000046a <stat>:

int
stat(const char *n, struct stat *st)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	e04a                	sd	s2,0(sp)
 472:	1000                	addi	s0,sp,32
 474:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 476:	4581                	li	a1,0
 478:	00000097          	auipc	ra,0x0
 47c:	17e080e7          	jalr	382(ra) # 5f6 <open>
  if(fd < 0)
 480:	02054663          	bltz	a0,4ac <stat+0x42>
 484:	e426                	sd	s1,8(sp)
 486:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 488:	85ca                	mv	a1,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	184080e7          	jalr	388(ra) # 60e <fstat>
 492:	892a                	mv	s2,a0
  close(fd);
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	148080e7          	jalr	328(ra) # 5de <close>
  return r;
 49e:	64a2                	ld	s1,8(sp)
}
 4a0:	854a                	mv	a0,s2
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6902                	ld	s2,0(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret
    return -1;
 4ac:	597d                	li	s2,-1
 4ae:	bfcd                	j	4a0 <stat+0x36>

00000000000004b0 <atoi>:

int
atoi(const char *s)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e406                	sd	ra,8(sp)
 4b4:	e022                	sd	s0,0(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addiw	a5,a3,-48
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66963          	bltu	a2,a5,4f8 <atoi+0x48>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ce:	0705                	addi	a4,a4,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addiw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1e>
  return n;
}
 4f0:	60a2                	ld	ra,8(sp)
 4f2:	6402                	ld	s0,0(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
  n = 0;
 4f8:	4501                	li	a0,0
 4fa:	bfdd                	j	4f0 <atoi+0x40>

00000000000004fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e406                	sd	ra,8(sp)
 500:	e022                	sd	s0,0(sp)
 502:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 504:	02b57563          	bgeu	a0,a1,52e <memmove+0x32>
    while(n-- > 0)
 508:	00c05f63          	blez	a2,526 <memmove+0x2a>
 50c:	1602                	slli	a2,a2,0x20
 50e:	9201                	srli	a2,a2,0x20
 510:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 514:	872a                	mv	a4,a0
      *dst++ = *src++;
 516:	0585                	addi	a1,a1,1
 518:	0705                	addi	a4,a4,1
 51a:	fff5c683          	lbu	a3,-1(a1)
 51e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 522:	fee79ae3          	bne	a5,a4,516 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 526:	60a2                	ld	ra,8(sp)
 528:	6402                	ld	s0,0(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
    dst += n;
 52e:	00c50733          	add	a4,a0,a2
    src += n;
 532:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 534:	fec059e3          	blez	a2,526 <memmove+0x2a>
 538:	fff6079b          	addiw	a5,a2,-1
 53c:	1782                	slli	a5,a5,0x20
 53e:	9381                	srli	a5,a5,0x20
 540:	fff7c793          	not	a5,a5
 544:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 546:	15fd                	addi	a1,a1,-1
 548:	177d                	addi	a4,a4,-1
 54a:	0005c683          	lbu	a3,0(a1)
 54e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 552:	fef71ae3          	bne	a4,a5,546 <memmove+0x4a>
 556:	bfc1                	j	526 <memmove+0x2a>

0000000000000558 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 558:	1141                	addi	sp,sp,-16
 55a:	e406                	sd	ra,8(sp)
 55c:	e022                	sd	s0,0(sp)
 55e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 560:	ca0d                	beqz	a2,592 <memcmp+0x3a>
 562:	fff6069b          	addiw	a3,a2,-1
 566:	1682                	slli	a3,a3,0x20
 568:	9281                	srli	a3,a3,0x20
 56a:	0685                	addi	a3,a3,1
 56c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 56e:	00054783          	lbu	a5,0(a0)
 572:	0005c703          	lbu	a4,0(a1)
 576:	00e79863          	bne	a5,a4,586 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 57a:	0505                	addi	a0,a0,1
    p2++;
 57c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 57e:	fed518e3          	bne	a0,a3,56e <memcmp+0x16>
  }
  return 0;
 582:	4501                	li	a0,0
 584:	a019                	j	58a <memcmp+0x32>
      return *p1 - *p2;
 586:	40e7853b          	subw	a0,a5,a4
}
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret
  return 0;
 592:	4501                	li	a0,0
 594:	bfdd                	j	58a <memcmp+0x32>

0000000000000596 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 596:	1141                	addi	sp,sp,-16
 598:	e406                	sd	ra,8(sp)
 59a:	e022                	sd	s0,0(sp)
 59c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 59e:	00000097          	auipc	ra,0x0
 5a2:	f5e080e7          	jalr	-162(ra) # 4fc <memmove>
}
 5a6:	60a2                	ld	ra,8(sp)
 5a8:	6402                	ld	s0,0(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret

00000000000005ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ae:	4885                	li	a7,1
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b6:	4889                	li	a7,2
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <wait>:
.global wait
wait:
 li a7, SYS_wait
 5be:	488d                	li	a7,3
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c6:	4891                	li	a7,4
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <read>:
.global read
read:
 li a7, SYS_read
 5ce:	4895                	li	a7,5
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <write>:
.global write
write:
 li a7, SYS_write
 5d6:	48c1                	li	a7,16
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <close>:
.global close
close:
 li a7, SYS_close
 5de:	48d5                	li	a7,21
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e6:	4899                	li	a7,6
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ee:	489d                	li	a7,7
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <open>:
.global open
open:
 li a7, SYS_open
 5f6:	48bd                	li	a7,15
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5fe:	48c5                	li	a7,17
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 606:	48c9                	li	a7,18
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 60e:	48a1                	li	a7,8
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <link>:
.global link
link:
 li a7, SYS_link
 616:	48cd                	li	a7,19
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 61e:	48d1                	li	a7,20
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 626:	48a5                	li	a7,9
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <dup>:
.global dup
dup:
 li a7, SYS_dup
 62e:	48a9                	li	a7,10
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 636:	48ad                	li	a7,11
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 63e:	48b1                	li	a7,12
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 646:	48b5                	li	a7,13
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 64e:	48b9                	li	a7,14
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 656:	48d9                	li	a7,22
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 65e:	48dd                	li	a7,23
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 666:	48e1                	li	a7,24
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 66e:	48e5                	li	a7,25
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 676:	48e9                	li	a7,26
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 67e:	1101                	addi	sp,sp,-32
 680:	ec06                	sd	ra,24(sp)
 682:	e822                	sd	s0,16(sp)
 684:	1000                	addi	s0,sp,32
 686:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 68a:	4605                	li	a2,1
 68c:	fef40593          	addi	a1,s0,-17
 690:	00000097          	auipc	ra,0x0
 694:	f46080e7          	jalr	-186(ra) # 5d6 <write>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6105                	addi	sp,sp,32
 69e:	8082                	ret

00000000000006a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a0:	7139                	addi	sp,sp,-64
 6a2:	fc06                	sd	ra,56(sp)
 6a4:	f822                	sd	s0,48(sp)
 6a6:	f426                	sd	s1,40(sp)
 6a8:	f04a                	sd	s2,32(sp)
 6aa:	ec4e                	sd	s3,24(sp)
 6ac:	0080                	addi	s0,sp,64
 6ae:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6b0:	c299                	beqz	a3,6b6 <printint+0x16>
 6b2:	0805c063          	bltz	a1,732 <printint+0x92>
  neg = 0;
 6b6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6b8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 6bc:	869a                	mv	a3,t1
  i = 0;
 6be:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6c0:	00000817          	auipc	a6,0x0
 6c4:	50080813          	addi	a6,a6,1280 # bc0 <digits>
 6c8:	88be                	mv	a7,a5
 6ca:	0017851b          	addiw	a0,a5,1
 6ce:	87aa                	mv	a5,a0
 6d0:	02c5f73b          	remuw	a4,a1,a2
 6d4:	1702                	slli	a4,a4,0x20
 6d6:	9301                	srli	a4,a4,0x20
 6d8:	9742                	add	a4,a4,a6
 6da:	00074703          	lbu	a4,0(a4)
 6de:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6e2:	872e                	mv	a4,a1
 6e4:	02c5d5bb          	divuw	a1,a1,a2
 6e8:	0685                	addi	a3,a3,1
 6ea:	fcc77fe3          	bgeu	a4,a2,6c8 <printint+0x28>
  if(neg)
 6ee:	000e0c63          	beqz	t3,706 <printint+0x66>
    buf[i++] = '-';
 6f2:	fd050793          	addi	a5,a0,-48
 6f6:	00878533          	add	a0,a5,s0
 6fa:	02d00793          	li	a5,45
 6fe:	fef50823          	sb	a5,-16(a0)
 702:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 706:	fff7899b          	addiw	s3,a5,-1
 70a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 70e:	fff4c583          	lbu	a1,-1(s1)
 712:	854a                	mv	a0,s2
 714:	00000097          	auipc	ra,0x0
 718:	f6a080e7          	jalr	-150(ra) # 67e <putc>
  while(--i >= 0)
 71c:	39fd                	addiw	s3,s3,-1
 71e:	14fd                	addi	s1,s1,-1
 720:	fe09d7e3          	bgez	s3,70e <printint+0x6e>
}
 724:	70e2                	ld	ra,56(sp)
 726:	7442                	ld	s0,48(sp)
 728:	74a2                	ld	s1,40(sp)
 72a:	7902                	ld	s2,32(sp)
 72c:	69e2                	ld	s3,24(sp)
 72e:	6121                	addi	sp,sp,64
 730:	8082                	ret
    x = -xx;
 732:	40b005bb          	negw	a1,a1
    neg = 1;
 736:	4e05                	li	t3,1
    x = -xx;
 738:	b741                	j	6b8 <printint+0x18>

000000000000073a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	e486                	sd	ra,72(sp)
 73e:	e0a2                	sd	s0,64(sp)
 740:	f84a                	sd	s2,48(sp)
 742:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 744:	0005c903          	lbu	s2,0(a1)
 748:	1a090a63          	beqz	s2,8fc <vprintf+0x1c2>
 74c:	fc26                	sd	s1,56(sp)
 74e:	f44e                	sd	s3,40(sp)
 750:	f052                	sd	s4,32(sp)
 752:	ec56                	sd	s5,24(sp)
 754:	e85a                	sd	s6,16(sp)
 756:	e45e                	sd	s7,8(sp)
 758:	8aaa                	mv	s5,a0
 75a:	8bb2                	mv	s7,a2
 75c:	00158493          	addi	s1,a1,1
  state = 0;
 760:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 762:	02500a13          	li	s4,37
 766:	4b55                	li	s6,21
 768:	a839                	j	786 <vprintf+0x4c>
        putc(fd, c);
 76a:	85ca                	mv	a1,s2
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	f10080e7          	jalr	-240(ra) # 67e <putc>
 776:	a019                	j	77c <vprintf+0x42>
    } else if(state == '%'){
 778:	01498d63          	beq	s3,s4,792 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 77c:	0485                	addi	s1,s1,1
 77e:	fff4c903          	lbu	s2,-1(s1)
 782:	16090763          	beqz	s2,8f0 <vprintf+0x1b6>
    if(state == 0){
 786:	fe0999e3          	bnez	s3,778 <vprintf+0x3e>
      if(c == '%'){
 78a:	ff4910e3          	bne	s2,s4,76a <vprintf+0x30>
        state = '%';
 78e:	89d2                	mv	s3,s4
 790:	b7f5                	j	77c <vprintf+0x42>
      if(c == 'd'){
 792:	13490463          	beq	s2,s4,8ba <vprintf+0x180>
 796:	f9d9079b          	addiw	a5,s2,-99
 79a:	0ff7f793          	zext.b	a5,a5
 79e:	12fb6763          	bltu	s6,a5,8cc <vprintf+0x192>
 7a2:	f9d9079b          	addiw	a5,s2,-99
 7a6:	0ff7f713          	zext.b	a4,a5
 7aa:	12eb6163          	bltu	s6,a4,8cc <vprintf+0x192>
 7ae:	00271793          	slli	a5,a4,0x2
 7b2:	00000717          	auipc	a4,0x0
 7b6:	3b670713          	addi	a4,a4,950 # b68 <malloc+0x178>
 7ba:	97ba                	add	a5,a5,a4
 7bc:	439c                	lw	a5,0(a5)
 7be:	97ba                	add	a5,a5,a4
 7c0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7c2:	008b8913          	addi	s2,s7,8
 7c6:	4685                	li	a3,1
 7c8:	4629                	li	a2,10
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	ed0080e7          	jalr	-304(ra) # 6a0 <printint>
 7d8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b745                	j	77c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	eb4080e7          	jalr	-332(ra) # 6a0 <printint>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b751                	j	77c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7fa:	008b8913          	addi	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4641                	li	a2,16
 802:	000ba583          	lw	a1,0(s7)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e98080e7          	jalr	-360(ra) # 6a0 <printint>
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	b7a5                	j	77c <vprintf+0x42>
 816:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 818:	008b8c13          	addi	s8,s7,8
 81c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 820:	03000593          	li	a1,48
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e58080e7          	jalr	-424(ra) # 67e <putc>
  putc(fd, 'x');
 82e:	07800593          	li	a1,120
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e4a080e7          	jalr	-438(ra) # 67e <putc>
 83c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83e:	00000b97          	auipc	s7,0x0
 842:	382b8b93          	addi	s7,s7,898 # bc0 <digits>
 846:	03c9d793          	srli	a5,s3,0x3c
 84a:	97de                	add	a5,a5,s7
 84c:	0007c583          	lbu	a1,0(a5)
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e2c080e7          	jalr	-468(ra) # 67e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85a:	0992                	slli	s3,s3,0x4
 85c:	397d                	addiw	s2,s2,-1
 85e:	fe0914e3          	bnez	s2,846 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 862:	8be2                	mv	s7,s8
      state = 0;
 864:	4981                	li	s3,0
 866:	6c02                	ld	s8,0(sp)
 868:	bf11                	j	77c <vprintf+0x42>
        s = va_arg(ap, char*);
 86a:	008b8993          	addi	s3,s7,8
 86e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 872:	02090163          	beqz	s2,894 <vprintf+0x15a>
        while(*s != 0){
 876:	00094583          	lbu	a1,0(s2)
 87a:	c9a5                	beqz	a1,8ea <vprintf+0x1b0>
          putc(fd, *s);
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	e00080e7          	jalr	-512(ra) # 67e <putc>
          s++;
 886:	0905                	addi	s2,s2,1
        while(*s != 0){
 888:	00094583          	lbu	a1,0(s2)
 88c:	f9e5                	bnez	a1,87c <vprintf+0x142>
        s = va_arg(ap, char*);
 88e:	8bce                	mv	s7,s3
      state = 0;
 890:	4981                	li	s3,0
 892:	b5ed                	j	77c <vprintf+0x42>
          s = "(null)";
 894:	00000917          	auipc	s2,0x0
 898:	2cc90913          	addi	s2,s2,716 # b60 <malloc+0x170>
        while(*s != 0){
 89c:	02800593          	li	a1,40
 8a0:	bff1                	j	87c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8a2:	008b8913          	addi	s2,s7,8
 8a6:	000bc583          	lbu	a1,0(s7)
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dd2080e7          	jalr	-558(ra) # 67e <putc>
 8b4:	8bca                	mv	s7,s2
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b5d1                	j	77c <vprintf+0x42>
        putc(fd, c);
 8ba:	02500593          	li	a1,37
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	dbe080e7          	jalr	-578(ra) # 67e <putc>
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bd4d                	j	77c <vprintf+0x42>
        putc(fd, '%');
 8cc:	02500593          	li	a1,37
 8d0:	8556                	mv	a0,s5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	dac080e7          	jalr	-596(ra) # 67e <putc>
        putc(fd, c);
 8da:	85ca                	mv	a1,s2
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	da0080e7          	jalr	-608(ra) # 67e <putc>
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bd51                	j	77c <vprintf+0x42>
        s = va_arg(ap, char*);
 8ea:	8bce                	mv	s7,s3
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	b579                	j	77c <vprintf+0x42>
 8f0:	74e2                	ld	s1,56(sp)
 8f2:	79a2                	ld	s3,40(sp)
 8f4:	7a02                	ld	s4,32(sp)
 8f6:	6ae2                	ld	s5,24(sp)
 8f8:	6b42                	ld	s6,16(sp)
 8fa:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8fc:	60a6                	ld	ra,72(sp)
 8fe:	6406                	ld	s0,64(sp)
 900:	7942                	ld	s2,48(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 906:	715d                	addi	sp,sp,-80
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e010                	sd	a2,0(s0)
 910:	e414                	sd	a3,8(s0)
 912:	e818                	sd	a4,16(s0)
 914:	ec1c                	sd	a5,24(s0)
 916:	03043023          	sd	a6,32(s0)
 91a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	8622                	mv	a2,s0
 920:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 924:	00000097          	auipc	ra,0x0
 928:	e16080e7          	jalr	-490(ra) # 73a <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6161                	addi	sp,sp,80
 932:	8082                	ret

0000000000000934 <printf>:

void
printf(const char *fmt, ...)
{
 934:	711d                	addi	sp,sp,-96
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	1000                	addi	s0,sp,32
 93c:	e40c                	sd	a1,8(s0)
 93e:	e810                	sd	a2,16(s0)
 940:	ec14                	sd	a3,24(s0)
 942:	f018                	sd	a4,32(s0)
 944:	f41c                	sd	a5,40(s0)
 946:	03043823          	sd	a6,48(s0)
 94a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	00840613          	addi	a2,s0,8
 952:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 956:	85aa                	mv	a1,a0
 958:	4505                	li	a0,1
 95a:	00000097          	auipc	ra,0x0
 95e:	de0080e7          	jalr	-544(ra) # 73a <vprintf>
}
 962:	60e2                	ld	ra,24(sp)
 964:	6442                	ld	s0,16(sp)
 966:	6125                	addi	sp,sp,96
 968:	8082                	ret

000000000000096a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96a:	1141                	addi	sp,sp,-16
 96c:	e406                	sd	ra,8(sp)
 96e:	e022                	sd	s0,0(sp)
 970:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 972:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	00000797          	auipc	a5,0x0
 97a:	68a7b783          	ld	a5,1674(a5) # 1000 <freep>
 97e:	a02d                	j	9a8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 980:	4618                	lw	a4,8(a2)
 982:	9f2d                	addw	a4,a4,a1
 984:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	6310                	ld	a2,0(a4)
 98c:	a83d                	j	9ca <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98e:	ff852703          	lw	a4,-8(a0)
 992:	9f31                	addw	a4,a4,a2
 994:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 996:	ff053683          	ld	a3,-16(a0)
 99a:	a091                	j	9de <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	6398                	ld	a4,0(a5)
 99e:	00e7e463          	bltu	a5,a4,9a6 <free+0x3c>
 9a2:	00e6ea63          	bltu	a3,a4,9b6 <free+0x4c>
{
 9a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a8:	fed7fae3          	bgeu	a5,a3,99c <free+0x32>
 9ac:	6398                	ld	a4,0(a5)
 9ae:	00e6e463          	bltu	a3,a4,9b6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b2:	fee7eae3          	bltu	a5,a4,9a6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9b6:	ff852583          	lw	a1,-8(a0)
 9ba:	6390                	ld	a2,0(a5)
 9bc:	02059813          	slli	a6,a1,0x20
 9c0:	01c85713          	srli	a4,a6,0x1c
 9c4:	9736                	add	a4,a4,a3
 9c6:	fae60de3          	beq	a2,a4,980 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ce:	4790                	lw	a2,8(a5)
 9d0:	02061593          	slli	a1,a2,0x20
 9d4:	01c5d713          	srli	a4,a1,0x1c
 9d8:	973e                	add	a4,a4,a5
 9da:	fae68ae3          	beq	a3,a4,98e <free+0x24>
    p->s.ptr = bp->s.ptr;
 9de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e0:	00000717          	auipc	a4,0x0
 9e4:	62f73023          	sd	a5,1568(a4) # 1000 <freep>
}
 9e8:	60a2                	ld	ra,8(sp)
 9ea:	6402                	ld	s0,0(sp)
 9ec:	0141                	addi	sp,sp,16
 9ee:	8082                	ret

00000000000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	7139                	addi	sp,sp,-64
 9f2:	fc06                	sd	ra,56(sp)
 9f4:	f822                	sd	s0,48(sp)
 9f6:	f04a                	sd	s2,32(sp)
 9f8:	ec4e                	sd	s3,24(sp)
 9fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fc:	02051993          	slli	s3,a0,0x20
 a00:	0209d993          	srli	s3,s3,0x20
 a04:	09bd                	addi	s3,s3,15
 a06:	0049d993          	srli	s3,s3,0x4
 a0a:	2985                	addiw	s3,s3,1
 a0c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0e:	00000517          	auipc	a0,0x0
 a12:	5f253503          	ld	a0,1522(a0) # 1000 <freep>
 a16:	c905                	beqz	a0,a46 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1a:	4798                	lw	a4,8(a5)
 a1c:	09377a63          	bgeu	a4,s3,ab0 <malloc+0xc0>
 a20:	f426                	sd	s1,40(sp)
 a22:	e852                	sd	s4,16(sp)
 a24:	e456                	sd	s5,8(sp)
 a26:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a28:	8a4e                	mv	s4,s3
 a2a:	6705                	lui	a4,0x1
 a2c:	00e9f363          	bgeu	s3,a4,a32 <malloc+0x42>
 a30:	6a05                	lui	s4,0x1
 a32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3a:	00000497          	auipc	s1,0x0
 a3e:	5c648493          	addi	s1,s1,1478 # 1000 <freep>
  if(p == (char*)-1)
 a42:	5afd                	li	s5,-1
 a44:	a089                	j	a86 <malloc+0x96>
 a46:	f426                	sd	s1,40(sp)
 a48:	e852                	sd	s4,16(sp)
 a4a:	e456                	sd	s5,8(sp)
 a4c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4e:	00000797          	auipc	a5,0x0
 a52:	5d278793          	addi	a5,a5,1490 # 1020 <base>
 a56:	00000717          	auipc	a4,0x0
 a5a:	5af73523          	sd	a5,1450(a4) # 1000 <freep>
 a5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a64:	b7d1                	j	a28 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a66:	6398                	ld	a4,0(a5)
 a68:	e118                	sd	a4,0(a0)
 a6a:	a8b9                	j	ac8 <malloc+0xd8>
  hp->s.size = nu;
 a6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a70:	0541                	addi	a0,a0,16
 a72:	00000097          	auipc	ra,0x0
 a76:	ef8080e7          	jalr	-264(ra) # 96a <free>
  return freep;
 a7a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a7c:	c135                	beqz	a0,ae0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a80:	4798                	lw	a4,8(a5)
 a82:	03277363          	bgeu	a4,s2,aa8 <malloc+0xb8>
    if(p == freep)
 a86:	6098                	ld	a4,0(s1)
 a88:	853e                	mv	a0,a5
 a8a:	fef71ae3          	bne	a4,a5,a7e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a8e:	8552                	mv	a0,s4
 a90:	00000097          	auipc	ra,0x0
 a94:	bae080e7          	jalr	-1106(ra) # 63e <sbrk>
  if(p == (char*)-1)
 a98:	fd551ae3          	bne	a0,s5,a6c <malloc+0x7c>
        return 0;
 a9c:	4501                	li	a0,0
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
 aa6:	a03d                	j	ad4 <malloc+0xe4>
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	6a42                	ld	s4,16(sp)
 aac:	6aa2                	ld	s5,8(sp)
 aae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab0:	fae90be3          	beq	s2,a4,a66 <malloc+0x76>
        p->s.size -= nunits;
 ab4:	4137073b          	subw	a4,a4,s3
 ab8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aba:	02071693          	slli	a3,a4,0x20
 abe:	01c6d713          	srli	a4,a3,0x1c
 ac2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac8:	00000717          	auipc	a4,0x0
 acc:	52a73c23          	sd	a0,1336(a4) # 1000 <freep>
      return (void*)(p + 1);
 ad0:	01078513          	addi	a0,a5,16
  }
}
 ad4:	70e2                	ld	ra,56(sp)
 ad6:	7442                	ld	s0,48(sp)
 ad8:	7902                	ld	s2,32(sp)
 ada:	69e2                	ld	s3,24(sp)
 adc:	6121                	addi	sp,sp,64
 ade:	8082                	ret
 ae0:	74a2                	ld	s1,40(sp)
 ae2:	6a42                	ld	s4,16(sp)
 ae4:	6aa2                	ld	s5,8(sp)
 ae6:	6b02                	ld	s6,0(sp)
 ae8:	b7f5                	j	ad4 <malloc+0xe4>
