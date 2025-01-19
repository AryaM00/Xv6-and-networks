
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	00000097          	auipc	ra,0x0
      a2:	f62080e7          	jalr	-158(ra) # 0 <do_rand>
}
      a6:	60a2                	ld	ra,8(sp)
      a8:	6402                	ld	s0,0(sp)
      aa:	0141                	addi	sp,sp,16
      ac:	8082                	ret

00000000000000ae <go>:

void
go(int which_child)
{
      ae:	7171                	addi	sp,sp,-176
      b0:	f506                	sd	ra,168(sp)
      b2:	f122                	sd	s0,160(sp)
      b4:	ed26                	sd	s1,152(sp)
      b6:	1900                	addi	s0,sp,176
      b8:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      ba:	4501                	li	a0,0
      bc:	00001097          	auipc	ra,0x1
      c0:	eda080e7          	jalr	-294(ra) # f96 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00001517          	auipc	a0,0x1
      cc:	38850513          	addi	a0,a0,904 # 1450 <malloc+0x108>
      d0:	00001097          	auipc	ra,0x1
      d4:	ea6080e7          	jalr	-346(ra) # f76 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	37850513          	addi	a0,a0,888 # 1450 <malloc+0x108>
      e0:	00001097          	auipc	ra,0x1
      e4:	e9e080e7          	jalr	-354(ra) # f7e <chdir>
      e8:	c905                	beqz	a0,118 <go+0x6a>
      ea:	e94a                	sd	s2,144(sp)
      ec:	e54e                	sd	s3,136(sp)
      ee:	e152                	sd	s4,128(sp)
      f0:	fcd6                	sd	s5,120(sp)
      f2:	f8da                	sd	s6,112(sp)
      f4:	f4de                	sd	s7,104(sp)
      f6:	f0e2                	sd	s8,96(sp)
      f8:	ece6                	sd	s9,88(sp)
      fa:	e8ea                	sd	s10,80(sp)
      fc:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      fe:	00001517          	auipc	a0,0x1
     102:	35a50513          	addi	a0,a0,858 # 1458 <malloc+0x110>
     106:	00001097          	auipc	ra,0x1
     10a:	186080e7          	jalr	390(ra) # 128c <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	dfe080e7          	jalr	-514(ra) # f0e <exit>
     118:	e94a                	sd	s2,144(sp)
     11a:	e54e                	sd	s3,136(sp)
     11c:	e152                	sd	s4,128(sp)
     11e:	fcd6                	sd	s5,120(sp)
     120:	f8da                	sd	s6,112(sp)
     122:	f4de                	sd	s7,104(sp)
     124:	f0e2                	sd	s8,96(sp)
     126:	ece6                	sd	s9,88(sp)
     128:	e8ea                	sd	s10,80(sp)
     12a:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     12c:	00001517          	auipc	a0,0x1
     130:	35450513          	addi	a0,a0,852 # 1480 <malloc+0x138>
     134:	00001097          	auipc	ra,0x1
     138:	e4a080e7          	jalr	-438(ra) # f7e <chdir>
     13c:	00001c17          	auipc	s8,0x1
     140:	354c0c13          	addi	s8,s8,852 # 1490 <malloc+0x148>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00001c17          	auipc	s8,0x1
     14a:	342c0c13          	addi	s8,s8,834 # 1488 <malloc+0x140>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	e353f7b7          	lui	a5,0xe353f
     156:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     15a:	20c4a9b7          	lui	s3,0x20c4a
     15e:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     162:	1982                	slli	s3,s3,0x20
     164:	99be                	add	s3,s3,a5
     166:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     16a:	4b85                	li	s7,1
    int what = rand() % 23;
     16c:	b2164a37          	lui	s4,0xb2164
     170:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     174:	4ad9                	li	s5,22
     176:	00001917          	auipc	s2,0x1
     17a:	5ea90913          	addi	s2,s2,1514 # 1760 <malloc+0x418>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     17e:	f6840d93          	addi	s11,s0,-152
     182:	a839                	j	1a0 <go+0xf2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     184:	20200593          	li	a1,514
     188:	00001517          	auipc	a0,0x1
     18c:	31050513          	addi	a0,a0,784 # 1498 <malloc+0x150>
     190:	00001097          	auipc	ra,0x1
     194:	dbe080e7          	jalr	-578(ra) # f4e <open>
     198:	00001097          	auipc	ra,0x1
     19c:	d9e080e7          	jalr	-610(ra) # f36 <close>
    iters++;
     1a0:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a2:	0024d793          	srli	a5,s1,0x2
     1a6:	0337b7b3          	mulhu	a5,a5,s3
     1aa:	8391                	srli	a5,a5,0x4
     1ac:	036787b3          	mul	a5,a5,s6
     1b0:	00f49963          	bne	s1,a5,1c2 <go+0x114>
      write(1, which_child?"B":"A", 1);
     1b4:	865e                	mv	a2,s7
     1b6:	85e2                	mv	a1,s8
     1b8:	855e                	mv	a0,s7
     1ba:	00001097          	auipc	ra,0x1
     1be:	d74080e7          	jalr	-652(ra) # f2e <write>
    int what = rand() % 23;
     1c2:	00000097          	auipc	ra,0x0
     1c6:	ecc080e7          	jalr	-308(ra) # 8e <rand>
     1ca:	034507b3          	mul	a5,a0,s4
     1ce:	9381                	srli	a5,a5,0x20
     1d0:	9fa9                	addw	a5,a5,a0
     1d2:	4047d79b          	sraiw	a5,a5,0x4
     1d6:	41f5571b          	sraiw	a4,a0,0x1f
     1da:	9f99                	subw	a5,a5,a4
     1dc:	0017971b          	slliw	a4,a5,0x1
     1e0:	9f3d                	addw	a4,a4,a5
     1e2:	0037171b          	slliw	a4,a4,0x3
     1e6:	40f707bb          	subw	a5,a4,a5
     1ea:	9d1d                	subw	a0,a0,a5
     1ec:	faaaeae3          	bltu	s5,a0,1a0 <go+0xf2>
     1f0:	02051793          	slli	a5,a0,0x20
     1f4:	01e7d513          	srli	a0,a5,0x1e
     1f8:	954a                	add	a0,a0,s2
     1fa:	411c                	lw	a5,0(a0)
     1fc:	97ca                	add	a5,a5,s2
     1fe:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     200:	20200593          	li	a1,514
     204:	00001517          	auipc	a0,0x1
     208:	2a450513          	addi	a0,a0,676 # 14a8 <malloc+0x160>
     20c:	00001097          	auipc	ra,0x1
     210:	d42080e7          	jalr	-702(ra) # f4e <open>
     214:	00001097          	auipc	ra,0x1
     218:	d22080e7          	jalr	-734(ra) # f36 <close>
     21c:	b751                	j	1a0 <go+0xf2>
      unlink("grindir/../a");
     21e:	00001517          	auipc	a0,0x1
     222:	27a50513          	addi	a0,a0,634 # 1498 <malloc+0x150>
     226:	00001097          	auipc	ra,0x1
     22a:	d38080e7          	jalr	-712(ra) # f5e <unlink>
     22e:	bf8d                	j	1a0 <go+0xf2>
      if(chdir("grindir") != 0){
     230:	00001517          	auipc	a0,0x1
     234:	22050513          	addi	a0,a0,544 # 1450 <malloc+0x108>
     238:	00001097          	auipc	ra,0x1
     23c:	d46080e7          	jalr	-698(ra) # f7e <chdir>
     240:	e115                	bnez	a0,264 <go+0x1b6>
      unlink("../b");
     242:	00001517          	auipc	a0,0x1
     246:	27e50513          	addi	a0,a0,638 # 14c0 <malloc+0x178>
     24a:	00001097          	auipc	ra,0x1
     24e:	d14080e7          	jalr	-748(ra) # f5e <unlink>
      chdir("/");
     252:	00001517          	auipc	a0,0x1
     256:	22e50513          	addi	a0,a0,558 # 1480 <malloc+0x138>
     25a:	00001097          	auipc	ra,0x1
     25e:	d24080e7          	jalr	-732(ra) # f7e <chdir>
     262:	bf3d                	j	1a0 <go+0xf2>
        printf("grind: chdir grindir failed\n");
     264:	00001517          	auipc	a0,0x1
     268:	1f450513          	addi	a0,a0,500 # 1458 <malloc+0x110>
     26c:	00001097          	auipc	ra,0x1
     270:	020080e7          	jalr	32(ra) # 128c <printf>
        exit(1);
     274:	4505                	li	a0,1
     276:	00001097          	auipc	ra,0x1
     27a:	c98080e7          	jalr	-872(ra) # f0e <exit>
      close(fd);
     27e:	8566                	mv	a0,s9
     280:	00001097          	auipc	ra,0x1
     284:	cb6080e7          	jalr	-842(ra) # f36 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     288:	20200593          	li	a1,514
     28c:	00001517          	auipc	a0,0x1
     290:	23c50513          	addi	a0,a0,572 # 14c8 <malloc+0x180>
     294:	00001097          	auipc	ra,0x1
     298:	cba080e7          	jalr	-838(ra) # f4e <open>
     29c:	8caa                	mv	s9,a0
     29e:	b709                	j	1a0 <go+0xf2>
      close(fd);
     2a0:	8566                	mv	a0,s9
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c94080e7          	jalr	-876(ra) # f36 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2aa:	20200593          	li	a1,514
     2ae:	00001517          	auipc	a0,0x1
     2b2:	22a50513          	addi	a0,a0,554 # 14d8 <malloc+0x190>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	c98080e7          	jalr	-872(ra) # f4e <open>
     2be:	8caa                	mv	s9,a0
     2c0:	b5c5                	j	1a0 <go+0xf2>
      write(fd, buf, sizeof(buf));
     2c2:	3e700613          	li	a2,999
     2c6:	00002597          	auipc	a1,0x2
     2ca:	d5a58593          	addi	a1,a1,-678 # 2020 <buf.0>
     2ce:	8566                	mv	a0,s9
     2d0:	00001097          	auipc	ra,0x1
     2d4:	c5e080e7          	jalr	-930(ra) # f2e <write>
     2d8:	b5e1                	j	1a0 <go+0xf2>
      read(fd, buf, sizeof(buf));
     2da:	3e700613          	li	a2,999
     2de:	00002597          	auipc	a1,0x2
     2e2:	d4258593          	addi	a1,a1,-702 # 2020 <buf.0>
     2e6:	8566                	mv	a0,s9
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c3e080e7          	jalr	-962(ra) # f26 <read>
     2f0:	bd45                	j	1a0 <go+0xf2>
      mkdir("grindir/../a");
     2f2:	00001517          	auipc	a0,0x1
     2f6:	1a650513          	addi	a0,a0,422 # 1498 <malloc+0x150>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	c7c080e7          	jalr	-900(ra) # f76 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     302:	20200593          	li	a1,514
     306:	00001517          	auipc	a0,0x1
     30a:	1ea50513          	addi	a0,a0,490 # 14f0 <malloc+0x1a8>
     30e:	00001097          	auipc	ra,0x1
     312:	c40080e7          	jalr	-960(ra) # f4e <open>
     316:	00001097          	auipc	ra,0x1
     31a:	c20080e7          	jalr	-992(ra) # f36 <close>
      unlink("a/a");
     31e:	00001517          	auipc	a0,0x1
     322:	1e250513          	addi	a0,a0,482 # 1500 <malloc+0x1b8>
     326:	00001097          	auipc	ra,0x1
     32a:	c38080e7          	jalr	-968(ra) # f5e <unlink>
     32e:	bd8d                	j	1a0 <go+0xf2>
      mkdir("/../b");
     330:	00001517          	auipc	a0,0x1
     334:	1d850513          	addi	a0,a0,472 # 1508 <malloc+0x1c0>
     338:	00001097          	auipc	ra,0x1
     33c:	c3e080e7          	jalr	-962(ra) # f76 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     340:	20200593          	li	a1,514
     344:	00001517          	auipc	a0,0x1
     348:	1cc50513          	addi	a0,a0,460 # 1510 <malloc+0x1c8>
     34c:	00001097          	auipc	ra,0x1
     350:	c02080e7          	jalr	-1022(ra) # f4e <open>
     354:	00001097          	auipc	ra,0x1
     358:	be2080e7          	jalr	-1054(ra) # f36 <close>
      unlink("b/b");
     35c:	00001517          	auipc	a0,0x1
     360:	1c450513          	addi	a0,a0,452 # 1520 <malloc+0x1d8>
     364:	00001097          	auipc	ra,0x1
     368:	bfa080e7          	jalr	-1030(ra) # f5e <unlink>
     36c:	bd15                	j	1a0 <go+0xf2>
      unlink("b");
     36e:	00001517          	auipc	a0,0x1
     372:	1ba50513          	addi	a0,a0,442 # 1528 <malloc+0x1e0>
     376:	00001097          	auipc	ra,0x1
     37a:	be8080e7          	jalr	-1048(ra) # f5e <unlink>
      link("../grindir/./../a", "../b");
     37e:	00001597          	auipc	a1,0x1
     382:	14258593          	addi	a1,a1,322 # 14c0 <malloc+0x178>
     386:	00001517          	auipc	a0,0x1
     38a:	1aa50513          	addi	a0,a0,426 # 1530 <malloc+0x1e8>
     38e:	00001097          	auipc	ra,0x1
     392:	be0080e7          	jalr	-1056(ra) # f6e <link>
     396:	b529                	j	1a0 <go+0xf2>
      unlink("../grindir/../a");
     398:	00001517          	auipc	a0,0x1
     39c:	1b050513          	addi	a0,a0,432 # 1548 <malloc+0x200>
     3a0:	00001097          	auipc	ra,0x1
     3a4:	bbe080e7          	jalr	-1090(ra) # f5e <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	12058593          	addi	a1,a1,288 # 14c8 <malloc+0x180>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	1a850513          	addi	a0,a0,424 # 1558 <malloc+0x210>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	bb6080e7          	jalr	-1098(ra) # f6e <link>
     3c0:	b3c5                	j	1a0 <go+0xf2>
      int pid = fork();
     3c2:	00001097          	auipc	ra,0x1
     3c6:	b44080e7          	jalr	-1212(ra) # f06 <fork>
      if(pid == 0){
     3ca:	c909                	beqz	a0,3dc <go+0x32e>
      } else if(pid < 0){
     3cc:	00054c63          	bltz	a0,3e4 <go+0x336>
      wait(0);
     3d0:	4501                	li	a0,0
     3d2:	00001097          	auipc	ra,0x1
     3d6:	b44080e7          	jalr	-1212(ra) # f16 <wait>
     3da:	b3d9                	j	1a0 <go+0xf2>
        exit(0);
     3dc:	00001097          	auipc	ra,0x1
     3e0:	b32080e7          	jalr	-1230(ra) # f0e <exit>
        printf("grind: fork failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	17c50513          	addi	a0,a0,380 # 1560 <malloc+0x218>
     3ec:	00001097          	auipc	ra,0x1
     3f0:	ea0080e7          	jalr	-352(ra) # 128c <printf>
        exit(1);
     3f4:	4505                	li	a0,1
     3f6:	00001097          	auipc	ra,0x1
     3fa:	b18080e7          	jalr	-1256(ra) # f0e <exit>
      int pid = fork();
     3fe:	00001097          	auipc	ra,0x1
     402:	b08080e7          	jalr	-1272(ra) # f06 <fork>
      if(pid == 0){
     406:	c909                	beqz	a0,418 <go+0x36a>
      } else if(pid < 0){
     408:	02054563          	bltz	a0,432 <go+0x384>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	b08080e7          	jalr	-1272(ra) # f16 <wait>
     416:	b369                	j	1a0 <go+0xf2>
        fork();
     418:	00001097          	auipc	ra,0x1
     41c:	aee080e7          	jalr	-1298(ra) # f06 <fork>
        fork();
     420:	00001097          	auipc	ra,0x1
     424:	ae6080e7          	jalr	-1306(ra) # f06 <fork>
        exit(0);
     428:	4501                	li	a0,0
     42a:	00001097          	auipc	ra,0x1
     42e:	ae4080e7          	jalr	-1308(ra) # f0e <exit>
        printf("grind: fork failed\n");
     432:	00001517          	auipc	a0,0x1
     436:	12e50513          	addi	a0,a0,302 # 1560 <malloc+0x218>
     43a:	00001097          	auipc	ra,0x1
     43e:	e52080e7          	jalr	-430(ra) # 128c <printf>
        exit(1);
     442:	4505                	li	a0,1
     444:	00001097          	auipc	ra,0x1
     448:	aca080e7          	jalr	-1334(ra) # f0e <exit>
      sbrk(6011);
     44c:	6505                	lui	a0,0x1
     44e:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x433>
     452:	00001097          	auipc	ra,0x1
     456:	b44080e7          	jalr	-1212(ra) # f96 <sbrk>
     45a:	b399                	j	1a0 <go+0xf2>
      if(sbrk(0) > break0)
     45c:	4501                	li	a0,0
     45e:	00001097          	auipc	ra,0x1
     462:	b38080e7          	jalr	-1224(ra) # f96 <sbrk>
     466:	f5843783          	ld	a5,-168(s0)
     46a:	d2a7fbe3          	bgeu	a5,a0,1a0 <go+0xf2>
        sbrk(-(sbrk(0) - break0));
     46e:	4501                	li	a0,0
     470:	00001097          	auipc	ra,0x1
     474:	b26080e7          	jalr	-1242(ra) # f96 <sbrk>
     478:	f5843783          	ld	a5,-168(s0)
     47c:	40a7853b          	subw	a0,a5,a0
     480:	00001097          	auipc	ra,0x1
     484:	b16080e7          	jalr	-1258(ra) # f96 <sbrk>
     488:	bb21                	j	1a0 <go+0xf2>
      int pid = fork();
     48a:	00001097          	auipc	ra,0x1
     48e:	a7c080e7          	jalr	-1412(ra) # f06 <fork>
     492:	8d2a                	mv	s10,a0
      if(pid == 0){
     494:	c51d                	beqz	a0,4c2 <go+0x414>
      } else if(pid < 0){
     496:	04054963          	bltz	a0,4e8 <go+0x43a>
      if(chdir("../grindir/..") != 0){
     49a:	00001517          	auipc	a0,0x1
     49e:	0e650513          	addi	a0,a0,230 # 1580 <malloc+0x238>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	adc080e7          	jalr	-1316(ra) # f7e <chdir>
     4aa:	ed21                	bnez	a0,502 <go+0x454>
      kill(pid);
     4ac:	856a                	mv	a0,s10
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a90080e7          	jalr	-1392(ra) # f3e <kill>
      wait(0);
     4b6:	4501                	li	a0,0
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a5e080e7          	jalr	-1442(ra) # f16 <wait>
     4c0:	b1c5                	j	1a0 <go+0xf2>
        close(open("a", O_CREATE|O_RDWR));
     4c2:	20200593          	li	a1,514
     4c6:	00001517          	auipc	a0,0x1
     4ca:	0b250513          	addi	a0,a0,178 # 1578 <malloc+0x230>
     4ce:	00001097          	auipc	ra,0x1
     4d2:	a80080e7          	jalr	-1408(ra) # f4e <open>
     4d6:	00001097          	auipc	ra,0x1
     4da:	a60080e7          	jalr	-1440(ra) # f36 <close>
        exit(0);
     4de:	4501                	li	a0,0
     4e0:	00001097          	auipc	ra,0x1
     4e4:	a2e080e7          	jalr	-1490(ra) # f0e <exit>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	07850513          	addi	a0,a0,120 # 1560 <malloc+0x218>
     4f0:	00001097          	auipc	ra,0x1
     4f4:	d9c080e7          	jalr	-612(ra) # 128c <printf>
        exit(1);
     4f8:	4505                	li	a0,1
     4fa:	00001097          	auipc	ra,0x1
     4fe:	a14080e7          	jalr	-1516(ra) # f0e <exit>
        printf("grind: chdir failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	08e50513          	addi	a0,a0,142 # 1590 <malloc+0x248>
     50a:	00001097          	auipc	ra,0x1
     50e:	d82080e7          	jalr	-638(ra) # 128c <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	9fa080e7          	jalr	-1542(ra) # f0e <exit>
      int pid = fork();
     51c:	00001097          	auipc	ra,0x1
     520:	9ea080e7          	jalr	-1558(ra) # f06 <fork>
      if(pid == 0){
     524:	c909                	beqz	a0,536 <go+0x488>
      } else if(pid < 0){
     526:	02054563          	bltz	a0,550 <go+0x4a2>
      wait(0);
     52a:	4501                	li	a0,0
     52c:	00001097          	auipc	ra,0x1
     530:	9ea080e7          	jalr	-1558(ra) # f16 <wait>
     534:	b1b5                	j	1a0 <go+0xf2>
        kill(getpid());
     536:	00001097          	auipc	ra,0x1
     53a:	a58080e7          	jalr	-1448(ra) # f8e <getpid>
     53e:	00001097          	auipc	ra,0x1
     542:	a00080e7          	jalr	-1536(ra) # f3e <kill>
        exit(0);
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	9c6080e7          	jalr	-1594(ra) # f0e <exit>
        printf("grind: fork failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	01050513          	addi	a0,a0,16 # 1560 <malloc+0x218>
     558:	00001097          	auipc	ra,0x1
     55c:	d34080e7          	jalr	-716(ra) # 128c <printf>
        exit(1);
     560:	4505                	li	a0,1
     562:	00001097          	auipc	ra,0x1
     566:	9ac080e7          	jalr	-1620(ra) # f0e <exit>
      if(pipe(fds) < 0){
     56a:	f7840513          	addi	a0,s0,-136
     56e:	00001097          	auipc	ra,0x1
     572:	9b0080e7          	jalr	-1616(ra) # f1e <pipe>
     576:	02054b63          	bltz	a0,5ac <go+0x4fe>
      int pid = fork();
     57a:	00001097          	auipc	ra,0x1
     57e:	98c080e7          	jalr	-1652(ra) # f06 <fork>
      if(pid == 0){
     582:	c131                	beqz	a0,5c6 <go+0x518>
      } else if(pid < 0){
     584:	0a054a63          	bltz	a0,638 <go+0x58a>
      close(fds[0]);
     588:	f7842503          	lw	a0,-136(s0)
     58c:	00001097          	auipc	ra,0x1
     590:	9aa080e7          	jalr	-1622(ra) # f36 <close>
      close(fds[1]);
     594:	f7c42503          	lw	a0,-132(s0)
     598:	00001097          	auipc	ra,0x1
     59c:	99e080e7          	jalr	-1634(ra) # f36 <close>
      wait(0);
     5a0:	4501                	li	a0,0
     5a2:	00001097          	auipc	ra,0x1
     5a6:	974080e7          	jalr	-1676(ra) # f16 <wait>
     5aa:	bedd                	j	1a0 <go+0xf2>
        printf("grind: pipe failed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	ffc50513          	addi	a0,a0,-4 # 15a8 <malloc+0x260>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	cd8080e7          	jalr	-808(ra) # 128c <printf>
        exit(1);
     5bc:	4505                	li	a0,1
     5be:	00001097          	auipc	ra,0x1
     5c2:	950080e7          	jalr	-1712(ra) # f0e <exit>
        fork();
     5c6:	00001097          	auipc	ra,0x1
     5ca:	940080e7          	jalr	-1728(ra) # f06 <fork>
        fork();
     5ce:	00001097          	auipc	ra,0x1
     5d2:	938080e7          	jalr	-1736(ra) # f06 <fork>
        if(write(fds[1], "x", 1) != 1)
     5d6:	4605                	li	a2,1
     5d8:	00001597          	auipc	a1,0x1
     5dc:	fe858593          	addi	a1,a1,-24 # 15c0 <malloc+0x278>
     5e0:	f7c42503          	lw	a0,-132(s0)
     5e4:	00001097          	auipc	ra,0x1
     5e8:	94a080e7          	jalr	-1718(ra) # f2e <write>
     5ec:	4785                	li	a5,1
     5ee:	02f51363          	bne	a0,a5,614 <go+0x566>
        if(read(fds[0], &c, 1) != 1)
     5f2:	4605                	li	a2,1
     5f4:	f7040593          	addi	a1,s0,-144
     5f8:	f7842503          	lw	a0,-136(s0)
     5fc:	00001097          	auipc	ra,0x1
     600:	92a080e7          	jalr	-1750(ra) # f26 <read>
     604:	4785                	li	a5,1
     606:	02f51063          	bne	a0,a5,626 <go+0x578>
        exit(0);
     60a:	4501                	li	a0,0
     60c:	00001097          	auipc	ra,0x1
     610:	902080e7          	jalr	-1790(ra) # f0e <exit>
          printf("grind: pipe write failed\n");
     614:	00001517          	auipc	a0,0x1
     618:	fb450513          	addi	a0,a0,-76 # 15c8 <malloc+0x280>
     61c:	00001097          	auipc	ra,0x1
     620:	c70080e7          	jalr	-912(ra) # 128c <printf>
     624:	b7f9                	j	5f2 <go+0x544>
          printf("grind: pipe read failed\n");
     626:	00001517          	auipc	a0,0x1
     62a:	fc250513          	addi	a0,a0,-62 # 15e8 <malloc+0x2a0>
     62e:	00001097          	auipc	ra,0x1
     632:	c5e080e7          	jalr	-930(ra) # 128c <printf>
     636:	bfd1                	j	60a <go+0x55c>
        printf("grind: fork failed\n");
     638:	00001517          	auipc	a0,0x1
     63c:	f2850513          	addi	a0,a0,-216 # 1560 <malloc+0x218>
     640:	00001097          	auipc	ra,0x1
     644:	c4c080e7          	jalr	-948(ra) # 128c <printf>
        exit(1);
     648:	4505                	li	a0,1
     64a:	00001097          	auipc	ra,0x1
     64e:	8c4080e7          	jalr	-1852(ra) # f0e <exit>
      int pid = fork();
     652:	00001097          	auipc	ra,0x1
     656:	8b4080e7          	jalr	-1868(ra) # f06 <fork>
      if(pid == 0){
     65a:	c909                	beqz	a0,66c <go+0x5be>
      } else if(pid < 0){
     65c:	06054f63          	bltz	a0,6da <go+0x62c>
      wait(0);
     660:	4501                	li	a0,0
     662:	00001097          	auipc	ra,0x1
     666:	8b4080e7          	jalr	-1868(ra) # f16 <wait>
     66a:	be1d                	j	1a0 <go+0xf2>
        unlink("a");
     66c:	00001517          	auipc	a0,0x1
     670:	f0c50513          	addi	a0,a0,-244 # 1578 <malloc+0x230>
     674:	00001097          	auipc	ra,0x1
     678:	8ea080e7          	jalr	-1814(ra) # f5e <unlink>
        mkdir("a");
     67c:	00001517          	auipc	a0,0x1
     680:	efc50513          	addi	a0,a0,-260 # 1578 <malloc+0x230>
     684:	00001097          	auipc	ra,0x1
     688:	8f2080e7          	jalr	-1806(ra) # f76 <mkdir>
        chdir("a");
     68c:	00001517          	auipc	a0,0x1
     690:	eec50513          	addi	a0,a0,-276 # 1578 <malloc+0x230>
     694:	00001097          	auipc	ra,0x1
     698:	8ea080e7          	jalr	-1814(ra) # f7e <chdir>
        unlink("../a");
     69c:	00001517          	auipc	a0,0x1
     6a0:	f6c50513          	addi	a0,a0,-148 # 1608 <malloc+0x2c0>
     6a4:	00001097          	auipc	ra,0x1
     6a8:	8ba080e7          	jalr	-1862(ra) # f5e <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6ac:	20200593          	li	a1,514
     6b0:	00001517          	auipc	a0,0x1
     6b4:	f1050513          	addi	a0,a0,-240 # 15c0 <malloc+0x278>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	896080e7          	jalr	-1898(ra) # f4e <open>
        unlink("x");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	f0050513          	addi	a0,a0,-256 # 15c0 <malloc+0x278>
     6c8:	00001097          	auipc	ra,0x1
     6cc:	896080e7          	jalr	-1898(ra) # f5e <unlink>
        exit(0);
     6d0:	4501                	li	a0,0
     6d2:	00001097          	auipc	ra,0x1
     6d6:	83c080e7          	jalr	-1988(ra) # f0e <exit>
        printf("grind: fork failed\n");
     6da:	00001517          	auipc	a0,0x1
     6de:	e8650513          	addi	a0,a0,-378 # 1560 <malloc+0x218>
     6e2:	00001097          	auipc	ra,0x1
     6e6:	baa080e7          	jalr	-1110(ra) # 128c <printf>
        exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00001097          	auipc	ra,0x1
     6f0:	822080e7          	jalr	-2014(ra) # f0e <exit>
      unlink("c");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	f1c50513          	addi	a0,a0,-228 # 1610 <malloc+0x2c8>
     6fc:	00001097          	auipc	ra,0x1
     700:	862080e7          	jalr	-1950(ra) # f5e <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     704:	20200593          	li	a1,514
     708:	00001517          	auipc	a0,0x1
     70c:	f0850513          	addi	a0,a0,-248 # 1610 <malloc+0x2c8>
     710:	00001097          	auipc	ra,0x1
     714:	83e080e7          	jalr	-1986(ra) # f4e <open>
     718:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71a:	04054d63          	bltz	a0,774 <go+0x6c6>
      if(write(fd1, "x", 1) != 1){
     71e:	865e                	mv	a2,s7
     720:	00001597          	auipc	a1,0x1
     724:	ea058593          	addi	a1,a1,-352 # 15c0 <malloc+0x278>
     728:	00001097          	auipc	ra,0x1
     72c:	806080e7          	jalr	-2042(ra) # f2e <write>
     730:	05751f63          	bne	a0,s7,78e <go+0x6e0>
      if(fstat(fd1, &st) != 0){
     734:	f7840593          	addi	a1,s0,-136
     738:	856a                	mv	a0,s10
     73a:	00001097          	auipc	ra,0x1
     73e:	82c080e7          	jalr	-2004(ra) # f66 <fstat>
     742:	e13d                	bnez	a0,7a8 <go+0x6fa>
      if(st.size != 1){
     744:	f8843583          	ld	a1,-120(s0)
     748:	07759d63          	bne	a1,s7,7c2 <go+0x714>
      if(st.ino > 200){
     74c:	f7c42583          	lw	a1,-132(s0)
     750:	0c800793          	li	a5,200
     754:	08b7e563          	bltu	a5,a1,7de <go+0x730>
      close(fd1);
     758:	856a                	mv	a0,s10
     75a:	00000097          	auipc	ra,0x0
     75e:	7dc080e7          	jalr	2012(ra) # f36 <close>
      unlink("c");
     762:	00001517          	auipc	a0,0x1
     766:	eae50513          	addi	a0,a0,-338 # 1610 <malloc+0x2c8>
     76a:	00000097          	auipc	ra,0x0
     76e:	7f4080e7          	jalr	2036(ra) # f5e <unlink>
     772:	b43d                	j	1a0 <go+0xf2>
        printf("grind: create c failed\n");
     774:	00001517          	auipc	a0,0x1
     778:	ea450513          	addi	a0,a0,-348 # 1618 <malloc+0x2d0>
     77c:	00001097          	auipc	ra,0x1
     780:	b10080e7          	jalr	-1264(ra) # 128c <printf>
        exit(1);
     784:	4505                	li	a0,1
     786:	00000097          	auipc	ra,0x0
     78a:	788080e7          	jalr	1928(ra) # f0e <exit>
        printf("grind: write c failed\n");
     78e:	00001517          	auipc	a0,0x1
     792:	ea250513          	addi	a0,a0,-350 # 1630 <malloc+0x2e8>
     796:	00001097          	auipc	ra,0x1
     79a:	af6080e7          	jalr	-1290(ra) # 128c <printf>
        exit(1);
     79e:	4505                	li	a0,1
     7a0:	00000097          	auipc	ra,0x0
     7a4:	76e080e7          	jalr	1902(ra) # f0e <exit>
        printf("grind: fstat failed\n");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	ea050513          	addi	a0,a0,-352 # 1648 <malloc+0x300>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	adc080e7          	jalr	-1316(ra) # 128c <printf>
        exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00000097          	auipc	ra,0x0
     7be:	754080e7          	jalr	1876(ra) # f0e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c2:	2581                	sext.w	a1,a1
     7c4:	00001517          	auipc	a0,0x1
     7c8:	e9c50513          	addi	a0,a0,-356 # 1660 <malloc+0x318>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	ac0080e7          	jalr	-1344(ra) # 128c <printf>
        exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00000097          	auipc	ra,0x0
     7da:	738080e7          	jalr	1848(ra) # f0e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7de:	00001517          	auipc	a0,0x1
     7e2:	eaa50513          	addi	a0,a0,-342 # 1688 <malloc+0x340>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	aa6080e7          	jalr	-1370(ra) # 128c <printf>
        exit(1);
     7ee:	4505                	li	a0,1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	71e080e7          	jalr	1822(ra) # f0e <exit>
      if(pipe(aa) < 0){
     7f8:	856e                	mv	a0,s11
     7fa:	00000097          	auipc	ra,0x0
     7fe:	724080e7          	jalr	1828(ra) # f1e <pipe>
     802:	10054063          	bltz	a0,902 <go+0x854>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     806:	f7040513          	addi	a0,s0,-144
     80a:	00000097          	auipc	ra,0x0
     80e:	714080e7          	jalr	1812(ra) # f1e <pipe>
     812:	10054663          	bltz	a0,91e <go+0x870>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     816:	00000097          	auipc	ra,0x0
     81a:	6f0080e7          	jalr	1776(ra) # f06 <fork>
      if(pid1 == 0){
     81e:	10050e63          	beqz	a0,93a <go+0x88c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     822:	1c054663          	bltz	a0,9ee <go+0x940>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     826:	00000097          	auipc	ra,0x0
     82a:	6e0080e7          	jalr	1760(ra) # f06 <fork>
      if(pid2 == 0){
     82e:	1c050e63          	beqz	a0,a0a <go+0x95c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     832:	2a054a63          	bltz	a0,ae6 <go+0xa38>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     836:	f6842503          	lw	a0,-152(s0)
     83a:	00000097          	auipc	ra,0x0
     83e:	6fc080e7          	jalr	1788(ra) # f36 <close>
      close(aa[1]);
     842:	f6c42503          	lw	a0,-148(s0)
     846:	00000097          	auipc	ra,0x0
     84a:	6f0080e7          	jalr	1776(ra) # f36 <close>
      close(bb[1]);
     84e:	f7442503          	lw	a0,-140(s0)
     852:	00000097          	auipc	ra,0x0
     856:	6e4080e7          	jalr	1764(ra) # f36 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     85e:	865e                	mv	a2,s7
     860:	f6040593          	addi	a1,s0,-160
     864:	f7042503          	lw	a0,-144(s0)
     868:	00000097          	auipc	ra,0x0
     86c:	6be080e7          	jalr	1726(ra) # f26 <read>
      read(bb[0], buf+1, 1);
     870:	865e                	mv	a2,s7
     872:	f6140593          	addi	a1,s0,-159
     876:	f7042503          	lw	a0,-144(s0)
     87a:	00000097          	auipc	ra,0x0
     87e:	6ac080e7          	jalr	1708(ra) # f26 <read>
      read(bb[0], buf+2, 1);
     882:	865e                	mv	a2,s7
     884:	f6240593          	addi	a1,s0,-158
     888:	f7042503          	lw	a0,-144(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	69a080e7          	jalr	1690(ra) # f26 <read>
      close(bb[0]);
     894:	f7042503          	lw	a0,-144(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	69e080e7          	jalr	1694(ra) # f36 <close>
      int st1, st2;
      wait(&st1);
     8a0:	f6440513          	addi	a0,s0,-156
     8a4:	00000097          	auipc	ra,0x0
     8a8:	672080e7          	jalr	1650(ra) # f16 <wait>
      wait(&st2);
     8ac:	f7840513          	addi	a0,s0,-136
     8b0:	00000097          	auipc	ra,0x0
     8b4:	666080e7          	jalr	1638(ra) # f16 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8b8:	f6442783          	lw	a5,-156(s0)
     8bc:	f7842703          	lw	a4,-136(s0)
     8c0:	8fd9                	or	a5,a5,a4
     8c2:	ef89                	bnez	a5,8dc <go+0x82e>
     8c4:	00001597          	auipc	a1,0x1
     8c8:	e6458593          	addi	a1,a1,-412 # 1728 <malloc+0x3e0>
     8cc:	f6040513          	addi	a0,s0,-160
     8d0:	00000097          	auipc	ra,0x0
     8d4:	3be080e7          	jalr	958(ra) # c8e <strcmp>
     8d8:	8c0504e3          	beqz	a0,1a0 <go+0xf2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8dc:	f6040693          	addi	a3,s0,-160
     8e0:	f7842603          	lw	a2,-136(s0)
     8e4:	f6442583          	lw	a1,-156(s0)
     8e8:	00001517          	auipc	a0,0x1
     8ec:	e4850513          	addi	a0,a0,-440 # 1730 <malloc+0x3e8>
     8f0:	00001097          	auipc	ra,0x1
     8f4:	99c080e7          	jalr	-1636(ra) # 128c <printf>
        exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	614080e7          	jalr	1556(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     902:	00001597          	auipc	a1,0x1
     906:	ca658593          	addi	a1,a1,-858 # 15a8 <malloc+0x260>
     90a:	4509                	li	a0,2
     90c:	00001097          	auipc	ra,0x1
     910:	952080e7          	jalr	-1710(ra) # 125e <fprintf>
        exit(1);
     914:	4505                	li	a0,1
     916:	00000097          	auipc	ra,0x0
     91a:	5f8080e7          	jalr	1528(ra) # f0e <exit>
        fprintf(2, "grind: pipe failed\n");
     91e:	00001597          	auipc	a1,0x1
     922:	c8a58593          	addi	a1,a1,-886 # 15a8 <malloc+0x260>
     926:	4509                	li	a0,2
     928:	00001097          	auipc	ra,0x1
     92c:	936080e7          	jalr	-1738(ra) # 125e <fprintf>
        exit(1);
     930:	4505                	li	a0,1
     932:	00000097          	auipc	ra,0x0
     936:	5dc080e7          	jalr	1500(ra) # f0e <exit>
        close(bb[0]);
     93a:	f7042503          	lw	a0,-144(s0)
     93e:	00000097          	auipc	ra,0x0
     942:	5f8080e7          	jalr	1528(ra) # f36 <close>
        close(bb[1]);
     946:	f7442503          	lw	a0,-140(s0)
     94a:	00000097          	auipc	ra,0x0
     94e:	5ec080e7          	jalr	1516(ra) # f36 <close>
        close(aa[0]);
     952:	f6842503          	lw	a0,-152(s0)
     956:	00000097          	auipc	ra,0x0
     95a:	5e0080e7          	jalr	1504(ra) # f36 <close>
        close(1);
     95e:	4505                	li	a0,1
     960:	00000097          	auipc	ra,0x0
     964:	5d6080e7          	jalr	1494(ra) # f36 <close>
        if(dup(aa[1]) != 1){
     968:	f6c42503          	lw	a0,-148(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	61a080e7          	jalr	1562(ra) # f86 <dup>
     974:	4785                	li	a5,1
     976:	02f50063          	beq	a0,a5,996 <go+0x8e8>
          fprintf(2, "grind: dup failed\n");
     97a:	00001597          	auipc	a1,0x1
     97e:	d3658593          	addi	a1,a1,-714 # 16b0 <malloc+0x368>
     982:	4509                	li	a0,2
     984:	00001097          	auipc	ra,0x1
     988:	8da080e7          	jalr	-1830(ra) # 125e <fprintf>
          exit(1);
     98c:	4505                	li	a0,1
     98e:	00000097          	auipc	ra,0x0
     992:	580080e7          	jalr	1408(ra) # f0e <exit>
        close(aa[1]);
     996:	f6c42503          	lw	a0,-148(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	59c080e7          	jalr	1436(ra) # f36 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a2:	00001797          	auipc	a5,0x1
     9a6:	d2678793          	addi	a5,a5,-730 # 16c8 <malloc+0x380>
     9aa:	f6f43c23          	sd	a5,-136(s0)
     9ae:	00001797          	auipc	a5,0x1
     9b2:	d2278793          	addi	a5,a5,-734 # 16d0 <malloc+0x388>
     9b6:	f8f43023          	sd	a5,-128(s0)
     9ba:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9be:	f7840593          	addi	a1,s0,-136
     9c2:	00001517          	auipc	a0,0x1
     9c6:	d1650513          	addi	a0,a0,-746 # 16d8 <malloc+0x390>
     9ca:	00000097          	auipc	ra,0x0
     9ce:	57c080e7          	jalr	1404(ra) # f46 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d2:	00001597          	auipc	a1,0x1
     9d6:	d1658593          	addi	a1,a1,-746 # 16e8 <malloc+0x3a0>
     9da:	4509                	li	a0,2
     9dc:	00001097          	auipc	ra,0x1
     9e0:	882080e7          	jalr	-1918(ra) # 125e <fprintf>
        exit(2);
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	528080e7          	jalr	1320(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     9ee:	00001597          	auipc	a1,0x1
     9f2:	b7258593          	addi	a1,a1,-1166 # 1560 <malloc+0x218>
     9f6:	4509                	li	a0,2
     9f8:	00001097          	auipc	ra,0x1
     9fc:	866080e7          	jalr	-1946(ra) # 125e <fprintf>
        exit(3);
     a00:	450d                	li	a0,3
     a02:	00000097          	auipc	ra,0x0
     a06:	50c080e7          	jalr	1292(ra) # f0e <exit>
        close(aa[1]);
     a0a:	f6c42503          	lw	a0,-148(s0)
     a0e:	00000097          	auipc	ra,0x0
     a12:	528080e7          	jalr	1320(ra) # f36 <close>
        close(bb[0]);
     a16:	f7042503          	lw	a0,-144(s0)
     a1a:	00000097          	auipc	ra,0x0
     a1e:	51c080e7          	jalr	1308(ra) # f36 <close>
        close(0);
     a22:	4501                	li	a0,0
     a24:	00000097          	auipc	ra,0x0
     a28:	512080e7          	jalr	1298(ra) # f36 <close>
        if(dup(aa[0]) != 0){
     a2c:	f6842503          	lw	a0,-152(s0)
     a30:	00000097          	auipc	ra,0x0
     a34:	556080e7          	jalr	1366(ra) # f86 <dup>
     a38:	cd19                	beqz	a0,a56 <go+0x9a8>
          fprintf(2, "grind: dup failed\n");
     a3a:	00001597          	auipc	a1,0x1
     a3e:	c7658593          	addi	a1,a1,-906 # 16b0 <malloc+0x368>
     a42:	4509                	li	a0,2
     a44:	00001097          	auipc	ra,0x1
     a48:	81a080e7          	jalr	-2022(ra) # 125e <fprintf>
          exit(4);
     a4c:	4511                	li	a0,4
     a4e:	00000097          	auipc	ra,0x0
     a52:	4c0080e7          	jalr	1216(ra) # f0e <exit>
        close(aa[0]);
     a56:	f6842503          	lw	a0,-152(s0)
     a5a:	00000097          	auipc	ra,0x0
     a5e:	4dc080e7          	jalr	1244(ra) # f36 <close>
        close(1);
     a62:	4505                	li	a0,1
     a64:	00000097          	auipc	ra,0x0
     a68:	4d2080e7          	jalr	1234(ra) # f36 <close>
        if(dup(bb[1]) != 1){
     a6c:	f7442503          	lw	a0,-140(s0)
     a70:	00000097          	auipc	ra,0x0
     a74:	516080e7          	jalr	1302(ra) # f86 <dup>
     a78:	4785                	li	a5,1
     a7a:	02f50063          	beq	a0,a5,a9a <go+0x9ec>
          fprintf(2, "grind: dup failed\n");
     a7e:	00001597          	auipc	a1,0x1
     a82:	c3258593          	addi	a1,a1,-974 # 16b0 <malloc+0x368>
     a86:	4509                	li	a0,2
     a88:	00000097          	auipc	ra,0x0
     a8c:	7d6080e7          	jalr	2006(ra) # 125e <fprintf>
          exit(5);
     a90:	4515                	li	a0,5
     a92:	00000097          	auipc	ra,0x0
     a96:	47c080e7          	jalr	1148(ra) # f0e <exit>
        close(bb[1]);
     a9a:	f7442503          	lw	a0,-140(s0)
     a9e:	00000097          	auipc	ra,0x0
     aa2:	498080e7          	jalr	1176(ra) # f36 <close>
        char *args[2] = { "cat", 0 };
     aa6:	00001797          	auipc	a5,0x1
     aaa:	c5a78793          	addi	a5,a5,-934 # 1700 <malloc+0x3b8>
     aae:	f6f43c23          	sd	a5,-136(s0)
     ab2:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     ab6:	f7840593          	addi	a1,s0,-136
     aba:	00001517          	auipc	a0,0x1
     abe:	c4e50513          	addi	a0,a0,-946 # 1708 <malloc+0x3c0>
     ac2:	00000097          	auipc	ra,0x0
     ac6:	484080e7          	jalr	1156(ra) # f46 <exec>
        fprintf(2, "grind: cat: not found\n");
     aca:	00001597          	auipc	a1,0x1
     ace:	c4658593          	addi	a1,a1,-954 # 1710 <malloc+0x3c8>
     ad2:	4509                	li	a0,2
     ad4:	00000097          	auipc	ra,0x0
     ad8:	78a080e7          	jalr	1930(ra) # 125e <fprintf>
        exit(6);
     adc:	4519                	li	a0,6
     ade:	00000097          	auipc	ra,0x0
     ae2:	430080e7          	jalr	1072(ra) # f0e <exit>
        fprintf(2, "grind: fork failed\n");
     ae6:	00001597          	auipc	a1,0x1
     aea:	a7a58593          	addi	a1,a1,-1414 # 1560 <malloc+0x218>
     aee:	4509                	li	a0,2
     af0:	00000097          	auipc	ra,0x0
     af4:	76e080e7          	jalr	1902(ra) # 125e <fprintf>
        exit(7);
     af8:	451d                	li	a0,7
     afa:	00000097          	auipc	ra,0x0
     afe:	414080e7          	jalr	1044(ra) # f0e <exit>

0000000000000b02 <iter>:
  }
}

void
iter()
{
     b02:	7179                	addi	sp,sp,-48
     b04:	f406                	sd	ra,40(sp)
     b06:	f022                	sd	s0,32(sp)
     b08:	1800                	addi	s0,sp,48
  unlink("a");
     b0a:	00001517          	auipc	a0,0x1
     b0e:	a6e50513          	addi	a0,a0,-1426 # 1578 <malloc+0x230>
     b12:	00000097          	auipc	ra,0x0
     b16:	44c080e7          	jalr	1100(ra) # f5e <unlink>
  unlink("b");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	a0e50513          	addi	a0,a0,-1522 # 1528 <malloc+0x1e0>
     b22:	00000097          	auipc	ra,0x0
     b26:	43c080e7          	jalr	1084(ra) # f5e <unlink>
  
  int pid1 = fork();
     b2a:	00000097          	auipc	ra,0x0
     b2e:	3dc080e7          	jalr	988(ra) # f06 <fork>
  if(pid1 < 0){
     b32:	02054363          	bltz	a0,b58 <iter+0x56>
     b36:	ec26                	sd	s1,24(sp)
     b38:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3a:	ed15                	bnez	a0,b76 <iter+0x74>
     b3c:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     b3e:	00001717          	auipc	a4,0x1
     b42:	4c270713          	addi	a4,a4,1218 # 2000 <rand_next>
     b46:	631c                	ld	a5,0(a4)
     b48:	01f7c793          	xori	a5,a5,31
     b4c:	e31c                	sd	a5,0(a4)
    go(0);
     b4e:	4501                	li	a0,0
     b50:	fffff097          	auipc	ra,0xfffff
     b54:	55e080e7          	jalr	1374(ra) # ae <go>
     b58:	ec26                	sd	s1,24(sp)
     b5a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b5c:	00001517          	auipc	a0,0x1
     b60:	a0450513          	addi	a0,a0,-1532 # 1560 <malloc+0x218>
     b64:	00000097          	auipc	ra,0x0
     b68:	728080e7          	jalr	1832(ra) # 128c <printf>
    exit(1);
     b6c:	4505                	li	a0,1
     b6e:	00000097          	auipc	ra,0x0
     b72:	3a0080e7          	jalr	928(ra) # f0e <exit>
     b76:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b78:	00000097          	auipc	ra,0x0
     b7c:	38e080e7          	jalr	910(ra) # f06 <fork>
     b80:	892a                	mv	s2,a0
  if(pid2 < 0){
     b82:	02054263          	bltz	a0,ba6 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b86:	ed0d                	bnez	a0,bc0 <iter+0xbe>
    rand_next ^= 7177;
     b88:	00001697          	auipc	a3,0x1
     b8c:	47868693          	addi	a3,a3,1144 # 2000 <rand_next>
     b90:	629c                	ld	a5,0(a3)
     b92:	6709                	lui	a4,0x2
     b94:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x3f1>
     b98:	8fb9                	xor	a5,a5,a4
     b9a:	e29c                	sd	a5,0(a3)
    go(1);
     b9c:	4505                	li	a0,1
     b9e:	fffff097          	auipc	ra,0xfffff
     ba2:	510080e7          	jalr	1296(ra) # ae <go>
    printf("grind: fork failed\n");
     ba6:	00001517          	auipc	a0,0x1
     baa:	9ba50513          	addi	a0,a0,-1606 # 1560 <malloc+0x218>
     bae:	00000097          	auipc	ra,0x0
     bb2:	6de080e7          	jalr	1758(ra) # 128c <printf>
    exit(1);
     bb6:	4505                	li	a0,1
     bb8:	00000097          	auipc	ra,0x0
     bbc:	356080e7          	jalr	854(ra) # f0e <exit>
    exit(0);
  }

  int st1 = -1;
     bc0:	57fd                	li	a5,-1
     bc2:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bc6:	fdc40513          	addi	a0,s0,-36
     bca:	00000097          	auipc	ra,0x0
     bce:	34c080e7          	jalr	844(ra) # f16 <wait>
  if(st1 != 0){
     bd2:	fdc42783          	lw	a5,-36(s0)
     bd6:	ef99                	bnez	a5,bf4 <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bd8:	57fd                	li	a5,-1
     bda:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     bde:	fd840513          	addi	a0,s0,-40
     be2:	00000097          	auipc	ra,0x0
     be6:	334080e7          	jalr	820(ra) # f16 <wait>

  exit(0);
     bea:	4501                	li	a0,0
     bec:	00000097          	auipc	ra,0x0
     bf0:	322080e7          	jalr	802(ra) # f0e <exit>
    kill(pid1);
     bf4:	8526                	mv	a0,s1
     bf6:	00000097          	auipc	ra,0x0
     bfa:	348080e7          	jalr	840(ra) # f3e <kill>
    kill(pid2);
     bfe:	854a                	mv	a0,s2
     c00:	00000097          	auipc	ra,0x0
     c04:	33e080e7          	jalr	830(ra) # f3e <kill>
     c08:	bfc1                	j	bd8 <iter+0xd6>

0000000000000c0a <main>:
}

int
main()
{
     c0a:	1101                	addi	sp,sp,-32
     c0c:	ec06                	sd	ra,24(sp)
     c0e:	e822                	sd	s0,16(sp)
     c10:	e426                	sd	s1,8(sp)
     c12:	e04a                	sd	s2,0(sp)
     c14:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c16:	4951                	li	s2,20
    rand_next += 1;
     c18:	00001497          	auipc	s1,0x1
     c1c:	3e848493          	addi	s1,s1,1000 # 2000 <rand_next>
     c20:	a829                	j	c3a <main+0x30>
      iter();
     c22:	00000097          	auipc	ra,0x0
     c26:	ee0080e7          	jalr	-288(ra) # b02 <iter>
    sleep(20);
     c2a:	854a                	mv	a0,s2
     c2c:	00000097          	auipc	ra,0x0
     c30:	372080e7          	jalr	882(ra) # f9e <sleep>
    rand_next += 1;
     c34:	609c                	ld	a5,0(s1)
     c36:	0785                	addi	a5,a5,1
     c38:	e09c                	sd	a5,0(s1)
    int pid = fork();
     c3a:	00000097          	auipc	ra,0x0
     c3e:	2cc080e7          	jalr	716(ra) # f06 <fork>
    if(pid == 0){
     c42:	d165                	beqz	a0,c22 <main+0x18>
    if(pid > 0){
     c44:	fea053e3          	blez	a0,c2a <main+0x20>
      wait(0);
     c48:	4501                	li	a0,0
     c4a:	00000097          	auipc	ra,0x0
     c4e:	2cc080e7          	jalr	716(ra) # f16 <wait>
     c52:	bfe1                	j	c2a <main+0x20>

0000000000000c54 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c54:	1141                	addi	sp,sp,-16
     c56:	e406                	sd	ra,8(sp)
     c58:	e022                	sd	s0,0(sp)
     c5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c5c:	00000097          	auipc	ra,0x0
     c60:	fae080e7          	jalr	-82(ra) # c0a <main>
  exit(0);
     c64:	4501                	li	a0,0
     c66:	00000097          	auipc	ra,0x0
     c6a:	2a8080e7          	jalr	680(ra) # f0e <exit>

0000000000000c6e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c6e:	1141                	addi	sp,sp,-16
     c70:	e406                	sd	ra,8(sp)
     c72:	e022                	sd	s0,0(sp)
     c74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c76:	87aa                	mv	a5,a0
     c78:	0585                	addi	a1,a1,1
     c7a:	0785                	addi	a5,a5,1
     c7c:	fff5c703          	lbu	a4,-1(a1)
     c80:	fee78fa3          	sb	a4,-1(a5)
     c84:	fb75                	bnez	a4,c78 <strcpy+0xa>
    ;
  return os;
}
     c86:	60a2                	ld	ra,8(sp)
     c88:	6402                	ld	s0,0(sp)
     c8a:	0141                	addi	sp,sp,16
     c8c:	8082                	ret

0000000000000c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c8e:	1141                	addi	sp,sp,-16
     c90:	e406                	sd	ra,8(sp)
     c92:	e022                	sd	s0,0(sp)
     c94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c96:	00054783          	lbu	a5,0(a0)
     c9a:	cb91                	beqz	a5,cae <strcmp+0x20>
     c9c:	0005c703          	lbu	a4,0(a1)
     ca0:	00f71763          	bne	a4,a5,cae <strcmp+0x20>
    p++, q++;
     ca4:	0505                	addi	a0,a0,1
     ca6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     ca8:	00054783          	lbu	a5,0(a0)
     cac:	fbe5                	bnez	a5,c9c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     cae:	0005c503          	lbu	a0,0(a1)
}
     cb2:	40a7853b          	subw	a0,a5,a0
     cb6:	60a2                	ld	ra,8(sp)
     cb8:	6402                	ld	s0,0(sp)
     cba:	0141                	addi	sp,sp,16
     cbc:	8082                	ret

0000000000000cbe <strlen>:

uint
strlen(const char *s)
{
     cbe:	1141                	addi	sp,sp,-16
     cc0:	e406                	sd	ra,8(sp)
     cc2:	e022                	sd	s0,0(sp)
     cc4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cc6:	00054783          	lbu	a5,0(a0)
     cca:	cf99                	beqz	a5,ce8 <strlen+0x2a>
     ccc:	0505                	addi	a0,a0,1
     cce:	87aa                	mv	a5,a0
     cd0:	86be                	mv	a3,a5
     cd2:	0785                	addi	a5,a5,1
     cd4:	fff7c703          	lbu	a4,-1(a5)
     cd8:	ff65                	bnez	a4,cd0 <strlen+0x12>
     cda:	40a6853b          	subw	a0,a3,a0
     cde:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     ce0:	60a2                	ld	ra,8(sp)
     ce2:	6402                	ld	s0,0(sp)
     ce4:	0141                	addi	sp,sp,16
     ce6:	8082                	ret
  for(n = 0; s[n]; n++)
     ce8:	4501                	li	a0,0
     cea:	bfdd                	j	ce0 <strlen+0x22>

0000000000000cec <memset>:

void*
memset(void *dst, int c, uint n)
{
     cec:	1141                	addi	sp,sp,-16
     cee:	e406                	sd	ra,8(sp)
     cf0:	e022                	sd	s0,0(sp)
     cf2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cf4:	ca19                	beqz	a2,d0a <memset+0x1e>
     cf6:	87aa                	mv	a5,a0
     cf8:	1602                	slli	a2,a2,0x20
     cfa:	9201                	srli	a2,a2,0x20
     cfc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d00:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d04:	0785                	addi	a5,a5,1
     d06:	fee79de3          	bne	a5,a4,d00 <memset+0x14>
  }
  return dst;
}
     d0a:	60a2                	ld	ra,8(sp)
     d0c:	6402                	ld	s0,0(sp)
     d0e:	0141                	addi	sp,sp,16
     d10:	8082                	ret

0000000000000d12 <strchr>:

char*
strchr(const char *s, char c)
{
     d12:	1141                	addi	sp,sp,-16
     d14:	e406                	sd	ra,8(sp)
     d16:	e022                	sd	s0,0(sp)
     d18:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d1a:	00054783          	lbu	a5,0(a0)
     d1e:	cf81                	beqz	a5,d36 <strchr+0x24>
    if(*s == c)
     d20:	00f58763          	beq	a1,a5,d2e <strchr+0x1c>
  for(; *s; s++)
     d24:	0505                	addi	a0,a0,1
     d26:	00054783          	lbu	a5,0(a0)
     d2a:	fbfd                	bnez	a5,d20 <strchr+0xe>
      return (char*)s;
  return 0;
     d2c:	4501                	li	a0,0
}
     d2e:	60a2                	ld	ra,8(sp)
     d30:	6402                	ld	s0,0(sp)
     d32:	0141                	addi	sp,sp,16
     d34:	8082                	ret
  return 0;
     d36:	4501                	li	a0,0
     d38:	bfdd                	j	d2e <strchr+0x1c>

0000000000000d3a <gets>:

char*
gets(char *buf, int max)
{
     d3a:	7159                	addi	sp,sp,-112
     d3c:	f486                	sd	ra,104(sp)
     d3e:	f0a2                	sd	s0,96(sp)
     d40:	eca6                	sd	s1,88(sp)
     d42:	e8ca                	sd	s2,80(sp)
     d44:	e4ce                	sd	s3,72(sp)
     d46:	e0d2                	sd	s4,64(sp)
     d48:	fc56                	sd	s5,56(sp)
     d4a:	f85a                	sd	s6,48(sp)
     d4c:	f45e                	sd	s7,40(sp)
     d4e:	f062                	sd	s8,32(sp)
     d50:	ec66                	sd	s9,24(sp)
     d52:	e86a                	sd	s10,16(sp)
     d54:	1880                	addi	s0,sp,112
     d56:	8caa                	mv	s9,a0
     d58:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d5a:	892a                	mv	s2,a0
     d5c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d5e:	f9f40b13          	addi	s6,s0,-97
     d62:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d64:	4ba9                	li	s7,10
     d66:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     d68:	8d26                	mv	s10,s1
     d6a:	0014899b          	addiw	s3,s1,1
     d6e:	84ce                	mv	s1,s3
     d70:	0349d763          	bge	s3,s4,d9e <gets+0x64>
    cc = read(0, &c, 1);
     d74:	8656                	mv	a2,s5
     d76:	85da                	mv	a1,s6
     d78:	4501                	li	a0,0
     d7a:	00000097          	auipc	ra,0x0
     d7e:	1ac080e7          	jalr	428(ra) # f26 <read>
    if(cc < 1)
     d82:	00a05e63          	blez	a0,d9e <gets+0x64>
    buf[i++] = c;
     d86:	f9f44783          	lbu	a5,-97(s0)
     d8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d8e:	01778763          	beq	a5,s7,d9c <gets+0x62>
     d92:	0905                	addi	s2,s2,1
     d94:	fd879ae3          	bne	a5,s8,d68 <gets+0x2e>
    buf[i++] = c;
     d98:	8d4e                	mv	s10,s3
     d9a:	a011                	j	d9e <gets+0x64>
     d9c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     d9e:	9d66                	add	s10,s10,s9
     da0:	000d0023          	sb	zero,0(s10)
  return buf;
}
     da4:	8566                	mv	a0,s9
     da6:	70a6                	ld	ra,104(sp)
     da8:	7406                	ld	s0,96(sp)
     daa:	64e6                	ld	s1,88(sp)
     dac:	6946                	ld	s2,80(sp)
     dae:	69a6                	ld	s3,72(sp)
     db0:	6a06                	ld	s4,64(sp)
     db2:	7ae2                	ld	s5,56(sp)
     db4:	7b42                	ld	s6,48(sp)
     db6:	7ba2                	ld	s7,40(sp)
     db8:	7c02                	ld	s8,32(sp)
     dba:	6ce2                	ld	s9,24(sp)
     dbc:	6d42                	ld	s10,16(sp)
     dbe:	6165                	addi	sp,sp,112
     dc0:	8082                	ret

0000000000000dc2 <stat>:

int
stat(const char *n, struct stat *st)
{
     dc2:	1101                	addi	sp,sp,-32
     dc4:	ec06                	sd	ra,24(sp)
     dc6:	e822                	sd	s0,16(sp)
     dc8:	e04a                	sd	s2,0(sp)
     dca:	1000                	addi	s0,sp,32
     dcc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dce:	4581                	li	a1,0
     dd0:	00000097          	auipc	ra,0x0
     dd4:	17e080e7          	jalr	382(ra) # f4e <open>
  if(fd < 0)
     dd8:	02054663          	bltz	a0,e04 <stat+0x42>
     ddc:	e426                	sd	s1,8(sp)
     dde:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     de0:	85ca                	mv	a1,s2
     de2:	00000097          	auipc	ra,0x0
     de6:	184080e7          	jalr	388(ra) # f66 <fstat>
     dea:	892a                	mv	s2,a0
  close(fd);
     dec:	8526                	mv	a0,s1
     dee:	00000097          	auipc	ra,0x0
     df2:	148080e7          	jalr	328(ra) # f36 <close>
  return r;
     df6:	64a2                	ld	s1,8(sp)
}
     df8:	854a                	mv	a0,s2
     dfa:	60e2                	ld	ra,24(sp)
     dfc:	6442                	ld	s0,16(sp)
     dfe:	6902                	ld	s2,0(sp)
     e00:	6105                	addi	sp,sp,32
     e02:	8082                	ret
    return -1;
     e04:	597d                	li	s2,-1
     e06:	bfcd                	j	df8 <stat+0x36>

0000000000000e08 <atoi>:

int
atoi(const char *s)
{
     e08:	1141                	addi	sp,sp,-16
     e0a:	e406                	sd	ra,8(sp)
     e0c:	e022                	sd	s0,0(sp)
     e0e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e10:	00054683          	lbu	a3,0(a0)
     e14:	fd06879b          	addiw	a5,a3,-48
     e18:	0ff7f793          	zext.b	a5,a5
     e1c:	4625                	li	a2,9
     e1e:	02f66963          	bltu	a2,a5,e50 <atoi+0x48>
     e22:	872a                	mv	a4,a0
  n = 0;
     e24:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e26:	0705                	addi	a4,a4,1
     e28:	0025179b          	slliw	a5,a0,0x2
     e2c:	9fa9                	addw	a5,a5,a0
     e2e:	0017979b          	slliw	a5,a5,0x1
     e32:	9fb5                	addw	a5,a5,a3
     e34:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e38:	00074683          	lbu	a3,0(a4)
     e3c:	fd06879b          	addiw	a5,a3,-48
     e40:	0ff7f793          	zext.b	a5,a5
     e44:	fef671e3          	bgeu	a2,a5,e26 <atoi+0x1e>
  return n;
}
     e48:	60a2                	ld	ra,8(sp)
     e4a:	6402                	ld	s0,0(sp)
     e4c:	0141                	addi	sp,sp,16
     e4e:	8082                	ret
  n = 0;
     e50:	4501                	li	a0,0
     e52:	bfdd                	j	e48 <atoi+0x40>

0000000000000e54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e54:	1141                	addi	sp,sp,-16
     e56:	e406                	sd	ra,8(sp)
     e58:	e022                	sd	s0,0(sp)
     e5a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e5c:	02b57563          	bgeu	a0,a1,e86 <memmove+0x32>
    while(n-- > 0)
     e60:	00c05f63          	blez	a2,e7e <memmove+0x2a>
     e64:	1602                	slli	a2,a2,0x20
     e66:	9201                	srli	a2,a2,0x20
     e68:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e6c:	872a                	mv	a4,a0
      *dst++ = *src++;
     e6e:	0585                	addi	a1,a1,1
     e70:	0705                	addi	a4,a4,1
     e72:	fff5c683          	lbu	a3,-1(a1)
     e76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e7a:	fee79ae3          	bne	a5,a4,e6e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e7e:	60a2                	ld	ra,8(sp)
     e80:	6402                	ld	s0,0(sp)
     e82:	0141                	addi	sp,sp,16
     e84:	8082                	ret
    dst += n;
     e86:	00c50733          	add	a4,a0,a2
    src += n;
     e8a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e8c:	fec059e3          	blez	a2,e7e <memmove+0x2a>
     e90:	fff6079b          	addiw	a5,a2,-1
     e94:	1782                	slli	a5,a5,0x20
     e96:	9381                	srli	a5,a5,0x20
     e98:	fff7c793          	not	a5,a5
     e9c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e9e:	15fd                	addi	a1,a1,-1
     ea0:	177d                	addi	a4,a4,-1
     ea2:	0005c683          	lbu	a3,0(a1)
     ea6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     eaa:	fef71ae3          	bne	a4,a5,e9e <memmove+0x4a>
     eae:	bfc1                	j	e7e <memmove+0x2a>

0000000000000eb0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     eb0:	1141                	addi	sp,sp,-16
     eb2:	e406                	sd	ra,8(sp)
     eb4:	e022                	sd	s0,0(sp)
     eb6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     eb8:	ca0d                	beqz	a2,eea <memcmp+0x3a>
     eba:	fff6069b          	addiw	a3,a2,-1
     ebe:	1682                	slli	a3,a3,0x20
     ec0:	9281                	srli	a3,a3,0x20
     ec2:	0685                	addi	a3,a3,1
     ec4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ec6:	00054783          	lbu	a5,0(a0)
     eca:	0005c703          	lbu	a4,0(a1)
     ece:	00e79863          	bne	a5,a4,ede <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     ed2:	0505                	addi	a0,a0,1
    p2++;
     ed4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ed6:	fed518e3          	bne	a0,a3,ec6 <memcmp+0x16>
  }
  return 0;
     eda:	4501                	li	a0,0
     edc:	a019                	j	ee2 <memcmp+0x32>
      return *p1 - *p2;
     ede:	40e7853b          	subw	a0,a5,a4
}
     ee2:	60a2                	ld	ra,8(sp)
     ee4:	6402                	ld	s0,0(sp)
     ee6:	0141                	addi	sp,sp,16
     ee8:	8082                	ret
  return 0;
     eea:	4501                	li	a0,0
     eec:	bfdd                	j	ee2 <memcmp+0x32>

0000000000000eee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     eee:	1141                	addi	sp,sp,-16
     ef0:	e406                	sd	ra,8(sp)
     ef2:	e022                	sd	s0,0(sp)
     ef4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ef6:	00000097          	auipc	ra,0x0
     efa:	f5e080e7          	jalr	-162(ra) # e54 <memmove>
}
     efe:	60a2                	ld	ra,8(sp)
     f00:	6402                	ld	s0,0(sp)
     f02:	0141                	addi	sp,sp,16
     f04:	8082                	ret

0000000000000f06 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f06:	4885                	li	a7,1
 ecall
     f08:	00000073          	ecall
 ret
     f0c:	8082                	ret

0000000000000f0e <exit>:
.global exit
exit:
 li a7, SYS_exit
     f0e:	4889                	li	a7,2
 ecall
     f10:	00000073          	ecall
 ret
     f14:	8082                	ret

0000000000000f16 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f16:	488d                	li	a7,3
 ecall
     f18:	00000073          	ecall
 ret
     f1c:	8082                	ret

0000000000000f1e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f1e:	4891                	li	a7,4
 ecall
     f20:	00000073          	ecall
 ret
     f24:	8082                	ret

0000000000000f26 <read>:
.global read
read:
 li a7, SYS_read
     f26:	4895                	li	a7,5
 ecall
     f28:	00000073          	ecall
 ret
     f2c:	8082                	ret

0000000000000f2e <write>:
.global write
write:
 li a7, SYS_write
     f2e:	48c1                	li	a7,16
 ecall
     f30:	00000073          	ecall
 ret
     f34:	8082                	ret

0000000000000f36 <close>:
.global close
close:
 li a7, SYS_close
     f36:	48d5                	li	a7,21
 ecall
     f38:	00000073          	ecall
 ret
     f3c:	8082                	ret

0000000000000f3e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f3e:	4899                	li	a7,6
 ecall
     f40:	00000073          	ecall
 ret
     f44:	8082                	ret

0000000000000f46 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f46:	489d                	li	a7,7
 ecall
     f48:	00000073          	ecall
 ret
     f4c:	8082                	ret

0000000000000f4e <open>:
.global open
open:
 li a7, SYS_open
     f4e:	48bd                	li	a7,15
 ecall
     f50:	00000073          	ecall
 ret
     f54:	8082                	ret

0000000000000f56 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f56:	48c5                	li	a7,17
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f5e:	48c9                	li	a7,18
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f66:	48a1                	li	a7,8
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <link>:
.global link
link:
 li a7, SYS_link
     f6e:	48cd                	li	a7,19
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f76:	48d1                	li	a7,20
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f7e:	48a5                	li	a7,9
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f86:	48a9                	li	a7,10
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f8e:	48ad                	li	a7,11
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f96:	48b1                	li	a7,12
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f9e:	48b5                	li	a7,13
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     fa6:	48b9                	li	a7,14
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
     fae:	48d9                	li	a7,22
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     fb6:	48dd                	li	a7,23
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
     fbe:	48e1                	li	a7,24
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
     fc6:	48e5                	li	a7,25
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
     fce:	48e9                	li	a7,26
 ecall
     fd0:	00000073          	ecall
 ret
     fd4:	8082                	ret

0000000000000fd6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fd6:	1101                	addi	sp,sp,-32
     fd8:	ec06                	sd	ra,24(sp)
     fda:	e822                	sd	s0,16(sp)
     fdc:	1000                	addi	s0,sp,32
     fde:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fe2:	4605                	li	a2,1
     fe4:	fef40593          	addi	a1,s0,-17
     fe8:	00000097          	auipc	ra,0x0
     fec:	f46080e7          	jalr	-186(ra) # f2e <write>
}
     ff0:	60e2                	ld	ra,24(sp)
     ff2:	6442                	ld	s0,16(sp)
     ff4:	6105                	addi	sp,sp,32
     ff6:	8082                	ret

0000000000000ff8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ff8:	7139                	addi	sp,sp,-64
     ffa:	fc06                	sd	ra,56(sp)
     ffc:	f822                	sd	s0,48(sp)
     ffe:	f426                	sd	s1,40(sp)
    1000:	f04a                	sd	s2,32(sp)
    1002:	ec4e                	sd	s3,24(sp)
    1004:	0080                	addi	s0,sp,64
    1006:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1008:	c299                	beqz	a3,100e <printint+0x16>
    100a:	0805c063          	bltz	a1,108a <printint+0x92>
  neg = 0;
    100e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1010:	fc040313          	addi	t1,s0,-64
  neg = 0;
    1014:	869a                	mv	a3,t1
  i = 0;
    1016:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    1018:	00001817          	auipc	a6,0x1
    101c:	80080813          	addi	a6,a6,-2048 # 1818 <digits>
    1020:	88be                	mv	a7,a5
    1022:	0017851b          	addiw	a0,a5,1
    1026:	87aa                	mv	a5,a0
    1028:	02c5f73b          	remuw	a4,a1,a2
    102c:	1702                	slli	a4,a4,0x20
    102e:	9301                	srli	a4,a4,0x20
    1030:	9742                	add	a4,a4,a6
    1032:	00074703          	lbu	a4,0(a4)
    1036:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    103a:	872e                	mv	a4,a1
    103c:	02c5d5bb          	divuw	a1,a1,a2
    1040:	0685                	addi	a3,a3,1
    1042:	fcc77fe3          	bgeu	a4,a2,1020 <printint+0x28>
  if(neg)
    1046:	000e0c63          	beqz	t3,105e <printint+0x66>
    buf[i++] = '-';
    104a:	fd050793          	addi	a5,a0,-48
    104e:	00878533          	add	a0,a5,s0
    1052:	02d00793          	li	a5,45
    1056:	fef50823          	sb	a5,-16(a0)
    105a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    105e:	fff7899b          	addiw	s3,a5,-1
    1062:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    1066:	fff4c583          	lbu	a1,-1(s1)
    106a:	854a                	mv	a0,s2
    106c:	00000097          	auipc	ra,0x0
    1070:	f6a080e7          	jalr	-150(ra) # fd6 <putc>
  while(--i >= 0)
    1074:	39fd                	addiw	s3,s3,-1
    1076:	14fd                	addi	s1,s1,-1
    1078:	fe09d7e3          	bgez	s3,1066 <printint+0x6e>
}
    107c:	70e2                	ld	ra,56(sp)
    107e:	7442                	ld	s0,48(sp)
    1080:	74a2                	ld	s1,40(sp)
    1082:	7902                	ld	s2,32(sp)
    1084:	69e2                	ld	s3,24(sp)
    1086:	6121                	addi	sp,sp,64
    1088:	8082                	ret
    x = -xx;
    108a:	40b005bb          	negw	a1,a1
    neg = 1;
    108e:	4e05                	li	t3,1
    x = -xx;
    1090:	b741                	j	1010 <printint+0x18>

0000000000001092 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1092:	715d                	addi	sp,sp,-80
    1094:	e486                	sd	ra,72(sp)
    1096:	e0a2                	sd	s0,64(sp)
    1098:	f84a                	sd	s2,48(sp)
    109a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    109c:	0005c903          	lbu	s2,0(a1)
    10a0:	1a090a63          	beqz	s2,1254 <vprintf+0x1c2>
    10a4:	fc26                	sd	s1,56(sp)
    10a6:	f44e                	sd	s3,40(sp)
    10a8:	f052                	sd	s4,32(sp)
    10aa:	ec56                	sd	s5,24(sp)
    10ac:	e85a                	sd	s6,16(sp)
    10ae:	e45e                	sd	s7,8(sp)
    10b0:	8aaa                	mv	s5,a0
    10b2:	8bb2                	mv	s7,a2
    10b4:	00158493          	addi	s1,a1,1
  state = 0;
    10b8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10ba:	02500a13          	li	s4,37
    10be:	4b55                	li	s6,21
    10c0:	a839                	j	10de <vprintf+0x4c>
        putc(fd, c);
    10c2:	85ca                	mv	a1,s2
    10c4:	8556                	mv	a0,s5
    10c6:	00000097          	auipc	ra,0x0
    10ca:	f10080e7          	jalr	-240(ra) # fd6 <putc>
    10ce:	a019                	j	10d4 <vprintf+0x42>
    } else if(state == '%'){
    10d0:	01498d63          	beq	s3,s4,10ea <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10d4:	0485                	addi	s1,s1,1
    10d6:	fff4c903          	lbu	s2,-1(s1)
    10da:	16090763          	beqz	s2,1248 <vprintf+0x1b6>
    if(state == 0){
    10de:	fe0999e3          	bnez	s3,10d0 <vprintf+0x3e>
      if(c == '%'){
    10e2:	ff4910e3          	bne	s2,s4,10c2 <vprintf+0x30>
        state = '%';
    10e6:	89d2                	mv	s3,s4
    10e8:	b7f5                	j	10d4 <vprintf+0x42>
      if(c == 'd'){
    10ea:	13490463          	beq	s2,s4,1212 <vprintf+0x180>
    10ee:	f9d9079b          	addiw	a5,s2,-99
    10f2:	0ff7f793          	zext.b	a5,a5
    10f6:	12fb6763          	bltu	s6,a5,1224 <vprintf+0x192>
    10fa:	f9d9079b          	addiw	a5,s2,-99
    10fe:	0ff7f713          	zext.b	a4,a5
    1102:	12eb6163          	bltu	s6,a4,1224 <vprintf+0x192>
    1106:	00271793          	slli	a5,a4,0x2
    110a:	00000717          	auipc	a4,0x0
    110e:	6b670713          	addi	a4,a4,1718 # 17c0 <malloc+0x478>
    1112:	97ba                	add	a5,a5,a4
    1114:	439c                	lw	a5,0(a5)
    1116:	97ba                	add	a5,a5,a4
    1118:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    111a:	008b8913          	addi	s2,s7,8
    111e:	4685                	li	a3,1
    1120:	4629                	li	a2,10
    1122:	000ba583          	lw	a1,0(s7)
    1126:	8556                	mv	a0,s5
    1128:	00000097          	auipc	ra,0x0
    112c:	ed0080e7          	jalr	-304(ra) # ff8 <printint>
    1130:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1132:	4981                	li	s3,0
    1134:	b745                	j	10d4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1136:	008b8913          	addi	s2,s7,8
    113a:	4681                	li	a3,0
    113c:	4629                	li	a2,10
    113e:	000ba583          	lw	a1,0(s7)
    1142:	8556                	mv	a0,s5
    1144:	00000097          	auipc	ra,0x0
    1148:	eb4080e7          	jalr	-332(ra) # ff8 <printint>
    114c:	8bca                	mv	s7,s2
      state = 0;
    114e:	4981                	li	s3,0
    1150:	b751                	j	10d4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1152:	008b8913          	addi	s2,s7,8
    1156:	4681                	li	a3,0
    1158:	4641                	li	a2,16
    115a:	000ba583          	lw	a1,0(s7)
    115e:	8556                	mv	a0,s5
    1160:	00000097          	auipc	ra,0x0
    1164:	e98080e7          	jalr	-360(ra) # ff8 <printint>
    1168:	8bca                	mv	s7,s2
      state = 0;
    116a:	4981                	li	s3,0
    116c:	b7a5                	j	10d4 <vprintf+0x42>
    116e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1170:	008b8c13          	addi	s8,s7,8
    1174:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1178:	03000593          	li	a1,48
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	e58080e7          	jalr	-424(ra) # fd6 <putc>
  putc(fd, 'x');
    1186:	07800593          	li	a1,120
    118a:	8556                	mv	a0,s5
    118c:	00000097          	auipc	ra,0x0
    1190:	e4a080e7          	jalr	-438(ra) # fd6 <putc>
    1194:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1196:	00000b97          	auipc	s7,0x0
    119a:	682b8b93          	addi	s7,s7,1666 # 1818 <digits>
    119e:	03c9d793          	srli	a5,s3,0x3c
    11a2:	97de                	add	a5,a5,s7
    11a4:	0007c583          	lbu	a1,0(a5)
    11a8:	8556                	mv	a0,s5
    11aa:	00000097          	auipc	ra,0x0
    11ae:	e2c080e7          	jalr	-468(ra) # fd6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11b2:	0992                	slli	s3,s3,0x4
    11b4:	397d                	addiw	s2,s2,-1
    11b6:	fe0914e3          	bnez	s2,119e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    11ba:	8be2                	mv	s7,s8
      state = 0;
    11bc:	4981                	li	s3,0
    11be:	6c02                	ld	s8,0(sp)
    11c0:	bf11                	j	10d4 <vprintf+0x42>
        s = va_arg(ap, char*);
    11c2:	008b8993          	addi	s3,s7,8
    11c6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11ca:	02090163          	beqz	s2,11ec <vprintf+0x15a>
        while(*s != 0){
    11ce:	00094583          	lbu	a1,0(s2)
    11d2:	c9a5                	beqz	a1,1242 <vprintf+0x1b0>
          putc(fd, *s);
    11d4:	8556                	mv	a0,s5
    11d6:	00000097          	auipc	ra,0x0
    11da:	e00080e7          	jalr	-512(ra) # fd6 <putc>
          s++;
    11de:	0905                	addi	s2,s2,1
        while(*s != 0){
    11e0:	00094583          	lbu	a1,0(s2)
    11e4:	f9e5                	bnez	a1,11d4 <vprintf+0x142>
        s = va_arg(ap, char*);
    11e6:	8bce                	mv	s7,s3
      state = 0;
    11e8:	4981                	li	s3,0
    11ea:	b5ed                	j	10d4 <vprintf+0x42>
          s = "(null)";
    11ec:	00000917          	auipc	s2,0x0
    11f0:	56c90913          	addi	s2,s2,1388 # 1758 <malloc+0x410>
        while(*s != 0){
    11f4:	02800593          	li	a1,40
    11f8:	bff1                	j	11d4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    11fa:	008b8913          	addi	s2,s7,8
    11fe:	000bc583          	lbu	a1,0(s7)
    1202:	8556                	mv	a0,s5
    1204:	00000097          	auipc	ra,0x0
    1208:	dd2080e7          	jalr	-558(ra) # fd6 <putc>
    120c:	8bca                	mv	s7,s2
      state = 0;
    120e:	4981                	li	s3,0
    1210:	b5d1                	j	10d4 <vprintf+0x42>
        putc(fd, c);
    1212:	02500593          	li	a1,37
    1216:	8556                	mv	a0,s5
    1218:	00000097          	auipc	ra,0x0
    121c:	dbe080e7          	jalr	-578(ra) # fd6 <putc>
      state = 0;
    1220:	4981                	li	s3,0
    1222:	bd4d                	j	10d4 <vprintf+0x42>
        putc(fd, '%');
    1224:	02500593          	li	a1,37
    1228:	8556                	mv	a0,s5
    122a:	00000097          	auipc	ra,0x0
    122e:	dac080e7          	jalr	-596(ra) # fd6 <putc>
        putc(fd, c);
    1232:	85ca                	mv	a1,s2
    1234:	8556                	mv	a0,s5
    1236:	00000097          	auipc	ra,0x0
    123a:	da0080e7          	jalr	-608(ra) # fd6 <putc>
      state = 0;
    123e:	4981                	li	s3,0
    1240:	bd51                	j	10d4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1242:	8bce                	mv	s7,s3
      state = 0;
    1244:	4981                	li	s3,0
    1246:	b579                	j	10d4 <vprintf+0x42>
    1248:	74e2                	ld	s1,56(sp)
    124a:	79a2                	ld	s3,40(sp)
    124c:	7a02                	ld	s4,32(sp)
    124e:	6ae2                	ld	s5,24(sp)
    1250:	6b42                	ld	s6,16(sp)
    1252:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1254:	60a6                	ld	ra,72(sp)
    1256:	6406                	ld	s0,64(sp)
    1258:	7942                	ld	s2,48(sp)
    125a:	6161                	addi	sp,sp,80
    125c:	8082                	ret

000000000000125e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    125e:	715d                	addi	sp,sp,-80
    1260:	ec06                	sd	ra,24(sp)
    1262:	e822                	sd	s0,16(sp)
    1264:	1000                	addi	s0,sp,32
    1266:	e010                	sd	a2,0(s0)
    1268:	e414                	sd	a3,8(s0)
    126a:	e818                	sd	a4,16(s0)
    126c:	ec1c                	sd	a5,24(s0)
    126e:	03043023          	sd	a6,32(s0)
    1272:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1276:	8622                	mv	a2,s0
    1278:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    127c:	00000097          	auipc	ra,0x0
    1280:	e16080e7          	jalr	-490(ra) # 1092 <vprintf>
}
    1284:	60e2                	ld	ra,24(sp)
    1286:	6442                	ld	s0,16(sp)
    1288:	6161                	addi	sp,sp,80
    128a:	8082                	ret

000000000000128c <printf>:

void
printf(const char *fmt, ...)
{
    128c:	711d                	addi	sp,sp,-96
    128e:	ec06                	sd	ra,24(sp)
    1290:	e822                	sd	s0,16(sp)
    1292:	1000                	addi	s0,sp,32
    1294:	e40c                	sd	a1,8(s0)
    1296:	e810                	sd	a2,16(s0)
    1298:	ec14                	sd	a3,24(s0)
    129a:	f018                	sd	a4,32(s0)
    129c:	f41c                	sd	a5,40(s0)
    129e:	03043823          	sd	a6,48(s0)
    12a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12a6:	00840613          	addi	a2,s0,8
    12aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12ae:	85aa                	mv	a1,a0
    12b0:	4505                	li	a0,1
    12b2:	00000097          	auipc	ra,0x0
    12b6:	de0080e7          	jalr	-544(ra) # 1092 <vprintf>
}
    12ba:	60e2                	ld	ra,24(sp)
    12bc:	6442                	ld	s0,16(sp)
    12be:	6125                	addi	sp,sp,96
    12c0:	8082                	ret

00000000000012c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12c2:	1141                	addi	sp,sp,-16
    12c4:	e406                	sd	ra,8(sp)
    12c6:	e022                	sd	s0,0(sp)
    12c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ce:	00001797          	auipc	a5,0x1
    12d2:	d427b783          	ld	a5,-702(a5) # 2010 <freep>
    12d6:	a02d                	j	1300 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12d8:	4618                	lw	a4,8(a2)
    12da:	9f2d                	addw	a4,a4,a1
    12dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12e0:	6398                	ld	a4,0(a5)
    12e2:	6310                	ld	a2,0(a4)
    12e4:	a83d                	j	1322 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12e6:	ff852703          	lw	a4,-8(a0)
    12ea:	9f31                	addw	a4,a4,a2
    12ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12ee:	ff053683          	ld	a3,-16(a0)
    12f2:	a091                	j	1336 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12f4:	6398                	ld	a4,0(a5)
    12f6:	00e7e463          	bltu	a5,a4,12fe <free+0x3c>
    12fa:	00e6ea63          	bltu	a3,a4,130e <free+0x4c>
{
    12fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1300:	fed7fae3          	bgeu	a5,a3,12f4 <free+0x32>
    1304:	6398                	ld	a4,0(a5)
    1306:	00e6e463          	bltu	a3,a4,130e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    130a:	fee7eae3          	bltu	a5,a4,12fe <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    130e:	ff852583          	lw	a1,-8(a0)
    1312:	6390                	ld	a2,0(a5)
    1314:	02059813          	slli	a6,a1,0x20
    1318:	01c85713          	srli	a4,a6,0x1c
    131c:	9736                	add	a4,a4,a3
    131e:	fae60de3          	beq	a2,a4,12d8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1322:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1326:	4790                	lw	a2,8(a5)
    1328:	02061593          	slli	a1,a2,0x20
    132c:	01c5d713          	srli	a4,a1,0x1c
    1330:	973e                	add	a4,a4,a5
    1332:	fae68ae3          	beq	a3,a4,12e6 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1336:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1338:	00001717          	auipc	a4,0x1
    133c:	ccf73c23          	sd	a5,-808(a4) # 2010 <freep>
}
    1340:	60a2                	ld	ra,8(sp)
    1342:	6402                	ld	s0,0(sp)
    1344:	0141                	addi	sp,sp,16
    1346:	8082                	ret

0000000000001348 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1348:	7139                	addi	sp,sp,-64
    134a:	fc06                	sd	ra,56(sp)
    134c:	f822                	sd	s0,48(sp)
    134e:	f04a                	sd	s2,32(sp)
    1350:	ec4e                	sd	s3,24(sp)
    1352:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1354:	02051993          	slli	s3,a0,0x20
    1358:	0209d993          	srli	s3,s3,0x20
    135c:	09bd                	addi	s3,s3,15
    135e:	0049d993          	srli	s3,s3,0x4
    1362:	2985                	addiw	s3,s3,1
    1364:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1366:	00001517          	auipc	a0,0x1
    136a:	caa53503          	ld	a0,-854(a0) # 2010 <freep>
    136e:	c905                	beqz	a0,139e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1370:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1372:	4798                	lw	a4,8(a5)
    1374:	09377a63          	bgeu	a4,s3,1408 <malloc+0xc0>
    1378:	f426                	sd	s1,40(sp)
    137a:	e852                	sd	s4,16(sp)
    137c:	e456                	sd	s5,8(sp)
    137e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1380:	8a4e                	mv	s4,s3
    1382:	6705                	lui	a4,0x1
    1384:	00e9f363          	bgeu	s3,a4,138a <malloc+0x42>
    1388:	6a05                	lui	s4,0x1
    138a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    138e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1392:	00001497          	auipc	s1,0x1
    1396:	c7e48493          	addi	s1,s1,-898 # 2010 <freep>
  if(p == (char*)-1)
    139a:	5afd                	li	s5,-1
    139c:	a089                	j	13de <malloc+0x96>
    139e:	f426                	sd	s1,40(sp)
    13a0:	e852                	sd	s4,16(sp)
    13a2:	e456                	sd	s5,8(sp)
    13a4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13a6:	00001797          	auipc	a5,0x1
    13aa:	06278793          	addi	a5,a5,98 # 2408 <base>
    13ae:	00001717          	auipc	a4,0x1
    13b2:	c6f73123          	sd	a5,-926(a4) # 2010 <freep>
    13b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13bc:	b7d1                	j	1380 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    13be:	6398                	ld	a4,0(a5)
    13c0:	e118                	sd	a4,0(a0)
    13c2:	a8b9                	j	1420 <malloc+0xd8>
  hp->s.size = nu;
    13c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13c8:	0541                	addi	a0,a0,16
    13ca:	00000097          	auipc	ra,0x0
    13ce:	ef8080e7          	jalr	-264(ra) # 12c2 <free>
  return freep;
    13d2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13d4:	c135                	beqz	a0,1438 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13d8:	4798                	lw	a4,8(a5)
    13da:	03277363          	bgeu	a4,s2,1400 <malloc+0xb8>
    if(p == freep)
    13de:	6098                	ld	a4,0(s1)
    13e0:	853e                	mv	a0,a5
    13e2:	fef71ae3          	bne	a4,a5,13d6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    13e6:	8552                	mv	a0,s4
    13e8:	00000097          	auipc	ra,0x0
    13ec:	bae080e7          	jalr	-1106(ra) # f96 <sbrk>
  if(p == (char*)-1)
    13f0:	fd551ae3          	bne	a0,s5,13c4 <malloc+0x7c>
        return 0;
    13f4:	4501                	li	a0,0
    13f6:	74a2                	ld	s1,40(sp)
    13f8:	6a42                	ld	s4,16(sp)
    13fa:	6aa2                	ld	s5,8(sp)
    13fc:	6b02                	ld	s6,0(sp)
    13fe:	a03d                	j	142c <malloc+0xe4>
    1400:	74a2                	ld	s1,40(sp)
    1402:	6a42                	ld	s4,16(sp)
    1404:	6aa2                	ld	s5,8(sp)
    1406:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1408:	fae90be3          	beq	s2,a4,13be <malloc+0x76>
        p->s.size -= nunits;
    140c:	4137073b          	subw	a4,a4,s3
    1410:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1412:	02071693          	slli	a3,a4,0x20
    1416:	01c6d713          	srli	a4,a3,0x1c
    141a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    141c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1420:	00001717          	auipc	a4,0x1
    1424:	bea73823          	sd	a0,-1040(a4) # 2010 <freep>
      return (void*)(p + 1);
    1428:	01078513          	addi	a0,a5,16
  }
}
    142c:	70e2                	ld	ra,56(sp)
    142e:	7442                	ld	s0,48(sp)
    1430:	7902                	ld	s2,32(sp)
    1432:	69e2                	ld	s3,24(sp)
    1434:	6121                	addi	sp,sp,64
    1436:	8082                	ret
    1438:	74a2                	ld	s1,40(sp)
    143a:	6a42                	ld	s4,16(sp)
    143c:	6aa2                	ld	s5,8(sp)
    143e:	6b02                	ld	s6,0(sp)
    1440:	b7f5                	j	142c <malloc+0xe4>
