
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bd010113          	add	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	add	s0,sp,1072
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  20:	20100593          	li	a1,513
  24:	00001517          	auipc	a0,0x1
  28:	8dc50513          	add	a0,a0,-1828 # 900 <malloc+0xe6>
  2c:	00000097          	auipc	ra,0x0
  30:	406080e7          	jalr	1030(ra) # 432 <open>
  if(fd < 0){
  34:	04054463          	bltz	a0,7c <main+0x7c>
  38:	892a                	mv	s2,a0
  3a:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  3c:	06400993          	li	s3,100
      printf(".");
  40:	00001a17          	auipc	s4,0x1
  44:	900a0a13          	add	s4,s4,-1792 # 940 <malloc+0x126>
    *(int*)buf = blocks;
  48:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  4c:	40000613          	li	a2,1024
  50:	bd040593          	add	a1,s0,-1072
  54:	854a                	mv	a0,s2
  56:	00000097          	auipc	ra,0x0
  5a:	3bc080e7          	jalr	956(ra) # 412 <write>
    if(cc <= 0)
  5e:	02a05c63          	blez	a0,96 <main+0x96>
    blocks++;
  62:	0014879b          	addw	a5,s1,1
  66:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  6a:	0337e7bb          	remw	a5,a5,s3
  6e:	ffe9                	bnez	a5,48 <main+0x48>
      printf(".");
  70:	8552                	mv	a0,s4
  72:	00000097          	auipc	ra,0x0
  76:	6f0080e7          	jalr	1776(ra) # 762 <printf>
  7a:	b7f9                	j	48 <main+0x48>
    printf("bigfile: cannot open big.file for writing\n");
  7c:	00001517          	auipc	a0,0x1
  80:	89450513          	add	a0,a0,-1900 # 910 <malloc+0xf6>
  84:	00000097          	auipc	ra,0x0
  88:	6de080e7          	jalr	1758(ra) # 762 <printf>
    exit(-1);
  8c:	557d                	li	a0,-1
  8e:	00000097          	auipc	ra,0x0
  92:	364080e7          	jalr	868(ra) # 3f2 <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8b050513          	add	a0,a0,-1872 # 948 <malloc+0x12e>
  a0:	00000097          	auipc	ra,0x0
  a4:	6c2080e7          	jalr	1730(ra) # 762 <printf>
  if(blocks != 65803) {
  a8:	67c1                	lui	a5,0x10
  aa:	10b78793          	add	a5,a5,267 # 1010b <__global_pointer$+0xee7a>
  ae:	00f48f63          	beq	s1,a5,cc <main+0xcc>
    printf("bigfile: file is too small\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	8ae50513          	add	a0,a0,-1874 # 960 <malloc+0x146>
  ba:	00000097          	auipc	ra,0x0
  be:	6a8080e7          	jalr	1704(ra) # 762 <printf>
    exit(-1);
  c2:	557d                	li	a0,-1
  c4:	00000097          	auipc	ra,0x0
  c8:	32e080e7          	jalr	814(ra) # 3f2 <exit>
  }
  
  close(fd);
  cc:	854a                	mv	a0,s2
  ce:	00000097          	auipc	ra,0x0
  d2:	34c080e7          	jalr	844(ra) # 41a <close>
  fd = open("big.file", O_RDONLY);
  d6:	4581                	li	a1,0
  d8:	00001517          	auipc	a0,0x1
  dc:	82850513          	add	a0,a0,-2008 # 900 <malloc+0xe6>
  e0:	00000097          	auipc	ra,0x0
  e4:	352080e7          	jalr	850(ra) # 432 <open>
  e8:	892a                	mv	s2,a0
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < blocks; i++){
  ea:	4481                	li	s1,0
  if(fd < 0){
  ec:	04054463          	bltz	a0,134 <main+0x134>
  for(i = 0; i < blocks; i++){
  f0:	69c1                	lui	s3,0x10
  f2:	10b98993          	add	s3,s3,267 # 1010b <__global_pointer$+0xee7a>
    int cc = read(fd, buf, sizeof(buf));
  f6:	40000613          	li	a2,1024
  fa:	bd040593          	add	a1,s0,-1072
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	30a080e7          	jalr	778(ra) # 40a <read>
    if(cc <= 0){
 108:	04a05363          	blez	a0,14e <main+0x14e>
      printf("bigfile: read error at block %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
 10c:	bd042583          	lw	a1,-1072(s0)
 110:	04959d63          	bne	a1,s1,16a <main+0x16a>
  for(i = 0; i < blocks; i++){
 114:	2485                	addw	s1,s1,1
 116:	ff3490e3          	bne	s1,s3,f6 <main+0xf6>
             *(int*)buf, i);
      exit(-1);
    }
  }

  printf("bigfile done; ok\n"); 
 11a:	00001517          	auipc	a0,0x1
 11e:	8ee50513          	add	a0,a0,-1810 # a08 <malloc+0x1ee>
 122:	00000097          	auipc	ra,0x0
 126:	640080e7          	jalr	1600(ra) # 762 <printf>

  exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	2c6080e7          	jalr	710(ra) # 3f2 <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 134:	00001517          	auipc	a0,0x1
 138:	84c50513          	add	a0,a0,-1972 # 980 <malloc+0x166>
 13c:	00000097          	auipc	ra,0x0
 140:	626080e7          	jalr	1574(ra) # 762 <printf>
    exit(-1);
 144:	557d                	li	a0,-1
 146:	00000097          	auipc	ra,0x0
 14a:	2ac080e7          	jalr	684(ra) # 3f2 <exit>
      printf("bigfile: read error at block %d\n", i);
 14e:	85a6                	mv	a1,s1
 150:	00001517          	auipc	a0,0x1
 154:	86050513          	add	a0,a0,-1952 # 9b0 <malloc+0x196>
 158:	00000097          	auipc	ra,0x0
 15c:	60a080e7          	jalr	1546(ra) # 762 <printf>
      exit(-1);
 160:	557d                	li	a0,-1
 162:	00000097          	auipc	ra,0x0
 166:	290080e7          	jalr	656(ra) # 3f2 <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 16a:	8626                	mv	a2,s1
 16c:	00001517          	auipc	a0,0x1
 170:	86c50513          	add	a0,a0,-1940 # 9d8 <malloc+0x1be>
 174:	00000097          	auipc	ra,0x0
 178:	5ee080e7          	jalr	1518(ra) # 762 <printf>
      exit(-1);
 17c:	557d                	li	a0,-1
 17e:	00000097          	auipc	ra,0x0
 182:	274080e7          	jalr	628(ra) # 3f2 <exit>

0000000000000186 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 186:	1141                	add	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18c:	87aa                	mv	a5,a0
 18e:	0585                	add	a1,a1,1
 190:	0785                	add	a5,a5,1
 192:	fff5c703          	lbu	a4,-1(a1)
 196:	fee78fa3          	sb	a4,-1(a5)
 19a:	fb75                	bnez	a4,18e <strcpy+0x8>
    ;
  return os;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	add	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a2:	1141                	add	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	cb91                	beqz	a5,1c0 <strcmp+0x1e>
 1ae:	0005c703          	lbu	a4,0(a1)
 1b2:	00f71763          	bne	a4,a5,1c0 <strcmp+0x1e>
    p++, q++;
 1b6:	0505                	add	a0,a0,1
 1b8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbe5                	bnez	a5,1ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c0:	0005c503          	lbu	a0,0(a1)
}
 1c4:	40a7853b          	subw	a0,a5,a0
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	add	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strlen>:

uint
strlen(const char *s)
{
 1ce:	1141                	add	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cf91                	beqz	a5,1f4 <strlen+0x26>
 1da:	0505                	add	a0,a0,1
 1dc:	87aa                	mv	a5,a0
 1de:	86be                	mv	a3,a5
 1e0:	0785                	add	a5,a5,1
 1e2:	fff7c703          	lbu	a4,-1(a5)
 1e6:	ff65                	bnez	a4,1de <strlen+0x10>
 1e8:	40a6853b          	subw	a0,a3,a0
 1ec:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	add	sp,sp,16
 1f2:	8082                	ret
  for(n = 0; s[n]; n++)
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <strlen+0x20>

00000000000001f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f8:	1141                	add	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1fe:	ca19                	beqz	a2,214 <memset+0x1c>
 200:	87aa                	mv	a5,a0
 202:	1602                	sll	a2,a2,0x20
 204:	9201                	srl	a2,a2,0x20
 206:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 20a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20e:	0785                	add	a5,a5,1
 210:	fee79de3          	bne	a5,a4,20a <memset+0x12>
  }
  return dst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	add	sp,sp,16
 218:	8082                	ret

000000000000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	1141                	add	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	add	s0,sp,16
  for(; *s; s++)
 220:	00054783          	lbu	a5,0(a0)
 224:	cb99                	beqz	a5,23a <strchr+0x20>
    if(*s == c)
 226:	00f58763          	beq	a1,a5,234 <strchr+0x1a>
  for(; *s; s++)
 22a:	0505                	add	a0,a0,1
 22c:	00054783          	lbu	a5,0(a0)
 230:	fbfd                	bnez	a5,226 <strchr+0xc>
      return (char*)s;
  return 0;
 232:	4501                	li	a0,0
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	add	sp,sp,16
 238:	8082                	ret
  return 0;
 23a:	4501                	li	a0,0
 23c:	bfe5                	j	234 <strchr+0x1a>

000000000000023e <gets>:

char*
gets(char *buf, int max)
{
 23e:	711d                	add	sp,sp,-96
 240:	ec86                	sd	ra,88(sp)
 242:	e8a2                	sd	s0,80(sp)
 244:	e4a6                	sd	s1,72(sp)
 246:	e0ca                	sd	s2,64(sp)
 248:	fc4e                	sd	s3,56(sp)
 24a:	f852                	sd	s4,48(sp)
 24c:	f456                	sd	s5,40(sp)
 24e:	f05a                	sd	s6,32(sp)
 250:	ec5e                	sd	s7,24(sp)
 252:	1080                	add	s0,sp,96
 254:	8baa                	mv	s7,a0
 256:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	892a                	mv	s2,a0
 25a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25c:	4aa9                	li	s5,10
 25e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 260:	89a6                	mv	s3,s1
 262:	2485                	addw	s1,s1,1
 264:	0344d863          	bge	s1,s4,294 <gets+0x56>
    cc = read(0, &c, 1);
 268:	4605                	li	a2,1
 26a:	faf40593          	add	a1,s0,-81
 26e:	4501                	li	a0,0
 270:	00000097          	auipc	ra,0x0
 274:	19a080e7          	jalr	410(ra) # 40a <read>
    if(cc < 1)
 278:	00a05e63          	blez	a0,294 <gets+0x56>
    buf[i++] = c;
 27c:	faf44783          	lbu	a5,-81(s0)
 280:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 284:	01578763          	beq	a5,s5,292 <gets+0x54>
 288:	0905                	add	s2,s2,1
 28a:	fd679be3          	bne	a5,s6,260 <gets+0x22>
  for(i=0; i+1 < max; ){
 28e:	89a6                	mv	s3,s1
 290:	a011                	j	294 <gets+0x56>
 292:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 294:	99de                	add	s3,s3,s7
 296:	00098023          	sb	zero,0(s3)
  return buf;
}
 29a:	855e                	mv	a0,s7
 29c:	60e6                	ld	ra,88(sp)
 29e:	6446                	ld	s0,80(sp)
 2a0:	64a6                	ld	s1,72(sp)
 2a2:	6906                	ld	s2,64(sp)
 2a4:	79e2                	ld	s3,56(sp)
 2a6:	7a42                	ld	s4,48(sp)
 2a8:	7aa2                	ld	s5,40(sp)
 2aa:	7b02                	ld	s6,32(sp)
 2ac:	6be2                	ld	s7,24(sp)
 2ae:	6125                	add	sp,sp,96
 2b0:	8082                	ret

00000000000002b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b2:	1101                	add	sp,sp,-32
 2b4:	ec06                	sd	ra,24(sp)
 2b6:	e822                	sd	s0,16(sp)
 2b8:	e426                	sd	s1,8(sp)
 2ba:	e04a                	sd	s2,0(sp)
 2bc:	1000                	add	s0,sp,32
 2be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c0:	4581                	li	a1,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	170080e7          	jalr	368(ra) # 432 <open>
  if(fd < 0)
 2ca:	02054563          	bltz	a0,2f4 <stat+0x42>
 2ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d0:	85ca                	mv	a1,s2
 2d2:	00000097          	auipc	ra,0x0
 2d6:	178080e7          	jalr	376(ra) # 44a <fstat>
 2da:	892a                	mv	s2,a0
  close(fd);
 2dc:	8526                	mv	a0,s1
 2de:	00000097          	auipc	ra,0x0
 2e2:	13c080e7          	jalr	316(ra) # 41a <close>
  return r;
}
 2e6:	854a                	mv	a0,s2
 2e8:	60e2                	ld	ra,24(sp)
 2ea:	6442                	ld	s0,16(sp)
 2ec:	64a2                	ld	s1,8(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	add	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfc5                	j	2e6 <stat+0x34>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	add	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fe:	00054683          	lbu	a3,0(a0)
 302:	fd06879b          	addw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	4625                	li	a2,9
 30c:	02f66863          	bltu	a2,a5,33c <atoi+0x44>
 310:	872a                	mv	a4,a0
  n = 0;
 312:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 314:	0705                	add	a4,a4,1
 316:	0025179b          	sllw	a5,a0,0x2
 31a:	9fa9                	addw	a5,a5,a0
 31c:	0017979b          	sllw	a5,a5,0x1
 320:	9fb5                	addw	a5,a5,a3
 322:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 326:	00074683          	lbu	a3,0(a4)
 32a:	fd06879b          	addw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	fef671e3          	bgeu	a2,a5,314 <atoi+0x1c>
  return n;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	add	sp,sp,16
 33a:	8082                	ret
  n = 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <atoi+0x3e>

0000000000000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	1141                	add	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 346:	02b57463          	bgeu	a0,a1,36e <memmove+0x2e>
    while(n-- > 0)
 34a:	00c05f63          	blez	a2,368 <memmove+0x28>
 34e:	1602                	sll	a2,a2,0x20
 350:	9201                	srl	a2,a2,0x20
 352:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 356:	872a                	mv	a4,a0
      *dst++ = *src++;
 358:	0585                	add	a1,a1,1
 35a:	0705                	add	a4,a4,1
 35c:	fff5c683          	lbu	a3,-1(a1)
 360:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 364:	fee79ae3          	bne	a5,a4,358 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	add	sp,sp,16
 36c:	8082                	ret
    dst += n;
 36e:	00c50733          	add	a4,a0,a2
    src += n;
 372:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 374:	fec05ae3          	blez	a2,368 <memmove+0x28>
 378:	fff6079b          	addw	a5,a2,-1
 37c:	1782                	sll	a5,a5,0x20
 37e:	9381                	srl	a5,a5,0x20
 380:	fff7c793          	not	a5,a5
 384:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 386:	15fd                	add	a1,a1,-1
 388:	177d                	add	a4,a4,-1
 38a:	0005c683          	lbu	a3,0(a1)
 38e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 392:	fee79ae3          	bne	a5,a4,386 <memmove+0x46>
 396:	bfc9                	j	368 <memmove+0x28>

0000000000000398 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 398:	1141                	add	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 39e:	ca05                	beqz	a2,3ce <memcmp+0x36>
 3a0:	fff6069b          	addw	a3,a2,-1
 3a4:	1682                	sll	a3,a3,0x20
 3a6:	9281                	srl	a3,a3,0x20
 3a8:	0685                	add	a3,a3,1
 3aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	0005c703          	lbu	a4,0(a1)
 3b4:	00e79863          	bne	a5,a4,3c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b8:	0505                	add	a0,a0,1
    p2++;
 3ba:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3bc:	fed518e3          	bne	a0,a3,3ac <memcmp+0x14>
  }
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	a019                	j	3c8 <memcmp+0x30>
      return *p1 - *p2;
 3c4:	40e7853b          	subw	a0,a5,a4
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	add	sp,sp,16
 3cc:	8082                	ret
  return 0;
 3ce:	4501                	li	a0,0
 3d0:	bfe5                	j	3c8 <memcmp+0x30>

00000000000003d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d2:	1141                	add	sp,sp,-16
 3d4:	e406                	sd	ra,8(sp)
 3d6:	e022                	sd	s0,0(sp)
 3d8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3da:	00000097          	auipc	ra,0x0
 3de:	f66080e7          	jalr	-154(ra) # 340 <memmove>
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	add	sp,sp,16
 3e8:	8082                	ret

00000000000003ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ea:	4885                	li	a7,1
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f2:	4889                	li	a7,2
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fa:	488d                	li	a7,3
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 402:	4891                	li	a7,4
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <read>:
.global read
read:
 li a7, SYS_read
 40a:	4895                	li	a7,5
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <write>:
.global write
write:
 li a7, SYS_write
 412:	48c1                	li	a7,16
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <close>:
.global close
close:
 li a7, SYS_close
 41a:	48d5                	li	a7,21
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <kill>:
.global kill
kill:
 li a7, SYS_kill
 422:	4899                	li	a7,6
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <exec>:
.global exec
exec:
 li a7, SYS_exec
 42a:	489d                	li	a7,7
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <open>:
.global open
open:
 li a7, SYS_open
 432:	48bd                	li	a7,15
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43a:	48c5                	li	a7,17
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 442:	48c9                	li	a7,18
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44a:	48a1                	li	a7,8
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <link>:
.global link
link:
 li a7, SYS_link
 452:	48cd                	li	a7,19
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45a:	48d1                	li	a7,20
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 462:	48a5                	li	a7,9
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <dup>:
.global dup
dup:
 li a7, SYS_dup
 46a:	48a9                	li	a7,10
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 472:	48ad                	li	a7,11
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47a:	48b1                	li	a7,12
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 482:	48b5                	li	a7,13
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48a:	48b9                	li	a7,14
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 492:	48d9                	li	a7,22
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49a:	1101                	add	sp,sp,-32
 49c:	ec06                	sd	ra,24(sp)
 49e:	e822                	sd	s0,16(sp)
 4a0:	1000                	add	s0,sp,32
 4a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a6:	4605                	li	a2,1
 4a8:	fef40593          	add	a1,s0,-17
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f66080e7          	jalr	-154(ra) # 412 <write>
}
 4b4:	60e2                	ld	ra,24(sp)
 4b6:	6442                	ld	s0,16(sp)
 4b8:	6105                	add	sp,sp,32
 4ba:	8082                	ret

00000000000004bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bc:	7139                	add	sp,sp,-64
 4be:	fc06                	sd	ra,56(sp)
 4c0:	f822                	sd	s0,48(sp)
 4c2:	f426                	sd	s1,40(sp)
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	0080                	add	s0,sp,64
 4ca:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	c299                	beqz	a3,4d2 <printint+0x16>
 4ce:	0805c963          	bltz	a1,560 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d2:	2581                	sext.w	a1,a1
  neg = 0;
 4d4:	4881                	li	a7,0
 4d6:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4dc:	2601                	sext.w	a2,a2
 4de:	00000517          	auipc	a0,0x0
 4e2:	5a250513          	add	a0,a0,1442 # a80 <digits>
 4e6:	883a                	mv	a6,a4
 4e8:	2705                	addw	a4,a4,1
 4ea:	02c5f7bb          	remuw	a5,a1,a2
 4ee:	1782                	sll	a5,a5,0x20
 4f0:	9381                	srl	a5,a5,0x20
 4f2:	97aa                	add	a5,a5,a0
 4f4:	0007c783          	lbu	a5,0(a5)
 4f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fc:	0005879b          	sext.w	a5,a1
 500:	02c5d5bb          	divuw	a1,a1,a2
 504:	0685                	add	a3,a3,1
 506:	fec7f0e3          	bgeu	a5,a2,4e6 <printint+0x2a>
  if(neg)
 50a:	00088c63          	beqz	a7,522 <printint+0x66>
    buf[i++] = '-';
 50e:	fd070793          	add	a5,a4,-48
 512:	00878733          	add	a4,a5,s0
 516:	02d00793          	li	a5,45
 51a:	fef70823          	sb	a5,-16(a4)
 51e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 522:	02e05863          	blez	a4,552 <printint+0x96>
 526:	fc040793          	add	a5,s0,-64
 52a:	00e78933          	add	s2,a5,a4
 52e:	fff78993          	add	s3,a5,-1
 532:	99ba                	add	s3,s3,a4
 534:	377d                	addw	a4,a4,-1
 536:	1702                	sll	a4,a4,0x20
 538:	9301                	srl	a4,a4,0x20
 53a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53e:	fff94583          	lbu	a1,-1(s2)
 542:	8526                	mv	a0,s1
 544:	00000097          	auipc	ra,0x0
 548:	f56080e7          	jalr	-170(ra) # 49a <putc>
  while(--i >= 0)
 54c:	197d                	add	s2,s2,-1
 54e:	ff3918e3          	bne	s2,s3,53e <printint+0x82>
}
 552:	70e2                	ld	ra,56(sp)
 554:	7442                	ld	s0,48(sp)
 556:	74a2                	ld	s1,40(sp)
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
 55c:	6121                	add	sp,sp,64
 55e:	8082                	ret
    x = -xx;
 560:	40b005bb          	negw	a1,a1
    neg = 1;
 564:	4885                	li	a7,1
    x = -xx;
 566:	bf85                	j	4d6 <printint+0x1a>

0000000000000568 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 568:	715d                	add	sp,sp,-80
 56a:	e486                	sd	ra,72(sp)
 56c:	e0a2                	sd	s0,64(sp)
 56e:	fc26                	sd	s1,56(sp)
 570:	f84a                	sd	s2,48(sp)
 572:	f44e                	sd	s3,40(sp)
 574:	f052                	sd	s4,32(sp)
 576:	ec56                	sd	s5,24(sp)
 578:	e85a                	sd	s6,16(sp)
 57a:	e45e                	sd	s7,8(sp)
 57c:	e062                	sd	s8,0(sp)
 57e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 580:	0005c903          	lbu	s2,0(a1)
 584:	18090c63          	beqz	s2,71c <vprintf+0x1b4>
 588:	8aaa                	mv	s5,a0
 58a:	8bb2                	mv	s7,a2
 58c:	00158493          	add	s1,a1,1
  state = 0;
 590:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 592:	02500a13          	li	s4,37
 596:	4b55                	li	s6,21
 598:	a839                	j	5b6 <vprintf+0x4e>
        putc(fd, c);
 59a:	85ca                	mv	a1,s2
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	efc080e7          	jalr	-260(ra) # 49a <putc>
 5a6:	a019                	j	5ac <vprintf+0x44>
    } else if(state == '%'){
 5a8:	01498d63          	beq	s3,s4,5c2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5ac:	0485                	add	s1,s1,1
 5ae:	fff4c903          	lbu	s2,-1(s1)
 5b2:	16090563          	beqz	s2,71c <vprintf+0x1b4>
    if(state == 0){
 5b6:	fe0999e3          	bnez	s3,5a8 <vprintf+0x40>
      if(c == '%'){
 5ba:	ff4910e3          	bne	s2,s4,59a <vprintf+0x32>
        state = '%';
 5be:	89d2                	mv	s3,s4
 5c0:	b7f5                	j	5ac <vprintf+0x44>
      if(c == 'd'){
 5c2:	13490263          	beq	s2,s4,6e6 <vprintf+0x17e>
 5c6:	f9d9079b          	addw	a5,s2,-99
 5ca:	0ff7f793          	zext.b	a5,a5
 5ce:	12fb6563          	bltu	s6,a5,6f8 <vprintf+0x190>
 5d2:	f9d9079b          	addw	a5,s2,-99
 5d6:	0ff7f713          	zext.b	a4,a5
 5da:	10eb6f63          	bltu	s6,a4,6f8 <vprintf+0x190>
 5de:	00271793          	sll	a5,a4,0x2
 5e2:	00000717          	auipc	a4,0x0
 5e6:	44670713          	add	a4,a4,1094 # a28 <malloc+0x20e>
 5ea:	97ba                	add	a5,a5,a4
 5ec:	439c                	lw	a5,0(a5)
 5ee:	97ba                	add	a5,a5,a4
 5f0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f2:	008b8913          	add	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	ebc080e7          	jalr	-324(ra) # 4bc <printint>
 608:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b745                	j	5ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b8913          	add	s2,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000ba583          	lw	a1,0(s7)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	ea0080e7          	jalr	-352(ra) # 4bc <printint>
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	b751                	j	5ac <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 62a:	008b8913          	add	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000ba583          	lw	a1,0(s7)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e84080e7          	jalr	-380(ra) # 4bc <printint>
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	b7a5                	j	5ac <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 646:	008b8c13          	add	s8,s7,8
 64a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64e:	03000593          	li	a1,48
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e46080e7          	jalr	-442(ra) # 49a <putc>
  putc(fd, 'x');
 65c:	07800593          	li	a1,120
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e38080e7          	jalr	-456(ra) # 49a <putc>
 66a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	414b8b93          	add	s7,s7,1044 # a80 <digits>
 674:	03c9d793          	srl	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e1a080e7          	jalr	-486(ra) # 49a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 688:	0992                	sll	s3,s3,0x4
 68a:	397d                	addw	s2,s2,-1
 68c:	fe0914e3          	bnez	s2,674 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 690:	8be2                	mv	s7,s8
      state = 0;
 692:	4981                	li	s3,0
 694:	bf21                	j	5ac <vprintf+0x44>
        s = va_arg(ap, char*);
 696:	008b8993          	add	s3,s7,8
 69a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 69e:	02090163          	beqz	s2,6c0 <vprintf+0x158>
        while(*s != 0){
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	c9a5                	beqz	a1,716 <vprintf+0x1ae>
          putc(fd, *s);
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	df0080e7          	jalr	-528(ra) # 49a <putc>
          s++;
 6b2:	0905                	add	s2,s2,1
        while(*s != 0){
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	f9e5                	bnez	a1,6a8 <vprintf+0x140>
        s = va_arg(ap, char*);
 6ba:	8bce                	mv	s7,s3
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b5fd                	j	5ac <vprintf+0x44>
          s = "(null)";
 6c0:	00000917          	auipc	s2,0x0
 6c4:	36090913          	add	s2,s2,864 # a20 <malloc+0x206>
        while(*s != 0){
 6c8:	02800593          	li	a1,40
 6cc:	bff1                	j	6a8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6ce:	008b8913          	add	s2,s7,8
 6d2:	000bc583          	lbu	a1,0(s7)
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	dc2080e7          	jalr	-574(ra) # 49a <putc>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b5e1                	j	5ac <vprintf+0x44>
        putc(fd, c);
 6e6:	02500593          	li	a1,37
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dae080e7          	jalr	-594(ra) # 49a <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bd5d                	j	5ac <vprintf+0x44>
        putc(fd, '%');
 6f8:	02500593          	li	a1,37
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	d9c080e7          	jalr	-612(ra) # 49a <putc>
        putc(fd, c);
 706:	85ca                	mv	a1,s2
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	d90080e7          	jalr	-624(ra) # 49a <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	bd61                	j	5ac <vprintf+0x44>
        s = va_arg(ap, char*);
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	bd49                	j	5ac <vprintf+0x44>
    }
  }
}
 71c:	60a6                	ld	ra,72(sp)
 71e:	6406                	ld	s0,64(sp)
 720:	74e2                	ld	s1,56(sp)
 722:	7942                	ld	s2,48(sp)
 724:	79a2                	ld	s3,40(sp)
 726:	7a02                	ld	s4,32(sp)
 728:	6ae2                	ld	s5,24(sp)
 72a:	6b42                	ld	s6,16(sp)
 72c:	6ba2                	ld	s7,8(sp)
 72e:	6c02                	ld	s8,0(sp)
 730:	6161                	add	sp,sp,80
 732:	8082                	ret

0000000000000734 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 734:	715d                	add	sp,sp,-80
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	add	s0,sp,32
 73c:	e010                	sd	a2,0(s0)
 73e:	e414                	sd	a3,8(s0)
 740:	e818                	sd	a4,16(s0)
 742:	ec1c                	sd	a5,24(s0)
 744:	03043023          	sd	a6,32(s0)
 748:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 750:	8622                	mv	a2,s0
 752:	00000097          	auipc	ra,0x0
 756:	e16080e7          	jalr	-490(ra) # 568 <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6161                	add	sp,sp,80
 760:	8082                	ret

0000000000000762 <printf>:

void
printf(const char *fmt, ...)
{
 762:	711d                	add	sp,sp,-96
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	add	s0,sp,32
 76a:	e40c                	sd	a1,8(s0)
 76c:	e810                	sd	a2,16(s0)
 76e:	ec14                	sd	a3,24(s0)
 770:	f018                	sd	a4,32(s0)
 772:	f41c                	sd	a5,40(s0)
 774:	03043823          	sd	a6,48(s0)
 778:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	00840613          	add	a2,s0,8
 780:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 784:	85aa                	mv	a1,a0
 786:	4505                	li	a0,1
 788:	00000097          	auipc	ra,0x0
 78c:	de0080e7          	jalr	-544(ra) # 568 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6125                	add	sp,sp,96
 796:	8082                	ret

0000000000000798 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 798:	1141                	add	sp,sp,-16
 79a:	e422                	sd	s0,8(sp)
 79c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	00000797          	auipc	a5,0x0
 7a6:	2f67b783          	ld	a5,758(a5) # a98 <freep>
 7aa:	a02d                	j	7d4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ac:	4618                	lw	a4,8(a2)
 7ae:	9f2d                	addw	a4,a4,a1
 7b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	6310                	ld	a2,0(a4)
 7b8:	a83d                	j	7f6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ba:	ff852703          	lw	a4,-8(a0)
 7be:	9f31                	addw	a4,a4,a2
 7c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c2:	ff053683          	ld	a3,-16(a0)
 7c6:	a091                	j	80a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e7e463          	bltu	a5,a4,7d2 <free+0x3a>
 7ce:	00e6ea63          	bltu	a3,a4,7e2 <free+0x4a>
{
 7d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	fed7fae3          	bgeu	a5,a3,7c8 <free+0x30>
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e6e463          	bltu	a3,a4,7e2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	fee7eae3          	bltu	a5,a4,7d2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7e2:	ff852583          	lw	a1,-8(a0)
 7e6:	6390                	ld	a2,0(a5)
 7e8:	02059813          	sll	a6,a1,0x20
 7ec:	01c85713          	srl	a4,a6,0x1c
 7f0:	9736                	add	a4,a4,a3
 7f2:	fae60de3          	beq	a2,a4,7ac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fa:	4790                	lw	a2,8(a5)
 7fc:	02061593          	sll	a1,a2,0x20
 800:	01c5d713          	srl	a4,a1,0x1c
 804:	973e                	add	a4,a4,a5
 806:	fae68ae3          	beq	a3,a4,7ba <free+0x22>
    p->s.ptr = bp->s.ptr;
 80a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80c:	00000717          	auipc	a4,0x0
 810:	28f73623          	sd	a5,652(a4) # a98 <freep>
}
 814:	6422                	ld	s0,8(sp)
 816:	0141                	add	sp,sp,16
 818:	8082                	ret

000000000000081a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81a:	7139                	add	sp,sp,-64
 81c:	fc06                	sd	ra,56(sp)
 81e:	f822                	sd	s0,48(sp)
 820:	f426                	sd	s1,40(sp)
 822:	f04a                	sd	s2,32(sp)
 824:	ec4e                	sd	s3,24(sp)
 826:	e852                	sd	s4,16(sp)
 828:	e456                	sd	s5,8(sp)
 82a:	e05a                	sd	s6,0(sp)
 82c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	02051493          	sll	s1,a0,0x20
 832:	9081                	srl	s1,s1,0x20
 834:	04bd                	add	s1,s1,15
 836:	8091                	srl	s1,s1,0x4
 838:	0014899b          	addw	s3,s1,1
 83c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 83e:	00000517          	auipc	a0,0x0
 842:	25a53503          	ld	a0,602(a0) # a98 <freep>
 846:	c515                	beqz	a0,872 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 848:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84a:	4798                	lw	a4,8(a5)
 84c:	02977f63          	bgeu	a4,s1,88a <malloc+0x70>
  if(nu < 4096)
 850:	8a4e                	mv	s4,s3
 852:	0009871b          	sext.w	a4,s3
 856:	6685                	lui	a3,0x1
 858:	00d77363          	bgeu	a4,a3,85e <malloc+0x44>
 85c:	6a05                	lui	s4,0x1
 85e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 862:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 866:	00000917          	auipc	s2,0x0
 86a:	23290913          	add	s2,s2,562 # a98 <freep>
  if(p == (char*)-1)
 86e:	5afd                	li	s5,-1
 870:	a895                	j	8e4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 872:	00000797          	auipc	a5,0x0
 876:	22e78793          	add	a5,a5,558 # aa0 <base>
 87a:	00000717          	auipc	a4,0x0
 87e:	20f73f23          	sd	a5,542(a4) # a98 <freep>
 882:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 884:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 888:	b7e1                	j	850 <malloc+0x36>
      if(p->s.size == nunits)
 88a:	02e48c63          	beq	s1,a4,8c2 <malloc+0xa8>
        p->s.size -= nunits;
 88e:	4137073b          	subw	a4,a4,s3
 892:	c798                	sw	a4,8(a5)
        p += p->s.size;
 894:	02071693          	sll	a3,a4,0x20
 898:	01c6d713          	srl	a4,a3,0x1c
 89c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a2:	00000717          	auipc	a4,0x0
 8a6:	1ea73b23          	sd	a0,502(a4) # a98 <freep>
      return (void*)(p + 1);
 8aa:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	74a2                	ld	s1,40(sp)
 8b4:	7902                	ld	s2,32(sp)
 8b6:	69e2                	ld	s3,24(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	6121                	add	sp,sp,64
 8c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	e118                	sd	a4,0(a0)
 8c6:	bff1                	j	8a2 <malloc+0x88>
  hp->s.size = nu;
 8c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8cc:	0541                	add	a0,a0,16
 8ce:	00000097          	auipc	ra,0x0
 8d2:	eca080e7          	jalr	-310(ra) # 798 <free>
  return freep;
 8d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8da:	d971                	beqz	a0,8ae <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	fa9775e3          	bgeu	a4,s1,88a <malloc+0x70>
    if(p == freep)
 8e4:	00093703          	ld	a4,0(s2)
 8e8:	853e                	mv	a0,a5
 8ea:	fef719e3          	bne	a4,a5,8dc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ee:	8552                	mv	a0,s4
 8f0:	00000097          	auipc	ra,0x0
 8f4:	b8a080e7          	jalr	-1142(ra) # 47a <sbrk>
  if(p == (char*)-1)
 8f8:	fd5518e3          	bne	a0,s5,8c8 <malloc+0xae>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	bf45                	j	8ae <malloc+0x94>
