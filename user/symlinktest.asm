
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	4591                	li	a1,4
   e:	00001097          	auipc	ra,0x1
  12:	96a080e7          	jalr	-1686(ra) # 978 <open>
  if(fd < 0)
  16:	02054063          	bltz	a0,36 <stat_slink+0x36>
    return -1;
  if(fstat(fd, st) != 0)
  1a:	85a6                	mv	a1,s1
  1c:	00001097          	auipc	ra,0x1
  20:	974080e7          	jalr	-1676(ra) # 990 <fstat>
  24:	00a03533          	snez	a0,a0
  28:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	64a2                	ld	s1,8(sp)
  32:	6105                	add	sp,sp,32
  34:	8082                	ret
    return -1;
  36:	557d                	li	a0,-1
  38:	bfd5                	j	2c <stat_slink+0x2c>

000000000000003a <main>:
{
  3a:	7119                	add	sp,sp,-128
  3c:	fc86                	sd	ra,120(sp)
  3e:	f8a2                	sd	s0,112(sp)
  40:	f4a6                	sd	s1,104(sp)
  42:	f0ca                	sd	s2,96(sp)
  44:	ecce                	sd	s3,88(sp)
  46:	e8d2                	sd	s4,80(sp)
  48:	e4d6                	sd	s5,72(sp)
  4a:	e0da                	sd	s6,64(sp)
  4c:	fc5e                	sd	s7,56(sp)
  4e:	f862                	sd	s8,48(sp)
  50:	0100                	add	s0,sp,128
  unlink("/testsymlink/a");
  52:	00001517          	auipc	a0,0x1
  56:	df650513          	add	a0,a0,-522 # e48 <malloc+0xe8>
  5a:	00001097          	auipc	ra,0x1
  5e:	92e080e7          	jalr	-1746(ra) # 988 <unlink>
  unlink("/testsymlink/b");
  62:	00001517          	auipc	a0,0x1
  66:	df650513          	add	a0,a0,-522 # e58 <malloc+0xf8>
  6a:	00001097          	auipc	ra,0x1
  6e:	91e080e7          	jalr	-1762(ra) # 988 <unlink>
  unlink("/testsymlink/c");
  72:	00001517          	auipc	a0,0x1
  76:	df650513          	add	a0,a0,-522 # e68 <malloc+0x108>
  7a:	00001097          	auipc	ra,0x1
  7e:	90e080e7          	jalr	-1778(ra) # 988 <unlink>
  unlink("/testsymlink/1");
  82:	00001517          	auipc	a0,0x1
  86:	df650513          	add	a0,a0,-522 # e78 <malloc+0x118>
  8a:	00001097          	auipc	ra,0x1
  8e:	8fe080e7          	jalr	-1794(ra) # 988 <unlink>
  unlink("/testsymlink/2");
  92:	00001517          	auipc	a0,0x1
  96:	df650513          	add	a0,a0,-522 # e88 <malloc+0x128>
  9a:	00001097          	auipc	ra,0x1
  9e:	8ee080e7          	jalr	-1810(ra) # 988 <unlink>
  unlink("/testsymlink/3");
  a2:	00001517          	auipc	a0,0x1
  a6:	df650513          	add	a0,a0,-522 # e98 <malloc+0x138>
  aa:	00001097          	auipc	ra,0x1
  ae:	8de080e7          	jalr	-1826(ra) # 988 <unlink>
  unlink("/testsymlink/4");
  b2:	00001517          	auipc	a0,0x1
  b6:	df650513          	add	a0,a0,-522 # ea8 <malloc+0x148>
  ba:	00001097          	auipc	ra,0x1
  be:	8ce080e7          	jalr	-1842(ra) # 988 <unlink>
  unlink("/testsymlink/z");
  c2:	00001517          	auipc	a0,0x1
  c6:	df650513          	add	a0,a0,-522 # eb8 <malloc+0x158>
  ca:	00001097          	auipc	ra,0x1
  ce:	8be080e7          	jalr	-1858(ra) # 988 <unlink>
  unlink("/testsymlink/y");
  d2:	00001517          	auipc	a0,0x1
  d6:	df650513          	add	a0,a0,-522 # ec8 <malloc+0x168>
  da:	00001097          	auipc	ra,0x1
  de:	8ae080e7          	jalr	-1874(ra) # 988 <unlink>
  unlink("/testsymlink");
  e2:	00001517          	auipc	a0,0x1
  e6:	df650513          	add	a0,a0,-522 # ed8 <malloc+0x178>
  ea:	00001097          	auipc	ra,0x1
  ee:	89e080e7          	jalr	-1890(ra) # 988 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f2:	646367b7          	lui	a5,0x64636
  f6:	26178793          	add	a5,a5,609 # 64636261 <__global_pointer$+0x64634710>
  fa:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
  fe:	f8040723          	sb	zero,-114(s0)
 102:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 106:	00001517          	auipc	a0,0x1
 10a:	de250513          	add	a0,a0,-542 # ee8 <malloc+0x188>
 10e:	00001097          	auipc	ra,0x1
 112:	b9a080e7          	jalr	-1126(ra) # ca8 <printf>

  mkdir("/testsymlink");
 116:	00001517          	auipc	a0,0x1
 11a:	dc250513          	add	a0,a0,-574 # ed8 <malloc+0x178>
 11e:	00001097          	auipc	ra,0x1
 122:	882080e7          	jalr	-1918(ra) # 9a0 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 126:	20200593          	li	a1,514
 12a:	00001517          	auipc	a0,0x1
 12e:	d1e50513          	add	a0,a0,-738 # e48 <malloc+0xe8>
 132:	00001097          	auipc	ra,0x1
 136:	846080e7          	jalr	-1978(ra) # 978 <open>
 13a:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 13c:	0e054f63          	bltz	a0,23a <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 140:	00001597          	auipc	a1,0x1
 144:	d1858593          	add	a1,a1,-744 # e58 <malloc+0xf8>
 148:	00001517          	auipc	a0,0x1
 14c:	d0050513          	add	a0,a0,-768 # e48 <malloc+0xe8>
 150:	00001097          	auipc	ra,0x1
 154:	888080e7          	jalr	-1912(ra) # 9d8 <symlink>
  if(r < 0)
 158:	10054063          	bltz	a0,258 <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 15c:	4611                	li	a2,4
 15e:	f9040593          	add	a1,s0,-112
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	7f4080e7          	jalr	2036(ra) # 958 <write>
 16c:	4791                	li	a5,4
 16e:	10f50463          	beq	a0,a5,276 <main+0x23c>
    fail("failed to write to a");
 172:	00001517          	auipc	a0,0x1
 176:	dce50513          	add	a0,a0,-562 # f40 <malloc+0x1e0>
 17a:	00001097          	auipc	ra,0x1
 17e:	b2e080e7          	jalr	-1234(ra) # ca8 <printf>
 182:	4785                	li	a5,1
 184:	00001717          	auipc	a4,0x1
 188:	1cf72a23          	sw	a5,468(a4) # 1358 <failed>
  int r, fd1 = -1, fd2 = -1;
 18c:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	7d0080e7          	jalr	2000(ra) # 960 <close>
  close(fd2);
 198:	854a                	mv	a0,s2
 19a:	00000097          	auipc	ra,0x0
 19e:	7c6080e7          	jalr	1990(ra) # 960 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	07e50513          	add	a0,a0,126 # 1220 <malloc+0x4c0>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	afe080e7          	jalr	-1282(ra) # ca8 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b2:	20200593          	li	a1,514
 1b6:	00001517          	auipc	a0,0x1
 1ba:	d0250513          	add	a0,a0,-766 # eb8 <malloc+0x158>
 1be:	00000097          	auipc	ra,0x0
 1c2:	7ba080e7          	jalr	1978(ra) # 978 <open>
  if(fd < 0) {
 1c6:	42054263          	bltz	a0,5ea <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1ca:	00000097          	auipc	ra,0x0
 1ce:	796080e7          	jalr	1942(ra) # 960 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	75e080e7          	jalr	1886(ra) # 930 <fork>
    if(pid < 0){
 1da:	42054563          	bltz	a0,604 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1de:	44050063          	beqz	a0,61e <main+0x5e4>
    pid = fork();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	74e080e7          	jalr	1870(ra) # 930 <fork>
    if(pid < 0){
 1ea:	40054d63          	bltz	a0,604 <main+0x5ca>
    if(pid == 0) {
 1ee:	42050863          	beqz	a0,61e <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f2:	f9840513          	add	a0,s0,-104
 1f6:	00000097          	auipc	ra,0x0
 1fa:	74a080e7          	jalr	1866(ra) # 940 <wait>
    if(r != 0) {
 1fe:	f9842783          	lw	a5,-104(s0)
 202:	4a079863          	bnez	a5,6b2 <main+0x678>
    wait(&r);
 206:	f9840513          	add	a0,s0,-104
 20a:	00000097          	auipc	ra,0x0
 20e:	736080e7          	jalr	1846(ra) # 940 <wait>
    if(r != 0) {
 212:	f9842783          	lw	a5,-104(s0)
 216:	48079e63          	bnez	a5,6b2 <main+0x678>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	0a650513          	add	a0,a0,166 # 12c0 <malloc+0x560>
 222:	00001097          	auipc	ra,0x1
 226:	a86080e7          	jalr	-1402(ra) # ca8 <printf>
  exit(failed);
 22a:	00001517          	auipc	a0,0x1
 22e:	12e52503          	lw	a0,302(a0) # 1358 <failed>
 232:	00000097          	auipc	ra,0x0
 236:	706080e7          	jalr	1798(ra) # 938 <exit>
  if(fd1 < 0) fail("failed to open a");
 23a:	00001517          	auipc	a0,0x1
 23e:	cc650513          	add	a0,a0,-826 # f00 <malloc+0x1a0>
 242:	00001097          	auipc	ra,0x1
 246:	a66080e7          	jalr	-1434(ra) # ca8 <printf>
 24a:	4785                	li	a5,1
 24c:	00001717          	auipc	a4,0x1
 250:	10f72623          	sw	a5,268(a4) # 1358 <failed>
  int r, fd1 = -1, fd2 = -1;
 254:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 256:	bf25                	j	18e <main+0x154>
    fail("symlink b -> a failed");
 258:	00001517          	auipc	a0,0x1
 25c:	cc850513          	add	a0,a0,-824 # f20 <malloc+0x1c0>
 260:	00001097          	auipc	ra,0x1
 264:	a48080e7          	jalr	-1464(ra) # ca8 <printf>
 268:	4785                	li	a5,1
 26a:	00001717          	auipc	a4,0x1
 26e:	0ef72723          	sw	a5,238(a4) # 1358 <failed>
  int r, fd1 = -1, fd2 = -1;
 272:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 274:	bf29                	j	18e <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 276:	f9840593          	add	a1,s0,-104
 27a:	00001517          	auipc	a0,0x1
 27e:	bde50513          	add	a0,a0,-1058 # e58 <malloc+0xf8>
 282:	00000097          	auipc	ra,0x0
 286:	d7e080e7          	jalr	-642(ra) # 0 <stat_slink>
 28a:	e50d                	bnez	a0,2b4 <main+0x27a>
  if(st.type != T_SYMLINK)
 28c:	fa041703          	lh	a4,-96(s0)
 290:	4791                	li	a5,4
 292:	04f70063          	beq	a4,a5,2d2 <main+0x298>
    fail("b isn't a symlink");
 296:	00001517          	auipc	a0,0x1
 29a:	cea50513          	add	a0,a0,-790 # f80 <malloc+0x220>
 29e:	00001097          	auipc	ra,0x1
 2a2:	a0a080e7          	jalr	-1526(ra) # ca8 <printf>
 2a6:	4785                	li	a5,1
 2a8:	00001717          	auipc	a4,0x1
 2ac:	0af72823          	sw	a5,176(a4) # 1358 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b0:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b2:	bdf1                	j	18e <main+0x154>
    fail("failed to stat b");
 2b4:	00001517          	auipc	a0,0x1
 2b8:	cac50513          	add	a0,a0,-852 # f60 <malloc+0x200>
 2bc:	00001097          	auipc	ra,0x1
 2c0:	9ec080e7          	jalr	-1556(ra) # ca8 <printf>
 2c4:	4785                	li	a5,1
 2c6:	00001717          	auipc	a4,0x1
 2ca:	08f72923          	sw	a5,146(a4) # 1358 <failed>
  int r, fd1 = -1, fd2 = -1;
 2ce:	597d                	li	s2,-1
    fail("failed to stat b");
 2d0:	bd7d                	j	18e <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d2:	4589                	li	a1,2
 2d4:	00001517          	auipc	a0,0x1
 2d8:	b8450513          	add	a0,a0,-1148 # e58 <malloc+0xf8>
 2dc:	00000097          	auipc	ra,0x0
 2e0:	69c080e7          	jalr	1692(ra) # 978 <open>
 2e4:	892a                	mv	s2,a0
  if(fd2 < 0)
 2e6:	02054d63          	bltz	a0,320 <main+0x2e6>
  read(fd2, &c, 1);
 2ea:	4605                	li	a2,1
 2ec:	f8e40593          	add	a1,s0,-114
 2f0:	00000097          	auipc	ra,0x0
 2f4:	660080e7          	jalr	1632(ra) # 950 <read>
  if (c != 'a')
 2f8:	f8e44703          	lbu	a4,-114(s0)
 2fc:	06100793          	li	a5,97
 300:	02f70e63          	beq	a4,a5,33c <main+0x302>
    fail("failed to read bytes from b");
 304:	00001517          	auipc	a0,0x1
 308:	cbc50513          	add	a0,a0,-836 # fc0 <malloc+0x260>
 30c:	00001097          	auipc	ra,0x1
 310:	99c080e7          	jalr	-1636(ra) # ca8 <printf>
 314:	4785                	li	a5,1
 316:	00001717          	auipc	a4,0x1
 31a:	04f72123          	sw	a5,66(a4) # 1358 <failed>
 31e:	bd85                	j	18e <main+0x154>
    fail("failed to open b");
 320:	00001517          	auipc	a0,0x1
 324:	c8050513          	add	a0,a0,-896 # fa0 <malloc+0x240>
 328:	00001097          	auipc	ra,0x1
 32c:	980080e7          	jalr	-1664(ra) # ca8 <printf>
 330:	4785                	li	a5,1
 332:	00001717          	auipc	a4,0x1
 336:	02f72323          	sw	a5,38(a4) # 1358 <failed>
 33a:	bd91                	j	18e <main+0x154>
  unlink("/testsymlink/a");
 33c:	00001517          	auipc	a0,0x1
 340:	b0c50513          	add	a0,a0,-1268 # e48 <malloc+0xe8>
 344:	00000097          	auipc	ra,0x0
 348:	644080e7          	jalr	1604(ra) # 988 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 34c:	4589                	li	a1,2
 34e:	00001517          	auipc	a0,0x1
 352:	b0a50513          	add	a0,a0,-1270 # e58 <malloc+0xf8>
 356:	00000097          	auipc	ra,0x0
 35a:	622080e7          	jalr	1570(ra) # 978 <open>
 35e:	12055263          	bgez	a0,482 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 362:	00001597          	auipc	a1,0x1
 366:	ae658593          	add	a1,a1,-1306 # e48 <malloc+0xe8>
 36a:	00001517          	auipc	a0,0x1
 36e:	aee50513          	add	a0,a0,-1298 # e58 <malloc+0xf8>
 372:	00000097          	auipc	ra,0x0
 376:	666080e7          	jalr	1638(ra) # 9d8 <symlink>
  if(r < 0)
 37a:	12054263          	bltz	a0,49e <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 37e:	4589                	li	a1,2
 380:	00001517          	auipc	a0,0x1
 384:	ad850513          	add	a0,a0,-1320 # e58 <malloc+0xf8>
 388:	00000097          	auipc	ra,0x0
 38c:	5f0080e7          	jalr	1520(ra) # 978 <open>
  if(r >= 0)
 390:	12055563          	bgez	a0,4ba <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 394:	00001597          	auipc	a1,0x1
 398:	ad458593          	add	a1,a1,-1324 # e68 <malloc+0x108>
 39c:	00001517          	auipc	a0,0x1
 3a0:	ce450513          	add	a0,a0,-796 # 1080 <malloc+0x320>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	634080e7          	jalr	1588(ra) # 9d8 <symlink>
  if(r != 0)
 3ac:	12051563          	bnez	a0,4d6 <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b0:	00001597          	auipc	a1,0x1
 3b4:	ac858593          	add	a1,a1,-1336 # e78 <malloc+0x118>
 3b8:	00001517          	auipc	a0,0x1
 3bc:	ad050513          	add	a0,a0,-1328 # e88 <malloc+0x128>
 3c0:	00000097          	auipc	ra,0x0
 3c4:	618080e7          	jalr	1560(ra) # 9d8 <symlink>
  if(r) fail("Failed to link 1->2");
 3c8:	12051563          	bnez	a0,4f2 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3cc:	00001597          	auipc	a1,0x1
 3d0:	abc58593          	add	a1,a1,-1348 # e88 <malloc+0x128>
 3d4:	00001517          	auipc	a0,0x1
 3d8:	ac450513          	add	a0,a0,-1340 # e98 <malloc+0x138>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	5fc080e7          	jalr	1532(ra) # 9d8 <symlink>
  if(r) fail("Failed to link 2->3");
 3e4:	12051563          	bnez	a0,50e <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3e8:	00001597          	auipc	a1,0x1
 3ec:	ab058593          	add	a1,a1,-1360 # e98 <malloc+0x138>
 3f0:	00001517          	auipc	a0,0x1
 3f4:	ab850513          	add	a0,a0,-1352 # ea8 <malloc+0x148>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	5e0080e7          	jalr	1504(ra) # 9d8 <symlink>
  if(r) fail("Failed to link 3->4");
 400:	12051563          	bnez	a0,52a <main+0x4f0>
  close(fd1);
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	55a080e7          	jalr	1370(ra) # 960 <close>
  close(fd2);
 40e:	854a                	mv	a0,s2
 410:	00000097          	auipc	ra,0x0
 414:	550080e7          	jalr	1360(ra) # 960 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 418:	20200593          	li	a1,514
 41c:	00001517          	auipc	a0,0x1
 420:	a8c50513          	add	a0,a0,-1396 # ea8 <malloc+0x148>
 424:	00000097          	auipc	ra,0x0
 428:	554080e7          	jalr	1364(ra) # 978 <open>
 42c:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 42e:	10054c63          	bltz	a0,546 <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 432:	4589                	li	a1,2
 434:	00001517          	auipc	a0,0x1
 438:	a4450513          	add	a0,a0,-1468 # e78 <malloc+0x118>
 43c:	00000097          	auipc	ra,0x0
 440:	53c080e7          	jalr	1340(ra) # 978 <open>
 444:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 446:	10054e63          	bltz	a0,562 <main+0x528>
  c = '#';
 44a:	02300793          	li	a5,35
 44e:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 452:	4605                	li	a2,1
 454:	f8e40593          	add	a1,s0,-114
 458:	00000097          	auipc	ra,0x0
 45c:	500080e7          	jalr	1280(ra) # 958 <write>
  if(r!=1) fail("Failed to write to 1\n");
 460:	4785                	li	a5,1
 462:	10f50e63          	beq	a0,a5,57e <main+0x544>
 466:	00001517          	auipc	a0,0x1
 46a:	d1a50513          	add	a0,a0,-742 # 1180 <malloc+0x420>
 46e:	00001097          	auipc	ra,0x1
 472:	83a080e7          	jalr	-1990(ra) # ca8 <printf>
 476:	4785                	li	a5,1
 478:	00001717          	auipc	a4,0x1
 47c:	eef72023          	sw	a5,-288(a4) # 1358 <failed>
 480:	b339                	j	18e <main+0x154>
    fail("Should not be able to open b after deleting a");
 482:	00001517          	auipc	a0,0x1
 486:	b6650513          	add	a0,a0,-1178 # fe8 <malloc+0x288>
 48a:	00001097          	auipc	ra,0x1
 48e:	81e080e7          	jalr	-2018(ra) # ca8 <printf>
 492:	4785                	li	a5,1
 494:	00001717          	auipc	a4,0x1
 498:	ecf72223          	sw	a5,-316(a4) # 1358 <failed>
 49c:	b9cd                	j	18e <main+0x154>
    fail("symlink a -> b failed");
 49e:	00001517          	auipc	a0,0x1
 4a2:	b8250513          	add	a0,a0,-1150 # 1020 <malloc+0x2c0>
 4a6:	00001097          	auipc	ra,0x1
 4aa:	802080e7          	jalr	-2046(ra) # ca8 <printf>
 4ae:	4785                	li	a5,1
 4b0:	00001717          	auipc	a4,0x1
 4b4:	eaf72423          	sw	a5,-344(a4) # 1358 <failed>
 4b8:	b9d9                	j	18e <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	b8650513          	add	a0,a0,-1146 # 1040 <malloc+0x2e0>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	7e6080e7          	jalr	2022(ra) # ca8 <printf>
 4ca:	4785                	li	a5,1
 4cc:	00001717          	auipc	a4,0x1
 4d0:	e8f72623          	sw	a5,-372(a4) # 1358 <failed>
 4d4:	b96d                	j	18e <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4d6:	00001517          	auipc	a0,0x1
 4da:	bca50513          	add	a0,a0,-1078 # 10a0 <malloc+0x340>
 4de:	00000097          	auipc	ra,0x0
 4e2:	7ca080e7          	jalr	1994(ra) # ca8 <printf>
 4e6:	4785                	li	a5,1
 4e8:	00001717          	auipc	a4,0x1
 4ec:	e6f72823          	sw	a5,-400(a4) # 1358 <failed>
 4f0:	b979                	j	18e <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f2:	00001517          	auipc	a0,0x1
 4f6:	bee50513          	add	a0,a0,-1042 # 10e0 <malloc+0x380>
 4fa:	00000097          	auipc	ra,0x0
 4fe:	7ae080e7          	jalr	1966(ra) # ca8 <printf>
 502:	4785                	li	a5,1
 504:	00001717          	auipc	a4,0x1
 508:	e4f72a23          	sw	a5,-428(a4) # 1358 <failed>
 50c:	b149                	j	18e <main+0x154>
  if(r) fail("Failed to link 2->3");
 50e:	00001517          	auipc	a0,0x1
 512:	bf250513          	add	a0,a0,-1038 # 1100 <malloc+0x3a0>
 516:	00000097          	auipc	ra,0x0
 51a:	792080e7          	jalr	1938(ra) # ca8 <printf>
 51e:	4785                	li	a5,1
 520:	00001717          	auipc	a4,0x1
 524:	e2f72c23          	sw	a5,-456(a4) # 1358 <failed>
 528:	b19d                	j	18e <main+0x154>
  if(r) fail("Failed to link 3->4");
 52a:	00001517          	auipc	a0,0x1
 52e:	bf650513          	add	a0,a0,-1034 # 1120 <malloc+0x3c0>
 532:	00000097          	auipc	ra,0x0
 536:	776080e7          	jalr	1910(ra) # ca8 <printf>
 53a:	4785                	li	a5,1
 53c:	00001717          	auipc	a4,0x1
 540:	e0f72e23          	sw	a5,-484(a4) # 1358 <failed>
 544:	b1a9                	j	18e <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 546:	00001517          	auipc	a0,0x1
 54a:	bfa50513          	add	a0,a0,-1030 # 1140 <malloc+0x3e0>
 54e:	00000097          	auipc	ra,0x0
 552:	75a080e7          	jalr	1882(ra) # ca8 <printf>
 556:	4785                	li	a5,1
 558:	00001717          	auipc	a4,0x1
 55c:	e0f72023          	sw	a5,-512(a4) # 1358 <failed>
 560:	b13d                	j	18e <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 562:	00001517          	auipc	a0,0x1
 566:	bfe50513          	add	a0,a0,-1026 # 1160 <malloc+0x400>
 56a:	00000097          	auipc	ra,0x0
 56e:	73e080e7          	jalr	1854(ra) # ca8 <printf>
 572:	4785                	li	a5,1
 574:	00001717          	auipc	a4,0x1
 578:	def72223          	sw	a5,-540(a4) # 1358 <failed>
 57c:	b909                	j	18e <main+0x154>
  r = read(fd1, &c2, 1);
 57e:	4605                	li	a2,1
 580:	f8f40593          	add	a1,s0,-113
 584:	8526                	mv	a0,s1
 586:	00000097          	auipc	ra,0x0
 58a:	3ca080e7          	jalr	970(ra) # 950 <read>
  if(r!=1) fail("Failed to read from 4\n");
 58e:	4785                	li	a5,1
 590:	02f51663          	bne	a0,a5,5bc <main+0x582>
  if(c!=c2)
 594:	f8e44703          	lbu	a4,-114(s0)
 598:	f8f44783          	lbu	a5,-113(s0)
 59c:	02f70e63          	beq	a4,a5,5d8 <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a0:	00001517          	auipc	a0,0x1
 5a4:	c2850513          	add	a0,a0,-984 # 11c8 <malloc+0x468>
 5a8:	00000097          	auipc	ra,0x0
 5ac:	700080e7          	jalr	1792(ra) # ca8 <printf>
 5b0:	4785                	li	a5,1
 5b2:	00001717          	auipc	a4,0x1
 5b6:	daf72323          	sw	a5,-602(a4) # 1358 <failed>
 5ba:	bed1                	j	18e <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	be450513          	add	a0,a0,-1052 # 11a0 <malloc+0x440>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	6e4080e7          	jalr	1764(ra) # ca8 <printf>
 5cc:	4785                	li	a5,1
 5ce:	00001717          	auipc	a4,0x1
 5d2:	d8f72523          	sw	a5,-630(a4) # 1358 <failed>
 5d6:	be65                	j	18e <main+0x154>
  printf("test symlinks: ok\n");
 5d8:	00001517          	auipc	a0,0x1
 5dc:	c3050513          	add	a0,a0,-976 # 1208 <malloc+0x4a8>
 5e0:	00000097          	auipc	ra,0x0
 5e4:	6c8080e7          	jalr	1736(ra) # ca8 <printf>
 5e8:	b65d                	j	18e <main+0x154>
    printf("FAILED: open failed");
 5ea:	00001517          	auipc	a0,0x1
 5ee:	c5e50513          	add	a0,a0,-930 # 1248 <malloc+0x4e8>
 5f2:	00000097          	auipc	ra,0x0
 5f6:	6b6080e7          	jalr	1718(ra) # ca8 <printf>
    exit(1);
 5fa:	4505                	li	a0,1
 5fc:	00000097          	auipc	ra,0x0
 600:	33c080e7          	jalr	828(ra) # 938 <exit>
      printf("FAILED: fork failed\n");
 604:	00001517          	auipc	a0,0x1
 608:	c5c50513          	add	a0,a0,-932 # 1260 <malloc+0x500>
 60c:	00000097          	auipc	ra,0x0
 610:	69c080e7          	jalr	1692(ra) # ca8 <printf>
      exit(1);
 614:	4505                	li	a0,1
 616:	00000097          	auipc	ra,0x0
 61a:	322080e7          	jalr	802(ra) # 938 <exit>
  int r, fd1 = -1, fd2 = -1;
 61e:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 622:	06100913          	li	s2,97
        x = x * 1103515245 + 12345;
 626:	41c65ab7          	lui	s5,0x41c65
 62a:	e6da8a9b          	addw	s5,s5,-403 # 41c64e6d <__global_pointer$+0x41c6331c>
 62e:	6a0d                	lui	s4,0x3
 630:	039a0a1b          	addw	s4,s4,57 # 3039 <__global_pointer$+0x14e8>
        if((x % 3) == 0) {
 634:	4b0d                	li	s6,3
          unlink("/testsymlink/y");
 636:	00001997          	auipc	s3,0x1
 63a:	89298993          	add	s3,s3,-1902 # ec8 <malloc+0x168>
          symlink("/testsymlink/z", "/testsymlink/y");
 63e:	00001b97          	auipc	s7,0x1
 642:	87ab8b93          	add	s7,s7,-1926 # eb8 <malloc+0x158>
            if(st.type != T_SYMLINK) {
 646:	4c11                	li	s8,4
 648:	a801                	j	658 <main+0x61e>
          unlink("/testsymlink/y");
 64a:	854e                	mv	a0,s3
 64c:	00000097          	auipc	ra,0x0
 650:	33c080e7          	jalr	828(ra) # 988 <unlink>
      for(i = 0; i < 100; i++){
 654:	34fd                	addw	s1,s1,-1
 656:	c8a9                	beqz	s1,6a8 <main+0x66e>
        x = x * 1103515245 + 12345;
 658:	035907bb          	mulw	a5,s2,s5
 65c:	014787bb          	addw	a5,a5,s4
 660:	0007891b          	sext.w	s2,a5
        if((x % 3) == 0) {
 664:	0367f7bb          	remuw	a5,a5,s6
 668:	f3ed                	bnez	a5,64a <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66a:	85ce                	mv	a1,s3
 66c:	855e                	mv	a0,s7
 66e:	00000097          	auipc	ra,0x0
 672:	36a080e7          	jalr	874(ra) # 9d8 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 676:	f9840593          	add	a1,s0,-104
 67a:	854e                	mv	a0,s3
 67c:	00000097          	auipc	ra,0x0
 680:	984080e7          	jalr	-1660(ra) # 0 <stat_slink>
 684:	f961                	bnez	a0,654 <main+0x61a>
            if(st.type != T_SYMLINK) {
 686:	fa041583          	lh	a1,-96(s0)
 68a:	fd8585e3          	beq	a1,s8,654 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 68e:	00001517          	auipc	a0,0x1
 692:	bea50513          	add	a0,a0,-1046 # 1278 <malloc+0x518>
 696:	00000097          	auipc	ra,0x0
 69a:	612080e7          	jalr	1554(ra) # ca8 <printf>
              exit(1);
 69e:	4505                	li	a0,1
 6a0:	00000097          	auipc	ra,0x0
 6a4:	298080e7          	jalr	664(ra) # 938 <exit>
      exit(0);
 6a8:	4501                	li	a0,0
 6aa:	00000097          	auipc	ra,0x0
 6ae:	28e080e7          	jalr	654(ra) # 938 <exit>
      printf("test concurrent symlinks: failed\n");
 6b2:	00001517          	auipc	a0,0x1
 6b6:	be650513          	add	a0,a0,-1050 # 1298 <malloc+0x538>
 6ba:	00000097          	auipc	ra,0x0
 6be:	5ee080e7          	jalr	1518(ra) # ca8 <printf>
      exit(1);
 6c2:	4505                	li	a0,1
 6c4:	00000097          	auipc	ra,0x0
 6c8:	274080e7          	jalr	628(ra) # 938 <exit>

00000000000006cc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 6cc:	1141                	add	sp,sp,-16
 6ce:	e422                	sd	s0,8(sp)
 6d0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6d2:	87aa                	mv	a5,a0
 6d4:	0585                	add	a1,a1,1
 6d6:	0785                	add	a5,a5,1
 6d8:	fff5c703          	lbu	a4,-1(a1)
 6dc:	fee78fa3          	sb	a4,-1(a5)
 6e0:	fb75                	bnez	a4,6d4 <strcpy+0x8>
    ;
  return os;
}
 6e2:	6422                	ld	s0,8(sp)
 6e4:	0141                	add	sp,sp,16
 6e6:	8082                	ret

00000000000006e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6e8:	1141                	add	sp,sp,-16
 6ea:	e422                	sd	s0,8(sp)
 6ec:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 6ee:	00054783          	lbu	a5,0(a0)
 6f2:	cb91                	beqz	a5,706 <strcmp+0x1e>
 6f4:	0005c703          	lbu	a4,0(a1)
 6f8:	00f71763          	bne	a4,a5,706 <strcmp+0x1e>
    p++, q++;
 6fc:	0505                	add	a0,a0,1
 6fe:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 700:	00054783          	lbu	a5,0(a0)
 704:	fbe5                	bnez	a5,6f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 706:	0005c503          	lbu	a0,0(a1)
}
 70a:	40a7853b          	subw	a0,a5,a0
 70e:	6422                	ld	s0,8(sp)
 710:	0141                	add	sp,sp,16
 712:	8082                	ret

0000000000000714 <strlen>:

uint
strlen(const char *s)
{
 714:	1141                	add	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 71a:	00054783          	lbu	a5,0(a0)
 71e:	cf91                	beqz	a5,73a <strlen+0x26>
 720:	0505                	add	a0,a0,1
 722:	87aa                	mv	a5,a0
 724:	86be                	mv	a3,a5
 726:	0785                	add	a5,a5,1
 728:	fff7c703          	lbu	a4,-1(a5)
 72c:	ff65                	bnez	a4,724 <strlen+0x10>
 72e:	40a6853b          	subw	a0,a3,a0
 732:	2505                	addw	a0,a0,1
    ;
  return n;
}
 734:	6422                	ld	s0,8(sp)
 736:	0141                	add	sp,sp,16
 738:	8082                	ret
  for(n = 0; s[n]; n++)
 73a:	4501                	li	a0,0
 73c:	bfe5                	j	734 <strlen+0x20>

000000000000073e <memset>:

void*
memset(void *dst, int c, uint n)
{
 73e:	1141                	add	sp,sp,-16
 740:	e422                	sd	s0,8(sp)
 742:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 744:	ca19                	beqz	a2,75a <memset+0x1c>
 746:	87aa                	mv	a5,a0
 748:	1602                	sll	a2,a2,0x20
 74a:	9201                	srl	a2,a2,0x20
 74c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 750:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 754:	0785                	add	a5,a5,1
 756:	fee79de3          	bne	a5,a4,750 <memset+0x12>
  }
  return dst;
}
 75a:	6422                	ld	s0,8(sp)
 75c:	0141                	add	sp,sp,16
 75e:	8082                	ret

0000000000000760 <strchr>:

char*
strchr(const char *s, char c)
{
 760:	1141                	add	sp,sp,-16
 762:	e422                	sd	s0,8(sp)
 764:	0800                	add	s0,sp,16
  for(; *s; s++)
 766:	00054783          	lbu	a5,0(a0)
 76a:	cb99                	beqz	a5,780 <strchr+0x20>
    if(*s == c)
 76c:	00f58763          	beq	a1,a5,77a <strchr+0x1a>
  for(; *s; s++)
 770:	0505                	add	a0,a0,1
 772:	00054783          	lbu	a5,0(a0)
 776:	fbfd                	bnez	a5,76c <strchr+0xc>
      return (char*)s;
  return 0;
 778:	4501                	li	a0,0
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	add	sp,sp,16
 77e:	8082                	ret
  return 0;
 780:	4501                	li	a0,0
 782:	bfe5                	j	77a <strchr+0x1a>

0000000000000784 <gets>:

char*
gets(char *buf, int max)
{
 784:	711d                	add	sp,sp,-96
 786:	ec86                	sd	ra,88(sp)
 788:	e8a2                	sd	s0,80(sp)
 78a:	e4a6                	sd	s1,72(sp)
 78c:	e0ca                	sd	s2,64(sp)
 78e:	fc4e                	sd	s3,56(sp)
 790:	f852                	sd	s4,48(sp)
 792:	f456                	sd	s5,40(sp)
 794:	f05a                	sd	s6,32(sp)
 796:	ec5e                	sd	s7,24(sp)
 798:	1080                	add	s0,sp,96
 79a:	8baa                	mv	s7,a0
 79c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 79e:	892a                	mv	s2,a0
 7a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7a2:	4aa9                	li	s5,10
 7a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7a6:	89a6                	mv	s3,s1
 7a8:	2485                	addw	s1,s1,1
 7aa:	0344d863          	bge	s1,s4,7da <gets+0x56>
    cc = read(0, &c, 1);
 7ae:	4605                	li	a2,1
 7b0:	faf40593          	add	a1,s0,-81
 7b4:	4501                	li	a0,0
 7b6:	00000097          	auipc	ra,0x0
 7ba:	19a080e7          	jalr	410(ra) # 950 <read>
    if(cc < 1)
 7be:	00a05e63          	blez	a0,7da <gets+0x56>
    buf[i++] = c;
 7c2:	faf44783          	lbu	a5,-81(s0)
 7c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7ca:	01578763          	beq	a5,s5,7d8 <gets+0x54>
 7ce:	0905                	add	s2,s2,1
 7d0:	fd679be3          	bne	a5,s6,7a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 7d4:	89a6                	mv	s3,s1
 7d6:	a011                	j	7da <gets+0x56>
 7d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7da:	99de                	add	s3,s3,s7
 7dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 7e0:	855e                	mv	a0,s7
 7e2:	60e6                	ld	ra,88(sp)
 7e4:	6446                	ld	s0,80(sp)
 7e6:	64a6                	ld	s1,72(sp)
 7e8:	6906                	ld	s2,64(sp)
 7ea:	79e2                	ld	s3,56(sp)
 7ec:	7a42                	ld	s4,48(sp)
 7ee:	7aa2                	ld	s5,40(sp)
 7f0:	7b02                	ld	s6,32(sp)
 7f2:	6be2                	ld	s7,24(sp)
 7f4:	6125                	add	sp,sp,96
 7f6:	8082                	ret

00000000000007f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 7f8:	1101                	add	sp,sp,-32
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	e426                	sd	s1,8(sp)
 800:	e04a                	sd	s2,0(sp)
 802:	1000                	add	s0,sp,32
 804:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 806:	4581                	li	a1,0
 808:	00000097          	auipc	ra,0x0
 80c:	170080e7          	jalr	368(ra) # 978 <open>
  if(fd < 0)
 810:	02054563          	bltz	a0,83a <stat+0x42>
 814:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 816:	85ca                	mv	a1,s2
 818:	00000097          	auipc	ra,0x0
 81c:	178080e7          	jalr	376(ra) # 990 <fstat>
 820:	892a                	mv	s2,a0
  close(fd);
 822:	8526                	mv	a0,s1
 824:	00000097          	auipc	ra,0x0
 828:	13c080e7          	jalr	316(ra) # 960 <close>
  return r;
}
 82c:	854a                	mv	a0,s2
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	64a2                	ld	s1,8(sp)
 834:	6902                	ld	s2,0(sp)
 836:	6105                	add	sp,sp,32
 838:	8082                	ret
    return -1;
 83a:	597d                	li	s2,-1
 83c:	bfc5                	j	82c <stat+0x34>

000000000000083e <atoi>:

int
atoi(const char *s)
{
 83e:	1141                	add	sp,sp,-16
 840:	e422                	sd	s0,8(sp)
 842:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 844:	00054683          	lbu	a3,0(a0)
 848:	fd06879b          	addw	a5,a3,-48
 84c:	0ff7f793          	zext.b	a5,a5
 850:	4625                	li	a2,9
 852:	02f66863          	bltu	a2,a5,882 <atoi+0x44>
 856:	872a                	mv	a4,a0
  n = 0;
 858:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 85a:	0705                	add	a4,a4,1
 85c:	0025179b          	sllw	a5,a0,0x2
 860:	9fa9                	addw	a5,a5,a0
 862:	0017979b          	sllw	a5,a5,0x1
 866:	9fb5                	addw	a5,a5,a3
 868:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 86c:	00074683          	lbu	a3,0(a4)
 870:	fd06879b          	addw	a5,a3,-48
 874:	0ff7f793          	zext.b	a5,a5
 878:	fef671e3          	bgeu	a2,a5,85a <atoi+0x1c>
  return n;
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	add	sp,sp,16
 880:	8082                	ret
  n = 0;
 882:	4501                	li	a0,0
 884:	bfe5                	j	87c <atoi+0x3e>

0000000000000886 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 886:	1141                	add	sp,sp,-16
 888:	e422                	sd	s0,8(sp)
 88a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 88c:	02b57463          	bgeu	a0,a1,8b4 <memmove+0x2e>
    while(n-- > 0)
 890:	00c05f63          	blez	a2,8ae <memmove+0x28>
 894:	1602                	sll	a2,a2,0x20
 896:	9201                	srl	a2,a2,0x20
 898:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 89c:	872a                	mv	a4,a0
      *dst++ = *src++;
 89e:	0585                	add	a1,a1,1
 8a0:	0705                	add	a4,a4,1
 8a2:	fff5c683          	lbu	a3,-1(a1)
 8a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8aa:	fee79ae3          	bne	a5,a4,89e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8ae:	6422                	ld	s0,8(sp)
 8b0:	0141                	add	sp,sp,16
 8b2:	8082                	ret
    dst += n;
 8b4:	00c50733          	add	a4,a0,a2
    src += n;
 8b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8ba:	fec05ae3          	blez	a2,8ae <memmove+0x28>
 8be:	fff6079b          	addw	a5,a2,-1
 8c2:	1782                	sll	a5,a5,0x20
 8c4:	9381                	srl	a5,a5,0x20
 8c6:	fff7c793          	not	a5,a5
 8ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8cc:	15fd                	add	a1,a1,-1
 8ce:	177d                	add	a4,a4,-1
 8d0:	0005c683          	lbu	a3,0(a1)
 8d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8d8:	fee79ae3          	bne	a5,a4,8cc <memmove+0x46>
 8dc:	bfc9                	j	8ae <memmove+0x28>

00000000000008de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8de:	1141                	add	sp,sp,-16
 8e0:	e422                	sd	s0,8(sp)
 8e2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8e4:	ca05                	beqz	a2,914 <memcmp+0x36>
 8e6:	fff6069b          	addw	a3,a2,-1
 8ea:	1682                	sll	a3,a3,0x20
 8ec:	9281                	srl	a3,a3,0x20
 8ee:	0685                	add	a3,a3,1
 8f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8f2:	00054783          	lbu	a5,0(a0)
 8f6:	0005c703          	lbu	a4,0(a1)
 8fa:	00e79863          	bne	a5,a4,90a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8fe:	0505                	add	a0,a0,1
    p2++;
 900:	0585                	add	a1,a1,1
  while (n-- > 0) {
 902:	fed518e3          	bne	a0,a3,8f2 <memcmp+0x14>
  }
  return 0;
 906:	4501                	li	a0,0
 908:	a019                	j	90e <memcmp+0x30>
      return *p1 - *p2;
 90a:	40e7853b          	subw	a0,a5,a4
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	add	sp,sp,16
 912:	8082                	ret
  return 0;
 914:	4501                	li	a0,0
 916:	bfe5                	j	90e <memcmp+0x30>

0000000000000918 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 918:	1141                	add	sp,sp,-16
 91a:	e406                	sd	ra,8(sp)
 91c:	e022                	sd	s0,0(sp)
 91e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 920:	00000097          	auipc	ra,0x0
 924:	f66080e7          	jalr	-154(ra) # 886 <memmove>
}
 928:	60a2                	ld	ra,8(sp)
 92a:	6402                	ld	s0,0(sp)
 92c:	0141                	add	sp,sp,16
 92e:	8082                	ret

0000000000000930 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 930:	4885                	li	a7,1
 ecall
 932:	00000073          	ecall
 ret
 936:	8082                	ret

0000000000000938 <exit>:
.global exit
exit:
 li a7, SYS_exit
 938:	4889                	li	a7,2
 ecall
 93a:	00000073          	ecall
 ret
 93e:	8082                	ret

0000000000000940 <wait>:
.global wait
wait:
 li a7, SYS_wait
 940:	488d                	li	a7,3
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 948:	4891                	li	a7,4
 ecall
 94a:	00000073          	ecall
 ret
 94e:	8082                	ret

0000000000000950 <read>:
.global read
read:
 li a7, SYS_read
 950:	4895                	li	a7,5
 ecall
 952:	00000073          	ecall
 ret
 956:	8082                	ret

0000000000000958 <write>:
.global write
write:
 li a7, SYS_write
 958:	48c1                	li	a7,16
 ecall
 95a:	00000073          	ecall
 ret
 95e:	8082                	ret

0000000000000960 <close>:
.global close
close:
 li a7, SYS_close
 960:	48d5                	li	a7,21
 ecall
 962:	00000073          	ecall
 ret
 966:	8082                	ret

0000000000000968 <kill>:
.global kill
kill:
 li a7, SYS_kill
 968:	4899                	li	a7,6
 ecall
 96a:	00000073          	ecall
 ret
 96e:	8082                	ret

0000000000000970 <exec>:
.global exec
exec:
 li a7, SYS_exec
 970:	489d                	li	a7,7
 ecall
 972:	00000073          	ecall
 ret
 976:	8082                	ret

0000000000000978 <open>:
.global open
open:
 li a7, SYS_open
 978:	48bd                	li	a7,15
 ecall
 97a:	00000073          	ecall
 ret
 97e:	8082                	ret

0000000000000980 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 980:	48c5                	li	a7,17
 ecall
 982:	00000073          	ecall
 ret
 986:	8082                	ret

0000000000000988 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 988:	48c9                	li	a7,18
 ecall
 98a:	00000073          	ecall
 ret
 98e:	8082                	ret

0000000000000990 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 990:	48a1                	li	a7,8
 ecall
 992:	00000073          	ecall
 ret
 996:	8082                	ret

0000000000000998 <link>:
.global link
link:
 li a7, SYS_link
 998:	48cd                	li	a7,19
 ecall
 99a:	00000073          	ecall
 ret
 99e:	8082                	ret

00000000000009a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9a0:	48d1                	li	a7,20
 ecall
 9a2:	00000073          	ecall
 ret
 9a6:	8082                	ret

00000000000009a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9a8:	48a5                	li	a7,9
 ecall
 9aa:	00000073          	ecall
 ret
 9ae:	8082                	ret

00000000000009b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9b0:	48a9                	li	a7,10
 ecall
 9b2:	00000073          	ecall
 ret
 9b6:	8082                	ret

00000000000009b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9b8:	48ad                	li	a7,11
 ecall
 9ba:	00000073          	ecall
 ret
 9be:	8082                	ret

00000000000009c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9c0:	48b1                	li	a7,12
 ecall
 9c2:	00000073          	ecall
 ret
 9c6:	8082                	ret

00000000000009c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9c8:	48b5                	li	a7,13
 ecall
 9ca:	00000073          	ecall
 ret
 9ce:	8082                	ret

00000000000009d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9d0:	48b9                	li	a7,14
 ecall
 9d2:	00000073          	ecall
 ret
 9d6:	8082                	ret

00000000000009d8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9d8:	48d9                	li	a7,22
 ecall
 9da:	00000073          	ecall
 ret
 9de:	8082                	ret

00000000000009e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9e0:	1101                	add	sp,sp,-32
 9e2:	ec06                	sd	ra,24(sp)
 9e4:	e822                	sd	s0,16(sp)
 9e6:	1000                	add	s0,sp,32
 9e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9ec:	4605                	li	a2,1
 9ee:	fef40593          	add	a1,s0,-17
 9f2:	00000097          	auipc	ra,0x0
 9f6:	f66080e7          	jalr	-154(ra) # 958 <write>
}
 9fa:	60e2                	ld	ra,24(sp)
 9fc:	6442                	ld	s0,16(sp)
 9fe:	6105                	add	sp,sp,32
 a00:	8082                	ret

0000000000000a02 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a02:	7139                	add	sp,sp,-64
 a04:	fc06                	sd	ra,56(sp)
 a06:	f822                	sd	s0,48(sp)
 a08:	f426                	sd	s1,40(sp)
 a0a:	f04a                	sd	s2,32(sp)
 a0c:	ec4e                	sd	s3,24(sp)
 a0e:	0080                	add	s0,sp,64
 a10:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a12:	c299                	beqz	a3,a18 <printint+0x16>
 a14:	0805c963          	bltz	a1,aa6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a18:	2581                	sext.w	a1,a1
  neg = 0;
 a1a:	4881                	li	a7,0
 a1c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 a20:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a22:	2601                	sext.w	a2,a2
 a24:	00001517          	auipc	a0,0x1
 a28:	91c50513          	add	a0,a0,-1764 # 1340 <digits>
 a2c:	883a                	mv	a6,a4
 a2e:	2705                	addw	a4,a4,1
 a30:	02c5f7bb          	remuw	a5,a1,a2
 a34:	1782                	sll	a5,a5,0x20
 a36:	9381                	srl	a5,a5,0x20
 a38:	97aa                	add	a5,a5,a0
 a3a:	0007c783          	lbu	a5,0(a5)
 a3e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a42:	0005879b          	sext.w	a5,a1
 a46:	02c5d5bb          	divuw	a1,a1,a2
 a4a:	0685                	add	a3,a3,1
 a4c:	fec7f0e3          	bgeu	a5,a2,a2c <printint+0x2a>
  if(neg)
 a50:	00088c63          	beqz	a7,a68 <printint+0x66>
    buf[i++] = '-';
 a54:	fd070793          	add	a5,a4,-48
 a58:	00878733          	add	a4,a5,s0
 a5c:	02d00793          	li	a5,45
 a60:	fef70823          	sb	a5,-16(a4)
 a64:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 a68:	02e05863          	blez	a4,a98 <printint+0x96>
 a6c:	fc040793          	add	a5,s0,-64
 a70:	00e78933          	add	s2,a5,a4
 a74:	fff78993          	add	s3,a5,-1
 a78:	99ba                	add	s3,s3,a4
 a7a:	377d                	addw	a4,a4,-1
 a7c:	1702                	sll	a4,a4,0x20
 a7e:	9301                	srl	a4,a4,0x20
 a80:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a84:	fff94583          	lbu	a1,-1(s2)
 a88:	8526                	mv	a0,s1
 a8a:	00000097          	auipc	ra,0x0
 a8e:	f56080e7          	jalr	-170(ra) # 9e0 <putc>
  while(--i >= 0)
 a92:	197d                	add	s2,s2,-1
 a94:	ff3918e3          	bne	s2,s3,a84 <printint+0x82>
}
 a98:	70e2                	ld	ra,56(sp)
 a9a:	7442                	ld	s0,48(sp)
 a9c:	74a2                	ld	s1,40(sp)
 a9e:	7902                	ld	s2,32(sp)
 aa0:	69e2                	ld	s3,24(sp)
 aa2:	6121                	add	sp,sp,64
 aa4:	8082                	ret
    x = -xx;
 aa6:	40b005bb          	negw	a1,a1
    neg = 1;
 aaa:	4885                	li	a7,1
    x = -xx;
 aac:	bf85                	j	a1c <printint+0x1a>

0000000000000aae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 aae:	715d                	add	sp,sp,-80
 ab0:	e486                	sd	ra,72(sp)
 ab2:	e0a2                	sd	s0,64(sp)
 ab4:	fc26                	sd	s1,56(sp)
 ab6:	f84a                	sd	s2,48(sp)
 ab8:	f44e                	sd	s3,40(sp)
 aba:	f052                	sd	s4,32(sp)
 abc:	ec56                	sd	s5,24(sp)
 abe:	e85a                	sd	s6,16(sp)
 ac0:	e45e                	sd	s7,8(sp)
 ac2:	e062                	sd	s8,0(sp)
 ac4:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ac6:	0005c903          	lbu	s2,0(a1)
 aca:	18090c63          	beqz	s2,c62 <vprintf+0x1b4>
 ace:	8aaa                	mv	s5,a0
 ad0:	8bb2                	mv	s7,a2
 ad2:	00158493          	add	s1,a1,1
  state = 0;
 ad6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ad8:	02500a13          	li	s4,37
 adc:	4b55                	li	s6,21
 ade:	a839                	j	afc <vprintf+0x4e>
        putc(fd, c);
 ae0:	85ca                	mv	a1,s2
 ae2:	8556                	mv	a0,s5
 ae4:	00000097          	auipc	ra,0x0
 ae8:	efc080e7          	jalr	-260(ra) # 9e0 <putc>
 aec:	a019                	j	af2 <vprintf+0x44>
    } else if(state == '%'){
 aee:	01498d63          	beq	s3,s4,b08 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 af2:	0485                	add	s1,s1,1
 af4:	fff4c903          	lbu	s2,-1(s1)
 af8:	16090563          	beqz	s2,c62 <vprintf+0x1b4>
    if(state == 0){
 afc:	fe0999e3          	bnez	s3,aee <vprintf+0x40>
      if(c == '%'){
 b00:	ff4910e3          	bne	s2,s4,ae0 <vprintf+0x32>
        state = '%';
 b04:	89d2                	mv	s3,s4
 b06:	b7f5                	j	af2 <vprintf+0x44>
      if(c == 'd'){
 b08:	13490263          	beq	s2,s4,c2c <vprintf+0x17e>
 b0c:	f9d9079b          	addw	a5,s2,-99
 b10:	0ff7f793          	zext.b	a5,a5
 b14:	12fb6563          	bltu	s6,a5,c3e <vprintf+0x190>
 b18:	f9d9079b          	addw	a5,s2,-99
 b1c:	0ff7f713          	zext.b	a4,a5
 b20:	10eb6f63          	bltu	s6,a4,c3e <vprintf+0x190>
 b24:	00271793          	sll	a5,a4,0x2
 b28:	00000717          	auipc	a4,0x0
 b2c:	7c070713          	add	a4,a4,1984 # 12e8 <malloc+0x588>
 b30:	97ba                	add	a5,a5,a4
 b32:	439c                	lw	a5,0(a5)
 b34:	97ba                	add	a5,a5,a4
 b36:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b38:	008b8913          	add	s2,s7,8
 b3c:	4685                	li	a3,1
 b3e:	4629                	li	a2,10
 b40:	000ba583          	lw	a1,0(s7)
 b44:	8556                	mv	a0,s5
 b46:	00000097          	auipc	ra,0x0
 b4a:	ebc080e7          	jalr	-324(ra) # a02 <printint>
 b4e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b50:	4981                	li	s3,0
 b52:	b745                	j	af2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b54:	008b8913          	add	s2,s7,8
 b58:	4681                	li	a3,0
 b5a:	4629                	li	a2,10
 b5c:	000ba583          	lw	a1,0(s7)
 b60:	8556                	mv	a0,s5
 b62:	00000097          	auipc	ra,0x0
 b66:	ea0080e7          	jalr	-352(ra) # a02 <printint>
 b6a:	8bca                	mv	s7,s2
      state = 0;
 b6c:	4981                	li	s3,0
 b6e:	b751                	j	af2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 b70:	008b8913          	add	s2,s7,8
 b74:	4681                	li	a3,0
 b76:	4641                	li	a2,16
 b78:	000ba583          	lw	a1,0(s7)
 b7c:	8556                	mv	a0,s5
 b7e:	00000097          	auipc	ra,0x0
 b82:	e84080e7          	jalr	-380(ra) # a02 <printint>
 b86:	8bca                	mv	s7,s2
      state = 0;
 b88:	4981                	li	s3,0
 b8a:	b7a5                	j	af2 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 b8c:	008b8c13          	add	s8,s7,8
 b90:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b94:	03000593          	li	a1,48
 b98:	8556                	mv	a0,s5
 b9a:	00000097          	auipc	ra,0x0
 b9e:	e46080e7          	jalr	-442(ra) # 9e0 <putc>
  putc(fd, 'x');
 ba2:	07800593          	li	a1,120
 ba6:	8556                	mv	a0,s5
 ba8:	00000097          	auipc	ra,0x0
 bac:	e38080e7          	jalr	-456(ra) # 9e0 <putc>
 bb0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb2:	00000b97          	auipc	s7,0x0
 bb6:	78eb8b93          	add	s7,s7,1934 # 1340 <digits>
 bba:	03c9d793          	srl	a5,s3,0x3c
 bbe:	97de                	add	a5,a5,s7
 bc0:	0007c583          	lbu	a1,0(a5)
 bc4:	8556                	mv	a0,s5
 bc6:	00000097          	auipc	ra,0x0
 bca:	e1a080e7          	jalr	-486(ra) # 9e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bce:	0992                	sll	s3,s3,0x4
 bd0:	397d                	addw	s2,s2,-1
 bd2:	fe0914e3          	bnez	s2,bba <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 bd6:	8be2                	mv	s7,s8
      state = 0;
 bd8:	4981                	li	s3,0
 bda:	bf21                	j	af2 <vprintf+0x44>
        s = va_arg(ap, char*);
 bdc:	008b8993          	add	s3,s7,8
 be0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 be4:	02090163          	beqz	s2,c06 <vprintf+0x158>
        while(*s != 0){
 be8:	00094583          	lbu	a1,0(s2)
 bec:	c9a5                	beqz	a1,c5c <vprintf+0x1ae>
          putc(fd, *s);
 bee:	8556                	mv	a0,s5
 bf0:	00000097          	auipc	ra,0x0
 bf4:	df0080e7          	jalr	-528(ra) # 9e0 <putc>
          s++;
 bf8:	0905                	add	s2,s2,1
        while(*s != 0){
 bfa:	00094583          	lbu	a1,0(s2)
 bfe:	f9e5                	bnez	a1,bee <vprintf+0x140>
        s = va_arg(ap, char*);
 c00:	8bce                	mv	s7,s3
      state = 0;
 c02:	4981                	li	s3,0
 c04:	b5fd                	j	af2 <vprintf+0x44>
          s = "(null)";
 c06:	00000917          	auipc	s2,0x0
 c0a:	6da90913          	add	s2,s2,1754 # 12e0 <malloc+0x580>
        while(*s != 0){
 c0e:	02800593          	li	a1,40
 c12:	bff1                	j	bee <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 c14:	008b8913          	add	s2,s7,8
 c18:	000bc583          	lbu	a1,0(s7)
 c1c:	8556                	mv	a0,s5
 c1e:	00000097          	auipc	ra,0x0
 c22:	dc2080e7          	jalr	-574(ra) # 9e0 <putc>
 c26:	8bca                	mv	s7,s2
      state = 0;
 c28:	4981                	li	s3,0
 c2a:	b5e1                	j	af2 <vprintf+0x44>
        putc(fd, c);
 c2c:	02500593          	li	a1,37
 c30:	8556                	mv	a0,s5
 c32:	00000097          	auipc	ra,0x0
 c36:	dae080e7          	jalr	-594(ra) # 9e0 <putc>
      state = 0;
 c3a:	4981                	li	s3,0
 c3c:	bd5d                	j	af2 <vprintf+0x44>
        putc(fd, '%');
 c3e:	02500593          	li	a1,37
 c42:	8556                	mv	a0,s5
 c44:	00000097          	auipc	ra,0x0
 c48:	d9c080e7          	jalr	-612(ra) # 9e0 <putc>
        putc(fd, c);
 c4c:	85ca                	mv	a1,s2
 c4e:	8556                	mv	a0,s5
 c50:	00000097          	auipc	ra,0x0
 c54:	d90080e7          	jalr	-624(ra) # 9e0 <putc>
      state = 0;
 c58:	4981                	li	s3,0
 c5a:	bd61                	j	af2 <vprintf+0x44>
        s = va_arg(ap, char*);
 c5c:	8bce                	mv	s7,s3
      state = 0;
 c5e:	4981                	li	s3,0
 c60:	bd49                	j	af2 <vprintf+0x44>
    }
  }
}
 c62:	60a6                	ld	ra,72(sp)
 c64:	6406                	ld	s0,64(sp)
 c66:	74e2                	ld	s1,56(sp)
 c68:	7942                	ld	s2,48(sp)
 c6a:	79a2                	ld	s3,40(sp)
 c6c:	7a02                	ld	s4,32(sp)
 c6e:	6ae2                	ld	s5,24(sp)
 c70:	6b42                	ld	s6,16(sp)
 c72:	6ba2                	ld	s7,8(sp)
 c74:	6c02                	ld	s8,0(sp)
 c76:	6161                	add	sp,sp,80
 c78:	8082                	ret

0000000000000c7a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c7a:	715d                	add	sp,sp,-80
 c7c:	ec06                	sd	ra,24(sp)
 c7e:	e822                	sd	s0,16(sp)
 c80:	1000                	add	s0,sp,32
 c82:	e010                	sd	a2,0(s0)
 c84:	e414                	sd	a3,8(s0)
 c86:	e818                	sd	a4,16(s0)
 c88:	ec1c                	sd	a5,24(s0)
 c8a:	03043023          	sd	a6,32(s0)
 c8e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c92:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c96:	8622                	mv	a2,s0
 c98:	00000097          	auipc	ra,0x0
 c9c:	e16080e7          	jalr	-490(ra) # aae <vprintf>
}
 ca0:	60e2                	ld	ra,24(sp)
 ca2:	6442                	ld	s0,16(sp)
 ca4:	6161                	add	sp,sp,80
 ca6:	8082                	ret

0000000000000ca8 <printf>:

void
printf(const char *fmt, ...)
{
 ca8:	711d                	add	sp,sp,-96
 caa:	ec06                	sd	ra,24(sp)
 cac:	e822                	sd	s0,16(sp)
 cae:	1000                	add	s0,sp,32
 cb0:	e40c                	sd	a1,8(s0)
 cb2:	e810                	sd	a2,16(s0)
 cb4:	ec14                	sd	a3,24(s0)
 cb6:	f018                	sd	a4,32(s0)
 cb8:	f41c                	sd	a5,40(s0)
 cba:	03043823          	sd	a6,48(s0)
 cbe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc2:	00840613          	add	a2,s0,8
 cc6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cca:	85aa                	mv	a1,a0
 ccc:	4505                	li	a0,1
 cce:	00000097          	auipc	ra,0x0
 cd2:	de0080e7          	jalr	-544(ra) # aae <vprintf>
}
 cd6:	60e2                	ld	ra,24(sp)
 cd8:	6442                	ld	s0,16(sp)
 cda:	6125                	add	sp,sp,96
 cdc:	8082                	ret

0000000000000cde <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cde:	1141                	add	sp,sp,-16
 ce0:	e422                	sd	s0,8(sp)
 ce2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ce4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ce8:	00000797          	auipc	a5,0x0
 cec:	6787b783          	ld	a5,1656(a5) # 1360 <freep>
 cf0:	a02d                	j	d1a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cf2:	4618                	lw	a4,8(a2)
 cf4:	9f2d                	addw	a4,a4,a1
 cf6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cfa:	6398                	ld	a4,0(a5)
 cfc:	6310                	ld	a2,0(a4)
 cfe:	a83d                	j	d3c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d00:	ff852703          	lw	a4,-8(a0)
 d04:	9f31                	addw	a4,a4,a2
 d06:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d08:	ff053683          	ld	a3,-16(a0)
 d0c:	a091                	j	d50 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d0e:	6398                	ld	a4,0(a5)
 d10:	00e7e463          	bltu	a5,a4,d18 <free+0x3a>
 d14:	00e6ea63          	bltu	a3,a4,d28 <free+0x4a>
{
 d18:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d1a:	fed7fae3          	bgeu	a5,a3,d0e <free+0x30>
 d1e:	6398                	ld	a4,0(a5)
 d20:	00e6e463          	bltu	a3,a4,d28 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d24:	fee7eae3          	bltu	a5,a4,d18 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d28:	ff852583          	lw	a1,-8(a0)
 d2c:	6390                	ld	a2,0(a5)
 d2e:	02059813          	sll	a6,a1,0x20
 d32:	01c85713          	srl	a4,a6,0x1c
 d36:	9736                	add	a4,a4,a3
 d38:	fae60de3          	beq	a2,a4,cf2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d3c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d40:	4790                	lw	a2,8(a5)
 d42:	02061593          	sll	a1,a2,0x20
 d46:	01c5d713          	srl	a4,a1,0x1c
 d4a:	973e                	add	a4,a4,a5
 d4c:	fae68ae3          	beq	a3,a4,d00 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d50:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d52:	00000717          	auipc	a4,0x0
 d56:	60f73723          	sd	a5,1550(a4) # 1360 <freep>
}
 d5a:	6422                	ld	s0,8(sp)
 d5c:	0141                	add	sp,sp,16
 d5e:	8082                	ret

0000000000000d60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d60:	7139                	add	sp,sp,-64
 d62:	fc06                	sd	ra,56(sp)
 d64:	f822                	sd	s0,48(sp)
 d66:	f426                	sd	s1,40(sp)
 d68:	f04a                	sd	s2,32(sp)
 d6a:	ec4e                	sd	s3,24(sp)
 d6c:	e852                	sd	s4,16(sp)
 d6e:	e456                	sd	s5,8(sp)
 d70:	e05a                	sd	s6,0(sp)
 d72:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d74:	02051493          	sll	s1,a0,0x20
 d78:	9081                	srl	s1,s1,0x20
 d7a:	04bd                	add	s1,s1,15
 d7c:	8091                	srl	s1,s1,0x4
 d7e:	0014899b          	addw	s3,s1,1
 d82:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 d84:	00000517          	auipc	a0,0x0
 d88:	5dc53503          	ld	a0,1500(a0) # 1360 <freep>
 d8c:	c515                	beqz	a0,db8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d90:	4798                	lw	a4,8(a5)
 d92:	02977f63          	bgeu	a4,s1,dd0 <malloc+0x70>
  if(nu < 4096)
 d96:	8a4e                	mv	s4,s3
 d98:	0009871b          	sext.w	a4,s3
 d9c:	6685                	lui	a3,0x1
 d9e:	00d77363          	bgeu	a4,a3,da4 <malloc+0x44>
 da2:	6a05                	lui	s4,0x1
 da4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 da8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dac:	00000917          	auipc	s2,0x0
 db0:	5b490913          	add	s2,s2,1460 # 1360 <freep>
  if(p == (char*)-1)
 db4:	5afd                	li	s5,-1
 db6:	a895                	j	e2a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 db8:	00000797          	auipc	a5,0x0
 dbc:	5b078793          	add	a5,a5,1456 # 1368 <base>
 dc0:	00000717          	auipc	a4,0x0
 dc4:	5af73023          	sd	a5,1440(a4) # 1360 <freep>
 dc8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dce:	b7e1                	j	d96 <malloc+0x36>
      if(p->s.size == nunits)
 dd0:	02e48c63          	beq	s1,a4,e08 <malloc+0xa8>
        p->s.size -= nunits;
 dd4:	4137073b          	subw	a4,a4,s3
 dd8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dda:	02071693          	sll	a3,a4,0x20
 dde:	01c6d713          	srl	a4,a3,0x1c
 de2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 de4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 de8:	00000717          	auipc	a4,0x0
 dec:	56a73c23          	sd	a0,1400(a4) # 1360 <freep>
      return (void*)(p + 1);
 df0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 df4:	70e2                	ld	ra,56(sp)
 df6:	7442                	ld	s0,48(sp)
 df8:	74a2                	ld	s1,40(sp)
 dfa:	7902                	ld	s2,32(sp)
 dfc:	69e2                	ld	s3,24(sp)
 dfe:	6a42                	ld	s4,16(sp)
 e00:	6aa2                	ld	s5,8(sp)
 e02:	6b02                	ld	s6,0(sp)
 e04:	6121                	add	sp,sp,64
 e06:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e08:	6398                	ld	a4,0(a5)
 e0a:	e118                	sd	a4,0(a0)
 e0c:	bff1                	j	de8 <malloc+0x88>
  hp->s.size = nu;
 e0e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e12:	0541                	add	a0,a0,16
 e14:	00000097          	auipc	ra,0x0
 e18:	eca080e7          	jalr	-310(ra) # cde <free>
  return freep;
 e1c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e20:	d971                	beqz	a0,df4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e24:	4798                	lw	a4,8(a5)
 e26:	fa9775e3          	bgeu	a4,s1,dd0 <malloc+0x70>
    if(p == freep)
 e2a:	00093703          	ld	a4,0(s2)
 e2e:	853e                	mv	a0,a5
 e30:	fef719e3          	bne	a4,a5,e22 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e34:	8552                	mv	a0,s4
 e36:	00000097          	auipc	ra,0x0
 e3a:	b8a080e7          	jalr	-1142(ra) # 9c0 <sbrk>
  if(p == (char*)-1)
 e3e:	fd5518e3          	bne	a0,s5,e0e <malloc+0xae>
        return 0;
 e42:	4501                	li	a0,0
 e44:	bf45                	j	df4 <malloc+0x94>
