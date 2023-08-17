
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
      14:	626080e7          	jalr	1574(ra) # 5636 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	614080e7          	jalr	1556(ra) # 5636 <open>
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
      42:	ac250513          	add	a0,a0,-1342 # 5b00 <malloc+0xea>
      46:	00006097          	auipc	ra,0x6
      4a:	918080e7          	jalr	-1768(ra) # 595e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	5a6080e7          	jalr	1446(ra) # 55f6 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	36078793          	add	a5,a5,864 # 93b8 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	a6868693          	add	a3,a3,-1432 # bac8 <buf>
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
      84:	aa050513          	add	a0,a0,-1376 # 5b20 <malloc+0x10a>
      88:	00006097          	auipc	ra,0x6
      8c:	8d6080e7          	jalr	-1834(ra) # 595e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	564080e7          	jalr	1380(ra) # 55f6 <exit>

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
      ac:	a9050513          	add	a0,a0,-1392 # 5b38 <malloc+0x122>
      b0:	00005097          	auipc	ra,0x5
      b4:	586080e7          	jalr	1414(ra) # 5636 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	562080e7          	jalr	1378(ra) # 561e <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	a9250513          	add	a0,a0,-1390 # 5b58 <malloc+0x142>
      ce:	00005097          	auipc	ra,0x5
      d2:	568080e7          	jalr	1384(ra) # 5636 <open>
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
      ea:	a5a50513          	add	a0,a0,-1446 # 5b40 <malloc+0x12a>
      ee:	00006097          	auipc	ra,0x6
      f2:	870080e7          	jalr	-1936(ra) # 595e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	4fe080e7          	jalr	1278(ra) # 55f6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	a6650513          	add	a0,a0,-1434 # 5b68 <malloc+0x152>
     10a:	00006097          	auipc	ra,0x6
     10e:	854080e7          	jalr	-1964(ra) # 595e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	4e2080e7          	jalr	1250(ra) # 55f6 <exit>

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
     130:	a6450513          	add	a0,a0,-1436 # 5b90 <malloc+0x17a>
     134:	00005097          	auipc	ra,0x5
     138:	512080e7          	jalr	1298(ra) # 5646 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	a5050513          	add	a0,a0,-1456 # 5b90 <malloc+0x17a>
     148:	00005097          	auipc	ra,0x5
     14c:	4ee080e7          	jalr	1262(ra) # 5636 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	a4c58593          	add	a1,a1,-1460 # 5ba0 <malloc+0x18a>
     15c:	00005097          	auipc	ra,0x5
     160:	4ba080e7          	jalr	1210(ra) # 5616 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	a2850513          	add	a0,a0,-1496 # 5b90 <malloc+0x17a>
     170:	00005097          	auipc	ra,0x5
     174:	4c6080e7          	jalr	1222(ra) # 5636 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	a2c58593          	add	a1,a1,-1492 # 5ba8 <malloc+0x192>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	490080e7          	jalr	1168(ra) # 5616 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	9fc50513          	add	a0,a0,-1540 # 5b90 <malloc+0x17a>
     19c:	00005097          	auipc	ra,0x5
     1a0:	4aa080e7          	jalr	1194(ra) # 5646 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	478080e7          	jalr	1144(ra) # 561e <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	46e080e7          	jalr	1134(ra) # 561e <close>
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
     1ce:	9e650513          	add	a0,a0,-1562 # 5bb0 <malloc+0x19a>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	78c080e7          	jalr	1932(ra) # 595e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	41a080e7          	jalr	1050(ra) # 55f6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	426080e7          	jalr	1062(ra) # 5636 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	406080e7          	jalr	1030(ra) # 561e <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	400080e7          	jalr	1024(ra) # 5646 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	95c50513          	add	a0,a0,-1700 # 5bd8 <malloc+0x1c2>
     284:	00005097          	auipc	ra,0x5
     288:	3c2080e7          	jalr	962(ra) # 5646 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	948a8a93          	add	s5,s5,-1720 # 5bd8 <malloc+0x1c2>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	830a0a13          	add	s4,s4,-2000 # bac8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <subdir+0x179>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	38a080e7          	jalr	906(ra) # 5636 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	358080e7          	jalr	856(ra) # 5616 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	344080e7          	jalr	836(ra) # 5616 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	33e080e7          	jalr	830(ra) # 561e <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	35c080e7          	jalr	860(ra) # 5646 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	8d650513          	add	a0,a0,-1834 # 5be8 <malloc+0x1d2>
     31a:	00005097          	auipc	ra,0x5
     31e:	644080e7          	jalr	1604(ra) # 595e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	2d2080e7          	jalr	722(ra) # 55f6 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	8d450513          	add	a0,a0,-1836 # 5c08 <malloc+0x1f2>
     33c:	00005097          	auipc	ra,0x5
     340:	622080e7          	jalr	1570(ra) # 595e <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	2b0080e7          	jalr	688(ra) # 55f6 <exit>

000000000000034e <copyin>:
{
     34e:	715d                	add	sp,sp,-80
     350:	e486                	sd	ra,72(sp)
     352:	e0a2                	sd	s0,64(sp)
     354:	fc26                	sd	s1,56(sp)
     356:	f84a                	sd	s2,48(sp)
     358:	f44e                	sd	s3,40(sp)
     35a:	f052                	sd	s4,32(sp)
     35c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     35e:	4785                	li	a5,1
     360:	07fe                	sll	a5,a5,0x1f
     362:	fcf43023          	sd	a5,-64(s0)
     366:	57fd                	li	a5,-1
     368:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     370:	00006a17          	auipc	s4,0x6
     374:	8b0a0a13          	add	s4,s4,-1872 # 5c20 <malloc+0x20a>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	2b4080e7          	jalr	692(ra) # 5636 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	282080e7          	jalr	642(ra) # 5616 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	27c080e7          	jalr	636(ra) # 561e <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	29a080e7          	jalr	666(ra) # 5646 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	25c080e7          	jalr	604(ra) # 5616 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	add	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	23c080e7          	jalr	572(ra) # 5606 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	238080e7          	jalr	568(ra) # 5616 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	230080e7          	jalr	560(ra) # 561e <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	224080e7          	jalr	548(ra) # 561e <close>
  for(int ai = 0; ai < 2; ai++){
     402:	0921                	add	s2,s2,8
     404:	fd040793          	add	a5,s0,-48
     408:	f6f918e3          	bne	s2,a5,378 <copyin+0x2a>
}
     40c:	60a6                	ld	ra,72(sp)
     40e:	6406                	ld	s0,64(sp)
     410:	74e2                	ld	s1,56(sp)
     412:	7942                	ld	s2,48(sp)
     414:	79a2                	ld	s3,40(sp)
     416:	7a02                	ld	s4,32(sp)
     418:	6161                	add	sp,sp,80
     41a:	8082                	ret
      printf("open(copyin1) failed\n");
     41c:	00006517          	auipc	a0,0x6
     420:	80c50513          	add	a0,a0,-2036 # 5c28 <malloc+0x212>
     424:	00005097          	auipc	ra,0x5
     428:	53a080e7          	jalr	1338(ra) # 595e <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	1c8080e7          	jalr	456(ra) # 55f6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	80650513          	add	a0,a0,-2042 # 5c40 <malloc+0x22a>
     442:	00005097          	auipc	ra,0x5
     446:	51c080e7          	jalr	1308(ra) # 595e <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	1aa080e7          	jalr	426(ra) # 55f6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	81850513          	add	a0,a0,-2024 # 5c70 <malloc+0x25a>
     460:	00005097          	auipc	ra,0x5
     464:	4fe080e7          	jalr	1278(ra) # 595e <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	18c080e7          	jalr	396(ra) # 55f6 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	82e50513          	add	a0,a0,-2002 # 5ca0 <malloc+0x28a>
     47a:	00005097          	auipc	ra,0x5
     47e:	4e4080e7          	jalr	1252(ra) # 595e <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	172080e7          	jalr	370(ra) # 55f6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	82050513          	add	a0,a0,-2016 # 5cb0 <malloc+0x29a>
     498:	00005097          	auipc	ra,0x5
     49c:	4c6080e7          	jalr	1222(ra) # 595e <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	154080e7          	jalr	340(ra) # 55f6 <exit>

00000000000004aa <copyout>:
{
     4aa:	711d                	add	sp,sp,-96
     4ac:	ec86                	sd	ra,88(sp)
     4ae:	e8a2                	sd	s0,80(sp)
     4b0:	e4a6                	sd	s1,72(sp)
     4b2:	e0ca                	sd	s2,64(sp)
     4b4:	fc4e                	sd	s3,56(sp)
     4b6:	f852                	sd	s4,48(sp)
     4b8:	f456                	sd	s5,40(sp)
     4ba:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4bc:	4785                	li	a5,1
     4be:	07fe                	sll	a5,a5,0x1f
     4c0:	faf43823          	sd	a5,-80(s0)
     4c4:	57fd                	li	a5,-1
     4c6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ca:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     4ce:	00006a17          	auipc	s4,0x6
     4d2:	812a0a13          	add	s4,s4,-2030 # 5ce0 <malloc+0x2ca>
    n = write(fds[1], "x", 1);
     4d6:	00005a97          	auipc	s5,0x5
     4da:	6d2a8a93          	add	s5,s5,1746 # 5ba8 <malloc+0x192>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	150080e7          	jalr	336(ra) # 5636 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	116080e7          	jalr	278(ra) # 560e <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	118080e7          	jalr	280(ra) # 561e <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	add	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	0f4080e7          	jalr	244(ra) # 5606 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	0f0080e7          	jalr	240(ra) # 5616 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	0d2080e7          	jalr	210(ra) # 560e <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	0d2080e7          	jalr	210(ra) # 561e <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	0c6080e7          	jalr	198(ra) # 561e <close>
  for(int ai = 0; ai < 2; ai++){
     560:	0921                	add	s2,s2,8
     562:	fc040793          	add	a5,s0,-64
     566:	f6f91ce3          	bne	s2,a5,4de <copyout+0x34>
}
     56a:	60e6                	ld	ra,88(sp)
     56c:	6446                	ld	s0,80(sp)
     56e:	64a6                	ld	s1,72(sp)
     570:	6906                	ld	s2,64(sp)
     572:	79e2                	ld	s3,56(sp)
     574:	7a42                	ld	s4,48(sp)
     576:	7aa2                	ld	s5,40(sp)
     578:	6125                	add	sp,sp,96
     57a:	8082                	ret
      printf("open(README) failed\n");
     57c:	00005517          	auipc	a0,0x5
     580:	76c50513          	add	a0,a0,1900 # 5ce8 <malloc+0x2d2>
     584:	00005097          	auipc	ra,0x5
     588:	3da080e7          	jalr	986(ra) # 595e <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	068080e7          	jalr	104(ra) # 55f6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00005517          	auipc	a0,0x5
     59e:	76650513          	add	a0,a0,1894 # 5d00 <malloc+0x2ea>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	3bc080e7          	jalr	956(ra) # 595e <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	04a080e7          	jalr	74(ra) # 55f6 <exit>
      printf("pipe() failed\n");
     5b4:	00005517          	auipc	a0,0x5
     5b8:	6ec50513          	add	a0,a0,1772 # 5ca0 <malloc+0x28a>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	3a2080e7          	jalr	930(ra) # 595e <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	030080e7          	jalr	48(ra) # 55f6 <exit>
      printf("pipe write failed\n");
     5ce:	00005517          	auipc	a0,0x5
     5d2:	76250513          	add	a0,a0,1890 # 5d30 <malloc+0x31a>
     5d6:	00005097          	auipc	ra,0x5
     5da:	388080e7          	jalr	904(ra) # 595e <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	016080e7          	jalr	22(ra) # 55f6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00005517          	auipc	a0,0x5
     5f0:	75c50513          	add	a0,a0,1884 # 5d48 <malloc+0x332>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	36a080e7          	jalr	874(ra) # 595e <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	ff8080e7          	jalr	-8(ra) # 55f6 <exit>

0000000000000606 <truncate1>:
{
     606:	711d                	add	sp,sp,-96
     608:	ec86                	sd	ra,88(sp)
     60a:	e8a2                	sd	s0,80(sp)
     60c:	e4a6                	sd	s1,72(sp)
     60e:	e0ca                	sd	s2,64(sp)
     610:	fc4e                	sd	s3,56(sp)
     612:	f852                	sd	s4,48(sp)
     614:	f456                	sd	s5,40(sp)
     616:	1080                	add	s0,sp,96
     618:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61a:	00005517          	auipc	a0,0x5
     61e:	57650513          	add	a0,a0,1398 # 5b90 <malloc+0x17a>
     622:	00005097          	auipc	ra,0x5
     626:	024080e7          	jalr	36(ra) # 5646 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00005517          	auipc	a0,0x5
     632:	56250513          	add	a0,a0,1378 # 5b90 <malloc+0x17a>
     636:	00005097          	auipc	ra,0x5
     63a:	000080e7          	jalr	ra # 5636 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00005597          	auipc	a1,0x5
     646:	55e58593          	add	a1,a1,1374 # 5ba0 <malloc+0x18a>
     64a:	00005097          	auipc	ra,0x5
     64e:	fcc080e7          	jalr	-52(ra) # 5616 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	fca080e7          	jalr	-54(ra) # 561e <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00005517          	auipc	a0,0x5
     662:	53250513          	add	a0,a0,1330 # 5b90 <malloc+0x17a>
     666:	00005097          	auipc	ra,0x5
     66a:	fd0080e7          	jalr	-48(ra) # 5636 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	add	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	f96080e7          	jalr	-106(ra) # 560e <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00005517          	auipc	a0,0x5
     68e:	50650513          	add	a0,a0,1286 # 5b90 <malloc+0x17a>
     692:	00005097          	auipc	ra,0x5
     696:	fa4080e7          	jalr	-92(ra) # 5636 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	4f250513          	add	a0,a0,1266 # 5b90 <malloc+0x17a>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	f90080e7          	jalr	-112(ra) # 5636 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	add	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	f56080e7          	jalr	-170(ra) # 560e <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	add	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	f40080e7          	jalr	-192(ra) # 560e <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00005597          	auipc	a1,0x5
     6e0:	6fc58593          	add	a1,a1,1788 # 5dd8 <malloc+0x3c2>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	f30080e7          	jalr	-208(ra) # 5616 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	add	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	f16080e7          	jalr	-234(ra) # 560e <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	add	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	efe080e7          	jalr	-258(ra) # 560e <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	47250513          	add	a0,a0,1138 # 5b90 <malloc+0x17a>
     726:	00005097          	auipc	ra,0x5
     72a:	f20080e7          	jalr	-224(ra) # 5646 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	eee080e7          	jalr	-274(ra) # 561e <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	ee4080e7          	jalr	-284(ra) # 561e <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	eda080e7          	jalr	-294(ra) # 561e <close>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	add	sp,sp,96
     75c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     75e:	862a                	mv	a2,a0
     760:	85d6                	mv	a1,s5
     762:	00005517          	auipc	a0,0x5
     766:	61650513          	add	a0,a0,1558 # 5d78 <malloc+0x362>
     76a:	00005097          	auipc	ra,0x5
     76e:	1f4080e7          	jalr	500(ra) # 595e <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	e82080e7          	jalr	-382(ra) # 55f6 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00005517          	auipc	a0,0x5
     782:	61a50513          	add	a0,a0,1562 # 5d98 <malloc+0x382>
     786:	00005097          	auipc	ra,0x5
     78a:	1d8080e7          	jalr	472(ra) # 595e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00005517          	auipc	a0,0x5
     796:	61650513          	add	a0,a0,1558 # 5da8 <malloc+0x392>
     79a:	00005097          	auipc	ra,0x5
     79e:	1c4080e7          	jalr	452(ra) # 595e <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	e52080e7          	jalr	-430(ra) # 55f6 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00005517          	auipc	a0,0x5
     7b2:	61a50513          	add	a0,a0,1562 # 5dc8 <malloc+0x3b2>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	1a8080e7          	jalr	424(ra) # 595e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00005517          	auipc	a0,0x5
     7c6:	5e650513          	add	a0,a0,1510 # 5da8 <malloc+0x392>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	194080e7          	jalr	404(ra) # 595e <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	e22080e7          	jalr	-478(ra) # 55f6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00005517          	auipc	a0,0x5
     7e4:	60050513          	add	a0,a0,1536 # 5de0 <malloc+0x3ca>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	176080e7          	jalr	374(ra) # 595e <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	e04080e7          	jalr	-508(ra) # 55f6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00005517          	auipc	a0,0x5
     802:	60250513          	add	a0,a0,1538 # 5e00 <malloc+0x3ea>
     806:	00005097          	auipc	ra,0x5
     80a:	158080e7          	jalr	344(ra) # 595e <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	de6080e7          	jalr	-538(ra) # 55f6 <exit>

0000000000000818 <writetest>:
{
     818:	7139                	add	sp,sp,-64
     81a:	fc06                	sd	ra,56(sp)
     81c:	f822                	sd	s0,48(sp)
     81e:	f426                	sd	s1,40(sp)
     820:	f04a                	sd	s2,32(sp)
     822:	ec4e                	sd	s3,24(sp)
     824:	e852                	sd	s4,16(sp)
     826:	e456                	sd	s5,8(sp)
     828:	e05a                	sd	s6,0(sp)
     82a:	0080                	add	s0,sp,64
     82c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     82e:	20200593          	li	a1,514
     832:	00005517          	auipc	a0,0x5
     836:	5ee50513          	add	a0,a0,1518 # 5e20 <malloc+0x40a>
     83a:	00005097          	auipc	ra,0x5
     83e:	dfc080e7          	jalr	-516(ra) # 5636 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00005997          	auipc	s3,0x5
     84e:	5fe98993          	add	s3,s3,1534 # 5e48 <malloc+0x432>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00005a97          	auipc	s5,0x5
     856:	62ea8a93          	add	s5,s5,1582 # 5e80 <malloc+0x46a>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	db2080e7          	jalr	-590(ra) # 5616 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	d9e080e7          	jalr	-610(ra) # 5616 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	d90080e7          	jalr	-624(ra) # 561e <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00005517          	auipc	a0,0x5
     89c:	58850513          	add	a0,a0,1416 # 5e20 <malloc+0x40a>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	d96080e7          	jalr	-618(ra) # 5636 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000b597          	auipc	a1,0xb
     8b6:	21658593          	add	a1,a1,534 # bac8 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	d54080e7          	jalr	-684(ra) # 560e <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	d52080e7          	jalr	-686(ra) # 561e <close>
  if(unlink("small") < 0){
     8d4:	00005517          	auipc	a0,0x5
     8d8:	54c50513          	add	a0,a0,1356 # 5e20 <malloc+0x40a>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	d6a080e7          	jalr	-662(ra) # 5646 <unlink>
     8e4:	0a054463          	bltz	a0,98c <writetest+0x174>
}
     8e8:	70e2                	ld	ra,56(sp)
     8ea:	7442                	ld	s0,48(sp)
     8ec:	74a2                	ld	s1,40(sp)
     8ee:	7902                	ld	s2,32(sp)
     8f0:	69e2                	ld	s3,24(sp)
     8f2:	6a42                	ld	s4,16(sp)
     8f4:	6aa2                	ld	s5,8(sp)
     8f6:	6b02                	ld	s6,0(sp)
     8f8:	6121                	add	sp,sp,64
     8fa:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fc:	85da                	mv	a1,s6
     8fe:	00005517          	auipc	a0,0x5
     902:	52a50513          	add	a0,a0,1322 # 5e28 <malloc+0x412>
     906:	00005097          	auipc	ra,0x5
     90a:	058080e7          	jalr	88(ra) # 595e <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	ce6080e7          	jalr	-794(ra) # 55f6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00005517          	auipc	a0,0x5
     920:	53c50513          	add	a0,a0,1340 # 5e58 <malloc+0x442>
     924:	00005097          	auipc	ra,0x5
     928:	03a080e7          	jalr	58(ra) # 595e <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	cc8080e7          	jalr	-824(ra) # 55f6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00005517          	auipc	a0,0x5
     93e:	55650513          	add	a0,a0,1366 # 5e90 <malloc+0x47a>
     942:	00005097          	auipc	ra,0x5
     946:	01c080e7          	jalr	28(ra) # 595e <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	caa080e7          	jalr	-854(ra) # 55f6 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00005517          	auipc	a0,0x5
     95a:	56250513          	add	a0,a0,1378 # 5eb8 <malloc+0x4a2>
     95e:	00005097          	auipc	ra,0x5
     962:	000080e7          	jalr	ra # 595e <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	c8e080e7          	jalr	-882(ra) # 55f6 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	56650513          	add	a0,a0,1382 # 5ed8 <malloc+0x4c2>
     97a:	00005097          	auipc	ra,0x5
     97e:	fe4080e7          	jalr	-28(ra) # 595e <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	c72080e7          	jalr	-910(ra) # 55f6 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	56250513          	add	a0,a0,1378 # 5ef0 <malloc+0x4da>
     996:	00005097          	auipc	ra,0x5
     99a:	fc8080e7          	jalr	-56(ra) # 595e <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	c56080e7          	jalr	-938(ra) # 55f6 <exit>

00000000000009a8 <writebig>:
{
     9a8:	7139                	add	sp,sp,-64
     9aa:	fc06                	sd	ra,56(sp)
     9ac:	f822                	sd	s0,48(sp)
     9ae:	f426                	sd	s1,40(sp)
     9b0:	f04a                	sd	s2,32(sp)
     9b2:	ec4e                	sd	s3,24(sp)
     9b4:	e852                	sd	s4,16(sp)
     9b6:	e456                	sd	s5,8(sp)
     9b8:	0080                	add	s0,sp,64
     9ba:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9bc:	20200593          	li	a1,514
     9c0:	00005517          	auipc	a0,0x5
     9c4:	55050513          	add	a0,a0,1360 # 5f10 <malloc+0x4fa>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	c6e080e7          	jalr	-914(ra) # 5636 <open>
     9d0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d4:	0000b917          	auipc	s2,0xb
     9d8:	0f490913          	add	s2,s2,244 # bac8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9dc:	10c00a13          	li	s4,268
  if(fd < 0){
     9e0:	06054c63          	bltz	a0,a58 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9e8:	40000613          	li	a2,1024
     9ec:	85ca                	mv	a1,s2
     9ee:	854e                	mv	a0,s3
     9f0:	00005097          	auipc	ra,0x5
     9f4:	c26080e7          	jalr	-986(ra) # 5616 <write>
     9f8:	40000793          	li	a5,1024
     9fc:	06f51c63          	bne	a0,a5,a74 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a00:	2485                	addw	s1,s1,1
     a02:	ff4491e3          	bne	s1,s4,9e4 <writebig+0x3c>
  close(fd);
     a06:	854e                	mv	a0,s3
     a08:	00005097          	auipc	ra,0x5
     a0c:	c16080e7          	jalr	-1002(ra) # 561e <close>
  fd = open("big", O_RDONLY);
     a10:	4581                	li	a1,0
     a12:	00005517          	auipc	a0,0x5
     a16:	4fe50513          	add	a0,a0,1278 # 5f10 <malloc+0x4fa>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	c1c080e7          	jalr	-996(ra) # 5636 <open>
     a22:	89aa                	mv	s3,a0
  n = 0;
     a24:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a26:	0000b917          	auipc	s2,0xb
     a2a:	0a290913          	add	s2,s2,162 # bac8 <buf>
  if(fd < 0){
     a2e:	06054263          	bltz	a0,a92 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a32:	40000613          	li	a2,1024
     a36:	85ca                	mv	a1,s2
     a38:	854e                	mv	a0,s3
     a3a:	00005097          	auipc	ra,0x5
     a3e:	bd4080e7          	jalr	-1068(ra) # 560e <read>
    if(i == 0){
     a42:	c535                	beqz	a0,aae <writebig+0x106>
    } else if(i != BSIZE){
     a44:	40000793          	li	a5,1024
     a48:	0af51f63          	bne	a0,a5,b06 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4c:	00092683          	lw	a3,0(s2)
     a50:	0c969a63          	bne	a3,s1,b24 <writebig+0x17c>
    n++;
     a54:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a56:	bff1                	j	a32 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a58:	85d6                	mv	a1,s5
     a5a:	00005517          	auipc	a0,0x5
     a5e:	4be50513          	add	a0,a0,1214 # 5f18 <malloc+0x502>
     a62:	00005097          	auipc	ra,0x5
     a66:	efc080e7          	jalr	-260(ra) # 595e <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	00005097          	auipc	ra,0x5
     a70:	b8a080e7          	jalr	-1142(ra) # 55f6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a74:	8626                	mv	a2,s1
     a76:	85d6                	mv	a1,s5
     a78:	00005517          	auipc	a0,0x5
     a7c:	4c050513          	add	a0,a0,1216 # 5f38 <malloc+0x522>
     a80:	00005097          	auipc	ra,0x5
     a84:	ede080e7          	jalr	-290(ra) # 595e <printf>
      exit(1);
     a88:	4505                	li	a0,1
     a8a:	00005097          	auipc	ra,0x5
     a8e:	b6c080e7          	jalr	-1172(ra) # 55f6 <exit>
    printf("%s: error: open big failed!\n", s);
     a92:	85d6                	mv	a1,s5
     a94:	00005517          	auipc	a0,0x5
     a98:	4cc50513          	add	a0,a0,1228 # 5f60 <malloc+0x54a>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	ec2080e7          	jalr	-318(ra) # 595e <printf>
    exit(1);
     aa4:	4505                	li	a0,1
     aa6:	00005097          	auipc	ra,0x5
     aaa:	b50080e7          	jalr	-1200(ra) # 55f6 <exit>
      if(n == MAXFILE - 1){
     aae:	10b00793          	li	a5,267
     ab2:	02f48a63          	beq	s1,a5,ae6 <writebig+0x13e>
  close(fd);
     ab6:	854e                	mv	a0,s3
     ab8:	00005097          	auipc	ra,0x5
     abc:	b66080e7          	jalr	-1178(ra) # 561e <close>
  if(unlink("big") < 0){
     ac0:	00005517          	auipc	a0,0x5
     ac4:	45050513          	add	a0,a0,1104 # 5f10 <malloc+0x4fa>
     ac8:	00005097          	auipc	ra,0x5
     acc:	b7e080e7          	jalr	-1154(ra) # 5646 <unlink>
     ad0:	06054963          	bltz	a0,b42 <writebig+0x19a>
}
     ad4:	70e2                	ld	ra,56(sp)
     ad6:	7442                	ld	s0,48(sp)
     ad8:	74a2                	ld	s1,40(sp)
     ada:	7902                	ld	s2,32(sp)
     adc:	69e2                	ld	s3,24(sp)
     ade:	6a42                	ld	s4,16(sp)
     ae0:	6aa2                	ld	s5,8(sp)
     ae2:	6121                	add	sp,sp,64
     ae4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae6:	10b00613          	li	a2,267
     aea:	85d6                	mv	a1,s5
     aec:	00005517          	auipc	a0,0x5
     af0:	49450513          	add	a0,a0,1172 # 5f80 <malloc+0x56a>
     af4:	00005097          	auipc	ra,0x5
     af8:	e6a080e7          	jalr	-406(ra) # 595e <printf>
        exit(1);
     afc:	4505                	li	a0,1
     afe:	00005097          	auipc	ra,0x5
     b02:	af8080e7          	jalr	-1288(ra) # 55f6 <exit>
      printf("%s: read failed %d\n", s, i);
     b06:	862a                	mv	a2,a0
     b08:	85d6                	mv	a1,s5
     b0a:	00005517          	auipc	a0,0x5
     b0e:	49e50513          	add	a0,a0,1182 # 5fa8 <malloc+0x592>
     b12:	00005097          	auipc	ra,0x5
     b16:	e4c080e7          	jalr	-436(ra) # 595e <printf>
      exit(1);
     b1a:	4505                	li	a0,1
     b1c:	00005097          	auipc	ra,0x5
     b20:	ada080e7          	jalr	-1318(ra) # 55f6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b24:	8626                	mv	a2,s1
     b26:	85d6                	mv	a1,s5
     b28:	00005517          	auipc	a0,0x5
     b2c:	49850513          	add	a0,a0,1176 # 5fc0 <malloc+0x5aa>
     b30:	00005097          	auipc	ra,0x5
     b34:	e2e080e7          	jalr	-466(ra) # 595e <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	abc080e7          	jalr	-1348(ra) # 55f6 <exit>
    printf("%s: unlink big failed\n", s);
     b42:	85d6                	mv	a1,s5
     b44:	00005517          	auipc	a0,0x5
     b48:	4a450513          	add	a0,a0,1188 # 5fe8 <malloc+0x5d2>
     b4c:	00005097          	auipc	ra,0x5
     b50:	e12080e7          	jalr	-494(ra) # 595e <printf>
    exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	aa0080e7          	jalr	-1376(ra) # 55f6 <exit>

0000000000000b5e <unlinkread>:
{
     b5e:	7179                	add	sp,sp,-48
     b60:	f406                	sd	ra,40(sp)
     b62:	f022                	sd	s0,32(sp)
     b64:	ec26                	sd	s1,24(sp)
     b66:	e84a                	sd	s2,16(sp)
     b68:	e44e                	sd	s3,8(sp)
     b6a:	1800                	add	s0,sp,48
     b6c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b6e:	20200593          	li	a1,514
     b72:	00005517          	auipc	a0,0x5
     b76:	48e50513          	add	a0,a0,1166 # 6000 <malloc+0x5ea>
     b7a:	00005097          	auipc	ra,0x5
     b7e:	abc080e7          	jalr	-1348(ra) # 5636 <open>
  if(fd < 0){
     b82:	0e054563          	bltz	a0,c6c <unlinkread+0x10e>
     b86:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b88:	4615                	li	a2,5
     b8a:	00005597          	auipc	a1,0x5
     b8e:	4a658593          	add	a1,a1,1190 # 6030 <malloc+0x61a>
     b92:	00005097          	auipc	ra,0x5
     b96:	a84080e7          	jalr	-1404(ra) # 5616 <write>
  close(fd);
     b9a:	8526                	mv	a0,s1
     b9c:	00005097          	auipc	ra,0x5
     ba0:	a82080e7          	jalr	-1406(ra) # 561e <close>
  fd = open("unlinkread", O_RDWR);
     ba4:	4589                	li	a1,2
     ba6:	00005517          	auipc	a0,0x5
     baa:	45a50513          	add	a0,a0,1114 # 6000 <malloc+0x5ea>
     bae:	00005097          	auipc	ra,0x5
     bb2:	a88080e7          	jalr	-1400(ra) # 5636 <open>
     bb6:	84aa                	mv	s1,a0
  if(fd < 0){
     bb8:	0c054863          	bltz	a0,c88 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbc:	00005517          	auipc	a0,0x5
     bc0:	44450513          	add	a0,a0,1092 # 6000 <malloc+0x5ea>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	a82080e7          	jalr	-1406(ra) # 5646 <unlink>
     bcc:	ed61                	bnez	a0,ca4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bce:	20200593          	li	a1,514
     bd2:	00005517          	auipc	a0,0x5
     bd6:	42e50513          	add	a0,a0,1070 # 6000 <malloc+0x5ea>
     bda:	00005097          	auipc	ra,0x5
     bde:	a5c080e7          	jalr	-1444(ra) # 5636 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	49258593          	add	a1,a1,1170 # 6078 <malloc+0x662>
     bee:	00005097          	auipc	ra,0x5
     bf2:	a28080e7          	jalr	-1496(ra) # 5616 <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	00005097          	auipc	ra,0x5
     bfc:	a26080e7          	jalr	-1498(ra) # 561e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c00:	660d                	lui	a2,0x3
     c02:	0000b597          	auipc	a1,0xb
     c06:	ec658593          	add	a1,a1,-314 # bac8 <buf>
     c0a:	8526                	mv	a0,s1
     c0c:	00005097          	auipc	ra,0x5
     c10:	a02080e7          	jalr	-1534(ra) # 560e <read>
     c14:	4795                	li	a5,5
     c16:	0af51563          	bne	a0,a5,cc0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1a:	0000b717          	auipc	a4,0xb
     c1e:	eae74703          	lbu	a4,-338(a4) # bac8 <buf>
     c22:	06800793          	li	a5,104
     c26:	0af71b63          	bne	a4,a5,cdc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2a:	4629                	li	a2,10
     c2c:	0000b597          	auipc	a1,0xb
     c30:	e9c58593          	add	a1,a1,-356 # bac8 <buf>
     c34:	8526                	mv	a0,s1
     c36:	00005097          	auipc	ra,0x5
     c3a:	9e0080e7          	jalr	-1568(ra) # 5616 <write>
     c3e:	47a9                	li	a5,10
     c40:	0af51c63          	bne	a0,a5,cf8 <unlinkread+0x19a>
  close(fd);
     c44:	8526                	mv	a0,s1
     c46:	00005097          	auipc	ra,0x5
     c4a:	9d8080e7          	jalr	-1576(ra) # 561e <close>
  unlink("unlinkread");
     c4e:	00005517          	auipc	a0,0x5
     c52:	3b250513          	add	a0,a0,946 # 6000 <malloc+0x5ea>
     c56:	00005097          	auipc	ra,0x5
     c5a:	9f0080e7          	jalr	-1552(ra) # 5646 <unlink>
}
     c5e:	70a2                	ld	ra,40(sp)
     c60:	7402                	ld	s0,32(sp)
     c62:	64e2                	ld	s1,24(sp)
     c64:	6942                	ld	s2,16(sp)
     c66:	69a2                	ld	s3,8(sp)
     c68:	6145                	add	sp,sp,48
     c6a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	3a250513          	add	a0,a0,930 # 6010 <malloc+0x5fa>
     c76:	00005097          	auipc	ra,0x5
     c7a:	ce8080e7          	jalr	-792(ra) # 595e <printf>
    exit(1);
     c7e:	4505                	li	a0,1
     c80:	00005097          	auipc	ra,0x5
     c84:	976080e7          	jalr	-1674(ra) # 55f6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	3ae50513          	add	a0,a0,942 # 6038 <malloc+0x622>
     c92:	00005097          	auipc	ra,0x5
     c96:	ccc080e7          	jalr	-820(ra) # 595e <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00005097          	auipc	ra,0x5
     ca0:	95a080e7          	jalr	-1702(ra) # 55f6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	3b250513          	add	a0,a0,946 # 6058 <malloc+0x642>
     cae:	00005097          	auipc	ra,0x5
     cb2:	cb0080e7          	jalr	-848(ra) # 595e <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00005097          	auipc	ra,0x5
     cbc:	93e080e7          	jalr	-1730(ra) # 55f6 <exit>
    printf("%s: unlinkread read failed", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	3be50513          	add	a0,a0,958 # 6080 <malloc+0x66a>
     cca:	00005097          	auipc	ra,0x5
     cce:	c94080e7          	jalr	-876(ra) # 595e <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	922080e7          	jalr	-1758(ra) # 55f6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	3c250513          	add	a0,a0,962 # 60a0 <malloc+0x68a>
     ce6:	00005097          	auipc	ra,0x5
     cea:	c78080e7          	jalr	-904(ra) # 595e <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	906080e7          	jalr	-1786(ra) # 55f6 <exit>
    printf("%s: unlinkread write failed\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	3c650513          	add	a0,a0,966 # 60c0 <malloc+0x6aa>
     d02:	00005097          	auipc	ra,0x5
     d06:	c5c080e7          	jalr	-932(ra) # 595e <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00005097          	auipc	ra,0x5
     d10:	8ea080e7          	jalr	-1814(ra) # 55f6 <exit>

0000000000000d14 <linktest>:
{
     d14:	1101                	add	sp,sp,-32
     d16:	ec06                	sd	ra,24(sp)
     d18:	e822                	sd	s0,16(sp)
     d1a:	e426                	sd	s1,8(sp)
     d1c:	e04a                	sd	s2,0(sp)
     d1e:	1000                	add	s0,sp,32
     d20:	892a                	mv	s2,a0
  unlink("lf1");
     d22:	00005517          	auipc	a0,0x5
     d26:	3be50513          	add	a0,a0,958 # 60e0 <malloc+0x6ca>
     d2a:	00005097          	auipc	ra,0x5
     d2e:	91c080e7          	jalr	-1764(ra) # 5646 <unlink>
  unlink("lf2");
     d32:	00005517          	auipc	a0,0x5
     d36:	3b650513          	add	a0,a0,950 # 60e8 <malloc+0x6d2>
     d3a:	00005097          	auipc	ra,0x5
     d3e:	90c080e7          	jalr	-1780(ra) # 5646 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d42:	20200593          	li	a1,514
     d46:	00005517          	auipc	a0,0x5
     d4a:	39a50513          	add	a0,a0,922 # 60e0 <malloc+0x6ca>
     d4e:	00005097          	auipc	ra,0x5
     d52:	8e8080e7          	jalr	-1816(ra) # 5636 <open>
  if(fd < 0){
     d56:	10054763          	bltz	a0,e64 <linktest+0x150>
     d5a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5c:	4615                	li	a2,5
     d5e:	00005597          	auipc	a1,0x5
     d62:	2d258593          	add	a1,a1,722 # 6030 <malloc+0x61a>
     d66:	00005097          	auipc	ra,0x5
     d6a:	8b0080e7          	jalr	-1872(ra) # 5616 <write>
     d6e:	4795                	li	a5,5
     d70:	10f51863          	bne	a0,a5,e80 <linktest+0x16c>
  close(fd);
     d74:	8526                	mv	a0,s1
     d76:	00005097          	auipc	ra,0x5
     d7a:	8a8080e7          	jalr	-1880(ra) # 561e <close>
  if(link("lf1", "lf2") < 0){
     d7e:	00005597          	auipc	a1,0x5
     d82:	36a58593          	add	a1,a1,874 # 60e8 <malloc+0x6d2>
     d86:	00005517          	auipc	a0,0x5
     d8a:	35a50513          	add	a0,a0,858 # 60e0 <malloc+0x6ca>
     d8e:	00005097          	auipc	ra,0x5
     d92:	8c8080e7          	jalr	-1848(ra) # 5656 <link>
     d96:	10054363          	bltz	a0,e9c <linktest+0x188>
  unlink("lf1");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	34650513          	add	a0,a0,838 # 60e0 <malloc+0x6ca>
     da2:	00005097          	auipc	ra,0x5
     da6:	8a4080e7          	jalr	-1884(ra) # 5646 <unlink>
  if(open("lf1", 0) >= 0){
     daa:	4581                	li	a1,0
     dac:	00005517          	auipc	a0,0x5
     db0:	33450513          	add	a0,a0,820 # 60e0 <malloc+0x6ca>
     db4:	00005097          	auipc	ra,0x5
     db8:	882080e7          	jalr	-1918(ra) # 5636 <open>
     dbc:	0e055e63          	bgez	a0,eb8 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc0:	4581                	li	a1,0
     dc2:	00005517          	auipc	a0,0x5
     dc6:	32650513          	add	a0,a0,806 # 60e8 <malloc+0x6d2>
     dca:	00005097          	auipc	ra,0x5
     dce:	86c080e7          	jalr	-1940(ra) # 5636 <open>
     dd2:	84aa                	mv	s1,a0
  if(fd < 0){
     dd4:	10054063          	bltz	a0,ed4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dd8:	660d                	lui	a2,0x3
     dda:	0000b597          	auipc	a1,0xb
     dde:	cee58593          	add	a1,a1,-786 # bac8 <buf>
     de2:	00005097          	auipc	ra,0x5
     de6:	82c080e7          	jalr	-2004(ra) # 560e <read>
     dea:	4795                	li	a5,5
     dec:	10f51263          	bne	a0,a5,ef0 <linktest+0x1dc>
  close(fd);
     df0:	8526                	mv	a0,s1
     df2:	00005097          	auipc	ra,0x5
     df6:	82c080e7          	jalr	-2004(ra) # 561e <close>
  if(link("lf2", "lf2") >= 0){
     dfa:	00005597          	auipc	a1,0x5
     dfe:	2ee58593          	add	a1,a1,750 # 60e8 <malloc+0x6d2>
     e02:	852e                	mv	a0,a1
     e04:	00005097          	auipc	ra,0x5
     e08:	852080e7          	jalr	-1966(ra) # 5656 <link>
     e0c:	10055063          	bgez	a0,f0c <linktest+0x1f8>
  unlink("lf2");
     e10:	00005517          	auipc	a0,0x5
     e14:	2d850513          	add	a0,a0,728 # 60e8 <malloc+0x6d2>
     e18:	00005097          	auipc	ra,0x5
     e1c:	82e080e7          	jalr	-2002(ra) # 5646 <unlink>
  if(link("lf2", "lf1") >= 0){
     e20:	00005597          	auipc	a1,0x5
     e24:	2c058593          	add	a1,a1,704 # 60e0 <malloc+0x6ca>
     e28:	00005517          	auipc	a0,0x5
     e2c:	2c050513          	add	a0,a0,704 # 60e8 <malloc+0x6d2>
     e30:	00005097          	auipc	ra,0x5
     e34:	826080e7          	jalr	-2010(ra) # 5656 <link>
     e38:	0e055863          	bgez	a0,f28 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	2a458593          	add	a1,a1,676 # 60e0 <malloc+0x6ca>
     e44:	00005517          	auipc	a0,0x5
     e48:	3ac50513          	add	a0,a0,940 # 61f0 <malloc+0x7da>
     e4c:	00005097          	auipc	ra,0x5
     e50:	80a080e7          	jalr	-2038(ra) # 5656 <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x230>
}
     e58:	60e2                	ld	ra,24(sp)
     e5a:	6442                	ld	s0,16(sp)
     e5c:	64a2                	ld	s1,8(sp)
     e5e:	6902                	ld	s2,0(sp)
     e60:	6105                	add	sp,sp,32
     e62:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e64:	85ca                	mv	a1,s2
     e66:	00005517          	auipc	a0,0x5
     e6a:	28a50513          	add	a0,a0,650 # 60f0 <malloc+0x6da>
     e6e:	00005097          	auipc	ra,0x5
     e72:	af0080e7          	jalr	-1296(ra) # 595e <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00004097          	auipc	ra,0x4
     e7c:	77e080e7          	jalr	1918(ra) # 55f6 <exit>
    printf("%s: write lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	28650513          	add	a0,a0,646 # 6108 <malloc+0x6f2>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	ad4080e7          	jalr	-1324(ra) # 595e <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00004097          	auipc	ra,0x4
     e98:	762080e7          	jalr	1890(ra) # 55f6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	28250513          	add	a0,a0,642 # 6120 <malloc+0x70a>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	ab8080e7          	jalr	-1352(ra) # 595e <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00004097          	auipc	ra,0x4
     eb4:	746080e7          	jalr	1862(ra) # 55f6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	28650513          	add	a0,a0,646 # 6140 <malloc+0x72a>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	a9c080e7          	jalr	-1380(ra) # 595e <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00004097          	auipc	ra,0x4
     ed0:	72a080e7          	jalr	1834(ra) # 55f6 <exit>
    printf("%s: open lf2 failed\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	29a50513          	add	a0,a0,666 # 6170 <malloc+0x75a>
     ede:	00005097          	auipc	ra,0x5
     ee2:	a80080e7          	jalr	-1408(ra) # 595e <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00004097          	auipc	ra,0x4
     eec:	70e080e7          	jalr	1806(ra) # 55f6 <exit>
    printf("%s: read lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	29650513          	add	a0,a0,662 # 6188 <malloc+0x772>
     efa:	00005097          	auipc	ra,0x5
     efe:	a64080e7          	jalr	-1436(ra) # 595e <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00004097          	auipc	ra,0x4
     f08:	6f2080e7          	jalr	1778(ra) # 55f6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	29250513          	add	a0,a0,658 # 61a0 <malloc+0x78a>
     f16:	00005097          	auipc	ra,0x5
     f1a:	a48080e7          	jalr	-1464(ra) # 595e <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00004097          	auipc	ra,0x4
     f24:	6d6080e7          	jalr	1750(ra) # 55f6 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	29e50513          	add	a0,a0,670 # 61c8 <malloc+0x7b2>
     f32:	00005097          	auipc	ra,0x5
     f36:	a2c080e7          	jalr	-1492(ra) # 595e <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00004097          	auipc	ra,0x4
     f40:	6ba080e7          	jalr	1722(ra) # 55f6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	2b250513          	add	a0,a0,690 # 61f8 <malloc+0x7e2>
     f4e:	00005097          	auipc	ra,0x5
     f52:	a10080e7          	jalr	-1520(ra) # 595e <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00004097          	auipc	ra,0x4
     f5c:	69e080e7          	jalr	1694(ra) # 55f6 <exit>

0000000000000f60 <bigdir>:
{
     f60:	715d                	add	sp,sp,-80
     f62:	e486                	sd	ra,72(sp)
     f64:	e0a2                	sd	s0,64(sp)
     f66:	fc26                	sd	s1,56(sp)
     f68:	f84a                	sd	s2,48(sp)
     f6a:	f44e                	sd	s3,40(sp)
     f6c:	f052                	sd	s4,32(sp)
     f6e:	ec56                	sd	s5,24(sp)
     f70:	e85a                	sd	s6,16(sp)
     f72:	0880                	add	s0,sp,80
     f74:	89aa                	mv	s3,a0
  unlink("bd");
     f76:	00005517          	auipc	a0,0x5
     f7a:	2a250513          	add	a0,a0,674 # 6218 <malloc+0x802>
     f7e:	00004097          	auipc	ra,0x4
     f82:	6c8080e7          	jalr	1736(ra) # 5646 <unlink>
  fd = open("bd", O_CREATE);
     f86:	20000593          	li	a1,512
     f8a:	00005517          	auipc	a0,0x5
     f8e:	28e50513          	add	a0,a0,654 # 6218 <malloc+0x802>
     f92:	00004097          	auipc	ra,0x4
     f96:	6a4080e7          	jalr	1700(ra) # 5636 <open>
  if(fd < 0){
     f9a:	0c054963          	bltz	a0,106c <bigdir+0x10c>
  close(fd);
     f9e:	00004097          	auipc	ra,0x4
     fa2:	680080e7          	jalr	1664(ra) # 561e <close>
  for(i = 0; i < N; i++){
     fa6:	4901                	li	s2,0
    name[0] = 'x';
     fa8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fac:	00005a17          	auipc	s4,0x5
     fb0:	26ca0a13          	add	s4,s4,620 # 6218 <malloc+0x802>
  for(i = 0; i < N; i++){
     fb4:	1f400b13          	li	s6,500
    name[0] = 'x';
     fb8:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbc:	41f9571b          	sraw	a4,s2,0x1f
     fc0:	01a7571b          	srlw	a4,a4,0x1a
     fc4:	012707bb          	addw	a5,a4,s2
     fc8:	4067d69b          	sraw	a3,a5,0x6
     fcc:	0306869b          	addw	a3,a3,48
     fd0:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd4:	03f7f793          	and	a5,a5,63
     fd8:	9f99                	subw	a5,a5,a4
     fda:	0307879b          	addw	a5,a5,48
     fde:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe2:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe6:	fb040593          	add	a1,s0,-80
     fea:	8552                	mv	a0,s4
     fec:	00004097          	auipc	ra,0x4
     ff0:	66a080e7          	jalr	1642(ra) # 5656 <link>
     ff4:	84aa                	mv	s1,a0
     ff6:	e949                	bnez	a0,1088 <bigdir+0x128>
  for(i = 0; i < N; i++){
     ff8:	2905                	addw	s2,s2,1
     ffa:	fb691fe3          	bne	s2,s6,fb8 <bigdir+0x58>
  unlink("bd");
     ffe:	00005517          	auipc	a0,0x5
    1002:	21a50513          	add	a0,a0,538 # 6218 <malloc+0x802>
    1006:	00004097          	auipc	ra,0x4
    100a:	640080e7          	jalr	1600(ra) # 5646 <unlink>
    name[0] = 'x';
    100e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1012:	1f400a13          	li	s4,500
    name[0] = 'x';
    1016:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101a:	41f4d71b          	sraw	a4,s1,0x1f
    101e:	01a7571b          	srlw	a4,a4,0x1a
    1022:	009707bb          	addw	a5,a4,s1
    1026:	4067d69b          	sraw	a3,a5,0x6
    102a:	0306869b          	addw	a3,a3,48
    102e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1032:	03f7f793          	and	a5,a5,63
    1036:	9f99                	subw	a5,a5,a4
    1038:	0307879b          	addw	a5,a5,48
    103c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1040:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1044:	fb040513          	add	a0,s0,-80
    1048:	00004097          	auipc	ra,0x4
    104c:	5fe080e7          	jalr	1534(ra) # 5646 <unlink>
    1050:	ed21                	bnez	a0,10a8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    1052:	2485                	addw	s1,s1,1
    1054:	fd4491e3          	bne	s1,s4,1016 <bigdir+0xb6>
}
    1058:	60a6                	ld	ra,72(sp)
    105a:	6406                	ld	s0,64(sp)
    105c:	74e2                	ld	s1,56(sp)
    105e:	7942                	ld	s2,48(sp)
    1060:	79a2                	ld	s3,40(sp)
    1062:	7a02                	ld	s4,32(sp)
    1064:	6ae2                	ld	s5,24(sp)
    1066:	6b42                	ld	s6,16(sp)
    1068:	6161                	add	sp,sp,80
    106a:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106c:	85ce                	mv	a1,s3
    106e:	00005517          	auipc	a0,0x5
    1072:	1b250513          	add	a0,a0,434 # 6220 <malloc+0x80a>
    1076:	00005097          	auipc	ra,0x5
    107a:	8e8080e7          	jalr	-1816(ra) # 595e <printf>
    exit(1);
    107e:	4505                	li	a0,1
    1080:	00004097          	auipc	ra,0x4
    1084:	576080e7          	jalr	1398(ra) # 55f6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1088:	fb040613          	add	a2,s0,-80
    108c:	85ce                	mv	a1,s3
    108e:	00005517          	auipc	a0,0x5
    1092:	1b250513          	add	a0,a0,434 # 6240 <malloc+0x82a>
    1096:	00005097          	auipc	ra,0x5
    109a:	8c8080e7          	jalr	-1848(ra) # 595e <printf>
      exit(1);
    109e:	4505                	li	a0,1
    10a0:	00004097          	auipc	ra,0x4
    10a4:	556080e7          	jalr	1366(ra) # 55f6 <exit>
      printf("%s: bigdir unlink failed", s);
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	1b650513          	add	a0,a0,438 # 6260 <malloc+0x84a>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	8ac080e7          	jalr	-1876(ra) # 595e <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	53a080e7          	jalr	1338(ra) # 55f6 <exit>

00000000000010c4 <validatetest>:
{
    10c4:	7139                	add	sp,sp,-64
    10c6:	fc06                	sd	ra,56(sp)
    10c8:	f822                	sd	s0,48(sp)
    10ca:	f426                	sd	s1,40(sp)
    10cc:	f04a                	sd	s2,32(sp)
    10ce:	ec4e                	sd	s3,24(sp)
    10d0:	e852                	sd	s4,16(sp)
    10d2:	e456                	sd	s5,8(sp)
    10d4:	e05a                	sd	s6,0(sp)
    10d6:	0080                	add	s0,sp,64
    10d8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10da:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10dc:	00005997          	auipc	s3,0x5
    10e0:	1a498993          	add	s3,s3,420 # 6280 <malloc+0x86a>
    10e4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e6:	6a85                	lui	s5,0x1
    10e8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ec:	85a6                	mv	a1,s1
    10ee:	854e                	mv	a0,s3
    10f0:	00004097          	auipc	ra,0x4
    10f4:	566080e7          	jalr	1382(ra) # 5656 <link>
    10f8:	01251f63          	bne	a0,s2,1116 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	94d6                	add	s1,s1,s5
    10fe:	ff4497e3          	bne	s1,s4,10ec <validatetest+0x28>
}
    1102:	70e2                	ld	ra,56(sp)
    1104:	7442                	ld	s0,48(sp)
    1106:	74a2                	ld	s1,40(sp)
    1108:	7902                	ld	s2,32(sp)
    110a:	69e2                	ld	s3,24(sp)
    110c:	6a42                	ld	s4,16(sp)
    110e:	6aa2                	ld	s5,8(sp)
    1110:	6b02                	ld	s6,0(sp)
    1112:	6121                	add	sp,sp,64
    1114:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1116:	85da                	mv	a1,s6
    1118:	00005517          	auipc	a0,0x5
    111c:	17850513          	add	a0,a0,376 # 6290 <malloc+0x87a>
    1120:	00005097          	auipc	ra,0x5
    1124:	83e080e7          	jalr	-1986(ra) # 595e <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	00004097          	auipc	ra,0x4
    112e:	4cc080e7          	jalr	1228(ra) # 55f6 <exit>

0000000000001132 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1132:	7179                	add	sp,sp,-48
    1134:	f406                	sd	ra,40(sp)
    1136:	f022                	sd	s0,32(sp)
    1138:	ec26                	sd	s1,24(sp)
    113a:	1800                	add	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113c:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1140:	00007497          	auipc	s1,0x7
    1144:	1584b483          	ld	s1,344(s1) # 8298 <__SDATA_BEGIN__>
    1148:	fd840593          	add	a1,s0,-40
    114c:	8526                	mv	a0,s1
    114e:	00004097          	auipc	ra,0x4
    1152:	4e0080e7          	jalr	1248(ra) # 562e <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	4ae080e7          	jalr	1198(ra) # 5606 <pipe>

  exit(0);
    1160:	4501                	li	a0,0
    1162:	00004097          	auipc	ra,0x4
    1166:	494080e7          	jalr	1172(ra) # 55f6 <exit>

000000000000116a <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116a:	7139                	add	sp,sp,-64
    116c:	fc06                	sd	ra,56(sp)
    116e:	f822                	sd	s0,48(sp)
    1170:	f426                	sd	s1,40(sp)
    1172:	f04a                	sd	s2,32(sp)
    1174:	ec4e                	sd	s3,24(sp)
    1176:	0080                	add	s0,sp,64
    1178:	64b1                	lui	s1,0xc
    117a:	35048493          	add	s1,s1,848 # c350 <buf+0x888>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    117e:	597d                	li	s2,-1
    1180:	02095913          	srl	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1184:	00005997          	auipc	s3,0x5
    1188:	9b498993          	add	s3,s3,-1612 # 5b38 <malloc+0x122>
    argv[0] = (char*)0xffffffff;
    118c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1190:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1194:	fc040593          	add	a1,s0,-64
    1198:	854e                	mv	a0,s3
    119a:	00004097          	auipc	ra,0x4
    119e:	494080e7          	jalr	1172(ra) # 562e <exec>
  for(int i = 0; i < 50000; i++){
    11a2:	34fd                	addw	s1,s1,-1
    11a4:	f4e5                	bnez	s1,118c <badarg+0x22>
  }
  
  exit(0);
    11a6:	4501                	li	a0,0
    11a8:	00004097          	auipc	ra,0x4
    11ac:	44e080e7          	jalr	1102(ra) # 55f6 <exit>

00000000000011b0 <copyinstr2>:
{
    11b0:	7155                	add	sp,sp,-208
    11b2:	e586                	sd	ra,200(sp)
    11b4:	e1a2                	sd	s0,192(sp)
    11b6:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11b8:	f6840793          	add	a5,s0,-152
    11bc:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    11c0:	07800713          	li	a4,120
    11c4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11c8:	0785                	add	a5,a5,1
    11ca:	fed79de3          	bne	a5,a3,11c4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11ce:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d2:	f6840513          	add	a0,s0,-152
    11d6:	00004097          	auipc	ra,0x4
    11da:	470080e7          	jalr	1136(ra) # 5646 <unlink>
  if(ret != -1){
    11de:	57fd                	li	a5,-1
    11e0:	0ef51063          	bne	a0,a5,12c0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e4:	20100593          	li	a1,513
    11e8:	f6840513          	add	a0,s0,-152
    11ec:	00004097          	auipc	ra,0x4
    11f0:	44a080e7          	jalr	1098(ra) # 5636 <open>
  if(fd != -1){
    11f4:	57fd                	li	a5,-1
    11f6:	0ef51563          	bne	a0,a5,12e0 <copyinstr2+0x130>
  ret = link(b, b);
    11fa:	f6840593          	add	a1,s0,-152
    11fe:	852e                	mv	a0,a1
    1200:	00004097          	auipc	ra,0x4
    1204:	456080e7          	jalr	1110(ra) # 5656 <link>
  if(ret != -1){
    1208:	57fd                	li	a5,-1
    120a:	0ef51b63          	bne	a0,a5,1300 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    120e:	00006797          	auipc	a5,0x6
    1212:	26278793          	add	a5,a5,610 # 7470 <malloc+0x1a5a>
    1216:	f4f43c23          	sd	a5,-168(s0)
    121a:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    121e:	f5840593          	add	a1,s0,-168
    1222:	f6840513          	add	a0,s0,-152
    1226:	00004097          	auipc	ra,0x4
    122a:	408080e7          	jalr	1032(ra) # 562e <exec>
  if(ret != -1){
    122e:	57fd                	li	a5,-1
    1230:	0ef51963          	bne	a0,a5,1322 <copyinstr2+0x172>
  int pid = fork();
    1234:	00004097          	auipc	ra,0x4
    1238:	3ba080e7          	jalr	954(ra) # 55ee <fork>
  if(pid < 0){
    123c:	10054363          	bltz	a0,1342 <copyinstr2+0x192>
  if(pid == 0){
    1240:	12051463          	bnez	a0,1368 <copyinstr2+0x1b8>
    1244:	00007797          	auipc	a5,0x7
    1248:	16c78793          	add	a5,a5,364 # 83b0 <big.0>
    124c:	00008697          	auipc	a3,0x8
    1250:	16468693          	add	a3,a3,356 # 93b0 <__global_pointer$+0x918>
      big[i] = 'x';
    1254:	07800713          	li	a4,120
    1258:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125c:	0785                	add	a5,a5,1
    125e:	fed79de3          	bne	a5,a3,1258 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1262:	00008797          	auipc	a5,0x8
    1266:	14078723          	sb	zero,334(a5) # 93b0 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126a:	00007797          	auipc	a5,0x7
    126e:	be678793          	add	a5,a5,-1050 # 7e50 <malloc+0x243a>
    1272:	6390                	ld	a2,0(a5)
    1274:	6794                	ld	a3,8(a5)
    1276:	6b98                	ld	a4,16(a5)
    1278:	6f9c                	ld	a5,24(a5)
    127a:	f2c43823          	sd	a2,-208(s0)
    127e:	f2d43c23          	sd	a3,-200(s0)
    1282:	f4e43023          	sd	a4,-192(s0)
    1286:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128a:	f3040593          	add	a1,s0,-208
    128e:	00005517          	auipc	a0,0x5
    1292:	8aa50513          	add	a0,a0,-1878 # 5b38 <malloc+0x122>
    1296:	00004097          	auipc	ra,0x4
    129a:	398080e7          	jalr	920(ra) # 562e <exec>
    if(ret != -1){
    129e:	57fd                	li	a5,-1
    12a0:	0af50e63          	beq	a0,a5,135c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a4:	55fd                	li	a1,-1
    12a6:	00005517          	auipc	a0,0x5
    12aa:	09250513          	add	a0,a0,146 # 6338 <malloc+0x922>
    12ae:	00004097          	auipc	ra,0x4
    12b2:	6b0080e7          	jalr	1712(ra) # 595e <printf>
      exit(1);
    12b6:	4505                	li	a0,1
    12b8:	00004097          	auipc	ra,0x4
    12bc:	33e080e7          	jalr	830(ra) # 55f6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c0:	862a                	mv	a2,a0
    12c2:	f6840593          	add	a1,s0,-152
    12c6:	00005517          	auipc	a0,0x5
    12ca:	fea50513          	add	a0,a0,-22 # 62b0 <malloc+0x89a>
    12ce:	00004097          	auipc	ra,0x4
    12d2:	690080e7          	jalr	1680(ra) # 595e <printf>
    exit(1);
    12d6:	4505                	li	a0,1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	31e080e7          	jalr	798(ra) # 55f6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e0:	862a                	mv	a2,a0
    12e2:	f6840593          	add	a1,s0,-152
    12e6:	00005517          	auipc	a0,0x5
    12ea:	fea50513          	add	a0,a0,-22 # 62d0 <malloc+0x8ba>
    12ee:	00004097          	auipc	ra,0x4
    12f2:	670080e7          	jalr	1648(ra) # 595e <printf>
    exit(1);
    12f6:	4505                	li	a0,1
    12f8:	00004097          	auipc	ra,0x4
    12fc:	2fe080e7          	jalr	766(ra) # 55f6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1300:	86aa                	mv	a3,a0
    1302:	f6840613          	add	a2,s0,-152
    1306:	85b2                	mv	a1,a2
    1308:	00005517          	auipc	a0,0x5
    130c:	fe850513          	add	a0,a0,-24 # 62f0 <malloc+0x8da>
    1310:	00004097          	auipc	ra,0x4
    1314:	64e080e7          	jalr	1614(ra) # 595e <printf>
    exit(1);
    1318:	4505                	li	a0,1
    131a:	00004097          	auipc	ra,0x4
    131e:	2dc080e7          	jalr	732(ra) # 55f6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1322:	567d                	li	a2,-1
    1324:	f6840593          	add	a1,s0,-152
    1328:	00005517          	auipc	a0,0x5
    132c:	ff050513          	add	a0,a0,-16 # 6318 <malloc+0x902>
    1330:	00004097          	auipc	ra,0x4
    1334:	62e080e7          	jalr	1582(ra) # 595e <printf>
    exit(1);
    1338:	4505                	li	a0,1
    133a:	00004097          	auipc	ra,0x4
    133e:	2bc080e7          	jalr	700(ra) # 55f6 <exit>
    printf("fork failed\n");
    1342:	00005517          	auipc	a0,0x5
    1346:	45650513          	add	a0,a0,1110 # 6798 <malloc+0xd82>
    134a:	00004097          	auipc	ra,0x4
    134e:	614080e7          	jalr	1556(ra) # 595e <printf>
    exit(1);
    1352:	4505                	li	a0,1
    1354:	00004097          	auipc	ra,0x4
    1358:	2a2080e7          	jalr	674(ra) # 55f6 <exit>
    exit(747); // OK
    135c:	2eb00513          	li	a0,747
    1360:	00004097          	auipc	ra,0x4
    1364:	296080e7          	jalr	662(ra) # 55f6 <exit>
  int st = 0;
    1368:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136c:	f5440513          	add	a0,s0,-172
    1370:	00004097          	auipc	ra,0x4
    1374:	28e080e7          	jalr	654(ra) # 55fe <wait>
  if(st != 747){
    1378:	f5442703          	lw	a4,-172(s0)
    137c:	2eb00793          	li	a5,747
    1380:	00f71663          	bne	a4,a5,138c <copyinstr2+0x1dc>
}
    1384:	60ae                	ld	ra,200(sp)
    1386:	640e                	ld	s0,192(sp)
    1388:	6169                	add	sp,sp,208
    138a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138c:	00005517          	auipc	a0,0x5
    1390:	fd450513          	add	a0,a0,-44 # 6360 <malloc+0x94a>
    1394:	00004097          	auipc	ra,0x4
    1398:	5ca080e7          	jalr	1482(ra) # 595e <printf>
    exit(1);
    139c:	4505                	li	a0,1
    139e:	00004097          	auipc	ra,0x4
    13a2:	258080e7          	jalr	600(ra) # 55f6 <exit>

00000000000013a6 <truncate3>:
{
    13a6:	7159                	add	sp,sp,-112
    13a8:	f486                	sd	ra,104(sp)
    13aa:	f0a2                	sd	s0,96(sp)
    13ac:	eca6                	sd	s1,88(sp)
    13ae:	e8ca                	sd	s2,80(sp)
    13b0:	e4ce                	sd	s3,72(sp)
    13b2:	e0d2                	sd	s4,64(sp)
    13b4:	fc56                	sd	s5,56(sp)
    13b6:	1880                	add	s0,sp,112
    13b8:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13ba:	60100593          	li	a1,1537
    13be:	00004517          	auipc	a0,0x4
    13c2:	7d250513          	add	a0,a0,2002 # 5b90 <malloc+0x17a>
    13c6:	00004097          	auipc	ra,0x4
    13ca:	270080e7          	jalr	624(ra) # 5636 <open>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	250080e7          	jalr	592(ra) # 561e <close>
  pid = fork();
    13d6:	00004097          	auipc	ra,0x4
    13da:	218080e7          	jalr	536(ra) # 55ee <fork>
  if(pid < 0){
    13de:	08054063          	bltz	a0,145e <truncate3+0xb8>
  if(pid == 0){
    13e2:	e969                	bnez	a0,14b4 <truncate3+0x10e>
    13e4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13e8:	00004a17          	auipc	s4,0x4
    13ec:	7a8a0a13          	add	s4,s4,1960 # 5b90 <malloc+0x17a>
      int n = write(fd, "1234567890", 10);
    13f0:	00005a97          	auipc	s5,0x5
    13f4:	fd0a8a93          	add	s5,s5,-48 # 63c0 <malloc+0x9aa>
      int fd = open("truncfile", O_WRONLY);
    13f8:	4585                	li	a1,1
    13fa:	8552                	mv	a0,s4
    13fc:	00004097          	auipc	ra,0x4
    1400:	23a080e7          	jalr	570(ra) # 5636 <open>
    1404:	84aa                	mv	s1,a0
      if(fd < 0){
    1406:	06054a63          	bltz	a0,147a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140a:	4629                	li	a2,10
    140c:	85d6                	mv	a1,s5
    140e:	00004097          	auipc	ra,0x4
    1412:	208080e7          	jalr	520(ra) # 5616 <write>
      if(n != 10){
    1416:	47a9                	li	a5,10
    1418:	06f51f63          	bne	a0,a5,1496 <truncate3+0xf0>
      close(fd);
    141c:	8526                	mv	a0,s1
    141e:	00004097          	auipc	ra,0x4
    1422:	200080e7          	jalr	512(ra) # 561e <close>
      fd = open("truncfile", O_RDONLY);
    1426:	4581                	li	a1,0
    1428:	8552                	mv	a0,s4
    142a:	00004097          	auipc	ra,0x4
    142e:	20c080e7          	jalr	524(ra) # 5636 <open>
    1432:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1434:	02000613          	li	a2,32
    1438:	f9840593          	add	a1,s0,-104
    143c:	00004097          	auipc	ra,0x4
    1440:	1d2080e7          	jalr	466(ra) # 560e <read>
      close(fd);
    1444:	8526                	mv	a0,s1
    1446:	00004097          	auipc	ra,0x4
    144a:	1d8080e7          	jalr	472(ra) # 561e <close>
    for(int i = 0; i < 100; i++){
    144e:	39fd                	addw	s3,s3,-1
    1450:	fa0994e3          	bnez	s3,13f8 <truncate3+0x52>
    exit(0);
    1454:	4501                	li	a0,0
    1456:	00004097          	auipc	ra,0x4
    145a:	1a0080e7          	jalr	416(ra) # 55f6 <exit>
    printf("%s: fork failed\n", s);
    145e:	85ca                	mv	a1,s2
    1460:	00005517          	auipc	a0,0x5
    1464:	f3050513          	add	a0,a0,-208 # 6390 <malloc+0x97a>
    1468:	00004097          	auipc	ra,0x4
    146c:	4f6080e7          	jalr	1270(ra) # 595e <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	00004097          	auipc	ra,0x4
    1476:	184080e7          	jalr	388(ra) # 55f6 <exit>
        printf("%s: open failed\n", s);
    147a:	85ca                	mv	a1,s2
    147c:	00005517          	auipc	a0,0x5
    1480:	f2c50513          	add	a0,a0,-212 # 63a8 <malloc+0x992>
    1484:	00004097          	auipc	ra,0x4
    1488:	4da080e7          	jalr	1242(ra) # 595e <printf>
        exit(1);
    148c:	4505                	li	a0,1
    148e:	00004097          	auipc	ra,0x4
    1492:	168080e7          	jalr	360(ra) # 55f6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1496:	862a                	mv	a2,a0
    1498:	85ca                	mv	a1,s2
    149a:	00005517          	auipc	a0,0x5
    149e:	f3650513          	add	a0,a0,-202 # 63d0 <malloc+0x9ba>
    14a2:	00004097          	auipc	ra,0x4
    14a6:	4bc080e7          	jalr	1212(ra) # 595e <printf>
        exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	14a080e7          	jalr	330(ra) # 55f6 <exit>
    14b4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14b8:	00004a17          	auipc	s4,0x4
    14bc:	6d8a0a13          	add	s4,s4,1752 # 5b90 <malloc+0x17a>
    int n = write(fd, "xxx", 3);
    14c0:	00005a97          	auipc	s5,0x5
    14c4:	f30a8a93          	add	s5,s5,-208 # 63f0 <malloc+0x9da>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c8:	60100593          	li	a1,1537
    14cc:	8552                	mv	a0,s4
    14ce:	00004097          	auipc	ra,0x4
    14d2:	168080e7          	jalr	360(ra) # 5636 <open>
    14d6:	84aa                	mv	s1,a0
    if(fd < 0){
    14d8:	04054763          	bltz	a0,1526 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14dc:	460d                	li	a2,3
    14de:	85d6                	mv	a1,s5
    14e0:	00004097          	auipc	ra,0x4
    14e4:	136080e7          	jalr	310(ra) # 5616 <write>
    if(n != 3){
    14e8:	478d                	li	a5,3
    14ea:	04f51c63          	bne	a0,a5,1542 <truncate3+0x19c>
    close(fd);
    14ee:	8526                	mv	a0,s1
    14f0:	00004097          	auipc	ra,0x4
    14f4:	12e080e7          	jalr	302(ra) # 561e <close>
  for(int i = 0; i < 150; i++){
    14f8:	39fd                	addw	s3,s3,-1
    14fa:	fc0997e3          	bnez	s3,14c8 <truncate3+0x122>
  wait(&xstatus);
    14fe:	fbc40513          	add	a0,s0,-68
    1502:	00004097          	auipc	ra,0x4
    1506:	0fc080e7          	jalr	252(ra) # 55fe <wait>
  unlink("truncfile");
    150a:	00004517          	auipc	a0,0x4
    150e:	68650513          	add	a0,a0,1670 # 5b90 <malloc+0x17a>
    1512:	00004097          	auipc	ra,0x4
    1516:	134080e7          	jalr	308(ra) # 5646 <unlink>
  exit(xstatus);
    151a:	fbc42503          	lw	a0,-68(s0)
    151e:	00004097          	auipc	ra,0x4
    1522:	0d8080e7          	jalr	216(ra) # 55f6 <exit>
      printf("%s: open failed\n", s);
    1526:	85ca                	mv	a1,s2
    1528:	00005517          	auipc	a0,0x5
    152c:	e8050513          	add	a0,a0,-384 # 63a8 <malloc+0x992>
    1530:	00004097          	auipc	ra,0x4
    1534:	42e080e7          	jalr	1070(ra) # 595e <printf>
      exit(1);
    1538:	4505                	li	a0,1
    153a:	00004097          	auipc	ra,0x4
    153e:	0bc080e7          	jalr	188(ra) # 55f6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1542:	862a                	mv	a2,a0
    1544:	85ca                	mv	a1,s2
    1546:	00005517          	auipc	a0,0x5
    154a:	eb250513          	add	a0,a0,-334 # 63f8 <malloc+0x9e2>
    154e:	00004097          	auipc	ra,0x4
    1552:	410080e7          	jalr	1040(ra) # 595e <printf>
      exit(1);
    1556:	4505                	li	a0,1
    1558:	00004097          	auipc	ra,0x4
    155c:	09e080e7          	jalr	158(ra) # 55f6 <exit>

0000000000001560 <exectest>:
{
    1560:	715d                	add	sp,sp,-80
    1562:	e486                	sd	ra,72(sp)
    1564:	e0a2                	sd	s0,64(sp)
    1566:	fc26                	sd	s1,56(sp)
    1568:	f84a                	sd	s2,48(sp)
    156a:	0880                	add	s0,sp,80
    156c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    156e:	00004797          	auipc	a5,0x4
    1572:	5ca78793          	add	a5,a5,1482 # 5b38 <malloc+0x122>
    1576:	fcf43023          	sd	a5,-64(s0)
    157a:	00005797          	auipc	a5,0x5
    157e:	e9e78793          	add	a5,a5,-354 # 6418 <malloc+0xa02>
    1582:	fcf43423          	sd	a5,-56(s0)
    1586:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158a:	00005517          	auipc	a0,0x5
    158e:	e9650513          	add	a0,a0,-362 # 6420 <malloc+0xa0a>
    1592:	00004097          	auipc	ra,0x4
    1596:	0b4080e7          	jalr	180(ra) # 5646 <unlink>
  pid = fork();
    159a:	00004097          	auipc	ra,0x4
    159e:	054080e7          	jalr	84(ra) # 55ee <fork>
  if(pid < 0) {
    15a2:	04054663          	bltz	a0,15ee <exectest+0x8e>
    15a6:	84aa                	mv	s1,a0
  if(pid == 0) {
    15a8:	e959                	bnez	a0,163e <exectest+0xde>
    close(1);
    15aa:	4505                	li	a0,1
    15ac:	00004097          	auipc	ra,0x4
    15b0:	072080e7          	jalr	114(ra) # 561e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b4:	20100593          	li	a1,513
    15b8:	00005517          	auipc	a0,0x5
    15bc:	e6850513          	add	a0,a0,-408 # 6420 <malloc+0xa0a>
    15c0:	00004097          	auipc	ra,0x4
    15c4:	076080e7          	jalr	118(ra) # 5636 <open>
    if(fd < 0) {
    15c8:	04054163          	bltz	a0,160a <exectest+0xaa>
    if(fd != 1) {
    15cc:	4785                	li	a5,1
    15ce:	04f50c63          	beq	a0,a5,1626 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d2:	85ca                	mv	a1,s2
    15d4:	00005517          	auipc	a0,0x5
    15d8:	e6c50513          	add	a0,a0,-404 # 6440 <malloc+0xa2a>
    15dc:	00004097          	auipc	ra,0x4
    15e0:	382080e7          	jalr	898(ra) # 595e <printf>
      exit(1);
    15e4:	4505                	li	a0,1
    15e6:	00004097          	auipc	ra,0x4
    15ea:	010080e7          	jalr	16(ra) # 55f6 <exit>
     printf("%s: fork failed\n", s);
    15ee:	85ca                	mv	a1,s2
    15f0:	00005517          	auipc	a0,0x5
    15f4:	da050513          	add	a0,a0,-608 # 6390 <malloc+0x97a>
    15f8:	00004097          	auipc	ra,0x4
    15fc:	366080e7          	jalr	870(ra) # 595e <printf>
     exit(1);
    1600:	4505                	li	a0,1
    1602:	00004097          	auipc	ra,0x4
    1606:	ff4080e7          	jalr	-12(ra) # 55f6 <exit>
      printf("%s: create failed\n", s);
    160a:	85ca                	mv	a1,s2
    160c:	00005517          	auipc	a0,0x5
    1610:	e1c50513          	add	a0,a0,-484 # 6428 <malloc+0xa12>
    1614:	00004097          	auipc	ra,0x4
    1618:	34a080e7          	jalr	842(ra) # 595e <printf>
      exit(1);
    161c:	4505                	li	a0,1
    161e:	00004097          	auipc	ra,0x4
    1622:	fd8080e7          	jalr	-40(ra) # 55f6 <exit>
    if(exec("echo", echoargv) < 0){
    1626:	fc040593          	add	a1,s0,-64
    162a:	00004517          	auipc	a0,0x4
    162e:	50e50513          	add	a0,a0,1294 # 5b38 <malloc+0x122>
    1632:	00004097          	auipc	ra,0x4
    1636:	ffc080e7          	jalr	-4(ra) # 562e <exec>
    163a:	02054163          	bltz	a0,165c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    163e:	fdc40513          	add	a0,s0,-36
    1642:	00004097          	auipc	ra,0x4
    1646:	fbc080e7          	jalr	-68(ra) # 55fe <wait>
    164a:	02951763          	bne	a0,s1,1678 <exectest+0x118>
  if(xstatus != 0)
    164e:	fdc42503          	lw	a0,-36(s0)
    1652:	cd0d                	beqz	a0,168c <exectest+0x12c>
    exit(xstatus);
    1654:	00004097          	auipc	ra,0x4
    1658:	fa2080e7          	jalr	-94(ra) # 55f6 <exit>
      printf("%s: exec echo failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	df250513          	add	a0,a0,-526 # 6450 <malloc+0xa3a>
    1666:	00004097          	auipc	ra,0x4
    166a:	2f8080e7          	jalr	760(ra) # 595e <printf>
      exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	f86080e7          	jalr	-122(ra) # 55f6 <exit>
    printf("%s: wait failed!\n", s);
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	dee50513          	add	a0,a0,-530 # 6468 <malloc+0xa52>
    1682:	00004097          	auipc	ra,0x4
    1686:	2dc080e7          	jalr	732(ra) # 595e <printf>
    168a:	b7d1                	j	164e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168c:	4581                	li	a1,0
    168e:	00005517          	auipc	a0,0x5
    1692:	d9250513          	add	a0,a0,-622 # 6420 <malloc+0xa0a>
    1696:	00004097          	auipc	ra,0x4
    169a:	fa0080e7          	jalr	-96(ra) # 5636 <open>
  if(fd < 0) {
    169e:	02054a63          	bltz	a0,16d2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a2:	4609                	li	a2,2
    16a4:	fb840593          	add	a1,s0,-72
    16a8:	00004097          	auipc	ra,0x4
    16ac:	f66080e7          	jalr	-154(ra) # 560e <read>
    16b0:	4789                	li	a5,2
    16b2:	02f50e63          	beq	a0,a5,16ee <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b6:	85ca                	mv	a1,s2
    16b8:	00005517          	auipc	a0,0x5
    16bc:	82050513          	add	a0,a0,-2016 # 5ed8 <malloc+0x4c2>
    16c0:	00004097          	auipc	ra,0x4
    16c4:	29e080e7          	jalr	670(ra) # 595e <printf>
    exit(1);
    16c8:	4505                	li	a0,1
    16ca:	00004097          	auipc	ra,0x4
    16ce:	f2c080e7          	jalr	-212(ra) # 55f6 <exit>
    printf("%s: open failed\n", s);
    16d2:	85ca                	mv	a1,s2
    16d4:	00005517          	auipc	a0,0x5
    16d8:	cd450513          	add	a0,a0,-812 # 63a8 <malloc+0x992>
    16dc:	00004097          	auipc	ra,0x4
    16e0:	282080e7          	jalr	642(ra) # 595e <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00004097          	auipc	ra,0x4
    16ea:	f10080e7          	jalr	-240(ra) # 55f6 <exit>
  unlink("echo-ok");
    16ee:	00005517          	auipc	a0,0x5
    16f2:	d3250513          	add	a0,a0,-718 # 6420 <malloc+0xa0a>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	f50080e7          	jalr	-176(ra) # 5646 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    16fe:	fb844703          	lbu	a4,-72(s0)
    1702:	04f00793          	li	a5,79
    1706:	00f71863          	bne	a4,a5,1716 <exectest+0x1b6>
    170a:	fb944703          	lbu	a4,-71(s0)
    170e:	04b00793          	li	a5,75
    1712:	02f70063          	beq	a4,a5,1732 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	d6850513          	add	a0,a0,-664 # 6480 <malloc+0xa6a>
    1720:	00004097          	auipc	ra,0x4
    1724:	23e080e7          	jalr	574(ra) # 595e <printf>
    exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	ecc080e7          	jalr	-308(ra) # 55f6 <exit>
    exit(0);
    1732:	4501                	li	a0,0
    1734:	00004097          	auipc	ra,0x4
    1738:	ec2080e7          	jalr	-318(ra) # 55f6 <exit>

000000000000173c <pipe1>:
{
    173c:	711d                	add	sp,sp,-96
    173e:	ec86                	sd	ra,88(sp)
    1740:	e8a2                	sd	s0,80(sp)
    1742:	e4a6                	sd	s1,72(sp)
    1744:	e0ca                	sd	s2,64(sp)
    1746:	fc4e                	sd	s3,56(sp)
    1748:	f852                	sd	s4,48(sp)
    174a:	f456                	sd	s5,40(sp)
    174c:	f05a                	sd	s6,32(sp)
    174e:	ec5e                	sd	s7,24(sp)
    1750:	1080                	add	s0,sp,96
    1752:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1754:	fa840513          	add	a0,s0,-88
    1758:	00004097          	auipc	ra,0x4
    175c:	eae080e7          	jalr	-338(ra) # 5606 <pipe>
    1760:	e93d                	bnez	a0,17d6 <pipe1+0x9a>
    1762:	84aa                	mv	s1,a0
  pid = fork();
    1764:	00004097          	auipc	ra,0x4
    1768:	e8a080e7          	jalr	-374(ra) # 55ee <fork>
    176c:	8a2a                	mv	s4,a0
  if(pid == 0){
    176e:	c151                	beqz	a0,17f2 <pipe1+0xb6>
  } else if(pid > 0){
    1770:	16a05d63          	blez	a0,18ea <pipe1+0x1ae>
    close(fds[1]);
    1774:	fac42503          	lw	a0,-84(s0)
    1778:	00004097          	auipc	ra,0x4
    177c:	ea6080e7          	jalr	-346(ra) # 561e <close>
    total = 0;
    1780:	8a26                	mv	s4,s1
    cc = 1;
    1782:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1784:	0000aa97          	auipc	s5,0xa
    1788:	344a8a93          	add	s5,s5,836 # bac8 <buf>
    178c:	864e                	mv	a2,s3
    178e:	85d6                	mv	a1,s5
    1790:	fa842503          	lw	a0,-88(s0)
    1794:	00004097          	auipc	ra,0x4
    1798:	e7a080e7          	jalr	-390(ra) # 560e <read>
    179c:	10a05263          	blez	a0,18a0 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a0:	0000a717          	auipc	a4,0xa
    17a4:	32870713          	add	a4,a4,808 # bac8 <buf>
    17a8:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ac:	00074683          	lbu	a3,0(a4)
    17b0:	0ff4f793          	zext.b	a5,s1
    17b4:	2485                	addw	s1,s1,1
    17b6:	0cf69163          	bne	a3,a5,1878 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17ba:	0705                	add	a4,a4,1
    17bc:	fec498e3          	bne	s1,a2,17ac <pipe1+0x70>
      total += n;
    17c0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c4:	0019979b          	sllw	a5,s3,0x1
    17c8:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17cc:	670d                	lui	a4,0x3
    17ce:	fb377fe3          	bgeu	a4,s3,178c <pipe1+0x50>
        cc = sizeof(buf);
    17d2:	698d                	lui	s3,0x3
    17d4:	bf65                	j	178c <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    17d6:	85ca                	mv	a1,s2
    17d8:	00005517          	auipc	a0,0x5
    17dc:	cc050513          	add	a0,a0,-832 # 6498 <malloc+0xa82>
    17e0:	00004097          	auipc	ra,0x4
    17e4:	17e080e7          	jalr	382(ra) # 595e <printf>
    exit(1);
    17e8:	4505                	li	a0,1
    17ea:	00004097          	auipc	ra,0x4
    17ee:	e0c080e7          	jalr	-500(ra) # 55f6 <exit>
    close(fds[0]);
    17f2:	fa842503          	lw	a0,-88(s0)
    17f6:	00004097          	auipc	ra,0x4
    17fa:	e28080e7          	jalr	-472(ra) # 561e <close>
    for(n = 0; n < N; n++){
    17fe:	0000ab17          	auipc	s6,0xa
    1802:	2cab0b13          	add	s6,s6,714 # bac8 <buf>
    1806:	416004bb          	negw	s1,s6
    180a:	0ff4f493          	zext.b	s1,s1
    180e:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1812:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1814:	6a85                	lui	s5,0x1
    1816:	42da8a93          	add	s5,s5,1069 # 142d <truncate3+0x87>
{
    181a:	87da                	mv	a5,s6
        buf[i] = seq++;
    181c:	0097873b          	addw	a4,a5,s1
    1820:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1824:	0785                	add	a5,a5,1
    1826:	fef99be3          	bne	s3,a5,181c <pipe1+0xe0>
        buf[i] = seq++;
    182a:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    182e:	40900613          	li	a2,1033
    1832:	85de                	mv	a1,s7
    1834:	fac42503          	lw	a0,-84(s0)
    1838:	00004097          	auipc	ra,0x4
    183c:	dde080e7          	jalr	-546(ra) # 5616 <write>
    1840:	40900793          	li	a5,1033
    1844:	00f51c63          	bne	a0,a5,185c <pipe1+0x120>
    for(n = 0; n < N; n++){
    1848:	24a5                	addw	s1,s1,9
    184a:	0ff4f493          	zext.b	s1,s1
    184e:	fd5a16e3          	bne	s4,s5,181a <pipe1+0xde>
    exit(0);
    1852:	4501                	li	a0,0
    1854:	00004097          	auipc	ra,0x4
    1858:	da2080e7          	jalr	-606(ra) # 55f6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    185c:	85ca                	mv	a1,s2
    185e:	00005517          	auipc	a0,0x5
    1862:	c5250513          	add	a0,a0,-942 # 64b0 <malloc+0xa9a>
    1866:	00004097          	auipc	ra,0x4
    186a:	0f8080e7          	jalr	248(ra) # 595e <printf>
        exit(1);
    186e:	4505                	li	a0,1
    1870:	00004097          	auipc	ra,0x4
    1874:	d86080e7          	jalr	-634(ra) # 55f6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1878:	85ca                	mv	a1,s2
    187a:	00005517          	auipc	a0,0x5
    187e:	c4e50513          	add	a0,a0,-946 # 64c8 <malloc+0xab2>
    1882:	00004097          	auipc	ra,0x4
    1886:	0dc080e7          	jalr	220(ra) # 595e <printf>
}
    188a:	60e6                	ld	ra,88(sp)
    188c:	6446                	ld	s0,80(sp)
    188e:	64a6                	ld	s1,72(sp)
    1890:	6906                	ld	s2,64(sp)
    1892:	79e2                	ld	s3,56(sp)
    1894:	7a42                	ld	s4,48(sp)
    1896:	7aa2                	ld	s5,40(sp)
    1898:	7b02                	ld	s6,32(sp)
    189a:	6be2                	ld	s7,24(sp)
    189c:	6125                	add	sp,sp,96
    189e:	8082                	ret
    if(total != N * SZ){
    18a0:	6785                	lui	a5,0x1
    18a2:	42d78793          	add	a5,a5,1069 # 142d <truncate3+0x87>
    18a6:	02fa0063          	beq	s4,a5,18c6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18aa:	85d2                	mv	a1,s4
    18ac:	00005517          	auipc	a0,0x5
    18b0:	c3450513          	add	a0,a0,-972 # 64e0 <malloc+0xaca>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	0aa080e7          	jalr	170(ra) # 595e <printf>
      exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	d38080e7          	jalr	-712(ra) # 55f6 <exit>
    close(fds[0]);
    18c6:	fa842503          	lw	a0,-88(s0)
    18ca:	00004097          	auipc	ra,0x4
    18ce:	d54080e7          	jalr	-684(ra) # 561e <close>
    wait(&xstatus);
    18d2:	fa440513          	add	a0,s0,-92
    18d6:	00004097          	auipc	ra,0x4
    18da:	d28080e7          	jalr	-728(ra) # 55fe <wait>
    exit(xstatus);
    18de:	fa442503          	lw	a0,-92(s0)
    18e2:	00004097          	auipc	ra,0x4
    18e6:	d14080e7          	jalr	-748(ra) # 55f6 <exit>
    printf("%s: fork() failed\n", s);
    18ea:	85ca                	mv	a1,s2
    18ec:	00005517          	auipc	a0,0x5
    18f0:	c1450513          	add	a0,a0,-1004 # 6500 <malloc+0xaea>
    18f4:	00004097          	auipc	ra,0x4
    18f8:	06a080e7          	jalr	106(ra) # 595e <printf>
    exit(1);
    18fc:	4505                	li	a0,1
    18fe:	00004097          	auipc	ra,0x4
    1902:	cf8080e7          	jalr	-776(ra) # 55f6 <exit>

0000000000001906 <exitwait>:
{
    1906:	7139                	add	sp,sp,-64
    1908:	fc06                	sd	ra,56(sp)
    190a:	f822                	sd	s0,48(sp)
    190c:	f426                	sd	s1,40(sp)
    190e:	f04a                	sd	s2,32(sp)
    1910:	ec4e                	sd	s3,24(sp)
    1912:	e852                	sd	s4,16(sp)
    1914:	0080                	add	s0,sp,64
    1916:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1918:	4901                	li	s2,0
    191a:	06400993          	li	s3,100
    pid = fork();
    191e:	00004097          	auipc	ra,0x4
    1922:	cd0080e7          	jalr	-816(ra) # 55ee <fork>
    1926:	84aa                	mv	s1,a0
    if(pid < 0){
    1928:	02054a63          	bltz	a0,195c <exitwait+0x56>
    if(pid){
    192c:	c151                	beqz	a0,19b0 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    192e:	fcc40513          	add	a0,s0,-52
    1932:	00004097          	auipc	ra,0x4
    1936:	ccc080e7          	jalr	-820(ra) # 55fe <wait>
    193a:	02951f63          	bne	a0,s1,1978 <exitwait+0x72>
      if(i != xstate) {
    193e:	fcc42783          	lw	a5,-52(s0)
    1942:	05279963          	bne	a5,s2,1994 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1946:	2905                	addw	s2,s2,1
    1948:	fd391be3          	bne	s2,s3,191e <exitwait+0x18>
}
    194c:	70e2                	ld	ra,56(sp)
    194e:	7442                	ld	s0,48(sp)
    1950:	74a2                	ld	s1,40(sp)
    1952:	7902                	ld	s2,32(sp)
    1954:	69e2                	ld	s3,24(sp)
    1956:	6a42                	ld	s4,16(sp)
    1958:	6121                	add	sp,sp,64
    195a:	8082                	ret
      printf("%s: fork failed\n", s);
    195c:	85d2                	mv	a1,s4
    195e:	00005517          	auipc	a0,0x5
    1962:	a3250513          	add	a0,a0,-1486 # 6390 <malloc+0x97a>
    1966:	00004097          	auipc	ra,0x4
    196a:	ff8080e7          	jalr	-8(ra) # 595e <printf>
      exit(1);
    196e:	4505                	li	a0,1
    1970:	00004097          	auipc	ra,0x4
    1974:	c86080e7          	jalr	-890(ra) # 55f6 <exit>
        printf("%s: wait wrong pid\n", s);
    1978:	85d2                	mv	a1,s4
    197a:	00005517          	auipc	a0,0x5
    197e:	b9e50513          	add	a0,a0,-1122 # 6518 <malloc+0xb02>
    1982:	00004097          	auipc	ra,0x4
    1986:	fdc080e7          	jalr	-36(ra) # 595e <printf>
        exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	c6a080e7          	jalr	-918(ra) # 55f6 <exit>
        printf("%s: wait wrong exit status\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	b9a50513          	add	a0,a0,-1126 # 6530 <malloc+0xb1a>
    199e:	00004097          	auipc	ra,0x4
    19a2:	fc0080e7          	jalr	-64(ra) # 595e <printf>
        exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	c4e080e7          	jalr	-946(ra) # 55f6 <exit>
      exit(i);
    19b0:	854a                	mv	a0,s2
    19b2:	00004097          	auipc	ra,0x4
    19b6:	c44080e7          	jalr	-956(ra) # 55f6 <exit>

00000000000019ba <twochildren>:
{
    19ba:	1101                	add	sp,sp,-32
    19bc:	ec06                	sd	ra,24(sp)
    19be:	e822                	sd	s0,16(sp)
    19c0:	e426                	sd	s1,8(sp)
    19c2:	e04a                	sd	s2,0(sp)
    19c4:	1000                	add	s0,sp,32
    19c6:	892a                	mv	s2,a0
    19c8:	3e800493          	li	s1,1000
    int pid1 = fork();
    19cc:	00004097          	auipc	ra,0x4
    19d0:	c22080e7          	jalr	-990(ra) # 55ee <fork>
    if(pid1 < 0){
    19d4:	02054c63          	bltz	a0,1a0c <twochildren+0x52>
    if(pid1 == 0){
    19d8:	c921                	beqz	a0,1a28 <twochildren+0x6e>
      int pid2 = fork();
    19da:	00004097          	auipc	ra,0x4
    19de:	c14080e7          	jalr	-1004(ra) # 55ee <fork>
      if(pid2 < 0){
    19e2:	04054763          	bltz	a0,1a30 <twochildren+0x76>
      if(pid2 == 0){
    19e6:	c13d                	beqz	a0,1a4c <twochildren+0x92>
        wait(0);
    19e8:	4501                	li	a0,0
    19ea:	00004097          	auipc	ra,0x4
    19ee:	c14080e7          	jalr	-1004(ra) # 55fe <wait>
        wait(0);
    19f2:	4501                	li	a0,0
    19f4:	00004097          	auipc	ra,0x4
    19f8:	c0a080e7          	jalr	-1014(ra) # 55fe <wait>
  for(int i = 0; i < 1000; i++){
    19fc:	34fd                	addw	s1,s1,-1
    19fe:	f4f9                	bnez	s1,19cc <twochildren+0x12>
}
    1a00:	60e2                	ld	ra,24(sp)
    1a02:	6442                	ld	s0,16(sp)
    1a04:	64a2                	ld	s1,8(sp)
    1a06:	6902                	ld	s2,0(sp)
    1a08:	6105                	add	sp,sp,32
    1a0a:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0c:	85ca                	mv	a1,s2
    1a0e:	00005517          	auipc	a0,0x5
    1a12:	98250513          	add	a0,a0,-1662 # 6390 <malloc+0x97a>
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	f48080e7          	jalr	-184(ra) # 595e <printf>
      exit(1);
    1a1e:	4505                	li	a0,1
    1a20:	00004097          	auipc	ra,0x4
    1a24:	bd6080e7          	jalr	-1066(ra) # 55f6 <exit>
      exit(0);
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	bce080e7          	jalr	-1074(ra) # 55f6 <exit>
        printf("%s: fork failed\n", s);
    1a30:	85ca                	mv	a1,s2
    1a32:	00005517          	auipc	a0,0x5
    1a36:	95e50513          	add	a0,a0,-1698 # 6390 <malloc+0x97a>
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	f24080e7          	jalr	-220(ra) # 595e <printf>
        exit(1);
    1a42:	4505                	li	a0,1
    1a44:	00004097          	auipc	ra,0x4
    1a48:	bb2080e7          	jalr	-1102(ra) # 55f6 <exit>
        exit(0);
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	baa080e7          	jalr	-1110(ra) # 55f6 <exit>

0000000000001a54 <forkfork>:
{
    1a54:	7179                	add	sp,sp,-48
    1a56:	f406                	sd	ra,40(sp)
    1a58:	f022                	sd	s0,32(sp)
    1a5a:	ec26                	sd	s1,24(sp)
    1a5c:	1800                	add	s0,sp,48
    1a5e:	84aa                	mv	s1,a0
    int pid = fork();
    1a60:	00004097          	auipc	ra,0x4
    1a64:	b8e080e7          	jalr	-1138(ra) # 55ee <fork>
    if(pid < 0){
    1a68:	04054163          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a6c:	cd29                	beqz	a0,1ac6 <forkfork+0x72>
    int pid = fork();
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	b80080e7          	jalr	-1152(ra) # 55ee <fork>
    if(pid < 0){
    1a76:	02054a63          	bltz	a0,1aaa <forkfork+0x56>
    if(pid == 0){
    1a7a:	c531                	beqz	a0,1ac6 <forkfork+0x72>
    wait(&xstatus);
    1a7c:	fdc40513          	add	a0,s0,-36
    1a80:	00004097          	auipc	ra,0x4
    1a84:	b7e080e7          	jalr	-1154(ra) # 55fe <wait>
    if(xstatus != 0) {
    1a88:	fdc42783          	lw	a5,-36(s0)
    1a8c:	ebbd                	bnez	a5,1b02 <forkfork+0xae>
    wait(&xstatus);
    1a8e:	fdc40513          	add	a0,s0,-36
    1a92:	00004097          	auipc	ra,0x4
    1a96:	b6c080e7          	jalr	-1172(ra) # 55fe <wait>
    if(xstatus != 0) {
    1a9a:	fdc42783          	lw	a5,-36(s0)
    1a9e:	e3b5                	bnez	a5,1b02 <forkfork+0xae>
}
    1aa0:	70a2                	ld	ra,40(sp)
    1aa2:	7402                	ld	s0,32(sp)
    1aa4:	64e2                	ld	s1,24(sp)
    1aa6:	6145                	add	sp,sp,48
    1aa8:	8082                	ret
      printf("%s: fork failed", s);
    1aaa:	85a6                	mv	a1,s1
    1aac:	00005517          	auipc	a0,0x5
    1ab0:	aa450513          	add	a0,a0,-1372 # 6550 <malloc+0xb3a>
    1ab4:	00004097          	auipc	ra,0x4
    1ab8:	eaa080e7          	jalr	-342(ra) # 595e <printf>
      exit(1);
    1abc:	4505                	li	a0,1
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	b38080e7          	jalr	-1224(ra) # 55f6 <exit>
{
    1ac6:	0c800493          	li	s1,200
        int pid1 = fork();
    1aca:	00004097          	auipc	ra,0x4
    1ace:	b24080e7          	jalr	-1244(ra) # 55ee <fork>
        if(pid1 < 0){
    1ad2:	00054f63          	bltz	a0,1af0 <forkfork+0x9c>
        if(pid1 == 0){
    1ad6:	c115                	beqz	a0,1afa <forkfork+0xa6>
        wait(0);
    1ad8:	4501                	li	a0,0
    1ada:	00004097          	auipc	ra,0x4
    1ade:	b24080e7          	jalr	-1244(ra) # 55fe <wait>
      for(int j = 0; j < 200; j++){
    1ae2:	34fd                	addw	s1,s1,-1
    1ae4:	f0fd                	bnez	s1,1aca <forkfork+0x76>
      exit(0);
    1ae6:	4501                	li	a0,0
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	b0e080e7          	jalr	-1266(ra) # 55f6 <exit>
          exit(1);
    1af0:	4505                	li	a0,1
    1af2:	00004097          	auipc	ra,0x4
    1af6:	b04080e7          	jalr	-1276(ra) # 55f6 <exit>
          exit(0);
    1afa:	00004097          	auipc	ra,0x4
    1afe:	afc080e7          	jalr	-1284(ra) # 55f6 <exit>
      printf("%s: fork in child failed", s);
    1b02:	85a6                	mv	a1,s1
    1b04:	00005517          	auipc	a0,0x5
    1b08:	a5c50513          	add	a0,a0,-1444 # 6560 <malloc+0xb4a>
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	e52080e7          	jalr	-430(ra) # 595e <printf>
      exit(1);
    1b14:	4505                	li	a0,1
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	ae0080e7          	jalr	-1312(ra) # 55f6 <exit>

0000000000001b1e <reparent2>:
{
    1b1e:	1101                	add	sp,sp,-32
    1b20:	ec06                	sd	ra,24(sp)
    1b22:	e822                	sd	s0,16(sp)
    1b24:	e426                	sd	s1,8(sp)
    1b26:	1000                	add	s0,sp,32
    1b28:	32000493          	li	s1,800
    int pid1 = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	ac2080e7          	jalr	-1342(ra) # 55ee <fork>
    if(pid1 < 0){
    1b34:	00054f63          	bltz	a0,1b52 <reparent2+0x34>
    if(pid1 == 0){
    1b38:	c915                	beqz	a0,1b6c <reparent2+0x4e>
    wait(0);
    1b3a:	4501                	li	a0,0
    1b3c:	00004097          	auipc	ra,0x4
    1b40:	ac2080e7          	jalr	-1342(ra) # 55fe <wait>
  for(int i = 0; i < 800; i++){
    1b44:	34fd                	addw	s1,s1,-1
    1b46:	f0fd                	bnez	s1,1b2c <reparent2+0xe>
  exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	aac080e7          	jalr	-1364(ra) # 55f6 <exit>
      printf("fork failed\n");
    1b52:	00005517          	auipc	a0,0x5
    1b56:	c4650513          	add	a0,a0,-954 # 6798 <malloc+0xd82>
    1b5a:	00004097          	auipc	ra,0x4
    1b5e:	e04080e7          	jalr	-508(ra) # 595e <printf>
      exit(1);
    1b62:	4505                	li	a0,1
    1b64:	00004097          	auipc	ra,0x4
    1b68:	a92080e7          	jalr	-1390(ra) # 55f6 <exit>
      fork();
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	a82080e7          	jalr	-1406(ra) # 55ee <fork>
      fork();
    1b74:	00004097          	auipc	ra,0x4
    1b78:	a7a080e7          	jalr	-1414(ra) # 55ee <fork>
      exit(0);
    1b7c:	4501                	li	a0,0
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	a78080e7          	jalr	-1416(ra) # 55f6 <exit>

0000000000001b86 <createdelete>:
{
    1b86:	7175                	add	sp,sp,-144
    1b88:	e506                	sd	ra,136(sp)
    1b8a:	e122                	sd	s0,128(sp)
    1b8c:	fca6                	sd	s1,120(sp)
    1b8e:	f8ca                	sd	s2,112(sp)
    1b90:	f4ce                	sd	s3,104(sp)
    1b92:	f0d2                	sd	s4,96(sp)
    1b94:	ecd6                	sd	s5,88(sp)
    1b96:	e8da                	sd	s6,80(sp)
    1b98:	e4de                	sd	s7,72(sp)
    1b9a:	e0e2                	sd	s8,64(sp)
    1b9c:	fc66                	sd	s9,56(sp)
    1b9e:	0900                	add	s0,sp,144
    1ba0:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba2:	4901                	li	s2,0
    1ba4:	4991                	li	s3,4
    pid = fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	a48080e7          	jalr	-1464(ra) # 55ee <fork>
    1bae:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb0:	02054f63          	bltz	a0,1bee <createdelete+0x68>
    if(pid == 0){
    1bb4:	c939                	beqz	a0,1c0a <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bb6:	2905                	addw	s2,s2,1
    1bb8:	ff3917e3          	bne	s2,s3,1ba6 <createdelete+0x20>
    1bbc:	4491                	li	s1,4
    wait(&xstatus);
    1bbe:	f7c40513          	add	a0,s0,-132
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	a3c080e7          	jalr	-1476(ra) # 55fe <wait>
    if(xstatus != 0)
    1bca:	f7c42903          	lw	s2,-132(s0)
    1bce:	0e091263          	bnez	s2,1cb2 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd2:	34fd                	addw	s1,s1,-1
    1bd4:	f4ed                	bnez	s1,1bbe <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bd6:	f8040123          	sb	zero,-126(s0)
    1bda:	03000993          	li	s3,48
    1bde:	5a7d                	li	s4,-1
    1be0:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be4:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1be6:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1be8:	07400a93          	li	s5,116
    1bec:	a29d                	j	1d52 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bee:	85e6                	mv	a1,s9
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	ba850513          	add	a0,a0,-1112 # 6798 <malloc+0xd82>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	d66080e7          	jalr	-666(ra) # 595e <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	9f4080e7          	jalr	-1548(ra) # 55f6 <exit>
      name[0] = 'p' + pi;
    1c0a:	0709091b          	addw	s2,s2,112
    1c0e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c12:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c16:	4951                	li	s2,20
    1c18:	a015                	j	1c3c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1a:	85e6                	mv	a1,s9
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	80c50513          	add	a0,a0,-2036 # 6428 <malloc+0xa12>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	d3a080e7          	jalr	-710(ra) # 595e <printf>
          exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	9c8080e7          	jalr	-1592(ra) # 55f6 <exit>
      for(i = 0; i < N; i++){
    1c36:	2485                	addw	s1,s1,1
    1c38:	07248863          	beq	s1,s2,1ca8 <createdelete+0x122>
        name[1] = '0' + i;
    1c3c:	0304879b          	addw	a5,s1,48
    1c40:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c44:	20200593          	li	a1,514
    1c48:	f8040513          	add	a0,s0,-128
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	9ea080e7          	jalr	-1558(ra) # 5636 <open>
        if(fd < 0){
    1c54:	fc0543e3          	bltz	a0,1c1a <createdelete+0x94>
        close(fd);
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	9c6080e7          	jalr	-1594(ra) # 561e <close>
        if(i > 0 && (i % 2 ) == 0){
    1c60:	fc905be3          	blez	s1,1c36 <createdelete+0xb0>
    1c64:	0014f793          	and	a5,s1,1
    1c68:	f7f9                	bnez	a5,1c36 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6a:	01f4d79b          	srlw	a5,s1,0x1f
    1c6e:	9fa5                	addw	a5,a5,s1
    1c70:	4017d79b          	sraw	a5,a5,0x1
    1c74:	0307879b          	addw	a5,a5,48
    1c78:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c7c:	f8040513          	add	a0,s0,-128
    1c80:	00004097          	auipc	ra,0x4
    1c84:	9c6080e7          	jalr	-1594(ra) # 5646 <unlink>
    1c88:	fa0557e3          	bgez	a0,1c36 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c8c:	85e6                	mv	a1,s9
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	8f250513          	add	a0,a0,-1806 # 6580 <malloc+0xb6a>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	cc8080e7          	jalr	-824(ra) # 595e <printf>
            exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	956080e7          	jalr	-1706(ra) # 55f6 <exit>
      exit(0);
    1ca8:	4501                	li	a0,0
    1caa:	00004097          	auipc	ra,0x4
    1cae:	94c080e7          	jalr	-1716(ra) # 55f6 <exit>
      exit(1);
    1cb2:	4505                	li	a0,1
    1cb4:	00004097          	auipc	ra,0x4
    1cb8:	942080e7          	jalr	-1726(ra) # 55f6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cbc:	f8040613          	add	a2,s0,-128
    1cc0:	85e6                	mv	a1,s9
    1cc2:	00005517          	auipc	a0,0x5
    1cc6:	8d650513          	add	a0,a0,-1834 # 6598 <malloc+0xb82>
    1cca:	00004097          	auipc	ra,0x4
    1cce:	c94080e7          	jalr	-876(ra) # 595e <printf>
        exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	922080e7          	jalr	-1758(ra) # 55f6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cdc:	054b7163          	bgeu	s6,s4,1d1e <createdelete+0x198>
      if(fd >= 0)
    1ce0:	02055a63          	bgez	a0,1d14 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce4:	2485                	addw	s1,s1,1
    1ce6:	0ff4f493          	zext.b	s1,s1
    1cea:	05548c63          	beq	s1,s5,1d42 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cee:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cf6:	4581                	li	a1,0
    1cf8:	f8040513          	add	a0,s0,-128
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	93a080e7          	jalr	-1734(ra) # 5636 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d04:	00090463          	beqz	s2,1d0c <createdelete+0x186>
    1d08:	fd2bdae3          	bge	s7,s2,1cdc <createdelete+0x156>
    1d0c:	fa0548e3          	bltz	a0,1cbc <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d10:	014b7963          	bgeu	s6,s4,1d22 <createdelete+0x19c>
        close(fd);
    1d14:	00004097          	auipc	ra,0x4
    1d18:	90a080e7          	jalr	-1782(ra) # 561e <close>
    1d1c:	b7e1                	j	1ce4 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1e:	fc0543e3          	bltz	a0,1ce4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d22:	f8040613          	add	a2,s0,-128
    1d26:	85e6                	mv	a1,s9
    1d28:	00005517          	auipc	a0,0x5
    1d2c:	89850513          	add	a0,a0,-1896 # 65c0 <malloc+0xbaa>
    1d30:	00004097          	auipc	ra,0x4
    1d34:	c2e080e7          	jalr	-978(ra) # 595e <printf>
        exit(1);
    1d38:	4505                	li	a0,1
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	8bc080e7          	jalr	-1860(ra) # 55f6 <exit>
  for(i = 0; i < N; i++){
    1d42:	2905                	addw	s2,s2,1
    1d44:	2a05                	addw	s4,s4,1
    1d46:	2985                	addw	s3,s3,1 # 3001 <dirtest+0x87>
    1d48:	0ff9f993          	zext.b	s3,s3
    1d4c:	47d1                	li	a5,20
    1d4e:	02f90a63          	beq	s2,a5,1d82 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d52:	84e2                	mv	s1,s8
    1d54:	bf69                	j	1cee <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d56:	2905                	addw	s2,s2,1
    1d58:	0ff97913          	zext.b	s2,s2
    1d5c:	2985                	addw	s3,s3,1
    1d5e:	0ff9f993          	zext.b	s3,s3
    1d62:	03490863          	beq	s2,s4,1d92 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d66:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d68:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d6c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d70:	f8040513          	add	a0,s0,-128
    1d74:	00004097          	auipc	ra,0x4
    1d78:	8d2080e7          	jalr	-1838(ra) # 5646 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d7c:	34fd                	addw	s1,s1,-1
    1d7e:	f4ed                	bnez	s1,1d68 <createdelete+0x1e2>
    1d80:	bfd9                	j	1d56 <createdelete+0x1d0>
    1d82:	03000993          	li	s3,48
    1d86:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d8c:	08400a13          	li	s4,132
    1d90:	bfd9                	j	1d66 <createdelete+0x1e0>
}
    1d92:	60aa                	ld	ra,136(sp)
    1d94:	640a                	ld	s0,128(sp)
    1d96:	74e6                	ld	s1,120(sp)
    1d98:	7946                	ld	s2,112(sp)
    1d9a:	79a6                	ld	s3,104(sp)
    1d9c:	7a06                	ld	s4,96(sp)
    1d9e:	6ae6                	ld	s5,88(sp)
    1da0:	6b46                	ld	s6,80(sp)
    1da2:	6ba6                	ld	s7,72(sp)
    1da4:	6c06                	ld	s8,64(sp)
    1da6:	7ce2                	ld	s9,56(sp)
    1da8:	6149                	add	sp,sp,144
    1daa:	8082                	ret

0000000000001dac <linkunlink>:
{
    1dac:	711d                	add	sp,sp,-96
    1dae:	ec86                	sd	ra,88(sp)
    1db0:	e8a2                	sd	s0,80(sp)
    1db2:	e4a6                	sd	s1,72(sp)
    1db4:	e0ca                	sd	s2,64(sp)
    1db6:	fc4e                	sd	s3,56(sp)
    1db8:	f852                	sd	s4,48(sp)
    1dba:	f456                	sd	s5,40(sp)
    1dbc:	f05a                	sd	s6,32(sp)
    1dbe:	ec5e                	sd	s7,24(sp)
    1dc0:	e862                	sd	s8,16(sp)
    1dc2:	e466                	sd	s9,8(sp)
    1dc4:	1080                	add	s0,sp,96
    1dc6:	84aa                	mv	s1,a0
  unlink("x");
    1dc8:	00004517          	auipc	a0,0x4
    1dcc:	de050513          	add	a0,a0,-544 # 5ba8 <malloc+0x192>
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	876080e7          	jalr	-1930(ra) # 5646 <unlink>
  pid = fork();
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	816080e7          	jalr	-2026(ra) # 55ee <fork>
  if(pid < 0){
    1de0:	02054b63          	bltz	a0,1e16 <linkunlink+0x6a>
    1de4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1de6:	06100c93          	li	s9,97
    1dea:	c111                	beqz	a0,1dee <linkunlink+0x42>
    1dec:	4c85                	li	s9,1
    1dee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df2:	41c659b7          	lui	s3,0x41c65
    1df6:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c56395>
    1dfa:	690d                	lui	s2,0x3
    1dfc:	0399091b          	addw	s2,s2,57 # 3039 <dirtest+0xbf>
    if((x % 3) == 0){
    1e00:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e02:	4b05                	li	s6,1
      unlink("x");
    1e04:	00004a97          	auipc	s5,0x4
    1e08:	da4a8a93          	add	s5,s5,-604 # 5ba8 <malloc+0x192>
      link("cat", "x");
    1e0c:	00004b97          	auipc	s7,0x4
    1e10:	7dcb8b93          	add	s7,s7,2012 # 65e8 <malloc+0xbd2>
    1e14:	a825                	j	1e4c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e16:	85a6                	mv	a1,s1
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	57850513          	add	a0,a0,1400 # 6390 <malloc+0x97a>
    1e20:	00004097          	auipc	ra,0x4
    1e24:	b3e080e7          	jalr	-1218(ra) # 595e <printf>
    exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	00003097          	auipc	ra,0x3
    1e2e:	7cc080e7          	jalr	1996(ra) # 55f6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e32:	20200593          	li	a1,514
    1e36:	8556                	mv	a0,s5
    1e38:	00003097          	auipc	ra,0x3
    1e3c:	7fe080e7          	jalr	2046(ra) # 5636 <open>
    1e40:	00003097          	auipc	ra,0x3
    1e44:	7de080e7          	jalr	2014(ra) # 561e <close>
  for(i = 0; i < 100; i++){
    1e48:	34fd                	addw	s1,s1,-1
    1e4a:	c88d                	beqz	s1,1e7c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e4c:	033c87bb          	mulw	a5,s9,s3
    1e50:	012787bb          	addw	a5,a5,s2
    1e54:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e58:	0347f7bb          	remuw	a5,a5,s4
    1e5c:	dbf9                	beqz	a5,1e32 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e5e:	01678863          	beq	a5,s6,1e6e <linkunlink+0xc2>
      unlink("x");
    1e62:	8556                	mv	a0,s5
    1e64:	00003097          	auipc	ra,0x3
    1e68:	7e2080e7          	jalr	2018(ra) # 5646 <unlink>
    1e6c:	bff1                	j	1e48 <linkunlink+0x9c>
      link("cat", "x");
    1e6e:	85d6                	mv	a1,s5
    1e70:	855e                	mv	a0,s7
    1e72:	00003097          	auipc	ra,0x3
    1e76:	7e4080e7          	jalr	2020(ra) # 5656 <link>
    1e7a:	b7f9                	j	1e48 <linkunlink+0x9c>
  if(pid)
    1e7c:	020c0463          	beqz	s8,1ea4 <linkunlink+0xf8>
    wait(0);
    1e80:	4501                	li	a0,0
    1e82:	00003097          	auipc	ra,0x3
    1e86:	77c080e7          	jalr	1916(ra) # 55fe <wait>
}
    1e8a:	60e6                	ld	ra,88(sp)
    1e8c:	6446                	ld	s0,80(sp)
    1e8e:	64a6                	ld	s1,72(sp)
    1e90:	6906                	ld	s2,64(sp)
    1e92:	79e2                	ld	s3,56(sp)
    1e94:	7a42                	ld	s4,48(sp)
    1e96:	7aa2                	ld	s5,40(sp)
    1e98:	7b02                	ld	s6,32(sp)
    1e9a:	6be2                	ld	s7,24(sp)
    1e9c:	6c42                	ld	s8,16(sp)
    1e9e:	6ca2                	ld	s9,8(sp)
    1ea0:	6125                	add	sp,sp,96
    1ea2:	8082                	ret
    exit(0);
    1ea4:	4501                	li	a0,0
    1ea6:	00003097          	auipc	ra,0x3
    1eaa:	750080e7          	jalr	1872(ra) # 55f6 <exit>

0000000000001eae <manywrites>:
{
    1eae:	711d                	add	sp,sp,-96
    1eb0:	ec86                	sd	ra,88(sp)
    1eb2:	e8a2                	sd	s0,80(sp)
    1eb4:	e4a6                	sd	s1,72(sp)
    1eb6:	e0ca                	sd	s2,64(sp)
    1eb8:	fc4e                	sd	s3,56(sp)
    1eba:	f852                	sd	s4,48(sp)
    1ebc:	f456                	sd	s5,40(sp)
    1ebe:	f05a                	sd	s6,32(sp)
    1ec0:	ec5e                	sd	s7,24(sp)
    1ec2:	1080                	add	s0,sp,96
    1ec4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ec6:	4981                	li	s3,0
    1ec8:	4911                	li	s2,4
    int pid = fork();
    1eca:	00003097          	auipc	ra,0x3
    1ece:	724080e7          	jalr	1828(ra) # 55ee <fork>
    1ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed4:	02054963          	bltz	a0,1f06 <manywrites+0x58>
    if(pid == 0){
    1ed8:	c521                	beqz	a0,1f20 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eda:	2985                	addw	s3,s3,1
    1edc:	ff2997e3          	bne	s3,s2,1eca <manywrites+0x1c>
    1ee0:	4491                	li	s1,4
    int st = 0;
    1ee2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ee6:	fa840513          	add	a0,s0,-88
    1eea:	00003097          	auipc	ra,0x3
    1eee:	714080e7          	jalr	1812(ra) # 55fe <wait>
    if(st != 0)
    1ef2:	fa842503          	lw	a0,-88(s0)
    1ef6:	ed6d                	bnez	a0,1ff0 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1ef8:	34fd                	addw	s1,s1,-1
    1efa:	f4e5                	bnez	s1,1ee2 <manywrites+0x34>
  exit(0);
    1efc:	4501                	li	a0,0
    1efe:	00003097          	auipc	ra,0x3
    1f02:	6f8080e7          	jalr	1784(ra) # 55f6 <exit>
      printf("fork failed\n");
    1f06:	00005517          	auipc	a0,0x5
    1f0a:	89250513          	add	a0,a0,-1902 # 6798 <malloc+0xd82>
    1f0e:	00004097          	auipc	ra,0x4
    1f12:	a50080e7          	jalr	-1456(ra) # 595e <printf>
      exit(1);
    1f16:	4505                	li	a0,1
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	6de080e7          	jalr	1758(ra) # 55f6 <exit>
      name[0] = 'b';
    1f20:	06200793          	li	a5,98
    1f24:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f28:	0619879b          	addw	a5,s3,97
    1f2c:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f30:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f34:	fa840513          	add	a0,s0,-88
    1f38:	00003097          	auipc	ra,0x3
    1f3c:	70e080e7          	jalr	1806(ra) # 5646 <unlink>
    1f40:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f42:	0000ab17          	auipc	s6,0xa
    1f46:	b86b0b13          	add	s6,s6,-1146 # bac8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4a:	8a26                	mv	s4,s1
    1f4c:	0209ce63          	bltz	s3,1f88 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f50:	20200593          	li	a1,514
    1f54:	fa840513          	add	a0,s0,-88
    1f58:	00003097          	auipc	ra,0x3
    1f5c:	6de080e7          	jalr	1758(ra) # 5636 <open>
    1f60:	892a                	mv	s2,a0
          if(fd < 0){
    1f62:	04054763          	bltz	a0,1fb0 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f66:	660d                	lui	a2,0x3
    1f68:	85da                	mv	a1,s6
    1f6a:	00003097          	auipc	ra,0x3
    1f6e:	6ac080e7          	jalr	1708(ra) # 5616 <write>
          if(cc != sz){
    1f72:	678d                	lui	a5,0x3
    1f74:	04f51e63          	bne	a0,a5,1fd0 <manywrites+0x122>
          close(fd);
    1f78:	854a                	mv	a0,s2
    1f7a:	00003097          	auipc	ra,0x3
    1f7e:	6a4080e7          	jalr	1700(ra) # 561e <close>
        for(int i = 0; i < ci+1; i++){
    1f82:	2a05                	addw	s4,s4,1
    1f84:	fd49d6e3          	bge	s3,s4,1f50 <manywrites+0xa2>
        unlink(name);
    1f88:	fa840513          	add	a0,s0,-88
    1f8c:	00003097          	auipc	ra,0x3
    1f90:	6ba080e7          	jalr	1722(ra) # 5646 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f94:	3bfd                	addw	s7,s7,-1
    1f96:	fa0b9ae3          	bnez	s7,1f4a <manywrites+0x9c>
      unlink(name);
    1f9a:	fa840513          	add	a0,s0,-88
    1f9e:	00003097          	auipc	ra,0x3
    1fa2:	6a8080e7          	jalr	1704(ra) # 5646 <unlink>
      exit(0);
    1fa6:	4501                	li	a0,0
    1fa8:	00003097          	auipc	ra,0x3
    1fac:	64e080e7          	jalr	1614(ra) # 55f6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb0:	fa840613          	add	a2,s0,-88
    1fb4:	85d6                	mv	a1,s5
    1fb6:	00004517          	auipc	a0,0x4
    1fba:	63a50513          	add	a0,a0,1594 # 65f0 <malloc+0xbda>
    1fbe:	00004097          	auipc	ra,0x4
    1fc2:	9a0080e7          	jalr	-1632(ra) # 595e <printf>
            exit(1);
    1fc6:	4505                	li	a0,1
    1fc8:	00003097          	auipc	ra,0x3
    1fcc:	62e080e7          	jalr	1582(ra) # 55f6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd0:	86aa                	mv	a3,a0
    1fd2:	660d                	lui	a2,0x3
    1fd4:	85d6                	mv	a1,s5
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	c3250513          	add	a0,a0,-974 # 5c08 <malloc+0x1f2>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	980080e7          	jalr	-1664(ra) # 595e <printf>
            exit(1);
    1fe6:	4505                	li	a0,1
    1fe8:	00003097          	auipc	ra,0x3
    1fec:	60e080e7          	jalr	1550(ra) # 55f6 <exit>
      exit(st);
    1ff0:	00003097          	auipc	ra,0x3
    1ff4:	606080e7          	jalr	1542(ra) # 55f6 <exit>

0000000000001ff8 <forktest>:
{
    1ff8:	7179                	add	sp,sp,-48
    1ffa:	f406                	sd	ra,40(sp)
    1ffc:	f022                	sd	s0,32(sp)
    1ffe:	ec26                	sd	s1,24(sp)
    2000:	e84a                	sd	s2,16(sp)
    2002:	e44e                	sd	s3,8(sp)
    2004:	1800                	add	s0,sp,48
    2006:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2008:	4481                	li	s1,0
    200a:	3e800913          	li	s2,1000
    pid = fork();
    200e:	00003097          	auipc	ra,0x3
    2012:	5e0080e7          	jalr	1504(ra) # 55ee <fork>
    if(pid < 0)
    2016:	02054863          	bltz	a0,2046 <forktest+0x4e>
    if(pid == 0)
    201a:	c115                	beqz	a0,203e <forktest+0x46>
  for(n=0; n<N; n++){
    201c:	2485                	addw	s1,s1,1
    201e:	ff2498e3          	bne	s1,s2,200e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2022:	85ce                	mv	a1,s3
    2024:	00004517          	auipc	a0,0x4
    2028:	5fc50513          	add	a0,a0,1532 # 6620 <malloc+0xc0a>
    202c:	00004097          	auipc	ra,0x4
    2030:	932080e7          	jalr	-1742(ra) # 595e <printf>
    exit(1);
    2034:	4505                	li	a0,1
    2036:	00003097          	auipc	ra,0x3
    203a:	5c0080e7          	jalr	1472(ra) # 55f6 <exit>
      exit(0);
    203e:	00003097          	auipc	ra,0x3
    2042:	5b8080e7          	jalr	1464(ra) # 55f6 <exit>
  if (n == 0) {
    2046:	cc9d                	beqz	s1,2084 <forktest+0x8c>
  if(n == N){
    2048:	3e800793          	li	a5,1000
    204c:	fcf48be3          	beq	s1,a5,2022 <forktest+0x2a>
  for(; n > 0; n--){
    2050:	00905b63          	blez	s1,2066 <forktest+0x6e>
    if(wait(0) < 0){
    2054:	4501                	li	a0,0
    2056:	00003097          	auipc	ra,0x3
    205a:	5a8080e7          	jalr	1448(ra) # 55fe <wait>
    205e:	04054163          	bltz	a0,20a0 <forktest+0xa8>
  for(; n > 0; n--){
    2062:	34fd                	addw	s1,s1,-1
    2064:	f8e5                	bnez	s1,2054 <forktest+0x5c>
  if(wait(0) != -1){
    2066:	4501                	li	a0,0
    2068:	00003097          	auipc	ra,0x3
    206c:	596080e7          	jalr	1430(ra) # 55fe <wait>
    2070:	57fd                	li	a5,-1
    2072:	04f51563          	bne	a0,a5,20bc <forktest+0xc4>
}
    2076:	70a2                	ld	ra,40(sp)
    2078:	7402                	ld	s0,32(sp)
    207a:	64e2                	ld	s1,24(sp)
    207c:	6942                	ld	s2,16(sp)
    207e:	69a2                	ld	s3,8(sp)
    2080:	6145                	add	sp,sp,48
    2082:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2084:	85ce                	mv	a1,s3
    2086:	00004517          	auipc	a0,0x4
    208a:	58250513          	add	a0,a0,1410 # 6608 <malloc+0xbf2>
    208e:	00004097          	auipc	ra,0x4
    2092:	8d0080e7          	jalr	-1840(ra) # 595e <printf>
    exit(1);
    2096:	4505                	li	a0,1
    2098:	00003097          	auipc	ra,0x3
    209c:	55e080e7          	jalr	1374(ra) # 55f6 <exit>
      printf("%s: wait stopped early\n", s);
    20a0:	85ce                	mv	a1,s3
    20a2:	00004517          	auipc	a0,0x4
    20a6:	5a650513          	add	a0,a0,1446 # 6648 <malloc+0xc32>
    20aa:	00004097          	auipc	ra,0x4
    20ae:	8b4080e7          	jalr	-1868(ra) # 595e <printf>
      exit(1);
    20b2:	4505                	li	a0,1
    20b4:	00003097          	auipc	ra,0x3
    20b8:	542080e7          	jalr	1346(ra) # 55f6 <exit>
    printf("%s: wait got too many\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00004517          	auipc	a0,0x4
    20c2:	5a250513          	add	a0,a0,1442 # 6660 <malloc+0xc4a>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	898080e7          	jalr	-1896(ra) # 595e <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00003097          	auipc	ra,0x3
    20d4:	526080e7          	jalr	1318(ra) # 55f6 <exit>

00000000000020d8 <kernmem>:
{
    20d8:	715d                	add	sp,sp,-80
    20da:	e486                	sd	ra,72(sp)
    20dc:	e0a2                	sd	s0,64(sp)
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
    20e6:	ec56                	sd	s5,24(sp)
    20e8:	0880                	add	s0,sp,80
    20ea:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ec:	4485                	li	s1,1
    20ee:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f0:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	69b1                	lui	s3,0xc
    20f4:	35098993          	add	s3,s3,848 # c350 <buf+0x888>
    20f8:	1003d937          	lui	s2,0x1003d
    20fc:	090e                	sll	s2,s2,0x3
    20fe:	48090913          	add	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e9a8>
    pid = fork();
    2102:	00003097          	auipc	ra,0x3
    2106:	4ec080e7          	jalr	1260(ra) # 55ee <fork>
    if(pid < 0){
    210a:	02054963          	bltz	a0,213c <kernmem+0x64>
    if(pid == 0){
    210e:	c529                	beqz	a0,2158 <kernmem+0x80>
    wait(&xstatus);
    2110:	fbc40513          	add	a0,s0,-68
    2114:	00003097          	auipc	ra,0x3
    2118:	4ea080e7          	jalr	1258(ra) # 55fe <wait>
    if(xstatus != -1)  // did kernel kill child?
    211c:	fbc42783          	lw	a5,-68(s0)
    2120:	05579d63          	bne	a5,s5,217a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2124:	94ce                	add	s1,s1,s3
    2126:	fd249ee3          	bne	s1,s2,2102 <kernmem+0x2a>
}
    212a:	60a6                	ld	ra,72(sp)
    212c:	6406                	ld	s0,64(sp)
    212e:	74e2                	ld	s1,56(sp)
    2130:	7942                	ld	s2,48(sp)
    2132:	79a2                	ld	s3,40(sp)
    2134:	7a02                	ld	s4,32(sp)
    2136:	6ae2                	ld	s5,24(sp)
    2138:	6161                	add	sp,sp,80
    213a:	8082                	ret
      printf("%s: fork failed\n", s);
    213c:	85d2                	mv	a1,s4
    213e:	00004517          	auipc	a0,0x4
    2142:	25250513          	add	a0,a0,594 # 6390 <malloc+0x97a>
    2146:	00004097          	auipc	ra,0x4
    214a:	818080e7          	jalr	-2024(ra) # 595e <printf>
      exit(1);
    214e:	4505                	li	a0,1
    2150:	00003097          	auipc	ra,0x3
    2154:	4a6080e7          	jalr	1190(ra) # 55f6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2158:	0004c683          	lbu	a3,0(s1)
    215c:	8626                	mv	a2,s1
    215e:	85d2                	mv	a1,s4
    2160:	00004517          	auipc	a0,0x4
    2164:	51850513          	add	a0,a0,1304 # 6678 <malloc+0xc62>
    2168:	00003097          	auipc	ra,0x3
    216c:	7f6080e7          	jalr	2038(ra) # 595e <printf>
      exit(1);
    2170:	4505                	li	a0,1
    2172:	00003097          	auipc	ra,0x3
    2176:	484080e7          	jalr	1156(ra) # 55f6 <exit>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00003097          	auipc	ra,0x3
    2180:	47a080e7          	jalr	1146(ra) # 55f6 <exit>

0000000000002184 <bigargtest>:
{
    2184:	7179                	add	sp,sp,-48
    2186:	f406                	sd	ra,40(sp)
    2188:	f022                	sd	s0,32(sp)
    218a:	ec26                	sd	s1,24(sp)
    218c:	1800                	add	s0,sp,48
    218e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2190:	00004517          	auipc	a0,0x4
    2194:	50850513          	add	a0,a0,1288 # 6698 <malloc+0xc82>
    2198:	00003097          	auipc	ra,0x3
    219c:	4ae080e7          	jalr	1198(ra) # 5646 <unlink>
  pid = fork();
    21a0:	00003097          	auipc	ra,0x3
    21a4:	44e080e7          	jalr	1102(ra) # 55ee <fork>
  if(pid == 0){
    21a8:	c121                	beqz	a0,21e8 <bigargtest+0x64>
  } else if(pid < 0){
    21aa:	0a054063          	bltz	a0,224a <bigargtest+0xc6>
  wait(&xstatus);
    21ae:	fdc40513          	add	a0,s0,-36
    21b2:	00003097          	auipc	ra,0x3
    21b6:	44c080e7          	jalr	1100(ra) # 55fe <wait>
  if(xstatus != 0)
    21ba:	fdc42503          	lw	a0,-36(s0)
    21be:	e545                	bnez	a0,2266 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c0:	4581                	li	a1,0
    21c2:	00004517          	auipc	a0,0x4
    21c6:	4d650513          	add	a0,a0,1238 # 6698 <malloc+0xc82>
    21ca:	00003097          	auipc	ra,0x3
    21ce:	46c080e7          	jalr	1132(ra) # 5636 <open>
  if(fd < 0){
    21d2:	08054e63          	bltz	a0,226e <bigargtest+0xea>
  close(fd);
    21d6:	00003097          	auipc	ra,0x3
    21da:	448080e7          	jalr	1096(ra) # 561e <close>
}
    21de:	70a2                	ld	ra,40(sp)
    21e0:	7402                	ld	s0,32(sp)
    21e2:	64e2                	ld	s1,24(sp)
    21e4:	6145                	add	sp,sp,48
    21e6:	8082                	ret
    21e8:	00006797          	auipc	a5,0x6
    21ec:	0c878793          	add	a5,a5,200 # 82b0 <args.1>
    21f0:	00006697          	auipc	a3,0x6
    21f4:	1b868693          	add	a3,a3,440 # 83a8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21f8:	00004717          	auipc	a4,0x4
    21fc:	4b070713          	add	a4,a4,1200 # 66a8 <malloc+0xc92>
    2200:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2202:	07a1                	add	a5,a5,8
    2204:	fed79ee3          	bne	a5,a3,2200 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2208:	00006597          	auipc	a1,0x6
    220c:	0a858593          	add	a1,a1,168 # 82b0 <args.1>
    2210:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2214:	00004517          	auipc	a0,0x4
    2218:	92450513          	add	a0,a0,-1756 # 5b38 <malloc+0x122>
    221c:	00003097          	auipc	ra,0x3
    2220:	412080e7          	jalr	1042(ra) # 562e <exec>
    fd = open("bigarg-ok", O_CREATE);
    2224:	20000593          	li	a1,512
    2228:	00004517          	auipc	a0,0x4
    222c:	47050513          	add	a0,a0,1136 # 6698 <malloc+0xc82>
    2230:	00003097          	auipc	ra,0x3
    2234:	406080e7          	jalr	1030(ra) # 5636 <open>
    close(fd);
    2238:	00003097          	auipc	ra,0x3
    223c:	3e6080e7          	jalr	998(ra) # 561e <close>
    exit(0);
    2240:	4501                	li	a0,0
    2242:	00003097          	auipc	ra,0x3
    2246:	3b4080e7          	jalr	948(ra) # 55f6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224a:	85a6                	mv	a1,s1
    224c:	00004517          	auipc	a0,0x4
    2250:	53c50513          	add	a0,a0,1340 # 6788 <malloc+0xd72>
    2254:	00003097          	auipc	ra,0x3
    2258:	70a080e7          	jalr	1802(ra) # 595e <printf>
    exit(1);
    225c:	4505                	li	a0,1
    225e:	00003097          	auipc	ra,0x3
    2262:	398080e7          	jalr	920(ra) # 55f6 <exit>
    exit(xstatus);
    2266:	00003097          	auipc	ra,0x3
    226a:	390080e7          	jalr	912(ra) # 55f6 <exit>
    printf("%s: bigarg test failed!\n", s);
    226e:	85a6                	mv	a1,s1
    2270:	00004517          	auipc	a0,0x4
    2274:	53850513          	add	a0,a0,1336 # 67a8 <malloc+0xd92>
    2278:	00003097          	auipc	ra,0x3
    227c:	6e6080e7          	jalr	1766(ra) # 595e <printf>
    exit(1);
    2280:	4505                	li	a0,1
    2282:	00003097          	auipc	ra,0x3
    2286:	374080e7          	jalr	884(ra) # 55f6 <exit>

000000000000228a <stacktest>:
{
    228a:	7179                	add	sp,sp,-48
    228c:	f406                	sd	ra,40(sp)
    228e:	f022                	sd	s0,32(sp)
    2290:	ec26                	sd	s1,24(sp)
    2292:	1800                	add	s0,sp,48
    2294:	84aa                	mv	s1,a0
  pid = fork();
    2296:	00003097          	auipc	ra,0x3
    229a:	358080e7          	jalr	856(ra) # 55ee <fork>
  if(pid == 0) {
    229e:	c115                	beqz	a0,22c2 <stacktest+0x38>
  } else if(pid < 0){
    22a0:	04054463          	bltz	a0,22e8 <stacktest+0x5e>
  wait(&xstatus);
    22a4:	fdc40513          	add	a0,s0,-36
    22a8:	00003097          	auipc	ra,0x3
    22ac:	356080e7          	jalr	854(ra) # 55fe <wait>
  if(xstatus == -1)  // kernel killed child?
    22b0:	fdc42503          	lw	a0,-36(s0)
    22b4:	57fd                	li	a5,-1
    22b6:	04f50763          	beq	a0,a5,2304 <stacktest+0x7a>
    exit(xstatus);
    22ba:	00003097          	auipc	ra,0x3
    22be:	33c080e7          	jalr	828(ra) # 55f6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c4:	77fd                	lui	a5,0xfffff
    22c6:	97ba                	add	a5,a5,a4
    22c8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0528>
    22cc:	85a6                	mv	a1,s1
    22ce:	00004517          	auipc	a0,0x4
    22d2:	4fa50513          	add	a0,a0,1274 # 67c8 <malloc+0xdb2>
    22d6:	00003097          	auipc	ra,0x3
    22da:	688080e7          	jalr	1672(ra) # 595e <printf>
    exit(1);
    22de:	4505                	li	a0,1
    22e0:	00003097          	auipc	ra,0x3
    22e4:	316080e7          	jalr	790(ra) # 55f6 <exit>
    printf("%s: fork failed\n", s);
    22e8:	85a6                	mv	a1,s1
    22ea:	00004517          	auipc	a0,0x4
    22ee:	0a650513          	add	a0,a0,166 # 6390 <malloc+0x97a>
    22f2:	00003097          	auipc	ra,0x3
    22f6:	66c080e7          	jalr	1644(ra) # 595e <printf>
    exit(1);
    22fa:	4505                	li	a0,1
    22fc:	00003097          	auipc	ra,0x3
    2300:	2fa080e7          	jalr	762(ra) # 55f6 <exit>
    exit(0);
    2304:	4501                	li	a0,0
    2306:	00003097          	auipc	ra,0x3
    230a:	2f0080e7          	jalr	752(ra) # 55f6 <exit>

000000000000230e <copyinstr3>:
{
    230e:	7179                	add	sp,sp,-48
    2310:	f406                	sd	ra,40(sp)
    2312:	f022                	sd	s0,32(sp)
    2314:	ec26                	sd	s1,24(sp)
    2316:	1800                	add	s0,sp,48
  sbrk(8192);
    2318:	6509                	lui	a0,0x2
    231a:	00003097          	auipc	ra,0x3
    231e:	364080e7          	jalr	868(ra) # 567e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2322:	4501                	li	a0,0
    2324:	00003097          	auipc	ra,0x3
    2328:	35a080e7          	jalr	858(ra) # 567e <sbrk>
  if((top % PGSIZE) != 0){
    232c:	03451793          	sll	a5,a0,0x34
    2330:	e3c9                	bnez	a5,23b2 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2332:	4501                	li	a0,0
    2334:	00003097          	auipc	ra,0x3
    2338:	34a080e7          	jalr	842(ra) # 567e <sbrk>
  if(top % PGSIZE){
    233c:	03451793          	sll	a5,a0,0x34
    2340:	e3d9                	bnez	a5,23c6 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2342:	fff50493          	add	s1,a0,-1 # 1fff <forktest+0x7>
  *b = 'x';
    2346:	07800793          	li	a5,120
    234a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    234e:	8526                	mv	a0,s1
    2350:	00003097          	auipc	ra,0x3
    2354:	2f6080e7          	jalr	758(ra) # 5646 <unlink>
  if(ret != -1){
    2358:	57fd                	li	a5,-1
    235a:	08f51363          	bne	a0,a5,23e0 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    235e:	20100593          	li	a1,513
    2362:	8526                	mv	a0,s1
    2364:	00003097          	auipc	ra,0x3
    2368:	2d2080e7          	jalr	722(ra) # 5636 <open>
  if(fd != -1){
    236c:	57fd                	li	a5,-1
    236e:	08f51863          	bne	a0,a5,23fe <copyinstr3+0xf0>
  ret = link(b, b);
    2372:	85a6                	mv	a1,s1
    2374:	8526                	mv	a0,s1
    2376:	00003097          	auipc	ra,0x3
    237a:	2e0080e7          	jalr	736(ra) # 5656 <link>
  if(ret != -1){
    237e:	57fd                	li	a5,-1
    2380:	08f51e63          	bne	a0,a5,241c <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2384:	00005797          	auipc	a5,0x5
    2388:	0ec78793          	add	a5,a5,236 # 7470 <malloc+0x1a5a>
    238c:	fcf43823          	sd	a5,-48(s0)
    2390:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2394:	fd040593          	add	a1,s0,-48
    2398:	8526                	mv	a0,s1
    239a:	00003097          	auipc	ra,0x3
    239e:	294080e7          	jalr	660(ra) # 562e <exec>
  if(ret != -1){
    23a2:	57fd                	li	a5,-1
    23a4:	08f51c63          	bne	a0,a5,243c <copyinstr3+0x12e>
}
    23a8:	70a2                	ld	ra,40(sp)
    23aa:	7402                	ld	s0,32(sp)
    23ac:	64e2                	ld	s1,24(sp)
    23ae:	6145                	add	sp,sp,48
    23b0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b2:	0347d513          	srl	a0,a5,0x34
    23b6:	6785                	lui	a5,0x1
    23b8:	40a7853b          	subw	a0,a5,a0
    23bc:	00003097          	auipc	ra,0x3
    23c0:	2c2080e7          	jalr	706(ra) # 567e <sbrk>
    23c4:	b7bd                	j	2332 <copyinstr3+0x24>
    printf("oops\n");
    23c6:	00004517          	auipc	a0,0x4
    23ca:	42a50513          	add	a0,a0,1066 # 67f0 <malloc+0xdda>
    23ce:	00003097          	auipc	ra,0x3
    23d2:	590080e7          	jalr	1424(ra) # 595e <printf>
    exit(1);
    23d6:	4505                	li	a0,1
    23d8:	00003097          	auipc	ra,0x3
    23dc:	21e080e7          	jalr	542(ra) # 55f6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e0:	862a                	mv	a2,a0
    23e2:	85a6                	mv	a1,s1
    23e4:	00004517          	auipc	a0,0x4
    23e8:	ecc50513          	add	a0,a0,-308 # 62b0 <malloc+0x89a>
    23ec:	00003097          	auipc	ra,0x3
    23f0:	572080e7          	jalr	1394(ra) # 595e <printf>
    exit(1);
    23f4:	4505                	li	a0,1
    23f6:	00003097          	auipc	ra,0x3
    23fa:	200080e7          	jalr	512(ra) # 55f6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    23fe:	862a                	mv	a2,a0
    2400:	85a6                	mv	a1,s1
    2402:	00004517          	auipc	a0,0x4
    2406:	ece50513          	add	a0,a0,-306 # 62d0 <malloc+0x8ba>
    240a:	00003097          	auipc	ra,0x3
    240e:	554080e7          	jalr	1364(ra) # 595e <printf>
    exit(1);
    2412:	4505                	li	a0,1
    2414:	00003097          	auipc	ra,0x3
    2418:	1e2080e7          	jalr	482(ra) # 55f6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    241c:	86aa                	mv	a3,a0
    241e:	8626                	mv	a2,s1
    2420:	85a6                	mv	a1,s1
    2422:	00004517          	auipc	a0,0x4
    2426:	ece50513          	add	a0,a0,-306 # 62f0 <malloc+0x8da>
    242a:	00003097          	auipc	ra,0x3
    242e:	534080e7          	jalr	1332(ra) # 595e <printf>
    exit(1);
    2432:	4505                	li	a0,1
    2434:	00003097          	auipc	ra,0x3
    2438:	1c2080e7          	jalr	450(ra) # 55f6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    243c:	567d                	li	a2,-1
    243e:	85a6                	mv	a1,s1
    2440:	00004517          	auipc	a0,0x4
    2444:	ed850513          	add	a0,a0,-296 # 6318 <malloc+0x902>
    2448:	00003097          	auipc	ra,0x3
    244c:	516080e7          	jalr	1302(ra) # 595e <printf>
    exit(1);
    2450:	4505                	li	a0,1
    2452:	00003097          	auipc	ra,0x3
    2456:	1a4080e7          	jalr	420(ra) # 55f6 <exit>

000000000000245a <rwsbrk>:
{
    245a:	1101                	add	sp,sp,-32
    245c:	ec06                	sd	ra,24(sp)
    245e:	e822                	sd	s0,16(sp)
    2460:	e426                	sd	s1,8(sp)
    2462:	e04a                	sd	s2,0(sp)
    2464:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2466:	6509                	lui	a0,0x2
    2468:	00003097          	auipc	ra,0x3
    246c:	216080e7          	jalr	534(ra) # 567e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2470:	57fd                	li	a5,-1
    2472:	06f50263          	beq	a0,a5,24d6 <rwsbrk+0x7c>
    2476:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2478:	7579                	lui	a0,0xffffe
    247a:	00003097          	auipc	ra,0x3
    247e:	204080e7          	jalr	516(ra) # 567e <sbrk>
    2482:	57fd                	li	a5,-1
    2484:	06f50663          	beq	a0,a5,24f0 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2488:	20100593          	li	a1,513
    248c:	00004517          	auipc	a0,0x4
    2490:	3a450513          	add	a0,a0,932 # 6830 <malloc+0xe1a>
    2494:	00003097          	auipc	ra,0x3
    2498:	1a2080e7          	jalr	418(ra) # 5636 <open>
    249c:	892a                	mv	s2,a0
  if(fd < 0){
    249e:	06054663          	bltz	a0,250a <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    24a2:	6785                	lui	a5,0x1
    24a4:	94be                	add	s1,s1,a5
    24a6:	40000613          	li	a2,1024
    24aa:	85a6                	mv	a1,s1
    24ac:	00003097          	auipc	ra,0x3
    24b0:	16a080e7          	jalr	362(ra) # 5616 <write>
    24b4:	862a                	mv	a2,a0
  if(n >= 0){
    24b6:	06054763          	bltz	a0,2524 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24ba:	85a6                	mv	a1,s1
    24bc:	00004517          	auipc	a0,0x4
    24c0:	39450513          	add	a0,a0,916 # 6850 <malloc+0xe3a>
    24c4:	00003097          	auipc	ra,0x3
    24c8:	49a080e7          	jalr	1178(ra) # 595e <printf>
    exit(1);
    24cc:	4505                	li	a0,1
    24ce:	00003097          	auipc	ra,0x3
    24d2:	128080e7          	jalr	296(ra) # 55f6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24d6:	00004517          	auipc	a0,0x4
    24da:	32250513          	add	a0,a0,802 # 67f8 <malloc+0xde2>
    24de:	00003097          	auipc	ra,0x3
    24e2:	480080e7          	jalr	1152(ra) # 595e <printf>
    exit(1);
    24e6:	4505                	li	a0,1
    24e8:	00003097          	auipc	ra,0x3
    24ec:	10e080e7          	jalr	270(ra) # 55f6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f0:	00004517          	auipc	a0,0x4
    24f4:	32050513          	add	a0,a0,800 # 6810 <malloc+0xdfa>
    24f8:	00003097          	auipc	ra,0x3
    24fc:	466080e7          	jalr	1126(ra) # 595e <printf>
    exit(1);
    2500:	4505                	li	a0,1
    2502:	00003097          	auipc	ra,0x3
    2506:	0f4080e7          	jalr	244(ra) # 55f6 <exit>
    printf("open(rwsbrk) failed\n");
    250a:	00004517          	auipc	a0,0x4
    250e:	32e50513          	add	a0,a0,814 # 6838 <malloc+0xe22>
    2512:	00003097          	auipc	ra,0x3
    2516:	44c080e7          	jalr	1100(ra) # 595e <printf>
    exit(1);
    251a:	4505                	li	a0,1
    251c:	00003097          	auipc	ra,0x3
    2520:	0da080e7          	jalr	218(ra) # 55f6 <exit>
  close(fd);
    2524:	854a                	mv	a0,s2
    2526:	00003097          	auipc	ra,0x3
    252a:	0f8080e7          	jalr	248(ra) # 561e <close>
  unlink("rwsbrk");
    252e:	00004517          	auipc	a0,0x4
    2532:	30250513          	add	a0,a0,770 # 6830 <malloc+0xe1a>
    2536:	00003097          	auipc	ra,0x3
    253a:	110080e7          	jalr	272(ra) # 5646 <unlink>
  fd = open("README", O_RDONLY);
    253e:	4581                	li	a1,0
    2540:	00003517          	auipc	a0,0x3
    2544:	7a050513          	add	a0,a0,1952 # 5ce0 <malloc+0x2ca>
    2548:	00003097          	auipc	ra,0x3
    254c:	0ee080e7          	jalr	238(ra) # 5636 <open>
    2550:	892a                	mv	s2,a0
  if(fd < 0){
    2552:	02054963          	bltz	a0,2584 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2556:	4629                	li	a2,10
    2558:	85a6                	mv	a1,s1
    255a:	00003097          	auipc	ra,0x3
    255e:	0b4080e7          	jalr	180(ra) # 560e <read>
    2562:	862a                	mv	a2,a0
  if(n >= 0){
    2564:	02054d63          	bltz	a0,259e <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2568:	85a6                	mv	a1,s1
    256a:	00004517          	auipc	a0,0x4
    256e:	31650513          	add	a0,a0,790 # 6880 <malloc+0xe6a>
    2572:	00003097          	auipc	ra,0x3
    2576:	3ec080e7          	jalr	1004(ra) # 595e <printf>
    exit(1);
    257a:	4505                	li	a0,1
    257c:	00003097          	auipc	ra,0x3
    2580:	07a080e7          	jalr	122(ra) # 55f6 <exit>
    printf("open(rwsbrk) failed\n");
    2584:	00004517          	auipc	a0,0x4
    2588:	2b450513          	add	a0,a0,692 # 6838 <malloc+0xe22>
    258c:	00003097          	auipc	ra,0x3
    2590:	3d2080e7          	jalr	978(ra) # 595e <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	00003097          	auipc	ra,0x3
    259a:	060080e7          	jalr	96(ra) # 55f6 <exit>
  close(fd);
    259e:	854a                	mv	a0,s2
    25a0:	00003097          	auipc	ra,0x3
    25a4:	07e080e7          	jalr	126(ra) # 561e <close>
  exit(0);
    25a8:	4501                	li	a0,0
    25aa:	00003097          	auipc	ra,0x3
    25ae:	04c080e7          	jalr	76(ra) # 55f6 <exit>

00000000000025b2 <sbrkbasic>:
{
    25b2:	7139                	add	sp,sp,-64
    25b4:	fc06                	sd	ra,56(sp)
    25b6:	f822                	sd	s0,48(sp)
    25b8:	f426                	sd	s1,40(sp)
    25ba:	f04a                	sd	s2,32(sp)
    25bc:	ec4e                	sd	s3,24(sp)
    25be:	e852                	sd	s4,16(sp)
    25c0:	0080                	add	s0,sp,64
    25c2:	8a2a                	mv	s4,a0
  pid = fork();
    25c4:	00003097          	auipc	ra,0x3
    25c8:	02a080e7          	jalr	42(ra) # 55ee <fork>
  if(pid < 0){
    25cc:	02054c63          	bltz	a0,2604 <sbrkbasic+0x52>
  if(pid == 0){
    25d0:	ed21                	bnez	a0,2628 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d2:	40000537          	lui	a0,0x40000
    25d6:	00003097          	auipc	ra,0x3
    25da:	0a8080e7          	jalr	168(ra) # 567e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25de:	57fd                	li	a5,-1
    25e0:	02f50f63          	beq	a0,a5,261e <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25e4:	400007b7          	lui	a5,0x40000
    25e8:	97aa                	add	a5,a5,a0
      *b = 99;
    25ea:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ee:	6705                	lui	a4,0x1
      *b = 99;
    25f0:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1528>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f4:	953a                	add	a0,a0,a4
    25f6:	fef51de3          	bne	a0,a5,25f0 <sbrkbasic+0x3e>
    exit(1);
    25fa:	4505                	li	a0,1
    25fc:	00003097          	auipc	ra,0x3
    2600:	ffa080e7          	jalr	-6(ra) # 55f6 <exit>
    printf("fork failed in sbrkbasic\n");
    2604:	00004517          	auipc	a0,0x4
    2608:	2a450513          	add	a0,a0,676 # 68a8 <malloc+0xe92>
    260c:	00003097          	auipc	ra,0x3
    2610:	352080e7          	jalr	850(ra) # 595e <printf>
    exit(1);
    2614:	4505                	li	a0,1
    2616:	00003097          	auipc	ra,0x3
    261a:	fe0080e7          	jalr	-32(ra) # 55f6 <exit>
      exit(0);
    261e:	4501                	li	a0,0
    2620:	00003097          	auipc	ra,0x3
    2624:	fd6080e7          	jalr	-42(ra) # 55f6 <exit>
  wait(&xstatus);
    2628:	fcc40513          	add	a0,s0,-52
    262c:	00003097          	auipc	ra,0x3
    2630:	fd2080e7          	jalr	-46(ra) # 55fe <wait>
  if(xstatus == 1){
    2634:	fcc42703          	lw	a4,-52(s0)
    2638:	4785                	li	a5,1
    263a:	00f70d63          	beq	a4,a5,2654 <sbrkbasic+0xa2>
  a = sbrk(0);
    263e:	4501                	li	a0,0
    2640:	00003097          	auipc	ra,0x3
    2644:	03e080e7          	jalr	62(ra) # 567e <sbrk>
    2648:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    264a:	4901                	li	s2,0
    264c:	6985                	lui	s3,0x1
    264e:	38898993          	add	s3,s3,904 # 1388 <copyinstr2+0x1d8>
    2652:	a005                	j	2672 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2654:	85d2                	mv	a1,s4
    2656:	00004517          	auipc	a0,0x4
    265a:	27250513          	add	a0,a0,626 # 68c8 <malloc+0xeb2>
    265e:	00003097          	auipc	ra,0x3
    2662:	300080e7          	jalr	768(ra) # 595e <printf>
    exit(1);
    2666:	4505                	li	a0,1
    2668:	00003097          	auipc	ra,0x3
    266c:	f8e080e7          	jalr	-114(ra) # 55f6 <exit>
    a = b + 1;
    2670:	84be                	mv	s1,a5
    b = sbrk(1);
    2672:	4505                	li	a0,1
    2674:	00003097          	auipc	ra,0x3
    2678:	00a080e7          	jalr	10(ra) # 567e <sbrk>
    if(b != a){
    267c:	04951c63          	bne	a0,s1,26d4 <sbrkbasic+0x122>
    *b = 1;
    2680:	4785                	li	a5,1
    2682:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2686:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    268a:	2905                	addw	s2,s2,1
    268c:	ff3912e3          	bne	s2,s3,2670 <sbrkbasic+0xbe>
  pid = fork();
    2690:	00003097          	auipc	ra,0x3
    2694:	f5e080e7          	jalr	-162(ra) # 55ee <fork>
    2698:	892a                	mv	s2,a0
  if(pid < 0){
    269a:	04054d63          	bltz	a0,26f4 <sbrkbasic+0x142>
  c = sbrk(1);
    269e:	4505                	li	a0,1
    26a0:	00003097          	auipc	ra,0x3
    26a4:	fde080e7          	jalr	-34(ra) # 567e <sbrk>
  c = sbrk(1);
    26a8:	4505                	li	a0,1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	fd4080e7          	jalr	-44(ra) # 567e <sbrk>
  if(c != a + 1){
    26b2:	0489                	add	s1,s1,2
    26b4:	04a48e63          	beq	s1,a0,2710 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26b8:	85d2                	mv	a1,s4
    26ba:	00004517          	auipc	a0,0x4
    26be:	26e50513          	add	a0,a0,622 # 6928 <malloc+0xf12>
    26c2:	00003097          	auipc	ra,0x3
    26c6:	29c080e7          	jalr	668(ra) # 595e <printf>
    exit(1);
    26ca:	4505                	li	a0,1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	f2a080e7          	jalr	-214(ra) # 55f6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26d4:	86aa                	mv	a3,a0
    26d6:	8626                	mv	a2,s1
    26d8:	85ca                	mv	a1,s2
    26da:	00004517          	auipc	a0,0x4
    26de:	20e50513          	add	a0,a0,526 # 68e8 <malloc+0xed2>
    26e2:	00003097          	auipc	ra,0x3
    26e6:	27c080e7          	jalr	636(ra) # 595e <printf>
      exit(1);
    26ea:	4505                	li	a0,1
    26ec:	00003097          	auipc	ra,0x3
    26f0:	f0a080e7          	jalr	-246(ra) # 55f6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26f4:	85d2                	mv	a1,s4
    26f6:	00004517          	auipc	a0,0x4
    26fa:	21250513          	add	a0,a0,530 # 6908 <malloc+0xef2>
    26fe:	00003097          	auipc	ra,0x3
    2702:	260080e7          	jalr	608(ra) # 595e <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	00003097          	auipc	ra,0x3
    270c:	eee080e7          	jalr	-274(ra) # 55f6 <exit>
  if(pid == 0)
    2710:	00091763          	bnez	s2,271e <sbrkbasic+0x16c>
    exit(0);
    2714:	4501                	li	a0,0
    2716:	00003097          	auipc	ra,0x3
    271a:	ee0080e7          	jalr	-288(ra) # 55f6 <exit>
  wait(&xstatus);
    271e:	fcc40513          	add	a0,s0,-52
    2722:	00003097          	auipc	ra,0x3
    2726:	edc080e7          	jalr	-292(ra) # 55fe <wait>
  exit(xstatus);
    272a:	fcc42503          	lw	a0,-52(s0)
    272e:	00003097          	auipc	ra,0x3
    2732:	ec8080e7          	jalr	-312(ra) # 55f6 <exit>

0000000000002736 <sbrkmuch>:
{
    2736:	7179                	add	sp,sp,-48
    2738:	f406                	sd	ra,40(sp)
    273a:	f022                	sd	s0,32(sp)
    273c:	ec26                	sd	s1,24(sp)
    273e:	e84a                	sd	s2,16(sp)
    2740:	e44e                	sd	s3,8(sp)
    2742:	e052                	sd	s4,0(sp)
    2744:	1800                	add	s0,sp,48
    2746:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2748:	4501                	li	a0,0
    274a:	00003097          	auipc	ra,0x3
    274e:	f34080e7          	jalr	-204(ra) # 567e <sbrk>
    2752:	892a                	mv	s2,a0
  a = sbrk(0);
    2754:	4501                	li	a0,0
    2756:	00003097          	auipc	ra,0x3
    275a:	f28080e7          	jalr	-216(ra) # 567e <sbrk>
    275e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2760:	06400537          	lui	a0,0x6400
    2764:	9d05                	subw	a0,a0,s1
    2766:	00003097          	auipc	ra,0x3
    276a:	f18080e7          	jalr	-232(ra) # 567e <sbrk>
  if (p != a) {
    276e:	0ca49863          	bne	s1,a0,283e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2772:	4501                	li	a0,0
    2774:	00003097          	auipc	ra,0x3
    2778:	f0a080e7          	jalr	-246(ra) # 567e <sbrk>
    277c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    277e:	00a4f963          	bgeu	s1,a0,2790 <sbrkmuch+0x5a>
    *pp = 1;
    2782:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2784:	6705                	lui	a4,0x1
    *pp = 1;
    2786:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    278a:	94ba                	add	s1,s1,a4
    278c:	fef4ede3          	bltu	s1,a5,2786 <sbrkmuch+0x50>
  *lastaddr = 99;
    2790:	064007b7          	lui	a5,0x6400
    2794:	06300713          	li	a4,99
    2798:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1527>
  a = sbrk(0);
    279c:	4501                	li	a0,0
    279e:	00003097          	auipc	ra,0x3
    27a2:	ee0080e7          	jalr	-288(ra) # 567e <sbrk>
    27a6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27a8:	757d                	lui	a0,0xfffff
    27aa:	00003097          	auipc	ra,0x3
    27ae:	ed4080e7          	jalr	-300(ra) # 567e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b2:	57fd                	li	a5,-1
    27b4:	0af50363          	beq	a0,a5,285a <sbrkmuch+0x124>
  c = sbrk(0);
    27b8:	4501                	li	a0,0
    27ba:	00003097          	auipc	ra,0x3
    27be:	ec4080e7          	jalr	-316(ra) # 567e <sbrk>
  if(c != a - PGSIZE){
    27c2:	77fd                	lui	a5,0xfffff
    27c4:	97a6                	add	a5,a5,s1
    27c6:	0af51863          	bne	a0,a5,2876 <sbrkmuch+0x140>
  a = sbrk(0);
    27ca:	4501                	li	a0,0
    27cc:	00003097          	auipc	ra,0x3
    27d0:	eb2080e7          	jalr	-334(ra) # 567e <sbrk>
    27d4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27d6:	6505                	lui	a0,0x1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	ea6080e7          	jalr	-346(ra) # 567e <sbrk>
    27e0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e2:	0aa49a63          	bne	s1,a0,2896 <sbrkmuch+0x160>
    27e6:	4501                	li	a0,0
    27e8:	00003097          	auipc	ra,0x3
    27ec:	e96080e7          	jalr	-362(ra) # 567e <sbrk>
    27f0:	6785                	lui	a5,0x1
    27f2:	97a6                	add	a5,a5,s1
    27f4:	0af51163          	bne	a0,a5,2896 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27f8:	064007b7          	lui	a5,0x6400
    27fc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1527>
    2800:	06300793          	li	a5,99
    2804:	0af70963          	beq	a4,a5,28b6 <sbrkmuch+0x180>
  a = sbrk(0);
    2808:	4501                	li	a0,0
    280a:	00003097          	auipc	ra,0x3
    280e:	e74080e7          	jalr	-396(ra) # 567e <sbrk>
    2812:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2814:	4501                	li	a0,0
    2816:	00003097          	auipc	ra,0x3
    281a:	e68080e7          	jalr	-408(ra) # 567e <sbrk>
    281e:	40a9053b          	subw	a0,s2,a0
    2822:	00003097          	auipc	ra,0x3
    2826:	e5c080e7          	jalr	-420(ra) # 567e <sbrk>
  if(c != a){
    282a:	0aa49463          	bne	s1,a0,28d2 <sbrkmuch+0x19c>
}
    282e:	70a2                	ld	ra,40(sp)
    2830:	7402                	ld	s0,32(sp)
    2832:	64e2                	ld	s1,24(sp)
    2834:	6942                	ld	s2,16(sp)
    2836:	69a2                	ld	s3,8(sp)
    2838:	6a02                	ld	s4,0(sp)
    283a:	6145                	add	sp,sp,48
    283c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    283e:	85ce                	mv	a1,s3
    2840:	00004517          	auipc	a0,0x4
    2844:	10850513          	add	a0,a0,264 # 6948 <malloc+0xf32>
    2848:	00003097          	auipc	ra,0x3
    284c:	116080e7          	jalr	278(ra) # 595e <printf>
    exit(1);
    2850:	4505                	li	a0,1
    2852:	00003097          	auipc	ra,0x3
    2856:	da4080e7          	jalr	-604(ra) # 55f6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    285a:	85ce                	mv	a1,s3
    285c:	00004517          	auipc	a0,0x4
    2860:	13450513          	add	a0,a0,308 # 6990 <malloc+0xf7a>
    2864:	00003097          	auipc	ra,0x3
    2868:	0fa080e7          	jalr	250(ra) # 595e <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	00003097          	auipc	ra,0x3
    2872:	d88080e7          	jalr	-632(ra) # 55f6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2876:	86aa                	mv	a3,a0
    2878:	8626                	mv	a2,s1
    287a:	85ce                	mv	a1,s3
    287c:	00004517          	auipc	a0,0x4
    2880:	13450513          	add	a0,a0,308 # 69b0 <malloc+0xf9a>
    2884:	00003097          	auipc	ra,0x3
    2888:	0da080e7          	jalr	218(ra) # 595e <printf>
    exit(1);
    288c:	4505                	li	a0,1
    288e:	00003097          	auipc	ra,0x3
    2892:	d68080e7          	jalr	-664(ra) # 55f6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2896:	86d2                	mv	a3,s4
    2898:	8626                	mv	a2,s1
    289a:	85ce                	mv	a1,s3
    289c:	00004517          	auipc	a0,0x4
    28a0:	15450513          	add	a0,a0,340 # 69f0 <malloc+0xfda>
    28a4:	00003097          	auipc	ra,0x3
    28a8:	0ba080e7          	jalr	186(ra) # 595e <printf>
    exit(1);
    28ac:	4505                	li	a0,1
    28ae:	00003097          	auipc	ra,0x3
    28b2:	d48080e7          	jalr	-696(ra) # 55f6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28b6:	85ce                	mv	a1,s3
    28b8:	00004517          	auipc	a0,0x4
    28bc:	16850513          	add	a0,a0,360 # 6a20 <malloc+0x100a>
    28c0:	00003097          	auipc	ra,0x3
    28c4:	09e080e7          	jalr	158(ra) # 595e <printf>
    exit(1);
    28c8:	4505                	li	a0,1
    28ca:	00003097          	auipc	ra,0x3
    28ce:	d2c080e7          	jalr	-724(ra) # 55f6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d2:	86aa                	mv	a3,a0
    28d4:	8626                	mv	a2,s1
    28d6:	85ce                	mv	a1,s3
    28d8:	00004517          	auipc	a0,0x4
    28dc:	18050513          	add	a0,a0,384 # 6a58 <malloc+0x1042>
    28e0:	00003097          	auipc	ra,0x3
    28e4:	07e080e7          	jalr	126(ra) # 595e <printf>
    exit(1);
    28e8:	4505                	li	a0,1
    28ea:	00003097          	auipc	ra,0x3
    28ee:	d0c080e7          	jalr	-756(ra) # 55f6 <exit>

00000000000028f2 <sbrkarg>:
{
    28f2:	7179                	add	sp,sp,-48
    28f4:	f406                	sd	ra,40(sp)
    28f6:	f022                	sd	s0,32(sp)
    28f8:	ec26                	sd	s1,24(sp)
    28fa:	e84a                	sd	s2,16(sp)
    28fc:	e44e                	sd	s3,8(sp)
    28fe:	1800                	add	s0,sp,48
    2900:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2902:	6505                	lui	a0,0x1
    2904:	00003097          	auipc	ra,0x3
    2908:	d7a080e7          	jalr	-646(ra) # 567e <sbrk>
    290c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    290e:	20100593          	li	a1,513
    2912:	00004517          	auipc	a0,0x4
    2916:	16e50513          	add	a0,a0,366 # 6a80 <malloc+0x106a>
    291a:	00003097          	auipc	ra,0x3
    291e:	d1c080e7          	jalr	-740(ra) # 5636 <open>
    2922:	84aa                	mv	s1,a0
  unlink("sbrk");
    2924:	00004517          	auipc	a0,0x4
    2928:	15c50513          	add	a0,a0,348 # 6a80 <malloc+0x106a>
    292c:	00003097          	auipc	ra,0x3
    2930:	d1a080e7          	jalr	-742(ra) # 5646 <unlink>
  if(fd < 0)  {
    2934:	0404c163          	bltz	s1,2976 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2938:	6605                	lui	a2,0x1
    293a:	85ca                	mv	a1,s2
    293c:	8526                	mv	a0,s1
    293e:	00003097          	auipc	ra,0x3
    2942:	cd8080e7          	jalr	-808(ra) # 5616 <write>
    2946:	04054663          	bltz	a0,2992 <sbrkarg+0xa0>
  close(fd);
    294a:	8526                	mv	a0,s1
    294c:	00003097          	auipc	ra,0x3
    2950:	cd2080e7          	jalr	-814(ra) # 561e <close>
  a = sbrk(PGSIZE);
    2954:	6505                	lui	a0,0x1
    2956:	00003097          	auipc	ra,0x3
    295a:	d28080e7          	jalr	-728(ra) # 567e <sbrk>
  if(pipe((int *) a) != 0){
    295e:	00003097          	auipc	ra,0x3
    2962:	ca8080e7          	jalr	-856(ra) # 5606 <pipe>
    2966:	e521                	bnez	a0,29ae <sbrkarg+0xbc>
}
    2968:	70a2                	ld	ra,40(sp)
    296a:	7402                	ld	s0,32(sp)
    296c:	64e2                	ld	s1,24(sp)
    296e:	6942                	ld	s2,16(sp)
    2970:	69a2                	ld	s3,8(sp)
    2972:	6145                	add	sp,sp,48
    2974:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2976:	85ce                	mv	a1,s3
    2978:	00004517          	auipc	a0,0x4
    297c:	11050513          	add	a0,a0,272 # 6a88 <malloc+0x1072>
    2980:	00003097          	auipc	ra,0x3
    2984:	fde080e7          	jalr	-34(ra) # 595e <printf>
    exit(1);
    2988:	4505                	li	a0,1
    298a:	00003097          	auipc	ra,0x3
    298e:	c6c080e7          	jalr	-916(ra) # 55f6 <exit>
    printf("%s: write sbrk failed\n", s);
    2992:	85ce                	mv	a1,s3
    2994:	00004517          	auipc	a0,0x4
    2998:	10c50513          	add	a0,a0,268 # 6aa0 <malloc+0x108a>
    299c:	00003097          	auipc	ra,0x3
    29a0:	fc2080e7          	jalr	-62(ra) # 595e <printf>
    exit(1);
    29a4:	4505                	li	a0,1
    29a6:	00003097          	auipc	ra,0x3
    29aa:	c50080e7          	jalr	-944(ra) # 55f6 <exit>
    printf("%s: pipe() failed\n", s);
    29ae:	85ce                	mv	a1,s3
    29b0:	00004517          	auipc	a0,0x4
    29b4:	ae850513          	add	a0,a0,-1304 # 6498 <malloc+0xa82>
    29b8:	00003097          	auipc	ra,0x3
    29bc:	fa6080e7          	jalr	-90(ra) # 595e <printf>
    exit(1);
    29c0:	4505                	li	a0,1
    29c2:	00003097          	auipc	ra,0x3
    29c6:	c34080e7          	jalr	-972(ra) # 55f6 <exit>

00000000000029ca <argptest>:
{
    29ca:	1101                	add	sp,sp,-32
    29cc:	ec06                	sd	ra,24(sp)
    29ce:	e822                	sd	s0,16(sp)
    29d0:	e426                	sd	s1,8(sp)
    29d2:	e04a                	sd	s2,0(sp)
    29d4:	1000                	add	s0,sp,32
    29d6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29d8:	4581                	li	a1,0
    29da:	00004517          	auipc	a0,0x4
    29de:	0de50513          	add	a0,a0,222 # 6ab8 <malloc+0x10a2>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	c54080e7          	jalr	-940(ra) # 5636 <open>
  if (fd < 0) {
    29ea:	02054b63          	bltz	a0,2a20 <argptest+0x56>
    29ee:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f0:	4501                	li	a0,0
    29f2:	00003097          	auipc	ra,0x3
    29f6:	c8c080e7          	jalr	-884(ra) # 567e <sbrk>
    29fa:	567d                	li	a2,-1
    29fc:	fff50593          	add	a1,a0,-1
    2a00:	8526                	mv	a0,s1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	c0c080e7          	jalr	-1012(ra) # 560e <read>
  close(fd);
    2a0a:	8526                	mv	a0,s1
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	c12080e7          	jalr	-1006(ra) # 561e <close>
}
    2a14:	60e2                	ld	ra,24(sp)
    2a16:	6442                	ld	s0,16(sp)
    2a18:	64a2                	ld	s1,8(sp)
    2a1a:	6902                	ld	s2,0(sp)
    2a1c:	6105                	add	sp,sp,32
    2a1e:	8082                	ret
    printf("%s: open failed\n", s);
    2a20:	85ca                	mv	a1,s2
    2a22:	00004517          	auipc	a0,0x4
    2a26:	98650513          	add	a0,a0,-1658 # 63a8 <malloc+0x992>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	f34080e7          	jalr	-204(ra) # 595e <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	bc2080e7          	jalr	-1086(ra) # 55f6 <exit>

0000000000002a3c <sbrkbugs>:
{
    2a3c:	1141                	add	sp,sp,-16
    2a3e:	e406                	sd	ra,8(sp)
    2a40:	e022                	sd	s0,0(sp)
    2a42:	0800                	add	s0,sp,16
  int pid = fork();
    2a44:	00003097          	auipc	ra,0x3
    2a48:	baa080e7          	jalr	-1110(ra) # 55ee <fork>
  if(pid < 0){
    2a4c:	02054263          	bltz	a0,2a70 <sbrkbugs+0x34>
  if(pid == 0){
    2a50:	ed0d                	bnez	a0,2a8a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a52:	00003097          	auipc	ra,0x3
    2a56:	c2c080e7          	jalr	-980(ra) # 567e <sbrk>
    sbrk(-sz);
    2a5a:	40a0053b          	negw	a0,a0
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	c20080e7          	jalr	-992(ra) # 567e <sbrk>
    exit(0);
    2a66:	4501                	li	a0,0
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	b8e080e7          	jalr	-1138(ra) # 55f6 <exit>
    printf("fork failed\n");
    2a70:	00004517          	auipc	a0,0x4
    2a74:	d2850513          	add	a0,a0,-728 # 6798 <malloc+0xd82>
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	ee6080e7          	jalr	-282(ra) # 595e <printf>
    exit(1);
    2a80:	4505                	li	a0,1
    2a82:	00003097          	auipc	ra,0x3
    2a86:	b74080e7          	jalr	-1164(ra) # 55f6 <exit>
  wait(0);
    2a8a:	4501                	li	a0,0
    2a8c:	00003097          	auipc	ra,0x3
    2a90:	b72080e7          	jalr	-1166(ra) # 55fe <wait>
  pid = fork();
    2a94:	00003097          	auipc	ra,0x3
    2a98:	b5a080e7          	jalr	-1190(ra) # 55ee <fork>
  if(pid < 0){
    2a9c:	02054563          	bltz	a0,2ac6 <sbrkbugs+0x8a>
  if(pid == 0){
    2aa0:	e121                	bnez	a0,2ae0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	bdc080e7          	jalr	-1060(ra) # 567e <sbrk>
    sbrk(-(sz - 3500));
    2aaa:	6785                	lui	a5,0x1
    2aac:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x98>
    2ab0:	40a7853b          	subw	a0,a5,a0
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	bca080e7          	jalr	-1078(ra) # 567e <sbrk>
    exit(0);
    2abc:	4501                	li	a0,0
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	b38080e7          	jalr	-1224(ra) # 55f6 <exit>
    printf("fork failed\n");
    2ac6:	00004517          	auipc	a0,0x4
    2aca:	cd250513          	add	a0,a0,-814 # 6798 <malloc+0xd82>
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	e90080e7          	jalr	-368(ra) # 595e <printf>
    exit(1);
    2ad6:	4505                	li	a0,1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	b1e080e7          	jalr	-1250(ra) # 55f6 <exit>
  wait(0);
    2ae0:	4501                	li	a0,0
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	b1c080e7          	jalr	-1252(ra) # 55fe <wait>
  pid = fork();
    2aea:	00003097          	auipc	ra,0x3
    2aee:	b04080e7          	jalr	-1276(ra) # 55ee <fork>
  if(pid < 0){
    2af2:	02054a63          	bltz	a0,2b26 <sbrkbugs+0xea>
  if(pid == 0){
    2af6:	e529                	bnez	a0,2b40 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2af8:	00003097          	auipc	ra,0x3
    2afc:	b86080e7          	jalr	-1146(ra) # 567e <sbrk>
    2b00:	67ad                	lui	a5,0xb
    2b02:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1448>
    2b06:	40a7853b          	subw	a0,a5,a0
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	b74080e7          	jalr	-1164(ra) # 567e <sbrk>
    sbrk(-10);
    2b12:	5559                	li	a0,-10
    2b14:	00003097          	auipc	ra,0x3
    2b18:	b6a080e7          	jalr	-1174(ra) # 567e <sbrk>
    exit(0);
    2b1c:	4501                	li	a0,0
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	ad8080e7          	jalr	-1320(ra) # 55f6 <exit>
    printf("fork failed\n");
    2b26:	00004517          	auipc	a0,0x4
    2b2a:	c7250513          	add	a0,a0,-910 # 6798 <malloc+0xd82>
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	e30080e7          	jalr	-464(ra) # 595e <printf>
    exit(1);
    2b36:	4505                	li	a0,1
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	abe080e7          	jalr	-1346(ra) # 55f6 <exit>
  wait(0);
    2b40:	4501                	li	a0,0
    2b42:	00003097          	auipc	ra,0x3
    2b46:	abc080e7          	jalr	-1348(ra) # 55fe <wait>
  exit(0);
    2b4a:	4501                	li	a0,0
    2b4c:	00003097          	auipc	ra,0x3
    2b50:	aaa080e7          	jalr	-1366(ra) # 55f6 <exit>

0000000000002b54 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b54:	715d                	add	sp,sp,-80
    2b56:	e486                	sd	ra,72(sp)
    2b58:	e0a2                	sd	s0,64(sp)
    2b5a:	fc26                	sd	s1,56(sp)
    2b5c:	f84a                	sd	s2,48(sp)
    2b5e:	f44e                	sd	s3,40(sp)
    2b60:	f052                	sd	s4,32(sp)
    2b62:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b64:	4901                	li	s2,0
    2b66:	49bd                	li	s3,15
    int pid = fork();
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	a86080e7          	jalr	-1402(ra) # 55ee <fork>
    2b70:	84aa                	mv	s1,a0
    if(pid < 0){
    2b72:	02054063          	bltz	a0,2b92 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b76:	c91d                	beqz	a0,2bac <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b78:	4501                	li	a0,0
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	a84080e7          	jalr	-1404(ra) # 55fe <wait>
  for(int avail = 0; avail < 15; avail++){
    2b82:	2905                	addw	s2,s2,1
    2b84:	ff3912e3          	bne	s2,s3,2b68 <execout+0x14>
    }
  }

  exit(0);
    2b88:	4501                	li	a0,0
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	a6c080e7          	jalr	-1428(ra) # 55f6 <exit>
      printf("fork failed\n");
    2b92:	00004517          	auipc	a0,0x4
    2b96:	c0650513          	add	a0,a0,-1018 # 6798 <malloc+0xd82>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	dc4080e7          	jalr	-572(ra) # 595e <printf>
      exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	a52080e7          	jalr	-1454(ra) # 55f6 <exit>
        if(a == 0xffffffffffffffffLL)
    2bac:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bae:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb0:	6505                	lui	a0,0x1
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	acc080e7          	jalr	-1332(ra) # 567e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bba:	01350763          	beq	a0,s3,2bc8 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bbe:	6785                	lui	a5,0x1
    2bc0:	97aa                	add	a5,a5,a0
    2bc2:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9f>
      while(1){
    2bc6:	b7ed                	j	2bb0 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bc8:	01205a63          	blez	s2,2bdc <execout+0x88>
        sbrk(-4096);
    2bcc:	757d                	lui	a0,0xfffff
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	ab0080e7          	jalr	-1360(ra) # 567e <sbrk>
      for(int i = 0; i < avail; i++)
    2bd6:	2485                	addw	s1,s1,1
    2bd8:	ff249ae3          	bne	s1,s2,2bcc <execout+0x78>
      close(1);
    2bdc:	4505                	li	a0,1
    2bde:	00003097          	auipc	ra,0x3
    2be2:	a40080e7          	jalr	-1472(ra) # 561e <close>
      char *args[] = { "echo", "x", 0 };
    2be6:	00003517          	auipc	a0,0x3
    2bea:	f5250513          	add	a0,a0,-174 # 5b38 <malloc+0x122>
    2bee:	faa43c23          	sd	a0,-72(s0)
    2bf2:	00003797          	auipc	a5,0x3
    2bf6:	fb678793          	add	a5,a5,-74 # 5ba8 <malloc+0x192>
    2bfa:	fcf43023          	sd	a5,-64(s0)
    2bfe:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c02:	fb840593          	add	a1,s0,-72
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	a28080e7          	jalr	-1496(ra) # 562e <exec>
      exit(0);
    2c0e:	4501                	li	a0,0
    2c10:	00003097          	auipc	ra,0x3
    2c14:	9e6080e7          	jalr	-1562(ra) # 55f6 <exit>

0000000000002c18 <fourteen>:
{
    2c18:	1101                	add	sp,sp,-32
    2c1a:	ec06                	sd	ra,24(sp)
    2c1c:	e822                	sd	s0,16(sp)
    2c1e:	e426                	sd	s1,8(sp)
    2c20:	1000                	add	s0,sp,32
    2c22:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c24:	00004517          	auipc	a0,0x4
    2c28:	06c50513          	add	a0,a0,108 # 6c90 <malloc+0x127a>
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	a32080e7          	jalr	-1486(ra) # 565e <mkdir>
    2c34:	e165                	bnez	a0,2d14 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c36:	00004517          	auipc	a0,0x4
    2c3a:	eb250513          	add	a0,a0,-334 # 6ae8 <malloc+0x10d2>
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	a20080e7          	jalr	-1504(ra) # 565e <mkdir>
    2c46:	e56d                	bnez	a0,2d30 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c48:	20000593          	li	a1,512
    2c4c:	00004517          	auipc	a0,0x4
    2c50:	ef450513          	add	a0,a0,-268 # 6b40 <malloc+0x112a>
    2c54:	00003097          	auipc	ra,0x3
    2c58:	9e2080e7          	jalr	-1566(ra) # 5636 <open>
  if(fd < 0){
    2c5c:	0e054863          	bltz	a0,2d4c <fourteen+0x134>
  close(fd);
    2c60:	00003097          	auipc	ra,0x3
    2c64:	9be080e7          	jalr	-1602(ra) # 561e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c68:	4581                	li	a1,0
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	f4e50513          	add	a0,a0,-178 # 6bb8 <malloc+0x11a2>
    2c72:	00003097          	auipc	ra,0x3
    2c76:	9c4080e7          	jalr	-1596(ra) # 5636 <open>
  if(fd < 0){
    2c7a:	0e054763          	bltz	a0,2d68 <fourteen+0x150>
  close(fd);
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	9a0080e7          	jalr	-1632(ra) # 561e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	fa250513          	add	a0,a0,-94 # 6c28 <malloc+0x1212>
    2c8e:	00003097          	auipc	ra,0x3
    2c92:	9d0080e7          	jalr	-1584(ra) # 565e <mkdir>
    2c96:	c57d                	beqz	a0,2d84 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	fe850513          	add	a0,a0,-24 # 6c80 <malloc+0x126a>
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	9be080e7          	jalr	-1602(ra) # 565e <mkdir>
    2ca8:	cd65                	beqz	a0,2da0 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2caa:	00004517          	auipc	a0,0x4
    2cae:	fd650513          	add	a0,a0,-42 # 6c80 <malloc+0x126a>
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	994080e7          	jalr	-1644(ra) # 5646 <unlink>
  unlink("12345678901234/12345678901234");
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	f6e50513          	add	a0,a0,-146 # 6c28 <malloc+0x1212>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	984080e7          	jalr	-1660(ra) # 5646 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cca:	00004517          	auipc	a0,0x4
    2cce:	eee50513          	add	a0,a0,-274 # 6bb8 <malloc+0x11a2>
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	974080e7          	jalr	-1676(ra) # 5646 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2cda:	00004517          	auipc	a0,0x4
    2cde:	e6650513          	add	a0,a0,-410 # 6b40 <malloc+0x112a>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	964080e7          	jalr	-1692(ra) # 5646 <unlink>
  unlink("12345678901234/123456789012345");
    2cea:	00004517          	auipc	a0,0x4
    2cee:	dfe50513          	add	a0,a0,-514 # 6ae8 <malloc+0x10d2>
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	954080e7          	jalr	-1708(ra) # 5646 <unlink>
  unlink("12345678901234");
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	f9650513          	add	a0,a0,-106 # 6c90 <malloc+0x127a>
    2d02:	00003097          	auipc	ra,0x3
    2d06:	944080e7          	jalr	-1724(ra) # 5646 <unlink>
}
    2d0a:	60e2                	ld	ra,24(sp)
    2d0c:	6442                	ld	s0,16(sp)
    2d0e:	64a2                	ld	s1,8(sp)
    2d10:	6105                	add	sp,sp,32
    2d12:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d14:	85a6                	mv	a1,s1
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	daa50513          	add	a0,a0,-598 # 6ac0 <malloc+0x10aa>
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	c40080e7          	jalr	-960(ra) # 595e <printf>
    exit(1);
    2d26:	4505                	li	a0,1
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	8ce080e7          	jalr	-1842(ra) # 55f6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d30:	85a6                	mv	a1,s1
    2d32:	00004517          	auipc	a0,0x4
    2d36:	dd650513          	add	a0,a0,-554 # 6b08 <malloc+0x10f2>
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	c24080e7          	jalr	-988(ra) # 595e <printf>
    exit(1);
    2d42:	4505                	li	a0,1
    2d44:	00003097          	auipc	ra,0x3
    2d48:	8b2080e7          	jalr	-1870(ra) # 55f6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d4c:	85a6                	mv	a1,s1
    2d4e:	00004517          	auipc	a0,0x4
    2d52:	e2250513          	add	a0,a0,-478 # 6b70 <malloc+0x115a>
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	c08080e7          	jalr	-1016(ra) # 595e <printf>
    exit(1);
    2d5e:	4505                	li	a0,1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	896080e7          	jalr	-1898(ra) # 55f6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d68:	85a6                	mv	a1,s1
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	e7e50513          	add	a0,a0,-386 # 6be8 <malloc+0x11d2>
    2d72:	00003097          	auipc	ra,0x3
    2d76:	bec080e7          	jalr	-1044(ra) # 595e <printf>
    exit(1);
    2d7a:	4505                	li	a0,1
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	87a080e7          	jalr	-1926(ra) # 55f6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d84:	85a6                	mv	a1,s1
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	ec250513          	add	a0,a0,-318 # 6c48 <malloc+0x1232>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	bd0080e7          	jalr	-1072(ra) # 595e <printf>
    exit(1);
    2d96:	4505                	li	a0,1
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	85e080e7          	jalr	-1954(ra) # 55f6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da0:	85a6                	mv	a1,s1
    2da2:	00004517          	auipc	a0,0x4
    2da6:	efe50513          	add	a0,a0,-258 # 6ca0 <malloc+0x128a>
    2daa:	00003097          	auipc	ra,0x3
    2dae:	bb4080e7          	jalr	-1100(ra) # 595e <printf>
    exit(1);
    2db2:	4505                	li	a0,1
    2db4:	00003097          	auipc	ra,0x3
    2db8:	842080e7          	jalr	-1982(ra) # 55f6 <exit>

0000000000002dbc <iputtest>:
{
    2dbc:	1101                	add	sp,sp,-32
    2dbe:	ec06                	sd	ra,24(sp)
    2dc0:	e822                	sd	s0,16(sp)
    2dc2:	e426                	sd	s1,8(sp)
    2dc4:	1000                	add	s0,sp,32
    2dc6:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	f1050513          	add	a0,a0,-240 # 6cd8 <malloc+0x12c2>
    2dd0:	00003097          	auipc	ra,0x3
    2dd4:	88e080e7          	jalr	-1906(ra) # 565e <mkdir>
    2dd8:	04054563          	bltz	a0,2e22 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	efc50513          	add	a0,a0,-260 # 6cd8 <malloc+0x12c2>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	882080e7          	jalr	-1918(ra) # 5666 <chdir>
    2dec:	04054963          	bltz	a0,2e3e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df0:	00004517          	auipc	a0,0x4
    2df4:	f2850513          	add	a0,a0,-216 # 6d18 <malloc+0x1302>
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	84e080e7          	jalr	-1970(ra) # 5646 <unlink>
    2e00:	04054d63          	bltz	a0,2e5a <iputtest+0x9e>
  if(chdir("/") < 0){
    2e04:	00004517          	auipc	a0,0x4
    2e08:	f4450513          	add	a0,a0,-188 # 6d48 <malloc+0x1332>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	85a080e7          	jalr	-1958(ra) # 5666 <chdir>
    2e14:	06054163          	bltz	a0,2e76 <iputtest+0xba>
}
    2e18:	60e2                	ld	ra,24(sp)
    2e1a:	6442                	ld	s0,16(sp)
    2e1c:	64a2                	ld	s1,8(sp)
    2e1e:	6105                	add	sp,sp,32
    2e20:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e22:	85a6                	mv	a1,s1
    2e24:	00004517          	auipc	a0,0x4
    2e28:	ebc50513          	add	a0,a0,-324 # 6ce0 <malloc+0x12ca>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	b32080e7          	jalr	-1230(ra) # 595e <printf>
    exit(1);
    2e34:	4505                	li	a0,1
    2e36:	00002097          	auipc	ra,0x2
    2e3a:	7c0080e7          	jalr	1984(ra) # 55f6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e3e:	85a6                	mv	a1,s1
    2e40:	00004517          	auipc	a0,0x4
    2e44:	eb850513          	add	a0,a0,-328 # 6cf8 <malloc+0x12e2>
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	b16080e7          	jalr	-1258(ra) # 595e <printf>
    exit(1);
    2e50:	4505                	li	a0,1
    2e52:	00002097          	auipc	ra,0x2
    2e56:	7a4080e7          	jalr	1956(ra) # 55f6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e5a:	85a6                	mv	a1,s1
    2e5c:	00004517          	auipc	a0,0x4
    2e60:	ecc50513          	add	a0,a0,-308 # 6d28 <malloc+0x1312>
    2e64:	00003097          	auipc	ra,0x3
    2e68:	afa080e7          	jalr	-1286(ra) # 595e <printf>
    exit(1);
    2e6c:	4505                	li	a0,1
    2e6e:	00002097          	auipc	ra,0x2
    2e72:	788080e7          	jalr	1928(ra) # 55f6 <exit>
    printf("%s: chdir / failed\n", s);
    2e76:	85a6                	mv	a1,s1
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	ed850513          	add	a0,a0,-296 # 6d50 <malloc+0x133a>
    2e80:	00003097          	auipc	ra,0x3
    2e84:	ade080e7          	jalr	-1314(ra) # 595e <printf>
    exit(1);
    2e88:	4505                	li	a0,1
    2e8a:	00002097          	auipc	ra,0x2
    2e8e:	76c080e7          	jalr	1900(ra) # 55f6 <exit>

0000000000002e92 <exitiputtest>:
{
    2e92:	7179                	add	sp,sp,-48
    2e94:	f406                	sd	ra,40(sp)
    2e96:	f022                	sd	s0,32(sp)
    2e98:	ec26                	sd	s1,24(sp)
    2e9a:	1800                	add	s0,sp,48
    2e9c:	84aa                	mv	s1,a0
  pid = fork();
    2e9e:	00002097          	auipc	ra,0x2
    2ea2:	750080e7          	jalr	1872(ra) # 55ee <fork>
  if(pid < 0){
    2ea6:	04054663          	bltz	a0,2ef2 <exitiputtest+0x60>
  if(pid == 0){
    2eaa:	ed45                	bnez	a0,2f62 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	e2c50513          	add	a0,a0,-468 # 6cd8 <malloc+0x12c2>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	7aa080e7          	jalr	1962(ra) # 565e <mkdir>
    2ebc:	04054963          	bltz	a0,2f0e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec0:	00004517          	auipc	a0,0x4
    2ec4:	e1850513          	add	a0,a0,-488 # 6cd8 <malloc+0x12c2>
    2ec8:	00002097          	auipc	ra,0x2
    2ecc:	79e080e7          	jalr	1950(ra) # 5666 <chdir>
    2ed0:	04054d63          	bltz	a0,2f2a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	e4450513          	add	a0,a0,-444 # 6d18 <malloc+0x1302>
    2edc:	00002097          	auipc	ra,0x2
    2ee0:	76a080e7          	jalr	1898(ra) # 5646 <unlink>
    2ee4:	06054163          	bltz	a0,2f46 <exitiputtest+0xb4>
    exit(0);
    2ee8:	4501                	li	a0,0
    2eea:	00002097          	auipc	ra,0x2
    2eee:	70c080e7          	jalr	1804(ra) # 55f6 <exit>
    printf("%s: fork failed\n", s);
    2ef2:	85a6                	mv	a1,s1
    2ef4:	00003517          	auipc	a0,0x3
    2ef8:	49c50513          	add	a0,a0,1180 # 6390 <malloc+0x97a>
    2efc:	00003097          	auipc	ra,0x3
    2f00:	a62080e7          	jalr	-1438(ra) # 595e <printf>
    exit(1);
    2f04:	4505                	li	a0,1
    2f06:	00002097          	auipc	ra,0x2
    2f0a:	6f0080e7          	jalr	1776(ra) # 55f6 <exit>
      printf("%s: mkdir failed\n", s);
    2f0e:	85a6                	mv	a1,s1
    2f10:	00004517          	auipc	a0,0x4
    2f14:	dd050513          	add	a0,a0,-560 # 6ce0 <malloc+0x12ca>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	a46080e7          	jalr	-1466(ra) # 595e <printf>
      exit(1);
    2f20:	4505                	li	a0,1
    2f22:	00002097          	auipc	ra,0x2
    2f26:	6d4080e7          	jalr	1748(ra) # 55f6 <exit>
      printf("%s: child chdir failed\n", s);
    2f2a:	85a6                	mv	a1,s1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	e3c50513          	add	a0,a0,-452 # 6d68 <malloc+0x1352>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	a2a080e7          	jalr	-1494(ra) # 595e <printf>
      exit(1);
    2f3c:	4505                	li	a0,1
    2f3e:	00002097          	auipc	ra,0x2
    2f42:	6b8080e7          	jalr	1720(ra) # 55f6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f46:	85a6                	mv	a1,s1
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	de050513          	add	a0,a0,-544 # 6d28 <malloc+0x1312>
    2f50:	00003097          	auipc	ra,0x3
    2f54:	a0e080e7          	jalr	-1522(ra) # 595e <printf>
      exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	00002097          	auipc	ra,0x2
    2f5e:	69c080e7          	jalr	1692(ra) # 55f6 <exit>
  wait(&xstatus);
    2f62:	fdc40513          	add	a0,s0,-36
    2f66:	00002097          	auipc	ra,0x2
    2f6a:	698080e7          	jalr	1688(ra) # 55fe <wait>
  exit(xstatus);
    2f6e:	fdc42503          	lw	a0,-36(s0)
    2f72:	00002097          	auipc	ra,0x2
    2f76:	684080e7          	jalr	1668(ra) # 55f6 <exit>

0000000000002f7a <dirtest>:
{
    2f7a:	1101                	add	sp,sp,-32
    2f7c:	ec06                	sd	ra,24(sp)
    2f7e:	e822                	sd	s0,16(sp)
    2f80:	e426                	sd	s1,8(sp)
    2f82:	1000                	add	s0,sp,32
    2f84:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f86:	00004517          	auipc	a0,0x4
    2f8a:	dfa50513          	add	a0,a0,-518 # 6d80 <malloc+0x136a>
    2f8e:	00002097          	auipc	ra,0x2
    2f92:	6d0080e7          	jalr	1744(ra) # 565e <mkdir>
    2f96:	04054563          	bltz	a0,2fe0 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	de650513          	add	a0,a0,-538 # 6d80 <malloc+0x136a>
    2fa2:	00002097          	auipc	ra,0x2
    2fa6:	6c4080e7          	jalr	1732(ra) # 5666 <chdir>
    2faa:	04054963          	bltz	a0,2ffc <dirtest+0x82>
  if(chdir("..") < 0){
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	df250513          	add	a0,a0,-526 # 6da0 <malloc+0x138a>
    2fb6:	00002097          	auipc	ra,0x2
    2fba:	6b0080e7          	jalr	1712(ra) # 5666 <chdir>
    2fbe:	04054d63          	bltz	a0,3018 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	dbe50513          	add	a0,a0,-578 # 6d80 <malloc+0x136a>
    2fca:	00002097          	auipc	ra,0x2
    2fce:	67c080e7          	jalr	1660(ra) # 5646 <unlink>
    2fd2:	06054163          	bltz	a0,3034 <dirtest+0xba>
}
    2fd6:	60e2                	ld	ra,24(sp)
    2fd8:	6442                	ld	s0,16(sp)
    2fda:	64a2                	ld	s1,8(sp)
    2fdc:	6105                	add	sp,sp,32
    2fde:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe0:	85a6                	mv	a1,s1
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	cfe50513          	add	a0,a0,-770 # 6ce0 <malloc+0x12ca>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	974080e7          	jalr	-1676(ra) # 595e <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	00002097          	auipc	ra,0x2
    2ff8:	602080e7          	jalr	1538(ra) # 55f6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ffc:	85a6                	mv	a1,s1
    2ffe:	00004517          	auipc	a0,0x4
    3002:	d8a50513          	add	a0,a0,-630 # 6d88 <malloc+0x1372>
    3006:	00003097          	auipc	ra,0x3
    300a:	958080e7          	jalr	-1704(ra) # 595e <printf>
    exit(1);
    300e:	4505                	li	a0,1
    3010:	00002097          	auipc	ra,0x2
    3014:	5e6080e7          	jalr	1510(ra) # 55f6 <exit>
    printf("%s: chdir .. failed\n", s);
    3018:	85a6                	mv	a1,s1
    301a:	00004517          	auipc	a0,0x4
    301e:	d8e50513          	add	a0,a0,-626 # 6da8 <malloc+0x1392>
    3022:	00003097          	auipc	ra,0x3
    3026:	93c080e7          	jalr	-1732(ra) # 595e <printf>
    exit(1);
    302a:	4505                	li	a0,1
    302c:	00002097          	auipc	ra,0x2
    3030:	5ca080e7          	jalr	1482(ra) # 55f6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3034:	85a6                	mv	a1,s1
    3036:	00004517          	auipc	a0,0x4
    303a:	d8a50513          	add	a0,a0,-630 # 6dc0 <malloc+0x13aa>
    303e:	00003097          	auipc	ra,0x3
    3042:	920080e7          	jalr	-1760(ra) # 595e <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	00002097          	auipc	ra,0x2
    304c:	5ae080e7          	jalr	1454(ra) # 55f6 <exit>

0000000000003050 <subdir>:
{
    3050:	1101                	add	sp,sp,-32
    3052:	ec06                	sd	ra,24(sp)
    3054:	e822                	sd	s0,16(sp)
    3056:	e426                	sd	s1,8(sp)
    3058:	e04a                	sd	s2,0(sp)
    305a:	1000                	add	s0,sp,32
    305c:	892a                	mv	s2,a0
  unlink("ff");
    305e:	00004517          	auipc	a0,0x4
    3062:	eaa50513          	add	a0,a0,-342 # 6f08 <malloc+0x14f2>
    3066:	00002097          	auipc	ra,0x2
    306a:	5e0080e7          	jalr	1504(ra) # 5646 <unlink>
  if(mkdir("dd") != 0){
    306e:	00004517          	auipc	a0,0x4
    3072:	d6a50513          	add	a0,a0,-662 # 6dd8 <malloc+0x13c2>
    3076:	00002097          	auipc	ra,0x2
    307a:	5e8080e7          	jalr	1512(ra) # 565e <mkdir>
    307e:	38051663          	bnez	a0,340a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3082:	20200593          	li	a1,514
    3086:	00004517          	auipc	a0,0x4
    308a:	d7250513          	add	a0,a0,-654 # 6df8 <malloc+0x13e2>
    308e:	00002097          	auipc	ra,0x2
    3092:	5a8080e7          	jalr	1448(ra) # 5636 <open>
    3096:	84aa                	mv	s1,a0
  if(fd < 0){
    3098:	38054763          	bltz	a0,3426 <subdir+0x3d6>
  write(fd, "ff", 2);
    309c:	4609                	li	a2,2
    309e:	00004597          	auipc	a1,0x4
    30a2:	e6a58593          	add	a1,a1,-406 # 6f08 <malloc+0x14f2>
    30a6:	00002097          	auipc	ra,0x2
    30aa:	570080e7          	jalr	1392(ra) # 5616 <write>
  close(fd);
    30ae:	8526                	mv	a0,s1
    30b0:	00002097          	auipc	ra,0x2
    30b4:	56e080e7          	jalr	1390(ra) # 561e <close>
  if(unlink("dd") >= 0){
    30b8:	00004517          	auipc	a0,0x4
    30bc:	d2050513          	add	a0,a0,-736 # 6dd8 <malloc+0x13c2>
    30c0:	00002097          	auipc	ra,0x2
    30c4:	586080e7          	jalr	1414(ra) # 5646 <unlink>
    30c8:	36055d63          	bgez	a0,3442 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30cc:	00004517          	auipc	a0,0x4
    30d0:	d8450513          	add	a0,a0,-636 # 6e50 <malloc+0x143a>
    30d4:	00002097          	auipc	ra,0x2
    30d8:	58a080e7          	jalr	1418(ra) # 565e <mkdir>
    30dc:	38051163          	bnez	a0,345e <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e0:	20200593          	li	a1,514
    30e4:	00004517          	auipc	a0,0x4
    30e8:	d9450513          	add	a0,a0,-620 # 6e78 <malloc+0x1462>
    30ec:	00002097          	auipc	ra,0x2
    30f0:	54a080e7          	jalr	1354(ra) # 5636 <open>
    30f4:	84aa                	mv	s1,a0
  if(fd < 0){
    30f6:	38054263          	bltz	a0,347a <subdir+0x42a>
  write(fd, "FF", 2);
    30fa:	4609                	li	a2,2
    30fc:	00004597          	auipc	a1,0x4
    3100:	dac58593          	add	a1,a1,-596 # 6ea8 <malloc+0x1492>
    3104:	00002097          	auipc	ra,0x2
    3108:	512080e7          	jalr	1298(ra) # 5616 <write>
  close(fd);
    310c:	8526                	mv	a0,s1
    310e:	00002097          	auipc	ra,0x2
    3112:	510080e7          	jalr	1296(ra) # 561e <close>
  fd = open("dd/dd/../ff", 0);
    3116:	4581                	li	a1,0
    3118:	00004517          	auipc	a0,0x4
    311c:	d9850513          	add	a0,a0,-616 # 6eb0 <malloc+0x149a>
    3120:	00002097          	auipc	ra,0x2
    3124:	516080e7          	jalr	1302(ra) # 5636 <open>
    3128:	84aa                	mv	s1,a0
  if(fd < 0){
    312a:	36054663          	bltz	a0,3496 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    312e:	660d                	lui	a2,0x3
    3130:	00009597          	auipc	a1,0x9
    3134:	99858593          	add	a1,a1,-1640 # bac8 <buf>
    3138:	00002097          	auipc	ra,0x2
    313c:	4d6080e7          	jalr	1238(ra) # 560e <read>
  if(cc != 2 || buf[0] != 'f'){
    3140:	4789                	li	a5,2
    3142:	36f51863          	bne	a0,a5,34b2 <subdir+0x462>
    3146:	00009717          	auipc	a4,0x9
    314a:	98274703          	lbu	a4,-1662(a4) # bac8 <buf>
    314e:	06600793          	li	a5,102
    3152:	36f71063          	bne	a4,a5,34b2 <subdir+0x462>
  close(fd);
    3156:	8526                	mv	a0,s1
    3158:	00002097          	auipc	ra,0x2
    315c:	4c6080e7          	jalr	1222(ra) # 561e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3160:	00004597          	auipc	a1,0x4
    3164:	da058593          	add	a1,a1,-608 # 6f00 <malloc+0x14ea>
    3168:	00004517          	auipc	a0,0x4
    316c:	d1050513          	add	a0,a0,-752 # 6e78 <malloc+0x1462>
    3170:	00002097          	auipc	ra,0x2
    3174:	4e6080e7          	jalr	1254(ra) # 5656 <link>
    3178:	34051b63          	bnez	a0,34ce <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    317c:	00004517          	auipc	a0,0x4
    3180:	cfc50513          	add	a0,a0,-772 # 6e78 <malloc+0x1462>
    3184:	00002097          	auipc	ra,0x2
    3188:	4c2080e7          	jalr	1218(ra) # 5646 <unlink>
    318c:	34051f63          	bnez	a0,34ea <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3190:	4581                	li	a1,0
    3192:	00004517          	auipc	a0,0x4
    3196:	ce650513          	add	a0,a0,-794 # 6e78 <malloc+0x1462>
    319a:	00002097          	auipc	ra,0x2
    319e:	49c080e7          	jalr	1180(ra) # 5636 <open>
    31a2:	36055263          	bgez	a0,3506 <subdir+0x4b6>
  if(chdir("dd") != 0){
    31a6:	00004517          	auipc	a0,0x4
    31aa:	c3250513          	add	a0,a0,-974 # 6dd8 <malloc+0x13c2>
    31ae:	00002097          	auipc	ra,0x2
    31b2:	4b8080e7          	jalr	1208(ra) # 5666 <chdir>
    31b6:	36051663          	bnez	a0,3522 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31ba:	00004517          	auipc	a0,0x4
    31be:	dde50513          	add	a0,a0,-546 # 6f98 <malloc+0x1582>
    31c2:	00002097          	auipc	ra,0x2
    31c6:	4a4080e7          	jalr	1188(ra) # 5666 <chdir>
    31ca:	36051a63          	bnez	a0,353e <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31ce:	00004517          	auipc	a0,0x4
    31d2:	dfa50513          	add	a0,a0,-518 # 6fc8 <malloc+0x15b2>
    31d6:	00002097          	auipc	ra,0x2
    31da:	490080e7          	jalr	1168(ra) # 5666 <chdir>
    31de:	36051e63          	bnez	a0,355a <subdir+0x50a>
  if(chdir("./..") != 0){
    31e2:	00004517          	auipc	a0,0x4
    31e6:	e1650513          	add	a0,a0,-490 # 6ff8 <malloc+0x15e2>
    31ea:	00002097          	auipc	ra,0x2
    31ee:	47c080e7          	jalr	1148(ra) # 5666 <chdir>
    31f2:	38051263          	bnez	a0,3576 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31f6:	4581                	li	a1,0
    31f8:	00004517          	auipc	a0,0x4
    31fc:	d0850513          	add	a0,a0,-760 # 6f00 <malloc+0x14ea>
    3200:	00002097          	auipc	ra,0x2
    3204:	436080e7          	jalr	1078(ra) # 5636 <open>
    3208:	84aa                	mv	s1,a0
  if(fd < 0){
    320a:	38054463          	bltz	a0,3592 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    320e:	660d                	lui	a2,0x3
    3210:	00009597          	auipc	a1,0x9
    3214:	8b858593          	add	a1,a1,-1864 # bac8 <buf>
    3218:	00002097          	auipc	ra,0x2
    321c:	3f6080e7          	jalr	1014(ra) # 560e <read>
    3220:	4789                	li	a5,2
    3222:	38f51663          	bne	a0,a5,35ae <subdir+0x55e>
  close(fd);
    3226:	8526                	mv	a0,s1
    3228:	00002097          	auipc	ra,0x2
    322c:	3f6080e7          	jalr	1014(ra) # 561e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3230:	4581                	li	a1,0
    3232:	00004517          	auipc	a0,0x4
    3236:	c4650513          	add	a0,a0,-954 # 6e78 <malloc+0x1462>
    323a:	00002097          	auipc	ra,0x2
    323e:	3fc080e7          	jalr	1020(ra) # 5636 <open>
    3242:	38055463          	bgez	a0,35ca <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3246:	20200593          	li	a1,514
    324a:	00004517          	auipc	a0,0x4
    324e:	e3e50513          	add	a0,a0,-450 # 7088 <malloc+0x1672>
    3252:	00002097          	auipc	ra,0x2
    3256:	3e4080e7          	jalr	996(ra) # 5636 <open>
    325a:	38055663          	bgez	a0,35e6 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    325e:	20200593          	li	a1,514
    3262:	00004517          	auipc	a0,0x4
    3266:	e5650513          	add	a0,a0,-426 # 70b8 <malloc+0x16a2>
    326a:	00002097          	auipc	ra,0x2
    326e:	3cc080e7          	jalr	972(ra) # 5636 <open>
    3272:	38055863          	bgez	a0,3602 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3276:	20000593          	li	a1,512
    327a:	00004517          	auipc	a0,0x4
    327e:	b5e50513          	add	a0,a0,-1186 # 6dd8 <malloc+0x13c2>
    3282:	00002097          	auipc	ra,0x2
    3286:	3b4080e7          	jalr	948(ra) # 5636 <open>
    328a:	38055a63          	bgez	a0,361e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    328e:	4589                	li	a1,2
    3290:	00004517          	auipc	a0,0x4
    3294:	b4850513          	add	a0,a0,-1208 # 6dd8 <malloc+0x13c2>
    3298:	00002097          	auipc	ra,0x2
    329c:	39e080e7          	jalr	926(ra) # 5636 <open>
    32a0:	38055d63          	bgez	a0,363a <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32a4:	4585                	li	a1,1
    32a6:	00004517          	auipc	a0,0x4
    32aa:	b3250513          	add	a0,a0,-1230 # 6dd8 <malloc+0x13c2>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	388080e7          	jalr	904(ra) # 5636 <open>
    32b6:	3a055063          	bgez	a0,3656 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32ba:	00004597          	auipc	a1,0x4
    32be:	e8e58593          	add	a1,a1,-370 # 7148 <malloc+0x1732>
    32c2:	00004517          	auipc	a0,0x4
    32c6:	dc650513          	add	a0,a0,-570 # 7088 <malloc+0x1672>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	38c080e7          	jalr	908(ra) # 5656 <link>
    32d2:	3a050063          	beqz	a0,3672 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32d6:	00004597          	auipc	a1,0x4
    32da:	e7258593          	add	a1,a1,-398 # 7148 <malloc+0x1732>
    32de:	00004517          	auipc	a0,0x4
    32e2:	dda50513          	add	a0,a0,-550 # 70b8 <malloc+0x16a2>
    32e6:	00002097          	auipc	ra,0x2
    32ea:	370080e7          	jalr	880(ra) # 5656 <link>
    32ee:	3a050063          	beqz	a0,368e <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f2:	00004597          	auipc	a1,0x4
    32f6:	c0e58593          	add	a1,a1,-1010 # 6f00 <malloc+0x14ea>
    32fa:	00004517          	auipc	a0,0x4
    32fe:	afe50513          	add	a0,a0,-1282 # 6df8 <malloc+0x13e2>
    3302:	00002097          	auipc	ra,0x2
    3306:	354080e7          	jalr	852(ra) # 5656 <link>
    330a:	3a050063          	beqz	a0,36aa <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    330e:	00004517          	auipc	a0,0x4
    3312:	d7a50513          	add	a0,a0,-646 # 7088 <malloc+0x1672>
    3316:	00002097          	auipc	ra,0x2
    331a:	348080e7          	jalr	840(ra) # 565e <mkdir>
    331e:	3a050463          	beqz	a0,36c6 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3322:	00004517          	auipc	a0,0x4
    3326:	d9650513          	add	a0,a0,-618 # 70b8 <malloc+0x16a2>
    332a:	00002097          	auipc	ra,0x2
    332e:	334080e7          	jalr	820(ra) # 565e <mkdir>
    3332:	3a050863          	beqz	a0,36e2 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3336:	00004517          	auipc	a0,0x4
    333a:	bca50513          	add	a0,a0,-1078 # 6f00 <malloc+0x14ea>
    333e:	00002097          	auipc	ra,0x2
    3342:	320080e7          	jalr	800(ra) # 565e <mkdir>
    3346:	3a050c63          	beqz	a0,36fe <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    334a:	00004517          	auipc	a0,0x4
    334e:	d6e50513          	add	a0,a0,-658 # 70b8 <malloc+0x16a2>
    3352:	00002097          	auipc	ra,0x2
    3356:	2f4080e7          	jalr	756(ra) # 5646 <unlink>
    335a:	3c050063          	beqz	a0,371a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    335e:	00004517          	auipc	a0,0x4
    3362:	d2a50513          	add	a0,a0,-726 # 7088 <malloc+0x1672>
    3366:	00002097          	auipc	ra,0x2
    336a:	2e0080e7          	jalr	736(ra) # 5646 <unlink>
    336e:	3c050463          	beqz	a0,3736 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3372:	00004517          	auipc	a0,0x4
    3376:	a8650513          	add	a0,a0,-1402 # 6df8 <malloc+0x13e2>
    337a:	00002097          	auipc	ra,0x2
    337e:	2ec080e7          	jalr	748(ra) # 5666 <chdir>
    3382:	3c050863          	beqz	a0,3752 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3386:	00004517          	auipc	a0,0x4
    338a:	f1250513          	add	a0,a0,-238 # 7298 <malloc+0x1882>
    338e:	00002097          	auipc	ra,0x2
    3392:	2d8080e7          	jalr	728(ra) # 5666 <chdir>
    3396:	3c050c63          	beqz	a0,376e <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    339a:	00004517          	auipc	a0,0x4
    339e:	b6650513          	add	a0,a0,-1178 # 6f00 <malloc+0x14ea>
    33a2:	00002097          	auipc	ra,0x2
    33a6:	2a4080e7          	jalr	676(ra) # 5646 <unlink>
    33aa:	3e051063          	bnez	a0,378a <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33ae:	00004517          	auipc	a0,0x4
    33b2:	a4a50513          	add	a0,a0,-1462 # 6df8 <malloc+0x13e2>
    33b6:	00002097          	auipc	ra,0x2
    33ba:	290080e7          	jalr	656(ra) # 5646 <unlink>
    33be:	3e051463          	bnez	a0,37a6 <subdir+0x756>
  if(unlink("dd") == 0){
    33c2:	00004517          	auipc	a0,0x4
    33c6:	a1650513          	add	a0,a0,-1514 # 6dd8 <malloc+0x13c2>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	27c080e7          	jalr	636(ra) # 5646 <unlink>
    33d2:	3e050863          	beqz	a0,37c2 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33d6:	00004517          	auipc	a0,0x4
    33da:	f3250513          	add	a0,a0,-206 # 7308 <malloc+0x18f2>
    33de:	00002097          	auipc	ra,0x2
    33e2:	268080e7          	jalr	616(ra) # 5646 <unlink>
    33e6:	3e054c63          	bltz	a0,37de <subdir+0x78e>
  if(unlink("dd") < 0){
    33ea:	00004517          	auipc	a0,0x4
    33ee:	9ee50513          	add	a0,a0,-1554 # 6dd8 <malloc+0x13c2>
    33f2:	00002097          	auipc	ra,0x2
    33f6:	254080e7          	jalr	596(ra) # 5646 <unlink>
    33fa:	40054063          	bltz	a0,37fa <subdir+0x7aa>
}
    33fe:	60e2                	ld	ra,24(sp)
    3400:	6442                	ld	s0,16(sp)
    3402:	64a2                	ld	s1,8(sp)
    3404:	6902                	ld	s2,0(sp)
    3406:	6105                	add	sp,sp,32
    3408:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00004517          	auipc	a0,0x4
    3410:	9d450513          	add	a0,a0,-1580 # 6de0 <malloc+0x13ca>
    3414:	00002097          	auipc	ra,0x2
    3418:	54a080e7          	jalr	1354(ra) # 595e <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	00002097          	auipc	ra,0x2
    3422:	1d8080e7          	jalr	472(ra) # 55f6 <exit>
    printf("%s: create dd/ff failed\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	9d850513          	add	a0,a0,-1576 # 6e00 <malloc+0x13ea>
    3430:	00002097          	auipc	ra,0x2
    3434:	52e080e7          	jalr	1326(ra) # 595e <printf>
    exit(1);
    3438:	4505                	li	a0,1
    343a:	00002097          	auipc	ra,0x2
    343e:	1bc080e7          	jalr	444(ra) # 55f6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3442:	85ca                	mv	a1,s2
    3444:	00004517          	auipc	a0,0x4
    3448:	9dc50513          	add	a0,a0,-1572 # 6e20 <malloc+0x140a>
    344c:	00002097          	auipc	ra,0x2
    3450:	512080e7          	jalr	1298(ra) # 595e <printf>
    exit(1);
    3454:	4505                	li	a0,1
    3456:	00002097          	auipc	ra,0x2
    345a:	1a0080e7          	jalr	416(ra) # 55f6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    345e:	85ca                	mv	a1,s2
    3460:	00004517          	auipc	a0,0x4
    3464:	9f850513          	add	a0,a0,-1544 # 6e58 <malloc+0x1442>
    3468:	00002097          	auipc	ra,0x2
    346c:	4f6080e7          	jalr	1270(ra) # 595e <printf>
    exit(1);
    3470:	4505                	li	a0,1
    3472:	00002097          	auipc	ra,0x2
    3476:	184080e7          	jalr	388(ra) # 55f6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    347a:	85ca                	mv	a1,s2
    347c:	00004517          	auipc	a0,0x4
    3480:	a0c50513          	add	a0,a0,-1524 # 6e88 <malloc+0x1472>
    3484:	00002097          	auipc	ra,0x2
    3488:	4da080e7          	jalr	1242(ra) # 595e <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	00002097          	auipc	ra,0x2
    3492:	168080e7          	jalr	360(ra) # 55f6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3496:	85ca                	mv	a1,s2
    3498:	00004517          	auipc	a0,0x4
    349c:	a2850513          	add	a0,a0,-1496 # 6ec0 <malloc+0x14aa>
    34a0:	00002097          	auipc	ra,0x2
    34a4:	4be080e7          	jalr	1214(ra) # 595e <printf>
    exit(1);
    34a8:	4505                	li	a0,1
    34aa:	00002097          	auipc	ra,0x2
    34ae:	14c080e7          	jalr	332(ra) # 55f6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b2:	85ca                	mv	a1,s2
    34b4:	00004517          	auipc	a0,0x4
    34b8:	a2c50513          	add	a0,a0,-1492 # 6ee0 <malloc+0x14ca>
    34bc:	00002097          	auipc	ra,0x2
    34c0:	4a2080e7          	jalr	1186(ra) # 595e <printf>
    exit(1);
    34c4:	4505                	li	a0,1
    34c6:	00002097          	auipc	ra,0x2
    34ca:	130080e7          	jalr	304(ra) # 55f6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34ce:	85ca                	mv	a1,s2
    34d0:	00004517          	auipc	a0,0x4
    34d4:	a4050513          	add	a0,a0,-1472 # 6f10 <malloc+0x14fa>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	486080e7          	jalr	1158(ra) # 595e <printf>
    exit(1);
    34e0:	4505                	li	a0,1
    34e2:	00002097          	auipc	ra,0x2
    34e6:	114080e7          	jalr	276(ra) # 55f6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34ea:	85ca                	mv	a1,s2
    34ec:	00004517          	auipc	a0,0x4
    34f0:	a4c50513          	add	a0,a0,-1460 # 6f38 <malloc+0x1522>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	46a080e7          	jalr	1130(ra) # 595e <printf>
    exit(1);
    34fc:	4505                	li	a0,1
    34fe:	00002097          	auipc	ra,0x2
    3502:	0f8080e7          	jalr	248(ra) # 55f6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3506:	85ca                	mv	a1,s2
    3508:	00004517          	auipc	a0,0x4
    350c:	a5050513          	add	a0,a0,-1456 # 6f58 <malloc+0x1542>
    3510:	00002097          	auipc	ra,0x2
    3514:	44e080e7          	jalr	1102(ra) # 595e <printf>
    exit(1);
    3518:	4505                	li	a0,1
    351a:	00002097          	auipc	ra,0x2
    351e:	0dc080e7          	jalr	220(ra) # 55f6 <exit>
    printf("%s: chdir dd failed\n", s);
    3522:	85ca                	mv	a1,s2
    3524:	00004517          	auipc	a0,0x4
    3528:	a5c50513          	add	a0,a0,-1444 # 6f80 <malloc+0x156a>
    352c:	00002097          	auipc	ra,0x2
    3530:	432080e7          	jalr	1074(ra) # 595e <printf>
    exit(1);
    3534:	4505                	li	a0,1
    3536:	00002097          	auipc	ra,0x2
    353a:	0c0080e7          	jalr	192(ra) # 55f6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    353e:	85ca                	mv	a1,s2
    3540:	00004517          	auipc	a0,0x4
    3544:	a6850513          	add	a0,a0,-1432 # 6fa8 <malloc+0x1592>
    3548:	00002097          	auipc	ra,0x2
    354c:	416080e7          	jalr	1046(ra) # 595e <printf>
    exit(1);
    3550:	4505                	li	a0,1
    3552:	00002097          	auipc	ra,0x2
    3556:	0a4080e7          	jalr	164(ra) # 55f6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    355a:	85ca                	mv	a1,s2
    355c:	00004517          	auipc	a0,0x4
    3560:	a7c50513          	add	a0,a0,-1412 # 6fd8 <malloc+0x15c2>
    3564:	00002097          	auipc	ra,0x2
    3568:	3fa080e7          	jalr	1018(ra) # 595e <printf>
    exit(1);
    356c:	4505                	li	a0,1
    356e:	00002097          	auipc	ra,0x2
    3572:	088080e7          	jalr	136(ra) # 55f6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3576:	85ca                	mv	a1,s2
    3578:	00004517          	auipc	a0,0x4
    357c:	a8850513          	add	a0,a0,-1400 # 7000 <malloc+0x15ea>
    3580:	00002097          	auipc	ra,0x2
    3584:	3de080e7          	jalr	990(ra) # 595e <printf>
    exit(1);
    3588:	4505                	li	a0,1
    358a:	00002097          	auipc	ra,0x2
    358e:	06c080e7          	jalr	108(ra) # 55f6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3592:	85ca                	mv	a1,s2
    3594:	00004517          	auipc	a0,0x4
    3598:	a8450513          	add	a0,a0,-1404 # 7018 <malloc+0x1602>
    359c:	00002097          	auipc	ra,0x2
    35a0:	3c2080e7          	jalr	962(ra) # 595e <printf>
    exit(1);
    35a4:	4505                	li	a0,1
    35a6:	00002097          	auipc	ra,0x2
    35aa:	050080e7          	jalr	80(ra) # 55f6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35ae:	85ca                	mv	a1,s2
    35b0:	00004517          	auipc	a0,0x4
    35b4:	a8850513          	add	a0,a0,-1400 # 7038 <malloc+0x1622>
    35b8:	00002097          	auipc	ra,0x2
    35bc:	3a6080e7          	jalr	934(ra) # 595e <printf>
    exit(1);
    35c0:	4505                	li	a0,1
    35c2:	00002097          	auipc	ra,0x2
    35c6:	034080e7          	jalr	52(ra) # 55f6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35ca:	85ca                	mv	a1,s2
    35cc:	00004517          	auipc	a0,0x4
    35d0:	a8c50513          	add	a0,a0,-1396 # 7058 <malloc+0x1642>
    35d4:	00002097          	auipc	ra,0x2
    35d8:	38a080e7          	jalr	906(ra) # 595e <printf>
    exit(1);
    35dc:	4505                	li	a0,1
    35de:	00002097          	auipc	ra,0x2
    35e2:	018080e7          	jalr	24(ra) # 55f6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35e6:	85ca                	mv	a1,s2
    35e8:	00004517          	auipc	a0,0x4
    35ec:	ab050513          	add	a0,a0,-1360 # 7098 <malloc+0x1682>
    35f0:	00002097          	auipc	ra,0x2
    35f4:	36e080e7          	jalr	878(ra) # 595e <printf>
    exit(1);
    35f8:	4505                	li	a0,1
    35fa:	00002097          	auipc	ra,0x2
    35fe:	ffc080e7          	jalr	-4(ra) # 55f6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3602:	85ca                	mv	a1,s2
    3604:	00004517          	auipc	a0,0x4
    3608:	ac450513          	add	a0,a0,-1340 # 70c8 <malloc+0x16b2>
    360c:	00002097          	auipc	ra,0x2
    3610:	352080e7          	jalr	850(ra) # 595e <printf>
    exit(1);
    3614:	4505                	li	a0,1
    3616:	00002097          	auipc	ra,0x2
    361a:	fe0080e7          	jalr	-32(ra) # 55f6 <exit>
    printf("%s: create dd succeeded!\n", s);
    361e:	85ca                	mv	a1,s2
    3620:	00004517          	auipc	a0,0x4
    3624:	ac850513          	add	a0,a0,-1336 # 70e8 <malloc+0x16d2>
    3628:	00002097          	auipc	ra,0x2
    362c:	336080e7          	jalr	822(ra) # 595e <printf>
    exit(1);
    3630:	4505                	li	a0,1
    3632:	00002097          	auipc	ra,0x2
    3636:	fc4080e7          	jalr	-60(ra) # 55f6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    363a:	85ca                	mv	a1,s2
    363c:	00004517          	auipc	a0,0x4
    3640:	acc50513          	add	a0,a0,-1332 # 7108 <malloc+0x16f2>
    3644:	00002097          	auipc	ra,0x2
    3648:	31a080e7          	jalr	794(ra) # 595e <printf>
    exit(1);
    364c:	4505                	li	a0,1
    364e:	00002097          	auipc	ra,0x2
    3652:	fa8080e7          	jalr	-88(ra) # 55f6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3656:	85ca                	mv	a1,s2
    3658:	00004517          	auipc	a0,0x4
    365c:	ad050513          	add	a0,a0,-1328 # 7128 <malloc+0x1712>
    3660:	00002097          	auipc	ra,0x2
    3664:	2fe080e7          	jalr	766(ra) # 595e <printf>
    exit(1);
    3668:	4505                	li	a0,1
    366a:	00002097          	auipc	ra,0x2
    366e:	f8c080e7          	jalr	-116(ra) # 55f6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3672:	85ca                	mv	a1,s2
    3674:	00004517          	auipc	a0,0x4
    3678:	ae450513          	add	a0,a0,-1308 # 7158 <malloc+0x1742>
    367c:	00002097          	auipc	ra,0x2
    3680:	2e2080e7          	jalr	738(ra) # 595e <printf>
    exit(1);
    3684:	4505                	li	a0,1
    3686:	00002097          	auipc	ra,0x2
    368a:	f70080e7          	jalr	-144(ra) # 55f6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    368e:	85ca                	mv	a1,s2
    3690:	00004517          	auipc	a0,0x4
    3694:	af050513          	add	a0,a0,-1296 # 7180 <malloc+0x176a>
    3698:	00002097          	auipc	ra,0x2
    369c:	2c6080e7          	jalr	710(ra) # 595e <printf>
    exit(1);
    36a0:	4505                	li	a0,1
    36a2:	00002097          	auipc	ra,0x2
    36a6:	f54080e7          	jalr	-172(ra) # 55f6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36aa:	85ca                	mv	a1,s2
    36ac:	00004517          	auipc	a0,0x4
    36b0:	afc50513          	add	a0,a0,-1284 # 71a8 <malloc+0x1792>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	2aa080e7          	jalr	682(ra) # 595e <printf>
    exit(1);
    36bc:	4505                	li	a0,1
    36be:	00002097          	auipc	ra,0x2
    36c2:	f38080e7          	jalr	-200(ra) # 55f6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36c6:	85ca                	mv	a1,s2
    36c8:	00004517          	auipc	a0,0x4
    36cc:	b0850513          	add	a0,a0,-1272 # 71d0 <malloc+0x17ba>
    36d0:	00002097          	auipc	ra,0x2
    36d4:	28e080e7          	jalr	654(ra) # 595e <printf>
    exit(1);
    36d8:	4505                	li	a0,1
    36da:	00002097          	auipc	ra,0x2
    36de:	f1c080e7          	jalr	-228(ra) # 55f6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e2:	85ca                	mv	a1,s2
    36e4:	00004517          	auipc	a0,0x4
    36e8:	b0c50513          	add	a0,a0,-1268 # 71f0 <malloc+0x17da>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	272080e7          	jalr	626(ra) # 595e <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	00002097          	auipc	ra,0x2
    36fa:	f00080e7          	jalr	-256(ra) # 55f6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    36fe:	85ca                	mv	a1,s2
    3700:	00004517          	auipc	a0,0x4
    3704:	b1050513          	add	a0,a0,-1264 # 7210 <malloc+0x17fa>
    3708:	00002097          	auipc	ra,0x2
    370c:	256080e7          	jalr	598(ra) # 595e <printf>
    exit(1);
    3710:	4505                	li	a0,1
    3712:	00002097          	auipc	ra,0x2
    3716:	ee4080e7          	jalr	-284(ra) # 55f6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    371a:	85ca                	mv	a1,s2
    371c:	00004517          	auipc	a0,0x4
    3720:	b1c50513          	add	a0,a0,-1252 # 7238 <malloc+0x1822>
    3724:	00002097          	auipc	ra,0x2
    3728:	23a080e7          	jalr	570(ra) # 595e <printf>
    exit(1);
    372c:	4505                	li	a0,1
    372e:	00002097          	auipc	ra,0x2
    3732:	ec8080e7          	jalr	-312(ra) # 55f6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3736:	85ca                	mv	a1,s2
    3738:	00004517          	auipc	a0,0x4
    373c:	b2050513          	add	a0,a0,-1248 # 7258 <malloc+0x1842>
    3740:	00002097          	auipc	ra,0x2
    3744:	21e080e7          	jalr	542(ra) # 595e <printf>
    exit(1);
    3748:	4505                	li	a0,1
    374a:	00002097          	auipc	ra,0x2
    374e:	eac080e7          	jalr	-340(ra) # 55f6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3752:	85ca                	mv	a1,s2
    3754:	00004517          	auipc	a0,0x4
    3758:	b2450513          	add	a0,a0,-1244 # 7278 <malloc+0x1862>
    375c:	00002097          	auipc	ra,0x2
    3760:	202080e7          	jalr	514(ra) # 595e <printf>
    exit(1);
    3764:	4505                	li	a0,1
    3766:	00002097          	auipc	ra,0x2
    376a:	e90080e7          	jalr	-368(ra) # 55f6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    376e:	85ca                	mv	a1,s2
    3770:	00004517          	auipc	a0,0x4
    3774:	b3050513          	add	a0,a0,-1232 # 72a0 <malloc+0x188a>
    3778:	00002097          	auipc	ra,0x2
    377c:	1e6080e7          	jalr	486(ra) # 595e <printf>
    exit(1);
    3780:	4505                	li	a0,1
    3782:	00002097          	auipc	ra,0x2
    3786:	e74080e7          	jalr	-396(ra) # 55f6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    378a:	85ca                	mv	a1,s2
    378c:	00003517          	auipc	a0,0x3
    3790:	7ac50513          	add	a0,a0,1964 # 6f38 <malloc+0x1522>
    3794:	00002097          	auipc	ra,0x2
    3798:	1ca080e7          	jalr	458(ra) # 595e <printf>
    exit(1);
    379c:	4505                	li	a0,1
    379e:	00002097          	auipc	ra,0x2
    37a2:	e58080e7          	jalr	-424(ra) # 55f6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37a6:	85ca                	mv	a1,s2
    37a8:	00004517          	auipc	a0,0x4
    37ac:	b1850513          	add	a0,a0,-1256 # 72c0 <malloc+0x18aa>
    37b0:	00002097          	auipc	ra,0x2
    37b4:	1ae080e7          	jalr	430(ra) # 595e <printf>
    exit(1);
    37b8:	4505                	li	a0,1
    37ba:	00002097          	auipc	ra,0x2
    37be:	e3c080e7          	jalr	-452(ra) # 55f6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c2:	85ca                	mv	a1,s2
    37c4:	00004517          	auipc	a0,0x4
    37c8:	b1c50513          	add	a0,a0,-1252 # 72e0 <malloc+0x18ca>
    37cc:	00002097          	auipc	ra,0x2
    37d0:	192080e7          	jalr	402(ra) # 595e <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	00002097          	auipc	ra,0x2
    37da:	e20080e7          	jalr	-480(ra) # 55f6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37de:	85ca                	mv	a1,s2
    37e0:	00004517          	auipc	a0,0x4
    37e4:	b3050513          	add	a0,a0,-1232 # 7310 <malloc+0x18fa>
    37e8:	00002097          	auipc	ra,0x2
    37ec:	176080e7          	jalr	374(ra) # 595e <printf>
    exit(1);
    37f0:	4505                	li	a0,1
    37f2:	00002097          	auipc	ra,0x2
    37f6:	e04080e7          	jalr	-508(ra) # 55f6 <exit>
    printf("%s: unlink dd failed\n", s);
    37fa:	85ca                	mv	a1,s2
    37fc:	00004517          	auipc	a0,0x4
    3800:	b3450513          	add	a0,a0,-1228 # 7330 <malloc+0x191a>
    3804:	00002097          	auipc	ra,0x2
    3808:	15a080e7          	jalr	346(ra) # 595e <printf>
    exit(1);
    380c:	4505                	li	a0,1
    380e:	00002097          	auipc	ra,0x2
    3812:	de8080e7          	jalr	-536(ra) # 55f6 <exit>

0000000000003816 <rmdot>:
{
    3816:	1101                	add	sp,sp,-32
    3818:	ec06                	sd	ra,24(sp)
    381a:	e822                	sd	s0,16(sp)
    381c:	e426                	sd	s1,8(sp)
    381e:	1000                	add	s0,sp,32
    3820:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3822:	00004517          	auipc	a0,0x4
    3826:	b2650513          	add	a0,a0,-1242 # 7348 <malloc+0x1932>
    382a:	00002097          	auipc	ra,0x2
    382e:	e34080e7          	jalr	-460(ra) # 565e <mkdir>
    3832:	e549                	bnez	a0,38bc <rmdot+0xa6>
  if(chdir("dots") != 0){
    3834:	00004517          	auipc	a0,0x4
    3838:	b1450513          	add	a0,a0,-1260 # 7348 <malloc+0x1932>
    383c:	00002097          	auipc	ra,0x2
    3840:	e2a080e7          	jalr	-470(ra) # 5666 <chdir>
    3844:	e951                	bnez	a0,38d8 <rmdot+0xc2>
  if(unlink(".") == 0){
    3846:	00003517          	auipc	a0,0x3
    384a:	9aa50513          	add	a0,a0,-1622 # 61f0 <malloc+0x7da>
    384e:	00002097          	auipc	ra,0x2
    3852:	df8080e7          	jalr	-520(ra) # 5646 <unlink>
    3856:	cd59                	beqz	a0,38f4 <rmdot+0xde>
  if(unlink("..") == 0){
    3858:	00003517          	auipc	a0,0x3
    385c:	54850513          	add	a0,a0,1352 # 6da0 <malloc+0x138a>
    3860:	00002097          	auipc	ra,0x2
    3864:	de6080e7          	jalr	-538(ra) # 5646 <unlink>
    3868:	c545                	beqz	a0,3910 <rmdot+0xfa>
  if(chdir("/") != 0){
    386a:	00003517          	auipc	a0,0x3
    386e:	4de50513          	add	a0,a0,1246 # 6d48 <malloc+0x1332>
    3872:	00002097          	auipc	ra,0x2
    3876:	df4080e7          	jalr	-524(ra) # 5666 <chdir>
    387a:	e94d                	bnez	a0,392c <rmdot+0x116>
  if(unlink("dots/.") == 0){
    387c:	00004517          	auipc	a0,0x4
    3880:	b3450513          	add	a0,a0,-1228 # 73b0 <malloc+0x199a>
    3884:	00002097          	auipc	ra,0x2
    3888:	dc2080e7          	jalr	-574(ra) # 5646 <unlink>
    388c:	cd55                	beqz	a0,3948 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    388e:	00004517          	auipc	a0,0x4
    3892:	b4a50513          	add	a0,a0,-1206 # 73d8 <malloc+0x19c2>
    3896:	00002097          	auipc	ra,0x2
    389a:	db0080e7          	jalr	-592(ra) # 5646 <unlink>
    389e:	c179                	beqz	a0,3964 <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a0:	00004517          	auipc	a0,0x4
    38a4:	aa850513          	add	a0,a0,-1368 # 7348 <malloc+0x1932>
    38a8:	00002097          	auipc	ra,0x2
    38ac:	d9e080e7          	jalr	-610(ra) # 5646 <unlink>
    38b0:	e961                	bnez	a0,3980 <rmdot+0x16a>
}
    38b2:	60e2                	ld	ra,24(sp)
    38b4:	6442                	ld	s0,16(sp)
    38b6:	64a2                	ld	s1,8(sp)
    38b8:	6105                	add	sp,sp,32
    38ba:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38bc:	85a6                	mv	a1,s1
    38be:	00004517          	auipc	a0,0x4
    38c2:	a9250513          	add	a0,a0,-1390 # 7350 <malloc+0x193a>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	098080e7          	jalr	152(ra) # 595e <printf>
    exit(1);
    38ce:	4505                	li	a0,1
    38d0:	00002097          	auipc	ra,0x2
    38d4:	d26080e7          	jalr	-730(ra) # 55f6 <exit>
    printf("%s: chdir dots failed\n", s);
    38d8:	85a6                	mv	a1,s1
    38da:	00004517          	auipc	a0,0x4
    38de:	a8e50513          	add	a0,a0,-1394 # 7368 <malloc+0x1952>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	07c080e7          	jalr	124(ra) # 595e <printf>
    exit(1);
    38ea:	4505                	li	a0,1
    38ec:	00002097          	auipc	ra,0x2
    38f0:	d0a080e7          	jalr	-758(ra) # 55f6 <exit>
    printf("%s: rm . worked!\n", s);
    38f4:	85a6                	mv	a1,s1
    38f6:	00004517          	auipc	a0,0x4
    38fa:	a8a50513          	add	a0,a0,-1398 # 7380 <malloc+0x196a>
    38fe:	00002097          	auipc	ra,0x2
    3902:	060080e7          	jalr	96(ra) # 595e <printf>
    exit(1);
    3906:	4505                	li	a0,1
    3908:	00002097          	auipc	ra,0x2
    390c:	cee080e7          	jalr	-786(ra) # 55f6 <exit>
    printf("%s: rm .. worked!\n", s);
    3910:	85a6                	mv	a1,s1
    3912:	00004517          	auipc	a0,0x4
    3916:	a8650513          	add	a0,a0,-1402 # 7398 <malloc+0x1982>
    391a:	00002097          	auipc	ra,0x2
    391e:	044080e7          	jalr	68(ra) # 595e <printf>
    exit(1);
    3922:	4505                	li	a0,1
    3924:	00002097          	auipc	ra,0x2
    3928:	cd2080e7          	jalr	-814(ra) # 55f6 <exit>
    printf("%s: chdir / failed\n", s);
    392c:	85a6                	mv	a1,s1
    392e:	00003517          	auipc	a0,0x3
    3932:	42250513          	add	a0,a0,1058 # 6d50 <malloc+0x133a>
    3936:	00002097          	auipc	ra,0x2
    393a:	028080e7          	jalr	40(ra) # 595e <printf>
    exit(1);
    393e:	4505                	li	a0,1
    3940:	00002097          	auipc	ra,0x2
    3944:	cb6080e7          	jalr	-842(ra) # 55f6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3948:	85a6                	mv	a1,s1
    394a:	00004517          	auipc	a0,0x4
    394e:	a6e50513          	add	a0,a0,-1426 # 73b8 <malloc+0x19a2>
    3952:	00002097          	auipc	ra,0x2
    3956:	00c080e7          	jalr	12(ra) # 595e <printf>
    exit(1);
    395a:	4505                	li	a0,1
    395c:	00002097          	auipc	ra,0x2
    3960:	c9a080e7          	jalr	-870(ra) # 55f6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3964:	85a6                	mv	a1,s1
    3966:	00004517          	auipc	a0,0x4
    396a:	a7a50513          	add	a0,a0,-1414 # 73e0 <malloc+0x19ca>
    396e:	00002097          	auipc	ra,0x2
    3972:	ff0080e7          	jalr	-16(ra) # 595e <printf>
    exit(1);
    3976:	4505                	li	a0,1
    3978:	00002097          	auipc	ra,0x2
    397c:	c7e080e7          	jalr	-898(ra) # 55f6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3980:	85a6                	mv	a1,s1
    3982:	00004517          	auipc	a0,0x4
    3986:	a7e50513          	add	a0,a0,-1410 # 7400 <malloc+0x19ea>
    398a:	00002097          	auipc	ra,0x2
    398e:	fd4080e7          	jalr	-44(ra) # 595e <printf>
    exit(1);
    3992:	4505                	li	a0,1
    3994:	00002097          	auipc	ra,0x2
    3998:	c62080e7          	jalr	-926(ra) # 55f6 <exit>

000000000000399c <dirfile>:
{
    399c:	1101                	add	sp,sp,-32
    399e:	ec06                	sd	ra,24(sp)
    39a0:	e822                	sd	s0,16(sp)
    39a2:	e426                	sd	s1,8(sp)
    39a4:	e04a                	sd	s2,0(sp)
    39a6:	1000                	add	s0,sp,32
    39a8:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39aa:	20000593          	li	a1,512
    39ae:	00004517          	auipc	a0,0x4
    39b2:	a7250513          	add	a0,a0,-1422 # 7420 <malloc+0x1a0a>
    39b6:	00002097          	auipc	ra,0x2
    39ba:	c80080e7          	jalr	-896(ra) # 5636 <open>
  if(fd < 0){
    39be:	0e054d63          	bltz	a0,3ab8 <dirfile+0x11c>
  close(fd);
    39c2:	00002097          	auipc	ra,0x2
    39c6:	c5c080e7          	jalr	-932(ra) # 561e <close>
  if(chdir("dirfile") == 0){
    39ca:	00004517          	auipc	a0,0x4
    39ce:	a5650513          	add	a0,a0,-1450 # 7420 <malloc+0x1a0a>
    39d2:	00002097          	auipc	ra,0x2
    39d6:	c94080e7          	jalr	-876(ra) # 5666 <chdir>
    39da:	cd6d                	beqz	a0,3ad4 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39dc:	4581                	li	a1,0
    39de:	00004517          	auipc	a0,0x4
    39e2:	a8a50513          	add	a0,a0,-1398 # 7468 <malloc+0x1a52>
    39e6:	00002097          	auipc	ra,0x2
    39ea:	c50080e7          	jalr	-944(ra) # 5636 <open>
  if(fd >= 0){
    39ee:	10055163          	bgez	a0,3af0 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f2:	20000593          	li	a1,512
    39f6:	00004517          	auipc	a0,0x4
    39fa:	a7250513          	add	a0,a0,-1422 # 7468 <malloc+0x1a52>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	c38080e7          	jalr	-968(ra) # 5636 <open>
  if(fd >= 0){
    3a06:	10055363          	bgez	a0,3b0c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a0a:	00004517          	auipc	a0,0x4
    3a0e:	a5e50513          	add	a0,a0,-1442 # 7468 <malloc+0x1a52>
    3a12:	00002097          	auipc	ra,0x2
    3a16:	c4c080e7          	jalr	-948(ra) # 565e <mkdir>
    3a1a:	10050763          	beqz	a0,3b28 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a1e:	00004517          	auipc	a0,0x4
    3a22:	a4a50513          	add	a0,a0,-1462 # 7468 <malloc+0x1a52>
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	c20080e7          	jalr	-992(ra) # 5646 <unlink>
    3a2e:	10050b63          	beqz	a0,3b44 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a32:	00004597          	auipc	a1,0x4
    3a36:	a3658593          	add	a1,a1,-1482 # 7468 <malloc+0x1a52>
    3a3a:	00002517          	auipc	a0,0x2
    3a3e:	2a650513          	add	a0,a0,678 # 5ce0 <malloc+0x2ca>
    3a42:	00002097          	auipc	ra,0x2
    3a46:	c14080e7          	jalr	-1004(ra) # 5656 <link>
    3a4a:	10050b63          	beqz	a0,3b60 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a4e:	00004517          	auipc	a0,0x4
    3a52:	9d250513          	add	a0,a0,-1582 # 7420 <malloc+0x1a0a>
    3a56:	00002097          	auipc	ra,0x2
    3a5a:	bf0080e7          	jalr	-1040(ra) # 5646 <unlink>
    3a5e:	10051f63          	bnez	a0,3b7c <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a62:	4589                	li	a1,2
    3a64:	00002517          	auipc	a0,0x2
    3a68:	78c50513          	add	a0,a0,1932 # 61f0 <malloc+0x7da>
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	bca080e7          	jalr	-1078(ra) # 5636 <open>
  if(fd >= 0){
    3a74:	12055263          	bgez	a0,3b98 <dirfile+0x1fc>
  fd = open(".", 0);
    3a78:	4581                	li	a1,0
    3a7a:	00002517          	auipc	a0,0x2
    3a7e:	77650513          	add	a0,a0,1910 # 61f0 <malloc+0x7da>
    3a82:	00002097          	auipc	ra,0x2
    3a86:	bb4080e7          	jalr	-1100(ra) # 5636 <open>
    3a8a:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a8c:	4605                	li	a2,1
    3a8e:	00002597          	auipc	a1,0x2
    3a92:	11a58593          	add	a1,a1,282 # 5ba8 <malloc+0x192>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	b80080e7          	jalr	-1152(ra) # 5616 <write>
    3a9e:	10a04b63          	bgtz	a0,3bb4 <dirfile+0x218>
  close(fd);
    3aa2:	8526                	mv	a0,s1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	b7a080e7          	jalr	-1158(ra) # 561e <close>
}
    3aac:	60e2                	ld	ra,24(sp)
    3aae:	6442                	ld	s0,16(sp)
    3ab0:	64a2                	ld	s1,8(sp)
    3ab2:	6902                	ld	s2,0(sp)
    3ab4:	6105                	add	sp,sp,32
    3ab6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ab8:	85ca                	mv	a1,s2
    3aba:	00004517          	auipc	a0,0x4
    3abe:	96e50513          	add	a0,a0,-1682 # 7428 <malloc+0x1a12>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	e9c080e7          	jalr	-356(ra) # 595e <printf>
    exit(1);
    3aca:	4505                	li	a0,1
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	b2a080e7          	jalr	-1238(ra) # 55f6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00004517          	auipc	a0,0x4
    3ada:	97250513          	add	a0,a0,-1678 # 7448 <malloc+0x1a32>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	e80080e7          	jalr	-384(ra) # 595e <printf>
    exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	b0e080e7          	jalr	-1266(ra) # 55f6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00004517          	auipc	a0,0x4
    3af6:	98650513          	add	a0,a0,-1658 # 7478 <malloc+0x1a62>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	e64080e7          	jalr	-412(ra) # 595e <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	af2080e7          	jalr	-1294(ra) # 55f6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b0c:	85ca                	mv	a1,s2
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	96a50513          	add	a0,a0,-1686 # 7478 <malloc+0x1a62>
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	e48080e7          	jalr	-440(ra) # 595e <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	00002097          	auipc	ra,0x2
    3b24:	ad6080e7          	jalr	-1322(ra) # 55f6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b28:	85ca                	mv	a1,s2
    3b2a:	00004517          	auipc	a0,0x4
    3b2e:	97650513          	add	a0,a0,-1674 # 74a0 <malloc+0x1a8a>
    3b32:	00002097          	auipc	ra,0x2
    3b36:	e2c080e7          	jalr	-468(ra) # 595e <printf>
    exit(1);
    3b3a:	4505                	li	a0,1
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	aba080e7          	jalr	-1350(ra) # 55f6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b44:	85ca                	mv	a1,s2
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	98250513          	add	a0,a0,-1662 # 74c8 <malloc+0x1ab2>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	e10080e7          	jalr	-496(ra) # 595e <printf>
    exit(1);
    3b56:	4505                	li	a0,1
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	a9e080e7          	jalr	-1378(ra) # 55f6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b60:	85ca                	mv	a1,s2
    3b62:	00004517          	auipc	a0,0x4
    3b66:	98e50513          	add	a0,a0,-1650 # 74f0 <malloc+0x1ada>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	df4080e7          	jalr	-524(ra) # 595e <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	00002097          	auipc	ra,0x2
    3b78:	a82080e7          	jalr	-1406(ra) # 55f6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b7c:	85ca                	mv	a1,s2
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	99a50513          	add	a0,a0,-1638 # 7518 <malloc+0x1b02>
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	dd8080e7          	jalr	-552(ra) # 595e <printf>
    exit(1);
    3b8e:	4505                	li	a0,1
    3b90:	00002097          	auipc	ra,0x2
    3b94:	a66080e7          	jalr	-1434(ra) # 55f6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b98:	85ca                	mv	a1,s2
    3b9a:	00004517          	auipc	a0,0x4
    3b9e:	99e50513          	add	a0,a0,-1634 # 7538 <malloc+0x1b22>
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	dbc080e7          	jalr	-580(ra) # 595e <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	a4a080e7          	jalr	-1462(ra) # 55f6 <exit>
    printf("%s: write . succeeded!\n", s);
    3bb4:	85ca                	mv	a1,s2
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	9aa50513          	add	a0,a0,-1622 # 7560 <malloc+0x1b4a>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	da0080e7          	jalr	-608(ra) # 595e <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	a2e080e7          	jalr	-1490(ra) # 55f6 <exit>

0000000000003bd0 <iref>:
{
    3bd0:	7139                	add	sp,sp,-64
    3bd2:	fc06                	sd	ra,56(sp)
    3bd4:	f822                	sd	s0,48(sp)
    3bd6:	f426                	sd	s1,40(sp)
    3bd8:	f04a                	sd	s2,32(sp)
    3bda:	ec4e                	sd	s3,24(sp)
    3bdc:	e852                	sd	s4,16(sp)
    3bde:	e456                	sd	s5,8(sp)
    3be0:	e05a                	sd	s6,0(sp)
    3be2:	0080                	add	s0,sp,64
    3be4:	8b2a                	mv	s6,a0
    3be6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bea:	00004a17          	auipc	s4,0x4
    3bee:	98ea0a13          	add	s4,s4,-1650 # 7578 <malloc+0x1b62>
    mkdir("");
    3bf2:	00003497          	auipc	s1,0x3
    3bf6:	48e48493          	add	s1,s1,1166 # 7080 <malloc+0x166a>
    link("README", "");
    3bfa:	00002a97          	auipc	s5,0x2
    3bfe:	0e6a8a93          	add	s5,s5,230 # 5ce0 <malloc+0x2ca>
    fd = open("xx", O_CREATE);
    3c02:	00004997          	auipc	s3,0x4
    3c06:	86e98993          	add	s3,s3,-1938 # 7470 <malloc+0x1a5a>
    3c0a:	a891                	j	3c5e <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c0c:	85da                	mv	a1,s6
    3c0e:	00004517          	auipc	a0,0x4
    3c12:	97250513          	add	a0,a0,-1678 # 7580 <malloc+0x1b6a>
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	d48080e7          	jalr	-696(ra) # 595e <printf>
      exit(1);
    3c1e:	4505                	li	a0,1
    3c20:	00002097          	auipc	ra,0x2
    3c24:	9d6080e7          	jalr	-1578(ra) # 55f6 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c28:	85da                	mv	a1,s6
    3c2a:	00004517          	auipc	a0,0x4
    3c2e:	96e50513          	add	a0,a0,-1682 # 7598 <malloc+0x1b82>
    3c32:	00002097          	auipc	ra,0x2
    3c36:	d2c080e7          	jalr	-724(ra) # 595e <printf>
      exit(1);
    3c3a:	4505                	li	a0,1
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	9ba080e7          	jalr	-1606(ra) # 55f6 <exit>
      close(fd);
    3c44:	00002097          	auipc	ra,0x2
    3c48:	9da080e7          	jalr	-1574(ra) # 561e <close>
    3c4c:	a889                	j	3c9e <iref+0xce>
    unlink("xx");
    3c4e:	854e                	mv	a0,s3
    3c50:	00002097          	auipc	ra,0x2
    3c54:	9f6080e7          	jalr	-1546(ra) # 5646 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c58:	397d                	addw	s2,s2,-1
    3c5a:	06090063          	beqz	s2,3cba <iref+0xea>
    if(mkdir("irefd") != 0){
    3c5e:	8552                	mv	a0,s4
    3c60:	00002097          	auipc	ra,0x2
    3c64:	9fe080e7          	jalr	-1538(ra) # 565e <mkdir>
    3c68:	f155                	bnez	a0,3c0c <iref+0x3c>
    if(chdir("irefd") != 0){
    3c6a:	8552                	mv	a0,s4
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	9fa080e7          	jalr	-1542(ra) # 5666 <chdir>
    3c74:	f955                	bnez	a0,3c28 <iref+0x58>
    mkdir("");
    3c76:	8526                	mv	a0,s1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	9e6080e7          	jalr	-1562(ra) # 565e <mkdir>
    link("README", "");
    3c80:	85a6                	mv	a1,s1
    3c82:	8556                	mv	a0,s5
    3c84:	00002097          	auipc	ra,0x2
    3c88:	9d2080e7          	jalr	-1582(ra) # 5656 <link>
    fd = open("", O_CREATE);
    3c8c:	20000593          	li	a1,512
    3c90:	8526                	mv	a0,s1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	9a4080e7          	jalr	-1628(ra) # 5636 <open>
    if(fd >= 0)
    3c9a:	fa0555e3          	bgez	a0,3c44 <iref+0x74>
    fd = open("xx", O_CREATE);
    3c9e:	20000593          	li	a1,512
    3ca2:	854e                	mv	a0,s3
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	992080e7          	jalr	-1646(ra) # 5636 <open>
    if(fd >= 0)
    3cac:	fa0541e3          	bltz	a0,3c4e <iref+0x7e>
      close(fd);
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	96e080e7          	jalr	-1682(ra) # 561e <close>
    3cb8:	bf59                	j	3c4e <iref+0x7e>
    3cba:	03300493          	li	s1,51
    chdir("..");
    3cbe:	00003997          	auipc	s3,0x3
    3cc2:	0e298993          	add	s3,s3,226 # 6da0 <malloc+0x138a>
    unlink("irefd");
    3cc6:	00004917          	auipc	s2,0x4
    3cca:	8b290913          	add	s2,s2,-1870 # 7578 <malloc+0x1b62>
    chdir("..");
    3cce:	854e                	mv	a0,s3
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	996080e7          	jalr	-1642(ra) # 5666 <chdir>
    unlink("irefd");
    3cd8:	854a                	mv	a0,s2
    3cda:	00002097          	auipc	ra,0x2
    3cde:	96c080e7          	jalr	-1684(ra) # 5646 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce2:	34fd                	addw	s1,s1,-1
    3ce4:	f4ed                	bnez	s1,3cce <iref+0xfe>
  chdir("/");
    3ce6:	00003517          	auipc	a0,0x3
    3cea:	06250513          	add	a0,a0,98 # 6d48 <malloc+0x1332>
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	978080e7          	jalr	-1672(ra) # 5666 <chdir>
}
    3cf6:	70e2                	ld	ra,56(sp)
    3cf8:	7442                	ld	s0,48(sp)
    3cfa:	74a2                	ld	s1,40(sp)
    3cfc:	7902                	ld	s2,32(sp)
    3cfe:	69e2                	ld	s3,24(sp)
    3d00:	6a42                	ld	s4,16(sp)
    3d02:	6aa2                	ld	s5,8(sp)
    3d04:	6b02                	ld	s6,0(sp)
    3d06:	6121                	add	sp,sp,64
    3d08:	8082                	ret

0000000000003d0a <openiputtest>:
{
    3d0a:	7179                	add	sp,sp,-48
    3d0c:	f406                	sd	ra,40(sp)
    3d0e:	f022                	sd	s0,32(sp)
    3d10:	ec26                	sd	s1,24(sp)
    3d12:	1800                	add	s0,sp,48
    3d14:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d16:	00004517          	auipc	a0,0x4
    3d1a:	89a50513          	add	a0,a0,-1894 # 75b0 <malloc+0x1b9a>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	940080e7          	jalr	-1728(ra) # 565e <mkdir>
    3d26:	04054263          	bltz	a0,3d6a <openiputtest+0x60>
  pid = fork();
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	8c4080e7          	jalr	-1852(ra) # 55ee <fork>
  if(pid < 0){
    3d32:	04054a63          	bltz	a0,3d86 <openiputtest+0x7c>
  if(pid == 0){
    3d36:	e93d                	bnez	a0,3dac <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d38:	4589                	li	a1,2
    3d3a:	00004517          	auipc	a0,0x4
    3d3e:	87650513          	add	a0,a0,-1930 # 75b0 <malloc+0x1b9a>
    3d42:	00002097          	auipc	ra,0x2
    3d46:	8f4080e7          	jalr	-1804(ra) # 5636 <open>
    if(fd >= 0){
    3d4a:	04054c63          	bltz	a0,3da2 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d4e:	85a6                	mv	a1,s1
    3d50:	00004517          	auipc	a0,0x4
    3d54:	88050513          	add	a0,a0,-1920 # 75d0 <malloc+0x1bba>
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	c06080e7          	jalr	-1018(ra) # 595e <printf>
      exit(1);
    3d60:	4505                	li	a0,1
    3d62:	00002097          	auipc	ra,0x2
    3d66:	894080e7          	jalr	-1900(ra) # 55f6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d6a:	85a6                	mv	a1,s1
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	84c50513          	add	a0,a0,-1972 # 75b8 <malloc+0x1ba2>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	bea080e7          	jalr	-1046(ra) # 595e <printf>
    exit(1);
    3d7c:	4505                	li	a0,1
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	878080e7          	jalr	-1928(ra) # 55f6 <exit>
    printf("%s: fork failed\n", s);
    3d86:	85a6                	mv	a1,s1
    3d88:	00002517          	auipc	a0,0x2
    3d8c:	60850513          	add	a0,a0,1544 # 6390 <malloc+0x97a>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	bce080e7          	jalr	-1074(ra) # 595e <printf>
    exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	85c080e7          	jalr	-1956(ra) # 55f6 <exit>
    exit(0);
    3da2:	4501                	li	a0,0
    3da4:	00002097          	auipc	ra,0x2
    3da8:	852080e7          	jalr	-1966(ra) # 55f6 <exit>
  sleep(1);
    3dac:	4505                	li	a0,1
    3dae:	00002097          	auipc	ra,0x2
    3db2:	8d8080e7          	jalr	-1832(ra) # 5686 <sleep>
  if(unlink("oidir") != 0){
    3db6:	00003517          	auipc	a0,0x3
    3dba:	7fa50513          	add	a0,a0,2042 # 75b0 <malloc+0x1b9a>
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	888080e7          	jalr	-1912(ra) # 5646 <unlink>
    3dc6:	cd19                	beqz	a0,3de4 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dc8:	85a6                	mv	a1,s1
    3dca:	00002517          	auipc	a0,0x2
    3dce:	7b650513          	add	a0,a0,1974 # 6580 <malloc+0xb6a>
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	b8c080e7          	jalr	-1140(ra) # 595e <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	81a080e7          	jalr	-2022(ra) # 55f6 <exit>
  wait(&xstatus);
    3de4:	fdc40513          	add	a0,s0,-36
    3de8:	00002097          	auipc	ra,0x2
    3dec:	816080e7          	jalr	-2026(ra) # 55fe <wait>
  exit(xstatus);
    3df0:	fdc42503          	lw	a0,-36(s0)
    3df4:	00002097          	auipc	ra,0x2
    3df8:	802080e7          	jalr	-2046(ra) # 55f6 <exit>

0000000000003dfc <forkforkfork>:
{
    3dfc:	1101                	add	sp,sp,-32
    3dfe:	ec06                	sd	ra,24(sp)
    3e00:	e822                	sd	s0,16(sp)
    3e02:	e426                	sd	s1,8(sp)
    3e04:	1000                	add	s0,sp,32
    3e06:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e08:	00003517          	auipc	a0,0x3
    3e0c:	7f050513          	add	a0,a0,2032 # 75f8 <malloc+0x1be2>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	836080e7          	jalr	-1994(ra) # 5646 <unlink>
  int pid = fork();
    3e18:	00001097          	auipc	ra,0x1
    3e1c:	7d6080e7          	jalr	2006(ra) # 55ee <fork>
  if(pid < 0){
    3e20:	04054563          	bltz	a0,3e6a <forkforkfork+0x6e>
  if(pid == 0){
    3e24:	c12d                	beqz	a0,3e86 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e26:	4551                	li	a0,20
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	85e080e7          	jalr	-1954(ra) # 5686 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e30:	20200593          	li	a1,514
    3e34:	00003517          	auipc	a0,0x3
    3e38:	7c450513          	add	a0,a0,1988 # 75f8 <malloc+0x1be2>
    3e3c:	00001097          	auipc	ra,0x1
    3e40:	7fa080e7          	jalr	2042(ra) # 5636 <open>
    3e44:	00001097          	auipc	ra,0x1
    3e48:	7da080e7          	jalr	2010(ra) # 561e <close>
  wait(0);
    3e4c:	4501                	li	a0,0
    3e4e:	00001097          	auipc	ra,0x1
    3e52:	7b0080e7          	jalr	1968(ra) # 55fe <wait>
  sleep(10); // one second
    3e56:	4529                	li	a0,10
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	82e080e7          	jalr	-2002(ra) # 5686 <sleep>
}
    3e60:	60e2                	ld	ra,24(sp)
    3e62:	6442                	ld	s0,16(sp)
    3e64:	64a2                	ld	s1,8(sp)
    3e66:	6105                	add	sp,sp,32
    3e68:	8082                	ret
    printf("%s: fork failed", s);
    3e6a:	85a6                	mv	a1,s1
    3e6c:	00002517          	auipc	a0,0x2
    3e70:	6e450513          	add	a0,a0,1764 # 6550 <malloc+0xb3a>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	aea080e7          	jalr	-1302(ra) # 595e <printf>
    exit(1);
    3e7c:	4505                	li	a0,1
    3e7e:	00001097          	auipc	ra,0x1
    3e82:	778080e7          	jalr	1912(ra) # 55f6 <exit>
      int fd = open("stopforking", 0);
    3e86:	00003497          	auipc	s1,0x3
    3e8a:	77248493          	add	s1,s1,1906 # 75f8 <malloc+0x1be2>
    3e8e:	4581                	li	a1,0
    3e90:	8526                	mv	a0,s1
    3e92:	00001097          	auipc	ra,0x1
    3e96:	7a4080e7          	jalr	1956(ra) # 5636 <open>
      if(fd >= 0){
    3e9a:	02055763          	bgez	a0,3ec8 <forkforkfork+0xcc>
      if(fork() < 0){
    3e9e:	00001097          	auipc	ra,0x1
    3ea2:	750080e7          	jalr	1872(ra) # 55ee <fork>
    3ea6:	fe0554e3          	bgez	a0,3e8e <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eaa:	20200593          	li	a1,514
    3eae:	00003517          	auipc	a0,0x3
    3eb2:	74a50513          	add	a0,a0,1866 # 75f8 <malloc+0x1be2>
    3eb6:	00001097          	auipc	ra,0x1
    3eba:	780080e7          	jalr	1920(ra) # 5636 <open>
    3ebe:	00001097          	auipc	ra,0x1
    3ec2:	760080e7          	jalr	1888(ra) # 561e <close>
    3ec6:	b7e1                	j	3e8e <forkforkfork+0x92>
        exit(0);
    3ec8:	4501                	li	a0,0
    3eca:	00001097          	auipc	ra,0x1
    3ece:	72c080e7          	jalr	1836(ra) # 55f6 <exit>

0000000000003ed2 <preempt>:
{
    3ed2:	7139                	add	sp,sp,-64
    3ed4:	fc06                	sd	ra,56(sp)
    3ed6:	f822                	sd	s0,48(sp)
    3ed8:	f426                	sd	s1,40(sp)
    3eda:	f04a                	sd	s2,32(sp)
    3edc:	ec4e                	sd	s3,24(sp)
    3ede:	e852                	sd	s4,16(sp)
    3ee0:	0080                	add	s0,sp,64
    3ee2:	892a                	mv	s2,a0
  pid1 = fork();
    3ee4:	00001097          	auipc	ra,0x1
    3ee8:	70a080e7          	jalr	1802(ra) # 55ee <fork>
  if(pid1 < 0) {
    3eec:	00054563          	bltz	a0,3ef6 <preempt+0x24>
    3ef0:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3ef2:	e105                	bnez	a0,3f12 <preempt+0x40>
    for(;;)
    3ef4:	a001                	j	3ef4 <preempt+0x22>
    printf("%s: fork failed", s);
    3ef6:	85ca                	mv	a1,s2
    3ef8:	00002517          	auipc	a0,0x2
    3efc:	65850513          	add	a0,a0,1624 # 6550 <malloc+0xb3a>
    3f00:	00002097          	auipc	ra,0x2
    3f04:	a5e080e7          	jalr	-1442(ra) # 595e <printf>
    exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	00001097          	auipc	ra,0x1
    3f0e:	6ec080e7          	jalr	1772(ra) # 55f6 <exit>
  pid2 = fork();
    3f12:	00001097          	auipc	ra,0x1
    3f16:	6dc080e7          	jalr	1756(ra) # 55ee <fork>
    3f1a:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f1c:	00054463          	bltz	a0,3f24 <preempt+0x52>
  if(pid2 == 0)
    3f20:	e105                	bnez	a0,3f40 <preempt+0x6e>
    for(;;)
    3f22:	a001                	j	3f22 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f24:	85ca                	mv	a1,s2
    3f26:	00002517          	auipc	a0,0x2
    3f2a:	46a50513          	add	a0,a0,1130 # 6390 <malloc+0x97a>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	a30080e7          	jalr	-1488(ra) # 595e <printf>
    exit(1);
    3f36:	4505                	li	a0,1
    3f38:	00001097          	auipc	ra,0x1
    3f3c:	6be080e7          	jalr	1726(ra) # 55f6 <exit>
  pipe(pfds);
    3f40:	fc840513          	add	a0,s0,-56
    3f44:	00001097          	auipc	ra,0x1
    3f48:	6c2080e7          	jalr	1730(ra) # 5606 <pipe>
  pid3 = fork();
    3f4c:	00001097          	auipc	ra,0x1
    3f50:	6a2080e7          	jalr	1698(ra) # 55ee <fork>
    3f54:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3f56:	02054e63          	bltz	a0,3f92 <preempt+0xc0>
  if(pid3 == 0){
    3f5a:	e525                	bnez	a0,3fc2 <preempt+0xf0>
    close(pfds[0]);
    3f5c:	fc842503          	lw	a0,-56(s0)
    3f60:	00001097          	auipc	ra,0x1
    3f64:	6be080e7          	jalr	1726(ra) # 561e <close>
    if(write(pfds[1], "x", 1) != 1)
    3f68:	4605                	li	a2,1
    3f6a:	00002597          	auipc	a1,0x2
    3f6e:	c3e58593          	add	a1,a1,-962 # 5ba8 <malloc+0x192>
    3f72:	fcc42503          	lw	a0,-52(s0)
    3f76:	00001097          	auipc	ra,0x1
    3f7a:	6a0080e7          	jalr	1696(ra) # 5616 <write>
    3f7e:	4785                	li	a5,1
    3f80:	02f51763          	bne	a0,a5,3fae <preempt+0xdc>
    close(pfds[1]);
    3f84:	fcc42503          	lw	a0,-52(s0)
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	696080e7          	jalr	1686(ra) # 561e <close>
    for(;;)
    3f90:	a001                	j	3f90 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f92:	85ca                	mv	a1,s2
    3f94:	00002517          	auipc	a0,0x2
    3f98:	3fc50513          	add	a0,a0,1020 # 6390 <malloc+0x97a>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	9c2080e7          	jalr	-1598(ra) # 595e <printf>
     exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00001097          	auipc	ra,0x1
    3faa:	650080e7          	jalr	1616(ra) # 55f6 <exit>
      printf("%s: preempt write error", s);
    3fae:	85ca                	mv	a1,s2
    3fb0:	00003517          	auipc	a0,0x3
    3fb4:	65850513          	add	a0,a0,1624 # 7608 <malloc+0x1bf2>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	9a6080e7          	jalr	-1626(ra) # 595e <printf>
    3fc0:	b7d1                	j	3f84 <preempt+0xb2>
  close(pfds[1]);
    3fc2:	fcc42503          	lw	a0,-52(s0)
    3fc6:	00001097          	auipc	ra,0x1
    3fca:	658080e7          	jalr	1624(ra) # 561e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fce:	660d                	lui	a2,0x3
    3fd0:	00008597          	auipc	a1,0x8
    3fd4:	af858593          	add	a1,a1,-1288 # bac8 <buf>
    3fd8:	fc842503          	lw	a0,-56(s0)
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	632080e7          	jalr	1586(ra) # 560e <read>
    3fe4:	4785                	li	a5,1
    3fe6:	02f50363          	beq	a0,a5,400c <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fea:	85ca                	mv	a1,s2
    3fec:	00003517          	auipc	a0,0x3
    3ff0:	63450513          	add	a0,a0,1588 # 7620 <malloc+0x1c0a>
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	96a080e7          	jalr	-1686(ra) # 595e <printf>
}
    3ffc:	70e2                	ld	ra,56(sp)
    3ffe:	7442                	ld	s0,48(sp)
    4000:	74a2                	ld	s1,40(sp)
    4002:	7902                	ld	s2,32(sp)
    4004:	69e2                	ld	s3,24(sp)
    4006:	6a42                	ld	s4,16(sp)
    4008:	6121                	add	sp,sp,64
    400a:	8082                	ret
  close(pfds[0]);
    400c:	fc842503          	lw	a0,-56(s0)
    4010:	00001097          	auipc	ra,0x1
    4014:	60e080e7          	jalr	1550(ra) # 561e <close>
  printf("kill... ");
    4018:	00003517          	auipc	a0,0x3
    401c:	62050513          	add	a0,a0,1568 # 7638 <malloc+0x1c22>
    4020:	00002097          	auipc	ra,0x2
    4024:	93e080e7          	jalr	-1730(ra) # 595e <printf>
  kill(pid1);
    4028:	8526                	mv	a0,s1
    402a:	00001097          	auipc	ra,0x1
    402e:	5fc080e7          	jalr	1532(ra) # 5626 <kill>
  kill(pid2);
    4032:	854e                	mv	a0,s3
    4034:	00001097          	auipc	ra,0x1
    4038:	5f2080e7          	jalr	1522(ra) # 5626 <kill>
  kill(pid3);
    403c:	8552                	mv	a0,s4
    403e:	00001097          	auipc	ra,0x1
    4042:	5e8080e7          	jalr	1512(ra) # 5626 <kill>
  printf("wait... ");
    4046:	00003517          	auipc	a0,0x3
    404a:	60250513          	add	a0,a0,1538 # 7648 <malloc+0x1c32>
    404e:	00002097          	auipc	ra,0x2
    4052:	910080e7          	jalr	-1776(ra) # 595e <printf>
  wait(0);
    4056:	4501                	li	a0,0
    4058:	00001097          	auipc	ra,0x1
    405c:	5a6080e7          	jalr	1446(ra) # 55fe <wait>
  wait(0);
    4060:	4501                	li	a0,0
    4062:	00001097          	auipc	ra,0x1
    4066:	59c080e7          	jalr	1436(ra) # 55fe <wait>
  wait(0);
    406a:	4501                	li	a0,0
    406c:	00001097          	auipc	ra,0x1
    4070:	592080e7          	jalr	1426(ra) # 55fe <wait>
    4074:	b761                	j	3ffc <preempt+0x12a>

0000000000004076 <sbrkfail>:
{
    4076:	7119                	add	sp,sp,-128
    4078:	fc86                	sd	ra,120(sp)
    407a:	f8a2                	sd	s0,112(sp)
    407c:	f4a6                	sd	s1,104(sp)
    407e:	f0ca                	sd	s2,96(sp)
    4080:	ecce                	sd	s3,88(sp)
    4082:	e8d2                	sd	s4,80(sp)
    4084:	e4d6                	sd	s5,72(sp)
    4086:	0100                	add	s0,sp,128
    4088:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    408a:	fb040513          	add	a0,s0,-80
    408e:	00001097          	auipc	ra,0x1
    4092:	578080e7          	jalr	1400(ra) # 5606 <pipe>
    4096:	e901                	bnez	a0,40a6 <sbrkfail+0x30>
    4098:	f8040493          	add	s1,s0,-128
    409c:	fa840993          	add	s3,s0,-88
    40a0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    40a2:	5a7d                	li	s4,-1
    40a4:	a085                	j	4104 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    40a6:	85d6                	mv	a1,s5
    40a8:	00002517          	auipc	a0,0x2
    40ac:	3f050513          	add	a0,a0,1008 # 6498 <malloc+0xa82>
    40b0:	00002097          	auipc	ra,0x2
    40b4:	8ae080e7          	jalr	-1874(ra) # 595e <printf>
    exit(1);
    40b8:	4505                	li	a0,1
    40ba:	00001097          	auipc	ra,0x1
    40be:	53c080e7          	jalr	1340(ra) # 55f6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40c2:	00001097          	auipc	ra,0x1
    40c6:	5bc080e7          	jalr	1468(ra) # 567e <sbrk>
    40ca:	064007b7          	lui	a5,0x6400
    40ce:	40a7853b          	subw	a0,a5,a0
    40d2:	00001097          	auipc	ra,0x1
    40d6:	5ac080e7          	jalr	1452(ra) # 567e <sbrk>
      write(fds[1], "x", 1);
    40da:	4605                	li	a2,1
    40dc:	00002597          	auipc	a1,0x2
    40e0:	acc58593          	add	a1,a1,-1332 # 5ba8 <malloc+0x192>
    40e4:	fb442503          	lw	a0,-76(s0)
    40e8:	00001097          	auipc	ra,0x1
    40ec:	52e080e7          	jalr	1326(ra) # 5616 <write>
      for(;;) sleep(1000);
    40f0:	3e800513          	li	a0,1000
    40f4:	00001097          	auipc	ra,0x1
    40f8:	592080e7          	jalr	1426(ra) # 5686 <sleep>
    40fc:	bfd5                	j	40f0 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    40fe:	0911                	add	s2,s2,4
    4100:	03390563          	beq	s2,s3,412a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4104:	00001097          	auipc	ra,0x1
    4108:	4ea080e7          	jalr	1258(ra) # 55ee <fork>
    410c:	00a92023          	sw	a0,0(s2)
    4110:	d94d                	beqz	a0,40c2 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4112:	ff4506e3          	beq	a0,s4,40fe <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4116:	4605                	li	a2,1
    4118:	faf40593          	add	a1,s0,-81
    411c:	fb042503          	lw	a0,-80(s0)
    4120:	00001097          	auipc	ra,0x1
    4124:	4ee080e7          	jalr	1262(ra) # 560e <read>
    4128:	bfd9                	j	40fe <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    412a:	6505                	lui	a0,0x1
    412c:	00001097          	auipc	ra,0x1
    4130:	552080e7          	jalr	1362(ra) # 567e <sbrk>
    4134:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4136:	597d                	li	s2,-1
    4138:	a021                	j	4140 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    413a:	0491                	add	s1,s1,4
    413c:	01348f63          	beq	s1,s3,415a <sbrkfail+0xe4>
    if(pids[i] == -1)
    4140:	4088                	lw	a0,0(s1)
    4142:	ff250ce3          	beq	a0,s2,413a <sbrkfail+0xc4>
    kill(pids[i]);
    4146:	00001097          	auipc	ra,0x1
    414a:	4e0080e7          	jalr	1248(ra) # 5626 <kill>
    wait(0);
    414e:	4501                	li	a0,0
    4150:	00001097          	auipc	ra,0x1
    4154:	4ae080e7          	jalr	1198(ra) # 55fe <wait>
    4158:	b7cd                	j	413a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    415a:	57fd                	li	a5,-1
    415c:	04fa0163          	beq	s4,a5,419e <sbrkfail+0x128>
  pid = fork();
    4160:	00001097          	auipc	ra,0x1
    4164:	48e080e7          	jalr	1166(ra) # 55ee <fork>
    4168:	84aa                	mv	s1,a0
  if(pid < 0){
    416a:	04054863          	bltz	a0,41ba <sbrkfail+0x144>
  if(pid == 0){
    416e:	c525                	beqz	a0,41d6 <sbrkfail+0x160>
  wait(&xstatus);
    4170:	fbc40513          	add	a0,s0,-68
    4174:	00001097          	auipc	ra,0x1
    4178:	48a080e7          	jalr	1162(ra) # 55fe <wait>
  if(xstatus != -1 && xstatus != 2)
    417c:	fbc42783          	lw	a5,-68(s0)
    4180:	577d                	li	a4,-1
    4182:	00e78563          	beq	a5,a4,418c <sbrkfail+0x116>
    4186:	4709                	li	a4,2
    4188:	08e79d63          	bne	a5,a4,4222 <sbrkfail+0x1ac>
}
    418c:	70e6                	ld	ra,120(sp)
    418e:	7446                	ld	s0,112(sp)
    4190:	74a6                	ld	s1,104(sp)
    4192:	7906                	ld	s2,96(sp)
    4194:	69e6                	ld	s3,88(sp)
    4196:	6a46                	ld	s4,80(sp)
    4198:	6aa6                	ld	s5,72(sp)
    419a:	6109                	add	sp,sp,128
    419c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    419e:	85d6                	mv	a1,s5
    41a0:	00003517          	auipc	a0,0x3
    41a4:	4b850513          	add	a0,a0,1208 # 7658 <malloc+0x1c42>
    41a8:	00001097          	auipc	ra,0x1
    41ac:	7b6080e7          	jalr	1974(ra) # 595e <printf>
    exit(1);
    41b0:	4505                	li	a0,1
    41b2:	00001097          	auipc	ra,0x1
    41b6:	444080e7          	jalr	1092(ra) # 55f6 <exit>
    printf("%s: fork failed\n", s);
    41ba:	85d6                	mv	a1,s5
    41bc:	00002517          	auipc	a0,0x2
    41c0:	1d450513          	add	a0,a0,468 # 6390 <malloc+0x97a>
    41c4:	00001097          	auipc	ra,0x1
    41c8:	79a080e7          	jalr	1946(ra) # 595e <printf>
    exit(1);
    41cc:	4505                	li	a0,1
    41ce:	00001097          	auipc	ra,0x1
    41d2:	428080e7          	jalr	1064(ra) # 55f6 <exit>
    a = sbrk(0);
    41d6:	4501                	li	a0,0
    41d8:	00001097          	auipc	ra,0x1
    41dc:	4a6080e7          	jalr	1190(ra) # 567e <sbrk>
    41e0:	892a                	mv	s2,a0
    sbrk(10*BIG);
    41e2:	3e800537          	lui	a0,0x3e800
    41e6:	00001097          	auipc	ra,0x1
    41ea:	498080e7          	jalr	1176(ra) # 567e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41ee:	87ca                	mv	a5,s2
    41f0:	3e800737          	lui	a4,0x3e800
    41f4:	993a                	add	s2,s2,a4
    41f6:	6705                	lui	a4,0x1
      n += *(a+i);
    41f8:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1528>
    41fc:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41fe:	97ba                	add	a5,a5,a4
    4200:	ff279ce3          	bne	a5,s2,41f8 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4204:	8626                	mv	a2,s1
    4206:	85d6                	mv	a1,s5
    4208:	00003517          	auipc	a0,0x3
    420c:	47050513          	add	a0,a0,1136 # 7678 <malloc+0x1c62>
    4210:	00001097          	auipc	ra,0x1
    4214:	74e080e7          	jalr	1870(ra) # 595e <printf>
    exit(1);
    4218:	4505                	li	a0,1
    421a:	00001097          	auipc	ra,0x1
    421e:	3dc080e7          	jalr	988(ra) # 55f6 <exit>
    exit(1);
    4222:	4505                	li	a0,1
    4224:	00001097          	auipc	ra,0x1
    4228:	3d2080e7          	jalr	978(ra) # 55f6 <exit>

000000000000422c <reparent>:
{
    422c:	7179                	add	sp,sp,-48
    422e:	f406                	sd	ra,40(sp)
    4230:	f022                	sd	s0,32(sp)
    4232:	ec26                	sd	s1,24(sp)
    4234:	e84a                	sd	s2,16(sp)
    4236:	e44e                	sd	s3,8(sp)
    4238:	e052                	sd	s4,0(sp)
    423a:	1800                	add	s0,sp,48
    423c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    423e:	00001097          	auipc	ra,0x1
    4242:	438080e7          	jalr	1080(ra) # 5676 <getpid>
    4246:	8a2a                	mv	s4,a0
    4248:	0c800913          	li	s2,200
    int pid = fork();
    424c:	00001097          	auipc	ra,0x1
    4250:	3a2080e7          	jalr	930(ra) # 55ee <fork>
    4254:	84aa                	mv	s1,a0
    if(pid < 0){
    4256:	02054263          	bltz	a0,427a <reparent+0x4e>
    if(pid){
    425a:	cd21                	beqz	a0,42b2 <reparent+0x86>
      if(wait(0) != pid){
    425c:	4501                	li	a0,0
    425e:	00001097          	auipc	ra,0x1
    4262:	3a0080e7          	jalr	928(ra) # 55fe <wait>
    4266:	02951863          	bne	a0,s1,4296 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    426a:	397d                	addw	s2,s2,-1
    426c:	fe0910e3          	bnez	s2,424c <reparent+0x20>
  exit(0);
    4270:	4501                	li	a0,0
    4272:	00001097          	auipc	ra,0x1
    4276:	384080e7          	jalr	900(ra) # 55f6 <exit>
      printf("%s: fork failed\n", s);
    427a:	85ce                	mv	a1,s3
    427c:	00002517          	auipc	a0,0x2
    4280:	11450513          	add	a0,a0,276 # 6390 <malloc+0x97a>
    4284:	00001097          	auipc	ra,0x1
    4288:	6da080e7          	jalr	1754(ra) # 595e <printf>
      exit(1);
    428c:	4505                	li	a0,1
    428e:	00001097          	auipc	ra,0x1
    4292:	368080e7          	jalr	872(ra) # 55f6 <exit>
        printf("%s: wait wrong pid\n", s);
    4296:	85ce                	mv	a1,s3
    4298:	00002517          	auipc	a0,0x2
    429c:	28050513          	add	a0,a0,640 # 6518 <malloc+0xb02>
    42a0:	00001097          	auipc	ra,0x1
    42a4:	6be080e7          	jalr	1726(ra) # 595e <printf>
        exit(1);
    42a8:	4505                	li	a0,1
    42aa:	00001097          	auipc	ra,0x1
    42ae:	34c080e7          	jalr	844(ra) # 55f6 <exit>
      int pid2 = fork();
    42b2:	00001097          	auipc	ra,0x1
    42b6:	33c080e7          	jalr	828(ra) # 55ee <fork>
      if(pid2 < 0){
    42ba:	00054763          	bltz	a0,42c8 <reparent+0x9c>
      exit(0);
    42be:	4501                	li	a0,0
    42c0:	00001097          	auipc	ra,0x1
    42c4:	336080e7          	jalr	822(ra) # 55f6 <exit>
        kill(master_pid);
    42c8:	8552                	mv	a0,s4
    42ca:	00001097          	auipc	ra,0x1
    42ce:	35c080e7          	jalr	860(ra) # 5626 <kill>
        exit(1);
    42d2:	4505                	li	a0,1
    42d4:	00001097          	auipc	ra,0x1
    42d8:	322080e7          	jalr	802(ra) # 55f6 <exit>

00000000000042dc <mem>:
{
    42dc:	7139                	add	sp,sp,-64
    42de:	fc06                	sd	ra,56(sp)
    42e0:	f822                	sd	s0,48(sp)
    42e2:	f426                	sd	s1,40(sp)
    42e4:	f04a                	sd	s2,32(sp)
    42e6:	ec4e                	sd	s3,24(sp)
    42e8:	0080                	add	s0,sp,64
    42ea:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    42ec:	00001097          	auipc	ra,0x1
    42f0:	302080e7          	jalr	770(ra) # 55ee <fork>
    m1 = 0;
    42f4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    42f6:	6909                	lui	s2,0x2
    42f8:	71190913          	add	s2,s2,1809 # 2711 <sbrkbasic+0x15f>
  if((pid = fork()) == 0){
    42fc:	c115                	beqz	a0,4320 <mem+0x44>
    wait(&xstatus);
    42fe:	fcc40513          	add	a0,s0,-52
    4302:	00001097          	auipc	ra,0x1
    4306:	2fc080e7          	jalr	764(ra) # 55fe <wait>
    if(xstatus == -1){
    430a:	fcc42503          	lw	a0,-52(s0)
    430e:	57fd                	li	a5,-1
    4310:	06f50363          	beq	a0,a5,4376 <mem+0x9a>
    exit(xstatus);
    4314:	00001097          	auipc	ra,0x1
    4318:	2e2080e7          	jalr	738(ra) # 55f6 <exit>
      *(char**)m2 = m1;
    431c:	e104                	sd	s1,0(a0)
      m1 = m2;
    431e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4320:	854a                	mv	a0,s2
    4322:	00001097          	auipc	ra,0x1
    4326:	6f4080e7          	jalr	1780(ra) # 5a16 <malloc>
    432a:	f96d                	bnez	a0,431c <mem+0x40>
    while(m1){
    432c:	c881                	beqz	s1,433c <mem+0x60>
      m2 = *(char**)m1;
    432e:	8526                	mv	a0,s1
    4330:	6084                	ld	s1,0(s1)
      free(m1);
    4332:	00001097          	auipc	ra,0x1
    4336:	662080e7          	jalr	1634(ra) # 5994 <free>
    while(m1){
    433a:	f8f5                	bnez	s1,432e <mem+0x52>
    m1 = malloc(1024*20);
    433c:	6515                	lui	a0,0x5
    433e:	00001097          	auipc	ra,0x1
    4342:	6d8080e7          	jalr	1752(ra) # 5a16 <malloc>
    if(m1 == 0){
    4346:	c911                	beqz	a0,435a <mem+0x7e>
    free(m1);
    4348:	00001097          	auipc	ra,0x1
    434c:	64c080e7          	jalr	1612(ra) # 5994 <free>
    exit(0);
    4350:	4501                	li	a0,0
    4352:	00001097          	auipc	ra,0x1
    4356:	2a4080e7          	jalr	676(ra) # 55f6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    435a:	85ce                	mv	a1,s3
    435c:	00003517          	auipc	a0,0x3
    4360:	34c50513          	add	a0,a0,844 # 76a8 <malloc+0x1c92>
    4364:	00001097          	auipc	ra,0x1
    4368:	5fa080e7          	jalr	1530(ra) # 595e <printf>
      exit(1);
    436c:	4505                	li	a0,1
    436e:	00001097          	auipc	ra,0x1
    4372:	288080e7          	jalr	648(ra) # 55f6 <exit>
      exit(0);
    4376:	4501                	li	a0,0
    4378:	00001097          	auipc	ra,0x1
    437c:	27e080e7          	jalr	638(ra) # 55f6 <exit>

0000000000004380 <sharedfd>:
{
    4380:	7159                	add	sp,sp,-112
    4382:	f486                	sd	ra,104(sp)
    4384:	f0a2                	sd	s0,96(sp)
    4386:	eca6                	sd	s1,88(sp)
    4388:	e8ca                	sd	s2,80(sp)
    438a:	e4ce                	sd	s3,72(sp)
    438c:	e0d2                	sd	s4,64(sp)
    438e:	fc56                	sd	s5,56(sp)
    4390:	f85a                	sd	s6,48(sp)
    4392:	f45e                	sd	s7,40(sp)
    4394:	1880                	add	s0,sp,112
    4396:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4398:	00003517          	auipc	a0,0x3
    439c:	33050513          	add	a0,a0,816 # 76c8 <malloc+0x1cb2>
    43a0:	00001097          	auipc	ra,0x1
    43a4:	2a6080e7          	jalr	678(ra) # 5646 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43a8:	20200593          	li	a1,514
    43ac:	00003517          	auipc	a0,0x3
    43b0:	31c50513          	add	a0,a0,796 # 76c8 <malloc+0x1cb2>
    43b4:	00001097          	auipc	ra,0x1
    43b8:	282080e7          	jalr	642(ra) # 5636 <open>
  if(fd < 0){
    43bc:	04054a63          	bltz	a0,4410 <sharedfd+0x90>
    43c0:	892a                	mv	s2,a0
  pid = fork();
    43c2:	00001097          	auipc	ra,0x1
    43c6:	22c080e7          	jalr	556(ra) # 55ee <fork>
    43ca:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    43cc:	07000593          	li	a1,112
    43d0:	e119                	bnez	a0,43d6 <sharedfd+0x56>
    43d2:	06300593          	li	a1,99
    43d6:	4629                	li	a2,10
    43d8:	fa040513          	add	a0,s0,-96
    43dc:	00001097          	auipc	ra,0x1
    43e0:	020080e7          	jalr	32(ra) # 53fc <memset>
    43e4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    43e8:	4629                	li	a2,10
    43ea:	fa040593          	add	a1,s0,-96
    43ee:	854a                	mv	a0,s2
    43f0:	00001097          	auipc	ra,0x1
    43f4:	226080e7          	jalr	550(ra) # 5616 <write>
    43f8:	47a9                	li	a5,10
    43fa:	02f51963          	bne	a0,a5,442c <sharedfd+0xac>
  for(i = 0; i < N; i++){
    43fe:	34fd                	addw	s1,s1,-1
    4400:	f4e5                	bnez	s1,43e8 <sharedfd+0x68>
  if(pid == 0) {
    4402:	04099363          	bnez	s3,4448 <sharedfd+0xc8>
    exit(0);
    4406:	4501                	li	a0,0
    4408:	00001097          	auipc	ra,0x1
    440c:	1ee080e7          	jalr	494(ra) # 55f6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4410:	85d2                	mv	a1,s4
    4412:	00003517          	auipc	a0,0x3
    4416:	2c650513          	add	a0,a0,710 # 76d8 <malloc+0x1cc2>
    441a:	00001097          	auipc	ra,0x1
    441e:	544080e7          	jalr	1348(ra) # 595e <printf>
    exit(1);
    4422:	4505                	li	a0,1
    4424:	00001097          	auipc	ra,0x1
    4428:	1d2080e7          	jalr	466(ra) # 55f6 <exit>
      printf("%s: write sharedfd failed\n", s);
    442c:	85d2                	mv	a1,s4
    442e:	00003517          	auipc	a0,0x3
    4432:	2d250513          	add	a0,a0,722 # 7700 <malloc+0x1cea>
    4436:	00001097          	auipc	ra,0x1
    443a:	528080e7          	jalr	1320(ra) # 595e <printf>
      exit(1);
    443e:	4505                	li	a0,1
    4440:	00001097          	auipc	ra,0x1
    4444:	1b6080e7          	jalr	438(ra) # 55f6 <exit>
    wait(&xstatus);
    4448:	f9c40513          	add	a0,s0,-100
    444c:	00001097          	auipc	ra,0x1
    4450:	1b2080e7          	jalr	434(ra) # 55fe <wait>
    if(xstatus != 0)
    4454:	f9c42983          	lw	s3,-100(s0)
    4458:	00098763          	beqz	s3,4466 <sharedfd+0xe6>
      exit(xstatus);
    445c:	854e                	mv	a0,s3
    445e:	00001097          	auipc	ra,0x1
    4462:	198080e7          	jalr	408(ra) # 55f6 <exit>
  close(fd);
    4466:	854a                	mv	a0,s2
    4468:	00001097          	auipc	ra,0x1
    446c:	1b6080e7          	jalr	438(ra) # 561e <close>
  fd = open("sharedfd", 0);
    4470:	4581                	li	a1,0
    4472:	00003517          	auipc	a0,0x3
    4476:	25650513          	add	a0,a0,598 # 76c8 <malloc+0x1cb2>
    447a:	00001097          	auipc	ra,0x1
    447e:	1bc080e7          	jalr	444(ra) # 5636 <open>
    4482:	8baa                	mv	s7,a0
  nc = np = 0;
    4484:	8ace                	mv	s5,s3
  if(fd < 0){
    4486:	02054563          	bltz	a0,44b0 <sharedfd+0x130>
    448a:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    448e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4492:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4496:	4629                	li	a2,10
    4498:	fa040593          	add	a1,s0,-96
    449c:	855e                	mv	a0,s7
    449e:	00001097          	auipc	ra,0x1
    44a2:	170080e7          	jalr	368(ra) # 560e <read>
    44a6:	02a05f63          	blez	a0,44e4 <sharedfd+0x164>
    44aa:	fa040793          	add	a5,s0,-96
    44ae:	a01d                	j	44d4 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44b0:	85d2                	mv	a1,s4
    44b2:	00003517          	auipc	a0,0x3
    44b6:	26e50513          	add	a0,a0,622 # 7720 <malloc+0x1d0a>
    44ba:	00001097          	auipc	ra,0x1
    44be:	4a4080e7          	jalr	1188(ra) # 595e <printf>
    exit(1);
    44c2:	4505                	li	a0,1
    44c4:	00001097          	auipc	ra,0x1
    44c8:	132080e7          	jalr	306(ra) # 55f6 <exit>
        nc++;
    44cc:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    44ce:	0785                	add	a5,a5,1
    44d0:	fd2783e3          	beq	a5,s2,4496 <sharedfd+0x116>
      if(buf[i] == 'c')
    44d4:	0007c703          	lbu	a4,0(a5)
    44d8:	fe970ae3          	beq	a4,s1,44cc <sharedfd+0x14c>
      if(buf[i] == 'p')
    44dc:	ff6719e3          	bne	a4,s6,44ce <sharedfd+0x14e>
        np++;
    44e0:	2a85                	addw	s5,s5,1
    44e2:	b7f5                	j	44ce <sharedfd+0x14e>
  close(fd);
    44e4:	855e                	mv	a0,s7
    44e6:	00001097          	auipc	ra,0x1
    44ea:	138080e7          	jalr	312(ra) # 561e <close>
  unlink("sharedfd");
    44ee:	00003517          	auipc	a0,0x3
    44f2:	1da50513          	add	a0,a0,474 # 76c8 <malloc+0x1cb2>
    44f6:	00001097          	auipc	ra,0x1
    44fa:	150080e7          	jalr	336(ra) # 5646 <unlink>
  if(nc == N*SZ && np == N*SZ){
    44fe:	6789                	lui	a5,0x2
    4500:	71078793          	add	a5,a5,1808 # 2710 <sbrkbasic+0x15e>
    4504:	00f99763          	bne	s3,a5,4512 <sharedfd+0x192>
    4508:	6789                	lui	a5,0x2
    450a:	71078793          	add	a5,a5,1808 # 2710 <sbrkbasic+0x15e>
    450e:	02fa8063          	beq	s5,a5,452e <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4512:	85d2                	mv	a1,s4
    4514:	00003517          	auipc	a0,0x3
    4518:	23450513          	add	a0,a0,564 # 7748 <malloc+0x1d32>
    451c:	00001097          	auipc	ra,0x1
    4520:	442080e7          	jalr	1090(ra) # 595e <printf>
    exit(1);
    4524:	4505                	li	a0,1
    4526:	00001097          	auipc	ra,0x1
    452a:	0d0080e7          	jalr	208(ra) # 55f6 <exit>
    exit(0);
    452e:	4501                	li	a0,0
    4530:	00001097          	auipc	ra,0x1
    4534:	0c6080e7          	jalr	198(ra) # 55f6 <exit>

0000000000004538 <fourfiles>:
{
    4538:	7135                	add	sp,sp,-160
    453a:	ed06                	sd	ra,152(sp)
    453c:	e922                	sd	s0,144(sp)
    453e:	e526                	sd	s1,136(sp)
    4540:	e14a                	sd	s2,128(sp)
    4542:	fcce                	sd	s3,120(sp)
    4544:	f8d2                	sd	s4,112(sp)
    4546:	f4d6                	sd	s5,104(sp)
    4548:	f0da                	sd	s6,96(sp)
    454a:	ecde                	sd	s7,88(sp)
    454c:	e8e2                	sd	s8,80(sp)
    454e:	e4e6                	sd	s9,72(sp)
    4550:	e0ea                	sd	s10,64(sp)
    4552:	fc6e                	sd	s11,56(sp)
    4554:	1100                	add	s0,sp,160
    4556:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4558:	00003797          	auipc	a5,0x3
    455c:	20878793          	add	a5,a5,520 # 7760 <malloc+0x1d4a>
    4560:	f6f43823          	sd	a5,-144(s0)
    4564:	00003797          	auipc	a5,0x3
    4568:	20478793          	add	a5,a5,516 # 7768 <malloc+0x1d52>
    456c:	f6f43c23          	sd	a5,-136(s0)
    4570:	00003797          	auipc	a5,0x3
    4574:	20078793          	add	a5,a5,512 # 7770 <malloc+0x1d5a>
    4578:	f8f43023          	sd	a5,-128(s0)
    457c:	00003797          	auipc	a5,0x3
    4580:	1fc78793          	add	a5,a5,508 # 7778 <malloc+0x1d62>
    4584:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4588:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    458c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    458e:	4481                	li	s1,0
    4590:	4a11                	li	s4,4
    fname = names[pi];
    4592:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4596:	854e                	mv	a0,s3
    4598:	00001097          	auipc	ra,0x1
    459c:	0ae080e7          	jalr	174(ra) # 5646 <unlink>
    pid = fork();
    45a0:	00001097          	auipc	ra,0x1
    45a4:	04e080e7          	jalr	78(ra) # 55ee <fork>
    if(pid < 0){
    45a8:	04054063          	bltz	a0,45e8 <fourfiles+0xb0>
    if(pid == 0){
    45ac:	cd21                	beqz	a0,4604 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    45ae:	2485                	addw	s1,s1,1
    45b0:	0921                	add	s2,s2,8
    45b2:	ff4490e3          	bne	s1,s4,4592 <fourfiles+0x5a>
    45b6:	4491                	li	s1,4
    wait(&xstatus);
    45b8:	f6c40513          	add	a0,s0,-148
    45bc:	00001097          	auipc	ra,0x1
    45c0:	042080e7          	jalr	66(ra) # 55fe <wait>
    if(xstatus != 0)
    45c4:	f6c42a83          	lw	s5,-148(s0)
    45c8:	0c0a9863          	bnez	s5,4698 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    45cc:	34fd                	addw	s1,s1,-1
    45ce:	f4ed                	bnez	s1,45b8 <fourfiles+0x80>
    45d0:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45d4:	00007a17          	auipc	s4,0x7
    45d8:	4f4a0a13          	add	s4,s4,1268 # bac8 <buf>
    if(total != N*SZ){
    45dc:	6d05                	lui	s10,0x1
    45de:	770d0d13          	add	s10,s10,1904 # 1770 <pipe1+0x34>
  for(i = 0; i < NCHILD; i++){
    45e2:	03400d93          	li	s11,52
    45e6:	a22d                	j	4710 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    45e8:	85e6                	mv	a1,s9
    45ea:	00002517          	auipc	a0,0x2
    45ee:	1ae50513          	add	a0,a0,430 # 6798 <malloc+0xd82>
    45f2:	00001097          	auipc	ra,0x1
    45f6:	36c080e7          	jalr	876(ra) # 595e <printf>
      exit(1);
    45fa:	4505                	li	a0,1
    45fc:	00001097          	auipc	ra,0x1
    4600:	ffa080e7          	jalr	-6(ra) # 55f6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4604:	20200593          	li	a1,514
    4608:	854e                	mv	a0,s3
    460a:	00001097          	auipc	ra,0x1
    460e:	02c080e7          	jalr	44(ra) # 5636 <open>
    4612:	892a                	mv	s2,a0
      if(fd < 0){
    4614:	04054763          	bltz	a0,4662 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4618:	1f400613          	li	a2,500
    461c:	0304859b          	addw	a1,s1,48
    4620:	00007517          	auipc	a0,0x7
    4624:	4a850513          	add	a0,a0,1192 # bac8 <buf>
    4628:	00001097          	auipc	ra,0x1
    462c:	dd4080e7          	jalr	-556(ra) # 53fc <memset>
    4630:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4632:	00007997          	auipc	s3,0x7
    4636:	49698993          	add	s3,s3,1174 # bac8 <buf>
    463a:	1f400613          	li	a2,500
    463e:	85ce                	mv	a1,s3
    4640:	854a                	mv	a0,s2
    4642:	00001097          	auipc	ra,0x1
    4646:	fd4080e7          	jalr	-44(ra) # 5616 <write>
    464a:	85aa                	mv	a1,a0
    464c:	1f400793          	li	a5,500
    4650:	02f51763          	bne	a0,a5,467e <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4654:	34fd                	addw	s1,s1,-1
    4656:	f0f5                	bnez	s1,463a <fourfiles+0x102>
      exit(0);
    4658:	4501                	li	a0,0
    465a:	00001097          	auipc	ra,0x1
    465e:	f9c080e7          	jalr	-100(ra) # 55f6 <exit>
        printf("create failed\n", s);
    4662:	85e6                	mv	a1,s9
    4664:	00003517          	auipc	a0,0x3
    4668:	11c50513          	add	a0,a0,284 # 7780 <malloc+0x1d6a>
    466c:	00001097          	auipc	ra,0x1
    4670:	2f2080e7          	jalr	754(ra) # 595e <printf>
        exit(1);
    4674:	4505                	li	a0,1
    4676:	00001097          	auipc	ra,0x1
    467a:	f80080e7          	jalr	-128(ra) # 55f6 <exit>
          printf("write failed %d\n", n);
    467e:	00003517          	auipc	a0,0x3
    4682:	11250513          	add	a0,a0,274 # 7790 <malloc+0x1d7a>
    4686:	00001097          	auipc	ra,0x1
    468a:	2d8080e7          	jalr	728(ra) # 595e <printf>
          exit(1);
    468e:	4505                	li	a0,1
    4690:	00001097          	auipc	ra,0x1
    4694:	f66080e7          	jalr	-154(ra) # 55f6 <exit>
      exit(xstatus);
    4698:	8556                	mv	a0,s5
    469a:	00001097          	auipc	ra,0x1
    469e:	f5c080e7          	jalr	-164(ra) # 55f6 <exit>
          printf("wrong char\n", s);
    46a2:	85e6                	mv	a1,s9
    46a4:	00003517          	auipc	a0,0x3
    46a8:	10450513          	add	a0,a0,260 # 77a8 <malloc+0x1d92>
    46ac:	00001097          	auipc	ra,0x1
    46b0:	2b2080e7          	jalr	690(ra) # 595e <printf>
          exit(1);
    46b4:	4505                	li	a0,1
    46b6:	00001097          	auipc	ra,0x1
    46ba:	f40080e7          	jalr	-192(ra) # 55f6 <exit>
      total += n;
    46be:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46c2:	660d                	lui	a2,0x3
    46c4:	85d2                	mv	a1,s4
    46c6:	854e                	mv	a0,s3
    46c8:	00001097          	auipc	ra,0x1
    46cc:	f46080e7          	jalr	-186(ra) # 560e <read>
    46d0:	02a05063          	blez	a0,46f0 <fourfiles+0x1b8>
    46d4:	00007797          	auipc	a5,0x7
    46d8:	3f478793          	add	a5,a5,1012 # bac8 <buf>
    46dc:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    46e0:	0007c703          	lbu	a4,0(a5)
    46e4:	fa971fe3          	bne	a4,s1,46a2 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    46e8:	0785                	add	a5,a5,1
    46ea:	fed79be3          	bne	a5,a3,46e0 <fourfiles+0x1a8>
    46ee:	bfc1                	j	46be <fourfiles+0x186>
    close(fd);
    46f0:	854e                	mv	a0,s3
    46f2:	00001097          	auipc	ra,0x1
    46f6:	f2c080e7          	jalr	-212(ra) # 561e <close>
    if(total != N*SZ){
    46fa:	03a91863          	bne	s2,s10,472a <fourfiles+0x1f2>
    unlink(fname);
    46fe:	8562                	mv	a0,s8
    4700:	00001097          	auipc	ra,0x1
    4704:	f46080e7          	jalr	-186(ra) # 5646 <unlink>
  for(i = 0; i < NCHILD; i++){
    4708:	0ba1                	add	s7,s7,8
    470a:	2b05                	addw	s6,s6,1
    470c:	03bb0d63          	beq	s6,s11,4746 <fourfiles+0x20e>
    fname = names[i];
    4710:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4714:	4581                	li	a1,0
    4716:	8562                	mv	a0,s8
    4718:	00001097          	auipc	ra,0x1
    471c:	f1e080e7          	jalr	-226(ra) # 5636 <open>
    4720:	89aa                	mv	s3,a0
    total = 0;
    4722:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4724:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4728:	bf69                	j	46c2 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    472a:	85ca                	mv	a1,s2
    472c:	00003517          	auipc	a0,0x3
    4730:	08c50513          	add	a0,a0,140 # 77b8 <malloc+0x1da2>
    4734:	00001097          	auipc	ra,0x1
    4738:	22a080e7          	jalr	554(ra) # 595e <printf>
      exit(1);
    473c:	4505                	li	a0,1
    473e:	00001097          	auipc	ra,0x1
    4742:	eb8080e7          	jalr	-328(ra) # 55f6 <exit>
}
    4746:	60ea                	ld	ra,152(sp)
    4748:	644a                	ld	s0,144(sp)
    474a:	64aa                	ld	s1,136(sp)
    474c:	690a                	ld	s2,128(sp)
    474e:	79e6                	ld	s3,120(sp)
    4750:	7a46                	ld	s4,112(sp)
    4752:	7aa6                	ld	s5,104(sp)
    4754:	7b06                	ld	s6,96(sp)
    4756:	6be6                	ld	s7,88(sp)
    4758:	6c46                	ld	s8,80(sp)
    475a:	6ca6                	ld	s9,72(sp)
    475c:	6d06                	ld	s10,64(sp)
    475e:	7de2                	ld	s11,56(sp)
    4760:	610d                	add	sp,sp,160
    4762:	8082                	ret

0000000000004764 <concreate>:
{
    4764:	7135                	add	sp,sp,-160
    4766:	ed06                	sd	ra,152(sp)
    4768:	e922                	sd	s0,144(sp)
    476a:	e526                	sd	s1,136(sp)
    476c:	e14a                	sd	s2,128(sp)
    476e:	fcce                	sd	s3,120(sp)
    4770:	f8d2                	sd	s4,112(sp)
    4772:	f4d6                	sd	s5,104(sp)
    4774:	f0da                	sd	s6,96(sp)
    4776:	ecde                	sd	s7,88(sp)
    4778:	1100                	add	s0,sp,160
    477a:	89aa                	mv	s3,a0
  file[0] = 'C';
    477c:	04300793          	li	a5,67
    4780:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4784:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4788:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    478a:	4b0d                	li	s6,3
    478c:	4a85                	li	s5,1
      link("C0", file);
    478e:	00003b97          	auipc	s7,0x3
    4792:	042b8b93          	add	s7,s7,66 # 77d0 <malloc+0x1dba>
  for(i = 0; i < N; i++){
    4796:	02800a13          	li	s4,40
    479a:	acc9                	j	4a6c <concreate+0x308>
      link("C0", file);
    479c:	fa840593          	add	a1,s0,-88
    47a0:	855e                	mv	a0,s7
    47a2:	00001097          	auipc	ra,0x1
    47a6:	eb4080e7          	jalr	-332(ra) # 5656 <link>
    if(pid == 0) {
    47aa:	a465                	j	4a52 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    47ac:	4795                	li	a5,5
    47ae:	02f9693b          	remw	s2,s2,a5
    47b2:	4785                	li	a5,1
    47b4:	02f90b63          	beq	s2,a5,47ea <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    47b8:	20200593          	li	a1,514
    47bc:	fa840513          	add	a0,s0,-88
    47c0:	00001097          	auipc	ra,0x1
    47c4:	e76080e7          	jalr	-394(ra) # 5636 <open>
      if(fd < 0){
    47c8:	26055c63          	bgez	a0,4a40 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    47cc:	fa840593          	add	a1,s0,-88
    47d0:	00003517          	auipc	a0,0x3
    47d4:	00850513          	add	a0,a0,8 # 77d8 <malloc+0x1dc2>
    47d8:	00001097          	auipc	ra,0x1
    47dc:	186080e7          	jalr	390(ra) # 595e <printf>
        exit(1);
    47e0:	4505                	li	a0,1
    47e2:	00001097          	auipc	ra,0x1
    47e6:	e14080e7          	jalr	-492(ra) # 55f6 <exit>
      link("C0", file);
    47ea:	fa840593          	add	a1,s0,-88
    47ee:	00003517          	auipc	a0,0x3
    47f2:	fe250513          	add	a0,a0,-30 # 77d0 <malloc+0x1dba>
    47f6:	00001097          	auipc	ra,0x1
    47fa:	e60080e7          	jalr	-416(ra) # 5656 <link>
      exit(0);
    47fe:	4501                	li	a0,0
    4800:	00001097          	auipc	ra,0x1
    4804:	df6080e7          	jalr	-522(ra) # 55f6 <exit>
        exit(1);
    4808:	4505                	li	a0,1
    480a:	00001097          	auipc	ra,0x1
    480e:	dec080e7          	jalr	-532(ra) # 55f6 <exit>
  memset(fa, 0, sizeof(fa));
    4812:	02800613          	li	a2,40
    4816:	4581                	li	a1,0
    4818:	f8040513          	add	a0,s0,-128
    481c:	00001097          	auipc	ra,0x1
    4820:	be0080e7          	jalr	-1056(ra) # 53fc <memset>
  fd = open(".", 0);
    4824:	4581                	li	a1,0
    4826:	00002517          	auipc	a0,0x2
    482a:	9ca50513          	add	a0,a0,-1590 # 61f0 <malloc+0x7da>
    482e:	00001097          	auipc	ra,0x1
    4832:	e08080e7          	jalr	-504(ra) # 5636 <open>
    4836:	892a                	mv	s2,a0
  n = 0;
    4838:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    483a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    483e:	02700b13          	li	s6,39
      fa[i] = 1;
    4842:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4844:	4641                	li	a2,16
    4846:	f7040593          	add	a1,s0,-144
    484a:	854a                	mv	a0,s2
    484c:	00001097          	auipc	ra,0x1
    4850:	dc2080e7          	jalr	-574(ra) # 560e <read>
    4854:	08a05263          	blez	a0,48d8 <concreate+0x174>
    if(de.inum == 0)
    4858:	f7045783          	lhu	a5,-144(s0)
    485c:	d7e5                	beqz	a5,4844 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    485e:	f7244783          	lbu	a5,-142(s0)
    4862:	ff4791e3          	bne	a5,s4,4844 <concreate+0xe0>
    4866:	f7444783          	lbu	a5,-140(s0)
    486a:	ffe9                	bnez	a5,4844 <concreate+0xe0>
      i = de.name[1] - '0';
    486c:	f7344783          	lbu	a5,-141(s0)
    4870:	fd07879b          	addw	a5,a5,-48
    4874:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4878:	02eb6063          	bltu	s6,a4,4898 <concreate+0x134>
      if(fa[i]){
    487c:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x50>
    4880:	97a2                	add	a5,a5,s0
    4882:	fd07c783          	lbu	a5,-48(a5)
    4886:	eb8d                	bnez	a5,48b8 <concreate+0x154>
      fa[i] = 1;
    4888:	fb070793          	add	a5,a4,-80
    488c:	00878733          	add	a4,a5,s0
    4890:	fd770823          	sb	s7,-48(a4)
      n++;
    4894:	2a85                	addw	s5,s5,1
    4896:	b77d                	j	4844 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4898:	f7240613          	add	a2,s0,-142
    489c:	85ce                	mv	a1,s3
    489e:	00003517          	auipc	a0,0x3
    48a2:	f5a50513          	add	a0,a0,-166 # 77f8 <malloc+0x1de2>
    48a6:	00001097          	auipc	ra,0x1
    48aa:	0b8080e7          	jalr	184(ra) # 595e <printf>
        exit(1);
    48ae:	4505                	li	a0,1
    48b0:	00001097          	auipc	ra,0x1
    48b4:	d46080e7          	jalr	-698(ra) # 55f6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    48b8:	f7240613          	add	a2,s0,-142
    48bc:	85ce                	mv	a1,s3
    48be:	00003517          	auipc	a0,0x3
    48c2:	f5a50513          	add	a0,a0,-166 # 7818 <malloc+0x1e02>
    48c6:	00001097          	auipc	ra,0x1
    48ca:	098080e7          	jalr	152(ra) # 595e <printf>
        exit(1);
    48ce:	4505                	li	a0,1
    48d0:	00001097          	auipc	ra,0x1
    48d4:	d26080e7          	jalr	-730(ra) # 55f6 <exit>
  close(fd);
    48d8:	854a                	mv	a0,s2
    48da:	00001097          	auipc	ra,0x1
    48de:	d44080e7          	jalr	-700(ra) # 561e <close>
  if(n != N){
    48e2:	02800793          	li	a5,40
    48e6:	00fa9763          	bne	s5,a5,48f4 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    48ea:	4a8d                	li	s5,3
    48ec:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    48ee:	02800a13          	li	s4,40
    48f2:	a8c9                	j	49c4 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    48f4:	85ce                	mv	a1,s3
    48f6:	00003517          	auipc	a0,0x3
    48fa:	f4a50513          	add	a0,a0,-182 # 7840 <malloc+0x1e2a>
    48fe:	00001097          	auipc	ra,0x1
    4902:	060080e7          	jalr	96(ra) # 595e <printf>
    exit(1);
    4906:	4505                	li	a0,1
    4908:	00001097          	auipc	ra,0x1
    490c:	cee080e7          	jalr	-786(ra) # 55f6 <exit>
      printf("%s: fork failed\n", s);
    4910:	85ce                	mv	a1,s3
    4912:	00002517          	auipc	a0,0x2
    4916:	a7e50513          	add	a0,a0,-1410 # 6390 <malloc+0x97a>
    491a:	00001097          	auipc	ra,0x1
    491e:	044080e7          	jalr	68(ra) # 595e <printf>
      exit(1);
    4922:	4505                	li	a0,1
    4924:	00001097          	auipc	ra,0x1
    4928:	cd2080e7          	jalr	-814(ra) # 55f6 <exit>
      close(open(file, 0));
    492c:	4581                	li	a1,0
    492e:	fa840513          	add	a0,s0,-88
    4932:	00001097          	auipc	ra,0x1
    4936:	d04080e7          	jalr	-764(ra) # 5636 <open>
    493a:	00001097          	auipc	ra,0x1
    493e:	ce4080e7          	jalr	-796(ra) # 561e <close>
      close(open(file, 0));
    4942:	4581                	li	a1,0
    4944:	fa840513          	add	a0,s0,-88
    4948:	00001097          	auipc	ra,0x1
    494c:	cee080e7          	jalr	-786(ra) # 5636 <open>
    4950:	00001097          	auipc	ra,0x1
    4954:	cce080e7          	jalr	-818(ra) # 561e <close>
      close(open(file, 0));
    4958:	4581                	li	a1,0
    495a:	fa840513          	add	a0,s0,-88
    495e:	00001097          	auipc	ra,0x1
    4962:	cd8080e7          	jalr	-808(ra) # 5636 <open>
    4966:	00001097          	auipc	ra,0x1
    496a:	cb8080e7          	jalr	-840(ra) # 561e <close>
      close(open(file, 0));
    496e:	4581                	li	a1,0
    4970:	fa840513          	add	a0,s0,-88
    4974:	00001097          	auipc	ra,0x1
    4978:	cc2080e7          	jalr	-830(ra) # 5636 <open>
    497c:	00001097          	auipc	ra,0x1
    4980:	ca2080e7          	jalr	-862(ra) # 561e <close>
      close(open(file, 0));
    4984:	4581                	li	a1,0
    4986:	fa840513          	add	a0,s0,-88
    498a:	00001097          	auipc	ra,0x1
    498e:	cac080e7          	jalr	-852(ra) # 5636 <open>
    4992:	00001097          	auipc	ra,0x1
    4996:	c8c080e7          	jalr	-884(ra) # 561e <close>
      close(open(file, 0));
    499a:	4581                	li	a1,0
    499c:	fa840513          	add	a0,s0,-88
    49a0:	00001097          	auipc	ra,0x1
    49a4:	c96080e7          	jalr	-874(ra) # 5636 <open>
    49a8:	00001097          	auipc	ra,0x1
    49ac:	c76080e7          	jalr	-906(ra) # 561e <close>
    if(pid == 0)
    49b0:	08090363          	beqz	s2,4a36 <concreate+0x2d2>
      wait(0);
    49b4:	4501                	li	a0,0
    49b6:	00001097          	auipc	ra,0x1
    49ba:	c48080e7          	jalr	-952(ra) # 55fe <wait>
  for(i = 0; i < N; i++){
    49be:	2485                	addw	s1,s1,1
    49c0:	0f448563          	beq	s1,s4,4aaa <concreate+0x346>
    file[1] = '0' + i;
    49c4:	0304879b          	addw	a5,s1,48
    49c8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    49cc:	00001097          	auipc	ra,0x1
    49d0:	c22080e7          	jalr	-990(ra) # 55ee <fork>
    49d4:	892a                	mv	s2,a0
    if(pid < 0){
    49d6:	f2054de3          	bltz	a0,4910 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    49da:	0354e73b          	remw	a4,s1,s5
    49de:	00a767b3          	or	a5,a4,a0
    49e2:	2781                	sext.w	a5,a5
    49e4:	d7a1                	beqz	a5,492c <concreate+0x1c8>
    49e6:	01671363          	bne	a4,s6,49ec <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    49ea:	f129                	bnez	a0,492c <concreate+0x1c8>
      unlink(file);
    49ec:	fa840513          	add	a0,s0,-88
    49f0:	00001097          	auipc	ra,0x1
    49f4:	c56080e7          	jalr	-938(ra) # 5646 <unlink>
      unlink(file);
    49f8:	fa840513          	add	a0,s0,-88
    49fc:	00001097          	auipc	ra,0x1
    4a00:	c4a080e7          	jalr	-950(ra) # 5646 <unlink>
      unlink(file);
    4a04:	fa840513          	add	a0,s0,-88
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	c3e080e7          	jalr	-962(ra) # 5646 <unlink>
      unlink(file);
    4a10:	fa840513          	add	a0,s0,-88
    4a14:	00001097          	auipc	ra,0x1
    4a18:	c32080e7          	jalr	-974(ra) # 5646 <unlink>
      unlink(file);
    4a1c:	fa840513          	add	a0,s0,-88
    4a20:	00001097          	auipc	ra,0x1
    4a24:	c26080e7          	jalr	-986(ra) # 5646 <unlink>
      unlink(file);
    4a28:	fa840513          	add	a0,s0,-88
    4a2c:	00001097          	auipc	ra,0x1
    4a30:	c1a080e7          	jalr	-998(ra) # 5646 <unlink>
    4a34:	bfb5                	j	49b0 <concreate+0x24c>
      exit(0);
    4a36:	4501                	li	a0,0
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	bbe080e7          	jalr	-1090(ra) # 55f6 <exit>
      close(fd);
    4a40:	00001097          	auipc	ra,0x1
    4a44:	bde080e7          	jalr	-1058(ra) # 561e <close>
    if(pid == 0) {
    4a48:	bb5d                	j	47fe <concreate+0x9a>
      close(fd);
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	bd4080e7          	jalr	-1068(ra) # 561e <close>
      wait(&xstatus);
    4a52:	f6c40513          	add	a0,s0,-148
    4a56:	00001097          	auipc	ra,0x1
    4a5a:	ba8080e7          	jalr	-1112(ra) # 55fe <wait>
      if(xstatus != 0)
    4a5e:	f6c42483          	lw	s1,-148(s0)
    4a62:	da0493e3          	bnez	s1,4808 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4a66:	2905                	addw	s2,s2,1
    4a68:	db4905e3          	beq	s2,s4,4812 <concreate+0xae>
    file[1] = '0' + i;
    4a6c:	0309079b          	addw	a5,s2,48
    4a70:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4a74:	fa840513          	add	a0,s0,-88
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	bce080e7          	jalr	-1074(ra) # 5646 <unlink>
    pid = fork();
    4a80:	00001097          	auipc	ra,0x1
    4a84:	b6e080e7          	jalr	-1170(ra) # 55ee <fork>
    if(pid && (i % 3) == 1){
    4a88:	d20502e3          	beqz	a0,47ac <concreate+0x48>
    4a8c:	036967bb          	remw	a5,s2,s6
    4a90:	d15786e3          	beq	a5,s5,479c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4a94:	20200593          	li	a1,514
    4a98:	fa840513          	add	a0,s0,-88
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	b9a080e7          	jalr	-1126(ra) # 5636 <open>
      if(fd < 0){
    4aa4:	fa0553e3          	bgez	a0,4a4a <concreate+0x2e6>
    4aa8:	b315                	j	47cc <concreate+0x68>
}
    4aaa:	60ea                	ld	ra,152(sp)
    4aac:	644a                	ld	s0,144(sp)
    4aae:	64aa                	ld	s1,136(sp)
    4ab0:	690a                	ld	s2,128(sp)
    4ab2:	79e6                	ld	s3,120(sp)
    4ab4:	7a46                	ld	s4,112(sp)
    4ab6:	7aa6                	ld	s5,104(sp)
    4ab8:	7b06                	ld	s6,96(sp)
    4aba:	6be6                	ld	s7,88(sp)
    4abc:	610d                	add	sp,sp,160
    4abe:	8082                	ret

0000000000004ac0 <bigfile>:
{
    4ac0:	7139                	add	sp,sp,-64
    4ac2:	fc06                	sd	ra,56(sp)
    4ac4:	f822                	sd	s0,48(sp)
    4ac6:	f426                	sd	s1,40(sp)
    4ac8:	f04a                	sd	s2,32(sp)
    4aca:	ec4e                	sd	s3,24(sp)
    4acc:	e852                	sd	s4,16(sp)
    4ace:	e456                	sd	s5,8(sp)
    4ad0:	0080                	add	s0,sp,64
    4ad2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4ad4:	00003517          	auipc	a0,0x3
    4ad8:	da450513          	add	a0,a0,-604 # 7878 <malloc+0x1e62>
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	b6a080e7          	jalr	-1174(ra) # 5646 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4ae4:	20200593          	li	a1,514
    4ae8:	00003517          	auipc	a0,0x3
    4aec:	d9050513          	add	a0,a0,-624 # 7878 <malloc+0x1e62>
    4af0:	00001097          	auipc	ra,0x1
    4af4:	b46080e7          	jalr	-1210(ra) # 5636 <open>
    4af8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4afa:	4481                	li	s1,0
    memset(buf, i, SZ);
    4afc:	00007917          	auipc	s2,0x7
    4b00:	fcc90913          	add	s2,s2,-52 # bac8 <buf>
  for(i = 0; i < N; i++){
    4b04:	4a51                	li	s4,20
  if(fd < 0){
    4b06:	0a054063          	bltz	a0,4ba6 <bigfile+0xe6>
    memset(buf, i, SZ);
    4b0a:	25800613          	li	a2,600
    4b0e:	85a6                	mv	a1,s1
    4b10:	854a                	mv	a0,s2
    4b12:	00001097          	auipc	ra,0x1
    4b16:	8ea080e7          	jalr	-1814(ra) # 53fc <memset>
    if(write(fd, buf, SZ) != SZ){
    4b1a:	25800613          	li	a2,600
    4b1e:	85ca                	mv	a1,s2
    4b20:	854e                	mv	a0,s3
    4b22:	00001097          	auipc	ra,0x1
    4b26:	af4080e7          	jalr	-1292(ra) # 5616 <write>
    4b2a:	25800793          	li	a5,600
    4b2e:	08f51a63          	bne	a0,a5,4bc2 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b32:	2485                	addw	s1,s1,1
    4b34:	fd449be3          	bne	s1,s4,4b0a <bigfile+0x4a>
  close(fd);
    4b38:	854e                	mv	a0,s3
    4b3a:	00001097          	auipc	ra,0x1
    4b3e:	ae4080e7          	jalr	-1308(ra) # 561e <close>
  fd = open("bigfile.dat", 0);
    4b42:	4581                	li	a1,0
    4b44:	00003517          	auipc	a0,0x3
    4b48:	d3450513          	add	a0,a0,-716 # 7878 <malloc+0x1e62>
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	aea080e7          	jalr	-1302(ra) # 5636 <open>
    4b54:	8a2a                	mv	s4,a0
  total = 0;
    4b56:	4981                	li	s3,0
  for(i = 0; ; i++){
    4b58:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4b5a:	00007917          	auipc	s2,0x7
    4b5e:	f6e90913          	add	s2,s2,-146 # bac8 <buf>
  if(fd < 0){
    4b62:	06054e63          	bltz	a0,4bde <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4b66:	12c00613          	li	a2,300
    4b6a:	85ca                	mv	a1,s2
    4b6c:	8552                	mv	a0,s4
    4b6e:	00001097          	auipc	ra,0x1
    4b72:	aa0080e7          	jalr	-1376(ra) # 560e <read>
    if(cc < 0){
    4b76:	08054263          	bltz	a0,4bfa <bigfile+0x13a>
    if(cc == 0)
    4b7a:	c971                	beqz	a0,4c4e <bigfile+0x18e>
    if(cc != SZ/2){
    4b7c:	12c00793          	li	a5,300
    4b80:	08f51b63          	bne	a0,a5,4c16 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4b84:	01f4d79b          	srlw	a5,s1,0x1f
    4b88:	9fa5                	addw	a5,a5,s1
    4b8a:	4017d79b          	sraw	a5,a5,0x1
    4b8e:	00094703          	lbu	a4,0(s2)
    4b92:	0af71063          	bne	a4,a5,4c32 <bigfile+0x172>
    4b96:	12b94703          	lbu	a4,299(s2)
    4b9a:	08f71c63          	bne	a4,a5,4c32 <bigfile+0x172>
    total += cc;
    4b9e:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4ba2:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4ba4:	b7c9                	j	4b66 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4ba6:	85d6                	mv	a1,s5
    4ba8:	00003517          	auipc	a0,0x3
    4bac:	ce050513          	add	a0,a0,-800 # 7888 <malloc+0x1e72>
    4bb0:	00001097          	auipc	ra,0x1
    4bb4:	dae080e7          	jalr	-594(ra) # 595e <printf>
    exit(1);
    4bb8:	4505                	li	a0,1
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	a3c080e7          	jalr	-1476(ra) # 55f6 <exit>
      printf("%s: write bigfile failed\n", s);
    4bc2:	85d6                	mv	a1,s5
    4bc4:	00003517          	auipc	a0,0x3
    4bc8:	ce450513          	add	a0,a0,-796 # 78a8 <malloc+0x1e92>
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	d92080e7          	jalr	-622(ra) # 595e <printf>
      exit(1);
    4bd4:	4505                	li	a0,1
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	a20080e7          	jalr	-1504(ra) # 55f6 <exit>
    printf("%s: cannot open bigfile\n", s);
    4bde:	85d6                	mv	a1,s5
    4be0:	00003517          	auipc	a0,0x3
    4be4:	ce850513          	add	a0,a0,-792 # 78c8 <malloc+0x1eb2>
    4be8:	00001097          	auipc	ra,0x1
    4bec:	d76080e7          	jalr	-650(ra) # 595e <printf>
    exit(1);
    4bf0:	4505                	li	a0,1
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	a04080e7          	jalr	-1532(ra) # 55f6 <exit>
      printf("%s: read bigfile failed\n", s);
    4bfa:	85d6                	mv	a1,s5
    4bfc:	00003517          	auipc	a0,0x3
    4c00:	cec50513          	add	a0,a0,-788 # 78e8 <malloc+0x1ed2>
    4c04:	00001097          	auipc	ra,0x1
    4c08:	d5a080e7          	jalr	-678(ra) # 595e <printf>
      exit(1);
    4c0c:	4505                	li	a0,1
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	9e8080e7          	jalr	-1560(ra) # 55f6 <exit>
      printf("%s: short read bigfile\n", s);
    4c16:	85d6                	mv	a1,s5
    4c18:	00003517          	auipc	a0,0x3
    4c1c:	cf050513          	add	a0,a0,-784 # 7908 <malloc+0x1ef2>
    4c20:	00001097          	auipc	ra,0x1
    4c24:	d3e080e7          	jalr	-706(ra) # 595e <printf>
      exit(1);
    4c28:	4505                	li	a0,1
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	9cc080e7          	jalr	-1588(ra) # 55f6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c32:	85d6                	mv	a1,s5
    4c34:	00003517          	auipc	a0,0x3
    4c38:	cec50513          	add	a0,a0,-788 # 7920 <malloc+0x1f0a>
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	d22080e7          	jalr	-734(ra) # 595e <printf>
      exit(1);
    4c44:	4505                	li	a0,1
    4c46:	00001097          	auipc	ra,0x1
    4c4a:	9b0080e7          	jalr	-1616(ra) # 55f6 <exit>
  close(fd);
    4c4e:	8552                	mv	a0,s4
    4c50:	00001097          	auipc	ra,0x1
    4c54:	9ce080e7          	jalr	-1586(ra) # 561e <close>
  if(total != N*SZ){
    4c58:	678d                	lui	a5,0x3
    4c5a:	ee078793          	add	a5,a5,-288 # 2ee0 <exitiputtest+0x4e>
    4c5e:	02f99363          	bne	s3,a5,4c84 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4c62:	00003517          	auipc	a0,0x3
    4c66:	c1650513          	add	a0,a0,-1002 # 7878 <malloc+0x1e62>
    4c6a:	00001097          	auipc	ra,0x1
    4c6e:	9dc080e7          	jalr	-1572(ra) # 5646 <unlink>
}
    4c72:	70e2                	ld	ra,56(sp)
    4c74:	7442                	ld	s0,48(sp)
    4c76:	74a2                	ld	s1,40(sp)
    4c78:	7902                	ld	s2,32(sp)
    4c7a:	69e2                	ld	s3,24(sp)
    4c7c:	6a42                	ld	s4,16(sp)
    4c7e:	6aa2                	ld	s5,8(sp)
    4c80:	6121                	add	sp,sp,64
    4c82:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4c84:	85d6                	mv	a1,s5
    4c86:	00003517          	auipc	a0,0x3
    4c8a:	cba50513          	add	a0,a0,-838 # 7940 <malloc+0x1f2a>
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	cd0080e7          	jalr	-816(ra) # 595e <printf>
    exit(1);
    4c96:	4505                	li	a0,1
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	95e080e7          	jalr	-1698(ra) # 55f6 <exit>

0000000000004ca0 <fsfull>:
{
    4ca0:	7135                	add	sp,sp,-160
    4ca2:	ed06                	sd	ra,152(sp)
    4ca4:	e922                	sd	s0,144(sp)
    4ca6:	e526                	sd	s1,136(sp)
    4ca8:	e14a                	sd	s2,128(sp)
    4caa:	fcce                	sd	s3,120(sp)
    4cac:	f8d2                	sd	s4,112(sp)
    4cae:	f4d6                	sd	s5,104(sp)
    4cb0:	f0da                	sd	s6,96(sp)
    4cb2:	ecde                	sd	s7,88(sp)
    4cb4:	e8e2                	sd	s8,80(sp)
    4cb6:	e4e6                	sd	s9,72(sp)
    4cb8:	e0ea                	sd	s10,64(sp)
    4cba:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    4cbc:	00003517          	auipc	a0,0x3
    4cc0:	ca450513          	add	a0,a0,-860 # 7960 <malloc+0x1f4a>
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	c9a080e7          	jalr	-870(ra) # 595e <printf>
  for(nfiles = 0; ; nfiles++){
    4ccc:	4481                	li	s1,0
    name[0] = 'f';
    4cce:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4cd2:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4cd6:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4cda:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4cdc:	00003c97          	auipc	s9,0x3
    4ce0:	c94c8c93          	add	s9,s9,-876 # 7970 <malloc+0x1f5a>
    name[0] = 'f';
    4ce4:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4ce8:	0384c7bb          	divw	a5,s1,s8
    4cec:	0307879b          	addw	a5,a5,48
    4cf0:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4cf4:	0384e7bb          	remw	a5,s1,s8
    4cf8:	0377c7bb          	divw	a5,a5,s7
    4cfc:	0307879b          	addw	a5,a5,48
    4d00:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d04:	0374e7bb          	remw	a5,s1,s7
    4d08:	0367c7bb          	divw	a5,a5,s6
    4d0c:	0307879b          	addw	a5,a5,48
    4d10:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4d14:	0364e7bb          	remw	a5,s1,s6
    4d18:	0307879b          	addw	a5,a5,48
    4d1c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4d20:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4d24:	f6040593          	add	a1,s0,-160
    4d28:	8566                	mv	a0,s9
    4d2a:	00001097          	auipc	ra,0x1
    4d2e:	c34080e7          	jalr	-972(ra) # 595e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d32:	20200593          	li	a1,514
    4d36:	f6040513          	add	a0,s0,-160
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	8fc080e7          	jalr	-1796(ra) # 5636 <open>
    4d42:	892a                	mv	s2,a0
    if(fd < 0){
    4d44:	0a055563          	bgez	a0,4dee <fsfull+0x14e>
      printf("open %s failed\n", name);
    4d48:	f6040593          	add	a1,s0,-160
    4d4c:	00003517          	auipc	a0,0x3
    4d50:	c3450513          	add	a0,a0,-972 # 7980 <malloc+0x1f6a>
    4d54:	00001097          	auipc	ra,0x1
    4d58:	c0a080e7          	jalr	-1014(ra) # 595e <printf>
  while(nfiles >= 0){
    4d5c:	0604c363          	bltz	s1,4dc2 <fsfull+0x122>
    name[0] = 'f';
    4d60:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d64:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d68:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d6c:	4929                	li	s2,10
  while(nfiles >= 0){
    4d6e:	5afd                	li	s5,-1
    name[0] = 'f';
    4d70:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4d74:	0344c7bb          	divw	a5,s1,s4
    4d78:	0307879b          	addw	a5,a5,48
    4d7c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d80:	0344e7bb          	remw	a5,s1,s4
    4d84:	0337c7bb          	divw	a5,a5,s3
    4d88:	0307879b          	addw	a5,a5,48
    4d8c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d90:	0334e7bb          	remw	a5,s1,s3
    4d94:	0327c7bb          	divw	a5,a5,s2
    4d98:	0307879b          	addw	a5,a5,48
    4d9c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4da0:	0324e7bb          	remw	a5,s1,s2
    4da4:	0307879b          	addw	a5,a5,48
    4da8:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4dac:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4db0:	f6040513          	add	a0,s0,-160
    4db4:	00001097          	auipc	ra,0x1
    4db8:	892080e7          	jalr	-1902(ra) # 5646 <unlink>
    nfiles--;
    4dbc:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    4dbe:	fb5499e3          	bne	s1,s5,4d70 <fsfull+0xd0>
  printf("fsfull test finished\n");
    4dc2:	00003517          	auipc	a0,0x3
    4dc6:	bde50513          	add	a0,a0,-1058 # 79a0 <malloc+0x1f8a>
    4dca:	00001097          	auipc	ra,0x1
    4dce:	b94080e7          	jalr	-1132(ra) # 595e <printf>
}
    4dd2:	60ea                	ld	ra,152(sp)
    4dd4:	644a                	ld	s0,144(sp)
    4dd6:	64aa                	ld	s1,136(sp)
    4dd8:	690a                	ld	s2,128(sp)
    4dda:	79e6                	ld	s3,120(sp)
    4ddc:	7a46                	ld	s4,112(sp)
    4dde:	7aa6                	ld	s5,104(sp)
    4de0:	7b06                	ld	s6,96(sp)
    4de2:	6be6                	ld	s7,88(sp)
    4de4:	6c46                	ld	s8,80(sp)
    4de6:	6ca6                	ld	s9,72(sp)
    4de8:	6d06                	ld	s10,64(sp)
    4dea:	610d                	add	sp,sp,160
    4dec:	8082                	ret
    int total = 0;
    4dee:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4df0:	00007a97          	auipc	s5,0x7
    4df4:	cd8a8a93          	add	s5,s5,-808 # bac8 <buf>
      if(cc < BSIZE)
    4df8:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4dfc:	40000613          	li	a2,1024
    4e00:	85d6                	mv	a1,s5
    4e02:	854a                	mv	a0,s2
    4e04:	00001097          	auipc	ra,0x1
    4e08:	812080e7          	jalr	-2030(ra) # 5616 <write>
      if(cc < BSIZE)
    4e0c:	00aa5563          	bge	s4,a0,4e16 <fsfull+0x176>
      total += cc;
    4e10:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e14:	b7e5                	j	4dfc <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    4e16:	85ce                	mv	a1,s3
    4e18:	00003517          	auipc	a0,0x3
    4e1c:	b7850513          	add	a0,a0,-1160 # 7990 <malloc+0x1f7a>
    4e20:	00001097          	auipc	ra,0x1
    4e24:	b3e080e7          	jalr	-1218(ra) # 595e <printf>
    close(fd);
    4e28:	854a                	mv	a0,s2
    4e2a:	00000097          	auipc	ra,0x0
    4e2e:	7f4080e7          	jalr	2036(ra) # 561e <close>
    if(total == 0)
    4e32:	f20985e3          	beqz	s3,4d5c <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    4e36:	2485                	addw	s1,s1,1
    4e38:	b575                	j	4ce4 <fsfull+0x44>

0000000000004e3a <rand>:
{
    4e3a:	1141                	add	sp,sp,-16
    4e3c:	e422                	sd	s0,8(sp)
    4e3e:	0800                	add	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e40:	00003717          	auipc	a4,0x3
    4e44:	46070713          	add	a4,a4,1120 # 82a0 <randstate>
    4e48:	6308                	ld	a0,0(a4)
    4e4a:	001967b7          	lui	a5,0x196
    4e4e:	60d78793          	add	a5,a5,1549 # 19660d <__BSS_END__+0x187b35>
    4e52:	02f50533          	mul	a0,a0,a5
    4e56:	3c6ef7b7          	lui	a5,0x3c6ef
    4e5a:	35f78793          	add	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0887>
    4e5e:	953e                	add	a0,a0,a5
    4e60:	e308                	sd	a0,0(a4)
}
    4e62:	2501                	sext.w	a0,a0
    4e64:	6422                	ld	s0,8(sp)
    4e66:	0141                	add	sp,sp,16
    4e68:	8082                	ret

0000000000004e6a <badwrite>:
{
    4e6a:	7179                	add	sp,sp,-48
    4e6c:	f406                	sd	ra,40(sp)
    4e6e:	f022                	sd	s0,32(sp)
    4e70:	ec26                	sd	s1,24(sp)
    4e72:	e84a                	sd	s2,16(sp)
    4e74:	e44e                	sd	s3,8(sp)
    4e76:	e052                	sd	s4,0(sp)
    4e78:	1800                	add	s0,sp,48
  unlink("junk");
    4e7a:	00003517          	auipc	a0,0x3
    4e7e:	b3e50513          	add	a0,a0,-1218 # 79b8 <malloc+0x1fa2>
    4e82:	00000097          	auipc	ra,0x0
    4e86:	7c4080e7          	jalr	1988(ra) # 5646 <unlink>
    4e8a:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4e8e:	00003997          	auipc	s3,0x3
    4e92:	b2a98993          	add	s3,s3,-1238 # 79b8 <malloc+0x1fa2>
    write(fd, (char*)0xffffffffffL, 1);
    4e96:	5a7d                	li	s4,-1
    4e98:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4e9c:	20100593          	li	a1,513
    4ea0:	854e                	mv	a0,s3
    4ea2:	00000097          	auipc	ra,0x0
    4ea6:	794080e7          	jalr	1940(ra) # 5636 <open>
    4eaa:	84aa                	mv	s1,a0
    if(fd < 0){
    4eac:	06054b63          	bltz	a0,4f22 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4eb0:	4605                	li	a2,1
    4eb2:	85d2                	mv	a1,s4
    4eb4:	00000097          	auipc	ra,0x0
    4eb8:	762080e7          	jalr	1890(ra) # 5616 <write>
    close(fd);
    4ebc:	8526                	mv	a0,s1
    4ebe:	00000097          	auipc	ra,0x0
    4ec2:	760080e7          	jalr	1888(ra) # 561e <close>
    unlink("junk");
    4ec6:	854e                	mv	a0,s3
    4ec8:	00000097          	auipc	ra,0x0
    4ecc:	77e080e7          	jalr	1918(ra) # 5646 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4ed0:	397d                	addw	s2,s2,-1
    4ed2:	fc0915e3          	bnez	s2,4e9c <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4ed6:	20100593          	li	a1,513
    4eda:	00003517          	auipc	a0,0x3
    4ede:	ade50513          	add	a0,a0,-1314 # 79b8 <malloc+0x1fa2>
    4ee2:	00000097          	auipc	ra,0x0
    4ee6:	754080e7          	jalr	1876(ra) # 5636 <open>
    4eea:	84aa                	mv	s1,a0
  if(fd < 0){
    4eec:	04054863          	bltz	a0,4f3c <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4ef0:	4605                	li	a2,1
    4ef2:	00001597          	auipc	a1,0x1
    4ef6:	cb658593          	add	a1,a1,-842 # 5ba8 <malloc+0x192>
    4efa:	00000097          	auipc	ra,0x0
    4efe:	71c080e7          	jalr	1820(ra) # 5616 <write>
    4f02:	4785                	li	a5,1
    4f04:	04f50963          	beq	a0,a5,4f56 <badwrite+0xec>
    printf("write failed\n");
    4f08:	00003517          	auipc	a0,0x3
    4f0c:	ad050513          	add	a0,a0,-1328 # 79d8 <malloc+0x1fc2>
    4f10:	00001097          	auipc	ra,0x1
    4f14:	a4e080e7          	jalr	-1458(ra) # 595e <printf>
    exit(1);
    4f18:	4505                	li	a0,1
    4f1a:	00000097          	auipc	ra,0x0
    4f1e:	6dc080e7          	jalr	1756(ra) # 55f6 <exit>
      printf("open junk failed\n");
    4f22:	00003517          	auipc	a0,0x3
    4f26:	a9e50513          	add	a0,a0,-1378 # 79c0 <malloc+0x1faa>
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	a34080e7          	jalr	-1484(ra) # 595e <printf>
      exit(1);
    4f32:	4505                	li	a0,1
    4f34:	00000097          	auipc	ra,0x0
    4f38:	6c2080e7          	jalr	1730(ra) # 55f6 <exit>
    printf("open junk failed\n");
    4f3c:	00003517          	auipc	a0,0x3
    4f40:	a8450513          	add	a0,a0,-1404 # 79c0 <malloc+0x1faa>
    4f44:	00001097          	auipc	ra,0x1
    4f48:	a1a080e7          	jalr	-1510(ra) # 595e <printf>
    exit(1);
    4f4c:	4505                	li	a0,1
    4f4e:	00000097          	auipc	ra,0x0
    4f52:	6a8080e7          	jalr	1704(ra) # 55f6 <exit>
  close(fd);
    4f56:	8526                	mv	a0,s1
    4f58:	00000097          	auipc	ra,0x0
    4f5c:	6c6080e7          	jalr	1734(ra) # 561e <close>
  unlink("junk");
    4f60:	00003517          	auipc	a0,0x3
    4f64:	a5850513          	add	a0,a0,-1448 # 79b8 <malloc+0x1fa2>
    4f68:	00000097          	auipc	ra,0x0
    4f6c:	6de080e7          	jalr	1758(ra) # 5646 <unlink>
  exit(0);
    4f70:	4501                	li	a0,0
    4f72:	00000097          	auipc	ra,0x0
    4f76:	684080e7          	jalr	1668(ra) # 55f6 <exit>

0000000000004f7a <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4f7a:	7139                	add	sp,sp,-64
    4f7c:	fc06                	sd	ra,56(sp)
    4f7e:	f822                	sd	s0,48(sp)
    4f80:	f426                	sd	s1,40(sp)
    4f82:	f04a                	sd	s2,32(sp)
    4f84:	ec4e                	sd	s3,24(sp)
    4f86:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4f88:	fc840513          	add	a0,s0,-56
    4f8c:	00000097          	auipc	ra,0x0
    4f90:	67a080e7          	jalr	1658(ra) # 5606 <pipe>
    4f94:	06054763          	bltz	a0,5002 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4f98:	00000097          	auipc	ra,0x0
    4f9c:	656080e7          	jalr	1622(ra) # 55ee <fork>

  if(pid < 0){
    4fa0:	06054e63          	bltz	a0,501c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4fa4:	ed51                	bnez	a0,5040 <countfree+0xc6>
    close(fds[0]);
    4fa6:	fc842503          	lw	a0,-56(s0)
    4faa:	00000097          	auipc	ra,0x0
    4fae:	674080e7          	jalr	1652(ra) # 561e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4fb2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4fb4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4fb6:	00001997          	auipc	s3,0x1
    4fba:	bf298993          	add	s3,s3,-1038 # 5ba8 <malloc+0x192>
      uint64 a = (uint64) sbrk(4096);
    4fbe:	6505                	lui	a0,0x1
    4fc0:	00000097          	auipc	ra,0x0
    4fc4:	6be080e7          	jalr	1726(ra) # 567e <sbrk>
      if(a == 0xffffffffffffffff){
    4fc8:	07250763          	beq	a0,s2,5036 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4fcc:	6785                	lui	a5,0x1
    4fce:	97aa                	add	a5,a5,a0
    4fd0:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9f>
      if(write(fds[1], "x", 1) != 1){
    4fd4:	8626                	mv	a2,s1
    4fd6:	85ce                	mv	a1,s3
    4fd8:	fcc42503          	lw	a0,-52(s0)
    4fdc:	00000097          	auipc	ra,0x0
    4fe0:	63a080e7          	jalr	1594(ra) # 5616 <write>
    4fe4:	fc950de3          	beq	a0,s1,4fbe <countfree+0x44>
        printf("write() failed in countfree()\n");
    4fe8:	00003517          	auipc	a0,0x3
    4fec:	a4050513          	add	a0,a0,-1472 # 7a28 <malloc+0x2012>
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	96e080e7          	jalr	-1682(ra) # 595e <printf>
        exit(1);
    4ff8:	4505                	li	a0,1
    4ffa:	00000097          	auipc	ra,0x0
    4ffe:	5fc080e7          	jalr	1532(ra) # 55f6 <exit>
    printf("pipe() failed in countfree()\n");
    5002:	00003517          	auipc	a0,0x3
    5006:	9e650513          	add	a0,a0,-1562 # 79e8 <malloc+0x1fd2>
    500a:	00001097          	auipc	ra,0x1
    500e:	954080e7          	jalr	-1708(ra) # 595e <printf>
    exit(1);
    5012:	4505                	li	a0,1
    5014:	00000097          	auipc	ra,0x0
    5018:	5e2080e7          	jalr	1506(ra) # 55f6 <exit>
    printf("fork failed in countfree()\n");
    501c:	00003517          	auipc	a0,0x3
    5020:	9ec50513          	add	a0,a0,-1556 # 7a08 <malloc+0x1ff2>
    5024:	00001097          	auipc	ra,0x1
    5028:	93a080e7          	jalr	-1734(ra) # 595e <printf>
    exit(1);
    502c:	4505                	li	a0,1
    502e:	00000097          	auipc	ra,0x0
    5032:	5c8080e7          	jalr	1480(ra) # 55f6 <exit>
      }
    }

    exit(0);
    5036:	4501                	li	a0,0
    5038:	00000097          	auipc	ra,0x0
    503c:	5be080e7          	jalr	1470(ra) # 55f6 <exit>
  }

  close(fds[1]);
    5040:	fcc42503          	lw	a0,-52(s0)
    5044:	00000097          	auipc	ra,0x0
    5048:	5da080e7          	jalr	1498(ra) # 561e <close>

  int n = 0;
    504c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    504e:	4605                	li	a2,1
    5050:	fc740593          	add	a1,s0,-57
    5054:	fc842503          	lw	a0,-56(s0)
    5058:	00000097          	auipc	ra,0x0
    505c:	5b6080e7          	jalr	1462(ra) # 560e <read>
    if(cc < 0){
    5060:	00054563          	bltz	a0,506a <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5064:	c105                	beqz	a0,5084 <countfree+0x10a>
      break;
    n += 1;
    5066:	2485                	addw	s1,s1,1
  while(1){
    5068:	b7dd                	j	504e <countfree+0xd4>
      printf("read() failed in countfree()\n");
    506a:	00003517          	auipc	a0,0x3
    506e:	9de50513          	add	a0,a0,-1570 # 7a48 <malloc+0x2032>
    5072:	00001097          	auipc	ra,0x1
    5076:	8ec080e7          	jalr	-1812(ra) # 595e <printf>
      exit(1);
    507a:	4505                	li	a0,1
    507c:	00000097          	auipc	ra,0x0
    5080:	57a080e7          	jalr	1402(ra) # 55f6 <exit>
  }

  close(fds[0]);
    5084:	fc842503          	lw	a0,-56(s0)
    5088:	00000097          	auipc	ra,0x0
    508c:	596080e7          	jalr	1430(ra) # 561e <close>
  wait((int*)0);
    5090:	4501                	li	a0,0
    5092:	00000097          	auipc	ra,0x0
    5096:	56c080e7          	jalr	1388(ra) # 55fe <wait>
  
  return n;
}
    509a:	8526                	mv	a0,s1
    509c:	70e2                	ld	ra,56(sp)
    509e:	7442                	ld	s0,48(sp)
    50a0:	74a2                	ld	s1,40(sp)
    50a2:	7902                	ld	s2,32(sp)
    50a4:	69e2                	ld	s3,24(sp)
    50a6:	6121                	add	sp,sp,64
    50a8:	8082                	ret

00000000000050aa <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    50aa:	7179                	add	sp,sp,-48
    50ac:	f406                	sd	ra,40(sp)
    50ae:	f022                	sd	s0,32(sp)
    50b0:	ec26                	sd	s1,24(sp)
    50b2:	e84a                	sd	s2,16(sp)
    50b4:	1800                	add	s0,sp,48
    50b6:	84aa                	mv	s1,a0
    50b8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    50ba:	00003517          	auipc	a0,0x3
    50be:	9ae50513          	add	a0,a0,-1618 # 7a68 <malloc+0x2052>
    50c2:	00001097          	auipc	ra,0x1
    50c6:	89c080e7          	jalr	-1892(ra) # 595e <printf>
  if((pid = fork()) < 0) {
    50ca:	00000097          	auipc	ra,0x0
    50ce:	524080e7          	jalr	1316(ra) # 55ee <fork>
    50d2:	02054e63          	bltz	a0,510e <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    50d6:	c929                	beqz	a0,5128 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    50d8:	fdc40513          	add	a0,s0,-36
    50dc:	00000097          	auipc	ra,0x0
    50e0:	522080e7          	jalr	1314(ra) # 55fe <wait>
    if(xstatus != 0) 
    50e4:	fdc42783          	lw	a5,-36(s0)
    50e8:	c7b9                	beqz	a5,5136 <run+0x8c>
      printf("FAILED\n");
    50ea:	00003517          	auipc	a0,0x3
    50ee:	9a650513          	add	a0,a0,-1626 # 7a90 <malloc+0x207a>
    50f2:	00001097          	auipc	ra,0x1
    50f6:	86c080e7          	jalr	-1940(ra) # 595e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    50fa:	fdc42503          	lw	a0,-36(s0)
  }
}
    50fe:	00153513          	seqz	a0,a0
    5102:	70a2                	ld	ra,40(sp)
    5104:	7402                	ld	s0,32(sp)
    5106:	64e2                	ld	s1,24(sp)
    5108:	6942                	ld	s2,16(sp)
    510a:	6145                	add	sp,sp,48
    510c:	8082                	ret
    printf("runtest: fork error\n");
    510e:	00003517          	auipc	a0,0x3
    5112:	96a50513          	add	a0,a0,-1686 # 7a78 <malloc+0x2062>
    5116:	00001097          	auipc	ra,0x1
    511a:	848080e7          	jalr	-1976(ra) # 595e <printf>
    exit(1);
    511e:	4505                	li	a0,1
    5120:	00000097          	auipc	ra,0x0
    5124:	4d6080e7          	jalr	1238(ra) # 55f6 <exit>
    f(s);
    5128:	854a                	mv	a0,s2
    512a:	9482                	jalr	s1
    exit(0);
    512c:	4501                	li	a0,0
    512e:	00000097          	auipc	ra,0x0
    5132:	4c8080e7          	jalr	1224(ra) # 55f6 <exit>
      printf("OK\n");
    5136:	00003517          	auipc	a0,0x3
    513a:	96250513          	add	a0,a0,-1694 # 7a98 <malloc+0x2082>
    513e:	00001097          	auipc	ra,0x1
    5142:	820080e7          	jalr	-2016(ra) # 595e <printf>
    5146:	bf55                	j	50fa <run+0x50>

0000000000005148 <main>:

int
main(int argc, char *argv[])
{
    5148:	c1010113          	add	sp,sp,-1008
    514c:	3e113423          	sd	ra,1000(sp)
    5150:	3e813023          	sd	s0,992(sp)
    5154:	3c913c23          	sd	s1,984(sp)
    5158:	3d213823          	sd	s2,976(sp)
    515c:	3d313423          	sd	s3,968(sp)
    5160:	3d413023          	sd	s4,960(sp)
    5164:	3b513c23          	sd	s5,952(sp)
    5168:	3b613823          	sd	s6,944(sp)
    516c:	1f80                	add	s0,sp,1008
    516e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5170:	4789                	li	a5,2
    5172:	08f50c63          	beq	a0,a5,520a <main+0xc2>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5176:	4785                	li	a5,1
    5178:	12a7c563          	blt	a5,a0,52a2 <main+0x15a>
  char *justone = 0;
    517c:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    517e:	00003797          	auipc	a5,0x3
    5182:	cf278793          	add	a5,a5,-782 # 7e70 <malloc+0x245a>
    5186:	c1040713          	add	a4,s0,-1008
    518a:	00003817          	auipc	a6,0x3
    518e:	08680813          	add	a6,a6,134 # 8210 <malloc+0x27fa>
    5192:	6388                	ld	a0,0(a5)
    5194:	678c                	ld	a1,8(a5)
    5196:	6b90                	ld	a2,16(a5)
    5198:	6f94                	ld	a3,24(a5)
    519a:	e308                	sd	a0,0(a4)
    519c:	e70c                	sd	a1,8(a4)
    519e:	eb10                	sd	a2,16(a4)
    51a0:	ef14                	sd	a3,24(a4)
    51a2:	02078793          	add	a5,a5,32
    51a6:	02070713          	add	a4,a4,32
    51aa:	ff0794e3          	bne	a5,a6,5192 <main+0x4a>
    51ae:	6394                	ld	a3,0(a5)
    51b0:	679c                	ld	a5,8(a5)
    51b2:	e314                	sd	a3,0(a4)
    51b4:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    51b6:	00003517          	auipc	a0,0x3
    51ba:	9a250513          	add	a0,a0,-1630 # 7b58 <malloc+0x2142>
    51be:	00000097          	auipc	ra,0x0
    51c2:	7a0080e7          	jalr	1952(ra) # 595e <printf>
  int free0 = countfree();
    51c6:	00000097          	auipc	ra,0x0
    51ca:	db4080e7          	jalr	-588(ra) # 4f7a <countfree>
    51ce:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51d0:	c1843903          	ld	s2,-1000(s0)
    51d4:	c1040493          	add	s1,s0,-1008
  int fail = 0;
    51d8:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    51da:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    51dc:	10091863          	bnez	s2,52ec <main+0x1a4>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    51e0:	00000097          	auipc	ra,0x0
    51e4:	d9a080e7          	jalr	-614(ra) # 4f7a <countfree>
    51e8:	85aa                	mv	a1,a0
    51ea:	15555263          	bge	a0,s5,532e <main+0x1e6>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    51ee:	8656                	mv	a2,s5
    51f0:	00003517          	auipc	a0,0x3
    51f4:	92050513          	add	a0,a0,-1760 # 7b10 <malloc+0x20fa>
    51f8:	00000097          	auipc	ra,0x0
    51fc:	766080e7          	jalr	1894(ra) # 595e <printf>
    exit(1);
    5200:	4505                	li	a0,1
    5202:	00000097          	auipc	ra,0x0
    5206:	3f4080e7          	jalr	1012(ra) # 55f6 <exit>
    520a:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    520c:	00003597          	auipc	a1,0x3
    5210:	89458593          	add	a1,a1,-1900 # 7aa0 <malloc+0x208a>
    5214:	6488                	ld	a0,8(s1)
    5216:	00000097          	auipc	ra,0x0
    521a:	190080e7          	jalr	400(ra) # 53a6 <strcmp>
    521e:	e125                	bnez	a0,527e <main+0x136>
    continuous = 1;
    5220:	4985                	li	s3,1
  } tests[] = {
    5222:	00003797          	auipc	a5,0x3
    5226:	c4e78793          	add	a5,a5,-946 # 7e70 <malloc+0x245a>
    522a:	c1040713          	add	a4,s0,-1008
    522e:	00003817          	auipc	a6,0x3
    5232:	fe280813          	add	a6,a6,-30 # 8210 <malloc+0x27fa>
    5236:	6388                	ld	a0,0(a5)
    5238:	678c                	ld	a1,8(a5)
    523a:	6b90                	ld	a2,16(a5)
    523c:	6f94                	ld	a3,24(a5)
    523e:	e308                	sd	a0,0(a4)
    5240:	e70c                	sd	a1,8(a4)
    5242:	eb10                	sd	a2,16(a4)
    5244:	ef14                	sd	a3,24(a4)
    5246:	02078793          	add	a5,a5,32
    524a:	02070713          	add	a4,a4,32
    524e:	ff0794e3          	bne	a5,a6,5236 <main+0xee>
    5252:	6394                	ld	a3,0(a5)
    5254:	679c                	ld	a5,8(a5)
    5256:	e314                	sd	a3,0(a4)
    5258:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    525a:	00003517          	auipc	a0,0x3
    525e:	91650513          	add	a0,a0,-1770 # 7b70 <malloc+0x215a>
    5262:	00000097          	auipc	ra,0x0
    5266:	6fc080e7          	jalr	1788(ra) # 595e <printf>
        printf("SOME TESTS FAILED\n");
    526a:	00003a97          	auipc	s5,0x3
    526e:	88ea8a93          	add	s5,s5,-1906 # 7af8 <malloc+0x20e2>
        if(continuous != 2)
    5272:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5274:	00003b17          	auipc	s6,0x3
    5278:	864b0b13          	add	s6,s6,-1948 # 7ad8 <malloc+0x20c2>
    527c:	a0dd                	j	5362 <main+0x21a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    527e:	00003597          	auipc	a1,0x3
    5282:	82a58593          	add	a1,a1,-2006 # 7aa8 <malloc+0x2092>
    5286:	6488                	ld	a0,8(s1)
    5288:	00000097          	auipc	ra,0x0
    528c:	11e080e7          	jalr	286(ra) # 53a6 <strcmp>
    5290:	d949                	beqz	a0,5222 <main+0xda>
  } else if(argc == 2 && argv[1][0] != '-'){
    5292:	0084b983          	ld	s3,8(s1)
    5296:	0009c703          	lbu	a4,0(s3)
    529a:	02d00793          	li	a5,45
    529e:	eef710e3          	bne	a4,a5,517e <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    52a2:	00003517          	auipc	a0,0x3
    52a6:	80e50513          	add	a0,a0,-2034 # 7ab0 <malloc+0x209a>
    52aa:	00000097          	auipc	ra,0x0
    52ae:	6b4080e7          	jalr	1716(ra) # 595e <printf>
    exit(1);
    52b2:	4505                	li	a0,1
    52b4:	00000097          	auipc	ra,0x0
    52b8:	342080e7          	jalr	834(ra) # 55f6 <exit>
          exit(1);
    52bc:	4505                	li	a0,1
    52be:	00000097          	auipc	ra,0x0
    52c2:	338080e7          	jalr	824(ra) # 55f6 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    52c6:	40a905bb          	subw	a1,s2,a0
    52ca:	855a                	mv	a0,s6
    52cc:	00000097          	auipc	ra,0x0
    52d0:	692080e7          	jalr	1682(ra) # 595e <printf>
        if(continuous != 2)
    52d4:	09498763          	beq	s3,s4,5362 <main+0x21a>
          exit(1);
    52d8:	4505                	li	a0,1
    52da:	00000097          	auipc	ra,0x0
    52de:	31c080e7          	jalr	796(ra) # 55f6 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    52e2:	04c1                	add	s1,s1,16
    52e4:	0084b903          	ld	s2,8(s1)
    52e8:	02090463          	beqz	s2,5310 <main+0x1c8>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52ec:	00098963          	beqz	s3,52fe <main+0x1b6>
    52f0:	85ce                	mv	a1,s3
    52f2:	854a                	mv	a0,s2
    52f4:	00000097          	auipc	ra,0x0
    52f8:	0b2080e7          	jalr	178(ra) # 53a6 <strcmp>
    52fc:	f17d                	bnez	a0,52e2 <main+0x19a>
      if(!run(t->f, t->s))
    52fe:	85ca                	mv	a1,s2
    5300:	6088                	ld	a0,0(s1)
    5302:	00000097          	auipc	ra,0x0
    5306:	da8080e7          	jalr	-600(ra) # 50aa <run>
    530a:	fd61                	bnez	a0,52e2 <main+0x19a>
        fail = 1;
    530c:	8a5a                	mv	s4,s6
    530e:	bfd1                	j	52e2 <main+0x19a>
  if(fail){
    5310:	ec0a08e3          	beqz	s4,51e0 <main+0x98>
    printf("SOME TESTS FAILED\n");
    5314:	00002517          	auipc	a0,0x2
    5318:	7e450513          	add	a0,a0,2020 # 7af8 <malloc+0x20e2>
    531c:	00000097          	auipc	ra,0x0
    5320:	642080e7          	jalr	1602(ra) # 595e <printf>
    exit(1);
    5324:	4505                	li	a0,1
    5326:	00000097          	auipc	ra,0x0
    532a:	2d0080e7          	jalr	720(ra) # 55f6 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    532e:	00003517          	auipc	a0,0x3
    5332:	81250513          	add	a0,a0,-2030 # 7b40 <malloc+0x212a>
    5336:	00000097          	auipc	ra,0x0
    533a:	628080e7          	jalr	1576(ra) # 595e <printf>
    exit(0);
    533e:	4501                	li	a0,0
    5340:	00000097          	auipc	ra,0x0
    5344:	2b6080e7          	jalr	694(ra) # 55f6 <exit>
        printf("SOME TESTS FAILED\n");
    5348:	8556                	mv	a0,s5
    534a:	00000097          	auipc	ra,0x0
    534e:	614080e7          	jalr	1556(ra) # 595e <printf>
        if(continuous != 2)
    5352:	f74995e3          	bne	s3,s4,52bc <main+0x174>
      int free1 = countfree();
    5356:	00000097          	auipc	ra,0x0
    535a:	c24080e7          	jalr	-988(ra) # 4f7a <countfree>
      if(free1 < free0){
    535e:	f72544e3          	blt	a0,s2,52c6 <main+0x17e>
      int free0 = countfree();
    5362:	00000097          	auipc	ra,0x0
    5366:	c18080e7          	jalr	-1000(ra) # 4f7a <countfree>
    536a:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    536c:	c1843583          	ld	a1,-1000(s0)
    5370:	d1fd                	beqz	a1,5356 <main+0x20e>
    5372:	c1040493          	add	s1,s0,-1008
        if(!run(t->f, t->s)){
    5376:	6088                	ld	a0,0(s1)
    5378:	00000097          	auipc	ra,0x0
    537c:	d32080e7          	jalr	-718(ra) # 50aa <run>
    5380:	d561                	beqz	a0,5348 <main+0x200>
      for (struct test *t = tests; t->s != 0; t++) {
    5382:	04c1                	add	s1,s1,16
    5384:	648c                	ld	a1,8(s1)
    5386:	f9e5                	bnez	a1,5376 <main+0x22e>
    5388:	b7f9                	j	5356 <main+0x20e>

000000000000538a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    538a:	1141                	add	sp,sp,-16
    538c:	e422                	sd	s0,8(sp)
    538e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5390:	87aa                	mv	a5,a0
    5392:	0585                	add	a1,a1,1
    5394:	0785                	add	a5,a5,1
    5396:	fff5c703          	lbu	a4,-1(a1)
    539a:	fee78fa3          	sb	a4,-1(a5)
    539e:	fb75                	bnez	a4,5392 <strcpy+0x8>
    ;
  return os;
}
    53a0:	6422                	ld	s0,8(sp)
    53a2:	0141                	add	sp,sp,16
    53a4:	8082                	ret

00000000000053a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53a6:	1141                	add	sp,sp,-16
    53a8:	e422                	sd	s0,8(sp)
    53aa:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    53ac:	00054783          	lbu	a5,0(a0)
    53b0:	cb91                	beqz	a5,53c4 <strcmp+0x1e>
    53b2:	0005c703          	lbu	a4,0(a1)
    53b6:	00f71763          	bne	a4,a5,53c4 <strcmp+0x1e>
    p++, q++;
    53ba:	0505                	add	a0,a0,1
    53bc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    53be:	00054783          	lbu	a5,0(a0)
    53c2:	fbe5                	bnez	a5,53b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    53c4:	0005c503          	lbu	a0,0(a1)
}
    53c8:	40a7853b          	subw	a0,a5,a0
    53cc:	6422                	ld	s0,8(sp)
    53ce:	0141                	add	sp,sp,16
    53d0:	8082                	ret

00000000000053d2 <strlen>:

uint
strlen(const char *s)
{
    53d2:	1141                	add	sp,sp,-16
    53d4:	e422                	sd	s0,8(sp)
    53d6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    53d8:	00054783          	lbu	a5,0(a0)
    53dc:	cf91                	beqz	a5,53f8 <strlen+0x26>
    53de:	0505                	add	a0,a0,1
    53e0:	87aa                	mv	a5,a0
    53e2:	86be                	mv	a3,a5
    53e4:	0785                	add	a5,a5,1
    53e6:	fff7c703          	lbu	a4,-1(a5)
    53ea:	ff65                	bnez	a4,53e2 <strlen+0x10>
    53ec:	40a6853b          	subw	a0,a3,a0
    53f0:	2505                	addw	a0,a0,1
    ;
  return n;
}
    53f2:	6422                	ld	s0,8(sp)
    53f4:	0141                	add	sp,sp,16
    53f6:	8082                	ret
  for(n = 0; s[n]; n++)
    53f8:	4501                	li	a0,0
    53fa:	bfe5                	j	53f2 <strlen+0x20>

00000000000053fc <memset>:

void*
memset(void *dst, int c, uint n)
{
    53fc:	1141                	add	sp,sp,-16
    53fe:	e422                	sd	s0,8(sp)
    5400:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5402:	ca19                	beqz	a2,5418 <memset+0x1c>
    5404:	87aa                	mv	a5,a0
    5406:	1602                	sll	a2,a2,0x20
    5408:	9201                	srl	a2,a2,0x20
    540a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    540e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5412:	0785                	add	a5,a5,1
    5414:	fee79de3          	bne	a5,a4,540e <memset+0x12>
  }
  return dst;
}
    5418:	6422                	ld	s0,8(sp)
    541a:	0141                	add	sp,sp,16
    541c:	8082                	ret

000000000000541e <strchr>:

char*
strchr(const char *s, char c)
{
    541e:	1141                	add	sp,sp,-16
    5420:	e422                	sd	s0,8(sp)
    5422:	0800                	add	s0,sp,16
  for(; *s; s++)
    5424:	00054783          	lbu	a5,0(a0)
    5428:	cb99                	beqz	a5,543e <strchr+0x20>
    if(*s == c)
    542a:	00f58763          	beq	a1,a5,5438 <strchr+0x1a>
  for(; *s; s++)
    542e:	0505                	add	a0,a0,1
    5430:	00054783          	lbu	a5,0(a0)
    5434:	fbfd                	bnez	a5,542a <strchr+0xc>
      return (char*)s;
  return 0;
    5436:	4501                	li	a0,0
}
    5438:	6422                	ld	s0,8(sp)
    543a:	0141                	add	sp,sp,16
    543c:	8082                	ret
  return 0;
    543e:	4501                	li	a0,0
    5440:	bfe5                	j	5438 <strchr+0x1a>

0000000000005442 <gets>:

char*
gets(char *buf, int max)
{
    5442:	711d                	add	sp,sp,-96
    5444:	ec86                	sd	ra,88(sp)
    5446:	e8a2                	sd	s0,80(sp)
    5448:	e4a6                	sd	s1,72(sp)
    544a:	e0ca                	sd	s2,64(sp)
    544c:	fc4e                	sd	s3,56(sp)
    544e:	f852                	sd	s4,48(sp)
    5450:	f456                	sd	s5,40(sp)
    5452:	f05a                	sd	s6,32(sp)
    5454:	ec5e                	sd	s7,24(sp)
    5456:	1080                	add	s0,sp,96
    5458:	8baa                	mv	s7,a0
    545a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    545c:	892a                	mv	s2,a0
    545e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5460:	4aa9                	li	s5,10
    5462:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5464:	89a6                	mv	s3,s1
    5466:	2485                	addw	s1,s1,1
    5468:	0344d863          	bge	s1,s4,5498 <gets+0x56>
    cc = read(0, &c, 1);
    546c:	4605                	li	a2,1
    546e:	faf40593          	add	a1,s0,-81
    5472:	4501                	li	a0,0
    5474:	00000097          	auipc	ra,0x0
    5478:	19a080e7          	jalr	410(ra) # 560e <read>
    if(cc < 1)
    547c:	00a05e63          	blez	a0,5498 <gets+0x56>
    buf[i++] = c;
    5480:	faf44783          	lbu	a5,-81(s0)
    5484:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5488:	01578763          	beq	a5,s5,5496 <gets+0x54>
    548c:	0905                	add	s2,s2,1
    548e:	fd679be3          	bne	a5,s6,5464 <gets+0x22>
  for(i=0; i+1 < max; ){
    5492:	89a6                	mv	s3,s1
    5494:	a011                	j	5498 <gets+0x56>
    5496:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5498:	99de                	add	s3,s3,s7
    549a:	00098023          	sb	zero,0(s3)
  return buf;
}
    549e:	855e                	mv	a0,s7
    54a0:	60e6                	ld	ra,88(sp)
    54a2:	6446                	ld	s0,80(sp)
    54a4:	64a6                	ld	s1,72(sp)
    54a6:	6906                	ld	s2,64(sp)
    54a8:	79e2                	ld	s3,56(sp)
    54aa:	7a42                	ld	s4,48(sp)
    54ac:	7aa2                	ld	s5,40(sp)
    54ae:	7b02                	ld	s6,32(sp)
    54b0:	6be2                	ld	s7,24(sp)
    54b2:	6125                	add	sp,sp,96
    54b4:	8082                	ret

00000000000054b6 <stat>:

int
stat(const char *n, struct stat *st)
{
    54b6:	1101                	add	sp,sp,-32
    54b8:	ec06                	sd	ra,24(sp)
    54ba:	e822                	sd	s0,16(sp)
    54bc:	e426                	sd	s1,8(sp)
    54be:	e04a                	sd	s2,0(sp)
    54c0:	1000                	add	s0,sp,32
    54c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    54c4:	4581                	li	a1,0
    54c6:	00000097          	auipc	ra,0x0
    54ca:	170080e7          	jalr	368(ra) # 5636 <open>
  if(fd < 0)
    54ce:	02054563          	bltz	a0,54f8 <stat+0x42>
    54d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    54d4:	85ca                	mv	a1,s2
    54d6:	00000097          	auipc	ra,0x0
    54da:	178080e7          	jalr	376(ra) # 564e <fstat>
    54de:	892a                	mv	s2,a0
  close(fd);
    54e0:	8526                	mv	a0,s1
    54e2:	00000097          	auipc	ra,0x0
    54e6:	13c080e7          	jalr	316(ra) # 561e <close>
  return r;
}
    54ea:	854a                	mv	a0,s2
    54ec:	60e2                	ld	ra,24(sp)
    54ee:	6442                	ld	s0,16(sp)
    54f0:	64a2                	ld	s1,8(sp)
    54f2:	6902                	ld	s2,0(sp)
    54f4:	6105                	add	sp,sp,32
    54f6:	8082                	ret
    return -1;
    54f8:	597d                	li	s2,-1
    54fa:	bfc5                	j	54ea <stat+0x34>

00000000000054fc <atoi>:

int
atoi(const char *s)
{
    54fc:	1141                	add	sp,sp,-16
    54fe:	e422                	sd	s0,8(sp)
    5500:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5502:	00054683          	lbu	a3,0(a0)
    5506:	fd06879b          	addw	a5,a3,-48
    550a:	0ff7f793          	zext.b	a5,a5
    550e:	4625                	li	a2,9
    5510:	02f66863          	bltu	a2,a5,5540 <atoi+0x44>
    5514:	872a                	mv	a4,a0
  n = 0;
    5516:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5518:	0705                	add	a4,a4,1
    551a:	0025179b          	sllw	a5,a0,0x2
    551e:	9fa9                	addw	a5,a5,a0
    5520:	0017979b          	sllw	a5,a5,0x1
    5524:	9fb5                	addw	a5,a5,a3
    5526:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    552a:	00074683          	lbu	a3,0(a4)
    552e:	fd06879b          	addw	a5,a3,-48
    5532:	0ff7f793          	zext.b	a5,a5
    5536:	fef671e3          	bgeu	a2,a5,5518 <atoi+0x1c>
  return n;
}
    553a:	6422                	ld	s0,8(sp)
    553c:	0141                	add	sp,sp,16
    553e:	8082                	ret
  n = 0;
    5540:	4501                	li	a0,0
    5542:	bfe5                	j	553a <atoi+0x3e>

0000000000005544 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5544:	1141                	add	sp,sp,-16
    5546:	e422                	sd	s0,8(sp)
    5548:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    554a:	02b57463          	bgeu	a0,a1,5572 <memmove+0x2e>
    while(n-- > 0)
    554e:	00c05f63          	blez	a2,556c <memmove+0x28>
    5552:	1602                	sll	a2,a2,0x20
    5554:	9201                	srl	a2,a2,0x20
    5556:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    555a:	872a                	mv	a4,a0
      *dst++ = *src++;
    555c:	0585                	add	a1,a1,1
    555e:	0705                	add	a4,a4,1
    5560:	fff5c683          	lbu	a3,-1(a1)
    5564:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5568:	fee79ae3          	bne	a5,a4,555c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    556c:	6422                	ld	s0,8(sp)
    556e:	0141                	add	sp,sp,16
    5570:	8082                	ret
    dst += n;
    5572:	00c50733          	add	a4,a0,a2
    src += n;
    5576:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5578:	fec05ae3          	blez	a2,556c <memmove+0x28>
    557c:	fff6079b          	addw	a5,a2,-1 # 2fff <dirtest+0x85>
    5580:	1782                	sll	a5,a5,0x20
    5582:	9381                	srl	a5,a5,0x20
    5584:	fff7c793          	not	a5,a5
    5588:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    558a:	15fd                	add	a1,a1,-1
    558c:	177d                	add	a4,a4,-1
    558e:	0005c683          	lbu	a3,0(a1)
    5592:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5596:	fee79ae3          	bne	a5,a4,558a <memmove+0x46>
    559a:	bfc9                	j	556c <memmove+0x28>

000000000000559c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    559c:	1141                	add	sp,sp,-16
    559e:	e422                	sd	s0,8(sp)
    55a0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    55a2:	ca05                	beqz	a2,55d2 <memcmp+0x36>
    55a4:	fff6069b          	addw	a3,a2,-1
    55a8:	1682                	sll	a3,a3,0x20
    55aa:	9281                	srl	a3,a3,0x20
    55ac:	0685                	add	a3,a3,1
    55ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    55b0:	00054783          	lbu	a5,0(a0)
    55b4:	0005c703          	lbu	a4,0(a1)
    55b8:	00e79863          	bne	a5,a4,55c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    55bc:	0505                	add	a0,a0,1
    p2++;
    55be:	0585                	add	a1,a1,1
  while (n-- > 0) {
    55c0:	fed518e3          	bne	a0,a3,55b0 <memcmp+0x14>
  }
  return 0;
    55c4:	4501                	li	a0,0
    55c6:	a019                	j	55cc <memcmp+0x30>
      return *p1 - *p2;
    55c8:	40e7853b          	subw	a0,a5,a4
}
    55cc:	6422                	ld	s0,8(sp)
    55ce:	0141                	add	sp,sp,16
    55d0:	8082                	ret
  return 0;
    55d2:	4501                	li	a0,0
    55d4:	bfe5                	j	55cc <memcmp+0x30>

00000000000055d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    55d6:	1141                	add	sp,sp,-16
    55d8:	e406                	sd	ra,8(sp)
    55da:	e022                	sd	s0,0(sp)
    55dc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    55de:	00000097          	auipc	ra,0x0
    55e2:	f66080e7          	jalr	-154(ra) # 5544 <memmove>
}
    55e6:	60a2                	ld	ra,8(sp)
    55e8:	6402                	ld	s0,0(sp)
    55ea:	0141                	add	sp,sp,16
    55ec:	8082                	ret

00000000000055ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    55ee:	4885                	li	a7,1
 ecall
    55f0:	00000073          	ecall
 ret
    55f4:	8082                	ret

00000000000055f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    55f6:	4889                	li	a7,2
 ecall
    55f8:	00000073          	ecall
 ret
    55fc:	8082                	ret

00000000000055fe <wait>:
.global wait
wait:
 li a7, SYS_wait
    55fe:	488d                	li	a7,3
 ecall
    5600:	00000073          	ecall
 ret
    5604:	8082                	ret

0000000000005606 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5606:	4891                	li	a7,4
 ecall
    5608:	00000073          	ecall
 ret
    560c:	8082                	ret

000000000000560e <read>:
.global read
read:
 li a7, SYS_read
    560e:	4895                	li	a7,5
 ecall
    5610:	00000073          	ecall
 ret
    5614:	8082                	ret

0000000000005616 <write>:
.global write
write:
 li a7, SYS_write
    5616:	48c1                	li	a7,16
 ecall
    5618:	00000073          	ecall
 ret
    561c:	8082                	ret

000000000000561e <close>:
.global close
close:
 li a7, SYS_close
    561e:	48d5                	li	a7,21
 ecall
    5620:	00000073          	ecall
 ret
    5624:	8082                	ret

0000000000005626 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5626:	4899                	li	a7,6
 ecall
    5628:	00000073          	ecall
 ret
    562c:	8082                	ret

000000000000562e <exec>:
.global exec
exec:
 li a7, SYS_exec
    562e:	489d                	li	a7,7
 ecall
    5630:	00000073          	ecall
 ret
    5634:	8082                	ret

0000000000005636 <open>:
.global open
open:
 li a7, SYS_open
    5636:	48bd                	li	a7,15
 ecall
    5638:	00000073          	ecall
 ret
    563c:	8082                	ret

000000000000563e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    563e:	48c5                	li	a7,17
 ecall
    5640:	00000073          	ecall
 ret
    5644:	8082                	ret

0000000000005646 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5646:	48c9                	li	a7,18
 ecall
    5648:	00000073          	ecall
 ret
    564c:	8082                	ret

000000000000564e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    564e:	48a1                	li	a7,8
 ecall
    5650:	00000073          	ecall
 ret
    5654:	8082                	ret

0000000000005656 <link>:
.global link
link:
 li a7, SYS_link
    5656:	48cd                	li	a7,19
 ecall
    5658:	00000073          	ecall
 ret
    565c:	8082                	ret

000000000000565e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    565e:	48d1                	li	a7,20
 ecall
    5660:	00000073          	ecall
 ret
    5664:	8082                	ret

0000000000005666 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5666:	48a5                	li	a7,9
 ecall
    5668:	00000073          	ecall
 ret
    566c:	8082                	ret

000000000000566e <dup>:
.global dup
dup:
 li a7, SYS_dup
    566e:	48a9                	li	a7,10
 ecall
    5670:	00000073          	ecall
 ret
    5674:	8082                	ret

0000000000005676 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5676:	48ad                	li	a7,11
 ecall
    5678:	00000073          	ecall
 ret
    567c:	8082                	ret

000000000000567e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    567e:	48b1                	li	a7,12
 ecall
    5680:	00000073          	ecall
 ret
    5684:	8082                	ret

0000000000005686 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5686:	48b5                	li	a7,13
 ecall
    5688:	00000073          	ecall
 ret
    568c:	8082                	ret

000000000000568e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    568e:	48b9                	li	a7,14
 ecall
    5690:	00000073          	ecall
 ret
    5694:	8082                	ret

0000000000005696 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5696:	1101                	add	sp,sp,-32
    5698:	ec06                	sd	ra,24(sp)
    569a:	e822                	sd	s0,16(sp)
    569c:	1000                	add	s0,sp,32
    569e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    56a2:	4605                	li	a2,1
    56a4:	fef40593          	add	a1,s0,-17
    56a8:	00000097          	auipc	ra,0x0
    56ac:	f6e080e7          	jalr	-146(ra) # 5616 <write>
}
    56b0:	60e2                	ld	ra,24(sp)
    56b2:	6442                	ld	s0,16(sp)
    56b4:	6105                	add	sp,sp,32
    56b6:	8082                	ret

00000000000056b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    56b8:	7139                	add	sp,sp,-64
    56ba:	fc06                	sd	ra,56(sp)
    56bc:	f822                	sd	s0,48(sp)
    56be:	f426                	sd	s1,40(sp)
    56c0:	f04a                	sd	s2,32(sp)
    56c2:	ec4e                	sd	s3,24(sp)
    56c4:	0080                	add	s0,sp,64
    56c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    56c8:	c299                	beqz	a3,56ce <printint+0x16>
    56ca:	0805c963          	bltz	a1,575c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    56ce:	2581                	sext.w	a1,a1
  neg = 0;
    56d0:	4881                	li	a7,0
    56d2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    56d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    56d8:	2601                	sext.w	a2,a2
    56da:	00003517          	auipc	a0,0x3
    56de:	ba650513          	add	a0,a0,-1114 # 8280 <digits>
    56e2:	883a                	mv	a6,a4
    56e4:	2705                	addw	a4,a4,1
    56e6:	02c5f7bb          	remuw	a5,a1,a2
    56ea:	1782                	sll	a5,a5,0x20
    56ec:	9381                	srl	a5,a5,0x20
    56ee:	97aa                	add	a5,a5,a0
    56f0:	0007c783          	lbu	a5,0(a5)
    56f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    56f8:	0005879b          	sext.w	a5,a1
    56fc:	02c5d5bb          	divuw	a1,a1,a2
    5700:	0685                	add	a3,a3,1
    5702:	fec7f0e3          	bgeu	a5,a2,56e2 <printint+0x2a>
  if(neg)
    5706:	00088c63          	beqz	a7,571e <printint+0x66>
    buf[i++] = '-';
    570a:	fd070793          	add	a5,a4,-48
    570e:	00878733          	add	a4,a5,s0
    5712:	02d00793          	li	a5,45
    5716:	fef70823          	sb	a5,-16(a4)
    571a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    571e:	02e05863          	blez	a4,574e <printint+0x96>
    5722:	fc040793          	add	a5,s0,-64
    5726:	00e78933          	add	s2,a5,a4
    572a:	fff78993          	add	s3,a5,-1
    572e:	99ba                	add	s3,s3,a4
    5730:	377d                	addw	a4,a4,-1
    5732:	1702                	sll	a4,a4,0x20
    5734:	9301                	srl	a4,a4,0x20
    5736:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    573a:	fff94583          	lbu	a1,-1(s2)
    573e:	8526                	mv	a0,s1
    5740:	00000097          	auipc	ra,0x0
    5744:	f56080e7          	jalr	-170(ra) # 5696 <putc>
  while(--i >= 0)
    5748:	197d                	add	s2,s2,-1
    574a:	ff3918e3          	bne	s2,s3,573a <printint+0x82>
}
    574e:	70e2                	ld	ra,56(sp)
    5750:	7442                	ld	s0,48(sp)
    5752:	74a2                	ld	s1,40(sp)
    5754:	7902                	ld	s2,32(sp)
    5756:	69e2                	ld	s3,24(sp)
    5758:	6121                	add	sp,sp,64
    575a:	8082                	ret
    x = -xx;
    575c:	40b005bb          	negw	a1,a1
    neg = 1;
    5760:	4885                	li	a7,1
    x = -xx;
    5762:	bf85                	j	56d2 <printint+0x1a>

0000000000005764 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5764:	715d                	add	sp,sp,-80
    5766:	e486                	sd	ra,72(sp)
    5768:	e0a2                	sd	s0,64(sp)
    576a:	fc26                	sd	s1,56(sp)
    576c:	f84a                	sd	s2,48(sp)
    576e:	f44e                	sd	s3,40(sp)
    5770:	f052                	sd	s4,32(sp)
    5772:	ec56                	sd	s5,24(sp)
    5774:	e85a                	sd	s6,16(sp)
    5776:	e45e                	sd	s7,8(sp)
    5778:	e062                	sd	s8,0(sp)
    577a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    577c:	0005c903          	lbu	s2,0(a1)
    5780:	18090c63          	beqz	s2,5918 <vprintf+0x1b4>
    5784:	8aaa                	mv	s5,a0
    5786:	8bb2                	mv	s7,a2
    5788:	00158493          	add	s1,a1,1
  state = 0;
    578c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    578e:	02500a13          	li	s4,37
    5792:	4b55                	li	s6,21
    5794:	a839                	j	57b2 <vprintf+0x4e>
        putc(fd, c);
    5796:	85ca                	mv	a1,s2
    5798:	8556                	mv	a0,s5
    579a:	00000097          	auipc	ra,0x0
    579e:	efc080e7          	jalr	-260(ra) # 5696 <putc>
    57a2:	a019                	j	57a8 <vprintf+0x44>
    } else if(state == '%'){
    57a4:	01498d63          	beq	s3,s4,57be <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    57a8:	0485                	add	s1,s1,1
    57aa:	fff4c903          	lbu	s2,-1(s1)
    57ae:	16090563          	beqz	s2,5918 <vprintf+0x1b4>
    if(state == 0){
    57b2:	fe0999e3          	bnez	s3,57a4 <vprintf+0x40>
      if(c == '%'){
    57b6:	ff4910e3          	bne	s2,s4,5796 <vprintf+0x32>
        state = '%';
    57ba:	89d2                	mv	s3,s4
    57bc:	b7f5                	j	57a8 <vprintf+0x44>
      if(c == 'd'){
    57be:	13490263          	beq	s2,s4,58e2 <vprintf+0x17e>
    57c2:	f9d9079b          	addw	a5,s2,-99
    57c6:	0ff7f793          	zext.b	a5,a5
    57ca:	12fb6563          	bltu	s6,a5,58f4 <vprintf+0x190>
    57ce:	f9d9079b          	addw	a5,s2,-99
    57d2:	0ff7f713          	zext.b	a4,a5
    57d6:	10eb6f63          	bltu	s6,a4,58f4 <vprintf+0x190>
    57da:	00271793          	sll	a5,a4,0x2
    57de:	00003717          	auipc	a4,0x3
    57e2:	a4a70713          	add	a4,a4,-1462 # 8228 <malloc+0x2812>
    57e6:	97ba                	add	a5,a5,a4
    57e8:	439c                	lw	a5,0(a5)
    57ea:	97ba                	add	a5,a5,a4
    57ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    57ee:	008b8913          	add	s2,s7,8
    57f2:	4685                	li	a3,1
    57f4:	4629                	li	a2,10
    57f6:	000ba583          	lw	a1,0(s7)
    57fa:	8556                	mv	a0,s5
    57fc:	00000097          	auipc	ra,0x0
    5800:	ebc080e7          	jalr	-324(ra) # 56b8 <printint>
    5804:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5806:	4981                	li	s3,0
    5808:	b745                	j	57a8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    580a:	008b8913          	add	s2,s7,8
    580e:	4681                	li	a3,0
    5810:	4629                	li	a2,10
    5812:	000ba583          	lw	a1,0(s7)
    5816:	8556                	mv	a0,s5
    5818:	00000097          	auipc	ra,0x0
    581c:	ea0080e7          	jalr	-352(ra) # 56b8 <printint>
    5820:	8bca                	mv	s7,s2
      state = 0;
    5822:	4981                	li	s3,0
    5824:	b751                	j	57a8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5826:	008b8913          	add	s2,s7,8
    582a:	4681                	li	a3,0
    582c:	4641                	li	a2,16
    582e:	000ba583          	lw	a1,0(s7)
    5832:	8556                	mv	a0,s5
    5834:	00000097          	auipc	ra,0x0
    5838:	e84080e7          	jalr	-380(ra) # 56b8 <printint>
    583c:	8bca                	mv	s7,s2
      state = 0;
    583e:	4981                	li	s3,0
    5840:	b7a5                	j	57a8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    5842:	008b8c13          	add	s8,s7,8
    5846:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    584a:	03000593          	li	a1,48
    584e:	8556                	mv	a0,s5
    5850:	00000097          	auipc	ra,0x0
    5854:	e46080e7          	jalr	-442(ra) # 5696 <putc>
  putc(fd, 'x');
    5858:	07800593          	li	a1,120
    585c:	8556                	mv	a0,s5
    585e:	00000097          	auipc	ra,0x0
    5862:	e38080e7          	jalr	-456(ra) # 5696 <putc>
    5866:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5868:	00003b97          	auipc	s7,0x3
    586c:	a18b8b93          	add	s7,s7,-1512 # 8280 <digits>
    5870:	03c9d793          	srl	a5,s3,0x3c
    5874:	97de                	add	a5,a5,s7
    5876:	0007c583          	lbu	a1,0(a5)
    587a:	8556                	mv	a0,s5
    587c:	00000097          	auipc	ra,0x0
    5880:	e1a080e7          	jalr	-486(ra) # 5696 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5884:	0992                	sll	s3,s3,0x4
    5886:	397d                	addw	s2,s2,-1
    5888:	fe0914e3          	bnez	s2,5870 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    588c:	8be2                	mv	s7,s8
      state = 0;
    588e:	4981                	li	s3,0
    5890:	bf21                	j	57a8 <vprintf+0x44>
        s = va_arg(ap, char*);
    5892:	008b8993          	add	s3,s7,8
    5896:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    589a:	02090163          	beqz	s2,58bc <vprintf+0x158>
        while(*s != 0){
    589e:	00094583          	lbu	a1,0(s2)
    58a2:	c9a5                	beqz	a1,5912 <vprintf+0x1ae>
          putc(fd, *s);
    58a4:	8556                	mv	a0,s5
    58a6:	00000097          	auipc	ra,0x0
    58aa:	df0080e7          	jalr	-528(ra) # 5696 <putc>
          s++;
    58ae:	0905                	add	s2,s2,1
        while(*s != 0){
    58b0:	00094583          	lbu	a1,0(s2)
    58b4:	f9e5                	bnez	a1,58a4 <vprintf+0x140>
        s = va_arg(ap, char*);
    58b6:	8bce                	mv	s7,s3
      state = 0;
    58b8:	4981                	li	s3,0
    58ba:	b5fd                	j	57a8 <vprintf+0x44>
          s = "(null)";
    58bc:	00003917          	auipc	s2,0x3
    58c0:	96490913          	add	s2,s2,-1692 # 8220 <malloc+0x280a>
        while(*s != 0){
    58c4:	02800593          	li	a1,40
    58c8:	bff1                	j	58a4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    58ca:	008b8913          	add	s2,s7,8
    58ce:	000bc583          	lbu	a1,0(s7)
    58d2:	8556                	mv	a0,s5
    58d4:	00000097          	auipc	ra,0x0
    58d8:	dc2080e7          	jalr	-574(ra) # 5696 <putc>
    58dc:	8bca                	mv	s7,s2
      state = 0;
    58de:	4981                	li	s3,0
    58e0:	b5e1                	j	57a8 <vprintf+0x44>
        putc(fd, c);
    58e2:	02500593          	li	a1,37
    58e6:	8556                	mv	a0,s5
    58e8:	00000097          	auipc	ra,0x0
    58ec:	dae080e7          	jalr	-594(ra) # 5696 <putc>
      state = 0;
    58f0:	4981                	li	s3,0
    58f2:	bd5d                	j	57a8 <vprintf+0x44>
        putc(fd, '%');
    58f4:	02500593          	li	a1,37
    58f8:	8556                	mv	a0,s5
    58fa:	00000097          	auipc	ra,0x0
    58fe:	d9c080e7          	jalr	-612(ra) # 5696 <putc>
        putc(fd, c);
    5902:	85ca                	mv	a1,s2
    5904:	8556                	mv	a0,s5
    5906:	00000097          	auipc	ra,0x0
    590a:	d90080e7          	jalr	-624(ra) # 5696 <putc>
      state = 0;
    590e:	4981                	li	s3,0
    5910:	bd61                	j	57a8 <vprintf+0x44>
        s = va_arg(ap, char*);
    5912:	8bce                	mv	s7,s3
      state = 0;
    5914:	4981                	li	s3,0
    5916:	bd49                	j	57a8 <vprintf+0x44>
    }
  }
}
    5918:	60a6                	ld	ra,72(sp)
    591a:	6406                	ld	s0,64(sp)
    591c:	74e2                	ld	s1,56(sp)
    591e:	7942                	ld	s2,48(sp)
    5920:	79a2                	ld	s3,40(sp)
    5922:	7a02                	ld	s4,32(sp)
    5924:	6ae2                	ld	s5,24(sp)
    5926:	6b42                	ld	s6,16(sp)
    5928:	6ba2                	ld	s7,8(sp)
    592a:	6c02                	ld	s8,0(sp)
    592c:	6161                	add	sp,sp,80
    592e:	8082                	ret

0000000000005930 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5930:	715d                	add	sp,sp,-80
    5932:	ec06                	sd	ra,24(sp)
    5934:	e822                	sd	s0,16(sp)
    5936:	1000                	add	s0,sp,32
    5938:	e010                	sd	a2,0(s0)
    593a:	e414                	sd	a3,8(s0)
    593c:	e818                	sd	a4,16(s0)
    593e:	ec1c                	sd	a5,24(s0)
    5940:	03043023          	sd	a6,32(s0)
    5944:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5948:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    594c:	8622                	mv	a2,s0
    594e:	00000097          	auipc	ra,0x0
    5952:	e16080e7          	jalr	-490(ra) # 5764 <vprintf>
}
    5956:	60e2                	ld	ra,24(sp)
    5958:	6442                	ld	s0,16(sp)
    595a:	6161                	add	sp,sp,80
    595c:	8082                	ret

000000000000595e <printf>:

void
printf(const char *fmt, ...)
{
    595e:	711d                	add	sp,sp,-96
    5960:	ec06                	sd	ra,24(sp)
    5962:	e822                	sd	s0,16(sp)
    5964:	1000                	add	s0,sp,32
    5966:	e40c                	sd	a1,8(s0)
    5968:	e810                	sd	a2,16(s0)
    596a:	ec14                	sd	a3,24(s0)
    596c:	f018                	sd	a4,32(s0)
    596e:	f41c                	sd	a5,40(s0)
    5970:	03043823          	sd	a6,48(s0)
    5974:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5978:	00840613          	add	a2,s0,8
    597c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5980:	85aa                	mv	a1,a0
    5982:	4505                	li	a0,1
    5984:	00000097          	auipc	ra,0x0
    5988:	de0080e7          	jalr	-544(ra) # 5764 <vprintf>
}
    598c:	60e2                	ld	ra,24(sp)
    598e:	6442                	ld	s0,16(sp)
    5990:	6125                	add	sp,sp,96
    5992:	8082                	ret

0000000000005994 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5994:	1141                	add	sp,sp,-16
    5996:	e422                	sd	s0,8(sp)
    5998:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    599a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    599e:	00003797          	auipc	a5,0x3
    59a2:	90a7b783          	ld	a5,-1782(a5) # 82a8 <freep>
    59a6:	a02d                	j	59d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    59a8:	4618                	lw	a4,8(a2)
    59aa:	9f2d                	addw	a4,a4,a1
    59ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    59b0:	6398                	ld	a4,0(a5)
    59b2:	6310                	ld	a2,0(a4)
    59b4:	a83d                	j	59f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    59b6:	ff852703          	lw	a4,-8(a0)
    59ba:	9f31                	addw	a4,a4,a2
    59bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    59be:	ff053683          	ld	a3,-16(a0)
    59c2:	a091                	j	5a06 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59c4:	6398                	ld	a4,0(a5)
    59c6:	00e7e463          	bltu	a5,a4,59ce <free+0x3a>
    59ca:	00e6ea63          	bltu	a3,a4,59de <free+0x4a>
{
    59ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59d0:	fed7fae3          	bgeu	a5,a3,59c4 <free+0x30>
    59d4:	6398                	ld	a4,0(a5)
    59d6:	00e6e463          	bltu	a3,a4,59de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59da:	fee7eae3          	bltu	a5,a4,59ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    59de:	ff852583          	lw	a1,-8(a0)
    59e2:	6390                	ld	a2,0(a5)
    59e4:	02059813          	sll	a6,a1,0x20
    59e8:	01c85713          	srl	a4,a6,0x1c
    59ec:	9736                	add	a4,a4,a3
    59ee:	fae60de3          	beq	a2,a4,59a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    59f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    59f6:	4790                	lw	a2,8(a5)
    59f8:	02061593          	sll	a1,a2,0x20
    59fc:	01c5d713          	srl	a4,a1,0x1c
    5a00:	973e                	add	a4,a4,a5
    5a02:	fae68ae3          	beq	a3,a4,59b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5a06:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5a08:	00003717          	auipc	a4,0x3
    5a0c:	8af73023          	sd	a5,-1888(a4) # 82a8 <freep>
}
    5a10:	6422                	ld	s0,8(sp)
    5a12:	0141                	add	sp,sp,16
    5a14:	8082                	ret

0000000000005a16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a16:	7139                	add	sp,sp,-64
    5a18:	fc06                	sd	ra,56(sp)
    5a1a:	f822                	sd	s0,48(sp)
    5a1c:	f426                	sd	s1,40(sp)
    5a1e:	f04a                	sd	s2,32(sp)
    5a20:	ec4e                	sd	s3,24(sp)
    5a22:	e852                	sd	s4,16(sp)
    5a24:	e456                	sd	s5,8(sp)
    5a26:	e05a                	sd	s6,0(sp)
    5a28:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5a2a:	02051493          	sll	s1,a0,0x20
    5a2e:	9081                	srl	s1,s1,0x20
    5a30:	04bd                	add	s1,s1,15
    5a32:	8091                	srl	s1,s1,0x4
    5a34:	0014899b          	addw	s3,s1,1
    5a38:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    5a3a:	00003517          	auipc	a0,0x3
    5a3e:	86e53503          	ld	a0,-1938(a0) # 82a8 <freep>
    5a42:	c515                	beqz	a0,5a6e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5a44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5a46:	4798                	lw	a4,8(a5)
    5a48:	02977f63          	bgeu	a4,s1,5a86 <malloc+0x70>
  if(nu < 4096)
    5a4c:	8a4e                	mv	s4,s3
    5a4e:	0009871b          	sext.w	a4,s3
    5a52:	6685                	lui	a3,0x1
    5a54:	00d77363          	bgeu	a4,a3,5a5a <malloc+0x44>
    5a58:	6a05                	lui	s4,0x1
    5a5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5a5e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5a62:	00003917          	auipc	s2,0x3
    5a66:	84690913          	add	s2,s2,-1978 # 82a8 <freep>
  if(p == (char*)-1)
    5a6a:	5afd                	li	s5,-1
    5a6c:	a895                	j	5ae0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5a6e:	00009797          	auipc	a5,0x9
    5a72:	05a78793          	add	a5,a5,90 # eac8 <base>
    5a76:	00003717          	auipc	a4,0x3
    5a7a:	82f73923          	sd	a5,-1998(a4) # 82a8 <freep>
    5a7e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5a80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5a84:	b7e1                	j	5a4c <malloc+0x36>
      if(p->s.size == nunits)
    5a86:	02e48c63          	beq	s1,a4,5abe <malloc+0xa8>
        p->s.size -= nunits;
    5a8a:	4137073b          	subw	a4,a4,s3
    5a8e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5a90:	02071693          	sll	a3,a4,0x20
    5a94:	01c6d713          	srl	a4,a3,0x1c
    5a98:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5a9a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5a9e:	00003717          	auipc	a4,0x3
    5aa2:	80a73523          	sd	a0,-2038(a4) # 82a8 <freep>
      return (void*)(p + 1);
    5aa6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5aaa:	70e2                	ld	ra,56(sp)
    5aac:	7442                	ld	s0,48(sp)
    5aae:	74a2                	ld	s1,40(sp)
    5ab0:	7902                	ld	s2,32(sp)
    5ab2:	69e2                	ld	s3,24(sp)
    5ab4:	6a42                	ld	s4,16(sp)
    5ab6:	6aa2                	ld	s5,8(sp)
    5ab8:	6b02                	ld	s6,0(sp)
    5aba:	6121                	add	sp,sp,64
    5abc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5abe:	6398                	ld	a4,0(a5)
    5ac0:	e118                	sd	a4,0(a0)
    5ac2:	bff1                	j	5a9e <malloc+0x88>
  hp->s.size = nu;
    5ac4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5ac8:	0541                	add	a0,a0,16
    5aca:	00000097          	auipc	ra,0x0
    5ace:	eca080e7          	jalr	-310(ra) # 5994 <free>
  return freep;
    5ad2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5ad6:	d971                	beqz	a0,5aaa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ad8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ada:	4798                	lw	a4,8(a5)
    5adc:	fa9775e3          	bgeu	a4,s1,5a86 <malloc+0x70>
    if(p == freep)
    5ae0:	00093703          	ld	a4,0(s2)
    5ae4:	853e                	mv	a0,a5
    5ae6:	fef719e3          	bne	a4,a5,5ad8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5aea:	8552                	mv	a0,s4
    5aec:	00000097          	auipc	ra,0x0
    5af0:	b92080e7          	jalr	-1134(ra) # 567e <sbrk>
  if(p == (char*)-1)
    5af4:	fd5518e3          	bne	a0,s5,5ac4 <malloc+0xae>
        return 0;
    5af8:	4501                	li	a0,0
    5afa:	bf45                	j	5aaa <malloc+0x94>
