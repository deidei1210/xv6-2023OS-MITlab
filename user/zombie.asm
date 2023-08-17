
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	286080e7          	jalr	646(ra) # 28e <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	280080e7          	jalr	640(ra) # 296 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	306080e7          	jalr	774(ra) # 326 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	add	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	add	a1,a1,1
  34:	0785                	add	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	add	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	add	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	add	a0,a0,1
  5c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	add	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	add	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	add	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	86be                	mv	a3,a5
  84:	0785                	add	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x10>
  8c:	40a6853b          	subw	a0,a3,a0
  90:	2505                	addw	a0,a0,1
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	add	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	add	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	sll	a2,a2,0x20
  a8:	9201                	srl	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	add	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	add	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	add	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	add	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	add	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	add	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	add	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	add	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	add	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	19a080e7          	jalr	410(ra) # 2ae <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	add	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
  for(i=0; i+1 < max; ){
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	add	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	add	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	add	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	00000097          	auipc	ra,0x0
 16a:	170080e7          	jalr	368(ra) # 2d6 <open>
  if(fd < 0)
 16e:	02054563          	bltz	a0,198 <stat+0x42>
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	178080e7          	jalr	376(ra) # 2ee <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	13c080e7          	jalr	316(ra) # 2be <close>
  return r;
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	64a2                	ld	s1,8(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	add	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfc5                	j	18a <stat+0x34>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	add	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054683          	lbu	a3,0(a0)
 1a6:	fd06879b          	addw	a5,a3,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4625                	li	a2,9
 1b0:	02f66863          	bltu	a2,a5,1e0 <atoi+0x44>
 1b4:	872a                	mv	a4,a0
  n = 0;
 1b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b8:	0705                	add	a4,a4,1
 1ba:	0025179b          	sllw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	sllw	a5,a5,0x1
 1c4:	9fb5                	addw	a5,a5,a3
 1c6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	00074683          	lbu	a3,0(a4)
 1ce:	fd06879b          	addw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	fef671e3          	bgeu	a2,a5,1b8 <atoi+0x1c>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	add	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x3e>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	add	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ea:	02b57463          	bgeu	a0,a1,212 <memmove+0x2e>
    while(n-- > 0)
 1ee:	00c05f63          	blez	a2,20c <memmove+0x28>
 1f2:	1602                	sll	a2,a2,0x20
 1f4:	9201                	srl	a2,a2,0x20
 1f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	add	a1,a1,1
 1fe:	0705                	add	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fee79ae3          	bne	a5,a4,1fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	add	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x28>
 21c:	fff6079b          	addw	a5,a2,-1
 220:	1782                	sll	a5,a5,0x20
 222:	9381                	srl	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	add	a1,a1,-1
 22c:	177d                	add	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x46>
 23a:	bfc9                	j	20c <memmove+0x28>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	add	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addw	a3,a2,-1
 248:	1682                	sll	a3,a3,0x20
 24a:	9281                	srl	a3,a3,0x20
 24c:	0685                	add	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	add	a0,a0,1
    p2++;
 25e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	add	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	add	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 27e:	00000097          	auipc	ra,0x0
 282:	f66080e7          	jalr	-154(ra) # 1e4 <memmove>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	add	sp,sp,16
 28c:	8082                	ret

000000000000028e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28e:	4885                	li	a7,1
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <exit>:
.global exit
exit:
 li a7, SYS_exit
 296:	4889                	li	a7,2
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <wait>:
.global wait
wait:
 li a7, SYS_wait
 29e:	488d                	li	a7,3
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a6:	4891                	li	a7,4
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <read>:
.global read
read:
 li a7, SYS_read
 2ae:	4895                	li	a7,5
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <write>:
.global write
write:
 li a7, SYS_write
 2b6:	48c1                	li	a7,16
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <close>:
.global close
close:
 li a7, SYS_close
 2be:	48d5                	li	a7,21
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c6:	4899                	li	a7,6
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ce:	489d                	li	a7,7
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <open>:
.global open
open:
 li a7, SYS_open
 2d6:	48bd                	li	a7,15
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2de:	48c5                	li	a7,17
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e6:	48c9                	li	a7,18
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ee:	48a1                	li	a7,8
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <link>:
.global link
link:
 li a7, SYS_link
 2f6:	48cd                	li	a7,19
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2fe:	48d1                	li	a7,20
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 306:	48a5                	li	a7,9
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <dup>:
.global dup
dup:
 li a7, SYS_dup
 30e:	48a9                	li	a7,10
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 316:	48ad                	li	a7,11
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31e:	48b1                	li	a7,12
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 326:	48b5                	li	a7,13
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32e:	48b9                	li	a7,14
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 336:	48d9                	li	a7,22
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 33e:	48dd                	li	a7,23
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 346:	1101                	add	sp,sp,-32
 348:	ec06                	sd	ra,24(sp)
 34a:	e822                	sd	s0,16(sp)
 34c:	1000                	add	s0,sp,32
 34e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 352:	4605                	li	a2,1
 354:	fef40593          	add	a1,s0,-17
 358:	00000097          	auipc	ra,0x0
 35c:	f5e080e7          	jalr	-162(ra) # 2b6 <write>
}
 360:	60e2                	ld	ra,24(sp)
 362:	6442                	ld	s0,16(sp)
 364:	6105                	add	sp,sp,32
 366:	8082                	ret

0000000000000368 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	7139                	add	sp,sp,-64
 36a:	fc06                	sd	ra,56(sp)
 36c:	f822                	sd	s0,48(sp)
 36e:	f426                	sd	s1,40(sp)
 370:	f04a                	sd	s2,32(sp)
 372:	ec4e                	sd	s3,24(sp)
 374:	0080                	add	s0,sp,64
 376:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 378:	c299                	beqz	a3,37e <printint+0x16>
 37a:	0805c963          	bltz	a1,40c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37e:	2581                	sext.w	a1,a1
  neg = 0;
 380:	4881                	li	a7,0
 382:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 386:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 388:	2601                	sext.w	a2,a2
 38a:	00000517          	auipc	a0,0x0
 38e:	48650513          	add	a0,a0,1158 # 810 <digits>
 392:	883a                	mv	a6,a4
 394:	2705                	addw	a4,a4,1
 396:	02c5f7bb          	remuw	a5,a1,a2
 39a:	1782                	sll	a5,a5,0x20
 39c:	9381                	srl	a5,a5,0x20
 39e:	97aa                	add	a5,a5,a0
 3a0:	0007c783          	lbu	a5,0(a5)
 3a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a8:	0005879b          	sext.w	a5,a1
 3ac:	02c5d5bb          	divuw	a1,a1,a2
 3b0:	0685                	add	a3,a3,1
 3b2:	fec7f0e3          	bgeu	a5,a2,392 <printint+0x2a>
  if(neg)
 3b6:	00088c63          	beqz	a7,3ce <printint+0x66>
    buf[i++] = '-';
 3ba:	fd070793          	add	a5,a4,-48
 3be:	00878733          	add	a4,a5,s0
 3c2:	02d00793          	li	a5,45
 3c6:	fef70823          	sb	a5,-16(a4)
 3ca:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3ce:	02e05863          	blez	a4,3fe <printint+0x96>
 3d2:	fc040793          	add	a5,s0,-64
 3d6:	00e78933          	add	s2,a5,a4
 3da:	fff78993          	add	s3,a5,-1
 3de:	99ba                	add	s3,s3,a4
 3e0:	377d                	addw	a4,a4,-1
 3e2:	1702                	sll	a4,a4,0x20
 3e4:	9301                	srl	a4,a4,0x20
 3e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3ea:	fff94583          	lbu	a1,-1(s2)
 3ee:	8526                	mv	a0,s1
 3f0:	00000097          	auipc	ra,0x0
 3f4:	f56080e7          	jalr	-170(ra) # 346 <putc>
  while(--i >= 0)
 3f8:	197d                	add	s2,s2,-1
 3fa:	ff3918e3          	bne	s2,s3,3ea <printint+0x82>
}
 3fe:	70e2                	ld	ra,56(sp)
 400:	7442                	ld	s0,48(sp)
 402:	74a2                	ld	s1,40(sp)
 404:	7902                	ld	s2,32(sp)
 406:	69e2                	ld	s3,24(sp)
 408:	6121                	add	sp,sp,64
 40a:	8082                	ret
    x = -xx;
 40c:	40b005bb          	negw	a1,a1
    neg = 1;
 410:	4885                	li	a7,1
    x = -xx;
 412:	bf85                	j	382 <printint+0x1a>

