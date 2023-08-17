
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	4e0080e7          	jalr	1248(ra) # 54f0 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	4ce080e7          	jalr	1230(ra) # 54f0 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	97a50513          	add	a0,a0,-1670 # 59b8 <malloc+0xe8>
      46:	00005097          	auipc	ra,0x5
      4a:	7d2080e7          	jalr	2002(ra) # 5818 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	460080e7          	jalr	1120(ra) # 54b0 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	1e878793          	add	a5,a5,488 # 9240 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	8f068693          	add	a3,a3,-1808 # b950 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	95850513          	add	a0,a0,-1704 # 59d8 <malloc+0x108>
      88:	00005097          	auipc	ra,0x5
      8c:	790080e7          	jalr	1936(ra) # 5818 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	41e080e7          	jalr	1054(ra) # 54b0 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	94850513          	add	a0,a0,-1720 # 59f0 <malloc+0x120>
      b0:	00005097          	auipc	ra,0x5
      b4:	440080e7          	jalr	1088(ra) # 54f0 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	41c080e7          	jalr	1052(ra) # 54d8 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	94a50513          	add	a0,a0,-1718 # 5a10 <malloc+0x140>
      ce:	00005097          	auipc	ra,0x5
      d2:	422080e7          	jalr	1058(ra) # 54f0 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	91250513          	add	a0,a0,-1774 # 59f8 <malloc+0x128>
      ee:	00005097          	auipc	ra,0x5
      f2:	72a080e7          	jalr	1834(ra) # 5818 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	3b8080e7          	jalr	952(ra) # 54b0 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	91e50513          	add	a0,a0,-1762 # 5a20 <malloc+0x150>
     10a:	00005097          	auipc	ra,0x5
     10e:	70e080e7          	jalr	1806(ra) # 5818 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	39c080e7          	jalr	924(ra) # 54b0 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	91c50513          	add	a0,a0,-1764 # 5a48 <malloc+0x178>
     134:	00005097          	auipc	ra,0x5
     138:	3cc080e7          	jalr	972(ra) # 5500 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	90850513          	add	a0,a0,-1784 # 5a48 <malloc+0x178>
     148:	00005097          	auipc	ra,0x5
     14c:	3a8080e7          	jalr	936(ra) # 54f0 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	90458593          	add	a1,a1,-1788 # 5a58 <malloc+0x188>
     15c:	00005097          	auipc	ra,0x5
     160:	374080e7          	jalr	884(ra) # 54d0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	8e050513          	add	a0,a0,-1824 # 5a48 <malloc+0x178>
     170:	00005097          	auipc	ra,0x5
     174:	380080e7          	jalr	896(ra) # 54f0 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	8e458593          	add	a1,a1,-1820 # 5a60 <malloc+0x190>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	34a080e7          	jalr	842(ra) # 54d0 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	8b450513          	add	a0,a0,-1868 # 5a48 <malloc+0x178>
     19c:	00005097          	auipc	ra,0x5
     1a0:	364080e7          	jalr	868(ra) # 5500 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	332080e7          	jalr	818(ra) # 54d8 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	328080e7          	jalr	808(ra) # 54d8 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	89e50513          	add	a0,a0,-1890 # 5a68 <malloc+0x198>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	646080e7          	jalr	1606(ra) # 5818 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	2d4080e7          	jalr	724(ra) # 54b0 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	f3678793          	add	a5,a5,-202 # 8128 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	2d6080e7          	jalr	726(ra) # 54f0 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	2b6080e7          	jalr	694(ra) # 54d8 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addw	s1,s1,1
     22c:	0ff4f493          	zext.b	s1,s1
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	ef478793          	add	a5,a5,-268 # 8128 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	2a8080e7          	jalr	680(ra) # 5500 <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addw	s1,s1,1
     262:	0ff4f493          	zext.b	s1,s1
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	add	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	add	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	add	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00006517          	auipc	a0,0x6
     294:	80050513          	add	a0,a0,-2048 # 5a90 <malloc+0x1c0>
     298:	00005097          	auipc	ra,0x5
     29c:	268080e7          	jalr	616(ra) # 5500 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	7eca8a93          	add	s5,s5,2028 # 5a90 <malloc+0x1c0>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	6a4a0a13          	add	s4,s4,1700 # b950 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	add	s6,s6,457 # 31c9 <subdir+0x2af>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	230080e7          	jalr	560(ra) # 54f0 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	1fe080e7          	jalr	510(ra) # 54d0 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49263          	bne	s1,a0,340 <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	1ea080e7          	jalr	490(ra) # 54d0 <write>
      if(cc != sz){
     2ee:	04951a63          	bne	a0,s1,342 <bigwrite+0xca>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	1e4080e7          	jalr	484(ra) # 54d8 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	202080e7          	jalr	514(ra) # 5500 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	add	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00005517          	auipc	a0,0x5
     32a:	77a50513          	add	a0,a0,1914 # 5aa0 <malloc+0x1d0>
     32e:	00005097          	auipc	ra,0x5
     332:	4ea080e7          	jalr	1258(ra) # 5818 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	178080e7          	jalr	376(ra) # 54b0 <exit>
      if(cc != sz){
     340:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86aa                	mv	a3,a0
     344:	864e                	mv	a2,s3
     346:	85de                	mv	a1,s7
     348:	00005517          	auipc	a0,0x5
     34c:	77850513          	add	a0,a0,1912 # 5ac0 <malloc+0x1f0>
     350:	00005097          	auipc	ra,0x5
     354:	4c8080e7          	jalr	1224(ra) # 5818 <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00005097          	auipc	ra,0x5
     35e:	156080e7          	jalr	342(ra) # 54b0 <exit>

0000000000000362 <copyin>:
{
     362:	715d                	add	sp,sp,-80
     364:	e486                	sd	ra,72(sp)
     366:	e0a2                	sd	s0,64(sp)
     368:	fc26                	sd	s1,56(sp)
     36a:	f84a                	sd	s2,48(sp)
     36c:	f44e                	sd	s3,40(sp)
     36e:	f052                	sd	s4,32(sp)
     370:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     372:	4785                	li	a5,1
     374:	07fe                	sll	a5,a5,0x1f
     376:	fcf43023          	sd	a5,-64(s0)
     37a:	57fd                	li	a5,-1
     37c:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     380:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     384:	00005a17          	auipc	s4,0x5
     388:	754a0a13          	add	s4,s4,1876 # 5ad8 <malloc+0x208>
    uint64 addr = addrs[ai];
     38c:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     390:	20100593          	li	a1,513
     394:	8552                	mv	a0,s4
     396:	00005097          	auipc	ra,0x5
     39a:	15a080e7          	jalr	346(ra) # 54f0 <open>
     39e:	84aa                	mv	s1,a0
    if(fd < 0){
     3a0:	08054863          	bltz	a0,430 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a4:	6609                	lui	a2,0x2
     3a6:	85ce                	mv	a1,s3
     3a8:	00005097          	auipc	ra,0x5
     3ac:	128080e7          	jalr	296(ra) # 54d0 <write>
    if(n >= 0){
     3b0:	08055d63          	bgez	a0,44a <copyin+0xe8>
    close(fd);
     3b4:	8526                	mv	a0,s1
     3b6:	00005097          	auipc	ra,0x5
     3ba:	122080e7          	jalr	290(ra) # 54d8 <close>
    unlink("copyin1");
     3be:	8552                	mv	a0,s4
     3c0:	00005097          	auipc	ra,0x5
     3c4:	140080e7          	jalr	320(ra) # 5500 <unlink>
    n = write(1, (char*)addr, 8192);
     3c8:	6609                	lui	a2,0x2
     3ca:	85ce                	mv	a1,s3
     3cc:	4505                	li	a0,1
     3ce:	00005097          	auipc	ra,0x5
     3d2:	102080e7          	jalr	258(ra) # 54d0 <write>
    if(n > 0){
     3d6:	08a04963          	bgtz	a0,468 <copyin+0x106>
    if(pipe(fds) < 0){
     3da:	fb840513          	add	a0,s0,-72
     3de:	00005097          	auipc	ra,0x5
     3e2:	0e2080e7          	jalr	226(ra) # 54c0 <pipe>
     3e6:	0a054063          	bltz	a0,486 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ea:	6609                	lui	a2,0x2
     3ec:	85ce                	mv	a1,s3
     3ee:	fbc42503          	lw	a0,-68(s0)
     3f2:	00005097          	auipc	ra,0x5
     3f6:	0de080e7          	jalr	222(ra) # 54d0 <write>
    if(n > 0){
     3fa:	0aa04363          	bgtz	a0,4a0 <copyin+0x13e>
    close(fds[0]);
     3fe:	fb842503          	lw	a0,-72(s0)
     402:	00005097          	auipc	ra,0x5
     406:	0d6080e7          	jalr	214(ra) # 54d8 <close>
    close(fds[1]);
     40a:	fbc42503          	lw	a0,-68(s0)
     40e:	00005097          	auipc	ra,0x5
     412:	0ca080e7          	jalr	202(ra) # 54d8 <close>
  for(int ai = 0; ai < 2; ai++){
     416:	0921                	add	s2,s2,8
     418:	fd040793          	add	a5,s0,-48
     41c:	f6f918e3          	bne	s2,a5,38c <copyin+0x2a>
}
     420:	60a6                	ld	ra,72(sp)
     422:	6406                	ld	s0,64(sp)
     424:	74e2                	ld	s1,56(sp)
     426:	7942                	ld	s2,48(sp)
     428:	79a2                	ld	s3,40(sp)
     42a:	7a02                	ld	s4,32(sp)
     42c:	6161                	add	sp,sp,80
     42e:	8082                	ret
      printf("open(copyin1) failed\n");
     430:	00005517          	auipc	a0,0x5
     434:	6b050513          	add	a0,a0,1712 # 5ae0 <malloc+0x210>
     438:	00005097          	auipc	ra,0x5
     43c:	3e0080e7          	jalr	992(ra) # 5818 <printf>
      exit(1);
     440:	4505                	li	a0,1
     442:	00005097          	auipc	ra,0x5
     446:	06e080e7          	jalr	110(ra) # 54b0 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44a:	862a                	mv	a2,a0
     44c:	85ce                	mv	a1,s3
     44e:	00005517          	auipc	a0,0x5
     452:	6aa50513          	add	a0,a0,1706 # 5af8 <malloc+0x228>
     456:	00005097          	auipc	ra,0x5
     45a:	3c2080e7          	jalr	962(ra) # 5818 <printf>
      exit(1);
     45e:	4505                	li	a0,1
     460:	00005097          	auipc	ra,0x5
     464:	050080e7          	jalr	80(ra) # 54b0 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     468:	862a                	mv	a2,a0
     46a:	85ce                	mv	a1,s3
     46c:	00005517          	auipc	a0,0x5
     470:	6bc50513          	add	a0,a0,1724 # 5b28 <malloc+0x258>
     474:	00005097          	auipc	ra,0x5
     478:	3a4080e7          	jalr	932(ra) # 5818 <printf>
      exit(1);
     47c:	4505                	li	a0,1
     47e:	00005097          	auipc	ra,0x5
     482:	032080e7          	jalr	50(ra) # 54b0 <exit>
      printf("pipe() failed\n");
     486:	00005517          	auipc	a0,0x5
     48a:	6d250513          	add	a0,a0,1746 # 5b58 <malloc+0x288>
     48e:	00005097          	auipc	ra,0x5
     492:	38a080e7          	jalr	906(ra) # 5818 <printf>
      exit(1);
     496:	4505                	li	a0,1
     498:	00005097          	auipc	ra,0x5
     49c:	018080e7          	jalr	24(ra) # 54b0 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a0:	862a                	mv	a2,a0
     4a2:	85ce                	mv	a1,s3
     4a4:	00005517          	auipc	a0,0x5
     4a8:	6c450513          	add	a0,a0,1732 # 5b68 <malloc+0x298>
     4ac:	00005097          	auipc	ra,0x5
     4b0:	36c080e7          	jalr	876(ra) # 5818 <printf>
      exit(1);
     4b4:	4505                	li	a0,1
     4b6:	00005097          	auipc	ra,0x5
     4ba:	ffa080e7          	jalr	-6(ra) # 54b0 <exit>

00000000000004be <copyout>:
{
     4be:	711d                	add	sp,sp,-96
     4c0:	ec86                	sd	ra,88(sp)
     4c2:	e8a2                	sd	s0,80(sp)
     4c4:	e4a6                	sd	s1,72(sp)
     4c6:	e0ca                	sd	s2,64(sp)
     4c8:	fc4e                	sd	s3,56(sp)
     4ca:	f852                	sd	s4,48(sp)
     4cc:	f456                	sd	s5,40(sp)
     4ce:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d0:	4785                	li	a5,1
     4d2:	07fe                	sll	a5,a5,0x1f
     4d4:	faf43823          	sd	a5,-80(s0)
     4d8:	57fd                	li	a5,-1
     4da:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4de:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     4e2:	00005a17          	auipc	s4,0x5
     4e6:	6b6a0a13          	add	s4,s4,1718 # 5b98 <malloc+0x2c8>
    n = write(fds[1], "x", 1);
     4ea:	00005a97          	auipc	s5,0x5
     4ee:	576a8a93          	add	s5,s5,1398 # 5a60 <malloc+0x190>
    uint64 addr = addrs[ai];
     4f2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f6:	4581                	li	a1,0
     4f8:	8552                	mv	a0,s4
     4fa:	00005097          	auipc	ra,0x5
     4fe:	ff6080e7          	jalr	-10(ra) # 54f0 <open>
     502:	84aa                	mv	s1,a0
    if(fd < 0){
     504:	08054663          	bltz	a0,590 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     508:	6609                	lui	a2,0x2
     50a:	85ce                	mv	a1,s3
     50c:	00005097          	auipc	ra,0x5
     510:	fbc080e7          	jalr	-68(ra) # 54c8 <read>
    if(n > 0){
     514:	08a04b63          	bgtz	a0,5aa <copyout+0xec>
    close(fd);
     518:	8526                	mv	a0,s1
     51a:	00005097          	auipc	ra,0x5
     51e:	fbe080e7          	jalr	-66(ra) # 54d8 <close>
    if(pipe(fds) < 0){
     522:	fa840513          	add	a0,s0,-88
     526:	00005097          	auipc	ra,0x5
     52a:	f9a080e7          	jalr	-102(ra) # 54c0 <pipe>
     52e:	08054d63          	bltz	a0,5c8 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     532:	4605                	li	a2,1
     534:	85d6                	mv	a1,s5
     536:	fac42503          	lw	a0,-84(s0)
     53a:	00005097          	auipc	ra,0x5
     53e:	f96080e7          	jalr	-106(ra) # 54d0 <write>
    if(n != 1){
     542:	4785                	li	a5,1
     544:	08f51f63          	bne	a0,a5,5e2 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     548:	6609                	lui	a2,0x2
     54a:	85ce                	mv	a1,s3
     54c:	fa842503          	lw	a0,-88(s0)
     550:	00005097          	auipc	ra,0x5
     554:	f78080e7          	jalr	-136(ra) # 54c8 <read>
    if(n > 0){
     558:	0aa04263          	bgtz	a0,5fc <copyout+0x13e>
    close(fds[0]);
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00005097          	auipc	ra,0x5
     564:	f78080e7          	jalr	-136(ra) # 54d8 <close>
    close(fds[1]);
     568:	fac42503          	lw	a0,-84(s0)
     56c:	00005097          	auipc	ra,0x5
     570:	f6c080e7          	jalr	-148(ra) # 54d8 <close>
  for(int ai = 0; ai < 2; ai++){
     574:	0921                	add	s2,s2,8
     576:	fc040793          	add	a5,s0,-64
     57a:	f6f91ce3          	bne	s2,a5,4f2 <copyout+0x34>
}
     57e:	60e6                	ld	ra,88(sp)
     580:	6446                	ld	s0,80(sp)
     582:	64a6                	ld	s1,72(sp)
     584:	6906                	ld	s2,64(sp)
     586:	79e2                	ld	s3,56(sp)
     588:	7a42                	ld	s4,48(sp)
     58a:	7aa2                	ld	s5,40(sp)
     58c:	6125                	add	sp,sp,96
     58e:	8082                	ret
      printf("open(README) failed\n");
     590:	00005517          	auipc	a0,0x5
     594:	61050513          	add	a0,a0,1552 # 5ba0 <malloc+0x2d0>
     598:	00005097          	auipc	ra,0x5
     59c:	280080e7          	jalr	640(ra) # 5818 <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	f0e080e7          	jalr	-242(ra) # 54b0 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00005517          	auipc	a0,0x5
     5b2:	60a50513          	add	a0,a0,1546 # 5bb8 <malloc+0x2e8>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	262080e7          	jalr	610(ra) # 5818 <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	ef0080e7          	jalr	-272(ra) # 54b0 <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	59050513          	add	a0,a0,1424 # 5b58 <malloc+0x288>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	248080e7          	jalr	584(ra) # 5818 <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	ed6080e7          	jalr	-298(ra) # 54b0 <exit>
      printf("pipe write failed\n");
     5e2:	00005517          	auipc	a0,0x5
     5e6:	60650513          	add	a0,a0,1542 # 5be8 <malloc+0x318>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	22e080e7          	jalr	558(ra) # 5818 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	ebc080e7          	jalr	-324(ra) # 54b0 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00005517          	auipc	a0,0x5
     604:	60050513          	add	a0,a0,1536 # 5c00 <malloc+0x330>
     608:	00005097          	auipc	ra,0x5
     60c:	210080e7          	jalr	528(ra) # 5818 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	e9e080e7          	jalr	-354(ra) # 54b0 <exit>

000000000000061a <truncate1>:
{
     61a:	711d                	add	sp,sp,-96
     61c:	ec86                	sd	ra,88(sp)
     61e:	e8a2                	sd	s0,80(sp)
     620:	e4a6                	sd	s1,72(sp)
     622:	e0ca                	sd	s2,64(sp)
     624:	fc4e                	sd	s3,56(sp)
     626:	f852                	sd	s4,48(sp)
     628:	f456                	sd	s5,40(sp)
     62a:	1080                	add	s0,sp,96
     62c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     62e:	00005517          	auipc	a0,0x5
     632:	41a50513          	add	a0,a0,1050 # 5a48 <malloc+0x178>
     636:	00005097          	auipc	ra,0x5
     63a:	eca080e7          	jalr	-310(ra) # 5500 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00005517          	auipc	a0,0x5
     646:	40650513          	add	a0,a0,1030 # 5a48 <malloc+0x178>
     64a:	00005097          	auipc	ra,0x5
     64e:	ea6080e7          	jalr	-346(ra) # 54f0 <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00005597          	auipc	a1,0x5
     65a:	40258593          	add	a1,a1,1026 # 5a58 <malloc+0x188>
     65e:	00005097          	auipc	ra,0x5
     662:	e72080e7          	jalr	-398(ra) # 54d0 <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	e70080e7          	jalr	-400(ra) # 54d8 <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00005517          	auipc	a0,0x5
     676:	3d650513          	add	a0,a0,982 # 5a48 <malloc+0x178>
     67a:	00005097          	auipc	ra,0x5
     67e:	e76080e7          	jalr	-394(ra) # 54f0 <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	add	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	e3c080e7          	jalr	-452(ra) # 54c8 <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00005517          	auipc	a0,0x5
     6a2:	3aa50513          	add	a0,a0,938 # 5a48 <malloc+0x178>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	e4a080e7          	jalr	-438(ra) # 54f0 <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00005517          	auipc	a0,0x5
     6b6:	39650513          	add	a0,a0,918 # 5a48 <malloc+0x178>
     6ba:	00005097          	auipc	ra,0x5
     6be:	e36080e7          	jalr	-458(ra) # 54f0 <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	add	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	dfc080e7          	jalr	-516(ra) # 54c8 <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	add	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	de6080e7          	jalr	-538(ra) # 54c8 <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00005597          	auipc	a1,0x5
     6f4:	5a058593          	add	a1,a1,1440 # 5c90 <malloc+0x3c0>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	dd6080e7          	jalr	-554(ra) # 54d0 <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	add	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	dbc080e7          	jalr	-580(ra) # 54c8 <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	add	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	da4080e7          	jalr	-604(ra) # 54c8 <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00005517          	auipc	a0,0x5
     736:	31650513          	add	a0,a0,790 # 5a48 <malloc+0x178>
     73a:	00005097          	auipc	ra,0x5
     73e:	dc6080e7          	jalr	-570(ra) # 5500 <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	d94080e7          	jalr	-620(ra) # 54d8 <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	d8a080e7          	jalr	-630(ra) # 54d8 <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	d80080e7          	jalr	-640(ra) # 54d8 <close>
}
     760:	60e6                	ld	ra,88(sp)
     762:	6446                	ld	s0,80(sp)
     764:	64a6                	ld	s1,72(sp)
     766:	6906                	ld	s2,64(sp)
     768:	79e2                	ld	s3,56(sp)
     76a:	7a42                	ld	s4,48(sp)
     76c:	7aa2                	ld	s5,40(sp)
     76e:	6125                	add	sp,sp,96
     770:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     772:	862a                	mv	a2,a0
     774:	85d6                	mv	a1,s5
     776:	00005517          	auipc	a0,0x5
     77a:	4ba50513          	add	a0,a0,1210 # 5c30 <malloc+0x360>
     77e:	00005097          	auipc	ra,0x5
     782:	09a080e7          	jalr	154(ra) # 5818 <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	d28080e7          	jalr	-728(ra) # 54b0 <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00005517          	auipc	a0,0x5
     796:	4be50513          	add	a0,a0,1214 # 5c50 <malloc+0x380>
     79a:	00005097          	auipc	ra,0x5
     79e:	07e080e7          	jalr	126(ra) # 5818 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00005517          	auipc	a0,0x5
     7aa:	4ba50513          	add	a0,a0,1210 # 5c60 <malloc+0x390>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	06a080e7          	jalr	106(ra) # 5818 <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	cf8080e7          	jalr	-776(ra) # 54b0 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00005517          	auipc	a0,0x5
     7c6:	4be50513          	add	a0,a0,1214 # 5c80 <malloc+0x3b0>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	04e080e7          	jalr	78(ra) # 5818 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00005517          	auipc	a0,0x5
     7da:	48a50513          	add	a0,a0,1162 # 5c60 <malloc+0x390>
     7de:	00005097          	auipc	ra,0x5
     7e2:	03a080e7          	jalr	58(ra) # 5818 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	cc8080e7          	jalr	-824(ra) # 54b0 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00005517          	auipc	a0,0x5
     7f8:	4a450513          	add	a0,a0,1188 # 5c98 <malloc+0x3c8>
     7fc:	00005097          	auipc	ra,0x5
     800:	01c080e7          	jalr	28(ra) # 5818 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	caa080e7          	jalr	-854(ra) # 54b0 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00005517          	auipc	a0,0x5
     816:	4a650513          	add	a0,a0,1190 # 5cb8 <malloc+0x3e8>
     81a:	00005097          	auipc	ra,0x5
     81e:	ffe080e7          	jalr	-2(ra) # 5818 <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	c8c080e7          	jalr	-884(ra) # 54b0 <exit>

000000000000082c <writetest>:
{
     82c:	7139                	add	sp,sp,-64
     82e:	fc06                	sd	ra,56(sp)
     830:	f822                	sd	s0,48(sp)
     832:	f426                	sd	s1,40(sp)
     834:	f04a                	sd	s2,32(sp)
     836:	ec4e                	sd	s3,24(sp)
     838:	e852                	sd	s4,16(sp)
     83a:	e456                	sd	s5,8(sp)
     83c:	e05a                	sd	s6,0(sp)
     83e:	0080                	add	s0,sp,64
     840:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     842:	20200593          	li	a1,514
     846:	00005517          	auipc	a0,0x5
     84a:	49250513          	add	a0,a0,1170 # 5cd8 <malloc+0x408>
     84e:	00005097          	auipc	ra,0x5
     852:	ca2080e7          	jalr	-862(ra) # 54f0 <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00005997          	auipc	s3,0x5
     862:	4a298993          	add	s3,s3,1186 # 5d00 <malloc+0x430>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00005a97          	auipc	s5,0x5
     86a:	4d2a8a93          	add	s5,s5,1234 # 5d38 <malloc+0x468>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	c58080e7          	jalr	-936(ra) # 54d0 <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	c44080e7          	jalr	-956(ra) # 54d0 <write>
     894:	47a9                	li	a5,10
     896:	0af51a63          	bne	a0,a5,94a <writetest+0x11e>
  for(i = 0; i < N; i++){
     89a:	2485                	addw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	c36080e7          	jalr	-970(ra) # 54d8 <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00005517          	auipc	a0,0x5
     8b0:	42c50513          	add	a0,a0,1068 # 5cd8 <malloc+0x408>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	c3c080e7          	jalr	-964(ra) # 54f0 <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054563          	bltz	a0,968 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	08a58593          	add	a1,a1,138 # b950 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	bfa080e7          	jalr	-1030(ra) # 54c8 <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51563          	bne	a0,a5,984 <writetest+0x158>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	bf8080e7          	jalr	-1032(ra) # 54d8 <close>
  if(unlink("small") < 0){
     8e8:	00005517          	auipc	a0,0x5
     8ec:	3f050513          	add	a0,a0,1008 # 5cd8 <malloc+0x408>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	c10080e7          	jalr	-1008(ra) # 5500 <unlink>
     8f8:	0a054463          	bltz	a0,9a0 <writetest+0x174>
}
     8fc:	70e2                	ld	ra,56(sp)
     8fe:	7442                	ld	s0,48(sp)
     900:	74a2                	ld	s1,40(sp)
     902:	7902                	ld	s2,32(sp)
     904:	69e2                	ld	s3,24(sp)
     906:	6a42                	ld	s4,16(sp)
     908:	6aa2                	ld	s5,8(sp)
     90a:	6b02                	ld	s6,0(sp)
     90c:	6121                	add	sp,sp,64
     90e:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     910:	85da                	mv	a1,s6
     912:	00005517          	auipc	a0,0x5
     916:	3ce50513          	add	a0,a0,974 # 5ce0 <malloc+0x410>
     91a:	00005097          	auipc	ra,0x5
     91e:	efe080e7          	jalr	-258(ra) # 5818 <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	b8c080e7          	jalr	-1140(ra) # 54b0 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     92c:	8626                	mv	a2,s1
     92e:	85da                	mv	a1,s6
     930:	00005517          	auipc	a0,0x5
     934:	3e050513          	add	a0,a0,992 # 5d10 <malloc+0x440>
     938:	00005097          	auipc	ra,0x5
     93c:	ee0080e7          	jalr	-288(ra) # 5818 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	b6e080e7          	jalr	-1170(ra) # 54b0 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     94a:	8626                	mv	a2,s1
     94c:	85da                	mv	a1,s6
     94e:	00005517          	auipc	a0,0x5
     952:	3fa50513          	add	a0,a0,1018 # 5d48 <malloc+0x478>
     956:	00005097          	auipc	ra,0x5
     95a:	ec2080e7          	jalr	-318(ra) # 5818 <printf>
      exit(1);
     95e:	4505                	li	a0,1
     960:	00005097          	auipc	ra,0x5
     964:	b50080e7          	jalr	-1200(ra) # 54b0 <exit>
    printf("%s: error: open small failed!\n", s);
     968:	85da                	mv	a1,s6
     96a:	00005517          	auipc	a0,0x5
     96e:	40650513          	add	a0,a0,1030 # 5d70 <malloc+0x4a0>
     972:	00005097          	auipc	ra,0x5
     976:	ea6080e7          	jalr	-346(ra) # 5818 <printf>
    exit(1);
     97a:	4505                	li	a0,1
     97c:	00005097          	auipc	ra,0x5
     980:	b34080e7          	jalr	-1228(ra) # 54b0 <exit>
    printf("%s: read failed\n", s);
     984:	85da                	mv	a1,s6
     986:	00005517          	auipc	a0,0x5
     98a:	40a50513          	add	a0,a0,1034 # 5d90 <malloc+0x4c0>
     98e:	00005097          	auipc	ra,0x5
     992:	e8a080e7          	jalr	-374(ra) # 5818 <printf>
    exit(1);
     996:	4505                	li	a0,1
     998:	00005097          	auipc	ra,0x5
     99c:	b18080e7          	jalr	-1256(ra) # 54b0 <exit>
    printf("%s: unlink small failed\n", s);
     9a0:	85da                	mv	a1,s6
     9a2:	00005517          	auipc	a0,0x5
     9a6:	40650513          	add	a0,a0,1030 # 5da8 <malloc+0x4d8>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	e6e080e7          	jalr	-402(ra) # 5818 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	afc080e7          	jalr	-1284(ra) # 54b0 <exit>

00000000000009bc <writebig>:
{
     9bc:	7139                	add	sp,sp,-64
     9be:	fc06                	sd	ra,56(sp)
     9c0:	f822                	sd	s0,48(sp)
     9c2:	f426                	sd	s1,40(sp)
     9c4:	f04a                	sd	s2,32(sp)
     9c6:	ec4e                	sd	s3,24(sp)
     9c8:	e852                	sd	s4,16(sp)
     9ca:	e456                	sd	s5,8(sp)
     9cc:	0080                	add	s0,sp,64
     9ce:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d0:	20200593          	li	a1,514
     9d4:	00005517          	auipc	a0,0x5
     9d8:	3f450513          	add	a0,a0,1012 # 5dc8 <malloc+0x4f8>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	b14080e7          	jalr	-1260(ra) # 54f0 <open>
     9e4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e8:	0000b917          	auipc	s2,0xb
     9ec:	f6890913          	add	s2,s2,-152 # b950 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f0:	10c00a13          	li	s4,268
  if(fd < 0){
     9f4:	06054c63          	bltz	a0,a6c <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	00005097          	auipc	ra,0x5
     a08:	acc080e7          	jalr	-1332(ra) # 54d0 <write>
     a0c:	40000793          	li	a5,1024
     a10:	06f51c63          	bne	a0,a5,a88 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a14:	2485                	addw	s1,s1,1
     a16:	ff4491e3          	bne	s1,s4,9f8 <writebig+0x3c>
  close(fd);
     a1a:	854e                	mv	a0,s3
     a1c:	00005097          	auipc	ra,0x5
     a20:	abc080e7          	jalr	-1348(ra) # 54d8 <close>
  fd = open("big", O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	00005517          	auipc	a0,0x5
     a2a:	3a250513          	add	a0,a0,930 # 5dc8 <malloc+0x4f8>
     a2e:	00005097          	auipc	ra,0x5
     a32:	ac2080e7          	jalr	-1342(ra) # 54f0 <open>
     a36:	89aa                	mv	s3,a0
  n = 0;
     a38:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a3a:	0000b917          	auipc	s2,0xb
     a3e:	f1690913          	add	s2,s2,-234 # b950 <buf>
  if(fd < 0){
     a42:	06054263          	bltz	a0,aa6 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a46:	40000613          	li	a2,1024
     a4a:	85ca                	mv	a1,s2
     a4c:	854e                	mv	a0,s3
     a4e:	00005097          	auipc	ra,0x5
     a52:	a7a080e7          	jalr	-1414(ra) # 54c8 <read>
    if(i == 0){
     a56:	c535                	beqz	a0,ac2 <writebig+0x106>
    } else if(i != BSIZE){
     a58:	40000793          	li	a5,1024
     a5c:	0af51f63          	bne	a0,a5,b1a <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a60:	00092683          	lw	a3,0(s2)
     a64:	0c969a63          	bne	a3,s1,b38 <writebig+0x17c>
    n++;
     a68:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a6a:	bff1                	j	a46 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6c:	85d6                	mv	a1,s5
     a6e:	00005517          	auipc	a0,0x5
     a72:	36250513          	add	a0,a0,866 # 5dd0 <malloc+0x500>
     a76:	00005097          	auipc	ra,0x5
     a7a:	da2080e7          	jalr	-606(ra) # 5818 <printf>
    exit(1);
     a7e:	4505                	li	a0,1
     a80:	00005097          	auipc	ra,0x5
     a84:	a30080e7          	jalr	-1488(ra) # 54b0 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a88:	8626                	mv	a2,s1
     a8a:	85d6                	mv	a1,s5
     a8c:	00005517          	auipc	a0,0x5
     a90:	36450513          	add	a0,a0,868 # 5df0 <malloc+0x520>
     a94:	00005097          	auipc	ra,0x5
     a98:	d84080e7          	jalr	-636(ra) # 5818 <printf>
      exit(1);
     a9c:	4505                	li	a0,1
     a9e:	00005097          	auipc	ra,0x5
     aa2:	a12080e7          	jalr	-1518(ra) # 54b0 <exit>
    printf("%s: error: open big failed!\n", s);
     aa6:	85d6                	mv	a1,s5
     aa8:	00005517          	auipc	a0,0x5
     aac:	37050513          	add	a0,a0,880 # 5e18 <malloc+0x548>
     ab0:	00005097          	auipc	ra,0x5
     ab4:	d68080e7          	jalr	-664(ra) # 5818 <printf>
    exit(1);
     ab8:	4505                	li	a0,1
     aba:	00005097          	auipc	ra,0x5
     abe:	9f6080e7          	jalr	-1546(ra) # 54b0 <exit>
      if(n == MAXFILE - 1){
     ac2:	10b00793          	li	a5,267
     ac6:	02f48a63          	beq	s1,a5,afa <writebig+0x13e>
  close(fd);
     aca:	854e                	mv	a0,s3
     acc:	00005097          	auipc	ra,0x5
     ad0:	a0c080e7          	jalr	-1524(ra) # 54d8 <close>
  if(unlink("big") < 0){
     ad4:	00005517          	auipc	a0,0x5
     ad8:	2f450513          	add	a0,a0,756 # 5dc8 <malloc+0x4f8>
     adc:	00005097          	auipc	ra,0x5
     ae0:	a24080e7          	jalr	-1500(ra) # 5500 <unlink>
     ae4:	06054963          	bltz	a0,b56 <writebig+0x19a>
}
     ae8:	70e2                	ld	ra,56(sp)
     aea:	7442                	ld	s0,48(sp)
     aec:	74a2                	ld	s1,40(sp)
     aee:	7902                	ld	s2,32(sp)
     af0:	69e2                	ld	s3,24(sp)
     af2:	6a42                	ld	s4,16(sp)
     af4:	6aa2                	ld	s5,8(sp)
     af6:	6121                	add	sp,sp,64
     af8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     afa:	10b00613          	li	a2,267
     afe:	85d6                	mv	a1,s5
     b00:	00005517          	auipc	a0,0x5
     b04:	33850513          	add	a0,a0,824 # 5e38 <malloc+0x568>
     b08:	00005097          	auipc	ra,0x5
     b0c:	d10080e7          	jalr	-752(ra) # 5818 <printf>
        exit(1);
     b10:	4505                	li	a0,1
     b12:	00005097          	auipc	ra,0x5
     b16:	99e080e7          	jalr	-1634(ra) # 54b0 <exit>
      printf("%s: read failed %d\n", s, i);
     b1a:	862a                	mv	a2,a0
     b1c:	85d6                	mv	a1,s5
     b1e:	00005517          	auipc	a0,0x5
     b22:	34250513          	add	a0,a0,834 # 5e60 <malloc+0x590>
     b26:	00005097          	auipc	ra,0x5
     b2a:	cf2080e7          	jalr	-782(ra) # 5818 <printf>
      exit(1);
     b2e:	4505                	li	a0,1
     b30:	00005097          	auipc	ra,0x5
     b34:	980080e7          	jalr	-1664(ra) # 54b0 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b38:	8626                	mv	a2,s1
     b3a:	85d6                	mv	a1,s5
     b3c:	00005517          	auipc	a0,0x5
     b40:	33c50513          	add	a0,a0,828 # 5e78 <malloc+0x5a8>
     b44:	00005097          	auipc	ra,0x5
     b48:	cd4080e7          	jalr	-812(ra) # 5818 <printf>
      exit(1);
     b4c:	4505                	li	a0,1
     b4e:	00005097          	auipc	ra,0x5
     b52:	962080e7          	jalr	-1694(ra) # 54b0 <exit>
    printf("%s: unlink big failed\n", s);
     b56:	85d6                	mv	a1,s5
     b58:	00005517          	auipc	a0,0x5
     b5c:	34850513          	add	a0,a0,840 # 5ea0 <malloc+0x5d0>
     b60:	00005097          	auipc	ra,0x5
     b64:	cb8080e7          	jalr	-840(ra) # 5818 <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00005097          	auipc	ra,0x5
     b6e:	946080e7          	jalr	-1722(ra) # 54b0 <exit>

0000000000000b72 <unlinkread>:
{
     b72:	7179                	add	sp,sp,-48
     b74:	f406                	sd	ra,40(sp)
     b76:	f022                	sd	s0,32(sp)
     b78:	ec26                	sd	s1,24(sp)
     b7a:	e84a                	sd	s2,16(sp)
     b7c:	e44e                	sd	s3,8(sp)
     b7e:	1800                	add	s0,sp,48
     b80:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b82:	20200593          	li	a1,514
     b86:	00005517          	auipc	a0,0x5
     b8a:	33250513          	add	a0,a0,818 # 5eb8 <malloc+0x5e8>
     b8e:	00005097          	auipc	ra,0x5
     b92:	962080e7          	jalr	-1694(ra) # 54f0 <open>
  if(fd < 0){
     b96:	0e054563          	bltz	a0,c80 <unlinkread+0x10e>
     b9a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9c:	4615                	li	a2,5
     b9e:	00005597          	auipc	a1,0x5
     ba2:	34a58593          	add	a1,a1,842 # 5ee8 <malloc+0x618>
     ba6:	00005097          	auipc	ra,0x5
     baa:	92a080e7          	jalr	-1750(ra) # 54d0 <write>
  close(fd);
     bae:	8526                	mv	a0,s1
     bb0:	00005097          	auipc	ra,0x5
     bb4:	928080e7          	jalr	-1752(ra) # 54d8 <close>
  fd = open("unlinkread", O_RDWR);
     bb8:	4589                	li	a1,2
     bba:	00005517          	auipc	a0,0x5
     bbe:	2fe50513          	add	a0,a0,766 # 5eb8 <malloc+0x5e8>
     bc2:	00005097          	auipc	ra,0x5
     bc6:	92e080e7          	jalr	-1746(ra) # 54f0 <open>
     bca:	84aa                	mv	s1,a0
  if(fd < 0){
     bcc:	0c054863          	bltz	a0,c9c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bd0:	00005517          	auipc	a0,0x5
     bd4:	2e850513          	add	a0,a0,744 # 5eb8 <malloc+0x5e8>
     bd8:	00005097          	auipc	ra,0x5
     bdc:	928080e7          	jalr	-1752(ra) # 5500 <unlink>
     be0:	ed61                	bnez	a0,cb8 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     be2:	20200593          	li	a1,514
     be6:	00005517          	auipc	a0,0x5
     bea:	2d250513          	add	a0,a0,722 # 5eb8 <malloc+0x5e8>
     bee:	00005097          	auipc	ra,0x5
     bf2:	902080e7          	jalr	-1790(ra) # 54f0 <open>
     bf6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bf8:	460d                	li	a2,3
     bfa:	00005597          	auipc	a1,0x5
     bfe:	33658593          	add	a1,a1,822 # 5f30 <malloc+0x660>
     c02:	00005097          	auipc	ra,0x5
     c06:	8ce080e7          	jalr	-1842(ra) # 54d0 <write>
  close(fd1);
     c0a:	854a                	mv	a0,s2
     c0c:	00005097          	auipc	ra,0x5
     c10:	8cc080e7          	jalr	-1844(ra) # 54d8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c14:	660d                	lui	a2,0x3
     c16:	0000b597          	auipc	a1,0xb
     c1a:	d3a58593          	add	a1,a1,-710 # b950 <buf>
     c1e:	8526                	mv	a0,s1
     c20:	00005097          	auipc	ra,0x5
     c24:	8a8080e7          	jalr	-1880(ra) # 54c8 <read>
     c28:	4795                	li	a5,5
     c2a:	0af51563          	bne	a0,a5,cd4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c2e:	0000b717          	auipc	a4,0xb
     c32:	d2274703          	lbu	a4,-734(a4) # b950 <buf>
     c36:	06800793          	li	a5,104
     c3a:	0af71b63          	bne	a4,a5,cf0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c3e:	4629                	li	a2,10
     c40:	0000b597          	auipc	a1,0xb
     c44:	d1058593          	add	a1,a1,-752 # b950 <buf>
     c48:	8526                	mv	a0,s1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	886080e7          	jalr	-1914(ra) # 54d0 <write>
     c52:	47a9                	li	a5,10
     c54:	0af51c63          	bne	a0,a5,d0c <unlinkread+0x19a>
  close(fd);
     c58:	8526                	mv	a0,s1
     c5a:	00005097          	auipc	ra,0x5
     c5e:	87e080e7          	jalr	-1922(ra) # 54d8 <close>
  unlink("unlinkread");
     c62:	00005517          	auipc	a0,0x5
     c66:	25650513          	add	a0,a0,598 # 5eb8 <malloc+0x5e8>
     c6a:	00005097          	auipc	ra,0x5
     c6e:	896080e7          	jalr	-1898(ra) # 5500 <unlink>
}
     c72:	70a2                	ld	ra,40(sp)
     c74:	7402                	ld	s0,32(sp)
     c76:	64e2                	ld	s1,24(sp)
     c78:	6942                	ld	s2,16(sp)
     c7a:	69a2                	ld	s3,8(sp)
     c7c:	6145                	add	sp,sp,48
     c7e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c80:	85ce                	mv	a1,s3
     c82:	00005517          	auipc	a0,0x5
     c86:	24650513          	add	a0,a0,582 # 5ec8 <malloc+0x5f8>
     c8a:	00005097          	auipc	ra,0x5
     c8e:	b8e080e7          	jalr	-1138(ra) # 5818 <printf>
    exit(1);
     c92:	4505                	li	a0,1
     c94:	00005097          	auipc	ra,0x5
     c98:	81c080e7          	jalr	-2020(ra) # 54b0 <exit>
    printf("%s: open unlinkread failed\n", s);
     c9c:	85ce                	mv	a1,s3
     c9e:	00005517          	auipc	a0,0x5
     ca2:	25250513          	add	a0,a0,594 # 5ef0 <malloc+0x620>
     ca6:	00005097          	auipc	ra,0x5
     caa:	b72080e7          	jalr	-1166(ra) # 5818 <printf>
    exit(1);
     cae:	4505                	li	a0,1
     cb0:	00005097          	auipc	ra,0x5
     cb4:	800080e7          	jalr	-2048(ra) # 54b0 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cb8:	85ce                	mv	a1,s3
     cba:	00005517          	auipc	a0,0x5
     cbe:	25650513          	add	a0,a0,598 # 5f10 <malloc+0x640>
     cc2:	00005097          	auipc	ra,0x5
     cc6:	b56080e7          	jalr	-1194(ra) # 5818 <printf>
    exit(1);
     cca:	4505                	li	a0,1
     ccc:	00004097          	auipc	ra,0x4
     cd0:	7e4080e7          	jalr	2020(ra) # 54b0 <exit>
    printf("%s: unlinkread read failed", s);
     cd4:	85ce                	mv	a1,s3
     cd6:	00005517          	auipc	a0,0x5
     cda:	26250513          	add	a0,a0,610 # 5f38 <malloc+0x668>
     cde:	00005097          	auipc	ra,0x5
     ce2:	b3a080e7          	jalr	-1222(ra) # 5818 <printf>
    exit(1);
     ce6:	4505                	li	a0,1
     ce8:	00004097          	auipc	ra,0x4
     cec:	7c8080e7          	jalr	1992(ra) # 54b0 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cf0:	85ce                	mv	a1,s3
     cf2:	00005517          	auipc	a0,0x5
     cf6:	26650513          	add	a0,a0,614 # 5f58 <malloc+0x688>
     cfa:	00005097          	auipc	ra,0x5
     cfe:	b1e080e7          	jalr	-1250(ra) # 5818 <printf>
    exit(1);
     d02:	4505                	li	a0,1
     d04:	00004097          	auipc	ra,0x4
     d08:	7ac080e7          	jalr	1964(ra) # 54b0 <exit>
    printf("%s: unlinkread write failed\n", s);
     d0c:	85ce                	mv	a1,s3
     d0e:	00005517          	auipc	a0,0x5
     d12:	26a50513          	add	a0,a0,618 # 5f78 <malloc+0x6a8>
     d16:	00005097          	auipc	ra,0x5
     d1a:	b02080e7          	jalr	-1278(ra) # 5818 <printf>
    exit(1);
     d1e:	4505                	li	a0,1
     d20:	00004097          	auipc	ra,0x4
     d24:	790080e7          	jalr	1936(ra) # 54b0 <exit>

0000000000000d28 <linktest>:
{
     d28:	1101                	add	sp,sp,-32
     d2a:	ec06                	sd	ra,24(sp)
     d2c:	e822                	sd	s0,16(sp)
     d2e:	e426                	sd	s1,8(sp)
     d30:	e04a                	sd	s2,0(sp)
     d32:	1000                	add	s0,sp,32
     d34:	892a                	mv	s2,a0
  unlink("lf1");
     d36:	00005517          	auipc	a0,0x5
     d3a:	26250513          	add	a0,a0,610 # 5f98 <malloc+0x6c8>
     d3e:	00004097          	auipc	ra,0x4
     d42:	7c2080e7          	jalr	1986(ra) # 5500 <unlink>
  unlink("lf2");
     d46:	00005517          	auipc	a0,0x5
     d4a:	25a50513          	add	a0,a0,602 # 5fa0 <malloc+0x6d0>
     d4e:	00004097          	auipc	ra,0x4
     d52:	7b2080e7          	jalr	1970(ra) # 5500 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d56:	20200593          	li	a1,514
     d5a:	00005517          	auipc	a0,0x5
     d5e:	23e50513          	add	a0,a0,574 # 5f98 <malloc+0x6c8>
     d62:	00004097          	auipc	ra,0x4
     d66:	78e080e7          	jalr	1934(ra) # 54f0 <open>
  if(fd < 0){
     d6a:	10054763          	bltz	a0,e78 <linktest+0x150>
     d6e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d70:	4615                	li	a2,5
     d72:	00005597          	auipc	a1,0x5
     d76:	17658593          	add	a1,a1,374 # 5ee8 <malloc+0x618>
     d7a:	00004097          	auipc	ra,0x4
     d7e:	756080e7          	jalr	1878(ra) # 54d0 <write>
     d82:	4795                	li	a5,5
     d84:	10f51863          	bne	a0,a5,e94 <linktest+0x16c>
  close(fd);
     d88:	8526                	mv	a0,s1
     d8a:	00004097          	auipc	ra,0x4
     d8e:	74e080e7          	jalr	1870(ra) # 54d8 <close>
  if(link("lf1", "lf2") < 0){
     d92:	00005597          	auipc	a1,0x5
     d96:	20e58593          	add	a1,a1,526 # 5fa0 <malloc+0x6d0>
     d9a:	00005517          	auipc	a0,0x5
     d9e:	1fe50513          	add	a0,a0,510 # 5f98 <malloc+0x6c8>
     da2:	00004097          	auipc	ra,0x4
     da6:	76e080e7          	jalr	1902(ra) # 5510 <link>
     daa:	10054363          	bltz	a0,eb0 <linktest+0x188>
  unlink("lf1");
     dae:	00005517          	auipc	a0,0x5
     db2:	1ea50513          	add	a0,a0,490 # 5f98 <malloc+0x6c8>
     db6:	00004097          	auipc	ra,0x4
     dba:	74a080e7          	jalr	1866(ra) # 5500 <unlink>
  if(open("lf1", 0) >= 0){
     dbe:	4581                	li	a1,0
     dc0:	00005517          	auipc	a0,0x5
     dc4:	1d850513          	add	a0,a0,472 # 5f98 <malloc+0x6c8>
     dc8:	00004097          	auipc	ra,0x4
     dcc:	728080e7          	jalr	1832(ra) # 54f0 <open>
     dd0:	0e055e63          	bgez	a0,ecc <linktest+0x1a4>
  fd = open("lf2", 0);
     dd4:	4581                	li	a1,0
     dd6:	00005517          	auipc	a0,0x5
     dda:	1ca50513          	add	a0,a0,458 # 5fa0 <malloc+0x6d0>
     dde:	00004097          	auipc	ra,0x4
     de2:	712080e7          	jalr	1810(ra) # 54f0 <open>
     de6:	84aa                	mv	s1,a0
  if(fd < 0){
     de8:	10054063          	bltz	a0,ee8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dec:	660d                	lui	a2,0x3
     dee:	0000b597          	auipc	a1,0xb
     df2:	b6258593          	add	a1,a1,-1182 # b950 <buf>
     df6:	00004097          	auipc	ra,0x4
     dfa:	6d2080e7          	jalr	1746(ra) # 54c8 <read>
     dfe:	4795                	li	a5,5
     e00:	10f51263          	bne	a0,a5,f04 <linktest+0x1dc>
  close(fd);
     e04:	8526                	mv	a0,s1
     e06:	00004097          	auipc	ra,0x4
     e0a:	6d2080e7          	jalr	1746(ra) # 54d8 <close>
  if(link("lf2", "lf2") >= 0){
     e0e:	00005597          	auipc	a1,0x5
     e12:	19258593          	add	a1,a1,402 # 5fa0 <malloc+0x6d0>
     e16:	852e                	mv	a0,a1
     e18:	00004097          	auipc	ra,0x4
     e1c:	6f8080e7          	jalr	1784(ra) # 5510 <link>
     e20:	10055063          	bgez	a0,f20 <linktest+0x1f8>
  unlink("lf2");
     e24:	00005517          	auipc	a0,0x5
     e28:	17c50513          	add	a0,a0,380 # 5fa0 <malloc+0x6d0>
     e2c:	00004097          	auipc	ra,0x4
     e30:	6d4080e7          	jalr	1748(ra) # 5500 <unlink>
  if(link("lf2", "lf1") >= 0){
     e34:	00005597          	auipc	a1,0x5
     e38:	16458593          	add	a1,a1,356 # 5f98 <malloc+0x6c8>
     e3c:	00005517          	auipc	a0,0x5
     e40:	16450513          	add	a0,a0,356 # 5fa0 <malloc+0x6d0>
     e44:	00004097          	auipc	ra,0x4
     e48:	6cc080e7          	jalr	1740(ra) # 5510 <link>
     e4c:	0e055863          	bgez	a0,f3c <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e50:	00005597          	auipc	a1,0x5
     e54:	14858593          	add	a1,a1,328 # 5f98 <malloc+0x6c8>
     e58:	00005517          	auipc	a0,0x5
     e5c:	25050513          	add	a0,a0,592 # 60a8 <malloc+0x7d8>
     e60:	00004097          	auipc	ra,0x4
     e64:	6b0080e7          	jalr	1712(ra) # 5510 <link>
     e68:	0e055863          	bgez	a0,f58 <linktest+0x230>
}
     e6c:	60e2                	ld	ra,24(sp)
     e6e:	6442                	ld	s0,16(sp)
     e70:	64a2                	ld	s1,8(sp)
     e72:	6902                	ld	s2,0(sp)
     e74:	6105                	add	sp,sp,32
     e76:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e78:	85ca                	mv	a1,s2
     e7a:	00005517          	auipc	a0,0x5
     e7e:	12e50513          	add	a0,a0,302 # 5fa8 <malloc+0x6d8>
     e82:	00005097          	auipc	ra,0x5
     e86:	996080e7          	jalr	-1642(ra) # 5818 <printf>
    exit(1);
     e8a:	4505                	li	a0,1
     e8c:	00004097          	auipc	ra,0x4
     e90:	624080e7          	jalr	1572(ra) # 54b0 <exit>
    printf("%s: write lf1 failed\n", s);
     e94:	85ca                	mv	a1,s2
     e96:	00005517          	auipc	a0,0x5
     e9a:	12a50513          	add	a0,a0,298 # 5fc0 <malloc+0x6f0>
     e9e:	00005097          	auipc	ra,0x5
     ea2:	97a080e7          	jalr	-1670(ra) # 5818 <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00004097          	auipc	ra,0x4
     eac:	608080e7          	jalr	1544(ra) # 54b0 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     eb0:	85ca                	mv	a1,s2
     eb2:	00005517          	auipc	a0,0x5
     eb6:	12650513          	add	a0,a0,294 # 5fd8 <malloc+0x708>
     eba:	00005097          	auipc	ra,0x5
     ebe:	95e080e7          	jalr	-1698(ra) # 5818 <printf>
    exit(1);
     ec2:	4505                	li	a0,1
     ec4:	00004097          	auipc	ra,0x4
     ec8:	5ec080e7          	jalr	1516(ra) # 54b0 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ecc:	85ca                	mv	a1,s2
     ece:	00005517          	auipc	a0,0x5
     ed2:	12a50513          	add	a0,a0,298 # 5ff8 <malloc+0x728>
     ed6:	00005097          	auipc	ra,0x5
     eda:	942080e7          	jalr	-1726(ra) # 5818 <printf>
    exit(1);
     ede:	4505                	li	a0,1
     ee0:	00004097          	auipc	ra,0x4
     ee4:	5d0080e7          	jalr	1488(ra) # 54b0 <exit>
    printf("%s: open lf2 failed\n", s);
     ee8:	85ca                	mv	a1,s2
     eea:	00005517          	auipc	a0,0x5
     eee:	13e50513          	add	a0,a0,318 # 6028 <malloc+0x758>
     ef2:	00005097          	auipc	ra,0x5
     ef6:	926080e7          	jalr	-1754(ra) # 5818 <printf>
    exit(1);
     efa:	4505                	li	a0,1
     efc:	00004097          	auipc	ra,0x4
     f00:	5b4080e7          	jalr	1460(ra) # 54b0 <exit>
    printf("%s: read lf2 failed\n", s);
     f04:	85ca                	mv	a1,s2
     f06:	00005517          	auipc	a0,0x5
     f0a:	13a50513          	add	a0,a0,314 # 6040 <malloc+0x770>
     f0e:	00005097          	auipc	ra,0x5
     f12:	90a080e7          	jalr	-1782(ra) # 5818 <printf>
    exit(1);
     f16:	4505                	li	a0,1
     f18:	00004097          	auipc	ra,0x4
     f1c:	598080e7          	jalr	1432(ra) # 54b0 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f20:	85ca                	mv	a1,s2
     f22:	00005517          	auipc	a0,0x5
     f26:	13650513          	add	a0,a0,310 # 6058 <malloc+0x788>
     f2a:	00005097          	auipc	ra,0x5
     f2e:	8ee080e7          	jalr	-1810(ra) # 5818 <printf>
    exit(1);
     f32:	4505                	li	a0,1
     f34:	00004097          	auipc	ra,0x4
     f38:	57c080e7          	jalr	1404(ra) # 54b0 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f3c:	85ca                	mv	a1,s2
     f3e:	00005517          	auipc	a0,0x5
     f42:	14250513          	add	a0,a0,322 # 6080 <malloc+0x7b0>
     f46:	00005097          	auipc	ra,0x5
     f4a:	8d2080e7          	jalr	-1838(ra) # 5818 <printf>
    exit(1);
     f4e:	4505                	li	a0,1
     f50:	00004097          	auipc	ra,0x4
     f54:	560080e7          	jalr	1376(ra) # 54b0 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f58:	85ca                	mv	a1,s2
     f5a:	00005517          	auipc	a0,0x5
     f5e:	15650513          	add	a0,a0,342 # 60b0 <malloc+0x7e0>
     f62:	00005097          	auipc	ra,0x5
     f66:	8b6080e7          	jalr	-1866(ra) # 5818 <printf>
    exit(1);
     f6a:	4505                	li	a0,1
     f6c:	00004097          	auipc	ra,0x4
     f70:	544080e7          	jalr	1348(ra) # 54b0 <exit>

0000000000000f74 <bigdir>:
{
     f74:	715d                	add	sp,sp,-80
     f76:	e486                	sd	ra,72(sp)
     f78:	e0a2                	sd	s0,64(sp)
     f7a:	fc26                	sd	s1,56(sp)
     f7c:	f84a                	sd	s2,48(sp)
     f7e:	f44e                	sd	s3,40(sp)
     f80:	f052                	sd	s4,32(sp)
     f82:	ec56                	sd	s5,24(sp)
     f84:	e85a                	sd	s6,16(sp)
     f86:	0880                	add	s0,sp,80
     f88:	89aa                	mv	s3,a0
  unlink("bd");
     f8a:	00005517          	auipc	a0,0x5
     f8e:	14650513          	add	a0,a0,326 # 60d0 <malloc+0x800>
     f92:	00004097          	auipc	ra,0x4
     f96:	56e080e7          	jalr	1390(ra) # 5500 <unlink>
  fd = open("bd", O_CREATE);
     f9a:	20000593          	li	a1,512
     f9e:	00005517          	auipc	a0,0x5
     fa2:	13250513          	add	a0,a0,306 # 60d0 <malloc+0x800>
     fa6:	00004097          	auipc	ra,0x4
     faa:	54a080e7          	jalr	1354(ra) # 54f0 <open>
  if(fd < 0){
     fae:	0c054963          	bltz	a0,1080 <bigdir+0x10c>
  close(fd);
     fb2:	00004097          	auipc	ra,0x4
     fb6:	526080e7          	jalr	1318(ra) # 54d8 <close>
  for(i = 0; i < N; i++){
     fba:	4901                	li	s2,0
    name[0] = 'x';
     fbc:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fc0:	00005a17          	auipc	s4,0x5
     fc4:	110a0a13          	add	s4,s4,272 # 60d0 <malloc+0x800>
  for(i = 0; i < N; i++){
     fc8:	1f400b13          	li	s6,500
    name[0] = 'x';
     fcc:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fd0:	41f9571b          	sraw	a4,s2,0x1f
     fd4:	01a7571b          	srlw	a4,a4,0x1a
     fd8:	012707bb          	addw	a5,a4,s2
     fdc:	4067d69b          	sraw	a3,a5,0x6
     fe0:	0306869b          	addw	a3,a3,48
     fe4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fe8:	03f7f793          	and	a5,a5,63
     fec:	9f99                	subw	a5,a5,a4
     fee:	0307879b          	addw	a5,a5,48
     ff2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     ff6:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ffa:	fb040593          	add	a1,s0,-80
     ffe:	8552                	mv	a0,s4
    1000:	00004097          	auipc	ra,0x4
    1004:	510080e7          	jalr	1296(ra) # 5510 <link>
    1008:	84aa                	mv	s1,a0
    100a:	e949                	bnez	a0,109c <bigdir+0x128>
  for(i = 0; i < N; i++){
    100c:	2905                	addw	s2,s2,1
    100e:	fb691fe3          	bne	s2,s6,fcc <bigdir+0x58>
  unlink("bd");
    1012:	00005517          	auipc	a0,0x5
    1016:	0be50513          	add	a0,a0,190 # 60d0 <malloc+0x800>
    101a:	00004097          	auipc	ra,0x4
    101e:	4e6080e7          	jalr	1254(ra) # 5500 <unlink>
    name[0] = 'x';
    1022:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1026:	1f400a13          	li	s4,500
    name[0] = 'x';
    102a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    102e:	41f4d71b          	sraw	a4,s1,0x1f
    1032:	01a7571b          	srlw	a4,a4,0x1a
    1036:	009707bb          	addw	a5,a4,s1
    103a:	4067d69b          	sraw	a3,a5,0x6
    103e:	0306869b          	addw	a3,a3,48
    1042:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1046:	03f7f793          	and	a5,a5,63
    104a:	9f99                	subw	a5,a5,a4
    104c:	0307879b          	addw	a5,a5,48
    1050:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1054:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1058:	fb040513          	add	a0,s0,-80
    105c:	00004097          	auipc	ra,0x4
    1060:	4a4080e7          	jalr	1188(ra) # 5500 <unlink>
    1064:	ed21                	bnez	a0,10bc <bigdir+0x148>
  for(i = 0; i < N; i++){
    1066:	2485                	addw	s1,s1,1
    1068:	fd4491e3          	bne	s1,s4,102a <bigdir+0xb6>
}
    106c:	60a6                	ld	ra,72(sp)
    106e:	6406                	ld	s0,64(sp)
    1070:	74e2                	ld	s1,56(sp)
    1072:	7942                	ld	s2,48(sp)
    1074:	79a2                	ld	s3,40(sp)
    1076:	7a02                	ld	s4,32(sp)
    1078:	6ae2                	ld	s5,24(sp)
    107a:	6b42                	ld	s6,16(sp)
    107c:	6161                	add	sp,sp,80
    107e:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1080:	85ce                	mv	a1,s3
    1082:	00005517          	auipc	a0,0x5
    1086:	05650513          	add	a0,a0,86 # 60d8 <malloc+0x808>
    108a:	00004097          	auipc	ra,0x4
    108e:	78e080e7          	jalr	1934(ra) # 5818 <printf>
    exit(1);
    1092:	4505                	li	a0,1
    1094:	00004097          	auipc	ra,0x4
    1098:	41c080e7          	jalr	1052(ra) # 54b0 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    109c:	fb040613          	add	a2,s0,-80
    10a0:	85ce                	mv	a1,s3
    10a2:	00005517          	auipc	a0,0x5
    10a6:	05650513          	add	a0,a0,86 # 60f8 <malloc+0x828>
    10aa:	00004097          	auipc	ra,0x4
    10ae:	76e080e7          	jalr	1902(ra) # 5818 <printf>
      exit(1);
    10b2:	4505                	li	a0,1
    10b4:	00004097          	auipc	ra,0x4
    10b8:	3fc080e7          	jalr	1020(ra) # 54b0 <exit>
      printf("%s: bigdir unlink failed", s);
    10bc:	85ce                	mv	a1,s3
    10be:	00005517          	auipc	a0,0x5
    10c2:	05a50513          	add	a0,a0,90 # 6118 <malloc+0x848>
    10c6:	00004097          	auipc	ra,0x4
    10ca:	752080e7          	jalr	1874(ra) # 5818 <printf>
      exit(1);
    10ce:	4505                	li	a0,1
    10d0:	00004097          	auipc	ra,0x4
    10d4:	3e0080e7          	jalr	992(ra) # 54b0 <exit>

00000000000010d8 <validatetest>:
{
    10d8:	7139                	add	sp,sp,-64
    10da:	fc06                	sd	ra,56(sp)
    10dc:	f822                	sd	s0,48(sp)
    10de:	f426                	sd	s1,40(sp)
    10e0:	f04a                	sd	s2,32(sp)
    10e2:	ec4e                	sd	s3,24(sp)
    10e4:	e852                	sd	s4,16(sp)
    10e6:	e456                	sd	s5,8(sp)
    10e8:	e05a                	sd	s6,0(sp)
    10ea:	0080                	add	s0,sp,64
    10ec:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ee:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10f0:	00005997          	auipc	s3,0x5
    10f4:	04898993          	add	s3,s3,72 # 6138 <malloc+0x868>
    10f8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fa:	6a85                	lui	s5,0x1
    10fc:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1100:	85a6                	mv	a1,s1
    1102:	854e                	mv	a0,s3
    1104:	00004097          	auipc	ra,0x4
    1108:	40c080e7          	jalr	1036(ra) # 5510 <link>
    110c:	01251f63          	bne	a0,s2,112a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1110:	94d6                	add	s1,s1,s5
    1112:	ff4497e3          	bne	s1,s4,1100 <validatetest+0x28>
}
    1116:	70e2                	ld	ra,56(sp)
    1118:	7442                	ld	s0,48(sp)
    111a:	74a2                	ld	s1,40(sp)
    111c:	7902                	ld	s2,32(sp)
    111e:	69e2                	ld	s3,24(sp)
    1120:	6a42                	ld	s4,16(sp)
    1122:	6aa2                	ld	s5,8(sp)
    1124:	6b02                	ld	s6,0(sp)
    1126:	6121                	add	sp,sp,64
    1128:	8082                	ret
      printf("%s: link should not succeed\n", s);
    112a:	85da                	mv	a1,s6
    112c:	00005517          	auipc	a0,0x5
    1130:	01c50513          	add	a0,a0,28 # 6148 <malloc+0x878>
    1134:	00004097          	auipc	ra,0x4
    1138:	6e4080e7          	jalr	1764(ra) # 5818 <printf>
      exit(1);
    113c:	4505                	li	a0,1
    113e:	00004097          	auipc	ra,0x4
    1142:	372080e7          	jalr	882(ra) # 54b0 <exit>

0000000000001146 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1146:	7179                	add	sp,sp,-48
    1148:	f406                	sd	ra,40(sp)
    114a:	f022                	sd	s0,32(sp)
    114c:	ec26                	sd	s1,24(sp)
    114e:	1800                	add	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1150:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1154:	00007497          	auipc	s1,0x7
    1158:	fc44b483          	ld	s1,-60(s1) # 8118 <__SDATA_BEGIN__>
    115c:	fd840593          	add	a1,s0,-40
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	386080e7          	jalr	902(ra) # 54e8 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    116a:	8526                	mv	a0,s1
    116c:	00004097          	auipc	ra,0x4
    1170:	354080e7          	jalr	852(ra) # 54c0 <pipe>

  exit(0);
    1174:	4501                	li	a0,0
    1176:	00004097          	auipc	ra,0x4
    117a:	33a080e7          	jalr	826(ra) # 54b0 <exit>

000000000000117e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    117e:	7139                	add	sp,sp,-64
    1180:	fc06                	sd	ra,56(sp)
    1182:	f822                	sd	s0,48(sp)
    1184:	f426                	sd	s1,40(sp)
    1186:	f04a                	sd	s2,32(sp)
    1188:	ec4e                	sd	s3,24(sp)
    118a:	0080                	add	s0,sp,64
    118c:	64b1                	lui	s1,0xc
    118e:	35048493          	add	s1,s1,848 # c350 <buf+0xa00>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1192:	597d                	li	s2,-1
    1194:	02095913          	srl	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1198:	00005997          	auipc	s3,0x5
    119c:	85898993          	add	s3,s3,-1960 # 59f0 <malloc+0x120>
    argv[0] = (char*)0xffffffff;
    11a0:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11a4:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11a8:	fc040593          	add	a1,s0,-64
    11ac:	854e                	mv	a0,s3
    11ae:	00004097          	auipc	ra,0x4
    11b2:	33a080e7          	jalr	826(ra) # 54e8 <exec>
  for(int i = 0; i < 50000; i++){
    11b6:	34fd                	addw	s1,s1,-1
    11b8:	f4e5                	bnez	s1,11a0 <badarg+0x22>
  }
  
  exit(0);
    11ba:	4501                	li	a0,0
    11bc:	00004097          	auipc	ra,0x4
    11c0:	2f4080e7          	jalr	756(ra) # 54b0 <exit>

00000000000011c4 <copyinstr2>:
{
    11c4:	7155                	add	sp,sp,-208
    11c6:	e586                	sd	ra,200(sp)
    11c8:	e1a2                	sd	s0,192(sp)
    11ca:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11cc:	f6840793          	add	a5,s0,-152
    11d0:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    11d4:	07800713          	li	a4,120
    11d8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11dc:	0785                	add	a5,a5,1
    11de:	fed79de3          	bne	a5,a3,11d8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11e2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11e6:	f6840513          	add	a0,s0,-152
    11ea:	00004097          	auipc	ra,0x4
    11ee:	316080e7          	jalr	790(ra) # 5500 <unlink>
  if(ret != -1){
    11f2:	57fd                	li	a5,-1
    11f4:	0ef51063          	bne	a0,a5,12d4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11f8:	20100593          	li	a1,513
    11fc:	f6840513          	add	a0,s0,-152
    1200:	00004097          	auipc	ra,0x4
    1204:	2f0080e7          	jalr	752(ra) # 54f0 <open>
  if(fd != -1){
    1208:	57fd                	li	a5,-1
    120a:	0ef51563          	bne	a0,a5,12f4 <copyinstr2+0x130>
  ret = link(b, b);
    120e:	f6840593          	add	a1,s0,-152
    1212:	852e                	mv	a0,a1
    1214:	00004097          	auipc	ra,0x4
    1218:	2fc080e7          	jalr	764(ra) # 5510 <link>
  if(ret != -1){
    121c:	57fd                	li	a5,-1
    121e:	0ef51b63          	bne	a0,a5,1314 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1222:	00006797          	auipc	a5,0x6
    1226:	0ee78793          	add	a5,a5,238 # 7310 <malloc+0x1a40>
    122a:	f4f43c23          	sd	a5,-168(s0)
    122e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1232:	f5840593          	add	a1,s0,-168
    1236:	f6840513          	add	a0,s0,-152
    123a:	00004097          	auipc	ra,0x4
    123e:	2ae080e7          	jalr	686(ra) # 54e8 <exec>
  if(ret != -1){
    1242:	57fd                	li	a5,-1
    1244:	0ef51963          	bne	a0,a5,1336 <copyinstr2+0x172>
  int pid = fork();
    1248:	00004097          	auipc	ra,0x4
    124c:	260080e7          	jalr	608(ra) # 54a8 <fork>
  if(pid < 0){
    1250:	10054363          	bltz	a0,1356 <copyinstr2+0x192>
  if(pid == 0){
    1254:	12051463          	bnez	a0,137c <copyinstr2+0x1b8>
    1258:	00007797          	auipc	a5,0x7
    125c:	fe078793          	add	a5,a5,-32 # 8238 <big.0>
    1260:	00008697          	auipc	a3,0x8
    1264:	fd868693          	add	a3,a3,-40 # 9238 <__global_pointer$+0x920>
      big[i] = 'x';
    1268:	07800713          	li	a4,120
    126c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1270:	0785                	add	a5,a5,1
    1272:	fed79de3          	bne	a5,a3,126c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1276:	00008797          	auipc	a5,0x8
    127a:	fc078123          	sb	zero,-62(a5) # 9238 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    127e:	00007797          	auipc	a5,0x7
    1282:	a6278793          	add	a5,a5,-1438 # 7ce0 <malloc+0x2410>
    1286:	6390                	ld	a2,0(a5)
    1288:	6794                	ld	a3,8(a5)
    128a:	6b98                	ld	a4,16(a5)
    128c:	6f9c                	ld	a5,24(a5)
    128e:	f2c43823          	sd	a2,-208(s0)
    1292:	f2d43c23          	sd	a3,-200(s0)
    1296:	f4e43023          	sd	a4,-192(s0)
    129a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    129e:	f3040593          	add	a1,s0,-208
    12a2:	00004517          	auipc	a0,0x4
    12a6:	74e50513          	add	a0,a0,1870 # 59f0 <malloc+0x120>
    12aa:	00004097          	auipc	ra,0x4
    12ae:	23e080e7          	jalr	574(ra) # 54e8 <exec>
    if(ret != -1){
    12b2:	57fd                	li	a5,-1
    12b4:	0af50e63          	beq	a0,a5,1370 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12b8:	55fd                	li	a1,-1
    12ba:	00005517          	auipc	a0,0x5
    12be:	f3650513          	add	a0,a0,-202 # 61f0 <malloc+0x920>
    12c2:	00004097          	auipc	ra,0x4
    12c6:	556080e7          	jalr	1366(ra) # 5818 <printf>
      exit(1);
    12ca:	4505                	li	a0,1
    12cc:	00004097          	auipc	ra,0x4
    12d0:	1e4080e7          	jalr	484(ra) # 54b0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12d4:	862a                	mv	a2,a0
    12d6:	f6840593          	add	a1,s0,-152
    12da:	00005517          	auipc	a0,0x5
    12de:	e8e50513          	add	a0,a0,-370 # 6168 <malloc+0x898>
    12e2:	00004097          	auipc	ra,0x4
    12e6:	536080e7          	jalr	1334(ra) # 5818 <printf>
    exit(1);
    12ea:	4505                	li	a0,1
    12ec:	00004097          	auipc	ra,0x4
    12f0:	1c4080e7          	jalr	452(ra) # 54b0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12f4:	862a                	mv	a2,a0
    12f6:	f6840593          	add	a1,s0,-152
    12fa:	00005517          	auipc	a0,0x5
    12fe:	e8e50513          	add	a0,a0,-370 # 6188 <malloc+0x8b8>
    1302:	00004097          	auipc	ra,0x4
    1306:	516080e7          	jalr	1302(ra) # 5818 <printf>
    exit(1);
    130a:	4505                	li	a0,1
    130c:	00004097          	auipc	ra,0x4
    1310:	1a4080e7          	jalr	420(ra) # 54b0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1314:	86aa                	mv	a3,a0
    1316:	f6840613          	add	a2,s0,-152
    131a:	85b2                	mv	a1,a2
    131c:	00005517          	auipc	a0,0x5
    1320:	e8c50513          	add	a0,a0,-372 # 61a8 <malloc+0x8d8>
    1324:	00004097          	auipc	ra,0x4
    1328:	4f4080e7          	jalr	1268(ra) # 5818 <printf>
    exit(1);
    132c:	4505                	li	a0,1
    132e:	00004097          	auipc	ra,0x4
    1332:	182080e7          	jalr	386(ra) # 54b0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1336:	567d                	li	a2,-1
    1338:	f6840593          	add	a1,s0,-152
    133c:	00005517          	auipc	a0,0x5
    1340:	e9450513          	add	a0,a0,-364 # 61d0 <malloc+0x900>
    1344:	00004097          	auipc	ra,0x4
    1348:	4d4080e7          	jalr	1236(ra) # 5818 <printf>
    exit(1);
    134c:	4505                	li	a0,1
    134e:	00004097          	auipc	ra,0x4
    1352:	162080e7          	jalr	354(ra) # 54b0 <exit>
    printf("fork failed\n");
    1356:	00005517          	auipc	a0,0x5
    135a:	2e250513          	add	a0,a0,738 # 6638 <malloc+0xd68>
    135e:	00004097          	auipc	ra,0x4
    1362:	4ba080e7          	jalr	1210(ra) # 5818 <printf>
    exit(1);
    1366:	4505                	li	a0,1
    1368:	00004097          	auipc	ra,0x4
    136c:	148080e7          	jalr	328(ra) # 54b0 <exit>
    exit(747); // OK
    1370:	2eb00513          	li	a0,747
    1374:	00004097          	auipc	ra,0x4
    1378:	13c080e7          	jalr	316(ra) # 54b0 <exit>
  int st = 0;
    137c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1380:	f5440513          	add	a0,s0,-172
    1384:	00004097          	auipc	ra,0x4
    1388:	134080e7          	jalr	308(ra) # 54b8 <wait>
  if(st != 747){
    138c:	f5442703          	lw	a4,-172(s0)
    1390:	2eb00793          	li	a5,747
    1394:	00f71663          	bne	a4,a5,13a0 <copyinstr2+0x1dc>
}
    1398:	60ae                	ld	ra,200(sp)
    139a:	640e                	ld	s0,192(sp)
    139c:	6169                	add	sp,sp,208
    139e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13a0:	00005517          	auipc	a0,0x5
    13a4:	e7850513          	add	a0,a0,-392 # 6218 <malloc+0x948>
    13a8:	00004097          	auipc	ra,0x4
    13ac:	470080e7          	jalr	1136(ra) # 5818 <printf>
    exit(1);
    13b0:	4505                	li	a0,1
    13b2:	00004097          	auipc	ra,0x4
    13b6:	0fe080e7          	jalr	254(ra) # 54b0 <exit>

00000000000013ba <truncate3>:
{
    13ba:	7159                	add	sp,sp,-112
    13bc:	f486                	sd	ra,104(sp)
    13be:	f0a2                	sd	s0,96(sp)
    13c0:	eca6                	sd	s1,88(sp)
    13c2:	e8ca                	sd	s2,80(sp)
    13c4:	e4ce                	sd	s3,72(sp)
    13c6:	e0d2                	sd	s4,64(sp)
    13c8:	fc56                	sd	s5,56(sp)
    13ca:	1880                	add	s0,sp,112
    13cc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13ce:	60100593          	li	a1,1537
    13d2:	00004517          	auipc	a0,0x4
    13d6:	67650513          	add	a0,a0,1654 # 5a48 <malloc+0x178>
    13da:	00004097          	auipc	ra,0x4
    13de:	116080e7          	jalr	278(ra) # 54f0 <open>
    13e2:	00004097          	auipc	ra,0x4
    13e6:	0f6080e7          	jalr	246(ra) # 54d8 <close>
  pid = fork();
    13ea:	00004097          	auipc	ra,0x4
    13ee:	0be080e7          	jalr	190(ra) # 54a8 <fork>
  if(pid < 0){
    13f2:	08054063          	bltz	a0,1472 <truncate3+0xb8>
  if(pid == 0){
    13f6:	e969                	bnez	a0,14c8 <truncate3+0x10e>
    13f8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13fc:	00004a17          	auipc	s4,0x4
    1400:	64ca0a13          	add	s4,s4,1612 # 5a48 <malloc+0x178>
      int n = write(fd, "1234567890", 10);
    1404:	00005a97          	auipc	s5,0x5
    1408:	e74a8a93          	add	s5,s5,-396 # 6278 <malloc+0x9a8>
      int fd = open("truncfile", O_WRONLY);
    140c:	4585                	li	a1,1
    140e:	8552                	mv	a0,s4
    1410:	00004097          	auipc	ra,0x4
    1414:	0e0080e7          	jalr	224(ra) # 54f0 <open>
    1418:	84aa                	mv	s1,a0
      if(fd < 0){
    141a:	06054a63          	bltz	a0,148e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    141e:	4629                	li	a2,10
    1420:	85d6                	mv	a1,s5
    1422:	00004097          	auipc	ra,0x4
    1426:	0ae080e7          	jalr	174(ra) # 54d0 <write>
      if(n != 10){
    142a:	47a9                	li	a5,10
    142c:	06f51f63          	bne	a0,a5,14aa <truncate3+0xf0>
      close(fd);
    1430:	8526                	mv	a0,s1
    1432:	00004097          	auipc	ra,0x4
    1436:	0a6080e7          	jalr	166(ra) # 54d8 <close>
      fd = open("truncfile", O_RDONLY);
    143a:	4581                	li	a1,0
    143c:	8552                	mv	a0,s4
    143e:	00004097          	auipc	ra,0x4
    1442:	0b2080e7          	jalr	178(ra) # 54f0 <open>
    1446:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1448:	02000613          	li	a2,32
    144c:	f9840593          	add	a1,s0,-104
    1450:	00004097          	auipc	ra,0x4
    1454:	078080e7          	jalr	120(ra) # 54c8 <read>
      close(fd);
    1458:	8526                	mv	a0,s1
    145a:	00004097          	auipc	ra,0x4
    145e:	07e080e7          	jalr	126(ra) # 54d8 <close>
    for(int i = 0; i < 100; i++){
    1462:	39fd                	addw	s3,s3,-1
    1464:	fa0994e3          	bnez	s3,140c <truncate3+0x52>
    exit(0);
    1468:	4501                	li	a0,0
    146a:	00004097          	auipc	ra,0x4
    146e:	046080e7          	jalr	70(ra) # 54b0 <exit>
    printf("%s: fork failed\n", s);
    1472:	85ca                	mv	a1,s2
    1474:	00005517          	auipc	a0,0x5
    1478:	dd450513          	add	a0,a0,-556 # 6248 <malloc+0x978>
    147c:	00004097          	auipc	ra,0x4
    1480:	39c080e7          	jalr	924(ra) # 5818 <printf>
    exit(1);
    1484:	4505                	li	a0,1
    1486:	00004097          	auipc	ra,0x4
    148a:	02a080e7          	jalr	42(ra) # 54b0 <exit>
        printf("%s: open failed\n", s);
    148e:	85ca                	mv	a1,s2
    1490:	00005517          	auipc	a0,0x5
    1494:	dd050513          	add	a0,a0,-560 # 6260 <malloc+0x990>
    1498:	00004097          	auipc	ra,0x4
    149c:	380080e7          	jalr	896(ra) # 5818 <printf>
        exit(1);
    14a0:	4505                	li	a0,1
    14a2:	00004097          	auipc	ra,0x4
    14a6:	00e080e7          	jalr	14(ra) # 54b0 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14aa:	862a                	mv	a2,a0
    14ac:	85ca                	mv	a1,s2
    14ae:	00005517          	auipc	a0,0x5
    14b2:	dda50513          	add	a0,a0,-550 # 6288 <malloc+0x9b8>
    14b6:	00004097          	auipc	ra,0x4
    14ba:	362080e7          	jalr	866(ra) # 5818 <printf>
        exit(1);
    14be:	4505                	li	a0,1
    14c0:	00004097          	auipc	ra,0x4
    14c4:	ff0080e7          	jalr	-16(ra) # 54b0 <exit>
    14c8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14cc:	00004a17          	auipc	s4,0x4
    14d0:	57ca0a13          	add	s4,s4,1404 # 5a48 <malloc+0x178>
    int n = write(fd, "xxx", 3);
    14d4:	00005a97          	auipc	s5,0x5
    14d8:	dd4a8a93          	add	s5,s5,-556 # 62a8 <malloc+0x9d8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14dc:	60100593          	li	a1,1537
    14e0:	8552                	mv	a0,s4
    14e2:	00004097          	auipc	ra,0x4
    14e6:	00e080e7          	jalr	14(ra) # 54f0 <open>
    14ea:	84aa                	mv	s1,a0
    if(fd < 0){
    14ec:	04054763          	bltz	a0,153a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14f0:	460d                	li	a2,3
    14f2:	85d6                	mv	a1,s5
    14f4:	00004097          	auipc	ra,0x4
    14f8:	fdc080e7          	jalr	-36(ra) # 54d0 <write>
    if(n != 3){
    14fc:	478d                	li	a5,3
    14fe:	04f51c63          	bne	a0,a5,1556 <truncate3+0x19c>
    close(fd);
    1502:	8526                	mv	a0,s1
    1504:	00004097          	auipc	ra,0x4
    1508:	fd4080e7          	jalr	-44(ra) # 54d8 <close>
  for(int i = 0; i < 150; i++){
    150c:	39fd                	addw	s3,s3,-1
    150e:	fc0997e3          	bnez	s3,14dc <truncate3+0x122>
  wait(&xstatus);
    1512:	fbc40513          	add	a0,s0,-68
    1516:	00004097          	auipc	ra,0x4
    151a:	fa2080e7          	jalr	-94(ra) # 54b8 <wait>
  unlink("truncfile");
    151e:	00004517          	auipc	a0,0x4
    1522:	52a50513          	add	a0,a0,1322 # 5a48 <malloc+0x178>
    1526:	00004097          	auipc	ra,0x4
    152a:	fda080e7          	jalr	-38(ra) # 5500 <unlink>
  exit(xstatus);
    152e:	fbc42503          	lw	a0,-68(s0)
    1532:	00004097          	auipc	ra,0x4
    1536:	f7e080e7          	jalr	-130(ra) # 54b0 <exit>
      printf("%s: open failed\n", s);
    153a:	85ca                	mv	a1,s2
    153c:	00005517          	auipc	a0,0x5
    1540:	d2450513          	add	a0,a0,-732 # 6260 <malloc+0x990>
    1544:	00004097          	auipc	ra,0x4
    1548:	2d4080e7          	jalr	724(ra) # 5818 <printf>
      exit(1);
    154c:	4505                	li	a0,1
    154e:	00004097          	auipc	ra,0x4
    1552:	f62080e7          	jalr	-158(ra) # 54b0 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1556:	862a                	mv	a2,a0
    1558:	85ca                	mv	a1,s2
    155a:	00005517          	auipc	a0,0x5
    155e:	d5650513          	add	a0,a0,-682 # 62b0 <malloc+0x9e0>
    1562:	00004097          	auipc	ra,0x4
    1566:	2b6080e7          	jalr	694(ra) # 5818 <printf>
      exit(1);
    156a:	4505                	li	a0,1
    156c:	00004097          	auipc	ra,0x4
    1570:	f44080e7          	jalr	-188(ra) # 54b0 <exit>

0000000000001574 <exectest>:
{
    1574:	715d                	add	sp,sp,-80
    1576:	e486                	sd	ra,72(sp)
    1578:	e0a2                	sd	s0,64(sp)
    157a:	fc26                	sd	s1,56(sp)
    157c:	f84a                	sd	s2,48(sp)
    157e:	0880                	add	s0,sp,80
    1580:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1582:	00004797          	auipc	a5,0x4
    1586:	46e78793          	add	a5,a5,1134 # 59f0 <malloc+0x120>
    158a:	fcf43023          	sd	a5,-64(s0)
    158e:	00005797          	auipc	a5,0x5
    1592:	d4278793          	add	a5,a5,-702 # 62d0 <malloc+0xa00>
    1596:	fcf43423          	sd	a5,-56(s0)
    159a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    159e:	00005517          	auipc	a0,0x5
    15a2:	d3a50513          	add	a0,a0,-710 # 62d8 <malloc+0xa08>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	f5a080e7          	jalr	-166(ra) # 5500 <unlink>
  pid = fork();
    15ae:	00004097          	auipc	ra,0x4
    15b2:	efa080e7          	jalr	-262(ra) # 54a8 <fork>
  if(pid < 0) {
    15b6:	04054663          	bltz	a0,1602 <exectest+0x8e>
    15ba:	84aa                	mv	s1,a0
  if(pid == 0) {
    15bc:	e959                	bnez	a0,1652 <exectest+0xde>
    close(1);
    15be:	4505                	li	a0,1
    15c0:	00004097          	auipc	ra,0x4
    15c4:	f18080e7          	jalr	-232(ra) # 54d8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15c8:	20100593          	li	a1,513
    15cc:	00005517          	auipc	a0,0x5
    15d0:	d0c50513          	add	a0,a0,-756 # 62d8 <malloc+0xa08>
    15d4:	00004097          	auipc	ra,0x4
    15d8:	f1c080e7          	jalr	-228(ra) # 54f0 <open>
    if(fd < 0) {
    15dc:	04054163          	bltz	a0,161e <exectest+0xaa>
    if(fd != 1) {
    15e0:	4785                	li	a5,1
    15e2:	04f50c63          	beq	a0,a5,163a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00005517          	auipc	a0,0x5
    15ec:	d1050513          	add	a0,a0,-752 # 62f8 <malloc+0xa28>
    15f0:	00004097          	auipc	ra,0x4
    15f4:	228080e7          	jalr	552(ra) # 5818 <printf>
      exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00004097          	auipc	ra,0x4
    15fe:	eb6080e7          	jalr	-330(ra) # 54b0 <exit>
     printf("%s: fork failed\n", s);
    1602:	85ca                	mv	a1,s2
    1604:	00005517          	auipc	a0,0x5
    1608:	c4450513          	add	a0,a0,-956 # 6248 <malloc+0x978>
    160c:	00004097          	auipc	ra,0x4
    1610:	20c080e7          	jalr	524(ra) # 5818 <printf>
     exit(1);
    1614:	4505                	li	a0,1
    1616:	00004097          	auipc	ra,0x4
    161a:	e9a080e7          	jalr	-358(ra) # 54b0 <exit>
      printf("%s: create failed\n", s);
    161e:	85ca                	mv	a1,s2
    1620:	00005517          	auipc	a0,0x5
    1624:	cc050513          	add	a0,a0,-832 # 62e0 <malloc+0xa10>
    1628:	00004097          	auipc	ra,0x4
    162c:	1f0080e7          	jalr	496(ra) # 5818 <printf>
      exit(1);
    1630:	4505                	li	a0,1
    1632:	00004097          	auipc	ra,0x4
    1636:	e7e080e7          	jalr	-386(ra) # 54b0 <exit>
    if(exec("echo", echoargv) < 0){
    163a:	fc040593          	add	a1,s0,-64
    163e:	00004517          	auipc	a0,0x4
    1642:	3b250513          	add	a0,a0,946 # 59f0 <malloc+0x120>
    1646:	00004097          	auipc	ra,0x4
    164a:	ea2080e7          	jalr	-350(ra) # 54e8 <exec>
    164e:	02054163          	bltz	a0,1670 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1652:	fdc40513          	add	a0,s0,-36
    1656:	00004097          	auipc	ra,0x4
    165a:	e62080e7          	jalr	-414(ra) # 54b8 <wait>
    165e:	02951763          	bne	a0,s1,168c <exectest+0x118>
  if(xstatus != 0)
    1662:	fdc42503          	lw	a0,-36(s0)
    1666:	cd0d                	beqz	a0,16a0 <exectest+0x12c>
    exit(xstatus);
    1668:	00004097          	auipc	ra,0x4
    166c:	e48080e7          	jalr	-440(ra) # 54b0 <exit>
      printf("%s: exec echo failed\n", s);
    1670:	85ca                	mv	a1,s2
    1672:	00005517          	auipc	a0,0x5
    1676:	c9650513          	add	a0,a0,-874 # 6308 <malloc+0xa38>
    167a:	00004097          	auipc	ra,0x4
    167e:	19e080e7          	jalr	414(ra) # 5818 <printf>
      exit(1);
    1682:	4505                	li	a0,1
    1684:	00004097          	auipc	ra,0x4
    1688:	e2c080e7          	jalr	-468(ra) # 54b0 <exit>
    printf("%s: wait failed!\n", s);
    168c:	85ca                	mv	a1,s2
    168e:	00005517          	auipc	a0,0x5
    1692:	c9250513          	add	a0,a0,-878 # 6320 <malloc+0xa50>
    1696:	00004097          	auipc	ra,0x4
    169a:	182080e7          	jalr	386(ra) # 5818 <printf>
    169e:	b7d1                	j	1662 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16a0:	4581                	li	a1,0
    16a2:	00005517          	auipc	a0,0x5
    16a6:	c3650513          	add	a0,a0,-970 # 62d8 <malloc+0xa08>
    16aa:	00004097          	auipc	ra,0x4
    16ae:	e46080e7          	jalr	-442(ra) # 54f0 <open>
  if(fd < 0) {
    16b2:	02054a63          	bltz	a0,16e6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16b6:	4609                	li	a2,2
    16b8:	fb840593          	add	a1,s0,-72
    16bc:	00004097          	auipc	ra,0x4
    16c0:	e0c080e7          	jalr	-500(ra) # 54c8 <read>
    16c4:	4789                	li	a5,2
    16c6:	02f50e63          	beq	a0,a5,1702 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16ca:	85ca                	mv	a1,s2
    16cc:	00004517          	auipc	a0,0x4
    16d0:	6c450513          	add	a0,a0,1732 # 5d90 <malloc+0x4c0>
    16d4:	00004097          	auipc	ra,0x4
    16d8:	144080e7          	jalr	324(ra) # 5818 <printf>
    exit(1);
    16dc:	4505                	li	a0,1
    16de:	00004097          	auipc	ra,0x4
    16e2:	dd2080e7          	jalr	-558(ra) # 54b0 <exit>
    printf("%s: open failed\n", s);
    16e6:	85ca                	mv	a1,s2
    16e8:	00005517          	auipc	a0,0x5
    16ec:	b7850513          	add	a0,a0,-1160 # 6260 <malloc+0x990>
    16f0:	00004097          	auipc	ra,0x4
    16f4:	128080e7          	jalr	296(ra) # 5818 <printf>
    exit(1);
    16f8:	4505                	li	a0,1
    16fa:	00004097          	auipc	ra,0x4
    16fe:	db6080e7          	jalr	-586(ra) # 54b0 <exit>
  unlink("echo-ok");
    1702:	00005517          	auipc	a0,0x5
    1706:	bd650513          	add	a0,a0,-1066 # 62d8 <malloc+0xa08>
    170a:	00004097          	auipc	ra,0x4
    170e:	df6080e7          	jalr	-522(ra) # 5500 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1712:	fb844703          	lbu	a4,-72(s0)
    1716:	04f00793          	li	a5,79
    171a:	00f71863          	bne	a4,a5,172a <exectest+0x1b6>
    171e:	fb944703          	lbu	a4,-71(s0)
    1722:	04b00793          	li	a5,75
    1726:	02f70063          	beq	a4,a5,1746 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    172a:	85ca                	mv	a1,s2
    172c:	00005517          	auipc	a0,0x5
    1730:	c0c50513          	add	a0,a0,-1012 # 6338 <malloc+0xa68>
    1734:	00004097          	auipc	ra,0x4
    1738:	0e4080e7          	jalr	228(ra) # 5818 <printf>
    exit(1);
    173c:	4505                	li	a0,1
    173e:	00004097          	auipc	ra,0x4
    1742:	d72080e7          	jalr	-654(ra) # 54b0 <exit>
    exit(0);
    1746:	4501                	li	a0,0
    1748:	00004097          	auipc	ra,0x4
    174c:	d68080e7          	jalr	-664(ra) # 54b0 <exit>

0000000000001750 <pipe1>:
{
    1750:	711d                	add	sp,sp,-96
    1752:	ec86                	sd	ra,88(sp)
    1754:	e8a2                	sd	s0,80(sp)
    1756:	e4a6                	sd	s1,72(sp)
    1758:	e0ca                	sd	s2,64(sp)
    175a:	fc4e                	sd	s3,56(sp)
    175c:	f852                	sd	s4,48(sp)
    175e:	f456                	sd	s5,40(sp)
    1760:	f05a                	sd	s6,32(sp)
    1762:	ec5e                	sd	s7,24(sp)
    1764:	1080                	add	s0,sp,96
    1766:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1768:	fa840513          	add	a0,s0,-88
    176c:	00004097          	auipc	ra,0x4
    1770:	d54080e7          	jalr	-684(ra) # 54c0 <pipe>
    1774:	e93d                	bnez	a0,17ea <pipe1+0x9a>
    1776:	84aa                	mv	s1,a0
  pid = fork();
    1778:	00004097          	auipc	ra,0x4
    177c:	d30080e7          	jalr	-720(ra) # 54a8 <fork>
    1780:	8a2a                	mv	s4,a0
  if(pid == 0){
    1782:	c151                	beqz	a0,1806 <pipe1+0xb6>
  } else if(pid > 0){
    1784:	16a05d63          	blez	a0,18fe <pipe1+0x1ae>
    close(fds[1]);
    1788:	fac42503          	lw	a0,-84(s0)
    178c:	00004097          	auipc	ra,0x4
    1790:	d4c080e7          	jalr	-692(ra) # 54d8 <close>
    total = 0;
    1794:	8a26                	mv	s4,s1
    cc = 1;
    1796:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	0000aa97          	auipc	s5,0xa
    179c:	1b8a8a93          	add	s5,s5,440 # b950 <buf>
    17a0:	864e                	mv	a2,s3
    17a2:	85d6                	mv	a1,s5
    17a4:	fa842503          	lw	a0,-88(s0)
    17a8:	00004097          	auipc	ra,0x4
    17ac:	d20080e7          	jalr	-736(ra) # 54c8 <read>
    17b0:	10a05263          	blez	a0,18b4 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17b4:	0000a717          	auipc	a4,0xa
    17b8:	19c70713          	add	a4,a4,412 # b950 <buf>
    17bc:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17c0:	00074683          	lbu	a3,0(a4)
    17c4:	0ff4f793          	zext.b	a5,s1
    17c8:	2485                	addw	s1,s1,1
    17ca:	0cf69163          	bne	a3,a5,188c <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17ce:	0705                	add	a4,a4,1
    17d0:	fec498e3          	bne	s1,a2,17c0 <pipe1+0x70>
      total += n;
    17d4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17d8:	0019979b          	sllw	a5,s3,0x1
    17dc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17e0:	670d                	lui	a4,0x3
    17e2:	fb377fe3          	bgeu	a4,s3,17a0 <pipe1+0x50>
        cc = sizeof(buf);
    17e6:	698d                	lui	s3,0x3
    17e8:	bf65                	j	17a0 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    17ea:	85ca                	mv	a1,s2
    17ec:	00005517          	auipc	a0,0x5
    17f0:	b6450513          	add	a0,a0,-1180 # 6350 <malloc+0xa80>
    17f4:	00004097          	auipc	ra,0x4
    17f8:	024080e7          	jalr	36(ra) # 5818 <printf>
    exit(1);
    17fc:	4505                	li	a0,1
    17fe:	00004097          	auipc	ra,0x4
    1802:	cb2080e7          	jalr	-846(ra) # 54b0 <exit>
    close(fds[0]);
    1806:	fa842503          	lw	a0,-88(s0)
    180a:	00004097          	auipc	ra,0x4
    180e:	cce080e7          	jalr	-818(ra) # 54d8 <close>
    for(n = 0; n < N; n++){
    1812:	0000ab17          	auipc	s6,0xa
    1816:	13eb0b13          	add	s6,s6,318 # b950 <buf>
    181a:	416004bb          	negw	s1,s6
    181e:	0ff4f493          	zext.b	s1,s1
    1822:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1826:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1828:	6a85                	lui	s5,0x1
    182a:	42da8a93          	add	s5,s5,1069 # 142d <truncate3+0x73>
{
    182e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1830:	0097873b          	addw	a4,a5,s1
    1834:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1838:	0785                	add	a5,a5,1
    183a:	fef99be3          	bne	s3,a5,1830 <pipe1+0xe0>
        buf[i] = seq++;
    183e:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1842:	40900613          	li	a2,1033
    1846:	85de                	mv	a1,s7
    1848:	fac42503          	lw	a0,-84(s0)
    184c:	00004097          	auipc	ra,0x4
    1850:	c84080e7          	jalr	-892(ra) # 54d0 <write>
    1854:	40900793          	li	a5,1033
    1858:	00f51c63          	bne	a0,a5,1870 <pipe1+0x120>
    for(n = 0; n < N; n++){
    185c:	24a5                	addw	s1,s1,9
    185e:	0ff4f493          	zext.b	s1,s1
    1862:	fd5a16e3          	bne	s4,s5,182e <pipe1+0xde>
    exit(0);
    1866:	4501                	li	a0,0
    1868:	00004097          	auipc	ra,0x4
    186c:	c48080e7          	jalr	-952(ra) # 54b0 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1870:	85ca                	mv	a1,s2
    1872:	00005517          	auipc	a0,0x5
    1876:	af650513          	add	a0,a0,-1290 # 6368 <malloc+0xa98>
    187a:	00004097          	auipc	ra,0x4
    187e:	f9e080e7          	jalr	-98(ra) # 5818 <printf>
        exit(1);
    1882:	4505                	li	a0,1
    1884:	00004097          	auipc	ra,0x4
    1888:	c2c080e7          	jalr	-980(ra) # 54b0 <exit>
          printf("%s: pipe1 oops 2\n", s);
    188c:	85ca                	mv	a1,s2
    188e:	00005517          	auipc	a0,0x5
    1892:	af250513          	add	a0,a0,-1294 # 6380 <malloc+0xab0>
    1896:	00004097          	auipc	ra,0x4
    189a:	f82080e7          	jalr	-126(ra) # 5818 <printf>
}
    189e:	60e6                	ld	ra,88(sp)
    18a0:	6446                	ld	s0,80(sp)
    18a2:	64a6                	ld	s1,72(sp)
    18a4:	6906                	ld	s2,64(sp)
    18a6:	79e2                	ld	s3,56(sp)
    18a8:	7a42                	ld	s4,48(sp)
    18aa:	7aa2                	ld	s5,40(sp)
    18ac:	7b02                	ld	s6,32(sp)
    18ae:	6be2                	ld	s7,24(sp)
    18b0:	6125                	add	sp,sp,96
    18b2:	8082                	ret
    if(total != N * SZ){
    18b4:	6785                	lui	a5,0x1
    18b6:	42d78793          	add	a5,a5,1069 # 142d <truncate3+0x73>
    18ba:	02fa0063          	beq	s4,a5,18da <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18be:	85d2                	mv	a1,s4
    18c0:	00005517          	auipc	a0,0x5
    18c4:	ad850513          	add	a0,a0,-1320 # 6398 <malloc+0xac8>
    18c8:	00004097          	auipc	ra,0x4
    18cc:	f50080e7          	jalr	-176(ra) # 5818 <printf>
      exit(1);
    18d0:	4505                	li	a0,1
    18d2:	00004097          	auipc	ra,0x4
    18d6:	bde080e7          	jalr	-1058(ra) # 54b0 <exit>
    close(fds[0]);
    18da:	fa842503          	lw	a0,-88(s0)
    18de:	00004097          	auipc	ra,0x4
    18e2:	bfa080e7          	jalr	-1030(ra) # 54d8 <close>
    wait(&xstatus);
    18e6:	fa440513          	add	a0,s0,-92
    18ea:	00004097          	auipc	ra,0x4
    18ee:	bce080e7          	jalr	-1074(ra) # 54b8 <wait>
    exit(xstatus);
    18f2:	fa442503          	lw	a0,-92(s0)
    18f6:	00004097          	auipc	ra,0x4
    18fa:	bba080e7          	jalr	-1094(ra) # 54b0 <exit>
    printf("%s: fork() failed\n", s);
    18fe:	85ca                	mv	a1,s2
    1900:	00005517          	auipc	a0,0x5
    1904:	ab850513          	add	a0,a0,-1352 # 63b8 <malloc+0xae8>
    1908:	00004097          	auipc	ra,0x4
    190c:	f10080e7          	jalr	-240(ra) # 5818 <printf>
    exit(1);
    1910:	4505                	li	a0,1
    1912:	00004097          	auipc	ra,0x4
    1916:	b9e080e7          	jalr	-1122(ra) # 54b0 <exit>

000000000000191a <exitwait>:
{
    191a:	7139                	add	sp,sp,-64
    191c:	fc06                	sd	ra,56(sp)
    191e:	f822                	sd	s0,48(sp)
    1920:	f426                	sd	s1,40(sp)
    1922:	f04a                	sd	s2,32(sp)
    1924:	ec4e                	sd	s3,24(sp)
    1926:	e852                	sd	s4,16(sp)
    1928:	0080                	add	s0,sp,64
    192a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    192c:	4901                	li	s2,0
    192e:	06400993          	li	s3,100
    pid = fork();
    1932:	00004097          	auipc	ra,0x4
    1936:	b76080e7          	jalr	-1162(ra) # 54a8 <fork>
    193a:	84aa                	mv	s1,a0
    if(pid < 0){
    193c:	02054a63          	bltz	a0,1970 <exitwait+0x56>
    if(pid){
    1940:	c151                	beqz	a0,19c4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1942:	fcc40513          	add	a0,s0,-52
    1946:	00004097          	auipc	ra,0x4
    194a:	b72080e7          	jalr	-1166(ra) # 54b8 <wait>
    194e:	02951f63          	bne	a0,s1,198c <exitwait+0x72>
      if(i != xstate) {
    1952:	fcc42783          	lw	a5,-52(s0)
    1956:	05279963          	bne	a5,s2,19a8 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    195a:	2905                	addw	s2,s2,1
    195c:	fd391be3          	bne	s2,s3,1932 <exitwait+0x18>
}
    1960:	70e2                	ld	ra,56(sp)
    1962:	7442                	ld	s0,48(sp)
    1964:	74a2                	ld	s1,40(sp)
    1966:	7902                	ld	s2,32(sp)
    1968:	69e2                	ld	s3,24(sp)
    196a:	6a42                	ld	s4,16(sp)
    196c:	6121                	add	sp,sp,64
    196e:	8082                	ret
      printf("%s: fork failed\n", s);
    1970:	85d2                	mv	a1,s4
    1972:	00005517          	auipc	a0,0x5
    1976:	8d650513          	add	a0,a0,-1834 # 6248 <malloc+0x978>
    197a:	00004097          	auipc	ra,0x4
    197e:	e9e080e7          	jalr	-354(ra) # 5818 <printf>
      exit(1);
    1982:	4505                	li	a0,1
    1984:	00004097          	auipc	ra,0x4
    1988:	b2c080e7          	jalr	-1236(ra) # 54b0 <exit>
        printf("%s: wait wrong pid\n", s);
    198c:	85d2                	mv	a1,s4
    198e:	00005517          	auipc	a0,0x5
    1992:	a4250513          	add	a0,a0,-1470 # 63d0 <malloc+0xb00>
    1996:	00004097          	auipc	ra,0x4
    199a:	e82080e7          	jalr	-382(ra) # 5818 <printf>
        exit(1);
    199e:	4505                	li	a0,1
    19a0:	00004097          	auipc	ra,0x4
    19a4:	b10080e7          	jalr	-1264(ra) # 54b0 <exit>
        printf("%s: wait wrong exit status\n", s);
    19a8:	85d2                	mv	a1,s4
    19aa:	00005517          	auipc	a0,0x5
    19ae:	a3e50513          	add	a0,a0,-1474 # 63e8 <malloc+0xb18>
    19b2:	00004097          	auipc	ra,0x4
    19b6:	e66080e7          	jalr	-410(ra) # 5818 <printf>
        exit(1);
    19ba:	4505                	li	a0,1
    19bc:	00004097          	auipc	ra,0x4
    19c0:	af4080e7          	jalr	-1292(ra) # 54b0 <exit>
      exit(i);
    19c4:	854a                	mv	a0,s2
    19c6:	00004097          	auipc	ra,0x4
    19ca:	aea080e7          	jalr	-1302(ra) # 54b0 <exit>

00000000000019ce <twochildren>:
{
    19ce:	1101                	add	sp,sp,-32
    19d0:	ec06                	sd	ra,24(sp)
    19d2:	e822                	sd	s0,16(sp)
    19d4:	e426                	sd	s1,8(sp)
    19d6:	e04a                	sd	s2,0(sp)
    19d8:	1000                	add	s0,sp,32
    19da:	892a                	mv	s2,a0
    19dc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19e0:	00004097          	auipc	ra,0x4
    19e4:	ac8080e7          	jalr	-1336(ra) # 54a8 <fork>
    if(pid1 < 0){
    19e8:	02054c63          	bltz	a0,1a20 <twochildren+0x52>
    if(pid1 == 0){
    19ec:	c921                	beqz	a0,1a3c <twochildren+0x6e>
      int pid2 = fork();
    19ee:	00004097          	auipc	ra,0x4
    19f2:	aba080e7          	jalr	-1350(ra) # 54a8 <fork>
      if(pid2 < 0){
    19f6:	04054763          	bltz	a0,1a44 <twochildren+0x76>
      if(pid2 == 0){
    19fa:	c13d                	beqz	a0,1a60 <twochildren+0x92>
        wait(0);
    19fc:	4501                	li	a0,0
    19fe:	00004097          	auipc	ra,0x4
    1a02:	aba080e7          	jalr	-1350(ra) # 54b8 <wait>
        wait(0);
    1a06:	4501                	li	a0,0
    1a08:	00004097          	auipc	ra,0x4
    1a0c:	ab0080e7          	jalr	-1360(ra) # 54b8 <wait>
  for(int i = 0; i < 1000; i++){
    1a10:	34fd                	addw	s1,s1,-1
    1a12:	f4f9                	bnez	s1,19e0 <twochildren+0x12>
}
    1a14:	60e2                	ld	ra,24(sp)
    1a16:	6442                	ld	s0,16(sp)
    1a18:	64a2                	ld	s1,8(sp)
    1a1a:	6902                	ld	s2,0(sp)
    1a1c:	6105                	add	sp,sp,32
    1a1e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a20:	85ca                	mv	a1,s2
    1a22:	00005517          	auipc	a0,0x5
    1a26:	82650513          	add	a0,a0,-2010 # 6248 <malloc+0x978>
    1a2a:	00004097          	auipc	ra,0x4
    1a2e:	dee080e7          	jalr	-530(ra) # 5818 <printf>
      exit(1);
    1a32:	4505                	li	a0,1
    1a34:	00004097          	auipc	ra,0x4
    1a38:	a7c080e7          	jalr	-1412(ra) # 54b0 <exit>
      exit(0);
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	a74080e7          	jalr	-1420(ra) # 54b0 <exit>
        printf("%s: fork failed\n", s);
    1a44:	85ca                	mv	a1,s2
    1a46:	00005517          	auipc	a0,0x5
    1a4a:	80250513          	add	a0,a0,-2046 # 6248 <malloc+0x978>
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	dca080e7          	jalr	-566(ra) # 5818 <printf>
        exit(1);
    1a56:	4505                	li	a0,1
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	a58080e7          	jalr	-1448(ra) # 54b0 <exit>
        exit(0);
    1a60:	00004097          	auipc	ra,0x4
    1a64:	a50080e7          	jalr	-1456(ra) # 54b0 <exit>

0000000000001a68 <forkfork>:
{
    1a68:	7179                	add	sp,sp,-48
    1a6a:	f406                	sd	ra,40(sp)
    1a6c:	f022                	sd	s0,32(sp)
    1a6e:	ec26                	sd	s1,24(sp)
    1a70:	1800                	add	s0,sp,48
    1a72:	84aa                	mv	s1,a0
    int pid = fork();
    1a74:	00004097          	auipc	ra,0x4
    1a78:	a34080e7          	jalr	-1484(ra) # 54a8 <fork>
    if(pid < 0){
    1a7c:	04054163          	bltz	a0,1abe <forkfork+0x56>
    if(pid == 0){
    1a80:	cd29                	beqz	a0,1ada <forkfork+0x72>
    int pid = fork();
    1a82:	00004097          	auipc	ra,0x4
    1a86:	a26080e7          	jalr	-1498(ra) # 54a8 <fork>
    if(pid < 0){
    1a8a:	02054a63          	bltz	a0,1abe <forkfork+0x56>
    if(pid == 0){
    1a8e:	c531                	beqz	a0,1ada <forkfork+0x72>
    wait(&xstatus);
    1a90:	fdc40513          	add	a0,s0,-36
    1a94:	00004097          	auipc	ra,0x4
    1a98:	a24080e7          	jalr	-1500(ra) # 54b8 <wait>
    if(xstatus != 0) {
    1a9c:	fdc42783          	lw	a5,-36(s0)
    1aa0:	ebbd                	bnez	a5,1b16 <forkfork+0xae>
    wait(&xstatus);
    1aa2:	fdc40513          	add	a0,s0,-36
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	a12080e7          	jalr	-1518(ra) # 54b8 <wait>
    if(xstatus != 0) {
    1aae:	fdc42783          	lw	a5,-36(s0)
    1ab2:	e3b5                	bnez	a5,1b16 <forkfork+0xae>
}
    1ab4:	70a2                	ld	ra,40(sp)
    1ab6:	7402                	ld	s0,32(sp)
    1ab8:	64e2                	ld	s1,24(sp)
    1aba:	6145                	add	sp,sp,48
    1abc:	8082                	ret
      printf("%s: fork failed", s);
    1abe:	85a6                	mv	a1,s1
    1ac0:	00005517          	auipc	a0,0x5
    1ac4:	94850513          	add	a0,a0,-1720 # 6408 <malloc+0xb38>
    1ac8:	00004097          	auipc	ra,0x4
    1acc:	d50080e7          	jalr	-688(ra) # 5818 <printf>
      exit(1);
    1ad0:	4505                	li	a0,1
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	9de080e7          	jalr	-1570(ra) # 54b0 <exit>
{
    1ada:	0c800493          	li	s1,200
        int pid1 = fork();
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	9ca080e7          	jalr	-1590(ra) # 54a8 <fork>
        if(pid1 < 0){
    1ae6:	00054f63          	bltz	a0,1b04 <forkfork+0x9c>
        if(pid1 == 0){
    1aea:	c115                	beqz	a0,1b0e <forkfork+0xa6>
        wait(0);
    1aec:	4501                	li	a0,0
    1aee:	00004097          	auipc	ra,0x4
    1af2:	9ca080e7          	jalr	-1590(ra) # 54b8 <wait>
      for(int j = 0; j < 200; j++){
    1af6:	34fd                	addw	s1,s1,-1
    1af8:	f0fd                	bnez	s1,1ade <forkfork+0x76>
      exit(0);
    1afa:	4501                	li	a0,0
    1afc:	00004097          	auipc	ra,0x4
    1b00:	9b4080e7          	jalr	-1612(ra) # 54b0 <exit>
          exit(1);
    1b04:	4505                	li	a0,1
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	9aa080e7          	jalr	-1622(ra) # 54b0 <exit>
          exit(0);
    1b0e:	00004097          	auipc	ra,0x4
    1b12:	9a2080e7          	jalr	-1630(ra) # 54b0 <exit>
      printf("%s: fork in child failed", s);
    1b16:	85a6                	mv	a1,s1
    1b18:	00005517          	auipc	a0,0x5
    1b1c:	90050513          	add	a0,a0,-1792 # 6418 <malloc+0xb48>
    1b20:	00004097          	auipc	ra,0x4
    1b24:	cf8080e7          	jalr	-776(ra) # 5818 <printf>
      exit(1);
    1b28:	4505                	li	a0,1
    1b2a:	00004097          	auipc	ra,0x4
    1b2e:	986080e7          	jalr	-1658(ra) # 54b0 <exit>

0000000000001b32 <reparent2>:
{
    1b32:	1101                	add	sp,sp,-32
    1b34:	ec06                	sd	ra,24(sp)
    1b36:	e822                	sd	s0,16(sp)
    1b38:	e426                	sd	s1,8(sp)
    1b3a:	1000                	add	s0,sp,32
    1b3c:	32000493          	li	s1,800
    int pid1 = fork();
    1b40:	00004097          	auipc	ra,0x4
    1b44:	968080e7          	jalr	-1688(ra) # 54a8 <fork>
    if(pid1 < 0){
    1b48:	00054f63          	bltz	a0,1b66 <reparent2+0x34>
    if(pid1 == 0){
    1b4c:	c915                	beqz	a0,1b80 <reparent2+0x4e>
    wait(0);
    1b4e:	4501                	li	a0,0
    1b50:	00004097          	auipc	ra,0x4
    1b54:	968080e7          	jalr	-1688(ra) # 54b8 <wait>
  for(int i = 0; i < 800; i++){
    1b58:	34fd                	addw	s1,s1,-1
    1b5a:	f0fd                	bnez	s1,1b40 <reparent2+0xe>
  exit(0);
    1b5c:	4501                	li	a0,0
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	952080e7          	jalr	-1710(ra) # 54b0 <exit>
      printf("fork failed\n");
    1b66:	00005517          	auipc	a0,0x5
    1b6a:	ad250513          	add	a0,a0,-1326 # 6638 <malloc+0xd68>
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	caa080e7          	jalr	-854(ra) # 5818 <printf>
      exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	938080e7          	jalr	-1736(ra) # 54b0 <exit>
      fork();
    1b80:	00004097          	auipc	ra,0x4
    1b84:	928080e7          	jalr	-1752(ra) # 54a8 <fork>
      fork();
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	920080e7          	jalr	-1760(ra) # 54a8 <fork>
      exit(0);
    1b90:	4501                	li	a0,0
    1b92:	00004097          	auipc	ra,0x4
    1b96:	91e080e7          	jalr	-1762(ra) # 54b0 <exit>

0000000000001b9a <createdelete>:
{
    1b9a:	7175                	add	sp,sp,-144
    1b9c:	e506                	sd	ra,136(sp)
    1b9e:	e122                	sd	s0,128(sp)
    1ba0:	fca6                	sd	s1,120(sp)
    1ba2:	f8ca                	sd	s2,112(sp)
    1ba4:	f4ce                	sd	s3,104(sp)
    1ba6:	f0d2                	sd	s4,96(sp)
    1ba8:	ecd6                	sd	s5,88(sp)
    1baa:	e8da                	sd	s6,80(sp)
    1bac:	e4de                	sd	s7,72(sp)
    1bae:	e0e2                	sd	s8,64(sp)
    1bb0:	fc66                	sd	s9,56(sp)
    1bb2:	0900                	add	s0,sp,144
    1bb4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bb6:	4901                	li	s2,0
    1bb8:	4991                	li	s3,4
    pid = fork();
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	8ee080e7          	jalr	-1810(ra) # 54a8 <fork>
    1bc2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bc4:	02054f63          	bltz	a0,1c02 <createdelete+0x68>
    if(pid == 0){
    1bc8:	c939                	beqz	a0,1c1e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bca:	2905                	addw	s2,s2,1
    1bcc:	ff3917e3          	bne	s2,s3,1bba <createdelete+0x20>
    1bd0:	4491                	li	s1,4
    wait(&xstatus);
    1bd2:	f7c40513          	add	a0,s0,-132
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	8e2080e7          	jalr	-1822(ra) # 54b8 <wait>
    if(xstatus != 0)
    1bde:	f7c42903          	lw	s2,-132(s0)
    1be2:	0e091263          	bnez	s2,1cc6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1be6:	34fd                	addw	s1,s1,-1
    1be8:	f4ed                	bnez	s1,1bd2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bea:	f8040123          	sb	zero,-126(s0)
    1bee:	03000993          	li	s3,48
    1bf2:	5a7d                	li	s4,-1
    1bf4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bfa:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bfc:	07400a93          	li	s5,116
    1c00:	a29d                	j	1d66 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c02:	85e6                	mv	a1,s9
    1c04:	00005517          	auipc	a0,0x5
    1c08:	a3450513          	add	a0,a0,-1484 # 6638 <malloc+0xd68>
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	c0c080e7          	jalr	-1012(ra) # 5818 <printf>
      exit(1);
    1c14:	4505                	li	a0,1
    1c16:	00004097          	auipc	ra,0x4
    1c1a:	89a080e7          	jalr	-1894(ra) # 54b0 <exit>
      name[0] = 'p' + pi;
    1c1e:	0709091b          	addw	s2,s2,112
    1c22:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c26:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c2a:	4951                	li	s2,20
    1c2c:	a015                	j	1c50 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c2e:	85e6                	mv	a1,s9
    1c30:	00004517          	auipc	a0,0x4
    1c34:	6b050513          	add	a0,a0,1712 # 62e0 <malloc+0xa10>
    1c38:	00004097          	auipc	ra,0x4
    1c3c:	be0080e7          	jalr	-1056(ra) # 5818 <printf>
          exit(1);
    1c40:	4505                	li	a0,1
    1c42:	00004097          	auipc	ra,0x4
    1c46:	86e080e7          	jalr	-1938(ra) # 54b0 <exit>
      for(i = 0; i < N; i++){
    1c4a:	2485                	addw	s1,s1,1
    1c4c:	07248863          	beq	s1,s2,1cbc <createdelete+0x122>
        name[1] = '0' + i;
    1c50:	0304879b          	addw	a5,s1,48
    1c54:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c58:	20200593          	li	a1,514
    1c5c:	f8040513          	add	a0,s0,-128
    1c60:	00004097          	auipc	ra,0x4
    1c64:	890080e7          	jalr	-1904(ra) # 54f0 <open>
        if(fd < 0){
    1c68:	fc0543e3          	bltz	a0,1c2e <createdelete+0x94>
        close(fd);
    1c6c:	00004097          	auipc	ra,0x4
    1c70:	86c080e7          	jalr	-1940(ra) # 54d8 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c74:	fc905be3          	blez	s1,1c4a <createdelete+0xb0>
    1c78:	0014f793          	and	a5,s1,1
    1c7c:	f7f9                	bnez	a5,1c4a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c7e:	01f4d79b          	srlw	a5,s1,0x1f
    1c82:	9fa5                	addw	a5,a5,s1
    1c84:	4017d79b          	sraw	a5,a5,0x1
    1c88:	0307879b          	addw	a5,a5,48
    1c8c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c90:	f8040513          	add	a0,s0,-128
    1c94:	00004097          	auipc	ra,0x4
    1c98:	86c080e7          	jalr	-1940(ra) # 5500 <unlink>
    1c9c:	fa0557e3          	bgez	a0,1c4a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1ca0:	85e6                	mv	a1,s9
    1ca2:	00004517          	auipc	a0,0x4
    1ca6:	79650513          	add	a0,a0,1942 # 6438 <malloc+0xb68>
    1caa:	00004097          	auipc	ra,0x4
    1cae:	b6e080e7          	jalr	-1170(ra) # 5818 <printf>
            exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00003097          	auipc	ra,0x3
    1cb8:	7fc080e7          	jalr	2044(ra) # 54b0 <exit>
      exit(0);
    1cbc:	4501                	li	a0,0
    1cbe:	00003097          	auipc	ra,0x3
    1cc2:	7f2080e7          	jalr	2034(ra) # 54b0 <exit>
      exit(1);
    1cc6:	4505                	li	a0,1
    1cc8:	00003097          	auipc	ra,0x3
    1ccc:	7e8080e7          	jalr	2024(ra) # 54b0 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cd0:	f8040613          	add	a2,s0,-128
    1cd4:	85e6                	mv	a1,s9
    1cd6:	00004517          	auipc	a0,0x4
    1cda:	77a50513          	add	a0,a0,1914 # 6450 <malloc+0xb80>
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	b3a080e7          	jalr	-1222(ra) # 5818 <printf>
        exit(1);
    1ce6:	4505                	li	a0,1
    1ce8:	00003097          	auipc	ra,0x3
    1cec:	7c8080e7          	jalr	1992(ra) # 54b0 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cf0:	054b7163          	bgeu	s6,s4,1d32 <createdelete+0x198>
      if(fd >= 0)
    1cf4:	02055a63          	bgez	a0,1d28 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cf8:	2485                	addw	s1,s1,1
    1cfa:	0ff4f493          	zext.b	s1,s1
    1cfe:	05548c63          	beq	s1,s5,1d56 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d02:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d06:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d0a:	4581                	li	a1,0
    1d0c:	f8040513          	add	a0,s0,-128
    1d10:	00003097          	auipc	ra,0x3
    1d14:	7e0080e7          	jalr	2016(ra) # 54f0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d18:	00090463          	beqz	s2,1d20 <createdelete+0x186>
    1d1c:	fd2bdae3          	bge	s7,s2,1cf0 <createdelete+0x156>
    1d20:	fa0548e3          	bltz	a0,1cd0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d24:	014b7963          	bgeu	s6,s4,1d36 <createdelete+0x19c>
        close(fd);
    1d28:	00003097          	auipc	ra,0x3
    1d2c:	7b0080e7          	jalr	1968(ra) # 54d8 <close>
    1d30:	b7e1                	j	1cf8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d32:	fc0543e3          	bltz	a0,1cf8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d36:	f8040613          	add	a2,s0,-128
    1d3a:	85e6                	mv	a1,s9
    1d3c:	00004517          	auipc	a0,0x4
    1d40:	73c50513          	add	a0,a0,1852 # 6478 <malloc+0xba8>
    1d44:	00004097          	auipc	ra,0x4
    1d48:	ad4080e7          	jalr	-1324(ra) # 5818 <printf>
        exit(1);
    1d4c:	4505                	li	a0,1
    1d4e:	00003097          	auipc	ra,0x3
    1d52:	762080e7          	jalr	1890(ra) # 54b0 <exit>
  for(i = 0; i < N; i++){
    1d56:	2905                	addw	s2,s2,1
    1d58:	2a05                	addw	s4,s4,1
    1d5a:	2985                	addw	s3,s3,1 # 3001 <subdir+0xe7>
    1d5c:	0ff9f993          	zext.b	s3,s3
    1d60:	47d1                	li	a5,20
    1d62:	02f90a63          	beq	s2,a5,1d96 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d66:	84e2                	mv	s1,s8
    1d68:	bf69                	j	1d02 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d6a:	2905                	addw	s2,s2,1
    1d6c:	0ff97913          	zext.b	s2,s2
    1d70:	2985                	addw	s3,s3,1
    1d72:	0ff9f993          	zext.b	s3,s3
    1d76:	03490863          	beq	s2,s4,1da6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d7a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d7c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d80:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d84:	f8040513          	add	a0,s0,-128
    1d88:	00003097          	auipc	ra,0x3
    1d8c:	778080e7          	jalr	1912(ra) # 5500 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d90:	34fd                	addw	s1,s1,-1
    1d92:	f4ed                	bnez	s1,1d7c <createdelete+0x1e2>
    1d94:	bfd9                	j	1d6a <createdelete+0x1d0>
    1d96:	03000993          	li	s3,48
    1d9a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d9e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1da0:	08400a13          	li	s4,132
    1da4:	bfd9                	j	1d7a <createdelete+0x1e0>
}
    1da6:	60aa                	ld	ra,136(sp)
    1da8:	640a                	ld	s0,128(sp)
    1daa:	74e6                	ld	s1,120(sp)
    1dac:	7946                	ld	s2,112(sp)
    1dae:	79a6                	ld	s3,104(sp)
    1db0:	7a06                	ld	s4,96(sp)
    1db2:	6ae6                	ld	s5,88(sp)
    1db4:	6b46                	ld	s6,80(sp)
    1db6:	6ba6                	ld	s7,72(sp)
    1db8:	6c06                	ld	s8,64(sp)
    1dba:	7ce2                	ld	s9,56(sp)
    1dbc:	6149                	add	sp,sp,144
    1dbe:	8082                	ret

0000000000001dc0 <linkunlink>:
{
    1dc0:	711d                	add	sp,sp,-96
    1dc2:	ec86                	sd	ra,88(sp)
    1dc4:	e8a2                	sd	s0,80(sp)
    1dc6:	e4a6                	sd	s1,72(sp)
    1dc8:	e0ca                	sd	s2,64(sp)
    1dca:	fc4e                	sd	s3,56(sp)
    1dcc:	f852                	sd	s4,48(sp)
    1dce:	f456                	sd	s5,40(sp)
    1dd0:	f05a                	sd	s6,32(sp)
    1dd2:	ec5e                	sd	s7,24(sp)
    1dd4:	e862                	sd	s8,16(sp)
    1dd6:	e466                	sd	s9,8(sp)
    1dd8:	1080                	add	s0,sp,96
    1dda:	84aa                	mv	s1,a0
  unlink("x");
    1ddc:	00004517          	auipc	a0,0x4
    1de0:	c8450513          	add	a0,a0,-892 # 5a60 <malloc+0x190>
    1de4:	00003097          	auipc	ra,0x3
    1de8:	71c080e7          	jalr	1820(ra) # 5500 <unlink>
  pid = fork();
    1dec:	00003097          	auipc	ra,0x3
    1df0:	6bc080e7          	jalr	1724(ra) # 54a8 <fork>
  if(pid < 0){
    1df4:	02054b63          	bltz	a0,1e2a <linkunlink+0x6a>
    1df8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dfa:	06100c93          	li	s9,97
    1dfe:	c111                	beqz	a0,1e02 <linkunlink+0x42>
    1e00:	4c85                	li	s9,1
    1e02:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e06:	41c659b7          	lui	s3,0x41c65
    1e0a:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c5650d>
    1e0e:	690d                	lui	s2,0x3
    1e10:	0399091b          	addw	s2,s2,57 # 3039 <subdir+0x11f>
    if((x % 3) == 0){
    1e14:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e16:	4b05                	li	s6,1
      unlink("x");
    1e18:	00004a97          	auipc	s5,0x4
    1e1c:	c48a8a93          	add	s5,s5,-952 # 5a60 <malloc+0x190>
      link("cat", "x");
    1e20:	00004b97          	auipc	s7,0x4
    1e24:	680b8b93          	add	s7,s7,1664 # 64a0 <malloc+0xbd0>
    1e28:	a825                	j	1e60 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e2a:	85a6                	mv	a1,s1
    1e2c:	00004517          	auipc	a0,0x4
    1e30:	41c50513          	add	a0,a0,1052 # 6248 <malloc+0x978>
    1e34:	00004097          	auipc	ra,0x4
    1e38:	9e4080e7          	jalr	-1564(ra) # 5818 <printf>
    exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	00003097          	auipc	ra,0x3
    1e42:	672080e7          	jalr	1650(ra) # 54b0 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e46:	20200593          	li	a1,514
    1e4a:	8556                	mv	a0,s5
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	6a4080e7          	jalr	1700(ra) # 54f0 <open>
    1e54:	00003097          	auipc	ra,0x3
    1e58:	684080e7          	jalr	1668(ra) # 54d8 <close>
  for(i = 0; i < 100; i++){
    1e5c:	34fd                	addw	s1,s1,-1
    1e5e:	c88d                	beqz	s1,1e90 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e60:	033c87bb          	mulw	a5,s9,s3
    1e64:	012787bb          	addw	a5,a5,s2
    1e68:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e6c:	0347f7bb          	remuw	a5,a5,s4
    1e70:	dbf9                	beqz	a5,1e46 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e72:	01678863          	beq	a5,s6,1e82 <linkunlink+0xc2>
      unlink("x");
    1e76:	8556                	mv	a0,s5
    1e78:	00003097          	auipc	ra,0x3
    1e7c:	688080e7          	jalr	1672(ra) # 5500 <unlink>
    1e80:	bff1                	j	1e5c <linkunlink+0x9c>
      link("cat", "x");
    1e82:	85d6                	mv	a1,s5
    1e84:	855e                	mv	a0,s7
    1e86:	00003097          	auipc	ra,0x3
    1e8a:	68a080e7          	jalr	1674(ra) # 5510 <link>
    1e8e:	b7f9                	j	1e5c <linkunlink+0x9c>
  if(pid)
    1e90:	020c0463          	beqz	s8,1eb8 <linkunlink+0xf8>
    wait(0);
    1e94:	4501                	li	a0,0
    1e96:	00003097          	auipc	ra,0x3
    1e9a:	622080e7          	jalr	1570(ra) # 54b8 <wait>
}
    1e9e:	60e6                	ld	ra,88(sp)
    1ea0:	6446                	ld	s0,80(sp)
    1ea2:	64a6                	ld	s1,72(sp)
    1ea4:	6906                	ld	s2,64(sp)
    1ea6:	79e2                	ld	s3,56(sp)
    1ea8:	7a42                	ld	s4,48(sp)
    1eaa:	7aa2                	ld	s5,40(sp)
    1eac:	7b02                	ld	s6,32(sp)
    1eae:	6be2                	ld	s7,24(sp)
    1eb0:	6c42                	ld	s8,16(sp)
    1eb2:	6ca2                	ld	s9,8(sp)
    1eb4:	6125                	add	sp,sp,96
    1eb6:	8082                	ret
    exit(0);
    1eb8:	4501                	li	a0,0
    1eba:	00003097          	auipc	ra,0x3
    1ebe:	5f6080e7          	jalr	1526(ra) # 54b0 <exit>

0000000000001ec2 <forktest>:
{
    1ec2:	7179                	add	sp,sp,-48
    1ec4:	f406                	sd	ra,40(sp)
    1ec6:	f022                	sd	s0,32(sp)
    1ec8:	ec26                	sd	s1,24(sp)
    1eca:	e84a                	sd	s2,16(sp)
    1ecc:	e44e                	sd	s3,8(sp)
    1ece:	1800                	add	s0,sp,48
    1ed0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ed2:	4481                	li	s1,0
    1ed4:	3e800913          	li	s2,1000
    pid = fork();
    1ed8:	00003097          	auipc	ra,0x3
    1edc:	5d0080e7          	jalr	1488(ra) # 54a8 <fork>
    if(pid < 0)
    1ee0:	02054863          	bltz	a0,1f10 <forktest+0x4e>
    if(pid == 0)
    1ee4:	c115                	beqz	a0,1f08 <forktest+0x46>
  for(n=0; n<N; n++){
    1ee6:	2485                	addw	s1,s1,1
    1ee8:	ff2498e3          	bne	s1,s2,1ed8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1eec:	85ce                	mv	a1,s3
    1eee:	00004517          	auipc	a0,0x4
    1ef2:	5d250513          	add	a0,a0,1490 # 64c0 <malloc+0xbf0>
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	922080e7          	jalr	-1758(ra) # 5818 <printf>
    exit(1);
    1efe:	4505                	li	a0,1
    1f00:	00003097          	auipc	ra,0x3
    1f04:	5b0080e7          	jalr	1456(ra) # 54b0 <exit>
      exit(0);
    1f08:	00003097          	auipc	ra,0x3
    1f0c:	5a8080e7          	jalr	1448(ra) # 54b0 <exit>
  if (n == 0) {
    1f10:	cc9d                	beqz	s1,1f4e <forktest+0x8c>
  if(n == N){
    1f12:	3e800793          	li	a5,1000
    1f16:	fcf48be3          	beq	s1,a5,1eec <forktest+0x2a>
  for(; n > 0; n--){
    1f1a:	00905b63          	blez	s1,1f30 <forktest+0x6e>
    if(wait(0) < 0){
    1f1e:	4501                	li	a0,0
    1f20:	00003097          	auipc	ra,0x3
    1f24:	598080e7          	jalr	1432(ra) # 54b8 <wait>
    1f28:	04054163          	bltz	a0,1f6a <forktest+0xa8>
  for(; n > 0; n--){
    1f2c:	34fd                	addw	s1,s1,-1
    1f2e:	f8e5                	bnez	s1,1f1e <forktest+0x5c>
  if(wait(0) != -1){
    1f30:	4501                	li	a0,0
    1f32:	00003097          	auipc	ra,0x3
    1f36:	586080e7          	jalr	1414(ra) # 54b8 <wait>
    1f3a:	57fd                	li	a5,-1
    1f3c:	04f51563          	bne	a0,a5,1f86 <forktest+0xc4>
}
    1f40:	70a2                	ld	ra,40(sp)
    1f42:	7402                	ld	s0,32(sp)
    1f44:	64e2                	ld	s1,24(sp)
    1f46:	6942                	ld	s2,16(sp)
    1f48:	69a2                	ld	s3,8(sp)
    1f4a:	6145                	add	sp,sp,48
    1f4c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f4e:	85ce                	mv	a1,s3
    1f50:	00004517          	auipc	a0,0x4
    1f54:	55850513          	add	a0,a0,1368 # 64a8 <malloc+0xbd8>
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	8c0080e7          	jalr	-1856(ra) # 5818 <printf>
    exit(1);
    1f60:	4505                	li	a0,1
    1f62:	00003097          	auipc	ra,0x3
    1f66:	54e080e7          	jalr	1358(ra) # 54b0 <exit>
      printf("%s: wait stopped early\n", s);
    1f6a:	85ce                	mv	a1,s3
    1f6c:	00004517          	auipc	a0,0x4
    1f70:	57c50513          	add	a0,a0,1404 # 64e8 <malloc+0xc18>
    1f74:	00004097          	auipc	ra,0x4
    1f78:	8a4080e7          	jalr	-1884(ra) # 5818 <printf>
      exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	00003097          	auipc	ra,0x3
    1f82:	532080e7          	jalr	1330(ra) # 54b0 <exit>
    printf("%s: wait got too many\n", s);
    1f86:	85ce                	mv	a1,s3
    1f88:	00004517          	auipc	a0,0x4
    1f8c:	57850513          	add	a0,a0,1400 # 6500 <malloc+0xc30>
    1f90:	00004097          	auipc	ra,0x4
    1f94:	888080e7          	jalr	-1912(ra) # 5818 <printf>
    exit(1);
    1f98:	4505                	li	a0,1
    1f9a:	00003097          	auipc	ra,0x3
    1f9e:	516080e7          	jalr	1302(ra) # 54b0 <exit>

0000000000001fa2 <kernmem>:
{
    1fa2:	715d                	add	sp,sp,-80
    1fa4:	e486                	sd	ra,72(sp)
    1fa6:	e0a2                	sd	s0,64(sp)
    1fa8:	fc26                	sd	s1,56(sp)
    1faa:	f84a                	sd	s2,48(sp)
    1fac:	f44e                	sd	s3,40(sp)
    1fae:	f052                	sd	s4,32(sp)
    1fb0:	ec56                	sd	s5,24(sp)
    1fb2:	0880                	add	s0,sp,80
    1fb4:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb6:	4485                	li	s1,1
    1fb8:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fba:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fbc:	69b1                	lui	s3,0xc
    1fbe:	35098993          	add	s3,s3,848 # c350 <buf+0xa00>
    1fc2:	1003d937          	lui	s2,0x1003d
    1fc6:	090e                	sll	s2,s2,0x3
    1fc8:	48090913          	add	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eb20>
    pid = fork();
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	4dc080e7          	jalr	1244(ra) # 54a8 <fork>
    if(pid < 0){
    1fd4:	02054963          	bltz	a0,2006 <kernmem+0x64>
    if(pid == 0){
    1fd8:	c529                	beqz	a0,2022 <kernmem+0x80>
    wait(&xstatus);
    1fda:	fbc40513          	add	a0,s0,-68
    1fde:	00003097          	auipc	ra,0x3
    1fe2:	4da080e7          	jalr	1242(ra) # 54b8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fe6:	fbc42783          	lw	a5,-68(s0)
    1fea:	05579d63          	bne	a5,s5,2044 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fee:	94ce                	add	s1,s1,s3
    1ff0:	fd249ee3          	bne	s1,s2,1fcc <kernmem+0x2a>
}
    1ff4:	60a6                	ld	ra,72(sp)
    1ff6:	6406                	ld	s0,64(sp)
    1ff8:	74e2                	ld	s1,56(sp)
    1ffa:	7942                	ld	s2,48(sp)
    1ffc:	79a2                	ld	s3,40(sp)
    1ffe:	7a02                	ld	s4,32(sp)
    2000:	6ae2                	ld	s5,24(sp)
    2002:	6161                	add	sp,sp,80
    2004:	8082                	ret
      printf("%s: fork failed\n", s);
    2006:	85d2                	mv	a1,s4
    2008:	00004517          	auipc	a0,0x4
    200c:	24050513          	add	a0,a0,576 # 6248 <malloc+0x978>
    2010:	00004097          	auipc	ra,0x4
    2014:	808080e7          	jalr	-2040(ra) # 5818 <printf>
      exit(1);
    2018:	4505                	li	a0,1
    201a:	00003097          	auipc	ra,0x3
    201e:	496080e7          	jalr	1174(ra) # 54b0 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2022:	0004c683          	lbu	a3,0(s1)
    2026:	8626                	mv	a2,s1
    2028:	85d2                	mv	a1,s4
    202a:	00004517          	auipc	a0,0x4
    202e:	4ee50513          	add	a0,a0,1262 # 6518 <malloc+0xc48>
    2032:	00003097          	auipc	ra,0x3
    2036:	7e6080e7          	jalr	2022(ra) # 5818 <printf>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	474080e7          	jalr	1140(ra) # 54b0 <exit>
      exit(1);
    2044:	4505                	li	a0,1
    2046:	00003097          	auipc	ra,0x3
    204a:	46a080e7          	jalr	1130(ra) # 54b0 <exit>

000000000000204e <bigargtest>:
{
    204e:	7179                	add	sp,sp,-48
    2050:	f406                	sd	ra,40(sp)
    2052:	f022                	sd	s0,32(sp)
    2054:	ec26                	sd	s1,24(sp)
    2056:	1800                	add	s0,sp,48
    2058:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    205a:	00004517          	auipc	a0,0x4
    205e:	4de50513          	add	a0,a0,1246 # 6538 <malloc+0xc68>
    2062:	00003097          	auipc	ra,0x3
    2066:	49e080e7          	jalr	1182(ra) # 5500 <unlink>
  pid = fork();
    206a:	00003097          	auipc	ra,0x3
    206e:	43e080e7          	jalr	1086(ra) # 54a8 <fork>
  if(pid == 0){
    2072:	c121                	beqz	a0,20b2 <bigargtest+0x64>
  } else if(pid < 0){
    2074:	0a054063          	bltz	a0,2114 <bigargtest+0xc6>
  wait(&xstatus);
    2078:	fdc40513          	add	a0,s0,-36
    207c:	00003097          	auipc	ra,0x3
    2080:	43c080e7          	jalr	1084(ra) # 54b8 <wait>
  if(xstatus != 0)
    2084:	fdc42503          	lw	a0,-36(s0)
    2088:	e545                	bnez	a0,2130 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    208a:	4581                	li	a1,0
    208c:	00004517          	auipc	a0,0x4
    2090:	4ac50513          	add	a0,a0,1196 # 6538 <malloc+0xc68>
    2094:	00003097          	auipc	ra,0x3
    2098:	45c080e7          	jalr	1116(ra) # 54f0 <open>
  if(fd < 0){
    209c:	08054e63          	bltz	a0,2138 <bigargtest+0xea>
  close(fd);
    20a0:	00003097          	auipc	ra,0x3
    20a4:	438080e7          	jalr	1080(ra) # 54d8 <close>
}
    20a8:	70a2                	ld	ra,40(sp)
    20aa:	7402                	ld	s0,32(sp)
    20ac:	64e2                	ld	s1,24(sp)
    20ae:	6145                	add	sp,sp,48
    20b0:	8082                	ret
    20b2:	00006797          	auipc	a5,0x6
    20b6:	08678793          	add	a5,a5,134 # 8138 <args.1>
    20ba:	00006697          	auipc	a3,0x6
    20be:	17668693          	add	a3,a3,374 # 8230 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20c2:	00004717          	auipc	a4,0x4
    20c6:	48670713          	add	a4,a4,1158 # 6548 <malloc+0xc78>
    20ca:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20cc:	07a1                	add	a5,a5,8
    20ce:	fed79ee3          	bne	a5,a3,20ca <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20d2:	00006597          	auipc	a1,0x6
    20d6:	06658593          	add	a1,a1,102 # 8138 <args.1>
    20da:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20de:	00004517          	auipc	a0,0x4
    20e2:	91250513          	add	a0,a0,-1774 # 59f0 <malloc+0x120>
    20e6:	00003097          	auipc	ra,0x3
    20ea:	402080e7          	jalr	1026(ra) # 54e8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20ee:	20000593          	li	a1,512
    20f2:	00004517          	auipc	a0,0x4
    20f6:	44650513          	add	a0,a0,1094 # 6538 <malloc+0xc68>
    20fa:	00003097          	auipc	ra,0x3
    20fe:	3f6080e7          	jalr	1014(ra) # 54f0 <open>
    close(fd);
    2102:	00003097          	auipc	ra,0x3
    2106:	3d6080e7          	jalr	982(ra) # 54d8 <close>
    exit(0);
    210a:	4501                	li	a0,0
    210c:	00003097          	auipc	ra,0x3
    2110:	3a4080e7          	jalr	932(ra) # 54b0 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2114:	85a6                	mv	a1,s1
    2116:	00004517          	auipc	a0,0x4
    211a:	51250513          	add	a0,a0,1298 # 6628 <malloc+0xd58>
    211e:	00003097          	auipc	ra,0x3
    2122:	6fa080e7          	jalr	1786(ra) # 5818 <printf>
    exit(1);
    2126:	4505                	li	a0,1
    2128:	00003097          	auipc	ra,0x3
    212c:	388080e7          	jalr	904(ra) # 54b0 <exit>
    exit(xstatus);
    2130:	00003097          	auipc	ra,0x3
    2134:	380080e7          	jalr	896(ra) # 54b0 <exit>
    printf("%s: bigarg test failed!\n", s);
    2138:	85a6                	mv	a1,s1
    213a:	00004517          	auipc	a0,0x4
    213e:	50e50513          	add	a0,a0,1294 # 6648 <malloc+0xd78>
    2142:	00003097          	auipc	ra,0x3
    2146:	6d6080e7          	jalr	1750(ra) # 5818 <printf>
    exit(1);
    214a:	4505                	li	a0,1
    214c:	00003097          	auipc	ra,0x3
    2150:	364080e7          	jalr	868(ra) # 54b0 <exit>

0000000000002154 <stacktest>:
{
    2154:	7179                	add	sp,sp,-48
    2156:	f406                	sd	ra,40(sp)
    2158:	f022                	sd	s0,32(sp)
    215a:	ec26                	sd	s1,24(sp)
    215c:	1800                	add	s0,sp,48
    215e:	84aa                	mv	s1,a0
  pid = fork();
    2160:	00003097          	auipc	ra,0x3
    2164:	348080e7          	jalr	840(ra) # 54a8 <fork>
  if(pid == 0) {
    2168:	c115                	beqz	a0,218c <stacktest+0x38>
  } else if(pid < 0){
    216a:	04054463          	bltz	a0,21b2 <stacktest+0x5e>
  wait(&xstatus);
    216e:	fdc40513          	add	a0,s0,-36
    2172:	00003097          	auipc	ra,0x3
    2176:	346080e7          	jalr	838(ra) # 54b8 <wait>
  if(xstatus == -1)  // kernel killed child?
    217a:	fdc42503          	lw	a0,-36(s0)
    217e:	57fd                	li	a5,-1
    2180:	04f50763          	beq	a0,a5,21ce <stacktest+0x7a>
    exit(xstatus);
    2184:	00003097          	auipc	ra,0x3
    2188:	32c080e7          	jalr	812(ra) # 54b0 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    218c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    218e:	77fd                	lui	a5,0xfffff
    2190:	97ba                	add	a5,a5,a4
    2192:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff06a0>
    2196:	85a6                	mv	a1,s1
    2198:	00004517          	auipc	a0,0x4
    219c:	4d050513          	add	a0,a0,1232 # 6668 <malloc+0xd98>
    21a0:	00003097          	auipc	ra,0x3
    21a4:	678080e7          	jalr	1656(ra) # 5818 <printf>
    exit(1);
    21a8:	4505                	li	a0,1
    21aa:	00003097          	auipc	ra,0x3
    21ae:	306080e7          	jalr	774(ra) # 54b0 <exit>
    printf("%s: fork failed\n", s);
    21b2:	85a6                	mv	a1,s1
    21b4:	00004517          	auipc	a0,0x4
    21b8:	09450513          	add	a0,a0,148 # 6248 <malloc+0x978>
    21bc:	00003097          	auipc	ra,0x3
    21c0:	65c080e7          	jalr	1628(ra) # 5818 <printf>
    exit(1);
    21c4:	4505                	li	a0,1
    21c6:	00003097          	auipc	ra,0x3
    21ca:	2ea080e7          	jalr	746(ra) # 54b0 <exit>
    exit(0);
    21ce:	4501                	li	a0,0
    21d0:	00003097          	auipc	ra,0x3
    21d4:	2e0080e7          	jalr	736(ra) # 54b0 <exit>

00000000000021d8 <copyinstr3>:
{
    21d8:	7179                	add	sp,sp,-48
    21da:	f406                	sd	ra,40(sp)
    21dc:	f022                	sd	s0,32(sp)
    21de:	ec26                	sd	s1,24(sp)
    21e0:	1800                	add	s0,sp,48
  sbrk(8192);
    21e2:	6509                	lui	a0,0x2
    21e4:	00003097          	auipc	ra,0x3
    21e8:	354080e7          	jalr	852(ra) # 5538 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21ec:	4501                	li	a0,0
    21ee:	00003097          	auipc	ra,0x3
    21f2:	34a080e7          	jalr	842(ra) # 5538 <sbrk>
  if((top % PGSIZE) != 0){
    21f6:	03451793          	sll	a5,a0,0x34
    21fa:	e3c9                	bnez	a5,227c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21fc:	4501                	li	a0,0
    21fe:	00003097          	auipc	ra,0x3
    2202:	33a080e7          	jalr	826(ra) # 5538 <sbrk>
  if(top % PGSIZE){
    2206:	03451793          	sll	a5,a0,0x34
    220a:	e3d9                	bnez	a5,2290 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    220c:	fff50493          	add	s1,a0,-1 # 1fff <kernmem+0x5d>
  *b = 'x';
    2210:	07800793          	li	a5,120
    2214:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2218:	8526                	mv	a0,s1
    221a:	00003097          	auipc	ra,0x3
    221e:	2e6080e7          	jalr	742(ra) # 5500 <unlink>
  if(ret != -1){
    2222:	57fd                	li	a5,-1
    2224:	08f51363          	bne	a0,a5,22aa <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2228:	20100593          	li	a1,513
    222c:	8526                	mv	a0,s1
    222e:	00003097          	auipc	ra,0x3
    2232:	2c2080e7          	jalr	706(ra) # 54f0 <open>
  if(fd != -1){
    2236:	57fd                	li	a5,-1
    2238:	08f51863          	bne	a0,a5,22c8 <copyinstr3+0xf0>
  ret = link(b, b);
    223c:	85a6                	mv	a1,s1
    223e:	8526                	mv	a0,s1
    2240:	00003097          	auipc	ra,0x3
    2244:	2d0080e7          	jalr	720(ra) # 5510 <link>
  if(ret != -1){
    2248:	57fd                	li	a5,-1
    224a:	08f51e63          	bne	a0,a5,22e6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    224e:	00005797          	auipc	a5,0x5
    2252:	0c278793          	add	a5,a5,194 # 7310 <malloc+0x1a40>
    2256:	fcf43823          	sd	a5,-48(s0)
    225a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    225e:	fd040593          	add	a1,s0,-48
    2262:	8526                	mv	a0,s1
    2264:	00003097          	auipc	ra,0x3
    2268:	284080e7          	jalr	644(ra) # 54e8 <exec>
  if(ret != -1){
    226c:	57fd                	li	a5,-1
    226e:	08f51c63          	bne	a0,a5,2306 <copyinstr3+0x12e>
}
    2272:	70a2                	ld	ra,40(sp)
    2274:	7402                	ld	s0,32(sp)
    2276:	64e2                	ld	s1,24(sp)
    2278:	6145                	add	sp,sp,48
    227a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    227c:	0347d513          	srl	a0,a5,0x34
    2280:	6785                	lui	a5,0x1
    2282:	40a7853b          	subw	a0,a5,a0
    2286:	00003097          	auipc	ra,0x3
    228a:	2b2080e7          	jalr	690(ra) # 5538 <sbrk>
    228e:	b7bd                	j	21fc <copyinstr3+0x24>
    printf("oops\n");
    2290:	00004517          	auipc	a0,0x4
    2294:	40050513          	add	a0,a0,1024 # 6690 <malloc+0xdc0>
    2298:	00003097          	auipc	ra,0x3
    229c:	580080e7          	jalr	1408(ra) # 5818 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	00003097          	auipc	ra,0x3
    22a6:	20e080e7          	jalr	526(ra) # 54b0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    22aa:	862a                	mv	a2,a0
    22ac:	85a6                	mv	a1,s1
    22ae:	00004517          	auipc	a0,0x4
    22b2:	eba50513          	add	a0,a0,-326 # 6168 <malloc+0x898>
    22b6:	00003097          	auipc	ra,0x3
    22ba:	562080e7          	jalr	1378(ra) # 5818 <printf>
    exit(1);
    22be:	4505                	li	a0,1
    22c0:	00003097          	auipc	ra,0x3
    22c4:	1f0080e7          	jalr	496(ra) # 54b0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22c8:	862a                	mv	a2,a0
    22ca:	85a6                	mv	a1,s1
    22cc:	00004517          	auipc	a0,0x4
    22d0:	ebc50513          	add	a0,a0,-324 # 6188 <malloc+0x8b8>
    22d4:	00003097          	auipc	ra,0x3
    22d8:	544080e7          	jalr	1348(ra) # 5818 <printf>
    exit(1);
    22dc:	4505                	li	a0,1
    22de:	00003097          	auipc	ra,0x3
    22e2:	1d2080e7          	jalr	466(ra) # 54b0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22e6:	86aa                	mv	a3,a0
    22e8:	8626                	mv	a2,s1
    22ea:	85a6                	mv	a1,s1
    22ec:	00004517          	auipc	a0,0x4
    22f0:	ebc50513          	add	a0,a0,-324 # 61a8 <malloc+0x8d8>
    22f4:	00003097          	auipc	ra,0x3
    22f8:	524080e7          	jalr	1316(ra) # 5818 <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	00003097          	auipc	ra,0x3
    2302:	1b2080e7          	jalr	434(ra) # 54b0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2306:	567d                	li	a2,-1
    2308:	85a6                	mv	a1,s1
    230a:	00004517          	auipc	a0,0x4
    230e:	ec650513          	add	a0,a0,-314 # 61d0 <malloc+0x900>
    2312:	00003097          	auipc	ra,0x3
    2316:	506080e7          	jalr	1286(ra) # 5818 <printf>
    exit(1);
    231a:	4505                	li	a0,1
    231c:	00003097          	auipc	ra,0x3
    2320:	194080e7          	jalr	404(ra) # 54b0 <exit>

0000000000002324 <rwsbrk>:
{
    2324:	1101                	add	sp,sp,-32
    2326:	ec06                	sd	ra,24(sp)
    2328:	e822                	sd	s0,16(sp)
    232a:	e426                	sd	s1,8(sp)
    232c:	e04a                	sd	s2,0(sp)
    232e:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2330:	6509                	lui	a0,0x2
    2332:	00003097          	auipc	ra,0x3
    2336:	206080e7          	jalr	518(ra) # 5538 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    233a:	57fd                	li	a5,-1
    233c:	06f50263          	beq	a0,a5,23a0 <rwsbrk+0x7c>
    2340:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2342:	7579                	lui	a0,0xffffe
    2344:	00003097          	auipc	ra,0x3
    2348:	1f4080e7          	jalr	500(ra) # 5538 <sbrk>
    234c:	57fd                	li	a5,-1
    234e:	06f50663          	beq	a0,a5,23ba <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2352:	20100593          	li	a1,513
    2356:	00004517          	auipc	a0,0x4
    235a:	37a50513          	add	a0,a0,890 # 66d0 <malloc+0xe00>
    235e:	00003097          	auipc	ra,0x3
    2362:	192080e7          	jalr	402(ra) # 54f0 <open>
    2366:	892a                	mv	s2,a0
  if(fd < 0){
    2368:	06054663          	bltz	a0,23d4 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    236c:	6785                	lui	a5,0x1
    236e:	94be                	add	s1,s1,a5
    2370:	40000613          	li	a2,1024
    2374:	85a6                	mv	a1,s1
    2376:	00003097          	auipc	ra,0x3
    237a:	15a080e7          	jalr	346(ra) # 54d0 <write>
    237e:	862a                	mv	a2,a0
  if(n >= 0){
    2380:	06054763          	bltz	a0,23ee <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2384:	85a6                	mv	a1,s1
    2386:	00004517          	auipc	a0,0x4
    238a:	36a50513          	add	a0,a0,874 # 66f0 <malloc+0xe20>
    238e:	00003097          	auipc	ra,0x3
    2392:	48a080e7          	jalr	1162(ra) # 5818 <printf>
    exit(1);
    2396:	4505                	li	a0,1
    2398:	00003097          	auipc	ra,0x3
    239c:	118080e7          	jalr	280(ra) # 54b0 <exit>
    printf("sbrk(rwsbrk) failed\n");
    23a0:	00004517          	auipc	a0,0x4
    23a4:	2f850513          	add	a0,a0,760 # 6698 <malloc+0xdc8>
    23a8:	00003097          	auipc	ra,0x3
    23ac:	470080e7          	jalr	1136(ra) # 5818 <printf>
    exit(1);
    23b0:	4505                	li	a0,1
    23b2:	00003097          	auipc	ra,0x3
    23b6:	0fe080e7          	jalr	254(ra) # 54b0 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    23ba:	00004517          	auipc	a0,0x4
    23be:	2f650513          	add	a0,a0,758 # 66b0 <malloc+0xde0>
    23c2:	00003097          	auipc	ra,0x3
    23c6:	456080e7          	jalr	1110(ra) # 5818 <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00003097          	auipc	ra,0x3
    23d0:	0e4080e7          	jalr	228(ra) # 54b0 <exit>
    printf("open(rwsbrk) failed\n");
    23d4:	00004517          	auipc	a0,0x4
    23d8:	30450513          	add	a0,a0,772 # 66d8 <malloc+0xe08>
    23dc:	00003097          	auipc	ra,0x3
    23e0:	43c080e7          	jalr	1084(ra) # 5818 <printf>
    exit(1);
    23e4:	4505                	li	a0,1
    23e6:	00003097          	auipc	ra,0x3
    23ea:	0ca080e7          	jalr	202(ra) # 54b0 <exit>
  close(fd);
    23ee:	854a                	mv	a0,s2
    23f0:	00003097          	auipc	ra,0x3
    23f4:	0e8080e7          	jalr	232(ra) # 54d8 <close>
  unlink("rwsbrk");
    23f8:	00004517          	auipc	a0,0x4
    23fc:	2d850513          	add	a0,a0,728 # 66d0 <malloc+0xe00>
    2400:	00003097          	auipc	ra,0x3
    2404:	100080e7          	jalr	256(ra) # 5500 <unlink>
  fd = open("README", O_RDONLY);
    2408:	4581                	li	a1,0
    240a:	00003517          	auipc	a0,0x3
    240e:	78e50513          	add	a0,a0,1934 # 5b98 <malloc+0x2c8>
    2412:	00003097          	auipc	ra,0x3
    2416:	0de080e7          	jalr	222(ra) # 54f0 <open>
    241a:	892a                	mv	s2,a0
  if(fd < 0){
    241c:	02054963          	bltz	a0,244e <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2420:	4629                	li	a2,10
    2422:	85a6                	mv	a1,s1
    2424:	00003097          	auipc	ra,0x3
    2428:	0a4080e7          	jalr	164(ra) # 54c8 <read>
    242c:	862a                	mv	a2,a0
  if(n >= 0){
    242e:	02054d63          	bltz	a0,2468 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2432:	85a6                	mv	a1,s1
    2434:	00004517          	auipc	a0,0x4
    2438:	2ec50513          	add	a0,a0,748 # 6720 <malloc+0xe50>
    243c:	00003097          	auipc	ra,0x3
    2440:	3dc080e7          	jalr	988(ra) # 5818 <printf>
    exit(1);
    2444:	4505                	li	a0,1
    2446:	00003097          	auipc	ra,0x3
    244a:	06a080e7          	jalr	106(ra) # 54b0 <exit>
    printf("open(rwsbrk) failed\n");
    244e:	00004517          	auipc	a0,0x4
    2452:	28a50513          	add	a0,a0,650 # 66d8 <malloc+0xe08>
    2456:	00003097          	auipc	ra,0x3
    245a:	3c2080e7          	jalr	962(ra) # 5818 <printf>
    exit(1);
    245e:	4505                	li	a0,1
    2460:	00003097          	auipc	ra,0x3
    2464:	050080e7          	jalr	80(ra) # 54b0 <exit>
  close(fd);
    2468:	854a                	mv	a0,s2
    246a:	00003097          	auipc	ra,0x3
    246e:	06e080e7          	jalr	110(ra) # 54d8 <close>
  exit(0);
    2472:	4501                	li	a0,0
    2474:	00003097          	auipc	ra,0x3
    2478:	03c080e7          	jalr	60(ra) # 54b0 <exit>

000000000000247c <sbrkbasic>:
{
    247c:	7139                	add	sp,sp,-64
    247e:	fc06                	sd	ra,56(sp)
    2480:	f822                	sd	s0,48(sp)
    2482:	f426                	sd	s1,40(sp)
    2484:	f04a                	sd	s2,32(sp)
    2486:	ec4e                	sd	s3,24(sp)
    2488:	e852                	sd	s4,16(sp)
    248a:	0080                	add	s0,sp,64
    248c:	8a2a                	mv	s4,a0
  pid = fork();
    248e:	00003097          	auipc	ra,0x3
    2492:	01a080e7          	jalr	26(ra) # 54a8 <fork>
  if(pid < 0){
    2496:	02054c63          	bltz	a0,24ce <sbrkbasic+0x52>
  if(pid == 0){
    249a:	ed21                	bnez	a0,24f2 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    249c:	40000537          	lui	a0,0x40000
    24a0:	00003097          	auipc	ra,0x3
    24a4:	098080e7          	jalr	152(ra) # 5538 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    24a8:	57fd                	li	a5,-1
    24aa:	02f50f63          	beq	a0,a5,24e8 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    24ae:	400007b7          	lui	a5,0x40000
    24b2:	97aa                	add	a5,a5,a0
      *b = 99;
    24b4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    24b8:	6705                	lui	a4,0x1
      *b = 99;
    24ba:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff16a0>
    for(b = a; b < a+TOOMUCH; b += 4096){
    24be:	953a                	add	a0,a0,a4
    24c0:	fef51de3          	bne	a0,a5,24ba <sbrkbasic+0x3e>
    exit(1);
    24c4:	4505                	li	a0,1
    24c6:	00003097          	auipc	ra,0x3
    24ca:	fea080e7          	jalr	-22(ra) # 54b0 <exit>
    printf("fork failed in sbrkbasic\n");
    24ce:	00004517          	auipc	a0,0x4
    24d2:	27a50513          	add	a0,a0,634 # 6748 <malloc+0xe78>
    24d6:	00003097          	auipc	ra,0x3
    24da:	342080e7          	jalr	834(ra) # 5818 <printf>
    exit(1);
    24de:	4505                	li	a0,1
    24e0:	00003097          	auipc	ra,0x3
    24e4:	fd0080e7          	jalr	-48(ra) # 54b0 <exit>
      exit(0);
    24e8:	4501                	li	a0,0
    24ea:	00003097          	auipc	ra,0x3
    24ee:	fc6080e7          	jalr	-58(ra) # 54b0 <exit>
  wait(&xstatus);
    24f2:	fcc40513          	add	a0,s0,-52
    24f6:	00003097          	auipc	ra,0x3
    24fa:	fc2080e7          	jalr	-62(ra) # 54b8 <wait>
  if(xstatus == 1){
    24fe:	fcc42703          	lw	a4,-52(s0)
    2502:	4785                	li	a5,1
    2504:	00f70d63          	beq	a4,a5,251e <sbrkbasic+0xa2>
  a = sbrk(0);
    2508:	4501                	li	a0,0
    250a:	00003097          	auipc	ra,0x3
    250e:	02e080e7          	jalr	46(ra) # 5538 <sbrk>
    2512:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2514:	4901                	li	s2,0
    2516:	6985                	lui	s3,0x1
    2518:	38898993          	add	s3,s3,904 # 1388 <copyinstr2+0x1c4>
    251c:	a005                	j	253c <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    251e:	85d2                	mv	a1,s4
    2520:	00004517          	auipc	a0,0x4
    2524:	24850513          	add	a0,a0,584 # 6768 <malloc+0xe98>
    2528:	00003097          	auipc	ra,0x3
    252c:	2f0080e7          	jalr	752(ra) # 5818 <printf>
    exit(1);
    2530:	4505                	li	a0,1
    2532:	00003097          	auipc	ra,0x3
    2536:	f7e080e7          	jalr	-130(ra) # 54b0 <exit>
    a = b + 1;
    253a:	84be                	mv	s1,a5
    b = sbrk(1);
    253c:	4505                	li	a0,1
    253e:	00003097          	auipc	ra,0x3
    2542:	ffa080e7          	jalr	-6(ra) # 5538 <sbrk>
    if(b != a){
    2546:	04951c63          	bne	a0,s1,259e <sbrkbasic+0x122>
    *b = 1;
    254a:	4785                	li	a5,1
    254c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2550:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    2554:	2905                	addw	s2,s2,1
    2556:	ff3912e3          	bne	s2,s3,253a <sbrkbasic+0xbe>
  pid = fork();
    255a:	00003097          	auipc	ra,0x3
    255e:	f4e080e7          	jalr	-178(ra) # 54a8 <fork>
    2562:	892a                	mv	s2,a0
  if(pid < 0){
    2564:	04054d63          	bltz	a0,25be <sbrkbasic+0x142>
  c = sbrk(1);
    2568:	4505                	li	a0,1
    256a:	00003097          	auipc	ra,0x3
    256e:	fce080e7          	jalr	-50(ra) # 5538 <sbrk>
  c = sbrk(1);
    2572:	4505                	li	a0,1
    2574:	00003097          	auipc	ra,0x3
    2578:	fc4080e7          	jalr	-60(ra) # 5538 <sbrk>
  if(c != a + 1){
    257c:	0489                	add	s1,s1,2
    257e:	04a48e63          	beq	s1,a0,25da <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    2582:	85d2                	mv	a1,s4
    2584:	00004517          	auipc	a0,0x4
    2588:	24450513          	add	a0,a0,580 # 67c8 <malloc+0xef8>
    258c:	00003097          	auipc	ra,0x3
    2590:	28c080e7          	jalr	652(ra) # 5818 <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	f1a080e7          	jalr	-230(ra) # 54b0 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    259e:	86aa                	mv	a3,a0
    25a0:	8626                	mv	a2,s1
    25a2:	85ca                	mv	a1,s2
    25a4:	00004517          	auipc	a0,0x4
    25a8:	1e450513          	add	a0,a0,484 # 6788 <malloc+0xeb8>
    25ac:	00003097          	auipc	ra,0x3
    25b0:	26c080e7          	jalr	620(ra) # 5818 <printf>
      exit(1);
    25b4:	4505                	li	a0,1
    25b6:	00003097          	auipc	ra,0x3
    25ba:	efa080e7          	jalr	-262(ra) # 54b0 <exit>
    printf("%s: sbrk test fork failed\n", s);
    25be:	85d2                	mv	a1,s4
    25c0:	00004517          	auipc	a0,0x4
    25c4:	1e850513          	add	a0,a0,488 # 67a8 <malloc+0xed8>
    25c8:	00003097          	auipc	ra,0x3
    25cc:	250080e7          	jalr	592(ra) # 5818 <printf>
    exit(1);
    25d0:	4505                	li	a0,1
    25d2:	00003097          	auipc	ra,0x3
    25d6:	ede080e7          	jalr	-290(ra) # 54b0 <exit>
  if(pid == 0)
    25da:	00091763          	bnez	s2,25e8 <sbrkbasic+0x16c>
    exit(0);
    25de:	4501                	li	a0,0
    25e0:	00003097          	auipc	ra,0x3
    25e4:	ed0080e7          	jalr	-304(ra) # 54b0 <exit>
  wait(&xstatus);
    25e8:	fcc40513          	add	a0,s0,-52
    25ec:	00003097          	auipc	ra,0x3
    25f0:	ecc080e7          	jalr	-308(ra) # 54b8 <wait>
  exit(xstatus);
    25f4:	fcc42503          	lw	a0,-52(s0)
    25f8:	00003097          	auipc	ra,0x3
    25fc:	eb8080e7          	jalr	-328(ra) # 54b0 <exit>

0000000000002600 <sbrkmuch>:
{
    2600:	7179                	add	sp,sp,-48
    2602:	f406                	sd	ra,40(sp)
    2604:	f022                	sd	s0,32(sp)
    2606:	ec26                	sd	s1,24(sp)
    2608:	e84a                	sd	s2,16(sp)
    260a:	e44e                	sd	s3,8(sp)
    260c:	e052                	sd	s4,0(sp)
    260e:	1800                	add	s0,sp,48
    2610:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2612:	4501                	li	a0,0
    2614:	00003097          	auipc	ra,0x3
    2618:	f24080e7          	jalr	-220(ra) # 5538 <sbrk>
    261c:	892a                	mv	s2,a0
  a = sbrk(0);
    261e:	4501                	li	a0,0
    2620:	00003097          	auipc	ra,0x3
    2624:	f18080e7          	jalr	-232(ra) # 5538 <sbrk>
    2628:	84aa                	mv	s1,a0
  p = sbrk(amt);
    262a:	06400537          	lui	a0,0x6400
    262e:	9d05                	subw	a0,a0,s1
    2630:	00003097          	auipc	ra,0x3
    2634:	f08080e7          	jalr	-248(ra) # 5538 <sbrk>
  if (p != a) {
    2638:	0ca49863          	bne	s1,a0,2708 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    263c:	4501                	li	a0,0
    263e:	00003097          	auipc	ra,0x3
    2642:	efa080e7          	jalr	-262(ra) # 5538 <sbrk>
    2646:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2648:	00a4f963          	bgeu	s1,a0,265a <sbrkmuch+0x5a>
    *pp = 1;
    264c:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    264e:	6705                	lui	a4,0x1
    *pp = 1;
    2650:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2654:	94ba                	add	s1,s1,a4
    2656:	fef4ede3          	bltu	s1,a5,2650 <sbrkmuch+0x50>
  *lastaddr = 99;
    265a:	064007b7          	lui	a5,0x6400
    265e:	06300713          	li	a4,99
    2662:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f169f>
  a = sbrk(0);
    2666:	4501                	li	a0,0
    2668:	00003097          	auipc	ra,0x3
    266c:	ed0080e7          	jalr	-304(ra) # 5538 <sbrk>
    2670:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2672:	757d                	lui	a0,0xfffff
    2674:	00003097          	auipc	ra,0x3
    2678:	ec4080e7          	jalr	-316(ra) # 5538 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    267c:	57fd                	li	a5,-1
    267e:	0af50363          	beq	a0,a5,2724 <sbrkmuch+0x124>
  c = sbrk(0);
    2682:	4501                	li	a0,0
    2684:	00003097          	auipc	ra,0x3
    2688:	eb4080e7          	jalr	-332(ra) # 5538 <sbrk>
  if(c != a - PGSIZE){
    268c:	77fd                	lui	a5,0xfffff
    268e:	97a6                	add	a5,a5,s1
    2690:	0af51863          	bne	a0,a5,2740 <sbrkmuch+0x140>
  a = sbrk(0);
    2694:	4501                	li	a0,0
    2696:	00003097          	auipc	ra,0x3
    269a:	ea2080e7          	jalr	-350(ra) # 5538 <sbrk>
    269e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    26a0:	6505                	lui	a0,0x1
    26a2:	00003097          	auipc	ra,0x3
    26a6:	e96080e7          	jalr	-362(ra) # 5538 <sbrk>
    26aa:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    26ac:	0aa49a63          	bne	s1,a0,2760 <sbrkmuch+0x160>
    26b0:	4501                	li	a0,0
    26b2:	00003097          	auipc	ra,0x3
    26b6:	e86080e7          	jalr	-378(ra) # 5538 <sbrk>
    26ba:	6785                	lui	a5,0x1
    26bc:	97a6                	add	a5,a5,s1
    26be:	0af51163          	bne	a0,a5,2760 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    26c2:	064007b7          	lui	a5,0x6400
    26c6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f169f>
    26ca:	06300793          	li	a5,99
    26ce:	0af70963          	beq	a4,a5,2780 <sbrkmuch+0x180>
  a = sbrk(0);
    26d2:	4501                	li	a0,0
    26d4:	00003097          	auipc	ra,0x3
    26d8:	e64080e7          	jalr	-412(ra) # 5538 <sbrk>
    26dc:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    26de:	4501                	li	a0,0
    26e0:	00003097          	auipc	ra,0x3
    26e4:	e58080e7          	jalr	-424(ra) # 5538 <sbrk>
    26e8:	40a9053b          	subw	a0,s2,a0
    26ec:	00003097          	auipc	ra,0x3
    26f0:	e4c080e7          	jalr	-436(ra) # 5538 <sbrk>
  if(c != a){
    26f4:	0aa49463          	bne	s1,a0,279c <sbrkmuch+0x19c>
}
    26f8:	70a2                	ld	ra,40(sp)
    26fa:	7402                	ld	s0,32(sp)
    26fc:	64e2                	ld	s1,24(sp)
    26fe:	6942                	ld	s2,16(sp)
    2700:	69a2                	ld	s3,8(sp)
    2702:	6a02                	ld	s4,0(sp)
    2704:	6145                	add	sp,sp,48
    2706:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2708:	85ce                	mv	a1,s3
    270a:	00004517          	auipc	a0,0x4
    270e:	0de50513          	add	a0,a0,222 # 67e8 <malloc+0xf18>
    2712:	00003097          	auipc	ra,0x3
    2716:	106080e7          	jalr	262(ra) # 5818 <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	00003097          	auipc	ra,0x3
    2720:	d94080e7          	jalr	-620(ra) # 54b0 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2724:	85ce                	mv	a1,s3
    2726:	00004517          	auipc	a0,0x4
    272a:	10a50513          	add	a0,a0,266 # 6830 <malloc+0xf60>
    272e:	00003097          	auipc	ra,0x3
    2732:	0ea080e7          	jalr	234(ra) # 5818 <printf>
    exit(1);
    2736:	4505                	li	a0,1
    2738:	00003097          	auipc	ra,0x3
    273c:	d78080e7          	jalr	-648(ra) # 54b0 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2740:	86aa                	mv	a3,a0
    2742:	8626                	mv	a2,s1
    2744:	85ce                	mv	a1,s3
    2746:	00004517          	auipc	a0,0x4
    274a:	10a50513          	add	a0,a0,266 # 6850 <malloc+0xf80>
    274e:	00003097          	auipc	ra,0x3
    2752:	0ca080e7          	jalr	202(ra) # 5818 <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	00003097          	auipc	ra,0x3
    275c:	d58080e7          	jalr	-680(ra) # 54b0 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2760:	86d2                	mv	a3,s4
    2762:	8626                	mv	a2,s1
    2764:	85ce                	mv	a1,s3
    2766:	00004517          	auipc	a0,0x4
    276a:	12a50513          	add	a0,a0,298 # 6890 <malloc+0xfc0>
    276e:	00003097          	auipc	ra,0x3
    2772:	0aa080e7          	jalr	170(ra) # 5818 <printf>
    exit(1);
    2776:	4505                	li	a0,1
    2778:	00003097          	auipc	ra,0x3
    277c:	d38080e7          	jalr	-712(ra) # 54b0 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2780:	85ce                	mv	a1,s3
    2782:	00004517          	auipc	a0,0x4
    2786:	13e50513          	add	a0,a0,318 # 68c0 <malloc+0xff0>
    278a:	00003097          	auipc	ra,0x3
    278e:	08e080e7          	jalr	142(ra) # 5818 <printf>
    exit(1);
    2792:	4505                	li	a0,1
    2794:	00003097          	auipc	ra,0x3
    2798:	d1c080e7          	jalr	-740(ra) # 54b0 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    279c:	86aa                	mv	a3,a0
    279e:	8626                	mv	a2,s1
    27a0:	85ce                	mv	a1,s3
    27a2:	00004517          	auipc	a0,0x4
    27a6:	15650513          	add	a0,a0,342 # 68f8 <malloc+0x1028>
    27aa:	00003097          	auipc	ra,0x3
    27ae:	06e080e7          	jalr	110(ra) # 5818 <printf>
    exit(1);
    27b2:	4505                	li	a0,1
    27b4:	00003097          	auipc	ra,0x3
    27b8:	cfc080e7          	jalr	-772(ra) # 54b0 <exit>

00000000000027bc <sbrkarg>:
{
    27bc:	7179                	add	sp,sp,-48
    27be:	f406                	sd	ra,40(sp)
    27c0:	f022                	sd	s0,32(sp)
    27c2:	ec26                	sd	s1,24(sp)
    27c4:	e84a                	sd	s2,16(sp)
    27c6:	e44e                	sd	s3,8(sp)
    27c8:	1800                	add	s0,sp,48
    27ca:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    27cc:	6505                	lui	a0,0x1
    27ce:	00003097          	auipc	ra,0x3
    27d2:	d6a080e7          	jalr	-662(ra) # 5538 <sbrk>
    27d6:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    27d8:	20100593          	li	a1,513
    27dc:	00004517          	auipc	a0,0x4
    27e0:	14450513          	add	a0,a0,324 # 6920 <malloc+0x1050>
    27e4:	00003097          	auipc	ra,0x3
    27e8:	d0c080e7          	jalr	-756(ra) # 54f0 <open>
    27ec:	84aa                	mv	s1,a0
  unlink("sbrk");
    27ee:	00004517          	auipc	a0,0x4
    27f2:	13250513          	add	a0,a0,306 # 6920 <malloc+0x1050>
    27f6:	00003097          	auipc	ra,0x3
    27fa:	d0a080e7          	jalr	-758(ra) # 5500 <unlink>
  if(fd < 0)  {
    27fe:	0404c163          	bltz	s1,2840 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2802:	6605                	lui	a2,0x1
    2804:	85ca                	mv	a1,s2
    2806:	8526                	mv	a0,s1
    2808:	00003097          	auipc	ra,0x3
    280c:	cc8080e7          	jalr	-824(ra) # 54d0 <write>
    2810:	04054663          	bltz	a0,285c <sbrkarg+0xa0>
  close(fd);
    2814:	8526                	mv	a0,s1
    2816:	00003097          	auipc	ra,0x3
    281a:	cc2080e7          	jalr	-830(ra) # 54d8 <close>
  a = sbrk(PGSIZE);
    281e:	6505                	lui	a0,0x1
    2820:	00003097          	auipc	ra,0x3
    2824:	d18080e7          	jalr	-744(ra) # 5538 <sbrk>
  if(pipe((int *) a) != 0){
    2828:	00003097          	auipc	ra,0x3
    282c:	c98080e7          	jalr	-872(ra) # 54c0 <pipe>
    2830:	e521                	bnez	a0,2878 <sbrkarg+0xbc>
}
    2832:	70a2                	ld	ra,40(sp)
    2834:	7402                	ld	s0,32(sp)
    2836:	64e2                	ld	s1,24(sp)
    2838:	6942                	ld	s2,16(sp)
    283a:	69a2                	ld	s3,8(sp)
    283c:	6145                	add	sp,sp,48
    283e:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2840:	85ce                	mv	a1,s3
    2842:	00004517          	auipc	a0,0x4
    2846:	0e650513          	add	a0,a0,230 # 6928 <malloc+0x1058>
    284a:	00003097          	auipc	ra,0x3
    284e:	fce080e7          	jalr	-50(ra) # 5818 <printf>
    exit(1);
    2852:	4505                	li	a0,1
    2854:	00003097          	auipc	ra,0x3
    2858:	c5c080e7          	jalr	-932(ra) # 54b0 <exit>
    printf("%s: write sbrk failed\n", s);
    285c:	85ce                	mv	a1,s3
    285e:	00004517          	auipc	a0,0x4
    2862:	0e250513          	add	a0,a0,226 # 6940 <malloc+0x1070>
    2866:	00003097          	auipc	ra,0x3
    286a:	fb2080e7          	jalr	-78(ra) # 5818 <printf>
    exit(1);
    286e:	4505                	li	a0,1
    2870:	00003097          	auipc	ra,0x3
    2874:	c40080e7          	jalr	-960(ra) # 54b0 <exit>
    printf("%s: pipe() failed\n", s);
    2878:	85ce                	mv	a1,s3
    287a:	00004517          	auipc	a0,0x4
    287e:	ad650513          	add	a0,a0,-1322 # 6350 <malloc+0xa80>
    2882:	00003097          	auipc	ra,0x3
    2886:	f96080e7          	jalr	-106(ra) # 5818 <printf>
    exit(1);
    288a:	4505                	li	a0,1
    288c:	00003097          	auipc	ra,0x3
    2890:	c24080e7          	jalr	-988(ra) # 54b0 <exit>

0000000000002894 <argptest>:
{
    2894:	1101                	add	sp,sp,-32
    2896:	ec06                	sd	ra,24(sp)
    2898:	e822                	sd	s0,16(sp)
    289a:	e426                	sd	s1,8(sp)
    289c:	e04a                	sd	s2,0(sp)
    289e:	1000                	add	s0,sp,32
    28a0:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    28a2:	4581                	li	a1,0
    28a4:	00004517          	auipc	a0,0x4
    28a8:	0b450513          	add	a0,a0,180 # 6958 <malloc+0x1088>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	c44080e7          	jalr	-956(ra) # 54f0 <open>
  if (fd < 0) {
    28b4:	02054b63          	bltz	a0,28ea <argptest+0x56>
    28b8:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    28ba:	4501                	li	a0,0
    28bc:	00003097          	auipc	ra,0x3
    28c0:	c7c080e7          	jalr	-900(ra) # 5538 <sbrk>
    28c4:	567d                	li	a2,-1
    28c6:	fff50593          	add	a1,a0,-1
    28ca:	8526                	mv	a0,s1
    28cc:	00003097          	auipc	ra,0x3
    28d0:	bfc080e7          	jalr	-1028(ra) # 54c8 <read>
  close(fd);
    28d4:	8526                	mv	a0,s1
    28d6:	00003097          	auipc	ra,0x3
    28da:	c02080e7          	jalr	-1022(ra) # 54d8 <close>
}
    28de:	60e2                	ld	ra,24(sp)
    28e0:	6442                	ld	s0,16(sp)
    28e2:	64a2                	ld	s1,8(sp)
    28e4:	6902                	ld	s2,0(sp)
    28e6:	6105                	add	sp,sp,32
    28e8:	8082                	ret
    printf("%s: open failed\n", s);
    28ea:	85ca                	mv	a1,s2
    28ec:	00004517          	auipc	a0,0x4
    28f0:	97450513          	add	a0,a0,-1676 # 6260 <malloc+0x990>
    28f4:	00003097          	auipc	ra,0x3
    28f8:	f24080e7          	jalr	-220(ra) # 5818 <printf>
    exit(1);
    28fc:	4505                	li	a0,1
    28fe:	00003097          	auipc	ra,0x3
    2902:	bb2080e7          	jalr	-1102(ra) # 54b0 <exit>

0000000000002906 <sbrkbugs>:
{
    2906:	1141                	add	sp,sp,-16
    2908:	e406                	sd	ra,8(sp)
    290a:	e022                	sd	s0,0(sp)
    290c:	0800                	add	s0,sp,16
  int pid = fork();
    290e:	00003097          	auipc	ra,0x3
    2912:	b9a080e7          	jalr	-1126(ra) # 54a8 <fork>
  if(pid < 0){
    2916:	02054263          	bltz	a0,293a <sbrkbugs+0x34>
  if(pid == 0){
    291a:	ed0d                	bnez	a0,2954 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    291c:	00003097          	auipc	ra,0x3
    2920:	c1c080e7          	jalr	-996(ra) # 5538 <sbrk>
    sbrk(-sz);
    2924:	40a0053b          	negw	a0,a0
    2928:	00003097          	auipc	ra,0x3
    292c:	c10080e7          	jalr	-1008(ra) # 5538 <sbrk>
    exit(0);
    2930:	4501                	li	a0,0
    2932:	00003097          	auipc	ra,0x3
    2936:	b7e080e7          	jalr	-1154(ra) # 54b0 <exit>
    printf("fork failed\n");
    293a:	00004517          	auipc	a0,0x4
    293e:	cfe50513          	add	a0,a0,-770 # 6638 <malloc+0xd68>
    2942:	00003097          	auipc	ra,0x3
    2946:	ed6080e7          	jalr	-298(ra) # 5818 <printf>
    exit(1);
    294a:	4505                	li	a0,1
    294c:	00003097          	auipc	ra,0x3
    2950:	b64080e7          	jalr	-1180(ra) # 54b0 <exit>
  wait(0);
    2954:	4501                	li	a0,0
    2956:	00003097          	auipc	ra,0x3
    295a:	b62080e7          	jalr	-1182(ra) # 54b8 <wait>
  pid = fork();
    295e:	00003097          	auipc	ra,0x3
    2962:	b4a080e7          	jalr	-1206(ra) # 54a8 <fork>
  if(pid < 0){
    2966:	02054563          	bltz	a0,2990 <sbrkbugs+0x8a>
  if(pid == 0){
    296a:	e121                	bnez	a0,29aa <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    296c:	00003097          	auipc	ra,0x3
    2970:	bcc080e7          	jalr	-1076(ra) # 5538 <sbrk>
    sbrk(-(sz - 3500));
    2974:	6785                	lui	a5,0x1
    2976:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x84>
    297a:	40a7853b          	subw	a0,a5,a0
    297e:	00003097          	auipc	ra,0x3
    2982:	bba080e7          	jalr	-1094(ra) # 5538 <sbrk>
    exit(0);
    2986:	4501                	li	a0,0
    2988:	00003097          	auipc	ra,0x3
    298c:	b28080e7          	jalr	-1240(ra) # 54b0 <exit>
    printf("fork failed\n");
    2990:	00004517          	auipc	a0,0x4
    2994:	ca850513          	add	a0,a0,-856 # 6638 <malloc+0xd68>
    2998:	00003097          	auipc	ra,0x3
    299c:	e80080e7          	jalr	-384(ra) # 5818 <printf>
    exit(1);
    29a0:	4505                	li	a0,1
    29a2:	00003097          	auipc	ra,0x3
    29a6:	b0e080e7          	jalr	-1266(ra) # 54b0 <exit>
  wait(0);
    29aa:	4501                	li	a0,0
    29ac:	00003097          	auipc	ra,0x3
    29b0:	b0c080e7          	jalr	-1268(ra) # 54b8 <wait>
  pid = fork();
    29b4:	00003097          	auipc	ra,0x3
    29b8:	af4080e7          	jalr	-1292(ra) # 54a8 <fork>
  if(pid < 0){
    29bc:	02054a63          	bltz	a0,29f0 <sbrkbugs+0xea>
  if(pid == 0){
    29c0:	e529                	bnez	a0,2a0a <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    29c2:	00003097          	auipc	ra,0x3
    29c6:	b76080e7          	jalr	-1162(ra) # 5538 <sbrk>
    29ca:	67ad                	lui	a5,0xb
    29cc:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x15c0>
    29d0:	40a7853b          	subw	a0,a5,a0
    29d4:	00003097          	auipc	ra,0x3
    29d8:	b64080e7          	jalr	-1180(ra) # 5538 <sbrk>
    sbrk(-10);
    29dc:	5559                	li	a0,-10
    29de:	00003097          	auipc	ra,0x3
    29e2:	b5a080e7          	jalr	-1190(ra) # 5538 <sbrk>
    exit(0);
    29e6:	4501                	li	a0,0
    29e8:	00003097          	auipc	ra,0x3
    29ec:	ac8080e7          	jalr	-1336(ra) # 54b0 <exit>
    printf("fork failed\n");
    29f0:	00004517          	auipc	a0,0x4
    29f4:	c4850513          	add	a0,a0,-952 # 6638 <malloc+0xd68>
    29f8:	00003097          	auipc	ra,0x3
    29fc:	e20080e7          	jalr	-480(ra) # 5818 <printf>
    exit(1);
    2a00:	4505                	li	a0,1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	aae080e7          	jalr	-1362(ra) # 54b0 <exit>
  wait(0);
    2a0a:	4501                	li	a0,0
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	aac080e7          	jalr	-1364(ra) # 54b8 <wait>
  exit(0);
    2a14:	4501                	li	a0,0
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	a9a080e7          	jalr	-1382(ra) # 54b0 <exit>

0000000000002a1e <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2a1e:	715d                	add	sp,sp,-80
    2a20:	e486                	sd	ra,72(sp)
    2a22:	e0a2                	sd	s0,64(sp)
    2a24:	fc26                	sd	s1,56(sp)
    2a26:	f84a                	sd	s2,48(sp)
    2a28:	f44e                	sd	s3,40(sp)
    2a2a:	f052                	sd	s4,32(sp)
    2a2c:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2a2e:	4901                	li	s2,0
    2a30:	49bd                	li	s3,15
    int pid = fork();
    2a32:	00003097          	auipc	ra,0x3
    2a36:	a76080e7          	jalr	-1418(ra) # 54a8 <fork>
    2a3a:	84aa                	mv	s1,a0
    if(pid < 0){
    2a3c:	02054063          	bltz	a0,2a5c <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2a40:	c91d                	beqz	a0,2a76 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2a42:	4501                	li	a0,0
    2a44:	00003097          	auipc	ra,0x3
    2a48:	a74080e7          	jalr	-1420(ra) # 54b8 <wait>
  for(int avail = 0; avail < 15; avail++){
    2a4c:	2905                	addw	s2,s2,1
    2a4e:	ff3912e3          	bne	s2,s3,2a32 <execout+0x14>
    }
  }

  exit(0);
    2a52:	4501                	li	a0,0
    2a54:	00003097          	auipc	ra,0x3
    2a58:	a5c080e7          	jalr	-1444(ra) # 54b0 <exit>
      printf("fork failed\n");
    2a5c:	00004517          	auipc	a0,0x4
    2a60:	bdc50513          	add	a0,a0,-1060 # 6638 <malloc+0xd68>
    2a64:	00003097          	auipc	ra,0x3
    2a68:	db4080e7          	jalr	-588(ra) # 5818 <printf>
      exit(1);
    2a6c:	4505                	li	a0,1
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	a42080e7          	jalr	-1470(ra) # 54b0 <exit>
        if(a == 0xffffffffffffffffLL)
    2a76:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2a78:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2a7a:	6505                	lui	a0,0x1
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	abc080e7          	jalr	-1348(ra) # 5538 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2a84:	01350763          	beq	a0,s3,2a92 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2a88:	6785                	lui	a5,0x1
    2a8a:	97aa                	add	a5,a5,a0
    2a8c:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x8b>
      while(1){
    2a90:	b7ed                	j	2a7a <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2a92:	01205a63          	blez	s2,2aa6 <execout+0x88>
        sbrk(-4096);
    2a96:	757d                	lui	a0,0xfffff
    2a98:	00003097          	auipc	ra,0x3
    2a9c:	aa0080e7          	jalr	-1376(ra) # 5538 <sbrk>
      for(int i = 0; i < avail; i++)
    2aa0:	2485                	addw	s1,s1,1
    2aa2:	ff249ae3          	bne	s1,s2,2a96 <execout+0x78>
      close(1);
    2aa6:	4505                	li	a0,1
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	a30080e7          	jalr	-1488(ra) # 54d8 <close>
      char *args[] = { "echo", "x", 0 };
    2ab0:	00003517          	auipc	a0,0x3
    2ab4:	f4050513          	add	a0,a0,-192 # 59f0 <malloc+0x120>
    2ab8:	faa43c23          	sd	a0,-72(s0)
    2abc:	00003797          	auipc	a5,0x3
    2ac0:	fa478793          	add	a5,a5,-92 # 5a60 <malloc+0x190>
    2ac4:	fcf43023          	sd	a5,-64(s0)
    2ac8:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2acc:	fb840593          	add	a1,s0,-72
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	a18080e7          	jalr	-1512(ra) # 54e8 <exec>
      exit(0);
    2ad8:	4501                	li	a0,0
    2ada:	00003097          	auipc	ra,0x3
    2ade:	9d6080e7          	jalr	-1578(ra) # 54b0 <exit>

0000000000002ae2 <fourteen>:
{
    2ae2:	1101                	add	sp,sp,-32
    2ae4:	ec06                	sd	ra,24(sp)
    2ae6:	e822                	sd	s0,16(sp)
    2ae8:	e426                	sd	s1,8(sp)
    2aea:	1000                	add	s0,sp,32
    2aec:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2aee:	00004517          	auipc	a0,0x4
    2af2:	04250513          	add	a0,a0,66 # 6b30 <malloc+0x1260>
    2af6:	00003097          	auipc	ra,0x3
    2afa:	a22080e7          	jalr	-1502(ra) # 5518 <mkdir>
    2afe:	e165                	bnez	a0,2bde <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2b00:	00004517          	auipc	a0,0x4
    2b04:	e8850513          	add	a0,a0,-376 # 6988 <malloc+0x10b8>
    2b08:	00003097          	auipc	ra,0x3
    2b0c:	a10080e7          	jalr	-1520(ra) # 5518 <mkdir>
    2b10:	e56d                	bnez	a0,2bfa <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2b12:	20000593          	li	a1,512
    2b16:	00004517          	auipc	a0,0x4
    2b1a:	eca50513          	add	a0,a0,-310 # 69e0 <malloc+0x1110>
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	9d2080e7          	jalr	-1582(ra) # 54f0 <open>
  if(fd < 0){
    2b26:	0e054863          	bltz	a0,2c16 <fourteen+0x134>
  close(fd);
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	9ae080e7          	jalr	-1618(ra) # 54d8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2b32:	4581                	li	a1,0
    2b34:	00004517          	auipc	a0,0x4
    2b38:	f2450513          	add	a0,a0,-220 # 6a58 <malloc+0x1188>
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	9b4080e7          	jalr	-1612(ra) # 54f0 <open>
  if(fd < 0){
    2b44:	0e054763          	bltz	a0,2c32 <fourteen+0x150>
  close(fd);
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	990080e7          	jalr	-1648(ra) # 54d8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2b50:	00004517          	auipc	a0,0x4
    2b54:	f7850513          	add	a0,a0,-136 # 6ac8 <malloc+0x11f8>
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	9c0080e7          	jalr	-1600(ra) # 5518 <mkdir>
    2b60:	c57d                	beqz	a0,2c4e <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2b62:	00004517          	auipc	a0,0x4
    2b66:	fbe50513          	add	a0,a0,-66 # 6b20 <malloc+0x1250>
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	9ae080e7          	jalr	-1618(ra) # 5518 <mkdir>
    2b72:	cd65                	beqz	a0,2c6a <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2b74:	00004517          	auipc	a0,0x4
    2b78:	fac50513          	add	a0,a0,-84 # 6b20 <malloc+0x1250>
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	984080e7          	jalr	-1660(ra) # 5500 <unlink>
  unlink("12345678901234/12345678901234");
    2b84:	00004517          	auipc	a0,0x4
    2b88:	f4450513          	add	a0,a0,-188 # 6ac8 <malloc+0x11f8>
    2b8c:	00003097          	auipc	ra,0x3
    2b90:	974080e7          	jalr	-1676(ra) # 5500 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	ec450513          	add	a0,a0,-316 # 6a58 <malloc+0x1188>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	964080e7          	jalr	-1692(ra) # 5500 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	e3c50513          	add	a0,a0,-452 # 69e0 <malloc+0x1110>
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	954080e7          	jalr	-1708(ra) # 5500 <unlink>
  unlink("12345678901234/123456789012345");
    2bb4:	00004517          	auipc	a0,0x4
    2bb8:	dd450513          	add	a0,a0,-556 # 6988 <malloc+0x10b8>
    2bbc:	00003097          	auipc	ra,0x3
    2bc0:	944080e7          	jalr	-1724(ra) # 5500 <unlink>
  unlink("12345678901234");
    2bc4:	00004517          	auipc	a0,0x4
    2bc8:	f6c50513          	add	a0,a0,-148 # 6b30 <malloc+0x1260>
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	934080e7          	jalr	-1740(ra) # 5500 <unlink>
}
    2bd4:	60e2                	ld	ra,24(sp)
    2bd6:	6442                	ld	s0,16(sp)
    2bd8:	64a2                	ld	s1,8(sp)
    2bda:	6105                	add	sp,sp,32
    2bdc:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2bde:	85a6                	mv	a1,s1
    2be0:	00004517          	auipc	a0,0x4
    2be4:	d8050513          	add	a0,a0,-640 # 6960 <malloc+0x1090>
    2be8:	00003097          	auipc	ra,0x3
    2bec:	c30080e7          	jalr	-976(ra) # 5818 <printf>
    exit(1);
    2bf0:	4505                	li	a0,1
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	8be080e7          	jalr	-1858(ra) # 54b0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2bfa:	85a6                	mv	a1,s1
    2bfc:	00004517          	auipc	a0,0x4
    2c00:	dac50513          	add	a0,a0,-596 # 69a8 <malloc+0x10d8>
    2c04:	00003097          	auipc	ra,0x3
    2c08:	c14080e7          	jalr	-1004(ra) # 5818 <printf>
    exit(1);
    2c0c:	4505                	li	a0,1
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	8a2080e7          	jalr	-1886(ra) # 54b0 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2c16:	85a6                	mv	a1,s1
    2c18:	00004517          	auipc	a0,0x4
    2c1c:	df850513          	add	a0,a0,-520 # 6a10 <malloc+0x1140>
    2c20:	00003097          	auipc	ra,0x3
    2c24:	bf8080e7          	jalr	-1032(ra) # 5818 <printf>
    exit(1);
    2c28:	4505                	li	a0,1
    2c2a:	00003097          	auipc	ra,0x3
    2c2e:	886080e7          	jalr	-1914(ra) # 54b0 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2c32:	85a6                	mv	a1,s1
    2c34:	00004517          	auipc	a0,0x4
    2c38:	e5450513          	add	a0,a0,-428 # 6a88 <malloc+0x11b8>
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	bdc080e7          	jalr	-1060(ra) # 5818 <printf>
    exit(1);
    2c44:	4505                	li	a0,1
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	86a080e7          	jalr	-1942(ra) # 54b0 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2c4e:	85a6                	mv	a1,s1
    2c50:	00004517          	auipc	a0,0x4
    2c54:	e9850513          	add	a0,a0,-360 # 6ae8 <malloc+0x1218>
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	bc0080e7          	jalr	-1088(ra) # 5818 <printf>
    exit(1);
    2c60:	4505                	li	a0,1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	84e080e7          	jalr	-1970(ra) # 54b0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2c6a:	85a6                	mv	a1,s1
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	ed450513          	add	a0,a0,-300 # 6b40 <malloc+0x1270>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	ba4080e7          	jalr	-1116(ra) # 5818 <printf>
    exit(1);
    2c7c:	4505                	li	a0,1
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	832080e7          	jalr	-1998(ra) # 54b0 <exit>

0000000000002c86 <iputtest>:
{
    2c86:	1101                	add	sp,sp,-32
    2c88:	ec06                	sd	ra,24(sp)
    2c8a:	e822                	sd	s0,16(sp)
    2c8c:	e426                	sd	s1,8(sp)
    2c8e:	1000                	add	s0,sp,32
    2c90:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2c92:	00004517          	auipc	a0,0x4
    2c96:	ee650513          	add	a0,a0,-282 # 6b78 <malloc+0x12a8>
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	87e080e7          	jalr	-1922(ra) # 5518 <mkdir>
    2ca2:	04054563          	bltz	a0,2cec <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ca6:	00004517          	auipc	a0,0x4
    2caa:	ed250513          	add	a0,a0,-302 # 6b78 <malloc+0x12a8>
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	872080e7          	jalr	-1934(ra) # 5520 <chdir>
    2cb6:	04054963          	bltz	a0,2d08 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	efe50513          	add	a0,a0,-258 # 6bb8 <malloc+0x12e8>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	83e080e7          	jalr	-1986(ra) # 5500 <unlink>
    2cca:	04054d63          	bltz	a0,2d24 <iputtest+0x9e>
  if(chdir("/") < 0){
    2cce:	00004517          	auipc	a0,0x4
    2cd2:	f1a50513          	add	a0,a0,-230 # 6be8 <malloc+0x1318>
    2cd6:	00003097          	auipc	ra,0x3
    2cda:	84a080e7          	jalr	-1974(ra) # 5520 <chdir>
    2cde:	06054163          	bltz	a0,2d40 <iputtest+0xba>
}
    2ce2:	60e2                	ld	ra,24(sp)
    2ce4:	6442                	ld	s0,16(sp)
    2ce6:	64a2                	ld	s1,8(sp)
    2ce8:	6105                	add	sp,sp,32
    2cea:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cec:	85a6                	mv	a1,s1
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	e9250513          	add	a0,a0,-366 # 6b80 <malloc+0x12b0>
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	b22080e7          	jalr	-1246(ra) # 5818 <printf>
    exit(1);
    2cfe:	4505                	li	a0,1
    2d00:	00002097          	auipc	ra,0x2
    2d04:	7b0080e7          	jalr	1968(ra) # 54b0 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2d08:	85a6                	mv	a1,s1
    2d0a:	00004517          	auipc	a0,0x4
    2d0e:	e8e50513          	add	a0,a0,-370 # 6b98 <malloc+0x12c8>
    2d12:	00003097          	auipc	ra,0x3
    2d16:	b06080e7          	jalr	-1274(ra) # 5818 <printf>
    exit(1);
    2d1a:	4505                	li	a0,1
    2d1c:	00002097          	auipc	ra,0x2
    2d20:	794080e7          	jalr	1940(ra) # 54b0 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2d24:	85a6                	mv	a1,s1
    2d26:	00004517          	auipc	a0,0x4
    2d2a:	ea250513          	add	a0,a0,-350 # 6bc8 <malloc+0x12f8>
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	aea080e7          	jalr	-1302(ra) # 5818 <printf>
    exit(1);
    2d36:	4505                	li	a0,1
    2d38:	00002097          	auipc	ra,0x2
    2d3c:	778080e7          	jalr	1912(ra) # 54b0 <exit>
    printf("%s: chdir / failed\n", s);
    2d40:	85a6                	mv	a1,s1
    2d42:	00004517          	auipc	a0,0x4
    2d46:	eae50513          	add	a0,a0,-338 # 6bf0 <malloc+0x1320>
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	ace080e7          	jalr	-1330(ra) # 5818 <printf>
    exit(1);
    2d52:	4505                	li	a0,1
    2d54:	00002097          	auipc	ra,0x2
    2d58:	75c080e7          	jalr	1884(ra) # 54b0 <exit>

0000000000002d5c <exitiputtest>:
{
    2d5c:	7179                	add	sp,sp,-48
    2d5e:	f406                	sd	ra,40(sp)
    2d60:	f022                	sd	s0,32(sp)
    2d62:	ec26                	sd	s1,24(sp)
    2d64:	1800                	add	s0,sp,48
    2d66:	84aa                	mv	s1,a0
  pid = fork();
    2d68:	00002097          	auipc	ra,0x2
    2d6c:	740080e7          	jalr	1856(ra) # 54a8 <fork>
  if(pid < 0){
    2d70:	04054663          	bltz	a0,2dbc <exitiputtest+0x60>
  if(pid == 0){
    2d74:	ed45                	bnez	a0,2e2c <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	e0250513          	add	a0,a0,-510 # 6b78 <malloc+0x12a8>
    2d7e:	00002097          	auipc	ra,0x2
    2d82:	79a080e7          	jalr	1946(ra) # 5518 <mkdir>
    2d86:	04054963          	bltz	a0,2dd8 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2d8a:	00004517          	auipc	a0,0x4
    2d8e:	dee50513          	add	a0,a0,-530 # 6b78 <malloc+0x12a8>
    2d92:	00002097          	auipc	ra,0x2
    2d96:	78e080e7          	jalr	1934(ra) # 5520 <chdir>
    2d9a:	04054d63          	bltz	a0,2df4 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	e1a50513          	add	a0,a0,-486 # 6bb8 <malloc+0x12e8>
    2da6:	00002097          	auipc	ra,0x2
    2daa:	75a080e7          	jalr	1882(ra) # 5500 <unlink>
    2dae:	06054163          	bltz	a0,2e10 <exitiputtest+0xb4>
    exit(0);
    2db2:	4501                	li	a0,0
    2db4:	00002097          	auipc	ra,0x2
    2db8:	6fc080e7          	jalr	1788(ra) # 54b0 <exit>
    printf("%s: fork failed\n", s);
    2dbc:	85a6                	mv	a1,s1
    2dbe:	00003517          	auipc	a0,0x3
    2dc2:	48a50513          	add	a0,a0,1162 # 6248 <malloc+0x978>
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	a52080e7          	jalr	-1454(ra) # 5818 <printf>
    exit(1);
    2dce:	4505                	li	a0,1
    2dd0:	00002097          	auipc	ra,0x2
    2dd4:	6e0080e7          	jalr	1760(ra) # 54b0 <exit>
      printf("%s: mkdir failed\n", s);
    2dd8:	85a6                	mv	a1,s1
    2dda:	00004517          	auipc	a0,0x4
    2dde:	da650513          	add	a0,a0,-602 # 6b80 <malloc+0x12b0>
    2de2:	00003097          	auipc	ra,0x3
    2de6:	a36080e7          	jalr	-1482(ra) # 5818 <printf>
      exit(1);
    2dea:	4505                	li	a0,1
    2dec:	00002097          	auipc	ra,0x2
    2df0:	6c4080e7          	jalr	1732(ra) # 54b0 <exit>
      printf("%s: child chdir failed\n", s);
    2df4:	85a6                	mv	a1,s1
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	e1250513          	add	a0,a0,-494 # 6c08 <malloc+0x1338>
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	a1a080e7          	jalr	-1510(ra) # 5818 <printf>
      exit(1);
    2e06:	4505                	li	a0,1
    2e08:	00002097          	auipc	ra,0x2
    2e0c:	6a8080e7          	jalr	1704(ra) # 54b0 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2e10:	85a6                	mv	a1,s1
    2e12:	00004517          	auipc	a0,0x4
    2e16:	db650513          	add	a0,a0,-586 # 6bc8 <malloc+0x12f8>
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	9fe080e7          	jalr	-1538(ra) # 5818 <printf>
      exit(1);
    2e22:	4505                	li	a0,1
    2e24:	00002097          	auipc	ra,0x2
    2e28:	68c080e7          	jalr	1676(ra) # 54b0 <exit>
  wait(&xstatus);
    2e2c:	fdc40513          	add	a0,s0,-36
    2e30:	00002097          	auipc	ra,0x2
    2e34:	688080e7          	jalr	1672(ra) # 54b8 <wait>
  exit(xstatus);
    2e38:	fdc42503          	lw	a0,-36(s0)
    2e3c:	00002097          	auipc	ra,0x2
    2e40:	674080e7          	jalr	1652(ra) # 54b0 <exit>

0000000000002e44 <dirtest>:
{
    2e44:	1101                	add	sp,sp,-32
    2e46:	ec06                	sd	ra,24(sp)
    2e48:	e822                	sd	s0,16(sp)
    2e4a:	e426                	sd	s1,8(sp)
    2e4c:	1000                	add	s0,sp,32
    2e4e:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2e50:	00004517          	auipc	a0,0x4
    2e54:	dd050513          	add	a0,a0,-560 # 6c20 <malloc+0x1350>
    2e58:	00002097          	auipc	ra,0x2
    2e5c:	6c0080e7          	jalr	1728(ra) # 5518 <mkdir>
    2e60:	04054563          	bltz	a0,2eaa <dirtest+0x66>
  if(chdir("dir0") < 0){
    2e64:	00004517          	auipc	a0,0x4
    2e68:	dbc50513          	add	a0,a0,-580 # 6c20 <malloc+0x1350>
    2e6c:	00002097          	auipc	ra,0x2
    2e70:	6b4080e7          	jalr	1716(ra) # 5520 <chdir>
    2e74:	04054963          	bltz	a0,2ec6 <dirtest+0x82>
  if(chdir("..") < 0){
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	dc850513          	add	a0,a0,-568 # 6c40 <malloc+0x1370>
    2e80:	00002097          	auipc	ra,0x2
    2e84:	6a0080e7          	jalr	1696(ra) # 5520 <chdir>
    2e88:	04054d63          	bltz	a0,2ee2 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	d9450513          	add	a0,a0,-620 # 6c20 <malloc+0x1350>
    2e94:	00002097          	auipc	ra,0x2
    2e98:	66c080e7          	jalr	1644(ra) # 5500 <unlink>
    2e9c:	06054163          	bltz	a0,2efe <dirtest+0xba>
}
    2ea0:	60e2                	ld	ra,24(sp)
    2ea2:	6442                	ld	s0,16(sp)
    2ea4:	64a2                	ld	s1,8(sp)
    2ea6:	6105                	add	sp,sp,32
    2ea8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2eaa:	85a6                	mv	a1,s1
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	cd450513          	add	a0,a0,-812 # 6b80 <malloc+0x12b0>
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	964080e7          	jalr	-1692(ra) # 5818 <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00002097          	auipc	ra,0x2
    2ec2:	5f2080e7          	jalr	1522(ra) # 54b0 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ec6:	85a6                	mv	a1,s1
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	d6050513          	add	a0,a0,-672 # 6c28 <malloc+0x1358>
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	948080e7          	jalr	-1720(ra) # 5818 <printf>
    exit(1);
    2ed8:	4505                	li	a0,1
    2eda:	00002097          	auipc	ra,0x2
    2ede:	5d6080e7          	jalr	1494(ra) # 54b0 <exit>
    printf("%s: chdir .. failed\n", s);
    2ee2:	85a6                	mv	a1,s1
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	d6450513          	add	a0,a0,-668 # 6c48 <malloc+0x1378>
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	92c080e7          	jalr	-1748(ra) # 5818 <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	00002097          	auipc	ra,0x2
    2efa:	5ba080e7          	jalr	1466(ra) # 54b0 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2efe:	85a6                	mv	a1,s1
    2f00:	00004517          	auipc	a0,0x4
    2f04:	d6050513          	add	a0,a0,-672 # 6c60 <malloc+0x1390>
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	910080e7          	jalr	-1776(ra) # 5818 <printf>
    exit(1);
    2f10:	4505                	li	a0,1
    2f12:	00002097          	auipc	ra,0x2
    2f16:	59e080e7          	jalr	1438(ra) # 54b0 <exit>

0000000000002f1a <subdir>:
{
    2f1a:	1101                	add	sp,sp,-32
    2f1c:	ec06                	sd	ra,24(sp)
    2f1e:	e822                	sd	s0,16(sp)
    2f20:	e426                	sd	s1,8(sp)
    2f22:	e04a                	sd	s2,0(sp)
    2f24:	1000                	add	s0,sp,32
    2f26:	892a                	mv	s2,a0
  unlink("ff");
    2f28:	00004517          	auipc	a0,0x4
    2f2c:	e8050513          	add	a0,a0,-384 # 6da8 <malloc+0x14d8>
    2f30:	00002097          	auipc	ra,0x2
    2f34:	5d0080e7          	jalr	1488(ra) # 5500 <unlink>
  if(mkdir("dd") != 0){
    2f38:	00004517          	auipc	a0,0x4
    2f3c:	d4050513          	add	a0,a0,-704 # 6c78 <malloc+0x13a8>
    2f40:	00002097          	auipc	ra,0x2
    2f44:	5d8080e7          	jalr	1496(ra) # 5518 <mkdir>
    2f48:	38051663          	bnez	a0,32d4 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2f4c:	20200593          	li	a1,514
    2f50:	00004517          	auipc	a0,0x4
    2f54:	d4850513          	add	a0,a0,-696 # 6c98 <malloc+0x13c8>
    2f58:	00002097          	auipc	ra,0x2
    2f5c:	598080e7          	jalr	1432(ra) # 54f0 <open>
    2f60:	84aa                	mv	s1,a0
  if(fd < 0){
    2f62:	38054763          	bltz	a0,32f0 <subdir+0x3d6>
  write(fd, "ff", 2);
    2f66:	4609                	li	a2,2
    2f68:	00004597          	auipc	a1,0x4
    2f6c:	e4058593          	add	a1,a1,-448 # 6da8 <malloc+0x14d8>
    2f70:	00002097          	auipc	ra,0x2
    2f74:	560080e7          	jalr	1376(ra) # 54d0 <write>
  close(fd);
    2f78:	8526                	mv	a0,s1
    2f7a:	00002097          	auipc	ra,0x2
    2f7e:	55e080e7          	jalr	1374(ra) # 54d8 <close>
  if(unlink("dd") >= 0){
    2f82:	00004517          	auipc	a0,0x4
    2f86:	cf650513          	add	a0,a0,-778 # 6c78 <malloc+0x13a8>
    2f8a:	00002097          	auipc	ra,0x2
    2f8e:	576080e7          	jalr	1398(ra) # 5500 <unlink>
    2f92:	36055d63          	bgez	a0,330c <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	d5a50513          	add	a0,a0,-678 # 6cf0 <malloc+0x1420>
    2f9e:	00002097          	auipc	ra,0x2
    2fa2:	57a080e7          	jalr	1402(ra) # 5518 <mkdir>
    2fa6:	38051163          	bnez	a0,3328 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2faa:	20200593          	li	a1,514
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	d6a50513          	add	a0,a0,-662 # 6d18 <malloc+0x1448>
    2fb6:	00002097          	auipc	ra,0x2
    2fba:	53a080e7          	jalr	1338(ra) # 54f0 <open>
    2fbe:	84aa                	mv	s1,a0
  if(fd < 0){
    2fc0:	38054263          	bltz	a0,3344 <subdir+0x42a>
  write(fd, "FF", 2);
    2fc4:	4609                	li	a2,2
    2fc6:	00004597          	auipc	a1,0x4
    2fca:	d8258593          	add	a1,a1,-638 # 6d48 <malloc+0x1478>
    2fce:	00002097          	auipc	ra,0x2
    2fd2:	502080e7          	jalr	1282(ra) # 54d0 <write>
  close(fd);
    2fd6:	8526                	mv	a0,s1
    2fd8:	00002097          	auipc	ra,0x2
    2fdc:	500080e7          	jalr	1280(ra) # 54d8 <close>
  fd = open("dd/dd/../ff", 0);
    2fe0:	4581                	li	a1,0
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	d6e50513          	add	a0,a0,-658 # 6d50 <malloc+0x1480>
    2fea:	00002097          	auipc	ra,0x2
    2fee:	506080e7          	jalr	1286(ra) # 54f0 <open>
    2ff2:	84aa                	mv	s1,a0
  if(fd < 0){
    2ff4:	36054663          	bltz	a0,3360 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2ff8:	660d                	lui	a2,0x3
    2ffa:	00009597          	auipc	a1,0x9
    2ffe:	95658593          	add	a1,a1,-1706 # b950 <buf>
    3002:	00002097          	auipc	ra,0x2
    3006:	4c6080e7          	jalr	1222(ra) # 54c8 <read>
  if(cc != 2 || buf[0] != 'f'){
    300a:	4789                	li	a5,2
    300c:	36f51863          	bne	a0,a5,337c <subdir+0x462>
    3010:	00009717          	auipc	a4,0x9
    3014:	94074703          	lbu	a4,-1728(a4) # b950 <buf>
    3018:	06600793          	li	a5,102
    301c:	36f71063          	bne	a4,a5,337c <subdir+0x462>
  close(fd);
    3020:	8526                	mv	a0,s1
    3022:	00002097          	auipc	ra,0x2
    3026:	4b6080e7          	jalr	1206(ra) # 54d8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    302a:	00004597          	auipc	a1,0x4
    302e:	d7658593          	add	a1,a1,-650 # 6da0 <malloc+0x14d0>
    3032:	00004517          	auipc	a0,0x4
    3036:	ce650513          	add	a0,a0,-794 # 6d18 <malloc+0x1448>
    303a:	00002097          	auipc	ra,0x2
    303e:	4d6080e7          	jalr	1238(ra) # 5510 <link>
    3042:	34051b63          	bnez	a0,3398 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3046:	00004517          	auipc	a0,0x4
    304a:	cd250513          	add	a0,a0,-814 # 6d18 <malloc+0x1448>
    304e:	00002097          	auipc	ra,0x2
    3052:	4b2080e7          	jalr	1202(ra) # 5500 <unlink>
    3056:	34051f63          	bnez	a0,33b4 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    305a:	4581                	li	a1,0
    305c:	00004517          	auipc	a0,0x4
    3060:	cbc50513          	add	a0,a0,-836 # 6d18 <malloc+0x1448>
    3064:	00002097          	auipc	ra,0x2
    3068:	48c080e7          	jalr	1164(ra) # 54f0 <open>
    306c:	36055263          	bgez	a0,33d0 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3070:	00004517          	auipc	a0,0x4
    3074:	c0850513          	add	a0,a0,-1016 # 6c78 <malloc+0x13a8>
    3078:	00002097          	auipc	ra,0x2
    307c:	4a8080e7          	jalr	1192(ra) # 5520 <chdir>
    3080:	36051663          	bnez	a0,33ec <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3084:	00004517          	auipc	a0,0x4
    3088:	db450513          	add	a0,a0,-588 # 6e38 <malloc+0x1568>
    308c:	00002097          	auipc	ra,0x2
    3090:	494080e7          	jalr	1172(ra) # 5520 <chdir>
    3094:	36051a63          	bnez	a0,3408 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3098:	00004517          	auipc	a0,0x4
    309c:	dd050513          	add	a0,a0,-560 # 6e68 <malloc+0x1598>
    30a0:	00002097          	auipc	ra,0x2
    30a4:	480080e7          	jalr	1152(ra) # 5520 <chdir>
    30a8:	36051e63          	bnez	a0,3424 <subdir+0x50a>
  if(chdir("./..") != 0){
    30ac:	00004517          	auipc	a0,0x4
    30b0:	dec50513          	add	a0,a0,-532 # 6e98 <malloc+0x15c8>
    30b4:	00002097          	auipc	ra,0x2
    30b8:	46c080e7          	jalr	1132(ra) # 5520 <chdir>
    30bc:	38051263          	bnez	a0,3440 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    30c0:	4581                	li	a1,0
    30c2:	00004517          	auipc	a0,0x4
    30c6:	cde50513          	add	a0,a0,-802 # 6da0 <malloc+0x14d0>
    30ca:	00002097          	auipc	ra,0x2
    30ce:	426080e7          	jalr	1062(ra) # 54f0 <open>
    30d2:	84aa                	mv	s1,a0
  if(fd < 0){
    30d4:	38054463          	bltz	a0,345c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    30d8:	660d                	lui	a2,0x3
    30da:	00009597          	auipc	a1,0x9
    30de:	87658593          	add	a1,a1,-1930 # b950 <buf>
    30e2:	00002097          	auipc	ra,0x2
    30e6:	3e6080e7          	jalr	998(ra) # 54c8 <read>
    30ea:	4789                	li	a5,2
    30ec:	38f51663          	bne	a0,a5,3478 <subdir+0x55e>
  close(fd);
    30f0:	8526                	mv	a0,s1
    30f2:	00002097          	auipc	ra,0x2
    30f6:	3e6080e7          	jalr	998(ra) # 54d8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    30fa:	4581                	li	a1,0
    30fc:	00004517          	auipc	a0,0x4
    3100:	c1c50513          	add	a0,a0,-996 # 6d18 <malloc+0x1448>
    3104:	00002097          	auipc	ra,0x2
    3108:	3ec080e7          	jalr	1004(ra) # 54f0 <open>
    310c:	38055463          	bgez	a0,3494 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3110:	20200593          	li	a1,514
    3114:	00004517          	auipc	a0,0x4
    3118:	e1450513          	add	a0,a0,-492 # 6f28 <malloc+0x1658>
    311c:	00002097          	auipc	ra,0x2
    3120:	3d4080e7          	jalr	980(ra) # 54f0 <open>
    3124:	38055663          	bgez	a0,34b0 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3128:	20200593          	li	a1,514
    312c:	00004517          	auipc	a0,0x4
    3130:	e2c50513          	add	a0,a0,-468 # 6f58 <malloc+0x1688>
    3134:	00002097          	auipc	ra,0x2
    3138:	3bc080e7          	jalr	956(ra) # 54f0 <open>
    313c:	38055863          	bgez	a0,34cc <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3140:	20000593          	li	a1,512
    3144:	00004517          	auipc	a0,0x4
    3148:	b3450513          	add	a0,a0,-1228 # 6c78 <malloc+0x13a8>
    314c:	00002097          	auipc	ra,0x2
    3150:	3a4080e7          	jalr	932(ra) # 54f0 <open>
    3154:	38055a63          	bgez	a0,34e8 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3158:	4589                	li	a1,2
    315a:	00004517          	auipc	a0,0x4
    315e:	b1e50513          	add	a0,a0,-1250 # 6c78 <malloc+0x13a8>
    3162:	00002097          	auipc	ra,0x2
    3166:	38e080e7          	jalr	910(ra) # 54f0 <open>
    316a:	38055d63          	bgez	a0,3504 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    316e:	4585                	li	a1,1
    3170:	00004517          	auipc	a0,0x4
    3174:	b0850513          	add	a0,a0,-1272 # 6c78 <malloc+0x13a8>
    3178:	00002097          	auipc	ra,0x2
    317c:	378080e7          	jalr	888(ra) # 54f0 <open>
    3180:	3a055063          	bgez	a0,3520 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3184:	00004597          	auipc	a1,0x4
    3188:	e6458593          	add	a1,a1,-412 # 6fe8 <malloc+0x1718>
    318c:	00004517          	auipc	a0,0x4
    3190:	d9c50513          	add	a0,a0,-612 # 6f28 <malloc+0x1658>
    3194:	00002097          	auipc	ra,0x2
    3198:	37c080e7          	jalr	892(ra) # 5510 <link>
    319c:	3a050063          	beqz	a0,353c <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    31a0:	00004597          	auipc	a1,0x4
    31a4:	e4858593          	add	a1,a1,-440 # 6fe8 <malloc+0x1718>
    31a8:	00004517          	auipc	a0,0x4
    31ac:	db050513          	add	a0,a0,-592 # 6f58 <malloc+0x1688>
    31b0:	00002097          	auipc	ra,0x2
    31b4:	360080e7          	jalr	864(ra) # 5510 <link>
    31b8:	3a050063          	beqz	a0,3558 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    31bc:	00004597          	auipc	a1,0x4
    31c0:	be458593          	add	a1,a1,-1052 # 6da0 <malloc+0x14d0>
    31c4:	00004517          	auipc	a0,0x4
    31c8:	ad450513          	add	a0,a0,-1324 # 6c98 <malloc+0x13c8>
    31cc:	00002097          	auipc	ra,0x2
    31d0:	344080e7          	jalr	836(ra) # 5510 <link>
    31d4:	3a050063          	beqz	a0,3574 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    31d8:	00004517          	auipc	a0,0x4
    31dc:	d5050513          	add	a0,a0,-688 # 6f28 <malloc+0x1658>
    31e0:	00002097          	auipc	ra,0x2
    31e4:	338080e7          	jalr	824(ra) # 5518 <mkdir>
    31e8:	3a050463          	beqz	a0,3590 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    31ec:	00004517          	auipc	a0,0x4
    31f0:	d6c50513          	add	a0,a0,-660 # 6f58 <malloc+0x1688>
    31f4:	00002097          	auipc	ra,0x2
    31f8:	324080e7          	jalr	804(ra) # 5518 <mkdir>
    31fc:	3a050863          	beqz	a0,35ac <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3200:	00004517          	auipc	a0,0x4
    3204:	ba050513          	add	a0,a0,-1120 # 6da0 <malloc+0x14d0>
    3208:	00002097          	auipc	ra,0x2
    320c:	310080e7          	jalr	784(ra) # 5518 <mkdir>
    3210:	3a050c63          	beqz	a0,35c8 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3214:	00004517          	auipc	a0,0x4
    3218:	d4450513          	add	a0,a0,-700 # 6f58 <malloc+0x1688>
    321c:	00002097          	auipc	ra,0x2
    3220:	2e4080e7          	jalr	740(ra) # 5500 <unlink>
    3224:	3c050063          	beqz	a0,35e4 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3228:	00004517          	auipc	a0,0x4
    322c:	d0050513          	add	a0,a0,-768 # 6f28 <malloc+0x1658>
    3230:	00002097          	auipc	ra,0x2
    3234:	2d0080e7          	jalr	720(ra) # 5500 <unlink>
    3238:	3c050463          	beqz	a0,3600 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    323c:	00004517          	auipc	a0,0x4
    3240:	a5c50513          	add	a0,a0,-1444 # 6c98 <malloc+0x13c8>
    3244:	00002097          	auipc	ra,0x2
    3248:	2dc080e7          	jalr	732(ra) # 5520 <chdir>
    324c:	3c050863          	beqz	a0,361c <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3250:	00004517          	auipc	a0,0x4
    3254:	ee850513          	add	a0,a0,-280 # 7138 <malloc+0x1868>
    3258:	00002097          	auipc	ra,0x2
    325c:	2c8080e7          	jalr	712(ra) # 5520 <chdir>
    3260:	3c050c63          	beqz	a0,3638 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3264:	00004517          	auipc	a0,0x4
    3268:	b3c50513          	add	a0,a0,-1220 # 6da0 <malloc+0x14d0>
    326c:	00002097          	auipc	ra,0x2
    3270:	294080e7          	jalr	660(ra) # 5500 <unlink>
    3274:	3e051063          	bnez	a0,3654 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3278:	00004517          	auipc	a0,0x4
    327c:	a2050513          	add	a0,a0,-1504 # 6c98 <malloc+0x13c8>
    3280:	00002097          	auipc	ra,0x2
    3284:	280080e7          	jalr	640(ra) # 5500 <unlink>
    3288:	3e051463          	bnez	a0,3670 <subdir+0x756>
  if(unlink("dd") == 0){
    328c:	00004517          	auipc	a0,0x4
    3290:	9ec50513          	add	a0,a0,-1556 # 6c78 <malloc+0x13a8>
    3294:	00002097          	auipc	ra,0x2
    3298:	26c080e7          	jalr	620(ra) # 5500 <unlink>
    329c:	3e050863          	beqz	a0,368c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    32a0:	00004517          	auipc	a0,0x4
    32a4:	f0850513          	add	a0,a0,-248 # 71a8 <malloc+0x18d8>
    32a8:	00002097          	auipc	ra,0x2
    32ac:	258080e7          	jalr	600(ra) # 5500 <unlink>
    32b0:	3e054c63          	bltz	a0,36a8 <subdir+0x78e>
  if(unlink("dd") < 0){
    32b4:	00004517          	auipc	a0,0x4
    32b8:	9c450513          	add	a0,a0,-1596 # 6c78 <malloc+0x13a8>
    32bc:	00002097          	auipc	ra,0x2
    32c0:	244080e7          	jalr	580(ra) # 5500 <unlink>
    32c4:	40054063          	bltz	a0,36c4 <subdir+0x7aa>
}
    32c8:	60e2                	ld	ra,24(sp)
    32ca:	6442                	ld	s0,16(sp)
    32cc:	64a2                	ld	s1,8(sp)
    32ce:	6902                	ld	s2,0(sp)
    32d0:	6105                	add	sp,sp,32
    32d2:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    32d4:	85ca                	mv	a1,s2
    32d6:	00004517          	auipc	a0,0x4
    32da:	9aa50513          	add	a0,a0,-1622 # 6c80 <malloc+0x13b0>
    32de:	00002097          	auipc	ra,0x2
    32e2:	53a080e7          	jalr	1338(ra) # 5818 <printf>
    exit(1);
    32e6:	4505                	li	a0,1
    32e8:	00002097          	auipc	ra,0x2
    32ec:	1c8080e7          	jalr	456(ra) # 54b0 <exit>
    printf("%s: create dd/ff failed\n", s);
    32f0:	85ca                	mv	a1,s2
    32f2:	00004517          	auipc	a0,0x4
    32f6:	9ae50513          	add	a0,a0,-1618 # 6ca0 <malloc+0x13d0>
    32fa:	00002097          	auipc	ra,0x2
    32fe:	51e080e7          	jalr	1310(ra) # 5818 <printf>
    exit(1);
    3302:	4505                	li	a0,1
    3304:	00002097          	auipc	ra,0x2
    3308:	1ac080e7          	jalr	428(ra) # 54b0 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    330c:	85ca                	mv	a1,s2
    330e:	00004517          	auipc	a0,0x4
    3312:	9b250513          	add	a0,a0,-1614 # 6cc0 <malloc+0x13f0>
    3316:	00002097          	auipc	ra,0x2
    331a:	502080e7          	jalr	1282(ra) # 5818 <printf>
    exit(1);
    331e:	4505                	li	a0,1
    3320:	00002097          	auipc	ra,0x2
    3324:	190080e7          	jalr	400(ra) # 54b0 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3328:	85ca                	mv	a1,s2
    332a:	00004517          	auipc	a0,0x4
    332e:	9ce50513          	add	a0,a0,-1586 # 6cf8 <malloc+0x1428>
    3332:	00002097          	auipc	ra,0x2
    3336:	4e6080e7          	jalr	1254(ra) # 5818 <printf>
    exit(1);
    333a:	4505                	li	a0,1
    333c:	00002097          	auipc	ra,0x2
    3340:	174080e7          	jalr	372(ra) # 54b0 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3344:	85ca                	mv	a1,s2
    3346:	00004517          	auipc	a0,0x4
    334a:	9e250513          	add	a0,a0,-1566 # 6d28 <malloc+0x1458>
    334e:	00002097          	auipc	ra,0x2
    3352:	4ca080e7          	jalr	1226(ra) # 5818 <printf>
    exit(1);
    3356:	4505                	li	a0,1
    3358:	00002097          	auipc	ra,0x2
    335c:	158080e7          	jalr	344(ra) # 54b0 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3360:	85ca                	mv	a1,s2
    3362:	00004517          	auipc	a0,0x4
    3366:	9fe50513          	add	a0,a0,-1538 # 6d60 <malloc+0x1490>
    336a:	00002097          	auipc	ra,0x2
    336e:	4ae080e7          	jalr	1198(ra) # 5818 <printf>
    exit(1);
    3372:	4505                	li	a0,1
    3374:	00002097          	auipc	ra,0x2
    3378:	13c080e7          	jalr	316(ra) # 54b0 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    337c:	85ca                	mv	a1,s2
    337e:	00004517          	auipc	a0,0x4
    3382:	a0250513          	add	a0,a0,-1534 # 6d80 <malloc+0x14b0>
    3386:	00002097          	auipc	ra,0x2
    338a:	492080e7          	jalr	1170(ra) # 5818 <printf>
    exit(1);
    338e:	4505                	li	a0,1
    3390:	00002097          	auipc	ra,0x2
    3394:	120080e7          	jalr	288(ra) # 54b0 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3398:	85ca                	mv	a1,s2
    339a:	00004517          	auipc	a0,0x4
    339e:	a1650513          	add	a0,a0,-1514 # 6db0 <malloc+0x14e0>
    33a2:	00002097          	auipc	ra,0x2
    33a6:	476080e7          	jalr	1142(ra) # 5818 <printf>
    exit(1);
    33aa:	4505                	li	a0,1
    33ac:	00002097          	auipc	ra,0x2
    33b0:	104080e7          	jalr	260(ra) # 54b0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    33b4:	85ca                	mv	a1,s2
    33b6:	00004517          	auipc	a0,0x4
    33ba:	a2250513          	add	a0,a0,-1502 # 6dd8 <malloc+0x1508>
    33be:	00002097          	auipc	ra,0x2
    33c2:	45a080e7          	jalr	1114(ra) # 5818 <printf>
    exit(1);
    33c6:	4505                	li	a0,1
    33c8:	00002097          	auipc	ra,0x2
    33cc:	0e8080e7          	jalr	232(ra) # 54b0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    33d0:	85ca                	mv	a1,s2
    33d2:	00004517          	auipc	a0,0x4
    33d6:	a2650513          	add	a0,a0,-1498 # 6df8 <malloc+0x1528>
    33da:	00002097          	auipc	ra,0x2
    33de:	43e080e7          	jalr	1086(ra) # 5818 <printf>
    exit(1);
    33e2:	4505                	li	a0,1
    33e4:	00002097          	auipc	ra,0x2
    33e8:	0cc080e7          	jalr	204(ra) # 54b0 <exit>
    printf("%s: chdir dd failed\n", s);
    33ec:	85ca                	mv	a1,s2
    33ee:	00004517          	auipc	a0,0x4
    33f2:	a3250513          	add	a0,a0,-1486 # 6e20 <malloc+0x1550>
    33f6:	00002097          	auipc	ra,0x2
    33fa:	422080e7          	jalr	1058(ra) # 5818 <printf>
    exit(1);
    33fe:	4505                	li	a0,1
    3400:	00002097          	auipc	ra,0x2
    3404:	0b0080e7          	jalr	176(ra) # 54b0 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3408:	85ca                	mv	a1,s2
    340a:	00004517          	auipc	a0,0x4
    340e:	a3e50513          	add	a0,a0,-1474 # 6e48 <malloc+0x1578>
    3412:	00002097          	auipc	ra,0x2
    3416:	406080e7          	jalr	1030(ra) # 5818 <printf>
    exit(1);
    341a:	4505                	li	a0,1
    341c:	00002097          	auipc	ra,0x2
    3420:	094080e7          	jalr	148(ra) # 54b0 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3424:	85ca                	mv	a1,s2
    3426:	00004517          	auipc	a0,0x4
    342a:	a5250513          	add	a0,a0,-1454 # 6e78 <malloc+0x15a8>
    342e:	00002097          	auipc	ra,0x2
    3432:	3ea080e7          	jalr	1002(ra) # 5818 <printf>
    exit(1);
    3436:	4505                	li	a0,1
    3438:	00002097          	auipc	ra,0x2
    343c:	078080e7          	jalr	120(ra) # 54b0 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3440:	85ca                	mv	a1,s2
    3442:	00004517          	auipc	a0,0x4
    3446:	a5e50513          	add	a0,a0,-1442 # 6ea0 <malloc+0x15d0>
    344a:	00002097          	auipc	ra,0x2
    344e:	3ce080e7          	jalr	974(ra) # 5818 <printf>
    exit(1);
    3452:	4505                	li	a0,1
    3454:	00002097          	auipc	ra,0x2
    3458:	05c080e7          	jalr	92(ra) # 54b0 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    345c:	85ca                	mv	a1,s2
    345e:	00004517          	auipc	a0,0x4
    3462:	a5a50513          	add	a0,a0,-1446 # 6eb8 <malloc+0x15e8>
    3466:	00002097          	auipc	ra,0x2
    346a:	3b2080e7          	jalr	946(ra) # 5818 <printf>
    exit(1);
    346e:	4505                	li	a0,1
    3470:	00002097          	auipc	ra,0x2
    3474:	040080e7          	jalr	64(ra) # 54b0 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3478:	85ca                	mv	a1,s2
    347a:	00004517          	auipc	a0,0x4
    347e:	a5e50513          	add	a0,a0,-1442 # 6ed8 <malloc+0x1608>
    3482:	00002097          	auipc	ra,0x2
    3486:	396080e7          	jalr	918(ra) # 5818 <printf>
    exit(1);
    348a:	4505                	li	a0,1
    348c:	00002097          	auipc	ra,0x2
    3490:	024080e7          	jalr	36(ra) # 54b0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3494:	85ca                	mv	a1,s2
    3496:	00004517          	auipc	a0,0x4
    349a:	a6250513          	add	a0,a0,-1438 # 6ef8 <malloc+0x1628>
    349e:	00002097          	auipc	ra,0x2
    34a2:	37a080e7          	jalr	890(ra) # 5818 <printf>
    exit(1);
    34a6:	4505                	li	a0,1
    34a8:	00002097          	auipc	ra,0x2
    34ac:	008080e7          	jalr	8(ra) # 54b0 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    34b0:	85ca                	mv	a1,s2
    34b2:	00004517          	auipc	a0,0x4
    34b6:	a8650513          	add	a0,a0,-1402 # 6f38 <malloc+0x1668>
    34ba:	00002097          	auipc	ra,0x2
    34be:	35e080e7          	jalr	862(ra) # 5818 <printf>
    exit(1);
    34c2:	4505                	li	a0,1
    34c4:	00002097          	auipc	ra,0x2
    34c8:	fec080e7          	jalr	-20(ra) # 54b0 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    34cc:	85ca                	mv	a1,s2
    34ce:	00004517          	auipc	a0,0x4
    34d2:	a9a50513          	add	a0,a0,-1382 # 6f68 <malloc+0x1698>
    34d6:	00002097          	auipc	ra,0x2
    34da:	342080e7          	jalr	834(ra) # 5818 <printf>
    exit(1);
    34de:	4505                	li	a0,1
    34e0:	00002097          	auipc	ra,0x2
    34e4:	fd0080e7          	jalr	-48(ra) # 54b0 <exit>
    printf("%s: create dd succeeded!\n", s);
    34e8:	85ca                	mv	a1,s2
    34ea:	00004517          	auipc	a0,0x4
    34ee:	a9e50513          	add	a0,a0,-1378 # 6f88 <malloc+0x16b8>
    34f2:	00002097          	auipc	ra,0x2
    34f6:	326080e7          	jalr	806(ra) # 5818 <printf>
    exit(1);
    34fa:	4505                	li	a0,1
    34fc:	00002097          	auipc	ra,0x2
    3500:	fb4080e7          	jalr	-76(ra) # 54b0 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3504:	85ca                	mv	a1,s2
    3506:	00004517          	auipc	a0,0x4
    350a:	aa250513          	add	a0,a0,-1374 # 6fa8 <malloc+0x16d8>
    350e:	00002097          	auipc	ra,0x2
    3512:	30a080e7          	jalr	778(ra) # 5818 <printf>
    exit(1);
    3516:	4505                	li	a0,1
    3518:	00002097          	auipc	ra,0x2
    351c:	f98080e7          	jalr	-104(ra) # 54b0 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3520:	85ca                	mv	a1,s2
    3522:	00004517          	auipc	a0,0x4
    3526:	aa650513          	add	a0,a0,-1370 # 6fc8 <malloc+0x16f8>
    352a:	00002097          	auipc	ra,0x2
    352e:	2ee080e7          	jalr	750(ra) # 5818 <printf>
    exit(1);
    3532:	4505                	li	a0,1
    3534:	00002097          	auipc	ra,0x2
    3538:	f7c080e7          	jalr	-132(ra) # 54b0 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    353c:	85ca                	mv	a1,s2
    353e:	00004517          	auipc	a0,0x4
    3542:	aba50513          	add	a0,a0,-1350 # 6ff8 <malloc+0x1728>
    3546:	00002097          	auipc	ra,0x2
    354a:	2d2080e7          	jalr	722(ra) # 5818 <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	f60080e7          	jalr	-160(ra) # 54b0 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3558:	85ca                	mv	a1,s2
    355a:	00004517          	auipc	a0,0x4
    355e:	ac650513          	add	a0,a0,-1338 # 7020 <malloc+0x1750>
    3562:	00002097          	auipc	ra,0x2
    3566:	2b6080e7          	jalr	694(ra) # 5818 <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	f44080e7          	jalr	-188(ra) # 54b0 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3574:	85ca                	mv	a1,s2
    3576:	00004517          	auipc	a0,0x4
    357a:	ad250513          	add	a0,a0,-1326 # 7048 <malloc+0x1778>
    357e:	00002097          	auipc	ra,0x2
    3582:	29a080e7          	jalr	666(ra) # 5818 <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	f28080e7          	jalr	-216(ra) # 54b0 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3590:	85ca                	mv	a1,s2
    3592:	00004517          	auipc	a0,0x4
    3596:	ade50513          	add	a0,a0,-1314 # 7070 <malloc+0x17a0>
    359a:	00002097          	auipc	ra,0x2
    359e:	27e080e7          	jalr	638(ra) # 5818 <printf>
    exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	f0c080e7          	jalr	-244(ra) # 54b0 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    35ac:	85ca                	mv	a1,s2
    35ae:	00004517          	auipc	a0,0x4
    35b2:	ae250513          	add	a0,a0,-1310 # 7090 <malloc+0x17c0>
    35b6:	00002097          	auipc	ra,0x2
    35ba:	262080e7          	jalr	610(ra) # 5818 <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	00002097          	auipc	ra,0x2
    35c4:	ef0080e7          	jalr	-272(ra) # 54b0 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    35c8:	85ca                	mv	a1,s2
    35ca:	00004517          	auipc	a0,0x4
    35ce:	ae650513          	add	a0,a0,-1306 # 70b0 <malloc+0x17e0>
    35d2:	00002097          	auipc	ra,0x2
    35d6:	246080e7          	jalr	582(ra) # 5818 <printf>
    exit(1);
    35da:	4505                	li	a0,1
    35dc:	00002097          	auipc	ra,0x2
    35e0:	ed4080e7          	jalr	-300(ra) # 54b0 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    35e4:	85ca                	mv	a1,s2
    35e6:	00004517          	auipc	a0,0x4
    35ea:	af250513          	add	a0,a0,-1294 # 70d8 <malloc+0x1808>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	22a080e7          	jalr	554(ra) # 5818 <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	00002097          	auipc	ra,0x2
    35fc:	eb8080e7          	jalr	-328(ra) # 54b0 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3600:	85ca                	mv	a1,s2
    3602:	00004517          	auipc	a0,0x4
    3606:	af650513          	add	a0,a0,-1290 # 70f8 <malloc+0x1828>
    360a:	00002097          	auipc	ra,0x2
    360e:	20e080e7          	jalr	526(ra) # 5818 <printf>
    exit(1);
    3612:	4505                	li	a0,1
    3614:	00002097          	auipc	ra,0x2
    3618:	e9c080e7          	jalr	-356(ra) # 54b0 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    361c:	85ca                	mv	a1,s2
    361e:	00004517          	auipc	a0,0x4
    3622:	afa50513          	add	a0,a0,-1286 # 7118 <malloc+0x1848>
    3626:	00002097          	auipc	ra,0x2
    362a:	1f2080e7          	jalr	498(ra) # 5818 <printf>
    exit(1);
    362e:	4505                	li	a0,1
    3630:	00002097          	auipc	ra,0x2
    3634:	e80080e7          	jalr	-384(ra) # 54b0 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3638:	85ca                	mv	a1,s2
    363a:	00004517          	auipc	a0,0x4
    363e:	b0650513          	add	a0,a0,-1274 # 7140 <malloc+0x1870>
    3642:	00002097          	auipc	ra,0x2
    3646:	1d6080e7          	jalr	470(ra) # 5818 <printf>
    exit(1);
    364a:	4505                	li	a0,1
    364c:	00002097          	auipc	ra,0x2
    3650:	e64080e7          	jalr	-412(ra) # 54b0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3654:	85ca                	mv	a1,s2
    3656:	00003517          	auipc	a0,0x3
    365a:	78250513          	add	a0,a0,1922 # 6dd8 <malloc+0x1508>
    365e:	00002097          	auipc	ra,0x2
    3662:	1ba080e7          	jalr	442(ra) # 5818 <printf>
    exit(1);
    3666:	4505                	li	a0,1
    3668:	00002097          	auipc	ra,0x2
    366c:	e48080e7          	jalr	-440(ra) # 54b0 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3670:	85ca                	mv	a1,s2
    3672:	00004517          	auipc	a0,0x4
    3676:	aee50513          	add	a0,a0,-1298 # 7160 <malloc+0x1890>
    367a:	00002097          	auipc	ra,0x2
    367e:	19e080e7          	jalr	414(ra) # 5818 <printf>
    exit(1);
    3682:	4505                	li	a0,1
    3684:	00002097          	auipc	ra,0x2
    3688:	e2c080e7          	jalr	-468(ra) # 54b0 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    368c:	85ca                	mv	a1,s2
    368e:	00004517          	auipc	a0,0x4
    3692:	af250513          	add	a0,a0,-1294 # 7180 <malloc+0x18b0>
    3696:	00002097          	auipc	ra,0x2
    369a:	182080e7          	jalr	386(ra) # 5818 <printf>
    exit(1);
    369e:	4505                	li	a0,1
    36a0:	00002097          	auipc	ra,0x2
    36a4:	e10080e7          	jalr	-496(ra) # 54b0 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    36a8:	85ca                	mv	a1,s2
    36aa:	00004517          	auipc	a0,0x4
    36ae:	b0650513          	add	a0,a0,-1274 # 71b0 <malloc+0x18e0>
    36b2:	00002097          	auipc	ra,0x2
    36b6:	166080e7          	jalr	358(ra) # 5818 <printf>
    exit(1);
    36ba:	4505                	li	a0,1
    36bc:	00002097          	auipc	ra,0x2
    36c0:	df4080e7          	jalr	-524(ra) # 54b0 <exit>
    printf("%s: unlink dd failed\n", s);
    36c4:	85ca                	mv	a1,s2
    36c6:	00004517          	auipc	a0,0x4
    36ca:	b0a50513          	add	a0,a0,-1270 # 71d0 <malloc+0x1900>
    36ce:	00002097          	auipc	ra,0x2
    36d2:	14a080e7          	jalr	330(ra) # 5818 <printf>
    exit(1);
    36d6:	4505                	li	a0,1
    36d8:	00002097          	auipc	ra,0x2
    36dc:	dd8080e7          	jalr	-552(ra) # 54b0 <exit>

00000000000036e0 <rmdot>:
{
    36e0:	1101                	add	sp,sp,-32
    36e2:	ec06                	sd	ra,24(sp)
    36e4:	e822                	sd	s0,16(sp)
    36e6:	e426                	sd	s1,8(sp)
    36e8:	1000                	add	s0,sp,32
    36ea:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    36ec:	00004517          	auipc	a0,0x4
    36f0:	afc50513          	add	a0,a0,-1284 # 71e8 <malloc+0x1918>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	e24080e7          	jalr	-476(ra) # 5518 <mkdir>
    36fc:	e549                	bnez	a0,3786 <rmdot+0xa6>
  if(chdir("dots") != 0){
    36fe:	00004517          	auipc	a0,0x4
    3702:	aea50513          	add	a0,a0,-1302 # 71e8 <malloc+0x1918>
    3706:	00002097          	auipc	ra,0x2
    370a:	e1a080e7          	jalr	-486(ra) # 5520 <chdir>
    370e:	e951                	bnez	a0,37a2 <rmdot+0xc2>
  if(unlink(".") == 0){
    3710:	00003517          	auipc	a0,0x3
    3714:	99850513          	add	a0,a0,-1640 # 60a8 <malloc+0x7d8>
    3718:	00002097          	auipc	ra,0x2
    371c:	de8080e7          	jalr	-536(ra) # 5500 <unlink>
    3720:	cd59                	beqz	a0,37be <rmdot+0xde>
  if(unlink("..") == 0){
    3722:	00003517          	auipc	a0,0x3
    3726:	51e50513          	add	a0,a0,1310 # 6c40 <malloc+0x1370>
    372a:	00002097          	auipc	ra,0x2
    372e:	dd6080e7          	jalr	-554(ra) # 5500 <unlink>
    3732:	c545                	beqz	a0,37da <rmdot+0xfa>
  if(chdir("/") != 0){
    3734:	00003517          	auipc	a0,0x3
    3738:	4b450513          	add	a0,a0,1204 # 6be8 <malloc+0x1318>
    373c:	00002097          	auipc	ra,0x2
    3740:	de4080e7          	jalr	-540(ra) # 5520 <chdir>
    3744:	e94d                	bnez	a0,37f6 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3746:	00004517          	auipc	a0,0x4
    374a:	b0a50513          	add	a0,a0,-1270 # 7250 <malloc+0x1980>
    374e:	00002097          	auipc	ra,0x2
    3752:	db2080e7          	jalr	-590(ra) # 5500 <unlink>
    3756:	cd55                	beqz	a0,3812 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3758:	00004517          	auipc	a0,0x4
    375c:	b2050513          	add	a0,a0,-1248 # 7278 <malloc+0x19a8>
    3760:	00002097          	auipc	ra,0x2
    3764:	da0080e7          	jalr	-608(ra) # 5500 <unlink>
    3768:	c179                	beqz	a0,382e <rmdot+0x14e>
  if(unlink("dots") != 0){
    376a:	00004517          	auipc	a0,0x4
    376e:	a7e50513          	add	a0,a0,-1410 # 71e8 <malloc+0x1918>
    3772:	00002097          	auipc	ra,0x2
    3776:	d8e080e7          	jalr	-626(ra) # 5500 <unlink>
    377a:	e961                	bnez	a0,384a <rmdot+0x16a>
}
    377c:	60e2                	ld	ra,24(sp)
    377e:	6442                	ld	s0,16(sp)
    3780:	64a2                	ld	s1,8(sp)
    3782:	6105                	add	sp,sp,32
    3784:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3786:	85a6                	mv	a1,s1
    3788:	00004517          	auipc	a0,0x4
    378c:	a6850513          	add	a0,a0,-1432 # 71f0 <malloc+0x1920>
    3790:	00002097          	auipc	ra,0x2
    3794:	088080e7          	jalr	136(ra) # 5818 <printf>
    exit(1);
    3798:	4505                	li	a0,1
    379a:	00002097          	auipc	ra,0x2
    379e:	d16080e7          	jalr	-746(ra) # 54b0 <exit>
    printf("%s: chdir dots failed\n", s);
    37a2:	85a6                	mv	a1,s1
    37a4:	00004517          	auipc	a0,0x4
    37a8:	a6450513          	add	a0,a0,-1436 # 7208 <malloc+0x1938>
    37ac:	00002097          	auipc	ra,0x2
    37b0:	06c080e7          	jalr	108(ra) # 5818 <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	00002097          	auipc	ra,0x2
    37ba:	cfa080e7          	jalr	-774(ra) # 54b0 <exit>
    printf("%s: rm . worked!\n", s);
    37be:	85a6                	mv	a1,s1
    37c0:	00004517          	auipc	a0,0x4
    37c4:	a6050513          	add	a0,a0,-1440 # 7220 <malloc+0x1950>
    37c8:	00002097          	auipc	ra,0x2
    37cc:	050080e7          	jalr	80(ra) # 5818 <printf>
    exit(1);
    37d0:	4505                	li	a0,1
    37d2:	00002097          	auipc	ra,0x2
    37d6:	cde080e7          	jalr	-802(ra) # 54b0 <exit>
    printf("%s: rm .. worked!\n", s);
    37da:	85a6                	mv	a1,s1
    37dc:	00004517          	auipc	a0,0x4
    37e0:	a5c50513          	add	a0,a0,-1444 # 7238 <malloc+0x1968>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	034080e7          	jalr	52(ra) # 5818 <printf>
    exit(1);
    37ec:	4505                	li	a0,1
    37ee:	00002097          	auipc	ra,0x2
    37f2:	cc2080e7          	jalr	-830(ra) # 54b0 <exit>
    printf("%s: chdir / failed\n", s);
    37f6:	85a6                	mv	a1,s1
    37f8:	00003517          	auipc	a0,0x3
    37fc:	3f850513          	add	a0,a0,1016 # 6bf0 <malloc+0x1320>
    3800:	00002097          	auipc	ra,0x2
    3804:	018080e7          	jalr	24(ra) # 5818 <printf>
    exit(1);
    3808:	4505                	li	a0,1
    380a:	00002097          	auipc	ra,0x2
    380e:	ca6080e7          	jalr	-858(ra) # 54b0 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3812:	85a6                	mv	a1,s1
    3814:	00004517          	auipc	a0,0x4
    3818:	a4450513          	add	a0,a0,-1468 # 7258 <malloc+0x1988>
    381c:	00002097          	auipc	ra,0x2
    3820:	ffc080e7          	jalr	-4(ra) # 5818 <printf>
    exit(1);
    3824:	4505                	li	a0,1
    3826:	00002097          	auipc	ra,0x2
    382a:	c8a080e7          	jalr	-886(ra) # 54b0 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    382e:	85a6                	mv	a1,s1
    3830:	00004517          	auipc	a0,0x4
    3834:	a5050513          	add	a0,a0,-1456 # 7280 <malloc+0x19b0>
    3838:	00002097          	auipc	ra,0x2
    383c:	fe0080e7          	jalr	-32(ra) # 5818 <printf>
    exit(1);
    3840:	4505                	li	a0,1
    3842:	00002097          	auipc	ra,0x2
    3846:	c6e080e7          	jalr	-914(ra) # 54b0 <exit>
    printf("%s: unlink dots failed!\n", s);
    384a:	85a6                	mv	a1,s1
    384c:	00004517          	auipc	a0,0x4
    3850:	a5450513          	add	a0,a0,-1452 # 72a0 <malloc+0x19d0>
    3854:	00002097          	auipc	ra,0x2
    3858:	fc4080e7          	jalr	-60(ra) # 5818 <printf>
    exit(1);
    385c:	4505                	li	a0,1
    385e:	00002097          	auipc	ra,0x2
    3862:	c52080e7          	jalr	-942(ra) # 54b0 <exit>

0000000000003866 <dirfile>:
{
    3866:	1101                	add	sp,sp,-32
    3868:	ec06                	sd	ra,24(sp)
    386a:	e822                	sd	s0,16(sp)
    386c:	e426                	sd	s1,8(sp)
    386e:	e04a                	sd	s2,0(sp)
    3870:	1000                	add	s0,sp,32
    3872:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3874:	20000593          	li	a1,512
    3878:	00004517          	auipc	a0,0x4
    387c:	a4850513          	add	a0,a0,-1464 # 72c0 <malloc+0x19f0>
    3880:	00002097          	auipc	ra,0x2
    3884:	c70080e7          	jalr	-912(ra) # 54f0 <open>
  if(fd < 0){
    3888:	0e054d63          	bltz	a0,3982 <dirfile+0x11c>
  close(fd);
    388c:	00002097          	auipc	ra,0x2
    3890:	c4c080e7          	jalr	-948(ra) # 54d8 <close>
  if(chdir("dirfile") == 0){
    3894:	00004517          	auipc	a0,0x4
    3898:	a2c50513          	add	a0,a0,-1492 # 72c0 <malloc+0x19f0>
    389c:	00002097          	auipc	ra,0x2
    38a0:	c84080e7          	jalr	-892(ra) # 5520 <chdir>
    38a4:	cd6d                	beqz	a0,399e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    38a6:	4581                	li	a1,0
    38a8:	00004517          	auipc	a0,0x4
    38ac:	a6050513          	add	a0,a0,-1440 # 7308 <malloc+0x1a38>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	c40080e7          	jalr	-960(ra) # 54f0 <open>
  if(fd >= 0){
    38b8:	10055163          	bgez	a0,39ba <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    38bc:	20000593          	li	a1,512
    38c0:	00004517          	auipc	a0,0x4
    38c4:	a4850513          	add	a0,a0,-1464 # 7308 <malloc+0x1a38>
    38c8:	00002097          	auipc	ra,0x2
    38cc:	c28080e7          	jalr	-984(ra) # 54f0 <open>
  if(fd >= 0){
    38d0:	10055363          	bgez	a0,39d6 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    38d4:	00004517          	auipc	a0,0x4
    38d8:	a3450513          	add	a0,a0,-1484 # 7308 <malloc+0x1a38>
    38dc:	00002097          	auipc	ra,0x2
    38e0:	c3c080e7          	jalr	-964(ra) # 5518 <mkdir>
    38e4:	10050763          	beqz	a0,39f2 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    38e8:	00004517          	auipc	a0,0x4
    38ec:	a2050513          	add	a0,a0,-1504 # 7308 <malloc+0x1a38>
    38f0:	00002097          	auipc	ra,0x2
    38f4:	c10080e7          	jalr	-1008(ra) # 5500 <unlink>
    38f8:	10050b63          	beqz	a0,3a0e <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    38fc:	00004597          	auipc	a1,0x4
    3900:	a0c58593          	add	a1,a1,-1524 # 7308 <malloc+0x1a38>
    3904:	00002517          	auipc	a0,0x2
    3908:	29450513          	add	a0,a0,660 # 5b98 <malloc+0x2c8>
    390c:	00002097          	auipc	ra,0x2
    3910:	c04080e7          	jalr	-1020(ra) # 5510 <link>
    3914:	10050b63          	beqz	a0,3a2a <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3918:	00004517          	auipc	a0,0x4
    391c:	9a850513          	add	a0,a0,-1624 # 72c0 <malloc+0x19f0>
    3920:	00002097          	auipc	ra,0x2
    3924:	be0080e7          	jalr	-1056(ra) # 5500 <unlink>
    3928:	10051f63          	bnez	a0,3a46 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    392c:	4589                	li	a1,2
    392e:	00002517          	auipc	a0,0x2
    3932:	77a50513          	add	a0,a0,1914 # 60a8 <malloc+0x7d8>
    3936:	00002097          	auipc	ra,0x2
    393a:	bba080e7          	jalr	-1094(ra) # 54f0 <open>
  if(fd >= 0){
    393e:	12055263          	bgez	a0,3a62 <dirfile+0x1fc>
  fd = open(".", 0);
    3942:	4581                	li	a1,0
    3944:	00002517          	auipc	a0,0x2
    3948:	76450513          	add	a0,a0,1892 # 60a8 <malloc+0x7d8>
    394c:	00002097          	auipc	ra,0x2
    3950:	ba4080e7          	jalr	-1116(ra) # 54f0 <open>
    3954:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3956:	4605                	li	a2,1
    3958:	00002597          	auipc	a1,0x2
    395c:	10858593          	add	a1,a1,264 # 5a60 <malloc+0x190>
    3960:	00002097          	auipc	ra,0x2
    3964:	b70080e7          	jalr	-1168(ra) # 54d0 <write>
    3968:	10a04b63          	bgtz	a0,3a7e <dirfile+0x218>
  close(fd);
    396c:	8526                	mv	a0,s1
    396e:	00002097          	auipc	ra,0x2
    3972:	b6a080e7          	jalr	-1174(ra) # 54d8 <close>
}
    3976:	60e2                	ld	ra,24(sp)
    3978:	6442                	ld	s0,16(sp)
    397a:	64a2                	ld	s1,8(sp)
    397c:	6902                	ld	s2,0(sp)
    397e:	6105                	add	sp,sp,32
    3980:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3982:	85ca                	mv	a1,s2
    3984:	00004517          	auipc	a0,0x4
    3988:	94450513          	add	a0,a0,-1724 # 72c8 <malloc+0x19f8>
    398c:	00002097          	auipc	ra,0x2
    3990:	e8c080e7          	jalr	-372(ra) # 5818 <printf>
    exit(1);
    3994:	4505                	li	a0,1
    3996:	00002097          	auipc	ra,0x2
    399a:	b1a080e7          	jalr	-1254(ra) # 54b0 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    399e:	85ca                	mv	a1,s2
    39a0:	00004517          	auipc	a0,0x4
    39a4:	94850513          	add	a0,a0,-1720 # 72e8 <malloc+0x1a18>
    39a8:	00002097          	auipc	ra,0x2
    39ac:	e70080e7          	jalr	-400(ra) # 5818 <printf>
    exit(1);
    39b0:	4505                	li	a0,1
    39b2:	00002097          	auipc	ra,0x2
    39b6:	afe080e7          	jalr	-1282(ra) # 54b0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    39ba:	85ca                	mv	a1,s2
    39bc:	00004517          	auipc	a0,0x4
    39c0:	95c50513          	add	a0,a0,-1700 # 7318 <malloc+0x1a48>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	e54080e7          	jalr	-428(ra) # 5818 <printf>
    exit(1);
    39cc:	4505                	li	a0,1
    39ce:	00002097          	auipc	ra,0x2
    39d2:	ae2080e7          	jalr	-1310(ra) # 54b0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    39d6:	85ca                	mv	a1,s2
    39d8:	00004517          	auipc	a0,0x4
    39dc:	94050513          	add	a0,a0,-1728 # 7318 <malloc+0x1a48>
    39e0:	00002097          	auipc	ra,0x2
    39e4:	e38080e7          	jalr	-456(ra) # 5818 <printf>
    exit(1);
    39e8:	4505                	li	a0,1
    39ea:	00002097          	auipc	ra,0x2
    39ee:	ac6080e7          	jalr	-1338(ra) # 54b0 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    39f2:	85ca                	mv	a1,s2
    39f4:	00004517          	auipc	a0,0x4
    39f8:	94c50513          	add	a0,a0,-1716 # 7340 <malloc+0x1a70>
    39fc:	00002097          	auipc	ra,0x2
    3a00:	e1c080e7          	jalr	-484(ra) # 5818 <printf>
    exit(1);
    3a04:	4505                	li	a0,1
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	aaa080e7          	jalr	-1366(ra) # 54b0 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3a0e:	85ca                	mv	a1,s2
    3a10:	00004517          	auipc	a0,0x4
    3a14:	95850513          	add	a0,a0,-1704 # 7368 <malloc+0x1a98>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	e00080e7          	jalr	-512(ra) # 5818 <printf>
    exit(1);
    3a20:	4505                	li	a0,1
    3a22:	00002097          	auipc	ra,0x2
    3a26:	a8e080e7          	jalr	-1394(ra) # 54b0 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3a2a:	85ca                	mv	a1,s2
    3a2c:	00004517          	auipc	a0,0x4
    3a30:	96450513          	add	a0,a0,-1692 # 7390 <malloc+0x1ac0>
    3a34:	00002097          	auipc	ra,0x2
    3a38:	de4080e7          	jalr	-540(ra) # 5818 <printf>
    exit(1);
    3a3c:	4505                	li	a0,1
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	a72080e7          	jalr	-1422(ra) # 54b0 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3a46:	85ca                	mv	a1,s2
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	97050513          	add	a0,a0,-1680 # 73b8 <malloc+0x1ae8>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	dc8080e7          	jalr	-568(ra) # 5818 <printf>
    exit(1);
    3a58:	4505                	li	a0,1
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	a56080e7          	jalr	-1450(ra) # 54b0 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3a62:	85ca                	mv	a1,s2
    3a64:	00004517          	auipc	a0,0x4
    3a68:	97450513          	add	a0,a0,-1676 # 73d8 <malloc+0x1b08>
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	dac080e7          	jalr	-596(ra) # 5818 <printf>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	a3a080e7          	jalr	-1478(ra) # 54b0 <exit>
    printf("%s: write . succeeded!\n", s);
    3a7e:	85ca                	mv	a1,s2
    3a80:	00004517          	auipc	a0,0x4
    3a84:	98050513          	add	a0,a0,-1664 # 7400 <malloc+0x1b30>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	d90080e7          	jalr	-624(ra) # 5818 <printf>
    exit(1);
    3a90:	4505                	li	a0,1
    3a92:	00002097          	auipc	ra,0x2
    3a96:	a1e080e7          	jalr	-1506(ra) # 54b0 <exit>

0000000000003a9a <iref>:
{
    3a9a:	7139                	add	sp,sp,-64
    3a9c:	fc06                	sd	ra,56(sp)
    3a9e:	f822                	sd	s0,48(sp)
    3aa0:	f426                	sd	s1,40(sp)
    3aa2:	f04a                	sd	s2,32(sp)
    3aa4:	ec4e                	sd	s3,24(sp)
    3aa6:	e852                	sd	s4,16(sp)
    3aa8:	e456                	sd	s5,8(sp)
    3aaa:	e05a                	sd	s6,0(sp)
    3aac:	0080                	add	s0,sp,64
    3aae:	8b2a                	mv	s6,a0
    3ab0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3ab4:	00004a17          	auipc	s4,0x4
    3ab8:	964a0a13          	add	s4,s4,-1692 # 7418 <malloc+0x1b48>
    mkdir("");
    3abc:	00003497          	auipc	s1,0x3
    3ac0:	46448493          	add	s1,s1,1124 # 6f20 <malloc+0x1650>
    link("README", "");
    3ac4:	00002a97          	auipc	s5,0x2
    3ac8:	0d4a8a93          	add	s5,s5,212 # 5b98 <malloc+0x2c8>
    fd = open("xx", O_CREATE);
    3acc:	00004997          	auipc	s3,0x4
    3ad0:	84498993          	add	s3,s3,-1980 # 7310 <malloc+0x1a40>
    3ad4:	a891                	j	3b28 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3ad6:	85da                	mv	a1,s6
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	94850513          	add	a0,a0,-1720 # 7420 <malloc+0x1b50>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	d38080e7          	jalr	-712(ra) # 5818 <printf>
      exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	9c6080e7          	jalr	-1594(ra) # 54b0 <exit>
      printf("%s: chdir irefd failed\n", s);
    3af2:	85da                	mv	a1,s6
    3af4:	00004517          	auipc	a0,0x4
    3af8:	94450513          	add	a0,a0,-1724 # 7438 <malloc+0x1b68>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	d1c080e7          	jalr	-740(ra) # 5818 <printf>
      exit(1);
    3b04:	4505                	li	a0,1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	9aa080e7          	jalr	-1622(ra) # 54b0 <exit>
      close(fd);
    3b0e:	00002097          	auipc	ra,0x2
    3b12:	9ca080e7          	jalr	-1590(ra) # 54d8 <close>
    3b16:	a889                	j	3b68 <iref+0xce>
    unlink("xx");
    3b18:	854e                	mv	a0,s3
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	9e6080e7          	jalr	-1562(ra) # 5500 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3b22:	397d                	addw	s2,s2,-1
    3b24:	06090063          	beqz	s2,3b84 <iref+0xea>
    if(mkdir("irefd") != 0){
    3b28:	8552                	mv	a0,s4
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	9ee080e7          	jalr	-1554(ra) # 5518 <mkdir>
    3b32:	f155                	bnez	a0,3ad6 <iref+0x3c>
    if(chdir("irefd") != 0){
    3b34:	8552                	mv	a0,s4
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	9ea080e7          	jalr	-1558(ra) # 5520 <chdir>
    3b3e:	f955                	bnez	a0,3af2 <iref+0x58>
    mkdir("");
    3b40:	8526                	mv	a0,s1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	9d6080e7          	jalr	-1578(ra) # 5518 <mkdir>
    link("README", "");
    3b4a:	85a6                	mv	a1,s1
    3b4c:	8556                	mv	a0,s5
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	9c2080e7          	jalr	-1598(ra) # 5510 <link>
    fd = open("", O_CREATE);
    3b56:	20000593          	li	a1,512
    3b5a:	8526                	mv	a0,s1
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	994080e7          	jalr	-1644(ra) # 54f0 <open>
    if(fd >= 0)
    3b64:	fa0555e3          	bgez	a0,3b0e <iref+0x74>
    fd = open("xx", O_CREATE);
    3b68:	20000593          	li	a1,512
    3b6c:	854e                	mv	a0,s3
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	982080e7          	jalr	-1662(ra) # 54f0 <open>
    if(fd >= 0)
    3b76:	fa0541e3          	bltz	a0,3b18 <iref+0x7e>
      close(fd);
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	95e080e7          	jalr	-1698(ra) # 54d8 <close>
    3b82:	bf59                	j	3b18 <iref+0x7e>
    3b84:	03300493          	li	s1,51
    chdir("..");
    3b88:	00003997          	auipc	s3,0x3
    3b8c:	0b898993          	add	s3,s3,184 # 6c40 <malloc+0x1370>
    unlink("irefd");
    3b90:	00004917          	auipc	s2,0x4
    3b94:	88890913          	add	s2,s2,-1912 # 7418 <malloc+0x1b48>
    chdir("..");
    3b98:	854e                	mv	a0,s3
    3b9a:	00002097          	auipc	ra,0x2
    3b9e:	986080e7          	jalr	-1658(ra) # 5520 <chdir>
    unlink("irefd");
    3ba2:	854a                	mv	a0,s2
    3ba4:	00002097          	auipc	ra,0x2
    3ba8:	95c080e7          	jalr	-1700(ra) # 5500 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3bac:	34fd                	addw	s1,s1,-1
    3bae:	f4ed                	bnez	s1,3b98 <iref+0xfe>
  chdir("/");
    3bb0:	00003517          	auipc	a0,0x3
    3bb4:	03850513          	add	a0,a0,56 # 6be8 <malloc+0x1318>
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	968080e7          	jalr	-1688(ra) # 5520 <chdir>
}
    3bc0:	70e2                	ld	ra,56(sp)
    3bc2:	7442                	ld	s0,48(sp)
    3bc4:	74a2                	ld	s1,40(sp)
    3bc6:	7902                	ld	s2,32(sp)
    3bc8:	69e2                	ld	s3,24(sp)
    3bca:	6a42                	ld	s4,16(sp)
    3bcc:	6aa2                	ld	s5,8(sp)
    3bce:	6b02                	ld	s6,0(sp)
    3bd0:	6121                	add	sp,sp,64
    3bd2:	8082                	ret

0000000000003bd4 <openiputtest>:
{
    3bd4:	7179                	add	sp,sp,-48
    3bd6:	f406                	sd	ra,40(sp)
    3bd8:	f022                	sd	s0,32(sp)
    3bda:	ec26                	sd	s1,24(sp)
    3bdc:	1800                	add	s0,sp,48
    3bde:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3be0:	00004517          	auipc	a0,0x4
    3be4:	87050513          	add	a0,a0,-1936 # 7450 <malloc+0x1b80>
    3be8:	00002097          	auipc	ra,0x2
    3bec:	930080e7          	jalr	-1744(ra) # 5518 <mkdir>
    3bf0:	04054263          	bltz	a0,3c34 <openiputtest+0x60>
  pid = fork();
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	8b4080e7          	jalr	-1868(ra) # 54a8 <fork>
  if(pid < 0){
    3bfc:	04054a63          	bltz	a0,3c50 <openiputtest+0x7c>
  if(pid == 0){
    3c00:	e93d                	bnez	a0,3c76 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3c02:	4589                	li	a1,2
    3c04:	00004517          	auipc	a0,0x4
    3c08:	84c50513          	add	a0,a0,-1972 # 7450 <malloc+0x1b80>
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	8e4080e7          	jalr	-1820(ra) # 54f0 <open>
    if(fd >= 0){
    3c14:	04054c63          	bltz	a0,3c6c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3c18:	85a6                	mv	a1,s1
    3c1a:	00004517          	auipc	a0,0x4
    3c1e:	85650513          	add	a0,a0,-1962 # 7470 <malloc+0x1ba0>
    3c22:	00002097          	auipc	ra,0x2
    3c26:	bf6080e7          	jalr	-1034(ra) # 5818 <printf>
      exit(1);
    3c2a:	4505                	li	a0,1
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	884080e7          	jalr	-1916(ra) # 54b0 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3c34:	85a6                	mv	a1,s1
    3c36:	00004517          	auipc	a0,0x4
    3c3a:	82250513          	add	a0,a0,-2014 # 7458 <malloc+0x1b88>
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	bda080e7          	jalr	-1062(ra) # 5818 <printf>
    exit(1);
    3c46:	4505                	li	a0,1
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	868080e7          	jalr	-1944(ra) # 54b0 <exit>
    printf("%s: fork failed\n", s);
    3c50:	85a6                	mv	a1,s1
    3c52:	00002517          	auipc	a0,0x2
    3c56:	5f650513          	add	a0,a0,1526 # 6248 <malloc+0x978>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	bbe080e7          	jalr	-1090(ra) # 5818 <printf>
    exit(1);
    3c62:	4505                	li	a0,1
    3c64:	00002097          	auipc	ra,0x2
    3c68:	84c080e7          	jalr	-1972(ra) # 54b0 <exit>
    exit(0);
    3c6c:	4501                	li	a0,0
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	842080e7          	jalr	-1982(ra) # 54b0 <exit>
  sleep(1);
    3c76:	4505                	li	a0,1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	8c8080e7          	jalr	-1848(ra) # 5540 <sleep>
  if(unlink("oidir") != 0){
    3c80:	00003517          	auipc	a0,0x3
    3c84:	7d050513          	add	a0,a0,2000 # 7450 <malloc+0x1b80>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	878080e7          	jalr	-1928(ra) # 5500 <unlink>
    3c90:	cd19                	beqz	a0,3cae <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3c92:	85a6                	mv	a1,s1
    3c94:	00002517          	auipc	a0,0x2
    3c98:	7a450513          	add	a0,a0,1956 # 6438 <malloc+0xb68>
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	b7c080e7          	jalr	-1156(ra) # 5818 <printf>
    exit(1);
    3ca4:	4505                	li	a0,1
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	80a080e7          	jalr	-2038(ra) # 54b0 <exit>
  wait(&xstatus);
    3cae:	fdc40513          	add	a0,s0,-36
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	806080e7          	jalr	-2042(ra) # 54b8 <wait>
  exit(xstatus);
    3cba:	fdc42503          	lw	a0,-36(s0)
    3cbe:	00001097          	auipc	ra,0x1
    3cc2:	7f2080e7          	jalr	2034(ra) # 54b0 <exit>

0000000000003cc6 <forkforkfork>:
{
    3cc6:	1101                	add	sp,sp,-32
    3cc8:	ec06                	sd	ra,24(sp)
    3cca:	e822                	sd	s0,16(sp)
    3ccc:	e426                	sd	s1,8(sp)
    3cce:	1000                	add	s0,sp,32
    3cd0:	84aa                	mv	s1,a0
  unlink("stopforking");
    3cd2:	00003517          	auipc	a0,0x3
    3cd6:	7c650513          	add	a0,a0,1990 # 7498 <malloc+0x1bc8>
    3cda:	00002097          	auipc	ra,0x2
    3cde:	826080e7          	jalr	-2010(ra) # 5500 <unlink>
  int pid = fork();
    3ce2:	00001097          	auipc	ra,0x1
    3ce6:	7c6080e7          	jalr	1990(ra) # 54a8 <fork>
  if(pid < 0){
    3cea:	04054563          	bltz	a0,3d34 <forkforkfork+0x6e>
  if(pid == 0){
    3cee:	c12d                	beqz	a0,3d50 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3cf0:	4551                	li	a0,20
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	84e080e7          	jalr	-1970(ra) # 5540 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3cfa:	20200593          	li	a1,514
    3cfe:	00003517          	auipc	a0,0x3
    3d02:	79a50513          	add	a0,a0,1946 # 7498 <malloc+0x1bc8>
    3d06:	00001097          	auipc	ra,0x1
    3d0a:	7ea080e7          	jalr	2026(ra) # 54f0 <open>
    3d0e:	00001097          	auipc	ra,0x1
    3d12:	7ca080e7          	jalr	1994(ra) # 54d8 <close>
  wait(0);
    3d16:	4501                	li	a0,0
    3d18:	00001097          	auipc	ra,0x1
    3d1c:	7a0080e7          	jalr	1952(ra) # 54b8 <wait>
  sleep(10); // one second
    3d20:	4529                	li	a0,10
    3d22:	00002097          	auipc	ra,0x2
    3d26:	81e080e7          	jalr	-2018(ra) # 5540 <sleep>
}
    3d2a:	60e2                	ld	ra,24(sp)
    3d2c:	6442                	ld	s0,16(sp)
    3d2e:	64a2                	ld	s1,8(sp)
    3d30:	6105                	add	sp,sp,32
    3d32:	8082                	ret
    printf("%s: fork failed", s);
    3d34:	85a6                	mv	a1,s1
    3d36:	00002517          	auipc	a0,0x2
    3d3a:	6d250513          	add	a0,a0,1746 # 6408 <malloc+0xb38>
    3d3e:	00002097          	auipc	ra,0x2
    3d42:	ada080e7          	jalr	-1318(ra) # 5818 <printf>
    exit(1);
    3d46:	4505                	li	a0,1
    3d48:	00001097          	auipc	ra,0x1
    3d4c:	768080e7          	jalr	1896(ra) # 54b0 <exit>
      int fd = open("stopforking", 0);
    3d50:	00003497          	auipc	s1,0x3
    3d54:	74848493          	add	s1,s1,1864 # 7498 <malloc+0x1bc8>
    3d58:	4581                	li	a1,0
    3d5a:	8526                	mv	a0,s1
    3d5c:	00001097          	auipc	ra,0x1
    3d60:	794080e7          	jalr	1940(ra) # 54f0 <open>
      if(fd >= 0){
    3d64:	02055763          	bgez	a0,3d92 <forkforkfork+0xcc>
      if(fork() < 0){
    3d68:	00001097          	auipc	ra,0x1
    3d6c:	740080e7          	jalr	1856(ra) # 54a8 <fork>
    3d70:	fe0554e3          	bgez	a0,3d58 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3d74:	20200593          	li	a1,514
    3d78:	00003517          	auipc	a0,0x3
    3d7c:	72050513          	add	a0,a0,1824 # 7498 <malloc+0x1bc8>
    3d80:	00001097          	auipc	ra,0x1
    3d84:	770080e7          	jalr	1904(ra) # 54f0 <open>
    3d88:	00001097          	auipc	ra,0x1
    3d8c:	750080e7          	jalr	1872(ra) # 54d8 <close>
    3d90:	b7e1                	j	3d58 <forkforkfork+0x92>
        exit(0);
    3d92:	4501                	li	a0,0
    3d94:	00001097          	auipc	ra,0x1
    3d98:	71c080e7          	jalr	1820(ra) # 54b0 <exit>

0000000000003d9c <preempt>:
{
    3d9c:	7139                	add	sp,sp,-64
    3d9e:	fc06                	sd	ra,56(sp)
    3da0:	f822                	sd	s0,48(sp)
    3da2:	f426                	sd	s1,40(sp)
    3da4:	f04a                	sd	s2,32(sp)
    3da6:	ec4e                	sd	s3,24(sp)
    3da8:	e852                	sd	s4,16(sp)
    3daa:	0080                	add	s0,sp,64
    3dac:	892a                	mv	s2,a0
  pid1 = fork();
    3dae:	00001097          	auipc	ra,0x1
    3db2:	6fa080e7          	jalr	1786(ra) # 54a8 <fork>
  if(pid1 < 0) {
    3db6:	00054563          	bltz	a0,3dc0 <preempt+0x24>
    3dba:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3dbc:	e105                	bnez	a0,3ddc <preempt+0x40>
    for(;;)
    3dbe:	a001                	j	3dbe <preempt+0x22>
    printf("%s: fork failed", s);
    3dc0:	85ca                	mv	a1,s2
    3dc2:	00002517          	auipc	a0,0x2
    3dc6:	64650513          	add	a0,a0,1606 # 6408 <malloc+0xb38>
    3dca:	00002097          	auipc	ra,0x2
    3dce:	a4e080e7          	jalr	-1458(ra) # 5818 <printf>
    exit(1);
    3dd2:	4505                	li	a0,1
    3dd4:	00001097          	auipc	ra,0x1
    3dd8:	6dc080e7          	jalr	1756(ra) # 54b0 <exit>
  pid2 = fork();
    3ddc:	00001097          	auipc	ra,0x1
    3de0:	6cc080e7          	jalr	1740(ra) # 54a8 <fork>
    3de4:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3de6:	00054463          	bltz	a0,3dee <preempt+0x52>
  if(pid2 == 0)
    3dea:	e105                	bnez	a0,3e0a <preempt+0x6e>
    for(;;)
    3dec:	a001                	j	3dec <preempt+0x50>
    printf("%s: fork failed\n", s);
    3dee:	85ca                	mv	a1,s2
    3df0:	00002517          	auipc	a0,0x2
    3df4:	45850513          	add	a0,a0,1112 # 6248 <malloc+0x978>
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	a20080e7          	jalr	-1504(ra) # 5818 <printf>
    exit(1);
    3e00:	4505                	li	a0,1
    3e02:	00001097          	auipc	ra,0x1
    3e06:	6ae080e7          	jalr	1710(ra) # 54b0 <exit>
  pipe(pfds);
    3e0a:	fc840513          	add	a0,s0,-56
    3e0e:	00001097          	auipc	ra,0x1
    3e12:	6b2080e7          	jalr	1714(ra) # 54c0 <pipe>
  pid3 = fork();
    3e16:	00001097          	auipc	ra,0x1
    3e1a:	692080e7          	jalr	1682(ra) # 54a8 <fork>
    3e1e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3e20:	02054e63          	bltz	a0,3e5c <preempt+0xc0>
  if(pid3 == 0){
    3e24:	e525                	bnez	a0,3e8c <preempt+0xf0>
    close(pfds[0]);
    3e26:	fc842503          	lw	a0,-56(s0)
    3e2a:	00001097          	auipc	ra,0x1
    3e2e:	6ae080e7          	jalr	1710(ra) # 54d8 <close>
    if(write(pfds[1], "x", 1) != 1)
    3e32:	4605                	li	a2,1
    3e34:	00002597          	auipc	a1,0x2
    3e38:	c2c58593          	add	a1,a1,-980 # 5a60 <malloc+0x190>
    3e3c:	fcc42503          	lw	a0,-52(s0)
    3e40:	00001097          	auipc	ra,0x1
    3e44:	690080e7          	jalr	1680(ra) # 54d0 <write>
    3e48:	4785                	li	a5,1
    3e4a:	02f51763          	bne	a0,a5,3e78 <preempt+0xdc>
    close(pfds[1]);
    3e4e:	fcc42503          	lw	a0,-52(s0)
    3e52:	00001097          	auipc	ra,0x1
    3e56:	686080e7          	jalr	1670(ra) # 54d8 <close>
    for(;;)
    3e5a:	a001                	j	3e5a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3e5c:	85ca                	mv	a1,s2
    3e5e:	00002517          	auipc	a0,0x2
    3e62:	3ea50513          	add	a0,a0,1002 # 6248 <malloc+0x978>
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	9b2080e7          	jalr	-1614(ra) # 5818 <printf>
     exit(1);
    3e6e:	4505                	li	a0,1
    3e70:	00001097          	auipc	ra,0x1
    3e74:	640080e7          	jalr	1600(ra) # 54b0 <exit>
      printf("%s: preempt write error", s);
    3e78:	85ca                	mv	a1,s2
    3e7a:	00003517          	auipc	a0,0x3
    3e7e:	62e50513          	add	a0,a0,1582 # 74a8 <malloc+0x1bd8>
    3e82:	00002097          	auipc	ra,0x2
    3e86:	996080e7          	jalr	-1642(ra) # 5818 <printf>
    3e8a:	b7d1                	j	3e4e <preempt+0xb2>
  close(pfds[1]);
    3e8c:	fcc42503          	lw	a0,-52(s0)
    3e90:	00001097          	auipc	ra,0x1
    3e94:	648080e7          	jalr	1608(ra) # 54d8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3e98:	660d                	lui	a2,0x3
    3e9a:	00008597          	auipc	a1,0x8
    3e9e:	ab658593          	add	a1,a1,-1354 # b950 <buf>
    3ea2:	fc842503          	lw	a0,-56(s0)
    3ea6:	00001097          	auipc	ra,0x1
    3eaa:	622080e7          	jalr	1570(ra) # 54c8 <read>
    3eae:	4785                	li	a5,1
    3eb0:	02f50363          	beq	a0,a5,3ed6 <preempt+0x13a>
    printf("%s: preempt read error", s);
    3eb4:	85ca                	mv	a1,s2
    3eb6:	00003517          	auipc	a0,0x3
    3eba:	60a50513          	add	a0,a0,1546 # 74c0 <malloc+0x1bf0>
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	95a080e7          	jalr	-1702(ra) # 5818 <printf>
}
    3ec6:	70e2                	ld	ra,56(sp)
    3ec8:	7442                	ld	s0,48(sp)
    3eca:	74a2                	ld	s1,40(sp)
    3ecc:	7902                	ld	s2,32(sp)
    3ece:	69e2                	ld	s3,24(sp)
    3ed0:	6a42                	ld	s4,16(sp)
    3ed2:	6121                	add	sp,sp,64
    3ed4:	8082                	ret
  close(pfds[0]);
    3ed6:	fc842503          	lw	a0,-56(s0)
    3eda:	00001097          	auipc	ra,0x1
    3ede:	5fe080e7          	jalr	1534(ra) # 54d8 <close>
  printf("kill... ");
    3ee2:	00003517          	auipc	a0,0x3
    3ee6:	5f650513          	add	a0,a0,1526 # 74d8 <malloc+0x1c08>
    3eea:	00002097          	auipc	ra,0x2
    3eee:	92e080e7          	jalr	-1746(ra) # 5818 <printf>
  kill(pid1);
    3ef2:	8526                	mv	a0,s1
    3ef4:	00001097          	auipc	ra,0x1
    3ef8:	5ec080e7          	jalr	1516(ra) # 54e0 <kill>
  kill(pid2);
    3efc:	854e                	mv	a0,s3
    3efe:	00001097          	auipc	ra,0x1
    3f02:	5e2080e7          	jalr	1506(ra) # 54e0 <kill>
  kill(pid3);
    3f06:	8552                	mv	a0,s4
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	5d8080e7          	jalr	1496(ra) # 54e0 <kill>
  printf("wait... ");
    3f10:	00003517          	auipc	a0,0x3
    3f14:	5d850513          	add	a0,a0,1496 # 74e8 <malloc+0x1c18>
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	900080e7          	jalr	-1792(ra) # 5818 <printf>
  wait(0);
    3f20:	4501                	li	a0,0
    3f22:	00001097          	auipc	ra,0x1
    3f26:	596080e7          	jalr	1430(ra) # 54b8 <wait>
  wait(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	58c080e7          	jalr	1420(ra) # 54b8 <wait>
  wait(0);
    3f34:	4501                	li	a0,0
    3f36:	00001097          	auipc	ra,0x1
    3f3a:	582080e7          	jalr	1410(ra) # 54b8 <wait>
    3f3e:	b761                	j	3ec6 <preempt+0x12a>

0000000000003f40 <sbrkfail>:
{
    3f40:	7119                	add	sp,sp,-128
    3f42:	fc86                	sd	ra,120(sp)
    3f44:	f8a2                	sd	s0,112(sp)
    3f46:	f4a6                	sd	s1,104(sp)
    3f48:	f0ca                	sd	s2,96(sp)
    3f4a:	ecce                	sd	s3,88(sp)
    3f4c:	e8d2                	sd	s4,80(sp)
    3f4e:	e4d6                	sd	s5,72(sp)
    3f50:	0100                	add	s0,sp,128
    3f52:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3f54:	fb040513          	add	a0,s0,-80
    3f58:	00001097          	auipc	ra,0x1
    3f5c:	568080e7          	jalr	1384(ra) # 54c0 <pipe>
    3f60:	e901                	bnez	a0,3f70 <sbrkfail+0x30>
    3f62:	f8040493          	add	s1,s0,-128
    3f66:	fa840993          	add	s3,s0,-88
    3f6a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3f6c:	5a7d                	li	s4,-1
    3f6e:	a085                	j	3fce <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3f70:	85d6                	mv	a1,s5
    3f72:	00002517          	auipc	a0,0x2
    3f76:	3de50513          	add	a0,a0,990 # 6350 <malloc+0xa80>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	89e080e7          	jalr	-1890(ra) # 5818 <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00001097          	auipc	ra,0x1
    3f88:	52c080e7          	jalr	1324(ra) # 54b0 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3f8c:	00001097          	auipc	ra,0x1
    3f90:	5ac080e7          	jalr	1452(ra) # 5538 <sbrk>
    3f94:	064007b7          	lui	a5,0x6400
    3f98:	40a7853b          	subw	a0,a5,a0
    3f9c:	00001097          	auipc	ra,0x1
    3fa0:	59c080e7          	jalr	1436(ra) # 5538 <sbrk>
      write(fds[1], "x", 1);
    3fa4:	4605                	li	a2,1
    3fa6:	00002597          	auipc	a1,0x2
    3faa:	aba58593          	add	a1,a1,-1350 # 5a60 <malloc+0x190>
    3fae:	fb442503          	lw	a0,-76(s0)
    3fb2:	00001097          	auipc	ra,0x1
    3fb6:	51e080e7          	jalr	1310(ra) # 54d0 <write>
      for(;;) sleep(1000);
    3fba:	3e800513          	li	a0,1000
    3fbe:	00001097          	auipc	ra,0x1
    3fc2:	582080e7          	jalr	1410(ra) # 5540 <sleep>
    3fc6:	bfd5                	j	3fba <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3fc8:	0911                	add	s2,s2,4
    3fca:	03390563          	beq	s2,s3,3ff4 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3fce:	00001097          	auipc	ra,0x1
    3fd2:	4da080e7          	jalr	1242(ra) # 54a8 <fork>
    3fd6:	00a92023          	sw	a0,0(s2)
    3fda:	d94d                	beqz	a0,3f8c <sbrkfail+0x4c>
    if(pids[i] != -1)
    3fdc:	ff4506e3          	beq	a0,s4,3fc8 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3fe0:	4605                	li	a2,1
    3fe2:	faf40593          	add	a1,s0,-81
    3fe6:	fb042503          	lw	a0,-80(s0)
    3fea:	00001097          	auipc	ra,0x1
    3fee:	4de080e7          	jalr	1246(ra) # 54c8 <read>
    3ff2:	bfd9                	j	3fc8 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3ff4:	6505                	lui	a0,0x1
    3ff6:	00001097          	auipc	ra,0x1
    3ffa:	542080e7          	jalr	1346(ra) # 5538 <sbrk>
    3ffe:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4000:	597d                	li	s2,-1
    4002:	a021                	j	400a <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4004:	0491                	add	s1,s1,4
    4006:	01348f63          	beq	s1,s3,4024 <sbrkfail+0xe4>
    if(pids[i] == -1)
    400a:	4088                	lw	a0,0(s1)
    400c:	ff250ce3          	beq	a0,s2,4004 <sbrkfail+0xc4>
    kill(pids[i]);
    4010:	00001097          	auipc	ra,0x1
    4014:	4d0080e7          	jalr	1232(ra) # 54e0 <kill>
    wait(0);
    4018:	4501                	li	a0,0
    401a:	00001097          	auipc	ra,0x1
    401e:	49e080e7          	jalr	1182(ra) # 54b8 <wait>
    4022:	b7cd                	j	4004 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4024:	57fd                	li	a5,-1
    4026:	04fa0163          	beq	s4,a5,4068 <sbrkfail+0x128>
  pid = fork();
    402a:	00001097          	auipc	ra,0x1
    402e:	47e080e7          	jalr	1150(ra) # 54a8 <fork>
    4032:	84aa                	mv	s1,a0
  if(pid < 0){
    4034:	04054863          	bltz	a0,4084 <sbrkfail+0x144>
  if(pid == 0){
    4038:	c525                	beqz	a0,40a0 <sbrkfail+0x160>
  wait(&xstatus);
    403a:	fbc40513          	add	a0,s0,-68
    403e:	00001097          	auipc	ra,0x1
    4042:	47a080e7          	jalr	1146(ra) # 54b8 <wait>
  if(xstatus != -1 && xstatus != 2)
    4046:	fbc42783          	lw	a5,-68(s0)
    404a:	577d                	li	a4,-1
    404c:	00e78563          	beq	a5,a4,4056 <sbrkfail+0x116>
    4050:	4709                	li	a4,2
    4052:	08e79d63          	bne	a5,a4,40ec <sbrkfail+0x1ac>
}
    4056:	70e6                	ld	ra,120(sp)
    4058:	7446                	ld	s0,112(sp)
    405a:	74a6                	ld	s1,104(sp)
    405c:	7906                	ld	s2,96(sp)
    405e:	69e6                	ld	s3,88(sp)
    4060:	6a46                	ld	s4,80(sp)
    4062:	6aa6                	ld	s5,72(sp)
    4064:	6109                	add	sp,sp,128
    4066:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4068:	85d6                	mv	a1,s5
    406a:	00003517          	auipc	a0,0x3
    406e:	48e50513          	add	a0,a0,1166 # 74f8 <malloc+0x1c28>
    4072:	00001097          	auipc	ra,0x1
    4076:	7a6080e7          	jalr	1958(ra) # 5818 <printf>
    exit(1);
    407a:	4505                	li	a0,1
    407c:	00001097          	auipc	ra,0x1
    4080:	434080e7          	jalr	1076(ra) # 54b0 <exit>
    printf("%s: fork failed\n", s);
    4084:	85d6                	mv	a1,s5
    4086:	00002517          	auipc	a0,0x2
    408a:	1c250513          	add	a0,a0,450 # 6248 <malloc+0x978>
    408e:	00001097          	auipc	ra,0x1
    4092:	78a080e7          	jalr	1930(ra) # 5818 <printf>
    exit(1);
    4096:	4505                	li	a0,1
    4098:	00001097          	auipc	ra,0x1
    409c:	418080e7          	jalr	1048(ra) # 54b0 <exit>
    a = sbrk(0);
    40a0:	4501                	li	a0,0
    40a2:	00001097          	auipc	ra,0x1
    40a6:	496080e7          	jalr	1174(ra) # 5538 <sbrk>
    40aa:	892a                	mv	s2,a0
    sbrk(10*BIG);
    40ac:	3e800537          	lui	a0,0x3e800
    40b0:	00001097          	auipc	ra,0x1
    40b4:	488080e7          	jalr	1160(ra) # 5538 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    40b8:	87ca                	mv	a5,s2
    40ba:	3e800737          	lui	a4,0x3e800
    40be:	993a                	add	s2,s2,a4
    40c0:	6705                	lui	a4,0x1
      n += *(a+i);
    40c2:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f16a0>
    40c6:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    40c8:	97ba                	add	a5,a5,a4
    40ca:	ff279ce3          	bne	a5,s2,40c2 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    40ce:	8626                	mv	a2,s1
    40d0:	85d6                	mv	a1,s5
    40d2:	00003517          	auipc	a0,0x3
    40d6:	44650513          	add	a0,a0,1094 # 7518 <malloc+0x1c48>
    40da:	00001097          	auipc	ra,0x1
    40de:	73e080e7          	jalr	1854(ra) # 5818 <printf>
    exit(1);
    40e2:	4505                	li	a0,1
    40e4:	00001097          	auipc	ra,0x1
    40e8:	3cc080e7          	jalr	972(ra) # 54b0 <exit>
    exit(1);
    40ec:	4505                	li	a0,1
    40ee:	00001097          	auipc	ra,0x1
    40f2:	3c2080e7          	jalr	962(ra) # 54b0 <exit>

00000000000040f6 <reparent>:
{
    40f6:	7179                	add	sp,sp,-48
    40f8:	f406                	sd	ra,40(sp)
    40fa:	f022                	sd	s0,32(sp)
    40fc:	ec26                	sd	s1,24(sp)
    40fe:	e84a                	sd	s2,16(sp)
    4100:	e44e                	sd	s3,8(sp)
    4102:	e052                	sd	s4,0(sp)
    4104:	1800                	add	s0,sp,48
    4106:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4108:	00001097          	auipc	ra,0x1
    410c:	428080e7          	jalr	1064(ra) # 5530 <getpid>
    4110:	8a2a                	mv	s4,a0
    4112:	0c800913          	li	s2,200
    int pid = fork();
    4116:	00001097          	auipc	ra,0x1
    411a:	392080e7          	jalr	914(ra) # 54a8 <fork>
    411e:	84aa                	mv	s1,a0
    if(pid < 0){
    4120:	02054263          	bltz	a0,4144 <reparent+0x4e>
    if(pid){
    4124:	cd21                	beqz	a0,417c <reparent+0x86>
      if(wait(0) != pid){
    4126:	4501                	li	a0,0
    4128:	00001097          	auipc	ra,0x1
    412c:	390080e7          	jalr	912(ra) # 54b8 <wait>
    4130:	02951863          	bne	a0,s1,4160 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4134:	397d                	addw	s2,s2,-1
    4136:	fe0910e3          	bnez	s2,4116 <reparent+0x20>
  exit(0);
    413a:	4501                	li	a0,0
    413c:	00001097          	auipc	ra,0x1
    4140:	374080e7          	jalr	884(ra) # 54b0 <exit>
      printf("%s: fork failed\n", s);
    4144:	85ce                	mv	a1,s3
    4146:	00002517          	auipc	a0,0x2
    414a:	10250513          	add	a0,a0,258 # 6248 <malloc+0x978>
    414e:	00001097          	auipc	ra,0x1
    4152:	6ca080e7          	jalr	1738(ra) # 5818 <printf>
      exit(1);
    4156:	4505                	li	a0,1
    4158:	00001097          	auipc	ra,0x1
    415c:	358080e7          	jalr	856(ra) # 54b0 <exit>
        printf("%s: wait wrong pid\n", s);
    4160:	85ce                	mv	a1,s3
    4162:	00002517          	auipc	a0,0x2
    4166:	26e50513          	add	a0,a0,622 # 63d0 <malloc+0xb00>
    416a:	00001097          	auipc	ra,0x1
    416e:	6ae080e7          	jalr	1710(ra) # 5818 <printf>
        exit(1);
    4172:	4505                	li	a0,1
    4174:	00001097          	auipc	ra,0x1
    4178:	33c080e7          	jalr	828(ra) # 54b0 <exit>
      int pid2 = fork();
    417c:	00001097          	auipc	ra,0x1
    4180:	32c080e7          	jalr	812(ra) # 54a8 <fork>
      if(pid2 < 0){
    4184:	00054763          	bltz	a0,4192 <reparent+0x9c>
      exit(0);
    4188:	4501                	li	a0,0
    418a:	00001097          	auipc	ra,0x1
    418e:	326080e7          	jalr	806(ra) # 54b0 <exit>
        kill(master_pid);
    4192:	8552                	mv	a0,s4
    4194:	00001097          	auipc	ra,0x1
    4198:	34c080e7          	jalr	844(ra) # 54e0 <kill>
        exit(1);
    419c:	4505                	li	a0,1
    419e:	00001097          	auipc	ra,0x1
    41a2:	312080e7          	jalr	786(ra) # 54b0 <exit>

00000000000041a6 <mem>:
{
    41a6:	7139                	add	sp,sp,-64
    41a8:	fc06                	sd	ra,56(sp)
    41aa:	f822                	sd	s0,48(sp)
    41ac:	f426                	sd	s1,40(sp)
    41ae:	f04a                	sd	s2,32(sp)
    41b0:	ec4e                	sd	s3,24(sp)
    41b2:	0080                	add	s0,sp,64
    41b4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    41b6:	00001097          	auipc	ra,0x1
    41ba:	2f2080e7          	jalr	754(ra) # 54a8 <fork>
    m1 = 0;
    41be:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    41c0:	6909                	lui	s2,0x2
    41c2:	71190913          	add	s2,s2,1809 # 2711 <sbrkmuch+0x111>
  if((pid = fork()) == 0){
    41c6:	c115                	beqz	a0,41ea <mem+0x44>
    wait(&xstatus);
    41c8:	fcc40513          	add	a0,s0,-52
    41cc:	00001097          	auipc	ra,0x1
    41d0:	2ec080e7          	jalr	748(ra) # 54b8 <wait>
    if(xstatus == -1){
    41d4:	fcc42503          	lw	a0,-52(s0)
    41d8:	57fd                	li	a5,-1
    41da:	06f50363          	beq	a0,a5,4240 <mem+0x9a>
    exit(xstatus);
    41de:	00001097          	auipc	ra,0x1
    41e2:	2d2080e7          	jalr	722(ra) # 54b0 <exit>
      *(char**)m2 = m1;
    41e6:	e104                	sd	s1,0(a0)
      m1 = m2;
    41e8:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    41ea:	854a                	mv	a0,s2
    41ec:	00001097          	auipc	ra,0x1
    41f0:	6e4080e7          	jalr	1764(ra) # 58d0 <malloc>
    41f4:	f96d                	bnez	a0,41e6 <mem+0x40>
    while(m1){
    41f6:	c881                	beqz	s1,4206 <mem+0x60>
      m2 = *(char**)m1;
    41f8:	8526                	mv	a0,s1
    41fa:	6084                	ld	s1,0(s1)
      free(m1);
    41fc:	00001097          	auipc	ra,0x1
    4200:	652080e7          	jalr	1618(ra) # 584e <free>
    while(m1){
    4204:	f8f5                	bnez	s1,41f8 <mem+0x52>
    m1 = malloc(1024*20);
    4206:	6515                	lui	a0,0x5
    4208:	00001097          	auipc	ra,0x1
    420c:	6c8080e7          	jalr	1736(ra) # 58d0 <malloc>
    if(m1 == 0){
    4210:	c911                	beqz	a0,4224 <mem+0x7e>
    free(m1);
    4212:	00001097          	auipc	ra,0x1
    4216:	63c080e7          	jalr	1596(ra) # 584e <free>
    exit(0);
    421a:	4501                	li	a0,0
    421c:	00001097          	auipc	ra,0x1
    4220:	294080e7          	jalr	660(ra) # 54b0 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4224:	85ce                	mv	a1,s3
    4226:	00003517          	auipc	a0,0x3
    422a:	32250513          	add	a0,a0,802 # 7548 <malloc+0x1c78>
    422e:	00001097          	auipc	ra,0x1
    4232:	5ea080e7          	jalr	1514(ra) # 5818 <printf>
      exit(1);
    4236:	4505                	li	a0,1
    4238:	00001097          	auipc	ra,0x1
    423c:	278080e7          	jalr	632(ra) # 54b0 <exit>
      exit(0);
    4240:	4501                	li	a0,0
    4242:	00001097          	auipc	ra,0x1
    4246:	26e080e7          	jalr	622(ra) # 54b0 <exit>

000000000000424a <sharedfd>:
{
    424a:	7159                	add	sp,sp,-112
    424c:	f486                	sd	ra,104(sp)
    424e:	f0a2                	sd	s0,96(sp)
    4250:	eca6                	sd	s1,88(sp)
    4252:	e8ca                	sd	s2,80(sp)
    4254:	e4ce                	sd	s3,72(sp)
    4256:	e0d2                	sd	s4,64(sp)
    4258:	fc56                	sd	s5,56(sp)
    425a:	f85a                	sd	s6,48(sp)
    425c:	f45e                	sd	s7,40(sp)
    425e:	1880                	add	s0,sp,112
    4260:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4262:	00003517          	auipc	a0,0x3
    4266:	30650513          	add	a0,a0,774 # 7568 <malloc+0x1c98>
    426a:	00001097          	auipc	ra,0x1
    426e:	296080e7          	jalr	662(ra) # 5500 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4272:	20200593          	li	a1,514
    4276:	00003517          	auipc	a0,0x3
    427a:	2f250513          	add	a0,a0,754 # 7568 <malloc+0x1c98>
    427e:	00001097          	auipc	ra,0x1
    4282:	272080e7          	jalr	626(ra) # 54f0 <open>
  if(fd < 0){
    4286:	04054a63          	bltz	a0,42da <sharedfd+0x90>
    428a:	892a                	mv	s2,a0
  pid = fork();
    428c:	00001097          	auipc	ra,0x1
    4290:	21c080e7          	jalr	540(ra) # 54a8 <fork>
    4294:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4296:	07000593          	li	a1,112
    429a:	e119                	bnez	a0,42a0 <sharedfd+0x56>
    429c:	06300593          	li	a1,99
    42a0:	4629                	li	a2,10
    42a2:	fa040513          	add	a0,s0,-96
    42a6:	00001097          	auipc	ra,0x1
    42aa:	010080e7          	jalr	16(ra) # 52b6 <memset>
    42ae:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    42b2:	4629                	li	a2,10
    42b4:	fa040593          	add	a1,s0,-96
    42b8:	854a                	mv	a0,s2
    42ba:	00001097          	auipc	ra,0x1
    42be:	216080e7          	jalr	534(ra) # 54d0 <write>
    42c2:	47a9                	li	a5,10
    42c4:	02f51963          	bne	a0,a5,42f6 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    42c8:	34fd                	addw	s1,s1,-1
    42ca:	f4e5                	bnez	s1,42b2 <sharedfd+0x68>
  if(pid == 0) {
    42cc:	04099363          	bnez	s3,4312 <sharedfd+0xc8>
    exit(0);
    42d0:	4501                	li	a0,0
    42d2:	00001097          	auipc	ra,0x1
    42d6:	1de080e7          	jalr	478(ra) # 54b0 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    42da:	85d2                	mv	a1,s4
    42dc:	00003517          	auipc	a0,0x3
    42e0:	29c50513          	add	a0,a0,668 # 7578 <malloc+0x1ca8>
    42e4:	00001097          	auipc	ra,0x1
    42e8:	534080e7          	jalr	1332(ra) # 5818 <printf>
    exit(1);
    42ec:	4505                	li	a0,1
    42ee:	00001097          	auipc	ra,0x1
    42f2:	1c2080e7          	jalr	450(ra) # 54b0 <exit>
      printf("%s: write sharedfd failed\n", s);
    42f6:	85d2                	mv	a1,s4
    42f8:	00003517          	auipc	a0,0x3
    42fc:	2a850513          	add	a0,a0,680 # 75a0 <malloc+0x1cd0>
    4300:	00001097          	auipc	ra,0x1
    4304:	518080e7          	jalr	1304(ra) # 5818 <printf>
      exit(1);
    4308:	4505                	li	a0,1
    430a:	00001097          	auipc	ra,0x1
    430e:	1a6080e7          	jalr	422(ra) # 54b0 <exit>
    wait(&xstatus);
    4312:	f9c40513          	add	a0,s0,-100
    4316:	00001097          	auipc	ra,0x1
    431a:	1a2080e7          	jalr	418(ra) # 54b8 <wait>
    if(xstatus != 0)
    431e:	f9c42983          	lw	s3,-100(s0)
    4322:	00098763          	beqz	s3,4330 <sharedfd+0xe6>
      exit(xstatus);
    4326:	854e                	mv	a0,s3
    4328:	00001097          	auipc	ra,0x1
    432c:	188080e7          	jalr	392(ra) # 54b0 <exit>
  close(fd);
    4330:	854a                	mv	a0,s2
    4332:	00001097          	auipc	ra,0x1
    4336:	1a6080e7          	jalr	422(ra) # 54d8 <close>
  fd = open("sharedfd", 0);
    433a:	4581                	li	a1,0
    433c:	00003517          	auipc	a0,0x3
    4340:	22c50513          	add	a0,a0,556 # 7568 <malloc+0x1c98>
    4344:	00001097          	auipc	ra,0x1
    4348:	1ac080e7          	jalr	428(ra) # 54f0 <open>
    434c:	8baa                	mv	s7,a0
  nc = np = 0;
    434e:	8ace                	mv	s5,s3
  if(fd < 0){
    4350:	02054563          	bltz	a0,437a <sharedfd+0x130>
    4354:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4358:	06300493          	li	s1,99
      if(buf[i] == 'p')
    435c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4360:	4629                	li	a2,10
    4362:	fa040593          	add	a1,s0,-96
    4366:	855e                	mv	a0,s7
    4368:	00001097          	auipc	ra,0x1
    436c:	160080e7          	jalr	352(ra) # 54c8 <read>
    4370:	02a05f63          	blez	a0,43ae <sharedfd+0x164>
    4374:	fa040793          	add	a5,s0,-96
    4378:	a01d                	j	439e <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    437a:	85d2                	mv	a1,s4
    437c:	00003517          	auipc	a0,0x3
    4380:	24450513          	add	a0,a0,580 # 75c0 <malloc+0x1cf0>
    4384:	00001097          	auipc	ra,0x1
    4388:	494080e7          	jalr	1172(ra) # 5818 <printf>
    exit(1);
    438c:	4505                	li	a0,1
    438e:	00001097          	auipc	ra,0x1
    4392:	122080e7          	jalr	290(ra) # 54b0 <exit>
        nc++;
    4396:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4398:	0785                	add	a5,a5,1
    439a:	fd2783e3          	beq	a5,s2,4360 <sharedfd+0x116>
      if(buf[i] == 'c')
    439e:	0007c703          	lbu	a4,0(a5)
    43a2:	fe970ae3          	beq	a4,s1,4396 <sharedfd+0x14c>
      if(buf[i] == 'p')
    43a6:	ff6719e3          	bne	a4,s6,4398 <sharedfd+0x14e>
        np++;
    43aa:	2a85                	addw	s5,s5,1
    43ac:	b7f5                	j	4398 <sharedfd+0x14e>
  close(fd);
    43ae:	855e                	mv	a0,s7
    43b0:	00001097          	auipc	ra,0x1
    43b4:	128080e7          	jalr	296(ra) # 54d8 <close>
  unlink("sharedfd");
    43b8:	00003517          	auipc	a0,0x3
    43bc:	1b050513          	add	a0,a0,432 # 7568 <malloc+0x1c98>
    43c0:	00001097          	auipc	ra,0x1
    43c4:	140080e7          	jalr	320(ra) # 5500 <unlink>
  if(nc == N*SZ && np == N*SZ){
    43c8:	6789                	lui	a5,0x2
    43ca:	71078793          	add	a5,a5,1808 # 2710 <sbrkmuch+0x110>
    43ce:	00f99763          	bne	s3,a5,43dc <sharedfd+0x192>
    43d2:	6789                	lui	a5,0x2
    43d4:	71078793          	add	a5,a5,1808 # 2710 <sbrkmuch+0x110>
    43d8:	02fa8063          	beq	s5,a5,43f8 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    43dc:	85d2                	mv	a1,s4
    43de:	00003517          	auipc	a0,0x3
    43e2:	20a50513          	add	a0,a0,522 # 75e8 <malloc+0x1d18>
    43e6:	00001097          	auipc	ra,0x1
    43ea:	432080e7          	jalr	1074(ra) # 5818 <printf>
    exit(1);
    43ee:	4505                	li	a0,1
    43f0:	00001097          	auipc	ra,0x1
    43f4:	0c0080e7          	jalr	192(ra) # 54b0 <exit>
    exit(0);
    43f8:	4501                	li	a0,0
    43fa:	00001097          	auipc	ra,0x1
    43fe:	0b6080e7          	jalr	182(ra) # 54b0 <exit>

0000000000004402 <fourfiles>:
{
    4402:	7135                	add	sp,sp,-160
    4404:	ed06                	sd	ra,152(sp)
    4406:	e922                	sd	s0,144(sp)
    4408:	e526                	sd	s1,136(sp)
    440a:	e14a                	sd	s2,128(sp)
    440c:	fcce                	sd	s3,120(sp)
    440e:	f8d2                	sd	s4,112(sp)
    4410:	f4d6                	sd	s5,104(sp)
    4412:	f0da                	sd	s6,96(sp)
    4414:	ecde                	sd	s7,88(sp)
    4416:	e8e2                	sd	s8,80(sp)
    4418:	e4e6                	sd	s9,72(sp)
    441a:	e0ea                	sd	s10,64(sp)
    441c:	fc6e                	sd	s11,56(sp)
    441e:	1100                	add	s0,sp,160
    4420:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4422:	00003797          	auipc	a5,0x3
    4426:	1de78793          	add	a5,a5,478 # 7600 <malloc+0x1d30>
    442a:	f6f43823          	sd	a5,-144(s0)
    442e:	00003797          	auipc	a5,0x3
    4432:	1da78793          	add	a5,a5,474 # 7608 <malloc+0x1d38>
    4436:	f6f43c23          	sd	a5,-136(s0)
    443a:	00003797          	auipc	a5,0x3
    443e:	1d678793          	add	a5,a5,470 # 7610 <malloc+0x1d40>
    4442:	f8f43023          	sd	a5,-128(s0)
    4446:	00003797          	auipc	a5,0x3
    444a:	1d278793          	add	a5,a5,466 # 7618 <malloc+0x1d48>
    444e:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4452:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4456:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4458:	4481                	li	s1,0
    445a:	4a11                	li	s4,4
    fname = names[pi];
    445c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4460:	854e                	mv	a0,s3
    4462:	00001097          	auipc	ra,0x1
    4466:	09e080e7          	jalr	158(ra) # 5500 <unlink>
    pid = fork();
    446a:	00001097          	auipc	ra,0x1
    446e:	03e080e7          	jalr	62(ra) # 54a8 <fork>
    if(pid < 0){
    4472:	04054063          	bltz	a0,44b2 <fourfiles+0xb0>
    if(pid == 0){
    4476:	cd21                	beqz	a0,44ce <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4478:	2485                	addw	s1,s1,1
    447a:	0921                	add	s2,s2,8
    447c:	ff4490e3          	bne	s1,s4,445c <fourfiles+0x5a>
    4480:	4491                	li	s1,4
    wait(&xstatus);
    4482:	f6c40513          	add	a0,s0,-148
    4486:	00001097          	auipc	ra,0x1
    448a:	032080e7          	jalr	50(ra) # 54b8 <wait>
    if(xstatus != 0)
    448e:	f6c42a83          	lw	s5,-148(s0)
    4492:	0c0a9863          	bnez	s5,4562 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4496:	34fd                	addw	s1,s1,-1
    4498:	f4ed                	bnez	s1,4482 <fourfiles+0x80>
    449a:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    449e:	00007a17          	auipc	s4,0x7
    44a2:	4b2a0a13          	add	s4,s4,1202 # b950 <buf>
    if(total != N*SZ){
    44a6:	6d05                	lui	s10,0x1
    44a8:	770d0d13          	add	s10,s10,1904 # 1770 <pipe1+0x20>
  for(i = 0; i < NCHILD; i++){
    44ac:	03400d93          	li	s11,52
    44b0:	a22d                	j	45da <fourfiles+0x1d8>
      printf("fork failed\n", s);
    44b2:	85e6                	mv	a1,s9
    44b4:	00002517          	auipc	a0,0x2
    44b8:	18450513          	add	a0,a0,388 # 6638 <malloc+0xd68>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	35c080e7          	jalr	860(ra) # 5818 <printf>
      exit(1);
    44c4:	4505                	li	a0,1
    44c6:	00001097          	auipc	ra,0x1
    44ca:	fea080e7          	jalr	-22(ra) # 54b0 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    44ce:	20200593          	li	a1,514
    44d2:	854e                	mv	a0,s3
    44d4:	00001097          	auipc	ra,0x1
    44d8:	01c080e7          	jalr	28(ra) # 54f0 <open>
    44dc:	892a                	mv	s2,a0
      if(fd < 0){
    44de:	04054763          	bltz	a0,452c <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    44e2:	1f400613          	li	a2,500
    44e6:	0304859b          	addw	a1,s1,48
    44ea:	00007517          	auipc	a0,0x7
    44ee:	46650513          	add	a0,a0,1126 # b950 <buf>
    44f2:	00001097          	auipc	ra,0x1
    44f6:	dc4080e7          	jalr	-572(ra) # 52b6 <memset>
    44fa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    44fc:	00007997          	auipc	s3,0x7
    4500:	45498993          	add	s3,s3,1108 # b950 <buf>
    4504:	1f400613          	li	a2,500
    4508:	85ce                	mv	a1,s3
    450a:	854a                	mv	a0,s2
    450c:	00001097          	auipc	ra,0x1
    4510:	fc4080e7          	jalr	-60(ra) # 54d0 <write>
    4514:	85aa                	mv	a1,a0
    4516:	1f400793          	li	a5,500
    451a:	02f51763          	bne	a0,a5,4548 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    451e:	34fd                	addw	s1,s1,-1
    4520:	f0f5                	bnez	s1,4504 <fourfiles+0x102>
      exit(0);
    4522:	4501                	li	a0,0
    4524:	00001097          	auipc	ra,0x1
    4528:	f8c080e7          	jalr	-116(ra) # 54b0 <exit>
        printf("create failed\n", s);
    452c:	85e6                	mv	a1,s9
    452e:	00003517          	auipc	a0,0x3
    4532:	0f250513          	add	a0,a0,242 # 7620 <malloc+0x1d50>
    4536:	00001097          	auipc	ra,0x1
    453a:	2e2080e7          	jalr	738(ra) # 5818 <printf>
        exit(1);
    453e:	4505                	li	a0,1
    4540:	00001097          	auipc	ra,0x1
    4544:	f70080e7          	jalr	-144(ra) # 54b0 <exit>
          printf("write failed %d\n", n);
    4548:	00003517          	auipc	a0,0x3
    454c:	0e850513          	add	a0,a0,232 # 7630 <malloc+0x1d60>
    4550:	00001097          	auipc	ra,0x1
    4554:	2c8080e7          	jalr	712(ra) # 5818 <printf>
          exit(1);
    4558:	4505                	li	a0,1
    455a:	00001097          	auipc	ra,0x1
    455e:	f56080e7          	jalr	-170(ra) # 54b0 <exit>
      exit(xstatus);
    4562:	8556                	mv	a0,s5
    4564:	00001097          	auipc	ra,0x1
    4568:	f4c080e7          	jalr	-180(ra) # 54b0 <exit>
          printf("wrong char\n", s);
    456c:	85e6                	mv	a1,s9
    456e:	00003517          	auipc	a0,0x3
    4572:	0da50513          	add	a0,a0,218 # 7648 <malloc+0x1d78>
    4576:	00001097          	auipc	ra,0x1
    457a:	2a2080e7          	jalr	674(ra) # 5818 <printf>
          exit(1);
    457e:	4505                	li	a0,1
    4580:	00001097          	auipc	ra,0x1
    4584:	f30080e7          	jalr	-208(ra) # 54b0 <exit>
      total += n;
    4588:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    458c:	660d                	lui	a2,0x3
    458e:	85d2                	mv	a1,s4
    4590:	854e                	mv	a0,s3
    4592:	00001097          	auipc	ra,0x1
    4596:	f36080e7          	jalr	-202(ra) # 54c8 <read>
    459a:	02a05063          	blez	a0,45ba <fourfiles+0x1b8>
    459e:	00007797          	auipc	a5,0x7
    45a2:	3b278793          	add	a5,a5,946 # b950 <buf>
    45a6:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    45aa:	0007c703          	lbu	a4,0(a5)
    45ae:	fa971fe3          	bne	a4,s1,456c <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    45b2:	0785                	add	a5,a5,1
    45b4:	fed79be3          	bne	a5,a3,45aa <fourfiles+0x1a8>
    45b8:	bfc1                	j	4588 <fourfiles+0x186>
    close(fd);
    45ba:	854e                	mv	a0,s3
    45bc:	00001097          	auipc	ra,0x1
    45c0:	f1c080e7          	jalr	-228(ra) # 54d8 <close>
    if(total != N*SZ){
    45c4:	03a91863          	bne	s2,s10,45f4 <fourfiles+0x1f2>
    unlink(fname);
    45c8:	8562                	mv	a0,s8
    45ca:	00001097          	auipc	ra,0x1
    45ce:	f36080e7          	jalr	-202(ra) # 5500 <unlink>
  for(i = 0; i < NCHILD; i++){
    45d2:	0ba1                	add	s7,s7,8
    45d4:	2b05                	addw	s6,s6,1
    45d6:	03bb0d63          	beq	s6,s11,4610 <fourfiles+0x20e>
    fname = names[i];
    45da:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    45de:	4581                	li	a1,0
    45e0:	8562                	mv	a0,s8
    45e2:	00001097          	auipc	ra,0x1
    45e6:	f0e080e7          	jalr	-242(ra) # 54f0 <open>
    45ea:	89aa                	mv	s3,a0
    total = 0;
    45ec:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    45ee:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45f2:	bf69                	j	458c <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    45f4:	85ca                	mv	a1,s2
    45f6:	00003517          	auipc	a0,0x3
    45fa:	06250513          	add	a0,a0,98 # 7658 <malloc+0x1d88>
    45fe:	00001097          	auipc	ra,0x1
    4602:	21a080e7          	jalr	538(ra) # 5818 <printf>
      exit(1);
    4606:	4505                	li	a0,1
    4608:	00001097          	auipc	ra,0x1
    460c:	ea8080e7          	jalr	-344(ra) # 54b0 <exit>
}
    4610:	60ea                	ld	ra,152(sp)
    4612:	644a                	ld	s0,144(sp)
    4614:	64aa                	ld	s1,136(sp)
    4616:	690a                	ld	s2,128(sp)
    4618:	79e6                	ld	s3,120(sp)
    461a:	7a46                	ld	s4,112(sp)
    461c:	7aa6                	ld	s5,104(sp)
    461e:	7b06                	ld	s6,96(sp)
    4620:	6be6                	ld	s7,88(sp)
    4622:	6c46                	ld	s8,80(sp)
    4624:	6ca6                	ld	s9,72(sp)
    4626:	6d06                	ld	s10,64(sp)
    4628:	7de2                	ld	s11,56(sp)
    462a:	610d                	add	sp,sp,160
    462c:	8082                	ret

000000000000462e <concreate>:
{
    462e:	7135                	add	sp,sp,-160
    4630:	ed06                	sd	ra,152(sp)
    4632:	e922                	sd	s0,144(sp)
    4634:	e526                	sd	s1,136(sp)
    4636:	e14a                	sd	s2,128(sp)
    4638:	fcce                	sd	s3,120(sp)
    463a:	f8d2                	sd	s4,112(sp)
    463c:	f4d6                	sd	s5,104(sp)
    463e:	f0da                	sd	s6,96(sp)
    4640:	ecde                	sd	s7,88(sp)
    4642:	1100                	add	s0,sp,160
    4644:	89aa                	mv	s3,a0
  file[0] = 'C';
    4646:	04300793          	li	a5,67
    464a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    464e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4652:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4654:	4b0d                	li	s6,3
    4656:	4a85                	li	s5,1
      link("C0", file);
    4658:	00003b97          	auipc	s7,0x3
    465c:	018b8b93          	add	s7,s7,24 # 7670 <malloc+0x1da0>
  for(i = 0; i < N; i++){
    4660:	02800a13          	li	s4,40
    4664:	acc9                	j	4936 <concreate+0x308>
      link("C0", file);
    4666:	fa840593          	add	a1,s0,-88
    466a:	855e                	mv	a0,s7
    466c:	00001097          	auipc	ra,0x1
    4670:	ea4080e7          	jalr	-348(ra) # 5510 <link>
    if(pid == 0) {
    4674:	a465                	j	491c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4676:	4795                	li	a5,5
    4678:	02f9693b          	remw	s2,s2,a5
    467c:	4785                	li	a5,1
    467e:	02f90b63          	beq	s2,a5,46b4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4682:	20200593          	li	a1,514
    4686:	fa840513          	add	a0,s0,-88
    468a:	00001097          	auipc	ra,0x1
    468e:	e66080e7          	jalr	-410(ra) # 54f0 <open>
      if(fd < 0){
    4692:	26055c63          	bgez	a0,490a <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4696:	fa840593          	add	a1,s0,-88
    469a:	00003517          	auipc	a0,0x3
    469e:	fde50513          	add	a0,a0,-34 # 7678 <malloc+0x1da8>
    46a2:	00001097          	auipc	ra,0x1
    46a6:	176080e7          	jalr	374(ra) # 5818 <printf>
        exit(1);
    46aa:	4505                	li	a0,1
    46ac:	00001097          	auipc	ra,0x1
    46b0:	e04080e7          	jalr	-508(ra) # 54b0 <exit>
      link("C0", file);
    46b4:	fa840593          	add	a1,s0,-88
    46b8:	00003517          	auipc	a0,0x3
    46bc:	fb850513          	add	a0,a0,-72 # 7670 <malloc+0x1da0>
    46c0:	00001097          	auipc	ra,0x1
    46c4:	e50080e7          	jalr	-432(ra) # 5510 <link>
      exit(0);
    46c8:	4501                	li	a0,0
    46ca:	00001097          	auipc	ra,0x1
    46ce:	de6080e7          	jalr	-538(ra) # 54b0 <exit>
        exit(1);
    46d2:	4505                	li	a0,1
    46d4:	00001097          	auipc	ra,0x1
    46d8:	ddc080e7          	jalr	-548(ra) # 54b0 <exit>
  memset(fa, 0, sizeof(fa));
    46dc:	02800613          	li	a2,40
    46e0:	4581                	li	a1,0
    46e2:	f8040513          	add	a0,s0,-128
    46e6:	00001097          	auipc	ra,0x1
    46ea:	bd0080e7          	jalr	-1072(ra) # 52b6 <memset>
  fd = open(".", 0);
    46ee:	4581                	li	a1,0
    46f0:	00002517          	auipc	a0,0x2
    46f4:	9b850513          	add	a0,a0,-1608 # 60a8 <malloc+0x7d8>
    46f8:	00001097          	auipc	ra,0x1
    46fc:	df8080e7          	jalr	-520(ra) # 54f0 <open>
    4700:	892a                	mv	s2,a0
  n = 0;
    4702:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4704:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4708:	02700b13          	li	s6,39
      fa[i] = 1;
    470c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    470e:	4641                	li	a2,16
    4710:	f7040593          	add	a1,s0,-144
    4714:	854a                	mv	a0,s2
    4716:	00001097          	auipc	ra,0x1
    471a:	db2080e7          	jalr	-590(ra) # 54c8 <read>
    471e:	08a05263          	blez	a0,47a2 <concreate+0x174>
    if(de.inum == 0)
    4722:	f7045783          	lhu	a5,-144(s0)
    4726:	d7e5                	beqz	a5,470e <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4728:	f7244783          	lbu	a5,-142(s0)
    472c:	ff4791e3          	bne	a5,s4,470e <concreate+0xe0>
    4730:	f7444783          	lbu	a5,-140(s0)
    4734:	ffe9                	bnez	a5,470e <concreate+0xe0>
      i = de.name[1] - '0';
    4736:	f7344783          	lbu	a5,-141(s0)
    473a:	fd07879b          	addw	a5,a5,-48
    473e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4742:	02eb6063          	bltu	s6,a4,4762 <concreate+0x134>
      if(fa[i]){
    4746:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x3c>
    474a:	97a2                	add	a5,a5,s0
    474c:	fd07c783          	lbu	a5,-48(a5)
    4750:	eb8d                	bnez	a5,4782 <concreate+0x154>
      fa[i] = 1;
    4752:	fb070793          	add	a5,a4,-80
    4756:	00878733          	add	a4,a5,s0
    475a:	fd770823          	sb	s7,-48(a4)
      n++;
    475e:	2a85                	addw	s5,s5,1
    4760:	b77d                	j	470e <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4762:	f7240613          	add	a2,s0,-142
    4766:	85ce                	mv	a1,s3
    4768:	00003517          	auipc	a0,0x3
    476c:	f3050513          	add	a0,a0,-208 # 7698 <malloc+0x1dc8>
    4770:	00001097          	auipc	ra,0x1
    4774:	0a8080e7          	jalr	168(ra) # 5818 <printf>
        exit(1);
    4778:	4505                	li	a0,1
    477a:	00001097          	auipc	ra,0x1
    477e:	d36080e7          	jalr	-714(ra) # 54b0 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4782:	f7240613          	add	a2,s0,-142
    4786:	85ce                	mv	a1,s3
    4788:	00003517          	auipc	a0,0x3
    478c:	f3050513          	add	a0,a0,-208 # 76b8 <malloc+0x1de8>
    4790:	00001097          	auipc	ra,0x1
    4794:	088080e7          	jalr	136(ra) # 5818 <printf>
        exit(1);
    4798:	4505                	li	a0,1
    479a:	00001097          	auipc	ra,0x1
    479e:	d16080e7          	jalr	-746(ra) # 54b0 <exit>
  close(fd);
    47a2:	854a                	mv	a0,s2
    47a4:	00001097          	auipc	ra,0x1
    47a8:	d34080e7          	jalr	-716(ra) # 54d8 <close>
  if(n != N){
    47ac:	02800793          	li	a5,40
    47b0:	00fa9763          	bne	s5,a5,47be <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    47b4:	4a8d                	li	s5,3
    47b6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    47b8:	02800a13          	li	s4,40
    47bc:	a8c9                	j	488e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    47be:	85ce                	mv	a1,s3
    47c0:	00003517          	auipc	a0,0x3
    47c4:	f2050513          	add	a0,a0,-224 # 76e0 <malloc+0x1e10>
    47c8:	00001097          	auipc	ra,0x1
    47cc:	050080e7          	jalr	80(ra) # 5818 <printf>
    exit(1);
    47d0:	4505                	li	a0,1
    47d2:	00001097          	auipc	ra,0x1
    47d6:	cde080e7          	jalr	-802(ra) # 54b0 <exit>
      printf("%s: fork failed\n", s);
    47da:	85ce                	mv	a1,s3
    47dc:	00002517          	auipc	a0,0x2
    47e0:	a6c50513          	add	a0,a0,-1428 # 6248 <malloc+0x978>
    47e4:	00001097          	auipc	ra,0x1
    47e8:	034080e7          	jalr	52(ra) # 5818 <printf>
      exit(1);
    47ec:	4505                	li	a0,1
    47ee:	00001097          	auipc	ra,0x1
    47f2:	cc2080e7          	jalr	-830(ra) # 54b0 <exit>
      close(open(file, 0));
    47f6:	4581                	li	a1,0
    47f8:	fa840513          	add	a0,s0,-88
    47fc:	00001097          	auipc	ra,0x1
    4800:	cf4080e7          	jalr	-780(ra) # 54f0 <open>
    4804:	00001097          	auipc	ra,0x1
    4808:	cd4080e7          	jalr	-812(ra) # 54d8 <close>
      close(open(file, 0));
    480c:	4581                	li	a1,0
    480e:	fa840513          	add	a0,s0,-88
    4812:	00001097          	auipc	ra,0x1
    4816:	cde080e7          	jalr	-802(ra) # 54f0 <open>
    481a:	00001097          	auipc	ra,0x1
    481e:	cbe080e7          	jalr	-834(ra) # 54d8 <close>
      close(open(file, 0));
    4822:	4581                	li	a1,0
    4824:	fa840513          	add	a0,s0,-88
    4828:	00001097          	auipc	ra,0x1
    482c:	cc8080e7          	jalr	-824(ra) # 54f0 <open>
    4830:	00001097          	auipc	ra,0x1
    4834:	ca8080e7          	jalr	-856(ra) # 54d8 <close>
      close(open(file, 0));
    4838:	4581                	li	a1,0
    483a:	fa840513          	add	a0,s0,-88
    483e:	00001097          	auipc	ra,0x1
    4842:	cb2080e7          	jalr	-846(ra) # 54f0 <open>
    4846:	00001097          	auipc	ra,0x1
    484a:	c92080e7          	jalr	-878(ra) # 54d8 <close>
      close(open(file, 0));
    484e:	4581                	li	a1,0
    4850:	fa840513          	add	a0,s0,-88
    4854:	00001097          	auipc	ra,0x1
    4858:	c9c080e7          	jalr	-868(ra) # 54f0 <open>
    485c:	00001097          	auipc	ra,0x1
    4860:	c7c080e7          	jalr	-900(ra) # 54d8 <close>
      close(open(file, 0));
    4864:	4581                	li	a1,0
    4866:	fa840513          	add	a0,s0,-88
    486a:	00001097          	auipc	ra,0x1
    486e:	c86080e7          	jalr	-890(ra) # 54f0 <open>
    4872:	00001097          	auipc	ra,0x1
    4876:	c66080e7          	jalr	-922(ra) # 54d8 <close>
    if(pid == 0)
    487a:	08090363          	beqz	s2,4900 <concreate+0x2d2>
      wait(0);
    487e:	4501                	li	a0,0
    4880:	00001097          	auipc	ra,0x1
    4884:	c38080e7          	jalr	-968(ra) # 54b8 <wait>
  for(i = 0; i < N; i++){
    4888:	2485                	addw	s1,s1,1
    488a:	0f448563          	beq	s1,s4,4974 <concreate+0x346>
    file[1] = '0' + i;
    488e:	0304879b          	addw	a5,s1,48
    4892:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4896:	00001097          	auipc	ra,0x1
    489a:	c12080e7          	jalr	-1006(ra) # 54a8 <fork>
    489e:	892a                	mv	s2,a0
    if(pid < 0){
    48a0:	f2054de3          	bltz	a0,47da <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    48a4:	0354e73b          	remw	a4,s1,s5
    48a8:	00a767b3          	or	a5,a4,a0
    48ac:	2781                	sext.w	a5,a5
    48ae:	d7a1                	beqz	a5,47f6 <concreate+0x1c8>
    48b0:	01671363          	bne	a4,s6,48b6 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    48b4:	f129                	bnez	a0,47f6 <concreate+0x1c8>
      unlink(file);
    48b6:	fa840513          	add	a0,s0,-88
    48ba:	00001097          	auipc	ra,0x1
    48be:	c46080e7          	jalr	-954(ra) # 5500 <unlink>
      unlink(file);
    48c2:	fa840513          	add	a0,s0,-88
    48c6:	00001097          	auipc	ra,0x1
    48ca:	c3a080e7          	jalr	-966(ra) # 5500 <unlink>
      unlink(file);
    48ce:	fa840513          	add	a0,s0,-88
    48d2:	00001097          	auipc	ra,0x1
    48d6:	c2e080e7          	jalr	-978(ra) # 5500 <unlink>
      unlink(file);
    48da:	fa840513          	add	a0,s0,-88
    48de:	00001097          	auipc	ra,0x1
    48e2:	c22080e7          	jalr	-990(ra) # 5500 <unlink>
      unlink(file);
    48e6:	fa840513          	add	a0,s0,-88
    48ea:	00001097          	auipc	ra,0x1
    48ee:	c16080e7          	jalr	-1002(ra) # 5500 <unlink>
      unlink(file);
    48f2:	fa840513          	add	a0,s0,-88
    48f6:	00001097          	auipc	ra,0x1
    48fa:	c0a080e7          	jalr	-1014(ra) # 5500 <unlink>
    48fe:	bfb5                	j	487a <concreate+0x24c>
      exit(0);
    4900:	4501                	li	a0,0
    4902:	00001097          	auipc	ra,0x1
    4906:	bae080e7          	jalr	-1106(ra) # 54b0 <exit>
      close(fd);
    490a:	00001097          	auipc	ra,0x1
    490e:	bce080e7          	jalr	-1074(ra) # 54d8 <close>
    if(pid == 0) {
    4912:	bb5d                	j	46c8 <concreate+0x9a>
      close(fd);
    4914:	00001097          	auipc	ra,0x1
    4918:	bc4080e7          	jalr	-1084(ra) # 54d8 <close>
      wait(&xstatus);
    491c:	f6c40513          	add	a0,s0,-148
    4920:	00001097          	auipc	ra,0x1
    4924:	b98080e7          	jalr	-1128(ra) # 54b8 <wait>
      if(xstatus != 0)
    4928:	f6c42483          	lw	s1,-148(s0)
    492c:	da0493e3          	bnez	s1,46d2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4930:	2905                	addw	s2,s2,1
    4932:	db4905e3          	beq	s2,s4,46dc <concreate+0xae>
    file[1] = '0' + i;
    4936:	0309079b          	addw	a5,s2,48
    493a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    493e:	fa840513          	add	a0,s0,-88
    4942:	00001097          	auipc	ra,0x1
    4946:	bbe080e7          	jalr	-1090(ra) # 5500 <unlink>
    pid = fork();
    494a:	00001097          	auipc	ra,0x1
    494e:	b5e080e7          	jalr	-1186(ra) # 54a8 <fork>
    if(pid && (i % 3) == 1){
    4952:	d20502e3          	beqz	a0,4676 <concreate+0x48>
    4956:	036967bb          	remw	a5,s2,s6
    495a:	d15786e3          	beq	a5,s5,4666 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    495e:	20200593          	li	a1,514
    4962:	fa840513          	add	a0,s0,-88
    4966:	00001097          	auipc	ra,0x1
    496a:	b8a080e7          	jalr	-1142(ra) # 54f0 <open>
      if(fd < 0){
    496e:	fa0553e3          	bgez	a0,4914 <concreate+0x2e6>
    4972:	b315                	j	4696 <concreate+0x68>
}
    4974:	60ea                	ld	ra,152(sp)
    4976:	644a                	ld	s0,144(sp)
    4978:	64aa                	ld	s1,136(sp)
    497a:	690a                	ld	s2,128(sp)
    497c:	79e6                	ld	s3,120(sp)
    497e:	7a46                	ld	s4,112(sp)
    4980:	7aa6                	ld	s5,104(sp)
    4982:	7b06                	ld	s6,96(sp)
    4984:	6be6                	ld	s7,88(sp)
    4986:	610d                	add	sp,sp,160
    4988:	8082                	ret

000000000000498a <bigfile>:
{
    498a:	7139                	add	sp,sp,-64
    498c:	fc06                	sd	ra,56(sp)
    498e:	f822                	sd	s0,48(sp)
    4990:	f426                	sd	s1,40(sp)
    4992:	f04a                	sd	s2,32(sp)
    4994:	ec4e                	sd	s3,24(sp)
    4996:	e852                	sd	s4,16(sp)
    4998:	e456                	sd	s5,8(sp)
    499a:	0080                	add	s0,sp,64
    499c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    499e:	00003517          	auipc	a0,0x3
    49a2:	d7a50513          	add	a0,a0,-646 # 7718 <malloc+0x1e48>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	b5a080e7          	jalr	-1190(ra) # 5500 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    49ae:	20200593          	li	a1,514
    49b2:	00003517          	auipc	a0,0x3
    49b6:	d6650513          	add	a0,a0,-666 # 7718 <malloc+0x1e48>
    49ba:	00001097          	auipc	ra,0x1
    49be:	b36080e7          	jalr	-1226(ra) # 54f0 <open>
    49c2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    49c4:	4481                	li	s1,0
    memset(buf, i, SZ);
    49c6:	00007917          	auipc	s2,0x7
    49ca:	f8a90913          	add	s2,s2,-118 # b950 <buf>
  for(i = 0; i < N; i++){
    49ce:	4a51                	li	s4,20
  if(fd < 0){
    49d0:	0a054063          	bltz	a0,4a70 <bigfile+0xe6>
    memset(buf, i, SZ);
    49d4:	25800613          	li	a2,600
    49d8:	85a6                	mv	a1,s1
    49da:	854a                	mv	a0,s2
    49dc:	00001097          	auipc	ra,0x1
    49e0:	8da080e7          	jalr	-1830(ra) # 52b6 <memset>
    if(write(fd, buf, SZ) != SZ){
    49e4:	25800613          	li	a2,600
    49e8:	85ca                	mv	a1,s2
    49ea:	854e                	mv	a0,s3
    49ec:	00001097          	auipc	ra,0x1
    49f0:	ae4080e7          	jalr	-1308(ra) # 54d0 <write>
    49f4:	25800793          	li	a5,600
    49f8:	08f51a63          	bne	a0,a5,4a8c <bigfile+0x102>
  for(i = 0; i < N; i++){
    49fc:	2485                	addw	s1,s1,1
    49fe:	fd449be3          	bne	s1,s4,49d4 <bigfile+0x4a>
  close(fd);
    4a02:	854e                	mv	a0,s3
    4a04:	00001097          	auipc	ra,0x1
    4a08:	ad4080e7          	jalr	-1324(ra) # 54d8 <close>
  fd = open("bigfile.dat", 0);
    4a0c:	4581                	li	a1,0
    4a0e:	00003517          	auipc	a0,0x3
    4a12:	d0a50513          	add	a0,a0,-758 # 7718 <malloc+0x1e48>
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	ada080e7          	jalr	-1318(ra) # 54f0 <open>
    4a1e:	8a2a                	mv	s4,a0
  total = 0;
    4a20:	4981                	li	s3,0
  for(i = 0; ; i++){
    4a22:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4a24:	00007917          	auipc	s2,0x7
    4a28:	f2c90913          	add	s2,s2,-212 # b950 <buf>
  if(fd < 0){
    4a2c:	06054e63          	bltz	a0,4aa8 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4a30:	12c00613          	li	a2,300
    4a34:	85ca                	mv	a1,s2
    4a36:	8552                	mv	a0,s4
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	a90080e7          	jalr	-1392(ra) # 54c8 <read>
    if(cc < 0){
    4a40:	08054263          	bltz	a0,4ac4 <bigfile+0x13a>
    if(cc == 0)
    4a44:	c971                	beqz	a0,4b18 <bigfile+0x18e>
    if(cc != SZ/2){
    4a46:	12c00793          	li	a5,300
    4a4a:	08f51b63          	bne	a0,a5,4ae0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4a4e:	01f4d79b          	srlw	a5,s1,0x1f
    4a52:	9fa5                	addw	a5,a5,s1
    4a54:	4017d79b          	sraw	a5,a5,0x1
    4a58:	00094703          	lbu	a4,0(s2)
    4a5c:	0af71063          	bne	a4,a5,4afc <bigfile+0x172>
    4a60:	12b94703          	lbu	a4,299(s2)
    4a64:	08f71c63          	bne	a4,a5,4afc <bigfile+0x172>
    total += cc;
    4a68:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4a6c:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4a6e:	b7c9                	j	4a30 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4a70:	85d6                	mv	a1,s5
    4a72:	00003517          	auipc	a0,0x3
    4a76:	cb650513          	add	a0,a0,-842 # 7728 <malloc+0x1e58>
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	d9e080e7          	jalr	-610(ra) # 5818 <printf>
    exit(1);
    4a82:	4505                	li	a0,1
    4a84:	00001097          	auipc	ra,0x1
    4a88:	a2c080e7          	jalr	-1492(ra) # 54b0 <exit>
      printf("%s: write bigfile failed\n", s);
    4a8c:	85d6                	mv	a1,s5
    4a8e:	00003517          	auipc	a0,0x3
    4a92:	cba50513          	add	a0,a0,-838 # 7748 <malloc+0x1e78>
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	d82080e7          	jalr	-638(ra) # 5818 <printf>
      exit(1);
    4a9e:	4505                	li	a0,1
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	a10080e7          	jalr	-1520(ra) # 54b0 <exit>
    printf("%s: cannot open bigfile\n", s);
    4aa8:	85d6                	mv	a1,s5
    4aaa:	00003517          	auipc	a0,0x3
    4aae:	cbe50513          	add	a0,a0,-834 # 7768 <malloc+0x1e98>
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	d66080e7          	jalr	-666(ra) # 5818 <printf>
    exit(1);
    4aba:	4505                	li	a0,1
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	9f4080e7          	jalr	-1548(ra) # 54b0 <exit>
      printf("%s: read bigfile failed\n", s);
    4ac4:	85d6                	mv	a1,s5
    4ac6:	00003517          	auipc	a0,0x3
    4aca:	cc250513          	add	a0,a0,-830 # 7788 <malloc+0x1eb8>
    4ace:	00001097          	auipc	ra,0x1
    4ad2:	d4a080e7          	jalr	-694(ra) # 5818 <printf>
      exit(1);
    4ad6:	4505                	li	a0,1
    4ad8:	00001097          	auipc	ra,0x1
    4adc:	9d8080e7          	jalr	-1576(ra) # 54b0 <exit>
      printf("%s: short read bigfile\n", s);
    4ae0:	85d6                	mv	a1,s5
    4ae2:	00003517          	auipc	a0,0x3
    4ae6:	cc650513          	add	a0,a0,-826 # 77a8 <malloc+0x1ed8>
    4aea:	00001097          	auipc	ra,0x1
    4aee:	d2e080e7          	jalr	-722(ra) # 5818 <printf>
      exit(1);
    4af2:	4505                	li	a0,1
    4af4:	00001097          	auipc	ra,0x1
    4af8:	9bc080e7          	jalr	-1604(ra) # 54b0 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4afc:	85d6                	mv	a1,s5
    4afe:	00003517          	auipc	a0,0x3
    4b02:	cc250513          	add	a0,a0,-830 # 77c0 <malloc+0x1ef0>
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	d12080e7          	jalr	-750(ra) # 5818 <printf>
      exit(1);
    4b0e:	4505                	li	a0,1
    4b10:	00001097          	auipc	ra,0x1
    4b14:	9a0080e7          	jalr	-1632(ra) # 54b0 <exit>
  close(fd);
    4b18:	8552                	mv	a0,s4
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	9be080e7          	jalr	-1602(ra) # 54d8 <close>
  if(total != N*SZ){
    4b22:	678d                	lui	a5,0x3
    4b24:	ee078793          	add	a5,a5,-288 # 2ee0 <dirtest+0x9c>
    4b28:	02f99363          	bne	s3,a5,4b4e <bigfile+0x1c4>
  unlink("bigfile.dat");
    4b2c:	00003517          	auipc	a0,0x3
    4b30:	bec50513          	add	a0,a0,-1044 # 7718 <malloc+0x1e48>
    4b34:	00001097          	auipc	ra,0x1
    4b38:	9cc080e7          	jalr	-1588(ra) # 5500 <unlink>
}
    4b3c:	70e2                	ld	ra,56(sp)
    4b3e:	7442                	ld	s0,48(sp)
    4b40:	74a2                	ld	s1,40(sp)
    4b42:	7902                	ld	s2,32(sp)
    4b44:	69e2                	ld	s3,24(sp)
    4b46:	6a42                	ld	s4,16(sp)
    4b48:	6aa2                	ld	s5,8(sp)
    4b4a:	6121                	add	sp,sp,64
    4b4c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4b4e:	85d6                	mv	a1,s5
    4b50:	00003517          	auipc	a0,0x3
    4b54:	c9050513          	add	a0,a0,-880 # 77e0 <malloc+0x1f10>
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	cc0080e7          	jalr	-832(ra) # 5818 <printf>
    exit(1);
    4b60:	4505                	li	a0,1
    4b62:	00001097          	auipc	ra,0x1
    4b66:	94e080e7          	jalr	-1714(ra) # 54b0 <exit>

0000000000004b6a <fsfull>:
{
    4b6a:	7135                	add	sp,sp,-160
    4b6c:	ed06                	sd	ra,152(sp)
    4b6e:	e922                	sd	s0,144(sp)
    4b70:	e526                	sd	s1,136(sp)
    4b72:	e14a                	sd	s2,128(sp)
    4b74:	fcce                	sd	s3,120(sp)
    4b76:	f8d2                	sd	s4,112(sp)
    4b78:	f4d6                	sd	s5,104(sp)
    4b7a:	f0da                	sd	s6,96(sp)
    4b7c:	ecde                	sd	s7,88(sp)
    4b7e:	e8e2                	sd	s8,80(sp)
    4b80:	e4e6                	sd	s9,72(sp)
    4b82:	e0ea                	sd	s10,64(sp)
    4b84:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    4b86:	00003517          	auipc	a0,0x3
    4b8a:	c7a50513          	add	a0,a0,-902 # 7800 <malloc+0x1f30>
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	c8a080e7          	jalr	-886(ra) # 5818 <printf>
  for(nfiles = 0; ; nfiles++){
    4b96:	4481                	li	s1,0
    name[0] = 'f';
    4b98:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4b9c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ba0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ba4:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4ba6:	00003c97          	auipc	s9,0x3
    4baa:	c6ac8c93          	add	s9,s9,-918 # 7810 <malloc+0x1f40>
    name[0] = 'f';
    4bae:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4bb2:	0384c7bb          	divw	a5,s1,s8
    4bb6:	0307879b          	addw	a5,a5,48
    4bba:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4bbe:	0384e7bb          	remw	a5,s1,s8
    4bc2:	0377c7bb          	divw	a5,a5,s7
    4bc6:	0307879b          	addw	a5,a5,48
    4bca:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4bce:	0374e7bb          	remw	a5,s1,s7
    4bd2:	0367c7bb          	divw	a5,a5,s6
    4bd6:	0307879b          	addw	a5,a5,48
    4bda:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4bde:	0364e7bb          	remw	a5,s1,s6
    4be2:	0307879b          	addw	a5,a5,48
    4be6:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4bea:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4bee:	f6040593          	add	a1,s0,-160
    4bf2:	8566                	mv	a0,s9
    4bf4:	00001097          	auipc	ra,0x1
    4bf8:	c24080e7          	jalr	-988(ra) # 5818 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4bfc:	20200593          	li	a1,514
    4c00:	f6040513          	add	a0,s0,-160
    4c04:	00001097          	auipc	ra,0x1
    4c08:	8ec080e7          	jalr	-1812(ra) # 54f0 <open>
    4c0c:	892a                	mv	s2,a0
    if(fd < 0){
    4c0e:	0a055563          	bgez	a0,4cb8 <fsfull+0x14e>
      printf("open %s failed\n", name);
    4c12:	f6040593          	add	a1,s0,-160
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	c0a50513          	add	a0,a0,-1014 # 7820 <malloc+0x1f50>
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	bfa080e7          	jalr	-1030(ra) # 5818 <printf>
  while(nfiles >= 0){
    4c26:	0604c363          	bltz	s1,4c8c <fsfull+0x122>
    name[0] = 'f';
    4c2a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4c2e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4c32:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4c36:	4929                	li	s2,10
  while(nfiles >= 0){
    4c38:	5afd                	li	s5,-1
    name[0] = 'f';
    4c3a:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4c3e:	0344c7bb          	divw	a5,s1,s4
    4c42:	0307879b          	addw	a5,a5,48
    4c46:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4c4a:	0344e7bb          	remw	a5,s1,s4
    4c4e:	0337c7bb          	divw	a5,a5,s3
    4c52:	0307879b          	addw	a5,a5,48
    4c56:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4c5a:	0334e7bb          	remw	a5,s1,s3
    4c5e:	0327c7bb          	divw	a5,a5,s2
    4c62:	0307879b          	addw	a5,a5,48
    4c66:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4c6a:	0324e7bb          	remw	a5,s1,s2
    4c6e:	0307879b          	addw	a5,a5,48
    4c72:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4c76:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4c7a:	f6040513          	add	a0,s0,-160
    4c7e:	00001097          	auipc	ra,0x1
    4c82:	882080e7          	jalr	-1918(ra) # 5500 <unlink>
    nfiles--;
    4c86:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    4c88:	fb5499e3          	bne	s1,s5,4c3a <fsfull+0xd0>
  printf("fsfull test finished\n");
    4c8c:	00003517          	auipc	a0,0x3
    4c90:	bb450513          	add	a0,a0,-1100 # 7840 <malloc+0x1f70>
    4c94:	00001097          	auipc	ra,0x1
    4c98:	b84080e7          	jalr	-1148(ra) # 5818 <printf>
}
    4c9c:	60ea                	ld	ra,152(sp)
    4c9e:	644a                	ld	s0,144(sp)
    4ca0:	64aa                	ld	s1,136(sp)
    4ca2:	690a                	ld	s2,128(sp)
    4ca4:	79e6                	ld	s3,120(sp)
    4ca6:	7a46                	ld	s4,112(sp)
    4ca8:	7aa6                	ld	s5,104(sp)
    4caa:	7b06                	ld	s6,96(sp)
    4cac:	6be6                	ld	s7,88(sp)
    4cae:	6c46                	ld	s8,80(sp)
    4cb0:	6ca6                	ld	s9,72(sp)
    4cb2:	6d06                	ld	s10,64(sp)
    4cb4:	610d                	add	sp,sp,160
    4cb6:	8082                	ret
    int total = 0;
    4cb8:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4cba:	00007a97          	auipc	s5,0x7
    4cbe:	c96a8a93          	add	s5,s5,-874 # b950 <buf>
      if(cc < BSIZE)
    4cc2:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4cc6:	40000613          	li	a2,1024
    4cca:	85d6                	mv	a1,s5
    4ccc:	854a                	mv	a0,s2
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	802080e7          	jalr	-2046(ra) # 54d0 <write>
      if(cc < BSIZE)
    4cd6:	00aa5563          	bge	s4,a0,4ce0 <fsfull+0x176>
      total += cc;
    4cda:	00a989bb          	addw	s3,s3,a0
    while(1){
    4cde:	b7e5                	j	4cc6 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    4ce0:	85ce                	mv	a1,s3
    4ce2:	00003517          	auipc	a0,0x3
    4ce6:	b4e50513          	add	a0,a0,-1202 # 7830 <malloc+0x1f60>
    4cea:	00001097          	auipc	ra,0x1
    4cee:	b2e080e7          	jalr	-1234(ra) # 5818 <printf>
    close(fd);
    4cf2:	854a                	mv	a0,s2
    4cf4:	00000097          	auipc	ra,0x0
    4cf8:	7e4080e7          	jalr	2020(ra) # 54d8 <close>
    if(total == 0)
    4cfc:	f20985e3          	beqz	s3,4c26 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    4d00:	2485                	addw	s1,s1,1
    4d02:	b575                	j	4bae <fsfull+0x44>

0000000000004d04 <rand>:
{
    4d04:	1141                	add	sp,sp,-16
    4d06:	e422                	sd	s0,8(sp)
    4d08:	0800                	add	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4d0a:	00003717          	auipc	a4,0x3
    4d0e:	41670713          	add	a4,a4,1046 # 8120 <randstate>
    4d12:	6308                	ld	a0,0(a4)
    4d14:	001967b7          	lui	a5,0x196
    4d18:	60d78793          	add	a5,a5,1549 # 19660d <__BSS_END__+0x187cad>
    4d1c:	02f50533          	mul	a0,a0,a5
    4d20:	3c6ef7b7          	lui	a5,0x3c6ef
    4d24:	35f78793          	add	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e09ff>
    4d28:	953e                	add	a0,a0,a5
    4d2a:	e308                	sd	a0,0(a4)
}
    4d2c:	2501                	sext.w	a0,a0
    4d2e:	6422                	ld	s0,8(sp)
    4d30:	0141                	add	sp,sp,16
    4d32:	8082                	ret

0000000000004d34 <badwrite>:
{
    4d34:	7179                	add	sp,sp,-48
    4d36:	f406                	sd	ra,40(sp)
    4d38:	f022                	sd	s0,32(sp)
    4d3a:	ec26                	sd	s1,24(sp)
    4d3c:	e84a                	sd	s2,16(sp)
    4d3e:	e44e                	sd	s3,8(sp)
    4d40:	e052                	sd	s4,0(sp)
    4d42:	1800                	add	s0,sp,48
  unlink("junk");
    4d44:	00003517          	auipc	a0,0x3
    4d48:	b1450513          	add	a0,a0,-1260 # 7858 <malloc+0x1f88>
    4d4c:	00000097          	auipc	ra,0x0
    4d50:	7b4080e7          	jalr	1972(ra) # 5500 <unlink>
    4d54:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d58:	00003997          	auipc	s3,0x3
    4d5c:	b0098993          	add	s3,s3,-1280 # 7858 <malloc+0x1f88>
    write(fd, (char*)0xffffffffffL, 1);
    4d60:	5a7d                	li	s4,-1
    4d62:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d66:	20100593          	li	a1,513
    4d6a:	854e                	mv	a0,s3
    4d6c:	00000097          	auipc	ra,0x0
    4d70:	784080e7          	jalr	1924(ra) # 54f0 <open>
    4d74:	84aa                	mv	s1,a0
    if(fd < 0){
    4d76:	06054b63          	bltz	a0,4dec <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4d7a:	4605                	li	a2,1
    4d7c:	85d2                	mv	a1,s4
    4d7e:	00000097          	auipc	ra,0x0
    4d82:	752080e7          	jalr	1874(ra) # 54d0 <write>
    close(fd);
    4d86:	8526                	mv	a0,s1
    4d88:	00000097          	auipc	ra,0x0
    4d8c:	750080e7          	jalr	1872(ra) # 54d8 <close>
    unlink("junk");
    4d90:	854e                	mv	a0,s3
    4d92:	00000097          	auipc	ra,0x0
    4d96:	76e080e7          	jalr	1902(ra) # 5500 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4d9a:	397d                	addw	s2,s2,-1
    4d9c:	fc0915e3          	bnez	s2,4d66 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4da0:	20100593          	li	a1,513
    4da4:	00003517          	auipc	a0,0x3
    4da8:	ab450513          	add	a0,a0,-1356 # 7858 <malloc+0x1f88>
    4dac:	00000097          	auipc	ra,0x0
    4db0:	744080e7          	jalr	1860(ra) # 54f0 <open>
    4db4:	84aa                	mv	s1,a0
  if(fd < 0){
    4db6:	04054863          	bltz	a0,4e06 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4dba:	4605                	li	a2,1
    4dbc:	00001597          	auipc	a1,0x1
    4dc0:	ca458593          	add	a1,a1,-860 # 5a60 <malloc+0x190>
    4dc4:	00000097          	auipc	ra,0x0
    4dc8:	70c080e7          	jalr	1804(ra) # 54d0 <write>
    4dcc:	4785                	li	a5,1
    4dce:	04f50963          	beq	a0,a5,4e20 <badwrite+0xec>
    printf("write failed\n");
    4dd2:	00003517          	auipc	a0,0x3
    4dd6:	aa650513          	add	a0,a0,-1370 # 7878 <malloc+0x1fa8>
    4dda:	00001097          	auipc	ra,0x1
    4dde:	a3e080e7          	jalr	-1474(ra) # 5818 <printf>
    exit(1);
    4de2:	4505                	li	a0,1
    4de4:	00000097          	auipc	ra,0x0
    4de8:	6cc080e7          	jalr	1740(ra) # 54b0 <exit>
      printf("open junk failed\n");
    4dec:	00003517          	auipc	a0,0x3
    4df0:	a7450513          	add	a0,a0,-1420 # 7860 <malloc+0x1f90>
    4df4:	00001097          	auipc	ra,0x1
    4df8:	a24080e7          	jalr	-1500(ra) # 5818 <printf>
      exit(1);
    4dfc:	4505                	li	a0,1
    4dfe:	00000097          	auipc	ra,0x0
    4e02:	6b2080e7          	jalr	1714(ra) # 54b0 <exit>
    printf("open junk failed\n");
    4e06:	00003517          	auipc	a0,0x3
    4e0a:	a5a50513          	add	a0,a0,-1446 # 7860 <malloc+0x1f90>
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	a0a080e7          	jalr	-1526(ra) # 5818 <printf>
    exit(1);
    4e16:	4505                	li	a0,1
    4e18:	00000097          	auipc	ra,0x0
    4e1c:	698080e7          	jalr	1688(ra) # 54b0 <exit>
  close(fd);
    4e20:	8526                	mv	a0,s1
    4e22:	00000097          	auipc	ra,0x0
    4e26:	6b6080e7          	jalr	1718(ra) # 54d8 <close>
  unlink("junk");
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	a2e50513          	add	a0,a0,-1490 # 7858 <malloc+0x1f88>
    4e32:	00000097          	auipc	ra,0x0
    4e36:	6ce080e7          	jalr	1742(ra) # 5500 <unlink>
  exit(0);
    4e3a:	4501                	li	a0,0
    4e3c:	00000097          	auipc	ra,0x0
    4e40:	674080e7          	jalr	1652(ra) # 54b0 <exit>

0000000000004e44 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4e44:	7139                	add	sp,sp,-64
    4e46:	fc06                	sd	ra,56(sp)
    4e48:	f822                	sd	s0,48(sp)
    4e4a:	f426                	sd	s1,40(sp)
    4e4c:	f04a                	sd	s2,32(sp)
    4e4e:	ec4e                	sd	s3,24(sp)
    4e50:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4e52:	fc840513          	add	a0,s0,-56
    4e56:	00000097          	auipc	ra,0x0
    4e5a:	66a080e7          	jalr	1642(ra) # 54c0 <pipe>
    4e5e:	06054763          	bltz	a0,4ecc <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4e62:	00000097          	auipc	ra,0x0
    4e66:	646080e7          	jalr	1606(ra) # 54a8 <fork>

  if(pid < 0){
    4e6a:	06054e63          	bltz	a0,4ee6 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4e6e:	ed51                	bnez	a0,4f0a <countfree+0xc6>
    close(fds[0]);
    4e70:	fc842503          	lw	a0,-56(s0)
    4e74:	00000097          	auipc	ra,0x0
    4e78:	664080e7          	jalr	1636(ra) # 54d8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4e7c:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4e7e:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4e80:	00001997          	auipc	s3,0x1
    4e84:	be098993          	add	s3,s3,-1056 # 5a60 <malloc+0x190>
      uint64 a = (uint64) sbrk(4096);
    4e88:	6505                	lui	a0,0x1
    4e8a:	00000097          	auipc	ra,0x0
    4e8e:	6ae080e7          	jalr	1710(ra) # 5538 <sbrk>
      if(a == 0xffffffffffffffff){
    4e92:	07250763          	beq	a0,s2,4f00 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4e96:	6785                	lui	a5,0x1
    4e98:	97aa                	add	a5,a5,a0
    4e9a:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x8b>
      if(write(fds[1], "x", 1) != 1){
    4e9e:	8626                	mv	a2,s1
    4ea0:	85ce                	mv	a1,s3
    4ea2:	fcc42503          	lw	a0,-52(s0)
    4ea6:	00000097          	auipc	ra,0x0
    4eaa:	62a080e7          	jalr	1578(ra) # 54d0 <write>
    4eae:	fc950de3          	beq	a0,s1,4e88 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4eb2:	00003517          	auipc	a0,0x3
    4eb6:	a1650513          	add	a0,a0,-1514 # 78c8 <malloc+0x1ff8>
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	95e080e7          	jalr	-1698(ra) # 5818 <printf>
        exit(1);
    4ec2:	4505                	li	a0,1
    4ec4:	00000097          	auipc	ra,0x0
    4ec8:	5ec080e7          	jalr	1516(ra) # 54b0 <exit>
    printf("pipe() failed in countfree()\n");
    4ecc:	00003517          	auipc	a0,0x3
    4ed0:	9bc50513          	add	a0,a0,-1604 # 7888 <malloc+0x1fb8>
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	944080e7          	jalr	-1724(ra) # 5818 <printf>
    exit(1);
    4edc:	4505                	li	a0,1
    4ede:	00000097          	auipc	ra,0x0
    4ee2:	5d2080e7          	jalr	1490(ra) # 54b0 <exit>
    printf("fork failed in countfree()\n");
    4ee6:	00003517          	auipc	a0,0x3
    4eea:	9c250513          	add	a0,a0,-1598 # 78a8 <malloc+0x1fd8>
    4eee:	00001097          	auipc	ra,0x1
    4ef2:	92a080e7          	jalr	-1750(ra) # 5818 <printf>
    exit(1);
    4ef6:	4505                	li	a0,1
    4ef8:	00000097          	auipc	ra,0x0
    4efc:	5b8080e7          	jalr	1464(ra) # 54b0 <exit>
      }
    }

    exit(0);
    4f00:	4501                	li	a0,0
    4f02:	00000097          	auipc	ra,0x0
    4f06:	5ae080e7          	jalr	1454(ra) # 54b0 <exit>
  }

  close(fds[1]);
    4f0a:	fcc42503          	lw	a0,-52(s0)
    4f0e:	00000097          	auipc	ra,0x0
    4f12:	5ca080e7          	jalr	1482(ra) # 54d8 <close>

  int n = 0;
    4f16:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4f18:	4605                	li	a2,1
    4f1a:	fc740593          	add	a1,s0,-57
    4f1e:	fc842503          	lw	a0,-56(s0)
    4f22:	00000097          	auipc	ra,0x0
    4f26:	5a6080e7          	jalr	1446(ra) # 54c8 <read>
    if(cc < 0){
    4f2a:	00054563          	bltz	a0,4f34 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4f2e:	c105                	beqz	a0,4f4e <countfree+0x10a>
      break;
    n += 1;
    4f30:	2485                	addw	s1,s1,1
  while(1){
    4f32:	b7dd                	j	4f18 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4f34:	00003517          	auipc	a0,0x3
    4f38:	9b450513          	add	a0,a0,-1612 # 78e8 <malloc+0x2018>
    4f3c:	00001097          	auipc	ra,0x1
    4f40:	8dc080e7          	jalr	-1828(ra) # 5818 <printf>
      exit(1);
    4f44:	4505                	li	a0,1
    4f46:	00000097          	auipc	ra,0x0
    4f4a:	56a080e7          	jalr	1386(ra) # 54b0 <exit>
  }

  close(fds[0]);
    4f4e:	fc842503          	lw	a0,-56(s0)
    4f52:	00000097          	auipc	ra,0x0
    4f56:	586080e7          	jalr	1414(ra) # 54d8 <close>
  wait((int*)0);
    4f5a:	4501                	li	a0,0
    4f5c:	00000097          	auipc	ra,0x0
    4f60:	55c080e7          	jalr	1372(ra) # 54b8 <wait>
  
  return n;
}
    4f64:	8526                	mv	a0,s1
    4f66:	70e2                	ld	ra,56(sp)
    4f68:	7442                	ld	s0,48(sp)
    4f6a:	74a2                	ld	s1,40(sp)
    4f6c:	7902                	ld	s2,32(sp)
    4f6e:	69e2                	ld	s3,24(sp)
    4f70:	6121                	add	sp,sp,64
    4f72:	8082                	ret

0000000000004f74 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4f74:	7179                	add	sp,sp,-48
    4f76:	f406                	sd	ra,40(sp)
    4f78:	f022                	sd	s0,32(sp)
    4f7a:	ec26                	sd	s1,24(sp)
    4f7c:	e84a                	sd	s2,16(sp)
    4f7e:	1800                	add	s0,sp,48
    4f80:	84aa                	mv	s1,a0
    4f82:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4f84:	00003517          	auipc	a0,0x3
    4f88:	98450513          	add	a0,a0,-1660 # 7908 <malloc+0x2038>
    4f8c:	00001097          	auipc	ra,0x1
    4f90:	88c080e7          	jalr	-1908(ra) # 5818 <printf>
  if((pid = fork()) < 0) {
    4f94:	00000097          	auipc	ra,0x0
    4f98:	514080e7          	jalr	1300(ra) # 54a8 <fork>
    4f9c:	02054e63          	bltz	a0,4fd8 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4fa0:	c929                	beqz	a0,4ff2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4fa2:	fdc40513          	add	a0,s0,-36
    4fa6:	00000097          	auipc	ra,0x0
    4faa:	512080e7          	jalr	1298(ra) # 54b8 <wait>
    if(xstatus != 0) 
    4fae:	fdc42783          	lw	a5,-36(s0)
    4fb2:	c7b9                	beqz	a5,5000 <run+0x8c>
      printf("FAILED\n");
    4fb4:	00003517          	auipc	a0,0x3
    4fb8:	97c50513          	add	a0,a0,-1668 # 7930 <malloc+0x2060>
    4fbc:	00001097          	auipc	ra,0x1
    4fc0:	85c080e7          	jalr	-1956(ra) # 5818 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4fc4:	fdc42503          	lw	a0,-36(s0)
  }
}
    4fc8:	00153513          	seqz	a0,a0
    4fcc:	70a2                	ld	ra,40(sp)
    4fce:	7402                	ld	s0,32(sp)
    4fd0:	64e2                	ld	s1,24(sp)
    4fd2:	6942                	ld	s2,16(sp)
    4fd4:	6145                	add	sp,sp,48
    4fd6:	8082                	ret
    printf("runtest: fork error\n");
    4fd8:	00003517          	auipc	a0,0x3
    4fdc:	94050513          	add	a0,a0,-1728 # 7918 <malloc+0x2048>
    4fe0:	00001097          	auipc	ra,0x1
    4fe4:	838080e7          	jalr	-1992(ra) # 5818 <printf>
    exit(1);
    4fe8:	4505                	li	a0,1
    4fea:	00000097          	auipc	ra,0x0
    4fee:	4c6080e7          	jalr	1222(ra) # 54b0 <exit>
    f(s);
    4ff2:	854a                	mv	a0,s2
    4ff4:	9482                	jalr	s1
    exit(0);
    4ff6:	4501                	li	a0,0
    4ff8:	00000097          	auipc	ra,0x0
    4ffc:	4b8080e7          	jalr	1208(ra) # 54b0 <exit>
      printf("OK\n");
    5000:	00003517          	auipc	a0,0x3
    5004:	93850513          	add	a0,a0,-1736 # 7938 <malloc+0x2068>
    5008:	00001097          	auipc	ra,0x1
    500c:	810080e7          	jalr	-2032(ra) # 5818 <printf>
    5010:	bf55                	j	4fc4 <run+0x50>

0000000000005012 <main>:

int
main(int argc, char *argv[])
{
    5012:	c2010113          	add	sp,sp,-992
    5016:	3c113c23          	sd	ra,984(sp)
    501a:	3c813823          	sd	s0,976(sp)
    501e:	3c913423          	sd	s1,968(sp)
    5022:	3d213023          	sd	s2,960(sp)
    5026:	3b313c23          	sd	s3,952(sp)
    502a:	3b413823          	sd	s4,944(sp)
    502e:	3b513423          	sd	s5,936(sp)
    5032:	3b613023          	sd	s6,928(sp)
    5036:	1780                	add	s0,sp,992
    5038:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    503a:	4789                	li	a5,2
    503c:	08f50863          	beq	a0,a5,50cc <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5040:	4785                	li	a5,1
    5042:	10a7cd63          	blt	a5,a0,515c <main+0x14a>
  char *justone = 0;
    5046:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5048:	00003797          	auipc	a5,0x3
    504c:	cb878793          	add	a5,a5,-840 # 7d00 <malloc+0x2430>
    5050:	c2040713          	add	a4,s0,-992
    5054:	00003817          	auipc	a6,0x3
    5058:	04c80813          	add	a6,a6,76 # 80a0 <malloc+0x27d0>
    505c:	6388                	ld	a0,0(a5)
    505e:	678c                	ld	a1,8(a5)
    5060:	6b90                	ld	a2,16(a5)
    5062:	6f94                	ld	a3,24(a5)
    5064:	e308                	sd	a0,0(a4)
    5066:	e70c                	sd	a1,8(a4)
    5068:	eb10                	sd	a2,16(a4)
    506a:	ef14                	sd	a3,24(a4)
    506c:	02078793          	add	a5,a5,32
    5070:	02070713          	add	a4,a4,32
    5074:	ff0794e3          	bne	a5,a6,505c <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5078:	00003517          	auipc	a0,0x3
    507c:	98050513          	add	a0,a0,-1664 # 79f8 <malloc+0x2128>
    5080:	00000097          	auipc	ra,0x0
    5084:	798080e7          	jalr	1944(ra) # 5818 <printf>
  int free0 = countfree();
    5088:	00000097          	auipc	ra,0x0
    508c:	dbc080e7          	jalr	-580(ra) # 4e44 <countfree>
    5090:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5092:	c2843903          	ld	s2,-984(s0)
    5096:	c2040493          	add	s1,s0,-992
  int fail = 0;
    509a:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    509c:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    509e:	10091463          	bnez	s2,51a6 <main+0x194>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    50a2:	00000097          	auipc	ra,0x0
    50a6:	da2080e7          	jalr	-606(ra) # 4e44 <countfree>
    50aa:	85aa                	mv	a1,a0
    50ac:	13555e63          	bge	a0,s5,51e8 <main+0x1d6>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    50b0:	8656                	mv	a2,s5
    50b2:	00003517          	auipc	a0,0x3
    50b6:	8fe50513          	add	a0,a0,-1794 # 79b0 <malloc+0x20e0>
    50ba:	00000097          	auipc	ra,0x0
    50be:	75e080e7          	jalr	1886(ra) # 5818 <printf>
    exit(1);
    50c2:	4505                	li	a0,1
    50c4:	00000097          	auipc	ra,0x0
    50c8:	3ec080e7          	jalr	1004(ra) # 54b0 <exit>
    50cc:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    50ce:	00003597          	auipc	a1,0x3
    50d2:	87258593          	add	a1,a1,-1934 # 7940 <malloc+0x2070>
    50d6:	6488                	ld	a0,8(s1)
    50d8:	00000097          	auipc	ra,0x0
    50dc:	188080e7          	jalr	392(ra) # 5260 <strcmp>
    50e0:	ed21                	bnez	a0,5138 <main+0x126>
    continuous = 1;
    50e2:	4985                	li	s3,1
  } tests[] = {
    50e4:	00003797          	auipc	a5,0x3
    50e8:	c1c78793          	add	a5,a5,-996 # 7d00 <malloc+0x2430>
    50ec:	c2040713          	add	a4,s0,-992
    50f0:	00003817          	auipc	a6,0x3
    50f4:	fb080813          	add	a6,a6,-80 # 80a0 <malloc+0x27d0>
    50f8:	6388                	ld	a0,0(a5)
    50fa:	678c                	ld	a1,8(a5)
    50fc:	6b90                	ld	a2,16(a5)
    50fe:	6f94                	ld	a3,24(a5)
    5100:	e308                	sd	a0,0(a4)
    5102:	e70c                	sd	a1,8(a4)
    5104:	eb10                	sd	a2,16(a4)
    5106:	ef14                	sd	a3,24(a4)
    5108:	02078793          	add	a5,a5,32
    510c:	02070713          	add	a4,a4,32
    5110:	ff0794e3          	bne	a5,a6,50f8 <main+0xe6>
    printf("continuous usertests starting\n");
    5114:	00003517          	auipc	a0,0x3
    5118:	8fc50513          	add	a0,a0,-1796 # 7a10 <malloc+0x2140>
    511c:	00000097          	auipc	ra,0x0
    5120:	6fc080e7          	jalr	1788(ra) # 5818 <printf>
        printf("SOME TESTS FAILED\n");
    5124:	00003a97          	auipc	s5,0x3
    5128:	874a8a93          	add	s5,s5,-1932 # 7998 <malloc+0x20c8>
        if(continuous != 2)
    512c:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    512e:	00003b17          	auipc	s6,0x3
    5132:	84ab0b13          	add	s6,s6,-1974 # 7978 <malloc+0x20a8>
    5136:	a0dd                	j	521c <main+0x20a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5138:	00003597          	auipc	a1,0x3
    513c:	81058593          	add	a1,a1,-2032 # 7948 <malloc+0x2078>
    5140:	6488                	ld	a0,8(s1)
    5142:	00000097          	auipc	ra,0x0
    5146:	11e080e7          	jalr	286(ra) # 5260 <strcmp>
    514a:	dd49                	beqz	a0,50e4 <main+0xd2>
  } else if(argc == 2 && argv[1][0] != '-'){
    514c:	0084b983          	ld	s3,8(s1)
    5150:	0009c703          	lbu	a4,0(s3)
    5154:	02d00793          	li	a5,45
    5158:	eef718e3          	bne	a4,a5,5048 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    515c:	00002517          	auipc	a0,0x2
    5160:	7f450513          	add	a0,a0,2036 # 7950 <malloc+0x2080>
    5164:	00000097          	auipc	ra,0x0
    5168:	6b4080e7          	jalr	1716(ra) # 5818 <printf>
    exit(1);
    516c:	4505                	li	a0,1
    516e:	00000097          	auipc	ra,0x0
    5172:	342080e7          	jalr	834(ra) # 54b0 <exit>
          exit(1);
    5176:	4505                	li	a0,1
    5178:	00000097          	auipc	ra,0x0
    517c:	338080e7          	jalr	824(ra) # 54b0 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5180:	40a905bb          	subw	a1,s2,a0
    5184:	855a                	mv	a0,s6
    5186:	00000097          	auipc	ra,0x0
    518a:	692080e7          	jalr	1682(ra) # 5818 <printf>
        if(continuous != 2)
    518e:	09498763          	beq	s3,s4,521c <main+0x20a>
          exit(1);
    5192:	4505                	li	a0,1
    5194:	00000097          	auipc	ra,0x0
    5198:	31c080e7          	jalr	796(ra) # 54b0 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    519c:	04c1                	add	s1,s1,16
    519e:	0084b903          	ld	s2,8(s1)
    51a2:	02090463          	beqz	s2,51ca <main+0x1b8>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    51a6:	00098963          	beqz	s3,51b8 <main+0x1a6>
    51aa:	85ce                	mv	a1,s3
    51ac:	854a                	mv	a0,s2
    51ae:	00000097          	auipc	ra,0x0
    51b2:	0b2080e7          	jalr	178(ra) # 5260 <strcmp>
    51b6:	f17d                	bnez	a0,519c <main+0x18a>
      if(!run(t->f, t->s))
    51b8:	85ca                	mv	a1,s2
    51ba:	6088                	ld	a0,0(s1)
    51bc:	00000097          	auipc	ra,0x0
    51c0:	db8080e7          	jalr	-584(ra) # 4f74 <run>
    51c4:	fd61                	bnez	a0,519c <main+0x18a>
        fail = 1;
    51c6:	8a5a                	mv	s4,s6
    51c8:	bfd1                	j	519c <main+0x18a>
  if(fail){
    51ca:	ec0a0ce3          	beqz	s4,50a2 <main+0x90>
    printf("SOME TESTS FAILED\n");
    51ce:	00002517          	auipc	a0,0x2
    51d2:	7ca50513          	add	a0,a0,1994 # 7998 <malloc+0x20c8>
    51d6:	00000097          	auipc	ra,0x0
    51da:	642080e7          	jalr	1602(ra) # 5818 <printf>
    exit(1);
    51de:	4505                	li	a0,1
    51e0:	00000097          	auipc	ra,0x0
    51e4:	2d0080e7          	jalr	720(ra) # 54b0 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    51e8:	00002517          	auipc	a0,0x2
    51ec:	7f850513          	add	a0,a0,2040 # 79e0 <malloc+0x2110>
    51f0:	00000097          	auipc	ra,0x0
    51f4:	628080e7          	jalr	1576(ra) # 5818 <printf>
    exit(0);
    51f8:	4501                	li	a0,0
    51fa:	00000097          	auipc	ra,0x0
    51fe:	2b6080e7          	jalr	694(ra) # 54b0 <exit>
        printf("SOME TESTS FAILED\n");
    5202:	8556                	mv	a0,s5
    5204:	00000097          	auipc	ra,0x0
    5208:	614080e7          	jalr	1556(ra) # 5818 <printf>
        if(continuous != 2)
    520c:	f74995e3          	bne	s3,s4,5176 <main+0x164>
      int free1 = countfree();
    5210:	00000097          	auipc	ra,0x0
    5214:	c34080e7          	jalr	-972(ra) # 4e44 <countfree>
      if(free1 < free0){
    5218:	f72544e3          	blt	a0,s2,5180 <main+0x16e>
      int free0 = countfree();
    521c:	00000097          	auipc	ra,0x0
    5220:	c28080e7          	jalr	-984(ra) # 4e44 <countfree>
    5224:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5226:	c2843583          	ld	a1,-984(s0)
    522a:	d1fd                	beqz	a1,5210 <main+0x1fe>
    522c:	c2040493          	add	s1,s0,-992
        if(!run(t->f, t->s)){
    5230:	6088                	ld	a0,0(s1)
    5232:	00000097          	auipc	ra,0x0
    5236:	d42080e7          	jalr	-702(ra) # 4f74 <run>
    523a:	d561                	beqz	a0,5202 <main+0x1f0>
      for (struct test *t = tests; t->s != 0; t++) {
    523c:	04c1                	add	s1,s1,16
    523e:	648c                	ld	a1,8(s1)
    5240:	f9e5                	bnez	a1,5230 <main+0x21e>
    5242:	b7f9                	j	5210 <main+0x1fe>

0000000000005244 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5244:	1141                	add	sp,sp,-16
    5246:	e422                	sd	s0,8(sp)
    5248:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    524a:	87aa                	mv	a5,a0
    524c:	0585                	add	a1,a1,1
    524e:	0785                	add	a5,a5,1
    5250:	fff5c703          	lbu	a4,-1(a1)
    5254:	fee78fa3          	sb	a4,-1(a5)
    5258:	fb75                	bnez	a4,524c <strcpy+0x8>
    ;
  return os;
}
    525a:	6422                	ld	s0,8(sp)
    525c:	0141                	add	sp,sp,16
    525e:	8082                	ret

0000000000005260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5260:	1141                	add	sp,sp,-16
    5262:	e422                	sd	s0,8(sp)
    5264:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5266:	00054783          	lbu	a5,0(a0)
    526a:	cb91                	beqz	a5,527e <strcmp+0x1e>
    526c:	0005c703          	lbu	a4,0(a1)
    5270:	00f71763          	bne	a4,a5,527e <strcmp+0x1e>
    p++, q++;
    5274:	0505                	add	a0,a0,1
    5276:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5278:	00054783          	lbu	a5,0(a0)
    527c:	fbe5                	bnez	a5,526c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    527e:	0005c503          	lbu	a0,0(a1)
}
    5282:	40a7853b          	subw	a0,a5,a0
    5286:	6422                	ld	s0,8(sp)
    5288:	0141                	add	sp,sp,16
    528a:	8082                	ret

000000000000528c <strlen>:

uint
strlen(const char *s)
{
    528c:	1141                	add	sp,sp,-16
    528e:	e422                	sd	s0,8(sp)
    5290:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5292:	00054783          	lbu	a5,0(a0)
    5296:	cf91                	beqz	a5,52b2 <strlen+0x26>
    5298:	0505                	add	a0,a0,1
    529a:	87aa                	mv	a5,a0
    529c:	86be                	mv	a3,a5
    529e:	0785                	add	a5,a5,1
    52a0:	fff7c703          	lbu	a4,-1(a5)
    52a4:	ff65                	bnez	a4,529c <strlen+0x10>
    52a6:	40a6853b          	subw	a0,a3,a0
    52aa:	2505                	addw	a0,a0,1
    ;
  return n;
}
    52ac:	6422                	ld	s0,8(sp)
    52ae:	0141                	add	sp,sp,16
    52b0:	8082                	ret
  for(n = 0; s[n]; n++)
    52b2:	4501                	li	a0,0
    52b4:	bfe5                	j	52ac <strlen+0x20>

00000000000052b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    52b6:	1141                	add	sp,sp,-16
    52b8:	e422                	sd	s0,8(sp)
    52ba:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    52bc:	ca19                	beqz	a2,52d2 <memset+0x1c>
    52be:	87aa                	mv	a5,a0
    52c0:	1602                	sll	a2,a2,0x20
    52c2:	9201                	srl	a2,a2,0x20
    52c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    52c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    52cc:	0785                	add	a5,a5,1
    52ce:	fee79de3          	bne	a5,a4,52c8 <memset+0x12>
  }
  return dst;
}
    52d2:	6422                	ld	s0,8(sp)
    52d4:	0141                	add	sp,sp,16
    52d6:	8082                	ret

00000000000052d8 <strchr>:

char*
strchr(const char *s, char c)
{
    52d8:	1141                	add	sp,sp,-16
    52da:	e422                	sd	s0,8(sp)
    52dc:	0800                	add	s0,sp,16
  for(; *s; s++)
    52de:	00054783          	lbu	a5,0(a0)
    52e2:	cb99                	beqz	a5,52f8 <strchr+0x20>
    if(*s == c)
    52e4:	00f58763          	beq	a1,a5,52f2 <strchr+0x1a>
  for(; *s; s++)
    52e8:	0505                	add	a0,a0,1
    52ea:	00054783          	lbu	a5,0(a0)
    52ee:	fbfd                	bnez	a5,52e4 <strchr+0xc>
      return (char*)s;
  return 0;
    52f0:	4501                	li	a0,0
}
    52f2:	6422                	ld	s0,8(sp)
    52f4:	0141                	add	sp,sp,16
    52f6:	8082                	ret
  return 0;
    52f8:	4501                	li	a0,0
    52fa:	bfe5                	j	52f2 <strchr+0x1a>

00000000000052fc <gets>:

char*
gets(char *buf, int max)
{
    52fc:	711d                	add	sp,sp,-96
    52fe:	ec86                	sd	ra,88(sp)
    5300:	e8a2                	sd	s0,80(sp)
    5302:	e4a6                	sd	s1,72(sp)
    5304:	e0ca                	sd	s2,64(sp)
    5306:	fc4e                	sd	s3,56(sp)
    5308:	f852                	sd	s4,48(sp)
    530a:	f456                	sd	s5,40(sp)
    530c:	f05a                	sd	s6,32(sp)
    530e:	ec5e                	sd	s7,24(sp)
    5310:	1080                	add	s0,sp,96
    5312:	8baa                	mv	s7,a0
    5314:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5316:	892a                	mv	s2,a0
    5318:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    531a:	4aa9                	li	s5,10
    531c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    531e:	89a6                	mv	s3,s1
    5320:	2485                	addw	s1,s1,1
    5322:	0344d863          	bge	s1,s4,5352 <gets+0x56>
    cc = read(0, &c, 1);
    5326:	4605                	li	a2,1
    5328:	faf40593          	add	a1,s0,-81
    532c:	4501                	li	a0,0
    532e:	00000097          	auipc	ra,0x0
    5332:	19a080e7          	jalr	410(ra) # 54c8 <read>
    if(cc < 1)
    5336:	00a05e63          	blez	a0,5352 <gets+0x56>
    buf[i++] = c;
    533a:	faf44783          	lbu	a5,-81(s0)
    533e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5342:	01578763          	beq	a5,s5,5350 <gets+0x54>
    5346:	0905                	add	s2,s2,1
    5348:	fd679be3          	bne	a5,s6,531e <gets+0x22>
  for(i=0; i+1 < max; ){
    534c:	89a6                	mv	s3,s1
    534e:	a011                	j	5352 <gets+0x56>
    5350:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5352:	99de                	add	s3,s3,s7
    5354:	00098023          	sb	zero,0(s3)
  return buf;
}
    5358:	855e                	mv	a0,s7
    535a:	60e6                	ld	ra,88(sp)
    535c:	6446                	ld	s0,80(sp)
    535e:	64a6                	ld	s1,72(sp)
    5360:	6906                	ld	s2,64(sp)
    5362:	79e2                	ld	s3,56(sp)
    5364:	7a42                	ld	s4,48(sp)
    5366:	7aa2                	ld	s5,40(sp)
    5368:	7b02                	ld	s6,32(sp)
    536a:	6be2                	ld	s7,24(sp)
    536c:	6125                	add	sp,sp,96
    536e:	8082                	ret

0000000000005370 <stat>:

int
stat(const char *n, struct stat *st)
{
    5370:	1101                	add	sp,sp,-32
    5372:	ec06                	sd	ra,24(sp)
    5374:	e822                	sd	s0,16(sp)
    5376:	e426                	sd	s1,8(sp)
    5378:	e04a                	sd	s2,0(sp)
    537a:	1000                	add	s0,sp,32
    537c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    537e:	4581                	li	a1,0
    5380:	00000097          	auipc	ra,0x0
    5384:	170080e7          	jalr	368(ra) # 54f0 <open>
  if(fd < 0)
    5388:	02054563          	bltz	a0,53b2 <stat+0x42>
    538c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    538e:	85ca                	mv	a1,s2
    5390:	00000097          	auipc	ra,0x0
    5394:	178080e7          	jalr	376(ra) # 5508 <fstat>
    5398:	892a                	mv	s2,a0
  close(fd);
    539a:	8526                	mv	a0,s1
    539c:	00000097          	auipc	ra,0x0
    53a0:	13c080e7          	jalr	316(ra) # 54d8 <close>
  return r;
}
    53a4:	854a                	mv	a0,s2
    53a6:	60e2                	ld	ra,24(sp)
    53a8:	6442                	ld	s0,16(sp)
    53aa:	64a2                	ld	s1,8(sp)
    53ac:	6902                	ld	s2,0(sp)
    53ae:	6105                	add	sp,sp,32
    53b0:	8082                	ret
    return -1;
    53b2:	597d                	li	s2,-1
    53b4:	bfc5                	j	53a4 <stat+0x34>

00000000000053b6 <atoi>:

int
atoi(const char *s)
{
    53b6:	1141                	add	sp,sp,-16
    53b8:	e422                	sd	s0,8(sp)
    53ba:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    53bc:	00054683          	lbu	a3,0(a0)
    53c0:	fd06879b          	addw	a5,a3,-48
    53c4:	0ff7f793          	zext.b	a5,a5
    53c8:	4625                	li	a2,9
    53ca:	02f66863          	bltu	a2,a5,53fa <atoi+0x44>
    53ce:	872a                	mv	a4,a0
  n = 0;
    53d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    53d2:	0705                	add	a4,a4,1
    53d4:	0025179b          	sllw	a5,a0,0x2
    53d8:	9fa9                	addw	a5,a5,a0
    53da:	0017979b          	sllw	a5,a5,0x1
    53de:	9fb5                	addw	a5,a5,a3
    53e0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    53e4:	00074683          	lbu	a3,0(a4)
    53e8:	fd06879b          	addw	a5,a3,-48
    53ec:	0ff7f793          	zext.b	a5,a5
    53f0:	fef671e3          	bgeu	a2,a5,53d2 <atoi+0x1c>
  return n;
}
    53f4:	6422                	ld	s0,8(sp)
    53f6:	0141                	add	sp,sp,16
    53f8:	8082                	ret
  n = 0;
    53fa:	4501                	li	a0,0
    53fc:	bfe5                	j	53f4 <atoi+0x3e>

00000000000053fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    53fe:	1141                	add	sp,sp,-16
    5400:	e422                	sd	s0,8(sp)
    5402:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5404:	02b57463          	bgeu	a0,a1,542c <memmove+0x2e>
    while(n-- > 0)
    5408:	00c05f63          	blez	a2,5426 <memmove+0x28>
    540c:	1602                	sll	a2,a2,0x20
    540e:	9201                	srl	a2,a2,0x20
    5410:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5414:	872a                	mv	a4,a0
      *dst++ = *src++;
    5416:	0585                	add	a1,a1,1
    5418:	0705                	add	a4,a4,1
    541a:	fff5c683          	lbu	a3,-1(a1)
    541e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5422:	fee79ae3          	bne	a5,a4,5416 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5426:	6422                	ld	s0,8(sp)
    5428:	0141                	add	sp,sp,16
    542a:	8082                	ret
    dst += n;
    542c:	00c50733          	add	a4,a0,a2
    src += n;
    5430:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5432:	fec05ae3          	blez	a2,5426 <memmove+0x28>
    5436:	fff6079b          	addw	a5,a2,-1 # 2fff <subdir+0xe5>
    543a:	1782                	sll	a5,a5,0x20
    543c:	9381                	srl	a5,a5,0x20
    543e:	fff7c793          	not	a5,a5
    5442:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5444:	15fd                	add	a1,a1,-1
    5446:	177d                	add	a4,a4,-1
    5448:	0005c683          	lbu	a3,0(a1)
    544c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5450:	fee79ae3          	bne	a5,a4,5444 <memmove+0x46>
    5454:	bfc9                	j	5426 <memmove+0x28>

0000000000005456 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5456:	1141                	add	sp,sp,-16
    5458:	e422                	sd	s0,8(sp)
    545a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    545c:	ca05                	beqz	a2,548c <memcmp+0x36>
    545e:	fff6069b          	addw	a3,a2,-1
    5462:	1682                	sll	a3,a3,0x20
    5464:	9281                	srl	a3,a3,0x20
    5466:	0685                	add	a3,a3,1
    5468:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    546a:	00054783          	lbu	a5,0(a0)
    546e:	0005c703          	lbu	a4,0(a1)
    5472:	00e79863          	bne	a5,a4,5482 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5476:	0505                	add	a0,a0,1
    p2++;
    5478:	0585                	add	a1,a1,1
  while (n-- > 0) {
    547a:	fed518e3          	bne	a0,a3,546a <memcmp+0x14>
  }
  return 0;
    547e:	4501                	li	a0,0
    5480:	a019                	j	5486 <memcmp+0x30>
      return *p1 - *p2;
    5482:	40e7853b          	subw	a0,a5,a4
}
    5486:	6422                	ld	s0,8(sp)
    5488:	0141                	add	sp,sp,16
    548a:	8082                	ret
  return 0;
    548c:	4501                	li	a0,0
    548e:	bfe5                	j	5486 <memcmp+0x30>

0000000000005490 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5490:	1141                	add	sp,sp,-16
    5492:	e406                	sd	ra,8(sp)
    5494:	e022                	sd	s0,0(sp)
    5496:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5498:	00000097          	auipc	ra,0x0
    549c:	f66080e7          	jalr	-154(ra) # 53fe <memmove>
}
    54a0:	60a2                	ld	ra,8(sp)
    54a2:	6402                	ld	s0,0(sp)
    54a4:	0141                	add	sp,sp,16
    54a6:	8082                	ret

00000000000054a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    54a8:	4885                	li	a7,1
 ecall
    54aa:	00000073          	ecall
 ret
    54ae:	8082                	ret

00000000000054b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    54b0:	4889                	li	a7,2
 ecall
    54b2:	00000073          	ecall
 ret
    54b6:	8082                	ret

00000000000054b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    54b8:	488d                	li	a7,3
 ecall
    54ba:	00000073          	ecall
 ret
    54be:	8082                	ret

00000000000054c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    54c0:	4891                	li	a7,4
 ecall
    54c2:	00000073          	ecall
 ret
    54c6:	8082                	ret

00000000000054c8 <read>:
.global read
read:
 li a7, SYS_read
    54c8:	4895                	li	a7,5
 ecall
    54ca:	00000073          	ecall
 ret
    54ce:	8082                	ret

00000000000054d0 <write>:
.global write
write:
 li a7, SYS_write
    54d0:	48c1                	li	a7,16
 ecall
    54d2:	00000073          	ecall
 ret
    54d6:	8082                	ret

00000000000054d8 <close>:
.global close
close:
 li a7, SYS_close
    54d8:	48d5                	li	a7,21
 ecall
    54da:	00000073          	ecall
 ret
    54de:	8082                	ret

00000000000054e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    54e0:	4899                	li	a7,6
 ecall
    54e2:	00000073          	ecall
 ret
    54e6:	8082                	ret

00000000000054e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    54e8:	489d                	li	a7,7
 ecall
    54ea:	00000073          	ecall
 ret
    54ee:	8082                	ret

00000000000054f0 <open>:
.global open
open:
 li a7, SYS_open
    54f0:	48bd                	li	a7,15
 ecall
    54f2:	00000073          	ecall
 ret
    54f6:	8082                	ret

00000000000054f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    54f8:	48c5                	li	a7,17
 ecall
    54fa:	00000073          	ecall
 ret
    54fe:	8082                	ret

0000000000005500 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5500:	48c9                	li	a7,18
 ecall
    5502:	00000073          	ecall
 ret
    5506:	8082                	ret

0000000000005508 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5508:	48a1                	li	a7,8
 ecall
    550a:	00000073          	ecall
 ret
    550e:	8082                	ret

0000000000005510 <link>:
.global link
link:
 li a7, SYS_link
    5510:	48cd                	li	a7,19
 ecall
    5512:	00000073          	ecall
 ret
    5516:	8082                	ret

0000000000005518 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5518:	48d1                	li	a7,20
 ecall
    551a:	00000073          	ecall
 ret
    551e:	8082                	ret

0000000000005520 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5520:	48a5                	li	a7,9
 ecall
    5522:	00000073          	ecall
 ret
    5526:	8082                	ret

0000000000005528 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5528:	48a9                	li	a7,10
 ecall
    552a:	00000073          	ecall
 ret
    552e:	8082                	ret

0000000000005530 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5530:	48ad                	li	a7,11
 ecall
    5532:	00000073          	ecall
 ret
    5536:	8082                	ret

0000000000005538 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5538:	48b1                	li	a7,12
 ecall
    553a:	00000073          	ecall
 ret
    553e:	8082                	ret

0000000000005540 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5540:	48b5                	li	a7,13
 ecall
    5542:	00000073          	ecall
 ret
    5546:	8082                	ret

0000000000005548 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5548:	48b9                	li	a7,14
 ecall
    554a:	00000073          	ecall
 ret
    554e:	8082                	ret

0000000000005550 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5550:	1101                	add	sp,sp,-32
    5552:	ec06                	sd	ra,24(sp)
    5554:	e822                	sd	s0,16(sp)
    5556:	1000                	add	s0,sp,32
    5558:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    555c:	4605                	li	a2,1
    555e:	fef40593          	add	a1,s0,-17
    5562:	00000097          	auipc	ra,0x0
    5566:	f6e080e7          	jalr	-146(ra) # 54d0 <write>
}
    556a:	60e2                	ld	ra,24(sp)
    556c:	6442                	ld	s0,16(sp)
    556e:	6105                	add	sp,sp,32
    5570:	8082                	ret

0000000000005572 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5572:	7139                	add	sp,sp,-64
    5574:	fc06                	sd	ra,56(sp)
    5576:	f822                	sd	s0,48(sp)
    5578:	f426                	sd	s1,40(sp)
    557a:	f04a                	sd	s2,32(sp)
    557c:	ec4e                	sd	s3,24(sp)
    557e:	0080                	add	s0,sp,64
    5580:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5582:	c299                	beqz	a3,5588 <printint+0x16>
    5584:	0805c963          	bltz	a1,5616 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5588:	2581                	sext.w	a1,a1
  neg = 0;
    558a:	4881                	li	a7,0
    558c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5590:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5592:	2601                	sext.w	a2,a2
    5594:	00003517          	auipc	a0,0x3
    5598:	b6c50513          	add	a0,a0,-1172 # 8100 <digits>
    559c:	883a                	mv	a6,a4
    559e:	2705                	addw	a4,a4,1
    55a0:	02c5f7bb          	remuw	a5,a1,a2
    55a4:	1782                	sll	a5,a5,0x20
    55a6:	9381                	srl	a5,a5,0x20
    55a8:	97aa                	add	a5,a5,a0
    55aa:	0007c783          	lbu	a5,0(a5)
    55ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    55b2:	0005879b          	sext.w	a5,a1
    55b6:	02c5d5bb          	divuw	a1,a1,a2
    55ba:	0685                	add	a3,a3,1
    55bc:	fec7f0e3          	bgeu	a5,a2,559c <printint+0x2a>
  if(neg)
    55c0:	00088c63          	beqz	a7,55d8 <printint+0x66>
    buf[i++] = '-';
    55c4:	fd070793          	add	a5,a4,-48
    55c8:	00878733          	add	a4,a5,s0
    55cc:	02d00793          	li	a5,45
    55d0:	fef70823          	sb	a5,-16(a4)
    55d4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    55d8:	02e05863          	blez	a4,5608 <printint+0x96>
    55dc:	fc040793          	add	a5,s0,-64
    55e0:	00e78933          	add	s2,a5,a4
    55e4:	fff78993          	add	s3,a5,-1
    55e8:	99ba                	add	s3,s3,a4
    55ea:	377d                	addw	a4,a4,-1
    55ec:	1702                	sll	a4,a4,0x20
    55ee:	9301                	srl	a4,a4,0x20
    55f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    55f4:	fff94583          	lbu	a1,-1(s2)
    55f8:	8526                	mv	a0,s1
    55fa:	00000097          	auipc	ra,0x0
    55fe:	f56080e7          	jalr	-170(ra) # 5550 <putc>
  while(--i >= 0)
    5602:	197d                	add	s2,s2,-1
    5604:	ff3918e3          	bne	s2,s3,55f4 <printint+0x82>
}
    5608:	70e2                	ld	ra,56(sp)
    560a:	7442                	ld	s0,48(sp)
    560c:	74a2                	ld	s1,40(sp)
    560e:	7902                	ld	s2,32(sp)
    5610:	69e2                	ld	s3,24(sp)
    5612:	6121                	add	sp,sp,64
    5614:	8082                	ret
    x = -xx;
    5616:	40b005bb          	negw	a1,a1
    neg = 1;
    561a:	4885                	li	a7,1
    x = -xx;
    561c:	bf85                	j	558c <printint+0x1a>

000000000000561e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    561e:	715d                	add	sp,sp,-80
    5620:	e486                	sd	ra,72(sp)
    5622:	e0a2                	sd	s0,64(sp)
    5624:	fc26                	sd	s1,56(sp)
    5626:	f84a                	sd	s2,48(sp)
    5628:	f44e                	sd	s3,40(sp)
    562a:	f052                	sd	s4,32(sp)
    562c:	ec56                	sd	s5,24(sp)
    562e:	e85a                	sd	s6,16(sp)
    5630:	e45e                	sd	s7,8(sp)
    5632:	e062                	sd	s8,0(sp)
    5634:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5636:	0005c903          	lbu	s2,0(a1)
    563a:	18090c63          	beqz	s2,57d2 <vprintf+0x1b4>
    563e:	8aaa                	mv	s5,a0
    5640:	8bb2                	mv	s7,a2
    5642:	00158493          	add	s1,a1,1
  state = 0;
    5646:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5648:	02500a13          	li	s4,37
    564c:	4b55                	li	s6,21
    564e:	a839                	j	566c <vprintf+0x4e>
        putc(fd, c);
    5650:	85ca                	mv	a1,s2
    5652:	8556                	mv	a0,s5
    5654:	00000097          	auipc	ra,0x0
    5658:	efc080e7          	jalr	-260(ra) # 5550 <putc>
    565c:	a019                	j	5662 <vprintf+0x44>
    } else if(state == '%'){
    565e:	01498d63          	beq	s3,s4,5678 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5662:	0485                	add	s1,s1,1
    5664:	fff4c903          	lbu	s2,-1(s1)
    5668:	16090563          	beqz	s2,57d2 <vprintf+0x1b4>
    if(state == 0){
    566c:	fe0999e3          	bnez	s3,565e <vprintf+0x40>
      if(c == '%'){
    5670:	ff4910e3          	bne	s2,s4,5650 <vprintf+0x32>
        state = '%';
    5674:	89d2                	mv	s3,s4
    5676:	b7f5                	j	5662 <vprintf+0x44>
      if(c == 'd'){
    5678:	13490263          	beq	s2,s4,579c <vprintf+0x17e>
    567c:	f9d9079b          	addw	a5,s2,-99
    5680:	0ff7f793          	zext.b	a5,a5
    5684:	12fb6563          	bltu	s6,a5,57ae <vprintf+0x190>
    5688:	f9d9079b          	addw	a5,s2,-99
    568c:	0ff7f713          	zext.b	a4,a5
    5690:	10eb6f63          	bltu	s6,a4,57ae <vprintf+0x190>
    5694:	00271793          	sll	a5,a4,0x2
    5698:	00003717          	auipc	a4,0x3
    569c:	a1070713          	add	a4,a4,-1520 # 80a8 <malloc+0x27d8>
    56a0:	97ba                	add	a5,a5,a4
    56a2:	439c                	lw	a5,0(a5)
    56a4:	97ba                	add	a5,a5,a4
    56a6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    56a8:	008b8913          	add	s2,s7,8
    56ac:	4685                	li	a3,1
    56ae:	4629                	li	a2,10
    56b0:	000ba583          	lw	a1,0(s7)
    56b4:	8556                	mv	a0,s5
    56b6:	00000097          	auipc	ra,0x0
    56ba:	ebc080e7          	jalr	-324(ra) # 5572 <printint>
    56be:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    56c0:	4981                	li	s3,0
    56c2:	b745                	j	5662 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    56c4:	008b8913          	add	s2,s7,8
    56c8:	4681                	li	a3,0
    56ca:	4629                	li	a2,10
    56cc:	000ba583          	lw	a1,0(s7)
    56d0:	8556                	mv	a0,s5
    56d2:	00000097          	auipc	ra,0x0
    56d6:	ea0080e7          	jalr	-352(ra) # 5572 <printint>
    56da:	8bca                	mv	s7,s2
      state = 0;
    56dc:	4981                	li	s3,0
    56de:	b751                	j	5662 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    56e0:	008b8913          	add	s2,s7,8
    56e4:	4681                	li	a3,0
    56e6:	4641                	li	a2,16
    56e8:	000ba583          	lw	a1,0(s7)
    56ec:	8556                	mv	a0,s5
    56ee:	00000097          	auipc	ra,0x0
    56f2:	e84080e7          	jalr	-380(ra) # 5572 <printint>
    56f6:	8bca                	mv	s7,s2
      state = 0;
    56f8:	4981                	li	s3,0
    56fa:	b7a5                	j	5662 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    56fc:	008b8c13          	add	s8,s7,8
    5700:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5704:	03000593          	li	a1,48
    5708:	8556                	mv	a0,s5
    570a:	00000097          	auipc	ra,0x0
    570e:	e46080e7          	jalr	-442(ra) # 5550 <putc>
  putc(fd, 'x');
    5712:	07800593          	li	a1,120
    5716:	8556                	mv	a0,s5
    5718:	00000097          	auipc	ra,0x0
    571c:	e38080e7          	jalr	-456(ra) # 5550 <putc>
    5720:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5722:	00003b97          	auipc	s7,0x3
    5726:	9deb8b93          	add	s7,s7,-1570 # 8100 <digits>
    572a:	03c9d793          	srl	a5,s3,0x3c
    572e:	97de                	add	a5,a5,s7
    5730:	0007c583          	lbu	a1,0(a5)
    5734:	8556                	mv	a0,s5
    5736:	00000097          	auipc	ra,0x0
    573a:	e1a080e7          	jalr	-486(ra) # 5550 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    573e:	0992                	sll	s3,s3,0x4
    5740:	397d                	addw	s2,s2,-1
    5742:	fe0914e3          	bnez	s2,572a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5746:	8be2                	mv	s7,s8
      state = 0;
    5748:	4981                	li	s3,0
    574a:	bf21                	j	5662 <vprintf+0x44>
        s = va_arg(ap, char*);
    574c:	008b8993          	add	s3,s7,8
    5750:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5754:	02090163          	beqz	s2,5776 <vprintf+0x158>
        while(*s != 0){
    5758:	00094583          	lbu	a1,0(s2)
    575c:	c9a5                	beqz	a1,57cc <vprintf+0x1ae>
          putc(fd, *s);
    575e:	8556                	mv	a0,s5
    5760:	00000097          	auipc	ra,0x0
    5764:	df0080e7          	jalr	-528(ra) # 5550 <putc>
          s++;
    5768:	0905                	add	s2,s2,1
        while(*s != 0){
    576a:	00094583          	lbu	a1,0(s2)
    576e:	f9e5                	bnez	a1,575e <vprintf+0x140>
        s = va_arg(ap, char*);
    5770:	8bce                	mv	s7,s3
      state = 0;
    5772:	4981                	li	s3,0
    5774:	b5fd                	j	5662 <vprintf+0x44>
          s = "(null)";
    5776:	00003917          	auipc	s2,0x3
    577a:	92a90913          	add	s2,s2,-1750 # 80a0 <malloc+0x27d0>
        while(*s != 0){
    577e:	02800593          	li	a1,40
    5782:	bff1                	j	575e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    5784:	008b8913          	add	s2,s7,8
    5788:	000bc583          	lbu	a1,0(s7)
    578c:	8556                	mv	a0,s5
    578e:	00000097          	auipc	ra,0x0
    5792:	dc2080e7          	jalr	-574(ra) # 5550 <putc>
    5796:	8bca                	mv	s7,s2
      state = 0;
    5798:	4981                	li	s3,0
    579a:	b5e1                	j	5662 <vprintf+0x44>
        putc(fd, c);
    579c:	02500593          	li	a1,37
    57a0:	8556                	mv	a0,s5
    57a2:	00000097          	auipc	ra,0x0
    57a6:	dae080e7          	jalr	-594(ra) # 5550 <putc>
      state = 0;
    57aa:	4981                	li	s3,0
    57ac:	bd5d                	j	5662 <vprintf+0x44>
        putc(fd, '%');
    57ae:	02500593          	li	a1,37
    57b2:	8556                	mv	a0,s5
    57b4:	00000097          	auipc	ra,0x0
    57b8:	d9c080e7          	jalr	-612(ra) # 5550 <putc>
        putc(fd, c);
    57bc:	85ca                	mv	a1,s2
    57be:	8556                	mv	a0,s5
    57c0:	00000097          	auipc	ra,0x0
    57c4:	d90080e7          	jalr	-624(ra) # 5550 <putc>
      state = 0;
    57c8:	4981                	li	s3,0
    57ca:	bd61                	j	5662 <vprintf+0x44>
        s = va_arg(ap, char*);
    57cc:	8bce                	mv	s7,s3
      state = 0;
    57ce:	4981                	li	s3,0
    57d0:	bd49                	j	5662 <vprintf+0x44>
    }
  }
}
    57d2:	60a6                	ld	ra,72(sp)
    57d4:	6406                	ld	s0,64(sp)
    57d6:	74e2                	ld	s1,56(sp)
    57d8:	7942                	ld	s2,48(sp)
    57da:	79a2                	ld	s3,40(sp)
    57dc:	7a02                	ld	s4,32(sp)
    57de:	6ae2                	ld	s5,24(sp)
    57e0:	6b42                	ld	s6,16(sp)
    57e2:	6ba2                	ld	s7,8(sp)
    57e4:	6c02                	ld	s8,0(sp)
    57e6:	6161                	add	sp,sp,80
    57e8:	8082                	ret

00000000000057ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    57ea:	715d                	add	sp,sp,-80
    57ec:	ec06                	sd	ra,24(sp)
    57ee:	e822                	sd	s0,16(sp)
    57f0:	1000                	add	s0,sp,32
    57f2:	e010                	sd	a2,0(s0)
    57f4:	e414                	sd	a3,8(s0)
    57f6:	e818                	sd	a4,16(s0)
    57f8:	ec1c                	sd	a5,24(s0)
    57fa:	03043023          	sd	a6,32(s0)
    57fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5802:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5806:	8622                	mv	a2,s0
    5808:	00000097          	auipc	ra,0x0
    580c:	e16080e7          	jalr	-490(ra) # 561e <vprintf>
}
    5810:	60e2                	ld	ra,24(sp)
    5812:	6442                	ld	s0,16(sp)
    5814:	6161                	add	sp,sp,80
    5816:	8082                	ret

0000000000005818 <printf>:

void
printf(const char *fmt, ...)
{
    5818:	711d                	add	sp,sp,-96
    581a:	ec06                	sd	ra,24(sp)
    581c:	e822                	sd	s0,16(sp)
    581e:	1000                	add	s0,sp,32
    5820:	e40c                	sd	a1,8(s0)
    5822:	e810                	sd	a2,16(s0)
    5824:	ec14                	sd	a3,24(s0)
    5826:	f018                	sd	a4,32(s0)
    5828:	f41c                	sd	a5,40(s0)
    582a:	03043823          	sd	a6,48(s0)
    582e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5832:	00840613          	add	a2,s0,8
    5836:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    583a:	85aa                	mv	a1,a0
    583c:	4505                	li	a0,1
    583e:	00000097          	auipc	ra,0x0
    5842:	de0080e7          	jalr	-544(ra) # 561e <vprintf>
}
    5846:	60e2                	ld	ra,24(sp)
    5848:	6442                	ld	s0,16(sp)
    584a:	6125                	add	sp,sp,96
    584c:	8082                	ret

000000000000584e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    584e:	1141                	add	sp,sp,-16
    5850:	e422                	sd	s0,8(sp)
    5852:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5854:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5858:	00003797          	auipc	a5,0x3
    585c:	8d87b783          	ld	a5,-1832(a5) # 8130 <freep>
    5860:	a02d                	j	588a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5862:	4618                	lw	a4,8(a2)
    5864:	9f2d                	addw	a4,a4,a1
    5866:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    586a:	6398                	ld	a4,0(a5)
    586c:	6310                	ld	a2,0(a4)
    586e:	a83d                	j	58ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5870:	ff852703          	lw	a4,-8(a0)
    5874:	9f31                	addw	a4,a4,a2
    5876:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5878:	ff053683          	ld	a3,-16(a0)
    587c:	a091                	j	58c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    587e:	6398                	ld	a4,0(a5)
    5880:	00e7e463          	bltu	a5,a4,5888 <free+0x3a>
    5884:	00e6ea63          	bltu	a3,a4,5898 <free+0x4a>
{
    5888:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    588a:	fed7fae3          	bgeu	a5,a3,587e <free+0x30>
    588e:	6398                	ld	a4,0(a5)
    5890:	00e6e463          	bltu	a3,a4,5898 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5894:	fee7eae3          	bltu	a5,a4,5888 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5898:	ff852583          	lw	a1,-8(a0)
    589c:	6390                	ld	a2,0(a5)
    589e:	02059813          	sll	a6,a1,0x20
    58a2:	01c85713          	srl	a4,a6,0x1c
    58a6:	9736                	add	a4,a4,a3
    58a8:	fae60de3          	beq	a2,a4,5862 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    58ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    58b0:	4790                	lw	a2,8(a5)
    58b2:	02061593          	sll	a1,a2,0x20
    58b6:	01c5d713          	srl	a4,a1,0x1c
    58ba:	973e                	add	a4,a4,a5
    58bc:	fae68ae3          	beq	a3,a4,5870 <free+0x22>
    p->s.ptr = bp->s.ptr;
    58c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    58c2:	00003717          	auipc	a4,0x3
    58c6:	86f73723          	sd	a5,-1938(a4) # 8130 <freep>
}
    58ca:	6422                	ld	s0,8(sp)
    58cc:	0141                	add	sp,sp,16
    58ce:	8082                	ret

00000000000058d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    58d0:	7139                	add	sp,sp,-64
    58d2:	fc06                	sd	ra,56(sp)
    58d4:	f822                	sd	s0,48(sp)
    58d6:	f426                	sd	s1,40(sp)
    58d8:	f04a                	sd	s2,32(sp)
    58da:	ec4e                	sd	s3,24(sp)
    58dc:	e852                	sd	s4,16(sp)
    58de:	e456                	sd	s5,8(sp)
    58e0:	e05a                	sd	s6,0(sp)
    58e2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    58e4:	02051493          	sll	s1,a0,0x20
    58e8:	9081                	srl	s1,s1,0x20
    58ea:	04bd                	add	s1,s1,15
    58ec:	8091                	srl	s1,s1,0x4
    58ee:	0014899b          	addw	s3,s1,1
    58f2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    58f4:	00003517          	auipc	a0,0x3
    58f8:	83c53503          	ld	a0,-1988(a0) # 8130 <freep>
    58fc:	c515                	beqz	a0,5928 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    58fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5900:	4798                	lw	a4,8(a5)
    5902:	02977f63          	bgeu	a4,s1,5940 <malloc+0x70>
  if(nu < 4096)
    5906:	8a4e                	mv	s4,s3
    5908:	0009871b          	sext.w	a4,s3
    590c:	6685                	lui	a3,0x1
    590e:	00d77363          	bgeu	a4,a3,5914 <malloc+0x44>
    5912:	6a05                	lui	s4,0x1
    5914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5918:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    591c:	00003917          	auipc	s2,0x3
    5920:	81490913          	add	s2,s2,-2028 # 8130 <freep>
  if(p == (char*)-1)
    5924:	5afd                	li	s5,-1
    5926:	a895                	j	599a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5928:	00009797          	auipc	a5,0x9
    592c:	02878793          	add	a5,a5,40 # e950 <base>
    5930:	00003717          	auipc	a4,0x3
    5934:	80f73023          	sd	a5,-2048(a4) # 8130 <freep>
    5938:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    593a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    593e:	b7e1                	j	5906 <malloc+0x36>
      if(p->s.size == nunits)
    5940:	02e48c63          	beq	s1,a4,5978 <malloc+0xa8>
        p->s.size -= nunits;
    5944:	4137073b          	subw	a4,a4,s3
    5948:	c798                	sw	a4,8(a5)
        p += p->s.size;
    594a:	02071693          	sll	a3,a4,0x20
    594e:	01c6d713          	srl	a4,a3,0x1c
    5952:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5954:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5958:	00002717          	auipc	a4,0x2
    595c:	7ca73c23          	sd	a0,2008(a4) # 8130 <freep>
      return (void*)(p + 1);
    5960:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5964:	70e2                	ld	ra,56(sp)
    5966:	7442                	ld	s0,48(sp)
    5968:	74a2                	ld	s1,40(sp)
    596a:	7902                	ld	s2,32(sp)
    596c:	69e2                	ld	s3,24(sp)
    596e:	6a42                	ld	s4,16(sp)
    5970:	6aa2                	ld	s5,8(sp)
    5972:	6b02                	ld	s6,0(sp)
    5974:	6121                	add	sp,sp,64
    5976:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5978:	6398                	ld	a4,0(a5)
    597a:	e118                	sd	a4,0(a0)
    597c:	bff1                	j	5958 <malloc+0x88>
  hp->s.size = nu;
    597e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5982:	0541                	add	a0,a0,16
    5984:	00000097          	auipc	ra,0x0
    5988:	eca080e7          	jalr	-310(ra) # 584e <free>
  return freep;
    598c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5990:	d971                	beqz	a0,5964 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5992:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5994:	4798                	lw	a4,8(a5)
    5996:	fa9775e3          	bgeu	a4,s1,5940 <malloc+0x70>
    if(p == freep)
    599a:	00093703          	ld	a4,0(s2)
    599e:	853e                	mv	a0,a5
    59a0:	fef719e3          	bne	a4,a5,5992 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    59a4:	8552                	mv	a0,s4
    59a6:	00000097          	auipc	ra,0x0
    59aa:	b92080e7          	jalr	-1134(ra) # 5538 <sbrk>
  if(p == (char*)-1)
    59ae:	fd5518e3          	bne	a0,s5,597e <malloc+0xae>
        return 0;
    59b2:	4501                	li	a0,0
    59b4:	bf45                	j	5964 <malloc+0x94>
