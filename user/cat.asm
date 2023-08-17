
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	9f890913          	add	s2,s2,-1544 # a08 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	380080e7          	jalr	896(ra) # 3a0 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	374080e7          	jalr	884(ra) # 3a8 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	8d858593          	add	a1,a1,-1832 # 918 <statistics+0x8a>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	678080e7          	jalr	1656(ra) # 6c2 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	334080e7          	jalr	820(ra) # 388 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	add	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	8c258593          	add	a1,a1,-1854 # 930 <statistics+0xa2>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	64a080e7          	jalr	1610(ra) # 6c2 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	306080e7          	jalr	774(ra) # 388 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	add	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  98:	4785                	li	a5,1
  9a:	04a7d763          	bge	a5,a0,e8 <main+0x5e>
  9e:	00858913          	add	s2,a1,8
  a2:	ffe5099b          	addw	s3,a0,-2
  a6:	02099793          	sll	a5,s3,0x20
  aa:	01d7d993          	srl	s3,a5,0x1d
  ae:	05c1                	add	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2)
  b8:	00000097          	auipc	ra,0x0
  bc:	310080e7          	jalr	784(ra) # 3c8 <open>
  c0:	84aa                	mv	s1,a0
  c2:	02054d63          	bltz	a0,fc <main+0x72>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	2e0080e7          	jalr	736(ra) # 3b0 <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	add	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2a8080e7          	jalr	680(ra) # 388 <exit>
    cat(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	f16080e7          	jalr	-234(ra) # 0 <cat>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	294080e7          	jalr	660(ra) # 388 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fc:	00093603          	ld	a2,0(s2)
 100:	00001597          	auipc	a1,0x1
 104:	84858593          	add	a1,a1,-1976 # 948 <statistics+0xba>
 108:	4509                	li	a0,2
 10a:	00000097          	auipc	ra,0x0
 10e:	5b8080e7          	jalr	1464(ra) # 6c2 <fprintf>
      exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	274080e7          	jalr	628(ra) # 388 <exit>

000000000000011c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11c:	1141                	add	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 122:	87aa                	mv	a5,a0
 124:	0585                	add	a1,a1,1
 126:	0785                	add	a5,a5,1
 128:	fff5c703          	lbu	a4,-1(a1)
 12c:	fee78fa3          	sb	a4,-1(a5)
 130:	fb75                	bnez	a4,124 <strcpy+0x8>
    ;
  return os;
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	add	sp,sp,16
 136:	8082                	ret

0000000000000138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 138:	1141                	add	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cb91                	beqz	a5,156 <strcmp+0x1e>
 144:	0005c703          	lbu	a4,0(a1)
 148:	00f71763          	bne	a4,a5,156 <strcmp+0x1e>
    p++, q++;
 14c:	0505                	add	a0,a0,1
 14e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 150:	00054783          	lbu	a5,0(a0)
 154:	fbe5                	bnez	a5,144 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 156:	0005c503          	lbu	a0,0(a1)
}
 15a:	40a7853b          	subw	a0,a5,a0
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	add	sp,sp,16
 162:	8082                	ret

0000000000000164 <strlen>:

