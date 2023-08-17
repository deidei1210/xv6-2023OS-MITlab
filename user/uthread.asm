
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	cfa78793          	add	a5,a5,-774 # d00 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	cef73123          	sd	a5,-798(a4) # cf0 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	cef72423          	sw	a5,-792(a4) # 2d00 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	add	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  26:	00001897          	auipc	a7,0x1
  2a:	cca8b883          	ld	a7,-822(a7) # cf0 <current_thread>
  2e:	6789                	lui	a5,0x2
  30:	0791                	add	a5,a5,4 # 2004 <__global_pointer$+0xb33>
  32:	97c6                	add	a5,a5,a7
  34:	4711                	li	a4,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  36:	00009517          	auipc	a0,0x9
  3a:	cda50513          	add	a0,a0,-806 # 8d10 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  3e:	6609                	lui	a2,0x2
  40:	4589                	li	a1,2
      next_thread = t;
      break;
    }
    t = t + 1;
  42:	00460813          	add	a6,a2,4 # 2004 <__global_pointer$+0xb33>
  46:	a809                	j	58 <thread_schedule+0x32>
    if(t->state == RUNNABLE) {
  48:	00c786b3          	add	a3,a5,a2
  4c:	4294                	lw	a3,0(a3)
  4e:	02b68d63          	beq	a3,a1,88 <thread_schedule+0x62>
    t = t + 1;
  52:	97c2                	add	a5,a5,a6
  for(int i = 0; i < MAX_THREAD; i++){
  54:	377d                	addw	a4,a4,-1
  56:	cb01                	beqz	a4,66 <thread_schedule+0x40>
    if(t >= all_thread + MAX_THREAD)
  58:	fea7e8e3          	bltu	a5,a0,48 <thread_schedule+0x22>
      t = all_thread;
  5c:	00001797          	auipc	a5,0x1
  60:	ca478793          	add	a5,a5,-860 # d00 <all_thread>
  64:	b7d5                	j	48 <thread_schedule+0x22>
{
  66:	1141                	add	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	add	s0,sp,16
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  6e:	00001517          	auipc	a0,0x1
  72:	af250513          	add	a0,a0,-1294 # b60 <malloc+0xec>
  76:	00001097          	auipc	ra,0x1
  7a:	946080e7          	jalr	-1722(ra) # 9bc <printf>
    exit(-1);
  7e:	557d                	li	a0,-1
  80:	00000097          	auipc	ra,0x0
  84:	5d4080e7          	jalr	1492(ra) # 654 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  88:	00f88b63          	beq	a7,a5,9e <thread_schedule+0x78>
    next_thread->state = RUNNING;
  8c:	6709                	lui	a4,0x2
  8e:	973e                	add	a4,a4,a5
  90:	4685                	li	a3,1
  92:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  94:	00001717          	auipc	a4,0x1
  98:	c4f73e23          	sd	a5,-932(a4) # cf0 <current_thread>
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
  } else
    next_thread = 0;
}
  9c:	8082                	ret
  9e:	8082                	ret

00000000000000a0 <thread_create>:

void 
thread_create(void (*func)())
{
  a0:	1141                	add	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	add	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  a6:	00001797          	auipc	a5,0x1
  aa:	c5a78793          	add	a5,a5,-934 # d00 <all_thread>
    if (t->state == FREE) break;
  ae:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  b0:	00468593          	add	a1,a3,4 # 2004 <__global_pointer$+0xb33>
  b4:	00009617          	auipc	a2,0x9
  b8:	c5c60613          	add	a2,a2,-932 # 8d10 <base>
    if (t->state == FREE) break;
  bc:	00d78733          	add	a4,a5,a3
  c0:	4318                	lw	a4,0(a4)
  c2:	c701                	beqz	a4,ca <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c4:	97ae                	add	a5,a5,a1
  c6:	fec79be3          	bne	a5,a2,bc <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  ca:	6709                	lui	a4,0x2
  cc:	97ba                	add	a5,a5,a4
  ce:	4709                	li	a4,2
  d0:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	add	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <thread_yield>:

void 
thread_yield(void)
{
  d8:	1141                	add	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
  e0:	00001797          	auipc	a5,0x1
  e4:	c107b783          	ld	a5,-1008(a5) # cf0 <current_thread>
  e8:	6709                	lui	a4,0x2
  ea:	97ba                	add	a5,a5,a4
  ec:	4709                	li	a4,2
  ee:	c398                	sw	a4,0(a5)
  thread_schedule();
  f0:	00000097          	auipc	ra,0x0
  f4:	f36080e7          	jalr	-202(ra) # 26 <thread_schedule>
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	add	sp,sp,16
  fe:	8082                	ret

0000000000000100 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 100:	7179                	add	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 110:	00001517          	auipc	a0,0x1
 114:	a7850513          	add	a0,a0,-1416 # b88 <malloc+0x114>
 118:	00001097          	auipc	ra,0x1
 11c:	8a4080e7          	jalr	-1884(ra) # 9bc <printf>
  a_started = 1;
 120:	4785                	li	a5,1
 122:	00001717          	auipc	a4,0x1
 126:	bcf72523          	sw	a5,-1078(a4) # cec <a_started>
  while(b_started == 0 || c_started == 0)
 12a:	00001497          	auipc	s1,0x1
 12e:	bbe48493          	add	s1,s1,-1090 # ce8 <b_started>
 132:	00001917          	auipc	s2,0x1
 136:	bb290913          	add	s2,s2,-1102 # ce4 <c_started>
 13a:	a029                	j	144 <thread_a+0x44>
    thread_yield();
 13c:	00000097          	auipc	ra,0x0
 140:	f9c080e7          	jalr	-100(ra) # d8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 144:	409c                	lw	a5,0(s1)
 146:	2781                	sext.w	a5,a5
 148:	dbf5                	beqz	a5,13c <thread_a+0x3c>
 14a:	00092783          	lw	a5,0(s2)
 14e:	2781                	sext.w	a5,a5
 150:	d7f5                	beqz	a5,13c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 152:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 154:	00001a17          	auipc	s4,0x1
 158:	a4ca0a13          	add	s4,s4,-1460 # ba0 <malloc+0x12c>
    a_n += 1;
 15c:	00001917          	auipc	s2,0x1
 160:	b8490913          	add	s2,s2,-1148 # ce0 <a_n>
  for (i = 0; i < 100; i++) {
 164:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 168:	85a6                	mv	a1,s1
 16a:	8552                	mv	a0,s4
 16c:	00001097          	auipc	ra,0x1
 170:	850080e7          	jalr	-1968(ra) # 9bc <printf>
    a_n += 1;
 174:	00092783          	lw	a5,0(s2)
 178:	2785                	addw	a5,a5,1
 17a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 17e:	00000097          	auipc	ra,0x0
 182:	f5a080e7          	jalr	-166(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 186:	2485                	addw	s1,s1,1
 188:	ff3490e3          	bne	s1,s3,168 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 18c:	00001597          	auipc	a1,0x1
 190:	b545a583          	lw	a1,-1196(a1) # ce0 <a_n>
 194:	00001517          	auipc	a0,0x1
 198:	a1c50513          	add	a0,a0,-1508 # bb0 <malloc+0x13c>
 19c:	00001097          	auipc	ra,0x1
 1a0:	820080e7          	jalr	-2016(ra) # 9bc <printf>

  current_thread->state = FREE;
 1a4:	00001797          	auipc	a5,0x1
 1a8:	b4c7b783          	ld	a5,-1204(a5) # cf0 <current_thread>
 1ac:	6709                	lui	a4,0x2
 1ae:	97ba                	add	a5,a5,a4
 1b0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	e72080e7          	jalr	-398(ra) # 26 <thread_schedule>
}
 1bc:	70a2                	ld	ra,40(sp)
 1be:	7402                	ld	s0,32(sp)
 1c0:	64e2                	ld	s1,24(sp)
 1c2:	6942                	ld	s2,16(sp)
 1c4:	69a2                	ld	s3,8(sp)
 1c6:	6a02                	ld	s4,0(sp)
 1c8:	6145                	add	sp,sp,48
 1ca:	8082                	ret

00000000000001cc <thread_b>:

void 
thread_b(void)
{
 1cc:	7179                	add	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	e44e                	sd	s3,8(sp)
 1d8:	e052                	sd	s4,0(sp)
 1da:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 1dc:	00001517          	auipc	a0,0x1
 1e0:	9f450513          	add	a0,a0,-1548 # bd0 <malloc+0x15c>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	7d8080e7          	jalr	2008(ra) # 9bc <printf>
  b_started = 1;
 1ec:	4785                	li	a5,1
 1ee:	00001717          	auipc	a4,0x1
 1f2:	aef72d23          	sw	a5,-1286(a4) # ce8 <b_started>
  while(a_started == 0 || c_started == 0)
 1f6:	00001497          	auipc	s1,0x1
 1fa:	af648493          	add	s1,s1,-1290 # cec <a_started>
 1fe:	00001917          	auipc	s2,0x1
 202:	ae690913          	add	s2,s2,-1306 # ce4 <c_started>
 206:	a029                	j	210 <thread_b+0x44>
    thread_yield();
 208:	00000097          	auipc	ra,0x0
 20c:	ed0080e7          	jalr	-304(ra) # d8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 210:	409c                	lw	a5,0(s1)
 212:	2781                	sext.w	a5,a5
 214:	dbf5                	beqz	a5,208 <thread_b+0x3c>
 216:	00092783          	lw	a5,0(s2)
 21a:	2781                	sext.w	a5,a5
 21c:	d7f5                	beqz	a5,208 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 21e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 220:	00001a17          	auipc	s4,0x1
 224:	9c8a0a13          	add	s4,s4,-1592 # be8 <malloc+0x174>
    b_n += 1;
 228:	00001917          	auipc	s2,0x1
 22c:	ab490913          	add	s2,s2,-1356 # cdc <b_n>
  for (i = 0; i < 100; i++) {
 230:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 234:	85a6                	mv	a1,s1
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	784080e7          	jalr	1924(ra) # 9bc <printf>
    b_n += 1;
 240:	00092783          	lw	a5,0(s2)
 244:	2785                	addw	a5,a5,1
 246:	00f92023          	sw	a5,0(s2)
    thread_yield();
 24a:	00000097          	auipc	ra,0x0
 24e:	e8e080e7          	jalr	-370(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 252:	2485                	addw	s1,s1,1
 254:	ff3490e3          	bne	s1,s3,234 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 258:	00001597          	auipc	a1,0x1
 25c:	a845a583          	lw	a1,-1404(a1) # cdc <b_n>
 260:	00001517          	auipc	a0,0x1
 264:	99850513          	add	a0,a0,-1640 # bf8 <malloc+0x184>
 268:	00000097          	auipc	ra,0x0
 26c:	754080e7          	jalr	1876(ra) # 9bc <printf>

  current_thread->state = FREE;
 270:	00001797          	auipc	a5,0x1
 274:	a807b783          	ld	a5,-1408(a5) # cf0 <current_thread>
 278:	6709                	lui	a4,0x2
 27a:	97ba                	add	a5,a5,a4
 27c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 280:	00000097          	auipc	ra,0x0
 284:	da6080e7          	jalr	-602(ra) # 26 <thread_schedule>
}
 288:	70a2                	ld	ra,40(sp)
 28a:	7402                	ld	s0,32(sp)
 28c:	64e2                	ld	s1,24(sp)
 28e:	6942                	ld	s2,16(sp)
 290:	69a2                	ld	s3,8(sp)
 292:	6a02                	ld	s4,0(sp)
 294:	6145                	add	sp,sp,48
 296:	8082                	ret

0000000000000298 <thread_c>:

void 
thread_c(void)
{
 298:	7179                	add	sp,sp,-48
 29a:	f406                	sd	ra,40(sp)
 29c:	f022                	sd	s0,32(sp)
 29e:	ec26                	sd	s1,24(sp)
 2a0:	e84a                	sd	s2,16(sp)
 2a2:	e44e                	sd	s3,8(sp)
 2a4:	e052                	sd	s4,0(sp)
 2a6:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	97050513          	add	a0,a0,-1680 # c18 <malloc+0x1a4>
 2b0:	00000097          	auipc	ra,0x0
 2b4:	70c080e7          	jalr	1804(ra) # 9bc <printf>
  c_started = 1;
 2b8:	4785                	li	a5,1
 2ba:	00001717          	auipc	a4,0x1
 2be:	a2f72523          	sw	a5,-1494(a4) # ce4 <c_started>
  while(a_started == 0 || b_started == 0)
 2c2:	00001497          	auipc	s1,0x1
 2c6:	a2a48493          	add	s1,s1,-1494 # cec <a_started>
 2ca:	00001917          	auipc	s2,0x1
 2ce:	a1e90913          	add	s2,s2,-1506 # ce8 <b_started>
 2d2:	a029                	j	2dc <thread_c+0x44>
    thread_yield();
 2d4:	00000097          	auipc	ra,0x0
 2d8:	e04080e7          	jalr	-508(ra) # d8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2dc:	409c                	lw	a5,0(s1)
 2de:	2781                	sext.w	a5,a5
 2e0:	dbf5                	beqz	a5,2d4 <thread_c+0x3c>
 2e2:	00092783          	lw	a5,0(s2)
 2e6:	2781                	sext.w	a5,a5
 2e8:	d7f5                	beqz	a5,2d4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 2ea:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 2ec:	00001a17          	auipc	s4,0x1
 2f0:	944a0a13          	add	s4,s4,-1724 # c30 <malloc+0x1bc>
    c_n += 1;
 2f4:	00001917          	auipc	s2,0x1
 2f8:	9e490913          	add	s2,s2,-1564 # cd8 <c_n>
  for (i = 0; i < 100; i++) {
 2fc:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 300:	85a6                	mv	a1,s1
 302:	8552                	mv	a0,s4
 304:	00000097          	auipc	ra,0x0
 308:	6b8080e7          	jalr	1720(ra) # 9bc <printf>
    c_n += 1;
 30c:	00092783          	lw	a5,0(s2)
 310:	2785                	addw	a5,a5,1
 312:	00f92023          	sw	a5,0(s2)
    thread_yield();
 316:	00000097          	auipc	ra,0x0
 31a:	dc2080e7          	jalr	-574(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 31e:	2485                	addw	s1,s1,1
 320:	ff3490e3          	bne	s1,s3,300 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 324:	00001597          	auipc	a1,0x1
 328:	9b45a583          	lw	a1,-1612(a1) # cd8 <c_n>
 32c:	00001517          	auipc	a0,0x1
 330:	91450513          	add	a0,a0,-1772 # c40 <malloc+0x1cc>
 334:	00000097          	auipc	ra,0x0
 338:	688080e7          	jalr	1672(ra) # 9bc <printf>

  current_thread->state = FREE;
 33c:	00001797          	auipc	a5,0x1
 340:	9b47b783          	ld	a5,-1612(a5) # cf0 <current_thread>
 344:	6709                	lui	a4,0x2
 346:	97ba                	add	a5,a5,a4
 348:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 34c:	00000097          	auipc	ra,0x0
 350:	cda080e7          	jalr	-806(ra) # 26 <thread_schedule>
}
 354:	70a2                	ld	ra,40(sp)
 356:	7402                	ld	s0,32(sp)
 358:	64e2                	ld	s1,24(sp)
 35a:	6942                	ld	s2,16(sp)
 35c:	69a2                	ld	s3,8(sp)
 35e:	6a02                	ld	s4,0(sp)
 360:	6145                	add	sp,sp,48
 362:	8082                	ret

0000000000000364 <main>:

int 
main(int argc, char *argv[]) 
{
 364:	1141                	add	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 36c:	00001797          	auipc	a5,0x1
 370:	9607ac23          	sw	zero,-1672(a5) # ce4 <c_started>
 374:	00001797          	auipc	a5,0x1
 378:	9607aa23          	sw	zero,-1676(a5) # ce8 <b_started>
 37c:	00001797          	auipc	a5,0x1
 380:	9607a823          	sw	zero,-1680(a5) # cec <a_started>
  a_n = b_n = c_n = 0;
 384:	00001797          	auipc	a5,0x1
 388:	9407aa23          	sw	zero,-1708(a5) # cd8 <c_n>
 38c:	00001797          	auipc	a5,0x1
 390:	9407a823          	sw	zero,-1712(a5) # cdc <b_n>
 394:	00001797          	auipc	a5,0x1
 398:	9407a623          	sw	zero,-1716(a5) # ce0 <a_n>
  thread_init();
 39c:	00000097          	auipc	ra,0x0
 3a0:	c64080e7          	jalr	-924(ra) # 0 <thread_init>
  thread_create(thread_a);
 3a4:	00000517          	auipc	a0,0x0
 3a8:	d5c50513          	add	a0,a0,-676 # 100 <thread_a>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	cf4080e7          	jalr	-780(ra) # a0 <thread_create>
  thread_create(thread_b);
 3b4:	00000517          	auipc	a0,0x0
 3b8:	e1850513          	add	a0,a0,-488 # 1cc <thread_b>
 3bc:	00000097          	auipc	ra,0x0
 3c0:	ce4080e7          	jalr	-796(ra) # a0 <thread_create>
  thread_create(thread_c);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	ed450513          	add	a0,a0,-300 # 298 <thread_c>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cd4080e7          	jalr	-812(ra) # a0 <thread_create>
  thread_schedule();
 3d4:	00000097          	auipc	ra,0x0
 3d8:	c52080e7          	jalr	-942(ra) # 26 <thread_schedule>
  exit(0);
 3dc:	4501                	li	a0,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	276080e7          	jalr	630(ra) # 654 <exit>

00000000000003e6 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	ret    /* return to ra */
 3e6:	8082                	ret

00000000000003e8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3e8:	1141                	add	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ee:	87aa                	mv	a5,a0
 3f0:	0585                	add	a1,a1,1
 3f2:	0785                	add	a5,a5,1
 3f4:	fff5c703          	lbu	a4,-1(a1)
 3f8:	fee78fa3          	sb	a4,-1(a5)
 3fc:	fb75                	bnez	a4,3f0 <strcpy+0x8>
    ;
  return os;
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	add	sp,sp,16
 402:	8082                	ret

0000000000000404 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 404:	1141                	add	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 40a:	00054783          	lbu	a5,0(a0)
 40e:	cb91                	beqz	a5,422 <strcmp+0x1e>
 410:	0005c703          	lbu	a4,0(a1)
 414:	00f71763          	bne	a4,a5,422 <strcmp+0x1e>
    p++, q++;
 418:	0505                	add	a0,a0,1
 41a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 41c:	00054783          	lbu	a5,0(a0)
 420:	fbe5                	bnez	a5,410 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 422:	0005c503          	lbu	a0,0(a1)
}
 426:	40a7853b          	subw	a0,a5,a0
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	add	sp,sp,16
 42e:	8082                	ret

0000000000000430 <strlen>:

uint
strlen(const char *s)
{
 430:	1141                	add	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 436:	00054783          	lbu	a5,0(a0)
 43a:	cf91                	beqz	a5,456 <strlen+0x26>
 43c:	0505                	add	a0,a0,1
 43e:	87aa                	mv	a5,a0
 440:	86be                	mv	a3,a5
 442:	0785                	add	a5,a5,1
 444:	fff7c703          	lbu	a4,-1(a5)
 448:	ff65                	bnez	a4,440 <strlen+0x10>
 44a:	40a6853b          	subw	a0,a3,a0
 44e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 450:	6422                	ld	s0,8(sp)
 452:	0141                	add	sp,sp,16
 454:	8082                	ret
  for(n = 0; s[n]; n++)
 456:	4501                	li	a0,0
 458:	bfe5                	j	450 <strlen+0x20>

000000000000045a <memset>:

void*
memset(void *dst, int c, uint n)
{
 45a:	1141                	add	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 460:	ca19                	beqz	a2,476 <memset+0x1c>
 462:	87aa                	mv	a5,a0
 464:	1602                	sll	a2,a2,0x20
 466:	9201                	srl	a2,a2,0x20
 468:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 46c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 470:	0785                	add	a5,a5,1
 472:	fee79de3          	bne	a5,a4,46c <memset+0x12>
  }
  return dst;
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	add	sp,sp,16
 47a:	8082                	ret

000000000000047c <strchr>:

char*
strchr(const char *s, char c)
{
 47c:	1141                	add	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	add	s0,sp,16
  for(; *s; s++)
 482:	00054783          	lbu	a5,0(a0)
 486:	cb99                	beqz	a5,49c <strchr+0x20>
    if(*s == c)
 488:	00f58763          	beq	a1,a5,496 <strchr+0x1a>
  for(; *s; s++)
 48c:	0505                	add	a0,a0,1
 48e:	00054783          	lbu	a5,0(a0)
 492:	fbfd                	bnez	a5,488 <strchr+0xc>
      return (char*)s;
  return 0;
 494:	4501                	li	a0,0
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	add	sp,sp,16
 49a:	8082                	ret
  return 0;
 49c:	4501                	li	a0,0
 49e:	bfe5                	j	496 <strchr+0x1a>

00000000000004a0 <gets>:

char*
gets(char *buf, int max)
{
 4a0:	711d                	add	sp,sp,-96
 4a2:	ec86                	sd	ra,88(sp)
 4a4:	e8a2                	sd	s0,80(sp)
 4a6:	e4a6                	sd	s1,72(sp)
 4a8:	e0ca                	sd	s2,64(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	1080                	add	s0,sp,96
 4b6:	8baa                	mv	s7,a0
 4b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ba:	892a                	mv	s2,a0
 4bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4be:	4aa9                	li	s5,10
 4c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4c2:	89a6                	mv	s3,s1
 4c4:	2485                	addw	s1,s1,1
 4c6:	0344d863          	bge	s1,s4,4f6 <gets+0x56>
    cc = read(0, &c, 1);
 4ca:	4605                	li	a2,1
 4cc:	faf40593          	add	a1,s0,-81
 4d0:	4501                	li	a0,0
 4d2:	00000097          	auipc	ra,0x0
 4d6:	19a080e7          	jalr	410(ra) # 66c <read>
    if(cc < 1)
 4da:	00a05e63          	blez	a0,4f6 <gets+0x56>
    buf[i++] = c;
 4de:	faf44783          	lbu	a5,-81(s0)
 4e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e6:	01578763          	beq	a5,s5,4f4 <gets+0x54>
 4ea:	0905                	add	s2,s2,1
 4ec:	fd679be3          	bne	a5,s6,4c2 <gets+0x22>
  for(i=0; i+1 < max; ){
 4f0:	89a6                	mv	s3,s1
 4f2:	a011                	j	4f6 <gets+0x56>
 4f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4f6:	99de                	add	s3,s3,s7
 4f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 4fc:	855e                	mv	a0,s7
 4fe:	60e6                	ld	ra,88(sp)
 500:	6446                	ld	s0,80(sp)
 502:	64a6                	ld	s1,72(sp)
 504:	6906                	ld	s2,64(sp)
 506:	79e2                	ld	s3,56(sp)
 508:	7a42                	ld	s4,48(sp)
 50a:	7aa2                	ld	s5,40(sp)
 50c:	7b02                	ld	s6,32(sp)
 50e:	6be2                	ld	s7,24(sp)
 510:	6125                	add	sp,sp,96
 512:	8082                	ret

0000000000000514 <stat>:

int
stat(const char *n, struct stat *st)
{
 514:	1101                	add	sp,sp,-32
 516:	ec06                	sd	ra,24(sp)
 518:	e822                	sd	s0,16(sp)
 51a:	e426                	sd	s1,8(sp)
 51c:	e04a                	sd	s2,0(sp)
 51e:	1000                	add	s0,sp,32
 520:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 522:	4581                	li	a1,0
 524:	00000097          	auipc	ra,0x0
 528:	170080e7          	jalr	368(ra) # 694 <open>
  if(fd < 0)
 52c:	02054563          	bltz	a0,556 <stat+0x42>
 530:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 532:	85ca                	mv	a1,s2
 534:	00000097          	auipc	ra,0x0
 538:	178080e7          	jalr	376(ra) # 6ac <fstat>
 53c:	892a                	mv	s2,a0
  close(fd);
 53e:	8526                	mv	a0,s1
 540:	00000097          	auipc	ra,0x0
 544:	13c080e7          	jalr	316(ra) # 67c <close>
  return r;
}
 548:	854a                	mv	a0,s2
 54a:	60e2                	ld	ra,24(sp)
 54c:	6442                	ld	s0,16(sp)
 54e:	64a2                	ld	s1,8(sp)
 550:	6902                	ld	s2,0(sp)
 552:	6105                	add	sp,sp,32
 554:	8082                	ret
    return -1;
 556:	597d                	li	s2,-1
 558:	bfc5                	j	548 <stat+0x34>

000000000000055a <atoi>:

int
atoi(const char *s)
{
 55a:	1141                	add	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 560:	00054683          	lbu	a3,0(a0)
 564:	fd06879b          	addw	a5,a3,-48
 568:	0ff7f793          	zext.b	a5,a5
 56c:	4625                	li	a2,9
 56e:	02f66863          	bltu	a2,a5,59e <atoi+0x44>
 572:	872a                	mv	a4,a0
  n = 0;
 574:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 576:	0705                	add	a4,a4,1 # 2001 <__global_pointer$+0xb30>
 578:	0025179b          	sllw	a5,a0,0x2
 57c:	9fa9                	addw	a5,a5,a0
 57e:	0017979b          	sllw	a5,a5,0x1
 582:	9fb5                	addw	a5,a5,a3
 584:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 588:	00074683          	lbu	a3,0(a4)
 58c:	fd06879b          	addw	a5,a3,-48
 590:	0ff7f793          	zext.b	a5,a5
 594:	fef671e3          	bgeu	a2,a5,576 <atoi+0x1c>
  return n;
}
 598:	6422                	ld	s0,8(sp)
 59a:	0141                	add	sp,sp,16
 59c:	8082                	ret
  n = 0;
 59e:	4501                	li	a0,0
 5a0:	bfe5                	j	598 <atoi+0x3e>

00000000000005a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5a2:	1141                	add	sp,sp,-16
 5a4:	e422                	sd	s0,8(sp)
 5a6:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5a8:	02b57463          	bgeu	a0,a1,5d0 <memmove+0x2e>
    while(n-- > 0)
 5ac:	00c05f63          	blez	a2,5ca <memmove+0x28>
 5b0:	1602                	sll	a2,a2,0x20
 5b2:	9201                	srl	a2,a2,0x20
 5b4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5b8:	872a                	mv	a4,a0
      *dst++ = *src++;
 5ba:	0585                	add	a1,a1,1
 5bc:	0705                	add	a4,a4,1
 5be:	fff5c683          	lbu	a3,-1(a1)
 5c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c6:	fee79ae3          	bne	a5,a4,5ba <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5ca:	6422                	ld	s0,8(sp)
 5cc:	0141                	add	sp,sp,16
 5ce:	8082                	ret
    dst += n;
 5d0:	00c50733          	add	a4,a0,a2
    src += n;
 5d4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d6:	fec05ae3          	blez	a2,5ca <memmove+0x28>
 5da:	fff6079b          	addw	a5,a2,-1
 5de:	1782                	sll	a5,a5,0x20
 5e0:	9381                	srl	a5,a5,0x20
 5e2:	fff7c793          	not	a5,a5
 5e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e8:	15fd                	add	a1,a1,-1
 5ea:	177d                	add	a4,a4,-1
 5ec:	0005c683          	lbu	a3,0(a1)
 5f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5f4:	fee79ae3          	bne	a5,a4,5e8 <memmove+0x46>
 5f8:	bfc9                	j	5ca <memmove+0x28>

00000000000005fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5fa:	1141                	add	sp,sp,-16
 5fc:	e422                	sd	s0,8(sp)
 5fe:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 600:	ca05                	beqz	a2,630 <memcmp+0x36>
 602:	fff6069b          	addw	a3,a2,-1
 606:	1682                	sll	a3,a3,0x20
 608:	9281                	srl	a3,a3,0x20
 60a:	0685                	add	a3,a3,1
 60c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 60e:	00054783          	lbu	a5,0(a0)
 612:	0005c703          	lbu	a4,0(a1)
 616:	00e79863          	bne	a5,a4,626 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 61a:	0505                	add	a0,a0,1
    p2++;
 61c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 61e:	fed518e3          	bne	a0,a3,60e <memcmp+0x14>
  }
  return 0;
 622:	4501                	li	a0,0
 624:	a019                	j	62a <memcmp+0x30>
      return *p1 - *p2;
 626:	40e7853b          	subw	a0,a5,a4
}
 62a:	6422                	ld	s0,8(sp)
 62c:	0141                	add	sp,sp,16
 62e:	8082                	ret
  return 0;
 630:	4501                	li	a0,0
 632:	bfe5                	j	62a <memcmp+0x30>

0000000000000634 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 634:	1141                	add	sp,sp,-16
 636:	e406                	sd	ra,8(sp)
 638:	e022                	sd	s0,0(sp)
 63a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 63c:	00000097          	auipc	ra,0x0
 640:	f66080e7          	jalr	-154(ra) # 5a2 <memmove>
}
 644:	60a2                	ld	ra,8(sp)
 646:	6402                	ld	s0,0(sp)
 648:	0141                	add	sp,sp,16
 64a:	8082                	ret

000000000000064c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 64c:	4885                	li	a7,1
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <exit>:
.global exit
exit:
 li a7, SYS_exit
 654:	4889                	li	a7,2
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <wait>:
.global wait
wait:
 li a7, SYS_wait
 65c:	488d                	li	a7,3
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 664:	4891                	li	a7,4
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <read>:
.global read
read:
 li a7, SYS_read
 66c:	4895                	li	a7,5
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <write>:
.global write
write:
 li a7, SYS_write
 674:	48c1                	li	a7,16
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <close>:
.global close
close:
 li a7, SYS_close
 67c:	48d5                	li	a7,21
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <kill>:
.global kill
kill:
 li a7, SYS_kill
 684:	4899                	li	a7,6
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <exec>:
.global exec
exec:
 li a7, SYS_exec
 68c:	489d                	li	a7,7
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <open>:
.global open
open:
 li a7, SYS_open
 694:	48bd                	li	a7,15
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 69c:	48c5                	li	a7,17
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6a4:	48c9                	li	a7,18
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6ac:	48a1                	li	a7,8
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <link>:
.global link
link:
 li a7, SYS_link
 6b4:	48cd                	li	a7,19
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6bc:	48d1                	li	a7,20
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6c4:	48a5                	li	a7,9
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6cc:	48a9                	li	a7,10
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6d4:	48ad                	li	a7,11
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6dc:	48b1                	li	a7,12
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6e4:	48b5                	li	a7,13
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ec:	48b9                	li	a7,14
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f4:	1101                	add	sp,sp,-32
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	add	s0,sp,32
 6fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 700:	4605                	li	a2,1
 702:	fef40593          	add	a1,s0,-17
 706:	00000097          	auipc	ra,0x0
 70a:	f6e080e7          	jalr	-146(ra) # 674 <write>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6105                	add	sp,sp,32
 714:	8082                	ret

0000000000000716 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 716:	7139                	add	sp,sp,-64
 718:	fc06                	sd	ra,56(sp)
 71a:	f822                	sd	s0,48(sp)
 71c:	f426                	sd	s1,40(sp)
 71e:	f04a                	sd	s2,32(sp)
 720:	ec4e                	sd	s3,24(sp)
 722:	0080                	add	s0,sp,64
 724:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 726:	c299                	beqz	a3,72c <printint+0x16>
 728:	0805c963          	bltz	a1,7ba <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 72c:	2581                	sext.w	a1,a1
  neg = 0;
 72e:	4881                	li	a7,0
 730:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 734:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 736:	2601                	sext.w	a2,a2
 738:	00000517          	auipc	a0,0x0
 73c:	58850513          	add	a0,a0,1416 # cc0 <digits>
 740:	883a                	mv	a6,a4
 742:	2705                	addw	a4,a4,1
 744:	02c5f7bb          	remuw	a5,a1,a2
 748:	1782                	sll	a5,a5,0x20
 74a:	9381                	srl	a5,a5,0x20
 74c:	97aa                	add	a5,a5,a0
 74e:	0007c783          	lbu	a5,0(a5)
 752:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 756:	0005879b          	sext.w	a5,a1
 75a:	02c5d5bb          	divuw	a1,a1,a2
 75e:	0685                	add	a3,a3,1
 760:	fec7f0e3          	bgeu	a5,a2,740 <printint+0x2a>
  if(neg)
 764:	00088c63          	beqz	a7,77c <printint+0x66>
    buf[i++] = '-';
 768:	fd070793          	add	a5,a4,-48
 76c:	00878733          	add	a4,a5,s0
 770:	02d00793          	li	a5,45
 774:	fef70823          	sb	a5,-16(a4)
 778:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 77c:	02e05863          	blez	a4,7ac <printint+0x96>
 780:	fc040793          	add	a5,s0,-64
 784:	00e78933          	add	s2,a5,a4
 788:	fff78993          	add	s3,a5,-1
 78c:	99ba                	add	s3,s3,a4
 78e:	377d                	addw	a4,a4,-1
 790:	1702                	sll	a4,a4,0x20
 792:	9301                	srl	a4,a4,0x20
 794:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 798:	fff94583          	lbu	a1,-1(s2)
 79c:	8526                	mv	a0,s1
 79e:	00000097          	auipc	ra,0x0
 7a2:	f56080e7          	jalr	-170(ra) # 6f4 <putc>
  while(--i >= 0)
 7a6:	197d                	add	s2,s2,-1
 7a8:	ff3918e3          	bne	s2,s3,798 <printint+0x82>
}
 7ac:	70e2                	ld	ra,56(sp)
 7ae:	7442                	ld	s0,48(sp)
 7b0:	74a2                	ld	s1,40(sp)
 7b2:	7902                	ld	s2,32(sp)
 7b4:	69e2                	ld	s3,24(sp)
 7b6:	6121                	add	sp,sp,64
 7b8:	8082                	ret
    x = -xx;
 7ba:	40b005bb          	negw	a1,a1
    neg = 1;
 7be:	4885                	li	a7,1
    x = -xx;
 7c0:	bf85                	j	730 <printint+0x1a>

00000000000007c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c2:	715d                	add	sp,sp,-80
 7c4:	e486                	sd	ra,72(sp)
 7c6:	e0a2                	sd	s0,64(sp)
 7c8:	fc26                	sd	s1,56(sp)
 7ca:	f84a                	sd	s2,48(sp)
 7cc:	f44e                	sd	s3,40(sp)
 7ce:	f052                	sd	s4,32(sp)
 7d0:	ec56                	sd	s5,24(sp)
 7d2:	e85a                	sd	s6,16(sp)
 7d4:	e45e                	sd	s7,8(sp)
 7d6:	e062                	sd	s8,0(sp)
 7d8:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7da:	0005c903          	lbu	s2,0(a1)
 7de:	18090c63          	beqz	s2,976 <vprintf+0x1b4>
 7e2:	8aaa                	mv	s5,a0
 7e4:	8bb2                	mv	s7,a2
 7e6:	00158493          	add	s1,a1,1
  state = 0;
 7ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7ec:	02500a13          	li	s4,37
 7f0:	4b55                	li	s6,21
 7f2:	a839                	j	810 <vprintf+0x4e>
        putc(fd, c);
 7f4:	85ca                	mv	a1,s2
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	efc080e7          	jalr	-260(ra) # 6f4 <putc>
 800:	a019                	j	806 <vprintf+0x44>
    } else if(state == '%'){
 802:	01498d63          	beq	s3,s4,81c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 806:	0485                	add	s1,s1,1
 808:	fff4c903          	lbu	s2,-1(s1)
 80c:	16090563          	beqz	s2,976 <vprintf+0x1b4>
    if(state == 0){
 810:	fe0999e3          	bnez	s3,802 <vprintf+0x40>
      if(c == '%'){
 814:	ff4910e3          	bne	s2,s4,7f4 <vprintf+0x32>
        state = '%';
 818:	89d2                	mv	s3,s4
 81a:	b7f5                	j	806 <vprintf+0x44>
      if(c == 'd'){
 81c:	13490263          	beq	s2,s4,940 <vprintf+0x17e>
 820:	f9d9079b          	addw	a5,s2,-99
 824:	0ff7f793          	zext.b	a5,a5
 828:	12fb6563          	bltu	s6,a5,952 <vprintf+0x190>
 82c:	f9d9079b          	addw	a5,s2,-99
 830:	0ff7f713          	zext.b	a4,a5
 834:	10eb6f63          	bltu	s6,a4,952 <vprintf+0x190>
 838:	00271793          	sll	a5,a4,0x2
 83c:	00000717          	auipc	a4,0x0
 840:	42c70713          	add	a4,a4,1068 # c68 <malloc+0x1f4>
 844:	97ba                	add	a5,a5,a4
 846:	439c                	lw	a5,0(a5)
 848:	97ba                	add	a5,a5,a4
 84a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 84c:	008b8913          	add	s2,s7,8
 850:	4685                	li	a3,1
 852:	4629                	li	a2,10
 854:	000ba583          	lw	a1,0(s7)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	ebc080e7          	jalr	-324(ra) # 716 <printint>
 862:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 864:	4981                	li	s3,0
 866:	b745                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 868:	008b8913          	add	s2,s7,8
 86c:	4681                	li	a3,0
 86e:	4629                	li	a2,10
 870:	000ba583          	lw	a1,0(s7)
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	ea0080e7          	jalr	-352(ra) # 716 <printint>
 87e:	8bca                	mv	s7,s2
      state = 0;
 880:	4981                	li	s3,0
 882:	b751                	j	806 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 884:	008b8913          	add	s2,s7,8
 888:	4681                	li	a3,0
 88a:	4641                	li	a2,16
 88c:	000ba583          	lw	a1,0(s7)
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	e84080e7          	jalr	-380(ra) # 716 <printint>
 89a:	8bca                	mv	s7,s2
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b7a5                	j	806 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 8a0:	008b8c13          	add	s8,s7,8
 8a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a8:	03000593          	li	a1,48
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e46080e7          	jalr	-442(ra) # 6f4 <putc>
  putc(fd, 'x');
 8b6:	07800593          	li	a1,120
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	e38080e7          	jalr	-456(ra) # 6f4 <putc>
 8c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c6:	00000b97          	auipc	s7,0x0
 8ca:	3fab8b93          	add	s7,s7,1018 # cc0 <digits>
 8ce:	03c9d793          	srl	a5,s3,0x3c
 8d2:	97de                	add	a5,a5,s7
 8d4:	0007c583          	lbu	a1,0(a5)
 8d8:	8556                	mv	a0,s5
 8da:	00000097          	auipc	ra,0x0
 8de:	e1a080e7          	jalr	-486(ra) # 6f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e2:	0992                	sll	s3,s3,0x4
 8e4:	397d                	addw	s2,s2,-1
 8e6:	fe0914e3          	bnez	s2,8ce <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8ea:	8be2                	mv	s7,s8
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	bf21                	j	806 <vprintf+0x44>
        s = va_arg(ap, char*);
 8f0:	008b8993          	add	s3,s7,8
 8f4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8f8:	02090163          	beqz	s2,91a <vprintf+0x158>
        while(*s != 0){
 8fc:	00094583          	lbu	a1,0(s2)
 900:	c9a5                	beqz	a1,970 <vprintf+0x1ae>
          putc(fd, *s);
 902:	8556                	mv	a0,s5
 904:	00000097          	auipc	ra,0x0
 908:	df0080e7          	jalr	-528(ra) # 6f4 <putc>
          s++;
 90c:	0905                	add	s2,s2,1
        while(*s != 0){
 90e:	00094583          	lbu	a1,0(s2)
 912:	f9e5                	bnez	a1,902 <vprintf+0x140>
        s = va_arg(ap, char*);
 914:	8bce                	mv	s7,s3
      state = 0;
 916:	4981                	li	s3,0
 918:	b5fd                	j	806 <vprintf+0x44>
          s = "(null)";
 91a:	00000917          	auipc	s2,0x0
 91e:	34690913          	add	s2,s2,838 # c60 <malloc+0x1ec>
        while(*s != 0){
 922:	02800593          	li	a1,40
 926:	bff1                	j	902 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 928:	008b8913          	add	s2,s7,8
 92c:	000bc583          	lbu	a1,0(s7)
 930:	8556                	mv	a0,s5
 932:	00000097          	auipc	ra,0x0
 936:	dc2080e7          	jalr	-574(ra) # 6f4 <putc>
 93a:	8bca                	mv	s7,s2
      state = 0;
 93c:	4981                	li	s3,0
 93e:	b5e1                	j	806 <vprintf+0x44>
        putc(fd, c);
 940:	02500593          	li	a1,37
 944:	8556                	mv	a0,s5
 946:	00000097          	auipc	ra,0x0
 94a:	dae080e7          	jalr	-594(ra) # 6f4 <putc>
      state = 0;
 94e:	4981                	li	s3,0
 950:	bd5d                	j	806 <vprintf+0x44>
        putc(fd, '%');
 952:	02500593          	li	a1,37
 956:	8556                	mv	a0,s5
 958:	00000097          	auipc	ra,0x0
 95c:	d9c080e7          	jalr	-612(ra) # 6f4 <putc>
        putc(fd, c);
 960:	85ca                	mv	a1,s2
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	d90080e7          	jalr	-624(ra) # 6f4 <putc>
      state = 0;
 96c:	4981                	li	s3,0
 96e:	bd61                	j	806 <vprintf+0x44>
        s = va_arg(ap, char*);
 970:	8bce                	mv	s7,s3
      state = 0;
 972:	4981                	li	s3,0
 974:	bd49                	j	806 <vprintf+0x44>
    }
  }
}
 976:	60a6                	ld	ra,72(sp)
 978:	6406                	ld	s0,64(sp)
 97a:	74e2                	ld	s1,56(sp)
 97c:	7942                	ld	s2,48(sp)
 97e:	79a2                	ld	s3,40(sp)
 980:	7a02                	ld	s4,32(sp)
 982:	6ae2                	ld	s5,24(sp)
 984:	6b42                	ld	s6,16(sp)
 986:	6ba2                	ld	s7,8(sp)
 988:	6c02                	ld	s8,0(sp)
 98a:	6161                	add	sp,sp,80
 98c:	8082                	ret

000000000000098e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98e:	715d                	add	sp,sp,-80
 990:	ec06                	sd	ra,24(sp)
 992:	e822                	sd	s0,16(sp)
 994:	1000                	add	s0,sp,32
 996:	e010                	sd	a2,0(s0)
 998:	e414                	sd	a3,8(s0)
 99a:	e818                	sd	a4,16(s0)
 99c:	ec1c                	sd	a5,24(s0)
 99e:	03043023          	sd	a6,32(s0)
 9a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9aa:	8622                	mv	a2,s0
 9ac:	00000097          	auipc	ra,0x0
 9b0:	e16080e7          	jalr	-490(ra) # 7c2 <vprintf>
}
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	6161                	add	sp,sp,80
 9ba:	8082                	ret

00000000000009bc <printf>:

void
printf(const char *fmt, ...)
{
 9bc:	711d                	add	sp,sp,-96
 9be:	ec06                	sd	ra,24(sp)
 9c0:	e822                	sd	s0,16(sp)
 9c2:	1000                	add	s0,sp,32
 9c4:	e40c                	sd	a1,8(s0)
 9c6:	e810                	sd	a2,16(s0)
 9c8:	ec14                	sd	a3,24(s0)
 9ca:	f018                	sd	a4,32(s0)
 9cc:	f41c                	sd	a5,40(s0)
 9ce:	03043823          	sd	a6,48(s0)
 9d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	00840613          	add	a2,s0,8
 9da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9de:	85aa                	mv	a1,a0
 9e0:	4505                	li	a0,1
 9e2:	00000097          	auipc	ra,0x0
 9e6:	de0080e7          	jalr	-544(ra) # 7c2 <vprintf>
}
 9ea:	60e2                	ld	ra,24(sp)
 9ec:	6442                	ld	s0,16(sp)
 9ee:	6125                	add	sp,sp,96
 9f0:	8082                	ret

00000000000009f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f2:	1141                	add	sp,sp,-16
 9f4:	e422                	sd	s0,8(sp)
 9f6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fc:	00000797          	auipc	a5,0x0
 a00:	2fc7b783          	ld	a5,764(a5) # cf8 <freep>
 a04:	a02d                	j	a2e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a06:	4618                	lw	a4,8(a2)
 a08:	9f2d                	addw	a4,a4,a1
 a0a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a0e:	6398                	ld	a4,0(a5)
 a10:	6310                	ld	a2,0(a4)
 a12:	a83d                	j	a50 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a14:	ff852703          	lw	a4,-8(a0)
 a18:	9f31                	addw	a4,a4,a2
 a1a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a1c:	ff053683          	ld	a3,-16(a0)
 a20:	a091                	j	a64 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a22:	6398                	ld	a4,0(a5)
 a24:	00e7e463          	bltu	a5,a4,a2c <free+0x3a>
 a28:	00e6ea63          	bltu	a3,a4,a3c <free+0x4a>
{
 a2c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2e:	fed7fae3          	bgeu	a5,a3,a22 <free+0x30>
 a32:	6398                	ld	a4,0(a5)
 a34:	00e6e463          	bltu	a3,a4,a3c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a38:	fee7eae3          	bltu	a5,a4,a2c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a3c:	ff852583          	lw	a1,-8(a0)
 a40:	6390                	ld	a2,0(a5)
 a42:	02059813          	sll	a6,a1,0x20
 a46:	01c85713          	srl	a4,a6,0x1c
 a4a:	9736                	add	a4,a4,a3
 a4c:	fae60de3          	beq	a2,a4,a06 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a50:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a54:	4790                	lw	a2,8(a5)
 a56:	02061593          	sll	a1,a2,0x20
 a5a:	01c5d713          	srl	a4,a1,0x1c
 a5e:	973e                	add	a4,a4,a5
 a60:	fae68ae3          	beq	a3,a4,a14 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a64:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a66:	00000717          	auipc	a4,0x0
 a6a:	28f73923          	sd	a5,658(a4) # cf8 <freep>
}
 a6e:	6422                	ld	s0,8(sp)
 a70:	0141                	add	sp,sp,16
 a72:	8082                	ret

0000000000000a74 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a74:	7139                	add	sp,sp,-64
 a76:	fc06                	sd	ra,56(sp)
 a78:	f822                	sd	s0,48(sp)
 a7a:	f426                	sd	s1,40(sp)
 a7c:	f04a                	sd	s2,32(sp)
 a7e:	ec4e                	sd	s3,24(sp)
 a80:	e852                	sd	s4,16(sp)
 a82:	e456                	sd	s5,8(sp)
 a84:	e05a                	sd	s6,0(sp)
 a86:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a88:	02051493          	sll	s1,a0,0x20
 a8c:	9081                	srl	s1,s1,0x20
 a8e:	04bd                	add	s1,s1,15
 a90:	8091                	srl	s1,s1,0x4
 a92:	0014899b          	addw	s3,s1,1
 a96:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a98:	00000517          	auipc	a0,0x0
 a9c:	26053503          	ld	a0,608(a0) # cf8 <freep>
 aa0:	c515                	beqz	a0,acc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	02977f63          	bgeu	a4,s1,ae4 <malloc+0x70>
  if(nu < 4096)
 aaa:	8a4e                	mv	s4,s3
 aac:	0009871b          	sext.w	a4,s3
 ab0:	6685                	lui	a3,0x1
 ab2:	00d77363          	bgeu	a4,a3,ab8 <malloc+0x44>
 ab6:	6a05                	lui	s4,0x1
 ab8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 abc:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac0:	00000917          	auipc	s2,0x0
 ac4:	23890913          	add	s2,s2,568 # cf8 <freep>
  if(p == (char*)-1)
 ac8:	5afd                	li	s5,-1
 aca:	a895                	j	b3e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 acc:	00008797          	auipc	a5,0x8
 ad0:	24478793          	add	a5,a5,580 # 8d10 <base>
 ad4:	00000717          	auipc	a4,0x0
 ad8:	22f73223          	sd	a5,548(a4) # cf8 <freep>
 adc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ade:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae2:	b7e1                	j	aaa <malloc+0x36>
      if(p->s.size == nunits)
 ae4:	02e48c63          	beq	s1,a4,b1c <malloc+0xa8>
        p->s.size -= nunits;
 ae8:	4137073b          	subw	a4,a4,s3
 aec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aee:	02071693          	sll	a3,a4,0x20
 af2:	01c6d713          	srl	a4,a3,0x1c
 af6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 afc:	00000717          	auipc	a4,0x0
 b00:	1ea73e23          	sd	a0,508(a4) # cf8 <freep>
      return (void*)(p + 1);
 b04:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b08:	70e2                	ld	ra,56(sp)
 b0a:	7442                	ld	s0,48(sp)
 b0c:	74a2                	ld	s1,40(sp)
 b0e:	7902                	ld	s2,32(sp)
 b10:	69e2                	ld	s3,24(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	6121                	add	sp,sp,64
 b1a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b1c:	6398                	ld	a4,0(a5)
 b1e:	e118                	sd	a4,0(a0)
 b20:	bff1                	j	afc <malloc+0x88>
  hp->s.size = nu;
 b22:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b26:	0541                	add	a0,a0,16
 b28:	00000097          	auipc	ra,0x0
 b2c:	eca080e7          	jalr	-310(ra) # 9f2 <free>
  return freep;
 b30:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b34:	d971                	beqz	a0,b08 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	fa9775e3          	bgeu	a4,s1,ae4 <malloc+0x70>
    if(p == freep)
 b3e:	00093703          	ld	a4,0(s2)
 b42:	853e                	mv	a0,a5
 b44:	fef719e3          	bne	a4,a5,b36 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b48:	8552                	mv	a0,s4
 b4a:	00000097          	auipc	ra,0x0
 b4e:	b92080e7          	jalr	-1134(ra) # 6dc <sbrk>
  if(p == (char*)-1)
 b52:	fd5518e3          	bne	a0,s5,b22 <malloc+0xae>
        return 0;
 b56:	4501                	li	a0,0
 b58:	bf45                	j	b08 <malloc+0x94>
