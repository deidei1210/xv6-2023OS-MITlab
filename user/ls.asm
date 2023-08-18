
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	306080e7          	jalr	774(ra) # 316 <strlen>
  18:	02051793          	sll	a5,a0,0x20
  1c:	9381                	srl	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	add	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2da080e7          	jalr	730(ra) # 316 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	add	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2b8080e7          	jalr	696(ra) # 316 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	ad298993          	add	s3,s3,-1326 # b38 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	412080e7          	jalr	1042(ra) # 488 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	296080e7          	jalr	662(ra) # 316 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	288080e7          	jalr	648(ra) # 316 <strlen>
  96:	1902                	sll	s2,s2,0x20
  98:	02095913          	srl	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	298080e7          	jalr	664(ra) # 340 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	add	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	add	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4a0080e7          	jalr	1184(ra) # 57a <open>
  e2:	06054d63          	bltz	a0,15c <ls+0xa8>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	add	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4a6080e7          	jalr	1190(ra) # 592 <fstat>
  f4:	06054f63          	bltz	a0,172 <ls+0xbe>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	4705                	li	a4,1
  fe:	08e78a63          	beq	a5,a4,192 <ls+0xde>
 102:	4709                	li	a4,2
 104:	02e79663          	bne	a5,a4,130 <ls+0x7c>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 108:	854a                	mv	a0,s2
 10a:	00000097          	auipc	ra,0x0
 10e:	ef6080e7          	jalr	-266(ra) # 0 <fmtname>
 112:	85aa                	mv	a1,a0
 114:	da843703          	ld	a4,-600(s0)
 118:	d9c42683          	lw	a3,-612(s0)
 11c:	da041603          	lh	a2,-608(s0)
 120:	00001517          	auipc	a0,0x1
 124:	95850513          	add	a0,a0,-1704 # a78 <malloc+0x116>
 128:	00000097          	auipc	ra,0x0
 12c:	782080e7          	jalr	1922(ra) # 8aa <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 130:	8526                	mv	a0,s1
 132:	00000097          	auipc	ra,0x0
 136:	430080e7          	jalr	1072(ra) # 562 <close>
}
 13a:	26813083          	ld	ra,616(sp)
 13e:	26013403          	ld	s0,608(sp)
 142:	25813483          	ld	s1,600(sp)
 146:	25013903          	ld	s2,592(sp)
 14a:	24813983          	ld	s3,584(sp)
 14e:	24013a03          	ld	s4,576(sp)
 152:	23813a83          	ld	s5,568(sp)
 156:	27010113          	add	sp,sp,624
 15a:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 15c:	864a                	mv	a2,s2
 15e:	00001597          	auipc	a1,0x1
 162:	8ea58593          	add	a1,a1,-1814 # a48 <malloc+0xe6>
 166:	4509                	li	a0,2
 168:	00000097          	auipc	ra,0x0
 16c:	714080e7          	jalr	1812(ra) # 87c <fprintf>
    return;
 170:	b7e9                	j	13a <ls+0x86>
    fprintf(2, "ls: cannot stat %s\n", path);
 172:	864a                	mv	a2,s2
 174:	00001597          	auipc	a1,0x1
 178:	8ec58593          	add	a1,a1,-1812 # a60 <malloc+0xfe>
 17c:	4509                	li	a0,2
 17e:	00000097          	auipc	ra,0x0
 182:	6fe080e7          	jalr	1790(ra) # 87c <fprintf>
    close(fd);
 186:	8526                	mv	a0,s1
 188:	00000097          	auipc	ra,0x0
 18c:	3da080e7          	jalr	986(ra) # 562 <close>
    return;
 190:	b76d                	j	13a <ls+0x86>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 192:	854a                	mv	a0,s2
 194:	00000097          	auipc	ra,0x0
 198:	182080e7          	jalr	386(ra) # 316 <strlen>
 19c:	2541                	addw	a0,a0,16
 19e:	20000793          	li	a5,512
 1a2:	00a7fb63          	bgeu	a5,a0,1b8 <ls+0x104>
      printf("ls: path too long\n");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	8e250513          	add	a0,a0,-1822 # a88 <malloc+0x126>
 1ae:	00000097          	auipc	ra,0x0
 1b2:	6fc080e7          	jalr	1788(ra) # 8aa <printf>
      break;
 1b6:	bfad                	j	130 <ls+0x7c>
    strcpy(buf, path);
 1b8:	85ca                	mv	a1,s2
 1ba:	dc040513          	add	a0,s0,-576
 1be:	00000097          	auipc	ra,0x0
 1c2:	110080e7          	jalr	272(ra) # 2ce <strcpy>
    p = buf+strlen(buf);
 1c6:	dc040513          	add	a0,s0,-576
 1ca:	00000097          	auipc	ra,0x0
 1ce:	14c080e7          	jalr	332(ra) # 316 <strlen>
 1d2:	1502                	sll	a0,a0,0x20
 1d4:	9101                	srl	a0,a0,0x20
 1d6:	dc040793          	add	a5,s0,-576
 1da:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1de:	00190993          	add	s3,s2,1
 1e2:	02f00793          	li	a5,47
 1e6:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1ea:	00001a17          	auipc	s4,0x1
 1ee:	8b6a0a13          	add	s4,s4,-1866 # aa0 <malloc+0x13e>
        printf("ls: cannot stat %s\n", buf);
 1f2:	00001a97          	auipc	s5,0x1
 1f6:	86ea8a93          	add	s5,s5,-1938 # a60 <malloc+0xfe>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fa:	a801                	j	20a <ls+0x156>
        printf("ls: cannot stat %s\n", buf);
 1fc:	dc040593          	add	a1,s0,-576
 200:	8556                	mv	a0,s5
 202:	00000097          	auipc	ra,0x0
 206:	6a8080e7          	jalr	1704(ra) # 8aa <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20a:	4641                	li	a2,16
 20c:	db040593          	add	a1,s0,-592
 210:	8526                	mv	a0,s1
 212:	00000097          	auipc	ra,0x0
 216:	340080e7          	jalr	832(ra) # 552 <read>
 21a:	47c1                	li	a5,16
 21c:	f0f51ae3          	bne	a0,a5,130 <ls+0x7c>
      if(de.inum == 0)
 220:	db045783          	lhu	a5,-592(s0)
 224:	d3fd                	beqz	a5,20a <ls+0x156>
      memmove(p, de.name, DIRSIZ);
 226:	4639                	li	a2,14
 228:	db240593          	add	a1,s0,-590
 22c:	854e                	mv	a0,s3
 22e:	00000097          	auipc	ra,0x0
 232:	25a080e7          	jalr	602(ra) # 488 <memmove>
      p[DIRSIZ] = 0;
 236:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 23a:	d9840593          	add	a1,s0,-616
 23e:	dc040513          	add	a0,s0,-576
 242:	00000097          	auipc	ra,0x0
 246:	1b8080e7          	jalr	440(ra) # 3fa <stat>
 24a:	fa0549e3          	bltz	a0,1fc <ls+0x148>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24e:	dc040513          	add	a0,s0,-576
 252:	00000097          	auipc	ra,0x0
 256:	dae080e7          	jalr	-594(ra) # 0 <fmtname>
 25a:	85aa                	mv	a1,a0
 25c:	da843703          	ld	a4,-600(s0)
 260:	d9c42683          	lw	a3,-612(s0)
 264:	da041603          	lh	a2,-608(s0)
 268:	8552                	mv	a0,s4
 26a:	00000097          	auipc	ra,0x0
 26e:	640080e7          	jalr	1600(ra) # 8aa <printf>
 272:	bf61                	j	20a <ls+0x156>