uint
strlen(const char *s)
{
 164:	1141                	add	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x26>
 170:	0505                	add	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	add	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x10>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addw	a0,a0,1
    ;
  return n;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	add	sp,sp,16
 188:	8082                	ret
  for(n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strlen+0x20>

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	1141                	add	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 194:	ca19                	beqz	a2,1aa <memset+0x1c>
 196:	87aa                	mv	a5,a0
 198:	1602                	sll	a2,a2,0x20
 19a:	9201                	srl	a2,a2,0x20
 19c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a4:	0785                	add	a5,a5,1
 1a6:	fee79de3          	bne	a5,a4,1a0 <memset+0x12>
  }
  return dst;
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	add	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	1141                	add	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	add	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cb99                	beqz	a5,1d0 <strchr+0x20>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1a>
  for(; *s; s++)
 1c0:	0505                	add	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xc>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	add	sp,sp,16
 1ce:	8082                	ret
  return 0;
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strchr+0x1a>

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	711d                	add	sp,sp,-96
 1d6:	ec86                	sd	ra,88(sp)
 1d8:	e8a2                	sd	s0,80(sp)
 1da:	e4a6                	sd	s1,72(sp)
 1dc:	e0ca                	sd	s2,64(sp)
 1de:	fc4e                	sd	s3,56(sp)
 1e0:	f852                	sd	s4,48(sp)
 1e2:	f456                	sd	s5,40(sp)
 1e4:	f05a                	sd	s6,32(sp)
 1e6:	ec5e                	sd	s7,24(sp)
 1e8:	1080                	add	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f2:	4aa9                	li	s5,10
 1f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f6:	89a6                	mv	s3,s1
 1f8:	2485                	addw	s1,s1,1
 1fa:	0344d863          	bge	s1,s4,22a <gets+0x56>
    cc = read(0, &c, 1);
 1fe:	4605                	li	a2,1
 200:	faf40593          	add	a1,s0,-81
 204:	4501                	li	a0,0
 206:	00000097          	auipc	ra,0x0
 20a:	19a080e7          	jalr	410(ra) # 3a0 <read>
    if(cc < 1)
 20e:	00a05e63          	blez	a0,22a <gets+0x56>
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	01578763          	beq	a5,s5,228 <gets+0x54>
 21e:	0905                	add	s2,s2,1
 220:	fd679be3          	bne	a5,s6,1f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 224:	89a6                	mv	s3,s1
 226:	a011                	j	22a <gets+0x56>
 228:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22a:	99de                	add	s3,s3,s7
 22c:	00098023          	sb	zero,0(s3)
  return buf;
}
 230:	855e                	mv	a0,s7
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6125                	add	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	add	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e426                	sd	s1,8(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	add	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	00000097          	auipc	ra,0x0
 25c:	170080e7          	jalr	368(ra) # 3c8 <open>
  if(fd < 0)
 260:	02054563          	bltz	a0,28a <stat+0x42>
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	00000097          	auipc	ra,0x0
 26c:	178080e7          	jalr	376(ra) # 3e0 <fstat>
 270:	892a                	mv	s2,a0
  close(fd);
 272:	8526                	mv	a0,s1
 274:	00000097          	auipc	ra,0x0
 278:	13c080e7          	jalr	316(ra) # 3b0 <close>
  return r;
}
 27c:	854a                	mv	a0,s2
 27e:	60e2                	ld	ra,24(sp)
 280:	6442                	ld	s0,16(sp)
 282:	64a2                	ld	s1,8(sp)
 284:	6902                	ld	s2,0(sp)
 286:	6105                	add	sp,sp,32
 288:	8082                	ret
    return -1;
 28a:	597d                	li	s2,-1
 28c:	bfc5                	j	27c <stat+0x34>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	add	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	00054683          	lbu	a3,0(a0)
 298:	fd06879b          	addw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	4625                	li	a2,9
 2a2:	02f66863          	bltu	a2,a5,2d2 <atoi+0x44>
 2a6:	872a                	mv	a4,a0
  n = 0;
 2a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2aa:	0705                	add	a4,a4,1
 2ac:	0025179b          	sllw	a5,a0,0x2
 2b0:	9fa9                	addw	a5,a5,a0
 2b2:	0017979b          	sllw	a5,a5,0x1
 2b6:	9fb5                	addw	a5,a5,a3
 2b8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2bc:	00074683          	lbu	a3,0(a4)
 2c0:	fd06879b          	addw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	fef671e3          	bgeu	a2,a5,2aa <atoi+0x1c>
  return n;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	add	sp,sp,16
 2d0:	8082                	ret
  n = 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <atoi+0x3e>

