
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include <kernel/types.h>
#include <user/user.h>

int main(){
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	add	s0,sp,48
    //pipe1(p1)：写端父进程，读端子进程
    //pipe2(p2)；写端子进程，读端父进程
    int p1[2],p2[2];
    //来回传输的字符数组：一个字节
    char buffer[] = {'X'};
   8:	05800793          	li	a5,88
   c:	fcf40c23          	sb	a5,-40(s0)
    //传输字符数组的长度
    long length = sizeof(buffer);
    pipe(p1); //父进程写，子进程读的pipe
  10:	fe840513          	add	a0,s0,-24
  14:	00000097          	auipc	ra,0x0
  18:	3e4080e7          	jalr	996(ra) # 3f8 <pipe>
    pipe(p2); //子进程写，父进程读的pipe
  1c:	fe040513          	add	a0,s0,-32
  20:	00000097          	auipc	ra,0x0
  24:	3d8080e7          	jalr	984(ra) # 3f8 <pipe>
    //子进程
    if(fork() == 0){
  28:	00000097          	auipc	ra,0x0
  2c:	3b8080e7          	jalr	952(ra) # 3e0 <fork>
  30:	e14d                	bnez	a0,d2 <main+0xd2>
        //关掉不用的p1[1]、p2[0]
        close(p1[1]);
  32:	fec42503          	lw	a0,-20(s0)
  36:	00000097          	auipc	ra,0x0
  3a:	3da080e7          	jalr	986(ra) # 410 <close>
        close(p2[0]);
  3e:	fe042503          	lw	a0,-32(s0)
  42:	00000097          	auipc	ra,0x0
  46:	3ce080e7          	jalr	974(ra) # 410 <close>
		//子进程从pipe1的读端，读取字符数组
		if(read(p1[0], buffer, length) != length){
  4a:	4605                	li	a2,1
  4c:	fd840593          	add	a1,s0,-40
  50:	fe842503          	lw	a0,-24(s0)
  54:	00000097          	auipc	ra,0x0
  58:	3ac080e7          	jalr	940(ra) # 400 <read>
  5c:	4785                	li	a5,1
  5e:	00f50f63          	beq	a0,a5,7c <main+0x7c>
			printf("a--->b read error!");
  62:	00001517          	auipc	a0,0x1
  66:	88e50513          	add	a0,a0,-1906 # 8f0 <malloc+0xe8>
  6a:	00000097          	auipc	ra,0x0
  6e:	6e6080e7          	jalr	1766(ra) # 750 <printf>
			exit(1);
  72:	4505                	li	a0,1
  74:	00000097          	auipc	ra,0x0
  78:	374080e7          	jalr	884(ra) # 3e8 <exit>
		}
		//打印读取到的字符数组
		printf("%d: received ping\n", getpid());
  7c:	00000097          	auipc	ra,0x0
  80:	3ec080e7          	jalr	1004(ra) # 468 <getpid>
  84:	85aa                	mv	a1,a0
  86:	00001517          	auipc	a0,0x1
  8a:	88250513          	add	a0,a0,-1918 # 908 <malloc+0x100>
  8e:	00000097          	auipc	ra,0x0
  92:	6c2080e7          	jalr	1730(ra) # 750 <printf>
		//子进程向pipe2的写端，写入字符数组
		if(write(p2[1], buffer, length) != length){
  96:	4605                	li	a2,1
  98:	fd840593          	add	a1,s0,-40
  9c:	fe442503          	lw	a0,-28(s0)
  a0:	00000097          	auipc	ra,0x0
  a4:	368080e7          	jalr	872(ra) # 408 <write>
  a8:	4785                	li	a5,1
  aa:	00f50f63          	beq	a0,a5,c8 <main+0xc8>
			printf("a<---b write error!");
  ae:	00001517          	auipc	a0,0x1
  b2:	87250513          	add	a0,a0,-1934 # 920 <malloc+0x118>
  b6:	00000097          	auipc	ra,0x0
  ba:	69a080e7          	jalr	1690(ra) # 750 <printf>
			exit(1);
  be:	4505                	li	a0,1
  c0:	00000097          	auipc	ra,0x0
  c4:	328080e7          	jalr	808(ra) # 3e8 <exit>
		}
        exit(0);
  c8:	4501                	li	a0,0
  ca:	00000097          	auipc	ra,0x0
  ce:	31e080e7          	jalr	798(ra) # 3e8 <exit>
    }
    //关掉不用的p1[0]、p2[1]
    close(p1[0]);
  d2:	fe842503          	lw	a0,-24(s0)
  d6:	00000097          	auipc	ra,0x0
  da:	33a080e7          	jalr	826(ra) # 410 <close>
    close(p2[1]);
  de:	fe442503          	lw	a0,-28(s0)
  e2:	00000097          	auipc	ra,0x0
  e6:	32e080e7          	jalr	814(ra) # 410 <close>
	//父进程向pipe1的写端，写入字符数组
	if(write(p1[1], buffer, length) != length){
  ea:	4605                	li	a2,1
  ec:	fd840593          	add	a1,s0,-40
  f0:	fec42503          	lw	a0,-20(s0)
  f4:	00000097          	auipc	ra,0x0
  f8:	314080e7          	jalr	788(ra) # 408 <write>
  fc:	4785                	li	a5,1
  fe:	00f50f63          	beq	a0,a5,11c <main+0x11c>
		printf("a--->b write error!");
 102:	00001517          	auipc	a0,0x1
 106:	83650513          	add	a0,a0,-1994 # 938 <malloc+0x130>
 10a:	00000097          	auipc	ra,0x0
 10e:	646080e7          	jalr	1606(ra) # 750 <printf>
		exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	2d4080e7          	jalr	724(ra) # 3e8 <exit>
	}
	//父进程从pipe2的读端，读取字符数组
	if(read(p2[0], buffer, length) != length){
 11c:	4605                	li	a2,1
 11e:	fd840593          	add	a1,s0,-40
 122:	fe042503          	lw	a0,-32(s0)
 126:	00000097          	auipc	ra,0x0
 12a:	2da080e7          	jalr	730(ra) # 400 <read>
 12e:	4785                	li	a5,1
 130:	00f50f63          	beq	a0,a5,14e <main+0x14e>
		printf("a<---b read error!");
 134:	00001517          	auipc	a0,0x1
 138:	81c50513          	add	a0,a0,-2020 # 950 <malloc+0x148>
 13c:	00000097          	auipc	ra,0x0
 140:	614080e7          	jalr	1556(ra) # 750 <printf>
		exit(1);
 144:	4505                	li	a0,1
 146:	00000097          	auipc	ra,0x0
 14a:	2a2080e7          	jalr	674(ra) # 3e8 <exit>
	}
	//打印读取的字符数组
	printf("%d: received pong\n", getpid());
 14e:	00000097          	auipc	ra,0x0
 152:	31a080e7          	jalr	794(ra) # 468 <getpid>
 156:	85aa                	mv	a1,a0
 158:	00001517          	auipc	a0,0x1
 15c:	81050513          	add	a0,a0,-2032 # 968 <malloc+0x160>
 160:	00000097          	auipc	ra,0x0
 164:	5f0080e7          	jalr	1520(ra) # 750 <printf>
    //等待进程子退出
    wait(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	286080e7          	jalr	646(ra) # 3f0 <wait>
	exit(0);
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	274080e7          	jalr	628(ra) # 3e8 <exit>

000000000000017c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 17c:	1141                	add	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 182:	87aa                	mv	a5,a0
 184:	0585                	add	a1,a1,1
 186:	0785                	add	a5,a5,1
 188:	fff5c703          	lbu	a4,-1(a1)
 18c:	fee78fa3          	sb	a4,-1(a5)
 190:	fb75                	bnez	a4,184 <strcpy+0x8>
    ;
  return os;
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	add	sp,sp,16
 196:	8082                	ret

0000000000000198 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 198:	1141                	add	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	cb91                	beqz	a5,1b6 <strcmp+0x1e>
 1a4:	0005c703          	lbu	a4,0(a1)
 1a8:	00f71763          	bne	a4,a5,1b6 <strcmp+0x1e>
    p++, q++;
 1ac:	0505                	add	a0,a0,1
 1ae:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbe5                	bnez	a5,1a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b6:	0005c503          	lbu	a0,0(a1)
}
 1ba:	40a7853b          	subw	a0,a5,a0
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strlen>:

unsigned int
strlen(const char *s)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cf91                	beqz	a5,1ea <strlen+0x26>
 1d0:	0505                	add	a0,a0,1
 1d2:	87aa                	mv	a5,a0
 1d4:	86be                	mv	a3,a5
 1d6:	0785                	add	a5,a5,1
 1d8:	fff7c703          	lbu	a4,-1(a5)
 1dc:	ff65                	bnez	a4,1d4 <strlen+0x10>
 1de:	40a6853b          	subw	a0,a3,a0
 1e2:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	add	sp,sp,16
 1e8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <strlen+0x20>

00000000000001ee <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
 1ee:	1141                	add	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f4:	ca19                	beqz	a2,20a <memset+0x1c>
 1f6:	87aa                	mv	a5,a0
 1f8:	1602                	sll	a2,a2,0x20
 1fa:	9201                	srl	a2,a2,0x20
 1fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 200:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 204:	0785                	add	a5,a5,1
 206:	fee79de3          	bne	a5,a4,200 <memset+0x12>
  }
  return dst;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	add	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	1141                	add	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	add	s0,sp,16
  for(; *s; s++)
 216:	00054783          	lbu	a5,0(a0)
 21a:	cb99                	beqz	a5,230 <strchr+0x20>
    if(*s == c)
 21c:	00f58763          	beq	a1,a5,22a <strchr+0x1a>
  for(; *s; s++)
 220:	0505                	add	a0,a0,1
 222:	00054783          	lbu	a5,0(a0)
 226:	fbfd                	bnez	a5,21c <strchr+0xc>
      return (char*)s;
  return 0;
 228:	4501                	li	a0,0
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	add	sp,sp,16
 22e:	8082                	ret
  return 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <strchr+0x1a>

