
user/_stats:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define SZ 4096
char buf[SZ];

int
main(void)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  int i, n;
  
  while (1) {
    n = statistics(buf, SZ);
  10:	00001a17          	auipc	s4,0x1
  14:	8f0a0a13          	add	s4,s4,-1808 # 900 <buf>
  18:	6585                	lui	a1,0x1
  1a:	8552                	mv	a0,s4
  1c:	00000097          	auipc	ra,0x0
  20:	7b0080e7          	jalr	1968(ra) # 7cc <statistics>
  24:	89aa                	mv	s3,a0
    for (i = 0; i < n; i++) {
  26:	02a05263          	blez	a0,4a <main+0x4a>
  2a:	00001497          	auipc	s1,0x1
  2e:	8d648493          	add	s1,s1,-1834 # 900 <buf>
  32:	00950933          	add	s2,a0,s1
      write(1, buf+i, 1);
  36:	4605                	li	a2,1
  38:	85a6                	mv	a1,s1
  3a:	4505                	li	a0,1
  3c:	00000097          	auipc	ra,0x0
  40:	2aa080e7          	jalr	682(ra) # 2e6 <write>
    for (i = 0; i < n; i++) {
  44:	0485                	add	s1,s1,1
  46:	ff2498e3          	bne	s1,s2,36 <main+0x36>
    }
    if (n != SZ)
  4a:	6785                	lui	a5,0x1
  4c:	fcf986e3          	beq	s3,a5,18 <main+0x18>
      break;
  }

  exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	274080e7          	jalr	628(ra) # 2c6 <exit>

000000000000005a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  5a:	1141                	add	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  60:	87aa                	mv	a5,a0
  62:	0585                	add	a1,a1,1 # 1001 <buf+0x701>
  64:	0785                	add	a5,a5,1 # 1001 <buf+0x701>
  66:	fff5c703          	lbu	a4,-1(a1)
  6a:	fee78fa3          	sb	a4,-1(a5)
  6e:	fb75                	bnez	a4,62 <strcpy+0x8>
    ;
  return os;
}
  70:	6422                	ld	s0,8(sp)
  72:	0141                	add	sp,sp,16
  74:	8082                	ret

0000000000000076 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  76:	1141                	add	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cb91                	beqz	a5,94 <strcmp+0x1e>
  82:	0005c703          	lbu	a4,0(a1)
  86:	00f71763          	bne	a4,a5,94 <strcmp+0x1e>
    p++, q++;
  8a:	0505                	add	a0,a0,1
  8c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	fbe5                	bnez	a5,82 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  94:	0005c503          	lbu	a0,0(a1)
}
  98:	40a7853b          	subw	a0,a5,a0
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	add	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strlen>:

uint
strlen(const char *s)
{
  a2:	1141                	add	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	cf91                	beqz	a5,c8 <strlen+0x26>
  ae:	0505                	add	a0,a0,1
  b0:	87aa                	mv	a5,a0
  b2:	86be                	mv	a3,a5
  b4:	0785                	add	a5,a5,1
  b6:	fff7c703          	lbu	a4,-1(a5)
  ba:	ff65                	bnez	a4,b2 <strlen+0x10>
  bc:	40a6853b          	subw	a0,a3,a0
  c0:	2505                	addw	a0,a0,1
    ;
  return n;
}
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	add	sp,sp,16
  c6:	8082                	ret
  for(n = 0; s[n]; n++)
  c8:	4501                	li	a0,0
  ca:	bfe5                	j	c2 <strlen+0x20>

00000000000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	1141                	add	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d2:	ca19                	beqz	a2,e8 <memset+0x1c>
  d4:	87aa                	mv	a5,a0
  d6:	1602                	sll	a2,a2,0x20
  d8:	9201                	srl	a2,a2,0x20
  da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e2:	0785                	add	a5,a5,1
  e4:	fee79de3          	bne	a5,a4,de <memset+0x12>
  }
  return dst;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	add	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strchr>:

