
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00000597          	auipc	a1,0x0
  14:	7d858593          	add	a1,a1,2008 # 7e8 <malloc+0xec>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	5fc080e7          	jalr	1532(ra) # 616 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2a8080e7          	jalr	680(ra) # 2cc <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	2fa080e7          	jalr	762(ra) # 32c <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	28c080e7          	jalr	652(ra) # 2cc <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00000597          	auipc	a1,0x0
  50:	7b458593          	add	a1,a1,1972 # 800 <malloc+0x104>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	5c0080e7          	jalr	1472(ra) # 616 <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  60:	1141                	add	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	add	a1,a1,1
  6a:	0785                	add	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	add	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	add	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	add	a0,a0,1
  92:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	add	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	add	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	86be                	mv	a3,a5
  ba:	0785                	add	a5,a5,1
  bc:	fff7c703          	lbu	a4,-1(a5)
  c0:	ff65                	bnez	a4,b8 <strlen+0x10>
  c2:	40a6853b          	subw	a0,a3,a0
  c6:	2505                	addw	a0,a0,1
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	add	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	add	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	sll	a2,a2,0x20
  de:	9201                	srl	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	add	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	add	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	add	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	add	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	add	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	add	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	add	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	add	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addw	s1,s1,1
 13e:	0344d863          	bge	s1,s4,16e <gets+0x56>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	add	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	19a080e7          	jalr	410(ra) # 2e4 <read>
    if(cc < 1)
 152:	00a05e63          	blez	a0,16e <gets+0x56>
    buf[i++] = c;
 156:	faf44783          	lbu	a5,-81(s0)
 15a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15e:	01578763          	beq	a5,s5,16c <gets+0x54>
 162:	0905                	add	s2,s2,1
 164:	fd679be3          	bne	a5,s6,13a <gets+0x22>
  for(i=0; i+1 < max; ){
 168:	89a6                	mv	s3,s1
 16a:	a011                	j	16e <gets+0x56>
 16c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16e:	99de                	add	s3,s3,s7
 170:	00098023          	sb	zero,0(s3)
  return buf;
}
 174:	855e                	mv	a0,s7
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6125                	add	sp,sp,96
 18a:	8082                	ret

000000000000018c <stat>:

