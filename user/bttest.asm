
user/_bttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  sleep(1);
   8:	4505                	li	a0,1
   a:	00000097          	auipc	ra,0x0
   e:	30e080e7          	jalr	782(ra) # 318 <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	274080e7          	jalr	628(ra) # 288 <exit>

000000000000001c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	add	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  22:	87aa                	mv	a5,a0
  24:	0585                	add	a1,a1,1
  26:	0785                	add	a5,a5,1
  28:	fff5c703          	lbu	a4,-1(a1)
  2c:	fee78fa3          	sb	a4,-1(a5)
  30:	fb75                	bnez	a4,24 <strcpy+0x8>
    ;
  return os;
}
  32:	6422                	ld	s0,8(sp)
  34:	0141                	add	sp,sp,16
  36:	8082                	ret

0000000000000038 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  38:	1141                	add	sp,sp,-16
  3a:	e422                	sd	s0,8(sp)
  3c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  3e:	00054783          	lbu	a5,0(a0)
  42:	cb91                	beqz	a5,56 <strcmp+0x1e>
  44:	0005c703          	lbu	a4,0(a1)
  48:	00f71763          	bne	a4,a5,56 <strcmp+0x1e>
    p++, q++;
  4c:	0505                	add	a0,a0,1
  4e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	fbe5                	bnez	a5,44 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  56:	0005c503          	lbu	a0,0(a1)
}
  5a:	40a7853b          	subw	a0,a5,a0
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	add	sp,sp,16
  62:	8082                	ret

0000000000000064 <strlen>:

uint
strlen(const char *s)
{
  64:	1141                	add	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cf91                	beqz	a5,8a <strlen+0x26>
  70:	0505                	add	a0,a0,1
  72:	87aa                	mv	a5,a0
  74:	86be                	mv	a3,a5
  76:	0785                	add	a5,a5,1
  78:	fff7c703          	lbu	a4,-1(a5)
  7c:	ff65                	bnez	a4,74 <strlen+0x10>
  7e:	40a6853b          	subw	a0,a3,a0
  82:	2505                	addw	a0,a0,1
    ;
  return n;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	add	sp,sp,16
  88:	8082                	ret
  for(n = 0; s[n]; n++)
  8a:	4501                	li	a0,0
  8c:	bfe5                	j	84 <strlen+0x20>

000000000000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	1141                	add	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  94:	ca19                	beqz	a2,aa <memset+0x1c>
  96:	87aa                	mv	a5,a0
  98:	1602                	sll	a2,a2,0x20
  9a:	9201                	srl	a2,a2,0x20
  9c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a4:	0785                	add	a5,a5,1
  a6:	fee79de3          	bne	a5,a4,a0 <memset+0x12>
  }
  return dst;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	add	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strchr>:

