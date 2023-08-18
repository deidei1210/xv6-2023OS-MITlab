
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	add	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xor	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	add	a3,a3,797 # 1f31d <__global_pointer$+0x1d474>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	add	a2,a2,423 # 41a7 <__global_pointer$+0x22fe>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd643>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	add	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	add	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	add	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	65050513          	add	a0,a0,1616 # 16b0 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	add	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7119                	add	sp,sp,-128
      7a:	fc86                	sd	ra,120(sp)
      7c:	f8a2                	sd	s0,112(sp)
      7e:	f4a6                	sd	s1,104(sp)
      80:	f0ca                	sd	s2,96(sp)
      82:	ecce                	sd	s3,88(sp)
      84:	e8d2                	sd	s4,80(sp)
      86:	e4d6                	sd	s5,72(sp)
      88:	e0da                	sd	s6,64(sp)
      8a:	fc5e                	sd	s7,56(sp)
      8c:	0100                	add	s0,sp,128
      8e:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      90:	4501                	li	a0,0
      92:	00001097          	auipc	ra,0x1
      96:	dde080e7          	jalr	-546(ra) # e70 <sbrk>
      9a:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9c:	00001517          	auipc	a0,0x1
      a0:	25c50513          	add	a0,a0,604 # 12f8 <malloc+0xe8>
      a4:	00001097          	auipc	ra,0x1
      a8:	dac080e7          	jalr	-596(ra) # e50 <mkdir>
  if(chdir("grindir") != 0){
      ac:	00001517          	auipc	a0,0x1
      b0:	24c50513          	add	a0,a0,588 # 12f8 <malloc+0xe8>
      b4:	00001097          	auipc	ra,0x1
      b8:	da4080e7          	jalr	-604(ra) # e58 <chdir>
      bc:	cd11                	beqz	a0,d8 <go+0x60>
    printf("grind: chdir grindir failed\n");
      be:	00001517          	auipc	a0,0x1
      c2:	24250513          	add	a0,a0,578 # 1300 <malloc+0xf0>
      c6:	00001097          	auipc	ra,0x1
      ca:	092080e7          	jalr	146(ra) # 1158 <printf>
    exit(1);
      ce:	4505                	li	a0,1
      d0:	00001097          	auipc	ra,0x1
      d4:	d18080e7          	jalr	-744(ra) # de8 <exit>
  }
  chdir("/");
      d8:	00001517          	auipc	a0,0x1
      dc:	24850513          	add	a0,a0,584 # 1320 <malloc+0x110>
      e0:	00001097          	auipc	ra,0x1
      e4:	d78080e7          	jalr	-648(ra) # e58 <chdir>
      e8:	00001997          	auipc	s3,0x1
      ec:	24898993          	add	s3,s3,584 # 1330 <malloc+0x120>
      f0:	c489                	beqz	s1,fa <go+0x82>
      f2:	00001997          	auipc	s3,0x1
      f6:	23698993          	add	s3,s3,566 # 1328 <malloc+0x118>
  uint64 iters = 0;
      fa:	4481                	li	s1,0
  int fd = -1;
      fc:	5a7d                	li	s4,-1
      fe:	00001917          	auipc	s2,0x1
     102:	4da90913          	add	s2,s2,1242 # 15d8 <malloc+0x3c8>
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     106:	00001b17          	auipc	s6,0x1
     10a:	5bab0b13          	add	s6,s6,1466 # 16c0 <buf.0>
     10e:	a839                	j	12c <go+0xb4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     110:	20200593          	li	a1,514
     114:	00001517          	auipc	a0,0x1
     118:	22450513          	add	a0,a0,548 # 1338 <malloc+0x128>
     11c:	00001097          	auipc	ra,0x1
     120:	d0c080e7          	jalr	-756(ra) # e28 <open>
     124:	00001097          	auipc	ra,0x1
     128:	cec080e7          	jalr	-788(ra) # e10 <close>
    iters++;
     12c:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     12e:	1f400793          	li	a5,500
     132:	02f4f7b3          	remu	a5,s1,a5
     136:	eb81                	bnez	a5,146 <go+0xce>
      write(1, which_child?"B":"A", 1);
     138:	4605                	li	a2,1
     13a:	85ce                	mv	a1,s3
     13c:	4505                	li	a0,1
     13e:	00001097          	auipc	ra,0x1
     142:	cca080e7          	jalr	-822(ra) # e08 <write>
    int what = rand() % 23;
     146:	00000097          	auipc	ra,0x0
     14a:	f12080e7          	jalr	-238(ra) # 58 <rand>
     14e:	47dd                	li	a5,23
     150:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     154:	4785                	li	a5,1
     156:	faf50de3          	beq	a0,a5,110 <go+0x98>
    } else if(what == 2){
     15a:	47d9                	li	a5,22
     15c:	fca7e8e3          	bltu	a5,a0,12c <go+0xb4>
     160:	050a                	sll	a0,a0,0x2
     162:	954a                	add	a0,a0,s2
     164:	411c                	lw	a5,0(a0)
     166:	97ca                	add	a5,a5,s2
     168:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16a:	20200593          	li	a1,514
     16e:	00001517          	auipc	a0,0x1
     172:	1da50513          	add	a0,a0,474 # 1348 <malloc+0x138>
     176:	00001097          	auipc	ra,0x1
     17a:	cb2080e7          	jalr	-846(ra) # e28 <open>
     17e:	00001097          	auipc	ra,0x1
     182:	c92080e7          	jalr	-878(ra) # e10 <close>
     186:	b75d                	j	12c <go+0xb4>
      unlink("grindir/../a");
     188:	00001517          	auipc	a0,0x1
     18c:	1b050513          	add	a0,a0,432 # 1338 <malloc+0x128>
     190:	00001097          	auipc	ra,0x1
     194:	ca8080e7          	jalr	-856(ra) # e38 <unlink>
     198:	bf51                	j	12c <go+0xb4>
      if(chdir("grindir") != 0){
     19a:	00001517          	auipc	a0,0x1
     19e:	15e50513          	add	a0,a0,350 # 12f8 <malloc+0xe8>
     1a2:	00001097          	auipc	ra,0x1
     1a6:	cb6080e7          	jalr	-842(ra) # e58 <chdir>
     1aa:	e115                	bnez	a0,1ce <go+0x156>
      unlink("../b");
     1ac:	00001517          	auipc	a0,0x1
     1b0:	1b450513          	add	a0,a0,436 # 1360 <malloc+0x150>
     1b4:	00001097          	auipc	ra,0x1
     1b8:	c84080e7          	jalr	-892(ra) # e38 <unlink>
      chdir("/");
     1bc:	00001517          	auipc	a0,0x1
     1c0:	16450513          	add	a0,a0,356 # 1320 <malloc+0x110>
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c94080e7          	jalr	-876(ra) # e58 <chdir>
     1cc:	b785                	j	12c <go+0xb4>
        printf("grind: chdir grindir failed\n");
     1ce:	00001517          	auipc	a0,0x1
     1d2:	13250513          	add	a0,a0,306 # 1300 <malloc+0xf0>
     1d6:	00001097          	auipc	ra,0x1
     1da:	f82080e7          	jalr	-126(ra) # 1158 <printf>
        exit(1);
     1de:	4505                	li	a0,1
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c08080e7          	jalr	-1016(ra) # de8 <exit>
      close(fd);
     1e8:	8552                	mv	a0,s4
     1ea:	00001097          	auipc	ra,0x1
     1ee:	c26080e7          	jalr	-986(ra) # e10 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f2:	20200593          	li	a1,514
     1f6:	00001517          	auipc	a0,0x1
     1fa:	17250513          	add	a0,a0,370 # 1368 <malloc+0x158>
     1fe:	00001097          	auipc	ra,0x1
     202:	c2a080e7          	jalr	-982(ra) # e28 <open>
     206:	8a2a                	mv	s4,a0
     208:	b715                	j	12c <go+0xb4>
      close(fd);
     20a:	8552                	mv	a0,s4
     20c:	00001097          	auipc	ra,0x1
     210:	c04080e7          	jalr	-1020(ra) # e10 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	00001517          	auipc	a0,0x1
     21c:	16050513          	add	a0,a0,352 # 1378 <malloc+0x168>
     220:	00001097          	auipc	ra,0x1
     224:	c08080e7          	jalr	-1016(ra) # e28 <open>
     228:	8a2a                	mv	s4,a0
     22a:	b709                	j	12c <go+0xb4>
      write(fd, buf, sizeof(buf));
     22c:	3e700613          	li	a2,999
     230:	85da                	mv	a1,s6
     232:	8552                	mv	a0,s4
     234:	00001097          	auipc	ra,0x1
     238:	bd4080e7          	jalr	-1068(ra) # e08 <write>
     23c:	bdc5                	j	12c <go+0xb4>
      read(fd, buf, sizeof(buf));
     23e:	3e700613          	li	a2,999
     242:	85da                	mv	a1,s6
     244:	8552                	mv	a0,s4
     246:	00001097          	auipc	ra,0x1
     24a:	bba080e7          	jalr	-1094(ra) # e00 <read>
     24e:	bdf9                	j	12c <go+0xb4>
    } else if(what == 9){
      mkdir("grindir/../a");
     250:	00001517          	auipc	a0,0x1
     254:	0e850513          	add	a0,a0,232 # 1338 <malloc+0x128>
     258:	00001097          	auipc	ra,0x1
     25c:	bf8080e7          	jalr	-1032(ra) # e50 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     260:	20200593          	li	a1,514
     264:	00001517          	auipc	a0,0x1
     268:	12c50513          	add	a0,a0,300 # 1390 <malloc+0x180>
     26c:	00001097          	auipc	ra,0x1
     270:	bbc080e7          	jalr	-1092(ra) # e28 <open>
     274:	00001097          	auipc	ra,0x1
     278:	b9c080e7          	jalr	-1124(ra) # e10 <close>
      unlink("a/a");
     27c:	00001517          	auipc	a0,0x1
     280:	12450513          	add	a0,a0,292 # 13a0 <malloc+0x190>
     284:	00001097          	auipc	ra,0x1
     288:	bb4080e7          	jalr	-1100(ra) # e38 <unlink>
     28c:	b545                	j	12c <go+0xb4>
    } else if(what == 10){
      mkdir("/../b");
     28e:	00001517          	auipc	a0,0x1
     292:	11a50513          	add	a0,a0,282 # 13a8 <malloc+0x198>
     296:	00001097          	auipc	ra,0x1
     29a:	bba080e7          	jalr	-1094(ra) # e50 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     29e:	20200593          	li	a1,514
     2a2:	00001517          	auipc	a0,0x1
     2a6:	10e50513          	add	a0,a0,270 # 13b0 <malloc+0x1a0>
     2aa:	00001097          	auipc	ra,0x1
     2ae:	b7e080e7          	jalr	-1154(ra) # e28 <open>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	b5e080e7          	jalr	-1186(ra) # e10 <close>
      unlink("b/b");
     2ba:	00001517          	auipc	a0,0x1
     2be:	10650513          	add	a0,a0,262 # 13c0 <malloc+0x1b0>
     2c2:	00001097          	auipc	ra,0x1
     2c6:	b76080e7          	jalr	-1162(ra) # e38 <unlink>
     2ca:	b58d                	j	12c <go+0xb4>
    } else if(what == 11){
      unlink("b");
     2cc:	00001517          	auipc	a0,0x1
     2d0:	0bc50513          	add	a0,a0,188 # 1388 <malloc+0x178>
     2d4:	00001097          	auipc	ra,0x1
     2d8:	b64080e7          	jalr	-1180(ra) # e38 <unlink>
      link("../grindir/./../a", "../b");
     2dc:	00001597          	auipc	a1,0x1
     2e0:	08458593          	add	a1,a1,132 # 1360 <malloc+0x150>
     2e4:	00001517          	auipc	a0,0x1
     2e8:	0e450513          	add	a0,a0,228 # 13c8 <malloc+0x1b8>
     2ec:	00001097          	auipc	ra,0x1
     2f0:	b5c080e7          	jalr	-1188(ra) # e48 <link>
     2f4:	bd25                	j	12c <go+0xb4>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f6:	00001517          	auipc	a0,0x1
     2fa:	0ea50513          	add	a0,a0,234 # 13e0 <malloc+0x1d0>
     2fe:	00001097          	auipc	ra,0x1
     302:	b3a080e7          	jalr	-1222(ra) # e38 <unlink>
      link(".././b", "/grindir/../a");
     306:	00001597          	auipc	a1,0x1
     30a:	06258593          	add	a1,a1,98 # 1368 <malloc+0x158>
     30e:	00001517          	auipc	a0,0x1
     312:	0e250513          	add	a0,a0,226 # 13f0 <malloc+0x1e0>
     316:	00001097          	auipc	ra,0x1
     31a:	b32080e7          	jalr	-1230(ra) # e48 <link>
     31e:	b539                	j	12c <go+0xb4>
    } else if(what == 13){
      int pid = fork();
     320:	00001097          	auipc	ra,0x1
     324:	ac0080e7          	jalr	-1344(ra) # de0 <fork>
      if(pid == 0){
     328:	c909                	beqz	a0,33a <go+0x2c2>
        exit(0);
      } else if(pid < 0){
     32a:	00054c63          	bltz	a0,342 <go+0x2ca>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     32e:	4501                	li	a0,0
     330:	00001097          	auipc	ra,0x1
     334:	ac0080e7          	jalr	-1344(ra) # df0 <wait>
     338:	bbd5                	j	12c <go+0xb4>
        exit(0);
     33a:	00001097          	auipc	ra,0x1
     33e:	aae080e7          	jalr	-1362(ra) # de8 <exit>
        printf("grind: fork failed\n");
     342:	00001517          	auipc	a0,0x1
     346:	0b650513          	add	a0,a0,182 # 13f8 <malloc+0x1e8>
     34a:	00001097          	auipc	ra,0x1
     34e:	e0e080e7          	jalr	-498(ra) # 1158 <printf>
        exit(1);
     352:	4505                	li	a0,1
     354:	00001097          	auipc	ra,0x1
     358:	a94080e7          	jalr	-1388(ra) # de8 <exit>
    } else if(what == 14){
      int pid = fork();
     35c:	00001097          	auipc	ra,0x1
     360:	a84080e7          	jalr	-1404(ra) # de0 <fork>
      if(pid == 0){
     364:	c909                	beqz	a0,376 <go+0x2fe>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     366:	02054563          	bltz	a0,390 <go+0x318>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36a:	4501                	li	a0,0
     36c:	00001097          	auipc	ra,0x1
     370:	a84080e7          	jalr	-1404(ra) # df0 <wait>
     374:	bb65                	j	12c <go+0xb4>
        fork();
     376:	00001097          	auipc	ra,0x1
     37a:	a6a080e7          	jalr	-1430(ra) # de0 <fork>
        fork();
     37e:	00001097          	auipc	ra,0x1
     382:	a62080e7          	jalr	-1438(ra) # de0 <fork>
        exit(0);
     386:	4501                	li	a0,0
     388:	00001097          	auipc	ra,0x1
     38c:	a60080e7          	jalr	-1440(ra) # de8 <exit>
        printf("grind: fork failed\n");
     390:	00001517          	auipc	a0,0x1
     394:	06850513          	add	a0,a0,104 # 13f8 <malloc+0x1e8>
     398:	00001097          	auipc	ra,0x1
     39c:	dc0080e7          	jalr	-576(ra) # 1158 <printf>
        exit(1);
     3a0:	4505                	li	a0,1
     3a2:	00001097          	auipc	ra,0x1
     3a6:	a46080e7          	jalr	-1466(ra) # de8 <exit>
    } else if(what == 15){
      sbrk(6011);
     3aa:	6505                	lui	a0,0x1
     3ac:	77b50513          	add	a0,a0,1915 # 177b <buf.0+0xbb>
     3b0:	00001097          	auipc	ra,0x1
     3b4:	ac0080e7          	jalr	-1344(ra) # e70 <sbrk>
     3b8:	bb95                	j	12c <go+0xb4>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3ba:	4501                	li	a0,0
     3bc:	00001097          	auipc	ra,0x1
     3c0:	ab4080e7          	jalr	-1356(ra) # e70 <sbrk>
     3c4:	d6aaf4e3          	bgeu	s5,a0,12c <go+0xb4>
        sbrk(-(sbrk(0) - break0));
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	aa6080e7          	jalr	-1370(ra) # e70 <sbrk>
     3d2:	40aa853b          	subw	a0,s5,a0
     3d6:	00001097          	auipc	ra,0x1
     3da:	a9a080e7          	jalr	-1382(ra) # e70 <sbrk>
     3de:	b3b9                	j	12c <go+0xb4>
    } else if(what == 17){
      int pid = fork();
     3e0:	00001097          	auipc	ra,0x1
     3e4:	a00080e7          	jalr	-1536(ra) # de0 <fork>
     3e8:	8baa                	mv	s7,a0
      if(pid == 0){
     3ea:	c51d                	beqz	a0,418 <go+0x3a0>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ec:	04054963          	bltz	a0,43e <go+0x3c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f0:	00001517          	auipc	a0,0x1
     3f4:	02050513          	add	a0,a0,32 # 1410 <malloc+0x200>
     3f8:	00001097          	auipc	ra,0x1
     3fc:	a60080e7          	jalr	-1440(ra) # e58 <chdir>
     400:	ed21                	bnez	a0,458 <go+0x3e0>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     402:	855e                	mv	a0,s7
     404:	00001097          	auipc	ra,0x1
     408:	a14080e7          	jalr	-1516(ra) # e18 <kill>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	9e2080e7          	jalr	-1566(ra) # df0 <wait>
     416:	bb19                	j	12c <go+0xb4>
        close(open("a", O_CREATE|O_RDWR));
     418:	20200593          	li	a1,514
     41c:	00001517          	auipc	a0,0x1
     420:	fbc50513          	add	a0,a0,-68 # 13d8 <malloc+0x1c8>
     424:	00001097          	auipc	ra,0x1
     428:	a04080e7          	jalr	-1532(ra) # e28 <open>
     42c:	00001097          	auipc	ra,0x1
     430:	9e4080e7          	jalr	-1564(ra) # e10 <close>
        exit(0);
     434:	4501                	li	a0,0
     436:	00001097          	auipc	ra,0x1
     43a:	9b2080e7          	jalr	-1614(ra) # de8 <exit>
        printf("grind: fork failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	fba50513          	add	a0,a0,-70 # 13f8 <malloc+0x1e8>
     446:	00001097          	auipc	ra,0x1
     44a:	d12080e7          	jalr	-750(ra) # 1158 <printf>
        exit(1);
     44e:	4505                	li	a0,1
     450:	00001097          	auipc	ra,0x1
     454:	998080e7          	jalr	-1640(ra) # de8 <exit>
        printf("grind: chdir failed\n");
     458:	00001517          	auipc	a0,0x1
     45c:	fc850513          	add	a0,a0,-56 # 1420 <malloc+0x210>
     460:	00001097          	auipc	ra,0x1
     464:	cf8080e7          	jalr	-776(ra) # 1158 <printf>
        exit(1);
     468:	4505                	li	a0,1
     46a:	00001097          	auipc	ra,0x1
     46e:	97e080e7          	jalr	-1666(ra) # de8 <exit>
    } else if(what == 18){
      int pid = fork();
     472:	00001097          	auipc	ra,0x1
     476:	96e080e7          	jalr	-1682(ra) # de0 <fork>
      if(pid == 0){
     47a:	c909                	beqz	a0,48c <go+0x414>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47c:	02054563          	bltz	a0,4a6 <go+0x42e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     480:	4501                	li	a0,0
     482:	00001097          	auipc	ra,0x1
     486:	96e080e7          	jalr	-1682(ra) # df0 <wait>
     48a:	b14d                	j	12c <go+0xb4>
        kill(getpid());
     48c:	00001097          	auipc	ra,0x1
     490:	9dc080e7          	jalr	-1572(ra) # e68 <getpid>
     494:	00001097          	auipc	ra,0x1
     498:	984080e7          	jalr	-1660(ra) # e18 <kill>
        exit(0);
     49c:	4501                	li	a0,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	94a080e7          	jalr	-1718(ra) # de8 <exit>
        printf("grind: fork failed\n");
     4a6:	00001517          	auipc	a0,0x1
     4aa:	f5250513          	add	a0,a0,-174 # 13f8 <malloc+0x1e8>
     4ae:	00001097          	auipc	ra,0x1
     4b2:	caa080e7          	jalr	-854(ra) # 1158 <printf>
        exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00001097          	auipc	ra,0x1
     4bc:	930080e7          	jalr	-1744(ra) # de8 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c0:	f9840513          	add	a0,s0,-104
     4c4:	00001097          	auipc	ra,0x1
     4c8:	934080e7          	jalr	-1740(ra) # df8 <pipe>
     4cc:	02054b63          	bltz	a0,502 <go+0x48a>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d0:	00001097          	auipc	ra,0x1
     4d4:	910080e7          	jalr	-1776(ra) # de0 <fork>
      if(pid == 0){
     4d8:	c131                	beqz	a0,51c <go+0x4a4>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4da:	0a054a63          	bltz	a0,58e <go+0x516>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4de:	f9842503          	lw	a0,-104(s0)
     4e2:	00001097          	auipc	ra,0x1
     4e6:	92e080e7          	jalr	-1746(ra) # e10 <close>
      close(fds[1]);
     4ea:	f9c42503          	lw	a0,-100(s0)
     4ee:	00001097          	auipc	ra,0x1
     4f2:	922080e7          	jalr	-1758(ra) # e10 <close>
      wait(0);
     4f6:	4501                	li	a0,0
     4f8:	00001097          	auipc	ra,0x1
     4fc:	8f8080e7          	jalr	-1800(ra) # df0 <wait>
     500:	b135                	j	12c <go+0xb4>
        printf("grind: pipe failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	f3650513          	add	a0,a0,-202 # 1438 <malloc+0x228>
     50a:	00001097          	auipc	ra,0x1
     50e:	c4e080e7          	jalr	-946(ra) # 1158 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	8d4080e7          	jalr	-1836(ra) # de8 <exit>
        fork();
     51c:	00001097          	auipc	ra,0x1
     520:	8c4080e7          	jalr	-1852(ra) # de0 <fork>
        fork();
     524:	00001097          	auipc	ra,0x1
     528:	8bc080e7          	jalr	-1860(ra) # de0 <fork>
        if(write(fds[1], "x", 1) != 1)
     52c:	4605                	li	a2,1
     52e:	00001597          	auipc	a1,0x1
     532:	f2258593          	add	a1,a1,-222 # 1450 <malloc+0x240>
     536:	f9c42503          	lw	a0,-100(s0)
     53a:	00001097          	auipc	ra,0x1
     53e:	8ce080e7          	jalr	-1842(ra) # e08 <write>
     542:	4785                	li	a5,1
     544:	02f51363          	bne	a0,a5,56a <go+0x4f2>
        if(read(fds[0], &c, 1) != 1)
     548:	4605                	li	a2,1
     54a:	f9040593          	add	a1,s0,-112
     54e:	f9842503          	lw	a0,-104(s0)
     552:	00001097          	auipc	ra,0x1
     556:	8ae080e7          	jalr	-1874(ra) # e00 <read>
     55a:	4785                	li	a5,1
     55c:	02f51063          	bne	a0,a5,57c <go+0x504>
        exit(0);
     560:	4501                	li	a0,0
     562:	00001097          	auipc	ra,0x1
     566:	886080e7          	jalr	-1914(ra) # de8 <exit>
          printf("grind: pipe write failed\n");
     56a:	00001517          	auipc	a0,0x1
     56e:	eee50513          	add	a0,a0,-274 # 1458 <malloc+0x248>
     572:	00001097          	auipc	ra,0x1
     576:	be6080e7          	jalr	-1050(ra) # 1158 <printf>
     57a:	b7f9                	j	548 <go+0x4d0>
          printf("grind: pipe read failed\n");
     57c:	00001517          	auipc	a0,0x1
     580:	efc50513          	add	a0,a0,-260 # 1478 <malloc+0x268>
     584:	00001097          	auipc	ra,0x1
     588:	bd4080e7          	jalr	-1068(ra) # 1158 <printf>
     58c:	bfd1                	j	560 <go+0x4e8>
        printf("grind: fork failed\n");
     58e:	00001517          	auipc	a0,0x1
     592:	e6a50513          	add	a0,a0,-406 # 13f8 <malloc+0x1e8>
     596:	00001097          	auipc	ra,0x1
     59a:	bc2080e7          	jalr	-1086(ra) # 1158 <printf>
        exit(1);
     59e:	4505                	li	a0,1
     5a0:	00001097          	auipc	ra,0x1
     5a4:	848080e7          	jalr	-1976(ra) # de8 <exit>
    } else if(what == 20){
      int pid = fork();
     5a8:	00001097          	auipc	ra,0x1
     5ac:	838080e7          	jalr	-1992(ra) # de0 <fork>
      if(pid == 0){
     5b0:	c909                	beqz	a0,5c2 <go+0x54a>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b2:	06054f63          	bltz	a0,630 <go+0x5b8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b6:	4501                	li	a0,0
     5b8:	00001097          	auipc	ra,0x1
     5bc:	838080e7          	jalr	-1992(ra) # df0 <wait>
     5c0:	b6b5                	j	12c <go+0xb4>
        unlink("a");
     5c2:	00001517          	auipc	a0,0x1
     5c6:	e1650513          	add	a0,a0,-490 # 13d8 <malloc+0x1c8>
     5ca:	00001097          	auipc	ra,0x1
     5ce:	86e080e7          	jalr	-1938(ra) # e38 <unlink>
        mkdir("a");
     5d2:	00001517          	auipc	a0,0x1
     5d6:	e0650513          	add	a0,a0,-506 # 13d8 <malloc+0x1c8>
     5da:	00001097          	auipc	ra,0x1
     5de:	876080e7          	jalr	-1930(ra) # e50 <mkdir>
        chdir("a");
     5e2:	00001517          	auipc	a0,0x1
     5e6:	df650513          	add	a0,a0,-522 # 13d8 <malloc+0x1c8>
     5ea:	00001097          	auipc	ra,0x1
     5ee:	86e080e7          	jalr	-1938(ra) # e58 <chdir>
        unlink("../a");
     5f2:	00001517          	auipc	a0,0x1
     5f6:	d4e50513          	add	a0,a0,-690 # 1340 <malloc+0x130>
     5fa:	00001097          	auipc	ra,0x1
     5fe:	83e080e7          	jalr	-1986(ra) # e38 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     602:	20200593          	li	a1,514
     606:	00001517          	auipc	a0,0x1
     60a:	e4a50513          	add	a0,a0,-438 # 1450 <malloc+0x240>
     60e:	00001097          	auipc	ra,0x1
     612:	81a080e7          	jalr	-2022(ra) # e28 <open>
        unlink("x");
     616:	00001517          	auipc	a0,0x1
     61a:	e3a50513          	add	a0,a0,-454 # 1450 <malloc+0x240>
     61e:	00001097          	auipc	ra,0x1
     622:	81a080e7          	jalr	-2022(ra) # e38 <unlink>
        exit(0);
     626:	4501                	li	a0,0
     628:	00000097          	auipc	ra,0x0
     62c:	7c0080e7          	jalr	1984(ra) # de8 <exit>
        printf("grind: fork failed\n");
     630:	00001517          	auipc	a0,0x1
     634:	dc850513          	add	a0,a0,-568 # 13f8 <malloc+0x1e8>
     638:	00001097          	auipc	ra,0x1
     63c:	b20080e7          	jalr	-1248(ra) # 1158 <printf>
        exit(1);
     640:	4505                	li	a0,1
     642:	00000097          	auipc	ra,0x0
     646:	7a6080e7          	jalr	1958(ra) # de8 <exit>
    } else if(what == 21){
      unlink("c");
     64a:	00001517          	auipc	a0,0x1
     64e:	e4e50513          	add	a0,a0,-434 # 1498 <malloc+0x288>
     652:	00000097          	auipc	ra,0x0
     656:	7e6080e7          	jalr	2022(ra) # e38 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65a:	20200593          	li	a1,514
     65e:	00001517          	auipc	a0,0x1
     662:	e3a50513          	add	a0,a0,-454 # 1498 <malloc+0x288>
     666:	00000097          	auipc	ra,0x0
     66a:	7c2080e7          	jalr	1986(ra) # e28 <open>
     66e:	8baa                	mv	s7,a0
      if(fd1 < 0){
     670:	04054f63          	bltz	a0,6ce <go+0x656>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     674:	4605                	li	a2,1
     676:	00001597          	auipc	a1,0x1
     67a:	dda58593          	add	a1,a1,-550 # 1450 <malloc+0x240>
     67e:	00000097          	auipc	ra,0x0
     682:	78a080e7          	jalr	1930(ra) # e08 <write>
     686:	4785                	li	a5,1
     688:	06f51063          	bne	a0,a5,6e8 <go+0x670>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68c:	f9840593          	add	a1,s0,-104
     690:	855e                	mv	a0,s7
     692:	00000097          	auipc	ra,0x0
     696:	7ae080e7          	jalr	1966(ra) # e40 <fstat>
     69a:	e525                	bnez	a0,702 <go+0x68a>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69c:	fa843583          	ld	a1,-88(s0)
     6a0:	4785                	li	a5,1
     6a2:	06f59d63          	bne	a1,a5,71c <go+0x6a4>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a6:	f9c42583          	lw	a1,-100(s0)
     6aa:	0c800793          	li	a5,200
     6ae:	08b7e563          	bltu	a5,a1,738 <go+0x6c0>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b2:	855e                	mv	a0,s7
     6b4:	00000097          	auipc	ra,0x0
     6b8:	75c080e7          	jalr	1884(ra) # e10 <close>
      unlink("c");
     6bc:	00001517          	auipc	a0,0x1
     6c0:	ddc50513          	add	a0,a0,-548 # 1498 <malloc+0x288>
     6c4:	00000097          	auipc	ra,0x0
     6c8:	774080e7          	jalr	1908(ra) # e38 <unlink>
     6cc:	b485                	j	12c <go+0xb4>
        printf("grind: create c failed\n");
     6ce:	00001517          	auipc	a0,0x1
     6d2:	dd250513          	add	a0,a0,-558 # 14a0 <malloc+0x290>
     6d6:	00001097          	auipc	ra,0x1
     6da:	a82080e7          	jalr	-1406(ra) # 1158 <printf>
        exit(1);
     6de:	4505                	li	a0,1
     6e0:	00000097          	auipc	ra,0x0
     6e4:	708080e7          	jalr	1800(ra) # de8 <exit>
        printf("grind: write c failed\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	dd050513          	add	a0,a0,-560 # 14b8 <malloc+0x2a8>
     6f0:	00001097          	auipc	ra,0x1
     6f4:	a68080e7          	jalr	-1432(ra) # 1158 <printf>
        exit(1);
     6f8:	4505                	li	a0,1
     6fa:	00000097          	auipc	ra,0x0
     6fe:	6ee080e7          	jalr	1774(ra) # de8 <exit>
        printf("grind: fstat failed\n");
     702:	00001517          	auipc	a0,0x1
     706:	dce50513          	add	a0,a0,-562 # 14d0 <malloc+0x2c0>
     70a:	00001097          	auipc	ra,0x1
     70e:	a4e080e7          	jalr	-1458(ra) # 1158 <printf>
        exit(1);
     712:	4505                	li	a0,1
     714:	00000097          	auipc	ra,0x0
     718:	6d4080e7          	jalr	1748(ra) # de8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71c:	2581                	sext.w	a1,a1
     71e:	00001517          	auipc	a0,0x1
     722:	dca50513          	add	a0,a0,-566 # 14e8 <malloc+0x2d8>
     726:	00001097          	auipc	ra,0x1
     72a:	a32080e7          	jalr	-1486(ra) # 1158 <printf>
        exit(1);
     72e:	4505                	li	a0,1
     730:	00000097          	auipc	ra,0x0
     734:	6b8080e7          	jalr	1720(ra) # de8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     738:	00001517          	auipc	a0,0x1
     73c:	dd850513          	add	a0,a0,-552 # 1510 <malloc+0x300>
     740:	00001097          	auipc	ra,0x1
     744:	a18080e7          	jalr	-1512(ra) # 1158 <printf>
        exit(1);
     748:	4505                	li	a0,1
     74a:	00000097          	auipc	ra,0x0
     74e:	69e080e7          	jalr	1694(ra) # de8 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     752:	f8840513          	add	a0,s0,-120
     756:	00000097          	auipc	ra,0x0
     75a:	6a2080e7          	jalr	1698(ra) # df8 <pipe>
     75e:	0e054963          	bltz	a0,850 <go+0x7d8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     762:	f9040513          	add	a0,s0,-112
     766:	00000097          	auipc	ra,0x0
     76a:	692080e7          	jalr	1682(ra) # df8 <pipe>
     76e:	0e054f63          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     772:	00000097          	auipc	ra,0x0
     776:	66e080e7          	jalr	1646(ra) # de0 <fork>
      if(pid1 == 0){
     77a:	10050763          	beqz	a0,888 <go+0x810>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     77e:	1a054f63          	bltz	a0,93c <go+0x8c4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     782:	00000097          	auipc	ra,0x0
     786:	65e080e7          	jalr	1630(ra) # de0 <fork>
      if(pid2 == 0){
     78a:	1c050763          	beqz	a0,958 <go+0x8e0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     78e:	2a054363          	bltz	a0,a34 <go+0x9bc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     792:	f8842503          	lw	a0,-120(s0)
     796:	00000097          	auipc	ra,0x0
     79a:	67a080e7          	jalr	1658(ra) # e10 <close>
      close(aa[1]);
     79e:	f8c42503          	lw	a0,-116(s0)
     7a2:	00000097          	auipc	ra,0x0
     7a6:	66e080e7          	jalr	1646(ra) # e10 <close>
      close(bb[1]);
     7aa:	f9442503          	lw	a0,-108(s0)
     7ae:	00000097          	auipc	ra,0x0
     7b2:	662080e7          	jalr	1634(ra) # e10 <close>
      char buf[3] = { 0, 0, 0 };
     7b6:	f8041023          	sh	zero,-128(s0)
     7ba:	f8040123          	sb	zero,-126(s0)
      read(bb[0], buf+0, 1);
     7be:	4605                	li	a2,1
     7c0:	f8040593          	add	a1,s0,-128
     7c4:	f9042503          	lw	a0,-112(s0)
     7c8:	00000097          	auipc	ra,0x0
     7cc:	638080e7          	jalr	1592(ra) # e00 <read>
      read(bb[0], buf+1, 1);
     7d0:	4605                	li	a2,1
     7d2:	f8140593          	add	a1,s0,-127
     7d6:	f9042503          	lw	a0,-112(s0)
     7da:	00000097          	auipc	ra,0x0
     7de:	626080e7          	jalr	1574(ra) # e00 <read>
      close(bb[0]);
     7e2:	f9042503          	lw	a0,-112(s0)
     7e6:	00000097          	auipc	ra,0x0
     7ea:	62a080e7          	jalr	1578(ra) # e10 <close>
      int st1, st2;
      wait(&st1);
     7ee:	f8440513          	add	a0,s0,-124
     7f2:	00000097          	auipc	ra,0x0
     7f6:	5fe080e7          	jalr	1534(ra) # df0 <wait>
      wait(&st2);
     7fa:	f9840513          	add	a0,s0,-104
     7fe:	00000097          	auipc	ra,0x0
     802:	5f2080e7          	jalr	1522(ra) # df0 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi") != 0){
     806:	f8442783          	lw	a5,-124(s0)
     80a:	f9842703          	lw	a4,-104(s0)
     80e:	8fd9                	or	a5,a5,a4
     810:	ef89                	bnez	a5,82a <go+0x7b2>
     812:	00001597          	auipc	a1,0x1
     816:	d4658593          	add	a1,a1,-698 # 1558 <malloc+0x348>
     81a:	f8040513          	add	a0,s0,-128
     81e:	00000097          	auipc	ra,0x0
     822:	37a080e7          	jalr	890(ra) # b98 <strcmp>
     826:	900503e3          	beqz	a0,12c <go+0xb4>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     82a:	f8040693          	add	a3,s0,-128
     82e:	f9842603          	lw	a2,-104(s0)
     832:	f8442583          	lw	a1,-124(s0)
     836:	00001517          	auipc	a0,0x1
     83a:	d7a50513          	add	a0,a0,-646 # 15b0 <malloc+0x3a0>
     83e:	00001097          	auipc	ra,0x1
     842:	91a080e7          	jalr	-1766(ra) # 1158 <printf>
        exit(1);
     846:	4505                	li	a0,1
     848:	00000097          	auipc	ra,0x0
     84c:	5a0080e7          	jalr	1440(ra) # de8 <exit>
        fprintf(2, "grind: pipe failed\n");
     850:	00001597          	auipc	a1,0x1
     854:	be858593          	add	a1,a1,-1048 # 1438 <malloc+0x228>
     858:	4509                	li	a0,2
     85a:	00001097          	auipc	ra,0x1
     85e:	8d0080e7          	jalr	-1840(ra) # 112a <fprintf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	584080e7          	jalr	1412(ra) # de8 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	bcc58593          	add	a1,a1,-1076 # 1438 <malloc+0x228>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	8b4080e7          	jalr	-1868(ra) # 112a <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	568080e7          	jalr	1384(ra) # de8 <exit>
        close(bb[0]);
     888:	f9042503          	lw	a0,-112(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	584080e7          	jalr	1412(ra) # e10 <close>
        close(bb[1]);
     894:	f9442503          	lw	a0,-108(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	578080e7          	jalr	1400(ra) # e10 <close>
        close(aa[0]);
     8a0:	f8842503          	lw	a0,-120(s0)
     8a4:	00000097          	auipc	ra,0x0
     8a8:	56c080e7          	jalr	1388(ra) # e10 <close>
        close(1);
     8ac:	4505                	li	a0,1
     8ae:	00000097          	auipc	ra,0x0
     8b2:	562080e7          	jalr	1378(ra) # e10 <close>
        if(dup(aa[1]) != 1){
     8b6:	f8c42503          	lw	a0,-116(s0)
     8ba:	00000097          	auipc	ra,0x0
     8be:	5a6080e7          	jalr	1446(ra) # e60 <dup>
     8c2:	4785                	li	a5,1
     8c4:	02f50063          	beq	a0,a5,8e4 <go+0x86c>
          fprintf(2, "grind: dup failed\n");
     8c8:	00001597          	auipc	a1,0x1
     8cc:	c7058593          	add	a1,a1,-912 # 1538 <malloc+0x328>
     8d0:	4509                	li	a0,2
     8d2:	00001097          	auipc	ra,0x1
     8d6:	858080e7          	jalr	-1960(ra) # 112a <fprintf>
          exit(1);
     8da:	4505                	li	a0,1
     8dc:	00000097          	auipc	ra,0x0
     8e0:	50c080e7          	jalr	1292(ra) # de8 <exit>
        close(aa[1]);
     8e4:	f8c42503          	lw	a0,-116(s0)
     8e8:	00000097          	auipc	ra,0x0
     8ec:	528080e7          	jalr	1320(ra) # e10 <close>
        char *args[3] = { "echo", "hi", 0 };
     8f0:	00001797          	auipc	a5,0x1
     8f4:	c6078793          	add	a5,a5,-928 # 1550 <malloc+0x340>
     8f8:	f8f43c23          	sd	a5,-104(s0)
     8fc:	00001797          	auipc	a5,0x1
     900:	c5c78793          	add	a5,a5,-932 # 1558 <malloc+0x348>
     904:	faf43023          	sd	a5,-96(s0)
     908:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     90c:	f9840593          	add	a1,s0,-104
     910:	00001517          	auipc	a0,0x1
     914:	c5050513          	add	a0,a0,-944 # 1560 <malloc+0x350>
     918:	00000097          	auipc	ra,0x0
     91c:	508080e7          	jalr	1288(ra) # e20 <exec>
        fprintf(2, "grind: echo: not found\n");
     920:	00001597          	auipc	a1,0x1
     924:	c5058593          	add	a1,a1,-944 # 1570 <malloc+0x360>
     928:	4509                	li	a0,2
     92a:	00001097          	auipc	ra,0x1
     92e:	800080e7          	jalr	-2048(ra) # 112a <fprintf>
        exit(2);
     932:	4509                	li	a0,2
     934:	00000097          	auipc	ra,0x0
     938:	4b4080e7          	jalr	1204(ra) # de8 <exit>
        fprintf(2, "grind: fork failed\n");
     93c:	00001597          	auipc	a1,0x1
     940:	abc58593          	add	a1,a1,-1348 # 13f8 <malloc+0x1e8>
     944:	4509                	li	a0,2
     946:	00000097          	auipc	ra,0x0
     94a:	7e4080e7          	jalr	2020(ra) # 112a <fprintf>
        exit(3);
     94e:	450d                	li	a0,3
     950:	00000097          	auipc	ra,0x0
     954:	498080e7          	jalr	1176(ra) # de8 <exit>
        close(aa[1]);
     958:	f8c42503          	lw	a0,-116(s0)
     95c:	00000097          	auipc	ra,0x0
     960:	4b4080e7          	jalr	1204(ra) # e10 <close>
        close(bb[0]);
     964:	f9042503          	lw	a0,-112(s0)
     968:	00000097          	auipc	ra,0x0
     96c:	4a8080e7          	jalr	1192(ra) # e10 <close>
        close(0);
     970:	4501                	li	a0,0
     972:	00000097          	auipc	ra,0x0
     976:	49e080e7          	jalr	1182(ra) # e10 <close>
        if(dup(aa[0]) != 0){
     97a:	f8842503          	lw	a0,-120(s0)
     97e:	00000097          	auipc	ra,0x0
     982:	4e2080e7          	jalr	1250(ra) # e60 <dup>
     986:	cd19                	beqz	a0,9a4 <go+0x92c>
          fprintf(2, "grind: dup failed\n");
     988:	00001597          	auipc	a1,0x1
     98c:	bb058593          	add	a1,a1,-1104 # 1538 <malloc+0x328>
     990:	4509                	li	a0,2
     992:	00000097          	auipc	ra,0x0
     996:	798080e7          	jalr	1944(ra) # 112a <fprintf>
          exit(4);
     99a:	4511                	li	a0,4
     99c:	00000097          	auipc	ra,0x0
     9a0:	44c080e7          	jalr	1100(ra) # de8 <exit>
        close(aa[0]);
     9a4:	f8842503          	lw	a0,-120(s0)
     9a8:	00000097          	auipc	ra,0x0
     9ac:	468080e7          	jalr	1128(ra) # e10 <close>
        close(1);
     9b0:	4505                	li	a0,1
     9b2:	00000097          	auipc	ra,0x0
     9b6:	45e080e7          	jalr	1118(ra) # e10 <close>
        if(dup(bb[1]) != 1){
     9ba:	f9442503          	lw	a0,-108(s0)
     9be:	00000097          	auipc	ra,0x0
     9c2:	4a2080e7          	jalr	1186(ra) # e60 <dup>
     9c6:	4785                	li	a5,1
     9c8:	02f50063          	beq	a0,a5,9e8 <go+0x970>
          fprintf(2, "grind: dup failed\n");
     9cc:	00001597          	auipc	a1,0x1
     9d0:	b6c58593          	add	a1,a1,-1172 # 1538 <malloc+0x328>
     9d4:	4509                	li	a0,2
     9d6:	00000097          	auipc	ra,0x0
     9da:	754080e7          	jalr	1876(ra) # 112a <fprintf>
          exit(5);
     9de:	4515                	li	a0,5
     9e0:	00000097          	auipc	ra,0x0
     9e4:	408080e7          	jalr	1032(ra) # de8 <exit>
        close(bb[1]);
     9e8:	f9442503          	lw	a0,-108(s0)
     9ec:	00000097          	auipc	ra,0x0
     9f0:	424080e7          	jalr	1060(ra) # e10 <close>
        char *args[2] = { "cat", 0 };
     9f4:	00001797          	auipc	a5,0x1
     9f8:	b9478793          	add	a5,a5,-1132 # 1588 <malloc+0x378>
     9fc:	f8f43c23          	sd	a5,-104(s0)
     a00:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     a04:	f9840593          	add	a1,s0,-104
     a08:	00001517          	auipc	a0,0x1
     a0c:	b8850513          	add	a0,a0,-1144 # 1590 <malloc+0x380>
     a10:	00000097          	auipc	ra,0x0
     a14:	410080e7          	jalr	1040(ra) # e20 <exec>
        fprintf(2, "grind: cat: not found\n");
     a18:	00001597          	auipc	a1,0x1
     a1c:	b8058593          	add	a1,a1,-1152 # 1598 <malloc+0x388>
     a20:	4509                	li	a0,2
     a22:	00000097          	auipc	ra,0x0
     a26:	708080e7          	jalr	1800(ra) # 112a <fprintf>
        exit(6);
     a2a:	4519                	li	a0,6
     a2c:	00000097          	auipc	ra,0x0
     a30:	3bc080e7          	jalr	956(ra) # de8 <exit>
        fprintf(2, "grind: fork failed\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	9c458593          	add	a1,a1,-1596 # 13f8 <malloc+0x1e8>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	6ec080e7          	jalr	1772(ra) # 112a <fprintf>
        exit(7);
     a46:	451d                	li	a0,7
     a48:	00000097          	auipc	ra,0x0
     a4c:	3a0080e7          	jalr	928(ra) # de8 <exit>

0000000000000a50 <iter>:
  }
}

void
iter()
{
     a50:	7179                	add	sp,sp,-48
     a52:	f406                	sd	ra,40(sp)
     a54:	f022                	sd	s0,32(sp)
     a56:	ec26                	sd	s1,24(sp)
     a58:	e84a                	sd	s2,16(sp)
     a5a:	1800                	add	s0,sp,48
  unlink("a");
     a5c:	00001517          	auipc	a0,0x1
     a60:	97c50513          	add	a0,a0,-1668 # 13d8 <malloc+0x1c8>
     a64:	00000097          	auipc	ra,0x0
     a68:	3d4080e7          	jalr	980(ra) # e38 <unlink>
  unlink("b");
     a6c:	00001517          	auipc	a0,0x1
     a70:	91c50513          	add	a0,a0,-1764 # 1388 <malloc+0x178>
     a74:	00000097          	auipc	ra,0x0
     a78:	3c4080e7          	jalr	964(ra) # e38 <unlink>
  
  int pid1 = fork();
     a7c:	00000097          	auipc	ra,0x0
     a80:	364080e7          	jalr	868(ra) # de0 <fork>
  if(pid1 < 0){
     a84:	00054e63          	bltz	a0,aa0 <iter+0x50>
     a88:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a8a:	e905                	bnez	a0,aba <iter+0x6a>
    rand_next = 31;
     a8c:	47fd                	li	a5,31
     a8e:	00001717          	auipc	a4,0x1
     a92:	c2f73123          	sd	a5,-990(a4) # 16b0 <rand_next>
    go(0);
     a96:	4501                	li	a0,0
     a98:	fffff097          	auipc	ra,0xfffff
     a9c:	5e0080e7          	jalr	1504(ra) # 78 <go>
    printf("grind: fork failed\n");
     aa0:	00001517          	auipc	a0,0x1
     aa4:	95850513          	add	a0,a0,-1704 # 13f8 <malloc+0x1e8>
     aa8:	00000097          	auipc	ra,0x0
     aac:	6b0080e7          	jalr	1712(ra) # 1158 <printf>
    exit(1);
     ab0:	4505                	li	a0,1
     ab2:	00000097          	auipc	ra,0x0
     ab6:	336080e7          	jalr	822(ra) # de8 <exit>
    exit(0);
  }

  int pid2 = fork();
     aba:	00000097          	auipc	ra,0x0
     abe:	326080e7          	jalr	806(ra) # de0 <fork>
     ac2:	892a                	mv	s2,a0
  if(pid2 < 0){
     ac4:	00054f63          	bltz	a0,ae2 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ac8:	e915                	bnez	a0,afc <iter+0xac>
    rand_next = 7177;
     aca:	6789                	lui	a5,0x2
     acc:	c0978793          	add	a5,a5,-1015 # 1c09 <__BSS_END__+0x151>
     ad0:	00001717          	auipc	a4,0x1
     ad4:	bef73023          	sd	a5,-1056(a4) # 16b0 <rand_next>
    go(1);
     ad8:	4505                	li	a0,1
     ada:	fffff097          	auipc	ra,0xfffff
     ade:	59e080e7          	jalr	1438(ra) # 78 <go>
    printf("grind: fork failed\n");
     ae2:	00001517          	auipc	a0,0x1
     ae6:	91650513          	add	a0,a0,-1770 # 13f8 <malloc+0x1e8>
     aea:	00000097          	auipc	ra,0x0
     aee:	66e080e7          	jalr	1646(ra) # 1158 <printf>
    exit(1);
     af2:	4505                	li	a0,1
     af4:	00000097          	auipc	ra,0x0
     af8:	2f4080e7          	jalr	756(ra) # de8 <exit>
    exit(0);
  }

  int st1 = -1;
     afc:	57fd                	li	a5,-1
     afe:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b02:	fdc40513          	add	a0,s0,-36
     b06:	00000097          	auipc	ra,0x0
     b0a:	2ea080e7          	jalr	746(ra) # df0 <wait>
  if(st1 != 0){
     b0e:	fdc42783          	lw	a5,-36(s0)
     b12:	ef99                	bnez	a5,b30 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b14:	57fd                	li	a5,-1
     b16:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b1a:	fd840513          	add	a0,s0,-40
     b1e:	00000097          	auipc	ra,0x0
     b22:	2d2080e7          	jalr	722(ra) # df0 <wait>

  exit(0);
     b26:	4501                	li	a0,0
     b28:	00000097          	auipc	ra,0x0
     b2c:	2c0080e7          	jalr	704(ra) # de8 <exit>
    kill(pid1);
     b30:	8526                	mv	a0,s1
     b32:	00000097          	auipc	ra,0x0
     b36:	2e6080e7          	jalr	742(ra) # e18 <kill>
    kill(pid2);
     b3a:	854a                	mv	a0,s2
     b3c:	00000097          	auipc	ra,0x0
     b40:	2dc080e7          	jalr	732(ra) # e18 <kill>
     b44:	bfc1                	j	b14 <iter+0xc4>

0000000000000b46 <main>:
}

int
main()
{
     b46:	1141                	add	sp,sp,-16
     b48:	e406                	sd	ra,8(sp)
     b4a:	e022                	sd	s0,0(sp)
     b4c:	0800                	add	s0,sp,16
     b4e:	a811                	j	b62 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b50:	00000097          	auipc	ra,0x0
     b54:	f00080e7          	jalr	-256(ra) # a50 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b58:	4551                	li	a0,20
     b5a:	00000097          	auipc	ra,0x0
     b5e:	31e080e7          	jalr	798(ra) # e78 <sleep>
    int pid = fork();
     b62:	00000097          	auipc	ra,0x0
     b66:	27e080e7          	jalr	638(ra) # de0 <fork>
    if(pid == 0){
     b6a:	d17d                	beqz	a0,b50 <main+0xa>
    if(pid > 0){
     b6c:	fea056e3          	blez	a0,b58 <main+0x12>
      wait(0);
     b70:	4501                	li	a0,0
     b72:	00000097          	auipc	ra,0x0
     b76:	27e080e7          	jalr	638(ra) # df0 <wait>
     b7a:	bff9                	j	b58 <main+0x12>

0000000000000b7c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b7c:	1141                	add	sp,sp,-16
     b7e:	e422                	sd	s0,8(sp)
     b80:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b82:	87aa                	mv	a5,a0
     b84:	0585                	add	a1,a1,1
     b86:	0785                	add	a5,a5,1
     b88:	fff5c703          	lbu	a4,-1(a1)
     b8c:	fee78fa3          	sb	a4,-1(a5)
     b90:	fb75                	bnez	a4,b84 <strcpy+0x8>
    ;
  return os;
}
     b92:	6422                	ld	s0,8(sp)
     b94:	0141                	add	sp,sp,16
     b96:	8082                	ret

0000000000000b98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b98:	1141                	add	sp,sp,-16
     b9a:	e422                	sd	s0,8(sp)
     b9c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     b9e:	00054783          	lbu	a5,0(a0)
     ba2:	cb91                	beqz	a5,bb6 <strcmp+0x1e>
     ba4:	0005c703          	lbu	a4,0(a1)
     ba8:	00f71763          	bne	a4,a5,bb6 <strcmp+0x1e>
    p++, q++;
     bac:	0505                	add	a0,a0,1
     bae:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     bb0:	00054783          	lbu	a5,0(a0)
     bb4:	fbe5                	bnez	a5,ba4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bb6:	0005c503          	lbu	a0,0(a1)
}
     bba:	40a7853b          	subw	a0,a5,a0
     bbe:	6422                	ld	s0,8(sp)
     bc0:	0141                	add	sp,sp,16
     bc2:	8082                	ret

0000000000000bc4 <strlen>:

uint
strlen(const char *s)
{
     bc4:	1141                	add	sp,sp,-16
     bc6:	e422                	sd	s0,8(sp)
     bc8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bca:	00054783          	lbu	a5,0(a0)
     bce:	cf91                	beqz	a5,bea <strlen+0x26>
     bd0:	0505                	add	a0,a0,1
     bd2:	87aa                	mv	a5,a0
     bd4:	86be                	mv	a3,a5
     bd6:	0785                	add	a5,a5,1
     bd8:	fff7c703          	lbu	a4,-1(a5)
     bdc:	ff65                	bnez	a4,bd4 <strlen+0x10>
     bde:	40a6853b          	subw	a0,a3,a0
     be2:	2505                	addw	a0,a0,1
    ;
  return n;
}
     be4:	6422                	ld	s0,8(sp)
     be6:	0141                	add	sp,sp,16
     be8:	8082                	ret
  for(n = 0; s[n]; n++)
     bea:	4501                	li	a0,0
     bec:	bfe5                	j	be4 <strlen+0x20>

0000000000000bee <memset>:

void*
memset(void *dst, int c, uint n)
{
     bee:	1141                	add	sp,sp,-16
     bf0:	e422                	sd	s0,8(sp)
     bf2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bf4:	ca19                	beqz	a2,c0a <memset+0x1c>
     bf6:	87aa                	mv	a5,a0
     bf8:	1602                	sll	a2,a2,0x20
     bfa:	9201                	srl	a2,a2,0x20
     bfc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c00:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c04:	0785                	add	a5,a5,1
     c06:	fee79de3          	bne	a5,a4,c00 <memset+0x12>
  }
  return dst;
}
     c0a:	6422                	ld	s0,8(sp)
     c0c:	0141                	add	sp,sp,16
     c0e:	8082                	ret

0000000000000c10 <strchr>:

char*
strchr(const char *s, char c)
{
     c10:	1141                	add	sp,sp,-16
     c12:	e422                	sd	s0,8(sp)
     c14:	0800                	add	s0,sp,16
  for(; *s; s++)
     c16:	00054783          	lbu	a5,0(a0)
     c1a:	cb99                	beqz	a5,c30 <strchr+0x20>
    if(*s == c)
     c1c:	00f58763          	beq	a1,a5,c2a <strchr+0x1a>
  for(; *s; s++)
     c20:	0505                	add	a0,a0,1
     c22:	00054783          	lbu	a5,0(a0)
     c26:	fbfd                	bnez	a5,c1c <strchr+0xc>
      return (char*)s;
  return 0;
     c28:	4501                	li	a0,0
}
     c2a:	6422                	ld	s0,8(sp)
     c2c:	0141                	add	sp,sp,16
     c2e:	8082                	ret
  return 0;
     c30:	4501                	li	a0,0
     c32:	bfe5                	j	c2a <strchr+0x1a>

0000000000000c34 <gets>:

char*
gets(char *buf, int max)
{
     c34:	711d                	add	sp,sp,-96
     c36:	ec86                	sd	ra,88(sp)
     c38:	e8a2                	sd	s0,80(sp)
     c3a:	e4a6                	sd	s1,72(sp)
     c3c:	e0ca                	sd	s2,64(sp)
     c3e:	fc4e                	sd	s3,56(sp)
     c40:	f852                	sd	s4,48(sp)
     c42:	f456                	sd	s5,40(sp)
     c44:	f05a                	sd	s6,32(sp)
     c46:	ec5e                	sd	s7,24(sp)
     c48:	1080                	add	s0,sp,96
     c4a:	8baa                	mv	s7,a0
     c4c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c4e:	892a                	mv	s2,a0
     c50:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c52:	4aa9                	li	s5,10
     c54:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c56:	89a6                	mv	s3,s1
     c58:	2485                	addw	s1,s1,1
     c5a:	0344d863          	bge	s1,s4,c8a <gets+0x56>
    cc = read(0, &c, 1);
     c5e:	4605                	li	a2,1
     c60:	faf40593          	add	a1,s0,-81
     c64:	4501                	li	a0,0
     c66:	00000097          	auipc	ra,0x0
     c6a:	19a080e7          	jalr	410(ra) # e00 <read>
    if(cc < 1)
     c6e:	00a05e63          	blez	a0,c8a <gets+0x56>
    buf[i++] = c;
     c72:	faf44783          	lbu	a5,-81(s0)
     c76:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c7a:	01578763          	beq	a5,s5,c88 <gets+0x54>
     c7e:	0905                	add	s2,s2,1
     c80:	fd679be3          	bne	a5,s6,c56 <gets+0x22>
  for(i=0; i+1 < max; ){
     c84:	89a6                	mv	s3,s1
     c86:	a011                	j	c8a <gets+0x56>
     c88:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c8a:	99de                	add	s3,s3,s7
     c8c:	00098023          	sb	zero,0(s3)
  return buf;
}
     c90:	855e                	mv	a0,s7
     c92:	60e6                	ld	ra,88(sp)
     c94:	6446                	ld	s0,80(sp)
     c96:	64a6                	ld	s1,72(sp)
     c98:	6906                	ld	s2,64(sp)
     c9a:	79e2                	ld	s3,56(sp)
     c9c:	7a42                	ld	s4,48(sp)
     c9e:	7aa2                	ld	s5,40(sp)
     ca0:	7b02                	ld	s6,32(sp)
     ca2:	6be2                	ld	s7,24(sp)
     ca4:	6125                	add	sp,sp,96
     ca6:	8082                	ret

0000000000000ca8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ca8:	1101                	add	sp,sp,-32
     caa:	ec06                	sd	ra,24(sp)
     cac:	e822                	sd	s0,16(sp)
     cae:	e426                	sd	s1,8(sp)
     cb0:	e04a                	sd	s2,0(sp)
     cb2:	1000                	add	s0,sp,32
     cb4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cb6:	4581                	li	a1,0
     cb8:	00000097          	auipc	ra,0x0
     cbc:	170080e7          	jalr	368(ra) # e28 <open>
  if(fd < 0)
     cc0:	02054563          	bltz	a0,cea <stat+0x42>
     cc4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cc6:	85ca                	mv	a1,s2
     cc8:	00000097          	auipc	ra,0x0
     ccc:	178080e7          	jalr	376(ra) # e40 <fstat>
     cd0:	892a                	mv	s2,a0
  close(fd);
     cd2:	8526                	mv	a0,s1
     cd4:	00000097          	auipc	ra,0x0
     cd8:	13c080e7          	jalr	316(ra) # e10 <close>
  return r;
}
     cdc:	854a                	mv	a0,s2
     cde:	60e2                	ld	ra,24(sp)
     ce0:	6442                	ld	s0,16(sp)
     ce2:	64a2                	ld	s1,8(sp)
     ce4:	6902                	ld	s2,0(sp)
     ce6:	6105                	add	sp,sp,32
     ce8:	8082                	ret
    return -1;
     cea:	597d                	li	s2,-1
     cec:	bfc5                	j	cdc <stat+0x34>

0000000000000cee <atoi>:

int
atoi(const char *s)
{
     cee:	1141                	add	sp,sp,-16
     cf0:	e422                	sd	s0,8(sp)
     cf2:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cf4:	00054683          	lbu	a3,0(a0)
     cf8:	fd06879b          	addw	a5,a3,-48
     cfc:	0ff7f793          	zext.b	a5,a5
     d00:	4625                	li	a2,9
     d02:	02f66863          	bltu	a2,a5,d32 <atoi+0x44>
     d06:	872a                	mv	a4,a0
  n = 0;
     d08:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d0a:	0705                	add	a4,a4,1
     d0c:	0025179b          	sllw	a5,a0,0x2
     d10:	9fa9                	addw	a5,a5,a0
     d12:	0017979b          	sllw	a5,a5,0x1
     d16:	9fb5                	addw	a5,a5,a3
     d18:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d1c:	00074683          	lbu	a3,0(a4)
     d20:	fd06879b          	addw	a5,a3,-48
     d24:	0ff7f793          	zext.b	a5,a5
     d28:	fef671e3          	bgeu	a2,a5,d0a <atoi+0x1c>
  return n;
}
     d2c:	6422                	ld	s0,8(sp)
     d2e:	0141                	add	sp,sp,16
     d30:	8082                	ret
  n = 0;
     d32:	4501                	li	a0,0
     d34:	bfe5                	j	d2c <atoi+0x3e>

0000000000000d36 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d36:	1141                	add	sp,sp,-16
     d38:	e422                	sd	s0,8(sp)
     d3a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d3c:	02b57463          	bgeu	a0,a1,d64 <memmove+0x2e>
    while(n-- > 0)
     d40:	00c05f63          	blez	a2,d5e <memmove+0x28>
     d44:	1602                	sll	a2,a2,0x20
     d46:	9201                	srl	a2,a2,0x20
     d48:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d4c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d4e:	0585                	add	a1,a1,1
     d50:	0705                	add	a4,a4,1
     d52:	fff5c683          	lbu	a3,-1(a1)
     d56:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d5a:	fee79ae3          	bne	a5,a4,d4e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d5e:	6422                	ld	s0,8(sp)
     d60:	0141                	add	sp,sp,16
     d62:	8082                	ret
    dst += n;
     d64:	00c50733          	add	a4,a0,a2
    src += n;
     d68:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d6a:	fec05ae3          	blez	a2,d5e <memmove+0x28>
     d6e:	fff6079b          	addw	a5,a2,-1
     d72:	1782                	sll	a5,a5,0x20
     d74:	9381                	srl	a5,a5,0x20
     d76:	fff7c793          	not	a5,a5
     d7a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d7c:	15fd                	add	a1,a1,-1
     d7e:	177d                	add	a4,a4,-1
     d80:	0005c683          	lbu	a3,0(a1)
     d84:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d88:	fee79ae3          	bne	a5,a4,d7c <memmove+0x46>
     d8c:	bfc9                	j	d5e <memmove+0x28>

0000000000000d8e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d8e:	1141                	add	sp,sp,-16
     d90:	e422                	sd	s0,8(sp)
     d92:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d94:	ca05                	beqz	a2,dc4 <memcmp+0x36>
     d96:	fff6069b          	addw	a3,a2,-1
     d9a:	1682                	sll	a3,a3,0x20
     d9c:	9281                	srl	a3,a3,0x20
     d9e:	0685                	add	a3,a3,1
     da0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     da2:	00054783          	lbu	a5,0(a0)
     da6:	0005c703          	lbu	a4,0(a1)
     daa:	00e79863          	bne	a5,a4,dba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dae:	0505                	add	a0,a0,1
    p2++;
     db0:	0585                	add	a1,a1,1
  while (n-- > 0) {
     db2:	fed518e3          	bne	a0,a3,da2 <memcmp+0x14>
  }
  return 0;
     db6:	4501                	li	a0,0
     db8:	a019                	j	dbe <memcmp+0x30>
      return *p1 - *p2;
     dba:	40e7853b          	subw	a0,a5,a4
}
     dbe:	6422                	ld	s0,8(sp)
     dc0:	0141                	add	sp,sp,16
     dc2:	8082                	ret
  return 0;
     dc4:	4501                	li	a0,0
     dc6:	bfe5                	j	dbe <memcmp+0x30>

0000000000000dc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dc8:	1141                	add	sp,sp,-16
     dca:	e406                	sd	ra,8(sp)
     dcc:	e022                	sd	s0,0(sp)
     dce:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     dd0:	00000097          	auipc	ra,0x0
     dd4:	f66080e7          	jalr	-154(ra) # d36 <memmove>
}
     dd8:	60a2                	ld	ra,8(sp)
     dda:	6402                	ld	s0,0(sp)
     ddc:	0141                	add	sp,sp,16
     dde:	8082                	ret

0000000000000de0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     de0:	4885                	li	a7,1
 ecall
     de2:	00000073          	ecall
 ret
     de6:	8082                	ret

0000000000000de8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     de8:	4889                	li	a7,2
 ecall
     dea:	00000073          	ecall
 ret
     dee:	8082                	ret

0000000000000df0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     df0:	488d                	li	a7,3
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     df8:	4891                	li	a7,4
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <read>:
.global read
read:
 li a7, SYS_read
     e00:	4895                	li	a7,5
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <write>:
.global write
write:
 li a7, SYS_write
     e08:	48c1                	li	a7,16
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <close>:
.global close
close:
 li a7, SYS_close
     e10:	48d5                	li	a7,21
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e18:	4899                	li	a7,6
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e20:	489d                	li	a7,7
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <open>:
.global open
open:
 li a7, SYS_open
     e28:	48bd                	li	a7,15
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e30:	48c5                	li	a7,17
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e38:	48c9                	li	a7,18
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e40:	48a1                	li	a7,8
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <link>:
.global link
link:
 li a7, SYS_link
     e48:	48cd                	li	a7,19
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e50:	48d1                	li	a7,20
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e58:	48a5                	li	a7,9
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e60:	48a9                	li	a7,10
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e68:	48ad                	li	a7,11
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e70:	48b1                	li	a7,12
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e78:	48b5                	li	a7,13
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e80:	48b9                	li	a7,14
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     e88:	48d9                	li	a7,22
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e90:	1101                	add	sp,sp,-32
     e92:	ec06                	sd	ra,24(sp)
     e94:	e822                	sd	s0,16(sp)
     e96:	1000                	add	s0,sp,32
     e98:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e9c:	4605                	li	a2,1
     e9e:	fef40593          	add	a1,s0,-17
     ea2:	00000097          	auipc	ra,0x0
     ea6:	f66080e7          	jalr	-154(ra) # e08 <write>
}
     eaa:	60e2                	ld	ra,24(sp)
     eac:	6442                	ld	s0,16(sp)
     eae:	6105                	add	sp,sp,32
     eb0:	8082                	ret

0000000000000eb2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eb2:	7139                	add	sp,sp,-64
     eb4:	fc06                	sd	ra,56(sp)
     eb6:	f822                	sd	s0,48(sp)
     eb8:	f426                	sd	s1,40(sp)
     eba:	f04a                	sd	s2,32(sp)
     ebc:	ec4e                	sd	s3,24(sp)
     ebe:	0080                	add	s0,sp,64
     ec0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ec2:	c299                	beqz	a3,ec8 <printint+0x16>
     ec4:	0805c963          	bltz	a1,f56 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ec8:	2581                	sext.w	a1,a1
  neg = 0;
     eca:	4881                	li	a7,0
     ecc:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     ed0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ed2:	2601                	sext.w	a2,a2
     ed4:	00000517          	auipc	a0,0x0
     ed8:	7c450513          	add	a0,a0,1988 # 1698 <digits>
     edc:	883a                	mv	a6,a4
     ede:	2705                	addw	a4,a4,1
     ee0:	02c5f7bb          	remuw	a5,a1,a2
     ee4:	1782                	sll	a5,a5,0x20
     ee6:	9381                	srl	a5,a5,0x20
     ee8:	97aa                	add	a5,a5,a0
     eea:	0007c783          	lbu	a5,0(a5)
     eee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ef2:	0005879b          	sext.w	a5,a1
     ef6:	02c5d5bb          	divuw	a1,a1,a2
     efa:	0685                	add	a3,a3,1
     efc:	fec7f0e3          	bgeu	a5,a2,edc <printint+0x2a>
  if(neg)
     f00:	00088c63          	beqz	a7,f18 <printint+0x66>
    buf[i++] = '-';
     f04:	fd070793          	add	a5,a4,-48
     f08:	00878733          	add	a4,a5,s0
     f0c:	02d00793          	li	a5,45
     f10:	fef70823          	sb	a5,-16(a4)
     f14:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f18:	02e05863          	blez	a4,f48 <printint+0x96>
     f1c:	fc040793          	add	a5,s0,-64
     f20:	00e78933          	add	s2,a5,a4
     f24:	fff78993          	add	s3,a5,-1
     f28:	99ba                	add	s3,s3,a4
     f2a:	377d                	addw	a4,a4,-1
     f2c:	1702                	sll	a4,a4,0x20
     f2e:	9301                	srl	a4,a4,0x20
     f30:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f34:	fff94583          	lbu	a1,-1(s2)
     f38:	8526                	mv	a0,s1
     f3a:	00000097          	auipc	ra,0x0
     f3e:	f56080e7          	jalr	-170(ra) # e90 <putc>
  while(--i >= 0)
     f42:	197d                	add	s2,s2,-1
     f44:	ff3918e3          	bne	s2,s3,f34 <printint+0x82>
}
     f48:	70e2                	ld	ra,56(sp)
     f4a:	7442                	ld	s0,48(sp)
     f4c:	74a2                	ld	s1,40(sp)
     f4e:	7902                	ld	s2,32(sp)
     f50:	69e2                	ld	s3,24(sp)
     f52:	6121                	add	sp,sp,64
     f54:	8082                	ret
    x = -xx;
     f56:	40b005bb          	negw	a1,a1
    neg = 1;
     f5a:	4885                	li	a7,1
    x = -xx;
     f5c:	bf85                	j	ecc <printint+0x1a>

0000000000000f5e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f5e:	715d                	add	sp,sp,-80
     f60:	e486                	sd	ra,72(sp)
     f62:	e0a2                	sd	s0,64(sp)
     f64:	fc26                	sd	s1,56(sp)
     f66:	f84a                	sd	s2,48(sp)
     f68:	f44e                	sd	s3,40(sp)
     f6a:	f052                	sd	s4,32(sp)
     f6c:	ec56                	sd	s5,24(sp)
     f6e:	e85a                	sd	s6,16(sp)
     f70:	e45e                	sd	s7,8(sp)
     f72:	e062                	sd	s8,0(sp)
     f74:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f76:	0005c903          	lbu	s2,0(a1)
     f7a:	18090c63          	beqz	s2,1112 <vprintf+0x1b4>
     f7e:	8aaa                	mv	s5,a0
     f80:	8bb2                	mv	s7,a2
     f82:	00158493          	add	s1,a1,1
  state = 0;
     f86:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f88:	02500a13          	li	s4,37
     f8c:	4b55                	li	s6,21
     f8e:	a839                	j	fac <vprintf+0x4e>
        putc(fd, c);
     f90:	85ca                	mv	a1,s2
     f92:	8556                	mv	a0,s5
     f94:	00000097          	auipc	ra,0x0
     f98:	efc080e7          	jalr	-260(ra) # e90 <putc>
     f9c:	a019                	j	fa2 <vprintf+0x44>
    } else if(state == '%'){
     f9e:	01498d63          	beq	s3,s4,fb8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
     fa2:	0485                	add	s1,s1,1
     fa4:	fff4c903          	lbu	s2,-1(s1)
     fa8:	16090563          	beqz	s2,1112 <vprintf+0x1b4>
    if(state == 0){
     fac:	fe0999e3          	bnez	s3,f9e <vprintf+0x40>
      if(c == '%'){
     fb0:	ff4910e3          	bne	s2,s4,f90 <vprintf+0x32>
        state = '%';
     fb4:	89d2                	mv	s3,s4
     fb6:	b7f5                	j	fa2 <vprintf+0x44>
      if(c == 'd'){
     fb8:	13490263          	beq	s2,s4,10dc <vprintf+0x17e>
     fbc:	f9d9079b          	addw	a5,s2,-99
     fc0:	0ff7f793          	zext.b	a5,a5
     fc4:	12fb6563          	bltu	s6,a5,10ee <vprintf+0x190>
     fc8:	f9d9079b          	addw	a5,s2,-99
     fcc:	0ff7f713          	zext.b	a4,a5
     fd0:	10eb6f63          	bltu	s6,a4,10ee <vprintf+0x190>
     fd4:	00271793          	sll	a5,a4,0x2
     fd8:	00000717          	auipc	a4,0x0
     fdc:	66870713          	add	a4,a4,1640 # 1640 <malloc+0x430>
     fe0:	97ba                	add	a5,a5,a4
     fe2:	439c                	lw	a5,0(a5)
     fe4:	97ba                	add	a5,a5,a4
     fe6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     fe8:	008b8913          	add	s2,s7,8
     fec:	4685                	li	a3,1
     fee:	4629                	li	a2,10
     ff0:	000ba583          	lw	a1,0(s7)
     ff4:	8556                	mv	a0,s5
     ff6:	00000097          	auipc	ra,0x0
     ffa:	ebc080e7          	jalr	-324(ra) # eb2 <printint>
     ffe:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1000:	4981                	li	s3,0
    1002:	b745                	j	fa2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1004:	008b8913          	add	s2,s7,8
    1008:	4681                	li	a3,0
    100a:	4629                	li	a2,10
    100c:	000ba583          	lw	a1,0(s7)
    1010:	8556                	mv	a0,s5
    1012:	00000097          	auipc	ra,0x0
    1016:	ea0080e7          	jalr	-352(ra) # eb2 <printint>
    101a:	8bca                	mv	s7,s2
      state = 0;
    101c:	4981                	li	s3,0
    101e:	b751                	j	fa2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    1020:	008b8913          	add	s2,s7,8
    1024:	4681                	li	a3,0
    1026:	4641                	li	a2,16
    1028:	000ba583          	lw	a1,0(s7)
    102c:	8556                	mv	a0,s5
    102e:	00000097          	auipc	ra,0x0
    1032:	e84080e7          	jalr	-380(ra) # eb2 <printint>
    1036:	8bca                	mv	s7,s2
      state = 0;
    1038:	4981                	li	s3,0
    103a:	b7a5                	j	fa2 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    103c:	008b8c13          	add	s8,s7,8
    1040:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1044:	03000593          	li	a1,48
    1048:	8556                	mv	a0,s5
    104a:	00000097          	auipc	ra,0x0
    104e:	e46080e7          	jalr	-442(ra) # e90 <putc>
  putc(fd, 'x');
    1052:	07800593          	li	a1,120
    1056:	8556                	mv	a0,s5
    1058:	00000097          	auipc	ra,0x0
    105c:	e38080e7          	jalr	-456(ra) # e90 <putc>
    1060:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1062:	00000b97          	auipc	s7,0x0
    1066:	636b8b93          	add	s7,s7,1590 # 1698 <digits>
    106a:	03c9d793          	srl	a5,s3,0x3c
    106e:	97de                	add	a5,a5,s7
    1070:	0007c583          	lbu	a1,0(a5)
    1074:	8556                	mv	a0,s5
    1076:	00000097          	auipc	ra,0x0
    107a:	e1a080e7          	jalr	-486(ra) # e90 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    107e:	0992                	sll	s3,s3,0x4
    1080:	397d                	addw	s2,s2,-1
    1082:	fe0914e3          	bnez	s2,106a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1086:	8be2                	mv	s7,s8
      state = 0;
    1088:	4981                	li	s3,0
    108a:	bf21                	j	fa2 <vprintf+0x44>
        s = va_arg(ap, char*);
    108c:	008b8993          	add	s3,s7,8
    1090:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1094:	02090163          	beqz	s2,10b6 <vprintf+0x158>
        while(*s != 0){
    1098:	00094583          	lbu	a1,0(s2)
    109c:	c9a5                	beqz	a1,110c <vprintf+0x1ae>
          putc(fd, *s);
    109e:	8556                	mv	a0,s5
    10a0:	00000097          	auipc	ra,0x0
    10a4:	df0080e7          	jalr	-528(ra) # e90 <putc>
          s++;
    10a8:	0905                	add	s2,s2,1
        while(*s != 0){
    10aa:	00094583          	lbu	a1,0(s2)
    10ae:	f9e5                	bnez	a1,109e <vprintf+0x140>
        s = va_arg(ap, char*);
    10b0:	8bce                	mv	s7,s3
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	b5fd                	j	fa2 <vprintf+0x44>
          s = "(null)";
    10b6:	00000917          	auipc	s2,0x0
    10ba:	58290913          	add	s2,s2,1410 # 1638 <malloc+0x428>
        while(*s != 0){
    10be:	02800593          	li	a1,40
    10c2:	bff1                	j	109e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    10c4:	008b8913          	add	s2,s7,8
    10c8:	000bc583          	lbu	a1,0(s7)
    10cc:	8556                	mv	a0,s5
    10ce:	00000097          	auipc	ra,0x0
    10d2:	dc2080e7          	jalr	-574(ra) # e90 <putc>
    10d6:	8bca                	mv	s7,s2
      state = 0;
    10d8:	4981                	li	s3,0
    10da:	b5e1                	j	fa2 <vprintf+0x44>
        putc(fd, c);
    10dc:	02500593          	li	a1,37
    10e0:	8556                	mv	a0,s5
    10e2:	00000097          	auipc	ra,0x0
    10e6:	dae080e7          	jalr	-594(ra) # e90 <putc>
      state = 0;
    10ea:	4981                	li	s3,0
    10ec:	bd5d                	j	fa2 <vprintf+0x44>
        putc(fd, '%');
    10ee:	02500593          	li	a1,37
    10f2:	8556                	mv	a0,s5
    10f4:	00000097          	auipc	ra,0x0
    10f8:	d9c080e7          	jalr	-612(ra) # e90 <putc>
        putc(fd, c);
    10fc:	85ca                	mv	a1,s2
    10fe:	8556                	mv	a0,s5
    1100:	00000097          	auipc	ra,0x0
    1104:	d90080e7          	jalr	-624(ra) # e90 <putc>
      state = 0;
    1108:	4981                	li	s3,0
    110a:	bd61                	j	fa2 <vprintf+0x44>
        s = va_arg(ap, char*);
    110c:	8bce                	mv	s7,s3
      state = 0;
    110e:	4981                	li	s3,0
    1110:	bd49                	j	fa2 <vprintf+0x44>
    }
  }
}
    1112:	60a6                	ld	ra,72(sp)
    1114:	6406                	ld	s0,64(sp)
    1116:	74e2                	ld	s1,56(sp)
    1118:	7942                	ld	s2,48(sp)
    111a:	79a2                	ld	s3,40(sp)
    111c:	7a02                	ld	s4,32(sp)
    111e:	6ae2                	ld	s5,24(sp)
    1120:	6b42                	ld	s6,16(sp)
    1122:	6ba2                	ld	s7,8(sp)
    1124:	6c02                	ld	s8,0(sp)
    1126:	6161                	add	sp,sp,80
    1128:	8082                	ret

000000000000112a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    112a:	715d                	add	sp,sp,-80
    112c:	ec06                	sd	ra,24(sp)
    112e:	e822                	sd	s0,16(sp)
    1130:	1000                	add	s0,sp,32
    1132:	e010                	sd	a2,0(s0)
    1134:	e414                	sd	a3,8(s0)
    1136:	e818                	sd	a4,16(s0)
    1138:	ec1c                	sd	a5,24(s0)
    113a:	03043023          	sd	a6,32(s0)
    113e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1142:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1146:	8622                	mv	a2,s0
    1148:	00000097          	auipc	ra,0x0
    114c:	e16080e7          	jalr	-490(ra) # f5e <vprintf>
}
    1150:	60e2                	ld	ra,24(sp)
    1152:	6442                	ld	s0,16(sp)
    1154:	6161                	add	sp,sp,80
    1156:	8082                	ret

0000000000001158 <printf>:

void
printf(const char *fmt, ...)
{
    1158:	711d                	add	sp,sp,-96
    115a:	ec06                	sd	ra,24(sp)
    115c:	e822                	sd	s0,16(sp)
    115e:	1000                	add	s0,sp,32
    1160:	e40c                	sd	a1,8(s0)
    1162:	e810                	sd	a2,16(s0)
    1164:	ec14                	sd	a3,24(s0)
    1166:	f018                	sd	a4,32(s0)
    1168:	f41c                	sd	a5,40(s0)
    116a:	03043823          	sd	a6,48(s0)
    116e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1172:	00840613          	add	a2,s0,8
    1176:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    117a:	85aa                	mv	a1,a0
    117c:	4505                	li	a0,1
    117e:	00000097          	auipc	ra,0x0
    1182:	de0080e7          	jalr	-544(ra) # f5e <vprintf>
}
    1186:	60e2                	ld	ra,24(sp)
    1188:	6442                	ld	s0,16(sp)
    118a:	6125                	add	sp,sp,96
    118c:	8082                	ret

000000000000118e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    118e:	1141                	add	sp,sp,-16
    1190:	e422                	sd	s0,8(sp)
    1192:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1194:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1198:	00000797          	auipc	a5,0x0
    119c:	5207b783          	ld	a5,1312(a5) # 16b8 <freep>
    11a0:	a02d                	j	11ca <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11a2:	4618                	lw	a4,8(a2)
    11a4:	9f2d                	addw	a4,a4,a1
    11a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11aa:	6398                	ld	a4,0(a5)
    11ac:	6310                	ld	a2,0(a4)
    11ae:	a83d                	j	11ec <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11b0:	ff852703          	lw	a4,-8(a0)
    11b4:	9f31                	addw	a4,a4,a2
    11b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11b8:	ff053683          	ld	a3,-16(a0)
    11bc:	a091                	j	1200 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11be:	6398                	ld	a4,0(a5)
    11c0:	00e7e463          	bltu	a5,a4,11c8 <free+0x3a>
    11c4:	00e6ea63          	bltu	a3,a4,11d8 <free+0x4a>
{
    11c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ca:	fed7fae3          	bgeu	a5,a3,11be <free+0x30>
    11ce:	6398                	ld	a4,0(a5)
    11d0:	00e6e463          	bltu	a3,a4,11d8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d4:	fee7eae3          	bltu	a5,a4,11c8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11d8:	ff852583          	lw	a1,-8(a0)
    11dc:	6390                	ld	a2,0(a5)
    11de:	02059813          	sll	a6,a1,0x20
    11e2:	01c85713          	srl	a4,a6,0x1c
    11e6:	9736                	add	a4,a4,a3
    11e8:	fae60de3          	beq	a2,a4,11a2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11f0:	4790                	lw	a2,8(a5)
    11f2:	02061593          	sll	a1,a2,0x20
    11f6:	01c5d713          	srl	a4,a1,0x1c
    11fa:	973e                	add	a4,a4,a5
    11fc:	fae68ae3          	beq	a3,a4,11b0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1200:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1202:	00000717          	auipc	a4,0x0
    1206:	4af73b23          	sd	a5,1206(a4) # 16b8 <freep>
}
    120a:	6422                	ld	s0,8(sp)
    120c:	0141                	add	sp,sp,16
    120e:	8082                	ret

0000000000001210 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1210:	7139                	add	sp,sp,-64
    1212:	fc06                	sd	ra,56(sp)
    1214:	f822                	sd	s0,48(sp)
    1216:	f426                	sd	s1,40(sp)
    1218:	f04a                	sd	s2,32(sp)
    121a:	ec4e                	sd	s3,24(sp)
    121c:	e852                	sd	s4,16(sp)
    121e:	e456                	sd	s5,8(sp)
    1220:	e05a                	sd	s6,0(sp)
    1222:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1224:	02051493          	sll	s1,a0,0x20
    1228:	9081                	srl	s1,s1,0x20
    122a:	04bd                	add	s1,s1,15
    122c:	8091                	srl	s1,s1,0x4
    122e:	0014899b          	addw	s3,s1,1
    1232:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1234:	00000517          	auipc	a0,0x0
    1238:	48453503          	ld	a0,1156(a0) # 16b8 <freep>
    123c:	c515                	beqz	a0,1268 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    123e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1240:	4798                	lw	a4,8(a5)
    1242:	02977f63          	bgeu	a4,s1,1280 <malloc+0x70>
  if(nu < 4096)
    1246:	8a4e                	mv	s4,s3
    1248:	0009871b          	sext.w	a4,s3
    124c:	6685                	lui	a3,0x1
    124e:	00d77363          	bgeu	a4,a3,1254 <malloc+0x44>
    1252:	6a05                	lui	s4,0x1
    1254:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1258:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    125c:	00000917          	auipc	s2,0x0
    1260:	45c90913          	add	s2,s2,1116 # 16b8 <freep>
  if(p == (char*)-1)
    1264:	5afd                	li	s5,-1
    1266:	a895                	j	12da <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1268:	00001797          	auipc	a5,0x1
    126c:	84078793          	add	a5,a5,-1984 # 1aa8 <base>
    1270:	00000717          	auipc	a4,0x0
    1274:	44f73423          	sd	a5,1096(a4) # 16b8 <freep>
    1278:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    127a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    127e:	b7e1                	j	1246 <malloc+0x36>
      if(p->s.size == nunits)
    1280:	02e48c63          	beq	s1,a4,12b8 <malloc+0xa8>
        p->s.size -= nunits;
    1284:	4137073b          	subw	a4,a4,s3
    1288:	c798                	sw	a4,8(a5)
        p += p->s.size;
    128a:	02071693          	sll	a3,a4,0x20
    128e:	01c6d713          	srl	a4,a3,0x1c
    1292:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1294:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1298:	00000717          	auipc	a4,0x0
    129c:	42a73023          	sd	a0,1056(a4) # 16b8 <freep>
      return (void*)(p + 1);
    12a0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12a4:	70e2                	ld	ra,56(sp)
    12a6:	7442                	ld	s0,48(sp)
    12a8:	74a2                	ld	s1,40(sp)
    12aa:	7902                	ld	s2,32(sp)
    12ac:	69e2                	ld	s3,24(sp)
    12ae:	6a42                	ld	s4,16(sp)
    12b0:	6aa2                	ld	s5,8(sp)
    12b2:	6b02                	ld	s6,0(sp)
    12b4:	6121                	add	sp,sp,64
    12b6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12b8:	6398                	ld	a4,0(a5)
    12ba:	e118                	sd	a4,0(a0)
    12bc:	bff1                	j	1298 <malloc+0x88>
  hp->s.size = nu;
    12be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12c2:	0541                	add	a0,a0,16
    12c4:	00000097          	auipc	ra,0x0
    12c8:	eca080e7          	jalr	-310(ra) # 118e <free>
  return freep;
    12cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12d0:	d971                	beqz	a0,12a4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12d4:	4798                	lw	a4,8(a5)
    12d6:	fa9775e3          	bgeu	a4,s1,1280 <malloc+0x70>
    if(p == freep)
    12da:	00093703          	ld	a4,0(s2)
    12de:	853e                	mv	a0,a5
    12e0:	fef719e3          	bne	a4,a5,12d2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    12e4:	8552                	mv	a0,s4
    12e6:	00000097          	auipc	ra,0x0
    12ea:	b8a080e7          	jalr	-1142(ra) # e70 <sbrk>
  if(p == (char*)-1)
    12ee:	fd5518e3          	bne	a0,s5,12be <malloc+0xae>
        return 0;
    12f2:	4501                	li	a0,0
    12f4:	bf45                	j	12a4 <malloc+0x94>
