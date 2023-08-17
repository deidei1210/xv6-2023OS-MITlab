
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
  6a:	ada98993          	add	s3,s3,-1318 # b40 <buf.0>
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
 124:	96050513          	add	a0,a0,-1696 # a80 <malloc+0x116>
 128:	00000097          	auipc	ra,0x0
 12c:	78a080e7          	jalr	1930(ra) # 8b2 <printf>
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
 162:	8f258593          	add	a1,a1,-1806 # a50 <malloc+0xe6>
 166:	4509                	li	a0,2
 168:	00000097          	auipc	ra,0x0
 16c:	71c080e7          	jalr	1820(ra) # 884 <fprintf>
    return;
 170:	b7e9                	j	13a <ls+0x86>
    fprintf(2, "ls: cannot stat %s\n", path);
 172:	864a                	mv	a2,s2
 174:	00001597          	auipc	a1,0x1
 178:	8f458593          	add	a1,a1,-1804 # a68 <malloc+0xfe>
 17c:	4509                	li	a0,2
 17e:	00000097          	auipc	ra,0x0
 182:	706080e7          	jalr	1798(ra) # 884 <fprintf>
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
 1aa:	8ea50513          	add	a0,a0,-1814 # a90 <malloc+0x126>
 1ae:	00000097          	auipc	ra,0x0
 1b2:	704080e7          	jalr	1796(ra) # 8b2 <printf>
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
 1ee:	8bea0a13          	add	s4,s4,-1858 # aa8 <malloc+0x13e>
        printf("ls: cannot stat %s\n", buf);
 1f2:	00001a97          	auipc	s5,0x1
 1f6:	876a8a93          	add	s5,s5,-1930 # a68 <malloc+0xfe>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fa:	a801                	j	20a <ls+0x156>
        printf("ls: cannot stat %s\n", buf);
 1fc:	dc040593          	add	a1,s0,-576
 200:	8556                	mv	a0,s5
 202:	00000097          	auipc	ra,0x0
 206:	6b0080e7          	jalr	1712(ra) # 8b2 <printf>
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
 26e:	648080e7          	jalr	1608(ra) # 8b2 <printf>
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
 2b4:	00001517          	auipc	a0,0x1
 2b8:	80450513          	add	a0,a0,-2044 # ab8 <malloc+0x14e>
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

00000000000005da <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 5e2:	48dd                	li	a7,23
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ea:	1101                	add	sp,sp,-32
 5ec:	ec06                	sd	ra,24(sp)
 5ee:	e822                	sd	s0,16(sp)
 5f0:	1000                	add	s0,sp,32
 5f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f6:	4605                	li	a2,1
 5f8:	fef40593          	add	a1,s0,-17
 5fc:	00000097          	auipc	ra,0x0
 600:	f5e080e7          	jalr	-162(ra) # 55a <write>
}
 604:	60e2                	ld	ra,24(sp)
 606:	6442                	ld	s0,16(sp)
 608:	6105                	add	sp,sp,32
 60a:	8082                	ret