0000000000000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	711d                	add	sp,sp,-96
 236:	ec86                	sd	ra,88(sp)
 238:	e8a2                	sd	s0,80(sp)
 23a:	e4a6                	sd	s1,72(sp)
 23c:	e0ca                	sd	s2,64(sp)
 23e:	fc4e                	sd	s3,56(sp)
 240:	f852                	sd	s4,48(sp)
 242:	f456                	sd	s5,40(sp)
 244:	f05a                	sd	s6,32(sp)
 246:	ec5e                	sd	s7,24(sp)
 248:	1080                	add	s0,sp,96
 24a:	8baa                	mv	s7,a0
 24c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24e:	892a                	mv	s2,a0
 250:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 252:	4aa9                	li	s5,10
 254:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 256:	89a6                	mv	s3,s1
 258:	2485                	addw	s1,s1,1
 25a:	0344d863          	bge	s1,s4,28a <gets+0x56>
    cc = read(0, &c, 1);
 25e:	4605                	li	a2,1
 260:	faf40593          	add	a1,s0,-81
 264:	4501                	li	a0,0
 266:	00000097          	auipc	ra,0x0
 26a:	19a080e7          	jalr	410(ra) # 400 <read>
    if(cc < 1)
 26e:	00a05e63          	blez	a0,28a <gets+0x56>
    buf[i++] = c;
 272:	faf44783          	lbu	a5,-81(s0)
 276:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27a:	01578763          	beq	a5,s5,288 <gets+0x54>
 27e:	0905                	add	s2,s2,1
 280:	fd679be3          	bne	a5,s6,256 <gets+0x22>
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	a011                	j	28a <gets+0x56>
 288:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 28a:	99de                	add	s3,s3,s7
 28c:	00098023          	sb	zero,0(s3)
  return buf;
}
 290:	855e                	mv	a0,s7
 292:	60e6                	ld	ra,88(sp)
 294:	6446                	ld	s0,80(sp)
 296:	64a6                	ld	s1,72(sp)
 298:	6906                	ld	s2,64(sp)
 29a:	79e2                	ld	s3,56(sp)
 29c:	7a42                	ld	s4,48(sp)
 29e:	7aa2                	ld	s5,40(sp)
 2a0:	7b02                	ld	s6,32(sp)
 2a2:	6be2                	ld	s7,24(sp)
 2a4:	6125                	add	sp,sp,96
 2a6:	8082                	ret

