
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	712d                	add	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	e626                	sd	s1,264(sp)
   8:	e24a                	sd	s2,256(sp)
   a:	1200                	add	s0,sp,288
   c:	892e                	mv	s2,a1
  int i;
  char *nargv[MAXARG];

  if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
   e:	4789                	li	a5,2
  10:	00a7dd63          	bge	a5,a0,2a <main+0x2a>
  14:	84aa                	mv	s1,a0
  16:	6588                	ld	a0,8(a1)
  18:	00054783          	lbu	a5,0(a0)
  1c:	fd07879b          	addw	a5,a5,-48
  20:	0ff7f793          	zext.b	a5,a5
  24:	4725                	li	a4,9
  26:	02f77263          	bgeu	a4,a5,4a <main+0x4a>
    fprintf(2, "Usage: %s mask command\n", argv[0]);
  2a:	00093603          	ld	a2,0(s2)
  2e:	00001597          	auipc	a1,0x1
  32:	81a58593          	add	a1,a1,-2022 # 848 <malloc+0xec>
  36:	4509                	li	a0,2
  38:	00000097          	auipc	ra,0x0
  3c:	63e080e7          	jalr	1598(ra) # 676 <fprintf>
    exit(1);
  40:	4505                	li	a0,1
  42:	00000097          	auipc	ra,0x0
  46:	2ea080e7          	jalr	746(ra) # 32c <exit>
  }

  if (trace(atoi(argv[1])) < 0) {
  4a:	00000097          	auipc	ra,0x0
  4e:	1e8080e7          	jalr	488(ra) # 232 <atoi>
  52:	00000097          	auipc	ra,0x0
  56:	37a080e7          	jalr	890(ra) # 3cc <trace>
  5a:	04054363          	bltz	a0,a0 <main+0xa0>
  5e:	01090793          	add	a5,s2,16
  62:	ee040713          	add	a4,s0,-288
  66:	34f5                	addw	s1,s1,-3
  68:	02049693          	sll	a3,s1,0x20
  6c:	01d6d493          	srl	s1,a3,0x1d
  70:	94be                	add	s1,s1,a5
  72:	10090593          	add	a1,s2,256
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }
  
  for(i = 2; i < argc && i < MAXARG; i++){
    nargv[i-2] = argv[i];
  76:	6394                	ld	a3,0(a5)
  78:	e314                	sd	a3,0(a4)
  for(i = 2; i < argc && i < MAXARG; i++){
  7a:	00978663          	beq	a5,s1,86 <main+0x86>
  7e:	07a1                	add	a5,a5,8
  80:	0721                	add	a4,a4,8
  82:	feb79ae3          	bne	a5,a1,76 <main+0x76>
  }
  exec(nargv[0], nargv);
  86:	ee040593          	add	a1,s0,-288
  8a:	ee043503          	ld	a0,-288(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	2d6080e7          	jalr	726(ra) # 364 <exec>
  exit(0);
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	294080e7          	jalr	660(ra) # 32c <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  a0:	00093603          	ld	a2,0(s2)
  a4:	00000597          	auipc	a1,0x0
  a8:	7bc58593          	add	a1,a1,1980 # 860 <malloc+0x104>
  ac:	4509                	li	a0,2
  ae:	00000097          	auipc	ra,0x0
  b2:	5c8080e7          	jalr	1480(ra) # 676 <fprintf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	274080e7          	jalr	628(ra) # 32c <exit>

00000000000000c0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  c0:	1141                	add	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c6:	87aa                	mv	a5,a0
  c8:	0585                	add	a1,a1,1
  ca:	0785                	add	a5,a5,1
  cc:	fff5c703          	lbu	a4,-1(a1)
  d0:	fee78fa3          	sb	a4,-1(a5)
  d4:	fb75                	bnez	a4,c8 <strcpy+0x8>
    ;
  return os;
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	add	sp,sp,16
  da:	8082                	ret

00000000000000dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dc:	1141                	add	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cb91                	beqz	a5,fa <strcmp+0x1e>
  e8:	0005c703          	lbu	a4,0(a1)
  ec:	00f71763          	bne	a4,a5,fa <strcmp+0x1e>
    p++, q++;
  f0:	0505                	add	a0,a0,1
  f2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	fbe5                	bnez	a5,e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  fa:	0005c503          	lbu	a0,0(a1)
}
  fe:	40a7853b          	subw	a0,a5,a0
 102:	6422                	ld	s0,8(sp)
 104:	0141                	add	sp,sp,16
 106:	8082                	ret

0000000000000108 <strlen>:

uint
strlen(const char *s)
{
 108:	1141                	add	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cf91                	beqz	a5,12e <strlen+0x26>
 114:	0505                	add	a0,a0,1
 116:	87aa                	mv	a5,a0
 118:	86be                	mv	a3,a5
 11a:	0785                	add	a5,a5,1
 11c:	fff7c703          	lbu	a4,-1(a5)
 120:	ff65                	bnez	a4,118 <strlen+0x10>
 122:	40a6853b          	subw	a0,a3,a0
 126:	2505                	addw	a0,a0,1
    ;
  return n;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	add	sp,sp,16
 12c:	8082                	ret
  for(n = 0; s[n]; n++)
 12e:	4501                	li	a0,0
 130:	bfe5                	j	128 <strlen+0x20>

0000000000000132 <memset>:

void*
memset(void *dst, int c, uint n)
{
 132:	1141                	add	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 138:	ca19                	beqz	a2,14e <memset+0x1c>
 13a:	87aa                	mv	a5,a0
 13c:	1602                	sll	a2,a2,0x20
 13e:	9201                	srl	a2,a2,0x20
 140:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 144:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 148:	0785                	add	a5,a5,1
 14a:	fee79de3          	bne	a5,a4,144 <memset+0x12>
  }
  return dst;
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	add	sp,sp,16
 152:	8082                	ret

0000000000000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	1141                	add	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	add	s0,sp,16
  for(; *s; s++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cb99                	beqz	a5,174 <strchr+0x20>
    if(*s == c)
 160:	00f58763          	beq	a1,a5,16e <strchr+0x1a>
  for(; *s; s++)
 164:	0505                	add	a0,a0,1
 166:	00054783          	lbu	a5,0(a0)
 16a:	fbfd                	bnez	a5,160 <strchr+0xc>
      return (char*)s;
  return 0;
 16c:	4501                	li	a0,0
}
 16e:	6422                	ld	s0,8(sp)
 170:	0141                	add	sp,sp,16
 172:	8082                	ret
  return 0;
 174:	4501                	li	a0,0
 176:	bfe5                	j	16e <strchr+0x1a>

0000000000000178 <gets>:

char*
gets(char *buf, int max)
{
 178:	711d                	add	sp,sp,-96
 17a:	ec86                	sd	ra,88(sp)
 17c:	e8a2                	sd	s0,80(sp)
 17e:	e4a6                	sd	s1,72(sp)
 180:	e0ca                	sd	s2,64(sp)
 182:	fc4e                	sd	s3,56(sp)
 184:	f852                	sd	s4,48(sp)
 186:	f456                	sd	s5,40(sp)
 188:	f05a                	sd	s6,32(sp)
 18a:	ec5e                	sd	s7,24(sp)
 18c:	1080                	add	s0,sp,96
 18e:	8baa                	mv	s7,a0
 190:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 192:	892a                	mv	s2,a0
 194:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 196:	4aa9                	li	s5,10
 198:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 19a:	89a6                	mv	s3,s1
 19c:	2485                	addw	s1,s1,1
 19e:	0344d863          	bge	s1,s4,1ce <gets+0x56>
    cc = read(0, &c, 1);
 1a2:	4605                	li	a2,1
 1a4:	faf40593          	add	a1,s0,-81
 1a8:	4501                	li	a0,0
 1aa:	00000097          	auipc	ra,0x0
 1ae:	19a080e7          	jalr	410(ra) # 344 <read>
    if(cc < 1)
 1b2:	00a05e63          	blez	a0,1ce <gets+0x56>
    buf[i++] = c;
 1b6:	faf44783          	lbu	a5,-81(s0)
 1ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1be:	01578763          	beq	a5,s5,1cc <gets+0x54>
 1c2:	0905                	add	s2,s2,1
 1c4:	fd679be3          	bne	a5,s6,19a <gets+0x22>
  for(i=0; i+1 < max; ){
 1c8:	89a6                	mv	s3,s1
 1ca:	a011                	j	1ce <gets+0x56>
 1cc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ce:	99de                	add	s3,s3,s7
 1d0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d4:	855e                	mv	a0,s7
 1d6:	60e6                	ld	ra,88(sp)
 1d8:	6446                	ld	s0,80(sp)
 1da:	64a6                	ld	s1,72(sp)
 1dc:	6906                	ld	s2,64(sp)
 1de:	79e2                	ld	s3,56(sp)
 1e0:	7a42                	ld	s4,48(sp)
 1e2:	7aa2                	ld	s5,40(sp)
 1e4:	7b02                	ld	s6,32(sp)
 1e6:	6be2                	ld	s7,24(sp)
 1e8:	6125                	add	sp,sp,96
 1ea:	8082                	ret

00000000000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	1101                	add	sp,sp,-32
 1ee:	ec06                	sd	ra,24(sp)
 1f0:	e822                	sd	s0,16(sp)
 1f2:	e426                	sd	s1,8(sp)
 1f4:	e04a                	sd	s2,0(sp)
 1f6:	1000                	add	s0,sp,32
 1f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	4581                	li	a1,0
 1fc:	00000097          	auipc	ra,0x0
 200:	170080e7          	jalr	368(ra) # 36c <open>
  if(fd < 0)
 204:	02054563          	bltz	a0,22e <stat+0x42>
 208:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20a:	85ca                	mv	a1,s2
 20c:	00000097          	auipc	ra,0x0
 210:	178080e7          	jalr	376(ra) # 384 <fstat>
 214:	892a                	mv	s2,a0
  close(fd);
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	13c080e7          	jalr	316(ra) # 354 <close>
  return r;
}
 220:	854a                	mv	a0,s2
 222:	60e2                	ld	ra,24(sp)
 224:	6442                	ld	s0,16(sp)
 226:	64a2                	ld	s1,8(sp)
 228:	6902                	ld	s2,0(sp)
 22a:	6105                	add	sp,sp,32
 22c:	8082                	ret
    return -1;
 22e:	597d                	li	s2,-1
 230:	bfc5                	j	220 <stat+0x34>

0000000000000232 <atoi>:

int
atoi(const char *s)
{
 232:	1141                	add	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 238:	00054683          	lbu	a3,0(a0)
 23c:	fd06879b          	addw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	4625                	li	a2,9
 246:	02f66863          	bltu	a2,a5,276 <atoi+0x44>
 24a:	872a                	mv	a4,a0
  n = 0;
 24c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24e:	0705                	add	a4,a4,1
 250:	0025179b          	sllw	a5,a0,0x2
 254:	9fa9                	addw	a5,a5,a0
 256:	0017979b          	sllw	a5,a5,0x1
 25a:	9fb5                	addw	a5,a5,a3
 25c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 260:	00074683          	lbu	a3,0(a4)
 264:	fd06879b          	addw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	fef671e3          	bgeu	a2,a5,24e <atoi+0x1c>
  return n;
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	add	sp,sp,16
 274:	8082                	ret
  n = 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <atoi+0x3e>

000000000000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	add	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 280:	02b57463          	bgeu	a0,a1,2a8 <memmove+0x2e>
    while(n-- > 0)
 284:	00c05f63          	blez	a2,2a2 <memmove+0x28>
 288:	1602                	sll	a2,a2,0x20
 28a:	9201                	srl	a2,a2,0x20
 28c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 290:	872a                	mv	a4,a0
      *dst++ = *src++;
 292:	0585                	add	a1,a1,1
 294:	0705                	add	a4,a4,1
 296:	fff5c683          	lbu	a3,-1(a1)
 29a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	add	sp,sp,16
 2a6:	8082                	ret
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ae:	fec05ae3          	blez	a2,2a2 <memmove+0x28>
 2b2:	fff6079b          	addw	a5,a2,-1
 2b6:	1782                	sll	a5,a5,0x20
 2b8:	9381                	srl	a5,a5,0x20
 2ba:	fff7c793          	not	a5,a5
 2be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c0:	15fd                	add	a1,a1,-1
 2c2:	177d                	add	a4,a4,-1
 2c4:	0005c683          	lbu	a3,0(a1)
 2c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x46>
 2d0:	bfc9                	j	2a2 <memmove+0x28>

00000000000002d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d2:	1141                	add	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d8:	ca05                	beqz	a2,308 <memcmp+0x36>
 2da:	fff6069b          	addw	a3,a2,-1
 2de:	1682                	sll	a3,a3,0x20
 2e0:	9281                	srl	a3,a3,0x20
 2e2:	0685                	add	a3,a3,1
 2e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00e79863          	bne	a5,a4,2fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f2:	0505                	add	a0,a0,1
    p2++;
 2f4:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2f6:	fed518e3          	bne	a0,a3,2e6 <memcmp+0x14>
  }
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	a019                	j	302 <memcmp+0x30>
      return *p1 - *p2;
 2fe:	40e7853b          	subw	a0,a5,a4
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	add	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <memcmp+0x30>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 314:	00000097          	auipc	ra,0x0
 318:	f66080e7          	jalr	-154(ra) # 27a <memmove>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret

0000000000000324 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 324:	4885                	li	a7,1
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exit>:
.global exit
exit:
 li a7, SYS_exit
 32c:	4889                	li	a7,2
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <wait>:
.global wait
wait:
 li a7, SYS_wait
 334:	488d                	li	a7,3
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33c:	4891                	li	a7,4
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <read>:
.global read
read:
 li a7, SYS_read
 344:	4895                	li	a7,5
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <write>:
.global write
write:
 li a7, SYS_write
 34c:	48c1                	li	a7,16
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <close>:
.global close
close:
 li a7, SYS_close
 354:	48d5                	li	a7,21
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <kill>:
.global kill
kill:
 li a7, SYS_kill
 35c:	4899                	li	a7,6
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exec>:
.global exec
exec:
 li a7, SYS_exec
 364:	489d                	li	a7,7
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <open>:
.global open
open:
 li a7, SYS_open
 36c:	48bd                	li	a7,15
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 374:	48c5                	li	a7,17
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37c:	48c9                	li	a7,18
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 384:	48a1                	li	a7,8
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <link>:
.global link
link:
 li a7, SYS_link
 38c:	48cd                	li	a7,19
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 394:	48d1                	li	a7,20
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39c:	48a5                	li	a7,9
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a4:	48a9                	li	a7,10
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ac:	48ad                	li	a7,11
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b4:	48b1                	li	a7,12
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3bc:	48b5                	li	a7,13
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c4:	48b9                	li	a7,14
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <trace>:
.global trace
trace:
 li a7, SYS_trace
 3cc:	48d9                	li	a7,22
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3d4:	48dd                	li	a7,23
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3dc:	1101                	add	sp,sp,-32
 3de:	ec06                	sd	ra,24(sp)
 3e0:	e822                	sd	s0,16(sp)
 3e2:	1000                	add	s0,sp,32
 3e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e8:	4605                	li	a2,1
 3ea:	fef40593          	add	a1,s0,-17
 3ee:	00000097          	auipc	ra,0x0
 3f2:	f5e080e7          	jalr	-162(ra) # 34c <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	add	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	7139                	add	sp,sp,-64
 400:	fc06                	sd	ra,56(sp)
 402:	f822                	sd	s0,48(sp)
 404:	f426                	sd	s1,40(sp)
 406:	f04a                	sd	s2,32(sp)
 408:	ec4e                	sd	s3,24(sp)
 40a:	0080                	add	s0,sp,64
 40c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40e:	c299                	beqz	a3,414 <printint+0x16>
 410:	0805c963          	bltz	a1,4a2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 414:	2581                	sext.w	a1,a1
  neg = 0;
 416:	4881                	li	a7,0
 418:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 41c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41e:	2601                	sext.w	a2,a2
 420:	00000517          	auipc	a0,0x0
 424:	4b850513          	add	a0,a0,1208 # 8d8 <digits>
 428:	883a                	mv	a6,a4
 42a:	2705                	addw	a4,a4,1
 42c:	02c5f7bb          	remuw	a5,a1,a2
 430:	1782                	sll	a5,a5,0x20
 432:	9381                	srl	a5,a5,0x20
 434:	97aa                	add	a5,a5,a0
 436:	0007c783          	lbu	a5,0(a5)
 43a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43e:	0005879b          	sext.w	a5,a1
 442:	02c5d5bb          	divuw	a1,a1,a2
 446:	0685                	add	a3,a3,1
 448:	fec7f0e3          	bgeu	a5,a2,428 <printint+0x2a>
  if(neg)
 44c:	00088c63          	beqz	a7,464 <printint+0x66>
    buf[i++] = '-';
 450:	fd070793          	add	a5,a4,-48
 454:	00878733          	add	a4,a5,s0
 458:	02d00793          	li	a5,45
 45c:	fef70823          	sb	a5,-16(a4)
 460:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 464:	02e05863          	blez	a4,494 <printint+0x96>
 468:	fc040793          	add	a5,s0,-64
 46c:	00e78933          	add	s2,a5,a4
 470:	fff78993          	add	s3,a5,-1
 474:	99ba                	add	s3,s3,a4
 476:	377d                	addw	a4,a4,-1
 478:	1702                	sll	a4,a4,0x20
 47a:	9301                	srl	a4,a4,0x20
 47c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 480:	fff94583          	lbu	a1,-1(s2)
 484:	8526                	mv	a0,s1
 486:	00000097          	auipc	ra,0x0
 48a:	f56080e7          	jalr	-170(ra) # 3dc <putc>
  while(--i >= 0)
 48e:	197d                	add	s2,s2,-1
 490:	ff3918e3          	bne	s2,s3,480 <printint+0x82>
}
 494:	70e2                	ld	ra,56(sp)
 496:	7442                	ld	s0,48(sp)
 498:	74a2                	ld	s1,40(sp)
 49a:	7902                	ld	s2,32(sp)
 49c:	69e2                	ld	s3,24(sp)
 49e:	6121                	add	sp,sp,64
 4a0:	8082                	ret
    x = -xx;
 4a2:	40b005bb          	negw	a1,a1
    neg = 1;
 4a6:	4885                	li	a7,1
    x = -xx;
 4a8:	bf85                	j	418 <printint+0x1a>

00000000000004aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4aa:	715d                	add	sp,sp,-80
 4ac:	e486                	sd	ra,72(sp)
 4ae:	e0a2                	sd	s0,64(sp)
 4b0:	fc26                	sd	s1,56(sp)
 4b2:	f84a                	sd	s2,48(sp)
 4b4:	f44e                	sd	s3,40(sp)
 4b6:	f052                	sd	s4,32(sp)
 4b8:	ec56                	sd	s5,24(sp)
 4ba:	e85a                	sd	s6,16(sp)
 4bc:	e45e                	sd	s7,8(sp)
 4be:	e062                	sd	s8,0(sp)
 4c0:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c2:	0005c903          	lbu	s2,0(a1)
 4c6:	18090c63          	beqz	s2,65e <vprintf+0x1b4>
 4ca:	8aaa                	mv	s5,a0
 4cc:	8bb2                	mv	s7,a2
 4ce:	00158493          	add	s1,a1,1
  state = 0;
 4d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d4:	02500a13          	li	s4,37
 4d8:	4b55                	li	s6,21
 4da:	a839                	j	4f8 <vprintf+0x4e>
        putc(fd, c);
 4dc:	85ca                	mv	a1,s2
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	efc080e7          	jalr	-260(ra) # 3dc <putc>
 4e8:	a019                	j	4ee <vprintf+0x44>
    } else if(state == '%'){
 4ea:	01498d63          	beq	s3,s4,504 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4ee:	0485                	add	s1,s1,1
 4f0:	fff4c903          	lbu	s2,-1(s1)
 4f4:	16090563          	beqz	s2,65e <vprintf+0x1b4>
    if(state == 0){
 4f8:	fe0999e3          	bnez	s3,4ea <vprintf+0x40>
      if(c == '%'){
 4fc:	ff4910e3          	bne	s2,s4,4dc <vprintf+0x32>
        state = '%';
 500:	89d2                	mv	s3,s4
 502:	b7f5                	j	4ee <vprintf+0x44>
      if(c == 'd'){
 504:	13490263          	beq	s2,s4,628 <vprintf+0x17e>
 508:	f9d9079b          	addw	a5,s2,-99
 50c:	0ff7f793          	zext.b	a5,a5
 510:	12fb6563          	bltu	s6,a5,63a <vprintf+0x190>
 514:	f9d9079b          	addw	a5,s2,-99
 518:	0ff7f713          	zext.b	a4,a5
 51c:	10eb6f63          	bltu	s6,a4,63a <vprintf+0x190>
 520:	00271793          	sll	a5,a4,0x2
 524:	00000717          	auipc	a4,0x0
 528:	35c70713          	add	a4,a4,860 # 880 <malloc+0x124>
 52c:	97ba                	add	a5,a5,a4
 52e:	439c                	lw	a5,0(a5)
 530:	97ba                	add	a5,a5,a4
 532:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b8913          	add	s2,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	ebc080e7          	jalr	-324(ra) # 3fe <printint>
 54a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b745                	j	4ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	008b8913          	add	s2,s7,8
 554:	4681                	li	a3,0
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ea0080e7          	jalr	-352(ra) # 3fe <printint>
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	b751                	j	4ee <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 56c:	008b8913          	add	s2,s7,8
 570:	4681                	li	a3,0
 572:	4641                	li	a2,16
 574:	000ba583          	lw	a1,0(s7)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e84080e7          	jalr	-380(ra) # 3fe <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b7a5                	j	4ee <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 588:	008b8c13          	add	s8,s7,8
 58c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 590:	03000593          	li	a1,48
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e46080e7          	jalr	-442(ra) # 3dc <putc>
  putc(fd, 'x');
 59e:	07800593          	li	a1,120
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e38080e7          	jalr	-456(ra) # 3dc <putc>
 5ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	00000b97          	auipc	s7,0x0
 5b2:	32ab8b93          	add	s7,s7,810 # 8d8 <digits>
 5b6:	03c9d793          	srl	a5,s3,0x3c
 5ba:	97de                	add	a5,a5,s7
 5bc:	0007c583          	lbu	a1,0(a5)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e1a080e7          	jalr	-486(ra) # 3dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ca:	0992                	sll	s3,s3,0x4
 5cc:	397d                	addw	s2,s2,-1
 5ce:	fe0914e3          	bnez	s2,5b6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5d2:	8be2                	mv	s7,s8
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bf21                	j	4ee <vprintf+0x44>
        s = va_arg(ap, char*);
 5d8:	008b8993          	add	s3,s7,8
 5dc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5e0:	02090163          	beqz	s2,602 <vprintf+0x158>
        while(*s != 0){
 5e4:	00094583          	lbu	a1,0(s2)
 5e8:	c9a5                	beqz	a1,658 <vprintf+0x1ae>
          putc(fd, *s);
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	df0080e7          	jalr	-528(ra) # 3dc <putc>
          s++;
 5f4:	0905                	add	s2,s2,1
        while(*s != 0){
 5f6:	00094583          	lbu	a1,0(s2)
 5fa:	f9e5                	bnez	a1,5ea <vprintf+0x140>
        s = va_arg(ap, char*);
 5fc:	8bce                	mv	s7,s3
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b5fd                	j	4ee <vprintf+0x44>
          s = "(null)";
 602:	00000917          	auipc	s2,0x0
 606:	27690913          	add	s2,s2,630 # 878 <malloc+0x11c>
        while(*s != 0){
 60a:	02800593          	li	a1,40
 60e:	bff1                	j	5ea <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 610:	008b8913          	add	s2,s7,8
 614:	000bc583          	lbu	a1,0(s7)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dc2080e7          	jalr	-574(ra) # 3dc <putc>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b5e1                	j	4ee <vprintf+0x44>
        putc(fd, c);
 628:	02500593          	li	a1,37
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	dae080e7          	jalr	-594(ra) # 3dc <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bd5d                	j	4ee <vprintf+0x44>
        putc(fd, '%');
 63a:	02500593          	li	a1,37
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d9c080e7          	jalr	-612(ra) # 3dc <putc>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d90080e7          	jalr	-624(ra) # 3dc <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	bd61                	j	4ee <vprintf+0x44>
        s = va_arg(ap, char*);
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd49                	j	4ee <vprintf+0x44>
    }
  }
}
 65e:	60a6                	ld	ra,72(sp)
 660:	6406                	ld	s0,64(sp)
 662:	74e2                	ld	s1,56(sp)
 664:	7942                	ld	s2,48(sp)
 666:	79a2                	ld	s3,40(sp)
 668:	7a02                	ld	s4,32(sp)
 66a:	6ae2                	ld	s5,24(sp)
 66c:	6b42                	ld	s6,16(sp)
 66e:	6ba2                	ld	s7,8(sp)
 670:	6c02                	ld	s8,0(sp)
 672:	6161                	add	sp,sp,80
 674:	8082                	ret

0000000000000676 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 676:	715d                	add	sp,sp,-80
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	add	s0,sp,32
 67e:	e010                	sd	a2,0(s0)
 680:	e414                	sd	a3,8(s0)
 682:	e818                	sd	a4,16(s0)
 684:	ec1c                	sd	a5,24(s0)
 686:	03043023          	sd	a6,32(s0)
 68a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 692:	8622                	mv	a2,s0
 694:	00000097          	auipc	ra,0x0
 698:	e16080e7          	jalr	-490(ra) # 4aa <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6161                	add	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <printf>:

void
printf(const char *fmt, ...)
{
 6a4:	711d                	add	sp,sp,-96
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	add	s0,sp,32
 6ac:	e40c                	sd	a1,8(s0)
 6ae:	e810                	sd	a2,16(s0)
 6b0:	ec14                	sd	a3,24(s0)
 6b2:	f018                	sd	a4,32(s0)
 6b4:	f41c                	sd	a5,40(s0)
 6b6:	03043823          	sd	a6,48(s0)
 6ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	00840613          	add	a2,s0,8
 6c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c6:	85aa                	mv	a1,a0
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	de0080e7          	jalr	-544(ra) # 4aa <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	add	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	add	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00000797          	auipc	a5,0x0
 6e8:	20c7b783          	ld	a5,524(a5) # 8f0 <freep>
 6ec:	a02d                	j	716 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ee:	4618                	lw	a4,8(a2)
 6f0:	9f2d                	addw	a4,a4,a1
 6f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	6398                	ld	a4,0(a5)
 6f8:	6310                	ld	a2,0(a4)
 6fa:	a83d                	j	738 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fc:	ff852703          	lw	a4,-8(a0)
 700:	9f31                	addw	a4,a4,a2
 702:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 704:	ff053683          	ld	a3,-16(a0)
 708:	a091                	j	74c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x3a>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x4a>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x30>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059813          	sll	a6,a1,0x20
 72e:	01c85713          	srl	a4,a6,0x1c
 732:	9736                	add	a4,a4,a3
 734:	fae60de3          	beq	a2,a4,6ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061593          	sll	a1,a2,0x20
 742:	01c5d713          	srl	a4,a1,0x1c
 746:	973e                	add	a4,a4,a5
 748:	fae68ae3          	beq	a3,a4,6fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 74c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74e:	00000717          	auipc	a4,0x0
 752:	1af73123          	sd	a5,418(a4) # 8f0 <freep>
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	add	sp,sp,16
 75a:	8082                	ret

000000000000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	7139                	add	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	e852                	sd	s4,16(sp)
 76a:	e456                	sd	s5,8(sp)
 76c:	e05a                	sd	s6,0(sp)
 76e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051493          	sll	s1,a0,0x20
 774:	9081                	srl	s1,s1,0x20
 776:	04bd                	add	s1,s1,15
 778:	8091                	srl	s1,s1,0x4
 77a:	0014899b          	addw	s3,s1,1
 77e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 780:	00000517          	auipc	a0,0x0
 784:	17053503          	ld	a0,368(a0) # 8f0 <freep>
 788:	c515                	beqz	a0,7b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	02977f63          	bgeu	a4,s1,7cc <malloc+0x70>
  if(nu < 4096)
 792:	8a4e                	mv	s4,s3
 794:	0009871b          	sext.w	a4,s3
 798:	6685                	lui	a3,0x1
 79a:	00d77363          	bgeu	a4,a3,7a0 <malloc+0x44>
 79e:	6a05                	lui	s4,0x1
 7a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a8:	00000917          	auipc	s2,0x0
 7ac:	14890913          	add	s2,s2,328 # 8f0 <freep>
  if(p == (char*)-1)
 7b0:	5afd                	li	s5,-1
 7b2:	a895                	j	826 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7b4:	00000797          	auipc	a5,0x0
 7b8:	14478793          	add	a5,a5,324 # 8f8 <base>
 7bc:	00000717          	auipc	a4,0x0
 7c0:	12f73a23          	sd	a5,308(a4) # 8f0 <freep>
 7c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ca:	b7e1                	j	792 <malloc+0x36>
      if(p->s.size == nunits)
 7cc:	02e48c63          	beq	s1,a4,804 <malloc+0xa8>
        p->s.size -= nunits;
 7d0:	4137073b          	subw	a4,a4,s3
 7d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d6:	02071693          	sll	a3,a4,0x20
 7da:	01c6d713          	srl	a4,a3,0x1c
 7de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e4:	00000717          	auipc	a4,0x0
 7e8:	10a73623          	sd	a0,268(a4) # 8f0 <freep>
      return (void*)(p + 1);
 7ec:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f0:	70e2                	ld	ra,56(sp)
 7f2:	7442                	ld	s0,48(sp)
 7f4:	74a2                	ld	s1,40(sp)
 7f6:	7902                	ld	s2,32(sp)
 7f8:	69e2                	ld	s3,24(sp)
 7fa:	6a42                	ld	s4,16(sp)
 7fc:	6aa2                	ld	s5,8(sp)
 7fe:	6b02                	ld	s6,0(sp)
 800:	6121                	add	sp,sp,64
 802:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	e118                	sd	a4,0(a0)
 808:	bff1                	j	7e4 <malloc+0x88>
  hp->s.size = nu;
 80a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80e:	0541                	add	a0,a0,16
 810:	00000097          	auipc	ra,0x0
 814:	eca080e7          	jalr	-310(ra) # 6da <free>
  return freep;
 818:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81c:	d971                	beqz	a0,7f0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	fa9775e3          	bgeu	a4,s1,7cc <malloc+0x70>
    if(p == freep)
 826:	00093703          	ld	a4,0(s2)
 82a:	853e                	mv	a0,a5
 82c:	fef719e3          	bne	a4,a5,81e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 830:	8552                	mv	a0,s4
 832:	00000097          	auipc	ra,0x0
 836:	b82080e7          	jalr	-1150(ra) # 3b4 <sbrk>
  if(p == (char*)-1)
 83a:	fd5518e3          	bne	a0,s5,80a <malloc+0xae>
        return 0;
 83e:	4501                	li	a0,0
 840:	bf45                	j	7f0 <malloc+0x94>