000000000000060c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60c:	7139                	add	sp,sp,-64
 60e:	fc06                	sd	ra,56(sp)
 610:	f822                	sd	s0,48(sp)
 612:	f426                	sd	s1,40(sp)
 614:	f04a                	sd	s2,32(sp)
 616:	ec4e                	sd	s3,24(sp)
 618:	0080                	add	s0,sp,64
 61a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 61c:	c299                	beqz	a3,622 <printint+0x16>
 61e:	0805c963          	bltz	a1,6b0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 622:	2581                	sext.w	a1,a1
  neg = 0;
 624:	4881                	li	a7,0
 626:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 62a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 62c:	2601                	sext.w	a2,a2
 62e:	00000517          	auipc	a0,0x0
 632:	4f250513          	add	a0,a0,1266 # b20 <digits>
 636:	883a                	mv	a6,a4
 638:	2705                	addw	a4,a4,1
 63a:	02c5f7bb          	remuw	a5,a1,a2
 63e:	1782                	sll	a5,a5,0x20
 640:	9381                	srl	a5,a5,0x20
 642:	97aa                	add	a5,a5,a0
 644:	0007c783          	lbu	a5,0(a5)
 648:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 64c:	0005879b          	sext.w	a5,a1
 650:	02c5d5bb          	divuw	a1,a1,a2
 654:	0685                	add	a3,a3,1
 656:	fec7f0e3          	bgeu	a5,a2,636 <printint+0x2a>
  if(neg)
 65a:	00088c63          	beqz	a7,672 <printint+0x66>
    buf[i++] = '-';
 65e:	fd070793          	add	a5,a4,-48
 662:	00878733          	add	a4,a5,s0
 666:	02d00793          	li	a5,45
 66a:	fef70823          	sb	a5,-16(a4)
 66e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 672:	02e05863          	blez	a4,6a2 <printint+0x96>
 676:	fc040793          	add	a5,s0,-64
 67a:	00e78933          	add	s2,a5,a4
 67e:	fff78993          	add	s3,a5,-1
 682:	99ba                	add	s3,s3,a4
 684:	377d                	addw	a4,a4,-1
 686:	1702                	sll	a4,a4,0x20
 688:	9301                	srl	a4,a4,0x20
 68a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 68e:	fff94583          	lbu	a1,-1(s2)
 692:	8526                	mv	a0,s1
 694:	00000097          	auipc	ra,0x0
 698:	f56080e7          	jalr	-170(ra) # 5ea <putc>
  while(--i >= 0)
 69c:	197d                	add	s2,s2,-1
 69e:	ff3918e3          	bne	s2,s3,68e <printint+0x82>
}
 6a2:	70e2                	ld	ra,56(sp)
 6a4:	7442                	ld	s0,48(sp)
 6a6:	74a2                	ld	s1,40(sp)
 6a8:	7902                	ld	s2,32(sp)
 6aa:	69e2                	ld	s3,24(sp)
 6ac:	6121                	add	sp,sp,64
 6ae:	8082                	ret
    x = -xx;
 6b0:	40b005bb          	negw	a1,a1
    neg = 1;
 6b4:	4885                	li	a7,1
    x = -xx;
 6b6:	bf85                	j	626 <printint+0x1a>

