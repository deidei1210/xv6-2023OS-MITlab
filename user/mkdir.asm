
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
  40:	7ac58593          	add	a1,a1,1964 # 7e8 <malloc+0xe6>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	5d6080e7          	jalr	1494(ra) # 61c <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	292080e7          	jalr	658(ra) # 2e2 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  58:	6090                	ld	a2,0(s1)
  5a:	00000597          	auipc	a1,0x0
  5e:	7a658593          	add	a1,a1,1958 # 800 <malloc+0xfe>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	5b8080e7          	jalr	1464(ra) # 61c <fprintf>
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

0000000000000382 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 382:	1101                	add	sp,sp,-32
 384:	ec06                	sd	ra,24(sp)
 386:	e822                	sd	s0,16(sp)
 388:	1000                	add	s0,sp,32
 38a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38e:	4605                	li	a2,1
 390:	fef40593          	add	a1,s0,-17
 394:	00000097          	auipc	ra,0x0
 398:	f6e080e7          	jalr	-146(ra) # 302 <write>
}
 39c:	60e2                	ld	ra,24(sp)
 39e:	6442                	ld	s0,16(sp)
 3a0:	6105                	add	sp,sp,32
 3a2:	8082                	ret

00000000000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	7139                	add	sp,sp,-64
 3a6:	fc06                	sd	ra,56(sp)
 3a8:	f822                	sd	s0,48(sp)
 3aa:	f426                	sd	s1,40(sp)
 3ac:	f04a                	sd	s2,32(sp)
 3ae:	ec4e                	sd	s3,24(sp)
 3b0:	0080                	add	s0,sp,64
 3b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b4:	c299                	beqz	a3,3ba <printint+0x16>
 3b6:	0805c963          	bltz	a1,448 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ba:	2581                	sext.w	a1,a1
  neg = 0;
 3bc:	4881                	li	a7,0
 3be:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c4:	2601                	sext.w	a2,a2
 3c6:	00000517          	auipc	a0,0x0
 3ca:	4ba50513          	add	a0,a0,1210 # 880 <digits>
 3ce:	883a                	mv	a6,a4
 3d0:	2705                	addw	a4,a4,1
 3d2:	02c5f7bb          	remuw	a5,a1,a2
 3d6:	1782                	sll	a5,a5,0x20
 3d8:	9381                	srl	a5,a5,0x20
 3da:	97aa                	add	a5,a5,a0
 3dc:	0007c783          	lbu	a5,0(a5)
 3e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e4:	0005879b          	sext.w	a5,a1
 3e8:	02c5d5bb          	divuw	a1,a1,a2
 3ec:	0685                	add	a3,a3,1
 3ee:	fec7f0e3          	bgeu	a5,a2,3ce <printint+0x2a>
  if(neg)
 3f2:	00088c63          	beqz	a7,40a <printint+0x66>
    buf[i++] = '-';
 3f6:	fd070793          	add	a5,a4,-48
 3fa:	00878733          	add	a4,a5,s0
 3fe:	02d00793          	li	a5,45
 402:	fef70823          	sb	a5,-16(a4)
 406:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 40a:	02e05863          	blez	a4,43a <printint+0x96>
 40e:	fc040793          	add	a5,s0,-64
 412:	00e78933          	add	s2,a5,a4
 416:	fff78993          	add	s3,a5,-1
 41a:	99ba                	add	s3,s3,a4
 41c:	377d                	addw	a4,a4,-1
 41e:	1702                	sll	a4,a4,0x20
 420:	9301                	srl	a4,a4,0x20
 422:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 426:	fff94583          	lbu	a1,-1(s2)
 42a:	8526                	mv	a0,s1
 42c:	00000097          	auipc	ra,0x0
 430:	f56080e7          	jalr	-170(ra) # 382 <putc>
  while(--i >= 0)
 434:	197d                	add	s2,s2,-1
 436:	ff3918e3          	bne	s2,s3,426 <printint+0x82>
}
 43a:	70e2                	ld	ra,56(sp)
 43c:	7442                	ld	s0,48(sp)
 43e:	74a2                	ld	s1,40(sp)
 440:	7902                	ld	s2,32(sp)
 442:	69e2                	ld	s3,24(sp)
 444:	6121                	add	sp,sp,64
 446:	8082                	ret
    x = -xx;
 448:	40b005bb          	negw	a1,a1
    neg = 1;
 44c:	4885                	li	a7,1
    x = -xx;
 44e:	bf85                	j	3be <printint+0x1a>

