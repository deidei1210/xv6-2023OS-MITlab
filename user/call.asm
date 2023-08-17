
user/_call:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
  return x+3;
}
   6:	250d                	addw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	add	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	add	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	add	s0,sp,16
  return g(x);
}
  14:	250d                	addw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	add	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	add	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	add	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	7a050513          	add	a0,a0,1952 # 7c8 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	5f6080e7          	jalr	1526(ra) # 626 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	274080e7          	jalr	628(ra) # 2ae <exit>

0000000000000042 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  42:	1141                	add	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	add	a1,a1,1
  4c:	0785                	add	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	add	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	add	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	add	a0,a0,1
  74:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	add	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	add	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	add	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	86be                	mv	a3,a5
  9c:	0785                	add	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	ff65                	bnez	a4,9a <strlen+0x10>
  a4:	40a6853b          	subw	a0,a3,a0
  a8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	add	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	add	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1c>
  bc:	87aa                	mv	a5,a0
  be:	1602                	sll	a2,a2,0x20
  c0:	9201                	srl	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	add	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x12>
  }
  return dst;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	add	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	add	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	add	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb99                	beqz	a5,f6 <strchr+0x20>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1a>
  for(; *s; s++)
  e6:	0505                	add	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xc>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strchr+0x1a>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	add	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	1080                	add	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 118:	4aa9                	li	s5,10
 11a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11c:	89a6                	mv	s3,s1
 11e:	2485                	addw	s1,s1,1
 120:	0344d863          	bge	s1,s4,150 <gets+0x56>
    cc = read(0, &c, 1);
 124:	4605                	li	a2,1
 126:	faf40593          	add	a1,s0,-81
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	19a080e7          	jalr	410(ra) # 2c6 <read>
    if(cc < 1)
 134:	00a05e63          	blez	a0,150 <gets+0x56>
    buf[i++] = c;
 138:	faf44783          	lbu	a5,-81(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	01578763          	beq	a5,s5,14e <gets+0x54>
 144:	0905                	add	s2,s2,1
 146:	fd679be3          	bne	a5,s6,11c <gets+0x22>
  for(i=0; i+1 < max; ){
 14a:	89a6                	mv	s3,s1
 14c:	a011                	j	150 <gets+0x56>
 14e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 150:	99de                	add	s3,s3,s7
 152:	00098023          	sb	zero,0(s3)
  return buf;
}
 156:	855e                	mv	a0,s7
 158:	60e6                	ld	ra,88(sp)
 15a:	6446                	ld	s0,80(sp)
 15c:	64a6                	ld	s1,72(sp)
 15e:	6906                	ld	s2,64(sp)
 160:	79e2                	ld	s3,56(sp)
 162:	7a42                	ld	s4,48(sp)
 164:	7aa2                	ld	s5,40(sp)
 166:	7b02                	ld	s6,32(sp)
 168:	6be2                	ld	s7,24(sp)
 16a:	6125                	add	sp,sp,96
 16c:	8082                	ret

000000000000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	1101                	add	sp,sp,-32
 170:	ec06                	sd	ra,24(sp)
 172:	e822                	sd	s0,16(sp)
 174:	e426                	sd	s1,8(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	add	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	170080e7          	jalr	368(ra) # 2ee <open>
  if(fd < 0)
 186:	02054563          	bltz	a0,1b0 <stat+0x42>
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	00000097          	auipc	ra,0x0
 192:	178080e7          	jalr	376(ra) # 306 <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	13c080e7          	jalr	316(ra) # 2d6 <close>
  return r;
}
 1a2:	854a                	mv	a0,s2
 1a4:	60e2                	ld	ra,24(sp)
 1a6:	6442                	ld	s0,16(sp)
 1a8:	64a2                	ld	s1,8(sp)
 1aa:	6902                	ld	s2,0(sp)
 1ac:	6105                	add	sp,sp,32
 1ae:	8082                	ret
    return -1;
 1b0:	597d                	li	s2,-1
 1b2:	bfc5                	j	1a2 <stat+0x34>

00000000000001b4 <atoi>:

int
atoi(const char *s)
{
 1b4:	1141                	add	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ba:	00054683          	lbu	a3,0(a0)
 1be:	fd06879b          	addw	a5,a3,-48
 1c2:	0ff7f793          	zext.b	a5,a5
 1c6:	4625                	li	a2,9
 1c8:	02f66863          	bltu	a2,a5,1f8 <atoi+0x44>
 1cc:	872a                	mv	a4,a0
  n = 0;
 1ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d0:	0705                	add	a4,a4,1
 1d2:	0025179b          	sllw	a5,a0,0x2
 1d6:	9fa9                	addw	a5,a5,a0
 1d8:	0017979b          	sllw	a5,a5,0x1
 1dc:	9fb5                	addw	a5,a5,a3
 1de:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e2:	00074683          	lbu	a3,0(a4)
 1e6:	fd06879b          	addw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	fef671e3          	bgeu	a2,a5,1d0 <atoi+0x1c>
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	add	sp,sp,16
 1f6:	8082                	ret
  n = 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <atoi+0x3e>

00000000000001fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 202:	02b57463          	bgeu	a0,a1,22a <memmove+0x2e>
    while(n-- > 0)
 206:	00c05f63          	blez	a2,224 <memmove+0x28>
 20a:	1602                	sll	a2,a2,0x20
 20c:	9201                	srl	a2,a2,0x20
 20e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	add	a1,a1,1
 216:	0705                	add	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	add	sp,sp,16
 228:	8082                	ret
    dst += n;
 22a:	00c50733          	add	a4,a0,a2
    src += n;
 22e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 230:	fec05ae3          	blez	a2,224 <memmove+0x28>
 234:	fff6079b          	addw	a5,a2,-1
 238:	1782                	sll	a5,a5,0x20
 23a:	9381                	srl	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	add	a1,a1,-1
 244:	177d                	add	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x46>
 252:	bfc9                	j	224 <memmove+0x28>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	add	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	ca05                	beqz	a2,28a <memcmp+0x36>
 25c:	fff6069b          	addw	a3,a2,-1
 260:	1682                	sll	a3,a3,0x20
 262:	9281                	srl	a3,a3,0x20
 264:	0685                	add	a3,a3,1
 266:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 268:	00054783          	lbu	a5,0(a0)
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00e79863          	bne	a5,a4,280 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	add	a0,a0,1
    p2++;
 276:	0585                	add	a1,a1,1
  while (n-- > 0) {
 278:	fed518e3          	bne	a0,a3,268 <memcmp+0x14>
  }
  return 0;
 27c:	4501                	li	a0,0
 27e:	a019                	j	284 <memcmp+0x30>
      return *p1 - *p2;
 280:	40e7853b          	subw	a0,a5,a4
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	add	sp,sp,16
 288:	8082                	ret
  return 0;
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <memcmp+0x30>

000000000000028e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28e:	1141                	add	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 296:	00000097          	auipc	ra,0x0
 29a:	f66080e7          	jalr	-154(ra) # 1fc <memmove>
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	add	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a6:	4885                	li	a7,1
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ae:	4889                	li	a7,2
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b6:	488d                	li	a7,3
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2be:	4891                	li	a7,4
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <read>:
.global read
read:
 li a7, SYS_read
 2c6:	4895                	li	a7,5
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <write>:
.global write
write:
 li a7, SYS_write
 2ce:	48c1                	li	a7,16
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <close>:
.global close
close:
 li a7, SYS_close
 2d6:	48d5                	li	a7,21
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <kill>:
.global kill
kill:
 li a7, SYS_kill
 2de:	4899                	li	a7,6
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e6:	489d                	li	a7,7
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <open>:
.global open
open:
 li a7, SYS_open
 2ee:	48bd                	li	a7,15
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f6:	48c5                	li	a7,17
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fe:	48c9                	li	a7,18
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 306:	48a1                	li	a7,8
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <link>:
.global link
link:
 li a7, SYS_link
 30e:	48cd                	li	a7,19
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 316:	48d1                	li	a7,20
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31e:	48a5                	li	a7,9
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <dup>:
.global dup
dup:
 li a7, SYS_dup
 326:	48a9                	li	a7,10
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32e:	48ad                	li	a7,11
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 336:	48b1                	li	a7,12
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33e:	48b5                	li	a7,13
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 346:	48b9                	li	a7,14
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 34e:	48d9                	li	a7,22
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 356:	48dd                	li	a7,23
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35e:	1101                	add	sp,sp,-32
 360:	ec06                	sd	ra,24(sp)
 362:	e822                	sd	s0,16(sp)
 364:	1000                	add	s0,sp,32
 366:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36a:	4605                	li	a2,1
 36c:	fef40593          	add	a1,s0,-17
 370:	00000097          	auipc	ra,0x0
 374:	f5e080e7          	jalr	-162(ra) # 2ce <write>
}
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	6105                	add	sp,sp,32
 37e:	8082                	ret

0000000000000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	7139                	add	sp,sp,-64
 382:	fc06                	sd	ra,56(sp)
 384:	f822                	sd	s0,48(sp)
 386:	f426                	sd	s1,40(sp)
 388:	f04a                	sd	s2,32(sp)
 38a:	ec4e                	sd	s3,24(sp)
 38c:	0080                	add	s0,sp,64
 38e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 390:	c299                	beqz	a3,396 <printint+0x16>
 392:	0805c963          	bltz	a1,424 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 396:	2581                	sext.w	a1,a1
  neg = 0;
 398:	4881                	li	a7,0
 39a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 39e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a0:	2601                	sext.w	a2,a2
 3a2:	00000517          	auipc	a0,0x0
 3a6:	48e50513          	add	a0,a0,1166 # 830 <digits>
 3aa:	883a                	mv	a6,a4
 3ac:	2705                	addw	a4,a4,1
 3ae:	02c5f7bb          	remuw	a5,a1,a2
 3b2:	1782                	sll	a5,a5,0x20
 3b4:	9381                	srl	a5,a5,0x20
 3b6:	97aa                	add	a5,a5,a0
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c0:	0005879b          	sext.w	a5,a1
 3c4:	02c5d5bb          	divuw	a1,a1,a2
 3c8:	0685                	add	a3,a3,1
 3ca:	fec7f0e3          	bgeu	a5,a2,3aa <printint+0x2a>
  if(neg)
 3ce:	00088c63          	beqz	a7,3e6 <printint+0x66>
    buf[i++] = '-';
 3d2:	fd070793          	add	a5,a4,-48
 3d6:	00878733          	add	a4,a5,s0
 3da:	02d00793          	li	a5,45
 3de:	fef70823          	sb	a5,-16(a4)
 3e2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3e6:	02e05863          	blez	a4,416 <printint+0x96>
 3ea:	fc040793          	add	a5,s0,-64
 3ee:	00e78933          	add	s2,a5,a4
 3f2:	fff78993          	add	s3,a5,-1
 3f6:	99ba                	add	s3,s3,a4
 3f8:	377d                	addw	a4,a4,-1
 3fa:	1702                	sll	a4,a4,0x20
 3fc:	9301                	srl	a4,a4,0x20
 3fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 402:	fff94583          	lbu	a1,-1(s2)
 406:	8526                	mv	a0,s1
 408:	00000097          	auipc	ra,0x0
 40c:	f56080e7          	jalr	-170(ra) # 35e <putc>
  while(--i >= 0)
 410:	197d                	add	s2,s2,-1
 412:	ff3918e3          	bne	s2,s3,402 <printint+0x82>
}
 416:	70e2                	ld	ra,56(sp)
 418:	7442                	ld	s0,48(sp)
 41a:	74a2                	ld	s1,40(sp)
 41c:	7902                	ld	s2,32(sp)
 41e:	69e2                	ld	s3,24(sp)
 420:	6121                	add	sp,sp,64
 422:	8082                	ret
    x = -xx;
 424:	40b005bb          	negw	a1,a1
    neg = 1;
 428:	4885                	li	a7,1
    x = -xx;
 42a:	bf85                	j	39a <printint+0x1a>