0000000000000274 <main>:

int
main(int argc, char *argv[])
{
 274:	1101                	add	sp,sp,-32
 276:	ec06                	sd	ra,24(sp)
 278:	e822                	sd	s0,16(sp)
 27a:	e426                	sd	s1,8(sp)
 27c:	e04a                	sd	s2,0(sp)
 27e:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
 280:	4785                	li	a5,1
 282:	02a7d963          	bge	a5,a0,2b4 <main+0x40>
 286:	00858493          	add	s1,a1,8
 28a:	ffe5091b          	addw	s2,a0,-2
 28e:	02091793          	sll	a5,s2,0x20
 292:	01d7d913          	srl	s2,a5,0x1d
 296:	05c1                	add	a1,a1,16
 298:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 29a:	6088                	ld	a0,0(s1)
 29c:	00000097          	auipc	ra,0x0
 2a0:	e18080e7          	jalr	-488(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2a4:	04a1                	add	s1,s1,8
 2a6:	ff249ae3          	bne	s1,s2,29a <main+0x26>
  exit(0);
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	28e080e7          	jalr	654(ra) # 53a <exit>
    ls(".");
 2b4:	00000517          	auipc	a0,0x0
 2b8:	7fc50513          	add	a0,a0,2044 # ab0 <malloc+0x14e>
 2bc:	00000097          	auipc	ra,0x0
 2c0:	df8080e7          	jalr	-520(ra) # b4 <ls>
    exit(0);
 2c4:	4501                	li	a0,0
 2c6:	00000097          	auipc	ra,0x0
 2ca:	274080e7          	jalr	628(ra) # 53a <exit>

00000000000002ce <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2ce:	1141                	add	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d4:	87aa                	mv	a5,a0
 2d6:	0585                	add	a1,a1,1
 2d8:	0785                	add	a5,a5,1
 2da:	fff5c703          	lbu	a4,-1(a1)
 2de:	fee78fa3          	sb	a4,-1(a5)
 2e2:	fb75                	bnez	a4,2d6 <strcpy+0x8>
    ;
  return os;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	add	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ea:	1141                	add	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cb91                	beqz	a5,308 <strcmp+0x1e>
 2f6:	0005c703          	lbu	a4,0(a1)
 2fa:	00f71763          	bne	a4,a5,308 <strcmp+0x1e>
    p++, q++;
 2fe:	0505                	add	a0,a0,1
 300:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 302:	00054783          	lbu	a5,0(a0)
 306:	fbe5                	bnez	a5,2f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 308:	0005c503          	lbu	a0,0(a1)
}
 30c:	40a7853b          	subw	a0,a5,a0
 310:	6422                	ld	s0,8(sp)
 312:	0141                	add	sp,sp,16
 314:	8082                	ret

0000000000000316 <strlen>:

uint
strlen(const char *s)
{
 316:	1141                	add	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31c:	00054783          	lbu	a5,0(a0)
 320:	cf91                	beqz	a5,33c <strlen+0x26>
 322:	0505                	add	a0,a0,1
 324:	87aa                	mv	a5,a0
 326:	86be                	mv	a3,a5
 328:	0785                	add	a5,a5,1
 32a:	fff7c703          	lbu	a4,-1(a5)
 32e:	ff65                	bnez	a4,326 <strlen+0x10>
 330:	40a6853b          	subw	a0,a3,a0
 334:	2505                	addw	a0,a0,1
    ;
  return n;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	add	sp,sp,16
 33a:	8082                	ret
  for(n = 0; s[n]; n++)
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <strlen+0x20>

0000000000000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	1141                	add	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 346:	ca19                	beqz	a2,35c <memset+0x1c>
 348:	87aa                	mv	a5,a0
 34a:	1602                	sll	a2,a2,0x20
 34c:	9201                	srl	a2,a2,0x20
 34e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 352:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 356:	0785                	add	a5,a5,1
 358:	fee79de3          	bne	a5,a4,352 <memset+0x12>
  }
  return dst;
}
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	add	sp,sp,16
 360:	8082                	ret

