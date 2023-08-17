
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1ae080e7          	jalr	430(ra) # 1d6 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2d0080e7          	jalr	720(ra) # 300 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	add	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	290080e7          	jalr	656(ra) # 2d0 <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7a058593          	add	a1,a1,1952 # 7e8 <malloc+0xe8>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5c8080e7          	jalr	1480(ra) # 61a <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	274080e7          	jalr	628(ra) # 2d0 <exit>

0000000000000064 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  64:	1141                	add	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	add	a1,a1,1
  6e:	0785                	add	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	add	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	add	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	add	a0,a0,1
  96:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	add	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	add	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	add	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	86be                	mv	a3,a5
  be:	0785                	add	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	ff65                	bnez	a4,bc <strlen+0x10>
  c6:	40a6853b          	subw	a0,a3,a0
  ca:	2505                	addw	a0,a0,1
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	add	sp,sp,16
  d0:	8082                	ret
  for(n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	1141                	add	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  dc:	ca19                	beqz	a2,f2 <memset+0x1c>
  de:	87aa                	mv	a5,a0
  e0:	1602                	sll	a2,a2,0x20
  e2:	9201                	srl	a2,a2,0x20
  e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ec:	0785                	add	a5,a5,1
  ee:	fee79de3          	bne	a5,a4,e8 <memset+0x12>
  }
  return dst;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	add	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	1141                	add	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	add	s0,sp,16
  for(; *s; s++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb99                	beqz	a5,118 <strchr+0x20>
    if(*s == c)
 104:	00f58763          	beq	a1,a5,112 <strchr+0x1a>
  for(; *s; s++)
 108:	0505                	add	a0,a0,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbfd                	bnez	a5,104 <strchr+0xc>
      return (char*)s;
  return 0;
 110:	4501                	li	a0,0
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	add	sp,sp,16
 116:	8082                	ret
  return 0;
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strchr+0x1a>

000000000000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	711d                	add	sp,sp,-96
 11e:	ec86                	sd	ra,88(sp)
 120:	e8a2                	sd	s0,80(sp)
 122:	e4a6                	sd	s1,72(sp)
 124:	e0ca                	sd	s2,64(sp)
 126:	fc4e                	sd	s3,56(sp)
 128:	f852                	sd	s4,48(sp)
 12a:	f456                	sd	s5,40(sp)
 12c:	f05a                	sd	s6,32(sp)
 12e:	ec5e                	sd	s7,24(sp)
 130:	1080                	add	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4aa9                	li	s5,10
 13c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13e:	89a6                	mv	s3,s1
 140:	2485                	addw	s1,s1,1
 142:	0344d863          	bge	s1,s4,172 <gets+0x56>
    cc = read(0, &c, 1);
 146:	4605                	li	a2,1
 148:	faf40593          	add	a1,s0,-81
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	19a080e7          	jalr	410(ra) # 2e8 <read>
    if(cc < 1)
 156:	00a05e63          	blez	a0,172 <gets+0x56>
    buf[i++] = c;
 15a:	faf44783          	lbu	a5,-81(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	01578763          	beq	a5,s5,170 <gets+0x54>
 166:	0905                	add	s2,s2,1
 168:	fd679be3          	bne	a5,s6,13e <gets+0x22>
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	a011                	j	172 <gets+0x56>
 170:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 172:	99de                	add	s3,s3,s7
 174:	00098023          	sb	zero,0(s3)
  return buf;
}
 178:	855e                	mv	a0,s7
 17a:	60e6                	ld	ra,88(sp)
 17c:	6446                	ld	s0,80(sp)
 17e:	64a6                	ld	s1,72(sp)
 180:	6906                	ld	s2,64(sp)
 182:	79e2                	ld	s3,56(sp)
 184:	7a42                	ld	s4,48(sp)
 186:	7aa2                	ld	s5,40(sp)
 188:	7b02                	ld	s6,32(sp)
 18a:	6be2                	ld	s7,24(sp)
 18c:	6125                	add	sp,sp,96
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	add	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e426                	sd	s1,8(sp)
 198:	e04a                	sd	s2,0(sp)
 19a:	1000                	add	s0,sp,32
 19c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	4581                	li	a1,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	170080e7          	jalr	368(ra) # 310 <open>
  if(fd < 0)
 1a8:	02054563          	bltz	a0,1d2 <stat+0x42>
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	00000097          	auipc	ra,0x0
 1b4:	178080e7          	jalr	376(ra) # 328 <fstat>
 1b8:	892a                	mv	s2,a0
  close(fd);
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	13c080e7          	jalr	316(ra) # 2f8 <close>
  return r;
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	64a2                	ld	s1,8(sp)
 1cc:	6902                	ld	s2,0(sp)
 1ce:	6105                	add	sp,sp,32
 1d0:	8082                	ret
    return -1;
 1d2:	597d                	li	s2,-1
 1d4:	bfc5                	j	1c4 <stat+0x34>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	add	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1dc:	00054683          	lbu	a3,0(a0)
 1e0:	fd06879b          	addw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	4625                	li	a2,9
 1ea:	02f66863          	bltu	a2,a5,21a <atoi+0x44>
 1ee:	872a                	mv	a4,a0
  n = 0;
 1f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f2:	0705                	add	a4,a4,1
 1f4:	0025179b          	sllw	a5,a0,0x2
 1f8:	9fa9                	addw	a5,a5,a0
 1fa:	0017979b          	sllw	a5,a5,0x1
 1fe:	9fb5                	addw	a5,a5,a3
 200:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 204:	00074683          	lbu	a3,0(a4)
 208:	fd06879b          	addw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	fef671e3          	bgeu	a2,a5,1f2 <atoi+0x1c>
  return n;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	add	sp,sp,16
 218:	8082                	ret
  n = 0;
 21a:	4501                	li	a0,0
 21c:	bfe5                	j	214 <atoi+0x3e>

000000000000021e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21e:	1141                	add	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 224:	02b57463          	bgeu	a0,a1,24c <memmove+0x2e>
    while(n-- > 0)
 228:	00c05f63          	blez	a2,246 <memmove+0x28>
 22c:	1602                	sll	a2,a2,0x20
 22e:	9201                	srl	a2,a2,0x20
 230:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 234:	872a                	mv	a4,a0
      *dst++ = *src++;
 236:	0585                	add	a1,a1,1
 238:	0705                	add	a4,a4,1
 23a:	fff5c683          	lbu	a3,-1(a1)
 23e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	add	sp,sp,16
 24a:	8082                	ret
    dst += n;
 24c:	00c50733          	add	a4,a0,a2
    src += n;
 250:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 252:	fec05ae3          	blez	a2,246 <memmove+0x28>
 256:	fff6079b          	addw	a5,a2,-1
 25a:	1782                	sll	a5,a5,0x20
 25c:	9381                	srl	a5,a5,0x20
 25e:	fff7c793          	not	a5,a5
 262:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 264:	15fd                	add	a1,a1,-1
 266:	177d                	add	a4,a4,-1
 268:	0005c683          	lbu	a3,0(a1)
 26c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x46>
 274:	bfc9                	j	246 <memmove+0x28>

0000000000000276 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 276:	1141                	add	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27c:	ca05                	beqz	a2,2ac <memcmp+0x36>
 27e:	fff6069b          	addw	a3,a2,-1
 282:	1682                	sll	a3,a3,0x20
 284:	9281                	srl	a3,a3,0x20
 286:	0685                	add	a3,a3,1
 288:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28a:	00054783          	lbu	a5,0(a0)
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00e79863          	bne	a5,a4,2a2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 296:	0505                	add	a0,a0,1
    p2++;
 298:	0585                	add	a1,a1,1
  while (n-- > 0) {
 29a:	fed518e3          	bne	a0,a3,28a <memcmp+0x14>
  }
  return 0;
 29e:	4501                	li	a0,0
 2a0:	a019                	j	2a6 <memcmp+0x30>
      return *p1 - *p2;
 2a2:	40e7853b          	subw	a0,a5,a4
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	add	sp,sp,16
 2aa:	8082                	ret
  return 0;
 2ac:	4501                	li	a0,0
 2ae:	bfe5                	j	2a6 <memcmp+0x30>

00000000000002b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b0:	1141                	add	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b8:	00000097          	auipc	ra,0x0
 2bc:	f66080e7          	jalr	-154(ra) # 21e <memmove>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	add	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c8:	4885                	li	a7,1
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d0:	4889                	li	a7,2
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d8:	488d                	li	a7,3
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <close>:
.global close
close:
 li a7, SYS_close
 2f8:	48d5                	li	a7,21
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48bd                	li	a7,15
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 318:	48c5                	li	a7,17
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 320:	48c9                	li	a7,18
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 328:	48a1                	li	a7,8
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <link>:
.global link
link:
 li a7, SYS_link
 330:	48cd                	li	a7,19
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 338:	48d1                	li	a7,20
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 340:	48a5                	li	a7,9
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <dup>:
.global dup
dup:
 li a7, SYS_dup
 348:	48a9                	li	a7,10
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 350:	48ad                	li	a7,11
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 358:	48b1                	li	a7,12
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 360:	48b5                	li	a7,13
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 368:	48b9                	li	a7,14
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 370:	48d9                	li	a7,22
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 378:	48dd                	li	a7,23
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 380:	1101                	add	sp,sp,-32
 382:	ec06                	sd	ra,24(sp)
 384:	e822                	sd	s0,16(sp)
 386:	1000                	add	s0,sp,32
 388:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38c:	4605                	li	a2,1
 38e:	fef40593          	add	a1,s0,-17
 392:	00000097          	auipc	ra,0x0
 396:	f5e080e7          	jalr	-162(ra) # 2f0 <write>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	6105                	add	sp,sp,32
 3a0:	8082                	ret

00000000000003a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a2:	7139                	add	sp,sp,-64
 3a4:	fc06                	sd	ra,56(sp)
 3a6:	f822                	sd	s0,48(sp)
 3a8:	f426                	sd	s1,40(sp)
 3aa:	f04a                	sd	s2,32(sp)
 3ac:	ec4e                	sd	s3,24(sp)
 3ae:	0080                	add	s0,sp,64
 3b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b2:	c299                	beqz	a3,3b8 <printint+0x16>
 3b4:	0805c963          	bltz	a1,446 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b8:	2581                	sext.w	a1,a1
  neg = 0;
 3ba:	4881                	li	a7,0
 3bc:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c2:	2601                	sext.w	a2,a2
 3c4:	00000517          	auipc	a0,0x0
 3c8:	49c50513          	add	a0,a0,1180 # 860 <digits>
 3cc:	883a                	mv	a6,a4
 3ce:	2705                	addw	a4,a4,1
 3d0:	02c5f7bb          	remuw	a5,a1,a2
 3d4:	1782                	sll	a5,a5,0x20
 3d6:	9381                	srl	a5,a5,0x20
 3d8:	97aa                	add	a5,a5,a0
 3da:	0007c783          	lbu	a5,0(a5)
 3de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e2:	0005879b          	sext.w	a5,a1
 3e6:	02c5d5bb          	divuw	a1,a1,a2
 3ea:	0685                	add	a3,a3,1
 3ec:	fec7f0e3          	bgeu	a5,a2,3cc <printint+0x2a>
  if(neg)
 3f0:	00088c63          	beqz	a7,408 <printint+0x66>
    buf[i++] = '-';
 3f4:	fd070793          	add	a5,a4,-48
 3f8:	00878733          	add	a4,a5,s0
 3fc:	02d00793          	li	a5,45
 400:	fef70823          	sb	a5,-16(a4)
 404:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 408:	02e05863          	blez	a4,438 <printint+0x96>
 40c:	fc040793          	add	a5,s0,-64
 410:	00e78933          	add	s2,a5,a4
 414:	fff78993          	add	s3,a5,-1
 418:	99ba                	add	s3,s3,a4
 41a:	377d                	addw	a4,a4,-1
 41c:	1702                	sll	a4,a4,0x20
 41e:	9301                	srl	a4,a4,0x20
 420:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 424:	fff94583          	lbu	a1,-1(s2)
 428:	8526                	mv	a0,s1
 42a:	00000097          	auipc	ra,0x0
 42e:	f56080e7          	jalr	-170(ra) # 380 <putc>
  while(--i >= 0)
 432:	197d                	add	s2,s2,-1
 434:	ff3918e3          	bne	s2,s3,424 <printint+0x82>
}
 438:	70e2                	ld	ra,56(sp)
 43a:	7442                	ld	s0,48(sp)
 43c:	74a2                	ld	s1,40(sp)
 43e:	7902                	ld	s2,32(sp)
 440:	69e2                	ld	s3,24(sp)
 442:	6121                	add	sp,sp,64
 444:	8082                	ret
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4885                	li	a7,1
    x = -xx;
 44c:	bf85                	j	3bc <printint+0x1a>

