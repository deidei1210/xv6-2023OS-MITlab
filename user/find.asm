
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_name>:
#include "user/user.h"

/*
	将路径格式化为文件名
*/
char* fmt_name(char *path){
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
   c:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--);
   e:	00000097          	auipc	ra,0x0
  12:	2de080e7          	jalr	734(ra) # 2ec <strlen>
  16:	02051593          	sll	a1,a0,0x20
  1a:	9181                	srl	a1,a1,0x20
  1c:	95a6                	add	a1,a1,s1
  1e:	02f00713          	li	a4,47
  22:	0095e963          	bltu	a1,s1,34 <fmt_name+0x34>
  26:	0005c783          	lbu	a5,0(a1)
  2a:	00e78563          	beq	a5,a4,34 <fmt_name+0x34>
  2e:	15fd                	add	a1,a1,-1
  30:	fe95fbe3          	bgeu	a1,s1,26 <fmt_name+0x26>
  p++;
  34:	00158493          	add	s1,a1,1
  memmove(buf, p, strlen(p)+1);
  38:	8526                	mv	a0,s1
  3a:	00000097          	auipc	ra,0x0
  3e:	2b2080e7          	jalr	690(ra) # 2ec <strlen>
  42:	00001917          	auipc	s2,0x1
  46:	ad690913          	add	s2,s2,-1322 # b18 <buf.0>
  4a:	0015061b          	addw	a2,a0,1
  4e:	85a6                	mv	a1,s1
  50:	854a                	mv	a0,s2
  52:	00000097          	auipc	ra,0x0
  56:	40c080e7          	jalr	1036(ra) # 45e <memmove>
  return buf;
}
  5a:	854a                	mv	a0,s2
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6902                	ld	s2,0(sp)
  64:	6105                	add	sp,sp,32
  66:	8082                	ret

0000000000000068 <eq_print>:
/*
	系统文件名与要查找的文件名，若一致，打印系统文件完整路径
*/
void eq_print(char *fileName, char *findName){
  68:	1101                	add	sp,sp,-32
  6a:	ec06                	sd	ra,24(sp)
  6c:	e822                	sd	s0,16(sp)
  6e:	e426                	sd	s1,8(sp)
  70:	e04a                	sd	s2,0(sp)
  72:	1000                	add	s0,sp,32
  74:	892a                	mv	s2,a0
  76:	84ae                	mv	s1,a1
	if(strcmp(fmt_name(fileName), findName) == 0){
  78:	00000097          	auipc	ra,0x0
  7c:	f88080e7          	jalr	-120(ra) # 0 <fmt_name>
  80:	85a6                	mv	a1,s1
  82:	00000097          	auipc	ra,0x0
  86:	23e080e7          	jalr	574(ra) # 2c0 <strcmp>
  8a:	c519                	beqz	a0,98 <eq_print+0x30>
		printf("%s\n", fileName);
	}
}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6902                	ld	s2,0(sp)
  94:	6105                	add	sp,sp,32
  96:	8082                	ret
		printf("%s\n", fileName);
  98:	85ca                	mv	a1,s2
  9a:	00001517          	auipc	a0,0x1
  9e:	97e50513          	add	a0,a0,-1666 # a18 <malloc+0xe8>
  a2:	00000097          	auipc	ra,0x0
  a6:	7d6080e7          	jalr	2006(ra) # 878 <printf>
}
  aa:	b7cd                	j	8c <eq_print+0x24>