00000000000002a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a8:	1101                	add	sp,sp,-32
 2aa:	ec06                	sd	ra,24(sp)
 2ac:	e822                	sd	s0,16(sp)
 2ae:	e426                	sd	s1,8(sp)
 2b0:	e04a                	sd	s2,0(sp)
 2b2:	1000                	add	s0,sp,32
 2b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b6:	4581                	li	a1,0
 2b8:	00000097          	auipc	ra,0x0
 2bc:	170080e7          	jalr	368(ra) # 428 <open>
  if(fd < 0)
 2c0:	02054563          	bltz	a0,2ea <stat+0x42>
 2c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c6:	85ca                	mv	a1,s2
 2c8:	00000097          	auipc	ra,0x0
 2cc:	178080e7          	jalr	376(ra) # 440 <fstat>
 2d0:	892a                	mv	s2,a0
  close(fd);
 2d2:	8526                	mv	a0,s1
 2d4:	00000097          	auipc	ra,0x0
 2d8:	13c080e7          	jalr	316(ra) # 410 <close>
  return r;
}
 2dc:	854a                	mv	a0,s2
 2de:	60e2                	ld	ra,24(sp)
 2e0:	6442                	ld	s0,16(sp)
 2e2:	64a2                	ld	s1,8(sp)
 2e4:	6902                	ld	s2,0(sp)
 2e6:	6105                	add	sp,sp,32
 2e8:	8082                	ret
    return -1;
 2ea:	597d                	li	s2,-1
 2ec:	bfc5                	j	2dc <stat+0x34>

