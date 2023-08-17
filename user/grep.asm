
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	add	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	add	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	add	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	add	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	add	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	add	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	add	a1,a1,1
  ba:	00178513          	add	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	add	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	add	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	add	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	add	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	add	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	add	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	add	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	99ca8a93          	add	s5,s5,-1636 # ad8 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	1f0080e7          	jalr	496(ra) # 33e <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	add	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3b8080e7          	jalr	952(ra) # 536 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	398080e7          	jalr	920(ra) # 52e <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	92250513          	add	a0,a0,-1758 # ad8 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	29a080e7          	jalr	666(ra) # 464 <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	add	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	add	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	add	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	add	s2,a1,16
 210:	ffd5099b          	addw	s3,a0,-3
 214:	02099793          	sll	a5,s3,0x20
 218:	01d7d993          	srl	s3,a5,0x1d
 21c:	05e1                	add	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	330080e7          	jalr	816(ra) # 556 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	2fc080e7          	jalr	764(ra) # 53e <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	add	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2c4080e7          	jalr	708(ra) # 516 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00000597          	auipc	a1,0x0
 25e:	7c658593          	add	a1,a1,1990 # a20 <malloc+0xea>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	5ec080e7          	jalr	1516(ra) # 850 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2a8080e7          	jalr	680(ra) # 516 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	292080e7          	jalr	658(ra) # 516 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00000517          	auipc	a0,0x0
 294:	7b050513          	add	a0,a0,1968 # a40 <malloc+0x10a>
 298:	00000097          	auipc	ra,0x0
 29c:	5e6080e7          	jalr	1510(ra) # 87e <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	274080e7          	jalr	628(ra) # 516 <exit>

00000000000002aa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2aa:	1141                	add	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b0:	87aa                	mv	a5,a0
 2b2:	0585                	add	a1,a1,1
 2b4:	0785                	add	a5,a5,1
 2b6:	fff5c703          	lbu	a4,-1(a1)
 2ba:	fee78fa3          	sb	a4,-1(a5)
 2be:	fb75                	bnez	a4,2b2 <strcpy+0x8>
    ;
  return os;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	add	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c6:	1141                	add	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cb91                	beqz	a5,2e4 <strcmp+0x1e>
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00f71763          	bne	a4,a5,2e4 <strcmp+0x1e>
    p++, q++;
 2da:	0505                	add	a0,a0,1
 2dc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	fbe5                	bnez	a5,2d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e4:	0005c503          	lbu	a0,0(a1)
}
 2e8:	40a7853b          	subw	a0,a5,a0
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	add	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strlen>:

uint
strlen(const char *s)
{
 2f2:	1141                	add	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	cf91                	beqz	a5,318 <strlen+0x26>
 2fe:	0505                	add	a0,a0,1
 300:	87aa                	mv	a5,a0
 302:	86be                	mv	a3,a5
 304:	0785                	add	a5,a5,1
 306:	fff7c703          	lbu	a4,-1(a5)
 30a:	ff65                	bnez	a4,302 <strlen+0x10>
 30c:	40a6853b          	subw	a0,a3,a0
 310:	2505                	addw	a0,a0,1
    ;
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	add	sp,sp,16
 316:	8082                	ret
  for(n = 0; s[n]; n++)
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <strlen+0x20>

000000000000031c <memset>:

void*
memset(void *dst, int c, uint n)
{
 31c:	1141                	add	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 322:	ca19                	beqz	a2,338 <memset+0x1c>
 324:	87aa                	mv	a5,a0
 326:	1602                	sll	a2,a2,0x20
 328:	9201                	srl	a2,a2,0x20
 32a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 332:	0785                	add	a5,a5,1
 334:	fee79de3          	bne	a5,a4,32e <memset+0x12>
  }
  return dst;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	add	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	add	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	add	s0,sp,16
  for(; *s; s++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cb99                	beqz	a5,35e <strchr+0x20>
    if(*s == c)
 34a:	00f58763          	beq	a1,a5,358 <strchr+0x1a>
  for(; *s; s++)
 34e:	0505                	add	a0,a0,1
 350:	00054783          	lbu	a5,0(a0)
 354:	fbfd                	bnez	a5,34a <strchr+0xc>
      return (char*)s;
  return 0;
 356:	4501                	li	a0,0
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	add	sp,sp,16
 35c:	8082                	ret
  return 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <strchr+0x1a>

0000000000000362 <gets>:

char*
gets(char *buf, int max)
{
 362:	711d                	add	sp,sp,-96
 364:	ec86                	sd	ra,88(sp)
 366:	e8a2                	sd	s0,80(sp)
 368:	e4a6                	sd	s1,72(sp)
 36a:	e0ca                	sd	s2,64(sp)
 36c:	fc4e                	sd	s3,56(sp)
 36e:	f852                	sd	s4,48(sp)
 370:	f456                	sd	s5,40(sp)
 372:	f05a                	sd	s6,32(sp)
 374:	ec5e                	sd	s7,24(sp)
 376:	1080                	add	s0,sp,96
 378:	8baa                	mv	s7,a0
 37a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37c:	892a                	mv	s2,a0
 37e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 380:	4aa9                	li	s5,10
 382:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 384:	89a6                	mv	s3,s1
 386:	2485                	addw	s1,s1,1
 388:	0344d863          	bge	s1,s4,3b8 <gets+0x56>
    cc = read(0, &c, 1);
 38c:	4605                	li	a2,1
 38e:	faf40593          	add	a1,s0,-81
 392:	4501                	li	a0,0
 394:	00000097          	auipc	ra,0x0
 398:	19a080e7          	jalr	410(ra) # 52e <read>
    if(cc < 1)
 39c:	00a05e63          	blez	a0,3b8 <gets+0x56>
    buf[i++] = c;
 3a0:	faf44783          	lbu	a5,-81(s0)
 3a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a8:	01578763          	beq	a5,s5,3b6 <gets+0x54>
 3ac:	0905                	add	s2,s2,1
 3ae:	fd679be3          	bne	a5,s6,384 <gets+0x22>
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	a011                	j	3b8 <gets+0x56>
 3b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b8:	99de                	add	s3,s3,s7
 3ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 3be:	855e                	mv	a0,s7
 3c0:	60e6                	ld	ra,88(sp)
 3c2:	6446                	ld	s0,80(sp)
 3c4:	64a6                	ld	s1,72(sp)
 3c6:	6906                	ld	s2,64(sp)
 3c8:	79e2                	ld	s3,56(sp)
 3ca:	7a42                	ld	s4,48(sp)
 3cc:	7aa2                	ld	s5,40(sp)
 3ce:	7b02                	ld	s6,32(sp)
 3d0:	6be2                	ld	s7,24(sp)
 3d2:	6125                	add	sp,sp,96
 3d4:	8082                	ret

00000000000003d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d6:	1101                	add	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	e426                	sd	s1,8(sp)
 3de:	e04a                	sd	s2,0(sp)
 3e0:	1000                	add	s0,sp,32
 3e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e4:	4581                	li	a1,0
 3e6:	00000097          	auipc	ra,0x0
 3ea:	170080e7          	jalr	368(ra) # 556 <open>
  if(fd < 0)
 3ee:	02054563          	bltz	a0,418 <stat+0x42>
 3f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f4:	85ca                	mv	a1,s2
 3f6:	00000097          	auipc	ra,0x0
 3fa:	178080e7          	jalr	376(ra) # 56e <fstat>
 3fe:	892a                	mv	s2,a0
  close(fd);
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	13c080e7          	jalr	316(ra) # 53e <close>
  return r;
}
 40a:	854a                	mv	a0,s2
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	64a2                	ld	s1,8(sp)
 412:	6902                	ld	s2,0(sp)
 414:	6105                	add	sp,sp,32
 416:	8082                	ret
    return -1;
 418:	597d                	li	s2,-1
 41a:	bfc5                	j	40a <stat+0x34>

000000000000041c <atoi>:

int
atoi(const char *s)
{
 41c:	1141                	add	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 422:	00054683          	lbu	a3,0(a0)
 426:	fd06879b          	addw	a5,a3,-48
 42a:	0ff7f793          	zext.b	a5,a5
 42e:	4625                	li	a2,9
 430:	02f66863          	bltu	a2,a5,460 <atoi+0x44>
 434:	872a                	mv	a4,a0
  n = 0;
 436:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 438:	0705                	add	a4,a4,1
 43a:	0025179b          	sllw	a5,a0,0x2
 43e:	9fa9                	addw	a5,a5,a0
 440:	0017979b          	sllw	a5,a5,0x1
 444:	9fb5                	addw	a5,a5,a3
 446:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44a:	00074683          	lbu	a3,0(a4)
 44e:	fd06879b          	addw	a5,a3,-48
 452:	0ff7f793          	zext.b	a5,a5
 456:	fef671e3          	bgeu	a2,a5,438 <atoi+0x1c>
  return n;
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	add	sp,sp,16
 45e:	8082                	ret
  n = 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <atoi+0x3e>

0000000000000464 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 464:	1141                	add	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 46a:	02b57463          	bgeu	a0,a1,492 <memmove+0x2e>
    while(n-- > 0)
 46e:	00c05f63          	blez	a2,48c <memmove+0x28>
 472:	1602                	sll	a2,a2,0x20
 474:	9201                	srl	a2,a2,0x20
 476:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 47a:	872a                	mv	a4,a0
      *dst++ = *src++;
 47c:	0585                	add	a1,a1,1
 47e:	0705                	add	a4,a4,1
 480:	fff5c683          	lbu	a3,-1(a1)
 484:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 488:	fee79ae3          	bne	a5,a4,47c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48c:	6422                	ld	s0,8(sp)
 48e:	0141                	add	sp,sp,16
 490:	8082                	ret
    dst += n;
 492:	00c50733          	add	a4,a0,a2
    src += n;
 496:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 498:	fec05ae3          	blez	a2,48c <memmove+0x28>
 49c:	fff6079b          	addw	a5,a2,-1
 4a0:	1782                	sll	a5,a5,0x20
 4a2:	9381                	srl	a5,a5,0x20
 4a4:	fff7c793          	not	a5,a5
 4a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4aa:	15fd                	add	a1,a1,-1
 4ac:	177d                	add	a4,a4,-1
 4ae:	0005c683          	lbu	a3,0(a1)
 4b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b6:	fee79ae3          	bne	a5,a4,4aa <memmove+0x46>
 4ba:	bfc9                	j	48c <memmove+0x28>

00000000000004bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4bc:	1141                	add	sp,sp,-16
 4be:	e422                	sd	s0,8(sp)
 4c0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c2:	ca05                	beqz	a2,4f2 <memcmp+0x36>
 4c4:	fff6069b          	addw	a3,a2,-1
 4c8:	1682                	sll	a3,a3,0x20
 4ca:	9281                	srl	a3,a3,0x20
 4cc:	0685                	add	a3,a3,1
 4ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4d0:	00054783          	lbu	a5,0(a0)
 4d4:	0005c703          	lbu	a4,0(a1)
 4d8:	00e79863          	bne	a5,a4,4e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4dc:	0505                	add	a0,a0,1
    p2++;
 4de:	0585                	add	a1,a1,1
  while (n-- > 0) {
 4e0:	fed518e3          	bne	a0,a3,4d0 <memcmp+0x14>
  }
  return 0;
 4e4:	4501                	li	a0,0
 4e6:	a019                	j	4ec <memcmp+0x30>
      return *p1 - *p2;
 4e8:	40e7853b          	subw	a0,a5,a4
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	add	sp,sp,16
 4f0:	8082                	ret
  return 0;
 4f2:	4501                	li	a0,0
 4f4:	bfe5                	j	4ec <memcmp+0x30>

00000000000004f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f6:	1141                	add	sp,sp,-16
 4f8:	e406                	sd	ra,8(sp)
 4fa:	e022                	sd	s0,0(sp)
 4fc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4fe:	00000097          	auipc	ra,0x0
 502:	f66080e7          	jalr	-154(ra) # 464 <memmove>
}
 506:	60a2                	ld	ra,8(sp)
 508:	6402                	ld	s0,0(sp)
 50a:	0141                	add	sp,sp,16
 50c:	8082                	ret

000000000000050e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50e:	4885                	li	a7,1
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <exit>:
.global exit
exit:
 li a7, SYS_exit
 516:	4889                	li	a7,2
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <wait>:
.global wait
wait:
 li a7, SYS_wait
 51e:	488d                	li	a7,3
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 526:	4891                	li	a7,4
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <read>:
.global read
read:
 li a7, SYS_read
 52e:	4895                	li	a7,5
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <write>:
.global write
write:
 li a7, SYS_write
 536:	48c1                	li	a7,16
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <close>:
.global close
close:
 li a7, SYS_close
 53e:	48d5                	li	a7,21
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <kill>:
.global kill
kill:
 li a7, SYS_kill
 546:	4899                	li	a7,6
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <exec>:
.global exec
exec:
 li a7, SYS_exec
 54e:	489d                	li	a7,7
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <open>:
.global open
open:
 li a7, SYS_open
 556:	48bd                	li	a7,15
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55e:	48c5                	li	a7,17
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 566:	48c9                	li	a7,18
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56e:	48a1                	li	a7,8
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <link>:
.global link
link:
 li a7, SYS_link
 576:	48cd                	li	a7,19
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57e:	48d1                	li	a7,20
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 586:	48a5                	li	a7,9
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <dup>:
.global dup
dup:
 li a7, SYS_dup
 58e:	48a9                	li	a7,10
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 596:	48ad                	li	a7,11
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 59e:	48b1                	li	a7,12
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5a6:	48b5                	li	a7,13
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ae:	48b9                	li	a7,14
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b6:	1101                	add	sp,sp,-32
 5b8:	ec06                	sd	ra,24(sp)
 5ba:	e822                	sd	s0,16(sp)
 5bc:	1000                	add	s0,sp,32
 5be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c2:	4605                	li	a2,1
 5c4:	fef40593          	add	a1,s0,-17
 5c8:	00000097          	auipc	ra,0x0
 5cc:	f6e080e7          	jalr	-146(ra) # 536 <write>
}
 5d0:	60e2                	ld	ra,24(sp)
 5d2:	6442                	ld	s0,16(sp)
 5d4:	6105                	add	sp,sp,32
 5d6:	8082                	ret

00000000000005d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d8:	7139                	add	sp,sp,-64
 5da:	fc06                	sd	ra,56(sp)
 5dc:	f822                	sd	s0,48(sp)
 5de:	f426                	sd	s1,40(sp)
 5e0:	f04a                	sd	s2,32(sp)
 5e2:	ec4e                	sd	s3,24(sp)
 5e4:	0080                	add	s0,sp,64
 5e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e8:	c299                	beqz	a3,5ee <printint+0x16>
 5ea:	0805c963          	bltz	a1,67c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ee:	2581                	sext.w	a1,a1
  neg = 0;
 5f0:	4881                	li	a7,0
 5f2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f8:	2601                	sext.w	a2,a2
 5fa:	00000517          	auipc	a0,0x0
 5fe:	4be50513          	add	a0,a0,1214 # ab8 <digits>
 602:	883a                	mv	a6,a4
 604:	2705                	addw	a4,a4,1
 606:	02c5f7bb          	remuw	a5,a1,a2
 60a:	1782                	sll	a5,a5,0x20
 60c:	9381                	srl	a5,a5,0x20
 60e:	97aa                	add	a5,a5,a0
 610:	0007c783          	lbu	a5,0(a5)
 614:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 618:	0005879b          	sext.w	a5,a1
 61c:	02c5d5bb          	divuw	a1,a1,a2
 620:	0685                	add	a3,a3,1
 622:	fec7f0e3          	bgeu	a5,a2,602 <printint+0x2a>
  if(neg)
 626:	00088c63          	beqz	a7,63e <printint+0x66>
    buf[i++] = '-';
 62a:	fd070793          	add	a5,a4,-48
 62e:	00878733          	add	a4,a5,s0
 632:	02d00793          	li	a5,45
 636:	fef70823          	sb	a5,-16(a4)
 63a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 63e:	02e05863          	blez	a4,66e <printint+0x96>
 642:	fc040793          	add	a5,s0,-64
 646:	00e78933          	add	s2,a5,a4
 64a:	fff78993          	add	s3,a5,-1
 64e:	99ba                	add	s3,s3,a4
 650:	377d                	addw	a4,a4,-1
 652:	1702                	sll	a4,a4,0x20
 654:	9301                	srl	a4,a4,0x20
 656:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65a:	fff94583          	lbu	a1,-1(s2)
 65e:	8526                	mv	a0,s1
 660:	00000097          	auipc	ra,0x0
 664:	f56080e7          	jalr	-170(ra) # 5b6 <putc>
  while(--i >= 0)
 668:	197d                	add	s2,s2,-1
 66a:	ff3918e3          	bne	s2,s3,65a <printint+0x82>
}
 66e:	70e2                	ld	ra,56(sp)
 670:	7442                	ld	s0,48(sp)
 672:	74a2                	ld	s1,40(sp)
 674:	7902                	ld	s2,32(sp)
 676:	69e2                	ld	s3,24(sp)
 678:	6121                	add	sp,sp,64
 67a:	8082                	ret
    x = -xx;
 67c:	40b005bb          	negw	a1,a1
    neg = 1;
 680:	4885                	li	a7,1
    x = -xx;
 682:	bf85                	j	5f2 <printint+0x1a>

