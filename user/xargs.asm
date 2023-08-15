
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   0:	7125                	add	sp,sp,-416
   2:	ef06                	sd	ra,408(sp)
   4:	eb22                	sd	s0,400(sp)
   6:	e726                	sd	s1,392(sp)
   8:	e34a                	sd	s2,384(sp)
   a:	fece                	sd	s3,376(sp)
   c:	fad2                	sd	s4,368(sp)
   e:	f6d6                	sd	s5,360(sp)
  10:	f2da                	sd	s6,352(sp)
  12:	eede                	sd	s7,344(sp)
  14:	eae2                	sd	s8,336(sp)
  16:	e6e6                	sd	s9,328(sp)
  18:	1300                	add	s0,sp,416
  1a:	8c2e                	mv	s8,a1
    int l,m = 0;
    char block[32];
    char buf[32];
    char *p = buf;
    char *lineSplit[32];
    for(i = 1; i < argc; i++){
  1c:	4785                	li	a5,1
  1e:	06a7d063          	bge	a5,a0,7e <main+0x7e>
  22:	00858713          	add	a4,a1,8
  26:	e6040793          	add	a5,s0,-416
  2a:	0005099b          	sext.w	s3,a0
  2e:	ffe5061b          	addw	a2,a0,-2
  32:	02061693          	sll	a3,a2,0x20
  36:	01d6d613          	srl	a2,a3,0x1d
  3a:	e6840693          	add	a3,s0,-408
  3e:	9636                	add	a2,a2,a3
        lineSplit[j++] = argv[i];
  40:	6314                	ld	a3,0(a4)
  42:	e394                	sd	a3,0(a5)
    for(i = 1; i < argc; i++){
  44:	0721                	add	a4,a4,8
  46:	07a1                	add	a5,a5,8
  48:	fec79ce3          	bne	a5,a2,40 <main+0x40>
        lineSplit[j++] = argv[i];
  4c:	39fd                	addw	s3,s3,-1
    char *p = buf;
  4e:	f6040c93          	add	s9,s0,-160
    int l,m = 0;
  52:	4901                	li	s2,0
    }
    while( (k = read(0, block, sizeof(block))) > 0){
        for(l = 0; l < k; l++){
            if(block[l] == '\n'){
  54:	4aa9                	li	s5,10
                buf[m] = 0;
                m = 0;
                lineSplit[j++] = p;
                p = buf;
                lineSplit[j] = 0;
                j = argc - 1;
  56:	fff50b9b          	addw	s7,a0,-1
    while( (k = read(0, block, sizeof(block))) > 0){
  5a:	02000613          	li	a2,32
  5e:	f8040593          	add	a1,s0,-128
  62:	4501                	li	a0,0
  64:	00000097          	auipc	ra,0x0
  68:	350080e7          	jalr	848(ra) # 3b4 <read>
  6c:	0aa05d63          	blez	a0,126 <main+0x126>
        for(l = 0; l < k; l++){
  70:	f8040493          	add	s1,s0,-128
  74:	00950a33          	add	s4,a0,s1
                if(fork() == 0){
                    exec(argv[1], lineSplit);
                }                
                wait(0);
            }else if(block[l] == ' ') {
  78:	02000b13          	li	s6,32
  7c:	a841                	j	10c <main+0x10c>
    int j = 0;
  7e:	4981                	li	s3,0
  80:	b7f9                	j	4e <main+0x4e>
                buf[m] = 0;
  82:	fa090793          	add	a5,s2,-96
  86:	00878933          	add	s2,a5,s0
  8a:	fc090023          	sb	zero,-64(s2)
                lineSplit[j++] = p;
  8e:	00399793          	sll	a5,s3,0x3
  92:	fa078793          	add	a5,a5,-96
  96:	97a2                	add	a5,a5,s0
  98:	ed97b023          	sd	s9,-320(a5)
                lineSplit[j] = 0;
  9c:	2985                	addw	s3,s3,1
  9e:	098e                	sll	s3,s3,0x3
  a0:	fa098793          	add	a5,s3,-96
  a4:	008789b3          	add	s3,a5,s0
  a8:	ec09b023          	sd	zero,-320(s3)
                j = argc - 1;
  ac:	89de                	mv	s3,s7
                if(fork() == 0){
  ae:	00000097          	auipc	ra,0x0
  b2:	2e6080e7          	jalr	742(ra) # 394 <fork>
  b6:	c911                	beqz	a0,ca <main+0xca>
                wait(0);
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	2ea080e7          	jalr	746(ra) # 3a4 <wait>
                p = buf;
  c2:	f6040c93          	add	s9,s0,-160
                m = 0;
  c6:	4901                	li	s2,0
  c8:	a83d                	j	106 <main+0x106>
                    exec(argv[1], lineSplit);
  ca:	e6040593          	add	a1,s0,-416
  ce:	008c3503          	ld	a0,8(s8)
  d2:	00000097          	auipc	ra,0x0
  d6:	302080e7          	jalr	770(ra) # 3d4 <exec>
  da:	bff9                	j	b8 <main+0xb8>
                buf[m++] = 0;
  dc:	0019071b          	addw	a4,s2,1
  e0:	fa090793          	add	a5,s2,-96
  e4:	00878933          	add	s2,a5,s0
  e8:	fc090023          	sb	zero,-64(s2)
                lineSplit[j++] = p;
  ec:	00399793          	sll	a5,s3,0x3
  f0:	fa078793          	add	a5,a5,-96
  f4:	97a2                	add	a5,a5,s0
  f6:	ed97b023          	sd	s9,-320(a5)
                p = &buf[m];
  fa:	f6040793          	add	a5,s0,-160
  fe:	00e78cb3          	add	s9,a5,a4
                buf[m++] = 0;
 102:	893a                	mv	s2,a4
                lineSplit[j++] = p;
 104:	2985                	addw	s3,s3,1
        for(l = 0; l < k; l++){
 106:	0485                	add	s1,s1,1
 108:	f49a09e3          	beq	s4,s1,5a <main+0x5a>
            if(block[l] == '\n'){
 10c:	0004c783          	lbu	a5,0(s1)
 110:	f75789e3          	beq	a5,s5,82 <main+0x82>
            }else if(block[l] == ' ') {
 114:	fd6784e3          	beq	a5,s6,dc <main+0xdc>
            }else {
                buf[m++] = block[l];
 118:	fa090713          	add	a4,s2,-96
 11c:	9722                	add	a4,a4,s0
 11e:	fcf70023          	sb	a5,-64(a4)
 122:	2905                	addw	s2,s2,1
 124:	b7cd                	j	106 <main+0x106>
            }
        }
    }
    exit(0);
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	274080e7          	jalr	628(ra) # 39c <exit>

0000000000000130 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 130:	1141                	add	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 136:	87aa                	mv	a5,a0
 138:	0585                	add	a1,a1,1
 13a:	0785                	add	a5,a5,1
 13c:	fff5c703          	lbu	a4,-1(a1)
 140:	fee78fa3          	sb	a4,-1(a5)
 144:	fb75                	bnez	a4,138 <strcpy+0x8>
    ;
  return os;
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	add	sp,sp,16
 14a:	8082                	ret

000000000000014c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14c:	1141                	add	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	cb91                	beqz	a5,16a <strcmp+0x1e>
 158:	0005c703          	lbu	a4,0(a1)
 15c:	00f71763          	bne	a4,a5,16a <strcmp+0x1e>
    p++, q++;
 160:	0505                	add	a0,a0,1
 162:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 164:	00054783          	lbu	a5,0(a0)
 168:	fbe5                	bnez	a5,158 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16a:	0005c503          	lbu	a0,0(a1)
}
 16e:	40a7853b          	subw	a0,a5,a0
 172:	6422                	ld	s0,8(sp)
 174:	0141                	add	sp,sp,16
 176:	8082                	ret

0000000000000178 <strlen>:

unsigned int
strlen(const char *s)
{
 178:	1141                	add	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf91                	beqz	a5,19e <strlen+0x26>
 184:	0505                	add	a0,a0,1
 186:	87aa                	mv	a5,a0
 188:	86be                	mv	a3,a5
 18a:	0785                	add	a5,a5,1
 18c:	fff7c703          	lbu	a4,-1(a5)
 190:	ff65                	bnez	a4,188 <strlen+0x10>
 192:	40a6853b          	subw	a0,a3,a0
 196:	2505                	addw	a0,a0,1
    ;
  return n;
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	add	sp,sp,16
 19c:	8082                	ret
  for(n = 0; s[n]; n++)
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strlen+0x20>

00000000000001a2 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
 1a2:	1141                	add	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a8:	ca19                	beqz	a2,1be <memset+0x1c>
 1aa:	87aa                	mv	a5,a0
 1ac:	1602                	sll	a2,a2,0x20
 1ae:	9201                	srl	a2,a2,0x20
 1b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b8:	0785                	add	a5,a5,1
 1ba:	fee79de3          	bne	a5,a4,1b4 <memset+0x12>
  }
  return dst;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strchr>:

char*
strchr(const char *s, char c)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb99                	beqz	a5,1e4 <strchr+0x20>
    if(*s == c)
 1d0:	00f58763          	beq	a1,a5,1de <strchr+0x1a>
  for(; *s; s++)
 1d4:	0505                	add	a0,a0,1
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	fbfd                	bnez	a5,1d0 <strchr+0xc>
      return (char*)s;
  return 0;
 1dc:	4501                	li	a0,0
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	add	sp,sp,16
 1e2:	8082                	ret
  return 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <strchr+0x1a>

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	711d                	add	sp,sp,-96
 1ea:	ec86                	sd	ra,88(sp)
 1ec:	e8a2                	sd	s0,80(sp)
 1ee:	e4a6                	sd	s1,72(sp)
 1f0:	e0ca                	sd	s2,64(sp)
 1f2:	fc4e                	sd	s3,56(sp)
 1f4:	f852                	sd	s4,48(sp)
 1f6:	f456                	sd	s5,40(sp)
 1f8:	f05a                	sd	s6,32(sp)
 1fa:	ec5e                	sd	s7,24(sp)
 1fc:	1080                	add	s0,sp,96
 1fe:	8baa                	mv	s7,a0
 200:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 202:	892a                	mv	s2,a0
 204:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 206:	4aa9                	li	s5,10
 208:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20a:	89a6                	mv	s3,s1
 20c:	2485                	addw	s1,s1,1
 20e:	0344d863          	bge	s1,s4,23e <gets+0x56>
    cc = read(0, &c, 1);
 212:	4605                	li	a2,1
 214:	faf40593          	add	a1,s0,-81
 218:	4501                	li	a0,0
 21a:	00000097          	auipc	ra,0x0
 21e:	19a080e7          	jalr	410(ra) # 3b4 <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x56>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01578763          	beq	a5,s5,23c <gets+0x54>
 232:	0905                	add	s2,s2,1
 234:	fd679be3          	bne	a5,s6,20a <gets+0x22>
  for(i=0; i+1 < max; ){
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x56>
 23c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	add	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int
stat(const char *n, struct stat *st)
{
 25c:	1101                	add	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e426                	sd	s1,8(sp)
 264:	e04a                	sd	s2,0(sp)
 266:	1000                	add	s0,sp,32
 268:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	4581                	li	a1,0
 26c:	00000097          	auipc	ra,0x0
 270:	170080e7          	jalr	368(ra) # 3dc <open>
  if(fd < 0)
 274:	02054563          	bltz	a0,29e <stat+0x42>
 278:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27a:	85ca                	mv	a1,s2
 27c:	00000097          	auipc	ra,0x0
 280:	178080e7          	jalr	376(ra) # 3f4 <fstat>
 284:	892a                	mv	s2,a0
  close(fd);
 286:	8526                	mv	a0,s1
 288:	00000097          	auipc	ra,0x0
 28c:	13c080e7          	jalr	316(ra) # 3c4 <close>
  return r;
}
 290:	854a                	mv	a0,s2
 292:	60e2                	ld	ra,24(sp)
 294:	6442                	ld	s0,16(sp)
 296:	64a2                	ld	s1,8(sp)
 298:	6902                	ld	s2,0(sp)
 29a:	6105                	add	sp,sp,32
 29c:	8082                	ret
    return -1;
 29e:	597d                	li	s2,-1
 2a0:	bfc5                	j	290 <stat+0x34>

00000000000002a2 <atoi>:

int
atoi(const char *s)
{
 2a2:	1141                	add	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a8:	00054683          	lbu	a3,0(a0)
 2ac:	fd06879b          	addw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	4625                	li	a2,9
 2b6:	02f66863          	bltu	a2,a5,2e6 <atoi+0x44>
 2ba:	872a                	mv	a4,a0
  n = 0;
 2bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2be:	0705                	add	a4,a4,1
 2c0:	0025179b          	sllw	a5,a0,0x2
 2c4:	9fa9                	addw	a5,a5,a0
 2c6:	0017979b          	sllw	a5,a5,0x1
 2ca:	9fb5                	addw	a5,a5,a3
 2cc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d0:	00074683          	lbu	a3,0(a4)
 2d4:	fd06879b          	addw	a5,a3,-48
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	fef671e3          	bgeu	a2,a5,2be <atoi+0x1c>
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	add	sp,sp,16
 2e4:	8082                	ret
  n = 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <atoi+0x3e>

00000000000002ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ea:	1141                	add	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f0:	02b57463          	bgeu	a0,a1,318 <memmove+0x2e>
    while(n-- > 0)
 2f4:	00c05f63          	blez	a2,312 <memmove+0x28>
 2f8:	1602                	sll	a2,a2,0x20
 2fa:	9201                	srl	a2,a2,0x20
 2fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 300:	872a                	mv	a4,a0
      *dst++ = *src++;
 302:	0585                	add	a1,a1,1
 304:	0705                	add	a4,a4,1
 306:	fff5c683          	lbu	a3,-1(a1)
 30a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	add	sp,sp,16
 316:	8082                	ret
    dst += n;
 318:	00c50733          	add	a4,a0,a2
    src += n;
 31c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31e:	fec05ae3          	blez	a2,312 <memmove+0x28>
 322:	fff6079b          	addw	a5,a2,-1
 326:	1782                	sll	a5,a5,0x20
 328:	9381                	srl	a5,a5,0x20
 32a:	fff7c793          	not	a5,a5
 32e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 330:	15fd                	add	a1,a1,-1
 332:	177d                	add	a4,a4,-1
 334:	0005c683          	lbu	a3,0(a1)
 338:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33c:	fee79ae3          	bne	a5,a4,330 <memmove+0x46>
 340:	bfc9                	j	312 <memmove+0x28>

0000000000000342 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
 342:	1141                	add	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 348:	ca05                	beqz	a2,378 <memcmp+0x36>
 34a:	fff6069b          	addw	a3,a2,-1
 34e:	1682                	sll	a3,a3,0x20
 350:	9281                	srl	a3,a3,0x20
 352:	0685                	add	a3,a3,1
 354:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 356:	00054783          	lbu	a5,0(a0)
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	00e79863          	bne	a5,a4,36e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 362:	0505                	add	a0,a0,1
    p2++;
 364:	0585                	add	a1,a1,1
  while (n-- > 0) {
 366:	fed518e3          	bne	a0,a3,356 <memcmp+0x14>
  }
  return 0;
 36a:	4501                	li	a0,0
 36c:	a019                	j	372 <memcmp+0x30>
      return *p1 - *p2;
 36e:	40e7853b          	subw	a0,a5,a4
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <memcmp+0x30>

000000000000037c <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
 37c:	1141                	add	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 384:	00000097          	auipc	ra,0x0
 388:	f66080e7          	jalr	-154(ra) # 2ea <memmove>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	add	sp,sp,16
 392:	8082                	ret

0000000000000394 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 394:	4885                	li	a7,1
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exit>:
.global exit
exit:
 li a7, SYS_exit
 39c:	4889                	li	a7,2
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a4:	488d                	li	a7,3
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ac:	4891                	li	a7,4
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <read>:
.global read
read:
 li a7, SYS_read
 3b4:	4895                	li	a7,5
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <write>:
.global write
write:
 li a7, SYS_write
 3bc:	48c1                	li	a7,16
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <close>:
.global close
close:
 li a7, SYS_close
 3c4:	48d5                	li	a7,21
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3cc:	4899                	li	a7,6
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d4:	489d                	li	a7,7
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <open>:
.global open
open:
 li a7, SYS_open
 3dc:	48bd                	li	a7,15
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e4:	48c5                	li	a7,17
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ec:	48c9                	li	a7,18
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f4:	48a1                	li	a7,8
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <link>:
.global link
link:
 li a7, SYS_link
 3fc:	48cd                	li	a7,19
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 404:	48d1                	li	a7,20
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40c:	48a5                	li	a7,9
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <dup>:
.global dup
dup:
 li a7, SYS_dup
 414:	48a9                	li	a7,10
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41c:	48ad                	li	a7,11
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 424:	48b1                	li	a7,12
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42c:	48b5                	li	a7,13
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 434:	48b9                	li	a7,14
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43c:	1101                	add	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	add	s0,sp,32
 444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 448:	4605                	li	a2,1
 44a:	fef40593          	add	a1,s0,-17
 44e:	00000097          	auipc	ra,0x0
 452:	f6e080e7          	jalr	-146(ra) # 3bc <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	add	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45e:	7139                	add	sp,sp,-64
 460:	fc06                	sd	ra,56(sp)
 462:	f822                	sd	s0,48(sp)
 464:	f426                	sd	s1,40(sp)
 466:	f04a                	sd	s2,32(sp)
 468:	ec4e                	sd	s3,24(sp)
 46a:	0080                	add	s0,sp,64
 46c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46e:	c299                	beqz	a3,474 <printint+0x16>
 470:	0805c963          	bltz	a1,502 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 474:	2581                	sext.w	a1,a1
  neg = 0;
 476:	4881                	li	a7,0
 478:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 47c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47e:	2601                	sext.w	a2,a2
 480:	00000517          	auipc	a0,0x0
 484:	48850513          	add	a0,a0,1160 # 908 <digits>
 488:	883a                	mv	a6,a4
 48a:	2705                	addw	a4,a4,1
 48c:	02c5f7bb          	remuw	a5,a1,a2
 490:	1782                	sll	a5,a5,0x20
 492:	9381                	srl	a5,a5,0x20
 494:	97aa                	add	a5,a5,a0
 496:	0007c783          	lbu	a5,0(a5)
 49a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49e:	0005879b          	sext.w	a5,a1
 4a2:	02c5d5bb          	divuw	a1,a1,a2
 4a6:	0685                	add	a3,a3,1
 4a8:	fec7f0e3          	bgeu	a5,a2,488 <printint+0x2a>
  if(neg)
 4ac:	00088c63          	beqz	a7,4c4 <printint+0x66>
    buf[i++] = '-';
 4b0:	fd070793          	add	a5,a4,-48
 4b4:	00878733          	add	a4,a5,s0
 4b8:	02d00793          	li	a5,45
 4bc:	fef70823          	sb	a5,-16(a4)
 4c0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4c4:	02e05863          	blez	a4,4f4 <printint+0x96>
 4c8:	fc040793          	add	a5,s0,-64
 4cc:	00e78933          	add	s2,a5,a4
 4d0:	fff78993          	add	s3,a5,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	377d                	addw	a4,a4,-1
 4d8:	1702                	sll	a4,a4,0x20
 4da:	9301                	srl	a4,a4,0x20
 4dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e0:	fff94583          	lbu	a1,-1(s2)
 4e4:	8526                	mv	a0,s1
 4e6:	00000097          	auipc	ra,0x0
 4ea:	f56080e7          	jalr	-170(ra) # 43c <putc>
  while(--i >= 0)
 4ee:	197d                	add	s2,s2,-1
 4f0:	ff3918e3          	bne	s2,s3,4e0 <printint+0x82>
}
 4f4:	70e2                	ld	ra,56(sp)
 4f6:	7442                	ld	s0,48(sp)
 4f8:	74a2                	ld	s1,40(sp)
 4fa:	7902                	ld	s2,32(sp)
 4fc:	69e2                	ld	s3,24(sp)
 4fe:	6121                	add	sp,sp,64
 500:	8082                	ret
    x = -xx;
 502:	40b005bb          	negw	a1,a1
    neg = 1;
 506:	4885                	li	a7,1
    x = -xx;
 508:	bf85                	j	478 <printint+0x1a>

000000000000050a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50a:	715d                	add	sp,sp,-80
 50c:	e486                	sd	ra,72(sp)
 50e:	e0a2                	sd	s0,64(sp)
 510:	fc26                	sd	s1,56(sp)
 512:	f84a                	sd	s2,48(sp)
 514:	f44e                	sd	s3,40(sp)
 516:	f052                	sd	s4,32(sp)
 518:	ec56                	sd	s5,24(sp)
 51a:	e85a                	sd	s6,16(sp)
 51c:	e45e                	sd	s7,8(sp)
 51e:	e062                	sd	s8,0(sp)
 520:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c903          	lbu	s2,0(a1)
 526:	18090c63          	beqz	s2,6be <vprintf+0x1b4>
 52a:	8aaa                	mv	s5,a0
 52c:	8bb2                	mv	s7,a2
 52e:	00158493          	add	s1,a1,1
  state = 0;
 532:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 534:	02500a13          	li	s4,37
 538:	4b55                	li	s6,21
 53a:	a839                	j	558 <vprintf+0x4e>
        putc(fd, c);
 53c:	85ca                	mv	a1,s2
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	efc080e7          	jalr	-260(ra) # 43c <putc>
 548:	a019                	j	54e <vprintf+0x44>
    } else if(state == '%'){
 54a:	01498d63          	beq	s3,s4,564 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 54e:	0485                	add	s1,s1,1
 550:	fff4c903          	lbu	s2,-1(s1)
 554:	16090563          	beqz	s2,6be <vprintf+0x1b4>
    if(state == 0){
 558:	fe0999e3          	bnez	s3,54a <vprintf+0x40>
      if(c == '%'){
 55c:	ff4910e3          	bne	s2,s4,53c <vprintf+0x32>
        state = '%';
 560:	89d2                	mv	s3,s4
 562:	b7f5                	j	54e <vprintf+0x44>
      if(c == 'd'){
 564:	13490263          	beq	s2,s4,688 <vprintf+0x17e>
 568:	f9d9079b          	addw	a5,s2,-99
 56c:	0ff7f793          	zext.b	a5,a5
 570:	12fb6563          	bltu	s6,a5,69a <vprintf+0x190>
 574:	f9d9079b          	addw	a5,s2,-99
 578:	0ff7f713          	zext.b	a4,a5
 57c:	10eb6f63          	bltu	s6,a4,69a <vprintf+0x190>
 580:	00271793          	sll	a5,a4,0x2
 584:	00000717          	auipc	a4,0x0
 588:	32c70713          	add	a4,a4,812 # 8b0 <malloc+0xf4>
 58c:	97ba                	add	a5,a5,a4
 58e:	439c                	lw	a5,0(a5)
 590:	97ba                	add	a5,a5,a4
 592:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 594:	008b8913          	add	s2,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	ebc080e7          	jalr	-324(ra) # 45e <printint>
 5aa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b745                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	008b8913          	add	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	ea0080e7          	jalr	-352(ra) # 45e <printint>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b751                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5cc:	008b8913          	add	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4641                	li	a2,16
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e84080e7          	jalr	-380(ra) # 45e <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b7a5                	j	54e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5e8:	008b8c13          	add	s8,s7,8
 5ec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f0:	03000593          	li	a1,48
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e46080e7          	jalr	-442(ra) # 43c <putc>
  putc(fd, 'x');
 5fe:	07800593          	li	a1,120
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e38080e7          	jalr	-456(ra) # 43c <putc>
 60c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00000b97          	auipc	s7,0x0
 612:	2fab8b93          	add	s7,s7,762 # 908 <digits>
 616:	03c9d793          	srl	a5,s3,0x3c
 61a:	97de                	add	a5,a5,s7
 61c:	0007c583          	lbu	a1,0(a5)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e1a080e7          	jalr	-486(ra) # 43c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62a:	0992                	sll	s3,s3,0x4
 62c:	397d                	addw	s2,s2,-1
 62e:	fe0914e3          	bnez	s2,616 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 632:	8be2                	mv	s7,s8
      state = 0;
 634:	4981                	li	s3,0
 636:	bf21                	j	54e <vprintf+0x44>
        s = va_arg(ap, char*);
 638:	008b8993          	add	s3,s7,8
 63c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 640:	02090163          	beqz	s2,662 <vprintf+0x158>
        while(*s != 0){
 644:	00094583          	lbu	a1,0(s2)
 648:	c9a5                	beqz	a1,6b8 <vprintf+0x1ae>
          putc(fd, *s);
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	df0080e7          	jalr	-528(ra) # 43c <putc>
          s++;
 654:	0905                	add	s2,s2,1
        while(*s != 0){
 656:	00094583          	lbu	a1,0(s2)
 65a:	f9e5                	bnez	a1,64a <vprintf+0x140>
        s = va_arg(ap, char*);
 65c:	8bce                	mv	s7,s3
      state = 0;
 65e:	4981                	li	s3,0
 660:	b5fd                	j	54e <vprintf+0x44>
          s = "(null)";
 662:	00000917          	auipc	s2,0x0
 666:	24690913          	add	s2,s2,582 # 8a8 <malloc+0xec>
        while(*s != 0){
 66a:	02800593          	li	a1,40
 66e:	bff1                	j	64a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 670:	008b8913          	add	s2,s7,8
 674:	000bc583          	lbu	a1,0(s7)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	dc2080e7          	jalr	-574(ra) # 43c <putc>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	b5e1                	j	54e <vprintf+0x44>
        putc(fd, c);
 688:	02500593          	li	a1,37
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	dae080e7          	jalr	-594(ra) # 43c <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	bd5d                	j	54e <vprintf+0x44>
        putc(fd, '%');
 69a:	02500593          	li	a1,37
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	d9c080e7          	jalr	-612(ra) # 43c <putc>
        putc(fd, c);
 6a8:	85ca                	mv	a1,s2
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	d90080e7          	jalr	-624(ra) # 43c <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bd61                	j	54e <vprintf+0x44>
        s = va_arg(ap, char*);
 6b8:	8bce                	mv	s7,s3
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bd49                	j	54e <vprintf+0x44>
    }
  }
}
 6be:	60a6                	ld	ra,72(sp)
 6c0:	6406                	ld	s0,64(sp)
 6c2:	74e2                	ld	s1,56(sp)
 6c4:	7942                	ld	s2,48(sp)
 6c6:	79a2                	ld	s3,40(sp)
 6c8:	7a02                	ld	s4,32(sp)
 6ca:	6ae2                	ld	s5,24(sp)
 6cc:	6b42                	ld	s6,16(sp)
 6ce:	6ba2                	ld	s7,8(sp)
 6d0:	6c02                	ld	s8,0(sp)
 6d2:	6161                	add	sp,sp,80
 6d4:	8082                	ret

00000000000006d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d6:	715d                	add	sp,sp,-80
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	add	s0,sp,32
 6de:	e010                	sd	a2,0(s0)
 6e0:	e414                	sd	a3,8(s0)
 6e2:	e818                	sd	a4,16(s0)
 6e4:	ec1c                	sd	a5,24(s0)
 6e6:	03043023          	sd	a6,32(s0)
 6ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f2:	8622                	mv	a2,s0
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e16080e7          	jalr	-490(ra) # 50a <vprintf>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6161                	add	sp,sp,80
 702:	8082                	ret

0000000000000704 <printf>:

void
printf(const char *fmt, ...)
{
 704:	711d                	add	sp,sp,-96
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	add	s0,sp,32
 70c:	e40c                	sd	a1,8(s0)
 70e:	e810                	sd	a2,16(s0)
 710:	ec14                	sd	a3,24(s0)
 712:	f018                	sd	a4,32(s0)
 714:	f41c                	sd	a5,40(s0)
 716:	03043823          	sd	a6,48(s0)
 71a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	00840613          	add	a2,s0,8
 722:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 726:	85aa                	mv	a1,a0
 728:	4505                	li	a0,1
 72a:	00000097          	auipc	ra,0x0
 72e:	de0080e7          	jalr	-544(ra) # 50a <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6125                	add	sp,sp,96
 738:	8082                	ret

000000000000073a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73a:	1141                	add	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	00000797          	auipc	a5,0x0
 748:	1dc7b783          	ld	a5,476(a5) # 920 <freep>
 74c:	a02d                	j	776 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74e:	4618                	lw	a4,8(a2)
 750:	9f2d                	addw	a4,a4,a1
 752:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	6398                	ld	a4,0(a5)
 758:	6310                	ld	a2,0(a4)
 75a:	a83d                	j	798 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75c:	ff852703          	lw	a4,-8(a0)
 760:	9f31                	addw	a4,a4,a2
 762:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 764:	ff053683          	ld	a3,-16(a0)
 768:	a091                	j	7ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x3a>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x4a>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x30>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	sll	a6,a1,0x20
 78e:	01c85713          	srl	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	fae60de3          	beq	a2,a4,74e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	sll	a1,a2,0x20
 7a2:	01c5d713          	srl	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	fae68ae3          	beq	a3,a4,75c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00000717          	auipc	a4,0x0
 7b2:	16f73923          	sd	a5,370(a4) # 920 <freep>
}
 7b6:	6422                	ld	s0,8(sp)
 7b8:	0141                	add	sp,sp,16
 7ba:	8082                	ret

00000000000007bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7bc:	7139                	add	sp,sp,-64
 7be:	fc06                	sd	ra,56(sp)
 7c0:	f822                	sd	s0,48(sp)
 7c2:	f426                	sd	s1,40(sp)
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	ec4e                	sd	s3,24(sp)
 7c8:	e852                	sd	s4,16(sp)
 7ca:	e456                	sd	s5,8(sp)
 7cc:	e05a                	sd	s6,0(sp)
 7ce:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d0:	02051493          	sll	s1,a0,0x20
 7d4:	9081                	srl	s1,s1,0x20
 7d6:	04bd                	add	s1,s1,15
 7d8:	8091                	srl	s1,s1,0x4
 7da:	0014899b          	addw	s3,s1,1
 7de:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7e0:	00000517          	auipc	a0,0x0
 7e4:	14053503          	ld	a0,320(a0) # 920 <freep>
 7e8:	c515                	beqz	a0,814 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	02977f63          	bgeu	a4,s1,82c <malloc+0x70>
  if(nu < 4096)
 7f2:	8a4e                	mv	s4,s3
 7f4:	0009871b          	sext.w	a4,s3
 7f8:	6685                	lui	a3,0x1
 7fa:	00d77363          	bgeu	a4,a3,800 <malloc+0x44>
 7fe:	6a05                	lui	s4,0x1
 800:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 804:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 808:	00000917          	auipc	s2,0x0
 80c:	11890913          	add	s2,s2,280 # 920 <freep>
  if(p == (char*)-1)
 810:	5afd                	li	s5,-1
 812:	a895                	j	886 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 814:	00000797          	auipc	a5,0x0
 818:	11478793          	add	a5,a5,276 # 928 <base>
 81c:	00000717          	auipc	a4,0x0
 820:	10f73223          	sd	a5,260(a4) # 920 <freep>
 824:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 826:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82a:	b7e1                	j	7f2 <malloc+0x36>
      if(p->s.size == nunits)
 82c:	02e48c63          	beq	s1,a4,864 <malloc+0xa8>
        p->s.size -= nunits;
 830:	4137073b          	subw	a4,a4,s3
 834:	c798                	sw	a4,8(a5)
        p += p->s.size;
 836:	02071693          	sll	a3,a4,0x20
 83a:	01c6d713          	srl	a4,a3,0x1c
 83e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 840:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 844:	00000717          	auipc	a4,0x0
 848:	0ca73e23          	sd	a0,220(a4) # 920 <freep>
      return (void*)(p + 1);
 84c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 850:	70e2                	ld	ra,56(sp)
 852:	7442                	ld	s0,48(sp)
 854:	74a2                	ld	s1,40(sp)
 856:	7902                	ld	s2,32(sp)
 858:	69e2                	ld	s3,24(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
 860:	6121                	add	sp,sp,64
 862:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 864:	6398                	ld	a4,0(a5)
 866:	e118                	sd	a4,0(a0)
 868:	bff1                	j	844 <malloc+0x88>
  hp->s.size = nu;
 86a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86e:	0541                	add	a0,a0,16
 870:	00000097          	auipc	ra,0x0
 874:	eca080e7          	jalr	-310(ra) # 73a <free>
  return freep;
 878:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87c:	d971                	beqz	a0,850 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	fa9775e3          	bgeu	a4,s1,82c <malloc+0x70>
    if(p == freep)
 886:	00093703          	ld	a4,0(s2)
 88a:	853e                	mv	a0,a5
 88c:	fef719e3          	bne	a4,a5,87e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 890:	8552                	mv	a0,s4
 892:	00000097          	auipc	ra,0x0
 896:	b92080e7          	jalr	-1134(ra) # 424 <sbrk>
  if(p == (char*)-1)
 89a:	fd5518e3          	bne	a0,s5,86a <malloc+0xae>
        return 0;
 89e:	4501                	li	a0,0
 8a0:	bf45                	j	850 <malloc+0x94>
