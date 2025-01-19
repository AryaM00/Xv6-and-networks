
user/_syscount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <syscall_name>:
#include "../kernel/syscall.h"   
#include "../kernel/param.h"  
#include "user.h"


char* syscall_name(int mask) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    for (int i = 0; i < 32; i++) {
   8:	4781                	li	a5,0
        if (mask == (1 << i)) {
   a:	4685                	li	a3,1
    for (int i = 0; i < 32; i++) {
   c:	02000613          	li	a2,32
        if (mask == (1 << i)) {
  10:	00f6973b          	sllw	a4,a3,a5
  14:	00a70d63          	beq	a4,a0,2e <syscall_name+0x2e>
    for (int i = 0; i < 32; i++) {
  18:	2785                	addiw	a5,a5,1
  1a:	fec79be3          	bne	a5,a2,10 <syscall_name+0x10>

        
            }
        }
    }
    return "unknown";
  1e:	00001517          	auipc	a0,0x1
  22:	a9a50513          	addi	a0,a0,-1382 # ab8 <malloc+0x1ce>
}
  26:	60a2                	ld	ra,8(sp)
  28:	6402                	ld	s0,0(sp)
  2a:	0141                	addi	sp,sp,16
  2c:	8082                	ret
            switch (i) {
  2e:	475d                	li	a4,23
  30:	fef764e3          	bltu	a4,a5,18 <syscall_name+0x18>
  34:	00279713          	slli	a4,a5,0x2
  38:	00001597          	auipc	a1,0x1
  3c:	ae858593          	addi	a1,a1,-1304 # b20 <malloc+0x236>
  40:	972e                	add	a4,a4,a1
  42:	4318                	lw	a4,0(a4)
  44:	972e                	add	a4,a4,a1
  46:	8702                	jr	a4
                case SYS_wait: return "wait";
  48:	00001517          	auipc	a0,0x1
  4c:	9c050513          	addi	a0,a0,-1600 # a08 <malloc+0x11e>
  50:	bfd9                	j	26 <syscall_name+0x26>
                case SYS_pipe: return "pipe";
  52:	00001517          	auipc	a0,0x1
  56:	9be50513          	addi	a0,a0,-1602 # a10 <malloc+0x126>
  5a:	b7f1                	j	26 <syscall_name+0x26>
                case SYS_read: return "read";
  5c:	00001517          	auipc	a0,0x1
  60:	9bc50513          	addi	a0,a0,-1604 # a18 <malloc+0x12e>
  64:	b7c9                	j	26 <syscall_name+0x26>
                case SYS_kill: return "kill";
  66:	00001517          	auipc	a0,0x1
  6a:	9ba50513          	addi	a0,a0,-1606 # a20 <malloc+0x136>
  6e:	bf65                	j	26 <syscall_name+0x26>
                case SYS_exec: return "exec";
  70:	00001517          	auipc	a0,0x1
  74:	9b850513          	addi	a0,a0,-1608 # a28 <malloc+0x13e>
  78:	b77d                	j	26 <syscall_name+0x26>
                case SYS_fstat: return "fstat";
  7a:	00001517          	auipc	a0,0x1
  7e:	9b650513          	addi	a0,a0,-1610 # a30 <malloc+0x146>
  82:	b755                	j	26 <syscall_name+0x26>
                case SYS_chdir: return "chdir";
  84:	00001517          	auipc	a0,0x1
  88:	9b450513          	addi	a0,a0,-1612 # a38 <malloc+0x14e>
  8c:	bf69                	j	26 <syscall_name+0x26>
                case SYS_dup: return "dup";
  8e:	00001517          	auipc	a0,0x1
  92:	9b250513          	addi	a0,a0,-1614 # a40 <malloc+0x156>
  96:	bf41                	j	26 <syscall_name+0x26>
                case SYS_getpid: return "getpid";
  98:	00001517          	auipc	a0,0x1
  9c:	9b050513          	addi	a0,a0,-1616 # a48 <malloc+0x15e>
  a0:	b759                	j	26 <syscall_name+0x26>
                case SYS_sbrk: return "sbrk";
  a2:	00001517          	auipc	a0,0x1
  a6:	9ae50513          	addi	a0,a0,-1618 # a50 <malloc+0x166>
  aa:	bfb5                	j	26 <syscall_name+0x26>
                case SYS_sleep: return "sleep";
  ac:	00001517          	auipc	a0,0x1
  b0:	9ac50513          	addi	a0,a0,-1620 # a58 <malloc+0x16e>
  b4:	bf8d                	j	26 <syscall_name+0x26>
                case SYS_uptime: return "uptime";
  b6:	00001517          	auipc	a0,0x1
  ba:	9aa50513          	addi	a0,a0,-1622 # a60 <malloc+0x176>
  be:	b7a5                	j	26 <syscall_name+0x26>
                case SYS_open: return "open";
  c0:	00001517          	auipc	a0,0x1
  c4:	9a850513          	addi	a0,a0,-1624 # a68 <malloc+0x17e>
  c8:	bfb9                	j	26 <syscall_name+0x26>
                case SYS_write: return "write";
  ca:	00001517          	auipc	a0,0x1
  ce:	9a650513          	addi	a0,a0,-1626 # a70 <malloc+0x186>
  d2:	bf91                	j	26 <syscall_name+0x26>
                case SYS_mknod: return "mknod";
  d4:	00001517          	auipc	a0,0x1
  d8:	9a450513          	addi	a0,a0,-1628 # a78 <malloc+0x18e>
  dc:	b7a9                	j	26 <syscall_name+0x26>
                case SYS_unlink: return "unlink";
  de:	00001517          	auipc	a0,0x1
  e2:	9a250513          	addi	a0,a0,-1630 # a80 <malloc+0x196>
  e6:	b781                	j	26 <syscall_name+0x26>
                case SYS_link: return "link";
  e8:	00001517          	auipc	a0,0x1
  ec:	9a050513          	addi	a0,a0,-1632 # a88 <malloc+0x19e>
  f0:	bf1d                	j	26 <syscall_name+0x26>
                case SYS_mkdir: return "mkdir";
  f2:	00001517          	auipc	a0,0x1
  f6:	99e50513          	addi	a0,a0,-1634 # a90 <malloc+0x1a6>
  fa:	b735                	j	26 <syscall_name+0x26>
                case SYS_close: return "close";
  fc:	00001517          	auipc	a0,0x1
 100:	99c50513          	addi	a0,a0,-1636 # a98 <malloc+0x1ae>
 104:	b70d                	j	26 <syscall_name+0x26>
                case SYS_waitx: return "waitx";
 106:	00001517          	auipc	a0,0x1
 10a:	99a50513          	addi	a0,a0,-1638 # aa0 <malloc+0x1b6>
 10e:	bf21                	j	26 <syscall_name+0x26>
                case SYS_getsyscount: return "getsyscount";
 110:	00001517          	auipc	a0,0x1
 114:	99850513          	addi	a0,a0,-1640 # aa8 <malloc+0x1be>
 118:	b739                	j	26 <syscall_name+0x26>
                case SYS_fork: return "fork";
 11a:	00001517          	auipc	a0,0x1
 11e:	8d650513          	addi	a0,a0,-1834 # 9f0 <malloc+0x106>
 122:	b711                	j	26 <syscall_name+0x26>
            switch (i) {
 124:	00001517          	auipc	a0,0x1
 128:	8dc50513          	addi	a0,a0,-1828 # a00 <malloc+0x116>
 12c:	bded                	j	26 <syscall_name+0x26>

000000000000012e <main>:
int 
main(int argc,char *argv[]){
 12e:	7179                	addi	sp,sp,-48
 130:	f406                	sd	ra,40(sp)
 132:	f022                	sd	s0,32(sp)
 134:	1800                	addi	s0,sp,48
    
    if(argc<3){
 136:	4789                	li	a5,2
 138:	02a7c363          	blt	a5,a0,15e <main+0x30>
 13c:	ec26                	sd	s1,24(sp)
 13e:	e84a                	sd	s2,16(sp)
 140:	e44e                	sd	s3,8(sp)
        fprintf(2,"Usage: syscount <mask> command [args]\n");
 142:	00001597          	auipc	a1,0x1
 146:	97e58593          	addi	a1,a1,-1666 # ac0 <malloc+0x1d6>
 14a:	853e                	mv	a0,a5
 14c:	00000097          	auipc	ra,0x0
 150:	6b4080e7          	jalr	1716(ra) # 800 <fprintf>
        exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	35a080e7          	jalr	858(ra) # 4b0 <exit>
 15e:	ec26                	sd	s1,24(sp)
 160:	e84a                	sd	s2,16(sp)
 162:	e44e                	sd	s3,8(sp)
 164:	84ae                	mv	s1,a1

    }
    int mask = atoi(argv[1]);
 166:	6588                	ld	a0,8(a1)
 168:	00000097          	auipc	ra,0x0
 16c:	242080e7          	jalr	578(ra) # 3aa <atoi>
 170:	89aa                	mv	s3,a0
    int pid = fork();
 172:	00000097          	auipc	ra,0x0
 176:	336080e7          	jalr	822(ra) # 4a8 <fork>
 17a:	892a                	mv	s2,a0
    if(pid<0){
 17c:	00054f63          	bltz	a0,19a <main+0x6c>
        fprintf(2,"fork failed\n");
        exit(1);
    }
    if(pid==0){
 180:	e91d                	bnez	a0,1b6 <main+0x88>
        // child
        exec(argv[2],&argv[2]);
 182:	01048593          	addi	a1,s1,16
 186:	6888                	ld	a0,16(s1)
 188:	00000097          	auipc	ra,0x0
 18c:	360080e7          	jalr	864(ra) # 4e8 <exec>
        // fprintf(2,"exec %s failed\n",argv[2]);
        // i want to copy syscount array of child to syscount array of parent


        exit(1);
 190:	4505                	li	a0,1
 192:	00000097          	auipc	ra,0x0
 196:	31e080e7          	jalr	798(ra) # 4b0 <exit>
        fprintf(2,"fork failed\n");
 19a:	00001597          	auipc	a1,0x1
 19e:	94e58593          	addi	a1,a1,-1714 # ae8 <malloc+0x1fe>
 1a2:	4509                	li	a0,2
 1a4:	00000097          	auipc	ra,0x0
 1a8:	65c080e7          	jalr	1628(ra) # 800 <fprintf>
        exit(1);
 1ac:	4505                	li	a0,1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	302080e7          	jalr	770(ra) # 4b0 <exit>
    }
    else{
        // parent
        wait(0);
 1b6:	4501                	li	a0,0
 1b8:	00000097          	auipc	ra,0x0
 1bc:	300080e7          	jalr	768(ra) # 4b8 <wait>

        int count = getsyscount(mask);
 1c0:	854e                	mv	a0,s3
 1c2:	00000097          	auipc	ra,0x0
 1c6:	396080e7          	jalr	918(ra) # 558 <getsyscount>
 1ca:	84aa                	mv	s1,a0
        printf("PID %d called %s %d times.\n", pid, syscall_name(mask), count);
 1cc:	854e                	mv	a0,s3
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e32080e7          	jalr	-462(ra) # 0 <syscall_name>
 1d6:	862a                	mv	a2,a0
 1d8:	86a6                	mv	a3,s1
 1da:	85ca                	mv	a1,s2
 1dc:	00001517          	auipc	a0,0x1
 1e0:	91c50513          	addi	a0,a0,-1764 # af8 <malloc+0x20e>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	64a080e7          	jalr	1610(ra) # 82e <printf>
        exit(0);
 1ec:	4501                	li	a0,0
 1ee:	00000097          	auipc	ra,0x0
 1f2:	2c2080e7          	jalr	706(ra) # 4b0 <exit>

00000000000001f6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1fe:	00000097          	auipc	ra,0x0
 202:	f30080e7          	jalr	-208(ra) # 12e <main>
  exit(0);
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	2a8080e7          	jalr	680(ra) # 4b0 <exit>

0000000000000210 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 218:	87aa                	mv	a5,a0
 21a:	0585                	addi	a1,a1,1
 21c:	0785                	addi	a5,a5,1
 21e:	fff5c703          	lbu	a4,-1(a1)
 222:	fee78fa3          	sb	a4,-1(a5)
 226:	fb75                	bnez	a4,21a <strcpy+0xa>
    ;
  return os;
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cb91                	beqz	a5,250 <strcmp+0x20>
 23e:	0005c703          	lbu	a4,0(a1)
 242:	00f71763          	bne	a4,a5,250 <strcmp+0x20>
    p++, q++;
 246:	0505                	addi	a0,a0,1
 248:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbe5                	bnez	a5,23e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 250:	0005c503          	lbu	a0,0(a1)
}
 254:	40a7853b          	subw	a0,a5,a0
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret

0000000000000260 <strlen>:

uint
strlen(const char *s)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 268:	00054783          	lbu	a5,0(a0)
 26c:	cf99                	beqz	a5,28a <strlen+0x2a>
 26e:	0505                	addi	a0,a0,1
 270:	87aa                	mv	a5,a0
 272:	86be                	mv	a3,a5
 274:	0785                	addi	a5,a5,1
 276:	fff7c703          	lbu	a4,-1(a5)
 27a:	ff65                	bnez	a4,272 <strlen+0x12>
 27c:	40a6853b          	subw	a0,a3,a0
 280:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  for(n = 0; s[n]; n++)
 28a:	4501                	li	a0,0
 28c:	bfdd                	j	282 <strlen+0x22>

000000000000028e <memset>:

void*
memset(void *dst, int c, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ca19                	beqz	a2,2ac <memset+0x1e>
 298:	87aa                	mv	a5,a0
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a6:	0785                	addi	a5,a5,1
 2a8:	fee79de3          	bne	a5,a4,2a2 <memset+0x14>
  }
  return dst;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strchr>:

char*
strchr(const char *s, char c)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cf81                	beqz	a5,2d8 <strchr+0x24>
    if(*s == c)
 2c2:	00f58763          	beq	a1,a5,2d0 <strchr+0x1c>
  for(; *s; s++)
 2c6:	0505                	addi	a0,a0,1
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	fbfd                	bnez	a5,2c2 <strchr+0xe>
      return (char*)s;
  return 0;
 2ce:	4501                	li	a0,0
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  return 0;
 2d8:	4501                	li	a0,0
 2da:	bfdd                	j	2d0 <strchr+0x1c>

00000000000002dc <gets>:

char*
gets(char *buf, int max)
{
 2dc:	7159                	addi	sp,sp,-112
 2de:	f486                	sd	ra,104(sp)
 2e0:	f0a2                	sd	s0,96(sp)
 2e2:	eca6                	sd	s1,88(sp)
 2e4:	e8ca                	sd	s2,80(sp)
 2e6:	e4ce                	sd	s3,72(sp)
 2e8:	e0d2                	sd	s4,64(sp)
 2ea:	fc56                	sd	s5,56(sp)
 2ec:	f85a                	sd	s6,48(sp)
 2ee:	f45e                	sd	s7,40(sp)
 2f0:	f062                	sd	s8,32(sp)
 2f2:	ec66                	sd	s9,24(sp)
 2f4:	e86a                	sd	s10,16(sp)
 2f6:	1880                	addi	s0,sp,112
 2f8:	8caa                	mv	s9,a0
 2fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fc:	892a                	mv	s2,a0
 2fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
 300:	f9f40b13          	addi	s6,s0,-97
 304:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 306:	4ba9                	li	s7,10
 308:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 30a:	8d26                	mv	s10,s1
 30c:	0014899b          	addiw	s3,s1,1
 310:	84ce                	mv	s1,s3
 312:	0349d763          	bge	s3,s4,340 <gets+0x64>
    cc = read(0, &c, 1);
 316:	8656                	mv	a2,s5
 318:	85da                	mv	a1,s6
 31a:	4501                	li	a0,0
 31c:	00000097          	auipc	ra,0x0
 320:	1ac080e7          	jalr	428(ra) # 4c8 <read>
    if(cc < 1)
 324:	00a05e63          	blez	a0,340 <gets+0x64>
    buf[i++] = c;
 328:	f9f44783          	lbu	a5,-97(s0)
 32c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 330:	01778763          	beq	a5,s7,33e <gets+0x62>
 334:	0905                	addi	s2,s2,1
 336:	fd879ae3          	bne	a5,s8,30a <gets+0x2e>
    buf[i++] = c;
 33a:	8d4e                	mv	s10,s3
 33c:	a011                	j	340 <gets+0x64>
 33e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 340:	9d66                	add	s10,s10,s9
 342:	000d0023          	sb	zero,0(s10)
  return buf;
}
 346:	8566                	mv	a0,s9
 348:	70a6                	ld	ra,104(sp)
 34a:	7406                	ld	s0,96(sp)
 34c:	64e6                	ld	s1,88(sp)
 34e:	6946                	ld	s2,80(sp)
 350:	69a6                	ld	s3,72(sp)
 352:	6a06                	ld	s4,64(sp)
 354:	7ae2                	ld	s5,56(sp)
 356:	7b42                	ld	s6,48(sp)
 358:	7ba2                	ld	s7,40(sp)
 35a:	7c02                	ld	s8,32(sp)
 35c:	6ce2                	ld	s9,24(sp)
 35e:	6d42                	ld	s10,16(sp)
 360:	6165                	addi	sp,sp,112
 362:	8082                	ret

0000000000000364 <stat>:

int
stat(const char *n, struct stat *st)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	e04a                	sd	s2,0(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 370:	4581                	li	a1,0
 372:	00000097          	auipc	ra,0x0
 376:	17e080e7          	jalr	382(ra) # 4f0 <open>
  if(fd < 0)
 37a:	02054663          	bltz	a0,3a6 <stat+0x42>
 37e:	e426                	sd	s1,8(sp)
 380:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 382:	85ca                	mv	a1,s2
 384:	00000097          	auipc	ra,0x0
 388:	184080e7          	jalr	388(ra) # 508 <fstat>
 38c:	892a                	mv	s2,a0
  close(fd);
 38e:	8526                	mv	a0,s1
 390:	00000097          	auipc	ra,0x0
 394:	148080e7          	jalr	328(ra) # 4d8 <close>
  return r;
 398:	64a2                	ld	s1,8(sp)
}
 39a:	854a                	mv	a0,s2
 39c:	60e2                	ld	ra,24(sp)
 39e:	6442                	ld	s0,16(sp)
 3a0:	6902                	ld	s2,0(sp)
 3a2:	6105                	addi	sp,sp,32
 3a4:	8082                	ret
    return -1;
 3a6:	597d                	li	s2,-1
 3a8:	bfcd                	j	39a <stat+0x36>

00000000000003aa <atoi>:

int
atoi(const char *s)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b2:	00054683          	lbu	a3,0(a0)
 3b6:	fd06879b          	addiw	a5,a3,-48
 3ba:	0ff7f793          	zext.b	a5,a5
 3be:	4625                	li	a2,9
 3c0:	02f66963          	bltu	a2,a5,3f2 <atoi+0x48>
 3c4:	872a                	mv	a4,a0
  n = 0;
 3c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3c8:	0705                	addi	a4,a4,1
 3ca:	0025179b          	slliw	a5,a0,0x2
 3ce:	9fa9                	addw	a5,a5,a0
 3d0:	0017979b          	slliw	a5,a5,0x1
 3d4:	9fb5                	addw	a5,a5,a3
 3d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3da:	00074683          	lbu	a3,0(a4)
 3de:	fd06879b          	addiw	a5,a3,-48
 3e2:	0ff7f793          	zext.b	a5,a5
 3e6:	fef671e3          	bgeu	a2,a5,3c8 <atoi+0x1e>
  return n;
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  n = 0;
 3f2:	4501                	li	a0,0
 3f4:	bfdd                	j	3ea <atoi+0x40>

00000000000003f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3fe:	02b57563          	bgeu	a0,a1,428 <memmove+0x32>
    while(n-- > 0)
 402:	00c05f63          	blez	a2,420 <memmove+0x2a>
 406:	1602                	slli	a2,a2,0x20
 408:	9201                	srli	a2,a2,0x20
 40a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40e:	872a                	mv	a4,a0
      *dst++ = *src++;
 410:	0585                	addi	a1,a1,1
 412:	0705                	addi	a4,a4,1
 414:	fff5c683          	lbu	a3,-1(a1)
 418:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41c:	fee79ae3          	bne	a5,a4,410 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 420:	60a2                	ld	ra,8(sp)
 422:	6402                	ld	s0,0(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
    dst += n;
 428:	00c50733          	add	a4,a0,a2
    src += n;
 42c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 42e:	fec059e3          	blez	a2,420 <memmove+0x2a>
 432:	fff6079b          	addiw	a5,a2,-1
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	fff7c793          	not	a5,a5
 43e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 440:	15fd                	addi	a1,a1,-1
 442:	177d                	addi	a4,a4,-1
 444:	0005c683          	lbu	a3,0(a1)
 448:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 44c:	fef71ae3          	bne	a4,a5,440 <memmove+0x4a>
 450:	bfc1                	j	420 <memmove+0x2a>

0000000000000452 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 45a:	ca0d                	beqz	a2,48c <memcmp+0x3a>
 45c:	fff6069b          	addiw	a3,a2,-1
 460:	1682                	slli	a3,a3,0x20
 462:	9281                	srli	a3,a3,0x20
 464:	0685                	addi	a3,a3,1
 466:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 468:	00054783          	lbu	a5,0(a0)
 46c:	0005c703          	lbu	a4,0(a1)
 470:	00e79863          	bne	a5,a4,480 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 474:	0505                	addi	a0,a0,1
    p2++;
 476:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 478:	fed518e3          	bne	a0,a3,468 <memcmp+0x16>
  }
  return 0;
 47c:	4501                	li	a0,0
 47e:	a019                	j	484 <memcmp+0x32>
      return *p1 - *p2;
 480:	40e7853b          	subw	a0,a5,a4
}
 484:	60a2                	ld	ra,8(sp)
 486:	6402                	ld	s0,0(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  return 0;
 48c:	4501                	li	a0,0
 48e:	bfdd                	j	484 <memcmp+0x32>

0000000000000490 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 498:	00000097          	auipc	ra,0x0
 49c:	f5e080e7          	jalr	-162(ra) # 3f6 <memmove>
}
 4a0:	60a2                	ld	ra,8(sp)
 4a2:	6402                	ld	s0,0(sp)
 4a4:	0141                	addi	sp,sp,16
 4a6:	8082                	ret

00000000000004a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a8:	4885                	li	a7,1
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b0:	4889                	li	a7,2
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b8:	488d                	li	a7,3
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c0:	4891                	li	a7,4
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <read>:
.global read
read:
 li a7, SYS_read
 4c8:	4895                	li	a7,5
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <write>:
.global write
write:
 li a7, SYS_write
 4d0:	48c1                	li	a7,16
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <close>:
.global close
close:
 li a7, SYS_close
 4d8:	48d5                	li	a7,21
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e0:	4899                	li	a7,6
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e8:	489d                	li	a7,7
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <open>:
.global open
open:
 li a7, SYS_open
 4f0:	48bd                	li	a7,15
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f8:	48c5                	li	a7,17
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 500:	48c9                	li	a7,18
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 508:	48a1                	li	a7,8
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <link>:
.global link
link:
 li a7, SYS_link
 510:	48cd                	li	a7,19
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 518:	48d1                	li	a7,20
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 520:	48a5                	li	a7,9
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <dup>:
.global dup
dup:
 li a7, SYS_dup
 528:	48a9                	li	a7,10
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 530:	48ad                	li	a7,11
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 538:	48b1                	li	a7,12
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 540:	48b5                	li	a7,13
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 548:	48b9                	li	a7,14
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 550:	48d9                	li	a7,22
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 558:	48dd                	li	a7,23
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 560:	48e1                	li	a7,24
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 568:	48e5                	li	a7,25
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 570:	48e9                	li	a7,26
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	00000097          	auipc	ra,0x0
 58e:	f46080e7          	jalr	-186(ra) # 4d0 <write>
}
 592:	60e2                	ld	ra,24(sp)
 594:	6442                	ld	s0,16(sp)
 596:	6105                	addi	sp,sp,32
 598:	8082                	ret

000000000000059a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59a:	7139                	addi	sp,sp,-64
 59c:	fc06                	sd	ra,56(sp)
 59e:	f822                	sd	s0,48(sp)
 5a0:	f426                	sd	s1,40(sp)
 5a2:	f04a                	sd	s2,32(sp)
 5a4:	ec4e                	sd	s3,24(sp)
 5a6:	0080                	addi	s0,sp,64
 5a8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5aa:	c299                	beqz	a3,5b0 <printint+0x16>
 5ac:	0805c063          	bltz	a1,62c <printint+0x92>
  neg = 0;
 5b0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5b2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 5b6:	869a                	mv	a3,t1
  i = 0;
 5b8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ba:	00000817          	auipc	a6,0x0
 5be:	61e80813          	addi	a6,a6,1566 # bd8 <digits>
 5c2:	88be                	mv	a7,a5
 5c4:	0017851b          	addiw	a0,a5,1
 5c8:	87aa                	mv	a5,a0
 5ca:	02c5f73b          	remuw	a4,a1,a2
 5ce:	1702                	slli	a4,a4,0x20
 5d0:	9301                	srli	a4,a4,0x20
 5d2:	9742                	add	a4,a4,a6
 5d4:	00074703          	lbu	a4,0(a4)
 5d8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5dc:	872e                	mv	a4,a1
 5de:	02c5d5bb          	divuw	a1,a1,a2
 5e2:	0685                	addi	a3,a3,1
 5e4:	fcc77fe3          	bgeu	a4,a2,5c2 <printint+0x28>
  if(neg)
 5e8:	000e0c63          	beqz	t3,600 <printint+0x66>
    buf[i++] = '-';
 5ec:	fd050793          	addi	a5,a0,-48
 5f0:	00878533          	add	a0,a5,s0
 5f4:	02d00793          	li	a5,45
 5f8:	fef50823          	sb	a5,-16(a0)
 5fc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 600:	fff7899b          	addiw	s3,a5,-1
 604:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 608:	fff4c583          	lbu	a1,-1(s1)
 60c:	854a                	mv	a0,s2
 60e:	00000097          	auipc	ra,0x0
 612:	f6a080e7          	jalr	-150(ra) # 578 <putc>
  while(--i >= 0)
 616:	39fd                	addiw	s3,s3,-1
 618:	14fd                	addi	s1,s1,-1
 61a:	fe09d7e3          	bgez	s3,608 <printint+0x6e>
}
 61e:	70e2                	ld	ra,56(sp)
 620:	7442                	ld	s0,48(sp)
 622:	74a2                	ld	s1,40(sp)
 624:	7902                	ld	s2,32(sp)
 626:	69e2                	ld	s3,24(sp)
 628:	6121                	addi	sp,sp,64
 62a:	8082                	ret
    x = -xx;
 62c:	40b005bb          	negw	a1,a1
    neg = 1;
 630:	4e05                	li	t3,1
    x = -xx;
 632:	b741                	j	5b2 <printint+0x18>

0000000000000634 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 634:	715d                	addi	sp,sp,-80
 636:	e486                	sd	ra,72(sp)
 638:	e0a2                	sd	s0,64(sp)
 63a:	f84a                	sd	s2,48(sp)
 63c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63e:	0005c903          	lbu	s2,0(a1)
 642:	1a090a63          	beqz	s2,7f6 <vprintf+0x1c2>
 646:	fc26                	sd	s1,56(sp)
 648:	f44e                	sd	s3,40(sp)
 64a:	f052                	sd	s4,32(sp)
 64c:	ec56                	sd	s5,24(sp)
 64e:	e85a                	sd	s6,16(sp)
 650:	e45e                	sd	s7,8(sp)
 652:	8aaa                	mv	s5,a0
 654:	8bb2                	mv	s7,a2
 656:	00158493          	addi	s1,a1,1
  state = 0;
 65a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65c:	02500a13          	li	s4,37
 660:	4b55                	li	s6,21
 662:	a839                	j	680 <vprintf+0x4c>
        putc(fd, c);
 664:	85ca                	mv	a1,s2
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	f10080e7          	jalr	-240(ra) # 578 <putc>
 670:	a019                	j	676 <vprintf+0x42>
    } else if(state == '%'){
 672:	01498d63          	beq	s3,s4,68c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 676:	0485                	addi	s1,s1,1
 678:	fff4c903          	lbu	s2,-1(s1)
 67c:	16090763          	beqz	s2,7ea <vprintf+0x1b6>
    if(state == 0){
 680:	fe0999e3          	bnez	s3,672 <vprintf+0x3e>
      if(c == '%'){
 684:	ff4910e3          	bne	s2,s4,664 <vprintf+0x30>
        state = '%';
 688:	89d2                	mv	s3,s4
 68a:	b7f5                	j	676 <vprintf+0x42>
      if(c == 'd'){
 68c:	13490463          	beq	s2,s4,7b4 <vprintf+0x180>
 690:	f9d9079b          	addiw	a5,s2,-99
 694:	0ff7f793          	zext.b	a5,a5
 698:	12fb6763          	bltu	s6,a5,7c6 <vprintf+0x192>
 69c:	f9d9079b          	addiw	a5,s2,-99
 6a0:	0ff7f713          	zext.b	a4,a5
 6a4:	12eb6163          	bltu	s6,a4,7c6 <vprintf+0x192>
 6a8:	00271793          	slli	a5,a4,0x2
 6ac:	00000717          	auipc	a4,0x0
 6b0:	4d470713          	addi	a4,a4,1236 # b80 <malloc+0x296>
 6b4:	97ba                	add	a5,a5,a4
 6b6:	439c                	lw	a5,0(a5)
 6b8:	97ba                	add	a5,a5,a4
 6ba:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4685                	li	a3,1
 6c2:	4629                	li	a2,10
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	ed0080e7          	jalr	-304(ra) # 59a <printint>
 6d2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b745                	j	676 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	eb4080e7          	jalr	-332(ra) # 59a <printint>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b751                	j	676 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4641                	li	a2,16
 6fc:	000ba583          	lw	a1,0(s7)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e98080e7          	jalr	-360(ra) # 59a <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b7a5                	j	676 <vprintf+0x42>
 710:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 712:	008b8c13          	addi	s8,s7,8
 716:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71a:	03000593          	li	a1,48
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	e58080e7          	jalr	-424(ra) # 578 <putc>
  putc(fd, 'x');
 728:	07800593          	li	a1,120
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	e4a080e7          	jalr	-438(ra) # 578 <putc>
 736:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 738:	00000b97          	auipc	s7,0x0
 73c:	4a0b8b93          	addi	s7,s7,1184 # bd8 <digits>
 740:	03c9d793          	srli	a5,s3,0x3c
 744:	97de                	add	a5,a5,s7
 746:	0007c583          	lbu	a1,0(a5)
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e2c080e7          	jalr	-468(ra) # 578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 754:	0992                	slli	s3,s3,0x4
 756:	397d                	addiw	s2,s2,-1
 758:	fe0914e3          	bnez	s2,740 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 75c:	8be2                	mv	s7,s8
      state = 0;
 75e:	4981                	li	s3,0
 760:	6c02                	ld	s8,0(sp)
 762:	bf11                	j	676 <vprintf+0x42>
        s = va_arg(ap, char*);
 764:	008b8993          	addi	s3,s7,8
 768:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 76c:	02090163          	beqz	s2,78e <vprintf+0x15a>
        while(*s != 0){
 770:	00094583          	lbu	a1,0(s2)
 774:	c9a5                	beqz	a1,7e4 <vprintf+0x1b0>
          putc(fd, *s);
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e00080e7          	jalr	-512(ra) # 578 <putc>
          s++;
 780:	0905                	addi	s2,s2,1
        while(*s != 0){
 782:	00094583          	lbu	a1,0(s2)
 786:	f9e5                	bnez	a1,776 <vprintf+0x142>
        s = va_arg(ap, char*);
 788:	8bce                	mv	s7,s3
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b5ed                	j	676 <vprintf+0x42>
          s = "(null)";
 78e:	00000917          	auipc	s2,0x0
 792:	38a90913          	addi	s2,s2,906 # b18 <malloc+0x22e>
        while(*s != 0){
 796:	02800593          	li	a1,40
 79a:	bff1                	j	776 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 79c:	008b8913          	addi	s2,s7,8
 7a0:	000bc583          	lbu	a1,0(s7)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	dd2080e7          	jalr	-558(ra) # 578 <putc>
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b5d1                	j	676 <vprintf+0x42>
        putc(fd, c);
 7b4:	02500593          	li	a1,37
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	dbe080e7          	jalr	-578(ra) # 578 <putc>
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bd4d                	j	676 <vprintf+0x42>
        putc(fd, '%');
 7c6:	02500593          	li	a1,37
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	dac080e7          	jalr	-596(ra) # 578 <putc>
        putc(fd, c);
 7d4:	85ca                	mv	a1,s2
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	da0080e7          	jalr	-608(ra) # 578 <putc>
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bd51                	j	676 <vprintf+0x42>
        s = va_arg(ap, char*);
 7e4:	8bce                	mv	s7,s3
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b579                	j	676 <vprintf+0x42>
 7ea:	74e2                	ld	s1,56(sp)
 7ec:	79a2                	ld	s3,40(sp)
 7ee:	7a02                	ld	s4,32(sp)
 7f0:	6ae2                	ld	s5,24(sp)
 7f2:	6b42                	ld	s6,16(sp)
 7f4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7f6:	60a6                	ld	ra,72(sp)
 7f8:	6406                	ld	s0,64(sp)
 7fa:	7942                	ld	s2,48(sp)
 7fc:	6161                	addi	sp,sp,80
 7fe:	8082                	ret

0000000000000800 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 800:	715d                	addi	sp,sp,-80
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	addi	s0,sp,32
 808:	e010                	sd	a2,0(s0)
 80a:	e414                	sd	a3,8(s0)
 80c:	e818                	sd	a4,16(s0)
 80e:	ec1c                	sd	a5,24(s0)
 810:	03043023          	sd	a6,32(s0)
 814:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	8622                	mv	a2,s0
 81a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81e:	00000097          	auipc	ra,0x0
 822:	e16080e7          	jalr	-490(ra) # 634 <vprintf>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6161                	addi	sp,sp,80
 82c:	8082                	ret

000000000000082e <printf>:

void
printf(const char *fmt, ...)
{
 82e:	711d                	addi	sp,sp,-96
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e40c                	sd	a1,8(s0)
 838:	e810                	sd	a2,16(s0)
 83a:	ec14                	sd	a3,24(s0)
 83c:	f018                	sd	a4,32(s0)
 83e:	f41c                	sd	a5,40(s0)
 840:	03043823          	sd	a6,48(s0)
 844:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	00840613          	addi	a2,s0,8
 84c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 850:	85aa                	mv	a1,a0
 852:	4505                	li	a0,1
 854:	00000097          	auipc	ra,0x0
 858:	de0080e7          	jalr	-544(ra) # 634 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6125                	addi	sp,sp,96
 862:	8082                	ret

0000000000000864 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 864:	1141                	addi	sp,sp,-16
 866:	e406                	sd	ra,8(sp)
 868:	e022                	sd	s0,0(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	7907b783          	ld	a5,1936(a5) # 1000 <freep>
 878:	a02d                	j	8a2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87a:	4618                	lw	a4,8(a2)
 87c:	9f2d                	addw	a4,a4,a1
 87e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6310                	ld	a2,0(a4)
 886:	a83d                	j	8c4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 888:	ff852703          	lw	a4,-8(a0)
 88c:	9f31                	addw	a4,a4,a2
 88e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 890:	ff053683          	ld	a3,-16(a0)
 894:	a091                	j	8d8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 896:	6398                	ld	a4,0(a5)
 898:	00e7e463          	bltu	a5,a4,8a0 <free+0x3c>
 89c:	00e6ea63          	bltu	a3,a4,8b0 <free+0x4c>
{
 8a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	fed7fae3          	bgeu	a5,a3,896 <free+0x32>
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e6e463          	bltu	a3,a4,8b0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	fee7eae3          	bltu	a5,a4,8a0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8b0:	ff852583          	lw	a1,-8(a0)
 8b4:	6390                	ld	a2,0(a5)
 8b6:	02059813          	slli	a6,a1,0x20
 8ba:	01c85713          	srli	a4,a6,0x1c
 8be:	9736                	add	a4,a4,a3
 8c0:	fae60de3          	beq	a2,a4,87a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c8:	4790                	lw	a2,8(a5)
 8ca:	02061593          	slli	a1,a2,0x20
 8ce:	01c5d713          	srli	a4,a1,0x1c
 8d2:	973e                	add	a4,a4,a5
 8d4:	fae68ae3          	beq	a3,a4,888 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
}
 8e2:	60a2                	ld	ra,8(sp)
 8e4:	6402                	ld	s0,0(sp)
 8e6:	0141                	addi	sp,sp,16
 8e8:	8082                	ret

00000000000008ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ea:	7139                	addi	sp,sp,-64
 8ec:	fc06                	sd	ra,56(sp)
 8ee:	f822                	sd	s0,48(sp)
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	ec4e                	sd	s3,24(sp)
 8f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	02051993          	slli	s3,a0,0x20
 8fa:	0209d993          	srli	s3,s3,0x20
 8fe:	09bd                	addi	s3,s3,15
 900:	0049d993          	srli	s3,s3,0x4
 904:	2985                	addiw	s3,s3,1
 906:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 908:	00000517          	auipc	a0,0x0
 90c:	6f853503          	ld	a0,1784(a0) # 1000 <freep>
 910:	c905                	beqz	a0,940 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 912:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 914:	4798                	lw	a4,8(a5)
 916:	09377a63          	bgeu	a4,s3,9aa <malloc+0xc0>
 91a:	f426                	sd	s1,40(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 922:	8a4e                	mv	s4,s3
 924:	6705                	lui	a4,0x1
 926:	00e9f363          	bgeu	s3,a4,92c <malloc+0x42>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 934:	00000497          	auipc	s1,0x0
 938:	6cc48493          	addi	s1,s1,1740 # 1000 <freep>
  if(p == (char*)-1)
 93c:	5afd                	li	s5,-1
 93e:	a089                	j	980 <malloc+0x96>
 940:	f426                	sd	s1,40(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 948:	00000797          	auipc	a5,0x0
 94c:	6c878793          	addi	a5,a5,1736 # 1010 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6af73823          	sd	a5,1712(a4) # 1000 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95e:	b7d1                	j	922 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	a8b9                	j	9c2 <malloc+0xd8>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	00000097          	auipc	ra,0x0
 970:	ef8080e7          	jalr	-264(ra) # 864 <free>
  return freep;
 974:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 976:	c135                	beqz	a0,9da <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 978:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97a:	4798                	lw	a4,8(a5)
 97c:	03277363          	bgeu	a4,s2,9a2 <malloc+0xb8>
    if(p == freep)
 980:	6098                	ld	a4,0(s1)
 982:	853e                	mv	a0,a5
 984:	fef71ae3          	bne	a4,a5,978 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 988:	8552                	mv	a0,s4
 98a:	00000097          	auipc	ra,0x0
 98e:	bae080e7          	jalr	-1106(ra) # 538 <sbrk>
  if(p == (char*)-1)
 992:	fd551ae3          	bne	a0,s5,966 <malloc+0x7c>
        return 0;
 996:	4501                	li	a0,0
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	a03d                	j	9ce <malloc+0xe4>
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9aa:	fae90be3          	beq	s2,a4,960 <malloc+0x76>
        p->s.size -= nunits;
 9ae:	4137073b          	subw	a4,a4,s3
 9b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b4:	02071693          	slli	a3,a4,0x20
 9b8:	01c6d713          	srli	a4,a3,0x1c
 9bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62a73f23          	sd	a0,1598(a4) # 1000 <freep>
      return (void*)(p + 1);
 9ca:	01078513          	addi	a0,a5,16
  }
}
 9ce:	70e2                	ld	ra,56(sp)
 9d0:	7442                	ld	s0,48(sp)
 9d2:	7902                	ld	s2,32(sp)
 9d4:	69e2                	ld	s3,24(sp)
 9d6:	6121                	addi	sp,sp,64
 9d8:	8082                	ret
 9da:	74a2                	ld	s1,40(sp)
 9dc:	6a42                	ld	s4,16(sp)
 9de:	6aa2                	ld	s5,8(sp)
 9e0:	6b02                	ld	s6,0(sp)
 9e2:	b7f5                	j	9ce <malloc+0xe4>