00000000000002ee <atoi>:

int
atoi(const char *s)
{
 2ee:	1141                	add	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f4:	00054683          	lbu	a3,0(a0)
 2f8:	fd06879b          	addw	a5,a3,-48
 2fc:	0ff7f793          	zext.b	a5,a5
 300:	4625                	li	a2,9
 302:	02f66863          	bltu	a2,a5,332 <atoi+0x44>
 306:	872a                	mv	a4,a0
  n = 0;
 308:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 30a:	0705                	add	a4,a4,1
 30c:	0025179b          	sllw	a5,a0,0x2
 310:	9fa9                	addw	a5,a5,a0
 312:	0017979b          	sllw	a5,a5,0x1
 316:	9fb5                	addw	a5,a5,a3
 318:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31c:	00074683          	lbu	a3,0(a4)
 320:	fd06879b          	addw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	fef671e3          	bgeu	a2,a5,30a <atoi+0x1c>
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	add	sp,sp,16
 330:	8082                	ret
  n = 0;
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <atoi+0x3e>

0000000000000336 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 336:	1141                	add	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33c:	02b57463          	bgeu	a0,a1,364 <memmove+0x2e>
    while(n-- > 0)
 340:	00c05f63          	blez	a2,35e <memmove+0x28>
 344:	1602                	sll	a2,a2,0x20
 346:	9201                	srl	a2,a2,0x20
 348:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34c:	872a                	mv	a4,a0
      *dst++ = *src++;
 34e:	0585                	add	a1,a1,1
 350:	0705                	add	a4,a4,1
 352:	fff5c683          	lbu	a3,-1(a1)
 356:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35a:	fee79ae3          	bne	a5,a4,34e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	add	sp,sp,16
 362:	8082                	ret
    dst += n;
 364:	00c50733          	add	a4,a0,a2
    src += n;
 368:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 36a:	fec05ae3          	blez	a2,35e <memmove+0x28>
 36e:	fff6079b          	addw	a5,a2,-1
 372:	1782                	sll	a5,a5,0x20
 374:	9381                	srl	a5,a5,0x20
 376:	fff7c793          	not	a5,a5
 37a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37c:	15fd                	add	a1,a1,-1
 37e:	177d                	add	a4,a4,-1
 380:	0005c683          	lbu	a3,0(a1)
 384:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 388:	fee79ae3          	bne	a5,a4,37c <memmove+0x46>
 38c:	bfc9                	j	35e <memmove+0x28>

000000000000038e <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
 38e:	1141                	add	sp,sp,-16
 390:	e422                	sd	s0,8(sp)
 392:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 394:	ca05                	beqz	a2,3c4 <memcmp+0x36>
 396:	fff6069b          	addw	a3,a2,-1
 39a:	1682                	sll	a3,a3,0x20
 39c:	9281                	srl	a3,a3,0x20
 39e:	0685                	add	a3,a3,1
 3a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a2:	00054783          	lbu	a5,0(a0)
 3a6:	0005c703          	lbu	a4,0(a1)
 3aa:	00e79863          	bne	a5,a4,3ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ae:	0505                	add	a0,a0,1
    p2++;
 3b0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3b2:	fed518e3          	bne	a0,a3,3a2 <memcmp+0x14>
  }
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	a019                	j	3be <memcmp+0x30>
      return *p1 - *p2;
 3ba:	40e7853b          	subw	a0,a5,a4
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	add	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfe5                	j	3be <memcmp+0x30>

