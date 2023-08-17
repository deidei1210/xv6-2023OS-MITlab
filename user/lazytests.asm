
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:

#define REGION_SZ (1024 * 1024 * 1024)

void
sparse_memory(char *s)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  char *i, *prev_end, *new_end;
  
  prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	608080e7          	jalr	1544(ra) # 614 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  14:	57fd                	li	a5,-1
  16:	02f50c63          	beq	a0,a5,4e <sparse_memory+0x4e>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	400017b7          	lui	a5,0x40001
  22:	00f50733          	add	a4,a0,a5
  26:	87b2                	mv	a5,a2
  28:	000406b7          	lui	a3,0x40
    *(char **)i = i;
  2c:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  2e:	97b6                	add	a5,a5,a3
  30:	fee79ee3          	bne	a5,a4,2c <sparse_memory+0x2c>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  34:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
  38:	621c                	ld	a5,0(a2)
  3a:	02c79763          	bne	a5,a2,68 <sparse_memory+0x68>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  3e:	9636                	add	a2,a2,a3
  40:	fee61ce3          	bne	a2,a4,38 <sparse_memory+0x38>
      printf("failed to read value from memory\n");
      exit(1);
    }
  }

  exit(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	546080e7          	jalr	1350(ra) # 58c <exit>
    printf("sbrk() failed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	a4a50513          	add	a0,a0,-1462 # a98 <malloc+0xec>
  56:	00001097          	auipc	ra,0x1
  5a:	89e080e7          	jalr	-1890(ra) # 8f4 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	52c080e7          	jalr	1324(ra) # 58c <exit>
      printf("failed to read value from memory\n");
  68:	00001517          	auipc	a0,0x1
  6c:	a4050513          	add	a0,a0,-1472 # aa8 <malloc+0xfc>
  70:	00001097          	auipc	ra,0x1
  74:	884080e7          	jalr	-1916(ra) # 8f4 <printf>
      exit(1);
  78:	4505                	li	a0,1
  7a:	00000097          	auipc	ra,0x0
  7e:	512080e7          	jalr	1298(ra) # 58c <exit>

0000000000000082 <sparse_memory_unmap>:
}

void
sparse_memory_unmap(char *s)
{
  82:	7139                	add	sp,sp,-64
  84:	fc06                	sd	ra,56(sp)
  86:	f822                	sd	s0,48(sp)
  88:	f426                	sd	s1,40(sp)
  8a:	f04a                	sd	s2,32(sp)
  8c:	ec4e                	sd	s3,24(sp)
  8e:	0080                	add	s0,sp,64
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  90:	40000537          	lui	a0,0x40000
  94:	00000097          	auipc	ra,0x0
  98:	580080e7          	jalr	1408(ra) # 614 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  9c:	57fd                	li	a5,-1
  9e:	04f50963          	beq	a0,a5,f0 <sparse_memory_unmap+0x6e>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  a2:	6905                	lui	s2,0x1
  a4:	992a                	add	s2,s2,a0
  a6:	400017b7          	lui	a5,0x40001
  aa:	00f504b3          	add	s1,a0,a5
  ae:	87ca                	mv	a5,s2
  b0:	01000737          	lui	a4,0x1000
    *(char **)i = i;
  b4:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b6:	97ba                	add	a5,a5,a4
  b8:	fef49ee3          	bne	s1,a5,b4 <sparse_memory_unmap+0x32>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  bc:	010009b7          	lui	s3,0x1000
    pid = fork();
  c0:	00000097          	auipc	ra,0x0
  c4:	4c4080e7          	jalr	1220(ra) # 584 <fork>
    if (pid < 0) {
  c8:	04054163          	bltz	a0,10a <sparse_memory_unmap+0x88>
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
  cc:	cd21                	beqz	a0,124 <sparse_memory_unmap+0xa2>
      sbrk(-1L * REGION_SZ);
      *(char **)i = i;
      exit(0);
    } else {
      int status;
      wait(&status);
  ce:	fcc40513          	add	a0,s0,-52
  d2:	00000097          	auipc	ra,0x0
  d6:	4c2080e7          	jalr	1218(ra) # 594 <wait>
      if (status == 0) {
  da:	fcc42783          	lw	a5,-52(s0)
  de:	c3a5                	beqz	a5,13e <sparse_memory_unmap+0xbc>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  e0:	994e                	add	s2,s2,s3
  e2:	fd249fe3          	bne	s1,s2,c0 <sparse_memory_unmap+0x3e>
        exit(1);
      }
    }
  }

  exit(0);
  e6:	4501                	li	a0,0
  e8:	00000097          	auipc	ra,0x0
  ec:	4a4080e7          	jalr	1188(ra) # 58c <exit>
    printf("sbrk() failed\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	9a850513          	add	a0,a0,-1624 # a98 <malloc+0xec>
  f8:	00000097          	auipc	ra,0x0
  fc:	7fc080e7          	jalr	2044(ra) # 8f4 <printf>
    exit(1);
 100:	4505                	li	a0,1
 102:	00000097          	auipc	ra,0x0
 106:	48a080e7          	jalr	1162(ra) # 58c <exit>
      printf("error forking\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	9c650513          	add	a0,a0,-1594 # ad0 <malloc+0x124>
 112:	00000097          	auipc	ra,0x0
 116:	7e2080e7          	jalr	2018(ra) # 8f4 <printf>
      exit(1);
 11a:	4505                	li	a0,1
 11c:	00000097          	auipc	ra,0x0
 120:	470080e7          	jalr	1136(ra) # 58c <exit>
      sbrk(-1L * REGION_SZ);
 124:	c0000537          	lui	a0,0xc0000
 128:	00000097          	auipc	ra,0x0
 12c:	4ec080e7          	jalr	1260(ra) # 614 <sbrk>
      *(char **)i = i;
 130:	01293023          	sd	s2,0(s2) # 1000 <__BSS_END__+0x368>
      exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	456080e7          	jalr	1110(ra) # 58c <exit>
        printf("memory not unmapped\n");
 13e:	00001517          	auipc	a0,0x1
 142:	9a250513          	add	a0,a0,-1630 # ae0 <malloc+0x134>
 146:	00000097          	auipc	ra,0x0
 14a:	7ae080e7          	jalr	1966(ra) # 8f4 <printf>
        exit(1);
 14e:	4505                	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	43c080e7          	jalr	1084(ra) # 58c <exit>

0000000000000158 <oom>:
}

void
oom(char *s)
{
 158:	7179                	add	sp,sp,-48
 15a:	f406                	sd	ra,40(sp)
 15c:	f022                	sd	s0,32(sp)
 15e:	ec26                	sd	s1,24(sp)
 160:	1800                	add	s0,sp,48
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
 162:	00000097          	auipc	ra,0x0
 166:	422080e7          	jalr	1058(ra) # 584 <fork>
    m1 = 0;
 16a:	4481                	li	s1,0
  if((pid = fork()) == 0){
 16c:	c10d                	beqz	a0,18e <oom+0x36>
      m1 = m2;
    }
    exit(0);
  } else {
    int xstatus;
    wait(&xstatus);
 16e:	fdc40513          	add	a0,s0,-36
 172:	00000097          	auipc	ra,0x0
 176:	422080e7          	jalr	1058(ra) # 594 <wait>
    exit(xstatus == 0);
 17a:	fdc42503          	lw	a0,-36(s0)
 17e:	00153513          	seqz	a0,a0
 182:	00000097          	auipc	ra,0x0
 186:	40a080e7          	jalr	1034(ra) # 58c <exit>
      *(char**)m2 = m1;
 18a:	e104                	sd	s1,0(a0)
      m1 = m2;
 18c:	84aa                	mv	s1,a0
    while((m2 = malloc(4096*4096)) != 0){
 18e:	01000537          	lui	a0,0x1000
 192:	00001097          	auipc	ra,0x1
 196:	81a080e7          	jalr	-2022(ra) # 9ac <malloc>
 19a:	f965                	bnez	a0,18a <oom+0x32>
    exit(0);
 19c:	00000097          	auipc	ra,0x0
 1a0:	3f0080e7          	jalr	1008(ra) # 58c <exit>

00000000000001a4 <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
 1a4:	7179                	add	sp,sp,-48
 1a6:	f406                	sd	ra,40(sp)
 1a8:	f022                	sd	s0,32(sp)
 1aa:	ec26                	sd	s1,24(sp)
 1ac:	e84a                	sd	s2,16(sp)
 1ae:	1800                	add	s0,sp,48
 1b0:	892a                	mv	s2,a0
 1b2:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("running test %s\n", s);
 1b4:	00001517          	auipc	a0,0x1
 1b8:	94450513          	add	a0,a0,-1724 # af8 <malloc+0x14c>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	738080e7          	jalr	1848(ra) # 8f4 <printf>
  if((pid = fork()) < 0) {
 1c4:	00000097          	auipc	ra,0x0
 1c8:	3c0080e7          	jalr	960(ra) # 584 <fork>
 1cc:	02054f63          	bltz	a0,20a <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
 1d0:	c931                	beqz	a0,224 <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
 1d2:	fdc40513          	add	a0,s0,-36
 1d6:	00000097          	auipc	ra,0x0
 1da:	3be080e7          	jalr	958(ra) # 594 <wait>
    if(xstatus != 0) 
 1de:	fdc42783          	lw	a5,-36(s0)
 1e2:	cba1                	beqz	a5,232 <run+0x8e>
      printf("test %s: FAILED\n", s);
 1e4:	85a6                	mv	a1,s1
 1e6:	00001517          	auipc	a0,0x1
 1ea:	94250513          	add	a0,a0,-1726 # b28 <malloc+0x17c>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	706080e7          	jalr	1798(ra) # 8f4 <printf>
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
 1f6:	fdc42503          	lw	a0,-36(s0)
  }
}
 1fa:	00153513          	seqz	a0,a0
 1fe:	70a2                	ld	ra,40(sp)
 200:	7402                	ld	s0,32(sp)
 202:	64e2                	ld	s1,24(sp)
 204:	6942                	ld	s2,16(sp)
 206:	6145                	add	sp,sp,48
 208:	8082                	ret
    printf("runtest: fork error\n");
 20a:	00001517          	auipc	a0,0x1
 20e:	90650513          	add	a0,a0,-1786 # b10 <malloc+0x164>
 212:	00000097          	auipc	ra,0x0
 216:	6e2080e7          	jalr	1762(ra) # 8f4 <printf>
    exit(1);
 21a:	4505                	li	a0,1
 21c:	00000097          	auipc	ra,0x0
 220:	370080e7          	jalr	880(ra) # 58c <exit>
    f(s);
 224:	8526                	mv	a0,s1
 226:	9902                	jalr	s2
    exit(0);
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	362080e7          	jalr	866(ra) # 58c <exit>
      printf("test %s: OK\n", s);
 232:	85a6                	mv	a1,s1
 234:	00001517          	auipc	a0,0x1
 238:	90c50513          	add	a0,a0,-1780 # b40 <malloc+0x194>
 23c:	00000097          	auipc	ra,0x0
 240:	6b8080e7          	jalr	1720(ra) # 8f4 <printf>
 244:	bf4d                	j	1f6 <run+0x52>

0000000000000246 <main>:

int
main(int argc, char *argv[])
{
 246:	7119                	add	sp,sp,-128
 248:	fc86                	sd	ra,120(sp)
 24a:	f8a2                	sd	s0,112(sp)
 24c:	f4a6                	sd	s1,104(sp)
 24e:	f0ca                	sd	s2,96(sp)
 250:	ecce                	sd	s3,88(sp)
 252:	e8d2                	sd	s4,80(sp)
 254:	e4d6                	sd	s5,72(sp)
 256:	0100                	add	s0,sp,128
  char *n = 0;
  if(argc > 1) {
 258:	4785                	li	a5,1
  char *n = 0;
 25a:	4981                	li	s3,0
  if(argc > 1) {
 25c:	00a7d463          	bge	a5,a0,264 <main+0x1e>
    n = argv[1];
 260:	0085b983          	ld	s3,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 264:	00001797          	auipc	a5,0x1
 268:	96478793          	add	a5,a5,-1692 # bc8 <malloc+0x21c>
 26c:	0007b883          	ld	a7,0(a5)
 270:	0087b803          	ld	a6,8(a5)
 274:	6b88                	ld	a0,16(a5)
 276:	6f8c                	ld	a1,24(a5)
 278:	7390                	ld	a2,32(a5)
 27a:	7794                	ld	a3,40(a5)
 27c:	7b98                	ld	a4,48(a5)
 27e:	7f9c                	ld	a5,56(a5)
 280:	f9143023          	sd	a7,-128(s0)
 284:	f9043423          	sd	a6,-120(s0)
 288:	f8a43823          	sd	a0,-112(s0)
 28c:	f8b43c23          	sd	a1,-104(s0)
 290:	fac43023          	sd	a2,-96(s0)
 294:	fad43423          	sd	a3,-88(s0)
 298:	fae43823          	sd	a4,-80(s0)
 29c:	faf43c23          	sd	a5,-72(s0)
    { sparse_memory_unmap, "lazy unmap"},
    { oom, "out of memory"},
    { 0, 0},
  };
    
  printf("lazytests starting\n");
 2a0:	00001517          	auipc	a0,0x1
 2a4:	8b050513          	add	a0,a0,-1872 # b50 <malloc+0x1a4>
 2a8:	00000097          	auipc	ra,0x0
 2ac:	64c080e7          	jalr	1612(ra) # 8f4 <printf>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
 2b0:	f8843903          	ld	s2,-120(s0)
 2b4:	04090963          	beqz	s2,306 <main+0xc0>
 2b8:	f8040493          	add	s1,s0,-128
  int fail = 0;
 2bc:	4a01                	li	s4,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
 2be:	4a85                	li	s5,1
 2c0:	a031                	j	2cc <main+0x86>
  for (struct test *t = tests; t->s != 0; t++) {
 2c2:	04c1                	add	s1,s1,16
 2c4:	0084b903          	ld	s2,8(s1)
 2c8:	02090463          	beqz	s2,2f0 <main+0xaa>
    if((n == 0) || strcmp(t->s, n) == 0) {
 2cc:	00098963          	beqz	s3,2de <main+0x98>
 2d0:	85ce                	mv	a1,s3
 2d2:	854a                	mv	a0,s2
 2d4:	00000097          	auipc	ra,0x0
 2d8:	068080e7          	jalr	104(ra) # 33c <strcmp>
 2dc:	f17d                	bnez	a0,2c2 <main+0x7c>
      if(!run(t->f, t->s))
 2de:	85ca                	mv	a1,s2
 2e0:	6088                	ld	a0,0(s1)
 2e2:	00000097          	auipc	ra,0x0
 2e6:	ec2080e7          	jalr	-318(ra) # 1a4 <run>
 2ea:	fd61                	bnez	a0,2c2 <main+0x7c>
        fail = 1;
 2ec:	8a56                	mv	s4,s5
 2ee:	bfd1                	j	2c2 <main+0x7c>
    }
  }
  if(!fail)
 2f0:	000a0b63          	beqz	s4,306 <main+0xc0>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
 2f4:	00001517          	auipc	a0,0x1
 2f8:	88c50513          	add	a0,a0,-1908 # b80 <malloc+0x1d4>
 2fc:	00000097          	auipc	ra,0x0
 300:	5f8080e7          	jalr	1528(ra) # 8f4 <printf>
 304:	a809                	j	316 <main+0xd0>
    printf("ALL TESTS PASSED\n");
 306:	00001517          	auipc	a0,0x1
 30a:	86250513          	add	a0,a0,-1950 # b68 <malloc+0x1bc>
 30e:	00000097          	auipc	ra,0x0
 312:	5e6080e7          	jalr	1510(ra) # 8f4 <printf>
  exit(1);   // not reached.
 316:	4505                	li	a0,1
 318:	00000097          	auipc	ra,0x0
 31c:	274080e7          	jalr	628(ra) # 58c <exit>

0000000000000320 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 320:	1141                	add	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 326:	87aa                	mv	a5,a0
 328:	0585                	add	a1,a1,1
 32a:	0785                	add	a5,a5,1
 32c:	fff5c703          	lbu	a4,-1(a1)
 330:	fee78fa3          	sb	a4,-1(a5)
 334:	fb75                	bnez	a4,328 <strcpy+0x8>
    ;
  return os;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	add	sp,sp,16
 33a:	8082                	ret

000000000000033c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33c:	1141                	add	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 342:	00054783          	lbu	a5,0(a0)
 346:	cb91                	beqz	a5,35a <strcmp+0x1e>
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00f71763          	bne	a4,a5,35a <strcmp+0x1e>
    p++, q++;
 350:	0505                	add	a0,a0,1
 352:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 354:	00054783          	lbu	a5,0(a0)
 358:	fbe5                	bnez	a5,348 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 35a:	0005c503          	lbu	a0,0(a1)
}
 35e:	40a7853b          	subw	a0,a5,a0
 362:	6422                	ld	s0,8(sp)
 364:	0141                	add	sp,sp,16
 366:	8082                	ret

0000000000000368 <strlen>:

unsigned int
strlen(const char *s)
{
 368:	1141                	add	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf91                	beqz	a5,38e <strlen+0x26>
 374:	0505                	add	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	86be                	mv	a3,a5
 37a:	0785                	add	a5,a5,1
 37c:	fff7c703          	lbu	a4,-1(a5)
 380:	ff65                	bnez	a4,378 <strlen+0x10>
 382:	40a6853b          	subw	a0,a3,a0
 386:	2505                	addw	a0,a0,1
    ;
  return n;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	add	sp,sp,16
 38c:	8082                	ret
  for(n = 0; s[n]; n++)
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strlen+0x20>

0000000000000392 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
 392:	1141                	add	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 398:	ca19                	beqz	a2,3ae <memset+0x1c>
 39a:	87aa                	mv	a5,a0
 39c:	1602                	sll	a2,a2,0x20
 39e:	9201                	srl	a2,a2,0x20
 3a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a8:	0785                	add	a5,a5,1
 3aa:	fee79de3          	bne	a5,a4,3a4 <memset+0x12>
  }
  return dst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	add	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <strchr>:

char*
strchr(const char *s, char c)
{
 3b4:	1141                	add	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	add	s0,sp,16
  for(; *s; s++)
 3ba:	00054783          	lbu	a5,0(a0)
 3be:	cb99                	beqz	a5,3d4 <strchr+0x20>
    if(*s == c)
 3c0:	00f58763          	beq	a1,a5,3ce <strchr+0x1a>
  for(; *s; s++)
 3c4:	0505                	add	a0,a0,1
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	fbfd                	bnez	a5,3c0 <strchr+0xc>
      return (char*)s;
  return 0;
 3cc:	4501                	li	a0,0
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	add	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <strchr+0x1a>

00000000000003d8 <gets>:

char*
gets(char *buf, int max)
{
 3d8:	711d                	add	sp,sp,-96
 3da:	ec86                	sd	ra,88(sp)
 3dc:	e8a2                	sd	s0,80(sp)
 3de:	e4a6                	sd	s1,72(sp)
 3e0:	e0ca                	sd	s2,64(sp)
 3e2:	fc4e                	sd	s3,56(sp)
 3e4:	f852                	sd	s4,48(sp)
 3e6:	f456                	sd	s5,40(sp)
 3e8:	f05a                	sd	s6,32(sp)
 3ea:	ec5e                	sd	s7,24(sp)
 3ec:	1080                	add	s0,sp,96
 3ee:	8baa                	mv	s7,a0
 3f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f2:	892a                	mv	s2,a0
 3f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f6:	4aa9                	li	s5,10
 3f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3fa:	89a6                	mv	s3,s1
 3fc:	2485                	addw	s1,s1,1
 3fe:	0344d863          	bge	s1,s4,42e <gets+0x56>
    cc = read(0, &c, 1);
 402:	4605                	li	a2,1
 404:	faf40593          	add	a1,s0,-81
 408:	4501                	li	a0,0
 40a:	00000097          	auipc	ra,0x0
 40e:	19a080e7          	jalr	410(ra) # 5a4 <read>
    if(cc < 1)
 412:	00a05e63          	blez	a0,42e <gets+0x56>
    buf[i++] = c;
 416:	faf44783          	lbu	a5,-81(s0)
 41a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41e:	01578763          	beq	a5,s5,42c <gets+0x54>
 422:	0905                	add	s2,s2,1
 424:	fd679be3          	bne	a5,s6,3fa <gets+0x22>
  for(i=0; i+1 < max; ){
 428:	89a6                	mv	s3,s1
 42a:	a011                	j	42e <gets+0x56>
 42c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42e:	99de                	add	s3,s3,s7
 430:	00098023          	sb	zero,0(s3) # 1000000 <__global_pointer$+0xffeb87>
  return buf;
}
 434:	855e                	mv	a0,s7
 436:	60e6                	ld	ra,88(sp)
 438:	6446                	ld	s0,80(sp)
 43a:	64a6                	ld	s1,72(sp)
 43c:	6906                	ld	s2,64(sp)
 43e:	79e2                	ld	s3,56(sp)
 440:	7a42                	ld	s4,48(sp)
 442:	7aa2                	ld	s5,40(sp)
 444:	7b02                	ld	s6,32(sp)
 446:	6be2                	ld	s7,24(sp)
 448:	6125                	add	sp,sp,96
 44a:	8082                	ret

000000000000044c <stat>:

int
stat(const char *n, struct stat *st)
{
 44c:	1101                	add	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	e426                	sd	s1,8(sp)
 454:	e04a                	sd	s2,0(sp)
 456:	1000                	add	s0,sp,32
 458:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 45a:	4581                	li	a1,0
 45c:	00000097          	auipc	ra,0x0
 460:	170080e7          	jalr	368(ra) # 5cc <open>
  if(fd < 0)
 464:	02054563          	bltz	a0,48e <stat+0x42>
 468:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 46a:	85ca                	mv	a1,s2
 46c:	00000097          	auipc	ra,0x0
 470:	178080e7          	jalr	376(ra) # 5e4 <fstat>
 474:	892a                	mv	s2,a0
  close(fd);
 476:	8526                	mv	a0,s1
 478:	00000097          	auipc	ra,0x0
 47c:	13c080e7          	jalr	316(ra) # 5b4 <close>
  return r;
}
 480:	854a                	mv	a0,s2
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	64a2                	ld	s1,8(sp)
 488:	6902                	ld	s2,0(sp)
 48a:	6105                	add	sp,sp,32
 48c:	8082                	ret
    return -1;
 48e:	597d                	li	s2,-1
 490:	bfc5                	j	480 <stat+0x34>

0000000000000492 <atoi>:

int
atoi(const char *s)
{
 492:	1141                	add	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 498:	00054683          	lbu	a3,0(a0)
 49c:	fd06879b          	addw	a5,a3,-48 # 3ffd0 <__global_pointer$+0x3eb57>
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	4625                	li	a2,9
 4a6:	02f66863          	bltu	a2,a5,4d6 <atoi+0x44>
 4aa:	872a                	mv	a4,a0
  n = 0;
 4ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ae:	0705                	add	a4,a4,1 # 1000001 <__global_pointer$+0xffeb88>
 4b0:	0025179b          	sllw	a5,a0,0x2
 4b4:	9fa9                	addw	a5,a5,a0
 4b6:	0017979b          	sllw	a5,a5,0x1
 4ba:	9fb5                	addw	a5,a5,a3
 4bc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c0:	00074683          	lbu	a3,0(a4)
 4c4:	fd06879b          	addw	a5,a3,-48
 4c8:	0ff7f793          	zext.b	a5,a5
 4cc:	fef671e3          	bgeu	a2,a5,4ae <atoi+0x1c>
  return n;
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	add	sp,sp,16
 4d4:	8082                	ret
  n = 0;
 4d6:	4501                	li	a0,0
 4d8:	bfe5                	j	4d0 <atoi+0x3e>

00000000000004da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4da:	1141                	add	sp,sp,-16
 4dc:	e422                	sd	s0,8(sp)
 4de:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e0:	02b57463          	bgeu	a0,a1,508 <memmove+0x2e>
    while(n-- > 0)
 4e4:	00c05f63          	blez	a2,502 <memmove+0x28>
 4e8:	1602                	sll	a2,a2,0x20
 4ea:	9201                	srl	a2,a2,0x20
 4ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f2:	0585                	add	a1,a1,1
 4f4:	0705                	add	a4,a4,1
 4f6:	fff5c683          	lbu	a3,-1(a1)
 4fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4fe:	fee79ae3          	bne	a5,a4,4f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	add	sp,sp,16
 506:	8082                	ret
    dst += n;
 508:	00c50733          	add	a4,a0,a2
    src += n;
 50c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 50e:	fec05ae3          	blez	a2,502 <memmove+0x28>
 512:	fff6079b          	addw	a5,a2,-1 # fff <__BSS_END__+0x367>
 516:	1782                	sll	a5,a5,0x20
 518:	9381                	srl	a5,a5,0x20
 51a:	fff7c793          	not	a5,a5
 51e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 520:	15fd                	add	a1,a1,-1
 522:	177d                	add	a4,a4,-1
 524:	0005c683          	lbu	a3,0(a1)
 528:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 52c:	fee79ae3          	bne	a5,a4,520 <memmove+0x46>
 530:	bfc9                	j	502 <memmove+0x28>

0000000000000532 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
 532:	1141                	add	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 538:	ca05                	beqz	a2,568 <memcmp+0x36>
 53a:	fff6069b          	addw	a3,a2,-1
 53e:	1682                	sll	a3,a3,0x20
 540:	9281                	srl	a3,a3,0x20
 542:	0685                	add	a3,a3,1
 544:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 546:	00054783          	lbu	a5,0(a0)
 54a:	0005c703          	lbu	a4,0(a1)
 54e:	00e79863          	bne	a5,a4,55e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 552:	0505                	add	a0,a0,1
    p2++;
 554:	0585                	add	a1,a1,1
  while (n-- > 0) {
 556:	fed518e3          	bne	a0,a3,546 <memcmp+0x14>
  }
  return 0;
 55a:	4501                	li	a0,0
 55c:	a019                	j	562 <memcmp+0x30>
      return *p1 - *p2;
 55e:	40e7853b          	subw	a0,a5,a4
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	add	sp,sp,16
 566:	8082                	ret
  return 0;
 568:	4501                	li	a0,0
 56a:	bfe5                	j	562 <memcmp+0x30>

000000000000056c <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
 56c:	1141                	add	sp,sp,-16
 56e:	e406                	sd	ra,8(sp)
 570:	e022                	sd	s0,0(sp)
 572:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 574:	00000097          	auipc	ra,0x0
 578:	f66080e7          	jalr	-154(ra) # 4da <memmove>
}
 57c:	60a2                	ld	ra,8(sp)
 57e:	6402                	ld	s0,0(sp)
 580:	0141                	add	sp,sp,16
 582:	8082                	ret

0000000000000584 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 584:	4885                	li	a7,1
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exit>:
.global exit
exit:
 li a7, SYS_exit
 58c:	4889                	li	a7,2
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <wait>:
.global wait
wait:
 li a7, SYS_wait
 594:	488d                	li	a7,3
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 59c:	4891                	li	a7,4
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <read>:
.global read
read:
 li a7, SYS_read
 5a4:	4895                	li	a7,5
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <write>:
.global write
write:
 li a7, SYS_write
 5ac:	48c1                	li	a7,16
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <close>:
.global close
close:
 li a7, SYS_close
 5b4:	48d5                	li	a7,21
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5bc:	4899                	li	a7,6
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c4:	489d                	li	a7,7
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <open>:
.global open
open:
 li a7, SYS_open
 5cc:	48bd                	li	a7,15
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d4:	48c5                	li	a7,17
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5dc:	48c9                	li	a7,18
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e4:	48a1                	li	a7,8
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <link>:
.global link
link:
 li a7, SYS_link
 5ec:	48cd                	li	a7,19
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f4:	48d1                	li	a7,20
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fc:	48a5                	li	a7,9
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <dup>:
.global dup
dup:
 li a7, SYS_dup
 604:	48a9                	li	a7,10
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60c:	48ad                	li	a7,11
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 614:	48b1                	li	a7,12
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 61c:	48b5                	li	a7,13
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 624:	48b9                	li	a7,14
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62c:	1101                	add	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	add	s0,sp,32
 634:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 638:	4605                	li	a2,1
 63a:	fef40593          	add	a1,s0,-17
 63e:	00000097          	auipc	ra,0x0
 642:	f6e080e7          	jalr	-146(ra) # 5ac <write>
}
 646:	60e2                	ld	ra,24(sp)
 648:	6442                	ld	s0,16(sp)
 64a:	6105                	add	sp,sp,32
 64c:	8082                	ret

000000000000064e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64e:	7139                	add	sp,sp,-64
 650:	fc06                	sd	ra,56(sp)
 652:	f822                	sd	s0,48(sp)
 654:	f426                	sd	s1,40(sp)
 656:	f04a                	sd	s2,32(sp)
 658:	ec4e                	sd	s3,24(sp)
 65a:	0080                	add	s0,sp,64
 65c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65e:	c299                	beqz	a3,664 <printint+0x16>
 660:	0805c963          	bltz	a1,6f2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 664:	2581                	sext.w	a1,a1
  neg = 0;
 666:	4881                	li	a7,0
 668:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 66c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66e:	2601                	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	5f850513          	add	a0,a0,1528 # c68 <digits>
 678:	883a                	mv	a6,a4
 67a:	2705                	addw	a4,a4,1
 67c:	02c5f7bb          	remuw	a5,a1,a2
 680:	1782                	sll	a5,a5,0x20
 682:	9381                	srl	a5,a5,0x20
 684:	97aa                	add	a5,a5,a0
 686:	0007c783          	lbu	a5,0(a5)
 68a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68e:	0005879b          	sext.w	a5,a1
 692:	02c5d5bb          	divuw	a1,a1,a2
 696:	0685                	add	a3,a3,1
 698:	fec7f0e3          	bgeu	a5,a2,678 <printint+0x2a>
  if(neg)
 69c:	00088c63          	beqz	a7,6b4 <printint+0x66>
    buf[i++] = '-';
 6a0:	fd070793          	add	a5,a4,-48
 6a4:	00878733          	add	a4,a5,s0
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x96>
 6b8:	fc040793          	add	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	add	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addw	a4,a4,-1
 6c8:	1702                	sll	a4,a4,0x20
 6ca:	9301                	srl	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f56080e7          	jalr	-170(ra) # 62c <putc>
  while(--i >= 0)
 6de:	197d                	add	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x82>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	add	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf85                	j	668 <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	715d                	add	sp,sp,-80
 6fc:	e486                	sd	ra,72(sp)
 6fe:	e0a2                	sd	s0,64(sp)
 700:	fc26                	sd	s1,56(sp)
 702:	f84a                	sd	s2,48(sp)
 704:	f44e                	sd	s3,40(sp)
 706:	f052                	sd	s4,32(sp)
 708:	ec56                	sd	s5,24(sp)
 70a:	e85a                	sd	s6,16(sp)
 70c:	e45e                	sd	s7,8(sp)
 70e:	e062                	sd	s8,0(sp)
 710:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 712:	0005c903          	lbu	s2,0(a1)
 716:	18090c63          	beqz	s2,8ae <vprintf+0x1b4>
 71a:	8aaa                	mv	s5,a0
 71c:	8bb2                	mv	s7,a2
 71e:	00158493          	add	s1,a1,1
  state = 0;
 722:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 724:	02500a13          	li	s4,37
 728:	4b55                	li	s6,21
 72a:	a839                	j	748 <vprintf+0x4e>
        putc(fd, c);
 72c:	85ca                	mv	a1,s2
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	efc080e7          	jalr	-260(ra) # 62c <putc>
 738:	a019                	j	73e <vprintf+0x44>
    } else if(state == '%'){
 73a:	01498d63          	beq	s3,s4,754 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 73e:	0485                	add	s1,s1,1
 740:	fff4c903          	lbu	s2,-1(s1)
 744:	16090563          	beqz	s2,8ae <vprintf+0x1b4>
    if(state == 0){
 748:	fe0999e3          	bnez	s3,73a <vprintf+0x40>
      if(c == '%'){
 74c:	ff4910e3          	bne	s2,s4,72c <vprintf+0x32>
        state = '%';
 750:	89d2                	mv	s3,s4
 752:	b7f5                	j	73e <vprintf+0x44>
      if(c == 'd'){
 754:	13490263          	beq	s2,s4,878 <vprintf+0x17e>
 758:	f9d9079b          	addw	a5,s2,-99
 75c:	0ff7f793          	zext.b	a5,a5
 760:	12fb6563          	bltu	s6,a5,88a <vprintf+0x190>
 764:	f9d9079b          	addw	a5,s2,-99
 768:	0ff7f713          	zext.b	a4,a5
 76c:	10eb6f63          	bltu	s6,a4,88a <vprintf+0x190>
 770:	00271793          	sll	a5,a4,0x2
 774:	00000717          	auipc	a4,0x0
 778:	49c70713          	add	a4,a4,1180 # c10 <malloc+0x264>
 77c:	97ba                	add	a5,a5,a4
 77e:	439c                	lw	a5,0(a5)
 780:	97ba                	add	a5,a5,a4
 782:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 784:	008b8913          	add	s2,s7,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000ba583          	lw	a1,0(s7)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	ebc080e7          	jalr	-324(ra) # 64e <printint>
 79a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b745                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	008b8913          	add	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	ea0080e7          	jalr	-352(ra) # 64e <printint>
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b751                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7bc:	008b8913          	add	s2,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e84080e7          	jalr	-380(ra) # 64e <printint>
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b7a5                	j	73e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7d8:	008b8c13          	add	s8,s7,8
 7dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e0:	03000593          	li	a1,48
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e46080e7          	jalr	-442(ra) # 62c <putc>
  putc(fd, 'x');
 7ee:	07800593          	li	a1,120
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e38080e7          	jalr	-456(ra) # 62c <putc>
 7fc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fe:	00000b97          	auipc	s7,0x0
 802:	46ab8b93          	add	s7,s7,1130 # c68 <digits>
 806:	03c9d793          	srl	a5,s3,0x3c
 80a:	97de                	add	a5,a5,s7
 80c:	0007c583          	lbu	a1,0(a5)
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	e1a080e7          	jalr	-486(ra) # 62c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81a:	0992                	sll	s3,s3,0x4
 81c:	397d                	addw	s2,s2,-1
 81e:	fe0914e3          	bnez	s2,806 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 822:	8be2                	mv	s7,s8
      state = 0;
 824:	4981                	li	s3,0
 826:	bf21                	j	73e <vprintf+0x44>
        s = va_arg(ap, char*);
 828:	008b8993          	add	s3,s7,8
 82c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 830:	02090163          	beqz	s2,852 <vprintf+0x158>
        while(*s != 0){
 834:	00094583          	lbu	a1,0(s2)
 838:	c9a5                	beqz	a1,8a8 <vprintf+0x1ae>
          putc(fd, *s);
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df0080e7          	jalr	-528(ra) # 62c <putc>
          s++;
 844:	0905                	add	s2,s2,1
        while(*s != 0){
 846:	00094583          	lbu	a1,0(s2)
 84a:	f9e5                	bnez	a1,83a <vprintf+0x140>
        s = va_arg(ap, char*);
 84c:	8bce                	mv	s7,s3
      state = 0;
 84e:	4981                	li	s3,0
 850:	b5fd                	j	73e <vprintf+0x44>
          s = "(null)";
 852:	00000917          	auipc	s2,0x0
 856:	3b690913          	add	s2,s2,950 # c08 <malloc+0x25c>
        while(*s != 0){
 85a:	02800593          	li	a1,40
 85e:	bff1                	j	83a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 860:	008b8913          	add	s2,s7,8
 864:	000bc583          	lbu	a1,0(s7)
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	dc2080e7          	jalr	-574(ra) # 62c <putc>
 872:	8bca                	mv	s7,s2
      state = 0;
 874:	4981                	li	s3,0
 876:	b5e1                	j	73e <vprintf+0x44>
        putc(fd, c);
 878:	02500593          	li	a1,37
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	dae080e7          	jalr	-594(ra) # 62c <putc>
      state = 0;
 886:	4981                	li	s3,0
 888:	bd5d                	j	73e <vprintf+0x44>
        putc(fd, '%');
 88a:	02500593          	li	a1,37
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	d9c080e7          	jalr	-612(ra) # 62c <putc>
        putc(fd, c);
 898:	85ca                	mv	a1,s2
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d90080e7          	jalr	-624(ra) # 62c <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bd61                	j	73e <vprintf+0x44>
        s = va_arg(ap, char*);
 8a8:	8bce                	mv	s7,s3
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd49                	j	73e <vprintf+0x44>
    }
  }
}
 8ae:	60a6                	ld	ra,72(sp)
 8b0:	6406                	ld	s0,64(sp)
 8b2:	74e2                	ld	s1,56(sp)
 8b4:	7942                	ld	s2,48(sp)
 8b6:	79a2                	ld	s3,40(sp)
 8b8:	7a02                	ld	s4,32(sp)
 8ba:	6ae2                	ld	s5,24(sp)
 8bc:	6b42                	ld	s6,16(sp)
 8be:	6ba2                	ld	s7,8(sp)
 8c0:	6c02                	ld	s8,0(sp)
 8c2:	6161                	add	sp,sp,80
 8c4:	8082                	ret

00000000000008c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c6:	715d                	add	sp,sp,-80
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	add	s0,sp,32
 8ce:	e010                	sd	a2,0(s0)
 8d0:	e414                	sd	a3,8(s0)
 8d2:	e818                	sd	a4,16(s0)
 8d4:	ec1c                	sd	a5,24(s0)
 8d6:	03043023          	sd	a6,32(s0)
 8da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e2:	8622                	mv	a2,s0
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e16080e7          	jalr	-490(ra) # 6fa <vprintf>
}
 8ec:	60e2                	ld	ra,24(sp)
 8ee:	6442                	ld	s0,16(sp)
 8f0:	6161                	add	sp,sp,80
 8f2:	8082                	ret

00000000000008f4 <printf>:

void
printf(const char *fmt, ...)
{
 8f4:	711d                	add	sp,sp,-96
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	add	s0,sp,32
 8fc:	e40c                	sd	a1,8(s0)
 8fe:	e810                	sd	a2,16(s0)
 900:	ec14                	sd	a3,24(s0)
 902:	f018                	sd	a4,32(s0)
 904:	f41c                	sd	a5,40(s0)
 906:	03043823          	sd	a6,48(s0)
 90a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90e:	00840613          	add	a2,s0,8
 912:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 916:	85aa                	mv	a1,a0
 918:	4505                	li	a0,1
 91a:	00000097          	auipc	ra,0x0
 91e:	de0080e7          	jalr	-544(ra) # 6fa <vprintf>
}
 922:	60e2                	ld	ra,24(sp)
 924:	6442                	ld	s0,16(sp)
 926:	6125                	add	sp,sp,96
 928:	8082                	ret

000000000000092a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92a:	1141                	add	sp,sp,-16
 92c:	e422                	sd	s0,8(sp)
 92e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 930:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	00000797          	auipc	a5,0x0
 938:	34c7b783          	ld	a5,844(a5) # c80 <freep>
 93c:	a02d                	j	966 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93e:	4618                	lw	a4,8(a2)
 940:	9f2d                	addw	a4,a4,a1
 942:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	6310                	ld	a2,0(a4)
 94a:	a83d                	j	988 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9f31                	addw	a4,a4,a2
 952:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 954:	ff053683          	ld	a3,-16(a0)
 958:	a091                	j	99c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x3a>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x4a>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bgeu	a5,a3,95a <free+0x30>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059813          	sll	a6,a1,0x20
 97e:	01c85713          	srl	a4,a6,0x1c
 982:	9736                	add	a4,a4,a3
 984:	fae60de3          	beq	a2,a4,93e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061593          	sll	a1,a2,0x20
 992:	01c5d713          	srl	a4,a1,0x1c
 996:	973e                	add	a4,a4,a5
 998:	fae68ae3          	beq	a3,a4,94c <free+0x22>
    p->s.ptr = bp->s.ptr;
 99c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	2ef73123          	sd	a5,738(a4) # c80 <freep>
}
 9a6:	6422                	ld	s0,8(sp)
 9a8:	0141                	add	sp,sp,16
 9aa:	8082                	ret

00000000000009ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ac:	7139                	add	sp,sp,-64
 9ae:	fc06                	sd	ra,56(sp)
 9b0:	f822                	sd	s0,48(sp)
 9b2:	f426                	sd	s1,40(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
 9be:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c0:	02051493          	sll	s1,a0,0x20
 9c4:	9081                	srl	s1,s1,0x20
 9c6:	04bd                	add	s1,s1,15
 9c8:	8091                	srl	s1,s1,0x4
 9ca:	0014899b          	addw	s3,s1,1
 9ce:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9d0:	00000517          	auipc	a0,0x0
 9d4:	2b053503          	ld	a0,688(a0) # c80 <freep>
 9d8:	c515                	beqz	a0,a04 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9dc:	4798                	lw	a4,8(a5)
 9de:	02977f63          	bgeu	a4,s1,a1c <malloc+0x70>
  if(nu < 4096)
 9e2:	8a4e                	mv	s4,s3
 9e4:	0009871b          	sext.w	a4,s3
 9e8:	6685                	lui	a3,0x1
 9ea:	00d77363          	bgeu	a4,a3,9f0 <malloc+0x44>
 9ee:	6a05                	lui	s4,0x1
 9f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f8:	00000917          	auipc	s2,0x0
 9fc:	28890913          	add	s2,s2,648 # c80 <freep>
  if(p == (char*)-1)
 a00:	5afd                	li	s5,-1
 a02:	a895                	j	a76 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a04:	00000797          	auipc	a5,0x0
 a08:	28478793          	add	a5,a5,644 # c88 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	26f73a23          	sd	a5,628(a4) # c80 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7e1                	j	9e2 <malloc+0x36>
      if(p->s.size == nunits)
 a1c:	02e48c63          	beq	s1,a4,a54 <malloc+0xa8>
        p->s.size -= nunits;
 a20:	4137073b          	subw	a4,a4,s3
 a24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a26:	02071693          	sll	a3,a4,0x20
 a2a:	01c6d713          	srl	a4,a3,0x1c
 a2e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a30:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a34:	00000717          	auipc	a4,0x0
 a38:	24a73623          	sd	a0,588(a4) # c80 <freep>
      return (void*)(p + 1);
 a3c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a40:	70e2                	ld	ra,56(sp)
 a42:	7442                	ld	s0,48(sp)
 a44:	74a2                	ld	s1,40(sp)
 a46:	7902                	ld	s2,32(sp)
 a48:	69e2                	ld	s3,24(sp)
 a4a:	6a42                	ld	s4,16(sp)
 a4c:	6aa2                	ld	s5,8(sp)
 a4e:	6b02                	ld	s6,0(sp)
 a50:	6121                	add	sp,sp,64
 a52:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	bff1                	j	a34 <malloc+0x88>
  hp->s.size = nu;
 a5a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5e:	0541                	add	a0,a0,16
 a60:	00000097          	auipc	ra,0x0
 a64:	eca080e7          	jalr	-310(ra) # 92a <free>
  return freep;
 a68:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a6c:	d971                	beqz	a0,a40 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a70:	4798                	lw	a4,8(a5)
 a72:	fa9775e3          	bgeu	a4,s1,a1c <malloc+0x70>
    if(p == freep)
 a76:	00093703          	ld	a4,0(s2)
 a7a:	853e                	mv	a0,a5
 a7c:	fef719e3          	bne	a4,a5,a6e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a80:	8552                	mv	a0,s4
 a82:	00000097          	auipc	ra,0x0
 a86:	b92080e7          	jalr	-1134(ra) # 614 <sbrk>
  if(p == (char*)-1)
 a8a:	fd5518e3          	bne	a0,s5,a5a <malloc+0xae>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	bf45                	j	a40 <malloc+0x94>