char*
strchr(const char *s, char c)
{
  ee:	1141                	add	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	add	s0,sp,16
  for(; *s; s++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb99                	beqz	a5,10e <strchr+0x20>
    if(*s == c)
  fa:	00f58763          	beq	a1,a5,108 <strchr+0x1a>
  for(; *s; s++)
  fe:	0505                	add	a0,a0,1
 100:	00054783          	lbu	a5,0(a0)
 104:	fbfd                	bnez	a5,fa <strchr+0xc>
      return (char*)s;
  return 0;
 106:	4501                	li	a0,0
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	add	sp,sp,16
 10c:	8082                	ret
  return 0;
 10e:	4501                	li	a0,0
 110:	bfe5                	j	108 <strchr+0x1a>

0000000000000112 <gets>:

char*
gets(char *buf, int max)
{
 112:	711d                	add	sp,sp,-96
 114:	ec86                	sd	ra,88(sp)
 116:	e8a2                	sd	s0,80(sp)
 118:	e4a6                	sd	s1,72(sp)
 11a:	e0ca                	sd	s2,64(sp)
 11c:	fc4e                	sd	s3,56(sp)
 11e:	f852                	sd	s4,48(sp)
 120:	f456                	sd	s5,40(sp)
 122:	f05a                	sd	s6,32(sp)
 124:	ec5e                	sd	s7,24(sp)
 126:	1080                	add	s0,sp,96
 128:	8baa                	mv	s7,a0
 12a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	892a                	mv	s2,a0
 12e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 130:	4aa9                	li	s5,10
 132:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	2485                	addw	s1,s1,1
 138:	0344d863          	bge	s1,s4,168 <gets+0x56>
    cc = read(0, &c, 1);
 13c:	4605                	li	a2,1
 13e:	faf40593          	add	a1,s0,-81
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	19a080e7          	jalr	410(ra) # 2de <read>
    if(cc < 1)
 14c:	00a05e63          	blez	a0,168 <gets+0x56>
    buf[i++] = c;
 150:	faf44783          	lbu	a5,-81(s0)
 154:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 158:	01578763          	beq	a5,s5,166 <gets+0x54>
 15c:	0905                	add	s2,s2,1
 15e:	fd679be3          	bne	a5,s6,134 <gets+0x22>
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	a011                	j	168 <gets+0x56>
 166:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 168:	99de                	add	s3,s3,s7
 16a:	00098023          	sb	zero,0(s3)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6125                	add	sp,sp,96
 184:	8082                	ret

0000000000000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	1101                	add	sp,sp,-32
 188:	ec06                	sd	ra,24(sp)
 18a:	e822                	sd	s0,16(sp)
 18c:	e426                	sd	s1,8(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	add	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	00000097          	auipc	ra,0x0
 19a:	170080e7          	jalr	368(ra) # 306 <open>
  if(fd < 0)
 19e:	02054563          	bltz	a0,1c8 <stat+0x42>
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	00000097          	auipc	ra,0x0
 1aa:	178080e7          	jalr	376(ra) # 31e <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	13c080e7          	jalr	316(ra) # 2ee <close>
  return r;
}
 1ba:	854a                	mv	a0,s2
 1bc:	60e2                	ld	ra,24(sp)
 1be:	6442                	ld	s0,16(sp)
 1c0:	64a2                	ld	s1,8(sp)
 1c2:	6902                	ld	s2,0(sp)
 1c4:	6105                	add	sp,sp,32
 1c6:	8082                	ret
    return -1;
 1c8:	597d                	li	s2,-1
 1ca:	bfc5                	j	1ba <stat+0x34>

00000000000001cc <atoi>:

int
atoi(const char *s)
{
 1cc:	1141                	add	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d2:	00054683          	lbu	a3,0(a0)
 1d6:	fd06879b          	addw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	4625                	li	a2,9
 1e0:	02f66863          	bltu	a2,a5,210 <atoi+0x44>
 1e4:	872a                	mv	a4,a0
  n = 0;
 1e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e8:	0705                	add	a4,a4,1
 1ea:	0025179b          	sllw	a5,a0,0x2
 1ee:	9fa9                	addw	a5,a5,a0
 1f0:	0017979b          	sllw	a5,a5,0x1
 1f4:	9fb5                	addw	a5,a5,a3
 1f6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fa:	00074683          	lbu	a3,0(a4)
 1fe:	fd06879b          	addw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	fef671e3          	bgeu	a2,a5,1e8 <atoi+0x1c>
  return n;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	add	sp,sp,16
 20e:	8082                	ret
  n = 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <atoi+0x3e>

0000000000000214 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 214:	1141                	add	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21a:	02b57463          	bgeu	a0,a1,242 <memmove+0x2e>
    while(n-- > 0)
 21e:	00c05f63          	blez	a2,23c <memmove+0x28>
 222:	1602                	sll	a2,a2,0x20
 224:	9201                	srl	a2,a2,0x20
 226:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22a:	872a                	mv	a4,a0
      *dst++ = *src++;
 22c:	0585                	add	a1,a1,1
 22e:	0705                	add	a4,a4,1
 230:	fff5c683          	lbu	a3,-1(a1)
 234:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	add	sp,sp,16
 240:	8082                	ret
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 248:	fec05ae3          	blez	a2,23c <memmove+0x28>
 24c:	fff6079b          	addw	a5,a2,-1
 250:	1782                	sll	a5,a5,0x20
 252:	9381                	srl	a5,a5,0x20
 254:	fff7c793          	not	a5,a5
 258:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25a:	15fd                	add	a1,a1,-1
 25c:	177d                	add	a4,a4,-1
 25e:	0005c683          	lbu	a3,0(a1)
 262:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x46>
 26a:	bfc9                	j	23c <memmove+0x28>

000000000000026c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 272:	ca05                	beqz	a2,2a2 <memcmp+0x36>
 274:	fff6069b          	addw	a3,a2,-1
 278:	1682                	sll	a3,a3,0x20
 27a:	9281                	srl	a3,a3,0x20
 27c:	0685                	add	a3,a3,1
 27e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 280:	00054783          	lbu	a5,0(a0)
 284:	0005c703          	lbu	a4,0(a1)
 288:	00e79863          	bne	a5,a4,298 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28c:	0505                	add	a0,a0,1
    p2++;
 28e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 290:	fed518e3          	bne	a0,a3,280 <memcmp+0x14>
  }
  return 0;
 294:	4501                	li	a0,0
 296:	a019                	j	29c <memcmp+0x30>
      return *p1 - *p2;
 298:	40e7853b          	subw	a0,a5,a4
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	add	sp,sp,16
 2a0:	8082                	ret
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <memcmp+0x30>

00000000000002a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a6:	1141                	add	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2ae:	00000097          	auipc	ra,0x0
 2b2:	f66080e7          	jalr	-154(ra) # 214 <memmove>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	add	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 366:	1101                	add	sp,sp,-32
 368:	ec06                	sd	ra,24(sp)
 36a:	e822                	sd	s0,16(sp)
 36c:	1000                	add	s0,sp,32
 36e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 372:	4605                	li	a2,1
 374:	fef40593          	add	a1,s0,-17
 378:	00000097          	auipc	ra,0x0
 37c:	f6e080e7          	jalr	-146(ra) # 2e6 <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	add	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	7139                	add	sp,sp,-64
 38a:	fc06                	sd	ra,56(sp)
 38c:	f822                	sd	s0,48(sp)
 38e:	f426                	sd	s1,40(sp)
 390:	f04a                	sd	s2,32(sp)
 392:	ec4e                	sd	s3,24(sp)
 394:	0080                	add	s0,sp,64
 396:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 398:	c299                	beqz	a3,39e <printint+0x16>
 39a:	0805c963          	bltz	a1,42c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39e:	2581                	sext.w	a1,a1
  neg = 0;
 3a0:	4881                	li	a7,0
 3a2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3a6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a8:	2601                	sext.w	a2,a2
 3aa:	00000517          	auipc	a0,0x0
 3ae:	50e50513          	add	a0,a0,1294 # 8b8 <digits>
 3b2:	883a                	mv	a6,a4
 3b4:	2705                	addw	a4,a4,1
 3b6:	02c5f7bb          	remuw	a5,a1,a2
 3ba:	1782                	sll	a5,a5,0x20
 3bc:	9381                	srl	a5,a5,0x20
 3be:	97aa                	add	a5,a5,a0
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c8:	0005879b          	sext.w	a5,a1
 3cc:	02c5d5bb          	divuw	a1,a1,a2
 3d0:	0685                	add	a3,a3,1
 3d2:	fec7f0e3          	bgeu	a5,a2,3b2 <printint+0x2a>
  if(neg)
 3d6:	00088c63          	beqz	a7,3ee <printint+0x66>
    buf[i++] = '-';
 3da:	fd070793          	add	a5,a4,-48
 3de:	00878733          	add	a4,a5,s0
 3e2:	02d00793          	li	a5,45
 3e6:	fef70823          	sb	a5,-16(a4)
 3ea:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3ee:	02e05863          	blez	a4,41e <printint+0x96>
 3f2:	fc040793          	add	a5,s0,-64
 3f6:	00e78933          	add	s2,a5,a4
 3fa:	fff78993          	add	s3,a5,-1
 3fe:	99ba                	add	s3,s3,a4
 400:	377d                	addw	a4,a4,-1
 402:	1702                	sll	a4,a4,0x20
 404:	9301                	srl	a4,a4,0x20
 406:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40a:	fff94583          	lbu	a1,-1(s2)
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	f56080e7          	jalr	-170(ra) # 366 <putc>
  while(--i >= 0)
 418:	197d                	add	s2,s2,-1
 41a:	ff3918e3          	bne	s2,s3,40a <printint+0x82>
}
 41e:	70e2                	ld	ra,56(sp)
 420:	7442                	ld	s0,48(sp)
 422:	74a2                	ld	s1,40(sp)
 424:	7902                	ld	s2,32(sp)
 426:	69e2                	ld	s3,24(sp)
 428:	6121                	add	sp,sp,64
 42a:	8082                	ret
    x = -xx;
 42c:	40b005bb          	negw	a1,a1
    neg = 1;
 430:	4885                	li	a7,1
    x = -xx;
 432:	bf85                	j	3a2 <printint+0x1a>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	715d                	add	sp,sp,-80
 436:	e486                	sd	ra,72(sp)
 438:	e0a2                	sd	s0,64(sp)
 43a:	fc26                	sd	s1,56(sp)
 43c:	f84a                	sd	s2,48(sp)
 43e:	f44e                	sd	s3,40(sp)
 440:	f052                	sd	s4,32(sp)
 442:	ec56                	sd	s5,24(sp)
 444:	e85a                	sd	s6,16(sp)
 446:	e45e                	sd	s7,8(sp)
 448:	e062                	sd	s8,0(sp)
 44a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44c:	0005c903          	lbu	s2,0(a1)
 450:	18090c63          	beqz	s2,5e8 <vprintf+0x1b4>
 454:	8aaa                	mv	s5,a0
 456:	8bb2                	mv	s7,a2
 458:	00158493          	add	s1,a1,1
  state = 0;
 45c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45e:	02500a13          	li	s4,37
 462:	4b55                	li	s6,21
 464:	a839                	j	482 <vprintf+0x4e>
        putc(fd, c);
 466:	85ca                	mv	a1,s2
 468:	8556                	mv	a0,s5
 46a:	00000097          	auipc	ra,0x0
 46e:	efc080e7          	jalr	-260(ra) # 366 <putc>
 472:	a019                	j	478 <vprintf+0x44>
    } else if(state == '%'){
 474:	01498d63          	beq	s3,s4,48e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 478:	0485                	add	s1,s1,1
 47a:	fff4c903          	lbu	s2,-1(s1)
 47e:	16090563          	beqz	s2,5e8 <vprintf+0x1b4>
    if(state == 0){
 482:	fe0999e3          	bnez	s3,474 <vprintf+0x40>
      if(c == '%'){
 486:	ff4910e3          	bne	s2,s4,466 <vprintf+0x32>
        state = '%';
 48a:	89d2                	mv	s3,s4
 48c:	b7f5                	j	478 <vprintf+0x44>
      if(c == 'd'){
 48e:	13490263          	beq	s2,s4,5b2 <vprintf+0x17e>
 492:	f9d9079b          	addw	a5,s2,-99
 496:	0ff7f793          	zext.b	a5,a5
 49a:	12fb6563          	bltu	s6,a5,5c4 <vprintf+0x190>
 49e:	f9d9079b          	addw	a5,s2,-99
 4a2:	0ff7f713          	zext.b	a4,a5
 4a6:	10eb6f63          	bltu	s6,a4,5c4 <vprintf+0x190>
 4aa:	00271793          	sll	a5,a4,0x2
 4ae:	00000717          	auipc	a4,0x0
 4b2:	3b270713          	add	a4,a4,946 # 860 <statistics+0x94>
 4b6:	97ba                	add	a5,a5,a4
 4b8:	439c                	lw	a5,0(a5)
 4ba:	97ba                	add	a5,a5,a4
 4bc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4be:	008b8913          	add	s2,s7,8
 4c2:	4685                	li	a3,1
 4c4:	4629                	li	a2,10
 4c6:	000ba583          	lw	a1,0(s7)
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ebc080e7          	jalr	-324(ra) # 388 <printint>
 4d4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d6:	4981                	li	s3,0
 4d8:	b745                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4da:	008b8913          	add	s2,s7,8
 4de:	4681                	li	a3,0
 4e0:	4629                	li	a2,10
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	ea0080e7          	jalr	-352(ra) # 388 <printint>
 4f0:	8bca                	mv	s7,s2
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b751                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4f6:	008b8913          	add	s2,s7,8
 4fa:	4681                	li	a3,0
 4fc:	4641                	li	a2,16
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e84080e7          	jalr	-380(ra) # 388 <printint>
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	b7a5                	j	478 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 512:	008b8c13          	add	s8,s7,8
 516:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 51a:	03000593          	li	a1,48
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e46080e7          	jalr	-442(ra) # 366 <putc>
  putc(fd, 'x');
 528:	07800593          	li	a1,120
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e38080e7          	jalr	-456(ra) # 366 <putc>
 536:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 538:	00000b97          	auipc	s7,0x0
 53c:	380b8b93          	add	s7,s7,896 # 8b8 <digits>
 540:	03c9d793          	srl	a5,s3,0x3c
 544:	97de                	add	a5,a5,s7
 546:	0007c583          	lbu	a1,0(a5)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	e1a080e7          	jalr	-486(ra) # 366 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 554:	0992                	sll	s3,s3,0x4
 556:	397d                	addw	s2,s2,-1
 558:	fe0914e3          	bnez	s2,540 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 55c:	8be2                	mv	s7,s8
      state = 0;
 55e:	4981                	li	s3,0
 560:	bf21                	j	478 <vprintf+0x44>
        s = va_arg(ap, char*);
 562:	008b8993          	add	s3,s7,8
 566:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 56a:	02090163          	beqz	s2,58c <vprintf+0x158>
        while(*s != 0){
 56e:	00094583          	lbu	a1,0(s2)
 572:	c9a5                	beqz	a1,5e2 <vprintf+0x1ae>
          putc(fd, *s);
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	df0080e7          	jalr	-528(ra) # 366 <putc>
          s++;
 57e:	0905                	add	s2,s2,1
        while(*s != 0){
 580:	00094583          	lbu	a1,0(s2)
 584:	f9e5                	bnez	a1,574 <vprintf+0x140>
        s = va_arg(ap, char*);
 586:	8bce                	mv	s7,s3
      state = 0;
 588:	4981                	li	s3,0
 58a:	b5fd                	j	478 <vprintf+0x44>
          s = "(null)";
 58c:	00000917          	auipc	s2,0x0
 590:	2cc90913          	add	s2,s2,716 # 858 <statistics+0x8c>
        while(*s != 0){
 594:	02800593          	li	a1,40
 598:	bff1                	j	574 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 59a:	008b8913          	add	s2,s7,8
 59e:	000bc583          	lbu	a1,0(s7)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	dc2080e7          	jalr	-574(ra) # 366 <putc>
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5e1                	j	478 <vprintf+0x44>
        putc(fd, c);
 5b2:	02500593          	li	a1,37
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	dae080e7          	jalr	-594(ra) # 366 <putc>
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bd5d                	j	478 <vprintf+0x44>
        putc(fd, '%');
 5c4:	02500593          	li	a1,37
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	d9c080e7          	jalr	-612(ra) # 366 <putc>
        putc(fd, c);
 5d2:	85ca                	mv	a1,s2
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	d90080e7          	jalr	-624(ra) # 366 <putc>
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bd61                	j	478 <vprintf+0x44>
        s = va_arg(ap, char*);
 5e2:	8bce                	mv	s7,s3
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd49                	j	478 <vprintf+0x44>
    }
  }
}
 5e8:	60a6                	ld	ra,72(sp)
 5ea:	6406                	ld	s0,64(sp)
 5ec:	74e2                	ld	s1,56(sp)
 5ee:	7942                	ld	s2,48(sp)
 5f0:	79a2                	ld	s3,40(sp)
 5f2:	7a02                	ld	s4,32(sp)
 5f4:	6ae2                	ld	s5,24(sp)
 5f6:	6b42                	ld	s6,16(sp)
 5f8:	6ba2                	ld	s7,8(sp)
 5fa:	6c02                	ld	s8,0(sp)
 5fc:	6161                	add	sp,sp,80
 5fe:	8082                	ret

0000000000000600 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 600:	715d                	add	sp,sp,-80
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	add	s0,sp,32
 608:	e010                	sd	a2,0(s0)
 60a:	e414                	sd	a3,8(s0)
 60c:	e818                	sd	a4,16(s0)
 60e:	ec1c                	sd	a5,24(s0)
 610:	03043023          	sd	a6,32(s0)
 614:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 618:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 61c:	8622                	mv	a2,s0
 61e:	00000097          	auipc	ra,0x0
 622:	e16080e7          	jalr	-490(ra) # 434 <vprintf>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6161                	add	sp,sp,80
 62c:	8082                	ret

000000000000062e <printf>:

void
printf(const char *fmt, ...)
{
 62e:	711d                	add	sp,sp,-96
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	add	s0,sp,32
 636:	e40c                	sd	a1,8(s0)
 638:	e810                	sd	a2,16(s0)
 63a:	ec14                	sd	a3,24(s0)
 63c:	f018                	sd	a4,32(s0)
 63e:	f41c                	sd	a5,40(s0)
 640:	03043823          	sd	a6,48(s0)
 644:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 648:	00840613          	add	a2,s0,8
 64c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 650:	85aa                	mv	a1,a0
 652:	4505                	li	a0,1
 654:	00000097          	auipc	ra,0x0
 658:	de0080e7          	jalr	-544(ra) # 434 <vprintf>
}
 65c:	60e2                	ld	ra,24(sp)
 65e:	6442                	ld	s0,16(sp)
 660:	6125                	add	sp,sp,96
 662:	8082                	ret

0000000000000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	1141                	add	sp,sp,-16
 666:	e422                	sd	s0,8(sp)
 668:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	00000797          	auipc	a5,0x0
 672:	28a7b783          	ld	a5,650(a5) # 8f8 <freep>
 676:	a02d                	j	6a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 678:	4618                	lw	a4,8(a2)
 67a:	9f2d                	addw	a4,a4,a1
 67c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 680:	6398                	ld	a4,0(a5)
 682:	6310                	ld	a2,0(a4)
 684:	a83d                	j	6c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 686:	ff852703          	lw	a4,-8(a0)
 68a:	9f31                	addw	a4,a4,a2
 68c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 68e:	ff053683          	ld	a3,-16(a0)
 692:	a091                	j	6d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	6398                	ld	a4,0(a5)
 696:	00e7e463          	bltu	a5,a4,69e <free+0x3a>
 69a:	00e6ea63          	bltu	a3,a4,6ae <free+0x4a>
{
 69e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	fed7fae3          	bgeu	a5,a3,694 <free+0x30>
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e6e463          	bltu	a3,a4,6ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	fee7eae3          	bltu	a5,a4,69e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ae:	ff852583          	lw	a1,-8(a0)
 6b2:	6390                	ld	a2,0(a5)
 6b4:	02059813          	sll	a6,a1,0x20
 6b8:	01c85713          	srl	a4,a6,0x1c
 6bc:	9736                	add	a4,a4,a3
 6be:	fae60de3          	beq	a2,a4,678 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c6:	4790                	lw	a2,8(a5)
 6c8:	02061593          	sll	a1,a2,0x20
 6cc:	01c5d713          	srl	a4,a1,0x1c
 6d0:	973e                	add	a4,a4,a5
 6d2:	fae68ae3          	beq	a3,a4,686 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d8:	00000717          	auipc	a4,0x0
 6dc:	22f73023          	sd	a5,544(a4) # 8f8 <freep>
}
 6e0:	6422                	ld	s0,8(sp)
 6e2:	0141                	add	sp,sp,16
 6e4:	8082                	ret

00000000000006e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e6:	7139                	add	sp,sp,-64
 6e8:	fc06                	sd	ra,56(sp)
 6ea:	f822                	sd	s0,48(sp)
 6ec:	f426                	sd	s1,40(sp)
 6ee:	f04a                	sd	s2,32(sp)
 6f0:	ec4e                	sd	s3,24(sp)
 6f2:	e852                	sd	s4,16(sp)
 6f4:	e456                	sd	s5,8(sp)
 6f6:	e05a                	sd	s6,0(sp)
 6f8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	02051493          	sll	s1,a0,0x20
 6fe:	9081                	srl	s1,s1,0x20
 700:	04bd                	add	s1,s1,15
 702:	8091                	srl	s1,s1,0x4
 704:	0014899b          	addw	s3,s1,1
 708:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 70a:	00000517          	auipc	a0,0x0
 70e:	1ee53503          	ld	a0,494(a0) # 8f8 <freep>
 712:	c515                	beqz	a0,73e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 714:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 716:	4798                	lw	a4,8(a5)
 718:	02977f63          	bgeu	a4,s1,756 <malloc+0x70>
  if(nu < 4096)
 71c:	8a4e                	mv	s4,s3
 71e:	0009871b          	sext.w	a4,s3
 722:	6685                	lui	a3,0x1
 724:	00d77363          	bgeu	a4,a3,72a <malloc+0x44>
 728:	6a05                	lui	s4,0x1
 72a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 732:	00000917          	auipc	s2,0x0
 736:	1c690913          	add	s2,s2,454 # 8f8 <freep>
  if(p == (char*)-1)
 73a:	5afd                	li	s5,-1
 73c:	a895                	j	7b0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 73e:	00001797          	auipc	a5,0x1
 742:	1c278793          	add	a5,a5,450 # 1900 <base>
 746:	00000717          	auipc	a4,0x0
 74a:	1af73923          	sd	a5,434(a4) # 8f8 <freep>
 74e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 750:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 754:	b7e1                	j	71c <malloc+0x36>
      if(p->s.size == nunits)
 756:	02e48c63          	beq	s1,a4,78e <malloc+0xa8>
        p->s.size -= nunits;
 75a:	4137073b          	subw	a4,a4,s3
 75e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 760:	02071693          	sll	a3,a4,0x20
 764:	01c6d713          	srl	a4,a3,0x1c
 768:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 76a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76e:	00000717          	auipc	a4,0x0
 772:	18a73523          	sd	a0,394(a4) # 8f8 <freep>
      return (void*)(p + 1);
 776:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 77a:	70e2                	ld	ra,56(sp)
 77c:	7442                	ld	s0,48(sp)
 77e:	74a2                	ld	s1,40(sp)
 780:	7902                	ld	s2,32(sp)
 782:	69e2                	ld	s3,24(sp)
 784:	6a42                	ld	s4,16(sp)
 786:	6aa2                	ld	s5,8(sp)
 788:	6b02                	ld	s6,0(sp)
 78a:	6121                	add	sp,sp,64
 78c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78e:	6398                	ld	a4,0(a5)
 790:	e118                	sd	a4,0(a0)
 792:	bff1                	j	76e <malloc+0x88>
  hp->s.size = nu;
 794:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 798:	0541                	add	a0,a0,16
 79a:	00000097          	auipc	ra,0x0
 79e:	eca080e7          	jalr	-310(ra) # 664 <free>
  return freep;
 7a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a6:	d971                	beqz	a0,77a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7aa:	4798                	lw	a4,8(a5)
 7ac:	fa9775e3          	bgeu	a4,s1,756 <malloc+0x70>
    if(p == freep)
 7b0:	00093703          	ld	a4,0(s2)
 7b4:	853e                	mv	a0,a5
 7b6:	fef719e3          	bne	a4,a5,7a8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7ba:	8552                	mv	a0,s4
 7bc:	00000097          	auipc	ra,0x0
 7c0:	b92080e7          	jalr	-1134(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7c4:	fd5518e3          	bne	a0,s5,794 <malloc+0xae>
        return 0;
 7c8:	4501                	li	a0,0
 7ca:	bf45                	j	77a <malloc+0x94>

00000000000007cc <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 7cc:	7179                	add	sp,sp,-48
 7ce:	f406                	sd	ra,40(sp)
 7d0:	f022                	sd	s0,32(sp)
 7d2:	ec26                	sd	s1,24(sp)
 7d4:	e84a                	sd	s2,16(sp)
 7d6:	e44e                	sd	s3,8(sp)
 7d8:	e052                	sd	s4,0(sp)
 7da:	1800                	add	s0,sp,48
 7dc:	8a2a                	mv	s4,a0
 7de:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 7e0:	4581                	li	a1,0
 7e2:	00000517          	auipc	a0,0x0
 7e6:	0ee50513          	add	a0,a0,238 # 8d0 <digits+0x18>
 7ea:	00000097          	auipc	ra,0x0
 7ee:	b1c080e7          	jalr	-1252(ra) # 306 <open>
  if(fd < 0) {
 7f2:	04054263          	bltz	a0,836 <statistics+0x6a>
 7f6:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 7f8:	4481                	li	s1,0
 7fa:	03205063          	blez	s2,81a <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 7fe:	4099063b          	subw	a2,s2,s1
 802:	009a05b3          	add	a1,s4,s1
 806:	854e                	mv	a0,s3
 808:	00000097          	auipc	ra,0x0
 80c:	ad6080e7          	jalr	-1322(ra) # 2de <read>
 810:	00054563          	bltz	a0,81a <statistics+0x4e>
      break;
    }
    i += n;
 814:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 816:	ff24c4e3          	blt	s1,s2,7fe <statistics+0x32>
  }
  close(fd);
 81a:	854e                	mv	a0,s3
 81c:	00000097          	auipc	ra,0x0
 820:	ad2080e7          	jalr	-1326(ra) # 2ee <close>
  return i;
}
 824:	8526                	mv	a0,s1
 826:	70a2                	ld	ra,40(sp)
 828:	7402                	ld	s0,32(sp)
 82a:	64e2                	ld	s1,24(sp)
 82c:	6942                	ld	s2,16(sp)
 82e:	69a2                	ld	s3,8(sp)
 830:	6a02                	ld	s4,0(sp)
 832:	6145                	add	sp,sp,48
 834:	8082                	ret
      fprintf(2, "stats: open failed\n");
 836:	00000597          	auipc	a1,0x0
 83a:	0aa58593          	add	a1,a1,170 # 8e0 <digits+0x28>
 83e:	4509                	li	a0,2
 840:	00000097          	auipc	ra,0x0
 844:	dc0080e7          	jalr	-576(ra) # 600 <fprintf>
      exit(1);
 848:	4505                	li	a0,1
 84a:	00000097          	auipc	ra,0x0
 84e:	a7c080e7          	jalr	-1412(ra) # 2c6 <exit>