int
stat(const char *n, struct stat *st)
{
 18c:	1101                	add	sp,sp,-32
 18e:	ec06                	sd	ra,24(sp)
 190:	e822                	sd	s0,16(sp)
 192:	e426                	sd	s1,8(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	add	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	170080e7          	jalr	368(ra) # 30c <open>
  if(fd < 0)
 1a4:	02054563          	bltz	a0,1ce <stat+0x42>
 1a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1aa:	85ca                	mv	a1,s2
 1ac:	00000097          	auipc	ra,0x0
 1b0:	178080e7          	jalr	376(ra) # 324 <fstat>
 1b4:	892a                	mv	s2,a0
  close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	00000097          	auipc	ra,0x0
 1bc:	13c080e7          	jalr	316(ra) # 2f4 <close>
  return r;
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	64a2                	ld	s1,8(sp)
 1c8:	6902                	ld	s2,0(sp)
 1ca:	6105                	add	sp,sp,32
 1cc:	8082                	ret
    return -1;
 1ce:	597d                	li	s2,-1
 1d0:	bfc5                	j	1c0 <stat+0x34>

00000000000001d2 <atoi>:

int
atoi(const char *s)
{
 1d2:	1141                	add	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	00054683          	lbu	a3,0(a0)
 1dc:	fd06879b          	addw	a5,a3,-48
 1e0:	0ff7f793          	zext.b	a5,a5
 1e4:	4625                	li	a2,9
 1e6:	02f66863          	bltu	a2,a5,216 <atoi+0x44>
 1ea:	872a                	mv	a4,a0
  n = 0;
 1ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ee:	0705                	add	a4,a4,1
 1f0:	0025179b          	sllw	a5,a0,0x2
 1f4:	9fa9                	addw	a5,a5,a0
 1f6:	0017979b          	sllw	a5,a5,0x1
 1fa:	9fb5                	addw	a5,a5,a3
 1fc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 200:	00074683          	lbu	a3,0(a4)
 204:	fd06879b          	addw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	fef671e3          	bgeu	a2,a5,1ee <atoi+0x1c>
  return n;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	add	sp,sp,16
 214:	8082                	ret
  n = 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <atoi+0x3e>

000000000000021a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21a:	1141                	add	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 220:	02b57463          	bgeu	a0,a1,248 <memmove+0x2e>
    while(n-- > 0)
 224:	00c05f63          	blez	a2,242 <memmove+0x28>
 228:	1602                	sll	a2,a2,0x20
 22a:	9201                	srl	a2,a2,0x20
 22c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 230:	872a                	mv	a4,a0
      *dst++ = *src++;
 232:	0585                	add	a1,a1,1
 234:	0705                	add	a4,a4,1
 236:	fff5c683          	lbu	a3,-1(a1)
 23a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	add	sp,sp,16
 246:	8082                	ret
    dst += n;
 248:	00c50733          	add	a4,a0,a2
    src += n;
 24c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24e:	fec05ae3          	blez	a2,242 <memmove+0x28>
 252:	fff6079b          	addw	a5,a2,-1
 256:	1782                	sll	a5,a5,0x20
 258:	9381                	srl	a5,a5,0x20
 25a:	fff7c793          	not	a5,a5
 25e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 260:	15fd                	add	a1,a1,-1
 262:	177d                	add	a4,a4,-1
 264:	0005c683          	lbu	a3,0(a1)
 268:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26c:	fee79ae3          	bne	a5,a4,260 <memmove+0x46>
 270:	bfc9                	j	242 <memmove+0x28>

0000000000000272 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 272:	1141                	add	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 278:	ca05                	beqz	a2,2a8 <memcmp+0x36>
 27a:	fff6069b          	addw	a3,a2,-1
 27e:	1682                	sll	a3,a3,0x20
 280:	9281                	srl	a3,a3,0x20
 282:	0685                	add	a3,a3,1
 284:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 286:	00054783          	lbu	a5,0(a0)
 28a:	0005c703          	lbu	a4,0(a1)
 28e:	00e79863          	bne	a5,a4,29e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 292:	0505                	add	a0,a0,1
    p2++;
 294:	0585                	add	a1,a1,1
  while (n-- > 0) {
 296:	fed518e3          	bne	a0,a3,286 <memcmp+0x14>
  }
  return 0;
 29a:	4501                	li	a0,0
 29c:	a019                	j	2a2 <memcmp+0x30>
      return *p1 - *p2;
 29e:	40e7853b          	subw	a0,a5,a4
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	add	sp,sp,16
 2a6:	8082                	ret
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	bfe5                	j	2a2 <memcmp+0x30>

00000000000002ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ac:	1141                	add	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b4:	00000097          	auipc	ra,0x0
 2b8:	f66080e7          	jalr	-154(ra) # 21a <memmove>
}
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	add	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c4:	4885                	li	a7,1
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2cc:	4889                	li	a7,2
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d4:	488d                	li	a7,3
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2dc:	4891                	li	a7,4
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <read>:
.global read
read:
 li a7, SYS_read
 2e4:	4895                	li	a7,5
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <write>:
.global write
write:
 li a7, SYS_write
 2ec:	48c1                	li	a7,16
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <close>:
.global close
close:
 li a7, SYS_close
 2f4:	48d5                	li	a7,21
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fc:	4899                	li	a7,6
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exec>:
.global exec
exec:
 li a7, SYS_exec
 304:	489d                	li	a7,7
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <open>:
.global open
open:
 li a7, SYS_open
 30c:	48bd                	li	a7,15
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 314:	48c5                	li	a7,17
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31c:	48c9                	li	a7,18
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 324:	48a1                	li	a7,8
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <link>:
.global link
link:
 li a7, SYS_link
 32c:	48cd                	li	a7,19
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 334:	48d1                	li	a7,20
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33c:	48a5                	li	a7,9
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <dup>:
.global dup
dup:
 li a7, SYS_dup
 344:	48a9                	li	a7,10
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34c:	48ad                	li	a7,11
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 354:	48b1                	li	a7,12
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 35c:	48b5                	li	a7,13
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 364:	48b9                	li	a7,14
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 36c:	48d9                	li	a7,22
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 374:	48dd                	li	a7,23
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37c:	1101                	add	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	1000                	add	s0,sp,32
 384:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 388:	4605                	li	a2,1
 38a:	fef40593          	add	a1,s0,-17
 38e:	00000097          	auipc	ra,0x0
 392:	f5e080e7          	jalr	-162(ra) # 2ec <write>
}
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	6105                	add	sp,sp,32
 39c:	8082                	ret

000000000000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	7139                	add	sp,sp,-64
 3a0:	fc06                	sd	ra,56(sp)
 3a2:	f822                	sd	s0,48(sp)
 3a4:	f426                	sd	s1,40(sp)
 3a6:	f04a                	sd	s2,32(sp)
 3a8:	ec4e                	sd	s3,24(sp)
 3aa:	0080                	add	s0,sp,64
 3ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ae:	c299                	beqz	a3,3b4 <printint+0x16>
 3b0:	0805c963          	bltz	a1,442 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b4:	2581                	sext.w	a1,a1
  neg = 0;
 3b6:	4881                	li	a7,0
 3b8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3be:	2601                	sext.w	a2,a2
 3c0:	00000517          	auipc	a0,0x0
 3c4:	4b850513          	add	a0,a0,1208 # 878 <digits>
 3c8:	883a                	mv	a6,a4
 3ca:	2705                	addw	a4,a4,1
 3cc:	02c5f7bb          	remuw	a5,a1,a2
 3d0:	1782                	sll	a5,a5,0x20
 3d2:	9381                	srl	a5,a5,0x20
 3d4:	97aa                	add	a5,a5,a0
 3d6:	0007c783          	lbu	a5,0(a5)
 3da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3de:	0005879b          	sext.w	a5,a1
 3e2:	02c5d5bb          	divuw	a1,a1,a2
 3e6:	0685                	add	a3,a3,1
 3e8:	fec7f0e3          	bgeu	a5,a2,3c8 <printint+0x2a>
  if(neg)
 3ec:	00088c63          	beqz	a7,404 <printint+0x66>
    buf[i++] = '-';
 3f0:	fd070793          	add	a5,a4,-48
 3f4:	00878733          	add	a4,a5,s0
 3f8:	02d00793          	li	a5,45
 3fc:	fef70823          	sb	a5,-16(a4)
 400:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 404:	02e05863          	blez	a4,434 <printint+0x96>
 408:	fc040793          	add	a5,s0,-64
 40c:	00e78933          	add	s2,a5,a4
 410:	fff78993          	add	s3,a5,-1
 414:	99ba                	add	s3,s3,a4
 416:	377d                	addw	a4,a4,-1
 418:	1702                	sll	a4,a4,0x20
 41a:	9301                	srl	a4,a4,0x20
 41c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 420:	fff94583          	lbu	a1,-1(s2)
 424:	8526                	mv	a0,s1
 426:	00000097          	auipc	ra,0x0
 42a:	f56080e7          	jalr	-170(ra) # 37c <putc>
  while(--i >= 0)
 42e:	197d                	add	s2,s2,-1
 430:	ff3918e3          	bne	s2,s3,420 <printint+0x82>
}
 434:	70e2                	ld	ra,56(sp)
 436:	7442                	ld	s0,48(sp)
 438:	74a2                	ld	s1,40(sp)
 43a:	7902                	ld	s2,32(sp)
 43c:	69e2                	ld	s3,24(sp)
 43e:	6121                	add	sp,sp,64
 440:	8082                	ret
    x = -xx;
 442:	40b005bb          	negw	a1,a1
    neg = 1;
 446:	4885                	li	a7,1
    x = -xx;
 448:	bf85                	j	3b8 <printint+0x1a>

