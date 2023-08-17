
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
  10:	00001597          	auipc	a1,0x1
  14:	84858593          	add	a1,a1,-1976 # 858 <statistics+0x86>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	5ec080e7          	jalr	1516(ra) # 606 <fprintf>
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
  4c:	00001597          	auipc	a1,0x1
  50:	82458593          	add	a1,a1,-2012 # 870 <statistics+0x9e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	5b0080e7          	jalr	1456(ra) # 606 <fprintf>
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

000000000000036c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36c:	1101                	add	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	1000                	add	s0,sp,32
 374:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 378:	4605                	li	a2,1
 37a:	fef40593          	add	a1,s0,-17
 37e:	00000097          	auipc	ra,0x0
 382:	f6e080e7          	jalr	-146(ra) # 2ec <write>
}
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	6105                	add	sp,sp,32
 38c:	8082                	ret

000000000000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	7139                	add	sp,sp,-64
 390:	fc06                	sd	ra,56(sp)
 392:	f822                	sd	s0,48(sp)
 394:	f426                	sd	s1,40(sp)
 396:	f04a                	sd	s2,32(sp)
 398:	ec4e                	sd	s3,24(sp)
 39a:	0080                	add	s0,sp,64
 39c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	c299                	beqz	a3,3a4 <printint+0x16>
 3a0:	0805c963          	bltz	a1,432 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a4:	2581                	sext.w	a1,a1
  neg = 0;
 3a6:	4881                	li	a7,0
 3a8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ae:	2601                	sext.w	a2,a2
 3b0:	00000517          	auipc	a0,0x0
 3b4:	53850513          	add	a0,a0,1336 # 8e8 <digits>
 3b8:	883a                	mv	a6,a4
 3ba:	2705                	addw	a4,a4,1
 3bc:	02c5f7bb          	remuw	a5,a1,a2
 3c0:	1782                	sll	a5,a5,0x20
 3c2:	9381                	srl	a5,a5,0x20
 3c4:	97aa                	add	a5,a5,a0
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ce:	0005879b          	sext.w	a5,a1
 3d2:	02c5d5bb          	divuw	a1,a1,a2
 3d6:	0685                	add	a3,a3,1
 3d8:	fec7f0e3          	bgeu	a5,a2,3b8 <printint+0x2a>
  if(neg)
 3dc:	00088c63          	beqz	a7,3f4 <printint+0x66>
    buf[i++] = '-';
 3e0:	fd070793          	add	a5,a4,-48
 3e4:	00878733          	add	a4,a5,s0
 3e8:	02d00793          	li	a5,45
 3ec:	fef70823          	sb	a5,-16(a4)
 3f0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3f4:	02e05863          	blez	a4,424 <printint+0x96>
 3f8:	fc040793          	add	a5,s0,-64
 3fc:	00e78933          	add	s2,a5,a4
 400:	fff78993          	add	s3,a5,-1
 404:	99ba                	add	s3,s3,a4
 406:	377d                	addw	a4,a4,-1
 408:	1702                	sll	a4,a4,0x20
 40a:	9301                	srl	a4,a4,0x20
 40c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 410:	fff94583          	lbu	a1,-1(s2)
 414:	8526                	mv	a0,s1
 416:	00000097          	auipc	ra,0x0
 41a:	f56080e7          	jalr	-170(ra) # 36c <putc>
  while(--i >= 0)
 41e:	197d                	add	s2,s2,-1
 420:	ff3918e3          	bne	s2,s3,410 <printint+0x82>
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	7902                	ld	s2,32(sp)
 42c:	69e2                	ld	s3,24(sp)
 42e:	6121                	add	sp,sp,64
 430:	8082                	ret
    x = -xx;
 432:	40b005bb          	negw	a1,a1
    neg = 1;
 436:	4885                	li	a7,1
    x = -xx;
 438:	bf85                	j	3a8 <printint+0x1a>

