
user/_mkdir:     file format elf64-littleriscv


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
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	322080e7          	jalr	802(ra) # 34a <mkdir>
  30:	02054463          	bltz	a0,58 <main+0x58>
  for(i = 1; i < argc; i++){
  34:	04a1                	add	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a80d                	j	6c <main+0x6c>
    fprintf(2, "Usage: mkdir files...\n");
  3c:	00000597          	auipc	a1,0x0
  40:	7b458593          	add	a1,a1,1972 # 7f0 <malloc+0xe6>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	5de080e7          	jalr	1502(ra) # 624 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	292080e7          	jalr	658(ra) # 2e2 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  58:	6090                	ld	a2,0(s1)
  5a:	00000597          	auipc	a1,0x0
  5e:	7ae58593          	add	a1,a1,1966 # 808 <malloc+0xfe>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	5c0080e7          	jalr	1472(ra) # 624 <fprintf>
      break;
    }
  }

  exit(0);
  6c:	4501                	li	a0,0
  6e:	00000097          	auipc	ra,0x0
  72:	274080e7          	jalr	628(ra) # 2e2 <exit>

0000000000000076 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  76:	1141                	add	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7c:	87aa                	mv	a5,a0
  7e:	0585                	add	a1,a1,1
  80:	0785                	add	a5,a5,1
  82:	fff5c703          	lbu	a4,-1(a1)
  86:	fee78fa3          	sb	a4,-1(a5)
  8a:	fb75                	bnez	a4,7e <strcpy+0x8>
    ;
  return os;
}
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	add	sp,sp,16
  90:	8082                	ret

0000000000000092 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  92:	1141                	add	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	cb91                	beqz	a5,b0 <strcmp+0x1e>
  9e:	0005c703          	lbu	a4,0(a1)
  a2:	00f71763          	bne	a4,a5,b0 <strcmp+0x1e>
    p++, q++;
  a6:	0505                	add	a0,a0,1
  a8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	fbe5                	bnez	a5,9e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b0:	0005c503          	lbu	a0,0(a1)
}
  b4:	40a7853b          	subw	a0,a5,a0
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	add	sp,sp,16
  bc:	8082                	ret

00000000000000be <strlen>:

uint
strlen(const char *s)
{
  be:	1141                	add	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cf91                	beqz	a5,e4 <strlen+0x26>
  ca:	0505                	add	a0,a0,1
  cc:	87aa                	mv	a5,a0
  ce:	86be                	mv	a3,a5
  d0:	0785                	add	a5,a5,1
  d2:	fff7c703          	lbu	a4,-1(a5)
  d6:	ff65                	bnez	a4,ce <strlen+0x10>
  d8:	40a6853b          	subw	a0,a3,a0
  dc:	2505                	addw	a0,a0,1
    ;
  return n;
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	add	sp,sp,16
  e2:	8082                	ret
  for(n = 0; s[n]; n++)
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strlen+0x20>

00000000000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	1141                	add	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ee:	ca19                	beqz	a2,104 <memset+0x1c>
  f0:	87aa                	mv	a5,a0
  f2:	1602                	sll	a2,a2,0x20
  f4:	9201                	srl	a2,a2,0x20
  f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fe:	0785                	add	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <memset+0x12>
  }
  return dst;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	add	sp,sp,16
 108:	8082                	ret

000000000000010a <strchr>:

char*
strchr(const char *s, char c)
{
 10a:	1141                	add	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	add	s0,sp,16
  for(; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cb99                	beqz	a5,12a <strchr+0x20>
    if(*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1a>
  for(; *s; s++)
 11a:	0505                	add	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xc>
      return (char*)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	add	sp,sp,16
 128:	8082                	ret
  return 0;
 12a:	4501                	li	a0,0
 12c:	bfe5                	j	124 <strchr+0x1a>

000000000000012e <gets>:

char*
gets(char *buf, int max)
{
 12e:	711d                	add	sp,sp,-96
 130:	ec86                	sd	ra,88(sp)
 132:	e8a2                	sd	s0,80(sp)
 134:	e4a6                	sd	s1,72(sp)
 136:	e0ca                	sd	s2,64(sp)
 138:	fc4e                	sd	s3,56(sp)
 13a:	f852                	sd	s4,48(sp)
 13c:	f456                	sd	s5,40(sp)
 13e:	f05a                	sd	s6,32(sp)
 140:	ec5e                	sd	s7,24(sp)
 142:	1080                	add	s0,sp,96
 144:	8baa                	mv	s7,a0
 146:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 148:	892a                	mv	s2,a0
 14a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14c:	4aa9                	li	s5,10
 14e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 150:	89a6                	mv	s3,s1
 152:	2485                	addw	s1,s1,1
 154:	0344d863          	bge	s1,s4,184 <gets+0x56>
    cc = read(0, &c, 1);
 158:	4605                	li	a2,1
 15a:	faf40593          	add	a1,s0,-81
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	19a080e7          	jalr	410(ra) # 2fa <read>
    if(cc < 1)
 168:	00a05e63          	blez	a0,184 <gets+0x56>
    buf[i++] = c;
 16c:	faf44783          	lbu	a5,-81(s0)
 170:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 174:	01578763          	beq	a5,s5,182 <gets+0x54>
 178:	0905                	add	s2,s2,1
 17a:	fd679be3          	bne	a5,s6,150 <gets+0x22>
  for(i=0; i+1 < max; ){
 17e:	89a6                	mv	s3,s1
 180:	a011                	j	184 <gets+0x56>
 182:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 184:	99de                	add	s3,s3,s7
 186:	00098023          	sb	zero,0(s3)
  return buf;
}
 18a:	855e                	mv	a0,s7
 18c:	60e6                	ld	ra,88(sp)
 18e:	6446                	ld	s0,80(sp)
 190:	64a6                	ld	s1,72(sp)
 192:	6906                	ld	s2,64(sp)
 194:	79e2                	ld	s3,56(sp)
 196:	7a42                	ld	s4,48(sp)
 198:	7aa2                	ld	s5,40(sp)
 19a:	7b02                	ld	s6,32(sp)
 19c:	6be2                	ld	s7,24(sp)
 19e:	6125                	add	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	add	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	add	s0,sp,32
 1ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	4581                	li	a1,0
 1b2:	00000097          	auipc	ra,0x0
 1b6:	170080e7          	jalr	368(ra) # 322 <open>
  if(fd < 0)
 1ba:	02054563          	bltz	a0,1e4 <stat+0x42>
 1be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c0:	85ca                	mv	a1,s2
 1c2:	00000097          	auipc	ra,0x0
 1c6:	178080e7          	jalr	376(ra) # 33a <fstat>
 1ca:	892a                	mv	s2,a0
  close(fd);
 1cc:	8526                	mv	a0,s1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	13c080e7          	jalr	316(ra) # 30a <close>
  return r;
}
 1d6:	854a                	mv	a0,s2
 1d8:	60e2                	ld	ra,24(sp)
 1da:	6442                	ld	s0,16(sp)
 1dc:	64a2                	ld	s1,8(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	add	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfc5                	j	1d6 <stat+0x34>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	add	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054683          	lbu	a3,0(a0)
 1f2:	fd06879b          	addw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	4625                	li	a2,9
 1fc:	02f66863          	bltu	a2,a5,22c <atoi+0x44>
 200:	872a                	mv	a4,a0
  n = 0;
 202:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 204:	0705                	add	a4,a4,1
 206:	0025179b          	sllw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	sllw	a5,a5,0x1
 210:	9fb5                	addw	a5,a5,a3
 212:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	00074683          	lbu	a3,0(a4)
 21a:	fd06879b          	addw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	fef671e3          	bgeu	a2,a5,204 <atoi+0x1c>
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	add	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <atoi+0x3e>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	add	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57463          	bgeu	a0,a1,25e <memmove+0x2e>
    while(n-- > 0)
 23a:	00c05f63          	blez	a2,258 <memmove+0x28>
 23e:	1602                	sll	a2,a2,0x20
 240:	9201                	srl	a2,a2,0x20
 242:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 246:	872a                	mv	a4,a0
      *dst++ = *src++;
 248:	0585                	add	a1,a1,1
 24a:	0705                	add	a4,a4,1
 24c:	fff5c683          	lbu	a3,-1(a1)
 250:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 254:	fee79ae3          	bne	a5,a4,248 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	add	sp,sp,16
 25c:	8082                	ret
    dst += n;
 25e:	00c50733          	add	a4,a0,a2
    src += n;
 262:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 264:	fec05ae3          	blez	a2,258 <memmove+0x28>
 268:	fff6079b          	addw	a5,a2,-1
 26c:	1782                	sll	a5,a5,0x20
 26e:	9381                	srl	a5,a5,0x20
 270:	fff7c793          	not	a5,a5
 274:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 276:	15fd                	add	a1,a1,-1
 278:	177d                	add	a4,a4,-1
 27a:	0005c683          	lbu	a3,0(a1)
 27e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 282:	fee79ae3          	bne	a5,a4,276 <memmove+0x46>
 286:	bfc9                	j	258 <memmove+0x28>

0000000000000288 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 288:	1141                	add	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ca05                	beqz	a2,2be <memcmp+0x36>
 290:	fff6069b          	addw	a3,a2,-1
 294:	1682                	sll	a3,a3,0x20
 296:	9281                	srl	a3,a3,0x20
 298:	0685                	add	a3,a3,1
 29a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	add	a0,a0,1
    p2++;
 2aa:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x14>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x30>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	add	sp,sp,16
 2bc:	8082                	ret
  return 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <memcmp+0x30>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	add	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2ca:	00000097          	auipc	ra,0x0
 2ce:	f66080e7          	jalr	-154(ra) # 230 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	add	sp,sp,16
 2d8:	8082                	ret

00000000000002da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2da:	4885                	li	a7,1
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e2:	4889                	li	a7,2
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ea:	488d                	li	a7,3
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f2:	4891                	li	a7,4
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <read>:
.global read
read:
 li a7, SYS_read
 2fa:	4895                	li	a7,5
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <write>:
.global write
write:
 li a7, SYS_write
 302:	48c1                	li	a7,16
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <close>:
.global close
close:
 li a7, SYS_close
 30a:	48d5                	li	a7,21
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <kill>:
.global kill
kill:
 li a7, SYS_kill
 312:	4899                	li	a7,6
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <exec>:
.global exec
exec:
 li a7, SYS_exec
 31a:	489d                	li	a7,7
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <open>:
.global open
open:
 li a7, SYS_open
 322:	48bd                	li	a7,15
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32a:	48c5                	li	a7,17
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 332:	48c9                	li	a7,18
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33a:	48a1                	li	a7,8
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <link>:
.global link
link:
 li a7, SYS_link
 342:	48cd                	li	a7,19
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34a:	48d1                	li	a7,20
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 352:	48a5                	li	a7,9
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <dup>:
.global dup
dup:
 li a7, SYS_dup
 35a:	48a9                	li	a7,10
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 362:	48ad                	li	a7,11
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36a:	48b1                	li	a7,12
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 372:	48b5                	li	a7,13
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37a:	48b9                	li	a7,14
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 382:	48d9                	li	a7,22
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38a:	1101                	add	sp,sp,-32
 38c:	ec06                	sd	ra,24(sp)
 38e:	e822                	sd	s0,16(sp)
 390:	1000                	add	s0,sp,32
 392:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 396:	4605                	li	a2,1
 398:	fef40593          	add	a1,s0,-17
 39c:	00000097          	auipc	ra,0x0
 3a0:	f66080e7          	jalr	-154(ra) # 302 <write>
}
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	6105                	add	sp,sp,32
 3aa:	8082                	ret

00000000000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	7139                	add	sp,sp,-64
 3ae:	fc06                	sd	ra,56(sp)
 3b0:	f822                	sd	s0,48(sp)
 3b2:	f426                	sd	s1,40(sp)
 3b4:	f04a                	sd	s2,32(sp)
 3b6:	ec4e                	sd	s3,24(sp)
 3b8:	0080                	add	s0,sp,64
 3ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bc:	c299                	beqz	a3,3c2 <printint+0x16>
 3be:	0805c963          	bltz	a1,450 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c2:	2581                	sext.w	a1,a1
  neg = 0;
 3c4:	4881                	li	a7,0
 3c6:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3cc:	2601                	sext.w	a2,a2
 3ce:	00000517          	auipc	a0,0x0
 3d2:	4ba50513          	add	a0,a0,1210 # 888 <digits>
 3d6:	883a                	mv	a6,a4
 3d8:	2705                	addw	a4,a4,1
 3da:	02c5f7bb          	remuw	a5,a1,a2
 3de:	1782                	sll	a5,a5,0x20
 3e0:	9381                	srl	a5,a5,0x20
 3e2:	97aa                	add	a5,a5,a0
 3e4:	0007c783          	lbu	a5,0(a5)
 3e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ec:	0005879b          	sext.w	a5,a1
 3f0:	02c5d5bb          	divuw	a1,a1,a2
 3f4:	0685                	add	a3,a3,1
 3f6:	fec7f0e3          	bgeu	a5,a2,3d6 <printint+0x2a>
  if(neg)
 3fa:	00088c63          	beqz	a7,412 <printint+0x66>
    buf[i++] = '-';
 3fe:	fd070793          	add	a5,a4,-48
 402:	00878733          	add	a4,a5,s0
 406:	02d00793          	li	a5,45
 40a:	fef70823          	sb	a5,-16(a4)
 40e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 412:	02e05863          	blez	a4,442 <printint+0x96>
 416:	fc040793          	add	a5,s0,-64
 41a:	00e78933          	add	s2,a5,a4
 41e:	fff78993          	add	s3,a5,-1
 422:	99ba                	add	s3,s3,a4
 424:	377d                	addw	a4,a4,-1
 426:	1702                	sll	a4,a4,0x20
 428:	9301                	srl	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	fff94583          	lbu	a1,-1(s2)
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	f56080e7          	jalr	-170(ra) # 38a <putc>
  while(--i >= 0)
 43c:	197d                	add	s2,s2,-1
 43e:	ff3918e3          	bne	s2,s3,42e <printint+0x82>
}
 442:	70e2                	ld	ra,56(sp)
 444:	7442                	ld	s0,48(sp)
 446:	74a2                	ld	s1,40(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	add	sp,sp,64
 44e:	8082                	ret
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4885                	li	a7,1
    x = -xx;
 456:	bf85                	j	3c6 <printint+0x1a>

0000000000000458 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 458:	715d                	add	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	fc26                	sd	s1,56(sp)
 460:	f84a                	sd	s2,48(sp)
 462:	f44e                	sd	s3,40(sp)
 464:	f052                	sd	s4,32(sp)
 466:	ec56                	sd	s5,24(sp)
 468:	e85a                	sd	s6,16(sp)
 46a:	e45e                	sd	s7,8(sp)
 46c:	e062                	sd	s8,0(sp)
 46e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 470:	0005c903          	lbu	s2,0(a1)
 474:	18090c63          	beqz	s2,60c <vprintf+0x1b4>
 478:	8aaa                	mv	s5,a0
 47a:	8bb2                	mv	s7,a2
 47c:	00158493          	add	s1,a1,1
  state = 0;
 480:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 482:	02500a13          	li	s4,37
 486:	4b55                	li	s6,21
 488:	a839                	j	4a6 <vprintf+0x4e>
        putc(fd, c);
 48a:	85ca                	mv	a1,s2
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	efc080e7          	jalr	-260(ra) # 38a <putc>
 496:	a019                	j	49c <vprintf+0x44>
    } else if(state == '%'){
 498:	01498d63          	beq	s3,s4,4b2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 49c:	0485                	add	s1,s1,1
 49e:	fff4c903          	lbu	s2,-1(s1)
 4a2:	16090563          	beqz	s2,60c <vprintf+0x1b4>
    if(state == 0){
 4a6:	fe0999e3          	bnez	s3,498 <vprintf+0x40>
      if(c == '%'){
 4aa:	ff4910e3          	bne	s2,s4,48a <vprintf+0x32>
        state = '%';
 4ae:	89d2                	mv	s3,s4
 4b0:	b7f5                	j	49c <vprintf+0x44>
      if(c == 'd'){
 4b2:	13490263          	beq	s2,s4,5d6 <vprintf+0x17e>
 4b6:	f9d9079b          	addw	a5,s2,-99
 4ba:	0ff7f793          	zext.b	a5,a5
 4be:	12fb6563          	bltu	s6,a5,5e8 <vprintf+0x190>
 4c2:	f9d9079b          	addw	a5,s2,-99
 4c6:	0ff7f713          	zext.b	a4,a5
 4ca:	10eb6f63          	bltu	s6,a4,5e8 <vprintf+0x190>
 4ce:	00271793          	sll	a5,a4,0x2
 4d2:	00000717          	auipc	a4,0x0
 4d6:	35e70713          	add	a4,a4,862 # 830 <malloc+0x126>
 4da:	97ba                	add	a5,a5,a4
 4dc:	439c                	lw	a5,0(a5)
 4de:	97ba                	add	a5,a5,a4
 4e0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e2:	008b8913          	add	s2,s7,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000ba583          	lw	a1,0(s7)
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ebc080e7          	jalr	-324(ra) # 3ac <printint>
 4f8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	b745                	j	49c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fe:	008b8913          	add	s2,s7,8
 502:	4681                	li	a3,0
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ea0080e7          	jalr	-352(ra) # 3ac <printint>
 514:	8bca                	mv	s7,s2
      state = 0;
 516:	4981                	li	s3,0
 518:	b751                	j	49c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 51a:	008b8913          	add	s2,s7,8
 51e:	4681                	li	a3,0
 520:	4641                	li	a2,16
 522:	000ba583          	lw	a1,0(s7)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e84080e7          	jalr	-380(ra) # 3ac <printint>
 530:	8bca                	mv	s7,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	b7a5                	j	49c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 536:	008b8c13          	add	s8,s7,8
 53a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 53e:	03000593          	li	a1,48
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e46080e7          	jalr	-442(ra) # 38a <putc>
  putc(fd, 'x');
 54c:	07800593          	li	a1,120
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e38080e7          	jalr	-456(ra) # 38a <putc>
 55a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55c:	00000b97          	auipc	s7,0x0
 560:	32cb8b93          	add	s7,s7,812 # 888 <digits>
 564:	03c9d793          	srl	a5,s3,0x3c
 568:	97de                	add	a5,a5,s7
 56a:	0007c583          	lbu	a1,0(a5)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e1a080e7          	jalr	-486(ra) # 38a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 578:	0992                	sll	s3,s3,0x4
 57a:	397d                	addw	s2,s2,-1
 57c:	fe0914e3          	bnez	s2,564 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 580:	8be2                	mv	s7,s8
      state = 0;
 582:	4981                	li	s3,0
 584:	bf21                	j	49c <vprintf+0x44>
        s = va_arg(ap, char*);
 586:	008b8993          	add	s3,s7,8
 58a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 58e:	02090163          	beqz	s2,5b0 <vprintf+0x158>
        while(*s != 0){
 592:	00094583          	lbu	a1,0(s2)
 596:	c9a5                	beqz	a1,606 <vprintf+0x1ae>
          putc(fd, *s);
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	df0080e7          	jalr	-528(ra) # 38a <putc>
          s++;
 5a2:	0905                	add	s2,s2,1
        while(*s != 0){
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	f9e5                	bnez	a1,598 <vprintf+0x140>
        s = va_arg(ap, char*);
 5aa:	8bce                	mv	s7,s3
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5fd                	j	49c <vprintf+0x44>
          s = "(null)";
 5b0:	00000917          	auipc	s2,0x0
 5b4:	27890913          	add	s2,s2,632 # 828 <malloc+0x11e>
        while(*s != 0){
 5b8:	02800593          	li	a1,40
 5bc:	bff1                	j	598 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5be:	008b8913          	add	s2,s7,8
 5c2:	000bc583          	lbu	a1,0(s7)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc2080e7          	jalr	-574(ra) # 38a <putc>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b5e1                	j	49c <vprintf+0x44>
        putc(fd, c);
 5d6:	02500593          	li	a1,37
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dae080e7          	jalr	-594(ra) # 38a <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd5d                	j	49c <vprintf+0x44>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	d9c080e7          	jalr	-612(ra) # 38a <putc>
        putc(fd, c);
 5f6:	85ca                	mv	a1,s2
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d90080e7          	jalr	-624(ra) # 38a <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	bd61                	j	49c <vprintf+0x44>
        s = va_arg(ap, char*);
 606:	8bce                	mv	s7,s3
      state = 0;
 608:	4981                	li	s3,0
 60a:	bd49                	j	49c <vprintf+0x44>
    }
  }
}
 60c:	60a6                	ld	ra,72(sp)
 60e:	6406                	ld	s0,64(sp)
 610:	74e2                	ld	s1,56(sp)
 612:	7942                	ld	s2,48(sp)
 614:	79a2                	ld	s3,40(sp)
 616:	7a02                	ld	s4,32(sp)
 618:	6ae2                	ld	s5,24(sp)
 61a:	6b42                	ld	s6,16(sp)
 61c:	6ba2                	ld	s7,8(sp)
 61e:	6c02                	ld	s8,0(sp)
 620:	6161                	add	sp,sp,80
 622:	8082                	ret

0000000000000624 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 624:	715d                	add	sp,sp,-80
 626:	ec06                	sd	ra,24(sp)
 628:	e822                	sd	s0,16(sp)
 62a:	1000                	add	s0,sp,32
 62c:	e010                	sd	a2,0(s0)
 62e:	e414                	sd	a3,8(s0)
 630:	e818                	sd	a4,16(s0)
 632:	ec1c                	sd	a5,24(s0)
 634:	03043023          	sd	a6,32(s0)
 638:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 640:	8622                	mv	a2,s0
 642:	00000097          	auipc	ra,0x0
 646:	e16080e7          	jalr	-490(ra) # 458 <vprintf>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6161                	add	sp,sp,80
 650:	8082                	ret

0000000000000652 <printf>:

void
printf(const char *fmt, ...)
{
 652:	711d                	add	sp,sp,-96
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	add	s0,sp,32
 65a:	e40c                	sd	a1,8(s0)
 65c:	e810                	sd	a2,16(s0)
 65e:	ec14                	sd	a3,24(s0)
 660:	f018                	sd	a4,32(s0)
 662:	f41c                	sd	a5,40(s0)
 664:	03043823          	sd	a6,48(s0)
 668:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	00840613          	add	a2,s0,8
 670:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 674:	85aa                	mv	a1,a0
 676:	4505                	li	a0,1
 678:	00000097          	auipc	ra,0x0
 67c:	de0080e7          	jalr	-544(ra) # 458 <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6125                	add	sp,sp,96
 686:	8082                	ret

0000000000000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	1141                	add	sp,sp,-16
 68a:	e422                	sd	s0,8(sp)
 68c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	00000797          	auipc	a5,0x0
 696:	20e7b783          	ld	a5,526(a5) # 8a0 <freep>
 69a:	a02d                	j	6c4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69c:	4618                	lw	a4,8(a2)
 69e:	9f2d                	addw	a4,a4,a1
 6a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a4:	6398                	ld	a4,0(a5)
 6a6:	6310                	ld	a2,0(a4)
 6a8:	a83d                	j	6e6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6aa:	ff852703          	lw	a4,-8(a0)
 6ae:	9f31                	addw	a4,a4,a2
 6b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b2:	ff053683          	ld	a3,-16(a0)
 6b6:	a091                	j	6fa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	6398                	ld	a4,0(a5)
 6ba:	00e7e463          	bltu	a5,a4,6c2 <free+0x3a>
 6be:	00e6ea63          	bltu	a3,a4,6d2 <free+0x4a>
{
 6c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	fed7fae3          	bgeu	a5,a3,6b8 <free+0x30>
 6c8:	6398                	ld	a4,0(a5)
 6ca:	00e6e463          	bltu	a3,a4,6d2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	fee7eae3          	bltu	a5,a4,6c2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d2:	ff852583          	lw	a1,-8(a0)
 6d6:	6390                	ld	a2,0(a5)
 6d8:	02059813          	sll	a6,a1,0x20
 6dc:	01c85713          	srl	a4,a6,0x1c
 6e0:	9736                	add	a4,a4,a3
 6e2:	fae60de3          	beq	a2,a4,69c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ea:	4790                	lw	a2,8(a5)
 6ec:	02061593          	sll	a1,a2,0x20
 6f0:	01c5d713          	srl	a4,a1,0x1c
 6f4:	973e                	add	a4,a4,a5
 6f6:	fae68ae3          	beq	a3,a4,6aa <free+0x22>
    p->s.ptr = bp->s.ptr;
 6fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fc:	00000717          	auipc	a4,0x0
 700:	1af73223          	sd	a5,420(a4) # 8a0 <freep>
}
 704:	6422                	ld	s0,8(sp)
 706:	0141                	add	sp,sp,16
 708:	8082                	ret

000000000000070a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70a:	7139                	add	sp,sp,-64
 70c:	fc06                	sd	ra,56(sp)
 70e:	f822                	sd	s0,48(sp)
 710:	f426                	sd	s1,40(sp)
 712:	f04a                	sd	s2,32(sp)
 714:	ec4e                	sd	s3,24(sp)
 716:	e852                	sd	s4,16(sp)
 718:	e456                	sd	s5,8(sp)
 71a:	e05a                	sd	s6,0(sp)
 71c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71e:	02051493          	sll	s1,a0,0x20
 722:	9081                	srl	s1,s1,0x20
 724:	04bd                	add	s1,s1,15
 726:	8091                	srl	s1,s1,0x4
 728:	0014899b          	addw	s3,s1,1
 72c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 72e:	00000517          	auipc	a0,0x0
 732:	17253503          	ld	a0,370(a0) # 8a0 <freep>
 736:	c515                	beqz	a0,762 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 738:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73a:	4798                	lw	a4,8(a5)
 73c:	02977f63          	bgeu	a4,s1,77a <malloc+0x70>
  if(nu < 4096)
 740:	8a4e                	mv	s4,s3
 742:	0009871b          	sext.w	a4,s3
 746:	6685                	lui	a3,0x1
 748:	00d77363          	bgeu	a4,a3,74e <malloc+0x44>
 74c:	6a05                	lui	s4,0x1
 74e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 752:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 756:	00000917          	auipc	s2,0x0
 75a:	14a90913          	add	s2,s2,330 # 8a0 <freep>
  if(p == (char*)-1)
 75e:	5afd                	li	s5,-1
 760:	a895                	j	7d4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 762:	00000797          	auipc	a5,0x0
 766:	14678793          	add	a5,a5,326 # 8a8 <base>
 76a:	00000717          	auipc	a4,0x0
 76e:	12f73b23          	sd	a5,310(a4) # 8a0 <freep>
 772:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 774:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 778:	b7e1                	j	740 <malloc+0x36>
      if(p->s.size == nunits)
 77a:	02e48c63          	beq	s1,a4,7b2 <malloc+0xa8>
        p->s.size -= nunits;
 77e:	4137073b          	subw	a4,a4,s3
 782:	c798                	sw	a4,8(a5)
        p += p->s.size;
 784:	02071693          	sll	a3,a4,0x20
 788:	01c6d713          	srl	a4,a3,0x1c
 78c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 78e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 792:	00000717          	auipc	a4,0x0
 796:	10a73723          	sd	a0,270(a4) # 8a0 <freep>
      return (void*)(p + 1);
 79a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 79e:	70e2                	ld	ra,56(sp)
 7a0:	7442                	ld	s0,48(sp)
 7a2:	74a2                	ld	s1,40(sp)
 7a4:	7902                	ld	s2,32(sp)
 7a6:	69e2                	ld	s3,24(sp)
 7a8:	6a42                	ld	s4,16(sp)
 7aa:	6aa2                	ld	s5,8(sp)
 7ac:	6b02                	ld	s6,0(sp)
 7ae:	6121                	add	sp,sp,64
 7b0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	e118                	sd	a4,0(a0)
 7b6:	bff1                	j	792 <malloc+0x88>
  hp->s.size = nu;
 7b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7bc:	0541                	add	a0,a0,16
 7be:	00000097          	auipc	ra,0x0
 7c2:	eca080e7          	jalr	-310(ra) # 688 <free>
  return freep;
 7c6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ca:	d971                	beqz	a0,79e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	fa9775e3          	bgeu	a4,s1,77a <malloc+0x70>
    if(p == freep)
 7d4:	00093703          	ld	a4,0(s2)
 7d8:	853e                	mv	a0,a5
 7da:	fef719e3          	bne	a4,a5,7cc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7de:	8552                	mv	a0,s4
 7e0:	00000097          	auipc	ra,0x0
 7e4:	b8a080e7          	jalr	-1142(ra) # 36a <sbrk>
  if(p == (char*)-1)
 7e8:	fd5518e3          	bne	a0,s5,7b8 <malloc+0xae>
        return 0;
 7ec:	4501                	li	a0,0
 7ee:	bf45                	j	79e <malloc+0x94>