00000000000002d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d6:	1141                	add	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2dc:	02b57463          	bgeu	a0,a1,304 <memmove+0x2e>
    while(n-- > 0)
 2e0:	00c05f63          	blez	a2,2fe <memmove+0x28>
 2e4:	1602                	sll	a2,a2,0x20
 2e6:	9201                	srl	a2,a2,0x20
 2e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ee:	0585                	add	a1,a1,1
 2f0:	0705                	add	a4,a4,1
 2f2:	fff5c683          	lbu	a3,-1(a1)
 2f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fa:	fee79ae3          	bne	a5,a4,2ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	add	sp,sp,16
 302:	8082                	ret
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30a:	fec05ae3          	blez	a2,2fe <memmove+0x28>
 30e:	fff6079b          	addw	a5,a2,-1
 312:	1782                	sll	a5,a5,0x20
 314:	9381                	srl	a5,a5,0x20
 316:	fff7c793          	not	a5,a5
 31a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31c:	15fd                	add	a1,a1,-1
 31e:	177d                	add	a4,a4,-1
 320:	0005c683          	lbu	a3,0(a1)
 324:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 328:	fee79ae3          	bne	a5,a4,31c <memmove+0x46>
 32c:	bfc9                	j	2fe <memmove+0x28>

000000000000032e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32e:	1141                	add	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ca05                	beqz	a2,364 <memcmp+0x36>
 336:	fff6069b          	addw	a3,a2,-1
 33a:	1682                	sll	a3,a3,0x20
 33c:	9281                	srl	a3,a3,0x20
 33e:	0685                	add	a3,a3,1
 340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	add	a0,a0,1
    p2++;
 350:	0585                	add	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x14>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x30>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	add	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <memcmp+0x30>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	add	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 370:	00000097          	auipc	ra,0x0
 374:	f66080e7          	jalr	-154(ra) # 2d6 <memmove>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	add	sp,sp,16
 37e:	8082                	ret

0000000000000380 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 380:	4885                	li	a7,1
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exit>:
.global exit
exit:
 li a7, SYS_exit
 388:	4889                	li	a7,2
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <wait>:
.global wait
wait:
 li a7, SYS_wait
 390:	488d                	li	a7,3
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 398:	4891                	li	a7,4
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <read>:
.global read
read:
 li a7, SYS_read
 3a0:	4895                	li	a7,5
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <write>:
.global write
write:
 li a7, SYS_write
 3a8:	48c1                	li	a7,16
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <close>:
.global close
close:
 li a7, SYS_close
 3b0:	48d5                	li	a7,21
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b8:	4899                	li	a7,6
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c0:	489d                	li	a7,7
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <open>:
.global open
open:
 li a7, SYS_open
 3c8:	48bd                	li	a7,15
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d0:	48c5                	li	a7,17
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d8:	48c9                	li	a7,18
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e0:	48a1                	li	a7,8
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <link>:
.global link
link:
 li a7, SYS_link
 3e8:	48cd                	li	a7,19
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f0:	48d1                	li	a7,20
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f8:	48a5                	li	a7,9
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <dup>:
.global dup
dup:
 li a7, SYS_dup
 400:	48a9                	li	a7,10
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 408:	48ad                	li	a7,11
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 410:	48b1                	li	a7,12
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 418:	48b5                	li	a7,13
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 420:	48b9                	li	a7,14
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 428:	1101                	add	sp,sp,-32
 42a:	ec06                	sd	ra,24(sp)
 42c:	e822                	sd	s0,16(sp)
 42e:	1000                	add	s0,sp,32
 430:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 434:	4605                	li	a2,1
 436:	fef40593          	add	a1,s0,-17
 43a:	00000097          	auipc	ra,0x0
 43e:	f6e080e7          	jalr	-146(ra) # 3a8 <write>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6105                	add	sp,sp,32
 448:	8082                	ret