000000000000043a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43a:	715d                	add	sp,sp,-80
 43c:	e486                	sd	ra,72(sp)
 43e:	e0a2                	sd	s0,64(sp)
 440:	fc26                	sd	s1,56(sp)
 442:	f84a                	sd	s2,48(sp)
 444:	f44e                	sd	s3,40(sp)
 446:	f052                	sd	s4,32(sp)
 448:	ec56                	sd	s5,24(sp)
 44a:	e85a                	sd	s6,16(sp)
 44c:	e45e                	sd	s7,8(sp)
 44e:	e062                	sd	s8,0(sp)
 450:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 452:	0005c903          	lbu	s2,0(a1)
 456:	18090c63          	beqz	s2,5ee <vprintf+0x1b4>
 45a:	8aaa                	mv	s5,a0
 45c:	8bb2                	mv	s7,a2
 45e:	00158493          	add	s1,a1,1
  state = 0;
 462:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 464:	02500a13          	li	s4,37
 468:	4b55                	li	s6,21
 46a:	a839                	j	488 <vprintf+0x4e>
        putc(fd, c);
 46c:	85ca                	mv	a1,s2
 46e:	8556                	mv	a0,s5
 470:	00000097          	auipc	ra,0x0
 474:	efc080e7          	jalr	-260(ra) # 36c <putc>
 478:	a019                	j	47e <vprintf+0x44>
    } else if(state == '%'){
 47a:	01498d63          	beq	s3,s4,494 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 47e:	0485                	add	s1,s1,1
 480:	fff4c903          	lbu	s2,-1(s1)
 484:	16090563          	beqz	s2,5ee <vprintf+0x1b4>
    if(state == 0){
 488:	fe0999e3          	bnez	s3,47a <vprintf+0x40>
      if(c == '%'){
 48c:	ff4910e3          	bne	s2,s4,46c <vprintf+0x32>
        state = '%';
 490:	89d2                	mv	s3,s4
 492:	b7f5                	j	47e <vprintf+0x44>
      if(c == 'd'){
 494:	13490263          	beq	s2,s4,5b8 <vprintf+0x17e>
 498:	f9d9079b          	addw	a5,s2,-99
 49c:	0ff7f793          	zext.b	a5,a5
 4a0:	12fb6563          	bltu	s6,a5,5ca <vprintf+0x190>
 4a4:	f9d9079b          	addw	a5,s2,-99
 4a8:	0ff7f713          	zext.b	a4,a5
 4ac:	10eb6f63          	bltu	s6,a4,5ca <vprintf+0x190>
 4b0:	00271793          	sll	a5,a4,0x2
 4b4:	00000717          	auipc	a4,0x0
 4b8:	3dc70713          	add	a4,a4,988 # 890 <statistics+0xbe>
 4bc:	97ba                	add	a5,a5,a4
 4be:	439c                	lw	a5,0(a5)
 4c0:	97ba                	add	a5,a5,a4
 4c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4c4:	008b8913          	add	s2,s7,8
 4c8:	4685                	li	a3,1
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	ebc080e7          	jalr	-324(ra) # 38e <printint>
 4da:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b745                	j	47e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e0:	008b8913          	add	s2,s7,8
 4e4:	4681                	li	a3,0
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	ea0080e7          	jalr	-352(ra) # 38e <printint>
 4f6:	8bca                	mv	s7,s2
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b751                	j	47e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4fc:	008b8913          	add	s2,s7,8
 500:	4681                	li	a3,0
 502:	4641                	li	a2,16
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	e84080e7          	jalr	-380(ra) # 38e <printint>
 512:	8bca                	mv	s7,s2
      state = 0;
 514:	4981                	li	s3,0
 516:	b7a5                	j	47e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 518:	008b8c13          	add	s8,s7,8
 51c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 520:	03000593          	li	a1,48
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e46080e7          	jalr	-442(ra) # 36c <putc>
  putc(fd, 'x');
 52e:	07800593          	li	a1,120
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e38080e7          	jalr	-456(ra) # 36c <putc>
 53c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53e:	00000b97          	auipc	s7,0x0
 542:	3aab8b93          	add	s7,s7,938 # 8e8 <digits>
 546:	03c9d793          	srl	a5,s3,0x3c
 54a:	97de                	add	a5,a5,s7
 54c:	0007c583          	lbu	a1,0(a5)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e1a080e7          	jalr	-486(ra) # 36c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55a:	0992                	sll	s3,s3,0x4
 55c:	397d                	addw	s2,s2,-1
 55e:	fe0914e3          	bnez	s2,546 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 562:	8be2                	mv	s7,s8
      state = 0;
 564:	4981                	li	s3,0
 566:	bf21                	j	47e <vprintf+0x44>
        s = va_arg(ap, char*);
 568:	008b8993          	add	s3,s7,8
 56c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 570:	02090163          	beqz	s2,592 <vprintf+0x158>
        while(*s != 0){
 574:	00094583          	lbu	a1,0(s2)
 578:	c9a5                	beqz	a1,5e8 <vprintf+0x1ae>
          putc(fd, *s);
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	df0080e7          	jalr	-528(ra) # 36c <putc>
          s++;
 584:	0905                	add	s2,s2,1
        while(*s != 0){
 586:	00094583          	lbu	a1,0(s2)
 58a:	f9e5                	bnez	a1,57a <vprintf+0x140>
        s = va_arg(ap, char*);
 58c:	8bce                	mv	s7,s3
      state = 0;
 58e:	4981                	li	s3,0
 590:	b5fd                	j	47e <vprintf+0x44>
          s = "(null)";
 592:	00000917          	auipc	s2,0x0
 596:	2f690913          	add	s2,s2,758 # 888 <statistics+0xb6>
        while(*s != 0){
 59a:	02800593          	li	a1,40
 59e:	bff1                	j	57a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5a0:	008b8913          	add	s2,s7,8
 5a4:	000bc583          	lbu	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	dc2080e7          	jalr	-574(ra) # 36c <putc>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b5e1                	j	47e <vprintf+0x44>
        putc(fd, c);
 5b8:	02500593          	li	a1,37
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	dae080e7          	jalr	-594(ra) # 36c <putc>
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bd5d                	j	47e <vprintf+0x44>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	d9c080e7          	jalr	-612(ra) # 36c <putc>
        putc(fd, c);
 5d8:	85ca                	mv	a1,s2
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	d90080e7          	jalr	-624(ra) # 36c <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd61                	j	47e <vprintf+0x44>
        s = va_arg(ap, char*);
 5e8:	8bce                	mv	s7,s3
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bd49                	j	47e <vprintf+0x44>
    }
  }
}
 5ee:	60a6                	ld	ra,72(sp)
 5f0:	6406                	ld	s0,64(sp)
 5f2:	74e2                	ld	s1,56(sp)
 5f4:	7942                	ld	s2,48(sp)
 5f6:	79a2                	ld	s3,40(sp)
 5f8:	7a02                	ld	s4,32(sp)
 5fa:	6ae2                	ld	s5,24(sp)
 5fc:	6b42                	ld	s6,16(sp)
 5fe:	6ba2                	ld	s7,8(sp)
 600:	6c02                	ld	s8,0(sp)
 602:	6161                	add	sp,sp,80
 604:	8082                	ret

0000000000000606 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 606:	715d                	add	sp,sp,-80
 608:	ec06                	sd	ra,24(sp)
 60a:	e822                	sd	s0,16(sp)
 60c:	1000                	add	s0,sp,32
 60e:	e010                	sd	a2,0(s0)
 610:	e414                	sd	a3,8(s0)
 612:	e818                	sd	a4,16(s0)
 614:	ec1c                	sd	a5,24(s0)
 616:	03043023          	sd	a6,32(s0)
 61a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 61e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 622:	8622                	mv	a2,s0
 624:	00000097          	auipc	ra,0x0
 628:	e16080e7          	jalr	-490(ra) # 43a <vprintf>
}
 62c:	60e2                	ld	ra,24(sp)
 62e:	6442                	ld	s0,16(sp)
 630:	6161                	add	sp,sp,80
 632:	8082                	ret

0000000000000634 <printf>:

void
printf(const char *fmt, ...)
{
 634:	711d                	add	sp,sp,-96
 636:	ec06                	sd	ra,24(sp)
 638:	e822                	sd	s0,16(sp)
 63a:	1000                	add	s0,sp,32
 63c:	e40c                	sd	a1,8(s0)
 63e:	e810                	sd	a2,16(s0)
 640:	ec14                	sd	a3,24(s0)
 642:	f018                	sd	a4,32(s0)
 644:	f41c                	sd	a5,40(s0)
 646:	03043823          	sd	a6,48(s0)
 64a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 64e:	00840613          	add	a2,s0,8
 652:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 656:	85aa                	mv	a1,a0
 658:	4505                	li	a0,1
 65a:	00000097          	auipc	ra,0x0
 65e:	de0080e7          	jalr	-544(ra) # 43a <vprintf>
}
 662:	60e2                	ld	ra,24(sp)
 664:	6442                	ld	s0,16(sp)
 666:	6125                	add	sp,sp,96
 668:	8082                	ret

000000000000066a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66a:	1141                	add	sp,sp,-16
 66c:	e422                	sd	s0,8(sp)
 66e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	00000797          	auipc	a5,0x0
 678:	2b47b783          	ld	a5,692(a5) # 928 <freep>
 67c:	a02d                	j	6a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 67e:	4618                	lw	a4,8(a2)
 680:	9f2d                	addw	a4,a4,a1
 682:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 686:	6398                	ld	a4,0(a5)
 688:	6310                	ld	a2,0(a4)
 68a:	a83d                	j	6c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 68c:	ff852703          	lw	a4,-8(a0)
 690:	9f31                	addw	a4,a4,a2
 692:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 694:	ff053683          	ld	a3,-16(a0)
 698:	a091                	j	6dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69a:	6398                	ld	a4,0(a5)
 69c:	00e7e463          	bltu	a5,a4,6a4 <free+0x3a>
 6a0:	00e6ea63          	bltu	a3,a4,6b4 <free+0x4a>
{
 6a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	fed7fae3          	bgeu	a5,a3,69a <free+0x30>
 6aa:	6398                	ld	a4,0(a5)
 6ac:	00e6e463          	bltu	a3,a4,6b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	fee7eae3          	bltu	a5,a4,6a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6b4:	ff852583          	lw	a1,-8(a0)
 6b8:	6390                	ld	a2,0(a5)
 6ba:	02059813          	sll	a6,a1,0x20
 6be:	01c85713          	srl	a4,a6,0x1c
 6c2:	9736                	add	a4,a4,a3
 6c4:	fae60de3          	beq	a2,a4,67e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6cc:	4790                	lw	a2,8(a5)
 6ce:	02061593          	sll	a1,a2,0x20
 6d2:	01c5d713          	srl	a4,a1,0x1c
 6d6:	973e                	add	a4,a4,a5
 6d8:	fae68ae3          	beq	a3,a4,68c <free+0x22>
    p->s.ptr = bp->s.ptr;
 6dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6de:	00000717          	auipc	a4,0x0
 6e2:	24f73523          	sd	a5,586(a4) # 928 <freep>
}
 6e6:	6422                	ld	s0,8(sp)
 6e8:	0141                	add	sp,sp,16
 6ea:	8082                	ret

00000000000006ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ec:	7139                	add	sp,sp,-64
 6ee:	fc06                	sd	ra,56(sp)
 6f0:	f822                	sd	s0,48(sp)
 6f2:	f426                	sd	s1,40(sp)
 6f4:	f04a                	sd	s2,32(sp)
 6f6:	ec4e                	sd	s3,24(sp)
 6f8:	e852                	sd	s4,16(sp)
 6fa:	e456                	sd	s5,8(sp)
 6fc:	e05a                	sd	s6,0(sp)
 6fe:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 700:	02051493          	sll	s1,a0,0x20
 704:	9081                	srl	s1,s1,0x20
 706:	04bd                	add	s1,s1,15
 708:	8091                	srl	s1,s1,0x4
 70a:	0014899b          	addw	s3,s1,1
 70e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 710:	00000517          	auipc	a0,0x0
 714:	21853503          	ld	a0,536(a0) # 928 <freep>
 718:	c515                	beqz	a0,744 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 71c:	4798                	lw	a4,8(a5)
 71e:	02977f63          	bgeu	a4,s1,75c <malloc+0x70>
  if(nu < 4096)
 722:	8a4e                	mv	s4,s3
 724:	0009871b          	sext.w	a4,s3
 728:	6685                	lui	a3,0x1
 72a:	00d77363          	bgeu	a4,a3,730 <malloc+0x44>
 72e:	6a05                	lui	s4,0x1
 730:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 734:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 738:	00000917          	auipc	s2,0x0
 73c:	1f090913          	add	s2,s2,496 # 928 <freep>
  if(p == (char*)-1)
 740:	5afd                	li	s5,-1
 742:	a895                	j	7b6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 744:	00000797          	auipc	a5,0x0
 748:	1ec78793          	add	a5,a5,492 # 930 <base>
 74c:	00000717          	auipc	a4,0x0
 750:	1cf73e23          	sd	a5,476(a4) # 928 <freep>
 754:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 756:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 75a:	b7e1                	j	722 <malloc+0x36>
      if(p->s.size == nunits)
 75c:	02e48c63          	beq	s1,a4,794 <malloc+0xa8>
        p->s.size -= nunits;
 760:	4137073b          	subw	a4,a4,s3
 764:	c798                	sw	a4,8(a5)
        p += p->s.size;
 766:	02071693          	sll	a3,a4,0x20
 76a:	01c6d713          	srl	a4,a3,0x1c
 76e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 770:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 774:	00000717          	auipc	a4,0x0
 778:	1aa73a23          	sd	a0,436(a4) # 928 <freep>
      return (void*)(p + 1);
 77c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 780:	70e2                	ld	ra,56(sp)
 782:	7442                	ld	s0,48(sp)
 784:	74a2                	ld	s1,40(sp)
 786:	7902                	ld	s2,32(sp)
 788:	69e2                	ld	s3,24(sp)
 78a:	6a42                	ld	s4,16(sp)
 78c:	6aa2                	ld	s5,8(sp)
 78e:	6b02                	ld	s6,0(sp)
 790:	6121                	add	sp,sp,64
 792:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	e118                	sd	a4,0(a0)
 798:	bff1                	j	774 <malloc+0x88>
  hp->s.size = nu;
 79a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 79e:	0541                	add	a0,a0,16
 7a0:	00000097          	auipc	ra,0x0
 7a4:	eca080e7          	jalr	-310(ra) # 66a <free>
  return freep;
 7a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ac:	d971                	beqz	a0,780 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b0:	4798                	lw	a4,8(a5)
 7b2:	fa9775e3          	bgeu	a4,s1,75c <malloc+0x70>
    if(p == freep)
 7b6:	00093703          	ld	a4,0(s2)
 7ba:	853e                	mv	a0,a5
 7bc:	fef719e3          	bne	a4,a5,7ae <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7c0:	8552                	mv	a0,s4
 7c2:	00000097          	auipc	ra,0x0
 7c6:	b92080e7          	jalr	-1134(ra) # 354 <sbrk>
  if(p == (char*)-1)
 7ca:	fd5518e3          	bne	a0,s5,79a <malloc+0xae>
        return 0;
 7ce:	4501                	li	a0,0
 7d0:	bf45                	j	780 <malloc+0x94>

00000000000007d2 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 7d2:	7179                	add	sp,sp,-48
 7d4:	f406                	sd	ra,40(sp)
 7d6:	f022                	sd	s0,32(sp)
 7d8:	ec26                	sd	s1,24(sp)
 7da:	e84a                	sd	s2,16(sp)
 7dc:	e44e                	sd	s3,8(sp)
 7de:	e052                	sd	s4,0(sp)
 7e0:	1800                	add	s0,sp,48
 7e2:	8a2a                	mv	s4,a0
 7e4:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 7e6:	4581                	li	a1,0
 7e8:	00000517          	auipc	a0,0x0
 7ec:	11850513          	add	a0,a0,280 # 900 <digits+0x18>
 7f0:	00000097          	auipc	ra,0x0
 7f4:	b1c080e7          	jalr	-1252(ra) # 30c <open>
  if(fd < 0) {
 7f8:	04054263          	bltz	a0,83c <statistics+0x6a>
 7fc:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 7fe:	4481                	li	s1,0
 800:	03205063          	blez	s2,820 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 804:	4099063b          	subw	a2,s2,s1
 808:	009a05b3          	add	a1,s4,s1
 80c:	854e                	mv	a0,s3
 80e:	00000097          	auipc	ra,0x0
 812:	ad6080e7          	jalr	-1322(ra) # 2e4 <read>
 816:	00054563          	bltz	a0,820 <statistics+0x4e>
      break;
    }
    i += n;
 81a:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 81c:	ff24c4e3          	blt	s1,s2,804 <statistics+0x32>
  }
  close(fd);
 820:	854e                	mv	a0,s3
 822:	00000097          	auipc	ra,0x0
 826:	ad2080e7          	jalr	-1326(ra) # 2f4 <close>
  return i;
}
 82a:	8526                	mv	a0,s1
 82c:	70a2                	ld	ra,40(sp)
 82e:	7402                	ld	s0,32(sp)
 830:	64e2                	ld	s1,24(sp)
 832:	6942                	ld	s2,16(sp)
 834:	69a2                	ld	s3,8(sp)
 836:	6a02                	ld	s4,0(sp)
 838:	6145                	add	sp,sp,48
 83a:	8082                	ret
      fprintf(2, "stats: open failed\n");
 83c:	00000597          	auipc	a1,0x0
 840:	0d458593          	add	a1,a1,212 # 910 <digits+0x28>
 844:	4509                	li	a0,2
 846:	00000097          	auipc	ra,0x0
 84a:	dc0080e7          	jalr	-576(ra) # 606 <fprintf>
      exit(1);
 84e:	4505                	li	a0,1
 850:	00000097          	auipc	ra,0x0
 854:	a7c080e7          	jalr	-1412(ra) # 2cc <exit>
