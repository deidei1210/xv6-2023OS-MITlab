
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
  14:	95090913          	add	s2,s2,-1712 # 960 <buf>
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
  44:	85858593          	add	a1,a1,-1960 # 898 <malloc+0xe8>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	680080e7          	jalr	1664(ra) # 6ca <fprintf>
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
  72:	84258593          	add	a1,a1,-1982 # 8b0 <malloc+0x100>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	652080e7          	jalr	1618(ra) # 6ca <fprintf>
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
 100:	00000597          	auipc	a1,0x0
 104:	7c858593          	add	a1,a1,1992 # 8c8 <malloc+0x118>
 108:	4509                	li	a0,2
 10a:	00000097          	auipc	ra,0x0
 10e:	5c0080e7          	jalr	1472(ra) # 6ca <fprintf>
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

0000000000000428 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 428:	48d9                	li	a7,22
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	add	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	add	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	add	a1,s0,-17
 442:	00000097          	auipc	ra,0x0
 446:	f66080e7          	jalr	-154(ra) # 3a8 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	add	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 452:	7139                	add	sp,sp,-64
 454:	fc06                	sd	ra,56(sp)
 456:	f822                	sd	s0,48(sp)
 458:	f426                	sd	s1,40(sp)
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	0080                	add	s0,sp,64
 460:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 462:	c299                	beqz	a3,468 <printint+0x16>
 464:	0805c963          	bltz	a1,4f6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 468:	2581                	sext.w	a1,a1
  neg = 0;
 46a:	4881                	li	a7,0
 46c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 470:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 472:	2601                	sext.w	a2,a2
 474:	00000517          	auipc	a0,0x0
 478:	4cc50513          	add	a0,a0,1228 # 940 <digits>
 47c:	883a                	mv	a6,a4
 47e:	2705                	addw	a4,a4,1
 480:	02c5f7bb          	remuw	a5,a1,a2
 484:	1782                	sll	a5,a5,0x20
 486:	9381                	srl	a5,a5,0x20
 488:	97aa                	add	a5,a5,a0
 48a:	0007c783          	lbu	a5,0(a5)
 48e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 492:	0005879b          	sext.w	a5,a1
 496:	02c5d5bb          	divuw	a1,a1,a2
 49a:	0685                	add	a3,a3,1
 49c:	fec7f0e3          	bgeu	a5,a2,47c <printint+0x2a>
  if(neg)
 4a0:	00088c63          	beqz	a7,4b8 <printint+0x66>
    buf[i++] = '-';
 4a4:	fd070793          	add	a5,a4,-48
 4a8:	00878733          	add	a4,a5,s0
 4ac:	02d00793          	li	a5,45
 4b0:	fef70823          	sb	a5,-16(a4)
 4b4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4b8:	02e05863          	blez	a4,4e8 <printint+0x96>
 4bc:	fc040793          	add	a5,s0,-64
 4c0:	00e78933          	add	s2,a5,a4
 4c4:	fff78993          	add	s3,a5,-1
 4c8:	99ba                	add	s3,s3,a4
 4ca:	377d                	addw	a4,a4,-1
 4cc:	1702                	sll	a4,a4,0x20
 4ce:	9301                	srl	a4,a4,0x20
 4d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d4:	fff94583          	lbu	a1,-1(s2)
 4d8:	8526                	mv	a0,s1
 4da:	00000097          	auipc	ra,0x0
 4de:	f56080e7          	jalr	-170(ra) # 430 <putc>
  while(--i >= 0)
 4e2:	197d                	add	s2,s2,-1
 4e4:	ff3918e3          	bne	s2,s3,4d4 <printint+0x82>
}
 4e8:	70e2                	ld	ra,56(sp)
 4ea:	7442                	ld	s0,48(sp)
 4ec:	74a2                	ld	s1,40(sp)
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
 4f2:	6121                	add	sp,sp,64
 4f4:	8082                	ret
    x = -xx;
 4f6:	40b005bb          	negw	a1,a1
    neg = 1;
 4fa:	4885                	li	a7,1
    x = -xx;
 4fc:	bf85                	j	46c <printint+0x1a>

