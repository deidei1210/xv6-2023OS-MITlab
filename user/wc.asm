
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	99ad8d93          	add	s11,s11,-1638 # 9c8 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	8c8a0a13          	add	s4,s4,-1848 # 900 <malloc+0xea>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1d8080e7          	jalr	472(ra) # 21e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	add	s1,s1,1
  54:	00998d63          	beq	s3,s1,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	392080e7          	jalr	914(ra) # 40e <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	93e48493          	add	s1,s1,-1730 # 9c8 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	87250513          	add	a0,a0,-1934 # 918 <malloc+0x102>
  ae:	00000097          	auipc	ra,0x0
  b2:	6b0080e7          	jalr	1712(ra) # 75e <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	add	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	83450513          	add	a0,a0,-1996 # 908 <malloc+0xf2>
  dc:	00000097          	auipc	ra,0x0
  e0:	682080e7          	jalr	1666(ra) # 75e <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	310080e7          	jalr	784(ra) # 3f6 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	add	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
  fa:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fc:	4785                	li	a5,1
  fe:	04a7d963          	bge	a5,a0,150 <main+0x62>
 102:	00858913          	add	s2,a1,8
 106:	ffe5099b          	addw	s3,a0,-2
 10a:	02099793          	sll	a5,s3,0x20
 10e:	01d7d993          	srl	s3,a5,0x1d
 112:	05c1                	add	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	31a080e7          	jalr	794(ra) # 436 <open>
 124:	84aa                	mv	s1,a0
 126:	04054363          	bltz	a0,16c <main+0x7e>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	2e6080e7          	jalr	742(ra) # 41e <close>
  for(i = 1; i < argc; i++){
 140:	0921                	add	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2ae080e7          	jalr	686(ra) # 3f6 <exit>
    wc(0, "");
 150:	00000597          	auipc	a1,0x0
 154:	7d858593          	add	a1,a1,2008 # 928 <malloc+0x112>
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	ea6080e7          	jalr	-346(ra) # 0 <wc>
    exit(0);
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	292080e7          	jalr	658(ra) # 3f6 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 16c:	00093583          	ld	a1,0(s2)
 170:	00000517          	auipc	a0,0x0
 174:	7c050513          	add	a0,a0,1984 # 930 <malloc+0x11a>
 178:	00000097          	auipc	ra,0x0
 17c:	5e6080e7          	jalr	1510(ra) # 75e <printf>
      exit(1);
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	274080e7          	jalr	628(ra) # 3f6 <exit>

000000000000018a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 18a:	1141                	add	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 190:	87aa                	mv	a5,a0
 192:	0585                	add	a1,a1,1
 194:	0785                	add	a5,a5,1
 196:	fff5c703          	lbu	a4,-1(a1)
 19a:	fee78fa3          	sb	a4,-1(a5)
 19e:	fb75                	bnez	a4,192 <strcpy+0x8>
    ;
  return os;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	add	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a6:	1141                	add	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb91                	beqz	a5,1c4 <strcmp+0x1e>
 1b2:	0005c703          	lbu	a4,0(a1)
 1b6:	00f71763          	bne	a4,a5,1c4 <strcmp+0x1e>
    p++, q++;
 1ba:	0505                	add	a0,a0,1
 1bc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbe5                	bnez	a5,1b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c4:	0005c503          	lbu	a0,0(a1)
}
 1c8:	40a7853b          	subw	a0,a5,a0
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	add	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strlen>:

uint
strlen(const char *s)
{
 1d2:	1141                	add	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cf91                	beqz	a5,1f8 <strlen+0x26>
 1de:	0505                	add	a0,a0,1
 1e0:	87aa                	mv	a5,a0
 1e2:	86be                	mv	a3,a5
 1e4:	0785                	add	a5,a5,1
 1e6:	fff7c703          	lbu	a4,-1(a5)
 1ea:	ff65                	bnez	a4,1e2 <strlen+0x10>
 1ec:	40a6853b          	subw	a0,a3,a0
 1f0:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	add	sp,sp,16
 1f6:	8082                	ret
  for(n = 0; s[n]; n++)
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strlen+0x20>

00000000000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 202:	ca19                	beqz	a2,218 <memset+0x1c>
 204:	87aa                	mv	a5,a0
 206:	1602                	sll	a2,a2,0x20
 208:	9201                	srl	a2,a2,0x20
 20a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 20e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 212:	0785                	add	a5,a5,1
 214:	fee79de3          	bne	a5,a4,20e <memset+0x12>
  }
  return dst;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	add	sp,sp,16
 21c:	8082                	ret

000000000000021e <strchr>:

char*
strchr(const char *s, char c)
{
 21e:	1141                	add	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	add	s0,sp,16
  for(; *s; s++)
 224:	00054783          	lbu	a5,0(a0)
 228:	cb99                	beqz	a5,23e <strchr+0x20>
    if(*s == c)
 22a:	00f58763          	beq	a1,a5,238 <strchr+0x1a>
  for(; *s; s++)
 22e:	0505                	add	a0,a0,1
 230:	00054783          	lbu	a5,0(a0)
 234:	fbfd                	bnez	a5,22a <strchr+0xc>
      return (char*)s;
  return 0;
 236:	4501                	li	a0,0
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	add	sp,sp,16
 23c:	8082                	ret
  return 0;
 23e:	4501                	li	a0,0
 240:	bfe5                	j	238 <strchr+0x1a>

0000000000000242 <gets>:

char*
gets(char *buf, int max)
{
 242:	711d                	add	sp,sp,-96
 244:	ec86                	sd	ra,88(sp)
 246:	e8a2                	sd	s0,80(sp)
 248:	e4a6                	sd	s1,72(sp)
 24a:	e0ca                	sd	s2,64(sp)
 24c:	fc4e                	sd	s3,56(sp)
 24e:	f852                	sd	s4,48(sp)
 250:	f456                	sd	s5,40(sp)
 252:	f05a                	sd	s6,32(sp)
 254:	ec5e                	sd	s7,24(sp)
 256:	1080                	add	s0,sp,96
 258:	8baa                	mv	s7,a0
 25a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25c:	892a                	mv	s2,a0
 25e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	4aa9                	li	s5,10
 262:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 264:	89a6                	mv	s3,s1
 266:	2485                	addw	s1,s1,1
 268:	0344d863          	bge	s1,s4,298 <gets+0x56>
    cc = read(0, &c, 1);
 26c:	4605                	li	a2,1
 26e:	faf40593          	add	a1,s0,-81
 272:	4501                	li	a0,0
 274:	00000097          	auipc	ra,0x0
 278:	19a080e7          	jalr	410(ra) # 40e <read>
    if(cc < 1)
 27c:	00a05e63          	blez	a0,298 <gets+0x56>
    buf[i++] = c;
 280:	faf44783          	lbu	a5,-81(s0)
 284:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 288:	01578763          	beq	a5,s5,296 <gets+0x54>
 28c:	0905                	add	s2,s2,1
 28e:	fd679be3          	bne	a5,s6,264 <gets+0x22>
  for(i=0; i+1 < max; ){
 292:	89a6                	mv	s3,s1
 294:	a011                	j	298 <gets+0x56>
 296:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 298:	99de                	add	s3,s3,s7
 29a:	00098023          	sb	zero,0(s3)
  return buf;
}
 29e:	855e                	mv	a0,s7
 2a0:	60e6                	ld	ra,88(sp)
 2a2:	6446                	ld	s0,80(sp)
 2a4:	64a6                	ld	s1,72(sp)
 2a6:	6906                	ld	s2,64(sp)
 2a8:	79e2                	ld	s3,56(sp)
 2aa:	7a42                	ld	s4,48(sp)
 2ac:	7aa2                	ld	s5,40(sp)
 2ae:	7b02                	ld	s6,32(sp)
 2b0:	6be2                	ld	s7,24(sp)
 2b2:	6125                	add	sp,sp,96
 2b4:	8082                	ret

00000000000002b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b6:	1101                	add	sp,sp,-32
 2b8:	ec06                	sd	ra,24(sp)
 2ba:	e822                	sd	s0,16(sp)
 2bc:	e426                	sd	s1,8(sp)
 2be:	e04a                	sd	s2,0(sp)
 2c0:	1000                	add	s0,sp,32
 2c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c4:	4581                	li	a1,0
 2c6:	00000097          	auipc	ra,0x0
 2ca:	170080e7          	jalr	368(ra) # 436 <open>
  if(fd < 0)
 2ce:	02054563          	bltz	a0,2f8 <stat+0x42>
 2d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d4:	85ca                	mv	a1,s2
 2d6:	00000097          	auipc	ra,0x0
 2da:	178080e7          	jalr	376(ra) # 44e <fstat>
 2de:	892a                	mv	s2,a0
  close(fd);
 2e0:	8526                	mv	a0,s1
 2e2:	00000097          	auipc	ra,0x0
 2e6:	13c080e7          	jalr	316(ra) # 41e <close>
  return r;
}
 2ea:	854a                	mv	a0,s2
 2ec:	60e2                	ld	ra,24(sp)
 2ee:	6442                	ld	s0,16(sp)
 2f0:	64a2                	ld	s1,8(sp)
 2f2:	6902                	ld	s2,0(sp)
 2f4:	6105                	add	sp,sp,32
 2f6:	8082                	ret
    return -1;
 2f8:	597d                	li	s2,-1
 2fa:	bfc5                	j	2ea <stat+0x34>

00000000000002fc <atoi>:

int
atoi(const char *s)
{
 2fc:	1141                	add	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 302:	00054683          	lbu	a3,0(a0)
 306:	fd06879b          	addw	a5,a3,-48
 30a:	0ff7f793          	zext.b	a5,a5
 30e:	4625                	li	a2,9
 310:	02f66863          	bltu	a2,a5,340 <atoi+0x44>
 314:	872a                	mv	a4,a0
  n = 0;
 316:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 318:	0705                	add	a4,a4,1
 31a:	0025179b          	sllw	a5,a0,0x2
 31e:	9fa9                	addw	a5,a5,a0
 320:	0017979b          	sllw	a5,a5,0x1
 324:	9fb5                	addw	a5,a5,a3
 326:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32a:	00074683          	lbu	a3,0(a4)
 32e:	fd06879b          	addw	a5,a3,-48
 332:	0ff7f793          	zext.b	a5,a5
 336:	fef671e3          	bgeu	a2,a5,318 <atoi+0x1c>
  return n;
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	add	sp,sp,16
 33e:	8082                	ret
  n = 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <atoi+0x3e>

0000000000000344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 344:	1141                	add	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34a:	02b57463          	bgeu	a0,a1,372 <memmove+0x2e>
    while(n-- > 0)
 34e:	00c05f63          	blez	a2,36c <memmove+0x28>
 352:	1602                	sll	a2,a2,0x20
 354:	9201                	srl	a2,a2,0x20
 356:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35a:	872a                	mv	a4,a0
      *dst++ = *src++;
 35c:	0585                	add	a1,a1,1
 35e:	0705                	add	a4,a4,1
 360:	fff5c683          	lbu	a3,-1(a1)
 364:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	add	sp,sp,16
 370:	8082                	ret
    dst += n;
 372:	00c50733          	add	a4,a0,a2
    src += n;
 376:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 378:	fec05ae3          	blez	a2,36c <memmove+0x28>
 37c:	fff6079b          	addw	a5,a2,-1
 380:	1782                	sll	a5,a5,0x20
 382:	9381                	srl	a5,a5,0x20
 384:	fff7c793          	not	a5,a5
 388:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38a:	15fd                	add	a1,a1,-1
 38c:	177d                	add	a4,a4,-1
 38e:	0005c683          	lbu	a3,0(a1)
 392:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 396:	fee79ae3          	bne	a5,a4,38a <memmove+0x46>
 39a:	bfc9                	j	36c <memmove+0x28>

000000000000039c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39c:	1141                	add	sp,sp,-16
 39e:	e422                	sd	s0,8(sp)
 3a0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a2:	ca05                	beqz	a2,3d2 <memcmp+0x36>
 3a4:	fff6069b          	addw	a3,a2,-1
 3a8:	1682                	sll	a3,a3,0x20
 3aa:	9281                	srl	a3,a3,0x20
 3ac:	0685                	add	a3,a3,1
 3ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	0005c703          	lbu	a4,0(a1)
 3b8:	00e79863          	bne	a5,a4,3c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3bc:	0505                	add	a0,a0,1
    p2++;
 3be:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3c0:	fed518e3          	bne	a0,a3,3b0 <memcmp+0x14>
  }
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	a019                	j	3cc <memcmp+0x30>
      return *p1 - *p2;
 3c8:	40e7853b          	subw	a0,a5,a4
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	add	sp,sp,16
 3d0:	8082                	ret
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	bfe5                	j	3cc <memcmp+0x30>

00000000000003d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d6:	1141                	add	sp,sp,-16
 3d8:	e406                	sd	ra,8(sp)
 3da:	e022                	sd	s0,0(sp)
 3dc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3de:	00000097          	auipc	ra,0x0
 3e2:	f66080e7          	jalr	-154(ra) # 344 <memmove>
}
 3e6:	60a2                	ld	ra,8(sp)
 3e8:	6402                	ld	s0,0(sp)
 3ea:	0141                	add	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ee:	4885                	li	a7,1
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f6:	4889                	li	a7,2
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fe:	488d                	li	a7,3
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 406:	4891                	li	a7,4
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <read>:
.global read
read:
 li a7, SYS_read
 40e:	4895                	li	a7,5
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <write>:
.global write
write:
 li a7, SYS_write
 416:	48c1                	li	a7,16
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <close>:
.global close
close:
 li a7, SYS_close
 41e:	48d5                	li	a7,21
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <kill>:
.global kill
kill:
 li a7, SYS_kill
 426:	4899                	li	a7,6
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <exec>:
.global exec
exec:
 li a7, SYS_exec
 42e:	489d                	li	a7,7
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <open>:
.global open
open:
 li a7, SYS_open
 436:	48bd                	li	a7,15
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43e:	48c5                	li	a7,17
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 446:	48c9                	li	a7,18
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44e:	48a1                	li	a7,8
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <link>:
.global link
link:
 li a7, SYS_link
 456:	48cd                	li	a7,19
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45e:	48d1                	li	a7,20
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 466:	48a5                	li	a7,9
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <dup>:
.global dup
dup:
 li a7, SYS_dup
 46e:	48a9                	li	a7,10
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 476:	48ad                	li	a7,11
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47e:	48b1                	li	a7,12
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 486:	48b5                	li	a7,13
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48e:	48b9                	li	a7,14
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 496:	1101                	add	sp,sp,-32
 498:	ec06                	sd	ra,24(sp)
 49a:	e822                	sd	s0,16(sp)
 49c:	1000                	add	s0,sp,32
 49e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a2:	4605                	li	a2,1
 4a4:	fef40593          	add	a1,s0,-17
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f6e080e7          	jalr	-146(ra) # 416 <write>
}
 4b0:	60e2                	ld	ra,24(sp)
 4b2:	6442                	ld	s0,16(sp)
 4b4:	6105                	add	sp,sp,32
 4b6:	8082                	ret