0000000000000362 <strchr>:

char*
strchr(const char *s, char c)
{
 362:	1141                	add	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	add	s0,sp,16
  for(; *s; s++)
 368:	00054783          	lbu	a5,0(a0)
 36c:	cb99                	beqz	a5,382 <strchr+0x20>
    if(*s == c)
 36e:	00f58763          	beq	a1,a5,37c <strchr+0x1a>
  for(; *s; s++)
 372:	0505                	add	a0,a0,1
 374:	00054783          	lbu	a5,0(a0)
 378:	fbfd                	bnez	a5,36e <strchr+0xc>
      return (char*)s;
  return 0;
 37a:	4501                	li	a0,0
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	add	sp,sp,16
 380:	8082                	ret
  return 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <strchr+0x1a>

0000000000000386 <gets>:

char*
gets(char *buf, int max)
{
 386:	711d                	add	sp,sp,-96
 388:	ec86                	sd	ra,88(sp)
 38a:	e8a2                	sd	s0,80(sp)
 38c:	e4a6                	sd	s1,72(sp)
 38e:	e0ca                	sd	s2,64(sp)
 390:	fc4e                	sd	s3,56(sp)
 392:	f852                	sd	s4,48(sp)
 394:	f456                	sd	s5,40(sp)
 396:	f05a                	sd	s6,32(sp)
 398:	ec5e                	sd	s7,24(sp)
 39a:	1080                	add	s0,sp,96
 39c:	8baa                	mv	s7,a0
 39e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a0:	892a                	mv	s2,a0
 3a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a4:	4aa9                	li	s5,10
 3a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3a8:	89a6                	mv	s3,s1
 3aa:	2485                	addw	s1,s1,1
 3ac:	0344d863          	bge	s1,s4,3dc <gets+0x56>
    cc = read(0, &c, 1);
 3b0:	4605                	li	a2,1
 3b2:	faf40593          	add	a1,s0,-81
 3b6:	4501                	li	a0,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	19a080e7          	jalr	410(ra) # 552 <read>
    if(cc < 1)
 3c0:	00a05e63          	blez	a0,3dc <gets+0x56>
    buf[i++] = c;
 3c4:	faf44783          	lbu	a5,-81(s0)
 3c8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3cc:	01578763          	beq	a5,s5,3da <gets+0x54>
 3d0:	0905                	add	s2,s2,1
 3d2:	fd679be3          	bne	a5,s6,3a8 <gets+0x22>
  for(i=0; i+1 < max; ){
 3d6:	89a6                	mv	s3,s1
 3d8:	a011                	j	3dc <gets+0x56>
 3da:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3dc:	99de                	add	s3,s3,s7
 3de:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e2:	855e                	mv	a0,s7
 3e4:	60e6                	ld	ra,88(sp)
 3e6:	6446                	ld	s0,80(sp)
 3e8:	64a6                	ld	s1,72(sp)
 3ea:	6906                	ld	s2,64(sp)
 3ec:	79e2                	ld	s3,56(sp)
 3ee:	7a42                	ld	s4,48(sp)
 3f0:	7aa2                	ld	s5,40(sp)
 3f2:	7b02                	ld	s6,32(sp)
 3f4:	6be2                	ld	s7,24(sp)
 3f6:	6125                	add	sp,sp,96
 3f8:	8082                	ret

00000000000003fa <stat>:

int
stat(const char *n, struct stat *st)
{
 3fa:	1101                	add	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	e426                	sd	s1,8(sp)
 402:	e04a                	sd	s2,0(sp)
 404:	1000                	add	s0,sp,32
 406:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 408:	4581                	li	a1,0
 40a:	00000097          	auipc	ra,0x0
 40e:	170080e7          	jalr	368(ra) # 57a <open>
  if(fd < 0)
 412:	02054563          	bltz	a0,43c <stat+0x42>
 416:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 418:	85ca                	mv	a1,s2
 41a:	00000097          	auipc	ra,0x0
 41e:	178080e7          	jalr	376(ra) # 592 <fstat>
 422:	892a                	mv	s2,a0
  close(fd);
 424:	8526                	mv	a0,s1
 426:	00000097          	auipc	ra,0x0
 42a:	13c080e7          	jalr	316(ra) # 562 <close>
  return r;
}
 42e:	854a                	mv	a0,s2
 430:	60e2                	ld	ra,24(sp)
 432:	6442                	ld	s0,16(sp)
 434:	64a2                	ld	s1,8(sp)
 436:	6902                	ld	s2,0(sp)
 438:	6105                	add	sp,sp,32
 43a:	8082                	ret
    return -1;
 43c:	597d                	li	s2,-1
 43e:	bfc5                	j	42e <stat+0x34>

0000000000000440 <atoi>:

int
atoi(const char *s)
{
 440:	1141                	add	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 446:	00054683          	lbu	a3,0(a0)
 44a:	fd06879b          	addw	a5,a3,-48
 44e:	0ff7f793          	zext.b	a5,a5
 452:	4625                	li	a2,9
 454:	02f66863          	bltu	a2,a5,484 <atoi+0x44>
 458:	872a                	mv	a4,a0
  n = 0;
 45a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 45c:	0705                	add	a4,a4,1
 45e:	0025179b          	sllw	a5,a0,0x2
 462:	9fa9                	addw	a5,a5,a0
 464:	0017979b          	sllw	a5,a5,0x1
 468:	9fb5                	addw	a5,a5,a3
 46a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 46e:	00074683          	lbu	a3,0(a4)
 472:	fd06879b          	addw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	fef671e3          	bgeu	a2,a5,45c <atoi+0x1c>
  return n;
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	add	sp,sp,16
 482:	8082                	ret
  n = 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <atoi+0x3e>

0000000000000488 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 488:	1141                	add	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 48e:	02b57463          	bgeu	a0,a1,4b6 <memmove+0x2e>
    while(n-- > 0)
 492:	00c05f63          	blez	a2,4b0 <memmove+0x28>
 496:	1602                	sll	a2,a2,0x20
 498:	9201                	srl	a2,a2,0x20
 49a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 49e:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a0:	0585                	add	a1,a1,1
 4a2:	0705                	add	a4,a4,1
 4a4:	fff5c683          	lbu	a3,-1(a1)
 4a8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ac:	fee79ae3          	bne	a5,a4,4a0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	add	sp,sp,16
 4b4:	8082                	ret
    dst += n;
 4b6:	00c50733          	add	a4,a0,a2
    src += n;
 4ba:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4bc:	fec05ae3          	blez	a2,4b0 <memmove+0x28>
 4c0:	fff6079b          	addw	a5,a2,-1
 4c4:	1782                	sll	a5,a5,0x20
 4c6:	9381                	srl	a5,a5,0x20
 4c8:	fff7c793          	not	a5,a5
 4cc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ce:	15fd                	add	a1,a1,-1
 4d0:	177d                	add	a4,a4,-1
 4d2:	0005c683          	lbu	a3,0(a1)
 4d6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4da:	fee79ae3          	bne	a5,a4,4ce <memmove+0x46>
 4de:	bfc9                	j	4b0 <memmove+0x28>

00000000000004e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e0:	1141                	add	sp,sp,-16
 4e2:	e422                	sd	s0,8(sp)
 4e4:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4e6:	ca05                	beqz	a2,516 <memcmp+0x36>
 4e8:	fff6069b          	addw	a3,a2,-1
 4ec:	1682                	sll	a3,a3,0x20
 4ee:	9281                	srl	a3,a3,0x20
 4f0:	0685                	add	a3,a3,1
 4f2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4f4:	00054783          	lbu	a5,0(a0)
 4f8:	0005c703          	lbu	a4,0(a1)
 4fc:	00e79863          	bne	a5,a4,50c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 500:	0505                	add	a0,a0,1
    p2++;
 502:	0585                	add	a1,a1,1
  while (n-- > 0) {
 504:	fed518e3          	bne	a0,a3,4f4 <memcmp+0x14>
  }
  return 0;
 508:	4501                	li	a0,0
 50a:	a019                	j	510 <memcmp+0x30>
      return *p1 - *p2;
 50c:	40e7853b          	subw	a0,a5,a4
}
 510:	6422                	ld	s0,8(sp)
 512:	0141                	add	sp,sp,16
 514:	8082                	ret
  return 0;
 516:	4501                	li	a0,0
 518:	bfe5                	j	510 <memcmp+0x30>

000000000000051a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 51a:	1141                	add	sp,sp,-16
 51c:	e406                	sd	ra,8(sp)
 51e:	e022                	sd	s0,0(sp)
 520:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 522:	00000097          	auipc	ra,0x0
 526:	f66080e7          	jalr	-154(ra) # 488 <memmove>
}
 52a:	60a2                	ld	ra,8(sp)
 52c:	6402                	ld	s0,0(sp)
 52e:	0141                	add	sp,sp,16
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e2:	1101                	add	sp,sp,-32
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	add	s0,sp,32
 5ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ee:	4605                	li	a2,1
 5f0:	fef40593          	add	a1,s0,-17
 5f4:	00000097          	auipc	ra,0x0
 5f8:	f66080e7          	jalr	-154(ra) # 55a <write>
}
 5fc:	60e2                	ld	ra,24(sp)
 5fe:	6442                	ld	s0,16(sp)
 600:	6105                	add	sp,sp,32
 602:	8082                	ret

0000000000000604 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 604:	7139                	add	sp,sp,-64
 606:	fc06                	sd	ra,56(sp)
 608:	f822                	sd	s0,48(sp)
 60a:	f426                	sd	s1,40(sp)
 60c:	f04a                	sd	s2,32(sp)
 60e:	ec4e                	sd	s3,24(sp)
 610:	0080                	add	s0,sp,64
 612:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 614:	c299                	beqz	a3,61a <printint+0x16>
 616:	0805c963          	bltz	a1,6a8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61a:	2581                	sext.w	a1,a1
  neg = 0;
 61c:	4881                	li	a7,0
 61e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 622:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 624:	2601                	sext.w	a2,a2
 626:	00000517          	auipc	a0,0x0
 62a:	4f250513          	add	a0,a0,1266 # b18 <digits>
 62e:	883a                	mv	a6,a4
 630:	2705                	addw	a4,a4,1
 632:	02c5f7bb          	remuw	a5,a1,a2
 636:	1782                	sll	a5,a5,0x20
 638:	9381                	srl	a5,a5,0x20
 63a:	97aa                	add	a5,a5,a0
 63c:	0007c783          	lbu	a5,0(a5)
 640:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 644:	0005879b          	sext.w	a5,a1
 648:	02c5d5bb          	divuw	a1,a1,a2
 64c:	0685                	add	a3,a3,1
 64e:	fec7f0e3          	bgeu	a5,a2,62e <printint+0x2a>
  if(neg)
 652:	00088c63          	beqz	a7,66a <printint+0x66>
    buf[i++] = '-';
 656:	fd070793          	add	a5,a4,-48
 65a:	00878733          	add	a4,a5,s0
 65e:	02d00793          	li	a5,45
 662:	fef70823          	sb	a5,-16(a4)
 666:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 66a:	02e05863          	blez	a4,69a <printint+0x96>
 66e:	fc040793          	add	a5,s0,-64
 672:	00e78933          	add	s2,a5,a4
 676:	fff78993          	add	s3,a5,-1
 67a:	99ba                	add	s3,s3,a4
 67c:	377d                	addw	a4,a4,-1
 67e:	1702                	sll	a4,a4,0x20
 680:	9301                	srl	a4,a4,0x20
 682:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 686:	fff94583          	lbu	a1,-1(s2)
 68a:	8526                	mv	a0,s1
 68c:	00000097          	auipc	ra,0x0
 690:	f56080e7          	jalr	-170(ra) # 5e2 <putc>
  while(--i >= 0)
 694:	197d                	add	s2,s2,-1
 696:	ff3918e3          	bne	s2,s3,686 <printint+0x82>
}
 69a:	70e2                	ld	ra,56(sp)
 69c:	7442                	ld	s0,48(sp)
 69e:	74a2                	ld	s1,40(sp)
 6a0:	7902                	ld	s2,32(sp)
 6a2:	69e2                	ld	s3,24(sp)
 6a4:	6121                	add	sp,sp,64
 6a6:	8082                	ret
    x = -xx;
 6a8:	40b005bb          	negw	a1,a1
    neg = 1;
 6ac:	4885                	li	a7,1
    x = -xx;
 6ae:	bf85                	j	61e <printint+0x1a>

