
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test2();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	cc050513          	add	a0,a0,-832 # cd0 <buf>
  18:	00001097          	auipc	ra,0x1
  1c:	a66080e7          	jalr	-1434(ra) # a7e <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	ca850513          	add	a0,a0,-856 # cd0 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	370080e7          	jalr	880(ra) # 3a0 <strchr>
  n = atoi(c+2);
  38:	0509                	add	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	444080e7          	jalr	1092(ra) # 47e <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	add	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	ab258593          	add	a1,a1,-1358 # b08 <statistics+0x8a>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	852080e7          	jalr	-1966(ra) # 8b2 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	c6658593          	add	a1,a1,-922 # cd0 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	aa650513          	add	a0,a0,-1370 # b18 <statistics+0x9a>
  7a:	00001097          	auipc	ra,0x1
  7e:	866080e7          	jalr	-1946(ra) # 8e0 <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

void test1(void)
{
  84:	7179                	add	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	add	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	a8e50513          	add	a0,a0,-1394 # b20 <statistics+0xa2>
  9a:	00001097          	auipc	ra,0x1
  9e:	846080e7          	jalr	-1978(ra) # 8e0 <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	4c2080e7          	jalr	1218(ra) # 570 <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4b4080e7          	jalr	1204(ra) # 570 <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	4b4080e7          	jalr	1204(ra) # 580 <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	4aa080e7          	jalr	1194(ra) # 580 <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	a7250513          	add	a0,a0,-1422 # b50 <statistics+0xd2>
  e6:	00000097          	auipc	ra,0x0
  ea:	7fa080e7          	jalr	2042(ra) # 8e0 <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	a6050513          	add	a0,a0,-1440 # b60 <statistics+0xe2>
 108:	00000097          	auipc	ra,0x0
 10c:	7d8080e7          	jalr	2008(ra) # 8e0 <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	add	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	a1250513          	add	a0,a0,-1518 # b30 <statistics+0xb2>
 126:	00000097          	auipc	ra,0x0
 12a:	7ba080e7          	jalr	1978(ra) # 8e0 <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	448080e7          	jalr	1096(ra) # 578 <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	add	s2,s2,1696 # 186a0 <__BSS_END__+0x169c0>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	4be080e7          	jalr	1214(ra) # 600 <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <buf+0x334>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	4ae080e7          	jalr	1198(ra) # 600 <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	40e080e7          	jalr	1038(ra) # 578 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	9ce50513          	add	a0,a0,-1586 # b40 <statistics+0xc2>
 17a:	00000097          	auipc	ra,0x0
 17e:	766080e7          	jalr	1894(ra) # 8e0 <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	3f4080e7          	jalr	1012(ra) # 578 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	9e450513          	add	a0,a0,-1564 # b70 <statistics+0xf2>
 194:	00000097          	auipc	ra,0x0
 198:	74c080e7          	jalr	1868(ra) # 8e0 <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	add	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	add	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	450080e7          	jalr	1104(ra) # 600 <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
 1c0:	a031                	j	1cc <countfree+0x2e>
 1c2:	6785                	lui	a5,0x1
 1c4:	97aa                	add	a5,a5,a0
 1c6:	ff378fa3          	sb	s3,-1(a5) # fff <buf+0x32f>
    n += 1;
 1ca:	2485                	addw	s1,s1,1
    uint64 a = (uint64) sbrk(4096);
 1cc:	6505                	lui	a0,0x1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	432080e7          	jalr	1074(ra) # 600 <sbrk>
    if(a == 0xffffffffffffffff){
 1d6:	ff2516e3          	bne	a0,s2,1c2 <countfree+0x24>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	424080e7          	jalr	1060(ra) # 600 <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	418080e7          	jalr	1048(ra) # 600 <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	add	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

void test2() {
 202:	715d                	add	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	0880                	add	s0,sp,80
  int free0 = countfree();
 218:	00000097          	auipc	ra,0x0
 21c:	f86080e7          	jalr	-122(ra) # 19e <countfree>
 220:	89aa                	mv	s3,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 222:	00001517          	auipc	a0,0x1
 226:	95e50513          	add	a0,a0,-1698 # b80 <statistics+0x102>
 22a:	00000097          	auipc	ra,0x0
 22e:	6b6080e7          	jalr	1718(ra) # 8e0 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 232:	6621                	lui	a2,0x8
 234:	85ce                	mv	a1,s3
 236:	00001517          	auipc	a0,0x1
 23a:	95a50513          	add	a0,a0,-1702 # b90 <statistics+0x112>
 23e:	00000097          	auipc	ra,0x0
 242:	6a2080e7          	jalr	1698(ra) # 8e0 <printf>
  if(n - free0 > 1000) {
 246:	67a1                	lui	a5,0x8
 248:	413787bb          	subw	a5,a5,s3
 24c:	3e800713          	li	a4,1000
 250:	00f74c63          	blt	a4,a5,268 <test2+0x66>
 254:	4481                	li	s1,0
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
    if(i % 10 == 9)
 256:	4b29                	li	s6,10
 258:	4aa5                	li	s5,9
      printf(".");
 25a:	00001b97          	auipc	s7,0x1
 25e:	996b8b93          	add	s7,s7,-1642 # bf0 <statistics+0x172>
  for (int i = 0; i < 50; i++) {
 262:	03200a13          	li	s4,50
 266:	a01d                	j	28c <test2+0x8a>
    printf("test2 FAILED: cannot allocate enough memory");
 268:	00001517          	auipc	a0,0x1
 26c:	95850513          	add	a0,a0,-1704 # bc0 <statistics+0x142>
 270:	00000097          	auipc	ra,0x0
 274:	670080e7          	jalr	1648(ra) # 8e0 <printf>
    exit(-1);
 278:	557d                	li	a0,-1
 27a:	00000097          	auipc	ra,0x0
 27e:	2fe080e7          	jalr	766(ra) # 578 <exit>
    if(free1 != free0) {
 282:	03299463          	bne	s3,s2,2aa <test2+0xa8>
  for (int i = 0; i < 50; i++) {
 286:	2485                	addw	s1,s1,1
 288:	03448e63          	beq	s1,s4,2c4 <test2+0xc2>
    free1 = countfree();
 28c:	00000097          	auipc	ra,0x0
 290:	f12080e7          	jalr	-238(ra) # 19e <countfree>
 294:	892a                	mv	s2,a0
    if(i % 10 == 9)
 296:	0364e7bb          	remw	a5,s1,s6
 29a:	ff5794e3          	bne	a5,s5,282 <test2+0x80>
      printf(".");
 29e:	855e                	mv	a0,s7
 2a0:	00000097          	auipc	ra,0x0
 2a4:	640080e7          	jalr	1600(ra) # 8e0 <printf>
 2a8:	bfe9                	j	282 <test2+0x80>
      printf("test2 FAIL: losing pages\n");
 2aa:	00001517          	auipc	a0,0x1
 2ae:	94e50513          	add	a0,a0,-1714 # bf8 <statistics+0x17a>
 2b2:	00000097          	auipc	ra,0x0
 2b6:	62e080e7          	jalr	1582(ra) # 8e0 <printf>
      exit(-1);
 2ba:	557d                	li	a0,-1
 2bc:	00000097          	auipc	ra,0x0
 2c0:	2bc080e7          	jalr	700(ra) # 578 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2c4:	00001517          	auipc	a0,0x1
 2c8:	95450513          	add	a0,a0,-1708 # c18 <statistics+0x19a>
 2cc:	00000097          	auipc	ra,0x0
 2d0:	614080e7          	jalr	1556(ra) # 8e0 <printf>
}
 2d4:	60a6                	ld	ra,72(sp)
 2d6:	6406                	ld	s0,64(sp)
 2d8:	74e2                	ld	s1,56(sp)
 2da:	7942                	ld	s2,48(sp)
 2dc:	79a2                	ld	s3,40(sp)
 2de:	7a02                	ld	s4,32(sp)
 2e0:	6ae2                	ld	s5,24(sp)
 2e2:	6b42                	ld	s6,16(sp)
 2e4:	6ba2                	ld	s7,8(sp)
 2e6:	6161                	add	sp,sp,80
 2e8:	8082                	ret

00000000000002ea <main>:
{
 2ea:	1141                	add	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	add	s0,sp,16
  test1();
 2f2:	00000097          	auipc	ra,0x0
 2f6:	d92080e7          	jalr	-622(ra) # 84 <test1>
  test2();
 2fa:	00000097          	auipc	ra,0x0
 2fe:	f08080e7          	jalr	-248(ra) # 202 <test2>
  exit(0);
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	274080e7          	jalr	628(ra) # 578 <exit>

000000000000030c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 312:	87aa                	mv	a5,a0
 314:	0585                	add	a1,a1,1
 316:	0785                	add	a5,a5,1 # 8001 <__BSS_END__+0x6321>
 318:	fff5c703          	lbu	a4,-1(a1)
 31c:	fee78fa3          	sb	a4,-1(a5)
 320:	fb75                	bnez	a4,314 <strcpy+0x8>
    ;
  return os;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	add	sp,sp,16
 326:	8082                	ret

0000000000000328 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 328:	1141                	add	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cb91                	beqz	a5,346 <strcmp+0x1e>
 334:	0005c703          	lbu	a4,0(a1)
 338:	00f71763          	bne	a4,a5,346 <strcmp+0x1e>
    p++, q++;
 33c:	0505                	add	a0,a0,1
 33e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 340:	00054783          	lbu	a5,0(a0)
 344:	fbe5                	bnez	a5,334 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 346:	0005c503          	lbu	a0,0(a1)
}
 34a:	40a7853b          	subw	a0,a5,a0
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	add	sp,sp,16
 352:	8082                	ret

0000000000000354 <strlen>:

uint
strlen(const char *s)
{
 354:	1141                	add	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	cf91                	beqz	a5,37a <strlen+0x26>
 360:	0505                	add	a0,a0,1
 362:	87aa                	mv	a5,a0
 364:	86be                	mv	a3,a5
 366:	0785                	add	a5,a5,1
 368:	fff7c703          	lbu	a4,-1(a5)
 36c:	ff65                	bnez	a4,364 <strlen+0x10>
 36e:	40a6853b          	subw	a0,a3,a0
 372:	2505                	addw	a0,a0,1
    ;
  return n;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	add	sp,sp,16
 378:	8082                	ret
  for(n = 0; s[n]; n++)
 37a:	4501                	li	a0,0
 37c:	bfe5                	j	374 <strlen+0x20>

000000000000037e <memset>:

void*
memset(void *dst, int c, uint n)
{
 37e:	1141                	add	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 384:	ca19                	beqz	a2,39a <memset+0x1c>
 386:	87aa                	mv	a5,a0
 388:	1602                	sll	a2,a2,0x20
 38a:	9201                	srl	a2,a2,0x20
 38c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 390:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 394:	0785                	add	a5,a5,1
 396:	fee79de3          	bne	a5,a4,390 <memset+0x12>
  }
  return dst;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	add	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <strchr>:

char*
strchr(const char *s, char c)
{
 3a0:	1141                	add	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	add	s0,sp,16
  for(; *s; s++)
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	cb99                	beqz	a5,3c0 <strchr+0x20>
    if(*s == c)
 3ac:	00f58763          	beq	a1,a5,3ba <strchr+0x1a>
  for(; *s; s++)
 3b0:	0505                	add	a0,a0,1
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	fbfd                	bnez	a5,3ac <strchr+0xc>
      return (char*)s;
  return 0;
 3b8:	4501                	li	a0,0
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	add	sp,sp,16
 3be:	8082                	ret
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	bfe5                	j	3ba <strchr+0x1a>

00000000000003c4 <gets>:

char*
gets(char *buf, int max)
{
 3c4:	711d                	add	sp,sp,-96
 3c6:	ec86                	sd	ra,88(sp)
 3c8:	e8a2                	sd	s0,80(sp)
 3ca:	e4a6                	sd	s1,72(sp)
 3cc:	e0ca                	sd	s2,64(sp)
 3ce:	fc4e                	sd	s3,56(sp)
 3d0:	f852                	sd	s4,48(sp)
 3d2:	f456                	sd	s5,40(sp)
 3d4:	f05a                	sd	s6,32(sp)
 3d6:	ec5e                	sd	s7,24(sp)
 3d8:	1080                	add	s0,sp,96
 3da:	8baa                	mv	s7,a0
 3dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3de:	892a                	mv	s2,a0
 3e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e2:	4aa9                	li	s5,10
 3e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e6:	89a6                	mv	s3,s1
 3e8:	2485                	addw	s1,s1,1
 3ea:	0344d863          	bge	s1,s4,41a <gets+0x56>
    cc = read(0, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	faf40593          	add	a1,s0,-81
 3f4:	4501                	li	a0,0
 3f6:	00000097          	auipc	ra,0x0
 3fa:	19a080e7          	jalr	410(ra) # 590 <read>
    if(cc < 1)
 3fe:	00a05e63          	blez	a0,41a <gets+0x56>
    buf[i++] = c;
 402:	faf44783          	lbu	a5,-81(s0)
 406:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40a:	01578763          	beq	a5,s5,418 <gets+0x54>
 40e:	0905                	add	s2,s2,1
 410:	fd679be3          	bne	a5,s6,3e6 <gets+0x22>
  for(i=0; i+1 < max; ){
 414:	89a6                	mv	s3,s1
 416:	a011                	j	41a <gets+0x56>
 418:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41a:	99de                	add	s3,s3,s7
 41c:	00098023          	sb	zero,0(s3)
  return buf;
}
 420:	855e                	mv	a0,s7
 422:	60e6                	ld	ra,88(sp)
 424:	6446                	ld	s0,80(sp)
 426:	64a6                	ld	s1,72(sp)
 428:	6906                	ld	s2,64(sp)
 42a:	79e2                	ld	s3,56(sp)
 42c:	7a42                	ld	s4,48(sp)
 42e:	7aa2                	ld	s5,40(sp)
 430:	7b02                	ld	s6,32(sp)
 432:	6be2                	ld	s7,24(sp)
 434:	6125                	add	sp,sp,96
 436:	8082                	ret

0000000000000438 <stat>:

int
stat(const char *n, struct stat *st)
{
 438:	1101                	add	sp,sp,-32
 43a:	ec06                	sd	ra,24(sp)
 43c:	e822                	sd	s0,16(sp)
 43e:	e426                	sd	s1,8(sp)
 440:	e04a                	sd	s2,0(sp)
 442:	1000                	add	s0,sp,32
 444:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 446:	4581                	li	a1,0
 448:	00000097          	auipc	ra,0x0
 44c:	170080e7          	jalr	368(ra) # 5b8 <open>
  if(fd < 0)
 450:	02054563          	bltz	a0,47a <stat+0x42>
 454:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 456:	85ca                	mv	a1,s2
 458:	00000097          	auipc	ra,0x0
 45c:	178080e7          	jalr	376(ra) # 5d0 <fstat>
 460:	892a                	mv	s2,a0
  close(fd);
 462:	8526                	mv	a0,s1
 464:	00000097          	auipc	ra,0x0
 468:	13c080e7          	jalr	316(ra) # 5a0 <close>
  return r;
}
 46c:	854a                	mv	a0,s2
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	64a2                	ld	s1,8(sp)
 474:	6902                	ld	s2,0(sp)
 476:	6105                	add	sp,sp,32
 478:	8082                	ret
    return -1;
 47a:	597d                	li	s2,-1
 47c:	bfc5                	j	46c <stat+0x34>

000000000000047e <atoi>:

int
atoi(const char *s)
{
 47e:	1141                	add	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 484:	00054683          	lbu	a3,0(a0)
 488:	fd06879b          	addw	a5,a3,-48
 48c:	0ff7f793          	zext.b	a5,a5
 490:	4625                	li	a2,9
 492:	02f66863          	bltu	a2,a5,4c2 <atoi+0x44>
 496:	872a                	mv	a4,a0
  n = 0;
 498:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 49a:	0705                	add	a4,a4,1
 49c:	0025179b          	sllw	a5,a0,0x2
 4a0:	9fa9                	addw	a5,a5,a0
 4a2:	0017979b          	sllw	a5,a5,0x1
 4a6:	9fb5                	addw	a5,a5,a3
 4a8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4ac:	00074683          	lbu	a3,0(a4)
 4b0:	fd06879b          	addw	a5,a3,-48
 4b4:	0ff7f793          	zext.b	a5,a5
 4b8:	fef671e3          	bgeu	a2,a5,49a <atoi+0x1c>
  return n;
}
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	add	sp,sp,16
 4c0:	8082                	ret
  n = 0;
 4c2:	4501                	li	a0,0
 4c4:	bfe5                	j	4bc <atoi+0x3e>

00000000000004c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c6:	1141                	add	sp,sp,-16
 4c8:	e422                	sd	s0,8(sp)
 4ca:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4cc:	02b57463          	bgeu	a0,a1,4f4 <memmove+0x2e>
    while(n-- > 0)
 4d0:	00c05f63          	blez	a2,4ee <memmove+0x28>
 4d4:	1602                	sll	a2,a2,0x20
 4d6:	9201                	srl	a2,a2,0x20
 4d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4de:	0585                	add	a1,a1,1
 4e0:	0705                	add	a4,a4,1
 4e2:	fff5c683          	lbu	a3,-1(a1)
 4e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ea:	fee79ae3          	bne	a5,a4,4de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ee:	6422                	ld	s0,8(sp)
 4f0:	0141                	add	sp,sp,16
 4f2:	8082                	ret
    dst += n;
 4f4:	00c50733          	add	a4,a0,a2
    src += n;
 4f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fa:	fec05ae3          	blez	a2,4ee <memmove+0x28>
 4fe:	fff6079b          	addw	a5,a2,-1 # 7fff <__BSS_END__+0x631f>
 502:	1782                	sll	a5,a5,0x20
 504:	9381                	srl	a5,a5,0x20
 506:	fff7c793          	not	a5,a5
 50a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50c:	15fd                	add	a1,a1,-1
 50e:	177d                	add	a4,a4,-1
 510:	0005c683          	lbu	a3,0(a1)
 514:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 518:	fee79ae3          	bne	a5,a4,50c <memmove+0x46>
 51c:	bfc9                	j	4ee <memmove+0x28>

000000000000051e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51e:	1141                	add	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 524:	ca05                	beqz	a2,554 <memcmp+0x36>
 526:	fff6069b          	addw	a3,a2,-1
 52a:	1682                	sll	a3,a3,0x20
 52c:	9281                	srl	a3,a3,0x20
 52e:	0685                	add	a3,a3,1
 530:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 532:	00054783          	lbu	a5,0(a0)
 536:	0005c703          	lbu	a4,0(a1)
 53a:	00e79863          	bne	a5,a4,54a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 53e:	0505                	add	a0,a0,1
    p2++;
 540:	0585                	add	a1,a1,1
  while (n-- > 0) {
 542:	fed518e3          	bne	a0,a3,532 <memcmp+0x14>
  }
  return 0;
 546:	4501                	li	a0,0
 548:	a019                	j	54e <memcmp+0x30>
      return *p1 - *p2;
 54a:	40e7853b          	subw	a0,a5,a4
}
 54e:	6422                	ld	s0,8(sp)
 550:	0141                	add	sp,sp,16
 552:	8082                	ret
  return 0;
 554:	4501                	li	a0,0
 556:	bfe5                	j	54e <memcmp+0x30>

0000000000000558 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 558:	1141                	add	sp,sp,-16
 55a:	e406                	sd	ra,8(sp)
 55c:	e022                	sd	s0,0(sp)
 55e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 560:	00000097          	auipc	ra,0x0
 564:	f66080e7          	jalr	-154(ra) # 4c6 <memmove>
}
 568:	60a2                	ld	ra,8(sp)
 56a:	6402                	ld	s0,0(sp)
 56c:	0141                	add	sp,sp,16
 56e:	8082                	ret

0000000000000570 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 570:	4885                	li	a7,1
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <exit>:
.global exit
exit:
 li a7, SYS_exit
 578:	4889                	li	a7,2
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <wait>:
.global wait
wait:
 li a7, SYS_wait
 580:	488d                	li	a7,3
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 588:	4891                	li	a7,4
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <read>:
.global read
read:
 li a7, SYS_read
 590:	4895                	li	a7,5
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <write>:
.global write
write:
 li a7, SYS_write
 598:	48c1                	li	a7,16
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <close>:
.global close
close:
 li a7, SYS_close
 5a0:	48d5                	li	a7,21
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a8:	4899                	li	a7,6
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b0:	489d                	li	a7,7
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <open>:
.global open
open:
 li a7, SYS_open
 5b8:	48bd                	li	a7,15
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c0:	48c5                	li	a7,17
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c8:	48c9                	li	a7,18
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d0:	48a1                	li	a7,8
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <link>:
.global link
link:
 li a7, SYS_link
 5d8:	48cd                	li	a7,19
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e0:	48d1                	li	a7,20
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e8:	48a5                	li	a7,9
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f0:	48a9                	li	a7,10
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f8:	48ad                	li	a7,11
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 600:	48b1                	li	a7,12
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 608:	48b5                	li	a7,13
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 610:	48b9                	li	a7,14
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 618:	1101                	add	sp,sp,-32
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	1000                	add	s0,sp,32
 620:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 624:	4605                	li	a2,1
 626:	fef40593          	add	a1,s0,-17
 62a:	00000097          	auipc	ra,0x0
 62e:	f6e080e7          	jalr	-146(ra) # 598 <write>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6105                	add	sp,sp,32
 638:	8082                	ret

000000000000063a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63a:	7139                	add	sp,sp,-64
 63c:	fc06                	sd	ra,56(sp)
 63e:	f822                	sd	s0,48(sp)
 640:	f426                	sd	s1,40(sp)
 642:	f04a                	sd	s2,32(sp)
 644:	ec4e                	sd	s3,24(sp)
 646:	0080                	add	s0,sp,64
 648:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64a:	c299                	beqz	a3,650 <printint+0x16>
 64c:	0805c963          	bltz	a1,6de <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 650:	2581                	sext.w	a1,a1
  neg = 0;
 652:	4881                	li	a7,0
 654:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 658:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 65a:	2601                	sext.w	a2,a2
 65c:	00000517          	auipc	a0,0x0
 660:	62c50513          	add	a0,a0,1580 # c88 <digits>
 664:	883a                	mv	a6,a4
 666:	2705                	addw	a4,a4,1
 668:	02c5f7bb          	remuw	a5,a1,a2
 66c:	1782                	sll	a5,a5,0x20
 66e:	9381                	srl	a5,a5,0x20
 670:	97aa                	add	a5,a5,a0
 672:	0007c783          	lbu	a5,0(a5)
 676:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 67a:	0005879b          	sext.w	a5,a1
 67e:	02c5d5bb          	divuw	a1,a1,a2
 682:	0685                	add	a3,a3,1
 684:	fec7f0e3          	bgeu	a5,a2,664 <printint+0x2a>
  if(neg)
 688:	00088c63          	beqz	a7,6a0 <printint+0x66>
    buf[i++] = '-';
 68c:	fd070793          	add	a5,a4,-48
 690:	00878733          	add	a4,a5,s0
 694:	02d00793          	li	a5,45
 698:	fef70823          	sb	a5,-16(a4)
 69c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6a0:	02e05863          	blez	a4,6d0 <printint+0x96>
 6a4:	fc040793          	add	a5,s0,-64
 6a8:	00e78933          	add	s2,a5,a4
 6ac:	fff78993          	add	s3,a5,-1
 6b0:	99ba                	add	s3,s3,a4
 6b2:	377d                	addw	a4,a4,-1
 6b4:	1702                	sll	a4,a4,0x20
 6b6:	9301                	srl	a4,a4,0x20
 6b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6bc:	fff94583          	lbu	a1,-1(s2)
 6c0:	8526                	mv	a0,s1
 6c2:	00000097          	auipc	ra,0x0
 6c6:	f56080e7          	jalr	-170(ra) # 618 <putc>
  while(--i >= 0)
 6ca:	197d                	add	s2,s2,-1
 6cc:	ff3918e3          	bne	s2,s3,6bc <printint+0x82>
}
 6d0:	70e2                	ld	ra,56(sp)
 6d2:	7442                	ld	s0,48(sp)
 6d4:	74a2                	ld	s1,40(sp)
 6d6:	7902                	ld	s2,32(sp)
 6d8:	69e2                	ld	s3,24(sp)
 6da:	6121                	add	sp,sp,64
 6dc:	8082                	ret
    x = -xx;
 6de:	40b005bb          	negw	a1,a1
    neg = 1;
 6e2:	4885                	li	a7,1
    x = -xx;
 6e4:	bf85                	j	654 <printint+0x1a>

00000000000006e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e6:	715d                	add	sp,sp,-80
 6e8:	e486                	sd	ra,72(sp)
 6ea:	e0a2                	sd	s0,64(sp)
 6ec:	fc26                	sd	s1,56(sp)
 6ee:	f84a                	sd	s2,48(sp)
 6f0:	f44e                	sd	s3,40(sp)
 6f2:	f052                	sd	s4,32(sp)
 6f4:	ec56                	sd	s5,24(sp)
 6f6:	e85a                	sd	s6,16(sp)
 6f8:	e45e                	sd	s7,8(sp)
 6fa:	e062                	sd	s8,0(sp)
 6fc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6fe:	0005c903          	lbu	s2,0(a1)
 702:	18090c63          	beqz	s2,89a <vprintf+0x1b4>
 706:	8aaa                	mv	s5,a0
 708:	8bb2                	mv	s7,a2
 70a:	00158493          	add	s1,a1,1
  state = 0;
 70e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 710:	02500a13          	li	s4,37
 714:	4b55                	li	s6,21
 716:	a839                	j	734 <vprintf+0x4e>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	efc080e7          	jalr	-260(ra) # 618 <putc>
 724:	a019                	j	72a <vprintf+0x44>
    } else if(state == '%'){
 726:	01498d63          	beq	s3,s4,740 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 72a:	0485                	add	s1,s1,1
 72c:	fff4c903          	lbu	s2,-1(s1)
 730:	16090563          	beqz	s2,89a <vprintf+0x1b4>
    if(state == 0){
 734:	fe0999e3          	bnez	s3,726 <vprintf+0x40>
      if(c == '%'){
 738:	ff4910e3          	bne	s2,s4,718 <vprintf+0x32>
        state = '%';
 73c:	89d2                	mv	s3,s4
 73e:	b7f5                	j	72a <vprintf+0x44>
      if(c == 'd'){
 740:	13490263          	beq	s2,s4,864 <vprintf+0x17e>
 744:	f9d9079b          	addw	a5,s2,-99
 748:	0ff7f793          	zext.b	a5,a5
 74c:	12fb6563          	bltu	s6,a5,876 <vprintf+0x190>
 750:	f9d9079b          	addw	a5,s2,-99
 754:	0ff7f713          	zext.b	a4,a5
 758:	10eb6f63          	bltu	s6,a4,876 <vprintf+0x190>
 75c:	00271793          	sll	a5,a4,0x2
 760:	00000717          	auipc	a4,0x0
 764:	4d070713          	add	a4,a4,1232 # c30 <statistics+0x1b2>
 768:	97ba                	add	a5,a5,a4
 76a:	439c                	lw	a5,0(a5)
 76c:	97ba                	add	a5,a5,a4
 76e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 770:	008b8913          	add	s2,s7,8
 774:	4685                	li	a3,1
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	ebc080e7          	jalr	-324(ra) # 63a <printint>
 786:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 788:	4981                	li	s3,0
 78a:	b745                	j	72a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	008b8913          	add	s2,s7,8
 790:	4681                	li	a3,0
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	ea0080e7          	jalr	-352(ra) # 63a <printint>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b751                	j	72a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7a8:	008b8913          	add	s2,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4641                	li	a2,16
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e84080e7          	jalr	-380(ra) # 63a <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b7a5                	j	72a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7c4:	008b8c13          	add	s8,s7,8
 7c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7cc:	03000593          	li	a1,48
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e46080e7          	jalr	-442(ra) # 618 <putc>
  putc(fd, 'x');
 7da:	07800593          	li	a1,120
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e38080e7          	jalr	-456(ra) # 618 <putc>
 7e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ea:	00000b97          	auipc	s7,0x0
 7ee:	49eb8b93          	add	s7,s7,1182 # c88 <digits>
 7f2:	03c9d793          	srl	a5,s3,0x3c
 7f6:	97de                	add	a5,a5,s7
 7f8:	0007c583          	lbu	a1,0(a5)
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	e1a080e7          	jalr	-486(ra) # 618 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 806:	0992                	sll	s3,s3,0x4
 808:	397d                	addw	s2,s2,-1
 80a:	fe0914e3          	bnez	s2,7f2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 80e:	8be2                	mv	s7,s8
      state = 0;
 810:	4981                	li	s3,0
 812:	bf21                	j	72a <vprintf+0x44>
        s = va_arg(ap, char*);
 814:	008b8993          	add	s3,s7,8
 818:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 81c:	02090163          	beqz	s2,83e <vprintf+0x158>
        while(*s != 0){
 820:	00094583          	lbu	a1,0(s2)
 824:	c9a5                	beqz	a1,894 <vprintf+0x1ae>
          putc(fd, *s);
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	df0080e7          	jalr	-528(ra) # 618 <putc>
          s++;
 830:	0905                	add	s2,s2,1
        while(*s != 0){
 832:	00094583          	lbu	a1,0(s2)
 836:	f9e5                	bnez	a1,826 <vprintf+0x140>
        s = va_arg(ap, char*);
 838:	8bce                	mv	s7,s3
      state = 0;
 83a:	4981                	li	s3,0
 83c:	b5fd                	j	72a <vprintf+0x44>
          s = "(null)";
 83e:	00000917          	auipc	s2,0x0
 842:	3ea90913          	add	s2,s2,1002 # c28 <statistics+0x1aa>
        while(*s != 0){
 846:	02800593          	li	a1,40
 84a:	bff1                	j	826 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 84c:	008b8913          	add	s2,s7,8
 850:	000bc583          	lbu	a1,0(s7)
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	dc2080e7          	jalr	-574(ra) # 618 <putc>
 85e:	8bca                	mv	s7,s2
      state = 0;
 860:	4981                	li	s3,0
 862:	b5e1                	j	72a <vprintf+0x44>
        putc(fd, c);
 864:	02500593          	li	a1,37
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	dae080e7          	jalr	-594(ra) # 618 <putc>
      state = 0;
 872:	4981                	li	s3,0
 874:	bd5d                	j	72a <vprintf+0x44>
        putc(fd, '%');
 876:	02500593          	li	a1,37
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	d9c080e7          	jalr	-612(ra) # 618 <putc>
        putc(fd, c);
 884:	85ca                	mv	a1,s2
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	d90080e7          	jalr	-624(ra) # 618 <putc>
      state = 0;
 890:	4981                	li	s3,0
 892:	bd61                	j	72a <vprintf+0x44>
        s = va_arg(ap, char*);
 894:	8bce                	mv	s7,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	bd49                	j	72a <vprintf+0x44>
    }
  }
}
 89a:	60a6                	ld	ra,72(sp)
 89c:	6406                	ld	s0,64(sp)
 89e:	74e2                	ld	s1,56(sp)
 8a0:	7942                	ld	s2,48(sp)
 8a2:	79a2                	ld	s3,40(sp)
 8a4:	7a02                	ld	s4,32(sp)
 8a6:	6ae2                	ld	s5,24(sp)
 8a8:	6b42                	ld	s6,16(sp)
 8aa:	6ba2                	ld	s7,8(sp)
 8ac:	6c02                	ld	s8,0(sp)
 8ae:	6161                	add	sp,sp,80
 8b0:	8082                	ret

00000000000008b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b2:	715d                	add	sp,sp,-80
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	add	s0,sp,32
 8ba:	e010                	sd	a2,0(s0)
 8bc:	e414                	sd	a3,8(s0)
 8be:	e818                	sd	a4,16(s0)
 8c0:	ec1c                	sd	a5,24(s0)
 8c2:	03043023          	sd	a6,32(s0)
 8c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ce:	8622                	mv	a2,s0
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e16080e7          	jalr	-490(ra) # 6e6 <vprintf>
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	6161                	add	sp,sp,80
 8de:	8082                	ret

00000000000008e0 <printf>:

void
printf(const char *fmt, ...)
{
 8e0:	711d                	add	sp,sp,-96
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	1000                	add	s0,sp,32
 8e8:	e40c                	sd	a1,8(s0)
 8ea:	e810                	sd	a2,16(s0)
 8ec:	ec14                	sd	a3,24(s0)
 8ee:	f018                	sd	a4,32(s0)
 8f0:	f41c                	sd	a5,40(s0)
 8f2:	03043823          	sd	a6,48(s0)
 8f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	00840613          	add	a2,s0,8
 8fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 902:	85aa                	mv	a1,a0
 904:	4505                	li	a0,1
 906:	00000097          	auipc	ra,0x0
 90a:	de0080e7          	jalr	-544(ra) # 6e6 <vprintf>
}
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	6125                	add	sp,sp,96
 914:	8082                	ret

0000000000000916 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 916:	1141                	add	sp,sp,-16
 918:	e422                	sd	s0,8(sp)
 91a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	00000797          	auipc	a5,0x0
 924:	3a87b783          	ld	a5,936(a5) # cc8 <freep>
 928:	a02d                	j	952 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 92a:	4618                	lw	a4,8(a2)
 92c:	9f2d                	addw	a4,a4,a1
 92e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	6310                	ld	a2,0(a4)
 936:	a83d                	j	974 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 938:	ff852703          	lw	a4,-8(a0)
 93c:	9f31                	addw	a4,a4,a2
 93e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 940:	ff053683          	ld	a3,-16(a0)
 944:	a091                	j	988 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 946:	6398                	ld	a4,0(a5)
 948:	00e7e463          	bltu	a5,a4,950 <free+0x3a>
 94c:	00e6ea63          	bltu	a3,a4,960 <free+0x4a>
{
 950:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	fed7fae3          	bgeu	a5,a3,946 <free+0x30>
 956:	6398                	ld	a4,0(a5)
 958:	00e6e463          	bltu	a3,a4,960 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	fee7eae3          	bltu	a5,a4,950 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 960:	ff852583          	lw	a1,-8(a0)
 964:	6390                	ld	a2,0(a5)
 966:	02059813          	sll	a6,a1,0x20
 96a:	01c85713          	srl	a4,a6,0x1c
 96e:	9736                	add	a4,a4,a3
 970:	fae60de3          	beq	a2,a4,92a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 978:	4790                	lw	a2,8(a5)
 97a:	02061593          	sll	a1,a2,0x20
 97e:	01c5d713          	srl	a4,a1,0x1c
 982:	973e                	add	a4,a4,a5
 984:	fae68ae3          	beq	a3,a4,938 <free+0x22>
    p->s.ptr = bp->s.ptr;
 988:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 98a:	00000717          	auipc	a4,0x0
 98e:	32f73f23          	sd	a5,830(a4) # cc8 <freep>
}
 992:	6422                	ld	s0,8(sp)
 994:	0141                	add	sp,sp,16
 996:	8082                	ret

0000000000000998 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 998:	7139                	add	sp,sp,-64
 99a:	fc06                	sd	ra,56(sp)
 99c:	f822                	sd	s0,48(sp)
 99e:	f426                	sd	s1,40(sp)
 9a0:	f04a                	sd	s2,32(sp)
 9a2:	ec4e                	sd	s3,24(sp)
 9a4:	e852                	sd	s4,16(sp)
 9a6:	e456                	sd	s5,8(sp)
 9a8:	e05a                	sd	s6,0(sp)
 9aa:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ac:	02051493          	sll	s1,a0,0x20
 9b0:	9081                	srl	s1,s1,0x20
 9b2:	04bd                	add	s1,s1,15
 9b4:	8091                	srl	s1,s1,0x4
 9b6:	0014899b          	addw	s3,s1,1
 9ba:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9bc:	00000517          	auipc	a0,0x0
 9c0:	30c53503          	ld	a0,780(a0) # cc8 <freep>
 9c4:	c515                	beqz	a0,9f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c8:	4798                	lw	a4,8(a5)
 9ca:	02977f63          	bgeu	a4,s1,a08 <malloc+0x70>
  if(nu < 4096)
 9ce:	8a4e                	mv	s4,s3
 9d0:	0009871b          	sext.w	a4,s3
 9d4:	6685                	lui	a3,0x1
 9d6:	00d77363          	bgeu	a4,a3,9dc <malloc+0x44>
 9da:	6a05                	lui	s4,0x1
 9dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e4:	00000917          	auipc	s2,0x0
 9e8:	2e490913          	add	s2,s2,740 # cc8 <freep>
  if(p == (char*)-1)
 9ec:	5afd                	li	s5,-1
 9ee:	a895                	j	a62 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9f0:	00001797          	auipc	a5,0x1
 9f4:	2e078793          	add	a5,a5,736 # 1cd0 <base>
 9f8:	00000717          	auipc	a4,0x0
 9fc:	2cf73823          	sd	a5,720(a4) # cc8 <freep>
 a00:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a02:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a06:	b7e1                	j	9ce <malloc+0x36>
      if(p->s.size == nunits)
 a08:	02e48c63          	beq	s1,a4,a40 <malloc+0xa8>
        p->s.size -= nunits;
 a0c:	4137073b          	subw	a4,a4,s3
 a10:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a12:	02071693          	sll	a3,a4,0x20
 a16:	01c6d713          	srl	a4,a3,0x1c
 a1a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a20:	00000717          	auipc	a4,0x0
 a24:	2aa73423          	sd	a0,680(a4) # cc8 <freep>
      return (void*)(p + 1);
 a28:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a2c:	70e2                	ld	ra,56(sp)
 a2e:	7442                	ld	s0,48(sp)
 a30:	74a2                	ld	s1,40(sp)
 a32:	7902                	ld	s2,32(sp)
 a34:	69e2                	ld	s3,24(sp)
 a36:	6a42                	ld	s4,16(sp)
 a38:	6aa2                	ld	s5,8(sp)
 a3a:	6b02                	ld	s6,0(sp)
 a3c:	6121                	add	sp,sp,64
 a3e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a40:	6398                	ld	a4,0(a5)
 a42:	e118                	sd	a4,0(a0)
 a44:	bff1                	j	a20 <malloc+0x88>
  hp->s.size = nu;
 a46:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a4a:	0541                	add	a0,a0,16
 a4c:	00000097          	auipc	ra,0x0
 a50:	eca080e7          	jalr	-310(ra) # 916 <free>
  return freep;
 a54:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a58:	d971                	beqz	a0,a2c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5c:	4798                	lw	a4,8(a5)
 a5e:	fa9775e3          	bgeu	a4,s1,a08 <malloc+0x70>
    if(p == freep)
 a62:	00093703          	ld	a4,0(s2)
 a66:	853e                	mv	a0,a5
 a68:	fef719e3          	bne	a4,a5,a5a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a6c:	8552                	mv	a0,s4
 a6e:	00000097          	auipc	ra,0x0
 a72:	b92080e7          	jalr	-1134(ra) # 600 <sbrk>
  if(p == (char*)-1)
 a76:	fd5518e3          	bne	a0,s5,a46 <malloc+0xae>
        return 0;
 a7a:	4501                	li	a0,0
 a7c:	bf45                	j	a2c <malloc+0x94>

0000000000000a7e <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 a7e:	7179                	add	sp,sp,-48
 a80:	f406                	sd	ra,40(sp)
 a82:	f022                	sd	s0,32(sp)
 a84:	ec26                	sd	s1,24(sp)
 a86:	e84a                	sd	s2,16(sp)
 a88:	e44e                	sd	s3,8(sp)
 a8a:	e052                	sd	s4,0(sp)
 a8c:	1800                	add	s0,sp,48
 a8e:	8a2a                	mv	s4,a0
 a90:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 a92:	4581                	li	a1,0
 a94:	00000517          	auipc	a0,0x0
 a98:	20c50513          	add	a0,a0,524 # ca0 <digits+0x18>
 a9c:	00000097          	auipc	ra,0x0
 aa0:	b1c080e7          	jalr	-1252(ra) # 5b8 <open>
  if(fd < 0) {
 aa4:	04054263          	bltz	a0,ae8 <statistics+0x6a>
 aa8:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 aaa:	4481                	li	s1,0
 aac:	03205063          	blez	s2,acc <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 ab0:	4099063b          	subw	a2,s2,s1
 ab4:	009a05b3          	add	a1,s4,s1
 ab8:	854e                	mv	a0,s3
 aba:	00000097          	auipc	ra,0x0
 abe:	ad6080e7          	jalr	-1322(ra) # 590 <read>
 ac2:	00054563          	bltz	a0,acc <statistics+0x4e>
      break;
    }
    i += n;
 ac6:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 ac8:	ff24c4e3          	blt	s1,s2,ab0 <statistics+0x32>
  }
  close(fd);
 acc:	854e                	mv	a0,s3
 ace:	00000097          	auipc	ra,0x0
 ad2:	ad2080e7          	jalr	-1326(ra) # 5a0 <close>
  return i;
}
 ad6:	8526                	mv	a0,s1
 ad8:	70a2                	ld	ra,40(sp)
 ada:	7402                	ld	s0,32(sp)
 adc:	64e2                	ld	s1,24(sp)
 ade:	6942                	ld	s2,16(sp)
 ae0:	69a2                	ld	s3,8(sp)
 ae2:	6a02                	ld	s4,0(sp)
 ae4:	6145                	add	sp,sp,48
 ae6:	8082                	ret
      fprintf(2, "stats: open failed\n");
 ae8:	00000597          	auipc	a1,0x0
 aec:	1c858593          	add	a1,a1,456 # cb0 <digits+0x28>
 af0:	4509                	li	a0,2
 af2:	00000097          	auipc	ra,0x0
 af6:	dc0080e7          	jalr	-576(ra) # 8b2 <fprintf>
      exit(1);
 afa:	4505                	li	a0,1
 afc:	00000097          	auipc	ra,0x0
 b00:	a7c080e7          	jalr	-1412(ra) # 578 <exit>