00000000000004b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b8:	7139                	add	sp,sp,-64
 4ba:	fc06                	sd	ra,56(sp)
 4bc:	f822                	sd	s0,48(sp)
 4be:	f426                	sd	s1,40(sp)
 4c0:	f04a                	sd	s2,32(sp)
 4c2:	ec4e                	sd	s3,24(sp)
 4c4:	0080                	add	s0,sp,64
 4c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c8:	c299                	beqz	a3,4ce <printint+0x16>
 4ca:	0805c963          	bltz	a1,55c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ce:	2581                	sext.w	a1,a1
  neg = 0;
 4d0:	4881                	li	a7,0
 4d2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d8:	2601                	sext.w	a2,a2
 4da:	00000517          	auipc	a0,0x0
 4de:	4ce50513          	add	a0,a0,1230 # 9a8 <digits>
 4e2:	883a                	mv	a6,a4
 4e4:	2705                	addw	a4,a4,1
 4e6:	02c5f7bb          	remuw	a5,a1,a2
 4ea:	1782                	sll	a5,a5,0x20
 4ec:	9381                	srl	a5,a5,0x20
 4ee:	97aa                	add	a5,a5,a0
 4f0:	0007c783          	lbu	a5,0(a5)
 4f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f8:	0005879b          	sext.w	a5,a1
 4fc:	02c5d5bb          	divuw	a1,a1,a2
 500:	0685                	add	a3,a3,1
 502:	fec7f0e3          	bgeu	a5,a2,4e2 <printint+0x2a>
  if(neg)
 506:	00088c63          	beqz	a7,51e <printint+0x66>
    buf[i++] = '-';
 50a:	fd070793          	add	a5,a4,-48
 50e:	00878733          	add	a4,a5,s0
 512:	02d00793          	li	a5,45
 516:	fef70823          	sb	a5,-16(a4)
 51a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 51e:	02e05863          	blez	a4,54e <printint+0x96>
 522:	fc040793          	add	a5,s0,-64
 526:	00e78933          	add	s2,a5,a4
 52a:	fff78993          	add	s3,a5,-1
 52e:	99ba                	add	s3,s3,a4
 530:	377d                	addw	a4,a4,-1
 532:	1702                	sll	a4,a4,0x20
 534:	9301                	srl	a4,a4,0x20
 536:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53a:	fff94583          	lbu	a1,-1(s2)
 53e:	8526                	mv	a0,s1
 540:	00000097          	auipc	ra,0x0
 544:	f56080e7          	jalr	-170(ra) # 496 <putc>
  while(--i >= 0)
 548:	197d                	add	s2,s2,-1
 54a:	ff3918e3          	bne	s2,s3,53a <printint+0x82>
}
 54e:	70e2                	ld	ra,56(sp)
 550:	7442                	ld	s0,48(sp)
 552:	74a2                	ld	s1,40(sp)
 554:	7902                	ld	s2,32(sp)
 556:	69e2                	ld	s3,24(sp)
 558:	6121                	add	sp,sp,64
 55a:	8082                	ret
    x = -xx;
 55c:	40b005bb          	negw	a1,a1
    neg = 1;
 560:	4885                	li	a7,1
    x = -xx;
 562:	bf85                	j	4d2 <printint+0x1a>

