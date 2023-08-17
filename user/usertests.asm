
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
      14:	38a080e7          	jalr	906(ra) # 539a <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	378080e7          	jalr	888(ra) # 539a <open>
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
      42:	8aa50513          	add	a0,a0,-1878 # 58e8 <statistics+0x88>
      46:	00005097          	auipc	ra,0x5
      4a:	67c080e7          	jalr	1660(ra) # 56c2 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	30a080e7          	jalr	778(ra) # 535a <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	0a078793          	add	a5,a5,160 # 90f8 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	7a868693          	add	a3,a3,1960 # b808 <buf>
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
      84:	88850513          	add	a0,a0,-1912 # 5908 <statistics+0xa8>
      88:	00005097          	auipc	ra,0x5
      8c:	63a080e7          	jalr	1594(ra) # 56c2 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	2c8080e7          	jalr	712(ra) # 535a <exit>

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
      ac:	87850513          	add	a0,a0,-1928 # 5920 <statistics+0xc0>
      b0:	00005097          	auipc	ra,0x5
      b4:	2ea080e7          	jalr	746(ra) # 539a <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	2c6080e7          	jalr	710(ra) # 5382 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	87a50513          	add	a0,a0,-1926 # 5940 <statistics+0xe0>
      ce:	00005097          	auipc	ra,0x5
      d2:	2cc080e7          	jalr	716(ra) # 539a <open>
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
      ea:	84250513          	add	a0,a0,-1982 # 5928 <statistics+0xc8>
      ee:	00005097          	auipc	ra,0x5
      f2:	5d4080e7          	jalr	1492(ra) # 56c2 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	262080e7          	jalr	610(ra) # 535a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	84e50513          	add	a0,a0,-1970 # 5950 <statistics+0xf0>
     10a:	00005097          	auipc	ra,0x5
     10e:	5b8080e7          	jalr	1464(ra) # 56c2 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	246080e7          	jalr	582(ra) # 535a <exit>

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
     130:	84c50513          	add	a0,a0,-1972 # 5978 <statistics+0x118>
     134:	00005097          	auipc	ra,0x5
     138:	276080e7          	jalr	630(ra) # 53aa <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	83850513          	add	a0,a0,-1992 # 5978 <statistics+0x118>
     148:	00005097          	auipc	ra,0x5
     14c:	252080e7          	jalr	594(ra) # 539a <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	83458593          	add	a1,a1,-1996 # 5988 <statistics+0x128>
     15c:	00005097          	auipc	ra,0x5
     160:	21e080e7          	jalr	542(ra) # 537a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	81050513          	add	a0,a0,-2032 # 5978 <statistics+0x118>
     170:	00005097          	auipc	ra,0x5
     174:	22a080e7          	jalr	554(ra) # 539a <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	81458593          	add	a1,a1,-2028 # 5990 <statistics+0x130>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	1f4080e7          	jalr	500(ra) # 537a <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00005517          	auipc	a0,0x5
     198:	7e450513          	add	a0,a0,2020 # 5978 <statistics+0x118>
     19c:	00005097          	auipc	ra,0x5
     1a0:	20e080e7          	jalr	526(ra) # 53aa <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	1dc080e7          	jalr	476(ra) # 5382 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	1d2080e7          	jalr	466(ra) # 5382 <close>
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
     1ca:	00005517          	auipc	a0,0x5
     1ce:	7ce50513          	add	a0,a0,1998 # 5998 <statistics+0x138>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	4f0080e7          	jalr	1264(ra) # 56c2 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	17e080e7          	jalr	382(ra) # 535a <exit>

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
     1f6:	dee78793          	add	a5,a5,-530 # 7fe0 <name>
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
     21e:	180080e7          	jalr	384(ra) # 539a <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	160080e7          	jalr	352(ra) # 5382 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addw	s1,s1,1
     22c:	0ff4f493          	zext.b	s1,s1
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	dac78793          	add	a5,a5,-596 # 7fe0 <name>
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
     25c:	152080e7          	jalr	338(ra) # 53aa <unlink>
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
     290:	00005517          	auipc	a0,0x5
     294:	73050513          	add	a0,a0,1840 # 59c0 <statistics+0x160>
     298:	00005097          	auipc	ra,0x5
     29c:	112080e7          	jalr	274(ra) # 53aa <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	71ca8a93          	add	s5,s5,1820 # 59c0 <statistics+0x160>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	55ca0a13          	add	s4,s4,1372 # b808 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	add	s6,s6,457 # 31c9 <subdir+0x4f3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	0da080e7          	jalr	218(ra) # 539a <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	0a8080e7          	jalr	168(ra) # 537a <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49263          	bne	s1,a0,340 <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	094080e7          	jalr	148(ra) # 537a <write>
      if(cc != sz){
     2ee:	04951a63          	bne	a0,s1,342 <bigwrite+0xca>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	08e080e7          	jalr	142(ra) # 5382 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	0ac080e7          	jalr	172(ra) # 53aa <unlink>
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
     32a:	6aa50513          	add	a0,a0,1706 # 59d0 <statistics+0x170>
     32e:	00005097          	auipc	ra,0x5
     332:	394080e7          	jalr	916(ra) # 56c2 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	022080e7          	jalr	34(ra) # 535a <exit>
      if(cc != sz){
     340:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86aa                	mv	a3,a0
     344:	864e                	mv	a2,s3
     346:	85de                	mv	a1,s7
     348:	00005517          	auipc	a0,0x5
     34c:	6a850513          	add	a0,a0,1704 # 59f0 <statistics+0x190>
     350:	00005097          	auipc	ra,0x5
     354:	372080e7          	jalr	882(ra) # 56c2 <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00005097          	auipc	ra,0x5
     35e:	000080e7          	jalr	ra # 535a <exit>

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
     388:	684a0a13          	add	s4,s4,1668 # 5a08 <statistics+0x1a8>
    uint64 addr = addrs[ai];
     38c:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     390:	20100593          	li	a1,513
     394:	8552                	mv	a0,s4
     396:	00005097          	auipc	ra,0x5
     39a:	004080e7          	jalr	4(ra) # 539a <open>
     39e:	84aa                	mv	s1,a0
    if(fd < 0){
     3a0:	08054863          	bltz	a0,430 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a4:	6609                	lui	a2,0x2
     3a6:	85ce                	mv	a1,s3
     3a8:	00005097          	auipc	ra,0x5
     3ac:	fd2080e7          	jalr	-46(ra) # 537a <write>
    if(n >= 0){
     3b0:	08055d63          	bgez	a0,44a <copyin+0xe8>
    close(fd);
     3b4:	8526                	mv	a0,s1
     3b6:	00005097          	auipc	ra,0x5
     3ba:	fcc080e7          	jalr	-52(ra) # 5382 <close>
    unlink("copyin1");
     3be:	8552                	mv	a0,s4
     3c0:	00005097          	auipc	ra,0x5
     3c4:	fea080e7          	jalr	-22(ra) # 53aa <unlink>
    n = write(1, (char*)addr, 8192);
     3c8:	6609                	lui	a2,0x2
     3ca:	85ce                	mv	a1,s3
     3cc:	4505                	li	a0,1
     3ce:	00005097          	auipc	ra,0x5
     3d2:	fac080e7          	jalr	-84(ra) # 537a <write>
    if(n > 0){
     3d6:	08a04963          	bgtz	a0,468 <copyin+0x106>
    if(pipe(fds) < 0){
     3da:	fb840513          	add	a0,s0,-72
     3de:	00005097          	auipc	ra,0x5
     3e2:	f8c080e7          	jalr	-116(ra) # 536a <pipe>
     3e6:	0a054063          	bltz	a0,486 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ea:	6609                	lui	a2,0x2
     3ec:	85ce                	mv	a1,s3
     3ee:	fbc42503          	lw	a0,-68(s0)
     3f2:	00005097          	auipc	ra,0x5
     3f6:	f88080e7          	jalr	-120(ra) # 537a <write>
    if(n > 0){
     3fa:	0aa04363          	bgtz	a0,4a0 <copyin+0x13e>
    close(fds[0]);
     3fe:	fb842503          	lw	a0,-72(s0)
     402:	00005097          	auipc	ra,0x5
     406:	f80080e7          	jalr	-128(ra) # 5382 <close>
    close(fds[1]);
     40a:	fbc42503          	lw	a0,-68(s0)
     40e:	00005097          	auipc	ra,0x5
     412:	f74080e7          	jalr	-140(ra) # 5382 <close>
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
     434:	5e050513          	add	a0,a0,1504 # 5a10 <statistics+0x1b0>
     438:	00005097          	auipc	ra,0x5
     43c:	28a080e7          	jalr	650(ra) # 56c2 <printf>
      exit(1);
     440:	4505                	li	a0,1
     442:	00005097          	auipc	ra,0x5
     446:	f18080e7          	jalr	-232(ra) # 535a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44a:	862a                	mv	a2,a0
     44c:	85ce                	mv	a1,s3
     44e:	00005517          	auipc	a0,0x5
     452:	5da50513          	add	a0,a0,1498 # 5a28 <statistics+0x1c8>
     456:	00005097          	auipc	ra,0x5
     45a:	26c080e7          	jalr	620(ra) # 56c2 <printf>
      exit(1);
     45e:	4505                	li	a0,1
     460:	00005097          	auipc	ra,0x5
     464:	efa080e7          	jalr	-262(ra) # 535a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     468:	862a                	mv	a2,a0
     46a:	85ce                	mv	a1,s3
     46c:	00005517          	auipc	a0,0x5
     470:	5ec50513          	add	a0,a0,1516 # 5a58 <statistics+0x1f8>
     474:	00005097          	auipc	ra,0x5
     478:	24e080e7          	jalr	590(ra) # 56c2 <printf>
      exit(1);
     47c:	4505                	li	a0,1
     47e:	00005097          	auipc	ra,0x5
     482:	edc080e7          	jalr	-292(ra) # 535a <exit>
      printf("pipe() failed\n");
     486:	00005517          	auipc	a0,0x5
     48a:	60250513          	add	a0,a0,1538 # 5a88 <statistics+0x228>
     48e:	00005097          	auipc	ra,0x5
     492:	234080e7          	jalr	564(ra) # 56c2 <printf>
      exit(1);
     496:	4505                	li	a0,1
     498:	00005097          	auipc	ra,0x5
     49c:	ec2080e7          	jalr	-318(ra) # 535a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a0:	862a                	mv	a2,a0
     4a2:	85ce                	mv	a1,s3
     4a4:	00005517          	auipc	a0,0x5
     4a8:	5f450513          	add	a0,a0,1524 # 5a98 <statistics+0x238>
     4ac:	00005097          	auipc	ra,0x5
     4b0:	216080e7          	jalr	534(ra) # 56c2 <printf>
      exit(1);
     4b4:	4505                	li	a0,1
     4b6:	00005097          	auipc	ra,0x5
     4ba:	ea4080e7          	jalr	-348(ra) # 535a <exit>

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
     4e6:	5e6a0a13          	add	s4,s4,1510 # 5ac8 <statistics+0x268>
    n = write(fds[1], "x", 1);
     4ea:	00005a97          	auipc	s5,0x5
     4ee:	4a6a8a93          	add	s5,s5,1190 # 5990 <statistics+0x130>
    uint64 addr = addrs[ai];
     4f2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f6:	4581                	li	a1,0
     4f8:	8552                	mv	a0,s4
     4fa:	00005097          	auipc	ra,0x5
     4fe:	ea0080e7          	jalr	-352(ra) # 539a <open>
     502:	84aa                	mv	s1,a0
    if(fd < 0){
     504:	08054663          	bltz	a0,590 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     508:	6609                	lui	a2,0x2
     50a:	85ce                	mv	a1,s3
     50c:	00005097          	auipc	ra,0x5
     510:	e66080e7          	jalr	-410(ra) # 5372 <read>
    if(n > 0){
     514:	08a04b63          	bgtz	a0,5aa <copyout+0xec>
    close(fd);
     518:	8526                	mv	a0,s1
     51a:	00005097          	auipc	ra,0x5
     51e:	e68080e7          	jalr	-408(ra) # 5382 <close>
    if(pipe(fds) < 0){
     522:	fa840513          	add	a0,s0,-88
     526:	00005097          	auipc	ra,0x5
     52a:	e44080e7          	jalr	-444(ra) # 536a <pipe>
     52e:	08054d63          	bltz	a0,5c8 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     532:	4605                	li	a2,1
     534:	85d6                	mv	a1,s5
     536:	fac42503          	lw	a0,-84(s0)
     53a:	00005097          	auipc	ra,0x5
     53e:	e40080e7          	jalr	-448(ra) # 537a <write>
    if(n != 1){
     542:	4785                	li	a5,1
     544:	08f51f63          	bne	a0,a5,5e2 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     548:	6609                	lui	a2,0x2
     54a:	85ce                	mv	a1,s3
     54c:	fa842503          	lw	a0,-88(s0)
     550:	00005097          	auipc	ra,0x5
     554:	e22080e7          	jalr	-478(ra) # 5372 <read>
    if(n > 0){
     558:	0aa04263          	bgtz	a0,5fc <copyout+0x13e>
    close(fds[0]);
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00005097          	auipc	ra,0x5
     564:	e22080e7          	jalr	-478(ra) # 5382 <close>
    close(fds[1]);
     568:	fac42503          	lw	a0,-84(s0)
     56c:	00005097          	auipc	ra,0x5
     570:	e16080e7          	jalr	-490(ra) # 5382 <close>
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
     594:	54050513          	add	a0,a0,1344 # 5ad0 <statistics+0x270>
     598:	00005097          	auipc	ra,0x5
     59c:	12a080e7          	jalr	298(ra) # 56c2 <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	db8080e7          	jalr	-584(ra) # 535a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00005517          	auipc	a0,0x5
     5b2:	53a50513          	add	a0,a0,1338 # 5ae8 <statistics+0x288>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	10c080e7          	jalr	268(ra) # 56c2 <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	d9a080e7          	jalr	-614(ra) # 535a <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	4c050513          	add	a0,a0,1216 # 5a88 <statistics+0x228>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	0f2080e7          	jalr	242(ra) # 56c2 <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	d80080e7          	jalr	-640(ra) # 535a <exit>
      printf("pipe write failed\n");
     5e2:	00005517          	auipc	a0,0x5
     5e6:	53650513          	add	a0,a0,1334 # 5b18 <statistics+0x2b8>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	0d8080e7          	jalr	216(ra) # 56c2 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	d66080e7          	jalr	-666(ra) # 535a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00005517          	auipc	a0,0x5
     604:	53050513          	add	a0,a0,1328 # 5b30 <statistics+0x2d0>
     608:	00005097          	auipc	ra,0x5
     60c:	0ba080e7          	jalr	186(ra) # 56c2 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	d48080e7          	jalr	-696(ra) # 535a <exit>

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
     632:	34a50513          	add	a0,a0,842 # 5978 <statistics+0x118>
     636:	00005097          	auipc	ra,0x5
     63a:	d74080e7          	jalr	-652(ra) # 53aa <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00005517          	auipc	a0,0x5
     646:	33650513          	add	a0,a0,822 # 5978 <statistics+0x118>
     64a:	00005097          	auipc	ra,0x5
     64e:	d50080e7          	jalr	-688(ra) # 539a <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00005597          	auipc	a1,0x5
     65a:	33258593          	add	a1,a1,818 # 5988 <statistics+0x128>
     65e:	00005097          	auipc	ra,0x5
     662:	d1c080e7          	jalr	-740(ra) # 537a <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	d1a080e7          	jalr	-742(ra) # 5382 <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00005517          	auipc	a0,0x5
     676:	30650513          	add	a0,a0,774 # 5978 <statistics+0x118>
     67a:	00005097          	auipc	ra,0x5
     67e:	d20080e7          	jalr	-736(ra) # 539a <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	add	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	ce6080e7          	jalr	-794(ra) # 5372 <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00005517          	auipc	a0,0x5
     6a2:	2da50513          	add	a0,a0,730 # 5978 <statistics+0x118>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	cf4080e7          	jalr	-780(ra) # 539a <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00005517          	auipc	a0,0x5
     6b6:	2c650513          	add	a0,a0,710 # 5978 <statistics+0x118>
     6ba:	00005097          	auipc	ra,0x5
     6be:	ce0080e7          	jalr	-800(ra) # 539a <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	add	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	ca6080e7          	jalr	-858(ra) # 5372 <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	add	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	c90080e7          	jalr	-880(ra) # 5372 <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00005597          	auipc	a1,0x5
     6f4:	4d058593          	add	a1,a1,1232 # 5bc0 <statistics+0x360>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	c80080e7          	jalr	-896(ra) # 537a <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	add	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	c66080e7          	jalr	-922(ra) # 5372 <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	add	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	c4e080e7          	jalr	-946(ra) # 5372 <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00005517          	auipc	a0,0x5
     736:	24650513          	add	a0,a0,582 # 5978 <statistics+0x118>
     73a:	00005097          	auipc	ra,0x5
     73e:	c70080e7          	jalr	-912(ra) # 53aa <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	c3e080e7          	jalr	-962(ra) # 5382 <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	c34080e7          	jalr	-972(ra) # 5382 <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	c2a080e7          	jalr	-982(ra) # 5382 <close>
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
     77a:	3ea50513          	add	a0,a0,1002 # 5b60 <statistics+0x300>
     77e:	00005097          	auipc	ra,0x5
     782:	f44080e7          	jalr	-188(ra) # 56c2 <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	bd2080e7          	jalr	-1070(ra) # 535a <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00005517          	auipc	a0,0x5
     796:	3ee50513          	add	a0,a0,1006 # 5b80 <statistics+0x320>
     79a:	00005097          	auipc	ra,0x5
     79e:	f28080e7          	jalr	-216(ra) # 56c2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00005517          	auipc	a0,0x5
     7aa:	3ea50513          	add	a0,a0,1002 # 5b90 <statistics+0x330>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	f14080e7          	jalr	-236(ra) # 56c2 <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	ba2080e7          	jalr	-1118(ra) # 535a <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00005517          	auipc	a0,0x5
     7c6:	3ee50513          	add	a0,a0,1006 # 5bb0 <statistics+0x350>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	ef8080e7          	jalr	-264(ra) # 56c2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00005517          	auipc	a0,0x5
     7da:	3ba50513          	add	a0,a0,954 # 5b90 <statistics+0x330>
     7de:	00005097          	auipc	ra,0x5
     7e2:	ee4080e7          	jalr	-284(ra) # 56c2 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	b72080e7          	jalr	-1166(ra) # 535a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00005517          	auipc	a0,0x5
     7f8:	3d450513          	add	a0,a0,980 # 5bc8 <statistics+0x368>
     7fc:	00005097          	auipc	ra,0x5
     800:	ec6080e7          	jalr	-314(ra) # 56c2 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	b54080e7          	jalr	-1196(ra) # 535a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00005517          	auipc	a0,0x5
     816:	3d650513          	add	a0,a0,982 # 5be8 <statistics+0x388>
     81a:	00005097          	auipc	ra,0x5
     81e:	ea8080e7          	jalr	-344(ra) # 56c2 <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	b36080e7          	jalr	-1226(ra) # 535a <exit>

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
     84a:	3c250513          	add	a0,a0,962 # 5c08 <statistics+0x3a8>
     84e:	00005097          	auipc	ra,0x5
     852:	b4c080e7          	jalr	-1204(ra) # 539a <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00005997          	auipc	s3,0x5
     862:	3d298993          	add	s3,s3,978 # 5c30 <statistics+0x3d0>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00005a97          	auipc	s5,0x5
     86a:	402a8a93          	add	s5,s5,1026 # 5c68 <statistics+0x408>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	b02080e7          	jalr	-1278(ra) # 537a <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	aee080e7          	jalr	-1298(ra) # 537a <write>
     894:	47a9                	li	a5,10
     896:	0af51963          	bne	a0,a5,948 <writetest+0x11c>
  for(i = 0; i < N; i++){
     89a:	2485                	addw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	ae0080e7          	jalr	-1312(ra) # 5382 <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00005517          	auipc	a0,0x5
     8b0:	35c50513          	add	a0,a0,860 # 5c08 <statistics+0x3a8>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	ae6080e7          	jalr	-1306(ra) # 539a <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054363          	bltz	a0,964 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	f4258593          	add	a1,a1,-190 # b808 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	aa4080e7          	jalr	-1372(ra) # 5372 <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51363          	bne	a0,a5,980 <writetest+0x154>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	aa2080e7          	jalr	-1374(ra) # 5382 <close>
  if(unlink("small") < 0){
     8e8:	00005517          	auipc	a0,0x5
     8ec:	32050513          	add	a0,a0,800 # 5c08 <statistics+0x3a8>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	aba080e7          	jalr	-1350(ra) # 53aa <unlink>
     8f8:	0a054263          	bltz	a0,99c <writetest+0x170>
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
     916:	2fe50513          	add	a0,a0,766 # 5c10 <statistics+0x3b0>
     91a:	00005097          	auipc	ra,0x5
     91e:	da8080e7          	jalr	-600(ra) # 56c2 <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	a36080e7          	jalr	-1482(ra) # 535a <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92c:	85a6                	mv	a1,s1
     92e:	00005517          	auipc	a0,0x5
     932:	31250513          	add	a0,a0,786 # 5c40 <statistics+0x3e0>
     936:	00005097          	auipc	ra,0x5
     93a:	d8c080e7          	jalr	-628(ra) # 56c2 <printf>
      exit(1);
     93e:	4505                	li	a0,1
     940:	00005097          	auipc	ra,0x5
     944:	a1a080e7          	jalr	-1510(ra) # 535a <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     948:	85a6                	mv	a1,s1
     94a:	00005517          	auipc	a0,0x5
     94e:	32e50513          	add	a0,a0,814 # 5c78 <statistics+0x418>
     952:	00005097          	auipc	ra,0x5
     956:	d70080e7          	jalr	-656(ra) # 56c2 <printf>
      exit(1);
     95a:	4505                	li	a0,1
     95c:	00005097          	auipc	ra,0x5
     960:	9fe080e7          	jalr	-1538(ra) # 535a <exit>
    printf("%s: error: open small failed!\n", s);
     964:	85da                	mv	a1,s6
     966:	00005517          	auipc	a0,0x5
     96a:	33a50513          	add	a0,a0,826 # 5ca0 <statistics+0x440>
     96e:	00005097          	auipc	ra,0x5
     972:	d54080e7          	jalr	-684(ra) # 56c2 <printf>
    exit(1);
     976:	4505                	li	a0,1
     978:	00005097          	auipc	ra,0x5
     97c:	9e2080e7          	jalr	-1566(ra) # 535a <exit>
    printf("%s: read failed\n", s);
     980:	85da                	mv	a1,s6
     982:	00005517          	auipc	a0,0x5
     986:	33e50513          	add	a0,a0,830 # 5cc0 <statistics+0x460>
     98a:	00005097          	auipc	ra,0x5
     98e:	d38080e7          	jalr	-712(ra) # 56c2 <printf>
    exit(1);
     992:	4505                	li	a0,1
     994:	00005097          	auipc	ra,0x5
     998:	9c6080e7          	jalr	-1594(ra) # 535a <exit>
    printf("%s: unlink small failed\n", s);
     99c:	85da                	mv	a1,s6
     99e:	00005517          	auipc	a0,0x5
     9a2:	33a50513          	add	a0,a0,826 # 5cd8 <statistics+0x478>
     9a6:	00005097          	auipc	ra,0x5
     9aa:	d1c080e7          	jalr	-740(ra) # 56c2 <printf>
    exit(1);
     9ae:	4505                	li	a0,1
     9b0:	00005097          	auipc	ra,0x5
     9b4:	9aa080e7          	jalr	-1622(ra) # 535a <exit>

00000000000009b8 <writebig>:
{
     9b8:	7139                	add	sp,sp,-64
     9ba:	fc06                	sd	ra,56(sp)
     9bc:	f822                	sd	s0,48(sp)
     9be:	f426                	sd	s1,40(sp)
     9c0:	f04a                	sd	s2,32(sp)
     9c2:	ec4e                	sd	s3,24(sp)
     9c4:	e852                	sd	s4,16(sp)
     9c6:	e456                	sd	s5,8(sp)
     9c8:	0080                	add	s0,sp,64
     9ca:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9cc:	20200593          	li	a1,514
     9d0:	00005517          	auipc	a0,0x5
     9d4:	32850513          	add	a0,a0,808 # 5cf8 <statistics+0x498>
     9d8:	00005097          	auipc	ra,0x5
     9dc:	9c2080e7          	jalr	-1598(ra) # 539a <open>
     9e0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e4:	0000b917          	auipc	s2,0xb
     9e8:	e2490913          	add	s2,s2,-476 # b808 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ec:	10c00a13          	li	s4,268
  if(fd < 0){
     9f0:	06054c63          	bltz	a0,a68 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9f8:	40000613          	li	a2,1024
     9fc:	85ca                	mv	a1,s2
     9fe:	854e                	mv	a0,s3
     a00:	00005097          	auipc	ra,0x5
     a04:	97a080e7          	jalr	-1670(ra) # 537a <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51c63          	bne	a0,a5,a84 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addw	s1,s1,1
     a12:	ff4491e3          	bne	s1,s4,9f4 <writebig+0x3c>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	00005097          	auipc	ra,0x5
     a1c:	96a080e7          	jalr	-1686(ra) # 5382 <close>
  fd = open("big", O_RDONLY);
     a20:	4581                	li	a1,0
     a22:	00005517          	auipc	a0,0x5
     a26:	2d650513          	add	a0,a0,726 # 5cf8 <statistics+0x498>
     a2a:	00005097          	auipc	ra,0x5
     a2e:	970080e7          	jalr	-1680(ra) # 539a <open>
     a32:	89aa                	mv	s3,a0
  n = 0;
     a34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a36:	0000b917          	auipc	s2,0xb
     a3a:	dd290913          	add	s2,s2,-558 # b808 <buf>
  if(fd < 0){
     a3e:	06054163          	bltz	a0,aa0 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a42:	40000613          	li	a2,1024
     a46:	85ca                	mv	a1,s2
     a48:	854e                	mv	a0,s3
     a4a:	00005097          	auipc	ra,0x5
     a4e:	928080e7          	jalr	-1752(ra) # 5372 <read>
    if(i == 0){
     a52:	c52d                	beqz	a0,abc <writebig+0x104>
    } else if(i != BSIZE){
     a54:	40000793          	li	a5,1024
     a58:	0af51d63          	bne	a0,a5,b12 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5c:	00092603          	lw	a2,0(s2)
     a60:	0c961763          	bne	a2,s1,b2e <writebig+0x176>
    n++;
     a64:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a66:	bff1                	j	a42 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a68:	85d6                	mv	a1,s5
     a6a:	00005517          	auipc	a0,0x5
     a6e:	29650513          	add	a0,a0,662 # 5d00 <statistics+0x4a0>
     a72:	00005097          	auipc	ra,0x5
     a76:	c50080e7          	jalr	-944(ra) # 56c2 <printf>
    exit(1);
     a7a:	4505                	li	a0,1
     a7c:	00005097          	auipc	ra,0x5
     a80:	8de080e7          	jalr	-1826(ra) # 535a <exit>
      printf("%s: error: write big file failed\n", i);
     a84:	85a6                	mv	a1,s1
     a86:	00005517          	auipc	a0,0x5
     a8a:	29a50513          	add	a0,a0,666 # 5d20 <statistics+0x4c0>
     a8e:	00005097          	auipc	ra,0x5
     a92:	c34080e7          	jalr	-972(ra) # 56c2 <printf>
      exit(1);
     a96:	4505                	li	a0,1
     a98:	00005097          	auipc	ra,0x5
     a9c:	8c2080e7          	jalr	-1854(ra) # 535a <exit>
    printf("%s: error: open big failed!\n", s);
     aa0:	85d6                	mv	a1,s5
     aa2:	00005517          	auipc	a0,0x5
     aa6:	2a650513          	add	a0,a0,678 # 5d48 <statistics+0x4e8>
     aaa:	00005097          	auipc	ra,0x5
     aae:	c18080e7          	jalr	-1000(ra) # 56c2 <printf>
    exit(1);
     ab2:	4505                	li	a0,1
     ab4:	00005097          	auipc	ra,0x5
     ab8:	8a6080e7          	jalr	-1882(ra) # 535a <exit>
      if(n == MAXFILE - 1){
     abc:	10b00793          	li	a5,267
     ac0:	02f48a63          	beq	s1,a5,af4 <writebig+0x13c>
  close(fd);
     ac4:	854e                	mv	a0,s3
     ac6:	00005097          	auipc	ra,0x5
     aca:	8bc080e7          	jalr	-1860(ra) # 5382 <close>
  if(unlink("big") < 0){
     ace:	00005517          	auipc	a0,0x5
     ad2:	22a50513          	add	a0,a0,554 # 5cf8 <statistics+0x498>
     ad6:	00005097          	auipc	ra,0x5
     ada:	8d4080e7          	jalr	-1836(ra) # 53aa <unlink>
     ade:	06054663          	bltz	a0,b4a <writebig+0x192>
}
     ae2:	70e2                	ld	ra,56(sp)
     ae4:	7442                	ld	s0,48(sp)
     ae6:	74a2                	ld	s1,40(sp)
     ae8:	7902                	ld	s2,32(sp)
     aea:	69e2                	ld	s3,24(sp)
     aec:	6a42                	ld	s4,16(sp)
     aee:	6aa2                	ld	s5,8(sp)
     af0:	6121                	add	sp,sp,64
     af2:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af4:	10b00593          	li	a1,267
     af8:	00005517          	auipc	a0,0x5
     afc:	27050513          	add	a0,a0,624 # 5d68 <statistics+0x508>
     b00:	00005097          	auipc	ra,0x5
     b04:	bc2080e7          	jalr	-1086(ra) # 56c2 <printf>
        exit(1);
     b08:	4505                	li	a0,1
     b0a:	00005097          	auipc	ra,0x5
     b0e:	850080e7          	jalr	-1968(ra) # 535a <exit>
      printf("%s: read failed %d\n", i);
     b12:	85aa                	mv	a1,a0
     b14:	00005517          	auipc	a0,0x5
     b18:	27c50513          	add	a0,a0,636 # 5d90 <statistics+0x530>
     b1c:	00005097          	auipc	ra,0x5
     b20:	ba6080e7          	jalr	-1114(ra) # 56c2 <printf>
      exit(1);
     b24:	4505                	li	a0,1
     b26:	00005097          	auipc	ra,0x5
     b2a:	834080e7          	jalr	-1996(ra) # 535a <exit>
      printf("%s: read content of block %d is %d\n",
     b2e:	85a6                	mv	a1,s1
     b30:	00005517          	auipc	a0,0x5
     b34:	27850513          	add	a0,a0,632 # 5da8 <statistics+0x548>
     b38:	00005097          	auipc	ra,0x5
     b3c:	b8a080e7          	jalr	-1142(ra) # 56c2 <printf>
      exit(1);
     b40:	4505                	li	a0,1
     b42:	00005097          	auipc	ra,0x5
     b46:	818080e7          	jalr	-2024(ra) # 535a <exit>
    printf("%s: unlink big failed\n", s);
     b4a:	85d6                	mv	a1,s5
     b4c:	00005517          	auipc	a0,0x5
     b50:	28450513          	add	a0,a0,644 # 5dd0 <statistics+0x570>
     b54:	00005097          	auipc	ra,0x5
     b58:	b6e080e7          	jalr	-1170(ra) # 56c2 <printf>
    exit(1);
     b5c:	4505                	li	a0,1
     b5e:	00004097          	auipc	ra,0x4
     b62:	7fc080e7          	jalr	2044(ra) # 535a <exit>

0000000000000b66 <unlinkread>:
{
     b66:	7179                	add	sp,sp,-48
     b68:	f406                	sd	ra,40(sp)
     b6a:	f022                	sd	s0,32(sp)
     b6c:	ec26                	sd	s1,24(sp)
     b6e:	e84a                	sd	s2,16(sp)
     b70:	e44e                	sd	s3,8(sp)
     b72:	1800                	add	s0,sp,48
     b74:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b76:	20200593          	li	a1,514
     b7a:	00005517          	auipc	a0,0x5
     b7e:	26e50513          	add	a0,a0,622 # 5de8 <statistics+0x588>
     b82:	00005097          	auipc	ra,0x5
     b86:	818080e7          	jalr	-2024(ra) # 539a <open>
  if(fd < 0){
     b8a:	0e054563          	bltz	a0,c74 <unlinkread+0x10e>
     b8e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b90:	4615                	li	a2,5
     b92:	00005597          	auipc	a1,0x5
     b96:	28658593          	add	a1,a1,646 # 5e18 <statistics+0x5b8>
     b9a:	00004097          	auipc	ra,0x4
     b9e:	7e0080e7          	jalr	2016(ra) # 537a <write>
  close(fd);
     ba2:	8526                	mv	a0,s1
     ba4:	00004097          	auipc	ra,0x4
     ba8:	7de080e7          	jalr	2014(ra) # 5382 <close>
  fd = open("unlinkread", O_RDWR);
     bac:	4589                	li	a1,2
     bae:	00005517          	auipc	a0,0x5
     bb2:	23a50513          	add	a0,a0,570 # 5de8 <statistics+0x588>
     bb6:	00004097          	auipc	ra,0x4
     bba:	7e4080e7          	jalr	2020(ra) # 539a <open>
     bbe:	84aa                	mv	s1,a0
  if(fd < 0){
     bc0:	0c054863          	bltz	a0,c90 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc4:	00005517          	auipc	a0,0x5
     bc8:	22450513          	add	a0,a0,548 # 5de8 <statistics+0x588>
     bcc:	00004097          	auipc	ra,0x4
     bd0:	7de080e7          	jalr	2014(ra) # 53aa <unlink>
     bd4:	ed61                	bnez	a0,cac <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd6:	20200593          	li	a1,514
     bda:	00005517          	auipc	a0,0x5
     bde:	20e50513          	add	a0,a0,526 # 5de8 <statistics+0x588>
     be2:	00004097          	auipc	ra,0x4
     be6:	7b8080e7          	jalr	1976(ra) # 539a <open>
     bea:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bec:	460d                	li	a2,3
     bee:	00005597          	auipc	a1,0x5
     bf2:	27258593          	add	a1,a1,626 # 5e60 <statistics+0x600>
     bf6:	00004097          	auipc	ra,0x4
     bfa:	784080e7          	jalr	1924(ra) # 537a <write>
  close(fd1);
     bfe:	854a                	mv	a0,s2
     c00:	00004097          	auipc	ra,0x4
     c04:	782080e7          	jalr	1922(ra) # 5382 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c08:	660d                	lui	a2,0x3
     c0a:	0000b597          	auipc	a1,0xb
     c0e:	bfe58593          	add	a1,a1,-1026 # b808 <buf>
     c12:	8526                	mv	a0,s1
     c14:	00004097          	auipc	ra,0x4
     c18:	75e080e7          	jalr	1886(ra) # 5372 <read>
     c1c:	4795                	li	a5,5
     c1e:	0af51563          	bne	a0,a5,cc8 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c22:	0000b717          	auipc	a4,0xb
     c26:	be674703          	lbu	a4,-1050(a4) # b808 <buf>
     c2a:	06800793          	li	a5,104
     c2e:	0af71b63          	bne	a4,a5,ce4 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c32:	4629                	li	a2,10
     c34:	0000b597          	auipc	a1,0xb
     c38:	bd458593          	add	a1,a1,-1068 # b808 <buf>
     c3c:	8526                	mv	a0,s1
     c3e:	00004097          	auipc	ra,0x4
     c42:	73c080e7          	jalr	1852(ra) # 537a <write>
     c46:	47a9                	li	a5,10
     c48:	0af51c63          	bne	a0,a5,d00 <unlinkread+0x19a>
  close(fd);
     c4c:	8526                	mv	a0,s1
     c4e:	00004097          	auipc	ra,0x4
     c52:	734080e7          	jalr	1844(ra) # 5382 <close>
  unlink("unlinkread");
     c56:	00005517          	auipc	a0,0x5
     c5a:	19250513          	add	a0,a0,402 # 5de8 <statistics+0x588>
     c5e:	00004097          	auipc	ra,0x4
     c62:	74c080e7          	jalr	1868(ra) # 53aa <unlink>
}
     c66:	70a2                	ld	ra,40(sp)
     c68:	7402                	ld	s0,32(sp)
     c6a:	64e2                	ld	s1,24(sp)
     c6c:	6942                	ld	s2,16(sp)
     c6e:	69a2                	ld	s3,8(sp)
     c70:	6145                	add	sp,sp,48
     c72:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c74:	85ce                	mv	a1,s3
     c76:	00005517          	auipc	a0,0x5
     c7a:	18250513          	add	a0,a0,386 # 5df8 <statistics+0x598>
     c7e:	00005097          	auipc	ra,0x5
     c82:	a44080e7          	jalr	-1468(ra) # 56c2 <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00004097          	auipc	ra,0x4
     c8c:	6d2080e7          	jalr	1746(ra) # 535a <exit>
    printf("%s: open unlinkread failed\n", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	18e50513          	add	a0,a0,398 # 5e20 <statistics+0x5c0>
     c9a:	00005097          	auipc	ra,0x5
     c9e:	a28080e7          	jalr	-1496(ra) # 56c2 <printf>
    exit(1);
     ca2:	4505                	li	a0,1
     ca4:	00004097          	auipc	ra,0x4
     ca8:	6b6080e7          	jalr	1718(ra) # 535a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cac:	85ce                	mv	a1,s3
     cae:	00005517          	auipc	a0,0x5
     cb2:	19250513          	add	a0,a0,402 # 5e40 <statistics+0x5e0>
     cb6:	00005097          	auipc	ra,0x5
     cba:	a0c080e7          	jalr	-1524(ra) # 56c2 <printf>
    exit(1);
     cbe:	4505                	li	a0,1
     cc0:	00004097          	auipc	ra,0x4
     cc4:	69a080e7          	jalr	1690(ra) # 535a <exit>
    printf("%s: unlinkread read failed", s);
     cc8:	85ce                	mv	a1,s3
     cca:	00005517          	auipc	a0,0x5
     cce:	19e50513          	add	a0,a0,414 # 5e68 <statistics+0x608>
     cd2:	00005097          	auipc	ra,0x5
     cd6:	9f0080e7          	jalr	-1552(ra) # 56c2 <printf>
    exit(1);
     cda:	4505                	li	a0,1
     cdc:	00004097          	auipc	ra,0x4
     ce0:	67e080e7          	jalr	1662(ra) # 535a <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce4:	85ce                	mv	a1,s3
     ce6:	00005517          	auipc	a0,0x5
     cea:	1a250513          	add	a0,a0,418 # 5e88 <statistics+0x628>
     cee:	00005097          	auipc	ra,0x5
     cf2:	9d4080e7          	jalr	-1580(ra) # 56c2 <printf>
    exit(1);
     cf6:	4505                	li	a0,1
     cf8:	00004097          	auipc	ra,0x4
     cfc:	662080e7          	jalr	1634(ra) # 535a <exit>
    printf("%s: unlinkread write failed\n", s);
     d00:	85ce                	mv	a1,s3
     d02:	00005517          	auipc	a0,0x5
     d06:	1a650513          	add	a0,a0,422 # 5ea8 <statistics+0x648>
     d0a:	00005097          	auipc	ra,0x5
     d0e:	9b8080e7          	jalr	-1608(ra) # 56c2 <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00004097          	auipc	ra,0x4
     d18:	646080e7          	jalr	1606(ra) # 535a <exit>

0000000000000d1c <linktest>:
{
     d1c:	1101                	add	sp,sp,-32
     d1e:	ec06                	sd	ra,24(sp)
     d20:	e822                	sd	s0,16(sp)
     d22:	e426                	sd	s1,8(sp)
     d24:	e04a                	sd	s2,0(sp)
     d26:	1000                	add	s0,sp,32
     d28:	892a                	mv	s2,a0
  unlink("lf1");
     d2a:	00005517          	auipc	a0,0x5
     d2e:	19e50513          	add	a0,a0,414 # 5ec8 <statistics+0x668>
     d32:	00004097          	auipc	ra,0x4
     d36:	678080e7          	jalr	1656(ra) # 53aa <unlink>
  unlink("lf2");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	19650513          	add	a0,a0,406 # 5ed0 <statistics+0x670>
     d42:	00004097          	auipc	ra,0x4
     d46:	668080e7          	jalr	1640(ra) # 53aa <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4a:	20200593          	li	a1,514
     d4e:	00005517          	auipc	a0,0x5
     d52:	17a50513          	add	a0,a0,378 # 5ec8 <statistics+0x668>
     d56:	00004097          	auipc	ra,0x4
     d5a:	644080e7          	jalr	1604(ra) # 539a <open>
  if(fd < 0){
     d5e:	10054763          	bltz	a0,e6c <linktest+0x150>
     d62:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d64:	4615                	li	a2,5
     d66:	00005597          	auipc	a1,0x5
     d6a:	0b258593          	add	a1,a1,178 # 5e18 <statistics+0x5b8>
     d6e:	00004097          	auipc	ra,0x4
     d72:	60c080e7          	jalr	1548(ra) # 537a <write>
     d76:	4795                	li	a5,5
     d78:	10f51863          	bne	a0,a5,e88 <linktest+0x16c>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00004097          	auipc	ra,0x4
     d82:	604080e7          	jalr	1540(ra) # 5382 <close>
  if(link("lf1", "lf2") < 0){
     d86:	00005597          	auipc	a1,0x5
     d8a:	14a58593          	add	a1,a1,330 # 5ed0 <statistics+0x670>
     d8e:	00005517          	auipc	a0,0x5
     d92:	13a50513          	add	a0,a0,314 # 5ec8 <statistics+0x668>
     d96:	00004097          	auipc	ra,0x4
     d9a:	624080e7          	jalr	1572(ra) # 53ba <link>
     d9e:	10054363          	bltz	a0,ea4 <linktest+0x188>
  unlink("lf1");
     da2:	00005517          	auipc	a0,0x5
     da6:	12650513          	add	a0,a0,294 # 5ec8 <statistics+0x668>
     daa:	00004097          	auipc	ra,0x4
     dae:	600080e7          	jalr	1536(ra) # 53aa <unlink>
  if(open("lf1", 0) >= 0){
     db2:	4581                	li	a1,0
     db4:	00005517          	auipc	a0,0x5
     db8:	11450513          	add	a0,a0,276 # 5ec8 <statistics+0x668>
     dbc:	00004097          	auipc	ra,0x4
     dc0:	5de080e7          	jalr	1502(ra) # 539a <open>
     dc4:	0e055e63          	bgez	a0,ec0 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc8:	4581                	li	a1,0
     dca:	00005517          	auipc	a0,0x5
     dce:	10650513          	add	a0,a0,262 # 5ed0 <statistics+0x670>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	5c8080e7          	jalr	1480(ra) # 539a <open>
     dda:	84aa                	mv	s1,a0
  if(fd < 0){
     ddc:	10054063          	bltz	a0,edc <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000b597          	auipc	a1,0xb
     de6:	a2658593          	add	a1,a1,-1498 # b808 <buf>
     dea:	00004097          	auipc	ra,0x4
     dee:	588080e7          	jalr	1416(ra) # 5372 <read>
     df2:	4795                	li	a5,5
     df4:	10f51263          	bne	a0,a5,ef8 <linktest+0x1dc>
  close(fd);
     df8:	8526                	mv	a0,s1
     dfa:	00004097          	auipc	ra,0x4
     dfe:	588080e7          	jalr	1416(ra) # 5382 <close>
  if(link("lf2", "lf2") >= 0){
     e02:	00005597          	auipc	a1,0x5
     e06:	0ce58593          	add	a1,a1,206 # 5ed0 <statistics+0x670>
     e0a:	852e                	mv	a0,a1
     e0c:	00004097          	auipc	ra,0x4
     e10:	5ae080e7          	jalr	1454(ra) # 53ba <link>
     e14:	10055063          	bgez	a0,f14 <linktest+0x1f8>
  unlink("lf2");
     e18:	00005517          	auipc	a0,0x5
     e1c:	0b850513          	add	a0,a0,184 # 5ed0 <statistics+0x670>
     e20:	00004097          	auipc	ra,0x4
     e24:	58a080e7          	jalr	1418(ra) # 53aa <unlink>
  if(link("lf2", "lf1") >= 0){
     e28:	00005597          	auipc	a1,0x5
     e2c:	0a058593          	add	a1,a1,160 # 5ec8 <statistics+0x668>
     e30:	00005517          	auipc	a0,0x5
     e34:	0a050513          	add	a0,a0,160 # 5ed0 <statistics+0x670>
     e38:	00004097          	auipc	ra,0x4
     e3c:	582080e7          	jalr	1410(ra) # 53ba <link>
     e40:	0e055863          	bgez	a0,f30 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e44:	00005597          	auipc	a1,0x5
     e48:	08458593          	add	a1,a1,132 # 5ec8 <statistics+0x668>
     e4c:	00005517          	auipc	a0,0x5
     e50:	18c50513          	add	a0,a0,396 # 5fd8 <statistics+0x778>
     e54:	00004097          	auipc	ra,0x4
     e58:	566080e7          	jalr	1382(ra) # 53ba <link>
     e5c:	0e055863          	bgez	a0,f4c <linktest+0x230>
}
     e60:	60e2                	ld	ra,24(sp)
     e62:	6442                	ld	s0,16(sp)
     e64:	64a2                	ld	s1,8(sp)
     e66:	6902                	ld	s2,0(sp)
     e68:	6105                	add	sp,sp,32
     e6a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6c:	85ca                	mv	a1,s2
     e6e:	00005517          	auipc	a0,0x5
     e72:	06a50513          	add	a0,a0,106 # 5ed8 <statistics+0x678>
     e76:	00005097          	auipc	ra,0x5
     e7a:	84c080e7          	jalr	-1972(ra) # 56c2 <printf>
    exit(1);
     e7e:	4505                	li	a0,1
     e80:	00004097          	auipc	ra,0x4
     e84:	4da080e7          	jalr	1242(ra) # 535a <exit>
    printf("%s: write lf1 failed\n", s);
     e88:	85ca                	mv	a1,s2
     e8a:	00005517          	auipc	a0,0x5
     e8e:	06650513          	add	a0,a0,102 # 5ef0 <statistics+0x690>
     e92:	00005097          	auipc	ra,0x5
     e96:	830080e7          	jalr	-2000(ra) # 56c2 <printf>
    exit(1);
     e9a:	4505                	li	a0,1
     e9c:	00004097          	auipc	ra,0x4
     ea0:	4be080e7          	jalr	1214(ra) # 535a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea4:	85ca                	mv	a1,s2
     ea6:	00005517          	auipc	a0,0x5
     eaa:	06250513          	add	a0,a0,98 # 5f08 <statistics+0x6a8>
     eae:	00005097          	auipc	ra,0x5
     eb2:	814080e7          	jalr	-2028(ra) # 56c2 <printf>
    exit(1);
     eb6:	4505                	li	a0,1
     eb8:	00004097          	auipc	ra,0x4
     ebc:	4a2080e7          	jalr	1186(ra) # 535a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec0:	85ca                	mv	a1,s2
     ec2:	00005517          	auipc	a0,0x5
     ec6:	06650513          	add	a0,a0,102 # 5f28 <statistics+0x6c8>
     eca:	00004097          	auipc	ra,0x4
     ece:	7f8080e7          	jalr	2040(ra) # 56c2 <printf>
    exit(1);
     ed2:	4505                	li	a0,1
     ed4:	00004097          	auipc	ra,0x4
     ed8:	486080e7          	jalr	1158(ra) # 535a <exit>
    printf("%s: open lf2 failed\n", s);
     edc:	85ca                	mv	a1,s2
     ede:	00005517          	auipc	a0,0x5
     ee2:	07a50513          	add	a0,a0,122 # 5f58 <statistics+0x6f8>
     ee6:	00004097          	auipc	ra,0x4
     eea:	7dc080e7          	jalr	2012(ra) # 56c2 <printf>
    exit(1);
     eee:	4505                	li	a0,1
     ef0:	00004097          	auipc	ra,0x4
     ef4:	46a080e7          	jalr	1130(ra) # 535a <exit>
    printf("%s: read lf2 failed\n", s);
     ef8:	85ca                	mv	a1,s2
     efa:	00005517          	auipc	a0,0x5
     efe:	07650513          	add	a0,a0,118 # 5f70 <statistics+0x710>
     f02:	00004097          	auipc	ra,0x4
     f06:	7c0080e7          	jalr	1984(ra) # 56c2 <printf>
    exit(1);
     f0a:	4505                	li	a0,1
     f0c:	00004097          	auipc	ra,0x4
     f10:	44e080e7          	jalr	1102(ra) # 535a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f14:	85ca                	mv	a1,s2
     f16:	00005517          	auipc	a0,0x5
     f1a:	07250513          	add	a0,a0,114 # 5f88 <statistics+0x728>
     f1e:	00004097          	auipc	ra,0x4
     f22:	7a4080e7          	jalr	1956(ra) # 56c2 <printf>
    exit(1);
     f26:	4505                	li	a0,1
     f28:	00004097          	auipc	ra,0x4
     f2c:	432080e7          	jalr	1074(ra) # 535a <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f30:	85ca                	mv	a1,s2
     f32:	00005517          	auipc	a0,0x5
     f36:	07e50513          	add	a0,a0,126 # 5fb0 <statistics+0x750>
     f3a:	00004097          	auipc	ra,0x4
     f3e:	788080e7          	jalr	1928(ra) # 56c2 <printf>
    exit(1);
     f42:	4505                	li	a0,1
     f44:	00004097          	auipc	ra,0x4
     f48:	416080e7          	jalr	1046(ra) # 535a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4c:	85ca                	mv	a1,s2
     f4e:	00005517          	auipc	a0,0x5
     f52:	09250513          	add	a0,a0,146 # 5fe0 <statistics+0x780>
     f56:	00004097          	auipc	ra,0x4
     f5a:	76c080e7          	jalr	1900(ra) # 56c2 <printf>
    exit(1);
     f5e:	4505                	li	a0,1
     f60:	00004097          	auipc	ra,0x4
     f64:	3fa080e7          	jalr	1018(ra) # 535a <exit>

0000000000000f68 <bigdir>:
{
     f68:	715d                	add	sp,sp,-80
     f6a:	e486                	sd	ra,72(sp)
     f6c:	e0a2                	sd	s0,64(sp)
     f6e:	fc26                	sd	s1,56(sp)
     f70:	f84a                	sd	s2,48(sp)
     f72:	f44e                	sd	s3,40(sp)
     f74:	f052                	sd	s4,32(sp)
     f76:	ec56                	sd	s5,24(sp)
     f78:	e85a                	sd	s6,16(sp)
     f7a:	0880                	add	s0,sp,80
     f7c:	89aa                	mv	s3,a0
  unlink("bd");
     f7e:	00005517          	auipc	a0,0x5
     f82:	08250513          	add	a0,a0,130 # 6000 <statistics+0x7a0>
     f86:	00004097          	auipc	ra,0x4
     f8a:	424080e7          	jalr	1060(ra) # 53aa <unlink>
  fd = open("bd", O_CREATE);
     f8e:	20000593          	li	a1,512
     f92:	00005517          	auipc	a0,0x5
     f96:	06e50513          	add	a0,a0,110 # 6000 <statistics+0x7a0>
     f9a:	00004097          	auipc	ra,0x4
     f9e:	400080e7          	jalr	1024(ra) # 539a <open>
  if(fd < 0){
     fa2:	0c054963          	bltz	a0,1074 <bigdir+0x10c>
  close(fd);
     fa6:	00004097          	auipc	ra,0x4
     faa:	3dc080e7          	jalr	988(ra) # 5382 <close>
  for(i = 0; i < N; i++){
     fae:	4901                	li	s2,0
    name[0] = 'x';
     fb0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb4:	00005a17          	auipc	s4,0x5
     fb8:	04ca0a13          	add	s4,s4,76 # 6000 <statistics+0x7a0>
  for(i = 0; i < N; i++){
     fbc:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc4:	41f9571b          	sraw	a4,s2,0x1f
     fc8:	01a7571b          	srlw	a4,a4,0x1a
     fcc:	012707bb          	addw	a5,a4,s2
     fd0:	4067d69b          	sraw	a3,a5,0x6
     fd4:	0306869b          	addw	a3,a3,48
     fd8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fdc:	03f7f793          	and	a5,a5,63
     fe0:	9f99                	subw	a5,a5,a4
     fe2:	0307879b          	addw	a5,a5,48
     fe6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fea:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fee:	fb040593          	add	a1,s0,-80
     ff2:	8552                	mv	a0,s4
     ff4:	00004097          	auipc	ra,0x4
     ff8:	3c6080e7          	jalr	966(ra) # 53ba <link>
     ffc:	84aa                	mv	s1,a0
     ffe:	e949                	bnez	a0,1090 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1000:	2905                	addw	s2,s2,1
    1002:	fb691fe3          	bne	s2,s6,fc0 <bigdir+0x58>
  unlink("bd");
    1006:	00005517          	auipc	a0,0x5
    100a:	ffa50513          	add	a0,a0,-6 # 6000 <statistics+0x7a0>
    100e:	00004097          	auipc	ra,0x4
    1012:	39c080e7          	jalr	924(ra) # 53aa <unlink>
    name[0] = 'x';
    1016:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101a:	1f400a13          	li	s4,500
    name[0] = 'x';
    101e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1022:	41f4d71b          	sraw	a4,s1,0x1f
    1026:	01a7571b          	srlw	a4,a4,0x1a
    102a:	009707bb          	addw	a5,a4,s1
    102e:	4067d69b          	sraw	a3,a5,0x6
    1032:	0306869b          	addw	a3,a3,48
    1036:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103a:	03f7f793          	and	a5,a5,63
    103e:	9f99                	subw	a5,a5,a4
    1040:	0307879b          	addw	a5,a5,48
    1044:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1048:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104c:	fb040513          	add	a0,s0,-80
    1050:	00004097          	auipc	ra,0x4
    1054:	35a080e7          	jalr	858(ra) # 53aa <unlink>
    1058:	ed21                	bnez	a0,10b0 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105a:	2485                	addw	s1,s1,1
    105c:	fd4491e3          	bne	s1,s4,101e <bigdir+0xb6>
}
    1060:	60a6                	ld	ra,72(sp)
    1062:	6406                	ld	s0,64(sp)
    1064:	74e2                	ld	s1,56(sp)
    1066:	7942                	ld	s2,48(sp)
    1068:	79a2                	ld	s3,40(sp)
    106a:	7a02                	ld	s4,32(sp)
    106c:	6ae2                	ld	s5,24(sp)
    106e:	6b42                	ld	s6,16(sp)
    1070:	6161                	add	sp,sp,80
    1072:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1074:	85ce                	mv	a1,s3
    1076:	00005517          	auipc	a0,0x5
    107a:	f9250513          	add	a0,a0,-110 # 6008 <statistics+0x7a8>
    107e:	00004097          	auipc	ra,0x4
    1082:	644080e7          	jalr	1604(ra) # 56c2 <printf>
    exit(1);
    1086:	4505                	li	a0,1
    1088:	00004097          	auipc	ra,0x4
    108c:	2d2080e7          	jalr	722(ra) # 535a <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1090:	fb040613          	add	a2,s0,-80
    1094:	85ce                	mv	a1,s3
    1096:	00005517          	auipc	a0,0x5
    109a:	f9250513          	add	a0,a0,-110 # 6028 <statistics+0x7c8>
    109e:	00004097          	auipc	ra,0x4
    10a2:	624080e7          	jalr	1572(ra) # 56c2 <printf>
      exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00004097          	auipc	ra,0x4
    10ac:	2b2080e7          	jalr	690(ra) # 535a <exit>
      printf("%s: bigdir unlink failed", s);
    10b0:	85ce                	mv	a1,s3
    10b2:	00005517          	auipc	a0,0x5
    10b6:	f9650513          	add	a0,a0,-106 # 6048 <statistics+0x7e8>
    10ba:	00004097          	auipc	ra,0x4
    10be:	608080e7          	jalr	1544(ra) # 56c2 <printf>
      exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00004097          	auipc	ra,0x4
    10c8:	296080e7          	jalr	662(ra) # 535a <exit>

00000000000010cc <validatetest>:
{
    10cc:	7139                	add	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	e05a                	sd	s6,0(sp)
    10de:	0080                	add	s0,sp,64
    10e0:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e2:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e4:	00005997          	auipc	s3,0x5
    10e8:	f8498993          	add	s3,s3,-124 # 6068 <statistics+0x808>
    10ec:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ee:	6a85                	lui	s5,0x1
    10f0:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f4:	85a6                	mv	a1,s1
    10f6:	854e                	mv	a0,s3
    10f8:	00004097          	auipc	ra,0x4
    10fc:	2c2080e7          	jalr	706(ra) # 53ba <link>
    1100:	01251f63          	bne	a0,s2,111e <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1104:	94d6                	add	s1,s1,s5
    1106:	ff4497e3          	bne	s1,s4,10f4 <validatetest+0x28>
}
    110a:	70e2                	ld	ra,56(sp)
    110c:	7442                	ld	s0,48(sp)
    110e:	74a2                	ld	s1,40(sp)
    1110:	7902                	ld	s2,32(sp)
    1112:	69e2                	ld	s3,24(sp)
    1114:	6a42                	ld	s4,16(sp)
    1116:	6aa2                	ld	s5,8(sp)
    1118:	6b02                	ld	s6,0(sp)
    111a:	6121                	add	sp,sp,64
    111c:	8082                	ret
      printf("%s: link should not succeed\n", s);
    111e:	85da                	mv	a1,s6
    1120:	00005517          	auipc	a0,0x5
    1124:	f5850513          	add	a0,a0,-168 # 6078 <statistics+0x818>
    1128:	00004097          	auipc	ra,0x4
    112c:	59a080e7          	jalr	1434(ra) # 56c2 <printf>
      exit(1);
    1130:	4505                	li	a0,1
    1132:	00004097          	auipc	ra,0x4
    1136:	228080e7          	jalr	552(ra) # 535a <exit>

000000000000113a <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113a:	7179                	add	sp,sp,-48
    113c:	f406                	sd	ra,40(sp)
    113e:	f022                	sd	s0,32(sp)
    1140:	ec26                	sd	s1,24(sp)
    1142:	1800                	add	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1144:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1148:	00007497          	auipc	s1,0x7
    114c:	e884b483          	ld	s1,-376(s1) # 7fd0 <__SDATA_BEGIN__>
    1150:	fd840593          	add	a1,s0,-40
    1154:	8526                	mv	a0,s1
    1156:	00004097          	auipc	ra,0x4
    115a:	23c080e7          	jalr	572(ra) # 5392 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115e:	8526                	mv	a0,s1
    1160:	00004097          	auipc	ra,0x4
    1164:	20a080e7          	jalr	522(ra) # 536a <pipe>

  exit(0);
    1168:	4501                	li	a0,0
    116a:	00004097          	auipc	ra,0x4
    116e:	1f0080e7          	jalr	496(ra) # 535a <exit>

0000000000001172 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1172:	7139                	add	sp,sp,-64
    1174:	fc06                	sd	ra,56(sp)
    1176:	f822                	sd	s0,48(sp)
    1178:	f426                	sd	s1,40(sp)
    117a:	f04a                	sd	s2,32(sp)
    117c:	ec4e                	sd	s3,24(sp)
    117e:	0080                	add	s0,sp,64
    1180:	64b1                	lui	s1,0xc
    1182:	35048493          	add	s1,s1,848 # c350 <buf+0xb48>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1186:	597d                	li	s2,-1
    1188:	02095913          	srl	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118c:	00004997          	auipc	s3,0x4
    1190:	79498993          	add	s3,s3,1940 # 5920 <statistics+0xc0>
    argv[0] = (char*)0xffffffff;
    1194:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1198:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119c:	fc040593          	add	a1,s0,-64
    11a0:	854e                	mv	a0,s3
    11a2:	00004097          	auipc	ra,0x4
    11a6:	1f0080e7          	jalr	496(ra) # 5392 <exec>
  for(int i = 0; i < 50000; i++){
    11aa:	34fd                	addw	s1,s1,-1
    11ac:	f4e5                	bnez	s1,1194 <badarg+0x22>
  }
  
  exit(0);
    11ae:	4501                	li	a0,0
    11b0:	00004097          	auipc	ra,0x4
    11b4:	1aa080e7          	jalr	426(ra) # 535a <exit>

00000000000011b8 <copyinstr2>:
{
    11b8:	7155                	add	sp,sp,-208
    11ba:	e586                	sd	ra,200(sp)
    11bc:	e1a2                	sd	s0,192(sp)
    11be:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c0:	f6840793          	add	a5,s0,-152
    11c4:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    11c8:	07800713          	li	a4,120
    11cc:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d0:	0785                	add	a5,a5,1
    11d2:	fed79de3          	bne	a5,a3,11cc <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11da:	f6840513          	add	a0,s0,-152
    11de:	00004097          	auipc	ra,0x4
    11e2:	1cc080e7          	jalr	460(ra) # 53aa <unlink>
  if(ret != -1){
    11e6:	57fd                	li	a5,-1
    11e8:	0ef51063          	bne	a0,a5,12c8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ec:	20100593          	li	a1,513
    11f0:	f6840513          	add	a0,s0,-152
    11f4:	00004097          	auipc	ra,0x4
    11f8:	1a6080e7          	jalr	422(ra) # 539a <open>
  if(fd != -1){
    11fc:	57fd                	li	a5,-1
    11fe:	0ef51563          	bne	a0,a5,12e8 <copyinstr2+0x130>
  ret = link(b, b);
    1202:	f6840593          	add	a1,s0,-152
    1206:	852e                	mv	a0,a1
    1208:	00004097          	auipc	ra,0x4
    120c:	1b2080e7          	jalr	434(ra) # 53ba <link>
  if(ret != -1){
    1210:	57fd                	li	a5,-1
    1212:	0ef51b63          	bne	a0,a5,1308 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1216:	00006797          	auipc	a5,0x6
    121a:	f2a78793          	add	a5,a5,-214 # 7140 <statistics+0x18e0>
    121e:	f4f43c23          	sd	a5,-168(s0)
    1222:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1226:	f5840593          	add	a1,s0,-168
    122a:	f6840513          	add	a0,s0,-152
    122e:	00004097          	auipc	ra,0x4
    1232:	164080e7          	jalr	356(ra) # 5392 <exec>
  if(ret != -1){
    1236:	57fd                	li	a5,-1
    1238:	0ef51963          	bne	a0,a5,132a <copyinstr2+0x172>
  int pid = fork();
    123c:	00004097          	auipc	ra,0x4
    1240:	116080e7          	jalr	278(ra) # 5352 <fork>
  if(pid < 0){
    1244:	10054363          	bltz	a0,134a <copyinstr2+0x192>
  if(pid == 0){
    1248:	12051463          	bnez	a0,1370 <copyinstr2+0x1b8>
    124c:	00007797          	auipc	a5,0x7
    1250:	ea478793          	add	a5,a5,-348 # 80f0 <big.0>
    1254:	00008697          	auipc	a3,0x8
    1258:	e9c68693          	add	a3,a3,-356 # 90f0 <__global_pointer$+0x920>
      big[i] = 'x';
    125c:	07800713          	li	a4,120
    1260:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1264:	0785                	add	a5,a5,1
    1266:	fed79de3          	bne	a5,a3,1260 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126a:	00008797          	auipc	a5,0x8
    126e:	e8078323          	sb	zero,-378(a5) # 90f0 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1272:	00007797          	auipc	a5,0x7
    1276:	91e78793          	add	a5,a5,-1762 # 7b90 <statistics+0x2330>
    127a:	6390                	ld	a2,0(a5)
    127c:	6794                	ld	a3,8(a5)
    127e:	6b98                	ld	a4,16(a5)
    1280:	6f9c                	ld	a5,24(a5)
    1282:	f2c43823          	sd	a2,-208(s0)
    1286:	f2d43c23          	sd	a3,-200(s0)
    128a:	f4e43023          	sd	a4,-192(s0)
    128e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1292:	f3040593          	add	a1,s0,-208
    1296:	00004517          	auipc	a0,0x4
    129a:	68a50513          	add	a0,a0,1674 # 5920 <statistics+0xc0>
    129e:	00004097          	auipc	ra,0x4
    12a2:	0f4080e7          	jalr	244(ra) # 5392 <exec>
    if(ret != -1){
    12a6:	57fd                	li	a5,-1
    12a8:	0af50e63          	beq	a0,a5,1364 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ac:	55fd                	li	a1,-1
    12ae:	00005517          	auipc	a0,0x5
    12b2:	e7250513          	add	a0,a0,-398 # 6120 <statistics+0x8c0>
    12b6:	00004097          	auipc	ra,0x4
    12ba:	40c080e7          	jalr	1036(ra) # 56c2 <printf>
      exit(1);
    12be:	4505                	li	a0,1
    12c0:	00004097          	auipc	ra,0x4
    12c4:	09a080e7          	jalr	154(ra) # 535a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c8:	862a                	mv	a2,a0
    12ca:	f6840593          	add	a1,s0,-152
    12ce:	00005517          	auipc	a0,0x5
    12d2:	dca50513          	add	a0,a0,-566 # 6098 <statistics+0x838>
    12d6:	00004097          	auipc	ra,0x4
    12da:	3ec080e7          	jalr	1004(ra) # 56c2 <printf>
    exit(1);
    12de:	4505                	li	a0,1
    12e0:	00004097          	auipc	ra,0x4
    12e4:	07a080e7          	jalr	122(ra) # 535a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e8:	862a                	mv	a2,a0
    12ea:	f6840593          	add	a1,s0,-152
    12ee:	00005517          	auipc	a0,0x5
    12f2:	dca50513          	add	a0,a0,-566 # 60b8 <statistics+0x858>
    12f6:	00004097          	auipc	ra,0x4
    12fa:	3cc080e7          	jalr	972(ra) # 56c2 <printf>
    exit(1);
    12fe:	4505                	li	a0,1
    1300:	00004097          	auipc	ra,0x4
    1304:	05a080e7          	jalr	90(ra) # 535a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1308:	86aa                	mv	a3,a0
    130a:	f6840613          	add	a2,s0,-152
    130e:	85b2                	mv	a1,a2
    1310:	00005517          	auipc	a0,0x5
    1314:	dc850513          	add	a0,a0,-568 # 60d8 <statistics+0x878>
    1318:	00004097          	auipc	ra,0x4
    131c:	3aa080e7          	jalr	938(ra) # 56c2 <printf>
    exit(1);
    1320:	4505                	li	a0,1
    1322:	00004097          	auipc	ra,0x4
    1326:	038080e7          	jalr	56(ra) # 535a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132a:	567d                	li	a2,-1
    132c:	f6840593          	add	a1,s0,-152
    1330:	00005517          	auipc	a0,0x5
    1334:	dd050513          	add	a0,a0,-560 # 6100 <statistics+0x8a0>
    1338:	00004097          	auipc	ra,0x4
    133c:	38a080e7          	jalr	906(ra) # 56c2 <printf>
    exit(1);
    1340:	4505                	li	a0,1
    1342:	00004097          	auipc	ra,0x4
    1346:	018080e7          	jalr	24(ra) # 535a <exit>
    printf("fork failed\n");
    134a:	00005517          	auipc	a0,0x5
    134e:	21e50513          	add	a0,a0,542 # 6568 <statistics+0xd08>
    1352:	00004097          	auipc	ra,0x4
    1356:	370080e7          	jalr	880(ra) # 56c2 <printf>
    exit(1);
    135a:	4505                	li	a0,1
    135c:	00004097          	auipc	ra,0x4
    1360:	ffe080e7          	jalr	-2(ra) # 535a <exit>
    exit(747); // OK
    1364:	2eb00513          	li	a0,747
    1368:	00004097          	auipc	ra,0x4
    136c:	ff2080e7          	jalr	-14(ra) # 535a <exit>
  int st = 0;
    1370:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1374:	f5440513          	add	a0,s0,-172
    1378:	00004097          	auipc	ra,0x4
    137c:	fea080e7          	jalr	-22(ra) # 5362 <wait>
  if(st != 747){
    1380:	f5442703          	lw	a4,-172(s0)
    1384:	2eb00793          	li	a5,747
    1388:	00f71663          	bne	a4,a5,1394 <copyinstr2+0x1dc>
}
    138c:	60ae                	ld	ra,200(sp)
    138e:	640e                	ld	s0,192(sp)
    1390:	6169                	add	sp,sp,208
    1392:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1394:	00005517          	auipc	a0,0x5
    1398:	db450513          	add	a0,a0,-588 # 6148 <statistics+0x8e8>
    139c:	00004097          	auipc	ra,0x4
    13a0:	326080e7          	jalr	806(ra) # 56c2 <printf>
    exit(1);
    13a4:	4505                	li	a0,1
    13a6:	00004097          	auipc	ra,0x4
    13aa:	fb4080e7          	jalr	-76(ra) # 535a <exit>

00000000000013ae <truncate3>:
{
    13ae:	7159                	add	sp,sp,-112
    13b0:	f486                	sd	ra,104(sp)
    13b2:	f0a2                	sd	s0,96(sp)
    13b4:	eca6                	sd	s1,88(sp)
    13b6:	e8ca                	sd	s2,80(sp)
    13b8:	e4ce                	sd	s3,72(sp)
    13ba:	e0d2                	sd	s4,64(sp)
    13bc:	fc56                	sd	s5,56(sp)
    13be:	1880                	add	s0,sp,112
    13c0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c2:	60100593          	li	a1,1537
    13c6:	00004517          	auipc	a0,0x4
    13ca:	5b250513          	add	a0,a0,1458 # 5978 <statistics+0x118>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	fcc080e7          	jalr	-52(ra) # 539a <open>
    13d6:	00004097          	auipc	ra,0x4
    13da:	fac080e7          	jalr	-84(ra) # 5382 <close>
  pid = fork();
    13de:	00004097          	auipc	ra,0x4
    13e2:	f74080e7          	jalr	-140(ra) # 5352 <fork>
  if(pid < 0){
    13e6:	08054063          	bltz	a0,1466 <truncate3+0xb8>
  if(pid == 0){
    13ea:	e969                	bnez	a0,14bc <truncate3+0x10e>
    13ec:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f0:	00004a17          	auipc	s4,0x4
    13f4:	588a0a13          	add	s4,s4,1416 # 5978 <statistics+0x118>
      int n = write(fd, "1234567890", 10);
    13f8:	00005a97          	auipc	s5,0x5
    13fc:	db0a8a93          	add	s5,s5,-592 # 61a8 <statistics+0x948>
      int fd = open("truncfile", O_WRONLY);
    1400:	4585                	li	a1,1
    1402:	8552                	mv	a0,s4
    1404:	00004097          	auipc	ra,0x4
    1408:	f96080e7          	jalr	-106(ra) # 539a <open>
    140c:	84aa                	mv	s1,a0
      if(fd < 0){
    140e:	06054a63          	bltz	a0,1482 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1412:	4629                	li	a2,10
    1414:	85d6                	mv	a1,s5
    1416:	00004097          	auipc	ra,0x4
    141a:	f64080e7          	jalr	-156(ra) # 537a <write>
      if(n != 10){
    141e:	47a9                	li	a5,10
    1420:	06f51f63          	bne	a0,a5,149e <truncate3+0xf0>
      close(fd);
    1424:	8526                	mv	a0,s1
    1426:	00004097          	auipc	ra,0x4
    142a:	f5c080e7          	jalr	-164(ra) # 5382 <close>
      fd = open("truncfile", O_RDONLY);
    142e:	4581                	li	a1,0
    1430:	8552                	mv	a0,s4
    1432:	00004097          	auipc	ra,0x4
    1436:	f68080e7          	jalr	-152(ra) # 539a <open>
    143a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143c:	02000613          	li	a2,32
    1440:	f9840593          	add	a1,s0,-104
    1444:	00004097          	auipc	ra,0x4
    1448:	f2e080e7          	jalr	-210(ra) # 5372 <read>
      close(fd);
    144c:	8526                	mv	a0,s1
    144e:	00004097          	auipc	ra,0x4
    1452:	f34080e7          	jalr	-204(ra) # 5382 <close>
    for(int i = 0; i < 100; i++){
    1456:	39fd                	addw	s3,s3,-1
    1458:	fa0994e3          	bnez	s3,1400 <truncate3+0x52>
    exit(0);
    145c:	4501                	li	a0,0
    145e:	00004097          	auipc	ra,0x4
    1462:	efc080e7          	jalr	-260(ra) # 535a <exit>
    printf("%s: fork failed\n", s);
    1466:	85ca                	mv	a1,s2
    1468:	00005517          	auipc	a0,0x5
    146c:	d1050513          	add	a0,a0,-752 # 6178 <statistics+0x918>
    1470:	00004097          	auipc	ra,0x4
    1474:	252080e7          	jalr	594(ra) # 56c2 <printf>
    exit(1);
    1478:	4505                	li	a0,1
    147a:	00004097          	auipc	ra,0x4
    147e:	ee0080e7          	jalr	-288(ra) # 535a <exit>
        printf("%s: open failed\n", s);
    1482:	85ca                	mv	a1,s2
    1484:	00005517          	auipc	a0,0x5
    1488:	d0c50513          	add	a0,a0,-756 # 6190 <statistics+0x930>
    148c:	00004097          	auipc	ra,0x4
    1490:	236080e7          	jalr	566(ra) # 56c2 <printf>
        exit(1);
    1494:	4505                	li	a0,1
    1496:	00004097          	auipc	ra,0x4
    149a:	ec4080e7          	jalr	-316(ra) # 535a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149e:	862a                	mv	a2,a0
    14a0:	85ca                	mv	a1,s2
    14a2:	00005517          	auipc	a0,0x5
    14a6:	d1650513          	add	a0,a0,-746 # 61b8 <statistics+0x958>
    14aa:	00004097          	auipc	ra,0x4
    14ae:	218080e7          	jalr	536(ra) # 56c2 <printf>
        exit(1);
    14b2:	4505                	li	a0,1
    14b4:	00004097          	auipc	ra,0x4
    14b8:	ea6080e7          	jalr	-346(ra) # 535a <exit>
    14bc:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c0:	00004a17          	auipc	s4,0x4
    14c4:	4b8a0a13          	add	s4,s4,1208 # 5978 <statistics+0x118>
    int n = write(fd, "xxx", 3);
    14c8:	00005a97          	auipc	s5,0x5
    14cc:	d10a8a93          	add	s5,s5,-752 # 61d8 <statistics+0x978>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d0:	60100593          	li	a1,1537
    14d4:	8552                	mv	a0,s4
    14d6:	00004097          	auipc	ra,0x4
    14da:	ec4080e7          	jalr	-316(ra) # 539a <open>
    14de:	84aa                	mv	s1,a0
    if(fd < 0){
    14e0:	04054763          	bltz	a0,152e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e4:	460d                	li	a2,3
    14e6:	85d6                	mv	a1,s5
    14e8:	00004097          	auipc	ra,0x4
    14ec:	e92080e7          	jalr	-366(ra) # 537a <write>
    if(n != 3){
    14f0:	478d                	li	a5,3
    14f2:	04f51c63          	bne	a0,a5,154a <truncate3+0x19c>
    close(fd);
    14f6:	8526                	mv	a0,s1
    14f8:	00004097          	auipc	ra,0x4
    14fc:	e8a080e7          	jalr	-374(ra) # 5382 <close>
  for(int i = 0; i < 150; i++){
    1500:	39fd                	addw	s3,s3,-1
    1502:	fc0997e3          	bnez	s3,14d0 <truncate3+0x122>
  wait(&xstatus);
    1506:	fbc40513          	add	a0,s0,-68
    150a:	00004097          	auipc	ra,0x4
    150e:	e58080e7          	jalr	-424(ra) # 5362 <wait>
  unlink("truncfile");
    1512:	00004517          	auipc	a0,0x4
    1516:	46650513          	add	a0,a0,1126 # 5978 <statistics+0x118>
    151a:	00004097          	auipc	ra,0x4
    151e:	e90080e7          	jalr	-368(ra) # 53aa <unlink>
  exit(xstatus);
    1522:	fbc42503          	lw	a0,-68(s0)
    1526:	00004097          	auipc	ra,0x4
    152a:	e34080e7          	jalr	-460(ra) # 535a <exit>
      printf("%s: open failed\n", s);
    152e:	85ca                	mv	a1,s2
    1530:	00005517          	auipc	a0,0x5
    1534:	c6050513          	add	a0,a0,-928 # 6190 <statistics+0x930>
    1538:	00004097          	auipc	ra,0x4
    153c:	18a080e7          	jalr	394(ra) # 56c2 <printf>
      exit(1);
    1540:	4505                	li	a0,1
    1542:	00004097          	auipc	ra,0x4
    1546:	e18080e7          	jalr	-488(ra) # 535a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154a:	862a                	mv	a2,a0
    154c:	85ca                	mv	a1,s2
    154e:	00005517          	auipc	a0,0x5
    1552:	c9250513          	add	a0,a0,-878 # 61e0 <statistics+0x980>
    1556:	00004097          	auipc	ra,0x4
    155a:	16c080e7          	jalr	364(ra) # 56c2 <printf>
      exit(1);
    155e:	4505                	li	a0,1
    1560:	00004097          	auipc	ra,0x4
    1564:	dfa080e7          	jalr	-518(ra) # 535a <exit>

0000000000001568 <exectest>:
{
    1568:	715d                	add	sp,sp,-80
    156a:	e486                	sd	ra,72(sp)
    156c:	e0a2                	sd	s0,64(sp)
    156e:	fc26                	sd	s1,56(sp)
    1570:	f84a                	sd	s2,48(sp)
    1572:	0880                	add	s0,sp,80
    1574:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1576:	00004797          	auipc	a5,0x4
    157a:	3aa78793          	add	a5,a5,938 # 5920 <statistics+0xc0>
    157e:	fcf43023          	sd	a5,-64(s0)
    1582:	00005797          	auipc	a5,0x5
    1586:	c7e78793          	add	a5,a5,-898 # 6200 <statistics+0x9a0>
    158a:	fcf43423          	sd	a5,-56(s0)
    158e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1592:	00005517          	auipc	a0,0x5
    1596:	c7650513          	add	a0,a0,-906 # 6208 <statistics+0x9a8>
    159a:	00004097          	auipc	ra,0x4
    159e:	e10080e7          	jalr	-496(ra) # 53aa <unlink>
  pid = fork();
    15a2:	00004097          	auipc	ra,0x4
    15a6:	db0080e7          	jalr	-592(ra) # 5352 <fork>
  if(pid < 0) {
    15aa:	04054663          	bltz	a0,15f6 <exectest+0x8e>
    15ae:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b0:	e959                	bnez	a0,1646 <exectest+0xde>
    close(1);
    15b2:	4505                	li	a0,1
    15b4:	00004097          	auipc	ra,0x4
    15b8:	dce080e7          	jalr	-562(ra) # 5382 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15bc:	20100593          	li	a1,513
    15c0:	00005517          	auipc	a0,0x5
    15c4:	c4850513          	add	a0,a0,-952 # 6208 <statistics+0x9a8>
    15c8:	00004097          	auipc	ra,0x4
    15cc:	dd2080e7          	jalr	-558(ra) # 539a <open>
    if(fd < 0) {
    15d0:	04054163          	bltz	a0,1612 <exectest+0xaa>
    if(fd != 1) {
    15d4:	4785                	li	a5,1
    15d6:	04f50c63          	beq	a0,a5,162e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15da:	85ca                	mv	a1,s2
    15dc:	00005517          	auipc	a0,0x5
    15e0:	c4c50513          	add	a0,a0,-948 # 6228 <statistics+0x9c8>
    15e4:	00004097          	auipc	ra,0x4
    15e8:	0de080e7          	jalr	222(ra) # 56c2 <printf>
      exit(1);
    15ec:	4505                	li	a0,1
    15ee:	00004097          	auipc	ra,0x4
    15f2:	d6c080e7          	jalr	-660(ra) # 535a <exit>
     printf("%s: fork failed\n", s);
    15f6:	85ca                	mv	a1,s2
    15f8:	00005517          	auipc	a0,0x5
    15fc:	b8050513          	add	a0,a0,-1152 # 6178 <statistics+0x918>
    1600:	00004097          	auipc	ra,0x4
    1604:	0c2080e7          	jalr	194(ra) # 56c2 <printf>
     exit(1);
    1608:	4505                	li	a0,1
    160a:	00004097          	auipc	ra,0x4
    160e:	d50080e7          	jalr	-688(ra) # 535a <exit>
      printf("%s: create failed\n", s);
    1612:	85ca                	mv	a1,s2
    1614:	00005517          	auipc	a0,0x5
    1618:	bfc50513          	add	a0,a0,-1028 # 6210 <statistics+0x9b0>
    161c:	00004097          	auipc	ra,0x4
    1620:	0a6080e7          	jalr	166(ra) # 56c2 <printf>
      exit(1);
    1624:	4505                	li	a0,1
    1626:	00004097          	auipc	ra,0x4
    162a:	d34080e7          	jalr	-716(ra) # 535a <exit>
    if(exec("echo", echoargv) < 0){
    162e:	fc040593          	add	a1,s0,-64
    1632:	00004517          	auipc	a0,0x4
    1636:	2ee50513          	add	a0,a0,750 # 5920 <statistics+0xc0>
    163a:	00004097          	auipc	ra,0x4
    163e:	d58080e7          	jalr	-680(ra) # 5392 <exec>
    1642:	02054163          	bltz	a0,1664 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1646:	fdc40513          	add	a0,s0,-36
    164a:	00004097          	auipc	ra,0x4
    164e:	d18080e7          	jalr	-744(ra) # 5362 <wait>
    1652:	02951763          	bne	a0,s1,1680 <exectest+0x118>
  if(xstatus != 0)
    1656:	fdc42503          	lw	a0,-36(s0)
    165a:	cd0d                	beqz	a0,1694 <exectest+0x12c>
    exit(xstatus);
    165c:	00004097          	auipc	ra,0x4
    1660:	cfe080e7          	jalr	-770(ra) # 535a <exit>
      printf("%s: exec echo failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	bd250513          	add	a0,a0,-1070 # 6238 <statistics+0x9d8>
    166e:	00004097          	auipc	ra,0x4
    1672:	054080e7          	jalr	84(ra) # 56c2 <printf>
      exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	ce2080e7          	jalr	-798(ra) # 535a <exit>
    printf("%s: wait failed!\n", s);
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	bce50513          	add	a0,a0,-1074 # 6250 <statistics+0x9f0>
    168a:	00004097          	auipc	ra,0x4
    168e:	038080e7          	jalr	56(ra) # 56c2 <printf>
    1692:	b7d1                	j	1656 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1694:	4581                	li	a1,0
    1696:	00005517          	auipc	a0,0x5
    169a:	b7250513          	add	a0,a0,-1166 # 6208 <statistics+0x9a8>
    169e:	00004097          	auipc	ra,0x4
    16a2:	cfc080e7          	jalr	-772(ra) # 539a <open>
  if(fd < 0) {
    16a6:	02054a63          	bltz	a0,16da <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16aa:	4609                	li	a2,2
    16ac:	fb840593          	add	a1,s0,-72
    16b0:	00004097          	auipc	ra,0x4
    16b4:	cc2080e7          	jalr	-830(ra) # 5372 <read>
    16b8:	4789                	li	a5,2
    16ba:	02f50e63          	beq	a0,a5,16f6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16be:	85ca                	mv	a1,s2
    16c0:	00004517          	auipc	a0,0x4
    16c4:	60050513          	add	a0,a0,1536 # 5cc0 <statistics+0x460>
    16c8:	00004097          	auipc	ra,0x4
    16cc:	ffa080e7          	jalr	-6(ra) # 56c2 <printf>
    exit(1);
    16d0:	4505                	li	a0,1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	c88080e7          	jalr	-888(ra) # 535a <exit>
    printf("%s: open failed\n", s);
    16da:	85ca                	mv	a1,s2
    16dc:	00005517          	auipc	a0,0x5
    16e0:	ab450513          	add	a0,a0,-1356 # 6190 <statistics+0x930>
    16e4:	00004097          	auipc	ra,0x4
    16e8:	fde080e7          	jalr	-34(ra) # 56c2 <printf>
    exit(1);
    16ec:	4505                	li	a0,1
    16ee:	00004097          	auipc	ra,0x4
    16f2:	c6c080e7          	jalr	-916(ra) # 535a <exit>
  unlink("echo-ok");
    16f6:	00005517          	auipc	a0,0x5
    16fa:	b1250513          	add	a0,a0,-1262 # 6208 <statistics+0x9a8>
    16fe:	00004097          	auipc	ra,0x4
    1702:	cac080e7          	jalr	-852(ra) # 53aa <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1706:	fb844703          	lbu	a4,-72(s0)
    170a:	04f00793          	li	a5,79
    170e:	00f71863          	bne	a4,a5,171e <exectest+0x1b6>
    1712:	fb944703          	lbu	a4,-71(s0)
    1716:	04b00793          	li	a5,75
    171a:	02f70063          	beq	a4,a5,173a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    171e:	85ca                	mv	a1,s2
    1720:	00005517          	auipc	a0,0x5
    1724:	b4850513          	add	a0,a0,-1208 # 6268 <statistics+0xa08>
    1728:	00004097          	auipc	ra,0x4
    172c:	f9a080e7          	jalr	-102(ra) # 56c2 <printf>
    exit(1);
    1730:	4505                	li	a0,1
    1732:	00004097          	auipc	ra,0x4
    1736:	c28080e7          	jalr	-984(ra) # 535a <exit>
    exit(0);
    173a:	4501                	li	a0,0
    173c:	00004097          	auipc	ra,0x4
    1740:	c1e080e7          	jalr	-994(ra) # 535a <exit>

0000000000001744 <pipe1>:
{
    1744:	711d                	add	sp,sp,-96
    1746:	ec86                	sd	ra,88(sp)
    1748:	e8a2                	sd	s0,80(sp)
    174a:	e4a6                	sd	s1,72(sp)
    174c:	e0ca                	sd	s2,64(sp)
    174e:	fc4e                	sd	s3,56(sp)
    1750:	f852                	sd	s4,48(sp)
    1752:	f456                	sd	s5,40(sp)
    1754:	f05a                	sd	s6,32(sp)
    1756:	ec5e                	sd	s7,24(sp)
    1758:	1080                	add	s0,sp,96
    175a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175c:	fa840513          	add	a0,s0,-88
    1760:	00004097          	auipc	ra,0x4
    1764:	c0a080e7          	jalr	-1014(ra) # 536a <pipe>
    1768:	e93d                	bnez	a0,17de <pipe1+0x9a>
    176a:	84aa                	mv	s1,a0
  pid = fork();
    176c:	00004097          	auipc	ra,0x4
    1770:	be6080e7          	jalr	-1050(ra) # 5352 <fork>
    1774:	8a2a                	mv	s4,a0
  if(pid == 0){
    1776:	c151                	beqz	a0,17fa <pipe1+0xb6>
  } else if(pid > 0){
    1778:	16a05d63          	blez	a0,18f2 <pipe1+0x1ae>
    close(fds[1]);
    177c:	fac42503          	lw	a0,-84(s0)
    1780:	00004097          	auipc	ra,0x4
    1784:	c02080e7          	jalr	-1022(ra) # 5382 <close>
    total = 0;
    1788:	8a26                	mv	s4,s1
    cc = 1;
    178a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178c:	0000aa97          	auipc	s5,0xa
    1790:	07ca8a93          	add	s5,s5,124 # b808 <buf>
    1794:	864e                	mv	a2,s3
    1796:	85d6                	mv	a1,s5
    1798:	fa842503          	lw	a0,-88(s0)
    179c:	00004097          	auipc	ra,0x4
    17a0:	bd6080e7          	jalr	-1066(ra) # 5372 <read>
    17a4:	10a05263          	blez	a0,18a8 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a8:	0000a717          	auipc	a4,0xa
    17ac:	06070713          	add	a4,a4,96 # b808 <buf>
    17b0:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b4:	00074683          	lbu	a3,0(a4)
    17b8:	0ff4f793          	zext.b	a5,s1
    17bc:	2485                	addw	s1,s1,1
    17be:	0cf69163          	bne	a3,a5,1880 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17c2:	0705                	add	a4,a4,1
    17c4:	fec498e3          	bne	s1,a2,17b4 <pipe1+0x70>
      total += n;
    17c8:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17cc:	0019979b          	sllw	a5,s3,0x1
    17d0:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d4:	670d                	lui	a4,0x3
    17d6:	fb377fe3          	bgeu	a4,s3,1794 <pipe1+0x50>
        cc = sizeof(buf);
    17da:	698d                	lui	s3,0x3
    17dc:	bf65                	j	1794 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    17de:	85ca                	mv	a1,s2
    17e0:	00005517          	auipc	a0,0x5
    17e4:	aa050513          	add	a0,a0,-1376 # 6280 <statistics+0xa20>
    17e8:	00004097          	auipc	ra,0x4
    17ec:	eda080e7          	jalr	-294(ra) # 56c2 <printf>
    exit(1);
    17f0:	4505                	li	a0,1
    17f2:	00004097          	auipc	ra,0x4
    17f6:	b68080e7          	jalr	-1176(ra) # 535a <exit>
    close(fds[0]);
    17fa:	fa842503          	lw	a0,-88(s0)
    17fe:	00004097          	auipc	ra,0x4
    1802:	b84080e7          	jalr	-1148(ra) # 5382 <close>
    for(n = 0; n < N; n++){
    1806:	0000ab17          	auipc	s6,0xa
    180a:	002b0b13          	add	s6,s6,2 # b808 <buf>
    180e:	416004bb          	negw	s1,s6
    1812:	0ff4f493          	zext.b	s1,s1
    1816:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181a:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    181c:	6a85                	lui	s5,0x1
    181e:	42da8a93          	add	s5,s5,1069 # 142d <truncate3+0x7f>
{
    1822:	87da                	mv	a5,s6
        buf[i] = seq++;
    1824:	0097873b          	addw	a4,a5,s1
    1828:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    182c:	0785                	add	a5,a5,1
    182e:	fef99be3          	bne	s3,a5,1824 <pipe1+0xe0>
        buf[i] = seq++;
    1832:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1836:	40900613          	li	a2,1033
    183a:	85de                	mv	a1,s7
    183c:	fac42503          	lw	a0,-84(s0)
    1840:	00004097          	auipc	ra,0x4
    1844:	b3a080e7          	jalr	-1222(ra) # 537a <write>
    1848:	40900793          	li	a5,1033
    184c:	00f51c63          	bne	a0,a5,1864 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1850:	24a5                	addw	s1,s1,9
    1852:	0ff4f493          	zext.b	s1,s1
    1856:	fd5a16e3          	bne	s4,s5,1822 <pipe1+0xde>
    exit(0);
    185a:	4501                	li	a0,0
    185c:	00004097          	auipc	ra,0x4
    1860:	afe080e7          	jalr	-1282(ra) # 535a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1864:	85ca                	mv	a1,s2
    1866:	00005517          	auipc	a0,0x5
    186a:	a3250513          	add	a0,a0,-1486 # 6298 <statistics+0xa38>
    186e:	00004097          	auipc	ra,0x4
    1872:	e54080e7          	jalr	-428(ra) # 56c2 <printf>
        exit(1);
    1876:	4505                	li	a0,1
    1878:	00004097          	auipc	ra,0x4
    187c:	ae2080e7          	jalr	-1310(ra) # 535a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1880:	85ca                	mv	a1,s2
    1882:	00005517          	auipc	a0,0x5
    1886:	a2e50513          	add	a0,a0,-1490 # 62b0 <statistics+0xa50>
    188a:	00004097          	auipc	ra,0x4
    188e:	e38080e7          	jalr	-456(ra) # 56c2 <printf>
}
    1892:	60e6                	ld	ra,88(sp)
    1894:	6446                	ld	s0,80(sp)
    1896:	64a6                	ld	s1,72(sp)
    1898:	6906                	ld	s2,64(sp)
    189a:	79e2                	ld	s3,56(sp)
    189c:	7a42                	ld	s4,48(sp)
    189e:	7aa2                	ld	s5,40(sp)
    18a0:	7b02                	ld	s6,32(sp)
    18a2:	6be2                	ld	s7,24(sp)
    18a4:	6125                	add	sp,sp,96
    18a6:	8082                	ret
    if(total != N * SZ){
    18a8:	6785                	lui	a5,0x1
    18aa:	42d78793          	add	a5,a5,1069 # 142d <truncate3+0x7f>
    18ae:	02fa0063          	beq	s4,a5,18ce <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b2:	85d2                	mv	a1,s4
    18b4:	00005517          	auipc	a0,0x5
    18b8:	a1450513          	add	a0,a0,-1516 # 62c8 <statistics+0xa68>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	e06080e7          	jalr	-506(ra) # 56c2 <printf>
      exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	a94080e7          	jalr	-1388(ra) # 535a <exit>
    close(fds[0]);
    18ce:	fa842503          	lw	a0,-88(s0)
    18d2:	00004097          	auipc	ra,0x4
    18d6:	ab0080e7          	jalr	-1360(ra) # 5382 <close>
    wait(&xstatus);
    18da:	fa440513          	add	a0,s0,-92
    18de:	00004097          	auipc	ra,0x4
    18e2:	a84080e7          	jalr	-1404(ra) # 5362 <wait>
    exit(xstatus);
    18e6:	fa442503          	lw	a0,-92(s0)
    18ea:	00004097          	auipc	ra,0x4
    18ee:	a70080e7          	jalr	-1424(ra) # 535a <exit>
    printf("%s: fork() failed\n", s);
    18f2:	85ca                	mv	a1,s2
    18f4:	00005517          	auipc	a0,0x5
    18f8:	9f450513          	add	a0,a0,-1548 # 62e8 <statistics+0xa88>
    18fc:	00004097          	auipc	ra,0x4
    1900:	dc6080e7          	jalr	-570(ra) # 56c2 <printf>
    exit(1);
    1904:	4505                	li	a0,1
    1906:	00004097          	auipc	ra,0x4
    190a:	a54080e7          	jalr	-1452(ra) # 535a <exit>

000000000000190e <exitwait>:
{
    190e:	7139                	add	sp,sp,-64
    1910:	fc06                	sd	ra,56(sp)
    1912:	f822                	sd	s0,48(sp)
    1914:	f426                	sd	s1,40(sp)
    1916:	f04a                	sd	s2,32(sp)
    1918:	ec4e                	sd	s3,24(sp)
    191a:	e852                	sd	s4,16(sp)
    191c:	0080                	add	s0,sp,64
    191e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1920:	4901                	li	s2,0
    1922:	06400993          	li	s3,100
    pid = fork();
    1926:	00004097          	auipc	ra,0x4
    192a:	a2c080e7          	jalr	-1492(ra) # 5352 <fork>
    192e:	84aa                	mv	s1,a0
    if(pid < 0){
    1930:	02054a63          	bltz	a0,1964 <exitwait+0x56>
    if(pid){
    1934:	c151                	beqz	a0,19b8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1936:	fcc40513          	add	a0,s0,-52
    193a:	00004097          	auipc	ra,0x4
    193e:	a28080e7          	jalr	-1496(ra) # 5362 <wait>
    1942:	02951f63          	bne	a0,s1,1980 <exitwait+0x72>
      if(i != xstate) {
    1946:	fcc42783          	lw	a5,-52(s0)
    194a:	05279963          	bne	a5,s2,199c <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194e:	2905                	addw	s2,s2,1
    1950:	fd391be3          	bne	s2,s3,1926 <exitwait+0x18>
}
    1954:	70e2                	ld	ra,56(sp)
    1956:	7442                	ld	s0,48(sp)
    1958:	74a2                	ld	s1,40(sp)
    195a:	7902                	ld	s2,32(sp)
    195c:	69e2                	ld	s3,24(sp)
    195e:	6a42                	ld	s4,16(sp)
    1960:	6121                	add	sp,sp,64
    1962:	8082                	ret
      printf("%s: fork failed\n", s);
    1964:	85d2                	mv	a1,s4
    1966:	00005517          	auipc	a0,0x5
    196a:	81250513          	add	a0,a0,-2030 # 6178 <statistics+0x918>
    196e:	00004097          	auipc	ra,0x4
    1972:	d54080e7          	jalr	-684(ra) # 56c2 <printf>
      exit(1);
    1976:	4505                	li	a0,1
    1978:	00004097          	auipc	ra,0x4
    197c:	9e2080e7          	jalr	-1566(ra) # 535a <exit>
        printf("%s: wait wrong pid\n", s);
    1980:	85d2                	mv	a1,s4
    1982:	00005517          	auipc	a0,0x5
    1986:	97e50513          	add	a0,a0,-1666 # 6300 <statistics+0xaa0>
    198a:	00004097          	auipc	ra,0x4
    198e:	d38080e7          	jalr	-712(ra) # 56c2 <printf>
        exit(1);
    1992:	4505                	li	a0,1
    1994:	00004097          	auipc	ra,0x4
    1998:	9c6080e7          	jalr	-1594(ra) # 535a <exit>
        printf("%s: wait wrong exit status\n", s);
    199c:	85d2                	mv	a1,s4
    199e:	00005517          	auipc	a0,0x5
    19a2:	97a50513          	add	a0,a0,-1670 # 6318 <statistics+0xab8>
    19a6:	00004097          	auipc	ra,0x4
    19aa:	d1c080e7          	jalr	-740(ra) # 56c2 <printf>
        exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00004097          	auipc	ra,0x4
    19b4:	9aa080e7          	jalr	-1622(ra) # 535a <exit>
      exit(i);
    19b8:	854a                	mv	a0,s2
    19ba:	00004097          	auipc	ra,0x4
    19be:	9a0080e7          	jalr	-1632(ra) # 535a <exit>

00000000000019c2 <twochildren>:
{
    19c2:	1101                	add	sp,sp,-32
    19c4:	ec06                	sd	ra,24(sp)
    19c6:	e822                	sd	s0,16(sp)
    19c8:	e426                	sd	s1,8(sp)
    19ca:	e04a                	sd	s2,0(sp)
    19cc:	1000                	add	s0,sp,32
    19ce:	892a                	mv	s2,a0
    19d0:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d4:	00004097          	auipc	ra,0x4
    19d8:	97e080e7          	jalr	-1666(ra) # 5352 <fork>
    if(pid1 < 0){
    19dc:	02054c63          	bltz	a0,1a14 <twochildren+0x52>
    if(pid1 == 0){
    19e0:	c921                	beqz	a0,1a30 <twochildren+0x6e>
      int pid2 = fork();
    19e2:	00004097          	auipc	ra,0x4
    19e6:	970080e7          	jalr	-1680(ra) # 5352 <fork>
      if(pid2 < 0){
    19ea:	04054763          	bltz	a0,1a38 <twochildren+0x76>
      if(pid2 == 0){
    19ee:	c13d                	beqz	a0,1a54 <twochildren+0x92>
        wait(0);
    19f0:	4501                	li	a0,0
    19f2:	00004097          	auipc	ra,0x4
    19f6:	970080e7          	jalr	-1680(ra) # 5362 <wait>
        wait(0);
    19fa:	4501                	li	a0,0
    19fc:	00004097          	auipc	ra,0x4
    1a00:	966080e7          	jalr	-1690(ra) # 5362 <wait>
  for(int i = 0; i < 1000; i++){
    1a04:	34fd                	addw	s1,s1,-1
    1a06:	f4f9                	bnez	s1,19d4 <twochildren+0x12>
}
    1a08:	60e2                	ld	ra,24(sp)
    1a0a:	6442                	ld	s0,16(sp)
    1a0c:	64a2                	ld	s1,8(sp)
    1a0e:	6902                	ld	s2,0(sp)
    1a10:	6105                	add	sp,sp,32
    1a12:	8082                	ret
      printf("%s: fork failed\n", s);
    1a14:	85ca                	mv	a1,s2
    1a16:	00004517          	auipc	a0,0x4
    1a1a:	76250513          	add	a0,a0,1890 # 6178 <statistics+0x918>
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	ca4080e7          	jalr	-860(ra) # 56c2 <printf>
      exit(1);
    1a26:	4505                	li	a0,1
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	932080e7          	jalr	-1742(ra) # 535a <exit>
      exit(0);
    1a30:	00004097          	auipc	ra,0x4
    1a34:	92a080e7          	jalr	-1750(ra) # 535a <exit>
        printf("%s: fork failed\n", s);
    1a38:	85ca                	mv	a1,s2
    1a3a:	00004517          	auipc	a0,0x4
    1a3e:	73e50513          	add	a0,a0,1854 # 6178 <statistics+0x918>
    1a42:	00004097          	auipc	ra,0x4
    1a46:	c80080e7          	jalr	-896(ra) # 56c2 <printf>
        exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	90e080e7          	jalr	-1778(ra) # 535a <exit>
        exit(0);
    1a54:	00004097          	auipc	ra,0x4
    1a58:	906080e7          	jalr	-1786(ra) # 535a <exit>

0000000000001a5c <forkfork>:
{
    1a5c:	7179                	add	sp,sp,-48
    1a5e:	f406                	sd	ra,40(sp)
    1a60:	f022                	sd	s0,32(sp)
    1a62:	ec26                	sd	s1,24(sp)
    1a64:	1800                	add	s0,sp,48
    1a66:	84aa                	mv	s1,a0
    int pid = fork();
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	8ea080e7          	jalr	-1814(ra) # 5352 <fork>
    if(pid < 0){
    1a70:	04054163          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a74:	cd29                	beqz	a0,1ace <forkfork+0x72>
    int pid = fork();
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	8dc080e7          	jalr	-1828(ra) # 5352 <fork>
    if(pid < 0){
    1a7e:	02054a63          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a82:	c531                	beqz	a0,1ace <forkfork+0x72>
    wait(&xstatus);
    1a84:	fdc40513          	add	a0,s0,-36
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	8da080e7          	jalr	-1830(ra) # 5362 <wait>
    if(xstatus != 0) {
    1a90:	fdc42783          	lw	a5,-36(s0)
    1a94:	ebbd                	bnez	a5,1b0a <forkfork+0xae>
    wait(&xstatus);
    1a96:	fdc40513          	add	a0,s0,-36
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	8c8080e7          	jalr	-1848(ra) # 5362 <wait>
    if(xstatus != 0) {
    1aa2:	fdc42783          	lw	a5,-36(s0)
    1aa6:	e3b5                	bnez	a5,1b0a <forkfork+0xae>
}
    1aa8:	70a2                	ld	ra,40(sp)
    1aaa:	7402                	ld	s0,32(sp)
    1aac:	64e2                	ld	s1,24(sp)
    1aae:	6145                	add	sp,sp,48
    1ab0:	8082                	ret
      printf("%s: fork failed", s);
    1ab2:	85a6                	mv	a1,s1
    1ab4:	00005517          	auipc	a0,0x5
    1ab8:	88450513          	add	a0,a0,-1916 # 6338 <statistics+0xad8>
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	c06080e7          	jalr	-1018(ra) # 56c2 <printf>
      exit(1);
    1ac4:	4505                	li	a0,1
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	894080e7          	jalr	-1900(ra) # 535a <exit>
{
    1ace:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	880080e7          	jalr	-1920(ra) # 5352 <fork>
        if(pid1 < 0){
    1ada:	00054f63          	bltz	a0,1af8 <forkfork+0x9c>
        if(pid1 == 0){
    1ade:	c115                	beqz	a0,1b02 <forkfork+0xa6>
        wait(0);
    1ae0:	4501                	li	a0,0
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	880080e7          	jalr	-1920(ra) # 5362 <wait>
      for(int j = 0; j < 200; j++){
    1aea:	34fd                	addw	s1,s1,-1
    1aec:	f0fd                	bnez	s1,1ad2 <forkfork+0x76>
      exit(0);
    1aee:	4501                	li	a0,0
    1af0:	00004097          	auipc	ra,0x4
    1af4:	86a080e7          	jalr	-1942(ra) # 535a <exit>
          exit(1);
    1af8:	4505                	li	a0,1
    1afa:	00004097          	auipc	ra,0x4
    1afe:	860080e7          	jalr	-1952(ra) # 535a <exit>
          exit(0);
    1b02:	00004097          	auipc	ra,0x4
    1b06:	858080e7          	jalr	-1960(ra) # 535a <exit>
      printf("%s: fork in child failed", s);
    1b0a:	85a6                	mv	a1,s1
    1b0c:	00005517          	auipc	a0,0x5
    1b10:	83c50513          	add	a0,a0,-1988 # 6348 <statistics+0xae8>
    1b14:	00004097          	auipc	ra,0x4
    1b18:	bae080e7          	jalr	-1106(ra) # 56c2 <printf>
      exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	83c080e7          	jalr	-1988(ra) # 535a <exit>

0000000000001b26 <reparent2>:
{
    1b26:	1101                	add	sp,sp,-32
    1b28:	ec06                	sd	ra,24(sp)
    1b2a:	e822                	sd	s0,16(sp)
    1b2c:	e426                	sd	s1,8(sp)
    1b2e:	1000                	add	s0,sp,32
    1b30:	32000493          	li	s1,800
    int pid1 = fork();
    1b34:	00004097          	auipc	ra,0x4
    1b38:	81e080e7          	jalr	-2018(ra) # 5352 <fork>
    if(pid1 < 0){
    1b3c:	00054f63          	bltz	a0,1b5a <reparent2+0x34>
    if(pid1 == 0){
    1b40:	c915                	beqz	a0,1b74 <reparent2+0x4e>
    wait(0);
    1b42:	4501                	li	a0,0
    1b44:	00004097          	auipc	ra,0x4
    1b48:	81e080e7          	jalr	-2018(ra) # 5362 <wait>
  for(int i = 0; i < 800; i++){
    1b4c:	34fd                	addw	s1,s1,-1
    1b4e:	f0fd                	bnez	s1,1b34 <reparent2+0xe>
  exit(0);
    1b50:	4501                	li	a0,0
    1b52:	00004097          	auipc	ra,0x4
    1b56:	808080e7          	jalr	-2040(ra) # 535a <exit>
      printf("fork failed\n");
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	a0e50513          	add	a0,a0,-1522 # 6568 <statistics+0xd08>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	b60080e7          	jalr	-1184(ra) # 56c2 <printf>
      exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00003097          	auipc	ra,0x3
    1b70:	7ee080e7          	jalr	2030(ra) # 535a <exit>
      fork();
    1b74:	00003097          	auipc	ra,0x3
    1b78:	7de080e7          	jalr	2014(ra) # 5352 <fork>
      fork();
    1b7c:	00003097          	auipc	ra,0x3
    1b80:	7d6080e7          	jalr	2006(ra) # 5352 <fork>
      exit(0);
    1b84:	4501                	li	a0,0
    1b86:	00003097          	auipc	ra,0x3
    1b8a:	7d4080e7          	jalr	2004(ra) # 535a <exit>

0000000000001b8e <createdelete>:
{
    1b8e:	7175                	add	sp,sp,-144
    1b90:	e506                	sd	ra,136(sp)
    1b92:	e122                	sd	s0,128(sp)
    1b94:	fca6                	sd	s1,120(sp)
    1b96:	f8ca                	sd	s2,112(sp)
    1b98:	f4ce                	sd	s3,104(sp)
    1b9a:	f0d2                	sd	s4,96(sp)
    1b9c:	ecd6                	sd	s5,88(sp)
    1b9e:	e8da                	sd	s6,80(sp)
    1ba0:	e4de                	sd	s7,72(sp)
    1ba2:	e0e2                	sd	s8,64(sp)
    1ba4:	fc66                	sd	s9,56(sp)
    1ba6:	0900                	add	s0,sp,144
    1ba8:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1baa:	4901                	li	s2,0
    1bac:	4991                	li	s3,4
    pid = fork();
    1bae:	00003097          	auipc	ra,0x3
    1bb2:	7a4080e7          	jalr	1956(ra) # 5352 <fork>
    1bb6:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb8:	02054f63          	bltz	a0,1bf6 <createdelete+0x68>
    if(pid == 0){
    1bbc:	c939                	beqz	a0,1c12 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bbe:	2905                	addw	s2,s2,1
    1bc0:	ff3917e3          	bne	s2,s3,1bae <createdelete+0x20>
    1bc4:	4491                	li	s1,4
    wait(&xstatus);
    1bc6:	f7c40513          	add	a0,s0,-132
    1bca:	00003097          	auipc	ra,0x3
    1bce:	798080e7          	jalr	1944(ra) # 5362 <wait>
    if(xstatus != 0)
    1bd2:	f7c42903          	lw	s2,-132(s0)
    1bd6:	0e091263          	bnez	s2,1cba <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bda:	34fd                	addw	s1,s1,-1
    1bdc:	f4ed                	bnez	s1,1bc6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bde:	f8040123          	sb	zero,-126(s0)
    1be2:	03000993          	li	s3,48
    1be6:	5a7d                	li	s4,-1
    1be8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bec:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bee:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf0:	07400a93          	li	s5,116
    1bf4:	a29d                	j	1d5a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf6:	85e6                	mv	a1,s9
    1bf8:	00005517          	auipc	a0,0x5
    1bfc:	97050513          	add	a0,a0,-1680 # 6568 <statistics+0xd08>
    1c00:	00004097          	auipc	ra,0x4
    1c04:	ac2080e7          	jalr	-1342(ra) # 56c2 <printf>
      exit(1);
    1c08:	4505                	li	a0,1
    1c0a:	00003097          	auipc	ra,0x3
    1c0e:	750080e7          	jalr	1872(ra) # 535a <exit>
      name[0] = 'p' + pi;
    1c12:	0709091b          	addw	s2,s2,112
    1c16:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1e:	4951                	li	s2,20
    1c20:	a015                	j	1c44 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c22:	85e6                	mv	a1,s9
    1c24:	00004517          	auipc	a0,0x4
    1c28:	5ec50513          	add	a0,a0,1516 # 6210 <statistics+0x9b0>
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	a96080e7          	jalr	-1386(ra) # 56c2 <printf>
          exit(1);
    1c34:	4505                	li	a0,1
    1c36:	00003097          	auipc	ra,0x3
    1c3a:	724080e7          	jalr	1828(ra) # 535a <exit>
      for(i = 0; i < N; i++){
    1c3e:	2485                	addw	s1,s1,1
    1c40:	07248863          	beq	s1,s2,1cb0 <createdelete+0x122>
        name[1] = '0' + i;
    1c44:	0304879b          	addw	a5,s1,48
    1c48:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4c:	20200593          	li	a1,514
    1c50:	f8040513          	add	a0,s0,-128
    1c54:	00003097          	auipc	ra,0x3
    1c58:	746080e7          	jalr	1862(ra) # 539a <open>
        if(fd < 0){
    1c5c:	fc0543e3          	bltz	a0,1c22 <createdelete+0x94>
        close(fd);
    1c60:	00003097          	auipc	ra,0x3
    1c64:	722080e7          	jalr	1826(ra) # 5382 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c68:	fc905be3          	blez	s1,1c3e <createdelete+0xb0>
    1c6c:	0014f793          	and	a5,s1,1
    1c70:	f7f9                	bnez	a5,1c3e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c72:	01f4d79b          	srlw	a5,s1,0x1f
    1c76:	9fa5                	addw	a5,a5,s1
    1c78:	4017d79b          	sraw	a5,a5,0x1
    1c7c:	0307879b          	addw	a5,a5,48
    1c80:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c84:	f8040513          	add	a0,s0,-128
    1c88:	00003097          	auipc	ra,0x3
    1c8c:	722080e7          	jalr	1826(ra) # 53aa <unlink>
    1c90:	fa0557e3          	bgez	a0,1c3e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c94:	85e6                	mv	a1,s9
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	6d250513          	add	a0,a0,1746 # 6368 <statistics+0xb08>
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	a24080e7          	jalr	-1500(ra) # 56c2 <printf>
            exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	00003097          	auipc	ra,0x3
    1cac:	6b2080e7          	jalr	1714(ra) # 535a <exit>
      exit(0);
    1cb0:	4501                	li	a0,0
    1cb2:	00003097          	auipc	ra,0x3
    1cb6:	6a8080e7          	jalr	1704(ra) # 535a <exit>
      exit(1);
    1cba:	4505                	li	a0,1
    1cbc:	00003097          	auipc	ra,0x3
    1cc0:	69e080e7          	jalr	1694(ra) # 535a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc4:	f8040613          	add	a2,s0,-128
    1cc8:	85e6                	mv	a1,s9
    1cca:	00004517          	auipc	a0,0x4
    1cce:	6b650513          	add	a0,a0,1718 # 6380 <statistics+0xb20>
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	9f0080e7          	jalr	-1552(ra) # 56c2 <printf>
        exit(1);
    1cda:	4505                	li	a0,1
    1cdc:	00003097          	auipc	ra,0x3
    1ce0:	67e080e7          	jalr	1662(ra) # 535a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce4:	054b7163          	bgeu	s6,s4,1d26 <createdelete+0x198>
      if(fd >= 0)
    1ce8:	02055a63          	bgez	a0,1d1c <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cec:	2485                	addw	s1,s1,1
    1cee:	0ff4f493          	zext.b	s1,s1
    1cf2:	05548c63          	beq	s1,s5,1d4a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfa:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfe:	4581                	li	a1,0
    1d00:	f8040513          	add	a0,s0,-128
    1d04:	00003097          	auipc	ra,0x3
    1d08:	696080e7          	jalr	1686(ra) # 539a <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0c:	00090463          	beqz	s2,1d14 <createdelete+0x186>
    1d10:	fd2bdae3          	bge	s7,s2,1ce4 <createdelete+0x156>
    1d14:	fa0548e3          	bltz	a0,1cc4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d18:	014b7963          	bgeu	s6,s4,1d2a <createdelete+0x19c>
        close(fd);
    1d1c:	00003097          	auipc	ra,0x3
    1d20:	666080e7          	jalr	1638(ra) # 5382 <close>
    1d24:	b7e1                	j	1cec <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d26:	fc0543e3          	bltz	a0,1cec <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2a:	f8040613          	add	a2,s0,-128
    1d2e:	85e6                	mv	a1,s9
    1d30:	00004517          	auipc	a0,0x4
    1d34:	67850513          	add	a0,a0,1656 # 63a8 <statistics+0xb48>
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	98a080e7          	jalr	-1654(ra) # 56c2 <printf>
        exit(1);
    1d40:	4505                	li	a0,1
    1d42:	00003097          	auipc	ra,0x3
    1d46:	618080e7          	jalr	1560(ra) # 535a <exit>
  for(i = 0; i < N; i++){
    1d4a:	2905                	addw	s2,s2,1
    1d4c:	2a05                	addw	s4,s4,1
    1d4e:	2985                	addw	s3,s3,1 # 3001 <subdir+0x32b>
    1d50:	0ff9f993          	zext.b	s3,s3
    1d54:	47d1                	li	a5,20
    1d56:	02f90a63          	beq	s2,a5,1d8a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5a:	84e2                	mv	s1,s8
    1d5c:	bf69                	j	1cf6 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5e:	2905                	addw	s2,s2,1
    1d60:	0ff97913          	zext.b	s2,s2
    1d64:	2985                	addw	s3,s3,1
    1d66:	0ff9f993          	zext.b	s3,s3
    1d6a:	03490863          	beq	s2,s4,1d9a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d70:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d74:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d78:	f8040513          	add	a0,s0,-128
    1d7c:	00003097          	auipc	ra,0x3
    1d80:	62e080e7          	jalr	1582(ra) # 53aa <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d84:	34fd                	addw	s1,s1,-1
    1d86:	f4ed                	bnez	s1,1d70 <createdelete+0x1e2>
    1d88:	bfd9                	j	1d5e <createdelete+0x1d0>
    1d8a:	03000993          	li	s3,48
    1d8e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d92:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d94:	08400a13          	li	s4,132
    1d98:	bfd9                	j	1d6e <createdelete+0x1e0>
}
    1d9a:	60aa                	ld	ra,136(sp)
    1d9c:	640a                	ld	s0,128(sp)
    1d9e:	74e6                	ld	s1,120(sp)
    1da0:	7946                	ld	s2,112(sp)
    1da2:	79a6                	ld	s3,104(sp)
    1da4:	7a06                	ld	s4,96(sp)
    1da6:	6ae6                	ld	s5,88(sp)
    1da8:	6b46                	ld	s6,80(sp)
    1daa:	6ba6                	ld	s7,72(sp)
    1dac:	6c06                	ld	s8,64(sp)
    1dae:	7ce2                	ld	s9,56(sp)
    1db0:	6149                	add	sp,sp,144
    1db2:	8082                	ret

0000000000001db4 <linkunlink>:
{
    1db4:	711d                	add	sp,sp,-96
    1db6:	ec86                	sd	ra,88(sp)
    1db8:	e8a2                	sd	s0,80(sp)
    1dba:	e4a6                	sd	s1,72(sp)
    1dbc:	e0ca                	sd	s2,64(sp)
    1dbe:	fc4e                	sd	s3,56(sp)
    1dc0:	f852                	sd	s4,48(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	f05a                	sd	s6,32(sp)
    1dc6:	ec5e                	sd	s7,24(sp)
    1dc8:	e862                	sd	s8,16(sp)
    1dca:	e466                	sd	s9,8(sp)
    1dcc:	1080                	add	s0,sp,96
    1dce:	84aa                	mv	s1,a0
  unlink("x");
    1dd0:	00004517          	auipc	a0,0x4
    1dd4:	bc050513          	add	a0,a0,-1088 # 5990 <statistics+0x130>
    1dd8:	00003097          	auipc	ra,0x3
    1ddc:	5d2080e7          	jalr	1490(ra) # 53aa <unlink>
  pid = fork();
    1de0:	00003097          	auipc	ra,0x3
    1de4:	572080e7          	jalr	1394(ra) # 5352 <fork>
  if(pid < 0){
    1de8:	02054b63          	bltz	a0,1e1e <linkunlink+0x6a>
    1dec:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dee:	06100c93          	li	s9,97
    1df2:	c111                	beqz	a0,1df6 <linkunlink+0x42>
    1df4:	4c85                	li	s9,1
    1df6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfa:	41c659b7          	lui	s3,0x41c65
    1dfe:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c56655>
    1e02:	690d                	lui	s2,0x3
    1e04:	0399091b          	addw	s2,s2,57 # 3039 <subdir+0x363>
    if((x % 3) == 0){
    1e08:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0a:	4b05                	li	s6,1
      unlink("x");
    1e0c:	00004a97          	auipc	s5,0x4
    1e10:	b84a8a93          	add	s5,s5,-1148 # 5990 <statistics+0x130>
      link("cat", "x");
    1e14:	00004b97          	auipc	s7,0x4
    1e18:	5bcb8b93          	add	s7,s7,1468 # 63d0 <statistics+0xb70>
    1e1c:	a825                	j	1e54 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1e:	85a6                	mv	a1,s1
    1e20:	00004517          	auipc	a0,0x4
    1e24:	35850513          	add	a0,a0,856 # 6178 <statistics+0x918>
    1e28:	00004097          	auipc	ra,0x4
    1e2c:	89a080e7          	jalr	-1894(ra) # 56c2 <printf>
    exit(1);
    1e30:	4505                	li	a0,1
    1e32:	00003097          	auipc	ra,0x3
    1e36:	528080e7          	jalr	1320(ra) # 535a <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3a:	20200593          	li	a1,514
    1e3e:	8556                	mv	a0,s5
    1e40:	00003097          	auipc	ra,0x3
    1e44:	55a080e7          	jalr	1370(ra) # 539a <open>
    1e48:	00003097          	auipc	ra,0x3
    1e4c:	53a080e7          	jalr	1338(ra) # 5382 <close>
  for(i = 0; i < 100; i++){
    1e50:	34fd                	addw	s1,s1,-1
    1e52:	c88d                	beqz	s1,1e84 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e54:	033c87bb          	mulw	a5,s9,s3
    1e58:	012787bb          	addw	a5,a5,s2
    1e5c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e60:	0347f7bb          	remuw	a5,a5,s4
    1e64:	dbf9                	beqz	a5,1e3a <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e66:	01678863          	beq	a5,s6,1e76 <linkunlink+0xc2>
      unlink("x");
    1e6a:	8556                	mv	a0,s5
    1e6c:	00003097          	auipc	ra,0x3
    1e70:	53e080e7          	jalr	1342(ra) # 53aa <unlink>
    1e74:	bff1                	j	1e50 <linkunlink+0x9c>
      link("cat", "x");
    1e76:	85d6                	mv	a1,s5
    1e78:	855e                	mv	a0,s7
    1e7a:	00003097          	auipc	ra,0x3
    1e7e:	540080e7          	jalr	1344(ra) # 53ba <link>
    1e82:	b7f9                	j	1e50 <linkunlink+0x9c>
  if(pid)
    1e84:	020c0463          	beqz	s8,1eac <linkunlink+0xf8>
    wait(0);
    1e88:	4501                	li	a0,0
    1e8a:	00003097          	auipc	ra,0x3
    1e8e:	4d8080e7          	jalr	1240(ra) # 5362 <wait>
}
    1e92:	60e6                	ld	ra,88(sp)
    1e94:	6446                	ld	s0,80(sp)
    1e96:	64a6                	ld	s1,72(sp)
    1e98:	6906                	ld	s2,64(sp)
    1e9a:	79e2                	ld	s3,56(sp)
    1e9c:	7a42                	ld	s4,48(sp)
    1e9e:	7aa2                	ld	s5,40(sp)
    1ea0:	7b02                	ld	s6,32(sp)
    1ea2:	6be2                	ld	s7,24(sp)
    1ea4:	6c42                	ld	s8,16(sp)
    1ea6:	6ca2                	ld	s9,8(sp)
    1ea8:	6125                	add	sp,sp,96
    1eaa:	8082                	ret
    exit(0);
    1eac:	4501                	li	a0,0
    1eae:	00003097          	auipc	ra,0x3
    1eb2:	4ac080e7          	jalr	1196(ra) # 535a <exit>

0000000000001eb6 <forktest>:
{
    1eb6:	7179                	add	sp,sp,-48
    1eb8:	f406                	sd	ra,40(sp)
    1eba:	f022                	sd	s0,32(sp)
    1ebc:	ec26                	sd	s1,24(sp)
    1ebe:	e84a                	sd	s2,16(sp)
    1ec0:	e44e                	sd	s3,8(sp)
    1ec2:	1800                	add	s0,sp,48
    1ec4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ec6:	4481                	li	s1,0
    1ec8:	3e800913          	li	s2,1000
    pid = fork();
    1ecc:	00003097          	auipc	ra,0x3
    1ed0:	486080e7          	jalr	1158(ra) # 5352 <fork>
    if(pid < 0)
    1ed4:	02054863          	bltz	a0,1f04 <forktest+0x4e>
    if(pid == 0)
    1ed8:	c115                	beqz	a0,1efc <forktest+0x46>
  for(n=0; n<N; n++){
    1eda:	2485                	addw	s1,s1,1
    1edc:	ff2498e3          	bne	s1,s2,1ecc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee0:	85ce                	mv	a1,s3
    1ee2:	00004517          	auipc	a0,0x4
    1ee6:	50e50513          	add	a0,a0,1294 # 63f0 <statistics+0xb90>
    1eea:	00003097          	auipc	ra,0x3
    1eee:	7d8080e7          	jalr	2008(ra) # 56c2 <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	00003097          	auipc	ra,0x3
    1ef8:	466080e7          	jalr	1126(ra) # 535a <exit>
      exit(0);
    1efc:	00003097          	auipc	ra,0x3
    1f00:	45e080e7          	jalr	1118(ra) # 535a <exit>
  if (n == 0) {
    1f04:	cc9d                	beqz	s1,1f42 <forktest+0x8c>
  if(n == N){
    1f06:	3e800793          	li	a5,1000
    1f0a:	fcf48be3          	beq	s1,a5,1ee0 <forktest+0x2a>
  for(; n > 0; n--){
    1f0e:	00905b63          	blez	s1,1f24 <forktest+0x6e>
    if(wait(0) < 0){
    1f12:	4501                	li	a0,0
    1f14:	00003097          	auipc	ra,0x3
    1f18:	44e080e7          	jalr	1102(ra) # 5362 <wait>
    1f1c:	04054163          	bltz	a0,1f5e <forktest+0xa8>
  for(; n > 0; n--){
    1f20:	34fd                	addw	s1,s1,-1
    1f22:	f8e5                	bnez	s1,1f12 <forktest+0x5c>
  if(wait(0) != -1){
    1f24:	4501                	li	a0,0
    1f26:	00003097          	auipc	ra,0x3
    1f2a:	43c080e7          	jalr	1084(ra) # 5362 <wait>
    1f2e:	57fd                	li	a5,-1
    1f30:	04f51563          	bne	a0,a5,1f7a <forktest+0xc4>
}
    1f34:	70a2                	ld	ra,40(sp)
    1f36:	7402                	ld	s0,32(sp)
    1f38:	64e2                	ld	s1,24(sp)
    1f3a:	6942                	ld	s2,16(sp)
    1f3c:	69a2                	ld	s3,8(sp)
    1f3e:	6145                	add	sp,sp,48
    1f40:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f42:	85ce                	mv	a1,s3
    1f44:	00004517          	auipc	a0,0x4
    1f48:	49450513          	add	a0,a0,1172 # 63d8 <statistics+0xb78>
    1f4c:	00003097          	auipc	ra,0x3
    1f50:	776080e7          	jalr	1910(ra) # 56c2 <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	00003097          	auipc	ra,0x3
    1f5a:	404080e7          	jalr	1028(ra) # 535a <exit>
      printf("%s: wait stopped early\n", s);
    1f5e:	85ce                	mv	a1,s3
    1f60:	00004517          	auipc	a0,0x4
    1f64:	4b850513          	add	a0,a0,1208 # 6418 <statistics+0xbb8>
    1f68:	00003097          	auipc	ra,0x3
    1f6c:	75a080e7          	jalr	1882(ra) # 56c2 <printf>
      exit(1);
    1f70:	4505                	li	a0,1
    1f72:	00003097          	auipc	ra,0x3
    1f76:	3e8080e7          	jalr	1000(ra) # 535a <exit>
    printf("%s: wait got too many\n", s);
    1f7a:	85ce                	mv	a1,s3
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	4b450513          	add	a0,a0,1204 # 6430 <statistics+0xbd0>
    1f84:	00003097          	auipc	ra,0x3
    1f88:	73e080e7          	jalr	1854(ra) # 56c2 <printf>
    exit(1);
    1f8c:	4505                	li	a0,1
    1f8e:	00003097          	auipc	ra,0x3
    1f92:	3cc080e7          	jalr	972(ra) # 535a <exit>

0000000000001f96 <kernmem>:
{
    1f96:	715d                	add	sp,sp,-80
    1f98:	e486                	sd	ra,72(sp)
    1f9a:	e0a2                	sd	s0,64(sp)
    1f9c:	fc26                	sd	s1,56(sp)
    1f9e:	f84a                	sd	s2,48(sp)
    1fa0:	f44e                	sd	s3,40(sp)
    1fa2:	f052                	sd	s4,32(sp)
    1fa4:	ec56                	sd	s5,24(sp)
    1fa6:	0880                	add	s0,sp,80
    1fa8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1faa:	4485                	li	s1,1
    1fac:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fae:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb0:	69b1                	lui	s3,0xc
    1fb2:	35098993          	add	s3,s3,848 # c350 <buf+0xb48>
    1fb6:	1003d937          	lui	s2,0x1003d
    1fba:	090e                	sll	s2,s2,0x3
    1fbc:	48090913          	add	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ec68>
    pid = fork();
    1fc0:	00003097          	auipc	ra,0x3
    1fc4:	392080e7          	jalr	914(ra) # 5352 <fork>
    if(pid < 0){
    1fc8:	02054963          	bltz	a0,1ffa <kernmem+0x64>
    if(pid == 0){
    1fcc:	c529                	beqz	a0,2016 <kernmem+0x80>
    wait(&xstatus);
    1fce:	fbc40513          	add	a0,s0,-68
    1fd2:	00003097          	auipc	ra,0x3
    1fd6:	390080e7          	jalr	912(ra) # 5362 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fda:	fbc42783          	lw	a5,-68(s0)
    1fde:	05579c63          	bne	a5,s5,2036 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe2:	94ce                	add	s1,s1,s3
    1fe4:	fd249ee3          	bne	s1,s2,1fc0 <kernmem+0x2a>
}
    1fe8:	60a6                	ld	ra,72(sp)
    1fea:	6406                	ld	s0,64(sp)
    1fec:	74e2                	ld	s1,56(sp)
    1fee:	7942                	ld	s2,48(sp)
    1ff0:	79a2                	ld	s3,40(sp)
    1ff2:	7a02                	ld	s4,32(sp)
    1ff4:	6ae2                	ld	s5,24(sp)
    1ff6:	6161                	add	sp,sp,80
    1ff8:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffa:	85d2                	mv	a1,s4
    1ffc:	00004517          	auipc	a0,0x4
    2000:	17c50513          	add	a0,a0,380 # 6178 <statistics+0x918>
    2004:	00003097          	auipc	ra,0x3
    2008:	6be080e7          	jalr	1726(ra) # 56c2 <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00003097          	auipc	ra,0x3
    2012:	34c080e7          	jalr	844(ra) # 535a <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    2016:	0004c603          	lbu	a2,0(s1)
    201a:	85a6                	mv	a1,s1
    201c:	00004517          	auipc	a0,0x4
    2020:	42c50513          	add	a0,a0,1068 # 6448 <statistics+0xbe8>
    2024:	00003097          	auipc	ra,0x3
    2028:	69e080e7          	jalr	1694(ra) # 56c2 <printf>
      exit(1);
    202c:	4505                	li	a0,1
    202e:	00003097          	auipc	ra,0x3
    2032:	32c080e7          	jalr	812(ra) # 535a <exit>
      exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	322080e7          	jalr	802(ra) # 535a <exit>

0000000000002040 <bigargtest>:
{
    2040:	7179                	add	sp,sp,-48
    2042:	f406                	sd	ra,40(sp)
    2044:	f022                	sd	s0,32(sp)
    2046:	ec26                	sd	s1,24(sp)
    2048:	1800                	add	s0,sp,48
    204a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    204c:	00004517          	auipc	a0,0x4
    2050:	41c50513          	add	a0,a0,1052 # 6468 <statistics+0xc08>
    2054:	00003097          	auipc	ra,0x3
    2058:	356080e7          	jalr	854(ra) # 53aa <unlink>
  pid = fork();
    205c:	00003097          	auipc	ra,0x3
    2060:	2f6080e7          	jalr	758(ra) # 5352 <fork>
  if(pid == 0){
    2064:	c121                	beqz	a0,20a4 <bigargtest+0x64>
  } else if(pid < 0){
    2066:	0a054063          	bltz	a0,2106 <bigargtest+0xc6>
  wait(&xstatus);
    206a:	fdc40513          	add	a0,s0,-36
    206e:	00003097          	auipc	ra,0x3
    2072:	2f4080e7          	jalr	756(ra) # 5362 <wait>
  if(xstatus != 0)
    2076:	fdc42503          	lw	a0,-36(s0)
    207a:	e545                	bnez	a0,2122 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    207c:	4581                	li	a1,0
    207e:	00004517          	auipc	a0,0x4
    2082:	3ea50513          	add	a0,a0,1002 # 6468 <statistics+0xc08>
    2086:	00003097          	auipc	ra,0x3
    208a:	314080e7          	jalr	788(ra) # 539a <open>
  if(fd < 0){
    208e:	08054e63          	bltz	a0,212a <bigargtest+0xea>
  close(fd);
    2092:	00003097          	auipc	ra,0x3
    2096:	2f0080e7          	jalr	752(ra) # 5382 <close>
}
    209a:	70a2                	ld	ra,40(sp)
    209c:	7402                	ld	s0,32(sp)
    209e:	64e2                	ld	s1,24(sp)
    20a0:	6145                	add	sp,sp,48
    20a2:	8082                	ret
    20a4:	00006797          	auipc	a5,0x6
    20a8:	f4c78793          	add	a5,a5,-180 # 7ff0 <args.1>
    20ac:	00006697          	auipc	a3,0x6
    20b0:	03c68693          	add	a3,a3,60 # 80e8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b4:	00004717          	auipc	a4,0x4
    20b8:	3c470713          	add	a4,a4,964 # 6478 <statistics+0xc18>
    20bc:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20be:	07a1                	add	a5,a5,8
    20c0:	fed79ee3          	bne	a5,a3,20bc <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c4:	00006597          	auipc	a1,0x6
    20c8:	f2c58593          	add	a1,a1,-212 # 7ff0 <args.1>
    20cc:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d0:	00004517          	auipc	a0,0x4
    20d4:	85050513          	add	a0,a0,-1968 # 5920 <statistics+0xc0>
    20d8:	00003097          	auipc	ra,0x3
    20dc:	2ba080e7          	jalr	698(ra) # 5392 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e0:	20000593          	li	a1,512
    20e4:	00004517          	auipc	a0,0x4
    20e8:	38450513          	add	a0,a0,900 # 6468 <statistics+0xc08>
    20ec:	00003097          	auipc	ra,0x3
    20f0:	2ae080e7          	jalr	686(ra) # 539a <open>
    close(fd);
    20f4:	00003097          	auipc	ra,0x3
    20f8:	28e080e7          	jalr	654(ra) # 5382 <close>
    exit(0);
    20fc:	4501                	li	a0,0
    20fe:	00003097          	auipc	ra,0x3
    2102:	25c080e7          	jalr	604(ra) # 535a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2106:	85a6                	mv	a1,s1
    2108:	00004517          	auipc	a0,0x4
    210c:	45050513          	add	a0,a0,1104 # 6558 <statistics+0xcf8>
    2110:	00003097          	auipc	ra,0x3
    2114:	5b2080e7          	jalr	1458(ra) # 56c2 <printf>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	00003097          	auipc	ra,0x3
    211e:	240080e7          	jalr	576(ra) # 535a <exit>
    exit(xstatus);
    2122:	00003097          	auipc	ra,0x3
    2126:	238080e7          	jalr	568(ra) # 535a <exit>
    printf("%s: bigarg test failed!\n", s);
    212a:	85a6                	mv	a1,s1
    212c:	00004517          	auipc	a0,0x4
    2130:	44c50513          	add	a0,a0,1100 # 6578 <statistics+0xd18>
    2134:	00003097          	auipc	ra,0x3
    2138:	58e080e7          	jalr	1422(ra) # 56c2 <printf>
    exit(1);
    213c:	4505                	li	a0,1
    213e:	00003097          	auipc	ra,0x3
    2142:	21c080e7          	jalr	540(ra) # 535a <exit>

0000000000002146 <stacktest>:
{
    2146:	7179                	add	sp,sp,-48
    2148:	f406                	sd	ra,40(sp)
    214a:	f022                	sd	s0,32(sp)
    214c:	ec26                	sd	s1,24(sp)
    214e:	1800                	add	s0,sp,48
    2150:	84aa                	mv	s1,a0
  pid = fork();
    2152:	00003097          	auipc	ra,0x3
    2156:	200080e7          	jalr	512(ra) # 5352 <fork>
  if(pid == 0) {
    215a:	c115                	beqz	a0,217e <stacktest+0x38>
  } else if(pid < 0){
    215c:	04054363          	bltz	a0,21a2 <stacktest+0x5c>
  wait(&xstatus);
    2160:	fdc40513          	add	a0,s0,-36
    2164:	00003097          	auipc	ra,0x3
    2168:	1fe080e7          	jalr	510(ra) # 5362 <wait>
  if(xstatus == -1)  // kernel killed child?
    216c:	fdc42503          	lw	a0,-36(s0)
    2170:	57fd                	li	a5,-1
    2172:	04f50663          	beq	a0,a5,21be <stacktest+0x78>
    exit(xstatus);
    2176:	00003097          	auipc	ra,0x3
    217a:	1e4080e7          	jalr	484(ra) # 535a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    217e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2180:	77fd                	lui	a5,0xfffff
    2182:	97ba                	add	a5,a5,a4
    2184:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff07e8>
    2188:	00004517          	auipc	a0,0x4
    218c:	41050513          	add	a0,a0,1040 # 6598 <statistics+0xd38>
    2190:	00003097          	auipc	ra,0x3
    2194:	532080e7          	jalr	1330(ra) # 56c2 <printf>
    exit(1);
    2198:	4505                	li	a0,1
    219a:	00003097          	auipc	ra,0x3
    219e:	1c0080e7          	jalr	448(ra) # 535a <exit>
    printf("%s: fork failed\n", s);
    21a2:	85a6                	mv	a1,s1
    21a4:	00004517          	auipc	a0,0x4
    21a8:	fd450513          	add	a0,a0,-44 # 6178 <statistics+0x918>
    21ac:	00003097          	auipc	ra,0x3
    21b0:	516080e7          	jalr	1302(ra) # 56c2 <printf>
    exit(1);
    21b4:	4505                	li	a0,1
    21b6:	00003097          	auipc	ra,0x3
    21ba:	1a4080e7          	jalr	420(ra) # 535a <exit>
    exit(0);
    21be:	4501                	li	a0,0
    21c0:	00003097          	auipc	ra,0x3
    21c4:	19a080e7          	jalr	410(ra) # 535a <exit>

00000000000021c8 <copyinstr3>:
{
    21c8:	7179                	add	sp,sp,-48
    21ca:	f406                	sd	ra,40(sp)
    21cc:	f022                	sd	s0,32(sp)
    21ce:	ec26                	sd	s1,24(sp)
    21d0:	1800                	add	s0,sp,48
  sbrk(8192);
    21d2:	6509                	lui	a0,0x2
    21d4:	00003097          	auipc	ra,0x3
    21d8:	20e080e7          	jalr	526(ra) # 53e2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21dc:	4501                	li	a0,0
    21de:	00003097          	auipc	ra,0x3
    21e2:	204080e7          	jalr	516(ra) # 53e2 <sbrk>
  if((top % PGSIZE) != 0){
    21e6:	03451793          	sll	a5,a0,0x34
    21ea:	e3c9                	bnez	a5,226c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21ec:	4501                	li	a0,0
    21ee:	00003097          	auipc	ra,0x3
    21f2:	1f4080e7          	jalr	500(ra) # 53e2 <sbrk>
  if(top % PGSIZE){
    21f6:	03451793          	sll	a5,a0,0x34
    21fa:	e3d9                	bnez	a5,2280 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    21fc:	fff50493          	add	s1,a0,-1 # 1fff <kernmem+0x69>
  *b = 'x';
    2200:	07800793          	li	a5,120
    2204:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2208:	8526                	mv	a0,s1
    220a:	00003097          	auipc	ra,0x3
    220e:	1a0080e7          	jalr	416(ra) # 53aa <unlink>
  if(ret != -1){
    2212:	57fd                	li	a5,-1
    2214:	08f51363          	bne	a0,a5,229a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2218:	20100593          	li	a1,513
    221c:	8526                	mv	a0,s1
    221e:	00003097          	auipc	ra,0x3
    2222:	17c080e7          	jalr	380(ra) # 539a <open>
  if(fd != -1){
    2226:	57fd                	li	a5,-1
    2228:	08f51863          	bne	a0,a5,22b8 <copyinstr3+0xf0>
  ret = link(b, b);
    222c:	85a6                	mv	a1,s1
    222e:	8526                	mv	a0,s1
    2230:	00003097          	auipc	ra,0x3
    2234:	18a080e7          	jalr	394(ra) # 53ba <link>
  if(ret != -1){
    2238:	57fd                	li	a5,-1
    223a:	08f51e63          	bne	a0,a5,22d6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    223e:	00005797          	auipc	a5,0x5
    2242:	f0278793          	add	a5,a5,-254 # 7140 <statistics+0x18e0>
    2246:	fcf43823          	sd	a5,-48(s0)
    224a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    224e:	fd040593          	add	a1,s0,-48
    2252:	8526                	mv	a0,s1
    2254:	00003097          	auipc	ra,0x3
    2258:	13e080e7          	jalr	318(ra) # 5392 <exec>
  if(ret != -1){
    225c:	57fd                	li	a5,-1
    225e:	08f51c63          	bne	a0,a5,22f6 <copyinstr3+0x12e>
}
    2262:	70a2                	ld	ra,40(sp)
    2264:	7402                	ld	s0,32(sp)
    2266:	64e2                	ld	s1,24(sp)
    2268:	6145                	add	sp,sp,48
    226a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    226c:	0347d513          	srl	a0,a5,0x34
    2270:	6785                	lui	a5,0x1
    2272:	40a7853b          	subw	a0,a5,a0
    2276:	00003097          	auipc	ra,0x3
    227a:	16c080e7          	jalr	364(ra) # 53e2 <sbrk>
    227e:	b7bd                	j	21ec <copyinstr3+0x24>
    printf("oops\n");
    2280:	00004517          	auipc	a0,0x4
    2284:	34050513          	add	a0,a0,832 # 65c0 <statistics+0xd60>
    2288:	00003097          	auipc	ra,0x3
    228c:	43a080e7          	jalr	1082(ra) # 56c2 <printf>
    exit(1);
    2290:	4505                	li	a0,1
    2292:	00003097          	auipc	ra,0x3
    2296:	0c8080e7          	jalr	200(ra) # 535a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229a:	862a                	mv	a2,a0
    229c:	85a6                	mv	a1,s1
    229e:	00004517          	auipc	a0,0x4
    22a2:	dfa50513          	add	a0,a0,-518 # 6098 <statistics+0x838>
    22a6:	00003097          	auipc	ra,0x3
    22aa:	41c080e7          	jalr	1052(ra) # 56c2 <printf>
    exit(1);
    22ae:	4505                	li	a0,1
    22b0:	00003097          	auipc	ra,0x3
    22b4:	0aa080e7          	jalr	170(ra) # 535a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22b8:	862a                	mv	a2,a0
    22ba:	85a6                	mv	a1,s1
    22bc:	00004517          	auipc	a0,0x4
    22c0:	dfc50513          	add	a0,a0,-516 # 60b8 <statistics+0x858>
    22c4:	00003097          	auipc	ra,0x3
    22c8:	3fe080e7          	jalr	1022(ra) # 56c2 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	00003097          	auipc	ra,0x3
    22d2:	08c080e7          	jalr	140(ra) # 535a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22d6:	86aa                	mv	a3,a0
    22d8:	8626                	mv	a2,s1
    22da:	85a6                	mv	a1,s1
    22dc:	00004517          	auipc	a0,0x4
    22e0:	dfc50513          	add	a0,a0,-516 # 60d8 <statistics+0x878>
    22e4:	00003097          	auipc	ra,0x3
    22e8:	3de080e7          	jalr	990(ra) # 56c2 <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	00003097          	auipc	ra,0x3
    22f2:	06c080e7          	jalr	108(ra) # 535a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22f6:	567d                	li	a2,-1
    22f8:	85a6                	mv	a1,s1
    22fa:	00004517          	auipc	a0,0x4
    22fe:	e0650513          	add	a0,a0,-506 # 6100 <statistics+0x8a0>
    2302:	00003097          	auipc	ra,0x3
    2306:	3c0080e7          	jalr	960(ra) # 56c2 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	04e080e7          	jalr	78(ra) # 535a <exit>

0000000000002314 <sbrkbasic>:
{
    2314:	7139                	add	sp,sp,-64
    2316:	fc06                	sd	ra,56(sp)
    2318:	f822                	sd	s0,48(sp)
    231a:	f426                	sd	s1,40(sp)
    231c:	f04a                	sd	s2,32(sp)
    231e:	ec4e                	sd	s3,24(sp)
    2320:	e852                	sd	s4,16(sp)
    2322:	0080                	add	s0,sp,64
    2324:	8a2a                	mv	s4,a0
  pid = fork();
    2326:	00003097          	auipc	ra,0x3
    232a:	02c080e7          	jalr	44(ra) # 5352 <fork>
  if(pid < 0){
    232e:	02054c63          	bltz	a0,2366 <sbrkbasic+0x52>
  if(pid == 0){
    2332:	ed21                	bnez	a0,238a <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2334:	40000537          	lui	a0,0x40000
    2338:	00003097          	auipc	ra,0x3
    233c:	0aa080e7          	jalr	170(ra) # 53e2 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2340:	57fd                	li	a5,-1
    2342:	02f50f63          	beq	a0,a5,2380 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2346:	400007b7          	lui	a5,0x40000
    234a:	97aa                	add	a5,a5,a0
      *b = 99;
    234c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2350:	6705                	lui	a4,0x1
      *b = 99;
    2352:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff17e8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2356:	953a                	add	a0,a0,a4
    2358:	fef51de3          	bne	a0,a5,2352 <sbrkbasic+0x3e>
    exit(1);
    235c:	4505                	li	a0,1
    235e:	00003097          	auipc	ra,0x3
    2362:	ffc080e7          	jalr	-4(ra) # 535a <exit>
    printf("fork failed in sbrkbasic\n");
    2366:	00004517          	auipc	a0,0x4
    236a:	26250513          	add	a0,a0,610 # 65c8 <statistics+0xd68>
    236e:	00003097          	auipc	ra,0x3
    2372:	354080e7          	jalr	852(ra) # 56c2 <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	00003097          	auipc	ra,0x3
    237c:	fe2080e7          	jalr	-30(ra) # 535a <exit>
      exit(0);
    2380:	4501                	li	a0,0
    2382:	00003097          	auipc	ra,0x3
    2386:	fd8080e7          	jalr	-40(ra) # 535a <exit>
  wait(&xstatus);
    238a:	fcc40513          	add	a0,s0,-52
    238e:	00003097          	auipc	ra,0x3
    2392:	fd4080e7          	jalr	-44(ra) # 5362 <wait>
  if(xstatus == 1){
    2396:	fcc42703          	lw	a4,-52(s0)
    239a:	4785                	li	a5,1
    239c:	00f70d63          	beq	a4,a5,23b6 <sbrkbasic+0xa2>
  a = sbrk(0);
    23a0:	4501                	li	a0,0
    23a2:	00003097          	auipc	ra,0x3
    23a6:	040080e7          	jalr	64(ra) # 53e2 <sbrk>
    23aa:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    23ac:	4901                	li	s2,0
    23ae:	6985                	lui	s3,0x1
    23b0:	38898993          	add	s3,s3,904 # 1388 <copyinstr2+0x1d0>
    23b4:	a005                	j	23d4 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    23b6:	85d2                	mv	a1,s4
    23b8:	00004517          	auipc	a0,0x4
    23bc:	23050513          	add	a0,a0,560 # 65e8 <statistics+0xd88>
    23c0:	00003097          	auipc	ra,0x3
    23c4:	302080e7          	jalr	770(ra) # 56c2 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	f90080e7          	jalr	-112(ra) # 535a <exit>
    a = b + 1;
    23d2:	84be                	mv	s1,a5
    b = sbrk(1);
    23d4:	4505                	li	a0,1
    23d6:	00003097          	auipc	ra,0x3
    23da:	00c080e7          	jalr	12(ra) # 53e2 <sbrk>
    if(b != a){
    23de:	04951c63          	bne	a0,s1,2436 <sbrkbasic+0x122>
    *b = 1;
    23e2:	4785                	li	a5,1
    23e4:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    23e8:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    23ec:	2905                	addw	s2,s2,1
    23ee:	ff3912e3          	bne	s2,s3,23d2 <sbrkbasic+0xbe>
  pid = fork();
    23f2:	00003097          	auipc	ra,0x3
    23f6:	f60080e7          	jalr	-160(ra) # 5352 <fork>
    23fa:	892a                	mv	s2,a0
  if(pid < 0){
    23fc:	04054d63          	bltz	a0,2456 <sbrkbasic+0x142>
  c = sbrk(1);
    2400:	4505                	li	a0,1
    2402:	00003097          	auipc	ra,0x3
    2406:	fe0080e7          	jalr	-32(ra) # 53e2 <sbrk>
  c = sbrk(1);
    240a:	4505                	li	a0,1
    240c:	00003097          	auipc	ra,0x3
    2410:	fd6080e7          	jalr	-42(ra) # 53e2 <sbrk>
  if(c != a + 1){
    2414:	0489                	add	s1,s1,2
    2416:	04a48e63          	beq	s1,a0,2472 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    241a:	85d2                	mv	a1,s4
    241c:	00004517          	auipc	a0,0x4
    2420:	22c50513          	add	a0,a0,556 # 6648 <statistics+0xde8>
    2424:	00003097          	auipc	ra,0x3
    2428:	29e080e7          	jalr	670(ra) # 56c2 <printf>
    exit(1);
    242c:	4505                	li	a0,1
    242e:	00003097          	auipc	ra,0x3
    2432:	f2c080e7          	jalr	-212(ra) # 535a <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    2436:	86aa                	mv	a3,a0
    2438:	8626                	mv	a2,s1
    243a:	85ca                	mv	a1,s2
    243c:	00004517          	auipc	a0,0x4
    2440:	1cc50513          	add	a0,a0,460 # 6608 <statistics+0xda8>
    2444:	00003097          	auipc	ra,0x3
    2448:	27e080e7          	jalr	638(ra) # 56c2 <printf>
      exit(1);
    244c:	4505                	li	a0,1
    244e:	00003097          	auipc	ra,0x3
    2452:	f0c080e7          	jalr	-244(ra) # 535a <exit>
    printf("%s: sbrk test fork failed\n", s);
    2456:	85d2                	mv	a1,s4
    2458:	00004517          	auipc	a0,0x4
    245c:	1d050513          	add	a0,a0,464 # 6628 <statistics+0xdc8>
    2460:	00003097          	auipc	ra,0x3
    2464:	262080e7          	jalr	610(ra) # 56c2 <printf>
    exit(1);
    2468:	4505                	li	a0,1
    246a:	00003097          	auipc	ra,0x3
    246e:	ef0080e7          	jalr	-272(ra) # 535a <exit>
  if(pid == 0)
    2472:	00091763          	bnez	s2,2480 <sbrkbasic+0x16c>
    exit(0);
    2476:	4501                	li	a0,0
    2478:	00003097          	auipc	ra,0x3
    247c:	ee2080e7          	jalr	-286(ra) # 535a <exit>
  wait(&xstatus);
    2480:	fcc40513          	add	a0,s0,-52
    2484:	00003097          	auipc	ra,0x3
    2488:	ede080e7          	jalr	-290(ra) # 5362 <wait>
  exit(xstatus);
    248c:	fcc42503          	lw	a0,-52(s0)
    2490:	00003097          	auipc	ra,0x3
    2494:	eca080e7          	jalr	-310(ra) # 535a <exit>

0000000000002498 <sbrkmuch>:
{
    2498:	7179                	add	sp,sp,-48
    249a:	f406                	sd	ra,40(sp)
    249c:	f022                	sd	s0,32(sp)
    249e:	ec26                	sd	s1,24(sp)
    24a0:	e84a                	sd	s2,16(sp)
    24a2:	e44e                	sd	s3,8(sp)
    24a4:	e052                	sd	s4,0(sp)
    24a6:	1800                	add	s0,sp,48
    24a8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24aa:	4501                	li	a0,0
    24ac:	00003097          	auipc	ra,0x3
    24b0:	f36080e7          	jalr	-202(ra) # 53e2 <sbrk>
    24b4:	892a                	mv	s2,a0
  a = sbrk(0);
    24b6:	4501                	li	a0,0
    24b8:	00003097          	auipc	ra,0x3
    24bc:	f2a080e7          	jalr	-214(ra) # 53e2 <sbrk>
    24c0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24c2:	06400537          	lui	a0,0x6400
    24c6:	9d05                	subw	a0,a0,s1
    24c8:	00003097          	auipc	ra,0x3
    24cc:	f1a080e7          	jalr	-230(ra) # 53e2 <sbrk>
  if (p != a) {
    24d0:	0ca49863          	bne	s1,a0,25a0 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    24d4:	4501                	li	a0,0
    24d6:	00003097          	auipc	ra,0x3
    24da:	f0c080e7          	jalr	-244(ra) # 53e2 <sbrk>
    24de:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    24e0:	00a4f963          	bgeu	s1,a0,24f2 <sbrkmuch+0x5a>
    *pp = 1;
    24e4:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    24e6:	6705                	lui	a4,0x1
    *pp = 1;
    24e8:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    24ec:	94ba                	add	s1,s1,a4
    24ee:	fef4ede3          	bltu	s1,a5,24e8 <sbrkmuch+0x50>
  *lastaddr = 99;
    24f2:	064007b7          	lui	a5,0x6400
    24f6:	06300713          	li	a4,99
    24fa:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f17e7>
  a = sbrk(0);
    24fe:	4501                	li	a0,0
    2500:	00003097          	auipc	ra,0x3
    2504:	ee2080e7          	jalr	-286(ra) # 53e2 <sbrk>
    2508:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    250a:	757d                	lui	a0,0xfffff
    250c:	00003097          	auipc	ra,0x3
    2510:	ed6080e7          	jalr	-298(ra) # 53e2 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2514:	57fd                	li	a5,-1
    2516:	0af50363          	beq	a0,a5,25bc <sbrkmuch+0x124>
  c = sbrk(0);
    251a:	4501                	li	a0,0
    251c:	00003097          	auipc	ra,0x3
    2520:	ec6080e7          	jalr	-314(ra) # 53e2 <sbrk>
  if(c != a - PGSIZE){
    2524:	77fd                	lui	a5,0xfffff
    2526:	97a6                	add	a5,a5,s1
    2528:	0af51863          	bne	a0,a5,25d8 <sbrkmuch+0x140>
  a = sbrk(0);
    252c:	4501                	li	a0,0
    252e:	00003097          	auipc	ra,0x3
    2532:	eb4080e7          	jalr	-332(ra) # 53e2 <sbrk>
    2536:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2538:	6505                	lui	a0,0x1
    253a:	00003097          	auipc	ra,0x3
    253e:	ea8080e7          	jalr	-344(ra) # 53e2 <sbrk>
    2542:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2544:	0aa49963          	bne	s1,a0,25f6 <sbrkmuch+0x15e>
    2548:	4501                	li	a0,0
    254a:	00003097          	auipc	ra,0x3
    254e:	e98080e7          	jalr	-360(ra) # 53e2 <sbrk>
    2552:	6785                	lui	a5,0x1
    2554:	97a6                	add	a5,a5,s1
    2556:	0af51063          	bne	a0,a5,25f6 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    255a:	064007b7          	lui	a5,0x6400
    255e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f17e7>
    2562:	06300793          	li	a5,99
    2566:	0af70763          	beq	a4,a5,2614 <sbrkmuch+0x17c>
  a = sbrk(0);
    256a:	4501                	li	a0,0
    256c:	00003097          	auipc	ra,0x3
    2570:	e76080e7          	jalr	-394(ra) # 53e2 <sbrk>
    2574:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2576:	4501                	li	a0,0
    2578:	00003097          	auipc	ra,0x3
    257c:	e6a080e7          	jalr	-406(ra) # 53e2 <sbrk>
    2580:	40a9053b          	subw	a0,s2,a0
    2584:	00003097          	auipc	ra,0x3
    2588:	e5e080e7          	jalr	-418(ra) # 53e2 <sbrk>
  if(c != a){
    258c:	0aa49263          	bne	s1,a0,2630 <sbrkmuch+0x198>
}
    2590:	70a2                	ld	ra,40(sp)
    2592:	7402                	ld	s0,32(sp)
    2594:	64e2                	ld	s1,24(sp)
    2596:	6942                	ld	s2,16(sp)
    2598:	69a2                	ld	s3,8(sp)
    259a:	6a02                	ld	s4,0(sp)
    259c:	6145                	add	sp,sp,48
    259e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25a0:	85ce                	mv	a1,s3
    25a2:	00004517          	auipc	a0,0x4
    25a6:	0c650513          	add	a0,a0,198 # 6668 <statistics+0xe08>
    25aa:	00003097          	auipc	ra,0x3
    25ae:	118080e7          	jalr	280(ra) # 56c2 <printf>
    exit(1);
    25b2:	4505                	li	a0,1
    25b4:	00003097          	auipc	ra,0x3
    25b8:	da6080e7          	jalr	-602(ra) # 535a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25bc:	85ce                	mv	a1,s3
    25be:	00004517          	auipc	a0,0x4
    25c2:	0f250513          	add	a0,a0,242 # 66b0 <statistics+0xe50>
    25c6:	00003097          	auipc	ra,0x3
    25ca:	0fc080e7          	jalr	252(ra) # 56c2 <printf>
    exit(1);
    25ce:	4505                	li	a0,1
    25d0:	00003097          	auipc	ra,0x3
    25d4:	d8a080e7          	jalr	-630(ra) # 535a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    25d8:	862a                	mv	a2,a0
    25da:	85a6                	mv	a1,s1
    25dc:	00004517          	auipc	a0,0x4
    25e0:	0f450513          	add	a0,a0,244 # 66d0 <statistics+0xe70>
    25e4:	00003097          	auipc	ra,0x3
    25e8:	0de080e7          	jalr	222(ra) # 56c2 <printf>
    exit(1);
    25ec:	4505                	li	a0,1
    25ee:	00003097          	auipc	ra,0x3
    25f2:	d6c080e7          	jalr	-660(ra) # 535a <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    25f6:	8652                	mv	a2,s4
    25f8:	85a6                	mv	a1,s1
    25fa:	00004517          	auipc	a0,0x4
    25fe:	11650513          	add	a0,a0,278 # 6710 <statistics+0xeb0>
    2602:	00003097          	auipc	ra,0x3
    2606:	0c0080e7          	jalr	192(ra) # 56c2 <printf>
    exit(1);
    260a:	4505                	li	a0,1
    260c:	00003097          	auipc	ra,0x3
    2610:	d4e080e7          	jalr	-690(ra) # 535a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2614:	85ce                	mv	a1,s3
    2616:	00004517          	auipc	a0,0x4
    261a:	12a50513          	add	a0,a0,298 # 6740 <statistics+0xee0>
    261e:	00003097          	auipc	ra,0x3
    2622:	0a4080e7          	jalr	164(ra) # 56c2 <printf>
    exit(1);
    2626:	4505                	li	a0,1
    2628:	00003097          	auipc	ra,0x3
    262c:	d32080e7          	jalr	-718(ra) # 535a <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2630:	862a                	mv	a2,a0
    2632:	85a6                	mv	a1,s1
    2634:	00004517          	auipc	a0,0x4
    2638:	14450513          	add	a0,a0,324 # 6778 <statistics+0xf18>
    263c:	00003097          	auipc	ra,0x3
    2640:	086080e7          	jalr	134(ra) # 56c2 <printf>
    exit(1);
    2644:	4505                	li	a0,1
    2646:	00003097          	auipc	ra,0x3
    264a:	d14080e7          	jalr	-748(ra) # 535a <exit>

000000000000264e <sbrkarg>:
{
    264e:	7179                	add	sp,sp,-48
    2650:	f406                	sd	ra,40(sp)
    2652:	f022                	sd	s0,32(sp)
    2654:	ec26                	sd	s1,24(sp)
    2656:	e84a                	sd	s2,16(sp)
    2658:	e44e                	sd	s3,8(sp)
    265a:	1800                	add	s0,sp,48
    265c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    265e:	6505                	lui	a0,0x1
    2660:	00003097          	auipc	ra,0x3
    2664:	d82080e7          	jalr	-638(ra) # 53e2 <sbrk>
    2668:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    266a:	20100593          	li	a1,513
    266e:	00004517          	auipc	a0,0x4
    2672:	13250513          	add	a0,a0,306 # 67a0 <statistics+0xf40>
    2676:	00003097          	auipc	ra,0x3
    267a:	d24080e7          	jalr	-732(ra) # 539a <open>
    267e:	84aa                	mv	s1,a0
  unlink("sbrk");
    2680:	00004517          	auipc	a0,0x4
    2684:	12050513          	add	a0,a0,288 # 67a0 <statistics+0xf40>
    2688:	00003097          	auipc	ra,0x3
    268c:	d22080e7          	jalr	-734(ra) # 53aa <unlink>
  if(fd < 0)  {
    2690:	0404c163          	bltz	s1,26d2 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2694:	6605                	lui	a2,0x1
    2696:	85ca                	mv	a1,s2
    2698:	8526                	mv	a0,s1
    269a:	00003097          	auipc	ra,0x3
    269e:	ce0080e7          	jalr	-800(ra) # 537a <write>
    26a2:	04054663          	bltz	a0,26ee <sbrkarg+0xa0>
  close(fd);
    26a6:	8526                	mv	a0,s1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	cda080e7          	jalr	-806(ra) # 5382 <close>
  a = sbrk(PGSIZE);
    26b0:	6505                	lui	a0,0x1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	d30080e7          	jalr	-720(ra) # 53e2 <sbrk>
  if(pipe((int *) a) != 0){
    26ba:	00003097          	auipc	ra,0x3
    26be:	cb0080e7          	jalr	-848(ra) # 536a <pipe>
    26c2:	e521                	bnez	a0,270a <sbrkarg+0xbc>
}
    26c4:	70a2                	ld	ra,40(sp)
    26c6:	7402                	ld	s0,32(sp)
    26c8:	64e2                	ld	s1,24(sp)
    26ca:	6942                	ld	s2,16(sp)
    26cc:	69a2                	ld	s3,8(sp)
    26ce:	6145                	add	sp,sp,48
    26d0:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    26d2:	85ce                	mv	a1,s3
    26d4:	00004517          	auipc	a0,0x4
    26d8:	0d450513          	add	a0,a0,212 # 67a8 <statistics+0xf48>
    26dc:	00003097          	auipc	ra,0x3
    26e0:	fe6080e7          	jalr	-26(ra) # 56c2 <printf>
    exit(1);
    26e4:	4505                	li	a0,1
    26e6:	00003097          	auipc	ra,0x3
    26ea:	c74080e7          	jalr	-908(ra) # 535a <exit>
    printf("%s: write sbrk failed\n", s);
    26ee:	85ce                	mv	a1,s3
    26f0:	00004517          	auipc	a0,0x4
    26f4:	0d050513          	add	a0,a0,208 # 67c0 <statistics+0xf60>
    26f8:	00003097          	auipc	ra,0x3
    26fc:	fca080e7          	jalr	-54(ra) # 56c2 <printf>
    exit(1);
    2700:	4505                	li	a0,1
    2702:	00003097          	auipc	ra,0x3
    2706:	c58080e7          	jalr	-936(ra) # 535a <exit>
    printf("%s: pipe() failed\n", s);
    270a:	85ce                	mv	a1,s3
    270c:	00004517          	auipc	a0,0x4
    2710:	b7450513          	add	a0,a0,-1164 # 6280 <statistics+0xa20>
    2714:	00003097          	auipc	ra,0x3
    2718:	fae080e7          	jalr	-82(ra) # 56c2 <printf>
    exit(1);
    271c:	4505                	li	a0,1
    271e:	00003097          	auipc	ra,0x3
    2722:	c3c080e7          	jalr	-964(ra) # 535a <exit>

0000000000002726 <argptest>:
{
    2726:	1101                	add	sp,sp,-32
    2728:	ec06                	sd	ra,24(sp)
    272a:	e822                	sd	s0,16(sp)
    272c:	e426                	sd	s1,8(sp)
    272e:	e04a                	sd	s2,0(sp)
    2730:	1000                	add	s0,sp,32
    2732:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2734:	4581                	li	a1,0
    2736:	00004517          	auipc	a0,0x4
    273a:	0a250513          	add	a0,a0,162 # 67d8 <statistics+0xf78>
    273e:	00003097          	auipc	ra,0x3
    2742:	c5c080e7          	jalr	-932(ra) # 539a <open>
  if (fd < 0) {
    2746:	02054b63          	bltz	a0,277c <argptest+0x56>
    274a:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    274c:	4501                	li	a0,0
    274e:	00003097          	auipc	ra,0x3
    2752:	c94080e7          	jalr	-876(ra) # 53e2 <sbrk>
    2756:	567d                	li	a2,-1
    2758:	fff50593          	add	a1,a0,-1
    275c:	8526                	mv	a0,s1
    275e:	00003097          	auipc	ra,0x3
    2762:	c14080e7          	jalr	-1004(ra) # 5372 <read>
  close(fd);
    2766:	8526                	mv	a0,s1
    2768:	00003097          	auipc	ra,0x3
    276c:	c1a080e7          	jalr	-998(ra) # 5382 <close>
}
    2770:	60e2                	ld	ra,24(sp)
    2772:	6442                	ld	s0,16(sp)
    2774:	64a2                	ld	s1,8(sp)
    2776:	6902                	ld	s2,0(sp)
    2778:	6105                	add	sp,sp,32
    277a:	8082                	ret
    printf("%s: open failed\n", s);
    277c:	85ca                	mv	a1,s2
    277e:	00004517          	auipc	a0,0x4
    2782:	a1250513          	add	a0,a0,-1518 # 6190 <statistics+0x930>
    2786:	00003097          	auipc	ra,0x3
    278a:	f3c080e7          	jalr	-196(ra) # 56c2 <printf>
    exit(1);
    278e:	4505                	li	a0,1
    2790:	00003097          	auipc	ra,0x3
    2794:	bca080e7          	jalr	-1078(ra) # 535a <exit>

0000000000002798 <sbrkbugs>:
{
    2798:	1141                	add	sp,sp,-16
    279a:	e406                	sd	ra,8(sp)
    279c:	e022                	sd	s0,0(sp)
    279e:	0800                	add	s0,sp,16
  int pid = fork();
    27a0:	00003097          	auipc	ra,0x3
    27a4:	bb2080e7          	jalr	-1102(ra) # 5352 <fork>
  if(pid < 0){
    27a8:	02054263          	bltz	a0,27cc <sbrkbugs+0x34>
  if(pid == 0){
    27ac:	ed0d                	bnez	a0,27e6 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    27ae:	00003097          	auipc	ra,0x3
    27b2:	c34080e7          	jalr	-972(ra) # 53e2 <sbrk>
    sbrk(-sz);
    27b6:	40a0053b          	negw	a0,a0
    27ba:	00003097          	auipc	ra,0x3
    27be:	c28080e7          	jalr	-984(ra) # 53e2 <sbrk>
    exit(0);
    27c2:	4501                	li	a0,0
    27c4:	00003097          	auipc	ra,0x3
    27c8:	b96080e7          	jalr	-1130(ra) # 535a <exit>
    printf("fork failed\n");
    27cc:	00004517          	auipc	a0,0x4
    27d0:	d9c50513          	add	a0,a0,-612 # 6568 <statistics+0xd08>
    27d4:	00003097          	auipc	ra,0x3
    27d8:	eee080e7          	jalr	-274(ra) # 56c2 <printf>
    exit(1);
    27dc:	4505                	li	a0,1
    27de:	00003097          	auipc	ra,0x3
    27e2:	b7c080e7          	jalr	-1156(ra) # 535a <exit>
  wait(0);
    27e6:	4501                	li	a0,0
    27e8:	00003097          	auipc	ra,0x3
    27ec:	b7a080e7          	jalr	-1158(ra) # 5362 <wait>
  pid = fork();
    27f0:	00003097          	auipc	ra,0x3
    27f4:	b62080e7          	jalr	-1182(ra) # 5352 <fork>
  if(pid < 0){
    27f8:	02054563          	bltz	a0,2822 <sbrkbugs+0x8a>
  if(pid == 0){
    27fc:	e121                	bnez	a0,283c <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    27fe:	00003097          	auipc	ra,0x3
    2802:	be4080e7          	jalr	-1052(ra) # 53e2 <sbrk>
    sbrk(-(sz - 3500));
    2806:	6785                	lui	a5,0x1
    2808:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x90>
    280c:	40a7853b          	subw	a0,a5,a0
    2810:	00003097          	auipc	ra,0x3
    2814:	bd2080e7          	jalr	-1070(ra) # 53e2 <sbrk>
    exit(0);
    2818:	4501                	li	a0,0
    281a:	00003097          	auipc	ra,0x3
    281e:	b40080e7          	jalr	-1216(ra) # 535a <exit>
    printf("fork failed\n");
    2822:	00004517          	auipc	a0,0x4
    2826:	d4650513          	add	a0,a0,-698 # 6568 <statistics+0xd08>
    282a:	00003097          	auipc	ra,0x3
    282e:	e98080e7          	jalr	-360(ra) # 56c2 <printf>
    exit(1);
    2832:	4505                	li	a0,1
    2834:	00003097          	auipc	ra,0x3
    2838:	b26080e7          	jalr	-1242(ra) # 535a <exit>
  wait(0);
    283c:	4501                	li	a0,0
    283e:	00003097          	auipc	ra,0x3
    2842:	b24080e7          	jalr	-1244(ra) # 5362 <wait>
  pid = fork();
    2846:	00003097          	auipc	ra,0x3
    284a:	b0c080e7          	jalr	-1268(ra) # 5352 <fork>
  if(pid < 0){
    284e:	02054a63          	bltz	a0,2882 <sbrkbugs+0xea>
  if(pid == 0){
    2852:	e529                	bnez	a0,289c <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2854:	00003097          	auipc	ra,0x3
    2858:	b8e080e7          	jalr	-1138(ra) # 53e2 <sbrk>
    285c:	67ad                	lui	a5,0xb
    285e:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1708>
    2862:	40a7853b          	subw	a0,a5,a0
    2866:	00003097          	auipc	ra,0x3
    286a:	b7c080e7          	jalr	-1156(ra) # 53e2 <sbrk>
    sbrk(-10);
    286e:	5559                	li	a0,-10
    2870:	00003097          	auipc	ra,0x3
    2874:	b72080e7          	jalr	-1166(ra) # 53e2 <sbrk>
    exit(0);
    2878:	4501                	li	a0,0
    287a:	00003097          	auipc	ra,0x3
    287e:	ae0080e7          	jalr	-1312(ra) # 535a <exit>
    printf("fork failed\n");
    2882:	00004517          	auipc	a0,0x4
    2886:	ce650513          	add	a0,a0,-794 # 6568 <statistics+0xd08>
    288a:	00003097          	auipc	ra,0x3
    288e:	e38080e7          	jalr	-456(ra) # 56c2 <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	ac6080e7          	jalr	-1338(ra) # 535a <exit>
  wait(0);
    289c:	4501                	li	a0,0
    289e:	00003097          	auipc	ra,0x3
    28a2:	ac4080e7          	jalr	-1340(ra) # 5362 <wait>
  exit(0);
    28a6:	4501                	li	a0,0
    28a8:	00003097          	auipc	ra,0x3
    28ac:	ab2080e7          	jalr	-1358(ra) # 535a <exit>

00000000000028b0 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28b0:	715d                	add	sp,sp,-80
    28b2:	e486                	sd	ra,72(sp)
    28b4:	e0a2                	sd	s0,64(sp)
    28b6:	fc26                	sd	s1,56(sp)
    28b8:	f84a                	sd	s2,48(sp)
    28ba:	f44e                	sd	s3,40(sp)
    28bc:	f052                	sd	s4,32(sp)
    28be:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28c0:	4901                	li	s2,0
    28c2:	49bd                	li	s3,15
    int pid = fork();
    28c4:	00003097          	auipc	ra,0x3
    28c8:	a8e080e7          	jalr	-1394(ra) # 5352 <fork>
    28cc:	84aa                	mv	s1,a0
    if(pid < 0){
    28ce:	02054063          	bltz	a0,28ee <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    28d2:	c91d                	beqz	a0,2908 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    28d4:	4501                	li	a0,0
    28d6:	00003097          	auipc	ra,0x3
    28da:	a8c080e7          	jalr	-1396(ra) # 5362 <wait>
  for(int avail = 0; avail < 15; avail++){
    28de:	2905                	addw	s2,s2,1
    28e0:	ff3912e3          	bne	s2,s3,28c4 <execout+0x14>
    }
  }

  exit(0);
    28e4:	4501                	li	a0,0
    28e6:	00003097          	auipc	ra,0x3
    28ea:	a74080e7          	jalr	-1420(ra) # 535a <exit>
      printf("fork failed\n");
    28ee:	00004517          	auipc	a0,0x4
    28f2:	c7a50513          	add	a0,a0,-902 # 6568 <statistics+0xd08>
    28f6:	00003097          	auipc	ra,0x3
    28fa:	dcc080e7          	jalr	-564(ra) # 56c2 <printf>
      exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	a5a080e7          	jalr	-1446(ra) # 535a <exit>
        if(a == 0xffffffffffffffffLL)
    2908:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    290a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    290c:	6505                	lui	a0,0x1
    290e:	00003097          	auipc	ra,0x3
    2912:	ad4080e7          	jalr	-1324(ra) # 53e2 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2916:	01350763          	beq	a0,s3,2924 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    291a:	6785                	lui	a5,0x1
    291c:	97aa                	add	a5,a5,a0
    291e:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x97>
      while(1){
    2922:	b7ed                	j	290c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2924:	01205a63          	blez	s2,2938 <execout+0x88>
        sbrk(-4096);
    2928:	757d                	lui	a0,0xfffff
    292a:	00003097          	auipc	ra,0x3
    292e:	ab8080e7          	jalr	-1352(ra) # 53e2 <sbrk>
      for(int i = 0; i < avail; i++)
    2932:	2485                	addw	s1,s1,1
    2934:	ff249ae3          	bne	s1,s2,2928 <execout+0x78>
      close(1);
    2938:	4505                	li	a0,1
    293a:	00003097          	auipc	ra,0x3
    293e:	a48080e7          	jalr	-1464(ra) # 5382 <close>
      char *args[] = { "echo", "x", 0 };
    2942:	00003517          	auipc	a0,0x3
    2946:	fde50513          	add	a0,a0,-34 # 5920 <statistics+0xc0>
    294a:	faa43c23          	sd	a0,-72(s0)
    294e:	00003797          	auipc	a5,0x3
    2952:	04278793          	add	a5,a5,66 # 5990 <statistics+0x130>
    2956:	fcf43023          	sd	a5,-64(s0)
    295a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    295e:	fb840593          	add	a1,s0,-72
    2962:	00003097          	auipc	ra,0x3
    2966:	a30080e7          	jalr	-1488(ra) # 5392 <exec>
      exit(0);
    296a:	4501                	li	a0,0
    296c:	00003097          	auipc	ra,0x3
    2970:	9ee080e7          	jalr	-1554(ra) # 535a <exit>

0000000000002974 <fourteen>:
{
    2974:	1101                	add	sp,sp,-32
    2976:	ec06                	sd	ra,24(sp)
    2978:	e822                	sd	s0,16(sp)
    297a:	e426                	sd	s1,8(sp)
    297c:	1000                	add	s0,sp,32
    297e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2980:	00004517          	auipc	a0,0x4
    2984:	03050513          	add	a0,a0,48 # 69b0 <statistics+0x1150>
    2988:	00003097          	auipc	ra,0x3
    298c:	a3a080e7          	jalr	-1478(ra) # 53c2 <mkdir>
    2990:	e165                	bnez	a0,2a70 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2992:	00004517          	auipc	a0,0x4
    2996:	e7650513          	add	a0,a0,-394 # 6808 <statistics+0xfa8>
    299a:	00003097          	auipc	ra,0x3
    299e:	a28080e7          	jalr	-1496(ra) # 53c2 <mkdir>
    29a2:	e56d                	bnez	a0,2a8c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29a4:	20000593          	li	a1,512
    29a8:	00004517          	auipc	a0,0x4
    29ac:	eb850513          	add	a0,a0,-328 # 6860 <statistics+0x1000>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	9ea080e7          	jalr	-1558(ra) # 539a <open>
  if(fd < 0){
    29b8:	0e054863          	bltz	a0,2aa8 <fourteen+0x134>
  close(fd);
    29bc:	00003097          	auipc	ra,0x3
    29c0:	9c6080e7          	jalr	-1594(ra) # 5382 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29c4:	4581                	li	a1,0
    29c6:	00004517          	auipc	a0,0x4
    29ca:	f1250513          	add	a0,a0,-238 # 68d8 <statistics+0x1078>
    29ce:	00003097          	auipc	ra,0x3
    29d2:	9cc080e7          	jalr	-1588(ra) # 539a <open>
  if(fd < 0){
    29d6:	0e054763          	bltz	a0,2ac4 <fourteen+0x150>
  close(fd);
    29da:	00003097          	auipc	ra,0x3
    29de:	9a8080e7          	jalr	-1624(ra) # 5382 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    29e2:	00004517          	auipc	a0,0x4
    29e6:	f6650513          	add	a0,a0,-154 # 6948 <statistics+0x10e8>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	9d8080e7          	jalr	-1576(ra) # 53c2 <mkdir>
    29f2:	c57d                	beqz	a0,2ae0 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    29f4:	00004517          	auipc	a0,0x4
    29f8:	fac50513          	add	a0,a0,-84 # 69a0 <statistics+0x1140>
    29fc:	00003097          	auipc	ra,0x3
    2a00:	9c6080e7          	jalr	-1594(ra) # 53c2 <mkdir>
    2a04:	cd65                	beqz	a0,2afc <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a06:	00004517          	auipc	a0,0x4
    2a0a:	f9a50513          	add	a0,a0,-102 # 69a0 <statistics+0x1140>
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	99c080e7          	jalr	-1636(ra) # 53aa <unlink>
  unlink("12345678901234/12345678901234");
    2a16:	00004517          	auipc	a0,0x4
    2a1a:	f3250513          	add	a0,a0,-206 # 6948 <statistics+0x10e8>
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	98c080e7          	jalr	-1652(ra) # 53aa <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	eb250513          	add	a0,a0,-334 # 68d8 <statistics+0x1078>
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	97c080e7          	jalr	-1668(ra) # 53aa <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	e2a50513          	add	a0,a0,-470 # 6860 <statistics+0x1000>
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	96c080e7          	jalr	-1684(ra) # 53aa <unlink>
  unlink("12345678901234/123456789012345");
    2a46:	00004517          	auipc	a0,0x4
    2a4a:	dc250513          	add	a0,a0,-574 # 6808 <statistics+0xfa8>
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	95c080e7          	jalr	-1700(ra) # 53aa <unlink>
  unlink("12345678901234");
    2a56:	00004517          	auipc	a0,0x4
    2a5a:	f5a50513          	add	a0,a0,-166 # 69b0 <statistics+0x1150>
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	94c080e7          	jalr	-1716(ra) # 53aa <unlink>
}
    2a66:	60e2                	ld	ra,24(sp)
    2a68:	6442                	ld	s0,16(sp)
    2a6a:	64a2                	ld	s1,8(sp)
    2a6c:	6105                	add	sp,sp,32
    2a6e:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a70:	85a6                	mv	a1,s1
    2a72:	00004517          	auipc	a0,0x4
    2a76:	d6e50513          	add	a0,a0,-658 # 67e0 <statistics+0xf80>
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	c48080e7          	jalr	-952(ra) # 56c2 <printf>
    exit(1);
    2a82:	4505                	li	a0,1
    2a84:	00003097          	auipc	ra,0x3
    2a88:	8d6080e7          	jalr	-1834(ra) # 535a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2a8c:	85a6                	mv	a1,s1
    2a8e:	00004517          	auipc	a0,0x4
    2a92:	d9a50513          	add	a0,a0,-614 # 6828 <statistics+0xfc8>
    2a96:	00003097          	auipc	ra,0x3
    2a9a:	c2c080e7          	jalr	-980(ra) # 56c2 <printf>
    exit(1);
    2a9e:	4505                	li	a0,1
    2aa0:	00003097          	auipc	ra,0x3
    2aa4:	8ba080e7          	jalr	-1862(ra) # 535a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	de650513          	add	a0,a0,-538 # 6890 <statistics+0x1030>
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	c10080e7          	jalr	-1008(ra) # 56c2 <printf>
    exit(1);
    2aba:	4505                	li	a0,1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	89e080e7          	jalr	-1890(ra) # 535a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2ac4:	85a6                	mv	a1,s1
    2ac6:	00004517          	auipc	a0,0x4
    2aca:	e4250513          	add	a0,a0,-446 # 6908 <statistics+0x10a8>
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	bf4080e7          	jalr	-1036(ra) # 56c2 <printf>
    exit(1);
    2ad6:	4505                	li	a0,1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	882080e7          	jalr	-1918(ra) # 535a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2ae0:	85a6                	mv	a1,s1
    2ae2:	00004517          	auipc	a0,0x4
    2ae6:	e8650513          	add	a0,a0,-378 # 6968 <statistics+0x1108>
    2aea:	00003097          	auipc	ra,0x3
    2aee:	bd8080e7          	jalr	-1064(ra) # 56c2 <printf>
    exit(1);
    2af2:	4505                	li	a0,1
    2af4:	00003097          	auipc	ra,0x3
    2af8:	866080e7          	jalr	-1946(ra) # 535a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2afc:	85a6                	mv	a1,s1
    2afe:	00004517          	auipc	a0,0x4
    2b02:	ec250513          	add	a0,a0,-318 # 69c0 <statistics+0x1160>
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	bbc080e7          	jalr	-1092(ra) # 56c2 <printf>
    exit(1);
    2b0e:	4505                	li	a0,1
    2b10:	00003097          	auipc	ra,0x3
    2b14:	84a080e7          	jalr	-1974(ra) # 535a <exit>

0000000000002b18 <iputtest>:
{
    2b18:	1101                	add	sp,sp,-32
    2b1a:	ec06                	sd	ra,24(sp)
    2b1c:	e822                	sd	s0,16(sp)
    2b1e:	e426                	sd	s1,8(sp)
    2b20:	1000                	add	s0,sp,32
    2b22:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	ed450513          	add	a0,a0,-300 # 69f8 <statistics+0x1198>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	896080e7          	jalr	-1898(ra) # 53c2 <mkdir>
    2b34:	04054563          	bltz	a0,2b7e <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	ec050513          	add	a0,a0,-320 # 69f8 <statistics+0x1198>
    2b40:	00003097          	auipc	ra,0x3
    2b44:	88a080e7          	jalr	-1910(ra) # 53ca <chdir>
    2b48:	04054963          	bltz	a0,2b9a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	eec50513          	add	a0,a0,-276 # 6a38 <statistics+0x11d8>
    2b54:	00003097          	auipc	ra,0x3
    2b58:	856080e7          	jalr	-1962(ra) # 53aa <unlink>
    2b5c:	04054d63          	bltz	a0,2bb6 <iputtest+0x9e>
  if(chdir("/") < 0){
    2b60:	00004517          	auipc	a0,0x4
    2b64:	f0850513          	add	a0,a0,-248 # 6a68 <statistics+0x1208>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	862080e7          	jalr	-1950(ra) # 53ca <chdir>
    2b70:	06054163          	bltz	a0,2bd2 <iputtest+0xba>
}
    2b74:	60e2                	ld	ra,24(sp)
    2b76:	6442                	ld	s0,16(sp)
    2b78:	64a2                	ld	s1,8(sp)
    2b7a:	6105                	add	sp,sp,32
    2b7c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b7e:	85a6                	mv	a1,s1
    2b80:	00004517          	auipc	a0,0x4
    2b84:	e8050513          	add	a0,a0,-384 # 6a00 <statistics+0x11a0>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	b3a080e7          	jalr	-1222(ra) # 56c2 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00002097          	auipc	ra,0x2
    2b96:	7c8080e7          	jalr	1992(ra) # 535a <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	e7c50513          	add	a0,a0,-388 # 6a18 <statistics+0x11b8>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	b1e080e7          	jalr	-1250(ra) # 56c2 <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00002097          	auipc	ra,0x2
    2bb2:	7ac080e7          	jalr	1964(ra) # 535a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2bb6:	85a6                	mv	a1,s1
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	e9050513          	add	a0,a0,-368 # 6a48 <statistics+0x11e8>
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	b02080e7          	jalr	-1278(ra) # 56c2 <printf>
    exit(1);
    2bc8:	4505                	li	a0,1
    2bca:	00002097          	auipc	ra,0x2
    2bce:	790080e7          	jalr	1936(ra) # 535a <exit>
    printf("%s: chdir / failed\n", s);
    2bd2:	85a6                	mv	a1,s1
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	e9c50513          	add	a0,a0,-356 # 6a70 <statistics+0x1210>
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	ae6080e7          	jalr	-1306(ra) # 56c2 <printf>
    exit(1);
    2be4:	4505                	li	a0,1
    2be6:	00002097          	auipc	ra,0x2
    2bea:	774080e7          	jalr	1908(ra) # 535a <exit>

0000000000002bee <exitiputtest>:
{
    2bee:	7179                	add	sp,sp,-48
    2bf0:	f406                	sd	ra,40(sp)
    2bf2:	f022                	sd	s0,32(sp)
    2bf4:	ec26                	sd	s1,24(sp)
    2bf6:	1800                	add	s0,sp,48
    2bf8:	84aa                	mv	s1,a0
  pid = fork();
    2bfa:	00002097          	auipc	ra,0x2
    2bfe:	758080e7          	jalr	1880(ra) # 5352 <fork>
  if(pid < 0){
    2c02:	04054663          	bltz	a0,2c4e <exitiputtest+0x60>
  if(pid == 0){
    2c06:	ed45                	bnez	a0,2cbe <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	df050513          	add	a0,a0,-528 # 69f8 <statistics+0x1198>
    2c10:	00002097          	auipc	ra,0x2
    2c14:	7b2080e7          	jalr	1970(ra) # 53c2 <mkdir>
    2c18:	04054963          	bltz	a0,2c6a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c1c:	00004517          	auipc	a0,0x4
    2c20:	ddc50513          	add	a0,a0,-548 # 69f8 <statistics+0x1198>
    2c24:	00002097          	auipc	ra,0x2
    2c28:	7a6080e7          	jalr	1958(ra) # 53ca <chdir>
    2c2c:	04054d63          	bltz	a0,2c86 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c30:	00004517          	auipc	a0,0x4
    2c34:	e0850513          	add	a0,a0,-504 # 6a38 <statistics+0x11d8>
    2c38:	00002097          	auipc	ra,0x2
    2c3c:	772080e7          	jalr	1906(ra) # 53aa <unlink>
    2c40:	06054163          	bltz	a0,2ca2 <exitiputtest+0xb4>
    exit(0);
    2c44:	4501                	li	a0,0
    2c46:	00002097          	auipc	ra,0x2
    2c4a:	714080e7          	jalr	1812(ra) # 535a <exit>
    printf("%s: fork failed\n", s);
    2c4e:	85a6                	mv	a1,s1
    2c50:	00003517          	auipc	a0,0x3
    2c54:	52850513          	add	a0,a0,1320 # 6178 <statistics+0x918>
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	a6a080e7          	jalr	-1430(ra) # 56c2 <printf>
    exit(1);
    2c60:	4505                	li	a0,1
    2c62:	00002097          	auipc	ra,0x2
    2c66:	6f8080e7          	jalr	1784(ra) # 535a <exit>
      printf("%s: mkdir failed\n", s);
    2c6a:	85a6                	mv	a1,s1
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	d9450513          	add	a0,a0,-620 # 6a00 <statistics+0x11a0>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	a4e080e7          	jalr	-1458(ra) # 56c2 <printf>
      exit(1);
    2c7c:	4505                	li	a0,1
    2c7e:	00002097          	auipc	ra,0x2
    2c82:	6dc080e7          	jalr	1756(ra) # 535a <exit>
      printf("%s: child chdir failed\n", s);
    2c86:	85a6                	mv	a1,s1
    2c88:	00004517          	auipc	a0,0x4
    2c8c:	e0050513          	add	a0,a0,-512 # 6a88 <statistics+0x1228>
    2c90:	00003097          	auipc	ra,0x3
    2c94:	a32080e7          	jalr	-1486(ra) # 56c2 <printf>
      exit(1);
    2c98:	4505                	li	a0,1
    2c9a:	00002097          	auipc	ra,0x2
    2c9e:	6c0080e7          	jalr	1728(ra) # 535a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ca2:	85a6                	mv	a1,s1
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	da450513          	add	a0,a0,-604 # 6a48 <statistics+0x11e8>
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	a16080e7          	jalr	-1514(ra) # 56c2 <printf>
      exit(1);
    2cb4:	4505                	li	a0,1
    2cb6:	00002097          	auipc	ra,0x2
    2cba:	6a4080e7          	jalr	1700(ra) # 535a <exit>
  wait(&xstatus);
    2cbe:	fdc40513          	add	a0,s0,-36
    2cc2:	00002097          	auipc	ra,0x2
    2cc6:	6a0080e7          	jalr	1696(ra) # 5362 <wait>
  exit(xstatus);
    2cca:	fdc42503          	lw	a0,-36(s0)
    2cce:	00002097          	auipc	ra,0x2
    2cd2:	68c080e7          	jalr	1676(ra) # 535a <exit>

0000000000002cd6 <subdir>:
{
    2cd6:	1101                	add	sp,sp,-32
    2cd8:	ec06                	sd	ra,24(sp)
    2cda:	e822                	sd	s0,16(sp)
    2cdc:	e426                	sd	s1,8(sp)
    2cde:	e04a                	sd	s2,0(sp)
    2ce0:	1000                	add	s0,sp,32
    2ce2:	892a                	mv	s2,a0
  unlink("ff");
    2ce4:	00004517          	auipc	a0,0x4
    2ce8:	eec50513          	add	a0,a0,-276 # 6bd0 <statistics+0x1370>
    2cec:	00002097          	auipc	ra,0x2
    2cf0:	6be080e7          	jalr	1726(ra) # 53aa <unlink>
  if(mkdir("dd") != 0){
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	dac50513          	add	a0,a0,-596 # 6aa0 <statistics+0x1240>
    2cfc:	00002097          	auipc	ra,0x2
    2d00:	6c6080e7          	jalr	1734(ra) # 53c2 <mkdir>
    2d04:	38051663          	bnez	a0,3090 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d08:	20200593          	li	a1,514
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	db450513          	add	a0,a0,-588 # 6ac0 <statistics+0x1260>
    2d14:	00002097          	auipc	ra,0x2
    2d18:	686080e7          	jalr	1670(ra) # 539a <open>
    2d1c:	84aa                	mv	s1,a0
  if(fd < 0){
    2d1e:	38054763          	bltz	a0,30ac <subdir+0x3d6>
  write(fd, "ff", 2);
    2d22:	4609                	li	a2,2
    2d24:	00004597          	auipc	a1,0x4
    2d28:	eac58593          	add	a1,a1,-340 # 6bd0 <statistics+0x1370>
    2d2c:	00002097          	auipc	ra,0x2
    2d30:	64e080e7          	jalr	1614(ra) # 537a <write>
  close(fd);
    2d34:	8526                	mv	a0,s1
    2d36:	00002097          	auipc	ra,0x2
    2d3a:	64c080e7          	jalr	1612(ra) # 5382 <close>
  if(unlink("dd") >= 0){
    2d3e:	00004517          	auipc	a0,0x4
    2d42:	d6250513          	add	a0,a0,-670 # 6aa0 <statistics+0x1240>
    2d46:	00002097          	auipc	ra,0x2
    2d4a:	664080e7          	jalr	1636(ra) # 53aa <unlink>
    2d4e:	36055d63          	bgez	a0,30c8 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d52:	00004517          	auipc	a0,0x4
    2d56:	dc650513          	add	a0,a0,-570 # 6b18 <statistics+0x12b8>
    2d5a:	00002097          	auipc	ra,0x2
    2d5e:	668080e7          	jalr	1640(ra) # 53c2 <mkdir>
    2d62:	38051163          	bnez	a0,30e4 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d66:	20200593          	li	a1,514
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	dd650513          	add	a0,a0,-554 # 6b40 <statistics+0x12e0>
    2d72:	00002097          	auipc	ra,0x2
    2d76:	628080e7          	jalr	1576(ra) # 539a <open>
    2d7a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d7c:	38054263          	bltz	a0,3100 <subdir+0x42a>
  write(fd, "FF", 2);
    2d80:	4609                	li	a2,2
    2d82:	00004597          	auipc	a1,0x4
    2d86:	dee58593          	add	a1,a1,-530 # 6b70 <statistics+0x1310>
    2d8a:	00002097          	auipc	ra,0x2
    2d8e:	5f0080e7          	jalr	1520(ra) # 537a <write>
  close(fd);
    2d92:	8526                	mv	a0,s1
    2d94:	00002097          	auipc	ra,0x2
    2d98:	5ee080e7          	jalr	1518(ra) # 5382 <close>
  fd = open("dd/dd/../ff", 0);
    2d9c:	4581                	li	a1,0
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	dda50513          	add	a0,a0,-550 # 6b78 <statistics+0x1318>
    2da6:	00002097          	auipc	ra,0x2
    2daa:	5f4080e7          	jalr	1524(ra) # 539a <open>
    2dae:	84aa                	mv	s1,a0
  if(fd < 0){
    2db0:	36054663          	bltz	a0,311c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2db4:	660d                	lui	a2,0x3
    2db6:	00009597          	auipc	a1,0x9
    2dba:	a5258593          	add	a1,a1,-1454 # b808 <buf>
    2dbe:	00002097          	auipc	ra,0x2
    2dc2:	5b4080e7          	jalr	1460(ra) # 5372 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc6:	4789                	li	a5,2
    2dc8:	36f51863          	bne	a0,a5,3138 <subdir+0x462>
    2dcc:	00009717          	auipc	a4,0x9
    2dd0:	a3c74703          	lbu	a4,-1476(a4) # b808 <buf>
    2dd4:	06600793          	li	a5,102
    2dd8:	36f71063          	bne	a4,a5,3138 <subdir+0x462>
  close(fd);
    2ddc:	8526                	mv	a0,s1
    2dde:	00002097          	auipc	ra,0x2
    2de2:	5a4080e7          	jalr	1444(ra) # 5382 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2de6:	00004597          	auipc	a1,0x4
    2dea:	de258593          	add	a1,a1,-542 # 6bc8 <statistics+0x1368>
    2dee:	00004517          	auipc	a0,0x4
    2df2:	d5250513          	add	a0,a0,-686 # 6b40 <statistics+0x12e0>
    2df6:	00002097          	auipc	ra,0x2
    2dfa:	5c4080e7          	jalr	1476(ra) # 53ba <link>
    2dfe:	34051b63          	bnez	a0,3154 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e02:	00004517          	auipc	a0,0x4
    2e06:	d3e50513          	add	a0,a0,-706 # 6b40 <statistics+0x12e0>
    2e0a:	00002097          	auipc	ra,0x2
    2e0e:	5a0080e7          	jalr	1440(ra) # 53aa <unlink>
    2e12:	34051f63          	bnez	a0,3170 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e16:	4581                	li	a1,0
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	d2850513          	add	a0,a0,-728 # 6b40 <statistics+0x12e0>
    2e20:	00002097          	auipc	ra,0x2
    2e24:	57a080e7          	jalr	1402(ra) # 539a <open>
    2e28:	36055263          	bgez	a0,318c <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	c7450513          	add	a0,a0,-908 # 6aa0 <statistics+0x1240>
    2e34:	00002097          	auipc	ra,0x2
    2e38:	596080e7          	jalr	1430(ra) # 53ca <chdir>
    2e3c:	36051663          	bnez	a0,31a8 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e40:	00004517          	auipc	a0,0x4
    2e44:	e2050513          	add	a0,a0,-480 # 6c60 <statistics+0x1400>
    2e48:	00002097          	auipc	ra,0x2
    2e4c:	582080e7          	jalr	1410(ra) # 53ca <chdir>
    2e50:	36051a63          	bnez	a0,31c4 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e54:	00004517          	auipc	a0,0x4
    2e58:	e3c50513          	add	a0,a0,-452 # 6c90 <statistics+0x1430>
    2e5c:	00002097          	auipc	ra,0x2
    2e60:	56e080e7          	jalr	1390(ra) # 53ca <chdir>
    2e64:	36051e63          	bnez	a0,31e0 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	e5850513          	add	a0,a0,-424 # 6cc0 <statistics+0x1460>
    2e70:	00002097          	auipc	ra,0x2
    2e74:	55a080e7          	jalr	1370(ra) # 53ca <chdir>
    2e78:	38051263          	bnez	a0,31fc <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e7c:	4581                	li	a1,0
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	d4a50513          	add	a0,a0,-694 # 6bc8 <statistics+0x1368>
    2e86:	00002097          	auipc	ra,0x2
    2e8a:	514080e7          	jalr	1300(ra) # 539a <open>
    2e8e:	84aa                	mv	s1,a0
  if(fd < 0){
    2e90:	38054463          	bltz	a0,3218 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e94:	660d                	lui	a2,0x3
    2e96:	00009597          	auipc	a1,0x9
    2e9a:	97258593          	add	a1,a1,-1678 # b808 <buf>
    2e9e:	00002097          	auipc	ra,0x2
    2ea2:	4d4080e7          	jalr	1236(ra) # 5372 <read>
    2ea6:	4789                	li	a5,2
    2ea8:	38f51663          	bne	a0,a5,3234 <subdir+0x55e>
  close(fd);
    2eac:	8526                	mv	a0,s1
    2eae:	00002097          	auipc	ra,0x2
    2eb2:	4d4080e7          	jalr	1236(ra) # 5382 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2eb6:	4581                	li	a1,0
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	c8850513          	add	a0,a0,-888 # 6b40 <statistics+0x12e0>
    2ec0:	00002097          	auipc	ra,0x2
    2ec4:	4da080e7          	jalr	1242(ra) # 539a <open>
    2ec8:	38055463          	bgez	a0,3250 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ecc:	20200593          	li	a1,514
    2ed0:	00004517          	auipc	a0,0x4
    2ed4:	e8050513          	add	a0,a0,-384 # 6d50 <statistics+0x14f0>
    2ed8:	00002097          	auipc	ra,0x2
    2edc:	4c2080e7          	jalr	1218(ra) # 539a <open>
    2ee0:	38055663          	bgez	a0,326c <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2ee4:	20200593          	li	a1,514
    2ee8:	00004517          	auipc	a0,0x4
    2eec:	e9850513          	add	a0,a0,-360 # 6d80 <statistics+0x1520>
    2ef0:	00002097          	auipc	ra,0x2
    2ef4:	4aa080e7          	jalr	1194(ra) # 539a <open>
    2ef8:	38055863          	bgez	a0,3288 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2efc:	20000593          	li	a1,512
    2f00:	00004517          	auipc	a0,0x4
    2f04:	ba050513          	add	a0,a0,-1120 # 6aa0 <statistics+0x1240>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	492080e7          	jalr	1170(ra) # 539a <open>
    2f10:	38055a63          	bgez	a0,32a4 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f14:	4589                	li	a1,2
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	b8a50513          	add	a0,a0,-1142 # 6aa0 <statistics+0x1240>
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	47c080e7          	jalr	1148(ra) # 539a <open>
    2f26:	38055d63          	bgez	a0,32c0 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f2a:	4585                	li	a1,1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	b7450513          	add	a0,a0,-1164 # 6aa0 <statistics+0x1240>
    2f34:	00002097          	auipc	ra,0x2
    2f38:	466080e7          	jalr	1126(ra) # 539a <open>
    2f3c:	3a055063          	bgez	a0,32dc <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f40:	00004597          	auipc	a1,0x4
    2f44:	ed058593          	add	a1,a1,-304 # 6e10 <statistics+0x15b0>
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	e0850513          	add	a0,a0,-504 # 6d50 <statistics+0x14f0>
    2f50:	00002097          	auipc	ra,0x2
    2f54:	46a080e7          	jalr	1130(ra) # 53ba <link>
    2f58:	3a050063          	beqz	a0,32f8 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f5c:	00004597          	auipc	a1,0x4
    2f60:	eb458593          	add	a1,a1,-332 # 6e10 <statistics+0x15b0>
    2f64:	00004517          	auipc	a0,0x4
    2f68:	e1c50513          	add	a0,a0,-484 # 6d80 <statistics+0x1520>
    2f6c:	00002097          	auipc	ra,0x2
    2f70:	44e080e7          	jalr	1102(ra) # 53ba <link>
    2f74:	3a050063          	beqz	a0,3314 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f78:	00004597          	auipc	a1,0x4
    2f7c:	c5058593          	add	a1,a1,-944 # 6bc8 <statistics+0x1368>
    2f80:	00004517          	auipc	a0,0x4
    2f84:	b4050513          	add	a0,a0,-1216 # 6ac0 <statistics+0x1260>
    2f88:	00002097          	auipc	ra,0x2
    2f8c:	432080e7          	jalr	1074(ra) # 53ba <link>
    2f90:	3a050063          	beqz	a0,3330 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	dbc50513          	add	a0,a0,-580 # 6d50 <statistics+0x14f0>
    2f9c:	00002097          	auipc	ra,0x2
    2fa0:	426080e7          	jalr	1062(ra) # 53c2 <mkdir>
    2fa4:	3a050463          	beqz	a0,334c <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	dd850513          	add	a0,a0,-552 # 6d80 <statistics+0x1520>
    2fb0:	00002097          	auipc	ra,0x2
    2fb4:	412080e7          	jalr	1042(ra) # 53c2 <mkdir>
    2fb8:	3a050863          	beqz	a0,3368 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fbc:	00004517          	auipc	a0,0x4
    2fc0:	c0c50513          	add	a0,a0,-1012 # 6bc8 <statistics+0x1368>
    2fc4:	00002097          	auipc	ra,0x2
    2fc8:	3fe080e7          	jalr	1022(ra) # 53c2 <mkdir>
    2fcc:	3a050c63          	beqz	a0,3384 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2fd0:	00004517          	auipc	a0,0x4
    2fd4:	db050513          	add	a0,a0,-592 # 6d80 <statistics+0x1520>
    2fd8:	00002097          	auipc	ra,0x2
    2fdc:	3d2080e7          	jalr	978(ra) # 53aa <unlink>
    2fe0:	3c050063          	beqz	a0,33a0 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	d6c50513          	add	a0,a0,-660 # 6d50 <statistics+0x14f0>
    2fec:	00002097          	auipc	ra,0x2
    2ff0:	3be080e7          	jalr	958(ra) # 53aa <unlink>
    2ff4:	3c050463          	beqz	a0,33bc <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2ff8:	00004517          	auipc	a0,0x4
    2ffc:	ac850513          	add	a0,a0,-1336 # 6ac0 <statistics+0x1260>
    3000:	00002097          	auipc	ra,0x2
    3004:	3ca080e7          	jalr	970(ra) # 53ca <chdir>
    3008:	3c050863          	beqz	a0,33d8 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    300c:	00004517          	auipc	a0,0x4
    3010:	f5450513          	add	a0,a0,-172 # 6f60 <statistics+0x1700>
    3014:	00002097          	auipc	ra,0x2
    3018:	3b6080e7          	jalr	950(ra) # 53ca <chdir>
    301c:	3c050c63          	beqz	a0,33f4 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3020:	00004517          	auipc	a0,0x4
    3024:	ba850513          	add	a0,a0,-1112 # 6bc8 <statistics+0x1368>
    3028:	00002097          	auipc	ra,0x2
    302c:	382080e7          	jalr	898(ra) # 53aa <unlink>
    3030:	3e051063          	bnez	a0,3410 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3034:	00004517          	auipc	a0,0x4
    3038:	a8c50513          	add	a0,a0,-1396 # 6ac0 <statistics+0x1260>
    303c:	00002097          	auipc	ra,0x2
    3040:	36e080e7          	jalr	878(ra) # 53aa <unlink>
    3044:	3e051463          	bnez	a0,342c <subdir+0x756>
  if(unlink("dd") == 0){
    3048:	00004517          	auipc	a0,0x4
    304c:	a5850513          	add	a0,a0,-1448 # 6aa0 <statistics+0x1240>
    3050:	00002097          	auipc	ra,0x2
    3054:	35a080e7          	jalr	858(ra) # 53aa <unlink>
    3058:	3e050863          	beqz	a0,3448 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    305c:	00004517          	auipc	a0,0x4
    3060:	f7450513          	add	a0,a0,-140 # 6fd0 <statistics+0x1770>
    3064:	00002097          	auipc	ra,0x2
    3068:	346080e7          	jalr	838(ra) # 53aa <unlink>
    306c:	3e054c63          	bltz	a0,3464 <subdir+0x78e>
  if(unlink("dd") < 0){
    3070:	00004517          	auipc	a0,0x4
    3074:	a3050513          	add	a0,a0,-1488 # 6aa0 <statistics+0x1240>
    3078:	00002097          	auipc	ra,0x2
    307c:	332080e7          	jalr	818(ra) # 53aa <unlink>
    3080:	40054063          	bltz	a0,3480 <subdir+0x7aa>
}
    3084:	60e2                	ld	ra,24(sp)
    3086:	6442                	ld	s0,16(sp)
    3088:	64a2                	ld	s1,8(sp)
    308a:	6902                	ld	s2,0(sp)
    308c:	6105                	add	sp,sp,32
    308e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3090:	85ca                	mv	a1,s2
    3092:	00004517          	auipc	a0,0x4
    3096:	a1650513          	add	a0,a0,-1514 # 6aa8 <statistics+0x1248>
    309a:	00002097          	auipc	ra,0x2
    309e:	628080e7          	jalr	1576(ra) # 56c2 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	00002097          	auipc	ra,0x2
    30a8:	2b6080e7          	jalr	694(ra) # 535a <exit>
    printf("%s: create dd/ff failed\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	a1a50513          	add	a0,a0,-1510 # 6ac8 <statistics+0x1268>
    30b6:	00002097          	auipc	ra,0x2
    30ba:	60c080e7          	jalr	1548(ra) # 56c2 <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	00002097          	auipc	ra,0x2
    30c4:	29a080e7          	jalr	666(ra) # 535a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30c8:	85ca                	mv	a1,s2
    30ca:	00004517          	auipc	a0,0x4
    30ce:	a1e50513          	add	a0,a0,-1506 # 6ae8 <statistics+0x1288>
    30d2:	00002097          	auipc	ra,0x2
    30d6:	5f0080e7          	jalr	1520(ra) # 56c2 <printf>
    exit(1);
    30da:	4505                	li	a0,1
    30dc:	00002097          	auipc	ra,0x2
    30e0:	27e080e7          	jalr	638(ra) # 535a <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00004517          	auipc	a0,0x4
    30ea:	a3a50513          	add	a0,a0,-1478 # 6b20 <statistics+0x12c0>
    30ee:	00002097          	auipc	ra,0x2
    30f2:	5d4080e7          	jalr	1492(ra) # 56c2 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	00002097          	auipc	ra,0x2
    30fc:	262080e7          	jalr	610(ra) # 535a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	a4e50513          	add	a0,a0,-1458 # 6b50 <statistics+0x12f0>
    310a:	00002097          	auipc	ra,0x2
    310e:	5b8080e7          	jalr	1464(ra) # 56c2 <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	00002097          	auipc	ra,0x2
    3118:	246080e7          	jalr	582(ra) # 535a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    311c:	85ca                	mv	a1,s2
    311e:	00004517          	auipc	a0,0x4
    3122:	a6a50513          	add	a0,a0,-1430 # 6b88 <statistics+0x1328>
    3126:	00002097          	auipc	ra,0x2
    312a:	59c080e7          	jalr	1436(ra) # 56c2 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00002097          	auipc	ra,0x2
    3134:	22a080e7          	jalr	554(ra) # 535a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	a6e50513          	add	a0,a0,-1426 # 6ba8 <statistics+0x1348>
    3142:	00002097          	auipc	ra,0x2
    3146:	580080e7          	jalr	1408(ra) # 56c2 <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00002097          	auipc	ra,0x2
    3150:	20e080e7          	jalr	526(ra) # 535a <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3154:	85ca                	mv	a1,s2
    3156:	00004517          	auipc	a0,0x4
    315a:	a8250513          	add	a0,a0,-1406 # 6bd8 <statistics+0x1378>
    315e:	00002097          	auipc	ra,0x2
    3162:	564080e7          	jalr	1380(ra) # 56c2 <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00002097          	auipc	ra,0x2
    316c:	1f2080e7          	jalr	498(ra) # 535a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3170:	85ca                	mv	a1,s2
    3172:	00004517          	auipc	a0,0x4
    3176:	a8e50513          	add	a0,a0,-1394 # 6c00 <statistics+0x13a0>
    317a:	00002097          	auipc	ra,0x2
    317e:	548080e7          	jalr	1352(ra) # 56c2 <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00002097          	auipc	ra,0x2
    3188:	1d6080e7          	jalr	470(ra) # 535a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    318c:	85ca                	mv	a1,s2
    318e:	00004517          	auipc	a0,0x4
    3192:	a9250513          	add	a0,a0,-1390 # 6c20 <statistics+0x13c0>
    3196:	00002097          	auipc	ra,0x2
    319a:	52c080e7          	jalr	1324(ra) # 56c2 <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00002097          	auipc	ra,0x2
    31a4:	1ba080e7          	jalr	442(ra) # 535a <exit>
    printf("%s: chdir dd failed\n", s);
    31a8:	85ca                	mv	a1,s2
    31aa:	00004517          	auipc	a0,0x4
    31ae:	a9e50513          	add	a0,a0,-1378 # 6c48 <statistics+0x13e8>
    31b2:	00002097          	auipc	ra,0x2
    31b6:	510080e7          	jalr	1296(ra) # 56c2 <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00002097          	auipc	ra,0x2
    31c0:	19e080e7          	jalr	414(ra) # 535a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31c4:	85ca                	mv	a1,s2
    31c6:	00004517          	auipc	a0,0x4
    31ca:	aaa50513          	add	a0,a0,-1366 # 6c70 <statistics+0x1410>
    31ce:	00002097          	auipc	ra,0x2
    31d2:	4f4080e7          	jalr	1268(ra) # 56c2 <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	00002097          	auipc	ra,0x2
    31dc:	182080e7          	jalr	386(ra) # 535a <exit>
    printf("chdir dd/../../dd failed\n", s);
    31e0:	85ca                	mv	a1,s2
    31e2:	00004517          	auipc	a0,0x4
    31e6:	abe50513          	add	a0,a0,-1346 # 6ca0 <statistics+0x1440>
    31ea:	00002097          	auipc	ra,0x2
    31ee:	4d8080e7          	jalr	1240(ra) # 56c2 <printf>
    exit(1);
    31f2:	4505                	li	a0,1
    31f4:	00002097          	auipc	ra,0x2
    31f8:	166080e7          	jalr	358(ra) # 535a <exit>
    printf("%s: chdir ./.. failed\n", s);
    31fc:	85ca                	mv	a1,s2
    31fe:	00004517          	auipc	a0,0x4
    3202:	aca50513          	add	a0,a0,-1334 # 6cc8 <statistics+0x1468>
    3206:	00002097          	auipc	ra,0x2
    320a:	4bc080e7          	jalr	1212(ra) # 56c2 <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	00002097          	auipc	ra,0x2
    3214:	14a080e7          	jalr	330(ra) # 535a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3218:	85ca                	mv	a1,s2
    321a:	00004517          	auipc	a0,0x4
    321e:	ac650513          	add	a0,a0,-1338 # 6ce0 <statistics+0x1480>
    3222:	00002097          	auipc	ra,0x2
    3226:	4a0080e7          	jalr	1184(ra) # 56c2 <printf>
    exit(1);
    322a:	4505                	li	a0,1
    322c:	00002097          	auipc	ra,0x2
    3230:	12e080e7          	jalr	302(ra) # 535a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3234:	85ca                	mv	a1,s2
    3236:	00004517          	auipc	a0,0x4
    323a:	aca50513          	add	a0,a0,-1334 # 6d00 <statistics+0x14a0>
    323e:	00002097          	auipc	ra,0x2
    3242:	484080e7          	jalr	1156(ra) # 56c2 <printf>
    exit(1);
    3246:	4505                	li	a0,1
    3248:	00002097          	auipc	ra,0x2
    324c:	112080e7          	jalr	274(ra) # 535a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3250:	85ca                	mv	a1,s2
    3252:	00004517          	auipc	a0,0x4
    3256:	ace50513          	add	a0,a0,-1330 # 6d20 <statistics+0x14c0>
    325a:	00002097          	auipc	ra,0x2
    325e:	468080e7          	jalr	1128(ra) # 56c2 <printf>
    exit(1);
    3262:	4505                	li	a0,1
    3264:	00002097          	auipc	ra,0x2
    3268:	0f6080e7          	jalr	246(ra) # 535a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    326c:	85ca                	mv	a1,s2
    326e:	00004517          	auipc	a0,0x4
    3272:	af250513          	add	a0,a0,-1294 # 6d60 <statistics+0x1500>
    3276:	00002097          	auipc	ra,0x2
    327a:	44c080e7          	jalr	1100(ra) # 56c2 <printf>
    exit(1);
    327e:	4505                	li	a0,1
    3280:	00002097          	auipc	ra,0x2
    3284:	0da080e7          	jalr	218(ra) # 535a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3288:	85ca                	mv	a1,s2
    328a:	00004517          	auipc	a0,0x4
    328e:	b0650513          	add	a0,a0,-1274 # 6d90 <statistics+0x1530>
    3292:	00002097          	auipc	ra,0x2
    3296:	430080e7          	jalr	1072(ra) # 56c2 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	00002097          	auipc	ra,0x2
    32a0:	0be080e7          	jalr	190(ra) # 535a <exit>
    printf("%s: create dd succeeded!\n", s);
    32a4:	85ca                	mv	a1,s2
    32a6:	00004517          	auipc	a0,0x4
    32aa:	b0a50513          	add	a0,a0,-1270 # 6db0 <statistics+0x1550>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	414080e7          	jalr	1044(ra) # 56c2 <printf>
    exit(1);
    32b6:	4505                	li	a0,1
    32b8:	00002097          	auipc	ra,0x2
    32bc:	0a2080e7          	jalr	162(ra) # 535a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32c0:	85ca                	mv	a1,s2
    32c2:	00004517          	auipc	a0,0x4
    32c6:	b0e50513          	add	a0,a0,-1266 # 6dd0 <statistics+0x1570>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	3f8080e7          	jalr	1016(ra) # 56c2 <printf>
    exit(1);
    32d2:	4505                	li	a0,1
    32d4:	00002097          	auipc	ra,0x2
    32d8:	086080e7          	jalr	134(ra) # 535a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    32dc:	85ca                	mv	a1,s2
    32de:	00004517          	auipc	a0,0x4
    32e2:	b1250513          	add	a0,a0,-1262 # 6df0 <statistics+0x1590>
    32e6:	00002097          	auipc	ra,0x2
    32ea:	3dc080e7          	jalr	988(ra) # 56c2 <printf>
    exit(1);
    32ee:	4505                	li	a0,1
    32f0:	00002097          	auipc	ra,0x2
    32f4:	06a080e7          	jalr	106(ra) # 535a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    32f8:	85ca                	mv	a1,s2
    32fa:	00004517          	auipc	a0,0x4
    32fe:	b2650513          	add	a0,a0,-1242 # 6e20 <statistics+0x15c0>
    3302:	00002097          	auipc	ra,0x2
    3306:	3c0080e7          	jalr	960(ra) # 56c2 <printf>
    exit(1);
    330a:	4505                	li	a0,1
    330c:	00002097          	auipc	ra,0x2
    3310:	04e080e7          	jalr	78(ra) # 535a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3314:	85ca                	mv	a1,s2
    3316:	00004517          	auipc	a0,0x4
    331a:	b3250513          	add	a0,a0,-1230 # 6e48 <statistics+0x15e8>
    331e:	00002097          	auipc	ra,0x2
    3322:	3a4080e7          	jalr	932(ra) # 56c2 <printf>
    exit(1);
    3326:	4505                	li	a0,1
    3328:	00002097          	auipc	ra,0x2
    332c:	032080e7          	jalr	50(ra) # 535a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3330:	85ca                	mv	a1,s2
    3332:	00004517          	auipc	a0,0x4
    3336:	b3e50513          	add	a0,a0,-1218 # 6e70 <statistics+0x1610>
    333a:	00002097          	auipc	ra,0x2
    333e:	388080e7          	jalr	904(ra) # 56c2 <printf>
    exit(1);
    3342:	4505                	li	a0,1
    3344:	00002097          	auipc	ra,0x2
    3348:	016080e7          	jalr	22(ra) # 535a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    334c:	85ca                	mv	a1,s2
    334e:	00004517          	auipc	a0,0x4
    3352:	b4a50513          	add	a0,a0,-1206 # 6e98 <statistics+0x1638>
    3356:	00002097          	auipc	ra,0x2
    335a:	36c080e7          	jalr	876(ra) # 56c2 <printf>
    exit(1);
    335e:	4505                	li	a0,1
    3360:	00002097          	auipc	ra,0x2
    3364:	ffa080e7          	jalr	-6(ra) # 535a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3368:	85ca                	mv	a1,s2
    336a:	00004517          	auipc	a0,0x4
    336e:	b4e50513          	add	a0,a0,-1202 # 6eb8 <statistics+0x1658>
    3372:	00002097          	auipc	ra,0x2
    3376:	350080e7          	jalr	848(ra) # 56c2 <printf>
    exit(1);
    337a:	4505                	li	a0,1
    337c:	00002097          	auipc	ra,0x2
    3380:	fde080e7          	jalr	-34(ra) # 535a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3384:	85ca                	mv	a1,s2
    3386:	00004517          	auipc	a0,0x4
    338a:	b5250513          	add	a0,a0,-1198 # 6ed8 <statistics+0x1678>
    338e:	00002097          	auipc	ra,0x2
    3392:	334080e7          	jalr	820(ra) # 56c2 <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	00002097          	auipc	ra,0x2
    339c:	fc2080e7          	jalr	-62(ra) # 535a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33a0:	85ca                	mv	a1,s2
    33a2:	00004517          	auipc	a0,0x4
    33a6:	b5e50513          	add	a0,a0,-1186 # 6f00 <statistics+0x16a0>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	318080e7          	jalr	792(ra) # 56c2 <printf>
    exit(1);
    33b2:	4505                	li	a0,1
    33b4:	00002097          	auipc	ra,0x2
    33b8:	fa6080e7          	jalr	-90(ra) # 535a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33bc:	85ca                	mv	a1,s2
    33be:	00004517          	auipc	a0,0x4
    33c2:	b6250513          	add	a0,a0,-1182 # 6f20 <statistics+0x16c0>
    33c6:	00002097          	auipc	ra,0x2
    33ca:	2fc080e7          	jalr	764(ra) # 56c2 <printf>
    exit(1);
    33ce:	4505                	li	a0,1
    33d0:	00002097          	auipc	ra,0x2
    33d4:	f8a080e7          	jalr	-118(ra) # 535a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00004517          	auipc	a0,0x4
    33de:	b6650513          	add	a0,a0,-1178 # 6f40 <statistics+0x16e0>
    33e2:	00002097          	auipc	ra,0x2
    33e6:	2e0080e7          	jalr	736(ra) # 56c2 <printf>
    exit(1);
    33ea:	4505                	li	a0,1
    33ec:	00002097          	auipc	ra,0x2
    33f0:	f6e080e7          	jalr	-146(ra) # 535a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    33f4:	85ca                	mv	a1,s2
    33f6:	00004517          	auipc	a0,0x4
    33fa:	b7250513          	add	a0,a0,-1166 # 6f68 <statistics+0x1708>
    33fe:	00002097          	auipc	ra,0x2
    3402:	2c4080e7          	jalr	708(ra) # 56c2 <printf>
    exit(1);
    3406:	4505                	li	a0,1
    3408:	00002097          	auipc	ra,0x2
    340c:	f52080e7          	jalr	-174(ra) # 535a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00003517          	auipc	a0,0x3
    3416:	7ee50513          	add	a0,a0,2030 # 6c00 <statistics+0x13a0>
    341a:	00002097          	auipc	ra,0x2
    341e:	2a8080e7          	jalr	680(ra) # 56c2 <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	00002097          	auipc	ra,0x2
    3428:	f36080e7          	jalr	-202(ra) # 535a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	b5a50513          	add	a0,a0,-1190 # 6f88 <statistics+0x1728>
    3436:	00002097          	auipc	ra,0x2
    343a:	28c080e7          	jalr	652(ra) # 56c2 <printf>
    exit(1);
    343e:	4505                	li	a0,1
    3440:	00002097          	auipc	ra,0x2
    3444:	f1a080e7          	jalr	-230(ra) # 535a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3448:	85ca                	mv	a1,s2
    344a:	00004517          	auipc	a0,0x4
    344e:	b5e50513          	add	a0,a0,-1186 # 6fa8 <statistics+0x1748>
    3452:	00002097          	auipc	ra,0x2
    3456:	270080e7          	jalr	624(ra) # 56c2 <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	00002097          	auipc	ra,0x2
    3460:	efe080e7          	jalr	-258(ra) # 535a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	b7250513          	add	a0,a0,-1166 # 6fd8 <statistics+0x1778>
    346e:	00002097          	auipc	ra,0x2
    3472:	254080e7          	jalr	596(ra) # 56c2 <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	00002097          	auipc	ra,0x2
    347c:	ee2080e7          	jalr	-286(ra) # 535a <exit>
    printf("%s: unlink dd failed\n", s);
    3480:	85ca                	mv	a1,s2
    3482:	00004517          	auipc	a0,0x4
    3486:	b7650513          	add	a0,a0,-1162 # 6ff8 <statistics+0x1798>
    348a:	00002097          	auipc	ra,0x2
    348e:	238080e7          	jalr	568(ra) # 56c2 <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	ec6080e7          	jalr	-314(ra) # 535a <exit>

000000000000349c <rmdot>:
{
    349c:	1101                	add	sp,sp,-32
    349e:	ec06                	sd	ra,24(sp)
    34a0:	e822                	sd	s0,16(sp)
    34a2:	e426                	sd	s1,8(sp)
    34a4:	1000                	add	s0,sp,32
    34a6:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34a8:	00004517          	auipc	a0,0x4
    34ac:	b6850513          	add	a0,a0,-1176 # 7010 <statistics+0x17b0>
    34b0:	00002097          	auipc	ra,0x2
    34b4:	f12080e7          	jalr	-238(ra) # 53c2 <mkdir>
    34b8:	e549                	bnez	a0,3542 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34ba:	00004517          	auipc	a0,0x4
    34be:	b5650513          	add	a0,a0,-1194 # 7010 <statistics+0x17b0>
    34c2:	00002097          	auipc	ra,0x2
    34c6:	f08080e7          	jalr	-248(ra) # 53ca <chdir>
    34ca:	e951                	bnez	a0,355e <rmdot+0xc2>
  if(unlink(".") == 0){
    34cc:	00003517          	auipc	a0,0x3
    34d0:	b0c50513          	add	a0,a0,-1268 # 5fd8 <statistics+0x778>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	ed6080e7          	jalr	-298(ra) # 53aa <unlink>
    34dc:	cd59                	beqz	a0,357a <rmdot+0xde>
  if(unlink("..") == 0){
    34de:	00004517          	auipc	a0,0x4
    34e2:	b8250513          	add	a0,a0,-1150 # 7060 <statistics+0x1800>
    34e6:	00002097          	auipc	ra,0x2
    34ea:	ec4080e7          	jalr	-316(ra) # 53aa <unlink>
    34ee:	c545                	beqz	a0,3596 <rmdot+0xfa>
  if(chdir("/") != 0){
    34f0:	00003517          	auipc	a0,0x3
    34f4:	57850513          	add	a0,a0,1400 # 6a68 <statistics+0x1208>
    34f8:	00002097          	auipc	ra,0x2
    34fc:	ed2080e7          	jalr	-302(ra) # 53ca <chdir>
    3500:	e94d                	bnez	a0,35b2 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3502:	00004517          	auipc	a0,0x4
    3506:	b7e50513          	add	a0,a0,-1154 # 7080 <statistics+0x1820>
    350a:	00002097          	auipc	ra,0x2
    350e:	ea0080e7          	jalr	-352(ra) # 53aa <unlink>
    3512:	cd55                	beqz	a0,35ce <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3514:	00004517          	auipc	a0,0x4
    3518:	b9450513          	add	a0,a0,-1132 # 70a8 <statistics+0x1848>
    351c:	00002097          	auipc	ra,0x2
    3520:	e8e080e7          	jalr	-370(ra) # 53aa <unlink>
    3524:	c179                	beqz	a0,35ea <rmdot+0x14e>
  if(unlink("dots") != 0){
    3526:	00004517          	auipc	a0,0x4
    352a:	aea50513          	add	a0,a0,-1302 # 7010 <statistics+0x17b0>
    352e:	00002097          	auipc	ra,0x2
    3532:	e7c080e7          	jalr	-388(ra) # 53aa <unlink>
    3536:	e961                	bnez	a0,3606 <rmdot+0x16a>
}
    3538:	60e2                	ld	ra,24(sp)
    353a:	6442                	ld	s0,16(sp)
    353c:	64a2                	ld	s1,8(sp)
    353e:	6105                	add	sp,sp,32
    3540:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3542:	85a6                	mv	a1,s1
    3544:	00004517          	auipc	a0,0x4
    3548:	ad450513          	add	a0,a0,-1324 # 7018 <statistics+0x17b8>
    354c:	00002097          	auipc	ra,0x2
    3550:	176080e7          	jalr	374(ra) # 56c2 <printf>
    exit(1);
    3554:	4505                	li	a0,1
    3556:	00002097          	auipc	ra,0x2
    355a:	e04080e7          	jalr	-508(ra) # 535a <exit>
    printf("%s: chdir dots failed\n", s);
    355e:	85a6                	mv	a1,s1
    3560:	00004517          	auipc	a0,0x4
    3564:	ad050513          	add	a0,a0,-1328 # 7030 <statistics+0x17d0>
    3568:	00002097          	auipc	ra,0x2
    356c:	15a080e7          	jalr	346(ra) # 56c2 <printf>
    exit(1);
    3570:	4505                	li	a0,1
    3572:	00002097          	auipc	ra,0x2
    3576:	de8080e7          	jalr	-536(ra) # 535a <exit>
    printf("%s: rm . worked!\n", s);
    357a:	85a6                	mv	a1,s1
    357c:	00004517          	auipc	a0,0x4
    3580:	acc50513          	add	a0,a0,-1332 # 7048 <statistics+0x17e8>
    3584:	00002097          	auipc	ra,0x2
    3588:	13e080e7          	jalr	318(ra) # 56c2 <printf>
    exit(1);
    358c:	4505                	li	a0,1
    358e:	00002097          	auipc	ra,0x2
    3592:	dcc080e7          	jalr	-564(ra) # 535a <exit>
    printf("%s: rm .. worked!\n", s);
    3596:	85a6                	mv	a1,s1
    3598:	00004517          	auipc	a0,0x4
    359c:	ad050513          	add	a0,a0,-1328 # 7068 <statistics+0x1808>
    35a0:	00002097          	auipc	ra,0x2
    35a4:	122080e7          	jalr	290(ra) # 56c2 <printf>
    exit(1);
    35a8:	4505                	li	a0,1
    35aa:	00002097          	auipc	ra,0x2
    35ae:	db0080e7          	jalr	-592(ra) # 535a <exit>
    printf("%s: chdir / failed\n", s);
    35b2:	85a6                	mv	a1,s1
    35b4:	00003517          	auipc	a0,0x3
    35b8:	4bc50513          	add	a0,a0,1212 # 6a70 <statistics+0x1210>
    35bc:	00002097          	auipc	ra,0x2
    35c0:	106080e7          	jalr	262(ra) # 56c2 <printf>
    exit(1);
    35c4:	4505                	li	a0,1
    35c6:	00002097          	auipc	ra,0x2
    35ca:	d94080e7          	jalr	-620(ra) # 535a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    35ce:	85a6                	mv	a1,s1
    35d0:	00004517          	auipc	a0,0x4
    35d4:	ab850513          	add	a0,a0,-1352 # 7088 <statistics+0x1828>
    35d8:	00002097          	auipc	ra,0x2
    35dc:	0ea080e7          	jalr	234(ra) # 56c2 <printf>
    exit(1);
    35e0:	4505                	li	a0,1
    35e2:	00002097          	auipc	ra,0x2
    35e6:	d78080e7          	jalr	-648(ra) # 535a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    35ea:	85a6                	mv	a1,s1
    35ec:	00004517          	auipc	a0,0x4
    35f0:	ac450513          	add	a0,a0,-1340 # 70b0 <statistics+0x1850>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	0ce080e7          	jalr	206(ra) # 56c2 <printf>
    exit(1);
    35fc:	4505                	li	a0,1
    35fe:	00002097          	auipc	ra,0x2
    3602:	d5c080e7          	jalr	-676(ra) # 535a <exit>
    printf("%s: unlink dots failed!\n", s);
    3606:	85a6                	mv	a1,s1
    3608:	00004517          	auipc	a0,0x4
    360c:	ac850513          	add	a0,a0,-1336 # 70d0 <statistics+0x1870>
    3610:	00002097          	auipc	ra,0x2
    3614:	0b2080e7          	jalr	178(ra) # 56c2 <printf>
    exit(1);
    3618:	4505                	li	a0,1
    361a:	00002097          	auipc	ra,0x2
    361e:	d40080e7          	jalr	-704(ra) # 535a <exit>

0000000000003622 <dirfile>:
{
    3622:	1101                	add	sp,sp,-32
    3624:	ec06                	sd	ra,24(sp)
    3626:	e822                	sd	s0,16(sp)
    3628:	e426                	sd	s1,8(sp)
    362a:	e04a                	sd	s2,0(sp)
    362c:	1000                	add	s0,sp,32
    362e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3630:	20000593          	li	a1,512
    3634:	00004517          	auipc	a0,0x4
    3638:	abc50513          	add	a0,a0,-1348 # 70f0 <statistics+0x1890>
    363c:	00002097          	auipc	ra,0x2
    3640:	d5e080e7          	jalr	-674(ra) # 539a <open>
  if(fd < 0){
    3644:	0e054d63          	bltz	a0,373e <dirfile+0x11c>
  close(fd);
    3648:	00002097          	auipc	ra,0x2
    364c:	d3a080e7          	jalr	-710(ra) # 5382 <close>
  if(chdir("dirfile") == 0){
    3650:	00004517          	auipc	a0,0x4
    3654:	aa050513          	add	a0,a0,-1376 # 70f0 <statistics+0x1890>
    3658:	00002097          	auipc	ra,0x2
    365c:	d72080e7          	jalr	-654(ra) # 53ca <chdir>
    3660:	cd6d                	beqz	a0,375a <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3662:	4581                	li	a1,0
    3664:	00004517          	auipc	a0,0x4
    3668:	ad450513          	add	a0,a0,-1324 # 7138 <statistics+0x18d8>
    366c:	00002097          	auipc	ra,0x2
    3670:	d2e080e7          	jalr	-722(ra) # 539a <open>
  if(fd >= 0){
    3674:	10055163          	bgez	a0,3776 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3678:	20000593          	li	a1,512
    367c:	00004517          	auipc	a0,0x4
    3680:	abc50513          	add	a0,a0,-1348 # 7138 <statistics+0x18d8>
    3684:	00002097          	auipc	ra,0x2
    3688:	d16080e7          	jalr	-746(ra) # 539a <open>
  if(fd >= 0){
    368c:	10055363          	bgez	a0,3792 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3690:	00004517          	auipc	a0,0x4
    3694:	aa850513          	add	a0,a0,-1368 # 7138 <statistics+0x18d8>
    3698:	00002097          	auipc	ra,0x2
    369c:	d2a080e7          	jalr	-726(ra) # 53c2 <mkdir>
    36a0:	10050763          	beqz	a0,37ae <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36a4:	00004517          	auipc	a0,0x4
    36a8:	a9450513          	add	a0,a0,-1388 # 7138 <statistics+0x18d8>
    36ac:	00002097          	auipc	ra,0x2
    36b0:	cfe080e7          	jalr	-770(ra) # 53aa <unlink>
    36b4:	10050b63          	beqz	a0,37ca <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36b8:	00004597          	auipc	a1,0x4
    36bc:	a8058593          	add	a1,a1,-1408 # 7138 <statistics+0x18d8>
    36c0:	00002517          	auipc	a0,0x2
    36c4:	40850513          	add	a0,a0,1032 # 5ac8 <statistics+0x268>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	cf2080e7          	jalr	-782(ra) # 53ba <link>
    36d0:	10050b63          	beqz	a0,37e6 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    36d4:	00004517          	auipc	a0,0x4
    36d8:	a1c50513          	add	a0,a0,-1508 # 70f0 <statistics+0x1890>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	cce080e7          	jalr	-818(ra) # 53aa <unlink>
    36e4:	10051f63          	bnez	a0,3802 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    36e8:	4589                	li	a1,2
    36ea:	00003517          	auipc	a0,0x3
    36ee:	8ee50513          	add	a0,a0,-1810 # 5fd8 <statistics+0x778>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	ca8080e7          	jalr	-856(ra) # 539a <open>
  if(fd >= 0){
    36fa:	12055263          	bgez	a0,381e <dirfile+0x1fc>
  fd = open(".", 0);
    36fe:	4581                	li	a1,0
    3700:	00003517          	auipc	a0,0x3
    3704:	8d850513          	add	a0,a0,-1832 # 5fd8 <statistics+0x778>
    3708:	00002097          	auipc	ra,0x2
    370c:	c92080e7          	jalr	-878(ra) # 539a <open>
    3710:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3712:	4605                	li	a2,1
    3714:	00002597          	auipc	a1,0x2
    3718:	27c58593          	add	a1,a1,636 # 5990 <statistics+0x130>
    371c:	00002097          	auipc	ra,0x2
    3720:	c5e080e7          	jalr	-930(ra) # 537a <write>
    3724:	10a04b63          	bgtz	a0,383a <dirfile+0x218>
  close(fd);
    3728:	8526                	mv	a0,s1
    372a:	00002097          	auipc	ra,0x2
    372e:	c58080e7          	jalr	-936(ra) # 5382 <close>
}
    3732:	60e2                	ld	ra,24(sp)
    3734:	6442                	ld	s0,16(sp)
    3736:	64a2                	ld	s1,8(sp)
    3738:	6902                	ld	s2,0(sp)
    373a:	6105                	add	sp,sp,32
    373c:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	9b850513          	add	a0,a0,-1608 # 70f8 <statistics+0x1898>
    3748:	00002097          	auipc	ra,0x2
    374c:	f7a080e7          	jalr	-134(ra) # 56c2 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	c08080e7          	jalr	-1016(ra) # 535a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	9bc50513          	add	a0,a0,-1604 # 7118 <statistics+0x18b8>
    3764:	00002097          	auipc	ra,0x2
    3768:	f5e080e7          	jalr	-162(ra) # 56c2 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	bec080e7          	jalr	-1044(ra) # 535a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	9d050513          	add	a0,a0,-1584 # 7148 <statistics+0x18e8>
    3780:	00002097          	auipc	ra,0x2
    3784:	f42080e7          	jalr	-190(ra) # 56c2 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	bd0080e7          	jalr	-1072(ra) # 535a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	9b450513          	add	a0,a0,-1612 # 7148 <statistics+0x18e8>
    379c:	00002097          	auipc	ra,0x2
    37a0:	f26080e7          	jalr	-218(ra) # 56c2 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	bb4080e7          	jalr	-1100(ra) # 535a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	9c050513          	add	a0,a0,-1600 # 7170 <statistics+0x1910>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	f0a080e7          	jalr	-246(ra) # 56c2 <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	b98080e7          	jalr	-1128(ra) # 535a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	9cc50513          	add	a0,a0,-1588 # 7198 <statistics+0x1938>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	eee080e7          	jalr	-274(ra) # 56c2 <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	b7c080e7          	jalr	-1156(ra) # 535a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	9d850513          	add	a0,a0,-1576 # 71c0 <statistics+0x1960>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	ed2080e7          	jalr	-302(ra) # 56c2 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	b60080e7          	jalr	-1184(ra) # 535a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	9e450513          	add	a0,a0,-1564 # 71e8 <statistics+0x1988>
    380c:	00002097          	auipc	ra,0x2
    3810:	eb6080e7          	jalr	-330(ra) # 56c2 <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	b44080e7          	jalr	-1212(ra) # 535a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    381e:	85ca                	mv	a1,s2
    3820:	00004517          	auipc	a0,0x4
    3824:	9e850513          	add	a0,a0,-1560 # 7208 <statistics+0x19a8>
    3828:	00002097          	auipc	ra,0x2
    382c:	e9a080e7          	jalr	-358(ra) # 56c2 <printf>
    exit(1);
    3830:	4505                	li	a0,1
    3832:	00002097          	auipc	ra,0x2
    3836:	b28080e7          	jalr	-1240(ra) # 535a <exit>
    printf("%s: write . succeeded!\n", s);
    383a:	85ca                	mv	a1,s2
    383c:	00004517          	auipc	a0,0x4
    3840:	9f450513          	add	a0,a0,-1548 # 7230 <statistics+0x19d0>
    3844:	00002097          	auipc	ra,0x2
    3848:	e7e080e7          	jalr	-386(ra) # 56c2 <printf>
    exit(1);
    384c:	4505                	li	a0,1
    384e:	00002097          	auipc	ra,0x2
    3852:	b0c080e7          	jalr	-1268(ra) # 535a <exit>

0000000000003856 <iref>:
{
    3856:	7139                	add	sp,sp,-64
    3858:	fc06                	sd	ra,56(sp)
    385a:	f822                	sd	s0,48(sp)
    385c:	f426                	sd	s1,40(sp)
    385e:	f04a                	sd	s2,32(sp)
    3860:	ec4e                	sd	s3,24(sp)
    3862:	e852                	sd	s4,16(sp)
    3864:	e456                	sd	s5,8(sp)
    3866:	e05a                	sd	s6,0(sp)
    3868:	0080                	add	s0,sp,64
    386a:	8b2a                	mv	s6,a0
    386c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3870:	00004a17          	auipc	s4,0x4
    3874:	9d8a0a13          	add	s4,s4,-1576 # 7248 <statistics+0x19e8>
    mkdir("");
    3878:	00003497          	auipc	s1,0x3
    387c:	4d048493          	add	s1,s1,1232 # 6d48 <statistics+0x14e8>
    link("README", "");
    3880:	00002a97          	auipc	s5,0x2
    3884:	248a8a93          	add	s5,s5,584 # 5ac8 <statistics+0x268>
    fd = open("xx", O_CREATE);
    3888:	00004997          	auipc	s3,0x4
    388c:	8b898993          	add	s3,s3,-1864 # 7140 <statistics+0x18e0>
    3890:	a891                	j	38e4 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3892:	85da                	mv	a1,s6
    3894:	00004517          	auipc	a0,0x4
    3898:	9bc50513          	add	a0,a0,-1604 # 7250 <statistics+0x19f0>
    389c:	00002097          	auipc	ra,0x2
    38a0:	e26080e7          	jalr	-474(ra) # 56c2 <printf>
      exit(1);
    38a4:	4505                	li	a0,1
    38a6:	00002097          	auipc	ra,0x2
    38aa:	ab4080e7          	jalr	-1356(ra) # 535a <exit>
      printf("%s: chdir irefd failed\n", s);
    38ae:	85da                	mv	a1,s6
    38b0:	00004517          	auipc	a0,0x4
    38b4:	9b850513          	add	a0,a0,-1608 # 7268 <statistics+0x1a08>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	e0a080e7          	jalr	-502(ra) # 56c2 <printf>
      exit(1);
    38c0:	4505                	li	a0,1
    38c2:	00002097          	auipc	ra,0x2
    38c6:	a98080e7          	jalr	-1384(ra) # 535a <exit>
      close(fd);
    38ca:	00002097          	auipc	ra,0x2
    38ce:	ab8080e7          	jalr	-1352(ra) # 5382 <close>
    38d2:	a889                	j	3924 <iref+0xce>
    unlink("xx");
    38d4:	854e                	mv	a0,s3
    38d6:	00002097          	auipc	ra,0x2
    38da:	ad4080e7          	jalr	-1324(ra) # 53aa <unlink>
  for(i = 0; i < NINODE + 1; i++){
    38de:	397d                	addw	s2,s2,-1
    38e0:	06090063          	beqz	s2,3940 <iref+0xea>
    if(mkdir("irefd") != 0){
    38e4:	8552                	mv	a0,s4
    38e6:	00002097          	auipc	ra,0x2
    38ea:	adc080e7          	jalr	-1316(ra) # 53c2 <mkdir>
    38ee:	f155                	bnez	a0,3892 <iref+0x3c>
    if(chdir("irefd") != 0){
    38f0:	8552                	mv	a0,s4
    38f2:	00002097          	auipc	ra,0x2
    38f6:	ad8080e7          	jalr	-1320(ra) # 53ca <chdir>
    38fa:	f955                	bnez	a0,38ae <iref+0x58>
    mkdir("");
    38fc:	8526                	mv	a0,s1
    38fe:	00002097          	auipc	ra,0x2
    3902:	ac4080e7          	jalr	-1340(ra) # 53c2 <mkdir>
    link("README", "");
    3906:	85a6                	mv	a1,s1
    3908:	8556                	mv	a0,s5
    390a:	00002097          	auipc	ra,0x2
    390e:	ab0080e7          	jalr	-1360(ra) # 53ba <link>
    fd = open("", O_CREATE);
    3912:	20000593          	li	a1,512
    3916:	8526                	mv	a0,s1
    3918:	00002097          	auipc	ra,0x2
    391c:	a82080e7          	jalr	-1406(ra) # 539a <open>
    if(fd >= 0)
    3920:	fa0555e3          	bgez	a0,38ca <iref+0x74>
    fd = open("xx", O_CREATE);
    3924:	20000593          	li	a1,512
    3928:	854e                	mv	a0,s3
    392a:	00002097          	auipc	ra,0x2
    392e:	a70080e7          	jalr	-1424(ra) # 539a <open>
    if(fd >= 0)
    3932:	fa0541e3          	bltz	a0,38d4 <iref+0x7e>
      close(fd);
    3936:	00002097          	auipc	ra,0x2
    393a:	a4c080e7          	jalr	-1460(ra) # 5382 <close>
    393e:	bf59                	j	38d4 <iref+0x7e>
    3940:	03300493          	li	s1,51
    chdir("..");
    3944:	00003997          	auipc	s3,0x3
    3948:	71c98993          	add	s3,s3,1820 # 7060 <statistics+0x1800>
    unlink("irefd");
    394c:	00004917          	auipc	s2,0x4
    3950:	8fc90913          	add	s2,s2,-1796 # 7248 <statistics+0x19e8>
    chdir("..");
    3954:	854e                	mv	a0,s3
    3956:	00002097          	auipc	ra,0x2
    395a:	a74080e7          	jalr	-1420(ra) # 53ca <chdir>
    unlink("irefd");
    395e:	854a                	mv	a0,s2
    3960:	00002097          	auipc	ra,0x2
    3964:	a4a080e7          	jalr	-1462(ra) # 53aa <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3968:	34fd                	addw	s1,s1,-1
    396a:	f4ed                	bnez	s1,3954 <iref+0xfe>
  chdir("/");
    396c:	00003517          	auipc	a0,0x3
    3970:	0fc50513          	add	a0,a0,252 # 6a68 <statistics+0x1208>
    3974:	00002097          	auipc	ra,0x2
    3978:	a56080e7          	jalr	-1450(ra) # 53ca <chdir>
}
    397c:	70e2                	ld	ra,56(sp)
    397e:	7442                	ld	s0,48(sp)
    3980:	74a2                	ld	s1,40(sp)
    3982:	7902                	ld	s2,32(sp)
    3984:	69e2                	ld	s3,24(sp)
    3986:	6a42                	ld	s4,16(sp)
    3988:	6aa2                	ld	s5,8(sp)
    398a:	6b02                	ld	s6,0(sp)
    398c:	6121                	add	sp,sp,64
    398e:	8082                	ret

0000000000003990 <openiputtest>:
{
    3990:	7179                	add	sp,sp,-48
    3992:	f406                	sd	ra,40(sp)
    3994:	f022                	sd	s0,32(sp)
    3996:	ec26                	sd	s1,24(sp)
    3998:	1800                	add	s0,sp,48
    399a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    399c:	00004517          	auipc	a0,0x4
    39a0:	8e450513          	add	a0,a0,-1820 # 7280 <statistics+0x1a20>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	a1e080e7          	jalr	-1506(ra) # 53c2 <mkdir>
    39ac:	04054263          	bltz	a0,39f0 <openiputtest+0x60>
  pid = fork();
    39b0:	00002097          	auipc	ra,0x2
    39b4:	9a2080e7          	jalr	-1630(ra) # 5352 <fork>
  if(pid < 0){
    39b8:	04054a63          	bltz	a0,3a0c <openiputtest+0x7c>
  if(pid == 0){
    39bc:	e93d                	bnez	a0,3a32 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39be:	4589                	li	a1,2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	8c050513          	add	a0,a0,-1856 # 7280 <statistics+0x1a20>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	9d2080e7          	jalr	-1582(ra) # 539a <open>
    if(fd >= 0){
    39d0:	04054c63          	bltz	a0,3a28 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    39d4:	85a6                	mv	a1,s1
    39d6:	00004517          	auipc	a0,0x4
    39da:	8ca50513          	add	a0,a0,-1846 # 72a0 <statistics+0x1a40>
    39de:	00002097          	auipc	ra,0x2
    39e2:	ce4080e7          	jalr	-796(ra) # 56c2 <printf>
      exit(1);
    39e6:	4505                	li	a0,1
    39e8:	00002097          	auipc	ra,0x2
    39ec:	972080e7          	jalr	-1678(ra) # 535a <exit>
    printf("%s: mkdir oidir failed\n", s);
    39f0:	85a6                	mv	a1,s1
    39f2:	00004517          	auipc	a0,0x4
    39f6:	89650513          	add	a0,a0,-1898 # 7288 <statistics+0x1a28>
    39fa:	00002097          	auipc	ra,0x2
    39fe:	cc8080e7          	jalr	-824(ra) # 56c2 <printf>
    exit(1);
    3a02:	4505                	li	a0,1
    3a04:	00002097          	auipc	ra,0x2
    3a08:	956080e7          	jalr	-1706(ra) # 535a <exit>
    printf("%s: fork failed\n", s);
    3a0c:	85a6                	mv	a1,s1
    3a0e:	00002517          	auipc	a0,0x2
    3a12:	76a50513          	add	a0,a0,1898 # 6178 <statistics+0x918>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	cac080e7          	jalr	-852(ra) # 56c2 <printf>
    exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	00002097          	auipc	ra,0x2
    3a24:	93a080e7          	jalr	-1734(ra) # 535a <exit>
    exit(0);
    3a28:	4501                	li	a0,0
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	930080e7          	jalr	-1744(ra) # 535a <exit>
  sleep(1);
    3a32:	4505                	li	a0,1
    3a34:	00002097          	auipc	ra,0x2
    3a38:	9b6080e7          	jalr	-1610(ra) # 53ea <sleep>
  if(unlink("oidir") != 0){
    3a3c:	00004517          	auipc	a0,0x4
    3a40:	84450513          	add	a0,a0,-1980 # 7280 <statistics+0x1a20>
    3a44:	00002097          	auipc	ra,0x2
    3a48:	966080e7          	jalr	-1690(ra) # 53aa <unlink>
    3a4c:	cd19                	beqz	a0,3a6a <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a4e:	85a6                	mv	a1,s1
    3a50:	00003517          	auipc	a0,0x3
    3a54:	91850513          	add	a0,a0,-1768 # 6368 <statistics+0xb08>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	c6a080e7          	jalr	-918(ra) # 56c2 <printf>
    exit(1);
    3a60:	4505                	li	a0,1
    3a62:	00002097          	auipc	ra,0x2
    3a66:	8f8080e7          	jalr	-1800(ra) # 535a <exit>
  wait(&xstatus);
    3a6a:	fdc40513          	add	a0,s0,-36
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	8f4080e7          	jalr	-1804(ra) # 5362 <wait>
  exit(xstatus);
    3a76:	fdc42503          	lw	a0,-36(s0)
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	8e0080e7          	jalr	-1824(ra) # 535a <exit>

0000000000003a82 <forkforkfork>:
{
    3a82:	1101                	add	sp,sp,-32
    3a84:	ec06                	sd	ra,24(sp)
    3a86:	e822                	sd	s0,16(sp)
    3a88:	e426                	sd	s1,8(sp)
    3a8a:	1000                	add	s0,sp,32
    3a8c:	84aa                	mv	s1,a0
  unlink("stopforking");
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	83a50513          	add	a0,a0,-1990 # 72c8 <statistics+0x1a68>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	914080e7          	jalr	-1772(ra) # 53aa <unlink>
  int pid = fork();
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	8b4080e7          	jalr	-1868(ra) # 5352 <fork>
  if(pid < 0){
    3aa6:	04054563          	bltz	a0,3af0 <forkforkfork+0x6e>
  if(pid == 0){
    3aaa:	c12d                	beqz	a0,3b0c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3aac:	4551                	li	a0,20
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	93c080e7          	jalr	-1732(ra) # 53ea <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3ab6:	20200593          	li	a1,514
    3aba:	00004517          	auipc	a0,0x4
    3abe:	80e50513          	add	a0,a0,-2034 # 72c8 <statistics+0x1a68>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	8d8080e7          	jalr	-1832(ra) # 539a <open>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	8b8080e7          	jalr	-1864(ra) # 5382 <close>
  wait(0);
    3ad2:	4501                	li	a0,0
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	88e080e7          	jalr	-1906(ra) # 5362 <wait>
  sleep(10); // one second
    3adc:	4529                	li	a0,10
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	90c080e7          	jalr	-1780(ra) # 53ea <sleep>
}
    3ae6:	60e2                	ld	ra,24(sp)
    3ae8:	6442                	ld	s0,16(sp)
    3aea:	64a2                	ld	s1,8(sp)
    3aec:	6105                	add	sp,sp,32
    3aee:	8082                	ret
    printf("%s: fork failed", s);
    3af0:	85a6                	mv	a1,s1
    3af2:	00003517          	auipc	a0,0x3
    3af6:	84650513          	add	a0,a0,-1978 # 6338 <statistics+0xad8>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	bc8080e7          	jalr	-1080(ra) # 56c2 <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	856080e7          	jalr	-1962(ra) # 535a <exit>
      int fd = open("stopforking", 0);
    3b0c:	00003497          	auipc	s1,0x3
    3b10:	7bc48493          	add	s1,s1,1980 # 72c8 <statistics+0x1a68>
    3b14:	4581                	li	a1,0
    3b16:	8526                	mv	a0,s1
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	882080e7          	jalr	-1918(ra) # 539a <open>
      if(fd >= 0){
    3b20:	02055763          	bgez	a0,3b4e <forkforkfork+0xcc>
      if(fork() < 0){
    3b24:	00002097          	auipc	ra,0x2
    3b28:	82e080e7          	jalr	-2002(ra) # 5352 <fork>
    3b2c:	fe0554e3          	bgez	a0,3b14 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b30:	20200593          	li	a1,514
    3b34:	00003517          	auipc	a0,0x3
    3b38:	79450513          	add	a0,a0,1940 # 72c8 <statistics+0x1a68>
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	85e080e7          	jalr	-1954(ra) # 539a <open>
    3b44:	00002097          	auipc	ra,0x2
    3b48:	83e080e7          	jalr	-1986(ra) # 5382 <close>
    3b4c:	b7e1                	j	3b14 <forkforkfork+0x92>
        exit(0);
    3b4e:	4501                	li	a0,0
    3b50:	00002097          	auipc	ra,0x2
    3b54:	80a080e7          	jalr	-2038(ra) # 535a <exit>

0000000000003b58 <preempt>:
{
    3b58:	7139                	add	sp,sp,-64
    3b5a:	fc06                	sd	ra,56(sp)
    3b5c:	f822                	sd	s0,48(sp)
    3b5e:	f426                	sd	s1,40(sp)
    3b60:	f04a                	sd	s2,32(sp)
    3b62:	ec4e                	sd	s3,24(sp)
    3b64:	e852                	sd	s4,16(sp)
    3b66:	0080                	add	s0,sp,64
    3b68:	892a                	mv	s2,a0
  pid1 = fork();
    3b6a:	00001097          	auipc	ra,0x1
    3b6e:	7e8080e7          	jalr	2024(ra) # 5352 <fork>
  if(pid1 < 0) {
    3b72:	00054563          	bltz	a0,3b7c <preempt+0x24>
    3b76:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3b78:	ed19                	bnez	a0,3b96 <preempt+0x3e>
    for(;;)
    3b7a:	a001                	j	3b7a <preempt+0x22>
    printf("%s: fork failed");
    3b7c:	00002517          	auipc	a0,0x2
    3b80:	7bc50513          	add	a0,a0,1980 # 6338 <statistics+0xad8>
    3b84:	00002097          	auipc	ra,0x2
    3b88:	b3e080e7          	jalr	-1218(ra) # 56c2 <printf>
    exit(1);
    3b8c:	4505                	li	a0,1
    3b8e:	00001097          	auipc	ra,0x1
    3b92:	7cc080e7          	jalr	1996(ra) # 535a <exit>
  pid2 = fork();
    3b96:	00001097          	auipc	ra,0x1
    3b9a:	7bc080e7          	jalr	1980(ra) # 5352 <fork>
    3b9e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3ba0:	00054463          	bltz	a0,3ba8 <preempt+0x50>
  if(pid2 == 0)
    3ba4:	e105                	bnez	a0,3bc4 <preempt+0x6c>
    for(;;)
    3ba6:	a001                	j	3ba6 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3ba8:	85ca                	mv	a1,s2
    3baa:	00002517          	auipc	a0,0x2
    3bae:	5ce50513          	add	a0,a0,1486 # 6178 <statistics+0x918>
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	b10080e7          	jalr	-1264(ra) # 56c2 <printf>
    exit(1);
    3bba:	4505                	li	a0,1
    3bbc:	00001097          	auipc	ra,0x1
    3bc0:	79e080e7          	jalr	1950(ra) # 535a <exit>
  pipe(pfds);
    3bc4:	fc840513          	add	a0,s0,-56
    3bc8:	00001097          	auipc	ra,0x1
    3bcc:	7a2080e7          	jalr	1954(ra) # 536a <pipe>
  pid3 = fork();
    3bd0:	00001097          	auipc	ra,0x1
    3bd4:	782080e7          	jalr	1922(ra) # 5352 <fork>
    3bd8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3bda:	02054e63          	bltz	a0,3c16 <preempt+0xbe>
  if(pid3 == 0){
    3bde:	e13d                	bnez	a0,3c44 <preempt+0xec>
    close(pfds[0]);
    3be0:	fc842503          	lw	a0,-56(s0)
    3be4:	00001097          	auipc	ra,0x1
    3be8:	79e080e7          	jalr	1950(ra) # 5382 <close>
    if(write(pfds[1], "x", 1) != 1)
    3bec:	4605                	li	a2,1
    3bee:	00002597          	auipc	a1,0x2
    3bf2:	da258593          	add	a1,a1,-606 # 5990 <statistics+0x130>
    3bf6:	fcc42503          	lw	a0,-52(s0)
    3bfa:	00001097          	auipc	ra,0x1
    3bfe:	780080e7          	jalr	1920(ra) # 537a <write>
    3c02:	4785                	li	a5,1
    3c04:	02f51763          	bne	a0,a5,3c32 <preempt+0xda>
    close(pfds[1]);
    3c08:	fcc42503          	lw	a0,-52(s0)
    3c0c:	00001097          	auipc	ra,0x1
    3c10:	776080e7          	jalr	1910(ra) # 5382 <close>
    for(;;)
    3c14:	a001                	j	3c14 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c16:	85ca                	mv	a1,s2
    3c18:	00002517          	auipc	a0,0x2
    3c1c:	56050513          	add	a0,a0,1376 # 6178 <statistics+0x918>
    3c20:	00002097          	auipc	ra,0x2
    3c24:	aa2080e7          	jalr	-1374(ra) # 56c2 <printf>
     exit(1);
    3c28:	4505                	li	a0,1
    3c2a:	00001097          	auipc	ra,0x1
    3c2e:	730080e7          	jalr	1840(ra) # 535a <exit>
      printf("%s: preempt write error");
    3c32:	00003517          	auipc	a0,0x3
    3c36:	6a650513          	add	a0,a0,1702 # 72d8 <statistics+0x1a78>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	a88080e7          	jalr	-1400(ra) # 56c2 <printf>
    3c42:	b7d9                	j	3c08 <preempt+0xb0>
  close(pfds[1]);
    3c44:	fcc42503          	lw	a0,-52(s0)
    3c48:	00001097          	auipc	ra,0x1
    3c4c:	73a080e7          	jalr	1850(ra) # 5382 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c50:	660d                	lui	a2,0x3
    3c52:	00008597          	auipc	a1,0x8
    3c56:	bb658593          	add	a1,a1,-1098 # b808 <buf>
    3c5a:	fc842503          	lw	a0,-56(s0)
    3c5e:	00001097          	auipc	ra,0x1
    3c62:	714080e7          	jalr	1812(ra) # 5372 <read>
    3c66:	4785                	li	a5,1
    3c68:	02f50263          	beq	a0,a5,3c8c <preempt+0x134>
    printf("%s: preempt read error");
    3c6c:	00003517          	auipc	a0,0x3
    3c70:	68450513          	add	a0,a0,1668 # 72f0 <statistics+0x1a90>
    3c74:	00002097          	auipc	ra,0x2
    3c78:	a4e080e7          	jalr	-1458(ra) # 56c2 <printf>
}
    3c7c:	70e2                	ld	ra,56(sp)
    3c7e:	7442                	ld	s0,48(sp)
    3c80:	74a2                	ld	s1,40(sp)
    3c82:	7902                	ld	s2,32(sp)
    3c84:	69e2                	ld	s3,24(sp)
    3c86:	6a42                	ld	s4,16(sp)
    3c88:	6121                	add	sp,sp,64
    3c8a:	8082                	ret
  close(pfds[0]);
    3c8c:	fc842503          	lw	a0,-56(s0)
    3c90:	00001097          	auipc	ra,0x1
    3c94:	6f2080e7          	jalr	1778(ra) # 5382 <close>
  printf("kill... ");
    3c98:	00003517          	auipc	a0,0x3
    3c9c:	67050513          	add	a0,a0,1648 # 7308 <statistics+0x1aa8>
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	a22080e7          	jalr	-1502(ra) # 56c2 <printf>
  kill(pid1);
    3ca8:	8526                	mv	a0,s1
    3caa:	00001097          	auipc	ra,0x1
    3cae:	6e0080e7          	jalr	1760(ra) # 538a <kill>
  kill(pid2);
    3cb2:	854e                	mv	a0,s3
    3cb4:	00001097          	auipc	ra,0x1
    3cb8:	6d6080e7          	jalr	1750(ra) # 538a <kill>
  kill(pid3);
    3cbc:	8552                	mv	a0,s4
    3cbe:	00001097          	auipc	ra,0x1
    3cc2:	6cc080e7          	jalr	1740(ra) # 538a <kill>
  printf("wait... ");
    3cc6:	00003517          	auipc	a0,0x3
    3cca:	65250513          	add	a0,a0,1618 # 7318 <statistics+0x1ab8>
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	9f4080e7          	jalr	-1548(ra) # 56c2 <printf>
  wait(0);
    3cd6:	4501                	li	a0,0
    3cd8:	00001097          	auipc	ra,0x1
    3cdc:	68a080e7          	jalr	1674(ra) # 5362 <wait>
  wait(0);
    3ce0:	4501                	li	a0,0
    3ce2:	00001097          	auipc	ra,0x1
    3ce6:	680080e7          	jalr	1664(ra) # 5362 <wait>
  wait(0);
    3cea:	4501                	li	a0,0
    3cec:	00001097          	auipc	ra,0x1
    3cf0:	676080e7          	jalr	1654(ra) # 5362 <wait>
    3cf4:	b761                	j	3c7c <preempt+0x124>

0000000000003cf6 <sbrkfail>:
{
    3cf6:	7119                	add	sp,sp,-128
    3cf8:	fc86                	sd	ra,120(sp)
    3cfa:	f8a2                	sd	s0,112(sp)
    3cfc:	f4a6                	sd	s1,104(sp)
    3cfe:	f0ca                	sd	s2,96(sp)
    3d00:	ecce                	sd	s3,88(sp)
    3d02:	e8d2                	sd	s4,80(sp)
    3d04:	e4d6                	sd	s5,72(sp)
    3d06:	0100                	add	s0,sp,128
    3d08:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3d0a:	fb040513          	add	a0,s0,-80
    3d0e:	00001097          	auipc	ra,0x1
    3d12:	65c080e7          	jalr	1628(ra) # 536a <pipe>
    3d16:	e901                	bnez	a0,3d26 <sbrkfail+0x30>
    3d18:	f8040493          	add	s1,s0,-128
    3d1c:	fa840993          	add	s3,s0,-88
    3d20:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3d22:	5a7d                	li	s4,-1
    3d24:	a085                	j	3d84 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3d26:	85d6                	mv	a1,s5
    3d28:	00002517          	auipc	a0,0x2
    3d2c:	55850513          	add	a0,a0,1368 # 6280 <statistics+0xa20>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	992080e7          	jalr	-1646(ra) # 56c2 <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00001097          	auipc	ra,0x1
    3d3e:	620080e7          	jalr	1568(ra) # 535a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d42:	00001097          	auipc	ra,0x1
    3d46:	6a0080e7          	jalr	1696(ra) # 53e2 <sbrk>
    3d4a:	064007b7          	lui	a5,0x6400
    3d4e:	40a7853b          	subw	a0,a5,a0
    3d52:	00001097          	auipc	ra,0x1
    3d56:	690080e7          	jalr	1680(ra) # 53e2 <sbrk>
      write(fds[1], "x", 1);
    3d5a:	4605                	li	a2,1
    3d5c:	00002597          	auipc	a1,0x2
    3d60:	c3458593          	add	a1,a1,-972 # 5990 <statistics+0x130>
    3d64:	fb442503          	lw	a0,-76(s0)
    3d68:	00001097          	auipc	ra,0x1
    3d6c:	612080e7          	jalr	1554(ra) # 537a <write>
      for(;;) sleep(1000);
    3d70:	3e800513          	li	a0,1000
    3d74:	00001097          	auipc	ra,0x1
    3d78:	676080e7          	jalr	1654(ra) # 53ea <sleep>
    3d7c:	bfd5                	j	3d70 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d7e:	0911                	add	s2,s2,4
    3d80:	03390563          	beq	s2,s3,3daa <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3d84:	00001097          	auipc	ra,0x1
    3d88:	5ce080e7          	jalr	1486(ra) # 5352 <fork>
    3d8c:	00a92023          	sw	a0,0(s2)
    3d90:	d94d                	beqz	a0,3d42 <sbrkfail+0x4c>
    if(pids[i] != -1)
    3d92:	ff4506e3          	beq	a0,s4,3d7e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3d96:	4605                	li	a2,1
    3d98:	faf40593          	add	a1,s0,-81
    3d9c:	fb042503          	lw	a0,-80(s0)
    3da0:	00001097          	auipc	ra,0x1
    3da4:	5d2080e7          	jalr	1490(ra) # 5372 <read>
    3da8:	bfd9                	j	3d7e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3daa:	6505                	lui	a0,0x1
    3dac:	00001097          	auipc	ra,0x1
    3db0:	636080e7          	jalr	1590(ra) # 53e2 <sbrk>
    3db4:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3db6:	597d                	li	s2,-1
    3db8:	a021                	j	3dc0 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3dba:	0491                	add	s1,s1,4
    3dbc:	01348f63          	beq	s1,s3,3dda <sbrkfail+0xe4>
    if(pids[i] == -1)
    3dc0:	4088                	lw	a0,0(s1)
    3dc2:	ff250ce3          	beq	a0,s2,3dba <sbrkfail+0xc4>
    kill(pids[i]);
    3dc6:	00001097          	auipc	ra,0x1
    3dca:	5c4080e7          	jalr	1476(ra) # 538a <kill>
    wait(0);
    3dce:	4501                	li	a0,0
    3dd0:	00001097          	auipc	ra,0x1
    3dd4:	592080e7          	jalr	1426(ra) # 5362 <wait>
    3dd8:	b7cd                	j	3dba <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    3dda:	57fd                	li	a5,-1
    3ddc:	04fa0163          	beq	s4,a5,3e1e <sbrkfail+0x128>
  pid = fork();
    3de0:	00001097          	auipc	ra,0x1
    3de4:	572080e7          	jalr	1394(ra) # 5352 <fork>
    3de8:	84aa                	mv	s1,a0
  if(pid < 0){
    3dea:	04054863          	bltz	a0,3e3a <sbrkfail+0x144>
  if(pid == 0){
    3dee:	c525                	beqz	a0,3e56 <sbrkfail+0x160>
  wait(&xstatus);
    3df0:	fbc40513          	add	a0,s0,-68
    3df4:	00001097          	auipc	ra,0x1
    3df8:	56e080e7          	jalr	1390(ra) # 5362 <wait>
  if(xstatus != -1 && xstatus != 2)
    3dfc:	fbc42783          	lw	a5,-68(s0)
    3e00:	577d                	li	a4,-1
    3e02:	00e78563          	beq	a5,a4,3e0c <sbrkfail+0x116>
    3e06:	4709                	li	a4,2
    3e08:	08e79c63          	bne	a5,a4,3ea0 <sbrkfail+0x1aa>
}
    3e0c:	70e6                	ld	ra,120(sp)
    3e0e:	7446                	ld	s0,112(sp)
    3e10:	74a6                	ld	s1,104(sp)
    3e12:	7906                	ld	s2,96(sp)
    3e14:	69e6                	ld	s3,88(sp)
    3e16:	6a46                	ld	s4,80(sp)
    3e18:	6aa6                	ld	s5,72(sp)
    3e1a:	6109                	add	sp,sp,128
    3e1c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e1e:	85d6                	mv	a1,s5
    3e20:	00003517          	auipc	a0,0x3
    3e24:	50850513          	add	a0,a0,1288 # 7328 <statistics+0x1ac8>
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	89a080e7          	jalr	-1894(ra) # 56c2 <printf>
    exit(1);
    3e30:	4505                	li	a0,1
    3e32:	00001097          	auipc	ra,0x1
    3e36:	528080e7          	jalr	1320(ra) # 535a <exit>
    printf("%s: fork failed\n", s);
    3e3a:	85d6                	mv	a1,s5
    3e3c:	00002517          	auipc	a0,0x2
    3e40:	33c50513          	add	a0,a0,828 # 6178 <statistics+0x918>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	87e080e7          	jalr	-1922(ra) # 56c2 <printf>
    exit(1);
    3e4c:	4505                	li	a0,1
    3e4e:	00001097          	auipc	ra,0x1
    3e52:	50c080e7          	jalr	1292(ra) # 535a <exit>
    a = sbrk(0);
    3e56:	4501                	li	a0,0
    3e58:	00001097          	auipc	ra,0x1
    3e5c:	58a080e7          	jalr	1418(ra) # 53e2 <sbrk>
    3e60:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e62:	3e800537          	lui	a0,0x3e800
    3e66:	00001097          	auipc	ra,0x1
    3e6a:	57c080e7          	jalr	1404(ra) # 53e2 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e6e:	87ca                	mv	a5,s2
    3e70:	3e800737          	lui	a4,0x3e800
    3e74:	993a                	add	s2,s2,a4
    3e76:	6705                	lui	a4,0x1
      n += *(a+i);
    3e78:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f17e8>
    3e7c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e7e:	97ba                	add	a5,a5,a4
    3e80:	ff279ce3          	bne	a5,s2,3e78 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e84:	85a6                	mv	a1,s1
    3e86:	00003517          	auipc	a0,0x3
    3e8a:	4c250513          	add	a0,a0,1218 # 7348 <statistics+0x1ae8>
    3e8e:	00002097          	auipc	ra,0x2
    3e92:	834080e7          	jalr	-1996(ra) # 56c2 <printf>
    exit(1);
    3e96:	4505                	li	a0,1
    3e98:	00001097          	auipc	ra,0x1
    3e9c:	4c2080e7          	jalr	1218(ra) # 535a <exit>
    exit(1);
    3ea0:	4505                	li	a0,1
    3ea2:	00001097          	auipc	ra,0x1
    3ea6:	4b8080e7          	jalr	1208(ra) # 535a <exit>

0000000000003eaa <reparent>:
{
    3eaa:	7179                	add	sp,sp,-48
    3eac:	f406                	sd	ra,40(sp)
    3eae:	f022                	sd	s0,32(sp)
    3eb0:	ec26                	sd	s1,24(sp)
    3eb2:	e84a                	sd	s2,16(sp)
    3eb4:	e44e                	sd	s3,8(sp)
    3eb6:	e052                	sd	s4,0(sp)
    3eb8:	1800                	add	s0,sp,48
    3eba:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3ebc:	00001097          	auipc	ra,0x1
    3ec0:	51e080e7          	jalr	1310(ra) # 53da <getpid>
    3ec4:	8a2a                	mv	s4,a0
    3ec6:	0c800913          	li	s2,200
    int pid = fork();
    3eca:	00001097          	auipc	ra,0x1
    3ece:	488080e7          	jalr	1160(ra) # 5352 <fork>
    3ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    3ed4:	02054263          	bltz	a0,3ef8 <reparent+0x4e>
    if(pid){
    3ed8:	cd21                	beqz	a0,3f30 <reparent+0x86>
      if(wait(0) != pid){
    3eda:	4501                	li	a0,0
    3edc:	00001097          	auipc	ra,0x1
    3ee0:	486080e7          	jalr	1158(ra) # 5362 <wait>
    3ee4:	02951863          	bne	a0,s1,3f14 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3ee8:	397d                	addw	s2,s2,-1
    3eea:	fe0910e3          	bnez	s2,3eca <reparent+0x20>
  exit(0);
    3eee:	4501                	li	a0,0
    3ef0:	00001097          	auipc	ra,0x1
    3ef4:	46a080e7          	jalr	1130(ra) # 535a <exit>
      printf("%s: fork failed\n", s);
    3ef8:	85ce                	mv	a1,s3
    3efa:	00002517          	auipc	a0,0x2
    3efe:	27e50513          	add	a0,a0,638 # 6178 <statistics+0x918>
    3f02:	00001097          	auipc	ra,0x1
    3f06:	7c0080e7          	jalr	1984(ra) # 56c2 <printf>
      exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	44e080e7          	jalr	1102(ra) # 535a <exit>
        printf("%s: wait wrong pid\n", s);
    3f14:	85ce                	mv	a1,s3
    3f16:	00002517          	auipc	a0,0x2
    3f1a:	3ea50513          	add	a0,a0,1002 # 6300 <statistics+0xaa0>
    3f1e:	00001097          	auipc	ra,0x1
    3f22:	7a4080e7          	jalr	1956(ra) # 56c2 <printf>
        exit(1);
    3f26:	4505                	li	a0,1
    3f28:	00001097          	auipc	ra,0x1
    3f2c:	432080e7          	jalr	1074(ra) # 535a <exit>
      int pid2 = fork();
    3f30:	00001097          	auipc	ra,0x1
    3f34:	422080e7          	jalr	1058(ra) # 5352 <fork>
      if(pid2 < 0){
    3f38:	00054763          	bltz	a0,3f46 <reparent+0x9c>
      exit(0);
    3f3c:	4501                	li	a0,0
    3f3e:	00001097          	auipc	ra,0x1
    3f42:	41c080e7          	jalr	1052(ra) # 535a <exit>
        kill(master_pid);
    3f46:	8552                	mv	a0,s4
    3f48:	00001097          	auipc	ra,0x1
    3f4c:	442080e7          	jalr	1090(ra) # 538a <kill>
        exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00001097          	auipc	ra,0x1
    3f56:	408080e7          	jalr	1032(ra) # 535a <exit>

0000000000003f5a <mem>:
{
    3f5a:	7139                	add	sp,sp,-64
    3f5c:	fc06                	sd	ra,56(sp)
    3f5e:	f822                	sd	s0,48(sp)
    3f60:	f426                	sd	s1,40(sp)
    3f62:	f04a                	sd	s2,32(sp)
    3f64:	ec4e                	sd	s3,24(sp)
    3f66:	0080                	add	s0,sp,64
    3f68:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f6a:	00001097          	auipc	ra,0x1
    3f6e:	3e8080e7          	jalr	1000(ra) # 5352 <fork>
    m1 = 0;
    3f72:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f74:	6909                	lui	s2,0x2
    3f76:	71190913          	add	s2,s2,1809 # 2711 <sbrkarg+0xc3>
  if((pid = fork()) == 0){
    3f7a:	c115                	beqz	a0,3f9e <mem+0x44>
    wait(&xstatus);
    3f7c:	fcc40513          	add	a0,s0,-52
    3f80:	00001097          	auipc	ra,0x1
    3f84:	3e2080e7          	jalr	994(ra) # 5362 <wait>
    if(xstatus == -1){
    3f88:	fcc42503          	lw	a0,-52(s0)
    3f8c:	57fd                	li	a5,-1
    3f8e:	06f50363          	beq	a0,a5,3ff4 <mem+0x9a>
    exit(xstatus);
    3f92:	00001097          	auipc	ra,0x1
    3f96:	3c8080e7          	jalr	968(ra) # 535a <exit>
      *(char**)m2 = m1;
    3f9a:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f9c:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3f9e:	854a                	mv	a0,s2
    3fa0:	00001097          	auipc	ra,0x1
    3fa4:	7da080e7          	jalr	2010(ra) # 577a <malloc>
    3fa8:	f96d                	bnez	a0,3f9a <mem+0x40>
    while(m1){
    3faa:	c881                	beqz	s1,3fba <mem+0x60>
      m2 = *(char**)m1;
    3fac:	8526                	mv	a0,s1
    3fae:	6084                	ld	s1,0(s1)
      free(m1);
    3fb0:	00001097          	auipc	ra,0x1
    3fb4:	748080e7          	jalr	1864(ra) # 56f8 <free>
    while(m1){
    3fb8:	f8f5                	bnez	s1,3fac <mem+0x52>
    m1 = malloc(1024*20);
    3fba:	6515                	lui	a0,0x5
    3fbc:	00001097          	auipc	ra,0x1
    3fc0:	7be080e7          	jalr	1982(ra) # 577a <malloc>
    if(m1 == 0){
    3fc4:	c911                	beqz	a0,3fd8 <mem+0x7e>
    free(m1);
    3fc6:	00001097          	auipc	ra,0x1
    3fca:	732080e7          	jalr	1842(ra) # 56f8 <free>
    exit(0);
    3fce:	4501                	li	a0,0
    3fd0:	00001097          	auipc	ra,0x1
    3fd4:	38a080e7          	jalr	906(ra) # 535a <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fd8:	85ce                	mv	a1,s3
    3fda:	00003517          	auipc	a0,0x3
    3fde:	39e50513          	add	a0,a0,926 # 7378 <statistics+0x1b18>
    3fe2:	00001097          	auipc	ra,0x1
    3fe6:	6e0080e7          	jalr	1760(ra) # 56c2 <printf>
      exit(1);
    3fea:	4505                	li	a0,1
    3fec:	00001097          	auipc	ra,0x1
    3ff0:	36e080e7          	jalr	878(ra) # 535a <exit>
      exit(0);
    3ff4:	4501                	li	a0,0
    3ff6:	00001097          	auipc	ra,0x1
    3ffa:	364080e7          	jalr	868(ra) # 535a <exit>

0000000000003ffe <sharedfd>:
{
    3ffe:	7159                	add	sp,sp,-112
    4000:	f486                	sd	ra,104(sp)
    4002:	f0a2                	sd	s0,96(sp)
    4004:	eca6                	sd	s1,88(sp)
    4006:	e8ca                	sd	s2,80(sp)
    4008:	e4ce                	sd	s3,72(sp)
    400a:	e0d2                	sd	s4,64(sp)
    400c:	fc56                	sd	s5,56(sp)
    400e:	f85a                	sd	s6,48(sp)
    4010:	f45e                	sd	s7,40(sp)
    4012:	1880                	add	s0,sp,112
    4014:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4016:	00003517          	auipc	a0,0x3
    401a:	38250513          	add	a0,a0,898 # 7398 <statistics+0x1b38>
    401e:	00001097          	auipc	ra,0x1
    4022:	38c080e7          	jalr	908(ra) # 53aa <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4026:	20200593          	li	a1,514
    402a:	00003517          	auipc	a0,0x3
    402e:	36e50513          	add	a0,a0,878 # 7398 <statistics+0x1b38>
    4032:	00001097          	auipc	ra,0x1
    4036:	368080e7          	jalr	872(ra) # 539a <open>
  if(fd < 0){
    403a:	04054a63          	bltz	a0,408e <sharedfd+0x90>
    403e:	892a                	mv	s2,a0
  pid = fork();
    4040:	00001097          	auipc	ra,0x1
    4044:	312080e7          	jalr	786(ra) # 5352 <fork>
    4048:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    404a:	07000593          	li	a1,112
    404e:	e119                	bnez	a0,4054 <sharedfd+0x56>
    4050:	06300593          	li	a1,99
    4054:	4629                	li	a2,10
    4056:	fa040513          	add	a0,s0,-96
    405a:	00001097          	auipc	ra,0x1
    405e:	106080e7          	jalr	262(ra) # 5160 <memset>
    4062:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4066:	4629                	li	a2,10
    4068:	fa040593          	add	a1,s0,-96
    406c:	854a                	mv	a0,s2
    406e:	00001097          	auipc	ra,0x1
    4072:	30c080e7          	jalr	780(ra) # 537a <write>
    4076:	47a9                	li	a5,10
    4078:	02f51963          	bne	a0,a5,40aa <sharedfd+0xac>
  for(i = 0; i < N; i++){
    407c:	34fd                	addw	s1,s1,-1
    407e:	f4e5                	bnez	s1,4066 <sharedfd+0x68>
  if(pid == 0) {
    4080:	04099363          	bnez	s3,40c6 <sharedfd+0xc8>
    exit(0);
    4084:	4501                	li	a0,0
    4086:	00001097          	auipc	ra,0x1
    408a:	2d4080e7          	jalr	724(ra) # 535a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    408e:	85d2                	mv	a1,s4
    4090:	00003517          	auipc	a0,0x3
    4094:	31850513          	add	a0,a0,792 # 73a8 <statistics+0x1b48>
    4098:	00001097          	auipc	ra,0x1
    409c:	62a080e7          	jalr	1578(ra) # 56c2 <printf>
    exit(1);
    40a0:	4505                	li	a0,1
    40a2:	00001097          	auipc	ra,0x1
    40a6:	2b8080e7          	jalr	696(ra) # 535a <exit>
      printf("%s: write sharedfd failed\n", s);
    40aa:	85d2                	mv	a1,s4
    40ac:	00003517          	auipc	a0,0x3
    40b0:	32450513          	add	a0,a0,804 # 73d0 <statistics+0x1b70>
    40b4:	00001097          	auipc	ra,0x1
    40b8:	60e080e7          	jalr	1550(ra) # 56c2 <printf>
      exit(1);
    40bc:	4505                	li	a0,1
    40be:	00001097          	auipc	ra,0x1
    40c2:	29c080e7          	jalr	668(ra) # 535a <exit>
    wait(&xstatus);
    40c6:	f9c40513          	add	a0,s0,-100
    40ca:	00001097          	auipc	ra,0x1
    40ce:	298080e7          	jalr	664(ra) # 5362 <wait>
    if(xstatus != 0)
    40d2:	f9c42983          	lw	s3,-100(s0)
    40d6:	00098763          	beqz	s3,40e4 <sharedfd+0xe6>
      exit(xstatus);
    40da:	854e                	mv	a0,s3
    40dc:	00001097          	auipc	ra,0x1
    40e0:	27e080e7          	jalr	638(ra) # 535a <exit>
  close(fd);
    40e4:	854a                	mv	a0,s2
    40e6:	00001097          	auipc	ra,0x1
    40ea:	29c080e7          	jalr	668(ra) # 5382 <close>
  fd = open("sharedfd", 0);
    40ee:	4581                	li	a1,0
    40f0:	00003517          	auipc	a0,0x3
    40f4:	2a850513          	add	a0,a0,680 # 7398 <statistics+0x1b38>
    40f8:	00001097          	auipc	ra,0x1
    40fc:	2a2080e7          	jalr	674(ra) # 539a <open>
    4100:	8baa                	mv	s7,a0
  nc = np = 0;
    4102:	8ace                	mv	s5,s3
  if(fd < 0){
    4104:	02054563          	bltz	a0,412e <sharedfd+0x130>
    4108:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    410c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4110:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4114:	4629                	li	a2,10
    4116:	fa040593          	add	a1,s0,-96
    411a:	855e                	mv	a0,s7
    411c:	00001097          	auipc	ra,0x1
    4120:	256080e7          	jalr	598(ra) # 5372 <read>
    4124:	02a05f63          	blez	a0,4162 <sharedfd+0x164>
    4128:	fa040793          	add	a5,s0,-96
    412c:	a01d                	j	4152 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    412e:	85d2                	mv	a1,s4
    4130:	00003517          	auipc	a0,0x3
    4134:	2c050513          	add	a0,a0,704 # 73f0 <statistics+0x1b90>
    4138:	00001097          	auipc	ra,0x1
    413c:	58a080e7          	jalr	1418(ra) # 56c2 <printf>
    exit(1);
    4140:	4505                	li	a0,1
    4142:	00001097          	auipc	ra,0x1
    4146:	218080e7          	jalr	536(ra) # 535a <exit>
        nc++;
    414a:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    414c:	0785                	add	a5,a5,1
    414e:	fd2783e3          	beq	a5,s2,4114 <sharedfd+0x116>
      if(buf[i] == 'c')
    4152:	0007c703          	lbu	a4,0(a5)
    4156:	fe970ae3          	beq	a4,s1,414a <sharedfd+0x14c>
      if(buf[i] == 'p')
    415a:	ff6719e3          	bne	a4,s6,414c <sharedfd+0x14e>
        np++;
    415e:	2a85                	addw	s5,s5,1
    4160:	b7f5                	j	414c <sharedfd+0x14e>
  close(fd);
    4162:	855e                	mv	a0,s7
    4164:	00001097          	auipc	ra,0x1
    4168:	21e080e7          	jalr	542(ra) # 5382 <close>
  unlink("sharedfd");
    416c:	00003517          	auipc	a0,0x3
    4170:	22c50513          	add	a0,a0,556 # 7398 <statistics+0x1b38>
    4174:	00001097          	auipc	ra,0x1
    4178:	236080e7          	jalr	566(ra) # 53aa <unlink>
  if(nc == N*SZ && np == N*SZ){
    417c:	6789                	lui	a5,0x2
    417e:	71078793          	add	a5,a5,1808 # 2710 <sbrkarg+0xc2>
    4182:	00f99763          	bne	s3,a5,4190 <sharedfd+0x192>
    4186:	6789                	lui	a5,0x2
    4188:	71078793          	add	a5,a5,1808 # 2710 <sbrkarg+0xc2>
    418c:	02fa8063          	beq	s5,a5,41ac <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4190:	85d2                	mv	a1,s4
    4192:	00003517          	auipc	a0,0x3
    4196:	28650513          	add	a0,a0,646 # 7418 <statistics+0x1bb8>
    419a:	00001097          	auipc	ra,0x1
    419e:	528080e7          	jalr	1320(ra) # 56c2 <printf>
    exit(1);
    41a2:	4505                	li	a0,1
    41a4:	00001097          	auipc	ra,0x1
    41a8:	1b6080e7          	jalr	438(ra) # 535a <exit>
    exit(0);
    41ac:	4501                	li	a0,0
    41ae:	00001097          	auipc	ra,0x1
    41b2:	1ac080e7          	jalr	428(ra) # 535a <exit>

00000000000041b6 <fourfiles>:
{
    41b6:	7135                	add	sp,sp,-160
    41b8:	ed06                	sd	ra,152(sp)
    41ba:	e922                	sd	s0,144(sp)
    41bc:	e526                	sd	s1,136(sp)
    41be:	e14a                	sd	s2,128(sp)
    41c0:	fcce                	sd	s3,120(sp)
    41c2:	f8d2                	sd	s4,112(sp)
    41c4:	f4d6                	sd	s5,104(sp)
    41c6:	f0da                	sd	s6,96(sp)
    41c8:	ecde                	sd	s7,88(sp)
    41ca:	e8e2                	sd	s8,80(sp)
    41cc:	e4e6                	sd	s9,72(sp)
    41ce:	e0ea                	sd	s10,64(sp)
    41d0:	fc6e                	sd	s11,56(sp)
    41d2:	1100                	add	s0,sp,160
    41d4:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    41d6:	00003797          	auipc	a5,0x3
    41da:	25a78793          	add	a5,a5,602 # 7430 <statistics+0x1bd0>
    41de:	f6f43823          	sd	a5,-144(s0)
    41e2:	00003797          	auipc	a5,0x3
    41e6:	25678793          	add	a5,a5,598 # 7438 <statistics+0x1bd8>
    41ea:	f6f43c23          	sd	a5,-136(s0)
    41ee:	00003797          	auipc	a5,0x3
    41f2:	25278793          	add	a5,a5,594 # 7440 <statistics+0x1be0>
    41f6:	f8f43023          	sd	a5,-128(s0)
    41fa:	00003797          	auipc	a5,0x3
    41fe:	24e78793          	add	a5,a5,590 # 7448 <statistics+0x1be8>
    4202:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4206:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    420a:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    420c:	4481                	li	s1,0
    420e:	4a11                	li	s4,4
    fname = names[pi];
    4210:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4214:	854e                	mv	a0,s3
    4216:	00001097          	auipc	ra,0x1
    421a:	194080e7          	jalr	404(ra) # 53aa <unlink>
    pid = fork();
    421e:	00001097          	auipc	ra,0x1
    4222:	134080e7          	jalr	308(ra) # 5352 <fork>
    if(pid < 0){
    4226:	04054063          	bltz	a0,4266 <fourfiles+0xb0>
    if(pid == 0){
    422a:	cd21                	beqz	a0,4282 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    422c:	2485                	addw	s1,s1,1
    422e:	0921                	add	s2,s2,8
    4230:	ff4490e3          	bne	s1,s4,4210 <fourfiles+0x5a>
    4234:	4491                	li	s1,4
    wait(&xstatus);
    4236:	f6c40513          	add	a0,s0,-148
    423a:	00001097          	auipc	ra,0x1
    423e:	128080e7          	jalr	296(ra) # 5362 <wait>
    if(xstatus != 0)
    4242:	f6c42a83          	lw	s5,-148(s0)
    4246:	0c0a9863          	bnez	s5,4316 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    424a:	34fd                	addw	s1,s1,-1
    424c:	f4ed                	bnez	s1,4236 <fourfiles+0x80>
    424e:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4252:	00007a17          	auipc	s4,0x7
    4256:	5b6a0a13          	add	s4,s4,1462 # b808 <buf>
    if(total != N*SZ){
    425a:	6d05                	lui	s10,0x1
    425c:	770d0d13          	add	s10,s10,1904 # 1770 <pipe1+0x2c>
  for(i = 0; i < NCHILD; i++){
    4260:	03400d93          	li	s11,52
    4264:	a22d                	j	438e <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4266:	85e6                	mv	a1,s9
    4268:	00002517          	auipc	a0,0x2
    426c:	30050513          	add	a0,a0,768 # 6568 <statistics+0xd08>
    4270:	00001097          	auipc	ra,0x1
    4274:	452080e7          	jalr	1106(ra) # 56c2 <printf>
      exit(1);
    4278:	4505                	li	a0,1
    427a:	00001097          	auipc	ra,0x1
    427e:	0e0080e7          	jalr	224(ra) # 535a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4282:	20200593          	li	a1,514
    4286:	854e                	mv	a0,s3
    4288:	00001097          	auipc	ra,0x1
    428c:	112080e7          	jalr	274(ra) # 539a <open>
    4290:	892a                	mv	s2,a0
      if(fd < 0){
    4292:	04054763          	bltz	a0,42e0 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4296:	1f400613          	li	a2,500
    429a:	0304859b          	addw	a1,s1,48
    429e:	00007517          	auipc	a0,0x7
    42a2:	56a50513          	add	a0,a0,1386 # b808 <buf>
    42a6:	00001097          	auipc	ra,0x1
    42aa:	eba080e7          	jalr	-326(ra) # 5160 <memset>
    42ae:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42b0:	00007997          	auipc	s3,0x7
    42b4:	55898993          	add	s3,s3,1368 # b808 <buf>
    42b8:	1f400613          	li	a2,500
    42bc:	85ce                	mv	a1,s3
    42be:	854a                	mv	a0,s2
    42c0:	00001097          	auipc	ra,0x1
    42c4:	0ba080e7          	jalr	186(ra) # 537a <write>
    42c8:	85aa                	mv	a1,a0
    42ca:	1f400793          	li	a5,500
    42ce:	02f51763          	bne	a0,a5,42fc <fourfiles+0x146>
      for(i = 0; i < N; i++){
    42d2:	34fd                	addw	s1,s1,-1
    42d4:	f0f5                	bnez	s1,42b8 <fourfiles+0x102>
      exit(0);
    42d6:	4501                	li	a0,0
    42d8:	00001097          	auipc	ra,0x1
    42dc:	082080e7          	jalr	130(ra) # 535a <exit>
        printf("create failed\n", s);
    42e0:	85e6                	mv	a1,s9
    42e2:	00003517          	auipc	a0,0x3
    42e6:	16e50513          	add	a0,a0,366 # 7450 <statistics+0x1bf0>
    42ea:	00001097          	auipc	ra,0x1
    42ee:	3d8080e7          	jalr	984(ra) # 56c2 <printf>
        exit(1);
    42f2:	4505                	li	a0,1
    42f4:	00001097          	auipc	ra,0x1
    42f8:	066080e7          	jalr	102(ra) # 535a <exit>
          printf("write failed %d\n", n);
    42fc:	00003517          	auipc	a0,0x3
    4300:	16450513          	add	a0,a0,356 # 7460 <statistics+0x1c00>
    4304:	00001097          	auipc	ra,0x1
    4308:	3be080e7          	jalr	958(ra) # 56c2 <printf>
          exit(1);
    430c:	4505                	li	a0,1
    430e:	00001097          	auipc	ra,0x1
    4312:	04c080e7          	jalr	76(ra) # 535a <exit>
      exit(xstatus);
    4316:	8556                	mv	a0,s5
    4318:	00001097          	auipc	ra,0x1
    431c:	042080e7          	jalr	66(ra) # 535a <exit>
          printf("wrong char\n", s);
    4320:	85e6                	mv	a1,s9
    4322:	00003517          	auipc	a0,0x3
    4326:	15650513          	add	a0,a0,342 # 7478 <statistics+0x1c18>
    432a:	00001097          	auipc	ra,0x1
    432e:	398080e7          	jalr	920(ra) # 56c2 <printf>
          exit(1);
    4332:	4505                	li	a0,1
    4334:	00001097          	auipc	ra,0x1
    4338:	026080e7          	jalr	38(ra) # 535a <exit>
      total += n;
    433c:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4340:	660d                	lui	a2,0x3
    4342:	85d2                	mv	a1,s4
    4344:	854e                	mv	a0,s3
    4346:	00001097          	auipc	ra,0x1
    434a:	02c080e7          	jalr	44(ra) # 5372 <read>
    434e:	02a05063          	blez	a0,436e <fourfiles+0x1b8>
    4352:	00007797          	auipc	a5,0x7
    4356:	4b678793          	add	a5,a5,1206 # b808 <buf>
    435a:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    435e:	0007c703          	lbu	a4,0(a5)
    4362:	fa971fe3          	bne	a4,s1,4320 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4366:	0785                	add	a5,a5,1
    4368:	fed79be3          	bne	a5,a3,435e <fourfiles+0x1a8>
    436c:	bfc1                	j	433c <fourfiles+0x186>
    close(fd);
    436e:	854e                	mv	a0,s3
    4370:	00001097          	auipc	ra,0x1
    4374:	012080e7          	jalr	18(ra) # 5382 <close>
    if(total != N*SZ){
    4378:	03a91863          	bne	s2,s10,43a8 <fourfiles+0x1f2>
    unlink(fname);
    437c:	8562                	mv	a0,s8
    437e:	00001097          	auipc	ra,0x1
    4382:	02c080e7          	jalr	44(ra) # 53aa <unlink>
  for(i = 0; i < NCHILD; i++){
    4386:	0ba1                	add	s7,s7,8
    4388:	2b05                	addw	s6,s6,1
    438a:	03bb0d63          	beq	s6,s11,43c4 <fourfiles+0x20e>
    fname = names[i];
    438e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4392:	4581                	li	a1,0
    4394:	8562                	mv	a0,s8
    4396:	00001097          	auipc	ra,0x1
    439a:	004080e7          	jalr	4(ra) # 539a <open>
    439e:	89aa                	mv	s3,a0
    total = 0;
    43a0:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    43a2:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43a6:	bf69                	j	4340 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    43a8:	85ca                	mv	a1,s2
    43aa:	00003517          	auipc	a0,0x3
    43ae:	0de50513          	add	a0,a0,222 # 7488 <statistics+0x1c28>
    43b2:	00001097          	auipc	ra,0x1
    43b6:	310080e7          	jalr	784(ra) # 56c2 <printf>
      exit(1);
    43ba:	4505                	li	a0,1
    43bc:	00001097          	auipc	ra,0x1
    43c0:	f9e080e7          	jalr	-98(ra) # 535a <exit>
}
    43c4:	60ea                	ld	ra,152(sp)
    43c6:	644a                	ld	s0,144(sp)
    43c8:	64aa                	ld	s1,136(sp)
    43ca:	690a                	ld	s2,128(sp)
    43cc:	79e6                	ld	s3,120(sp)
    43ce:	7a46                	ld	s4,112(sp)
    43d0:	7aa6                	ld	s5,104(sp)
    43d2:	7b06                	ld	s6,96(sp)
    43d4:	6be6                	ld	s7,88(sp)
    43d6:	6c46                	ld	s8,80(sp)
    43d8:	6ca6                	ld	s9,72(sp)
    43da:	6d06                	ld	s10,64(sp)
    43dc:	7de2                	ld	s11,56(sp)
    43de:	610d                	add	sp,sp,160
    43e0:	8082                	ret

00000000000043e2 <concreate>:
{
    43e2:	7135                	add	sp,sp,-160
    43e4:	ed06                	sd	ra,152(sp)
    43e6:	e922                	sd	s0,144(sp)
    43e8:	e526                	sd	s1,136(sp)
    43ea:	e14a                	sd	s2,128(sp)
    43ec:	fcce                	sd	s3,120(sp)
    43ee:	f8d2                	sd	s4,112(sp)
    43f0:	f4d6                	sd	s5,104(sp)
    43f2:	f0da                	sd	s6,96(sp)
    43f4:	ecde                	sd	s7,88(sp)
    43f6:	1100                	add	s0,sp,160
    43f8:	89aa                	mv	s3,a0
  file[0] = 'C';
    43fa:	04300793          	li	a5,67
    43fe:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4402:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4406:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4408:	4b0d                	li	s6,3
    440a:	4a85                	li	s5,1
      link("C0", file);
    440c:	00003b97          	auipc	s7,0x3
    4410:	094b8b93          	add	s7,s7,148 # 74a0 <statistics+0x1c40>
  for(i = 0; i < N; i++){
    4414:	02800a13          	li	s4,40
    4418:	acc9                	j	46ea <concreate+0x308>
      link("C0", file);
    441a:	fa840593          	add	a1,s0,-88
    441e:	855e                	mv	a0,s7
    4420:	00001097          	auipc	ra,0x1
    4424:	f9a080e7          	jalr	-102(ra) # 53ba <link>
    if(pid == 0) {
    4428:	a465                	j	46d0 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    442a:	4795                	li	a5,5
    442c:	02f9693b          	remw	s2,s2,a5
    4430:	4785                	li	a5,1
    4432:	02f90b63          	beq	s2,a5,4468 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4436:	20200593          	li	a1,514
    443a:	fa840513          	add	a0,s0,-88
    443e:	00001097          	auipc	ra,0x1
    4442:	f5c080e7          	jalr	-164(ra) # 539a <open>
      if(fd < 0){
    4446:	26055c63          	bgez	a0,46be <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    444a:	fa840593          	add	a1,s0,-88
    444e:	00003517          	auipc	a0,0x3
    4452:	05a50513          	add	a0,a0,90 # 74a8 <statistics+0x1c48>
    4456:	00001097          	auipc	ra,0x1
    445a:	26c080e7          	jalr	620(ra) # 56c2 <printf>
        exit(1);
    445e:	4505                	li	a0,1
    4460:	00001097          	auipc	ra,0x1
    4464:	efa080e7          	jalr	-262(ra) # 535a <exit>
      link("C0", file);
    4468:	fa840593          	add	a1,s0,-88
    446c:	00003517          	auipc	a0,0x3
    4470:	03450513          	add	a0,a0,52 # 74a0 <statistics+0x1c40>
    4474:	00001097          	auipc	ra,0x1
    4478:	f46080e7          	jalr	-186(ra) # 53ba <link>
      exit(0);
    447c:	4501                	li	a0,0
    447e:	00001097          	auipc	ra,0x1
    4482:	edc080e7          	jalr	-292(ra) # 535a <exit>
        exit(1);
    4486:	4505                	li	a0,1
    4488:	00001097          	auipc	ra,0x1
    448c:	ed2080e7          	jalr	-302(ra) # 535a <exit>
  memset(fa, 0, sizeof(fa));
    4490:	02800613          	li	a2,40
    4494:	4581                	li	a1,0
    4496:	f8040513          	add	a0,s0,-128
    449a:	00001097          	auipc	ra,0x1
    449e:	cc6080e7          	jalr	-826(ra) # 5160 <memset>
  fd = open(".", 0);
    44a2:	4581                	li	a1,0
    44a4:	00002517          	auipc	a0,0x2
    44a8:	b3450513          	add	a0,a0,-1228 # 5fd8 <statistics+0x778>
    44ac:	00001097          	auipc	ra,0x1
    44b0:	eee080e7          	jalr	-274(ra) # 539a <open>
    44b4:	892a                	mv	s2,a0
  n = 0;
    44b6:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44b8:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44bc:	02700b13          	li	s6,39
      fa[i] = 1;
    44c0:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    44c2:	4641                	li	a2,16
    44c4:	f7040593          	add	a1,s0,-144
    44c8:	854a                	mv	a0,s2
    44ca:	00001097          	auipc	ra,0x1
    44ce:	ea8080e7          	jalr	-344(ra) # 5372 <read>
    44d2:	08a05263          	blez	a0,4556 <concreate+0x174>
    if(de.inum == 0)
    44d6:	f7045783          	lhu	a5,-144(s0)
    44da:	d7e5                	beqz	a5,44c2 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44dc:	f7244783          	lbu	a5,-142(s0)
    44e0:	ff4791e3          	bne	a5,s4,44c2 <concreate+0xe0>
    44e4:	f7444783          	lbu	a5,-140(s0)
    44e8:	ffe9                	bnez	a5,44c2 <concreate+0xe0>
      i = de.name[1] - '0';
    44ea:	f7344783          	lbu	a5,-141(s0)
    44ee:	fd07879b          	addw	a5,a5,-48
    44f2:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    44f6:	02eb6063          	bltu	s6,a4,4516 <concreate+0x134>
      if(fa[i]){
    44fa:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x48>
    44fe:	97a2                	add	a5,a5,s0
    4500:	fd07c783          	lbu	a5,-48(a5)
    4504:	eb8d                	bnez	a5,4536 <concreate+0x154>
      fa[i] = 1;
    4506:	fb070793          	add	a5,a4,-80
    450a:	00878733          	add	a4,a5,s0
    450e:	fd770823          	sb	s7,-48(a4)
      n++;
    4512:	2a85                	addw	s5,s5,1
    4514:	b77d                	j	44c2 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4516:	f7240613          	add	a2,s0,-142
    451a:	85ce                	mv	a1,s3
    451c:	00003517          	auipc	a0,0x3
    4520:	fac50513          	add	a0,a0,-84 # 74c8 <statistics+0x1c68>
    4524:	00001097          	auipc	ra,0x1
    4528:	19e080e7          	jalr	414(ra) # 56c2 <printf>
        exit(1);
    452c:	4505                	li	a0,1
    452e:	00001097          	auipc	ra,0x1
    4532:	e2c080e7          	jalr	-468(ra) # 535a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4536:	f7240613          	add	a2,s0,-142
    453a:	85ce                	mv	a1,s3
    453c:	00003517          	auipc	a0,0x3
    4540:	fac50513          	add	a0,a0,-84 # 74e8 <statistics+0x1c88>
    4544:	00001097          	auipc	ra,0x1
    4548:	17e080e7          	jalr	382(ra) # 56c2 <printf>
        exit(1);
    454c:	4505                	li	a0,1
    454e:	00001097          	auipc	ra,0x1
    4552:	e0c080e7          	jalr	-500(ra) # 535a <exit>
  close(fd);
    4556:	854a                	mv	a0,s2
    4558:	00001097          	auipc	ra,0x1
    455c:	e2a080e7          	jalr	-470(ra) # 5382 <close>
  if(n != N){
    4560:	02800793          	li	a5,40
    4564:	00fa9763          	bne	s5,a5,4572 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4568:	4a8d                	li	s5,3
    456a:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    456c:	02800a13          	li	s4,40
    4570:	a8c9                	j	4642 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4572:	85ce                	mv	a1,s3
    4574:	00003517          	auipc	a0,0x3
    4578:	f9c50513          	add	a0,a0,-100 # 7510 <statistics+0x1cb0>
    457c:	00001097          	auipc	ra,0x1
    4580:	146080e7          	jalr	326(ra) # 56c2 <printf>
    exit(1);
    4584:	4505                	li	a0,1
    4586:	00001097          	auipc	ra,0x1
    458a:	dd4080e7          	jalr	-556(ra) # 535a <exit>
      printf("%s: fork failed\n", s);
    458e:	85ce                	mv	a1,s3
    4590:	00002517          	auipc	a0,0x2
    4594:	be850513          	add	a0,a0,-1048 # 6178 <statistics+0x918>
    4598:	00001097          	auipc	ra,0x1
    459c:	12a080e7          	jalr	298(ra) # 56c2 <printf>
      exit(1);
    45a0:	4505                	li	a0,1
    45a2:	00001097          	auipc	ra,0x1
    45a6:	db8080e7          	jalr	-584(ra) # 535a <exit>
      close(open(file, 0));
    45aa:	4581                	li	a1,0
    45ac:	fa840513          	add	a0,s0,-88
    45b0:	00001097          	auipc	ra,0x1
    45b4:	dea080e7          	jalr	-534(ra) # 539a <open>
    45b8:	00001097          	auipc	ra,0x1
    45bc:	dca080e7          	jalr	-566(ra) # 5382 <close>
      close(open(file, 0));
    45c0:	4581                	li	a1,0
    45c2:	fa840513          	add	a0,s0,-88
    45c6:	00001097          	auipc	ra,0x1
    45ca:	dd4080e7          	jalr	-556(ra) # 539a <open>
    45ce:	00001097          	auipc	ra,0x1
    45d2:	db4080e7          	jalr	-588(ra) # 5382 <close>
      close(open(file, 0));
    45d6:	4581                	li	a1,0
    45d8:	fa840513          	add	a0,s0,-88
    45dc:	00001097          	auipc	ra,0x1
    45e0:	dbe080e7          	jalr	-578(ra) # 539a <open>
    45e4:	00001097          	auipc	ra,0x1
    45e8:	d9e080e7          	jalr	-610(ra) # 5382 <close>
      close(open(file, 0));
    45ec:	4581                	li	a1,0
    45ee:	fa840513          	add	a0,s0,-88
    45f2:	00001097          	auipc	ra,0x1
    45f6:	da8080e7          	jalr	-600(ra) # 539a <open>
    45fa:	00001097          	auipc	ra,0x1
    45fe:	d88080e7          	jalr	-632(ra) # 5382 <close>
      close(open(file, 0));
    4602:	4581                	li	a1,0
    4604:	fa840513          	add	a0,s0,-88
    4608:	00001097          	auipc	ra,0x1
    460c:	d92080e7          	jalr	-622(ra) # 539a <open>
    4610:	00001097          	auipc	ra,0x1
    4614:	d72080e7          	jalr	-654(ra) # 5382 <close>
      close(open(file, 0));
    4618:	4581                	li	a1,0
    461a:	fa840513          	add	a0,s0,-88
    461e:	00001097          	auipc	ra,0x1
    4622:	d7c080e7          	jalr	-644(ra) # 539a <open>
    4626:	00001097          	auipc	ra,0x1
    462a:	d5c080e7          	jalr	-676(ra) # 5382 <close>
    if(pid == 0)
    462e:	08090363          	beqz	s2,46b4 <concreate+0x2d2>
      wait(0);
    4632:	4501                	li	a0,0
    4634:	00001097          	auipc	ra,0x1
    4638:	d2e080e7          	jalr	-722(ra) # 5362 <wait>
  for(i = 0; i < N; i++){
    463c:	2485                	addw	s1,s1,1
    463e:	0f448563          	beq	s1,s4,4728 <concreate+0x346>
    file[1] = '0' + i;
    4642:	0304879b          	addw	a5,s1,48
    4646:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    464a:	00001097          	auipc	ra,0x1
    464e:	d08080e7          	jalr	-760(ra) # 5352 <fork>
    4652:	892a                	mv	s2,a0
    if(pid < 0){
    4654:	f2054de3          	bltz	a0,458e <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4658:	0354e73b          	remw	a4,s1,s5
    465c:	00a767b3          	or	a5,a4,a0
    4660:	2781                	sext.w	a5,a5
    4662:	d7a1                	beqz	a5,45aa <concreate+0x1c8>
    4664:	01671363          	bne	a4,s6,466a <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4668:	f129                	bnez	a0,45aa <concreate+0x1c8>
      unlink(file);
    466a:	fa840513          	add	a0,s0,-88
    466e:	00001097          	auipc	ra,0x1
    4672:	d3c080e7          	jalr	-708(ra) # 53aa <unlink>
      unlink(file);
    4676:	fa840513          	add	a0,s0,-88
    467a:	00001097          	auipc	ra,0x1
    467e:	d30080e7          	jalr	-720(ra) # 53aa <unlink>
      unlink(file);
    4682:	fa840513          	add	a0,s0,-88
    4686:	00001097          	auipc	ra,0x1
    468a:	d24080e7          	jalr	-732(ra) # 53aa <unlink>
      unlink(file);
    468e:	fa840513          	add	a0,s0,-88
    4692:	00001097          	auipc	ra,0x1
    4696:	d18080e7          	jalr	-744(ra) # 53aa <unlink>
      unlink(file);
    469a:	fa840513          	add	a0,s0,-88
    469e:	00001097          	auipc	ra,0x1
    46a2:	d0c080e7          	jalr	-756(ra) # 53aa <unlink>
      unlink(file);
    46a6:	fa840513          	add	a0,s0,-88
    46aa:	00001097          	auipc	ra,0x1
    46ae:	d00080e7          	jalr	-768(ra) # 53aa <unlink>
    46b2:	bfb5                	j	462e <concreate+0x24c>
      exit(0);
    46b4:	4501                	li	a0,0
    46b6:	00001097          	auipc	ra,0x1
    46ba:	ca4080e7          	jalr	-860(ra) # 535a <exit>
      close(fd);
    46be:	00001097          	auipc	ra,0x1
    46c2:	cc4080e7          	jalr	-828(ra) # 5382 <close>
    if(pid == 0) {
    46c6:	bb5d                	j	447c <concreate+0x9a>
      close(fd);
    46c8:	00001097          	auipc	ra,0x1
    46cc:	cba080e7          	jalr	-838(ra) # 5382 <close>
      wait(&xstatus);
    46d0:	f6c40513          	add	a0,s0,-148
    46d4:	00001097          	auipc	ra,0x1
    46d8:	c8e080e7          	jalr	-882(ra) # 5362 <wait>
      if(xstatus != 0)
    46dc:	f6c42483          	lw	s1,-148(s0)
    46e0:	da0493e3          	bnez	s1,4486 <concreate+0xa4>
  for(i = 0; i < N; i++){
    46e4:	2905                	addw	s2,s2,1
    46e6:	db4905e3          	beq	s2,s4,4490 <concreate+0xae>
    file[1] = '0' + i;
    46ea:	0309079b          	addw	a5,s2,48
    46ee:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    46f2:	fa840513          	add	a0,s0,-88
    46f6:	00001097          	auipc	ra,0x1
    46fa:	cb4080e7          	jalr	-844(ra) # 53aa <unlink>
    pid = fork();
    46fe:	00001097          	auipc	ra,0x1
    4702:	c54080e7          	jalr	-940(ra) # 5352 <fork>
    if(pid && (i % 3) == 1){
    4706:	d20502e3          	beqz	a0,442a <concreate+0x48>
    470a:	036967bb          	remw	a5,s2,s6
    470e:	d15786e3          	beq	a5,s5,441a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4712:	20200593          	li	a1,514
    4716:	fa840513          	add	a0,s0,-88
    471a:	00001097          	auipc	ra,0x1
    471e:	c80080e7          	jalr	-896(ra) # 539a <open>
      if(fd < 0){
    4722:	fa0553e3          	bgez	a0,46c8 <concreate+0x2e6>
    4726:	b315                	j	444a <concreate+0x68>
}
    4728:	60ea                	ld	ra,152(sp)
    472a:	644a                	ld	s0,144(sp)
    472c:	64aa                	ld	s1,136(sp)
    472e:	690a                	ld	s2,128(sp)
    4730:	79e6                	ld	s3,120(sp)
    4732:	7a46                	ld	s4,112(sp)
    4734:	7aa6                	ld	s5,104(sp)
    4736:	7b06                	ld	s6,96(sp)
    4738:	6be6                	ld	s7,88(sp)
    473a:	610d                	add	sp,sp,160
    473c:	8082                	ret

000000000000473e <bigfile>:
{
    473e:	7139                	add	sp,sp,-64
    4740:	fc06                	sd	ra,56(sp)
    4742:	f822                	sd	s0,48(sp)
    4744:	f426                	sd	s1,40(sp)
    4746:	f04a                	sd	s2,32(sp)
    4748:	ec4e                	sd	s3,24(sp)
    474a:	e852                	sd	s4,16(sp)
    474c:	e456                	sd	s5,8(sp)
    474e:	0080                	add	s0,sp,64
    4750:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4752:	00003517          	auipc	a0,0x3
    4756:	df650513          	add	a0,a0,-522 # 7548 <statistics+0x1ce8>
    475a:	00001097          	auipc	ra,0x1
    475e:	c50080e7          	jalr	-944(ra) # 53aa <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4762:	20200593          	li	a1,514
    4766:	00003517          	auipc	a0,0x3
    476a:	de250513          	add	a0,a0,-542 # 7548 <statistics+0x1ce8>
    476e:	00001097          	auipc	ra,0x1
    4772:	c2c080e7          	jalr	-980(ra) # 539a <open>
    4776:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4778:	4481                	li	s1,0
    memset(buf, i, SZ);
    477a:	00007917          	auipc	s2,0x7
    477e:	08e90913          	add	s2,s2,142 # b808 <buf>
  for(i = 0; i < N; i++){
    4782:	4a51                	li	s4,20
  if(fd < 0){
    4784:	0a054063          	bltz	a0,4824 <bigfile+0xe6>
    memset(buf, i, SZ);
    4788:	25800613          	li	a2,600
    478c:	85a6                	mv	a1,s1
    478e:	854a                	mv	a0,s2
    4790:	00001097          	auipc	ra,0x1
    4794:	9d0080e7          	jalr	-1584(ra) # 5160 <memset>
    if(write(fd, buf, SZ) != SZ){
    4798:	25800613          	li	a2,600
    479c:	85ca                	mv	a1,s2
    479e:	854e                	mv	a0,s3
    47a0:	00001097          	auipc	ra,0x1
    47a4:	bda080e7          	jalr	-1062(ra) # 537a <write>
    47a8:	25800793          	li	a5,600
    47ac:	08f51a63          	bne	a0,a5,4840 <bigfile+0x102>
  for(i = 0; i < N; i++){
    47b0:	2485                	addw	s1,s1,1
    47b2:	fd449be3          	bne	s1,s4,4788 <bigfile+0x4a>
  close(fd);
    47b6:	854e                	mv	a0,s3
    47b8:	00001097          	auipc	ra,0x1
    47bc:	bca080e7          	jalr	-1078(ra) # 5382 <close>
  fd = open("bigfile.dat", 0);
    47c0:	4581                	li	a1,0
    47c2:	00003517          	auipc	a0,0x3
    47c6:	d8650513          	add	a0,a0,-634 # 7548 <statistics+0x1ce8>
    47ca:	00001097          	auipc	ra,0x1
    47ce:	bd0080e7          	jalr	-1072(ra) # 539a <open>
    47d2:	8a2a                	mv	s4,a0
  total = 0;
    47d4:	4981                	li	s3,0
  for(i = 0; ; i++){
    47d6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    47d8:	00007917          	auipc	s2,0x7
    47dc:	03090913          	add	s2,s2,48 # b808 <buf>
  if(fd < 0){
    47e0:	06054e63          	bltz	a0,485c <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    47e4:	12c00613          	li	a2,300
    47e8:	85ca                	mv	a1,s2
    47ea:	8552                	mv	a0,s4
    47ec:	00001097          	auipc	ra,0x1
    47f0:	b86080e7          	jalr	-1146(ra) # 5372 <read>
    if(cc < 0){
    47f4:	08054263          	bltz	a0,4878 <bigfile+0x13a>
    if(cc == 0)
    47f8:	c971                	beqz	a0,48cc <bigfile+0x18e>
    if(cc != SZ/2){
    47fa:	12c00793          	li	a5,300
    47fe:	08f51b63          	bne	a0,a5,4894 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4802:	01f4d79b          	srlw	a5,s1,0x1f
    4806:	9fa5                	addw	a5,a5,s1
    4808:	4017d79b          	sraw	a5,a5,0x1
    480c:	00094703          	lbu	a4,0(s2)
    4810:	0af71063          	bne	a4,a5,48b0 <bigfile+0x172>
    4814:	12b94703          	lbu	a4,299(s2)
    4818:	08f71c63          	bne	a4,a5,48b0 <bigfile+0x172>
    total += cc;
    481c:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4820:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4822:	b7c9                	j	47e4 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4824:	85d6                	mv	a1,s5
    4826:	00003517          	auipc	a0,0x3
    482a:	d3250513          	add	a0,a0,-718 # 7558 <statistics+0x1cf8>
    482e:	00001097          	auipc	ra,0x1
    4832:	e94080e7          	jalr	-364(ra) # 56c2 <printf>
    exit(1);
    4836:	4505                	li	a0,1
    4838:	00001097          	auipc	ra,0x1
    483c:	b22080e7          	jalr	-1246(ra) # 535a <exit>
      printf("%s: write bigfile failed\n", s);
    4840:	85d6                	mv	a1,s5
    4842:	00003517          	auipc	a0,0x3
    4846:	d3650513          	add	a0,a0,-714 # 7578 <statistics+0x1d18>
    484a:	00001097          	auipc	ra,0x1
    484e:	e78080e7          	jalr	-392(ra) # 56c2 <printf>
      exit(1);
    4852:	4505                	li	a0,1
    4854:	00001097          	auipc	ra,0x1
    4858:	b06080e7          	jalr	-1274(ra) # 535a <exit>
    printf("%s: cannot open bigfile\n", s);
    485c:	85d6                	mv	a1,s5
    485e:	00003517          	auipc	a0,0x3
    4862:	d3a50513          	add	a0,a0,-710 # 7598 <statistics+0x1d38>
    4866:	00001097          	auipc	ra,0x1
    486a:	e5c080e7          	jalr	-420(ra) # 56c2 <printf>
    exit(1);
    486e:	4505                	li	a0,1
    4870:	00001097          	auipc	ra,0x1
    4874:	aea080e7          	jalr	-1302(ra) # 535a <exit>
      printf("%s: read bigfile failed\n", s);
    4878:	85d6                	mv	a1,s5
    487a:	00003517          	auipc	a0,0x3
    487e:	d3e50513          	add	a0,a0,-706 # 75b8 <statistics+0x1d58>
    4882:	00001097          	auipc	ra,0x1
    4886:	e40080e7          	jalr	-448(ra) # 56c2 <printf>
      exit(1);
    488a:	4505                	li	a0,1
    488c:	00001097          	auipc	ra,0x1
    4890:	ace080e7          	jalr	-1330(ra) # 535a <exit>
      printf("%s: short read bigfile\n", s);
    4894:	85d6                	mv	a1,s5
    4896:	00003517          	auipc	a0,0x3
    489a:	d4250513          	add	a0,a0,-702 # 75d8 <statistics+0x1d78>
    489e:	00001097          	auipc	ra,0x1
    48a2:	e24080e7          	jalr	-476(ra) # 56c2 <printf>
      exit(1);
    48a6:	4505                	li	a0,1
    48a8:	00001097          	auipc	ra,0x1
    48ac:	ab2080e7          	jalr	-1358(ra) # 535a <exit>
      printf("%s: read bigfile wrong data\n", s);
    48b0:	85d6                	mv	a1,s5
    48b2:	00003517          	auipc	a0,0x3
    48b6:	d3e50513          	add	a0,a0,-706 # 75f0 <statistics+0x1d90>
    48ba:	00001097          	auipc	ra,0x1
    48be:	e08080e7          	jalr	-504(ra) # 56c2 <printf>
      exit(1);
    48c2:	4505                	li	a0,1
    48c4:	00001097          	auipc	ra,0x1
    48c8:	a96080e7          	jalr	-1386(ra) # 535a <exit>
  close(fd);
    48cc:	8552                	mv	a0,s4
    48ce:	00001097          	auipc	ra,0x1
    48d2:	ab4080e7          	jalr	-1356(ra) # 5382 <close>
  if(total != N*SZ){
    48d6:	678d                	lui	a5,0x3
    48d8:	ee078793          	add	a5,a5,-288 # 2ee0 <subdir+0x20a>
    48dc:	02f99363          	bne	s3,a5,4902 <bigfile+0x1c4>
  unlink("bigfile.dat");
    48e0:	00003517          	auipc	a0,0x3
    48e4:	c6850513          	add	a0,a0,-920 # 7548 <statistics+0x1ce8>
    48e8:	00001097          	auipc	ra,0x1
    48ec:	ac2080e7          	jalr	-1342(ra) # 53aa <unlink>
}
    48f0:	70e2                	ld	ra,56(sp)
    48f2:	7442                	ld	s0,48(sp)
    48f4:	74a2                	ld	s1,40(sp)
    48f6:	7902                	ld	s2,32(sp)
    48f8:	69e2                	ld	s3,24(sp)
    48fa:	6a42                	ld	s4,16(sp)
    48fc:	6aa2                	ld	s5,8(sp)
    48fe:	6121                	add	sp,sp,64
    4900:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4902:	85d6                	mv	a1,s5
    4904:	00003517          	auipc	a0,0x3
    4908:	d0c50513          	add	a0,a0,-756 # 7610 <statistics+0x1db0>
    490c:	00001097          	auipc	ra,0x1
    4910:	db6080e7          	jalr	-586(ra) # 56c2 <printf>
    exit(1);
    4914:	4505                	li	a0,1
    4916:	00001097          	auipc	ra,0x1
    491a:	a44080e7          	jalr	-1468(ra) # 535a <exit>

000000000000491e <dirtest>:
{
    491e:	1101                	add	sp,sp,-32
    4920:	ec06                	sd	ra,24(sp)
    4922:	e822                	sd	s0,16(sp)
    4924:	e426                	sd	s1,8(sp)
    4926:	1000                	add	s0,sp,32
    4928:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    492a:	00003517          	auipc	a0,0x3
    492e:	d0650513          	add	a0,a0,-762 # 7630 <statistics+0x1dd0>
    4932:	00001097          	auipc	ra,0x1
    4936:	d90080e7          	jalr	-624(ra) # 56c2 <printf>
  if(mkdir("dir0") < 0){
    493a:	00003517          	auipc	a0,0x3
    493e:	d0650513          	add	a0,a0,-762 # 7640 <statistics+0x1de0>
    4942:	00001097          	auipc	ra,0x1
    4946:	a80080e7          	jalr	-1408(ra) # 53c2 <mkdir>
    494a:	04054d63          	bltz	a0,49a4 <dirtest+0x86>
  if(chdir("dir0") < 0){
    494e:	00003517          	auipc	a0,0x3
    4952:	cf250513          	add	a0,a0,-782 # 7640 <statistics+0x1de0>
    4956:	00001097          	auipc	ra,0x1
    495a:	a74080e7          	jalr	-1420(ra) # 53ca <chdir>
    495e:	06054163          	bltz	a0,49c0 <dirtest+0xa2>
  if(chdir("..") < 0){
    4962:	00002517          	auipc	a0,0x2
    4966:	6fe50513          	add	a0,a0,1790 # 7060 <statistics+0x1800>
    496a:	00001097          	auipc	ra,0x1
    496e:	a60080e7          	jalr	-1440(ra) # 53ca <chdir>
    4972:	06054563          	bltz	a0,49dc <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4976:	00003517          	auipc	a0,0x3
    497a:	cca50513          	add	a0,a0,-822 # 7640 <statistics+0x1de0>
    497e:	00001097          	auipc	ra,0x1
    4982:	a2c080e7          	jalr	-1492(ra) # 53aa <unlink>
    4986:	06054963          	bltz	a0,49f8 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    498a:	00003517          	auipc	a0,0x3
    498e:	d0650513          	add	a0,a0,-762 # 7690 <statistics+0x1e30>
    4992:	00001097          	auipc	ra,0x1
    4996:	d30080e7          	jalr	-720(ra) # 56c2 <printf>
}
    499a:	60e2                	ld	ra,24(sp)
    499c:	6442                	ld	s0,16(sp)
    499e:	64a2                	ld	s1,8(sp)
    49a0:	6105                	add	sp,sp,32
    49a2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49a4:	85a6                	mv	a1,s1
    49a6:	00002517          	auipc	a0,0x2
    49aa:	05a50513          	add	a0,a0,90 # 6a00 <statistics+0x11a0>
    49ae:	00001097          	auipc	ra,0x1
    49b2:	d14080e7          	jalr	-748(ra) # 56c2 <printf>
    exit(1);
    49b6:	4505                	li	a0,1
    49b8:	00001097          	auipc	ra,0x1
    49bc:	9a2080e7          	jalr	-1630(ra) # 535a <exit>
    printf("%s: chdir dir0 failed\n", s);
    49c0:	85a6                	mv	a1,s1
    49c2:	00003517          	auipc	a0,0x3
    49c6:	c8650513          	add	a0,a0,-890 # 7648 <statistics+0x1de8>
    49ca:	00001097          	auipc	ra,0x1
    49ce:	cf8080e7          	jalr	-776(ra) # 56c2 <printf>
    exit(1);
    49d2:	4505                	li	a0,1
    49d4:	00001097          	auipc	ra,0x1
    49d8:	986080e7          	jalr	-1658(ra) # 535a <exit>
    printf("%s: chdir .. failed\n", s);
    49dc:	85a6                	mv	a1,s1
    49de:	00003517          	auipc	a0,0x3
    49e2:	c8250513          	add	a0,a0,-894 # 7660 <statistics+0x1e00>
    49e6:	00001097          	auipc	ra,0x1
    49ea:	cdc080e7          	jalr	-804(ra) # 56c2 <printf>
    exit(1);
    49ee:	4505                	li	a0,1
    49f0:	00001097          	auipc	ra,0x1
    49f4:	96a080e7          	jalr	-1686(ra) # 535a <exit>
    printf("%s: unlink dir0 failed\n", s);
    49f8:	85a6                	mv	a1,s1
    49fa:	00003517          	auipc	a0,0x3
    49fe:	c7e50513          	add	a0,a0,-898 # 7678 <statistics+0x1e18>
    4a02:	00001097          	auipc	ra,0x1
    4a06:	cc0080e7          	jalr	-832(ra) # 56c2 <printf>
    exit(1);
    4a0a:	4505                	li	a0,1
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	94e080e7          	jalr	-1714(ra) # 535a <exit>

0000000000004a14 <fsfull>:
{
    4a14:	7135                	add	sp,sp,-160
    4a16:	ed06                	sd	ra,152(sp)
    4a18:	e922                	sd	s0,144(sp)
    4a1a:	e526                	sd	s1,136(sp)
    4a1c:	e14a                	sd	s2,128(sp)
    4a1e:	fcce                	sd	s3,120(sp)
    4a20:	f8d2                	sd	s4,112(sp)
    4a22:	f4d6                	sd	s5,104(sp)
    4a24:	f0da                	sd	s6,96(sp)
    4a26:	ecde                	sd	s7,88(sp)
    4a28:	e8e2                	sd	s8,80(sp)
    4a2a:	e4e6                	sd	s9,72(sp)
    4a2c:	e0ea                	sd	s10,64(sp)
    4a2e:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    4a30:	00003517          	auipc	a0,0x3
    4a34:	c7850513          	add	a0,a0,-904 # 76a8 <statistics+0x1e48>
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	c8a080e7          	jalr	-886(ra) # 56c2 <printf>
  for(nfiles = 0; ; nfiles++){
    4a40:	4481                	li	s1,0
    name[0] = 'f';
    4a42:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a46:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a4a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a4e:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a50:	00003c97          	auipc	s9,0x3
    4a54:	c68c8c93          	add	s9,s9,-920 # 76b8 <statistics+0x1e58>
    name[0] = 'f';
    4a58:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4a5c:	0384c7bb          	divw	a5,s1,s8
    4a60:	0307879b          	addw	a5,a5,48
    4a64:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a68:	0384e7bb          	remw	a5,s1,s8
    4a6c:	0377c7bb          	divw	a5,a5,s7
    4a70:	0307879b          	addw	a5,a5,48
    4a74:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4a78:	0374e7bb          	remw	a5,s1,s7
    4a7c:	0367c7bb          	divw	a5,a5,s6
    4a80:	0307879b          	addw	a5,a5,48
    4a84:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4a88:	0364e7bb          	remw	a5,s1,s6
    4a8c:	0307879b          	addw	a5,a5,48
    4a90:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4a94:	f60402a3          	sb	zero,-155(s0)
    printf("%s: writing %s\n", name);
    4a98:	f6040593          	add	a1,s0,-160
    4a9c:	8566                	mv	a0,s9
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	c24080e7          	jalr	-988(ra) # 56c2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4aa6:	20200593          	li	a1,514
    4aaa:	f6040513          	add	a0,s0,-160
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	8ec080e7          	jalr	-1812(ra) # 539a <open>
    4ab6:	892a                	mv	s2,a0
    if(fd < 0){
    4ab8:	0a055563          	bgez	a0,4b62 <fsfull+0x14e>
      printf("%s: open %s failed\n", name);
    4abc:	f6040593          	add	a1,s0,-160
    4ac0:	00003517          	auipc	a0,0x3
    4ac4:	c0850513          	add	a0,a0,-1016 # 76c8 <statistics+0x1e68>
    4ac8:	00001097          	auipc	ra,0x1
    4acc:	bfa080e7          	jalr	-1030(ra) # 56c2 <printf>
  while(nfiles >= 0){
    4ad0:	0604c363          	bltz	s1,4b36 <fsfull+0x122>
    name[0] = 'f';
    4ad4:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4ad8:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4adc:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ae0:	4929                	li	s2,10
  while(nfiles >= 0){
    4ae2:	5afd                	li	s5,-1
    name[0] = 'f';
    4ae4:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4ae8:	0344c7bb          	divw	a5,s1,s4
    4aec:	0307879b          	addw	a5,a5,48
    4af0:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4af4:	0344e7bb          	remw	a5,s1,s4
    4af8:	0337c7bb          	divw	a5,a5,s3
    4afc:	0307879b          	addw	a5,a5,48
    4b00:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b04:	0334e7bb          	remw	a5,s1,s3
    4b08:	0327c7bb          	divw	a5,a5,s2
    4b0c:	0307879b          	addw	a5,a5,48
    4b10:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4b14:	0324e7bb          	remw	a5,s1,s2
    4b18:	0307879b          	addw	a5,a5,48
    4b1c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4b20:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4b24:	f6040513          	add	a0,s0,-160
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	882080e7          	jalr	-1918(ra) # 53aa <unlink>
    nfiles--;
    4b30:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    4b32:	fb5499e3          	bne	s1,s5,4ae4 <fsfull+0xd0>
  printf("fsfull test finished\n");
    4b36:	00003517          	auipc	a0,0x3
    4b3a:	bc250513          	add	a0,a0,-1086 # 76f8 <statistics+0x1e98>
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	b84080e7          	jalr	-1148(ra) # 56c2 <printf>
}
    4b46:	60ea                	ld	ra,152(sp)
    4b48:	644a                	ld	s0,144(sp)
    4b4a:	64aa                	ld	s1,136(sp)
    4b4c:	690a                	ld	s2,128(sp)
    4b4e:	79e6                	ld	s3,120(sp)
    4b50:	7a46                	ld	s4,112(sp)
    4b52:	7aa6                	ld	s5,104(sp)
    4b54:	7b06                	ld	s6,96(sp)
    4b56:	6be6                	ld	s7,88(sp)
    4b58:	6c46                	ld	s8,80(sp)
    4b5a:	6ca6                	ld	s9,72(sp)
    4b5c:	6d06                	ld	s10,64(sp)
    4b5e:	610d                	add	sp,sp,160
    4b60:	8082                	ret
    int total = 0;
    4b62:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4b64:	00007a97          	auipc	s5,0x7
    4b68:	ca4a8a93          	add	s5,s5,-860 # b808 <buf>
      if(cc < BSIZE)
    4b6c:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4b70:	40000613          	li	a2,1024
    4b74:	85d6                	mv	a1,s5
    4b76:	854a                	mv	a0,s2
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	802080e7          	jalr	-2046(ra) # 537a <write>
      if(cc < BSIZE)
    4b80:	00aa5563          	bge	s4,a0,4b8a <fsfull+0x176>
      total += cc;
    4b84:	00a989bb          	addw	s3,s3,a0
    while(1){
    4b88:	b7e5                	j	4b70 <fsfull+0x15c>
    printf("%s: wrote %d bytes\n", total);
    4b8a:	85ce                	mv	a1,s3
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	b5450513          	add	a0,a0,-1196 # 76e0 <statistics+0x1e80>
    4b94:	00001097          	auipc	ra,0x1
    4b98:	b2e080e7          	jalr	-1234(ra) # 56c2 <printf>
    close(fd);
    4b9c:	854a                	mv	a0,s2
    4b9e:	00000097          	auipc	ra,0x0
    4ba2:	7e4080e7          	jalr	2020(ra) # 5382 <close>
    if(total == 0)
    4ba6:	f20985e3          	beqz	s3,4ad0 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    4baa:	2485                	addw	s1,s1,1
    4bac:	b575                	j	4a58 <fsfull+0x44>

0000000000004bae <rand>:
{
    4bae:	1141                	add	sp,sp,-16
    4bb0:	e422                	sd	s0,8(sp)
    4bb2:	0800                	add	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bb4:	00003717          	auipc	a4,0x3
    4bb8:	42470713          	add	a4,a4,1060 # 7fd8 <randstate>
    4bbc:	6308                	ld	a0,0(a4)
    4bbe:	001967b7          	lui	a5,0x196
    4bc2:	60d78793          	add	a5,a5,1549 # 19660d <__BSS_END__+0x187df5>
    4bc6:	02f50533          	mul	a0,a0,a5
    4bca:	3c6ef7b7          	lui	a5,0x3c6ef
    4bce:	35f78793          	add	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0b47>
    4bd2:	953e                	add	a0,a0,a5
    4bd4:	e308                	sd	a0,0(a4)
}
    4bd6:	2501                	sext.w	a0,a0
    4bd8:	6422                	ld	s0,8(sp)
    4bda:	0141                	add	sp,sp,16
    4bdc:	8082                	ret

0000000000004bde <badwrite>:
{
    4bde:	7179                	add	sp,sp,-48
    4be0:	f406                	sd	ra,40(sp)
    4be2:	f022                	sd	s0,32(sp)
    4be4:	ec26                	sd	s1,24(sp)
    4be6:	e84a                	sd	s2,16(sp)
    4be8:	e44e                	sd	s3,8(sp)
    4bea:	e052                	sd	s4,0(sp)
    4bec:	1800                	add	s0,sp,48
  unlink("junk");
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	b2250513          	add	a0,a0,-1246 # 7710 <statistics+0x1eb0>
    4bf6:	00000097          	auipc	ra,0x0
    4bfa:	7b4080e7          	jalr	1972(ra) # 53aa <unlink>
    4bfe:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c02:	00003997          	auipc	s3,0x3
    4c06:	b0e98993          	add	s3,s3,-1266 # 7710 <statistics+0x1eb0>
    write(fd, (char*)0xffffffffffL, 1);
    4c0a:	5a7d                	li	s4,-1
    4c0c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c10:	20100593          	li	a1,513
    4c14:	854e                	mv	a0,s3
    4c16:	00000097          	auipc	ra,0x0
    4c1a:	784080e7          	jalr	1924(ra) # 539a <open>
    4c1e:	84aa                	mv	s1,a0
    if(fd < 0){
    4c20:	06054b63          	bltz	a0,4c96 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c24:	4605                	li	a2,1
    4c26:	85d2                	mv	a1,s4
    4c28:	00000097          	auipc	ra,0x0
    4c2c:	752080e7          	jalr	1874(ra) # 537a <write>
    close(fd);
    4c30:	8526                	mv	a0,s1
    4c32:	00000097          	auipc	ra,0x0
    4c36:	750080e7          	jalr	1872(ra) # 5382 <close>
    unlink("junk");
    4c3a:	854e                	mv	a0,s3
    4c3c:	00000097          	auipc	ra,0x0
    4c40:	76e080e7          	jalr	1902(ra) # 53aa <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c44:	397d                	addw	s2,s2,-1
    4c46:	fc0915e3          	bnez	s2,4c10 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c4a:	20100593          	li	a1,513
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	ac250513          	add	a0,a0,-1342 # 7710 <statistics+0x1eb0>
    4c56:	00000097          	auipc	ra,0x0
    4c5a:	744080e7          	jalr	1860(ra) # 539a <open>
    4c5e:	84aa                	mv	s1,a0
  if(fd < 0){
    4c60:	04054863          	bltz	a0,4cb0 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c64:	4605                	li	a2,1
    4c66:	00001597          	auipc	a1,0x1
    4c6a:	d2a58593          	add	a1,a1,-726 # 5990 <statistics+0x130>
    4c6e:	00000097          	auipc	ra,0x0
    4c72:	70c080e7          	jalr	1804(ra) # 537a <write>
    4c76:	4785                	li	a5,1
    4c78:	04f50963          	beq	a0,a5,4cca <badwrite+0xec>
    printf("write failed\n");
    4c7c:	00003517          	auipc	a0,0x3
    4c80:	ab450513          	add	a0,a0,-1356 # 7730 <statistics+0x1ed0>
    4c84:	00001097          	auipc	ra,0x1
    4c88:	a3e080e7          	jalr	-1474(ra) # 56c2 <printf>
    exit(1);
    4c8c:	4505                	li	a0,1
    4c8e:	00000097          	auipc	ra,0x0
    4c92:	6cc080e7          	jalr	1740(ra) # 535a <exit>
      printf("open junk failed\n");
    4c96:	00003517          	auipc	a0,0x3
    4c9a:	a8250513          	add	a0,a0,-1406 # 7718 <statistics+0x1eb8>
    4c9e:	00001097          	auipc	ra,0x1
    4ca2:	a24080e7          	jalr	-1500(ra) # 56c2 <printf>
      exit(1);
    4ca6:	4505                	li	a0,1
    4ca8:	00000097          	auipc	ra,0x0
    4cac:	6b2080e7          	jalr	1714(ra) # 535a <exit>
    printf("open junk failed\n");
    4cb0:	00003517          	auipc	a0,0x3
    4cb4:	a6850513          	add	a0,a0,-1432 # 7718 <statistics+0x1eb8>
    4cb8:	00001097          	auipc	ra,0x1
    4cbc:	a0a080e7          	jalr	-1526(ra) # 56c2 <printf>
    exit(1);
    4cc0:	4505                	li	a0,1
    4cc2:	00000097          	auipc	ra,0x0
    4cc6:	698080e7          	jalr	1688(ra) # 535a <exit>
  close(fd);
    4cca:	8526                	mv	a0,s1
    4ccc:	00000097          	auipc	ra,0x0
    4cd0:	6b6080e7          	jalr	1718(ra) # 5382 <close>
  unlink("junk");
    4cd4:	00003517          	auipc	a0,0x3
    4cd8:	a3c50513          	add	a0,a0,-1476 # 7710 <statistics+0x1eb0>
    4cdc:	00000097          	auipc	ra,0x0
    4ce0:	6ce080e7          	jalr	1742(ra) # 53aa <unlink>
  exit(0);
    4ce4:	4501                	li	a0,0
    4ce6:	00000097          	auipc	ra,0x0
    4cea:	674080e7          	jalr	1652(ra) # 535a <exit>

0000000000004cee <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4cee:	7139                	add	sp,sp,-64
    4cf0:	fc06                	sd	ra,56(sp)
    4cf2:	f822                	sd	s0,48(sp)
    4cf4:	f426                	sd	s1,40(sp)
    4cf6:	f04a                	sd	s2,32(sp)
    4cf8:	ec4e                	sd	s3,24(sp)
    4cfa:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4cfc:	fc840513          	add	a0,s0,-56
    4d00:	00000097          	auipc	ra,0x0
    4d04:	66a080e7          	jalr	1642(ra) # 536a <pipe>
    4d08:	06054763          	bltz	a0,4d76 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d0c:	00000097          	auipc	ra,0x0
    4d10:	646080e7          	jalr	1606(ra) # 5352 <fork>

  if(pid < 0){
    4d14:	06054e63          	bltz	a0,4d90 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d18:	ed51                	bnez	a0,4db4 <countfree+0xc6>
    close(fds[0]);
    4d1a:	fc842503          	lw	a0,-56(s0)
    4d1e:	00000097          	auipc	ra,0x0
    4d22:	664080e7          	jalr	1636(ra) # 5382 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d26:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d28:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d2a:	00001997          	auipc	s3,0x1
    4d2e:	c6698993          	add	s3,s3,-922 # 5990 <statistics+0x130>
      uint64 a = (uint64) sbrk(4096);
    4d32:	6505                	lui	a0,0x1
    4d34:	00000097          	auipc	ra,0x0
    4d38:	6ae080e7          	jalr	1710(ra) # 53e2 <sbrk>
      if(a == 0xffffffffffffffff){
    4d3c:	07250763          	beq	a0,s2,4daa <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4d40:	6785                	lui	a5,0x1
    4d42:	97aa                	add	a5,a5,a0
    4d44:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x97>
      if(write(fds[1], "x", 1) != 1){
    4d48:	8626                	mv	a2,s1
    4d4a:	85ce                	mv	a1,s3
    4d4c:	fcc42503          	lw	a0,-52(s0)
    4d50:	00000097          	auipc	ra,0x0
    4d54:	62a080e7          	jalr	1578(ra) # 537a <write>
    4d58:	fc950de3          	beq	a0,s1,4d32 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4d5c:	00003517          	auipc	a0,0x3
    4d60:	a2450513          	add	a0,a0,-1500 # 7780 <statistics+0x1f20>
    4d64:	00001097          	auipc	ra,0x1
    4d68:	95e080e7          	jalr	-1698(ra) # 56c2 <printf>
        exit(1);
    4d6c:	4505                	li	a0,1
    4d6e:	00000097          	auipc	ra,0x0
    4d72:	5ec080e7          	jalr	1516(ra) # 535a <exit>
    printf("pipe() failed in countfree()\n");
    4d76:	00003517          	auipc	a0,0x3
    4d7a:	9ca50513          	add	a0,a0,-1590 # 7740 <statistics+0x1ee0>
    4d7e:	00001097          	auipc	ra,0x1
    4d82:	944080e7          	jalr	-1724(ra) # 56c2 <printf>
    exit(1);
    4d86:	4505                	li	a0,1
    4d88:	00000097          	auipc	ra,0x0
    4d8c:	5d2080e7          	jalr	1490(ra) # 535a <exit>
    printf("fork failed in countfree()\n");
    4d90:	00003517          	auipc	a0,0x3
    4d94:	9d050513          	add	a0,a0,-1584 # 7760 <statistics+0x1f00>
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	92a080e7          	jalr	-1750(ra) # 56c2 <printf>
    exit(1);
    4da0:	4505                	li	a0,1
    4da2:	00000097          	auipc	ra,0x0
    4da6:	5b8080e7          	jalr	1464(ra) # 535a <exit>
      }
    }

    exit(0);
    4daa:	4501                	li	a0,0
    4dac:	00000097          	auipc	ra,0x0
    4db0:	5ae080e7          	jalr	1454(ra) # 535a <exit>
  }

  close(fds[1]);
    4db4:	fcc42503          	lw	a0,-52(s0)
    4db8:	00000097          	auipc	ra,0x0
    4dbc:	5ca080e7          	jalr	1482(ra) # 5382 <close>

  int n = 0;
    4dc0:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4dc2:	4605                	li	a2,1
    4dc4:	fc740593          	add	a1,s0,-57
    4dc8:	fc842503          	lw	a0,-56(s0)
    4dcc:	00000097          	auipc	ra,0x0
    4dd0:	5a6080e7          	jalr	1446(ra) # 5372 <read>
    if(cc < 0){
    4dd4:	00054563          	bltz	a0,4dde <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4dd8:	c105                	beqz	a0,4df8 <countfree+0x10a>
      break;
    n += 1;
    4dda:	2485                	addw	s1,s1,1
  while(1){
    4ddc:	b7dd                	j	4dc2 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4dde:	00003517          	auipc	a0,0x3
    4de2:	9c250513          	add	a0,a0,-1598 # 77a0 <statistics+0x1f40>
    4de6:	00001097          	auipc	ra,0x1
    4dea:	8dc080e7          	jalr	-1828(ra) # 56c2 <printf>
      exit(1);
    4dee:	4505                	li	a0,1
    4df0:	00000097          	auipc	ra,0x0
    4df4:	56a080e7          	jalr	1386(ra) # 535a <exit>
  }

  close(fds[0]);
    4df8:	fc842503          	lw	a0,-56(s0)
    4dfc:	00000097          	auipc	ra,0x0
    4e00:	586080e7          	jalr	1414(ra) # 5382 <close>
  wait((int*)0);
    4e04:	4501                	li	a0,0
    4e06:	00000097          	auipc	ra,0x0
    4e0a:	55c080e7          	jalr	1372(ra) # 5362 <wait>
  
  return n;
}
    4e0e:	8526                	mv	a0,s1
    4e10:	70e2                	ld	ra,56(sp)
    4e12:	7442                	ld	s0,48(sp)
    4e14:	74a2                	ld	s1,40(sp)
    4e16:	7902                	ld	s2,32(sp)
    4e18:	69e2                	ld	s3,24(sp)
    4e1a:	6121                	add	sp,sp,64
    4e1c:	8082                	ret

0000000000004e1e <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e1e:	7179                	add	sp,sp,-48
    4e20:	f406                	sd	ra,40(sp)
    4e22:	f022                	sd	s0,32(sp)
    4e24:	ec26                	sd	s1,24(sp)
    4e26:	e84a                	sd	s2,16(sp)
    4e28:	1800                	add	s0,sp,48
    4e2a:	84aa                	mv	s1,a0
    4e2c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	99250513          	add	a0,a0,-1646 # 77c0 <statistics+0x1f60>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	88c080e7          	jalr	-1908(ra) # 56c2 <printf>
  if((pid = fork()) < 0) {
    4e3e:	00000097          	auipc	ra,0x0
    4e42:	514080e7          	jalr	1300(ra) # 5352 <fork>
    4e46:	02054e63          	bltz	a0,4e82 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e4a:	c929                	beqz	a0,4e9c <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e4c:	fdc40513          	add	a0,s0,-36
    4e50:	00000097          	auipc	ra,0x0
    4e54:	512080e7          	jalr	1298(ra) # 5362 <wait>
    if(xstatus != 0) 
    4e58:	fdc42783          	lw	a5,-36(s0)
    4e5c:	c7b9                	beqz	a5,4eaa <run+0x8c>
      printf("FAILED\n");
    4e5e:	00003517          	auipc	a0,0x3
    4e62:	98a50513          	add	a0,a0,-1654 # 77e8 <statistics+0x1f88>
    4e66:	00001097          	auipc	ra,0x1
    4e6a:	85c080e7          	jalr	-1956(ra) # 56c2 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4e6e:	fdc42503          	lw	a0,-36(s0)
  }
}
    4e72:	00153513          	seqz	a0,a0
    4e76:	70a2                	ld	ra,40(sp)
    4e78:	7402                	ld	s0,32(sp)
    4e7a:	64e2                	ld	s1,24(sp)
    4e7c:	6942                	ld	s2,16(sp)
    4e7e:	6145                	add	sp,sp,48
    4e80:	8082                	ret
    printf("runtest: fork error\n");
    4e82:	00003517          	auipc	a0,0x3
    4e86:	94e50513          	add	a0,a0,-1714 # 77d0 <statistics+0x1f70>
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	838080e7          	jalr	-1992(ra) # 56c2 <printf>
    exit(1);
    4e92:	4505                	li	a0,1
    4e94:	00000097          	auipc	ra,0x0
    4e98:	4c6080e7          	jalr	1222(ra) # 535a <exit>
    f(s);
    4e9c:	854a                	mv	a0,s2
    4e9e:	9482                	jalr	s1
    exit(0);
    4ea0:	4501                	li	a0,0
    4ea2:	00000097          	auipc	ra,0x0
    4ea6:	4b8080e7          	jalr	1208(ra) # 535a <exit>
      printf("OK\n");
    4eaa:	00003517          	auipc	a0,0x3
    4eae:	94650513          	add	a0,a0,-1722 # 77f0 <statistics+0x1f90>
    4eb2:	00001097          	auipc	ra,0x1
    4eb6:	810080e7          	jalr	-2032(ra) # 56c2 <printf>
    4eba:	bf55                	j	4e6e <run+0x50>

0000000000004ebc <main>:

int
main(int argc, char *argv[])
{
    4ebc:	c4010113          	add	sp,sp,-960
    4ec0:	3a113c23          	sd	ra,952(sp)
    4ec4:	3a813823          	sd	s0,944(sp)
    4ec8:	3a913423          	sd	s1,936(sp)
    4ecc:	3b213023          	sd	s2,928(sp)
    4ed0:	39313c23          	sd	s3,920(sp)
    4ed4:	39413823          	sd	s4,912(sp)
    4ed8:	39513423          	sd	s5,904(sp)
    4edc:	39613023          	sd	s6,896(sp)
    4ee0:	0780                	add	s0,sp,960
    4ee2:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4ee4:	4789                	li	a5,2
    4ee6:	08f50863          	beq	a0,a5,4f76 <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4eea:	4785                	li	a5,1
    4eec:	10a7cd63          	blt	a5,a0,5006 <main+0x14a>
  char *justone = 0;
    4ef0:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4ef2:	00003797          	auipc	a5,0x3
    4ef6:	cbe78793          	add	a5,a5,-834 # 7bb0 <statistics+0x2350>
    4efa:	c4040713          	add	a4,s0,-960
    4efe:	00003817          	auipc	a6,0x3
    4f02:	03280813          	add	a6,a6,50 # 7f30 <statistics+0x26d0>
    4f06:	6388                	ld	a0,0(a5)
    4f08:	678c                	ld	a1,8(a5)
    4f0a:	6b90                	ld	a2,16(a5)
    4f0c:	6f94                	ld	a3,24(a5)
    4f0e:	e308                	sd	a0,0(a4)
    4f10:	e70c                	sd	a1,8(a4)
    4f12:	eb10                	sd	a2,16(a4)
    4f14:	ef14                	sd	a3,24(a4)
    4f16:	02078793          	add	a5,a5,32
    4f1a:	02070713          	add	a4,a4,32
    4f1e:	ff0794e3          	bne	a5,a6,4f06 <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f22:	00003517          	auipc	a0,0x3
    4f26:	98e50513          	add	a0,a0,-1650 # 78b0 <statistics+0x2050>
    4f2a:	00000097          	auipc	ra,0x0
    4f2e:	798080e7          	jalr	1944(ra) # 56c2 <printf>
  int free0 = countfree();
    4f32:	00000097          	auipc	ra,0x0
    4f36:	dbc080e7          	jalr	-580(ra) # 4cee <countfree>
    4f3a:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f3c:	c4843903          	ld	s2,-952(s0)
    4f40:	c4040493          	add	s1,s0,-960
  int fail = 0;
    4f44:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f46:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f48:	10091463          	bnez	s2,5050 <main+0x194>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f4c:	00000097          	auipc	ra,0x0
    4f50:	da2080e7          	jalr	-606(ra) # 4cee <countfree>
    4f54:	85aa                	mv	a1,a0
    4f56:	13555e63          	bge	a0,s5,5092 <main+0x1d6>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f5a:	8656                	mv	a2,s5
    4f5c:	00003517          	auipc	a0,0x3
    4f60:	90c50513          	add	a0,a0,-1780 # 7868 <statistics+0x2008>
    4f64:	00000097          	auipc	ra,0x0
    4f68:	75e080e7          	jalr	1886(ra) # 56c2 <printf>
    exit(1);
    4f6c:	4505                	li	a0,1
    4f6e:	00000097          	auipc	ra,0x0
    4f72:	3ec080e7          	jalr	1004(ra) # 535a <exit>
    4f76:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f78:	00003597          	auipc	a1,0x3
    4f7c:	88058593          	add	a1,a1,-1920 # 77f8 <statistics+0x1f98>
    4f80:	6488                	ld	a0,8(s1)
    4f82:	00000097          	auipc	ra,0x0
    4f86:	188080e7          	jalr	392(ra) # 510a <strcmp>
    4f8a:	ed21                	bnez	a0,4fe2 <main+0x126>
    continuous = 1;
    4f8c:	4985                	li	s3,1
  } tests[] = {
    4f8e:	00003797          	auipc	a5,0x3
    4f92:	c2278793          	add	a5,a5,-990 # 7bb0 <statistics+0x2350>
    4f96:	c4040713          	add	a4,s0,-960
    4f9a:	00003817          	auipc	a6,0x3
    4f9e:	f9680813          	add	a6,a6,-106 # 7f30 <statistics+0x26d0>
    4fa2:	6388                	ld	a0,0(a5)
    4fa4:	678c                	ld	a1,8(a5)
    4fa6:	6b90                	ld	a2,16(a5)
    4fa8:	6f94                	ld	a3,24(a5)
    4faa:	e308                	sd	a0,0(a4)
    4fac:	e70c                	sd	a1,8(a4)
    4fae:	eb10                	sd	a2,16(a4)
    4fb0:	ef14                	sd	a3,24(a4)
    4fb2:	02078793          	add	a5,a5,32
    4fb6:	02070713          	add	a4,a4,32
    4fba:	ff0794e3          	bne	a5,a6,4fa2 <main+0xe6>
    printf("continuous usertests starting\n");
    4fbe:	00003517          	auipc	a0,0x3
    4fc2:	90a50513          	add	a0,a0,-1782 # 78c8 <statistics+0x2068>
    4fc6:	00000097          	auipc	ra,0x0
    4fca:	6fc080e7          	jalr	1788(ra) # 56c2 <printf>
        printf("SOME TESTS FAILED\n");
    4fce:	00003a97          	auipc	s5,0x3
    4fd2:	882a8a93          	add	s5,s5,-1918 # 7850 <statistics+0x1ff0>
        if(continuous != 2)
    4fd6:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    4fd8:	00003b17          	auipc	s6,0x3
    4fdc:	858b0b13          	add	s6,s6,-1960 # 7830 <statistics+0x1fd0>
    4fe0:	a0dd                	j	50c6 <main+0x20a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fe2:	00003597          	auipc	a1,0x3
    4fe6:	81e58593          	add	a1,a1,-2018 # 7800 <statistics+0x1fa0>
    4fea:	6488                	ld	a0,8(s1)
    4fec:	00000097          	auipc	ra,0x0
    4ff0:	11e080e7          	jalr	286(ra) # 510a <strcmp>
    4ff4:	dd49                	beqz	a0,4f8e <main+0xd2>
  } else if(argc == 2 && argv[1][0] != '-'){
    4ff6:	0084b983          	ld	s3,8(s1)
    4ffa:	0009c703          	lbu	a4,0(s3)
    4ffe:	02d00793          	li	a5,45
    5002:	eef718e3          	bne	a4,a5,4ef2 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5006:	00003517          	auipc	a0,0x3
    500a:	80250513          	add	a0,a0,-2046 # 7808 <statistics+0x1fa8>
    500e:	00000097          	auipc	ra,0x0
    5012:	6b4080e7          	jalr	1716(ra) # 56c2 <printf>
    exit(1);
    5016:	4505                	li	a0,1
    5018:	00000097          	auipc	ra,0x0
    501c:	342080e7          	jalr	834(ra) # 535a <exit>
          exit(1);
    5020:	4505                	li	a0,1
    5022:	00000097          	auipc	ra,0x0
    5026:	338080e7          	jalr	824(ra) # 535a <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    502a:	40a905bb          	subw	a1,s2,a0
    502e:	855a                	mv	a0,s6
    5030:	00000097          	auipc	ra,0x0
    5034:	692080e7          	jalr	1682(ra) # 56c2 <printf>
        if(continuous != 2)
    5038:	09498763          	beq	s3,s4,50c6 <main+0x20a>
          exit(1);
    503c:	4505                	li	a0,1
    503e:	00000097          	auipc	ra,0x0
    5042:	31c080e7          	jalr	796(ra) # 535a <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5046:	04c1                	add	s1,s1,16
    5048:	0084b903          	ld	s2,8(s1)
    504c:	02090463          	beqz	s2,5074 <main+0x1b8>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5050:	00098963          	beqz	s3,5062 <main+0x1a6>
    5054:	85ce                	mv	a1,s3
    5056:	854a                	mv	a0,s2
    5058:	00000097          	auipc	ra,0x0
    505c:	0b2080e7          	jalr	178(ra) # 510a <strcmp>
    5060:	f17d                	bnez	a0,5046 <main+0x18a>
      if(!run(t->f, t->s))
    5062:	85ca                	mv	a1,s2
    5064:	6088                	ld	a0,0(s1)
    5066:	00000097          	auipc	ra,0x0
    506a:	db8080e7          	jalr	-584(ra) # 4e1e <run>
    506e:	fd61                	bnez	a0,5046 <main+0x18a>
        fail = 1;
    5070:	8a5a                	mv	s4,s6
    5072:	bfd1                	j	5046 <main+0x18a>
  if(fail){
    5074:	ec0a0ce3          	beqz	s4,4f4c <main+0x90>
    printf("SOME TESTS FAILED\n");
    5078:	00002517          	auipc	a0,0x2
    507c:	7d850513          	add	a0,a0,2008 # 7850 <statistics+0x1ff0>
    5080:	00000097          	auipc	ra,0x0
    5084:	642080e7          	jalr	1602(ra) # 56c2 <printf>
    exit(1);
    5088:	4505                	li	a0,1
    508a:	00000097          	auipc	ra,0x0
    508e:	2d0080e7          	jalr	720(ra) # 535a <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5092:	00003517          	auipc	a0,0x3
    5096:	80650513          	add	a0,a0,-2042 # 7898 <statistics+0x2038>
    509a:	00000097          	auipc	ra,0x0
    509e:	628080e7          	jalr	1576(ra) # 56c2 <printf>
    exit(0);
    50a2:	4501                	li	a0,0
    50a4:	00000097          	auipc	ra,0x0
    50a8:	2b6080e7          	jalr	694(ra) # 535a <exit>
        printf("SOME TESTS FAILED\n");
    50ac:	8556                	mv	a0,s5
    50ae:	00000097          	auipc	ra,0x0
    50b2:	614080e7          	jalr	1556(ra) # 56c2 <printf>
        if(continuous != 2)
    50b6:	f74995e3          	bne	s3,s4,5020 <main+0x164>
      int free1 = countfree();
    50ba:	00000097          	auipc	ra,0x0
    50be:	c34080e7          	jalr	-972(ra) # 4cee <countfree>
      if(free1 < free0){
    50c2:	f72544e3          	blt	a0,s2,502a <main+0x16e>
      int free0 = countfree();
    50c6:	00000097          	auipc	ra,0x0
    50ca:	c28080e7          	jalr	-984(ra) # 4cee <countfree>
    50ce:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    50d0:	c4843583          	ld	a1,-952(s0)
    50d4:	d1fd                	beqz	a1,50ba <main+0x1fe>
    50d6:	c4040493          	add	s1,s0,-960
        if(!run(t->f, t->s)){
    50da:	6088                	ld	a0,0(s1)
    50dc:	00000097          	auipc	ra,0x0
    50e0:	d42080e7          	jalr	-702(ra) # 4e1e <run>
    50e4:	d561                	beqz	a0,50ac <main+0x1f0>
      for (struct test *t = tests; t->s != 0; t++) {
    50e6:	04c1                	add	s1,s1,16
    50e8:	648c                	ld	a1,8(s1)
    50ea:	f9e5                	bnez	a1,50da <main+0x21e>
    50ec:	b7f9                	j	50ba <main+0x1fe>

00000000000050ee <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    50ee:	1141                	add	sp,sp,-16
    50f0:	e422                	sd	s0,8(sp)
    50f2:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    50f4:	87aa                	mv	a5,a0
    50f6:	0585                	add	a1,a1,1
    50f8:	0785                	add	a5,a5,1
    50fa:	fff5c703          	lbu	a4,-1(a1)
    50fe:	fee78fa3          	sb	a4,-1(a5)
    5102:	fb75                	bnez	a4,50f6 <strcpy+0x8>
    ;
  return os;
}
    5104:	6422                	ld	s0,8(sp)
    5106:	0141                	add	sp,sp,16
    5108:	8082                	ret

000000000000510a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    510a:	1141                	add	sp,sp,-16
    510c:	e422                	sd	s0,8(sp)
    510e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5110:	00054783          	lbu	a5,0(a0)
    5114:	cb91                	beqz	a5,5128 <strcmp+0x1e>
    5116:	0005c703          	lbu	a4,0(a1)
    511a:	00f71763          	bne	a4,a5,5128 <strcmp+0x1e>
    p++, q++;
    511e:	0505                	add	a0,a0,1
    5120:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5122:	00054783          	lbu	a5,0(a0)
    5126:	fbe5                	bnez	a5,5116 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5128:	0005c503          	lbu	a0,0(a1)
}
    512c:	40a7853b          	subw	a0,a5,a0
    5130:	6422                	ld	s0,8(sp)
    5132:	0141                	add	sp,sp,16
    5134:	8082                	ret

0000000000005136 <strlen>:

uint
strlen(const char *s)
{
    5136:	1141                	add	sp,sp,-16
    5138:	e422                	sd	s0,8(sp)
    513a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    513c:	00054783          	lbu	a5,0(a0)
    5140:	cf91                	beqz	a5,515c <strlen+0x26>
    5142:	0505                	add	a0,a0,1
    5144:	87aa                	mv	a5,a0
    5146:	86be                	mv	a3,a5
    5148:	0785                	add	a5,a5,1
    514a:	fff7c703          	lbu	a4,-1(a5)
    514e:	ff65                	bnez	a4,5146 <strlen+0x10>
    5150:	40a6853b          	subw	a0,a3,a0
    5154:	2505                	addw	a0,a0,1
    ;
  return n;
}
    5156:	6422                	ld	s0,8(sp)
    5158:	0141                	add	sp,sp,16
    515a:	8082                	ret
  for(n = 0; s[n]; n++)
    515c:	4501                	li	a0,0
    515e:	bfe5                	j	5156 <strlen+0x20>

0000000000005160 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5160:	1141                	add	sp,sp,-16
    5162:	e422                	sd	s0,8(sp)
    5164:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5166:	ca19                	beqz	a2,517c <memset+0x1c>
    5168:	87aa                	mv	a5,a0
    516a:	1602                	sll	a2,a2,0x20
    516c:	9201                	srl	a2,a2,0x20
    516e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5176:	0785                	add	a5,a5,1
    5178:	fee79de3          	bne	a5,a4,5172 <memset+0x12>
  }
  return dst;
}
    517c:	6422                	ld	s0,8(sp)
    517e:	0141                	add	sp,sp,16
    5180:	8082                	ret

0000000000005182 <strchr>:

char*
strchr(const char *s, char c)
{
    5182:	1141                	add	sp,sp,-16
    5184:	e422                	sd	s0,8(sp)
    5186:	0800                	add	s0,sp,16
  for(; *s; s++)
    5188:	00054783          	lbu	a5,0(a0)
    518c:	cb99                	beqz	a5,51a2 <strchr+0x20>
    if(*s == c)
    518e:	00f58763          	beq	a1,a5,519c <strchr+0x1a>
  for(; *s; s++)
    5192:	0505                	add	a0,a0,1
    5194:	00054783          	lbu	a5,0(a0)
    5198:	fbfd                	bnez	a5,518e <strchr+0xc>
      return (char*)s;
  return 0;
    519a:	4501                	li	a0,0
}
    519c:	6422                	ld	s0,8(sp)
    519e:	0141                	add	sp,sp,16
    51a0:	8082                	ret
  return 0;
    51a2:	4501                	li	a0,0
    51a4:	bfe5                	j	519c <strchr+0x1a>

00000000000051a6 <gets>:

char*
gets(char *buf, int max)
{
    51a6:	711d                	add	sp,sp,-96
    51a8:	ec86                	sd	ra,88(sp)
    51aa:	e8a2                	sd	s0,80(sp)
    51ac:	e4a6                	sd	s1,72(sp)
    51ae:	e0ca                	sd	s2,64(sp)
    51b0:	fc4e                	sd	s3,56(sp)
    51b2:	f852                	sd	s4,48(sp)
    51b4:	f456                	sd	s5,40(sp)
    51b6:	f05a                	sd	s6,32(sp)
    51b8:	ec5e                	sd	s7,24(sp)
    51ba:	1080                	add	s0,sp,96
    51bc:	8baa                	mv	s7,a0
    51be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    51c0:	892a                	mv	s2,a0
    51c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    51c4:	4aa9                	li	s5,10
    51c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    51c8:	89a6                	mv	s3,s1
    51ca:	2485                	addw	s1,s1,1
    51cc:	0344d863          	bge	s1,s4,51fc <gets+0x56>
    cc = read(0, &c, 1);
    51d0:	4605                	li	a2,1
    51d2:	faf40593          	add	a1,s0,-81
    51d6:	4501                	li	a0,0
    51d8:	00000097          	auipc	ra,0x0
    51dc:	19a080e7          	jalr	410(ra) # 5372 <read>
    if(cc < 1)
    51e0:	00a05e63          	blez	a0,51fc <gets+0x56>
    buf[i++] = c;
    51e4:	faf44783          	lbu	a5,-81(s0)
    51e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    51ec:	01578763          	beq	a5,s5,51fa <gets+0x54>
    51f0:	0905                	add	s2,s2,1
    51f2:	fd679be3          	bne	a5,s6,51c8 <gets+0x22>
  for(i=0; i+1 < max; ){
    51f6:	89a6                	mv	s3,s1
    51f8:	a011                	j	51fc <gets+0x56>
    51fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    51fc:	99de                	add	s3,s3,s7
    51fe:	00098023          	sb	zero,0(s3)
  return buf;
}
    5202:	855e                	mv	a0,s7
    5204:	60e6                	ld	ra,88(sp)
    5206:	6446                	ld	s0,80(sp)
    5208:	64a6                	ld	s1,72(sp)
    520a:	6906                	ld	s2,64(sp)
    520c:	79e2                	ld	s3,56(sp)
    520e:	7a42                	ld	s4,48(sp)
    5210:	7aa2                	ld	s5,40(sp)
    5212:	7b02                	ld	s6,32(sp)
    5214:	6be2                	ld	s7,24(sp)
    5216:	6125                	add	sp,sp,96
    5218:	8082                	ret

000000000000521a <stat>:

int
stat(const char *n, struct stat *st)
{
    521a:	1101                	add	sp,sp,-32
    521c:	ec06                	sd	ra,24(sp)
    521e:	e822                	sd	s0,16(sp)
    5220:	e426                	sd	s1,8(sp)
    5222:	e04a                	sd	s2,0(sp)
    5224:	1000                	add	s0,sp,32
    5226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5228:	4581                	li	a1,0
    522a:	00000097          	auipc	ra,0x0
    522e:	170080e7          	jalr	368(ra) # 539a <open>
  if(fd < 0)
    5232:	02054563          	bltz	a0,525c <stat+0x42>
    5236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5238:	85ca                	mv	a1,s2
    523a:	00000097          	auipc	ra,0x0
    523e:	178080e7          	jalr	376(ra) # 53b2 <fstat>
    5242:	892a                	mv	s2,a0
  close(fd);
    5244:	8526                	mv	a0,s1
    5246:	00000097          	auipc	ra,0x0
    524a:	13c080e7          	jalr	316(ra) # 5382 <close>
  return r;
}
    524e:	854a                	mv	a0,s2
    5250:	60e2                	ld	ra,24(sp)
    5252:	6442                	ld	s0,16(sp)
    5254:	64a2                	ld	s1,8(sp)
    5256:	6902                	ld	s2,0(sp)
    5258:	6105                	add	sp,sp,32
    525a:	8082                	ret
    return -1;
    525c:	597d                	li	s2,-1
    525e:	bfc5                	j	524e <stat+0x34>

0000000000005260 <atoi>:

int
atoi(const char *s)
{
    5260:	1141                	add	sp,sp,-16
    5262:	e422                	sd	s0,8(sp)
    5264:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5266:	00054683          	lbu	a3,0(a0)
    526a:	fd06879b          	addw	a5,a3,-48
    526e:	0ff7f793          	zext.b	a5,a5
    5272:	4625                	li	a2,9
    5274:	02f66863          	bltu	a2,a5,52a4 <atoi+0x44>
    5278:	872a                	mv	a4,a0
  n = 0;
    527a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    527c:	0705                	add	a4,a4,1
    527e:	0025179b          	sllw	a5,a0,0x2
    5282:	9fa9                	addw	a5,a5,a0
    5284:	0017979b          	sllw	a5,a5,0x1
    5288:	9fb5                	addw	a5,a5,a3
    528a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    528e:	00074683          	lbu	a3,0(a4)
    5292:	fd06879b          	addw	a5,a3,-48
    5296:	0ff7f793          	zext.b	a5,a5
    529a:	fef671e3          	bgeu	a2,a5,527c <atoi+0x1c>
  return n;
}
    529e:	6422                	ld	s0,8(sp)
    52a0:	0141                	add	sp,sp,16
    52a2:	8082                	ret
  n = 0;
    52a4:	4501                	li	a0,0
    52a6:	bfe5                	j	529e <atoi+0x3e>

00000000000052a8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    52a8:	1141                	add	sp,sp,-16
    52aa:	e422                	sd	s0,8(sp)
    52ac:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    52ae:	02b57463          	bgeu	a0,a1,52d6 <memmove+0x2e>
    while(n-- > 0)
    52b2:	00c05f63          	blez	a2,52d0 <memmove+0x28>
    52b6:	1602                	sll	a2,a2,0x20
    52b8:	9201                	srl	a2,a2,0x20
    52ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    52be:	872a                	mv	a4,a0
      *dst++ = *src++;
    52c0:	0585                	add	a1,a1,1
    52c2:	0705                	add	a4,a4,1
    52c4:	fff5c683          	lbu	a3,-1(a1)
    52c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    52cc:	fee79ae3          	bne	a5,a4,52c0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    52d0:	6422                	ld	s0,8(sp)
    52d2:	0141                	add	sp,sp,16
    52d4:	8082                	ret
    dst += n;
    52d6:	00c50733          	add	a4,a0,a2
    src += n;
    52da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    52dc:	fec05ae3          	blez	a2,52d0 <memmove+0x28>
    52e0:	fff6079b          	addw	a5,a2,-1 # 2fff <subdir+0x329>
    52e4:	1782                	sll	a5,a5,0x20
    52e6:	9381                	srl	a5,a5,0x20
    52e8:	fff7c793          	not	a5,a5
    52ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    52ee:	15fd                	add	a1,a1,-1
    52f0:	177d                	add	a4,a4,-1
    52f2:	0005c683          	lbu	a3,0(a1)
    52f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    52fa:	fee79ae3          	bne	a5,a4,52ee <memmove+0x46>
    52fe:	bfc9                	j	52d0 <memmove+0x28>

0000000000005300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5300:	1141                	add	sp,sp,-16
    5302:	e422                	sd	s0,8(sp)
    5304:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5306:	ca05                	beqz	a2,5336 <memcmp+0x36>
    5308:	fff6069b          	addw	a3,a2,-1
    530c:	1682                	sll	a3,a3,0x20
    530e:	9281                	srl	a3,a3,0x20
    5310:	0685                	add	a3,a3,1
    5312:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5314:	00054783          	lbu	a5,0(a0)
    5318:	0005c703          	lbu	a4,0(a1)
    531c:	00e79863          	bne	a5,a4,532c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5320:	0505                	add	a0,a0,1
    p2++;
    5322:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5324:	fed518e3          	bne	a0,a3,5314 <memcmp+0x14>
  }
  return 0;
    5328:	4501                	li	a0,0
    532a:	a019                	j	5330 <memcmp+0x30>
      return *p1 - *p2;
    532c:	40e7853b          	subw	a0,a5,a4
}
    5330:	6422                	ld	s0,8(sp)
    5332:	0141                	add	sp,sp,16
    5334:	8082                	ret
  return 0;
    5336:	4501                	li	a0,0
    5338:	bfe5                	j	5330 <memcmp+0x30>

000000000000533a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    533a:	1141                	add	sp,sp,-16
    533c:	e406                	sd	ra,8(sp)
    533e:	e022                	sd	s0,0(sp)
    5340:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5342:	00000097          	auipc	ra,0x0
    5346:	f66080e7          	jalr	-154(ra) # 52a8 <memmove>
}
    534a:	60a2                	ld	ra,8(sp)
    534c:	6402                	ld	s0,0(sp)
    534e:	0141                	add	sp,sp,16
    5350:	8082                	ret

0000000000005352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5352:	4885                	li	a7,1
 ecall
    5354:	00000073          	ecall
 ret
    5358:	8082                	ret

000000000000535a <exit>:
.global exit
exit:
 li a7, SYS_exit
    535a:	4889                	li	a7,2
 ecall
    535c:	00000073          	ecall
 ret
    5360:	8082                	ret

0000000000005362 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5362:	488d                	li	a7,3
 ecall
    5364:	00000073          	ecall
 ret
    5368:	8082                	ret

000000000000536a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    536a:	4891                	li	a7,4
 ecall
    536c:	00000073          	ecall
 ret
    5370:	8082                	ret

0000000000005372 <read>:
.global read
read:
 li a7, SYS_read
    5372:	4895                	li	a7,5
 ecall
    5374:	00000073          	ecall
 ret
    5378:	8082                	ret

000000000000537a <write>:
.global write
write:
 li a7, SYS_write
    537a:	48c1                	li	a7,16
 ecall
    537c:	00000073          	ecall
 ret
    5380:	8082                	ret

0000000000005382 <close>:
.global close
close:
 li a7, SYS_close
    5382:	48d5                	li	a7,21
 ecall
    5384:	00000073          	ecall
 ret
    5388:	8082                	ret

000000000000538a <kill>:
.global kill
kill:
 li a7, SYS_kill
    538a:	4899                	li	a7,6
 ecall
    538c:	00000073          	ecall
 ret
    5390:	8082                	ret

0000000000005392 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5392:	489d                	li	a7,7
 ecall
    5394:	00000073          	ecall
 ret
    5398:	8082                	ret

000000000000539a <open>:
.global open
open:
 li a7, SYS_open
    539a:	48bd                	li	a7,15
 ecall
    539c:	00000073          	ecall
 ret
    53a0:	8082                	ret

00000000000053a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53a2:	48c5                	li	a7,17
 ecall
    53a4:	00000073          	ecall
 ret
    53a8:	8082                	ret

00000000000053aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53aa:	48c9                	li	a7,18
 ecall
    53ac:	00000073          	ecall
 ret
    53b0:	8082                	ret

00000000000053b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    53b2:	48a1                	li	a7,8
 ecall
    53b4:	00000073          	ecall
 ret
    53b8:	8082                	ret

00000000000053ba <link>:
.global link
link:
 li a7, SYS_link
    53ba:	48cd                	li	a7,19
 ecall
    53bc:	00000073          	ecall
 ret
    53c0:	8082                	ret

00000000000053c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    53c2:	48d1                	li	a7,20
 ecall
    53c4:	00000073          	ecall
 ret
    53c8:	8082                	ret

00000000000053ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    53ca:	48a5                	li	a7,9
 ecall
    53cc:	00000073          	ecall
 ret
    53d0:	8082                	ret

00000000000053d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    53d2:	48a9                	li	a7,10
 ecall
    53d4:	00000073          	ecall
 ret
    53d8:	8082                	ret

00000000000053da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    53da:	48ad                	li	a7,11
 ecall
    53dc:	00000073          	ecall
 ret
    53e0:	8082                	ret

00000000000053e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    53e2:	48b1                	li	a7,12
 ecall
    53e4:	00000073          	ecall
 ret
    53e8:	8082                	ret

00000000000053ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    53ea:	48b5                	li	a7,13
 ecall
    53ec:	00000073          	ecall
 ret
    53f0:	8082                	ret

00000000000053f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    53f2:	48b9                	li	a7,14
 ecall
    53f4:	00000073          	ecall
 ret
    53f8:	8082                	ret

00000000000053fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    53fa:	1101                	add	sp,sp,-32
    53fc:	ec06                	sd	ra,24(sp)
    53fe:	e822                	sd	s0,16(sp)
    5400:	1000                	add	s0,sp,32
    5402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5406:	4605                	li	a2,1
    5408:	fef40593          	add	a1,s0,-17
    540c:	00000097          	auipc	ra,0x0
    5410:	f6e080e7          	jalr	-146(ra) # 537a <write>
}
    5414:	60e2                	ld	ra,24(sp)
    5416:	6442                	ld	s0,16(sp)
    5418:	6105                	add	sp,sp,32
    541a:	8082                	ret

000000000000541c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    541c:	7139                	add	sp,sp,-64
    541e:	fc06                	sd	ra,56(sp)
    5420:	f822                	sd	s0,48(sp)
    5422:	f426                	sd	s1,40(sp)
    5424:	f04a                	sd	s2,32(sp)
    5426:	ec4e                	sd	s3,24(sp)
    5428:	0080                	add	s0,sp,64
    542a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    542c:	c299                	beqz	a3,5432 <printint+0x16>
    542e:	0805c963          	bltz	a1,54c0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5432:	2581                	sext.w	a1,a1
  neg = 0;
    5434:	4881                	li	a7,0
    5436:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    543a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    543c:	2601                	sext.w	a2,a2
    543e:	00003517          	auipc	a0,0x3
    5442:	b5250513          	add	a0,a0,-1198 # 7f90 <digits>
    5446:	883a                	mv	a6,a4
    5448:	2705                	addw	a4,a4,1
    544a:	02c5f7bb          	remuw	a5,a1,a2
    544e:	1782                	sll	a5,a5,0x20
    5450:	9381                	srl	a5,a5,0x20
    5452:	97aa                	add	a5,a5,a0
    5454:	0007c783          	lbu	a5,0(a5)
    5458:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    545c:	0005879b          	sext.w	a5,a1
    5460:	02c5d5bb          	divuw	a1,a1,a2
    5464:	0685                	add	a3,a3,1
    5466:	fec7f0e3          	bgeu	a5,a2,5446 <printint+0x2a>
  if(neg)
    546a:	00088c63          	beqz	a7,5482 <printint+0x66>
    buf[i++] = '-';
    546e:	fd070793          	add	a5,a4,-48
    5472:	00878733          	add	a4,a5,s0
    5476:	02d00793          	li	a5,45
    547a:	fef70823          	sb	a5,-16(a4)
    547e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5482:	02e05863          	blez	a4,54b2 <printint+0x96>
    5486:	fc040793          	add	a5,s0,-64
    548a:	00e78933          	add	s2,a5,a4
    548e:	fff78993          	add	s3,a5,-1
    5492:	99ba                	add	s3,s3,a4
    5494:	377d                	addw	a4,a4,-1
    5496:	1702                	sll	a4,a4,0x20
    5498:	9301                	srl	a4,a4,0x20
    549a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    549e:	fff94583          	lbu	a1,-1(s2)
    54a2:	8526                	mv	a0,s1
    54a4:	00000097          	auipc	ra,0x0
    54a8:	f56080e7          	jalr	-170(ra) # 53fa <putc>
  while(--i >= 0)
    54ac:	197d                	add	s2,s2,-1
    54ae:	ff3918e3          	bne	s2,s3,549e <printint+0x82>
}
    54b2:	70e2                	ld	ra,56(sp)
    54b4:	7442                	ld	s0,48(sp)
    54b6:	74a2                	ld	s1,40(sp)
    54b8:	7902                	ld	s2,32(sp)
    54ba:	69e2                	ld	s3,24(sp)
    54bc:	6121                	add	sp,sp,64
    54be:	8082                	ret
    x = -xx;
    54c0:	40b005bb          	negw	a1,a1
    neg = 1;
    54c4:	4885                	li	a7,1
    x = -xx;
    54c6:	bf85                	j	5436 <printint+0x1a>

00000000000054c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    54c8:	715d                	add	sp,sp,-80
    54ca:	e486                	sd	ra,72(sp)
    54cc:	e0a2                	sd	s0,64(sp)
    54ce:	fc26                	sd	s1,56(sp)
    54d0:	f84a                	sd	s2,48(sp)
    54d2:	f44e                	sd	s3,40(sp)
    54d4:	f052                	sd	s4,32(sp)
    54d6:	ec56                	sd	s5,24(sp)
    54d8:	e85a                	sd	s6,16(sp)
    54da:	e45e                	sd	s7,8(sp)
    54dc:	e062                	sd	s8,0(sp)
    54de:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    54e0:	0005c903          	lbu	s2,0(a1)
    54e4:	18090c63          	beqz	s2,567c <vprintf+0x1b4>
    54e8:	8aaa                	mv	s5,a0
    54ea:	8bb2                	mv	s7,a2
    54ec:	00158493          	add	s1,a1,1
  state = 0;
    54f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    54f2:	02500a13          	li	s4,37
    54f6:	4b55                	li	s6,21
    54f8:	a839                	j	5516 <vprintf+0x4e>
        putc(fd, c);
    54fa:	85ca                	mv	a1,s2
    54fc:	8556                	mv	a0,s5
    54fe:	00000097          	auipc	ra,0x0
    5502:	efc080e7          	jalr	-260(ra) # 53fa <putc>
    5506:	a019                	j	550c <vprintf+0x44>
    } else if(state == '%'){
    5508:	01498d63          	beq	s3,s4,5522 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    550c:	0485                	add	s1,s1,1
    550e:	fff4c903          	lbu	s2,-1(s1)
    5512:	16090563          	beqz	s2,567c <vprintf+0x1b4>
    if(state == 0){
    5516:	fe0999e3          	bnez	s3,5508 <vprintf+0x40>
      if(c == '%'){
    551a:	ff4910e3          	bne	s2,s4,54fa <vprintf+0x32>
        state = '%';
    551e:	89d2                	mv	s3,s4
    5520:	b7f5                	j	550c <vprintf+0x44>
      if(c == 'd'){
    5522:	13490263          	beq	s2,s4,5646 <vprintf+0x17e>
    5526:	f9d9079b          	addw	a5,s2,-99
    552a:	0ff7f793          	zext.b	a5,a5
    552e:	12fb6563          	bltu	s6,a5,5658 <vprintf+0x190>
    5532:	f9d9079b          	addw	a5,s2,-99
    5536:	0ff7f713          	zext.b	a4,a5
    553a:	10eb6f63          	bltu	s6,a4,5658 <vprintf+0x190>
    553e:	00271793          	sll	a5,a4,0x2
    5542:	00003717          	auipc	a4,0x3
    5546:	9f670713          	add	a4,a4,-1546 # 7f38 <statistics+0x26d8>
    554a:	97ba                	add	a5,a5,a4
    554c:	439c                	lw	a5,0(a5)
    554e:	97ba                	add	a5,a5,a4
    5550:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5552:	008b8913          	add	s2,s7,8
    5556:	4685                	li	a3,1
    5558:	4629                	li	a2,10
    555a:	000ba583          	lw	a1,0(s7)
    555e:	8556                	mv	a0,s5
    5560:	00000097          	auipc	ra,0x0
    5564:	ebc080e7          	jalr	-324(ra) # 541c <printint>
    5568:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    556a:	4981                	li	s3,0
    556c:	b745                	j	550c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    556e:	008b8913          	add	s2,s7,8
    5572:	4681                	li	a3,0
    5574:	4629                	li	a2,10
    5576:	000ba583          	lw	a1,0(s7)
    557a:	8556                	mv	a0,s5
    557c:	00000097          	auipc	ra,0x0
    5580:	ea0080e7          	jalr	-352(ra) # 541c <printint>
    5584:	8bca                	mv	s7,s2
      state = 0;
    5586:	4981                	li	s3,0
    5588:	b751                	j	550c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    558a:	008b8913          	add	s2,s7,8
    558e:	4681                	li	a3,0
    5590:	4641                	li	a2,16
    5592:	000ba583          	lw	a1,0(s7)
    5596:	8556                	mv	a0,s5
    5598:	00000097          	auipc	ra,0x0
    559c:	e84080e7          	jalr	-380(ra) # 541c <printint>
    55a0:	8bca                	mv	s7,s2
      state = 0;
    55a2:	4981                	li	s3,0
    55a4:	b7a5                	j	550c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    55a6:	008b8c13          	add	s8,s7,8
    55aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    55ae:	03000593          	li	a1,48
    55b2:	8556                	mv	a0,s5
    55b4:	00000097          	auipc	ra,0x0
    55b8:	e46080e7          	jalr	-442(ra) # 53fa <putc>
  putc(fd, 'x');
    55bc:	07800593          	li	a1,120
    55c0:	8556                	mv	a0,s5
    55c2:	00000097          	auipc	ra,0x0
    55c6:	e38080e7          	jalr	-456(ra) # 53fa <putc>
    55ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    55cc:	00003b97          	auipc	s7,0x3
    55d0:	9c4b8b93          	add	s7,s7,-1596 # 7f90 <digits>
    55d4:	03c9d793          	srl	a5,s3,0x3c
    55d8:	97de                	add	a5,a5,s7
    55da:	0007c583          	lbu	a1,0(a5)
    55de:	8556                	mv	a0,s5
    55e0:	00000097          	auipc	ra,0x0
    55e4:	e1a080e7          	jalr	-486(ra) # 53fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    55e8:	0992                	sll	s3,s3,0x4
    55ea:	397d                	addw	s2,s2,-1
    55ec:	fe0914e3          	bnez	s2,55d4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    55f0:	8be2                	mv	s7,s8
      state = 0;
    55f2:	4981                	li	s3,0
    55f4:	bf21                	j	550c <vprintf+0x44>
        s = va_arg(ap, char*);
    55f6:	008b8993          	add	s3,s7,8
    55fa:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    55fe:	02090163          	beqz	s2,5620 <vprintf+0x158>
        while(*s != 0){
    5602:	00094583          	lbu	a1,0(s2)
    5606:	c9a5                	beqz	a1,5676 <vprintf+0x1ae>
          putc(fd, *s);
    5608:	8556                	mv	a0,s5
    560a:	00000097          	auipc	ra,0x0
    560e:	df0080e7          	jalr	-528(ra) # 53fa <putc>
          s++;
    5612:	0905                	add	s2,s2,1
        while(*s != 0){
    5614:	00094583          	lbu	a1,0(s2)
    5618:	f9e5                	bnez	a1,5608 <vprintf+0x140>
        s = va_arg(ap, char*);
    561a:	8bce                	mv	s7,s3
      state = 0;
    561c:	4981                	li	s3,0
    561e:	b5fd                	j	550c <vprintf+0x44>
          s = "(null)";
    5620:	00003917          	auipc	s2,0x3
    5624:	91090913          	add	s2,s2,-1776 # 7f30 <statistics+0x26d0>
        while(*s != 0){
    5628:	02800593          	li	a1,40
    562c:	bff1                	j	5608 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    562e:	008b8913          	add	s2,s7,8
    5632:	000bc583          	lbu	a1,0(s7)
    5636:	8556                	mv	a0,s5
    5638:	00000097          	auipc	ra,0x0
    563c:	dc2080e7          	jalr	-574(ra) # 53fa <putc>
    5640:	8bca                	mv	s7,s2
      state = 0;
    5642:	4981                	li	s3,0
    5644:	b5e1                	j	550c <vprintf+0x44>
        putc(fd, c);
    5646:	02500593          	li	a1,37
    564a:	8556                	mv	a0,s5
    564c:	00000097          	auipc	ra,0x0
    5650:	dae080e7          	jalr	-594(ra) # 53fa <putc>
      state = 0;
    5654:	4981                	li	s3,0
    5656:	bd5d                	j	550c <vprintf+0x44>
        putc(fd, '%');
    5658:	02500593          	li	a1,37
    565c:	8556                	mv	a0,s5
    565e:	00000097          	auipc	ra,0x0
    5662:	d9c080e7          	jalr	-612(ra) # 53fa <putc>
        putc(fd, c);
    5666:	85ca                	mv	a1,s2
    5668:	8556                	mv	a0,s5
    566a:	00000097          	auipc	ra,0x0
    566e:	d90080e7          	jalr	-624(ra) # 53fa <putc>
      state = 0;
    5672:	4981                	li	s3,0
    5674:	bd61                	j	550c <vprintf+0x44>
        s = va_arg(ap, char*);
    5676:	8bce                	mv	s7,s3
      state = 0;
    5678:	4981                	li	s3,0
    567a:	bd49                	j	550c <vprintf+0x44>
    }
  }
}
    567c:	60a6                	ld	ra,72(sp)
    567e:	6406                	ld	s0,64(sp)
    5680:	74e2                	ld	s1,56(sp)
    5682:	7942                	ld	s2,48(sp)
    5684:	79a2                	ld	s3,40(sp)
    5686:	7a02                	ld	s4,32(sp)
    5688:	6ae2                	ld	s5,24(sp)
    568a:	6b42                	ld	s6,16(sp)
    568c:	6ba2                	ld	s7,8(sp)
    568e:	6c02                	ld	s8,0(sp)
    5690:	6161                	add	sp,sp,80
    5692:	8082                	ret

0000000000005694 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5694:	715d                	add	sp,sp,-80
    5696:	ec06                	sd	ra,24(sp)
    5698:	e822                	sd	s0,16(sp)
    569a:	1000                	add	s0,sp,32
    569c:	e010                	sd	a2,0(s0)
    569e:	e414                	sd	a3,8(s0)
    56a0:	e818                	sd	a4,16(s0)
    56a2:	ec1c                	sd	a5,24(s0)
    56a4:	03043023          	sd	a6,32(s0)
    56a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    56ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    56b0:	8622                	mv	a2,s0
    56b2:	00000097          	auipc	ra,0x0
    56b6:	e16080e7          	jalr	-490(ra) # 54c8 <vprintf>
}
    56ba:	60e2                	ld	ra,24(sp)
    56bc:	6442                	ld	s0,16(sp)
    56be:	6161                	add	sp,sp,80
    56c0:	8082                	ret

00000000000056c2 <printf>:

void
printf(const char *fmt, ...)
{
    56c2:	711d                	add	sp,sp,-96
    56c4:	ec06                	sd	ra,24(sp)
    56c6:	e822                	sd	s0,16(sp)
    56c8:	1000                	add	s0,sp,32
    56ca:	e40c                	sd	a1,8(s0)
    56cc:	e810                	sd	a2,16(s0)
    56ce:	ec14                	sd	a3,24(s0)
    56d0:	f018                	sd	a4,32(s0)
    56d2:	f41c                	sd	a5,40(s0)
    56d4:	03043823          	sd	a6,48(s0)
    56d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    56dc:	00840613          	add	a2,s0,8
    56e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    56e4:	85aa                	mv	a1,a0
    56e6:	4505                	li	a0,1
    56e8:	00000097          	auipc	ra,0x0
    56ec:	de0080e7          	jalr	-544(ra) # 54c8 <vprintf>
}
    56f0:	60e2                	ld	ra,24(sp)
    56f2:	6442                	ld	s0,16(sp)
    56f4:	6125                	add	sp,sp,96
    56f6:	8082                	ret

00000000000056f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    56f8:	1141                	add	sp,sp,-16
    56fa:	e422                	sd	s0,8(sp)
    56fc:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    56fe:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5702:	00003797          	auipc	a5,0x3
    5706:	8e67b783          	ld	a5,-1818(a5) # 7fe8 <freep>
    570a:	a02d                	j	5734 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    570c:	4618                	lw	a4,8(a2)
    570e:	9f2d                	addw	a4,a4,a1
    5710:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5714:	6398                	ld	a4,0(a5)
    5716:	6310                	ld	a2,0(a4)
    5718:	a83d                	j	5756 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    571a:	ff852703          	lw	a4,-8(a0)
    571e:	9f31                	addw	a4,a4,a2
    5720:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5722:	ff053683          	ld	a3,-16(a0)
    5726:	a091                	j	576a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5728:	6398                	ld	a4,0(a5)
    572a:	00e7e463          	bltu	a5,a4,5732 <free+0x3a>
    572e:	00e6ea63          	bltu	a3,a4,5742 <free+0x4a>
{
    5732:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5734:	fed7fae3          	bgeu	a5,a3,5728 <free+0x30>
    5738:	6398                	ld	a4,0(a5)
    573a:	00e6e463          	bltu	a3,a4,5742 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    573e:	fee7eae3          	bltu	a5,a4,5732 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5742:	ff852583          	lw	a1,-8(a0)
    5746:	6390                	ld	a2,0(a5)
    5748:	02059813          	sll	a6,a1,0x20
    574c:	01c85713          	srl	a4,a6,0x1c
    5750:	9736                	add	a4,a4,a3
    5752:	fae60de3          	beq	a2,a4,570c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5756:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    575a:	4790                	lw	a2,8(a5)
    575c:	02061593          	sll	a1,a2,0x20
    5760:	01c5d713          	srl	a4,a1,0x1c
    5764:	973e                	add	a4,a4,a5
    5766:	fae68ae3          	beq	a3,a4,571a <free+0x22>
    p->s.ptr = bp->s.ptr;
    576a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    576c:	00003717          	auipc	a4,0x3
    5770:	86f73e23          	sd	a5,-1924(a4) # 7fe8 <freep>
}
    5774:	6422                	ld	s0,8(sp)
    5776:	0141                	add	sp,sp,16
    5778:	8082                	ret

000000000000577a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    577a:	7139                	add	sp,sp,-64
    577c:	fc06                	sd	ra,56(sp)
    577e:	f822                	sd	s0,48(sp)
    5780:	f426                	sd	s1,40(sp)
    5782:	f04a                	sd	s2,32(sp)
    5784:	ec4e                	sd	s3,24(sp)
    5786:	e852                	sd	s4,16(sp)
    5788:	e456                	sd	s5,8(sp)
    578a:	e05a                	sd	s6,0(sp)
    578c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    578e:	02051493          	sll	s1,a0,0x20
    5792:	9081                	srl	s1,s1,0x20
    5794:	04bd                	add	s1,s1,15
    5796:	8091                	srl	s1,s1,0x4
    5798:	0014899b          	addw	s3,s1,1
    579c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    579e:	00003517          	auipc	a0,0x3
    57a2:	84a53503          	ld	a0,-1974(a0) # 7fe8 <freep>
    57a6:	c515                	beqz	a0,57d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    57a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    57aa:	4798                	lw	a4,8(a5)
    57ac:	02977f63          	bgeu	a4,s1,57ea <malloc+0x70>
  if(nu < 4096)
    57b0:	8a4e                	mv	s4,s3
    57b2:	0009871b          	sext.w	a4,s3
    57b6:	6685                	lui	a3,0x1
    57b8:	00d77363          	bgeu	a4,a3,57be <malloc+0x44>
    57bc:	6a05                	lui	s4,0x1
    57be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    57c2:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    57c6:	00003917          	auipc	s2,0x3
    57ca:	82290913          	add	s2,s2,-2014 # 7fe8 <freep>
  if(p == (char*)-1)
    57ce:	5afd                	li	s5,-1
    57d0:	a895                	j	5844 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    57d2:	00009797          	auipc	a5,0x9
    57d6:	03678793          	add	a5,a5,54 # e808 <base>
    57da:	00003717          	auipc	a4,0x3
    57de:	80f73723          	sd	a5,-2034(a4) # 7fe8 <freep>
    57e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    57e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    57e8:	b7e1                	j	57b0 <malloc+0x36>
      if(p->s.size == nunits)
    57ea:	02e48c63          	beq	s1,a4,5822 <malloc+0xa8>
        p->s.size -= nunits;
    57ee:	4137073b          	subw	a4,a4,s3
    57f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    57f4:	02071693          	sll	a3,a4,0x20
    57f8:	01c6d713          	srl	a4,a3,0x1c
    57fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    57fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5802:	00002717          	auipc	a4,0x2
    5806:	7ea73323          	sd	a0,2022(a4) # 7fe8 <freep>
      return (void*)(p + 1);
    580a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    580e:	70e2                	ld	ra,56(sp)
    5810:	7442                	ld	s0,48(sp)
    5812:	74a2                	ld	s1,40(sp)
    5814:	7902                	ld	s2,32(sp)
    5816:	69e2                	ld	s3,24(sp)
    5818:	6a42                	ld	s4,16(sp)
    581a:	6aa2                	ld	s5,8(sp)
    581c:	6b02                	ld	s6,0(sp)
    581e:	6121                	add	sp,sp,64
    5820:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5822:	6398                	ld	a4,0(a5)
    5824:	e118                	sd	a4,0(a0)
    5826:	bff1                	j	5802 <malloc+0x88>
  hp->s.size = nu;
    5828:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    582c:	0541                	add	a0,a0,16
    582e:	00000097          	auipc	ra,0x0
    5832:	eca080e7          	jalr	-310(ra) # 56f8 <free>
  return freep;
    5836:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    583a:	d971                	beqz	a0,580e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    583c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    583e:	4798                	lw	a4,8(a5)
    5840:	fa9775e3          	bgeu	a4,s1,57ea <malloc+0x70>
    if(p == freep)
    5844:	00093703          	ld	a4,0(s2)
    5848:	853e                	mv	a0,a5
    584a:	fef719e3          	bne	a4,a5,583c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    584e:	8552                	mv	a0,s4
    5850:	00000097          	auipc	ra,0x0
    5854:	b92080e7          	jalr	-1134(ra) # 53e2 <sbrk>
  if(p == (char*)-1)
    5858:	fd5518e3          	bne	a0,s5,5828 <malloc+0xae>
        return 0;
    585c:	4501                	li	a0,0
    585e:	bf45                	j	580e <malloc+0x94>

0000000000005860 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
    5860:	7179                	add	sp,sp,-48
    5862:	f406                	sd	ra,40(sp)
    5864:	f022                	sd	s0,32(sp)
    5866:	ec26                	sd	s1,24(sp)
    5868:	e84a                	sd	s2,16(sp)
    586a:	e44e                	sd	s3,8(sp)
    586c:	e052                	sd	s4,0(sp)
    586e:	1800                	add	s0,sp,48
    5870:	8a2a                	mv	s4,a0
    5872:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
    5874:	4581                	li	a1,0
    5876:	00002517          	auipc	a0,0x2
    587a:	73250513          	add	a0,a0,1842 # 7fa8 <digits+0x18>
    587e:	00000097          	auipc	ra,0x0
    5882:	b1c080e7          	jalr	-1252(ra) # 539a <open>
  if(fd < 0) {
    5886:	04054263          	bltz	a0,58ca <statistics+0x6a>
    588a:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
    588c:	4481                	li	s1,0
    588e:	03205063          	blez	s2,58ae <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
    5892:	4099063b          	subw	a2,s2,s1
    5896:	009a05b3          	add	a1,s4,s1
    589a:	854e                	mv	a0,s3
    589c:	00000097          	auipc	ra,0x0
    58a0:	ad6080e7          	jalr	-1322(ra) # 5372 <read>
    58a4:	00054563          	bltz	a0,58ae <statistics+0x4e>
      break;
    }
    i += n;
    58a8:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
    58aa:	ff24c4e3          	blt	s1,s2,5892 <statistics+0x32>
  }
  close(fd);
    58ae:	854e                	mv	a0,s3
    58b0:	00000097          	auipc	ra,0x0
    58b4:	ad2080e7          	jalr	-1326(ra) # 5382 <close>
  return i;
}
    58b8:	8526                	mv	a0,s1
    58ba:	70a2                	ld	ra,40(sp)
    58bc:	7402                	ld	s0,32(sp)
    58be:	64e2                	ld	s1,24(sp)
    58c0:	6942                	ld	s2,16(sp)
    58c2:	69a2                	ld	s3,8(sp)
    58c4:	6a02                	ld	s4,0(sp)
    58c6:	6145                	add	sp,sp,48
    58c8:	8082                	ret
      fprintf(2, "stats: open failed\n");
    58ca:	00002597          	auipc	a1,0x2
    58ce:	6ee58593          	add	a1,a1,1774 # 7fb8 <digits+0x28>
    58d2:	4509                	li	a0,2
    58d4:	00000097          	auipc	ra,0x0
    58d8:	dc0080e7          	jalr	-576(ra) # 5694 <fprintf>
      exit(1);
    58dc:	4505                	li	a0,1
    58de:	00000097          	auipc	ra,0x0
    58e2:	a7c080e7          	jalr	-1412(ra) # 535a <exit>
