
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
      14:	502080e7          	jalr	1282(ra) # 5512 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	4f0080e7          	jalr	1264(ra) # 5512 <open>
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
      42:	99a50513          	add	a0,a0,-1638 # 59d8 <malloc+0xe6>
      46:	00005097          	auipc	ra,0x5
      4a:	7f4080e7          	jalr	2036(ra) # 583a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	482080e7          	jalr	1154(ra) # 54d2 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	22878793          	add	a5,a5,552 # 9280 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	93068693          	add	a3,a3,-1744 # b990 <buf>
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
      84:	97850513          	add	a0,a0,-1672 # 59f8 <malloc+0x106>
      88:	00005097          	auipc	ra,0x5
      8c:	7b2080e7          	jalr	1970(ra) # 583a <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	440080e7          	jalr	1088(ra) # 54d2 <exit>

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
      ac:	96850513          	add	a0,a0,-1688 # 5a10 <malloc+0x11e>
      b0:	00005097          	auipc	ra,0x5
      b4:	462080e7          	jalr	1122(ra) # 5512 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	43e080e7          	jalr	1086(ra) # 54fa <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	96a50513          	add	a0,a0,-1686 # 5a30 <malloc+0x13e>
      ce:	00005097          	auipc	ra,0x5
      d2:	444080e7          	jalr	1092(ra) # 5512 <open>
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
      ea:	93250513          	add	a0,a0,-1742 # 5a18 <malloc+0x126>
      ee:	00005097          	auipc	ra,0x5
      f2:	74c080e7          	jalr	1868(ra) # 583a <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	3da080e7          	jalr	986(ra) # 54d2 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	93e50513          	add	a0,a0,-1730 # 5a40 <malloc+0x14e>
     10a:	00005097          	auipc	ra,0x5
     10e:	730080e7          	jalr	1840(ra) # 583a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	3be080e7          	jalr	958(ra) # 54d2 <exit>

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
     130:	93c50513          	add	a0,a0,-1732 # 5a68 <malloc+0x176>
     134:	00005097          	auipc	ra,0x5
     138:	3ee080e7          	jalr	1006(ra) # 5522 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	92850513          	add	a0,a0,-1752 # 5a68 <malloc+0x176>
     148:	00005097          	auipc	ra,0x5
     14c:	3ca080e7          	jalr	970(ra) # 5512 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	92458593          	add	a1,a1,-1756 # 5a78 <malloc+0x186>
     15c:	00005097          	auipc	ra,0x5
     160:	396080e7          	jalr	918(ra) # 54f2 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	90050513          	add	a0,a0,-1792 # 5a68 <malloc+0x176>
     170:	00005097          	auipc	ra,0x5
     174:	3a2080e7          	jalr	930(ra) # 5512 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	90458593          	add	a1,a1,-1788 # 5a80 <malloc+0x18e>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	36c080e7          	jalr	876(ra) # 54f2 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	8d450513          	add	a0,a0,-1836 # 5a68 <malloc+0x176>
     19c:	00005097          	auipc	ra,0x5
     1a0:	386080e7          	jalr	902(ra) # 5522 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	354080e7          	jalr	852(ra) # 54fa <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	34a080e7          	jalr	842(ra) # 54fa <close>
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
     1ce:	8be50513          	add	a0,a0,-1858 # 5a88 <malloc+0x196>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	668080e7          	jalr	1640(ra) # 583a <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	2f6080e7          	jalr	758(ra) # 54d2 <exit>

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
     1f6:	f7678793          	add	a5,a5,-138 # 8168 <name>
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
     21e:	2f8080e7          	jalr	760(ra) # 5512 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	2d8080e7          	jalr	728(ra) # 54fa <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addw	s1,s1,1
     22c:	0ff4f493          	zext.b	s1,s1
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	f3478793          	add	a5,a5,-204 # 8168 <name>
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
     25c:	2ca080e7          	jalr	714(ra) # 5522 <unlink>
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
     294:	82050513          	add	a0,a0,-2016 # 5ab0 <malloc+0x1be>
     298:	00005097          	auipc	ra,0x5
     29c:	28a080e7          	jalr	650(ra) # 5522 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	80ca8a93          	add	s5,s5,-2036 # 5ab0 <malloc+0x1be>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	6e4a0a13          	add	s4,s4,1764 # b990 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	add	s6,s6,457 # 31c9 <subdir+0x39b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	252080e7          	jalr	594(ra) # 5512 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	220080e7          	jalr	544(ra) # 54f2 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49263          	bne	s1,a0,340 <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	20c080e7          	jalr	524(ra) # 54f2 <write>
      if(cc != sz){
     2ee:	04951a63          	bne	a0,s1,342 <bigwrite+0xca>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	206080e7          	jalr	518(ra) # 54fa <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	224080e7          	jalr	548(ra) # 5522 <unlink>
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
     32a:	79a50513          	add	a0,a0,1946 # 5ac0 <malloc+0x1ce>
     32e:	00005097          	auipc	ra,0x5
     332:	50c080e7          	jalr	1292(ra) # 583a <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	19a080e7          	jalr	410(ra) # 54d2 <exit>
      if(cc != sz){
     340:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86aa                	mv	a3,a0
     344:	864e                	mv	a2,s3
     346:	85de                	mv	a1,s7
     348:	00005517          	auipc	a0,0x5
     34c:	79850513          	add	a0,a0,1944 # 5ae0 <malloc+0x1ee>
     350:	00005097          	auipc	ra,0x5
     354:	4ea080e7          	jalr	1258(ra) # 583a <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00005097          	auipc	ra,0x5
     35e:	178080e7          	jalr	376(ra) # 54d2 <exit>

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
     388:	774a0a13          	add	s4,s4,1908 # 5af8 <malloc+0x206>
    uint64 addr = addrs[ai];
     38c:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     390:	20100593          	li	a1,513
     394:	8552                	mv	a0,s4
     396:	00005097          	auipc	ra,0x5
     39a:	17c080e7          	jalr	380(ra) # 5512 <open>
     39e:	84aa                	mv	s1,a0
    if(fd < 0){
     3a0:	08054863          	bltz	a0,430 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a4:	6609                	lui	a2,0x2
     3a6:	85ce                	mv	a1,s3
     3a8:	00005097          	auipc	ra,0x5
     3ac:	14a080e7          	jalr	330(ra) # 54f2 <write>
    if(n >= 0){
     3b0:	08055d63          	bgez	a0,44a <copyin+0xe8>
    close(fd);
     3b4:	8526                	mv	a0,s1
     3b6:	00005097          	auipc	ra,0x5
     3ba:	144080e7          	jalr	324(ra) # 54fa <close>
    unlink("copyin1");
     3be:	8552                	mv	a0,s4
     3c0:	00005097          	auipc	ra,0x5
     3c4:	162080e7          	jalr	354(ra) # 5522 <unlink>
    n = write(1, (char*)addr, 8192);
     3c8:	6609                	lui	a2,0x2
     3ca:	85ce                	mv	a1,s3
     3cc:	4505                	li	a0,1
     3ce:	00005097          	auipc	ra,0x5
     3d2:	124080e7          	jalr	292(ra) # 54f2 <write>
    if(n > 0){
     3d6:	08a04963          	bgtz	a0,468 <copyin+0x106>
    if(pipe(fds) < 0){
     3da:	fb840513          	add	a0,s0,-72
     3de:	00005097          	auipc	ra,0x5
     3e2:	104080e7          	jalr	260(ra) # 54e2 <pipe>
     3e6:	0a054063          	bltz	a0,486 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ea:	6609                	lui	a2,0x2
     3ec:	85ce                	mv	a1,s3
     3ee:	fbc42503          	lw	a0,-68(s0)
     3f2:	00005097          	auipc	ra,0x5
     3f6:	100080e7          	jalr	256(ra) # 54f2 <write>
    if(n > 0){
     3fa:	0aa04363          	bgtz	a0,4a0 <copyin+0x13e>
    close(fds[0]);
     3fe:	fb842503          	lw	a0,-72(s0)
     402:	00005097          	auipc	ra,0x5
     406:	0f8080e7          	jalr	248(ra) # 54fa <close>
    close(fds[1]);
     40a:	fbc42503          	lw	a0,-68(s0)
     40e:	00005097          	auipc	ra,0x5
     412:	0ec080e7          	jalr	236(ra) # 54fa <close>
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
     434:	6d050513          	add	a0,a0,1744 # 5b00 <malloc+0x20e>
     438:	00005097          	auipc	ra,0x5
     43c:	402080e7          	jalr	1026(ra) # 583a <printf>
      exit(1);
     440:	4505                	li	a0,1
     442:	00005097          	auipc	ra,0x5
     446:	090080e7          	jalr	144(ra) # 54d2 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44a:	862a                	mv	a2,a0
     44c:	85ce                	mv	a1,s3
     44e:	00005517          	auipc	a0,0x5
     452:	6ca50513          	add	a0,a0,1738 # 5b18 <malloc+0x226>
     456:	00005097          	auipc	ra,0x5
     45a:	3e4080e7          	jalr	996(ra) # 583a <printf>
      exit(1);
     45e:	4505                	li	a0,1
     460:	00005097          	auipc	ra,0x5
     464:	072080e7          	jalr	114(ra) # 54d2 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     468:	862a                	mv	a2,a0
     46a:	85ce                	mv	a1,s3
     46c:	00005517          	auipc	a0,0x5
     470:	6dc50513          	add	a0,a0,1756 # 5b48 <malloc+0x256>
     474:	00005097          	auipc	ra,0x5
     478:	3c6080e7          	jalr	966(ra) # 583a <printf>
      exit(1);
     47c:	4505                	li	a0,1
     47e:	00005097          	auipc	ra,0x5
     482:	054080e7          	jalr	84(ra) # 54d2 <exit>
      printf("pipe() failed\n");
     486:	00005517          	auipc	a0,0x5
     48a:	6f250513          	add	a0,a0,1778 # 5b78 <malloc+0x286>
     48e:	00005097          	auipc	ra,0x5
     492:	3ac080e7          	jalr	940(ra) # 583a <printf>
      exit(1);
     496:	4505                	li	a0,1
     498:	00005097          	auipc	ra,0x5
     49c:	03a080e7          	jalr	58(ra) # 54d2 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a0:	862a                	mv	a2,a0
     4a2:	85ce                	mv	a1,s3
     4a4:	00005517          	auipc	a0,0x5
     4a8:	6e450513          	add	a0,a0,1764 # 5b88 <malloc+0x296>
     4ac:	00005097          	auipc	ra,0x5
     4b0:	38e080e7          	jalr	910(ra) # 583a <printf>
      exit(1);
     4b4:	4505                	li	a0,1
     4b6:	00005097          	auipc	ra,0x5
     4ba:	01c080e7          	jalr	28(ra) # 54d2 <exit>

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
     4e6:	6d6a0a13          	add	s4,s4,1750 # 5bb8 <malloc+0x2c6>
    n = write(fds[1], "x", 1);
     4ea:	00005a97          	auipc	s5,0x5
     4ee:	596a8a93          	add	s5,s5,1430 # 5a80 <malloc+0x18e>
    uint64 addr = addrs[ai];
     4f2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f6:	4581                	li	a1,0
     4f8:	8552                	mv	a0,s4
     4fa:	00005097          	auipc	ra,0x5
     4fe:	018080e7          	jalr	24(ra) # 5512 <open>
     502:	84aa                	mv	s1,a0
    if(fd < 0){
     504:	08054663          	bltz	a0,590 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     508:	6609                	lui	a2,0x2
     50a:	85ce                	mv	a1,s3
     50c:	00005097          	auipc	ra,0x5
     510:	fde080e7          	jalr	-34(ra) # 54ea <read>
    if(n > 0){
     514:	08a04b63          	bgtz	a0,5aa <copyout+0xec>
    close(fd);
     518:	8526                	mv	a0,s1
     51a:	00005097          	auipc	ra,0x5
     51e:	fe0080e7          	jalr	-32(ra) # 54fa <close>
    if(pipe(fds) < 0){
     522:	fa840513          	add	a0,s0,-88
     526:	00005097          	auipc	ra,0x5
     52a:	fbc080e7          	jalr	-68(ra) # 54e2 <pipe>
     52e:	08054d63          	bltz	a0,5c8 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     532:	4605                	li	a2,1
     534:	85d6                	mv	a1,s5
     536:	fac42503          	lw	a0,-84(s0)
     53a:	00005097          	auipc	ra,0x5
     53e:	fb8080e7          	jalr	-72(ra) # 54f2 <write>
    if(n != 1){
     542:	4785                	li	a5,1
     544:	08f51f63          	bne	a0,a5,5e2 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     548:	6609                	lui	a2,0x2
     54a:	85ce                	mv	a1,s3
     54c:	fa842503          	lw	a0,-88(s0)
     550:	00005097          	auipc	ra,0x5
     554:	f9a080e7          	jalr	-102(ra) # 54ea <read>
    if(n > 0){
     558:	0aa04263          	bgtz	a0,5fc <copyout+0x13e>
    close(fds[0]);
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00005097          	auipc	ra,0x5
     564:	f9a080e7          	jalr	-102(ra) # 54fa <close>
    close(fds[1]);
     568:	fac42503          	lw	a0,-84(s0)
     56c:	00005097          	auipc	ra,0x5
     570:	f8e080e7          	jalr	-114(ra) # 54fa <close>
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
     594:	63050513          	add	a0,a0,1584 # 5bc0 <malloc+0x2ce>
     598:	00005097          	auipc	ra,0x5
     59c:	2a2080e7          	jalr	674(ra) # 583a <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	f30080e7          	jalr	-208(ra) # 54d2 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00005517          	auipc	a0,0x5
     5b2:	62a50513          	add	a0,a0,1578 # 5bd8 <malloc+0x2e6>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	284080e7          	jalr	644(ra) # 583a <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	f12080e7          	jalr	-238(ra) # 54d2 <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	5b050513          	add	a0,a0,1456 # 5b78 <malloc+0x286>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	26a080e7          	jalr	618(ra) # 583a <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	ef8080e7          	jalr	-264(ra) # 54d2 <exit>
      printf("pipe write failed\n");
     5e2:	00005517          	auipc	a0,0x5
     5e6:	62650513          	add	a0,a0,1574 # 5c08 <malloc+0x316>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	250080e7          	jalr	592(ra) # 583a <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	ede080e7          	jalr	-290(ra) # 54d2 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00005517          	auipc	a0,0x5
     604:	62050513          	add	a0,a0,1568 # 5c20 <malloc+0x32e>
     608:	00005097          	auipc	ra,0x5
     60c:	232080e7          	jalr	562(ra) # 583a <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	ec0080e7          	jalr	-320(ra) # 54d2 <exit>

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
     632:	43a50513          	add	a0,a0,1082 # 5a68 <malloc+0x176>
     636:	00005097          	auipc	ra,0x5
     63a:	eec080e7          	jalr	-276(ra) # 5522 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00005517          	auipc	a0,0x5
     646:	42650513          	add	a0,a0,1062 # 5a68 <malloc+0x176>
     64a:	00005097          	auipc	ra,0x5
     64e:	ec8080e7          	jalr	-312(ra) # 5512 <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00005597          	auipc	a1,0x5
     65a:	42258593          	add	a1,a1,1058 # 5a78 <malloc+0x186>
     65e:	00005097          	auipc	ra,0x5
     662:	e94080e7          	jalr	-364(ra) # 54f2 <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	e92080e7          	jalr	-366(ra) # 54fa <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00005517          	auipc	a0,0x5
     676:	3f650513          	add	a0,a0,1014 # 5a68 <malloc+0x176>
     67a:	00005097          	auipc	ra,0x5
     67e:	e98080e7          	jalr	-360(ra) # 5512 <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	add	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	e5e080e7          	jalr	-418(ra) # 54ea <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00005517          	auipc	a0,0x5
     6a2:	3ca50513          	add	a0,a0,970 # 5a68 <malloc+0x176>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	e6c080e7          	jalr	-404(ra) # 5512 <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00005517          	auipc	a0,0x5
     6b6:	3b650513          	add	a0,a0,950 # 5a68 <malloc+0x176>
     6ba:	00005097          	auipc	ra,0x5
     6be:	e58080e7          	jalr	-424(ra) # 5512 <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	add	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	e1e080e7          	jalr	-482(ra) # 54ea <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	add	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	e08080e7          	jalr	-504(ra) # 54ea <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00005597          	auipc	a1,0x5
     6f4:	5c058593          	add	a1,a1,1472 # 5cb0 <malloc+0x3be>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	df8080e7          	jalr	-520(ra) # 54f2 <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	add	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	dde080e7          	jalr	-546(ra) # 54ea <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	add	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	dc6080e7          	jalr	-570(ra) # 54ea <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00005517          	auipc	a0,0x5
     736:	33650513          	add	a0,a0,822 # 5a68 <malloc+0x176>
     73a:	00005097          	auipc	ra,0x5
     73e:	de8080e7          	jalr	-536(ra) # 5522 <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	db6080e7          	jalr	-586(ra) # 54fa <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	dac080e7          	jalr	-596(ra) # 54fa <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	da2080e7          	jalr	-606(ra) # 54fa <close>
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
     77a:	4da50513          	add	a0,a0,1242 # 5c50 <malloc+0x35e>
     77e:	00005097          	auipc	ra,0x5
     782:	0bc080e7          	jalr	188(ra) # 583a <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	d4a080e7          	jalr	-694(ra) # 54d2 <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00005517          	auipc	a0,0x5
     796:	4de50513          	add	a0,a0,1246 # 5c70 <malloc+0x37e>
     79a:	00005097          	auipc	ra,0x5
     79e:	0a0080e7          	jalr	160(ra) # 583a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00005517          	auipc	a0,0x5
     7aa:	4da50513          	add	a0,a0,1242 # 5c80 <malloc+0x38e>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	08c080e7          	jalr	140(ra) # 583a <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	d1a080e7          	jalr	-742(ra) # 54d2 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00005517          	auipc	a0,0x5
     7c6:	4de50513          	add	a0,a0,1246 # 5ca0 <malloc+0x3ae>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	070080e7          	jalr	112(ra) # 583a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00005517          	auipc	a0,0x5
     7da:	4aa50513          	add	a0,a0,1194 # 5c80 <malloc+0x38e>
     7de:	00005097          	auipc	ra,0x5
     7e2:	05c080e7          	jalr	92(ra) # 583a <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	cea080e7          	jalr	-790(ra) # 54d2 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00005517          	auipc	a0,0x5
     7f8:	4c450513          	add	a0,a0,1220 # 5cb8 <malloc+0x3c6>
     7fc:	00005097          	auipc	ra,0x5
     800:	03e080e7          	jalr	62(ra) # 583a <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	ccc080e7          	jalr	-820(ra) # 54d2 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00005517          	auipc	a0,0x5
     816:	4c650513          	add	a0,a0,1222 # 5cd8 <malloc+0x3e6>
     81a:	00005097          	auipc	ra,0x5
     81e:	020080e7          	jalr	32(ra) # 583a <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	cae080e7          	jalr	-850(ra) # 54d2 <exit>

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
     84a:	4b250513          	add	a0,a0,1202 # 5cf8 <malloc+0x406>
     84e:	00005097          	auipc	ra,0x5
     852:	cc4080e7          	jalr	-828(ra) # 5512 <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00005997          	auipc	s3,0x5
     862:	4c298993          	add	s3,s3,1218 # 5d20 <malloc+0x42e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00005a97          	auipc	s5,0x5
     86a:	4f2a8a93          	add	s5,s5,1266 # 5d58 <malloc+0x466>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	c7a080e7          	jalr	-902(ra) # 54f2 <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	c66080e7          	jalr	-922(ra) # 54f2 <write>
     894:	47a9                	li	a5,10
     896:	0af51963          	bne	a0,a5,948 <writetest+0x11c>
  for(i = 0; i < N; i++){
     89a:	2485                	addw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	c58080e7          	jalr	-936(ra) # 54fa <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00005517          	auipc	a0,0x5
     8b0:	44c50513          	add	a0,a0,1100 # 5cf8 <malloc+0x406>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	c5e080e7          	jalr	-930(ra) # 5512 <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054363          	bltz	a0,964 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	0ca58593          	add	a1,a1,202 # b990 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	c1c080e7          	jalr	-996(ra) # 54ea <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51363          	bne	a0,a5,980 <writetest+0x154>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	c1a080e7          	jalr	-998(ra) # 54fa <close>
  if(unlink("small") < 0){
     8e8:	00005517          	auipc	a0,0x5
     8ec:	41050513          	add	a0,a0,1040 # 5cf8 <malloc+0x406>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	c32080e7          	jalr	-974(ra) # 5522 <unlink>
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
     916:	3ee50513          	add	a0,a0,1006 # 5d00 <malloc+0x40e>
     91a:	00005097          	auipc	ra,0x5
     91e:	f20080e7          	jalr	-224(ra) # 583a <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	bae080e7          	jalr	-1106(ra) # 54d2 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92c:	85a6                	mv	a1,s1
     92e:	00005517          	auipc	a0,0x5
     932:	40250513          	add	a0,a0,1026 # 5d30 <malloc+0x43e>
     936:	00005097          	auipc	ra,0x5
     93a:	f04080e7          	jalr	-252(ra) # 583a <printf>
      exit(1);
     93e:	4505                	li	a0,1
     940:	00005097          	auipc	ra,0x5
     944:	b92080e7          	jalr	-1134(ra) # 54d2 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     948:	85a6                	mv	a1,s1
     94a:	00005517          	auipc	a0,0x5
     94e:	41e50513          	add	a0,a0,1054 # 5d68 <malloc+0x476>
     952:	00005097          	auipc	ra,0x5
     956:	ee8080e7          	jalr	-280(ra) # 583a <printf>
      exit(1);
     95a:	4505                	li	a0,1
     95c:	00005097          	auipc	ra,0x5
     960:	b76080e7          	jalr	-1162(ra) # 54d2 <exit>
    printf("%s: error: open small failed!\n", s);
     964:	85da                	mv	a1,s6
     966:	00005517          	auipc	a0,0x5
     96a:	42a50513          	add	a0,a0,1066 # 5d90 <malloc+0x49e>
     96e:	00005097          	auipc	ra,0x5
     972:	ecc080e7          	jalr	-308(ra) # 583a <printf>
    exit(1);
     976:	4505                	li	a0,1
     978:	00005097          	auipc	ra,0x5
     97c:	b5a080e7          	jalr	-1190(ra) # 54d2 <exit>
    printf("%s: read failed\n", s);
     980:	85da                	mv	a1,s6
     982:	00005517          	auipc	a0,0x5
     986:	42e50513          	add	a0,a0,1070 # 5db0 <malloc+0x4be>
     98a:	00005097          	auipc	ra,0x5
     98e:	eb0080e7          	jalr	-336(ra) # 583a <printf>
    exit(1);
     992:	4505                	li	a0,1
     994:	00005097          	auipc	ra,0x5
     998:	b3e080e7          	jalr	-1218(ra) # 54d2 <exit>
    printf("%s: unlink small failed\n", s);
     99c:	85da                	mv	a1,s6
     99e:	00005517          	auipc	a0,0x5
     9a2:	42a50513          	add	a0,a0,1066 # 5dc8 <malloc+0x4d6>
     9a6:	00005097          	auipc	ra,0x5
     9aa:	e94080e7          	jalr	-364(ra) # 583a <printf>
    exit(1);
     9ae:	4505                	li	a0,1
     9b0:	00005097          	auipc	ra,0x5
     9b4:	b22080e7          	jalr	-1246(ra) # 54d2 <exit>

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
     9d4:	41850513          	add	a0,a0,1048 # 5de8 <malloc+0x4f6>
     9d8:	00005097          	auipc	ra,0x5
     9dc:	b3a080e7          	jalr	-1222(ra) # 5512 <open>
     9e0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e4:	0000b917          	auipc	s2,0xb
     9e8:	fac90913          	add	s2,s2,-84 # b990 <buf>
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
     a04:	af2080e7          	jalr	-1294(ra) # 54f2 <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51c63          	bne	a0,a5,a84 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addw	s1,s1,1
     a12:	ff4491e3          	bne	s1,s4,9f4 <writebig+0x3c>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	00005097          	auipc	ra,0x5
     a1c:	ae2080e7          	jalr	-1310(ra) # 54fa <close>
  fd = open("big", O_RDONLY);
     a20:	4581                	li	a1,0
     a22:	00005517          	auipc	a0,0x5
     a26:	3c650513          	add	a0,a0,966 # 5de8 <malloc+0x4f6>
     a2a:	00005097          	auipc	ra,0x5
     a2e:	ae8080e7          	jalr	-1304(ra) # 5512 <open>
     a32:	89aa                	mv	s3,a0
  n = 0;
     a34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a36:	0000b917          	auipc	s2,0xb
     a3a:	f5a90913          	add	s2,s2,-166 # b990 <buf>
  if(fd < 0){
     a3e:	06054163          	bltz	a0,aa0 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a42:	40000613          	li	a2,1024
     a46:	85ca                	mv	a1,s2
     a48:	854e                	mv	a0,s3
     a4a:	00005097          	auipc	ra,0x5
     a4e:	aa0080e7          	jalr	-1376(ra) # 54ea <read>
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
     a6e:	38650513          	add	a0,a0,902 # 5df0 <malloc+0x4fe>
     a72:	00005097          	auipc	ra,0x5
     a76:	dc8080e7          	jalr	-568(ra) # 583a <printf>
    exit(1);
     a7a:	4505                	li	a0,1
     a7c:	00005097          	auipc	ra,0x5
     a80:	a56080e7          	jalr	-1450(ra) # 54d2 <exit>
      printf("%s: error: write big file failed\n", i);
     a84:	85a6                	mv	a1,s1
     a86:	00005517          	auipc	a0,0x5
     a8a:	38a50513          	add	a0,a0,906 # 5e10 <malloc+0x51e>
     a8e:	00005097          	auipc	ra,0x5
     a92:	dac080e7          	jalr	-596(ra) # 583a <printf>
      exit(1);
     a96:	4505                	li	a0,1
     a98:	00005097          	auipc	ra,0x5
     a9c:	a3a080e7          	jalr	-1478(ra) # 54d2 <exit>
    printf("%s: error: open big failed!\n", s);
     aa0:	85d6                	mv	a1,s5
     aa2:	00005517          	auipc	a0,0x5
     aa6:	39650513          	add	a0,a0,918 # 5e38 <malloc+0x546>
     aaa:	00005097          	auipc	ra,0x5
     aae:	d90080e7          	jalr	-624(ra) # 583a <printf>
    exit(1);
     ab2:	4505                	li	a0,1
     ab4:	00005097          	auipc	ra,0x5
     ab8:	a1e080e7          	jalr	-1506(ra) # 54d2 <exit>
      if(n == MAXFILE - 1){
     abc:	10b00793          	li	a5,267
     ac0:	02f48a63          	beq	s1,a5,af4 <writebig+0x13c>
  close(fd);
     ac4:	854e                	mv	a0,s3
     ac6:	00005097          	auipc	ra,0x5
     aca:	a34080e7          	jalr	-1484(ra) # 54fa <close>
  if(unlink("big") < 0){
     ace:	00005517          	auipc	a0,0x5
     ad2:	31a50513          	add	a0,a0,794 # 5de8 <malloc+0x4f6>
     ad6:	00005097          	auipc	ra,0x5
     ada:	a4c080e7          	jalr	-1460(ra) # 5522 <unlink>
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
     afc:	36050513          	add	a0,a0,864 # 5e58 <malloc+0x566>
     b00:	00005097          	auipc	ra,0x5
     b04:	d3a080e7          	jalr	-710(ra) # 583a <printf>
        exit(1);
     b08:	4505                	li	a0,1
     b0a:	00005097          	auipc	ra,0x5
     b0e:	9c8080e7          	jalr	-1592(ra) # 54d2 <exit>
      printf("%s: read failed %d\n", i);
     b12:	85aa                	mv	a1,a0
     b14:	00005517          	auipc	a0,0x5
     b18:	36c50513          	add	a0,a0,876 # 5e80 <malloc+0x58e>
     b1c:	00005097          	auipc	ra,0x5
     b20:	d1e080e7          	jalr	-738(ra) # 583a <printf>
      exit(1);
     b24:	4505                	li	a0,1
     b26:	00005097          	auipc	ra,0x5
     b2a:	9ac080e7          	jalr	-1620(ra) # 54d2 <exit>
      printf("%s: read content of block %d is %d\n",
     b2e:	85a6                	mv	a1,s1
     b30:	00005517          	auipc	a0,0x5
     b34:	36850513          	add	a0,a0,872 # 5e98 <malloc+0x5a6>
     b38:	00005097          	auipc	ra,0x5
     b3c:	d02080e7          	jalr	-766(ra) # 583a <printf>
      exit(1);
     b40:	4505                	li	a0,1
     b42:	00005097          	auipc	ra,0x5
     b46:	990080e7          	jalr	-1648(ra) # 54d2 <exit>
    printf("%s: unlink big failed\n", s);
     b4a:	85d6                	mv	a1,s5
     b4c:	00005517          	auipc	a0,0x5
     b50:	37450513          	add	a0,a0,884 # 5ec0 <malloc+0x5ce>
     b54:	00005097          	auipc	ra,0x5
     b58:	ce6080e7          	jalr	-794(ra) # 583a <printf>
    exit(1);
     b5c:	4505                	li	a0,1
     b5e:	00005097          	auipc	ra,0x5
     b62:	974080e7          	jalr	-1676(ra) # 54d2 <exit>

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
     b7e:	35e50513          	add	a0,a0,862 # 5ed8 <malloc+0x5e6>
     b82:	00005097          	auipc	ra,0x5
     b86:	990080e7          	jalr	-1648(ra) # 5512 <open>
  if(fd < 0){
     b8a:	0e054563          	bltz	a0,c74 <unlinkread+0x10e>
     b8e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b90:	4615                	li	a2,5
     b92:	00005597          	auipc	a1,0x5
     b96:	37658593          	add	a1,a1,886 # 5f08 <malloc+0x616>
     b9a:	00005097          	auipc	ra,0x5
     b9e:	958080e7          	jalr	-1704(ra) # 54f2 <write>
  close(fd);
     ba2:	8526                	mv	a0,s1
     ba4:	00005097          	auipc	ra,0x5
     ba8:	956080e7          	jalr	-1706(ra) # 54fa <close>
  fd = open("unlinkread", O_RDWR);
     bac:	4589                	li	a1,2
     bae:	00005517          	auipc	a0,0x5
     bb2:	32a50513          	add	a0,a0,810 # 5ed8 <malloc+0x5e6>
     bb6:	00005097          	auipc	ra,0x5
     bba:	95c080e7          	jalr	-1700(ra) # 5512 <open>
     bbe:	84aa                	mv	s1,a0
  if(fd < 0){
     bc0:	0c054863          	bltz	a0,c90 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc4:	00005517          	auipc	a0,0x5
     bc8:	31450513          	add	a0,a0,788 # 5ed8 <malloc+0x5e6>
     bcc:	00005097          	auipc	ra,0x5
     bd0:	956080e7          	jalr	-1706(ra) # 5522 <unlink>
     bd4:	ed61                	bnez	a0,cac <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd6:	20200593          	li	a1,514
     bda:	00005517          	auipc	a0,0x5
     bde:	2fe50513          	add	a0,a0,766 # 5ed8 <malloc+0x5e6>
     be2:	00005097          	auipc	ra,0x5
     be6:	930080e7          	jalr	-1744(ra) # 5512 <open>
     bea:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bec:	460d                	li	a2,3
     bee:	00005597          	auipc	a1,0x5
     bf2:	36258593          	add	a1,a1,866 # 5f50 <malloc+0x65e>
     bf6:	00005097          	auipc	ra,0x5
     bfa:	8fc080e7          	jalr	-1796(ra) # 54f2 <write>
  close(fd1);
     bfe:	854a                	mv	a0,s2
     c00:	00005097          	auipc	ra,0x5
     c04:	8fa080e7          	jalr	-1798(ra) # 54fa <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c08:	660d                	lui	a2,0x3
     c0a:	0000b597          	auipc	a1,0xb
     c0e:	d8658593          	add	a1,a1,-634 # b990 <buf>
     c12:	8526                	mv	a0,s1
     c14:	00005097          	auipc	ra,0x5
     c18:	8d6080e7          	jalr	-1834(ra) # 54ea <read>
     c1c:	4795                	li	a5,5
     c1e:	0af51563          	bne	a0,a5,cc8 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c22:	0000b717          	auipc	a4,0xb
     c26:	d6e74703          	lbu	a4,-658(a4) # b990 <buf>
     c2a:	06800793          	li	a5,104
     c2e:	0af71b63          	bne	a4,a5,ce4 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c32:	4629                	li	a2,10
     c34:	0000b597          	auipc	a1,0xb
     c38:	d5c58593          	add	a1,a1,-676 # b990 <buf>
     c3c:	8526                	mv	a0,s1
     c3e:	00005097          	auipc	ra,0x5
     c42:	8b4080e7          	jalr	-1868(ra) # 54f2 <write>
     c46:	47a9                	li	a5,10
     c48:	0af51c63          	bne	a0,a5,d00 <unlinkread+0x19a>
  close(fd);
     c4c:	8526                	mv	a0,s1
     c4e:	00005097          	auipc	ra,0x5
     c52:	8ac080e7          	jalr	-1876(ra) # 54fa <close>
  unlink("unlinkread");
     c56:	00005517          	auipc	a0,0x5
     c5a:	28250513          	add	a0,a0,642 # 5ed8 <malloc+0x5e6>
     c5e:	00005097          	auipc	ra,0x5
     c62:	8c4080e7          	jalr	-1852(ra) # 5522 <unlink>
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
     c7a:	27250513          	add	a0,a0,626 # 5ee8 <malloc+0x5f6>
     c7e:	00005097          	auipc	ra,0x5
     c82:	bbc080e7          	jalr	-1092(ra) # 583a <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	84a080e7          	jalr	-1974(ra) # 54d2 <exit>
    printf("%s: open unlinkread failed\n", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	27e50513          	add	a0,a0,638 # 5f10 <malloc+0x61e>
     c9a:	00005097          	auipc	ra,0x5
     c9e:	ba0080e7          	jalr	-1120(ra) # 583a <printf>
    exit(1);
     ca2:	4505                	li	a0,1
     ca4:	00005097          	auipc	ra,0x5
     ca8:	82e080e7          	jalr	-2002(ra) # 54d2 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cac:	85ce                	mv	a1,s3
     cae:	00005517          	auipc	a0,0x5
     cb2:	28250513          	add	a0,a0,642 # 5f30 <malloc+0x63e>
     cb6:	00005097          	auipc	ra,0x5
     cba:	b84080e7          	jalr	-1148(ra) # 583a <printf>
    exit(1);
     cbe:	4505                	li	a0,1
     cc0:	00005097          	auipc	ra,0x5
     cc4:	812080e7          	jalr	-2030(ra) # 54d2 <exit>
    printf("%s: unlinkread read failed", s);
     cc8:	85ce                	mv	a1,s3
     cca:	00005517          	auipc	a0,0x5
     cce:	28e50513          	add	a0,a0,654 # 5f58 <malloc+0x666>
     cd2:	00005097          	auipc	ra,0x5
     cd6:	b68080e7          	jalr	-1176(ra) # 583a <printf>
    exit(1);
     cda:	4505                	li	a0,1
     cdc:	00004097          	auipc	ra,0x4
     ce0:	7f6080e7          	jalr	2038(ra) # 54d2 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce4:	85ce                	mv	a1,s3
     ce6:	00005517          	auipc	a0,0x5
     cea:	29250513          	add	a0,a0,658 # 5f78 <malloc+0x686>
     cee:	00005097          	auipc	ra,0x5
     cf2:	b4c080e7          	jalr	-1204(ra) # 583a <printf>
    exit(1);
     cf6:	4505                	li	a0,1
     cf8:	00004097          	auipc	ra,0x4
     cfc:	7da080e7          	jalr	2010(ra) # 54d2 <exit>
    printf("%s: unlinkread write failed\n", s);
     d00:	85ce                	mv	a1,s3
     d02:	00005517          	auipc	a0,0x5
     d06:	29650513          	add	a0,a0,662 # 5f98 <malloc+0x6a6>
     d0a:	00005097          	auipc	ra,0x5
     d0e:	b30080e7          	jalr	-1232(ra) # 583a <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00004097          	auipc	ra,0x4
     d18:	7be080e7          	jalr	1982(ra) # 54d2 <exit>

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
     d2e:	28e50513          	add	a0,a0,654 # 5fb8 <malloc+0x6c6>
     d32:	00004097          	auipc	ra,0x4
     d36:	7f0080e7          	jalr	2032(ra) # 5522 <unlink>
  unlink("lf2");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	28650513          	add	a0,a0,646 # 5fc0 <malloc+0x6ce>
     d42:	00004097          	auipc	ra,0x4
     d46:	7e0080e7          	jalr	2016(ra) # 5522 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4a:	20200593          	li	a1,514
     d4e:	00005517          	auipc	a0,0x5
     d52:	26a50513          	add	a0,a0,618 # 5fb8 <malloc+0x6c6>
     d56:	00004097          	auipc	ra,0x4
     d5a:	7bc080e7          	jalr	1980(ra) # 5512 <open>
  if(fd < 0){
     d5e:	10054763          	bltz	a0,e6c <linktest+0x150>
     d62:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d64:	4615                	li	a2,5
     d66:	00005597          	auipc	a1,0x5
     d6a:	1a258593          	add	a1,a1,418 # 5f08 <malloc+0x616>
     d6e:	00004097          	auipc	ra,0x4
     d72:	784080e7          	jalr	1924(ra) # 54f2 <write>
     d76:	4795                	li	a5,5
     d78:	10f51863          	bne	a0,a5,e88 <linktest+0x16c>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00004097          	auipc	ra,0x4
     d82:	77c080e7          	jalr	1916(ra) # 54fa <close>
  if(link("lf1", "lf2") < 0){
     d86:	00005597          	auipc	a1,0x5
     d8a:	23a58593          	add	a1,a1,570 # 5fc0 <malloc+0x6ce>
     d8e:	00005517          	auipc	a0,0x5
     d92:	22a50513          	add	a0,a0,554 # 5fb8 <malloc+0x6c6>
     d96:	00004097          	auipc	ra,0x4
     d9a:	79c080e7          	jalr	1948(ra) # 5532 <link>
     d9e:	10054363          	bltz	a0,ea4 <linktest+0x188>
  unlink("lf1");
     da2:	00005517          	auipc	a0,0x5
     da6:	21650513          	add	a0,a0,534 # 5fb8 <malloc+0x6c6>
     daa:	00004097          	auipc	ra,0x4
     dae:	778080e7          	jalr	1912(ra) # 5522 <unlink>
  if(open("lf1", 0) >= 0){
     db2:	4581                	li	a1,0
     db4:	00005517          	auipc	a0,0x5
     db8:	20450513          	add	a0,a0,516 # 5fb8 <malloc+0x6c6>
     dbc:	00004097          	auipc	ra,0x4
     dc0:	756080e7          	jalr	1878(ra) # 5512 <open>
     dc4:	0e055e63          	bgez	a0,ec0 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc8:	4581                	li	a1,0
     dca:	00005517          	auipc	a0,0x5
     dce:	1f650513          	add	a0,a0,502 # 5fc0 <malloc+0x6ce>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	740080e7          	jalr	1856(ra) # 5512 <open>
     dda:	84aa                	mv	s1,a0
  if(fd < 0){
     ddc:	10054063          	bltz	a0,edc <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000b597          	auipc	a1,0xb
     de6:	bae58593          	add	a1,a1,-1106 # b990 <buf>
     dea:	00004097          	auipc	ra,0x4
     dee:	700080e7          	jalr	1792(ra) # 54ea <read>
     df2:	4795                	li	a5,5
     df4:	10f51263          	bne	a0,a5,ef8 <linktest+0x1dc>
  close(fd);
     df8:	8526                	mv	a0,s1
     dfa:	00004097          	auipc	ra,0x4
     dfe:	700080e7          	jalr	1792(ra) # 54fa <close>
  if(link("lf2", "lf2") >= 0){
     e02:	00005597          	auipc	a1,0x5
     e06:	1be58593          	add	a1,a1,446 # 5fc0 <malloc+0x6ce>
     e0a:	852e                	mv	a0,a1
     e0c:	00004097          	auipc	ra,0x4
     e10:	726080e7          	jalr	1830(ra) # 5532 <link>
     e14:	10055063          	bgez	a0,f14 <linktest+0x1f8>
  unlink("lf2");
     e18:	00005517          	auipc	a0,0x5
     e1c:	1a850513          	add	a0,a0,424 # 5fc0 <malloc+0x6ce>
     e20:	00004097          	auipc	ra,0x4
     e24:	702080e7          	jalr	1794(ra) # 5522 <unlink>
  if(link("lf2", "lf1") >= 0){
     e28:	00005597          	auipc	a1,0x5
     e2c:	19058593          	add	a1,a1,400 # 5fb8 <malloc+0x6c6>
     e30:	00005517          	auipc	a0,0x5
     e34:	19050513          	add	a0,a0,400 # 5fc0 <malloc+0x6ce>
     e38:	00004097          	auipc	ra,0x4
     e3c:	6fa080e7          	jalr	1786(ra) # 5532 <link>
     e40:	0e055863          	bgez	a0,f30 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e44:	00005597          	auipc	a1,0x5
     e48:	17458593          	add	a1,a1,372 # 5fb8 <malloc+0x6c6>
     e4c:	00005517          	auipc	a0,0x5
     e50:	27c50513          	add	a0,a0,636 # 60c8 <malloc+0x7d6>
     e54:	00004097          	auipc	ra,0x4
     e58:	6de080e7          	jalr	1758(ra) # 5532 <link>
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
     e72:	15a50513          	add	a0,a0,346 # 5fc8 <malloc+0x6d6>
     e76:	00005097          	auipc	ra,0x5
     e7a:	9c4080e7          	jalr	-1596(ra) # 583a <printf>
    exit(1);
     e7e:	4505                	li	a0,1
     e80:	00004097          	auipc	ra,0x4
     e84:	652080e7          	jalr	1618(ra) # 54d2 <exit>
    printf("%s: write lf1 failed\n", s);
     e88:	85ca                	mv	a1,s2
     e8a:	00005517          	auipc	a0,0x5
     e8e:	15650513          	add	a0,a0,342 # 5fe0 <malloc+0x6ee>
     e92:	00005097          	auipc	ra,0x5
     e96:	9a8080e7          	jalr	-1624(ra) # 583a <printf>
    exit(1);
     e9a:	4505                	li	a0,1
     e9c:	00004097          	auipc	ra,0x4
     ea0:	636080e7          	jalr	1590(ra) # 54d2 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea4:	85ca                	mv	a1,s2
     ea6:	00005517          	auipc	a0,0x5
     eaa:	15250513          	add	a0,a0,338 # 5ff8 <malloc+0x706>
     eae:	00005097          	auipc	ra,0x5
     eb2:	98c080e7          	jalr	-1652(ra) # 583a <printf>
    exit(1);
     eb6:	4505                	li	a0,1
     eb8:	00004097          	auipc	ra,0x4
     ebc:	61a080e7          	jalr	1562(ra) # 54d2 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec0:	85ca                	mv	a1,s2
     ec2:	00005517          	auipc	a0,0x5
     ec6:	15650513          	add	a0,a0,342 # 6018 <malloc+0x726>
     eca:	00005097          	auipc	ra,0x5
     ece:	970080e7          	jalr	-1680(ra) # 583a <printf>
    exit(1);
     ed2:	4505                	li	a0,1
     ed4:	00004097          	auipc	ra,0x4
     ed8:	5fe080e7          	jalr	1534(ra) # 54d2 <exit>
    printf("%s: open lf2 failed\n", s);
     edc:	85ca                	mv	a1,s2
     ede:	00005517          	auipc	a0,0x5
     ee2:	16a50513          	add	a0,a0,362 # 6048 <malloc+0x756>
     ee6:	00005097          	auipc	ra,0x5
     eea:	954080e7          	jalr	-1708(ra) # 583a <printf>
    exit(1);
     eee:	4505                	li	a0,1
     ef0:	00004097          	auipc	ra,0x4
     ef4:	5e2080e7          	jalr	1506(ra) # 54d2 <exit>
    printf("%s: read lf2 failed\n", s);
     ef8:	85ca                	mv	a1,s2
     efa:	00005517          	auipc	a0,0x5
     efe:	16650513          	add	a0,a0,358 # 6060 <malloc+0x76e>
     f02:	00005097          	auipc	ra,0x5
     f06:	938080e7          	jalr	-1736(ra) # 583a <printf>
    exit(1);
     f0a:	4505                	li	a0,1
     f0c:	00004097          	auipc	ra,0x4
     f10:	5c6080e7          	jalr	1478(ra) # 54d2 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f14:	85ca                	mv	a1,s2
     f16:	00005517          	auipc	a0,0x5
     f1a:	16250513          	add	a0,a0,354 # 6078 <malloc+0x786>
     f1e:	00005097          	auipc	ra,0x5
     f22:	91c080e7          	jalr	-1764(ra) # 583a <printf>
    exit(1);
     f26:	4505                	li	a0,1
     f28:	00004097          	auipc	ra,0x4
     f2c:	5aa080e7          	jalr	1450(ra) # 54d2 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f30:	85ca                	mv	a1,s2
     f32:	00005517          	auipc	a0,0x5
     f36:	16e50513          	add	a0,a0,366 # 60a0 <malloc+0x7ae>
     f3a:	00005097          	auipc	ra,0x5
     f3e:	900080e7          	jalr	-1792(ra) # 583a <printf>
    exit(1);
     f42:	4505                	li	a0,1
     f44:	00004097          	auipc	ra,0x4
     f48:	58e080e7          	jalr	1422(ra) # 54d2 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4c:	85ca                	mv	a1,s2
     f4e:	00005517          	auipc	a0,0x5
     f52:	18250513          	add	a0,a0,386 # 60d0 <malloc+0x7de>
     f56:	00005097          	auipc	ra,0x5
     f5a:	8e4080e7          	jalr	-1820(ra) # 583a <printf>
    exit(1);
     f5e:	4505                	li	a0,1
     f60:	00004097          	auipc	ra,0x4
     f64:	572080e7          	jalr	1394(ra) # 54d2 <exit>

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
     f82:	17250513          	add	a0,a0,370 # 60f0 <malloc+0x7fe>
     f86:	00004097          	auipc	ra,0x4
     f8a:	59c080e7          	jalr	1436(ra) # 5522 <unlink>
  fd = open("bd", O_CREATE);
     f8e:	20000593          	li	a1,512
     f92:	00005517          	auipc	a0,0x5
     f96:	15e50513          	add	a0,a0,350 # 60f0 <malloc+0x7fe>
     f9a:	00004097          	auipc	ra,0x4
     f9e:	578080e7          	jalr	1400(ra) # 5512 <open>
  if(fd < 0){
     fa2:	0c054963          	bltz	a0,1074 <bigdir+0x10c>
  close(fd);
     fa6:	00004097          	auipc	ra,0x4
     faa:	554080e7          	jalr	1364(ra) # 54fa <close>
  for(i = 0; i < N; i++){
     fae:	4901                	li	s2,0
    name[0] = 'x';
     fb0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb4:	00005a17          	auipc	s4,0x5
     fb8:	13ca0a13          	add	s4,s4,316 # 60f0 <malloc+0x7fe>
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
     ff8:	53e080e7          	jalr	1342(ra) # 5532 <link>
     ffc:	84aa                	mv	s1,a0
     ffe:	e949                	bnez	a0,1090 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1000:	2905                	addw	s2,s2,1
    1002:	fb691fe3          	bne	s2,s6,fc0 <bigdir+0x58>
  unlink("bd");
    1006:	00005517          	auipc	a0,0x5
    100a:	0ea50513          	add	a0,a0,234 # 60f0 <malloc+0x7fe>
    100e:	00004097          	auipc	ra,0x4
    1012:	514080e7          	jalr	1300(ra) # 5522 <unlink>
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
    1054:	4d2080e7          	jalr	1234(ra) # 5522 <unlink>
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
    107a:	08250513          	add	a0,a0,130 # 60f8 <malloc+0x806>
    107e:	00004097          	auipc	ra,0x4
    1082:	7bc080e7          	jalr	1980(ra) # 583a <printf>
    exit(1);
    1086:	4505                	li	a0,1
    1088:	00004097          	auipc	ra,0x4
    108c:	44a080e7          	jalr	1098(ra) # 54d2 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1090:	fb040613          	add	a2,s0,-80
    1094:	85ce                	mv	a1,s3
    1096:	00005517          	auipc	a0,0x5
    109a:	08250513          	add	a0,a0,130 # 6118 <malloc+0x826>
    109e:	00004097          	auipc	ra,0x4
    10a2:	79c080e7          	jalr	1948(ra) # 583a <printf>
      exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00004097          	auipc	ra,0x4
    10ac:	42a080e7          	jalr	1066(ra) # 54d2 <exit>
      printf("%s: bigdir unlink failed", s);
    10b0:	85ce                	mv	a1,s3
    10b2:	00005517          	auipc	a0,0x5
    10b6:	08650513          	add	a0,a0,134 # 6138 <malloc+0x846>
    10ba:	00004097          	auipc	ra,0x4
    10be:	780080e7          	jalr	1920(ra) # 583a <printf>
      exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00004097          	auipc	ra,0x4
    10c8:	40e080e7          	jalr	1038(ra) # 54d2 <exit>

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
    10e8:	07498993          	add	s3,s3,116 # 6158 <malloc+0x866>
    10ec:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ee:	6a85                	lui	s5,0x1
    10f0:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f4:	85a6                	mv	a1,s1
    10f6:	854e                	mv	a0,s3
    10f8:	00004097          	auipc	ra,0x4
    10fc:	43a080e7          	jalr	1082(ra) # 5532 <link>
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
    1124:	04850513          	add	a0,a0,72 # 6168 <malloc+0x876>
    1128:	00004097          	auipc	ra,0x4
    112c:	712080e7          	jalr	1810(ra) # 583a <printf>
      exit(1);
    1130:	4505                	li	a0,1
    1132:	00004097          	auipc	ra,0x4
    1136:	3a0080e7          	jalr	928(ra) # 54d2 <exit>

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
    114c:	0104b483          	ld	s1,16(s1) # 8158 <__SDATA_BEGIN__>
    1150:	fd840593          	add	a1,s0,-40
    1154:	8526                	mv	a0,s1
    1156:	00004097          	auipc	ra,0x4
    115a:	3b4080e7          	jalr	948(ra) # 550a <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115e:	8526                	mv	a0,s1
    1160:	00004097          	auipc	ra,0x4
    1164:	382080e7          	jalr	898(ra) # 54e2 <pipe>

  exit(0);
    1168:	4501                	li	a0,0
    116a:	00004097          	auipc	ra,0x4
    116e:	368080e7          	jalr	872(ra) # 54d2 <exit>

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
    1182:	35048493          	add	s1,s1,848 # c350 <buf+0x9c0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1186:	597d                	li	s2,-1
    1188:	02095913          	srl	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118c:	00005997          	auipc	s3,0x5
    1190:	88498993          	add	s3,s3,-1916 # 5a10 <malloc+0x11e>
    argv[0] = (char*)0xffffffff;
    1194:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1198:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119c:	fc040593          	add	a1,s0,-64
    11a0:	854e                	mv	a0,s3
    11a2:	00004097          	auipc	ra,0x4
    11a6:	368080e7          	jalr	872(ra) # 550a <exec>
  for(int i = 0; i < 50000; i++){
    11aa:	34fd                	addw	s1,s1,-1
    11ac:	f4e5                	bnez	s1,1194 <badarg+0x22>
  }
  
  exit(0);
    11ae:	4501                	li	a0,0
    11b0:	00004097          	auipc	ra,0x4
    11b4:	322080e7          	jalr	802(ra) # 54d2 <exit>

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
    11e2:	344080e7          	jalr	836(ra) # 5522 <unlink>
  if(ret != -1){
    11e6:	57fd                	li	a5,-1
    11e8:	0ef51063          	bne	a0,a5,12c8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ec:	20100593          	li	a1,513
    11f0:	f6840513          	add	a0,s0,-152
    11f4:	00004097          	auipc	ra,0x4
    11f8:	31e080e7          	jalr	798(ra) # 5512 <open>
  if(fd != -1){
    11fc:	57fd                	li	a5,-1
    11fe:	0ef51563          	bne	a0,a5,12e8 <copyinstr2+0x130>
  ret = link(b, b);
    1202:	f6840593          	add	a1,s0,-152
    1206:	852e                	mv	a0,a1
    1208:	00004097          	auipc	ra,0x4
    120c:	32a080e7          	jalr	810(ra) # 5532 <link>
  if(ret != -1){
    1210:	57fd                	li	a5,-1
    1212:	0ef51b63          	bne	a0,a5,1308 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1216:	00006797          	auipc	a5,0x6
    121a:	0ca78793          	add	a5,a5,202 # 72e0 <malloc+0x19ee>
    121e:	f4f43c23          	sd	a5,-168(s0)
    1222:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1226:	f5840593          	add	a1,s0,-168
    122a:	f6840513          	add	a0,s0,-152
    122e:	00004097          	auipc	ra,0x4
    1232:	2dc080e7          	jalr	732(ra) # 550a <exec>
  if(ret != -1){
    1236:	57fd                	li	a5,-1
    1238:	0ef51963          	bne	a0,a5,132a <copyinstr2+0x172>
  int pid = fork();
    123c:	00004097          	auipc	ra,0x4
    1240:	28e080e7          	jalr	654(ra) # 54ca <fork>
  if(pid < 0){
    1244:	10054363          	bltz	a0,134a <copyinstr2+0x192>
  if(pid == 0){
    1248:	12051463          	bnez	a0,1370 <copyinstr2+0x1b8>
    124c:	00007797          	auipc	a5,0x7
    1250:	02c78793          	add	a5,a5,44 # 8278 <big.0>
    1254:	00008697          	auipc	a3,0x8
    1258:	02468693          	add	a3,a3,36 # 9278 <__global_pointer$+0x920>
      big[i] = 'x';
    125c:	07800713          	li	a4,120
    1260:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1264:	0785                	add	a5,a5,1
    1266:	fed79de3          	bne	a5,a3,1260 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126a:	00008797          	auipc	a5,0x8
    126e:	00078723          	sb	zero,14(a5) # 9278 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1272:	00007797          	auipc	a5,0x7
    1276:	abe78793          	add	a5,a5,-1346 # 7d30 <malloc+0x243e>
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
    129a:	77a50513          	add	a0,a0,1914 # 5a10 <malloc+0x11e>
    129e:	00004097          	auipc	ra,0x4
    12a2:	26c080e7          	jalr	620(ra) # 550a <exec>
    if(ret != -1){
    12a6:	57fd                	li	a5,-1
    12a8:	0af50e63          	beq	a0,a5,1364 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ac:	55fd                	li	a1,-1
    12ae:	00005517          	auipc	a0,0x5
    12b2:	f6250513          	add	a0,a0,-158 # 6210 <malloc+0x91e>
    12b6:	00004097          	auipc	ra,0x4
    12ba:	584080e7          	jalr	1412(ra) # 583a <printf>
      exit(1);
    12be:	4505                	li	a0,1
    12c0:	00004097          	auipc	ra,0x4
    12c4:	212080e7          	jalr	530(ra) # 54d2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c8:	862a                	mv	a2,a0
    12ca:	f6840593          	add	a1,s0,-152
    12ce:	00005517          	auipc	a0,0x5
    12d2:	eba50513          	add	a0,a0,-326 # 6188 <malloc+0x896>
    12d6:	00004097          	auipc	ra,0x4
    12da:	564080e7          	jalr	1380(ra) # 583a <printf>
    exit(1);
    12de:	4505                	li	a0,1
    12e0:	00004097          	auipc	ra,0x4
    12e4:	1f2080e7          	jalr	498(ra) # 54d2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e8:	862a                	mv	a2,a0
    12ea:	f6840593          	add	a1,s0,-152
    12ee:	00005517          	auipc	a0,0x5
    12f2:	eba50513          	add	a0,a0,-326 # 61a8 <malloc+0x8b6>
    12f6:	00004097          	auipc	ra,0x4
    12fa:	544080e7          	jalr	1348(ra) # 583a <printf>
    exit(1);
    12fe:	4505                	li	a0,1
    1300:	00004097          	auipc	ra,0x4
    1304:	1d2080e7          	jalr	466(ra) # 54d2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1308:	86aa                	mv	a3,a0
    130a:	f6840613          	add	a2,s0,-152
    130e:	85b2                	mv	a1,a2
    1310:	00005517          	auipc	a0,0x5
    1314:	eb850513          	add	a0,a0,-328 # 61c8 <malloc+0x8d6>
    1318:	00004097          	auipc	ra,0x4
    131c:	522080e7          	jalr	1314(ra) # 583a <printf>
    exit(1);
    1320:	4505                	li	a0,1
    1322:	00004097          	auipc	ra,0x4
    1326:	1b0080e7          	jalr	432(ra) # 54d2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132a:	567d                	li	a2,-1
    132c:	f6840593          	add	a1,s0,-152
    1330:	00005517          	auipc	a0,0x5
    1334:	ec050513          	add	a0,a0,-320 # 61f0 <malloc+0x8fe>
    1338:	00004097          	auipc	ra,0x4
    133c:	502080e7          	jalr	1282(ra) # 583a <printf>
    exit(1);
    1340:	4505                	li	a0,1
    1342:	00004097          	auipc	ra,0x4
    1346:	190080e7          	jalr	400(ra) # 54d2 <exit>
    printf("fork failed\n");
    134a:	00005517          	auipc	a0,0x5
    134e:	30e50513          	add	a0,a0,782 # 6658 <malloc+0xd66>
    1352:	00004097          	auipc	ra,0x4
    1356:	4e8080e7          	jalr	1256(ra) # 583a <printf>
    exit(1);
    135a:	4505                	li	a0,1
    135c:	00004097          	auipc	ra,0x4
    1360:	176080e7          	jalr	374(ra) # 54d2 <exit>
    exit(747); // OK
    1364:	2eb00513          	li	a0,747
    1368:	00004097          	auipc	ra,0x4
    136c:	16a080e7          	jalr	362(ra) # 54d2 <exit>
  int st = 0;
    1370:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1374:	f5440513          	add	a0,s0,-172
    1378:	00004097          	auipc	ra,0x4
    137c:	162080e7          	jalr	354(ra) # 54da <wait>
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
    1398:	ea450513          	add	a0,a0,-348 # 6238 <malloc+0x946>
    139c:	00004097          	auipc	ra,0x4
    13a0:	49e080e7          	jalr	1182(ra) # 583a <printf>
    exit(1);
    13a4:	4505                	li	a0,1
    13a6:	00004097          	auipc	ra,0x4
    13aa:	12c080e7          	jalr	300(ra) # 54d2 <exit>

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
    13ca:	6a250513          	add	a0,a0,1698 # 5a68 <malloc+0x176>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	144080e7          	jalr	324(ra) # 5512 <open>
    13d6:	00004097          	auipc	ra,0x4
    13da:	124080e7          	jalr	292(ra) # 54fa <close>
  pid = fork();
    13de:	00004097          	auipc	ra,0x4
    13e2:	0ec080e7          	jalr	236(ra) # 54ca <fork>
  if(pid < 0){
    13e6:	08054063          	bltz	a0,1466 <truncate3+0xb8>
  if(pid == 0){
    13ea:	e969                	bnez	a0,14bc <truncate3+0x10e>
    13ec:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f0:	00004a17          	auipc	s4,0x4
    13f4:	678a0a13          	add	s4,s4,1656 # 5a68 <malloc+0x176>
      int n = write(fd, "1234567890", 10);
    13f8:	00005a97          	auipc	s5,0x5
    13fc:	ea0a8a93          	add	s5,s5,-352 # 6298 <malloc+0x9a6>
      int fd = open("truncfile", O_WRONLY);
    1400:	4585                	li	a1,1
    1402:	8552                	mv	a0,s4
    1404:	00004097          	auipc	ra,0x4
    1408:	10e080e7          	jalr	270(ra) # 5512 <open>
    140c:	84aa                	mv	s1,a0
      if(fd < 0){
    140e:	06054a63          	bltz	a0,1482 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1412:	4629                	li	a2,10
    1414:	85d6                	mv	a1,s5
    1416:	00004097          	auipc	ra,0x4
    141a:	0dc080e7          	jalr	220(ra) # 54f2 <write>
      if(n != 10){
    141e:	47a9                	li	a5,10
    1420:	06f51f63          	bne	a0,a5,149e <truncate3+0xf0>
      close(fd);
    1424:	8526                	mv	a0,s1
    1426:	00004097          	auipc	ra,0x4
    142a:	0d4080e7          	jalr	212(ra) # 54fa <close>
      fd = open("truncfile", O_RDONLY);
    142e:	4581                	li	a1,0
    1430:	8552                	mv	a0,s4
    1432:	00004097          	auipc	ra,0x4
    1436:	0e0080e7          	jalr	224(ra) # 5512 <open>
    143a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143c:	02000613          	li	a2,32
    1440:	f9840593          	add	a1,s0,-104
    1444:	00004097          	auipc	ra,0x4
    1448:	0a6080e7          	jalr	166(ra) # 54ea <read>
      close(fd);
    144c:	8526                	mv	a0,s1
    144e:	00004097          	auipc	ra,0x4
    1452:	0ac080e7          	jalr	172(ra) # 54fa <close>
    for(int i = 0; i < 100; i++){
    1456:	39fd                	addw	s3,s3,-1
    1458:	fa0994e3          	bnez	s3,1400 <truncate3+0x52>
    exit(0);
    145c:	4501                	li	a0,0
    145e:	00004097          	auipc	ra,0x4
    1462:	074080e7          	jalr	116(ra) # 54d2 <exit>
    printf("%s: fork failed\n", s);
    1466:	85ca                	mv	a1,s2
    1468:	00005517          	auipc	a0,0x5
    146c:	e0050513          	add	a0,a0,-512 # 6268 <malloc+0x976>
    1470:	00004097          	auipc	ra,0x4
    1474:	3ca080e7          	jalr	970(ra) # 583a <printf>
    exit(1);
    1478:	4505                	li	a0,1
    147a:	00004097          	auipc	ra,0x4
    147e:	058080e7          	jalr	88(ra) # 54d2 <exit>
        printf("%s: open failed\n", s);
    1482:	85ca                	mv	a1,s2
    1484:	00005517          	auipc	a0,0x5
    1488:	dfc50513          	add	a0,a0,-516 # 6280 <malloc+0x98e>
    148c:	00004097          	auipc	ra,0x4
    1490:	3ae080e7          	jalr	942(ra) # 583a <printf>
        exit(1);
    1494:	4505                	li	a0,1
    1496:	00004097          	auipc	ra,0x4
    149a:	03c080e7          	jalr	60(ra) # 54d2 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149e:	862a                	mv	a2,a0
    14a0:	85ca                	mv	a1,s2
    14a2:	00005517          	auipc	a0,0x5
    14a6:	e0650513          	add	a0,a0,-506 # 62a8 <malloc+0x9b6>
    14aa:	00004097          	auipc	ra,0x4
    14ae:	390080e7          	jalr	912(ra) # 583a <printf>
        exit(1);
    14b2:	4505                	li	a0,1
    14b4:	00004097          	auipc	ra,0x4
    14b8:	01e080e7          	jalr	30(ra) # 54d2 <exit>
    14bc:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c0:	00004a17          	auipc	s4,0x4
    14c4:	5a8a0a13          	add	s4,s4,1448 # 5a68 <malloc+0x176>
    int n = write(fd, "xxx", 3);
    14c8:	00005a97          	auipc	s5,0x5
    14cc:	e00a8a93          	add	s5,s5,-512 # 62c8 <malloc+0x9d6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d0:	60100593          	li	a1,1537
    14d4:	8552                	mv	a0,s4
    14d6:	00004097          	auipc	ra,0x4
    14da:	03c080e7          	jalr	60(ra) # 5512 <open>
    14de:	84aa                	mv	s1,a0
    if(fd < 0){
    14e0:	04054763          	bltz	a0,152e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e4:	460d                	li	a2,3
    14e6:	85d6                	mv	a1,s5
    14e8:	00004097          	auipc	ra,0x4
    14ec:	00a080e7          	jalr	10(ra) # 54f2 <write>
    if(n != 3){
    14f0:	478d                	li	a5,3
    14f2:	04f51c63          	bne	a0,a5,154a <truncate3+0x19c>
    close(fd);
    14f6:	8526                	mv	a0,s1
    14f8:	00004097          	auipc	ra,0x4
    14fc:	002080e7          	jalr	2(ra) # 54fa <close>
  for(int i = 0; i < 150; i++){
    1500:	39fd                	addw	s3,s3,-1
    1502:	fc0997e3          	bnez	s3,14d0 <truncate3+0x122>
  wait(&xstatus);
    1506:	fbc40513          	add	a0,s0,-68
    150a:	00004097          	auipc	ra,0x4
    150e:	fd0080e7          	jalr	-48(ra) # 54da <wait>
  unlink("truncfile");
    1512:	00004517          	auipc	a0,0x4
    1516:	55650513          	add	a0,a0,1366 # 5a68 <malloc+0x176>
    151a:	00004097          	auipc	ra,0x4
    151e:	008080e7          	jalr	8(ra) # 5522 <unlink>
  exit(xstatus);
    1522:	fbc42503          	lw	a0,-68(s0)
    1526:	00004097          	auipc	ra,0x4
    152a:	fac080e7          	jalr	-84(ra) # 54d2 <exit>
      printf("%s: open failed\n", s);
    152e:	85ca                	mv	a1,s2
    1530:	00005517          	auipc	a0,0x5
    1534:	d5050513          	add	a0,a0,-688 # 6280 <malloc+0x98e>
    1538:	00004097          	auipc	ra,0x4
    153c:	302080e7          	jalr	770(ra) # 583a <printf>
      exit(1);
    1540:	4505                	li	a0,1
    1542:	00004097          	auipc	ra,0x4
    1546:	f90080e7          	jalr	-112(ra) # 54d2 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154a:	862a                	mv	a2,a0
    154c:	85ca                	mv	a1,s2
    154e:	00005517          	auipc	a0,0x5
    1552:	d8250513          	add	a0,a0,-638 # 62d0 <malloc+0x9de>
    1556:	00004097          	auipc	ra,0x4
    155a:	2e4080e7          	jalr	740(ra) # 583a <printf>
      exit(1);
    155e:	4505                	li	a0,1
    1560:	00004097          	auipc	ra,0x4
    1564:	f72080e7          	jalr	-142(ra) # 54d2 <exit>

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
    157a:	49a78793          	add	a5,a5,1178 # 5a10 <malloc+0x11e>
    157e:	fcf43023          	sd	a5,-64(s0)
    1582:	00005797          	auipc	a5,0x5
    1586:	d6e78793          	add	a5,a5,-658 # 62f0 <malloc+0x9fe>
    158a:	fcf43423          	sd	a5,-56(s0)
    158e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1592:	00005517          	auipc	a0,0x5
    1596:	d6650513          	add	a0,a0,-666 # 62f8 <malloc+0xa06>
    159a:	00004097          	auipc	ra,0x4
    159e:	f88080e7          	jalr	-120(ra) # 5522 <unlink>
  pid = fork();
    15a2:	00004097          	auipc	ra,0x4
    15a6:	f28080e7          	jalr	-216(ra) # 54ca <fork>
  if(pid < 0) {
    15aa:	04054663          	bltz	a0,15f6 <exectest+0x8e>
    15ae:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b0:	e959                	bnez	a0,1646 <exectest+0xde>
    close(1);
    15b2:	4505                	li	a0,1
    15b4:	00004097          	auipc	ra,0x4
    15b8:	f46080e7          	jalr	-186(ra) # 54fa <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15bc:	20100593          	li	a1,513
    15c0:	00005517          	auipc	a0,0x5
    15c4:	d3850513          	add	a0,a0,-712 # 62f8 <malloc+0xa06>
    15c8:	00004097          	auipc	ra,0x4
    15cc:	f4a080e7          	jalr	-182(ra) # 5512 <open>
    if(fd < 0) {
    15d0:	04054163          	bltz	a0,1612 <exectest+0xaa>
    if(fd != 1) {
    15d4:	4785                	li	a5,1
    15d6:	04f50c63          	beq	a0,a5,162e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15da:	85ca                	mv	a1,s2
    15dc:	00005517          	auipc	a0,0x5
    15e0:	d3c50513          	add	a0,a0,-708 # 6318 <malloc+0xa26>
    15e4:	00004097          	auipc	ra,0x4
    15e8:	256080e7          	jalr	598(ra) # 583a <printf>
      exit(1);
    15ec:	4505                	li	a0,1
    15ee:	00004097          	auipc	ra,0x4
    15f2:	ee4080e7          	jalr	-284(ra) # 54d2 <exit>
     printf("%s: fork failed\n", s);
    15f6:	85ca                	mv	a1,s2
    15f8:	00005517          	auipc	a0,0x5
    15fc:	c7050513          	add	a0,a0,-912 # 6268 <malloc+0x976>
    1600:	00004097          	auipc	ra,0x4
    1604:	23a080e7          	jalr	570(ra) # 583a <printf>
     exit(1);
    1608:	4505                	li	a0,1
    160a:	00004097          	auipc	ra,0x4
    160e:	ec8080e7          	jalr	-312(ra) # 54d2 <exit>
      printf("%s: create failed\n", s);
    1612:	85ca                	mv	a1,s2
    1614:	00005517          	auipc	a0,0x5
    1618:	cec50513          	add	a0,a0,-788 # 6300 <malloc+0xa0e>
    161c:	00004097          	auipc	ra,0x4
    1620:	21e080e7          	jalr	542(ra) # 583a <printf>
      exit(1);
    1624:	4505                	li	a0,1
    1626:	00004097          	auipc	ra,0x4
    162a:	eac080e7          	jalr	-340(ra) # 54d2 <exit>
    if(exec("echo", echoargv) < 0){
    162e:	fc040593          	add	a1,s0,-64
    1632:	00004517          	auipc	a0,0x4
    1636:	3de50513          	add	a0,a0,990 # 5a10 <malloc+0x11e>
    163a:	00004097          	auipc	ra,0x4
    163e:	ed0080e7          	jalr	-304(ra) # 550a <exec>
    1642:	02054163          	bltz	a0,1664 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1646:	fdc40513          	add	a0,s0,-36
    164a:	00004097          	auipc	ra,0x4
    164e:	e90080e7          	jalr	-368(ra) # 54da <wait>
    1652:	02951763          	bne	a0,s1,1680 <exectest+0x118>
  if(xstatus != 0)
    1656:	fdc42503          	lw	a0,-36(s0)
    165a:	cd0d                	beqz	a0,1694 <exectest+0x12c>
    exit(xstatus);
    165c:	00004097          	auipc	ra,0x4
    1660:	e76080e7          	jalr	-394(ra) # 54d2 <exit>
      printf("%s: exec echo failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	cc250513          	add	a0,a0,-830 # 6328 <malloc+0xa36>
    166e:	00004097          	auipc	ra,0x4
    1672:	1cc080e7          	jalr	460(ra) # 583a <printf>
      exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	e5a080e7          	jalr	-422(ra) # 54d2 <exit>
    printf("%s: wait failed!\n", s);
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	cbe50513          	add	a0,a0,-834 # 6340 <malloc+0xa4e>
    168a:	00004097          	auipc	ra,0x4
    168e:	1b0080e7          	jalr	432(ra) # 583a <printf>
    1692:	b7d1                	j	1656 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1694:	4581                	li	a1,0
    1696:	00005517          	auipc	a0,0x5
    169a:	c6250513          	add	a0,a0,-926 # 62f8 <malloc+0xa06>
    169e:	00004097          	auipc	ra,0x4
    16a2:	e74080e7          	jalr	-396(ra) # 5512 <open>
  if(fd < 0) {
    16a6:	02054a63          	bltz	a0,16da <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16aa:	4609                	li	a2,2
    16ac:	fb840593          	add	a1,s0,-72
    16b0:	00004097          	auipc	ra,0x4
    16b4:	e3a080e7          	jalr	-454(ra) # 54ea <read>
    16b8:	4789                	li	a5,2
    16ba:	02f50e63          	beq	a0,a5,16f6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16be:	85ca                	mv	a1,s2
    16c0:	00004517          	auipc	a0,0x4
    16c4:	6f050513          	add	a0,a0,1776 # 5db0 <malloc+0x4be>
    16c8:	00004097          	auipc	ra,0x4
    16cc:	172080e7          	jalr	370(ra) # 583a <printf>
    exit(1);
    16d0:	4505                	li	a0,1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	e00080e7          	jalr	-512(ra) # 54d2 <exit>
    printf("%s: open failed\n", s);
    16da:	85ca                	mv	a1,s2
    16dc:	00005517          	auipc	a0,0x5
    16e0:	ba450513          	add	a0,a0,-1116 # 6280 <malloc+0x98e>
    16e4:	00004097          	auipc	ra,0x4
    16e8:	156080e7          	jalr	342(ra) # 583a <printf>
    exit(1);
    16ec:	4505                	li	a0,1
    16ee:	00004097          	auipc	ra,0x4
    16f2:	de4080e7          	jalr	-540(ra) # 54d2 <exit>
  unlink("echo-ok");
    16f6:	00005517          	auipc	a0,0x5
    16fa:	c0250513          	add	a0,a0,-1022 # 62f8 <malloc+0xa06>
    16fe:	00004097          	auipc	ra,0x4
    1702:	e24080e7          	jalr	-476(ra) # 5522 <unlink>
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
    1724:	c3850513          	add	a0,a0,-968 # 6358 <malloc+0xa66>
    1728:	00004097          	auipc	ra,0x4
    172c:	112080e7          	jalr	274(ra) # 583a <printf>
    exit(1);
    1730:	4505                	li	a0,1
    1732:	00004097          	auipc	ra,0x4
    1736:	da0080e7          	jalr	-608(ra) # 54d2 <exit>
    exit(0);
    173a:	4501                	li	a0,0
    173c:	00004097          	auipc	ra,0x4
    1740:	d96080e7          	jalr	-618(ra) # 54d2 <exit>

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
    1764:	d82080e7          	jalr	-638(ra) # 54e2 <pipe>
    1768:	e93d                	bnez	a0,17de <pipe1+0x9a>
    176a:	84aa                	mv	s1,a0
  pid = fork();
    176c:	00004097          	auipc	ra,0x4
    1770:	d5e080e7          	jalr	-674(ra) # 54ca <fork>
    1774:	8a2a                	mv	s4,a0
  if(pid == 0){
    1776:	c151                	beqz	a0,17fa <pipe1+0xb6>
  } else if(pid > 0){
    1778:	16a05d63          	blez	a0,18f2 <pipe1+0x1ae>
    close(fds[1]);
    177c:	fac42503          	lw	a0,-84(s0)
    1780:	00004097          	auipc	ra,0x4
    1784:	d7a080e7          	jalr	-646(ra) # 54fa <close>
    total = 0;
    1788:	8a26                	mv	s4,s1
    cc = 1;
    178a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178c:	0000aa97          	auipc	s5,0xa
    1790:	204a8a93          	add	s5,s5,516 # b990 <buf>
    1794:	864e                	mv	a2,s3
    1796:	85d6                	mv	a1,s5
    1798:	fa842503          	lw	a0,-88(s0)
    179c:	00004097          	auipc	ra,0x4
    17a0:	d4e080e7          	jalr	-690(ra) # 54ea <read>
    17a4:	10a05263          	blez	a0,18a8 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a8:	0000a717          	auipc	a4,0xa
    17ac:	1e870713          	add	a4,a4,488 # b990 <buf>
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
    17e4:	b9050513          	add	a0,a0,-1136 # 6370 <malloc+0xa7e>
    17e8:	00004097          	auipc	ra,0x4
    17ec:	052080e7          	jalr	82(ra) # 583a <printf>
    exit(1);
    17f0:	4505                	li	a0,1
    17f2:	00004097          	auipc	ra,0x4
    17f6:	ce0080e7          	jalr	-800(ra) # 54d2 <exit>
    close(fds[0]);
    17fa:	fa842503          	lw	a0,-88(s0)
    17fe:	00004097          	auipc	ra,0x4
    1802:	cfc080e7          	jalr	-772(ra) # 54fa <close>
    for(n = 0; n < N; n++){
    1806:	0000ab17          	auipc	s6,0xa
    180a:	18ab0b13          	add	s6,s6,394 # b990 <buf>
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
    1844:	cb2080e7          	jalr	-846(ra) # 54f2 <write>
    1848:	40900793          	li	a5,1033
    184c:	00f51c63          	bne	a0,a5,1864 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1850:	24a5                	addw	s1,s1,9
    1852:	0ff4f493          	zext.b	s1,s1
    1856:	fd5a16e3          	bne	s4,s5,1822 <pipe1+0xde>
    exit(0);
    185a:	4501                	li	a0,0
    185c:	00004097          	auipc	ra,0x4
    1860:	c76080e7          	jalr	-906(ra) # 54d2 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1864:	85ca                	mv	a1,s2
    1866:	00005517          	auipc	a0,0x5
    186a:	b2250513          	add	a0,a0,-1246 # 6388 <malloc+0xa96>
    186e:	00004097          	auipc	ra,0x4
    1872:	fcc080e7          	jalr	-52(ra) # 583a <printf>
        exit(1);
    1876:	4505                	li	a0,1
    1878:	00004097          	auipc	ra,0x4
    187c:	c5a080e7          	jalr	-934(ra) # 54d2 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1880:	85ca                	mv	a1,s2
    1882:	00005517          	auipc	a0,0x5
    1886:	b1e50513          	add	a0,a0,-1250 # 63a0 <malloc+0xaae>
    188a:	00004097          	auipc	ra,0x4
    188e:	fb0080e7          	jalr	-80(ra) # 583a <printf>
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
    18b8:	b0450513          	add	a0,a0,-1276 # 63b8 <malloc+0xac6>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	f7e080e7          	jalr	-130(ra) # 583a <printf>
      exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	c0c080e7          	jalr	-1012(ra) # 54d2 <exit>
    close(fds[0]);
    18ce:	fa842503          	lw	a0,-88(s0)
    18d2:	00004097          	auipc	ra,0x4
    18d6:	c28080e7          	jalr	-984(ra) # 54fa <close>
    wait(&xstatus);
    18da:	fa440513          	add	a0,s0,-92
    18de:	00004097          	auipc	ra,0x4
    18e2:	bfc080e7          	jalr	-1028(ra) # 54da <wait>
    exit(xstatus);
    18e6:	fa442503          	lw	a0,-92(s0)
    18ea:	00004097          	auipc	ra,0x4
    18ee:	be8080e7          	jalr	-1048(ra) # 54d2 <exit>
    printf("%s: fork() failed\n", s);
    18f2:	85ca                	mv	a1,s2
    18f4:	00005517          	auipc	a0,0x5
    18f8:	ae450513          	add	a0,a0,-1308 # 63d8 <malloc+0xae6>
    18fc:	00004097          	auipc	ra,0x4
    1900:	f3e080e7          	jalr	-194(ra) # 583a <printf>
    exit(1);
    1904:	4505                	li	a0,1
    1906:	00004097          	auipc	ra,0x4
    190a:	bcc080e7          	jalr	-1076(ra) # 54d2 <exit>

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
    192a:	ba4080e7          	jalr	-1116(ra) # 54ca <fork>
    192e:	84aa                	mv	s1,a0
    if(pid < 0){
    1930:	02054a63          	bltz	a0,1964 <exitwait+0x56>
    if(pid){
    1934:	c151                	beqz	a0,19b8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1936:	fcc40513          	add	a0,s0,-52
    193a:	00004097          	auipc	ra,0x4
    193e:	ba0080e7          	jalr	-1120(ra) # 54da <wait>
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
    196a:	90250513          	add	a0,a0,-1790 # 6268 <malloc+0x976>
    196e:	00004097          	auipc	ra,0x4
    1972:	ecc080e7          	jalr	-308(ra) # 583a <printf>
      exit(1);
    1976:	4505                	li	a0,1
    1978:	00004097          	auipc	ra,0x4
    197c:	b5a080e7          	jalr	-1190(ra) # 54d2 <exit>
        printf("%s: wait wrong pid\n", s);
    1980:	85d2                	mv	a1,s4
    1982:	00005517          	auipc	a0,0x5
    1986:	a6e50513          	add	a0,a0,-1426 # 63f0 <malloc+0xafe>
    198a:	00004097          	auipc	ra,0x4
    198e:	eb0080e7          	jalr	-336(ra) # 583a <printf>
        exit(1);
    1992:	4505                	li	a0,1
    1994:	00004097          	auipc	ra,0x4
    1998:	b3e080e7          	jalr	-1218(ra) # 54d2 <exit>
        printf("%s: wait wrong exit status\n", s);
    199c:	85d2                	mv	a1,s4
    199e:	00005517          	auipc	a0,0x5
    19a2:	a6a50513          	add	a0,a0,-1430 # 6408 <malloc+0xb16>
    19a6:	00004097          	auipc	ra,0x4
    19aa:	e94080e7          	jalr	-364(ra) # 583a <printf>
        exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00004097          	auipc	ra,0x4
    19b4:	b22080e7          	jalr	-1246(ra) # 54d2 <exit>
      exit(i);
    19b8:	854a                	mv	a0,s2
    19ba:	00004097          	auipc	ra,0x4
    19be:	b18080e7          	jalr	-1256(ra) # 54d2 <exit>

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
    19d8:	af6080e7          	jalr	-1290(ra) # 54ca <fork>
    if(pid1 < 0){
    19dc:	02054c63          	bltz	a0,1a14 <twochildren+0x52>
    if(pid1 == 0){
    19e0:	c921                	beqz	a0,1a30 <twochildren+0x6e>
      int pid2 = fork();
    19e2:	00004097          	auipc	ra,0x4
    19e6:	ae8080e7          	jalr	-1304(ra) # 54ca <fork>
      if(pid2 < 0){
    19ea:	04054763          	bltz	a0,1a38 <twochildren+0x76>
      if(pid2 == 0){
    19ee:	c13d                	beqz	a0,1a54 <twochildren+0x92>
        wait(0);
    19f0:	4501                	li	a0,0
    19f2:	00004097          	auipc	ra,0x4
    19f6:	ae8080e7          	jalr	-1304(ra) # 54da <wait>
        wait(0);
    19fa:	4501                	li	a0,0
    19fc:	00004097          	auipc	ra,0x4
    1a00:	ade080e7          	jalr	-1314(ra) # 54da <wait>
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
    1a16:	00005517          	auipc	a0,0x5
    1a1a:	85250513          	add	a0,a0,-1966 # 6268 <malloc+0x976>
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	e1c080e7          	jalr	-484(ra) # 583a <printf>
      exit(1);
    1a26:	4505                	li	a0,1
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	aaa080e7          	jalr	-1366(ra) # 54d2 <exit>
      exit(0);
    1a30:	00004097          	auipc	ra,0x4
    1a34:	aa2080e7          	jalr	-1374(ra) # 54d2 <exit>
        printf("%s: fork failed\n", s);
    1a38:	85ca                	mv	a1,s2
    1a3a:	00005517          	auipc	a0,0x5
    1a3e:	82e50513          	add	a0,a0,-2002 # 6268 <malloc+0x976>
    1a42:	00004097          	auipc	ra,0x4
    1a46:	df8080e7          	jalr	-520(ra) # 583a <printf>
        exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	a86080e7          	jalr	-1402(ra) # 54d2 <exit>
        exit(0);
    1a54:	00004097          	auipc	ra,0x4
    1a58:	a7e080e7          	jalr	-1410(ra) # 54d2 <exit>

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
    1a6c:	a62080e7          	jalr	-1438(ra) # 54ca <fork>
    if(pid < 0){
    1a70:	04054163          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a74:	cd29                	beqz	a0,1ace <forkfork+0x72>
    int pid = fork();
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	a54080e7          	jalr	-1452(ra) # 54ca <fork>
    if(pid < 0){
    1a7e:	02054a63          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a82:	c531                	beqz	a0,1ace <forkfork+0x72>
    wait(&xstatus);
    1a84:	fdc40513          	add	a0,s0,-36
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	a52080e7          	jalr	-1454(ra) # 54da <wait>
    if(xstatus != 0) {
    1a90:	fdc42783          	lw	a5,-36(s0)
    1a94:	ebbd                	bnez	a5,1b0a <forkfork+0xae>
    wait(&xstatus);
    1a96:	fdc40513          	add	a0,s0,-36
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	a40080e7          	jalr	-1472(ra) # 54da <wait>
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
    1ab8:	97450513          	add	a0,a0,-1676 # 6428 <malloc+0xb36>
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	d7e080e7          	jalr	-642(ra) # 583a <printf>
      exit(1);
    1ac4:	4505                	li	a0,1
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	a0c080e7          	jalr	-1524(ra) # 54d2 <exit>
{
    1ace:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	9f8080e7          	jalr	-1544(ra) # 54ca <fork>
        if(pid1 < 0){
    1ada:	00054f63          	bltz	a0,1af8 <forkfork+0x9c>
        if(pid1 == 0){
    1ade:	c115                	beqz	a0,1b02 <forkfork+0xa6>
        wait(0);
    1ae0:	4501                	li	a0,0
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	9f8080e7          	jalr	-1544(ra) # 54da <wait>
      for(int j = 0; j < 200; j++){
    1aea:	34fd                	addw	s1,s1,-1
    1aec:	f0fd                	bnez	s1,1ad2 <forkfork+0x76>
      exit(0);
    1aee:	4501                	li	a0,0
    1af0:	00004097          	auipc	ra,0x4
    1af4:	9e2080e7          	jalr	-1566(ra) # 54d2 <exit>
          exit(1);
    1af8:	4505                	li	a0,1
    1afa:	00004097          	auipc	ra,0x4
    1afe:	9d8080e7          	jalr	-1576(ra) # 54d2 <exit>
          exit(0);
    1b02:	00004097          	auipc	ra,0x4
    1b06:	9d0080e7          	jalr	-1584(ra) # 54d2 <exit>
      printf("%s: fork in child failed", s);
    1b0a:	85a6                	mv	a1,s1
    1b0c:	00005517          	auipc	a0,0x5
    1b10:	92c50513          	add	a0,a0,-1748 # 6438 <malloc+0xb46>
    1b14:	00004097          	auipc	ra,0x4
    1b18:	d26080e7          	jalr	-730(ra) # 583a <printf>
      exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	9b4080e7          	jalr	-1612(ra) # 54d2 <exit>

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
    1b38:	996080e7          	jalr	-1642(ra) # 54ca <fork>
    if(pid1 < 0){
    1b3c:	00054f63          	bltz	a0,1b5a <reparent2+0x34>
    if(pid1 == 0){
    1b40:	c915                	beqz	a0,1b74 <reparent2+0x4e>
    wait(0);
    1b42:	4501                	li	a0,0
    1b44:	00004097          	auipc	ra,0x4
    1b48:	996080e7          	jalr	-1642(ra) # 54da <wait>
  for(int i = 0; i < 800; i++){
    1b4c:	34fd                	addw	s1,s1,-1
    1b4e:	f0fd                	bnez	s1,1b34 <reparent2+0xe>
  exit(0);
    1b50:	4501                	li	a0,0
    1b52:	00004097          	auipc	ra,0x4
    1b56:	980080e7          	jalr	-1664(ra) # 54d2 <exit>
      printf("fork failed\n");
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	afe50513          	add	a0,a0,-1282 # 6658 <malloc+0xd66>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	cd8080e7          	jalr	-808(ra) # 583a <printf>
      exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	966080e7          	jalr	-1690(ra) # 54d2 <exit>
      fork();
    1b74:	00004097          	auipc	ra,0x4
    1b78:	956080e7          	jalr	-1706(ra) # 54ca <fork>
      fork();
    1b7c:	00004097          	auipc	ra,0x4
    1b80:	94e080e7          	jalr	-1714(ra) # 54ca <fork>
      exit(0);
    1b84:	4501                	li	a0,0
    1b86:	00004097          	auipc	ra,0x4
    1b8a:	94c080e7          	jalr	-1716(ra) # 54d2 <exit>

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
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	91c080e7          	jalr	-1764(ra) # 54ca <fork>
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
    1bca:	00004097          	auipc	ra,0x4
    1bce:	910080e7          	jalr	-1776(ra) # 54da <wait>
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
    1bfc:	a6050513          	add	a0,a0,-1440 # 6658 <malloc+0xd66>
    1c00:	00004097          	auipc	ra,0x4
    1c04:	c3a080e7          	jalr	-966(ra) # 583a <printf>
      exit(1);
    1c08:	4505                	li	a0,1
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	8c8080e7          	jalr	-1848(ra) # 54d2 <exit>
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
    1c28:	6dc50513          	add	a0,a0,1756 # 6300 <malloc+0xa0e>
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	c0e080e7          	jalr	-1010(ra) # 583a <printf>
          exit(1);
    1c34:	4505                	li	a0,1
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	89c080e7          	jalr	-1892(ra) # 54d2 <exit>
      for(i = 0; i < N; i++){
    1c3e:	2485                	addw	s1,s1,1
    1c40:	07248863          	beq	s1,s2,1cb0 <createdelete+0x122>
        name[1] = '0' + i;
    1c44:	0304879b          	addw	a5,s1,48
    1c48:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4c:	20200593          	li	a1,514
    1c50:	f8040513          	add	a0,s0,-128
    1c54:	00004097          	auipc	ra,0x4
    1c58:	8be080e7          	jalr	-1858(ra) # 5512 <open>
        if(fd < 0){
    1c5c:	fc0543e3          	bltz	a0,1c22 <createdelete+0x94>
        close(fd);
    1c60:	00004097          	auipc	ra,0x4
    1c64:	89a080e7          	jalr	-1894(ra) # 54fa <close>
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
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	89a080e7          	jalr	-1894(ra) # 5522 <unlink>
    1c90:	fa0557e3          	bgez	a0,1c3e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c94:	85e6                	mv	a1,s9
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	7c250513          	add	a0,a0,1986 # 6458 <malloc+0xb66>
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	b9c080e7          	jalr	-1124(ra) # 583a <printf>
            exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	00004097          	auipc	ra,0x4
    1cac:	82a080e7          	jalr	-2006(ra) # 54d2 <exit>
      exit(0);
    1cb0:	4501                	li	a0,0
    1cb2:	00004097          	auipc	ra,0x4
    1cb6:	820080e7          	jalr	-2016(ra) # 54d2 <exit>
      exit(1);
    1cba:	4505                	li	a0,1
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	816080e7          	jalr	-2026(ra) # 54d2 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc4:	f8040613          	add	a2,s0,-128
    1cc8:	85e6                	mv	a1,s9
    1cca:	00004517          	auipc	a0,0x4
    1cce:	7a650513          	add	a0,a0,1958 # 6470 <malloc+0xb7e>
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	b68080e7          	jalr	-1176(ra) # 583a <printf>
        exit(1);
    1cda:	4505                	li	a0,1
    1cdc:	00003097          	auipc	ra,0x3
    1ce0:	7f6080e7          	jalr	2038(ra) # 54d2 <exit>
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
    1d04:	00004097          	auipc	ra,0x4
    1d08:	80e080e7          	jalr	-2034(ra) # 5512 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0c:	00090463          	beqz	s2,1d14 <createdelete+0x186>
    1d10:	fd2bdae3          	bge	s7,s2,1ce4 <createdelete+0x156>
    1d14:	fa0548e3          	bltz	a0,1cc4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d18:	014b7963          	bgeu	s6,s4,1d2a <createdelete+0x19c>
        close(fd);
    1d1c:	00003097          	auipc	ra,0x3
    1d20:	7de080e7          	jalr	2014(ra) # 54fa <close>
    1d24:	b7e1                	j	1cec <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d26:	fc0543e3          	bltz	a0,1cec <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2a:	f8040613          	add	a2,s0,-128
    1d2e:	85e6                	mv	a1,s9
    1d30:	00004517          	auipc	a0,0x4
    1d34:	76850513          	add	a0,a0,1896 # 6498 <malloc+0xba6>
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	b02080e7          	jalr	-1278(ra) # 583a <printf>
        exit(1);
    1d40:	4505                	li	a0,1
    1d42:	00003097          	auipc	ra,0x3
    1d46:	790080e7          	jalr	1936(ra) # 54d2 <exit>
  for(i = 0; i < N; i++){
    1d4a:	2905                	addw	s2,s2,1
    1d4c:	2a05                	addw	s4,s4,1
    1d4e:	2985                	addw	s3,s3,1 # 3001 <subdir+0x1d3>
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
    1d80:	7a6080e7          	jalr	1958(ra) # 5522 <unlink>
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
    1dd4:	cb050513          	add	a0,a0,-848 # 5a80 <malloc+0x18e>
    1dd8:	00003097          	auipc	ra,0x3
    1ddc:	74a080e7          	jalr	1866(ra) # 5522 <unlink>
  pid = fork();
    1de0:	00003097          	auipc	ra,0x3
    1de4:	6ea080e7          	jalr	1770(ra) # 54ca <fork>
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
    1dfe:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c564cd>
    1e02:	690d                	lui	s2,0x3
    1e04:	0399091b          	addw	s2,s2,57 # 3039 <subdir+0x20b>
    if((x % 3) == 0){
    1e08:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0a:	4b05                	li	s6,1
      unlink("x");
    1e0c:	00004a97          	auipc	s5,0x4
    1e10:	c74a8a93          	add	s5,s5,-908 # 5a80 <malloc+0x18e>
      link("cat", "x");
    1e14:	00004b97          	auipc	s7,0x4
    1e18:	6acb8b93          	add	s7,s7,1708 # 64c0 <malloc+0xbce>
    1e1c:	a825                	j	1e54 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1e:	85a6                	mv	a1,s1
    1e20:	00004517          	auipc	a0,0x4
    1e24:	44850513          	add	a0,a0,1096 # 6268 <malloc+0x976>
    1e28:	00004097          	auipc	ra,0x4
    1e2c:	a12080e7          	jalr	-1518(ra) # 583a <printf>
    exit(1);
    1e30:	4505                	li	a0,1
    1e32:	00003097          	auipc	ra,0x3
    1e36:	6a0080e7          	jalr	1696(ra) # 54d2 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3a:	20200593          	li	a1,514
    1e3e:	8556                	mv	a0,s5
    1e40:	00003097          	auipc	ra,0x3
    1e44:	6d2080e7          	jalr	1746(ra) # 5512 <open>
    1e48:	00003097          	auipc	ra,0x3
    1e4c:	6b2080e7          	jalr	1714(ra) # 54fa <close>
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
    1e70:	6b6080e7          	jalr	1718(ra) # 5522 <unlink>
    1e74:	bff1                	j	1e50 <linkunlink+0x9c>
      link("cat", "x");
    1e76:	85d6                	mv	a1,s5
    1e78:	855e                	mv	a0,s7
    1e7a:	00003097          	auipc	ra,0x3
    1e7e:	6b8080e7          	jalr	1720(ra) # 5532 <link>
    1e82:	b7f9                	j	1e50 <linkunlink+0x9c>
  if(pid)
    1e84:	020c0463          	beqz	s8,1eac <linkunlink+0xf8>
    wait(0);
    1e88:	4501                	li	a0,0
    1e8a:	00003097          	auipc	ra,0x3
    1e8e:	650080e7          	jalr	1616(ra) # 54da <wait>
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
    1eb2:	624080e7          	jalr	1572(ra) # 54d2 <exit>

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
    1ed0:	5fe080e7          	jalr	1534(ra) # 54ca <fork>
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
    1ee6:	5fe50513          	add	a0,a0,1534 # 64e0 <malloc+0xbee>
    1eea:	00004097          	auipc	ra,0x4
    1eee:	950080e7          	jalr	-1712(ra) # 583a <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	00003097          	auipc	ra,0x3
    1ef8:	5de080e7          	jalr	1502(ra) # 54d2 <exit>
      exit(0);
    1efc:	00003097          	auipc	ra,0x3
    1f00:	5d6080e7          	jalr	1494(ra) # 54d2 <exit>
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
    1f18:	5c6080e7          	jalr	1478(ra) # 54da <wait>
    1f1c:	04054163          	bltz	a0,1f5e <forktest+0xa8>
  for(; n > 0; n--){
    1f20:	34fd                	addw	s1,s1,-1
    1f22:	f8e5                	bnez	s1,1f12 <forktest+0x5c>
  if(wait(0) != -1){
    1f24:	4501                	li	a0,0
    1f26:	00003097          	auipc	ra,0x3
    1f2a:	5b4080e7          	jalr	1460(ra) # 54da <wait>
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
    1f48:	58450513          	add	a0,a0,1412 # 64c8 <malloc+0xbd6>
    1f4c:	00004097          	auipc	ra,0x4
    1f50:	8ee080e7          	jalr	-1810(ra) # 583a <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	00003097          	auipc	ra,0x3
    1f5a:	57c080e7          	jalr	1404(ra) # 54d2 <exit>
      printf("%s: wait stopped early\n", s);
    1f5e:	85ce                	mv	a1,s3
    1f60:	00004517          	auipc	a0,0x4
    1f64:	5a850513          	add	a0,a0,1448 # 6508 <malloc+0xc16>
    1f68:	00004097          	auipc	ra,0x4
    1f6c:	8d2080e7          	jalr	-1838(ra) # 583a <printf>
      exit(1);
    1f70:	4505                	li	a0,1
    1f72:	00003097          	auipc	ra,0x3
    1f76:	560080e7          	jalr	1376(ra) # 54d2 <exit>
    printf("%s: wait got too many\n", s);
    1f7a:	85ce                	mv	a1,s3
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	5a450513          	add	a0,a0,1444 # 6520 <malloc+0xc2e>
    1f84:	00004097          	auipc	ra,0x4
    1f88:	8b6080e7          	jalr	-1866(ra) # 583a <printf>
    exit(1);
    1f8c:	4505                	li	a0,1
    1f8e:	00003097          	auipc	ra,0x3
    1f92:	544080e7          	jalr	1348(ra) # 54d2 <exit>

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
    1fb2:	35098993          	add	s3,s3,848 # c350 <buf+0x9c0>
    1fb6:	1003d937          	lui	s2,0x1003d
    1fba:	090e                	sll	s2,s2,0x3
    1fbc:	48090913          	add	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eae0>
    pid = fork();
    1fc0:	00003097          	auipc	ra,0x3
    1fc4:	50a080e7          	jalr	1290(ra) # 54ca <fork>
    if(pid < 0){
    1fc8:	02054963          	bltz	a0,1ffa <kernmem+0x64>
    if(pid == 0){
    1fcc:	c529                	beqz	a0,2016 <kernmem+0x80>
    wait(&xstatus);
    1fce:	fbc40513          	add	a0,s0,-68
    1fd2:	00003097          	auipc	ra,0x3
    1fd6:	508080e7          	jalr	1288(ra) # 54da <wait>
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
    2000:	26c50513          	add	a0,a0,620 # 6268 <malloc+0x976>
    2004:	00004097          	auipc	ra,0x4
    2008:	836080e7          	jalr	-1994(ra) # 583a <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00003097          	auipc	ra,0x3
    2012:	4c4080e7          	jalr	1220(ra) # 54d2 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    2016:	0004c603          	lbu	a2,0(s1)
    201a:	85a6                	mv	a1,s1
    201c:	00004517          	auipc	a0,0x4
    2020:	51c50513          	add	a0,a0,1308 # 6538 <malloc+0xc46>
    2024:	00004097          	auipc	ra,0x4
    2028:	816080e7          	jalr	-2026(ra) # 583a <printf>
      exit(1);
    202c:	4505                	li	a0,1
    202e:	00003097          	auipc	ra,0x3
    2032:	4a4080e7          	jalr	1188(ra) # 54d2 <exit>
      exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	49a080e7          	jalr	1178(ra) # 54d2 <exit>

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
    2050:	50c50513          	add	a0,a0,1292 # 6558 <malloc+0xc66>
    2054:	00003097          	auipc	ra,0x3
    2058:	4ce080e7          	jalr	1230(ra) # 5522 <unlink>
  pid = fork();
    205c:	00003097          	auipc	ra,0x3
    2060:	46e080e7          	jalr	1134(ra) # 54ca <fork>
  if(pid == 0){
    2064:	c121                	beqz	a0,20a4 <bigargtest+0x64>
  } else if(pid < 0){
    2066:	0a054063          	bltz	a0,2106 <bigargtest+0xc6>
  wait(&xstatus);
    206a:	fdc40513          	add	a0,s0,-36
    206e:	00003097          	auipc	ra,0x3
    2072:	46c080e7          	jalr	1132(ra) # 54da <wait>
  if(xstatus != 0)
    2076:	fdc42503          	lw	a0,-36(s0)
    207a:	e545                	bnez	a0,2122 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    207c:	4581                	li	a1,0
    207e:	00004517          	auipc	a0,0x4
    2082:	4da50513          	add	a0,a0,1242 # 6558 <malloc+0xc66>
    2086:	00003097          	auipc	ra,0x3
    208a:	48c080e7          	jalr	1164(ra) # 5512 <open>
  if(fd < 0){
    208e:	08054e63          	bltz	a0,212a <bigargtest+0xea>
  close(fd);
    2092:	00003097          	auipc	ra,0x3
    2096:	468080e7          	jalr	1128(ra) # 54fa <close>
}
    209a:	70a2                	ld	ra,40(sp)
    209c:	7402                	ld	s0,32(sp)
    209e:	64e2                	ld	s1,24(sp)
    20a0:	6145                	add	sp,sp,48
    20a2:	8082                	ret
    20a4:	00006797          	auipc	a5,0x6
    20a8:	0d478793          	add	a5,a5,212 # 8178 <args.1>
    20ac:	00006697          	auipc	a3,0x6
    20b0:	1c468693          	add	a3,a3,452 # 8270 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b4:	00004717          	auipc	a4,0x4
    20b8:	4b470713          	add	a4,a4,1204 # 6568 <malloc+0xc76>
    20bc:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20be:	07a1                	add	a5,a5,8
    20c0:	fed79ee3          	bne	a5,a3,20bc <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c4:	00006597          	auipc	a1,0x6
    20c8:	0b458593          	add	a1,a1,180 # 8178 <args.1>
    20cc:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d0:	00004517          	auipc	a0,0x4
    20d4:	94050513          	add	a0,a0,-1728 # 5a10 <malloc+0x11e>
    20d8:	00003097          	auipc	ra,0x3
    20dc:	432080e7          	jalr	1074(ra) # 550a <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e0:	20000593          	li	a1,512
    20e4:	00004517          	auipc	a0,0x4
    20e8:	47450513          	add	a0,a0,1140 # 6558 <malloc+0xc66>
    20ec:	00003097          	auipc	ra,0x3
    20f0:	426080e7          	jalr	1062(ra) # 5512 <open>
    close(fd);
    20f4:	00003097          	auipc	ra,0x3
    20f8:	406080e7          	jalr	1030(ra) # 54fa <close>
    exit(0);
    20fc:	4501                	li	a0,0
    20fe:	00003097          	auipc	ra,0x3
    2102:	3d4080e7          	jalr	980(ra) # 54d2 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2106:	85a6                	mv	a1,s1
    2108:	00004517          	auipc	a0,0x4
    210c:	54050513          	add	a0,a0,1344 # 6648 <malloc+0xd56>
    2110:	00003097          	auipc	ra,0x3
    2114:	72a080e7          	jalr	1834(ra) # 583a <printf>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	00003097          	auipc	ra,0x3
    211e:	3b8080e7          	jalr	952(ra) # 54d2 <exit>
    exit(xstatus);
    2122:	00003097          	auipc	ra,0x3
    2126:	3b0080e7          	jalr	944(ra) # 54d2 <exit>
    printf("%s: bigarg test failed!\n", s);
    212a:	85a6                	mv	a1,s1
    212c:	00004517          	auipc	a0,0x4
    2130:	53c50513          	add	a0,a0,1340 # 6668 <malloc+0xd76>
    2134:	00003097          	auipc	ra,0x3
    2138:	706080e7          	jalr	1798(ra) # 583a <printf>
    exit(1);
    213c:	4505                	li	a0,1
    213e:	00003097          	auipc	ra,0x3
    2142:	394080e7          	jalr	916(ra) # 54d2 <exit>

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
    2156:	378080e7          	jalr	888(ra) # 54ca <fork>
  if(pid == 0) {
    215a:	c115                	beqz	a0,217e <stacktest+0x38>
  } else if(pid < 0){
    215c:	04054363          	bltz	a0,21a2 <stacktest+0x5c>
  wait(&xstatus);
    2160:	fdc40513          	add	a0,s0,-36
    2164:	00003097          	auipc	ra,0x3
    2168:	376080e7          	jalr	886(ra) # 54da <wait>
  if(xstatus == -1)  // kernel killed child?
    216c:	fdc42503          	lw	a0,-36(s0)
    2170:	57fd                	li	a5,-1
    2172:	04f50663          	beq	a0,a5,21be <stacktest+0x78>
    exit(xstatus);
    2176:	00003097          	auipc	ra,0x3
    217a:	35c080e7          	jalr	860(ra) # 54d2 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    217e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2180:	77fd                	lui	a5,0xfffff
    2182:	97ba                	add	a5,a5,a4
    2184:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0660>
    2188:	00004517          	auipc	a0,0x4
    218c:	50050513          	add	a0,a0,1280 # 6688 <malloc+0xd96>
    2190:	00003097          	auipc	ra,0x3
    2194:	6aa080e7          	jalr	1706(ra) # 583a <printf>
    exit(1);
    2198:	4505                	li	a0,1
    219a:	00003097          	auipc	ra,0x3
    219e:	338080e7          	jalr	824(ra) # 54d2 <exit>
    printf("%s: fork failed\n", s);
    21a2:	85a6                	mv	a1,s1
    21a4:	00004517          	auipc	a0,0x4
    21a8:	0c450513          	add	a0,a0,196 # 6268 <malloc+0x976>
    21ac:	00003097          	auipc	ra,0x3
    21b0:	68e080e7          	jalr	1678(ra) # 583a <printf>
    exit(1);
    21b4:	4505                	li	a0,1
    21b6:	00003097          	auipc	ra,0x3
    21ba:	31c080e7          	jalr	796(ra) # 54d2 <exit>
    exit(0);
    21be:	4501                	li	a0,0
    21c0:	00003097          	auipc	ra,0x3
    21c4:	312080e7          	jalr	786(ra) # 54d2 <exit>

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
    21d8:	386080e7          	jalr	902(ra) # 555a <sbrk>
  uint64 top = (uint64) sbrk(0);
    21dc:	4501                	li	a0,0
    21de:	00003097          	auipc	ra,0x3
    21e2:	37c080e7          	jalr	892(ra) # 555a <sbrk>
  if((top % PGSIZE) != 0){
    21e6:	03451793          	sll	a5,a0,0x34
    21ea:	e3c9                	bnez	a5,226c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21ec:	4501                	li	a0,0
    21ee:	00003097          	auipc	ra,0x3
    21f2:	36c080e7          	jalr	876(ra) # 555a <sbrk>
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
    220e:	318080e7          	jalr	792(ra) # 5522 <unlink>
  if(ret != -1){
    2212:	57fd                	li	a5,-1
    2214:	08f51363          	bne	a0,a5,229a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2218:	20100593          	li	a1,513
    221c:	8526                	mv	a0,s1
    221e:	00003097          	auipc	ra,0x3
    2222:	2f4080e7          	jalr	756(ra) # 5512 <open>
  if(fd != -1){
    2226:	57fd                	li	a5,-1
    2228:	08f51863          	bne	a0,a5,22b8 <copyinstr3+0xf0>
  ret = link(b, b);
    222c:	85a6                	mv	a1,s1
    222e:	8526                	mv	a0,s1
    2230:	00003097          	auipc	ra,0x3
    2234:	302080e7          	jalr	770(ra) # 5532 <link>
  if(ret != -1){
    2238:	57fd                	li	a5,-1
    223a:	08f51e63          	bne	a0,a5,22d6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    223e:	00005797          	auipc	a5,0x5
    2242:	0a278793          	add	a5,a5,162 # 72e0 <malloc+0x19ee>
    2246:	fcf43823          	sd	a5,-48(s0)
    224a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    224e:	fd040593          	add	a1,s0,-48
    2252:	8526                	mv	a0,s1
    2254:	00003097          	auipc	ra,0x3
    2258:	2b6080e7          	jalr	694(ra) # 550a <exec>
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
    227a:	2e4080e7          	jalr	740(ra) # 555a <sbrk>
    227e:	b7bd                	j	21ec <copyinstr3+0x24>
    printf("oops\n");
    2280:	00004517          	auipc	a0,0x4
    2284:	43050513          	add	a0,a0,1072 # 66b0 <malloc+0xdbe>
    2288:	00003097          	auipc	ra,0x3
    228c:	5b2080e7          	jalr	1458(ra) # 583a <printf>
    exit(1);
    2290:	4505                	li	a0,1
    2292:	00003097          	auipc	ra,0x3
    2296:	240080e7          	jalr	576(ra) # 54d2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229a:	862a                	mv	a2,a0
    229c:	85a6                	mv	a1,s1
    229e:	00004517          	auipc	a0,0x4
    22a2:	eea50513          	add	a0,a0,-278 # 6188 <malloc+0x896>
    22a6:	00003097          	auipc	ra,0x3
    22aa:	594080e7          	jalr	1428(ra) # 583a <printf>
    exit(1);
    22ae:	4505                	li	a0,1
    22b0:	00003097          	auipc	ra,0x3
    22b4:	222080e7          	jalr	546(ra) # 54d2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22b8:	862a                	mv	a2,a0
    22ba:	85a6                	mv	a1,s1
    22bc:	00004517          	auipc	a0,0x4
    22c0:	eec50513          	add	a0,a0,-276 # 61a8 <malloc+0x8b6>
    22c4:	00003097          	auipc	ra,0x3
    22c8:	576080e7          	jalr	1398(ra) # 583a <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	00003097          	auipc	ra,0x3
    22d2:	204080e7          	jalr	516(ra) # 54d2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22d6:	86aa                	mv	a3,a0
    22d8:	8626                	mv	a2,s1
    22da:	85a6                	mv	a1,s1
    22dc:	00004517          	auipc	a0,0x4
    22e0:	eec50513          	add	a0,a0,-276 # 61c8 <malloc+0x8d6>
    22e4:	00003097          	auipc	ra,0x3
    22e8:	556080e7          	jalr	1366(ra) # 583a <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	00003097          	auipc	ra,0x3
    22f2:	1e4080e7          	jalr	484(ra) # 54d2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22f6:	567d                	li	a2,-1
    22f8:	85a6                	mv	a1,s1
    22fa:	00004517          	auipc	a0,0x4
    22fe:	ef650513          	add	a0,a0,-266 # 61f0 <malloc+0x8fe>
    2302:	00003097          	auipc	ra,0x3
    2306:	538080e7          	jalr	1336(ra) # 583a <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	1c6080e7          	jalr	454(ra) # 54d2 <exit>

0000000000002314 <rwsbrk>:
{
    2314:	1101                	add	sp,sp,-32
    2316:	ec06                	sd	ra,24(sp)
    2318:	e822                	sd	s0,16(sp)
    231a:	e426                	sd	s1,8(sp)
    231c:	e04a                	sd	s2,0(sp)
    231e:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2320:	6509                	lui	a0,0x2
    2322:	00003097          	auipc	ra,0x3
    2326:	238080e7          	jalr	568(ra) # 555a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    232a:	57fd                	li	a5,-1
    232c:	06f50263          	beq	a0,a5,2390 <rwsbrk+0x7c>
    2330:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2332:	7579                	lui	a0,0xffffe
    2334:	00003097          	auipc	ra,0x3
    2338:	226080e7          	jalr	550(ra) # 555a <sbrk>
    233c:	57fd                	li	a5,-1
    233e:	06f50663          	beq	a0,a5,23aa <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2342:	20100593          	li	a1,513
    2346:	00004517          	auipc	a0,0x4
    234a:	3aa50513          	add	a0,a0,938 # 66f0 <malloc+0xdfe>
    234e:	00003097          	auipc	ra,0x3
    2352:	1c4080e7          	jalr	452(ra) # 5512 <open>
    2356:	892a                	mv	s2,a0
  if(fd < 0){
    2358:	06054663          	bltz	a0,23c4 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    235c:	6785                	lui	a5,0x1
    235e:	94be                	add	s1,s1,a5
    2360:	40000613          	li	a2,1024
    2364:	85a6                	mv	a1,s1
    2366:	00003097          	auipc	ra,0x3
    236a:	18c080e7          	jalr	396(ra) # 54f2 <write>
    236e:	862a                	mv	a2,a0
  if(n >= 0){
    2370:	06054763          	bltz	a0,23de <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2374:	85a6                	mv	a1,s1
    2376:	00004517          	auipc	a0,0x4
    237a:	39a50513          	add	a0,a0,922 # 6710 <malloc+0xe1e>
    237e:	00003097          	auipc	ra,0x3
    2382:	4bc080e7          	jalr	1212(ra) # 583a <printf>
    exit(1);
    2386:	4505                	li	a0,1
    2388:	00003097          	auipc	ra,0x3
    238c:	14a080e7          	jalr	330(ra) # 54d2 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2390:	00004517          	auipc	a0,0x4
    2394:	32850513          	add	a0,a0,808 # 66b8 <malloc+0xdc6>
    2398:	00003097          	auipc	ra,0x3
    239c:	4a2080e7          	jalr	1186(ra) # 583a <printf>
    exit(1);
    23a0:	4505                	li	a0,1
    23a2:	00003097          	auipc	ra,0x3
    23a6:	130080e7          	jalr	304(ra) # 54d2 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    23aa:	00004517          	auipc	a0,0x4
    23ae:	32650513          	add	a0,a0,806 # 66d0 <malloc+0xdde>
    23b2:	00003097          	auipc	ra,0x3
    23b6:	488080e7          	jalr	1160(ra) # 583a <printf>
    exit(1);
    23ba:	4505                	li	a0,1
    23bc:	00003097          	auipc	ra,0x3
    23c0:	116080e7          	jalr	278(ra) # 54d2 <exit>
    printf("open(rwsbrk) failed\n");
    23c4:	00004517          	auipc	a0,0x4
    23c8:	33450513          	add	a0,a0,820 # 66f8 <malloc+0xe06>
    23cc:	00003097          	auipc	ra,0x3
    23d0:	46e080e7          	jalr	1134(ra) # 583a <printf>
    exit(1);
    23d4:	4505                	li	a0,1
    23d6:	00003097          	auipc	ra,0x3
    23da:	0fc080e7          	jalr	252(ra) # 54d2 <exit>
  close(fd);
    23de:	854a                	mv	a0,s2
    23e0:	00003097          	auipc	ra,0x3
    23e4:	11a080e7          	jalr	282(ra) # 54fa <close>
  unlink("rwsbrk");
    23e8:	00004517          	auipc	a0,0x4
    23ec:	30850513          	add	a0,a0,776 # 66f0 <malloc+0xdfe>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	132080e7          	jalr	306(ra) # 5522 <unlink>
  fd = open("README", O_RDONLY);
    23f8:	4581                	li	a1,0
    23fa:	00003517          	auipc	a0,0x3
    23fe:	7be50513          	add	a0,a0,1982 # 5bb8 <malloc+0x2c6>
    2402:	00003097          	auipc	ra,0x3
    2406:	110080e7          	jalr	272(ra) # 5512 <open>
    240a:	892a                	mv	s2,a0
  if(fd < 0){
    240c:	02054963          	bltz	a0,243e <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2410:	4629                	li	a2,10
    2412:	85a6                	mv	a1,s1
    2414:	00003097          	auipc	ra,0x3
    2418:	0d6080e7          	jalr	214(ra) # 54ea <read>
    241c:	862a                	mv	a2,a0
  if(n >= 0){
    241e:	02054d63          	bltz	a0,2458 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2422:	85a6                	mv	a1,s1
    2424:	00004517          	auipc	a0,0x4
    2428:	31c50513          	add	a0,a0,796 # 6740 <malloc+0xe4e>
    242c:	00003097          	auipc	ra,0x3
    2430:	40e080e7          	jalr	1038(ra) # 583a <printf>
    exit(1);
    2434:	4505                	li	a0,1
    2436:	00003097          	auipc	ra,0x3
    243a:	09c080e7          	jalr	156(ra) # 54d2 <exit>
    printf("open(rwsbrk) failed\n");
    243e:	00004517          	auipc	a0,0x4
    2442:	2ba50513          	add	a0,a0,698 # 66f8 <malloc+0xe06>
    2446:	00003097          	auipc	ra,0x3
    244a:	3f4080e7          	jalr	1012(ra) # 583a <printf>
    exit(1);
    244e:	4505                	li	a0,1
    2450:	00003097          	auipc	ra,0x3
    2454:	082080e7          	jalr	130(ra) # 54d2 <exit>
  close(fd);
    2458:	854a                	mv	a0,s2
    245a:	00003097          	auipc	ra,0x3
    245e:	0a0080e7          	jalr	160(ra) # 54fa <close>
  exit(0);
    2462:	4501                	li	a0,0
    2464:	00003097          	auipc	ra,0x3
    2468:	06e080e7          	jalr	110(ra) # 54d2 <exit>

000000000000246c <sbrkbasic>:
{
    246c:	7139                	add	sp,sp,-64
    246e:	fc06                	sd	ra,56(sp)
    2470:	f822                	sd	s0,48(sp)
    2472:	f426                	sd	s1,40(sp)
    2474:	f04a                	sd	s2,32(sp)
    2476:	ec4e                	sd	s3,24(sp)
    2478:	e852                	sd	s4,16(sp)
    247a:	0080                	add	s0,sp,64
    247c:	8a2a                	mv	s4,a0
  pid = fork();
    247e:	00003097          	auipc	ra,0x3
    2482:	04c080e7          	jalr	76(ra) # 54ca <fork>
  if(pid < 0){
    2486:	02054c63          	bltz	a0,24be <sbrkbasic+0x52>
  if(pid == 0){
    248a:	ed21                	bnez	a0,24e2 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    248c:	40000537          	lui	a0,0x40000
    2490:	00003097          	auipc	ra,0x3
    2494:	0ca080e7          	jalr	202(ra) # 555a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2498:	57fd                	li	a5,-1
    249a:	02f50f63          	beq	a0,a5,24d8 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    249e:	400007b7          	lui	a5,0x40000
    24a2:	97aa                	add	a5,a5,a0
      *b = 99;
    24a4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    24a8:	6705                	lui	a4,0x1
      *b = 99;
    24aa:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1660>
    for(b = a; b < a+TOOMUCH; b += 4096){
    24ae:	953a                	add	a0,a0,a4
    24b0:	fef51de3          	bne	a0,a5,24aa <sbrkbasic+0x3e>
    exit(1);
    24b4:	4505                	li	a0,1
    24b6:	00003097          	auipc	ra,0x3
    24ba:	01c080e7          	jalr	28(ra) # 54d2 <exit>
    printf("fork failed in sbrkbasic\n");
    24be:	00004517          	auipc	a0,0x4
    24c2:	2aa50513          	add	a0,a0,682 # 6768 <malloc+0xe76>
    24c6:	00003097          	auipc	ra,0x3
    24ca:	374080e7          	jalr	884(ra) # 583a <printf>
    exit(1);
    24ce:	4505                	li	a0,1
    24d0:	00003097          	auipc	ra,0x3
    24d4:	002080e7          	jalr	2(ra) # 54d2 <exit>
      exit(0);
    24d8:	4501                	li	a0,0
    24da:	00003097          	auipc	ra,0x3
    24de:	ff8080e7          	jalr	-8(ra) # 54d2 <exit>
  wait(&xstatus);
    24e2:	fcc40513          	add	a0,s0,-52
    24e6:	00003097          	auipc	ra,0x3
    24ea:	ff4080e7          	jalr	-12(ra) # 54da <wait>
  if(xstatus == 1){
    24ee:	fcc42703          	lw	a4,-52(s0)
    24f2:	4785                	li	a5,1
    24f4:	00f70d63          	beq	a4,a5,250e <sbrkbasic+0xa2>
  a = sbrk(0);
    24f8:	4501                	li	a0,0
    24fa:	00003097          	auipc	ra,0x3
    24fe:	060080e7          	jalr	96(ra) # 555a <sbrk>
    2502:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2504:	4901                	li	s2,0
    2506:	6985                	lui	s3,0x1
    2508:	38898993          	add	s3,s3,904 # 1388 <copyinstr2+0x1d0>
    250c:	a005                	j	252c <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    250e:	85d2                	mv	a1,s4
    2510:	00004517          	auipc	a0,0x4
    2514:	27850513          	add	a0,a0,632 # 6788 <malloc+0xe96>
    2518:	00003097          	auipc	ra,0x3
    251c:	322080e7          	jalr	802(ra) # 583a <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	fb0080e7          	jalr	-80(ra) # 54d2 <exit>
    a = b + 1;
    252a:	84be                	mv	s1,a5
    b = sbrk(1);
    252c:	4505                	li	a0,1
    252e:	00003097          	auipc	ra,0x3
    2532:	02c080e7          	jalr	44(ra) # 555a <sbrk>
    if(b != a){
    2536:	04951c63          	bne	a0,s1,258e <sbrkbasic+0x122>
    *b = 1;
    253a:	4785                	li	a5,1
    253c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2540:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    2544:	2905                	addw	s2,s2,1
    2546:	ff3912e3          	bne	s2,s3,252a <sbrkbasic+0xbe>
  pid = fork();
    254a:	00003097          	auipc	ra,0x3
    254e:	f80080e7          	jalr	-128(ra) # 54ca <fork>
    2552:	892a                	mv	s2,a0
  if(pid < 0){
    2554:	04054d63          	bltz	a0,25ae <sbrkbasic+0x142>
  c = sbrk(1);
    2558:	4505                	li	a0,1
    255a:	00003097          	auipc	ra,0x3
    255e:	000080e7          	jalr	ra # 555a <sbrk>
  c = sbrk(1);
    2562:	4505                	li	a0,1
    2564:	00003097          	auipc	ra,0x3
    2568:	ff6080e7          	jalr	-10(ra) # 555a <sbrk>
  if(c != a + 1){
    256c:	0489                	add	s1,s1,2
    256e:	04a48e63          	beq	s1,a0,25ca <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    2572:	85d2                	mv	a1,s4
    2574:	00004517          	auipc	a0,0x4
    2578:	27450513          	add	a0,a0,628 # 67e8 <malloc+0xef6>
    257c:	00003097          	auipc	ra,0x3
    2580:	2be080e7          	jalr	702(ra) # 583a <printf>
    exit(1);
    2584:	4505                	li	a0,1
    2586:	00003097          	auipc	ra,0x3
    258a:	f4c080e7          	jalr	-180(ra) # 54d2 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    258e:	86aa                	mv	a3,a0
    2590:	8626                	mv	a2,s1
    2592:	85ca                	mv	a1,s2
    2594:	00004517          	auipc	a0,0x4
    2598:	21450513          	add	a0,a0,532 # 67a8 <malloc+0xeb6>
    259c:	00003097          	auipc	ra,0x3
    25a0:	29e080e7          	jalr	670(ra) # 583a <printf>
      exit(1);
    25a4:	4505                	li	a0,1
    25a6:	00003097          	auipc	ra,0x3
    25aa:	f2c080e7          	jalr	-212(ra) # 54d2 <exit>
    printf("%s: sbrk test fork failed\n", s);
    25ae:	85d2                	mv	a1,s4
    25b0:	00004517          	auipc	a0,0x4
    25b4:	21850513          	add	a0,a0,536 # 67c8 <malloc+0xed6>
    25b8:	00003097          	auipc	ra,0x3
    25bc:	282080e7          	jalr	642(ra) # 583a <printf>
    exit(1);
    25c0:	4505                	li	a0,1
    25c2:	00003097          	auipc	ra,0x3
    25c6:	f10080e7          	jalr	-240(ra) # 54d2 <exit>
  if(pid == 0)
    25ca:	00091763          	bnez	s2,25d8 <sbrkbasic+0x16c>
    exit(0);
    25ce:	4501                	li	a0,0
    25d0:	00003097          	auipc	ra,0x3
    25d4:	f02080e7          	jalr	-254(ra) # 54d2 <exit>
  wait(&xstatus);
    25d8:	fcc40513          	add	a0,s0,-52
    25dc:	00003097          	auipc	ra,0x3
    25e0:	efe080e7          	jalr	-258(ra) # 54da <wait>
  exit(xstatus);
    25e4:	fcc42503          	lw	a0,-52(s0)
    25e8:	00003097          	auipc	ra,0x3
    25ec:	eea080e7          	jalr	-278(ra) # 54d2 <exit>

00000000000025f0 <sbrkmuch>:
{
    25f0:	7179                	add	sp,sp,-48
    25f2:	f406                	sd	ra,40(sp)
    25f4:	f022                	sd	s0,32(sp)
    25f6:	ec26                	sd	s1,24(sp)
    25f8:	e84a                	sd	s2,16(sp)
    25fa:	e44e                	sd	s3,8(sp)
    25fc:	e052                	sd	s4,0(sp)
    25fe:	1800                	add	s0,sp,48
    2600:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2602:	4501                	li	a0,0
    2604:	00003097          	auipc	ra,0x3
    2608:	f56080e7          	jalr	-170(ra) # 555a <sbrk>
    260c:	892a                	mv	s2,a0
  a = sbrk(0);
    260e:	4501                	li	a0,0
    2610:	00003097          	auipc	ra,0x3
    2614:	f4a080e7          	jalr	-182(ra) # 555a <sbrk>
    2618:	84aa                	mv	s1,a0
  p = sbrk(amt);
    261a:	06400537          	lui	a0,0x6400
    261e:	9d05                	subw	a0,a0,s1
    2620:	00003097          	auipc	ra,0x3
    2624:	f3a080e7          	jalr	-198(ra) # 555a <sbrk>
  if (p != a) {
    2628:	0ca49863          	bne	s1,a0,26f8 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    262c:	4501                	li	a0,0
    262e:	00003097          	auipc	ra,0x3
    2632:	f2c080e7          	jalr	-212(ra) # 555a <sbrk>
    2636:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2638:	00a4f963          	bgeu	s1,a0,264a <sbrkmuch+0x5a>
    *pp = 1;
    263c:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    263e:	6705                	lui	a4,0x1
    *pp = 1;
    2640:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2644:	94ba                	add	s1,s1,a4
    2646:	fef4ede3          	bltu	s1,a5,2640 <sbrkmuch+0x50>
  *lastaddr = 99;
    264a:	064007b7          	lui	a5,0x6400
    264e:	06300713          	li	a4,99
    2652:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f165f>
  a = sbrk(0);
    2656:	4501                	li	a0,0
    2658:	00003097          	auipc	ra,0x3
    265c:	f02080e7          	jalr	-254(ra) # 555a <sbrk>
    2660:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2662:	757d                	lui	a0,0xfffff
    2664:	00003097          	auipc	ra,0x3
    2668:	ef6080e7          	jalr	-266(ra) # 555a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    266c:	57fd                	li	a5,-1
    266e:	0af50363          	beq	a0,a5,2714 <sbrkmuch+0x124>
  c = sbrk(0);
    2672:	4501                	li	a0,0
    2674:	00003097          	auipc	ra,0x3
    2678:	ee6080e7          	jalr	-282(ra) # 555a <sbrk>
  if(c != a - PGSIZE){
    267c:	77fd                	lui	a5,0xfffff
    267e:	97a6                	add	a5,a5,s1
    2680:	0af51863          	bne	a0,a5,2730 <sbrkmuch+0x140>
  a = sbrk(0);
    2684:	4501                	li	a0,0
    2686:	00003097          	auipc	ra,0x3
    268a:	ed4080e7          	jalr	-300(ra) # 555a <sbrk>
    268e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2690:	6505                	lui	a0,0x1
    2692:	00003097          	auipc	ra,0x3
    2696:	ec8080e7          	jalr	-312(ra) # 555a <sbrk>
    269a:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    269c:	0aa49963          	bne	s1,a0,274e <sbrkmuch+0x15e>
    26a0:	4501                	li	a0,0
    26a2:	00003097          	auipc	ra,0x3
    26a6:	eb8080e7          	jalr	-328(ra) # 555a <sbrk>
    26aa:	6785                	lui	a5,0x1
    26ac:	97a6                	add	a5,a5,s1
    26ae:	0af51063          	bne	a0,a5,274e <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    26b2:	064007b7          	lui	a5,0x6400
    26b6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f165f>
    26ba:	06300793          	li	a5,99
    26be:	0af70763          	beq	a4,a5,276c <sbrkmuch+0x17c>
  a = sbrk(0);
    26c2:	4501                	li	a0,0
    26c4:	00003097          	auipc	ra,0x3
    26c8:	e96080e7          	jalr	-362(ra) # 555a <sbrk>
    26cc:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    26ce:	4501                	li	a0,0
    26d0:	00003097          	auipc	ra,0x3
    26d4:	e8a080e7          	jalr	-374(ra) # 555a <sbrk>
    26d8:	40a9053b          	subw	a0,s2,a0
    26dc:	00003097          	auipc	ra,0x3
    26e0:	e7e080e7          	jalr	-386(ra) # 555a <sbrk>
  if(c != a){
    26e4:	0aa49263          	bne	s1,a0,2788 <sbrkmuch+0x198>
}
    26e8:	70a2                	ld	ra,40(sp)
    26ea:	7402                	ld	s0,32(sp)
    26ec:	64e2                	ld	s1,24(sp)
    26ee:	6942                	ld	s2,16(sp)
    26f0:	69a2                	ld	s3,8(sp)
    26f2:	6a02                	ld	s4,0(sp)
    26f4:	6145                	add	sp,sp,48
    26f6:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    26f8:	85ce                	mv	a1,s3
    26fa:	00004517          	auipc	a0,0x4
    26fe:	10e50513          	add	a0,a0,270 # 6808 <malloc+0xf16>
    2702:	00003097          	auipc	ra,0x3
    2706:	138080e7          	jalr	312(ra) # 583a <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	00003097          	auipc	ra,0x3
    2710:	dc6080e7          	jalr	-570(ra) # 54d2 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2714:	85ce                	mv	a1,s3
    2716:	00004517          	auipc	a0,0x4
    271a:	13a50513          	add	a0,a0,314 # 6850 <malloc+0xf5e>
    271e:	00003097          	auipc	ra,0x3
    2722:	11c080e7          	jalr	284(ra) # 583a <printf>
    exit(1);
    2726:	4505                	li	a0,1
    2728:	00003097          	auipc	ra,0x3
    272c:	daa080e7          	jalr	-598(ra) # 54d2 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2730:	862a                	mv	a2,a0
    2732:	85a6                	mv	a1,s1
    2734:	00004517          	auipc	a0,0x4
    2738:	13c50513          	add	a0,a0,316 # 6870 <malloc+0xf7e>
    273c:	00003097          	auipc	ra,0x3
    2740:	0fe080e7          	jalr	254(ra) # 583a <printf>
    exit(1);
    2744:	4505                	li	a0,1
    2746:	00003097          	auipc	ra,0x3
    274a:	d8c080e7          	jalr	-628(ra) # 54d2 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    274e:	8652                	mv	a2,s4
    2750:	85a6                	mv	a1,s1
    2752:	00004517          	auipc	a0,0x4
    2756:	15e50513          	add	a0,a0,350 # 68b0 <malloc+0xfbe>
    275a:	00003097          	auipc	ra,0x3
    275e:	0e0080e7          	jalr	224(ra) # 583a <printf>
    exit(1);
    2762:	4505                	li	a0,1
    2764:	00003097          	auipc	ra,0x3
    2768:	d6e080e7          	jalr	-658(ra) # 54d2 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    276c:	85ce                	mv	a1,s3
    276e:	00004517          	auipc	a0,0x4
    2772:	17250513          	add	a0,a0,370 # 68e0 <malloc+0xfee>
    2776:	00003097          	auipc	ra,0x3
    277a:	0c4080e7          	jalr	196(ra) # 583a <printf>
    exit(1);
    277e:	4505                	li	a0,1
    2780:	00003097          	auipc	ra,0x3
    2784:	d52080e7          	jalr	-686(ra) # 54d2 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2788:	862a                	mv	a2,a0
    278a:	85a6                	mv	a1,s1
    278c:	00004517          	auipc	a0,0x4
    2790:	18c50513          	add	a0,a0,396 # 6918 <malloc+0x1026>
    2794:	00003097          	auipc	ra,0x3
    2798:	0a6080e7          	jalr	166(ra) # 583a <printf>
    exit(1);
    279c:	4505                	li	a0,1
    279e:	00003097          	auipc	ra,0x3
    27a2:	d34080e7          	jalr	-716(ra) # 54d2 <exit>

00000000000027a6 <sbrkarg>:
{
    27a6:	7179                	add	sp,sp,-48
    27a8:	f406                	sd	ra,40(sp)
    27aa:	f022                	sd	s0,32(sp)
    27ac:	ec26                	sd	s1,24(sp)
    27ae:	e84a                	sd	s2,16(sp)
    27b0:	e44e                	sd	s3,8(sp)
    27b2:	1800                	add	s0,sp,48
    27b4:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    27b6:	6505                	lui	a0,0x1
    27b8:	00003097          	auipc	ra,0x3
    27bc:	da2080e7          	jalr	-606(ra) # 555a <sbrk>
    27c0:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    27c2:	20100593          	li	a1,513
    27c6:	00004517          	auipc	a0,0x4
    27ca:	17a50513          	add	a0,a0,378 # 6940 <malloc+0x104e>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	d44080e7          	jalr	-700(ra) # 5512 <open>
    27d6:	84aa                	mv	s1,a0
  unlink("sbrk");
    27d8:	00004517          	auipc	a0,0x4
    27dc:	16850513          	add	a0,a0,360 # 6940 <malloc+0x104e>
    27e0:	00003097          	auipc	ra,0x3
    27e4:	d42080e7          	jalr	-702(ra) # 5522 <unlink>
  if(fd < 0)  {
    27e8:	0404c163          	bltz	s1,282a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    27ec:	6605                	lui	a2,0x1
    27ee:	85ca                	mv	a1,s2
    27f0:	8526                	mv	a0,s1
    27f2:	00003097          	auipc	ra,0x3
    27f6:	d00080e7          	jalr	-768(ra) # 54f2 <write>
    27fa:	04054663          	bltz	a0,2846 <sbrkarg+0xa0>
  close(fd);
    27fe:	8526                	mv	a0,s1
    2800:	00003097          	auipc	ra,0x3
    2804:	cfa080e7          	jalr	-774(ra) # 54fa <close>
  a = sbrk(PGSIZE);
    2808:	6505                	lui	a0,0x1
    280a:	00003097          	auipc	ra,0x3
    280e:	d50080e7          	jalr	-688(ra) # 555a <sbrk>
  if(pipe((int *) a) != 0){
    2812:	00003097          	auipc	ra,0x3
    2816:	cd0080e7          	jalr	-816(ra) # 54e2 <pipe>
    281a:	e521                	bnez	a0,2862 <sbrkarg+0xbc>
}
    281c:	70a2                	ld	ra,40(sp)
    281e:	7402                	ld	s0,32(sp)
    2820:	64e2                	ld	s1,24(sp)
    2822:	6942                	ld	s2,16(sp)
    2824:	69a2                	ld	s3,8(sp)
    2826:	6145                	add	sp,sp,48
    2828:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    282a:	85ce                	mv	a1,s3
    282c:	00004517          	auipc	a0,0x4
    2830:	11c50513          	add	a0,a0,284 # 6948 <malloc+0x1056>
    2834:	00003097          	auipc	ra,0x3
    2838:	006080e7          	jalr	6(ra) # 583a <printf>
    exit(1);
    283c:	4505                	li	a0,1
    283e:	00003097          	auipc	ra,0x3
    2842:	c94080e7          	jalr	-876(ra) # 54d2 <exit>
    printf("%s: write sbrk failed\n", s);
    2846:	85ce                	mv	a1,s3
    2848:	00004517          	auipc	a0,0x4
    284c:	11850513          	add	a0,a0,280 # 6960 <malloc+0x106e>
    2850:	00003097          	auipc	ra,0x3
    2854:	fea080e7          	jalr	-22(ra) # 583a <printf>
    exit(1);
    2858:	4505                	li	a0,1
    285a:	00003097          	auipc	ra,0x3
    285e:	c78080e7          	jalr	-904(ra) # 54d2 <exit>
    printf("%s: pipe() failed\n", s);
    2862:	85ce                	mv	a1,s3
    2864:	00004517          	auipc	a0,0x4
    2868:	b0c50513          	add	a0,a0,-1268 # 6370 <malloc+0xa7e>
    286c:	00003097          	auipc	ra,0x3
    2870:	fce080e7          	jalr	-50(ra) # 583a <printf>
    exit(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	c5c080e7          	jalr	-932(ra) # 54d2 <exit>

000000000000287e <argptest>:
{
    287e:	1101                	add	sp,sp,-32
    2880:	ec06                	sd	ra,24(sp)
    2882:	e822                	sd	s0,16(sp)
    2884:	e426                	sd	s1,8(sp)
    2886:	e04a                	sd	s2,0(sp)
    2888:	1000                	add	s0,sp,32
    288a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    288c:	4581                	li	a1,0
    288e:	00004517          	auipc	a0,0x4
    2892:	0ea50513          	add	a0,a0,234 # 6978 <malloc+0x1086>
    2896:	00003097          	auipc	ra,0x3
    289a:	c7c080e7          	jalr	-900(ra) # 5512 <open>
  if (fd < 0) {
    289e:	02054b63          	bltz	a0,28d4 <argptest+0x56>
    28a2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    28a4:	4501                	li	a0,0
    28a6:	00003097          	auipc	ra,0x3
    28aa:	cb4080e7          	jalr	-844(ra) # 555a <sbrk>
    28ae:	567d                	li	a2,-1
    28b0:	fff50593          	add	a1,a0,-1
    28b4:	8526                	mv	a0,s1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	c34080e7          	jalr	-972(ra) # 54ea <read>
  close(fd);
    28be:	8526                	mv	a0,s1
    28c0:	00003097          	auipc	ra,0x3
    28c4:	c3a080e7          	jalr	-966(ra) # 54fa <close>
}
    28c8:	60e2                	ld	ra,24(sp)
    28ca:	6442                	ld	s0,16(sp)
    28cc:	64a2                	ld	s1,8(sp)
    28ce:	6902                	ld	s2,0(sp)
    28d0:	6105                	add	sp,sp,32
    28d2:	8082                	ret
    printf("%s: open failed\n", s);
    28d4:	85ca                	mv	a1,s2
    28d6:	00004517          	auipc	a0,0x4
    28da:	9aa50513          	add	a0,a0,-1622 # 6280 <malloc+0x98e>
    28de:	00003097          	auipc	ra,0x3
    28e2:	f5c080e7          	jalr	-164(ra) # 583a <printf>
    exit(1);
    28e6:	4505                	li	a0,1
    28e8:	00003097          	auipc	ra,0x3
    28ec:	bea080e7          	jalr	-1046(ra) # 54d2 <exit>

00000000000028f0 <sbrkbugs>:
{
    28f0:	1141                	add	sp,sp,-16
    28f2:	e406                	sd	ra,8(sp)
    28f4:	e022                	sd	s0,0(sp)
    28f6:	0800                	add	s0,sp,16
  int pid = fork();
    28f8:	00003097          	auipc	ra,0x3
    28fc:	bd2080e7          	jalr	-1070(ra) # 54ca <fork>
  if(pid < 0){
    2900:	02054263          	bltz	a0,2924 <sbrkbugs+0x34>
  if(pid == 0){
    2904:	ed0d                	bnez	a0,293e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2906:	00003097          	auipc	ra,0x3
    290a:	c54080e7          	jalr	-940(ra) # 555a <sbrk>
    sbrk(-sz);
    290e:	40a0053b          	negw	a0,a0
    2912:	00003097          	auipc	ra,0x3
    2916:	c48080e7          	jalr	-952(ra) # 555a <sbrk>
    exit(0);
    291a:	4501                	li	a0,0
    291c:	00003097          	auipc	ra,0x3
    2920:	bb6080e7          	jalr	-1098(ra) # 54d2 <exit>
    printf("fork failed\n");
    2924:	00004517          	auipc	a0,0x4
    2928:	d3450513          	add	a0,a0,-716 # 6658 <malloc+0xd66>
    292c:	00003097          	auipc	ra,0x3
    2930:	f0e080e7          	jalr	-242(ra) # 583a <printf>
    exit(1);
    2934:	4505                	li	a0,1
    2936:	00003097          	auipc	ra,0x3
    293a:	b9c080e7          	jalr	-1124(ra) # 54d2 <exit>
  wait(0);
    293e:	4501                	li	a0,0
    2940:	00003097          	auipc	ra,0x3
    2944:	b9a080e7          	jalr	-1126(ra) # 54da <wait>
  pid = fork();
    2948:	00003097          	auipc	ra,0x3
    294c:	b82080e7          	jalr	-1150(ra) # 54ca <fork>
  if(pid < 0){
    2950:	02054563          	bltz	a0,297a <sbrkbugs+0x8a>
  if(pid == 0){
    2954:	e121                	bnez	a0,2994 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2956:	00003097          	auipc	ra,0x3
    295a:	c04080e7          	jalr	-1020(ra) # 555a <sbrk>
    sbrk(-(sz - 3500));
    295e:	6785                	lui	a5,0x1
    2960:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x90>
    2964:	40a7853b          	subw	a0,a5,a0
    2968:	00003097          	auipc	ra,0x3
    296c:	bf2080e7          	jalr	-1038(ra) # 555a <sbrk>
    exit(0);
    2970:	4501                	li	a0,0
    2972:	00003097          	auipc	ra,0x3
    2976:	b60080e7          	jalr	-1184(ra) # 54d2 <exit>
    printf("fork failed\n");
    297a:	00004517          	auipc	a0,0x4
    297e:	cde50513          	add	a0,a0,-802 # 6658 <malloc+0xd66>
    2982:	00003097          	auipc	ra,0x3
    2986:	eb8080e7          	jalr	-328(ra) # 583a <printf>
    exit(1);
    298a:	4505                	li	a0,1
    298c:	00003097          	auipc	ra,0x3
    2990:	b46080e7          	jalr	-1210(ra) # 54d2 <exit>
  wait(0);
    2994:	4501                	li	a0,0
    2996:	00003097          	auipc	ra,0x3
    299a:	b44080e7          	jalr	-1212(ra) # 54da <wait>
  pid = fork();
    299e:	00003097          	auipc	ra,0x3
    29a2:	b2c080e7          	jalr	-1236(ra) # 54ca <fork>
  if(pid < 0){
    29a6:	02054a63          	bltz	a0,29da <sbrkbugs+0xea>
  if(pid == 0){
    29aa:	e529                	bnez	a0,29f4 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    29ac:	00003097          	auipc	ra,0x3
    29b0:	bae080e7          	jalr	-1106(ra) # 555a <sbrk>
    29b4:	67ad                	lui	a5,0xb
    29b6:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1580>
    29ba:	40a7853b          	subw	a0,a5,a0
    29be:	00003097          	auipc	ra,0x3
    29c2:	b9c080e7          	jalr	-1124(ra) # 555a <sbrk>
    sbrk(-10);
    29c6:	5559                	li	a0,-10
    29c8:	00003097          	auipc	ra,0x3
    29cc:	b92080e7          	jalr	-1134(ra) # 555a <sbrk>
    exit(0);
    29d0:	4501                	li	a0,0
    29d2:	00003097          	auipc	ra,0x3
    29d6:	b00080e7          	jalr	-1280(ra) # 54d2 <exit>
    printf("fork failed\n");
    29da:	00004517          	auipc	a0,0x4
    29de:	c7e50513          	add	a0,a0,-898 # 6658 <malloc+0xd66>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	e58080e7          	jalr	-424(ra) # 583a <printf>
    exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	ae6080e7          	jalr	-1306(ra) # 54d2 <exit>
  wait(0);
    29f4:	4501                	li	a0,0
    29f6:	00003097          	auipc	ra,0x3
    29fa:	ae4080e7          	jalr	-1308(ra) # 54da <wait>
  exit(0);
    29fe:	4501                	li	a0,0
    2a00:	00003097          	auipc	ra,0x3
    2a04:	ad2080e7          	jalr	-1326(ra) # 54d2 <exit>

0000000000002a08 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2a08:	715d                	add	sp,sp,-80
    2a0a:	e486                	sd	ra,72(sp)
    2a0c:	e0a2                	sd	s0,64(sp)
    2a0e:	fc26                	sd	s1,56(sp)
    2a10:	f84a                	sd	s2,48(sp)
    2a12:	f44e                	sd	s3,40(sp)
    2a14:	f052                	sd	s4,32(sp)
    2a16:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2a18:	4901                	li	s2,0
    2a1a:	49bd                	li	s3,15
    int pid = fork();
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	aae080e7          	jalr	-1362(ra) # 54ca <fork>
    2a24:	84aa                	mv	s1,a0
    if(pid < 0){
    2a26:	02054063          	bltz	a0,2a46 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2a2a:	c91d                	beqz	a0,2a60 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2a2c:	4501                	li	a0,0
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	aac080e7          	jalr	-1364(ra) # 54da <wait>
  for(int avail = 0; avail < 15; avail++){
    2a36:	2905                	addw	s2,s2,1
    2a38:	ff3912e3          	bne	s2,s3,2a1c <execout+0x14>
    }
  }

  exit(0);
    2a3c:	4501                	li	a0,0
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	a94080e7          	jalr	-1388(ra) # 54d2 <exit>
      printf("fork failed\n");
    2a46:	00004517          	auipc	a0,0x4
    2a4a:	c1250513          	add	a0,a0,-1006 # 6658 <malloc+0xd66>
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	dec080e7          	jalr	-532(ra) # 583a <printf>
      exit(1);
    2a56:	4505                	li	a0,1
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	a7a080e7          	jalr	-1414(ra) # 54d2 <exit>
        if(a == 0xffffffffffffffffLL)
    2a60:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2a62:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2a64:	6505                	lui	a0,0x1
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	af4080e7          	jalr	-1292(ra) # 555a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2a6e:	01350763          	beq	a0,s3,2a7c <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2a72:	6785                	lui	a5,0x1
    2a74:	97aa                	add	a5,a5,a0
    2a76:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x97>
      while(1){
    2a7a:	b7ed                	j	2a64 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2a7c:	01205a63          	blez	s2,2a90 <execout+0x88>
        sbrk(-4096);
    2a80:	757d                	lui	a0,0xfffff
    2a82:	00003097          	auipc	ra,0x3
    2a86:	ad8080e7          	jalr	-1320(ra) # 555a <sbrk>
      for(int i = 0; i < avail; i++)
    2a8a:	2485                	addw	s1,s1,1
    2a8c:	ff249ae3          	bne	s1,s2,2a80 <execout+0x78>
      close(1);
    2a90:	4505                	li	a0,1
    2a92:	00003097          	auipc	ra,0x3
    2a96:	a68080e7          	jalr	-1432(ra) # 54fa <close>
      char *args[] = { "echo", "x", 0 };
    2a9a:	00003517          	auipc	a0,0x3
    2a9e:	f7650513          	add	a0,a0,-138 # 5a10 <malloc+0x11e>
    2aa2:	faa43c23          	sd	a0,-72(s0)
    2aa6:	00003797          	auipc	a5,0x3
    2aaa:	fda78793          	add	a5,a5,-38 # 5a80 <malloc+0x18e>
    2aae:	fcf43023          	sd	a5,-64(s0)
    2ab2:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2ab6:	fb840593          	add	a1,s0,-72
    2aba:	00003097          	auipc	ra,0x3
    2abe:	a50080e7          	jalr	-1456(ra) # 550a <exec>
      exit(0);
    2ac2:	4501                	li	a0,0
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	a0e080e7          	jalr	-1522(ra) # 54d2 <exit>

0000000000002acc <fourteen>:
{
    2acc:	1101                	add	sp,sp,-32
    2ace:	ec06                	sd	ra,24(sp)
    2ad0:	e822                	sd	s0,16(sp)
    2ad2:	e426                	sd	s1,8(sp)
    2ad4:	1000                	add	s0,sp,32
    2ad6:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ad8:	00004517          	auipc	a0,0x4
    2adc:	07850513          	add	a0,a0,120 # 6b50 <malloc+0x125e>
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	a5a080e7          	jalr	-1446(ra) # 553a <mkdir>
    2ae8:	e165                	bnez	a0,2bc8 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2aea:	00004517          	auipc	a0,0x4
    2aee:	ebe50513          	add	a0,a0,-322 # 69a8 <malloc+0x10b6>
    2af2:	00003097          	auipc	ra,0x3
    2af6:	a48080e7          	jalr	-1464(ra) # 553a <mkdir>
    2afa:	e56d                	bnez	a0,2be4 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2afc:	20000593          	li	a1,512
    2b00:	00004517          	auipc	a0,0x4
    2b04:	f0050513          	add	a0,a0,-256 # 6a00 <malloc+0x110e>
    2b08:	00003097          	auipc	ra,0x3
    2b0c:	a0a080e7          	jalr	-1526(ra) # 5512 <open>
  if(fd < 0){
    2b10:	0e054863          	bltz	a0,2c00 <fourteen+0x134>
  close(fd);
    2b14:	00003097          	auipc	ra,0x3
    2b18:	9e6080e7          	jalr	-1562(ra) # 54fa <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2b1c:	4581                	li	a1,0
    2b1e:	00004517          	auipc	a0,0x4
    2b22:	f5a50513          	add	a0,a0,-166 # 6a78 <malloc+0x1186>
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	9ec080e7          	jalr	-1556(ra) # 5512 <open>
  if(fd < 0){
    2b2e:	0e054763          	bltz	a0,2c1c <fourteen+0x150>
  close(fd);
    2b32:	00003097          	auipc	ra,0x3
    2b36:	9c8080e7          	jalr	-1592(ra) # 54fa <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2b3a:	00004517          	auipc	a0,0x4
    2b3e:	fae50513          	add	a0,a0,-82 # 6ae8 <malloc+0x11f6>
    2b42:	00003097          	auipc	ra,0x3
    2b46:	9f8080e7          	jalr	-1544(ra) # 553a <mkdir>
    2b4a:	c57d                	beqz	a0,2c38 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	ff450513          	add	a0,a0,-12 # 6b40 <malloc+0x124e>
    2b54:	00003097          	auipc	ra,0x3
    2b58:	9e6080e7          	jalr	-1562(ra) # 553a <mkdir>
    2b5c:	cd65                	beqz	a0,2c54 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2b5e:	00004517          	auipc	a0,0x4
    2b62:	fe250513          	add	a0,a0,-30 # 6b40 <malloc+0x124e>
    2b66:	00003097          	auipc	ra,0x3
    2b6a:	9bc080e7          	jalr	-1604(ra) # 5522 <unlink>
  unlink("12345678901234/12345678901234");
    2b6e:	00004517          	auipc	a0,0x4
    2b72:	f7a50513          	add	a0,a0,-134 # 6ae8 <malloc+0x11f6>
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	9ac080e7          	jalr	-1620(ra) # 5522 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2b7e:	00004517          	auipc	a0,0x4
    2b82:	efa50513          	add	a0,a0,-262 # 6a78 <malloc+0x1186>
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	99c080e7          	jalr	-1636(ra) # 5522 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2b8e:	00004517          	auipc	a0,0x4
    2b92:	e7250513          	add	a0,a0,-398 # 6a00 <malloc+0x110e>
    2b96:	00003097          	auipc	ra,0x3
    2b9a:	98c080e7          	jalr	-1652(ra) # 5522 <unlink>
  unlink("12345678901234/123456789012345");
    2b9e:	00004517          	auipc	a0,0x4
    2ba2:	e0a50513          	add	a0,a0,-502 # 69a8 <malloc+0x10b6>
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	97c080e7          	jalr	-1668(ra) # 5522 <unlink>
  unlink("12345678901234");
    2bae:	00004517          	auipc	a0,0x4
    2bb2:	fa250513          	add	a0,a0,-94 # 6b50 <malloc+0x125e>
    2bb6:	00003097          	auipc	ra,0x3
    2bba:	96c080e7          	jalr	-1684(ra) # 5522 <unlink>
}
    2bbe:	60e2                	ld	ra,24(sp)
    2bc0:	6442                	ld	s0,16(sp)
    2bc2:	64a2                	ld	s1,8(sp)
    2bc4:	6105                	add	sp,sp,32
    2bc6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2bc8:	85a6                	mv	a1,s1
    2bca:	00004517          	auipc	a0,0x4
    2bce:	db650513          	add	a0,a0,-586 # 6980 <malloc+0x108e>
    2bd2:	00003097          	auipc	ra,0x3
    2bd6:	c68080e7          	jalr	-920(ra) # 583a <printf>
    exit(1);
    2bda:	4505                	li	a0,1
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	8f6080e7          	jalr	-1802(ra) # 54d2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2be4:	85a6                	mv	a1,s1
    2be6:	00004517          	auipc	a0,0x4
    2bea:	de250513          	add	a0,a0,-542 # 69c8 <malloc+0x10d6>
    2bee:	00003097          	auipc	ra,0x3
    2bf2:	c4c080e7          	jalr	-948(ra) # 583a <printf>
    exit(1);
    2bf6:	4505                	li	a0,1
    2bf8:	00003097          	auipc	ra,0x3
    2bfc:	8da080e7          	jalr	-1830(ra) # 54d2 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2c00:	85a6                	mv	a1,s1
    2c02:	00004517          	auipc	a0,0x4
    2c06:	e2e50513          	add	a0,a0,-466 # 6a30 <malloc+0x113e>
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	c30080e7          	jalr	-976(ra) # 583a <printf>
    exit(1);
    2c12:	4505                	li	a0,1
    2c14:	00003097          	auipc	ra,0x3
    2c18:	8be080e7          	jalr	-1858(ra) # 54d2 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2c1c:	85a6                	mv	a1,s1
    2c1e:	00004517          	auipc	a0,0x4
    2c22:	e8a50513          	add	a0,a0,-374 # 6aa8 <malloc+0x11b6>
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	c14080e7          	jalr	-1004(ra) # 583a <printf>
    exit(1);
    2c2e:	4505                	li	a0,1
    2c30:	00003097          	auipc	ra,0x3
    2c34:	8a2080e7          	jalr	-1886(ra) # 54d2 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2c38:	85a6                	mv	a1,s1
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	ece50513          	add	a0,a0,-306 # 6b08 <malloc+0x1216>
    2c42:	00003097          	auipc	ra,0x3
    2c46:	bf8080e7          	jalr	-1032(ra) # 583a <printf>
    exit(1);
    2c4a:	4505                	li	a0,1
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	886080e7          	jalr	-1914(ra) # 54d2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2c54:	85a6                	mv	a1,s1
    2c56:	00004517          	auipc	a0,0x4
    2c5a:	f0a50513          	add	a0,a0,-246 # 6b60 <malloc+0x126e>
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	bdc080e7          	jalr	-1060(ra) # 583a <printf>
    exit(1);
    2c66:	4505                	li	a0,1
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	86a080e7          	jalr	-1942(ra) # 54d2 <exit>

0000000000002c70 <iputtest>:
{
    2c70:	1101                	add	sp,sp,-32
    2c72:	ec06                	sd	ra,24(sp)
    2c74:	e822                	sd	s0,16(sp)
    2c76:	e426                	sd	s1,8(sp)
    2c78:	1000                	add	s0,sp,32
    2c7a:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2c7c:	00004517          	auipc	a0,0x4
    2c80:	f1c50513          	add	a0,a0,-228 # 6b98 <malloc+0x12a6>
    2c84:	00003097          	auipc	ra,0x3
    2c88:	8b6080e7          	jalr	-1866(ra) # 553a <mkdir>
    2c8c:	04054563          	bltz	a0,2cd6 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2c90:	00004517          	auipc	a0,0x4
    2c94:	f0850513          	add	a0,a0,-248 # 6b98 <malloc+0x12a6>
    2c98:	00003097          	auipc	ra,0x3
    2c9c:	8aa080e7          	jalr	-1878(ra) # 5542 <chdir>
    2ca0:	04054963          	bltz	a0,2cf2 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	f3450513          	add	a0,a0,-204 # 6bd8 <malloc+0x12e6>
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	876080e7          	jalr	-1930(ra) # 5522 <unlink>
    2cb4:	04054d63          	bltz	a0,2d0e <iputtest+0x9e>
  if(chdir("/") < 0){
    2cb8:	00004517          	auipc	a0,0x4
    2cbc:	f5050513          	add	a0,a0,-176 # 6c08 <malloc+0x1316>
    2cc0:	00003097          	auipc	ra,0x3
    2cc4:	882080e7          	jalr	-1918(ra) # 5542 <chdir>
    2cc8:	06054163          	bltz	a0,2d2a <iputtest+0xba>
}
    2ccc:	60e2                	ld	ra,24(sp)
    2cce:	6442                	ld	s0,16(sp)
    2cd0:	64a2                	ld	s1,8(sp)
    2cd2:	6105                	add	sp,sp,32
    2cd4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cd6:	85a6                	mv	a1,s1
    2cd8:	00004517          	auipc	a0,0x4
    2cdc:	ec850513          	add	a0,a0,-312 # 6ba0 <malloc+0x12ae>
    2ce0:	00003097          	auipc	ra,0x3
    2ce4:	b5a080e7          	jalr	-1190(ra) # 583a <printf>
    exit(1);
    2ce8:	4505                	li	a0,1
    2cea:	00002097          	auipc	ra,0x2
    2cee:	7e8080e7          	jalr	2024(ra) # 54d2 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2cf2:	85a6                	mv	a1,s1
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	ec450513          	add	a0,a0,-316 # 6bb8 <malloc+0x12c6>
    2cfc:	00003097          	auipc	ra,0x3
    2d00:	b3e080e7          	jalr	-1218(ra) # 583a <printf>
    exit(1);
    2d04:	4505                	li	a0,1
    2d06:	00002097          	auipc	ra,0x2
    2d0a:	7cc080e7          	jalr	1996(ra) # 54d2 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2d0e:	85a6                	mv	a1,s1
    2d10:	00004517          	auipc	a0,0x4
    2d14:	ed850513          	add	a0,a0,-296 # 6be8 <malloc+0x12f6>
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	b22080e7          	jalr	-1246(ra) # 583a <printf>
    exit(1);
    2d20:	4505                	li	a0,1
    2d22:	00002097          	auipc	ra,0x2
    2d26:	7b0080e7          	jalr	1968(ra) # 54d2 <exit>
    printf("%s: chdir / failed\n", s);
    2d2a:	85a6                	mv	a1,s1
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	ee450513          	add	a0,a0,-284 # 6c10 <malloc+0x131e>
    2d34:	00003097          	auipc	ra,0x3
    2d38:	b06080e7          	jalr	-1274(ra) # 583a <printf>
    exit(1);
    2d3c:	4505                	li	a0,1
    2d3e:	00002097          	auipc	ra,0x2
    2d42:	794080e7          	jalr	1940(ra) # 54d2 <exit>

0000000000002d46 <exitiputtest>:
{
    2d46:	7179                	add	sp,sp,-48
    2d48:	f406                	sd	ra,40(sp)
    2d4a:	f022                	sd	s0,32(sp)
    2d4c:	ec26                	sd	s1,24(sp)
    2d4e:	1800                	add	s0,sp,48
    2d50:	84aa                	mv	s1,a0
  pid = fork();
    2d52:	00002097          	auipc	ra,0x2
    2d56:	778080e7          	jalr	1912(ra) # 54ca <fork>
  if(pid < 0){
    2d5a:	04054663          	bltz	a0,2da6 <exitiputtest+0x60>
  if(pid == 0){
    2d5e:	ed45                	bnez	a0,2e16 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2d60:	00004517          	auipc	a0,0x4
    2d64:	e3850513          	add	a0,a0,-456 # 6b98 <malloc+0x12a6>
    2d68:	00002097          	auipc	ra,0x2
    2d6c:	7d2080e7          	jalr	2002(ra) # 553a <mkdir>
    2d70:	04054963          	bltz	a0,2dc2 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2d74:	00004517          	auipc	a0,0x4
    2d78:	e2450513          	add	a0,a0,-476 # 6b98 <malloc+0x12a6>
    2d7c:	00002097          	auipc	ra,0x2
    2d80:	7c6080e7          	jalr	1990(ra) # 5542 <chdir>
    2d84:	04054d63          	bltz	a0,2dde <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	e5050513          	add	a0,a0,-432 # 6bd8 <malloc+0x12e6>
    2d90:	00002097          	auipc	ra,0x2
    2d94:	792080e7          	jalr	1938(ra) # 5522 <unlink>
    2d98:	06054163          	bltz	a0,2dfa <exitiputtest+0xb4>
    exit(0);
    2d9c:	4501                	li	a0,0
    2d9e:	00002097          	auipc	ra,0x2
    2da2:	734080e7          	jalr	1844(ra) # 54d2 <exit>
    printf("%s: fork failed\n", s);
    2da6:	85a6                	mv	a1,s1
    2da8:	00003517          	auipc	a0,0x3
    2dac:	4c050513          	add	a0,a0,1216 # 6268 <malloc+0x976>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	a8a080e7          	jalr	-1398(ra) # 583a <printf>
    exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00002097          	auipc	ra,0x2
    2dbe:	718080e7          	jalr	1816(ra) # 54d2 <exit>
      printf("%s: mkdir failed\n", s);
    2dc2:	85a6                	mv	a1,s1
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	ddc50513          	add	a0,a0,-548 # 6ba0 <malloc+0x12ae>
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	a6e080e7          	jalr	-1426(ra) # 583a <printf>
      exit(1);
    2dd4:	4505                	li	a0,1
    2dd6:	00002097          	auipc	ra,0x2
    2dda:	6fc080e7          	jalr	1788(ra) # 54d2 <exit>
      printf("%s: child chdir failed\n", s);
    2dde:	85a6                	mv	a1,s1
    2de0:	00004517          	auipc	a0,0x4
    2de4:	e4850513          	add	a0,a0,-440 # 6c28 <malloc+0x1336>
    2de8:	00003097          	auipc	ra,0x3
    2dec:	a52080e7          	jalr	-1454(ra) # 583a <printf>
      exit(1);
    2df0:	4505                	li	a0,1
    2df2:	00002097          	auipc	ra,0x2
    2df6:	6e0080e7          	jalr	1760(ra) # 54d2 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2dfa:	85a6                	mv	a1,s1
    2dfc:	00004517          	auipc	a0,0x4
    2e00:	dec50513          	add	a0,a0,-532 # 6be8 <malloc+0x12f6>
    2e04:	00003097          	auipc	ra,0x3
    2e08:	a36080e7          	jalr	-1482(ra) # 583a <printf>
      exit(1);
    2e0c:	4505                	li	a0,1
    2e0e:	00002097          	auipc	ra,0x2
    2e12:	6c4080e7          	jalr	1732(ra) # 54d2 <exit>
  wait(&xstatus);
    2e16:	fdc40513          	add	a0,s0,-36
    2e1a:	00002097          	auipc	ra,0x2
    2e1e:	6c0080e7          	jalr	1728(ra) # 54da <wait>
  exit(xstatus);
    2e22:	fdc42503          	lw	a0,-36(s0)
    2e26:	00002097          	auipc	ra,0x2
    2e2a:	6ac080e7          	jalr	1708(ra) # 54d2 <exit>

0000000000002e2e <subdir>:
{
    2e2e:	1101                	add	sp,sp,-32
    2e30:	ec06                	sd	ra,24(sp)
    2e32:	e822                	sd	s0,16(sp)
    2e34:	e426                	sd	s1,8(sp)
    2e36:	e04a                	sd	s2,0(sp)
    2e38:	1000                	add	s0,sp,32
    2e3a:	892a                	mv	s2,a0
  unlink("ff");
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	f3450513          	add	a0,a0,-204 # 6d70 <malloc+0x147e>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	6de080e7          	jalr	1758(ra) # 5522 <unlink>
  if(mkdir("dd") != 0){
    2e4c:	00004517          	auipc	a0,0x4
    2e50:	df450513          	add	a0,a0,-524 # 6c40 <malloc+0x134e>
    2e54:	00002097          	auipc	ra,0x2
    2e58:	6e6080e7          	jalr	1766(ra) # 553a <mkdir>
    2e5c:	38051663          	bnez	a0,31e8 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2e60:	20200593          	li	a1,514
    2e64:	00004517          	auipc	a0,0x4
    2e68:	dfc50513          	add	a0,a0,-516 # 6c60 <malloc+0x136e>
    2e6c:	00002097          	auipc	ra,0x2
    2e70:	6a6080e7          	jalr	1702(ra) # 5512 <open>
    2e74:	84aa                	mv	s1,a0
  if(fd < 0){
    2e76:	38054763          	bltz	a0,3204 <subdir+0x3d6>
  write(fd, "ff", 2);
    2e7a:	4609                	li	a2,2
    2e7c:	00004597          	auipc	a1,0x4
    2e80:	ef458593          	add	a1,a1,-268 # 6d70 <malloc+0x147e>
    2e84:	00002097          	auipc	ra,0x2
    2e88:	66e080e7          	jalr	1646(ra) # 54f2 <write>
  close(fd);
    2e8c:	8526                	mv	a0,s1
    2e8e:	00002097          	auipc	ra,0x2
    2e92:	66c080e7          	jalr	1644(ra) # 54fa <close>
  if(unlink("dd") >= 0){
    2e96:	00004517          	auipc	a0,0x4
    2e9a:	daa50513          	add	a0,a0,-598 # 6c40 <malloc+0x134e>
    2e9e:	00002097          	auipc	ra,0x2
    2ea2:	684080e7          	jalr	1668(ra) # 5522 <unlink>
    2ea6:	36055d63          	bgez	a0,3220 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	e0e50513          	add	a0,a0,-498 # 6cb8 <malloc+0x13c6>
    2eb2:	00002097          	auipc	ra,0x2
    2eb6:	688080e7          	jalr	1672(ra) # 553a <mkdir>
    2eba:	38051163          	bnez	a0,323c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2ebe:	20200593          	li	a1,514
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	e1e50513          	add	a0,a0,-482 # 6ce0 <malloc+0x13ee>
    2eca:	00002097          	auipc	ra,0x2
    2ece:	648080e7          	jalr	1608(ra) # 5512 <open>
    2ed2:	84aa                	mv	s1,a0
  if(fd < 0){
    2ed4:	38054263          	bltz	a0,3258 <subdir+0x42a>
  write(fd, "FF", 2);
    2ed8:	4609                	li	a2,2
    2eda:	00004597          	auipc	a1,0x4
    2ede:	e3658593          	add	a1,a1,-458 # 6d10 <malloc+0x141e>
    2ee2:	00002097          	auipc	ra,0x2
    2ee6:	610080e7          	jalr	1552(ra) # 54f2 <write>
  close(fd);
    2eea:	8526                	mv	a0,s1
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	60e080e7          	jalr	1550(ra) # 54fa <close>
  fd = open("dd/dd/../ff", 0);
    2ef4:	4581                	li	a1,0
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	e2250513          	add	a0,a0,-478 # 6d18 <malloc+0x1426>
    2efe:	00002097          	auipc	ra,0x2
    2f02:	614080e7          	jalr	1556(ra) # 5512 <open>
    2f06:	84aa                	mv	s1,a0
  if(fd < 0){
    2f08:	36054663          	bltz	a0,3274 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2f0c:	660d                	lui	a2,0x3
    2f0e:	00009597          	auipc	a1,0x9
    2f12:	a8258593          	add	a1,a1,-1406 # b990 <buf>
    2f16:	00002097          	auipc	ra,0x2
    2f1a:	5d4080e7          	jalr	1492(ra) # 54ea <read>
  if(cc != 2 || buf[0] != 'f'){
    2f1e:	4789                	li	a5,2
    2f20:	36f51863          	bne	a0,a5,3290 <subdir+0x462>
    2f24:	00009717          	auipc	a4,0x9
    2f28:	a6c74703          	lbu	a4,-1428(a4) # b990 <buf>
    2f2c:	06600793          	li	a5,102
    2f30:	36f71063          	bne	a4,a5,3290 <subdir+0x462>
  close(fd);
    2f34:	8526                	mv	a0,s1
    2f36:	00002097          	auipc	ra,0x2
    2f3a:	5c4080e7          	jalr	1476(ra) # 54fa <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2f3e:	00004597          	auipc	a1,0x4
    2f42:	e2a58593          	add	a1,a1,-470 # 6d68 <malloc+0x1476>
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	d9a50513          	add	a0,a0,-614 # 6ce0 <malloc+0x13ee>
    2f4e:	00002097          	auipc	ra,0x2
    2f52:	5e4080e7          	jalr	1508(ra) # 5532 <link>
    2f56:	34051b63          	bnez	a0,32ac <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	d8650513          	add	a0,a0,-634 # 6ce0 <malloc+0x13ee>
    2f62:	00002097          	auipc	ra,0x2
    2f66:	5c0080e7          	jalr	1472(ra) # 5522 <unlink>
    2f6a:	34051f63          	bnez	a0,32c8 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2f6e:	4581                	li	a1,0
    2f70:	00004517          	auipc	a0,0x4
    2f74:	d7050513          	add	a0,a0,-656 # 6ce0 <malloc+0x13ee>
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	59a080e7          	jalr	1434(ra) # 5512 <open>
    2f80:	36055263          	bgez	a0,32e4 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2f84:	00004517          	auipc	a0,0x4
    2f88:	cbc50513          	add	a0,a0,-836 # 6c40 <malloc+0x134e>
    2f8c:	00002097          	auipc	ra,0x2
    2f90:	5b6080e7          	jalr	1462(ra) # 5542 <chdir>
    2f94:	36051663          	bnez	a0,3300 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2f98:	00004517          	auipc	a0,0x4
    2f9c:	e6850513          	add	a0,a0,-408 # 6e00 <malloc+0x150e>
    2fa0:	00002097          	auipc	ra,0x2
    2fa4:	5a2080e7          	jalr	1442(ra) # 5542 <chdir>
    2fa8:	36051a63          	bnez	a0,331c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2fac:	00004517          	auipc	a0,0x4
    2fb0:	e8450513          	add	a0,a0,-380 # 6e30 <malloc+0x153e>
    2fb4:	00002097          	auipc	ra,0x2
    2fb8:	58e080e7          	jalr	1422(ra) # 5542 <chdir>
    2fbc:	36051e63          	bnez	a0,3338 <subdir+0x50a>
  if(chdir("./..") != 0){
    2fc0:	00004517          	auipc	a0,0x4
    2fc4:	ea050513          	add	a0,a0,-352 # 6e60 <malloc+0x156e>
    2fc8:	00002097          	auipc	ra,0x2
    2fcc:	57a080e7          	jalr	1402(ra) # 5542 <chdir>
    2fd0:	38051263          	bnez	a0,3354 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2fd4:	4581                	li	a1,0
    2fd6:	00004517          	auipc	a0,0x4
    2fda:	d9250513          	add	a0,a0,-622 # 6d68 <malloc+0x1476>
    2fde:	00002097          	auipc	ra,0x2
    2fe2:	534080e7          	jalr	1332(ra) # 5512 <open>
    2fe6:	84aa                	mv	s1,a0
  if(fd < 0){
    2fe8:	38054463          	bltz	a0,3370 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2fec:	660d                	lui	a2,0x3
    2fee:	00009597          	auipc	a1,0x9
    2ff2:	9a258593          	add	a1,a1,-1630 # b990 <buf>
    2ff6:	00002097          	auipc	ra,0x2
    2ffa:	4f4080e7          	jalr	1268(ra) # 54ea <read>
    2ffe:	4789                	li	a5,2
    3000:	38f51663          	bne	a0,a5,338c <subdir+0x55e>
  close(fd);
    3004:	8526                	mv	a0,s1
    3006:	00002097          	auipc	ra,0x2
    300a:	4f4080e7          	jalr	1268(ra) # 54fa <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    300e:	4581                	li	a1,0
    3010:	00004517          	auipc	a0,0x4
    3014:	cd050513          	add	a0,a0,-816 # 6ce0 <malloc+0x13ee>
    3018:	00002097          	auipc	ra,0x2
    301c:	4fa080e7          	jalr	1274(ra) # 5512 <open>
    3020:	38055463          	bgez	a0,33a8 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3024:	20200593          	li	a1,514
    3028:	00004517          	auipc	a0,0x4
    302c:	ec850513          	add	a0,a0,-312 # 6ef0 <malloc+0x15fe>
    3030:	00002097          	auipc	ra,0x2
    3034:	4e2080e7          	jalr	1250(ra) # 5512 <open>
    3038:	38055663          	bgez	a0,33c4 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    303c:	20200593          	li	a1,514
    3040:	00004517          	auipc	a0,0x4
    3044:	ee050513          	add	a0,a0,-288 # 6f20 <malloc+0x162e>
    3048:	00002097          	auipc	ra,0x2
    304c:	4ca080e7          	jalr	1226(ra) # 5512 <open>
    3050:	38055863          	bgez	a0,33e0 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3054:	20000593          	li	a1,512
    3058:	00004517          	auipc	a0,0x4
    305c:	be850513          	add	a0,a0,-1048 # 6c40 <malloc+0x134e>
    3060:	00002097          	auipc	ra,0x2
    3064:	4b2080e7          	jalr	1202(ra) # 5512 <open>
    3068:	38055a63          	bgez	a0,33fc <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    306c:	4589                	li	a1,2
    306e:	00004517          	auipc	a0,0x4
    3072:	bd250513          	add	a0,a0,-1070 # 6c40 <malloc+0x134e>
    3076:	00002097          	auipc	ra,0x2
    307a:	49c080e7          	jalr	1180(ra) # 5512 <open>
    307e:	38055d63          	bgez	a0,3418 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3082:	4585                	li	a1,1
    3084:	00004517          	auipc	a0,0x4
    3088:	bbc50513          	add	a0,a0,-1092 # 6c40 <malloc+0x134e>
    308c:	00002097          	auipc	ra,0x2
    3090:	486080e7          	jalr	1158(ra) # 5512 <open>
    3094:	3a055063          	bgez	a0,3434 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3098:	00004597          	auipc	a1,0x4
    309c:	f1858593          	add	a1,a1,-232 # 6fb0 <malloc+0x16be>
    30a0:	00004517          	auipc	a0,0x4
    30a4:	e5050513          	add	a0,a0,-432 # 6ef0 <malloc+0x15fe>
    30a8:	00002097          	auipc	ra,0x2
    30ac:	48a080e7          	jalr	1162(ra) # 5532 <link>
    30b0:	3a050063          	beqz	a0,3450 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    30b4:	00004597          	auipc	a1,0x4
    30b8:	efc58593          	add	a1,a1,-260 # 6fb0 <malloc+0x16be>
    30bc:	00004517          	auipc	a0,0x4
    30c0:	e6450513          	add	a0,a0,-412 # 6f20 <malloc+0x162e>
    30c4:	00002097          	auipc	ra,0x2
    30c8:	46e080e7          	jalr	1134(ra) # 5532 <link>
    30cc:	3a050063          	beqz	a0,346c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    30d0:	00004597          	auipc	a1,0x4
    30d4:	c9858593          	add	a1,a1,-872 # 6d68 <malloc+0x1476>
    30d8:	00004517          	auipc	a0,0x4
    30dc:	b8850513          	add	a0,a0,-1144 # 6c60 <malloc+0x136e>
    30e0:	00002097          	auipc	ra,0x2
    30e4:	452080e7          	jalr	1106(ra) # 5532 <link>
    30e8:	3a050063          	beqz	a0,3488 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    30ec:	00004517          	auipc	a0,0x4
    30f0:	e0450513          	add	a0,a0,-508 # 6ef0 <malloc+0x15fe>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	446080e7          	jalr	1094(ra) # 553a <mkdir>
    30fc:	3a050463          	beqz	a0,34a4 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3100:	00004517          	auipc	a0,0x4
    3104:	e2050513          	add	a0,a0,-480 # 6f20 <malloc+0x162e>
    3108:	00002097          	auipc	ra,0x2
    310c:	432080e7          	jalr	1074(ra) # 553a <mkdir>
    3110:	3a050863          	beqz	a0,34c0 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3114:	00004517          	auipc	a0,0x4
    3118:	c5450513          	add	a0,a0,-940 # 6d68 <malloc+0x1476>
    311c:	00002097          	auipc	ra,0x2
    3120:	41e080e7          	jalr	1054(ra) # 553a <mkdir>
    3124:	3a050c63          	beqz	a0,34dc <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3128:	00004517          	auipc	a0,0x4
    312c:	df850513          	add	a0,a0,-520 # 6f20 <malloc+0x162e>
    3130:	00002097          	auipc	ra,0x2
    3134:	3f2080e7          	jalr	1010(ra) # 5522 <unlink>
    3138:	3c050063          	beqz	a0,34f8 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    313c:	00004517          	auipc	a0,0x4
    3140:	db450513          	add	a0,a0,-588 # 6ef0 <malloc+0x15fe>
    3144:	00002097          	auipc	ra,0x2
    3148:	3de080e7          	jalr	990(ra) # 5522 <unlink>
    314c:	3c050463          	beqz	a0,3514 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3150:	00004517          	auipc	a0,0x4
    3154:	b1050513          	add	a0,a0,-1264 # 6c60 <malloc+0x136e>
    3158:	00002097          	auipc	ra,0x2
    315c:	3ea080e7          	jalr	1002(ra) # 5542 <chdir>
    3160:	3c050863          	beqz	a0,3530 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3164:	00004517          	auipc	a0,0x4
    3168:	f9c50513          	add	a0,a0,-100 # 7100 <malloc+0x180e>
    316c:	00002097          	auipc	ra,0x2
    3170:	3d6080e7          	jalr	982(ra) # 5542 <chdir>
    3174:	3c050c63          	beqz	a0,354c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3178:	00004517          	auipc	a0,0x4
    317c:	bf050513          	add	a0,a0,-1040 # 6d68 <malloc+0x1476>
    3180:	00002097          	auipc	ra,0x2
    3184:	3a2080e7          	jalr	930(ra) # 5522 <unlink>
    3188:	3e051063          	bnez	a0,3568 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    318c:	00004517          	auipc	a0,0x4
    3190:	ad450513          	add	a0,a0,-1324 # 6c60 <malloc+0x136e>
    3194:	00002097          	auipc	ra,0x2
    3198:	38e080e7          	jalr	910(ra) # 5522 <unlink>
    319c:	3e051463          	bnez	a0,3584 <subdir+0x756>
  if(unlink("dd") == 0){
    31a0:	00004517          	auipc	a0,0x4
    31a4:	aa050513          	add	a0,a0,-1376 # 6c40 <malloc+0x134e>
    31a8:	00002097          	auipc	ra,0x2
    31ac:	37a080e7          	jalr	890(ra) # 5522 <unlink>
    31b0:	3e050863          	beqz	a0,35a0 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    31b4:	00004517          	auipc	a0,0x4
    31b8:	fbc50513          	add	a0,a0,-68 # 7170 <malloc+0x187e>
    31bc:	00002097          	auipc	ra,0x2
    31c0:	366080e7          	jalr	870(ra) # 5522 <unlink>
    31c4:	3e054c63          	bltz	a0,35bc <subdir+0x78e>
  if(unlink("dd") < 0){
    31c8:	00004517          	auipc	a0,0x4
    31cc:	a7850513          	add	a0,a0,-1416 # 6c40 <malloc+0x134e>
    31d0:	00002097          	auipc	ra,0x2
    31d4:	352080e7          	jalr	850(ra) # 5522 <unlink>
    31d8:	40054063          	bltz	a0,35d8 <subdir+0x7aa>
}
    31dc:	60e2                	ld	ra,24(sp)
    31de:	6442                	ld	s0,16(sp)
    31e0:	64a2                	ld	s1,8(sp)
    31e2:	6902                	ld	s2,0(sp)
    31e4:	6105                	add	sp,sp,32
    31e6:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    31e8:	85ca                	mv	a1,s2
    31ea:	00004517          	auipc	a0,0x4
    31ee:	a5e50513          	add	a0,a0,-1442 # 6c48 <malloc+0x1356>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	648080e7          	jalr	1608(ra) # 583a <printf>
    exit(1);
    31fa:	4505                	li	a0,1
    31fc:	00002097          	auipc	ra,0x2
    3200:	2d6080e7          	jalr	726(ra) # 54d2 <exit>
    printf("%s: create dd/ff failed\n", s);
    3204:	85ca                	mv	a1,s2
    3206:	00004517          	auipc	a0,0x4
    320a:	a6250513          	add	a0,a0,-1438 # 6c68 <malloc+0x1376>
    320e:	00002097          	auipc	ra,0x2
    3212:	62c080e7          	jalr	1580(ra) # 583a <printf>
    exit(1);
    3216:	4505                	li	a0,1
    3218:	00002097          	auipc	ra,0x2
    321c:	2ba080e7          	jalr	698(ra) # 54d2 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3220:	85ca                	mv	a1,s2
    3222:	00004517          	auipc	a0,0x4
    3226:	a6650513          	add	a0,a0,-1434 # 6c88 <malloc+0x1396>
    322a:	00002097          	auipc	ra,0x2
    322e:	610080e7          	jalr	1552(ra) # 583a <printf>
    exit(1);
    3232:	4505                	li	a0,1
    3234:	00002097          	auipc	ra,0x2
    3238:	29e080e7          	jalr	670(ra) # 54d2 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    323c:	85ca                	mv	a1,s2
    323e:	00004517          	auipc	a0,0x4
    3242:	a8250513          	add	a0,a0,-1406 # 6cc0 <malloc+0x13ce>
    3246:	00002097          	auipc	ra,0x2
    324a:	5f4080e7          	jalr	1524(ra) # 583a <printf>
    exit(1);
    324e:	4505                	li	a0,1
    3250:	00002097          	auipc	ra,0x2
    3254:	282080e7          	jalr	642(ra) # 54d2 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3258:	85ca                	mv	a1,s2
    325a:	00004517          	auipc	a0,0x4
    325e:	a9650513          	add	a0,a0,-1386 # 6cf0 <malloc+0x13fe>
    3262:	00002097          	auipc	ra,0x2
    3266:	5d8080e7          	jalr	1496(ra) # 583a <printf>
    exit(1);
    326a:	4505                	li	a0,1
    326c:	00002097          	auipc	ra,0x2
    3270:	266080e7          	jalr	614(ra) # 54d2 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3274:	85ca                	mv	a1,s2
    3276:	00004517          	auipc	a0,0x4
    327a:	ab250513          	add	a0,a0,-1358 # 6d28 <malloc+0x1436>
    327e:	00002097          	auipc	ra,0x2
    3282:	5bc080e7          	jalr	1468(ra) # 583a <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	00002097          	auipc	ra,0x2
    328c:	24a080e7          	jalr	586(ra) # 54d2 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3290:	85ca                	mv	a1,s2
    3292:	00004517          	auipc	a0,0x4
    3296:	ab650513          	add	a0,a0,-1354 # 6d48 <malloc+0x1456>
    329a:	00002097          	auipc	ra,0x2
    329e:	5a0080e7          	jalr	1440(ra) # 583a <printf>
    exit(1);
    32a2:	4505                	li	a0,1
    32a4:	00002097          	auipc	ra,0x2
    32a8:	22e080e7          	jalr	558(ra) # 54d2 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    32ac:	85ca                	mv	a1,s2
    32ae:	00004517          	auipc	a0,0x4
    32b2:	aca50513          	add	a0,a0,-1334 # 6d78 <malloc+0x1486>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	584080e7          	jalr	1412(ra) # 583a <printf>
    exit(1);
    32be:	4505                	li	a0,1
    32c0:	00002097          	auipc	ra,0x2
    32c4:	212080e7          	jalr	530(ra) # 54d2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    32c8:	85ca                	mv	a1,s2
    32ca:	00004517          	auipc	a0,0x4
    32ce:	ad650513          	add	a0,a0,-1322 # 6da0 <malloc+0x14ae>
    32d2:	00002097          	auipc	ra,0x2
    32d6:	568080e7          	jalr	1384(ra) # 583a <printf>
    exit(1);
    32da:	4505                	li	a0,1
    32dc:	00002097          	auipc	ra,0x2
    32e0:	1f6080e7          	jalr	502(ra) # 54d2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    32e4:	85ca                	mv	a1,s2
    32e6:	00004517          	auipc	a0,0x4
    32ea:	ada50513          	add	a0,a0,-1318 # 6dc0 <malloc+0x14ce>
    32ee:	00002097          	auipc	ra,0x2
    32f2:	54c080e7          	jalr	1356(ra) # 583a <printf>
    exit(1);
    32f6:	4505                	li	a0,1
    32f8:	00002097          	auipc	ra,0x2
    32fc:	1da080e7          	jalr	474(ra) # 54d2 <exit>
    printf("%s: chdir dd failed\n", s);
    3300:	85ca                	mv	a1,s2
    3302:	00004517          	auipc	a0,0x4
    3306:	ae650513          	add	a0,a0,-1306 # 6de8 <malloc+0x14f6>
    330a:	00002097          	auipc	ra,0x2
    330e:	530080e7          	jalr	1328(ra) # 583a <printf>
    exit(1);
    3312:	4505                	li	a0,1
    3314:	00002097          	auipc	ra,0x2
    3318:	1be080e7          	jalr	446(ra) # 54d2 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    331c:	85ca                	mv	a1,s2
    331e:	00004517          	auipc	a0,0x4
    3322:	af250513          	add	a0,a0,-1294 # 6e10 <malloc+0x151e>
    3326:	00002097          	auipc	ra,0x2
    332a:	514080e7          	jalr	1300(ra) # 583a <printf>
    exit(1);
    332e:	4505                	li	a0,1
    3330:	00002097          	auipc	ra,0x2
    3334:	1a2080e7          	jalr	418(ra) # 54d2 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3338:	85ca                	mv	a1,s2
    333a:	00004517          	auipc	a0,0x4
    333e:	b0650513          	add	a0,a0,-1274 # 6e40 <malloc+0x154e>
    3342:	00002097          	auipc	ra,0x2
    3346:	4f8080e7          	jalr	1272(ra) # 583a <printf>
    exit(1);
    334a:	4505                	li	a0,1
    334c:	00002097          	auipc	ra,0x2
    3350:	186080e7          	jalr	390(ra) # 54d2 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3354:	85ca                	mv	a1,s2
    3356:	00004517          	auipc	a0,0x4
    335a:	b1250513          	add	a0,a0,-1262 # 6e68 <malloc+0x1576>
    335e:	00002097          	auipc	ra,0x2
    3362:	4dc080e7          	jalr	1244(ra) # 583a <printf>
    exit(1);
    3366:	4505                	li	a0,1
    3368:	00002097          	auipc	ra,0x2
    336c:	16a080e7          	jalr	362(ra) # 54d2 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3370:	85ca                	mv	a1,s2
    3372:	00004517          	auipc	a0,0x4
    3376:	b0e50513          	add	a0,a0,-1266 # 6e80 <malloc+0x158e>
    337a:	00002097          	auipc	ra,0x2
    337e:	4c0080e7          	jalr	1216(ra) # 583a <printf>
    exit(1);
    3382:	4505                	li	a0,1
    3384:	00002097          	auipc	ra,0x2
    3388:	14e080e7          	jalr	334(ra) # 54d2 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    338c:	85ca                	mv	a1,s2
    338e:	00004517          	auipc	a0,0x4
    3392:	b1250513          	add	a0,a0,-1262 # 6ea0 <malloc+0x15ae>
    3396:	00002097          	auipc	ra,0x2
    339a:	4a4080e7          	jalr	1188(ra) # 583a <printf>
    exit(1);
    339e:	4505                	li	a0,1
    33a0:	00002097          	auipc	ra,0x2
    33a4:	132080e7          	jalr	306(ra) # 54d2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    33a8:	85ca                	mv	a1,s2
    33aa:	00004517          	auipc	a0,0x4
    33ae:	b1650513          	add	a0,a0,-1258 # 6ec0 <malloc+0x15ce>
    33b2:	00002097          	auipc	ra,0x2
    33b6:	488080e7          	jalr	1160(ra) # 583a <printf>
    exit(1);
    33ba:	4505                	li	a0,1
    33bc:	00002097          	auipc	ra,0x2
    33c0:	116080e7          	jalr	278(ra) # 54d2 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    33c4:	85ca                	mv	a1,s2
    33c6:	00004517          	auipc	a0,0x4
    33ca:	b3a50513          	add	a0,a0,-1222 # 6f00 <malloc+0x160e>
    33ce:	00002097          	auipc	ra,0x2
    33d2:	46c080e7          	jalr	1132(ra) # 583a <printf>
    exit(1);
    33d6:	4505                	li	a0,1
    33d8:	00002097          	auipc	ra,0x2
    33dc:	0fa080e7          	jalr	250(ra) # 54d2 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    33e0:	85ca                	mv	a1,s2
    33e2:	00004517          	auipc	a0,0x4
    33e6:	b4e50513          	add	a0,a0,-1202 # 6f30 <malloc+0x163e>
    33ea:	00002097          	auipc	ra,0x2
    33ee:	450080e7          	jalr	1104(ra) # 583a <printf>
    exit(1);
    33f2:	4505                	li	a0,1
    33f4:	00002097          	auipc	ra,0x2
    33f8:	0de080e7          	jalr	222(ra) # 54d2 <exit>
    printf("%s: create dd succeeded!\n", s);
    33fc:	85ca                	mv	a1,s2
    33fe:	00004517          	auipc	a0,0x4
    3402:	b5250513          	add	a0,a0,-1198 # 6f50 <malloc+0x165e>
    3406:	00002097          	auipc	ra,0x2
    340a:	434080e7          	jalr	1076(ra) # 583a <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	00002097          	auipc	ra,0x2
    3414:	0c2080e7          	jalr	194(ra) # 54d2 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3418:	85ca                	mv	a1,s2
    341a:	00004517          	auipc	a0,0x4
    341e:	b5650513          	add	a0,a0,-1194 # 6f70 <malloc+0x167e>
    3422:	00002097          	auipc	ra,0x2
    3426:	418080e7          	jalr	1048(ra) # 583a <printf>
    exit(1);
    342a:	4505                	li	a0,1
    342c:	00002097          	auipc	ra,0x2
    3430:	0a6080e7          	jalr	166(ra) # 54d2 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3434:	85ca                	mv	a1,s2
    3436:	00004517          	auipc	a0,0x4
    343a:	b5a50513          	add	a0,a0,-1190 # 6f90 <malloc+0x169e>
    343e:	00002097          	auipc	ra,0x2
    3442:	3fc080e7          	jalr	1020(ra) # 583a <printf>
    exit(1);
    3446:	4505                	li	a0,1
    3448:	00002097          	auipc	ra,0x2
    344c:	08a080e7          	jalr	138(ra) # 54d2 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3450:	85ca                	mv	a1,s2
    3452:	00004517          	auipc	a0,0x4
    3456:	b6e50513          	add	a0,a0,-1170 # 6fc0 <malloc+0x16ce>
    345a:	00002097          	auipc	ra,0x2
    345e:	3e0080e7          	jalr	992(ra) # 583a <printf>
    exit(1);
    3462:	4505                	li	a0,1
    3464:	00002097          	auipc	ra,0x2
    3468:	06e080e7          	jalr	110(ra) # 54d2 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    346c:	85ca                	mv	a1,s2
    346e:	00004517          	auipc	a0,0x4
    3472:	b7a50513          	add	a0,a0,-1158 # 6fe8 <malloc+0x16f6>
    3476:	00002097          	auipc	ra,0x2
    347a:	3c4080e7          	jalr	964(ra) # 583a <printf>
    exit(1);
    347e:	4505                	li	a0,1
    3480:	00002097          	auipc	ra,0x2
    3484:	052080e7          	jalr	82(ra) # 54d2 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3488:	85ca                	mv	a1,s2
    348a:	00004517          	auipc	a0,0x4
    348e:	b8650513          	add	a0,a0,-1146 # 7010 <malloc+0x171e>
    3492:	00002097          	auipc	ra,0x2
    3496:	3a8080e7          	jalr	936(ra) # 583a <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	00002097          	auipc	ra,0x2
    34a0:	036080e7          	jalr	54(ra) # 54d2 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    34a4:	85ca                	mv	a1,s2
    34a6:	00004517          	auipc	a0,0x4
    34aa:	b9250513          	add	a0,a0,-1134 # 7038 <malloc+0x1746>
    34ae:	00002097          	auipc	ra,0x2
    34b2:	38c080e7          	jalr	908(ra) # 583a <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	01a080e7          	jalr	26(ra) # 54d2 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    34c0:	85ca                	mv	a1,s2
    34c2:	00004517          	auipc	a0,0x4
    34c6:	b9650513          	add	a0,a0,-1130 # 7058 <malloc+0x1766>
    34ca:	00002097          	auipc	ra,0x2
    34ce:	370080e7          	jalr	880(ra) # 583a <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	ffe080e7          	jalr	-2(ra) # 54d2 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    34dc:	85ca                	mv	a1,s2
    34de:	00004517          	auipc	a0,0x4
    34e2:	b9a50513          	add	a0,a0,-1126 # 7078 <malloc+0x1786>
    34e6:	00002097          	auipc	ra,0x2
    34ea:	354080e7          	jalr	852(ra) # 583a <printf>
    exit(1);
    34ee:	4505                	li	a0,1
    34f0:	00002097          	auipc	ra,0x2
    34f4:	fe2080e7          	jalr	-30(ra) # 54d2 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    34f8:	85ca                	mv	a1,s2
    34fa:	00004517          	auipc	a0,0x4
    34fe:	ba650513          	add	a0,a0,-1114 # 70a0 <malloc+0x17ae>
    3502:	00002097          	auipc	ra,0x2
    3506:	338080e7          	jalr	824(ra) # 583a <printf>
    exit(1);
    350a:	4505                	li	a0,1
    350c:	00002097          	auipc	ra,0x2
    3510:	fc6080e7          	jalr	-58(ra) # 54d2 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3514:	85ca                	mv	a1,s2
    3516:	00004517          	auipc	a0,0x4
    351a:	baa50513          	add	a0,a0,-1110 # 70c0 <malloc+0x17ce>
    351e:	00002097          	auipc	ra,0x2
    3522:	31c080e7          	jalr	796(ra) # 583a <printf>
    exit(1);
    3526:	4505                	li	a0,1
    3528:	00002097          	auipc	ra,0x2
    352c:	faa080e7          	jalr	-86(ra) # 54d2 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3530:	85ca                	mv	a1,s2
    3532:	00004517          	auipc	a0,0x4
    3536:	bae50513          	add	a0,a0,-1106 # 70e0 <malloc+0x17ee>
    353a:	00002097          	auipc	ra,0x2
    353e:	300080e7          	jalr	768(ra) # 583a <printf>
    exit(1);
    3542:	4505                	li	a0,1
    3544:	00002097          	auipc	ra,0x2
    3548:	f8e080e7          	jalr	-114(ra) # 54d2 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    354c:	85ca                	mv	a1,s2
    354e:	00004517          	auipc	a0,0x4
    3552:	bba50513          	add	a0,a0,-1094 # 7108 <malloc+0x1816>
    3556:	00002097          	auipc	ra,0x2
    355a:	2e4080e7          	jalr	740(ra) # 583a <printf>
    exit(1);
    355e:	4505                	li	a0,1
    3560:	00002097          	auipc	ra,0x2
    3564:	f72080e7          	jalr	-142(ra) # 54d2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3568:	85ca                	mv	a1,s2
    356a:	00004517          	auipc	a0,0x4
    356e:	83650513          	add	a0,a0,-1994 # 6da0 <malloc+0x14ae>
    3572:	00002097          	auipc	ra,0x2
    3576:	2c8080e7          	jalr	712(ra) # 583a <printf>
    exit(1);
    357a:	4505                	li	a0,1
    357c:	00002097          	auipc	ra,0x2
    3580:	f56080e7          	jalr	-170(ra) # 54d2 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3584:	85ca                	mv	a1,s2
    3586:	00004517          	auipc	a0,0x4
    358a:	ba250513          	add	a0,a0,-1118 # 7128 <malloc+0x1836>
    358e:	00002097          	auipc	ra,0x2
    3592:	2ac080e7          	jalr	684(ra) # 583a <printf>
    exit(1);
    3596:	4505                	li	a0,1
    3598:	00002097          	auipc	ra,0x2
    359c:	f3a080e7          	jalr	-198(ra) # 54d2 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    35a0:	85ca                	mv	a1,s2
    35a2:	00004517          	auipc	a0,0x4
    35a6:	ba650513          	add	a0,a0,-1114 # 7148 <malloc+0x1856>
    35aa:	00002097          	auipc	ra,0x2
    35ae:	290080e7          	jalr	656(ra) # 583a <printf>
    exit(1);
    35b2:	4505                	li	a0,1
    35b4:	00002097          	auipc	ra,0x2
    35b8:	f1e080e7          	jalr	-226(ra) # 54d2 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    35bc:	85ca                	mv	a1,s2
    35be:	00004517          	auipc	a0,0x4
    35c2:	bba50513          	add	a0,a0,-1094 # 7178 <malloc+0x1886>
    35c6:	00002097          	auipc	ra,0x2
    35ca:	274080e7          	jalr	628(ra) # 583a <printf>
    exit(1);
    35ce:	4505                	li	a0,1
    35d0:	00002097          	auipc	ra,0x2
    35d4:	f02080e7          	jalr	-254(ra) # 54d2 <exit>
    printf("%s: unlink dd failed\n", s);
    35d8:	85ca                	mv	a1,s2
    35da:	00004517          	auipc	a0,0x4
    35de:	bbe50513          	add	a0,a0,-1090 # 7198 <malloc+0x18a6>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	258080e7          	jalr	600(ra) # 583a <printf>
    exit(1);
    35ea:	4505                	li	a0,1
    35ec:	00002097          	auipc	ra,0x2
    35f0:	ee6080e7          	jalr	-282(ra) # 54d2 <exit>

00000000000035f4 <rmdot>:
{
    35f4:	1101                	add	sp,sp,-32
    35f6:	ec06                	sd	ra,24(sp)
    35f8:	e822                	sd	s0,16(sp)
    35fa:	e426                	sd	s1,8(sp)
    35fc:	1000                	add	s0,sp,32
    35fe:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3600:	00004517          	auipc	a0,0x4
    3604:	bb050513          	add	a0,a0,-1104 # 71b0 <malloc+0x18be>
    3608:	00002097          	auipc	ra,0x2
    360c:	f32080e7          	jalr	-206(ra) # 553a <mkdir>
    3610:	e549                	bnez	a0,369a <rmdot+0xa6>
  if(chdir("dots") != 0){
    3612:	00004517          	auipc	a0,0x4
    3616:	b9e50513          	add	a0,a0,-1122 # 71b0 <malloc+0x18be>
    361a:	00002097          	auipc	ra,0x2
    361e:	f28080e7          	jalr	-216(ra) # 5542 <chdir>
    3622:	e951                	bnez	a0,36b6 <rmdot+0xc2>
  if(unlink(".") == 0){
    3624:	00003517          	auipc	a0,0x3
    3628:	aa450513          	add	a0,a0,-1372 # 60c8 <malloc+0x7d6>
    362c:	00002097          	auipc	ra,0x2
    3630:	ef6080e7          	jalr	-266(ra) # 5522 <unlink>
    3634:	cd59                	beqz	a0,36d2 <rmdot+0xde>
  if(unlink("..") == 0){
    3636:	00004517          	auipc	a0,0x4
    363a:	bca50513          	add	a0,a0,-1078 # 7200 <malloc+0x190e>
    363e:	00002097          	auipc	ra,0x2
    3642:	ee4080e7          	jalr	-284(ra) # 5522 <unlink>
    3646:	c545                	beqz	a0,36ee <rmdot+0xfa>
  if(chdir("/") != 0){
    3648:	00003517          	auipc	a0,0x3
    364c:	5c050513          	add	a0,a0,1472 # 6c08 <malloc+0x1316>
    3650:	00002097          	auipc	ra,0x2
    3654:	ef2080e7          	jalr	-270(ra) # 5542 <chdir>
    3658:	e94d                	bnez	a0,370a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    365a:	00004517          	auipc	a0,0x4
    365e:	bc650513          	add	a0,a0,-1082 # 7220 <malloc+0x192e>
    3662:	00002097          	auipc	ra,0x2
    3666:	ec0080e7          	jalr	-320(ra) # 5522 <unlink>
    366a:	cd55                	beqz	a0,3726 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    366c:	00004517          	auipc	a0,0x4
    3670:	bdc50513          	add	a0,a0,-1060 # 7248 <malloc+0x1956>
    3674:	00002097          	auipc	ra,0x2
    3678:	eae080e7          	jalr	-338(ra) # 5522 <unlink>
    367c:	c179                	beqz	a0,3742 <rmdot+0x14e>
  if(unlink("dots") != 0){
    367e:	00004517          	auipc	a0,0x4
    3682:	b3250513          	add	a0,a0,-1230 # 71b0 <malloc+0x18be>
    3686:	00002097          	auipc	ra,0x2
    368a:	e9c080e7          	jalr	-356(ra) # 5522 <unlink>
    368e:	e961                	bnez	a0,375e <rmdot+0x16a>
}
    3690:	60e2                	ld	ra,24(sp)
    3692:	6442                	ld	s0,16(sp)
    3694:	64a2                	ld	s1,8(sp)
    3696:	6105                	add	sp,sp,32
    3698:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    369a:	85a6                	mv	a1,s1
    369c:	00004517          	auipc	a0,0x4
    36a0:	b1c50513          	add	a0,a0,-1252 # 71b8 <malloc+0x18c6>
    36a4:	00002097          	auipc	ra,0x2
    36a8:	196080e7          	jalr	406(ra) # 583a <printf>
    exit(1);
    36ac:	4505                	li	a0,1
    36ae:	00002097          	auipc	ra,0x2
    36b2:	e24080e7          	jalr	-476(ra) # 54d2 <exit>
    printf("%s: chdir dots failed\n", s);
    36b6:	85a6                	mv	a1,s1
    36b8:	00004517          	auipc	a0,0x4
    36bc:	b1850513          	add	a0,a0,-1256 # 71d0 <malloc+0x18de>
    36c0:	00002097          	auipc	ra,0x2
    36c4:	17a080e7          	jalr	378(ra) # 583a <printf>
    exit(1);
    36c8:	4505                	li	a0,1
    36ca:	00002097          	auipc	ra,0x2
    36ce:	e08080e7          	jalr	-504(ra) # 54d2 <exit>
    printf("%s: rm . worked!\n", s);
    36d2:	85a6                	mv	a1,s1
    36d4:	00004517          	auipc	a0,0x4
    36d8:	b1450513          	add	a0,a0,-1260 # 71e8 <malloc+0x18f6>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	15e080e7          	jalr	350(ra) # 583a <printf>
    exit(1);
    36e4:	4505                	li	a0,1
    36e6:	00002097          	auipc	ra,0x2
    36ea:	dec080e7          	jalr	-532(ra) # 54d2 <exit>
    printf("%s: rm .. worked!\n", s);
    36ee:	85a6                	mv	a1,s1
    36f0:	00004517          	auipc	a0,0x4
    36f4:	b1850513          	add	a0,a0,-1256 # 7208 <malloc+0x1916>
    36f8:	00002097          	auipc	ra,0x2
    36fc:	142080e7          	jalr	322(ra) # 583a <printf>
    exit(1);
    3700:	4505                	li	a0,1
    3702:	00002097          	auipc	ra,0x2
    3706:	dd0080e7          	jalr	-560(ra) # 54d2 <exit>
    printf("%s: chdir / failed\n", s);
    370a:	85a6                	mv	a1,s1
    370c:	00003517          	auipc	a0,0x3
    3710:	50450513          	add	a0,a0,1284 # 6c10 <malloc+0x131e>
    3714:	00002097          	auipc	ra,0x2
    3718:	126080e7          	jalr	294(ra) # 583a <printf>
    exit(1);
    371c:	4505                	li	a0,1
    371e:	00002097          	auipc	ra,0x2
    3722:	db4080e7          	jalr	-588(ra) # 54d2 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3726:	85a6                	mv	a1,s1
    3728:	00004517          	auipc	a0,0x4
    372c:	b0050513          	add	a0,a0,-1280 # 7228 <malloc+0x1936>
    3730:	00002097          	auipc	ra,0x2
    3734:	10a080e7          	jalr	266(ra) # 583a <printf>
    exit(1);
    3738:	4505                	li	a0,1
    373a:	00002097          	auipc	ra,0x2
    373e:	d98080e7          	jalr	-616(ra) # 54d2 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3742:	85a6                	mv	a1,s1
    3744:	00004517          	auipc	a0,0x4
    3748:	b0c50513          	add	a0,a0,-1268 # 7250 <malloc+0x195e>
    374c:	00002097          	auipc	ra,0x2
    3750:	0ee080e7          	jalr	238(ra) # 583a <printf>
    exit(1);
    3754:	4505                	li	a0,1
    3756:	00002097          	auipc	ra,0x2
    375a:	d7c080e7          	jalr	-644(ra) # 54d2 <exit>
    printf("%s: unlink dots failed!\n", s);
    375e:	85a6                	mv	a1,s1
    3760:	00004517          	auipc	a0,0x4
    3764:	b1050513          	add	a0,a0,-1264 # 7270 <malloc+0x197e>
    3768:	00002097          	auipc	ra,0x2
    376c:	0d2080e7          	jalr	210(ra) # 583a <printf>
    exit(1);
    3770:	4505                	li	a0,1
    3772:	00002097          	auipc	ra,0x2
    3776:	d60080e7          	jalr	-672(ra) # 54d2 <exit>

000000000000377a <dirfile>:
{
    377a:	1101                	add	sp,sp,-32
    377c:	ec06                	sd	ra,24(sp)
    377e:	e822                	sd	s0,16(sp)
    3780:	e426                	sd	s1,8(sp)
    3782:	e04a                	sd	s2,0(sp)
    3784:	1000                	add	s0,sp,32
    3786:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3788:	20000593          	li	a1,512
    378c:	00004517          	auipc	a0,0x4
    3790:	b0450513          	add	a0,a0,-1276 # 7290 <malloc+0x199e>
    3794:	00002097          	auipc	ra,0x2
    3798:	d7e080e7          	jalr	-642(ra) # 5512 <open>
  if(fd < 0){
    379c:	0e054d63          	bltz	a0,3896 <dirfile+0x11c>
  close(fd);
    37a0:	00002097          	auipc	ra,0x2
    37a4:	d5a080e7          	jalr	-678(ra) # 54fa <close>
  if(chdir("dirfile") == 0){
    37a8:	00004517          	auipc	a0,0x4
    37ac:	ae850513          	add	a0,a0,-1304 # 7290 <malloc+0x199e>
    37b0:	00002097          	auipc	ra,0x2
    37b4:	d92080e7          	jalr	-622(ra) # 5542 <chdir>
    37b8:	cd6d                	beqz	a0,38b2 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    37ba:	4581                	li	a1,0
    37bc:	00004517          	auipc	a0,0x4
    37c0:	b1c50513          	add	a0,a0,-1252 # 72d8 <malloc+0x19e6>
    37c4:	00002097          	auipc	ra,0x2
    37c8:	d4e080e7          	jalr	-690(ra) # 5512 <open>
  if(fd >= 0){
    37cc:	10055163          	bgez	a0,38ce <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    37d0:	20000593          	li	a1,512
    37d4:	00004517          	auipc	a0,0x4
    37d8:	b0450513          	add	a0,a0,-1276 # 72d8 <malloc+0x19e6>
    37dc:	00002097          	auipc	ra,0x2
    37e0:	d36080e7          	jalr	-714(ra) # 5512 <open>
  if(fd >= 0){
    37e4:	10055363          	bgez	a0,38ea <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    37e8:	00004517          	auipc	a0,0x4
    37ec:	af050513          	add	a0,a0,-1296 # 72d8 <malloc+0x19e6>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	d4a080e7          	jalr	-694(ra) # 553a <mkdir>
    37f8:	10050763          	beqz	a0,3906 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    37fc:	00004517          	auipc	a0,0x4
    3800:	adc50513          	add	a0,a0,-1316 # 72d8 <malloc+0x19e6>
    3804:	00002097          	auipc	ra,0x2
    3808:	d1e080e7          	jalr	-738(ra) # 5522 <unlink>
    380c:	10050b63          	beqz	a0,3922 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3810:	00004597          	auipc	a1,0x4
    3814:	ac858593          	add	a1,a1,-1336 # 72d8 <malloc+0x19e6>
    3818:	00002517          	auipc	a0,0x2
    381c:	3a050513          	add	a0,a0,928 # 5bb8 <malloc+0x2c6>
    3820:	00002097          	auipc	ra,0x2
    3824:	d12080e7          	jalr	-750(ra) # 5532 <link>
    3828:	10050b63          	beqz	a0,393e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    382c:	00004517          	auipc	a0,0x4
    3830:	a6450513          	add	a0,a0,-1436 # 7290 <malloc+0x199e>
    3834:	00002097          	auipc	ra,0x2
    3838:	cee080e7          	jalr	-786(ra) # 5522 <unlink>
    383c:	10051f63          	bnez	a0,395a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3840:	4589                	li	a1,2
    3842:	00003517          	auipc	a0,0x3
    3846:	88650513          	add	a0,a0,-1914 # 60c8 <malloc+0x7d6>
    384a:	00002097          	auipc	ra,0x2
    384e:	cc8080e7          	jalr	-824(ra) # 5512 <open>
  if(fd >= 0){
    3852:	12055263          	bgez	a0,3976 <dirfile+0x1fc>
  fd = open(".", 0);
    3856:	4581                	li	a1,0
    3858:	00003517          	auipc	a0,0x3
    385c:	87050513          	add	a0,a0,-1936 # 60c8 <malloc+0x7d6>
    3860:	00002097          	auipc	ra,0x2
    3864:	cb2080e7          	jalr	-846(ra) # 5512 <open>
    3868:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    386a:	4605                	li	a2,1
    386c:	00002597          	auipc	a1,0x2
    3870:	21458593          	add	a1,a1,532 # 5a80 <malloc+0x18e>
    3874:	00002097          	auipc	ra,0x2
    3878:	c7e080e7          	jalr	-898(ra) # 54f2 <write>
    387c:	10a04b63          	bgtz	a0,3992 <dirfile+0x218>
  close(fd);
    3880:	8526                	mv	a0,s1
    3882:	00002097          	auipc	ra,0x2
    3886:	c78080e7          	jalr	-904(ra) # 54fa <close>
}
    388a:	60e2                	ld	ra,24(sp)
    388c:	6442                	ld	s0,16(sp)
    388e:	64a2                	ld	s1,8(sp)
    3890:	6902                	ld	s2,0(sp)
    3892:	6105                	add	sp,sp,32
    3894:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3896:	85ca                	mv	a1,s2
    3898:	00004517          	auipc	a0,0x4
    389c:	a0050513          	add	a0,a0,-1536 # 7298 <malloc+0x19a6>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	f9a080e7          	jalr	-102(ra) # 583a <printf>
    exit(1);
    38a8:	4505                	li	a0,1
    38aa:	00002097          	auipc	ra,0x2
    38ae:	c28080e7          	jalr	-984(ra) # 54d2 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    38b2:	85ca                	mv	a1,s2
    38b4:	00004517          	auipc	a0,0x4
    38b8:	a0450513          	add	a0,a0,-1532 # 72b8 <malloc+0x19c6>
    38bc:	00002097          	auipc	ra,0x2
    38c0:	f7e080e7          	jalr	-130(ra) # 583a <printf>
    exit(1);
    38c4:	4505                	li	a0,1
    38c6:	00002097          	auipc	ra,0x2
    38ca:	c0c080e7          	jalr	-1012(ra) # 54d2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    38ce:	85ca                	mv	a1,s2
    38d0:	00004517          	auipc	a0,0x4
    38d4:	a1850513          	add	a0,a0,-1512 # 72e8 <malloc+0x19f6>
    38d8:	00002097          	auipc	ra,0x2
    38dc:	f62080e7          	jalr	-158(ra) # 583a <printf>
    exit(1);
    38e0:	4505                	li	a0,1
    38e2:	00002097          	auipc	ra,0x2
    38e6:	bf0080e7          	jalr	-1040(ra) # 54d2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    38ea:	85ca                	mv	a1,s2
    38ec:	00004517          	auipc	a0,0x4
    38f0:	9fc50513          	add	a0,a0,-1540 # 72e8 <malloc+0x19f6>
    38f4:	00002097          	auipc	ra,0x2
    38f8:	f46080e7          	jalr	-186(ra) # 583a <printf>
    exit(1);
    38fc:	4505                	li	a0,1
    38fe:	00002097          	auipc	ra,0x2
    3902:	bd4080e7          	jalr	-1068(ra) # 54d2 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3906:	85ca                	mv	a1,s2
    3908:	00004517          	auipc	a0,0x4
    390c:	a0850513          	add	a0,a0,-1528 # 7310 <malloc+0x1a1e>
    3910:	00002097          	auipc	ra,0x2
    3914:	f2a080e7          	jalr	-214(ra) # 583a <printf>
    exit(1);
    3918:	4505                	li	a0,1
    391a:	00002097          	auipc	ra,0x2
    391e:	bb8080e7          	jalr	-1096(ra) # 54d2 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3922:	85ca                	mv	a1,s2
    3924:	00004517          	auipc	a0,0x4
    3928:	a1450513          	add	a0,a0,-1516 # 7338 <malloc+0x1a46>
    392c:	00002097          	auipc	ra,0x2
    3930:	f0e080e7          	jalr	-242(ra) # 583a <printf>
    exit(1);
    3934:	4505                	li	a0,1
    3936:	00002097          	auipc	ra,0x2
    393a:	b9c080e7          	jalr	-1124(ra) # 54d2 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    393e:	85ca                	mv	a1,s2
    3940:	00004517          	auipc	a0,0x4
    3944:	a2050513          	add	a0,a0,-1504 # 7360 <malloc+0x1a6e>
    3948:	00002097          	auipc	ra,0x2
    394c:	ef2080e7          	jalr	-270(ra) # 583a <printf>
    exit(1);
    3950:	4505                	li	a0,1
    3952:	00002097          	auipc	ra,0x2
    3956:	b80080e7          	jalr	-1152(ra) # 54d2 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    395a:	85ca                	mv	a1,s2
    395c:	00004517          	auipc	a0,0x4
    3960:	a2c50513          	add	a0,a0,-1492 # 7388 <malloc+0x1a96>
    3964:	00002097          	auipc	ra,0x2
    3968:	ed6080e7          	jalr	-298(ra) # 583a <printf>
    exit(1);
    396c:	4505                	li	a0,1
    396e:	00002097          	auipc	ra,0x2
    3972:	b64080e7          	jalr	-1180(ra) # 54d2 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3976:	85ca                	mv	a1,s2
    3978:	00004517          	auipc	a0,0x4
    397c:	a3050513          	add	a0,a0,-1488 # 73a8 <malloc+0x1ab6>
    3980:	00002097          	auipc	ra,0x2
    3984:	eba080e7          	jalr	-326(ra) # 583a <printf>
    exit(1);
    3988:	4505                	li	a0,1
    398a:	00002097          	auipc	ra,0x2
    398e:	b48080e7          	jalr	-1208(ra) # 54d2 <exit>
    printf("%s: write . succeeded!\n", s);
    3992:	85ca                	mv	a1,s2
    3994:	00004517          	auipc	a0,0x4
    3998:	a3c50513          	add	a0,a0,-1476 # 73d0 <malloc+0x1ade>
    399c:	00002097          	auipc	ra,0x2
    39a0:	e9e080e7          	jalr	-354(ra) # 583a <printf>
    exit(1);
    39a4:	4505                	li	a0,1
    39a6:	00002097          	auipc	ra,0x2
    39aa:	b2c080e7          	jalr	-1236(ra) # 54d2 <exit>

00000000000039ae <iref>:
{
    39ae:	7139                	add	sp,sp,-64
    39b0:	fc06                	sd	ra,56(sp)
    39b2:	f822                	sd	s0,48(sp)
    39b4:	f426                	sd	s1,40(sp)
    39b6:	f04a                	sd	s2,32(sp)
    39b8:	ec4e                	sd	s3,24(sp)
    39ba:	e852                	sd	s4,16(sp)
    39bc:	e456                	sd	s5,8(sp)
    39be:	e05a                	sd	s6,0(sp)
    39c0:	0080                	add	s0,sp,64
    39c2:	8b2a                	mv	s6,a0
    39c4:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    39c8:	00004a17          	auipc	s4,0x4
    39cc:	a20a0a13          	add	s4,s4,-1504 # 73e8 <malloc+0x1af6>
    mkdir("");
    39d0:	00003497          	auipc	s1,0x3
    39d4:	51848493          	add	s1,s1,1304 # 6ee8 <malloc+0x15f6>
    link("README", "");
    39d8:	00002a97          	auipc	s5,0x2
    39dc:	1e0a8a93          	add	s5,s5,480 # 5bb8 <malloc+0x2c6>
    fd = open("xx", O_CREATE);
    39e0:	00004997          	auipc	s3,0x4
    39e4:	90098993          	add	s3,s3,-1792 # 72e0 <malloc+0x19ee>
    39e8:	a891                	j	3a3c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    39ea:	85da                	mv	a1,s6
    39ec:	00004517          	auipc	a0,0x4
    39f0:	a0450513          	add	a0,a0,-1532 # 73f0 <malloc+0x1afe>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	e46080e7          	jalr	-442(ra) # 583a <printf>
      exit(1);
    39fc:	4505                	li	a0,1
    39fe:	00002097          	auipc	ra,0x2
    3a02:	ad4080e7          	jalr	-1324(ra) # 54d2 <exit>
      printf("%s: chdir irefd failed\n", s);
    3a06:	85da                	mv	a1,s6
    3a08:	00004517          	auipc	a0,0x4
    3a0c:	a0050513          	add	a0,a0,-1536 # 7408 <malloc+0x1b16>
    3a10:	00002097          	auipc	ra,0x2
    3a14:	e2a080e7          	jalr	-470(ra) # 583a <printf>
      exit(1);
    3a18:	4505                	li	a0,1
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	ab8080e7          	jalr	-1352(ra) # 54d2 <exit>
      close(fd);
    3a22:	00002097          	auipc	ra,0x2
    3a26:	ad8080e7          	jalr	-1320(ra) # 54fa <close>
    3a2a:	a889                	j	3a7c <iref+0xce>
    unlink("xx");
    3a2c:	854e                	mv	a0,s3
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	af4080e7          	jalr	-1292(ra) # 5522 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3a36:	397d                	addw	s2,s2,-1
    3a38:	06090063          	beqz	s2,3a98 <iref+0xea>
    if(mkdir("irefd") != 0){
    3a3c:	8552                	mv	a0,s4
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	afc080e7          	jalr	-1284(ra) # 553a <mkdir>
    3a46:	f155                	bnez	a0,39ea <iref+0x3c>
    if(chdir("irefd") != 0){
    3a48:	8552                	mv	a0,s4
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	af8080e7          	jalr	-1288(ra) # 5542 <chdir>
    3a52:	f955                	bnez	a0,3a06 <iref+0x58>
    mkdir("");
    3a54:	8526                	mv	a0,s1
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	ae4080e7          	jalr	-1308(ra) # 553a <mkdir>
    link("README", "");
    3a5e:	85a6                	mv	a1,s1
    3a60:	8556                	mv	a0,s5
    3a62:	00002097          	auipc	ra,0x2
    3a66:	ad0080e7          	jalr	-1328(ra) # 5532 <link>
    fd = open("", O_CREATE);
    3a6a:	20000593          	li	a1,512
    3a6e:	8526                	mv	a0,s1
    3a70:	00002097          	auipc	ra,0x2
    3a74:	aa2080e7          	jalr	-1374(ra) # 5512 <open>
    if(fd >= 0)
    3a78:	fa0555e3          	bgez	a0,3a22 <iref+0x74>
    fd = open("xx", O_CREATE);
    3a7c:	20000593          	li	a1,512
    3a80:	854e                	mv	a0,s3
    3a82:	00002097          	auipc	ra,0x2
    3a86:	a90080e7          	jalr	-1392(ra) # 5512 <open>
    if(fd >= 0)
    3a8a:	fa0541e3          	bltz	a0,3a2c <iref+0x7e>
      close(fd);
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	a6c080e7          	jalr	-1428(ra) # 54fa <close>
    3a96:	bf59                	j	3a2c <iref+0x7e>
    3a98:	03300493          	li	s1,51
    chdir("..");
    3a9c:	00003997          	auipc	s3,0x3
    3aa0:	76498993          	add	s3,s3,1892 # 7200 <malloc+0x190e>
    unlink("irefd");
    3aa4:	00004917          	auipc	s2,0x4
    3aa8:	94490913          	add	s2,s2,-1724 # 73e8 <malloc+0x1af6>
    chdir("..");
    3aac:	854e                	mv	a0,s3
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	a94080e7          	jalr	-1388(ra) # 5542 <chdir>
    unlink("irefd");
    3ab6:	854a                	mv	a0,s2
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	a6a080e7          	jalr	-1430(ra) # 5522 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ac0:	34fd                	addw	s1,s1,-1
    3ac2:	f4ed                	bnez	s1,3aac <iref+0xfe>
  chdir("/");
    3ac4:	00003517          	auipc	a0,0x3
    3ac8:	14450513          	add	a0,a0,324 # 6c08 <malloc+0x1316>
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	a76080e7          	jalr	-1418(ra) # 5542 <chdir>
}
    3ad4:	70e2                	ld	ra,56(sp)
    3ad6:	7442                	ld	s0,48(sp)
    3ad8:	74a2                	ld	s1,40(sp)
    3ada:	7902                	ld	s2,32(sp)
    3adc:	69e2                	ld	s3,24(sp)
    3ade:	6a42                	ld	s4,16(sp)
    3ae0:	6aa2                	ld	s5,8(sp)
    3ae2:	6b02                	ld	s6,0(sp)
    3ae4:	6121                	add	sp,sp,64
    3ae6:	8082                	ret

0000000000003ae8 <openiputtest>:
{
    3ae8:	7179                	add	sp,sp,-48
    3aea:	f406                	sd	ra,40(sp)
    3aec:	f022                	sd	s0,32(sp)
    3aee:	ec26                	sd	s1,24(sp)
    3af0:	1800                	add	s0,sp,48
    3af2:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3af4:	00004517          	auipc	a0,0x4
    3af8:	92c50513          	add	a0,a0,-1748 # 7420 <malloc+0x1b2e>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	a3e080e7          	jalr	-1474(ra) # 553a <mkdir>
    3b04:	04054263          	bltz	a0,3b48 <openiputtest+0x60>
  pid = fork();
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	9c2080e7          	jalr	-1598(ra) # 54ca <fork>
  if(pid < 0){
    3b10:	04054a63          	bltz	a0,3b64 <openiputtest+0x7c>
  if(pid == 0){
    3b14:	e93d                	bnez	a0,3b8a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3b16:	4589                	li	a1,2
    3b18:	00004517          	auipc	a0,0x4
    3b1c:	90850513          	add	a0,a0,-1784 # 7420 <malloc+0x1b2e>
    3b20:	00002097          	auipc	ra,0x2
    3b24:	9f2080e7          	jalr	-1550(ra) # 5512 <open>
    if(fd >= 0){
    3b28:	04054c63          	bltz	a0,3b80 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3b2c:	85a6                	mv	a1,s1
    3b2e:	00004517          	auipc	a0,0x4
    3b32:	91250513          	add	a0,a0,-1774 # 7440 <malloc+0x1b4e>
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	d04080e7          	jalr	-764(ra) # 583a <printf>
      exit(1);
    3b3e:	4505                	li	a0,1
    3b40:	00002097          	auipc	ra,0x2
    3b44:	992080e7          	jalr	-1646(ra) # 54d2 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3b48:	85a6                	mv	a1,s1
    3b4a:	00004517          	auipc	a0,0x4
    3b4e:	8de50513          	add	a0,a0,-1826 # 7428 <malloc+0x1b36>
    3b52:	00002097          	auipc	ra,0x2
    3b56:	ce8080e7          	jalr	-792(ra) # 583a <printf>
    exit(1);
    3b5a:	4505                	li	a0,1
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	976080e7          	jalr	-1674(ra) # 54d2 <exit>
    printf("%s: fork failed\n", s);
    3b64:	85a6                	mv	a1,s1
    3b66:	00002517          	auipc	a0,0x2
    3b6a:	70250513          	add	a0,a0,1794 # 6268 <malloc+0x976>
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	ccc080e7          	jalr	-820(ra) # 583a <printf>
    exit(1);
    3b76:	4505                	li	a0,1
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	95a080e7          	jalr	-1702(ra) # 54d2 <exit>
    exit(0);
    3b80:	4501                	li	a0,0
    3b82:	00002097          	auipc	ra,0x2
    3b86:	950080e7          	jalr	-1712(ra) # 54d2 <exit>
  sleep(1);
    3b8a:	4505                	li	a0,1
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	9d6080e7          	jalr	-1578(ra) # 5562 <sleep>
  if(unlink("oidir") != 0){
    3b94:	00004517          	auipc	a0,0x4
    3b98:	88c50513          	add	a0,a0,-1908 # 7420 <malloc+0x1b2e>
    3b9c:	00002097          	auipc	ra,0x2
    3ba0:	986080e7          	jalr	-1658(ra) # 5522 <unlink>
    3ba4:	cd19                	beqz	a0,3bc2 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3ba6:	85a6                	mv	a1,s1
    3ba8:	00003517          	auipc	a0,0x3
    3bac:	8b050513          	add	a0,a0,-1872 # 6458 <malloc+0xb66>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	c8a080e7          	jalr	-886(ra) # 583a <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	918080e7          	jalr	-1768(ra) # 54d2 <exit>
  wait(&xstatus);
    3bc2:	fdc40513          	add	a0,s0,-36
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	914080e7          	jalr	-1772(ra) # 54da <wait>
  exit(xstatus);
    3bce:	fdc42503          	lw	a0,-36(s0)
    3bd2:	00002097          	auipc	ra,0x2
    3bd6:	900080e7          	jalr	-1792(ra) # 54d2 <exit>

0000000000003bda <forkforkfork>:
{
    3bda:	1101                	add	sp,sp,-32
    3bdc:	ec06                	sd	ra,24(sp)
    3bde:	e822                	sd	s0,16(sp)
    3be0:	e426                	sd	s1,8(sp)
    3be2:	1000                	add	s0,sp,32
    3be4:	84aa                	mv	s1,a0
  unlink("stopforking");
    3be6:	00004517          	auipc	a0,0x4
    3bea:	88250513          	add	a0,a0,-1918 # 7468 <malloc+0x1b76>
    3bee:	00002097          	auipc	ra,0x2
    3bf2:	934080e7          	jalr	-1740(ra) # 5522 <unlink>
  int pid = fork();
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	8d4080e7          	jalr	-1836(ra) # 54ca <fork>
  if(pid < 0){
    3bfe:	04054563          	bltz	a0,3c48 <forkforkfork+0x6e>
  if(pid == 0){
    3c02:	c12d                	beqz	a0,3c64 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3c04:	4551                	li	a0,20
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	95c080e7          	jalr	-1700(ra) # 5562 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3c0e:	20200593          	li	a1,514
    3c12:	00004517          	auipc	a0,0x4
    3c16:	85650513          	add	a0,a0,-1962 # 7468 <malloc+0x1b76>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	8f8080e7          	jalr	-1800(ra) # 5512 <open>
    3c22:	00002097          	auipc	ra,0x2
    3c26:	8d8080e7          	jalr	-1832(ra) # 54fa <close>
  wait(0);
    3c2a:	4501                	li	a0,0
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	8ae080e7          	jalr	-1874(ra) # 54da <wait>
  sleep(10); // one second
    3c34:	4529                	li	a0,10
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	92c080e7          	jalr	-1748(ra) # 5562 <sleep>
}
    3c3e:	60e2                	ld	ra,24(sp)
    3c40:	6442                	ld	s0,16(sp)
    3c42:	64a2                	ld	s1,8(sp)
    3c44:	6105                	add	sp,sp,32
    3c46:	8082                	ret
    printf("%s: fork failed", s);
    3c48:	85a6                	mv	a1,s1
    3c4a:	00002517          	auipc	a0,0x2
    3c4e:	7de50513          	add	a0,a0,2014 # 6428 <malloc+0xb36>
    3c52:	00002097          	auipc	ra,0x2
    3c56:	be8080e7          	jalr	-1048(ra) # 583a <printf>
    exit(1);
    3c5a:	4505                	li	a0,1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	876080e7          	jalr	-1930(ra) # 54d2 <exit>
      int fd = open("stopforking", 0);
    3c64:	00004497          	auipc	s1,0x4
    3c68:	80448493          	add	s1,s1,-2044 # 7468 <malloc+0x1b76>
    3c6c:	4581                	li	a1,0
    3c6e:	8526                	mv	a0,s1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	8a2080e7          	jalr	-1886(ra) # 5512 <open>
      if(fd >= 0){
    3c78:	02055763          	bgez	a0,3ca6 <forkforkfork+0xcc>
      if(fork() < 0){
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	84e080e7          	jalr	-1970(ra) # 54ca <fork>
    3c84:	fe0554e3          	bgez	a0,3c6c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3c88:	20200593          	li	a1,514
    3c8c:	00003517          	auipc	a0,0x3
    3c90:	7dc50513          	add	a0,a0,2012 # 7468 <malloc+0x1b76>
    3c94:	00002097          	auipc	ra,0x2
    3c98:	87e080e7          	jalr	-1922(ra) # 5512 <open>
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	85e080e7          	jalr	-1954(ra) # 54fa <close>
    3ca4:	b7e1                	j	3c6c <forkforkfork+0x92>
        exit(0);
    3ca6:	4501                	li	a0,0
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	82a080e7          	jalr	-2006(ra) # 54d2 <exit>

0000000000003cb0 <preempt>:
{
    3cb0:	7139                	add	sp,sp,-64
    3cb2:	fc06                	sd	ra,56(sp)
    3cb4:	f822                	sd	s0,48(sp)
    3cb6:	f426                	sd	s1,40(sp)
    3cb8:	f04a                	sd	s2,32(sp)
    3cba:	ec4e                	sd	s3,24(sp)
    3cbc:	e852                	sd	s4,16(sp)
    3cbe:	0080                	add	s0,sp,64
    3cc0:	892a                	mv	s2,a0
  pid1 = fork();
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	808080e7          	jalr	-2040(ra) # 54ca <fork>
  if(pid1 < 0) {
    3cca:	00054563          	bltz	a0,3cd4 <preempt+0x24>
    3cce:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3cd0:	ed19                	bnez	a0,3cee <preempt+0x3e>
    for(;;)
    3cd2:	a001                	j	3cd2 <preempt+0x22>
    printf("%s: fork failed");
    3cd4:	00002517          	auipc	a0,0x2
    3cd8:	75450513          	add	a0,a0,1876 # 6428 <malloc+0xb36>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	b5e080e7          	jalr	-1186(ra) # 583a <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00001097          	auipc	ra,0x1
    3cea:	7ec080e7          	jalr	2028(ra) # 54d2 <exit>
  pid2 = fork();
    3cee:	00001097          	auipc	ra,0x1
    3cf2:	7dc080e7          	jalr	2012(ra) # 54ca <fork>
    3cf6:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3cf8:	00054463          	bltz	a0,3d00 <preempt+0x50>
  if(pid2 == 0)
    3cfc:	e105                	bnez	a0,3d1c <preempt+0x6c>
    for(;;)
    3cfe:	a001                	j	3cfe <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3d00:	85ca                	mv	a1,s2
    3d02:	00002517          	auipc	a0,0x2
    3d06:	56650513          	add	a0,a0,1382 # 6268 <malloc+0x976>
    3d0a:	00002097          	auipc	ra,0x2
    3d0e:	b30080e7          	jalr	-1232(ra) # 583a <printf>
    exit(1);
    3d12:	4505                	li	a0,1
    3d14:	00001097          	auipc	ra,0x1
    3d18:	7be080e7          	jalr	1982(ra) # 54d2 <exit>
  pipe(pfds);
    3d1c:	fc840513          	add	a0,s0,-56
    3d20:	00001097          	auipc	ra,0x1
    3d24:	7c2080e7          	jalr	1986(ra) # 54e2 <pipe>
  pid3 = fork();
    3d28:	00001097          	auipc	ra,0x1
    3d2c:	7a2080e7          	jalr	1954(ra) # 54ca <fork>
    3d30:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3d32:	02054e63          	bltz	a0,3d6e <preempt+0xbe>
  if(pid3 == 0){
    3d36:	e13d                	bnez	a0,3d9c <preempt+0xec>
    close(pfds[0]);
    3d38:	fc842503          	lw	a0,-56(s0)
    3d3c:	00001097          	auipc	ra,0x1
    3d40:	7be080e7          	jalr	1982(ra) # 54fa <close>
    if(write(pfds[1], "x", 1) != 1)
    3d44:	4605                	li	a2,1
    3d46:	00002597          	auipc	a1,0x2
    3d4a:	d3a58593          	add	a1,a1,-710 # 5a80 <malloc+0x18e>
    3d4e:	fcc42503          	lw	a0,-52(s0)
    3d52:	00001097          	auipc	ra,0x1
    3d56:	7a0080e7          	jalr	1952(ra) # 54f2 <write>
    3d5a:	4785                	li	a5,1
    3d5c:	02f51763          	bne	a0,a5,3d8a <preempt+0xda>
    close(pfds[1]);
    3d60:	fcc42503          	lw	a0,-52(s0)
    3d64:	00001097          	auipc	ra,0x1
    3d68:	796080e7          	jalr	1942(ra) # 54fa <close>
    for(;;)
    3d6c:	a001                	j	3d6c <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3d6e:	85ca                	mv	a1,s2
    3d70:	00002517          	auipc	a0,0x2
    3d74:	4f850513          	add	a0,a0,1272 # 6268 <malloc+0x976>
    3d78:	00002097          	auipc	ra,0x2
    3d7c:	ac2080e7          	jalr	-1342(ra) # 583a <printf>
     exit(1);
    3d80:	4505                	li	a0,1
    3d82:	00001097          	auipc	ra,0x1
    3d86:	750080e7          	jalr	1872(ra) # 54d2 <exit>
      printf("%s: preempt write error");
    3d8a:	00003517          	auipc	a0,0x3
    3d8e:	6ee50513          	add	a0,a0,1774 # 7478 <malloc+0x1b86>
    3d92:	00002097          	auipc	ra,0x2
    3d96:	aa8080e7          	jalr	-1368(ra) # 583a <printf>
    3d9a:	b7d9                	j	3d60 <preempt+0xb0>
  close(pfds[1]);
    3d9c:	fcc42503          	lw	a0,-52(s0)
    3da0:	00001097          	auipc	ra,0x1
    3da4:	75a080e7          	jalr	1882(ra) # 54fa <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3da8:	660d                	lui	a2,0x3
    3daa:	00008597          	auipc	a1,0x8
    3dae:	be658593          	add	a1,a1,-1050 # b990 <buf>
    3db2:	fc842503          	lw	a0,-56(s0)
    3db6:	00001097          	auipc	ra,0x1
    3dba:	734080e7          	jalr	1844(ra) # 54ea <read>
    3dbe:	4785                	li	a5,1
    3dc0:	02f50263          	beq	a0,a5,3de4 <preempt+0x134>
    printf("%s: preempt read error");
    3dc4:	00003517          	auipc	a0,0x3
    3dc8:	6cc50513          	add	a0,a0,1740 # 7490 <malloc+0x1b9e>
    3dcc:	00002097          	auipc	ra,0x2
    3dd0:	a6e080e7          	jalr	-1426(ra) # 583a <printf>
}
    3dd4:	70e2                	ld	ra,56(sp)
    3dd6:	7442                	ld	s0,48(sp)
    3dd8:	74a2                	ld	s1,40(sp)
    3dda:	7902                	ld	s2,32(sp)
    3ddc:	69e2                	ld	s3,24(sp)
    3dde:	6a42                	ld	s4,16(sp)
    3de0:	6121                	add	sp,sp,64
    3de2:	8082                	ret
  close(pfds[0]);
    3de4:	fc842503          	lw	a0,-56(s0)
    3de8:	00001097          	auipc	ra,0x1
    3dec:	712080e7          	jalr	1810(ra) # 54fa <close>
  printf("kill... ");
    3df0:	00003517          	auipc	a0,0x3
    3df4:	6b850513          	add	a0,a0,1720 # 74a8 <malloc+0x1bb6>
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	a42080e7          	jalr	-1470(ra) # 583a <printf>
  kill(pid1);
    3e00:	8526                	mv	a0,s1
    3e02:	00001097          	auipc	ra,0x1
    3e06:	700080e7          	jalr	1792(ra) # 5502 <kill>
  kill(pid2);
    3e0a:	854e                	mv	a0,s3
    3e0c:	00001097          	auipc	ra,0x1
    3e10:	6f6080e7          	jalr	1782(ra) # 5502 <kill>
  kill(pid3);
    3e14:	8552                	mv	a0,s4
    3e16:	00001097          	auipc	ra,0x1
    3e1a:	6ec080e7          	jalr	1772(ra) # 5502 <kill>
  printf("wait... ");
    3e1e:	00003517          	auipc	a0,0x3
    3e22:	69a50513          	add	a0,a0,1690 # 74b8 <malloc+0x1bc6>
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	a14080e7          	jalr	-1516(ra) # 583a <printf>
  wait(0);
    3e2e:	4501                	li	a0,0
    3e30:	00001097          	auipc	ra,0x1
    3e34:	6aa080e7          	jalr	1706(ra) # 54da <wait>
  wait(0);
    3e38:	4501                	li	a0,0
    3e3a:	00001097          	auipc	ra,0x1
    3e3e:	6a0080e7          	jalr	1696(ra) # 54da <wait>
  wait(0);
    3e42:	4501                	li	a0,0
    3e44:	00001097          	auipc	ra,0x1
    3e48:	696080e7          	jalr	1686(ra) # 54da <wait>
    3e4c:	b761                	j	3dd4 <preempt+0x124>

0000000000003e4e <sbrkfail>:
{
    3e4e:	7119                	add	sp,sp,-128
    3e50:	fc86                	sd	ra,120(sp)
    3e52:	f8a2                	sd	s0,112(sp)
    3e54:	f4a6                	sd	s1,104(sp)
    3e56:	f0ca                	sd	s2,96(sp)
    3e58:	ecce                	sd	s3,88(sp)
    3e5a:	e8d2                	sd	s4,80(sp)
    3e5c:	e4d6                	sd	s5,72(sp)
    3e5e:	0100                	add	s0,sp,128
    3e60:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3e62:	fb040513          	add	a0,s0,-80
    3e66:	00001097          	auipc	ra,0x1
    3e6a:	67c080e7          	jalr	1660(ra) # 54e2 <pipe>
    3e6e:	e901                	bnez	a0,3e7e <sbrkfail+0x30>
    3e70:	f8040493          	add	s1,s0,-128
    3e74:	fa840993          	add	s3,s0,-88
    3e78:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3e7a:	5a7d                	li	s4,-1
    3e7c:	a085                	j	3edc <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3e7e:	85d6                	mv	a1,s5
    3e80:	00002517          	auipc	a0,0x2
    3e84:	4f050513          	add	a0,a0,1264 # 6370 <malloc+0xa7e>
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	9b2080e7          	jalr	-1614(ra) # 583a <printf>
    exit(1);
    3e90:	4505                	li	a0,1
    3e92:	00001097          	auipc	ra,0x1
    3e96:	640080e7          	jalr	1600(ra) # 54d2 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3e9a:	00001097          	auipc	ra,0x1
    3e9e:	6c0080e7          	jalr	1728(ra) # 555a <sbrk>
    3ea2:	064007b7          	lui	a5,0x6400
    3ea6:	40a7853b          	subw	a0,a5,a0
    3eaa:	00001097          	auipc	ra,0x1
    3eae:	6b0080e7          	jalr	1712(ra) # 555a <sbrk>
      write(fds[1], "x", 1);
    3eb2:	4605                	li	a2,1
    3eb4:	00002597          	auipc	a1,0x2
    3eb8:	bcc58593          	add	a1,a1,-1076 # 5a80 <malloc+0x18e>
    3ebc:	fb442503          	lw	a0,-76(s0)
    3ec0:	00001097          	auipc	ra,0x1
    3ec4:	632080e7          	jalr	1586(ra) # 54f2 <write>
      for(;;) sleep(1000);
    3ec8:	3e800513          	li	a0,1000
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	696080e7          	jalr	1686(ra) # 5562 <sleep>
    3ed4:	bfd5                	j	3ec8 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3ed6:	0911                	add	s2,s2,4
    3ed8:	03390563          	beq	s2,s3,3f02 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3edc:	00001097          	auipc	ra,0x1
    3ee0:	5ee080e7          	jalr	1518(ra) # 54ca <fork>
    3ee4:	00a92023          	sw	a0,0(s2)
    3ee8:	d94d                	beqz	a0,3e9a <sbrkfail+0x4c>
    if(pids[i] != -1)
    3eea:	ff4506e3          	beq	a0,s4,3ed6 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3eee:	4605                	li	a2,1
    3ef0:	faf40593          	add	a1,s0,-81
    3ef4:	fb042503          	lw	a0,-80(s0)
    3ef8:	00001097          	auipc	ra,0x1
    3efc:	5f2080e7          	jalr	1522(ra) # 54ea <read>
    3f00:	bfd9                	j	3ed6 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3f02:	6505                	lui	a0,0x1
    3f04:	00001097          	auipc	ra,0x1
    3f08:	656080e7          	jalr	1622(ra) # 555a <sbrk>
    3f0c:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3f0e:	597d                	li	s2,-1
    3f10:	a021                	j	3f18 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3f12:	0491                	add	s1,s1,4
    3f14:	01348f63          	beq	s1,s3,3f32 <sbrkfail+0xe4>
    if(pids[i] == -1)
    3f18:	4088                	lw	a0,0(s1)
    3f1a:	ff250ce3          	beq	a0,s2,3f12 <sbrkfail+0xc4>
    kill(pids[i]);
    3f1e:	00001097          	auipc	ra,0x1
    3f22:	5e4080e7          	jalr	1508(ra) # 5502 <kill>
    wait(0);
    3f26:	4501                	li	a0,0
    3f28:	00001097          	auipc	ra,0x1
    3f2c:	5b2080e7          	jalr	1458(ra) # 54da <wait>
    3f30:	b7cd                	j	3f12 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    3f32:	57fd                	li	a5,-1
    3f34:	04fa0163          	beq	s4,a5,3f76 <sbrkfail+0x128>
  pid = fork();
    3f38:	00001097          	auipc	ra,0x1
    3f3c:	592080e7          	jalr	1426(ra) # 54ca <fork>
    3f40:	84aa                	mv	s1,a0
  if(pid < 0){
    3f42:	04054863          	bltz	a0,3f92 <sbrkfail+0x144>
  if(pid == 0){
    3f46:	c525                	beqz	a0,3fae <sbrkfail+0x160>
  wait(&xstatus);
    3f48:	fbc40513          	add	a0,s0,-68
    3f4c:	00001097          	auipc	ra,0x1
    3f50:	58e080e7          	jalr	1422(ra) # 54da <wait>
  if(xstatus != -1 && xstatus != 2)
    3f54:	fbc42783          	lw	a5,-68(s0)
    3f58:	577d                	li	a4,-1
    3f5a:	00e78563          	beq	a5,a4,3f64 <sbrkfail+0x116>
    3f5e:	4709                	li	a4,2
    3f60:	08e79c63          	bne	a5,a4,3ff8 <sbrkfail+0x1aa>
}
    3f64:	70e6                	ld	ra,120(sp)
    3f66:	7446                	ld	s0,112(sp)
    3f68:	74a6                	ld	s1,104(sp)
    3f6a:	7906                	ld	s2,96(sp)
    3f6c:	69e6                	ld	s3,88(sp)
    3f6e:	6a46                	ld	s4,80(sp)
    3f70:	6aa6                	ld	s5,72(sp)
    3f72:	6109                	add	sp,sp,128
    3f74:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3f76:	85d6                	mv	a1,s5
    3f78:	00003517          	auipc	a0,0x3
    3f7c:	55050513          	add	a0,a0,1360 # 74c8 <malloc+0x1bd6>
    3f80:	00002097          	auipc	ra,0x2
    3f84:	8ba080e7          	jalr	-1862(ra) # 583a <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	00001097          	auipc	ra,0x1
    3f8e:	548080e7          	jalr	1352(ra) # 54d2 <exit>
    printf("%s: fork failed\n", s);
    3f92:	85d6                	mv	a1,s5
    3f94:	00002517          	auipc	a0,0x2
    3f98:	2d450513          	add	a0,a0,724 # 6268 <malloc+0x976>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	89e080e7          	jalr	-1890(ra) # 583a <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00001097          	auipc	ra,0x1
    3faa:	52c080e7          	jalr	1324(ra) # 54d2 <exit>
    a = sbrk(0);
    3fae:	4501                	li	a0,0
    3fb0:	00001097          	auipc	ra,0x1
    3fb4:	5aa080e7          	jalr	1450(ra) # 555a <sbrk>
    3fb8:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3fba:	3e800537          	lui	a0,0x3e800
    3fbe:	00001097          	auipc	ra,0x1
    3fc2:	59c080e7          	jalr	1436(ra) # 555a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3fc6:	87ca                	mv	a5,s2
    3fc8:	3e800737          	lui	a4,0x3e800
    3fcc:	993a                	add	s2,s2,a4
    3fce:	6705                	lui	a4,0x1
      n += *(a+i);
    3fd0:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1660>
    3fd4:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3fd6:	97ba                	add	a5,a5,a4
    3fd8:	ff279ce3          	bne	a5,s2,3fd0 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3fdc:	85a6                	mv	a1,s1
    3fde:	00003517          	auipc	a0,0x3
    3fe2:	50a50513          	add	a0,a0,1290 # 74e8 <malloc+0x1bf6>
    3fe6:	00002097          	auipc	ra,0x2
    3fea:	854080e7          	jalr	-1964(ra) # 583a <printf>
    exit(1);
    3fee:	4505                	li	a0,1
    3ff0:	00001097          	auipc	ra,0x1
    3ff4:	4e2080e7          	jalr	1250(ra) # 54d2 <exit>
    exit(1);
    3ff8:	4505                	li	a0,1
    3ffa:	00001097          	auipc	ra,0x1
    3ffe:	4d8080e7          	jalr	1240(ra) # 54d2 <exit>

0000000000004002 <reparent>:
{
    4002:	7179                	add	sp,sp,-48
    4004:	f406                	sd	ra,40(sp)
    4006:	f022                	sd	s0,32(sp)
    4008:	ec26                	sd	s1,24(sp)
    400a:	e84a                	sd	s2,16(sp)
    400c:	e44e                	sd	s3,8(sp)
    400e:	e052                	sd	s4,0(sp)
    4010:	1800                	add	s0,sp,48
    4012:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4014:	00001097          	auipc	ra,0x1
    4018:	53e080e7          	jalr	1342(ra) # 5552 <getpid>
    401c:	8a2a                	mv	s4,a0
    401e:	0c800913          	li	s2,200
    int pid = fork();
    4022:	00001097          	auipc	ra,0x1
    4026:	4a8080e7          	jalr	1192(ra) # 54ca <fork>
    402a:	84aa                	mv	s1,a0
    if(pid < 0){
    402c:	02054263          	bltz	a0,4050 <reparent+0x4e>
    if(pid){
    4030:	cd21                	beqz	a0,4088 <reparent+0x86>
      if(wait(0) != pid){
    4032:	4501                	li	a0,0
    4034:	00001097          	auipc	ra,0x1
    4038:	4a6080e7          	jalr	1190(ra) # 54da <wait>
    403c:	02951863          	bne	a0,s1,406c <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4040:	397d                	addw	s2,s2,-1
    4042:	fe0910e3          	bnez	s2,4022 <reparent+0x20>
  exit(0);
    4046:	4501                	li	a0,0
    4048:	00001097          	auipc	ra,0x1
    404c:	48a080e7          	jalr	1162(ra) # 54d2 <exit>
      printf("%s: fork failed\n", s);
    4050:	85ce                	mv	a1,s3
    4052:	00002517          	auipc	a0,0x2
    4056:	21650513          	add	a0,a0,534 # 6268 <malloc+0x976>
    405a:	00001097          	auipc	ra,0x1
    405e:	7e0080e7          	jalr	2016(ra) # 583a <printf>
      exit(1);
    4062:	4505                	li	a0,1
    4064:	00001097          	auipc	ra,0x1
    4068:	46e080e7          	jalr	1134(ra) # 54d2 <exit>
        printf("%s: wait wrong pid\n", s);
    406c:	85ce                	mv	a1,s3
    406e:	00002517          	auipc	a0,0x2
    4072:	38250513          	add	a0,a0,898 # 63f0 <malloc+0xafe>
    4076:	00001097          	auipc	ra,0x1
    407a:	7c4080e7          	jalr	1988(ra) # 583a <printf>
        exit(1);
    407e:	4505                	li	a0,1
    4080:	00001097          	auipc	ra,0x1
    4084:	452080e7          	jalr	1106(ra) # 54d2 <exit>
      int pid2 = fork();
    4088:	00001097          	auipc	ra,0x1
    408c:	442080e7          	jalr	1090(ra) # 54ca <fork>
      if(pid2 < 0){
    4090:	00054763          	bltz	a0,409e <reparent+0x9c>
      exit(0);
    4094:	4501                	li	a0,0
    4096:	00001097          	auipc	ra,0x1
    409a:	43c080e7          	jalr	1084(ra) # 54d2 <exit>
        kill(master_pid);
    409e:	8552                	mv	a0,s4
    40a0:	00001097          	auipc	ra,0x1
    40a4:	462080e7          	jalr	1122(ra) # 5502 <kill>
        exit(1);
    40a8:	4505                	li	a0,1
    40aa:	00001097          	auipc	ra,0x1
    40ae:	428080e7          	jalr	1064(ra) # 54d2 <exit>

00000000000040b2 <mem>:
{
    40b2:	7139                	add	sp,sp,-64
    40b4:	fc06                	sd	ra,56(sp)
    40b6:	f822                	sd	s0,48(sp)
    40b8:	f426                	sd	s1,40(sp)
    40ba:	f04a                	sd	s2,32(sp)
    40bc:	ec4e                	sd	s3,24(sp)
    40be:	0080                	add	s0,sp,64
    40c0:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    40c2:	00001097          	auipc	ra,0x1
    40c6:	408080e7          	jalr	1032(ra) # 54ca <fork>
    m1 = 0;
    40ca:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    40cc:	6909                	lui	s2,0x2
    40ce:	71190913          	add	s2,s2,1809 # 2711 <sbrkmuch+0x121>
  if((pid = fork()) == 0){
    40d2:	c115                	beqz	a0,40f6 <mem+0x44>
    wait(&xstatus);
    40d4:	fcc40513          	add	a0,s0,-52
    40d8:	00001097          	auipc	ra,0x1
    40dc:	402080e7          	jalr	1026(ra) # 54da <wait>
    if(xstatus == -1){
    40e0:	fcc42503          	lw	a0,-52(s0)
    40e4:	57fd                	li	a5,-1
    40e6:	06f50363          	beq	a0,a5,414c <mem+0x9a>
    exit(xstatus);
    40ea:	00001097          	auipc	ra,0x1
    40ee:	3e8080e7          	jalr	1000(ra) # 54d2 <exit>
      *(char**)m2 = m1;
    40f2:	e104                	sd	s1,0(a0)
      m1 = m2;
    40f4:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    40f6:	854a                	mv	a0,s2
    40f8:	00001097          	auipc	ra,0x1
    40fc:	7fa080e7          	jalr	2042(ra) # 58f2 <malloc>
    4100:	f96d                	bnez	a0,40f2 <mem+0x40>
    while(m1){
    4102:	c881                	beqz	s1,4112 <mem+0x60>
      m2 = *(char**)m1;
    4104:	8526                	mv	a0,s1
    4106:	6084                	ld	s1,0(s1)
      free(m1);
    4108:	00001097          	auipc	ra,0x1
    410c:	768080e7          	jalr	1896(ra) # 5870 <free>
    while(m1){
    4110:	f8f5                	bnez	s1,4104 <mem+0x52>
    m1 = malloc(1024*20);
    4112:	6515                	lui	a0,0x5
    4114:	00001097          	auipc	ra,0x1
    4118:	7de080e7          	jalr	2014(ra) # 58f2 <malloc>
    if(m1 == 0){
    411c:	c911                	beqz	a0,4130 <mem+0x7e>
    free(m1);
    411e:	00001097          	auipc	ra,0x1
    4122:	752080e7          	jalr	1874(ra) # 5870 <free>
    exit(0);
    4126:	4501                	li	a0,0
    4128:	00001097          	auipc	ra,0x1
    412c:	3aa080e7          	jalr	938(ra) # 54d2 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4130:	85ce                	mv	a1,s3
    4132:	00003517          	auipc	a0,0x3
    4136:	3e650513          	add	a0,a0,998 # 7518 <malloc+0x1c26>
    413a:	00001097          	auipc	ra,0x1
    413e:	700080e7          	jalr	1792(ra) # 583a <printf>
      exit(1);
    4142:	4505                	li	a0,1
    4144:	00001097          	auipc	ra,0x1
    4148:	38e080e7          	jalr	910(ra) # 54d2 <exit>
      exit(0);
    414c:	4501                	li	a0,0
    414e:	00001097          	auipc	ra,0x1
    4152:	384080e7          	jalr	900(ra) # 54d2 <exit>

0000000000004156 <sharedfd>:
{
    4156:	7159                	add	sp,sp,-112
    4158:	f486                	sd	ra,104(sp)
    415a:	f0a2                	sd	s0,96(sp)
    415c:	eca6                	sd	s1,88(sp)
    415e:	e8ca                	sd	s2,80(sp)
    4160:	e4ce                	sd	s3,72(sp)
    4162:	e0d2                	sd	s4,64(sp)
    4164:	fc56                	sd	s5,56(sp)
    4166:	f85a                	sd	s6,48(sp)
    4168:	f45e                	sd	s7,40(sp)
    416a:	1880                	add	s0,sp,112
    416c:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    416e:	00003517          	auipc	a0,0x3
    4172:	3ca50513          	add	a0,a0,970 # 7538 <malloc+0x1c46>
    4176:	00001097          	auipc	ra,0x1
    417a:	3ac080e7          	jalr	940(ra) # 5522 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    417e:	20200593          	li	a1,514
    4182:	00003517          	auipc	a0,0x3
    4186:	3b650513          	add	a0,a0,950 # 7538 <malloc+0x1c46>
    418a:	00001097          	auipc	ra,0x1
    418e:	388080e7          	jalr	904(ra) # 5512 <open>
  if(fd < 0){
    4192:	04054a63          	bltz	a0,41e6 <sharedfd+0x90>
    4196:	892a                	mv	s2,a0
  pid = fork();
    4198:	00001097          	auipc	ra,0x1
    419c:	332080e7          	jalr	818(ra) # 54ca <fork>
    41a0:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    41a2:	07000593          	li	a1,112
    41a6:	e119                	bnez	a0,41ac <sharedfd+0x56>
    41a8:	06300593          	li	a1,99
    41ac:	4629                	li	a2,10
    41ae:	fa040513          	add	a0,s0,-96
    41b2:	00001097          	auipc	ra,0x1
    41b6:	126080e7          	jalr	294(ra) # 52d8 <memset>
    41ba:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    41be:	4629                	li	a2,10
    41c0:	fa040593          	add	a1,s0,-96
    41c4:	854a                	mv	a0,s2
    41c6:	00001097          	auipc	ra,0x1
    41ca:	32c080e7          	jalr	812(ra) # 54f2 <write>
    41ce:	47a9                	li	a5,10
    41d0:	02f51963          	bne	a0,a5,4202 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    41d4:	34fd                	addw	s1,s1,-1
    41d6:	f4e5                	bnez	s1,41be <sharedfd+0x68>
  if(pid == 0) {
    41d8:	04099363          	bnez	s3,421e <sharedfd+0xc8>
    exit(0);
    41dc:	4501                	li	a0,0
    41de:	00001097          	auipc	ra,0x1
    41e2:	2f4080e7          	jalr	756(ra) # 54d2 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    41e6:	85d2                	mv	a1,s4
    41e8:	00003517          	auipc	a0,0x3
    41ec:	36050513          	add	a0,a0,864 # 7548 <malloc+0x1c56>
    41f0:	00001097          	auipc	ra,0x1
    41f4:	64a080e7          	jalr	1610(ra) # 583a <printf>
    exit(1);
    41f8:	4505                	li	a0,1
    41fa:	00001097          	auipc	ra,0x1
    41fe:	2d8080e7          	jalr	728(ra) # 54d2 <exit>
      printf("%s: write sharedfd failed\n", s);
    4202:	85d2                	mv	a1,s4
    4204:	00003517          	auipc	a0,0x3
    4208:	36c50513          	add	a0,a0,876 # 7570 <malloc+0x1c7e>
    420c:	00001097          	auipc	ra,0x1
    4210:	62e080e7          	jalr	1582(ra) # 583a <printf>
      exit(1);
    4214:	4505                	li	a0,1
    4216:	00001097          	auipc	ra,0x1
    421a:	2bc080e7          	jalr	700(ra) # 54d2 <exit>
    wait(&xstatus);
    421e:	f9c40513          	add	a0,s0,-100
    4222:	00001097          	auipc	ra,0x1
    4226:	2b8080e7          	jalr	696(ra) # 54da <wait>
    if(xstatus != 0)
    422a:	f9c42983          	lw	s3,-100(s0)
    422e:	00098763          	beqz	s3,423c <sharedfd+0xe6>
      exit(xstatus);
    4232:	854e                	mv	a0,s3
    4234:	00001097          	auipc	ra,0x1
    4238:	29e080e7          	jalr	670(ra) # 54d2 <exit>
  close(fd);
    423c:	854a                	mv	a0,s2
    423e:	00001097          	auipc	ra,0x1
    4242:	2bc080e7          	jalr	700(ra) # 54fa <close>
  fd = open("sharedfd", 0);
    4246:	4581                	li	a1,0
    4248:	00003517          	auipc	a0,0x3
    424c:	2f050513          	add	a0,a0,752 # 7538 <malloc+0x1c46>
    4250:	00001097          	auipc	ra,0x1
    4254:	2c2080e7          	jalr	706(ra) # 5512 <open>
    4258:	8baa                	mv	s7,a0
  nc = np = 0;
    425a:	8ace                	mv	s5,s3
  if(fd < 0){
    425c:	02054563          	bltz	a0,4286 <sharedfd+0x130>
    4260:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4264:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4268:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    426c:	4629                	li	a2,10
    426e:	fa040593          	add	a1,s0,-96
    4272:	855e                	mv	a0,s7
    4274:	00001097          	auipc	ra,0x1
    4278:	276080e7          	jalr	630(ra) # 54ea <read>
    427c:	02a05f63          	blez	a0,42ba <sharedfd+0x164>
    4280:	fa040793          	add	a5,s0,-96
    4284:	a01d                	j	42aa <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4286:	85d2                	mv	a1,s4
    4288:	00003517          	auipc	a0,0x3
    428c:	30850513          	add	a0,a0,776 # 7590 <malloc+0x1c9e>
    4290:	00001097          	auipc	ra,0x1
    4294:	5aa080e7          	jalr	1450(ra) # 583a <printf>
    exit(1);
    4298:	4505                	li	a0,1
    429a:	00001097          	auipc	ra,0x1
    429e:	238080e7          	jalr	568(ra) # 54d2 <exit>
        nc++;
    42a2:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    42a4:	0785                	add	a5,a5,1
    42a6:	fd2783e3          	beq	a5,s2,426c <sharedfd+0x116>
      if(buf[i] == 'c')
    42aa:	0007c703          	lbu	a4,0(a5)
    42ae:	fe970ae3          	beq	a4,s1,42a2 <sharedfd+0x14c>
      if(buf[i] == 'p')
    42b2:	ff6719e3          	bne	a4,s6,42a4 <sharedfd+0x14e>
        np++;
    42b6:	2a85                	addw	s5,s5,1
    42b8:	b7f5                	j	42a4 <sharedfd+0x14e>
  close(fd);
    42ba:	855e                	mv	a0,s7
    42bc:	00001097          	auipc	ra,0x1
    42c0:	23e080e7          	jalr	574(ra) # 54fa <close>
  unlink("sharedfd");
    42c4:	00003517          	auipc	a0,0x3
    42c8:	27450513          	add	a0,a0,628 # 7538 <malloc+0x1c46>
    42cc:	00001097          	auipc	ra,0x1
    42d0:	256080e7          	jalr	598(ra) # 5522 <unlink>
  if(nc == N*SZ && np == N*SZ){
    42d4:	6789                	lui	a5,0x2
    42d6:	71078793          	add	a5,a5,1808 # 2710 <sbrkmuch+0x120>
    42da:	00f99763          	bne	s3,a5,42e8 <sharedfd+0x192>
    42de:	6789                	lui	a5,0x2
    42e0:	71078793          	add	a5,a5,1808 # 2710 <sbrkmuch+0x120>
    42e4:	02fa8063          	beq	s5,a5,4304 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    42e8:	85d2                	mv	a1,s4
    42ea:	00003517          	auipc	a0,0x3
    42ee:	2ce50513          	add	a0,a0,718 # 75b8 <malloc+0x1cc6>
    42f2:	00001097          	auipc	ra,0x1
    42f6:	548080e7          	jalr	1352(ra) # 583a <printf>
    exit(1);
    42fa:	4505                	li	a0,1
    42fc:	00001097          	auipc	ra,0x1
    4300:	1d6080e7          	jalr	470(ra) # 54d2 <exit>
    exit(0);
    4304:	4501                	li	a0,0
    4306:	00001097          	auipc	ra,0x1
    430a:	1cc080e7          	jalr	460(ra) # 54d2 <exit>

000000000000430e <fourfiles>:
{
    430e:	7135                	add	sp,sp,-160
    4310:	ed06                	sd	ra,152(sp)
    4312:	e922                	sd	s0,144(sp)
    4314:	e526                	sd	s1,136(sp)
    4316:	e14a                	sd	s2,128(sp)
    4318:	fcce                	sd	s3,120(sp)
    431a:	f8d2                	sd	s4,112(sp)
    431c:	f4d6                	sd	s5,104(sp)
    431e:	f0da                	sd	s6,96(sp)
    4320:	ecde                	sd	s7,88(sp)
    4322:	e8e2                	sd	s8,80(sp)
    4324:	e4e6                	sd	s9,72(sp)
    4326:	e0ea                	sd	s10,64(sp)
    4328:	fc6e                	sd	s11,56(sp)
    432a:	1100                	add	s0,sp,160
    432c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    432e:	00003797          	auipc	a5,0x3
    4332:	2a278793          	add	a5,a5,674 # 75d0 <malloc+0x1cde>
    4336:	f6f43823          	sd	a5,-144(s0)
    433a:	00003797          	auipc	a5,0x3
    433e:	29e78793          	add	a5,a5,670 # 75d8 <malloc+0x1ce6>
    4342:	f6f43c23          	sd	a5,-136(s0)
    4346:	00003797          	auipc	a5,0x3
    434a:	29a78793          	add	a5,a5,666 # 75e0 <malloc+0x1cee>
    434e:	f8f43023          	sd	a5,-128(s0)
    4352:	00003797          	auipc	a5,0x3
    4356:	29678793          	add	a5,a5,662 # 75e8 <malloc+0x1cf6>
    435a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    435e:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4362:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4364:	4481                	li	s1,0
    4366:	4a11                	li	s4,4
    fname = names[pi];
    4368:	00093983          	ld	s3,0(s2)
    unlink(fname);
    436c:	854e                	mv	a0,s3
    436e:	00001097          	auipc	ra,0x1
    4372:	1b4080e7          	jalr	436(ra) # 5522 <unlink>
    pid = fork();
    4376:	00001097          	auipc	ra,0x1
    437a:	154080e7          	jalr	340(ra) # 54ca <fork>
    if(pid < 0){
    437e:	04054063          	bltz	a0,43be <fourfiles+0xb0>
    if(pid == 0){
    4382:	cd21                	beqz	a0,43da <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4384:	2485                	addw	s1,s1,1
    4386:	0921                	add	s2,s2,8
    4388:	ff4490e3          	bne	s1,s4,4368 <fourfiles+0x5a>
    438c:	4491                	li	s1,4
    wait(&xstatus);
    438e:	f6c40513          	add	a0,s0,-148
    4392:	00001097          	auipc	ra,0x1
    4396:	148080e7          	jalr	328(ra) # 54da <wait>
    if(xstatus != 0)
    439a:	f6c42a83          	lw	s5,-148(s0)
    439e:	0c0a9863          	bnez	s5,446e <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    43a2:	34fd                	addw	s1,s1,-1
    43a4:	f4ed                	bnez	s1,438e <fourfiles+0x80>
    43a6:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43aa:	00007a17          	auipc	s4,0x7
    43ae:	5e6a0a13          	add	s4,s4,1510 # b990 <buf>
    if(total != N*SZ){
    43b2:	6d05                	lui	s10,0x1
    43b4:	770d0d13          	add	s10,s10,1904 # 1770 <pipe1+0x2c>
  for(i = 0; i < NCHILD; i++){
    43b8:	03400d93          	li	s11,52
    43bc:	a22d                	j	44e6 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    43be:	85e6                	mv	a1,s9
    43c0:	00002517          	auipc	a0,0x2
    43c4:	29850513          	add	a0,a0,664 # 6658 <malloc+0xd66>
    43c8:	00001097          	auipc	ra,0x1
    43cc:	472080e7          	jalr	1138(ra) # 583a <printf>
      exit(1);
    43d0:	4505                	li	a0,1
    43d2:	00001097          	auipc	ra,0x1
    43d6:	100080e7          	jalr	256(ra) # 54d2 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    43da:	20200593          	li	a1,514
    43de:	854e                	mv	a0,s3
    43e0:	00001097          	auipc	ra,0x1
    43e4:	132080e7          	jalr	306(ra) # 5512 <open>
    43e8:	892a                	mv	s2,a0
      if(fd < 0){
    43ea:	04054763          	bltz	a0,4438 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    43ee:	1f400613          	li	a2,500
    43f2:	0304859b          	addw	a1,s1,48
    43f6:	00007517          	auipc	a0,0x7
    43fa:	59a50513          	add	a0,a0,1434 # b990 <buf>
    43fe:	00001097          	auipc	ra,0x1
    4402:	eda080e7          	jalr	-294(ra) # 52d8 <memset>
    4406:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4408:	00007997          	auipc	s3,0x7
    440c:	58898993          	add	s3,s3,1416 # b990 <buf>
    4410:	1f400613          	li	a2,500
    4414:	85ce                	mv	a1,s3
    4416:	854a                	mv	a0,s2
    4418:	00001097          	auipc	ra,0x1
    441c:	0da080e7          	jalr	218(ra) # 54f2 <write>
    4420:	85aa                	mv	a1,a0
    4422:	1f400793          	li	a5,500
    4426:	02f51763          	bne	a0,a5,4454 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    442a:	34fd                	addw	s1,s1,-1
    442c:	f0f5                	bnez	s1,4410 <fourfiles+0x102>
      exit(0);
    442e:	4501                	li	a0,0
    4430:	00001097          	auipc	ra,0x1
    4434:	0a2080e7          	jalr	162(ra) # 54d2 <exit>
        printf("create failed\n", s);
    4438:	85e6                	mv	a1,s9
    443a:	00003517          	auipc	a0,0x3
    443e:	1b650513          	add	a0,a0,438 # 75f0 <malloc+0x1cfe>
    4442:	00001097          	auipc	ra,0x1
    4446:	3f8080e7          	jalr	1016(ra) # 583a <printf>
        exit(1);
    444a:	4505                	li	a0,1
    444c:	00001097          	auipc	ra,0x1
    4450:	086080e7          	jalr	134(ra) # 54d2 <exit>
          printf("write failed %d\n", n);
    4454:	00003517          	auipc	a0,0x3
    4458:	1ac50513          	add	a0,a0,428 # 7600 <malloc+0x1d0e>
    445c:	00001097          	auipc	ra,0x1
    4460:	3de080e7          	jalr	990(ra) # 583a <printf>
          exit(1);
    4464:	4505                	li	a0,1
    4466:	00001097          	auipc	ra,0x1
    446a:	06c080e7          	jalr	108(ra) # 54d2 <exit>
      exit(xstatus);
    446e:	8556                	mv	a0,s5
    4470:	00001097          	auipc	ra,0x1
    4474:	062080e7          	jalr	98(ra) # 54d2 <exit>
          printf("wrong char\n", s);
    4478:	85e6                	mv	a1,s9
    447a:	00003517          	auipc	a0,0x3
    447e:	19e50513          	add	a0,a0,414 # 7618 <malloc+0x1d26>
    4482:	00001097          	auipc	ra,0x1
    4486:	3b8080e7          	jalr	952(ra) # 583a <printf>
          exit(1);
    448a:	4505                	li	a0,1
    448c:	00001097          	auipc	ra,0x1
    4490:	046080e7          	jalr	70(ra) # 54d2 <exit>
      total += n;
    4494:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4498:	660d                	lui	a2,0x3
    449a:	85d2                	mv	a1,s4
    449c:	854e                	mv	a0,s3
    449e:	00001097          	auipc	ra,0x1
    44a2:	04c080e7          	jalr	76(ra) # 54ea <read>
    44a6:	02a05063          	blez	a0,44c6 <fourfiles+0x1b8>
    44aa:	00007797          	auipc	a5,0x7
    44ae:	4e678793          	add	a5,a5,1254 # b990 <buf>
    44b2:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    44b6:	0007c703          	lbu	a4,0(a5)
    44ba:	fa971fe3          	bne	a4,s1,4478 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    44be:	0785                	add	a5,a5,1
    44c0:	fed79be3          	bne	a5,a3,44b6 <fourfiles+0x1a8>
    44c4:	bfc1                	j	4494 <fourfiles+0x186>
    close(fd);
    44c6:	854e                	mv	a0,s3
    44c8:	00001097          	auipc	ra,0x1
    44cc:	032080e7          	jalr	50(ra) # 54fa <close>
    if(total != N*SZ){
    44d0:	03a91863          	bne	s2,s10,4500 <fourfiles+0x1f2>
    unlink(fname);
    44d4:	8562                	mv	a0,s8
    44d6:	00001097          	auipc	ra,0x1
    44da:	04c080e7          	jalr	76(ra) # 5522 <unlink>
  for(i = 0; i < NCHILD; i++){
    44de:	0ba1                	add	s7,s7,8
    44e0:	2b05                	addw	s6,s6,1
    44e2:	03bb0d63          	beq	s6,s11,451c <fourfiles+0x20e>
    fname = names[i];
    44e6:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    44ea:	4581                	li	a1,0
    44ec:	8562                	mv	a0,s8
    44ee:	00001097          	auipc	ra,0x1
    44f2:	024080e7          	jalr	36(ra) # 5512 <open>
    44f6:	89aa                	mv	s3,a0
    total = 0;
    44f8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    44fa:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    44fe:	bf69                	j	4498 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4500:	85ca                	mv	a1,s2
    4502:	00003517          	auipc	a0,0x3
    4506:	12650513          	add	a0,a0,294 # 7628 <malloc+0x1d36>
    450a:	00001097          	auipc	ra,0x1
    450e:	330080e7          	jalr	816(ra) # 583a <printf>
      exit(1);
    4512:	4505                	li	a0,1
    4514:	00001097          	auipc	ra,0x1
    4518:	fbe080e7          	jalr	-66(ra) # 54d2 <exit>
}
    451c:	60ea                	ld	ra,152(sp)
    451e:	644a                	ld	s0,144(sp)
    4520:	64aa                	ld	s1,136(sp)
    4522:	690a                	ld	s2,128(sp)
    4524:	79e6                	ld	s3,120(sp)
    4526:	7a46                	ld	s4,112(sp)
    4528:	7aa6                	ld	s5,104(sp)
    452a:	7b06                	ld	s6,96(sp)
    452c:	6be6                	ld	s7,88(sp)
    452e:	6c46                	ld	s8,80(sp)
    4530:	6ca6                	ld	s9,72(sp)
    4532:	6d06                	ld	s10,64(sp)
    4534:	7de2                	ld	s11,56(sp)
    4536:	610d                	add	sp,sp,160
    4538:	8082                	ret

000000000000453a <concreate>:
{
    453a:	7135                	add	sp,sp,-160
    453c:	ed06                	sd	ra,152(sp)
    453e:	e922                	sd	s0,144(sp)
    4540:	e526                	sd	s1,136(sp)
    4542:	e14a                	sd	s2,128(sp)
    4544:	fcce                	sd	s3,120(sp)
    4546:	f8d2                	sd	s4,112(sp)
    4548:	f4d6                	sd	s5,104(sp)
    454a:	f0da                	sd	s6,96(sp)
    454c:	ecde                	sd	s7,88(sp)
    454e:	1100                	add	s0,sp,160
    4550:	89aa                	mv	s3,a0
  file[0] = 'C';
    4552:	04300793          	li	a5,67
    4556:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    455a:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    455e:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4560:	4b0d                	li	s6,3
    4562:	4a85                	li	s5,1
      link("C0", file);
    4564:	00003b97          	auipc	s7,0x3
    4568:	0dcb8b93          	add	s7,s7,220 # 7640 <malloc+0x1d4e>
  for(i = 0; i < N; i++){
    456c:	02800a13          	li	s4,40
    4570:	acc9                	j	4842 <concreate+0x308>
      link("C0", file);
    4572:	fa840593          	add	a1,s0,-88
    4576:	855e                	mv	a0,s7
    4578:	00001097          	auipc	ra,0x1
    457c:	fba080e7          	jalr	-70(ra) # 5532 <link>
    if(pid == 0) {
    4580:	a465                	j	4828 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4582:	4795                	li	a5,5
    4584:	02f9693b          	remw	s2,s2,a5
    4588:	4785                	li	a5,1
    458a:	02f90b63          	beq	s2,a5,45c0 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    458e:	20200593          	li	a1,514
    4592:	fa840513          	add	a0,s0,-88
    4596:	00001097          	auipc	ra,0x1
    459a:	f7c080e7          	jalr	-132(ra) # 5512 <open>
      if(fd < 0){
    459e:	26055c63          	bgez	a0,4816 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    45a2:	fa840593          	add	a1,s0,-88
    45a6:	00003517          	auipc	a0,0x3
    45aa:	0a250513          	add	a0,a0,162 # 7648 <malloc+0x1d56>
    45ae:	00001097          	auipc	ra,0x1
    45b2:	28c080e7          	jalr	652(ra) # 583a <printf>
        exit(1);
    45b6:	4505                	li	a0,1
    45b8:	00001097          	auipc	ra,0x1
    45bc:	f1a080e7          	jalr	-230(ra) # 54d2 <exit>
      link("C0", file);
    45c0:	fa840593          	add	a1,s0,-88
    45c4:	00003517          	auipc	a0,0x3
    45c8:	07c50513          	add	a0,a0,124 # 7640 <malloc+0x1d4e>
    45cc:	00001097          	auipc	ra,0x1
    45d0:	f66080e7          	jalr	-154(ra) # 5532 <link>
      exit(0);
    45d4:	4501                	li	a0,0
    45d6:	00001097          	auipc	ra,0x1
    45da:	efc080e7          	jalr	-260(ra) # 54d2 <exit>
        exit(1);
    45de:	4505                	li	a0,1
    45e0:	00001097          	auipc	ra,0x1
    45e4:	ef2080e7          	jalr	-270(ra) # 54d2 <exit>
  memset(fa, 0, sizeof(fa));
    45e8:	02800613          	li	a2,40
    45ec:	4581                	li	a1,0
    45ee:	f8040513          	add	a0,s0,-128
    45f2:	00001097          	auipc	ra,0x1
    45f6:	ce6080e7          	jalr	-794(ra) # 52d8 <memset>
  fd = open(".", 0);
    45fa:	4581                	li	a1,0
    45fc:	00002517          	auipc	a0,0x2
    4600:	acc50513          	add	a0,a0,-1332 # 60c8 <malloc+0x7d6>
    4604:	00001097          	auipc	ra,0x1
    4608:	f0e080e7          	jalr	-242(ra) # 5512 <open>
    460c:	892a                	mv	s2,a0
  n = 0;
    460e:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4610:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4614:	02700b13          	li	s6,39
      fa[i] = 1;
    4618:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    461a:	4641                	li	a2,16
    461c:	f7040593          	add	a1,s0,-144
    4620:	854a                	mv	a0,s2
    4622:	00001097          	auipc	ra,0x1
    4626:	ec8080e7          	jalr	-312(ra) # 54ea <read>
    462a:	08a05263          	blez	a0,46ae <concreate+0x174>
    if(de.inum == 0)
    462e:	f7045783          	lhu	a5,-144(s0)
    4632:	d7e5                	beqz	a5,461a <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4634:	f7244783          	lbu	a5,-142(s0)
    4638:	ff4791e3          	bne	a5,s4,461a <concreate+0xe0>
    463c:	f7444783          	lbu	a5,-140(s0)
    4640:	ffe9                	bnez	a5,461a <concreate+0xe0>
      i = de.name[1] - '0';
    4642:	f7344783          	lbu	a5,-141(s0)
    4646:	fd07879b          	addw	a5,a5,-48
    464a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    464e:	02eb6063          	bltu	s6,a4,466e <concreate+0x134>
      if(fa[i]){
    4652:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x48>
    4656:	97a2                	add	a5,a5,s0
    4658:	fd07c783          	lbu	a5,-48(a5)
    465c:	eb8d                	bnez	a5,468e <concreate+0x154>
      fa[i] = 1;
    465e:	fb070793          	add	a5,a4,-80
    4662:	00878733          	add	a4,a5,s0
    4666:	fd770823          	sb	s7,-48(a4)
      n++;
    466a:	2a85                	addw	s5,s5,1
    466c:	b77d                	j	461a <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    466e:	f7240613          	add	a2,s0,-142
    4672:	85ce                	mv	a1,s3
    4674:	00003517          	auipc	a0,0x3
    4678:	ff450513          	add	a0,a0,-12 # 7668 <malloc+0x1d76>
    467c:	00001097          	auipc	ra,0x1
    4680:	1be080e7          	jalr	446(ra) # 583a <printf>
        exit(1);
    4684:	4505                	li	a0,1
    4686:	00001097          	auipc	ra,0x1
    468a:	e4c080e7          	jalr	-436(ra) # 54d2 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    468e:	f7240613          	add	a2,s0,-142
    4692:	85ce                	mv	a1,s3
    4694:	00003517          	auipc	a0,0x3
    4698:	ff450513          	add	a0,a0,-12 # 7688 <malloc+0x1d96>
    469c:	00001097          	auipc	ra,0x1
    46a0:	19e080e7          	jalr	414(ra) # 583a <printf>
        exit(1);
    46a4:	4505                	li	a0,1
    46a6:	00001097          	auipc	ra,0x1
    46aa:	e2c080e7          	jalr	-468(ra) # 54d2 <exit>
  close(fd);
    46ae:	854a                	mv	a0,s2
    46b0:	00001097          	auipc	ra,0x1
    46b4:	e4a080e7          	jalr	-438(ra) # 54fa <close>
  if(n != N){
    46b8:	02800793          	li	a5,40
    46bc:	00fa9763          	bne	s5,a5,46ca <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    46c0:	4a8d                	li	s5,3
    46c2:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    46c4:	02800a13          	li	s4,40
    46c8:	a8c9                	j	479a <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    46ca:	85ce                	mv	a1,s3
    46cc:	00003517          	auipc	a0,0x3
    46d0:	fe450513          	add	a0,a0,-28 # 76b0 <malloc+0x1dbe>
    46d4:	00001097          	auipc	ra,0x1
    46d8:	166080e7          	jalr	358(ra) # 583a <printf>
    exit(1);
    46dc:	4505                	li	a0,1
    46de:	00001097          	auipc	ra,0x1
    46e2:	df4080e7          	jalr	-524(ra) # 54d2 <exit>
      printf("%s: fork failed\n", s);
    46e6:	85ce                	mv	a1,s3
    46e8:	00002517          	auipc	a0,0x2
    46ec:	b8050513          	add	a0,a0,-1152 # 6268 <malloc+0x976>
    46f0:	00001097          	auipc	ra,0x1
    46f4:	14a080e7          	jalr	330(ra) # 583a <printf>
      exit(1);
    46f8:	4505                	li	a0,1
    46fa:	00001097          	auipc	ra,0x1
    46fe:	dd8080e7          	jalr	-552(ra) # 54d2 <exit>
      close(open(file, 0));
    4702:	4581                	li	a1,0
    4704:	fa840513          	add	a0,s0,-88
    4708:	00001097          	auipc	ra,0x1
    470c:	e0a080e7          	jalr	-502(ra) # 5512 <open>
    4710:	00001097          	auipc	ra,0x1
    4714:	dea080e7          	jalr	-534(ra) # 54fa <close>
      close(open(file, 0));
    4718:	4581                	li	a1,0
    471a:	fa840513          	add	a0,s0,-88
    471e:	00001097          	auipc	ra,0x1
    4722:	df4080e7          	jalr	-524(ra) # 5512 <open>
    4726:	00001097          	auipc	ra,0x1
    472a:	dd4080e7          	jalr	-556(ra) # 54fa <close>
      close(open(file, 0));
    472e:	4581                	li	a1,0
    4730:	fa840513          	add	a0,s0,-88
    4734:	00001097          	auipc	ra,0x1
    4738:	dde080e7          	jalr	-546(ra) # 5512 <open>
    473c:	00001097          	auipc	ra,0x1
    4740:	dbe080e7          	jalr	-578(ra) # 54fa <close>
      close(open(file, 0));
    4744:	4581                	li	a1,0
    4746:	fa840513          	add	a0,s0,-88
    474a:	00001097          	auipc	ra,0x1
    474e:	dc8080e7          	jalr	-568(ra) # 5512 <open>
    4752:	00001097          	auipc	ra,0x1
    4756:	da8080e7          	jalr	-600(ra) # 54fa <close>
      close(open(file, 0));
    475a:	4581                	li	a1,0
    475c:	fa840513          	add	a0,s0,-88
    4760:	00001097          	auipc	ra,0x1
    4764:	db2080e7          	jalr	-590(ra) # 5512 <open>
    4768:	00001097          	auipc	ra,0x1
    476c:	d92080e7          	jalr	-622(ra) # 54fa <close>
      close(open(file, 0));
    4770:	4581                	li	a1,0
    4772:	fa840513          	add	a0,s0,-88
    4776:	00001097          	auipc	ra,0x1
    477a:	d9c080e7          	jalr	-612(ra) # 5512 <open>
    477e:	00001097          	auipc	ra,0x1
    4782:	d7c080e7          	jalr	-644(ra) # 54fa <close>
    if(pid == 0)
    4786:	08090363          	beqz	s2,480c <concreate+0x2d2>
      wait(0);
    478a:	4501                	li	a0,0
    478c:	00001097          	auipc	ra,0x1
    4790:	d4e080e7          	jalr	-690(ra) # 54da <wait>
  for(i = 0; i < N; i++){
    4794:	2485                	addw	s1,s1,1
    4796:	0f448563          	beq	s1,s4,4880 <concreate+0x346>
    file[1] = '0' + i;
    479a:	0304879b          	addw	a5,s1,48
    479e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    47a2:	00001097          	auipc	ra,0x1
    47a6:	d28080e7          	jalr	-728(ra) # 54ca <fork>
    47aa:	892a                	mv	s2,a0
    if(pid < 0){
    47ac:	f2054de3          	bltz	a0,46e6 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    47b0:	0354e73b          	remw	a4,s1,s5
    47b4:	00a767b3          	or	a5,a4,a0
    47b8:	2781                	sext.w	a5,a5
    47ba:	d7a1                	beqz	a5,4702 <concreate+0x1c8>
    47bc:	01671363          	bne	a4,s6,47c2 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    47c0:	f129                	bnez	a0,4702 <concreate+0x1c8>
      unlink(file);
    47c2:	fa840513          	add	a0,s0,-88
    47c6:	00001097          	auipc	ra,0x1
    47ca:	d5c080e7          	jalr	-676(ra) # 5522 <unlink>
      unlink(file);
    47ce:	fa840513          	add	a0,s0,-88
    47d2:	00001097          	auipc	ra,0x1
    47d6:	d50080e7          	jalr	-688(ra) # 5522 <unlink>
      unlink(file);
    47da:	fa840513          	add	a0,s0,-88
    47de:	00001097          	auipc	ra,0x1
    47e2:	d44080e7          	jalr	-700(ra) # 5522 <unlink>
      unlink(file);
    47e6:	fa840513          	add	a0,s0,-88
    47ea:	00001097          	auipc	ra,0x1
    47ee:	d38080e7          	jalr	-712(ra) # 5522 <unlink>
      unlink(file);
    47f2:	fa840513          	add	a0,s0,-88
    47f6:	00001097          	auipc	ra,0x1
    47fa:	d2c080e7          	jalr	-724(ra) # 5522 <unlink>
      unlink(file);
    47fe:	fa840513          	add	a0,s0,-88
    4802:	00001097          	auipc	ra,0x1
    4806:	d20080e7          	jalr	-736(ra) # 5522 <unlink>
    480a:	bfb5                	j	4786 <concreate+0x24c>
      exit(0);
    480c:	4501                	li	a0,0
    480e:	00001097          	auipc	ra,0x1
    4812:	cc4080e7          	jalr	-828(ra) # 54d2 <exit>
      close(fd);
    4816:	00001097          	auipc	ra,0x1
    481a:	ce4080e7          	jalr	-796(ra) # 54fa <close>
    if(pid == 0) {
    481e:	bb5d                	j	45d4 <concreate+0x9a>
      close(fd);
    4820:	00001097          	auipc	ra,0x1
    4824:	cda080e7          	jalr	-806(ra) # 54fa <close>
      wait(&xstatus);
    4828:	f6c40513          	add	a0,s0,-148
    482c:	00001097          	auipc	ra,0x1
    4830:	cae080e7          	jalr	-850(ra) # 54da <wait>
      if(xstatus != 0)
    4834:	f6c42483          	lw	s1,-148(s0)
    4838:	da0493e3          	bnez	s1,45de <concreate+0xa4>
  for(i = 0; i < N; i++){
    483c:	2905                	addw	s2,s2,1
    483e:	db4905e3          	beq	s2,s4,45e8 <concreate+0xae>
    file[1] = '0' + i;
    4842:	0309079b          	addw	a5,s2,48
    4846:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    484a:	fa840513          	add	a0,s0,-88
    484e:	00001097          	auipc	ra,0x1
    4852:	cd4080e7          	jalr	-812(ra) # 5522 <unlink>
    pid = fork();
    4856:	00001097          	auipc	ra,0x1
    485a:	c74080e7          	jalr	-908(ra) # 54ca <fork>
    if(pid && (i % 3) == 1){
    485e:	d20502e3          	beqz	a0,4582 <concreate+0x48>
    4862:	036967bb          	remw	a5,s2,s6
    4866:	d15786e3          	beq	a5,s5,4572 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    486a:	20200593          	li	a1,514
    486e:	fa840513          	add	a0,s0,-88
    4872:	00001097          	auipc	ra,0x1
    4876:	ca0080e7          	jalr	-864(ra) # 5512 <open>
      if(fd < 0){
    487a:	fa0553e3          	bgez	a0,4820 <concreate+0x2e6>
    487e:	b315                	j	45a2 <concreate+0x68>
}
    4880:	60ea                	ld	ra,152(sp)
    4882:	644a                	ld	s0,144(sp)
    4884:	64aa                	ld	s1,136(sp)
    4886:	690a                	ld	s2,128(sp)
    4888:	79e6                	ld	s3,120(sp)
    488a:	7a46                	ld	s4,112(sp)
    488c:	7aa6                	ld	s5,104(sp)
    488e:	7b06                	ld	s6,96(sp)
    4890:	6be6                	ld	s7,88(sp)
    4892:	610d                	add	sp,sp,160
    4894:	8082                	ret

0000000000004896 <bigfile>:
{
    4896:	7139                	add	sp,sp,-64
    4898:	fc06                	sd	ra,56(sp)
    489a:	f822                	sd	s0,48(sp)
    489c:	f426                	sd	s1,40(sp)
    489e:	f04a                	sd	s2,32(sp)
    48a0:	ec4e                	sd	s3,24(sp)
    48a2:	e852                	sd	s4,16(sp)
    48a4:	e456                	sd	s5,8(sp)
    48a6:	0080                	add	s0,sp,64
    48a8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    48aa:	00003517          	auipc	a0,0x3
    48ae:	e3e50513          	add	a0,a0,-450 # 76e8 <malloc+0x1df6>
    48b2:	00001097          	auipc	ra,0x1
    48b6:	c70080e7          	jalr	-912(ra) # 5522 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    48ba:	20200593          	li	a1,514
    48be:	00003517          	auipc	a0,0x3
    48c2:	e2a50513          	add	a0,a0,-470 # 76e8 <malloc+0x1df6>
    48c6:	00001097          	auipc	ra,0x1
    48ca:	c4c080e7          	jalr	-948(ra) # 5512 <open>
    48ce:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    48d0:	4481                	li	s1,0
    memset(buf, i, SZ);
    48d2:	00007917          	auipc	s2,0x7
    48d6:	0be90913          	add	s2,s2,190 # b990 <buf>
  for(i = 0; i < N; i++){
    48da:	4a51                	li	s4,20
  if(fd < 0){
    48dc:	0a054063          	bltz	a0,497c <bigfile+0xe6>
    memset(buf, i, SZ);
    48e0:	25800613          	li	a2,600
    48e4:	85a6                	mv	a1,s1
    48e6:	854a                	mv	a0,s2
    48e8:	00001097          	auipc	ra,0x1
    48ec:	9f0080e7          	jalr	-1552(ra) # 52d8 <memset>
    if(write(fd, buf, SZ) != SZ){
    48f0:	25800613          	li	a2,600
    48f4:	85ca                	mv	a1,s2
    48f6:	854e                	mv	a0,s3
    48f8:	00001097          	auipc	ra,0x1
    48fc:	bfa080e7          	jalr	-1030(ra) # 54f2 <write>
    4900:	25800793          	li	a5,600
    4904:	08f51a63          	bne	a0,a5,4998 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4908:	2485                	addw	s1,s1,1
    490a:	fd449be3          	bne	s1,s4,48e0 <bigfile+0x4a>
  close(fd);
    490e:	854e                	mv	a0,s3
    4910:	00001097          	auipc	ra,0x1
    4914:	bea080e7          	jalr	-1046(ra) # 54fa <close>
  fd = open("bigfile.dat", 0);
    4918:	4581                	li	a1,0
    491a:	00003517          	auipc	a0,0x3
    491e:	dce50513          	add	a0,a0,-562 # 76e8 <malloc+0x1df6>
    4922:	00001097          	auipc	ra,0x1
    4926:	bf0080e7          	jalr	-1040(ra) # 5512 <open>
    492a:	8a2a                	mv	s4,a0
  total = 0;
    492c:	4981                	li	s3,0
  for(i = 0; ; i++){
    492e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4930:	00007917          	auipc	s2,0x7
    4934:	06090913          	add	s2,s2,96 # b990 <buf>
  if(fd < 0){
    4938:	06054e63          	bltz	a0,49b4 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    493c:	12c00613          	li	a2,300
    4940:	85ca                	mv	a1,s2
    4942:	8552                	mv	a0,s4
    4944:	00001097          	auipc	ra,0x1
    4948:	ba6080e7          	jalr	-1114(ra) # 54ea <read>
    if(cc < 0){
    494c:	08054263          	bltz	a0,49d0 <bigfile+0x13a>
    if(cc == 0)
    4950:	c971                	beqz	a0,4a24 <bigfile+0x18e>
    if(cc != SZ/2){
    4952:	12c00793          	li	a5,300
    4956:	08f51b63          	bne	a0,a5,49ec <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    495a:	01f4d79b          	srlw	a5,s1,0x1f
    495e:	9fa5                	addw	a5,a5,s1
    4960:	4017d79b          	sraw	a5,a5,0x1
    4964:	00094703          	lbu	a4,0(s2)
    4968:	0af71063          	bne	a4,a5,4a08 <bigfile+0x172>
    496c:	12b94703          	lbu	a4,299(s2)
    4970:	08f71c63          	bne	a4,a5,4a08 <bigfile+0x172>
    total += cc;
    4974:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4978:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    497a:	b7c9                	j	493c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    497c:	85d6                	mv	a1,s5
    497e:	00003517          	auipc	a0,0x3
    4982:	d7a50513          	add	a0,a0,-646 # 76f8 <malloc+0x1e06>
    4986:	00001097          	auipc	ra,0x1
    498a:	eb4080e7          	jalr	-332(ra) # 583a <printf>
    exit(1);
    498e:	4505                	li	a0,1
    4990:	00001097          	auipc	ra,0x1
    4994:	b42080e7          	jalr	-1214(ra) # 54d2 <exit>
      printf("%s: write bigfile failed\n", s);
    4998:	85d6                	mv	a1,s5
    499a:	00003517          	auipc	a0,0x3
    499e:	d7e50513          	add	a0,a0,-642 # 7718 <malloc+0x1e26>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	e98080e7          	jalr	-360(ra) # 583a <printf>
      exit(1);
    49aa:	4505                	li	a0,1
    49ac:	00001097          	auipc	ra,0x1
    49b0:	b26080e7          	jalr	-1242(ra) # 54d2 <exit>
    printf("%s: cannot open bigfile\n", s);
    49b4:	85d6                	mv	a1,s5
    49b6:	00003517          	auipc	a0,0x3
    49ba:	d8250513          	add	a0,a0,-638 # 7738 <malloc+0x1e46>
    49be:	00001097          	auipc	ra,0x1
    49c2:	e7c080e7          	jalr	-388(ra) # 583a <printf>
    exit(1);
    49c6:	4505                	li	a0,1
    49c8:	00001097          	auipc	ra,0x1
    49cc:	b0a080e7          	jalr	-1270(ra) # 54d2 <exit>
      printf("%s: read bigfile failed\n", s);
    49d0:	85d6                	mv	a1,s5
    49d2:	00003517          	auipc	a0,0x3
    49d6:	d8650513          	add	a0,a0,-634 # 7758 <malloc+0x1e66>
    49da:	00001097          	auipc	ra,0x1
    49de:	e60080e7          	jalr	-416(ra) # 583a <printf>
      exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	aee080e7          	jalr	-1298(ra) # 54d2 <exit>
      printf("%s: short read bigfile\n", s);
    49ec:	85d6                	mv	a1,s5
    49ee:	00003517          	auipc	a0,0x3
    49f2:	d8a50513          	add	a0,a0,-630 # 7778 <malloc+0x1e86>
    49f6:	00001097          	auipc	ra,0x1
    49fa:	e44080e7          	jalr	-444(ra) # 583a <printf>
      exit(1);
    49fe:	4505                	li	a0,1
    4a00:	00001097          	auipc	ra,0x1
    4a04:	ad2080e7          	jalr	-1326(ra) # 54d2 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4a08:	85d6                	mv	a1,s5
    4a0a:	00003517          	auipc	a0,0x3
    4a0e:	d8650513          	add	a0,a0,-634 # 7790 <malloc+0x1e9e>
    4a12:	00001097          	auipc	ra,0x1
    4a16:	e28080e7          	jalr	-472(ra) # 583a <printf>
      exit(1);
    4a1a:	4505                	li	a0,1
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	ab6080e7          	jalr	-1354(ra) # 54d2 <exit>
  close(fd);
    4a24:	8552                	mv	a0,s4
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	ad4080e7          	jalr	-1324(ra) # 54fa <close>
  if(total != N*SZ){
    4a2e:	678d                	lui	a5,0x3
    4a30:	ee078793          	add	a5,a5,-288 # 2ee0 <subdir+0xb2>
    4a34:	02f99363          	bne	s3,a5,4a5a <bigfile+0x1c4>
  unlink("bigfile.dat");
    4a38:	00003517          	auipc	a0,0x3
    4a3c:	cb050513          	add	a0,a0,-848 # 76e8 <malloc+0x1df6>
    4a40:	00001097          	auipc	ra,0x1
    4a44:	ae2080e7          	jalr	-1310(ra) # 5522 <unlink>
}
    4a48:	70e2                	ld	ra,56(sp)
    4a4a:	7442                	ld	s0,48(sp)
    4a4c:	74a2                	ld	s1,40(sp)
    4a4e:	7902                	ld	s2,32(sp)
    4a50:	69e2                	ld	s3,24(sp)
    4a52:	6a42                	ld	s4,16(sp)
    4a54:	6aa2                	ld	s5,8(sp)
    4a56:	6121                	add	sp,sp,64
    4a58:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4a5a:	85d6                	mv	a1,s5
    4a5c:	00003517          	auipc	a0,0x3
    4a60:	d5450513          	add	a0,a0,-684 # 77b0 <malloc+0x1ebe>
    4a64:	00001097          	auipc	ra,0x1
    4a68:	dd6080e7          	jalr	-554(ra) # 583a <printf>
    exit(1);
    4a6c:	4505                	li	a0,1
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	a64080e7          	jalr	-1436(ra) # 54d2 <exit>

0000000000004a76 <dirtest>:
{
    4a76:	1101                	add	sp,sp,-32
    4a78:	ec06                	sd	ra,24(sp)
    4a7a:	e822                	sd	s0,16(sp)
    4a7c:	e426                	sd	s1,8(sp)
    4a7e:	1000                	add	s0,sp,32
    4a80:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    4a82:	00003517          	auipc	a0,0x3
    4a86:	d4e50513          	add	a0,a0,-690 # 77d0 <malloc+0x1ede>
    4a8a:	00001097          	auipc	ra,0x1
    4a8e:	db0080e7          	jalr	-592(ra) # 583a <printf>
  if(mkdir("dir0") < 0){
    4a92:	00003517          	auipc	a0,0x3
    4a96:	d4e50513          	add	a0,a0,-690 # 77e0 <malloc+0x1eee>
    4a9a:	00001097          	auipc	ra,0x1
    4a9e:	aa0080e7          	jalr	-1376(ra) # 553a <mkdir>
    4aa2:	04054d63          	bltz	a0,4afc <dirtest+0x86>
  if(chdir("dir0") < 0){
    4aa6:	00003517          	auipc	a0,0x3
    4aaa:	d3a50513          	add	a0,a0,-710 # 77e0 <malloc+0x1eee>
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	a94080e7          	jalr	-1388(ra) # 5542 <chdir>
    4ab6:	06054163          	bltz	a0,4b18 <dirtest+0xa2>
  if(chdir("..") < 0){
    4aba:	00002517          	auipc	a0,0x2
    4abe:	74650513          	add	a0,a0,1862 # 7200 <malloc+0x190e>
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	a80080e7          	jalr	-1408(ra) # 5542 <chdir>
    4aca:	06054563          	bltz	a0,4b34 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4ace:	00003517          	auipc	a0,0x3
    4ad2:	d1250513          	add	a0,a0,-750 # 77e0 <malloc+0x1eee>
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	a4c080e7          	jalr	-1460(ra) # 5522 <unlink>
    4ade:	06054963          	bltz	a0,4b50 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4ae2:	00003517          	auipc	a0,0x3
    4ae6:	d4e50513          	add	a0,a0,-690 # 7830 <malloc+0x1f3e>
    4aea:	00001097          	auipc	ra,0x1
    4aee:	d50080e7          	jalr	-688(ra) # 583a <printf>
}
    4af2:	60e2                	ld	ra,24(sp)
    4af4:	6442                	ld	s0,16(sp)
    4af6:	64a2                	ld	s1,8(sp)
    4af8:	6105                	add	sp,sp,32
    4afa:	8082                	ret
    printf("%s: mkdir failed\n", s);
    4afc:	85a6                	mv	a1,s1
    4afe:	00002517          	auipc	a0,0x2
    4b02:	0a250513          	add	a0,a0,162 # 6ba0 <malloc+0x12ae>
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	d34080e7          	jalr	-716(ra) # 583a <printf>
    exit(1);
    4b0e:	4505                	li	a0,1
    4b10:	00001097          	auipc	ra,0x1
    4b14:	9c2080e7          	jalr	-1598(ra) # 54d2 <exit>
    printf("%s: chdir dir0 failed\n", s);
    4b18:	85a6                	mv	a1,s1
    4b1a:	00003517          	auipc	a0,0x3
    4b1e:	cce50513          	add	a0,a0,-818 # 77e8 <malloc+0x1ef6>
    4b22:	00001097          	auipc	ra,0x1
    4b26:	d18080e7          	jalr	-744(ra) # 583a <printf>
    exit(1);
    4b2a:	4505                	li	a0,1
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	9a6080e7          	jalr	-1626(ra) # 54d2 <exit>
    printf("%s: chdir .. failed\n", s);
    4b34:	85a6                	mv	a1,s1
    4b36:	00003517          	auipc	a0,0x3
    4b3a:	cca50513          	add	a0,a0,-822 # 7800 <malloc+0x1f0e>
    4b3e:	00001097          	auipc	ra,0x1
    4b42:	cfc080e7          	jalr	-772(ra) # 583a <printf>
    exit(1);
    4b46:	4505                	li	a0,1
    4b48:	00001097          	auipc	ra,0x1
    4b4c:	98a080e7          	jalr	-1654(ra) # 54d2 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4b50:	85a6                	mv	a1,s1
    4b52:	00003517          	auipc	a0,0x3
    4b56:	cc650513          	add	a0,a0,-826 # 7818 <malloc+0x1f26>
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	ce0080e7          	jalr	-800(ra) # 583a <printf>
    exit(1);
    4b62:	4505                	li	a0,1
    4b64:	00001097          	auipc	ra,0x1
    4b68:	96e080e7          	jalr	-1682(ra) # 54d2 <exit>

0000000000004b6c <fsfull>:
{
    4b6c:	7135                	add	sp,sp,-160
    4b6e:	ed06                	sd	ra,152(sp)
    4b70:	e922                	sd	s0,144(sp)
    4b72:	e526                	sd	s1,136(sp)
    4b74:	e14a                	sd	s2,128(sp)
    4b76:	fcce                	sd	s3,120(sp)
    4b78:	f8d2                	sd	s4,112(sp)
    4b7a:	f4d6                	sd	s5,104(sp)
    4b7c:	f0da                	sd	s6,96(sp)
    4b7e:	ecde                	sd	s7,88(sp)
    4b80:	e8e2                	sd	s8,80(sp)
    4b82:	e4e6                	sd	s9,72(sp)
    4b84:	e0ea                	sd	s10,64(sp)
    4b86:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    4b88:	00003517          	auipc	a0,0x3
    4b8c:	cc050513          	add	a0,a0,-832 # 7848 <malloc+0x1f56>
    4b90:	00001097          	auipc	ra,0x1
    4b94:	caa080e7          	jalr	-854(ra) # 583a <printf>
  for(nfiles = 0; ; nfiles++){
    4b98:	4481                	li	s1,0
    name[0] = 'f';
    4b9a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4b9e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ba2:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ba6:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4ba8:	00003c97          	auipc	s9,0x3
    4bac:	cb0c8c93          	add	s9,s9,-848 # 7858 <malloc+0x1f66>
    name[0] = 'f';
    4bb0:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4bb4:	0384c7bb          	divw	a5,s1,s8
    4bb8:	0307879b          	addw	a5,a5,48
    4bbc:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4bc0:	0384e7bb          	remw	a5,s1,s8
    4bc4:	0377c7bb          	divw	a5,a5,s7
    4bc8:	0307879b          	addw	a5,a5,48
    4bcc:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4bd0:	0374e7bb          	remw	a5,s1,s7
    4bd4:	0367c7bb          	divw	a5,a5,s6
    4bd8:	0307879b          	addw	a5,a5,48
    4bdc:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4be0:	0364e7bb          	remw	a5,s1,s6
    4be4:	0307879b          	addw	a5,a5,48
    4be8:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4bec:	f60402a3          	sb	zero,-155(s0)
    printf("%s: writing %s\n", name);
    4bf0:	f6040593          	add	a1,s0,-160
    4bf4:	8566                	mv	a0,s9
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	c44080e7          	jalr	-956(ra) # 583a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4bfe:	20200593          	li	a1,514
    4c02:	f6040513          	add	a0,s0,-160
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	90c080e7          	jalr	-1780(ra) # 5512 <open>
    4c0e:	892a                	mv	s2,a0
    if(fd < 0){
    4c10:	0a055563          	bgez	a0,4cba <fsfull+0x14e>
      printf("%s: open %s failed\n", name);
    4c14:	f6040593          	add	a1,s0,-160
    4c18:	00003517          	auipc	a0,0x3
    4c1c:	c5050513          	add	a0,a0,-944 # 7868 <malloc+0x1f76>
    4c20:	00001097          	auipc	ra,0x1
    4c24:	c1a080e7          	jalr	-998(ra) # 583a <printf>
  while(nfiles >= 0){
    4c28:	0604c363          	bltz	s1,4c8e <fsfull+0x122>
    name[0] = 'f';
    4c2c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4c30:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4c34:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4c38:	4929                	li	s2,10
  while(nfiles >= 0){
    4c3a:	5afd                	li	s5,-1
    name[0] = 'f';
    4c3c:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4c40:	0344c7bb          	divw	a5,s1,s4
    4c44:	0307879b          	addw	a5,a5,48
    4c48:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4c4c:	0344e7bb          	remw	a5,s1,s4
    4c50:	0337c7bb          	divw	a5,a5,s3
    4c54:	0307879b          	addw	a5,a5,48
    4c58:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4c5c:	0334e7bb          	remw	a5,s1,s3
    4c60:	0327c7bb          	divw	a5,a5,s2
    4c64:	0307879b          	addw	a5,a5,48
    4c68:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4c6c:	0324e7bb          	remw	a5,s1,s2
    4c70:	0307879b          	addw	a5,a5,48
    4c74:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4c78:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4c7c:	f6040513          	add	a0,s0,-160
    4c80:	00001097          	auipc	ra,0x1
    4c84:	8a2080e7          	jalr	-1886(ra) # 5522 <unlink>
    nfiles--;
    4c88:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    4c8a:	fb5499e3          	bne	s1,s5,4c3c <fsfull+0xd0>
  printf("fsfull test finished\n");
    4c8e:	00003517          	auipc	a0,0x3
    4c92:	c0a50513          	add	a0,a0,-1014 # 7898 <malloc+0x1fa6>
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	ba4080e7          	jalr	-1116(ra) # 583a <printf>
}
    4c9e:	60ea                	ld	ra,152(sp)
    4ca0:	644a                	ld	s0,144(sp)
    4ca2:	64aa                	ld	s1,136(sp)
    4ca4:	690a                	ld	s2,128(sp)
    4ca6:	79e6                	ld	s3,120(sp)
    4ca8:	7a46                	ld	s4,112(sp)
    4caa:	7aa6                	ld	s5,104(sp)
    4cac:	7b06                	ld	s6,96(sp)
    4cae:	6be6                	ld	s7,88(sp)
    4cb0:	6c46                	ld	s8,80(sp)
    4cb2:	6ca6                	ld	s9,72(sp)
    4cb4:	6d06                	ld	s10,64(sp)
    4cb6:	610d                	add	sp,sp,160
    4cb8:	8082                	ret
    int total = 0;
    4cba:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4cbc:	00007a97          	auipc	s5,0x7
    4cc0:	cd4a8a93          	add	s5,s5,-812 # b990 <buf>
      if(cc < BSIZE)
    4cc4:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4cc8:	40000613          	li	a2,1024
    4ccc:	85d6                	mv	a1,s5
    4cce:	854a                	mv	a0,s2
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	822080e7          	jalr	-2014(ra) # 54f2 <write>
      if(cc < BSIZE)
    4cd8:	00aa5563          	bge	s4,a0,4ce2 <fsfull+0x176>
      total += cc;
    4cdc:	00a989bb          	addw	s3,s3,a0
    while(1){
    4ce0:	b7e5                	j	4cc8 <fsfull+0x15c>
    printf("%s: wrote %d bytes\n", total);
    4ce2:	85ce                	mv	a1,s3
    4ce4:	00003517          	auipc	a0,0x3
    4ce8:	b9c50513          	add	a0,a0,-1124 # 7880 <malloc+0x1f8e>
    4cec:	00001097          	auipc	ra,0x1
    4cf0:	b4e080e7          	jalr	-1202(ra) # 583a <printf>
    close(fd);
    4cf4:	854a                	mv	a0,s2
    4cf6:	00001097          	auipc	ra,0x1
    4cfa:	804080e7          	jalr	-2044(ra) # 54fa <close>
    if(total == 0)
    4cfe:	f20985e3          	beqz	s3,4c28 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    4d02:	2485                	addw	s1,s1,1
    4d04:	b575                	j	4bb0 <fsfull+0x44>

0000000000004d06 <rand>:
{
    4d06:	1141                	add	sp,sp,-16
    4d08:	e422                	sd	s0,8(sp)
    4d0a:	0800                	add	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4d0c:	00003717          	auipc	a4,0x3
    4d10:	45470713          	add	a4,a4,1108 # 8160 <randstate>
    4d14:	6308                	ld	a0,0(a4)
    4d16:	001967b7          	lui	a5,0x196
    4d1a:	60d78793          	add	a5,a5,1549 # 19660d <__BSS_END__+0x187c6d>
    4d1e:	02f50533          	mul	a0,a0,a5
    4d22:	3c6ef7b7          	lui	a5,0x3c6ef
    4d26:	35f78793          	add	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e09bf>
    4d2a:	953e                	add	a0,a0,a5
    4d2c:	e308                	sd	a0,0(a4)
}
    4d2e:	2501                	sext.w	a0,a0
    4d30:	6422                	ld	s0,8(sp)
    4d32:	0141                	add	sp,sp,16
    4d34:	8082                	ret

0000000000004d36 <badwrite>:
{
    4d36:	7179                	add	sp,sp,-48
    4d38:	f406                	sd	ra,40(sp)
    4d3a:	f022                	sd	s0,32(sp)
    4d3c:	ec26                	sd	s1,24(sp)
    4d3e:	e84a                	sd	s2,16(sp)
    4d40:	e44e                	sd	s3,8(sp)
    4d42:	e052                	sd	s4,0(sp)
    4d44:	1800                	add	s0,sp,48
  unlink("junk");
    4d46:	00003517          	auipc	a0,0x3
    4d4a:	b6a50513          	add	a0,a0,-1174 # 78b0 <malloc+0x1fbe>
    4d4e:	00000097          	auipc	ra,0x0
    4d52:	7d4080e7          	jalr	2004(ra) # 5522 <unlink>
    4d56:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d5a:	00003997          	auipc	s3,0x3
    4d5e:	b5698993          	add	s3,s3,-1194 # 78b0 <malloc+0x1fbe>
    write(fd, (char*)0xffffffffffL, 1);
    4d62:	5a7d                	li	s4,-1
    4d64:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d68:	20100593          	li	a1,513
    4d6c:	854e                	mv	a0,s3
    4d6e:	00000097          	auipc	ra,0x0
    4d72:	7a4080e7          	jalr	1956(ra) # 5512 <open>
    4d76:	84aa                	mv	s1,a0
    if(fd < 0){
    4d78:	06054b63          	bltz	a0,4dee <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4d7c:	4605                	li	a2,1
    4d7e:	85d2                	mv	a1,s4
    4d80:	00000097          	auipc	ra,0x0
    4d84:	772080e7          	jalr	1906(ra) # 54f2 <write>
    close(fd);
    4d88:	8526                	mv	a0,s1
    4d8a:	00000097          	auipc	ra,0x0
    4d8e:	770080e7          	jalr	1904(ra) # 54fa <close>
    unlink("junk");
    4d92:	854e                	mv	a0,s3
    4d94:	00000097          	auipc	ra,0x0
    4d98:	78e080e7          	jalr	1934(ra) # 5522 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4d9c:	397d                	addw	s2,s2,-1
    4d9e:	fc0915e3          	bnez	s2,4d68 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4da2:	20100593          	li	a1,513
    4da6:	00003517          	auipc	a0,0x3
    4daa:	b0a50513          	add	a0,a0,-1270 # 78b0 <malloc+0x1fbe>
    4dae:	00000097          	auipc	ra,0x0
    4db2:	764080e7          	jalr	1892(ra) # 5512 <open>
    4db6:	84aa                	mv	s1,a0
  if(fd < 0){
    4db8:	04054863          	bltz	a0,4e08 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4dbc:	4605                	li	a2,1
    4dbe:	00001597          	auipc	a1,0x1
    4dc2:	cc258593          	add	a1,a1,-830 # 5a80 <malloc+0x18e>
    4dc6:	00000097          	auipc	ra,0x0
    4dca:	72c080e7          	jalr	1836(ra) # 54f2 <write>
    4dce:	4785                	li	a5,1
    4dd0:	04f50963          	beq	a0,a5,4e22 <badwrite+0xec>
    printf("write failed\n");
    4dd4:	00003517          	auipc	a0,0x3
    4dd8:	afc50513          	add	a0,a0,-1284 # 78d0 <malloc+0x1fde>
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	a5e080e7          	jalr	-1442(ra) # 583a <printf>
    exit(1);
    4de4:	4505                	li	a0,1
    4de6:	00000097          	auipc	ra,0x0
    4dea:	6ec080e7          	jalr	1772(ra) # 54d2 <exit>
      printf("open junk failed\n");
    4dee:	00003517          	auipc	a0,0x3
    4df2:	aca50513          	add	a0,a0,-1334 # 78b8 <malloc+0x1fc6>
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	a44080e7          	jalr	-1468(ra) # 583a <printf>
      exit(1);
    4dfe:	4505                	li	a0,1
    4e00:	00000097          	auipc	ra,0x0
    4e04:	6d2080e7          	jalr	1746(ra) # 54d2 <exit>
    printf("open junk failed\n");
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	ab050513          	add	a0,a0,-1360 # 78b8 <malloc+0x1fc6>
    4e10:	00001097          	auipc	ra,0x1
    4e14:	a2a080e7          	jalr	-1494(ra) # 583a <printf>
    exit(1);
    4e18:	4505                	li	a0,1
    4e1a:	00000097          	auipc	ra,0x0
    4e1e:	6b8080e7          	jalr	1720(ra) # 54d2 <exit>
  close(fd);
    4e22:	8526                	mv	a0,s1
    4e24:	00000097          	auipc	ra,0x0
    4e28:	6d6080e7          	jalr	1750(ra) # 54fa <close>
  unlink("junk");
    4e2c:	00003517          	auipc	a0,0x3
    4e30:	a8450513          	add	a0,a0,-1404 # 78b0 <malloc+0x1fbe>
    4e34:	00000097          	auipc	ra,0x0
    4e38:	6ee080e7          	jalr	1774(ra) # 5522 <unlink>
  exit(0);
    4e3c:	4501                	li	a0,0
    4e3e:	00000097          	auipc	ra,0x0
    4e42:	694080e7          	jalr	1684(ra) # 54d2 <exit>

0000000000004e46 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4e46:	7139                	add	sp,sp,-64
    4e48:	fc06                	sd	ra,56(sp)
    4e4a:	f822                	sd	s0,48(sp)
    4e4c:	f426                	sd	s1,40(sp)
    4e4e:	f04a                	sd	s2,32(sp)
    4e50:	ec4e                	sd	s3,24(sp)
    4e52:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4e54:	fc840513          	add	a0,s0,-56
    4e58:	00000097          	auipc	ra,0x0
    4e5c:	68a080e7          	jalr	1674(ra) # 54e2 <pipe>
    4e60:	06054763          	bltz	a0,4ece <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4e64:	00000097          	auipc	ra,0x0
    4e68:	666080e7          	jalr	1638(ra) # 54ca <fork>

  if(pid < 0){
    4e6c:	06054e63          	bltz	a0,4ee8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4e70:	ed51                	bnez	a0,4f0c <countfree+0xc6>
    close(fds[0]);
    4e72:	fc842503          	lw	a0,-56(s0)
    4e76:	00000097          	auipc	ra,0x0
    4e7a:	684080e7          	jalr	1668(ra) # 54fa <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4e7e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4e80:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4e82:	00001997          	auipc	s3,0x1
    4e86:	bfe98993          	add	s3,s3,-1026 # 5a80 <malloc+0x18e>
      uint64 a = (uint64) sbrk(4096);
    4e8a:	6505                	lui	a0,0x1
    4e8c:	00000097          	auipc	ra,0x0
    4e90:	6ce080e7          	jalr	1742(ra) # 555a <sbrk>
      if(a == 0xffffffffffffffff){
    4e94:	07250763          	beq	a0,s2,4f02 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4e98:	6785                	lui	a5,0x1
    4e9a:	97aa                	add	a5,a5,a0
    4e9c:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x97>
      if(write(fds[1], "x", 1) != 1){
    4ea0:	8626                	mv	a2,s1
    4ea2:	85ce                	mv	a1,s3
    4ea4:	fcc42503          	lw	a0,-52(s0)
    4ea8:	00000097          	auipc	ra,0x0
    4eac:	64a080e7          	jalr	1610(ra) # 54f2 <write>
    4eb0:	fc950de3          	beq	a0,s1,4e8a <countfree+0x44>
        printf("write() failed in countfree()\n");
    4eb4:	00003517          	auipc	a0,0x3
    4eb8:	a6c50513          	add	a0,a0,-1428 # 7920 <malloc+0x202e>
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	97e080e7          	jalr	-1666(ra) # 583a <printf>
        exit(1);
    4ec4:	4505                	li	a0,1
    4ec6:	00000097          	auipc	ra,0x0
    4eca:	60c080e7          	jalr	1548(ra) # 54d2 <exit>
    printf("pipe() failed in countfree()\n");
    4ece:	00003517          	auipc	a0,0x3
    4ed2:	a1250513          	add	a0,a0,-1518 # 78e0 <malloc+0x1fee>
    4ed6:	00001097          	auipc	ra,0x1
    4eda:	964080e7          	jalr	-1692(ra) # 583a <printf>
    exit(1);
    4ede:	4505                	li	a0,1
    4ee0:	00000097          	auipc	ra,0x0
    4ee4:	5f2080e7          	jalr	1522(ra) # 54d2 <exit>
    printf("fork failed in countfree()\n");
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	a1850513          	add	a0,a0,-1512 # 7900 <malloc+0x200e>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	94a080e7          	jalr	-1718(ra) # 583a <printf>
    exit(1);
    4ef8:	4505                	li	a0,1
    4efa:	00000097          	auipc	ra,0x0
    4efe:	5d8080e7          	jalr	1496(ra) # 54d2 <exit>
      }
    }

    exit(0);
    4f02:	4501                	li	a0,0
    4f04:	00000097          	auipc	ra,0x0
    4f08:	5ce080e7          	jalr	1486(ra) # 54d2 <exit>
  }

  close(fds[1]);
    4f0c:	fcc42503          	lw	a0,-52(s0)
    4f10:	00000097          	auipc	ra,0x0
    4f14:	5ea080e7          	jalr	1514(ra) # 54fa <close>

  int n = 0;
    4f18:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4f1a:	4605                	li	a2,1
    4f1c:	fc740593          	add	a1,s0,-57
    4f20:	fc842503          	lw	a0,-56(s0)
    4f24:	00000097          	auipc	ra,0x0
    4f28:	5c6080e7          	jalr	1478(ra) # 54ea <read>
    if(cc < 0){
    4f2c:	00054563          	bltz	a0,4f36 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4f30:	c105                	beqz	a0,4f50 <countfree+0x10a>
      break;
    n += 1;
    4f32:	2485                	addw	s1,s1,1
  while(1){
    4f34:	b7dd                	j	4f1a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4f36:	00003517          	auipc	a0,0x3
    4f3a:	a0a50513          	add	a0,a0,-1526 # 7940 <malloc+0x204e>
    4f3e:	00001097          	auipc	ra,0x1
    4f42:	8fc080e7          	jalr	-1796(ra) # 583a <printf>
      exit(1);
    4f46:	4505                	li	a0,1
    4f48:	00000097          	auipc	ra,0x0
    4f4c:	58a080e7          	jalr	1418(ra) # 54d2 <exit>
  }

  close(fds[0]);
    4f50:	fc842503          	lw	a0,-56(s0)
    4f54:	00000097          	auipc	ra,0x0
    4f58:	5a6080e7          	jalr	1446(ra) # 54fa <close>
  wait((int*)0);
    4f5c:	4501                	li	a0,0
    4f5e:	00000097          	auipc	ra,0x0
    4f62:	57c080e7          	jalr	1404(ra) # 54da <wait>
  
  return n;
}
    4f66:	8526                	mv	a0,s1
    4f68:	70e2                	ld	ra,56(sp)
    4f6a:	7442                	ld	s0,48(sp)
    4f6c:	74a2                	ld	s1,40(sp)
    4f6e:	7902                	ld	s2,32(sp)
    4f70:	69e2                	ld	s3,24(sp)
    4f72:	6121                	add	sp,sp,64
    4f74:	8082                	ret

0000000000004f76 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4f76:	7179                	add	sp,sp,-48
    4f78:	f406                	sd	ra,40(sp)
    4f7a:	f022                	sd	s0,32(sp)
    4f7c:	ec26                	sd	s1,24(sp)
    4f7e:	e84a                	sd	s2,16(sp)
    4f80:	1800                	add	s0,sp,48
    4f82:	84aa                	mv	s1,a0
    4f84:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4f86:	00003517          	auipc	a0,0x3
    4f8a:	9da50513          	add	a0,a0,-1574 # 7960 <malloc+0x206e>
    4f8e:	00001097          	auipc	ra,0x1
    4f92:	8ac080e7          	jalr	-1876(ra) # 583a <printf>
  if((pid = fork()) < 0) {
    4f96:	00000097          	auipc	ra,0x0
    4f9a:	534080e7          	jalr	1332(ra) # 54ca <fork>
    4f9e:	02054e63          	bltz	a0,4fda <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4fa2:	c929                	beqz	a0,4ff4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4fa4:	fdc40513          	add	a0,s0,-36
    4fa8:	00000097          	auipc	ra,0x0
    4fac:	532080e7          	jalr	1330(ra) # 54da <wait>
    if(xstatus != 0) 
    4fb0:	fdc42783          	lw	a5,-36(s0)
    4fb4:	c7b9                	beqz	a5,5002 <run+0x8c>
      printf("FAILED\n");
    4fb6:	00003517          	auipc	a0,0x3
    4fba:	9d250513          	add	a0,a0,-1582 # 7988 <malloc+0x2096>
    4fbe:	00001097          	auipc	ra,0x1
    4fc2:	87c080e7          	jalr	-1924(ra) # 583a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4fc6:	fdc42503          	lw	a0,-36(s0)
  }
}
    4fca:	00153513          	seqz	a0,a0
    4fce:	70a2                	ld	ra,40(sp)
    4fd0:	7402                	ld	s0,32(sp)
    4fd2:	64e2                	ld	s1,24(sp)
    4fd4:	6942                	ld	s2,16(sp)
    4fd6:	6145                	add	sp,sp,48
    4fd8:	8082                	ret
    printf("runtest: fork error\n");
    4fda:	00003517          	auipc	a0,0x3
    4fde:	99650513          	add	a0,a0,-1642 # 7970 <malloc+0x207e>
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	858080e7          	jalr	-1960(ra) # 583a <printf>
    exit(1);
    4fea:	4505                	li	a0,1
    4fec:	00000097          	auipc	ra,0x0
    4ff0:	4e6080e7          	jalr	1254(ra) # 54d2 <exit>
    f(s);
    4ff4:	854a                	mv	a0,s2
    4ff6:	9482                	jalr	s1
    exit(0);
    4ff8:	4501                	li	a0,0
    4ffa:	00000097          	auipc	ra,0x0
    4ffe:	4d8080e7          	jalr	1240(ra) # 54d2 <exit>
      printf("OK\n");
    5002:	00003517          	auipc	a0,0x3
    5006:	98e50513          	add	a0,a0,-1650 # 7990 <malloc+0x209e>
    500a:	00001097          	auipc	ra,0x1
    500e:	830080e7          	jalr	-2000(ra) # 583a <printf>
    5012:	bf55                	j	4fc6 <run+0x50>

0000000000005014 <main>:

int
main(int argc, char *argv[])
{
    5014:	c3010113          	add	sp,sp,-976
    5018:	3c113423          	sd	ra,968(sp)
    501c:	3c813023          	sd	s0,960(sp)
    5020:	3a913c23          	sd	s1,952(sp)
    5024:	3b213823          	sd	s2,944(sp)
    5028:	3b313423          	sd	s3,936(sp)
    502c:	3b413023          	sd	s4,928(sp)
    5030:	39513c23          	sd	s5,920(sp)
    5034:	39613823          	sd	s6,912(sp)
    5038:	0f80                	add	s0,sp,976
    503a:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    503c:	4789                	li	a5,2
    503e:	0af50063          	beq	a0,a5,50de <main+0xca>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5042:	4785                	li	a5,1
    5044:	12a7cd63          	blt	a5,a0,517e <main+0x16a>
  char *justone = 0;
    5048:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    504a:	00003797          	auipc	a5,0x3
    504e:	d0678793          	add	a5,a5,-762 # 7d50 <malloc+0x245e>
    5052:	c3040713          	add	a4,s0,-976
    5056:	00003317          	auipc	t1,0x3
    505a:	08a30313          	add	t1,t1,138 # 80e0 <malloc+0x27ee>
    505e:	0007b883          	ld	a7,0(a5)
    5062:	0087b803          	ld	a6,8(a5)
    5066:	6b88                	ld	a0,16(a5)
    5068:	6f8c                	ld	a1,24(a5)
    506a:	7390                	ld	a2,32(a5)
    506c:	7794                	ld	a3,40(a5)
    506e:	01173023          	sd	a7,0(a4)
    5072:	01073423          	sd	a6,8(a4)
    5076:	eb08                	sd	a0,16(a4)
    5078:	ef0c                	sd	a1,24(a4)
    507a:	f310                	sd	a2,32(a4)
    507c:	f714                	sd	a3,40(a4)
    507e:	03078793          	add	a5,a5,48
    5082:	03070713          	add	a4,a4,48
    5086:	fc679ce3          	bne	a5,t1,505e <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    508a:	00003517          	auipc	a0,0x3
    508e:	9c650513          	add	a0,a0,-1594 # 7a50 <malloc+0x215e>
    5092:	00000097          	auipc	ra,0x0
    5096:	7a8080e7          	jalr	1960(ra) # 583a <printf>
  int free0 = countfree();
    509a:	00000097          	auipc	ra,0x0
    509e:	dac080e7          	jalr	-596(ra) # 4e46 <countfree>
    50a2:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    50a4:	c3843903          	ld	s2,-968(s0)
    50a8:	c3040493          	add	s1,s0,-976
  int fail = 0;
    50ac:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    50ae:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    50b0:	10091c63          	bnez	s2,51c8 <main+0x1b4>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    50b4:	00000097          	auipc	ra,0x0
    50b8:	d92080e7          	jalr	-622(ra) # 4e46 <countfree>
    50bc:	85aa                	mv	a1,a0
    50be:	15555663          	bge	a0,s5,520a <main+0x1f6>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    50c2:	8656                	mv	a2,s5
    50c4:	00003517          	auipc	a0,0x3
    50c8:	94450513          	add	a0,a0,-1724 # 7a08 <malloc+0x2116>
    50cc:	00000097          	auipc	ra,0x0
    50d0:	76e080e7          	jalr	1902(ra) # 583a <printf>
    exit(1);
    50d4:	4505                	li	a0,1
    50d6:	00000097          	auipc	ra,0x0
    50da:	3fc080e7          	jalr	1020(ra) # 54d2 <exit>
    50de:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    50e0:	00003597          	auipc	a1,0x3
    50e4:	8b858593          	add	a1,a1,-1864 # 7998 <malloc+0x20a6>
    50e8:	6488                	ld	a0,8(s1)
    50ea:	00000097          	auipc	ra,0x0
    50ee:	198080e7          	jalr	408(ra) # 5282 <strcmp>
    50f2:	e525                	bnez	a0,515a <main+0x146>
    continuous = 1;
    50f4:	4985                	li	s3,1
  } tests[] = {
    50f6:	00003797          	auipc	a5,0x3
    50fa:	c5a78793          	add	a5,a5,-934 # 7d50 <malloc+0x245e>
    50fe:	c3040713          	add	a4,s0,-976
    5102:	00003317          	auipc	t1,0x3
    5106:	fde30313          	add	t1,t1,-34 # 80e0 <malloc+0x27ee>
    510a:	0007b883          	ld	a7,0(a5)
    510e:	0087b803          	ld	a6,8(a5)
    5112:	6b88                	ld	a0,16(a5)
    5114:	6f8c                	ld	a1,24(a5)
    5116:	7390                	ld	a2,32(a5)
    5118:	7794                	ld	a3,40(a5)
    511a:	01173023          	sd	a7,0(a4)
    511e:	01073423          	sd	a6,8(a4)
    5122:	eb08                	sd	a0,16(a4)
    5124:	ef0c                	sd	a1,24(a4)
    5126:	f310                	sd	a2,32(a4)
    5128:	f714                	sd	a3,40(a4)
    512a:	03078793          	add	a5,a5,48
    512e:	03070713          	add	a4,a4,48
    5132:	fc679ce3          	bne	a5,t1,510a <main+0xf6>
    printf("continuous usertests starting\n");
    5136:	00003517          	auipc	a0,0x3
    513a:	93250513          	add	a0,a0,-1742 # 7a68 <malloc+0x2176>
    513e:	00000097          	auipc	ra,0x0
    5142:	6fc080e7          	jalr	1788(ra) # 583a <printf>
        printf("SOME TESTS FAILED\n");
    5146:	00003a97          	auipc	s5,0x3
    514a:	8aaa8a93          	add	s5,s5,-1878 # 79f0 <malloc+0x20fe>
        if(continuous != 2)
    514e:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5150:	00003b17          	auipc	s6,0x3
    5154:	880b0b13          	add	s6,s6,-1920 # 79d0 <malloc+0x20de>
    5158:	a0dd                	j	523e <main+0x22a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    515a:	00003597          	auipc	a1,0x3
    515e:	84658593          	add	a1,a1,-1978 # 79a0 <malloc+0x20ae>
    5162:	6488                	ld	a0,8(s1)
    5164:	00000097          	auipc	ra,0x0
    5168:	11e080e7          	jalr	286(ra) # 5282 <strcmp>
    516c:	d549                	beqz	a0,50f6 <main+0xe2>
  } else if(argc == 2 && argv[1][0] != '-'){
    516e:	0084b983          	ld	s3,8(s1)
    5172:	0009c703          	lbu	a4,0(s3)
    5176:	02d00793          	li	a5,45
    517a:	ecf718e3          	bne	a4,a5,504a <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    517e:	00003517          	auipc	a0,0x3
    5182:	82a50513          	add	a0,a0,-2006 # 79a8 <malloc+0x20b6>
    5186:	00000097          	auipc	ra,0x0
    518a:	6b4080e7          	jalr	1716(ra) # 583a <printf>
    exit(1);
    518e:	4505                	li	a0,1
    5190:	00000097          	auipc	ra,0x0
    5194:	342080e7          	jalr	834(ra) # 54d2 <exit>
          exit(1);
    5198:	4505                	li	a0,1
    519a:	00000097          	auipc	ra,0x0
    519e:	338080e7          	jalr	824(ra) # 54d2 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    51a2:	40a905bb          	subw	a1,s2,a0
    51a6:	855a                	mv	a0,s6
    51a8:	00000097          	auipc	ra,0x0
    51ac:	692080e7          	jalr	1682(ra) # 583a <printf>
        if(continuous != 2)
    51b0:	09498763          	beq	s3,s4,523e <main+0x22a>
          exit(1);
    51b4:	4505                	li	a0,1
    51b6:	00000097          	auipc	ra,0x0
    51ba:	31c080e7          	jalr	796(ra) # 54d2 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    51be:	04c1                	add	s1,s1,16
    51c0:	0084b903          	ld	s2,8(s1)
    51c4:	02090463          	beqz	s2,51ec <main+0x1d8>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    51c8:	00098963          	beqz	s3,51da <main+0x1c6>
    51cc:	85ce                	mv	a1,s3
    51ce:	854a                	mv	a0,s2
    51d0:	00000097          	auipc	ra,0x0
    51d4:	0b2080e7          	jalr	178(ra) # 5282 <strcmp>
    51d8:	f17d                	bnez	a0,51be <main+0x1aa>
      if(!run(t->f, t->s))
    51da:	85ca                	mv	a1,s2
    51dc:	6088                	ld	a0,0(s1)
    51de:	00000097          	auipc	ra,0x0
    51e2:	d98080e7          	jalr	-616(ra) # 4f76 <run>
    51e6:	fd61                	bnez	a0,51be <main+0x1aa>
        fail = 1;
    51e8:	8a5a                	mv	s4,s6
    51ea:	bfd1                	j	51be <main+0x1aa>
  if(fail){
    51ec:	ec0a04e3          	beqz	s4,50b4 <main+0xa0>
    printf("SOME TESTS FAILED\n");
    51f0:	00003517          	auipc	a0,0x3
    51f4:	80050513          	add	a0,a0,-2048 # 79f0 <malloc+0x20fe>
    51f8:	00000097          	auipc	ra,0x0
    51fc:	642080e7          	jalr	1602(ra) # 583a <printf>
    exit(1);
    5200:	4505                	li	a0,1
    5202:	00000097          	auipc	ra,0x0
    5206:	2d0080e7          	jalr	720(ra) # 54d2 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    520a:	00003517          	auipc	a0,0x3
    520e:	82e50513          	add	a0,a0,-2002 # 7a38 <malloc+0x2146>
    5212:	00000097          	auipc	ra,0x0
    5216:	628080e7          	jalr	1576(ra) # 583a <printf>
    exit(0);
    521a:	4501                	li	a0,0
    521c:	00000097          	auipc	ra,0x0
    5220:	2b6080e7          	jalr	694(ra) # 54d2 <exit>
        printf("SOME TESTS FAILED\n");
    5224:	8556                	mv	a0,s5
    5226:	00000097          	auipc	ra,0x0
    522a:	614080e7          	jalr	1556(ra) # 583a <printf>
        if(continuous != 2)
    522e:	f74995e3          	bne	s3,s4,5198 <main+0x184>
      int free1 = countfree();
    5232:	00000097          	auipc	ra,0x0
    5236:	c14080e7          	jalr	-1004(ra) # 4e46 <countfree>
      if(free1 < free0){
    523a:	f72544e3          	blt	a0,s2,51a2 <main+0x18e>
      int free0 = countfree();
    523e:	00000097          	auipc	ra,0x0
    5242:	c08080e7          	jalr	-1016(ra) # 4e46 <countfree>
    5246:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5248:	c3843583          	ld	a1,-968(s0)
    524c:	d1fd                	beqz	a1,5232 <main+0x21e>
    524e:	c3040493          	add	s1,s0,-976
        if(!run(t->f, t->s)){
    5252:	6088                	ld	a0,0(s1)
    5254:	00000097          	auipc	ra,0x0
    5258:	d22080e7          	jalr	-734(ra) # 4f76 <run>
    525c:	d561                	beqz	a0,5224 <main+0x210>
      for (struct test *t = tests; t->s != 0; t++) {
    525e:	04c1                	add	s1,s1,16
    5260:	648c                	ld	a1,8(s1)
    5262:	f9e5                	bnez	a1,5252 <main+0x23e>
    5264:	b7f9                	j	5232 <main+0x21e>

0000000000005266 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5266:	1141                	add	sp,sp,-16
    5268:	e422                	sd	s0,8(sp)
    526a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    526c:	87aa                	mv	a5,a0
    526e:	0585                	add	a1,a1,1
    5270:	0785                	add	a5,a5,1
    5272:	fff5c703          	lbu	a4,-1(a1)
    5276:	fee78fa3          	sb	a4,-1(a5)
    527a:	fb75                	bnez	a4,526e <strcpy+0x8>
    ;
  return os;
}
    527c:	6422                	ld	s0,8(sp)
    527e:	0141                	add	sp,sp,16
    5280:	8082                	ret

0000000000005282 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5282:	1141                	add	sp,sp,-16
    5284:	e422                	sd	s0,8(sp)
    5286:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5288:	00054783          	lbu	a5,0(a0)
    528c:	cb91                	beqz	a5,52a0 <strcmp+0x1e>
    528e:	0005c703          	lbu	a4,0(a1)
    5292:	00f71763          	bne	a4,a5,52a0 <strcmp+0x1e>
    p++, q++;
    5296:	0505                	add	a0,a0,1
    5298:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    529a:	00054783          	lbu	a5,0(a0)
    529e:	fbe5                	bnez	a5,528e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    52a0:	0005c503          	lbu	a0,0(a1)
}
    52a4:	40a7853b          	subw	a0,a5,a0
    52a8:	6422                	ld	s0,8(sp)
    52aa:	0141                	add	sp,sp,16
    52ac:	8082                	ret

00000000000052ae <strlen>:

unsigned int
strlen(const char *s)
{
    52ae:	1141                	add	sp,sp,-16
    52b0:	e422                	sd	s0,8(sp)
    52b2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    52b4:	00054783          	lbu	a5,0(a0)
    52b8:	cf91                	beqz	a5,52d4 <strlen+0x26>
    52ba:	0505                	add	a0,a0,1
    52bc:	87aa                	mv	a5,a0
    52be:	86be                	mv	a3,a5
    52c0:	0785                	add	a5,a5,1
    52c2:	fff7c703          	lbu	a4,-1(a5)
    52c6:	ff65                	bnez	a4,52be <strlen+0x10>
    52c8:	40a6853b          	subw	a0,a3,a0
    52cc:	2505                	addw	a0,a0,1
    ;
  return n;
}
    52ce:	6422                	ld	s0,8(sp)
    52d0:	0141                	add	sp,sp,16
    52d2:	8082                	ret
  for(n = 0; s[n]; n++)
    52d4:	4501                	li	a0,0
    52d6:	bfe5                	j	52ce <strlen+0x20>

00000000000052d8 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
    52d8:	1141                	add	sp,sp,-16
    52da:	e422                	sd	s0,8(sp)
    52dc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    52de:	ca19                	beqz	a2,52f4 <memset+0x1c>
    52e0:	87aa                	mv	a5,a0
    52e2:	1602                	sll	a2,a2,0x20
    52e4:	9201                	srl	a2,a2,0x20
    52e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    52ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    52ee:	0785                	add	a5,a5,1
    52f0:	fee79de3          	bne	a5,a4,52ea <memset+0x12>
  }
  return dst;
}
    52f4:	6422                	ld	s0,8(sp)
    52f6:	0141                	add	sp,sp,16
    52f8:	8082                	ret

00000000000052fa <strchr>:

char*
strchr(const char *s, char c)
{
    52fa:	1141                	add	sp,sp,-16
    52fc:	e422                	sd	s0,8(sp)
    52fe:	0800                	add	s0,sp,16
  for(; *s; s++)
    5300:	00054783          	lbu	a5,0(a0)
    5304:	cb99                	beqz	a5,531a <strchr+0x20>
    if(*s == c)
    5306:	00f58763          	beq	a1,a5,5314 <strchr+0x1a>
  for(; *s; s++)
    530a:	0505                	add	a0,a0,1
    530c:	00054783          	lbu	a5,0(a0)
    5310:	fbfd                	bnez	a5,5306 <strchr+0xc>
      return (char*)s;
  return 0;
    5312:	4501                	li	a0,0
}
    5314:	6422                	ld	s0,8(sp)
    5316:	0141                	add	sp,sp,16
    5318:	8082                	ret
  return 0;
    531a:	4501                	li	a0,0
    531c:	bfe5                	j	5314 <strchr+0x1a>

000000000000531e <gets>:

char*
gets(char *buf, int max)
{
    531e:	711d                	add	sp,sp,-96
    5320:	ec86                	sd	ra,88(sp)
    5322:	e8a2                	sd	s0,80(sp)
    5324:	e4a6                	sd	s1,72(sp)
    5326:	e0ca                	sd	s2,64(sp)
    5328:	fc4e                	sd	s3,56(sp)
    532a:	f852                	sd	s4,48(sp)
    532c:	f456                	sd	s5,40(sp)
    532e:	f05a                	sd	s6,32(sp)
    5330:	ec5e                	sd	s7,24(sp)
    5332:	1080                	add	s0,sp,96
    5334:	8baa                	mv	s7,a0
    5336:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5338:	892a                	mv	s2,a0
    533a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    533c:	4aa9                	li	s5,10
    533e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5340:	89a6                	mv	s3,s1
    5342:	2485                	addw	s1,s1,1
    5344:	0344d863          	bge	s1,s4,5374 <gets+0x56>
    cc = read(0, &c, 1);
    5348:	4605                	li	a2,1
    534a:	faf40593          	add	a1,s0,-81
    534e:	4501                	li	a0,0
    5350:	00000097          	auipc	ra,0x0
    5354:	19a080e7          	jalr	410(ra) # 54ea <read>
    if(cc < 1)
    5358:	00a05e63          	blez	a0,5374 <gets+0x56>
    buf[i++] = c;
    535c:	faf44783          	lbu	a5,-81(s0)
    5360:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5364:	01578763          	beq	a5,s5,5372 <gets+0x54>
    5368:	0905                	add	s2,s2,1
    536a:	fd679be3          	bne	a5,s6,5340 <gets+0x22>
  for(i=0; i+1 < max; ){
    536e:	89a6                	mv	s3,s1
    5370:	a011                	j	5374 <gets+0x56>
    5372:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5374:	99de                	add	s3,s3,s7
    5376:	00098023          	sb	zero,0(s3)
  return buf;
}
    537a:	855e                	mv	a0,s7
    537c:	60e6                	ld	ra,88(sp)
    537e:	6446                	ld	s0,80(sp)
    5380:	64a6                	ld	s1,72(sp)
    5382:	6906                	ld	s2,64(sp)
    5384:	79e2                	ld	s3,56(sp)
    5386:	7a42                	ld	s4,48(sp)
    5388:	7aa2                	ld	s5,40(sp)
    538a:	7b02                	ld	s6,32(sp)
    538c:	6be2                	ld	s7,24(sp)
    538e:	6125                	add	sp,sp,96
    5390:	8082                	ret

0000000000005392 <stat>:

int
stat(const char *n, struct stat *st)
{
    5392:	1101                	add	sp,sp,-32
    5394:	ec06                	sd	ra,24(sp)
    5396:	e822                	sd	s0,16(sp)
    5398:	e426                	sd	s1,8(sp)
    539a:	e04a                	sd	s2,0(sp)
    539c:	1000                	add	s0,sp,32
    539e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    53a0:	4581                	li	a1,0
    53a2:	00000097          	auipc	ra,0x0
    53a6:	170080e7          	jalr	368(ra) # 5512 <open>
  if(fd < 0)
    53aa:	02054563          	bltz	a0,53d4 <stat+0x42>
    53ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    53b0:	85ca                	mv	a1,s2
    53b2:	00000097          	auipc	ra,0x0
    53b6:	178080e7          	jalr	376(ra) # 552a <fstat>
    53ba:	892a                	mv	s2,a0
  close(fd);
    53bc:	8526                	mv	a0,s1
    53be:	00000097          	auipc	ra,0x0
    53c2:	13c080e7          	jalr	316(ra) # 54fa <close>
  return r;
}
    53c6:	854a                	mv	a0,s2
    53c8:	60e2                	ld	ra,24(sp)
    53ca:	6442                	ld	s0,16(sp)
    53cc:	64a2                	ld	s1,8(sp)
    53ce:	6902                	ld	s2,0(sp)
    53d0:	6105                	add	sp,sp,32
    53d2:	8082                	ret
    return -1;
    53d4:	597d                	li	s2,-1
    53d6:	bfc5                	j	53c6 <stat+0x34>

00000000000053d8 <atoi>:

int
atoi(const char *s)
{
    53d8:	1141                	add	sp,sp,-16
    53da:	e422                	sd	s0,8(sp)
    53dc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    53de:	00054683          	lbu	a3,0(a0)
    53e2:	fd06879b          	addw	a5,a3,-48
    53e6:	0ff7f793          	zext.b	a5,a5
    53ea:	4625                	li	a2,9
    53ec:	02f66863          	bltu	a2,a5,541c <atoi+0x44>
    53f0:	872a                	mv	a4,a0
  n = 0;
    53f2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    53f4:	0705                	add	a4,a4,1
    53f6:	0025179b          	sllw	a5,a0,0x2
    53fa:	9fa9                	addw	a5,a5,a0
    53fc:	0017979b          	sllw	a5,a5,0x1
    5400:	9fb5                	addw	a5,a5,a3
    5402:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5406:	00074683          	lbu	a3,0(a4)
    540a:	fd06879b          	addw	a5,a3,-48
    540e:	0ff7f793          	zext.b	a5,a5
    5412:	fef671e3          	bgeu	a2,a5,53f4 <atoi+0x1c>
  return n;
}
    5416:	6422                	ld	s0,8(sp)
    5418:	0141                	add	sp,sp,16
    541a:	8082                	ret
  n = 0;
    541c:	4501                	li	a0,0
    541e:	bfe5                	j	5416 <atoi+0x3e>

0000000000005420 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5420:	1141                	add	sp,sp,-16
    5422:	e422                	sd	s0,8(sp)
    5424:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5426:	02b57463          	bgeu	a0,a1,544e <memmove+0x2e>
    while(n-- > 0)
    542a:	00c05f63          	blez	a2,5448 <memmove+0x28>
    542e:	1602                	sll	a2,a2,0x20
    5430:	9201                	srl	a2,a2,0x20
    5432:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5436:	872a                	mv	a4,a0
      *dst++ = *src++;
    5438:	0585                	add	a1,a1,1
    543a:	0705                	add	a4,a4,1
    543c:	fff5c683          	lbu	a3,-1(a1)
    5440:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5444:	fee79ae3          	bne	a5,a4,5438 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5448:	6422                	ld	s0,8(sp)
    544a:	0141                	add	sp,sp,16
    544c:	8082                	ret
    dst += n;
    544e:	00c50733          	add	a4,a0,a2
    src += n;
    5452:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5454:	fec05ae3          	blez	a2,5448 <memmove+0x28>
    5458:	fff6079b          	addw	a5,a2,-1 # 2fff <subdir+0x1d1>
    545c:	1782                	sll	a5,a5,0x20
    545e:	9381                	srl	a5,a5,0x20
    5460:	fff7c793          	not	a5,a5
    5464:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5466:	15fd                	add	a1,a1,-1
    5468:	177d                	add	a4,a4,-1
    546a:	0005c683          	lbu	a3,0(a1)
    546e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5472:	fee79ae3          	bne	a5,a4,5466 <memmove+0x46>
    5476:	bfc9                	j	5448 <memmove+0x28>

0000000000005478 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
    5478:	1141                	add	sp,sp,-16
    547a:	e422                	sd	s0,8(sp)
    547c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    547e:	ca05                	beqz	a2,54ae <memcmp+0x36>
    5480:	fff6069b          	addw	a3,a2,-1
    5484:	1682                	sll	a3,a3,0x20
    5486:	9281                	srl	a3,a3,0x20
    5488:	0685                	add	a3,a3,1
    548a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    548c:	00054783          	lbu	a5,0(a0)
    5490:	0005c703          	lbu	a4,0(a1)
    5494:	00e79863          	bne	a5,a4,54a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5498:	0505                	add	a0,a0,1
    p2++;
    549a:	0585                	add	a1,a1,1
  while (n-- > 0) {
    549c:	fed518e3          	bne	a0,a3,548c <memcmp+0x14>
  }
  return 0;
    54a0:	4501                	li	a0,0
    54a2:	a019                	j	54a8 <memcmp+0x30>
      return *p1 - *p2;
    54a4:	40e7853b          	subw	a0,a5,a4
}
    54a8:	6422                	ld	s0,8(sp)
    54aa:	0141                	add	sp,sp,16
    54ac:	8082                	ret
  return 0;
    54ae:	4501                	li	a0,0
    54b0:	bfe5                	j	54a8 <memcmp+0x30>

00000000000054b2 <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
    54b2:	1141                	add	sp,sp,-16
    54b4:	e406                	sd	ra,8(sp)
    54b6:	e022                	sd	s0,0(sp)
    54b8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    54ba:	00000097          	auipc	ra,0x0
    54be:	f66080e7          	jalr	-154(ra) # 5420 <memmove>
}
    54c2:	60a2                	ld	ra,8(sp)
    54c4:	6402                	ld	s0,0(sp)
    54c6:	0141                	add	sp,sp,16
    54c8:	8082                	ret

00000000000054ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    54ca:	4885                	li	a7,1
 ecall
    54cc:	00000073          	ecall
 ret
    54d0:	8082                	ret

00000000000054d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    54d2:	4889                	li	a7,2
 ecall
    54d4:	00000073          	ecall
 ret
    54d8:	8082                	ret

00000000000054da <wait>:
.global wait
wait:
 li a7, SYS_wait
    54da:	488d                	li	a7,3
 ecall
    54dc:	00000073          	ecall
 ret
    54e0:	8082                	ret

00000000000054e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    54e2:	4891                	li	a7,4
 ecall
    54e4:	00000073          	ecall
 ret
    54e8:	8082                	ret

00000000000054ea <read>:
.global read
read:
 li a7, SYS_read
    54ea:	4895                	li	a7,5
 ecall
    54ec:	00000073          	ecall
 ret
    54f0:	8082                	ret

00000000000054f2 <write>:
.global write
write:
 li a7, SYS_write
    54f2:	48c1                	li	a7,16
 ecall
    54f4:	00000073          	ecall
 ret
    54f8:	8082                	ret

00000000000054fa <close>:
.global close
close:
 li a7, SYS_close
    54fa:	48d5                	li	a7,21
 ecall
    54fc:	00000073          	ecall
 ret
    5500:	8082                	ret

0000000000005502 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5502:	4899                	li	a7,6
 ecall
    5504:	00000073          	ecall
 ret
    5508:	8082                	ret

000000000000550a <exec>:
.global exec
exec:
 li a7, SYS_exec
    550a:	489d                	li	a7,7
 ecall
    550c:	00000073          	ecall
 ret
    5510:	8082                	ret

0000000000005512 <open>:
.global open
open:
 li a7, SYS_open
    5512:	48bd                	li	a7,15
 ecall
    5514:	00000073          	ecall
 ret
    5518:	8082                	ret

000000000000551a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    551a:	48c5                	li	a7,17
 ecall
    551c:	00000073          	ecall
 ret
    5520:	8082                	ret

0000000000005522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5522:	48c9                	li	a7,18
 ecall
    5524:	00000073          	ecall
 ret
    5528:	8082                	ret

000000000000552a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    552a:	48a1                	li	a7,8
 ecall
    552c:	00000073          	ecall
 ret
    5530:	8082                	ret

0000000000005532 <link>:
.global link
link:
 li a7, SYS_link
    5532:	48cd                	li	a7,19
 ecall
    5534:	00000073          	ecall
 ret
    5538:	8082                	ret

000000000000553a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    553a:	48d1                	li	a7,20
 ecall
    553c:	00000073          	ecall
 ret
    5540:	8082                	ret

0000000000005542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5542:	48a5                	li	a7,9
 ecall
    5544:	00000073          	ecall
 ret
    5548:	8082                	ret

000000000000554a <dup>:
.global dup
dup:
 li a7, SYS_dup
    554a:	48a9                	li	a7,10
 ecall
    554c:	00000073          	ecall
 ret
    5550:	8082                	ret

0000000000005552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5552:	48ad                	li	a7,11
 ecall
    5554:	00000073          	ecall
 ret
    5558:	8082                	ret

000000000000555a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    555a:	48b1                	li	a7,12
 ecall
    555c:	00000073          	ecall
 ret
    5560:	8082                	ret

0000000000005562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5562:	48b5                	li	a7,13
 ecall
    5564:	00000073          	ecall
 ret
    5568:	8082                	ret

000000000000556a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    556a:	48b9                	li	a7,14
 ecall
    556c:	00000073          	ecall
 ret
    5570:	8082                	ret

0000000000005572 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5572:	1101                	add	sp,sp,-32
    5574:	ec06                	sd	ra,24(sp)
    5576:	e822                	sd	s0,16(sp)
    5578:	1000                	add	s0,sp,32
    557a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    557e:	4605                	li	a2,1
    5580:	fef40593          	add	a1,s0,-17
    5584:	00000097          	auipc	ra,0x0
    5588:	f6e080e7          	jalr	-146(ra) # 54f2 <write>
}
    558c:	60e2                	ld	ra,24(sp)
    558e:	6442                	ld	s0,16(sp)
    5590:	6105                	add	sp,sp,32
    5592:	8082                	ret

0000000000005594 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5594:	7139                	add	sp,sp,-64
    5596:	fc06                	sd	ra,56(sp)
    5598:	f822                	sd	s0,48(sp)
    559a:	f426                	sd	s1,40(sp)
    559c:	f04a                	sd	s2,32(sp)
    559e:	ec4e                	sd	s3,24(sp)
    55a0:	0080                	add	s0,sp,64
    55a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    55a4:	c299                	beqz	a3,55aa <printint+0x16>
    55a6:	0805c963          	bltz	a1,5638 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    55aa:	2581                	sext.w	a1,a1
  neg = 0;
    55ac:	4881                	li	a7,0
    55ae:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    55b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    55b4:	2601                	sext.w	a2,a2
    55b6:	00003517          	auipc	a0,0x3
    55ba:	b8a50513          	add	a0,a0,-1142 # 8140 <digits>
    55be:	883a                	mv	a6,a4
    55c0:	2705                	addw	a4,a4,1
    55c2:	02c5f7bb          	remuw	a5,a1,a2
    55c6:	1782                	sll	a5,a5,0x20
    55c8:	9381                	srl	a5,a5,0x20
    55ca:	97aa                	add	a5,a5,a0
    55cc:	0007c783          	lbu	a5,0(a5)
    55d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    55d4:	0005879b          	sext.w	a5,a1
    55d8:	02c5d5bb          	divuw	a1,a1,a2
    55dc:	0685                	add	a3,a3,1
    55de:	fec7f0e3          	bgeu	a5,a2,55be <printint+0x2a>
  if(neg)
    55e2:	00088c63          	beqz	a7,55fa <printint+0x66>
    buf[i++] = '-';
    55e6:	fd070793          	add	a5,a4,-48
    55ea:	00878733          	add	a4,a5,s0
    55ee:	02d00793          	li	a5,45
    55f2:	fef70823          	sb	a5,-16(a4)
    55f6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    55fa:	02e05863          	blez	a4,562a <printint+0x96>
    55fe:	fc040793          	add	a5,s0,-64
    5602:	00e78933          	add	s2,a5,a4
    5606:	fff78993          	add	s3,a5,-1
    560a:	99ba                	add	s3,s3,a4
    560c:	377d                	addw	a4,a4,-1
    560e:	1702                	sll	a4,a4,0x20
    5610:	9301                	srl	a4,a4,0x20
    5612:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5616:	fff94583          	lbu	a1,-1(s2)
    561a:	8526                	mv	a0,s1
    561c:	00000097          	auipc	ra,0x0
    5620:	f56080e7          	jalr	-170(ra) # 5572 <putc>
  while(--i >= 0)
    5624:	197d                	add	s2,s2,-1
    5626:	ff3918e3          	bne	s2,s3,5616 <printint+0x82>
}
    562a:	70e2                	ld	ra,56(sp)
    562c:	7442                	ld	s0,48(sp)
    562e:	74a2                	ld	s1,40(sp)
    5630:	7902                	ld	s2,32(sp)
    5632:	69e2                	ld	s3,24(sp)
    5634:	6121                	add	sp,sp,64
    5636:	8082                	ret
    x = -xx;
    5638:	40b005bb          	negw	a1,a1
    neg = 1;
    563c:	4885                	li	a7,1
    x = -xx;
    563e:	bf85                	j	55ae <printint+0x1a>

0000000000005640 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5640:	715d                	add	sp,sp,-80
    5642:	e486                	sd	ra,72(sp)
    5644:	e0a2                	sd	s0,64(sp)
    5646:	fc26                	sd	s1,56(sp)
    5648:	f84a                	sd	s2,48(sp)
    564a:	f44e                	sd	s3,40(sp)
    564c:	f052                	sd	s4,32(sp)
    564e:	ec56                	sd	s5,24(sp)
    5650:	e85a                	sd	s6,16(sp)
    5652:	e45e                	sd	s7,8(sp)
    5654:	e062                	sd	s8,0(sp)
    5656:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5658:	0005c903          	lbu	s2,0(a1)
    565c:	18090c63          	beqz	s2,57f4 <vprintf+0x1b4>
    5660:	8aaa                	mv	s5,a0
    5662:	8bb2                	mv	s7,a2
    5664:	00158493          	add	s1,a1,1
  state = 0;
    5668:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    566a:	02500a13          	li	s4,37
    566e:	4b55                	li	s6,21
    5670:	a839                	j	568e <vprintf+0x4e>
        putc(fd, c);
    5672:	85ca                	mv	a1,s2
    5674:	8556                	mv	a0,s5
    5676:	00000097          	auipc	ra,0x0
    567a:	efc080e7          	jalr	-260(ra) # 5572 <putc>
    567e:	a019                	j	5684 <vprintf+0x44>
    } else if(state == '%'){
    5680:	01498d63          	beq	s3,s4,569a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5684:	0485                	add	s1,s1,1
    5686:	fff4c903          	lbu	s2,-1(s1)
    568a:	16090563          	beqz	s2,57f4 <vprintf+0x1b4>
    if(state == 0){
    568e:	fe0999e3          	bnez	s3,5680 <vprintf+0x40>
      if(c == '%'){
    5692:	ff4910e3          	bne	s2,s4,5672 <vprintf+0x32>
        state = '%';
    5696:	89d2                	mv	s3,s4
    5698:	b7f5                	j	5684 <vprintf+0x44>
      if(c == 'd'){
    569a:	13490263          	beq	s2,s4,57be <vprintf+0x17e>
    569e:	f9d9079b          	addw	a5,s2,-99
    56a2:	0ff7f793          	zext.b	a5,a5
    56a6:	12fb6563          	bltu	s6,a5,57d0 <vprintf+0x190>
    56aa:	f9d9079b          	addw	a5,s2,-99
    56ae:	0ff7f713          	zext.b	a4,a5
    56b2:	10eb6f63          	bltu	s6,a4,57d0 <vprintf+0x190>
    56b6:	00271793          	sll	a5,a4,0x2
    56ba:	00003717          	auipc	a4,0x3
    56be:	a2e70713          	add	a4,a4,-1490 # 80e8 <malloc+0x27f6>
    56c2:	97ba                	add	a5,a5,a4
    56c4:	439c                	lw	a5,0(a5)
    56c6:	97ba                	add	a5,a5,a4
    56c8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    56ca:	008b8913          	add	s2,s7,8
    56ce:	4685                	li	a3,1
    56d0:	4629                	li	a2,10
    56d2:	000ba583          	lw	a1,0(s7)
    56d6:	8556                	mv	a0,s5
    56d8:	00000097          	auipc	ra,0x0
    56dc:	ebc080e7          	jalr	-324(ra) # 5594 <printint>
    56e0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    56e2:	4981                	li	s3,0
    56e4:	b745                	j	5684 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    56e6:	008b8913          	add	s2,s7,8
    56ea:	4681                	li	a3,0
    56ec:	4629                	li	a2,10
    56ee:	000ba583          	lw	a1,0(s7)
    56f2:	8556                	mv	a0,s5
    56f4:	00000097          	auipc	ra,0x0
    56f8:	ea0080e7          	jalr	-352(ra) # 5594 <printint>
    56fc:	8bca                	mv	s7,s2
      state = 0;
    56fe:	4981                	li	s3,0
    5700:	b751                	j	5684 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5702:	008b8913          	add	s2,s7,8
    5706:	4681                	li	a3,0
    5708:	4641                	li	a2,16
    570a:	000ba583          	lw	a1,0(s7)
    570e:	8556                	mv	a0,s5
    5710:	00000097          	auipc	ra,0x0
    5714:	e84080e7          	jalr	-380(ra) # 5594 <printint>
    5718:	8bca                	mv	s7,s2
      state = 0;
    571a:	4981                	li	s3,0
    571c:	b7a5                	j	5684 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    571e:	008b8c13          	add	s8,s7,8
    5722:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5726:	03000593          	li	a1,48
    572a:	8556                	mv	a0,s5
    572c:	00000097          	auipc	ra,0x0
    5730:	e46080e7          	jalr	-442(ra) # 5572 <putc>
  putc(fd, 'x');
    5734:	07800593          	li	a1,120
    5738:	8556                	mv	a0,s5
    573a:	00000097          	auipc	ra,0x0
    573e:	e38080e7          	jalr	-456(ra) # 5572 <putc>
    5742:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5744:	00003b97          	auipc	s7,0x3
    5748:	9fcb8b93          	add	s7,s7,-1540 # 8140 <digits>
    574c:	03c9d793          	srl	a5,s3,0x3c
    5750:	97de                	add	a5,a5,s7
    5752:	0007c583          	lbu	a1,0(a5)
    5756:	8556                	mv	a0,s5
    5758:	00000097          	auipc	ra,0x0
    575c:	e1a080e7          	jalr	-486(ra) # 5572 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5760:	0992                	sll	s3,s3,0x4
    5762:	397d                	addw	s2,s2,-1
    5764:	fe0914e3          	bnez	s2,574c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5768:	8be2                	mv	s7,s8
      state = 0;
    576a:	4981                	li	s3,0
    576c:	bf21                	j	5684 <vprintf+0x44>
        s = va_arg(ap, char*);
    576e:	008b8993          	add	s3,s7,8
    5772:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5776:	02090163          	beqz	s2,5798 <vprintf+0x158>
        while(*s != 0){
    577a:	00094583          	lbu	a1,0(s2)
    577e:	c9a5                	beqz	a1,57ee <vprintf+0x1ae>
          putc(fd, *s);
    5780:	8556                	mv	a0,s5
    5782:	00000097          	auipc	ra,0x0
    5786:	df0080e7          	jalr	-528(ra) # 5572 <putc>
          s++;
    578a:	0905                	add	s2,s2,1
        while(*s != 0){
    578c:	00094583          	lbu	a1,0(s2)
    5790:	f9e5                	bnez	a1,5780 <vprintf+0x140>
        s = va_arg(ap, char*);
    5792:	8bce                	mv	s7,s3
      state = 0;
    5794:	4981                	li	s3,0
    5796:	b5fd                	j	5684 <vprintf+0x44>
          s = "(null)";
    5798:	00003917          	auipc	s2,0x3
    579c:	94890913          	add	s2,s2,-1720 # 80e0 <malloc+0x27ee>
        while(*s != 0){
    57a0:	02800593          	li	a1,40
    57a4:	bff1                	j	5780 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    57a6:	008b8913          	add	s2,s7,8
    57aa:	000bc583          	lbu	a1,0(s7)
    57ae:	8556                	mv	a0,s5
    57b0:	00000097          	auipc	ra,0x0
    57b4:	dc2080e7          	jalr	-574(ra) # 5572 <putc>
    57b8:	8bca                	mv	s7,s2
      state = 0;
    57ba:	4981                	li	s3,0
    57bc:	b5e1                	j	5684 <vprintf+0x44>
        putc(fd, c);
    57be:	02500593          	li	a1,37
    57c2:	8556                	mv	a0,s5
    57c4:	00000097          	auipc	ra,0x0
    57c8:	dae080e7          	jalr	-594(ra) # 5572 <putc>
      state = 0;
    57cc:	4981                	li	s3,0
    57ce:	bd5d                	j	5684 <vprintf+0x44>
        putc(fd, '%');
    57d0:	02500593          	li	a1,37
    57d4:	8556                	mv	a0,s5
    57d6:	00000097          	auipc	ra,0x0
    57da:	d9c080e7          	jalr	-612(ra) # 5572 <putc>
        putc(fd, c);
    57de:	85ca                	mv	a1,s2
    57e0:	8556                	mv	a0,s5
    57e2:	00000097          	auipc	ra,0x0
    57e6:	d90080e7          	jalr	-624(ra) # 5572 <putc>
      state = 0;
    57ea:	4981                	li	s3,0
    57ec:	bd61                	j	5684 <vprintf+0x44>
        s = va_arg(ap, char*);
    57ee:	8bce                	mv	s7,s3
      state = 0;
    57f0:	4981                	li	s3,0
    57f2:	bd49                	j	5684 <vprintf+0x44>
    }
  }
}
    57f4:	60a6                	ld	ra,72(sp)
    57f6:	6406                	ld	s0,64(sp)
    57f8:	74e2                	ld	s1,56(sp)
    57fa:	7942                	ld	s2,48(sp)
    57fc:	79a2                	ld	s3,40(sp)
    57fe:	7a02                	ld	s4,32(sp)
    5800:	6ae2                	ld	s5,24(sp)
    5802:	6b42                	ld	s6,16(sp)
    5804:	6ba2                	ld	s7,8(sp)
    5806:	6c02                	ld	s8,0(sp)
    5808:	6161                	add	sp,sp,80
    580a:	8082                	ret

000000000000580c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    580c:	715d                	add	sp,sp,-80
    580e:	ec06                	sd	ra,24(sp)
    5810:	e822                	sd	s0,16(sp)
    5812:	1000                	add	s0,sp,32
    5814:	e010                	sd	a2,0(s0)
    5816:	e414                	sd	a3,8(s0)
    5818:	e818                	sd	a4,16(s0)
    581a:	ec1c                	sd	a5,24(s0)
    581c:	03043023          	sd	a6,32(s0)
    5820:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5824:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5828:	8622                	mv	a2,s0
    582a:	00000097          	auipc	ra,0x0
    582e:	e16080e7          	jalr	-490(ra) # 5640 <vprintf>
}
    5832:	60e2                	ld	ra,24(sp)
    5834:	6442                	ld	s0,16(sp)
    5836:	6161                	add	sp,sp,80
    5838:	8082                	ret

000000000000583a <printf>:

void
printf(const char *fmt, ...)
{
    583a:	711d                	add	sp,sp,-96
    583c:	ec06                	sd	ra,24(sp)
    583e:	e822                	sd	s0,16(sp)
    5840:	1000                	add	s0,sp,32
    5842:	e40c                	sd	a1,8(s0)
    5844:	e810                	sd	a2,16(s0)
    5846:	ec14                	sd	a3,24(s0)
    5848:	f018                	sd	a4,32(s0)
    584a:	f41c                	sd	a5,40(s0)
    584c:	03043823          	sd	a6,48(s0)
    5850:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5854:	00840613          	add	a2,s0,8
    5858:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    585c:	85aa                	mv	a1,a0
    585e:	4505                	li	a0,1
    5860:	00000097          	auipc	ra,0x0
    5864:	de0080e7          	jalr	-544(ra) # 5640 <vprintf>
}
    5868:	60e2                	ld	ra,24(sp)
    586a:	6442                	ld	s0,16(sp)
    586c:	6125                	add	sp,sp,96
    586e:	8082                	ret

0000000000005870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5870:	1141                	add	sp,sp,-16
    5872:	e422                	sd	s0,8(sp)
    5874:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5876:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    587a:	00003797          	auipc	a5,0x3
    587e:	8f67b783          	ld	a5,-1802(a5) # 8170 <freep>
    5882:	a02d                	j	58ac <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5884:	4618                	lw	a4,8(a2)
    5886:	9f2d                	addw	a4,a4,a1
    5888:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    588c:	6398                	ld	a4,0(a5)
    588e:	6310                	ld	a2,0(a4)
    5890:	a83d                	j	58ce <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5892:	ff852703          	lw	a4,-8(a0)
    5896:	9f31                	addw	a4,a4,a2
    5898:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    589a:	ff053683          	ld	a3,-16(a0)
    589e:	a091                	j	58e2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58a0:	6398                	ld	a4,0(a5)
    58a2:	00e7e463          	bltu	a5,a4,58aa <free+0x3a>
    58a6:	00e6ea63          	bltu	a3,a4,58ba <free+0x4a>
{
    58aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    58ac:	fed7fae3          	bgeu	a5,a3,58a0 <free+0x30>
    58b0:	6398                	ld	a4,0(a5)
    58b2:	00e6e463          	bltu	a3,a4,58ba <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58b6:	fee7eae3          	bltu	a5,a4,58aa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    58ba:	ff852583          	lw	a1,-8(a0)
    58be:	6390                	ld	a2,0(a5)
    58c0:	02059813          	sll	a6,a1,0x20
    58c4:	01c85713          	srl	a4,a6,0x1c
    58c8:	9736                	add	a4,a4,a3
    58ca:	fae60de3          	beq	a2,a4,5884 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    58ce:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    58d2:	4790                	lw	a2,8(a5)
    58d4:	02061593          	sll	a1,a2,0x20
    58d8:	01c5d713          	srl	a4,a1,0x1c
    58dc:	973e                	add	a4,a4,a5
    58de:	fae68ae3          	beq	a3,a4,5892 <free+0x22>
    p->s.ptr = bp->s.ptr;
    58e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    58e4:	00003717          	auipc	a4,0x3
    58e8:	88f73623          	sd	a5,-1908(a4) # 8170 <freep>
}
    58ec:	6422                	ld	s0,8(sp)
    58ee:	0141                	add	sp,sp,16
    58f0:	8082                	ret

00000000000058f2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    58f2:	7139                	add	sp,sp,-64
    58f4:	fc06                	sd	ra,56(sp)
    58f6:	f822                	sd	s0,48(sp)
    58f8:	f426                	sd	s1,40(sp)
    58fa:	f04a                	sd	s2,32(sp)
    58fc:	ec4e                	sd	s3,24(sp)
    58fe:	e852                	sd	s4,16(sp)
    5900:	e456                	sd	s5,8(sp)
    5902:	e05a                	sd	s6,0(sp)
    5904:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5906:	02051493          	sll	s1,a0,0x20
    590a:	9081                	srl	s1,s1,0x20
    590c:	04bd                	add	s1,s1,15
    590e:	8091                	srl	s1,s1,0x4
    5910:	0014899b          	addw	s3,s1,1
    5914:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    5916:	00003517          	auipc	a0,0x3
    591a:	85a53503          	ld	a0,-1958(a0) # 8170 <freep>
    591e:	c515                	beqz	a0,594a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5922:	4798                	lw	a4,8(a5)
    5924:	02977f63          	bgeu	a4,s1,5962 <malloc+0x70>
  if(nu < 4096)
    5928:	8a4e                	mv	s4,s3
    592a:	0009871b          	sext.w	a4,s3
    592e:	6685                	lui	a3,0x1
    5930:	00d77363          	bgeu	a4,a3,5936 <malloc+0x44>
    5934:	6a05                	lui	s4,0x1
    5936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    593a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    593e:	00003917          	auipc	s2,0x3
    5942:	83290913          	add	s2,s2,-1998 # 8170 <freep>
  if(p == (char*)-1)
    5946:	5afd                	li	s5,-1
    5948:	a895                	j	59bc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    594a:	00009797          	auipc	a5,0x9
    594e:	04678793          	add	a5,a5,70 # e990 <base>
    5952:	00003717          	auipc	a4,0x3
    5956:	80f73f23          	sd	a5,-2018(a4) # 8170 <freep>
    595a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    595c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5960:	b7e1                	j	5928 <malloc+0x36>
      if(p->s.size == nunits)
    5962:	02e48c63          	beq	s1,a4,599a <malloc+0xa8>
        p->s.size -= nunits;
    5966:	4137073b          	subw	a4,a4,s3
    596a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    596c:	02071693          	sll	a3,a4,0x20
    5970:	01c6d713          	srl	a4,a3,0x1c
    5974:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5976:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    597a:	00002717          	auipc	a4,0x2
    597e:	7ea73b23          	sd	a0,2038(a4) # 8170 <freep>
      return (void*)(p + 1);
    5982:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5986:	70e2                	ld	ra,56(sp)
    5988:	7442                	ld	s0,48(sp)
    598a:	74a2                	ld	s1,40(sp)
    598c:	7902                	ld	s2,32(sp)
    598e:	69e2                	ld	s3,24(sp)
    5990:	6a42                	ld	s4,16(sp)
    5992:	6aa2                	ld	s5,8(sp)
    5994:	6b02                	ld	s6,0(sp)
    5996:	6121                	add	sp,sp,64
    5998:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    599a:	6398                	ld	a4,0(a5)
    599c:	e118                	sd	a4,0(a0)
    599e:	bff1                	j	597a <malloc+0x88>
  hp->s.size = nu;
    59a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    59a4:	0541                	add	a0,a0,16
    59a6:	00000097          	auipc	ra,0x0
    59aa:	eca080e7          	jalr	-310(ra) # 5870 <free>
  return freep;
    59ae:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    59b2:	d971                	beqz	a0,5986 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    59b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    59b6:	4798                	lw	a4,8(a5)
    59b8:	fa9775e3          	bgeu	a4,s1,5962 <malloc+0x70>
    if(p == freep)
    59bc:	00093703          	ld	a4,0(s2)
    59c0:	853e                	mv	a0,a5
    59c2:	fef719e3          	bne	a4,a5,59b4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    59c6:	8552                	mv	a0,s4
    59c8:	00000097          	auipc	ra,0x0
    59cc:	b92080e7          	jalr	-1134(ra) # 555a <sbrk>
  if(p == (char*)-1)
    59d0:	fd5518e3          	bne	a0,s5,59a0 <malloc+0xae>
        return 0;
    59d4:	4501                	li	a0,0
    59d6:	bf45                	j	5986 <malloc+0x94>
