
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	d507a783          	lw	a5,-688(a5) # d58 <count>
  10:	2785                	addw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	d4f72323          	sw	a5,-698(a4) # d58 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	b2e50513          	add	a0,a0,-1234 # b48 <malloc+0xe6>
  22:	00001097          	auipc	ra,0x1
  26:	988080e7          	jalr	-1656(ra) # 9aa <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	6b0080e7          	jalr	1712(ra) # 6da <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	add	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	add	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	add	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	d1448493          	add	s1,s1,-748 # d58 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	d0c7a783          	lw	a5,-756(a5) # d58 <count>
  54:	2785                	addw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	af050513          	add	a0,a0,-1296 # b48 <malloc+0xe6>
  60:	00001097          	auipc	ra,0x1
  64:	94a080e7          	jalr	-1718(ra) # 9aa <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	add	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4faf>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	64e080e7          	jalr	1614(ra) # 6d2 <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	64e080e7          	jalr	1614(ra) # 6da <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	add	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	ab250513          	add	a0,a0,-1358 # b50 <malloc+0xee>
  a6:	00001097          	auipc	ra,0x1
  aa:	904080e7          	jalr	-1788(ra) # 9aa <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	582080e7          	jalr	1410(ra) # 632 <exit>

00000000000000b8 <test0>:
{
  b8:	7139                	add	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	add	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	abe50513          	add	a0,a0,-1346 # b88 <malloc+0x126>
  d2:	00001097          	auipc	ra,0x1
  d6:	8d8080e7          	jalr	-1832(ra) # 9aa <printf>
  count = 0;
  da:	00001797          	auipc	a5,0x1
  de:	c607af23          	sw	zero,-898(a5) # d58 <count>
  sigalarm(2, periodic);
  e2:	00000597          	auipc	a1,0x0
  e6:	f1e58593          	add	a1,a1,-226 # 0 <periodic>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	5e6080e7          	jalr	1510(ra) # 6d2 <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  f4:	4481                	li	s1,0
    if((i % 1000000) == 0)
  f6:	000f4937          	lui	s2,0xf4
  fa:	2409091b          	addw	s2,s2,576 # f4240 <__global_pointer$+0xf2cef>
      write(2, ".", 1);
  fe:	00001a97          	auipc	s5,0x1
 102:	a9aa8a93          	add	s5,s5,-1382 # b98 <malloc+0x136>
    if(count > 0)
 106:	00001a17          	auipc	s4,0x1
 10a:	c52a0a13          	add	s4,s4,-942 # d58 <count>
  for(i = 0; i < 1000*500000; i++){
 10e:	1dcd69b7          	lui	s3,0x1dcd6
 112:	50098993          	add	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4faf>
 116:	a809                	j	128 <test0+0x70>
    if(count > 0)
 118:	000a2783          	lw	a5,0(s4)
 11c:	2781                	sext.w	a5,a5
 11e:	02f04063          	bgtz	a5,13e <test0+0x86>
  for(i = 0; i < 1000*500000; i++){
 122:	2485                	addw	s1,s1,1
 124:	01348d63          	beq	s1,s3,13e <test0+0x86>
    if((i % 1000000) == 0)
 128:	0324e7bb          	remw	a5,s1,s2
 12c:	f7f5                	bnez	a5,118 <test0+0x60>
      write(2, ".", 1);
 12e:	4605                	li	a2,1
 130:	85d6                	mv	a1,s5
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	51e080e7          	jalr	1310(ra) # 652 <write>
 13c:	bff1                	j	118 <test0+0x60>
  sigalarm(0, 0);
 13e:	4581                	li	a1,0
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	590080e7          	jalr	1424(ra) # 6d2 <sigalarm>
  if(count > 0){
 14a:	00001797          	auipc	a5,0x1
 14e:	c0e7a783          	lw	a5,-1010(a5) # d58 <count>
 152:	02f05363          	blez	a5,178 <test0+0xc0>
    printf("test0 passed\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a4a50513          	add	a0,a0,-1462 # ba0 <malloc+0x13e>
 15e:	00001097          	auipc	ra,0x1
 162:	84c080e7          	jalr	-1972(ra) # 9aa <printf>
}
 166:	70e2                	ld	ra,56(sp)
 168:	7442                	ld	s0,48(sp)
 16a:	74a2                	ld	s1,40(sp)
 16c:	7902                	ld	s2,32(sp)
 16e:	69e2                	ld	s3,24(sp)
 170:	6a42                	ld	s4,16(sp)
 172:	6aa2                	ld	s5,8(sp)
 174:	6121                	add	sp,sp,64
 176:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 178:	00001517          	auipc	a0,0x1
 17c:	a3850513          	add	a0,a0,-1480 # bb0 <malloc+0x14e>
 180:	00001097          	auipc	ra,0x1
 184:	82a080e7          	jalr	-2006(ra) # 9aa <printf>
}
 188:	bff9                	j	166 <test0+0xae>

000000000000018a <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 18a:	1101                	add	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	1000                	add	s0,sp,32
 194:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 196:	002627b7          	lui	a5,0x262
 19a:	5a07879b          	addw	a5,a5,1440 # 2625a0 <__global_pointer$+0x26104f>
 19e:	02f5653b          	remw	a0,a0,a5
 1a2:	c909                	beqz	a0,1b4 <foo+0x2a>
  *j += 1;
 1a4:	409c                	lw	a5,0(s1)
 1a6:	2785                	addw	a5,a5,1
 1a8:	c09c                	sw	a5,0(s1)
}
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6105                	add	sp,sp,32
 1b2:	8082                	ret
    write(2, ".", 1);
 1b4:	4605                	li	a2,1
 1b6:	00001597          	auipc	a1,0x1
 1ba:	9e258593          	add	a1,a1,-1566 # b98 <malloc+0x136>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	492080e7          	jalr	1170(ra) # 652 <write>
 1c8:	bff1                	j	1a4 <foo+0x1a>

00000000000001ca <test1>:
{
 1ca:	7139                	add	sp,sp,-64
 1cc:	fc06                	sd	ra,56(sp)
 1ce:	f822                	sd	s0,48(sp)
 1d0:	f426                	sd	s1,40(sp)
 1d2:	f04a                	sd	s2,32(sp)
 1d4:	ec4e                	sd	s3,24(sp)
 1d6:	e852                	sd	s4,16(sp)
 1d8:	0080                	add	s0,sp,64
  printf("test1 start\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a1650513          	add	a0,a0,-1514 # bf0 <malloc+0x18e>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7c8080e7          	jalr	1992(ra) # 9aa <printf>
  count = 0;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	b607a723          	sw	zero,-1170(a5) # d58 <count>
  j = 0;
 1f2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1f6:	00000597          	auipc	a1,0x0
 1fa:	e0a58593          	add	a1,a1,-502 # 0 <periodic>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	4d2080e7          	jalr	1234(ra) # 6d2 <sigalarm>
  for(i = 0; i < 500000000; i++){
 208:	4481                	li	s1,0
    if(count >= 10)
 20a:	00001a17          	auipc	s4,0x1
 20e:	b4ea0a13          	add	s4,s4,-1202 # d58 <count>
 212:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 214:	1dcd6937          	lui	s2,0x1dcd6
 218:	50090913          	add	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4faf>
    if(count >= 10)
 21c:	000a2783          	lw	a5,0(s4)
 220:	2781                	sext.w	a5,a5
 222:	00f9cc63          	blt	s3,a5,23a <test1+0x70>
    foo(i, &j);
 226:	fcc40593          	add	a1,s0,-52
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	f5e080e7          	jalr	-162(ra) # 18a <foo>
  for(i = 0; i < 500000000; i++){
 234:	2485                	addw	s1,s1,1
 236:	ff2493e3          	bne	s1,s2,21c <test1+0x52>
  if(count < 10){
 23a:	00001717          	auipc	a4,0x1
 23e:	b1e72703          	lw	a4,-1250(a4) # d58 <count>
 242:	47a5                	li	a5,9
 244:	02e7d663          	bge	a5,a4,270 <test1+0xa6>
  } else if(i != j){
 248:	fcc42783          	lw	a5,-52(s0)
 24c:	02978b63          	beq	a5,s1,282 <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 250:	00001517          	auipc	a0,0x1
 254:	9e050513          	add	a0,a0,-1568 # c30 <malloc+0x1ce>
 258:	00000097          	auipc	ra,0x0
 25c:	752080e7          	jalr	1874(ra) # 9aa <printf>
}
 260:	70e2                	ld	ra,56(sp)
 262:	7442                	ld	s0,48(sp)
 264:	74a2                	ld	s1,40(sp)
 266:	7902                	ld	s2,32(sp)
 268:	69e2                	ld	s3,24(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6121                	add	sp,sp,64
 26e:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 270:	00001517          	auipc	a0,0x1
 274:	99050513          	add	a0,a0,-1648 # c00 <malloc+0x19e>
 278:	00000097          	auipc	ra,0x0
 27c:	732080e7          	jalr	1842(ra) # 9aa <printf>
 280:	b7c5                	j	260 <test1+0x96>
    printf("test1 passed\n");
 282:	00001517          	auipc	a0,0x1
 286:	9ee50513          	add	a0,a0,-1554 # c70 <malloc+0x20e>
 28a:	00000097          	auipc	ra,0x0
 28e:	720080e7          	jalr	1824(ra) # 9aa <printf>
}
 292:	b7f9                	j	260 <test1+0x96>

0000000000000294 <test2>:
{
 294:	715d                	add	sp,sp,-80
 296:	e486                	sd	ra,72(sp)
 298:	e0a2                	sd	s0,64(sp)
 29a:	fc26                	sd	s1,56(sp)
 29c:	f84a                	sd	s2,48(sp)
 29e:	f44e                	sd	s3,40(sp)
 2a0:	f052                	sd	s4,32(sp)
 2a2:	ec56                	sd	s5,24(sp)
 2a4:	0880                	add	s0,sp,80
  printf("test2 start\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	9da50513          	add	a0,a0,-1574 # c80 <malloc+0x21e>
 2ae:	00000097          	auipc	ra,0x0
 2b2:	6fc080e7          	jalr	1788(ra) # 9aa <printf>
  if ((pid = fork()) < 0) {
 2b6:	00000097          	auipc	ra,0x0
 2ba:	374080e7          	jalr	884(ra) # 62a <fork>
 2be:	04054263          	bltz	a0,302 <test2+0x6e>
 2c2:	84aa                	mv	s1,a0
  if (pid == 0) {
 2c4:	e539                	bnez	a0,312 <test2+0x7e>
    count = 0;
 2c6:	00001797          	auipc	a5,0x1
 2ca:	a807a923          	sw	zero,-1390(a5) # d58 <count>
    sigalarm(2, slow_handler);
 2ce:	00000597          	auipc	a1,0x0
 2d2:	d6c58593          	add	a1,a1,-660 # 3a <slow_handler>
 2d6:	4509                	li	a0,2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	3fa080e7          	jalr	1018(ra) # 6d2 <sigalarm>
      if((i % 1000000) == 0)
 2e0:	000f4937          	lui	s2,0xf4
 2e4:	2409091b          	addw	s2,s2,576 # f4240 <__global_pointer$+0xf2cef>
        write(2, ".", 1);
 2e8:	00001a97          	auipc	s5,0x1
 2ec:	8b0a8a93          	add	s5,s5,-1872 # b98 <malloc+0x136>
      if(count > 0)
 2f0:	00001a17          	auipc	s4,0x1
 2f4:	a68a0a13          	add	s4,s4,-1432 # d58 <count>
    for(i = 0; i < 1000*500000; i++){
 2f8:	1dcd69b7          	lui	s3,0x1dcd6
 2fc:	50098993          	add	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4faf>
 300:	a099                	j	346 <test2+0xb2>
    printf("test2: fork failed\n");
 302:	00001517          	auipc	a0,0x1
 306:	98e50513          	add	a0,a0,-1650 # c90 <malloc+0x22e>
 30a:	00000097          	auipc	ra,0x0
 30e:	6a0080e7          	jalr	1696(ra) # 9aa <printf>
  wait(&status);
 312:	fbc40513          	add	a0,s0,-68
 316:	00000097          	auipc	ra,0x0
 31a:	324080e7          	jalr	804(ra) # 63a <wait>
  if (status == 0) {
 31e:	fbc42783          	lw	a5,-68(s0)
 322:	c7a5                	beqz	a5,38a <test2+0xf6>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	74e2                	ld	s1,56(sp)
 32a:	7942                	ld	s2,48(sp)
 32c:	79a2                	ld	s3,40(sp)
 32e:	7a02                	ld	s4,32(sp)
 330:	6ae2                	ld	s5,24(sp)
 332:	6161                	add	sp,sp,80
 334:	8082                	ret
      if(count > 0)
 336:	000a2783          	lw	a5,0(s4)
 33a:	2781                	sext.w	a5,a5
 33c:	02f04063          	bgtz	a5,35c <test2+0xc8>
    for(i = 0; i < 1000*500000; i++){
 340:	2485                	addw	s1,s1,1
 342:	01348d63          	beq	s1,s3,35c <test2+0xc8>
      if((i % 1000000) == 0)
 346:	0324e7bb          	remw	a5,s1,s2
 34a:	f7f5                	bnez	a5,336 <test2+0xa2>
        write(2, ".", 1);
 34c:	4605                	li	a2,1
 34e:	85d6                	mv	a1,s5
 350:	4509                	li	a0,2
 352:	00000097          	auipc	ra,0x0
 356:	300080e7          	jalr	768(ra) # 652 <write>
 35a:	bff1                	j	336 <test2+0xa2>
    if (count == 0) {
 35c:	00001797          	auipc	a5,0x1
 360:	9fc7a783          	lw	a5,-1540(a5) # d58 <count>
 364:	ef91                	bnez	a5,380 <test2+0xec>
      printf("\ntest2 failed: alarm not called\n");
 366:	00001517          	auipc	a0,0x1
 36a:	94250513          	add	a0,a0,-1726 # ca8 <malloc+0x246>
 36e:	00000097          	auipc	ra,0x0
 372:	63c080e7          	jalr	1596(ra) # 9aa <printf>
      exit(1);
 376:	4505                	li	a0,1
 378:	00000097          	auipc	ra,0x0
 37c:	2ba080e7          	jalr	698(ra) # 632 <exit>
    exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	2b0080e7          	jalr	688(ra) # 632 <exit>
    printf("test2 passed\n");
 38a:	00001517          	auipc	a0,0x1
 38e:	94650513          	add	a0,a0,-1722 # cd0 <malloc+0x26e>
 392:	00000097          	auipc	ra,0x0
 396:	618080e7          	jalr	1560(ra) # 9aa <printf>
}
 39a:	b769                	j	324 <test2+0x90>

000000000000039c <main>:
{
 39c:	1141                	add	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	add	s0,sp,16
  test0();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	d14080e7          	jalr	-748(ra) # b8 <test0>
  test1();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	e1e080e7          	jalr	-482(ra) # 1ca <test1>
  test2();
 3b4:	00000097          	auipc	ra,0x0
 3b8:	ee0080e7          	jalr	-288(ra) # 294 <test2>
  exit(0);
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	274080e7          	jalr	628(ra) # 632 <exit>

00000000000003c6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3c6:	1141                	add	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3cc:	87aa                	mv	a5,a0
 3ce:	0585                	add	a1,a1,1
 3d0:	0785                	add	a5,a5,1
 3d2:	fff5c703          	lbu	a4,-1(a1)
 3d6:	fee78fa3          	sb	a4,-1(a5)
 3da:	fb75                	bnez	a4,3ce <strcpy+0x8>
    ;
  return os;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	add	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e2:	1141                	add	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	cb91                	beqz	a5,400 <strcmp+0x1e>
 3ee:	0005c703          	lbu	a4,0(a1)
 3f2:	00f71763          	bne	a4,a5,400 <strcmp+0x1e>
    p++, q++;
 3f6:	0505                	add	a0,a0,1
 3f8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	fbe5                	bnez	a5,3ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 400:	0005c503          	lbu	a0,0(a1)
}
 404:	40a7853b          	subw	a0,a5,a0
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	add	sp,sp,16
 40c:	8082                	ret

000000000000040e <strlen>:

uint
strlen(const char *s)
{
 40e:	1141                	add	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	cf91                	beqz	a5,434 <strlen+0x26>
 41a:	0505                	add	a0,a0,1
 41c:	87aa                	mv	a5,a0
 41e:	86be                	mv	a3,a5
 420:	0785                	add	a5,a5,1
 422:	fff7c703          	lbu	a4,-1(a5)
 426:	ff65                	bnez	a4,41e <strlen+0x10>
 428:	40a6853b          	subw	a0,a3,a0
 42c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	add	sp,sp,16
 432:	8082                	ret
  for(n = 0; s[n]; n++)
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <strlen+0x20>

0000000000000438 <memset>:

void*
memset(void *dst, int c, uint n)
{
 438:	1141                	add	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 43e:	ca19                	beqz	a2,454 <memset+0x1c>
 440:	87aa                	mv	a5,a0
 442:	1602                	sll	a2,a2,0x20
 444:	9201                	srl	a2,a2,0x20
 446:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 44a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 44e:	0785                	add	a5,a5,1
 450:	fee79de3          	bne	a5,a4,44a <memset+0x12>
  }
  return dst;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	add	sp,sp,16
 458:	8082                	ret

000000000000045a <strchr>:

char*
strchr(const char *s, char c)
{
 45a:	1141                	add	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	add	s0,sp,16
  for(; *s; s++)
 460:	00054783          	lbu	a5,0(a0)
 464:	cb99                	beqz	a5,47a <strchr+0x20>
    if(*s == c)
 466:	00f58763          	beq	a1,a5,474 <strchr+0x1a>
  for(; *s; s++)
 46a:	0505                	add	a0,a0,1
 46c:	00054783          	lbu	a5,0(a0)
 470:	fbfd                	bnez	a5,466 <strchr+0xc>
      return (char*)s;
  return 0;
 472:	4501                	li	a0,0
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	add	sp,sp,16
 478:	8082                	ret
  return 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <strchr+0x1a>

000000000000047e <gets>:

char*
gets(char *buf, int max)
{
 47e:	711d                	add	sp,sp,-96
 480:	ec86                	sd	ra,88(sp)
 482:	e8a2                	sd	s0,80(sp)
 484:	e4a6                	sd	s1,72(sp)
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	1080                	add	s0,sp,96
 494:	8baa                	mv	s7,a0
 496:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 498:	892a                	mv	s2,a0
 49a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 49c:	4aa9                	li	s5,10
 49e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a0:	89a6                	mv	s3,s1
 4a2:	2485                	addw	s1,s1,1
 4a4:	0344d863          	bge	s1,s4,4d4 <gets+0x56>
    cc = read(0, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	faf40593          	add	a1,s0,-81
 4ae:	4501                	li	a0,0
 4b0:	00000097          	auipc	ra,0x0
 4b4:	19a080e7          	jalr	410(ra) # 64a <read>
    if(cc < 1)
 4b8:	00a05e63          	blez	a0,4d4 <gets+0x56>
    buf[i++] = c;
 4bc:	faf44783          	lbu	a5,-81(s0)
 4c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c4:	01578763          	beq	a5,s5,4d2 <gets+0x54>
 4c8:	0905                	add	s2,s2,1
 4ca:	fd679be3          	bne	a5,s6,4a0 <gets+0x22>
  for(i=0; i+1 < max; ){
 4ce:	89a6                	mv	s3,s1
 4d0:	a011                	j	4d4 <gets+0x56>
 4d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d4:	99de                	add	s3,s3,s7
 4d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 4da:	855e                	mv	a0,s7
 4dc:	60e6                	ld	ra,88(sp)
 4de:	6446                	ld	s0,80(sp)
 4e0:	64a6                	ld	s1,72(sp)
 4e2:	6906                	ld	s2,64(sp)
 4e4:	79e2                	ld	s3,56(sp)
 4e6:	7a42                	ld	s4,48(sp)
 4e8:	7aa2                	ld	s5,40(sp)
 4ea:	7b02                	ld	s6,32(sp)
 4ec:	6be2                	ld	s7,24(sp)
 4ee:	6125                	add	sp,sp,96
 4f0:	8082                	ret

00000000000004f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f2:	1101                	add	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	e426                	sd	s1,8(sp)
 4fa:	e04a                	sd	s2,0(sp)
 4fc:	1000                	add	s0,sp,32
 4fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 500:	4581                	li	a1,0
 502:	00000097          	auipc	ra,0x0
 506:	170080e7          	jalr	368(ra) # 672 <open>
  if(fd < 0)
 50a:	02054563          	bltz	a0,534 <stat+0x42>
 50e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 510:	85ca                	mv	a1,s2
 512:	00000097          	auipc	ra,0x0
 516:	178080e7          	jalr	376(ra) # 68a <fstat>
 51a:	892a                	mv	s2,a0
  close(fd);
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	13c080e7          	jalr	316(ra) # 65a <close>
  return r;
}
 526:	854a                	mv	a0,s2
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	64a2                	ld	s1,8(sp)
 52e:	6902                	ld	s2,0(sp)
 530:	6105                	add	sp,sp,32
 532:	8082                	ret
    return -1;
 534:	597d                	li	s2,-1
 536:	bfc5                	j	526 <stat+0x34>

0000000000000538 <atoi>:

int
atoi(const char *s)
{
 538:	1141                	add	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53e:	00054683          	lbu	a3,0(a0)
 542:	fd06879b          	addw	a5,a3,-48
 546:	0ff7f793          	zext.b	a5,a5
 54a:	4625                	li	a2,9
 54c:	02f66863          	bltu	a2,a5,57c <atoi+0x44>
 550:	872a                	mv	a4,a0
  n = 0;
 552:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 554:	0705                	add	a4,a4,1
 556:	0025179b          	sllw	a5,a0,0x2
 55a:	9fa9                	addw	a5,a5,a0
 55c:	0017979b          	sllw	a5,a5,0x1
 560:	9fb5                	addw	a5,a5,a3
 562:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 566:	00074683          	lbu	a3,0(a4)
 56a:	fd06879b          	addw	a5,a3,-48
 56e:	0ff7f793          	zext.b	a5,a5
 572:	fef671e3          	bgeu	a2,a5,554 <atoi+0x1c>
  return n;
}
 576:	6422                	ld	s0,8(sp)
 578:	0141                	add	sp,sp,16
 57a:	8082                	ret
  n = 0;
 57c:	4501                	li	a0,0
 57e:	bfe5                	j	576 <atoi+0x3e>

0000000000000580 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 580:	1141                	add	sp,sp,-16
 582:	e422                	sd	s0,8(sp)
 584:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 586:	02b57463          	bgeu	a0,a1,5ae <memmove+0x2e>
    while(n-- > 0)
 58a:	00c05f63          	blez	a2,5a8 <memmove+0x28>
 58e:	1602                	sll	a2,a2,0x20
 590:	9201                	srl	a2,a2,0x20
 592:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 596:	872a                	mv	a4,a0
      *dst++ = *src++;
 598:	0585                	add	a1,a1,1
 59a:	0705                	add	a4,a4,1
 59c:	fff5c683          	lbu	a3,-1(a1)
 5a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a4:	fee79ae3          	bne	a5,a4,598 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	add	sp,sp,16
 5ac:	8082                	ret
    dst += n;
 5ae:	00c50733          	add	a4,a0,a2
    src += n;
 5b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b4:	fec05ae3          	blez	a2,5a8 <memmove+0x28>
 5b8:	fff6079b          	addw	a5,a2,-1
 5bc:	1782                	sll	a5,a5,0x20
 5be:	9381                	srl	a5,a5,0x20
 5c0:	fff7c793          	not	a5,a5
 5c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c6:	15fd                	add	a1,a1,-1
 5c8:	177d                	add	a4,a4,-1
 5ca:	0005c683          	lbu	a3,0(a1)
 5ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d2:	fee79ae3          	bne	a5,a4,5c6 <memmove+0x46>
 5d6:	bfc9                	j	5a8 <memmove+0x28>

00000000000005d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d8:	1141                	add	sp,sp,-16
 5da:	e422                	sd	s0,8(sp)
 5dc:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5de:	ca05                	beqz	a2,60e <memcmp+0x36>
 5e0:	fff6069b          	addw	a3,a2,-1
 5e4:	1682                	sll	a3,a3,0x20
 5e6:	9281                	srl	a3,a3,0x20
 5e8:	0685                	add	a3,a3,1
 5ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ec:	00054783          	lbu	a5,0(a0)
 5f0:	0005c703          	lbu	a4,0(a1)
 5f4:	00e79863          	bne	a5,a4,604 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f8:	0505                	add	a0,a0,1
    p2++;
 5fa:	0585                	add	a1,a1,1
  while (n-- > 0) {
 5fc:	fed518e3          	bne	a0,a3,5ec <memcmp+0x14>
  }
  return 0;
 600:	4501                	li	a0,0
 602:	a019                	j	608 <memcmp+0x30>
      return *p1 - *p2;
 604:	40e7853b          	subw	a0,a5,a4
}
 608:	6422                	ld	s0,8(sp)
 60a:	0141                	add	sp,sp,16
 60c:	8082                	ret
  return 0;
 60e:	4501                	li	a0,0
 610:	bfe5                	j	608 <memcmp+0x30>

0000000000000612 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 612:	1141                	add	sp,sp,-16
 614:	e406                	sd	ra,8(sp)
 616:	e022                	sd	s0,0(sp)
 618:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 61a:	00000097          	auipc	ra,0x0
 61e:	f66080e7          	jalr	-154(ra) # 580 <memmove>
}
 622:	60a2                	ld	ra,8(sp)
 624:	6402                	ld	s0,0(sp)
 626:	0141                	add	sp,sp,16
 628:	8082                	ret

000000000000062a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 62a:	4885                	li	a7,1
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <exit>:
.global exit
exit:
 li a7, SYS_exit
 632:	4889                	li	a7,2
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <wait>:
.global wait
wait:
 li a7, SYS_wait
 63a:	488d                	li	a7,3
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 642:	4891                	li	a7,4
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <read>:
.global read
read:
 li a7, SYS_read
 64a:	4895                	li	a7,5
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <write>:
.global write
write:
 li a7, SYS_write
 652:	48c1                	li	a7,16
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <close>:
.global close
close:
 li a7, SYS_close
 65a:	48d5                	li	a7,21
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <kill>:
.global kill
kill:
 li a7, SYS_kill
 662:	4899                	li	a7,6
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <exec>:
.global exec
exec:
 li a7, SYS_exec
 66a:	489d                	li	a7,7
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <open>:
.global open
open:
 li a7, SYS_open
 672:	48bd                	li	a7,15
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 67a:	48c5                	li	a7,17
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 682:	48c9                	li	a7,18
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68a:	48a1                	li	a7,8
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <link>:
.global link
link:
 li a7, SYS_link
 692:	48cd                	li	a7,19
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 69a:	48d1                	li	a7,20
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a2:	48a5                	li	a7,9
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 6aa:	48a9                	li	a7,10
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b2:	48ad                	li	a7,11
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6ba:	48b1                	li	a7,12
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c2:	48b5                	li	a7,13
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ca:	48b9                	li	a7,14
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6d2:	48d9                	li	a7,22
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6da:	48dd                	li	a7,23
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e2:	1101                	add	sp,sp,-32
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	add	s0,sp,32
 6ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6ee:	4605                	li	a2,1
 6f0:	fef40593          	add	a1,s0,-17
 6f4:	00000097          	auipc	ra,0x0
 6f8:	f5e080e7          	jalr	-162(ra) # 652 <write>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6105                	add	sp,sp,32
 702:	8082                	ret

0000000000000704 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 704:	7139                	add	sp,sp,-64
 706:	fc06                	sd	ra,56(sp)
 708:	f822                	sd	s0,48(sp)
 70a:	f426                	sd	s1,40(sp)
 70c:	f04a                	sd	s2,32(sp)
 70e:	ec4e                	sd	s3,24(sp)
 710:	0080                	add	s0,sp,64
 712:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 714:	c299                	beqz	a3,71a <printint+0x16>
 716:	0805c963          	bltz	a1,7a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71a:	2581                	sext.w	a1,a1
  neg = 0;
 71c:	4881                	li	a7,0
 71e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 722:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 724:	2601                	sext.w	a2,a2
 726:	00000517          	auipc	a0,0x0
 72a:	61a50513          	add	a0,a0,1562 # d40 <digits>
 72e:	883a                	mv	a6,a4
 730:	2705                	addw	a4,a4,1
 732:	02c5f7bb          	remuw	a5,a1,a2
 736:	1782                	sll	a5,a5,0x20
 738:	9381                	srl	a5,a5,0x20
 73a:	97aa                	add	a5,a5,a0
 73c:	0007c783          	lbu	a5,0(a5)
 740:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 744:	0005879b          	sext.w	a5,a1
 748:	02c5d5bb          	divuw	a1,a1,a2
 74c:	0685                	add	a3,a3,1
 74e:	fec7f0e3          	bgeu	a5,a2,72e <printint+0x2a>
  if(neg)
 752:	00088c63          	beqz	a7,76a <printint+0x66>
    buf[i++] = '-';
 756:	fd070793          	add	a5,a4,-48
 75a:	00878733          	add	a4,a5,s0
 75e:	02d00793          	li	a5,45
 762:	fef70823          	sb	a5,-16(a4)
 766:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 76a:	02e05863          	blez	a4,79a <printint+0x96>
 76e:	fc040793          	add	a5,s0,-64
 772:	00e78933          	add	s2,a5,a4
 776:	fff78993          	add	s3,a5,-1
 77a:	99ba                	add	s3,s3,a4
 77c:	377d                	addw	a4,a4,-1
 77e:	1702                	sll	a4,a4,0x20
 780:	9301                	srl	a4,a4,0x20
 782:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 786:	fff94583          	lbu	a1,-1(s2)
 78a:	8526                	mv	a0,s1
 78c:	00000097          	auipc	ra,0x0
 790:	f56080e7          	jalr	-170(ra) # 6e2 <putc>
  while(--i >= 0)
 794:	197d                	add	s2,s2,-1
 796:	ff3918e3          	bne	s2,s3,786 <printint+0x82>
}
 79a:	70e2                	ld	ra,56(sp)
 79c:	7442                	ld	s0,48(sp)
 79e:	74a2                	ld	s1,40(sp)
 7a0:	7902                	ld	s2,32(sp)
 7a2:	69e2                	ld	s3,24(sp)
 7a4:	6121                	add	sp,sp,64
 7a6:	8082                	ret
    x = -xx;
 7a8:	40b005bb          	negw	a1,a1
    neg = 1;
 7ac:	4885                	li	a7,1
    x = -xx;
 7ae:	bf85                	j	71e <printint+0x1a>

00000000000007b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b0:	715d                	add	sp,sp,-80
 7b2:	e486                	sd	ra,72(sp)
 7b4:	e0a2                	sd	s0,64(sp)
 7b6:	fc26                	sd	s1,56(sp)
 7b8:	f84a                	sd	s2,48(sp)
 7ba:	f44e                	sd	s3,40(sp)
 7bc:	f052                	sd	s4,32(sp)
 7be:	ec56                	sd	s5,24(sp)
 7c0:	e85a                	sd	s6,16(sp)
 7c2:	e45e                	sd	s7,8(sp)
 7c4:	e062                	sd	s8,0(sp)
 7c6:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7c8:	0005c903          	lbu	s2,0(a1)
 7cc:	18090c63          	beqz	s2,964 <vprintf+0x1b4>
 7d0:	8aaa                	mv	s5,a0
 7d2:	8bb2                	mv	s7,a2
 7d4:	00158493          	add	s1,a1,1
  state = 0;
 7d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7da:	02500a13          	li	s4,37
 7de:	4b55                	li	s6,21
 7e0:	a839                	j	7fe <vprintf+0x4e>
        putc(fd, c);
 7e2:	85ca                	mv	a1,s2
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	efc080e7          	jalr	-260(ra) # 6e2 <putc>
 7ee:	a019                	j	7f4 <vprintf+0x44>
    } else if(state == '%'){
 7f0:	01498d63          	beq	s3,s4,80a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 7f4:	0485                	add	s1,s1,1
 7f6:	fff4c903          	lbu	s2,-1(s1)
 7fa:	16090563          	beqz	s2,964 <vprintf+0x1b4>
    if(state == 0){
 7fe:	fe0999e3          	bnez	s3,7f0 <vprintf+0x40>
      if(c == '%'){
 802:	ff4910e3          	bne	s2,s4,7e2 <vprintf+0x32>
        state = '%';
 806:	89d2                	mv	s3,s4
 808:	b7f5                	j	7f4 <vprintf+0x44>
      if(c == 'd'){
 80a:	13490263          	beq	s2,s4,92e <vprintf+0x17e>
 80e:	f9d9079b          	addw	a5,s2,-99
 812:	0ff7f793          	zext.b	a5,a5
 816:	12fb6563          	bltu	s6,a5,940 <vprintf+0x190>
 81a:	f9d9079b          	addw	a5,s2,-99
 81e:	0ff7f713          	zext.b	a4,a5
 822:	10eb6f63          	bltu	s6,a4,940 <vprintf+0x190>
 826:	00271793          	sll	a5,a4,0x2
 82a:	00000717          	auipc	a4,0x0
 82e:	4be70713          	add	a4,a4,1214 # ce8 <malloc+0x286>
 832:	97ba                	add	a5,a5,a4
 834:	439c                	lw	a5,0(a5)
 836:	97ba                	add	a5,a5,a4
 838:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 83a:	008b8913          	add	s2,s7,8
 83e:	4685                	li	a3,1
 840:	4629                	li	a2,10
 842:	000ba583          	lw	a1,0(s7)
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	ebc080e7          	jalr	-324(ra) # 704 <printint>
 850:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 852:	4981                	li	s3,0
 854:	b745                	j	7f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 856:	008b8913          	add	s2,s7,8
 85a:	4681                	li	a3,0
 85c:	4629                	li	a2,10
 85e:	000ba583          	lw	a1,0(s7)
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	ea0080e7          	jalr	-352(ra) # 704 <printint>
 86c:	8bca                	mv	s7,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	b751                	j	7f4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 872:	008b8913          	add	s2,s7,8
 876:	4681                	li	a3,0
 878:	4641                	li	a2,16
 87a:	000ba583          	lw	a1,0(s7)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e84080e7          	jalr	-380(ra) # 704 <printint>
 888:	8bca                	mv	s7,s2
      state = 0;
 88a:	4981                	li	s3,0
 88c:	b7a5                	j	7f4 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 88e:	008b8c13          	add	s8,s7,8
 892:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 896:	03000593          	li	a1,48
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e46080e7          	jalr	-442(ra) # 6e2 <putc>
  putc(fd, 'x');
 8a4:	07800593          	li	a1,120
 8a8:	8556                	mv	a0,s5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	e38080e7          	jalr	-456(ra) # 6e2 <putc>
 8b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b4:	00000b97          	auipc	s7,0x0
 8b8:	48cb8b93          	add	s7,s7,1164 # d40 <digits>
 8bc:	03c9d793          	srl	a5,s3,0x3c
 8c0:	97de                	add	a5,a5,s7
 8c2:	0007c583          	lbu	a1,0(a5)
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e1a080e7          	jalr	-486(ra) # 6e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d0:	0992                	sll	s3,s3,0x4
 8d2:	397d                	addw	s2,s2,-1
 8d4:	fe0914e3          	bnez	s2,8bc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8d8:	8be2                	mv	s7,s8
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bf21                	j	7f4 <vprintf+0x44>
        s = va_arg(ap, char*);
 8de:	008b8993          	add	s3,s7,8
 8e2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8e6:	02090163          	beqz	s2,908 <vprintf+0x158>
        while(*s != 0){
 8ea:	00094583          	lbu	a1,0(s2)
 8ee:	c9a5                	beqz	a1,95e <vprintf+0x1ae>
          putc(fd, *s);
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	df0080e7          	jalr	-528(ra) # 6e2 <putc>
          s++;
 8fa:	0905                	add	s2,s2,1
        while(*s != 0){
 8fc:	00094583          	lbu	a1,0(s2)
 900:	f9e5                	bnez	a1,8f0 <vprintf+0x140>
        s = va_arg(ap, char*);
 902:	8bce                	mv	s7,s3
      state = 0;
 904:	4981                	li	s3,0
 906:	b5fd                	j	7f4 <vprintf+0x44>
          s = "(null)";
 908:	00000917          	auipc	s2,0x0
 90c:	3d890913          	add	s2,s2,984 # ce0 <malloc+0x27e>
        while(*s != 0){
 910:	02800593          	li	a1,40
 914:	bff1                	j	8f0 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 916:	008b8913          	add	s2,s7,8
 91a:	000bc583          	lbu	a1,0(s7)
 91e:	8556                	mv	a0,s5
 920:	00000097          	auipc	ra,0x0
 924:	dc2080e7          	jalr	-574(ra) # 6e2 <putc>
 928:	8bca                	mv	s7,s2
      state = 0;
 92a:	4981                	li	s3,0
 92c:	b5e1                	j	7f4 <vprintf+0x44>
        putc(fd, c);
 92e:	02500593          	li	a1,37
 932:	8556                	mv	a0,s5
 934:	00000097          	auipc	ra,0x0
 938:	dae080e7          	jalr	-594(ra) # 6e2 <putc>
      state = 0;
 93c:	4981                	li	s3,0
 93e:	bd5d                	j	7f4 <vprintf+0x44>
        putc(fd, '%');
 940:	02500593          	li	a1,37
 944:	8556                	mv	a0,s5
 946:	00000097          	auipc	ra,0x0
 94a:	d9c080e7          	jalr	-612(ra) # 6e2 <putc>
        putc(fd, c);
 94e:	85ca                	mv	a1,s2
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	d90080e7          	jalr	-624(ra) # 6e2 <putc>
      state = 0;
 95a:	4981                	li	s3,0
 95c:	bd61                	j	7f4 <vprintf+0x44>
        s = va_arg(ap, char*);
 95e:	8bce                	mv	s7,s3
      state = 0;
 960:	4981                	li	s3,0
 962:	bd49                	j	7f4 <vprintf+0x44>
    }
  }
}
 964:	60a6                	ld	ra,72(sp)
 966:	6406                	ld	s0,64(sp)
 968:	74e2                	ld	s1,56(sp)
 96a:	7942                	ld	s2,48(sp)
 96c:	79a2                	ld	s3,40(sp)
 96e:	7a02                	ld	s4,32(sp)
 970:	6ae2                	ld	s5,24(sp)
 972:	6b42                	ld	s6,16(sp)
 974:	6ba2                	ld	s7,8(sp)
 976:	6c02                	ld	s8,0(sp)
 978:	6161                	add	sp,sp,80
 97a:	8082                	ret

000000000000097c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 97c:	715d                	add	sp,sp,-80
 97e:	ec06                	sd	ra,24(sp)
 980:	e822                	sd	s0,16(sp)
 982:	1000                	add	s0,sp,32
 984:	e010                	sd	a2,0(s0)
 986:	e414                	sd	a3,8(s0)
 988:	e818                	sd	a4,16(s0)
 98a:	ec1c                	sd	a5,24(s0)
 98c:	03043023          	sd	a6,32(s0)
 990:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 994:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 998:	8622                	mv	a2,s0
 99a:	00000097          	auipc	ra,0x0
 99e:	e16080e7          	jalr	-490(ra) # 7b0 <vprintf>
}
 9a2:	60e2                	ld	ra,24(sp)
 9a4:	6442                	ld	s0,16(sp)
 9a6:	6161                	add	sp,sp,80
 9a8:	8082                	ret

00000000000009aa <printf>:

void
printf(const char *fmt, ...)
{
 9aa:	711d                	add	sp,sp,-96
 9ac:	ec06                	sd	ra,24(sp)
 9ae:	e822                	sd	s0,16(sp)
 9b0:	1000                	add	s0,sp,32
 9b2:	e40c                	sd	a1,8(s0)
 9b4:	e810                	sd	a2,16(s0)
 9b6:	ec14                	sd	a3,24(s0)
 9b8:	f018                	sd	a4,32(s0)
 9ba:	f41c                	sd	a5,40(s0)
 9bc:	03043823          	sd	a6,48(s0)
 9c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9c4:	00840613          	add	a2,s0,8
 9c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9cc:	85aa                	mv	a1,a0
 9ce:	4505                	li	a0,1
 9d0:	00000097          	auipc	ra,0x0
 9d4:	de0080e7          	jalr	-544(ra) # 7b0 <vprintf>
}
 9d8:	60e2                	ld	ra,24(sp)
 9da:	6442                	ld	s0,16(sp)
 9dc:	6125                	add	sp,sp,96
 9de:	8082                	ret

00000000000009e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e0:	1141                	add	sp,sp,-16
 9e2:	e422                	sd	s0,8(sp)
 9e4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ea:	00000797          	auipc	a5,0x0
 9ee:	3767b783          	ld	a5,886(a5) # d60 <freep>
 9f2:	a02d                	j	a1c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f4:	4618                	lw	a4,8(a2)
 9f6:	9f2d                	addw	a4,a4,a1
 9f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	6310                	ld	a2,0(a4)
 a00:	a83d                	j	a3e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a02:	ff852703          	lw	a4,-8(a0)
 a06:	9f31                	addw	a4,a4,a2
 a08:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a0a:	ff053683          	ld	a3,-16(a0)
 a0e:	a091                	j	a52 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a10:	6398                	ld	a4,0(a5)
 a12:	00e7e463          	bltu	a5,a4,a1a <free+0x3a>
 a16:	00e6ea63          	bltu	a3,a4,a2a <free+0x4a>
{
 a1a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a1c:	fed7fae3          	bgeu	a5,a3,a10 <free+0x30>
 a20:	6398                	ld	a4,0(a5)
 a22:	00e6e463          	bltu	a3,a4,a2a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a26:	fee7eae3          	bltu	a5,a4,a1a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a2a:	ff852583          	lw	a1,-8(a0)
 a2e:	6390                	ld	a2,0(a5)
 a30:	02059813          	sll	a6,a1,0x20
 a34:	01c85713          	srl	a4,a6,0x1c
 a38:	9736                	add	a4,a4,a3
 a3a:	fae60de3          	beq	a2,a4,9f4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a3e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a42:	4790                	lw	a2,8(a5)
 a44:	02061593          	sll	a1,a2,0x20
 a48:	01c5d713          	srl	a4,a1,0x1c
 a4c:	973e                	add	a4,a4,a5
 a4e:	fae68ae3          	beq	a3,a4,a02 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a52:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a54:	00000717          	auipc	a4,0x0
 a58:	30f73623          	sd	a5,780(a4) # d60 <freep>
}
 a5c:	6422                	ld	s0,8(sp)
 a5e:	0141                	add	sp,sp,16
 a60:	8082                	ret

0000000000000a62 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a62:	7139                	add	sp,sp,-64
 a64:	fc06                	sd	ra,56(sp)
 a66:	f822                	sd	s0,48(sp)
 a68:	f426                	sd	s1,40(sp)
 a6a:	f04a                	sd	s2,32(sp)
 a6c:	ec4e                	sd	s3,24(sp)
 a6e:	e852                	sd	s4,16(sp)
 a70:	e456                	sd	s5,8(sp)
 a72:	e05a                	sd	s6,0(sp)
 a74:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a76:	02051493          	sll	s1,a0,0x20
 a7a:	9081                	srl	s1,s1,0x20
 a7c:	04bd                	add	s1,s1,15
 a7e:	8091                	srl	s1,s1,0x4
 a80:	0014899b          	addw	s3,s1,1
 a84:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a86:	00000517          	auipc	a0,0x0
 a8a:	2da53503          	ld	a0,730(a0) # d60 <freep>
 a8e:	c515                	beqz	a0,aba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a92:	4798                	lw	a4,8(a5)
 a94:	02977f63          	bgeu	a4,s1,ad2 <malloc+0x70>
  if(nu < 4096)
 a98:	8a4e                	mv	s4,s3
 a9a:	0009871b          	sext.w	a4,s3
 a9e:	6685                	lui	a3,0x1
 aa0:	00d77363          	bgeu	a4,a3,aa6 <malloc+0x44>
 aa4:	6a05                	lui	s4,0x1
 aa6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aaa:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aae:	00000917          	auipc	s2,0x0
 ab2:	2b290913          	add	s2,s2,690 # d60 <freep>
  if(p == (char*)-1)
 ab6:	5afd                	li	s5,-1
 ab8:	a895                	j	b2c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 aba:	00000797          	auipc	a5,0x0
 abe:	2ae78793          	add	a5,a5,686 # d68 <base>
 ac2:	00000717          	auipc	a4,0x0
 ac6:	28f73f23          	sd	a5,670(a4) # d60 <freep>
 aca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 acc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ad0:	b7e1                	j	a98 <malloc+0x36>
      if(p->s.size == nunits)
 ad2:	02e48c63          	beq	s1,a4,b0a <malloc+0xa8>
        p->s.size -= nunits;
 ad6:	4137073b          	subw	a4,a4,s3
 ada:	c798                	sw	a4,8(a5)
        p += p->s.size;
 adc:	02071693          	sll	a3,a4,0x20
 ae0:	01c6d713          	srl	a4,a3,0x1c
 ae4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aea:	00000717          	auipc	a4,0x0
 aee:	26a73b23          	sd	a0,630(a4) # d60 <freep>
      return (void*)(p + 1);
 af2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 af6:	70e2                	ld	ra,56(sp)
 af8:	7442                	ld	s0,48(sp)
 afa:	74a2                	ld	s1,40(sp)
 afc:	7902                	ld	s2,32(sp)
 afe:	69e2                	ld	s3,24(sp)
 b00:	6a42                	ld	s4,16(sp)
 b02:	6aa2                	ld	s5,8(sp)
 b04:	6b02                	ld	s6,0(sp)
 b06:	6121                	add	sp,sp,64
 b08:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b0a:	6398                	ld	a4,0(a5)
 b0c:	e118                	sd	a4,0(a0)
 b0e:	bff1                	j	aea <malloc+0x88>
  hp->s.size = nu;
 b10:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b14:	0541                	add	a0,a0,16
 b16:	00000097          	auipc	ra,0x0
 b1a:	eca080e7          	jalr	-310(ra) # 9e0 <free>
  return freep;
 b1e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b22:	d971                	beqz	a0,af6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b26:	4798                	lw	a4,8(a5)
 b28:	fa9775e3          	bgeu	a4,s1,ad2 <malloc+0x70>
    if(p == freep)
 b2c:	00093703          	ld	a4,0(s2)
 b30:	853e                	mv	a0,a5
 b32:	fef719e3          	bne	a4,a5,b24 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b36:	8552                	mv	a0,s4
 b38:	00000097          	auipc	ra,0x0
 b3c:	b82080e7          	jalr	-1150(ra) # 6ba <sbrk>
  if(p == (char*)-1)
 b40:	fd5518e3          	bne	a0,s5,b10 <malloc+0xae>
        return 0;
 b44:	4501                	li	a0,0
 b46:	bf45                	j	af6 <malloc+0x94>