00000000000000ac <find>:
/*
	在某路径中查找某文件
*/
void find(char *path, char *findName){
  ac:	d9010113          	add	sp,sp,-624
  b0:	26113423          	sd	ra,616(sp)
  b4:	26813023          	sd	s0,608(sp)
  b8:	24913c23          	sd	s1,600(sp)
  bc:	25213823          	sd	s2,592(sp)
  c0:	25313423          	sd	s3,584(sp)
  c4:	25413023          	sd	s4,576(sp)
  c8:	23513c23          	sd	s5,568(sp)
  cc:	23613823          	sd	s6,560(sp)
  d0:	1c80                	add	s0,sp,624
  d2:	892a                	mv	s2,a0
  d4:	89ae                	mv	s3,a1
	int fd;
	struct stat st;	
	if((fd = open(path, O_RDONLY)) < 0){
  d6:	4581                	li	a1,0
  d8:	00000097          	auipc	ra,0x0
  dc:	478080e7          	jalr	1144(ra) # 550 <open>
  e0:	06054163          	bltz	a0,142 <find+0x96>
  e4:	84aa                	mv	s1,a0
		fprintf(2, "find: cannot open %s\n", path);
		return;
	}
	if(fstat(fd, &st) < 0){
  e6:	fa840593          	add	a1,s0,-88
  ea:	00000097          	auipc	ra,0x0
  ee:	47e080e7          	jalr	1150(ra) # 568 <fstat>
  f2:	06054363          	bltz	a0,158 <find+0xac>
		close(fd);
		return;
	}
	char buf[512], *p;	
	struct dirent de;
	switch(st.type){	
  f6:	fb041783          	lh	a5,-80(s0)
  fa:	4705                	li	a4,1
  fc:	06e78e63          	beq	a5,a4,178 <find+0xcc>
 100:	4709                	li	a4,2
 102:	00e79863          	bne	a5,a4,112 <find+0x66>
		case T_FILE:
			eq_print(path, findName);			
 106:	85ce                	mv	a1,s3
 108:	854a                	mv	a0,s2
 10a:	00000097          	auipc	ra,0x0
 10e:	f5e080e7          	jalr	-162(ra) # 68 <eq_print>
				p[strlen(de.name)] = 0;
				find(buf, findName);
			}
			break;
	}
	close(fd);	
 112:	8526                	mv	a0,s1
 114:	00000097          	auipc	ra,0x0
 118:	424080e7          	jalr	1060(ra) # 538 <close>
}
 11c:	26813083          	ld	ra,616(sp)
 120:	26013403          	ld	s0,608(sp)
 124:	25813483          	ld	s1,600(sp)
 128:	25013903          	ld	s2,592(sp)
 12c:	24813983          	ld	s3,584(sp)
 130:	24013a03          	ld	s4,576(sp)
 134:	23813a83          	ld	s5,568(sp)
 138:	23013b03          	ld	s6,560(sp)
 13c:	27010113          	add	sp,sp,624
 140:	8082                	ret
		fprintf(2, "find: cannot open %s\n", path);
 142:	864a                	mv	a2,s2
 144:	00001597          	auipc	a1,0x1
 148:	8dc58593          	add	a1,a1,-1828 # a20 <malloc+0xf0>
 14c:	4509                	li	a0,2
 14e:	00000097          	auipc	ra,0x0
 152:	6fc080e7          	jalr	1788(ra) # 84a <fprintf>
		return;
 156:	b7d9                	j	11c <find+0x70>
		fprintf(2, "find: cannot stat %s\n", path);
 158:	864a                	mv	a2,s2
 15a:	00001597          	auipc	a1,0x1
 15e:	8de58593          	add	a1,a1,-1826 # a38 <malloc+0x108>
 162:	4509                	li	a0,2
 164:	00000097          	auipc	ra,0x0
 168:	6e6080e7          	jalr	1766(ra) # 84a <fprintf>
		close(fd);
 16c:	8526                	mv	a0,s1
 16e:	00000097          	auipc	ra,0x0
 172:	3ca080e7          	jalr	970(ra) # 538 <close>
		return;
 176:	b75d                	j	11c <find+0x70>
			if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 178:	854a                	mv	a0,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	172080e7          	jalr	370(ra) # 2ec <strlen>
 182:	2541                	addw	a0,a0,16
 184:	20000793          	li	a5,512
 188:	00a7fb63          	bgeu	a5,a0,19e <find+0xf2>
				printf("find: path too long\n");
 18c:	00001517          	auipc	a0,0x1
 190:	8c450513          	add	a0,a0,-1852 # a50 <malloc+0x120>
 194:	00000097          	auipc	ra,0x0
 198:	6e4080e7          	jalr	1764(ra) # 878 <printf>
				break;
 19c:	bf9d                	j	112 <find+0x66>
			strcpy(buf, path);
 19e:	85ca                	mv	a1,s2
 1a0:	da840513          	add	a0,s0,-600
 1a4:	00000097          	auipc	ra,0x0
 1a8:	100080e7          	jalr	256(ra) # 2a4 <strcpy>
			p = buf+strlen(buf);
 1ac:	da840513          	add	a0,s0,-600
 1b0:	00000097          	auipc	ra,0x0
 1b4:	13c080e7          	jalr	316(ra) # 2ec <strlen>
 1b8:	1502                	sll	a0,a0,0x20
 1ba:	9101                	srl	a0,a0,0x20
 1bc:	da840793          	add	a5,s0,-600
 1c0:	97aa                	add	a5,a5,a0
			*p++ = '/';
 1c2:	00178a93          	add	s5,a5,1
 1c6:	02f00713          	li	a4,47
 1ca:	00e78023          	sb	a4,0(a5)
				if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1ce:	4905                	li	s2,1
 1d0:	00001a17          	auipc	s4,0x1
 1d4:	898a0a13          	add	s4,s4,-1896 # a68 <malloc+0x138>
 1d8:	00001b17          	auipc	s6,0x1
 1dc:	898b0b13          	add	s6,s6,-1896 # a70 <malloc+0x140>
			while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e0:	4641                	li	a2,16
 1e2:	d9840593          	add	a1,s0,-616
 1e6:	8526                	mv	a0,s1
 1e8:	00000097          	auipc	ra,0x0
 1ec:	340080e7          	jalr	832(ra) # 528 <read>
 1f0:	47c1                	li	a5,16
 1f2:	f2f510e3          	bne	a0,a5,112 <find+0x66>
				if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1f6:	d9845783          	lhu	a5,-616(s0)
 1fa:	fef973e3          	bgeu	s2,a5,1e0 <find+0x134>
 1fe:	85d2                	mv	a1,s4
 200:	d9a40513          	add	a0,s0,-614
 204:	00000097          	auipc	ra,0x0
 208:	0bc080e7          	jalr	188(ra) # 2c0 <strcmp>
 20c:	d971                	beqz	a0,1e0 <find+0x134>
 20e:	85da                	mv	a1,s6
 210:	d9a40513          	add	a0,s0,-614
 214:	00000097          	auipc	ra,0x0
 218:	0ac080e7          	jalr	172(ra) # 2c0 <strcmp>
 21c:	d171                	beqz	a0,1e0 <find+0x134>
				memmove(p, de.name, strlen(de.name));
 21e:	d9a40513          	add	a0,s0,-614
 222:	00000097          	auipc	ra,0x0
 226:	0ca080e7          	jalr	202(ra) # 2ec <strlen>
 22a:	0005061b          	sext.w	a2,a0
 22e:	d9a40593          	add	a1,s0,-614
 232:	8556                	mv	a0,s5
 234:	00000097          	auipc	ra,0x0
 238:	22a080e7          	jalr	554(ra) # 45e <memmove>
				p[strlen(de.name)] = 0;
 23c:	d9a40513          	add	a0,s0,-614
 240:	00000097          	auipc	ra,0x0
 244:	0ac080e7          	jalr	172(ra) # 2ec <strlen>
 248:	02051793          	sll	a5,a0,0x20
 24c:	9381                	srl	a5,a5,0x20
 24e:	97d6                	add	a5,a5,s5
 250:	00078023          	sb	zero,0(a5)
				find(buf, findName);
 254:	85ce                	mv	a1,s3
 256:	da840513          	add	a0,s0,-600
 25a:	00000097          	auipc	ra,0x0
 25e:	e52080e7          	jalr	-430(ra) # ac <find>
 262:	bfbd                	j	1e0 <find+0x134>