00000000000006b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b8:	715d                	add	sp,sp,-80
 6ba:	e486                	sd	ra,72(sp)
 6bc:	e0a2                	sd	s0,64(sp)
 6be:	fc26                	sd	s1,56(sp)
 6c0:	f84a                	sd	s2,48(sp)
 6c2:	f44e                	sd	s3,40(sp)
 6c4:	f052                	sd	s4,32(sp)
 6c6:	ec56                	sd	s5,24(sp)
 6c8:	e85a                	sd	s6,16(sp)
 6ca:	e45e                	sd	s7,8(sp)
 6cc:	e062                	sd	s8,0(sp)
 6ce:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d0:	0005c903          	lbu	s2,0(a1)
 6d4:	18090c63          	beqz	s2,86c <vprintf+0x1b4>
 6d8:	8aaa                	mv	s5,a0
 6da:	8bb2                	mv	s7,a2
 6dc:	00158493          	add	s1,a1,1
  state = 0;
 6e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e2:	02500a13          	li	s4,37
 6e6:	4b55                	li	s6,21
 6e8:	a839                	j	706 <vprintf+0x4e>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	efc080e7          	jalr	-260(ra) # 5ea <putc>
 6f6:	a019                	j	6fc <vprintf+0x44>
    } else if(state == '%'){
 6f8:	01498d63          	beq	s3,s4,712 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6fc:	0485                	add	s1,s1,1
 6fe:	fff4c903          	lbu	s2,-1(s1)
 702:	16090563          	beqz	s2,86c <vprintf+0x1b4>
    if(state == 0){
 706:	fe0999e3          	bnez	s3,6f8 <vprintf+0x40>
      if(c == '%'){
 70a:	ff4910e3          	bne	s2,s4,6ea <vprintf+0x32>
        state = '%';
 70e:	89d2                	mv	s3,s4
 710:	b7f5                	j	6fc <vprintf+0x44>
      if(c == 'd'){
 712:	13490263          	beq	s2,s4,836 <vprintf+0x17e>
 716:	f9d9079b          	addw	a5,s2,-99
 71a:	0ff7f793          	zext.b	a5,a5
 71e:	12fb6563          	bltu	s6,a5,848 <vprintf+0x190>
 722:	f9d9079b          	addw	a5,s2,-99
 726:	0ff7f713          	zext.b	a4,a5
 72a:	10eb6f63          	bltu	s6,a4,848 <vprintf+0x190>
 72e:	00271793          	sll	a5,a4,0x2
 732:	00000717          	auipc	a4,0x0
 736:	39670713          	add	a4,a4,918 # ac8 <malloc+0x15e>
 73a:	97ba                	add	a5,a5,a4
 73c:	439c                	lw	a5,0(a5)
 73e:	97ba                	add	a5,a5,a4
 740:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 742:	008b8913          	add	s2,s7,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	ebc080e7          	jalr	-324(ra) # 60c <printint>
 758:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b745                	j	6fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b8913          	add	s2,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	ea0080e7          	jalr	-352(ra) # 60c <printint>
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	b751                	j	6fc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 77a:	008b8913          	add	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000ba583          	lw	a1,0(s7)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e84080e7          	jalr	-380(ra) # 60c <printint>
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
 794:	b7a5                	j	6fc <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 796:	008b8c13          	add	s8,s7,8
 79a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 79e:	03000593          	li	a1,48
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e46080e7          	jalr	-442(ra) # 5ea <putc>
  putc(fd, 'x');
 7ac:	07800593          	li	a1,120
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e38080e7          	jalr	-456(ra) # 5ea <putc>
 7ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	364b8b93          	add	s7,s7,868 # b20 <digits>
 7c4:	03c9d793          	srl	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e1a080e7          	jalr	-486(ra) # 5ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d8:	0992                	sll	s3,s3,0x4
 7da:	397d                	addw	s2,s2,-1
 7dc:	fe0914e3          	bnez	s2,7c4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7e0:	8be2                	mv	s7,s8
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bf21                	j	6fc <vprintf+0x44>
        s = va_arg(ap, char*);
 7e6:	008b8993          	add	s3,s7,8
 7ea:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7ee:	02090163          	beqz	s2,810 <vprintf+0x158>
        while(*s != 0){
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	c9a5                	beqz	a1,866 <vprintf+0x1ae>
          putc(fd, *s);
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	df0080e7          	jalr	-528(ra) # 5ea <putc>
          s++;
 802:	0905                	add	s2,s2,1
        while(*s != 0){
 804:	00094583          	lbu	a1,0(s2)
 808:	f9e5                	bnez	a1,7f8 <vprintf+0x140>
        s = va_arg(ap, char*);
 80a:	8bce                	mv	s7,s3
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b5fd                	j	6fc <vprintf+0x44>
          s = "(null)";
 810:	00000917          	auipc	s2,0x0
 814:	2b090913          	add	s2,s2,688 # ac0 <malloc+0x156>
        while(*s != 0){
 818:	02800593          	li	a1,40
 81c:	bff1                	j	7f8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 81e:	008b8913          	add	s2,s7,8
 822:	000bc583          	lbu	a1,0(s7)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	dc2080e7          	jalr	-574(ra) # 5ea <putc>
 830:	8bca                	mv	s7,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	b5e1                	j	6fc <vprintf+0x44>
        putc(fd, c);
 836:	02500593          	li	a1,37
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	dae080e7          	jalr	-594(ra) # 5ea <putc>
      state = 0;
 844:	4981                	li	s3,0
 846:	bd5d                	j	6fc <vprintf+0x44>
        putc(fd, '%');
 848:	02500593          	li	a1,37
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	d9c080e7          	jalr	-612(ra) # 5ea <putc>
        putc(fd, c);
 856:	85ca                	mv	a1,s2
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	d90080e7          	jalr	-624(ra) # 5ea <putc>
      state = 0;
 862:	4981                	li	s3,0
 864:	bd61                	j	6fc <vprintf+0x44>
        s = va_arg(ap, char*);
 866:	8bce                	mv	s7,s3
      state = 0;
 868:	4981                	li	s3,0
 86a:	bd49                	j	6fc <vprintf+0x44>
    }
  }
}
 86c:	60a6                	ld	ra,72(sp)
 86e:	6406                	ld	s0,64(sp)
 870:	74e2                	ld	s1,56(sp)
 872:	7942                	ld	s2,48(sp)
 874:	79a2                	ld	s3,40(sp)
 876:	7a02                	ld	s4,32(sp)
 878:	6ae2                	ld	s5,24(sp)
 87a:	6b42                	ld	s6,16(sp)
 87c:	6ba2                	ld	s7,8(sp)
 87e:	6c02                	ld	s8,0(sp)
 880:	6161                	add	sp,sp,80
 882:	8082                	ret

0000000000000884 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 884:	715d                	add	sp,sp,-80
 886:	ec06                	sd	ra,24(sp)
 888:	e822                	sd	s0,16(sp)
 88a:	1000                	add	s0,sp,32
 88c:	e010                	sd	a2,0(s0)
 88e:	e414                	sd	a3,8(s0)
 890:	e818                	sd	a4,16(s0)
 892:	ec1c                	sd	a5,24(s0)
 894:	03043023          	sd	a6,32(s0)
 898:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 89c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a0:	8622                	mv	a2,s0
 8a2:	00000097          	auipc	ra,0x0
 8a6:	e16080e7          	jalr	-490(ra) # 6b8 <vprintf>
}
 8aa:	60e2                	ld	ra,24(sp)
 8ac:	6442                	ld	s0,16(sp)
 8ae:	6161                	add	sp,sp,80
 8b0:	8082                	ret

00000000000008b2 <printf>:

void
printf(const char *fmt, ...)
{
 8b2:	711d                	add	sp,sp,-96
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	add	s0,sp,32
 8ba:	e40c                	sd	a1,8(s0)
 8bc:	e810                	sd	a2,16(s0)
 8be:	ec14                	sd	a3,24(s0)
 8c0:	f018                	sd	a4,32(s0)
 8c2:	f41c                	sd	a5,40(s0)
 8c4:	03043823          	sd	a6,48(s0)
 8c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	00840613          	add	a2,s0,8
 8d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d4:	85aa                	mv	a1,a0
 8d6:	4505                	li	a0,1
 8d8:	00000097          	auipc	ra,0x0
 8dc:	de0080e7          	jalr	-544(ra) # 6b8 <vprintf>
}
 8e0:	60e2                	ld	ra,24(sp)
 8e2:	6442                	ld	s0,16(sp)
 8e4:	6125                	add	sp,sp,96
 8e6:	8082                	ret

00000000000008e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e8:	1141                	add	sp,sp,-16
 8ea:	e422                	sd	s0,8(sp)
 8ec:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ee:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f2:	00000797          	auipc	a5,0x0
 8f6:	2467b783          	ld	a5,582(a5) # b38 <freep>
 8fa:	a02d                	j	924 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8fc:	4618                	lw	a4,8(a2)
 8fe:	9f2d                	addw	a4,a4,a1
 900:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 904:	6398                	ld	a4,0(a5)
 906:	6310                	ld	a2,0(a4)
 908:	a83d                	j	946 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 90a:	ff852703          	lw	a4,-8(a0)
 90e:	9f31                	addw	a4,a4,a2
 910:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 912:	ff053683          	ld	a3,-16(a0)
 916:	a091                	j	95a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	6398                	ld	a4,0(a5)
 91a:	00e7e463          	bltu	a5,a4,922 <free+0x3a>
 91e:	00e6ea63          	bltu	a3,a4,932 <free+0x4a>
{
 922:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 924:	fed7fae3          	bgeu	a5,a3,918 <free+0x30>
 928:	6398                	ld	a4,0(a5)
 92a:	00e6e463          	bltu	a3,a4,932 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92e:	fee7eae3          	bltu	a5,a4,922 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 932:	ff852583          	lw	a1,-8(a0)
 936:	6390                	ld	a2,0(a5)
 938:	02059813          	sll	a6,a1,0x20
 93c:	01c85713          	srl	a4,a6,0x1c
 940:	9736                	add	a4,a4,a3
 942:	fae60de3          	beq	a2,a4,8fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 94a:	4790                	lw	a2,8(a5)
 94c:	02061593          	sll	a1,a2,0x20
 950:	01c5d713          	srl	a4,a1,0x1c
 954:	973e                	add	a4,a4,a5
 956:	fae68ae3          	beq	a3,a4,90a <free+0x22>
    p->s.ptr = bp->s.ptr;
 95a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95c:	00000717          	auipc	a4,0x0
 960:	1cf73e23          	sd	a5,476(a4) # b38 <freep>
}
 964:	6422                	ld	s0,8(sp)
 966:	0141                	add	sp,sp,16
 968:	8082                	ret

000000000000096a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96a:	7139                	add	sp,sp,-64
 96c:	fc06                	sd	ra,56(sp)
 96e:	f822                	sd	s0,48(sp)
 970:	f426                	sd	s1,40(sp)
 972:	f04a                	sd	s2,32(sp)
 974:	ec4e                	sd	s3,24(sp)
 976:	e852                	sd	s4,16(sp)
 978:	e456                	sd	s5,8(sp)
 97a:	e05a                	sd	s6,0(sp)
 97c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97e:	02051493          	sll	s1,a0,0x20
 982:	9081                	srl	s1,s1,0x20
 984:	04bd                	add	s1,s1,15
 986:	8091                	srl	s1,s1,0x4
 988:	0014899b          	addw	s3,s1,1
 98c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 98e:	00000517          	auipc	a0,0x0
 992:	1aa53503          	ld	a0,426(a0) # b38 <freep>
 996:	c515                	beqz	a0,9c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99a:	4798                	lw	a4,8(a5)
 99c:	02977f63          	bgeu	a4,s1,9da <malloc+0x70>
  if(nu < 4096)
 9a0:	8a4e                	mv	s4,s3
 9a2:	0009871b          	sext.w	a4,s3
 9a6:	6685                	lui	a3,0x1
 9a8:	00d77363          	bgeu	a4,a3,9ae <malloc+0x44>
 9ac:	6a05                	lui	s4,0x1
 9ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b2:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b6:	00000917          	auipc	s2,0x0
 9ba:	18290913          	add	s2,s2,386 # b38 <freep>
  if(p == (char*)-1)
 9be:	5afd                	li	s5,-1
 9c0:	a895                	j	a34 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9c2:	00000797          	auipc	a5,0x0
 9c6:	18e78793          	add	a5,a5,398 # b50 <base>
 9ca:	00000717          	auipc	a4,0x0
 9ce:	16f73723          	sd	a5,366(a4) # b38 <freep>
 9d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d8:	b7e1                	j	9a0 <malloc+0x36>
      if(p->s.size == nunits)
 9da:	02e48c63          	beq	s1,a4,a12 <malloc+0xa8>
        p->s.size -= nunits;
 9de:	4137073b          	subw	a4,a4,s3
 9e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e4:	02071693          	sll	a3,a4,0x20
 9e8:	01c6d713          	srl	a4,a3,0x1c
 9ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	14a73323          	sd	a0,326(a4) # b38 <freep>
      return (void*)(p + 1);
 9fa:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9fe:	70e2                	ld	ra,56(sp)
 a00:	7442                	ld	s0,48(sp)
 a02:	74a2                	ld	s1,40(sp)
 a04:	7902                	ld	s2,32(sp)
 a06:	69e2                	ld	s3,24(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	6121                	add	sp,sp,64
 a10:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a12:	6398                	ld	a4,0(a5)
 a14:	e118                	sd	a4,0(a0)
 a16:	bff1                	j	9f2 <malloc+0x88>
  hp->s.size = nu;
 a18:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1c:	0541                	add	a0,a0,16
 a1e:	00000097          	auipc	ra,0x0
 a22:	eca080e7          	jalr	-310(ra) # 8e8 <free>
  return freep;
 a26:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a2a:	d971                	beqz	a0,9fe <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2e:	4798                	lw	a4,8(a5)
 a30:	fa9775e3          	bgeu	a4,s1,9da <malloc+0x70>
    if(p == freep)
 a34:	00093703          	ld	a4,0(s2)
 a38:	853e                	mv	a0,a5
 a3a:	fef719e3          	bne	a4,a5,a2c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a3e:	8552                	mv	a0,s4
 a40:	00000097          	auipc	ra,0x0
 a44:	b82080e7          	jalr	-1150(ra) # 5c2 <sbrk>
  if(p == (char*)-1)
 a48:	fd5518e3          	bne	a0,s5,a18 <malloc+0xae>
        return 0;
 a4c:	4501                	li	a0,0
 a4e:	bf45                	j	9fe <malloc+0x94>
