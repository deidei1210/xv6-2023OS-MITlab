
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	64c080e7          	jalr	1612(ra) # 654 <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	add	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	aac50513          	add	a0,a0,-1364 # ac8 <malloc+0xec>
  24:	00001097          	auipc	ra,0x1
  28:	900080e7          	jalr	-1792(ra) # 924 <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	57e080e7          	jalr	1406(ra) # 5ac <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	add	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	add	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	5ec080e7          	jalr	1516(ra) # 634 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
  58:	a019                	j	5e <countfree+0x28>
  5a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  5e:	6505                	lui	a0,0x1
  60:	00000097          	auipc	ra,0x0
  64:	5d4080e7          	jalr	1492(ra) # 634 <sbrk>
  68:	ff2519e3          	bne	a0,s2,5a <countfree+0x24>
  }
  sinfo(&info);
  6c:	fc040513          	add	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	5b4080e7          	jalr	1460(ra) # 634 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	5a8080e7          	jalr	1448(ra) # 634 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	add	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	a3a50513          	add	a0,a0,-1478 # ae0 <malloc+0x104>
  ae:	00001097          	auipc	ra,0x1
  b2:	876080e7          	jalr	-1930(ra) # 924 <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	4f4080e7          	jalr	1268(ra) # 5ac <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	add	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	add	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	add	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	548080e7          	jalr	1352(ra) # 634 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	add	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	520080e7          	jalr	1312(ra) # 634 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	add	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	add	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	9d450513          	add	a0,a0,-1580 # b18 <malloc+0x13c>
 14c:	00000097          	auipc	ra,0x0
 150:	7d8080e7          	jalr	2008(ra) # 924 <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	456080e7          	jalr	1110(ra) # 5ac <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	9ea50513          	add	a0,a0,-1558 # b48 <malloc+0x16c>
 166:	00000097          	auipc	ra,0x0
 16a:	7be080e7          	jalr	1982(ra) # 924 <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	43c080e7          	jalr	1084(ra) # 5ac <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	9a050513          	add	a0,a0,-1632 # b18 <malloc+0x13c>
 180:	00000097          	auipc	ra,0x0
 184:	7a4080e7          	jalr	1956(ra) # 924 <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	422080e7          	jalr	1058(ra) # 5ac <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	9b650513          	add	a0,a0,-1610 # b48 <malloc+0x16c>
 19a:	00000097          	auipc	ra,0x0
 19e:	78a080e7          	jalr	1930(ra) # 924 <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	408080e7          	jalr	1032(ra) # 5ac <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	96a50513          	add	a0,a0,-1686 # b18 <malloc+0x13c>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	76e080e7          	jalr	1902(ra) # 924 <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3ec080e7          	jalr	1004(ra) # 5ac <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	add	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	add	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	add	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	480080e7          	jalr	1152(ra) # 654 <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	ab853503          	ld	a0,-1352(a0) # c98 <__SDATA_BEGIN__>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	46c080e7          	jalr	1132(ra) # 654 <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	add	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	95a50513          	add	a0,a0,-1702 # b58 <malloc+0x17c>
 206:	00000097          	auipc	ra,0x0
 20a:	71e080e7          	jalr	1822(ra) # 924 <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	39c080e7          	jalr	924(ra) # 5ac <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	95850513          	add	a0,a0,-1704 # b70 <malloc+0x194>
 220:	00000097          	auipc	ra,0x0
 224:	704080e7          	jalr	1796(ra) # 924 <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	382080e7          	jalr	898(ra) # 5ac <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	add	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	add	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	add	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	358080e7          	jalr	856(ra) # 5a4 <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	add	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	add	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	94e50513          	add	a0,a0,-1714 # bc0 <malloc+0x1e4>
 27a:	00000097          	auipc	ra,0x0
 27e:	6aa080e7          	jalr	1706(ra) # 924 <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	328080e7          	jalr	808(ra) # 5ac <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	91450513          	add	a0,a0,-1772 # ba0 <malloc+0x1c4>
 294:	00000097          	auipc	ra,0x0
 298:	690080e7          	jalr	1680(ra) # 924 <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	30e080e7          	jalr	782(ra) # 5ac <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	304080e7          	jalr	772(ra) # 5ac <exit>
  }
  wait(&status);
 2b0:	fcc40513          	add	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	300080e7          	jalr	768(ra) # 5b4 <wait>
  sinfo(&info);
 2bc:	fd040513          	add	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	add	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	8e450513          	add	a0,a0,-1820 # bc0 <malloc+0x1e4>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	640080e7          	jalr	1600(ra) # 924 <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	2be080e7          	jalr	702(ra) # 5ac <exit>