char*
strchr(const char *s, char c)
{
  b0:	1141                	add	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	add	s0,sp,16
  for(; *s; s++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb99                	beqz	a5,d0 <strchr+0x20>
    if(*s == c)
  bc:	00f58763          	beq	a1,a5,ca <strchr+0x1a>
  for(; *s; s++)
  c0:	0505                	add	a0,a0,1
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbfd                	bnez	a5,bc <strchr+0xc>
      return (char*)s;
  return 0;
  c8:	4501                	li	a0,0
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	add	sp,sp,16
  ce:	8082                	ret
  return 0;
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strchr+0x1a>

00000000000000d4 <gets>:

char*
gets(char *buf, int max)
{
  d4:	711d                	add	sp,sp,-96
  d6:	ec86                	sd	ra,88(sp)
  d8:	e8a2                	sd	s0,80(sp)
  da:	e4a6                	sd	s1,72(sp)
  dc:	e0ca                	sd	s2,64(sp)
  de:	fc4e                	sd	s3,56(sp)
  e0:	f852                	sd	s4,48(sp)
  e2:	f456                	sd	s5,40(sp)
  e4:	f05a                	sd	s6,32(sp)
  e6:	ec5e                	sd	s7,24(sp)
  e8:	1080                	add	s0,sp,96
  ea:	8baa                	mv	s7,a0
  ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ee:	892a                	mv	s2,a0
  f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f2:	4aa9                	li	s5,10
  f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  f6:	89a6                	mv	s3,s1
  f8:	2485                	addw	s1,s1,1
  fa:	0344d863          	bge	s1,s4,12a <gets+0x56>
    cc = read(0, &c, 1);
  fe:	4605                	li	a2,1
 100:	faf40593          	add	a1,s0,-81
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	19a080e7          	jalr	410(ra) # 2a0 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x56>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x54>
 11e:	0905                	add	s2,s2,1
 120:	fd679be3          	bne	a5,s6,f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x56>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	add	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	add	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e426                	sd	s1,8(sp)
 150:	e04a                	sd	s2,0(sp)
 152:	1000                	add	s0,sp,32
 154:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 156:	4581                	li	a1,0
 158:	00000097          	auipc	ra,0x0
 15c:	170080e7          	jalr	368(ra) # 2c8 <open>
  if(fd < 0)
 160:	02054563          	bltz	a0,18a <stat+0x42>
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	00000097          	auipc	ra,0x0
 16c:	178080e7          	jalr	376(ra) # 2e0 <fstat>
 170:	892a                	mv	s2,a0
  close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	13c080e7          	jalr	316(ra) # 2b0 <close>
  return r;
}
 17c:	854a                	mv	a0,s2
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	64a2                	ld	s1,8(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	add	sp,sp,32
 188:	8082                	ret
    return -1;
 18a:	597d                	li	s2,-1
 18c:	bfc5                	j	17c <stat+0x34>

000000000000018e <atoi>:

int
atoi(const char *s)
{
 18e:	1141                	add	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054683          	lbu	a3,0(a0)
 198:	fd06879b          	addw	a5,a3,-48
 19c:	0ff7f793          	zext.b	a5,a5
 1a0:	4625                	li	a2,9
 1a2:	02f66863          	bltu	a2,a5,1d2 <atoi+0x44>
 1a6:	872a                	mv	a4,a0
  n = 0;
 1a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1aa:	0705                	add	a4,a4,1
 1ac:	0025179b          	sllw	a5,a0,0x2
 1b0:	9fa9                	addw	a5,a5,a0
 1b2:	0017979b          	sllw	a5,a5,0x1
 1b6:	9fb5                	addw	a5,a5,a3
 1b8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1bc:	00074683          	lbu	a3,0(a4)
 1c0:	fd06879b          	addw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	fef671e3          	bgeu	a2,a5,1aa <atoi+0x1c>
  return n;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	add	sp,sp,16
 1d0:	8082                	ret
  n = 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <atoi+0x3e>

00000000000001d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d6:	1141                	add	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1dc:	02b57463          	bgeu	a0,a1,204 <memmove+0x2e>
    while(n-- > 0)
 1e0:	00c05f63          	blez	a2,1fe <memmove+0x28>
 1e4:	1602                	sll	a2,a2,0x20
 1e6:	9201                	srl	a2,a2,0x20
 1e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ee:	0585                	add	a1,a1,1
 1f0:	0705                	add	a4,a4,1
 1f2:	fff5c683          	lbu	a3,-1(a1)
 1f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fa:	fee79ae3          	bne	a5,a4,1ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	add	sp,sp,16
 202:	8082                	ret
    dst += n;
 204:	00c50733          	add	a4,a0,a2
    src += n;
 208:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20a:	fec05ae3          	blez	a2,1fe <memmove+0x28>
 20e:	fff6079b          	addw	a5,a2,-1
 212:	1782                	sll	a5,a5,0x20
 214:	9381                	srl	a5,a5,0x20
 216:	fff7c793          	not	a5,a5
 21a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21c:	15fd                	add	a1,a1,-1
 21e:	177d                	add	a4,a4,-1
 220:	0005c683          	lbu	a3,0(a1)
 224:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x46>
 22c:	bfc9                	j	1fe <memmove+0x28>

000000000000022e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22e:	1141                	add	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 234:	ca05                	beqz	a2,264 <memcmp+0x36>
 236:	fff6069b          	addw	a3,a2,-1
 23a:	1682                	sll	a3,a3,0x20
 23c:	9281                	srl	a3,a3,0x20
 23e:	0685                	add	a3,a3,1
 240:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 242:	00054783          	lbu	a5,0(a0)
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00e79863          	bne	a5,a4,25a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24e:	0505                	add	a0,a0,1
    p2++;
 250:	0585                	add	a1,a1,1
  while (n-- > 0) {
 252:	fed518e3          	bne	a0,a3,242 <memcmp+0x14>
  }
  return 0;
 256:	4501                	li	a0,0
 258:	a019                	j	25e <memcmp+0x30>
      return *p1 - *p2;
 25a:	40e7853b          	subw	a0,a5,a4
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	add	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <memcmp+0x30>

0000000000000268 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 268:	1141                	add	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 270:	00000097          	auipc	ra,0x0
 274:	f66080e7          	jalr	-154(ra) # 1d6 <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	add	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 330:	48dd                	li	a7,23
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 338:	1101                	add	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	1000                	add	s0,sp,32
 340:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 344:	4605                	li	a2,1
 346:	fef40593          	add	a1,s0,-17
 34a:	00000097          	auipc	ra,0x0
 34e:	f5e080e7          	jalr	-162(ra) # 2a8 <write>
}
 352:	60e2                	ld	ra,24(sp)
 354:	6442                	ld	s0,16(sp)
 356:	6105                	add	sp,sp,32
 358:	8082                	ret

000000000000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	7139                	add	sp,sp,-64
 35c:	fc06                	sd	ra,56(sp)
 35e:	f822                	sd	s0,48(sp)
 360:	f426                	sd	s1,40(sp)
 362:	f04a                	sd	s2,32(sp)
 364:	ec4e                	sd	s3,24(sp)
 366:	0080                	add	s0,sp,64
 368:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36a:	c299                	beqz	a3,370 <printint+0x16>
 36c:	0805c963          	bltz	a1,3fe <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 370:	2581                	sext.w	a1,a1
  neg = 0;
 372:	4881                	li	a7,0
 374:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 378:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37a:	2601                	sext.w	a2,a2
 37c:	00000517          	auipc	a0,0x0
 380:	48450513          	add	a0,a0,1156 # 800 <digits>
 384:	883a                	mv	a6,a4
 386:	2705                	addw	a4,a4,1
 388:	02c5f7bb          	remuw	a5,a1,a2
 38c:	1782                	sll	a5,a5,0x20
 38e:	9381                	srl	a5,a5,0x20
 390:	97aa                	add	a5,a5,a0
 392:	0007c783          	lbu	a5,0(a5)
 396:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39a:	0005879b          	sext.w	a5,a1
 39e:	02c5d5bb          	divuw	a1,a1,a2
 3a2:	0685                	add	a3,a3,1
 3a4:	fec7f0e3          	bgeu	a5,a2,384 <printint+0x2a>
  if(neg)
 3a8:	00088c63          	beqz	a7,3c0 <printint+0x66>
    buf[i++] = '-';
 3ac:	fd070793          	add	a5,a4,-48
 3b0:	00878733          	add	a4,a5,s0
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05863          	blez	a4,3f0 <printint+0x96>
 3c4:	fc040793          	add	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	add	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addw	a4,a4,-1
 3d4:	1702                	sll	a4,a4,0x20
 3d6:	9301                	srl	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f56080e7          	jalr	-170(ra) # 338 <putc>
  while(--i >= 0)
 3ea:	197d                	add	s2,s2,-1
 3ec:	ff3918e3          	bne	s2,s3,3dc <printint+0x82>
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
 3fa:	6121                	add	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf85                	j	374 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	715d                	add	sp,sp,-80
 408:	e486                	sd	ra,72(sp)
 40a:	e0a2                	sd	s0,64(sp)
 40c:	fc26                	sd	s1,56(sp)
 40e:	f84a                	sd	s2,48(sp)
 410:	f44e                	sd	s3,40(sp)
 412:	f052                	sd	s4,32(sp)
 414:	ec56                	sd	s5,24(sp)
 416:	e85a                	sd	s6,16(sp)
 418:	e45e                	sd	s7,8(sp)
 41a:	e062                	sd	s8,0(sp)
 41c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 41e:	0005c903          	lbu	s2,0(a1)
 422:	18090c63          	beqz	s2,5ba <vprintf+0x1b4>
 426:	8aaa                	mv	s5,a0
 428:	8bb2                	mv	s7,a2
 42a:	00158493          	add	s1,a1,1
  state = 0;
 42e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 430:	02500a13          	li	s4,37
 434:	4b55                	li	s6,21
 436:	a839                	j	454 <vprintf+0x4e>
        putc(fd, c);
 438:	85ca                	mv	a1,s2
 43a:	8556                	mv	a0,s5
 43c:	00000097          	auipc	ra,0x0
 440:	efc080e7          	jalr	-260(ra) # 338 <putc>
 444:	a019                	j	44a <vprintf+0x44>
    } else if(state == '%'){
 446:	01498d63          	beq	s3,s4,460 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 44a:	0485                	add	s1,s1,1
 44c:	fff4c903          	lbu	s2,-1(s1)
 450:	16090563          	beqz	s2,5ba <vprintf+0x1b4>
    if(state == 0){
 454:	fe0999e3          	bnez	s3,446 <vprintf+0x40>
      if(c == '%'){
 458:	ff4910e3          	bne	s2,s4,438 <vprintf+0x32>
        state = '%';
 45c:	89d2                	mv	s3,s4
 45e:	b7f5                	j	44a <vprintf+0x44>
      if(c == 'd'){
 460:	13490263          	beq	s2,s4,584 <vprintf+0x17e>
 464:	f9d9079b          	addw	a5,s2,-99
 468:	0ff7f793          	zext.b	a5,a5
 46c:	12fb6563          	bltu	s6,a5,596 <vprintf+0x190>
 470:	f9d9079b          	addw	a5,s2,-99
 474:	0ff7f713          	zext.b	a4,a5
 478:	10eb6f63          	bltu	s6,a4,596 <vprintf+0x190>
 47c:	00271793          	sll	a5,a4,0x2
 480:	00000717          	auipc	a4,0x0
 484:	32870713          	add	a4,a4,808 # 7a8 <malloc+0xf0>
 488:	97ba                	add	a5,a5,a4
 48a:	439c                	lw	a5,0(a5)
 48c:	97ba                	add	a5,a5,a4
 48e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 490:	008b8913          	add	s2,s7,8
 494:	4685                	li	a3,1
 496:	4629                	li	a2,10
 498:	000ba583          	lw	a1,0(s7)
 49c:	8556                	mv	a0,s5
 49e:	00000097          	auipc	ra,0x0
 4a2:	ebc080e7          	jalr	-324(ra) # 35a <printint>
 4a6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	b745                	j	44a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ac:	008b8913          	add	s2,s7,8
 4b0:	4681                	li	a3,0
 4b2:	4629                	li	a2,10
 4b4:	000ba583          	lw	a1,0(s7)
 4b8:	8556                	mv	a0,s5
 4ba:	00000097          	auipc	ra,0x0
 4be:	ea0080e7          	jalr	-352(ra) # 35a <printint>
 4c2:	8bca                	mv	s7,s2
      state = 0;
 4c4:	4981                	li	s3,0
 4c6:	b751                	j	44a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4c8:	008b8913          	add	s2,s7,8
 4cc:	4681                	li	a3,0
 4ce:	4641                	li	a2,16
 4d0:	000ba583          	lw	a1,0(s7)
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	e84080e7          	jalr	-380(ra) # 35a <printint>
 4de:	8bca                	mv	s7,s2
      state = 0;
 4e0:	4981                	li	s3,0
 4e2:	b7a5                	j	44a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 4e4:	008b8c13          	add	s8,s7,8
 4e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4ec:	03000593          	li	a1,48
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e46080e7          	jalr	-442(ra) # 338 <putc>
  putc(fd, 'x');
 4fa:	07800593          	li	a1,120
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e38080e7          	jalr	-456(ra) # 338 <putc>
 508:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 50a:	00000b97          	auipc	s7,0x0
 50e:	2f6b8b93          	add	s7,s7,758 # 800 <digits>
 512:	03c9d793          	srl	a5,s3,0x3c
 516:	97de                	add	a5,a5,s7
 518:	0007c583          	lbu	a1,0(a5)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e1a080e7          	jalr	-486(ra) # 338 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 526:	0992                	sll	s3,s3,0x4
 528:	397d                	addw	s2,s2,-1
 52a:	fe0914e3          	bnez	s2,512 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 52e:	8be2                	mv	s7,s8
      state = 0;
 530:	4981                	li	s3,0
 532:	bf21                	j	44a <vprintf+0x44>
        s = va_arg(ap, char*);
 534:	008b8993          	add	s3,s7,8
 538:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 53c:	02090163          	beqz	s2,55e <vprintf+0x158>
        while(*s != 0){
 540:	00094583          	lbu	a1,0(s2)
 544:	c9a5                	beqz	a1,5b4 <vprintf+0x1ae>
          putc(fd, *s);
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	df0080e7          	jalr	-528(ra) # 338 <putc>
          s++;
 550:	0905                	add	s2,s2,1
        while(*s != 0){
 552:	00094583          	lbu	a1,0(s2)
 556:	f9e5                	bnez	a1,546 <vprintf+0x140>
        s = va_arg(ap, char*);
 558:	8bce                	mv	s7,s3
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b5fd                	j	44a <vprintf+0x44>
          s = "(null)";
 55e:	00000917          	auipc	s2,0x0
 562:	24290913          	add	s2,s2,578 # 7a0 <malloc+0xe8>
        while(*s != 0){
 566:	02800593          	li	a1,40
 56a:	bff1                	j	546 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 56c:	008b8913          	add	s2,s7,8
 570:	000bc583          	lbu	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	dc2080e7          	jalr	-574(ra) # 338 <putc>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b5e1                	j	44a <vprintf+0x44>
        putc(fd, c);
 584:	02500593          	li	a1,37
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	dae080e7          	jalr	-594(ra) # 338 <putc>
      state = 0;
 592:	4981                	li	s3,0
 594:	bd5d                	j	44a <vprintf+0x44>
        putc(fd, '%');
 596:	02500593          	li	a1,37
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	d9c080e7          	jalr	-612(ra) # 338 <putc>
        putc(fd, c);
 5a4:	85ca                	mv	a1,s2
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	d90080e7          	jalr	-624(ra) # 338 <putc>
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bd61                	j	44a <vprintf+0x44>
        s = va_arg(ap, char*);
 5b4:	8bce                	mv	s7,s3
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bd49                	j	44a <vprintf+0x44>
    }
  }
}
 5ba:	60a6                	ld	ra,72(sp)
 5bc:	6406                	ld	s0,64(sp)
 5be:	74e2                	ld	s1,56(sp)
 5c0:	7942                	ld	s2,48(sp)
 5c2:	79a2                	ld	s3,40(sp)
 5c4:	7a02                	ld	s4,32(sp)
 5c6:	6ae2                	ld	s5,24(sp)
 5c8:	6b42                	ld	s6,16(sp)
 5ca:	6ba2                	ld	s7,8(sp)
 5cc:	6c02                	ld	s8,0(sp)
 5ce:	6161                	add	sp,sp,80
 5d0:	8082                	ret

00000000000005d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5d2:	715d                	add	sp,sp,-80
 5d4:	ec06                	sd	ra,24(sp)
 5d6:	e822                	sd	s0,16(sp)
 5d8:	1000                	add	s0,sp,32
 5da:	e010                	sd	a2,0(s0)
 5dc:	e414                	sd	a3,8(s0)
 5de:	e818                	sd	a4,16(s0)
 5e0:	ec1c                	sd	a5,24(s0)
 5e2:	03043023          	sd	a6,32(s0)
 5e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5ee:	8622                	mv	a2,s0
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e16080e7          	jalr	-490(ra) # 406 <vprintf>
}
 5f8:	60e2                	ld	ra,24(sp)
 5fa:	6442                	ld	s0,16(sp)
 5fc:	6161                	add	sp,sp,80
 5fe:	8082                	ret

0000000000000600 <printf>:

void
printf(const char *fmt, ...)
{
 600:	711d                	add	sp,sp,-96
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	1000                	add	s0,sp,32
 608:	e40c                	sd	a1,8(s0)
 60a:	e810                	sd	a2,16(s0)
 60c:	ec14                	sd	a3,24(s0)
 60e:	f018                	sd	a4,32(s0)
 610:	f41c                	sd	a5,40(s0)
 612:	03043823          	sd	a6,48(s0)
 616:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 61a:	00840613          	add	a2,s0,8
 61e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 622:	85aa                	mv	a1,a0
 624:	4505                	li	a0,1
 626:	00000097          	auipc	ra,0x0
 62a:	de0080e7          	jalr	-544(ra) # 406 <vprintf>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6125                	add	sp,sp,96
 634:	8082                	ret

0000000000000636 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 636:	1141                	add	sp,sp,-16
 638:	e422                	sd	s0,8(sp)
 63a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 640:	00000797          	auipc	a5,0x0
 644:	1d87b783          	ld	a5,472(a5) # 818 <freep>
 648:	a02d                	j	672 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 64a:	4618                	lw	a4,8(a2)
 64c:	9f2d                	addw	a4,a4,a1
 64e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 652:	6398                	ld	a4,0(a5)
 654:	6310                	ld	a2,0(a4)
 656:	a83d                	j	694 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 658:	ff852703          	lw	a4,-8(a0)
 65c:	9f31                	addw	a4,a4,a2
 65e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 660:	ff053683          	ld	a3,-16(a0)
 664:	a091                	j	6a8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 666:	6398                	ld	a4,0(a5)
 668:	00e7e463          	bltu	a5,a4,670 <free+0x3a>
 66c:	00e6ea63          	bltu	a3,a4,680 <free+0x4a>
{
 670:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	fed7fae3          	bgeu	a5,a3,666 <free+0x30>
 676:	6398                	ld	a4,0(a5)
 678:	00e6e463          	bltu	a3,a4,680 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	fee7eae3          	bltu	a5,a4,670 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 680:	ff852583          	lw	a1,-8(a0)
 684:	6390                	ld	a2,0(a5)
 686:	02059813          	sll	a6,a1,0x20
 68a:	01c85713          	srl	a4,a6,0x1c
 68e:	9736                	add	a4,a4,a3
 690:	fae60de3          	beq	a2,a4,64a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 694:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 698:	4790                	lw	a2,8(a5)
 69a:	02061593          	sll	a1,a2,0x20
 69e:	01c5d713          	srl	a4,a1,0x1c
 6a2:	973e                	add	a4,a4,a5
 6a4:	fae68ae3          	beq	a3,a4,658 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6aa:	00000717          	auipc	a4,0x0
 6ae:	16f73723          	sd	a5,366(a4) # 818 <freep>
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	add	sp,sp,16
 6b6:	8082                	ret

00000000000006b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b8:	7139                	add	sp,sp,-64
 6ba:	fc06                	sd	ra,56(sp)
 6bc:	f822                	sd	s0,48(sp)
 6be:	f426                	sd	s1,40(sp)
 6c0:	f04a                	sd	s2,32(sp)
 6c2:	ec4e                	sd	s3,24(sp)
 6c4:	e852                	sd	s4,16(sp)
 6c6:	e456                	sd	s5,8(sp)
 6c8:	e05a                	sd	s6,0(sp)
 6ca:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6cc:	02051493          	sll	s1,a0,0x20
 6d0:	9081                	srl	s1,s1,0x20
 6d2:	04bd                	add	s1,s1,15
 6d4:	8091                	srl	s1,s1,0x4
 6d6:	0014899b          	addw	s3,s1,1
 6da:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 6dc:	00000517          	auipc	a0,0x0
 6e0:	13c53503          	ld	a0,316(a0) # 818 <freep>
 6e4:	c515                	beqz	a0,710 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6e8:	4798                	lw	a4,8(a5)
 6ea:	02977f63          	bgeu	a4,s1,728 <malloc+0x70>
  if(nu < 4096)
 6ee:	8a4e                	mv	s4,s3
 6f0:	0009871b          	sext.w	a4,s3
 6f4:	6685                	lui	a3,0x1
 6f6:	00d77363          	bgeu	a4,a3,6fc <malloc+0x44>
 6fa:	6a05                	lui	s4,0x1
 6fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 700:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 704:	00000917          	auipc	s2,0x0
 708:	11490913          	add	s2,s2,276 # 818 <freep>
  if(p == (char*)-1)
 70c:	5afd                	li	s5,-1
 70e:	a895                	j	782 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 710:	00000797          	auipc	a5,0x0
 714:	11078793          	add	a5,a5,272 # 820 <base>
 718:	00000717          	auipc	a4,0x0
 71c:	10f73023          	sd	a5,256(a4) # 818 <freep>
 720:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 722:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 726:	b7e1                	j	6ee <malloc+0x36>
      if(p->s.size == nunits)
 728:	02e48c63          	beq	s1,a4,760 <malloc+0xa8>
        p->s.size -= nunits;
 72c:	4137073b          	subw	a4,a4,s3
 730:	c798                	sw	a4,8(a5)
        p += p->s.size;
 732:	02071693          	sll	a3,a4,0x20
 736:	01c6d713          	srl	a4,a3,0x1c
 73a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 73c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 740:	00000717          	auipc	a4,0x0
 744:	0ca73c23          	sd	a0,216(a4) # 818 <freep>
      return (void*)(p + 1);
 748:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 74c:	70e2                	ld	ra,56(sp)
 74e:	7442                	ld	s0,48(sp)
 750:	74a2                	ld	s1,40(sp)
 752:	7902                	ld	s2,32(sp)
 754:	69e2                	ld	s3,24(sp)
 756:	6a42                	ld	s4,16(sp)
 758:	6aa2                	ld	s5,8(sp)
 75a:	6b02                	ld	s6,0(sp)
 75c:	6121                	add	sp,sp,64
 75e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 760:	6398                	ld	a4,0(a5)
 762:	e118                	sd	a4,0(a0)
 764:	bff1                	j	740 <malloc+0x88>
  hp->s.size = nu;
 766:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 76a:	0541                	add	a0,a0,16
 76c:	00000097          	auipc	ra,0x0
 770:	eca080e7          	jalr	-310(ra) # 636 <free>
  return freep;
 774:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 778:	d971                	beqz	a0,74c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	fa9775e3          	bgeu	a4,s1,728 <malloc+0x70>
    if(p == freep)
 782:	00093703          	ld	a4,0(s2)
 786:	853e                	mv	a0,a5
 788:	fef719e3          	bne	a4,a5,77a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 78c:	8552                	mv	a0,s4
 78e:	00000097          	auipc	ra,0x0
 792:	b82080e7          	jalr	-1150(ra) # 310 <sbrk>
  if(p == (char*)-1)
 796:	fd5518e3          	bne	a0,s5,766 <malloc+0xae>
        return 0;
 79a:	4501                	li	a0,0
 79c:	bf45                	j	74c <malloc+0x94>