00000000000006b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b0:	715d                	add	sp,sp,-80
 6b2:	e486                	sd	ra,72(sp)
 6b4:	e0a2                	sd	s0,64(sp)
 6b6:	fc26                	sd	s1,56(sp)
 6b8:	f84a                	sd	s2,48(sp)
 6ba:	f44e                	sd	s3,40(sp)
 6bc:	f052                	sd	s4,32(sp)
 6be:	ec56                	sd	s5,24(sp)
 6c0:	e85a                	sd	s6,16(sp)
 6c2:	e45e                	sd	s7,8(sp)
 6c4:	e062                	sd	s8,0(sp)
 6c6:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c8:	0005c903          	lbu	s2,0(a1)
 6cc:	18090c63          	beqz	s2,864 <vprintf+0x1b4>
 6d0:	8aaa                	mv	s5,a0
 6d2:	8bb2                	mv	s7,a2
 6d4:	00158493          	add	s1,a1,1
  state = 0;
 6d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6da:	02500a13          	li	s4,37
 6de:	4b55                	li	s6,21
 6e0:	a839                	j	6fe <vprintf+0x4e>
        putc(fd, c);
 6e2:	85ca                	mv	a1,s2
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	efc080e7          	jalr	-260(ra) # 5e2 <putc>
 6ee:	a019                	j	6f4 <vprintf+0x44>
    } else if(state == '%'){
 6f0:	01498d63          	beq	s3,s4,70a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6f4:	0485                	add	s1,s1,1
 6f6:	fff4c903          	lbu	s2,-1(s1)
 6fa:	16090563          	beqz	s2,864 <vprintf+0x1b4>
    if(state == 0){
 6fe:	fe0999e3          	bnez	s3,6f0 <vprintf+0x40>
      if(c == '%'){
 702:	ff4910e3          	bne	s2,s4,6e2 <vprintf+0x32>
        state = '%';
 706:	89d2                	mv	s3,s4
 708:	b7f5                	j	6f4 <vprintf+0x44>
      if(c == 'd'){
 70a:	13490263          	beq	s2,s4,82e <vprintf+0x17e>
 70e:	f9d9079b          	addw	a5,s2,-99
 712:	0ff7f793          	zext.b	a5,a5
 716:	12fb6563          	bltu	s6,a5,840 <vprintf+0x190>
 71a:	f9d9079b          	addw	a5,s2,-99
 71e:	0ff7f713          	zext.b	a4,a5
 722:	10eb6f63          	bltu	s6,a4,840 <vprintf+0x190>
 726:	00271793          	sll	a5,a4,0x2
 72a:	00000717          	auipc	a4,0x0
 72e:	39670713          	add	a4,a4,918 # ac0 <malloc+0x15e>
 732:	97ba                	add	a5,a5,a4
 734:	439c                	lw	a5,0(a5)
 736:	97ba                	add	a5,a5,a4
 738:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 73a:	008b8913          	add	s2,s7,8
 73e:	4685                	li	a3,1
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	ebc080e7          	jalr	-324(ra) # 604 <printint>
 750:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 752:	4981                	li	s3,0
 754:	b745                	j	6f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	add	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	ea0080e7          	jalr	-352(ra) # 604 <printint>
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	b751                	j	6f4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 772:	008b8913          	add	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000ba583          	lw	a1,0(s7)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e84080e7          	jalr	-380(ra) # 604 <printint>
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b7a5                	j	6f4 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 78e:	008b8c13          	add	s8,s7,8
 792:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 796:	03000593          	li	a1,48
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e46080e7          	jalr	-442(ra) # 5e2 <putc>
  putc(fd, 'x');
 7a4:	07800593          	li	a1,120
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e38080e7          	jalr	-456(ra) # 5e2 <putc>
 7b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b4:	00000b97          	auipc	s7,0x0
 7b8:	364b8b93          	add	s7,s7,868 # b18 <digits>
 7bc:	03c9d793          	srl	a5,s3,0x3c
 7c0:	97de                	add	a5,a5,s7
 7c2:	0007c583          	lbu	a1,0(a5)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e1a080e7          	jalr	-486(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d0:	0992                	sll	s3,s3,0x4
 7d2:	397d                	addw	s2,s2,-1
 7d4:	fe0914e3          	bnez	s2,7bc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7d8:	8be2                	mv	s7,s8
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bf21                	j	6f4 <vprintf+0x44>
        s = va_arg(ap, char*);
 7de:	008b8993          	add	s3,s7,8
 7e2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7e6:	02090163          	beqz	s2,808 <vprintf+0x158>
        while(*s != 0){
 7ea:	00094583          	lbu	a1,0(s2)
 7ee:	c9a5                	beqz	a1,85e <vprintf+0x1ae>
          putc(fd, *s);
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	df0080e7          	jalr	-528(ra) # 5e2 <putc>
          s++;
 7fa:	0905                	add	s2,s2,1
        while(*s != 0){
 7fc:	00094583          	lbu	a1,0(s2)
 800:	f9e5                	bnez	a1,7f0 <vprintf+0x140>
        s = va_arg(ap, char*);
 802:	8bce                	mv	s7,s3
      state = 0;
 804:	4981                	li	s3,0
 806:	b5fd                	j	6f4 <vprintf+0x44>
          s = "(null)";
 808:	00000917          	auipc	s2,0x0
 80c:	2b090913          	add	s2,s2,688 # ab8 <malloc+0x156>
        while(*s != 0){
 810:	02800593          	li	a1,40
 814:	bff1                	j	7f0 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 816:	008b8913          	add	s2,s7,8
 81a:	000bc583          	lbu	a1,0(s7)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	dc2080e7          	jalr	-574(ra) # 5e2 <putc>
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b5e1                	j	6f4 <vprintf+0x44>
        putc(fd, c);
 82e:	02500593          	li	a1,37
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	dae080e7          	jalr	-594(ra) # 5e2 <putc>
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bd5d                	j	6f4 <vprintf+0x44>
        putc(fd, '%');
 840:	02500593          	li	a1,37
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	d9c080e7          	jalr	-612(ra) # 5e2 <putc>
        putc(fd, c);
 84e:	85ca                	mv	a1,s2
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	d90080e7          	jalr	-624(ra) # 5e2 <putc>
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bd61                	j	6f4 <vprintf+0x44>
        s = va_arg(ap, char*);
 85e:	8bce                	mv	s7,s3
      state = 0;
 860:	4981                	li	s3,0
 862:	bd49                	j	6f4 <vprintf+0x44>
    }
  }
}
 864:	60a6                	ld	ra,72(sp)
 866:	6406                	ld	s0,64(sp)
 868:	74e2                	ld	s1,56(sp)
 86a:	7942                	ld	s2,48(sp)
 86c:	79a2                	ld	s3,40(sp)
 86e:	7a02                	ld	s4,32(sp)
 870:	6ae2                	ld	s5,24(sp)
 872:	6b42                	ld	s6,16(sp)
 874:	6ba2                	ld	s7,8(sp)
 876:	6c02                	ld	s8,0(sp)
 878:	6161                	add	sp,sp,80
 87a:	8082                	ret

000000000000087c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 87c:	715d                	add	sp,sp,-80
 87e:	ec06                	sd	ra,24(sp)
 880:	e822                	sd	s0,16(sp)
 882:	1000                	add	s0,sp,32
 884:	e010                	sd	a2,0(s0)
 886:	e414                	sd	a3,8(s0)
 888:	e818                	sd	a4,16(s0)
 88a:	ec1c                	sd	a5,24(s0)
 88c:	03043023          	sd	a6,32(s0)
 890:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 894:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 898:	8622                	mv	a2,s0
 89a:	00000097          	auipc	ra,0x0
 89e:	e16080e7          	jalr	-490(ra) # 6b0 <vprintf>
}
 8a2:	60e2                	ld	ra,24(sp)
 8a4:	6442                	ld	s0,16(sp)
 8a6:	6161                	add	sp,sp,80
 8a8:	8082                	ret

00000000000008aa <printf>:

void
printf(const char *fmt, ...)
{
 8aa:	711d                	add	sp,sp,-96
 8ac:	ec06                	sd	ra,24(sp)
 8ae:	e822                	sd	s0,16(sp)
 8b0:	1000                	add	s0,sp,32
 8b2:	e40c                	sd	a1,8(s0)
 8b4:	e810                	sd	a2,16(s0)
 8b6:	ec14                	sd	a3,24(s0)
 8b8:	f018                	sd	a4,32(s0)
 8ba:	f41c                	sd	a5,40(s0)
 8bc:	03043823          	sd	a6,48(s0)
 8c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c4:	00840613          	add	a2,s0,8
 8c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8cc:	85aa                	mv	a1,a0
 8ce:	4505                	li	a0,1
 8d0:	00000097          	auipc	ra,0x0
 8d4:	de0080e7          	jalr	-544(ra) # 6b0 <vprintf>
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	6125                	add	sp,sp,96
 8de:	8082                	ret

00000000000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	1141                	add	sp,sp,-16
 8e2:	e422                	sd	s0,8(sp)
 8e4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ea:	00000797          	auipc	a5,0x0
 8ee:	2467b783          	ld	a5,582(a5) # b30 <freep>
 8f2:	a02d                	j	91c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f4:	4618                	lw	a4,8(a2)
 8f6:	9f2d                	addw	a4,a4,a1
 8f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fc:	6398                	ld	a4,0(a5)
 8fe:	6310                	ld	a2,0(a4)
 900:	a83d                	j	93e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 902:	ff852703          	lw	a4,-8(a0)
 906:	9f31                	addw	a4,a4,a2
 908:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90a:	ff053683          	ld	a3,-16(a0)
 90e:	a091                	j	952 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	6398                	ld	a4,0(a5)
 912:	00e7e463          	bltu	a5,a4,91a <free+0x3a>
 916:	00e6ea63          	bltu	a3,a4,92a <free+0x4a>
{
 91a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	fed7fae3          	bgeu	a5,a3,910 <free+0x30>
 920:	6398                	ld	a4,0(a5)
 922:	00e6e463          	bltu	a3,a4,92a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	fee7eae3          	bltu	a5,a4,91a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 92a:	ff852583          	lw	a1,-8(a0)
 92e:	6390                	ld	a2,0(a5)
 930:	02059813          	sll	a6,a1,0x20
 934:	01c85713          	srl	a4,a6,0x1c
 938:	9736                	add	a4,a4,a3
 93a:	fae60de3          	beq	a2,a4,8f4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 93e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 942:	4790                	lw	a2,8(a5)
 944:	02061593          	sll	a1,a2,0x20
 948:	01c5d713          	srl	a4,a1,0x1c
 94c:	973e                	add	a4,a4,a5
 94e:	fae68ae3          	beq	a3,a4,902 <free+0x22>
    p->s.ptr = bp->s.ptr;
 952:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 954:	00000717          	auipc	a4,0x0
 958:	1cf73e23          	sd	a5,476(a4) # b30 <freep>
}
 95c:	6422                	ld	s0,8(sp)
 95e:	0141                	add	sp,sp,16
 960:	8082                	ret

0000000000000962 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 962:	7139                	add	sp,sp,-64
 964:	fc06                	sd	ra,56(sp)
 966:	f822                	sd	s0,48(sp)
 968:	f426                	sd	s1,40(sp)
 96a:	f04a                	sd	s2,32(sp)
 96c:	ec4e                	sd	s3,24(sp)
 96e:	e852                	sd	s4,16(sp)
 970:	e456                	sd	s5,8(sp)
 972:	e05a                	sd	s6,0(sp)
 974:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 976:	02051493          	sll	s1,a0,0x20
 97a:	9081                	srl	s1,s1,0x20
 97c:	04bd                	add	s1,s1,15
 97e:	8091                	srl	s1,s1,0x4
 980:	0014899b          	addw	s3,s1,1
 984:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 986:	00000517          	auipc	a0,0x0
 98a:	1aa53503          	ld	a0,426(a0) # b30 <freep>
 98e:	c515                	beqz	a0,9ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 992:	4798                	lw	a4,8(a5)
 994:	02977f63          	bgeu	a4,s1,9d2 <malloc+0x70>
  if(nu < 4096)
 998:	8a4e                	mv	s4,s3
 99a:	0009871b          	sext.w	a4,s3
 99e:	6685                	lui	a3,0x1
 9a0:	00d77363          	bgeu	a4,a3,9a6 <malloc+0x44>
 9a4:	6a05                	lui	s4,0x1
 9a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9aa:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ae:	00000917          	auipc	s2,0x0
 9b2:	18290913          	add	s2,s2,386 # b30 <freep>
  if(p == (char*)-1)
 9b6:	5afd                	li	s5,-1
 9b8:	a895                	j	a2c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9ba:	00000797          	auipc	a5,0x0
 9be:	18e78793          	add	a5,a5,398 # b48 <base>
 9c2:	00000717          	auipc	a4,0x0
 9c6:	16f73723          	sd	a5,366(a4) # b30 <freep>
 9ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d0:	b7e1                	j	998 <malloc+0x36>
      if(p->s.size == nunits)
 9d2:	02e48c63          	beq	s1,a4,a0a <malloc+0xa8>
        p->s.size -= nunits;
 9d6:	4137073b          	subw	a4,a4,s3
 9da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9dc:	02071693          	sll	a3,a4,0x20
 9e0:	01c6d713          	srl	a4,a3,0x1c
 9e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ea:	00000717          	auipc	a4,0x0
 9ee:	14a73323          	sd	a0,326(a4) # b30 <freep>
      return (void*)(p + 1);
 9f2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f6:	70e2                	ld	ra,56(sp)
 9f8:	7442                	ld	s0,48(sp)
 9fa:	74a2                	ld	s1,40(sp)
 9fc:	7902                	ld	s2,32(sp)
 9fe:	69e2                	ld	s3,24(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
 a06:	6121                	add	sp,sp,64
 a08:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a0a:	6398                	ld	a4,0(a5)
 a0c:	e118                	sd	a4,0(a0)
 a0e:	bff1                	j	9ea <malloc+0x88>
  hp->s.size = nu;
 a10:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a14:	0541                	add	a0,a0,16
 a16:	00000097          	auipc	ra,0x0
 a1a:	eca080e7          	jalr	-310(ra) # 8e0 <free>
  return freep;
 a1e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a22:	d971                	beqz	a0,9f6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a26:	4798                	lw	a4,8(a5)
 a28:	fa9775e3          	bgeu	a4,s1,9d2 <malloc+0x70>
    if(p == freep)
 a2c:	00093703          	ld	a4,0(s2)
 a30:	853e                	mv	a0,a5
 a32:	fef719e3          	bne	a4,a5,a24 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a36:	8552                	mv	a0,s4
 a38:	00000097          	auipc	ra,0x0
 a3c:	b8a080e7          	jalr	-1142(ra) # 5c2 <sbrk>
  if(p == (char*)-1)
 a40:	fd5518e3          	bne	a0,s5,a10 <malloc+0xae>
        return 0;
 a44:	4501                	li	a0,0
 a46:	bf45                	j	9f6 <malloc+0x94>