0000000000000414 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 414:	715d                	add	sp,sp,-80
 416:	e486                	sd	ra,72(sp)
 418:	e0a2                	sd	s0,64(sp)
 41a:	fc26                	sd	s1,56(sp)
 41c:	f84a                	sd	s2,48(sp)
 41e:	f44e                	sd	s3,40(sp)
 420:	f052                	sd	s4,32(sp)
 422:	ec56                	sd	s5,24(sp)
 424:	e85a                	sd	s6,16(sp)
 426:	e45e                	sd	s7,8(sp)
 428:	e062                	sd	s8,0(sp)
 42a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42c:	0005c903          	lbu	s2,0(a1)
 430:	18090c63          	beqz	s2,5c8 <vprintf+0x1b4>
 434:	8aaa                	mv	s5,a0
 436:	8bb2                	mv	s7,a2
 438:	00158493          	add	s1,a1,1
  state = 0;
 43c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43e:	02500a13          	li	s4,37
 442:	4b55                	li	s6,21
 444:	a839                	j	462 <vprintf+0x4e>
        putc(fd, c);
 446:	85ca                	mv	a1,s2
 448:	8556                	mv	a0,s5
 44a:	00000097          	auipc	ra,0x0
 44e:	efc080e7          	jalr	-260(ra) # 346 <putc>
 452:	a019                	j	458 <vprintf+0x44>
    } else if(state == '%'){
 454:	01498d63          	beq	s3,s4,46e <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 458:	0485                	add	s1,s1,1
 45a:	fff4c903          	lbu	s2,-1(s1)
 45e:	16090563          	beqz	s2,5c8 <vprintf+0x1b4>
    if(state == 0){
 462:	fe0999e3          	bnez	s3,454 <vprintf+0x40>
      if(c == '%'){
 466:	ff4910e3          	bne	s2,s4,446 <vprintf+0x32>
        state = '%';
 46a:	89d2                	mv	s3,s4
 46c:	b7f5                	j	458 <vprintf+0x44>
      if(c == 'd'){
 46e:	13490263          	beq	s2,s4,592 <vprintf+0x17e>
 472:	f9d9079b          	addw	a5,s2,-99
 476:	0ff7f793          	zext.b	a5,a5
 47a:	12fb6563          	bltu	s6,a5,5a4 <vprintf+0x190>
 47e:	f9d9079b          	addw	a5,s2,-99
 482:	0ff7f713          	zext.b	a4,a5
 486:	10eb6f63          	bltu	s6,a4,5a4 <vprintf+0x190>
 48a:	00271793          	sll	a5,a4,0x2
 48e:	00000717          	auipc	a4,0x0
 492:	32a70713          	add	a4,a4,810 # 7b8 <malloc+0xf2>
 496:	97ba                	add	a5,a5,a4
 498:	439c                	lw	a5,0(a5)
 49a:	97ba                	add	a5,a5,a4
 49c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 49e:	008b8913          	add	s2,s7,8
 4a2:	4685                	li	a3,1
 4a4:	4629                	li	a2,10
 4a6:	000ba583          	lw	a1,0(s7)
 4aa:	8556                	mv	a0,s5
 4ac:	00000097          	auipc	ra,0x0
 4b0:	ebc080e7          	jalr	-324(ra) # 368 <printint>
 4b4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b6:	4981                	li	s3,0
 4b8:	b745                	j	458 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ba:	008b8913          	add	s2,s7,8
 4be:	4681                	li	a3,0
 4c0:	4629                	li	a2,10
 4c2:	000ba583          	lw	a1,0(s7)
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	ea0080e7          	jalr	-352(ra) # 368 <printint>
 4d0:	8bca                	mv	s7,s2
      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	b751                	j	458 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4d6:	008b8913          	add	s2,s7,8
 4da:	4681                	li	a3,0
 4dc:	4641                	li	a2,16
 4de:	000ba583          	lw	a1,0(s7)
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	e84080e7          	jalr	-380(ra) # 368 <printint>
 4ec:	8bca                	mv	s7,s2
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b7a5                	j	458 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 4f2:	008b8c13          	add	s8,s7,8
 4f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4fa:	03000593          	li	a1,48
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e46080e7          	jalr	-442(ra) # 346 <putc>
  putc(fd, 'x');
 508:	07800593          	li	a1,120
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e38080e7          	jalr	-456(ra) # 346 <putc>
 516:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	00000b97          	auipc	s7,0x0
 51c:	2f8b8b93          	add	s7,s7,760 # 810 <digits>
 520:	03c9d793          	srl	a5,s3,0x3c
 524:	97de                	add	a5,a5,s7
 526:	0007c583          	lbu	a1,0(a5)
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	e1a080e7          	jalr	-486(ra) # 346 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 534:	0992                	sll	s3,s3,0x4
 536:	397d                	addw	s2,s2,-1
 538:	fe0914e3          	bnez	s2,520 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 53c:	8be2                	mv	s7,s8
      state = 0;
 53e:	4981                	li	s3,0
 540:	bf21                	j	458 <vprintf+0x44>
        s = va_arg(ap, char*);
 542:	008b8993          	add	s3,s7,8
 546:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 54a:	02090163          	beqz	s2,56c <vprintf+0x158>
        while(*s != 0){
 54e:	00094583          	lbu	a1,0(s2)
 552:	c9a5                	beqz	a1,5c2 <vprintf+0x1ae>
          putc(fd, *s);
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	df0080e7          	jalr	-528(ra) # 346 <putc>
          s++;
 55e:	0905                	add	s2,s2,1
        while(*s != 0){
 560:	00094583          	lbu	a1,0(s2)
 564:	f9e5                	bnez	a1,554 <vprintf+0x140>
        s = va_arg(ap, char*);
 566:	8bce                	mv	s7,s3
      state = 0;
 568:	4981                	li	s3,0
 56a:	b5fd                	j	458 <vprintf+0x44>
          s = "(null)";
 56c:	00000917          	auipc	s2,0x0
 570:	24490913          	add	s2,s2,580 # 7b0 <malloc+0xea>
        while(*s != 0){
 574:	02800593          	li	a1,40
 578:	bff1                	j	554 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 57a:	008b8913          	add	s2,s7,8
 57e:	000bc583          	lbu	a1,0(s7)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	dc2080e7          	jalr	-574(ra) # 346 <putc>
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	b5e1                	j	458 <vprintf+0x44>
        putc(fd, c);
 592:	02500593          	li	a1,37
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	dae080e7          	jalr	-594(ra) # 346 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bd5d                	j	458 <vprintf+0x44>
        putc(fd, '%');
 5a4:	02500593          	li	a1,37
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	d9c080e7          	jalr	-612(ra) # 346 <putc>
        putc(fd, c);
 5b2:	85ca                	mv	a1,s2
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	d90080e7          	jalr	-624(ra) # 346 <putc>
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bd61                	j	458 <vprintf+0x44>
        s = va_arg(ap, char*);
 5c2:	8bce                	mv	s7,s3
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bd49                	j	458 <vprintf+0x44>
    }
  }
}
 5c8:	60a6                	ld	ra,72(sp)
 5ca:	6406                	ld	s0,64(sp)
 5cc:	74e2                	ld	s1,56(sp)
 5ce:	7942                	ld	s2,48(sp)
 5d0:	79a2                	ld	s3,40(sp)
 5d2:	7a02                	ld	s4,32(sp)
 5d4:	6ae2                	ld	s5,24(sp)
 5d6:	6b42                	ld	s6,16(sp)
 5d8:	6ba2                	ld	s7,8(sp)
 5da:	6c02                	ld	s8,0(sp)
 5dc:	6161                	add	sp,sp,80
 5de:	8082                	ret

00000000000005e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e0:	715d                	add	sp,sp,-80
 5e2:	ec06                	sd	ra,24(sp)
 5e4:	e822                	sd	s0,16(sp)
 5e6:	1000                	add	s0,sp,32
 5e8:	e010                	sd	a2,0(s0)
 5ea:	e414                	sd	a3,8(s0)
 5ec:	e818                	sd	a4,16(s0)
 5ee:	ec1c                	sd	a5,24(s0)
 5f0:	03043023          	sd	a6,32(s0)
 5f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5fc:	8622                	mv	a2,s0
 5fe:	00000097          	auipc	ra,0x0
 602:	e16080e7          	jalr	-490(ra) # 414 <vprintf>
}
 606:	60e2                	ld	ra,24(sp)
 608:	6442                	ld	s0,16(sp)
 60a:	6161                	add	sp,sp,80
 60c:	8082                	ret

000000000000060e <printf>:

void
printf(const char *fmt, ...)
{
 60e:	711d                	add	sp,sp,-96
 610:	ec06                	sd	ra,24(sp)
 612:	e822                	sd	s0,16(sp)
 614:	1000                	add	s0,sp,32
 616:	e40c                	sd	a1,8(s0)
 618:	e810                	sd	a2,16(s0)
 61a:	ec14                	sd	a3,24(s0)
 61c:	f018                	sd	a4,32(s0)
 61e:	f41c                	sd	a5,40(s0)
 620:	03043823          	sd	a6,48(s0)
 624:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 628:	00840613          	add	a2,s0,8
 62c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 630:	85aa                	mv	a1,a0
 632:	4505                	li	a0,1
 634:	00000097          	auipc	ra,0x0
 638:	de0080e7          	jalr	-544(ra) # 414 <vprintf>
}
 63c:	60e2                	ld	ra,24(sp)
 63e:	6442                	ld	s0,16(sp)
 640:	6125                	add	sp,sp,96
 642:	8082                	ret

0000000000000644 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 644:	1141                	add	sp,sp,-16
 646:	e422                	sd	s0,8(sp)
 648:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	00000797          	auipc	a5,0x0
 652:	1da7b783          	ld	a5,474(a5) # 828 <freep>
 656:	a02d                	j	680 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 658:	4618                	lw	a4,8(a2)
 65a:	9f2d                	addw	a4,a4,a1
 65c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 660:	6398                	ld	a4,0(a5)
 662:	6310                	ld	a2,0(a4)
 664:	a83d                	j	6a2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 666:	ff852703          	lw	a4,-8(a0)
 66a:	9f31                	addw	a4,a4,a2
 66c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 66e:	ff053683          	ld	a3,-16(a0)
 672:	a091                	j	6b6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	6398                	ld	a4,0(a5)
 676:	00e7e463          	bltu	a5,a4,67e <free+0x3a>
 67a:	00e6ea63          	bltu	a3,a4,68e <free+0x4a>
{
 67e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 680:	fed7fae3          	bgeu	a5,a3,674 <free+0x30>
 684:	6398                	ld	a4,0(a5)
 686:	00e6e463          	bltu	a3,a4,68e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	fee7eae3          	bltu	a5,a4,67e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 68e:	ff852583          	lw	a1,-8(a0)
 692:	6390                	ld	a2,0(a5)
 694:	02059813          	sll	a6,a1,0x20
 698:	01c85713          	srl	a4,a6,0x1c
 69c:	9736                	add	a4,a4,a3
 69e:	fae60de3          	beq	a2,a4,658 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6a6:	4790                	lw	a2,8(a5)
 6a8:	02061593          	sll	a1,a2,0x20
 6ac:	01c5d713          	srl	a4,a1,0x1c
 6b0:	973e                	add	a4,a4,a5
 6b2:	fae68ae3          	beq	a3,a4,666 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6b8:	00000717          	auipc	a4,0x0
 6bc:	16f73823          	sd	a5,368(a4) # 828 <freep>
}
 6c0:	6422                	ld	s0,8(sp)
 6c2:	0141                	add	sp,sp,16
 6c4:	8082                	ret

00000000000006c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c6:	7139                	add	sp,sp,-64
 6c8:	fc06                	sd	ra,56(sp)
 6ca:	f822                	sd	s0,48(sp)
 6cc:	f426                	sd	s1,40(sp)
 6ce:	f04a                	sd	s2,32(sp)
 6d0:	ec4e                	sd	s3,24(sp)
 6d2:	e852                	sd	s4,16(sp)
 6d4:	e456                	sd	s5,8(sp)
 6d6:	e05a                	sd	s6,0(sp)
 6d8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6da:	02051493          	sll	s1,a0,0x20
 6de:	9081                	srl	s1,s1,0x20
 6e0:	04bd                	add	s1,s1,15
 6e2:	8091                	srl	s1,s1,0x4
 6e4:	0014899b          	addw	s3,s1,1
 6e8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 6ea:	00000517          	auipc	a0,0x0
 6ee:	13e53503          	ld	a0,318(a0) # 828 <freep>
 6f2:	c515                	beqz	a0,71e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6f6:	4798                	lw	a4,8(a5)
 6f8:	02977f63          	bgeu	a4,s1,736 <malloc+0x70>
  if(nu < 4096)
 6fc:	8a4e                	mv	s4,s3
 6fe:	0009871b          	sext.w	a4,s3
 702:	6685                	lui	a3,0x1
 704:	00d77363          	bgeu	a4,a3,70a <malloc+0x44>
 708:	6a05                	lui	s4,0x1
 70a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 70e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 712:	00000917          	auipc	s2,0x0
 716:	11690913          	add	s2,s2,278 # 828 <freep>
  if(p == (char*)-1)
 71a:	5afd                	li	s5,-1
 71c:	a895                	j	790 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 71e:	00000797          	auipc	a5,0x0
 722:	11278793          	add	a5,a5,274 # 830 <base>
 726:	00000717          	auipc	a4,0x0
 72a:	10f73123          	sd	a5,258(a4) # 828 <freep>
 72e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 730:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 734:	b7e1                	j	6fc <malloc+0x36>
      if(p->s.size == nunits)
 736:	02e48c63          	beq	s1,a4,76e <malloc+0xa8>
        p->s.size -= nunits;
 73a:	4137073b          	subw	a4,a4,s3
 73e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 740:	02071693          	sll	a3,a4,0x20
 744:	01c6d713          	srl	a4,a3,0x1c
 748:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 74a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 74e:	00000717          	auipc	a4,0x0
 752:	0ca73d23          	sd	a0,218(a4) # 828 <freep>
      return (void*)(p + 1);
 756:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 75a:	70e2                	ld	ra,56(sp)
 75c:	7442                	ld	s0,48(sp)
 75e:	74a2                	ld	s1,40(sp)
 760:	7902                	ld	s2,32(sp)
 762:	69e2                	ld	s3,24(sp)
 764:	6a42                	ld	s4,16(sp)
 766:	6aa2                	ld	s5,8(sp)
 768:	6b02                	ld	s6,0(sp)
 76a:	6121                	add	sp,sp,64
 76c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	e118                	sd	a4,0(a0)
 772:	bff1                	j	74e <malloc+0x88>
  hp->s.size = nu;
 774:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 778:	0541                	add	a0,a0,16
 77a:	00000097          	auipc	ra,0x0
 77e:	eca080e7          	jalr	-310(ra) # 644 <free>
  return freep;
 782:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 786:	d971                	beqz	a0,75a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78a:	4798                	lw	a4,8(a5)
 78c:	fa9775e3          	bgeu	a4,s1,736 <malloc+0x70>
    if(p == freep)
 790:	00093703          	ld	a4,0(s2)
 794:	853e                	mv	a0,a5
 796:	fef719e3          	bne	a4,a5,788 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 79a:	8552                	mv	a0,s4
 79c:	00000097          	auipc	ra,0x0
 7a0:	b82080e7          	jalr	-1150(ra) # 31e <sbrk>
  if(p == (char*)-1)
 7a4:	fd5518e3          	bne	a0,s5,774 <malloc+0xae>
        return 0;
 7a8:	4501                	li	a0,0
 7aa:	bf45                	j	75a <malloc+0x94>