000000000000042c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42c:	715d                	add	sp,sp,-80
 42e:	e486                	sd	ra,72(sp)
 430:	e0a2                	sd	s0,64(sp)
 432:	fc26                	sd	s1,56(sp)
 434:	f84a                	sd	s2,48(sp)
 436:	f44e                	sd	s3,40(sp)
 438:	f052                	sd	s4,32(sp)
 43a:	ec56                	sd	s5,24(sp)
 43c:	e85a                	sd	s6,16(sp)
 43e:	e45e                	sd	s7,8(sp)
 440:	e062                	sd	s8,0(sp)
 442:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 444:	0005c903          	lbu	s2,0(a1)
 448:	18090c63          	beqz	s2,5e0 <vprintf+0x1b4>
 44c:	8aaa                	mv	s5,a0
 44e:	8bb2                	mv	s7,a2
 450:	00158493          	add	s1,a1,1
  state = 0;
 454:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 456:	02500a13          	li	s4,37
 45a:	4b55                	li	s6,21
 45c:	a839                	j	47a <vprintf+0x4e>
        putc(fd, c);
 45e:	85ca                	mv	a1,s2
 460:	8556                	mv	a0,s5
 462:	00000097          	auipc	ra,0x0
 466:	efc080e7          	jalr	-260(ra) # 35e <putc>
 46a:	a019                	j	470 <vprintf+0x44>
    } else if(state == '%'){
 46c:	01498d63          	beq	s3,s4,486 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 470:	0485                	add	s1,s1,1
 472:	fff4c903          	lbu	s2,-1(s1)
 476:	16090563          	beqz	s2,5e0 <vprintf+0x1b4>
    if(state == 0){
 47a:	fe0999e3          	bnez	s3,46c <vprintf+0x40>
      if(c == '%'){
 47e:	ff4910e3          	bne	s2,s4,45e <vprintf+0x32>
        state = '%';
 482:	89d2                	mv	s3,s4
 484:	b7f5                	j	470 <vprintf+0x44>
      if(c == 'd'){
 486:	13490263          	beq	s2,s4,5aa <vprintf+0x17e>
 48a:	f9d9079b          	addw	a5,s2,-99
 48e:	0ff7f793          	zext.b	a5,a5
 492:	12fb6563          	bltu	s6,a5,5bc <vprintf+0x190>
 496:	f9d9079b          	addw	a5,s2,-99
 49a:	0ff7f713          	zext.b	a4,a5
 49e:	10eb6f63          	bltu	s6,a4,5bc <vprintf+0x190>
 4a2:	00271793          	sll	a5,a4,0x2
 4a6:	00000717          	auipc	a4,0x0
 4aa:	33270713          	add	a4,a4,818 # 7d8 <malloc+0xfa>
 4ae:	97ba                	add	a5,a5,a4
 4b0:	439c                	lw	a5,0(a5)
 4b2:	97ba                	add	a5,a5,a4
 4b4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4b6:	008b8913          	add	s2,s7,8
 4ba:	4685                	li	a3,1
 4bc:	4629                	li	a2,10
 4be:	000ba583          	lw	a1,0(s7)
 4c2:	8556                	mv	a0,s5
 4c4:	00000097          	auipc	ra,0x0
 4c8:	ebc080e7          	jalr	-324(ra) # 380 <printint>
 4cc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	b745                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d2:	008b8913          	add	s2,s7,8
 4d6:	4681                	li	a3,0
 4d8:	4629                	li	a2,10
 4da:	000ba583          	lw	a1,0(s7)
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	ea0080e7          	jalr	-352(ra) # 380 <printint>
 4e8:	8bca                	mv	s7,s2
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	b751                	j	470 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4ee:	008b8913          	add	s2,s7,8
 4f2:	4681                	li	a3,0
 4f4:	4641                	li	a2,16
 4f6:	000ba583          	lw	a1,0(s7)
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e84080e7          	jalr	-380(ra) # 380 <printint>
 504:	8bca                	mv	s7,s2
      state = 0;
 506:	4981                	li	s3,0
 508:	b7a5                	j	470 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 50a:	008b8c13          	add	s8,s7,8
 50e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 512:	03000593          	li	a1,48
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e46080e7          	jalr	-442(ra) # 35e <putc>
  putc(fd, 'x');
 520:	07800593          	li	a1,120
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e38080e7          	jalr	-456(ra) # 35e <putc>
 52e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 530:	00000b97          	auipc	s7,0x0
 534:	300b8b93          	add	s7,s7,768 # 830 <digits>
 538:	03c9d793          	srl	a5,s3,0x3c
 53c:	97de                	add	a5,a5,s7
 53e:	0007c583          	lbu	a1,0(a5)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e1a080e7          	jalr	-486(ra) # 35e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 54c:	0992                	sll	s3,s3,0x4
 54e:	397d                	addw	s2,s2,-1
 550:	fe0914e3          	bnez	s2,538 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 554:	8be2                	mv	s7,s8
      state = 0;
 556:	4981                	li	s3,0
 558:	bf21                	j	470 <vprintf+0x44>
        s = va_arg(ap, char*);
 55a:	008b8993          	add	s3,s7,8
 55e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 562:	02090163          	beqz	s2,584 <vprintf+0x158>
        while(*s != 0){
 566:	00094583          	lbu	a1,0(s2)
 56a:	c9a5                	beqz	a1,5da <vprintf+0x1ae>
          putc(fd, *s);
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	df0080e7          	jalr	-528(ra) # 35e <putc>
          s++;
 576:	0905                	add	s2,s2,1
        while(*s != 0){
 578:	00094583          	lbu	a1,0(s2)
 57c:	f9e5                	bnez	a1,56c <vprintf+0x140>
        s = va_arg(ap, char*);
 57e:	8bce                	mv	s7,s3
      state = 0;
 580:	4981                	li	s3,0
 582:	b5fd                	j	470 <vprintf+0x44>
          s = "(null)";
 584:	00000917          	auipc	s2,0x0
 588:	24c90913          	add	s2,s2,588 # 7d0 <malloc+0xf2>
        while(*s != 0){
 58c:	02800593          	li	a1,40
 590:	bff1                	j	56c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 592:	008b8913          	add	s2,s7,8
 596:	000bc583          	lbu	a1,0(s7)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	dc2080e7          	jalr	-574(ra) # 35e <putc>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b5e1                	j	470 <vprintf+0x44>
        putc(fd, c);
 5aa:	02500593          	li	a1,37
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	dae080e7          	jalr	-594(ra) # 35e <putc>
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bd5d                	j	470 <vprintf+0x44>
        putc(fd, '%');
 5bc:	02500593          	li	a1,37
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	d9c080e7          	jalr	-612(ra) # 35e <putc>
        putc(fd, c);
 5ca:	85ca                	mv	a1,s2
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	d90080e7          	jalr	-624(ra) # 35e <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd61                	j	470 <vprintf+0x44>
        s = va_arg(ap, char*);
 5da:	8bce                	mv	s7,s3
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bd49                	j	470 <vprintf+0x44>
    }
  }
}
 5e0:	60a6                	ld	ra,72(sp)
 5e2:	6406                	ld	s0,64(sp)
 5e4:	74e2                	ld	s1,56(sp)
 5e6:	7942                	ld	s2,48(sp)
 5e8:	79a2                	ld	s3,40(sp)
 5ea:	7a02                	ld	s4,32(sp)
 5ec:	6ae2                	ld	s5,24(sp)
 5ee:	6b42                	ld	s6,16(sp)
 5f0:	6ba2                	ld	s7,8(sp)
 5f2:	6c02                	ld	s8,0(sp)
 5f4:	6161                	add	sp,sp,80
 5f6:	8082                	ret

00000000000005f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5f8:	715d                	add	sp,sp,-80
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	add	s0,sp,32
 600:	e010                	sd	a2,0(s0)
 602:	e414                	sd	a3,8(s0)
 604:	e818                	sd	a4,16(s0)
 606:	ec1c                	sd	a5,24(s0)
 608:	03043023          	sd	a6,32(s0)
 60c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 610:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 614:	8622                	mv	a2,s0
 616:	00000097          	auipc	ra,0x0
 61a:	e16080e7          	jalr	-490(ra) # 42c <vprintf>
}
 61e:	60e2                	ld	ra,24(sp)
 620:	6442                	ld	s0,16(sp)
 622:	6161                	add	sp,sp,80
 624:	8082                	ret

0000000000000626 <printf>:

void
printf(const char *fmt, ...)
{
 626:	711d                	add	sp,sp,-96
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	1000                	add	s0,sp,32
 62e:	e40c                	sd	a1,8(s0)
 630:	e810                	sd	a2,16(s0)
 632:	ec14                	sd	a3,24(s0)
 634:	f018                	sd	a4,32(s0)
 636:	f41c                	sd	a5,40(s0)
 638:	03043823          	sd	a6,48(s0)
 63c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 640:	00840613          	add	a2,s0,8
 644:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 648:	85aa                	mv	a1,a0
 64a:	4505                	li	a0,1
 64c:	00000097          	auipc	ra,0x0
 650:	de0080e7          	jalr	-544(ra) # 42c <vprintf>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6125                	add	sp,sp,96
 65a:	8082                	ret

000000000000065c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65c:	1141                	add	sp,sp,-16
 65e:	e422                	sd	s0,8(sp)
 660:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 662:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 666:	00000797          	auipc	a5,0x0
 66a:	1e27b783          	ld	a5,482(a5) # 848 <freep>
 66e:	a02d                	j	698 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 670:	4618                	lw	a4,8(a2)
 672:	9f2d                	addw	a4,a4,a1
 674:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	6398                	ld	a4,0(a5)
 67a:	6310                	ld	a2,0(a4)
 67c:	a83d                	j	6ba <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 67e:	ff852703          	lw	a4,-8(a0)
 682:	9f31                	addw	a4,a4,a2
 684:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 686:	ff053683          	ld	a3,-16(a0)
 68a:	a091                	j	6ce <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68c:	6398                	ld	a4,0(a5)
 68e:	00e7e463          	bltu	a5,a4,696 <free+0x3a>
 692:	00e6ea63          	bltu	a3,a4,6a6 <free+0x4a>
{
 696:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 698:	fed7fae3          	bgeu	a5,a3,68c <free+0x30>
 69c:	6398                	ld	a4,0(a5)
 69e:	00e6e463          	bltu	a3,a4,6a6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a2:	fee7eae3          	bltu	a5,a4,696 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6a6:	ff852583          	lw	a1,-8(a0)
 6aa:	6390                	ld	a2,0(a5)
 6ac:	02059813          	sll	a6,a1,0x20
 6b0:	01c85713          	srl	a4,a6,0x1c
 6b4:	9736                	add	a4,a4,a3
 6b6:	fae60de3          	beq	a2,a4,670 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6be:	4790                	lw	a2,8(a5)
 6c0:	02061593          	sll	a1,a2,0x20
 6c4:	01c5d713          	srl	a4,a1,0x1c
 6c8:	973e                	add	a4,a4,a5
 6ca:	fae68ae3          	beq	a3,a4,67e <free+0x22>
    p->s.ptr = bp->s.ptr;
 6ce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d0:	00000717          	auipc	a4,0x0
 6d4:	16f73c23          	sd	a5,376(a4) # 848 <freep>
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	add	sp,sp,16
 6dc:	8082                	ret

00000000000006de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6de:	7139                	add	sp,sp,-64
 6e0:	fc06                	sd	ra,56(sp)
 6e2:	f822                	sd	s0,48(sp)
 6e4:	f426                	sd	s1,40(sp)
 6e6:	f04a                	sd	s2,32(sp)
 6e8:	ec4e                	sd	s3,24(sp)
 6ea:	e852                	sd	s4,16(sp)
 6ec:	e456                	sd	s5,8(sp)
 6ee:	e05a                	sd	s6,0(sp)
 6f0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	02051493          	sll	s1,a0,0x20
 6f6:	9081                	srl	s1,s1,0x20
 6f8:	04bd                	add	s1,s1,15
 6fa:	8091                	srl	s1,s1,0x4
 6fc:	0014899b          	addw	s3,s1,1
 700:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 702:	00000517          	auipc	a0,0x0
 706:	14653503          	ld	a0,326(a0) # 848 <freep>
 70a:	c515                	beqz	a0,736 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 70e:	4798                	lw	a4,8(a5)
 710:	02977f63          	bgeu	a4,s1,74e <malloc+0x70>
  if(nu < 4096)
 714:	8a4e                	mv	s4,s3
 716:	0009871b          	sext.w	a4,s3
 71a:	6685                	lui	a3,0x1
 71c:	00d77363          	bgeu	a4,a3,722 <malloc+0x44>
 720:	6a05                	lui	s4,0x1
 722:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 726:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 72a:	00000917          	auipc	s2,0x0
 72e:	11e90913          	add	s2,s2,286 # 848 <freep>
  if(p == (char*)-1)
 732:	5afd                	li	s5,-1
 734:	a895                	j	7a8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 736:	00000797          	auipc	a5,0x0
 73a:	11a78793          	add	a5,a5,282 # 850 <base>
 73e:	00000717          	auipc	a4,0x0
 742:	10f73523          	sd	a5,266(a4) # 848 <freep>
 746:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 748:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 74c:	b7e1                	j	714 <malloc+0x36>
      if(p->s.size == nunits)
 74e:	02e48c63          	beq	s1,a4,786 <malloc+0xa8>
        p->s.size -= nunits;
 752:	4137073b          	subw	a4,a4,s3
 756:	c798                	sw	a4,8(a5)
        p += p->s.size;
 758:	02071693          	sll	a3,a4,0x20
 75c:	01c6d713          	srl	a4,a3,0x1c
 760:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 762:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 766:	00000717          	auipc	a4,0x0
 76a:	0ea73123          	sd	a0,226(a4) # 848 <freep>
      return (void*)(p + 1);
 76e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 772:	70e2                	ld	ra,56(sp)
 774:	7442                	ld	s0,48(sp)
 776:	74a2                	ld	s1,40(sp)
 778:	7902                	ld	s2,32(sp)
 77a:	69e2                	ld	s3,24(sp)
 77c:	6a42                	ld	s4,16(sp)
 77e:	6aa2                	ld	s5,8(sp)
 780:	6b02                	ld	s6,0(sp)
 782:	6121                	add	sp,sp,64
 784:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 786:	6398                	ld	a4,0(a5)
 788:	e118                	sd	a4,0(a0)
 78a:	bff1                	j	766 <malloc+0x88>
  hp->s.size = nu;
 78c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 790:	0541                	add	a0,a0,16
 792:	00000097          	auipc	ra,0x0
 796:	eca080e7          	jalr	-310(ra) # 65c <free>
  return freep;
 79a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 79e:	d971                	beqz	a0,772 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a2:	4798                	lw	a4,8(a5)
 7a4:	fa9775e3          	bgeu	a4,s1,74e <malloc+0x70>
    if(p == freep)
 7a8:	00093703          	ld	a4,0(s2)
 7ac:	853e                	mv	a0,a5
 7ae:	fef719e3          	bne	a4,a5,7a0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7b2:	8552                	mv	a0,s4
 7b4:	00000097          	auipc	ra,0x0
 7b8:	b82080e7          	jalr	-1150(ra) # 336 <sbrk>
  if(p == (char*)-1)
 7bc:	fd5518e3          	bne	a0,s5,78c <malloc+0xae>
        return 0;
 7c0:	4501                	li	a0,0
 7c2:	bf45                	j	772 <malloc+0x94>