0000000000000564 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 564:	715d                	add	sp,sp,-80
 566:	e486                	sd	ra,72(sp)
 568:	e0a2                	sd	s0,64(sp)
 56a:	fc26                	sd	s1,56(sp)
 56c:	f84a                	sd	s2,48(sp)
 56e:	f44e                	sd	s3,40(sp)
 570:	f052                	sd	s4,32(sp)
 572:	ec56                	sd	s5,24(sp)
 574:	e85a                	sd	s6,16(sp)
 576:	e45e                	sd	s7,8(sp)
 578:	e062                	sd	s8,0(sp)
 57a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57c:	0005c903          	lbu	s2,0(a1)
 580:	18090c63          	beqz	s2,718 <vprintf+0x1b4>
 584:	8aaa                	mv	s5,a0
 586:	8bb2                	mv	s7,a2
 588:	00158493          	add	s1,a1,1
  state = 0;
 58c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 58e:	02500a13          	li	s4,37
 592:	4b55                	li	s6,21
 594:	a839                	j	5b2 <vprintf+0x4e>
        putc(fd, c);
 596:	85ca                	mv	a1,s2
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	efc080e7          	jalr	-260(ra) # 496 <putc>
 5a2:	a019                	j	5a8 <vprintf+0x44>
    } else if(state == '%'){
 5a4:	01498d63          	beq	s3,s4,5be <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5a8:	0485                	add	s1,s1,1
 5aa:	fff4c903          	lbu	s2,-1(s1)
 5ae:	16090563          	beqz	s2,718 <vprintf+0x1b4>
    if(state == 0){
 5b2:	fe0999e3          	bnez	s3,5a4 <vprintf+0x40>
      if(c == '%'){
 5b6:	ff4910e3          	bne	s2,s4,596 <vprintf+0x32>
        state = '%';
 5ba:	89d2                	mv	s3,s4
 5bc:	b7f5                	j	5a8 <vprintf+0x44>
      if(c == 'd'){
 5be:	13490263          	beq	s2,s4,6e2 <vprintf+0x17e>
 5c2:	f9d9079b          	addw	a5,s2,-99
 5c6:	0ff7f793          	zext.b	a5,a5
 5ca:	12fb6563          	bltu	s6,a5,6f4 <vprintf+0x190>
 5ce:	f9d9079b          	addw	a5,s2,-99
 5d2:	0ff7f713          	zext.b	a4,a5
 5d6:	10eb6f63          	bltu	s6,a4,6f4 <vprintf+0x190>
 5da:	00271793          	sll	a5,a4,0x2
 5de:	00000717          	auipc	a4,0x0
 5e2:	37270713          	add	a4,a4,882 # 950 <malloc+0x13a>
 5e6:	97ba                	add	a5,a5,a4
 5e8:	439c                	lw	a5,0(a5)
 5ea:	97ba                	add	a5,a5,a4
 5ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ee:	008b8913          	add	s2,s7,8
 5f2:	4685                	li	a3,1
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	ebc080e7          	jalr	-324(ra) # 4b8 <printint>
 604:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 606:	4981                	li	s3,0
 608:	b745                	j	5a8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	008b8913          	add	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	ea0080e7          	jalr	-352(ra) # 4b8 <printint>
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	b751                	j	5a8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 626:	008b8913          	add	s2,s7,8
 62a:	4681                	li	a3,0
 62c:	4641                	li	a2,16
 62e:	000ba583          	lw	a1,0(s7)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e84080e7          	jalr	-380(ra) # 4b8 <printint>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b7a5                	j	5a8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 642:	008b8c13          	add	s8,s7,8
 646:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64a:	03000593          	li	a1,48
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e46080e7          	jalr	-442(ra) # 496 <putc>
  putc(fd, 'x');
 658:	07800593          	li	a1,120
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e38080e7          	jalr	-456(ra) # 496 <putc>
 666:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 668:	00000b97          	auipc	s7,0x0
 66c:	340b8b93          	add	s7,s7,832 # 9a8 <digits>
 670:	03c9d793          	srl	a5,s3,0x3c
 674:	97de                	add	a5,a5,s7
 676:	0007c583          	lbu	a1,0(a5)
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e1a080e7          	jalr	-486(ra) # 496 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 684:	0992                	sll	s3,s3,0x4
 686:	397d                	addw	s2,s2,-1
 688:	fe0914e3          	bnez	s2,670 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 68c:	8be2                	mv	s7,s8
      state = 0;
 68e:	4981                	li	s3,0
 690:	bf21                	j	5a8 <vprintf+0x44>
        s = va_arg(ap, char*);
 692:	008b8993          	add	s3,s7,8
 696:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 69a:	02090163          	beqz	s2,6bc <vprintf+0x158>
        while(*s != 0){
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	c9a5                	beqz	a1,712 <vprintf+0x1ae>
          putc(fd, *s);
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	df0080e7          	jalr	-528(ra) # 496 <putc>
          s++;
 6ae:	0905                	add	s2,s2,1
        while(*s != 0){
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	f9e5                	bnez	a1,6a4 <vprintf+0x140>
        s = va_arg(ap, char*);
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5fd                	j	5a8 <vprintf+0x44>
          s = "(null)";
 6bc:	00000917          	auipc	s2,0x0
 6c0:	28c90913          	add	s2,s2,652 # 948 <malloc+0x132>
        while(*s != 0){
 6c4:	02800593          	li	a1,40
 6c8:	bff1                	j	6a4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6ca:	008b8913          	add	s2,s7,8
 6ce:	000bc583          	lbu	a1,0(s7)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dc2080e7          	jalr	-574(ra) # 496 <putc>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b5e1                	j	5a8 <vprintf+0x44>
        putc(fd, c);
 6e2:	02500593          	li	a1,37
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	dae080e7          	jalr	-594(ra) # 496 <putc>
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bd5d                	j	5a8 <vprintf+0x44>
        putc(fd, '%');
 6f4:	02500593          	li	a1,37
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	d9c080e7          	jalr	-612(ra) # 496 <putc>
        putc(fd, c);
 702:	85ca                	mv	a1,s2
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d90080e7          	jalr	-624(ra) # 496 <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd61                	j	5a8 <vprintf+0x44>
        s = va_arg(ap, char*);
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	bd49                	j	5a8 <vprintf+0x44>
    }
  }
}
 718:	60a6                	ld	ra,72(sp)
 71a:	6406                	ld	s0,64(sp)
 71c:	74e2                	ld	s1,56(sp)
 71e:	7942                	ld	s2,48(sp)
 720:	79a2                	ld	s3,40(sp)
 722:	7a02                	ld	s4,32(sp)
 724:	6ae2                	ld	s5,24(sp)
 726:	6b42                	ld	s6,16(sp)
 728:	6ba2                	ld	s7,8(sp)
 72a:	6c02                	ld	s8,0(sp)
 72c:	6161                	add	sp,sp,80
 72e:	8082                	ret

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	add	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	add	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	8622                	mv	a2,s0
 74e:	00000097          	auipc	ra,0x0
 752:	e16080e7          	jalr	-490(ra) # 564 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	add	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	add	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	add	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	add	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	00000097          	auipc	ra,0x0
 788:	de0080e7          	jalr	-544(ra) # 564 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	add	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	add	sp,sp,-16
 796:	e422                	sd	s0,8(sp)
 798:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00000797          	auipc	a5,0x0
 7a2:	2227b783          	ld	a5,546(a5) # 9c0 <freep>
 7a6:	a02d                	j	7d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	4618                	lw	a4,8(a2)
 7aa:	9f2d                	addw	a4,a4,a1
 7ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	6310                	ld	a2,0(a4)
 7b4:	a83d                	j	7f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b6:	ff852703          	lw	a4,-8(a0)
 7ba:	9f31                	addw	a4,a4,a2
 7bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7be:	ff053683          	ld	a3,-16(a0)
 7c2:	a091                	j	806 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e7e463          	bltu	a5,a4,7ce <free+0x3a>
 7ca:	00e6ea63          	bltu	a3,a4,7de <free+0x4a>
{
 7ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	fed7fae3          	bgeu	a5,a3,7c4 <free+0x30>
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e6e463          	bltu	a3,a4,7de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	fee7eae3          	bltu	a5,a4,7ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7de:	ff852583          	lw	a1,-8(a0)
 7e2:	6390                	ld	a2,0(a5)
 7e4:	02059813          	sll	a6,a1,0x20
 7e8:	01c85713          	srl	a4,a6,0x1c
 7ec:	9736                	add	a4,a4,a3
 7ee:	fae60de3          	beq	a2,a4,7a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f6:	4790                	lw	a2,8(a5)
 7f8:	02061593          	sll	a1,a2,0x20
 7fc:	01c5d713          	srl	a4,a1,0x1c
 800:	973e                	add	a4,a4,a5
 802:	fae68ae3          	beq	a3,a4,7b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 806:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 808:	00000717          	auipc	a4,0x0
 80c:	1af73c23          	sd	a5,440(a4) # 9c0 <freep>
}
 810:	6422                	ld	s0,8(sp)
 812:	0141                	add	sp,sp,16
 814:	8082                	ret

0000000000000816 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 816:	7139                	add	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f426                	sd	s1,40(sp)
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
 828:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82a:	02051493          	sll	s1,a0,0x20
 82e:	9081                	srl	s1,s1,0x20
 830:	04bd                	add	s1,s1,15
 832:	8091                	srl	s1,s1,0x4
 834:	0014899b          	addw	s3,s1,1
 838:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 83a:	00000517          	auipc	a0,0x0
 83e:	18653503          	ld	a0,390(a0) # 9c0 <freep>
 842:	c515                	beqz	a0,86e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	02977f63          	bgeu	a4,s1,886 <malloc+0x70>
  if(nu < 4096)
 84c:	8a4e                	mv	s4,s3
 84e:	0009871b          	sext.w	a4,s3
 852:	6685                	lui	a3,0x1
 854:	00d77363          	bgeu	a4,a3,85a <malloc+0x44>
 858:	6a05                	lui	s4,0x1
 85a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 862:	00000917          	auipc	s2,0x0
 866:	15e90913          	add	s2,s2,350 # 9c0 <freep>
  if(p == (char*)-1)
 86a:	5afd                	li	s5,-1
 86c:	a895                	j	8e0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 86e:	00000797          	auipc	a5,0x0
 872:	35a78793          	add	a5,a5,858 # bc8 <base>
 876:	00000717          	auipc	a4,0x0
 87a:	14f73523          	sd	a5,330(a4) # 9c0 <freep>
 87e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 880:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 884:	b7e1                	j	84c <malloc+0x36>
      if(p->s.size == nunits)
 886:	02e48c63          	beq	s1,a4,8be <malloc+0xa8>
        p->s.size -= nunits;
 88a:	4137073b          	subw	a4,a4,s3
 88e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 890:	02071693          	sll	a3,a4,0x20
 894:	01c6d713          	srl	a4,a3,0x1c
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	12a73123          	sd	a0,290(a4) # 9c0 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	7902                	ld	s2,32(sp)
 8b2:	69e2                	ld	s3,24(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
 8ba:	6121                	add	sp,sp,64
 8bc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	e118                	sd	a4,0(a0)
 8c2:	bff1                	j	89e <malloc+0x88>
  hp->s.size = nu;
 8c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c8:	0541                	add	a0,a0,16
 8ca:	00000097          	auipc	ra,0x0
 8ce:	eca080e7          	jalr	-310(ra) # 794 <free>
  return freep;
 8d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d6:	d971                	beqz	a0,8aa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8da:	4798                	lw	a4,8(a5)
 8dc:	fa9775e3          	bgeu	a4,s1,886 <malloc+0x70>
    if(p == freep)
 8e0:	00093703          	ld	a4,0(s2)
 8e4:	853e                	mv	a0,a5
 8e6:	fef719e3          	bne	a4,a5,8d8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ea:	8552                	mv	a0,s4
 8ec:	00000097          	auipc	ra,0x0
 8f0:	b92080e7          	jalr	-1134(ra) # 47e <sbrk>
  if(p == (char*)-1)
 8f4:	fd5518e3          	bne	a0,s5,8c4 <malloc+0xae>
        return 0;
 8f8:	4501                	li	a0,0
 8fa:	bf45                	j	8aa <malloc+0x94>