0000000000000264 <main>:

int main(int argc, char *argv[]){
 264:	1141                	add	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	add	s0,sp,16
	if(argc < 3){
 26c:	4709                	li	a4,2
 26e:	00a74f63          	blt	a4,a0,28c <main+0x28>
		printf("find: find <path> <fileName>\n");
 272:	00001517          	auipc	a0,0x1
 276:	80650513          	add	a0,a0,-2042 # a78 <malloc+0x148>
 27a:	00000097          	auipc	ra,0x0
 27e:	5fe080e7          	jalr	1534(ra) # 878 <printf>
		exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	28c080e7          	jalr	652(ra) # 510 <exit>
 28c:	87ae                	mv	a5,a1
	}
	find(argv[1], argv[2]);
 28e:	698c                	ld	a1,16(a1)
 290:	6788                	ld	a0,8(a5)
 292:	00000097          	auipc	ra,0x0
 296:	e1a080e7          	jalr	-486(ra) # ac <find>
	exit(0);
 29a:	4501                	li	a0,0
 29c:	00000097          	auipc	ra,0x0
 2a0:	274080e7          	jalr	628(ra) # 510 <exit>

00000000000002a4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a4:	1141                	add	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	87aa                	mv	a5,a0
 2ac:	0585                	add	a1,a1,1
 2ae:	0785                	add	a5,a5,1
 2b0:	fff5c703          	lbu	a4,-1(a1)
 2b4:	fee78fa3          	sb	a4,-1(a5)
 2b8:	fb75                	bnez	a4,2ac <strcpy+0x8>
    ;
  return os;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	add	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c0:	1141                	add	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cb91                	beqz	a5,2de <strcmp+0x1e>
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00f71763          	bne	a4,a5,2de <strcmp+0x1e>
    p++, q++;
 2d4:	0505                	add	a0,a0,1
 2d6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2d8:	00054783          	lbu	a5,0(a0)
 2dc:	fbe5                	bnez	a5,2cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2de:	0005c503          	lbu	a0,0(a1)
}
 2e2:	40a7853b          	subw	a0,a5,a0
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	add	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strlen>:

unsigned int
strlen(const char *s)
{
 2ec:	1141                	add	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf91                	beqz	a5,312 <strlen+0x26>
 2f8:	0505                	add	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	add	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x10>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	add	sp,sp,16
 310:	8082                	ret
  for(n = 0; s[n]; n++)
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <strlen+0x20>

0000000000000316 <memset>:

void*
memset(void *dst, int c, unsigned int n)
{
 316:	1141                	add	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31c:	ca19                	beqz	a2,332 <memset+0x1c>
 31e:	87aa                	mv	a5,a0
 320:	1602                	sll	a2,a2,0x20
 322:	9201                	srl	a2,a2,0x20
 324:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 328:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32c:	0785                	add	a5,a5,1
 32e:	fee79de3          	bne	a5,a4,328 <memset+0x12>
  }
  return dst;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	add	sp,sp,16
 336:	8082                	ret

0000000000000338 <strchr>:

char*
strchr(const char *s, char c)
{
 338:	1141                	add	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	add	s0,sp,16
  for(; *s; s++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cb99                	beqz	a5,358 <strchr+0x20>
    if(*s == c)
 344:	00f58763          	beq	a1,a5,352 <strchr+0x1a>
  for(; *s; s++)
 348:	0505                	add	a0,a0,1
 34a:	00054783          	lbu	a5,0(a0)
 34e:	fbfd                	bnez	a5,344 <strchr+0xc>
      return (char*)s;
  return 0;
 350:	4501                	li	a0,0
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	add	sp,sp,16
 356:	8082                	ret
  return 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <strchr+0x1a>

000000000000035c <gets>:

char*
gets(char *buf, int max)
{
 35c:	711d                	add	sp,sp,-96
 35e:	ec86                	sd	ra,88(sp)
 360:	e8a2                	sd	s0,80(sp)
 362:	e4a6                	sd	s1,72(sp)
 364:	e0ca                	sd	s2,64(sp)
 366:	fc4e                	sd	s3,56(sp)
 368:	f852                	sd	s4,48(sp)
 36a:	f456                	sd	s5,40(sp)
 36c:	f05a                	sd	s6,32(sp)
 36e:	ec5e                	sd	s7,24(sp)
 370:	1080                	add	s0,sp,96
 372:	8baa                	mv	s7,a0
 374:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 376:	892a                	mv	s2,a0
 378:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 37a:	4aa9                	li	s5,10
 37c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37e:	89a6                	mv	s3,s1
 380:	2485                	addw	s1,s1,1
 382:	0344d863          	bge	s1,s4,3b2 <gets+0x56>
    cc = read(0, &c, 1);
 386:	4605                	li	a2,1
 388:	faf40593          	add	a1,s0,-81
 38c:	4501                	li	a0,0
 38e:	00000097          	auipc	ra,0x0
 392:	19a080e7          	jalr	410(ra) # 528 <read>
    if(cc < 1)
 396:	00a05e63          	blez	a0,3b2 <gets+0x56>
    buf[i++] = c;
 39a:	faf44783          	lbu	a5,-81(s0)
 39e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a2:	01578763          	beq	a5,s5,3b0 <gets+0x54>
 3a6:	0905                	add	s2,s2,1
 3a8:	fd679be3          	bne	a5,s6,37e <gets+0x22>
  for(i=0; i+1 < max; ){
 3ac:	89a6                	mv	s3,s1
 3ae:	a011                	j	3b2 <gets+0x56>
 3b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b2:	99de                	add	s3,s3,s7
 3b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b8:	855e                	mv	a0,s7
 3ba:	60e6                	ld	ra,88(sp)
 3bc:	6446                	ld	s0,80(sp)
 3be:	64a6                	ld	s1,72(sp)
 3c0:	6906                	ld	s2,64(sp)
 3c2:	79e2                	ld	s3,56(sp)
 3c4:	7a42                	ld	s4,48(sp)
 3c6:	7aa2                	ld	s5,40(sp)
 3c8:	7b02                	ld	s6,32(sp)
 3ca:	6be2                	ld	s7,24(sp)
 3cc:	6125                	add	sp,sp,96
 3ce:	8082                	ret

00000000000003d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d0:	1101                	add	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	e426                	sd	s1,8(sp)
 3d8:	e04a                	sd	s2,0(sp)
 3da:	1000                	add	s0,sp,32
 3dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3de:	4581                	li	a1,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	170080e7          	jalr	368(ra) # 550 <open>
  if(fd < 0)
 3e8:	02054563          	bltz	a0,412 <stat+0x42>
 3ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ee:	85ca                	mv	a1,s2
 3f0:	00000097          	auipc	ra,0x0
 3f4:	178080e7          	jalr	376(ra) # 568 <fstat>
 3f8:	892a                	mv	s2,a0
  close(fd);
 3fa:	8526                	mv	a0,s1
 3fc:	00000097          	auipc	ra,0x0
 400:	13c080e7          	jalr	316(ra) # 538 <close>
  return r;
}
 404:	854a                	mv	a0,s2
 406:	60e2                	ld	ra,24(sp)
 408:	6442                	ld	s0,16(sp)
 40a:	64a2                	ld	s1,8(sp)
 40c:	6902                	ld	s2,0(sp)
 40e:	6105                	add	sp,sp,32
 410:	8082                	ret
    return -1;
 412:	597d                	li	s2,-1
 414:	bfc5                	j	404 <stat+0x34>

0000000000000416 <atoi>:

int
atoi(const char *s)
{
 416:	1141                	add	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41c:	00054683          	lbu	a3,0(a0)
 420:	fd06879b          	addw	a5,a3,-48
 424:	0ff7f793          	zext.b	a5,a5
 428:	4625                	li	a2,9
 42a:	02f66863          	bltu	a2,a5,45a <atoi+0x44>
 42e:	872a                	mv	a4,a0
  n = 0;
 430:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 432:	0705                	add	a4,a4,1
 434:	0025179b          	sllw	a5,a0,0x2
 438:	9fa9                	addw	a5,a5,a0
 43a:	0017979b          	sllw	a5,a5,0x1
 43e:	9fb5                	addw	a5,a5,a3
 440:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 444:	00074683          	lbu	a3,0(a4)
 448:	fd06879b          	addw	a5,a3,-48
 44c:	0ff7f793          	zext.b	a5,a5
 450:	fef671e3          	bgeu	a2,a5,432 <atoi+0x1c>
  return n;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	add	sp,sp,16
 458:	8082                	ret
  n = 0;
 45a:	4501                	li	a0,0
 45c:	bfe5                	j	454 <atoi+0x3e>

000000000000045e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45e:	1141                	add	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 464:	02b57463          	bgeu	a0,a1,48c <memmove+0x2e>
    while(n-- > 0)
 468:	00c05f63          	blez	a2,486 <memmove+0x28>
 46c:	1602                	sll	a2,a2,0x20
 46e:	9201                	srl	a2,a2,0x20
 470:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 474:	872a                	mv	a4,a0
      *dst++ = *src++;
 476:	0585                	add	a1,a1,1
 478:	0705                	add	a4,a4,1
 47a:	fff5c683          	lbu	a3,-1(a1)
 47e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 482:	fee79ae3          	bne	a5,a4,476 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	add	sp,sp,16
 48a:	8082                	ret
    dst += n;
 48c:	00c50733          	add	a4,a0,a2
    src += n;
 490:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 492:	fec05ae3          	blez	a2,486 <memmove+0x28>
 496:	fff6079b          	addw	a5,a2,-1
 49a:	1782                	sll	a5,a5,0x20
 49c:	9381                	srl	a5,a5,0x20
 49e:	fff7c793          	not	a5,a5
 4a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a4:	15fd                	add	a1,a1,-1
 4a6:	177d                	add	a4,a4,-1
 4a8:	0005c683          	lbu	a3,0(a1)
 4ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b0:	fee79ae3          	bne	a5,a4,4a4 <memmove+0x46>
 4b4:	bfc9                	j	486 <memmove+0x28>

00000000000004b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, unsigned int n)
{
 4b6:	1141                	add	sp,sp,-16
 4b8:	e422                	sd	s0,8(sp)
 4ba:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4bc:	ca05                	beqz	a2,4ec <memcmp+0x36>
 4be:	fff6069b          	addw	a3,a2,-1
 4c2:	1682                	sll	a3,a3,0x20
 4c4:	9281                	srl	a3,a3,0x20
 4c6:	0685                	add	a3,a3,1
 4c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ca:	00054783          	lbu	a5,0(a0)
 4ce:	0005c703          	lbu	a4,0(a1)
 4d2:	00e79863          	bne	a5,a4,4e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d6:	0505                	add	a0,a0,1
    p2++;
 4d8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 4da:	fed518e3          	bne	a0,a3,4ca <memcmp+0x14>
  }
  return 0;
 4de:	4501                	li	a0,0
 4e0:	a019                	j	4e6 <memcmp+0x30>
      return *p1 - *p2;
 4e2:	40e7853b          	subw	a0,a5,a4
}
 4e6:	6422                	ld	s0,8(sp)
 4e8:	0141                	add	sp,sp,16
 4ea:	8082                	ret
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	bfe5                	j	4e6 <memcmp+0x30>

00000000000004f0 <memcpy>:

void *
memcpy(void *dst, const void *src, unsigned int n)
{
 4f0:	1141                	add	sp,sp,-16
 4f2:	e406                	sd	ra,8(sp)
 4f4:	e022                	sd	s0,0(sp)
 4f6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4f8:	00000097          	auipc	ra,0x0
 4fc:	f66080e7          	jalr	-154(ra) # 45e <memmove>
}
 500:	60a2                	ld	ra,8(sp)
 502:	6402                	ld	s0,0(sp)
 504:	0141                	add	sp,sp,16
 506:	8082                	ret

0000000000000508 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 508:	4885                	li	a7,1
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exit>:
.global exit
exit:
 li a7, SYS_exit
 510:	4889                	li	a7,2
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <wait>:
.global wait
wait:
 li a7, SYS_wait
 518:	488d                	li	a7,3
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 520:	4891                	li	a7,4
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <read>:
.global read
read:
 li a7, SYS_read
 528:	4895                	li	a7,5
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <write>:
.global write
write:
 li a7, SYS_write
 530:	48c1                	li	a7,16
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <close>:
.global close
close:
 li a7, SYS_close
 538:	48d5                	li	a7,21
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <kill>:
.global kill
kill:
 li a7, SYS_kill
 540:	4899                	li	a7,6
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exec>:
.global exec
exec:
 li a7, SYS_exec
 548:	489d                	li	a7,7
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <open>:
.global open
open:
 li a7, SYS_open
 550:	48bd                	li	a7,15
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 558:	48c5                	li	a7,17
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 560:	48c9                	li	a7,18
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 568:	48a1                	li	a7,8
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <link>:
.global link
link:
 li a7, SYS_link
 570:	48cd                	li	a7,19
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 578:	48d1                	li	a7,20
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 580:	48a5                	li	a7,9
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <dup>:
.global dup
dup:
 li a7, SYS_dup
 588:	48a9                	li	a7,10
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 590:	48ad                	li	a7,11
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 598:	48b1                	li	a7,12
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5a0:	48b5                	li	a7,13
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a8:	48b9                	li	a7,14
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b0:	1101                	add	sp,sp,-32
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	1000                	add	s0,sp,32
 5b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5bc:	4605                	li	a2,1
 5be:	fef40593          	add	a1,s0,-17
 5c2:	00000097          	auipc	ra,0x0
 5c6:	f6e080e7          	jalr	-146(ra) # 530 <write>
}
 5ca:	60e2                	ld	ra,24(sp)
 5cc:	6442                	ld	s0,16(sp)
 5ce:	6105                	add	sp,sp,32
 5d0:	8082                	ret

00000000000005d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d2:	7139                	add	sp,sp,-64
 5d4:	fc06                	sd	ra,56(sp)
 5d6:	f822                	sd	s0,48(sp)
 5d8:	f426                	sd	s1,40(sp)
 5da:	f04a                	sd	s2,32(sp)
 5dc:	ec4e                	sd	s3,24(sp)
 5de:	0080                	add	s0,sp,64
 5e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e2:	c299                	beqz	a3,5e8 <printint+0x16>
 5e4:	0805c963          	bltz	a1,676 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e8:	2581                	sext.w	a1,a1
  neg = 0;
 5ea:	4881                	li	a7,0
 5ec:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f2:	2601                	sext.w	a2,a2
 5f4:	00000517          	auipc	a0,0x0
 5f8:	50450513          	add	a0,a0,1284 # af8 <digits>
 5fc:	883a                	mv	a6,a4
 5fe:	2705                	addw	a4,a4,1
 600:	02c5f7bb          	remuw	a5,a1,a2
 604:	1782                	sll	a5,a5,0x20
 606:	9381                	srl	a5,a5,0x20
 608:	97aa                	add	a5,a5,a0
 60a:	0007c783          	lbu	a5,0(a5)
 60e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 612:	0005879b          	sext.w	a5,a1
 616:	02c5d5bb          	divuw	a1,a1,a2
 61a:	0685                	add	a3,a3,1
 61c:	fec7f0e3          	bgeu	a5,a2,5fc <printint+0x2a>
  if(neg)
 620:	00088c63          	beqz	a7,638 <printint+0x66>
    buf[i++] = '-';
 624:	fd070793          	add	a5,a4,-48
 628:	00878733          	add	a4,a5,s0
 62c:	02d00793          	li	a5,45
 630:	fef70823          	sb	a5,-16(a4)
 634:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 638:	02e05863          	blez	a4,668 <printint+0x96>
 63c:	fc040793          	add	a5,s0,-64
 640:	00e78933          	add	s2,a5,a4
 644:	fff78993          	add	s3,a5,-1
 648:	99ba                	add	s3,s3,a4
 64a:	377d                	addw	a4,a4,-1
 64c:	1702                	sll	a4,a4,0x20
 64e:	9301                	srl	a4,a4,0x20
 650:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 654:	fff94583          	lbu	a1,-1(s2)
 658:	8526                	mv	a0,s1
 65a:	00000097          	auipc	ra,0x0
 65e:	f56080e7          	jalr	-170(ra) # 5b0 <putc>
  while(--i >= 0)
 662:	197d                	add	s2,s2,-1
 664:	ff3918e3          	bne	s2,s3,654 <printint+0x82>
}
 668:	70e2                	ld	ra,56(sp)
 66a:	7442                	ld	s0,48(sp)
 66c:	74a2                	ld	s1,40(sp)
 66e:	7902                	ld	s2,32(sp)
 670:	69e2                	ld	s3,24(sp)
 672:	6121                	add	sp,sp,64
 674:	8082                	ret
    x = -xx;
 676:	40b005bb          	negw	a1,a1
    neg = 1;
 67a:	4885                	li	a7,1
    x = -xx;
 67c:	bf85                	j	5ec <printint+0x1a>

000000000000067e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67e:	715d                	add	sp,sp,-80
 680:	e486                	sd	ra,72(sp)
 682:	e0a2                	sd	s0,64(sp)
 684:	fc26                	sd	s1,56(sp)
 686:	f84a                	sd	s2,48(sp)
 688:	f44e                	sd	s3,40(sp)
 68a:	f052                	sd	s4,32(sp)
 68c:	ec56                	sd	s5,24(sp)
 68e:	e85a                	sd	s6,16(sp)
 690:	e45e                	sd	s7,8(sp)
 692:	e062                	sd	s8,0(sp)
 694:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 696:	0005c903          	lbu	s2,0(a1)
 69a:	18090c63          	beqz	s2,832 <vprintf+0x1b4>
 69e:	8aaa                	mv	s5,a0
 6a0:	8bb2                	mv	s7,a2
 6a2:	00158493          	add	s1,a1,1
  state = 0;
 6a6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6a8:	02500a13          	li	s4,37
 6ac:	4b55                	li	s6,21
 6ae:	a839                	j	6cc <vprintf+0x4e>
        putc(fd, c);
 6b0:	85ca                	mv	a1,s2
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	efc080e7          	jalr	-260(ra) # 5b0 <putc>
 6bc:	a019                	j	6c2 <vprintf+0x44>
    } else if(state == '%'){
 6be:	01498d63          	beq	s3,s4,6d8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6c2:	0485                	add	s1,s1,1
 6c4:	fff4c903          	lbu	s2,-1(s1)
 6c8:	16090563          	beqz	s2,832 <vprintf+0x1b4>
    if(state == 0){
 6cc:	fe0999e3          	bnez	s3,6be <vprintf+0x40>
      if(c == '%'){
 6d0:	ff4910e3          	bne	s2,s4,6b0 <vprintf+0x32>
        state = '%';
 6d4:	89d2                	mv	s3,s4
 6d6:	b7f5                	j	6c2 <vprintf+0x44>
      if(c == 'd'){
 6d8:	13490263          	beq	s2,s4,7fc <vprintf+0x17e>
 6dc:	f9d9079b          	addw	a5,s2,-99
 6e0:	0ff7f793          	zext.b	a5,a5
 6e4:	12fb6563          	bltu	s6,a5,80e <vprintf+0x190>
 6e8:	f9d9079b          	addw	a5,s2,-99
 6ec:	0ff7f713          	zext.b	a4,a5
 6f0:	10eb6f63          	bltu	s6,a4,80e <vprintf+0x190>
 6f4:	00271793          	sll	a5,a4,0x2
 6f8:	00000717          	auipc	a4,0x0
 6fc:	3a870713          	add	a4,a4,936 # aa0 <malloc+0x170>
 700:	97ba                	add	a5,a5,a4
 702:	439c                	lw	a5,0(a5)
 704:	97ba                	add	a5,a5,a4
 706:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 708:	008b8913          	add	s2,s7,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000ba583          	lw	a1,0(s7)
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	ebc080e7          	jalr	-324(ra) # 5d2 <printint>
 71e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 720:	4981                	li	s3,0
 722:	b745                	j	6c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b8913          	add	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	ea0080e7          	jalr	-352(ra) # 5d2 <printint>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b751                	j	6c2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 740:	008b8913          	add	s2,s7,8
 744:	4681                	li	a3,0
 746:	4641                	li	a2,16
 748:	000ba583          	lw	a1,0(s7)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	e84080e7          	jalr	-380(ra) # 5d2 <printint>
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	b7a5                	j	6c2 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 75c:	008b8c13          	add	s8,s7,8
 760:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e46080e7          	jalr	-442(ra) # 5b0 <putc>
  putc(fd, 'x');
 772:	07800593          	li	a1,120
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e38080e7          	jalr	-456(ra) # 5b0 <putc>
 780:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 782:	00000b97          	auipc	s7,0x0
 786:	376b8b93          	add	s7,s7,886 # af8 <digits>
 78a:	03c9d793          	srl	a5,s3,0x3c
 78e:	97de                	add	a5,a5,s7
 790:	0007c583          	lbu	a1,0(a5)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e1a080e7          	jalr	-486(ra) # 5b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79e:	0992                	sll	s3,s3,0x4
 7a0:	397d                	addw	s2,s2,-1
 7a2:	fe0914e3          	bnez	s2,78a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7a6:	8be2                	mv	s7,s8
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bf21                	j	6c2 <vprintf+0x44>
        s = va_arg(ap, char*);
 7ac:	008b8993          	add	s3,s7,8
 7b0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7b4:	02090163          	beqz	s2,7d6 <vprintf+0x158>
        while(*s != 0){
 7b8:	00094583          	lbu	a1,0(s2)
 7bc:	c9a5                	beqz	a1,82c <vprintf+0x1ae>
          putc(fd, *s);
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	df0080e7          	jalr	-528(ra) # 5b0 <putc>
          s++;
 7c8:	0905                	add	s2,s2,1
        while(*s != 0){
 7ca:	00094583          	lbu	a1,0(s2)
 7ce:	f9e5                	bnez	a1,7be <vprintf+0x140>
        s = va_arg(ap, char*);
 7d0:	8bce                	mv	s7,s3
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b5fd                	j	6c2 <vprintf+0x44>
          s = "(null)";
 7d6:	00000917          	auipc	s2,0x0
 7da:	2c290913          	add	s2,s2,706 # a98 <malloc+0x168>
        while(*s != 0){
 7de:	02800593          	li	a1,40
 7e2:	bff1                	j	7be <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 7e4:	008b8913          	add	s2,s7,8
 7e8:	000bc583          	lbu	a1,0(s7)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	dc2080e7          	jalr	-574(ra) # 5b0 <putc>
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b5e1                	j	6c2 <vprintf+0x44>
        putc(fd, c);
 7fc:	02500593          	li	a1,37
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	dae080e7          	jalr	-594(ra) # 5b0 <putc>
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bd5d                	j	6c2 <vprintf+0x44>
        putc(fd, '%');
 80e:	02500593          	li	a1,37
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	d9c080e7          	jalr	-612(ra) # 5b0 <putc>
        putc(fd, c);
 81c:	85ca                	mv	a1,s2
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	d90080e7          	jalr	-624(ra) # 5b0 <putc>
      state = 0;
 828:	4981                	li	s3,0
 82a:	bd61                	j	6c2 <vprintf+0x44>
        s = va_arg(ap, char*);
 82c:	8bce                	mv	s7,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	bd49                	j	6c2 <vprintf+0x44>
    }
  }
}
 832:	60a6                	ld	ra,72(sp)
 834:	6406                	ld	s0,64(sp)
 836:	74e2                	ld	s1,56(sp)
 838:	7942                	ld	s2,48(sp)
 83a:	79a2                	ld	s3,40(sp)
 83c:	7a02                	ld	s4,32(sp)
 83e:	6ae2                	ld	s5,24(sp)
 840:	6b42                	ld	s6,16(sp)
 842:	6ba2                	ld	s7,8(sp)
 844:	6c02                	ld	s8,0(sp)
 846:	6161                	add	sp,sp,80
 848:	8082                	ret

000000000000084a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84a:	715d                	add	sp,sp,-80
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	add	s0,sp,32
 852:	e010                	sd	a2,0(s0)
 854:	e414                	sd	a3,8(s0)
 856:	e818                	sd	a4,16(s0)
 858:	ec1c                	sd	a5,24(s0)
 85a:	03043023          	sd	a6,32(s0)
 85e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 866:	8622                	mv	a2,s0
 868:	00000097          	auipc	ra,0x0
 86c:	e16080e7          	jalr	-490(ra) # 67e <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6161                	add	sp,sp,80
 876:	8082                	ret

0000000000000878 <printf>:

void
printf(const char *fmt, ...)
{
 878:	711d                	add	sp,sp,-96
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	add	s0,sp,32
 880:	e40c                	sd	a1,8(s0)
 882:	e810                	sd	a2,16(s0)
 884:	ec14                	sd	a3,24(s0)
 886:	f018                	sd	a4,32(s0)
 888:	f41c                	sd	a5,40(s0)
 88a:	03043823          	sd	a6,48(s0)
 88e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	00840613          	add	a2,s0,8
 896:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89a:	85aa                	mv	a1,a0
 89c:	4505                	li	a0,1
 89e:	00000097          	auipc	ra,0x0
 8a2:	de0080e7          	jalr	-544(ra) # 67e <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6125                	add	sp,sp,96
 8ac:	8082                	ret

00000000000008ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ae:	1141                	add	sp,sp,-16
 8b0:	e422                	sd	s0,8(sp)
 8b2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	00000797          	auipc	a5,0x0
 8bc:	2587b783          	ld	a5,600(a5) # b10 <freep>
 8c0:	a02d                	j	8ea <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c2:	4618                	lw	a4,8(a2)
 8c4:	9f2d                	addw	a4,a4,a1
 8c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	6310                	ld	a2,0(a4)
 8ce:	a83d                	j	90c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d0:	ff852703          	lw	a4,-8(a0)
 8d4:	9f31                	addw	a4,a4,a2
 8d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d8:	ff053683          	ld	a3,-16(a0)
 8dc:	a091                	j	920 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e7e463          	bltu	a5,a4,8e8 <free+0x3a>
 8e4:	00e6ea63          	bltu	a3,a4,8f8 <free+0x4a>
{
 8e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ea:	fed7fae3          	bgeu	a5,a3,8de <free+0x30>
 8ee:	6398                	ld	a4,0(a5)
 8f0:	00e6e463          	bltu	a3,a4,8f8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f4:	fee7eae3          	bltu	a5,a4,8e8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f8:	ff852583          	lw	a1,-8(a0)
 8fc:	6390                	ld	a2,0(a5)
 8fe:	02059813          	sll	a6,a1,0x20
 902:	01c85713          	srl	a4,a6,0x1c
 906:	9736                	add	a4,a4,a3
 908:	fae60de3          	beq	a2,a4,8c2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 910:	4790                	lw	a2,8(a5)
 912:	02061593          	sll	a1,a2,0x20
 916:	01c5d713          	srl	a4,a1,0x1c
 91a:	973e                	add	a4,a4,a5
 91c:	fae68ae3          	beq	a3,a4,8d0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 920:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 922:	00000717          	auipc	a4,0x0
 926:	1ef73723          	sd	a5,494(a4) # b10 <freep>
}
 92a:	6422                	ld	s0,8(sp)
 92c:	0141                	add	sp,sp,16
 92e:	8082                	ret

0000000000000930 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 930:	7139                	add	sp,sp,-64
 932:	fc06                	sd	ra,56(sp)
 934:	f822                	sd	s0,48(sp)
 936:	f426                	sd	s1,40(sp)
 938:	f04a                	sd	s2,32(sp)
 93a:	ec4e                	sd	s3,24(sp)
 93c:	e852                	sd	s4,16(sp)
 93e:	e456                	sd	s5,8(sp)
 940:	e05a                	sd	s6,0(sp)
 942:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 944:	02051493          	sll	s1,a0,0x20
 948:	9081                	srl	s1,s1,0x20
 94a:	04bd                	add	s1,s1,15
 94c:	8091                	srl	s1,s1,0x4
 94e:	0014899b          	addw	s3,s1,1
 952:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 954:	00000517          	auipc	a0,0x0
 958:	1bc53503          	ld	a0,444(a0) # b10 <freep>
 95c:	c515                	beqz	a0,988 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 960:	4798                	lw	a4,8(a5)
 962:	02977f63          	bgeu	a4,s1,9a0 <malloc+0x70>
  if(nu < 4096)
 966:	8a4e                	mv	s4,s3
 968:	0009871b          	sext.w	a4,s3
 96c:	6685                	lui	a3,0x1
 96e:	00d77363          	bgeu	a4,a3,974 <malloc+0x44>
 972:	6a05                	lui	s4,0x1
 974:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 978:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97c:	00000917          	auipc	s2,0x0
 980:	19490913          	add	s2,s2,404 # b10 <freep>
  if(p == (char*)-1)
 984:	5afd                	li	s5,-1
 986:	a895                	j	9fa <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 988:	00000797          	auipc	a5,0x0
 98c:	1a078793          	add	a5,a5,416 # b28 <base>
 990:	00000717          	auipc	a4,0x0
 994:	18f73023          	sd	a5,384(a4) # b10 <freep>
 998:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 99e:	b7e1                	j	966 <malloc+0x36>
      if(p->s.size == nunits)
 9a0:	02e48c63          	beq	s1,a4,9d8 <malloc+0xa8>
        p->s.size -= nunits;
 9a4:	4137073b          	subw	a4,a4,s3
 9a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9aa:	02071693          	sll	a3,a4,0x20
 9ae:	01c6d713          	srl	a4,a3,0x1c
 9b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	14a73c23          	sd	a0,344(a4) # b10 <freep>
      return (void*)(p + 1);
 9c0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c4:	70e2                	ld	ra,56(sp)
 9c6:	7442                	ld	s0,48(sp)
 9c8:	74a2                	ld	s1,40(sp)
 9ca:	7902                	ld	s2,32(sp)
 9cc:	69e2                	ld	s3,24(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	6121                	add	sp,sp,64
 9d6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9d8:	6398                	ld	a4,0(a5)
 9da:	e118                	sd	a4,0(a0)
 9dc:	bff1                	j	9b8 <malloc+0x88>
  hp->s.size = nu;
 9de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e2:	0541                	add	a0,a0,16
 9e4:	00000097          	auipc	ra,0x0
 9e8:	eca080e7          	jalr	-310(ra) # 8ae <free>
  return freep;
 9ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f0:	d971                	beqz	a0,9c4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	fa9775e3          	bgeu	a4,s1,9a0 <malloc+0x70>
    if(p == freep)
 9fa:	00093703          	ld	a4,0(s2)
 9fe:	853e                	mv	a0,a5
 a00:	fef719e3          	bne	a4,a5,9f2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a04:	8552                	mv	a0,s4
 a06:	00000097          	auipc	ra,0x0
 a0a:	b92080e7          	jalr	-1134(ra) # 598 <sbrk>
  if(p == (char*)-1)
 a0e:	fd5518e3          	bne	a0,s5,9de <malloc+0xae>
        return 0;
 a12:	4501                	li	a0,0
 a14:	bf45                	j	9c4 <malloc+0x94>