000000000000044a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44a:	7139                	add	sp,sp,-64
 44c:	fc06                	sd	ra,56(sp)
 44e:	f822                	sd	s0,48(sp)
 450:	f426                	sd	s1,40(sp)
 452:	f04a                	sd	s2,32(sp)
 454:	ec4e                	sd	s3,24(sp)
 456:	0080                	add	s0,sp,64
 458:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45a:	c299                	beqz	a3,460 <printint+0x16>
 45c:	0805c963          	bltz	a1,4ee <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 460:	2581                	sext.w	a1,a1
  neg = 0;
 462:	4881                	li	a7,0
 464:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 468:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46a:	2601                	sext.w	a2,a2
 46c:	00000517          	auipc	a0,0x0
 470:	55450513          	add	a0,a0,1364 # 9c0 <digits>
 474:	883a                	mv	a6,a4
 476:	2705                	addw	a4,a4,1
 478:	02c5f7bb          	remuw	a5,a1,a2
 47c:	1782                	sll	a5,a5,0x20
 47e:	9381                	srl	a5,a5,0x20
 480:	97aa                	add	a5,a5,a0
 482:	0007c783          	lbu	a5,0(a5)
 486:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48a:	0005879b          	sext.w	a5,a1
 48e:	02c5d5bb          	divuw	a1,a1,a2
 492:	0685                	add	a3,a3,1
 494:	fec7f0e3          	bgeu	a5,a2,474 <printint+0x2a>
  if(neg)
 498:	00088c63          	beqz	a7,4b0 <printint+0x66>
    buf[i++] = '-';
 49c:	fd070793          	add	a5,a4,-48
 4a0:	00878733          	add	a4,a5,s0
 4a4:	02d00793          	li	a5,45
 4a8:	fef70823          	sb	a5,-16(a4)
 4ac:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4b0:	02e05863          	blez	a4,4e0 <printint+0x96>
 4b4:	fc040793          	add	a5,s0,-64
 4b8:	00e78933          	add	s2,a5,a4
 4bc:	fff78993          	add	s3,a5,-1
 4c0:	99ba                	add	s3,s3,a4
 4c2:	377d                	addw	a4,a4,-1
 4c4:	1702                	sll	a4,a4,0x20
 4c6:	9301                	srl	a4,a4,0x20
 4c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4cc:	fff94583          	lbu	a1,-1(s2)
 4d0:	8526                	mv	a0,s1
 4d2:	00000097          	auipc	ra,0x0
 4d6:	f56080e7          	jalr	-170(ra) # 428 <putc>
  while(--i >= 0)
 4da:	197d                	add	s2,s2,-1
 4dc:	ff3918e3          	bne	s2,s3,4cc <printint+0x82>
}
 4e0:	70e2                	ld	ra,56(sp)
 4e2:	7442                	ld	s0,48(sp)
 4e4:	74a2                	ld	s1,40(sp)
 4e6:	7902                	ld	s2,32(sp)
 4e8:	69e2                	ld	s3,24(sp)
 4ea:	6121                	add	sp,sp,64
 4ec:	8082                	ret
    x = -xx;
 4ee:	40b005bb          	negw	a1,a1
    neg = 1;
 4f2:	4885                	li	a7,1
    x = -xx;
 4f4:	bf85                	j	464 <printint+0x1a>