00000000000004fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fe:	715d                	add	sp,sp,-80
 500:	e486                	sd	ra,72(sp)
 502:	e0a2                	sd	s0,64(sp)
 504:	fc26                	sd	s1,56(sp)
 506:	f84a                	sd	s2,48(sp)
 508:	f44e                	sd	s3,40(sp)
 50a:	f052                	sd	s4,32(sp)
 50c:	ec56                	sd	s5,24(sp)
 50e:	e85a                	sd	s6,16(sp)
 510:	e45e                	sd	s7,8(sp)
 512:	e062                	sd	s8,0(sp)
 514:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c903          	lbu	s2,0(a1)
 51a:	18090c63          	beqz	s2,6b2 <vprintf+0x1b4>
 51e:	8aaa                	mv	s5,a0
 520:	8bb2                	mv	s7,a2
 522:	00158493          	add	s1,a1,1
  state = 0;
 526:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 528:	02500a13          	li	s4,37
 52c:	4b55                	li	s6,21
 52e:	a839                	j	54c <vprintf+0x4e>
        putc(fd, c);
 530:	85ca                	mv	a1,s2
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	efc080e7          	jalr	-260(ra) # 430 <putc>
 53c:	a019                	j	542 <vprintf+0x44>
    } else if(state == '%'){
 53e:	01498d63          	beq	s3,s4,558 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 542:	0485                	add	s1,s1,1
 544:	fff4c903          	lbu	s2,-1(s1)
 548:	16090563          	beqz	s2,6b2 <vprintf+0x1b4>
    if(state == 0){
 54c:	fe0999e3          	bnez	s3,53e <vprintf+0x40>
      if(c == '%'){
 550:	ff4910e3          	bne	s2,s4,530 <vprintf+0x32>
        state = '%';
 554:	89d2                	mv	s3,s4
 556:	b7f5                	j	542 <vprintf+0x44>
      if(c == 'd'){
 558:	13490263          	beq	s2,s4,67c <vprintf+0x17e>
 55c:	f9d9079b          	addw	a5,s2,-99
 560:	0ff7f793          	zext.b	a5,a5
 564:	12fb6563          	bltu	s6,a5,68e <vprintf+0x190>
 568:	f9d9079b          	addw	a5,s2,-99
 56c:	0ff7f713          	zext.b	a4,a5
 570:	10eb6f63          	bltu	s6,a4,68e <vprintf+0x190>
 574:	00271793          	sll	a5,a4,0x2
 578:	00000717          	auipc	a4,0x0
 57c:	37070713          	add	a4,a4,880 # 8e8 <malloc+0x138>
 580:	97ba                	add	a5,a5,a4
 582:	439c                	lw	a5,0(a5)
 584:	97ba                	add	a5,a5,a4
 586:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b8913          	add	s2,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	ebc080e7          	jalr	-324(ra) # 452 <printint>
 59e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b745                	j	542 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b8913          	add	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	ea0080e7          	jalr	-352(ra) # 452 <printint>
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b751                	j	542 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5c0:	008b8913          	add	s2,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e84080e7          	jalr	-380(ra) # 452 <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b7a5                	j	542 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5dc:	008b8c13          	add	s8,s7,8
 5e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e4:	03000593          	li	a1,48
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e46080e7          	jalr	-442(ra) # 430 <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e38080e7          	jalr	-456(ra) # 430 <putc>
 600:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000b97          	auipc	s7,0x0
 606:	33eb8b93          	add	s7,s7,830 # 940 <digits>
 60a:	03c9d793          	srl	a5,s3,0x3c
 60e:	97de                	add	a5,a5,s7
 610:	0007c583          	lbu	a1,0(a5)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e1a080e7          	jalr	-486(ra) # 430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61e:	0992                	sll	s3,s3,0x4
 620:	397d                	addw	s2,s2,-1
 622:	fe0914e3          	bnez	s2,60a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 626:	8be2                	mv	s7,s8
      state = 0;
 628:	4981                	li	s3,0
 62a:	bf21                	j	542 <vprintf+0x44>
        s = va_arg(ap, char*);
 62c:	008b8993          	add	s3,s7,8
 630:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 634:	02090163          	beqz	s2,656 <vprintf+0x158>
        while(*s != 0){
 638:	00094583          	lbu	a1,0(s2)
 63c:	c9a5                	beqz	a1,6ac <vprintf+0x1ae>
          putc(fd, *s);
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	df0080e7          	jalr	-528(ra) # 430 <putc>
          s++;
 648:	0905                	add	s2,s2,1
        while(*s != 0){
 64a:	00094583          	lbu	a1,0(s2)
 64e:	f9e5                	bnez	a1,63e <vprintf+0x140>
        s = va_arg(ap, char*);
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b5fd                	j	542 <vprintf+0x44>
          s = "(null)";
 656:	00000917          	auipc	s2,0x0
 65a:	28a90913          	add	s2,s2,650 # 8e0 <malloc+0x130>
        while(*s != 0){
 65e:	02800593          	li	a1,40
 662:	bff1                	j	63e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 664:	008b8913          	add	s2,s7,8
 668:	000bc583          	lbu	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dc2080e7          	jalr	-574(ra) # 430 <putc>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b5e1                	j	542 <vprintf+0x44>
        putc(fd, c);
 67c:	02500593          	li	a1,37
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	dae080e7          	jalr	-594(ra) # 430 <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd5d                	j	542 <vprintf+0x44>
        putc(fd, '%');
 68e:	02500593          	li	a1,37
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d9c080e7          	jalr	-612(ra) # 430 <putc>
        putc(fd, c);
 69c:	85ca                	mv	a1,s2
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	d90080e7          	jalr	-624(ra) # 430 <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bd61                	j	542 <vprintf+0x44>
        s = va_arg(ap, char*);
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bd49                	j	542 <vprintf+0x44>
    }
  }
}
 6b2:	60a6                	ld	ra,72(sp)
 6b4:	6406                	ld	s0,64(sp)
 6b6:	74e2                	ld	s1,56(sp)
 6b8:	7942                	ld	s2,48(sp)
 6ba:	79a2                	ld	s3,40(sp)
 6bc:	7a02                	ld	s4,32(sp)
 6be:	6ae2                	ld	s5,24(sp)
 6c0:	6b42                	ld	s6,16(sp)
 6c2:	6ba2                	ld	s7,8(sp)
 6c4:	6c02                	ld	s8,0(sp)
 6c6:	6161                	add	sp,sp,80
 6c8:	8082                	ret

00000000000006ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ca:	715d                	add	sp,sp,-80
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	add	s0,sp,32
 6d2:	e010                	sd	a2,0(s0)
 6d4:	e414                	sd	a3,8(s0)
 6d6:	e818                	sd	a4,16(s0)
 6d8:	ec1c                	sd	a5,24(s0)
 6da:	03043023          	sd	a6,32(s0)
 6de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	8622                	mv	a2,s0
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e16080e7          	jalr	-490(ra) # 4fe <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6161                	add	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <printf>:

void
printf(const char *fmt, ...)
{
 6f8:	711d                	add	sp,sp,-96
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	add	s0,sp,32
 700:	e40c                	sd	a1,8(s0)
 702:	e810                	sd	a2,16(s0)
 704:	ec14                	sd	a3,24(s0)
 706:	f018                	sd	a4,32(s0)
 708:	f41c                	sd	a5,40(s0)
 70a:	03043823          	sd	a6,48(s0)
 70e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	00840613          	add	a2,s0,8
 716:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71a:	85aa                	mv	a1,a0
 71c:	4505                	li	a0,1
 71e:	00000097          	auipc	ra,0x0
 722:	de0080e7          	jalr	-544(ra) # 4fe <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6125                	add	sp,sp,96
 72c:	8082                	ret

000000000000072e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72e:	1141                	add	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 734:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	00000797          	auipc	a5,0x0
 73c:	2207b783          	ld	a5,544(a5) # 958 <freep>
 740:	a02d                	j	76a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 742:	4618                	lw	a4,8(a2)
 744:	9f2d                	addw	a4,a4,a1
 746:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74a:	6398                	ld	a4,0(a5)
 74c:	6310                	ld	a2,0(a4)
 74e:	a83d                	j	78c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 750:	ff852703          	lw	a4,-8(a0)
 754:	9f31                	addw	a4,a4,a2
 756:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 758:	ff053683          	ld	a3,-16(a0)
 75c:	a091                	j	7a0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	6398                	ld	a4,0(a5)
 760:	00e7e463          	bltu	a5,a4,768 <free+0x3a>
 764:	00e6ea63          	bltu	a3,a4,778 <free+0x4a>
{
 768:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	fed7fae3          	bgeu	a5,a3,75e <free+0x30>
 76e:	6398                	ld	a4,0(a5)
 770:	00e6e463          	bltu	a3,a4,778 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	fee7eae3          	bltu	a5,a4,768 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 778:	ff852583          	lw	a1,-8(a0)
 77c:	6390                	ld	a2,0(a5)
 77e:	02059813          	sll	a6,a1,0x20
 782:	01c85713          	srl	a4,a6,0x1c
 786:	9736                	add	a4,a4,a3
 788:	fae60de3          	beq	a2,a4,742 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 790:	4790                	lw	a2,8(a5)
 792:	02061593          	sll	a1,a2,0x20
 796:	01c5d713          	srl	a4,a1,0x1c
 79a:	973e                	add	a4,a4,a5
 79c:	fae68ae3          	beq	a3,a4,750 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a2:	00000717          	auipc	a4,0x0
 7a6:	1af73b23          	sd	a5,438(a4) # 958 <freep>
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	add	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	7139                	add	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	f426                	sd	s1,40(sp)
 7b8:	f04a                	sd	s2,32(sp)
 7ba:	ec4e                	sd	s3,24(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
 7c2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	02051493          	sll	s1,a0,0x20
 7c8:	9081                	srl	s1,s1,0x20
 7ca:	04bd                	add	s1,s1,15
 7cc:	8091                	srl	s1,s1,0x4
 7ce:	0014899b          	addw	s3,s1,1
 7d2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7d4:	00000517          	auipc	a0,0x0
 7d8:	18453503          	ld	a0,388(a0) # 958 <freep>
 7dc:	c515                	beqz	a0,808 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e0:	4798                	lw	a4,8(a5)
 7e2:	02977f63          	bgeu	a4,s1,820 <malloc+0x70>
  if(nu < 4096)
 7e6:	8a4e                	mv	s4,s3
 7e8:	0009871b          	sext.w	a4,s3
 7ec:	6685                	lui	a3,0x1
 7ee:	00d77363          	bgeu	a4,a3,7f4 <malloc+0x44>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00000917          	auipc	s2,0x0
 800:	15c90913          	add	s2,s2,348 # 958 <freep>
  if(p == (char*)-1)
 804:	5afd                	li	s5,-1
 806:	a895                	j	87a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 808:	00000797          	auipc	a5,0x0
 80c:	35878793          	add	a5,a5,856 # b60 <base>
 810:	00000717          	auipc	a4,0x0
 814:	14f73423          	sd	a5,328(a4) # 958 <freep>
 818:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81e:	b7e1                	j	7e6 <malloc+0x36>
      if(p->s.size == nunits)
 820:	02e48c63          	beq	s1,a4,858 <malloc+0xa8>
        p->s.size -= nunits;
 824:	4137073b          	subw	a4,a4,s3
 828:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82a:	02071693          	sll	a3,a4,0x20
 82e:	01c6d713          	srl	a4,a3,0x1c
 832:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 834:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 838:	00000717          	auipc	a4,0x0
 83c:	12a73023          	sd	a0,288(a4) # 958 <freep>
      return (void*)(p + 1);
 840:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 844:	70e2                	ld	ra,56(sp)
 846:	7442                	ld	s0,48(sp)
 848:	74a2                	ld	s1,40(sp)
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
 854:	6121                	add	sp,sp,64
 856:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	bff1                	j	838 <malloc+0x88>
  hp->s.size = nu;
 85e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 862:	0541                	add	a0,a0,16
 864:	00000097          	auipc	ra,0x0
 868:	eca080e7          	jalr	-310(ra) # 72e <free>
  return freep;
 86c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 870:	d971                	beqz	a0,844 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	fa9775e3          	bgeu	a4,s1,820 <malloc+0x70>
    if(p == freep)
 87a:	00093703          	ld	a4,0(s2)
 87e:	853e                	mv	a0,a5
 880:	fef719e3          	bne	a4,a5,872 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 884:	8552                	mv	a0,s4
 886:	00000097          	auipc	ra,0x0
 88a:	b8a080e7          	jalr	-1142(ra) # 410 <sbrk>
  if(p == (char*)-1)
 88e:	fd5518e3          	bne	a0,s5,85e <malloc+0xae>
        return 0;
 892:	4501                	li	a0,0
 894:	bf45                	j	844 <malloc+0x94>