000000000000044e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44e:	715d                	add	sp,sp,-80
 450:	e486                	sd	ra,72(sp)
 452:	e0a2                	sd	s0,64(sp)
 454:	fc26                	sd	s1,56(sp)
 456:	f84a                	sd	s2,48(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	f052                	sd	s4,32(sp)
 45c:	ec56                	sd	s5,24(sp)
 45e:	e85a                	sd	s6,16(sp)
 460:	e45e                	sd	s7,8(sp)
 462:	e062                	sd	s8,0(sp)
 464:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 466:	0005c903          	lbu	s2,0(a1)
 46a:	18090c63          	beqz	s2,602 <vprintf+0x1b4>
 46e:	8aaa                	mv	s5,a0
 470:	8bb2                	mv	s7,a2
 472:	00158493          	add	s1,a1,1
  state = 0;
 476:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 478:	02500a13          	li	s4,37
 47c:	4b55                	li	s6,21
 47e:	a839                	j	49c <vprintf+0x4e>
        putc(fd, c);
 480:	85ca                	mv	a1,s2
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	efc080e7          	jalr	-260(ra) # 380 <putc>
 48c:	a019                	j	492 <vprintf+0x44>
    } else if(state == '%'){
 48e:	01498d63          	beq	s3,s4,4a8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 492:	0485                	add	s1,s1,1
 494:	fff4c903          	lbu	s2,-1(s1)
 498:	16090563          	beqz	s2,602 <vprintf+0x1b4>
    if(state == 0){
 49c:	fe0999e3          	bnez	s3,48e <vprintf+0x40>
      if(c == '%'){
 4a0:	ff4910e3          	bne	s2,s4,480 <vprintf+0x32>
        state = '%';
 4a4:	89d2                	mv	s3,s4
 4a6:	b7f5                	j	492 <vprintf+0x44>
      if(c == 'd'){
 4a8:	13490263          	beq	s2,s4,5cc <vprintf+0x17e>
 4ac:	f9d9079b          	addw	a5,s2,-99
 4b0:	0ff7f793          	zext.b	a5,a5
 4b4:	12fb6563          	bltu	s6,a5,5de <vprintf+0x190>
 4b8:	f9d9079b          	addw	a5,s2,-99
 4bc:	0ff7f713          	zext.b	a4,a5
 4c0:	10eb6f63          	bltu	s6,a4,5de <vprintf+0x190>
 4c4:	00271793          	sll	a5,a4,0x2
 4c8:	00000717          	auipc	a4,0x0
 4cc:	34070713          	add	a4,a4,832 # 808 <malloc+0x108>
 4d0:	97ba                	add	a5,a5,a4
 4d2:	439c                	lw	a5,0(a5)
 4d4:	97ba                	add	a5,a5,a4
 4d6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d8:	008b8913          	add	s2,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000ba583          	lw	a1,0(s7)
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	ebc080e7          	jalr	-324(ra) # 3a2 <printint>
 4ee:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b745                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f4:	008b8913          	add	s2,s7,8
 4f8:	4681                	li	a3,0
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	ea0080e7          	jalr	-352(ra) # 3a2 <printint>
 50a:	8bca                	mv	s7,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	b751                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 510:	008b8913          	add	s2,s7,8
 514:	4681                	li	a3,0
 516:	4641                	li	a2,16
 518:	000ba583          	lw	a1,0(s7)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e84080e7          	jalr	-380(ra) # 3a2 <printint>
 526:	8bca                	mv	s7,s2
      state = 0;
 528:	4981                	li	s3,0
 52a:	b7a5                	j	492 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 52c:	008b8c13          	add	s8,s7,8
 530:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 534:	03000593          	li	a1,48
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e46080e7          	jalr	-442(ra) # 380 <putc>
  putc(fd, 'x');
 542:	07800593          	li	a1,120
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e38080e7          	jalr	-456(ra) # 380 <putc>
 550:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 552:	00000b97          	auipc	s7,0x0
 556:	30eb8b93          	add	s7,s7,782 # 860 <digits>
 55a:	03c9d793          	srl	a5,s3,0x3c
 55e:	97de                	add	a5,a5,s7
 560:	0007c583          	lbu	a1,0(a5)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e1a080e7          	jalr	-486(ra) # 380 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56e:	0992                	sll	s3,s3,0x4
 570:	397d                	addw	s2,s2,-1
 572:	fe0914e3          	bnez	s2,55a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 576:	8be2                	mv	s7,s8
      state = 0;
 578:	4981                	li	s3,0
 57a:	bf21                	j	492 <vprintf+0x44>
        s = va_arg(ap, char*);
 57c:	008b8993          	add	s3,s7,8
 580:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 584:	02090163          	beqz	s2,5a6 <vprintf+0x158>
        while(*s != 0){
 588:	00094583          	lbu	a1,0(s2)
 58c:	c9a5                	beqz	a1,5fc <vprintf+0x1ae>
          putc(fd, *s);
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	df0080e7          	jalr	-528(ra) # 380 <putc>
          s++;
 598:	0905                	add	s2,s2,1
        while(*s != 0){
 59a:	00094583          	lbu	a1,0(s2)
 59e:	f9e5                	bnez	a1,58e <vprintf+0x140>
        s = va_arg(ap, char*);
 5a0:	8bce                	mv	s7,s3
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b5fd                	j	492 <vprintf+0x44>
          s = "(null)";
 5a6:	00000917          	auipc	s2,0x0
 5aa:	25a90913          	add	s2,s2,602 # 800 <malloc+0x100>
        while(*s != 0){
 5ae:	02800593          	li	a1,40
 5b2:	bff1                	j	58e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5b4:	008b8913          	add	s2,s7,8
 5b8:	000bc583          	lbu	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	dc2080e7          	jalr	-574(ra) # 380 <putc>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b5e1                	j	492 <vprintf+0x44>
        putc(fd, c);
 5cc:	02500593          	li	a1,37
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	dae080e7          	jalr	-594(ra) # 380 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bd5d                	j	492 <vprintf+0x44>
        putc(fd, '%');
 5de:	02500593          	li	a1,37
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	d9c080e7          	jalr	-612(ra) # 380 <putc>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	d90080e7          	jalr	-624(ra) # 380 <putc>
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bd61                	j	492 <vprintf+0x44>
        s = va_arg(ap, char*);
 5fc:	8bce                	mv	s7,s3
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bd49                	j	492 <vprintf+0x44>
    }
  }
}
 602:	60a6                	ld	ra,72(sp)
 604:	6406                	ld	s0,64(sp)
 606:	74e2                	ld	s1,56(sp)
 608:	7942                	ld	s2,48(sp)
 60a:	79a2                	ld	s3,40(sp)
 60c:	7a02                	ld	s4,32(sp)
 60e:	6ae2                	ld	s5,24(sp)
 610:	6b42                	ld	s6,16(sp)
 612:	6ba2                	ld	s7,8(sp)
 614:	6c02                	ld	s8,0(sp)
 616:	6161                	add	sp,sp,80
 618:	8082                	ret

000000000000061a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61a:	715d                	add	sp,sp,-80
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	add	s0,sp,32
 622:	e010                	sd	a2,0(s0)
 624:	e414                	sd	a3,8(s0)
 626:	e818                	sd	a4,16(s0)
 628:	ec1c                	sd	a5,24(s0)
 62a:	03043023          	sd	a6,32(s0)
 62e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 632:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 636:	8622                	mv	a2,s0
 638:	00000097          	auipc	ra,0x0
 63c:	e16080e7          	jalr	-490(ra) # 44e <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6161                	add	sp,sp,80
 646:	8082                	ret

0000000000000648 <printf>:

void
printf(const char *fmt, ...)
{
 648:	711d                	add	sp,sp,-96
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	add	s0,sp,32
 650:	e40c                	sd	a1,8(s0)
 652:	e810                	sd	a2,16(s0)
 654:	ec14                	sd	a3,24(s0)
 656:	f018                	sd	a4,32(s0)
 658:	f41c                	sd	a5,40(s0)
 65a:	03043823          	sd	a6,48(s0)
 65e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	00840613          	add	a2,s0,8
 666:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66a:	85aa                	mv	a1,a0
 66c:	4505                	li	a0,1
 66e:	00000097          	auipc	ra,0x0
 672:	de0080e7          	jalr	-544(ra) # 44e <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6125                	add	sp,sp,96
 67c:	8082                	ret

000000000000067e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67e:	1141                	add	sp,sp,-16
 680:	e422                	sd	s0,8(sp)
 682:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 684:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	00000797          	auipc	a5,0x0
 68c:	1f07b783          	ld	a5,496(a5) # 878 <freep>
 690:	a02d                	j	6ba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 692:	4618                	lw	a4,8(a2)
 694:	9f2d                	addw	a4,a4,a1
 696:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 69a:	6398                	ld	a4,0(a5)
 69c:	6310                	ld	a2,0(a4)
 69e:	a83d                	j	6dc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a0:	ff852703          	lw	a4,-8(a0)
 6a4:	9f31                	addw	a4,a4,a2
 6a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6a8:	ff053683          	ld	a3,-16(a0)
 6ac:	a091                	j	6f0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ae:	6398                	ld	a4,0(a5)
 6b0:	00e7e463          	bltu	a5,a4,6b8 <free+0x3a>
 6b4:	00e6ea63          	bltu	a3,a4,6c8 <free+0x4a>
{
 6b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	fed7fae3          	bgeu	a5,a3,6ae <free+0x30>
 6be:	6398                	ld	a4,0(a5)
 6c0:	00e6e463          	bltu	a3,a4,6c8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	fee7eae3          	bltu	a5,a4,6b8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6c8:	ff852583          	lw	a1,-8(a0)
 6cc:	6390                	ld	a2,0(a5)
 6ce:	02059813          	sll	a6,a1,0x20
 6d2:	01c85713          	srl	a4,a6,0x1c
 6d6:	9736                	add	a4,a4,a3
 6d8:	fae60de3          	beq	a2,a4,692 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e0:	4790                	lw	a2,8(a5)
 6e2:	02061593          	sll	a1,a2,0x20
 6e6:	01c5d713          	srl	a4,a1,0x1c
 6ea:	973e                	add	a4,a4,a5
 6ec:	fae68ae3          	beq	a3,a4,6a0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6f2:	00000717          	auipc	a4,0x0
 6f6:	18f73323          	sd	a5,390(a4) # 878 <freep>
}
 6fa:	6422                	ld	s0,8(sp)
 6fc:	0141                	add	sp,sp,16
 6fe:	8082                	ret

0000000000000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	7139                	add	sp,sp,-64
 702:	fc06                	sd	ra,56(sp)
 704:	f822                	sd	s0,48(sp)
 706:	f426                	sd	s1,40(sp)
 708:	f04a                	sd	s2,32(sp)
 70a:	ec4e                	sd	s3,24(sp)
 70c:	e852                	sd	s4,16(sp)
 70e:	e456                	sd	s5,8(sp)
 710:	e05a                	sd	s6,0(sp)
 712:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 714:	02051493          	sll	s1,a0,0x20
 718:	9081                	srl	s1,s1,0x20
 71a:	04bd                	add	s1,s1,15
 71c:	8091                	srl	s1,s1,0x4
 71e:	0014899b          	addw	s3,s1,1
 722:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 724:	00000517          	auipc	a0,0x0
 728:	15453503          	ld	a0,340(a0) # 878 <freep>
 72c:	c515                	beqz	a0,758 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	02977f63          	bgeu	a4,s1,770 <malloc+0x70>
  if(nu < 4096)
 736:	8a4e                	mv	s4,s3
 738:	0009871b          	sext.w	a4,s3
 73c:	6685                	lui	a3,0x1
 73e:	00d77363          	bgeu	a4,a3,744 <malloc+0x44>
 742:	6a05                	lui	s4,0x1
 744:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 748:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74c:	00000917          	auipc	s2,0x0
 750:	12c90913          	add	s2,s2,300 # 878 <freep>
  if(p == (char*)-1)
 754:	5afd                	li	s5,-1
 756:	a895                	j	7ca <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 758:	00000797          	auipc	a5,0x0
 75c:	12878793          	add	a5,a5,296 # 880 <base>
 760:	00000717          	auipc	a4,0x0
 764:	10f73c23          	sd	a5,280(a4) # 878 <freep>
 768:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76e:	b7e1                	j	736 <malloc+0x36>
      if(p->s.size == nunits)
 770:	02e48c63          	beq	s1,a4,7a8 <malloc+0xa8>
        p->s.size -= nunits;
 774:	4137073b          	subw	a4,a4,s3
 778:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77a:	02071693          	sll	a3,a4,0x20
 77e:	01c6d713          	srl	a4,a3,0x1c
 782:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 784:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 788:	00000717          	auipc	a4,0x0
 78c:	0ea73823          	sd	a0,240(a4) # 878 <freep>
      return (void*)(p + 1);
 790:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 794:	70e2                	ld	ra,56(sp)
 796:	7442                	ld	s0,48(sp)
 798:	74a2                	ld	s1,40(sp)
 79a:	7902                	ld	s2,32(sp)
 79c:	69e2                	ld	s3,24(sp)
 79e:	6a42                	ld	s4,16(sp)
 7a0:	6aa2                	ld	s5,8(sp)
 7a2:	6b02                	ld	s6,0(sp)
 7a4:	6121                	add	sp,sp,64
 7a6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a8:	6398                	ld	a4,0(a5)
 7aa:	e118                	sd	a4,0(a0)
 7ac:	bff1                	j	788 <malloc+0x88>
  hp->s.size = nu;
 7ae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b2:	0541                	add	a0,a0,16
 7b4:	00000097          	auipc	ra,0x0
 7b8:	eca080e7          	jalr	-310(ra) # 67e <free>
  return freep;
 7bc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c0:	d971                	beqz	a0,794 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	fa9775e3          	bgeu	a4,s1,770 <malloc+0x70>
    if(p == freep)
 7ca:	00093703          	ld	a4,0(s2)
 7ce:	853e                	mv	a0,a5
 7d0:	fef719e3          	bne	a4,a5,7c2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7d4:	8552                	mv	a0,s4
 7d6:	00000097          	auipc	ra,0x0
 7da:	b82080e7          	jalr	-1150(ra) # 358 <sbrk>
  if(p == (char*)-1)
 7de:	fd5518e3          	bne	a0,s5,7ae <malloc+0xae>
        return 0;
 7e2:	4501                	li	a0,0
 7e4:	bf45                	j	794 <malloc+0x94>