00000000000003c8 <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
 3c8:	1141                	add	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f66080e7          	jalr	-154(ra) # 336 <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	add	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <write>:
.global write
write:
 li a7, SYS_write
 408:	48c1                	li	a7,16
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <close>:
.global close
close:
 li a7, SYS_close
 410:	48d5                	li	a7,21
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <kill>:
.global kill
kill:
 li a7, SYS_kill
 418:	4899                	li	a7,6
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exec>:
.global exec
exec:
 li a7, SYS_exec
 420:	489d                	li	a7,7
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <open>:
.global open
open:
 li a7, SYS_open
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 430:	48c5                	li	a7,17
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 438:	48c9                	li	a7,18
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 440:	48a1                	li	a7,8
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <link>:
.global link
link:
 li a7, SYS_link
 448:	48cd                	li	a7,19
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 450:	48d1                	li	a7,20
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 458:	48a5                	li	a7,9
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <dup>:
.global dup
dup:
 li a7, SYS_dup
 460:	48a9                	li	a7,10
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 468:	48ad                	li	a7,11
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 470:	48b1                	li	a7,12
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 478:	48b5                	li	a7,13
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 480:	48b9                	li	a7,14
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 488:	1101                	add	sp,sp,-32
 48a:	ec06                	sd	ra,24(sp)
 48c:	e822                	sd	s0,16(sp)
 48e:	1000                	add	s0,sp,32
 490:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 494:	4605                	li	a2,1
 496:	fef40593          	add	a1,s0,-17
 49a:	00000097          	auipc	ra,0x0
 49e:	f6e080e7          	jalr	-146(ra) # 408 <write>
}
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6105                	add	sp,sp,32
 4a8:	8082                	ret

00000000000004aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4aa:	7139                	add	sp,sp,-64
 4ac:	fc06                	sd	ra,56(sp)
 4ae:	f822                	sd	s0,48(sp)
 4b0:	f426                	sd	s1,40(sp)
 4b2:	f04a                	sd	s2,32(sp)
 4b4:	ec4e                	sd	s3,24(sp)
 4b6:	0080                	add	s0,sp,64
 4b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ba:	c299                	beqz	a3,4c0 <printint+0x16>
 4bc:	0805c963          	bltz	a1,54e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c0:	2581                	sext.w	a1,a1
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	2601                	sext.w	a2,a2
 4cc:	00000517          	auipc	a0,0x0
 4d0:	51450513          	add	a0,a0,1300 # 9e0 <digits>
 4d4:	883a                	mv	a6,a4
 4d6:	2705                	addw	a4,a4,1
 4d8:	02c5f7bb          	remuw	a5,a1,a2
 4dc:	1782                	sll	a5,a5,0x20
 4de:	9381                	srl	a5,a5,0x20
 4e0:	97aa                	add	a5,a5,a0
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	0005879b          	sext.w	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	add	a3,a3,1
 4f4:	fec7f0e3          	bgeu	a5,a2,4d4 <printint+0x2a>
  if(neg)
 4f8:	00088c63          	beqz	a7,510 <printint+0x66>
    buf[i++] = '-';
 4fc:	fd070793          	add	a5,a4,-48
 500:	00878733          	add	a4,a5,s0
 504:	02d00793          	li	a5,45
 508:	fef70823          	sb	a5,-16(a4)
 50c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 510:	02e05863          	blez	a4,540 <printint+0x96>
 514:	fc040793          	add	a5,s0,-64
 518:	00e78933          	add	s2,a5,a4
 51c:	fff78993          	add	s3,a5,-1
 520:	99ba                	add	s3,s3,a4
 522:	377d                	addw	a4,a4,-1
 524:	1702                	sll	a4,a4,0x20
 526:	9301                	srl	a4,a4,0x20
 528:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52c:	fff94583          	lbu	a1,-1(s2)
 530:	8526                	mv	a0,s1
 532:	00000097          	auipc	ra,0x0
 536:	f56080e7          	jalr	-170(ra) # 488 <putc>
  while(--i >= 0)
 53a:	197d                	add	s2,s2,-1
 53c:	ff3918e3          	bne	s2,s3,52c <printint+0x82>
}
 540:	70e2                	ld	ra,56(sp)
 542:	7442                	ld	s0,48(sp)
 544:	74a2                	ld	s1,40(sp)
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
 54a:	6121                	add	sp,sp,64
 54c:	8082                	ret
    x = -xx;
 54e:	40b005bb          	negw	a1,a1
    neg = 1;
 552:	4885                	li	a7,1
    x = -xx;
 554:	bf85                	j	4c4 <printint+0x1a>