0000000000000684 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 684:	715d                	add	sp,sp,-80
 686:	e486                	sd	ra,72(sp)
 688:	e0a2                	sd	s0,64(sp)
 68a:	fc26                	sd	s1,56(sp)
 68c:	f84a                	sd	s2,48(sp)
 68e:	f44e                	sd	s3,40(sp)
 690:	f052                	sd	s4,32(sp)
 692:	ec56                	sd	s5,24(sp)
 694:	e85a                	sd	s6,16(sp)
 696:	e45e                	sd	s7,8(sp)
 698:	e062                	sd	s8,0(sp)
 69a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69c:	0005c903          	lbu	s2,0(a1)
 6a0:	18090c63          	beqz	s2,838 <vprintf+0x1b4>
 6a4:	8aaa                	mv	s5,a0
 6a6:	8bb2                	mv	s7,a2
 6a8:	00158493          	add	s1,a1,1
  state = 0;
 6ac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ae:	02500a13          	li	s4,37
 6b2:	4b55                	li	s6,21
 6b4:	a839                	j	6d2 <vprintf+0x4e>
        putc(fd, c);
 6b6:	85ca                	mv	a1,s2
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	efc080e7          	jalr	-260(ra) # 5b6 <putc>
 6c2:	a019                	j	6c8 <vprintf+0x44>
    } else if(state == '%'){
 6c4:	01498d63          	beq	s3,s4,6de <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6c8:	0485                	add	s1,s1,1
 6ca:	fff4c903          	lbu	s2,-1(s1)
 6ce:	16090563          	beqz	s2,838 <vprintf+0x1b4>
    if(state == 0){
 6d2:	fe0999e3          	bnez	s3,6c4 <vprintf+0x40>
      if(c == '%'){
 6d6:	ff4910e3          	bne	s2,s4,6b6 <vprintf+0x32>
        state = '%';
 6da:	89d2                	mv	s3,s4
 6dc:	b7f5                	j	6c8 <vprintf+0x44>
      if(c == 'd'){
 6de:	13490263          	beq	s2,s4,802 <vprintf+0x17e>
 6e2:	f9d9079b          	addw	a5,s2,-99
 6e6:	0ff7f793          	zext.b	a5,a5
 6ea:	12fb6563          	bltu	s6,a5,814 <vprintf+0x190>
 6ee:	f9d9079b          	addw	a5,s2,-99
 6f2:	0ff7f713          	zext.b	a4,a5
 6f6:	10eb6f63          	bltu	s6,a4,814 <vprintf+0x190>
 6fa:	00271793          	sll	a5,a4,0x2
 6fe:	00000717          	auipc	a4,0x0
 702:	36270713          	add	a4,a4,866 # a60 <malloc+0x12a>
 706:	97ba                	add	a5,a5,a4
 708:	439c                	lw	a5,0(a5)
 70a:	97ba                	add	a5,a5,a4
 70c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 70e:	008b8913          	add	s2,s7,8
 712:	4685                	li	a3,1
 714:	4629                	li	a2,10
 716:	000ba583          	lw	a1,0(s7)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	ebc080e7          	jalr	-324(ra) # 5d8 <printint>
 724:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 726:	4981                	li	s3,0
 728:	b745                	j	6c8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72a:	008b8913          	add	s2,s7,8
 72e:	4681                	li	a3,0
 730:	4629                	li	a2,10
 732:	000ba583          	lw	a1,0(s7)
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	ea0080e7          	jalr	-352(ra) # 5d8 <printint>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	b751                	j	6c8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 746:	008b8913          	add	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000ba583          	lw	a1,0(s7)
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e84080e7          	jalr	-380(ra) # 5d8 <printint>
 75c:	8bca                	mv	s7,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	b7a5                	j	6c8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 762:	008b8c13          	add	s8,s7,8
 766:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76a:	03000593          	li	a1,48
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	e46080e7          	jalr	-442(ra) # 5b6 <putc>
  putc(fd, 'x');
 778:	07800593          	li	a1,120
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e38080e7          	jalr	-456(ra) # 5b6 <putc>
 786:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 788:	00000b97          	auipc	s7,0x0
 78c:	330b8b93          	add	s7,s7,816 # ab8 <digits>
 790:	03c9d793          	srl	a5,s3,0x3c
 794:	97de                	add	a5,a5,s7
 796:	0007c583          	lbu	a1,0(a5)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e1a080e7          	jalr	-486(ra) # 5b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	0992                	sll	s3,s3,0x4
 7a6:	397d                	addw	s2,s2,-1
 7a8:	fe0914e3          	bnez	s2,790 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7ac:	8be2                	mv	s7,s8
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	bf21                	j	6c8 <vprintf+0x44>
        s = va_arg(ap, char*);
 7b2:	008b8993          	add	s3,s7,8
 7b6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7ba:	02090163          	beqz	s2,7dc <vprintf+0x158>
        while(*s != 0){
 7be:	00094583          	lbu	a1,0(s2)
 7c2:	c9a5                	beqz	a1,832 <vprintf+0x1ae>
          putc(fd, *s);
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	df0080e7          	jalr	-528(ra) # 5b6 <putc>
          s++;
 7ce:	0905                	add	s2,s2,1
        while(*s != 0){
 7d0:	00094583          	lbu	a1,0(s2)
 7d4:	f9e5                	bnez	a1,7c4 <vprintf+0x140>
        s = va_arg(ap, char*);
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b5fd                	j	6c8 <vprintf+0x44>
          s = "(null)";
 7dc:	00000917          	auipc	s2,0x0
 7e0:	27c90913          	add	s2,s2,636 # a58 <malloc+0x122>
        while(*s != 0){
 7e4:	02800593          	li	a1,40
 7e8:	bff1                	j	7c4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 7ea:	008b8913          	add	s2,s7,8
 7ee:	000bc583          	lbu	a1,0(s7)
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	dc2080e7          	jalr	-574(ra) # 5b6 <putc>
 7fc:	8bca                	mv	s7,s2
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b5e1                	j	6c8 <vprintf+0x44>
        putc(fd, c);
 802:	02500593          	li	a1,37
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	dae080e7          	jalr	-594(ra) # 5b6 <putc>
      state = 0;
 810:	4981                	li	s3,0
 812:	bd5d                	j	6c8 <vprintf+0x44>
        putc(fd, '%');
 814:	02500593          	li	a1,37
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	d9c080e7          	jalr	-612(ra) # 5b6 <putc>
        putc(fd, c);
 822:	85ca                	mv	a1,s2
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	d90080e7          	jalr	-624(ra) # 5b6 <putc>
      state = 0;
 82e:	4981                	li	s3,0
 830:	bd61                	j	6c8 <vprintf+0x44>
        s = va_arg(ap, char*);
 832:	8bce                	mv	s7,s3
      state = 0;
 834:	4981                	li	s3,0
 836:	bd49                	j	6c8 <vprintf+0x44>
    }
  }
}
 838:	60a6                	ld	ra,72(sp)
 83a:	6406                	ld	s0,64(sp)
 83c:	74e2                	ld	s1,56(sp)
 83e:	7942                	ld	s2,48(sp)
 840:	79a2                	ld	s3,40(sp)
 842:	7a02                	ld	s4,32(sp)
 844:	6ae2                	ld	s5,24(sp)
 846:	6b42                	ld	s6,16(sp)
 848:	6ba2                	ld	s7,8(sp)
 84a:	6c02                	ld	s8,0(sp)
 84c:	6161                	add	sp,sp,80
 84e:	8082                	ret

0000000000000850 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 850:	715d                	add	sp,sp,-80
 852:	ec06                	sd	ra,24(sp)
 854:	e822                	sd	s0,16(sp)
 856:	1000                	add	s0,sp,32
 858:	e010                	sd	a2,0(s0)
 85a:	e414                	sd	a3,8(s0)
 85c:	e818                	sd	a4,16(s0)
 85e:	ec1c                	sd	a5,24(s0)
 860:	03043023          	sd	a6,32(s0)
 864:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 86c:	8622                	mv	a2,s0
 86e:	00000097          	auipc	ra,0x0
 872:	e16080e7          	jalr	-490(ra) # 684 <vprintf>
}
 876:	60e2                	ld	ra,24(sp)
 878:	6442                	ld	s0,16(sp)
 87a:	6161                	add	sp,sp,80
 87c:	8082                	ret

000000000000087e <printf>:

void
printf(const char *fmt, ...)
{
 87e:	711d                	add	sp,sp,-96
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	add	s0,sp,32
 886:	e40c                	sd	a1,8(s0)
 888:	e810                	sd	a2,16(s0)
 88a:	ec14                	sd	a3,24(s0)
 88c:	f018                	sd	a4,32(s0)
 88e:	f41c                	sd	a5,40(s0)
 890:	03043823          	sd	a6,48(s0)
 894:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	00840613          	add	a2,s0,8
 89c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a0:	85aa                	mv	a1,a0
 8a2:	4505                	li	a0,1
 8a4:	00000097          	auipc	ra,0x0
 8a8:	de0080e7          	jalr	-544(ra) # 684 <vprintf>
}
 8ac:	60e2                	ld	ra,24(sp)
 8ae:	6442                	ld	s0,16(sp)
 8b0:	6125                	add	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b4:	1141                	add	sp,sp,-16
 8b6:	e422                	sd	s0,8(sp)
 8b8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ba:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	00000797          	auipc	a5,0x0
 8c2:	2127b783          	ld	a5,530(a5) # ad0 <freep>
 8c6:	a02d                	j	8f0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c8:	4618                	lw	a4,8(a2)
 8ca:	9f2d                	addw	a4,a4,a1
 8cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	6310                	ld	a2,0(a4)
 8d4:	a83d                	j	912 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9f31                	addw	a4,a4,a2
 8dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053683          	ld	a3,-16(a0)
 8e2:	a091                	j	926 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e7e463          	bltu	a5,a4,8ee <free+0x3a>
 8ea:	00e6ea63          	bltu	a3,a4,8fe <free+0x4a>
{
 8ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	fed7fae3          	bgeu	a5,a3,8e4 <free+0x30>
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e6e463          	bltu	a3,a4,8fe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	fee7eae3          	bltu	a5,a4,8ee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8fe:	ff852583          	lw	a1,-8(a0)
 902:	6390                	ld	a2,0(a5)
 904:	02059813          	sll	a6,a1,0x20
 908:	01c85713          	srl	a4,a6,0x1c
 90c:	9736                	add	a4,a4,a3
 90e:	fae60de3          	beq	a2,a4,8c8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 916:	4790                	lw	a2,8(a5)
 918:	02061593          	sll	a1,a2,0x20
 91c:	01c5d713          	srl	a4,a1,0x1c
 920:	973e                	add	a4,a4,a5
 922:	fae68ae3          	beq	a3,a4,8d6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 926:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 928:	00000717          	auipc	a4,0x0
 92c:	1af73423          	sd	a5,424(a4) # ad0 <freep>
}
 930:	6422                	ld	s0,8(sp)
 932:	0141                	add	sp,sp,16
 934:	8082                	ret

0000000000000936 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 936:	7139                	add	sp,sp,-64
 938:	fc06                	sd	ra,56(sp)
 93a:	f822                	sd	s0,48(sp)
 93c:	f426                	sd	s1,40(sp)
 93e:	f04a                	sd	s2,32(sp)
 940:	ec4e                	sd	s3,24(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
 948:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94a:	02051493          	sll	s1,a0,0x20
 94e:	9081                	srl	s1,s1,0x20
 950:	04bd                	add	s1,s1,15
 952:	8091                	srl	s1,s1,0x4
 954:	0014899b          	addw	s3,s1,1
 958:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 95a:	00000517          	auipc	a0,0x0
 95e:	17653503          	ld	a0,374(a0) # ad0 <freep>
 962:	c515                	beqz	a0,98e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 966:	4798                	lw	a4,8(a5)
 968:	02977f63          	bgeu	a4,s1,9a6 <malloc+0x70>
  if(nu < 4096)
 96c:	8a4e                	mv	s4,s3
 96e:	0009871b          	sext.w	a4,s3
 972:	6685                	lui	a3,0x1
 974:	00d77363          	bgeu	a4,a3,97a <malloc+0x44>
 978:	6a05                	lui	s4,0x1
 97a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 982:	00000917          	auipc	s2,0x0
 986:	14e90913          	add	s2,s2,334 # ad0 <freep>
  if(p == (char*)-1)
 98a:	5afd                	li	s5,-1
 98c:	a895                	j	a00 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 98e:	00000797          	auipc	a5,0x0
 992:	54a78793          	add	a5,a5,1354 # ed8 <base>
 996:	00000717          	auipc	a4,0x0
 99a:	12f73d23          	sd	a5,314(a4) # ad0 <freep>
 99e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a4:	b7e1                	j	96c <malloc+0x36>
      if(p->s.size == nunits)
 9a6:	02e48c63          	beq	s1,a4,9de <malloc+0xa8>
        p->s.size -= nunits;
 9aa:	4137073b          	subw	a4,a4,s3
 9ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b0:	02071693          	sll	a3,a4,0x20
 9b4:	01c6d713          	srl	a4,a3,0x1c
 9b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9be:	00000717          	auipc	a4,0x0
 9c2:	10a73923          	sd	a0,274(a4) # ad0 <freep>
      return (void*)(p + 1);
 9c6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ca:	70e2                	ld	ra,56(sp)
 9cc:	7442                	ld	s0,48(sp)
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	7902                	ld	s2,32(sp)
 9d2:	69e2                	ld	s3,24(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
 9da:	6121                	add	sp,sp,64
 9dc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9de:	6398                	ld	a4,0(a5)
 9e0:	e118                	sd	a4,0(a0)
 9e2:	bff1                	j	9be <malloc+0x88>
  hp->s.size = nu;
 9e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e8:	0541                	add	a0,a0,16
 9ea:	00000097          	auipc	ra,0x0
 9ee:	eca080e7          	jalr	-310(ra) # 8b4 <free>
  return freep;
 9f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f6:	d971                	beqz	a0,9ca <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fa:	4798                	lw	a4,8(a5)
 9fc:	fa9775e3          	bgeu	a4,s1,9a6 <malloc+0x70>
    if(p == freep)
 a00:	00093703          	ld	a4,0(s2)
 a04:	853e                	mv	a0,a5
 a06:	fef719e3          	bne	a4,a5,9f8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a0a:	8552                	mv	a0,s4
 a0c:	00000097          	auipc	ra,0x0
 a10:	b92080e7          	jalr	-1134(ra) # 59e <sbrk>
  if(p == (char*)-1)
 a14:	fd5518e3          	bne	a0,s5,9e4 <malloc+0xae>
        return 0;
 a18:	4501                	li	a0,0
 a1a:	bf45                	j	9ca <malloc+0x94>