0000000000000450 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 450:	715d                	add	sp,sp,-80
 452:	e486                	sd	ra,72(sp)
 454:	e0a2                	sd	s0,64(sp)
 456:	fc26                	sd	s1,56(sp)
 458:	f84a                	sd	s2,48(sp)
 45a:	f44e                	sd	s3,40(sp)
 45c:	f052                	sd	s4,32(sp)
 45e:	ec56                	sd	s5,24(sp)
 460:	e85a                	sd	s6,16(sp)
 462:	e45e                	sd	s7,8(sp)
 464:	e062                	sd	s8,0(sp)
 466:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 468:	0005c903          	lbu	s2,0(a1)
 46c:	18090c63          	beqz	s2,604 <vprintf+0x1b4>
 470:	8aaa                	mv	s5,a0
 472:	8bb2                	mv	s7,a2
 474:	00158493          	add	s1,a1,1
  state = 0;
 478:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47a:	02500a13          	li	s4,37
 47e:	4b55                	li	s6,21
 480:	a839                	j	49e <vprintf+0x4e>
        putc(fd, c);
 482:	85ca                	mv	a1,s2
 484:	8556                	mv	a0,s5
 486:	00000097          	auipc	ra,0x0
 48a:	efc080e7          	jalr	-260(ra) # 382 <putc>
 48e:	a019                	j	494 <vprintf+0x44>
    } else if(state == '%'){
 490:	01498d63          	beq	s3,s4,4aa <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 494:	0485                	add	s1,s1,1
 496:	fff4c903          	lbu	s2,-1(s1)
 49a:	16090563          	beqz	s2,604 <vprintf+0x1b4>
    if(state == 0){
 49e:	fe0999e3          	bnez	s3,490 <vprintf+0x40>
      if(c == '%'){
 4a2:	ff4910e3          	bne	s2,s4,482 <vprintf+0x32>
        state = '%';
 4a6:	89d2                	mv	s3,s4
 4a8:	b7f5                	j	494 <vprintf+0x44>
      if(c == 'd'){
 4aa:	13490263          	beq	s2,s4,5ce <vprintf+0x17e>
 4ae:	f9d9079b          	addw	a5,s2,-99
 4b2:	0ff7f793          	zext.b	a5,a5
 4b6:	12fb6563          	bltu	s6,a5,5e0 <vprintf+0x190>
 4ba:	f9d9079b          	addw	a5,s2,-99
 4be:	0ff7f713          	zext.b	a4,a5
 4c2:	10eb6f63          	bltu	s6,a4,5e0 <vprintf+0x190>
 4c6:	00271793          	sll	a5,a4,0x2
 4ca:	00000717          	auipc	a4,0x0
 4ce:	35e70713          	add	a4,a4,862 # 828 <malloc+0x126>
 4d2:	97ba                	add	a5,a5,a4
 4d4:	439c                	lw	a5,0(a5)
 4d6:	97ba                	add	a5,a5,a4
 4d8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4da:	008b8913          	add	s2,s7,8
 4de:	4685                	li	a3,1
 4e0:	4629                	li	a2,10
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	ebc080e7          	jalr	-324(ra) # 3a4 <printint>
 4f0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b745                	j	494 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f6:	008b8913          	add	s2,s7,8
 4fa:	4681                	li	a3,0
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	ea0080e7          	jalr	-352(ra) # 3a4 <printint>
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	b751                	j	494 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 512:	008b8913          	add	s2,s7,8
 516:	4681                	li	a3,0
 518:	4641                	li	a2,16
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e84080e7          	jalr	-380(ra) # 3a4 <printint>
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b7a5                	j	494 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 52e:	008b8c13          	add	s8,s7,8
 532:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 536:	03000593          	li	a1,48
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e46080e7          	jalr	-442(ra) # 382 <putc>
  putc(fd, 'x');
 544:	07800593          	li	a1,120
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e38080e7          	jalr	-456(ra) # 382 <putc>
 552:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	00000b97          	auipc	s7,0x0
 558:	32cb8b93          	add	s7,s7,812 # 880 <digits>
 55c:	03c9d793          	srl	a5,s3,0x3c
 560:	97de                	add	a5,a5,s7
 562:	0007c583          	lbu	a1,0(a5)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e1a080e7          	jalr	-486(ra) # 382 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 570:	0992                	sll	s3,s3,0x4
 572:	397d                	addw	s2,s2,-1
 574:	fe0914e3          	bnez	s2,55c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 578:	8be2                	mv	s7,s8
      state = 0;
 57a:	4981                	li	s3,0
 57c:	bf21                	j	494 <vprintf+0x44>
        s = va_arg(ap, char*);
 57e:	008b8993          	add	s3,s7,8
 582:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 586:	02090163          	beqz	s2,5a8 <vprintf+0x158>
        while(*s != 0){
 58a:	00094583          	lbu	a1,0(s2)
 58e:	c9a5                	beqz	a1,5fe <vprintf+0x1ae>
          putc(fd, *s);
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	df0080e7          	jalr	-528(ra) # 382 <putc>
          s++;
 59a:	0905                	add	s2,s2,1
        while(*s != 0){
 59c:	00094583          	lbu	a1,0(s2)
 5a0:	f9e5                	bnez	a1,590 <vprintf+0x140>
        s = va_arg(ap, char*);
 5a2:	8bce                	mv	s7,s3
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b5fd                	j	494 <vprintf+0x44>
          s = "(null)";
 5a8:	00000917          	auipc	s2,0x0
 5ac:	27890913          	add	s2,s2,632 # 820 <malloc+0x11e>
        while(*s != 0){
 5b0:	02800593          	li	a1,40
 5b4:	bff1                	j	590 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5b6:	008b8913          	add	s2,s7,8
 5ba:	000bc583          	lbu	a1,0(s7)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	dc2080e7          	jalr	-574(ra) # 382 <putc>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b5e1                	j	494 <vprintf+0x44>
        putc(fd, c);
 5ce:	02500593          	li	a1,37
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	dae080e7          	jalr	-594(ra) # 382 <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bd5d                	j	494 <vprintf+0x44>
        putc(fd, '%');
 5e0:	02500593          	li	a1,37
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	d9c080e7          	jalr	-612(ra) # 382 <putc>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	d90080e7          	jalr	-624(ra) # 382 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bd61                	j	494 <vprintf+0x44>
        s = va_arg(ap, char*);
 5fe:	8bce                	mv	s7,s3
      state = 0;
 600:	4981                	li	s3,0
 602:	bd49                	j	494 <vprintf+0x44>
    }
  }
}
 604:	60a6                	ld	ra,72(sp)
 606:	6406                	ld	s0,64(sp)
 608:	74e2                	ld	s1,56(sp)
 60a:	7942                	ld	s2,48(sp)
 60c:	79a2                	ld	s3,40(sp)
 60e:	7a02                	ld	s4,32(sp)
 610:	6ae2                	ld	s5,24(sp)
 612:	6b42                	ld	s6,16(sp)
 614:	6ba2                	ld	s7,8(sp)
 616:	6c02                	ld	s8,0(sp)
 618:	6161                	add	sp,sp,80
 61a:	8082                	ret

000000000000061c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61c:	715d                	add	sp,sp,-80
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	add	s0,sp,32
 624:	e010                	sd	a2,0(s0)
 626:	e414                	sd	a3,8(s0)
 628:	e818                	sd	a4,16(s0)
 62a:	ec1c                	sd	a5,24(s0)
 62c:	03043023          	sd	a6,32(s0)
 630:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 634:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 638:	8622                	mv	a2,s0
 63a:	00000097          	auipc	ra,0x0
 63e:	e16080e7          	jalr	-490(ra) # 450 <vprintf>
}
 642:	60e2                	ld	ra,24(sp)
 644:	6442                	ld	s0,16(sp)
 646:	6161                	add	sp,sp,80
 648:	8082                	ret

000000000000064a <printf>:

void
printf(const char *fmt, ...)
{
 64a:	711d                	add	sp,sp,-96
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	add	s0,sp,32
 652:	e40c                	sd	a1,8(s0)
 654:	e810                	sd	a2,16(s0)
 656:	ec14                	sd	a3,24(s0)
 658:	f018                	sd	a4,32(s0)
 65a:	f41c                	sd	a5,40(s0)
 65c:	03043823          	sd	a6,48(s0)
 660:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 664:	00840613          	add	a2,s0,8
 668:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66c:	85aa                	mv	a1,a0
 66e:	4505                	li	a0,1
 670:	00000097          	auipc	ra,0x0
 674:	de0080e7          	jalr	-544(ra) # 450 <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6125                	add	sp,sp,96
 67e:	8082                	ret

0000000000000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	1141                	add	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	00000797          	auipc	a5,0x0
 68e:	20e7b783          	ld	a5,526(a5) # 898 <freep>
 692:	a02d                	j	6bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 694:	4618                	lw	a4,8(a2)
 696:	9f2d                	addw	a4,a4,a1
 698:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 69c:	6398                	ld	a4,0(a5)
 69e:	6310                	ld	a2,0(a4)
 6a0:	a83d                	j	6de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a2:	ff852703          	lw	a4,-8(a0)
 6a6:	9f31                	addw	a4,a4,a2
 6a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6aa:	ff053683          	ld	a3,-16(a0)
 6ae:	a091                	j	6f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	6398                	ld	a4,0(a5)
 6b2:	00e7e463          	bltu	a5,a4,6ba <free+0x3a>
 6b6:	00e6ea63          	bltu	a3,a4,6ca <free+0x4a>
{
 6ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bc:	fed7fae3          	bgeu	a5,a3,6b0 <free+0x30>
 6c0:	6398                	ld	a4,0(a5)
 6c2:	00e6e463          	bltu	a3,a4,6ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c6:	fee7eae3          	bltu	a5,a4,6ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ca:	ff852583          	lw	a1,-8(a0)
 6ce:	6390                	ld	a2,0(a5)
 6d0:	02059813          	sll	a6,a1,0x20
 6d4:	01c85713          	srl	a4,a6,0x1c
 6d8:	9736                	add	a4,a4,a3
 6da:	fae60de3          	beq	a2,a4,694 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e2:	4790                	lw	a2,8(a5)
 6e4:	02061593          	sll	a1,a2,0x20
 6e8:	01c5d713          	srl	a4,a1,0x1c
 6ec:	973e                	add	a4,a4,a5
 6ee:	fae68ae3          	beq	a3,a4,6a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6f4:	00000717          	auipc	a4,0x0
 6f8:	1af73223          	sd	a5,420(a4) # 898 <freep>
}
 6fc:	6422                	ld	s0,8(sp)
 6fe:	0141                	add	sp,sp,16
 700:	8082                	ret

0000000000000702 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 702:	7139                	add	sp,sp,-64
 704:	fc06                	sd	ra,56(sp)
 706:	f822                	sd	s0,48(sp)
 708:	f426                	sd	s1,40(sp)
 70a:	f04a                	sd	s2,32(sp)
 70c:	ec4e                	sd	s3,24(sp)
 70e:	e852                	sd	s4,16(sp)
 710:	e456                	sd	s5,8(sp)
 712:	e05a                	sd	s6,0(sp)
 714:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 716:	02051493          	sll	s1,a0,0x20
 71a:	9081                	srl	s1,s1,0x20
 71c:	04bd                	add	s1,s1,15
 71e:	8091                	srl	s1,s1,0x4
 720:	0014899b          	addw	s3,s1,1
 724:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 726:	00000517          	auipc	a0,0x0
 72a:	17253503          	ld	a0,370(a0) # 898 <freep>
 72e:	c515                	beqz	a0,75a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 732:	4798                	lw	a4,8(a5)
 734:	02977f63          	bgeu	a4,s1,772 <malloc+0x70>
  if(nu < 4096)
 738:	8a4e                	mv	s4,s3
 73a:	0009871b          	sext.w	a4,s3
 73e:	6685                	lui	a3,0x1
 740:	00d77363          	bgeu	a4,a3,746 <malloc+0x44>
 744:	6a05                	lui	s4,0x1
 746:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 74a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74e:	00000917          	auipc	s2,0x0
 752:	14a90913          	add	s2,s2,330 # 898 <freep>
  if(p == (char*)-1)
 756:	5afd                	li	s5,-1
 758:	a895                	j	7cc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 75a:	00000797          	auipc	a5,0x0
 75e:	14678793          	add	a5,a5,326 # 8a0 <base>
 762:	00000717          	auipc	a4,0x0
 766:	12f73b23          	sd	a5,310(a4) # 898 <freep>
 76a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 770:	b7e1                	j	738 <malloc+0x36>
      if(p->s.size == nunits)
 772:	02e48c63          	beq	s1,a4,7aa <malloc+0xa8>
        p->s.size -= nunits;
 776:	4137073b          	subw	a4,a4,s3
 77a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77c:	02071693          	sll	a3,a4,0x20
 780:	01c6d713          	srl	a4,a3,0x1c
 784:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 786:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 78a:	00000717          	auipc	a4,0x0
 78e:	10a73723          	sd	a0,270(a4) # 898 <freep>
      return (void*)(p + 1);
 792:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 796:	70e2                	ld	ra,56(sp)
 798:	7442                	ld	s0,48(sp)
 79a:	74a2                	ld	s1,40(sp)
 79c:	7902                	ld	s2,32(sp)
 79e:	69e2                	ld	s3,24(sp)
 7a0:	6a42                	ld	s4,16(sp)
 7a2:	6aa2                	ld	s5,8(sp)
 7a4:	6b02                	ld	s6,0(sp)
 7a6:	6121                	add	sp,sp,64
 7a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7aa:	6398                	ld	a4,0(a5)
 7ac:	e118                	sd	a4,0(a0)
 7ae:	bff1                	j	78a <malloc+0x88>
  hp->s.size = nu;
 7b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b4:	0541                	add	a0,a0,16
 7b6:	00000097          	auipc	ra,0x0
 7ba:	eca080e7          	jalr	-310(ra) # 680 <free>
  return freep;
 7be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c2:	d971                	beqz	a0,796 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	fa9775e3          	bgeu	a4,s1,772 <malloc+0x70>
    if(p == freep)
 7cc:	00093703          	ld	a4,0(s2)
 7d0:	853e                	mv	a0,a5
 7d2:	fef719e3          	bne	a4,a5,7c4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7d6:	8552                	mv	a0,s4
 7d8:	00000097          	auipc	ra,0x0
 7dc:	b92080e7          	jalr	-1134(ra) # 36a <sbrk>
  if(p == (char*)-1)
 7e0:	fd5518e3          	bne	a0,s5,7b0 <malloc+0xae>
        return 0;
 7e4:	4501                	li	a0,0
 7e6:	bf45                	j	796 <malloc+0x94>
