
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
      14:	628080e7          	jalr	1576(ra) # 5638 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	616080e7          	jalr	1558(ra) # 5638 <open>
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
      42:	aca50513          	add	a0,a0,-1334 # 5b08 <malloc+0xe8>
      46:	00006097          	auipc	ra,0x6
      4a:	922080e7          	jalr	-1758(ra) # 5968 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	5a8080e7          	jalr	1448(ra) # 55f8 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	36878793          	add	a5,a5,872 # 93c0 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	a7068693          	add	a3,a3,-1424 # bad0 <buf>
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
      84:	aa850513          	add	a0,a0,-1368 # 5b28 <malloc+0x108>
      88:	00006097          	auipc	ra,0x6
      8c:	8e0080e7          	jalr	-1824(ra) # 5968 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	566080e7          	jalr	1382(ra) # 55f8 <exit>

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
      ac:	a9850513          	add	a0,a0,-1384 # 5b40 <malloc+0x120>
      b0:	00005097          	auipc	ra,0x5
      b4:	588080e7          	jalr	1416(ra) # 5638 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	564080e7          	jalr	1380(ra) # 5620 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	a9a50513          	add	a0,a0,-1382 # 5b60 <malloc+0x140>
      ce:	00005097          	auipc	ra,0x5
      d2:	56a080e7          	jalr	1386(ra) # 5638 <open>
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
      ea:	a6250513          	add	a0,a0,-1438 # 5b48 <malloc+0x128>
      ee:	00006097          	auipc	ra,0x6
      f2:	87a080e7          	jalr	-1926(ra) # 5968 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	500080e7          	jalr	1280(ra) # 55f8 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	a6e50513          	add	a0,a0,-1426 # 5b70 <malloc+0x150>
     10a:	00006097          	auipc	ra,0x6
     10e:	85e080e7          	jalr	-1954(ra) # 5968 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	4e4080e7          	jalr	1252(ra) # 55f8 <exit>

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
     130:	a6c50513          	add	a0,a0,-1428 # 5b98 <malloc+0x178>
     134:	00005097          	auipc	ra,0x5
     138:	514080e7          	jalr	1300(ra) # 5648 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	a5850513          	add	a0,a0,-1448 # 5b98 <malloc+0x178>
     148:	00005097          	auipc	ra,0x5
     14c:	4f0080e7          	jalr	1264(ra) # 5638 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	a5458593          	add	a1,a1,-1452 # 5ba8 <malloc+0x188>
     15c:	00005097          	auipc	ra,0x5
     160:	4bc080e7          	jalr	1212(ra) # 5618 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	a3050513          	add	a0,a0,-1488 # 5b98 <malloc+0x178>
     170:	00005097          	auipc	ra,0x5
     174:	4c8080e7          	jalr	1224(ra) # 5638 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	a3458593          	add	a1,a1,-1484 # 5bb0 <malloc+0x190>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	492080e7          	jalr	1170(ra) # 5618 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	a0450513          	add	a0,a0,-1532 # 5b98 <malloc+0x178>
     19c:	00005097          	auipc	ra,0x5
     1a0:	4ac080e7          	jalr	1196(ra) # 5648 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	47a080e7          	jalr	1146(ra) # 5620 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	470080e7          	jalr	1136(ra) # 5620 <close>
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
     1ce:	9ee50513          	add	a0,a0,-1554 # 5bb8 <malloc+0x198>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	796080e7          	jalr	1942(ra) # 5968 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	41c080e7          	jalr	1052(ra) # 55f8 <exit>

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
     214:	428080e7          	jalr	1064(ra) # 5638 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	408080e7          	jalr	1032(ra) # 5620 <close>
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
     24a:	402080e7          	jalr	1026(ra) # 5648 <unlink>
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
     280:	96450513          	add	a0,a0,-1692 # 5be0 <malloc+0x1c0>
     284:	00005097          	auipc	ra,0x5
     288:	3c4080e7          	jalr	964(ra) # 5648 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	950a8a93          	add	s5,s5,-1712 # 5be0 <malloc+0x1c0>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	838a0a13          	add	s4,s4,-1992 # bad0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <subdir+0x177>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	38c080e7          	jalr	908(ra) # 5638 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	35a080e7          	jalr	858(ra) # 5618 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	346080e7          	jalr	838(ra) # 5618 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	340080e7          	jalr	832(ra) # 5620 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	35e080e7          	jalr	862(ra) # 5648 <unlink>
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
     316:	8de50513          	add	a0,a0,-1826 # 5bf0 <malloc+0x1d0>
     31a:	00005097          	auipc	ra,0x5
     31e:	64e080e7          	jalr	1614(ra) # 5968 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	2d4080e7          	jalr	724(ra) # 55f8 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	8dc50513          	add	a0,a0,-1828 # 5c10 <malloc+0x1f0>
     33c:	00005097          	auipc	ra,0x5
     340:	62c080e7          	jalr	1580(ra) # 5968 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	2b2080e7          	jalr	690(ra) # 55f8 <exit>

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
     374:	8b8a0a13          	add	s4,s4,-1864 # 5c28 <malloc+0x208>
    uint64 addr = addrs[ai];
     378:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37c:	20100593          	li	a1,513
     380:	8552                	mv	a0,s4
     382:	00005097          	auipc	ra,0x5
     386:	2b6080e7          	jalr	694(ra) # 5638 <open>
     38a:	84aa                	mv	s1,a0
    if(fd < 0){
     38c:	08054863          	bltz	a0,41c <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     390:	6609                	lui	a2,0x2
     392:	85ce                	mv	a1,s3
     394:	00005097          	auipc	ra,0x5
     398:	284080e7          	jalr	644(ra) # 5618 <write>
    if(n >= 0){
     39c:	08055d63          	bgez	a0,436 <copyin+0xe8>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	27e080e7          	jalr	638(ra) # 5620 <close>
    unlink("copyin1");
     3aa:	8552                	mv	a0,s4
     3ac:	00005097          	auipc	ra,0x5
     3b0:	29c080e7          	jalr	668(ra) # 5648 <unlink>
    n = write(1, (char*)addr, 8192);
     3b4:	6609                	lui	a2,0x2
     3b6:	85ce                	mv	a1,s3
     3b8:	4505                	li	a0,1
     3ba:	00005097          	auipc	ra,0x5
     3be:	25e080e7          	jalr	606(ra) # 5618 <write>
    if(n > 0){
     3c2:	08a04963          	bgtz	a0,454 <copyin+0x106>
    if(pipe(fds) < 0){
     3c6:	fb840513          	add	a0,s0,-72
     3ca:	00005097          	auipc	ra,0x5
     3ce:	23e080e7          	jalr	574(ra) # 5608 <pipe>
     3d2:	0a054063          	bltz	a0,472 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d6:	6609                	lui	a2,0x2
     3d8:	85ce                	mv	a1,s3
     3da:	fbc42503          	lw	a0,-68(s0)
     3de:	00005097          	auipc	ra,0x5
     3e2:	23a080e7          	jalr	570(ra) # 5618 <write>
    if(n > 0){
     3e6:	0aa04363          	bgtz	a0,48c <copyin+0x13e>
    close(fds[0]);
     3ea:	fb842503          	lw	a0,-72(s0)
     3ee:	00005097          	auipc	ra,0x5
     3f2:	232080e7          	jalr	562(ra) # 5620 <close>
    close(fds[1]);
     3f6:	fbc42503          	lw	a0,-68(s0)
     3fa:	00005097          	auipc	ra,0x5
     3fe:	226080e7          	jalr	550(ra) # 5620 <close>
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
     420:	81450513          	add	a0,a0,-2028 # 5c30 <malloc+0x210>
     424:	00005097          	auipc	ra,0x5
     428:	544080e7          	jalr	1348(ra) # 5968 <printf>
      exit(1);
     42c:	4505                	li	a0,1
     42e:	00005097          	auipc	ra,0x5
     432:	1ca080e7          	jalr	458(ra) # 55f8 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     436:	862a                	mv	a2,a0
     438:	85ce                	mv	a1,s3
     43a:	00006517          	auipc	a0,0x6
     43e:	80e50513          	add	a0,a0,-2034 # 5c48 <malloc+0x228>
     442:	00005097          	auipc	ra,0x5
     446:	526080e7          	jalr	1318(ra) # 5968 <printf>
      exit(1);
     44a:	4505                	li	a0,1
     44c:	00005097          	auipc	ra,0x5
     450:	1ac080e7          	jalr	428(ra) # 55f8 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     454:	862a                	mv	a2,a0
     456:	85ce                	mv	a1,s3
     458:	00006517          	auipc	a0,0x6
     45c:	82050513          	add	a0,a0,-2016 # 5c78 <malloc+0x258>
     460:	00005097          	auipc	ra,0x5
     464:	508080e7          	jalr	1288(ra) # 5968 <printf>
      exit(1);
     468:	4505                	li	a0,1
     46a:	00005097          	auipc	ra,0x5
     46e:	18e080e7          	jalr	398(ra) # 55f8 <exit>
      printf("pipe() failed\n");
     472:	00006517          	auipc	a0,0x6
     476:	83650513          	add	a0,a0,-1994 # 5ca8 <malloc+0x288>
     47a:	00005097          	auipc	ra,0x5
     47e:	4ee080e7          	jalr	1262(ra) # 5968 <printf>
      exit(1);
     482:	4505                	li	a0,1
     484:	00005097          	auipc	ra,0x5
     488:	174080e7          	jalr	372(ra) # 55f8 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48c:	862a                	mv	a2,a0
     48e:	85ce                	mv	a1,s3
     490:	00006517          	auipc	a0,0x6
     494:	82850513          	add	a0,a0,-2008 # 5cb8 <malloc+0x298>
     498:	00005097          	auipc	ra,0x5
     49c:	4d0080e7          	jalr	1232(ra) # 5968 <printf>
      exit(1);
     4a0:	4505                	li	a0,1
     4a2:	00005097          	auipc	ra,0x5
     4a6:	156080e7          	jalr	342(ra) # 55f8 <exit>

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
     4d2:	81aa0a13          	add	s4,s4,-2022 # 5ce8 <malloc+0x2c8>
    n = write(fds[1], "x", 1);
     4d6:	00005a97          	auipc	s5,0x5
     4da:	6daa8a93          	add	s5,s5,1754 # 5bb0 <malloc+0x190>
    uint64 addr = addrs[ai];
     4de:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e2:	4581                	li	a1,0
     4e4:	8552                	mv	a0,s4
     4e6:	00005097          	auipc	ra,0x5
     4ea:	152080e7          	jalr	338(ra) # 5638 <open>
     4ee:	84aa                	mv	s1,a0
    if(fd < 0){
     4f0:	08054663          	bltz	a0,57c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	00005097          	auipc	ra,0x5
     4fc:	118080e7          	jalr	280(ra) # 5610 <read>
    if(n > 0){
     500:	08a04b63          	bgtz	a0,596 <copyout+0xec>
    close(fd);
     504:	8526                	mv	a0,s1
     506:	00005097          	auipc	ra,0x5
     50a:	11a080e7          	jalr	282(ra) # 5620 <close>
    if(pipe(fds) < 0){
     50e:	fa840513          	add	a0,s0,-88
     512:	00005097          	auipc	ra,0x5
     516:	0f6080e7          	jalr	246(ra) # 5608 <pipe>
     51a:	08054d63          	bltz	a0,5b4 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     51e:	4605                	li	a2,1
     520:	85d6                	mv	a1,s5
     522:	fac42503          	lw	a0,-84(s0)
     526:	00005097          	auipc	ra,0x5
     52a:	0f2080e7          	jalr	242(ra) # 5618 <write>
    if(n != 1){
     52e:	4785                	li	a5,1
     530:	08f51f63          	bne	a0,a5,5ce <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     534:	6609                	lui	a2,0x2
     536:	85ce                	mv	a1,s3
     538:	fa842503          	lw	a0,-88(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	0d4080e7          	jalr	212(ra) # 5610 <read>
    if(n > 0){
     544:	0aa04263          	bgtz	a0,5e8 <copyout+0x13e>
    close(fds[0]);
     548:	fa842503          	lw	a0,-88(s0)
     54c:	00005097          	auipc	ra,0x5
     550:	0d4080e7          	jalr	212(ra) # 5620 <close>
    close(fds[1]);
     554:	fac42503          	lw	a0,-84(s0)
     558:	00005097          	auipc	ra,0x5
     55c:	0c8080e7          	jalr	200(ra) # 5620 <close>
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
     580:	77450513          	add	a0,a0,1908 # 5cf0 <malloc+0x2d0>
     584:	00005097          	auipc	ra,0x5
     588:	3e4080e7          	jalr	996(ra) # 5968 <printf>
      exit(1);
     58c:	4505                	li	a0,1
     58e:	00005097          	auipc	ra,0x5
     592:	06a080e7          	jalr	106(ra) # 55f8 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00005517          	auipc	a0,0x5
     59e:	76e50513          	add	a0,a0,1902 # 5d08 <malloc+0x2e8>
     5a2:	00005097          	auipc	ra,0x5
     5a6:	3c6080e7          	jalr	966(ra) # 5968 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	04c080e7          	jalr	76(ra) # 55f8 <exit>
      printf("pipe() failed\n");
     5b4:	00005517          	auipc	a0,0x5
     5b8:	6f450513          	add	a0,a0,1780 # 5ca8 <malloc+0x288>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	3ac080e7          	jalr	940(ra) # 5968 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	032080e7          	jalr	50(ra) # 55f8 <exit>
      printf("pipe write failed\n");
     5ce:	00005517          	auipc	a0,0x5
     5d2:	76a50513          	add	a0,a0,1898 # 5d38 <malloc+0x318>
     5d6:	00005097          	auipc	ra,0x5
     5da:	392080e7          	jalr	914(ra) # 5968 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	018080e7          	jalr	24(ra) # 55f8 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5e8:	862a                	mv	a2,a0
     5ea:	85ce                	mv	a1,s3
     5ec:	00005517          	auipc	a0,0x5
     5f0:	76450513          	add	a0,a0,1892 # 5d50 <malloc+0x330>
     5f4:	00005097          	auipc	ra,0x5
     5f8:	374080e7          	jalr	884(ra) # 5968 <printf>
      exit(1);
     5fc:	4505                	li	a0,1
     5fe:	00005097          	auipc	ra,0x5
     602:	ffa080e7          	jalr	-6(ra) # 55f8 <exit>

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
     61e:	57e50513          	add	a0,a0,1406 # 5b98 <malloc+0x178>
     622:	00005097          	auipc	ra,0x5
     626:	026080e7          	jalr	38(ra) # 5648 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62a:	60100593          	li	a1,1537
     62e:	00005517          	auipc	a0,0x5
     632:	56a50513          	add	a0,a0,1386 # 5b98 <malloc+0x178>
     636:	00005097          	auipc	ra,0x5
     63a:	002080e7          	jalr	2(ra) # 5638 <open>
     63e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     640:	4611                	li	a2,4
     642:	00005597          	auipc	a1,0x5
     646:	56658593          	add	a1,a1,1382 # 5ba8 <malloc+0x188>
     64a:	00005097          	auipc	ra,0x5
     64e:	fce080e7          	jalr	-50(ra) # 5618 <write>
  close(fd1);
     652:	8526                	mv	a0,s1
     654:	00005097          	auipc	ra,0x5
     658:	fcc080e7          	jalr	-52(ra) # 5620 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65c:	4581                	li	a1,0
     65e:	00005517          	auipc	a0,0x5
     662:	53a50513          	add	a0,a0,1338 # 5b98 <malloc+0x178>
     666:	00005097          	auipc	ra,0x5
     66a:	fd2080e7          	jalr	-46(ra) # 5638 <open>
     66e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     670:	02000613          	li	a2,32
     674:	fa040593          	add	a1,s0,-96
     678:	00005097          	auipc	ra,0x5
     67c:	f98080e7          	jalr	-104(ra) # 5610 <read>
  if(n != 4){
     680:	4791                	li	a5,4
     682:	0cf51e63          	bne	a0,a5,75e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     686:	40100593          	li	a1,1025
     68a:	00005517          	auipc	a0,0x5
     68e:	50e50513          	add	a0,a0,1294 # 5b98 <malloc+0x178>
     692:	00005097          	auipc	ra,0x5
     696:	fa6080e7          	jalr	-90(ra) # 5638 <open>
     69a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69c:	4581                	li	a1,0
     69e:	00005517          	auipc	a0,0x5
     6a2:	4fa50513          	add	a0,a0,1274 # 5b98 <malloc+0x178>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	f92080e7          	jalr	-110(ra) # 5638 <open>
     6ae:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b0:	02000613          	li	a2,32
     6b4:	fa040593          	add	a1,s0,-96
     6b8:	00005097          	auipc	ra,0x5
     6bc:	f58080e7          	jalr	-168(ra) # 5610 <read>
     6c0:	8a2a                	mv	s4,a0
  if(n != 0){
     6c2:	ed4d                	bnez	a0,77c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	add	a1,s0,-96
     6cc:	8526                	mv	a0,s1
     6ce:	00005097          	auipc	ra,0x5
     6d2:	f42080e7          	jalr	-190(ra) # 5610 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	e971                	bnez	a0,7ac <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6da:	4619                	li	a2,6
     6dc:	00005597          	auipc	a1,0x5
     6e0:	70458593          	add	a1,a1,1796 # 5de0 <malloc+0x3c0>
     6e4:	854e                	mv	a0,s3
     6e6:	00005097          	auipc	ra,0x5
     6ea:	f32080e7          	jalr	-206(ra) # 5618 <write>
  n = read(fd3, buf, sizeof(buf));
     6ee:	02000613          	li	a2,32
     6f2:	fa040593          	add	a1,s0,-96
     6f6:	854a                	mv	a0,s2
     6f8:	00005097          	auipc	ra,0x5
     6fc:	f18080e7          	jalr	-232(ra) # 5610 <read>
  if(n != 6){
     700:	4799                	li	a5,6
     702:	0cf51d63          	bne	a0,a5,7dc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     706:	02000613          	li	a2,32
     70a:	fa040593          	add	a1,s0,-96
     70e:	8526                	mv	a0,s1
     710:	00005097          	auipc	ra,0x5
     714:	f00080e7          	jalr	-256(ra) # 5610 <read>
  if(n != 2){
     718:	4789                	li	a5,2
     71a:	0ef51063          	bne	a0,a5,7fa <truncate1+0x1f4>
  unlink("truncfile");
     71e:	00005517          	auipc	a0,0x5
     722:	47a50513          	add	a0,a0,1146 # 5b98 <malloc+0x178>
     726:	00005097          	auipc	ra,0x5
     72a:	f22080e7          	jalr	-222(ra) # 5648 <unlink>
  close(fd1);
     72e:	854e                	mv	a0,s3
     730:	00005097          	auipc	ra,0x5
     734:	ef0080e7          	jalr	-272(ra) # 5620 <close>
  close(fd2);
     738:	8526                	mv	a0,s1
     73a:	00005097          	auipc	ra,0x5
     73e:	ee6080e7          	jalr	-282(ra) # 5620 <close>
  close(fd3);
     742:	854a                	mv	a0,s2
     744:	00005097          	auipc	ra,0x5
     748:	edc080e7          	jalr	-292(ra) # 5620 <close>
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
     766:	61e50513          	add	a0,a0,1566 # 5d80 <malloc+0x360>
     76a:	00005097          	auipc	ra,0x5
     76e:	1fe080e7          	jalr	510(ra) # 5968 <printf>
    exit(1);
     772:	4505                	li	a0,1
     774:	00005097          	auipc	ra,0x5
     778:	e84080e7          	jalr	-380(ra) # 55f8 <exit>
    printf("aaa fd3=%d\n", fd3);
     77c:	85ca                	mv	a1,s2
     77e:	00005517          	auipc	a0,0x5
     782:	62250513          	add	a0,a0,1570 # 5da0 <malloc+0x380>
     786:	00005097          	auipc	ra,0x5
     78a:	1e2080e7          	jalr	482(ra) # 5968 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     78e:	8652                	mv	a2,s4
     790:	85d6                	mv	a1,s5
     792:	00005517          	auipc	a0,0x5
     796:	61e50513          	add	a0,a0,1566 # 5db0 <malloc+0x390>
     79a:	00005097          	auipc	ra,0x5
     79e:	1ce080e7          	jalr	462(ra) # 5968 <printf>
    exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00005097          	auipc	ra,0x5
     7a8:	e54080e7          	jalr	-428(ra) # 55f8 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ac:	85a6                	mv	a1,s1
     7ae:	00005517          	auipc	a0,0x5
     7b2:	62250513          	add	a0,a0,1570 # 5dd0 <malloc+0x3b0>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	1b2080e7          	jalr	434(ra) # 5968 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7be:	8652                	mv	a2,s4
     7c0:	85d6                	mv	a1,s5
     7c2:	00005517          	auipc	a0,0x5
     7c6:	5ee50513          	add	a0,a0,1518 # 5db0 <malloc+0x390>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	19e080e7          	jalr	414(ra) # 5968 <printf>
    exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	e24080e7          	jalr	-476(ra) # 55f8 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7dc:	862a                	mv	a2,a0
     7de:	85d6                	mv	a1,s5
     7e0:	00005517          	auipc	a0,0x5
     7e4:	60850513          	add	a0,a0,1544 # 5de8 <malloc+0x3c8>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	180080e7          	jalr	384(ra) # 5968 <printf>
    exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	e06080e7          	jalr	-506(ra) # 55f8 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fa:	862a                	mv	a2,a0
     7fc:	85d6                	mv	a1,s5
     7fe:	00005517          	auipc	a0,0x5
     802:	60a50513          	add	a0,a0,1546 # 5e08 <malloc+0x3e8>
     806:	00005097          	auipc	ra,0x5
     80a:	162080e7          	jalr	354(ra) # 5968 <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	de8080e7          	jalr	-536(ra) # 55f8 <exit>

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
     836:	5f650513          	add	a0,a0,1526 # 5e28 <malloc+0x408>
     83a:	00005097          	auipc	ra,0x5
     83e:	dfe080e7          	jalr	-514(ra) # 5638 <open>
  if(fd < 0){
     842:	0a054d63          	bltz	a0,8fc <writetest+0xe4>
     846:	892a                	mv	s2,a0
     848:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84a:	00005997          	auipc	s3,0x5
     84e:	60698993          	add	s3,s3,1542 # 5e50 <malloc+0x430>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     852:	00005a97          	auipc	s5,0x5
     856:	636a8a93          	add	s5,s5,1590 # 5e88 <malloc+0x468>
  for(i = 0; i < N; i++){
     85a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	4629                	li	a2,10
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	00005097          	auipc	ra,0x5
     868:	db4080e7          	jalr	-588(ra) # 5618 <write>
     86c:	47a9                	li	a5,10
     86e:	0af51563          	bne	a0,a5,918 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85d6                	mv	a1,s5
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	da0080e7          	jalr	-608(ra) # 5618 <write>
     880:	47a9                	li	a5,10
     882:	0af51a63          	bne	a0,a5,936 <writetest+0x11e>
  for(i = 0; i < N; i++){
     886:	2485                	addw	s1,s1,1
     888:	fd449be3          	bne	s1,s4,85e <writetest+0x46>
  close(fd);
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	d92080e7          	jalr	-622(ra) # 5620 <close>
  fd = open("small", O_RDONLY);
     896:	4581                	li	a1,0
     898:	00005517          	auipc	a0,0x5
     89c:	59050513          	add	a0,a0,1424 # 5e28 <malloc+0x408>
     8a0:	00005097          	auipc	ra,0x5
     8a4:	d98080e7          	jalr	-616(ra) # 5638 <open>
     8a8:	84aa                	mv	s1,a0
  if(fd < 0){
     8aa:	0a054563          	bltz	a0,954 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8ae:	7d000613          	li	a2,2000
     8b2:	0000b597          	auipc	a1,0xb
     8b6:	21e58593          	add	a1,a1,542 # bad0 <buf>
     8ba:	00005097          	auipc	ra,0x5
     8be:	d56080e7          	jalr	-682(ra) # 5610 <read>
  if(i != N*SZ*2){
     8c2:	7d000793          	li	a5,2000
     8c6:	0af51563          	bne	a0,a5,970 <writetest+0x158>
  close(fd);
     8ca:	8526                	mv	a0,s1
     8cc:	00005097          	auipc	ra,0x5
     8d0:	d54080e7          	jalr	-684(ra) # 5620 <close>
  if(unlink("small") < 0){
     8d4:	00005517          	auipc	a0,0x5
     8d8:	55450513          	add	a0,a0,1364 # 5e28 <malloc+0x408>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	d6c080e7          	jalr	-660(ra) # 5648 <unlink>
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
     902:	53250513          	add	a0,a0,1330 # 5e30 <malloc+0x410>
     906:	00005097          	auipc	ra,0x5
     90a:	062080e7          	jalr	98(ra) # 5968 <printf>
    exit(1);
     90e:	4505                	li	a0,1
     910:	00005097          	auipc	ra,0x5
     914:	ce8080e7          	jalr	-792(ra) # 55f8 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     918:	8626                	mv	a2,s1
     91a:	85da                	mv	a1,s6
     91c:	00005517          	auipc	a0,0x5
     920:	54450513          	add	a0,a0,1348 # 5e60 <malloc+0x440>
     924:	00005097          	auipc	ra,0x5
     928:	044080e7          	jalr	68(ra) # 5968 <printf>
      exit(1);
     92c:	4505                	li	a0,1
     92e:	00005097          	auipc	ra,0x5
     932:	cca080e7          	jalr	-822(ra) # 55f8 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     936:	8626                	mv	a2,s1
     938:	85da                	mv	a1,s6
     93a:	00005517          	auipc	a0,0x5
     93e:	55e50513          	add	a0,a0,1374 # 5e98 <malloc+0x478>
     942:	00005097          	auipc	ra,0x5
     946:	026080e7          	jalr	38(ra) # 5968 <printf>
      exit(1);
     94a:	4505                	li	a0,1
     94c:	00005097          	auipc	ra,0x5
     950:	cac080e7          	jalr	-852(ra) # 55f8 <exit>
    printf("%s: error: open small failed!\n", s);
     954:	85da                	mv	a1,s6
     956:	00005517          	auipc	a0,0x5
     95a:	56a50513          	add	a0,a0,1386 # 5ec0 <malloc+0x4a0>
     95e:	00005097          	auipc	ra,0x5
     962:	00a080e7          	jalr	10(ra) # 5968 <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	c90080e7          	jalr	-880(ra) # 55f8 <exit>
    printf("%s: read failed\n", s);
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	56e50513          	add	a0,a0,1390 # 5ee0 <malloc+0x4c0>
     97a:	00005097          	auipc	ra,0x5
     97e:	fee080e7          	jalr	-18(ra) # 5968 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	c74080e7          	jalr	-908(ra) # 55f8 <exit>
    printf("%s: unlink small failed\n", s);
     98c:	85da                	mv	a1,s6
     98e:	00005517          	auipc	a0,0x5
     992:	56a50513          	add	a0,a0,1386 # 5ef8 <malloc+0x4d8>
     996:	00005097          	auipc	ra,0x5
     99a:	fd2080e7          	jalr	-46(ra) # 5968 <printf>
    exit(1);
     99e:	4505                	li	a0,1
     9a0:	00005097          	auipc	ra,0x5
     9a4:	c58080e7          	jalr	-936(ra) # 55f8 <exit>

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
     9c4:	55850513          	add	a0,a0,1368 # 5f18 <malloc+0x4f8>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	c70080e7          	jalr	-912(ra) # 5638 <open>
  if(fd < 0){
     9d0:	08054563          	bltz	a0,a5a <writebig+0xb2>
     9d4:	89aa                	mv	s3,a0
     9d6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d8:	0000b917          	auipc	s2,0xb
     9dc:	0f890913          	add	s2,s2,248 # bad0 <buf>
  for(i = 0; i < MAXFILE; i++){
     9e0:	6a41                	lui	s4,0x10
     9e2:	10ba0a13          	add	s4,s4,267 # 1010b <__BSS_END__+0x162b>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	c26080e7          	jalr	-986(ra) # 5618 <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3e>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	c16080e7          	jalr	-1002(ra) # 5620 <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00005517          	auipc	a0,0x5
     a18:	50450513          	add	a0,a0,1284 # 5f18 <malloc+0x4f8>
     a1c:	00005097          	auipc	ra,0x5
     a20:	c1c080e7          	jalr	-996(ra) # 5638 <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	0a890913          	add	s2,s2,168 # bad0 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	bd4080e7          	jalr	-1068(ra) # 5610 <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x108>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x160>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17e>
    n++;
     a56:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	4c450513          	add	a0,a0,1220 # 5f20 <malloc+0x500>
     a64:	00005097          	auipc	ra,0x5
     a68:	f04080e7          	jalr	-252(ra) # 5968 <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	b8a080e7          	jalr	-1142(ra) # 55f8 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00005517          	auipc	a0,0x5
     a7e:	4c650513          	add	a0,a0,1222 # 5f40 <malloc+0x520>
     a82:	00005097          	auipc	ra,0x5
     a86:	ee6080e7          	jalr	-282(ra) # 5968 <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	b6c080e7          	jalr	-1172(ra) # 55f8 <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00005517          	auipc	a0,0x5
     a9a:	4d250513          	add	a0,a0,1234 # 5f68 <malloc+0x548>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	eca080e7          	jalr	-310(ra) # 5968 <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	b50080e7          	jalr	-1200(ra) # 55f8 <exit>
      if(n == MAXFILE - 1){
     ab0:	67c1                	lui	a5,0x10
     ab2:	10a78793          	add	a5,a5,266 # 1010a <__BSS_END__+0x162a>
     ab6:	02f48a63          	beq	s1,a5,aea <writebig+0x142>
  close(fd);
     aba:	854e                	mv	a0,s3
     abc:	00005097          	auipc	ra,0x5
     ac0:	b64080e7          	jalr	-1180(ra) # 5620 <close>
  if(unlink("big") < 0){
     ac4:	00005517          	auipc	a0,0x5
     ac8:	45450513          	add	a0,a0,1108 # 5f18 <malloc+0x4f8>
     acc:	00005097          	auipc	ra,0x5
     ad0:	b7c080e7          	jalr	-1156(ra) # 5648 <unlink>
     ad4:	06054863          	bltz	a0,b44 <writebig+0x19c>
}
     ad8:	70e2                	ld	ra,56(sp)
     ada:	7442                	ld	s0,48(sp)
     adc:	74a2                	ld	s1,40(sp)
     ade:	7902                	ld	s2,32(sp)
     ae0:	69e2                	ld	s3,24(sp)
     ae2:	6a42                	ld	s4,16(sp)
     ae4:	6aa2                	ld	s5,8(sp)
     ae6:	6121                	add	sp,sp,64
     ae8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aea:	863e                	mv	a2,a5
     aec:	85d6                	mv	a1,s5
     aee:	00005517          	auipc	a0,0x5
     af2:	49a50513          	add	a0,a0,1178 # 5f88 <malloc+0x568>
     af6:	00005097          	auipc	ra,0x5
     afa:	e72080e7          	jalr	-398(ra) # 5968 <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	af8080e7          	jalr	-1288(ra) # 55f8 <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	4a450513          	add	a0,a0,1188 # 5fb0 <malloc+0x590>
     b14:	00005097          	auipc	ra,0x5
     b18:	e54080e7          	jalr	-428(ra) # 5968 <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	ada080e7          	jalr	-1318(ra) # 55f8 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00005517          	auipc	a0,0x5
     b2e:	49e50513          	add	a0,a0,1182 # 5fc8 <malloc+0x5a8>
     b32:	00005097          	auipc	ra,0x5
     b36:	e36080e7          	jalr	-458(ra) # 5968 <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	abc080e7          	jalr	-1348(ra) # 55f8 <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00005517          	auipc	a0,0x5
     b4a:	4aa50513          	add	a0,a0,1194 # 5ff0 <malloc+0x5d0>
     b4e:	00005097          	auipc	ra,0x5
     b52:	e1a080e7          	jalr	-486(ra) # 5968 <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	aa0080e7          	jalr	-1376(ra) # 55f8 <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	add	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	add	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	49450513          	add	a0,a0,1172 # 6008 <malloc+0x5e8>
     b7c:	00005097          	auipc	ra,0x5
     b80:	abc080e7          	jalr	-1348(ra) # 5638 <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00005597          	auipc	a1,0x5
     b90:	4ac58593          	add	a1,a1,1196 # 6038 <malloc+0x618>
     b94:	00005097          	auipc	ra,0x5
     b98:	a84080e7          	jalr	-1404(ra) # 5618 <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	a82080e7          	jalr	-1406(ra) # 5620 <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	46050513          	add	a0,a0,1120 # 6008 <malloc+0x5e8>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	a88080e7          	jalr	-1400(ra) # 5638 <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	44a50513          	add	a0,a0,1098 # 6008 <malloc+0x5e8>
     bc6:	00005097          	auipc	ra,0x5
     bca:	a82080e7          	jalr	-1406(ra) # 5648 <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	43450513          	add	a0,a0,1076 # 6008 <malloc+0x5e8>
     bdc:	00005097          	auipc	ra,0x5
     be0:	a5c080e7          	jalr	-1444(ra) # 5638 <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00005597          	auipc	a1,0x5
     bec:	49858593          	add	a1,a1,1176 # 6080 <malloc+0x660>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	a28080e7          	jalr	-1496(ra) # 5618 <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	a26080e7          	jalr	-1498(ra) # 5620 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	ecc58593          	add	a1,a1,-308 # bad0 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	a02080e7          	jalr	-1534(ra) # 5610 <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	eb474703          	lbu	a4,-332(a4) # bad0 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	ea258593          	add	a1,a1,-350 # bad0 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	9e0080e7          	jalr	-1568(ra) # 5618 <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	9d8080e7          	jalr	-1576(ra) # 5620 <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	3b850513          	add	a0,a0,952 # 6008 <malloc+0x5e8>
     c58:	00005097          	auipc	ra,0x5
     c5c:	9f0080e7          	jalr	-1552(ra) # 5648 <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	add	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00005517          	auipc	a0,0x5
     c74:	3a850513          	add	a0,a0,936 # 6018 <malloc+0x5f8>
     c78:	00005097          	auipc	ra,0x5
     c7c:	cf0080e7          	jalr	-784(ra) # 5968 <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	976080e7          	jalr	-1674(ra) # 55f8 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00005517          	auipc	a0,0x5
     c90:	3b450513          	add	a0,a0,948 # 6040 <malloc+0x620>
     c94:	00005097          	auipc	ra,0x5
     c98:	cd4080e7          	jalr	-812(ra) # 5968 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	95a080e7          	jalr	-1702(ra) # 55f8 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	3b850513          	add	a0,a0,952 # 6060 <malloc+0x640>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	cb8080e7          	jalr	-840(ra) # 5968 <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	93e080e7          	jalr	-1730(ra) # 55f8 <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00005517          	auipc	a0,0x5
     cc8:	3c450513          	add	a0,a0,964 # 6088 <malloc+0x668>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	c9c080e7          	jalr	-868(ra) # 5968 <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	922080e7          	jalr	-1758(ra) # 55f8 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00005517          	auipc	a0,0x5
     ce4:	3c850513          	add	a0,a0,968 # 60a8 <malloc+0x688>
     ce8:	00005097          	auipc	ra,0x5
     cec:	c80080e7          	jalr	-896(ra) # 5968 <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	906080e7          	jalr	-1786(ra) # 55f8 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00005517          	auipc	a0,0x5
     d00:	3cc50513          	add	a0,a0,972 # 60c8 <malloc+0x6a8>
     d04:	00005097          	auipc	ra,0x5
     d08:	c64080e7          	jalr	-924(ra) # 5968 <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	8ea080e7          	jalr	-1814(ra) # 55f8 <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	add	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	add	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00005517          	auipc	a0,0x5
     d28:	3c450513          	add	a0,a0,964 # 60e8 <malloc+0x6c8>
     d2c:	00005097          	auipc	ra,0x5
     d30:	91c080e7          	jalr	-1764(ra) # 5648 <unlink>
  unlink("lf2");
     d34:	00005517          	auipc	a0,0x5
     d38:	3bc50513          	add	a0,a0,956 # 60f0 <malloc+0x6d0>
     d3c:	00005097          	auipc	ra,0x5
     d40:	90c080e7          	jalr	-1780(ra) # 5648 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00005517          	auipc	a0,0x5
     d4c:	3a050513          	add	a0,a0,928 # 60e8 <malloc+0x6c8>
     d50:	00005097          	auipc	ra,0x5
     d54:	8e8080e7          	jalr	-1816(ra) # 5638 <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	2d858593          	add	a1,a1,728 # 6038 <malloc+0x618>
     d68:	00005097          	auipc	ra,0x5
     d6c:	8b0080e7          	jalr	-1872(ra) # 5618 <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	8a8080e7          	jalr	-1880(ra) # 5620 <close>
  if(link("lf1", "lf2") < 0){
     d80:	00005597          	auipc	a1,0x5
     d84:	37058593          	add	a1,a1,880 # 60f0 <malloc+0x6d0>
     d88:	00005517          	auipc	a0,0x5
     d8c:	36050513          	add	a0,a0,864 # 60e8 <malloc+0x6c8>
     d90:	00005097          	auipc	ra,0x5
     d94:	8c8080e7          	jalr	-1848(ra) # 5658 <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	34c50513          	add	a0,a0,844 # 60e8 <malloc+0x6c8>
     da4:	00005097          	auipc	ra,0x5
     da8:	8a4080e7          	jalr	-1884(ra) # 5648 <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	33a50513          	add	a0,a0,826 # 60e8 <malloc+0x6c8>
     db6:	00005097          	auipc	ra,0x5
     dba:	882080e7          	jalr	-1918(ra) # 5638 <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	32c50513          	add	a0,a0,812 # 60f0 <malloc+0x6d0>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	86c080e7          	jalr	-1940(ra) # 5638 <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	cf458593          	add	a1,a1,-780 # bad0 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	82c080e7          	jalr	-2004(ra) # 5610 <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	82c080e7          	jalr	-2004(ra) # 5620 <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	2f458593          	add	a1,a1,756 # 60f0 <malloc+0x6d0>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	852080e7          	jalr	-1966(ra) # 5658 <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	2de50513          	add	a0,a0,734 # 60f0 <malloc+0x6d0>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	82e080e7          	jalr	-2002(ra) # 5648 <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	2c658593          	add	a1,a1,710 # 60e8 <malloc+0x6c8>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	2c650513          	add	a0,a0,710 # 60f0 <malloc+0x6d0>
     e32:	00005097          	auipc	ra,0x5
     e36:	826080e7          	jalr	-2010(ra) # 5658 <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	2aa58593          	add	a1,a1,682 # 60e8 <malloc+0x6c8>
     e46:	00005517          	auipc	a0,0x5
     e4a:	3b250513          	add	a0,a0,946 # 61f8 <malloc+0x7d8>
     e4e:	00005097          	auipc	ra,0x5
     e52:	80a080e7          	jalr	-2038(ra) # 5658 <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	add	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	29050513          	add	a0,a0,656 # 60f8 <malloc+0x6d8>
     e70:	00005097          	auipc	ra,0x5
     e74:	af8080e7          	jalr	-1288(ra) # 5968 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00004097          	auipc	ra,0x4
     e7e:	77e080e7          	jalr	1918(ra) # 55f8 <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	28c50513          	add	a0,a0,652 # 6110 <malloc+0x6f0>
     e8c:	00005097          	auipc	ra,0x5
     e90:	adc080e7          	jalr	-1316(ra) # 5968 <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00004097          	auipc	ra,0x4
     e9a:	762080e7          	jalr	1890(ra) # 55f8 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	28850513          	add	a0,a0,648 # 6128 <malloc+0x708>
     ea8:	00005097          	auipc	ra,0x5
     eac:	ac0080e7          	jalr	-1344(ra) # 5968 <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00004097          	auipc	ra,0x4
     eb6:	746080e7          	jalr	1862(ra) # 55f8 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	28c50513          	add	a0,a0,652 # 6148 <malloc+0x728>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	aa4080e7          	jalr	-1372(ra) # 5968 <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00004097          	auipc	ra,0x4
     ed2:	72a080e7          	jalr	1834(ra) # 55f8 <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	2a050513          	add	a0,a0,672 # 6178 <malloc+0x758>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	a88080e7          	jalr	-1400(ra) # 5968 <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00004097          	auipc	ra,0x4
     eee:	70e080e7          	jalr	1806(ra) # 55f8 <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	29c50513          	add	a0,a0,668 # 6190 <malloc+0x770>
     efc:	00005097          	auipc	ra,0x5
     f00:	a6c080e7          	jalr	-1428(ra) # 5968 <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00004097          	auipc	ra,0x4
     f0a:	6f2080e7          	jalr	1778(ra) # 55f8 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	29850513          	add	a0,a0,664 # 61a8 <malloc+0x788>
     f18:	00005097          	auipc	ra,0x5
     f1c:	a50080e7          	jalr	-1456(ra) # 5968 <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00004097          	auipc	ra,0x4
     f26:	6d6080e7          	jalr	1750(ra) # 55f8 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	2a450513          	add	a0,a0,676 # 61d0 <malloc+0x7b0>
     f34:	00005097          	auipc	ra,0x5
     f38:	a34080e7          	jalr	-1484(ra) # 5968 <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00004097          	auipc	ra,0x4
     f42:	6ba080e7          	jalr	1722(ra) # 55f8 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	2b850513          	add	a0,a0,696 # 6200 <malloc+0x7e0>
     f50:	00005097          	auipc	ra,0x5
     f54:	a18080e7          	jalr	-1512(ra) # 5968 <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00004097          	auipc	ra,0x4
     f5e:	69e080e7          	jalr	1694(ra) # 55f8 <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	add	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	add	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	2a850513          	add	a0,a0,680 # 6220 <malloc+0x800>
     f80:	00004097          	auipc	ra,0x4
     f84:	6c8080e7          	jalr	1736(ra) # 5648 <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	29450513          	add	a0,a0,660 # 6220 <malloc+0x800>
     f94:	00004097          	auipc	ra,0x4
     f98:	6a4080e7          	jalr	1700(ra) # 5638 <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	680080e7          	jalr	1664(ra) # 5620 <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	272a0a13          	add	s4,s4,626 # 6220 <malloc+0x800>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9571b          	sraw	a4,s2,0x1f
     fc2:	01a7571b          	srlw	a4,a4,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraw	a3,a5,0x6
     fce:	0306869b          	addw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	and	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	add	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	66a080e7          	jalr	1642(ra) # 5658 <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	22050513          	add	a0,a0,544 # 6220 <malloc+0x800>
    1008:	00004097          	auipc	ra,0x4
    100c:	640080e7          	jalr	1600(ra) # 5648 <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d71b          	sraw	a4,s1,0x1f
    1020:	01a7571b          	srlw	a4,a4,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraw	a3,a5,0x6
    102c:	0306869b          	addw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	and	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	add	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	5fe080e7          	jalr	1534(ra) # 5648 <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	add	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	1b850513          	add	a0,a0,440 # 6228 <malloc+0x808>
    1078:	00005097          	auipc	ra,0x5
    107c:	8f0080e7          	jalr	-1808(ra) # 5968 <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	576080e7          	jalr	1398(ra) # 55f8 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	add	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	1b850513          	add	a0,a0,440 # 6248 <malloc+0x828>
    1098:	00005097          	auipc	ra,0x5
    109c:	8d0080e7          	jalr	-1840(ra) # 5968 <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	556080e7          	jalr	1366(ra) # 55f8 <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	1bc50513          	add	a0,a0,444 # 6268 <malloc+0x848>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	8b4080e7          	jalr	-1868(ra) # 5968 <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	53a080e7          	jalr	1338(ra) # 55f8 <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	add	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	add	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	1aa98993          	add	s3,s3,426 # 6288 <malloc+0x868>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	566080e7          	jalr	1382(ra) # 5658 <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	add	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	17e50513          	add	a0,a0,382 # 6298 <malloc+0x878>
    1122:	00005097          	auipc	ra,0x5
    1126:	846080e7          	jalr	-1978(ra) # 5968 <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	4cc080e7          	jalr	1228(ra) # 55f8 <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	add	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	add	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	15e4b483          	ld	s1,350(s1) # 82a0 <__SDATA_BEGIN__>
    114a:	fd840593          	add	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	4e0080e7          	jalr	1248(ra) # 5630 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	4ae080e7          	jalr	1198(ra) # 5608 <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	494080e7          	jalr	1172(ra) # 55f8 <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	add	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	add	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	add	s1,s1,848 # c350 <buf+0x880>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srl	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	9ba98993          	add	s3,s3,-1606 # 5b40 <malloc+0x120>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	add	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	494080e7          	jalr	1172(ra) # 5630 <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	44e080e7          	jalr	1102(ra) # 55f8 <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	add	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	add	a5,s0,-152
    11be:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	add	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	add	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	470080e7          	jalr	1136(ra) # 5648 <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	add	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	44a080e7          	jalr	1098(ra) # 5638 <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	add	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	456080e7          	jalr	1110(ra) # 5658 <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	26878793          	add	a5,a5,616 # 7478 <malloc+0x1a58>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	add	a1,s0,-168
    1224:	f6840513          	add	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	408080e7          	jalr	1032(ra) # 5630 <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	3ba080e7          	jalr	954(ra) # 55f0 <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	17278793          	add	a5,a5,370 # 83b8 <big.0>
    124e:	00008697          	auipc	a3,0x8
    1252:	16a68693          	add	a3,a3,362 # 93b8 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	add	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	14078a23          	sb	zero,340(a5) # 93b8 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	bec78793          	add	a5,a5,-1044 # 7e58 <malloc+0x2438>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	add	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	8b050513          	add	a0,a0,-1872 # 5b40 <malloc+0x120>
    1298:	00004097          	auipc	ra,0x4
    129c:	398080e7          	jalr	920(ra) # 5630 <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	09850513          	add	a0,a0,152 # 6340 <malloc+0x920>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	6b8080e7          	jalr	1720(ra) # 5968 <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	33e080e7          	jalr	830(ra) # 55f8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	add	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	ff050513          	add	a0,a0,-16 # 62b8 <malloc+0x898>
    12d0:	00004097          	auipc	ra,0x4
    12d4:	698080e7          	jalr	1688(ra) # 5968 <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	31e080e7          	jalr	798(ra) # 55f8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	add	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	ff050513          	add	a0,a0,-16 # 62d8 <malloc+0x8b8>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	678080e7          	jalr	1656(ra) # 5968 <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	2fe080e7          	jalr	766(ra) # 55f8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	add	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	fee50513          	add	a0,a0,-18 # 62f8 <malloc+0x8d8>
    1312:	00004097          	auipc	ra,0x4
    1316:	656080e7          	jalr	1622(ra) # 5968 <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	2dc080e7          	jalr	732(ra) # 55f8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	add	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	ff650513          	add	a0,a0,-10 # 6320 <malloc+0x900>
    1332:	00004097          	auipc	ra,0x4
    1336:	636080e7          	jalr	1590(ra) # 5968 <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	2bc080e7          	jalr	700(ra) # 55f8 <exit>
    printf("fork failed\n");
    1344:	00005517          	auipc	a0,0x5
    1348:	45c50513          	add	a0,a0,1116 # 67a0 <malloc+0xd80>
    134c:	00004097          	auipc	ra,0x4
    1350:	61c080e7          	jalr	1564(ra) # 5968 <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	2a2080e7          	jalr	674(ra) # 55f8 <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	296080e7          	jalr	662(ra) # 55f8 <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	add	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	28e080e7          	jalr	654(ra) # 5600 <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	add	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	fda50513          	add	a0,a0,-38 # 6368 <malloc+0x948>
    1396:	00004097          	auipc	ra,0x4
    139a:	5d2080e7          	jalr	1490(ra) # 5968 <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	258080e7          	jalr	600(ra) # 55f8 <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	add	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	add	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00004517          	auipc	a0,0x4
    13c4:	7d850513          	add	a0,a0,2008 # 5b98 <malloc+0x178>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	270080e7          	jalr	624(ra) # 5638 <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	250080e7          	jalr	592(ra) # 5620 <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	218080e7          	jalr	536(ra) # 55f0 <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00004a17          	auipc	s4,0x4
    13ee:	7aea0a13          	add	s4,s4,1966 # 5b98 <malloc+0x178>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	fd6a8a93          	add	s5,s5,-42 # 63c8 <malloc+0x9a8>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	23a080e7          	jalr	570(ra) # 5638 <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	208080e7          	jalr	520(ra) # 5618 <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	200080e7          	jalr	512(ra) # 5620 <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	20c080e7          	jalr	524(ra) # 5638 <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	add	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	1d2080e7          	jalr	466(ra) # 5610 <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	1d8080e7          	jalr	472(ra) # 5620 <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	1a0080e7          	jalr	416(ra) # 55f8 <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	f3650513          	add	a0,a0,-202 # 6398 <malloc+0x978>
    146a:	00004097          	auipc	ra,0x4
    146e:	4fe080e7          	jalr	1278(ra) # 5968 <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	184080e7          	jalr	388(ra) # 55f8 <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	f3250513          	add	a0,a0,-206 # 63b0 <malloc+0x990>
    1486:	00004097          	auipc	ra,0x4
    148a:	4e2080e7          	jalr	1250(ra) # 5968 <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	168080e7          	jalr	360(ra) # 55f8 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	f3c50513          	add	a0,a0,-196 # 63d8 <malloc+0x9b8>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	4c4080e7          	jalr	1220(ra) # 5968 <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	14a080e7          	jalr	330(ra) # 55f8 <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00004a17          	auipc	s4,0x4
    14be:	6dea0a13          	add	s4,s4,1758 # 5b98 <malloc+0x178>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	f36a8a93          	add	s5,s5,-202 # 63f8 <malloc+0x9d8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	168080e7          	jalr	360(ra) # 5638 <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	136080e7          	jalr	310(ra) # 5618 <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	12e080e7          	jalr	302(ra) # 5620 <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	add	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	0fc080e7          	jalr	252(ra) # 5600 <wait>
  unlink("truncfile");
    150c:	00004517          	auipc	a0,0x4
    1510:	68c50513          	add	a0,a0,1676 # 5b98 <malloc+0x178>
    1514:	00004097          	auipc	ra,0x4
    1518:	134080e7          	jalr	308(ra) # 5648 <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	0d8080e7          	jalr	216(ra) # 55f8 <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	e8650513          	add	a0,a0,-378 # 63b0 <malloc+0x990>
    1532:	00004097          	auipc	ra,0x4
    1536:	436080e7          	jalr	1078(ra) # 5968 <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	0bc080e7          	jalr	188(ra) # 55f8 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	eb850513          	add	a0,a0,-328 # 6400 <malloc+0x9e0>
    1550:	00004097          	auipc	ra,0x4
    1554:	418080e7          	jalr	1048(ra) # 5968 <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	09e080e7          	jalr	158(ra) # 55f8 <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	add	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	add	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00004797          	auipc	a5,0x4
    1574:	5d078793          	add	a5,a5,1488 # 5b40 <malloc+0x120>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	ea478793          	add	a5,a5,-348 # 6420 <malloc+0xa00>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	e9c50513          	add	a0,a0,-356 # 6428 <malloc+0xa08>
    1594:	00004097          	auipc	ra,0x4
    1598:	0b4080e7          	jalr	180(ra) # 5648 <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	054080e7          	jalr	84(ra) # 55f0 <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	072080e7          	jalr	114(ra) # 5620 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	e6e50513          	add	a0,a0,-402 # 6428 <malloc+0xa08>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	076080e7          	jalr	118(ra) # 5638 <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	e7250513          	add	a0,a0,-398 # 6448 <malloc+0xa28>
    15de:	00004097          	auipc	ra,0x4
    15e2:	38a080e7          	jalr	906(ra) # 5968 <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	010080e7          	jalr	16(ra) # 55f8 <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	da650513          	add	a0,a0,-602 # 6398 <malloc+0x978>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	36e080e7          	jalr	878(ra) # 5968 <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	ff4080e7          	jalr	-12(ra) # 55f8 <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	e2250513          	add	a0,a0,-478 # 6430 <malloc+0xa10>
    1616:	00004097          	auipc	ra,0x4
    161a:	352080e7          	jalr	850(ra) # 5968 <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	fd8080e7          	jalr	-40(ra) # 55f8 <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	add	a1,s0,-64
    162c:	00004517          	auipc	a0,0x4
    1630:	51450513          	add	a0,a0,1300 # 5b40 <malloc+0x120>
    1634:	00004097          	auipc	ra,0x4
    1638:	ffc080e7          	jalr	-4(ra) # 5630 <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	add	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	fbc080e7          	jalr	-68(ra) # 5600 <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	fa2080e7          	jalr	-94(ra) # 55f8 <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	df850513          	add	a0,a0,-520 # 6458 <malloc+0xa38>
    1668:	00004097          	auipc	ra,0x4
    166c:	300080e7          	jalr	768(ra) # 5968 <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	f86080e7          	jalr	-122(ra) # 55f8 <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	df450513          	add	a0,a0,-524 # 6470 <malloc+0xa50>
    1684:	00004097          	auipc	ra,0x4
    1688:	2e4080e7          	jalr	740(ra) # 5968 <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	d9850513          	add	a0,a0,-616 # 6428 <malloc+0xa08>
    1698:	00004097          	auipc	ra,0x4
    169c:	fa0080e7          	jalr	-96(ra) # 5638 <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	add	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	f66080e7          	jalr	-154(ra) # 5610 <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	82650513          	add	a0,a0,-2010 # 5ee0 <malloc+0x4c0>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	2a6080e7          	jalr	678(ra) # 5968 <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	f2c080e7          	jalr	-212(ra) # 55f8 <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	cda50513          	add	a0,a0,-806 # 63b0 <malloc+0x990>
    16de:	00004097          	auipc	ra,0x4
    16e2:	28a080e7          	jalr	650(ra) # 5968 <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	f10080e7          	jalr	-240(ra) # 55f8 <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	d3850513          	add	a0,a0,-712 # 6428 <malloc+0xa08>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	f50080e7          	jalr	-176(ra) # 5648 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	d6e50513          	add	a0,a0,-658 # 6488 <malloc+0xa68>
    1722:	00004097          	auipc	ra,0x4
    1726:	246080e7          	jalr	582(ra) # 5968 <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	ecc080e7          	jalr	-308(ra) # 55f8 <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	ec2080e7          	jalr	-318(ra) # 55f8 <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	add	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	add	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	add	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	eae080e7          	jalr	-338(ra) # 5608 <pipe>
    1762:	e93d                	bnez	a0,17d8 <pipe1+0x9a>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	e8a080e7          	jalr	-374(ra) # 55f0 <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c151                	beqz	a0,17f4 <pipe1+0xb6>
  } else if(pid > 0){
    1772:	16a05d63          	blez	a0,18ec <pipe1+0x1ae>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	ea6080e7          	jalr	-346(ra) # 5620 <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	34aa8a93          	add	s5,s5,842 # bad0 <buf>
    178e:	864e                	mv	a2,s3
    1790:	85d6                	mv	a1,s5
    1792:	fa842503          	lw	a0,-88(s0)
    1796:	00004097          	auipc	ra,0x4
    179a:	e7a080e7          	jalr	-390(ra) # 5610 <read>
    179e:	10a05263          	blez	a0,18a2 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17a2:	0000a717          	auipc	a4,0xa
    17a6:	32e70713          	add	a4,a4,814 # bad0 <buf>
    17aa:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ae:	00074683          	lbu	a3,0(a4)
    17b2:	0ff4f793          	zext.b	a5,s1
    17b6:	2485                	addw	s1,s1,1
    17b8:	0cf69163          	bne	a3,a5,187a <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17bc:	0705                	add	a4,a4,1
    17be:	fec498e3          	bne	s1,a2,17ae <pipe1+0x70>
      total += n;
    17c2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c6:	0019979b          	sllw	a5,s3,0x1
    17ca:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ce:	670d                	lui	a4,0x3
    17d0:	fb377fe3          	bgeu	a4,s3,178e <pipe1+0x50>
        cc = sizeof(buf);
    17d4:	698d                	lui	s3,0x3
    17d6:	bf65                	j	178e <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    17d8:	85ca                	mv	a1,s2
    17da:	00005517          	auipc	a0,0x5
    17de:	cc650513          	add	a0,a0,-826 # 64a0 <malloc+0xa80>
    17e2:	00004097          	auipc	ra,0x4
    17e6:	186080e7          	jalr	390(ra) # 5968 <printf>
    exit(1);
    17ea:	4505                	li	a0,1
    17ec:	00004097          	auipc	ra,0x4
    17f0:	e0c080e7          	jalr	-500(ra) # 55f8 <exit>
    close(fds[0]);
    17f4:	fa842503          	lw	a0,-88(s0)
    17f8:	00004097          	auipc	ra,0x4
    17fc:	e28080e7          	jalr	-472(ra) # 5620 <close>
    for(n = 0; n < N; n++){
    1800:	0000ab17          	auipc	s6,0xa
    1804:	2d0b0b13          	add	s6,s6,720 # bad0 <buf>
    1808:	416004bb          	negw	s1,s6
    180c:	0ff4f493          	zext.b	s1,s1
    1810:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1814:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1816:	6a85                	lui	s5,0x1
    1818:	42da8a93          	add	s5,s5,1069 # 142d <truncate3+0x85>
{
    181c:	87da                	mv	a5,s6
        buf[i] = seq++;
    181e:	0097873b          	addw	a4,a5,s1
    1822:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1826:	0785                	add	a5,a5,1
    1828:	fef99be3          	bne	s3,a5,181e <pipe1+0xe0>
        buf[i] = seq++;
    182c:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1830:	40900613          	li	a2,1033
    1834:	85de                	mv	a1,s7
    1836:	fac42503          	lw	a0,-84(s0)
    183a:	00004097          	auipc	ra,0x4
    183e:	dde080e7          	jalr	-546(ra) # 5618 <write>
    1842:	40900793          	li	a5,1033
    1846:	00f51c63          	bne	a0,a5,185e <pipe1+0x120>
    for(n = 0; n < N; n++){
    184a:	24a5                	addw	s1,s1,9
    184c:	0ff4f493          	zext.b	s1,s1
    1850:	fd5a16e3          	bne	s4,s5,181c <pipe1+0xde>
    exit(0);
    1854:	4501                	li	a0,0
    1856:	00004097          	auipc	ra,0x4
    185a:	da2080e7          	jalr	-606(ra) # 55f8 <exit>
        printf("%s: pipe1 oops 1\n", s);
    185e:	85ca                	mv	a1,s2
    1860:	00005517          	auipc	a0,0x5
    1864:	c5850513          	add	a0,a0,-936 # 64b8 <malloc+0xa98>
    1868:	00004097          	auipc	ra,0x4
    186c:	100080e7          	jalr	256(ra) # 5968 <printf>
        exit(1);
    1870:	4505                	li	a0,1
    1872:	00004097          	auipc	ra,0x4
    1876:	d86080e7          	jalr	-634(ra) # 55f8 <exit>
          printf("%s: pipe1 oops 2\n", s);
    187a:	85ca                	mv	a1,s2
    187c:	00005517          	auipc	a0,0x5
    1880:	c5450513          	add	a0,a0,-940 # 64d0 <malloc+0xab0>
    1884:	00004097          	auipc	ra,0x4
    1888:	0e4080e7          	jalr	228(ra) # 5968 <printf>
}
    188c:	60e6                	ld	ra,88(sp)
    188e:	6446                	ld	s0,80(sp)
    1890:	64a6                	ld	s1,72(sp)
    1892:	6906                	ld	s2,64(sp)
    1894:	79e2                	ld	s3,56(sp)
    1896:	7a42                	ld	s4,48(sp)
    1898:	7aa2                	ld	s5,40(sp)
    189a:	7b02                	ld	s6,32(sp)
    189c:	6be2                	ld	s7,24(sp)
    189e:	6125                	add	sp,sp,96
    18a0:	8082                	ret
    if(total != N * SZ){
    18a2:	6785                	lui	a5,0x1
    18a4:	42d78793          	add	a5,a5,1069 # 142d <truncate3+0x85>
    18a8:	02fa0063          	beq	s4,a5,18c8 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ac:	85d2                	mv	a1,s4
    18ae:	00005517          	auipc	a0,0x5
    18b2:	c3a50513          	add	a0,a0,-966 # 64e8 <malloc+0xac8>
    18b6:	00004097          	auipc	ra,0x4
    18ba:	0b2080e7          	jalr	178(ra) # 5968 <printf>
      exit(1);
    18be:	4505                	li	a0,1
    18c0:	00004097          	auipc	ra,0x4
    18c4:	d38080e7          	jalr	-712(ra) # 55f8 <exit>
    close(fds[0]);
    18c8:	fa842503          	lw	a0,-88(s0)
    18cc:	00004097          	auipc	ra,0x4
    18d0:	d54080e7          	jalr	-684(ra) # 5620 <close>
    wait(&xstatus);
    18d4:	fa440513          	add	a0,s0,-92
    18d8:	00004097          	auipc	ra,0x4
    18dc:	d28080e7          	jalr	-728(ra) # 5600 <wait>
    exit(xstatus);
    18e0:	fa442503          	lw	a0,-92(s0)
    18e4:	00004097          	auipc	ra,0x4
    18e8:	d14080e7          	jalr	-748(ra) # 55f8 <exit>
    printf("%s: fork() failed\n", s);
    18ec:	85ca                	mv	a1,s2
    18ee:	00005517          	auipc	a0,0x5
    18f2:	c1a50513          	add	a0,a0,-998 # 6508 <malloc+0xae8>
    18f6:	00004097          	auipc	ra,0x4
    18fa:	072080e7          	jalr	114(ra) # 5968 <printf>
    exit(1);
    18fe:	4505                	li	a0,1
    1900:	00004097          	auipc	ra,0x4
    1904:	cf8080e7          	jalr	-776(ra) # 55f8 <exit>

0000000000001908 <exitwait>:
{
    1908:	7139                	add	sp,sp,-64
    190a:	fc06                	sd	ra,56(sp)
    190c:	f822                	sd	s0,48(sp)
    190e:	f426                	sd	s1,40(sp)
    1910:	f04a                	sd	s2,32(sp)
    1912:	ec4e                	sd	s3,24(sp)
    1914:	e852                	sd	s4,16(sp)
    1916:	0080                	add	s0,sp,64
    1918:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191a:	4901                	li	s2,0
    191c:	06400993          	li	s3,100
    pid = fork();
    1920:	00004097          	auipc	ra,0x4
    1924:	cd0080e7          	jalr	-816(ra) # 55f0 <fork>
    1928:	84aa                	mv	s1,a0
    if(pid < 0){
    192a:	02054a63          	bltz	a0,195e <exitwait+0x56>
    if(pid){
    192e:	c151                	beqz	a0,19b2 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1930:	fcc40513          	add	a0,s0,-52
    1934:	00004097          	auipc	ra,0x4
    1938:	ccc080e7          	jalr	-820(ra) # 5600 <wait>
    193c:	02951f63          	bne	a0,s1,197a <exitwait+0x72>
      if(i != xstate) {
    1940:	fcc42783          	lw	a5,-52(s0)
    1944:	05279963          	bne	a5,s2,1996 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1948:	2905                	addw	s2,s2,1
    194a:	fd391be3          	bne	s2,s3,1920 <exitwait+0x18>
}
    194e:	70e2                	ld	ra,56(sp)
    1950:	7442                	ld	s0,48(sp)
    1952:	74a2                	ld	s1,40(sp)
    1954:	7902                	ld	s2,32(sp)
    1956:	69e2                	ld	s3,24(sp)
    1958:	6a42                	ld	s4,16(sp)
    195a:	6121                	add	sp,sp,64
    195c:	8082                	ret
      printf("%s: fork failed\n", s);
    195e:	85d2                	mv	a1,s4
    1960:	00005517          	auipc	a0,0x5
    1964:	a3850513          	add	a0,a0,-1480 # 6398 <malloc+0x978>
    1968:	00004097          	auipc	ra,0x4
    196c:	000080e7          	jalr	ra # 5968 <printf>
      exit(1);
    1970:	4505                	li	a0,1
    1972:	00004097          	auipc	ra,0x4
    1976:	c86080e7          	jalr	-890(ra) # 55f8 <exit>
        printf("%s: wait wrong pid\n", s);
    197a:	85d2                	mv	a1,s4
    197c:	00005517          	auipc	a0,0x5
    1980:	ba450513          	add	a0,a0,-1116 # 6520 <malloc+0xb00>
    1984:	00004097          	auipc	ra,0x4
    1988:	fe4080e7          	jalr	-28(ra) # 5968 <printf>
        exit(1);
    198c:	4505                	li	a0,1
    198e:	00004097          	auipc	ra,0x4
    1992:	c6a080e7          	jalr	-918(ra) # 55f8 <exit>
        printf("%s: wait wrong exit status\n", s);
    1996:	85d2                	mv	a1,s4
    1998:	00005517          	auipc	a0,0x5
    199c:	ba050513          	add	a0,a0,-1120 # 6538 <malloc+0xb18>
    19a0:	00004097          	auipc	ra,0x4
    19a4:	fc8080e7          	jalr	-56(ra) # 5968 <printf>
        exit(1);
    19a8:	4505                	li	a0,1
    19aa:	00004097          	auipc	ra,0x4
    19ae:	c4e080e7          	jalr	-946(ra) # 55f8 <exit>
      exit(i);
    19b2:	854a                	mv	a0,s2
    19b4:	00004097          	auipc	ra,0x4
    19b8:	c44080e7          	jalr	-956(ra) # 55f8 <exit>

00000000000019bc <twochildren>:
{
    19bc:	1101                	add	sp,sp,-32
    19be:	ec06                	sd	ra,24(sp)
    19c0:	e822                	sd	s0,16(sp)
    19c2:	e426                	sd	s1,8(sp)
    19c4:	e04a                	sd	s2,0(sp)
    19c6:	1000                	add	s0,sp,32
    19c8:	892a                	mv	s2,a0
    19ca:	3e800493          	li	s1,1000
    int pid1 = fork();
    19ce:	00004097          	auipc	ra,0x4
    19d2:	c22080e7          	jalr	-990(ra) # 55f0 <fork>
    if(pid1 < 0){
    19d6:	02054c63          	bltz	a0,1a0e <twochildren+0x52>
    if(pid1 == 0){
    19da:	c921                	beqz	a0,1a2a <twochildren+0x6e>
      int pid2 = fork();
    19dc:	00004097          	auipc	ra,0x4
    19e0:	c14080e7          	jalr	-1004(ra) # 55f0 <fork>
      if(pid2 < 0){
    19e4:	04054763          	bltz	a0,1a32 <twochildren+0x76>
      if(pid2 == 0){
    19e8:	c13d                	beqz	a0,1a4e <twochildren+0x92>
        wait(0);
    19ea:	4501                	li	a0,0
    19ec:	00004097          	auipc	ra,0x4
    19f0:	c14080e7          	jalr	-1004(ra) # 5600 <wait>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	c0a080e7          	jalr	-1014(ra) # 5600 <wait>
  for(int i = 0; i < 1000; i++){
    19fe:	34fd                	addw	s1,s1,-1
    1a00:	f4f9                	bnez	s1,19ce <twochildren+0x12>
}
    1a02:	60e2                	ld	ra,24(sp)
    1a04:	6442                	ld	s0,16(sp)
    1a06:	64a2                	ld	s1,8(sp)
    1a08:	6902                	ld	s2,0(sp)
    1a0a:	6105                	add	sp,sp,32
    1a0c:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0e:	85ca                	mv	a1,s2
    1a10:	00005517          	auipc	a0,0x5
    1a14:	98850513          	add	a0,a0,-1656 # 6398 <malloc+0x978>
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	f50080e7          	jalr	-176(ra) # 5968 <printf>
      exit(1);
    1a20:	4505                	li	a0,1
    1a22:	00004097          	auipc	ra,0x4
    1a26:	bd6080e7          	jalr	-1066(ra) # 55f8 <exit>
      exit(0);
    1a2a:	00004097          	auipc	ra,0x4
    1a2e:	bce080e7          	jalr	-1074(ra) # 55f8 <exit>
        printf("%s: fork failed\n", s);
    1a32:	85ca                	mv	a1,s2
    1a34:	00005517          	auipc	a0,0x5
    1a38:	96450513          	add	a0,a0,-1692 # 6398 <malloc+0x978>
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	f2c080e7          	jalr	-212(ra) # 5968 <printf>
        exit(1);
    1a44:	4505                	li	a0,1
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	bb2080e7          	jalr	-1102(ra) # 55f8 <exit>
        exit(0);
    1a4e:	00004097          	auipc	ra,0x4
    1a52:	baa080e7          	jalr	-1110(ra) # 55f8 <exit>

0000000000001a56 <forkfork>:
{
    1a56:	7179                	add	sp,sp,-48
    1a58:	f406                	sd	ra,40(sp)
    1a5a:	f022                	sd	s0,32(sp)
    1a5c:	ec26                	sd	s1,24(sp)
    1a5e:	1800                	add	s0,sp,48
    1a60:	84aa                	mv	s1,a0
    int pid = fork();
    1a62:	00004097          	auipc	ra,0x4
    1a66:	b8e080e7          	jalr	-1138(ra) # 55f0 <fork>
    if(pid < 0){
    1a6a:	04054163          	bltz	a0,1aac <forkfork+0x56>
    if(pid == 0){
    1a6e:	cd29                	beqz	a0,1ac8 <forkfork+0x72>
    int pid = fork();
    1a70:	00004097          	auipc	ra,0x4
    1a74:	b80080e7          	jalr	-1152(ra) # 55f0 <fork>
    if(pid < 0){
    1a78:	02054a63          	bltz	a0,1aac <forkfork+0x56>
    if(pid == 0){
    1a7c:	c531                	beqz	a0,1ac8 <forkfork+0x72>
    wait(&xstatus);
    1a7e:	fdc40513          	add	a0,s0,-36
    1a82:	00004097          	auipc	ra,0x4
    1a86:	b7e080e7          	jalr	-1154(ra) # 5600 <wait>
    if(xstatus != 0) {
    1a8a:	fdc42783          	lw	a5,-36(s0)
    1a8e:	ebbd                	bnez	a5,1b04 <forkfork+0xae>
    wait(&xstatus);
    1a90:	fdc40513          	add	a0,s0,-36
    1a94:	00004097          	auipc	ra,0x4
    1a98:	b6c080e7          	jalr	-1172(ra) # 5600 <wait>
    if(xstatus != 0) {
    1a9c:	fdc42783          	lw	a5,-36(s0)
    1aa0:	e3b5                	bnez	a5,1b04 <forkfork+0xae>
}
    1aa2:	70a2                	ld	ra,40(sp)
    1aa4:	7402                	ld	s0,32(sp)
    1aa6:	64e2                	ld	s1,24(sp)
    1aa8:	6145                	add	sp,sp,48
    1aaa:	8082                	ret
      printf("%s: fork failed", s);
    1aac:	85a6                	mv	a1,s1
    1aae:	00005517          	auipc	a0,0x5
    1ab2:	aaa50513          	add	a0,a0,-1366 # 6558 <malloc+0xb38>
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	eb2080e7          	jalr	-334(ra) # 5968 <printf>
      exit(1);
    1abe:	4505                	li	a0,1
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	b38080e7          	jalr	-1224(ra) # 55f8 <exit>
{
    1ac8:	0c800493          	li	s1,200
        int pid1 = fork();
    1acc:	00004097          	auipc	ra,0x4
    1ad0:	b24080e7          	jalr	-1244(ra) # 55f0 <fork>
        if(pid1 < 0){
    1ad4:	00054f63          	bltz	a0,1af2 <forkfork+0x9c>
        if(pid1 == 0){
    1ad8:	c115                	beqz	a0,1afc <forkfork+0xa6>
        wait(0);
    1ada:	4501                	li	a0,0
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	b24080e7          	jalr	-1244(ra) # 5600 <wait>
      for(int j = 0; j < 200; j++){
    1ae4:	34fd                	addw	s1,s1,-1
    1ae6:	f0fd                	bnez	s1,1acc <forkfork+0x76>
      exit(0);
    1ae8:	4501                	li	a0,0
    1aea:	00004097          	auipc	ra,0x4
    1aee:	b0e080e7          	jalr	-1266(ra) # 55f8 <exit>
          exit(1);
    1af2:	4505                	li	a0,1
    1af4:	00004097          	auipc	ra,0x4
    1af8:	b04080e7          	jalr	-1276(ra) # 55f8 <exit>
          exit(0);
    1afc:	00004097          	auipc	ra,0x4
    1b00:	afc080e7          	jalr	-1284(ra) # 55f8 <exit>
      printf("%s: fork in child failed", s);
    1b04:	85a6                	mv	a1,s1
    1b06:	00005517          	auipc	a0,0x5
    1b0a:	a6250513          	add	a0,a0,-1438 # 6568 <malloc+0xb48>
    1b0e:	00004097          	auipc	ra,0x4
    1b12:	e5a080e7          	jalr	-422(ra) # 5968 <printf>
      exit(1);
    1b16:	4505                	li	a0,1
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	ae0080e7          	jalr	-1312(ra) # 55f8 <exit>

0000000000001b20 <reparent2>:
{
    1b20:	1101                	add	sp,sp,-32
    1b22:	ec06                	sd	ra,24(sp)
    1b24:	e822                	sd	s0,16(sp)
    1b26:	e426                	sd	s1,8(sp)
    1b28:	1000                	add	s0,sp,32
    1b2a:	32000493          	li	s1,800
    int pid1 = fork();
    1b2e:	00004097          	auipc	ra,0x4
    1b32:	ac2080e7          	jalr	-1342(ra) # 55f0 <fork>
    if(pid1 < 0){
    1b36:	00054f63          	bltz	a0,1b54 <reparent2+0x34>
    if(pid1 == 0){
    1b3a:	c915                	beqz	a0,1b6e <reparent2+0x4e>
    wait(0);
    1b3c:	4501                	li	a0,0
    1b3e:	00004097          	auipc	ra,0x4
    1b42:	ac2080e7          	jalr	-1342(ra) # 5600 <wait>
  for(int i = 0; i < 800; i++){
    1b46:	34fd                	addw	s1,s1,-1
    1b48:	f0fd                	bnez	s1,1b2e <reparent2+0xe>
  exit(0);
    1b4a:	4501                	li	a0,0
    1b4c:	00004097          	auipc	ra,0x4
    1b50:	aac080e7          	jalr	-1364(ra) # 55f8 <exit>
      printf("fork failed\n");
    1b54:	00005517          	auipc	a0,0x5
    1b58:	c4c50513          	add	a0,a0,-948 # 67a0 <malloc+0xd80>
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	e0c080e7          	jalr	-500(ra) # 5968 <printf>
      exit(1);
    1b64:	4505                	li	a0,1
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	a92080e7          	jalr	-1390(ra) # 55f8 <exit>
      fork();
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	a82080e7          	jalr	-1406(ra) # 55f0 <fork>
      fork();
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	a7a080e7          	jalr	-1414(ra) # 55f0 <fork>
      exit(0);
    1b7e:	4501                	li	a0,0
    1b80:	00004097          	auipc	ra,0x4
    1b84:	a78080e7          	jalr	-1416(ra) # 55f8 <exit>

0000000000001b88 <createdelete>:
{
    1b88:	7175                	add	sp,sp,-144
    1b8a:	e506                	sd	ra,136(sp)
    1b8c:	e122                	sd	s0,128(sp)
    1b8e:	fca6                	sd	s1,120(sp)
    1b90:	f8ca                	sd	s2,112(sp)
    1b92:	f4ce                	sd	s3,104(sp)
    1b94:	f0d2                	sd	s4,96(sp)
    1b96:	ecd6                	sd	s5,88(sp)
    1b98:	e8da                	sd	s6,80(sp)
    1b9a:	e4de                	sd	s7,72(sp)
    1b9c:	e0e2                	sd	s8,64(sp)
    1b9e:	fc66                	sd	s9,56(sp)
    1ba0:	0900                	add	s0,sp,144
    1ba2:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba4:	4901                	li	s2,0
    1ba6:	4991                	li	s3,4
    pid = fork();
    1ba8:	00004097          	auipc	ra,0x4
    1bac:	a48080e7          	jalr	-1464(ra) # 55f0 <fork>
    1bb0:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb2:	02054f63          	bltz	a0,1bf0 <createdelete+0x68>
    if(pid == 0){
    1bb6:	c939                	beqz	a0,1c0c <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bb8:	2905                	addw	s2,s2,1
    1bba:	ff3917e3          	bne	s2,s3,1ba8 <createdelete+0x20>
    1bbe:	4491                	li	s1,4
    wait(&xstatus);
    1bc0:	f7c40513          	add	a0,s0,-132
    1bc4:	00004097          	auipc	ra,0x4
    1bc8:	a3c080e7          	jalr	-1476(ra) # 5600 <wait>
    if(xstatus != 0)
    1bcc:	f7c42903          	lw	s2,-132(s0)
    1bd0:	0e091263          	bnez	s2,1cb4 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd4:	34fd                	addw	s1,s1,-1
    1bd6:	f4ed                	bnez	s1,1bc0 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bd8:	f8040123          	sb	zero,-126(s0)
    1bdc:	03000993          	li	s3,48
    1be0:	5a7d                	li	s4,-1
    1be2:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be6:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1be8:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bea:	07400a93          	li	s5,116
    1bee:	a29d                	j	1d54 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf0:	85e6                	mv	a1,s9
    1bf2:	00005517          	auipc	a0,0x5
    1bf6:	bae50513          	add	a0,a0,-1106 # 67a0 <malloc+0xd80>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	d6e080e7          	jalr	-658(ra) # 5968 <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00004097          	auipc	ra,0x4
    1c08:	9f4080e7          	jalr	-1548(ra) # 55f8 <exit>
      name[0] = 'p' + pi;
    1c0c:	0709091b          	addw	s2,s2,112
    1c10:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c14:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c18:	4951                	li	s2,20
    1c1a:	a015                	j	1c3e <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1c:	85e6                	mv	a1,s9
    1c1e:	00005517          	auipc	a0,0x5
    1c22:	81250513          	add	a0,a0,-2030 # 6430 <malloc+0xa10>
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	d42080e7          	jalr	-702(ra) # 5968 <printf>
          exit(1);
    1c2e:	4505                	li	a0,1
    1c30:	00004097          	auipc	ra,0x4
    1c34:	9c8080e7          	jalr	-1592(ra) # 55f8 <exit>
      for(i = 0; i < N; i++){
    1c38:	2485                	addw	s1,s1,1
    1c3a:	07248863          	beq	s1,s2,1caa <createdelete+0x122>
        name[1] = '0' + i;
    1c3e:	0304879b          	addw	a5,s1,48
    1c42:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c46:	20200593          	li	a1,514
    1c4a:	f8040513          	add	a0,s0,-128
    1c4e:	00004097          	auipc	ra,0x4
    1c52:	9ea080e7          	jalr	-1558(ra) # 5638 <open>
        if(fd < 0){
    1c56:	fc0543e3          	bltz	a0,1c1c <createdelete+0x94>
        close(fd);
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	9c6080e7          	jalr	-1594(ra) # 5620 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c62:	fc905be3          	blez	s1,1c38 <createdelete+0xb0>
    1c66:	0014f793          	and	a5,s1,1
    1c6a:	f7f9                	bnez	a5,1c38 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6c:	01f4d79b          	srlw	a5,s1,0x1f
    1c70:	9fa5                	addw	a5,a5,s1
    1c72:	4017d79b          	sraw	a5,a5,0x1
    1c76:	0307879b          	addw	a5,a5,48
    1c7a:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c7e:	f8040513          	add	a0,s0,-128
    1c82:	00004097          	auipc	ra,0x4
    1c86:	9c6080e7          	jalr	-1594(ra) # 5648 <unlink>
    1c8a:	fa0557e3          	bgez	a0,1c38 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c8e:	85e6                	mv	a1,s9
    1c90:	00005517          	auipc	a0,0x5
    1c94:	8f850513          	add	a0,a0,-1800 # 6588 <malloc+0xb68>
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	cd0080e7          	jalr	-816(ra) # 5968 <printf>
            exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	956080e7          	jalr	-1706(ra) # 55f8 <exit>
      exit(0);
    1caa:	4501                	li	a0,0
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	94c080e7          	jalr	-1716(ra) # 55f8 <exit>
      exit(1);
    1cb4:	4505                	li	a0,1
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	942080e7          	jalr	-1726(ra) # 55f8 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cbe:	f8040613          	add	a2,s0,-128
    1cc2:	85e6                	mv	a1,s9
    1cc4:	00005517          	auipc	a0,0x5
    1cc8:	8dc50513          	add	a0,a0,-1828 # 65a0 <malloc+0xb80>
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	c9c080e7          	jalr	-868(ra) # 5968 <printf>
        exit(1);
    1cd4:	4505                	li	a0,1
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	922080e7          	jalr	-1758(ra) # 55f8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cde:	054b7163          	bgeu	s6,s4,1d20 <createdelete+0x198>
      if(fd >= 0)
    1ce2:	02055a63          	bgez	a0,1d16 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce6:	2485                	addw	s1,s1,1
    1ce8:	0ff4f493          	zext.b	s1,s1
    1cec:	05548c63          	beq	s1,s5,1d44 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf4:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cf8:	4581                	li	a1,0
    1cfa:	f8040513          	add	a0,s0,-128
    1cfe:	00004097          	auipc	ra,0x4
    1d02:	93a080e7          	jalr	-1734(ra) # 5638 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d06:	00090463          	beqz	s2,1d0e <createdelete+0x186>
    1d0a:	fd2bdae3          	bge	s7,s2,1cde <createdelete+0x156>
    1d0e:	fa0548e3          	bltz	a0,1cbe <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d12:	014b7963          	bgeu	s6,s4,1d24 <createdelete+0x19c>
        close(fd);
    1d16:	00004097          	auipc	ra,0x4
    1d1a:	90a080e7          	jalr	-1782(ra) # 5620 <close>
    1d1e:	b7e1                	j	1ce6 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d20:	fc0543e3          	bltz	a0,1ce6 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d24:	f8040613          	add	a2,s0,-128
    1d28:	85e6                	mv	a1,s9
    1d2a:	00005517          	auipc	a0,0x5
    1d2e:	89e50513          	add	a0,a0,-1890 # 65c8 <malloc+0xba8>
    1d32:	00004097          	auipc	ra,0x4
    1d36:	c36080e7          	jalr	-970(ra) # 5968 <printf>
        exit(1);
    1d3a:	4505                	li	a0,1
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	8bc080e7          	jalr	-1860(ra) # 55f8 <exit>
  for(i = 0; i < N; i++){
    1d44:	2905                	addw	s2,s2,1
    1d46:	2a05                	addw	s4,s4,1
    1d48:	2985                	addw	s3,s3,1 # 3001 <dirtest+0x85>
    1d4a:	0ff9f993          	zext.b	s3,s3
    1d4e:	47d1                	li	a5,20
    1d50:	02f90a63          	beq	s2,a5,1d84 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d54:	84e2                	mv	s1,s8
    1d56:	bf69                	j	1cf0 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d58:	2905                	addw	s2,s2,1
    1d5a:	0ff97913          	zext.b	s2,s2
    1d5e:	2985                	addw	s3,s3,1
    1d60:	0ff9f993          	zext.b	s3,s3
    1d64:	03490863          	beq	s2,s4,1d94 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d68:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6a:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d6e:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d72:	f8040513          	add	a0,s0,-128
    1d76:	00004097          	auipc	ra,0x4
    1d7a:	8d2080e7          	jalr	-1838(ra) # 5648 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d7e:	34fd                	addw	s1,s1,-1
    1d80:	f4ed                	bnez	s1,1d6a <createdelete+0x1e2>
    1d82:	bfd9                	j	1d58 <createdelete+0x1d0>
    1d84:	03000993          	li	s3,48
    1d88:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8c:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d8e:	08400a13          	li	s4,132
    1d92:	bfd9                	j	1d68 <createdelete+0x1e0>
}
    1d94:	60aa                	ld	ra,136(sp)
    1d96:	640a                	ld	s0,128(sp)
    1d98:	74e6                	ld	s1,120(sp)
    1d9a:	7946                	ld	s2,112(sp)
    1d9c:	79a6                	ld	s3,104(sp)
    1d9e:	7a06                	ld	s4,96(sp)
    1da0:	6ae6                	ld	s5,88(sp)
    1da2:	6b46                	ld	s6,80(sp)
    1da4:	6ba6                	ld	s7,72(sp)
    1da6:	6c06                	ld	s8,64(sp)
    1da8:	7ce2                	ld	s9,56(sp)
    1daa:	6149                	add	sp,sp,144
    1dac:	8082                	ret

0000000000001dae <linkunlink>:
{
    1dae:	711d                	add	sp,sp,-96
    1db0:	ec86                	sd	ra,88(sp)
    1db2:	e8a2                	sd	s0,80(sp)
    1db4:	e4a6                	sd	s1,72(sp)
    1db6:	e0ca                	sd	s2,64(sp)
    1db8:	fc4e                	sd	s3,56(sp)
    1dba:	f852                	sd	s4,48(sp)
    1dbc:	f456                	sd	s5,40(sp)
    1dbe:	f05a                	sd	s6,32(sp)
    1dc0:	ec5e                	sd	s7,24(sp)
    1dc2:	e862                	sd	s8,16(sp)
    1dc4:	e466                	sd	s9,8(sp)
    1dc6:	1080                	add	s0,sp,96
    1dc8:	84aa                	mv	s1,a0
  unlink("x");
    1dca:	00004517          	auipc	a0,0x4
    1dce:	de650513          	add	a0,a0,-538 # 5bb0 <malloc+0x190>
    1dd2:	00004097          	auipc	ra,0x4
    1dd6:	876080e7          	jalr	-1930(ra) # 5648 <unlink>
  pid = fork();
    1dda:	00004097          	auipc	ra,0x4
    1dde:	816080e7          	jalr	-2026(ra) # 55f0 <fork>
  if(pid < 0){
    1de2:	02054b63          	bltz	a0,1e18 <linkunlink+0x6a>
    1de6:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1de8:	06100c93          	li	s9,97
    1dec:	c111                	beqz	a0,1df0 <linkunlink+0x42>
    1dee:	4c85                	li	s9,1
    1df0:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df4:	41c659b7          	lui	s3,0x41c65
    1df8:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c5638d>
    1dfc:	690d                	lui	s2,0x3
    1dfe:	0399091b          	addw	s2,s2,57 # 3039 <dirtest+0xbd>
    if((x % 3) == 0){
    1e02:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e04:	4b05                	li	s6,1
      unlink("x");
    1e06:	00004a97          	auipc	s5,0x4
    1e0a:	daaa8a93          	add	s5,s5,-598 # 5bb0 <malloc+0x190>
      link("cat", "x");
    1e0e:	00004b97          	auipc	s7,0x4
    1e12:	7e2b8b93          	add	s7,s7,2018 # 65f0 <malloc+0xbd0>
    1e16:	a825                	j	1e4e <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e18:	85a6                	mv	a1,s1
    1e1a:	00004517          	auipc	a0,0x4
    1e1e:	57e50513          	add	a0,a0,1406 # 6398 <malloc+0x978>
    1e22:	00004097          	auipc	ra,0x4
    1e26:	b46080e7          	jalr	-1210(ra) # 5968 <printf>
    exit(1);
    1e2a:	4505                	li	a0,1
    1e2c:	00003097          	auipc	ra,0x3
    1e30:	7cc080e7          	jalr	1996(ra) # 55f8 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e34:	20200593          	li	a1,514
    1e38:	8556                	mv	a0,s5
    1e3a:	00003097          	auipc	ra,0x3
    1e3e:	7fe080e7          	jalr	2046(ra) # 5638 <open>
    1e42:	00003097          	auipc	ra,0x3
    1e46:	7de080e7          	jalr	2014(ra) # 5620 <close>
  for(i = 0; i < 100; i++){
    1e4a:	34fd                	addw	s1,s1,-1
    1e4c:	c88d                	beqz	s1,1e7e <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e4e:	033c87bb          	mulw	a5,s9,s3
    1e52:	012787bb          	addw	a5,a5,s2
    1e56:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5a:	0347f7bb          	remuw	a5,a5,s4
    1e5e:	dbf9                	beqz	a5,1e34 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e60:	01678863          	beq	a5,s6,1e70 <linkunlink+0xc2>
      unlink("x");
    1e64:	8556                	mv	a0,s5
    1e66:	00003097          	auipc	ra,0x3
    1e6a:	7e2080e7          	jalr	2018(ra) # 5648 <unlink>
    1e6e:	bff1                	j	1e4a <linkunlink+0x9c>
      link("cat", "x");
    1e70:	85d6                	mv	a1,s5
    1e72:	855e                	mv	a0,s7
    1e74:	00003097          	auipc	ra,0x3
    1e78:	7e4080e7          	jalr	2020(ra) # 5658 <link>
    1e7c:	b7f9                	j	1e4a <linkunlink+0x9c>
  if(pid)
    1e7e:	020c0463          	beqz	s8,1ea6 <linkunlink+0xf8>
    wait(0);
    1e82:	4501                	li	a0,0
    1e84:	00003097          	auipc	ra,0x3
    1e88:	77c080e7          	jalr	1916(ra) # 5600 <wait>
}
    1e8c:	60e6                	ld	ra,88(sp)
    1e8e:	6446                	ld	s0,80(sp)
    1e90:	64a6                	ld	s1,72(sp)
    1e92:	6906                	ld	s2,64(sp)
    1e94:	79e2                	ld	s3,56(sp)
    1e96:	7a42                	ld	s4,48(sp)
    1e98:	7aa2                	ld	s5,40(sp)
    1e9a:	7b02                	ld	s6,32(sp)
    1e9c:	6be2                	ld	s7,24(sp)
    1e9e:	6c42                	ld	s8,16(sp)
    1ea0:	6ca2                	ld	s9,8(sp)
    1ea2:	6125                	add	sp,sp,96
    1ea4:	8082                	ret
    exit(0);
    1ea6:	4501                	li	a0,0
    1ea8:	00003097          	auipc	ra,0x3
    1eac:	750080e7          	jalr	1872(ra) # 55f8 <exit>

0000000000001eb0 <manywrites>:
{
    1eb0:	711d                	add	sp,sp,-96
    1eb2:	ec86                	sd	ra,88(sp)
    1eb4:	e8a2                	sd	s0,80(sp)
    1eb6:	e4a6                	sd	s1,72(sp)
    1eb8:	e0ca                	sd	s2,64(sp)
    1eba:	fc4e                	sd	s3,56(sp)
    1ebc:	f852                	sd	s4,48(sp)
    1ebe:	f456                	sd	s5,40(sp)
    1ec0:	f05a                	sd	s6,32(sp)
    1ec2:	ec5e                	sd	s7,24(sp)
    1ec4:	1080                	add	s0,sp,96
    1ec6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ec8:	4981                	li	s3,0
    1eca:	4911                	li	s2,4
    int pid = fork();
    1ecc:	00003097          	auipc	ra,0x3
    1ed0:	724080e7          	jalr	1828(ra) # 55f0 <fork>
    1ed4:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed6:	02054963          	bltz	a0,1f08 <manywrites+0x58>
    if(pid == 0){
    1eda:	c521                	beqz	a0,1f22 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1edc:	2985                	addw	s3,s3,1
    1ede:	ff2997e3          	bne	s3,s2,1ecc <manywrites+0x1c>
    1ee2:	4491                	li	s1,4
    int st = 0;
    1ee4:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1ee8:	fa840513          	add	a0,s0,-88
    1eec:	00003097          	auipc	ra,0x3
    1ef0:	714080e7          	jalr	1812(ra) # 5600 <wait>
    if(st != 0)
    1ef4:	fa842503          	lw	a0,-88(s0)
    1ef8:	ed6d                	bnez	a0,1ff2 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efa:	34fd                	addw	s1,s1,-1
    1efc:	f4e5                	bnez	s1,1ee4 <manywrites+0x34>
  exit(0);
    1efe:	4501                	li	a0,0
    1f00:	00003097          	auipc	ra,0x3
    1f04:	6f8080e7          	jalr	1784(ra) # 55f8 <exit>
      printf("fork failed\n");
    1f08:	00005517          	auipc	a0,0x5
    1f0c:	89850513          	add	a0,a0,-1896 # 67a0 <malloc+0xd80>
    1f10:	00004097          	auipc	ra,0x4
    1f14:	a58080e7          	jalr	-1448(ra) # 5968 <printf>
      exit(1);
    1f18:	4505                	li	a0,1
    1f1a:	00003097          	auipc	ra,0x3
    1f1e:	6de080e7          	jalr	1758(ra) # 55f8 <exit>
      name[0] = 'b';
    1f22:	06200793          	li	a5,98
    1f26:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2a:	0619879b          	addw	a5,s3,97
    1f2e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f32:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f36:	fa840513          	add	a0,s0,-88
    1f3a:	00003097          	auipc	ra,0x3
    1f3e:	70e080e7          	jalr	1806(ra) # 5648 <unlink>
    1f42:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f44:	0000ab17          	auipc	s6,0xa
    1f48:	b8cb0b13          	add	s6,s6,-1140 # bad0 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4c:	8a26                	mv	s4,s1
    1f4e:	0209ce63          	bltz	s3,1f8a <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f52:	20200593          	li	a1,514
    1f56:	fa840513          	add	a0,s0,-88
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	6de080e7          	jalr	1758(ra) # 5638 <open>
    1f62:	892a                	mv	s2,a0
          if(fd < 0){
    1f64:	04054763          	bltz	a0,1fb2 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f68:	660d                	lui	a2,0x3
    1f6a:	85da                	mv	a1,s6
    1f6c:	00003097          	auipc	ra,0x3
    1f70:	6ac080e7          	jalr	1708(ra) # 5618 <write>
          if(cc != sz){
    1f74:	678d                	lui	a5,0x3
    1f76:	04f51e63          	bne	a0,a5,1fd2 <manywrites+0x122>
          close(fd);
    1f7a:	854a                	mv	a0,s2
    1f7c:	00003097          	auipc	ra,0x3
    1f80:	6a4080e7          	jalr	1700(ra) # 5620 <close>
        for(int i = 0; i < ci+1; i++){
    1f84:	2a05                	addw	s4,s4,1
    1f86:	fd49d6e3          	bge	s3,s4,1f52 <manywrites+0xa2>
        unlink(name);
    1f8a:	fa840513          	add	a0,s0,-88
    1f8e:	00003097          	auipc	ra,0x3
    1f92:	6ba080e7          	jalr	1722(ra) # 5648 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f96:	3bfd                	addw	s7,s7,-1
    1f98:	fa0b9ae3          	bnez	s7,1f4c <manywrites+0x9c>
      unlink(name);
    1f9c:	fa840513          	add	a0,s0,-88
    1fa0:	00003097          	auipc	ra,0x3
    1fa4:	6a8080e7          	jalr	1704(ra) # 5648 <unlink>
      exit(0);
    1fa8:	4501                	li	a0,0
    1faa:	00003097          	auipc	ra,0x3
    1fae:	64e080e7          	jalr	1614(ra) # 55f8 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb2:	fa840613          	add	a2,s0,-88
    1fb6:	85d6                	mv	a1,s5
    1fb8:	00004517          	auipc	a0,0x4
    1fbc:	64050513          	add	a0,a0,1600 # 65f8 <malloc+0xbd8>
    1fc0:	00004097          	auipc	ra,0x4
    1fc4:	9a8080e7          	jalr	-1624(ra) # 5968 <printf>
            exit(1);
    1fc8:	4505                	li	a0,1
    1fca:	00003097          	auipc	ra,0x3
    1fce:	62e080e7          	jalr	1582(ra) # 55f8 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd2:	86aa                	mv	a3,a0
    1fd4:	660d                	lui	a2,0x3
    1fd6:	85d6                	mv	a1,s5
    1fd8:	00004517          	auipc	a0,0x4
    1fdc:	c3850513          	add	a0,a0,-968 # 5c10 <malloc+0x1f0>
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	988080e7          	jalr	-1656(ra) # 5968 <printf>
            exit(1);
    1fe8:	4505                	li	a0,1
    1fea:	00003097          	auipc	ra,0x3
    1fee:	60e080e7          	jalr	1550(ra) # 55f8 <exit>
      exit(st);
    1ff2:	00003097          	auipc	ra,0x3
    1ff6:	606080e7          	jalr	1542(ra) # 55f8 <exit>

0000000000001ffa <forktest>:
{
    1ffa:	7179                	add	sp,sp,-48
    1ffc:	f406                	sd	ra,40(sp)
    1ffe:	f022                	sd	s0,32(sp)
    2000:	ec26                	sd	s1,24(sp)
    2002:	e84a                	sd	s2,16(sp)
    2004:	e44e                	sd	s3,8(sp)
    2006:	1800                	add	s0,sp,48
    2008:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200a:	4481                	li	s1,0
    200c:	3e800913          	li	s2,1000
    pid = fork();
    2010:	00003097          	auipc	ra,0x3
    2014:	5e0080e7          	jalr	1504(ra) # 55f0 <fork>
    if(pid < 0)
    2018:	02054863          	bltz	a0,2048 <forktest+0x4e>
    if(pid == 0)
    201c:	c115                	beqz	a0,2040 <forktest+0x46>
  for(n=0; n<N; n++){
    201e:	2485                	addw	s1,s1,1
    2020:	ff2498e3          	bne	s1,s2,2010 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2024:	85ce                	mv	a1,s3
    2026:	00004517          	auipc	a0,0x4
    202a:	60250513          	add	a0,a0,1538 # 6628 <malloc+0xc08>
    202e:	00004097          	auipc	ra,0x4
    2032:	93a080e7          	jalr	-1734(ra) # 5968 <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	5c0080e7          	jalr	1472(ra) # 55f8 <exit>
      exit(0);
    2040:	00003097          	auipc	ra,0x3
    2044:	5b8080e7          	jalr	1464(ra) # 55f8 <exit>
  if (n == 0) {
    2048:	cc9d                	beqz	s1,2086 <forktest+0x8c>
  if(n == N){
    204a:	3e800793          	li	a5,1000
    204e:	fcf48be3          	beq	s1,a5,2024 <forktest+0x2a>
  for(; n > 0; n--){
    2052:	00905b63          	blez	s1,2068 <forktest+0x6e>
    if(wait(0) < 0){
    2056:	4501                	li	a0,0
    2058:	00003097          	auipc	ra,0x3
    205c:	5a8080e7          	jalr	1448(ra) # 5600 <wait>
    2060:	04054163          	bltz	a0,20a2 <forktest+0xa8>
  for(; n > 0; n--){
    2064:	34fd                	addw	s1,s1,-1
    2066:	f8e5                	bnez	s1,2056 <forktest+0x5c>
  if(wait(0) != -1){
    2068:	4501                	li	a0,0
    206a:	00003097          	auipc	ra,0x3
    206e:	596080e7          	jalr	1430(ra) # 5600 <wait>
    2072:	57fd                	li	a5,-1
    2074:	04f51563          	bne	a0,a5,20be <forktest+0xc4>
}
    2078:	70a2                	ld	ra,40(sp)
    207a:	7402                	ld	s0,32(sp)
    207c:	64e2                	ld	s1,24(sp)
    207e:	6942                	ld	s2,16(sp)
    2080:	69a2                	ld	s3,8(sp)
    2082:	6145                	add	sp,sp,48
    2084:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2086:	85ce                	mv	a1,s3
    2088:	00004517          	auipc	a0,0x4
    208c:	58850513          	add	a0,a0,1416 # 6610 <malloc+0xbf0>
    2090:	00004097          	auipc	ra,0x4
    2094:	8d8080e7          	jalr	-1832(ra) # 5968 <printf>
    exit(1);
    2098:	4505                	li	a0,1
    209a:	00003097          	auipc	ra,0x3
    209e:	55e080e7          	jalr	1374(ra) # 55f8 <exit>
      printf("%s: wait stopped early\n", s);
    20a2:	85ce                	mv	a1,s3
    20a4:	00004517          	auipc	a0,0x4
    20a8:	5ac50513          	add	a0,a0,1452 # 6650 <malloc+0xc30>
    20ac:	00004097          	auipc	ra,0x4
    20b0:	8bc080e7          	jalr	-1860(ra) # 5968 <printf>
      exit(1);
    20b4:	4505                	li	a0,1
    20b6:	00003097          	auipc	ra,0x3
    20ba:	542080e7          	jalr	1346(ra) # 55f8 <exit>
    printf("%s: wait got too many\n", s);
    20be:	85ce                	mv	a1,s3
    20c0:	00004517          	auipc	a0,0x4
    20c4:	5a850513          	add	a0,a0,1448 # 6668 <malloc+0xc48>
    20c8:	00004097          	auipc	ra,0x4
    20cc:	8a0080e7          	jalr	-1888(ra) # 5968 <printf>
    exit(1);
    20d0:	4505                	li	a0,1
    20d2:	00003097          	auipc	ra,0x3
    20d6:	526080e7          	jalr	1318(ra) # 55f8 <exit>

00000000000020da <kernmem>:
{
    20da:	715d                	add	sp,sp,-80
    20dc:	e486                	sd	ra,72(sp)
    20de:	e0a2                	sd	s0,64(sp)
    20e0:	fc26                	sd	s1,56(sp)
    20e2:	f84a                	sd	s2,48(sp)
    20e4:	f44e                	sd	s3,40(sp)
    20e6:	f052                	sd	s4,32(sp)
    20e8:	ec56                	sd	s5,24(sp)
    20ea:	0880                	add	s0,sp,80
    20ec:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20ee:	4485                	li	s1,1
    20f0:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f2:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f4:	69b1                	lui	s3,0xc
    20f6:	35098993          	add	s3,s3,848 # c350 <buf+0x880>
    20fa:	1003d937          	lui	s2,0x1003d
    20fe:	090e                	sll	s2,s2,0x3
    2100:	48090913          	add	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e9a0>
    pid = fork();
    2104:	00003097          	auipc	ra,0x3
    2108:	4ec080e7          	jalr	1260(ra) # 55f0 <fork>
    if(pid < 0){
    210c:	02054963          	bltz	a0,213e <kernmem+0x64>
    if(pid == 0){
    2110:	c529                	beqz	a0,215a <kernmem+0x80>
    wait(&xstatus);
    2112:	fbc40513          	add	a0,s0,-68
    2116:	00003097          	auipc	ra,0x3
    211a:	4ea080e7          	jalr	1258(ra) # 5600 <wait>
    if(xstatus != -1)  // did kernel kill child?
    211e:	fbc42783          	lw	a5,-68(s0)
    2122:	05579d63          	bne	a5,s5,217c <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2126:	94ce                	add	s1,s1,s3
    2128:	fd249ee3          	bne	s1,s2,2104 <kernmem+0x2a>
}
    212c:	60a6                	ld	ra,72(sp)
    212e:	6406                	ld	s0,64(sp)
    2130:	74e2                	ld	s1,56(sp)
    2132:	7942                	ld	s2,48(sp)
    2134:	79a2                	ld	s3,40(sp)
    2136:	7a02                	ld	s4,32(sp)
    2138:	6ae2                	ld	s5,24(sp)
    213a:	6161                	add	sp,sp,80
    213c:	8082                	ret
      printf("%s: fork failed\n", s);
    213e:	85d2                	mv	a1,s4
    2140:	00004517          	auipc	a0,0x4
    2144:	25850513          	add	a0,a0,600 # 6398 <malloc+0x978>
    2148:	00004097          	auipc	ra,0x4
    214c:	820080e7          	jalr	-2016(ra) # 5968 <printf>
      exit(1);
    2150:	4505                	li	a0,1
    2152:	00003097          	auipc	ra,0x3
    2156:	4a6080e7          	jalr	1190(ra) # 55f8 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215a:	0004c683          	lbu	a3,0(s1)
    215e:	8626                	mv	a2,s1
    2160:	85d2                	mv	a1,s4
    2162:	00004517          	auipc	a0,0x4
    2166:	51e50513          	add	a0,a0,1310 # 6680 <malloc+0xc60>
    216a:	00003097          	auipc	ra,0x3
    216e:	7fe080e7          	jalr	2046(ra) # 5968 <printf>
      exit(1);
    2172:	4505                	li	a0,1
    2174:	00003097          	auipc	ra,0x3
    2178:	484080e7          	jalr	1156(ra) # 55f8 <exit>
      exit(1);
    217c:	4505                	li	a0,1
    217e:	00003097          	auipc	ra,0x3
    2182:	47a080e7          	jalr	1146(ra) # 55f8 <exit>

0000000000002186 <bigargtest>:
{
    2186:	7179                	add	sp,sp,-48
    2188:	f406                	sd	ra,40(sp)
    218a:	f022                	sd	s0,32(sp)
    218c:	ec26                	sd	s1,24(sp)
    218e:	1800                	add	s0,sp,48
    2190:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2192:	00004517          	auipc	a0,0x4
    2196:	50e50513          	add	a0,a0,1294 # 66a0 <malloc+0xc80>
    219a:	00003097          	auipc	ra,0x3
    219e:	4ae080e7          	jalr	1198(ra) # 5648 <unlink>
  pid = fork();
    21a2:	00003097          	auipc	ra,0x3
    21a6:	44e080e7          	jalr	1102(ra) # 55f0 <fork>
  if(pid == 0){
    21aa:	c121                	beqz	a0,21ea <bigargtest+0x64>
  } else if(pid < 0){
    21ac:	0a054063          	bltz	a0,224c <bigargtest+0xc6>
  wait(&xstatus);
    21b0:	fdc40513          	add	a0,s0,-36
    21b4:	00003097          	auipc	ra,0x3
    21b8:	44c080e7          	jalr	1100(ra) # 5600 <wait>
  if(xstatus != 0)
    21bc:	fdc42503          	lw	a0,-36(s0)
    21c0:	e545                	bnez	a0,2268 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c2:	4581                	li	a1,0
    21c4:	00004517          	auipc	a0,0x4
    21c8:	4dc50513          	add	a0,a0,1244 # 66a0 <malloc+0xc80>
    21cc:	00003097          	auipc	ra,0x3
    21d0:	46c080e7          	jalr	1132(ra) # 5638 <open>
  if(fd < 0){
    21d4:	08054e63          	bltz	a0,2270 <bigargtest+0xea>
  close(fd);
    21d8:	00003097          	auipc	ra,0x3
    21dc:	448080e7          	jalr	1096(ra) # 5620 <close>
}
    21e0:	70a2                	ld	ra,40(sp)
    21e2:	7402                	ld	s0,32(sp)
    21e4:	64e2                	ld	s1,24(sp)
    21e6:	6145                	add	sp,sp,48
    21e8:	8082                	ret
    21ea:	00006797          	auipc	a5,0x6
    21ee:	0ce78793          	add	a5,a5,206 # 82b8 <args.1>
    21f2:	00006697          	auipc	a3,0x6
    21f6:	1be68693          	add	a3,a3,446 # 83b0 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fa:	00004717          	auipc	a4,0x4
    21fe:	4b670713          	add	a4,a4,1206 # 66b0 <malloc+0xc90>
    2202:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2204:	07a1                	add	a5,a5,8
    2206:	fed79ee3          	bne	a5,a3,2202 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220a:	00006597          	auipc	a1,0x6
    220e:	0ae58593          	add	a1,a1,174 # 82b8 <args.1>
    2212:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2216:	00004517          	auipc	a0,0x4
    221a:	92a50513          	add	a0,a0,-1750 # 5b40 <malloc+0x120>
    221e:	00003097          	auipc	ra,0x3
    2222:	412080e7          	jalr	1042(ra) # 5630 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2226:	20000593          	li	a1,512
    222a:	00004517          	auipc	a0,0x4
    222e:	47650513          	add	a0,a0,1142 # 66a0 <malloc+0xc80>
    2232:	00003097          	auipc	ra,0x3
    2236:	406080e7          	jalr	1030(ra) # 5638 <open>
    close(fd);
    223a:	00003097          	auipc	ra,0x3
    223e:	3e6080e7          	jalr	998(ra) # 5620 <close>
    exit(0);
    2242:	4501                	li	a0,0
    2244:	00003097          	auipc	ra,0x3
    2248:	3b4080e7          	jalr	948(ra) # 55f8 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224c:	85a6                	mv	a1,s1
    224e:	00004517          	auipc	a0,0x4
    2252:	54250513          	add	a0,a0,1346 # 6790 <malloc+0xd70>
    2256:	00003097          	auipc	ra,0x3
    225a:	712080e7          	jalr	1810(ra) # 5968 <printf>
    exit(1);
    225e:	4505                	li	a0,1
    2260:	00003097          	auipc	ra,0x3
    2264:	398080e7          	jalr	920(ra) # 55f8 <exit>
    exit(xstatus);
    2268:	00003097          	auipc	ra,0x3
    226c:	390080e7          	jalr	912(ra) # 55f8 <exit>
    printf("%s: bigarg test failed!\n", s);
    2270:	85a6                	mv	a1,s1
    2272:	00004517          	auipc	a0,0x4
    2276:	53e50513          	add	a0,a0,1342 # 67b0 <malloc+0xd90>
    227a:	00003097          	auipc	ra,0x3
    227e:	6ee080e7          	jalr	1774(ra) # 5968 <printf>
    exit(1);
    2282:	4505                	li	a0,1
    2284:	00003097          	auipc	ra,0x3
    2288:	374080e7          	jalr	884(ra) # 55f8 <exit>

000000000000228c <stacktest>:
{
    228c:	7179                	add	sp,sp,-48
    228e:	f406                	sd	ra,40(sp)
    2290:	f022                	sd	s0,32(sp)
    2292:	ec26                	sd	s1,24(sp)
    2294:	1800                	add	s0,sp,48
    2296:	84aa                	mv	s1,a0
  pid = fork();
    2298:	00003097          	auipc	ra,0x3
    229c:	358080e7          	jalr	856(ra) # 55f0 <fork>
  if(pid == 0) {
    22a0:	c115                	beqz	a0,22c4 <stacktest+0x38>
  } else if(pid < 0){
    22a2:	04054463          	bltz	a0,22ea <stacktest+0x5e>
  wait(&xstatus);
    22a6:	fdc40513          	add	a0,s0,-36
    22aa:	00003097          	auipc	ra,0x3
    22ae:	356080e7          	jalr	854(ra) # 5600 <wait>
  if(xstatus == -1)  // kernel killed child?
    22b2:	fdc42503          	lw	a0,-36(s0)
    22b6:	57fd                	li	a5,-1
    22b8:	04f50763          	beq	a0,a5,2306 <stacktest+0x7a>
    exit(xstatus);
    22bc:	00003097          	auipc	ra,0x3
    22c0:	33c080e7          	jalr	828(ra) # 55f8 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c4:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c6:	77fd                	lui	a5,0xfffff
    22c8:	97ba                	add	a5,a5,a4
    22ca:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0520>
    22ce:	85a6                	mv	a1,s1
    22d0:	00004517          	auipc	a0,0x4
    22d4:	50050513          	add	a0,a0,1280 # 67d0 <malloc+0xdb0>
    22d8:	00003097          	auipc	ra,0x3
    22dc:	690080e7          	jalr	1680(ra) # 5968 <printf>
    exit(1);
    22e0:	4505                	li	a0,1
    22e2:	00003097          	auipc	ra,0x3
    22e6:	316080e7          	jalr	790(ra) # 55f8 <exit>
    printf("%s: fork failed\n", s);
    22ea:	85a6                	mv	a1,s1
    22ec:	00004517          	auipc	a0,0x4
    22f0:	0ac50513          	add	a0,a0,172 # 6398 <malloc+0x978>
    22f4:	00003097          	auipc	ra,0x3
    22f8:	674080e7          	jalr	1652(ra) # 5968 <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	00003097          	auipc	ra,0x3
    2302:	2fa080e7          	jalr	762(ra) # 55f8 <exit>
    exit(0);
    2306:	4501                	li	a0,0
    2308:	00003097          	auipc	ra,0x3
    230c:	2f0080e7          	jalr	752(ra) # 55f8 <exit>

0000000000002310 <copyinstr3>:
{
    2310:	7179                	add	sp,sp,-48
    2312:	f406                	sd	ra,40(sp)
    2314:	f022                	sd	s0,32(sp)
    2316:	ec26                	sd	s1,24(sp)
    2318:	1800                	add	s0,sp,48
  sbrk(8192);
    231a:	6509                	lui	a0,0x2
    231c:	00003097          	auipc	ra,0x3
    2320:	364080e7          	jalr	868(ra) # 5680 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2324:	4501                	li	a0,0
    2326:	00003097          	auipc	ra,0x3
    232a:	35a080e7          	jalr	858(ra) # 5680 <sbrk>
  if((top % PGSIZE) != 0){
    232e:	03451793          	sll	a5,a0,0x34
    2332:	e3c9                	bnez	a5,23b4 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2334:	4501                	li	a0,0
    2336:	00003097          	auipc	ra,0x3
    233a:	34a080e7          	jalr	842(ra) # 5680 <sbrk>
  if(top % PGSIZE){
    233e:	03451793          	sll	a5,a0,0x34
    2342:	e3d9                	bnez	a5,23c8 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2344:	fff50493          	add	s1,a0,-1 # 1fff <forktest+0x5>
  *b = 'x';
    2348:	07800793          	li	a5,120
    234c:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2350:	8526                	mv	a0,s1
    2352:	00003097          	auipc	ra,0x3
    2356:	2f6080e7          	jalr	758(ra) # 5648 <unlink>
  if(ret != -1){
    235a:	57fd                	li	a5,-1
    235c:	08f51363          	bne	a0,a5,23e2 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2360:	20100593          	li	a1,513
    2364:	8526                	mv	a0,s1
    2366:	00003097          	auipc	ra,0x3
    236a:	2d2080e7          	jalr	722(ra) # 5638 <open>
  if(fd != -1){
    236e:	57fd                	li	a5,-1
    2370:	08f51863          	bne	a0,a5,2400 <copyinstr3+0xf0>
  ret = link(b, b);
    2374:	85a6                	mv	a1,s1
    2376:	8526                	mv	a0,s1
    2378:	00003097          	auipc	ra,0x3
    237c:	2e0080e7          	jalr	736(ra) # 5658 <link>
  if(ret != -1){
    2380:	57fd                	li	a5,-1
    2382:	08f51e63          	bne	a0,a5,241e <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2386:	00005797          	auipc	a5,0x5
    238a:	0f278793          	add	a5,a5,242 # 7478 <malloc+0x1a58>
    238e:	fcf43823          	sd	a5,-48(s0)
    2392:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2396:	fd040593          	add	a1,s0,-48
    239a:	8526                	mv	a0,s1
    239c:	00003097          	auipc	ra,0x3
    23a0:	294080e7          	jalr	660(ra) # 5630 <exec>
  if(ret != -1){
    23a4:	57fd                	li	a5,-1
    23a6:	08f51c63          	bne	a0,a5,243e <copyinstr3+0x12e>
}
    23aa:	70a2                	ld	ra,40(sp)
    23ac:	7402                	ld	s0,32(sp)
    23ae:	64e2                	ld	s1,24(sp)
    23b0:	6145                	add	sp,sp,48
    23b2:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b4:	0347d513          	srl	a0,a5,0x34
    23b8:	6785                	lui	a5,0x1
    23ba:	40a7853b          	subw	a0,a5,a0
    23be:	00003097          	auipc	ra,0x3
    23c2:	2c2080e7          	jalr	706(ra) # 5680 <sbrk>
    23c6:	b7bd                	j	2334 <copyinstr3+0x24>
    printf("oops\n");
    23c8:	00004517          	auipc	a0,0x4
    23cc:	43050513          	add	a0,a0,1072 # 67f8 <malloc+0xdd8>
    23d0:	00003097          	auipc	ra,0x3
    23d4:	598080e7          	jalr	1432(ra) # 5968 <printf>
    exit(1);
    23d8:	4505                	li	a0,1
    23da:	00003097          	auipc	ra,0x3
    23de:	21e080e7          	jalr	542(ra) # 55f8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e2:	862a                	mv	a2,a0
    23e4:	85a6                	mv	a1,s1
    23e6:	00004517          	auipc	a0,0x4
    23ea:	ed250513          	add	a0,a0,-302 # 62b8 <malloc+0x898>
    23ee:	00003097          	auipc	ra,0x3
    23f2:	57a080e7          	jalr	1402(ra) # 5968 <printf>
    exit(1);
    23f6:	4505                	li	a0,1
    23f8:	00003097          	auipc	ra,0x3
    23fc:	200080e7          	jalr	512(ra) # 55f8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2400:	862a                	mv	a2,a0
    2402:	85a6                	mv	a1,s1
    2404:	00004517          	auipc	a0,0x4
    2408:	ed450513          	add	a0,a0,-300 # 62d8 <malloc+0x8b8>
    240c:	00003097          	auipc	ra,0x3
    2410:	55c080e7          	jalr	1372(ra) # 5968 <printf>
    exit(1);
    2414:	4505                	li	a0,1
    2416:	00003097          	auipc	ra,0x3
    241a:	1e2080e7          	jalr	482(ra) # 55f8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    241e:	86aa                	mv	a3,a0
    2420:	8626                	mv	a2,s1
    2422:	85a6                	mv	a1,s1
    2424:	00004517          	auipc	a0,0x4
    2428:	ed450513          	add	a0,a0,-300 # 62f8 <malloc+0x8d8>
    242c:	00003097          	auipc	ra,0x3
    2430:	53c080e7          	jalr	1340(ra) # 5968 <printf>
    exit(1);
    2434:	4505                	li	a0,1
    2436:	00003097          	auipc	ra,0x3
    243a:	1c2080e7          	jalr	450(ra) # 55f8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    243e:	567d                	li	a2,-1
    2440:	85a6                	mv	a1,s1
    2442:	00004517          	auipc	a0,0x4
    2446:	ede50513          	add	a0,a0,-290 # 6320 <malloc+0x900>
    244a:	00003097          	auipc	ra,0x3
    244e:	51e080e7          	jalr	1310(ra) # 5968 <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	00003097          	auipc	ra,0x3
    2458:	1a4080e7          	jalr	420(ra) # 55f8 <exit>

000000000000245c <rwsbrk>:
{
    245c:	1101                	add	sp,sp,-32
    245e:	ec06                	sd	ra,24(sp)
    2460:	e822                	sd	s0,16(sp)
    2462:	e426                	sd	s1,8(sp)
    2464:	e04a                	sd	s2,0(sp)
    2466:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2468:	6509                	lui	a0,0x2
    246a:	00003097          	auipc	ra,0x3
    246e:	216080e7          	jalr	534(ra) # 5680 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2472:	57fd                	li	a5,-1
    2474:	06f50263          	beq	a0,a5,24d8 <rwsbrk+0x7c>
    2478:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247a:	7579                	lui	a0,0xffffe
    247c:	00003097          	auipc	ra,0x3
    2480:	204080e7          	jalr	516(ra) # 5680 <sbrk>
    2484:	57fd                	li	a5,-1
    2486:	06f50663          	beq	a0,a5,24f2 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248a:	20100593          	li	a1,513
    248e:	00004517          	auipc	a0,0x4
    2492:	3aa50513          	add	a0,a0,938 # 6838 <malloc+0xe18>
    2496:	00003097          	auipc	ra,0x3
    249a:	1a2080e7          	jalr	418(ra) # 5638 <open>
    249e:	892a                	mv	s2,a0
  if(fd < 0){
    24a0:	06054663          	bltz	a0,250c <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    24a4:	6785                	lui	a5,0x1
    24a6:	94be                	add	s1,s1,a5
    24a8:	40000613          	li	a2,1024
    24ac:	85a6                	mv	a1,s1
    24ae:	00003097          	auipc	ra,0x3
    24b2:	16a080e7          	jalr	362(ra) # 5618 <write>
    24b6:	862a                	mv	a2,a0
  if(n >= 0){
    24b8:	06054763          	bltz	a0,2526 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24bc:	85a6                	mv	a1,s1
    24be:	00004517          	auipc	a0,0x4
    24c2:	39a50513          	add	a0,a0,922 # 6858 <malloc+0xe38>
    24c6:	00003097          	auipc	ra,0x3
    24ca:	4a2080e7          	jalr	1186(ra) # 5968 <printf>
    exit(1);
    24ce:	4505                	li	a0,1
    24d0:	00003097          	auipc	ra,0x3
    24d4:	128080e7          	jalr	296(ra) # 55f8 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24d8:	00004517          	auipc	a0,0x4
    24dc:	32850513          	add	a0,a0,808 # 6800 <malloc+0xde0>
    24e0:	00003097          	auipc	ra,0x3
    24e4:	488080e7          	jalr	1160(ra) # 5968 <printf>
    exit(1);
    24e8:	4505                	li	a0,1
    24ea:	00003097          	auipc	ra,0x3
    24ee:	10e080e7          	jalr	270(ra) # 55f8 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f2:	00004517          	auipc	a0,0x4
    24f6:	32650513          	add	a0,a0,806 # 6818 <malloc+0xdf8>
    24fa:	00003097          	auipc	ra,0x3
    24fe:	46e080e7          	jalr	1134(ra) # 5968 <printf>
    exit(1);
    2502:	4505                	li	a0,1
    2504:	00003097          	auipc	ra,0x3
    2508:	0f4080e7          	jalr	244(ra) # 55f8 <exit>
    printf("open(rwsbrk) failed\n");
    250c:	00004517          	auipc	a0,0x4
    2510:	33450513          	add	a0,a0,820 # 6840 <malloc+0xe20>
    2514:	00003097          	auipc	ra,0x3
    2518:	454080e7          	jalr	1108(ra) # 5968 <printf>
    exit(1);
    251c:	4505                	li	a0,1
    251e:	00003097          	auipc	ra,0x3
    2522:	0da080e7          	jalr	218(ra) # 55f8 <exit>
  close(fd);
    2526:	854a                	mv	a0,s2
    2528:	00003097          	auipc	ra,0x3
    252c:	0f8080e7          	jalr	248(ra) # 5620 <close>
  unlink("rwsbrk");
    2530:	00004517          	auipc	a0,0x4
    2534:	30850513          	add	a0,a0,776 # 6838 <malloc+0xe18>
    2538:	00003097          	auipc	ra,0x3
    253c:	110080e7          	jalr	272(ra) # 5648 <unlink>
  fd = open("README", O_RDONLY);
    2540:	4581                	li	a1,0
    2542:	00003517          	auipc	a0,0x3
    2546:	7a650513          	add	a0,a0,1958 # 5ce8 <malloc+0x2c8>
    254a:	00003097          	auipc	ra,0x3
    254e:	0ee080e7          	jalr	238(ra) # 5638 <open>
    2552:	892a                	mv	s2,a0
  if(fd < 0){
    2554:	02054963          	bltz	a0,2586 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2558:	4629                	li	a2,10
    255a:	85a6                	mv	a1,s1
    255c:	00003097          	auipc	ra,0x3
    2560:	0b4080e7          	jalr	180(ra) # 5610 <read>
    2564:	862a                	mv	a2,a0
  if(n >= 0){
    2566:	02054d63          	bltz	a0,25a0 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256a:	85a6                	mv	a1,s1
    256c:	00004517          	auipc	a0,0x4
    2570:	31c50513          	add	a0,a0,796 # 6888 <malloc+0xe68>
    2574:	00003097          	auipc	ra,0x3
    2578:	3f4080e7          	jalr	1012(ra) # 5968 <printf>
    exit(1);
    257c:	4505                	li	a0,1
    257e:	00003097          	auipc	ra,0x3
    2582:	07a080e7          	jalr	122(ra) # 55f8 <exit>
    printf("open(rwsbrk) failed\n");
    2586:	00004517          	auipc	a0,0x4
    258a:	2ba50513          	add	a0,a0,698 # 6840 <malloc+0xe20>
    258e:	00003097          	auipc	ra,0x3
    2592:	3da080e7          	jalr	986(ra) # 5968 <printf>
    exit(1);
    2596:	4505                	li	a0,1
    2598:	00003097          	auipc	ra,0x3
    259c:	060080e7          	jalr	96(ra) # 55f8 <exit>
  close(fd);
    25a0:	854a                	mv	a0,s2
    25a2:	00003097          	auipc	ra,0x3
    25a6:	07e080e7          	jalr	126(ra) # 5620 <close>
  exit(0);
    25aa:	4501                	li	a0,0
    25ac:	00003097          	auipc	ra,0x3
    25b0:	04c080e7          	jalr	76(ra) # 55f8 <exit>

00000000000025b4 <sbrkbasic>:
{
    25b4:	7139                	add	sp,sp,-64
    25b6:	fc06                	sd	ra,56(sp)
    25b8:	f822                	sd	s0,48(sp)
    25ba:	f426                	sd	s1,40(sp)
    25bc:	f04a                	sd	s2,32(sp)
    25be:	ec4e                	sd	s3,24(sp)
    25c0:	e852                	sd	s4,16(sp)
    25c2:	0080                	add	s0,sp,64
    25c4:	8a2a                	mv	s4,a0
  pid = fork();
    25c6:	00003097          	auipc	ra,0x3
    25ca:	02a080e7          	jalr	42(ra) # 55f0 <fork>
  if(pid < 0){
    25ce:	02054c63          	bltz	a0,2606 <sbrkbasic+0x52>
  if(pid == 0){
    25d2:	ed21                	bnez	a0,262a <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d4:	40000537          	lui	a0,0x40000
    25d8:	00003097          	auipc	ra,0x3
    25dc:	0a8080e7          	jalr	168(ra) # 5680 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e0:	57fd                	li	a5,-1
    25e2:	02f50f63          	beq	a0,a5,2620 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25e6:	400007b7          	lui	a5,0x40000
    25ea:	97aa                	add	a5,a5,a0
      *b = 99;
    25ec:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f0:	6705                	lui	a4,0x1
      *b = 99;
    25f2:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1520>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f6:	953a                	add	a0,a0,a4
    25f8:	fef51de3          	bne	a0,a5,25f2 <sbrkbasic+0x3e>
    exit(1);
    25fc:	4505                	li	a0,1
    25fe:	00003097          	auipc	ra,0x3
    2602:	ffa080e7          	jalr	-6(ra) # 55f8 <exit>
    printf("fork failed in sbrkbasic\n");
    2606:	00004517          	auipc	a0,0x4
    260a:	2aa50513          	add	a0,a0,682 # 68b0 <malloc+0xe90>
    260e:	00003097          	auipc	ra,0x3
    2612:	35a080e7          	jalr	858(ra) # 5968 <printf>
    exit(1);
    2616:	4505                	li	a0,1
    2618:	00003097          	auipc	ra,0x3
    261c:	fe0080e7          	jalr	-32(ra) # 55f8 <exit>
      exit(0);
    2620:	4501                	li	a0,0
    2622:	00003097          	auipc	ra,0x3
    2626:	fd6080e7          	jalr	-42(ra) # 55f8 <exit>
  wait(&xstatus);
    262a:	fcc40513          	add	a0,s0,-52
    262e:	00003097          	auipc	ra,0x3
    2632:	fd2080e7          	jalr	-46(ra) # 5600 <wait>
  if(xstatus == 1){
    2636:	fcc42703          	lw	a4,-52(s0)
    263a:	4785                	li	a5,1
    263c:	00f70d63          	beq	a4,a5,2656 <sbrkbasic+0xa2>
  a = sbrk(0);
    2640:	4501                	li	a0,0
    2642:	00003097          	auipc	ra,0x3
    2646:	03e080e7          	jalr	62(ra) # 5680 <sbrk>
    264a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    264c:	4901                	li	s2,0
    264e:	6985                	lui	s3,0x1
    2650:	38898993          	add	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    2654:	a005                	j	2674 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2656:	85d2                	mv	a1,s4
    2658:	00004517          	auipc	a0,0x4
    265c:	27850513          	add	a0,a0,632 # 68d0 <malloc+0xeb0>
    2660:	00003097          	auipc	ra,0x3
    2664:	308080e7          	jalr	776(ra) # 5968 <printf>
    exit(1);
    2668:	4505                	li	a0,1
    266a:	00003097          	auipc	ra,0x3
    266e:	f8e080e7          	jalr	-114(ra) # 55f8 <exit>
    a = b + 1;
    2672:	84be                	mv	s1,a5
    b = sbrk(1);
    2674:	4505                	li	a0,1
    2676:	00003097          	auipc	ra,0x3
    267a:	00a080e7          	jalr	10(ra) # 5680 <sbrk>
    if(b != a){
    267e:	04951c63          	bne	a0,s1,26d6 <sbrkbasic+0x122>
    *b = 1;
    2682:	4785                	li	a5,1
    2684:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2688:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    268c:	2905                	addw	s2,s2,1
    268e:	ff3912e3          	bne	s2,s3,2672 <sbrkbasic+0xbe>
  pid = fork();
    2692:	00003097          	auipc	ra,0x3
    2696:	f5e080e7          	jalr	-162(ra) # 55f0 <fork>
    269a:	892a                	mv	s2,a0
  if(pid < 0){
    269c:	04054d63          	bltz	a0,26f6 <sbrkbasic+0x142>
  c = sbrk(1);
    26a0:	4505                	li	a0,1
    26a2:	00003097          	auipc	ra,0x3
    26a6:	fde080e7          	jalr	-34(ra) # 5680 <sbrk>
  c = sbrk(1);
    26aa:	4505                	li	a0,1
    26ac:	00003097          	auipc	ra,0x3
    26b0:	fd4080e7          	jalr	-44(ra) # 5680 <sbrk>
  if(c != a + 1){
    26b4:	0489                	add	s1,s1,2
    26b6:	04a48e63          	beq	s1,a0,2712 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26ba:	85d2                	mv	a1,s4
    26bc:	00004517          	auipc	a0,0x4
    26c0:	27450513          	add	a0,a0,628 # 6930 <malloc+0xf10>
    26c4:	00003097          	auipc	ra,0x3
    26c8:	2a4080e7          	jalr	676(ra) # 5968 <printf>
    exit(1);
    26cc:	4505                	li	a0,1
    26ce:	00003097          	auipc	ra,0x3
    26d2:	f2a080e7          	jalr	-214(ra) # 55f8 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26d6:	86aa                	mv	a3,a0
    26d8:	8626                	mv	a2,s1
    26da:	85ca                	mv	a1,s2
    26dc:	00004517          	auipc	a0,0x4
    26e0:	21450513          	add	a0,a0,532 # 68f0 <malloc+0xed0>
    26e4:	00003097          	auipc	ra,0x3
    26e8:	284080e7          	jalr	644(ra) # 5968 <printf>
      exit(1);
    26ec:	4505                	li	a0,1
    26ee:	00003097          	auipc	ra,0x3
    26f2:	f0a080e7          	jalr	-246(ra) # 55f8 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26f6:	85d2                	mv	a1,s4
    26f8:	00004517          	auipc	a0,0x4
    26fc:	21850513          	add	a0,a0,536 # 6910 <malloc+0xef0>
    2700:	00003097          	auipc	ra,0x3
    2704:	268080e7          	jalr	616(ra) # 5968 <printf>
    exit(1);
    2708:	4505                	li	a0,1
    270a:	00003097          	auipc	ra,0x3
    270e:	eee080e7          	jalr	-274(ra) # 55f8 <exit>
  if(pid == 0)
    2712:	00091763          	bnez	s2,2720 <sbrkbasic+0x16c>
    exit(0);
    2716:	4501                	li	a0,0
    2718:	00003097          	auipc	ra,0x3
    271c:	ee0080e7          	jalr	-288(ra) # 55f8 <exit>
  wait(&xstatus);
    2720:	fcc40513          	add	a0,s0,-52
    2724:	00003097          	auipc	ra,0x3
    2728:	edc080e7          	jalr	-292(ra) # 5600 <wait>
  exit(xstatus);
    272c:	fcc42503          	lw	a0,-52(s0)
    2730:	00003097          	auipc	ra,0x3
    2734:	ec8080e7          	jalr	-312(ra) # 55f8 <exit>

0000000000002738 <sbrkmuch>:
{
    2738:	7179                	add	sp,sp,-48
    273a:	f406                	sd	ra,40(sp)
    273c:	f022                	sd	s0,32(sp)
    273e:	ec26                	sd	s1,24(sp)
    2740:	e84a                	sd	s2,16(sp)
    2742:	e44e                	sd	s3,8(sp)
    2744:	e052                	sd	s4,0(sp)
    2746:	1800                	add	s0,sp,48
    2748:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    274a:	4501                	li	a0,0
    274c:	00003097          	auipc	ra,0x3
    2750:	f34080e7          	jalr	-204(ra) # 5680 <sbrk>
    2754:	892a                	mv	s2,a0
  a = sbrk(0);
    2756:	4501                	li	a0,0
    2758:	00003097          	auipc	ra,0x3
    275c:	f28080e7          	jalr	-216(ra) # 5680 <sbrk>
    2760:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2762:	06400537          	lui	a0,0x6400
    2766:	9d05                	subw	a0,a0,s1
    2768:	00003097          	auipc	ra,0x3
    276c:	f18080e7          	jalr	-232(ra) # 5680 <sbrk>
  if (p != a) {
    2770:	0ca49863          	bne	s1,a0,2840 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2774:	4501                	li	a0,0
    2776:	00003097          	auipc	ra,0x3
    277a:	f0a080e7          	jalr	-246(ra) # 5680 <sbrk>
    277e:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2780:	00a4f963          	bgeu	s1,a0,2792 <sbrkmuch+0x5a>
    *pp = 1;
    2784:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2786:	6705                	lui	a4,0x1
    *pp = 1;
    2788:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    278c:	94ba                	add	s1,s1,a4
    278e:	fef4ede3          	bltu	s1,a5,2788 <sbrkmuch+0x50>
  *lastaddr = 99;
    2792:	064007b7          	lui	a5,0x6400
    2796:	06300713          	li	a4,99
    279a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f151f>
  a = sbrk(0);
    279e:	4501                	li	a0,0
    27a0:	00003097          	auipc	ra,0x3
    27a4:	ee0080e7          	jalr	-288(ra) # 5680 <sbrk>
    27a8:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27aa:	757d                	lui	a0,0xfffff
    27ac:	00003097          	auipc	ra,0x3
    27b0:	ed4080e7          	jalr	-300(ra) # 5680 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b4:	57fd                	li	a5,-1
    27b6:	0af50363          	beq	a0,a5,285c <sbrkmuch+0x124>
  c = sbrk(0);
    27ba:	4501                	li	a0,0
    27bc:	00003097          	auipc	ra,0x3
    27c0:	ec4080e7          	jalr	-316(ra) # 5680 <sbrk>
  if(c != a - PGSIZE){
    27c4:	77fd                	lui	a5,0xfffff
    27c6:	97a6                	add	a5,a5,s1
    27c8:	0af51863          	bne	a0,a5,2878 <sbrkmuch+0x140>
  a = sbrk(0);
    27cc:	4501                	li	a0,0
    27ce:	00003097          	auipc	ra,0x3
    27d2:	eb2080e7          	jalr	-334(ra) # 5680 <sbrk>
    27d6:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27d8:	6505                	lui	a0,0x1
    27da:	00003097          	auipc	ra,0x3
    27de:	ea6080e7          	jalr	-346(ra) # 5680 <sbrk>
    27e2:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e4:	0aa49a63          	bne	s1,a0,2898 <sbrkmuch+0x160>
    27e8:	4501                	li	a0,0
    27ea:	00003097          	auipc	ra,0x3
    27ee:	e96080e7          	jalr	-362(ra) # 5680 <sbrk>
    27f2:	6785                	lui	a5,0x1
    27f4:	97a6                	add	a5,a5,s1
    27f6:	0af51163          	bne	a0,a5,2898 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27fa:	064007b7          	lui	a5,0x6400
    27fe:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f151f>
    2802:	06300793          	li	a5,99
    2806:	0af70963          	beq	a4,a5,28b8 <sbrkmuch+0x180>
  a = sbrk(0);
    280a:	4501                	li	a0,0
    280c:	00003097          	auipc	ra,0x3
    2810:	e74080e7          	jalr	-396(ra) # 5680 <sbrk>
    2814:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2816:	4501                	li	a0,0
    2818:	00003097          	auipc	ra,0x3
    281c:	e68080e7          	jalr	-408(ra) # 5680 <sbrk>
    2820:	40a9053b          	subw	a0,s2,a0
    2824:	00003097          	auipc	ra,0x3
    2828:	e5c080e7          	jalr	-420(ra) # 5680 <sbrk>
  if(c != a){
    282c:	0aa49463          	bne	s1,a0,28d4 <sbrkmuch+0x19c>
}
    2830:	70a2                	ld	ra,40(sp)
    2832:	7402                	ld	s0,32(sp)
    2834:	64e2                	ld	s1,24(sp)
    2836:	6942                	ld	s2,16(sp)
    2838:	69a2                	ld	s3,8(sp)
    283a:	6a02                	ld	s4,0(sp)
    283c:	6145                	add	sp,sp,48
    283e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2840:	85ce                	mv	a1,s3
    2842:	00004517          	auipc	a0,0x4
    2846:	10e50513          	add	a0,a0,270 # 6950 <malloc+0xf30>
    284a:	00003097          	auipc	ra,0x3
    284e:	11e080e7          	jalr	286(ra) # 5968 <printf>
    exit(1);
    2852:	4505                	li	a0,1
    2854:	00003097          	auipc	ra,0x3
    2858:	da4080e7          	jalr	-604(ra) # 55f8 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    285c:	85ce                	mv	a1,s3
    285e:	00004517          	auipc	a0,0x4
    2862:	13a50513          	add	a0,a0,314 # 6998 <malloc+0xf78>
    2866:	00003097          	auipc	ra,0x3
    286a:	102080e7          	jalr	258(ra) # 5968 <printf>
    exit(1);
    286e:	4505                	li	a0,1
    2870:	00003097          	auipc	ra,0x3
    2874:	d88080e7          	jalr	-632(ra) # 55f8 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2878:	86aa                	mv	a3,a0
    287a:	8626                	mv	a2,s1
    287c:	85ce                	mv	a1,s3
    287e:	00004517          	auipc	a0,0x4
    2882:	13a50513          	add	a0,a0,314 # 69b8 <malloc+0xf98>
    2886:	00003097          	auipc	ra,0x3
    288a:	0e2080e7          	jalr	226(ra) # 5968 <printf>
    exit(1);
    288e:	4505                	li	a0,1
    2890:	00003097          	auipc	ra,0x3
    2894:	d68080e7          	jalr	-664(ra) # 55f8 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2898:	86d2                	mv	a3,s4
    289a:	8626                	mv	a2,s1
    289c:	85ce                	mv	a1,s3
    289e:	00004517          	auipc	a0,0x4
    28a2:	15a50513          	add	a0,a0,346 # 69f8 <malloc+0xfd8>
    28a6:	00003097          	auipc	ra,0x3
    28aa:	0c2080e7          	jalr	194(ra) # 5968 <printf>
    exit(1);
    28ae:	4505                	li	a0,1
    28b0:	00003097          	auipc	ra,0x3
    28b4:	d48080e7          	jalr	-696(ra) # 55f8 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28b8:	85ce                	mv	a1,s3
    28ba:	00004517          	auipc	a0,0x4
    28be:	16e50513          	add	a0,a0,366 # 6a28 <malloc+0x1008>
    28c2:	00003097          	auipc	ra,0x3
    28c6:	0a6080e7          	jalr	166(ra) # 5968 <printf>
    exit(1);
    28ca:	4505                	li	a0,1
    28cc:	00003097          	auipc	ra,0x3
    28d0:	d2c080e7          	jalr	-724(ra) # 55f8 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d4:	86aa                	mv	a3,a0
    28d6:	8626                	mv	a2,s1
    28d8:	85ce                	mv	a1,s3
    28da:	00004517          	auipc	a0,0x4
    28de:	18650513          	add	a0,a0,390 # 6a60 <malloc+0x1040>
    28e2:	00003097          	auipc	ra,0x3
    28e6:	086080e7          	jalr	134(ra) # 5968 <printf>
    exit(1);
    28ea:	4505                	li	a0,1
    28ec:	00003097          	auipc	ra,0x3
    28f0:	d0c080e7          	jalr	-756(ra) # 55f8 <exit>

00000000000028f4 <sbrkarg>:
{
    28f4:	7179                	add	sp,sp,-48
    28f6:	f406                	sd	ra,40(sp)
    28f8:	f022                	sd	s0,32(sp)
    28fa:	ec26                	sd	s1,24(sp)
    28fc:	e84a                	sd	s2,16(sp)
    28fe:	e44e                	sd	s3,8(sp)
    2900:	1800                	add	s0,sp,48
    2902:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2904:	6505                	lui	a0,0x1
    2906:	00003097          	auipc	ra,0x3
    290a:	d7a080e7          	jalr	-646(ra) # 5680 <sbrk>
    290e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2910:	20100593          	li	a1,513
    2914:	00004517          	auipc	a0,0x4
    2918:	17450513          	add	a0,a0,372 # 6a88 <malloc+0x1068>
    291c:	00003097          	auipc	ra,0x3
    2920:	d1c080e7          	jalr	-740(ra) # 5638 <open>
    2924:	84aa                	mv	s1,a0
  unlink("sbrk");
    2926:	00004517          	auipc	a0,0x4
    292a:	16250513          	add	a0,a0,354 # 6a88 <malloc+0x1068>
    292e:	00003097          	auipc	ra,0x3
    2932:	d1a080e7          	jalr	-742(ra) # 5648 <unlink>
  if(fd < 0)  {
    2936:	0404c163          	bltz	s1,2978 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    293a:	6605                	lui	a2,0x1
    293c:	85ca                	mv	a1,s2
    293e:	8526                	mv	a0,s1
    2940:	00003097          	auipc	ra,0x3
    2944:	cd8080e7          	jalr	-808(ra) # 5618 <write>
    2948:	04054663          	bltz	a0,2994 <sbrkarg+0xa0>
  close(fd);
    294c:	8526                	mv	a0,s1
    294e:	00003097          	auipc	ra,0x3
    2952:	cd2080e7          	jalr	-814(ra) # 5620 <close>
  a = sbrk(PGSIZE);
    2956:	6505                	lui	a0,0x1
    2958:	00003097          	auipc	ra,0x3
    295c:	d28080e7          	jalr	-728(ra) # 5680 <sbrk>
  if(pipe((int *) a) != 0){
    2960:	00003097          	auipc	ra,0x3
    2964:	ca8080e7          	jalr	-856(ra) # 5608 <pipe>
    2968:	e521                	bnez	a0,29b0 <sbrkarg+0xbc>
}
    296a:	70a2                	ld	ra,40(sp)
    296c:	7402                	ld	s0,32(sp)
    296e:	64e2                	ld	s1,24(sp)
    2970:	6942                	ld	s2,16(sp)
    2972:	69a2                	ld	s3,8(sp)
    2974:	6145                	add	sp,sp,48
    2976:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2978:	85ce                	mv	a1,s3
    297a:	00004517          	auipc	a0,0x4
    297e:	11650513          	add	a0,a0,278 # 6a90 <malloc+0x1070>
    2982:	00003097          	auipc	ra,0x3
    2986:	fe6080e7          	jalr	-26(ra) # 5968 <printf>
    exit(1);
    298a:	4505                	li	a0,1
    298c:	00003097          	auipc	ra,0x3
    2990:	c6c080e7          	jalr	-916(ra) # 55f8 <exit>
    printf("%s: write sbrk failed\n", s);
    2994:	85ce                	mv	a1,s3
    2996:	00004517          	auipc	a0,0x4
    299a:	11250513          	add	a0,a0,274 # 6aa8 <malloc+0x1088>
    299e:	00003097          	auipc	ra,0x3
    29a2:	fca080e7          	jalr	-54(ra) # 5968 <printf>
    exit(1);
    29a6:	4505                	li	a0,1
    29a8:	00003097          	auipc	ra,0x3
    29ac:	c50080e7          	jalr	-944(ra) # 55f8 <exit>
    printf("%s: pipe() failed\n", s);
    29b0:	85ce                	mv	a1,s3
    29b2:	00004517          	auipc	a0,0x4
    29b6:	aee50513          	add	a0,a0,-1298 # 64a0 <malloc+0xa80>
    29ba:	00003097          	auipc	ra,0x3
    29be:	fae080e7          	jalr	-82(ra) # 5968 <printf>
    exit(1);
    29c2:	4505                	li	a0,1
    29c4:	00003097          	auipc	ra,0x3
    29c8:	c34080e7          	jalr	-972(ra) # 55f8 <exit>

00000000000029cc <argptest>:
{
    29cc:	1101                	add	sp,sp,-32
    29ce:	ec06                	sd	ra,24(sp)
    29d0:	e822                	sd	s0,16(sp)
    29d2:	e426                	sd	s1,8(sp)
    29d4:	e04a                	sd	s2,0(sp)
    29d6:	1000                	add	s0,sp,32
    29d8:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29da:	4581                	li	a1,0
    29dc:	00004517          	auipc	a0,0x4
    29e0:	0e450513          	add	a0,a0,228 # 6ac0 <malloc+0x10a0>
    29e4:	00003097          	auipc	ra,0x3
    29e8:	c54080e7          	jalr	-940(ra) # 5638 <open>
  if (fd < 0) {
    29ec:	02054b63          	bltz	a0,2a22 <argptest+0x56>
    29f0:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f2:	4501                	li	a0,0
    29f4:	00003097          	auipc	ra,0x3
    29f8:	c8c080e7          	jalr	-884(ra) # 5680 <sbrk>
    29fc:	567d                	li	a2,-1
    29fe:	fff50593          	add	a1,a0,-1
    2a02:	8526                	mv	a0,s1
    2a04:	00003097          	auipc	ra,0x3
    2a08:	c0c080e7          	jalr	-1012(ra) # 5610 <read>
  close(fd);
    2a0c:	8526                	mv	a0,s1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	c12080e7          	jalr	-1006(ra) # 5620 <close>
}
    2a16:	60e2                	ld	ra,24(sp)
    2a18:	6442                	ld	s0,16(sp)
    2a1a:	64a2                	ld	s1,8(sp)
    2a1c:	6902                	ld	s2,0(sp)
    2a1e:	6105                	add	sp,sp,32
    2a20:	8082                	ret
    printf("%s: open failed\n", s);
    2a22:	85ca                	mv	a1,s2
    2a24:	00004517          	auipc	a0,0x4
    2a28:	98c50513          	add	a0,a0,-1652 # 63b0 <malloc+0x990>
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	f3c080e7          	jalr	-196(ra) # 5968 <printf>
    exit(1);
    2a34:	4505                	li	a0,1
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	bc2080e7          	jalr	-1086(ra) # 55f8 <exit>

0000000000002a3e <sbrkbugs>:
{
    2a3e:	1141                	add	sp,sp,-16
    2a40:	e406                	sd	ra,8(sp)
    2a42:	e022                	sd	s0,0(sp)
    2a44:	0800                	add	s0,sp,16
  int pid = fork();
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	baa080e7          	jalr	-1110(ra) # 55f0 <fork>
  if(pid < 0){
    2a4e:	02054263          	bltz	a0,2a72 <sbrkbugs+0x34>
  if(pid == 0){
    2a52:	ed0d                	bnez	a0,2a8c <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a54:	00003097          	auipc	ra,0x3
    2a58:	c2c080e7          	jalr	-980(ra) # 5680 <sbrk>
    sbrk(-sz);
    2a5c:	40a0053b          	negw	a0,a0
    2a60:	00003097          	auipc	ra,0x3
    2a64:	c20080e7          	jalr	-992(ra) # 5680 <sbrk>
    exit(0);
    2a68:	4501                	li	a0,0
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	b8e080e7          	jalr	-1138(ra) # 55f8 <exit>
    printf("fork failed\n");
    2a72:	00004517          	auipc	a0,0x4
    2a76:	d2e50513          	add	a0,a0,-722 # 67a0 <malloc+0xd80>
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	eee080e7          	jalr	-274(ra) # 5968 <printf>
    exit(1);
    2a82:	4505                	li	a0,1
    2a84:	00003097          	auipc	ra,0x3
    2a88:	b74080e7          	jalr	-1164(ra) # 55f8 <exit>
  wait(0);
    2a8c:	4501                	li	a0,0
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	b72080e7          	jalr	-1166(ra) # 5600 <wait>
  pid = fork();
    2a96:	00003097          	auipc	ra,0x3
    2a9a:	b5a080e7          	jalr	-1190(ra) # 55f0 <fork>
  if(pid < 0){
    2a9e:	02054563          	bltz	a0,2ac8 <sbrkbugs+0x8a>
  if(pid == 0){
    2aa2:	e121                	bnez	a0,2ae2 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	bdc080e7          	jalr	-1060(ra) # 5680 <sbrk>
    sbrk(-(sz - 3500));
    2aac:	6785                	lui	a5,0x1
    2aae:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x96>
    2ab2:	40a7853b          	subw	a0,a5,a0
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	bca080e7          	jalr	-1078(ra) # 5680 <sbrk>
    exit(0);
    2abe:	4501                	li	a0,0
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	b38080e7          	jalr	-1224(ra) # 55f8 <exit>
    printf("fork failed\n");
    2ac8:	00004517          	auipc	a0,0x4
    2acc:	cd850513          	add	a0,a0,-808 # 67a0 <malloc+0xd80>
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	e98080e7          	jalr	-360(ra) # 5968 <printf>
    exit(1);
    2ad8:	4505                	li	a0,1
    2ada:	00003097          	auipc	ra,0x3
    2ade:	b1e080e7          	jalr	-1250(ra) # 55f8 <exit>
  wait(0);
    2ae2:	4501                	li	a0,0
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	b1c080e7          	jalr	-1252(ra) # 5600 <wait>
  pid = fork();
    2aec:	00003097          	auipc	ra,0x3
    2af0:	b04080e7          	jalr	-1276(ra) # 55f0 <fork>
  if(pid < 0){
    2af4:	02054a63          	bltz	a0,2b28 <sbrkbugs+0xea>
  if(pid == 0){
    2af8:	e529                	bnez	a0,2b42 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2afa:	00003097          	auipc	ra,0x3
    2afe:	b86080e7          	jalr	-1146(ra) # 5680 <sbrk>
    2b02:	67ad                	lui	a5,0xb
    2b04:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1440>
    2b08:	40a7853b          	subw	a0,a5,a0
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	b74080e7          	jalr	-1164(ra) # 5680 <sbrk>
    sbrk(-10);
    2b14:	5559                	li	a0,-10
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	b6a080e7          	jalr	-1174(ra) # 5680 <sbrk>
    exit(0);
    2b1e:	4501                	li	a0,0
    2b20:	00003097          	auipc	ra,0x3
    2b24:	ad8080e7          	jalr	-1320(ra) # 55f8 <exit>
    printf("fork failed\n");
    2b28:	00004517          	auipc	a0,0x4
    2b2c:	c7850513          	add	a0,a0,-904 # 67a0 <malloc+0xd80>
    2b30:	00003097          	auipc	ra,0x3
    2b34:	e38080e7          	jalr	-456(ra) # 5968 <printf>
    exit(1);
    2b38:	4505                	li	a0,1
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	abe080e7          	jalr	-1346(ra) # 55f8 <exit>
  wait(0);
    2b42:	4501                	li	a0,0
    2b44:	00003097          	auipc	ra,0x3
    2b48:	abc080e7          	jalr	-1348(ra) # 5600 <wait>
  exit(0);
    2b4c:	4501                	li	a0,0
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	aaa080e7          	jalr	-1366(ra) # 55f8 <exit>

0000000000002b56 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b56:	715d                	add	sp,sp,-80
    2b58:	e486                	sd	ra,72(sp)
    2b5a:	e0a2                	sd	s0,64(sp)
    2b5c:	fc26                	sd	s1,56(sp)
    2b5e:	f84a                	sd	s2,48(sp)
    2b60:	f44e                	sd	s3,40(sp)
    2b62:	f052                	sd	s4,32(sp)
    2b64:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b66:	4901                	li	s2,0
    2b68:	49bd                	li	s3,15
    int pid = fork();
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	a86080e7          	jalr	-1402(ra) # 55f0 <fork>
    2b72:	84aa                	mv	s1,a0
    if(pid < 0){
    2b74:	02054063          	bltz	a0,2b94 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b78:	c91d                	beqz	a0,2bae <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b7a:	4501                	li	a0,0
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	a84080e7          	jalr	-1404(ra) # 5600 <wait>
  for(int avail = 0; avail < 15; avail++){
    2b84:	2905                	addw	s2,s2,1
    2b86:	ff3912e3          	bne	s2,s3,2b6a <execout+0x14>
    }
  }

  exit(0);
    2b8a:	4501                	li	a0,0
    2b8c:	00003097          	auipc	ra,0x3
    2b90:	a6c080e7          	jalr	-1428(ra) # 55f8 <exit>
      printf("fork failed\n");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	c0c50513          	add	a0,a0,-1012 # 67a0 <malloc+0xd80>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	dcc080e7          	jalr	-564(ra) # 5968 <printf>
      exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	a52080e7          	jalr	-1454(ra) # 55f8 <exit>
        if(a == 0xffffffffffffffffLL)
    2bae:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb0:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb2:	6505                	lui	a0,0x1
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	acc080e7          	jalr	-1332(ra) # 5680 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bbc:	01350763          	beq	a0,s3,2bca <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc0:	6785                	lui	a5,0x1
    2bc2:	97aa                	add	a5,a5,a0
    2bc4:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x9d>
      while(1){
    2bc8:	b7ed                	j	2bb2 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bca:	01205a63          	blez	s2,2bde <execout+0x88>
        sbrk(-4096);
    2bce:	757d                	lui	a0,0xfffff
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	ab0080e7          	jalr	-1360(ra) # 5680 <sbrk>
      for(int i = 0; i < avail; i++)
    2bd8:	2485                	addw	s1,s1,1
    2bda:	ff249ae3          	bne	s1,s2,2bce <execout+0x78>
      close(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	a40080e7          	jalr	-1472(ra) # 5620 <close>
      char *args[] = { "echo", "x", 0 };
    2be8:	00003517          	auipc	a0,0x3
    2bec:	f5850513          	add	a0,a0,-168 # 5b40 <malloc+0x120>
    2bf0:	faa43c23          	sd	a0,-72(s0)
    2bf4:	00003797          	auipc	a5,0x3
    2bf8:	fbc78793          	add	a5,a5,-68 # 5bb0 <malloc+0x190>
    2bfc:	fcf43023          	sd	a5,-64(s0)
    2c00:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c04:	fb840593          	add	a1,s0,-72
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	a28080e7          	jalr	-1496(ra) # 5630 <exec>
      exit(0);
    2c10:	4501                	li	a0,0
    2c12:	00003097          	auipc	ra,0x3
    2c16:	9e6080e7          	jalr	-1562(ra) # 55f8 <exit>

0000000000002c1a <fourteen>:
{
    2c1a:	1101                	add	sp,sp,-32
    2c1c:	ec06                	sd	ra,24(sp)
    2c1e:	e822                	sd	s0,16(sp)
    2c20:	e426                	sd	s1,8(sp)
    2c22:	1000                	add	s0,sp,32
    2c24:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	07250513          	add	a0,a0,114 # 6c98 <malloc+0x1278>
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	a32080e7          	jalr	-1486(ra) # 5660 <mkdir>
    2c36:	e165                	bnez	a0,2d16 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c38:	00004517          	auipc	a0,0x4
    2c3c:	eb850513          	add	a0,a0,-328 # 6af0 <malloc+0x10d0>
    2c40:	00003097          	auipc	ra,0x3
    2c44:	a20080e7          	jalr	-1504(ra) # 5660 <mkdir>
    2c48:	e56d                	bnez	a0,2d32 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c4a:	20000593          	li	a1,512
    2c4e:	00004517          	auipc	a0,0x4
    2c52:	efa50513          	add	a0,a0,-262 # 6b48 <malloc+0x1128>
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	9e2080e7          	jalr	-1566(ra) # 5638 <open>
  if(fd < 0){
    2c5e:	0e054863          	bltz	a0,2d4e <fourteen+0x134>
  close(fd);
    2c62:	00003097          	auipc	ra,0x3
    2c66:	9be080e7          	jalr	-1602(ra) # 5620 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c6a:	4581                	li	a1,0
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	f5450513          	add	a0,a0,-172 # 6bc0 <malloc+0x11a0>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	9c4080e7          	jalr	-1596(ra) # 5638 <open>
  if(fd < 0){
    2c7c:	0e054763          	bltz	a0,2d6a <fourteen+0x150>
  close(fd);
    2c80:	00003097          	auipc	ra,0x3
    2c84:	9a0080e7          	jalr	-1632(ra) # 5620 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c88:	00004517          	auipc	a0,0x4
    2c8c:	fa850513          	add	a0,a0,-88 # 6c30 <malloc+0x1210>
    2c90:	00003097          	auipc	ra,0x3
    2c94:	9d0080e7          	jalr	-1584(ra) # 5660 <mkdir>
    2c98:	c57d                	beqz	a0,2d86 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c9a:	00004517          	auipc	a0,0x4
    2c9e:	fee50513          	add	a0,a0,-18 # 6c88 <malloc+0x1268>
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	9be080e7          	jalr	-1602(ra) # 5660 <mkdir>
    2caa:	cd65                	beqz	a0,2da2 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	fdc50513          	add	a0,a0,-36 # 6c88 <malloc+0x1268>
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	994080e7          	jalr	-1644(ra) # 5648 <unlink>
  unlink("12345678901234/12345678901234");
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	f7450513          	add	a0,a0,-140 # 6c30 <malloc+0x1210>
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	984080e7          	jalr	-1660(ra) # 5648 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	ef450513          	add	a0,a0,-268 # 6bc0 <malloc+0x11a0>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	974080e7          	jalr	-1676(ra) # 5648 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2cdc:	00004517          	auipc	a0,0x4
    2ce0:	e6c50513          	add	a0,a0,-404 # 6b48 <malloc+0x1128>
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	964080e7          	jalr	-1692(ra) # 5648 <unlink>
  unlink("12345678901234/123456789012345");
    2cec:	00004517          	auipc	a0,0x4
    2cf0:	e0450513          	add	a0,a0,-508 # 6af0 <malloc+0x10d0>
    2cf4:	00003097          	auipc	ra,0x3
    2cf8:	954080e7          	jalr	-1708(ra) # 5648 <unlink>
  unlink("12345678901234");
    2cfc:	00004517          	auipc	a0,0x4
    2d00:	f9c50513          	add	a0,a0,-100 # 6c98 <malloc+0x1278>
    2d04:	00003097          	auipc	ra,0x3
    2d08:	944080e7          	jalr	-1724(ra) # 5648 <unlink>
}
    2d0c:	60e2                	ld	ra,24(sp)
    2d0e:	6442                	ld	s0,16(sp)
    2d10:	64a2                	ld	s1,8(sp)
    2d12:	6105                	add	sp,sp,32
    2d14:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d16:	85a6                	mv	a1,s1
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	db050513          	add	a0,a0,-592 # 6ac8 <malloc+0x10a8>
    2d20:	00003097          	auipc	ra,0x3
    2d24:	c48080e7          	jalr	-952(ra) # 5968 <printf>
    exit(1);
    2d28:	4505                	li	a0,1
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	8ce080e7          	jalr	-1842(ra) # 55f8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d32:	85a6                	mv	a1,s1
    2d34:	00004517          	auipc	a0,0x4
    2d38:	ddc50513          	add	a0,a0,-548 # 6b10 <malloc+0x10f0>
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	c2c080e7          	jalr	-980(ra) # 5968 <printf>
    exit(1);
    2d44:	4505                	li	a0,1
    2d46:	00003097          	auipc	ra,0x3
    2d4a:	8b2080e7          	jalr	-1870(ra) # 55f8 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d4e:	85a6                	mv	a1,s1
    2d50:	00004517          	auipc	a0,0x4
    2d54:	e2850513          	add	a0,a0,-472 # 6b78 <malloc+0x1158>
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	c10080e7          	jalr	-1008(ra) # 5968 <printf>
    exit(1);
    2d60:	4505                	li	a0,1
    2d62:	00003097          	auipc	ra,0x3
    2d66:	896080e7          	jalr	-1898(ra) # 55f8 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d6a:	85a6                	mv	a1,s1
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	e8450513          	add	a0,a0,-380 # 6bf0 <malloc+0x11d0>
    2d74:	00003097          	auipc	ra,0x3
    2d78:	bf4080e7          	jalr	-1036(ra) # 5968 <printf>
    exit(1);
    2d7c:	4505                	li	a0,1
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	87a080e7          	jalr	-1926(ra) # 55f8 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d86:	85a6                	mv	a1,s1
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	ec850513          	add	a0,a0,-312 # 6c50 <malloc+0x1230>
    2d90:	00003097          	auipc	ra,0x3
    2d94:	bd8080e7          	jalr	-1064(ra) # 5968 <printf>
    exit(1);
    2d98:	4505                	li	a0,1
    2d9a:	00003097          	auipc	ra,0x3
    2d9e:	85e080e7          	jalr	-1954(ra) # 55f8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da2:	85a6                	mv	a1,s1
    2da4:	00004517          	auipc	a0,0x4
    2da8:	f0450513          	add	a0,a0,-252 # 6ca8 <malloc+0x1288>
    2dac:	00003097          	auipc	ra,0x3
    2db0:	bbc080e7          	jalr	-1092(ra) # 5968 <printf>
    exit(1);
    2db4:	4505                	li	a0,1
    2db6:	00003097          	auipc	ra,0x3
    2dba:	842080e7          	jalr	-1982(ra) # 55f8 <exit>

0000000000002dbe <iputtest>:
{
    2dbe:	1101                	add	sp,sp,-32
    2dc0:	ec06                	sd	ra,24(sp)
    2dc2:	e822                	sd	s0,16(sp)
    2dc4:	e426                	sd	s1,8(sp)
    2dc6:	1000                	add	s0,sp,32
    2dc8:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dca:	00004517          	auipc	a0,0x4
    2dce:	f1650513          	add	a0,a0,-234 # 6ce0 <malloc+0x12c0>
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	88e080e7          	jalr	-1906(ra) # 5660 <mkdir>
    2dda:	04054563          	bltz	a0,2e24 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2dde:	00004517          	auipc	a0,0x4
    2de2:	f0250513          	add	a0,a0,-254 # 6ce0 <malloc+0x12c0>
    2de6:	00003097          	auipc	ra,0x3
    2dea:	882080e7          	jalr	-1918(ra) # 5668 <chdir>
    2dee:	04054963          	bltz	a0,2e40 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df2:	00004517          	auipc	a0,0x4
    2df6:	f2e50513          	add	a0,a0,-210 # 6d20 <malloc+0x1300>
    2dfa:	00003097          	auipc	ra,0x3
    2dfe:	84e080e7          	jalr	-1970(ra) # 5648 <unlink>
    2e02:	04054d63          	bltz	a0,2e5c <iputtest+0x9e>
  if(chdir("/") < 0){
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	f4a50513          	add	a0,a0,-182 # 6d50 <malloc+0x1330>
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	85a080e7          	jalr	-1958(ra) # 5668 <chdir>
    2e16:	06054163          	bltz	a0,2e78 <iputtest+0xba>
}
    2e1a:	60e2                	ld	ra,24(sp)
    2e1c:	6442                	ld	s0,16(sp)
    2e1e:	64a2                	ld	s1,8(sp)
    2e20:	6105                	add	sp,sp,32
    2e22:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e24:	85a6                	mv	a1,s1
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	ec250513          	add	a0,a0,-318 # 6ce8 <malloc+0x12c8>
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	b3a080e7          	jalr	-1222(ra) # 5968 <printf>
    exit(1);
    2e36:	4505                	li	a0,1
    2e38:	00002097          	auipc	ra,0x2
    2e3c:	7c0080e7          	jalr	1984(ra) # 55f8 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e40:	85a6                	mv	a1,s1
    2e42:	00004517          	auipc	a0,0x4
    2e46:	ebe50513          	add	a0,a0,-322 # 6d00 <malloc+0x12e0>
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	b1e080e7          	jalr	-1250(ra) # 5968 <printf>
    exit(1);
    2e52:	4505                	li	a0,1
    2e54:	00002097          	auipc	ra,0x2
    2e58:	7a4080e7          	jalr	1956(ra) # 55f8 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e5c:	85a6                	mv	a1,s1
    2e5e:	00004517          	auipc	a0,0x4
    2e62:	ed250513          	add	a0,a0,-302 # 6d30 <malloc+0x1310>
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	b02080e7          	jalr	-1278(ra) # 5968 <printf>
    exit(1);
    2e6e:	4505                	li	a0,1
    2e70:	00002097          	auipc	ra,0x2
    2e74:	788080e7          	jalr	1928(ra) # 55f8 <exit>
    printf("%s: chdir / failed\n", s);
    2e78:	85a6                	mv	a1,s1
    2e7a:	00004517          	auipc	a0,0x4
    2e7e:	ede50513          	add	a0,a0,-290 # 6d58 <malloc+0x1338>
    2e82:	00003097          	auipc	ra,0x3
    2e86:	ae6080e7          	jalr	-1306(ra) # 5968 <printf>
    exit(1);
    2e8a:	4505                	li	a0,1
    2e8c:	00002097          	auipc	ra,0x2
    2e90:	76c080e7          	jalr	1900(ra) # 55f8 <exit>

0000000000002e94 <exitiputtest>:
{
    2e94:	7179                	add	sp,sp,-48
    2e96:	f406                	sd	ra,40(sp)
    2e98:	f022                	sd	s0,32(sp)
    2e9a:	ec26                	sd	s1,24(sp)
    2e9c:	1800                	add	s0,sp,48
    2e9e:	84aa                	mv	s1,a0
  pid = fork();
    2ea0:	00002097          	auipc	ra,0x2
    2ea4:	750080e7          	jalr	1872(ra) # 55f0 <fork>
  if(pid < 0){
    2ea8:	04054663          	bltz	a0,2ef4 <exitiputtest+0x60>
  if(pid == 0){
    2eac:	ed45                	bnez	a0,2f64 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eae:	00004517          	auipc	a0,0x4
    2eb2:	e3250513          	add	a0,a0,-462 # 6ce0 <malloc+0x12c0>
    2eb6:	00002097          	auipc	ra,0x2
    2eba:	7aa080e7          	jalr	1962(ra) # 5660 <mkdir>
    2ebe:	04054963          	bltz	a0,2f10 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	e1e50513          	add	a0,a0,-482 # 6ce0 <malloc+0x12c0>
    2eca:	00002097          	auipc	ra,0x2
    2ece:	79e080e7          	jalr	1950(ra) # 5668 <chdir>
    2ed2:	04054d63          	bltz	a0,2f2c <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2ed6:	00004517          	auipc	a0,0x4
    2eda:	e4a50513          	add	a0,a0,-438 # 6d20 <malloc+0x1300>
    2ede:	00002097          	auipc	ra,0x2
    2ee2:	76a080e7          	jalr	1898(ra) # 5648 <unlink>
    2ee6:	06054163          	bltz	a0,2f48 <exitiputtest+0xb4>
    exit(0);
    2eea:	4501                	li	a0,0
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	70c080e7          	jalr	1804(ra) # 55f8 <exit>
    printf("%s: fork failed\n", s);
    2ef4:	85a6                	mv	a1,s1
    2ef6:	00003517          	auipc	a0,0x3
    2efa:	4a250513          	add	a0,a0,1186 # 6398 <malloc+0x978>
    2efe:	00003097          	auipc	ra,0x3
    2f02:	a6a080e7          	jalr	-1430(ra) # 5968 <printf>
    exit(1);
    2f06:	4505                	li	a0,1
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	6f0080e7          	jalr	1776(ra) # 55f8 <exit>
      printf("%s: mkdir failed\n", s);
    2f10:	85a6                	mv	a1,s1
    2f12:	00004517          	auipc	a0,0x4
    2f16:	dd650513          	add	a0,a0,-554 # 6ce8 <malloc+0x12c8>
    2f1a:	00003097          	auipc	ra,0x3
    2f1e:	a4e080e7          	jalr	-1458(ra) # 5968 <printf>
      exit(1);
    2f22:	4505                	li	a0,1
    2f24:	00002097          	auipc	ra,0x2
    2f28:	6d4080e7          	jalr	1748(ra) # 55f8 <exit>
      printf("%s: child chdir failed\n", s);
    2f2c:	85a6                	mv	a1,s1
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	e4250513          	add	a0,a0,-446 # 6d70 <malloc+0x1350>
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	a32080e7          	jalr	-1486(ra) # 5968 <printf>
      exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00002097          	auipc	ra,0x2
    2f44:	6b8080e7          	jalr	1720(ra) # 55f8 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f48:	85a6                	mv	a1,s1
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	de650513          	add	a0,a0,-538 # 6d30 <malloc+0x1310>
    2f52:	00003097          	auipc	ra,0x3
    2f56:	a16080e7          	jalr	-1514(ra) # 5968 <printf>
      exit(1);
    2f5a:	4505                	li	a0,1
    2f5c:	00002097          	auipc	ra,0x2
    2f60:	69c080e7          	jalr	1692(ra) # 55f8 <exit>
  wait(&xstatus);
    2f64:	fdc40513          	add	a0,s0,-36
    2f68:	00002097          	auipc	ra,0x2
    2f6c:	698080e7          	jalr	1688(ra) # 5600 <wait>
  exit(xstatus);
    2f70:	fdc42503          	lw	a0,-36(s0)
    2f74:	00002097          	auipc	ra,0x2
    2f78:	684080e7          	jalr	1668(ra) # 55f8 <exit>

0000000000002f7c <dirtest>:
{
    2f7c:	1101                	add	sp,sp,-32
    2f7e:	ec06                	sd	ra,24(sp)
    2f80:	e822                	sd	s0,16(sp)
    2f82:	e426                	sd	s1,8(sp)
    2f84:	1000                	add	s0,sp,32
    2f86:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f88:	00004517          	auipc	a0,0x4
    2f8c:	e0050513          	add	a0,a0,-512 # 6d88 <malloc+0x1368>
    2f90:	00002097          	auipc	ra,0x2
    2f94:	6d0080e7          	jalr	1744(ra) # 5660 <mkdir>
    2f98:	04054563          	bltz	a0,2fe2 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2f9c:	00004517          	auipc	a0,0x4
    2fa0:	dec50513          	add	a0,a0,-532 # 6d88 <malloc+0x1368>
    2fa4:	00002097          	auipc	ra,0x2
    2fa8:	6c4080e7          	jalr	1732(ra) # 5668 <chdir>
    2fac:	04054963          	bltz	a0,2ffe <dirtest+0x82>
  if(chdir("..") < 0){
    2fb0:	00004517          	auipc	a0,0x4
    2fb4:	df850513          	add	a0,a0,-520 # 6da8 <malloc+0x1388>
    2fb8:	00002097          	auipc	ra,0x2
    2fbc:	6b0080e7          	jalr	1712(ra) # 5668 <chdir>
    2fc0:	04054d63          	bltz	a0,301a <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc4:	00004517          	auipc	a0,0x4
    2fc8:	dc450513          	add	a0,a0,-572 # 6d88 <malloc+0x1368>
    2fcc:	00002097          	auipc	ra,0x2
    2fd0:	67c080e7          	jalr	1660(ra) # 5648 <unlink>
    2fd4:	06054163          	bltz	a0,3036 <dirtest+0xba>
}
    2fd8:	60e2                	ld	ra,24(sp)
    2fda:	6442                	ld	s0,16(sp)
    2fdc:	64a2                	ld	s1,8(sp)
    2fde:	6105                	add	sp,sp,32
    2fe0:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe2:	85a6                	mv	a1,s1
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	d0450513          	add	a0,a0,-764 # 6ce8 <malloc+0x12c8>
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	97c080e7          	jalr	-1668(ra) # 5968 <printf>
    exit(1);
    2ff4:	4505                	li	a0,1
    2ff6:	00002097          	auipc	ra,0x2
    2ffa:	602080e7          	jalr	1538(ra) # 55f8 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ffe:	85a6                	mv	a1,s1
    3000:	00004517          	auipc	a0,0x4
    3004:	d9050513          	add	a0,a0,-624 # 6d90 <malloc+0x1370>
    3008:	00003097          	auipc	ra,0x3
    300c:	960080e7          	jalr	-1696(ra) # 5968 <printf>
    exit(1);
    3010:	4505                	li	a0,1
    3012:	00002097          	auipc	ra,0x2
    3016:	5e6080e7          	jalr	1510(ra) # 55f8 <exit>
    printf("%s: chdir .. failed\n", s);
    301a:	85a6                	mv	a1,s1
    301c:	00004517          	auipc	a0,0x4
    3020:	d9450513          	add	a0,a0,-620 # 6db0 <malloc+0x1390>
    3024:	00003097          	auipc	ra,0x3
    3028:	944080e7          	jalr	-1724(ra) # 5968 <printf>
    exit(1);
    302c:	4505                	li	a0,1
    302e:	00002097          	auipc	ra,0x2
    3032:	5ca080e7          	jalr	1482(ra) # 55f8 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3036:	85a6                	mv	a1,s1
    3038:	00004517          	auipc	a0,0x4
    303c:	d9050513          	add	a0,a0,-624 # 6dc8 <malloc+0x13a8>
    3040:	00003097          	auipc	ra,0x3
    3044:	928080e7          	jalr	-1752(ra) # 5968 <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	00002097          	auipc	ra,0x2
    304e:	5ae080e7          	jalr	1454(ra) # 55f8 <exit>

0000000000003052 <subdir>:
{
    3052:	1101                	add	sp,sp,-32
    3054:	ec06                	sd	ra,24(sp)
    3056:	e822                	sd	s0,16(sp)
    3058:	e426                	sd	s1,8(sp)
    305a:	e04a                	sd	s2,0(sp)
    305c:	1000                	add	s0,sp,32
    305e:	892a                	mv	s2,a0
  unlink("ff");
    3060:	00004517          	auipc	a0,0x4
    3064:	eb050513          	add	a0,a0,-336 # 6f10 <malloc+0x14f0>
    3068:	00002097          	auipc	ra,0x2
    306c:	5e0080e7          	jalr	1504(ra) # 5648 <unlink>
  if(mkdir("dd") != 0){
    3070:	00004517          	auipc	a0,0x4
    3074:	d7050513          	add	a0,a0,-656 # 6de0 <malloc+0x13c0>
    3078:	00002097          	auipc	ra,0x2
    307c:	5e8080e7          	jalr	1512(ra) # 5660 <mkdir>
    3080:	38051663          	bnez	a0,340c <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3084:	20200593          	li	a1,514
    3088:	00004517          	auipc	a0,0x4
    308c:	d7850513          	add	a0,a0,-648 # 6e00 <malloc+0x13e0>
    3090:	00002097          	auipc	ra,0x2
    3094:	5a8080e7          	jalr	1448(ra) # 5638 <open>
    3098:	84aa                	mv	s1,a0
  if(fd < 0){
    309a:	38054763          	bltz	a0,3428 <subdir+0x3d6>
  write(fd, "ff", 2);
    309e:	4609                	li	a2,2
    30a0:	00004597          	auipc	a1,0x4
    30a4:	e7058593          	add	a1,a1,-400 # 6f10 <malloc+0x14f0>
    30a8:	00002097          	auipc	ra,0x2
    30ac:	570080e7          	jalr	1392(ra) # 5618 <write>
  close(fd);
    30b0:	8526                	mv	a0,s1
    30b2:	00002097          	auipc	ra,0x2
    30b6:	56e080e7          	jalr	1390(ra) # 5620 <close>
  if(unlink("dd") >= 0){
    30ba:	00004517          	auipc	a0,0x4
    30be:	d2650513          	add	a0,a0,-730 # 6de0 <malloc+0x13c0>
    30c2:	00002097          	auipc	ra,0x2
    30c6:	586080e7          	jalr	1414(ra) # 5648 <unlink>
    30ca:	36055d63          	bgez	a0,3444 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30ce:	00004517          	auipc	a0,0x4
    30d2:	d8a50513          	add	a0,a0,-630 # 6e58 <malloc+0x1438>
    30d6:	00002097          	auipc	ra,0x2
    30da:	58a080e7          	jalr	1418(ra) # 5660 <mkdir>
    30de:	38051163          	bnez	a0,3460 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e2:	20200593          	li	a1,514
    30e6:	00004517          	auipc	a0,0x4
    30ea:	d9a50513          	add	a0,a0,-614 # 6e80 <malloc+0x1460>
    30ee:	00002097          	auipc	ra,0x2
    30f2:	54a080e7          	jalr	1354(ra) # 5638 <open>
    30f6:	84aa                	mv	s1,a0
  if(fd < 0){
    30f8:	38054263          	bltz	a0,347c <subdir+0x42a>
  write(fd, "FF", 2);
    30fc:	4609                	li	a2,2
    30fe:	00004597          	auipc	a1,0x4
    3102:	db258593          	add	a1,a1,-590 # 6eb0 <malloc+0x1490>
    3106:	00002097          	auipc	ra,0x2
    310a:	512080e7          	jalr	1298(ra) # 5618 <write>
  close(fd);
    310e:	8526                	mv	a0,s1
    3110:	00002097          	auipc	ra,0x2
    3114:	510080e7          	jalr	1296(ra) # 5620 <close>
  fd = open("dd/dd/../ff", 0);
    3118:	4581                	li	a1,0
    311a:	00004517          	auipc	a0,0x4
    311e:	d9e50513          	add	a0,a0,-610 # 6eb8 <malloc+0x1498>
    3122:	00002097          	auipc	ra,0x2
    3126:	516080e7          	jalr	1302(ra) # 5638 <open>
    312a:	84aa                	mv	s1,a0
  if(fd < 0){
    312c:	36054663          	bltz	a0,3498 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3130:	660d                	lui	a2,0x3
    3132:	00009597          	auipc	a1,0x9
    3136:	99e58593          	add	a1,a1,-1634 # bad0 <buf>
    313a:	00002097          	auipc	ra,0x2
    313e:	4d6080e7          	jalr	1238(ra) # 5610 <read>
  if(cc != 2 || buf[0] != 'f'){
    3142:	4789                	li	a5,2
    3144:	36f51863          	bne	a0,a5,34b4 <subdir+0x462>
    3148:	00009717          	auipc	a4,0x9
    314c:	98874703          	lbu	a4,-1656(a4) # bad0 <buf>
    3150:	06600793          	li	a5,102
    3154:	36f71063          	bne	a4,a5,34b4 <subdir+0x462>
  close(fd);
    3158:	8526                	mv	a0,s1
    315a:	00002097          	auipc	ra,0x2
    315e:	4c6080e7          	jalr	1222(ra) # 5620 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3162:	00004597          	auipc	a1,0x4
    3166:	da658593          	add	a1,a1,-602 # 6f08 <malloc+0x14e8>
    316a:	00004517          	auipc	a0,0x4
    316e:	d1650513          	add	a0,a0,-746 # 6e80 <malloc+0x1460>
    3172:	00002097          	auipc	ra,0x2
    3176:	4e6080e7          	jalr	1254(ra) # 5658 <link>
    317a:	34051b63          	bnez	a0,34d0 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    317e:	00004517          	auipc	a0,0x4
    3182:	d0250513          	add	a0,a0,-766 # 6e80 <malloc+0x1460>
    3186:	00002097          	auipc	ra,0x2
    318a:	4c2080e7          	jalr	1218(ra) # 5648 <unlink>
    318e:	34051f63          	bnez	a0,34ec <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3192:	4581                	li	a1,0
    3194:	00004517          	auipc	a0,0x4
    3198:	cec50513          	add	a0,a0,-788 # 6e80 <malloc+0x1460>
    319c:	00002097          	auipc	ra,0x2
    31a0:	49c080e7          	jalr	1180(ra) # 5638 <open>
    31a4:	36055263          	bgez	a0,3508 <subdir+0x4b6>
  if(chdir("dd") != 0){
    31a8:	00004517          	auipc	a0,0x4
    31ac:	c3850513          	add	a0,a0,-968 # 6de0 <malloc+0x13c0>
    31b0:	00002097          	auipc	ra,0x2
    31b4:	4b8080e7          	jalr	1208(ra) # 5668 <chdir>
    31b8:	36051663          	bnez	a0,3524 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31bc:	00004517          	auipc	a0,0x4
    31c0:	de450513          	add	a0,a0,-540 # 6fa0 <malloc+0x1580>
    31c4:	00002097          	auipc	ra,0x2
    31c8:	4a4080e7          	jalr	1188(ra) # 5668 <chdir>
    31cc:	36051a63          	bnez	a0,3540 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d0:	00004517          	auipc	a0,0x4
    31d4:	e0050513          	add	a0,a0,-512 # 6fd0 <malloc+0x15b0>
    31d8:	00002097          	auipc	ra,0x2
    31dc:	490080e7          	jalr	1168(ra) # 5668 <chdir>
    31e0:	36051e63          	bnez	a0,355c <subdir+0x50a>
  if(chdir("./..") != 0){
    31e4:	00004517          	auipc	a0,0x4
    31e8:	e1c50513          	add	a0,a0,-484 # 7000 <malloc+0x15e0>
    31ec:	00002097          	auipc	ra,0x2
    31f0:	47c080e7          	jalr	1148(ra) # 5668 <chdir>
    31f4:	38051263          	bnez	a0,3578 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31f8:	4581                	li	a1,0
    31fa:	00004517          	auipc	a0,0x4
    31fe:	d0e50513          	add	a0,a0,-754 # 6f08 <malloc+0x14e8>
    3202:	00002097          	auipc	ra,0x2
    3206:	436080e7          	jalr	1078(ra) # 5638 <open>
    320a:	84aa                	mv	s1,a0
  if(fd < 0){
    320c:	38054463          	bltz	a0,3594 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3210:	660d                	lui	a2,0x3
    3212:	00009597          	auipc	a1,0x9
    3216:	8be58593          	add	a1,a1,-1858 # bad0 <buf>
    321a:	00002097          	auipc	ra,0x2
    321e:	3f6080e7          	jalr	1014(ra) # 5610 <read>
    3222:	4789                	li	a5,2
    3224:	38f51663          	bne	a0,a5,35b0 <subdir+0x55e>
  close(fd);
    3228:	8526                	mv	a0,s1
    322a:	00002097          	auipc	ra,0x2
    322e:	3f6080e7          	jalr	1014(ra) # 5620 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3232:	4581                	li	a1,0
    3234:	00004517          	auipc	a0,0x4
    3238:	c4c50513          	add	a0,a0,-948 # 6e80 <malloc+0x1460>
    323c:	00002097          	auipc	ra,0x2
    3240:	3fc080e7          	jalr	1020(ra) # 5638 <open>
    3244:	38055463          	bgez	a0,35cc <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3248:	20200593          	li	a1,514
    324c:	00004517          	auipc	a0,0x4
    3250:	e4450513          	add	a0,a0,-444 # 7090 <malloc+0x1670>
    3254:	00002097          	auipc	ra,0x2
    3258:	3e4080e7          	jalr	996(ra) # 5638 <open>
    325c:	38055663          	bgez	a0,35e8 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3260:	20200593          	li	a1,514
    3264:	00004517          	auipc	a0,0x4
    3268:	e5c50513          	add	a0,a0,-420 # 70c0 <malloc+0x16a0>
    326c:	00002097          	auipc	ra,0x2
    3270:	3cc080e7          	jalr	972(ra) # 5638 <open>
    3274:	38055863          	bgez	a0,3604 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3278:	20000593          	li	a1,512
    327c:	00004517          	auipc	a0,0x4
    3280:	b6450513          	add	a0,a0,-1180 # 6de0 <malloc+0x13c0>
    3284:	00002097          	auipc	ra,0x2
    3288:	3b4080e7          	jalr	948(ra) # 5638 <open>
    328c:	38055a63          	bgez	a0,3620 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3290:	4589                	li	a1,2
    3292:	00004517          	auipc	a0,0x4
    3296:	b4e50513          	add	a0,a0,-1202 # 6de0 <malloc+0x13c0>
    329a:	00002097          	auipc	ra,0x2
    329e:	39e080e7          	jalr	926(ra) # 5638 <open>
    32a2:	38055d63          	bgez	a0,363c <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32a6:	4585                	li	a1,1
    32a8:	00004517          	auipc	a0,0x4
    32ac:	b3850513          	add	a0,a0,-1224 # 6de0 <malloc+0x13c0>
    32b0:	00002097          	auipc	ra,0x2
    32b4:	388080e7          	jalr	904(ra) # 5638 <open>
    32b8:	3a055063          	bgez	a0,3658 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32bc:	00004597          	auipc	a1,0x4
    32c0:	e9458593          	add	a1,a1,-364 # 7150 <malloc+0x1730>
    32c4:	00004517          	auipc	a0,0x4
    32c8:	dcc50513          	add	a0,a0,-564 # 7090 <malloc+0x1670>
    32cc:	00002097          	auipc	ra,0x2
    32d0:	38c080e7          	jalr	908(ra) # 5658 <link>
    32d4:	3a050063          	beqz	a0,3674 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32d8:	00004597          	auipc	a1,0x4
    32dc:	e7858593          	add	a1,a1,-392 # 7150 <malloc+0x1730>
    32e0:	00004517          	auipc	a0,0x4
    32e4:	de050513          	add	a0,a0,-544 # 70c0 <malloc+0x16a0>
    32e8:	00002097          	auipc	ra,0x2
    32ec:	370080e7          	jalr	880(ra) # 5658 <link>
    32f0:	3a050063          	beqz	a0,3690 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f4:	00004597          	auipc	a1,0x4
    32f8:	c1458593          	add	a1,a1,-1004 # 6f08 <malloc+0x14e8>
    32fc:	00004517          	auipc	a0,0x4
    3300:	b0450513          	add	a0,a0,-1276 # 6e00 <malloc+0x13e0>
    3304:	00002097          	auipc	ra,0x2
    3308:	354080e7          	jalr	852(ra) # 5658 <link>
    330c:	3a050063          	beqz	a0,36ac <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3310:	00004517          	auipc	a0,0x4
    3314:	d8050513          	add	a0,a0,-640 # 7090 <malloc+0x1670>
    3318:	00002097          	auipc	ra,0x2
    331c:	348080e7          	jalr	840(ra) # 5660 <mkdir>
    3320:	3a050463          	beqz	a0,36c8 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3324:	00004517          	auipc	a0,0x4
    3328:	d9c50513          	add	a0,a0,-612 # 70c0 <malloc+0x16a0>
    332c:	00002097          	auipc	ra,0x2
    3330:	334080e7          	jalr	820(ra) # 5660 <mkdir>
    3334:	3a050863          	beqz	a0,36e4 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3338:	00004517          	auipc	a0,0x4
    333c:	bd050513          	add	a0,a0,-1072 # 6f08 <malloc+0x14e8>
    3340:	00002097          	auipc	ra,0x2
    3344:	320080e7          	jalr	800(ra) # 5660 <mkdir>
    3348:	3a050c63          	beqz	a0,3700 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    334c:	00004517          	auipc	a0,0x4
    3350:	d7450513          	add	a0,a0,-652 # 70c0 <malloc+0x16a0>
    3354:	00002097          	auipc	ra,0x2
    3358:	2f4080e7          	jalr	756(ra) # 5648 <unlink>
    335c:	3c050063          	beqz	a0,371c <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3360:	00004517          	auipc	a0,0x4
    3364:	d3050513          	add	a0,a0,-720 # 7090 <malloc+0x1670>
    3368:	00002097          	auipc	ra,0x2
    336c:	2e0080e7          	jalr	736(ra) # 5648 <unlink>
    3370:	3c050463          	beqz	a0,3738 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3374:	00004517          	auipc	a0,0x4
    3378:	a8c50513          	add	a0,a0,-1396 # 6e00 <malloc+0x13e0>
    337c:	00002097          	auipc	ra,0x2
    3380:	2ec080e7          	jalr	748(ra) # 5668 <chdir>
    3384:	3c050863          	beqz	a0,3754 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3388:	00004517          	auipc	a0,0x4
    338c:	f1850513          	add	a0,a0,-232 # 72a0 <malloc+0x1880>
    3390:	00002097          	auipc	ra,0x2
    3394:	2d8080e7          	jalr	728(ra) # 5668 <chdir>
    3398:	3c050c63          	beqz	a0,3770 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    339c:	00004517          	auipc	a0,0x4
    33a0:	b6c50513          	add	a0,a0,-1172 # 6f08 <malloc+0x14e8>
    33a4:	00002097          	auipc	ra,0x2
    33a8:	2a4080e7          	jalr	676(ra) # 5648 <unlink>
    33ac:	3e051063          	bnez	a0,378c <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b0:	00004517          	auipc	a0,0x4
    33b4:	a5050513          	add	a0,a0,-1456 # 6e00 <malloc+0x13e0>
    33b8:	00002097          	auipc	ra,0x2
    33bc:	290080e7          	jalr	656(ra) # 5648 <unlink>
    33c0:	3e051463          	bnez	a0,37a8 <subdir+0x756>
  if(unlink("dd") == 0){
    33c4:	00004517          	auipc	a0,0x4
    33c8:	a1c50513          	add	a0,a0,-1508 # 6de0 <malloc+0x13c0>
    33cc:	00002097          	auipc	ra,0x2
    33d0:	27c080e7          	jalr	636(ra) # 5648 <unlink>
    33d4:	3e050863          	beqz	a0,37c4 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33d8:	00004517          	auipc	a0,0x4
    33dc:	f3850513          	add	a0,a0,-200 # 7310 <malloc+0x18f0>
    33e0:	00002097          	auipc	ra,0x2
    33e4:	268080e7          	jalr	616(ra) # 5648 <unlink>
    33e8:	3e054c63          	bltz	a0,37e0 <subdir+0x78e>
  if(unlink("dd") < 0){
    33ec:	00004517          	auipc	a0,0x4
    33f0:	9f450513          	add	a0,a0,-1548 # 6de0 <malloc+0x13c0>
    33f4:	00002097          	auipc	ra,0x2
    33f8:	254080e7          	jalr	596(ra) # 5648 <unlink>
    33fc:	40054063          	bltz	a0,37fc <subdir+0x7aa>
}
    3400:	60e2                	ld	ra,24(sp)
    3402:	6442                	ld	s0,16(sp)
    3404:	64a2                	ld	s1,8(sp)
    3406:	6902                	ld	s2,0(sp)
    3408:	6105                	add	sp,sp,32
    340a:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    340c:	85ca                	mv	a1,s2
    340e:	00004517          	auipc	a0,0x4
    3412:	9da50513          	add	a0,a0,-1574 # 6de8 <malloc+0x13c8>
    3416:	00002097          	auipc	ra,0x2
    341a:	552080e7          	jalr	1362(ra) # 5968 <printf>
    exit(1);
    341e:	4505                	li	a0,1
    3420:	00002097          	auipc	ra,0x2
    3424:	1d8080e7          	jalr	472(ra) # 55f8 <exit>
    printf("%s: create dd/ff failed\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00004517          	auipc	a0,0x4
    342e:	9de50513          	add	a0,a0,-1570 # 6e08 <malloc+0x13e8>
    3432:	00002097          	auipc	ra,0x2
    3436:	536080e7          	jalr	1334(ra) # 5968 <printf>
    exit(1);
    343a:	4505                	li	a0,1
    343c:	00002097          	auipc	ra,0x2
    3440:	1bc080e7          	jalr	444(ra) # 55f8 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3444:	85ca                	mv	a1,s2
    3446:	00004517          	auipc	a0,0x4
    344a:	9e250513          	add	a0,a0,-1566 # 6e28 <malloc+0x1408>
    344e:	00002097          	auipc	ra,0x2
    3452:	51a080e7          	jalr	1306(ra) # 5968 <printf>
    exit(1);
    3456:	4505                	li	a0,1
    3458:	00002097          	auipc	ra,0x2
    345c:	1a0080e7          	jalr	416(ra) # 55f8 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3460:	85ca                	mv	a1,s2
    3462:	00004517          	auipc	a0,0x4
    3466:	9fe50513          	add	a0,a0,-1538 # 6e60 <malloc+0x1440>
    346a:	00002097          	auipc	ra,0x2
    346e:	4fe080e7          	jalr	1278(ra) # 5968 <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	00002097          	auipc	ra,0x2
    3478:	184080e7          	jalr	388(ra) # 55f8 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    347c:	85ca                	mv	a1,s2
    347e:	00004517          	auipc	a0,0x4
    3482:	a1250513          	add	a0,a0,-1518 # 6e90 <malloc+0x1470>
    3486:	00002097          	auipc	ra,0x2
    348a:	4e2080e7          	jalr	1250(ra) # 5968 <printf>
    exit(1);
    348e:	4505                	li	a0,1
    3490:	00002097          	auipc	ra,0x2
    3494:	168080e7          	jalr	360(ra) # 55f8 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3498:	85ca                	mv	a1,s2
    349a:	00004517          	auipc	a0,0x4
    349e:	a2e50513          	add	a0,a0,-1490 # 6ec8 <malloc+0x14a8>
    34a2:	00002097          	auipc	ra,0x2
    34a6:	4c6080e7          	jalr	1222(ra) # 5968 <printf>
    exit(1);
    34aa:	4505                	li	a0,1
    34ac:	00002097          	auipc	ra,0x2
    34b0:	14c080e7          	jalr	332(ra) # 55f8 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b4:	85ca                	mv	a1,s2
    34b6:	00004517          	auipc	a0,0x4
    34ba:	a3250513          	add	a0,a0,-1486 # 6ee8 <malloc+0x14c8>
    34be:	00002097          	auipc	ra,0x2
    34c2:	4aa080e7          	jalr	1194(ra) # 5968 <printf>
    exit(1);
    34c6:	4505                	li	a0,1
    34c8:	00002097          	auipc	ra,0x2
    34cc:	130080e7          	jalr	304(ra) # 55f8 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d0:	85ca                	mv	a1,s2
    34d2:	00004517          	auipc	a0,0x4
    34d6:	a4650513          	add	a0,a0,-1466 # 6f18 <malloc+0x14f8>
    34da:	00002097          	auipc	ra,0x2
    34de:	48e080e7          	jalr	1166(ra) # 5968 <printf>
    exit(1);
    34e2:	4505                	li	a0,1
    34e4:	00002097          	auipc	ra,0x2
    34e8:	114080e7          	jalr	276(ra) # 55f8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34ec:	85ca                	mv	a1,s2
    34ee:	00004517          	auipc	a0,0x4
    34f2:	a5250513          	add	a0,a0,-1454 # 6f40 <malloc+0x1520>
    34f6:	00002097          	auipc	ra,0x2
    34fa:	472080e7          	jalr	1138(ra) # 5968 <printf>
    exit(1);
    34fe:	4505                	li	a0,1
    3500:	00002097          	auipc	ra,0x2
    3504:	0f8080e7          	jalr	248(ra) # 55f8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3508:	85ca                	mv	a1,s2
    350a:	00004517          	auipc	a0,0x4
    350e:	a5650513          	add	a0,a0,-1450 # 6f60 <malloc+0x1540>
    3512:	00002097          	auipc	ra,0x2
    3516:	456080e7          	jalr	1110(ra) # 5968 <printf>
    exit(1);
    351a:	4505                	li	a0,1
    351c:	00002097          	auipc	ra,0x2
    3520:	0dc080e7          	jalr	220(ra) # 55f8 <exit>
    printf("%s: chdir dd failed\n", s);
    3524:	85ca                	mv	a1,s2
    3526:	00004517          	auipc	a0,0x4
    352a:	a6250513          	add	a0,a0,-1438 # 6f88 <malloc+0x1568>
    352e:	00002097          	auipc	ra,0x2
    3532:	43a080e7          	jalr	1082(ra) # 5968 <printf>
    exit(1);
    3536:	4505                	li	a0,1
    3538:	00002097          	auipc	ra,0x2
    353c:	0c0080e7          	jalr	192(ra) # 55f8 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3540:	85ca                	mv	a1,s2
    3542:	00004517          	auipc	a0,0x4
    3546:	a6e50513          	add	a0,a0,-1426 # 6fb0 <malloc+0x1590>
    354a:	00002097          	auipc	ra,0x2
    354e:	41e080e7          	jalr	1054(ra) # 5968 <printf>
    exit(1);
    3552:	4505                	li	a0,1
    3554:	00002097          	auipc	ra,0x2
    3558:	0a4080e7          	jalr	164(ra) # 55f8 <exit>
    printf("chdir dd/../../dd failed\n", s);
    355c:	85ca                	mv	a1,s2
    355e:	00004517          	auipc	a0,0x4
    3562:	a8250513          	add	a0,a0,-1406 # 6fe0 <malloc+0x15c0>
    3566:	00002097          	auipc	ra,0x2
    356a:	402080e7          	jalr	1026(ra) # 5968 <printf>
    exit(1);
    356e:	4505                	li	a0,1
    3570:	00002097          	auipc	ra,0x2
    3574:	088080e7          	jalr	136(ra) # 55f8 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3578:	85ca                	mv	a1,s2
    357a:	00004517          	auipc	a0,0x4
    357e:	a8e50513          	add	a0,a0,-1394 # 7008 <malloc+0x15e8>
    3582:	00002097          	auipc	ra,0x2
    3586:	3e6080e7          	jalr	998(ra) # 5968 <printf>
    exit(1);
    358a:	4505                	li	a0,1
    358c:	00002097          	auipc	ra,0x2
    3590:	06c080e7          	jalr	108(ra) # 55f8 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3594:	85ca                	mv	a1,s2
    3596:	00004517          	auipc	a0,0x4
    359a:	a8a50513          	add	a0,a0,-1398 # 7020 <malloc+0x1600>
    359e:	00002097          	auipc	ra,0x2
    35a2:	3ca080e7          	jalr	970(ra) # 5968 <printf>
    exit(1);
    35a6:	4505                	li	a0,1
    35a8:	00002097          	auipc	ra,0x2
    35ac:	050080e7          	jalr	80(ra) # 55f8 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b0:	85ca                	mv	a1,s2
    35b2:	00004517          	auipc	a0,0x4
    35b6:	a8e50513          	add	a0,a0,-1394 # 7040 <malloc+0x1620>
    35ba:	00002097          	auipc	ra,0x2
    35be:	3ae080e7          	jalr	942(ra) # 5968 <printf>
    exit(1);
    35c2:	4505                	li	a0,1
    35c4:	00002097          	auipc	ra,0x2
    35c8:	034080e7          	jalr	52(ra) # 55f8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35cc:	85ca                	mv	a1,s2
    35ce:	00004517          	auipc	a0,0x4
    35d2:	a9250513          	add	a0,a0,-1390 # 7060 <malloc+0x1640>
    35d6:	00002097          	auipc	ra,0x2
    35da:	392080e7          	jalr	914(ra) # 5968 <printf>
    exit(1);
    35de:	4505                	li	a0,1
    35e0:	00002097          	auipc	ra,0x2
    35e4:	018080e7          	jalr	24(ra) # 55f8 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35e8:	85ca                	mv	a1,s2
    35ea:	00004517          	auipc	a0,0x4
    35ee:	ab650513          	add	a0,a0,-1354 # 70a0 <malloc+0x1680>
    35f2:	00002097          	auipc	ra,0x2
    35f6:	376080e7          	jalr	886(ra) # 5968 <printf>
    exit(1);
    35fa:	4505                	li	a0,1
    35fc:	00002097          	auipc	ra,0x2
    3600:	ffc080e7          	jalr	-4(ra) # 55f8 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3604:	85ca                	mv	a1,s2
    3606:	00004517          	auipc	a0,0x4
    360a:	aca50513          	add	a0,a0,-1334 # 70d0 <malloc+0x16b0>
    360e:	00002097          	auipc	ra,0x2
    3612:	35a080e7          	jalr	858(ra) # 5968 <printf>
    exit(1);
    3616:	4505                	li	a0,1
    3618:	00002097          	auipc	ra,0x2
    361c:	fe0080e7          	jalr	-32(ra) # 55f8 <exit>
    printf("%s: create dd succeeded!\n", s);
    3620:	85ca                	mv	a1,s2
    3622:	00004517          	auipc	a0,0x4
    3626:	ace50513          	add	a0,a0,-1330 # 70f0 <malloc+0x16d0>
    362a:	00002097          	auipc	ra,0x2
    362e:	33e080e7          	jalr	830(ra) # 5968 <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	00002097          	auipc	ra,0x2
    3638:	fc4080e7          	jalr	-60(ra) # 55f8 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    363c:	85ca                	mv	a1,s2
    363e:	00004517          	auipc	a0,0x4
    3642:	ad250513          	add	a0,a0,-1326 # 7110 <malloc+0x16f0>
    3646:	00002097          	auipc	ra,0x2
    364a:	322080e7          	jalr	802(ra) # 5968 <printf>
    exit(1);
    364e:	4505                	li	a0,1
    3650:	00002097          	auipc	ra,0x2
    3654:	fa8080e7          	jalr	-88(ra) # 55f8 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3658:	85ca                	mv	a1,s2
    365a:	00004517          	auipc	a0,0x4
    365e:	ad650513          	add	a0,a0,-1322 # 7130 <malloc+0x1710>
    3662:	00002097          	auipc	ra,0x2
    3666:	306080e7          	jalr	774(ra) # 5968 <printf>
    exit(1);
    366a:	4505                	li	a0,1
    366c:	00002097          	auipc	ra,0x2
    3670:	f8c080e7          	jalr	-116(ra) # 55f8 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3674:	85ca                	mv	a1,s2
    3676:	00004517          	auipc	a0,0x4
    367a:	aea50513          	add	a0,a0,-1302 # 7160 <malloc+0x1740>
    367e:	00002097          	auipc	ra,0x2
    3682:	2ea080e7          	jalr	746(ra) # 5968 <printf>
    exit(1);
    3686:	4505                	li	a0,1
    3688:	00002097          	auipc	ra,0x2
    368c:	f70080e7          	jalr	-144(ra) # 55f8 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3690:	85ca                	mv	a1,s2
    3692:	00004517          	auipc	a0,0x4
    3696:	af650513          	add	a0,a0,-1290 # 7188 <malloc+0x1768>
    369a:	00002097          	auipc	ra,0x2
    369e:	2ce080e7          	jalr	718(ra) # 5968 <printf>
    exit(1);
    36a2:	4505                	li	a0,1
    36a4:	00002097          	auipc	ra,0x2
    36a8:	f54080e7          	jalr	-172(ra) # 55f8 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36ac:	85ca                	mv	a1,s2
    36ae:	00004517          	auipc	a0,0x4
    36b2:	b0250513          	add	a0,a0,-1278 # 71b0 <malloc+0x1790>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	2b2080e7          	jalr	690(ra) # 5968 <printf>
    exit(1);
    36be:	4505                	li	a0,1
    36c0:	00002097          	auipc	ra,0x2
    36c4:	f38080e7          	jalr	-200(ra) # 55f8 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36c8:	85ca                	mv	a1,s2
    36ca:	00004517          	auipc	a0,0x4
    36ce:	b0e50513          	add	a0,a0,-1266 # 71d8 <malloc+0x17b8>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	296080e7          	jalr	662(ra) # 5968 <printf>
    exit(1);
    36da:	4505                	li	a0,1
    36dc:	00002097          	auipc	ra,0x2
    36e0:	f1c080e7          	jalr	-228(ra) # 55f8 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e4:	85ca                	mv	a1,s2
    36e6:	00004517          	auipc	a0,0x4
    36ea:	b1250513          	add	a0,a0,-1262 # 71f8 <malloc+0x17d8>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	27a080e7          	jalr	634(ra) # 5968 <printf>
    exit(1);
    36f6:	4505                	li	a0,1
    36f8:	00002097          	auipc	ra,0x2
    36fc:	f00080e7          	jalr	-256(ra) # 55f8 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3700:	85ca                	mv	a1,s2
    3702:	00004517          	auipc	a0,0x4
    3706:	b1650513          	add	a0,a0,-1258 # 7218 <malloc+0x17f8>
    370a:	00002097          	auipc	ra,0x2
    370e:	25e080e7          	jalr	606(ra) # 5968 <printf>
    exit(1);
    3712:	4505                	li	a0,1
    3714:	00002097          	auipc	ra,0x2
    3718:	ee4080e7          	jalr	-284(ra) # 55f8 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    371c:	85ca                	mv	a1,s2
    371e:	00004517          	auipc	a0,0x4
    3722:	b2250513          	add	a0,a0,-1246 # 7240 <malloc+0x1820>
    3726:	00002097          	auipc	ra,0x2
    372a:	242080e7          	jalr	578(ra) # 5968 <printf>
    exit(1);
    372e:	4505                	li	a0,1
    3730:	00002097          	auipc	ra,0x2
    3734:	ec8080e7          	jalr	-312(ra) # 55f8 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3738:	85ca                	mv	a1,s2
    373a:	00004517          	auipc	a0,0x4
    373e:	b2650513          	add	a0,a0,-1242 # 7260 <malloc+0x1840>
    3742:	00002097          	auipc	ra,0x2
    3746:	226080e7          	jalr	550(ra) # 5968 <printf>
    exit(1);
    374a:	4505                	li	a0,1
    374c:	00002097          	auipc	ra,0x2
    3750:	eac080e7          	jalr	-340(ra) # 55f8 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3754:	85ca                	mv	a1,s2
    3756:	00004517          	auipc	a0,0x4
    375a:	b2a50513          	add	a0,a0,-1238 # 7280 <malloc+0x1860>
    375e:	00002097          	auipc	ra,0x2
    3762:	20a080e7          	jalr	522(ra) # 5968 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	00002097          	auipc	ra,0x2
    376c:	e90080e7          	jalr	-368(ra) # 55f8 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3770:	85ca                	mv	a1,s2
    3772:	00004517          	auipc	a0,0x4
    3776:	b3650513          	add	a0,a0,-1226 # 72a8 <malloc+0x1888>
    377a:	00002097          	auipc	ra,0x2
    377e:	1ee080e7          	jalr	494(ra) # 5968 <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00002097          	auipc	ra,0x2
    3788:	e74080e7          	jalr	-396(ra) # 55f8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00003517          	auipc	a0,0x3
    3792:	7b250513          	add	a0,a0,1970 # 6f40 <malloc+0x1520>
    3796:	00002097          	auipc	ra,0x2
    379a:	1d2080e7          	jalr	466(ra) # 5968 <printf>
    exit(1);
    379e:	4505                	li	a0,1
    37a0:	00002097          	auipc	ra,0x2
    37a4:	e58080e7          	jalr	-424(ra) # 55f8 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37a8:	85ca                	mv	a1,s2
    37aa:	00004517          	auipc	a0,0x4
    37ae:	b1e50513          	add	a0,a0,-1250 # 72c8 <malloc+0x18a8>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	1b6080e7          	jalr	438(ra) # 5968 <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	e3c080e7          	jalr	-452(ra) # 55f8 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c4:	85ca                	mv	a1,s2
    37c6:	00004517          	auipc	a0,0x4
    37ca:	b2250513          	add	a0,a0,-1246 # 72e8 <malloc+0x18c8>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	19a080e7          	jalr	410(ra) # 5968 <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	00002097          	auipc	ra,0x2
    37dc:	e20080e7          	jalr	-480(ra) # 55f8 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00004517          	auipc	a0,0x4
    37e6:	b3650513          	add	a0,a0,-1226 # 7318 <malloc+0x18f8>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	17e080e7          	jalr	382(ra) # 5968 <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	e04080e7          	jalr	-508(ra) # 55f8 <exit>
    printf("%s: unlink dd failed\n", s);
    37fc:	85ca                	mv	a1,s2
    37fe:	00004517          	auipc	a0,0x4
    3802:	b3a50513          	add	a0,a0,-1222 # 7338 <malloc+0x1918>
    3806:	00002097          	auipc	ra,0x2
    380a:	162080e7          	jalr	354(ra) # 5968 <printf>
    exit(1);
    380e:	4505                	li	a0,1
    3810:	00002097          	auipc	ra,0x2
    3814:	de8080e7          	jalr	-536(ra) # 55f8 <exit>

0000000000003818 <rmdot>:
{
    3818:	1101                	add	sp,sp,-32
    381a:	ec06                	sd	ra,24(sp)
    381c:	e822                	sd	s0,16(sp)
    381e:	e426                	sd	s1,8(sp)
    3820:	1000                	add	s0,sp,32
    3822:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3824:	00004517          	auipc	a0,0x4
    3828:	b2c50513          	add	a0,a0,-1236 # 7350 <malloc+0x1930>
    382c:	00002097          	auipc	ra,0x2
    3830:	e34080e7          	jalr	-460(ra) # 5660 <mkdir>
    3834:	e549                	bnez	a0,38be <rmdot+0xa6>
  if(chdir("dots") != 0){
    3836:	00004517          	auipc	a0,0x4
    383a:	b1a50513          	add	a0,a0,-1254 # 7350 <malloc+0x1930>
    383e:	00002097          	auipc	ra,0x2
    3842:	e2a080e7          	jalr	-470(ra) # 5668 <chdir>
    3846:	e951                	bnez	a0,38da <rmdot+0xc2>
  if(unlink(".") == 0){
    3848:	00003517          	auipc	a0,0x3
    384c:	9b050513          	add	a0,a0,-1616 # 61f8 <malloc+0x7d8>
    3850:	00002097          	auipc	ra,0x2
    3854:	df8080e7          	jalr	-520(ra) # 5648 <unlink>
    3858:	cd59                	beqz	a0,38f6 <rmdot+0xde>
  if(unlink("..") == 0){
    385a:	00003517          	auipc	a0,0x3
    385e:	54e50513          	add	a0,a0,1358 # 6da8 <malloc+0x1388>
    3862:	00002097          	auipc	ra,0x2
    3866:	de6080e7          	jalr	-538(ra) # 5648 <unlink>
    386a:	c545                	beqz	a0,3912 <rmdot+0xfa>
  if(chdir("/") != 0){
    386c:	00003517          	auipc	a0,0x3
    3870:	4e450513          	add	a0,a0,1252 # 6d50 <malloc+0x1330>
    3874:	00002097          	auipc	ra,0x2
    3878:	df4080e7          	jalr	-524(ra) # 5668 <chdir>
    387c:	e94d                	bnez	a0,392e <rmdot+0x116>
  if(unlink("dots/.") == 0){
    387e:	00004517          	auipc	a0,0x4
    3882:	b3a50513          	add	a0,a0,-1222 # 73b8 <malloc+0x1998>
    3886:	00002097          	auipc	ra,0x2
    388a:	dc2080e7          	jalr	-574(ra) # 5648 <unlink>
    388e:	cd55                	beqz	a0,394a <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3890:	00004517          	auipc	a0,0x4
    3894:	b5050513          	add	a0,a0,-1200 # 73e0 <malloc+0x19c0>
    3898:	00002097          	auipc	ra,0x2
    389c:	db0080e7          	jalr	-592(ra) # 5648 <unlink>
    38a0:	c179                	beqz	a0,3966 <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a2:	00004517          	auipc	a0,0x4
    38a6:	aae50513          	add	a0,a0,-1362 # 7350 <malloc+0x1930>
    38aa:	00002097          	auipc	ra,0x2
    38ae:	d9e080e7          	jalr	-610(ra) # 5648 <unlink>
    38b2:	e961                	bnez	a0,3982 <rmdot+0x16a>
}
    38b4:	60e2                	ld	ra,24(sp)
    38b6:	6442                	ld	s0,16(sp)
    38b8:	64a2                	ld	s1,8(sp)
    38ba:	6105                	add	sp,sp,32
    38bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38be:	85a6                	mv	a1,s1
    38c0:	00004517          	auipc	a0,0x4
    38c4:	a9850513          	add	a0,a0,-1384 # 7358 <malloc+0x1938>
    38c8:	00002097          	auipc	ra,0x2
    38cc:	0a0080e7          	jalr	160(ra) # 5968 <printf>
    exit(1);
    38d0:	4505                	li	a0,1
    38d2:	00002097          	auipc	ra,0x2
    38d6:	d26080e7          	jalr	-730(ra) # 55f8 <exit>
    printf("%s: chdir dots failed\n", s);
    38da:	85a6                	mv	a1,s1
    38dc:	00004517          	auipc	a0,0x4
    38e0:	a9450513          	add	a0,a0,-1388 # 7370 <malloc+0x1950>
    38e4:	00002097          	auipc	ra,0x2
    38e8:	084080e7          	jalr	132(ra) # 5968 <printf>
    exit(1);
    38ec:	4505                	li	a0,1
    38ee:	00002097          	auipc	ra,0x2
    38f2:	d0a080e7          	jalr	-758(ra) # 55f8 <exit>
    printf("%s: rm . worked!\n", s);
    38f6:	85a6                	mv	a1,s1
    38f8:	00004517          	auipc	a0,0x4
    38fc:	a9050513          	add	a0,a0,-1392 # 7388 <malloc+0x1968>
    3900:	00002097          	auipc	ra,0x2
    3904:	068080e7          	jalr	104(ra) # 5968 <printf>
    exit(1);
    3908:	4505                	li	a0,1
    390a:	00002097          	auipc	ra,0x2
    390e:	cee080e7          	jalr	-786(ra) # 55f8 <exit>
    printf("%s: rm .. worked!\n", s);
    3912:	85a6                	mv	a1,s1
    3914:	00004517          	auipc	a0,0x4
    3918:	a8c50513          	add	a0,a0,-1396 # 73a0 <malloc+0x1980>
    391c:	00002097          	auipc	ra,0x2
    3920:	04c080e7          	jalr	76(ra) # 5968 <printf>
    exit(1);
    3924:	4505                	li	a0,1
    3926:	00002097          	auipc	ra,0x2
    392a:	cd2080e7          	jalr	-814(ra) # 55f8 <exit>
    printf("%s: chdir / failed\n", s);
    392e:	85a6                	mv	a1,s1
    3930:	00003517          	auipc	a0,0x3
    3934:	42850513          	add	a0,a0,1064 # 6d58 <malloc+0x1338>
    3938:	00002097          	auipc	ra,0x2
    393c:	030080e7          	jalr	48(ra) # 5968 <printf>
    exit(1);
    3940:	4505                	li	a0,1
    3942:	00002097          	auipc	ra,0x2
    3946:	cb6080e7          	jalr	-842(ra) # 55f8 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    394a:	85a6                	mv	a1,s1
    394c:	00004517          	auipc	a0,0x4
    3950:	a7450513          	add	a0,a0,-1420 # 73c0 <malloc+0x19a0>
    3954:	00002097          	auipc	ra,0x2
    3958:	014080e7          	jalr	20(ra) # 5968 <printf>
    exit(1);
    395c:	4505                	li	a0,1
    395e:	00002097          	auipc	ra,0x2
    3962:	c9a080e7          	jalr	-870(ra) # 55f8 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3966:	85a6                	mv	a1,s1
    3968:	00004517          	auipc	a0,0x4
    396c:	a8050513          	add	a0,a0,-1408 # 73e8 <malloc+0x19c8>
    3970:	00002097          	auipc	ra,0x2
    3974:	ff8080e7          	jalr	-8(ra) # 5968 <printf>
    exit(1);
    3978:	4505                	li	a0,1
    397a:	00002097          	auipc	ra,0x2
    397e:	c7e080e7          	jalr	-898(ra) # 55f8 <exit>
    printf("%s: unlink dots failed!\n", s);
    3982:	85a6                	mv	a1,s1
    3984:	00004517          	auipc	a0,0x4
    3988:	a8450513          	add	a0,a0,-1404 # 7408 <malloc+0x19e8>
    398c:	00002097          	auipc	ra,0x2
    3990:	fdc080e7          	jalr	-36(ra) # 5968 <printf>
    exit(1);
    3994:	4505                	li	a0,1
    3996:	00002097          	auipc	ra,0x2
    399a:	c62080e7          	jalr	-926(ra) # 55f8 <exit>

000000000000399e <dirfile>:
{
    399e:	1101                	add	sp,sp,-32
    39a0:	ec06                	sd	ra,24(sp)
    39a2:	e822                	sd	s0,16(sp)
    39a4:	e426                	sd	s1,8(sp)
    39a6:	e04a                	sd	s2,0(sp)
    39a8:	1000                	add	s0,sp,32
    39aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39ac:	20000593          	li	a1,512
    39b0:	00004517          	auipc	a0,0x4
    39b4:	a7850513          	add	a0,a0,-1416 # 7428 <malloc+0x1a08>
    39b8:	00002097          	auipc	ra,0x2
    39bc:	c80080e7          	jalr	-896(ra) # 5638 <open>
  if(fd < 0){
    39c0:	0e054d63          	bltz	a0,3aba <dirfile+0x11c>
  close(fd);
    39c4:	00002097          	auipc	ra,0x2
    39c8:	c5c080e7          	jalr	-932(ra) # 5620 <close>
  if(chdir("dirfile") == 0){
    39cc:	00004517          	auipc	a0,0x4
    39d0:	a5c50513          	add	a0,a0,-1444 # 7428 <malloc+0x1a08>
    39d4:	00002097          	auipc	ra,0x2
    39d8:	c94080e7          	jalr	-876(ra) # 5668 <chdir>
    39dc:	cd6d                	beqz	a0,3ad6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39de:	4581                	li	a1,0
    39e0:	00004517          	auipc	a0,0x4
    39e4:	a9050513          	add	a0,a0,-1392 # 7470 <malloc+0x1a50>
    39e8:	00002097          	auipc	ra,0x2
    39ec:	c50080e7          	jalr	-944(ra) # 5638 <open>
  if(fd >= 0){
    39f0:	10055163          	bgez	a0,3af2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f4:	20000593          	li	a1,512
    39f8:	00004517          	auipc	a0,0x4
    39fc:	a7850513          	add	a0,a0,-1416 # 7470 <malloc+0x1a50>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	c38080e7          	jalr	-968(ra) # 5638 <open>
  if(fd >= 0){
    3a08:	10055363          	bgez	a0,3b0e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	a6450513          	add	a0,a0,-1436 # 7470 <malloc+0x1a50>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	c4c080e7          	jalr	-948(ra) # 5660 <mkdir>
    3a1c:	10050763          	beqz	a0,3b2a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	a5050513          	add	a0,a0,-1456 # 7470 <malloc+0x1a50>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	c20080e7          	jalr	-992(ra) # 5648 <unlink>
    3a30:	10050b63          	beqz	a0,3b46 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a34:	00004597          	auipc	a1,0x4
    3a38:	a3c58593          	add	a1,a1,-1476 # 7470 <malloc+0x1a50>
    3a3c:	00002517          	auipc	a0,0x2
    3a40:	2ac50513          	add	a0,a0,684 # 5ce8 <malloc+0x2c8>
    3a44:	00002097          	auipc	ra,0x2
    3a48:	c14080e7          	jalr	-1004(ra) # 5658 <link>
    3a4c:	10050b63          	beqz	a0,3b62 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a50:	00004517          	auipc	a0,0x4
    3a54:	9d850513          	add	a0,a0,-1576 # 7428 <malloc+0x1a08>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	bf0080e7          	jalr	-1040(ra) # 5648 <unlink>
    3a60:	10051f63          	bnez	a0,3b7e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a64:	4589                	li	a1,2
    3a66:	00002517          	auipc	a0,0x2
    3a6a:	79250513          	add	a0,a0,1938 # 61f8 <malloc+0x7d8>
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	bca080e7          	jalr	-1078(ra) # 5638 <open>
  if(fd >= 0){
    3a76:	12055263          	bgez	a0,3b9a <dirfile+0x1fc>
  fd = open(".", 0);
    3a7a:	4581                	li	a1,0
    3a7c:	00002517          	auipc	a0,0x2
    3a80:	77c50513          	add	a0,a0,1916 # 61f8 <malloc+0x7d8>
    3a84:	00002097          	auipc	ra,0x2
    3a88:	bb4080e7          	jalr	-1100(ra) # 5638 <open>
    3a8c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a8e:	4605                	li	a2,1
    3a90:	00002597          	auipc	a1,0x2
    3a94:	12058593          	add	a1,a1,288 # 5bb0 <malloc+0x190>
    3a98:	00002097          	auipc	ra,0x2
    3a9c:	b80080e7          	jalr	-1152(ra) # 5618 <write>
    3aa0:	10a04b63          	bgtz	a0,3bb6 <dirfile+0x218>
  close(fd);
    3aa4:	8526                	mv	a0,s1
    3aa6:	00002097          	auipc	ra,0x2
    3aaa:	b7a080e7          	jalr	-1158(ra) # 5620 <close>
}
    3aae:	60e2                	ld	ra,24(sp)
    3ab0:	6442                	ld	s0,16(sp)
    3ab2:	64a2                	ld	s1,8(sp)
    3ab4:	6902                	ld	s2,0(sp)
    3ab6:	6105                	add	sp,sp,32
    3ab8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3aba:	85ca                	mv	a1,s2
    3abc:	00004517          	auipc	a0,0x4
    3ac0:	97450513          	add	a0,a0,-1676 # 7430 <malloc+0x1a10>
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	ea4080e7          	jalr	-348(ra) # 5968 <printf>
    exit(1);
    3acc:	4505                	li	a0,1
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	b2a080e7          	jalr	-1238(ra) # 55f8 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ad6:	85ca                	mv	a1,s2
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	97850513          	add	a0,a0,-1672 # 7450 <malloc+0x1a30>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	e88080e7          	jalr	-376(ra) # 5968 <printf>
    exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	b0e080e7          	jalr	-1266(ra) # 55f8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af2:	85ca                	mv	a1,s2
    3af4:	00004517          	auipc	a0,0x4
    3af8:	98c50513          	add	a0,a0,-1652 # 7480 <malloc+0x1a60>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	e6c080e7          	jalr	-404(ra) # 5968 <printf>
    exit(1);
    3b04:	4505                	li	a0,1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	af2080e7          	jalr	-1294(ra) # 55f8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b0e:	85ca                	mv	a1,s2
    3b10:	00004517          	auipc	a0,0x4
    3b14:	97050513          	add	a0,a0,-1680 # 7480 <malloc+0x1a60>
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	e50080e7          	jalr	-432(ra) # 5968 <printf>
    exit(1);
    3b20:	4505                	li	a0,1
    3b22:	00002097          	auipc	ra,0x2
    3b26:	ad6080e7          	jalr	-1322(ra) # 55f8 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b2a:	85ca                	mv	a1,s2
    3b2c:	00004517          	auipc	a0,0x4
    3b30:	97c50513          	add	a0,a0,-1668 # 74a8 <malloc+0x1a88>
    3b34:	00002097          	auipc	ra,0x2
    3b38:	e34080e7          	jalr	-460(ra) # 5968 <printf>
    exit(1);
    3b3c:	4505                	li	a0,1
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	aba080e7          	jalr	-1350(ra) # 55f8 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b46:	85ca                	mv	a1,s2
    3b48:	00004517          	auipc	a0,0x4
    3b4c:	98850513          	add	a0,a0,-1656 # 74d0 <malloc+0x1ab0>
    3b50:	00002097          	auipc	ra,0x2
    3b54:	e18080e7          	jalr	-488(ra) # 5968 <printf>
    exit(1);
    3b58:	4505                	li	a0,1
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	a9e080e7          	jalr	-1378(ra) # 55f8 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b62:	85ca                	mv	a1,s2
    3b64:	00004517          	auipc	a0,0x4
    3b68:	99450513          	add	a0,a0,-1644 # 74f8 <malloc+0x1ad8>
    3b6c:	00002097          	auipc	ra,0x2
    3b70:	dfc080e7          	jalr	-516(ra) # 5968 <printf>
    exit(1);
    3b74:	4505                	li	a0,1
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	a82080e7          	jalr	-1406(ra) # 55f8 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b7e:	85ca                	mv	a1,s2
    3b80:	00004517          	auipc	a0,0x4
    3b84:	9a050513          	add	a0,a0,-1632 # 7520 <malloc+0x1b00>
    3b88:	00002097          	auipc	ra,0x2
    3b8c:	de0080e7          	jalr	-544(ra) # 5968 <printf>
    exit(1);
    3b90:	4505                	li	a0,1
    3b92:	00002097          	auipc	ra,0x2
    3b96:	a66080e7          	jalr	-1434(ra) # 55f8 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b9a:	85ca                	mv	a1,s2
    3b9c:	00004517          	auipc	a0,0x4
    3ba0:	9a450513          	add	a0,a0,-1628 # 7540 <malloc+0x1b20>
    3ba4:	00002097          	auipc	ra,0x2
    3ba8:	dc4080e7          	jalr	-572(ra) # 5968 <printf>
    exit(1);
    3bac:	4505                	li	a0,1
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	a4a080e7          	jalr	-1462(ra) # 55f8 <exit>
    printf("%s: write . succeeded!\n", s);
    3bb6:	85ca                	mv	a1,s2
    3bb8:	00004517          	auipc	a0,0x4
    3bbc:	9b050513          	add	a0,a0,-1616 # 7568 <malloc+0x1b48>
    3bc0:	00002097          	auipc	ra,0x2
    3bc4:	da8080e7          	jalr	-600(ra) # 5968 <printf>
    exit(1);
    3bc8:	4505                	li	a0,1
    3bca:	00002097          	auipc	ra,0x2
    3bce:	a2e080e7          	jalr	-1490(ra) # 55f8 <exit>

0000000000003bd2 <iref>:
{
    3bd2:	7139                	add	sp,sp,-64
    3bd4:	fc06                	sd	ra,56(sp)
    3bd6:	f822                	sd	s0,48(sp)
    3bd8:	f426                	sd	s1,40(sp)
    3bda:	f04a                	sd	s2,32(sp)
    3bdc:	ec4e                	sd	s3,24(sp)
    3bde:	e852                	sd	s4,16(sp)
    3be0:	e456                	sd	s5,8(sp)
    3be2:	e05a                	sd	s6,0(sp)
    3be4:	0080                	add	s0,sp,64
    3be6:	8b2a                	mv	s6,a0
    3be8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bec:	00004a17          	auipc	s4,0x4
    3bf0:	994a0a13          	add	s4,s4,-1644 # 7580 <malloc+0x1b60>
    mkdir("");
    3bf4:	00003497          	auipc	s1,0x3
    3bf8:	49448493          	add	s1,s1,1172 # 7088 <malloc+0x1668>
    link("README", "");
    3bfc:	00002a97          	auipc	s5,0x2
    3c00:	0eca8a93          	add	s5,s5,236 # 5ce8 <malloc+0x2c8>
    fd = open("xx", O_CREATE);
    3c04:	00004997          	auipc	s3,0x4
    3c08:	87498993          	add	s3,s3,-1932 # 7478 <malloc+0x1a58>
    3c0c:	a891                	j	3c60 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c0e:	85da                	mv	a1,s6
    3c10:	00004517          	auipc	a0,0x4
    3c14:	97850513          	add	a0,a0,-1672 # 7588 <malloc+0x1b68>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	d50080e7          	jalr	-688(ra) # 5968 <printf>
      exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	9d6080e7          	jalr	-1578(ra) # 55f8 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c2a:	85da                	mv	a1,s6
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	97450513          	add	a0,a0,-1676 # 75a0 <malloc+0x1b80>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	d34080e7          	jalr	-716(ra) # 5968 <printf>
      exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	9ba080e7          	jalr	-1606(ra) # 55f8 <exit>
      close(fd);
    3c46:	00002097          	auipc	ra,0x2
    3c4a:	9da080e7          	jalr	-1574(ra) # 5620 <close>
    3c4e:	a889                	j	3ca0 <iref+0xce>
    unlink("xx");
    3c50:	854e                	mv	a0,s3
    3c52:	00002097          	auipc	ra,0x2
    3c56:	9f6080e7          	jalr	-1546(ra) # 5648 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c5a:	397d                	addw	s2,s2,-1
    3c5c:	06090063          	beqz	s2,3cbc <iref+0xea>
    if(mkdir("irefd") != 0){
    3c60:	8552                	mv	a0,s4
    3c62:	00002097          	auipc	ra,0x2
    3c66:	9fe080e7          	jalr	-1538(ra) # 5660 <mkdir>
    3c6a:	f155                	bnez	a0,3c0e <iref+0x3c>
    if(chdir("irefd") != 0){
    3c6c:	8552                	mv	a0,s4
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	9fa080e7          	jalr	-1542(ra) # 5668 <chdir>
    3c76:	f955                	bnez	a0,3c2a <iref+0x58>
    mkdir("");
    3c78:	8526                	mv	a0,s1
    3c7a:	00002097          	auipc	ra,0x2
    3c7e:	9e6080e7          	jalr	-1562(ra) # 5660 <mkdir>
    link("README", "");
    3c82:	85a6                	mv	a1,s1
    3c84:	8556                	mv	a0,s5
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	9d2080e7          	jalr	-1582(ra) # 5658 <link>
    fd = open("", O_CREATE);
    3c8e:	20000593          	li	a1,512
    3c92:	8526                	mv	a0,s1
    3c94:	00002097          	auipc	ra,0x2
    3c98:	9a4080e7          	jalr	-1628(ra) # 5638 <open>
    if(fd >= 0)
    3c9c:	fa0555e3          	bgez	a0,3c46 <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca0:	20000593          	li	a1,512
    3ca4:	854e                	mv	a0,s3
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	992080e7          	jalr	-1646(ra) # 5638 <open>
    if(fd >= 0)
    3cae:	fa0541e3          	bltz	a0,3c50 <iref+0x7e>
      close(fd);
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	96e080e7          	jalr	-1682(ra) # 5620 <close>
    3cba:	bf59                	j	3c50 <iref+0x7e>
    3cbc:	03300493          	li	s1,51
    chdir("..");
    3cc0:	00003997          	auipc	s3,0x3
    3cc4:	0e898993          	add	s3,s3,232 # 6da8 <malloc+0x1388>
    unlink("irefd");
    3cc8:	00004917          	auipc	s2,0x4
    3ccc:	8b890913          	add	s2,s2,-1864 # 7580 <malloc+0x1b60>
    chdir("..");
    3cd0:	854e                	mv	a0,s3
    3cd2:	00002097          	auipc	ra,0x2
    3cd6:	996080e7          	jalr	-1642(ra) # 5668 <chdir>
    unlink("irefd");
    3cda:	854a                	mv	a0,s2
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	96c080e7          	jalr	-1684(ra) # 5648 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce4:	34fd                	addw	s1,s1,-1
    3ce6:	f4ed                	bnez	s1,3cd0 <iref+0xfe>
  chdir("/");
    3ce8:	00003517          	auipc	a0,0x3
    3cec:	06850513          	add	a0,a0,104 # 6d50 <malloc+0x1330>
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	978080e7          	jalr	-1672(ra) # 5668 <chdir>
}
    3cf8:	70e2                	ld	ra,56(sp)
    3cfa:	7442                	ld	s0,48(sp)
    3cfc:	74a2                	ld	s1,40(sp)
    3cfe:	7902                	ld	s2,32(sp)
    3d00:	69e2                	ld	s3,24(sp)
    3d02:	6a42                	ld	s4,16(sp)
    3d04:	6aa2                	ld	s5,8(sp)
    3d06:	6b02                	ld	s6,0(sp)
    3d08:	6121                	add	sp,sp,64
    3d0a:	8082                	ret

0000000000003d0c <openiputtest>:
{
    3d0c:	7179                	add	sp,sp,-48
    3d0e:	f406                	sd	ra,40(sp)
    3d10:	f022                	sd	s0,32(sp)
    3d12:	ec26                	sd	s1,24(sp)
    3d14:	1800                	add	s0,sp,48
    3d16:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d18:	00004517          	auipc	a0,0x4
    3d1c:	8a050513          	add	a0,a0,-1888 # 75b8 <malloc+0x1b98>
    3d20:	00002097          	auipc	ra,0x2
    3d24:	940080e7          	jalr	-1728(ra) # 5660 <mkdir>
    3d28:	04054263          	bltz	a0,3d6c <openiputtest+0x60>
  pid = fork();
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	8c4080e7          	jalr	-1852(ra) # 55f0 <fork>
  if(pid < 0){
    3d34:	04054a63          	bltz	a0,3d88 <openiputtest+0x7c>
  if(pid == 0){
    3d38:	e93d                	bnez	a0,3dae <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d3a:	4589                	li	a1,2
    3d3c:	00004517          	auipc	a0,0x4
    3d40:	87c50513          	add	a0,a0,-1924 # 75b8 <malloc+0x1b98>
    3d44:	00002097          	auipc	ra,0x2
    3d48:	8f4080e7          	jalr	-1804(ra) # 5638 <open>
    if(fd >= 0){
    3d4c:	04054c63          	bltz	a0,3da4 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d50:	85a6                	mv	a1,s1
    3d52:	00004517          	auipc	a0,0x4
    3d56:	88650513          	add	a0,a0,-1914 # 75d8 <malloc+0x1bb8>
    3d5a:	00002097          	auipc	ra,0x2
    3d5e:	c0e080e7          	jalr	-1010(ra) # 5968 <printf>
      exit(1);
    3d62:	4505                	li	a0,1
    3d64:	00002097          	auipc	ra,0x2
    3d68:	894080e7          	jalr	-1900(ra) # 55f8 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d6c:	85a6                	mv	a1,s1
    3d6e:	00004517          	auipc	a0,0x4
    3d72:	85250513          	add	a0,a0,-1966 # 75c0 <malloc+0x1ba0>
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	bf2080e7          	jalr	-1038(ra) # 5968 <printf>
    exit(1);
    3d7e:	4505                	li	a0,1
    3d80:	00002097          	auipc	ra,0x2
    3d84:	878080e7          	jalr	-1928(ra) # 55f8 <exit>
    printf("%s: fork failed\n", s);
    3d88:	85a6                	mv	a1,s1
    3d8a:	00002517          	auipc	a0,0x2
    3d8e:	60e50513          	add	a0,a0,1550 # 6398 <malloc+0x978>
    3d92:	00002097          	auipc	ra,0x2
    3d96:	bd6080e7          	jalr	-1066(ra) # 5968 <printf>
    exit(1);
    3d9a:	4505                	li	a0,1
    3d9c:	00002097          	auipc	ra,0x2
    3da0:	85c080e7          	jalr	-1956(ra) # 55f8 <exit>
    exit(0);
    3da4:	4501                	li	a0,0
    3da6:	00002097          	auipc	ra,0x2
    3daa:	852080e7          	jalr	-1966(ra) # 55f8 <exit>
  sleep(1);
    3dae:	4505                	li	a0,1
    3db0:	00002097          	auipc	ra,0x2
    3db4:	8d8080e7          	jalr	-1832(ra) # 5688 <sleep>
  if(unlink("oidir") != 0){
    3db8:	00004517          	auipc	a0,0x4
    3dbc:	80050513          	add	a0,a0,-2048 # 75b8 <malloc+0x1b98>
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	888080e7          	jalr	-1912(ra) # 5648 <unlink>
    3dc8:	cd19                	beqz	a0,3de6 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dca:	85a6                	mv	a1,s1
    3dcc:	00002517          	auipc	a0,0x2
    3dd0:	7bc50513          	add	a0,a0,1980 # 6588 <malloc+0xb68>
    3dd4:	00002097          	auipc	ra,0x2
    3dd8:	b94080e7          	jalr	-1132(ra) # 5968 <printf>
    exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	00002097          	auipc	ra,0x2
    3de2:	81a080e7          	jalr	-2022(ra) # 55f8 <exit>
  wait(&xstatus);
    3de6:	fdc40513          	add	a0,s0,-36
    3dea:	00002097          	auipc	ra,0x2
    3dee:	816080e7          	jalr	-2026(ra) # 5600 <wait>
  exit(xstatus);
    3df2:	fdc42503          	lw	a0,-36(s0)
    3df6:	00002097          	auipc	ra,0x2
    3dfa:	802080e7          	jalr	-2046(ra) # 55f8 <exit>

0000000000003dfe <forkforkfork>:
{
    3dfe:	1101                	add	sp,sp,-32
    3e00:	ec06                	sd	ra,24(sp)
    3e02:	e822                	sd	s0,16(sp)
    3e04:	e426                	sd	s1,8(sp)
    3e06:	1000                	add	s0,sp,32
    3e08:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e0a:	00003517          	auipc	a0,0x3
    3e0e:	7f650513          	add	a0,a0,2038 # 7600 <malloc+0x1be0>
    3e12:	00002097          	auipc	ra,0x2
    3e16:	836080e7          	jalr	-1994(ra) # 5648 <unlink>
  int pid = fork();
    3e1a:	00001097          	auipc	ra,0x1
    3e1e:	7d6080e7          	jalr	2006(ra) # 55f0 <fork>
  if(pid < 0){
    3e22:	04054563          	bltz	a0,3e6c <forkforkfork+0x6e>
  if(pid == 0){
    3e26:	c12d                	beqz	a0,3e88 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e28:	4551                	li	a0,20
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	85e080e7          	jalr	-1954(ra) # 5688 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e32:	20200593          	li	a1,514
    3e36:	00003517          	auipc	a0,0x3
    3e3a:	7ca50513          	add	a0,a0,1994 # 7600 <malloc+0x1be0>
    3e3e:	00001097          	auipc	ra,0x1
    3e42:	7fa080e7          	jalr	2042(ra) # 5638 <open>
    3e46:	00001097          	auipc	ra,0x1
    3e4a:	7da080e7          	jalr	2010(ra) # 5620 <close>
  wait(0);
    3e4e:	4501                	li	a0,0
    3e50:	00001097          	auipc	ra,0x1
    3e54:	7b0080e7          	jalr	1968(ra) # 5600 <wait>
  sleep(10); // one second
    3e58:	4529                	li	a0,10
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	82e080e7          	jalr	-2002(ra) # 5688 <sleep>
}
    3e62:	60e2                	ld	ra,24(sp)
    3e64:	6442                	ld	s0,16(sp)
    3e66:	64a2                	ld	s1,8(sp)
    3e68:	6105                	add	sp,sp,32
    3e6a:	8082                	ret
    printf("%s: fork failed", s);
    3e6c:	85a6                	mv	a1,s1
    3e6e:	00002517          	auipc	a0,0x2
    3e72:	6ea50513          	add	a0,a0,1770 # 6558 <malloc+0xb38>
    3e76:	00002097          	auipc	ra,0x2
    3e7a:	af2080e7          	jalr	-1294(ra) # 5968 <printf>
    exit(1);
    3e7e:	4505                	li	a0,1
    3e80:	00001097          	auipc	ra,0x1
    3e84:	778080e7          	jalr	1912(ra) # 55f8 <exit>
      int fd = open("stopforking", 0);
    3e88:	00003497          	auipc	s1,0x3
    3e8c:	77848493          	add	s1,s1,1912 # 7600 <malloc+0x1be0>
    3e90:	4581                	li	a1,0
    3e92:	8526                	mv	a0,s1
    3e94:	00001097          	auipc	ra,0x1
    3e98:	7a4080e7          	jalr	1956(ra) # 5638 <open>
      if(fd >= 0){
    3e9c:	02055763          	bgez	a0,3eca <forkforkfork+0xcc>
      if(fork() < 0){
    3ea0:	00001097          	auipc	ra,0x1
    3ea4:	750080e7          	jalr	1872(ra) # 55f0 <fork>
    3ea8:	fe0554e3          	bgez	a0,3e90 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eac:	20200593          	li	a1,514
    3eb0:	00003517          	auipc	a0,0x3
    3eb4:	75050513          	add	a0,a0,1872 # 7600 <malloc+0x1be0>
    3eb8:	00001097          	auipc	ra,0x1
    3ebc:	780080e7          	jalr	1920(ra) # 5638 <open>
    3ec0:	00001097          	auipc	ra,0x1
    3ec4:	760080e7          	jalr	1888(ra) # 5620 <close>
    3ec8:	b7e1                	j	3e90 <forkforkfork+0x92>
        exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	72c080e7          	jalr	1836(ra) # 55f8 <exit>

0000000000003ed4 <preempt>:
{
    3ed4:	7139                	add	sp,sp,-64
    3ed6:	fc06                	sd	ra,56(sp)
    3ed8:	f822                	sd	s0,48(sp)
    3eda:	f426                	sd	s1,40(sp)
    3edc:	f04a                	sd	s2,32(sp)
    3ede:	ec4e                	sd	s3,24(sp)
    3ee0:	e852                	sd	s4,16(sp)
    3ee2:	0080                	add	s0,sp,64
    3ee4:	892a                	mv	s2,a0
  pid1 = fork();
    3ee6:	00001097          	auipc	ra,0x1
    3eea:	70a080e7          	jalr	1802(ra) # 55f0 <fork>
  if(pid1 < 0) {
    3eee:	00054563          	bltz	a0,3ef8 <preempt+0x24>
    3ef2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3ef4:	e105                	bnez	a0,3f14 <preempt+0x40>
    for(;;)
    3ef6:	a001                	j	3ef6 <preempt+0x22>
    printf("%s: fork failed", s);
    3ef8:	85ca                	mv	a1,s2
    3efa:	00002517          	auipc	a0,0x2
    3efe:	65e50513          	add	a0,a0,1630 # 6558 <malloc+0xb38>
    3f02:	00002097          	auipc	ra,0x2
    3f06:	a66080e7          	jalr	-1434(ra) # 5968 <printf>
    exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	6ec080e7          	jalr	1772(ra) # 55f8 <exit>
  pid2 = fork();
    3f14:	00001097          	auipc	ra,0x1
    3f18:	6dc080e7          	jalr	1756(ra) # 55f0 <fork>
    3f1c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f1e:	00054463          	bltz	a0,3f26 <preempt+0x52>
  if(pid2 == 0)
    3f22:	e105                	bnez	a0,3f42 <preempt+0x6e>
    for(;;)
    3f24:	a001                	j	3f24 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f26:	85ca                	mv	a1,s2
    3f28:	00002517          	auipc	a0,0x2
    3f2c:	47050513          	add	a0,a0,1136 # 6398 <malloc+0x978>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	a38080e7          	jalr	-1480(ra) # 5968 <printf>
    exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00001097          	auipc	ra,0x1
    3f3e:	6be080e7          	jalr	1726(ra) # 55f8 <exit>
  pipe(pfds);
    3f42:	fc840513          	add	a0,s0,-56
    3f46:	00001097          	auipc	ra,0x1
    3f4a:	6c2080e7          	jalr	1730(ra) # 5608 <pipe>
  pid3 = fork();
    3f4e:	00001097          	auipc	ra,0x1
    3f52:	6a2080e7          	jalr	1698(ra) # 55f0 <fork>
    3f56:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3f58:	02054e63          	bltz	a0,3f94 <preempt+0xc0>
  if(pid3 == 0){
    3f5c:	e525                	bnez	a0,3fc4 <preempt+0xf0>
    close(pfds[0]);
    3f5e:	fc842503          	lw	a0,-56(s0)
    3f62:	00001097          	auipc	ra,0x1
    3f66:	6be080e7          	jalr	1726(ra) # 5620 <close>
    if(write(pfds[1], "x", 1) != 1)
    3f6a:	4605                	li	a2,1
    3f6c:	00002597          	auipc	a1,0x2
    3f70:	c4458593          	add	a1,a1,-956 # 5bb0 <malloc+0x190>
    3f74:	fcc42503          	lw	a0,-52(s0)
    3f78:	00001097          	auipc	ra,0x1
    3f7c:	6a0080e7          	jalr	1696(ra) # 5618 <write>
    3f80:	4785                	li	a5,1
    3f82:	02f51763          	bne	a0,a5,3fb0 <preempt+0xdc>
    close(pfds[1]);
    3f86:	fcc42503          	lw	a0,-52(s0)
    3f8a:	00001097          	auipc	ra,0x1
    3f8e:	696080e7          	jalr	1686(ra) # 5620 <close>
    for(;;)
    3f92:	a001                	j	3f92 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f94:	85ca                	mv	a1,s2
    3f96:	00002517          	auipc	a0,0x2
    3f9a:	40250513          	add	a0,a0,1026 # 6398 <malloc+0x978>
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	9ca080e7          	jalr	-1590(ra) # 5968 <printf>
     exit(1);
    3fa6:	4505                	li	a0,1
    3fa8:	00001097          	auipc	ra,0x1
    3fac:	650080e7          	jalr	1616(ra) # 55f8 <exit>
      printf("%s: preempt write error", s);
    3fb0:	85ca                	mv	a1,s2
    3fb2:	00003517          	auipc	a0,0x3
    3fb6:	65e50513          	add	a0,a0,1630 # 7610 <malloc+0x1bf0>
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	9ae080e7          	jalr	-1618(ra) # 5968 <printf>
    3fc2:	b7d1                	j	3f86 <preempt+0xb2>
  close(pfds[1]);
    3fc4:	fcc42503          	lw	a0,-52(s0)
    3fc8:	00001097          	auipc	ra,0x1
    3fcc:	658080e7          	jalr	1624(ra) # 5620 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fd0:	660d                	lui	a2,0x3
    3fd2:	00008597          	auipc	a1,0x8
    3fd6:	afe58593          	add	a1,a1,-1282 # bad0 <buf>
    3fda:	fc842503          	lw	a0,-56(s0)
    3fde:	00001097          	auipc	ra,0x1
    3fe2:	632080e7          	jalr	1586(ra) # 5610 <read>
    3fe6:	4785                	li	a5,1
    3fe8:	02f50363          	beq	a0,a5,400e <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fec:	85ca                	mv	a1,s2
    3fee:	00003517          	auipc	a0,0x3
    3ff2:	63a50513          	add	a0,a0,1594 # 7628 <malloc+0x1c08>
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	972080e7          	jalr	-1678(ra) # 5968 <printf>
}
    3ffe:	70e2                	ld	ra,56(sp)
    4000:	7442                	ld	s0,48(sp)
    4002:	74a2                	ld	s1,40(sp)
    4004:	7902                	ld	s2,32(sp)
    4006:	69e2                	ld	s3,24(sp)
    4008:	6a42                	ld	s4,16(sp)
    400a:	6121                	add	sp,sp,64
    400c:	8082                	ret
  close(pfds[0]);
    400e:	fc842503          	lw	a0,-56(s0)
    4012:	00001097          	auipc	ra,0x1
    4016:	60e080e7          	jalr	1550(ra) # 5620 <close>
  printf("kill... ");
    401a:	00003517          	auipc	a0,0x3
    401e:	62650513          	add	a0,a0,1574 # 7640 <malloc+0x1c20>
    4022:	00002097          	auipc	ra,0x2
    4026:	946080e7          	jalr	-1722(ra) # 5968 <printf>
  kill(pid1);
    402a:	8526                	mv	a0,s1
    402c:	00001097          	auipc	ra,0x1
    4030:	5fc080e7          	jalr	1532(ra) # 5628 <kill>
  kill(pid2);
    4034:	854e                	mv	a0,s3
    4036:	00001097          	auipc	ra,0x1
    403a:	5f2080e7          	jalr	1522(ra) # 5628 <kill>
  kill(pid3);
    403e:	8552                	mv	a0,s4
    4040:	00001097          	auipc	ra,0x1
    4044:	5e8080e7          	jalr	1512(ra) # 5628 <kill>
  printf("wait... ");
    4048:	00003517          	auipc	a0,0x3
    404c:	60850513          	add	a0,a0,1544 # 7650 <malloc+0x1c30>
    4050:	00002097          	auipc	ra,0x2
    4054:	918080e7          	jalr	-1768(ra) # 5968 <printf>
  wait(0);
    4058:	4501                	li	a0,0
    405a:	00001097          	auipc	ra,0x1
    405e:	5a6080e7          	jalr	1446(ra) # 5600 <wait>
  wait(0);
    4062:	4501                	li	a0,0
    4064:	00001097          	auipc	ra,0x1
    4068:	59c080e7          	jalr	1436(ra) # 5600 <wait>
  wait(0);
    406c:	4501                	li	a0,0
    406e:	00001097          	auipc	ra,0x1
    4072:	592080e7          	jalr	1426(ra) # 5600 <wait>
    4076:	b761                	j	3ffe <preempt+0x12a>

0000000000004078 <sbrkfail>:
{
    4078:	7119                	add	sp,sp,-128
    407a:	fc86                	sd	ra,120(sp)
    407c:	f8a2                	sd	s0,112(sp)
    407e:	f4a6                	sd	s1,104(sp)
    4080:	f0ca                	sd	s2,96(sp)
    4082:	ecce                	sd	s3,88(sp)
    4084:	e8d2                	sd	s4,80(sp)
    4086:	e4d6                	sd	s5,72(sp)
    4088:	0100                	add	s0,sp,128
    408a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    408c:	fb040513          	add	a0,s0,-80
    4090:	00001097          	auipc	ra,0x1
    4094:	578080e7          	jalr	1400(ra) # 5608 <pipe>
    4098:	e901                	bnez	a0,40a8 <sbrkfail+0x30>
    409a:	f8040493          	add	s1,s0,-128
    409e:	fa840993          	add	s3,s0,-88
    40a2:	8926                	mv	s2,s1
    if(pids[i] != -1)
    40a4:	5a7d                	li	s4,-1
    40a6:	a085                	j	4106 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    40a8:	85d6                	mv	a1,s5
    40aa:	00002517          	auipc	a0,0x2
    40ae:	3f650513          	add	a0,a0,1014 # 64a0 <malloc+0xa80>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	8b6080e7          	jalr	-1866(ra) # 5968 <printf>
    exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00001097          	auipc	ra,0x1
    40c0:	53c080e7          	jalr	1340(ra) # 55f8 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40c4:	00001097          	auipc	ra,0x1
    40c8:	5bc080e7          	jalr	1468(ra) # 5680 <sbrk>
    40cc:	064007b7          	lui	a5,0x6400
    40d0:	40a7853b          	subw	a0,a5,a0
    40d4:	00001097          	auipc	ra,0x1
    40d8:	5ac080e7          	jalr	1452(ra) # 5680 <sbrk>
      write(fds[1], "x", 1);
    40dc:	4605                	li	a2,1
    40de:	00002597          	auipc	a1,0x2
    40e2:	ad258593          	add	a1,a1,-1326 # 5bb0 <malloc+0x190>
    40e6:	fb442503          	lw	a0,-76(s0)
    40ea:	00001097          	auipc	ra,0x1
    40ee:	52e080e7          	jalr	1326(ra) # 5618 <write>
      for(;;) sleep(1000);
    40f2:	3e800513          	li	a0,1000
    40f6:	00001097          	auipc	ra,0x1
    40fa:	592080e7          	jalr	1426(ra) # 5688 <sleep>
    40fe:	bfd5                	j	40f2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4100:	0911                	add	s2,s2,4
    4102:	03390563          	beq	s2,s3,412c <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4106:	00001097          	auipc	ra,0x1
    410a:	4ea080e7          	jalr	1258(ra) # 55f0 <fork>
    410e:	00a92023          	sw	a0,0(s2)
    4112:	d94d                	beqz	a0,40c4 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4114:	ff4506e3          	beq	a0,s4,4100 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4118:	4605                	li	a2,1
    411a:	faf40593          	add	a1,s0,-81
    411e:	fb042503          	lw	a0,-80(s0)
    4122:	00001097          	auipc	ra,0x1
    4126:	4ee080e7          	jalr	1262(ra) # 5610 <read>
    412a:	bfd9                	j	4100 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    412c:	6505                	lui	a0,0x1
    412e:	00001097          	auipc	ra,0x1
    4132:	552080e7          	jalr	1362(ra) # 5680 <sbrk>
    4136:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4138:	597d                	li	s2,-1
    413a:	a021                	j	4142 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    413c:	0491                	add	s1,s1,4
    413e:	01348f63          	beq	s1,s3,415c <sbrkfail+0xe4>
    if(pids[i] == -1)
    4142:	4088                	lw	a0,0(s1)
    4144:	ff250ce3          	beq	a0,s2,413c <sbrkfail+0xc4>
    kill(pids[i]);
    4148:	00001097          	auipc	ra,0x1
    414c:	4e0080e7          	jalr	1248(ra) # 5628 <kill>
    wait(0);
    4150:	4501                	li	a0,0
    4152:	00001097          	auipc	ra,0x1
    4156:	4ae080e7          	jalr	1198(ra) # 5600 <wait>
    415a:	b7cd                	j	413c <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    415c:	57fd                	li	a5,-1
    415e:	04fa0163          	beq	s4,a5,41a0 <sbrkfail+0x128>
  pid = fork();
    4162:	00001097          	auipc	ra,0x1
    4166:	48e080e7          	jalr	1166(ra) # 55f0 <fork>
    416a:	84aa                	mv	s1,a0
  if(pid < 0){
    416c:	04054863          	bltz	a0,41bc <sbrkfail+0x144>
  if(pid == 0){
    4170:	c525                	beqz	a0,41d8 <sbrkfail+0x160>
  wait(&xstatus);
    4172:	fbc40513          	add	a0,s0,-68
    4176:	00001097          	auipc	ra,0x1
    417a:	48a080e7          	jalr	1162(ra) # 5600 <wait>
  if(xstatus != -1 && xstatus != 2)
    417e:	fbc42783          	lw	a5,-68(s0)
    4182:	577d                	li	a4,-1
    4184:	00e78563          	beq	a5,a4,418e <sbrkfail+0x116>
    4188:	4709                	li	a4,2
    418a:	08e79d63          	bne	a5,a4,4224 <sbrkfail+0x1ac>
}
    418e:	70e6                	ld	ra,120(sp)
    4190:	7446                	ld	s0,112(sp)
    4192:	74a6                	ld	s1,104(sp)
    4194:	7906                	ld	s2,96(sp)
    4196:	69e6                	ld	s3,88(sp)
    4198:	6a46                	ld	s4,80(sp)
    419a:	6aa6                	ld	s5,72(sp)
    419c:	6109                	add	sp,sp,128
    419e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	4be50513          	add	a0,a0,1214 # 7660 <malloc+0x1c40>
    41aa:	00001097          	auipc	ra,0x1
    41ae:	7be080e7          	jalr	1982(ra) # 5968 <printf>
    exit(1);
    41b2:	4505                	li	a0,1
    41b4:	00001097          	auipc	ra,0x1
    41b8:	444080e7          	jalr	1092(ra) # 55f8 <exit>
    printf("%s: fork failed\n", s);
    41bc:	85d6                	mv	a1,s5
    41be:	00002517          	auipc	a0,0x2
    41c2:	1da50513          	add	a0,a0,474 # 6398 <malloc+0x978>
    41c6:	00001097          	auipc	ra,0x1
    41ca:	7a2080e7          	jalr	1954(ra) # 5968 <printf>
    exit(1);
    41ce:	4505                	li	a0,1
    41d0:	00001097          	auipc	ra,0x1
    41d4:	428080e7          	jalr	1064(ra) # 55f8 <exit>
    a = sbrk(0);
    41d8:	4501                	li	a0,0
    41da:	00001097          	auipc	ra,0x1
    41de:	4a6080e7          	jalr	1190(ra) # 5680 <sbrk>
    41e2:	892a                	mv	s2,a0
    sbrk(10*BIG);
    41e4:	3e800537          	lui	a0,0x3e800
    41e8:	00001097          	auipc	ra,0x1
    41ec:	498080e7          	jalr	1176(ra) # 5680 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41f0:	87ca                	mv	a5,s2
    41f2:	3e800737          	lui	a4,0x3e800
    41f6:	993a                	add	s2,s2,a4
    41f8:	6705                	lui	a4,0x1
      n += *(a+i);
    41fa:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1520>
    41fe:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4200:	97ba                	add	a5,a5,a4
    4202:	ff279ce3          	bne	a5,s2,41fa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4206:	8626                	mv	a2,s1
    4208:	85d6                	mv	a1,s5
    420a:	00003517          	auipc	a0,0x3
    420e:	47650513          	add	a0,a0,1142 # 7680 <malloc+0x1c60>
    4212:	00001097          	auipc	ra,0x1
    4216:	756080e7          	jalr	1878(ra) # 5968 <printf>
    exit(1);
    421a:	4505                	li	a0,1
    421c:	00001097          	auipc	ra,0x1
    4220:	3dc080e7          	jalr	988(ra) # 55f8 <exit>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00001097          	auipc	ra,0x1
    422a:	3d2080e7          	jalr	978(ra) # 55f8 <exit>

000000000000422e <reparent>:
{
    422e:	7179                	add	sp,sp,-48
    4230:	f406                	sd	ra,40(sp)
    4232:	f022                	sd	s0,32(sp)
    4234:	ec26                	sd	s1,24(sp)
    4236:	e84a                	sd	s2,16(sp)
    4238:	e44e                	sd	s3,8(sp)
    423a:	e052                	sd	s4,0(sp)
    423c:	1800                	add	s0,sp,48
    423e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4240:	00001097          	auipc	ra,0x1
    4244:	438080e7          	jalr	1080(ra) # 5678 <getpid>
    4248:	8a2a                	mv	s4,a0
    424a:	0c800913          	li	s2,200
    int pid = fork();
    424e:	00001097          	auipc	ra,0x1
    4252:	3a2080e7          	jalr	930(ra) # 55f0 <fork>
    4256:	84aa                	mv	s1,a0
    if(pid < 0){
    4258:	02054263          	bltz	a0,427c <reparent+0x4e>
    if(pid){
    425c:	cd21                	beqz	a0,42b4 <reparent+0x86>
      if(wait(0) != pid){
    425e:	4501                	li	a0,0
    4260:	00001097          	auipc	ra,0x1
    4264:	3a0080e7          	jalr	928(ra) # 5600 <wait>
    4268:	02951863          	bne	a0,s1,4298 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    426c:	397d                	addw	s2,s2,-1
    426e:	fe0910e3          	bnez	s2,424e <reparent+0x20>
  exit(0);
    4272:	4501                	li	a0,0
    4274:	00001097          	auipc	ra,0x1
    4278:	384080e7          	jalr	900(ra) # 55f8 <exit>
      printf("%s: fork failed\n", s);
    427c:	85ce                	mv	a1,s3
    427e:	00002517          	auipc	a0,0x2
    4282:	11a50513          	add	a0,a0,282 # 6398 <malloc+0x978>
    4286:	00001097          	auipc	ra,0x1
    428a:	6e2080e7          	jalr	1762(ra) # 5968 <printf>
      exit(1);
    428e:	4505                	li	a0,1
    4290:	00001097          	auipc	ra,0x1
    4294:	368080e7          	jalr	872(ra) # 55f8 <exit>
        printf("%s: wait wrong pid\n", s);
    4298:	85ce                	mv	a1,s3
    429a:	00002517          	auipc	a0,0x2
    429e:	28650513          	add	a0,a0,646 # 6520 <malloc+0xb00>
    42a2:	00001097          	auipc	ra,0x1
    42a6:	6c6080e7          	jalr	1734(ra) # 5968 <printf>
        exit(1);
    42aa:	4505                	li	a0,1
    42ac:	00001097          	auipc	ra,0x1
    42b0:	34c080e7          	jalr	844(ra) # 55f8 <exit>
      int pid2 = fork();
    42b4:	00001097          	auipc	ra,0x1
    42b8:	33c080e7          	jalr	828(ra) # 55f0 <fork>
      if(pid2 < 0){
    42bc:	00054763          	bltz	a0,42ca <reparent+0x9c>
      exit(0);
    42c0:	4501                	li	a0,0
    42c2:	00001097          	auipc	ra,0x1
    42c6:	336080e7          	jalr	822(ra) # 55f8 <exit>
        kill(master_pid);
    42ca:	8552                	mv	a0,s4
    42cc:	00001097          	auipc	ra,0x1
    42d0:	35c080e7          	jalr	860(ra) # 5628 <kill>
        exit(1);
    42d4:	4505                	li	a0,1
    42d6:	00001097          	auipc	ra,0x1
    42da:	322080e7          	jalr	802(ra) # 55f8 <exit>

00000000000042de <mem>:
{
    42de:	7139                	add	sp,sp,-64
    42e0:	fc06                	sd	ra,56(sp)
    42e2:	f822                	sd	s0,48(sp)
    42e4:	f426                	sd	s1,40(sp)
    42e6:	f04a                	sd	s2,32(sp)
    42e8:	ec4e                	sd	s3,24(sp)
    42ea:	0080                	add	s0,sp,64
    42ec:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    42ee:	00001097          	auipc	ra,0x1
    42f2:	302080e7          	jalr	770(ra) # 55f0 <fork>
    m1 = 0;
    42f6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    42f8:	6909                	lui	s2,0x2
    42fa:	71190913          	add	s2,s2,1809 # 2711 <sbrkbasic+0x15d>
  if((pid = fork()) == 0){
    42fe:	c115                	beqz	a0,4322 <mem+0x44>
    wait(&xstatus);
    4300:	fcc40513          	add	a0,s0,-52
    4304:	00001097          	auipc	ra,0x1
    4308:	2fc080e7          	jalr	764(ra) # 5600 <wait>
    if(xstatus == -1){
    430c:	fcc42503          	lw	a0,-52(s0)
    4310:	57fd                	li	a5,-1
    4312:	06f50363          	beq	a0,a5,4378 <mem+0x9a>
    exit(xstatus);
    4316:	00001097          	auipc	ra,0x1
    431a:	2e2080e7          	jalr	738(ra) # 55f8 <exit>
      *(char**)m2 = m1;
    431e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4320:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4322:	854a                	mv	a0,s2
    4324:	00001097          	auipc	ra,0x1
    4328:	6fc080e7          	jalr	1788(ra) # 5a20 <malloc>
    432c:	f96d                	bnez	a0,431e <mem+0x40>
    while(m1){
    432e:	c881                	beqz	s1,433e <mem+0x60>
      m2 = *(char**)m1;
    4330:	8526                	mv	a0,s1
    4332:	6084                	ld	s1,0(s1)
      free(m1);
    4334:	00001097          	auipc	ra,0x1
    4338:	66a080e7          	jalr	1642(ra) # 599e <free>
    while(m1){
    433c:	f8f5                	bnez	s1,4330 <mem+0x52>
    m1 = malloc(1024*20);
    433e:	6515                	lui	a0,0x5
    4340:	00001097          	auipc	ra,0x1
    4344:	6e0080e7          	jalr	1760(ra) # 5a20 <malloc>
    if(m1 == 0){
    4348:	c911                	beqz	a0,435c <mem+0x7e>
    free(m1);
    434a:	00001097          	auipc	ra,0x1
    434e:	654080e7          	jalr	1620(ra) # 599e <free>
    exit(0);
    4352:	4501                	li	a0,0
    4354:	00001097          	auipc	ra,0x1
    4358:	2a4080e7          	jalr	676(ra) # 55f8 <exit>
      printf("couldn't allocate mem?!!\n", s);
    435c:	85ce                	mv	a1,s3
    435e:	00003517          	auipc	a0,0x3
    4362:	35250513          	add	a0,a0,850 # 76b0 <malloc+0x1c90>
    4366:	00001097          	auipc	ra,0x1
    436a:	602080e7          	jalr	1538(ra) # 5968 <printf>
      exit(1);
    436e:	4505                	li	a0,1
    4370:	00001097          	auipc	ra,0x1
    4374:	288080e7          	jalr	648(ra) # 55f8 <exit>
      exit(0);
    4378:	4501                	li	a0,0
    437a:	00001097          	auipc	ra,0x1
    437e:	27e080e7          	jalr	638(ra) # 55f8 <exit>

0000000000004382 <sharedfd>:
{
    4382:	7159                	add	sp,sp,-112
    4384:	f486                	sd	ra,104(sp)
    4386:	f0a2                	sd	s0,96(sp)
    4388:	eca6                	sd	s1,88(sp)
    438a:	e8ca                	sd	s2,80(sp)
    438c:	e4ce                	sd	s3,72(sp)
    438e:	e0d2                	sd	s4,64(sp)
    4390:	fc56                	sd	s5,56(sp)
    4392:	f85a                	sd	s6,48(sp)
    4394:	f45e                	sd	s7,40(sp)
    4396:	1880                	add	s0,sp,112
    4398:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    439a:	00003517          	auipc	a0,0x3
    439e:	33650513          	add	a0,a0,822 # 76d0 <malloc+0x1cb0>
    43a2:	00001097          	auipc	ra,0x1
    43a6:	2a6080e7          	jalr	678(ra) # 5648 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43aa:	20200593          	li	a1,514
    43ae:	00003517          	auipc	a0,0x3
    43b2:	32250513          	add	a0,a0,802 # 76d0 <malloc+0x1cb0>
    43b6:	00001097          	auipc	ra,0x1
    43ba:	282080e7          	jalr	642(ra) # 5638 <open>
  if(fd < 0){
    43be:	04054a63          	bltz	a0,4412 <sharedfd+0x90>
    43c2:	892a                	mv	s2,a0
  pid = fork();
    43c4:	00001097          	auipc	ra,0x1
    43c8:	22c080e7          	jalr	556(ra) # 55f0 <fork>
    43cc:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    43ce:	07000593          	li	a1,112
    43d2:	e119                	bnez	a0,43d8 <sharedfd+0x56>
    43d4:	06300593          	li	a1,99
    43d8:	4629                	li	a2,10
    43da:	fa040513          	add	a0,s0,-96
    43de:	00001097          	auipc	ra,0x1
    43e2:	020080e7          	jalr	32(ra) # 53fe <memset>
    43e6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    43ea:	4629                	li	a2,10
    43ec:	fa040593          	add	a1,s0,-96
    43f0:	854a                	mv	a0,s2
    43f2:	00001097          	auipc	ra,0x1
    43f6:	226080e7          	jalr	550(ra) # 5618 <write>
    43fa:	47a9                	li	a5,10
    43fc:	02f51963          	bne	a0,a5,442e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4400:	34fd                	addw	s1,s1,-1
    4402:	f4e5                	bnez	s1,43ea <sharedfd+0x68>
  if(pid == 0) {
    4404:	04099363          	bnez	s3,444a <sharedfd+0xc8>
    exit(0);
    4408:	4501                	li	a0,0
    440a:	00001097          	auipc	ra,0x1
    440e:	1ee080e7          	jalr	494(ra) # 55f8 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4412:	85d2                	mv	a1,s4
    4414:	00003517          	auipc	a0,0x3
    4418:	2cc50513          	add	a0,a0,716 # 76e0 <malloc+0x1cc0>
    441c:	00001097          	auipc	ra,0x1
    4420:	54c080e7          	jalr	1356(ra) # 5968 <printf>
    exit(1);
    4424:	4505                	li	a0,1
    4426:	00001097          	auipc	ra,0x1
    442a:	1d2080e7          	jalr	466(ra) # 55f8 <exit>
      printf("%s: write sharedfd failed\n", s);
    442e:	85d2                	mv	a1,s4
    4430:	00003517          	auipc	a0,0x3
    4434:	2d850513          	add	a0,a0,728 # 7708 <malloc+0x1ce8>
    4438:	00001097          	auipc	ra,0x1
    443c:	530080e7          	jalr	1328(ra) # 5968 <printf>
      exit(1);
    4440:	4505                	li	a0,1
    4442:	00001097          	auipc	ra,0x1
    4446:	1b6080e7          	jalr	438(ra) # 55f8 <exit>
    wait(&xstatus);
    444a:	f9c40513          	add	a0,s0,-100
    444e:	00001097          	auipc	ra,0x1
    4452:	1b2080e7          	jalr	434(ra) # 5600 <wait>
    if(xstatus != 0)
    4456:	f9c42983          	lw	s3,-100(s0)
    445a:	00098763          	beqz	s3,4468 <sharedfd+0xe6>
      exit(xstatus);
    445e:	854e                	mv	a0,s3
    4460:	00001097          	auipc	ra,0x1
    4464:	198080e7          	jalr	408(ra) # 55f8 <exit>
  close(fd);
    4468:	854a                	mv	a0,s2
    446a:	00001097          	auipc	ra,0x1
    446e:	1b6080e7          	jalr	438(ra) # 5620 <close>
  fd = open("sharedfd", 0);
    4472:	4581                	li	a1,0
    4474:	00003517          	auipc	a0,0x3
    4478:	25c50513          	add	a0,a0,604 # 76d0 <malloc+0x1cb0>
    447c:	00001097          	auipc	ra,0x1
    4480:	1bc080e7          	jalr	444(ra) # 5638 <open>
    4484:	8baa                	mv	s7,a0
  nc = np = 0;
    4486:	8ace                	mv	s5,s3
  if(fd < 0){
    4488:	02054563          	bltz	a0,44b2 <sharedfd+0x130>
    448c:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4490:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4494:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4498:	4629                	li	a2,10
    449a:	fa040593          	add	a1,s0,-96
    449e:	855e                	mv	a0,s7
    44a0:	00001097          	auipc	ra,0x1
    44a4:	170080e7          	jalr	368(ra) # 5610 <read>
    44a8:	02a05f63          	blez	a0,44e6 <sharedfd+0x164>
    44ac:	fa040793          	add	a5,s0,-96
    44b0:	a01d                	j	44d6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44b2:	85d2                	mv	a1,s4
    44b4:	00003517          	auipc	a0,0x3
    44b8:	27450513          	add	a0,a0,628 # 7728 <malloc+0x1d08>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	4ac080e7          	jalr	1196(ra) # 5968 <printf>
    exit(1);
    44c4:	4505                	li	a0,1
    44c6:	00001097          	auipc	ra,0x1
    44ca:	132080e7          	jalr	306(ra) # 55f8 <exit>
        nc++;
    44ce:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    44d0:	0785                	add	a5,a5,1
    44d2:	fd2783e3          	beq	a5,s2,4498 <sharedfd+0x116>
      if(buf[i] == 'c')
    44d6:	0007c703          	lbu	a4,0(a5)
    44da:	fe970ae3          	beq	a4,s1,44ce <sharedfd+0x14c>
      if(buf[i] == 'p')
    44de:	ff6719e3          	bne	a4,s6,44d0 <sharedfd+0x14e>
        np++;
    44e2:	2a85                	addw	s5,s5,1
    44e4:	b7f5                	j	44d0 <sharedfd+0x14e>
  close(fd);
    44e6:	855e                	mv	a0,s7
    44e8:	00001097          	auipc	ra,0x1
    44ec:	138080e7          	jalr	312(ra) # 5620 <close>
  unlink("sharedfd");
    44f0:	00003517          	auipc	a0,0x3
    44f4:	1e050513          	add	a0,a0,480 # 76d0 <malloc+0x1cb0>
    44f8:	00001097          	auipc	ra,0x1
    44fc:	150080e7          	jalr	336(ra) # 5648 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4500:	6789                	lui	a5,0x2
    4502:	71078793          	add	a5,a5,1808 # 2710 <sbrkbasic+0x15c>
    4506:	00f99763          	bne	s3,a5,4514 <sharedfd+0x192>
    450a:	6789                	lui	a5,0x2
    450c:	71078793          	add	a5,a5,1808 # 2710 <sbrkbasic+0x15c>
    4510:	02fa8063          	beq	s5,a5,4530 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4514:	85d2                	mv	a1,s4
    4516:	00003517          	auipc	a0,0x3
    451a:	23a50513          	add	a0,a0,570 # 7750 <malloc+0x1d30>
    451e:	00001097          	auipc	ra,0x1
    4522:	44a080e7          	jalr	1098(ra) # 5968 <printf>
    exit(1);
    4526:	4505                	li	a0,1
    4528:	00001097          	auipc	ra,0x1
    452c:	0d0080e7          	jalr	208(ra) # 55f8 <exit>
    exit(0);
    4530:	4501                	li	a0,0
    4532:	00001097          	auipc	ra,0x1
    4536:	0c6080e7          	jalr	198(ra) # 55f8 <exit>

000000000000453a <fourfiles>:
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
    454e:	e8e2                	sd	s8,80(sp)
    4550:	e4e6                	sd	s9,72(sp)
    4552:	e0ea                	sd	s10,64(sp)
    4554:	fc6e                	sd	s11,56(sp)
    4556:	1100                	add	s0,sp,160
    4558:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    455a:	00003797          	auipc	a5,0x3
    455e:	20e78793          	add	a5,a5,526 # 7768 <malloc+0x1d48>
    4562:	f6f43823          	sd	a5,-144(s0)
    4566:	00003797          	auipc	a5,0x3
    456a:	20a78793          	add	a5,a5,522 # 7770 <malloc+0x1d50>
    456e:	f6f43c23          	sd	a5,-136(s0)
    4572:	00003797          	auipc	a5,0x3
    4576:	20678793          	add	a5,a5,518 # 7778 <malloc+0x1d58>
    457a:	f8f43023          	sd	a5,-128(s0)
    457e:	00003797          	auipc	a5,0x3
    4582:	20278793          	add	a5,a5,514 # 7780 <malloc+0x1d60>
    4586:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    458a:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    458e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4590:	4481                	li	s1,0
    4592:	4a11                	li	s4,4
    fname = names[pi];
    4594:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4598:	854e                	mv	a0,s3
    459a:	00001097          	auipc	ra,0x1
    459e:	0ae080e7          	jalr	174(ra) # 5648 <unlink>
    pid = fork();
    45a2:	00001097          	auipc	ra,0x1
    45a6:	04e080e7          	jalr	78(ra) # 55f0 <fork>
    if(pid < 0){
    45aa:	04054063          	bltz	a0,45ea <fourfiles+0xb0>
    if(pid == 0){
    45ae:	cd21                	beqz	a0,4606 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    45b0:	2485                	addw	s1,s1,1
    45b2:	0921                	add	s2,s2,8
    45b4:	ff4490e3          	bne	s1,s4,4594 <fourfiles+0x5a>
    45b8:	4491                	li	s1,4
    wait(&xstatus);
    45ba:	f6c40513          	add	a0,s0,-148
    45be:	00001097          	auipc	ra,0x1
    45c2:	042080e7          	jalr	66(ra) # 5600 <wait>
    if(xstatus != 0)
    45c6:	f6c42a83          	lw	s5,-148(s0)
    45ca:	0c0a9863          	bnez	s5,469a <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    45ce:	34fd                	addw	s1,s1,-1
    45d0:	f4ed                	bnez	s1,45ba <fourfiles+0x80>
    45d2:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45d6:	00007a17          	auipc	s4,0x7
    45da:	4faa0a13          	add	s4,s4,1274 # bad0 <buf>
    if(total != N*SZ){
    45de:	6d05                	lui	s10,0x1
    45e0:	770d0d13          	add	s10,s10,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    45e4:	03400d93          	li	s11,52
    45e8:	a22d                	j	4712 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    45ea:	85e6                	mv	a1,s9
    45ec:	00002517          	auipc	a0,0x2
    45f0:	1b450513          	add	a0,a0,436 # 67a0 <malloc+0xd80>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	374080e7          	jalr	884(ra) # 5968 <printf>
      exit(1);
    45fc:	4505                	li	a0,1
    45fe:	00001097          	auipc	ra,0x1
    4602:	ffa080e7          	jalr	-6(ra) # 55f8 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4606:	20200593          	li	a1,514
    460a:	854e                	mv	a0,s3
    460c:	00001097          	auipc	ra,0x1
    4610:	02c080e7          	jalr	44(ra) # 5638 <open>
    4614:	892a                	mv	s2,a0
      if(fd < 0){
    4616:	04054763          	bltz	a0,4664 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    461a:	1f400613          	li	a2,500
    461e:	0304859b          	addw	a1,s1,48
    4622:	00007517          	auipc	a0,0x7
    4626:	4ae50513          	add	a0,a0,1198 # bad0 <buf>
    462a:	00001097          	auipc	ra,0x1
    462e:	dd4080e7          	jalr	-556(ra) # 53fe <memset>
    4632:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4634:	00007997          	auipc	s3,0x7
    4638:	49c98993          	add	s3,s3,1180 # bad0 <buf>
    463c:	1f400613          	li	a2,500
    4640:	85ce                	mv	a1,s3
    4642:	854a                	mv	a0,s2
    4644:	00001097          	auipc	ra,0x1
    4648:	fd4080e7          	jalr	-44(ra) # 5618 <write>
    464c:	85aa                	mv	a1,a0
    464e:	1f400793          	li	a5,500
    4652:	02f51763          	bne	a0,a5,4680 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4656:	34fd                	addw	s1,s1,-1
    4658:	f0f5                	bnez	s1,463c <fourfiles+0x102>
      exit(0);
    465a:	4501                	li	a0,0
    465c:	00001097          	auipc	ra,0x1
    4660:	f9c080e7          	jalr	-100(ra) # 55f8 <exit>
        printf("create failed\n", s);
    4664:	85e6                	mv	a1,s9
    4666:	00003517          	auipc	a0,0x3
    466a:	12250513          	add	a0,a0,290 # 7788 <malloc+0x1d68>
    466e:	00001097          	auipc	ra,0x1
    4672:	2fa080e7          	jalr	762(ra) # 5968 <printf>
        exit(1);
    4676:	4505                	li	a0,1
    4678:	00001097          	auipc	ra,0x1
    467c:	f80080e7          	jalr	-128(ra) # 55f8 <exit>
          printf("write failed %d\n", n);
    4680:	00003517          	auipc	a0,0x3
    4684:	11850513          	add	a0,a0,280 # 7798 <malloc+0x1d78>
    4688:	00001097          	auipc	ra,0x1
    468c:	2e0080e7          	jalr	736(ra) # 5968 <printf>
          exit(1);
    4690:	4505                	li	a0,1
    4692:	00001097          	auipc	ra,0x1
    4696:	f66080e7          	jalr	-154(ra) # 55f8 <exit>
      exit(xstatus);
    469a:	8556                	mv	a0,s5
    469c:	00001097          	auipc	ra,0x1
    46a0:	f5c080e7          	jalr	-164(ra) # 55f8 <exit>
          printf("wrong char\n", s);
    46a4:	85e6                	mv	a1,s9
    46a6:	00003517          	auipc	a0,0x3
    46aa:	10a50513          	add	a0,a0,266 # 77b0 <malloc+0x1d90>
    46ae:	00001097          	auipc	ra,0x1
    46b2:	2ba080e7          	jalr	698(ra) # 5968 <printf>
          exit(1);
    46b6:	4505                	li	a0,1
    46b8:	00001097          	auipc	ra,0x1
    46bc:	f40080e7          	jalr	-192(ra) # 55f8 <exit>
      total += n;
    46c0:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46c4:	660d                	lui	a2,0x3
    46c6:	85d2                	mv	a1,s4
    46c8:	854e                	mv	a0,s3
    46ca:	00001097          	auipc	ra,0x1
    46ce:	f46080e7          	jalr	-186(ra) # 5610 <read>
    46d2:	02a05063          	blez	a0,46f2 <fourfiles+0x1b8>
    46d6:	00007797          	auipc	a5,0x7
    46da:	3fa78793          	add	a5,a5,1018 # bad0 <buf>
    46de:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    46e2:	0007c703          	lbu	a4,0(a5)
    46e6:	fa971fe3          	bne	a4,s1,46a4 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    46ea:	0785                	add	a5,a5,1
    46ec:	fed79be3          	bne	a5,a3,46e2 <fourfiles+0x1a8>
    46f0:	bfc1                	j	46c0 <fourfiles+0x186>
    close(fd);
    46f2:	854e                	mv	a0,s3
    46f4:	00001097          	auipc	ra,0x1
    46f8:	f2c080e7          	jalr	-212(ra) # 5620 <close>
    if(total != N*SZ){
    46fc:	03a91863          	bne	s2,s10,472c <fourfiles+0x1f2>
    unlink(fname);
    4700:	8562                	mv	a0,s8
    4702:	00001097          	auipc	ra,0x1
    4706:	f46080e7          	jalr	-186(ra) # 5648 <unlink>
  for(i = 0; i < NCHILD; i++){
    470a:	0ba1                	add	s7,s7,8
    470c:	2b05                	addw	s6,s6,1
    470e:	03bb0d63          	beq	s6,s11,4748 <fourfiles+0x20e>
    fname = names[i];
    4712:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4716:	4581                	li	a1,0
    4718:	8562                	mv	a0,s8
    471a:	00001097          	auipc	ra,0x1
    471e:	f1e080e7          	jalr	-226(ra) # 5638 <open>
    4722:	89aa                	mv	s3,a0
    total = 0;
    4724:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4726:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    472a:	bf69                	j	46c4 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    472c:	85ca                	mv	a1,s2
    472e:	00003517          	auipc	a0,0x3
    4732:	09250513          	add	a0,a0,146 # 77c0 <malloc+0x1da0>
    4736:	00001097          	auipc	ra,0x1
    473a:	232080e7          	jalr	562(ra) # 5968 <printf>
      exit(1);
    473e:	4505                	li	a0,1
    4740:	00001097          	auipc	ra,0x1
    4744:	eb8080e7          	jalr	-328(ra) # 55f8 <exit>
}
    4748:	60ea                	ld	ra,152(sp)
    474a:	644a                	ld	s0,144(sp)
    474c:	64aa                	ld	s1,136(sp)
    474e:	690a                	ld	s2,128(sp)
    4750:	79e6                	ld	s3,120(sp)
    4752:	7a46                	ld	s4,112(sp)
    4754:	7aa6                	ld	s5,104(sp)
    4756:	7b06                	ld	s6,96(sp)
    4758:	6be6                	ld	s7,88(sp)
    475a:	6c46                	ld	s8,80(sp)
    475c:	6ca6                	ld	s9,72(sp)
    475e:	6d06                	ld	s10,64(sp)
    4760:	7de2                	ld	s11,56(sp)
    4762:	610d                	add	sp,sp,160
    4764:	8082                	ret

0000000000004766 <concreate>:
{
    4766:	7135                	add	sp,sp,-160
    4768:	ed06                	sd	ra,152(sp)
    476a:	e922                	sd	s0,144(sp)
    476c:	e526                	sd	s1,136(sp)
    476e:	e14a                	sd	s2,128(sp)
    4770:	fcce                	sd	s3,120(sp)
    4772:	f8d2                	sd	s4,112(sp)
    4774:	f4d6                	sd	s5,104(sp)
    4776:	f0da                	sd	s6,96(sp)
    4778:	ecde                	sd	s7,88(sp)
    477a:	1100                	add	s0,sp,160
    477c:	89aa                	mv	s3,a0
  file[0] = 'C';
    477e:	04300793          	li	a5,67
    4782:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4786:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    478a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    478c:	4b0d                	li	s6,3
    478e:	4a85                	li	s5,1
      link("C0", file);
    4790:	00003b97          	auipc	s7,0x3
    4794:	048b8b93          	add	s7,s7,72 # 77d8 <malloc+0x1db8>
  for(i = 0; i < N; i++){
    4798:	02800a13          	li	s4,40
    479c:	acc9                	j	4a6e <concreate+0x308>
      link("C0", file);
    479e:	fa840593          	add	a1,s0,-88
    47a2:	855e                	mv	a0,s7
    47a4:	00001097          	auipc	ra,0x1
    47a8:	eb4080e7          	jalr	-332(ra) # 5658 <link>
    if(pid == 0) {
    47ac:	a465                	j	4a54 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    47ae:	4795                	li	a5,5
    47b0:	02f9693b          	remw	s2,s2,a5
    47b4:	4785                	li	a5,1
    47b6:	02f90b63          	beq	s2,a5,47ec <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    47ba:	20200593          	li	a1,514
    47be:	fa840513          	add	a0,s0,-88
    47c2:	00001097          	auipc	ra,0x1
    47c6:	e76080e7          	jalr	-394(ra) # 5638 <open>
      if(fd < 0){
    47ca:	26055c63          	bgez	a0,4a42 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    47ce:	fa840593          	add	a1,s0,-88
    47d2:	00003517          	auipc	a0,0x3
    47d6:	00e50513          	add	a0,a0,14 # 77e0 <malloc+0x1dc0>
    47da:	00001097          	auipc	ra,0x1
    47de:	18e080e7          	jalr	398(ra) # 5968 <printf>
        exit(1);
    47e2:	4505                	li	a0,1
    47e4:	00001097          	auipc	ra,0x1
    47e8:	e14080e7          	jalr	-492(ra) # 55f8 <exit>
      link("C0", file);
    47ec:	fa840593          	add	a1,s0,-88
    47f0:	00003517          	auipc	a0,0x3
    47f4:	fe850513          	add	a0,a0,-24 # 77d8 <malloc+0x1db8>
    47f8:	00001097          	auipc	ra,0x1
    47fc:	e60080e7          	jalr	-416(ra) # 5658 <link>
      exit(0);
    4800:	4501                	li	a0,0
    4802:	00001097          	auipc	ra,0x1
    4806:	df6080e7          	jalr	-522(ra) # 55f8 <exit>
        exit(1);
    480a:	4505                	li	a0,1
    480c:	00001097          	auipc	ra,0x1
    4810:	dec080e7          	jalr	-532(ra) # 55f8 <exit>
  memset(fa, 0, sizeof(fa));
    4814:	02800613          	li	a2,40
    4818:	4581                	li	a1,0
    481a:	f8040513          	add	a0,s0,-128
    481e:	00001097          	auipc	ra,0x1
    4822:	be0080e7          	jalr	-1056(ra) # 53fe <memset>
  fd = open(".", 0);
    4826:	4581                	li	a1,0
    4828:	00002517          	auipc	a0,0x2
    482c:	9d050513          	add	a0,a0,-1584 # 61f8 <malloc+0x7d8>
    4830:	00001097          	auipc	ra,0x1
    4834:	e08080e7          	jalr	-504(ra) # 5638 <open>
    4838:	892a                	mv	s2,a0
  n = 0;
    483a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    483c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4840:	02700b13          	li	s6,39
      fa[i] = 1;
    4844:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4846:	4641                	li	a2,16
    4848:	f7040593          	add	a1,s0,-144
    484c:	854a                	mv	a0,s2
    484e:	00001097          	auipc	ra,0x1
    4852:	dc2080e7          	jalr	-574(ra) # 5610 <read>
    4856:	08a05263          	blez	a0,48da <concreate+0x174>
    if(de.inum == 0)
    485a:	f7045783          	lhu	a5,-144(s0)
    485e:	d7e5                	beqz	a5,4846 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4860:	f7244783          	lbu	a5,-142(s0)
    4864:	ff4791e3          	bne	a5,s4,4846 <concreate+0xe0>
    4868:	f7444783          	lbu	a5,-140(s0)
    486c:	ffe9                	bnez	a5,4846 <concreate+0xe0>
      i = de.name[1] - '0';
    486e:	f7344783          	lbu	a5,-141(s0)
    4872:	fd07879b          	addw	a5,a5,-48
    4876:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    487a:	02eb6063          	bltu	s6,a4,489a <concreate+0x134>
      if(fa[i]){
    487e:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x4e>
    4882:	97a2                	add	a5,a5,s0
    4884:	fd07c783          	lbu	a5,-48(a5)
    4888:	eb8d                	bnez	a5,48ba <concreate+0x154>
      fa[i] = 1;
    488a:	fb070793          	add	a5,a4,-80
    488e:	00878733          	add	a4,a5,s0
    4892:	fd770823          	sb	s7,-48(a4)
      n++;
    4896:	2a85                	addw	s5,s5,1
    4898:	b77d                	j	4846 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    489a:	f7240613          	add	a2,s0,-142
    489e:	85ce                	mv	a1,s3
    48a0:	00003517          	auipc	a0,0x3
    48a4:	f6050513          	add	a0,a0,-160 # 7800 <malloc+0x1de0>
    48a8:	00001097          	auipc	ra,0x1
    48ac:	0c0080e7          	jalr	192(ra) # 5968 <printf>
        exit(1);
    48b0:	4505                	li	a0,1
    48b2:	00001097          	auipc	ra,0x1
    48b6:	d46080e7          	jalr	-698(ra) # 55f8 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    48ba:	f7240613          	add	a2,s0,-142
    48be:	85ce                	mv	a1,s3
    48c0:	00003517          	auipc	a0,0x3
    48c4:	f6050513          	add	a0,a0,-160 # 7820 <malloc+0x1e00>
    48c8:	00001097          	auipc	ra,0x1
    48cc:	0a0080e7          	jalr	160(ra) # 5968 <printf>
        exit(1);
    48d0:	4505                	li	a0,1
    48d2:	00001097          	auipc	ra,0x1
    48d6:	d26080e7          	jalr	-730(ra) # 55f8 <exit>
  close(fd);
    48da:	854a                	mv	a0,s2
    48dc:	00001097          	auipc	ra,0x1
    48e0:	d44080e7          	jalr	-700(ra) # 5620 <close>
  if(n != N){
    48e4:	02800793          	li	a5,40
    48e8:	00fa9763          	bne	s5,a5,48f6 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    48ec:	4a8d                	li	s5,3
    48ee:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    48f0:	02800a13          	li	s4,40
    48f4:	a8c9                	j	49c6 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    48f6:	85ce                	mv	a1,s3
    48f8:	00003517          	auipc	a0,0x3
    48fc:	f5050513          	add	a0,a0,-176 # 7848 <malloc+0x1e28>
    4900:	00001097          	auipc	ra,0x1
    4904:	068080e7          	jalr	104(ra) # 5968 <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	00001097          	auipc	ra,0x1
    490e:	cee080e7          	jalr	-786(ra) # 55f8 <exit>
      printf("%s: fork failed\n", s);
    4912:	85ce                	mv	a1,s3
    4914:	00002517          	auipc	a0,0x2
    4918:	a8450513          	add	a0,a0,-1404 # 6398 <malloc+0x978>
    491c:	00001097          	auipc	ra,0x1
    4920:	04c080e7          	jalr	76(ra) # 5968 <printf>
      exit(1);
    4924:	4505                	li	a0,1
    4926:	00001097          	auipc	ra,0x1
    492a:	cd2080e7          	jalr	-814(ra) # 55f8 <exit>
      close(open(file, 0));
    492e:	4581                	li	a1,0
    4930:	fa840513          	add	a0,s0,-88
    4934:	00001097          	auipc	ra,0x1
    4938:	d04080e7          	jalr	-764(ra) # 5638 <open>
    493c:	00001097          	auipc	ra,0x1
    4940:	ce4080e7          	jalr	-796(ra) # 5620 <close>
      close(open(file, 0));
    4944:	4581                	li	a1,0
    4946:	fa840513          	add	a0,s0,-88
    494a:	00001097          	auipc	ra,0x1
    494e:	cee080e7          	jalr	-786(ra) # 5638 <open>
    4952:	00001097          	auipc	ra,0x1
    4956:	cce080e7          	jalr	-818(ra) # 5620 <close>
      close(open(file, 0));
    495a:	4581                	li	a1,0
    495c:	fa840513          	add	a0,s0,-88
    4960:	00001097          	auipc	ra,0x1
    4964:	cd8080e7          	jalr	-808(ra) # 5638 <open>
    4968:	00001097          	auipc	ra,0x1
    496c:	cb8080e7          	jalr	-840(ra) # 5620 <close>
      close(open(file, 0));
    4970:	4581                	li	a1,0
    4972:	fa840513          	add	a0,s0,-88
    4976:	00001097          	auipc	ra,0x1
    497a:	cc2080e7          	jalr	-830(ra) # 5638 <open>
    497e:	00001097          	auipc	ra,0x1
    4982:	ca2080e7          	jalr	-862(ra) # 5620 <close>
      close(open(file, 0));
    4986:	4581                	li	a1,0
    4988:	fa840513          	add	a0,s0,-88
    498c:	00001097          	auipc	ra,0x1
    4990:	cac080e7          	jalr	-852(ra) # 5638 <open>
    4994:	00001097          	auipc	ra,0x1
    4998:	c8c080e7          	jalr	-884(ra) # 5620 <close>
      close(open(file, 0));
    499c:	4581                	li	a1,0
    499e:	fa840513          	add	a0,s0,-88
    49a2:	00001097          	auipc	ra,0x1
    49a6:	c96080e7          	jalr	-874(ra) # 5638 <open>
    49aa:	00001097          	auipc	ra,0x1
    49ae:	c76080e7          	jalr	-906(ra) # 5620 <close>
    if(pid == 0)
    49b2:	08090363          	beqz	s2,4a38 <concreate+0x2d2>
      wait(0);
    49b6:	4501                	li	a0,0
    49b8:	00001097          	auipc	ra,0x1
    49bc:	c48080e7          	jalr	-952(ra) # 5600 <wait>
  for(i = 0; i < N; i++){
    49c0:	2485                	addw	s1,s1,1
    49c2:	0f448563          	beq	s1,s4,4aac <concreate+0x346>
    file[1] = '0' + i;
    49c6:	0304879b          	addw	a5,s1,48
    49ca:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    49ce:	00001097          	auipc	ra,0x1
    49d2:	c22080e7          	jalr	-990(ra) # 55f0 <fork>
    49d6:	892a                	mv	s2,a0
    if(pid < 0){
    49d8:	f2054de3          	bltz	a0,4912 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    49dc:	0354e73b          	remw	a4,s1,s5
    49e0:	00a767b3          	or	a5,a4,a0
    49e4:	2781                	sext.w	a5,a5
    49e6:	d7a1                	beqz	a5,492e <concreate+0x1c8>
    49e8:	01671363          	bne	a4,s6,49ee <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    49ec:	f129                	bnez	a0,492e <concreate+0x1c8>
      unlink(file);
    49ee:	fa840513          	add	a0,s0,-88
    49f2:	00001097          	auipc	ra,0x1
    49f6:	c56080e7          	jalr	-938(ra) # 5648 <unlink>
      unlink(file);
    49fa:	fa840513          	add	a0,s0,-88
    49fe:	00001097          	auipc	ra,0x1
    4a02:	c4a080e7          	jalr	-950(ra) # 5648 <unlink>
      unlink(file);
    4a06:	fa840513          	add	a0,s0,-88
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	c3e080e7          	jalr	-962(ra) # 5648 <unlink>
      unlink(file);
    4a12:	fa840513          	add	a0,s0,-88
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	c32080e7          	jalr	-974(ra) # 5648 <unlink>
      unlink(file);
    4a1e:	fa840513          	add	a0,s0,-88
    4a22:	00001097          	auipc	ra,0x1
    4a26:	c26080e7          	jalr	-986(ra) # 5648 <unlink>
      unlink(file);
    4a2a:	fa840513          	add	a0,s0,-88
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	c1a080e7          	jalr	-998(ra) # 5648 <unlink>
    4a36:	bfb5                	j	49b2 <concreate+0x24c>
      exit(0);
    4a38:	4501                	li	a0,0
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	bbe080e7          	jalr	-1090(ra) # 55f8 <exit>
      close(fd);
    4a42:	00001097          	auipc	ra,0x1
    4a46:	bde080e7          	jalr	-1058(ra) # 5620 <close>
    if(pid == 0) {
    4a4a:	bb5d                	j	4800 <concreate+0x9a>
      close(fd);
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	bd4080e7          	jalr	-1068(ra) # 5620 <close>
      wait(&xstatus);
    4a54:	f6c40513          	add	a0,s0,-148
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	ba8080e7          	jalr	-1112(ra) # 5600 <wait>
      if(xstatus != 0)
    4a60:	f6c42483          	lw	s1,-148(s0)
    4a64:	da0493e3          	bnez	s1,480a <concreate+0xa4>
  for(i = 0; i < N; i++){
    4a68:	2905                	addw	s2,s2,1
    4a6a:	db4905e3          	beq	s2,s4,4814 <concreate+0xae>
    file[1] = '0' + i;
    4a6e:	0309079b          	addw	a5,s2,48
    4a72:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4a76:	fa840513          	add	a0,s0,-88
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	bce080e7          	jalr	-1074(ra) # 5648 <unlink>
    pid = fork();
    4a82:	00001097          	auipc	ra,0x1
    4a86:	b6e080e7          	jalr	-1170(ra) # 55f0 <fork>
    if(pid && (i % 3) == 1){
    4a8a:	d20502e3          	beqz	a0,47ae <concreate+0x48>
    4a8e:	036967bb          	remw	a5,s2,s6
    4a92:	d15786e3          	beq	a5,s5,479e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4a96:	20200593          	li	a1,514
    4a9a:	fa840513          	add	a0,s0,-88
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	b9a080e7          	jalr	-1126(ra) # 5638 <open>
      if(fd < 0){
    4aa6:	fa0553e3          	bgez	a0,4a4c <concreate+0x2e6>
    4aaa:	b315                	j	47ce <concreate+0x68>
}
    4aac:	60ea                	ld	ra,152(sp)
    4aae:	644a                	ld	s0,144(sp)
    4ab0:	64aa                	ld	s1,136(sp)
    4ab2:	690a                	ld	s2,128(sp)
    4ab4:	79e6                	ld	s3,120(sp)
    4ab6:	7a46                	ld	s4,112(sp)
    4ab8:	7aa6                	ld	s5,104(sp)
    4aba:	7b06                	ld	s6,96(sp)
    4abc:	6be6                	ld	s7,88(sp)
    4abe:	610d                	add	sp,sp,160
    4ac0:	8082                	ret

0000000000004ac2 <bigfile>:
{
    4ac2:	7139                	add	sp,sp,-64
    4ac4:	fc06                	sd	ra,56(sp)
    4ac6:	f822                	sd	s0,48(sp)
    4ac8:	f426                	sd	s1,40(sp)
    4aca:	f04a                	sd	s2,32(sp)
    4acc:	ec4e                	sd	s3,24(sp)
    4ace:	e852                	sd	s4,16(sp)
    4ad0:	e456                	sd	s5,8(sp)
    4ad2:	0080                	add	s0,sp,64
    4ad4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4ad6:	00003517          	auipc	a0,0x3
    4ada:	daa50513          	add	a0,a0,-598 # 7880 <malloc+0x1e60>
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	b6a080e7          	jalr	-1174(ra) # 5648 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4ae6:	20200593          	li	a1,514
    4aea:	00003517          	auipc	a0,0x3
    4aee:	d9650513          	add	a0,a0,-618 # 7880 <malloc+0x1e60>
    4af2:	00001097          	auipc	ra,0x1
    4af6:	b46080e7          	jalr	-1210(ra) # 5638 <open>
    4afa:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4afc:	4481                	li	s1,0
    memset(buf, i, SZ);
    4afe:	00007917          	auipc	s2,0x7
    4b02:	fd290913          	add	s2,s2,-46 # bad0 <buf>
  for(i = 0; i < N; i++){
    4b06:	4a51                	li	s4,20
  if(fd < 0){
    4b08:	0a054063          	bltz	a0,4ba8 <bigfile+0xe6>
    memset(buf, i, SZ);
    4b0c:	25800613          	li	a2,600
    4b10:	85a6                	mv	a1,s1
    4b12:	854a                	mv	a0,s2
    4b14:	00001097          	auipc	ra,0x1
    4b18:	8ea080e7          	jalr	-1814(ra) # 53fe <memset>
    if(write(fd, buf, SZ) != SZ){
    4b1c:	25800613          	li	a2,600
    4b20:	85ca                	mv	a1,s2
    4b22:	854e                	mv	a0,s3
    4b24:	00001097          	auipc	ra,0x1
    4b28:	af4080e7          	jalr	-1292(ra) # 5618 <write>
    4b2c:	25800793          	li	a5,600
    4b30:	08f51a63          	bne	a0,a5,4bc4 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b34:	2485                	addw	s1,s1,1
    4b36:	fd449be3          	bne	s1,s4,4b0c <bigfile+0x4a>
  close(fd);
    4b3a:	854e                	mv	a0,s3
    4b3c:	00001097          	auipc	ra,0x1
    4b40:	ae4080e7          	jalr	-1308(ra) # 5620 <close>
  fd = open("bigfile.dat", 0);
    4b44:	4581                	li	a1,0
    4b46:	00003517          	auipc	a0,0x3
    4b4a:	d3a50513          	add	a0,a0,-710 # 7880 <malloc+0x1e60>
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	aea080e7          	jalr	-1302(ra) # 5638 <open>
    4b56:	8a2a                	mv	s4,a0
  total = 0;
    4b58:	4981                	li	s3,0
  for(i = 0; ; i++){
    4b5a:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4b5c:	00007917          	auipc	s2,0x7
    4b60:	f7490913          	add	s2,s2,-140 # bad0 <buf>
  if(fd < 0){
    4b64:	06054e63          	bltz	a0,4be0 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4b68:	12c00613          	li	a2,300
    4b6c:	85ca                	mv	a1,s2
    4b6e:	8552                	mv	a0,s4
    4b70:	00001097          	auipc	ra,0x1
    4b74:	aa0080e7          	jalr	-1376(ra) # 5610 <read>
    if(cc < 0){
    4b78:	08054263          	bltz	a0,4bfc <bigfile+0x13a>
    if(cc == 0)
    4b7c:	c971                	beqz	a0,4c50 <bigfile+0x18e>
    if(cc != SZ/2){
    4b7e:	12c00793          	li	a5,300
    4b82:	08f51b63          	bne	a0,a5,4c18 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4b86:	01f4d79b          	srlw	a5,s1,0x1f
    4b8a:	9fa5                	addw	a5,a5,s1
    4b8c:	4017d79b          	sraw	a5,a5,0x1
    4b90:	00094703          	lbu	a4,0(s2)
    4b94:	0af71063          	bne	a4,a5,4c34 <bigfile+0x172>
    4b98:	12b94703          	lbu	a4,299(s2)
    4b9c:	08f71c63          	bne	a4,a5,4c34 <bigfile+0x172>
    total += cc;
    4ba0:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4ba4:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4ba6:	b7c9                	j	4b68 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4ba8:	85d6                	mv	a1,s5
    4baa:	00003517          	auipc	a0,0x3
    4bae:	ce650513          	add	a0,a0,-794 # 7890 <malloc+0x1e70>
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	db6080e7          	jalr	-586(ra) # 5968 <printf>
    exit(1);
    4bba:	4505                	li	a0,1
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	a3c080e7          	jalr	-1476(ra) # 55f8 <exit>
      printf("%s: write bigfile failed\n", s);
    4bc4:	85d6                	mv	a1,s5
    4bc6:	00003517          	auipc	a0,0x3
    4bca:	cea50513          	add	a0,a0,-790 # 78b0 <malloc+0x1e90>
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	d9a080e7          	jalr	-614(ra) # 5968 <printf>
      exit(1);
    4bd6:	4505                	li	a0,1
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	a20080e7          	jalr	-1504(ra) # 55f8 <exit>
    printf("%s: cannot open bigfile\n", s);
    4be0:	85d6                	mv	a1,s5
    4be2:	00003517          	auipc	a0,0x3
    4be6:	cee50513          	add	a0,a0,-786 # 78d0 <malloc+0x1eb0>
    4bea:	00001097          	auipc	ra,0x1
    4bee:	d7e080e7          	jalr	-642(ra) # 5968 <printf>
    exit(1);
    4bf2:	4505                	li	a0,1
    4bf4:	00001097          	auipc	ra,0x1
    4bf8:	a04080e7          	jalr	-1532(ra) # 55f8 <exit>
      printf("%s: read bigfile failed\n", s);
    4bfc:	85d6                	mv	a1,s5
    4bfe:	00003517          	auipc	a0,0x3
    4c02:	cf250513          	add	a0,a0,-782 # 78f0 <malloc+0x1ed0>
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	d62080e7          	jalr	-670(ra) # 5968 <printf>
      exit(1);
    4c0e:	4505                	li	a0,1
    4c10:	00001097          	auipc	ra,0x1
    4c14:	9e8080e7          	jalr	-1560(ra) # 55f8 <exit>
      printf("%s: short read bigfile\n", s);
    4c18:	85d6                	mv	a1,s5
    4c1a:	00003517          	auipc	a0,0x3
    4c1e:	cf650513          	add	a0,a0,-778 # 7910 <malloc+0x1ef0>
    4c22:	00001097          	auipc	ra,0x1
    4c26:	d46080e7          	jalr	-698(ra) # 5968 <printf>
      exit(1);
    4c2a:	4505                	li	a0,1
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	9cc080e7          	jalr	-1588(ra) # 55f8 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c34:	85d6                	mv	a1,s5
    4c36:	00003517          	auipc	a0,0x3
    4c3a:	cf250513          	add	a0,a0,-782 # 7928 <malloc+0x1f08>
    4c3e:	00001097          	auipc	ra,0x1
    4c42:	d2a080e7          	jalr	-726(ra) # 5968 <printf>
      exit(1);
    4c46:	4505                	li	a0,1
    4c48:	00001097          	auipc	ra,0x1
    4c4c:	9b0080e7          	jalr	-1616(ra) # 55f8 <exit>
  close(fd);
    4c50:	8552                	mv	a0,s4
    4c52:	00001097          	auipc	ra,0x1
    4c56:	9ce080e7          	jalr	-1586(ra) # 5620 <close>
  if(total != N*SZ){
    4c5a:	678d                	lui	a5,0x3
    4c5c:	ee078793          	add	a5,a5,-288 # 2ee0 <exitiputtest+0x4c>
    4c60:	02f99363          	bne	s3,a5,4c86 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4c64:	00003517          	auipc	a0,0x3
    4c68:	c1c50513          	add	a0,a0,-996 # 7880 <malloc+0x1e60>
    4c6c:	00001097          	auipc	ra,0x1
    4c70:	9dc080e7          	jalr	-1572(ra) # 5648 <unlink>
}
    4c74:	70e2                	ld	ra,56(sp)
    4c76:	7442                	ld	s0,48(sp)
    4c78:	74a2                	ld	s1,40(sp)
    4c7a:	7902                	ld	s2,32(sp)
    4c7c:	69e2                	ld	s3,24(sp)
    4c7e:	6a42                	ld	s4,16(sp)
    4c80:	6aa2                	ld	s5,8(sp)
    4c82:	6121                	add	sp,sp,64
    4c84:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4c86:	85d6                	mv	a1,s5
    4c88:	00003517          	auipc	a0,0x3
    4c8c:	cc050513          	add	a0,a0,-832 # 7948 <malloc+0x1f28>
    4c90:	00001097          	auipc	ra,0x1
    4c94:	cd8080e7          	jalr	-808(ra) # 5968 <printf>
    exit(1);
    4c98:	4505                	li	a0,1
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	95e080e7          	jalr	-1698(ra) # 55f8 <exit>

0000000000004ca2 <fsfull>:
{
    4ca2:	7135                	add	sp,sp,-160
    4ca4:	ed06                	sd	ra,152(sp)
    4ca6:	e922                	sd	s0,144(sp)
    4ca8:	e526                	sd	s1,136(sp)
    4caa:	e14a                	sd	s2,128(sp)
    4cac:	fcce                	sd	s3,120(sp)
    4cae:	f8d2                	sd	s4,112(sp)
    4cb0:	f4d6                	sd	s5,104(sp)
    4cb2:	f0da                	sd	s6,96(sp)
    4cb4:	ecde                	sd	s7,88(sp)
    4cb6:	e8e2                	sd	s8,80(sp)
    4cb8:	e4e6                	sd	s9,72(sp)
    4cba:	e0ea                	sd	s10,64(sp)
    4cbc:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    4cbe:	00003517          	auipc	a0,0x3
    4cc2:	caa50513          	add	a0,a0,-854 # 7968 <malloc+0x1f48>
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	ca2080e7          	jalr	-862(ra) # 5968 <printf>
  for(nfiles = 0; ; nfiles++){
    4cce:	4481                	li	s1,0
    name[0] = 'f';
    4cd0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4cd4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4cd8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4cdc:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4cde:	00003c97          	auipc	s9,0x3
    4ce2:	c9ac8c93          	add	s9,s9,-870 # 7978 <malloc+0x1f58>
    name[0] = 'f';
    4ce6:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4cea:	0384c7bb          	divw	a5,s1,s8
    4cee:	0307879b          	addw	a5,a5,48
    4cf2:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4cf6:	0384e7bb          	remw	a5,s1,s8
    4cfa:	0377c7bb          	divw	a5,a5,s7
    4cfe:	0307879b          	addw	a5,a5,48
    4d02:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d06:	0374e7bb          	remw	a5,s1,s7
    4d0a:	0367c7bb          	divw	a5,a5,s6
    4d0e:	0307879b          	addw	a5,a5,48
    4d12:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4d16:	0364e7bb          	remw	a5,s1,s6
    4d1a:	0307879b          	addw	a5,a5,48
    4d1e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4d22:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4d26:	f6040593          	add	a1,s0,-160
    4d2a:	8566                	mv	a0,s9
    4d2c:	00001097          	auipc	ra,0x1
    4d30:	c3c080e7          	jalr	-964(ra) # 5968 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d34:	20200593          	li	a1,514
    4d38:	f6040513          	add	a0,s0,-160
    4d3c:	00001097          	auipc	ra,0x1
    4d40:	8fc080e7          	jalr	-1796(ra) # 5638 <open>
    4d44:	892a                	mv	s2,a0
    if(fd < 0){
    4d46:	0a055563          	bgez	a0,4df0 <fsfull+0x14e>
      printf("open %s failed\n", name);
    4d4a:	f6040593          	add	a1,s0,-160
    4d4e:	00003517          	auipc	a0,0x3
    4d52:	c3a50513          	add	a0,a0,-966 # 7988 <malloc+0x1f68>
    4d56:	00001097          	auipc	ra,0x1
    4d5a:	c12080e7          	jalr	-1006(ra) # 5968 <printf>
  while(nfiles >= 0){
    4d5e:	0604c363          	bltz	s1,4dc4 <fsfull+0x122>
    name[0] = 'f';
    4d62:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d66:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d6a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d6e:	4929                	li	s2,10
  while(nfiles >= 0){
    4d70:	5afd                	li	s5,-1
    name[0] = 'f';
    4d72:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4d76:	0344c7bb          	divw	a5,s1,s4
    4d7a:	0307879b          	addw	a5,a5,48
    4d7e:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d82:	0344e7bb          	remw	a5,s1,s4
    4d86:	0337c7bb          	divw	a5,a5,s3
    4d8a:	0307879b          	addw	a5,a5,48
    4d8e:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d92:	0334e7bb          	remw	a5,s1,s3
    4d96:	0327c7bb          	divw	a5,a5,s2
    4d9a:	0307879b          	addw	a5,a5,48
    4d9e:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4da2:	0324e7bb          	remw	a5,s1,s2
    4da6:	0307879b          	addw	a5,a5,48
    4daa:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4dae:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4db2:	f6040513          	add	a0,s0,-160
    4db6:	00001097          	auipc	ra,0x1
    4dba:	892080e7          	jalr	-1902(ra) # 5648 <unlink>
    nfiles--;
    4dbe:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    4dc0:	fb5499e3          	bne	s1,s5,4d72 <fsfull+0xd0>
  printf("fsfull test finished\n");
    4dc4:	00003517          	auipc	a0,0x3
    4dc8:	be450513          	add	a0,a0,-1052 # 79a8 <malloc+0x1f88>
    4dcc:	00001097          	auipc	ra,0x1
    4dd0:	b9c080e7          	jalr	-1124(ra) # 5968 <printf>
}
    4dd4:	60ea                	ld	ra,152(sp)
    4dd6:	644a                	ld	s0,144(sp)
    4dd8:	64aa                	ld	s1,136(sp)
    4dda:	690a                	ld	s2,128(sp)
    4ddc:	79e6                	ld	s3,120(sp)
    4dde:	7a46                	ld	s4,112(sp)
    4de0:	7aa6                	ld	s5,104(sp)
    4de2:	7b06                	ld	s6,96(sp)
    4de4:	6be6                	ld	s7,88(sp)
    4de6:	6c46                	ld	s8,80(sp)
    4de8:	6ca6                	ld	s9,72(sp)
    4dea:	6d06                	ld	s10,64(sp)
    4dec:	610d                	add	sp,sp,160
    4dee:	8082                	ret
    int total = 0;
    4df0:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4df2:	00007a97          	auipc	s5,0x7
    4df6:	cdea8a93          	add	s5,s5,-802 # bad0 <buf>
      if(cc < BSIZE)
    4dfa:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4dfe:	40000613          	li	a2,1024
    4e02:	85d6                	mv	a1,s5
    4e04:	854a                	mv	a0,s2
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	812080e7          	jalr	-2030(ra) # 5618 <write>
      if(cc < BSIZE)
    4e0e:	00aa5563          	bge	s4,a0,4e18 <fsfull+0x176>
      total += cc;
    4e12:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e16:	b7e5                	j	4dfe <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    4e18:	85ce                	mv	a1,s3
    4e1a:	00003517          	auipc	a0,0x3
    4e1e:	b7e50513          	add	a0,a0,-1154 # 7998 <malloc+0x1f78>
    4e22:	00001097          	auipc	ra,0x1
    4e26:	b46080e7          	jalr	-1210(ra) # 5968 <printf>
    close(fd);
    4e2a:	854a                	mv	a0,s2
    4e2c:	00000097          	auipc	ra,0x0
    4e30:	7f4080e7          	jalr	2036(ra) # 5620 <close>
    if(total == 0)
    4e34:	f20985e3          	beqz	s3,4d5e <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    4e38:	2485                	addw	s1,s1,1
    4e3a:	b575                	j	4ce6 <fsfull+0x44>

0000000000004e3c <rand>:
{
    4e3c:	1141                	add	sp,sp,-16
    4e3e:	e422                	sd	s0,8(sp)
    4e40:	0800                	add	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e42:	00003717          	auipc	a4,0x3
    4e46:	46670713          	add	a4,a4,1126 # 82a8 <randstate>
    4e4a:	6308                	ld	a0,0(a4)
    4e4c:	001967b7          	lui	a5,0x196
    4e50:	60d78793          	add	a5,a5,1549 # 19660d <__BSS_END__+0x187b2d>
    4e54:	02f50533          	mul	a0,a0,a5
    4e58:	3c6ef7b7          	lui	a5,0x3c6ef
    4e5c:	35f78793          	add	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e087f>
    4e60:	953e                	add	a0,a0,a5
    4e62:	e308                	sd	a0,0(a4)
}
    4e64:	2501                	sext.w	a0,a0
    4e66:	6422                	ld	s0,8(sp)
    4e68:	0141                	add	sp,sp,16
    4e6a:	8082                	ret

0000000000004e6c <badwrite>:
{
    4e6c:	7179                	add	sp,sp,-48
    4e6e:	f406                	sd	ra,40(sp)
    4e70:	f022                	sd	s0,32(sp)
    4e72:	ec26                	sd	s1,24(sp)
    4e74:	e84a                	sd	s2,16(sp)
    4e76:	e44e                	sd	s3,8(sp)
    4e78:	e052                	sd	s4,0(sp)
    4e7a:	1800                	add	s0,sp,48
  unlink("junk");
    4e7c:	00003517          	auipc	a0,0x3
    4e80:	b4450513          	add	a0,a0,-1212 # 79c0 <malloc+0x1fa0>
    4e84:	00000097          	auipc	ra,0x0
    4e88:	7c4080e7          	jalr	1988(ra) # 5648 <unlink>
    4e8c:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4e90:	00003997          	auipc	s3,0x3
    4e94:	b3098993          	add	s3,s3,-1232 # 79c0 <malloc+0x1fa0>
    write(fd, (char*)0xffffffffffL, 1);
    4e98:	5a7d                	li	s4,-1
    4e9a:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4e9e:	20100593          	li	a1,513
    4ea2:	854e                	mv	a0,s3
    4ea4:	00000097          	auipc	ra,0x0
    4ea8:	794080e7          	jalr	1940(ra) # 5638 <open>
    4eac:	84aa                	mv	s1,a0
    if(fd < 0){
    4eae:	06054b63          	bltz	a0,4f24 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4eb2:	4605                	li	a2,1
    4eb4:	85d2                	mv	a1,s4
    4eb6:	00000097          	auipc	ra,0x0
    4eba:	762080e7          	jalr	1890(ra) # 5618 <write>
    close(fd);
    4ebe:	8526                	mv	a0,s1
    4ec0:	00000097          	auipc	ra,0x0
    4ec4:	760080e7          	jalr	1888(ra) # 5620 <close>
    unlink("junk");
    4ec8:	854e                	mv	a0,s3
    4eca:	00000097          	auipc	ra,0x0
    4ece:	77e080e7          	jalr	1918(ra) # 5648 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4ed2:	397d                	addw	s2,s2,-1
    4ed4:	fc0915e3          	bnez	s2,4e9e <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4ed8:	20100593          	li	a1,513
    4edc:	00003517          	auipc	a0,0x3
    4ee0:	ae450513          	add	a0,a0,-1308 # 79c0 <malloc+0x1fa0>
    4ee4:	00000097          	auipc	ra,0x0
    4ee8:	754080e7          	jalr	1876(ra) # 5638 <open>
    4eec:	84aa                	mv	s1,a0
  if(fd < 0){
    4eee:	04054863          	bltz	a0,4f3e <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4ef2:	4605                	li	a2,1
    4ef4:	00001597          	auipc	a1,0x1
    4ef8:	cbc58593          	add	a1,a1,-836 # 5bb0 <malloc+0x190>
    4efc:	00000097          	auipc	ra,0x0
    4f00:	71c080e7          	jalr	1820(ra) # 5618 <write>
    4f04:	4785                	li	a5,1
    4f06:	04f50963          	beq	a0,a5,4f58 <badwrite+0xec>
    printf("write failed\n");
    4f0a:	00003517          	auipc	a0,0x3
    4f0e:	ad650513          	add	a0,a0,-1322 # 79e0 <malloc+0x1fc0>
    4f12:	00001097          	auipc	ra,0x1
    4f16:	a56080e7          	jalr	-1450(ra) # 5968 <printf>
    exit(1);
    4f1a:	4505                	li	a0,1
    4f1c:	00000097          	auipc	ra,0x0
    4f20:	6dc080e7          	jalr	1756(ra) # 55f8 <exit>
      printf("open junk failed\n");
    4f24:	00003517          	auipc	a0,0x3
    4f28:	aa450513          	add	a0,a0,-1372 # 79c8 <malloc+0x1fa8>
    4f2c:	00001097          	auipc	ra,0x1
    4f30:	a3c080e7          	jalr	-1476(ra) # 5968 <printf>
      exit(1);
    4f34:	4505                	li	a0,1
    4f36:	00000097          	auipc	ra,0x0
    4f3a:	6c2080e7          	jalr	1730(ra) # 55f8 <exit>
    printf("open junk failed\n");
    4f3e:	00003517          	auipc	a0,0x3
    4f42:	a8a50513          	add	a0,a0,-1398 # 79c8 <malloc+0x1fa8>
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	a22080e7          	jalr	-1502(ra) # 5968 <printf>
    exit(1);
    4f4e:	4505                	li	a0,1
    4f50:	00000097          	auipc	ra,0x0
    4f54:	6a8080e7          	jalr	1704(ra) # 55f8 <exit>
  close(fd);
    4f58:	8526                	mv	a0,s1
    4f5a:	00000097          	auipc	ra,0x0
    4f5e:	6c6080e7          	jalr	1734(ra) # 5620 <close>
  unlink("junk");
    4f62:	00003517          	auipc	a0,0x3
    4f66:	a5e50513          	add	a0,a0,-1442 # 79c0 <malloc+0x1fa0>
    4f6a:	00000097          	auipc	ra,0x0
    4f6e:	6de080e7          	jalr	1758(ra) # 5648 <unlink>
  exit(0);
    4f72:	4501                	li	a0,0
    4f74:	00000097          	auipc	ra,0x0
    4f78:	684080e7          	jalr	1668(ra) # 55f8 <exit>

0000000000004f7c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4f7c:	7139                	add	sp,sp,-64
    4f7e:	fc06                	sd	ra,56(sp)
    4f80:	f822                	sd	s0,48(sp)
    4f82:	f426                	sd	s1,40(sp)
    4f84:	f04a                	sd	s2,32(sp)
    4f86:	ec4e                	sd	s3,24(sp)
    4f88:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4f8a:	fc840513          	add	a0,s0,-56
    4f8e:	00000097          	auipc	ra,0x0
    4f92:	67a080e7          	jalr	1658(ra) # 5608 <pipe>
    4f96:	06054763          	bltz	a0,5004 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4f9a:	00000097          	auipc	ra,0x0
    4f9e:	656080e7          	jalr	1622(ra) # 55f0 <fork>

  if(pid < 0){
    4fa2:	06054e63          	bltz	a0,501e <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4fa6:	ed51                	bnez	a0,5042 <countfree+0xc6>
    close(fds[0]);
    4fa8:	fc842503          	lw	a0,-56(s0)
    4fac:	00000097          	auipc	ra,0x0
    4fb0:	674080e7          	jalr	1652(ra) # 5620 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4fb4:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4fb6:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4fb8:	00001997          	auipc	s3,0x1
    4fbc:	bf898993          	add	s3,s3,-1032 # 5bb0 <malloc+0x190>
      uint64 a = (uint64) sbrk(4096);
    4fc0:	6505                	lui	a0,0x1
    4fc2:	00000097          	auipc	ra,0x0
    4fc6:	6be080e7          	jalr	1726(ra) # 5680 <sbrk>
      if(a == 0xffffffffffffffff){
    4fca:	07250763          	beq	a0,s2,5038 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4fce:	6785                	lui	a5,0x1
    4fd0:	97aa                	add	a5,a5,a0
    4fd2:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    4fd6:	8626                	mv	a2,s1
    4fd8:	85ce                	mv	a1,s3
    4fda:	fcc42503          	lw	a0,-52(s0)
    4fde:	00000097          	auipc	ra,0x0
    4fe2:	63a080e7          	jalr	1594(ra) # 5618 <write>
    4fe6:	fc950de3          	beq	a0,s1,4fc0 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	a4650513          	add	a0,a0,-1466 # 7a30 <malloc+0x2010>
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	976080e7          	jalr	-1674(ra) # 5968 <printf>
        exit(1);
    4ffa:	4505                	li	a0,1
    4ffc:	00000097          	auipc	ra,0x0
    5000:	5fc080e7          	jalr	1532(ra) # 55f8 <exit>
    printf("pipe() failed in countfree()\n");
    5004:	00003517          	auipc	a0,0x3
    5008:	9ec50513          	add	a0,a0,-1556 # 79f0 <malloc+0x1fd0>
    500c:	00001097          	auipc	ra,0x1
    5010:	95c080e7          	jalr	-1700(ra) # 5968 <printf>
    exit(1);
    5014:	4505                	li	a0,1
    5016:	00000097          	auipc	ra,0x0
    501a:	5e2080e7          	jalr	1506(ra) # 55f8 <exit>
    printf("fork failed in countfree()\n");
    501e:	00003517          	auipc	a0,0x3
    5022:	9f250513          	add	a0,a0,-1550 # 7a10 <malloc+0x1ff0>
    5026:	00001097          	auipc	ra,0x1
    502a:	942080e7          	jalr	-1726(ra) # 5968 <printf>
    exit(1);
    502e:	4505                	li	a0,1
    5030:	00000097          	auipc	ra,0x0
    5034:	5c8080e7          	jalr	1480(ra) # 55f8 <exit>
      }
    }

    exit(0);
    5038:	4501                	li	a0,0
    503a:	00000097          	auipc	ra,0x0
    503e:	5be080e7          	jalr	1470(ra) # 55f8 <exit>
  }

  close(fds[1]);
    5042:	fcc42503          	lw	a0,-52(s0)
    5046:	00000097          	auipc	ra,0x0
    504a:	5da080e7          	jalr	1498(ra) # 5620 <close>

  int n = 0;
    504e:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5050:	4605                	li	a2,1
    5052:	fc740593          	add	a1,s0,-57
    5056:	fc842503          	lw	a0,-56(s0)
    505a:	00000097          	auipc	ra,0x0
    505e:	5b6080e7          	jalr	1462(ra) # 5610 <read>
    if(cc < 0){
    5062:	00054563          	bltz	a0,506c <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5066:	c105                	beqz	a0,5086 <countfree+0x10a>
      break;
    n += 1;
    5068:	2485                	addw	s1,s1,1
  while(1){
    506a:	b7dd                	j	5050 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    506c:	00003517          	auipc	a0,0x3
    5070:	9e450513          	add	a0,a0,-1564 # 7a50 <malloc+0x2030>
    5074:	00001097          	auipc	ra,0x1
    5078:	8f4080e7          	jalr	-1804(ra) # 5968 <printf>
      exit(1);
    507c:	4505                	li	a0,1
    507e:	00000097          	auipc	ra,0x0
    5082:	57a080e7          	jalr	1402(ra) # 55f8 <exit>
  }

  close(fds[0]);
    5086:	fc842503          	lw	a0,-56(s0)
    508a:	00000097          	auipc	ra,0x0
    508e:	596080e7          	jalr	1430(ra) # 5620 <close>
  wait((int*)0);
    5092:	4501                	li	a0,0
    5094:	00000097          	auipc	ra,0x0
    5098:	56c080e7          	jalr	1388(ra) # 5600 <wait>
  
  return n;
}
    509c:	8526                	mv	a0,s1
    509e:	70e2                	ld	ra,56(sp)
    50a0:	7442                	ld	s0,48(sp)
    50a2:	74a2                	ld	s1,40(sp)
    50a4:	7902                	ld	s2,32(sp)
    50a6:	69e2                	ld	s3,24(sp)
    50a8:	6121                	add	sp,sp,64
    50aa:	8082                	ret

00000000000050ac <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    50ac:	7179                	add	sp,sp,-48
    50ae:	f406                	sd	ra,40(sp)
    50b0:	f022                	sd	s0,32(sp)
    50b2:	ec26                	sd	s1,24(sp)
    50b4:	e84a                	sd	s2,16(sp)
    50b6:	1800                	add	s0,sp,48
    50b8:	84aa                	mv	s1,a0
    50ba:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    50bc:	00003517          	auipc	a0,0x3
    50c0:	9b450513          	add	a0,a0,-1612 # 7a70 <malloc+0x2050>
    50c4:	00001097          	auipc	ra,0x1
    50c8:	8a4080e7          	jalr	-1884(ra) # 5968 <printf>
  if((pid = fork()) < 0) {
    50cc:	00000097          	auipc	ra,0x0
    50d0:	524080e7          	jalr	1316(ra) # 55f0 <fork>
    50d4:	02054e63          	bltz	a0,5110 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    50d8:	c929                	beqz	a0,512a <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    50da:	fdc40513          	add	a0,s0,-36
    50de:	00000097          	auipc	ra,0x0
    50e2:	522080e7          	jalr	1314(ra) # 5600 <wait>
    if(xstatus != 0) 
    50e6:	fdc42783          	lw	a5,-36(s0)
    50ea:	c7b9                	beqz	a5,5138 <run+0x8c>
      printf("FAILED\n");
    50ec:	00003517          	auipc	a0,0x3
    50f0:	9ac50513          	add	a0,a0,-1620 # 7a98 <malloc+0x2078>
    50f4:	00001097          	auipc	ra,0x1
    50f8:	874080e7          	jalr	-1932(ra) # 5968 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    50fc:	fdc42503          	lw	a0,-36(s0)
  }
}
    5100:	00153513          	seqz	a0,a0
    5104:	70a2                	ld	ra,40(sp)
    5106:	7402                	ld	s0,32(sp)
    5108:	64e2                	ld	s1,24(sp)
    510a:	6942                	ld	s2,16(sp)
    510c:	6145                	add	sp,sp,48
    510e:	8082                	ret
    printf("runtest: fork error\n");
    5110:	00003517          	auipc	a0,0x3
    5114:	97050513          	add	a0,a0,-1680 # 7a80 <malloc+0x2060>
    5118:	00001097          	auipc	ra,0x1
    511c:	850080e7          	jalr	-1968(ra) # 5968 <printf>
    exit(1);
    5120:	4505                	li	a0,1
    5122:	00000097          	auipc	ra,0x0
    5126:	4d6080e7          	jalr	1238(ra) # 55f8 <exit>
    f(s);
    512a:	854a                	mv	a0,s2
    512c:	9482                	jalr	s1
    exit(0);
    512e:	4501                	li	a0,0
    5130:	00000097          	auipc	ra,0x0
    5134:	4c8080e7          	jalr	1224(ra) # 55f8 <exit>
      printf("OK\n");
    5138:	00003517          	auipc	a0,0x3
    513c:	96850513          	add	a0,a0,-1688 # 7aa0 <malloc+0x2080>
    5140:	00001097          	auipc	ra,0x1
    5144:	828080e7          	jalr	-2008(ra) # 5968 <printf>
    5148:	bf55                	j	50fc <run+0x50>

000000000000514a <main>:

int
main(int argc, char *argv[])
{
    514a:	c1010113          	add	sp,sp,-1008
    514e:	3e113423          	sd	ra,1000(sp)
    5152:	3e813023          	sd	s0,992(sp)
    5156:	3c913c23          	sd	s1,984(sp)
    515a:	3d213823          	sd	s2,976(sp)
    515e:	3d313423          	sd	s3,968(sp)
    5162:	3d413023          	sd	s4,960(sp)
    5166:	3b513c23          	sd	s5,952(sp)
    516a:	3b613823          	sd	s6,944(sp)
    516e:	1f80                	add	s0,sp,1008
    5170:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5172:	4789                	li	a5,2
    5174:	08f50c63          	beq	a0,a5,520c <main+0xc2>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5178:	4785                	li	a5,1
    517a:	12a7c563          	blt	a5,a0,52a4 <main+0x15a>
  char *justone = 0;
    517e:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5180:	00003797          	auipc	a5,0x3
    5184:	cf878793          	add	a5,a5,-776 # 7e78 <malloc+0x2458>
    5188:	c1040713          	add	a4,s0,-1008
    518c:	00003817          	auipc	a6,0x3
    5190:	08c80813          	add	a6,a6,140 # 8218 <malloc+0x27f8>
    5194:	6388                	ld	a0,0(a5)
    5196:	678c                	ld	a1,8(a5)
    5198:	6b90                	ld	a2,16(a5)
    519a:	6f94                	ld	a3,24(a5)
    519c:	e308                	sd	a0,0(a4)
    519e:	e70c                	sd	a1,8(a4)
    51a0:	eb10                	sd	a2,16(a4)
    51a2:	ef14                	sd	a3,24(a4)
    51a4:	02078793          	add	a5,a5,32
    51a8:	02070713          	add	a4,a4,32
    51ac:	ff0794e3          	bne	a5,a6,5194 <main+0x4a>
    51b0:	6394                	ld	a3,0(a5)
    51b2:	679c                	ld	a5,8(a5)
    51b4:	e314                	sd	a3,0(a4)
    51b6:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    51b8:	00003517          	auipc	a0,0x3
    51bc:	9a850513          	add	a0,a0,-1624 # 7b60 <malloc+0x2140>
    51c0:	00000097          	auipc	ra,0x0
    51c4:	7a8080e7          	jalr	1960(ra) # 5968 <printf>
  int free0 = countfree();
    51c8:	00000097          	auipc	ra,0x0
    51cc:	db4080e7          	jalr	-588(ra) # 4f7c <countfree>
    51d0:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51d2:	c1843903          	ld	s2,-1000(s0)
    51d6:	c1040493          	add	s1,s0,-1008
  int fail = 0;
    51da:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    51dc:	4b05                	li	s6,1
  for (struct test *t = tests; t->s != 0; t++) {
    51de:	10091863          	bnez	s2,52ee <main+0x1a4>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    51e2:	00000097          	auipc	ra,0x0
    51e6:	d9a080e7          	jalr	-614(ra) # 4f7c <countfree>
    51ea:	85aa                	mv	a1,a0
    51ec:	15555263          	bge	a0,s5,5330 <main+0x1e6>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    51f0:	8656                	mv	a2,s5
    51f2:	00003517          	auipc	a0,0x3
    51f6:	92650513          	add	a0,a0,-1754 # 7b18 <malloc+0x20f8>
    51fa:	00000097          	auipc	ra,0x0
    51fe:	76e080e7          	jalr	1902(ra) # 5968 <printf>
    exit(1);
    5202:	4505                	li	a0,1
    5204:	00000097          	auipc	ra,0x0
    5208:	3f4080e7          	jalr	1012(ra) # 55f8 <exit>
    520c:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    520e:	00003597          	auipc	a1,0x3
    5212:	89a58593          	add	a1,a1,-1894 # 7aa8 <malloc+0x2088>
    5216:	6488                	ld	a0,8(s1)
    5218:	00000097          	auipc	ra,0x0
    521c:	190080e7          	jalr	400(ra) # 53a8 <strcmp>
    5220:	e125                	bnez	a0,5280 <main+0x136>
    continuous = 1;
    5222:	4985                	li	s3,1
  } tests[] = {
    5224:	00003797          	auipc	a5,0x3
    5228:	c5478793          	add	a5,a5,-940 # 7e78 <malloc+0x2458>
    522c:	c1040713          	add	a4,s0,-1008
    5230:	00003817          	auipc	a6,0x3
    5234:	fe880813          	add	a6,a6,-24 # 8218 <malloc+0x27f8>
    5238:	6388                	ld	a0,0(a5)
    523a:	678c                	ld	a1,8(a5)
    523c:	6b90                	ld	a2,16(a5)
    523e:	6f94                	ld	a3,24(a5)
    5240:	e308                	sd	a0,0(a4)
    5242:	e70c                	sd	a1,8(a4)
    5244:	eb10                	sd	a2,16(a4)
    5246:	ef14                	sd	a3,24(a4)
    5248:	02078793          	add	a5,a5,32
    524c:	02070713          	add	a4,a4,32
    5250:	ff0794e3          	bne	a5,a6,5238 <main+0xee>
    5254:	6394                	ld	a3,0(a5)
    5256:	679c                	ld	a5,8(a5)
    5258:	e314                	sd	a3,0(a4)
    525a:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    525c:	00003517          	auipc	a0,0x3
    5260:	91c50513          	add	a0,a0,-1764 # 7b78 <malloc+0x2158>
    5264:	00000097          	auipc	ra,0x0
    5268:	704080e7          	jalr	1796(ra) # 5968 <printf>
        printf("SOME TESTS FAILED\n");
    526c:	00003a97          	auipc	s5,0x3
    5270:	894a8a93          	add	s5,s5,-1900 # 7b00 <malloc+0x20e0>
        if(continuous != 2)
    5274:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5276:	00003b17          	auipc	s6,0x3
    527a:	86ab0b13          	add	s6,s6,-1942 # 7ae0 <malloc+0x20c0>
    527e:	a0dd                	j	5364 <main+0x21a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5280:	00003597          	auipc	a1,0x3
    5284:	83058593          	add	a1,a1,-2000 # 7ab0 <malloc+0x2090>
    5288:	6488                	ld	a0,8(s1)
    528a:	00000097          	auipc	ra,0x0
    528e:	11e080e7          	jalr	286(ra) # 53a8 <strcmp>
    5292:	d949                	beqz	a0,5224 <main+0xda>
  } else if(argc == 2 && argv[1][0] != '-'){
    5294:	0084b983          	ld	s3,8(s1)
    5298:	0009c703          	lbu	a4,0(s3)
    529c:	02d00793          	li	a5,45
    52a0:	eef710e3          	bne	a4,a5,5180 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    52a4:	00003517          	auipc	a0,0x3
    52a8:	81450513          	add	a0,a0,-2028 # 7ab8 <malloc+0x2098>
    52ac:	00000097          	auipc	ra,0x0
    52b0:	6bc080e7          	jalr	1724(ra) # 5968 <printf>
    exit(1);
    52b4:	4505                	li	a0,1
    52b6:	00000097          	auipc	ra,0x0
    52ba:	342080e7          	jalr	834(ra) # 55f8 <exit>
          exit(1);
    52be:	4505                	li	a0,1
    52c0:	00000097          	auipc	ra,0x0
    52c4:	338080e7          	jalr	824(ra) # 55f8 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    52c8:	40a905bb          	subw	a1,s2,a0
    52cc:	855a                	mv	a0,s6
    52ce:	00000097          	auipc	ra,0x0
    52d2:	69a080e7          	jalr	1690(ra) # 5968 <printf>
        if(continuous != 2)
    52d6:	09498763          	beq	s3,s4,5364 <main+0x21a>
          exit(1);
    52da:	4505                	li	a0,1
    52dc:	00000097          	auipc	ra,0x0
    52e0:	31c080e7          	jalr	796(ra) # 55f8 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    52e4:	04c1                	add	s1,s1,16
    52e6:	0084b903          	ld	s2,8(s1)
    52ea:	02090463          	beqz	s2,5312 <main+0x1c8>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52ee:	00098963          	beqz	s3,5300 <main+0x1b6>
    52f2:	85ce                	mv	a1,s3
    52f4:	854a                	mv	a0,s2
    52f6:	00000097          	auipc	ra,0x0
    52fa:	0b2080e7          	jalr	178(ra) # 53a8 <strcmp>
    52fe:	f17d                	bnez	a0,52e4 <main+0x19a>
      if(!run(t->f, t->s))
    5300:	85ca                	mv	a1,s2
    5302:	6088                	ld	a0,0(s1)
    5304:	00000097          	auipc	ra,0x0
    5308:	da8080e7          	jalr	-600(ra) # 50ac <run>
    530c:	fd61                	bnez	a0,52e4 <main+0x19a>
        fail = 1;
    530e:	8a5a                	mv	s4,s6
    5310:	bfd1                	j	52e4 <main+0x19a>
  if(fail){
    5312:	ec0a08e3          	beqz	s4,51e2 <main+0x98>
    printf("SOME TESTS FAILED\n");
    5316:	00002517          	auipc	a0,0x2
    531a:	7ea50513          	add	a0,a0,2026 # 7b00 <malloc+0x20e0>
    531e:	00000097          	auipc	ra,0x0
    5322:	64a080e7          	jalr	1610(ra) # 5968 <printf>
    exit(1);
    5326:	4505                	li	a0,1
    5328:	00000097          	auipc	ra,0x0
    532c:	2d0080e7          	jalr	720(ra) # 55f8 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5330:	00003517          	auipc	a0,0x3
    5334:	81850513          	add	a0,a0,-2024 # 7b48 <malloc+0x2128>
    5338:	00000097          	auipc	ra,0x0
    533c:	630080e7          	jalr	1584(ra) # 5968 <printf>
    exit(0);
    5340:	4501                	li	a0,0
    5342:	00000097          	auipc	ra,0x0
    5346:	2b6080e7          	jalr	694(ra) # 55f8 <exit>
        printf("SOME TESTS FAILED\n");
    534a:	8556                	mv	a0,s5
    534c:	00000097          	auipc	ra,0x0
    5350:	61c080e7          	jalr	1564(ra) # 5968 <printf>
        if(continuous != 2)
    5354:	f74995e3          	bne	s3,s4,52be <main+0x174>
      int free1 = countfree();
    5358:	00000097          	auipc	ra,0x0
    535c:	c24080e7          	jalr	-988(ra) # 4f7c <countfree>
      if(free1 < free0){
    5360:	f72544e3          	blt	a0,s2,52c8 <main+0x17e>
      int free0 = countfree();
    5364:	00000097          	auipc	ra,0x0
    5368:	c18080e7          	jalr	-1000(ra) # 4f7c <countfree>
    536c:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    536e:	c1843583          	ld	a1,-1000(s0)
    5372:	d1fd                	beqz	a1,5358 <main+0x20e>
    5374:	c1040493          	add	s1,s0,-1008
        if(!run(t->f, t->s)){
    5378:	6088                	ld	a0,0(s1)
    537a:	00000097          	auipc	ra,0x0
    537e:	d32080e7          	jalr	-718(ra) # 50ac <run>
    5382:	d561                	beqz	a0,534a <main+0x200>
      for (struct test *t = tests; t->s != 0; t++) {
    5384:	04c1                	add	s1,s1,16
    5386:	648c                	ld	a1,8(s1)
    5388:	f9e5                	bnez	a1,5378 <main+0x22e>
    538a:	b7f9                	j	5358 <main+0x20e>

000000000000538c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    538c:	1141                	add	sp,sp,-16
    538e:	e422                	sd	s0,8(sp)
    5390:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5392:	87aa                	mv	a5,a0
    5394:	0585                	add	a1,a1,1
    5396:	0785                	add	a5,a5,1
    5398:	fff5c703          	lbu	a4,-1(a1)
    539c:	fee78fa3          	sb	a4,-1(a5)
    53a0:	fb75                	bnez	a4,5394 <strcpy+0x8>
    ;
  return os;
}
    53a2:	6422                	ld	s0,8(sp)
    53a4:	0141                	add	sp,sp,16
    53a6:	8082                	ret

00000000000053a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53a8:	1141                	add	sp,sp,-16
    53aa:	e422                	sd	s0,8(sp)
    53ac:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    53ae:	00054783          	lbu	a5,0(a0)
    53b2:	cb91                	beqz	a5,53c6 <strcmp+0x1e>
    53b4:	0005c703          	lbu	a4,0(a1)
    53b8:	00f71763          	bne	a4,a5,53c6 <strcmp+0x1e>
    p++, q++;
    53bc:	0505                	add	a0,a0,1
    53be:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    53c0:	00054783          	lbu	a5,0(a0)
    53c4:	fbe5                	bnez	a5,53b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    53c6:	0005c503          	lbu	a0,0(a1)
}
    53ca:	40a7853b          	subw	a0,a5,a0
    53ce:	6422                	ld	s0,8(sp)
    53d0:	0141                	add	sp,sp,16
    53d2:	8082                	ret

00000000000053d4 <strlen>:

uint
strlen(const char *s)
{
    53d4:	1141                	add	sp,sp,-16
    53d6:	e422                	sd	s0,8(sp)
    53d8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    53da:	00054783          	lbu	a5,0(a0)
    53de:	cf91                	beqz	a5,53fa <strlen+0x26>
    53e0:	0505                	add	a0,a0,1
    53e2:	87aa                	mv	a5,a0
    53e4:	86be                	mv	a3,a5
    53e6:	0785                	add	a5,a5,1
    53e8:	fff7c703          	lbu	a4,-1(a5)
    53ec:	ff65                	bnez	a4,53e4 <strlen+0x10>
    53ee:	40a6853b          	subw	a0,a3,a0
    53f2:	2505                	addw	a0,a0,1
    ;
  return n;
}
    53f4:	6422                	ld	s0,8(sp)
    53f6:	0141                	add	sp,sp,16
    53f8:	8082                	ret
  for(n = 0; s[n]; n++)
    53fa:	4501                	li	a0,0
    53fc:	bfe5                	j	53f4 <strlen+0x20>

00000000000053fe <memset>:

void*
memset(void *dst, int c, uint n)
{
    53fe:	1141                	add	sp,sp,-16
    5400:	e422                	sd	s0,8(sp)
    5402:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5404:	ca19                	beqz	a2,541a <memset+0x1c>
    5406:	87aa                	mv	a5,a0
    5408:	1602                	sll	a2,a2,0x20
    540a:	9201                	srl	a2,a2,0x20
    540c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5410:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5414:	0785                	add	a5,a5,1
    5416:	fee79de3          	bne	a5,a4,5410 <memset+0x12>
  }
  return dst;
}
    541a:	6422                	ld	s0,8(sp)
    541c:	0141                	add	sp,sp,16
    541e:	8082                	ret

0000000000005420 <strchr>:

char*
strchr(const char *s, char c)
{
    5420:	1141                	add	sp,sp,-16
    5422:	e422                	sd	s0,8(sp)
    5424:	0800                	add	s0,sp,16
  for(; *s; s++)
    5426:	00054783          	lbu	a5,0(a0)
    542a:	cb99                	beqz	a5,5440 <strchr+0x20>
    if(*s == c)
    542c:	00f58763          	beq	a1,a5,543a <strchr+0x1a>
  for(; *s; s++)
    5430:	0505                	add	a0,a0,1
    5432:	00054783          	lbu	a5,0(a0)
    5436:	fbfd                	bnez	a5,542c <strchr+0xc>
      return (char*)s;
  return 0;
    5438:	4501                	li	a0,0
}
    543a:	6422                	ld	s0,8(sp)
    543c:	0141                	add	sp,sp,16
    543e:	8082                	ret
  return 0;
    5440:	4501                	li	a0,0
    5442:	bfe5                	j	543a <strchr+0x1a>

0000000000005444 <gets>:

char*
gets(char *buf, int max)
{
    5444:	711d                	add	sp,sp,-96
    5446:	ec86                	sd	ra,88(sp)
    5448:	e8a2                	sd	s0,80(sp)
    544a:	e4a6                	sd	s1,72(sp)
    544c:	e0ca                	sd	s2,64(sp)
    544e:	fc4e                	sd	s3,56(sp)
    5450:	f852                	sd	s4,48(sp)
    5452:	f456                	sd	s5,40(sp)
    5454:	f05a                	sd	s6,32(sp)
    5456:	ec5e                	sd	s7,24(sp)
    5458:	1080                	add	s0,sp,96
    545a:	8baa                	mv	s7,a0
    545c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    545e:	892a                	mv	s2,a0
    5460:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5462:	4aa9                	li	s5,10
    5464:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5466:	89a6                	mv	s3,s1
    5468:	2485                	addw	s1,s1,1
    546a:	0344d863          	bge	s1,s4,549a <gets+0x56>
    cc = read(0, &c, 1);
    546e:	4605                	li	a2,1
    5470:	faf40593          	add	a1,s0,-81
    5474:	4501                	li	a0,0
    5476:	00000097          	auipc	ra,0x0
    547a:	19a080e7          	jalr	410(ra) # 5610 <read>
    if(cc < 1)
    547e:	00a05e63          	blez	a0,549a <gets+0x56>
    buf[i++] = c;
    5482:	faf44783          	lbu	a5,-81(s0)
    5486:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    548a:	01578763          	beq	a5,s5,5498 <gets+0x54>
    548e:	0905                	add	s2,s2,1
    5490:	fd679be3          	bne	a5,s6,5466 <gets+0x22>
  for(i=0; i+1 < max; ){
    5494:	89a6                	mv	s3,s1
    5496:	a011                	j	549a <gets+0x56>
    5498:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    549a:	99de                	add	s3,s3,s7
    549c:	00098023          	sb	zero,0(s3)
  return buf;
}
    54a0:	855e                	mv	a0,s7
    54a2:	60e6                	ld	ra,88(sp)
    54a4:	6446                	ld	s0,80(sp)
    54a6:	64a6                	ld	s1,72(sp)
    54a8:	6906                	ld	s2,64(sp)
    54aa:	79e2                	ld	s3,56(sp)
    54ac:	7a42                	ld	s4,48(sp)
    54ae:	7aa2                	ld	s5,40(sp)
    54b0:	7b02                	ld	s6,32(sp)
    54b2:	6be2                	ld	s7,24(sp)
    54b4:	6125                	add	sp,sp,96
    54b6:	8082                	ret

00000000000054b8 <stat>:

int
stat(const char *n, struct stat *st)
{
    54b8:	1101                	add	sp,sp,-32
    54ba:	ec06                	sd	ra,24(sp)
    54bc:	e822                	sd	s0,16(sp)
    54be:	e426                	sd	s1,8(sp)
    54c0:	e04a                	sd	s2,0(sp)
    54c2:	1000                	add	s0,sp,32
    54c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    54c6:	4581                	li	a1,0
    54c8:	00000097          	auipc	ra,0x0
    54cc:	170080e7          	jalr	368(ra) # 5638 <open>
  if(fd < 0)
    54d0:	02054563          	bltz	a0,54fa <stat+0x42>
    54d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    54d6:	85ca                	mv	a1,s2
    54d8:	00000097          	auipc	ra,0x0
    54dc:	178080e7          	jalr	376(ra) # 5650 <fstat>
    54e0:	892a                	mv	s2,a0
  close(fd);
    54e2:	8526                	mv	a0,s1
    54e4:	00000097          	auipc	ra,0x0
    54e8:	13c080e7          	jalr	316(ra) # 5620 <close>
  return r;
}
    54ec:	854a                	mv	a0,s2
    54ee:	60e2                	ld	ra,24(sp)
    54f0:	6442                	ld	s0,16(sp)
    54f2:	64a2                	ld	s1,8(sp)
    54f4:	6902                	ld	s2,0(sp)
    54f6:	6105                	add	sp,sp,32
    54f8:	8082                	ret
    return -1;
    54fa:	597d                	li	s2,-1
    54fc:	bfc5                	j	54ec <stat+0x34>

00000000000054fe <atoi>:

int
atoi(const char *s)
{
    54fe:	1141                	add	sp,sp,-16
    5500:	e422                	sd	s0,8(sp)
    5502:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5504:	00054683          	lbu	a3,0(a0)
    5508:	fd06879b          	addw	a5,a3,-48
    550c:	0ff7f793          	zext.b	a5,a5
    5510:	4625                	li	a2,9
    5512:	02f66863          	bltu	a2,a5,5542 <atoi+0x44>
    5516:	872a                	mv	a4,a0
  n = 0;
    5518:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    551a:	0705                	add	a4,a4,1
    551c:	0025179b          	sllw	a5,a0,0x2
    5520:	9fa9                	addw	a5,a5,a0
    5522:	0017979b          	sllw	a5,a5,0x1
    5526:	9fb5                	addw	a5,a5,a3
    5528:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    552c:	00074683          	lbu	a3,0(a4)
    5530:	fd06879b          	addw	a5,a3,-48
    5534:	0ff7f793          	zext.b	a5,a5
    5538:	fef671e3          	bgeu	a2,a5,551a <atoi+0x1c>
  return n;
}
    553c:	6422                	ld	s0,8(sp)
    553e:	0141                	add	sp,sp,16
    5540:	8082                	ret
  n = 0;
    5542:	4501                	li	a0,0
    5544:	bfe5                	j	553c <atoi+0x3e>

0000000000005546 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5546:	1141                	add	sp,sp,-16
    5548:	e422                	sd	s0,8(sp)
    554a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    554c:	02b57463          	bgeu	a0,a1,5574 <memmove+0x2e>
    while(n-- > 0)
    5550:	00c05f63          	blez	a2,556e <memmove+0x28>
    5554:	1602                	sll	a2,a2,0x20
    5556:	9201                	srl	a2,a2,0x20
    5558:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    555c:	872a                	mv	a4,a0
      *dst++ = *src++;
    555e:	0585                	add	a1,a1,1
    5560:	0705                	add	a4,a4,1
    5562:	fff5c683          	lbu	a3,-1(a1)
    5566:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    556a:	fee79ae3          	bne	a5,a4,555e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    556e:	6422                	ld	s0,8(sp)
    5570:	0141                	add	sp,sp,16
    5572:	8082                	ret
    dst += n;
    5574:	00c50733          	add	a4,a0,a2
    src += n;
    5578:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    557a:	fec05ae3          	blez	a2,556e <memmove+0x28>
    557e:	fff6079b          	addw	a5,a2,-1 # 2fff <dirtest+0x83>
    5582:	1782                	sll	a5,a5,0x20
    5584:	9381                	srl	a5,a5,0x20
    5586:	fff7c793          	not	a5,a5
    558a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    558c:	15fd                	add	a1,a1,-1
    558e:	177d                	add	a4,a4,-1
    5590:	0005c683          	lbu	a3,0(a1)
    5594:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5598:	fee79ae3          	bne	a5,a4,558c <memmove+0x46>
    559c:	bfc9                	j	556e <memmove+0x28>

000000000000559e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    559e:	1141                	add	sp,sp,-16
    55a0:	e422                	sd	s0,8(sp)
    55a2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    55a4:	ca05                	beqz	a2,55d4 <memcmp+0x36>
    55a6:	fff6069b          	addw	a3,a2,-1
    55aa:	1682                	sll	a3,a3,0x20
    55ac:	9281                	srl	a3,a3,0x20
    55ae:	0685                	add	a3,a3,1
    55b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    55b2:	00054783          	lbu	a5,0(a0)
    55b6:	0005c703          	lbu	a4,0(a1)
    55ba:	00e79863          	bne	a5,a4,55ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    55be:	0505                	add	a0,a0,1
    p2++;
    55c0:	0585                	add	a1,a1,1
  while (n-- > 0) {
    55c2:	fed518e3          	bne	a0,a3,55b2 <memcmp+0x14>
  }
  return 0;
    55c6:	4501                	li	a0,0
    55c8:	a019                	j	55ce <memcmp+0x30>
      return *p1 - *p2;
    55ca:	40e7853b          	subw	a0,a5,a4
}
    55ce:	6422                	ld	s0,8(sp)
    55d0:	0141                	add	sp,sp,16
    55d2:	8082                	ret
  return 0;
    55d4:	4501                	li	a0,0
    55d6:	bfe5                	j	55ce <memcmp+0x30>

00000000000055d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    55d8:	1141                	add	sp,sp,-16
    55da:	e406                	sd	ra,8(sp)
    55dc:	e022                	sd	s0,0(sp)
    55de:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    55e0:	00000097          	auipc	ra,0x0
    55e4:	f66080e7          	jalr	-154(ra) # 5546 <memmove>
}
    55e8:	60a2                	ld	ra,8(sp)
    55ea:	6402                	ld	s0,0(sp)
    55ec:	0141                	add	sp,sp,16
    55ee:	8082                	ret

00000000000055f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    55f0:	4885                	li	a7,1
 ecall
    55f2:	00000073          	ecall
 ret
    55f6:	8082                	ret

00000000000055f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
    55f8:	4889                	li	a7,2
 ecall
    55fa:	00000073          	ecall
 ret
    55fe:	8082                	ret

0000000000005600 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5600:	488d                	li	a7,3
 ecall
    5602:	00000073          	ecall
 ret
    5606:	8082                	ret

0000000000005608 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5608:	4891                	li	a7,4
 ecall
    560a:	00000073          	ecall
 ret
    560e:	8082                	ret

0000000000005610 <read>:
.global read
read:
 li a7, SYS_read
    5610:	4895                	li	a7,5
 ecall
    5612:	00000073          	ecall
 ret
    5616:	8082                	ret

0000000000005618 <write>:
.global write
write:
 li a7, SYS_write
    5618:	48c1                	li	a7,16
 ecall
    561a:	00000073          	ecall
 ret
    561e:	8082                	ret

0000000000005620 <close>:
.global close
close:
 li a7, SYS_close
    5620:	48d5                	li	a7,21
 ecall
    5622:	00000073          	ecall
 ret
    5626:	8082                	ret

0000000000005628 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5628:	4899                	li	a7,6
 ecall
    562a:	00000073          	ecall
 ret
    562e:	8082                	ret

0000000000005630 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5630:	489d                	li	a7,7
 ecall
    5632:	00000073          	ecall
 ret
    5636:	8082                	ret

0000000000005638 <open>:
.global open
open:
 li a7, SYS_open
    5638:	48bd                	li	a7,15
 ecall
    563a:	00000073          	ecall
 ret
    563e:	8082                	ret

0000000000005640 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5640:	48c5                	li	a7,17
 ecall
    5642:	00000073          	ecall
 ret
    5646:	8082                	ret

0000000000005648 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5648:	48c9                	li	a7,18
 ecall
    564a:	00000073          	ecall
 ret
    564e:	8082                	ret

0000000000005650 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5650:	48a1                	li	a7,8
 ecall
    5652:	00000073          	ecall
 ret
    5656:	8082                	ret

0000000000005658 <link>:
.global link
link:
 li a7, SYS_link
    5658:	48cd                	li	a7,19
 ecall
    565a:	00000073          	ecall
 ret
    565e:	8082                	ret

0000000000005660 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5660:	48d1                	li	a7,20
 ecall
    5662:	00000073          	ecall
 ret
    5666:	8082                	ret

0000000000005668 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5668:	48a5                	li	a7,9
 ecall
    566a:	00000073          	ecall
 ret
    566e:	8082                	ret

0000000000005670 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5670:	48a9                	li	a7,10
 ecall
    5672:	00000073          	ecall
 ret
    5676:	8082                	ret

0000000000005678 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5678:	48ad                	li	a7,11
 ecall
    567a:	00000073          	ecall
 ret
    567e:	8082                	ret

0000000000005680 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5680:	48b1                	li	a7,12
 ecall
    5682:	00000073          	ecall
 ret
    5686:	8082                	ret

0000000000005688 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5688:	48b5                	li	a7,13
 ecall
    568a:	00000073          	ecall
 ret
    568e:	8082                	ret

0000000000005690 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5690:	48b9                	li	a7,14
 ecall
    5692:	00000073          	ecall
 ret
    5696:	8082                	ret

0000000000005698 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    5698:	48d9                	li	a7,22
 ecall
    569a:	00000073          	ecall
 ret
    569e:	8082                	ret

00000000000056a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    56a0:	1101                	add	sp,sp,-32
    56a2:	ec06                	sd	ra,24(sp)
    56a4:	e822                	sd	s0,16(sp)
    56a6:	1000                	add	s0,sp,32
    56a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    56ac:	4605                	li	a2,1
    56ae:	fef40593          	add	a1,s0,-17
    56b2:	00000097          	auipc	ra,0x0
    56b6:	f66080e7          	jalr	-154(ra) # 5618 <write>
}
    56ba:	60e2                	ld	ra,24(sp)
    56bc:	6442                	ld	s0,16(sp)
    56be:	6105                	add	sp,sp,32
    56c0:	8082                	ret

00000000000056c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    56c2:	7139                	add	sp,sp,-64
    56c4:	fc06                	sd	ra,56(sp)
    56c6:	f822                	sd	s0,48(sp)
    56c8:	f426                	sd	s1,40(sp)
    56ca:	f04a                	sd	s2,32(sp)
    56cc:	ec4e                	sd	s3,24(sp)
    56ce:	0080                	add	s0,sp,64
    56d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    56d2:	c299                	beqz	a3,56d8 <printint+0x16>
    56d4:	0805c963          	bltz	a1,5766 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    56d8:	2581                	sext.w	a1,a1
  neg = 0;
    56da:	4881                	li	a7,0
    56dc:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    56e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    56e2:	2601                	sext.w	a2,a2
    56e4:	00003517          	auipc	a0,0x3
    56e8:	ba450513          	add	a0,a0,-1116 # 8288 <digits>
    56ec:	883a                	mv	a6,a4
    56ee:	2705                	addw	a4,a4,1
    56f0:	02c5f7bb          	remuw	a5,a1,a2
    56f4:	1782                	sll	a5,a5,0x20
    56f6:	9381                	srl	a5,a5,0x20
    56f8:	97aa                	add	a5,a5,a0
    56fa:	0007c783          	lbu	a5,0(a5)
    56fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5702:	0005879b          	sext.w	a5,a1
    5706:	02c5d5bb          	divuw	a1,a1,a2
    570a:	0685                	add	a3,a3,1
    570c:	fec7f0e3          	bgeu	a5,a2,56ec <printint+0x2a>
  if(neg)
    5710:	00088c63          	beqz	a7,5728 <printint+0x66>
    buf[i++] = '-';
    5714:	fd070793          	add	a5,a4,-48
    5718:	00878733          	add	a4,a5,s0
    571c:	02d00793          	li	a5,45
    5720:	fef70823          	sb	a5,-16(a4)
    5724:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5728:	02e05863          	blez	a4,5758 <printint+0x96>
    572c:	fc040793          	add	a5,s0,-64
    5730:	00e78933          	add	s2,a5,a4
    5734:	fff78993          	add	s3,a5,-1
    5738:	99ba                	add	s3,s3,a4
    573a:	377d                	addw	a4,a4,-1
    573c:	1702                	sll	a4,a4,0x20
    573e:	9301                	srl	a4,a4,0x20
    5740:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5744:	fff94583          	lbu	a1,-1(s2)
    5748:	8526                	mv	a0,s1
    574a:	00000097          	auipc	ra,0x0
    574e:	f56080e7          	jalr	-170(ra) # 56a0 <putc>
  while(--i >= 0)
    5752:	197d                	add	s2,s2,-1
    5754:	ff3918e3          	bne	s2,s3,5744 <printint+0x82>
}
    5758:	70e2                	ld	ra,56(sp)
    575a:	7442                	ld	s0,48(sp)
    575c:	74a2                	ld	s1,40(sp)
    575e:	7902                	ld	s2,32(sp)
    5760:	69e2                	ld	s3,24(sp)
    5762:	6121                	add	sp,sp,64
    5764:	8082                	ret
    x = -xx;
    5766:	40b005bb          	negw	a1,a1
    neg = 1;
    576a:	4885                	li	a7,1
    x = -xx;
    576c:	bf85                	j	56dc <printint+0x1a>

000000000000576e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    576e:	715d                	add	sp,sp,-80
    5770:	e486                	sd	ra,72(sp)
    5772:	e0a2                	sd	s0,64(sp)
    5774:	fc26                	sd	s1,56(sp)
    5776:	f84a                	sd	s2,48(sp)
    5778:	f44e                	sd	s3,40(sp)
    577a:	f052                	sd	s4,32(sp)
    577c:	ec56                	sd	s5,24(sp)
    577e:	e85a                	sd	s6,16(sp)
    5780:	e45e                	sd	s7,8(sp)
    5782:	e062                	sd	s8,0(sp)
    5784:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5786:	0005c903          	lbu	s2,0(a1)
    578a:	18090c63          	beqz	s2,5922 <vprintf+0x1b4>
    578e:	8aaa                	mv	s5,a0
    5790:	8bb2                	mv	s7,a2
    5792:	00158493          	add	s1,a1,1
  state = 0;
    5796:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5798:	02500a13          	li	s4,37
    579c:	4b55                	li	s6,21
    579e:	a839                	j	57bc <vprintf+0x4e>
        putc(fd, c);
    57a0:	85ca                	mv	a1,s2
    57a2:	8556                	mv	a0,s5
    57a4:	00000097          	auipc	ra,0x0
    57a8:	efc080e7          	jalr	-260(ra) # 56a0 <putc>
    57ac:	a019                	j	57b2 <vprintf+0x44>
    } else if(state == '%'){
    57ae:	01498d63          	beq	s3,s4,57c8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    57b2:	0485                	add	s1,s1,1
    57b4:	fff4c903          	lbu	s2,-1(s1)
    57b8:	16090563          	beqz	s2,5922 <vprintf+0x1b4>
    if(state == 0){
    57bc:	fe0999e3          	bnez	s3,57ae <vprintf+0x40>
      if(c == '%'){
    57c0:	ff4910e3          	bne	s2,s4,57a0 <vprintf+0x32>
        state = '%';
    57c4:	89d2                	mv	s3,s4
    57c6:	b7f5                	j	57b2 <vprintf+0x44>
      if(c == 'd'){
    57c8:	13490263          	beq	s2,s4,58ec <vprintf+0x17e>
    57cc:	f9d9079b          	addw	a5,s2,-99
    57d0:	0ff7f793          	zext.b	a5,a5
    57d4:	12fb6563          	bltu	s6,a5,58fe <vprintf+0x190>
    57d8:	f9d9079b          	addw	a5,s2,-99
    57dc:	0ff7f713          	zext.b	a4,a5
    57e0:	10eb6f63          	bltu	s6,a4,58fe <vprintf+0x190>
    57e4:	00271793          	sll	a5,a4,0x2
    57e8:	00003717          	auipc	a4,0x3
    57ec:	a4870713          	add	a4,a4,-1464 # 8230 <malloc+0x2810>
    57f0:	97ba                	add	a5,a5,a4
    57f2:	439c                	lw	a5,0(a5)
    57f4:	97ba                	add	a5,a5,a4
    57f6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    57f8:	008b8913          	add	s2,s7,8
    57fc:	4685                	li	a3,1
    57fe:	4629                	li	a2,10
    5800:	000ba583          	lw	a1,0(s7)
    5804:	8556                	mv	a0,s5
    5806:	00000097          	auipc	ra,0x0
    580a:	ebc080e7          	jalr	-324(ra) # 56c2 <printint>
    580e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5810:	4981                	li	s3,0
    5812:	b745                	j	57b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5814:	008b8913          	add	s2,s7,8
    5818:	4681                	li	a3,0
    581a:	4629                	li	a2,10
    581c:	000ba583          	lw	a1,0(s7)
    5820:	8556                	mv	a0,s5
    5822:	00000097          	auipc	ra,0x0
    5826:	ea0080e7          	jalr	-352(ra) # 56c2 <printint>
    582a:	8bca                	mv	s7,s2
      state = 0;
    582c:	4981                	li	s3,0
    582e:	b751                	j	57b2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5830:	008b8913          	add	s2,s7,8
    5834:	4681                	li	a3,0
    5836:	4641                	li	a2,16
    5838:	000ba583          	lw	a1,0(s7)
    583c:	8556                	mv	a0,s5
    583e:	00000097          	auipc	ra,0x0
    5842:	e84080e7          	jalr	-380(ra) # 56c2 <printint>
    5846:	8bca                	mv	s7,s2
      state = 0;
    5848:	4981                	li	s3,0
    584a:	b7a5                	j	57b2 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    584c:	008b8c13          	add	s8,s7,8
    5850:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5854:	03000593          	li	a1,48
    5858:	8556                	mv	a0,s5
    585a:	00000097          	auipc	ra,0x0
    585e:	e46080e7          	jalr	-442(ra) # 56a0 <putc>
  putc(fd, 'x');
    5862:	07800593          	li	a1,120
    5866:	8556                	mv	a0,s5
    5868:	00000097          	auipc	ra,0x0
    586c:	e38080e7          	jalr	-456(ra) # 56a0 <putc>
    5870:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5872:	00003b97          	auipc	s7,0x3
    5876:	a16b8b93          	add	s7,s7,-1514 # 8288 <digits>
    587a:	03c9d793          	srl	a5,s3,0x3c
    587e:	97de                	add	a5,a5,s7
    5880:	0007c583          	lbu	a1,0(a5)
    5884:	8556                	mv	a0,s5
    5886:	00000097          	auipc	ra,0x0
    588a:	e1a080e7          	jalr	-486(ra) # 56a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    588e:	0992                	sll	s3,s3,0x4
    5890:	397d                	addw	s2,s2,-1
    5892:	fe0914e3          	bnez	s2,587a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5896:	8be2                	mv	s7,s8
      state = 0;
    5898:	4981                	li	s3,0
    589a:	bf21                	j	57b2 <vprintf+0x44>
        s = va_arg(ap, char*);
    589c:	008b8993          	add	s3,s7,8
    58a0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    58a4:	02090163          	beqz	s2,58c6 <vprintf+0x158>
        while(*s != 0){
    58a8:	00094583          	lbu	a1,0(s2)
    58ac:	c9a5                	beqz	a1,591c <vprintf+0x1ae>
          putc(fd, *s);
    58ae:	8556                	mv	a0,s5
    58b0:	00000097          	auipc	ra,0x0
    58b4:	df0080e7          	jalr	-528(ra) # 56a0 <putc>
          s++;
    58b8:	0905                	add	s2,s2,1
        while(*s != 0){
    58ba:	00094583          	lbu	a1,0(s2)
    58be:	f9e5                	bnez	a1,58ae <vprintf+0x140>
        s = va_arg(ap, char*);
    58c0:	8bce                	mv	s7,s3
      state = 0;
    58c2:	4981                	li	s3,0
    58c4:	b5fd                	j	57b2 <vprintf+0x44>
          s = "(null)";
    58c6:	00003917          	auipc	s2,0x3
    58ca:	96290913          	add	s2,s2,-1694 # 8228 <malloc+0x2808>
        while(*s != 0){
    58ce:	02800593          	li	a1,40
    58d2:	bff1                	j	58ae <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    58d4:	008b8913          	add	s2,s7,8
    58d8:	000bc583          	lbu	a1,0(s7)
    58dc:	8556                	mv	a0,s5
    58de:	00000097          	auipc	ra,0x0
    58e2:	dc2080e7          	jalr	-574(ra) # 56a0 <putc>
    58e6:	8bca                	mv	s7,s2
      state = 0;
    58e8:	4981                	li	s3,0
    58ea:	b5e1                	j	57b2 <vprintf+0x44>
        putc(fd, c);
    58ec:	02500593          	li	a1,37
    58f0:	8556                	mv	a0,s5
    58f2:	00000097          	auipc	ra,0x0
    58f6:	dae080e7          	jalr	-594(ra) # 56a0 <putc>
      state = 0;
    58fa:	4981                	li	s3,0
    58fc:	bd5d                	j	57b2 <vprintf+0x44>
        putc(fd, '%');
    58fe:	02500593          	li	a1,37
    5902:	8556                	mv	a0,s5
    5904:	00000097          	auipc	ra,0x0
    5908:	d9c080e7          	jalr	-612(ra) # 56a0 <putc>
        putc(fd, c);
    590c:	85ca                	mv	a1,s2
    590e:	8556                	mv	a0,s5
    5910:	00000097          	auipc	ra,0x0
    5914:	d90080e7          	jalr	-624(ra) # 56a0 <putc>
      state = 0;
    5918:	4981                	li	s3,0
    591a:	bd61                	j	57b2 <vprintf+0x44>
        s = va_arg(ap, char*);
    591c:	8bce                	mv	s7,s3
      state = 0;
    591e:	4981                	li	s3,0
    5920:	bd49                	j	57b2 <vprintf+0x44>
    }
  }
}
    5922:	60a6                	ld	ra,72(sp)
    5924:	6406                	ld	s0,64(sp)
    5926:	74e2                	ld	s1,56(sp)
    5928:	7942                	ld	s2,48(sp)
    592a:	79a2                	ld	s3,40(sp)
    592c:	7a02                	ld	s4,32(sp)
    592e:	6ae2                	ld	s5,24(sp)
    5930:	6b42                	ld	s6,16(sp)
    5932:	6ba2                	ld	s7,8(sp)
    5934:	6c02                	ld	s8,0(sp)
    5936:	6161                	add	sp,sp,80
    5938:	8082                	ret

000000000000593a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    593a:	715d                	add	sp,sp,-80
    593c:	ec06                	sd	ra,24(sp)
    593e:	e822                	sd	s0,16(sp)
    5940:	1000                	add	s0,sp,32
    5942:	e010                	sd	a2,0(s0)
    5944:	e414                	sd	a3,8(s0)
    5946:	e818                	sd	a4,16(s0)
    5948:	ec1c                	sd	a5,24(s0)
    594a:	03043023          	sd	a6,32(s0)
    594e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5952:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5956:	8622                	mv	a2,s0
    5958:	00000097          	auipc	ra,0x0
    595c:	e16080e7          	jalr	-490(ra) # 576e <vprintf>
}
    5960:	60e2                	ld	ra,24(sp)
    5962:	6442                	ld	s0,16(sp)
    5964:	6161                	add	sp,sp,80
    5966:	8082                	ret

0000000000005968 <printf>:

void
printf(const char *fmt, ...)
{
    5968:	711d                	add	sp,sp,-96
    596a:	ec06                	sd	ra,24(sp)
    596c:	e822                	sd	s0,16(sp)
    596e:	1000                	add	s0,sp,32
    5970:	e40c                	sd	a1,8(s0)
    5972:	e810                	sd	a2,16(s0)
    5974:	ec14                	sd	a3,24(s0)
    5976:	f018                	sd	a4,32(s0)
    5978:	f41c                	sd	a5,40(s0)
    597a:	03043823          	sd	a6,48(s0)
    597e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5982:	00840613          	add	a2,s0,8
    5986:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    598a:	85aa                	mv	a1,a0
    598c:	4505                	li	a0,1
    598e:	00000097          	auipc	ra,0x0
    5992:	de0080e7          	jalr	-544(ra) # 576e <vprintf>
}
    5996:	60e2                	ld	ra,24(sp)
    5998:	6442                	ld	s0,16(sp)
    599a:	6125                	add	sp,sp,96
    599c:	8082                	ret

000000000000599e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    599e:	1141                	add	sp,sp,-16
    59a0:	e422                	sd	s0,8(sp)
    59a2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    59a4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59a8:	00003797          	auipc	a5,0x3
    59ac:	9087b783          	ld	a5,-1784(a5) # 82b0 <freep>
    59b0:	a02d                	j	59da <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    59b2:	4618                	lw	a4,8(a2)
    59b4:	9f2d                	addw	a4,a4,a1
    59b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    59ba:	6398                	ld	a4,0(a5)
    59bc:	6310                	ld	a2,0(a4)
    59be:	a83d                	j	59fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    59c0:	ff852703          	lw	a4,-8(a0)
    59c4:	9f31                	addw	a4,a4,a2
    59c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    59c8:	ff053683          	ld	a3,-16(a0)
    59cc:	a091                	j	5a10 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59ce:	6398                	ld	a4,0(a5)
    59d0:	00e7e463          	bltu	a5,a4,59d8 <free+0x3a>
    59d4:	00e6ea63          	bltu	a3,a4,59e8 <free+0x4a>
{
    59d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59da:	fed7fae3          	bgeu	a5,a3,59ce <free+0x30>
    59de:	6398                	ld	a4,0(a5)
    59e0:	00e6e463          	bltu	a3,a4,59e8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59e4:	fee7eae3          	bltu	a5,a4,59d8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    59e8:	ff852583          	lw	a1,-8(a0)
    59ec:	6390                	ld	a2,0(a5)
    59ee:	02059813          	sll	a6,a1,0x20
    59f2:	01c85713          	srl	a4,a6,0x1c
    59f6:	9736                	add	a4,a4,a3
    59f8:	fae60de3          	beq	a2,a4,59b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    59fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5a00:	4790                	lw	a2,8(a5)
    5a02:	02061593          	sll	a1,a2,0x20
    5a06:	01c5d713          	srl	a4,a1,0x1c
    5a0a:	973e                	add	a4,a4,a5
    5a0c:	fae68ae3          	beq	a3,a4,59c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5a10:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5a12:	00003717          	auipc	a4,0x3
    5a16:	88f73f23          	sd	a5,-1890(a4) # 82b0 <freep>
}
    5a1a:	6422                	ld	s0,8(sp)
    5a1c:	0141                	add	sp,sp,16
    5a1e:	8082                	ret

0000000000005a20 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a20:	7139                	add	sp,sp,-64
    5a22:	fc06                	sd	ra,56(sp)
    5a24:	f822                	sd	s0,48(sp)
    5a26:	f426                	sd	s1,40(sp)
    5a28:	f04a                	sd	s2,32(sp)
    5a2a:	ec4e                	sd	s3,24(sp)
    5a2c:	e852                	sd	s4,16(sp)
    5a2e:	e456                	sd	s5,8(sp)
    5a30:	e05a                	sd	s6,0(sp)
    5a32:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5a34:	02051493          	sll	s1,a0,0x20
    5a38:	9081                	srl	s1,s1,0x20
    5a3a:	04bd                	add	s1,s1,15
    5a3c:	8091                	srl	s1,s1,0x4
    5a3e:	0014899b          	addw	s3,s1,1
    5a42:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    5a44:	00003517          	auipc	a0,0x3
    5a48:	86c53503          	ld	a0,-1940(a0) # 82b0 <freep>
    5a4c:	c515                	beqz	a0,5a78 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5a4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5a50:	4798                	lw	a4,8(a5)
    5a52:	02977f63          	bgeu	a4,s1,5a90 <malloc+0x70>
  if(nu < 4096)
    5a56:	8a4e                	mv	s4,s3
    5a58:	0009871b          	sext.w	a4,s3
    5a5c:	6685                	lui	a3,0x1
    5a5e:	00d77363          	bgeu	a4,a3,5a64 <malloc+0x44>
    5a62:	6a05                	lui	s4,0x1
    5a64:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5a68:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5a6c:	00003917          	auipc	s2,0x3
    5a70:	84490913          	add	s2,s2,-1980 # 82b0 <freep>
  if(p == (char*)-1)
    5a74:	5afd                	li	s5,-1
    5a76:	a895                	j	5aea <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5a78:	00009797          	auipc	a5,0x9
    5a7c:	05878793          	add	a5,a5,88 # ead0 <base>
    5a80:	00003717          	auipc	a4,0x3
    5a84:	82f73823          	sd	a5,-2000(a4) # 82b0 <freep>
    5a88:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5a8a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5a8e:	b7e1                	j	5a56 <malloc+0x36>
      if(p->s.size == nunits)
    5a90:	02e48c63          	beq	s1,a4,5ac8 <malloc+0xa8>
        p->s.size -= nunits;
    5a94:	4137073b          	subw	a4,a4,s3
    5a98:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5a9a:	02071693          	sll	a3,a4,0x20
    5a9e:	01c6d713          	srl	a4,a3,0x1c
    5aa2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5aa4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5aa8:	00003717          	auipc	a4,0x3
    5aac:	80a73423          	sd	a0,-2040(a4) # 82b0 <freep>
      return (void*)(p + 1);
    5ab0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5ab4:	70e2                	ld	ra,56(sp)
    5ab6:	7442                	ld	s0,48(sp)
    5ab8:	74a2                	ld	s1,40(sp)
    5aba:	7902                	ld	s2,32(sp)
    5abc:	69e2                	ld	s3,24(sp)
    5abe:	6a42                	ld	s4,16(sp)
    5ac0:	6aa2                	ld	s5,8(sp)
    5ac2:	6b02                	ld	s6,0(sp)
    5ac4:	6121                	add	sp,sp,64
    5ac6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5ac8:	6398                	ld	a4,0(a5)
    5aca:	e118                	sd	a4,0(a0)
    5acc:	bff1                	j	5aa8 <malloc+0x88>
  hp->s.size = nu;
    5ace:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5ad2:	0541                	add	a0,a0,16
    5ad4:	00000097          	auipc	ra,0x0
    5ad8:	eca080e7          	jalr	-310(ra) # 599e <free>
  return freep;
    5adc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5ae0:	d971                	beqz	a0,5ab4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ae2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ae4:	4798                	lw	a4,8(a5)
    5ae6:	fa9775e3          	bgeu	a4,s1,5a90 <malloc+0x70>
    if(p == freep)
    5aea:	00093703          	ld	a4,0(s2)
    5aee:	853e                	mv	a0,a5
    5af0:	fef719e3          	bne	a4,a5,5ae2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5af4:	8552                	mv	a0,s4
    5af6:	00000097          	auipc	ra,0x0
    5afa:	b8a080e7          	jalr	-1142(ra) # 5680 <sbrk>
  if(p == (char*)-1)
    5afe:	fd5518e3          	bne	a0,s5,5ace <malloc+0xae>
        return 0;
    5b02:	4501                	li	a0,0
    5b04:	bf45                	j	5ab4 <malloc+0x94>