00000000000004f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f6:	715d                	add	sp,sp,-80
 4f8:	e486                	sd	ra,72(sp)
 4fa:	e0a2                	sd	s0,64(sp)
 4fc:	fc26                	sd	s1,56(sp)
 4fe:	f84a                	sd	s2,48(sp)
 500:	f44e                	sd	s3,40(sp)
 502:	f052                	sd	s4,32(sp)
 504:	ec56                	sd	s5,24(sp)
 506:	e85a                	sd	s6,16(sp)
 508:	e45e                	sd	s7,8(sp)
 50a:	e062                	sd	s8,0(sp)
 50c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c903          	lbu	s2,0(a1)
 512:	18090c63          	beqz	s2,6aa <vprintf+0x1b4>
 516:	8aaa                	mv	s5,a0
 518:	8bb2                	mv	s7,a2
 51a:	00158493          	add	s1,a1,1
  state = 0;
 51e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 520:	02500a13          	li	s4,37
 524:	4b55                	li	s6,21
 526:	a839                	j	544 <vprintf+0x4e>
        putc(fd, c);
 528:	85ca                	mv	a1,s2
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	efc080e7          	jalr	-260(ra) # 428 <putc>
 534:	a019                	j	53a <vprintf+0x44>
    } else if(state == '%'){
 536:	01498d63          	beq	s3,s4,550 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 53a:	0485                	add	s1,s1,1
 53c:	fff4c903          	lbu	s2,-1(s1)
 540:	16090563          	beqz	s2,6aa <vprintf+0x1b4>
    if(state == 0){
 544:	fe0999e3          	bnez	s3,536 <vprintf+0x40>
      if(c == '%'){
 548:	ff4910e3          	bne	s2,s4,528 <vprintf+0x32>
        state = '%';
 54c:	89d2                	mv	s3,s4
 54e:	b7f5                	j	53a <vprintf+0x44>
      if(c == 'd'){
 550:	13490263          	beq	s2,s4,674 <vprintf+0x17e>
 554:	f9d9079b          	addw	a5,s2,-99
 558:	0ff7f793          	zext.b	a5,a5
 55c:	12fb6563          	bltu	s6,a5,686 <vprintf+0x190>
 560:	f9d9079b          	addw	a5,s2,-99
 564:	0ff7f713          	zext.b	a4,a5
 568:	10eb6f63          	bltu	s6,a4,686 <vprintf+0x190>
 56c:	00271793          	sll	a5,a4,0x2
 570:	00000717          	auipc	a4,0x0
 574:	3f870713          	add	a4,a4,1016 # 968 <statistics+0xda>
 578:	97ba                	add	a5,a5,a4
 57a:	439c                	lw	a5,0(a5)
 57c:	97ba                	add	a5,a5,a4
 57e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b8913          	add	s2,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	ebc080e7          	jalr	-324(ra) # 44a <printint>
 596:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 598:	4981                	li	s3,0
 59a:	b745                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b8913          	add	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ea0080e7          	jalr	-352(ra) # 44a <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b751                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5b8:	008b8913          	add	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e84080e7          	jalr	-380(ra) # 44a <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b7a5                	j	53a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b8c13          	add	s8,s7,8
 5d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5dc:	03000593          	li	a1,48
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e46080e7          	jalr	-442(ra) # 428 <putc>
  putc(fd, 'x');
 5ea:	07800593          	li	a1,120
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e38080e7          	jalr	-456(ra) # 428 <putc>
 5f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	3c6b8b93          	add	s7,s7,966 # 9c0 <digits>
 602:	03c9d793          	srl	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e1a080e7          	jalr	-486(ra) # 428 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	sll	s3,s3,0x4
 618:	397d                	addw	s2,s2,-1
 61a:	fe0914e3          	bnez	s2,602 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 61e:	8be2                	mv	s7,s8
      state = 0;
 620:	4981                	li	s3,0
 622:	bf21                	j	53a <vprintf+0x44>
        s = va_arg(ap, char*);
 624:	008b8993          	add	s3,s7,8
 628:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 62c:	02090163          	beqz	s2,64e <vprintf+0x158>
        while(*s != 0){
 630:	00094583          	lbu	a1,0(s2)
 634:	c9a5                	beqz	a1,6a4 <vprintf+0x1ae>
          putc(fd, *s);
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	df0080e7          	jalr	-528(ra) # 428 <putc>
          s++;
 640:	0905                	add	s2,s2,1
        while(*s != 0){
 642:	00094583          	lbu	a1,0(s2)
 646:	f9e5                	bnez	a1,636 <vprintf+0x140>
        s = va_arg(ap, char*);
 648:	8bce                	mv	s7,s3
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b5fd                	j	53a <vprintf+0x44>
          s = "(null)";
 64e:	00000917          	auipc	s2,0x0
 652:	31290913          	add	s2,s2,786 # 960 <statistics+0xd2>
        while(*s != 0){
 656:	02800593          	li	a1,40
 65a:	bff1                	j	636 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 65c:	008b8913          	add	s2,s7,8
 660:	000bc583          	lbu	a1,0(s7)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	dc2080e7          	jalr	-574(ra) # 428 <putc>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b5e1                	j	53a <vprintf+0x44>
        putc(fd, c);
 674:	02500593          	li	a1,37
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	dae080e7          	jalr	-594(ra) # 428 <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	bd5d                	j	53a <vprintf+0x44>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	d9c080e7          	jalr	-612(ra) # 428 <putc>
        putc(fd, c);
 694:	85ca                	mv	a1,s2
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	d90080e7          	jalr	-624(ra) # 428 <putc>
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd61                	j	53a <vprintf+0x44>
        s = va_arg(ap, char*);
 6a4:	8bce                	mv	s7,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd49                	j	53a <vprintf+0x44>
    }
  }
}
 6aa:	60a6                	ld	ra,72(sp)
 6ac:	6406                	ld	s0,64(sp)
 6ae:	74e2                	ld	s1,56(sp)
 6b0:	7942                	ld	s2,48(sp)
 6b2:	79a2                	ld	s3,40(sp)
 6b4:	7a02                	ld	s4,32(sp)
 6b6:	6ae2                	ld	s5,24(sp)
 6b8:	6b42                	ld	s6,16(sp)
 6ba:	6ba2                	ld	s7,8(sp)
 6bc:	6c02                	ld	s8,0(sp)
 6be:	6161                	add	sp,sp,80
 6c0:	8082                	ret

00000000000006c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c2:	715d                	add	sp,sp,-80
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	add	s0,sp,32
 6ca:	e010                	sd	a2,0(s0)
 6cc:	e414                	sd	a3,8(s0)
 6ce:	e818                	sd	a4,16(s0)
 6d0:	ec1c                	sd	a5,24(s0)
 6d2:	03043023          	sd	a6,32(s0)
 6d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6de:	8622                	mv	a2,s0
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e16080e7          	jalr	-490(ra) # 4f6 <vprintf>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6161                	add	sp,sp,80
 6ee:	8082                	ret

00000000000006f0 <printf>:

void
printf(const char *fmt, ...)
{
 6f0:	711d                	add	sp,sp,-96
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	add	s0,sp,32
 6f8:	e40c                	sd	a1,8(s0)
 6fa:	e810                	sd	a2,16(s0)
 6fc:	ec14                	sd	a3,24(s0)
 6fe:	f018                	sd	a4,32(s0)
 700:	f41c                	sd	a5,40(s0)
 702:	03043823          	sd	a6,48(s0)
 706:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	00840613          	add	a2,s0,8
 70e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 712:	85aa                	mv	a1,a0
 714:	4505                	li	a0,1
 716:	00000097          	auipc	ra,0x0
 71a:	de0080e7          	jalr	-544(ra) # 4f6 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6125                	add	sp,sp,96
 724:	8082                	ret

0000000000000726 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	1141                	add	sp,sp,-16
 728:	e422                	sd	s0,8(sp)
 72a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00000797          	auipc	a5,0x0
 734:	2d07b783          	ld	a5,720(a5) # a00 <freep>
 738:	a02d                	j	762 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73a:	4618                	lw	a4,8(a2)
 73c:	9f2d                	addw	a4,a4,a1
 73e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	6398                	ld	a4,0(a5)
 744:	6310                	ld	a2,0(a4)
 746:	a83d                	j	784 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 748:	ff852703          	lw	a4,-8(a0)
 74c:	9f31                	addw	a4,a4,a2
 74e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 750:	ff053683          	ld	a3,-16(a0)
 754:	a091                	j	798 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	6398                	ld	a4,0(a5)
 758:	00e7e463          	bltu	a5,a4,760 <free+0x3a>
 75c:	00e6ea63          	bltu	a3,a4,770 <free+0x4a>
{
 760:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	fed7fae3          	bgeu	a5,a3,756 <free+0x30>
 766:	6398                	ld	a4,0(a5)
 768:	00e6e463          	bltu	a3,a4,770 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	fee7eae3          	bltu	a5,a4,760 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 770:	ff852583          	lw	a1,-8(a0)
 774:	6390                	ld	a2,0(a5)
 776:	02059813          	sll	a6,a1,0x20
 77a:	01c85713          	srl	a4,a6,0x1c
 77e:	9736                	add	a4,a4,a3
 780:	fae60de3          	beq	a2,a4,73a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 788:	4790                	lw	a2,8(a5)
 78a:	02061593          	sll	a1,a2,0x20
 78e:	01c5d713          	srl	a4,a1,0x1c
 792:	973e                	add	a4,a4,a5
 794:	fae68ae3          	beq	a3,a4,748 <free+0x22>
    p->s.ptr = bp->s.ptr;
 798:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79a:	00000717          	auipc	a4,0x0
 79e:	26f73323          	sd	a5,614(a4) # a00 <freep>
}
 7a2:	6422                	ld	s0,8(sp)
 7a4:	0141                	add	sp,sp,16
 7a6:	8082                	ret

00000000000007a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a8:	7139                	add	sp,sp,-64
 7aa:	fc06                	sd	ra,56(sp)
 7ac:	f822                	sd	s0,48(sp)
 7ae:	f426                	sd	s1,40(sp)
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
 7ba:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051493          	sll	s1,a0,0x20
 7c0:	9081                	srl	s1,s1,0x20
 7c2:	04bd                	add	s1,s1,15
 7c4:	8091                	srl	s1,s1,0x4
 7c6:	0014899b          	addw	s3,s1,1
 7ca:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7cc:	00000517          	auipc	a0,0x0
 7d0:	23453503          	ld	a0,564(a0) # a00 <freep>
 7d4:	c515                	beqz	a0,800 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	02977f63          	bgeu	a4,s1,818 <malloc+0x70>
  if(nu < 4096)
 7de:	8a4e                	mv	s4,s3
 7e0:	0009871b          	sext.w	a4,s3
 7e4:	6685                	lui	a3,0x1
 7e6:	00d77363          	bgeu	a4,a3,7ec <malloc+0x44>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00000917          	auipc	s2,0x0
 7f8:	20c90913          	add	s2,s2,524 # a00 <freep>
  if(p == (char*)-1)
 7fc:	5afd                	li	s5,-1
 7fe:	a895                	j	872 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 800:	00000797          	auipc	a5,0x0
 804:	40878793          	add	a5,a5,1032 # c08 <base>
 808:	00000717          	auipc	a4,0x0
 80c:	1ef73c23          	sd	a5,504(a4) # a00 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7e1                	j	7de <malloc+0x36>
      if(p->s.size == nunits)
 818:	02e48c63          	beq	s1,a4,850 <malloc+0xa8>
        p->s.size -= nunits;
 81c:	4137073b          	subw	a4,a4,s3
 820:	c798                	sw	a4,8(a5)
        p += p->s.size;
 822:	02071693          	sll	a3,a4,0x20
 826:	01c6d713          	srl	a4,a3,0x1c
 82a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 830:	00000717          	auipc	a4,0x0
 834:	1ca73823          	sd	a0,464(a4) # a00 <freep>
      return (void*)(p + 1);
 838:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 83c:	70e2                	ld	ra,56(sp)
 83e:	7442                	ld	s0,48(sp)
 840:	74a2                	ld	s1,40(sp)
 842:	7902                	ld	s2,32(sp)
 844:	69e2                	ld	s3,24(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	6121                	add	sp,sp,64
 84e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	e118                	sd	a4,0(a0)
 854:	bff1                	j	830 <malloc+0x88>
  hp->s.size = nu;
 856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85a:	0541                	add	a0,a0,16
 85c:	00000097          	auipc	ra,0x0
 860:	eca080e7          	jalr	-310(ra) # 726 <free>
  return freep;
 864:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 868:	d971                	beqz	a0,83c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	fa9775e3          	bgeu	a4,s1,818 <malloc+0x70>
    if(p == freep)
 872:	00093703          	ld	a4,0(s2)
 876:	853e                	mv	a0,a5
 878:	fef719e3          	bne	a4,a5,86a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 87c:	8552                	mv	a0,s4
 87e:	00000097          	auipc	ra,0x0
 882:	b92080e7          	jalr	-1134(ra) # 410 <sbrk>
  if(p == (char*)-1)
 886:	fd5518e3          	bne	a0,s5,856 <malloc+0xae>
        return 0;
 88a:	4501                	li	a0,0
 88c:	bf45                	j	83c <malloc+0x94>

000000000000088e <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 88e:	7179                	add	sp,sp,-48
 890:	f406                	sd	ra,40(sp)
 892:	f022                	sd	s0,32(sp)
 894:	ec26                	sd	s1,24(sp)
 896:	e84a                	sd	s2,16(sp)
 898:	e44e                	sd	s3,8(sp)
 89a:	e052                	sd	s4,0(sp)
 89c:	1800                	add	s0,sp,48
 89e:	8a2a                	mv	s4,a0
 8a0:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 8a2:	4581                	li	a1,0
 8a4:	00000517          	auipc	a0,0x0
 8a8:	13450513          	add	a0,a0,308 # 9d8 <digits+0x18>
 8ac:	00000097          	auipc	ra,0x0
 8b0:	b1c080e7          	jalr	-1252(ra) # 3c8 <open>
  if(fd < 0) {
 8b4:	04054263          	bltz	a0,8f8 <statistics+0x6a>
 8b8:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 8ba:	4481                	li	s1,0
 8bc:	03205063          	blez	s2,8dc <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 8c0:	4099063b          	subw	a2,s2,s1
 8c4:	009a05b3          	add	a1,s4,s1
 8c8:	854e                	mv	a0,s3
 8ca:	00000097          	auipc	ra,0x0
 8ce:	ad6080e7          	jalr	-1322(ra) # 3a0 <read>
 8d2:	00054563          	bltz	a0,8dc <statistics+0x4e>
      break;
    }
    i += n;
 8d6:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 8d8:	ff24c4e3          	blt	s1,s2,8c0 <statistics+0x32>
  }
  close(fd);
 8dc:	854e                	mv	a0,s3
 8de:	00000097          	auipc	ra,0x0
 8e2:	ad2080e7          	jalr	-1326(ra) # 3b0 <close>
  return i;
}
 8e6:	8526                	mv	a0,s1
 8e8:	70a2                	ld	ra,40(sp)
 8ea:	7402                	ld	s0,32(sp)
 8ec:	64e2                	ld	s1,24(sp)
 8ee:	6942                	ld	s2,16(sp)
 8f0:	69a2                	ld	s3,8(sp)
 8f2:	6a02                	ld	s4,0(sp)
 8f4:	6145                	add	sp,sp,48
 8f6:	8082                	ret
      fprintf(2, "stats: open failed\n");
 8f8:	00000597          	auipc	a1,0x0
 8fc:	0f058593          	add	a1,a1,240 # 9e8 <digits+0x28>
 900:	4509                	li	a0,2
 902:	00000097          	auipc	ra,0x0
 906:	dc0080e7          	jalr	-576(ra) # 6c2 <fprintf>
      exit(1);
 90a:	4505                	li	a0,1
 90c:	00000097          	auipc	ra,0x0
 910:	a7c080e7          	jalr	-1412(ra) # 388 <exit>
