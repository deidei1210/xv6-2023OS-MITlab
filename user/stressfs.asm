
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	add	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	add	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	89a78793          	add	a5,a5,-1894 # 8b0 <malloc+0x118>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	85450513          	add	a0,a0,-1964 # 880 <malloc+0xe8>
  34:	00000097          	auipc	ra,0x0
  38:	6ac080e7          	jalr	1708(ra) # 6e0 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	add	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	31c080e7          	jalr	796(ra) # 370 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	83050513          	add	a0,a0,-2000 # 898 <malloc+0x100>
  70:	00000097          	auipc	ra,0x0
  74:	670080e7          	jalr	1648(ra) # 6e0 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	add	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	32e080e7          	jalr	814(ra) # 3b8 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	add	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	2f8080e7          	jalr	760(ra) # 398 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	2f2080e7          	jalr	754(ra) # 3a0 <close>

  printf("read\n");
  b6:	00000517          	auipc	a0,0x0
  ba:	7f250513          	add	a0,a0,2034 # 8a8 <malloc+0x110>
  be:	00000097          	auipc	ra,0x0
  c2:	622080e7          	jalr	1570(ra) # 6e0 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	add	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	2ec080e7          	jalr	748(ra) # 3b8 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	add	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2ae080e7          	jalr	686(ra) # 390 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2b0080e7          	jalr	688(ra) # 3a0 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	286080e7          	jalr	646(ra) # 380 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	274080e7          	jalr	628(ra) # 378 <exit>