00000000000002f6 <main>:

int
main(int argc, char *argv[])
{
 2f6:	1141                	add	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	add	s0,sp,16
  printf("sysinfotest: start\n");
 2fe:	00001517          	auipc	a0,0x1
 302:	8f250513          	add	a0,a0,-1806 # bf0 <malloc+0x214>
 306:	00000097          	auipc	ra,0x0
 30a:	61e080e7          	jalr	1566(ra) # 924 <printf>
  testcall();
 30e:	00000097          	auipc	ra,0x0
 312:	eba080e7          	jalr	-326(ra) # 1c8 <testcall>
  testmem();
 316:	00000097          	auipc	ra,0x0
 31a:	daa080e7          	jalr	-598(ra) # c0 <testmem>
  testproc();
 31e:	00000097          	auipc	ra,0x0
 322:	f14080e7          	jalr	-236(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 326:	00001517          	auipc	a0,0x1
 32a:	8e250513          	add	a0,a0,-1822 # c08 <malloc+0x22c>
 32e:	00000097          	auipc	ra,0x0
 332:	5f6080e7          	jalr	1526(ra) # 924 <printf>
  exit(0);
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	274080e7          	jalr	628(ra) # 5ac <exit>

0000000000000340 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 340:	1141                	add	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 346:	87aa                	mv	a5,a0
 348:	0585                	add	a1,a1,1 # fffffffffffff001 <__global_pointer$+0xffffffffffffdb70>
 34a:	0785                	add	a5,a5,1
 34c:	fff5c703          	lbu	a4,-1(a1)
 350:	fee78fa3          	sb	a4,-1(a5)
 354:	fb75                	bnez	a4,348 <strcpy+0x8>
    ;
  return os;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	add	sp,sp,16
 35a:	8082                	ret

000000000000035c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35c:	1141                	add	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 362:	00054783          	lbu	a5,0(a0)
 366:	cb91                	beqz	a5,37a <strcmp+0x1e>
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00f71763          	bne	a4,a5,37a <strcmp+0x1e>
    p++, q++;
 370:	0505                	add	a0,a0,1
 372:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 374:	00054783          	lbu	a5,0(a0)
 378:	fbe5                	bnez	a5,368 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 37a:	0005c503          	lbu	a0,0(a1)
}
 37e:	40a7853b          	subw	a0,a5,a0
 382:	6422                	ld	s0,8(sp)
 384:	0141                	add	sp,sp,16
 386:	8082                	ret

0000000000000388 <strlen>:

uint
strlen(const char *s)
{
 388:	1141                	add	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 38e:	00054783          	lbu	a5,0(a0)
 392:	cf91                	beqz	a5,3ae <strlen+0x26>
 394:	0505                	add	a0,a0,1
 396:	87aa                	mv	a5,a0
 398:	86be                	mv	a3,a5
 39a:	0785                	add	a5,a5,1
 39c:	fff7c703          	lbu	a4,-1(a5)
 3a0:	ff65                	bnez	a4,398 <strlen+0x10>
 3a2:	40a6853b          	subw	a0,a3,a0
 3a6:	2505                	addw	a0,a0,1
    ;
  return n;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	add	sp,sp,16
 3ac:	8082                	ret
  for(n = 0; s[n]; n++)
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <strlen+0x20>

00000000000003b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b2:	1141                	add	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3b8:	ca19                	beqz	a2,3ce <memset+0x1c>
 3ba:	87aa                	mv	a5,a0
 3bc:	1602                	sll	a2,a2,0x20
 3be:	9201                	srl	a2,a2,0x20
 3c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c8:	0785                	add	a5,a5,1
 3ca:	fee79de3          	bne	a5,a4,3c4 <memset+0x12>
  }
  return dst;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	add	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <strchr>:

char*
strchr(const char *s, char c)
{
 3d4:	1141                	add	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	add	s0,sp,16
  for(; *s; s++)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	cb99                	beqz	a5,3f4 <strchr+0x20>
    if(*s == c)
 3e0:	00f58763          	beq	a1,a5,3ee <strchr+0x1a>
  for(; *s; s++)
 3e4:	0505                	add	a0,a0,1
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	fbfd                	bnez	a5,3e0 <strchr+0xc>
      return (char*)s;
  return 0;
 3ec:	4501                	li	a0,0
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	add	sp,sp,16
 3f2:	8082                	ret
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	bfe5                	j	3ee <strchr+0x1a>

00000000000003f8 <gets>:

char*
gets(char *buf, int max)
{
 3f8:	711d                	add	sp,sp,-96
 3fa:	ec86                	sd	ra,88(sp)
 3fc:	e8a2                	sd	s0,80(sp)
 3fe:	e4a6                	sd	s1,72(sp)
 400:	e0ca                	sd	s2,64(sp)
 402:	fc4e                	sd	s3,56(sp)
 404:	f852                	sd	s4,48(sp)
 406:	f456                	sd	s5,40(sp)
 408:	f05a                	sd	s6,32(sp)
 40a:	ec5e                	sd	s7,24(sp)
 40c:	1080                	add	s0,sp,96
 40e:	8baa                	mv	s7,a0
 410:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 412:	892a                	mv	s2,a0
 414:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 416:	4aa9                	li	s5,10
 418:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 41a:	89a6                	mv	s3,s1
 41c:	2485                	addw	s1,s1,1
 41e:	0344d863          	bge	s1,s4,44e <gets+0x56>
    cc = read(0, &c, 1);
 422:	4605                	li	a2,1
 424:	faf40593          	add	a1,s0,-81
 428:	4501                	li	a0,0
 42a:	00000097          	auipc	ra,0x0
 42e:	19a080e7          	jalr	410(ra) # 5c4 <read>
    if(cc < 1)
 432:	00a05e63          	blez	a0,44e <gets+0x56>
    buf[i++] = c;
 436:	faf44783          	lbu	a5,-81(s0)
 43a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43e:	01578763          	beq	a5,s5,44c <gets+0x54>
 442:	0905                	add	s2,s2,1
 444:	fd679be3          	bne	a5,s6,41a <gets+0x22>
  for(i=0; i+1 < max; ){
 448:	89a6                	mv	s3,s1
 44a:	a011                	j	44e <gets+0x56>
 44c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 44e:	99de                	add	s3,s3,s7
 450:	00098023          	sb	zero,0(s3) # 1000 <__BSS_END__+0x348>
  return buf;
}
 454:	855e                	mv	a0,s7
 456:	60e6                	ld	ra,88(sp)
 458:	6446                	ld	s0,80(sp)
 45a:	64a6                	ld	s1,72(sp)
 45c:	6906                	ld	s2,64(sp)
 45e:	79e2                	ld	s3,56(sp)
 460:	7a42                	ld	s4,48(sp)
 462:	7aa2                	ld	s5,40(sp)
 464:	7b02                	ld	s6,32(sp)
 466:	6be2                	ld	s7,24(sp)
 468:	6125                	add	sp,sp,96
 46a:	8082                	ret

000000000000046c <stat>:

int
stat(const char *n, struct stat *st)
{
 46c:	1101                	add	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	e426                	sd	s1,8(sp)
 474:	e04a                	sd	s2,0(sp)
 476:	1000                	add	s0,sp,32
 478:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47a:	4581                	li	a1,0
 47c:	00000097          	auipc	ra,0x0
 480:	170080e7          	jalr	368(ra) # 5ec <open>
  if(fd < 0)
 484:	02054563          	bltz	a0,4ae <stat+0x42>
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	00000097          	auipc	ra,0x0
 490:	178080e7          	jalr	376(ra) # 604 <fstat>
 494:	892a                	mv	s2,a0
  close(fd);
 496:	8526                	mv	a0,s1
 498:	00000097          	auipc	ra,0x0
 49c:	13c080e7          	jalr	316(ra) # 5d4 <close>
  return r;
}
 4a0:	854a                	mv	a0,s2
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	64a2                	ld	s1,8(sp)
 4a8:	6902                	ld	s2,0(sp)
 4aa:	6105                	add	sp,sp,32
 4ac:	8082                	ret
    return -1;
 4ae:	597d                	li	s2,-1
 4b0:	bfc5                	j	4a0 <stat+0x34>

00000000000004b2 <atoi>:

int
atoi(const char *s)
{
 4b2:	1141                	add	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addw	a5,a3,-48
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66863          	bltu	a2,a5,4f6 <atoi+0x44>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ce:	0705                	add	a4,a4,1
 4d0:	0025179b          	sllw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	sllw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1c>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	add	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x3e>

00000000000004fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fa:	1141                	add	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57463          	bgeu	a0,a1,528 <memmove+0x2e>
    while(n-- > 0)
 504:	00c05f63          	blez	a2,522 <memmove+0x28>
 508:	1602                	sll	a2,a2,0x20
 50a:	9201                	srl	a2,a2,0x20
 50c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 510:	872a                	mv	a4,a0
      *dst++ = *src++;
 512:	0585                	add	a1,a1,1
 514:	0705                	add	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 51e:	fee79ae3          	bne	a5,a4,512 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	add	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 52e:	fec05ae3          	blez	a2,522 <memmove+0x28>
 532:	fff6079b          	addw	a5,a2,-1
 536:	1782                	sll	a5,a5,0x20
 538:	9381                	srl	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 540:	15fd                	add	a1,a1,-1
 542:	177d                	add	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 54c:	fee79ae3          	bne	a5,a4,540 <memmove+0x46>
 550:	bfc9                	j	522 <memmove+0x28>

0000000000000552 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 552:	1141                	add	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 558:	ca05                	beqz	a2,588 <memcmp+0x36>
 55a:	fff6069b          	addw	a3,a2,-1
 55e:	1682                	sll	a3,a3,0x20
 560:	9281                	srl	a3,a3,0x20
 562:	0685                	add	a3,a3,1
 564:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79863          	bne	a5,a4,57e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	add	a0,a0,1
    p2++;
 574:	0585                	add	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x14>
  }
  return 0;
 57a:	4501                	li	a0,0
 57c:	a019                	j	582 <memcmp+0x30>
      return *p1 - *p2;
 57e:	40e7853b          	subw	a0,a5,a4
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	add	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <memcmp+0x30>

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	1141                	add	sp,sp,-16
 58e:	e406                	sd	ra,8(sp)
 590:	e022                	sd	s0,0(sp)
 592:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 594:	00000097          	auipc	ra,0x0
 598:	f66080e7          	jalr	-154(ra) # 4fa <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	add	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a4:	4885                	li	a7,1
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ac:	4889                	li	a7,2
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b4:	488d                	li	a7,3
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5bc:	4891                	li	a7,4
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <read>:
.global read
read:
 li a7, SYS_read
 5c4:	4895                	li	a7,5
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <write>:
.global write
write:
 li a7, SYS_write
 5cc:	48c1                	li	a7,16
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <close>:
.global close
close:
 li a7, SYS_close
 5d4:	48d5                	li	a7,21
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5dc:	4899                	li	a7,6
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e4:	489d                	li	a7,7
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <open>:
.global open
open:
 li a7, SYS_open
 5ec:	48bd                	li	a7,15
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f4:	48c5                	li	a7,17
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5fc:	48c9                	li	a7,18
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 604:	48a1                	li	a7,8
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <link>:
.global link
link:
 li a7, SYS_link
 60c:	48cd                	li	a7,19
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 614:	48d1                	li	a7,20
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 61c:	48a5                	li	a7,9
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <dup>:
.global dup
dup:
 li a7, SYS_dup
 624:	48a9                	li	a7,10
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 62c:	48ad                	li	a7,11
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 634:	48b1                	li	a7,12
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 63c:	48b5                	li	a7,13
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 644:	48b9                	li	a7,14
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <trace>:
.global trace
trace:
 li a7, SYS_trace
 64c:	48d9                	li	a7,22
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 654:	48dd                	li	a7,23
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65c:	1101                	add	sp,sp,-32
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	add	s0,sp,32
 664:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 668:	4605                	li	a2,1
 66a:	fef40593          	add	a1,s0,-17
 66e:	00000097          	auipc	ra,0x0
 672:	f5e080e7          	jalr	-162(ra) # 5cc <write>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6105                	add	sp,sp,32
 67c:	8082                	ret

000000000000067e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67e:	7139                	add	sp,sp,-64
 680:	fc06                	sd	ra,56(sp)
 682:	f822                	sd	s0,48(sp)
 684:	f426                	sd	s1,40(sp)
 686:	f04a                	sd	s2,32(sp)
 688:	ec4e                	sd	s3,24(sp)
 68a:	0080                	add	s0,sp,64
 68c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 68e:	c299                	beqz	a3,694 <printint+0x16>
 690:	0805c963          	bltz	a1,722 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 694:	2581                	sext.w	a1,a1
  neg = 0;
 696:	4881                	li	a7,0
 698:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 69c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 69e:	2601                	sext.w	a2,a2
 6a0:	00000517          	auipc	a0,0x0
 6a4:	5e050513          	add	a0,a0,1504 # c80 <digits>
 6a8:	883a                	mv	a6,a4
 6aa:	2705                	addw	a4,a4,1
 6ac:	02c5f7bb          	remuw	a5,a1,a2
 6b0:	1782                	sll	a5,a5,0x20
 6b2:	9381                	srl	a5,a5,0x20
 6b4:	97aa                	add	a5,a5,a0
 6b6:	0007c783          	lbu	a5,0(a5)
 6ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6be:	0005879b          	sext.w	a5,a1
 6c2:	02c5d5bb          	divuw	a1,a1,a2
 6c6:	0685                	add	a3,a3,1
 6c8:	fec7f0e3          	bgeu	a5,a2,6a8 <printint+0x2a>
  if(neg)
 6cc:	00088c63          	beqz	a7,6e4 <printint+0x66>
    buf[i++] = '-';
 6d0:	fd070793          	add	a5,a4,-48
 6d4:	00878733          	add	a4,a5,s0
 6d8:	02d00793          	li	a5,45
 6dc:	fef70823          	sb	a5,-16(a4)
 6e0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6e4:	02e05863          	blez	a4,714 <printint+0x96>
 6e8:	fc040793          	add	a5,s0,-64
 6ec:	00e78933          	add	s2,a5,a4
 6f0:	fff78993          	add	s3,a5,-1
 6f4:	99ba                	add	s3,s3,a4
 6f6:	377d                	addw	a4,a4,-1
 6f8:	1702                	sll	a4,a4,0x20
 6fa:	9301                	srl	a4,a4,0x20
 6fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 700:	fff94583          	lbu	a1,-1(s2)
 704:	8526                	mv	a0,s1
 706:	00000097          	auipc	ra,0x0
 70a:	f56080e7          	jalr	-170(ra) # 65c <putc>
  while(--i >= 0)
 70e:	197d                	add	s2,s2,-1
 710:	ff3918e3          	bne	s2,s3,700 <printint+0x82>
}
 714:	70e2                	ld	ra,56(sp)
 716:	7442                	ld	s0,48(sp)
 718:	74a2                	ld	s1,40(sp)
 71a:	7902                	ld	s2,32(sp)
 71c:	69e2                	ld	s3,24(sp)
 71e:	6121                	add	sp,sp,64
 720:	8082                	ret
    x = -xx;
 722:	40b005bb          	negw	a1,a1
    neg = 1;
 726:	4885                	li	a7,1
    x = -xx;
 728:	bf85                	j	698 <printint+0x1a>

000000000000072a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 72a:	715d                	add	sp,sp,-80
 72c:	e486                	sd	ra,72(sp)
 72e:	e0a2                	sd	s0,64(sp)
 730:	fc26                	sd	s1,56(sp)
 732:	f84a                	sd	s2,48(sp)
 734:	f44e                	sd	s3,40(sp)
 736:	f052                	sd	s4,32(sp)
 738:	ec56                	sd	s5,24(sp)
 73a:	e85a                	sd	s6,16(sp)
 73c:	e45e                	sd	s7,8(sp)
 73e:	e062                	sd	s8,0(sp)
 740:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 742:	0005c903          	lbu	s2,0(a1)
 746:	18090c63          	beqz	s2,8de <vprintf+0x1b4>
 74a:	8aaa                	mv	s5,a0
 74c:	8bb2                	mv	s7,a2
 74e:	00158493          	add	s1,a1,1
  state = 0;
 752:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 754:	02500a13          	li	s4,37
 758:	4b55                	li	s6,21
 75a:	a839                	j	778 <vprintf+0x4e>
        putc(fd, c);
 75c:	85ca                	mv	a1,s2
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	efc080e7          	jalr	-260(ra) # 65c <putc>
 768:	a019                	j	76e <vprintf+0x44>
    } else if(state == '%'){
 76a:	01498d63          	beq	s3,s4,784 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 76e:	0485                	add	s1,s1,1
 770:	fff4c903          	lbu	s2,-1(s1)
 774:	16090563          	beqz	s2,8de <vprintf+0x1b4>
    if(state == 0){
 778:	fe0999e3          	bnez	s3,76a <vprintf+0x40>
      if(c == '%'){
 77c:	ff4910e3          	bne	s2,s4,75c <vprintf+0x32>
        state = '%';
 780:	89d2                	mv	s3,s4
 782:	b7f5                	j	76e <vprintf+0x44>
      if(c == 'd'){
 784:	13490263          	beq	s2,s4,8a8 <vprintf+0x17e>
 788:	f9d9079b          	addw	a5,s2,-99
 78c:	0ff7f793          	zext.b	a5,a5
 790:	12fb6563          	bltu	s6,a5,8ba <vprintf+0x190>
 794:	f9d9079b          	addw	a5,s2,-99
 798:	0ff7f713          	zext.b	a4,a5
 79c:	10eb6f63          	bltu	s6,a4,8ba <vprintf+0x190>
 7a0:	00271793          	sll	a5,a4,0x2
 7a4:	00000717          	auipc	a4,0x0
 7a8:	48470713          	add	a4,a4,1156 # c28 <malloc+0x24c>
 7ac:	97ba                	add	a5,a5,a4
 7ae:	439c                	lw	a5,0(a5)
 7b0:	97ba                	add	a5,a5,a4
 7b2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b8913          	add	s2,s7,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	ebc080e7          	jalr	-324(ra) # 67e <printint>
 7ca:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b745                	j	76e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b8913          	add	s2,s7,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	ea0080e7          	jalr	-352(ra) # 67e <printint>
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b751                	j	76e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b8913          	add	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e84080e7          	jalr	-380(ra) # 67e <printint>
 802:	8bca                	mv	s7,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	b7a5                	j	76e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 808:	008b8c13          	add	s8,s7,8
 80c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 810:	03000593          	li	a1,48
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	e46080e7          	jalr	-442(ra) # 65c <putc>
  putc(fd, 'x');
 81e:	07800593          	li	a1,120
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e38080e7          	jalr	-456(ra) # 65c <putc>
 82c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82e:	00000b97          	auipc	s7,0x0
 832:	452b8b93          	add	s7,s7,1106 # c80 <digits>
 836:	03c9d793          	srl	a5,s3,0x3c
 83a:	97de                	add	a5,a5,s7
 83c:	0007c583          	lbu	a1,0(a5)
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	e1a080e7          	jalr	-486(ra) # 65c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84a:	0992                	sll	s3,s3,0x4
 84c:	397d                	addw	s2,s2,-1
 84e:	fe0914e3          	bnez	s2,836 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 852:	8be2                	mv	s7,s8
      state = 0;
 854:	4981                	li	s3,0
 856:	bf21                	j	76e <vprintf+0x44>
        s = va_arg(ap, char*);
 858:	008b8993          	add	s3,s7,8
 85c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 860:	02090163          	beqz	s2,882 <vprintf+0x158>
        while(*s != 0){
 864:	00094583          	lbu	a1,0(s2)
 868:	c9a5                	beqz	a1,8d8 <vprintf+0x1ae>
          putc(fd, *s);
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	df0080e7          	jalr	-528(ra) # 65c <putc>
          s++;
 874:	0905                	add	s2,s2,1
        while(*s != 0){
 876:	00094583          	lbu	a1,0(s2)
 87a:	f9e5                	bnez	a1,86a <vprintf+0x140>
        s = va_arg(ap, char*);
 87c:	8bce                	mv	s7,s3
      state = 0;
 87e:	4981                	li	s3,0
 880:	b5fd                	j	76e <vprintf+0x44>
          s = "(null)";
 882:	00000917          	auipc	s2,0x0
 886:	39e90913          	add	s2,s2,926 # c20 <malloc+0x244>
        while(*s != 0){
 88a:	02800593          	li	a1,40
 88e:	bff1                	j	86a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 890:	008b8913          	add	s2,s7,8
 894:	000bc583          	lbu	a1,0(s7)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	dc2080e7          	jalr	-574(ra) # 65c <putc>
 8a2:	8bca                	mv	s7,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b5e1                	j	76e <vprintf+0x44>
        putc(fd, c);
 8a8:	02500593          	li	a1,37
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	dae080e7          	jalr	-594(ra) # 65c <putc>
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bd5d                	j	76e <vprintf+0x44>
        putc(fd, '%');
 8ba:	02500593          	li	a1,37
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d9c080e7          	jalr	-612(ra) # 65c <putc>
        putc(fd, c);
 8c8:	85ca                	mv	a1,s2
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d90080e7          	jalr	-624(ra) # 65c <putc>
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bd61                	j	76e <vprintf+0x44>
        s = va_arg(ap, char*);
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bd49                	j	76e <vprintf+0x44>
    }
  }
}
 8de:	60a6                	ld	ra,72(sp)
 8e0:	6406                	ld	s0,64(sp)
 8e2:	74e2                	ld	s1,56(sp)
 8e4:	7942                	ld	s2,48(sp)
 8e6:	79a2                	ld	s3,40(sp)
 8e8:	7a02                	ld	s4,32(sp)
 8ea:	6ae2                	ld	s5,24(sp)
 8ec:	6b42                	ld	s6,16(sp)
 8ee:	6ba2                	ld	s7,8(sp)
 8f0:	6c02                	ld	s8,0(sp)
 8f2:	6161                	add	sp,sp,80
 8f4:	8082                	ret

00000000000008f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f6:	715d                	add	sp,sp,-80
 8f8:	ec06                	sd	ra,24(sp)
 8fa:	e822                	sd	s0,16(sp)
 8fc:	1000                	add	s0,sp,32
 8fe:	e010                	sd	a2,0(s0)
 900:	e414                	sd	a3,8(s0)
 902:	e818                	sd	a4,16(s0)
 904:	ec1c                	sd	a5,24(s0)
 906:	03043023          	sd	a6,32(s0)
 90a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	8622                	mv	a2,s0
 914:	00000097          	auipc	ra,0x0
 918:	e16080e7          	jalr	-490(ra) # 72a <vprintf>
}
 91c:	60e2                	ld	ra,24(sp)
 91e:	6442                	ld	s0,16(sp)
 920:	6161                	add	sp,sp,80
 922:	8082                	ret

0000000000000924 <printf>:

void
printf(const char *fmt, ...)
{
 924:	711d                	add	sp,sp,-96
 926:	ec06                	sd	ra,24(sp)
 928:	e822                	sd	s0,16(sp)
 92a:	1000                	add	s0,sp,32
 92c:	e40c                	sd	a1,8(s0)
 92e:	e810                	sd	a2,16(s0)
 930:	ec14                	sd	a3,24(s0)
 932:	f018                	sd	a4,32(s0)
 934:	f41c                	sd	a5,40(s0)
 936:	03043823          	sd	a6,48(s0)
 93a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93e:	00840613          	add	a2,s0,8
 942:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 946:	85aa                	mv	a1,a0
 948:	4505                	li	a0,1
 94a:	00000097          	auipc	ra,0x0
 94e:	de0080e7          	jalr	-544(ra) # 72a <vprintf>
}
 952:	60e2                	ld	ra,24(sp)
 954:	6442                	ld	s0,16(sp)
 956:	6125                	add	sp,sp,96
 958:	8082                	ret

000000000000095a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95a:	1141                	add	sp,sp,-16
 95c:	e422                	sd	s0,8(sp)
 95e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 960:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 964:	00000797          	auipc	a5,0x0
 968:	33c7b783          	ld	a5,828(a5) # ca0 <freep>
 96c:	a02d                	j	996 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 96e:	4618                	lw	a4,8(a2)
 970:	9f2d                	addw	a4,a4,a1
 972:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	6310                	ld	a2,0(a4)
 97a:	a83d                	j	9b8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 97c:	ff852703          	lw	a4,-8(a0)
 980:	9f31                	addw	a4,a4,a2
 982:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 984:	ff053683          	ld	a3,-16(a0)
 988:	a091                	j	9cc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98a:	6398                	ld	a4,0(a5)
 98c:	00e7e463          	bltu	a5,a4,994 <free+0x3a>
 990:	00e6ea63          	bltu	a3,a4,9a4 <free+0x4a>
{
 994:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 996:	fed7fae3          	bgeu	a5,a3,98a <free+0x30>
 99a:	6398                	ld	a4,0(a5)
 99c:	00e6e463          	bltu	a3,a4,9a4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	fee7eae3          	bltu	a5,a4,994 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9a4:	ff852583          	lw	a1,-8(a0)
 9a8:	6390                	ld	a2,0(a5)
 9aa:	02059813          	sll	a6,a1,0x20
 9ae:	01c85713          	srl	a4,a6,0x1c
 9b2:	9736                	add	a4,a4,a3
 9b4:	fae60de3          	beq	a2,a4,96e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9bc:	4790                	lw	a2,8(a5)
 9be:	02061593          	sll	a1,a2,0x20
 9c2:	01c5d713          	srl	a4,a1,0x1c
 9c6:	973e                	add	a4,a4,a5
 9c8:	fae68ae3          	beq	a3,a4,97c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	2cf73923          	sd	a5,722(a4) # ca0 <freep>
}
 9d6:	6422                	ld	s0,8(sp)
 9d8:	0141                	add	sp,sp,16
 9da:	8082                	ret

00000000000009dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9dc:	7139                	add	sp,sp,-64
 9de:	fc06                	sd	ra,56(sp)
 9e0:	f822                	sd	s0,48(sp)
 9e2:	f426                	sd	s1,40(sp)
 9e4:	f04a                	sd	s2,32(sp)
 9e6:	ec4e                	sd	s3,24(sp)
 9e8:	e852                	sd	s4,16(sp)
 9ea:	e456                	sd	s5,8(sp)
 9ec:	e05a                	sd	s6,0(sp)
 9ee:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f0:	02051493          	sll	s1,a0,0x20
 9f4:	9081                	srl	s1,s1,0x20
 9f6:	04bd                	add	s1,s1,15
 9f8:	8091                	srl	s1,s1,0x4
 9fa:	0014899b          	addw	s3,s1,1
 9fe:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a00:	00000517          	auipc	a0,0x0
 a04:	2a053503          	ld	a0,672(a0) # ca0 <freep>
 a08:	c515                	beqz	a0,a34 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	02977f63          	bgeu	a4,s1,a4c <malloc+0x70>
  if(nu < 4096)
 a12:	8a4e                	mv	s4,s3
 a14:	0009871b          	sext.w	a4,s3
 a18:	6685                	lui	a3,0x1
 a1a:	00d77363          	bgeu	a4,a3,a20 <malloc+0x44>
 a1e:	6a05                	lui	s4,0x1
 a20:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a24:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a28:	00000917          	auipc	s2,0x0
 a2c:	27890913          	add	s2,s2,632 # ca0 <freep>
  if(p == (char*)-1)
 a30:	5afd                	li	s5,-1
 a32:	a895                	j	aa6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a34:	00000797          	auipc	a5,0x0
 a38:	27478793          	add	a5,a5,628 # ca8 <base>
 a3c:	00000717          	auipc	a4,0x0
 a40:	26f73223          	sd	a5,612(a4) # ca0 <freep>
 a44:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a46:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4a:	b7e1                	j	a12 <malloc+0x36>
      if(p->s.size == nunits)
 a4c:	02e48c63          	beq	s1,a4,a84 <malloc+0xa8>
        p->s.size -= nunits;
 a50:	4137073b          	subw	a4,a4,s3
 a54:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a56:	02071693          	sll	a3,a4,0x20
 a5a:	01c6d713          	srl	a4,a3,0x1c
 a5e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a64:	00000717          	auipc	a4,0x0
 a68:	22a73e23          	sd	a0,572(a4) # ca0 <freep>
      return (void*)(p + 1);
 a6c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a70:	70e2                	ld	ra,56(sp)
 a72:	7442                	ld	s0,48(sp)
 a74:	74a2                	ld	s1,40(sp)
 a76:	7902                	ld	s2,32(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
 a80:	6121                	add	sp,sp,64
 a82:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a84:	6398                	ld	a4,0(a5)
 a86:	e118                	sd	a4,0(a0)
 a88:	bff1                	j	a64 <malloc+0x88>
  hp->s.size = nu;
 a8a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8e:	0541                	add	a0,a0,16
 a90:	00000097          	auipc	ra,0x0
 a94:	eca080e7          	jalr	-310(ra) # 95a <free>
  return freep;
 a98:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9c:	d971                	beqz	a0,a70 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa0:	4798                	lw	a4,8(a5)
 aa2:	fa9775e3          	bgeu	a4,s1,a4c <malloc+0x70>
    if(p == freep)
 aa6:	00093703          	ld	a4,0(s2)
 aaa:	853e                	mv	a0,a5
 aac:	fef719e3          	bne	a4,a5,a9e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ab0:	8552                	mv	a0,s4
 ab2:	00000097          	auipc	ra,0x0
 ab6:	b82080e7          	jalr	-1150(ra) # 634 <sbrk>
  if(p == (char*)-1)
 aba:	fd5518e3          	bne	a0,s5,a8a <malloc+0xae>
        return 0;
 abe:	4501                	li	a0,0
 ac0:	bf45                	j	a70 <malloc+0x94>