000000000000044a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44a:	715d                	add	sp,sp,-80
 44c:	e486                	sd	ra,72(sp)
 44e:	e0a2                	sd	s0,64(sp)
 450:	fc26                	sd	s1,56(sp)
 452:	f84a                	sd	s2,48(sp)
 454:	f44e                	sd	s3,40(sp)
 456:	f052                	sd	s4,32(sp)
 458:	ec56                	sd	s5,24(sp)
 45a:	e85a                	sd	s6,16(sp)
 45c:	e45e                	sd	s7,8(sp)
 45e:	e062                	sd	s8,0(sp)
 460:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 462:	0005c903          	lbu	s2,0(a1)
 466:	18090c63          	beqz	s2,5fe <vprintf+0x1b4>
 46a:	8aaa                	mv	s5,a0
 46c:	8bb2                	mv	s7,a2
 46e:	00158493          	add	s1,a1,1
  state = 0;
 472:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 474:	02500a13          	li	s4,37
 478:	4b55                	li	s6,21
 47a:	a839                	j	498 <vprintf+0x4e>
        putc(fd, c);
 47c:	85ca                	mv	a1,s2
 47e:	8556                	mv	a0,s5
 480:	00000097          	auipc	ra,0x0
 484:	efc080e7          	jalr	-260(ra) # 37c <putc>
 488:	a019                	j	48e <vprintf+0x44>
    } else if(state == '%'){
 48a:	01498d63          	beq	s3,s4,4a4 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 48e:	0485                	add	s1,s1,1
 490:	fff4c903          	lbu	s2,-1(s1)
 494:	16090563          	beqz	s2,5fe <vprintf+0x1b4>
    if(state == 0){
 498:	fe0999e3          	bnez	s3,48a <vprintf+0x40>
      if(c == '%'){
 49c:	ff4910e3          	bne	s2,s4,47c <vprintf+0x32>
        state = '%';
 4a0:	89d2                	mv	s3,s4
 4a2:	b7f5                	j	48e <vprintf+0x44>
      if(c == 'd'){
 4a4:	13490263          	beq	s2,s4,5c8 <vprintf+0x17e>
 4a8:	f9d9079b          	addw	a5,s2,-99
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	12fb6563          	bltu	s6,a5,5da <vprintf+0x190>
 4b4:	f9d9079b          	addw	a5,s2,-99
 4b8:	0ff7f713          	zext.b	a4,a5
 4bc:	10eb6f63          	bltu	s6,a4,5da <vprintf+0x190>
 4c0:	00271793          	sll	a5,a4,0x2
 4c4:	00000717          	auipc	a4,0x0
 4c8:	35c70713          	add	a4,a4,860 # 820 <malloc+0x124>
 4cc:	97ba                	add	a5,a5,a4
 4ce:	439c                	lw	a5,0(a5)
 4d0:	97ba                	add	a5,a5,a4
 4d2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d4:	008b8913          	add	s2,s7,8
 4d8:	4685                	li	a3,1
 4da:	4629                	li	a2,10
 4dc:	000ba583          	lw	a1,0(s7)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	ebc080e7          	jalr	-324(ra) # 39e <printint>
 4ea:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b745                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f0:	008b8913          	add	s2,s7,8
 4f4:	4681                	li	a3,0
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ea0080e7          	jalr	-352(ra) # 39e <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	b751                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 50c:	008b8913          	add	s2,s7,8
 510:	4681                	li	a3,0
 512:	4641                	li	a2,16
 514:	000ba583          	lw	a1,0(s7)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e84080e7          	jalr	-380(ra) # 39e <printint>
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	b7a5                	j	48e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 528:	008b8c13          	add	s8,s7,8
 52c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 530:	03000593          	li	a1,48
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	e46080e7          	jalr	-442(ra) # 37c <putc>
  putc(fd, 'x');
 53e:	07800593          	li	a1,120
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e38080e7          	jalr	-456(ra) # 37c <putc>
 54c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54e:	00000b97          	auipc	s7,0x0
 552:	32ab8b93          	add	s7,s7,810 # 878 <digits>
 556:	03c9d793          	srl	a5,s3,0x3c
 55a:	97de                	add	a5,a5,s7
 55c:	0007c583          	lbu	a1,0(a5)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e1a080e7          	jalr	-486(ra) # 37c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56a:	0992                	sll	s3,s3,0x4
 56c:	397d                	addw	s2,s2,-1
 56e:	fe0914e3          	bnez	s2,556 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 572:	8be2                	mv	s7,s8
      state = 0;
 574:	4981                	li	s3,0
 576:	bf21                	j	48e <vprintf+0x44>
        s = va_arg(ap, char*);
 578:	008b8993          	add	s3,s7,8
 57c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 580:	02090163          	beqz	s2,5a2 <vprintf+0x158>
        while(*s != 0){
 584:	00094583          	lbu	a1,0(s2)
 588:	c9a5                	beqz	a1,5f8 <vprintf+0x1ae>
          putc(fd, *s);
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	df0080e7          	jalr	-528(ra) # 37c <putc>
          s++;
 594:	0905                	add	s2,s2,1
        while(*s != 0){
 596:	00094583          	lbu	a1,0(s2)
 59a:	f9e5                	bnez	a1,58a <vprintf+0x140>
        s = va_arg(ap, char*);
 59c:	8bce                	mv	s7,s3
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b5fd                	j	48e <vprintf+0x44>
          s = "(null)";
 5a2:	00000917          	auipc	s2,0x0
 5a6:	27690913          	add	s2,s2,630 # 818 <malloc+0x11c>
        while(*s != 0){
 5aa:	02800593          	li	a1,40
 5ae:	bff1                	j	58a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5b0:	008b8913          	add	s2,s7,8
 5b4:	000bc583          	lbu	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dc2080e7          	jalr	-574(ra) # 37c <putc>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5e1                	j	48e <vprintf+0x44>
        putc(fd, c);
 5c8:	02500593          	li	a1,37
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dae080e7          	jalr	-594(ra) # 37c <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd5d                	j	48e <vprintf+0x44>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d9c080e7          	jalr	-612(ra) # 37c <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	d90080e7          	jalr	-624(ra) # 37c <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd61                	j	48e <vprintf+0x44>
        s = va_arg(ap, char*);
 5f8:	8bce                	mv	s7,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bd49                	j	48e <vprintf+0x44>
    }
  }
}
 5fe:	60a6                	ld	ra,72(sp)
 600:	6406                	ld	s0,64(sp)
 602:	74e2                	ld	s1,56(sp)
 604:	7942                	ld	s2,48(sp)
 606:	79a2                	ld	s3,40(sp)
 608:	7a02                	ld	s4,32(sp)
 60a:	6ae2                	ld	s5,24(sp)
 60c:	6b42                	ld	s6,16(sp)
 60e:	6ba2                	ld	s7,8(sp)
 610:	6c02                	ld	s8,0(sp)
 612:	6161                	add	sp,sp,80
 614:	8082                	ret

0000000000000616 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 616:	715d                	add	sp,sp,-80
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	add	s0,sp,32
 61e:	e010                	sd	a2,0(s0)
 620:	e414                	sd	a3,8(s0)
 622:	e818                	sd	a4,16(s0)
 624:	ec1c                	sd	a5,24(s0)
 626:	03043023          	sd	a6,32(s0)
 62a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 62e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 632:	8622                	mv	a2,s0
 634:	00000097          	auipc	ra,0x0
 638:	e16080e7          	jalr	-490(ra) # 44a <vprintf>
}
 63c:	60e2                	ld	ra,24(sp)
 63e:	6442                	ld	s0,16(sp)
 640:	6161                	add	sp,sp,80
 642:	8082                	ret

0000000000000644 <printf>:

void
printf(const char *fmt, ...)
{
 644:	711d                	add	sp,sp,-96
 646:	ec06                	sd	ra,24(sp)
 648:	e822                	sd	s0,16(sp)
 64a:	1000                	add	s0,sp,32
 64c:	e40c                	sd	a1,8(s0)
 64e:	e810                	sd	a2,16(s0)
 650:	ec14                	sd	a3,24(s0)
 652:	f018                	sd	a4,32(s0)
 654:	f41c                	sd	a5,40(s0)
 656:	03043823          	sd	a6,48(s0)
 65a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 65e:	00840613          	add	a2,s0,8
 662:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 666:	85aa                	mv	a1,a0
 668:	4505                	li	a0,1
 66a:	00000097          	auipc	ra,0x0
 66e:	de0080e7          	jalr	-544(ra) # 44a <vprintf>
}
 672:	60e2                	ld	ra,24(sp)
 674:	6442                	ld	s0,16(sp)
 676:	6125                	add	sp,sp,96
 678:	8082                	ret

000000000000067a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67a:	1141                	add	sp,sp,-16
 67c:	e422                	sd	s0,8(sp)
 67e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	00000797          	auipc	a5,0x0
 688:	20c7b783          	ld	a5,524(a5) # 890 <freep>
 68c:	a02d                	j	6b6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 68e:	4618                	lw	a4,8(a2)
 690:	9f2d                	addw	a4,a4,a1
 692:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 696:	6398                	ld	a4,0(a5)
 698:	6310                	ld	a2,0(a4)
 69a:	a83d                	j	6d8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 69c:	ff852703          	lw	a4,-8(a0)
 6a0:	9f31                	addw	a4,a4,a2
 6a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6a4:	ff053683          	ld	a3,-16(a0)
 6a8:	a091                	j	6ec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	6398                	ld	a4,0(a5)
 6ac:	00e7e463          	bltu	a5,a4,6b4 <free+0x3a>
 6b0:	00e6ea63          	bltu	a3,a4,6c4 <free+0x4a>
{
 6b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b6:	fed7fae3          	bgeu	a5,a3,6aa <free+0x30>
 6ba:	6398                	ld	a4,0(a5)
 6bc:	00e6e463          	bltu	a3,a4,6c4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	fee7eae3          	bltu	a5,a4,6b4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6c4:	ff852583          	lw	a1,-8(a0)
 6c8:	6390                	ld	a2,0(a5)
 6ca:	02059813          	sll	a6,a1,0x20
 6ce:	01c85713          	srl	a4,a6,0x1c
 6d2:	9736                	add	a4,a4,a3
 6d4:	fae60de3          	beq	a2,a4,68e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6dc:	4790                	lw	a2,8(a5)
 6de:	02061593          	sll	a1,a2,0x20
 6e2:	01c5d713          	srl	a4,a1,0x1c
 6e6:	973e                	add	a4,a4,a5
 6e8:	fae68ae3          	beq	a3,a4,69c <free+0x22>
    p->s.ptr = bp->s.ptr;
 6ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6ee:	00000717          	auipc	a4,0x0
 6f2:	1af73123          	sd	a5,418(a4) # 890 <freep>
}
 6f6:	6422                	ld	s0,8(sp)
 6f8:	0141                	add	sp,sp,16
 6fa:	8082                	ret

00000000000006fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fc:	7139                	add	sp,sp,-64
 6fe:	fc06                	sd	ra,56(sp)
 700:	f822                	sd	s0,48(sp)
 702:	f426                	sd	s1,40(sp)
 704:	f04a                	sd	s2,32(sp)
 706:	ec4e                	sd	s3,24(sp)
 708:	e852                	sd	s4,16(sp)
 70a:	e456                	sd	s5,8(sp)
 70c:	e05a                	sd	s6,0(sp)
 70e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 710:	02051493          	sll	s1,a0,0x20
 714:	9081                	srl	s1,s1,0x20
 716:	04bd                	add	s1,s1,15
 718:	8091                	srl	s1,s1,0x4
 71a:	0014899b          	addw	s3,s1,1
 71e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 720:	00000517          	auipc	a0,0x0
 724:	17053503          	ld	a0,368(a0) # 890 <freep>
 728:	c515                	beqz	a0,754 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 72c:	4798                	lw	a4,8(a5)
 72e:	02977f63          	bgeu	a4,s1,76c <malloc+0x70>
  if(nu < 4096)
 732:	8a4e                	mv	s4,s3
 734:	0009871b          	sext.w	a4,s3
 738:	6685                	lui	a3,0x1
 73a:	00d77363          	bgeu	a4,a3,740 <malloc+0x44>
 73e:	6a05                	lui	s4,0x1
 740:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 744:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 748:	00000917          	auipc	s2,0x0
 74c:	14890913          	add	s2,s2,328 # 890 <freep>
  if(p == (char*)-1)
 750:	5afd                	li	s5,-1
 752:	a895                	j	7c6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 754:	00000797          	auipc	a5,0x0
 758:	14478793          	add	a5,a5,324 # 898 <base>
 75c:	00000717          	auipc	a4,0x0
 760:	12f73a23          	sd	a5,308(a4) # 890 <freep>
 764:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 766:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76a:	b7e1                	j	732 <malloc+0x36>
      if(p->s.size == nunits)
 76c:	02e48c63          	beq	s1,a4,7a4 <malloc+0xa8>
        p->s.size -= nunits;
 770:	4137073b          	subw	a4,a4,s3
 774:	c798                	sw	a4,8(a5)
        p += p->s.size;
 776:	02071693          	sll	a3,a4,0x20
 77a:	01c6d713          	srl	a4,a3,0x1c
 77e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 780:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 784:	00000717          	auipc	a4,0x0
 788:	10a73623          	sd	a0,268(a4) # 890 <freep>
      return (void*)(p + 1);
 78c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 790:	70e2                	ld	ra,56(sp)
 792:	7442                	ld	s0,48(sp)
 794:	74a2                	ld	s1,40(sp)
 796:	7902                	ld	s2,32(sp)
 798:	69e2                	ld	s3,24(sp)
 79a:	6a42                	ld	s4,16(sp)
 79c:	6aa2                	ld	s5,8(sp)
 79e:	6b02                	ld	s6,0(sp)
 7a0:	6121                	add	sp,sp,64
 7a2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	e118                	sd	a4,0(a0)
 7a8:	bff1                	j	784 <malloc+0x88>
  hp->s.size = nu;
 7aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ae:	0541                	add	a0,a0,16
 7b0:	00000097          	auipc	ra,0x0
 7b4:	eca080e7          	jalr	-310(ra) # 67a <free>
  return freep;
 7b8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7bc:	d971                	beqz	a0,790 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	fa9775e3          	bgeu	a4,s1,76c <malloc+0x70>
    if(p == freep)
 7c6:	00093703          	ld	a4,0(s2)
 7ca:	853e                	mv	a0,a5
 7cc:	fef719e3          	bne	a4,a5,7be <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7d0:	8552                	mv	a0,s4
 7d2:	00000097          	auipc	ra,0x0
 7d6:	b82080e7          	jalr	-1150(ra) # 354 <sbrk>
  if(p == (char*)-1)
 7da:	fd5518e3          	bne	a0,s5,7aa <malloc+0xae>
        return 0;
 7de:	4501                	li	a0,0
 7e0:	bf45                	j	790 <malloc+0x94>