000000000000010c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 10c:	1141                	add	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	add	a1,a1,1
 116:	0785                	add	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	add	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	add	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
    p++, q++;
 13c:	0505                	add	a0,a0,1
 13e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	add	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	add	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	add	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	86be                	mv	a3,a5
 166:	0785                	add	a5,a5,1
 168:	fff7c703          	lbu	a4,-1(a5)
 16c:	ff65                	bnez	a4,164 <strlen+0x10>
 16e:	40a6853b          	subw	a0,a3,a0
 172:	2505                	addw	a0,a0,1
    ;
  return n;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	add	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	add	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ca19                	beqz	a2,19a <memset+0x1c>
 186:	87aa                	mv	a5,a0
 188:	1602                	sll	a2,a2,0x20
 18a:	9201                	srl	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 190:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 194:	0785                	add	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x12>
  }
  return dst;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	add	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	1141                	add	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	add	s0,sp,16
  for(; *s; s++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb99                	beqz	a5,1c0 <strchr+0x20>
    if(*s == c)
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1a>
  for(; *s; s++)
 1b0:	0505                	add	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xc>
      return (char*)s;
  return 0;
 1b8:	4501                	li	a0,0
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	add	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfe5                	j	1ba <strchr+0x1a>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	711d                	add	sp,sp,-96
 1c6:	ec86                	sd	ra,88(sp)
 1c8:	e8a2                	sd	s0,80(sp)
 1ca:	e4a6                	sd	s1,72(sp)
 1cc:	e0ca                	sd	s2,64(sp)
 1ce:	fc4e                	sd	s3,56(sp)
 1d0:	f852                	sd	s4,48(sp)
 1d2:	f456                	sd	s5,40(sp)
 1d4:	f05a                	sd	s6,32(sp)
 1d6:	ec5e                	sd	s7,24(sp)
 1d8:	1080                	add	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e2:	4aa9                	li	s5,10
 1e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e6:	89a6                	mv	s3,s1
 1e8:	2485                	addw	s1,s1,1
 1ea:	0344d863          	bge	s1,s4,21a <gets+0x56>
    cc = read(0, &c, 1);
 1ee:	4605                	li	a2,1
 1f0:	faf40593          	add	a1,s0,-81
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	19a080e7          	jalr	410(ra) # 390 <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x56>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x54>
 20e:	0905                	add	s2,s2,1
 210:	fd679be3          	bne	a5,s6,1e6 <gets+0x22>
  for(i=0; i+1 < max; ){
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x56>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	add	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	add	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e426                	sd	s1,8(sp)
 240:	e04a                	sd	s2,0(sp)
 242:	1000                	add	s0,sp,32
 244:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	4581                	li	a1,0
 248:	00000097          	auipc	ra,0x0
 24c:	170080e7          	jalr	368(ra) # 3b8 <open>
  if(fd < 0)
 250:	02054563          	bltz	a0,27a <stat+0x42>
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	00000097          	auipc	ra,0x0
 25c:	178080e7          	jalr	376(ra) # 3d0 <fstat>
 260:	892a                	mv	s2,a0
  close(fd);
 262:	8526                	mv	a0,s1
 264:	00000097          	auipc	ra,0x0
 268:	13c080e7          	jalr	316(ra) # 3a0 <close>
  return r;
}
 26c:	854a                	mv	a0,s2
 26e:	60e2                	ld	ra,24(sp)
 270:	6442                	ld	s0,16(sp)
 272:	64a2                	ld	s1,8(sp)
 274:	6902                	ld	s2,0(sp)
 276:	6105                	add	sp,sp,32
 278:	8082                	ret
    return -1;
 27a:	597d                	li	s2,-1
 27c:	bfc5                	j	26c <stat+0x34>

000000000000027e <atoi>:

int
atoi(const char *s)
{
 27e:	1141                	add	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 284:	00054683          	lbu	a3,0(a0)
 288:	fd06879b          	addw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	4625                	li	a2,9
 292:	02f66863          	bltu	a2,a5,2c2 <atoi+0x44>
 296:	872a                	mv	a4,a0
  n = 0;
 298:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29a:	0705                	add	a4,a4,1
 29c:	0025179b          	sllw	a5,a0,0x2
 2a0:	9fa9                	addw	a5,a5,a0
 2a2:	0017979b          	sllw	a5,a5,0x1
 2a6:	9fb5                	addw	a5,a5,a3
 2a8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ac:	00074683          	lbu	a3,0(a4)
 2b0:	fd06879b          	addw	a5,a3,-48
 2b4:	0ff7f793          	zext.b	a5,a5
 2b8:	fef671e3          	bgeu	a2,a5,29a <atoi+0x1c>
  return n;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	add	sp,sp,16
 2c0:	8082                	ret
  n = 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <atoi+0x3e>

00000000000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	1141                	add	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57463          	bgeu	a0,a1,2f4 <memmove+0x2e>
    while(n-- > 0)
 2d0:	00c05f63          	blez	a2,2ee <memmove+0x28>
 2d4:	1602                	sll	a2,a2,0x20
 2d6:	9201                	srl	a2,a2,0x20
 2d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2de:	0585                	add	a1,a1,1
 2e0:	0705                	add	a4,a4,1
 2e2:	fff5c683          	lbu	a3,-1(a1)
 2e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ea:	fee79ae3          	bne	a5,a4,2de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	add	sp,sp,16
 2f2:	8082                	ret
    dst += n;
 2f4:	00c50733          	add	a4,a0,a2
    src += n;
 2f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fa:	fec05ae3          	blez	a2,2ee <memmove+0x28>
 2fe:	fff6079b          	addw	a5,a2,-1
 302:	1782                	sll	a5,a5,0x20
 304:	9381                	srl	a5,a5,0x20
 306:	fff7c793          	not	a5,a5
 30a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30c:	15fd                	add	a1,a1,-1
 30e:	177d                	add	a4,a4,-1
 310:	0005c683          	lbu	a3,0(a1)
 314:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 318:	fee79ae3          	bne	a5,a4,30c <memmove+0x46>
 31c:	bfc9                	j	2ee <memmove+0x28>

000000000000031e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31e:	1141                	add	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	ca05                	beqz	a2,354 <memcmp+0x36>
 326:	fff6069b          	addw	a3,a2,-1
 32a:	1682                	sll	a3,a3,0x20
 32c:	9281                	srl	a3,a3,0x20
 32e:	0685                	add	a3,a3,1
 330:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 332:	00054783          	lbu	a5,0(a0)
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00e79863          	bne	a5,a4,34a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 33e:	0505                	add	a0,a0,1
    p2++;
 340:	0585                	add	a1,a1,1
  while (n-- > 0) {
 342:	fed518e3          	bne	a0,a3,332 <memcmp+0x14>
  }
  return 0;
 346:	4501                	li	a0,0
 348:	a019                	j	34e <memcmp+0x30>
      return *p1 - *p2;
 34a:	40e7853b          	subw	a0,a5,a4
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	add	sp,sp,16
 352:	8082                	ret
  return 0;
 354:	4501                	li	a0,0
 356:	bfe5                	j	34e <memcmp+0x30>

0000000000000358 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 358:	1141                	add	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 360:	00000097          	auipc	ra,0x0
 364:	f66080e7          	jalr	-154(ra) # 2c6 <memmove>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	add	sp,sp,16
 36e:	8082                	ret

0000000000000370 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 370:	4885                	li	a7,1
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exit>:
.global exit
exit:
 li a7, SYS_exit
 378:	4889                	li	a7,2
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <wait>:
.global wait
wait:
 li a7, SYS_wait
 380:	488d                	li	a7,3
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 388:	4891                	li	a7,4
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <read>:
.global read
read:
 li a7, SYS_read
 390:	4895                	li	a7,5
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <write>:
.global write
write:
 li a7, SYS_write
 398:	48c1                	li	a7,16
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <close>:
.global close
close:
 li a7, SYS_close
 3a0:	48d5                	li	a7,21
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a8:	4899                	li	a7,6
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b0:	489d                	li	a7,7
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <open>:
.global open
open:
 li a7, SYS_open
 3b8:	48bd                	li	a7,15
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c0:	48c5                	li	a7,17
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c8:	48c9                	li	a7,18
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d0:	48a1                	li	a7,8
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <link>:
.global link
link:
 li a7, SYS_link
 3d8:	48cd                	li	a7,19
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e0:	48d1                	li	a7,20
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e8:	48a5                	li	a7,9
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f0:	48a9                	li	a7,10
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f8:	48ad                	li	a7,11
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 400:	48b1                	li	a7,12
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 408:	48b5                	li	a7,13
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 410:	48b9                	li	a7,14
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 418:	1101                	add	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	1000                	add	s0,sp,32
 420:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 424:	4605                	li	a2,1
 426:	fef40593          	add	a1,s0,-17
 42a:	00000097          	auipc	ra,0x0
 42e:	f6e080e7          	jalr	-146(ra) # 398 <write>
}
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6105                	add	sp,sp,32
 438:	8082                	ret

000000000000043a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43a:	7139                	add	sp,sp,-64
 43c:	fc06                	sd	ra,56(sp)
 43e:	f822                	sd	s0,48(sp)
 440:	f426                	sd	s1,40(sp)
 442:	f04a                	sd	s2,32(sp)
 444:	ec4e                	sd	s3,24(sp)
 446:	0080                	add	s0,sp,64
 448:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x16>
 44c:	0805c963          	bltz	a1,4de <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 450:	2581                	sext.w	a1,a1
  neg = 0;
 452:	4881                	li	a7,0
 454:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 458:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45a:	2601                	sext.w	a2,a2
 45c:	00000517          	auipc	a0,0x0
 460:	4c450513          	add	a0,a0,1220 # 920 <digits>
 464:	883a                	mv	a6,a4
 466:	2705                	addw	a4,a4,1
 468:	02c5f7bb          	remuw	a5,a1,a2
 46c:	1782                	sll	a5,a5,0x20
 46e:	9381                	srl	a5,a5,0x20
 470:	97aa                	add	a5,a5,a0
 472:	0007c783          	lbu	a5,0(a5)
 476:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47a:	0005879b          	sext.w	a5,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	add	a3,a3,1
 484:	fec7f0e3          	bgeu	a5,a2,464 <printint+0x2a>
  if(neg)
 488:	00088c63          	beqz	a7,4a0 <printint+0x66>
    buf[i++] = '-';
 48c:	fd070793          	add	a5,a4,-48
 490:	00878733          	add	a4,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef70823          	sb	a5,-16(a4)
 49c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05863          	blez	a4,4d0 <printint+0x96>
 4a4:	fc040793          	add	a5,s0,-64
 4a8:	00e78933          	add	s2,a5,a4
 4ac:	fff78993          	add	s3,a5,-1
 4b0:	99ba                	add	s3,s3,a4
 4b2:	377d                	addw	a4,a4,-1
 4b4:	1702                	sll	a4,a4,0x20
 4b6:	9301                	srl	a4,a4,0x20
 4b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4bc:	fff94583          	lbu	a1,-1(s2)
 4c0:	8526                	mv	a0,s1
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f56080e7          	jalr	-170(ra) # 418 <putc>
  while(--i >= 0)
 4ca:	197d                	add	s2,s2,-1
 4cc:	ff3918e3          	bne	s2,s3,4bc <printint+0x82>
}
 4d0:	70e2                	ld	ra,56(sp)
 4d2:	7442                	ld	s0,48(sp)
 4d4:	74a2                	ld	s1,40(sp)
 4d6:	7902                	ld	s2,32(sp)
 4d8:	69e2                	ld	s3,24(sp)
 4da:	6121                	add	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf85                	j	454 <printint+0x1a>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	715d                	add	sp,sp,-80
 4e8:	e486                	sd	ra,72(sp)
 4ea:	e0a2                	sd	s0,64(sp)
 4ec:	fc26                	sd	s1,56(sp)
 4ee:	f84a                	sd	s2,48(sp)
 4f0:	f44e                	sd	s3,40(sp)
 4f2:	f052                	sd	s4,32(sp)
 4f4:	ec56                	sd	s5,24(sp)
 4f6:	e85a                	sd	s6,16(sp)
 4f8:	e45e                	sd	s7,8(sp)
 4fa:	e062                	sd	s8,0(sp)
 4fc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fe:	0005c903          	lbu	s2,0(a1)
 502:	18090c63          	beqz	s2,69a <vprintf+0x1b4>
 506:	8aaa                	mv	s5,a0
 508:	8bb2                	mv	s7,a2
 50a:	00158493          	add	s1,a1,1
  state = 0;
 50e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 510:	02500a13          	li	s4,37
 514:	4b55                	li	s6,21
 516:	a839                	j	534 <vprintf+0x4e>
        putc(fd, c);
 518:	85ca                	mv	a1,s2
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	efc080e7          	jalr	-260(ra) # 418 <putc>
 524:	a019                	j	52a <vprintf+0x44>
    } else if(state == '%'){
 526:	01498d63          	beq	s3,s4,540 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 52a:	0485                	add	s1,s1,1
 52c:	fff4c903          	lbu	s2,-1(s1)
 530:	16090563          	beqz	s2,69a <vprintf+0x1b4>
    if(state == 0){
 534:	fe0999e3          	bnez	s3,526 <vprintf+0x40>
      if(c == '%'){
 538:	ff4910e3          	bne	s2,s4,518 <vprintf+0x32>
        state = '%';
 53c:	89d2                	mv	s3,s4
 53e:	b7f5                	j	52a <vprintf+0x44>
      if(c == 'd'){
 540:	13490263          	beq	s2,s4,664 <vprintf+0x17e>
 544:	f9d9079b          	addw	a5,s2,-99
 548:	0ff7f793          	zext.b	a5,a5
 54c:	12fb6563          	bltu	s6,a5,676 <vprintf+0x190>
 550:	f9d9079b          	addw	a5,s2,-99
 554:	0ff7f713          	zext.b	a4,a5
 558:	10eb6f63          	bltu	s6,a4,676 <vprintf+0x190>
 55c:	00271793          	sll	a5,a4,0x2
 560:	00000717          	auipc	a4,0x0
 564:	36870713          	add	a4,a4,872 # 8c8 <malloc+0x130>
 568:	97ba                	add	a5,a5,a4
 56a:	439c                	lw	a5,0(a5)
 56c:	97ba                	add	a5,a5,a4
 56e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b8913          	add	s2,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ebc080e7          	jalr	-324(ra) # 43a <printint>
 586:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 588:	4981                	li	s3,0
 58a:	b745                	j	52a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8913          	add	s2,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	ea0080e7          	jalr	-352(ra) # 43a <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b751                	j	52a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5a8:	008b8913          	add	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e84080e7          	jalr	-380(ra) # 43a <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b7a5                	j	52a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5c4:	008b8c13          	add	s8,s7,8
 5c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5cc:	03000593          	li	a1,48
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e46080e7          	jalr	-442(ra) # 418 <putc>
  putc(fd, 'x');
 5da:	07800593          	li	a1,120
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e38080e7          	jalr	-456(ra) # 418 <putc>
 5e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	00000b97          	auipc	s7,0x0
 5ee:	336b8b93          	add	s7,s7,822 # 920 <digits>
 5f2:	03c9d793          	srl	a5,s3,0x3c
 5f6:	97de                	add	a5,a5,s7
 5f8:	0007c583          	lbu	a1,0(a5)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e1a080e7          	jalr	-486(ra) # 418 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 606:	0992                	sll	s3,s3,0x4
 608:	397d                	addw	s2,s2,-1
 60a:	fe0914e3          	bnez	s2,5f2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 60e:	8be2                	mv	s7,s8
      state = 0;
 610:	4981                	li	s3,0
 612:	bf21                	j	52a <vprintf+0x44>
        s = va_arg(ap, char*);
 614:	008b8993          	add	s3,s7,8
 618:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 61c:	02090163          	beqz	s2,63e <vprintf+0x158>
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	c9a5                	beqz	a1,694 <vprintf+0x1ae>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	df0080e7          	jalr	-528(ra) # 418 <putc>
          s++;
 630:	0905                	add	s2,s2,1
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	f9e5                	bnez	a1,626 <vprintf+0x140>
        s = va_arg(ap, char*);
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5fd                	j	52a <vprintf+0x44>
          s = "(null)";
 63e:	00000917          	auipc	s2,0x0
 642:	28290913          	add	s2,s2,642 # 8c0 <malloc+0x128>
        while(*s != 0){
 646:	02800593          	li	a1,40
 64a:	bff1                	j	626 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 64c:	008b8913          	add	s2,s7,8
 650:	000bc583          	lbu	a1,0(s7)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	dc2080e7          	jalr	-574(ra) # 418 <putc>
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	b5e1                	j	52a <vprintf+0x44>
        putc(fd, c);
 664:	02500593          	li	a1,37
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	dae080e7          	jalr	-594(ra) # 418 <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bd5d                	j	52a <vprintf+0x44>
        putc(fd, '%');
 676:	02500593          	li	a1,37
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d9c080e7          	jalr	-612(ra) # 418 <putc>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d90080e7          	jalr	-624(ra) # 418 <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	bd61                	j	52a <vprintf+0x44>
        s = va_arg(ap, char*);
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bd49                	j	52a <vprintf+0x44>
    }
  }
}
 69a:	60a6                	ld	ra,72(sp)
 69c:	6406                	ld	s0,64(sp)
 69e:	74e2                	ld	s1,56(sp)
 6a0:	7942                	ld	s2,48(sp)
 6a2:	79a2                	ld	s3,40(sp)
 6a4:	7a02                	ld	s4,32(sp)
 6a6:	6ae2                	ld	s5,24(sp)
 6a8:	6b42                	ld	s6,16(sp)
 6aa:	6ba2                	ld	s7,8(sp)
 6ac:	6c02                	ld	s8,0(sp)
 6ae:	6161                	add	sp,sp,80
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	add	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	add	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	8622                	mv	a2,s0
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e16080e7          	jalr	-490(ra) # 4e6 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6161                	add	sp,sp,80
 6de:	8082                	ret

00000000000006e0 <printf>:

void
printf(const char *fmt, ...)
{
 6e0:	711d                	add	sp,sp,-96
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	add	s0,sp,32
 6e8:	e40c                	sd	a1,8(s0)
 6ea:	e810                	sd	a2,16(s0)
 6ec:	ec14                	sd	a3,24(s0)
 6ee:	f018                	sd	a4,32(s0)
 6f0:	f41c                	sd	a5,40(s0)
 6f2:	03043823          	sd	a6,48(s0)
 6f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fa:	00840613          	add	a2,s0,8
 6fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 702:	85aa                	mv	a1,a0
 704:	4505                	li	a0,1
 706:	00000097          	auipc	ra,0x0
 70a:	de0080e7          	jalr	-544(ra) # 4e6 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6125                	add	sp,sp,96
 714:	8082                	ret

0000000000000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	1141                	add	sp,sp,-16
 718:	e422                	sd	s0,8(sp)
 71a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	00000797          	auipc	a5,0x0
 724:	2187b783          	ld	a5,536(a5) # 938 <freep>
 728:	a02d                	j	752 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72a:	4618                	lw	a4,8(a2)
 72c:	9f2d                	addw	a4,a4,a1
 72e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	6398                	ld	a4,0(a5)
 734:	6310                	ld	a2,0(a4)
 736:	a83d                	j	774 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 738:	ff852703          	lw	a4,-8(a0)
 73c:	9f31                	addw	a4,a4,a2
 73e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 740:	ff053683          	ld	a3,-16(a0)
 744:	a091                	j	788 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	6398                	ld	a4,0(a5)
 748:	00e7e463          	bltu	a5,a4,750 <free+0x3a>
 74c:	00e6ea63          	bltu	a3,a4,760 <free+0x4a>
{
 750:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	fed7fae3          	bgeu	a5,a3,746 <free+0x30>
 756:	6398                	ld	a4,0(a5)
 758:	00e6e463          	bltu	a3,a4,760 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	fee7eae3          	bltu	a5,a4,750 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 760:	ff852583          	lw	a1,-8(a0)
 764:	6390                	ld	a2,0(a5)
 766:	02059813          	sll	a6,a1,0x20
 76a:	01c85713          	srl	a4,a6,0x1c
 76e:	9736                	add	a4,a4,a3
 770:	fae60de3          	beq	a2,a4,72a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 778:	4790                	lw	a2,8(a5)
 77a:	02061593          	sll	a1,a2,0x20
 77e:	01c5d713          	srl	a4,a1,0x1c
 782:	973e                	add	a4,a4,a5
 784:	fae68ae3          	beq	a3,a4,738 <free+0x22>
    p->s.ptr = bp->s.ptr;
 788:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 78a:	00000717          	auipc	a4,0x0
 78e:	1af73723          	sd	a5,430(a4) # 938 <freep>
}
 792:	6422                	ld	s0,8(sp)
 794:	0141                	add	sp,sp,16
 796:	8082                	ret

0000000000000798 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 798:	7139                	add	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f426                	sd	s1,40(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	e852                	sd	s4,16(sp)
 7a6:	e456                	sd	s5,8(sp)
 7a8:	e05a                	sd	s6,0(sp)
 7aa:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ac:	02051493          	sll	s1,a0,0x20
 7b0:	9081                	srl	s1,s1,0x20
 7b2:	04bd                	add	s1,s1,15
 7b4:	8091                	srl	s1,s1,0x4
 7b6:	0014899b          	addw	s3,s1,1
 7ba:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7bc:	00000517          	auipc	a0,0x0
 7c0:	17c53503          	ld	a0,380(a0) # 938 <freep>
 7c4:	c515                	beqz	a0,7f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c8:	4798                	lw	a4,8(a5)
 7ca:	02977f63          	bgeu	a4,s1,808 <malloc+0x70>
  if(nu < 4096)
 7ce:	8a4e                	mv	s4,s3
 7d0:	0009871b          	sext.w	a4,s3
 7d4:	6685                	lui	a3,0x1
 7d6:	00d77363          	bgeu	a4,a3,7dc <malloc+0x44>
 7da:	6a05                	lui	s4,0x1
 7dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e4:	00000917          	auipc	s2,0x0
 7e8:	15490913          	add	s2,s2,340 # 938 <freep>
  if(p == (char*)-1)
 7ec:	5afd                	li	s5,-1
 7ee:	a895                	j	862 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7f0:	00000797          	auipc	a5,0x0
 7f4:	15078793          	add	a5,a5,336 # 940 <base>
 7f8:	00000717          	auipc	a4,0x0
 7fc:	14f73023          	sd	a5,320(a4) # 938 <freep>
 800:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 802:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 806:	b7e1                	j	7ce <malloc+0x36>
      if(p->s.size == nunits)
 808:	02e48c63          	beq	s1,a4,840 <malloc+0xa8>
        p->s.size -= nunits;
 80c:	4137073b          	subw	a4,a4,s3
 810:	c798                	sw	a4,8(a5)
        p += p->s.size;
 812:	02071693          	sll	a3,a4,0x20
 816:	01c6d713          	srl	a4,a3,0x1c
 81a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 820:	00000717          	auipc	a4,0x0
 824:	10a73c23          	sd	a0,280(a4) # 938 <freep>
      return (void*)(p + 1);
 828:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82c:	70e2                	ld	ra,56(sp)
 82e:	7442                	ld	s0,48(sp)
 830:	74a2                	ld	s1,40(sp)
 832:	7902                	ld	s2,32(sp)
 834:	69e2                	ld	s3,24(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
 83c:	6121                	add	sp,sp,64
 83e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	e118                	sd	a4,0(a0)
 844:	bff1                	j	820 <malloc+0x88>
  hp->s.size = nu;
 846:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84a:	0541                	add	a0,a0,16
 84c:	00000097          	auipc	ra,0x0
 850:	eca080e7          	jalr	-310(ra) # 716 <free>
  return freep;
 854:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 858:	d971                	beqz	a0,82c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	fa9775e3          	bgeu	a4,s1,808 <malloc+0x70>
    if(p == freep)
 862:	00093703          	ld	a4,0(s2)
 866:	853e                	mv	a0,a5
 868:	fef719e3          	bne	a4,a5,85a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 86c:	8552                	mv	a0,s4
 86e:	00000097          	auipc	ra,0x0
 872:	b92080e7          	jalr	-1134(ra) # 400 <sbrk>
  if(p == (char*)-1)
 876:	fd5518e3          	bne	a0,s5,846 <malloc+0xae>
        return 0;
 87a:	4501                	li	a0,0
 87c:	bf45                	j	82c <malloc+0x94>
