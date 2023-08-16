
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <func>:
#include "kernel/types.h"
#include "user/user.h"

void func(int *input, int num){
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	add	s0,sp,64
   e:	892a                	mv	s2,a0
	if(num == 1){
  10:	4785                	li	a5,1
  12:	06f58663          	beq	a1,a5,7e <func+0x7e>
  16:	84ae                	mv	s1,a1
		printf("prime %d\n", *input);
		return;
	}
	int p[2],i;
	int prime = *input;
  18:	00052983          	lw	s3,0(a0)
	int temp;
	printf("prime %d\n", prime);
  1c:	85ce                	mv	a1,s3
  1e:	00001517          	auipc	a0,0x1
  22:	89a50513          	add	a0,a0,-1894 # 8b8 <malloc+0xe8>
  26:	00000097          	auipc	ra,0x0
  2a:	6f2080e7          	jalr	1778(ra) # 718 <printf>
	pipe(p);
  2e:	fc840513          	add	a0,s0,-56
  32:	00000097          	auipc	ra,0x0
  36:	38e080e7          	jalr	910(ra) # 3c0 <pipe>
    if(fork() == 0){
  3a:	00000097          	auipc	ra,0x0
  3e:	36e080e7          	jalr	878(ra) # 3a8 <fork>
  42:	c921                	beqz	a0,92 <func+0x92>
            temp = *(input + i);
			write(p[1], (char *)(&temp), 4);
		}
        exit(0);
    }
	close(p[1]);
  44:	fcc42503          	lw	a0,-52(s0)
  48:	00000097          	auipc	ra,0x0
  4c:	390080e7          	jalr	912(ra) # 3d8 <close>
	if(fork() == 0){
  50:	00000097          	auipc	ra,0x0
  54:	358080e7          	jalr	856(ra) # 3a8 <fork>
  58:	84aa                	mv	s1,a0
  5a:	c535                	beqz	a0,c6 <func+0xc6>
			}
		}
		func(input - counter, counter);
		exit(0);
    }
	wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	35a080e7          	jalr	858(ra) # 3b8 <wait>
	wait(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	350080e7          	jalr	848(ra) # 3b8 <wait>
}
  70:	70e2                	ld	ra,56(sp)
  72:	7442                	ld	s0,48(sp)
  74:	74a2                	ld	s1,40(sp)
  76:	7902                	ld	s2,32(sp)
  78:	69e2                	ld	s3,24(sp)
  7a:	6121                	add	sp,sp,64
  7c:	8082                	ret
		printf("prime %d\n", *input);
  7e:	410c                	lw	a1,0(a0)
  80:	00001517          	auipc	a0,0x1
  84:	83850513          	add	a0,a0,-1992 # 8b8 <malloc+0xe8>
  88:	00000097          	auipc	ra,0x0
  8c:	690080e7          	jalr	1680(ra) # 718 <printf>
		return;
  90:	b7c5                	j	70 <func+0x70>
        for(i = 0; i < num; i++){
  92:	02905563          	blez	s1,bc <func+0xbc>
  96:	89ca                	mv	s3,s2
  98:	048a                	sll	s1,s1,0x2
  9a:	94ca                	add	s1,s1,s2
            temp = *(input + i);
  9c:	0009a783          	lw	a5,0(s3)
  a0:	fcf42223          	sw	a5,-60(s0)
			write(p[1], (char *)(&temp), 4);
  a4:	4611                	li	a2,4
  a6:	fc440593          	add	a1,s0,-60
  aa:	fcc42503          	lw	a0,-52(s0)
  ae:	00000097          	auipc	ra,0x0
  b2:	322080e7          	jalr	802(ra) # 3d0 <write>
        for(i = 0; i < num; i++){
  b6:	0991                	add	s3,s3,4
  b8:	fe9992e3          	bne	s3,s1,9c <func+0x9c>
        exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	2f2080e7          	jalr	754(ra) # 3b0 <exit>
		while(read(p[0], buffer, 4) != 0){
  c6:	4611                	li	a2,4
  c8:	fc040593          	add	a1,s0,-64
  cc:	fc842503          	lw	a0,-56(s0)
  d0:	00000097          	auipc	ra,0x0
  d4:	2f8080e7          	jalr	760(ra) # 3c8 <read>
  d8:	cd09                	beqz	a0,f2 <func+0xf2>
			temp = *((int *)buffer);
  da:	fc042783          	lw	a5,-64(s0)
  de:	fcf42223          	sw	a5,-60(s0)
			if(temp % prime != 0){
  e2:	0337e73b          	remw	a4,a5,s3
  e6:	d365                	beqz	a4,c6 <func+0xc6>
				*input = temp;
  e8:	00f92023          	sw	a5,0(s2)
				input += 1;
  ec:	0911                	add	s2,s2,4
				counter++;
  ee:	2485                	addw	s1,s1,1
  f0:	bfd9                	j	c6 <func+0xc6>
		func(input - counter, counter);
  f2:	00249513          	sll	a0,s1,0x2
  f6:	85a6                	mv	a1,s1
  f8:	40a90533          	sub	a0,s2,a0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <func>
		exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2aa080e7          	jalr	682(ra) # 3b0 <exit>

000000000000010e <main>:

int main(){
 10e:	7135                	add	sp,sp,-160
 110:	ed06                	sd	ra,152(sp)
 112:	e922                	sd	s0,144(sp)
 114:	1100                	add	s0,sp,160
    int input[34];
	int i = 0;
	for(; i < 34; i++){
 116:	f6840793          	add	a5,s0,-152
 11a:	ff040693          	add	a3,s0,-16
int main(){
 11e:	4709                	li	a4,2
		input[i] = i+2;
 120:	c398                	sw	a4,0(a5)
	for(; i < 34; i++){
 122:	2705                	addw	a4,a4,1
 124:	0791                	add	a5,a5,4
 126:	fed79de3          	bne	a5,a3,120 <main+0x12>
	}
	func(input, 34);
 12a:	02200593          	li	a1,34
 12e:	f6840513          	add	a0,s0,-152
 132:	00000097          	auipc	ra,0x0
 136:	ece080e7          	jalr	-306(ra) # 0 <func>
    exit(0);
 13a:	4501                	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	274080e7          	jalr	628(ra) # 3b0 <exit>

0000000000000144 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 144:	1141                	add	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	87aa                	mv	a5,a0
 14c:	0585                	add	a1,a1,1
 14e:	0785                	add	a5,a5,1
 150:	fff5c703          	lbu	a4,-1(a1)
 154:	fee78fa3          	sb	a4,-1(a5)
 158:	fb75                	bnez	a4,14c <strcpy+0x8>
    ;
  return os;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	add	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	1141                	add	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb91                	beqz	a5,17e <strcmp+0x1e>
 16c:	0005c703          	lbu	a4,0(a1)
 170:	00f71763          	bne	a4,a5,17e <strcmp+0x1e>
    p++, q++;
 174:	0505                	add	a0,a0,1
 176:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbe5                	bnez	a5,16c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17e:	0005c503          	lbu	a0,0(a1)
}
 182:	40a7853b          	subw	a0,a5,a0
 186:	6422                	ld	s0,8(sp)
 188:	0141                	add	sp,sp,16
 18a:	8082                	ret

000000000000018c <strlen>:

unsigned int
strlen(const char *s)
{
 18c:	1141                	add	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cf91                	beqz	a5,1b2 <strlen+0x26>
 198:	0505                	add	a0,a0,1
 19a:	87aa                	mv	a5,a0
 19c:	86be                	mv	a3,a5
 19e:	0785                	add	a5,a5,1
 1a0:	fff7c703          	lbu	a4,-1(a5)
 1a4:	ff65                	bnez	a4,19c <strlen+0x10>
 1a6:	40a6853b          	subw	a0,a3,a0
 1aa:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	add	sp,sp,16
 1b0:	8082                	ret
  for(n = 0; s[n]; n++)
 1b2:	4501                	li	a0,0
 1b4:	bfe5                	j	1ac <strlen+0x20>

00000000000001b6 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
 1b6:	1141                	add	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1c>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	sll	a2,a2,0x20
 1c2:	9201                	srl	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	add	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x12>
  }
  return dst;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	add	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	1141                	add	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	add	s0,sp,16
  for(; *s; s++)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb99                	beqz	a5,1f8 <strchr+0x20>
    if(*s == c)
 1e4:	00f58763          	beq	a1,a5,1f2 <strchr+0x1a>
  for(; *s; s++)
 1e8:	0505                	add	a0,a0,1
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	fbfd                	bnez	a5,1e4 <strchr+0xc>
      return (char*)s;
  return 0;
 1f0:	4501                	li	a0,0
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	add	sp,sp,16
 1f6:	8082                	ret
  return 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strchr+0x1a>

00000000000001fc <gets>:

char*
gets(char *buf, int max)
{
 1fc:	711d                	add	sp,sp,-96
 1fe:	ec86                	sd	ra,88(sp)
 200:	e8a2                	sd	s0,80(sp)
 202:	e4a6                	sd	s1,72(sp)
 204:	e0ca                	sd	s2,64(sp)
 206:	fc4e                	sd	s3,56(sp)
 208:	f852                	sd	s4,48(sp)
 20a:	f456                	sd	s5,40(sp)
 20c:	f05a                	sd	s6,32(sp)
 20e:	ec5e                	sd	s7,24(sp)
 210:	1080                	add	s0,sp,96
 212:	8baa                	mv	s7,a0
 214:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	892a                	mv	s2,a0
 218:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21a:	4aa9                	li	s5,10
 21c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21e:	89a6                	mv	s3,s1
 220:	2485                	addw	s1,s1,1
 222:	0344d863          	bge	s1,s4,252 <gets+0x56>
    cc = read(0, &c, 1);
 226:	4605                	li	a2,1
 228:	faf40593          	add	a1,s0,-81
 22c:	4501                	li	a0,0
 22e:	00000097          	auipc	ra,0x0
 232:	19a080e7          	jalr	410(ra) # 3c8 <read>
    if(cc < 1)
 236:	00a05e63          	blez	a0,252 <gets+0x56>
    buf[i++] = c;
 23a:	faf44783          	lbu	a5,-81(s0)
 23e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 242:	01578763          	beq	a5,s5,250 <gets+0x54>
 246:	0905                	add	s2,s2,1
 248:	fd679be3          	bne	a5,s6,21e <gets+0x22>
  for(i=0; i+1 < max; ){
 24c:	89a6                	mv	s3,s1
 24e:	a011                	j	252 <gets+0x56>
 250:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 252:	99de                	add	s3,s3,s7
 254:	00098023          	sb	zero,0(s3)
  return buf;
}
 258:	855e                	mv	a0,s7
 25a:	60e6                	ld	ra,88(sp)
 25c:	6446                	ld	s0,80(sp)
 25e:	64a6                	ld	s1,72(sp)
 260:	6906                	ld	s2,64(sp)
 262:	79e2                	ld	s3,56(sp)
 264:	7a42                	ld	s4,48(sp)
 266:	7aa2                	ld	s5,40(sp)
 268:	7b02                	ld	s6,32(sp)
 26a:	6be2                	ld	s7,24(sp)
 26c:	6125                	add	sp,sp,96
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	add	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
 27a:	1000                	add	s0,sp,32
 27c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	4581                	li	a1,0
 280:	00000097          	auipc	ra,0x0
 284:	170080e7          	jalr	368(ra) # 3f0 <open>
  if(fd < 0)
 288:	02054563          	bltz	a0,2b2 <stat+0x42>
 28c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28e:	85ca                	mv	a1,s2
 290:	00000097          	auipc	ra,0x0
 294:	178080e7          	jalr	376(ra) # 408 <fstat>
 298:	892a                	mv	s2,a0
  close(fd);
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	13c080e7          	jalr	316(ra) # 3d8 <close>
  return r;
}
 2a4:	854a                	mv	a0,s2
 2a6:	60e2                	ld	ra,24(sp)
 2a8:	6442                	ld	s0,16(sp)
 2aa:	64a2                	ld	s1,8(sp)
 2ac:	6902                	ld	s2,0(sp)
 2ae:	6105                	add	sp,sp,32
 2b0:	8082                	ret
    return -1;
 2b2:	597d                	li	s2,-1
 2b4:	bfc5                	j	2a4 <stat+0x34>

00000000000002b6 <atoi>:

int
atoi(const char *s)
{
 2b6:	1141                	add	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bc:	00054683          	lbu	a3,0(a0)
 2c0:	fd06879b          	addw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	4625                	li	a2,9
 2ca:	02f66863          	bltu	a2,a5,2fa <atoi+0x44>
 2ce:	872a                	mv	a4,a0
  n = 0;
 2d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d2:	0705                	add	a4,a4,1
 2d4:	0025179b          	sllw	a5,a0,0x2
 2d8:	9fa9                	addw	a5,a5,a0
 2da:	0017979b          	sllw	a5,a5,0x1
 2de:	9fb5                	addw	a5,a5,a3
 2e0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e4:	00074683          	lbu	a3,0(a4)
 2e8:	fd06879b          	addw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	fef671e3          	bgeu	a2,a5,2d2 <atoi+0x1c>
  return n;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	add	sp,sp,16
 2f8:	8082                	ret
  n = 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <atoi+0x3e>

00000000000002fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fe:	1141                	add	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 304:	02b57463          	bgeu	a0,a1,32c <memmove+0x2e>
    while(n-- > 0)
 308:	00c05f63          	blez	a2,326 <memmove+0x28>
 30c:	1602                	sll	a2,a2,0x20
 30e:	9201                	srl	a2,a2,0x20
 310:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 314:	872a                	mv	a4,a0
      *dst++ = *src++;
 316:	0585                	add	a1,a1,1
 318:	0705                	add	a4,a4,1
 31a:	fff5c683          	lbu	a3,-1(a1)
 31e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	add	sp,sp,16
 32a:	8082                	ret
    dst += n;
 32c:	00c50733          	add	a4,a0,a2
    src += n;
 330:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 332:	fec05ae3          	blez	a2,326 <memmove+0x28>
 336:	fff6079b          	addw	a5,a2,-1
 33a:	1782                	sll	a5,a5,0x20
 33c:	9381                	srl	a5,a5,0x20
 33e:	fff7c793          	not	a5,a5
 342:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 344:	15fd                	add	a1,a1,-1
 346:	177d                	add	a4,a4,-1
 348:	0005c683          	lbu	a3,0(a1)
 34c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 350:	fee79ae3          	bne	a5,a4,344 <memmove+0x46>
 354:	bfc9                	j	326 <memmove+0x28>

0000000000000356 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
 356:	1141                	add	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35c:	ca05                	beqz	a2,38c <memcmp+0x36>
 35e:	fff6069b          	addw	a3,a2,-1
 362:	1682                	sll	a3,a3,0x20
 364:	9281                	srl	a3,a3,0x20
 366:	0685                	add	a3,a3,1
 368:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	add	a0,a0,1
    p2++;
 378:	0585                	add	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x14>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x30>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	add	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <memcmp+0x30>

0000000000000390 <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
 390:	1141                	add	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 398:	00000097          	auipc	ra,0x0
 39c:	f66080e7          	jalr	-154(ra) # 2fe <memmove>
}
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	add	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a8:	4885                	li	a7,1
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b0:	4889                	li	a7,2
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b8:	488d                	li	a7,3
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c0:	4891                	li	a7,4
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <read>:
.global read
read:
 li a7, SYS_read
 3c8:	4895                	li	a7,5
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <write>:
.global write
write:
 li a7, SYS_write
 3d0:	48c1                	li	a7,16
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <close>:
.global close
close:
 li a7, SYS_close
 3d8:	48d5                	li	a7,21
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e0:	4899                	li	a7,6
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e8:	489d                	li	a7,7
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <open>:
.global open
open:
 li a7, SYS_open
 3f0:	48bd                	li	a7,15
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f8:	48c5                	li	a7,17
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 400:	48c9                	li	a7,18
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 408:	48a1                	li	a7,8
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <link>:
.global link
link:
 li a7, SYS_link
 410:	48cd                	li	a7,19
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 418:	48d1                	li	a7,20
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 420:	48a5                	li	a7,9
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <dup>:
.global dup
dup:
 li a7, SYS_dup
 428:	48a9                	li	a7,10
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 430:	48ad                	li	a7,11
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 438:	48b1                	li	a7,12
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 440:	48b5                	li	a7,13
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 448:	48b9                	li	a7,14
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	add	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	add	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	add	a1,s0,-17
 462:	00000097          	auipc	ra,0x0
 466:	f6e080e7          	jalr	-146(ra) # 3d0 <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	add	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 472:	7139                	add	sp,sp,-64
 474:	fc06                	sd	ra,56(sp)
 476:	f822                	sd	s0,48(sp)
 478:	f426                	sd	s1,40(sp)
 47a:	f04a                	sd	s2,32(sp)
 47c:	ec4e                	sd	s3,24(sp)
 47e:	0080                	add	s0,sp,64
 480:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 482:	c299                	beqz	a3,488 <printint+0x16>
 484:	0805c963          	bltz	a1,516 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 488:	2581                	sext.w	a1,a1
  neg = 0;
 48a:	4881                	li	a7,0
 48c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 490:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 492:	2601                	sext.w	a2,a2
 494:	00000517          	auipc	a0,0x0
 498:	49450513          	add	a0,a0,1172 # 928 <digits>
 49c:	883a                	mv	a6,a4
 49e:	2705                	addw	a4,a4,1
 4a0:	02c5f7bb          	remuw	a5,a1,a2
 4a4:	1782                	sll	a5,a5,0x20
 4a6:	9381                	srl	a5,a5,0x20
 4a8:	97aa                	add	a5,a5,a0
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b2:	0005879b          	sext.w	a5,a1
 4b6:	02c5d5bb          	divuw	a1,a1,a2
 4ba:	0685                	add	a3,a3,1
 4bc:	fec7f0e3          	bgeu	a5,a2,49c <printint+0x2a>
  if(neg)
 4c0:	00088c63          	beqz	a7,4d8 <printint+0x66>
    buf[i++] = '-';
 4c4:	fd070793          	add	a5,a4,-48
 4c8:	00878733          	add	a4,a5,s0
 4cc:	02d00793          	li	a5,45
 4d0:	fef70823          	sb	a5,-16(a4)
 4d4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4d8:	02e05863          	blez	a4,508 <printint+0x96>
 4dc:	fc040793          	add	a5,s0,-64
 4e0:	00e78933          	add	s2,a5,a4
 4e4:	fff78993          	add	s3,a5,-1
 4e8:	99ba                	add	s3,s3,a4
 4ea:	377d                	addw	a4,a4,-1
 4ec:	1702                	sll	a4,a4,0x20
 4ee:	9301                	srl	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	fff94583          	lbu	a1,-1(s2)
 4f8:	8526                	mv	a0,s1
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f56080e7          	jalr	-170(ra) # 450 <putc>
  while(--i >= 0)
 502:	197d                	add	s2,s2,-1
 504:	ff3918e3          	bne	s2,s3,4f4 <printint+0x82>
}
 508:	70e2                	ld	ra,56(sp)
 50a:	7442                	ld	s0,48(sp)
 50c:	74a2                	ld	s1,40(sp)
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
 512:	6121                	add	sp,sp,64
 514:	8082                	ret
    x = -xx;
 516:	40b005bb          	negw	a1,a1
    neg = 1;
 51a:	4885                	li	a7,1
    x = -xx;
 51c:	bf85                	j	48c <printint+0x1a>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	715d                	add	sp,sp,-80
 520:	e486                	sd	ra,72(sp)
 522:	e0a2                	sd	s0,64(sp)
 524:	fc26                	sd	s1,56(sp)
 526:	f84a                	sd	s2,48(sp)
 528:	f44e                	sd	s3,40(sp)
 52a:	f052                	sd	s4,32(sp)
 52c:	ec56                	sd	s5,24(sp)
 52e:	e85a                	sd	s6,16(sp)
 530:	e45e                	sd	s7,8(sp)
 532:	e062                	sd	s8,0(sp)
 534:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 536:	0005c903          	lbu	s2,0(a1)
 53a:	18090c63          	beqz	s2,6d2 <vprintf+0x1b4>
 53e:	8aaa                	mv	s5,a0
 540:	8bb2                	mv	s7,a2
 542:	00158493          	add	s1,a1,1
  state = 0;
 546:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 548:	02500a13          	li	s4,37
 54c:	4b55                	li	s6,21
 54e:	a839                	j	56c <vprintf+0x4e>
        putc(fd, c);
 550:	85ca                	mv	a1,s2
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	efc080e7          	jalr	-260(ra) # 450 <putc>
 55c:	a019                	j	562 <vprintf+0x44>
    } else if(state == '%'){
 55e:	01498d63          	beq	s3,s4,578 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 562:	0485                	add	s1,s1,1
 564:	fff4c903          	lbu	s2,-1(s1)
 568:	16090563          	beqz	s2,6d2 <vprintf+0x1b4>
    if(state == 0){
 56c:	fe0999e3          	bnez	s3,55e <vprintf+0x40>
      if(c == '%'){
 570:	ff4910e3          	bne	s2,s4,550 <vprintf+0x32>
        state = '%';
 574:	89d2                	mv	s3,s4
 576:	b7f5                	j	562 <vprintf+0x44>
      if(c == 'd'){
 578:	13490263          	beq	s2,s4,69c <vprintf+0x17e>
 57c:	f9d9079b          	addw	a5,s2,-99
 580:	0ff7f793          	zext.b	a5,a5
 584:	12fb6563          	bltu	s6,a5,6ae <vprintf+0x190>
 588:	f9d9079b          	addw	a5,s2,-99
 58c:	0ff7f713          	zext.b	a4,a5
 590:	10eb6f63          	bltu	s6,a4,6ae <vprintf+0x190>
 594:	00271793          	sll	a5,a4,0x2
 598:	00000717          	auipc	a4,0x0
 59c:	33870713          	add	a4,a4,824 # 8d0 <malloc+0x100>
 5a0:	97ba                	add	a5,a5,a4
 5a2:	439c                	lw	a5,0(a5)
 5a4:	97ba                	add	a5,a5,a4
 5a6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a8:	008b8913          	add	s2,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	ebc080e7          	jalr	-324(ra) # 472 <printint>
 5be:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b745                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c4:	008b8913          	add	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	ea0080e7          	jalr	-352(ra) # 472 <printint>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b751                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5e0:	008b8913          	add	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e84080e7          	jalr	-380(ra) # 472 <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b7a5                	j	562 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5fc:	008b8c13          	add	s8,s7,8
 600:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 604:	03000593          	li	a1,48
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e46080e7          	jalr	-442(ra) # 450 <putc>
  putc(fd, 'x');
 612:	07800593          	li	a1,120
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e38080e7          	jalr	-456(ra) # 450 <putc>
 620:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	306b8b93          	add	s7,s7,774 # 928 <digits>
 62a:	03c9d793          	srl	a5,s3,0x3c
 62e:	97de                	add	a5,a5,s7
 630:	0007c583          	lbu	a1,0(a5)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e1a080e7          	jalr	-486(ra) # 450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63e:	0992                	sll	s3,s3,0x4
 640:	397d                	addw	s2,s2,-1
 642:	fe0914e3          	bnez	s2,62a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 646:	8be2                	mv	s7,s8
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf21                	j	562 <vprintf+0x44>
        s = va_arg(ap, char*);
 64c:	008b8993          	add	s3,s7,8
 650:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 654:	02090163          	beqz	s2,676 <vprintf+0x158>
        while(*s != 0){
 658:	00094583          	lbu	a1,0(s2)
 65c:	c9a5                	beqz	a1,6cc <vprintf+0x1ae>
          putc(fd, *s);
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	df0080e7          	jalr	-528(ra) # 450 <putc>
          s++;
 668:	0905                	add	s2,s2,1
        while(*s != 0){
 66a:	00094583          	lbu	a1,0(s2)
 66e:	f9e5                	bnez	a1,65e <vprintf+0x140>
        s = va_arg(ap, char*);
 670:	8bce                	mv	s7,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b5fd                	j	562 <vprintf+0x44>
          s = "(null)";
 676:	00000917          	auipc	s2,0x0
 67a:	25290913          	add	s2,s2,594 # 8c8 <malloc+0xf8>
        while(*s != 0){
 67e:	02800593          	li	a1,40
 682:	bff1                	j	65e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 684:	008b8913          	add	s2,s7,8
 688:	000bc583          	lbu	a1,0(s7)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	dc2080e7          	jalr	-574(ra) # 450 <putc>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b5e1                	j	562 <vprintf+0x44>
        putc(fd, c);
 69c:	02500593          	li	a1,37
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	dae080e7          	jalr	-594(ra) # 450 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd5d                	j	562 <vprintf+0x44>
        putc(fd, '%');
 6ae:	02500593          	li	a1,37
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	d9c080e7          	jalr	-612(ra) # 450 <putc>
        putc(fd, c);
 6bc:	85ca                	mv	a1,s2
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	d90080e7          	jalr	-624(ra) # 450 <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd61                	j	562 <vprintf+0x44>
        s = va_arg(ap, char*);
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bd49                	j	562 <vprintf+0x44>
    }
  }
}
 6d2:	60a6                	ld	ra,72(sp)
 6d4:	6406                	ld	s0,64(sp)
 6d6:	74e2                	ld	s1,56(sp)
 6d8:	7942                	ld	s2,48(sp)
 6da:	79a2                	ld	s3,40(sp)
 6dc:	7a02                	ld	s4,32(sp)
 6de:	6ae2                	ld	s5,24(sp)
 6e0:	6b42                	ld	s6,16(sp)
 6e2:	6ba2                	ld	s7,8(sp)
 6e4:	6c02                	ld	s8,0(sp)
 6e6:	6161                	add	sp,sp,80
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	add	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	add	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	00000097          	auipc	ra,0x0
 70c:	e16080e7          	jalr	-490(ra) # 51e <vprintf>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6161                	add	sp,sp,80
 716:	8082                	ret

0000000000000718 <printf>:

void
printf(const char *fmt, ...)
{
 718:	711d                	add	sp,sp,-96
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	add	s0,sp,32
 720:	e40c                	sd	a1,8(s0)
 722:	e810                	sd	a2,16(s0)
 724:	ec14                	sd	a3,24(s0)
 726:	f018                	sd	a4,32(s0)
 728:	f41c                	sd	a5,40(s0)
 72a:	03043823          	sd	a6,48(s0)
 72e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	00840613          	add	a2,s0,8
 736:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73a:	85aa                	mv	a1,a0
 73c:	4505                	li	a0,1
 73e:	00000097          	auipc	ra,0x0
 742:	de0080e7          	jalr	-544(ra) # 51e <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6125                	add	sp,sp,96
 74c:	8082                	ret

000000000000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	1141                	add	sp,sp,-16
 750:	e422                	sd	s0,8(sp)
 752:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00000797          	auipc	a5,0x0
 75c:	1e87b783          	ld	a5,488(a5) # 940 <freep>
 760:	a02d                	j	78a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 762:	4618                	lw	a4,8(a2)
 764:	9f2d                	addw	a4,a4,a1
 766:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	6398                	ld	a4,0(a5)
 76c:	6310                	ld	a2,0(a4)
 76e:	a83d                	j	7ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9f31                	addw	a4,a4,a2
 776:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053683          	ld	a3,-16(a0)
 77c:	a091                	j	7c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x3a>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x4a>
{
 788:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x30>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059813          	sll	a6,a1,0x20
 7a2:	01c85713          	srl	a4,a6,0x1c
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60de3          	beq	a2,a4,762 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061593          	sll	a1,a2,0x20
 7b6:	01c5d713          	srl	a4,a1,0x1c
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae68ae3          	beq	a3,a4,770 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c2:	00000717          	auipc	a4,0x0
 7c6:	16f73f23          	sd	a5,382(a4) # 940 <freep>
}
 7ca:	6422                	ld	s0,8(sp)
 7cc:	0141                	add	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	7139                	add	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
 7e2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	02051493          	sll	s1,a0,0x20
 7e8:	9081                	srl	s1,s1,0x20
 7ea:	04bd                	add	s1,s1,15
 7ec:	8091                	srl	s1,s1,0x4
 7ee:	0014899b          	addw	s3,s1,1
 7f2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7f4:	00000517          	auipc	a0,0x0
 7f8:	14c53503          	ld	a0,332(a0) # 940 <freep>
 7fc:	c515                	beqz	a0,828 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 800:	4798                	lw	a4,8(a5)
 802:	02977f63          	bgeu	a4,s1,840 <malloc+0x70>
  if(nu < 4096)
 806:	8a4e                	mv	s4,s3
 808:	0009871b          	sext.w	a4,s3
 80c:	6685                	lui	a3,0x1
 80e:	00d77363          	bgeu	a4,a3,814 <malloc+0x44>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000917          	auipc	s2,0x0
 820:	12490913          	add	s2,s2,292 # 940 <freep>
  if(p == (char*)-1)
 824:	5afd                	li	s5,-1
 826:	a895                	j	89a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 828:	00000797          	auipc	a5,0x0
 82c:	12078793          	add	a5,a5,288 # 948 <base>
 830:	00000717          	auipc	a4,0x0
 834:	10f73823          	sd	a5,272(a4) # 940 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7e1                	j	806 <malloc+0x36>
      if(p->s.size == nunits)
 840:	02e48c63          	beq	s1,a4,878 <malloc+0xa8>
        p->s.size -= nunits;
 844:	4137073b          	subw	a4,a4,s3
 848:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84a:	02071693          	sll	a3,a4,0x20
 84e:	01c6d713          	srl	a4,a3,0x1c
 852:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 854:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 858:	00000717          	auipc	a4,0x0
 85c:	0ea73423          	sd	a0,232(a4) # 940 <freep>
      return (void*)(p + 1);
 860:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 864:	70e2                	ld	ra,56(sp)
 866:	7442                	ld	s0,48(sp)
 868:	74a2                	ld	s1,40(sp)
 86a:	7902                	ld	s2,32(sp)
 86c:	69e2                	ld	s3,24(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	6121                	add	sp,sp,64
 876:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 878:	6398                	ld	a4,0(a5)
 87a:	e118                	sd	a4,0(a0)
 87c:	bff1                	j	858 <malloc+0x88>
  hp->s.size = nu;
 87e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 882:	0541                	add	a0,a0,16
 884:	00000097          	auipc	ra,0x0
 888:	eca080e7          	jalr	-310(ra) # 74e <free>
  return freep;
 88c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 890:	d971                	beqz	a0,864 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	fa9775e3          	bgeu	a4,s1,840 <malloc+0x70>
    if(p == freep)
 89a:	00093703          	ld	a4,0(s2)
 89e:	853e                	mv	a0,a5
 8a0:	fef719e3          	bne	a4,a5,892 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b92080e7          	jalr	-1134(ra) # 438 <sbrk>
  if(p == (char*)-1)
 8ae:	fd5518e3          	bne	a0,s5,87e <malloc+0xae>
        return 0;
 8b2:	4501                	li	a0,0
 8b4:	bf45                	j	864 <malloc+0x94>
