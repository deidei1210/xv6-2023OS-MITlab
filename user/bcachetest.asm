
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	add	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	add	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	7da080e7          	jalr	2010(ra) # 802 <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	add	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	79c080e7          	jalr	1948(ra) # 7e2 <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	78c080e7          	jalr	1932(ra) # 7ea <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	add	sp,sp,1072
  82:	8082                	ret
    printf("createfile %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	cca50513          	add	a0,a0,-822 # d50 <statistics+0x88>
  8e:	00001097          	auipc	ra,0x1
  92:	a9c080e7          	jalr	-1380(ra) # b2a <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	72a080e7          	jalr	1834(ra) # 7c2 <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	cc650513          	add	a0,a0,-826 # d68 <statistics+0xa0>
  aa:	00001097          	auipc	ra,0x1
  ae:	a80080e7          	jalr	-1408(ra) # b2a <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	70e080e7          	jalr	1806(ra) # 7c2 <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	add	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	add	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	712080e7          	jalr	1810(ra) # 802 <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	add	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	6ce080e7          	jalr	1742(ra) # 7da <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	6c8080e7          	jalr	1736(ra) # 7ea <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	add	sp,sp,1088
 14a:	8082                	ret
    printf("readfile: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c3450513          	add	a0,a0,-972 # d80 <statistics+0xb8>
 154:	00001097          	auipc	ra,0x1
 158:	9d6080e7          	jalr	-1578(ra) # b2a <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	664080e7          	jalr	1636(ra) # 7c2 <exit>
    printf("readfile open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	c3850513          	add	a0,a0,-968 # da0 <statistics+0xd8>
 170:	00001097          	auipc	ra,0x1
 174:	9ba080e7          	jalr	-1606(ra) # b2a <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	648080e7          	jalr	1608(ra) # 7c2 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	c3850513          	add	a0,a0,-968 # dc0 <statistics+0xf8>
 190:	00001097          	auipc	ra,0x1
 194:	99a080e7          	jalr	-1638(ra) # b2a <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	628080e7          	jalr	1576(ra) # 7c2 <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
 1a2:	1101                	add	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	add	s0,sp,32
 1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
 1b0:	6585                	lui	a1,0x1
 1b2:	00001517          	auipc	a0,0x1
 1b6:	d7e50513          	add	a0,a0,-642 # f30 <buf>
 1ba:	00001097          	auipc	ra,0x1
 1be:	b0e080e7          	jalr	-1266(ra) # cc8 <statistics>
 1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
 1c6:	03d00593          	li	a1,61
 1ca:	00001517          	auipc	a0,0x1
 1ce:	d6650513          	add	a0,a0,-666 # f30 <buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	418080e7          	jalr	1048(ra) # 5ea <strchr>
  n = atoi(c+2);
 1da:	0509                	add	a0,a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	4ec080e7          	jalr	1260(ra) # 6c8 <atoi>
 1e4:	84aa                	mv	s1,a0
  if(print)
 1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
 1ea:	8526                	mv	a0,s1
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	add	sp,sp,32
 1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
 1f8:	00001597          	auipc	a1,0x1
 1fc:	bf058593          	add	a1,a1,-1040 # de8 <statistics+0x120>
 200:	4509                	li	a0,2
 202:	00001097          	auipc	ra,0x1
 206:	8fa080e7          	jalr	-1798(ra) # afc <fprintf>
 20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
 20c:	00001597          	auipc	a1,0x1
 210:	d2458593          	add	a1,a1,-732 # f30 <buf>
 214:	00001517          	auipc	a0,0x1
 218:	be450513          	add	a0,a0,-1052 # df8 <statistics+0x130>
 21c:	00001097          	auipc	ra,0x1
 220:	90e080e7          	jalr	-1778(ra) # b2a <printf>
 224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

void
test0()
{
 226:	7139                	add	sp,sp,-64
 228:	fc06                	sd	ra,56(sp)
 22a:	f822                	sd	s0,48(sp)
 22c:	f426                	sd	s1,40(sp)
 22e:	f04a                	sd	s2,32(sp)
 230:	ec4e                	sd	s3,24(sp)
 232:	0080                	add	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int m, n;

  dir[0] = '0';
 234:	03000793          	li	a5,48
 238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 240:	04600793          	li	a5,70
 244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 24c:	00001517          	auipc	a0,0x1
 250:	bb450513          	add	a0,a0,-1100 # e00 <statistics+0x138>
 254:	00001097          	auipc	ra,0x1
 258:	8d6080e7          	jalr	-1834(ra) # b2a <printf>
 25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 260:	00001997          	auipc	s3,0x1
 264:	bc098993          	add	s3,s3,-1088 # e20 <statistics+0x158>
  for(int i = 0; i < NCHILD; i++){
 268:	03300913          	li	s2,51
    dir[0] = '0' + i;
 26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 270:	fc040513          	add	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	5b6080e7          	jalr	1462(ra) # 82a <mkdir>
    if (chdir(dir) < 0) {
 27c:	fc040513          	add	a0,s0,-64
 280:	00000097          	auipc	ra,0x0
 284:	5b2080e7          	jalr	1458(ra) # 832 <chdir>
 288:	0c054463          	bltz	a0,350 <test0+0x12a>
    unlink(file);
 28c:	fc840513          	add	a0,s0,-56
 290:	00000097          	auipc	ra,0x0
 294:	582080e7          	jalr	1410(ra) # 812 <unlink>
    createfile(file, N);
 298:	45a9                	li	a1,10
 29a:	fc840513          	add	a0,s0,-56
 29e:	00000097          	auipc	ra,0x0
 2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 2a6:	854e                	mv	a0,s3
 2a8:	00000097          	auipc	ra,0x0
 2ac:	58a080e7          	jalr	1418(ra) # 832 <chdir>
 2b0:	0a054d63          	bltz	a0,36a <test0+0x144>
  for(int i = 0; i < NCHILD; i++){
 2b4:	2485                	addw	s1,s1,1
 2b6:	0ff4f493          	zext.b	s1,s1
 2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
 2c8:	892a                	mv	s2,a0
 2ca:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 2ce:	03300993          	li	s3,51
    dir[0] = '0' + i;
 2d2:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 2d6:	00000097          	auipc	ra,0x0
 2da:	4e4080e7          	jalr	1252(ra) # 7ba <fork>
    if(pid < 0){
 2de:	0a054363          	bltz	a0,384 <test0+0x15e>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2e2:	cd55                	beqz	a0,39e <test0+0x178>
  for(int i = 0; i < NCHILD; i++){
 2e4:	2485                	addw	s1,s1,1
 2e6:	0ff4f493          	zext.b	s1,s1
 2ea:	ff3494e3          	bne	s1,s3,2d2 <test0+0xac>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	4da080e7          	jalr	1242(ra) # 7ca <wait>
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	4d0080e7          	jalr	1232(ra) # 7ca <wait>
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	4c6080e7          	jalr	1222(ra) # 7ca <wait>
  }
  printf("test0 results:\n");
 30c:	00001517          	auipc	a0,0x1
 310:	b2c50513          	add	a0,a0,-1236 # e38 <statistics+0x170>
 314:	00001097          	auipc	ra,0x1
 318:	816080e7          	jalr	-2026(ra) # b2a <printf>
  n = ntas(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	e84080e7          	jalr	-380(ra) # 1a2 <ntas>
  if (n-m < 500)
 326:	4125053b          	subw	a0,a0,s2
 32a:	1f300793          	li	a5,499
 32e:	0aa7cc63          	blt	a5,a0,3e6 <test0+0x1c0>
    printf("test0: OK\n");
 332:	00001517          	auipc	a0,0x1
 336:	b1650513          	add	a0,a0,-1258 # e48 <statistics+0x180>
 33a:	00000097          	auipc	ra,0x0
 33e:	7f0080e7          	jalr	2032(ra) # b2a <printf>
  else
    printf("test0: FAIL\n");
}
 342:	70e2                	ld	ra,56(sp)
 344:	7442                	ld	s0,48(sp)
 346:	74a2                	ld	s1,40(sp)
 348:	7902                	ld	s2,32(sp)
 34a:	69e2                	ld	s3,24(sp)
 34c:	6121                	add	sp,sp,64
 34e:	8082                	ret
      printf("chdir failed\n");
 350:	00001517          	auipc	a0,0x1
 354:	ac050513          	add	a0,a0,-1344 # e10 <statistics+0x148>
 358:	00000097          	auipc	ra,0x0
 35c:	7d2080e7          	jalr	2002(ra) # b2a <printf>
      exit(1);
 360:	4505                	li	a0,1
 362:	00000097          	auipc	ra,0x0
 366:	460080e7          	jalr	1120(ra) # 7c2 <exit>
      printf("chdir failed\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	aa650513          	add	a0,a0,-1370 # e10 <statistics+0x148>
 372:	00000097          	auipc	ra,0x0
 376:	7b8080e7          	jalr	1976(ra) # b2a <printf>
      exit(1);
 37a:	4505                	li	a0,1
 37c:	00000097          	auipc	ra,0x0
 380:	446080e7          	jalr	1094(ra) # 7c2 <exit>
      printf("fork failed");
 384:	00001517          	auipc	a0,0x1
 388:	aa450513          	add	a0,a0,-1372 # e28 <statistics+0x160>
 38c:	00000097          	auipc	ra,0x0
 390:	79e080e7          	jalr	1950(ra) # b2a <printf>
      exit(-1);
 394:	557d                	li	a0,-1
 396:	00000097          	auipc	ra,0x0
 39a:	42c080e7          	jalr	1068(ra) # 7c2 <exit>
      if (chdir(dir) < 0) {
 39e:	fc040513          	add	a0,s0,-64
 3a2:	00000097          	auipc	ra,0x0
 3a6:	490080e7          	jalr	1168(ra) # 832 <chdir>
 3aa:	02054163          	bltz	a0,3cc <test0+0x1a6>
      readfile(file, N*BSIZE, 1);
 3ae:	4605                	li	a2,1
 3b0:	658d                	lui	a1,0x3
 3b2:	80058593          	add	a1,a1,-2048 # 2800 <__BSS_END__+0x8c0>
 3b6:	fc840513          	add	a0,s0,-56
 3ba:	00000097          	auipc	ra,0x0
 3be:	d02080e7          	jalr	-766(ra) # bc <readfile>
      exit(0);
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	3fe080e7          	jalr	1022(ra) # 7c2 <exit>
        printf("chdir failed\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	a4450513          	add	a0,a0,-1468 # e10 <statistics+0x148>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	756080e7          	jalr	1878(ra) # b2a <printf>
        exit(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	3e4080e7          	jalr	996(ra) # 7c2 <exit>
    printf("test0: FAIL\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a7250513          	add	a0,a0,-1422 # e58 <statistics+0x190>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	73c080e7          	jalr	1852(ra) # b2a <printf>
}
 3f6:	b7b1                	j	342 <test0+0x11c>

00000000000003f8 <test1>:

void test1()
{
 3f8:	7179                	add	sp,sp,-48
 3fa:	f406                	sd	ra,40(sp)
 3fc:	f022                	sd	s0,32(sp)
 3fe:	ec26                	sd	s1,24(sp)
 400:	1800                	add	s0,sp,48
  char file[3];
  enum { N = 100, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 402:	00001517          	auipc	a0,0x1
 406:	a6650513          	add	a0,a0,-1434 # e68 <statistics+0x1a0>
 40a:	00000097          	auipc	ra,0x0
 40e:	720080e7          	jalr	1824(ra) # b2a <printf>
  file[0] = 'B';
 412:	04200793          	li	a5,66
 416:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 41a:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 41e:	03000493          	li	s1,48
 422:	fc940ca3          	sb	s1,-39(s0)
    unlink(file);
 426:	fd840513          	add	a0,s0,-40
 42a:	00000097          	auipc	ra,0x0
 42e:	3e8080e7          	jalr	1000(ra) # 812 <unlink>
    if (i == 0) {
      createfile(file, BIG);
 432:	06400593          	li	a1,100
 436:	fd840513          	add	a0,s0,-40
 43a:	00000097          	auipc	ra,0x0
 43e:	bc6080e7          	jalr	-1082(ra) # 0 <createfile>
    file[1] = '0' + i;
 442:	03100793          	li	a5,49
 446:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 44a:	fd840513          	add	a0,s0,-40
 44e:	00000097          	auipc	ra,0x0
 452:	3c4080e7          	jalr	964(ra) # 812 <unlink>
    } else {
      createfile(file, 1);
 456:	4585                	li	a1,1
 458:	fd840513          	add	a0,s0,-40
 45c:	00000097          	auipc	ra,0x0
 460:	ba4080e7          	jalr	-1116(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 464:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 468:	00000097          	auipc	ra,0x0
 46c:	352080e7          	jalr	850(ra) # 7ba <fork>
    if(pid < 0){
 470:	04054563          	bltz	a0,4ba <test1+0xc2>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 474:	c125                	beqz	a0,4d4 <test1+0xdc>
    file[1] = '0' + i;
 476:	03100793          	li	a5,49
 47a:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 47e:	00000097          	auipc	ra,0x0
 482:	33c080e7          	jalr	828(ra) # 7ba <fork>
    if(pid < 0){
 486:	02054a63          	bltz	a0,4ba <test1+0xc2>
    if(pid == 0){
 48a:	cd2d                	beqz	a0,504 <test1+0x10c>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 48c:	4501                	li	a0,0
 48e:	00000097          	auipc	ra,0x0
 492:	33c080e7          	jalr	828(ra) # 7ca <wait>
 496:	4501                	li	a0,0
 498:	00000097          	auipc	ra,0x0
 49c:	332080e7          	jalr	818(ra) # 7ca <wait>
  }
  printf("test1 OK\n");
 4a0:	00001517          	auipc	a0,0x1
 4a4:	9d850513          	add	a0,a0,-1576 # e78 <statistics+0x1b0>
 4a8:	00000097          	auipc	ra,0x0
 4ac:	682080e7          	jalr	1666(ra) # b2a <printf>
}
 4b0:	70a2                	ld	ra,40(sp)
 4b2:	7402                	ld	s0,32(sp)
 4b4:	64e2                	ld	s1,24(sp)
 4b6:	6145                	add	sp,sp,48
 4b8:	8082                	ret
      printf("fork failed");
 4ba:	00001517          	auipc	a0,0x1
 4be:	96e50513          	add	a0,a0,-1682 # e28 <statistics+0x160>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	668080e7          	jalr	1640(ra) # b2a <printf>
      exit(-1);
 4ca:	557d                	li	a0,-1
 4cc:	00000097          	auipc	ra,0x0
 4d0:	2f6080e7          	jalr	758(ra) # 7c2 <exit>
    if(pid == 0){
 4d4:	06400493          	li	s1,100
          readfile(file, BIG*BSIZE, BSIZE);
 4d8:	40000613          	li	a2,1024
 4dc:	65e5                	lui	a1,0x19
 4de:	fd840513          	add	a0,s0,-40
 4e2:	00000097          	auipc	ra,0x0
 4e6:	bda080e7          	jalr	-1062(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 4ea:	34fd                	addw	s1,s1,-1
 4ec:	f4f5                	bnez	s1,4d8 <test1+0xe0>
        unlink(file);
 4ee:	fd840513          	add	a0,s0,-40
 4f2:	00000097          	auipc	ra,0x0
 4f6:	320080e7          	jalr	800(ra) # 812 <unlink>
        exit(0);
 4fa:	4501                	li	a0,0
 4fc:	00000097          	auipc	ra,0x0
 500:	2c6080e7          	jalr	710(ra) # 7c2 <exit>
 504:	06400493          	li	s1,100
          readfile(file, 1, BSIZE);
 508:	40000613          	li	a2,1024
 50c:	4585                	li	a1,1
 50e:	fd840513          	add	a0,s0,-40
 512:	00000097          	auipc	ra,0x0
 516:	baa080e7          	jalr	-1110(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 51a:	34fd                	addw	s1,s1,-1
 51c:	f4f5                	bnez	s1,508 <test1+0x110>
        unlink(file);
 51e:	fd840513          	add	a0,s0,-40
 522:	00000097          	auipc	ra,0x0
 526:	2f0080e7          	jalr	752(ra) # 812 <unlink>
      exit(0);
 52a:	4501                	li	a0,0
 52c:	00000097          	auipc	ra,0x0
 530:	296080e7          	jalr	662(ra) # 7c2 <exit>

0000000000000534 <main>:
{
 534:	1141                	add	sp,sp,-16
 536:	e406                	sd	ra,8(sp)
 538:	e022                	sd	s0,0(sp)
 53a:	0800                	add	s0,sp,16
  test0();
 53c:	00000097          	auipc	ra,0x0
 540:	cea080e7          	jalr	-790(ra) # 226 <test0>
  test1();
 544:	00000097          	auipc	ra,0x0
 548:	eb4080e7          	jalr	-332(ra) # 3f8 <test1>
  exit(0);
 54c:	4501                	li	a0,0
 54e:	00000097          	auipc	ra,0x0
 552:	274080e7          	jalr	628(ra) # 7c2 <exit>

0000000000000556 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 556:	1141                	add	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 55c:	87aa                	mv	a5,a0
 55e:	0585                	add	a1,a1,1 # 19001 <__BSS_END__+0x170c1>
 560:	0785                	add	a5,a5,1
 562:	fff5c703          	lbu	a4,-1(a1)
 566:	fee78fa3          	sb	a4,-1(a5)
 56a:	fb75                	bnez	a4,55e <strcpy+0x8>
    ;
  return os;
}
 56c:	6422                	ld	s0,8(sp)
 56e:	0141                	add	sp,sp,16
 570:	8082                	ret

0000000000000572 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 572:	1141                	add	sp,sp,-16
 574:	e422                	sd	s0,8(sp)
 576:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 578:	00054783          	lbu	a5,0(a0)
 57c:	cb91                	beqz	a5,590 <strcmp+0x1e>
 57e:	0005c703          	lbu	a4,0(a1)
 582:	00f71763          	bne	a4,a5,590 <strcmp+0x1e>
    p++, q++;
 586:	0505                	add	a0,a0,1
 588:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 58a:	00054783          	lbu	a5,0(a0)
 58e:	fbe5                	bnez	a5,57e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 590:	0005c503          	lbu	a0,0(a1)
}
 594:	40a7853b          	subw	a0,a5,a0
 598:	6422                	ld	s0,8(sp)
 59a:	0141                	add	sp,sp,16
 59c:	8082                	ret

000000000000059e <strlen>:

uint
strlen(const char *s)
{
 59e:	1141                	add	sp,sp,-16
 5a0:	e422                	sd	s0,8(sp)
 5a2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5a4:	00054783          	lbu	a5,0(a0)
 5a8:	cf91                	beqz	a5,5c4 <strlen+0x26>
 5aa:	0505                	add	a0,a0,1
 5ac:	87aa                	mv	a5,a0
 5ae:	86be                	mv	a3,a5
 5b0:	0785                	add	a5,a5,1
 5b2:	fff7c703          	lbu	a4,-1(a5)
 5b6:	ff65                	bnez	a4,5ae <strlen+0x10>
 5b8:	40a6853b          	subw	a0,a3,a0
 5bc:	2505                	addw	a0,a0,1
    ;
  return n;
}
 5be:	6422                	ld	s0,8(sp)
 5c0:	0141                	add	sp,sp,16
 5c2:	8082                	ret
  for(n = 0; s[n]; n++)
 5c4:	4501                	li	a0,0
 5c6:	bfe5                	j	5be <strlen+0x20>

00000000000005c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c8:	1141                	add	sp,sp,-16
 5ca:	e422                	sd	s0,8(sp)
 5cc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5ce:	ca19                	beqz	a2,5e4 <memset+0x1c>
 5d0:	87aa                	mv	a5,a0
 5d2:	1602                	sll	a2,a2,0x20
 5d4:	9201                	srl	a2,a2,0x20
 5d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5de:	0785                	add	a5,a5,1
 5e0:	fee79de3          	bne	a5,a4,5da <memset+0x12>
  }
  return dst;
}
 5e4:	6422                	ld	s0,8(sp)
 5e6:	0141                	add	sp,sp,16
 5e8:	8082                	ret

00000000000005ea <strchr>:

char*
strchr(const char *s, char c)
{
 5ea:	1141                	add	sp,sp,-16
 5ec:	e422                	sd	s0,8(sp)
 5ee:	0800                	add	s0,sp,16
  for(; *s; s++)
 5f0:	00054783          	lbu	a5,0(a0)
 5f4:	cb99                	beqz	a5,60a <strchr+0x20>
    if(*s == c)
 5f6:	00f58763          	beq	a1,a5,604 <strchr+0x1a>
  for(; *s; s++)
 5fa:	0505                	add	a0,a0,1
 5fc:	00054783          	lbu	a5,0(a0)
 600:	fbfd                	bnez	a5,5f6 <strchr+0xc>
      return (char*)s;
  return 0;
 602:	4501                	li	a0,0
}
 604:	6422                	ld	s0,8(sp)
 606:	0141                	add	sp,sp,16
 608:	8082                	ret
  return 0;
 60a:	4501                	li	a0,0
 60c:	bfe5                	j	604 <strchr+0x1a>

000000000000060e <gets>:

char*
gets(char *buf, int max)
{
 60e:	711d                	add	sp,sp,-96
 610:	ec86                	sd	ra,88(sp)
 612:	e8a2                	sd	s0,80(sp)
 614:	e4a6                	sd	s1,72(sp)
 616:	e0ca                	sd	s2,64(sp)
 618:	fc4e                	sd	s3,56(sp)
 61a:	f852                	sd	s4,48(sp)
 61c:	f456                	sd	s5,40(sp)
 61e:	f05a                	sd	s6,32(sp)
 620:	ec5e                	sd	s7,24(sp)
 622:	1080                	add	s0,sp,96
 624:	8baa                	mv	s7,a0
 626:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 628:	892a                	mv	s2,a0
 62a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 62c:	4aa9                	li	s5,10
 62e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 630:	89a6                	mv	s3,s1
 632:	2485                	addw	s1,s1,1
 634:	0344d863          	bge	s1,s4,664 <gets+0x56>
    cc = read(0, &c, 1);
 638:	4605                	li	a2,1
 63a:	faf40593          	add	a1,s0,-81
 63e:	4501                	li	a0,0
 640:	00000097          	auipc	ra,0x0
 644:	19a080e7          	jalr	410(ra) # 7da <read>
    if(cc < 1)
 648:	00a05e63          	blez	a0,664 <gets+0x56>
    buf[i++] = c;
 64c:	faf44783          	lbu	a5,-81(s0)
 650:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 654:	01578763          	beq	a5,s5,662 <gets+0x54>
 658:	0905                	add	s2,s2,1
 65a:	fd679be3          	bne	a5,s6,630 <gets+0x22>
  for(i=0; i+1 < max; ){
 65e:	89a6                	mv	s3,s1
 660:	a011                	j	664 <gets+0x56>
 662:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 664:	99de                	add	s3,s3,s7
 666:	00098023          	sb	zero,0(s3)
  return buf;
}
 66a:	855e                	mv	a0,s7
 66c:	60e6                	ld	ra,88(sp)
 66e:	6446                	ld	s0,80(sp)
 670:	64a6                	ld	s1,72(sp)
 672:	6906                	ld	s2,64(sp)
 674:	79e2                	ld	s3,56(sp)
 676:	7a42                	ld	s4,48(sp)
 678:	7aa2                	ld	s5,40(sp)
 67a:	7b02                	ld	s6,32(sp)
 67c:	6be2                	ld	s7,24(sp)
 67e:	6125                	add	sp,sp,96
 680:	8082                	ret

0000000000000682 <stat>:

int
stat(const char *n, struct stat *st)
{
 682:	1101                	add	sp,sp,-32
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	e426                	sd	s1,8(sp)
 68a:	e04a                	sd	s2,0(sp)
 68c:	1000                	add	s0,sp,32
 68e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 690:	4581                	li	a1,0
 692:	00000097          	auipc	ra,0x0
 696:	170080e7          	jalr	368(ra) # 802 <open>
  if(fd < 0)
 69a:	02054563          	bltz	a0,6c4 <stat+0x42>
 69e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6a0:	85ca                	mv	a1,s2
 6a2:	00000097          	auipc	ra,0x0
 6a6:	178080e7          	jalr	376(ra) # 81a <fstat>
 6aa:	892a                	mv	s2,a0
  close(fd);
 6ac:	8526                	mv	a0,s1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	13c080e7          	jalr	316(ra) # 7ea <close>
  return r;
}
 6b6:	854a                	mv	a0,s2
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	64a2                	ld	s1,8(sp)
 6be:	6902                	ld	s2,0(sp)
 6c0:	6105                	add	sp,sp,32
 6c2:	8082                	ret
    return -1;
 6c4:	597d                	li	s2,-1
 6c6:	bfc5                	j	6b6 <stat+0x34>

00000000000006c8 <atoi>:

int
atoi(const char *s)
{
 6c8:	1141                	add	sp,sp,-16
 6ca:	e422                	sd	s0,8(sp)
 6cc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6ce:	00054683          	lbu	a3,0(a0)
 6d2:	fd06879b          	addw	a5,a3,-48
 6d6:	0ff7f793          	zext.b	a5,a5
 6da:	4625                	li	a2,9
 6dc:	02f66863          	bltu	a2,a5,70c <atoi+0x44>
 6e0:	872a                	mv	a4,a0
  n = 0;
 6e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6e4:	0705                	add	a4,a4,1
 6e6:	0025179b          	sllw	a5,a0,0x2
 6ea:	9fa9                	addw	a5,a5,a0
 6ec:	0017979b          	sllw	a5,a5,0x1
 6f0:	9fb5                	addw	a5,a5,a3
 6f2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6f6:	00074683          	lbu	a3,0(a4)
 6fa:	fd06879b          	addw	a5,a3,-48
 6fe:	0ff7f793          	zext.b	a5,a5
 702:	fef671e3          	bgeu	a2,a5,6e4 <atoi+0x1c>
  return n;
}
 706:	6422                	ld	s0,8(sp)
 708:	0141                	add	sp,sp,16
 70a:	8082                	ret
  n = 0;
 70c:	4501                	li	a0,0
 70e:	bfe5                	j	706 <atoi+0x3e>

0000000000000710 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 710:	1141                	add	sp,sp,-16
 712:	e422                	sd	s0,8(sp)
 714:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 716:	02b57463          	bgeu	a0,a1,73e <memmove+0x2e>
    while(n-- > 0)
 71a:	00c05f63          	blez	a2,738 <memmove+0x28>
 71e:	1602                	sll	a2,a2,0x20
 720:	9201                	srl	a2,a2,0x20
 722:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 726:	872a                	mv	a4,a0
      *dst++ = *src++;
 728:	0585                	add	a1,a1,1
 72a:	0705                	add	a4,a4,1
 72c:	fff5c683          	lbu	a3,-1(a1)
 730:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 734:	fee79ae3          	bne	a5,a4,728 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 738:	6422                	ld	s0,8(sp)
 73a:	0141                	add	sp,sp,16
 73c:	8082                	ret
    dst += n;
 73e:	00c50733          	add	a4,a0,a2
    src += n;
 742:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 744:	fec05ae3          	blez	a2,738 <memmove+0x28>
 748:	fff6079b          	addw	a5,a2,-1
 74c:	1782                	sll	a5,a5,0x20
 74e:	9381                	srl	a5,a5,0x20
 750:	fff7c793          	not	a5,a5
 754:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 756:	15fd                	add	a1,a1,-1
 758:	177d                	add	a4,a4,-1
 75a:	0005c683          	lbu	a3,0(a1)
 75e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 762:	fee79ae3          	bne	a5,a4,756 <memmove+0x46>
 766:	bfc9                	j	738 <memmove+0x28>

0000000000000768 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 768:	1141                	add	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 76e:	ca05                	beqz	a2,79e <memcmp+0x36>
 770:	fff6069b          	addw	a3,a2,-1
 774:	1682                	sll	a3,a3,0x20
 776:	9281                	srl	a3,a3,0x20
 778:	0685                	add	a3,a3,1
 77a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 77c:	00054783          	lbu	a5,0(a0)
 780:	0005c703          	lbu	a4,0(a1)
 784:	00e79863          	bne	a5,a4,794 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 788:	0505                	add	a0,a0,1
    p2++;
 78a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 78c:	fed518e3          	bne	a0,a3,77c <memcmp+0x14>
  }
  return 0;
 790:	4501                	li	a0,0
 792:	a019                	j	798 <memcmp+0x30>
      return *p1 - *p2;
 794:	40e7853b          	subw	a0,a5,a4
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	add	sp,sp,16
 79c:	8082                	ret
  return 0;
 79e:	4501                	li	a0,0
 7a0:	bfe5                	j	798 <memcmp+0x30>

00000000000007a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7a2:	1141                	add	sp,sp,-16
 7a4:	e406                	sd	ra,8(sp)
 7a6:	e022                	sd	s0,0(sp)
 7a8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 7aa:	00000097          	auipc	ra,0x0
 7ae:	f66080e7          	jalr	-154(ra) # 710 <memmove>
}
 7b2:	60a2                	ld	ra,8(sp)
 7b4:	6402                	ld	s0,0(sp)
 7b6:	0141                	add	sp,sp,16
 7b8:	8082                	ret

00000000000007ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7ba:	4885                	li	a7,1
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7c2:	4889                	li	a7,2
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 7ca:	488d                	li	a7,3
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7d2:	4891                	li	a7,4
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <read>:
.global read
read:
 li a7, SYS_read
 7da:	4895                	li	a7,5
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <write>:
.global write
write:
 li a7, SYS_write
 7e2:	48c1                	li	a7,16
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <close>:
.global close
close:
 li a7, SYS_close
 7ea:	48d5                	li	a7,21
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7f2:	4899                	li	a7,6
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 7fa:	489d                	li	a7,7
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <open>:
.global open
open:
 li a7, SYS_open
 802:	48bd                	li	a7,15
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 80a:	48c5                	li	a7,17
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 812:	48c9                	li	a7,18
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 81a:	48a1                	li	a7,8
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <link>:
.global link
link:
 li a7, SYS_link
 822:	48cd                	li	a7,19
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 82a:	48d1                	li	a7,20
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 832:	48a5                	li	a7,9
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <dup>:
.global dup
dup:
 li a7, SYS_dup
 83a:	48a9                	li	a7,10
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 842:	48ad                	li	a7,11
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 84a:	48b1                	li	a7,12
 ecall
 84c:	00000073          	ecall
 ret
 850:	8082                	ret

0000000000000852 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 852:	48b5                	li	a7,13
 ecall
 854:	00000073          	ecall
 ret
 858:	8082                	ret

000000000000085a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 85a:	48b9                	li	a7,14
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 862:	1101                	add	sp,sp,-32
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	add	s0,sp,32
 86a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 86e:	4605                	li	a2,1
 870:	fef40593          	add	a1,s0,-17
 874:	00000097          	auipc	ra,0x0
 878:	f6e080e7          	jalr	-146(ra) # 7e2 <write>
}
 87c:	60e2                	ld	ra,24(sp)
 87e:	6442                	ld	s0,16(sp)
 880:	6105                	add	sp,sp,32
 882:	8082                	ret

0000000000000884 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 884:	7139                	add	sp,sp,-64
 886:	fc06                	sd	ra,56(sp)
 888:	f822                	sd	s0,48(sp)
 88a:	f426                	sd	s1,40(sp)
 88c:	f04a                	sd	s2,32(sp)
 88e:	ec4e                	sd	s3,24(sp)
 890:	0080                	add	s0,sp,64
 892:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 894:	c299                	beqz	a3,89a <printint+0x16>
 896:	0805c963          	bltz	a1,928 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 89a:	2581                	sext.w	a1,a1
  neg = 0;
 89c:	4881                	li	a7,0
 89e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8a4:	2601                	sext.w	a2,a2
 8a6:	00000517          	auipc	a0,0x0
 8aa:	64250513          	add	a0,a0,1602 # ee8 <digits>
 8ae:	883a                	mv	a6,a4
 8b0:	2705                	addw	a4,a4,1
 8b2:	02c5f7bb          	remuw	a5,a1,a2
 8b6:	1782                	sll	a5,a5,0x20
 8b8:	9381                	srl	a5,a5,0x20
 8ba:	97aa                	add	a5,a5,a0
 8bc:	0007c783          	lbu	a5,0(a5)
 8c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8c4:	0005879b          	sext.w	a5,a1
 8c8:	02c5d5bb          	divuw	a1,a1,a2
 8cc:	0685                	add	a3,a3,1
 8ce:	fec7f0e3          	bgeu	a5,a2,8ae <printint+0x2a>
  if(neg)
 8d2:	00088c63          	beqz	a7,8ea <printint+0x66>
    buf[i++] = '-';
 8d6:	fd070793          	add	a5,a4,-48
 8da:	00878733          	add	a4,a5,s0
 8de:	02d00793          	li	a5,45
 8e2:	fef70823          	sb	a5,-16(a4)
 8e6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8ea:	02e05863          	blez	a4,91a <printint+0x96>
 8ee:	fc040793          	add	a5,s0,-64
 8f2:	00e78933          	add	s2,a5,a4
 8f6:	fff78993          	add	s3,a5,-1
 8fa:	99ba                	add	s3,s3,a4
 8fc:	377d                	addw	a4,a4,-1
 8fe:	1702                	sll	a4,a4,0x20
 900:	9301                	srl	a4,a4,0x20
 902:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 906:	fff94583          	lbu	a1,-1(s2)
 90a:	8526                	mv	a0,s1
 90c:	00000097          	auipc	ra,0x0
 910:	f56080e7          	jalr	-170(ra) # 862 <putc>
  while(--i >= 0)
 914:	197d                	add	s2,s2,-1
 916:	ff3918e3          	bne	s2,s3,906 <printint+0x82>
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	74a2                	ld	s1,40(sp)
 920:	7902                	ld	s2,32(sp)
 922:	69e2                	ld	s3,24(sp)
 924:	6121                	add	sp,sp,64
 926:	8082                	ret
    x = -xx;
 928:	40b005bb          	negw	a1,a1
    neg = 1;
 92c:	4885                	li	a7,1
    x = -xx;
 92e:	bf85                	j	89e <printint+0x1a>

0000000000000930 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 930:	715d                	add	sp,sp,-80
 932:	e486                	sd	ra,72(sp)
 934:	e0a2                	sd	s0,64(sp)
 936:	fc26                	sd	s1,56(sp)
 938:	f84a                	sd	s2,48(sp)
 93a:	f44e                	sd	s3,40(sp)
 93c:	f052                	sd	s4,32(sp)
 93e:	ec56                	sd	s5,24(sp)
 940:	e85a                	sd	s6,16(sp)
 942:	e45e                	sd	s7,8(sp)
 944:	e062                	sd	s8,0(sp)
 946:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 948:	0005c903          	lbu	s2,0(a1)
 94c:	18090c63          	beqz	s2,ae4 <vprintf+0x1b4>
 950:	8aaa                	mv	s5,a0
 952:	8bb2                	mv	s7,a2
 954:	00158493          	add	s1,a1,1
  state = 0;
 958:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 95a:	02500a13          	li	s4,37
 95e:	4b55                	li	s6,21
 960:	a839                	j	97e <vprintf+0x4e>
        putc(fd, c);
 962:	85ca                	mv	a1,s2
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	efc080e7          	jalr	-260(ra) # 862 <putc>
 96e:	a019                	j	974 <vprintf+0x44>
    } else if(state == '%'){
 970:	01498d63          	beq	s3,s4,98a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 974:	0485                	add	s1,s1,1
 976:	fff4c903          	lbu	s2,-1(s1)
 97a:	16090563          	beqz	s2,ae4 <vprintf+0x1b4>
    if(state == 0){
 97e:	fe0999e3          	bnez	s3,970 <vprintf+0x40>
      if(c == '%'){
 982:	ff4910e3          	bne	s2,s4,962 <vprintf+0x32>
        state = '%';
 986:	89d2                	mv	s3,s4
 988:	b7f5                	j	974 <vprintf+0x44>
      if(c == 'd'){
 98a:	13490263          	beq	s2,s4,aae <vprintf+0x17e>
 98e:	f9d9079b          	addw	a5,s2,-99
 992:	0ff7f793          	zext.b	a5,a5
 996:	12fb6563          	bltu	s6,a5,ac0 <vprintf+0x190>
 99a:	f9d9079b          	addw	a5,s2,-99
 99e:	0ff7f713          	zext.b	a4,a5
 9a2:	10eb6f63          	bltu	s6,a4,ac0 <vprintf+0x190>
 9a6:	00271793          	sll	a5,a4,0x2
 9aa:	00000717          	auipc	a4,0x0
 9ae:	4e670713          	add	a4,a4,1254 # e90 <statistics+0x1c8>
 9b2:	97ba                	add	a5,a5,a4
 9b4:	439c                	lw	a5,0(a5)
 9b6:	97ba                	add	a5,a5,a4
 9b8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 9ba:	008b8913          	add	s2,s7,8
 9be:	4685                	li	a3,1
 9c0:	4629                	li	a2,10
 9c2:	000ba583          	lw	a1,0(s7)
 9c6:	8556                	mv	a0,s5
 9c8:	00000097          	auipc	ra,0x0
 9cc:	ebc080e7          	jalr	-324(ra) # 884 <printint>
 9d0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	b745                	j	974 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9d6:	008b8913          	add	s2,s7,8
 9da:	4681                	li	a3,0
 9dc:	4629                	li	a2,10
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	ea0080e7          	jalr	-352(ra) # 884 <printint>
 9ec:	8bca                	mv	s7,s2
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	b751                	j	974 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 9f2:	008b8913          	add	s2,s7,8
 9f6:	4681                	li	a3,0
 9f8:	4641                	li	a2,16
 9fa:	000ba583          	lw	a1,0(s7)
 9fe:	8556                	mv	a0,s5
 a00:	00000097          	auipc	ra,0x0
 a04:	e84080e7          	jalr	-380(ra) # 884 <printint>
 a08:	8bca                	mv	s7,s2
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b7a5                	j	974 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 a0e:	008b8c13          	add	s8,s7,8
 a12:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a16:	03000593          	li	a1,48
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e46080e7          	jalr	-442(ra) # 862 <putc>
  putc(fd, 'x');
 a24:	07800593          	li	a1,120
 a28:	8556                	mv	a0,s5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	e38080e7          	jalr	-456(ra) # 862 <putc>
 a32:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a34:	00000b97          	auipc	s7,0x0
 a38:	4b4b8b93          	add	s7,s7,1204 # ee8 <digits>
 a3c:	03c9d793          	srl	a5,s3,0x3c
 a40:	97de                	add	a5,a5,s7
 a42:	0007c583          	lbu	a1,0(a5)
 a46:	8556                	mv	a0,s5
 a48:	00000097          	auipc	ra,0x0
 a4c:	e1a080e7          	jalr	-486(ra) # 862 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a50:	0992                	sll	s3,s3,0x4
 a52:	397d                	addw	s2,s2,-1
 a54:	fe0914e3          	bnez	s2,a3c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 a58:	8be2                	mv	s7,s8
      state = 0;
 a5a:	4981                	li	s3,0
 a5c:	bf21                	j	974 <vprintf+0x44>
        s = va_arg(ap, char*);
 a5e:	008b8993          	add	s3,s7,8
 a62:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 a66:	02090163          	beqz	s2,a88 <vprintf+0x158>
        while(*s != 0){
 a6a:	00094583          	lbu	a1,0(s2)
 a6e:	c9a5                	beqz	a1,ade <vprintf+0x1ae>
          putc(fd, *s);
 a70:	8556                	mv	a0,s5
 a72:	00000097          	auipc	ra,0x0
 a76:	df0080e7          	jalr	-528(ra) # 862 <putc>
          s++;
 a7a:	0905                	add	s2,s2,1
        while(*s != 0){
 a7c:	00094583          	lbu	a1,0(s2)
 a80:	f9e5                	bnez	a1,a70 <vprintf+0x140>
        s = va_arg(ap, char*);
 a82:	8bce                	mv	s7,s3
      state = 0;
 a84:	4981                	li	s3,0
 a86:	b5fd                	j	974 <vprintf+0x44>
          s = "(null)";
 a88:	00000917          	auipc	s2,0x0
 a8c:	40090913          	add	s2,s2,1024 # e88 <statistics+0x1c0>
        while(*s != 0){
 a90:	02800593          	li	a1,40
 a94:	bff1                	j	a70 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 a96:	008b8913          	add	s2,s7,8
 a9a:	000bc583          	lbu	a1,0(s7)
 a9e:	8556                	mv	a0,s5
 aa0:	00000097          	auipc	ra,0x0
 aa4:	dc2080e7          	jalr	-574(ra) # 862 <putc>
 aa8:	8bca                	mv	s7,s2
      state = 0;
 aaa:	4981                	li	s3,0
 aac:	b5e1                	j	974 <vprintf+0x44>
        putc(fd, c);
 aae:	02500593          	li	a1,37
 ab2:	8556                	mv	a0,s5
 ab4:	00000097          	auipc	ra,0x0
 ab8:	dae080e7          	jalr	-594(ra) # 862 <putc>
      state = 0;
 abc:	4981                	li	s3,0
 abe:	bd5d                	j	974 <vprintf+0x44>
        putc(fd, '%');
 ac0:	02500593          	li	a1,37
 ac4:	8556                	mv	a0,s5
 ac6:	00000097          	auipc	ra,0x0
 aca:	d9c080e7          	jalr	-612(ra) # 862 <putc>
        putc(fd, c);
 ace:	85ca                	mv	a1,s2
 ad0:	8556                	mv	a0,s5
 ad2:	00000097          	auipc	ra,0x0
 ad6:	d90080e7          	jalr	-624(ra) # 862 <putc>
      state = 0;
 ada:	4981                	li	s3,0
 adc:	bd61                	j	974 <vprintf+0x44>
        s = va_arg(ap, char*);
 ade:	8bce                	mv	s7,s3
      state = 0;
 ae0:	4981                	li	s3,0
 ae2:	bd49                	j	974 <vprintf+0x44>
    }
  }
}
 ae4:	60a6                	ld	ra,72(sp)
 ae6:	6406                	ld	s0,64(sp)
 ae8:	74e2                	ld	s1,56(sp)
 aea:	7942                	ld	s2,48(sp)
 aec:	79a2                	ld	s3,40(sp)
 aee:	7a02                	ld	s4,32(sp)
 af0:	6ae2                	ld	s5,24(sp)
 af2:	6b42                	ld	s6,16(sp)
 af4:	6ba2                	ld	s7,8(sp)
 af6:	6c02                	ld	s8,0(sp)
 af8:	6161                	add	sp,sp,80
 afa:	8082                	ret

0000000000000afc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 afc:	715d                	add	sp,sp,-80
 afe:	ec06                	sd	ra,24(sp)
 b00:	e822                	sd	s0,16(sp)
 b02:	1000                	add	s0,sp,32
 b04:	e010                	sd	a2,0(s0)
 b06:	e414                	sd	a3,8(s0)
 b08:	e818                	sd	a4,16(s0)
 b0a:	ec1c                	sd	a5,24(s0)
 b0c:	03043023          	sd	a6,32(s0)
 b10:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b14:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b18:	8622                	mv	a2,s0
 b1a:	00000097          	auipc	ra,0x0
 b1e:	e16080e7          	jalr	-490(ra) # 930 <vprintf>
}
 b22:	60e2                	ld	ra,24(sp)
 b24:	6442                	ld	s0,16(sp)
 b26:	6161                	add	sp,sp,80
 b28:	8082                	ret

0000000000000b2a <printf>:

void
printf(const char *fmt, ...)
{
 b2a:	711d                	add	sp,sp,-96
 b2c:	ec06                	sd	ra,24(sp)
 b2e:	e822                	sd	s0,16(sp)
 b30:	1000                	add	s0,sp,32
 b32:	e40c                	sd	a1,8(s0)
 b34:	e810                	sd	a2,16(s0)
 b36:	ec14                	sd	a3,24(s0)
 b38:	f018                	sd	a4,32(s0)
 b3a:	f41c                	sd	a5,40(s0)
 b3c:	03043823          	sd	a6,48(s0)
 b40:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b44:	00840613          	add	a2,s0,8
 b48:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b4c:	85aa                	mv	a1,a0
 b4e:	4505                	li	a0,1
 b50:	00000097          	auipc	ra,0x0
 b54:	de0080e7          	jalr	-544(ra) # 930 <vprintf>
}
 b58:	60e2                	ld	ra,24(sp)
 b5a:	6442                	ld	s0,16(sp)
 b5c:	6125                	add	sp,sp,96
 b5e:	8082                	ret

0000000000000b60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b60:	1141                	add	sp,sp,-16
 b62:	e422                	sd	s0,8(sp)
 b64:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b66:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b6a:	00000797          	auipc	a5,0x0
 b6e:	3be7b783          	ld	a5,958(a5) # f28 <freep>
 b72:	a02d                	j	b9c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b74:	4618                	lw	a4,8(a2)
 b76:	9f2d                	addw	a4,a4,a1
 b78:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b7c:	6398                	ld	a4,0(a5)
 b7e:	6310                	ld	a2,0(a4)
 b80:	a83d                	j	bbe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b82:	ff852703          	lw	a4,-8(a0)
 b86:	9f31                	addw	a4,a4,a2
 b88:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b8a:	ff053683          	ld	a3,-16(a0)
 b8e:	a091                	j	bd2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b90:	6398                	ld	a4,0(a5)
 b92:	00e7e463          	bltu	a5,a4,b9a <free+0x3a>
 b96:	00e6ea63          	bltu	a3,a4,baa <free+0x4a>
{
 b9a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9c:	fed7fae3          	bgeu	a5,a3,b90 <free+0x30>
 ba0:	6398                	ld	a4,0(a5)
 ba2:	00e6e463          	bltu	a3,a4,baa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba6:	fee7eae3          	bltu	a5,a4,b9a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 baa:	ff852583          	lw	a1,-8(a0)
 bae:	6390                	ld	a2,0(a5)
 bb0:	02059813          	sll	a6,a1,0x20
 bb4:	01c85713          	srl	a4,a6,0x1c
 bb8:	9736                	add	a4,a4,a3
 bba:	fae60de3          	beq	a2,a4,b74 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bbe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bc2:	4790                	lw	a2,8(a5)
 bc4:	02061593          	sll	a1,a2,0x20
 bc8:	01c5d713          	srl	a4,a1,0x1c
 bcc:	973e                	add	a4,a4,a5
 bce:	fae68ae3          	beq	a3,a4,b82 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bd2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bd4:	00000717          	auipc	a4,0x0
 bd8:	34f73a23          	sd	a5,852(a4) # f28 <freep>
}
 bdc:	6422                	ld	s0,8(sp)
 bde:	0141                	add	sp,sp,16
 be0:	8082                	ret

0000000000000be2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 be2:	7139                	add	sp,sp,-64
 be4:	fc06                	sd	ra,56(sp)
 be6:	f822                	sd	s0,48(sp)
 be8:	f426                	sd	s1,40(sp)
 bea:	f04a                	sd	s2,32(sp)
 bec:	ec4e                	sd	s3,24(sp)
 bee:	e852                	sd	s4,16(sp)
 bf0:	e456                	sd	s5,8(sp)
 bf2:	e05a                	sd	s6,0(sp)
 bf4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bf6:	02051493          	sll	s1,a0,0x20
 bfa:	9081                	srl	s1,s1,0x20
 bfc:	04bd                	add	s1,s1,15
 bfe:	8091                	srl	s1,s1,0x4
 c00:	0014899b          	addw	s3,s1,1
 c04:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c06:	00000517          	auipc	a0,0x0
 c0a:	32253503          	ld	a0,802(a0) # f28 <freep>
 c0e:	c515                	beqz	a0,c3a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c12:	4798                	lw	a4,8(a5)
 c14:	02977f63          	bgeu	a4,s1,c52 <malloc+0x70>
  if(nu < 4096)
 c18:	8a4e                	mv	s4,s3
 c1a:	0009871b          	sext.w	a4,s3
 c1e:	6685                	lui	a3,0x1
 c20:	00d77363          	bgeu	a4,a3,c26 <malloc+0x44>
 c24:	6a05                	lui	s4,0x1
 c26:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c2a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c2e:	00000917          	auipc	s2,0x0
 c32:	2fa90913          	add	s2,s2,762 # f28 <freep>
  if(p == (char*)-1)
 c36:	5afd                	li	s5,-1
 c38:	a895                	j	cac <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c3a:	00001797          	auipc	a5,0x1
 c3e:	2f678793          	add	a5,a5,758 # 1f30 <base>
 c42:	00000717          	auipc	a4,0x0
 c46:	2ef73323          	sd	a5,742(a4) # f28 <freep>
 c4a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c4c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c50:	b7e1                	j	c18 <malloc+0x36>
      if(p->s.size == nunits)
 c52:	02e48c63          	beq	s1,a4,c8a <malloc+0xa8>
        p->s.size -= nunits;
 c56:	4137073b          	subw	a4,a4,s3
 c5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c5c:	02071693          	sll	a3,a4,0x20
 c60:	01c6d713          	srl	a4,a3,0x1c
 c64:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c66:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c6a:	00000717          	auipc	a4,0x0
 c6e:	2aa73f23          	sd	a0,702(a4) # f28 <freep>
      return (void*)(p + 1);
 c72:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c76:	70e2                	ld	ra,56(sp)
 c78:	7442                	ld	s0,48(sp)
 c7a:	74a2                	ld	s1,40(sp)
 c7c:	7902                	ld	s2,32(sp)
 c7e:	69e2                	ld	s3,24(sp)
 c80:	6a42                	ld	s4,16(sp)
 c82:	6aa2                	ld	s5,8(sp)
 c84:	6b02                	ld	s6,0(sp)
 c86:	6121                	add	sp,sp,64
 c88:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c8a:	6398                	ld	a4,0(a5)
 c8c:	e118                	sd	a4,0(a0)
 c8e:	bff1                	j	c6a <malloc+0x88>
  hp->s.size = nu;
 c90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c94:	0541                	add	a0,a0,16
 c96:	00000097          	auipc	ra,0x0
 c9a:	eca080e7          	jalr	-310(ra) # b60 <free>
  return freep;
 c9e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ca2:	d971                	beqz	a0,c76 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ca4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ca6:	4798                	lw	a4,8(a5)
 ca8:	fa9775e3          	bgeu	a4,s1,c52 <malloc+0x70>
    if(p == freep)
 cac:	00093703          	ld	a4,0(s2)
 cb0:	853e                	mv	a0,a5
 cb2:	fef719e3          	bne	a4,a5,ca4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cb6:	8552                	mv	a0,s4
 cb8:	00000097          	auipc	ra,0x0
 cbc:	b92080e7          	jalr	-1134(ra) # 84a <sbrk>
  if(p == (char*)-1)
 cc0:	fd5518e3          	bne	a0,s5,c90 <malloc+0xae>
        return 0;
 cc4:	4501                	li	a0,0
 cc6:	bf45                	j	c76 <malloc+0x94>

0000000000000cc8 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 cc8:	7179                	add	sp,sp,-48
 cca:	f406                	sd	ra,40(sp)
 ccc:	f022                	sd	s0,32(sp)
 cce:	ec26                	sd	s1,24(sp)
 cd0:	e84a                	sd	s2,16(sp)
 cd2:	e44e                	sd	s3,8(sp)
 cd4:	e052                	sd	s4,0(sp)
 cd6:	1800                	add	s0,sp,48
 cd8:	8a2a                	mv	s4,a0
 cda:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 cdc:	4581                	li	a1,0
 cde:	00000517          	auipc	a0,0x0
 ce2:	22250513          	add	a0,a0,546 # f00 <digits+0x18>
 ce6:	00000097          	auipc	ra,0x0
 cea:	b1c080e7          	jalr	-1252(ra) # 802 <open>
  if(fd < 0) {
 cee:	04054263          	bltz	a0,d32 <statistics+0x6a>
 cf2:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 cf4:	4481                	li	s1,0
 cf6:	03205063          	blez	s2,d16 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 cfa:	4099063b          	subw	a2,s2,s1
 cfe:	009a05b3          	add	a1,s4,s1
 d02:	854e                	mv	a0,s3
 d04:	00000097          	auipc	ra,0x0
 d08:	ad6080e7          	jalr	-1322(ra) # 7da <read>
 d0c:	00054563          	bltz	a0,d16 <statistics+0x4e>
      break;
    }
    i += n;
 d10:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 d12:	ff24c4e3          	blt	s1,s2,cfa <statistics+0x32>
  }
  close(fd);
 d16:	854e                	mv	a0,s3
 d18:	00000097          	auipc	ra,0x0
 d1c:	ad2080e7          	jalr	-1326(ra) # 7ea <close>
  return i;
}
 d20:	8526                	mv	a0,s1
 d22:	70a2                	ld	ra,40(sp)
 d24:	7402                	ld	s0,32(sp)
 d26:	64e2                	ld	s1,24(sp)
 d28:	6942                	ld	s2,16(sp)
 d2a:	69a2                	ld	s3,8(sp)
 d2c:	6a02                	ld	s4,0(sp)
 d2e:	6145                	add	sp,sp,48
 d30:	8082                	ret
      fprintf(2, "stats: open failed\n");
 d32:	00000597          	auipc	a1,0x0
 d36:	1de58593          	add	a1,a1,478 # f10 <digits+0x28>
 d3a:	4509                	li	a0,2
 d3c:	00000097          	auipc	ra,0x0
 d40:	dc0080e7          	jalr	-576(ra) # afc <fprintf>
      exit(1);
 d44:	4505                	li	a0,1
 d46:	00000097          	auipc	ra,0x0
 d4a:	a7c080e7          	jalr	-1412(ra) # 7c2 <exit>