0000000000000556 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 556:	715d                	add	sp,sp,-80
 558:	e486                	sd	ra,72(sp)
 55a:	e0a2                	sd	s0,64(sp)
 55c:	fc26                	sd	s1,56(sp)
 55e:	f84a                	sd	s2,48(sp)
 560:	f44e                	sd	s3,40(sp)
 562:	f052                	sd	s4,32(sp)
 564:	ec56                	sd	s5,24(sp)
 566:	e85a                	sd	s6,16(sp)
 568:	e45e                	sd	s7,8(sp)
 56a:	e062                	sd	s8,0(sp)
 56c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 56e:	0005c903          	lbu	s2,0(a1)
 572:	18090c63          	beqz	s2,70a <vprintf+0x1b4>
 576:	8aaa                	mv	s5,a0
 578:	8bb2                	mv	s7,a2
 57a:	00158493          	add	s1,a1,1
  state = 0;
 57e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 580:	02500a13          	li	s4,37
 584:	4b55                	li	s6,21
 586:	a839                	j	5a4 <vprintf+0x4e>
        putc(fd, c);
 588:	85ca                	mv	a1,s2
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	efc080e7          	jalr	-260(ra) # 488 <putc>
 594:	a019                	j	59a <vprintf+0x44>
    } else if(state == '%'){
 596:	01498d63          	beq	s3,s4,5b0 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 59a:	0485                	add	s1,s1,1
 59c:	fff4c903          	lbu	s2,-1(s1)
 5a0:	16090563          	beqz	s2,70a <vprintf+0x1b4>
    if(state == 0){
 5a4:	fe0999e3          	bnez	s3,596 <vprintf+0x40>
      if(c == '%'){
 5a8:	ff4910e3          	bne	s2,s4,588 <vprintf+0x32>
        state = '%';
 5ac:	89d2                	mv	s3,s4
 5ae:	b7f5                	j	59a <vprintf+0x44>
      if(c == 'd'){
 5b0:	13490263          	beq	s2,s4,6d4 <vprintf+0x17e>
 5b4:	f9d9079b          	addw	a5,s2,-99
 5b8:	0ff7f793          	zext.b	a5,a5
 5bc:	12fb6563          	bltu	s6,a5,6e6 <vprintf+0x190>
 5c0:	f9d9079b          	addw	a5,s2,-99
 5c4:	0ff7f713          	zext.b	a4,a5
 5c8:	10eb6f63          	bltu	s6,a4,6e6 <vprintf+0x190>
 5cc:	00271793          	sll	a5,a4,0x2
 5d0:	00000717          	auipc	a4,0x0
 5d4:	3b870713          	add	a4,a4,952 # 988 <malloc+0x180>
 5d8:	97ba                	add	a5,a5,a4
 5da:	439c                	lw	a5,0(a5)
 5dc:	97ba                	add	a5,a5,a4
 5de:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5e0:	008b8913          	add	s2,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	ebc080e7          	jalr	-324(ra) # 4aa <printint>
 5f6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b745                	j	59a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	008b8913          	add	s2,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000ba583          	lw	a1,0(s7)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	ea0080e7          	jalr	-352(ra) # 4aa <printint>
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	b751                	j	59a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 618:	008b8913          	add	s2,s7,8
 61c:	4681                	li	a3,0
 61e:	4641                	li	a2,16
 620:	000ba583          	lw	a1,0(s7)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e84080e7          	jalr	-380(ra) # 4aa <printint>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	b7a5                	j	59a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 634:	008b8c13          	add	s8,s7,8
 638:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 63c:	03000593          	li	a1,48
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e46080e7          	jalr	-442(ra) # 488 <putc>
  putc(fd, 'x');
 64a:	07800593          	li	a1,120
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e38080e7          	jalr	-456(ra) # 488 <putc>
 658:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65a:	00000b97          	auipc	s7,0x0
 65e:	386b8b93          	add	s7,s7,902 # 9e0 <digits>
 662:	03c9d793          	srl	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e1a080e7          	jalr	-486(ra) # 488 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	sll	s3,s3,0x4
 678:	397d                	addw	s2,s2,-1
 67a:	fe0914e3          	bnez	s2,662 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 67e:	8be2                	mv	s7,s8
      state = 0;
 680:	4981                	li	s3,0
 682:	bf21                	j	59a <vprintf+0x44>
        s = va_arg(ap, char*);
 684:	008b8993          	add	s3,s7,8
 688:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 68c:	02090163          	beqz	s2,6ae <vprintf+0x158>
        while(*s != 0){
 690:	00094583          	lbu	a1,0(s2)
 694:	c9a5                	beqz	a1,704 <vprintf+0x1ae>
          putc(fd, *s);
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	df0080e7          	jalr	-528(ra) # 488 <putc>
          s++;
 6a0:	0905                	add	s2,s2,1
        while(*s != 0){
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9e5                	bnez	a1,696 <vprintf+0x140>
        s = va_arg(ap, char*);
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5fd                	j	59a <vprintf+0x44>
          s = "(null)";
 6ae:	00000917          	auipc	s2,0x0
 6b2:	2d290913          	add	s2,s2,722 # 980 <malloc+0x178>
        while(*s != 0){
 6b6:	02800593          	li	a1,40
 6ba:	bff1                	j	696 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6bc:	008b8913          	add	s2,s7,8
 6c0:	000bc583          	lbu	a1,0(s7)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dc2080e7          	jalr	-574(ra) # 488 <putc>
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5e1                	j	59a <vprintf+0x44>
        putc(fd, c);
 6d4:	02500593          	li	a1,37
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	dae080e7          	jalr	-594(ra) # 488 <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd5d                	j	59a <vprintf+0x44>
        putc(fd, '%');
 6e6:	02500593          	li	a1,37
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	d9c080e7          	jalr	-612(ra) # 488 <putc>
        putc(fd, c);
 6f4:	85ca                	mv	a1,s2
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d90080e7          	jalr	-624(ra) # 488 <putc>
      state = 0;
 700:	4981                	li	s3,0
 702:	bd61                	j	59a <vprintf+0x44>
        s = va_arg(ap, char*);
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	bd49                	j	59a <vprintf+0x44>
    }
  }
}
 70a:	60a6                	ld	ra,72(sp)
 70c:	6406                	ld	s0,64(sp)
 70e:	74e2                	ld	s1,56(sp)
 710:	7942                	ld	s2,48(sp)
 712:	79a2                	ld	s3,40(sp)
 714:	7a02                	ld	s4,32(sp)
 716:	6ae2                	ld	s5,24(sp)
 718:	6b42                	ld	s6,16(sp)
 71a:	6ba2                	ld	s7,8(sp)
 71c:	6c02                	ld	s8,0(sp)
 71e:	6161                	add	sp,sp,80
 720:	8082                	ret

0000000000000722 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 722:	715d                	add	sp,sp,-80
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	add	s0,sp,32
 72a:	e010                	sd	a2,0(s0)
 72c:	e414                	sd	a3,8(s0)
 72e:	e818                	sd	a4,16(s0)
 730:	ec1c                	sd	a5,24(s0)
 732:	03043023          	sd	a6,32(s0)
 736:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73e:	8622                	mv	a2,s0
 740:	00000097          	auipc	ra,0x0
 744:	e16080e7          	jalr	-490(ra) # 556 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	add	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	add	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	add	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	add	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	00000097          	auipc	ra,0x0
 77a:	de0080e7          	jalr	-544(ra) # 556 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6125                	add	sp,sp,96
 784:	8082                	ret

0000000000000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	1141                	add	sp,sp,-16
 788:	e422                	sd	s0,8(sp)
 78a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	00000797          	auipc	a5,0x0
 794:	2687b783          	ld	a5,616(a5) # 9f8 <freep>
 798:	a02d                	j	7c2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79a:	4618                	lw	a4,8(a2)
 79c:	9f2d                	addw	a4,a4,a1
 79e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	6398                	ld	a4,0(a5)
 7a4:	6310                	ld	a2,0(a4)
 7a6:	a83d                	j	7e4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a8:	ff852703          	lw	a4,-8(a0)
 7ac:	9f31                	addw	a4,a4,a2
 7ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b0:	ff053683          	ld	a3,-16(a0)
 7b4:	a091                	j	7f8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e7e463          	bltu	a5,a4,7c0 <free+0x3a>
 7bc:	00e6ea63          	bltu	a3,a4,7d0 <free+0x4a>
{
 7c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	fed7fae3          	bgeu	a5,a3,7b6 <free+0x30>
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e6e463          	bltu	a3,a4,7d0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	fee7eae3          	bltu	a5,a4,7c0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d0:	ff852583          	lw	a1,-8(a0)
 7d4:	6390                	ld	a2,0(a5)
 7d6:	02059813          	sll	a6,a1,0x20
 7da:	01c85713          	srl	a4,a6,0x1c
 7de:	9736                	add	a4,a4,a3
 7e0:	fae60de3          	beq	a2,a4,79a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e8:	4790                	lw	a2,8(a5)
 7ea:	02061593          	sll	a1,a2,0x20
 7ee:	01c5d713          	srl	a4,a1,0x1c
 7f2:	973e                	add	a4,a4,a5
 7f4:	fae68ae3          	beq	a3,a4,7a8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fa:	00000717          	auipc	a4,0x0
 7fe:	1ef73f23          	sd	a5,510(a4) # 9f8 <freep>
}
 802:	6422                	ld	s0,8(sp)
 804:	0141                	add	sp,sp,16
 806:	8082                	ret

0000000000000808 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 808:	7139                	add	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f426                	sd	s1,40(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
 81a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	02051493          	sll	s1,a0,0x20
 820:	9081                	srl	s1,s1,0x20
 822:	04bd                	add	s1,s1,15
 824:	8091                	srl	s1,s1,0x4
 826:	0014899b          	addw	s3,s1,1
 82a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 82c:	00000517          	auipc	a0,0x0
 830:	1cc53503          	ld	a0,460(a0) # 9f8 <freep>
 834:	c515                	beqz	a0,860 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	02977f63          	bgeu	a4,s1,878 <malloc+0x70>
  if(nu < 4096)
 83e:	8a4e                	mv	s4,s3
 840:	0009871b          	sext.w	a4,s3
 844:	6685                	lui	a3,0x1
 846:	00d77363          	bgeu	a4,a3,84c <malloc+0x44>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00000917          	auipc	s2,0x0
 858:	1a490913          	add	s2,s2,420 # 9f8 <freep>
  if(p == (char*)-1)
 85c:	5afd                	li	s5,-1
 85e:	a895                	j	8d2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 860:	00000797          	auipc	a5,0x0
 864:	1a078793          	add	a5,a5,416 # a00 <base>
 868:	00000717          	auipc	a4,0x0
 86c:	18f73823          	sd	a5,400(a4) # 9f8 <freep>
 870:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 872:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 876:	b7e1                	j	83e <malloc+0x36>
      if(p->s.size == nunits)
 878:	02e48c63          	beq	s1,a4,8b0 <malloc+0xa8>
        p->s.size -= nunits;
 87c:	4137073b          	subw	a4,a4,s3
 880:	c798                	sw	a4,8(a5)
        p += p->s.size;
 882:	02071693          	sll	a3,a4,0x20
 886:	01c6d713          	srl	a4,a3,0x1c
 88a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 890:	00000717          	auipc	a4,0x0
 894:	16a73423          	sd	a0,360(a4) # 9f8 <freep>
      return (void*)(p + 1);
 898:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89c:	70e2                	ld	ra,56(sp)
 89e:	7442                	ld	s0,48(sp)
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	7902                	ld	s2,32(sp)
 8a4:	69e2                	ld	s3,24(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	6121                	add	sp,sp,64
 8ae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b0:	6398                	ld	a4,0(a5)
 8b2:	e118                	sd	a4,0(a0)
 8b4:	bff1                	j	890 <malloc+0x88>
  hp->s.size = nu;
 8b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ba:	0541                	add	a0,a0,16
 8bc:	00000097          	auipc	ra,0x0
 8c0:	eca080e7          	jalr	-310(ra) # 786 <free>
  return freep;
 8c4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c8:	d971                	beqz	a0,89c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	fa9775e3          	bgeu	a4,s1,878 <malloc+0x70>
    if(p == freep)
 8d2:	00093703          	ld	a4,0(s2)
 8d6:	853e                	mv	a0,a5
 8d8:	fef719e3          	bne	a4,a5,8ca <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8dc:	8552                	mv	a0,s4
 8de:	00000097          	auipc	ra,0x0
 8e2:	b92080e7          	jalr	-1134(ra) # 470 <sbrk>
  if(p == (char*)-1)
 8e6:	fd5518e3          	bne	a0,s5,8b6 <malloc+0xae>
        return 0;
 8ea:	4501                	li	a0,0
 8ec:	bf45                	j	89c <malloc+0x94>
