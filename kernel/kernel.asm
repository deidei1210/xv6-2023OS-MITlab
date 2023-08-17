
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	17010113          	add	sp,sp,368 # 80009170 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	sllw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	sll	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	sll	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	fe070713          	add	a4,a4,-32 # 80009030 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	a6e78793          	add	a5,a5,-1426 # 80005ad0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	add	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	add	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dfe78793          	add	a5,a5,-514 # 80000eaa <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  timerinit();
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	f46080e7          	jalr	-186(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000de:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e6:	30200073          	mret
}
    800000ea:	60a2                	ld	ra,8(sp)
    800000ec:	6402                	ld	s0,0(sp)
    800000ee:	0141                	add	sp,sp,16
    800000f0:	8082                	ret

00000000800000f2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f2:	715d                	add	sp,sp,-80
    800000f4:	e486                	sd	ra,72(sp)
    800000f6:	e0a2                	sd	s0,64(sp)
    800000f8:	fc26                	sd	s1,56(sp)
    800000fa:	f84a                	sd	s2,48(sp)
    800000fc:	f44e                	sd	s3,40(sp)
    800000fe:	f052                	sd	s4,32(sp)
    80000100:	ec56                	sd	s5,24(sp)
    80000102:	0880                	add	s0,sp,80
    80000104:	8a2a                	mv	s4,a0
    80000106:	84ae                	mv	s1,a1
    80000108:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    8000010a:	00011517          	auipc	a0,0x11
    8000010e:	06650513          	add	a0,a0,102 # 80011170 <cons>
    80000112:	00001097          	auipc	ra,0x1
    80000116:	af0080e7          	jalr	-1296(ra) # 80000c02 <acquire>
  for(i = 0; i < n; i++){
    8000011a:	05305c63          	blez	s3,80000172 <consolewrite+0x80>
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	add	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	2f4080e7          	jalr	756(ra) # 80002420 <either_copyin>
    80000134:	01550d63          	beq	a0,s5,8000014e <consolewrite+0x5c>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	796080e7          	jalr	1942(ra) # 800008d2 <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addw	s2,s2,1
    80000146:	0485                	add	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x30>
    8000014c:	894e                	mv	s2,s3
  }
  release(&cons.lock);
    8000014e:	00011517          	auipc	a0,0x11
    80000152:	02250513          	add	a0,a0,34 # 80011170 <cons>
    80000156:	00001097          	auipc	ra,0x1
    8000015a:	b60080e7          	jalr	-1184(ra) # 80000cb6 <release>

  return i;
}
    8000015e:	854a                	mv	a0,s2
    80000160:	60a6                	ld	ra,72(sp)
    80000162:	6406                	ld	s0,64(sp)
    80000164:	74e2                	ld	s1,56(sp)
    80000166:	7942                	ld	s2,48(sp)
    80000168:	79a2                	ld	s3,40(sp)
    8000016a:	7a02                	ld	s4,32(sp)
    8000016c:	6ae2                	ld	s5,24(sp)
    8000016e:	6161                	add	sp,sp,80
    80000170:	8082                	ret
  for(i = 0; i < n; i++){
    80000172:	4901                	li	s2,0
    80000174:	bfe9                	j	8000014e <consolewrite+0x5c>

0000000080000176 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	add	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f456                	sd	s5,40(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	add	s0,sp,96
    8000018c:	8aaa                	mv	s5,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	fda50513          	add	a0,a0,-38 # 80011170 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a64080e7          	jalr	-1436(ra) # 80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	fca48493          	add	s1,s1,-54 # 80011170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	00011917          	auipc	s2,0x11
    800001b2:	05a90913          	add	s2,s2,90 # 80011208 <cons+0x98>
  while(n > 0){
    800001b6:	07305f63          	blez	s3,80000234 <consoleread+0xbe>
    while(cons.r == cons.w){
    800001ba:	0984a783          	lw	a5,152(s1)
    800001be:	09c4a703          	lw	a4,156(s1)
    800001c2:	02f71463          	bne	a4,a5,800001ea <consoleread+0x74>
      if(myproc()->killed){
    800001c6:	00001097          	auipc	ra,0x1
    800001ca:	794080e7          	jalr	1940(ra) # 8000195a <myproc>
    800001ce:	591c                	lw	a5,48(a0)
    800001d0:	efad                	bnez	a5,8000024a <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	f9a080e7          	jalr	-102(ra) # 80002170 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fef700e3          	beq	a4,a5,800001c6 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800001ea:	00011717          	auipc	a4,0x11
    800001ee:	f8670713          	add	a4,a4,-122 # 80011170 <cons>
    800001f2:	0017869b          	addw	a3,a5,1
    800001f6:	08d72c23          	sw	a3,152(a4)
    800001fa:	07f7f693          	and	a3,a5,127
    800001fe:	9736                	add	a4,a4,a3
    80000200:	01874703          	lbu	a4,24(a4)
    80000204:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000208:	4691                	li	a3,4
    8000020a:	06db8463          	beq	s7,a3,80000272 <consoleread+0xfc>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000212:	4685                	li	a3,1
    80000214:	faf40613          	add	a2,s0,-81
    80000218:	85d2                	mv	a1,s4
    8000021a:	8556                	mv	a0,s5
    8000021c:	00002097          	auipc	ra,0x2
    80000220:	1ae080e7          	jalr	430(ra) # 800023ca <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	00f50763          	beq	a0,a5,80000234 <consoleread+0xbe>
      break;

    dst++;
    8000022a:	0a05                	add	s4,s4,1
    --n;
    8000022c:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000022e:	47a9                	li	a5,10
    80000230:	f8fb93e3          	bne	s7,a5,800001b6 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000234:	00011517          	auipc	a0,0x11
    80000238:	f3c50513          	add	a0,a0,-196 # 80011170 <cons>
    8000023c:	00001097          	auipc	ra,0x1
    80000240:	a7a080e7          	jalr	-1414(ra) # 80000cb6 <release>

  return target - n;
    80000244:	413b053b          	subw	a0,s6,s3
    80000248:	a811                	j	8000025c <consoleread+0xe6>
        release(&cons.lock);
    8000024a:	00011517          	auipc	a0,0x11
    8000024e:	f2650513          	add	a0,a0,-218 # 80011170 <cons>
    80000252:	00001097          	auipc	ra,0x1
    80000256:	a64080e7          	jalr	-1436(ra) # 80000cb6 <release>
        return -1;
    8000025a:	557d                	li	a0,-1
}
    8000025c:	60e6                	ld	ra,88(sp)
    8000025e:	6446                	ld	s0,80(sp)
    80000260:	64a6                	ld	s1,72(sp)
    80000262:	6906                	ld	s2,64(sp)
    80000264:	79e2                	ld	s3,56(sp)
    80000266:	7a42                	ld	s4,48(sp)
    80000268:	7aa2                	ld	s5,40(sp)
    8000026a:	7b02                	ld	s6,32(sp)
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	6125                	add	sp,sp,96
    80000270:	8082                	ret
      if(n < target){
    80000272:	0009871b          	sext.w	a4,s3
    80000276:	fb677fe3          	bgeu	a4,s6,80000234 <consoleread+0xbe>
        cons.r--;
    8000027a:	00011717          	auipc	a4,0x11
    8000027e:	f8f72723          	sw	a5,-114(a4) # 80011208 <cons+0x98>
    80000282:	bf4d                	j	80000234 <consoleread+0xbe>

0000000080000284 <consputc>:
{
    80000284:	1141                	add	sp,sp,-16
    80000286:	e406                	sd	ra,8(sp)
    80000288:	e022                	sd	s0,0(sp)
    8000028a:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000028c:	10000793          	li	a5,256
    80000290:	00f50a63          	beq	a0,a5,800002a4 <consputc+0x20>
    uartputc_sync(c);
    80000294:	00000097          	auipc	ra,0x0
    80000298:	560080e7          	jalr	1376(ra) # 800007f4 <uartputc_sync>
}
    8000029c:	60a2                	ld	ra,8(sp)
    8000029e:	6402                	ld	s0,0(sp)
    800002a0:	0141                	add	sp,sp,16
    800002a2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a4:	4521                	li	a0,8
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	54e080e7          	jalr	1358(ra) # 800007f4 <uartputc_sync>
    800002ae:	02000513          	li	a0,32
    800002b2:	00000097          	auipc	ra,0x0
    800002b6:	542080e7          	jalr	1346(ra) # 800007f4 <uartputc_sync>
    800002ba:	4521                	li	a0,8
    800002bc:	00000097          	auipc	ra,0x0
    800002c0:	538080e7          	jalr	1336(ra) # 800007f4 <uartputc_sync>
    800002c4:	bfe1                	j	8000029c <consputc+0x18>

00000000800002c6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c6:	1101                	add	sp,sp,-32
    800002c8:	ec06                	sd	ra,24(sp)
    800002ca:	e822                	sd	s0,16(sp)
    800002cc:	e426                	sd	s1,8(sp)
    800002ce:	e04a                	sd	s2,0(sp)
    800002d0:	1000                	add	s0,sp,32
    800002d2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d4:	00011517          	auipc	a0,0x11
    800002d8:	e9c50513          	add	a0,a0,-356 # 80011170 <cons>
    800002dc:	00001097          	auipc	ra,0x1
    800002e0:	926080e7          	jalr	-1754(ra) # 80000c02 <acquire>

  switch(c){
    800002e4:	47d5                	li	a5,21
    800002e6:	0af48663          	beq	s1,a5,80000392 <consoleintr+0xcc>
    800002ea:	0297ca63          	blt	a5,s1,8000031e <consoleintr+0x58>
    800002ee:	47a1                	li	a5,8
    800002f0:	0ef48763          	beq	s1,a5,800003de <consoleintr+0x118>
    800002f4:	47c1                	li	a5,16
    800002f6:	10f49a63          	bne	s1,a5,8000040a <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fa:	00002097          	auipc	ra,0x2
    800002fe:	17c080e7          	jalr	380(ra) # 80002476 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000302:	00011517          	auipc	a0,0x11
    80000306:	e6e50513          	add	a0,a0,-402 # 80011170 <cons>
    8000030a:	00001097          	auipc	ra,0x1
    8000030e:	9ac080e7          	jalr	-1620(ra) # 80000cb6 <release>
}
    80000312:	60e2                	ld	ra,24(sp)
    80000314:	6442                	ld	s0,16(sp)
    80000316:	64a2                	ld	s1,8(sp)
    80000318:	6902                	ld	s2,0(sp)
    8000031a:	6105                	add	sp,sp,32
    8000031c:	8082                	ret
  switch(c){
    8000031e:	07f00793          	li	a5,127
    80000322:	0af48e63          	beq	s1,a5,800003de <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000326:	00011717          	auipc	a4,0x11
    8000032a:	e4a70713          	add	a4,a4,-438 # 80011170 <cons>
    8000032e:	0a072783          	lw	a5,160(a4)
    80000332:	09872703          	lw	a4,152(a4)
    80000336:	9f99                	subw	a5,a5,a4
    80000338:	07f00713          	li	a4,127
    8000033c:	fcf763e3          	bltu	a4,a5,80000302 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000340:	47b5                	li	a5,13
    80000342:	0cf48763          	beq	s1,a5,80000410 <consoleintr+0x14a>
      consputc(c);
    80000346:	8526                	mv	a0,s1
    80000348:	00000097          	auipc	ra,0x0
    8000034c:	f3c080e7          	jalr	-196(ra) # 80000284 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000350:	00011797          	auipc	a5,0x11
    80000354:	e2078793          	add	a5,a5,-480 # 80011170 <cons>
    80000358:	0a07a703          	lw	a4,160(a5)
    8000035c:	0017069b          	addw	a3,a4,1
    80000360:	0006861b          	sext.w	a2,a3
    80000364:	0ad7a023          	sw	a3,160(a5)
    80000368:	07f77713          	and	a4,a4,127
    8000036c:	97ba                	add	a5,a5,a4
    8000036e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000372:	47a9                	li	a5,10
    80000374:	0cf48563          	beq	s1,a5,8000043e <consoleintr+0x178>
    80000378:	4791                	li	a5,4
    8000037a:	0cf48263          	beq	s1,a5,8000043e <consoleintr+0x178>
    8000037e:	00011797          	auipc	a5,0x11
    80000382:	e8a7a783          	lw	a5,-374(a5) # 80011208 <cons+0x98>
    80000386:	0807879b          	addw	a5,a5,128
    8000038a:	f6f61ce3          	bne	a2,a5,80000302 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038e:	863e                	mv	a2,a5
    80000390:	a07d                	j	8000043e <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000392:	00011717          	auipc	a4,0x11
    80000396:	dde70713          	add	a4,a4,-546 # 80011170 <cons>
    8000039a:	0a072783          	lw	a5,160(a4)
    8000039e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a2:	00011497          	auipc	s1,0x11
    800003a6:	dce48493          	add	s1,s1,-562 # 80011170 <cons>
    while(cons.e != cons.w &&
    800003aa:	4929                	li	s2,10
    800003ac:	f4f70be3          	beq	a4,a5,80000302 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b0:	37fd                	addw	a5,a5,-1
    800003b2:	07f7f713          	and	a4,a5,127
    800003b6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b8:	01874703          	lbu	a4,24(a4)
    800003bc:	f52703e3          	beq	a4,s2,80000302 <consoleintr+0x3c>
      cons.e--;
    800003c0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c4:	10000513          	li	a0,256
    800003c8:	00000097          	auipc	ra,0x0
    800003cc:	ebc080e7          	jalr	-324(ra) # 80000284 <consputc>
    while(cons.e != cons.w &&
    800003d0:	0a04a783          	lw	a5,160(s1)
    800003d4:	09c4a703          	lw	a4,156(s1)
    800003d8:	fcf71ce3          	bne	a4,a5,800003b0 <consoleintr+0xea>
    800003dc:	b71d                	j	80000302 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003de:	00011717          	auipc	a4,0x11
    800003e2:	d9270713          	add	a4,a4,-622 # 80011170 <cons>
    800003e6:	0a072783          	lw	a5,160(a4)
    800003ea:	09c72703          	lw	a4,156(a4)
    800003ee:	f0f70ae3          	beq	a4,a5,80000302 <consoleintr+0x3c>
      cons.e--;
    800003f2:	37fd                	addw	a5,a5,-1
    800003f4:	00011717          	auipc	a4,0x11
    800003f8:	e0f72e23          	sw	a5,-484(a4) # 80011210 <cons+0xa0>
      consputc(BACKSPACE);
    800003fc:	10000513          	li	a0,256
    80000400:	00000097          	auipc	ra,0x0
    80000404:	e84080e7          	jalr	-380(ra) # 80000284 <consputc>
    80000408:	bded                	j	80000302 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040a:	ee048ce3          	beqz	s1,80000302 <consoleintr+0x3c>
    8000040e:	bf21                	j	80000326 <consoleintr+0x60>
      consputc(c);
    80000410:	4529                	li	a0,10
    80000412:	00000097          	auipc	ra,0x0
    80000416:	e72080e7          	jalr	-398(ra) # 80000284 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041a:	00011797          	auipc	a5,0x11
    8000041e:	d5678793          	add	a5,a5,-682 # 80011170 <cons>
    80000422:	0a07a703          	lw	a4,160(a5)
    80000426:	0017069b          	addw	a3,a4,1
    8000042a:	0006861b          	sext.w	a2,a3
    8000042e:	0ad7a023          	sw	a3,160(a5)
    80000432:	07f77713          	and	a4,a4,127
    80000436:	97ba                	add	a5,a5,a4
    80000438:	4729                	li	a4,10
    8000043a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043e:	00011797          	auipc	a5,0x11
    80000442:	dcc7a723          	sw	a2,-562(a5) # 8001120c <cons+0x9c>
        wakeup(&cons.r);
    80000446:	00011517          	auipc	a0,0x11
    8000044a:	dc250513          	add	a0,a0,-574 # 80011208 <cons+0x98>
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	ea2080e7          	jalr	-350(ra) # 800022f0 <wakeup>
    80000456:	b575                	j	80000302 <consoleintr+0x3c>

0000000080000458 <consoleinit>:

void
consoleinit(void)
{
    80000458:	1141                	add	sp,sp,-16
    8000045a:	e406                	sd	ra,8(sp)
    8000045c:	e022                	sd	s0,0(sp)
    8000045e:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000460:	00008597          	auipc	a1,0x8
    80000464:	bb058593          	add	a1,a1,-1104 # 80008010 <etext+0x10>
    80000468:	00011517          	auipc	a0,0x11
    8000046c:	d0850513          	add	a0,a0,-760 # 80011170 <cons>
    80000470:	00000097          	auipc	ra,0x0
    80000474:	702080e7          	jalr	1794(ra) # 80000b72 <initlock>

  uartinit();
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	32c080e7          	jalr	812(ra) # 800007a4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000480:	00021797          	auipc	a5,0x21
    80000484:	e7078793          	add	a5,a5,-400 # 800212f0 <devsw>
    80000488:	00000717          	auipc	a4,0x0
    8000048c:	cee70713          	add	a4,a4,-786 # 80000176 <consoleread>
    80000490:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000492:	00000717          	auipc	a4,0x0
    80000496:	c6070713          	add	a4,a4,-928 # 800000f2 <consolewrite>
    8000049a:	ef98                	sd	a4,24(a5)
}
    8000049c:	60a2                	ld	ra,8(sp)
    8000049e:	6402                	ld	s0,0(sp)
    800004a0:	0141                	add	sp,sp,16
    800004a2:	8082                	ret

00000000800004a4 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a4:	7179                	add	sp,sp,-48
    800004a6:	f406                	sd	ra,40(sp)
    800004a8:	f022                	sd	s0,32(sp)
    800004aa:	ec26                	sd	s1,24(sp)
    800004ac:	e84a                	sd	s2,16(sp)
    800004ae:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b0:	c219                	beqz	a2,800004b6 <printint+0x12>
    800004b2:	08054763          	bltz	a0,80000540 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004b6:	2501                	sext.w	a0,a0
    800004b8:	4881                	li	a7,0
    800004ba:	fd040693          	add	a3,s0,-48

  i = 0;
    800004be:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c0:	2581                	sext.w	a1,a1
    800004c2:	00008617          	auipc	a2,0x8
    800004c6:	b7e60613          	add	a2,a2,-1154 # 80008040 <digits>
    800004ca:	883a                	mv	a6,a4
    800004cc:	2705                	addw	a4,a4,1
    800004ce:	02b577bb          	remuw	a5,a0,a1
    800004d2:	1782                	sll	a5,a5,0x20
    800004d4:	9381                	srl	a5,a5,0x20
    800004d6:	97b2                	add	a5,a5,a2
    800004d8:	0007c783          	lbu	a5,0(a5)
    800004dc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e0:	0005079b          	sext.w	a5,a0
    800004e4:	02b5553b          	divuw	a0,a0,a1
    800004e8:	0685                	add	a3,a3,1
    800004ea:	feb7f0e3          	bgeu	a5,a1,800004ca <printint+0x26>

  if(sign)
    800004ee:	00088c63          	beqz	a7,80000506 <printint+0x62>
    buf[i++] = '-';
    800004f2:	fe070793          	add	a5,a4,-32
    800004f6:	00878733          	add	a4,a5,s0
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x90>
    8000050a:	fd040793          	add	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	add	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addw	a4,a4,-1
    8000051a:	1702                	sll	a4,a4,0x20
    8000051c:	9301                	srl	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	d5e080e7          	jalr	-674(ra) # 80000284 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	add	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7e>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	add	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf95                	j	800004ba <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	add	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	add	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	cc07ae23          	sw	zero,-804(a5) # 80011230 <pr+0x18>
  printf("panic: ");
    8000055c:	00008517          	auipc	a0,0x8
    80000560:	abc50513          	add	a0,a0,-1348 # 80008018 <etext+0x18>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	b5250513          	add	a0,a0,-1198 # 800080c8 <digits+0x88>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00009717          	auipc	a4,0x9
    8000058c:	a6f72c23          	sw	a5,-1416(a4) # 80009000 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	add	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	add	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	c6cdad83          	lw	s11,-916(s11) # 80011230 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	add	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	14050f63          	beqz	a0,8000073e <printf+0x1ac>
    800005e4:	4981                	li	s3,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b93          	li	s7,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00008b17          	auipc	s6,0x8
    800005f4:	a50b0b13          	add	s6,s6,-1456 # 80008040 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	c1650513          	add	a0,a0,-1002 # 80011218 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	5f8080e7          	jalr	1528(ra) # 80000c02 <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00008517          	auipc	a0,0x8
    80000618:	a1450513          	add	a0,a0,-1516 # 80008028 <etext+0x28>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	c60080e7          	jalr	-928(ra) # 80000284 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2985                	addw	s3,s3,1
    8000062e:	013a07b3          	add	a5,s4,s3
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050463          	beqz	a0,8000073e <printf+0x1ac>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2985                	addw	s3,s3,1
    80000640:	013a07b3          	add	a5,s4,s3
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000064c:	cbed                	beqz	a5,8000073e <printf+0x1ac>
    switch(c){
    8000064e:	05778a63          	beq	a5,s7,800006a2 <printf+0x110>
    80000652:	02fbf663          	bgeu	s7,a5,8000067e <printf+0xec>
    80000656:	09978863          	beq	a5,s9,800006e6 <printf+0x154>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79563          	bne	a5,a4,80000728 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	add	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e30080e7          	jalr	-464(ra) # 800004a4 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	09578f63          	beq	a5,s5,8000071c <printf+0x18a>
    80000682:	0b879363          	bne	a5,s8,80000728 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	add	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0c080e7          	jalr	-500(ra) # 800004a4 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	add	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bce080e7          	jalr	-1074(ra) # 80000284 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	bc2080e7          	jalr	-1086(ra) # 80000284 <consputc>
    800006ca:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c95793          	srl	a5,s2,0x3c
    800006d0:	97da                	add	a5,a5,s6
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	bae080e7          	jalr	-1106(ra) # 80000284 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0912                	sll	s2,s2,0x4
    800006e0:	34fd                	addw	s1,s1,-1
    800006e2:	f4ed                	bnez	s1,800006cc <printf+0x13a>
    800006e4:	b7a1                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e6:	f8843783          	ld	a5,-120(s0)
    800006ea:	00878713          	add	a4,a5,8
    800006ee:	f8e43423          	sd	a4,-120(s0)
    800006f2:	6384                	ld	s1,0(a5)
    800006f4:	cc89                	beqz	s1,8000070e <printf+0x17c>
      for(; *s; s++)
    800006f6:	0004c503          	lbu	a0,0(s1)
    800006fa:	d90d                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	b88080e7          	jalr	-1144(ra) # 80000284 <consputc>
      for(; *s; s++)
    80000704:	0485                	add	s1,s1,1
    80000706:	0004c503          	lbu	a0,0(s1)
    8000070a:	f96d                	bnez	a0,800006fc <printf+0x16a>
    8000070c:	b705                	j	8000062c <printf+0x9a>
        s = "(null)";
    8000070e:	00008497          	auipc	s1,0x8
    80000712:	91248493          	add	s1,s1,-1774 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000716:	02800513          	li	a0,40
    8000071a:	b7cd                	j	800006fc <printf+0x16a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b66080e7          	jalr	-1178(ra) # 80000284 <consputc>
      break;
    80000726:	b719                	j	8000062c <printf+0x9a>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b5a080e7          	jalr	-1190(ra) # 80000284 <consputc>
      consputc(c);
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	b50080e7          	jalr	-1200(ra) # 80000284 <consputc>
      break;
    8000073c:	bdc5                	j	8000062c <printf+0x9a>
  if(locking)
    8000073e:	020d9163          	bnez	s11,80000760 <printf+0x1ce>
}
    80000742:	70e6                	ld	ra,120(sp)
    80000744:	7446                	ld	s0,112(sp)
    80000746:	74a6                	ld	s1,104(sp)
    80000748:	7906                	ld	s2,96(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7ca2                	ld	s9,40(sp)
    80000758:	7d02                	ld	s10,32(sp)
    8000075a:	6de2                	ld	s11,24(sp)
    8000075c:	6129                	add	sp,sp,192
    8000075e:	8082                	ret
    release(&pr.lock);
    80000760:	00011517          	auipc	a0,0x11
    80000764:	ab850513          	add	a0,a0,-1352 # 80011218 <pr>
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	54e080e7          	jalr	1358(ra) # 80000cb6 <release>
}
    80000770:	bfc9                	j	80000742 <printf+0x1b0>

0000000080000772 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000772:	1101                	add	sp,sp,-32
    80000774:	ec06                	sd	ra,24(sp)
    80000776:	e822                	sd	s0,16(sp)
    80000778:	e426                	sd	s1,8(sp)
    8000077a:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077c:	00011497          	auipc	s1,0x11
    80000780:	a9c48493          	add	s1,s1,-1380 # 80011218 <pr>
    80000784:	00008597          	auipc	a1,0x8
    80000788:	8b458593          	add	a1,a1,-1868 # 80008038 <etext+0x38>
    8000078c:	8526                	mv	a0,s1
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	3e4080e7          	jalr	996(ra) # 80000b72 <initlock>
  pr.locking = 1;
    80000796:	4785                	li	a5,1
    80000798:	cc9c                	sw	a5,24(s1)
}
    8000079a:	60e2                	ld	ra,24(sp)
    8000079c:	6442                	ld	s0,16(sp)
    8000079e:	64a2                	ld	s1,8(sp)
    800007a0:	6105                	add	sp,sp,32
    800007a2:	8082                	ret

00000000800007a4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007a4:	1141                	add	sp,sp,-16
    800007a6:	e406                	sd	ra,8(sp)
    800007a8:	e022                	sd	s0,0(sp)
    800007aa:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ac:	100007b7          	lui	a5,0x10000
    800007b0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007b4:	f8000713          	li	a4,-128
    800007b8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007bc:	470d                	li	a4,3
    800007be:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ca:	469d                	li	a3,7
    800007cc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007d4:	00008597          	auipc	a1,0x8
    800007d8:	88458593          	add	a1,a1,-1916 # 80008058 <digits+0x18>
    800007dc:	00011517          	auipc	a0,0x11
    800007e0:	a5c50513          	add	a0,a0,-1444 # 80011238 <uart_tx_lock>
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	38e080e7          	jalr	910(ra) # 80000b72 <initlock>
}
    800007ec:	60a2                	ld	ra,8(sp)
    800007ee:	6402                	ld	s0,0(sp)
    800007f0:	0141                	add	sp,sp,16
    800007f2:	8082                	ret

00000000800007f4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007f4:	1101                	add	sp,sp,-32
    800007f6:	ec06                	sd	ra,24(sp)
    800007f8:	e822                	sd	s0,16(sp)
    800007fa:	e426                	sd	s1,8(sp)
    800007fc:	1000                	add	s0,sp,32
    800007fe:	84aa                	mv	s1,a0
  push_off();
    80000800:	00000097          	auipc	ra,0x0
    80000804:	3b6080e7          	jalr	950(ra) # 80000bb6 <push_off>

  if(panicked){
    80000808:	00008797          	auipc	a5,0x8
    8000080c:	7f87a783          	lw	a5,2040(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	10000737          	lui	a4,0x10000
  if(panicked){
    80000814:	c391                	beqz	a5,80000818 <uartputc_sync+0x24>
    for(;;)
    80000816:	a001                	j	80000816 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000818:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000081c:	0207f793          	and	a5,a5,32
    80000820:	dfe5                	beqz	a5,80000818 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000822:	0ff4f513          	zext.b	a0,s1
    80000826:	100007b7          	lui	a5,0x10000
    8000082a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	428080e7          	jalr	1064(ra) # 80000c56 <pop_off>
}
    80000836:	60e2                	ld	ra,24(sp)
    80000838:	6442                	ld	s0,16(sp)
    8000083a:	64a2                	ld	s1,8(sp)
    8000083c:	6105                	add	sp,sp,32
    8000083e:	8082                	ret

0000000080000840 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000840:	00008797          	auipc	a5,0x8
    80000844:	7c47a783          	lw	a5,1988(a5) # 80009004 <uart_tx_r>
    80000848:	00008717          	auipc	a4,0x8
    8000084c:	7c072703          	lw	a4,1984(a4) # 80009008 <uart_tx_w>
    80000850:	08f70063          	beq	a4,a5,800008d0 <uartstart+0x90>
{
    80000854:	7139                	add	sp,sp,-64
    80000856:	fc06                	sd	ra,56(sp)
    80000858:	f822                	sd	s0,48(sp)
    8000085a:	f426                	sd	s1,40(sp)
    8000085c:	f04a                	sd	s2,32(sp)
    8000085e:	ec4e                	sd	s3,24(sp)
    80000860:	e852                	sd	s4,16(sp)
    80000862:	e456                	sd	s5,8(sp)
    80000864:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000866:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    8000086a:	00011a97          	auipc	s5,0x11
    8000086e:	9cea8a93          	add	s5,s5,-1586 # 80011238 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000872:	00008497          	auipc	s1,0x8
    80000876:	79248493          	add	s1,s1,1938 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000087a:	00008a17          	auipc	s4,0x8
    8000087e:	78ea0a13          	add	s4,s4,1934 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000882:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000886:	02077713          	and	a4,a4,32
    8000088a:	cb15                	beqz	a4,800008be <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    8000088c:	00fa8733          	add	a4,s5,a5
    80000890:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000894:	2785                	addw	a5,a5,1
    80000896:	41f7d71b          	sraw	a4,a5,0x1f
    8000089a:	01b7571b          	srlw	a4,a4,0x1b
    8000089e:	9fb9                	addw	a5,a5,a4
    800008a0:	8bfd                	and	a5,a5,31
    800008a2:	9f99                	subw	a5,a5,a4
    800008a4:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a6:	8526                	mv	a0,s1
    800008a8:	00002097          	auipc	ra,0x2
    800008ac:	a48080e7          	jalr	-1464(ra) # 800022f0 <wakeup>
    
    WriteReg(THR, c);
    800008b0:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b4:	409c                	lw	a5,0(s1)
    800008b6:	000a2703          	lw	a4,0(s4)
    800008ba:	fcf714e3          	bne	a4,a5,80000882 <uartstart+0x42>
  }
}
    800008be:	70e2                	ld	ra,56(sp)
    800008c0:	7442                	ld	s0,48(sp)
    800008c2:	74a2                	ld	s1,40(sp)
    800008c4:	7902                	ld	s2,32(sp)
    800008c6:	69e2                	ld	s3,24(sp)
    800008c8:	6a42                	ld	s4,16(sp)
    800008ca:	6aa2                	ld	s5,8(sp)
    800008cc:	6121                	add	sp,sp,64
    800008ce:	8082                	ret
    800008d0:	8082                	ret

00000000800008d2 <uartputc>:
{
    800008d2:	7179                	add	sp,sp,-48
    800008d4:	f406                	sd	ra,40(sp)
    800008d6:	f022                	sd	s0,32(sp)
    800008d8:	ec26                	sd	s1,24(sp)
    800008da:	e84a                	sd	s2,16(sp)
    800008dc:	e44e                	sd	s3,8(sp)
    800008de:	e052                	sd	s4,0(sp)
    800008e0:	1800                	add	s0,sp,48
    800008e2:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008e4:	00011517          	auipc	a0,0x11
    800008e8:	95450513          	add	a0,a0,-1708 # 80011238 <uart_tx_lock>
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	316080e7          	jalr	790(ra) # 80000c02 <acquire>
  if(panicked){
    800008f4:	00008797          	auipc	a5,0x8
    800008f8:	70c7a783          	lw	a5,1804(a5) # 80009000 <panicked>
    800008fc:	c391                	beqz	a5,80000900 <uartputc+0x2e>
    for(;;)
    800008fe:	a001                	j	800008fe <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000900:	00008697          	auipc	a3,0x8
    80000904:	7086a683          	lw	a3,1800(a3) # 80009008 <uart_tx_w>
    80000908:	0016879b          	addw	a5,a3,1
    8000090c:	41f7d71b          	sraw	a4,a5,0x1f
    80000910:	01b7571b          	srlw	a4,a4,0x1b
    80000914:	9fb9                	addw	a5,a5,a4
    80000916:	8bfd                	and	a5,a5,31
    80000918:	9f99                	subw	a5,a5,a4
    8000091a:	00008717          	auipc	a4,0x8
    8000091e:	6ea72703          	lw	a4,1770(a4) # 80009004 <uart_tx_r>
    80000922:	04f71363          	bne	a4,a5,80000968 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000926:	00011a17          	auipc	s4,0x11
    8000092a:	912a0a13          	add	s4,s4,-1774 # 80011238 <uart_tx_lock>
    8000092e:	00008917          	auipc	s2,0x8
    80000932:	6d690913          	add	s2,s2,1750 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000936:	00008997          	auipc	s3,0x8
    8000093a:	6d298993          	add	s3,s3,1746 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000093e:	85d2                	mv	a1,s4
    80000940:	854a                	mv	a0,s2
    80000942:	00002097          	auipc	ra,0x2
    80000946:	82e080e7          	jalr	-2002(ra) # 80002170 <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000094a:	0009a683          	lw	a3,0(s3)
    8000094e:	0016879b          	addw	a5,a3,1
    80000952:	41f7d71b          	sraw	a4,a5,0x1f
    80000956:	01b7571b          	srlw	a4,a4,0x1b
    8000095a:	9fb9                	addw	a5,a5,a4
    8000095c:	8bfd                	and	a5,a5,31
    8000095e:	9f99                	subw	a5,a5,a4
    80000960:	00092703          	lw	a4,0(s2)
    80000964:	fcf70de3          	beq	a4,a5,8000093e <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000968:	00011917          	auipc	s2,0x11
    8000096c:	8d090913          	add	s2,s2,-1840 # 80011238 <uart_tx_lock>
    80000970:	96ca                	add	a3,a3,s2
    80000972:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000976:	00008717          	auipc	a4,0x8
    8000097a:	68f72923          	sw	a5,1682(a4) # 80009008 <uart_tx_w>
      uartstart();
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	ec2080e7          	jalr	-318(ra) # 80000840 <uartstart>
      release(&uart_tx_lock);
    80000986:	854a                	mv	a0,s2
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	32e080e7          	jalr	814(ra) # 80000cb6 <release>
}
    80000990:	70a2                	ld	ra,40(sp)
    80000992:	7402                	ld	s0,32(sp)
    80000994:	64e2                	ld	s1,24(sp)
    80000996:	6942                	ld	s2,16(sp)
    80000998:	69a2                	ld	s3,8(sp)
    8000099a:	6a02                	ld	s4,0(sp)
    8000099c:	6145                	add	sp,sp,48
    8000099e:	8082                	ret

00000000800009a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009a0:	1141                	add	sp,sp,-16
    800009a2:	e422                	sd	s0,8(sp)
    800009a4:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009a6:	100007b7          	lui	a5,0x10000
    800009aa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ae:	8b85                	and	a5,a5,1
    800009b0:	cb81                	beqz	a5,800009c0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009b2:	100007b7          	lui	a5,0x10000
    800009b6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009ba:	6422                	ld	s0,8(sp)
    800009bc:	0141                	add	sp,sp,16
    800009be:	8082                	ret
    return -1;
    800009c0:	557d                	li	a0,-1
    800009c2:	bfe5                	j	800009ba <uartgetc+0x1a>

00000000800009c4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009c4:	1101                	add	sp,sp,-32
    800009c6:	ec06                	sd	ra,24(sp)
    800009c8:	e822                	sd	s0,16(sp)
    800009ca:	e426                	sd	s1,8(sp)
    800009cc:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ce:	54fd                	li	s1,-1
    800009d0:	a029                	j	800009da <uartintr+0x16>
      break;
    consoleintr(c);
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	8f4080e7          	jalr	-1804(ra) # 800002c6 <consoleintr>
    int c = uartgetc();
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fc6080e7          	jalr	-58(ra) # 800009a0 <uartgetc>
    if(c == -1)
    800009e2:	fe9518e3          	bne	a0,s1,800009d2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009e6:	00011497          	auipc	s1,0x11
    800009ea:	85248493          	add	s1,s1,-1966 # 80011238 <uart_tx_lock>
    800009ee:	8526                	mv	a0,s1
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	212080e7          	jalr	530(ra) # 80000c02 <acquire>
  uartstart();
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	e48080e7          	jalr	-440(ra) # 80000840 <uartstart>
  release(&uart_tx_lock);
    80000a00:	8526                	mv	a0,s1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2b4080e7          	jalr	692(ra) # 80000cb6 <release>
}
    80000a0a:	60e2                	ld	ra,24(sp)
    80000a0c:	6442                	ld	s0,16(sp)
    80000a0e:	64a2                	ld	s1,8(sp)
    80000a10:	6105                	add	sp,sp,32
    80000a12:	8082                	ret

0000000080000a14 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a14:	1101                	add	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	e04a                	sd	s2,0(sp)
    80000a1e:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a20:	03451793          	sll	a5,a0,0x34
    80000a24:	ebb9                	bnez	a5,80000a7a <kfree+0x66>
    80000a26:	84aa                	mv	s1,a0
    80000a28:	00025797          	auipc	a5,0x25
    80000a2c:	5d878793          	add	a5,a5,1496 # 80026000 <end>
    80000a30:	04f56563          	bltu	a0,a5,80000a7a <kfree+0x66>
    80000a34:	47c5                	li	a5,17
    80000a36:	07ee                	sll	a5,a5,0x1b
    80000a38:	04f57163          	bgeu	a0,a5,80000a7a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a3c:	6605                	lui	a2,0x1
    80000a3e:	4585                	li	a1,1
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	2be080e7          	jalr	702(ra) # 80000cfe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a48:	00011917          	auipc	s2,0x11
    80000a4c:	82890913          	add	s2,s2,-2008 # 80011270 <kmem>
    80000a50:	854a                	mv	a0,s2
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	1b0080e7          	jalr	432(ra) # 80000c02 <acquire>
  r->next = kmem.freelist;
    80000a5a:	01893783          	ld	a5,24(s2)
    80000a5e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a60:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a64:	854a                	mv	a0,s2
    80000a66:	00000097          	auipc	ra,0x0
    80000a6a:	250080e7          	jalr	592(ra) # 80000cb6 <release>
}
    80000a6e:	60e2                	ld	ra,24(sp)
    80000a70:	6442                	ld	s0,16(sp)
    80000a72:	64a2                	ld	s1,8(sp)
    80000a74:	6902                	ld	s2,0(sp)
    80000a76:	6105                	add	sp,sp,32
    80000a78:	8082                	ret
    panic("kfree");
    80000a7a:	00007517          	auipc	a0,0x7
    80000a7e:	5e650513          	add	a0,a0,1510 # 80008060 <digits+0x20>
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	ac6080e7          	jalr	-1338(ra) # 80000548 <panic>

0000000080000a8a <freerange>:
{
    80000a8a:	7179                	add	sp,sp,-48
    80000a8c:	f406                	sd	ra,40(sp)
    80000a8e:	f022                	sd	s0,32(sp)
    80000a90:	ec26                	sd	s1,24(sp)
    80000a92:	e84a                	sd	s2,16(sp)
    80000a94:	e44e                	sd	s3,8(sp)
    80000a96:	e052                	sd	s4,0(sp)
    80000a98:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a9a:	6785                	lui	a5,0x1
    80000a9c:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aa0:	00e504b3          	add	s1,a0,a4
    80000aa4:	777d                	lui	a4,0xfffff
    80000aa6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa8:	94be                	add	s1,s1,a5
    80000aaa:	0095ee63          	bltu	a1,s1,80000ac6 <freerange+0x3c>
    80000aae:	892e                	mv	s2,a1
    kfree(p);
    80000ab0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab2:	6985                	lui	s3,0x1
    kfree(p);
    80000ab4:	01448533          	add	a0,s1,s4
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	f5c080e7          	jalr	-164(ra) # 80000a14 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94ce                	add	s1,s1,s3
    80000ac2:	fe9979e3          	bgeu	s2,s1,80000ab4 <freerange+0x2a>
}
    80000ac6:	70a2                	ld	ra,40(sp)
    80000ac8:	7402                	ld	s0,32(sp)
    80000aca:	64e2                	ld	s1,24(sp)
    80000acc:	6942                	ld	s2,16(sp)
    80000ace:	69a2                	ld	s3,8(sp)
    80000ad0:	6a02                	ld	s4,0(sp)
    80000ad2:	6145                	add	sp,sp,48
    80000ad4:	8082                	ret

0000000080000ad6 <kinit>:
{
    80000ad6:	1141                	add	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ade:	00007597          	auipc	a1,0x7
    80000ae2:	58a58593          	add	a1,a1,1418 # 80008068 <digits+0x28>
    80000ae6:	00010517          	auipc	a0,0x10
    80000aea:	78a50513          	add	a0,a0,1930 # 80011270 <kmem>
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	084080e7          	jalr	132(ra) # 80000b72 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af6:	45c5                	li	a1,17
    80000af8:	05ee                	sll	a1,a1,0x1b
    80000afa:	00025517          	auipc	a0,0x25
    80000afe:	50650513          	add	a0,a0,1286 # 80026000 <end>
    80000b02:	00000097          	auipc	ra,0x0
    80000b06:	f88080e7          	jalr	-120(ra) # 80000a8a <freerange>
}
    80000b0a:	60a2                	ld	ra,8(sp)
    80000b0c:	6402                	ld	s0,0(sp)
    80000b0e:	0141                	add	sp,sp,16
    80000b10:	8082                	ret

0000000080000b12 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b12:	1101                	add	sp,sp,-32
    80000b14:	ec06                	sd	ra,24(sp)
    80000b16:	e822                	sd	s0,16(sp)
    80000b18:	e426                	sd	s1,8(sp)
    80000b1a:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b1c:	00010497          	auipc	s1,0x10
    80000b20:	75448493          	add	s1,s1,1876 # 80011270 <kmem>
    80000b24:	8526                	mv	a0,s1
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	0dc080e7          	jalr	220(ra) # 80000c02 <acquire>
  r = kmem.freelist;
    80000b2e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b30:	c885                	beqz	s1,80000b60 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b32:	609c                	ld	a5,0(s1)
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	73c50513          	add	a0,a0,1852 # 80011270 <kmem>
    80000b3c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	178080e7          	jalr	376(ra) # 80000cb6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b46:	6605                	lui	a2,0x1
    80000b48:	4595                	li	a1,5
    80000b4a:	8526                	mv	a0,s1
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	1b2080e7          	jalr	434(ra) # 80000cfe <memset>
  return (void*)r;
}
    80000b54:	8526                	mv	a0,s1
    80000b56:	60e2                	ld	ra,24(sp)
    80000b58:	6442                	ld	s0,16(sp)
    80000b5a:	64a2                	ld	s1,8(sp)
    80000b5c:	6105                	add	sp,sp,32
    80000b5e:	8082                	ret
  release(&kmem.lock);
    80000b60:	00010517          	auipc	a0,0x10
    80000b64:	71050513          	add	a0,a0,1808 # 80011270 <kmem>
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	14e080e7          	jalr	334(ra) # 80000cb6 <release>
  if(r)
    80000b70:	b7d5                	j	80000b54 <kalloc+0x42>

0000000080000b72 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b72:	1141                	add	sp,sp,-16
    80000b74:	e422                	sd	s0,8(sp)
    80000b76:	0800                	add	s0,sp,16
  lk->name = name;
    80000b78:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b7e:	00053823          	sd	zero,16(a0)
}
    80000b82:	6422                	ld	s0,8(sp)
    80000b84:	0141                	add	sp,sp,16
    80000b86:	8082                	ret

0000000080000b88 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b88:	411c                	lw	a5,0(a0)
    80000b8a:	e399                	bnez	a5,80000b90 <holding+0x8>
    80000b8c:	4501                	li	a0,0
  return r;
}
    80000b8e:	8082                	ret
{
    80000b90:	1101                	add	sp,sp,-32
    80000b92:	ec06                	sd	ra,24(sp)
    80000b94:	e822                	sd	s0,16(sp)
    80000b96:	e426                	sd	s1,8(sp)
    80000b98:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9a:	6904                	ld	s1,16(a0)
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	da2080e7          	jalr	-606(ra) # 8000193e <mycpu>
    80000ba4:	40a48533          	sub	a0,s1,a0
    80000ba8:	00153513          	seqz	a0,a0
}
    80000bac:	60e2                	ld	ra,24(sp)
    80000bae:	6442                	ld	s0,16(sp)
    80000bb0:	64a2                	ld	s1,8(sp)
    80000bb2:	6105                	add	sp,sp,32
    80000bb4:	8082                	ret

0000000080000bb6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb6:	1101                	add	sp,sp,-32
    80000bb8:	ec06                	sd	ra,24(sp)
    80000bba:	e822                	sd	s0,16(sp)
    80000bbc:	e426                	sd	s1,8(sp)
    80000bbe:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc0:	100024f3          	csrr	s1,sstatus
    80000bc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc8:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bca:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bce:	00001097          	auipc	ra,0x1
    80000bd2:	d70080e7          	jalr	-656(ra) # 8000193e <mycpu>
    80000bd6:	5d3c                	lw	a5,120(a0)
    80000bd8:	cf89                	beqz	a5,80000bf2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bda:	00001097          	auipc	ra,0x1
    80000bde:	d64080e7          	jalr	-668(ra) # 8000193e <mycpu>
    80000be2:	5d3c                	lw	a5,120(a0)
    80000be4:	2785                	addw	a5,a5,1
    80000be6:	dd3c                	sw	a5,120(a0)
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	add	sp,sp,32
    80000bf0:	8082                	ret
    mycpu()->intena = old;
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	d4c080e7          	jalr	-692(ra) # 8000193e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	8085                	srl	s1,s1,0x1
    80000bfc:	8885                	and	s1,s1,1
    80000bfe:	dd64                	sw	s1,124(a0)
    80000c00:	bfe9                	j	80000bda <push_off+0x24>

0000000080000c02 <acquire>:
{
    80000c02:	1101                	add	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	add	s0,sp,32
    80000c0c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	fa8080e7          	jalr	-88(ra) # 80000bb6 <push_off>
  if(holding(lk))
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	f70080e7          	jalr	-144(ra) # 80000b88 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c20:	4705                	li	a4,1
  if(holding(lk))
    80000c22:	e115                	bnez	a0,80000c46 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c24:	87ba                	mv	a5,a4
    80000c26:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c2a:	2781                	sext.w	a5,a5
    80000c2c:	ffe5                	bnez	a5,80000c24 <acquire+0x22>
  __sync_synchronize();
    80000c2e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d0c080e7          	jalr	-756(ra) # 8000193e <mycpu>
    80000c3a:	e888                	sd	a0,16(s1)
}
    80000c3c:	60e2                	ld	ra,24(sp)
    80000c3e:	6442                	ld	s0,16(sp)
    80000c40:	64a2                	ld	s1,8(sp)
    80000c42:	6105                	add	sp,sp,32
    80000c44:	8082                	ret
    panic("acquire");
    80000c46:	00007517          	auipc	a0,0x7
    80000c4a:	42a50513          	add	a0,a0,1066 # 80008070 <digits+0x30>
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	8fa080e7          	jalr	-1798(ra) # 80000548 <panic>

0000000080000c56 <pop_off>:

void
pop_off(void)
{
    80000c56:	1141                	add	sp,sp,-16
    80000c58:	e406                	sd	ra,8(sp)
    80000c5a:	e022                	sd	s0,0(sp)
    80000c5c:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000c5e:	00001097          	auipc	ra,0x1
    80000c62:	ce0080e7          	jalr	-800(ra) # 8000193e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c66:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c6a:	8b89                	and	a5,a5,2
  if(intr_get())
    80000c6c:	e78d                	bnez	a5,80000c96 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c6e:	5d3c                	lw	a5,120(a0)
    80000c70:	02f05b63          	blez	a5,80000ca6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c74:	37fd                	addw	a5,a5,-1
    80000c76:	0007871b          	sext.w	a4,a5
    80000c7a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c7c:	eb09                	bnez	a4,80000c8e <pop_off+0x38>
    80000c7e:	5d7c                	lw	a5,124(a0)
    80000c80:	c799                	beqz	a5,80000c8e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c86:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c8a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c8e:	60a2                	ld	ra,8(sp)
    80000c90:	6402                	ld	s0,0(sp)
    80000c92:	0141                	add	sp,sp,16
    80000c94:	8082                	ret
    panic("pop_off - interruptible");
    80000c96:	00007517          	auipc	a0,0x7
    80000c9a:	3e250513          	add	a0,a0,994 # 80008078 <digits+0x38>
    80000c9e:	00000097          	auipc	ra,0x0
    80000ca2:	8aa080e7          	jalr	-1878(ra) # 80000548 <panic>
    panic("pop_off");
    80000ca6:	00007517          	auipc	a0,0x7
    80000caa:	3ea50513          	add	a0,a0,1002 # 80008090 <digits+0x50>
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	89a080e7          	jalr	-1894(ra) # 80000548 <panic>

0000000080000cb6 <release>:
{
    80000cb6:	1101                	add	sp,sp,-32
    80000cb8:	ec06                	sd	ra,24(sp)
    80000cba:	e822                	sd	s0,16(sp)
    80000cbc:	e426                	sd	s1,8(sp)
    80000cbe:	1000                	add	s0,sp,32
    80000cc0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	ec6080e7          	jalr	-314(ra) # 80000b88 <holding>
    80000cca:	c115                	beqz	a0,80000cee <release+0x38>
  lk->cpu = 0;
    80000ccc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cd4:	0f50000f          	fence	iorw,ow
    80000cd8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cdc:	00000097          	auipc	ra,0x0
    80000ce0:	f7a080e7          	jalr	-134(ra) # 80000c56 <pop_off>
}
    80000ce4:	60e2                	ld	ra,24(sp)
    80000ce6:	6442                	ld	s0,16(sp)
    80000ce8:	64a2                	ld	s1,8(sp)
    80000cea:	6105                	add	sp,sp,32
    80000cec:	8082                	ret
    panic("release");
    80000cee:	00007517          	auipc	a0,0x7
    80000cf2:	3aa50513          	add	a0,a0,938 # 80008098 <digits+0x58>
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	852080e7          	jalr	-1966(ra) # 80000548 <panic>

0000000080000cfe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cfe:	1141                	add	sp,sp,-16
    80000d00:	e422                	sd	s0,8(sp)
    80000d02:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d04:	ca19                	beqz	a2,80000d1a <memset+0x1c>
    80000d06:	87aa                	mv	a5,a0
    80000d08:	1602                	sll	a2,a2,0x20
    80000d0a:	9201                	srl	a2,a2,0x20
    80000d0c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d10:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d14:	0785                	add	a5,a5,1
    80000d16:	fee79de3          	bne	a5,a4,80000d10 <memset+0x12>
  }
  return dst;
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	add	sp,sp,16
    80000d1e:	8082                	ret

0000000080000d20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d20:	1141                	add	sp,sp,-16
    80000d22:	e422                	sd	s0,8(sp)
    80000d24:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	ca05                	beqz	a2,80000d56 <memcmp+0x36>
    80000d28:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d2c:	1682                	sll	a3,a3,0x20
    80000d2e:	9281                	srl	a3,a3,0x20
    80000d30:	0685                	add	a3,a3,1
    80000d32:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d34:	00054783          	lbu	a5,0(a0)
    80000d38:	0005c703          	lbu	a4,0(a1)
    80000d3c:	00e79863          	bne	a5,a4,80000d4c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d40:	0505                	add	a0,a0,1
    80000d42:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000d44:	fed518e3          	bne	a0,a3,80000d34 <memcmp+0x14>
  }

  return 0;
    80000d48:	4501                	li	a0,0
    80000d4a:	a019                	j	80000d50 <memcmp+0x30>
      return *s1 - *s2;
    80000d4c:	40e7853b          	subw	a0,a5,a4
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	add	sp,sp,16
    80000d54:	8082                	ret
  return 0;
    80000d56:	4501                	li	a0,0
    80000d58:	bfe5                	j	80000d50 <memcmp+0x30>

0000000080000d5a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d5a:	1141                	add	sp,sp,-16
    80000d5c:	e422                	sd	s0,8(sp)
    80000d5e:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d60:	02a5e563          	bltu	a1,a0,80000d8a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d64:	fff6069b          	addw	a3,a2,-1
    80000d68:	ce11                	beqz	a2,80000d84 <memmove+0x2a>
    80000d6a:	1682                	sll	a3,a3,0x20
    80000d6c:	9281                	srl	a3,a3,0x20
    80000d6e:	0685                	add	a3,a3,1
    80000d70:	96ae                	add	a3,a3,a1
    80000d72:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d74:	0585                	add	a1,a1,1
    80000d76:	0785                	add	a5,a5,1
    80000d78:	fff5c703          	lbu	a4,-1(a1)
    80000d7c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d80:	fed59ae3          	bne	a1,a3,80000d74 <memmove+0x1a>

  return dst;
}
    80000d84:	6422                	ld	s0,8(sp)
    80000d86:	0141                	add	sp,sp,16
    80000d88:	8082                	ret
  if(s < d && s + n > d){
    80000d8a:	02061713          	sll	a4,a2,0x20
    80000d8e:	9301                	srl	a4,a4,0x20
    80000d90:	00e587b3          	add	a5,a1,a4
    80000d94:	fcf578e3          	bgeu	a0,a5,80000d64 <memmove+0xa>
    d += n;
    80000d98:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d9a:	fff6069b          	addw	a3,a2,-1
    80000d9e:	d27d                	beqz	a2,80000d84 <memmove+0x2a>
    80000da0:	02069613          	sll	a2,a3,0x20
    80000da4:	9201                	srl	a2,a2,0x20
    80000da6:	fff64613          	not	a2,a2
    80000daa:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000dac:	17fd                	add	a5,a5,-1
    80000dae:	177d                	add	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
    80000db0:	0007c683          	lbu	a3,0(a5)
    80000db4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000db8:	fef61ae3          	bne	a2,a5,80000dac <memmove+0x52>
    80000dbc:	b7e1                	j	80000d84 <memmove+0x2a>

0000000080000dbe <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dbe:	1141                	add	sp,sp,-16
    80000dc0:	e406                	sd	ra,8(sp)
    80000dc2:	e022                	sd	s0,0(sp)
    80000dc4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	f94080e7          	jalr	-108(ra) # 80000d5a <memmove>
}
    80000dce:	60a2                	ld	ra,8(sp)
    80000dd0:	6402                	ld	s0,0(sp)
    80000dd2:	0141                	add	sp,sp,16
    80000dd4:	8082                	ret

0000000080000dd6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dd6:	1141                	add	sp,sp,-16
    80000dd8:	e422                	sd	s0,8(sp)
    80000dda:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ddc:	ce11                	beqz	a2,80000df8 <strncmp+0x22>
    80000dde:	00054783          	lbu	a5,0(a0)
    80000de2:	cf89                	beqz	a5,80000dfc <strncmp+0x26>
    80000de4:	0005c703          	lbu	a4,0(a1)
    80000de8:	00f71a63          	bne	a4,a5,80000dfc <strncmp+0x26>
    n--, p++, q++;
    80000dec:	367d                	addw	a2,a2,-1
    80000dee:	0505                	add	a0,a0,1
    80000df0:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000df2:	f675                	bnez	a2,80000dde <strncmp+0x8>
  if(n == 0)
    return 0;
    80000df4:	4501                	li	a0,0
    80000df6:	a809                	j	80000e08 <strncmp+0x32>
    80000df8:	4501                	li	a0,0
    80000dfa:	a039                	j	80000e08 <strncmp+0x32>
  if(n == 0)
    80000dfc:	ca09                	beqz	a2,80000e0e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dfe:	00054503          	lbu	a0,0(a0)
    80000e02:	0005c783          	lbu	a5,0(a1)
    80000e06:	9d1d                	subw	a0,a0,a5
}
    80000e08:	6422                	ld	s0,8(sp)
    80000e0a:	0141                	add	sp,sp,16
    80000e0c:	8082                	ret
    return 0;
    80000e0e:	4501                	li	a0,0
    80000e10:	bfe5                	j	80000e08 <strncmp+0x32>

0000000080000e12 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e12:	1141                	add	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e18:	87aa                	mv	a5,a0
    80000e1a:	86b2                	mv	a3,a2
    80000e1c:	367d                	addw	a2,a2,-1
    80000e1e:	00d05963          	blez	a3,80000e30 <strncpy+0x1e>
    80000e22:	0785                	add	a5,a5,1
    80000e24:	0005c703          	lbu	a4,0(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	0585                	add	a1,a1,1
    80000e2e:	f775                	bnez	a4,80000e1a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e30:	873e                	mv	a4,a5
    80000e32:	9fb5                	addw	a5,a5,a3
    80000e34:	37fd                	addw	a5,a5,-1
    80000e36:	00c05963          	blez	a2,80000e48 <strncpy+0x36>
    *s++ = 0;
    80000e3a:	0705                	add	a4,a4,1
    80000e3c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e40:	40e786bb          	subw	a3,a5,a4
    80000e44:	fed04be3          	bgtz	a3,80000e3a <strncpy+0x28>
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	add	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4e:	1141                	add	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2c>
    80000e58:	fff6069b          	addw	a3,a2,-1
    80000e5c:	1682                	sll	a3,a3,0x20
    80000e5e:	9281                	srl	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x28>
    80000e68:	0585                	add	a1,a1,1
    80000e6a:	0785                	add	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	6422                	ld	s0,8(sp)
    80000e7c:	0141                	add	sp,sp,16
    80000e7e:	8082                	ret

0000000080000e80 <strlen>:

int
strlen(const char *s)
{
    80000e80:	1141                	add	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e86:	00054783          	lbu	a5,0(a0)
    80000e8a:	cf91                	beqz	a5,80000ea6 <strlen+0x26>
    80000e8c:	0505                	add	a0,a0,1
    80000e8e:	87aa                	mv	a5,a0
    80000e90:	86be                	mv	a3,a5
    80000e92:	0785                	add	a5,a5,1
    80000e94:	fff7c703          	lbu	a4,-1(a5)
    80000e98:	ff65                	bnez	a4,80000e90 <strlen+0x10>
    80000e9a:	40a6853b          	subw	a0,a3,a0
    80000e9e:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000ea0:	6422                	ld	s0,8(sp)
    80000ea2:	0141                	add	sp,sp,16
    80000ea4:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ea6:	4501                	li	a0,0
    80000ea8:	bfe5                	j	80000ea0 <strlen+0x20>

0000000080000eaa <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eaa:	1141                	add	sp,sp,-16
    80000eac:	e406                	sd	ra,8(sp)
    80000eae:	e022                	sd	s0,0(sp)
    80000eb0:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	a7c080e7          	jalr	-1412(ra) # 8000192e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	15270713          	add	a4,a4,338 # 8000900c <started>
  if(cpuid() == 0){
    80000ec2:	c139                	beqz	a0,80000f08 <main+0x5e>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x1a>
      ;
    __sync_synchronize();
    80000eca:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	a60080e7          	jalr	-1440(ra) # 8000192e <cpuid>
    80000ed6:	85aa                	mv	a1,a0
    80000ed8:	00007517          	auipc	a0,0x7
    80000edc:	1e050513          	add	a0,a0,480 # 800080b8 <digits+0x78>
    80000ee0:	fffff097          	auipc	ra,0xfffff
    80000ee4:	6b2080e7          	jalr	1714(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000ee8:	00000097          	auipc	ra,0x0
    80000eec:	17e080e7          	jalr	382(ra) # 80001066 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef0:	00001097          	auipc	ra,0x1
    80000ef4:	6c8080e7          	jalr	1736(ra) # 800025b8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	c18080e7          	jalr	-1000(ra) # 80005b10 <plicinithart>
  }

  scheduler();        
    80000f00:	00001097          	auipc	ra,0x1
    80000f04:	f92080e7          	jalr	-110(ra) # 80001e92 <scheduler>
    consoleinit();
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	550080e7          	jalr	1360(ra) # 80000458 <consoleinit>
    printfinit();
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	862080e7          	jalr	-1950(ra) # 80000772 <printfinit>
    printf("\n");
    80000f18:	00007517          	auipc	a0,0x7
    80000f1c:	1b050513          	add	a0,a0,432 # 800080c8 <digits+0x88>
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	672080e7          	jalr	1650(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000f28:	00007517          	auipc	a0,0x7
    80000f2c:	17850513          	add	a0,a0,376 # 800080a0 <digits+0x60>
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	662080e7          	jalr	1634(ra) # 80000592 <printf>
    printf("\n");
    80000f38:	00007517          	auipc	a0,0x7
    80000f3c:	19050513          	add	a0,a0,400 # 800080c8 <digits+0x88>
    80000f40:	fffff097          	auipc	ra,0xfffff
    80000f44:	652080e7          	jalr	1618(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000f48:	00000097          	auipc	ra,0x0
    80000f4c:	b8e080e7          	jalr	-1138(ra) # 80000ad6 <kinit>
    kvminit();       // create kernel page table
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	242080e7          	jalr	578(ra) # 80001192 <kvminit>
    kvminithart();   // turn on paging
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	10e080e7          	jalr	270(ra) # 80001066 <kvminithart>
    procinit();      // process table
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	8fe080e7          	jalr	-1794(ra) # 8000185e <procinit>
    trapinit();      // trap vectors
    80000f68:	00001097          	auipc	ra,0x1
    80000f6c:	628080e7          	jalr	1576(ra) # 80002590 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f70:	00001097          	auipc	ra,0x1
    80000f74:	648080e7          	jalr	1608(ra) # 800025b8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f78:	00005097          	auipc	ra,0x5
    80000f7c:	b82080e7          	jalr	-1150(ra) # 80005afa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	b90080e7          	jalr	-1136(ra) # 80005b10 <plicinithart>
    binit();         // buffer cache
    80000f88:	00002097          	auipc	ra,0x2
    80000f8c:	d76080e7          	jalr	-650(ra) # 80002cfe <binit>
    iinit();         // inode cache
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	402080e7          	jalr	1026(ra) # 80003392 <iinit>
    fileinit();      // file table
    80000f98:	00003097          	auipc	ra,0x3
    80000f9c:	38a080e7          	jalr	906(ra) # 80004322 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	c90080e7          	jalr	-880(ra) # 80005c30 <virtio_disk_init>
    userinit();      // first user process
    80000fa8:	00001097          	auipc	ra,0x1
    80000fac:	c7c080e7          	jalr	-900(ra) # 80001c24 <userinit>
    __sync_synchronize();
    80000fb0:	0ff0000f          	fence
    started = 1;
    80000fb4:	4785                	li	a5,1
    80000fb6:	00008717          	auipc	a4,0x8
    80000fba:	04f72b23          	sw	a5,86(a4) # 8000900c <started>
    80000fbe:	b789                	j	80000f00 <main+0x56>

0000000080000fc0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fc0:	7139                	add	sp,sp,-64
    80000fc2:	fc06                	sd	ra,56(sp)
    80000fc4:	f822                	sd	s0,48(sp)
    80000fc6:	f426                	sd	s1,40(sp)
    80000fc8:	f04a                	sd	s2,32(sp)
    80000fca:	ec4e                	sd	s3,24(sp)
    80000fcc:	e852                	sd	s4,16(sp)
    80000fce:	e456                	sd	s5,8(sp)
    80000fd0:	e05a                	sd	s6,0(sp)
    80000fd2:	0080                	add	s0,sp,64
    80000fd4:	84aa                	mv	s1,a0
    80000fd6:	89ae                	mv	s3,a1
    80000fd8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fda:	57fd                	li	a5,-1
    80000fdc:	83e9                	srl	a5,a5,0x1a
    80000fde:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fe0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fe2:	04b7f263          	bgeu	a5,a1,80001026 <walk+0x66>
    panic("walk");
    80000fe6:	00007517          	auipc	a0,0x7
    80000fea:	0ea50513          	add	a0,a0,234 # 800080d0 <digits+0x90>
    80000fee:	fffff097          	auipc	ra,0xfffff
    80000ff2:	55a080e7          	jalr	1370(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ff6:	060a8663          	beqz	s5,80001062 <walk+0xa2>
    80000ffa:	00000097          	auipc	ra,0x0
    80000ffe:	b18080e7          	jalr	-1256(ra) # 80000b12 <kalloc>
    80001002:	84aa                	mv	s1,a0
    80001004:	c529                	beqz	a0,8000104e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001006:	6605                	lui	a2,0x1
    80001008:	4581                	li	a1,0
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	cf4080e7          	jalr	-780(ra) # 80000cfe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srl	a5,s1,0xc
    80001016:	07aa                	sll	a5,a5,0xa
    80001018:	0017e793          	or	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001020:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    80001022:	036a0063          	beq	s4,s6,80001042 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001026:	0149d933          	srl	s2,s3,s4
    8000102a:	1ff97913          	and	s2,s2,511
    8000102e:	090e                	sll	s2,s2,0x3
    80001030:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001032:	00093483          	ld	s1,0(s2)
    80001036:	0014f793          	and	a5,s1,1
    8000103a:	dfd5                	beqz	a5,80000ff6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000103c:	80a9                	srl	s1,s1,0xa
    8000103e:	04b2                	sll	s1,s1,0xc
    80001040:	b7c5                	j	80001020 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001042:	00c9d513          	srl	a0,s3,0xc
    80001046:	1ff57513          	and	a0,a0,511
    8000104a:	050e                	sll	a0,a0,0x3
    8000104c:	9526                	add	a0,a0,s1
}
    8000104e:	70e2                	ld	ra,56(sp)
    80001050:	7442                	ld	s0,48(sp)
    80001052:	74a2                	ld	s1,40(sp)
    80001054:	7902                	ld	s2,32(sp)
    80001056:	69e2                	ld	s3,24(sp)
    80001058:	6a42                	ld	s4,16(sp)
    8000105a:	6aa2                	ld	s5,8(sp)
    8000105c:	6b02                	ld	s6,0(sp)
    8000105e:	6121                	add	sp,sp,64
    80001060:	8082                	ret
        return 0;
    80001062:	4501                	li	a0,0
    80001064:	b7ed                	j	8000104e <walk+0x8e>

0000000080001066 <kvminithart>:
{
    80001066:	1141                	add	sp,sp,-16
    80001068:	e422                	sd	s0,8(sp)
    8000106a:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000106c:	00008797          	auipc	a5,0x8
    80001070:	fa47b783          	ld	a5,-92(a5) # 80009010 <kernel_pagetable>
    80001074:	83b1                	srl	a5,a5,0xc
    80001076:	577d                	li	a4,-1
    80001078:	177e                	sll	a4,a4,0x3f
    8000107a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000107c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001080:	12000073          	sfence.vma
}
    80001084:	6422                	ld	s0,8(sp)
    80001086:	0141                	add	sp,sp,16
    80001088:	8082                	ret

000000008000108a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000108a:	57fd                	li	a5,-1
    8000108c:	83e9                	srl	a5,a5,0x1a
    8000108e:	00b7f463          	bgeu	a5,a1,80001096 <walkaddr+0xc>
    return 0;
    80001092:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001094:	8082                	ret
{
    80001096:	1141                	add	sp,sp,-16
    80001098:	e406                	sd	ra,8(sp)
    8000109a:	e022                	sd	s0,0(sp)
    8000109c:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000109e:	4601                	li	a2,0
    800010a0:	00000097          	auipc	ra,0x0
    800010a4:	f20080e7          	jalr	-224(ra) # 80000fc0 <walk>
  if(pte == 0)
    800010a8:	c105                	beqz	a0,800010c8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010aa:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010ac:	0117f693          	and	a3,a5,17
    800010b0:	4745                	li	a4,17
    return 0;
    800010b2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010b4:	00e68663          	beq	a3,a4,800010c0 <walkaddr+0x36>
}
    800010b8:	60a2                	ld	ra,8(sp)
    800010ba:	6402                	ld	s0,0(sp)
    800010bc:	0141                	add	sp,sp,16
    800010be:	8082                	ret
  pa = PTE2PA(*pte);
    800010c0:	83a9                	srl	a5,a5,0xa
    800010c2:	00c79513          	sll	a0,a5,0xc
  return pa;
    800010c6:	bfcd                	j	800010b8 <walkaddr+0x2e>
    return 0;
    800010c8:	4501                	li	a0,0
    800010ca:	b7fd                	j	800010b8 <walkaddr+0x2e>

00000000800010cc <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010cc:	715d                	add	sp,sp,-80
    800010ce:	e486                	sd	ra,72(sp)
    800010d0:	e0a2                	sd	s0,64(sp)
    800010d2:	fc26                	sd	s1,56(sp)
    800010d4:	f84a                	sd	s2,48(sp)
    800010d6:	f44e                	sd	s3,40(sp)
    800010d8:	f052                	sd	s4,32(sp)
    800010da:	ec56                	sd	s5,24(sp)
    800010dc:	e85a                	sd	s6,16(sp)
    800010de:	e45e                	sd	s7,8(sp)
    800010e0:	0880                	add	s0,sp,80
    800010e2:	8aaa                	mv	s5,a0
    800010e4:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010e6:	777d                	lui	a4,0xfffff
    800010e8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ec:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    800010f0:	99ae                	add	s3,s3,a1
    800010f2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010f6:	893e                	mv	s2,a5
    800010f8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010fc:	6b85                	lui	s7,0x1
    800010fe:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001102:	4605                	li	a2,1
    80001104:	85ca                	mv	a1,s2
    80001106:	8556                	mv	a0,s5
    80001108:	00000097          	auipc	ra,0x0
    8000110c:	eb8080e7          	jalr	-328(ra) # 80000fc0 <walk>
    80001110:	c51d                	beqz	a0,8000113e <mappages+0x72>
    if(*pte & PTE_V)
    80001112:	611c                	ld	a5,0(a0)
    80001114:	8b85                	and	a5,a5,1
    80001116:	ef81                	bnez	a5,8000112e <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001118:	80b1                	srl	s1,s1,0xc
    8000111a:	04aa                	sll	s1,s1,0xa
    8000111c:	0164e4b3          	or	s1,s1,s6
    80001120:	0014e493          	or	s1,s1,1
    80001124:	e104                	sd	s1,0(a0)
    if(a == last)
    80001126:	03390863          	beq	s2,s3,80001156 <mappages+0x8a>
    a += PGSIZE;
    8000112a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000112c:	bfc9                	j	800010fe <mappages+0x32>
      panic("remap");
    8000112e:	00007517          	auipc	a0,0x7
    80001132:	faa50513          	add	a0,a0,-86 # 800080d8 <digits+0x98>
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	412080e7          	jalr	1042(ra) # 80000548 <panic>
      return -1;
    8000113e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001140:	60a6                	ld	ra,72(sp)
    80001142:	6406                	ld	s0,64(sp)
    80001144:	74e2                	ld	s1,56(sp)
    80001146:	7942                	ld	s2,48(sp)
    80001148:	79a2                	ld	s3,40(sp)
    8000114a:	7a02                	ld	s4,32(sp)
    8000114c:	6ae2                	ld	s5,24(sp)
    8000114e:	6b42                	ld	s6,16(sp)
    80001150:	6ba2                	ld	s7,8(sp)
    80001152:	6161                	add	sp,sp,80
    80001154:	8082                	ret
  return 0;
    80001156:	4501                	li	a0,0
    80001158:	b7e5                	j	80001140 <mappages+0x74>

000000008000115a <kvmmap>:
{
    8000115a:	1141                	add	sp,sp,-16
    8000115c:	e406                	sd	ra,8(sp)
    8000115e:	e022                	sd	s0,0(sp)
    80001160:	0800                	add	s0,sp,16
    80001162:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001164:	86ae                	mv	a3,a1
    80001166:	85aa                	mv	a1,a0
    80001168:	00008517          	auipc	a0,0x8
    8000116c:	ea853503          	ld	a0,-344(a0) # 80009010 <kernel_pagetable>
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f5c080e7          	jalr	-164(ra) # 800010cc <mappages>
    80001178:	e509                	bnez	a0,80001182 <kvmmap+0x28>
}
    8000117a:	60a2                	ld	ra,8(sp)
    8000117c:	6402                	ld	s0,0(sp)
    8000117e:	0141                	add	sp,sp,16
    80001180:	8082                	ret
    panic("kvmmap");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	f5e50513          	add	a0,a0,-162 # 800080e0 <digits+0xa0>
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	3be080e7          	jalr	958(ra) # 80000548 <panic>

0000000080001192 <kvminit>:
{
    80001192:	1101                	add	sp,sp,-32
    80001194:	ec06                	sd	ra,24(sp)
    80001196:	e822                	sd	s0,16(sp)
    80001198:	e426                	sd	s1,8(sp)
    8000119a:	1000                	add	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	976080e7          	jalr	-1674(ra) # 80000b12 <kalloc>
    800011a4:	00008717          	auipc	a4,0x8
    800011a8:	e6a73623          	sd	a0,-404(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800011ac:	6605                	lui	a2,0x1
    800011ae:	4581                	li	a1,0
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	b4e080e7          	jalr	-1202(ra) # 80000cfe <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011b8:	4699                	li	a3,6
    800011ba:	6605                	lui	a2,0x1
    800011bc:	100005b7          	lui	a1,0x10000
    800011c0:	10000537          	lui	a0,0x10000
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	f96080e7          	jalr	-106(ra) # 8000115a <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011cc:	4699                	li	a3,6
    800011ce:	6605                	lui	a2,0x1
    800011d0:	100015b7          	lui	a1,0x10001
    800011d4:	10001537          	lui	a0,0x10001
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f82080e7          	jalr	-126(ra) # 8000115a <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011e0:	4699                	li	a3,6
    800011e2:	00400637          	lui	a2,0x400
    800011e6:	0c0005b7          	lui	a1,0xc000
    800011ea:	0c000537          	lui	a0,0xc000
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f6c080e7          	jalr	-148(ra) # 8000115a <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011f6:	00007497          	auipc	s1,0x7
    800011fa:	e0a48493          	add	s1,s1,-502 # 80008000 <etext>
    800011fe:	46a9                	li	a3,10
    80001200:	80007617          	auipc	a2,0x80007
    80001204:	e0060613          	add	a2,a2,-512 # 8000 <_entry-0x7fff8000>
    80001208:	4585                	li	a1,1
    8000120a:	05fe                	sll	a1,a1,0x1f
    8000120c:	852e                	mv	a0,a1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f4c080e7          	jalr	-180(ra) # 8000115a <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001216:	4699                	li	a3,6
    80001218:	4645                	li	a2,17
    8000121a:	066e                	sll	a2,a2,0x1b
    8000121c:	8e05                	sub	a2,a2,s1
    8000121e:	85a6                	mv	a1,s1
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f38080e7          	jalr	-200(ra) # 8000115a <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000122a:	46a9                	li	a3,10
    8000122c:	6605                	lui	a2,0x1
    8000122e:	00006597          	auipc	a1,0x6
    80001232:	dd258593          	add	a1,a1,-558 # 80007000 <_trampoline>
    80001236:	04000537          	lui	a0,0x4000
    8000123a:	157d                	add	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    8000123c:	0532                	sll	a0,a0,0xc
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f1c080e7          	jalr	-228(ra) # 8000115a <kvmmap>
}
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	64a2                	ld	s1,8(sp)
    8000124c:	6105                	add	sp,sp,32
    8000124e:	8082                	ret

0000000080001250 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001250:	715d                	add	sp,sp,-80
    80001252:	e486                	sd	ra,72(sp)
    80001254:	e0a2                	sd	s0,64(sp)
    80001256:	fc26                	sd	s1,56(sp)
    80001258:	f84a                	sd	s2,48(sp)
    8000125a:	f44e                	sd	s3,40(sp)
    8000125c:	f052                	sd	s4,32(sp)
    8000125e:	ec56                	sd	s5,24(sp)
    80001260:	e85a                	sd	s6,16(sp)
    80001262:	e45e                	sd	s7,8(sp)
    80001264:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001266:	03459793          	sll	a5,a1,0x34
    8000126a:	e795                	bnez	a5,80001296 <uvmunmap+0x46>
    8000126c:	8a2a                	mv	s4,a0
    8000126e:	892e                	mv	s2,a1
    80001270:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001272:	0632                	sll	a2,a2,0xc
    80001274:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001278:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127a:	6b05                	lui	s6,0x1
    8000127c:	0735e263          	bltu	a1,s3,800012e0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001280:	60a6                	ld	ra,72(sp)
    80001282:	6406                	ld	s0,64(sp)
    80001284:	74e2                	ld	s1,56(sp)
    80001286:	7942                	ld	s2,48(sp)
    80001288:	79a2                	ld	s3,40(sp)
    8000128a:	7a02                	ld	s4,32(sp)
    8000128c:	6ae2                	ld	s5,24(sp)
    8000128e:	6b42                	ld	s6,16(sp)
    80001290:	6ba2                	ld	s7,8(sp)
    80001292:	6161                	add	sp,sp,80
    80001294:	8082                	ret
    panic("uvmunmap: not aligned");
    80001296:	00007517          	auipc	a0,0x7
    8000129a:	e5250513          	add	a0,a0,-430 # 800080e8 <digits+0xa8>
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	2aa080e7          	jalr	682(ra) # 80000548 <panic>
      panic("uvmunmap: walk");
    800012a6:	00007517          	auipc	a0,0x7
    800012aa:	e5a50513          	add	a0,a0,-422 # 80008100 <digits+0xc0>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	29a080e7          	jalr	666(ra) # 80000548 <panic>
      panic("uvmunmap: not mapped");
    800012b6:	00007517          	auipc	a0,0x7
    800012ba:	e5a50513          	add	a0,a0,-422 # 80008110 <digits+0xd0>
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	28a080e7          	jalr	650(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    800012c6:	00007517          	auipc	a0,0x7
    800012ca:	e6250513          	add	a0,a0,-414 # 80008128 <digits+0xe8>
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	27a080e7          	jalr	634(ra) # 80000548 <panic>
    *pte = 0;
    800012d6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012da:	995a                	add	s2,s2,s6
    800012dc:	fb3972e3          	bgeu	s2,s3,80001280 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012e0:	4601                	li	a2,0
    800012e2:	85ca                	mv	a1,s2
    800012e4:	8552                	mv	a0,s4
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	cda080e7          	jalr	-806(ra) # 80000fc0 <walk>
    800012ee:	84aa                	mv	s1,a0
    800012f0:	d95d                	beqz	a0,800012a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012f2:	6108                	ld	a0,0(a0)
    800012f4:	00157793          	and	a5,a0,1
    800012f8:	dfdd                	beqz	a5,800012b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fa:	3ff57793          	and	a5,a0,1023
    800012fe:	fd7784e3          	beq	a5,s7,800012c6 <uvmunmap+0x76>
    if(do_free){
    80001302:	fc0a8ae3          	beqz	s5,800012d6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001306:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001308:	0532                	sll	a0,a0,0xc
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	70a080e7          	jalr	1802(ra) # 80000a14 <kfree>
    80001312:	b7d1                	j	800012d6 <uvmunmap+0x86>

0000000080001314 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001314:	1101                	add	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	7f4080e7          	jalr	2036(ra) # 80000b12 <kalloc>
    80001326:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001328:	c519                	beqz	a0,80001336 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000132a:	6605                	lui	a2,0x1
    8000132c:	4581                	li	a1,0
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	9d0080e7          	jalr	-1584(ra) # 80000cfe <memset>
  return pagetable;
}
    80001336:	8526                	mv	a0,s1
    80001338:	60e2                	ld	ra,24(sp)
    8000133a:	6442                	ld	s0,16(sp)
    8000133c:	64a2                	ld	s1,8(sp)
    8000133e:	6105                	add	sp,sp,32
    80001340:	8082                	ret

0000000080001342 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001342:	7179                	add	sp,sp,-48
    80001344:	f406                	sd	ra,40(sp)
    80001346:	f022                	sd	s0,32(sp)
    80001348:	ec26                	sd	s1,24(sp)
    8000134a:	e84a                	sd	s2,16(sp)
    8000134c:	e44e                	sd	s3,8(sp)
    8000134e:	e052                	sd	s4,0(sp)
    80001350:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001352:	6785                	lui	a5,0x1
    80001354:	04f67863          	bgeu	a2,a5,800013a4 <uvminit+0x62>
    80001358:	8a2a                	mv	s4,a0
    8000135a:	89ae                	mv	s3,a1
    8000135c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	7b4080e7          	jalr	1972(ra) # 80000b12 <kalloc>
    80001366:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001368:	6605                	lui	a2,0x1
    8000136a:	4581                	li	a1,0
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	992080e7          	jalr	-1646(ra) # 80000cfe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001374:	4779                	li	a4,30
    80001376:	86ca                	mv	a3,s2
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	8552                	mv	a0,s4
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	d4e080e7          	jalr	-690(ra) # 800010cc <mappages>
  memmove(mem, src, sz);
    80001386:	8626                	mv	a2,s1
    80001388:	85ce                	mv	a1,s3
    8000138a:	854a                	mv	a0,s2
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	9ce080e7          	jalr	-1586(ra) # 80000d5a <memmove>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	add	sp,sp,48
    800013a2:	8082                	ret
    panic("inituvm: more than a page");
    800013a4:	00007517          	auipc	a0,0x7
    800013a8:	d9c50513          	add	a0,a0,-612 # 80008140 <digits+0x100>
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	19c080e7          	jalr	412(ra) # 80000548 <panic>

00000000800013b4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b4:	1101                	add	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013be:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013c0:	00b67d63          	bgeu	a2,a1,800013da <uvmdealloc+0x26>
    800013c4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c6:	6785                	lui	a5,0x1
    800013c8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013ca:	00f60733          	add	a4,a2,a5
    800013ce:	76fd                	lui	a3,0xfffff
    800013d0:	8f75                	and	a4,a4,a3
    800013d2:	97ae                	add	a5,a5,a1
    800013d4:	8ff5                	and	a5,a5,a3
    800013d6:	00f76863          	bltu	a4,a5,800013e6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013da:	8526                	mv	a0,s1
    800013dc:	60e2                	ld	ra,24(sp)
    800013de:	6442                	ld	s0,16(sp)
    800013e0:	64a2                	ld	s1,8(sp)
    800013e2:	6105                	add	sp,sp,32
    800013e4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e6:	8f99                	sub	a5,a5,a4
    800013e8:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013ea:	4685                	li	a3,1
    800013ec:	0007861b          	sext.w	a2,a5
    800013f0:	85ba                	mv	a1,a4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	e5e080e7          	jalr	-418(ra) # 80001250 <uvmunmap>
    800013fa:	b7c5                	j	800013da <uvmdealloc+0x26>

00000000800013fc <uvmalloc>:
  if(newsz < oldsz)
    800013fc:	0ab66163          	bltu	a2,a1,8000149e <uvmalloc+0xa2>
{
    80001400:	7139                	add	sp,sp,-64
    80001402:	fc06                	sd	ra,56(sp)
    80001404:	f822                	sd	s0,48(sp)
    80001406:	f426                	sd	s1,40(sp)
    80001408:	f04a                	sd	s2,32(sp)
    8000140a:	ec4e                	sd	s3,24(sp)
    8000140c:	e852                	sd	s4,16(sp)
    8000140e:	e456                	sd	s5,8(sp)
    80001410:	0080                	add	s0,sp,64
    80001412:	8aaa                	mv	s5,a0
    80001414:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001416:	6785                	lui	a5,0x1
    80001418:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000141a:	95be                	add	a1,a1,a5
    8000141c:	77fd                	lui	a5,0xfffff
    8000141e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001422:	08c9f063          	bgeu	s3,a2,800014a2 <uvmalloc+0xa6>
    80001426:	894e                	mv	s2,s3
    mem = kalloc();
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	6ea080e7          	jalr	1770(ra) # 80000b12 <kalloc>
    80001430:	84aa                	mv	s1,a0
    if(mem == 0){
    80001432:	c51d                	beqz	a0,80001460 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001434:	6605                	lui	a2,0x1
    80001436:	4581                	li	a1,0
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	8c6080e7          	jalr	-1850(ra) # 80000cfe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001440:	4779                	li	a4,30
    80001442:	86a6                	mv	a3,s1
    80001444:	6605                	lui	a2,0x1
    80001446:	85ca                	mv	a1,s2
    80001448:	8556                	mv	a0,s5
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	c82080e7          	jalr	-894(ra) # 800010cc <mappages>
    80001452:	e905                	bnez	a0,80001482 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001454:	6785                	lui	a5,0x1
    80001456:	993e                	add	s2,s2,a5
    80001458:	fd4968e3          	bltu	s2,s4,80001428 <uvmalloc+0x2c>
  return newsz;
    8000145c:	8552                	mv	a0,s4
    8000145e:	a809                	j	80001470 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001460:	864e                	mv	a2,s3
    80001462:	85ca                	mv	a1,s2
    80001464:	8556                	mv	a0,s5
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	f4e080e7          	jalr	-178(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000146e:	4501                	li	a0,0
}
    80001470:	70e2                	ld	ra,56(sp)
    80001472:	7442                	ld	s0,48(sp)
    80001474:	74a2                	ld	s1,40(sp)
    80001476:	7902                	ld	s2,32(sp)
    80001478:	69e2                	ld	s3,24(sp)
    8000147a:	6a42                	ld	s4,16(sp)
    8000147c:	6aa2                	ld	s5,8(sp)
    8000147e:	6121                	add	sp,sp,64
    80001480:	8082                	ret
      kfree(mem);
    80001482:	8526                	mv	a0,s1
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	590080e7          	jalr	1424(ra) # 80000a14 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000148c:	864e                	mv	a2,s3
    8000148e:	85ca                	mv	a1,s2
    80001490:	8556                	mv	a0,s5
    80001492:	00000097          	auipc	ra,0x0
    80001496:	f22080e7          	jalr	-222(ra) # 800013b4 <uvmdealloc>
      return 0;
    8000149a:	4501                	li	a0,0
    8000149c:	bfd1                	j	80001470 <uvmalloc+0x74>
    return oldsz;
    8000149e:	852e                	mv	a0,a1
}
    800014a0:	8082                	ret
  return newsz;
    800014a2:	8532                	mv	a0,a2
    800014a4:	b7f1                	j	80001470 <uvmalloc+0x74>

00000000800014a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a6:	7179                	add	sp,sp,-48
    800014a8:	f406                	sd	ra,40(sp)
    800014aa:	f022                	sd	s0,32(sp)
    800014ac:	ec26                	sd	s1,24(sp)
    800014ae:	e84a                	sd	s2,16(sp)
    800014b0:	e44e                	sd	s3,8(sp)
    800014b2:	e052                	sd	s4,0(sp)
    800014b4:	1800                	add	s0,sp,48
    800014b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014b8:	84aa                	mv	s1,a0
    800014ba:	6905                	lui	s2,0x1
    800014bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014be:	4985                	li	s3,1
    800014c0:	a829                	j	800014da <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c2:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014c4:	00c79513          	sll	a0,a5,0xc
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	fde080e7          	jalr	-34(ra) # 800014a6 <freewalk>
      pagetable[i] = 0;
    800014d0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014d4:	04a1                	add	s1,s1,8
    800014d6:	03248163          	beq	s1,s2,800014f8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014da:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014dc:	00f7f713          	and	a4,a5,15
    800014e0:	ff3701e3          	beq	a4,s3,800014c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014e4:	8b85                	and	a5,a5,1
    800014e6:	d7fd                	beqz	a5,800014d4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	c7850513          	add	a0,a0,-904 # 80008160 <digits+0x120>
    800014f0:	fffff097          	auipc	ra,0xfffff
    800014f4:	058080e7          	jalr	88(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    800014f8:	8552                	mv	a0,s4
    800014fa:	fffff097          	auipc	ra,0xfffff
    800014fe:	51a080e7          	jalr	1306(ra) # 80000a14 <kfree>
}
    80001502:	70a2                	ld	ra,40(sp)
    80001504:	7402                	ld	s0,32(sp)
    80001506:	64e2                	ld	s1,24(sp)
    80001508:	6942                	ld	s2,16(sp)
    8000150a:	69a2                	ld	s3,8(sp)
    8000150c:	6a02                	ld	s4,0(sp)
    8000150e:	6145                	add	sp,sp,48
    80001510:	8082                	ret

0000000080001512 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001512:	1101                	add	sp,sp,-32
    80001514:	ec06                	sd	ra,24(sp)
    80001516:	e822                	sd	s0,16(sp)
    80001518:	e426                	sd	s1,8(sp)
    8000151a:	1000                	add	s0,sp,32
    8000151c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000151e:	e999                	bnez	a1,80001534 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001520:	8526                	mv	a0,s1
    80001522:	00000097          	auipc	ra,0x0
    80001526:	f84080e7          	jalr	-124(ra) # 800014a6 <freewalk>
}
    8000152a:	60e2                	ld	ra,24(sp)
    8000152c:	6442                	ld	s0,16(sp)
    8000152e:	64a2                	ld	s1,8(sp)
    80001530:	6105                	add	sp,sp,32
    80001532:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001534:	6785                	lui	a5,0x1
    80001536:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001538:	95be                	add	a1,a1,a5
    8000153a:	4685                	li	a3,1
    8000153c:	00c5d613          	srl	a2,a1,0xc
    80001540:	4581                	li	a1,0
    80001542:	00000097          	auipc	ra,0x0
    80001546:	d0e080e7          	jalr	-754(ra) # 80001250 <uvmunmap>
    8000154a:	bfd9                	j	80001520 <uvmfree+0xe>

000000008000154c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000154c:	c679                	beqz	a2,8000161a <uvmcopy+0xce>
{
    8000154e:	715d                	add	sp,sp,-80
    80001550:	e486                	sd	ra,72(sp)
    80001552:	e0a2                	sd	s0,64(sp)
    80001554:	fc26                	sd	s1,56(sp)
    80001556:	f84a                	sd	s2,48(sp)
    80001558:	f44e                	sd	s3,40(sp)
    8000155a:	f052                	sd	s4,32(sp)
    8000155c:	ec56                	sd	s5,24(sp)
    8000155e:	e85a                	sd	s6,16(sp)
    80001560:	e45e                	sd	s7,8(sp)
    80001562:	0880                	add	s0,sp,80
    80001564:	8b2a                	mv	s6,a0
    80001566:	8aae                	mv	s5,a1
    80001568:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000156a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000156c:	4601                	li	a2,0
    8000156e:	85ce                	mv	a1,s3
    80001570:	855a                	mv	a0,s6
    80001572:	00000097          	auipc	ra,0x0
    80001576:	a4e080e7          	jalr	-1458(ra) # 80000fc0 <walk>
    8000157a:	c531                	beqz	a0,800015c6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000157c:	6118                	ld	a4,0(a0)
    8000157e:	00177793          	and	a5,a4,1
    80001582:	cbb1                	beqz	a5,800015d6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001584:	00a75593          	srl	a1,a4,0xa
    80001588:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000158c:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001590:	fffff097          	auipc	ra,0xfffff
    80001594:	582080e7          	jalr	1410(ra) # 80000b12 <kalloc>
    80001598:	892a                	mv	s2,a0
    8000159a:	c939                	beqz	a0,800015f0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000159c:	6605                	lui	a2,0x1
    8000159e:	85de                	mv	a1,s7
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	7ba080e7          	jalr	1978(ra) # 80000d5a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015a8:	8726                	mv	a4,s1
    800015aa:	86ca                	mv	a3,s2
    800015ac:	6605                	lui	a2,0x1
    800015ae:	85ce                	mv	a1,s3
    800015b0:	8556                	mv	a0,s5
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	b1a080e7          	jalr	-1254(ra) # 800010cc <mappages>
    800015ba:	e515                	bnez	a0,800015e6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015bc:	6785                	lui	a5,0x1
    800015be:	99be                	add	s3,s3,a5
    800015c0:	fb49e6e3          	bltu	s3,s4,8000156c <uvmcopy+0x20>
    800015c4:	a081                	j	80001604 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015c6:	00007517          	auipc	a0,0x7
    800015ca:	baa50513          	add	a0,a0,-1110 # 80008170 <digits+0x130>
    800015ce:	fffff097          	auipc	ra,0xfffff
    800015d2:	f7a080e7          	jalr	-134(ra) # 80000548 <panic>
      panic("uvmcopy: page not present");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	bba50513          	add	a0,a0,-1094 # 80008190 <digits+0x150>
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	f6a080e7          	jalr	-150(ra) # 80000548 <panic>
      kfree(mem);
    800015e6:	854a                	mv	a0,s2
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	42c080e7          	jalr	1068(ra) # 80000a14 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015f0:	4685                	li	a3,1
    800015f2:	00c9d613          	srl	a2,s3,0xc
    800015f6:	4581                	li	a1,0
    800015f8:	8556                	mv	a0,s5
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	c56080e7          	jalr	-938(ra) # 80001250 <uvmunmap>
  return -1;
    80001602:	557d                	li	a0,-1
}
    80001604:	60a6                	ld	ra,72(sp)
    80001606:	6406                	ld	s0,64(sp)
    80001608:	74e2                	ld	s1,56(sp)
    8000160a:	7942                	ld	s2,48(sp)
    8000160c:	79a2                	ld	s3,40(sp)
    8000160e:	7a02                	ld	s4,32(sp)
    80001610:	6ae2                	ld	s5,24(sp)
    80001612:	6b42                	ld	s6,16(sp)
    80001614:	6ba2                	ld	s7,8(sp)
    80001616:	6161                	add	sp,sp,80
    80001618:	8082                	ret
  return 0;
    8000161a:	4501                	li	a0,0
}
    8000161c:	8082                	ret

000000008000161e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000161e:	1141                	add	sp,sp,-16
    80001620:	e406                	sd	ra,8(sp)
    80001622:	e022                	sd	s0,0(sp)
    80001624:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001626:	4601                	li	a2,0
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	998080e7          	jalr	-1640(ra) # 80000fc0 <walk>
  if(pte == 0)
    80001630:	c901                	beqz	a0,80001640 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001632:	611c                	ld	a5,0(a0)
    80001634:	9bbd                	and	a5,a5,-17
    80001636:	e11c                	sd	a5,0(a0)
}
    80001638:	60a2                	ld	ra,8(sp)
    8000163a:	6402                	ld	s0,0(sp)
    8000163c:	0141                	add	sp,sp,16
    8000163e:	8082                	ret
    panic("uvmclear");
    80001640:	00007517          	auipc	a0,0x7
    80001644:	b7050513          	add	a0,a0,-1168 # 800081b0 <digits+0x170>
    80001648:	fffff097          	auipc	ra,0xfffff
    8000164c:	f00080e7          	jalr	-256(ra) # 80000548 <panic>

0000000080001650 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001650:	c6bd                	beqz	a3,800016be <copyout+0x6e>
{
    80001652:	715d                	add	sp,sp,-80
    80001654:	e486                	sd	ra,72(sp)
    80001656:	e0a2                	sd	s0,64(sp)
    80001658:	fc26                	sd	s1,56(sp)
    8000165a:	f84a                	sd	s2,48(sp)
    8000165c:	f44e                	sd	s3,40(sp)
    8000165e:	f052                	sd	s4,32(sp)
    80001660:	ec56                	sd	s5,24(sp)
    80001662:	e85a                	sd	s6,16(sp)
    80001664:	e45e                	sd	s7,8(sp)
    80001666:	e062                	sd	s8,0(sp)
    80001668:	0880                	add	s0,sp,80
    8000166a:	8b2a                	mv	s6,a0
    8000166c:	8c2e                	mv	s8,a1
    8000166e:	8a32                	mv	s4,a2
    80001670:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001672:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001674:	6a85                	lui	s5,0x1
    80001676:	a015                	j	8000169a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001678:	9562                	add	a0,a0,s8
    8000167a:	0004861b          	sext.w	a2,s1
    8000167e:	85d2                	mv	a1,s4
    80001680:	41250533          	sub	a0,a0,s2
    80001684:	fffff097          	auipc	ra,0xfffff
    80001688:	6d6080e7          	jalr	1750(ra) # 80000d5a <memmove>

    len -= n;
    8000168c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001690:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001692:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001696:	02098263          	beqz	s3,800016ba <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000169a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000169e:	85ca                	mv	a1,s2
    800016a0:	855a                	mv	a0,s6
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	9e8080e7          	jalr	-1560(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    800016aa:	cd01                	beqz	a0,800016c2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016ac:	418904b3          	sub	s1,s2,s8
    800016b0:	94d6                	add	s1,s1,s5
    800016b2:	fc99f3e3          	bgeu	s3,s1,80001678 <copyout+0x28>
    800016b6:	84ce                	mv	s1,s3
    800016b8:	b7c1                	j	80001678 <copyout+0x28>
  }
  return 0;
    800016ba:	4501                	li	a0,0
    800016bc:	a021                	j	800016c4 <copyout+0x74>
    800016be:	4501                	li	a0,0
}
    800016c0:	8082                	ret
      return -1;
    800016c2:	557d                	li	a0,-1
}
    800016c4:	60a6                	ld	ra,72(sp)
    800016c6:	6406                	ld	s0,64(sp)
    800016c8:	74e2                	ld	s1,56(sp)
    800016ca:	7942                	ld	s2,48(sp)
    800016cc:	79a2                	ld	s3,40(sp)
    800016ce:	7a02                	ld	s4,32(sp)
    800016d0:	6ae2                	ld	s5,24(sp)
    800016d2:	6b42                	ld	s6,16(sp)
    800016d4:	6ba2                	ld	s7,8(sp)
    800016d6:	6c02                	ld	s8,0(sp)
    800016d8:	6161                	add	sp,sp,80
    800016da:	8082                	ret

00000000800016dc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016dc:	caa5                	beqz	a3,8000174c <copyin+0x70>
{
    800016de:	715d                	add	sp,sp,-80
    800016e0:	e486                	sd	ra,72(sp)
    800016e2:	e0a2                	sd	s0,64(sp)
    800016e4:	fc26                	sd	s1,56(sp)
    800016e6:	f84a                	sd	s2,48(sp)
    800016e8:	f44e                	sd	s3,40(sp)
    800016ea:	f052                	sd	s4,32(sp)
    800016ec:	ec56                	sd	s5,24(sp)
    800016ee:	e85a                	sd	s6,16(sp)
    800016f0:	e45e                	sd	s7,8(sp)
    800016f2:	e062                	sd	s8,0(sp)
    800016f4:	0880                	add	s0,sp,80
    800016f6:	8b2a                	mv	s6,a0
    800016f8:	8a2e                	mv	s4,a1
    800016fa:	8c32                	mv	s8,a2
    800016fc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016fe:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001700:	6a85                	lui	s5,0x1
    80001702:	a01d                	j	80001728 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001704:	018505b3          	add	a1,a0,s8
    80001708:	0004861b          	sext.w	a2,s1
    8000170c:	412585b3          	sub	a1,a1,s2
    80001710:	8552                	mv	a0,s4
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	648080e7          	jalr	1608(ra) # 80000d5a <memmove>

    len -= n;
    8000171a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000171e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001720:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001724:	02098263          	beqz	s3,80001748 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001728:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000172c:	85ca                	mv	a1,s2
    8000172e:	855a                	mv	a0,s6
    80001730:	00000097          	auipc	ra,0x0
    80001734:	95a080e7          	jalr	-1702(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    80001738:	cd01                	beqz	a0,80001750 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000173a:	418904b3          	sub	s1,s2,s8
    8000173e:	94d6                	add	s1,s1,s5
    80001740:	fc99f2e3          	bgeu	s3,s1,80001704 <copyin+0x28>
    80001744:	84ce                	mv	s1,s3
    80001746:	bf7d                	j	80001704 <copyin+0x28>
  }
  return 0;
    80001748:	4501                	li	a0,0
    8000174a:	a021                	j	80001752 <copyin+0x76>
    8000174c:	4501                	li	a0,0
}
    8000174e:	8082                	ret
      return -1;
    80001750:	557d                	li	a0,-1
}
    80001752:	60a6                	ld	ra,72(sp)
    80001754:	6406                	ld	s0,64(sp)
    80001756:	74e2                	ld	s1,56(sp)
    80001758:	7942                	ld	s2,48(sp)
    8000175a:	79a2                	ld	s3,40(sp)
    8000175c:	7a02                	ld	s4,32(sp)
    8000175e:	6ae2                	ld	s5,24(sp)
    80001760:	6b42                	ld	s6,16(sp)
    80001762:	6ba2                	ld	s7,8(sp)
    80001764:	6c02                	ld	s8,0(sp)
    80001766:	6161                	add	sp,sp,80
    80001768:	8082                	ret

000000008000176a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000176a:	c2dd                	beqz	a3,80001810 <copyinstr+0xa6>
{
    8000176c:	715d                	add	sp,sp,-80
    8000176e:	e486                	sd	ra,72(sp)
    80001770:	e0a2                	sd	s0,64(sp)
    80001772:	fc26                	sd	s1,56(sp)
    80001774:	f84a                	sd	s2,48(sp)
    80001776:	f44e                	sd	s3,40(sp)
    80001778:	f052                	sd	s4,32(sp)
    8000177a:	ec56                	sd	s5,24(sp)
    8000177c:	e85a                	sd	s6,16(sp)
    8000177e:	e45e                	sd	s7,8(sp)
    80001780:	0880                	add	s0,sp,80
    80001782:	8a2a                	mv	s4,a0
    80001784:	8b2e                	mv	s6,a1
    80001786:	8bb2                	mv	s7,a2
    80001788:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000178a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000178c:	6985                	lui	s3,0x1
    8000178e:	a02d                	j	800017b8 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001790:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001794:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001796:	37fd                	addw	a5,a5,-1
    80001798:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000179c:	60a6                	ld	ra,72(sp)
    8000179e:	6406                	ld	s0,64(sp)
    800017a0:	74e2                	ld	s1,56(sp)
    800017a2:	7942                	ld	s2,48(sp)
    800017a4:	79a2                	ld	s3,40(sp)
    800017a6:	7a02                	ld	s4,32(sp)
    800017a8:	6ae2                	ld	s5,24(sp)
    800017aa:	6b42                	ld	s6,16(sp)
    800017ac:	6ba2                	ld	s7,8(sp)
    800017ae:	6161                	add	sp,sp,80
    800017b0:	8082                	ret
    srcva = va0 + PGSIZE;
    800017b2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017b6:	c8a9                	beqz	s1,80001808 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017b8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017bc:	85ca                	mv	a1,s2
    800017be:	8552                	mv	a0,s4
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	8ca080e7          	jalr	-1846(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    800017c8:	c131                	beqz	a0,8000180c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017ca:	417906b3          	sub	a3,s2,s7
    800017ce:	96ce                	add	a3,a3,s3
    800017d0:	00d4f363          	bgeu	s1,a3,800017d6 <copyinstr+0x6c>
    800017d4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017d6:	955e                	add	a0,a0,s7
    800017d8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017dc:	daf9                	beqz	a3,800017b2 <copyinstr+0x48>
    800017de:	87da                	mv	a5,s6
    800017e0:	885a                	mv	a6,s6
      if(*p == '\0'){
    800017e2:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800017e6:	96da                	add	a3,a3,s6
    800017e8:	85be                	mv	a1,a5
      if(*p == '\0'){
    800017ea:	00f60733          	add	a4,a2,a5
    800017ee:	00074703          	lbu	a4,0(a4)
    800017f2:	df59                	beqz	a4,80001790 <copyinstr+0x26>
        *dst = *p;
    800017f4:	00e78023          	sb	a4,0(a5)
      dst++;
    800017f8:	0785                	add	a5,a5,1
    while(n > 0){
    800017fa:	fed797e3          	bne	a5,a3,800017e8 <copyinstr+0x7e>
    800017fe:	14fd                	add	s1,s1,-1
    80001800:	94c2                	add	s1,s1,a6
      --max;
    80001802:	8c8d                	sub	s1,s1,a1
      dst++;
    80001804:	8b3e                	mv	s6,a5
    80001806:	b775                	j	800017b2 <copyinstr+0x48>
    80001808:	4781                	li	a5,0
    8000180a:	b771                	j	80001796 <copyinstr+0x2c>
      return -1;
    8000180c:	557d                	li	a0,-1
    8000180e:	b779                	j	8000179c <copyinstr+0x32>
  int got_null = 0;
    80001810:	4781                	li	a5,0
  if(got_null){
    80001812:	37fd                	addw	a5,a5,-1
    80001814:	0007851b          	sext.w	a0,a5
}
    80001818:	8082                	ret

000000008000181a <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000181a:	1101                	add	sp,sp,-32
    8000181c:	ec06                	sd	ra,24(sp)
    8000181e:	e822                	sd	s0,16(sp)
    80001820:	e426                	sd	s1,8(sp)
    80001822:	1000                	add	s0,sp,32
    80001824:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	362080e7          	jalr	866(ra) # 80000b88 <holding>
    8000182e:	c909                	beqz	a0,80001840 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001830:	749c                	ld	a5,40(s1)
    80001832:	00978f63          	beq	a5,s1,80001850 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001836:	60e2                	ld	ra,24(sp)
    80001838:	6442                	ld	s0,16(sp)
    8000183a:	64a2                	ld	s1,8(sp)
    8000183c:	6105                	add	sp,sp,32
    8000183e:	8082                	ret
    panic("wakeup1");
    80001840:	00007517          	auipc	a0,0x7
    80001844:	98050513          	add	a0,a0,-1664 # 800081c0 <digits+0x180>
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	d00080e7          	jalr	-768(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001850:	4c98                	lw	a4,24(s1)
    80001852:	4785                	li	a5,1
    80001854:	fef711e3          	bne	a4,a5,80001836 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001858:	4789                	li	a5,2
    8000185a:	cc9c                	sw	a5,24(s1)
}
    8000185c:	bfe9                	j	80001836 <wakeup1+0x1c>

000000008000185e <procinit>:
{
    8000185e:	715d                	add	sp,sp,-80
    80001860:	e486                	sd	ra,72(sp)
    80001862:	e0a2                	sd	s0,64(sp)
    80001864:	fc26                	sd	s1,56(sp)
    80001866:	f84a                	sd	s2,48(sp)
    80001868:	f44e                	sd	s3,40(sp)
    8000186a:	f052                	sd	s4,32(sp)
    8000186c:	ec56                	sd	s5,24(sp)
    8000186e:	e85a                	sd	s6,16(sp)
    80001870:	e45e                	sd	s7,8(sp)
    80001872:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001874:	00007597          	auipc	a1,0x7
    80001878:	95458593          	add	a1,a1,-1708 # 800081c8 <digits+0x188>
    8000187c:	00010517          	auipc	a0,0x10
    80001880:	a1450513          	add	a0,a0,-1516 # 80011290 <pid_lock>
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	2ee080e7          	jalr	750(ra) # 80000b72 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	00010917          	auipc	s2,0x10
    80001890:	e1c90913          	add	s2,s2,-484 # 800116a8 <proc>
      initlock(&p->lock, "proc");
    80001894:	00007b97          	auipc	s7,0x7
    80001898:	93cb8b93          	add	s7,s7,-1732 # 800081d0 <digits+0x190>
      uint64 va = KSTACK((int) (p - proc));
    8000189c:	8b4a                	mv	s6,s2
    8000189e:	00006a97          	auipc	s5,0x6
    800018a2:	762a8a93          	add	s5,s5,1890 # 80008000 <etext>
    800018a6:	040009b7          	lui	s3,0x4000
    800018aa:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018ac:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ae:	00015a17          	auipc	s4,0x15
    800018b2:	7faa0a13          	add	s4,s4,2042 # 800170a8 <tickslock>
      initlock(&p->lock, "proc");
    800018b6:	85de                	mv	a1,s7
    800018b8:	854a                	mv	a0,s2
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	2b8080e7          	jalr	696(ra) # 80000b72 <initlock>
      char *pa = kalloc();
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	250080e7          	jalr	592(ra) # 80000b12 <kalloc>
    800018ca:	85aa                	mv	a1,a0
      if(pa == 0)
    800018cc:	c929                	beqz	a0,8000191e <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800018ce:	416904b3          	sub	s1,s2,s6
    800018d2:	848d                	sra	s1,s1,0x3
    800018d4:	000ab783          	ld	a5,0(s5)
    800018d8:	02f484b3          	mul	s1,s1,a5
    800018dc:	2485                	addw	s1,s1,1
    800018de:	00d4949b          	sllw	s1,s1,0xd
    800018e2:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018e6:	4699                	li	a3,6
    800018e8:	6605                	lui	a2,0x1
    800018ea:	8526                	mv	a0,s1
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	86e080e7          	jalr	-1938(ra) # 8000115a <kvmmap>
      p->kstack = va;
    800018f4:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018f8:	16890913          	add	s2,s2,360
    800018fc:	fb491de3          	bne	s2,s4,800018b6 <procinit+0x58>
  kvminithart();
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	766080e7          	jalr	1894(ra) # 80001066 <kvminithart>
}
    80001908:	60a6                	ld	ra,72(sp)
    8000190a:	6406                	ld	s0,64(sp)
    8000190c:	74e2                	ld	s1,56(sp)
    8000190e:	7942                	ld	s2,48(sp)
    80001910:	79a2                	ld	s3,40(sp)
    80001912:	7a02                	ld	s4,32(sp)
    80001914:	6ae2                	ld	s5,24(sp)
    80001916:	6b42                	ld	s6,16(sp)
    80001918:	6ba2                	ld	s7,8(sp)
    8000191a:	6161                	add	sp,sp,80
    8000191c:	8082                	ret
        panic("kalloc");
    8000191e:	00007517          	auipc	a0,0x7
    80001922:	8ba50513          	add	a0,a0,-1862 # 800081d8 <digits+0x198>
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	c22080e7          	jalr	-990(ra) # 80000548 <panic>

000000008000192e <cpuid>:
{
    8000192e:	1141                	add	sp,sp,-16
    80001930:	e422                	sd	s0,8(sp)
    80001932:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001934:	8512                	mv	a0,tp
}
    80001936:	2501                	sext.w	a0,a0
    80001938:	6422                	ld	s0,8(sp)
    8000193a:	0141                	add	sp,sp,16
    8000193c:	8082                	ret

000000008000193e <mycpu>:
mycpu(void) {
    8000193e:	1141                	add	sp,sp,-16
    80001940:	e422                	sd	s0,8(sp)
    80001942:	0800                	add	s0,sp,16
    80001944:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001946:	2781                	sext.w	a5,a5
    80001948:	079e                	sll	a5,a5,0x7
}
    8000194a:	00010517          	auipc	a0,0x10
    8000194e:	95e50513          	add	a0,a0,-1698 # 800112a8 <cpus>
    80001952:	953e                	add	a0,a0,a5
    80001954:	6422                	ld	s0,8(sp)
    80001956:	0141                	add	sp,sp,16
    80001958:	8082                	ret

000000008000195a <myproc>:
myproc(void) {
    8000195a:	1101                	add	sp,sp,-32
    8000195c:	ec06                	sd	ra,24(sp)
    8000195e:	e822                	sd	s0,16(sp)
    80001960:	e426                	sd	s1,8(sp)
    80001962:	1000                	add	s0,sp,32
  push_off();
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	252080e7          	jalr	594(ra) # 80000bb6 <push_off>
    8000196c:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    8000196e:	2781                	sext.w	a5,a5
    80001970:	079e                	sll	a5,a5,0x7
    80001972:	00010717          	auipc	a4,0x10
    80001976:	91e70713          	add	a4,a4,-1762 # 80011290 <pid_lock>
    8000197a:	97ba                	add	a5,a5,a4
    8000197c:	6f84                	ld	s1,24(a5)
  pop_off();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	2d8080e7          	jalr	728(ra) # 80000c56 <pop_off>
}
    80001986:	8526                	mv	a0,s1
    80001988:	60e2                	ld	ra,24(sp)
    8000198a:	6442                	ld	s0,16(sp)
    8000198c:	64a2                	ld	s1,8(sp)
    8000198e:	6105                	add	sp,sp,32
    80001990:	8082                	ret

0000000080001992 <forkret>:
{
    80001992:	1141                	add	sp,sp,-16
    80001994:	e406                	sd	ra,8(sp)
    80001996:	e022                	sd	s0,0(sp)
    80001998:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    8000199a:	00000097          	auipc	ra,0x0
    8000199e:	fc0080e7          	jalr	-64(ra) # 8000195a <myproc>
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	314080e7          	jalr	788(ra) # 80000cb6 <release>
  if (first) {
    800019aa:	00007797          	auipc	a5,0x7
    800019ae:	e567a783          	lw	a5,-426(a5) # 80008800 <first.1>
    800019b2:	eb89                	bnez	a5,800019c4 <forkret+0x32>
  usertrapret();
    800019b4:	00001097          	auipc	ra,0x1
    800019b8:	c1c080e7          	jalr	-996(ra) # 800025d0 <usertrapret>
}
    800019bc:	60a2                	ld	ra,8(sp)
    800019be:	6402                	ld	s0,0(sp)
    800019c0:	0141                	add	sp,sp,16
    800019c2:	8082                	ret
    first = 0;
    800019c4:	00007797          	auipc	a5,0x7
    800019c8:	e207ae23          	sw	zero,-452(a5) # 80008800 <first.1>
    fsinit(ROOTDEV);
    800019cc:	4505                	li	a0,1
    800019ce:	00002097          	auipc	ra,0x2
    800019d2:	944080e7          	jalr	-1724(ra) # 80003312 <fsinit>
    800019d6:	bff9                	j	800019b4 <forkret+0x22>

00000000800019d8 <allocpid>:
allocpid() {
    800019d8:	1101                	add	sp,sp,-32
    800019da:	ec06                	sd	ra,24(sp)
    800019dc:	e822                	sd	s0,16(sp)
    800019de:	e426                	sd	s1,8(sp)
    800019e0:	e04a                	sd	s2,0(sp)
    800019e2:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    800019e4:	00010917          	auipc	s2,0x10
    800019e8:	8ac90913          	add	s2,s2,-1876 # 80011290 <pid_lock>
    800019ec:	854a                	mv	a0,s2
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	214080e7          	jalr	532(ra) # 80000c02 <acquire>
  pid = nextpid;
    800019f6:	00007797          	auipc	a5,0x7
    800019fa:	e0e78793          	add	a5,a5,-498 # 80008804 <nextpid>
    800019fe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a00:	0014871b          	addw	a4,s1,1
    80001a04:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a06:	854a                	mv	a0,s2
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	2ae080e7          	jalr	686(ra) # 80000cb6 <release>
}
    80001a10:	8526                	mv	a0,s1
    80001a12:	60e2                	ld	ra,24(sp)
    80001a14:	6442                	ld	s0,16(sp)
    80001a16:	64a2                	ld	s1,8(sp)
    80001a18:	6902                	ld	s2,0(sp)
    80001a1a:	6105                	add	sp,sp,32
    80001a1c:	8082                	ret

0000000080001a1e <proc_pagetable>:
{
    80001a1e:	1101                	add	sp,sp,-32
    80001a20:	ec06                	sd	ra,24(sp)
    80001a22:	e822                	sd	s0,16(sp)
    80001a24:	e426                	sd	s1,8(sp)
    80001a26:	e04a                	sd	s2,0(sp)
    80001a28:	1000                	add	s0,sp,32
    80001a2a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a2c:	00000097          	auipc	ra,0x0
    80001a30:	8e8080e7          	jalr	-1816(ra) # 80001314 <uvmcreate>
    80001a34:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a36:	c121                	beqz	a0,80001a76 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a38:	4729                	li	a4,10
    80001a3a:	00005697          	auipc	a3,0x5
    80001a3e:	5c668693          	add	a3,a3,1478 # 80007000 <_trampoline>
    80001a42:	6605                	lui	a2,0x1
    80001a44:	040005b7          	lui	a1,0x4000
    80001a48:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a4a:	05b2                	sll	a1,a1,0xc
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	680080e7          	jalr	1664(ra) # 800010cc <mappages>
    80001a54:	02054863          	bltz	a0,80001a84 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a58:	4719                	li	a4,6
    80001a5a:	05893683          	ld	a3,88(s2)
    80001a5e:	6605                	lui	a2,0x1
    80001a60:	020005b7          	lui	a1,0x2000
    80001a64:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a66:	05b6                	sll	a1,a1,0xd
    80001a68:	8526                	mv	a0,s1
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	662080e7          	jalr	1634(ra) # 800010cc <mappages>
    80001a72:	02054163          	bltz	a0,80001a94 <proc_pagetable+0x76>
}
    80001a76:	8526                	mv	a0,s1
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	64a2                	ld	s1,8(sp)
    80001a7e:	6902                	ld	s2,0(sp)
    80001a80:	6105                	add	sp,sp,32
    80001a82:	8082                	ret
    uvmfree(pagetable, 0);
    80001a84:	4581                	li	a1,0
    80001a86:	8526                	mv	a0,s1
    80001a88:	00000097          	auipc	ra,0x0
    80001a8c:	a8a080e7          	jalr	-1398(ra) # 80001512 <uvmfree>
    return 0;
    80001a90:	4481                	li	s1,0
    80001a92:	b7d5                	j	80001a76 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a94:	4681                	li	a3,0
    80001a96:	4605                	li	a2,1
    80001a98:	040005b7          	lui	a1,0x4000
    80001a9c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a9e:	05b2                	sll	a1,a1,0xc
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	7ae080e7          	jalr	1966(ra) # 80001250 <uvmunmap>
    uvmfree(pagetable, 0);
    80001aaa:	4581                	li	a1,0
    80001aac:	8526                	mv	a0,s1
    80001aae:	00000097          	auipc	ra,0x0
    80001ab2:	a64080e7          	jalr	-1436(ra) # 80001512 <uvmfree>
    return 0;
    80001ab6:	4481                	li	s1,0
    80001ab8:	bf7d                	j	80001a76 <proc_pagetable+0x58>

0000000080001aba <proc_freepagetable>:
{
    80001aba:	1101                	add	sp,sp,-32
    80001abc:	ec06                	sd	ra,24(sp)
    80001abe:	e822                	sd	s0,16(sp)
    80001ac0:	e426                	sd	s1,8(sp)
    80001ac2:	e04a                	sd	s2,0(sp)
    80001ac4:	1000                	add	s0,sp,32
    80001ac6:	84aa                	mv	s1,a0
    80001ac8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aca:	4681                	li	a3,0
    80001acc:	4605                	li	a2,1
    80001ace:	040005b7          	lui	a1,0x4000
    80001ad2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad4:	05b2                	sll	a1,a1,0xc
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	77a080e7          	jalr	1914(ra) # 80001250 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ade:	4681                	li	a3,0
    80001ae0:	4605                	li	a2,1
    80001ae2:	020005b7          	lui	a1,0x2000
    80001ae6:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ae8:	05b6                	sll	a1,a1,0xd
    80001aea:	8526                	mv	a0,s1
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	764080e7          	jalr	1892(ra) # 80001250 <uvmunmap>
  uvmfree(pagetable, sz);
    80001af4:	85ca                	mv	a1,s2
    80001af6:	8526                	mv	a0,s1
    80001af8:	00000097          	auipc	ra,0x0
    80001afc:	a1a080e7          	jalr	-1510(ra) # 80001512 <uvmfree>
}
    80001b00:	60e2                	ld	ra,24(sp)
    80001b02:	6442                	ld	s0,16(sp)
    80001b04:	64a2                	ld	s1,8(sp)
    80001b06:	6902                	ld	s2,0(sp)
    80001b08:	6105                	add	sp,sp,32
    80001b0a:	8082                	ret

0000000080001b0c <freeproc>:
{
    80001b0c:	1101                	add	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	1000                	add	s0,sp,32
    80001b16:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b18:	6d28                	ld	a0,88(a0)
    80001b1a:	c509                	beqz	a0,80001b24 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	ef8080e7          	jalr	-264(ra) # 80000a14 <kfree>
  p->trapframe = 0;
    80001b24:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b28:	68a8                	ld	a0,80(s1)
    80001b2a:	c511                	beqz	a0,80001b36 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b2c:	64ac                	ld	a1,72(s1)
    80001b2e:	00000097          	auipc	ra,0x0
    80001b32:	f8c080e7          	jalr	-116(ra) # 80001aba <proc_freepagetable>
  p->pagetable = 0;
    80001b36:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b3a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b3e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b42:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001b46:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b4a:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001b4e:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001b52:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001b56:	0004ac23          	sw	zero,24(s1)
}
    80001b5a:	60e2                	ld	ra,24(sp)
    80001b5c:	6442                	ld	s0,16(sp)
    80001b5e:	64a2                	ld	s1,8(sp)
    80001b60:	6105                	add	sp,sp,32
    80001b62:	8082                	ret

0000000080001b64 <allocproc>:
{
    80001b64:	1101                	add	sp,sp,-32
    80001b66:	ec06                	sd	ra,24(sp)
    80001b68:	e822                	sd	s0,16(sp)
    80001b6a:	e426                	sd	s1,8(sp)
    80001b6c:	e04a                	sd	s2,0(sp)
    80001b6e:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b70:	00010497          	auipc	s1,0x10
    80001b74:	b3848493          	add	s1,s1,-1224 # 800116a8 <proc>
    80001b78:	00015917          	auipc	s2,0x15
    80001b7c:	53090913          	add	s2,s2,1328 # 800170a8 <tickslock>
    acquire(&p->lock);
    80001b80:	8526                	mv	a0,s1
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	080080e7          	jalr	128(ra) # 80000c02 <acquire>
    if(p->state == UNUSED) {
    80001b8a:	4c9c                	lw	a5,24(s1)
    80001b8c:	cf81                	beqz	a5,80001ba4 <allocproc+0x40>
      release(&p->lock);
    80001b8e:	8526                	mv	a0,s1
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	126080e7          	jalr	294(ra) # 80000cb6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b98:	16848493          	add	s1,s1,360
    80001b9c:	ff2492e3          	bne	s1,s2,80001b80 <allocproc+0x1c>
  return 0;
    80001ba0:	4481                	li	s1,0
    80001ba2:	a0b9                	j	80001bf0 <allocproc+0x8c>
  p->pid = allocpid();
    80001ba4:	00000097          	auipc	ra,0x0
    80001ba8:	e34080e7          	jalr	-460(ra) # 800019d8 <allocpid>
    80001bac:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	f64080e7          	jalr	-156(ra) # 80000b12 <kalloc>
    80001bb6:	892a                	mv	s2,a0
    80001bb8:	eca8                	sd	a0,88(s1)
    80001bba:	c131                	beqz	a0,80001bfe <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00000097          	auipc	ra,0x0
    80001bc2:	e60080e7          	jalr	-416(ra) # 80001a1e <proc_pagetable>
    80001bc6:	892a                	mv	s2,a0
    80001bc8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bca:	c129                	beqz	a0,80001c0c <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001bcc:	07000613          	li	a2,112
    80001bd0:	4581                	li	a1,0
    80001bd2:	06048513          	add	a0,s1,96
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	128080e7          	jalr	296(ra) # 80000cfe <memset>
  p->context.ra = (uint64)forkret;
    80001bde:	00000797          	auipc	a5,0x0
    80001be2:	db478793          	add	a5,a5,-588 # 80001992 <forkret>
    80001be6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001be8:	60bc                	ld	a5,64(s1)
    80001bea:	6705                	lui	a4,0x1
    80001bec:	97ba                	add	a5,a5,a4
    80001bee:	f4bc                	sd	a5,104(s1)
}
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	64a2                	ld	s1,8(sp)
    80001bf8:	6902                	ld	s2,0(sp)
    80001bfa:	6105                	add	sp,sp,32
    80001bfc:	8082                	ret
    release(&p->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	0b6080e7          	jalr	182(ra) # 80000cb6 <release>
    return 0;
    80001c08:	84ca                	mv	s1,s2
    80001c0a:	b7dd                	j	80001bf0 <allocproc+0x8c>
    freeproc(p);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	efe080e7          	jalr	-258(ra) # 80001b0c <freeproc>
    release(&p->lock);
    80001c16:	8526                	mv	a0,s1
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	09e080e7          	jalr	158(ra) # 80000cb6 <release>
    return 0;
    80001c20:	84ca                	mv	s1,s2
    80001c22:	b7f9                	j	80001bf0 <allocproc+0x8c>

0000000080001c24 <userinit>:
{
    80001c24:	1101                	add	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	add	s0,sp,32
  p = allocproc();
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	f36080e7          	jalr	-202(ra) # 80001b64 <allocproc>
    80001c36:	84aa                	mv	s1,a0
  initproc = p;
    80001c38:	00007797          	auipc	a5,0x7
    80001c3c:	3ea7b023          	sd	a0,992(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001c40:	03400613          	li	a2,52
    80001c44:	00007597          	auipc	a1,0x7
    80001c48:	bcc58593          	add	a1,a1,-1076 # 80008810 <initcode>
    80001c4c:	6928                	ld	a0,80(a0)
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	6f4080e7          	jalr	1780(ra) # 80001342 <uvminit>
  p->sz = PGSIZE;
    80001c56:	6785                	lui	a5,0x1
    80001c58:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001c5a:	6cb8                	ld	a4,88(s1)
    80001c5c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001c60:	6cb8                	ld	a4,88(s1)
    80001c62:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001c64:	4641                	li	a2,16
    80001c66:	00006597          	auipc	a1,0x6
    80001c6a:	57a58593          	add	a1,a1,1402 # 800081e0 <digits+0x1a0>
    80001c6e:	15848513          	add	a0,s1,344
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	1dc080e7          	jalr	476(ra) # 80000e4e <safestrcpy>
  p->cwd = namei("/");
    80001c7a:	00006517          	auipc	a0,0x6
    80001c7e:	57650513          	add	a0,a0,1398 # 800081f0 <digits+0x1b0>
    80001c82:	00002097          	auipc	ra,0x2
    80001c86:	0b8080e7          	jalr	184(ra) # 80003d3a <namei>
    80001c8a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c8e:	4789                	li	a5,2
    80001c90:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c92:	8526                	mv	a0,s1
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	022080e7          	jalr	34(ra) # 80000cb6 <release>
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6105                	add	sp,sp,32
    80001ca4:	8082                	ret

0000000080001ca6 <growproc>:
{
    80001ca6:	1101                	add	sp,sp,-32
    80001ca8:	ec06                	sd	ra,24(sp)
    80001caa:	e822                	sd	s0,16(sp)
    80001cac:	e426                	sd	s1,8(sp)
    80001cae:	e04a                	sd	s2,0(sp)
    80001cb0:	1000                	add	s0,sp,32
    80001cb2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001cb4:	00000097          	auipc	ra,0x0
    80001cb8:	ca6080e7          	jalr	-858(ra) # 8000195a <myproc>
    80001cbc:	892a                	mv	s2,a0
  sz = p->sz;
    80001cbe:	652c                	ld	a1,72(a0)
    80001cc0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001cc4:	00904f63          	bgtz	s1,80001ce2 <growproc+0x3c>
  } else if(n < 0){
    80001cc8:	0204cd63          	bltz	s1,80001d02 <growproc+0x5c>
  p->sz = sz;
    80001ccc:	1782                	sll	a5,a5,0x20
    80001cce:	9381                	srl	a5,a5,0x20
    80001cd0:	04f93423          	sd	a5,72(s2)
  return 0;
    80001cd4:	4501                	li	a0,0
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6902                	ld	s2,0(sp)
    80001cde:	6105                	add	sp,sp,32
    80001ce0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001ce2:	00f4863b          	addw	a2,s1,a5
    80001ce6:	1602                	sll	a2,a2,0x20
    80001ce8:	9201                	srl	a2,a2,0x20
    80001cea:	1582                	sll	a1,a1,0x20
    80001cec:	9181                	srl	a1,a1,0x20
    80001cee:	6928                	ld	a0,80(a0)
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	70c080e7          	jalr	1804(ra) # 800013fc <uvmalloc>
    80001cf8:	0005079b          	sext.w	a5,a0
    80001cfc:	fbe1                	bnez	a5,80001ccc <growproc+0x26>
      return -1;
    80001cfe:	557d                	li	a0,-1
    80001d00:	bfd9                	j	80001cd6 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d02:	00f4863b          	addw	a2,s1,a5
    80001d06:	1602                	sll	a2,a2,0x20
    80001d08:	9201                	srl	a2,a2,0x20
    80001d0a:	1582                	sll	a1,a1,0x20
    80001d0c:	9181                	srl	a1,a1,0x20
    80001d0e:	6928                	ld	a0,80(a0)
    80001d10:	fffff097          	auipc	ra,0xfffff
    80001d14:	6a4080e7          	jalr	1700(ra) # 800013b4 <uvmdealloc>
    80001d18:	0005079b          	sext.w	a5,a0
    80001d1c:	bf45                	j	80001ccc <growproc+0x26>

0000000080001d1e <fork>:
{
    80001d1e:	7139                	add	sp,sp,-64
    80001d20:	fc06                	sd	ra,56(sp)
    80001d22:	f822                	sd	s0,48(sp)
    80001d24:	f426                	sd	s1,40(sp)
    80001d26:	f04a                	sd	s2,32(sp)
    80001d28:	ec4e                	sd	s3,24(sp)
    80001d2a:	e852                	sd	s4,16(sp)
    80001d2c:	e456                	sd	s5,8(sp)
    80001d2e:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	c2a080e7          	jalr	-982(ra) # 8000195a <myproc>
    80001d38:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	e2a080e7          	jalr	-470(ra) # 80001b64 <allocproc>
    80001d42:	c17d                	beqz	a0,80001e28 <fork+0x10a>
    80001d44:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d46:	048ab603          	ld	a2,72(s5)
    80001d4a:	692c                	ld	a1,80(a0)
    80001d4c:	050ab503          	ld	a0,80(s5)
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	7fc080e7          	jalr	2044(ra) # 8000154c <uvmcopy>
    80001d58:	04054a63          	bltz	a0,80001dac <fork+0x8e>
  np->sz = p->sz;
    80001d5c:	048ab783          	ld	a5,72(s5)
    80001d60:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001d64:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001d68:	058ab683          	ld	a3,88(s5)
    80001d6c:	87b6                	mv	a5,a3
    80001d6e:	058a3703          	ld	a4,88(s4)
    80001d72:	12068693          	add	a3,a3,288
    80001d76:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001d7a:	6788                	ld	a0,8(a5)
    80001d7c:	6b8c                	ld	a1,16(a5)
    80001d7e:	6f90                	ld	a2,24(a5)
    80001d80:	01073023          	sd	a6,0(a4)
    80001d84:	e708                	sd	a0,8(a4)
    80001d86:	eb0c                	sd	a1,16(a4)
    80001d88:	ef10                	sd	a2,24(a4)
    80001d8a:	02078793          	add	a5,a5,32
    80001d8e:	02070713          	add	a4,a4,32
    80001d92:	fed792e3          	bne	a5,a3,80001d76 <fork+0x58>
  np->trapframe->a0 = 0;
    80001d96:	058a3783          	ld	a5,88(s4)
    80001d9a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d9e:	0d0a8493          	add	s1,s5,208
    80001da2:	0d0a0913          	add	s2,s4,208
    80001da6:	150a8993          	add	s3,s5,336
    80001daa:	a00d                	j	80001dcc <fork+0xae>
    freeproc(np);
    80001dac:	8552                	mv	a0,s4
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	d5e080e7          	jalr	-674(ra) # 80001b0c <freeproc>
    release(&np->lock);
    80001db6:	8552                	mv	a0,s4
    80001db8:	fffff097          	auipc	ra,0xfffff
    80001dbc:	efe080e7          	jalr	-258(ra) # 80000cb6 <release>
    return -1;
    80001dc0:	54fd                	li	s1,-1
    80001dc2:	a889                	j	80001e14 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001dc4:	04a1                	add	s1,s1,8
    80001dc6:	0921                	add	s2,s2,8
    80001dc8:	01348b63          	beq	s1,s3,80001dde <fork+0xc0>
    if(p->ofile[i])
    80001dcc:	6088                	ld	a0,0(s1)
    80001dce:	d97d                	beqz	a0,80001dc4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001dd0:	00002097          	auipc	ra,0x2
    80001dd4:	5e4080e7          	jalr	1508(ra) # 800043b4 <filedup>
    80001dd8:	00a93023          	sd	a0,0(s2)
    80001ddc:	b7e5                	j	80001dc4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001dde:	150ab503          	ld	a0,336(s5)
    80001de2:	00001097          	auipc	ra,0x1
    80001de6:	766080e7          	jalr	1894(ra) # 80003548 <idup>
    80001dea:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001dee:	4641                	li	a2,16
    80001df0:	158a8593          	add	a1,s5,344
    80001df4:	158a0513          	add	a0,s4,344
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	056080e7          	jalr	86(ra) # 80000e4e <safestrcpy>
  pid = np->pid;
    80001e00:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e04:	4789                	li	a5,2
    80001e06:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e0a:	8552                	mv	a0,s4
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	eaa080e7          	jalr	-342(ra) # 80000cb6 <release>
}
    80001e14:	8526                	mv	a0,s1
    80001e16:	70e2                	ld	ra,56(sp)
    80001e18:	7442                	ld	s0,48(sp)
    80001e1a:	74a2                	ld	s1,40(sp)
    80001e1c:	7902                	ld	s2,32(sp)
    80001e1e:	69e2                	ld	s3,24(sp)
    80001e20:	6a42                	ld	s4,16(sp)
    80001e22:	6aa2                	ld	s5,8(sp)
    80001e24:	6121                	add	sp,sp,64
    80001e26:	8082                	ret
    return -1;
    80001e28:	54fd                	li	s1,-1
    80001e2a:	b7ed                	j	80001e14 <fork+0xf6>

0000000080001e2c <reparent>:
{
    80001e2c:	7179                	add	sp,sp,-48
    80001e2e:	f406                	sd	ra,40(sp)
    80001e30:	f022                	sd	s0,32(sp)
    80001e32:	ec26                	sd	s1,24(sp)
    80001e34:	e84a                	sd	s2,16(sp)
    80001e36:	e44e                	sd	s3,8(sp)
    80001e38:	e052                	sd	s4,0(sp)
    80001e3a:	1800                	add	s0,sp,48
    80001e3c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e3e:	00010497          	auipc	s1,0x10
    80001e42:	86a48493          	add	s1,s1,-1942 # 800116a8 <proc>
      pp->parent = initproc;
    80001e46:	00007a17          	auipc	s4,0x7
    80001e4a:	1d2a0a13          	add	s4,s4,466 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e4e:	00015997          	auipc	s3,0x15
    80001e52:	25a98993          	add	s3,s3,602 # 800170a8 <tickslock>
    80001e56:	a029                	j	80001e60 <reparent+0x34>
    80001e58:	16848493          	add	s1,s1,360
    80001e5c:	03348363          	beq	s1,s3,80001e82 <reparent+0x56>
    if(pp->parent == p){
    80001e60:	709c                	ld	a5,32(s1)
    80001e62:	ff279be3          	bne	a5,s2,80001e58 <reparent+0x2c>
      acquire(&pp->lock);
    80001e66:	8526                	mv	a0,s1
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	d9a080e7          	jalr	-614(ra) # 80000c02 <acquire>
      pp->parent = initproc;
    80001e70:	000a3783          	ld	a5,0(s4)
    80001e74:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001e76:	8526                	mv	a0,s1
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	e3e080e7          	jalr	-450(ra) # 80000cb6 <release>
    80001e80:	bfe1                	j	80001e58 <reparent+0x2c>
}
    80001e82:	70a2                	ld	ra,40(sp)
    80001e84:	7402                	ld	s0,32(sp)
    80001e86:	64e2                	ld	s1,24(sp)
    80001e88:	6942                	ld	s2,16(sp)
    80001e8a:	69a2                	ld	s3,8(sp)
    80001e8c:	6a02                	ld	s4,0(sp)
    80001e8e:	6145                	add	sp,sp,48
    80001e90:	8082                	ret

0000000080001e92 <scheduler>:
{
    80001e92:	715d                	add	sp,sp,-80
    80001e94:	e486                	sd	ra,72(sp)
    80001e96:	e0a2                	sd	s0,64(sp)
    80001e98:	fc26                	sd	s1,56(sp)
    80001e9a:	f84a                	sd	s2,48(sp)
    80001e9c:	f44e                	sd	s3,40(sp)
    80001e9e:	f052                	sd	s4,32(sp)
    80001ea0:	ec56                	sd	s5,24(sp)
    80001ea2:	e85a                	sd	s6,16(sp)
    80001ea4:	e45e                	sd	s7,8(sp)
    80001ea6:	e062                	sd	s8,0(sp)
    80001ea8:	0880                	add	s0,sp,80
    80001eaa:	8792                	mv	a5,tp
  int id = r_tp();
    80001eac:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eae:	00779b93          	sll	s7,a5,0x7
    80001eb2:	0000f717          	auipc	a4,0xf
    80001eb6:	3de70713          	add	a4,a4,990 # 80011290 <pid_lock>
    80001eba:	975e                	add	a4,a4,s7
    80001ebc:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001ec0:	0000f717          	auipc	a4,0xf
    80001ec4:	3f070713          	add	a4,a4,1008 # 800112b0 <cpus+0x8>
    80001ec8:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001eca:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    80001ecc:	4a09                	li	s4,2
        c->proc = p;
    80001ece:	079e                	sll	a5,a5,0x7
    80001ed0:	0000fa97          	auipc	s5,0xf
    80001ed4:	3c0a8a93          	add	s5,s5,960 # 80011290 <pid_lock>
    80001ed8:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eda:	00015997          	auipc	s3,0x15
    80001ede:	1ce98993          	add	s3,s3,462 # 800170a8 <tickslock>
    80001ee2:	a8a1                	j	80001f3a <scheduler+0xa8>
      release(&p->lock);
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	dd0080e7          	jalr	-560(ra) # 80000cb6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001eee:	16848493          	add	s1,s1,360
    80001ef2:	03348a63          	beq	s1,s3,80001f26 <scheduler+0x94>
      acquire(&p->lock);
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	d0a080e7          	jalr	-758(ra) # 80000c02 <acquire>
      if(p->state != UNUSED) {
    80001f00:	4c9c                	lw	a5,24(s1)
    80001f02:	d3ed                	beqz	a5,80001ee4 <scheduler+0x52>
        nproc++;
    80001f04:	2905                	addw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001f06:	fd479fe3          	bne	a5,s4,80001ee4 <scheduler+0x52>
        p->state = RUNNING;
    80001f0a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f0e:	009abc23          	sd	s1,24(s5)
        swtch(&c->context, &p->context);
    80001f12:	06048593          	add	a1,s1,96
    80001f16:	855e                	mv	a0,s7
    80001f18:	00000097          	auipc	ra,0x0
    80001f1c:	60e080e7          	jalr	1550(ra) # 80002526 <swtch>
        c->proc = 0;
    80001f20:	000abc23          	sd	zero,24(s5)
    80001f24:	b7c1                	j	80001ee4 <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    80001f26:	012a4a63          	blt	s4,s2,80001f3a <scheduler+0xa8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f2e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f32:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f36:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f3e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f42:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001f46:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f48:	0000f497          	auipc	s1,0xf
    80001f4c:	76048493          	add	s1,s1,1888 # 800116a8 <proc>
        p->state = RUNNING;
    80001f50:	4b0d                	li	s6,3
    80001f52:	b755                	j	80001ef6 <scheduler+0x64>

0000000080001f54 <sched>:
{
    80001f54:	7179                	add	sp,sp,-48
    80001f56:	f406                	sd	ra,40(sp)
    80001f58:	f022                	sd	s0,32(sp)
    80001f5a:	ec26                	sd	s1,24(sp)
    80001f5c:	e84a                	sd	s2,16(sp)
    80001f5e:	e44e                	sd	s3,8(sp)
    80001f60:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001f62:	00000097          	auipc	ra,0x0
    80001f66:	9f8080e7          	jalr	-1544(ra) # 8000195a <myproc>
    80001f6a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	c1c080e7          	jalr	-996(ra) # 80000b88 <holding>
    80001f74:	c93d                	beqz	a0,80001fea <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f76:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f78:	2781                	sext.w	a5,a5
    80001f7a:	079e                	sll	a5,a5,0x7
    80001f7c:	0000f717          	auipc	a4,0xf
    80001f80:	31470713          	add	a4,a4,788 # 80011290 <pid_lock>
    80001f84:	97ba                	add	a5,a5,a4
    80001f86:	0907a703          	lw	a4,144(a5)
    80001f8a:	4785                	li	a5,1
    80001f8c:	06f71763          	bne	a4,a5,80001ffa <sched+0xa6>
  if(p->state == RUNNING)
    80001f90:	4c98                	lw	a4,24(s1)
    80001f92:	478d                	li	a5,3
    80001f94:	06f70b63          	beq	a4,a5,8000200a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f9c:	8b89                	and	a5,a5,2
  if(intr_get())
    80001f9e:	efb5                	bnez	a5,8000201a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fa0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fa2:	0000f917          	auipc	s2,0xf
    80001fa6:	2ee90913          	add	s2,s2,750 # 80011290 <pid_lock>
    80001faa:	2781                	sext.w	a5,a5
    80001fac:	079e                	sll	a5,a5,0x7
    80001fae:	97ca                	add	a5,a5,s2
    80001fb0:	0947a983          	lw	s3,148(a5)
    80001fb4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fb6:	2781                	sext.w	a5,a5
    80001fb8:	079e                	sll	a5,a5,0x7
    80001fba:	0000f597          	auipc	a1,0xf
    80001fbe:	2f658593          	add	a1,a1,758 # 800112b0 <cpus+0x8>
    80001fc2:	95be                	add	a1,a1,a5
    80001fc4:	06048513          	add	a0,s1,96
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	55e080e7          	jalr	1374(ra) # 80002526 <swtch>
    80001fd0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fd2:	2781                	sext.w	a5,a5
    80001fd4:	079e                	sll	a5,a5,0x7
    80001fd6:	993e                	add	s2,s2,a5
    80001fd8:	09392a23          	sw	s3,148(s2)
}
    80001fdc:	70a2                	ld	ra,40(sp)
    80001fde:	7402                	ld	s0,32(sp)
    80001fe0:	64e2                	ld	s1,24(sp)
    80001fe2:	6942                	ld	s2,16(sp)
    80001fe4:	69a2                	ld	s3,8(sp)
    80001fe6:	6145                	add	sp,sp,48
    80001fe8:	8082                	ret
    panic("sched p->lock");
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	20e50513          	add	a0,a0,526 # 800081f8 <digits+0x1b8>
    80001ff2:	ffffe097          	auipc	ra,0xffffe
    80001ff6:	556080e7          	jalr	1366(ra) # 80000548 <panic>
    panic("sched locks");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	20e50513          	add	a0,a0,526 # 80008208 <digits+0x1c8>
    80002002:	ffffe097          	auipc	ra,0xffffe
    80002006:	546080e7          	jalr	1350(ra) # 80000548 <panic>
    panic("sched running");
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	20e50513          	add	a0,a0,526 # 80008218 <digits+0x1d8>
    80002012:	ffffe097          	auipc	ra,0xffffe
    80002016:	536080e7          	jalr	1334(ra) # 80000548 <panic>
    panic("sched interruptible");
    8000201a:	00006517          	auipc	a0,0x6
    8000201e:	20e50513          	add	a0,a0,526 # 80008228 <digits+0x1e8>
    80002022:	ffffe097          	auipc	ra,0xffffe
    80002026:	526080e7          	jalr	1318(ra) # 80000548 <panic>

000000008000202a <exit>:
{
    8000202a:	7179                	add	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	e44e                	sd	s3,8(sp)
    80002036:	e052                	sd	s4,0(sp)
    80002038:	1800                	add	s0,sp,48
    8000203a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000203c:	00000097          	auipc	ra,0x0
    80002040:	91e080e7          	jalr	-1762(ra) # 8000195a <myproc>
    80002044:	89aa                	mv	s3,a0
  if(p == initproc)
    80002046:	00007797          	auipc	a5,0x7
    8000204a:	fd27b783          	ld	a5,-46(a5) # 80009018 <initproc>
    8000204e:	0d050493          	add	s1,a0,208
    80002052:	15050913          	add	s2,a0,336
    80002056:	02a79363          	bne	a5,a0,8000207c <exit+0x52>
    panic("init exiting");
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	1e650513          	add	a0,a0,486 # 80008240 <digits+0x200>
    80002062:	ffffe097          	auipc	ra,0xffffe
    80002066:	4e6080e7          	jalr	1254(ra) # 80000548 <panic>
      fileclose(f);
    8000206a:	00002097          	auipc	ra,0x2
    8000206e:	39c080e7          	jalr	924(ra) # 80004406 <fileclose>
      p->ofile[fd] = 0;
    80002072:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002076:	04a1                	add	s1,s1,8
    80002078:	01248563          	beq	s1,s2,80002082 <exit+0x58>
    if(p->ofile[fd]){
    8000207c:	6088                	ld	a0,0(s1)
    8000207e:	f575                	bnez	a0,8000206a <exit+0x40>
    80002080:	bfdd                	j	80002076 <exit+0x4c>
  begin_op();
    80002082:	00002097          	auipc	ra,0x2
    80002086:	eb8080e7          	jalr	-328(ra) # 80003f3a <begin_op>
  iput(p->cwd);
    8000208a:	1509b503          	ld	a0,336(s3)
    8000208e:	00001097          	auipc	ra,0x1
    80002092:	6b2080e7          	jalr	1714(ra) # 80003740 <iput>
  end_op();
    80002096:	00002097          	auipc	ra,0x2
    8000209a:	f1e080e7          	jalr	-226(ra) # 80003fb4 <end_op>
  p->cwd = 0;
    8000209e:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800020a2:	00007497          	auipc	s1,0x7
    800020a6:	f7648493          	add	s1,s1,-138 # 80009018 <initproc>
    800020aa:	6088                	ld	a0,0(s1)
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	b56080e7          	jalr	-1194(ra) # 80000c02 <acquire>
  wakeup1(initproc);
    800020b4:	6088                	ld	a0,0(s1)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	764080e7          	jalr	1892(ra) # 8000181a <wakeup1>
  release(&initproc->lock);
    800020be:	6088                	ld	a0,0(s1)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	bf6080e7          	jalr	-1034(ra) # 80000cb6 <release>
  acquire(&p->lock);
    800020c8:	854e                	mv	a0,s3
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	b38080e7          	jalr	-1224(ra) # 80000c02 <acquire>
  struct proc *original_parent = p->parent;
    800020d2:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800020d6:	854e                	mv	a0,s3
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	bde080e7          	jalr	-1058(ra) # 80000cb6 <release>
  acquire(&original_parent->lock);
    800020e0:	8526                	mv	a0,s1
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	b20080e7          	jalr	-1248(ra) # 80000c02 <acquire>
  acquire(&p->lock);
    800020ea:	854e                	mv	a0,s3
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	b16080e7          	jalr	-1258(ra) # 80000c02 <acquire>
  reparent(p);
    800020f4:	854e                	mv	a0,s3
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	d36080e7          	jalr	-714(ra) # 80001e2c <reparent>
  wakeup1(original_parent);
    800020fe:	8526                	mv	a0,s1
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	71a080e7          	jalr	1818(ra) # 8000181a <wakeup1>
  p->xstate = status;
    80002108:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000210c:	4791                	li	a5,4
    8000210e:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	ba2080e7          	jalr	-1118(ra) # 80000cb6 <release>
  sched();
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	e38080e7          	jalr	-456(ra) # 80001f54 <sched>
  panic("zombie exit");
    80002124:	00006517          	auipc	a0,0x6
    80002128:	12c50513          	add	a0,a0,300 # 80008250 <digits+0x210>
    8000212c:	ffffe097          	auipc	ra,0xffffe
    80002130:	41c080e7          	jalr	1052(ra) # 80000548 <panic>

0000000080002134 <yield>:
{
    80002134:	1101                	add	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	81c080e7          	jalr	-2020(ra) # 8000195a <myproc>
    80002146:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	aba080e7          	jalr	-1350(ra) # 80000c02 <acquire>
  p->state = RUNNABLE;
    80002150:	4789                	li	a5,2
    80002152:	cc9c                	sw	a5,24(s1)
  sched();
    80002154:	00000097          	auipc	ra,0x0
    80002158:	e00080e7          	jalr	-512(ra) # 80001f54 <sched>
  release(&p->lock);
    8000215c:	8526                	mv	a0,s1
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	b58080e7          	jalr	-1192(ra) # 80000cb6 <release>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	add	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <sleep>:
{
    80002170:	7179                	add	sp,sp,-48
    80002172:	f406                	sd	ra,40(sp)
    80002174:	f022                	sd	s0,32(sp)
    80002176:	ec26                	sd	s1,24(sp)
    80002178:	e84a                	sd	s2,16(sp)
    8000217a:	e44e                	sd	s3,8(sp)
    8000217c:	1800                	add	s0,sp,48
    8000217e:	89aa                	mv	s3,a0
    80002180:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	7d8080e7          	jalr	2008(ra) # 8000195a <myproc>
    8000218a:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000218c:	05250663          	beq	a0,s2,800021d8 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	a72080e7          	jalr	-1422(ra) # 80000c02 <acquire>
    release(lk);
    80002198:	854a                	mv	a0,s2
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	b1c080e7          	jalr	-1252(ra) # 80000cb6 <release>
  p->chan = chan;
    800021a2:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800021a6:	4785                	li	a5,1
    800021a8:	cc9c                	sw	a5,24(s1)
  sched();
    800021aa:	00000097          	auipc	ra,0x0
    800021ae:	daa080e7          	jalr	-598(ra) # 80001f54 <sched>
  p->chan = 0;
    800021b2:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800021b6:	8526                	mv	a0,s1
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	afe080e7          	jalr	-1282(ra) # 80000cb6 <release>
    acquire(lk);
    800021c0:	854a                	mv	a0,s2
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	a40080e7          	jalr	-1472(ra) # 80000c02 <acquire>
}
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6942                	ld	s2,16(sp)
    800021d2:	69a2                	ld	s3,8(sp)
    800021d4:	6145                	add	sp,sp,48
    800021d6:	8082                	ret
  p->chan = chan;
    800021d8:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800021dc:	4785                	li	a5,1
    800021de:	cd1c                	sw	a5,24(a0)
  sched();
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	d74080e7          	jalr	-652(ra) # 80001f54 <sched>
  p->chan = 0;
    800021e8:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800021ec:	bff9                	j	800021ca <sleep+0x5a>

00000000800021ee <wait>:
{
    800021ee:	715d                	add	sp,sp,-80
    800021f0:	e486                	sd	ra,72(sp)
    800021f2:	e0a2                	sd	s0,64(sp)
    800021f4:	fc26                	sd	s1,56(sp)
    800021f6:	f84a                	sd	s2,48(sp)
    800021f8:	f44e                	sd	s3,40(sp)
    800021fa:	f052                	sd	s4,32(sp)
    800021fc:	ec56                	sd	s5,24(sp)
    800021fe:	e85a                	sd	s6,16(sp)
    80002200:	e45e                	sd	s7,8(sp)
    80002202:	0880                	add	s0,sp,80
    80002204:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	754080e7          	jalr	1876(ra) # 8000195a <myproc>
    8000220e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	9f2080e7          	jalr	-1550(ra) # 80000c02 <acquire>
    havekids = 0;
    80002218:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000221a:	4a11                	li	s4,4
        havekids = 1;
    8000221c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000221e:	00015997          	auipc	s3,0x15
    80002222:	e8a98993          	add	s3,s3,-374 # 800170a8 <tickslock>
    80002226:	a845                	j	800022d6 <wait+0xe8>
          pid = np->pid;
    80002228:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000222c:	000b0e63          	beqz	s6,80002248 <wait+0x5a>
    80002230:	4691                	li	a3,4
    80002232:	03448613          	add	a2,s1,52
    80002236:	85da                	mv	a1,s6
    80002238:	05093503          	ld	a0,80(s2)
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	414080e7          	jalr	1044(ra) # 80001650 <copyout>
    80002244:	02054d63          	bltz	a0,8000227e <wait+0x90>
          freeproc(np);
    80002248:	8526                	mv	a0,s1
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	8c2080e7          	jalr	-1854(ra) # 80001b0c <freeproc>
          release(&np->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	a62080e7          	jalr	-1438(ra) # 80000cb6 <release>
          release(&p->lock);
    8000225c:	854a                	mv	a0,s2
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	a58080e7          	jalr	-1448(ra) # 80000cb6 <release>
}
    80002266:	854e                	mv	a0,s3
    80002268:	60a6                	ld	ra,72(sp)
    8000226a:	6406                	ld	s0,64(sp)
    8000226c:	74e2                	ld	s1,56(sp)
    8000226e:	7942                	ld	s2,48(sp)
    80002270:	79a2                	ld	s3,40(sp)
    80002272:	7a02                	ld	s4,32(sp)
    80002274:	6ae2                	ld	s5,24(sp)
    80002276:	6b42                	ld	s6,16(sp)
    80002278:	6ba2                	ld	s7,8(sp)
    8000227a:	6161                	add	sp,sp,80
    8000227c:	8082                	ret
            release(&np->lock);
    8000227e:	8526                	mv	a0,s1
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	a36080e7          	jalr	-1482(ra) # 80000cb6 <release>
            release(&p->lock);
    80002288:	854a                	mv	a0,s2
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	a2c080e7          	jalr	-1492(ra) # 80000cb6 <release>
            return -1;
    80002292:	59fd                	li	s3,-1
    80002294:	bfc9                	j	80002266 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    80002296:	16848493          	add	s1,s1,360
    8000229a:	03348463          	beq	s1,s3,800022c2 <wait+0xd4>
      if(np->parent == p){
    8000229e:	709c                	ld	a5,32(s1)
    800022a0:	ff279be3          	bne	a5,s2,80002296 <wait+0xa8>
        acquire(&np->lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	95c080e7          	jalr	-1700(ra) # 80000c02 <acquire>
        if(np->state == ZOMBIE){
    800022ae:	4c9c                	lw	a5,24(s1)
    800022b0:	f7478ce3          	beq	a5,s4,80002228 <wait+0x3a>
        release(&np->lock);
    800022b4:	8526                	mv	a0,s1
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	a00080e7          	jalr	-1536(ra) # 80000cb6 <release>
        havekids = 1;
    800022be:	8756                	mv	a4,s5
    800022c0:	bfd9                	j	80002296 <wait+0xa8>
    if(!havekids || p->killed){
    800022c2:	c305                	beqz	a4,800022e2 <wait+0xf4>
    800022c4:	03092783          	lw	a5,48(s2)
    800022c8:	ef89                	bnez	a5,800022e2 <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    800022ca:	85ca                	mv	a1,s2
    800022cc:	854a                	mv	a0,s2
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	ea2080e7          	jalr	-350(ra) # 80002170 <sleep>
    havekids = 0;
    800022d6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800022d8:	0000f497          	auipc	s1,0xf
    800022dc:	3d048493          	add	s1,s1,976 # 800116a8 <proc>
    800022e0:	bf7d                	j	8000229e <wait+0xb0>
      release(&p->lock);
    800022e2:	854a                	mv	a0,s2
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	9d2080e7          	jalr	-1582(ra) # 80000cb6 <release>
      return -1;
    800022ec:	59fd                	li	s3,-1
    800022ee:	bfa5                	j	80002266 <wait+0x78>

00000000800022f0 <wakeup>:
{
    800022f0:	7139                	add	sp,sp,-64
    800022f2:	fc06                	sd	ra,56(sp)
    800022f4:	f822                	sd	s0,48(sp)
    800022f6:	f426                	sd	s1,40(sp)
    800022f8:	f04a                	sd	s2,32(sp)
    800022fa:	ec4e                	sd	s3,24(sp)
    800022fc:	e852                	sd	s4,16(sp)
    800022fe:	e456                	sd	s5,8(sp)
    80002300:	0080                	add	s0,sp,64
    80002302:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002304:	0000f497          	auipc	s1,0xf
    80002308:	3a448493          	add	s1,s1,932 # 800116a8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000230c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000230e:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002310:	00015917          	auipc	s2,0x15
    80002314:	d9890913          	add	s2,s2,-616 # 800170a8 <tickslock>
    80002318:	a811                	j	8000232c <wakeup+0x3c>
    release(&p->lock);
    8000231a:	8526                	mv	a0,s1
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	99a080e7          	jalr	-1638(ra) # 80000cb6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002324:	16848493          	add	s1,s1,360
    80002328:	03248063          	beq	s1,s2,80002348 <wakeup+0x58>
    acquire(&p->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	8d4080e7          	jalr	-1836(ra) # 80000c02 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002336:	4c9c                	lw	a5,24(s1)
    80002338:	ff3791e3          	bne	a5,s3,8000231a <wakeup+0x2a>
    8000233c:	749c                	ld	a5,40(s1)
    8000233e:	fd479ee3          	bne	a5,s4,8000231a <wakeup+0x2a>
      p->state = RUNNABLE;
    80002342:	0154ac23          	sw	s5,24(s1)
    80002346:	bfd1                	j	8000231a <wakeup+0x2a>
}
    80002348:	70e2                	ld	ra,56(sp)
    8000234a:	7442                	ld	s0,48(sp)
    8000234c:	74a2                	ld	s1,40(sp)
    8000234e:	7902                	ld	s2,32(sp)
    80002350:	69e2                	ld	s3,24(sp)
    80002352:	6a42                	ld	s4,16(sp)
    80002354:	6aa2                	ld	s5,8(sp)
    80002356:	6121                	add	sp,sp,64
    80002358:	8082                	ret

000000008000235a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000235a:	7179                	add	sp,sp,-48
    8000235c:	f406                	sd	ra,40(sp)
    8000235e:	f022                	sd	s0,32(sp)
    80002360:	ec26                	sd	s1,24(sp)
    80002362:	e84a                	sd	s2,16(sp)
    80002364:	e44e                	sd	s3,8(sp)
    80002366:	1800                	add	s0,sp,48
    80002368:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000236a:	0000f497          	auipc	s1,0xf
    8000236e:	33e48493          	add	s1,s1,830 # 800116a8 <proc>
    80002372:	00015997          	auipc	s3,0x15
    80002376:	d3698993          	add	s3,s3,-714 # 800170a8 <tickslock>
    acquire(&p->lock);
    8000237a:	8526                	mv	a0,s1
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	886080e7          	jalr	-1914(ra) # 80000c02 <acquire>
    if(p->pid == pid){
    80002384:	5c9c                	lw	a5,56(s1)
    80002386:	01278d63          	beq	a5,s2,800023a0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000238a:	8526                	mv	a0,s1
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	92a080e7          	jalr	-1750(ra) # 80000cb6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002394:	16848493          	add	s1,s1,360
    80002398:	ff3491e3          	bne	s1,s3,8000237a <kill+0x20>
  }
  return -1;
    8000239c:	557d                	li	a0,-1
    8000239e:	a821                	j	800023b6 <kill+0x5c>
      p->killed = 1;
    800023a0:	4785                	li	a5,1
    800023a2:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800023a4:	4c98                	lw	a4,24(s1)
    800023a6:	00f70f63          	beq	a4,a5,800023c4 <kill+0x6a>
      release(&p->lock);
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	90a080e7          	jalr	-1782(ra) # 80000cb6 <release>
      return 0;
    800023b4:	4501                	li	a0,0
}
    800023b6:	70a2                	ld	ra,40(sp)
    800023b8:	7402                	ld	s0,32(sp)
    800023ba:	64e2                	ld	s1,24(sp)
    800023bc:	6942                	ld	s2,16(sp)
    800023be:	69a2                	ld	s3,8(sp)
    800023c0:	6145                	add	sp,sp,48
    800023c2:	8082                	ret
        p->state = RUNNABLE;
    800023c4:	4789                	li	a5,2
    800023c6:	cc9c                	sw	a5,24(s1)
    800023c8:	b7cd                	j	800023aa <kill+0x50>

00000000800023ca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023ca:	7179                	add	sp,sp,-48
    800023cc:	f406                	sd	ra,40(sp)
    800023ce:	f022                	sd	s0,32(sp)
    800023d0:	ec26                	sd	s1,24(sp)
    800023d2:	e84a                	sd	s2,16(sp)
    800023d4:	e44e                	sd	s3,8(sp)
    800023d6:	e052                	sd	s4,0(sp)
    800023d8:	1800                	add	s0,sp,48
    800023da:	84aa                	mv	s1,a0
    800023dc:	892e                	mv	s2,a1
    800023de:	89b2                	mv	s3,a2
    800023e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	578080e7          	jalr	1400(ra) # 8000195a <myproc>
  if(user_dst){
    800023ea:	c08d                	beqz	s1,8000240c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800023ec:	86d2                	mv	a3,s4
    800023ee:	864e                	mv	a2,s3
    800023f0:	85ca                	mv	a1,s2
    800023f2:	6928                	ld	a0,80(a0)
    800023f4:	fffff097          	auipc	ra,0xfffff
    800023f8:	25c080e7          	jalr	604(ra) # 80001650 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023fc:	70a2                	ld	ra,40(sp)
    800023fe:	7402                	ld	s0,32(sp)
    80002400:	64e2                	ld	s1,24(sp)
    80002402:	6942                	ld	s2,16(sp)
    80002404:	69a2                	ld	s3,8(sp)
    80002406:	6a02                	ld	s4,0(sp)
    80002408:	6145                	add	sp,sp,48
    8000240a:	8082                	ret
    memmove((char *)dst, src, len);
    8000240c:	000a061b          	sext.w	a2,s4
    80002410:	85ce                	mv	a1,s3
    80002412:	854a                	mv	a0,s2
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	946080e7          	jalr	-1722(ra) # 80000d5a <memmove>
    return 0;
    8000241c:	8526                	mv	a0,s1
    8000241e:	bff9                	j	800023fc <either_copyout+0x32>

0000000080002420 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002420:	7179                	add	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	e052                	sd	s4,0(sp)
    8000242e:	1800                	add	s0,sp,48
    80002430:	892a                	mv	s2,a0
    80002432:	84ae                	mv	s1,a1
    80002434:	89b2                	mv	s3,a2
    80002436:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	522080e7          	jalr	1314(ra) # 8000195a <myproc>
  if(user_src){
    80002440:	c08d                	beqz	s1,80002462 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002442:	86d2                	mv	a3,s4
    80002444:	864e                	mv	a2,s3
    80002446:	85ca                	mv	a1,s2
    80002448:	6928                	ld	a0,80(a0)
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	292080e7          	jalr	658(ra) # 800016dc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002452:	70a2                	ld	ra,40(sp)
    80002454:	7402                	ld	s0,32(sp)
    80002456:	64e2                	ld	s1,24(sp)
    80002458:	6942                	ld	s2,16(sp)
    8000245a:	69a2                	ld	s3,8(sp)
    8000245c:	6a02                	ld	s4,0(sp)
    8000245e:	6145                	add	sp,sp,48
    80002460:	8082                	ret
    memmove(dst, (char*)src, len);
    80002462:	000a061b          	sext.w	a2,s4
    80002466:	85ce                	mv	a1,s3
    80002468:	854a                	mv	a0,s2
    8000246a:	fffff097          	auipc	ra,0xfffff
    8000246e:	8f0080e7          	jalr	-1808(ra) # 80000d5a <memmove>
    return 0;
    80002472:	8526                	mv	a0,s1
    80002474:	bff9                	j	80002452 <either_copyin+0x32>

0000000080002476 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002476:	715d                	add	sp,sp,-80
    80002478:	e486                	sd	ra,72(sp)
    8000247a:	e0a2                	sd	s0,64(sp)
    8000247c:	fc26                	sd	s1,56(sp)
    8000247e:	f84a                	sd	s2,48(sp)
    80002480:	f44e                	sd	s3,40(sp)
    80002482:	f052                	sd	s4,32(sp)
    80002484:	ec56                	sd	s5,24(sp)
    80002486:	e85a                	sd	s6,16(sp)
    80002488:	e45e                	sd	s7,8(sp)
    8000248a:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000248c:	00006517          	auipc	a0,0x6
    80002490:	c3c50513          	add	a0,a0,-964 # 800080c8 <digits+0x88>
    80002494:	ffffe097          	auipc	ra,0xffffe
    80002498:	0fe080e7          	jalr	254(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000249c:	0000f497          	auipc	s1,0xf
    800024a0:	36448493          	add	s1,s1,868 # 80011800 <proc+0x158>
    800024a4:	00015917          	auipc	s2,0x15
    800024a8:	d5c90913          	add	s2,s2,-676 # 80017200 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024ac:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800024ae:	00006997          	auipc	s3,0x6
    800024b2:	db298993          	add	s3,s3,-590 # 80008260 <digits+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    800024b6:	00006a97          	auipc	s5,0x6
    800024ba:	db2a8a93          	add	s5,s5,-590 # 80008268 <digits+0x228>
    printf("\n");
    800024be:	00006a17          	auipc	s4,0x6
    800024c2:	c0aa0a13          	add	s4,s4,-1014 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024c6:	00006b97          	auipc	s7,0x6
    800024ca:	ddab8b93          	add	s7,s7,-550 # 800082a0 <states.0>
    800024ce:	a00d                	j	800024f0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800024d0:	ee06a583          	lw	a1,-288(a3)
    800024d4:	8556                	mv	a0,s5
    800024d6:	ffffe097          	auipc	ra,0xffffe
    800024da:	0bc080e7          	jalr	188(ra) # 80000592 <printf>
    printf("\n");
    800024de:	8552                	mv	a0,s4
    800024e0:	ffffe097          	auipc	ra,0xffffe
    800024e4:	0b2080e7          	jalr	178(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024e8:	16848493          	add	s1,s1,360
    800024ec:	03248263          	beq	s1,s2,80002510 <procdump+0x9a>
    if(p->state == UNUSED)
    800024f0:	86a6                	mv	a3,s1
    800024f2:	ec04a783          	lw	a5,-320(s1)
    800024f6:	dbed                	beqz	a5,800024e8 <procdump+0x72>
      state = "???";
    800024f8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024fa:	fcfb6be3          	bltu	s6,a5,800024d0 <procdump+0x5a>
    800024fe:	02079713          	sll	a4,a5,0x20
    80002502:	01d75793          	srl	a5,a4,0x1d
    80002506:	97de                	add	a5,a5,s7
    80002508:	6390                	ld	a2,0(a5)
    8000250a:	f279                	bnez	a2,800024d0 <procdump+0x5a>
      state = "???";
    8000250c:	864e                	mv	a2,s3
    8000250e:	b7c9                	j	800024d0 <procdump+0x5a>
  }
}
    80002510:	60a6                	ld	ra,72(sp)
    80002512:	6406                	ld	s0,64(sp)
    80002514:	74e2                	ld	s1,56(sp)
    80002516:	7942                	ld	s2,48(sp)
    80002518:	79a2                	ld	s3,40(sp)
    8000251a:	7a02                	ld	s4,32(sp)
    8000251c:	6ae2                	ld	s5,24(sp)
    8000251e:	6b42                	ld	s6,16(sp)
    80002520:	6ba2                	ld	s7,8(sp)
    80002522:	6161                	add	sp,sp,80
    80002524:	8082                	ret

0000000080002526 <swtch>:
    80002526:	00153023          	sd	ra,0(a0)
    8000252a:	00253423          	sd	sp,8(a0)
    8000252e:	e900                	sd	s0,16(a0)
    80002530:	ed04                	sd	s1,24(a0)
    80002532:	03253023          	sd	s2,32(a0)
    80002536:	03353423          	sd	s3,40(a0)
    8000253a:	03453823          	sd	s4,48(a0)
    8000253e:	03553c23          	sd	s5,56(a0)
    80002542:	05653023          	sd	s6,64(a0)
    80002546:	05753423          	sd	s7,72(a0)
    8000254a:	05853823          	sd	s8,80(a0)
    8000254e:	05953c23          	sd	s9,88(a0)
    80002552:	07a53023          	sd	s10,96(a0)
    80002556:	07b53423          	sd	s11,104(a0)
    8000255a:	0005b083          	ld	ra,0(a1)
    8000255e:	0085b103          	ld	sp,8(a1)
    80002562:	6980                	ld	s0,16(a1)
    80002564:	6d84                	ld	s1,24(a1)
    80002566:	0205b903          	ld	s2,32(a1)
    8000256a:	0285b983          	ld	s3,40(a1)
    8000256e:	0305ba03          	ld	s4,48(a1)
    80002572:	0385ba83          	ld	s5,56(a1)
    80002576:	0405bb03          	ld	s6,64(a1)
    8000257a:	0485bb83          	ld	s7,72(a1)
    8000257e:	0505bc03          	ld	s8,80(a1)
    80002582:	0585bc83          	ld	s9,88(a1)
    80002586:	0605bd03          	ld	s10,96(a1)
    8000258a:	0685bd83          	ld	s11,104(a1)
    8000258e:	8082                	ret

0000000080002590 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002590:	1141                	add	sp,sp,-16
    80002592:	e406                	sd	ra,8(sp)
    80002594:	e022                	sd	s0,0(sp)
    80002596:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002598:	00006597          	auipc	a1,0x6
    8000259c:	d3058593          	add	a1,a1,-720 # 800082c8 <states.0+0x28>
    800025a0:	00015517          	auipc	a0,0x15
    800025a4:	b0850513          	add	a0,a0,-1272 # 800170a8 <tickslock>
    800025a8:	ffffe097          	auipc	ra,0xffffe
    800025ac:	5ca080e7          	jalr	1482(ra) # 80000b72 <initlock>
}
    800025b0:	60a2                	ld	ra,8(sp)
    800025b2:	6402                	ld	s0,0(sp)
    800025b4:	0141                	add	sp,sp,16
    800025b6:	8082                	ret

00000000800025b8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025b8:	1141                	add	sp,sp,-16
    800025ba:	e422                	sd	s0,8(sp)
    800025bc:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025be:	00003797          	auipc	a5,0x3
    800025c2:	48278793          	add	a5,a5,1154 # 80005a40 <kernelvec>
    800025c6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025ca:	6422                	ld	s0,8(sp)
    800025cc:	0141                	add	sp,sp,16
    800025ce:	8082                	ret

00000000800025d0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800025d0:	1141                	add	sp,sp,-16
    800025d2:	e406                	sd	ra,8(sp)
    800025d4:	e022                	sd	s0,0(sp)
    800025d6:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800025d8:	fffff097          	auipc	ra,0xfffff
    800025dc:	382080e7          	jalr	898(ra) # 8000195a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025e0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025e4:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025e6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800025ea:	00005697          	auipc	a3,0x5
    800025ee:	a1668693          	add	a3,a3,-1514 # 80007000 <_trampoline>
    800025f2:	00005717          	auipc	a4,0x5
    800025f6:	a0e70713          	add	a4,a4,-1522 # 80007000 <_trampoline>
    800025fa:	8f15                	sub	a4,a4,a3
    800025fc:	040007b7          	lui	a5,0x4000
    80002600:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002602:	07b2                	sll	a5,a5,0xc
    80002604:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002606:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000260a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000260c:	18002673          	csrr	a2,satp
    80002610:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002612:	6d30                	ld	a2,88(a0)
    80002614:	6138                	ld	a4,64(a0)
    80002616:	6585                	lui	a1,0x1
    80002618:	972e                	add	a4,a4,a1
    8000261a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000261c:	6d38                	ld	a4,88(a0)
    8000261e:	00000617          	auipc	a2,0x0
    80002622:	13c60613          	add	a2,a2,316 # 8000275a <usertrap>
    80002626:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002628:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000262a:	8612                	mv	a2,tp
    8000262c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002632:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002636:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000263a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000263e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002640:	6f18                	ld	a4,24(a4)
    80002642:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002646:	692c                	ld	a1,80(a0)
    80002648:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000264a:	00005717          	auipc	a4,0x5
    8000264e:	a4670713          	add	a4,a4,-1466 # 80007090 <userret>
    80002652:	8f15                	sub	a4,a4,a3
    80002654:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002656:	577d                	li	a4,-1
    80002658:	177e                	sll	a4,a4,0x3f
    8000265a:	8dd9                	or	a1,a1,a4
    8000265c:	02000537          	lui	a0,0x2000
    80002660:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80002662:	0536                	sll	a0,a0,0xd
    80002664:	9782                	jalr	a5
}
    80002666:	60a2                	ld	ra,8(sp)
    80002668:	6402                	ld	s0,0(sp)
    8000266a:	0141                	add	sp,sp,16
    8000266c:	8082                	ret

000000008000266e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000266e:	1101                	add	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80002678:	00015497          	auipc	s1,0x15
    8000267c:	a3048493          	add	s1,s1,-1488 # 800170a8 <tickslock>
    80002680:	8526                	mv	a0,s1
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	580080e7          	jalr	1408(ra) # 80000c02 <acquire>
  ticks++;
    8000268a:	00007517          	auipc	a0,0x7
    8000268e:	99650513          	add	a0,a0,-1642 # 80009020 <ticks>
    80002692:	411c                	lw	a5,0(a0)
    80002694:	2785                	addw	a5,a5,1
    80002696:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	c58080e7          	jalr	-936(ra) # 800022f0 <wakeup>
  release(&tickslock);
    800026a0:	8526                	mv	a0,s1
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	614080e7          	jalr	1556(ra) # 80000cb6 <release>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6105                	add	sp,sp,32
    800026b2:	8082                	ret

00000000800026b4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026b4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800026b8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800026ba:	0807df63          	bgez	a5,80002758 <devintr+0xa4>
{
    800026be:	1101                	add	sp,sp,-32
    800026c0:	ec06                	sd	ra,24(sp)
    800026c2:	e822                	sd	s0,16(sp)
    800026c4:	e426                	sd	s1,8(sp)
    800026c6:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    800026c8:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800026cc:	46a5                	li	a3,9
    800026ce:	00d70d63          	beq	a4,a3,800026e8 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    800026d2:	577d                	li	a4,-1
    800026d4:	177e                	sll	a4,a4,0x3f
    800026d6:	0705                	add	a4,a4,1
    return 0;
    800026d8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800026da:	04e78e63          	beq	a5,a4,80002736 <devintr+0x82>
  }
}
    800026de:	60e2                	ld	ra,24(sp)
    800026e0:	6442                	ld	s0,16(sp)
    800026e2:	64a2                	ld	s1,8(sp)
    800026e4:	6105                	add	sp,sp,32
    800026e6:	8082                	ret
    int irq = plic_claim();
    800026e8:	00003097          	auipc	ra,0x3
    800026ec:	460080e7          	jalr	1120(ra) # 80005b48 <plic_claim>
    800026f0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026f2:	47a9                	li	a5,10
    800026f4:	02f50763          	beq	a0,a5,80002722 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    800026f8:	4785                	li	a5,1
    800026fa:	02f50963          	beq	a0,a5,8000272c <devintr+0x78>
    return 1;
    800026fe:	4505                	li	a0,1
    } else if(irq){
    80002700:	dcf9                	beqz	s1,800026de <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80002702:	85a6                	mv	a1,s1
    80002704:	00006517          	auipc	a0,0x6
    80002708:	bcc50513          	add	a0,a0,-1076 # 800082d0 <states.0+0x30>
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	e86080e7          	jalr	-378(ra) # 80000592 <printf>
      plic_complete(irq);
    80002714:	8526                	mv	a0,s1
    80002716:	00003097          	auipc	ra,0x3
    8000271a:	456080e7          	jalr	1110(ra) # 80005b6c <plic_complete>
    return 1;
    8000271e:	4505                	li	a0,1
    80002720:	bf7d                	j	800026de <devintr+0x2a>
      uartintr();
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	2a2080e7          	jalr	674(ra) # 800009c4 <uartintr>
    if(irq)
    8000272a:	b7ed                	j	80002714 <devintr+0x60>
      virtio_disk_intr();
    8000272c:	00004097          	auipc	ra,0x4
    80002730:	8ca080e7          	jalr	-1846(ra) # 80005ff6 <virtio_disk_intr>
    if(irq)
    80002734:	b7c5                	j	80002714 <devintr+0x60>
    if(cpuid() == 0){
    80002736:	fffff097          	auipc	ra,0xfffff
    8000273a:	1f8080e7          	jalr	504(ra) # 8000192e <cpuid>
    8000273e:	c901                	beqz	a0,8000274e <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002740:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002744:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002746:	14479073          	csrw	sip,a5
    return 2;
    8000274a:	4509                	li	a0,2
    8000274c:	bf49                	j	800026de <devintr+0x2a>
      clockintr();
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	f20080e7          	jalr	-224(ra) # 8000266e <clockintr>
    80002756:	b7ed                	j	80002740 <devintr+0x8c>
}
    80002758:	8082                	ret

000000008000275a <usertrap>:
{
    8000275a:	1101                	add	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	e04a                	sd	s2,0(sp)
    80002764:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002766:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000276a:	1007f793          	and	a5,a5,256
    8000276e:	e3ad                	bnez	a5,800027d0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002770:	00003797          	auipc	a5,0x3
    80002774:	2d078793          	add	a5,a5,720 # 80005a40 <kernelvec>
    80002778:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000277c:	fffff097          	auipc	ra,0xfffff
    80002780:	1de080e7          	jalr	478(ra) # 8000195a <myproc>
    80002784:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002786:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002788:	14102773          	csrr	a4,sepc
    8000278c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000278e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002792:	47a1                	li	a5,8
    80002794:	04f71c63          	bne	a4,a5,800027ec <usertrap+0x92>
    if(p->killed)
    80002798:	591c                	lw	a5,48(a0)
    8000279a:	e3b9                	bnez	a5,800027e0 <usertrap+0x86>
    p->trapframe->epc += 4;
    8000279c:	6cb8                	ld	a4,88(s1)
    8000279e:	6f1c                	ld	a5,24(a4)
    800027a0:	0791                	add	a5,a5,4
    800027a2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027a8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ac:	10079073          	csrw	sstatus,a5
    syscall();
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	2e0080e7          	jalr	736(ra) # 80002a90 <syscall>
  if(p->killed)
    800027b8:	589c                	lw	a5,48(s1)
    800027ba:	ebc1                	bnez	a5,8000284a <usertrap+0xf0>
  usertrapret();
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	e14080e7          	jalr	-492(ra) # 800025d0 <usertrapret>
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6902                	ld	s2,0(sp)
    800027cc:	6105                	add	sp,sp,32
    800027ce:	8082                	ret
    panic("usertrap: not from user mode");
    800027d0:	00006517          	auipc	a0,0x6
    800027d4:	b2050513          	add	a0,a0,-1248 # 800082f0 <states.0+0x50>
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	d70080e7          	jalr	-656(ra) # 80000548 <panic>
      exit(-1);
    800027e0:	557d                	li	a0,-1
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	848080e7          	jalr	-1976(ra) # 8000202a <exit>
    800027ea:	bf4d                	j	8000279c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	ec8080e7          	jalr	-312(ra) # 800026b4 <devintr>
    800027f4:	892a                	mv	s2,a0
    800027f6:	c501                	beqz	a0,800027fe <usertrap+0xa4>
  if(p->killed)
    800027f8:	589c                	lw	a5,48(s1)
    800027fa:	c3a1                	beqz	a5,8000283a <usertrap+0xe0>
    800027fc:	a815                	j	80002830 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027fe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002802:	5c90                	lw	a2,56(s1)
    80002804:	00006517          	auipc	a0,0x6
    80002808:	b0c50513          	add	a0,a0,-1268 # 80008310 <states.0+0x70>
    8000280c:	ffffe097          	auipc	ra,0xffffe
    80002810:	d86080e7          	jalr	-634(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002814:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002818:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000281c:	00006517          	auipc	a0,0x6
    80002820:	b2450513          	add	a0,a0,-1244 # 80008340 <states.0+0xa0>
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	d6e080e7          	jalr	-658(ra) # 80000592 <printf>
    p->killed = 1;
    8000282c:	4785                	li	a5,1
    8000282e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002830:	557d                	li	a0,-1
    80002832:	fffff097          	auipc	ra,0xfffff
    80002836:	7f8080e7          	jalr	2040(ra) # 8000202a <exit>
  if(which_dev == 2)
    8000283a:	4789                	li	a5,2
    8000283c:	f8f910e3          	bne	s2,a5,800027bc <usertrap+0x62>
    yield();
    80002840:	00000097          	auipc	ra,0x0
    80002844:	8f4080e7          	jalr	-1804(ra) # 80002134 <yield>
    80002848:	bf95                	j	800027bc <usertrap+0x62>
  int which_dev = 0;
    8000284a:	4901                	li	s2,0
    8000284c:	b7d5                	j	80002830 <usertrap+0xd6>

000000008000284e <kerneltrap>:
{
    8000284e:	7179                	add	sp,sp,-48
    80002850:	f406                	sd	ra,40(sp)
    80002852:	f022                	sd	s0,32(sp)
    80002854:	ec26                	sd	s1,24(sp)
    80002856:	e84a                	sd	s2,16(sp)
    80002858:	e44e                	sd	s3,8(sp)
    8000285a:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000285c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002860:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002864:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002868:	1004f793          	and	a5,s1,256
    8000286c:	cb85                	beqz	a5,8000289c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000286e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002872:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002874:	ef85                	bnez	a5,800028ac <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e3e080e7          	jalr	-450(ra) # 800026b4 <devintr>
    8000287e:	cd1d                	beqz	a0,800028bc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002880:	4789                	li	a5,2
    80002882:	06f50a63          	beq	a0,a5,800028f6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002886:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000288a:	10049073          	csrw	sstatus,s1
}
    8000288e:	70a2                	ld	ra,40(sp)
    80002890:	7402                	ld	s0,32(sp)
    80002892:	64e2                	ld	s1,24(sp)
    80002894:	6942                	ld	s2,16(sp)
    80002896:	69a2                	ld	s3,8(sp)
    80002898:	6145                	add	sp,sp,48
    8000289a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	ac450513          	add	a0,a0,-1340 # 80008360 <states.0+0xc0>
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	ca4080e7          	jalr	-860(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    800028ac:	00006517          	auipc	a0,0x6
    800028b0:	adc50513          	add	a0,a0,-1316 # 80008388 <states.0+0xe8>
    800028b4:	ffffe097          	auipc	ra,0xffffe
    800028b8:	c94080e7          	jalr	-876(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    800028bc:	85ce                	mv	a1,s3
    800028be:	00006517          	auipc	a0,0x6
    800028c2:	aea50513          	add	a0,a0,-1302 # 800083a8 <states.0+0x108>
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	ccc080e7          	jalr	-820(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028ce:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028d2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	ae250513          	add	a0,a0,-1310 # 800083b8 <states.0+0x118>
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	cb4080e7          	jalr	-844(ra) # 80000592 <printf>
    panic("kerneltrap");
    800028e6:	00006517          	auipc	a0,0x6
    800028ea:	aea50513          	add	a0,a0,-1302 # 800083d0 <states.0+0x130>
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	c5a080e7          	jalr	-934(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028f6:	fffff097          	auipc	ra,0xfffff
    800028fa:	064080e7          	jalr	100(ra) # 8000195a <myproc>
    800028fe:	d541                	beqz	a0,80002886 <kerneltrap+0x38>
    80002900:	fffff097          	auipc	ra,0xfffff
    80002904:	05a080e7          	jalr	90(ra) # 8000195a <myproc>
    80002908:	4d18                	lw	a4,24(a0)
    8000290a:	478d                	li	a5,3
    8000290c:	f6f71de3          	bne	a4,a5,80002886 <kerneltrap+0x38>
    yield();
    80002910:	00000097          	auipc	ra,0x0
    80002914:	824080e7          	jalr	-2012(ra) # 80002134 <yield>
    80002918:	b7bd                	j	80002886 <kerneltrap+0x38>

000000008000291a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000291a:	1101                	add	sp,sp,-32
    8000291c:	ec06                	sd	ra,24(sp)
    8000291e:	e822                	sd	s0,16(sp)
    80002920:	e426                	sd	s1,8(sp)
    80002922:	1000                	add	s0,sp,32
    80002924:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002926:	fffff097          	auipc	ra,0xfffff
    8000292a:	034080e7          	jalr	52(ra) # 8000195a <myproc>
  switch (n) {
    8000292e:	4795                	li	a5,5
    80002930:	0497e163          	bltu	a5,s1,80002972 <argraw+0x58>
    80002934:	048a                	sll	s1,s1,0x2
    80002936:	00006717          	auipc	a4,0x6
    8000293a:	ad270713          	add	a4,a4,-1326 # 80008408 <states.0+0x168>
    8000293e:	94ba                	add	s1,s1,a4
    80002940:	409c                	lw	a5,0(s1)
    80002942:	97ba                	add	a5,a5,a4
    80002944:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002946:	6d3c                	ld	a5,88(a0)
    80002948:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000294a:	60e2                	ld	ra,24(sp)
    8000294c:	6442                	ld	s0,16(sp)
    8000294e:	64a2                	ld	s1,8(sp)
    80002950:	6105                	add	sp,sp,32
    80002952:	8082                	ret
    return p->trapframe->a1;
    80002954:	6d3c                	ld	a5,88(a0)
    80002956:	7fa8                	ld	a0,120(a5)
    80002958:	bfcd                	j	8000294a <argraw+0x30>
    return p->trapframe->a2;
    8000295a:	6d3c                	ld	a5,88(a0)
    8000295c:	63c8                	ld	a0,128(a5)
    8000295e:	b7f5                	j	8000294a <argraw+0x30>
    return p->trapframe->a3;
    80002960:	6d3c                	ld	a5,88(a0)
    80002962:	67c8                	ld	a0,136(a5)
    80002964:	b7dd                	j	8000294a <argraw+0x30>
    return p->trapframe->a4;
    80002966:	6d3c                	ld	a5,88(a0)
    80002968:	6bc8                	ld	a0,144(a5)
    8000296a:	b7c5                	j	8000294a <argraw+0x30>
    return p->trapframe->a5;
    8000296c:	6d3c                	ld	a5,88(a0)
    8000296e:	6fc8                	ld	a0,152(a5)
    80002970:	bfe9                	j	8000294a <argraw+0x30>
  panic("argraw");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	a6e50513          	add	a0,a0,-1426 # 800083e0 <states.0+0x140>
    8000297a:	ffffe097          	auipc	ra,0xffffe
    8000297e:	bce080e7          	jalr	-1074(ra) # 80000548 <panic>

0000000080002982 <fetchaddr>:
{
    80002982:	1101                	add	sp,sp,-32
    80002984:	ec06                	sd	ra,24(sp)
    80002986:	e822                	sd	s0,16(sp)
    80002988:	e426                	sd	s1,8(sp)
    8000298a:	e04a                	sd	s2,0(sp)
    8000298c:	1000                	add	s0,sp,32
    8000298e:	84aa                	mv	s1,a0
    80002990:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002992:	fffff097          	auipc	ra,0xfffff
    80002996:	fc8080e7          	jalr	-56(ra) # 8000195a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000299a:	653c                	ld	a5,72(a0)
    8000299c:	02f4f863          	bgeu	s1,a5,800029cc <fetchaddr+0x4a>
    800029a0:	00848713          	add	a4,s1,8
    800029a4:	02e7e663          	bltu	a5,a4,800029d0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029a8:	46a1                	li	a3,8
    800029aa:	8626                	mv	a2,s1
    800029ac:	85ca                	mv	a1,s2
    800029ae:	6928                	ld	a0,80(a0)
    800029b0:	fffff097          	auipc	ra,0xfffff
    800029b4:	d2c080e7          	jalr	-724(ra) # 800016dc <copyin>
    800029b8:	00a03533          	snez	a0,a0
    800029bc:	40a00533          	neg	a0,a0
}
    800029c0:	60e2                	ld	ra,24(sp)
    800029c2:	6442                	ld	s0,16(sp)
    800029c4:	64a2                	ld	s1,8(sp)
    800029c6:	6902                	ld	s2,0(sp)
    800029c8:	6105                	add	sp,sp,32
    800029ca:	8082                	ret
    return -1;
    800029cc:	557d                	li	a0,-1
    800029ce:	bfcd                	j	800029c0 <fetchaddr+0x3e>
    800029d0:	557d                	li	a0,-1
    800029d2:	b7fd                	j	800029c0 <fetchaddr+0x3e>

00000000800029d4 <fetchstr>:
{
    800029d4:	7179                	add	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	1800                	add	s0,sp,48
    800029e2:	892a                	mv	s2,a0
    800029e4:	84ae                	mv	s1,a1
    800029e6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800029e8:	fffff097          	auipc	ra,0xfffff
    800029ec:	f72080e7          	jalr	-142(ra) # 8000195a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800029f0:	86ce                	mv	a3,s3
    800029f2:	864a                	mv	a2,s2
    800029f4:	85a6                	mv	a1,s1
    800029f6:	6928                	ld	a0,80(a0)
    800029f8:	fffff097          	auipc	ra,0xfffff
    800029fc:	d72080e7          	jalr	-654(ra) # 8000176a <copyinstr>
  if(err < 0)
    80002a00:	00054763          	bltz	a0,80002a0e <fetchstr+0x3a>
  return strlen(buf);
    80002a04:	8526                	mv	a0,s1
    80002a06:	ffffe097          	auipc	ra,0xffffe
    80002a0a:	47a080e7          	jalr	1146(ra) # 80000e80 <strlen>
}
    80002a0e:	70a2                	ld	ra,40(sp)
    80002a10:	7402                	ld	s0,32(sp)
    80002a12:	64e2                	ld	s1,24(sp)
    80002a14:	6942                	ld	s2,16(sp)
    80002a16:	69a2                	ld	s3,8(sp)
    80002a18:	6145                	add	sp,sp,48
    80002a1a:	8082                	ret

0000000080002a1c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a1c:	1101                	add	sp,sp,-32
    80002a1e:	ec06                	sd	ra,24(sp)
    80002a20:	e822                	sd	s0,16(sp)
    80002a22:	e426                	sd	s1,8(sp)
    80002a24:	1000                	add	s0,sp,32
    80002a26:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	ef2080e7          	jalr	-270(ra) # 8000291a <argraw>
    80002a30:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a32:	4501                	li	a0,0
    80002a34:	60e2                	ld	ra,24(sp)
    80002a36:	6442                	ld	s0,16(sp)
    80002a38:	64a2                	ld	s1,8(sp)
    80002a3a:	6105                	add	sp,sp,32
    80002a3c:	8082                	ret

0000000080002a3e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002a3e:	1101                	add	sp,sp,-32
    80002a40:	ec06                	sd	ra,24(sp)
    80002a42:	e822                	sd	s0,16(sp)
    80002a44:	e426                	sd	s1,8(sp)
    80002a46:	1000                	add	s0,sp,32
    80002a48:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	ed0080e7          	jalr	-304(ra) # 8000291a <argraw>
    80002a52:	e088                	sd	a0,0(s1)
  return 0;
}
    80002a54:	4501                	li	a0,0
    80002a56:	60e2                	ld	ra,24(sp)
    80002a58:	6442                	ld	s0,16(sp)
    80002a5a:	64a2                	ld	s1,8(sp)
    80002a5c:	6105                	add	sp,sp,32
    80002a5e:	8082                	ret

0000000080002a60 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a60:	1101                	add	sp,sp,-32
    80002a62:	ec06                	sd	ra,24(sp)
    80002a64:	e822                	sd	s0,16(sp)
    80002a66:	e426                	sd	s1,8(sp)
    80002a68:	e04a                	sd	s2,0(sp)
    80002a6a:	1000                	add	s0,sp,32
    80002a6c:	84ae                	mv	s1,a1
    80002a6e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	eaa080e7          	jalr	-342(ra) # 8000291a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002a78:	864a                	mv	a2,s2
    80002a7a:	85a6                	mv	a1,s1
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	f58080e7          	jalr	-168(ra) # 800029d4 <fetchstr>
}
    80002a84:	60e2                	ld	ra,24(sp)
    80002a86:	6442                	ld	s0,16(sp)
    80002a88:	64a2                	ld	s1,8(sp)
    80002a8a:	6902                	ld	s2,0(sp)
    80002a8c:	6105                	add	sp,sp,32
    80002a8e:	8082                	ret

0000000080002a90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002a90:	1101                	add	sp,sp,-32
    80002a92:	ec06                	sd	ra,24(sp)
    80002a94:	e822                	sd	s0,16(sp)
    80002a96:	e426                	sd	s1,8(sp)
    80002a98:	e04a                	sd	s2,0(sp)
    80002a9a:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a9c:	fffff097          	auipc	ra,0xfffff
    80002aa0:	ebe080e7          	jalr	-322(ra) # 8000195a <myproc>
    80002aa4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002aa6:	05853903          	ld	s2,88(a0)
    80002aaa:	0a893783          	ld	a5,168(s2)
    80002aae:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ab2:	37fd                	addw	a5,a5,-1
    80002ab4:	4751                	li	a4,20
    80002ab6:	00f76f63          	bltu	a4,a5,80002ad4 <syscall+0x44>
    80002aba:	00369713          	sll	a4,a3,0x3
    80002abe:	00006797          	auipc	a5,0x6
    80002ac2:	96278793          	add	a5,a5,-1694 # 80008420 <syscalls>
    80002ac6:	97ba                	add	a5,a5,a4
    80002ac8:	639c                	ld	a5,0(a5)
    80002aca:	c789                	beqz	a5,80002ad4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002acc:	9782                	jalr	a5
    80002ace:	06a93823          	sd	a0,112(s2)
    80002ad2:	a839                	j	80002af0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ad4:	15848613          	add	a2,s1,344
    80002ad8:	5c8c                	lw	a1,56(s1)
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	90e50513          	add	a0,a0,-1778 # 800083e8 <states.0+0x148>
    80002ae2:	ffffe097          	auipc	ra,0xffffe
    80002ae6:	ab0080e7          	jalr	-1360(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002aea:	6cbc                	ld	a5,88(s1)
    80002aec:	577d                	li	a4,-1
    80002aee:	fbb8                	sd	a4,112(a5)
  }
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6902                	ld	s2,0(sp)
    80002af8:	6105                	add	sp,sp,32
    80002afa:	8082                	ret

0000000080002afc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002afc:	1101                	add	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b04:	fec40593          	add	a1,s0,-20
    80002b08:	4501                	li	a0,0
    80002b0a:	00000097          	auipc	ra,0x0
    80002b0e:	f12080e7          	jalr	-238(ra) # 80002a1c <argint>
    return -1;
    80002b12:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b14:	00054963          	bltz	a0,80002b26 <sys_exit+0x2a>
  exit(n);
    80002b18:	fec42503          	lw	a0,-20(s0)
    80002b1c:	fffff097          	auipc	ra,0xfffff
    80002b20:	50e080e7          	jalr	1294(ra) # 8000202a <exit>
  return 0;  // not reached
    80002b24:	4781                	li	a5,0
}
    80002b26:	853e                	mv	a0,a5
    80002b28:	60e2                	ld	ra,24(sp)
    80002b2a:	6442                	ld	s0,16(sp)
    80002b2c:	6105                	add	sp,sp,32
    80002b2e:	8082                	ret

0000000080002b30 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b30:	1141                	add	sp,sp,-16
    80002b32:	e406                	sd	ra,8(sp)
    80002b34:	e022                	sd	s0,0(sp)
    80002b36:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002b38:	fffff097          	auipc	ra,0xfffff
    80002b3c:	e22080e7          	jalr	-478(ra) # 8000195a <myproc>
}
    80002b40:	5d08                	lw	a0,56(a0)
    80002b42:	60a2                	ld	ra,8(sp)
    80002b44:	6402                	ld	s0,0(sp)
    80002b46:	0141                	add	sp,sp,16
    80002b48:	8082                	ret

0000000080002b4a <sys_fork>:

uint64
sys_fork(void)
{
    80002b4a:	1141                	add	sp,sp,-16
    80002b4c:	e406                	sd	ra,8(sp)
    80002b4e:	e022                	sd	s0,0(sp)
    80002b50:	0800                	add	s0,sp,16
  return fork();
    80002b52:	fffff097          	auipc	ra,0xfffff
    80002b56:	1cc080e7          	jalr	460(ra) # 80001d1e <fork>
}
    80002b5a:	60a2                	ld	ra,8(sp)
    80002b5c:	6402                	ld	s0,0(sp)
    80002b5e:	0141                	add	sp,sp,16
    80002b60:	8082                	ret

0000000080002b62 <sys_wait>:

uint64
sys_wait(void)
{
    80002b62:	1101                	add	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002b6a:	fe840593          	add	a1,s0,-24
    80002b6e:	4501                	li	a0,0
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	ece080e7          	jalr	-306(ra) # 80002a3e <argaddr>
    80002b78:	87aa                	mv	a5,a0
    return -1;
    80002b7a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002b7c:	0007c863          	bltz	a5,80002b8c <sys_wait+0x2a>
  return wait(p);
    80002b80:	fe843503          	ld	a0,-24(s0)
    80002b84:	fffff097          	auipc	ra,0xfffff
    80002b88:	66a080e7          	jalr	1642(ra) # 800021ee <wait>
}
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	6105                	add	sp,sp,32
    80002b92:	8082                	ret

0000000080002b94 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b94:	7179                	add	sp,sp,-48
    80002b96:	f406                	sd	ra,40(sp)
    80002b98:	f022                	sd	s0,32(sp)
    80002b9a:	ec26                	sd	s1,24(sp)
    80002b9c:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002b9e:	fdc40593          	add	a1,s0,-36
    80002ba2:	4501                	li	a0,0
    80002ba4:	00000097          	auipc	ra,0x0
    80002ba8:	e78080e7          	jalr	-392(ra) # 80002a1c <argint>
    80002bac:	87aa                	mv	a5,a0
    return -1;
    80002bae:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002bb0:	0207c063          	bltz	a5,80002bd0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	da6080e7          	jalr	-602(ra) # 8000195a <myproc>
    80002bbc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002bbe:	fdc42503          	lw	a0,-36(s0)
    80002bc2:	fffff097          	auipc	ra,0xfffff
    80002bc6:	0e4080e7          	jalr	228(ra) # 80001ca6 <growproc>
    80002bca:	00054863          	bltz	a0,80002bda <sys_sbrk+0x46>
    return -1;
  return addr;
    80002bce:	8526                	mv	a0,s1
}
    80002bd0:	70a2                	ld	ra,40(sp)
    80002bd2:	7402                	ld	s0,32(sp)
    80002bd4:	64e2                	ld	s1,24(sp)
    80002bd6:	6145                	add	sp,sp,48
    80002bd8:	8082                	ret
    return -1;
    80002bda:	557d                	li	a0,-1
    80002bdc:	bfd5                	j	80002bd0 <sys_sbrk+0x3c>

0000000080002bde <sys_sleep>:

uint64
sys_sleep(void)
{
    80002bde:	7139                	add	sp,sp,-64
    80002be0:	fc06                	sd	ra,56(sp)
    80002be2:	f822                	sd	s0,48(sp)
    80002be4:	f426                	sd	s1,40(sp)
    80002be6:	f04a                	sd	s2,32(sp)
    80002be8:	ec4e                	sd	s3,24(sp)
    80002bea:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002bec:	fcc40593          	add	a1,s0,-52
    80002bf0:	4501                	li	a0,0
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	e2a080e7          	jalr	-470(ra) # 80002a1c <argint>
    return -1;
    80002bfa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002bfc:	06054563          	bltz	a0,80002c66 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c00:	00014517          	auipc	a0,0x14
    80002c04:	4a850513          	add	a0,a0,1192 # 800170a8 <tickslock>
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	ffa080e7          	jalr	-6(ra) # 80000c02 <acquire>
  ticks0 = ticks;
    80002c10:	00006917          	auipc	s2,0x6
    80002c14:	41092903          	lw	s2,1040(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c18:	fcc42783          	lw	a5,-52(s0)
    80002c1c:	cf85                	beqz	a5,80002c54 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c1e:	00014997          	auipc	s3,0x14
    80002c22:	48a98993          	add	s3,s3,1162 # 800170a8 <tickslock>
    80002c26:	00006497          	auipc	s1,0x6
    80002c2a:	3fa48493          	add	s1,s1,1018 # 80009020 <ticks>
    if(myproc()->killed){
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	d2c080e7          	jalr	-724(ra) # 8000195a <myproc>
    80002c36:	591c                	lw	a5,48(a0)
    80002c38:	ef9d                	bnez	a5,80002c76 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002c3a:	85ce                	mv	a1,s3
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	fffff097          	auipc	ra,0xfffff
    80002c42:	532080e7          	jalr	1330(ra) # 80002170 <sleep>
  while(ticks - ticks0 < n){
    80002c46:	409c                	lw	a5,0(s1)
    80002c48:	412787bb          	subw	a5,a5,s2
    80002c4c:	fcc42703          	lw	a4,-52(s0)
    80002c50:	fce7efe3          	bltu	a5,a4,80002c2e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002c54:	00014517          	auipc	a0,0x14
    80002c58:	45450513          	add	a0,a0,1108 # 800170a8 <tickslock>
    80002c5c:	ffffe097          	auipc	ra,0xffffe
    80002c60:	05a080e7          	jalr	90(ra) # 80000cb6 <release>
  return 0;
    80002c64:	4781                	li	a5,0
}
    80002c66:	853e                	mv	a0,a5
    80002c68:	70e2                	ld	ra,56(sp)
    80002c6a:	7442                	ld	s0,48(sp)
    80002c6c:	74a2                	ld	s1,40(sp)
    80002c6e:	7902                	ld	s2,32(sp)
    80002c70:	69e2                	ld	s3,24(sp)
    80002c72:	6121                	add	sp,sp,64
    80002c74:	8082                	ret
      release(&tickslock);
    80002c76:	00014517          	auipc	a0,0x14
    80002c7a:	43250513          	add	a0,a0,1074 # 800170a8 <tickslock>
    80002c7e:	ffffe097          	auipc	ra,0xffffe
    80002c82:	038080e7          	jalr	56(ra) # 80000cb6 <release>
      return -1;
    80002c86:	57fd                	li	a5,-1
    80002c88:	bff9                	j	80002c66 <sys_sleep+0x88>

0000000080002c8a <sys_kill>:

uint64
sys_kill(void)
{
    80002c8a:	1101                	add	sp,sp,-32
    80002c8c:	ec06                	sd	ra,24(sp)
    80002c8e:	e822                	sd	s0,16(sp)
    80002c90:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002c92:	fec40593          	add	a1,s0,-20
    80002c96:	4501                	li	a0,0
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	d84080e7          	jalr	-636(ra) # 80002a1c <argint>
    80002ca0:	87aa                	mv	a5,a0
    return -1;
    80002ca2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ca4:	0007c863          	bltz	a5,80002cb4 <sys_kill+0x2a>
  return kill(pid);
    80002ca8:	fec42503          	lw	a0,-20(s0)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	6ae080e7          	jalr	1710(ra) # 8000235a <kill>
}
    80002cb4:	60e2                	ld	ra,24(sp)
    80002cb6:	6442                	ld	s0,16(sp)
    80002cb8:	6105                	add	sp,sp,32
    80002cba:	8082                	ret

0000000080002cbc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002cbc:	1101                	add	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	e426                	sd	s1,8(sp)
    80002cc4:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002cc6:	00014517          	auipc	a0,0x14
    80002cca:	3e250513          	add	a0,a0,994 # 800170a8 <tickslock>
    80002cce:	ffffe097          	auipc	ra,0xffffe
    80002cd2:	f34080e7          	jalr	-204(ra) # 80000c02 <acquire>
  xticks = ticks;
    80002cd6:	00006497          	auipc	s1,0x6
    80002cda:	34a4a483          	lw	s1,842(s1) # 80009020 <ticks>
  release(&tickslock);
    80002cde:	00014517          	auipc	a0,0x14
    80002ce2:	3ca50513          	add	a0,a0,970 # 800170a8 <tickslock>
    80002ce6:	ffffe097          	auipc	ra,0xffffe
    80002cea:	fd0080e7          	jalr	-48(ra) # 80000cb6 <release>
  return xticks;
}
    80002cee:	02049513          	sll	a0,s1,0x20
    80002cf2:	9101                	srl	a0,a0,0x20
    80002cf4:	60e2                	ld	ra,24(sp)
    80002cf6:	6442                	ld	s0,16(sp)
    80002cf8:	64a2                	ld	s1,8(sp)
    80002cfa:	6105                	add	sp,sp,32
    80002cfc:	8082                	ret

0000000080002cfe <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002cfe:	7179                	add	sp,sp,-48
    80002d00:	f406                	sd	ra,40(sp)
    80002d02:	f022                	sd	s0,32(sp)
    80002d04:	ec26                	sd	s1,24(sp)
    80002d06:	e84a                	sd	s2,16(sp)
    80002d08:	e44e                	sd	s3,8(sp)
    80002d0a:	e052                	sd	s4,0(sp)
    80002d0c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d0e:	00005597          	auipc	a1,0x5
    80002d12:	7c258593          	add	a1,a1,1986 # 800084d0 <syscalls+0xb0>
    80002d16:	00014517          	auipc	a0,0x14
    80002d1a:	3aa50513          	add	a0,a0,938 # 800170c0 <bcache>
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	e54080e7          	jalr	-428(ra) # 80000b72 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d26:	0001c797          	auipc	a5,0x1c
    80002d2a:	39a78793          	add	a5,a5,922 # 8001f0c0 <bcache+0x8000>
    80002d2e:	0001c717          	auipc	a4,0x1c
    80002d32:	5fa70713          	add	a4,a4,1530 # 8001f328 <bcache+0x8268>
    80002d36:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d3a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d3e:	00014497          	auipc	s1,0x14
    80002d42:	39a48493          	add	s1,s1,922 # 800170d8 <bcache+0x18>
    b->next = bcache.head.next;
    80002d46:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d48:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d4a:	00005a17          	auipc	s4,0x5
    80002d4e:	78ea0a13          	add	s4,s4,1934 # 800084d8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002d52:	2b893783          	ld	a5,696(s2)
    80002d56:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d58:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002d5c:	85d2                	mv	a1,s4
    80002d5e:	01048513          	add	a0,s1,16
    80002d62:	00001097          	auipc	ra,0x1
    80002d66:	496080e7          	jalr	1174(ra) # 800041f8 <initsleeplock>
    bcache.head.next->prev = b;
    80002d6a:	2b893783          	ld	a5,696(s2)
    80002d6e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d70:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d74:	45848493          	add	s1,s1,1112
    80002d78:	fd349de3          	bne	s1,s3,80002d52 <binit+0x54>
  }
}
    80002d7c:	70a2                	ld	ra,40(sp)
    80002d7e:	7402                	ld	s0,32(sp)
    80002d80:	64e2                	ld	s1,24(sp)
    80002d82:	6942                	ld	s2,16(sp)
    80002d84:	69a2                	ld	s3,8(sp)
    80002d86:	6a02                	ld	s4,0(sp)
    80002d88:	6145                	add	sp,sp,48
    80002d8a:	8082                	ret

0000000080002d8c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d8c:	7179                	add	sp,sp,-48
    80002d8e:	f406                	sd	ra,40(sp)
    80002d90:	f022                	sd	s0,32(sp)
    80002d92:	ec26                	sd	s1,24(sp)
    80002d94:	e84a                	sd	s2,16(sp)
    80002d96:	e44e                	sd	s3,8(sp)
    80002d98:	1800                	add	s0,sp,48
    80002d9a:	892a                	mv	s2,a0
    80002d9c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d9e:	00014517          	auipc	a0,0x14
    80002da2:	32250513          	add	a0,a0,802 # 800170c0 <bcache>
    80002da6:	ffffe097          	auipc	ra,0xffffe
    80002daa:	e5c080e7          	jalr	-420(ra) # 80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002dae:	0001c497          	auipc	s1,0x1c
    80002db2:	5ca4b483          	ld	s1,1482(s1) # 8001f378 <bcache+0x82b8>
    80002db6:	0001c797          	auipc	a5,0x1c
    80002dba:	57278793          	add	a5,a5,1394 # 8001f328 <bcache+0x8268>
    80002dbe:	02f48f63          	beq	s1,a5,80002dfc <bread+0x70>
    80002dc2:	873e                	mv	a4,a5
    80002dc4:	a021                	j	80002dcc <bread+0x40>
    80002dc6:	68a4                	ld	s1,80(s1)
    80002dc8:	02e48a63          	beq	s1,a4,80002dfc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002dcc:	449c                	lw	a5,8(s1)
    80002dce:	ff279ce3          	bne	a5,s2,80002dc6 <bread+0x3a>
    80002dd2:	44dc                	lw	a5,12(s1)
    80002dd4:	ff3799e3          	bne	a5,s3,80002dc6 <bread+0x3a>
      b->refcnt++;
    80002dd8:	40bc                	lw	a5,64(s1)
    80002dda:	2785                	addw	a5,a5,1
    80002ddc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002dde:	00014517          	auipc	a0,0x14
    80002de2:	2e250513          	add	a0,a0,738 # 800170c0 <bcache>
    80002de6:	ffffe097          	auipc	ra,0xffffe
    80002dea:	ed0080e7          	jalr	-304(ra) # 80000cb6 <release>
      acquiresleep(&b->lock);
    80002dee:	01048513          	add	a0,s1,16
    80002df2:	00001097          	auipc	ra,0x1
    80002df6:	440080e7          	jalr	1088(ra) # 80004232 <acquiresleep>
      return b;
    80002dfa:	a8b9                	j	80002e58 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002dfc:	0001c497          	auipc	s1,0x1c
    80002e00:	5744b483          	ld	s1,1396(s1) # 8001f370 <bcache+0x82b0>
    80002e04:	0001c797          	auipc	a5,0x1c
    80002e08:	52478793          	add	a5,a5,1316 # 8001f328 <bcache+0x8268>
    80002e0c:	00f48863          	beq	s1,a5,80002e1c <bread+0x90>
    80002e10:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e12:	40bc                	lw	a5,64(s1)
    80002e14:	cf81                	beqz	a5,80002e2c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e16:	64a4                	ld	s1,72(s1)
    80002e18:	fee49de3          	bne	s1,a4,80002e12 <bread+0x86>
  panic("bget: no buffers");
    80002e1c:	00005517          	auipc	a0,0x5
    80002e20:	6c450513          	add	a0,a0,1732 # 800084e0 <syscalls+0xc0>
    80002e24:	ffffd097          	auipc	ra,0xffffd
    80002e28:	724080e7          	jalr	1828(ra) # 80000548 <panic>
      b->dev = dev;
    80002e2c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e30:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e34:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e38:	4785                	li	a5,1
    80002e3a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e3c:	00014517          	auipc	a0,0x14
    80002e40:	28450513          	add	a0,a0,644 # 800170c0 <bcache>
    80002e44:	ffffe097          	auipc	ra,0xffffe
    80002e48:	e72080e7          	jalr	-398(ra) # 80000cb6 <release>
      acquiresleep(&b->lock);
    80002e4c:	01048513          	add	a0,s1,16
    80002e50:	00001097          	auipc	ra,0x1
    80002e54:	3e2080e7          	jalr	994(ra) # 80004232 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002e58:	409c                	lw	a5,0(s1)
    80002e5a:	cb89                	beqz	a5,80002e6c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	70a2                	ld	ra,40(sp)
    80002e60:	7402                	ld	s0,32(sp)
    80002e62:	64e2                	ld	s1,24(sp)
    80002e64:	6942                	ld	s2,16(sp)
    80002e66:	69a2                	ld	s3,8(sp)
    80002e68:	6145                	add	sp,sp,48
    80002e6a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002e6c:	4581                	li	a1,0
    80002e6e:	8526                	mv	a0,s1
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	f02080e7          	jalr	-254(ra) # 80005d72 <virtio_disk_rw>
    b->valid = 1;
    80002e78:	4785                	li	a5,1
    80002e7a:	c09c                	sw	a5,0(s1)
  return b;
    80002e7c:	b7c5                	j	80002e5c <bread+0xd0>

0000000080002e7e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002e7e:	1101                	add	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	e426                	sd	s1,8(sp)
    80002e86:	1000                	add	s0,sp,32
    80002e88:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e8a:	0541                	add	a0,a0,16
    80002e8c:	00001097          	auipc	ra,0x1
    80002e90:	440080e7          	jalr	1088(ra) # 800042cc <holdingsleep>
    80002e94:	cd01                	beqz	a0,80002eac <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e96:	4585                	li	a1,1
    80002e98:	8526                	mv	a0,s1
    80002e9a:	00003097          	auipc	ra,0x3
    80002e9e:	ed8080e7          	jalr	-296(ra) # 80005d72 <virtio_disk_rw>
}
    80002ea2:	60e2                	ld	ra,24(sp)
    80002ea4:	6442                	ld	s0,16(sp)
    80002ea6:	64a2                	ld	s1,8(sp)
    80002ea8:	6105                	add	sp,sp,32
    80002eaa:	8082                	ret
    panic("bwrite");
    80002eac:	00005517          	auipc	a0,0x5
    80002eb0:	64c50513          	add	a0,a0,1612 # 800084f8 <syscalls+0xd8>
    80002eb4:	ffffd097          	auipc	ra,0xffffd
    80002eb8:	694080e7          	jalr	1684(ra) # 80000548 <panic>

0000000080002ebc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ebc:	1101                	add	sp,sp,-32
    80002ebe:	ec06                	sd	ra,24(sp)
    80002ec0:	e822                	sd	s0,16(sp)
    80002ec2:	e426                	sd	s1,8(sp)
    80002ec4:	e04a                	sd	s2,0(sp)
    80002ec6:	1000                	add	s0,sp,32
    80002ec8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002eca:	01050913          	add	s2,a0,16
    80002ece:	854a                	mv	a0,s2
    80002ed0:	00001097          	auipc	ra,0x1
    80002ed4:	3fc080e7          	jalr	1020(ra) # 800042cc <holdingsleep>
    80002ed8:	c925                	beqz	a0,80002f48 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002eda:	854a                	mv	a0,s2
    80002edc:	00001097          	auipc	ra,0x1
    80002ee0:	3ac080e7          	jalr	940(ra) # 80004288 <releasesleep>

  acquire(&bcache.lock);
    80002ee4:	00014517          	auipc	a0,0x14
    80002ee8:	1dc50513          	add	a0,a0,476 # 800170c0 <bcache>
    80002eec:	ffffe097          	auipc	ra,0xffffe
    80002ef0:	d16080e7          	jalr	-746(ra) # 80000c02 <acquire>
  b->refcnt--;
    80002ef4:	40bc                	lw	a5,64(s1)
    80002ef6:	37fd                	addw	a5,a5,-1
    80002ef8:	0007871b          	sext.w	a4,a5
    80002efc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002efe:	e71d                	bnez	a4,80002f2c <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f00:	68b8                	ld	a4,80(s1)
    80002f02:	64bc                	ld	a5,72(s1)
    80002f04:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f06:	68b8                	ld	a4,80(s1)
    80002f08:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f0a:	0001c797          	auipc	a5,0x1c
    80002f0e:	1b678793          	add	a5,a5,438 # 8001f0c0 <bcache+0x8000>
    80002f12:	2b87b703          	ld	a4,696(a5)
    80002f16:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f18:	0001c717          	auipc	a4,0x1c
    80002f1c:	41070713          	add	a4,a4,1040 # 8001f328 <bcache+0x8268>
    80002f20:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f22:	2b87b703          	ld	a4,696(a5)
    80002f26:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f28:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f2c:	00014517          	auipc	a0,0x14
    80002f30:	19450513          	add	a0,a0,404 # 800170c0 <bcache>
    80002f34:	ffffe097          	auipc	ra,0xffffe
    80002f38:	d82080e7          	jalr	-638(ra) # 80000cb6 <release>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6902                	ld	s2,0(sp)
    80002f44:	6105                	add	sp,sp,32
    80002f46:	8082                	ret
    panic("brelse");
    80002f48:	00005517          	auipc	a0,0x5
    80002f4c:	5b850513          	add	a0,a0,1464 # 80008500 <syscalls+0xe0>
    80002f50:	ffffd097          	auipc	ra,0xffffd
    80002f54:	5f8080e7          	jalr	1528(ra) # 80000548 <panic>

0000000080002f58 <bpin>:

void
bpin(struct buf *b) {
    80002f58:	1101                	add	sp,sp,-32
    80002f5a:	ec06                	sd	ra,24(sp)
    80002f5c:	e822                	sd	s0,16(sp)
    80002f5e:	e426                	sd	s1,8(sp)
    80002f60:	1000                	add	s0,sp,32
    80002f62:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f64:	00014517          	auipc	a0,0x14
    80002f68:	15c50513          	add	a0,a0,348 # 800170c0 <bcache>
    80002f6c:	ffffe097          	auipc	ra,0xffffe
    80002f70:	c96080e7          	jalr	-874(ra) # 80000c02 <acquire>
  b->refcnt++;
    80002f74:	40bc                	lw	a5,64(s1)
    80002f76:	2785                	addw	a5,a5,1
    80002f78:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f7a:	00014517          	auipc	a0,0x14
    80002f7e:	14650513          	add	a0,a0,326 # 800170c0 <bcache>
    80002f82:	ffffe097          	auipc	ra,0xffffe
    80002f86:	d34080e7          	jalr	-716(ra) # 80000cb6 <release>
}
    80002f8a:	60e2                	ld	ra,24(sp)
    80002f8c:	6442                	ld	s0,16(sp)
    80002f8e:	64a2                	ld	s1,8(sp)
    80002f90:	6105                	add	sp,sp,32
    80002f92:	8082                	ret

0000000080002f94 <bunpin>:

void
bunpin(struct buf *b) {
    80002f94:	1101                	add	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	e426                	sd	s1,8(sp)
    80002f9c:	1000                	add	s0,sp,32
    80002f9e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fa0:	00014517          	auipc	a0,0x14
    80002fa4:	12050513          	add	a0,a0,288 # 800170c0 <bcache>
    80002fa8:	ffffe097          	auipc	ra,0xffffe
    80002fac:	c5a080e7          	jalr	-934(ra) # 80000c02 <acquire>
  b->refcnt--;
    80002fb0:	40bc                	lw	a5,64(s1)
    80002fb2:	37fd                	addw	a5,a5,-1
    80002fb4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fb6:	00014517          	auipc	a0,0x14
    80002fba:	10a50513          	add	a0,a0,266 # 800170c0 <bcache>
    80002fbe:	ffffe097          	auipc	ra,0xffffe
    80002fc2:	cf8080e7          	jalr	-776(ra) # 80000cb6 <release>
}
    80002fc6:	60e2                	ld	ra,24(sp)
    80002fc8:	6442                	ld	s0,16(sp)
    80002fca:	64a2                	ld	s1,8(sp)
    80002fcc:	6105                	add	sp,sp,32
    80002fce:	8082                	ret

0000000080002fd0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002fd0:	1101                	add	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	e426                	sd	s1,8(sp)
    80002fd8:	e04a                	sd	s2,0(sp)
    80002fda:	1000                	add	s0,sp,32
    80002fdc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002fde:	00d5d59b          	srlw	a1,a1,0xd
    80002fe2:	0001c797          	auipc	a5,0x1c
    80002fe6:	7ba7a783          	lw	a5,1978(a5) # 8001f79c <sb+0x1c>
    80002fea:	9dbd                	addw	a1,a1,a5
    80002fec:	00000097          	auipc	ra,0x0
    80002ff0:	da0080e7          	jalr	-608(ra) # 80002d8c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002ff4:	0074f713          	and	a4,s1,7
    80002ff8:	4785                	li	a5,1
    80002ffa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ffe:	14ce                	sll	s1,s1,0x33
    80003000:	90d9                	srl	s1,s1,0x36
    80003002:	00950733          	add	a4,a0,s1
    80003006:	05874703          	lbu	a4,88(a4)
    8000300a:	00e7f6b3          	and	a3,a5,a4
    8000300e:	c69d                	beqz	a3,8000303c <bfree+0x6c>
    80003010:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003012:	94aa                	add	s1,s1,a0
    80003014:	fff7c793          	not	a5,a5
    80003018:	8f7d                	and	a4,a4,a5
    8000301a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000301e:	00001097          	auipc	ra,0x1
    80003022:	0ee080e7          	jalr	238(ra) # 8000410c <log_write>
  brelse(bp);
    80003026:	854a                	mv	a0,s2
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	e94080e7          	jalr	-364(ra) # 80002ebc <brelse>
}
    80003030:	60e2                	ld	ra,24(sp)
    80003032:	6442                	ld	s0,16(sp)
    80003034:	64a2                	ld	s1,8(sp)
    80003036:	6902                	ld	s2,0(sp)
    80003038:	6105                	add	sp,sp,32
    8000303a:	8082                	ret
    panic("freeing free block");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	4cc50513          	add	a0,a0,1228 # 80008508 <syscalls+0xe8>
    80003044:	ffffd097          	auipc	ra,0xffffd
    80003048:	504080e7          	jalr	1284(ra) # 80000548 <panic>

000000008000304c <balloc>:
{
    8000304c:	711d                	add	sp,sp,-96
    8000304e:	ec86                	sd	ra,88(sp)
    80003050:	e8a2                	sd	s0,80(sp)
    80003052:	e4a6                	sd	s1,72(sp)
    80003054:	e0ca                	sd	s2,64(sp)
    80003056:	fc4e                	sd	s3,56(sp)
    80003058:	f852                	sd	s4,48(sp)
    8000305a:	f456                	sd	s5,40(sp)
    8000305c:	f05a                	sd	s6,32(sp)
    8000305e:	ec5e                	sd	s7,24(sp)
    80003060:	e862                	sd	s8,16(sp)
    80003062:	e466                	sd	s9,8(sp)
    80003064:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003066:	0001c797          	auipc	a5,0x1c
    8000306a:	71e7a783          	lw	a5,1822(a5) # 8001f784 <sb+0x4>
    8000306e:	cbc1                	beqz	a5,800030fe <balloc+0xb2>
    80003070:	8baa                	mv	s7,a0
    80003072:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003074:	0001cb17          	auipc	s6,0x1c
    80003078:	70cb0b13          	add	s6,s6,1804 # 8001f780 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000307c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000307e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003080:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003082:	6c89                	lui	s9,0x2
    80003084:	a831                	j	800030a0 <balloc+0x54>
    brelse(bp);
    80003086:	854a                	mv	a0,s2
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	e34080e7          	jalr	-460(ra) # 80002ebc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003090:	015c87bb          	addw	a5,s9,s5
    80003094:	00078a9b          	sext.w	s5,a5
    80003098:	004b2703          	lw	a4,4(s6)
    8000309c:	06eaf163          	bgeu	s5,a4,800030fe <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800030a0:	41fad79b          	sraw	a5,s5,0x1f
    800030a4:	0137d79b          	srlw	a5,a5,0x13
    800030a8:	015787bb          	addw	a5,a5,s5
    800030ac:	40d7d79b          	sraw	a5,a5,0xd
    800030b0:	01cb2583          	lw	a1,28(s6)
    800030b4:	9dbd                	addw	a1,a1,a5
    800030b6:	855e                	mv	a0,s7
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	cd4080e7          	jalr	-812(ra) # 80002d8c <bread>
    800030c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030c2:	004b2503          	lw	a0,4(s6)
    800030c6:	000a849b          	sext.w	s1,s5
    800030ca:	8762                	mv	a4,s8
    800030cc:	faa4fde3          	bgeu	s1,a0,80003086 <balloc+0x3a>
      m = 1 << (bi % 8);
    800030d0:	00777693          	and	a3,a4,7
    800030d4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800030d8:	41f7579b          	sraw	a5,a4,0x1f
    800030dc:	01d7d79b          	srlw	a5,a5,0x1d
    800030e0:	9fb9                	addw	a5,a5,a4
    800030e2:	4037d79b          	sraw	a5,a5,0x3
    800030e6:	00f90633          	add	a2,s2,a5
    800030ea:	05864603          	lbu	a2,88(a2)
    800030ee:	00c6f5b3          	and	a1,a3,a2
    800030f2:	cd91                	beqz	a1,8000310e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030f4:	2705                	addw	a4,a4,1
    800030f6:	2485                	addw	s1,s1,1
    800030f8:	fd471ae3          	bne	a4,s4,800030cc <balloc+0x80>
    800030fc:	b769                	j	80003086 <balloc+0x3a>
  panic("balloc: out of blocks");
    800030fe:	00005517          	auipc	a0,0x5
    80003102:	42250513          	add	a0,a0,1058 # 80008520 <syscalls+0x100>
    80003106:	ffffd097          	auipc	ra,0xffffd
    8000310a:	442080e7          	jalr	1090(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000310e:	97ca                	add	a5,a5,s2
    80003110:	8e55                	or	a2,a2,a3
    80003112:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003116:	854a                	mv	a0,s2
    80003118:	00001097          	auipc	ra,0x1
    8000311c:	ff4080e7          	jalr	-12(ra) # 8000410c <log_write>
        brelse(bp);
    80003120:	854a                	mv	a0,s2
    80003122:	00000097          	auipc	ra,0x0
    80003126:	d9a080e7          	jalr	-614(ra) # 80002ebc <brelse>
  bp = bread(dev, bno);
    8000312a:	85a6                	mv	a1,s1
    8000312c:	855e                	mv	a0,s7
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	c5e080e7          	jalr	-930(ra) # 80002d8c <bread>
    80003136:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003138:	40000613          	li	a2,1024
    8000313c:	4581                	li	a1,0
    8000313e:	05850513          	add	a0,a0,88
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	bbc080e7          	jalr	-1092(ra) # 80000cfe <memset>
  log_write(bp);
    8000314a:	854a                	mv	a0,s2
    8000314c:	00001097          	auipc	ra,0x1
    80003150:	fc0080e7          	jalr	-64(ra) # 8000410c <log_write>
  brelse(bp);
    80003154:	854a                	mv	a0,s2
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	d66080e7          	jalr	-666(ra) # 80002ebc <brelse>
}
    8000315e:	8526                	mv	a0,s1
    80003160:	60e6                	ld	ra,88(sp)
    80003162:	6446                	ld	s0,80(sp)
    80003164:	64a6                	ld	s1,72(sp)
    80003166:	6906                	ld	s2,64(sp)
    80003168:	79e2                	ld	s3,56(sp)
    8000316a:	7a42                	ld	s4,48(sp)
    8000316c:	7aa2                	ld	s5,40(sp)
    8000316e:	7b02                	ld	s6,32(sp)
    80003170:	6be2                	ld	s7,24(sp)
    80003172:	6c42                	ld	s8,16(sp)
    80003174:	6ca2                	ld	s9,8(sp)
    80003176:	6125                	add	sp,sp,96
    80003178:	8082                	ret

000000008000317a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000317a:	7179                	add	sp,sp,-48
    8000317c:	f406                	sd	ra,40(sp)
    8000317e:	f022                	sd	s0,32(sp)
    80003180:	ec26                	sd	s1,24(sp)
    80003182:	e84a                	sd	s2,16(sp)
    80003184:	e44e                	sd	s3,8(sp)
    80003186:	e052                	sd	s4,0(sp)
    80003188:	1800                	add	s0,sp,48
    8000318a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000318c:	47ad                	li	a5,11
    8000318e:	04b7fe63          	bgeu	a5,a1,800031ea <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003192:	ff45849b          	addw	s1,a1,-12
    80003196:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000319a:	0ff00793          	li	a5,255
    8000319e:	0ae7e463          	bltu	a5,a4,80003246 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800031a2:	08052583          	lw	a1,128(a0)
    800031a6:	c5b5                	beqz	a1,80003212 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800031a8:	00092503          	lw	a0,0(s2)
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	be0080e7          	jalr	-1056(ra) # 80002d8c <bread>
    800031b4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800031b6:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800031ba:	02049713          	sll	a4,s1,0x20
    800031be:	01e75593          	srl	a1,a4,0x1e
    800031c2:	00b784b3          	add	s1,a5,a1
    800031c6:	0004a983          	lw	s3,0(s1)
    800031ca:	04098e63          	beqz	s3,80003226 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800031ce:	8552                	mv	a0,s4
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	cec080e7          	jalr	-788(ra) # 80002ebc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800031d8:	854e                	mv	a0,s3
    800031da:	70a2                	ld	ra,40(sp)
    800031dc:	7402                	ld	s0,32(sp)
    800031de:	64e2                	ld	s1,24(sp)
    800031e0:	6942                	ld	s2,16(sp)
    800031e2:	69a2                	ld	s3,8(sp)
    800031e4:	6a02                	ld	s4,0(sp)
    800031e6:	6145                	add	sp,sp,48
    800031e8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800031ea:	02059793          	sll	a5,a1,0x20
    800031ee:	01e7d593          	srl	a1,a5,0x1e
    800031f2:	00b504b3          	add	s1,a0,a1
    800031f6:	0504a983          	lw	s3,80(s1)
    800031fa:	fc099fe3          	bnez	s3,800031d8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800031fe:	4108                	lw	a0,0(a0)
    80003200:	00000097          	auipc	ra,0x0
    80003204:	e4c080e7          	jalr	-436(ra) # 8000304c <balloc>
    80003208:	0005099b          	sext.w	s3,a0
    8000320c:	0534a823          	sw	s3,80(s1)
    80003210:	b7e1                	j	800031d8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003212:	4108                	lw	a0,0(a0)
    80003214:	00000097          	auipc	ra,0x0
    80003218:	e38080e7          	jalr	-456(ra) # 8000304c <balloc>
    8000321c:	0005059b          	sext.w	a1,a0
    80003220:	08b92023          	sw	a1,128(s2)
    80003224:	b751                	j	800031a8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003226:	00092503          	lw	a0,0(s2)
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	e22080e7          	jalr	-478(ra) # 8000304c <balloc>
    80003232:	0005099b          	sext.w	s3,a0
    80003236:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00001097          	auipc	ra,0x1
    80003240:	ed0080e7          	jalr	-304(ra) # 8000410c <log_write>
    80003244:	b769                	j	800031ce <bmap+0x54>
  panic("bmap: out of range");
    80003246:	00005517          	auipc	a0,0x5
    8000324a:	2f250513          	add	a0,a0,754 # 80008538 <syscalls+0x118>
    8000324e:	ffffd097          	auipc	ra,0xffffd
    80003252:	2fa080e7          	jalr	762(ra) # 80000548 <panic>

0000000080003256 <iget>:
{
    80003256:	7179                	add	sp,sp,-48
    80003258:	f406                	sd	ra,40(sp)
    8000325a:	f022                	sd	s0,32(sp)
    8000325c:	ec26                	sd	s1,24(sp)
    8000325e:	e84a                	sd	s2,16(sp)
    80003260:	e44e                	sd	s3,8(sp)
    80003262:	e052                	sd	s4,0(sp)
    80003264:	1800                	add	s0,sp,48
    80003266:	89aa                	mv	s3,a0
    80003268:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000326a:	0001c517          	auipc	a0,0x1c
    8000326e:	53650513          	add	a0,a0,1334 # 8001f7a0 <icache>
    80003272:	ffffe097          	auipc	ra,0xffffe
    80003276:	990080e7          	jalr	-1648(ra) # 80000c02 <acquire>
  empty = 0;
    8000327a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000327c:	0001c497          	auipc	s1,0x1c
    80003280:	53c48493          	add	s1,s1,1340 # 8001f7b8 <icache+0x18>
    80003284:	0001e697          	auipc	a3,0x1e
    80003288:	fc468693          	add	a3,a3,-60 # 80021248 <log>
    8000328c:	a039                	j	8000329a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000328e:	02090b63          	beqz	s2,800032c4 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003292:	08848493          	add	s1,s1,136
    80003296:	02d48a63          	beq	s1,a3,800032ca <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000329a:	449c                	lw	a5,8(s1)
    8000329c:	fef059e3          	blez	a5,8000328e <iget+0x38>
    800032a0:	4098                	lw	a4,0(s1)
    800032a2:	ff3716e3          	bne	a4,s3,8000328e <iget+0x38>
    800032a6:	40d8                	lw	a4,4(s1)
    800032a8:	ff4713e3          	bne	a4,s4,8000328e <iget+0x38>
      ip->ref++;
    800032ac:	2785                	addw	a5,a5,1
    800032ae:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800032b0:	0001c517          	auipc	a0,0x1c
    800032b4:	4f050513          	add	a0,a0,1264 # 8001f7a0 <icache>
    800032b8:	ffffe097          	auipc	ra,0xffffe
    800032bc:	9fe080e7          	jalr	-1538(ra) # 80000cb6 <release>
      return ip;
    800032c0:	8926                	mv	s2,s1
    800032c2:	a03d                	j	800032f0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032c4:	f7f9                	bnez	a5,80003292 <iget+0x3c>
    800032c6:	8926                	mv	s2,s1
    800032c8:	b7e9                	j	80003292 <iget+0x3c>
  if(empty == 0)
    800032ca:	02090c63          	beqz	s2,80003302 <iget+0xac>
  ip->dev = dev;
    800032ce:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800032d2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800032d6:	4785                	li	a5,1
    800032d8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800032dc:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800032e0:	0001c517          	auipc	a0,0x1c
    800032e4:	4c050513          	add	a0,a0,1216 # 8001f7a0 <icache>
    800032e8:	ffffe097          	auipc	ra,0xffffe
    800032ec:	9ce080e7          	jalr	-1586(ra) # 80000cb6 <release>
}
    800032f0:	854a                	mv	a0,s2
    800032f2:	70a2                	ld	ra,40(sp)
    800032f4:	7402                	ld	s0,32(sp)
    800032f6:	64e2                	ld	s1,24(sp)
    800032f8:	6942                	ld	s2,16(sp)
    800032fa:	69a2                	ld	s3,8(sp)
    800032fc:	6a02                	ld	s4,0(sp)
    800032fe:	6145                	add	sp,sp,48
    80003300:	8082                	ret
    panic("iget: no inodes");
    80003302:	00005517          	auipc	a0,0x5
    80003306:	24e50513          	add	a0,a0,590 # 80008550 <syscalls+0x130>
    8000330a:	ffffd097          	auipc	ra,0xffffd
    8000330e:	23e080e7          	jalr	574(ra) # 80000548 <panic>

0000000080003312 <fsinit>:
fsinit(int dev) {
    80003312:	7179                	add	sp,sp,-48
    80003314:	f406                	sd	ra,40(sp)
    80003316:	f022                	sd	s0,32(sp)
    80003318:	ec26                	sd	s1,24(sp)
    8000331a:	e84a                	sd	s2,16(sp)
    8000331c:	e44e                	sd	s3,8(sp)
    8000331e:	1800                	add	s0,sp,48
    80003320:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003322:	4585                	li	a1,1
    80003324:	00000097          	auipc	ra,0x0
    80003328:	a68080e7          	jalr	-1432(ra) # 80002d8c <bread>
    8000332c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000332e:	0001c997          	auipc	s3,0x1c
    80003332:	45298993          	add	s3,s3,1106 # 8001f780 <sb>
    80003336:	02000613          	li	a2,32
    8000333a:	05850593          	add	a1,a0,88
    8000333e:	854e                	mv	a0,s3
    80003340:	ffffe097          	auipc	ra,0xffffe
    80003344:	a1a080e7          	jalr	-1510(ra) # 80000d5a <memmove>
  brelse(bp);
    80003348:	8526                	mv	a0,s1
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	b72080e7          	jalr	-1166(ra) # 80002ebc <brelse>
  if(sb.magic != FSMAGIC)
    80003352:	0009a703          	lw	a4,0(s3)
    80003356:	102037b7          	lui	a5,0x10203
    8000335a:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000335e:	02f71263          	bne	a4,a5,80003382 <fsinit+0x70>
  initlog(dev, &sb);
    80003362:	0001c597          	auipc	a1,0x1c
    80003366:	41e58593          	add	a1,a1,1054 # 8001f780 <sb>
    8000336a:	854a                	mv	a0,s2
    8000336c:	00001097          	auipc	ra,0x1
    80003370:	b36080e7          	jalr	-1226(ra) # 80003ea2 <initlog>
}
    80003374:	70a2                	ld	ra,40(sp)
    80003376:	7402                	ld	s0,32(sp)
    80003378:	64e2                	ld	s1,24(sp)
    8000337a:	6942                	ld	s2,16(sp)
    8000337c:	69a2                	ld	s3,8(sp)
    8000337e:	6145                	add	sp,sp,48
    80003380:	8082                	ret
    panic("invalid file system");
    80003382:	00005517          	auipc	a0,0x5
    80003386:	1de50513          	add	a0,a0,478 # 80008560 <syscalls+0x140>
    8000338a:	ffffd097          	auipc	ra,0xffffd
    8000338e:	1be080e7          	jalr	446(ra) # 80000548 <panic>

0000000080003392 <iinit>:
{
    80003392:	7179                	add	sp,sp,-48
    80003394:	f406                	sd	ra,40(sp)
    80003396:	f022                	sd	s0,32(sp)
    80003398:	ec26                	sd	s1,24(sp)
    8000339a:	e84a                	sd	s2,16(sp)
    8000339c:	e44e                	sd	s3,8(sp)
    8000339e:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    800033a0:	00005597          	auipc	a1,0x5
    800033a4:	1d858593          	add	a1,a1,472 # 80008578 <syscalls+0x158>
    800033a8:	0001c517          	auipc	a0,0x1c
    800033ac:	3f850513          	add	a0,a0,1016 # 8001f7a0 <icache>
    800033b0:	ffffd097          	auipc	ra,0xffffd
    800033b4:	7c2080e7          	jalr	1986(ra) # 80000b72 <initlock>
  for(i = 0; i < NINODE; i++) {
    800033b8:	0001c497          	auipc	s1,0x1c
    800033bc:	41048493          	add	s1,s1,1040 # 8001f7c8 <icache+0x28>
    800033c0:	0001e997          	auipc	s3,0x1e
    800033c4:	e9898993          	add	s3,s3,-360 # 80021258 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800033c8:	00005917          	auipc	s2,0x5
    800033cc:	1b890913          	add	s2,s2,440 # 80008580 <syscalls+0x160>
    800033d0:	85ca                	mv	a1,s2
    800033d2:	8526                	mv	a0,s1
    800033d4:	00001097          	auipc	ra,0x1
    800033d8:	e24080e7          	jalr	-476(ra) # 800041f8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800033dc:	08848493          	add	s1,s1,136
    800033e0:	ff3498e3          	bne	s1,s3,800033d0 <iinit+0x3e>
}
    800033e4:	70a2                	ld	ra,40(sp)
    800033e6:	7402                	ld	s0,32(sp)
    800033e8:	64e2                	ld	s1,24(sp)
    800033ea:	6942                	ld	s2,16(sp)
    800033ec:	69a2                	ld	s3,8(sp)
    800033ee:	6145                	add	sp,sp,48
    800033f0:	8082                	ret

00000000800033f2 <ialloc>:
{
    800033f2:	7139                	add	sp,sp,-64
    800033f4:	fc06                	sd	ra,56(sp)
    800033f6:	f822                	sd	s0,48(sp)
    800033f8:	f426                	sd	s1,40(sp)
    800033fa:	f04a                	sd	s2,32(sp)
    800033fc:	ec4e                	sd	s3,24(sp)
    800033fe:	e852                	sd	s4,16(sp)
    80003400:	e456                	sd	s5,8(sp)
    80003402:	e05a                	sd	s6,0(sp)
    80003404:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003406:	0001c717          	auipc	a4,0x1c
    8000340a:	38672703          	lw	a4,902(a4) # 8001f78c <sb+0xc>
    8000340e:	4785                	li	a5,1
    80003410:	04e7f863          	bgeu	a5,a4,80003460 <ialloc+0x6e>
    80003414:	8aaa                	mv	s5,a0
    80003416:	8b2e                	mv	s6,a1
    80003418:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000341a:	0001ca17          	auipc	s4,0x1c
    8000341e:	366a0a13          	add	s4,s4,870 # 8001f780 <sb>
    80003422:	00495593          	srl	a1,s2,0x4
    80003426:	018a2783          	lw	a5,24(s4)
    8000342a:	9dbd                	addw	a1,a1,a5
    8000342c:	8556                	mv	a0,s5
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	95e080e7          	jalr	-1698(ra) # 80002d8c <bread>
    80003436:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003438:	05850993          	add	s3,a0,88
    8000343c:	00f97793          	and	a5,s2,15
    80003440:	079a                	sll	a5,a5,0x6
    80003442:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003444:	00099783          	lh	a5,0(s3)
    80003448:	c785                	beqz	a5,80003470 <ialloc+0x7e>
    brelse(bp);
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	a72080e7          	jalr	-1422(ra) # 80002ebc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003452:	0905                	add	s2,s2,1
    80003454:	00ca2703          	lw	a4,12(s4)
    80003458:	0009079b          	sext.w	a5,s2
    8000345c:	fce7e3e3          	bltu	a5,a4,80003422 <ialloc+0x30>
  panic("ialloc: no inodes");
    80003460:	00005517          	auipc	a0,0x5
    80003464:	12850513          	add	a0,a0,296 # 80008588 <syscalls+0x168>
    80003468:	ffffd097          	auipc	ra,0xffffd
    8000346c:	0e0080e7          	jalr	224(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    80003470:	04000613          	li	a2,64
    80003474:	4581                	li	a1,0
    80003476:	854e                	mv	a0,s3
    80003478:	ffffe097          	auipc	ra,0xffffe
    8000347c:	886080e7          	jalr	-1914(ra) # 80000cfe <memset>
      dip->type = type;
    80003480:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003484:	8526                	mv	a0,s1
    80003486:	00001097          	auipc	ra,0x1
    8000348a:	c86080e7          	jalr	-890(ra) # 8000410c <log_write>
      brelse(bp);
    8000348e:	8526                	mv	a0,s1
    80003490:	00000097          	auipc	ra,0x0
    80003494:	a2c080e7          	jalr	-1492(ra) # 80002ebc <brelse>
      return iget(dev, inum);
    80003498:	0009059b          	sext.w	a1,s2
    8000349c:	8556                	mv	a0,s5
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	db8080e7          	jalr	-584(ra) # 80003256 <iget>
}
    800034a6:	70e2                	ld	ra,56(sp)
    800034a8:	7442                	ld	s0,48(sp)
    800034aa:	74a2                	ld	s1,40(sp)
    800034ac:	7902                	ld	s2,32(sp)
    800034ae:	69e2                	ld	s3,24(sp)
    800034b0:	6a42                	ld	s4,16(sp)
    800034b2:	6aa2                	ld	s5,8(sp)
    800034b4:	6b02                	ld	s6,0(sp)
    800034b6:	6121                	add	sp,sp,64
    800034b8:	8082                	ret

00000000800034ba <iupdate>:
{
    800034ba:	1101                	add	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	e04a                	sd	s2,0(sp)
    800034c4:	1000                	add	s0,sp,32
    800034c6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034c8:	415c                	lw	a5,4(a0)
    800034ca:	0047d79b          	srlw	a5,a5,0x4
    800034ce:	0001c597          	auipc	a1,0x1c
    800034d2:	2ca5a583          	lw	a1,714(a1) # 8001f798 <sb+0x18>
    800034d6:	9dbd                	addw	a1,a1,a5
    800034d8:	4108                	lw	a0,0(a0)
    800034da:	00000097          	auipc	ra,0x0
    800034de:	8b2080e7          	jalr	-1870(ra) # 80002d8c <bread>
    800034e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034e4:	05850793          	add	a5,a0,88
    800034e8:	40d8                	lw	a4,4(s1)
    800034ea:	8b3d                	and	a4,a4,15
    800034ec:	071a                	sll	a4,a4,0x6
    800034ee:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800034f0:	04449703          	lh	a4,68(s1)
    800034f4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800034f8:	04649703          	lh	a4,70(s1)
    800034fc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003500:	04849703          	lh	a4,72(s1)
    80003504:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003508:	04a49703          	lh	a4,74(s1)
    8000350c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003510:	44f8                	lw	a4,76(s1)
    80003512:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003514:	03400613          	li	a2,52
    80003518:	05048593          	add	a1,s1,80
    8000351c:	00c78513          	add	a0,a5,12
    80003520:	ffffe097          	auipc	ra,0xffffe
    80003524:	83a080e7          	jalr	-1990(ra) # 80000d5a <memmove>
  log_write(bp);
    80003528:	854a                	mv	a0,s2
    8000352a:	00001097          	auipc	ra,0x1
    8000352e:	be2080e7          	jalr	-1054(ra) # 8000410c <log_write>
  brelse(bp);
    80003532:	854a                	mv	a0,s2
    80003534:	00000097          	auipc	ra,0x0
    80003538:	988080e7          	jalr	-1656(ra) # 80002ebc <brelse>
}
    8000353c:	60e2                	ld	ra,24(sp)
    8000353e:	6442                	ld	s0,16(sp)
    80003540:	64a2                	ld	s1,8(sp)
    80003542:	6902                	ld	s2,0(sp)
    80003544:	6105                	add	sp,sp,32
    80003546:	8082                	ret

0000000080003548 <idup>:
{
    80003548:	1101                	add	sp,sp,-32
    8000354a:	ec06                	sd	ra,24(sp)
    8000354c:	e822                	sd	s0,16(sp)
    8000354e:	e426                	sd	s1,8(sp)
    80003550:	1000                	add	s0,sp,32
    80003552:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003554:	0001c517          	auipc	a0,0x1c
    80003558:	24c50513          	add	a0,a0,588 # 8001f7a0 <icache>
    8000355c:	ffffd097          	auipc	ra,0xffffd
    80003560:	6a6080e7          	jalr	1702(ra) # 80000c02 <acquire>
  ip->ref++;
    80003564:	449c                	lw	a5,8(s1)
    80003566:	2785                	addw	a5,a5,1
    80003568:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000356a:	0001c517          	auipc	a0,0x1c
    8000356e:	23650513          	add	a0,a0,566 # 8001f7a0 <icache>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	744080e7          	jalr	1860(ra) # 80000cb6 <release>
}
    8000357a:	8526                	mv	a0,s1
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6105                	add	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <ilock>:
{
    80003586:	1101                	add	sp,sp,-32
    80003588:	ec06                	sd	ra,24(sp)
    8000358a:	e822                	sd	s0,16(sp)
    8000358c:	e426                	sd	s1,8(sp)
    8000358e:	e04a                	sd	s2,0(sp)
    80003590:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003592:	c115                	beqz	a0,800035b6 <ilock+0x30>
    80003594:	84aa                	mv	s1,a0
    80003596:	451c                	lw	a5,8(a0)
    80003598:	00f05f63          	blez	a5,800035b6 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000359c:	0541                	add	a0,a0,16
    8000359e:	00001097          	auipc	ra,0x1
    800035a2:	c94080e7          	jalr	-876(ra) # 80004232 <acquiresleep>
  if(ip->valid == 0){
    800035a6:	40bc                	lw	a5,64(s1)
    800035a8:	cf99                	beqz	a5,800035c6 <ilock+0x40>
}
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6902                	ld	s2,0(sp)
    800035b2:	6105                	add	sp,sp,32
    800035b4:	8082                	ret
    panic("ilock");
    800035b6:	00005517          	auipc	a0,0x5
    800035ba:	fea50513          	add	a0,a0,-22 # 800085a0 <syscalls+0x180>
    800035be:	ffffd097          	auipc	ra,0xffffd
    800035c2:	f8a080e7          	jalr	-118(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035c6:	40dc                	lw	a5,4(s1)
    800035c8:	0047d79b          	srlw	a5,a5,0x4
    800035cc:	0001c597          	auipc	a1,0x1c
    800035d0:	1cc5a583          	lw	a1,460(a1) # 8001f798 <sb+0x18>
    800035d4:	9dbd                	addw	a1,a1,a5
    800035d6:	4088                	lw	a0,0(s1)
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	7b4080e7          	jalr	1972(ra) # 80002d8c <bread>
    800035e0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035e2:	05850593          	add	a1,a0,88
    800035e6:	40dc                	lw	a5,4(s1)
    800035e8:	8bbd                	and	a5,a5,15
    800035ea:	079a                	sll	a5,a5,0x6
    800035ec:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800035ee:	00059783          	lh	a5,0(a1)
    800035f2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800035f6:	00259783          	lh	a5,2(a1)
    800035fa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800035fe:	00459783          	lh	a5,4(a1)
    80003602:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003606:	00659783          	lh	a5,6(a1)
    8000360a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000360e:	459c                	lw	a5,8(a1)
    80003610:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003612:	03400613          	li	a2,52
    80003616:	05b1                	add	a1,a1,12
    80003618:	05048513          	add	a0,s1,80
    8000361c:	ffffd097          	auipc	ra,0xffffd
    80003620:	73e080e7          	jalr	1854(ra) # 80000d5a <memmove>
    brelse(bp);
    80003624:	854a                	mv	a0,s2
    80003626:	00000097          	auipc	ra,0x0
    8000362a:	896080e7          	jalr	-1898(ra) # 80002ebc <brelse>
    ip->valid = 1;
    8000362e:	4785                	li	a5,1
    80003630:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003632:	04449783          	lh	a5,68(s1)
    80003636:	fbb5                	bnez	a5,800035aa <ilock+0x24>
      panic("ilock: no type");
    80003638:	00005517          	auipc	a0,0x5
    8000363c:	f7050513          	add	a0,a0,-144 # 800085a8 <syscalls+0x188>
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	f08080e7          	jalr	-248(ra) # 80000548 <panic>

0000000080003648 <iunlock>:
{
    80003648:	1101                	add	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	e426                	sd	s1,8(sp)
    80003650:	e04a                	sd	s2,0(sp)
    80003652:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003654:	c905                	beqz	a0,80003684 <iunlock+0x3c>
    80003656:	84aa                	mv	s1,a0
    80003658:	01050913          	add	s2,a0,16
    8000365c:	854a                	mv	a0,s2
    8000365e:	00001097          	auipc	ra,0x1
    80003662:	c6e080e7          	jalr	-914(ra) # 800042cc <holdingsleep>
    80003666:	cd19                	beqz	a0,80003684 <iunlock+0x3c>
    80003668:	449c                	lw	a5,8(s1)
    8000366a:	00f05d63          	blez	a5,80003684 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000366e:	854a                	mv	a0,s2
    80003670:	00001097          	auipc	ra,0x1
    80003674:	c18080e7          	jalr	-1000(ra) # 80004288 <releasesleep>
}
    80003678:	60e2                	ld	ra,24(sp)
    8000367a:	6442                	ld	s0,16(sp)
    8000367c:	64a2                	ld	s1,8(sp)
    8000367e:	6902                	ld	s2,0(sp)
    80003680:	6105                	add	sp,sp,32
    80003682:	8082                	ret
    panic("iunlock");
    80003684:	00005517          	auipc	a0,0x5
    80003688:	f3450513          	add	a0,a0,-204 # 800085b8 <syscalls+0x198>
    8000368c:	ffffd097          	auipc	ra,0xffffd
    80003690:	ebc080e7          	jalr	-324(ra) # 80000548 <panic>

0000000080003694 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003694:	7179                	add	sp,sp,-48
    80003696:	f406                	sd	ra,40(sp)
    80003698:	f022                	sd	s0,32(sp)
    8000369a:	ec26                	sd	s1,24(sp)
    8000369c:	e84a                	sd	s2,16(sp)
    8000369e:	e44e                	sd	s3,8(sp)
    800036a0:	e052                	sd	s4,0(sp)
    800036a2:	1800                	add	s0,sp,48
    800036a4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800036a6:	05050493          	add	s1,a0,80
    800036aa:	08050913          	add	s2,a0,128
    800036ae:	a021                	j	800036b6 <itrunc+0x22>
    800036b0:	0491                	add	s1,s1,4
    800036b2:	01248d63          	beq	s1,s2,800036cc <itrunc+0x38>
    if(ip->addrs[i]){
    800036b6:	408c                	lw	a1,0(s1)
    800036b8:	dde5                	beqz	a1,800036b0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800036ba:	0009a503          	lw	a0,0(s3)
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	912080e7          	jalr	-1774(ra) # 80002fd0 <bfree>
      ip->addrs[i] = 0;
    800036c6:	0004a023          	sw	zero,0(s1)
    800036ca:	b7dd                	j	800036b0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800036cc:	0809a583          	lw	a1,128(s3)
    800036d0:	e185                	bnez	a1,800036f0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800036d2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800036d6:	854e                	mv	a0,s3
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	de2080e7          	jalr	-542(ra) # 800034ba <iupdate>
}
    800036e0:	70a2                	ld	ra,40(sp)
    800036e2:	7402                	ld	s0,32(sp)
    800036e4:	64e2                	ld	s1,24(sp)
    800036e6:	6942                	ld	s2,16(sp)
    800036e8:	69a2                	ld	s3,8(sp)
    800036ea:	6a02                	ld	s4,0(sp)
    800036ec:	6145                	add	sp,sp,48
    800036ee:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800036f0:	0009a503          	lw	a0,0(s3)
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	698080e7          	jalr	1688(ra) # 80002d8c <bread>
    800036fc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800036fe:	05850493          	add	s1,a0,88
    80003702:	45850913          	add	s2,a0,1112
    80003706:	a021                	j	8000370e <itrunc+0x7a>
    80003708:	0491                	add	s1,s1,4
    8000370a:	01248b63          	beq	s1,s2,80003720 <itrunc+0x8c>
      if(a[j])
    8000370e:	408c                	lw	a1,0(s1)
    80003710:	dde5                	beqz	a1,80003708 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003712:	0009a503          	lw	a0,0(s3)
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	8ba080e7          	jalr	-1862(ra) # 80002fd0 <bfree>
    8000371e:	b7ed                	j	80003708 <itrunc+0x74>
    brelse(bp);
    80003720:	8552                	mv	a0,s4
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	79a080e7          	jalr	1946(ra) # 80002ebc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000372a:	0809a583          	lw	a1,128(s3)
    8000372e:	0009a503          	lw	a0,0(s3)
    80003732:	00000097          	auipc	ra,0x0
    80003736:	89e080e7          	jalr	-1890(ra) # 80002fd0 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000373a:	0809a023          	sw	zero,128(s3)
    8000373e:	bf51                	j	800036d2 <itrunc+0x3e>

0000000080003740 <iput>:
{
    80003740:	1101                	add	sp,sp,-32
    80003742:	ec06                	sd	ra,24(sp)
    80003744:	e822                	sd	s0,16(sp)
    80003746:	e426                	sd	s1,8(sp)
    80003748:	e04a                	sd	s2,0(sp)
    8000374a:	1000                	add	s0,sp,32
    8000374c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000374e:	0001c517          	auipc	a0,0x1c
    80003752:	05250513          	add	a0,a0,82 # 8001f7a0 <icache>
    80003756:	ffffd097          	auipc	ra,0xffffd
    8000375a:	4ac080e7          	jalr	1196(ra) # 80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000375e:	4498                	lw	a4,8(s1)
    80003760:	4785                	li	a5,1
    80003762:	02f70363          	beq	a4,a5,80003788 <iput+0x48>
  ip->ref--;
    80003766:	449c                	lw	a5,8(s1)
    80003768:	37fd                	addw	a5,a5,-1
    8000376a:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000376c:	0001c517          	auipc	a0,0x1c
    80003770:	03450513          	add	a0,a0,52 # 8001f7a0 <icache>
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	542080e7          	jalr	1346(ra) # 80000cb6 <release>
}
    8000377c:	60e2                	ld	ra,24(sp)
    8000377e:	6442                	ld	s0,16(sp)
    80003780:	64a2                	ld	s1,8(sp)
    80003782:	6902                	ld	s2,0(sp)
    80003784:	6105                	add	sp,sp,32
    80003786:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003788:	40bc                	lw	a5,64(s1)
    8000378a:	dff1                	beqz	a5,80003766 <iput+0x26>
    8000378c:	04a49783          	lh	a5,74(s1)
    80003790:	fbf9                	bnez	a5,80003766 <iput+0x26>
    acquiresleep(&ip->lock);
    80003792:	01048913          	add	s2,s1,16
    80003796:	854a                	mv	a0,s2
    80003798:	00001097          	auipc	ra,0x1
    8000379c:	a9a080e7          	jalr	-1382(ra) # 80004232 <acquiresleep>
    release(&icache.lock);
    800037a0:	0001c517          	auipc	a0,0x1c
    800037a4:	00050513          	mv	a0,a0
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	50e080e7          	jalr	1294(ra) # 80000cb6 <release>
    itrunc(ip);
    800037b0:	8526                	mv	a0,s1
    800037b2:	00000097          	auipc	ra,0x0
    800037b6:	ee2080e7          	jalr	-286(ra) # 80003694 <itrunc>
    ip->type = 0;
    800037ba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800037be:	8526                	mv	a0,s1
    800037c0:	00000097          	auipc	ra,0x0
    800037c4:	cfa080e7          	jalr	-774(ra) # 800034ba <iupdate>
    ip->valid = 0;
    800037c8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800037cc:	854a                	mv	a0,s2
    800037ce:	00001097          	auipc	ra,0x1
    800037d2:	aba080e7          	jalr	-1350(ra) # 80004288 <releasesleep>
    acquire(&icache.lock);
    800037d6:	0001c517          	auipc	a0,0x1c
    800037da:	fca50513          	add	a0,a0,-54 # 8001f7a0 <icache>
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	424080e7          	jalr	1060(ra) # 80000c02 <acquire>
    800037e6:	b741                	j	80003766 <iput+0x26>

00000000800037e8 <iunlockput>:
{
    800037e8:	1101                	add	sp,sp,-32
    800037ea:	ec06                	sd	ra,24(sp)
    800037ec:	e822                	sd	s0,16(sp)
    800037ee:	e426                	sd	s1,8(sp)
    800037f0:	1000                	add	s0,sp,32
    800037f2:	84aa                	mv	s1,a0
  iunlock(ip);
    800037f4:	00000097          	auipc	ra,0x0
    800037f8:	e54080e7          	jalr	-428(ra) # 80003648 <iunlock>
  iput(ip);
    800037fc:	8526                	mv	a0,s1
    800037fe:	00000097          	auipc	ra,0x0
    80003802:	f42080e7          	jalr	-190(ra) # 80003740 <iput>
}
    80003806:	60e2                	ld	ra,24(sp)
    80003808:	6442                	ld	s0,16(sp)
    8000380a:	64a2                	ld	s1,8(sp)
    8000380c:	6105                	add	sp,sp,32
    8000380e:	8082                	ret

0000000080003810 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003810:	1141                	add	sp,sp,-16
    80003812:	e422                	sd	s0,8(sp)
    80003814:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003816:	411c                	lw	a5,0(a0)
    80003818:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000381a:	415c                	lw	a5,4(a0)
    8000381c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000381e:	04451783          	lh	a5,68(a0)
    80003822:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003826:	04a51783          	lh	a5,74(a0)
    8000382a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000382e:	04c56783          	lwu	a5,76(a0)
    80003832:	e99c                	sd	a5,16(a1)
}
    80003834:	6422                	ld	s0,8(sp)
    80003836:	0141                	add	sp,sp,16
    80003838:	8082                	ret

000000008000383a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000383a:	457c                	lw	a5,76(a0)
    8000383c:	0ed7e963          	bltu	a5,a3,8000392e <readi+0xf4>
{
    80003840:	7159                	add	sp,sp,-112
    80003842:	f486                	sd	ra,104(sp)
    80003844:	f0a2                	sd	s0,96(sp)
    80003846:	eca6                	sd	s1,88(sp)
    80003848:	e8ca                	sd	s2,80(sp)
    8000384a:	e4ce                	sd	s3,72(sp)
    8000384c:	e0d2                	sd	s4,64(sp)
    8000384e:	fc56                	sd	s5,56(sp)
    80003850:	f85a                	sd	s6,48(sp)
    80003852:	f45e                	sd	s7,40(sp)
    80003854:	f062                	sd	s8,32(sp)
    80003856:	ec66                	sd	s9,24(sp)
    80003858:	e86a                	sd	s10,16(sp)
    8000385a:	e46e                	sd	s11,8(sp)
    8000385c:	1880                	add	s0,sp,112
    8000385e:	8baa                	mv	s7,a0
    80003860:	8c2e                	mv	s8,a1
    80003862:	8ab2                	mv	s5,a2
    80003864:	84b6                	mv	s1,a3
    80003866:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003868:	9f35                	addw	a4,a4,a3
    return 0;
    8000386a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000386c:	0ad76063          	bltu	a4,a3,8000390c <readi+0xd2>
  if(off + n > ip->size)
    80003870:	00e7f463          	bgeu	a5,a4,80003878 <readi+0x3e>
    n = ip->size - off;
    80003874:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003878:	0a0b0963          	beqz	s6,8000392a <readi+0xf0>
    8000387c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000387e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003882:	5cfd                	li	s9,-1
    80003884:	a82d                	j	800038be <readi+0x84>
    80003886:	020a1d93          	sll	s11,s4,0x20
    8000388a:	020ddd93          	srl	s11,s11,0x20
    8000388e:	05890613          	add	a2,s2,88
    80003892:	86ee                	mv	a3,s11
    80003894:	963a                	add	a2,a2,a4
    80003896:	85d6                	mv	a1,s5
    80003898:	8562                	mv	a0,s8
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	b30080e7          	jalr	-1232(ra) # 800023ca <either_copyout>
    800038a2:	05950d63          	beq	a0,s9,800038fc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038a6:	854a                	mv	a0,s2
    800038a8:	fffff097          	auipc	ra,0xfffff
    800038ac:	614080e7          	jalr	1556(ra) # 80002ebc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038b0:	013a09bb          	addw	s3,s4,s3
    800038b4:	009a04bb          	addw	s1,s4,s1
    800038b8:	9aee                	add	s5,s5,s11
    800038ba:	0569f763          	bgeu	s3,s6,80003908 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800038be:	000ba903          	lw	s2,0(s7)
    800038c2:	00a4d59b          	srlw	a1,s1,0xa
    800038c6:	855e                	mv	a0,s7
    800038c8:	00000097          	auipc	ra,0x0
    800038cc:	8b2080e7          	jalr	-1870(ra) # 8000317a <bmap>
    800038d0:	0005059b          	sext.w	a1,a0
    800038d4:	854a                	mv	a0,s2
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	4b6080e7          	jalr	1206(ra) # 80002d8c <bread>
    800038de:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038e0:	3ff4f713          	and	a4,s1,1023
    800038e4:	40ed07bb          	subw	a5,s10,a4
    800038e8:	413b06bb          	subw	a3,s6,s3
    800038ec:	8a3e                	mv	s4,a5
    800038ee:	2781                	sext.w	a5,a5
    800038f0:	0006861b          	sext.w	a2,a3
    800038f4:	f8f679e3          	bgeu	a2,a5,80003886 <readi+0x4c>
    800038f8:	8a36                	mv	s4,a3
    800038fa:	b771                	j	80003886 <readi+0x4c>
      brelse(bp);
    800038fc:	854a                	mv	a0,s2
    800038fe:	fffff097          	auipc	ra,0xfffff
    80003902:	5be080e7          	jalr	1470(ra) # 80002ebc <brelse>
      tot = -1;
    80003906:	59fd                	li	s3,-1
  }
  return tot;
    80003908:	0009851b          	sext.w	a0,s3
}
    8000390c:	70a6                	ld	ra,104(sp)
    8000390e:	7406                	ld	s0,96(sp)
    80003910:	64e6                	ld	s1,88(sp)
    80003912:	6946                	ld	s2,80(sp)
    80003914:	69a6                	ld	s3,72(sp)
    80003916:	6a06                	ld	s4,64(sp)
    80003918:	7ae2                	ld	s5,56(sp)
    8000391a:	7b42                	ld	s6,48(sp)
    8000391c:	7ba2                	ld	s7,40(sp)
    8000391e:	7c02                	ld	s8,32(sp)
    80003920:	6ce2                	ld	s9,24(sp)
    80003922:	6d42                	ld	s10,16(sp)
    80003924:	6da2                	ld	s11,8(sp)
    80003926:	6165                	add	sp,sp,112
    80003928:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000392a:	89da                	mv	s3,s6
    8000392c:	bff1                	j	80003908 <readi+0xce>
    return 0;
    8000392e:	4501                	li	a0,0
}
    80003930:	8082                	ret

0000000080003932 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003932:	457c                	lw	a5,76(a0)
    80003934:	10d7e763          	bltu	a5,a3,80003a42 <writei+0x110>
{
    80003938:	7159                	add	sp,sp,-112
    8000393a:	f486                	sd	ra,104(sp)
    8000393c:	f0a2                	sd	s0,96(sp)
    8000393e:	eca6                	sd	s1,88(sp)
    80003940:	e8ca                	sd	s2,80(sp)
    80003942:	e4ce                	sd	s3,72(sp)
    80003944:	e0d2                	sd	s4,64(sp)
    80003946:	fc56                	sd	s5,56(sp)
    80003948:	f85a                	sd	s6,48(sp)
    8000394a:	f45e                	sd	s7,40(sp)
    8000394c:	f062                	sd	s8,32(sp)
    8000394e:	ec66                	sd	s9,24(sp)
    80003950:	e86a                	sd	s10,16(sp)
    80003952:	e46e                	sd	s11,8(sp)
    80003954:	1880                	add	s0,sp,112
    80003956:	8baa                	mv	s7,a0
    80003958:	8c2e                	mv	s8,a1
    8000395a:	8ab2                	mv	s5,a2
    8000395c:	8936                	mv	s2,a3
    8000395e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003960:	00e687bb          	addw	a5,a3,a4
    80003964:	0ed7e163          	bltu	a5,a3,80003a46 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003968:	00043737          	lui	a4,0x43
    8000396c:	0cf76f63          	bltu	a4,a5,80003a4a <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003970:	0a0b0863          	beqz	s6,80003a20 <writei+0xee>
    80003974:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003976:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000397a:	5cfd                	li	s9,-1
    8000397c:	a091                	j	800039c0 <writei+0x8e>
    8000397e:	02099d93          	sll	s11,s3,0x20
    80003982:	020ddd93          	srl	s11,s11,0x20
    80003986:	05848513          	add	a0,s1,88
    8000398a:	86ee                	mv	a3,s11
    8000398c:	8656                	mv	a2,s5
    8000398e:	85e2                	mv	a1,s8
    80003990:	953a                	add	a0,a0,a4
    80003992:	fffff097          	auipc	ra,0xfffff
    80003996:	a8e080e7          	jalr	-1394(ra) # 80002420 <either_copyin>
    8000399a:	07950263          	beq	a0,s9,800039fe <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    8000399e:	8526                	mv	a0,s1
    800039a0:	00000097          	auipc	ra,0x0
    800039a4:	76c080e7          	jalr	1900(ra) # 8000410c <log_write>
    brelse(bp);
    800039a8:	8526                	mv	a0,s1
    800039aa:	fffff097          	auipc	ra,0xfffff
    800039ae:	512080e7          	jalr	1298(ra) # 80002ebc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039b2:	01498a3b          	addw	s4,s3,s4
    800039b6:	0129893b          	addw	s2,s3,s2
    800039ba:	9aee                	add	s5,s5,s11
    800039bc:	056a7763          	bgeu	s4,s6,80003a0a <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800039c0:	000ba483          	lw	s1,0(s7)
    800039c4:	00a9559b          	srlw	a1,s2,0xa
    800039c8:	855e                	mv	a0,s7
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	7b0080e7          	jalr	1968(ra) # 8000317a <bmap>
    800039d2:	0005059b          	sext.w	a1,a0
    800039d6:	8526                	mv	a0,s1
    800039d8:	fffff097          	auipc	ra,0xfffff
    800039dc:	3b4080e7          	jalr	948(ra) # 80002d8c <bread>
    800039e0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800039e2:	3ff97713          	and	a4,s2,1023
    800039e6:	40ed07bb          	subw	a5,s10,a4
    800039ea:	414b06bb          	subw	a3,s6,s4
    800039ee:	89be                	mv	s3,a5
    800039f0:	2781                	sext.w	a5,a5
    800039f2:	0006861b          	sext.w	a2,a3
    800039f6:	f8f674e3          	bgeu	a2,a5,8000397e <writei+0x4c>
    800039fa:	89b6                	mv	s3,a3
    800039fc:	b749                	j	8000397e <writei+0x4c>
      brelse(bp);
    800039fe:	8526                	mv	a0,s1
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	4bc080e7          	jalr	1212(ra) # 80002ebc <brelse>
      n = -1;
    80003a08:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003a0a:	04cba783          	lw	a5,76(s7)
    80003a0e:	0127f463          	bgeu	a5,s2,80003a16 <writei+0xe4>
      ip->size = off;
    80003a12:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a16:	855e                	mv	a0,s7
    80003a18:	00000097          	auipc	ra,0x0
    80003a1c:	aa2080e7          	jalr	-1374(ra) # 800034ba <iupdate>
  }

  return n;
    80003a20:	000b051b          	sext.w	a0,s6
}
    80003a24:	70a6                	ld	ra,104(sp)
    80003a26:	7406                	ld	s0,96(sp)
    80003a28:	64e6                	ld	s1,88(sp)
    80003a2a:	6946                	ld	s2,80(sp)
    80003a2c:	69a6                	ld	s3,72(sp)
    80003a2e:	6a06                	ld	s4,64(sp)
    80003a30:	7ae2                	ld	s5,56(sp)
    80003a32:	7b42                	ld	s6,48(sp)
    80003a34:	7ba2                	ld	s7,40(sp)
    80003a36:	7c02                	ld	s8,32(sp)
    80003a38:	6ce2                	ld	s9,24(sp)
    80003a3a:	6d42                	ld	s10,16(sp)
    80003a3c:	6da2                	ld	s11,8(sp)
    80003a3e:	6165                	add	sp,sp,112
    80003a40:	8082                	ret
    return -1;
    80003a42:	557d                	li	a0,-1
}
    80003a44:	8082                	ret
    return -1;
    80003a46:	557d                	li	a0,-1
    80003a48:	bff1                	j	80003a24 <writei+0xf2>
    return -1;
    80003a4a:	557d                	li	a0,-1
    80003a4c:	bfe1                	j	80003a24 <writei+0xf2>

0000000080003a4e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a4e:	1141                	add	sp,sp,-16
    80003a50:	e406                	sd	ra,8(sp)
    80003a52:	e022                	sd	s0,0(sp)
    80003a54:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a56:	4639                	li	a2,14
    80003a58:	ffffd097          	auipc	ra,0xffffd
    80003a5c:	37e080e7          	jalr	894(ra) # 80000dd6 <strncmp>
}
    80003a60:	60a2                	ld	ra,8(sp)
    80003a62:	6402                	ld	s0,0(sp)
    80003a64:	0141                	add	sp,sp,16
    80003a66:	8082                	ret

0000000080003a68 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a68:	7139                	add	sp,sp,-64
    80003a6a:	fc06                	sd	ra,56(sp)
    80003a6c:	f822                	sd	s0,48(sp)
    80003a6e:	f426                	sd	s1,40(sp)
    80003a70:	f04a                	sd	s2,32(sp)
    80003a72:	ec4e                	sd	s3,24(sp)
    80003a74:	e852                	sd	s4,16(sp)
    80003a76:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a78:	04451703          	lh	a4,68(a0)
    80003a7c:	4785                	li	a5,1
    80003a7e:	00f71a63          	bne	a4,a5,80003a92 <dirlookup+0x2a>
    80003a82:	892a                	mv	s2,a0
    80003a84:	89ae                	mv	s3,a1
    80003a86:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a88:	457c                	lw	a5,76(a0)
    80003a8a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a8c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a8e:	e79d                	bnez	a5,80003abc <dirlookup+0x54>
    80003a90:	a8a5                	j	80003b08 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003a92:	00005517          	auipc	a0,0x5
    80003a96:	b2e50513          	add	a0,a0,-1234 # 800085c0 <syscalls+0x1a0>
    80003a9a:	ffffd097          	auipc	ra,0xffffd
    80003a9e:	aae080e7          	jalr	-1362(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003aa2:	00005517          	auipc	a0,0x5
    80003aa6:	b3650513          	add	a0,a0,-1226 # 800085d8 <syscalls+0x1b8>
    80003aaa:	ffffd097          	auipc	ra,0xffffd
    80003aae:	a9e080e7          	jalr	-1378(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ab2:	24c1                	addw	s1,s1,16
    80003ab4:	04c92783          	lw	a5,76(s2)
    80003ab8:	04f4f763          	bgeu	s1,a5,80003b06 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003abc:	4741                	li	a4,16
    80003abe:	86a6                	mv	a3,s1
    80003ac0:	fc040613          	add	a2,s0,-64
    80003ac4:	4581                	li	a1,0
    80003ac6:	854a                	mv	a0,s2
    80003ac8:	00000097          	auipc	ra,0x0
    80003acc:	d72080e7          	jalr	-654(ra) # 8000383a <readi>
    80003ad0:	47c1                	li	a5,16
    80003ad2:	fcf518e3          	bne	a0,a5,80003aa2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003ad6:	fc045783          	lhu	a5,-64(s0)
    80003ada:	dfe1                	beqz	a5,80003ab2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003adc:	fc240593          	add	a1,s0,-62
    80003ae0:	854e                	mv	a0,s3
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	f6c080e7          	jalr	-148(ra) # 80003a4e <namecmp>
    80003aea:	f561                	bnez	a0,80003ab2 <dirlookup+0x4a>
      if(poff)
    80003aec:	000a0463          	beqz	s4,80003af4 <dirlookup+0x8c>
        *poff = off;
    80003af0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003af4:	fc045583          	lhu	a1,-64(s0)
    80003af8:	00092503          	lw	a0,0(s2)
    80003afc:	fffff097          	auipc	ra,0xfffff
    80003b00:	75a080e7          	jalr	1882(ra) # 80003256 <iget>
    80003b04:	a011                	j	80003b08 <dirlookup+0xa0>
  return 0;
    80003b06:	4501                	li	a0,0
}
    80003b08:	70e2                	ld	ra,56(sp)
    80003b0a:	7442                	ld	s0,48(sp)
    80003b0c:	74a2                	ld	s1,40(sp)
    80003b0e:	7902                	ld	s2,32(sp)
    80003b10:	69e2                	ld	s3,24(sp)
    80003b12:	6a42                	ld	s4,16(sp)
    80003b14:	6121                	add	sp,sp,64
    80003b16:	8082                	ret

0000000080003b18 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b18:	711d                	add	sp,sp,-96
    80003b1a:	ec86                	sd	ra,88(sp)
    80003b1c:	e8a2                	sd	s0,80(sp)
    80003b1e:	e4a6                	sd	s1,72(sp)
    80003b20:	e0ca                	sd	s2,64(sp)
    80003b22:	fc4e                	sd	s3,56(sp)
    80003b24:	f852                	sd	s4,48(sp)
    80003b26:	f456                	sd	s5,40(sp)
    80003b28:	f05a                	sd	s6,32(sp)
    80003b2a:	ec5e                	sd	s7,24(sp)
    80003b2c:	e862                	sd	s8,16(sp)
    80003b2e:	e466                	sd	s9,8(sp)
    80003b30:	1080                	add	s0,sp,96
    80003b32:	84aa                	mv	s1,a0
    80003b34:	8b2e                	mv	s6,a1
    80003b36:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b38:	00054703          	lbu	a4,0(a0)
    80003b3c:	02f00793          	li	a5,47
    80003b40:	02f70263          	beq	a4,a5,80003b64 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b44:	ffffe097          	auipc	ra,0xffffe
    80003b48:	e16080e7          	jalr	-490(ra) # 8000195a <myproc>
    80003b4c:	15053503          	ld	a0,336(a0)
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	9f8080e7          	jalr	-1544(ra) # 80003548 <idup>
    80003b58:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003b5a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003b5e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b60:	4b85                	li	s7,1
    80003b62:	a875                	j	80003c1e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003b64:	4585                	li	a1,1
    80003b66:	4505                	li	a0,1
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	6ee080e7          	jalr	1774(ra) # 80003256 <iget>
    80003b70:	8a2a                	mv	s4,a0
    80003b72:	b7e5                	j	80003b5a <namex+0x42>
      iunlockput(ip);
    80003b74:	8552                	mv	a0,s4
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	c72080e7          	jalr	-910(ra) # 800037e8 <iunlockput>
      return 0;
    80003b7e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b80:	8552                	mv	a0,s4
    80003b82:	60e6                	ld	ra,88(sp)
    80003b84:	6446                	ld	s0,80(sp)
    80003b86:	64a6                	ld	s1,72(sp)
    80003b88:	6906                	ld	s2,64(sp)
    80003b8a:	79e2                	ld	s3,56(sp)
    80003b8c:	7a42                	ld	s4,48(sp)
    80003b8e:	7aa2                	ld	s5,40(sp)
    80003b90:	7b02                	ld	s6,32(sp)
    80003b92:	6be2                	ld	s7,24(sp)
    80003b94:	6c42                	ld	s8,16(sp)
    80003b96:	6ca2                	ld	s9,8(sp)
    80003b98:	6125                	add	sp,sp,96
    80003b9a:	8082                	ret
      iunlock(ip);
    80003b9c:	8552                	mv	a0,s4
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	aaa080e7          	jalr	-1366(ra) # 80003648 <iunlock>
      return ip;
    80003ba6:	bfe9                	j	80003b80 <namex+0x68>
      iunlockput(ip);
    80003ba8:	8552                	mv	a0,s4
    80003baa:	00000097          	auipc	ra,0x0
    80003bae:	c3e080e7          	jalr	-962(ra) # 800037e8 <iunlockput>
      return 0;
    80003bb2:	8a4e                	mv	s4,s3
    80003bb4:	b7f1                	j	80003b80 <namex+0x68>
  len = path - s;
    80003bb6:	40998633          	sub	a2,s3,s1
    80003bba:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003bbe:	099c5863          	bge	s8,s9,80003c4e <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003bc2:	4639                	li	a2,14
    80003bc4:	85a6                	mv	a1,s1
    80003bc6:	8556                	mv	a0,s5
    80003bc8:	ffffd097          	auipc	ra,0xffffd
    80003bcc:	192080e7          	jalr	402(ra) # 80000d5a <memmove>
    80003bd0:	84ce                	mv	s1,s3
  while(*path == '/')
    80003bd2:	0004c783          	lbu	a5,0(s1)
    80003bd6:	01279763          	bne	a5,s2,80003be4 <namex+0xcc>
    path++;
    80003bda:	0485                	add	s1,s1,1
  while(*path == '/')
    80003bdc:	0004c783          	lbu	a5,0(s1)
    80003be0:	ff278de3          	beq	a5,s2,80003bda <namex+0xc2>
    ilock(ip);
    80003be4:	8552                	mv	a0,s4
    80003be6:	00000097          	auipc	ra,0x0
    80003bea:	9a0080e7          	jalr	-1632(ra) # 80003586 <ilock>
    if(ip->type != T_DIR){
    80003bee:	044a1783          	lh	a5,68(s4)
    80003bf2:	f97791e3          	bne	a5,s7,80003b74 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003bf6:	000b0563          	beqz	s6,80003c00 <namex+0xe8>
    80003bfa:	0004c783          	lbu	a5,0(s1)
    80003bfe:	dfd9                	beqz	a5,80003b9c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c00:	4601                	li	a2,0
    80003c02:	85d6                	mv	a1,s5
    80003c04:	8552                	mv	a0,s4
    80003c06:	00000097          	auipc	ra,0x0
    80003c0a:	e62080e7          	jalr	-414(ra) # 80003a68 <dirlookup>
    80003c0e:	89aa                	mv	s3,a0
    80003c10:	dd41                	beqz	a0,80003ba8 <namex+0x90>
    iunlockput(ip);
    80003c12:	8552                	mv	a0,s4
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	bd4080e7          	jalr	-1068(ra) # 800037e8 <iunlockput>
    ip = next;
    80003c1c:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c1e:	0004c783          	lbu	a5,0(s1)
    80003c22:	01279763          	bne	a5,s2,80003c30 <namex+0x118>
    path++;
    80003c26:	0485                	add	s1,s1,1
  while(*path == '/')
    80003c28:	0004c783          	lbu	a5,0(s1)
    80003c2c:	ff278de3          	beq	a5,s2,80003c26 <namex+0x10e>
  if(*path == 0)
    80003c30:	cb9d                	beqz	a5,80003c66 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003c32:	0004c783          	lbu	a5,0(s1)
    80003c36:	89a6                	mv	s3,s1
  len = path - s;
    80003c38:	4c81                	li	s9,0
    80003c3a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003c3c:	01278963          	beq	a5,s2,80003c4e <namex+0x136>
    80003c40:	dbbd                	beqz	a5,80003bb6 <namex+0x9e>
    path++;
    80003c42:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003c44:	0009c783          	lbu	a5,0(s3)
    80003c48:	ff279ce3          	bne	a5,s2,80003c40 <namex+0x128>
    80003c4c:	b7ad                	j	80003bb6 <namex+0x9e>
    memmove(name, s, len);
    80003c4e:	2601                	sext.w	a2,a2
    80003c50:	85a6                	mv	a1,s1
    80003c52:	8556                	mv	a0,s5
    80003c54:	ffffd097          	auipc	ra,0xffffd
    80003c58:	106080e7          	jalr	262(ra) # 80000d5a <memmove>
    name[len] = 0;
    80003c5c:	9cd6                	add	s9,s9,s5
    80003c5e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003c62:	84ce                	mv	s1,s3
    80003c64:	b7bd                	j	80003bd2 <namex+0xba>
  if(nameiparent){
    80003c66:	f00b0de3          	beqz	s6,80003b80 <namex+0x68>
    iput(ip);
    80003c6a:	8552                	mv	a0,s4
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	ad4080e7          	jalr	-1324(ra) # 80003740 <iput>
    return 0;
    80003c74:	4a01                	li	s4,0
    80003c76:	b729                	j	80003b80 <namex+0x68>

0000000080003c78 <dirlink>:
{
    80003c78:	7139                	add	sp,sp,-64
    80003c7a:	fc06                	sd	ra,56(sp)
    80003c7c:	f822                	sd	s0,48(sp)
    80003c7e:	f426                	sd	s1,40(sp)
    80003c80:	f04a                	sd	s2,32(sp)
    80003c82:	ec4e                	sd	s3,24(sp)
    80003c84:	e852                	sd	s4,16(sp)
    80003c86:	0080                	add	s0,sp,64
    80003c88:	892a                	mv	s2,a0
    80003c8a:	8a2e                	mv	s4,a1
    80003c8c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c8e:	4601                	li	a2,0
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	dd8080e7          	jalr	-552(ra) # 80003a68 <dirlookup>
    80003c98:	e93d                	bnez	a0,80003d0e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c9a:	04c92483          	lw	s1,76(s2)
    80003c9e:	c49d                	beqz	s1,80003ccc <dirlink+0x54>
    80003ca0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ca2:	4741                	li	a4,16
    80003ca4:	86a6                	mv	a3,s1
    80003ca6:	fc040613          	add	a2,s0,-64
    80003caa:	4581                	li	a1,0
    80003cac:	854a                	mv	a0,s2
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	b8c080e7          	jalr	-1140(ra) # 8000383a <readi>
    80003cb6:	47c1                	li	a5,16
    80003cb8:	06f51163          	bne	a0,a5,80003d1a <dirlink+0xa2>
    if(de.inum == 0)
    80003cbc:	fc045783          	lhu	a5,-64(s0)
    80003cc0:	c791                	beqz	a5,80003ccc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc2:	24c1                	addw	s1,s1,16
    80003cc4:	04c92783          	lw	a5,76(s2)
    80003cc8:	fcf4ede3          	bltu	s1,a5,80003ca2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003ccc:	4639                	li	a2,14
    80003cce:	85d2                	mv	a1,s4
    80003cd0:	fc240513          	add	a0,s0,-62
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	13e080e7          	jalr	318(ra) # 80000e12 <strncpy>
  de.inum = inum;
    80003cdc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ce0:	4741                	li	a4,16
    80003ce2:	86a6                	mv	a3,s1
    80003ce4:	fc040613          	add	a2,s0,-64
    80003ce8:	4581                	li	a1,0
    80003cea:	854a                	mv	a0,s2
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	c46080e7          	jalr	-954(ra) # 80003932 <writei>
    80003cf4:	872a                	mv	a4,a0
    80003cf6:	47c1                	li	a5,16
  return 0;
    80003cf8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cfa:	02f71863          	bne	a4,a5,80003d2a <dirlink+0xb2>
}
    80003cfe:	70e2                	ld	ra,56(sp)
    80003d00:	7442                	ld	s0,48(sp)
    80003d02:	74a2                	ld	s1,40(sp)
    80003d04:	7902                	ld	s2,32(sp)
    80003d06:	69e2                	ld	s3,24(sp)
    80003d08:	6a42                	ld	s4,16(sp)
    80003d0a:	6121                	add	sp,sp,64
    80003d0c:	8082                	ret
    iput(ip);
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	a32080e7          	jalr	-1486(ra) # 80003740 <iput>
    return -1;
    80003d16:	557d                	li	a0,-1
    80003d18:	b7dd                	j	80003cfe <dirlink+0x86>
      panic("dirlink read");
    80003d1a:	00005517          	auipc	a0,0x5
    80003d1e:	8ce50513          	add	a0,a0,-1842 # 800085e8 <syscalls+0x1c8>
    80003d22:	ffffd097          	auipc	ra,0xffffd
    80003d26:	826080e7          	jalr	-2010(ra) # 80000548 <panic>
    panic("dirlink");
    80003d2a:	00005517          	auipc	a0,0x5
    80003d2e:	9de50513          	add	a0,a0,-1570 # 80008708 <syscalls+0x2e8>
    80003d32:	ffffd097          	auipc	ra,0xffffd
    80003d36:	816080e7          	jalr	-2026(ra) # 80000548 <panic>

0000000080003d3a <namei>:

struct inode*
namei(char *path)
{
    80003d3a:	1101                	add	sp,sp,-32
    80003d3c:	ec06                	sd	ra,24(sp)
    80003d3e:	e822                	sd	s0,16(sp)
    80003d40:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003d42:	fe040613          	add	a2,s0,-32
    80003d46:	4581                	li	a1,0
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	dd0080e7          	jalr	-560(ra) # 80003b18 <namex>
}
    80003d50:	60e2                	ld	ra,24(sp)
    80003d52:	6442                	ld	s0,16(sp)
    80003d54:	6105                	add	sp,sp,32
    80003d56:	8082                	ret

0000000080003d58 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003d58:	1141                	add	sp,sp,-16
    80003d5a:	e406                	sd	ra,8(sp)
    80003d5c:	e022                	sd	s0,0(sp)
    80003d5e:	0800                	add	s0,sp,16
    80003d60:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d62:	4585                	li	a1,1
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	db4080e7          	jalr	-588(ra) # 80003b18 <namex>
}
    80003d6c:	60a2                	ld	ra,8(sp)
    80003d6e:	6402                	ld	s0,0(sp)
    80003d70:	0141                	add	sp,sp,16
    80003d72:	8082                	ret

0000000080003d74 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d74:	1101                	add	sp,sp,-32
    80003d76:	ec06                	sd	ra,24(sp)
    80003d78:	e822                	sd	s0,16(sp)
    80003d7a:	e426                	sd	s1,8(sp)
    80003d7c:	e04a                	sd	s2,0(sp)
    80003d7e:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d80:	0001d917          	auipc	s2,0x1d
    80003d84:	4c890913          	add	s2,s2,1224 # 80021248 <log>
    80003d88:	01892583          	lw	a1,24(s2)
    80003d8c:	02892503          	lw	a0,40(s2)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	ffc080e7          	jalr	-4(ra) # 80002d8c <bread>
    80003d98:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d9a:	02c92603          	lw	a2,44(s2)
    80003d9e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003da0:	00c05f63          	blez	a2,80003dbe <write_head+0x4a>
    80003da4:	0001d717          	auipc	a4,0x1d
    80003da8:	4d470713          	add	a4,a4,1236 # 80021278 <log+0x30>
    80003dac:	87aa                	mv	a5,a0
    80003dae:	060a                	sll	a2,a2,0x2
    80003db0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003db2:	4314                	lw	a3,0(a4)
    80003db4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003db6:	0711                	add	a4,a4,4
    80003db8:	0791                	add	a5,a5,4
    80003dba:	fec79ce3          	bne	a5,a2,80003db2 <write_head+0x3e>
  }
  bwrite(buf);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	fffff097          	auipc	ra,0xfffff
    80003dc4:	0be080e7          	jalr	190(ra) # 80002e7e <bwrite>
  brelse(buf);
    80003dc8:	8526                	mv	a0,s1
    80003dca:	fffff097          	auipc	ra,0xfffff
    80003dce:	0f2080e7          	jalr	242(ra) # 80002ebc <brelse>
}
    80003dd2:	60e2                	ld	ra,24(sp)
    80003dd4:	6442                	ld	s0,16(sp)
    80003dd6:	64a2                	ld	s1,8(sp)
    80003dd8:	6902                	ld	s2,0(sp)
    80003dda:	6105                	add	sp,sp,32
    80003ddc:	8082                	ret

0000000080003dde <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dde:	0001d797          	auipc	a5,0x1d
    80003de2:	4967a783          	lw	a5,1174(a5) # 80021274 <log+0x2c>
    80003de6:	0af05d63          	blez	a5,80003ea0 <install_trans+0xc2>
{
    80003dea:	7139                	add	sp,sp,-64
    80003dec:	fc06                	sd	ra,56(sp)
    80003dee:	f822                	sd	s0,48(sp)
    80003df0:	f426                	sd	s1,40(sp)
    80003df2:	f04a                	sd	s2,32(sp)
    80003df4:	ec4e                	sd	s3,24(sp)
    80003df6:	e852                	sd	s4,16(sp)
    80003df8:	e456                	sd	s5,8(sp)
    80003dfa:	e05a                	sd	s6,0(sp)
    80003dfc:	0080                	add	s0,sp,64
    80003dfe:	8b2a                	mv	s6,a0
    80003e00:	0001da97          	auipc	s5,0x1d
    80003e04:	478a8a93          	add	s5,s5,1144 # 80021278 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e08:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e0a:	0001d997          	auipc	s3,0x1d
    80003e0e:	43e98993          	add	s3,s3,1086 # 80021248 <log>
    80003e12:	a00d                	j	80003e34 <install_trans+0x56>
    brelse(lbuf);
    80003e14:	854a                	mv	a0,s2
    80003e16:	fffff097          	auipc	ra,0xfffff
    80003e1a:	0a6080e7          	jalr	166(ra) # 80002ebc <brelse>
    brelse(dbuf);
    80003e1e:	8526                	mv	a0,s1
    80003e20:	fffff097          	auipc	ra,0xfffff
    80003e24:	09c080e7          	jalr	156(ra) # 80002ebc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e28:	2a05                	addw	s4,s4,1
    80003e2a:	0a91                	add	s5,s5,4
    80003e2c:	02c9a783          	lw	a5,44(s3)
    80003e30:	04fa5e63          	bge	s4,a5,80003e8c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e34:	0189a583          	lw	a1,24(s3)
    80003e38:	014585bb          	addw	a1,a1,s4
    80003e3c:	2585                	addw	a1,a1,1
    80003e3e:	0289a503          	lw	a0,40(s3)
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	f4a080e7          	jalr	-182(ra) # 80002d8c <bread>
    80003e4a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003e4c:	000aa583          	lw	a1,0(s5)
    80003e50:	0289a503          	lw	a0,40(s3)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	f38080e7          	jalr	-200(ra) # 80002d8c <bread>
    80003e5c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003e5e:	40000613          	li	a2,1024
    80003e62:	05890593          	add	a1,s2,88
    80003e66:	05850513          	add	a0,a0,88
    80003e6a:	ffffd097          	auipc	ra,0xffffd
    80003e6e:	ef0080e7          	jalr	-272(ra) # 80000d5a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003e72:	8526                	mv	a0,s1
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	00a080e7          	jalr	10(ra) # 80002e7e <bwrite>
    if(recovering == 0)
    80003e7c:	f80b1ce3          	bnez	s6,80003e14 <install_trans+0x36>
      bunpin(dbuf);
    80003e80:	8526                	mv	a0,s1
    80003e82:	fffff097          	auipc	ra,0xfffff
    80003e86:	112080e7          	jalr	274(ra) # 80002f94 <bunpin>
    80003e8a:	b769                	j	80003e14 <install_trans+0x36>
}
    80003e8c:	70e2                	ld	ra,56(sp)
    80003e8e:	7442                	ld	s0,48(sp)
    80003e90:	74a2                	ld	s1,40(sp)
    80003e92:	7902                	ld	s2,32(sp)
    80003e94:	69e2                	ld	s3,24(sp)
    80003e96:	6a42                	ld	s4,16(sp)
    80003e98:	6aa2                	ld	s5,8(sp)
    80003e9a:	6b02                	ld	s6,0(sp)
    80003e9c:	6121                	add	sp,sp,64
    80003e9e:	8082                	ret
    80003ea0:	8082                	ret

0000000080003ea2 <initlog>:
{
    80003ea2:	7179                	add	sp,sp,-48
    80003ea4:	f406                	sd	ra,40(sp)
    80003ea6:	f022                	sd	s0,32(sp)
    80003ea8:	ec26                	sd	s1,24(sp)
    80003eaa:	e84a                	sd	s2,16(sp)
    80003eac:	e44e                	sd	s3,8(sp)
    80003eae:	1800                	add	s0,sp,48
    80003eb0:	892a                	mv	s2,a0
    80003eb2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003eb4:	0001d497          	auipc	s1,0x1d
    80003eb8:	39448493          	add	s1,s1,916 # 80021248 <log>
    80003ebc:	00004597          	auipc	a1,0x4
    80003ec0:	73c58593          	add	a1,a1,1852 # 800085f8 <syscalls+0x1d8>
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	cac080e7          	jalr	-852(ra) # 80000b72 <initlock>
  log.start = sb->logstart;
    80003ece:	0149a583          	lw	a1,20(s3)
    80003ed2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003ed4:	0109a783          	lw	a5,16(s3)
    80003ed8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003eda:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003ede:	854a                	mv	a0,s2
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	eac080e7          	jalr	-340(ra) # 80002d8c <bread>
  log.lh.n = lh->n;
    80003ee8:	4d30                	lw	a2,88(a0)
    80003eea:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003eec:	00c05f63          	blez	a2,80003f0a <initlog+0x68>
    80003ef0:	87aa                	mv	a5,a0
    80003ef2:	0001d717          	auipc	a4,0x1d
    80003ef6:	38670713          	add	a4,a4,902 # 80021278 <log+0x30>
    80003efa:	060a                	sll	a2,a2,0x2
    80003efc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003efe:	4ff4                	lw	a3,92(a5)
    80003f00:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f02:	0791                	add	a5,a5,4
    80003f04:	0711                	add	a4,a4,4
    80003f06:	fec79ce3          	bne	a5,a2,80003efe <initlog+0x5c>
  brelse(buf);
    80003f0a:	fffff097          	auipc	ra,0xfffff
    80003f0e:	fb2080e7          	jalr	-78(ra) # 80002ebc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f12:	4505                	li	a0,1
    80003f14:	00000097          	auipc	ra,0x0
    80003f18:	eca080e7          	jalr	-310(ra) # 80003dde <install_trans>
  log.lh.n = 0;
    80003f1c:	0001d797          	auipc	a5,0x1d
    80003f20:	3407ac23          	sw	zero,856(a5) # 80021274 <log+0x2c>
  write_head(); // clear the log
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	e50080e7          	jalr	-432(ra) # 80003d74 <write_head>
}
    80003f2c:	70a2                	ld	ra,40(sp)
    80003f2e:	7402                	ld	s0,32(sp)
    80003f30:	64e2                	ld	s1,24(sp)
    80003f32:	6942                	ld	s2,16(sp)
    80003f34:	69a2                	ld	s3,8(sp)
    80003f36:	6145                	add	sp,sp,48
    80003f38:	8082                	ret

0000000080003f3a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003f3a:	1101                	add	sp,sp,-32
    80003f3c:	ec06                	sd	ra,24(sp)
    80003f3e:	e822                	sd	s0,16(sp)
    80003f40:	e426                	sd	s1,8(sp)
    80003f42:	e04a                	sd	s2,0(sp)
    80003f44:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003f46:	0001d517          	auipc	a0,0x1d
    80003f4a:	30250513          	add	a0,a0,770 # 80021248 <log>
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	cb4080e7          	jalr	-844(ra) # 80000c02 <acquire>
  while(1){
    if(log.committing){
    80003f56:	0001d497          	auipc	s1,0x1d
    80003f5a:	2f248493          	add	s1,s1,754 # 80021248 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f5e:	4979                	li	s2,30
    80003f60:	a039                	j	80003f6e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003f62:	85a6                	mv	a1,s1
    80003f64:	8526                	mv	a0,s1
    80003f66:	ffffe097          	auipc	ra,0xffffe
    80003f6a:	20a080e7          	jalr	522(ra) # 80002170 <sleep>
    if(log.committing){
    80003f6e:	50dc                	lw	a5,36(s1)
    80003f70:	fbed                	bnez	a5,80003f62 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f72:	5098                	lw	a4,32(s1)
    80003f74:	2705                	addw	a4,a4,1
    80003f76:	0027179b          	sllw	a5,a4,0x2
    80003f7a:	9fb9                	addw	a5,a5,a4
    80003f7c:	0017979b          	sllw	a5,a5,0x1
    80003f80:	54d4                	lw	a3,44(s1)
    80003f82:	9fb5                	addw	a5,a5,a3
    80003f84:	00f95963          	bge	s2,a5,80003f96 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003f88:	85a6                	mv	a1,s1
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	ffffe097          	auipc	ra,0xffffe
    80003f90:	1e4080e7          	jalr	484(ra) # 80002170 <sleep>
    80003f94:	bfe9                	j	80003f6e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003f96:	0001d517          	auipc	a0,0x1d
    80003f9a:	2b250513          	add	a0,a0,690 # 80021248 <log>
    80003f9e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	d16080e7          	jalr	-746(ra) # 80000cb6 <release>
      break;
    }
  }
}
    80003fa8:	60e2                	ld	ra,24(sp)
    80003faa:	6442                	ld	s0,16(sp)
    80003fac:	64a2                	ld	s1,8(sp)
    80003fae:	6902                	ld	s2,0(sp)
    80003fb0:	6105                	add	sp,sp,32
    80003fb2:	8082                	ret

0000000080003fb4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003fb4:	7139                	add	sp,sp,-64
    80003fb6:	fc06                	sd	ra,56(sp)
    80003fb8:	f822                	sd	s0,48(sp)
    80003fba:	f426                	sd	s1,40(sp)
    80003fbc:	f04a                	sd	s2,32(sp)
    80003fbe:	ec4e                	sd	s3,24(sp)
    80003fc0:	e852                	sd	s4,16(sp)
    80003fc2:	e456                	sd	s5,8(sp)
    80003fc4:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003fc6:	0001d497          	auipc	s1,0x1d
    80003fca:	28248493          	add	s1,s1,642 # 80021248 <log>
    80003fce:	8526                	mv	a0,s1
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	c32080e7          	jalr	-974(ra) # 80000c02 <acquire>
  log.outstanding -= 1;
    80003fd8:	509c                	lw	a5,32(s1)
    80003fda:	37fd                	addw	a5,a5,-1
    80003fdc:	0007891b          	sext.w	s2,a5
    80003fe0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003fe2:	50dc                	lw	a5,36(s1)
    80003fe4:	e7b9                	bnez	a5,80004032 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003fe6:	04091e63          	bnez	s2,80004042 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003fea:	0001d497          	auipc	s1,0x1d
    80003fee:	25e48493          	add	s1,s1,606 # 80021248 <log>
    80003ff2:	4785                	li	a5,1
    80003ff4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	cbe080e7          	jalr	-834(ra) # 80000cb6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004000:	54dc                	lw	a5,44(s1)
    80004002:	06f04763          	bgtz	a5,80004070 <end_op+0xbc>
    acquire(&log.lock);
    80004006:	0001d497          	auipc	s1,0x1d
    8000400a:	24248493          	add	s1,s1,578 # 80021248 <log>
    8000400e:	8526                	mv	a0,s1
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	bf2080e7          	jalr	-1038(ra) # 80000c02 <acquire>
    log.committing = 0;
    80004018:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000401c:	8526                	mv	a0,s1
    8000401e:	ffffe097          	auipc	ra,0xffffe
    80004022:	2d2080e7          	jalr	722(ra) # 800022f0 <wakeup>
    release(&log.lock);
    80004026:	8526                	mv	a0,s1
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	c8e080e7          	jalr	-882(ra) # 80000cb6 <release>
}
    80004030:	a03d                	j	8000405e <end_op+0xaa>
    panic("log.committing");
    80004032:	00004517          	auipc	a0,0x4
    80004036:	5ce50513          	add	a0,a0,1486 # 80008600 <syscalls+0x1e0>
    8000403a:	ffffc097          	auipc	ra,0xffffc
    8000403e:	50e080e7          	jalr	1294(ra) # 80000548 <panic>
    wakeup(&log);
    80004042:	0001d497          	auipc	s1,0x1d
    80004046:	20648493          	add	s1,s1,518 # 80021248 <log>
    8000404a:	8526                	mv	a0,s1
    8000404c:	ffffe097          	auipc	ra,0xffffe
    80004050:	2a4080e7          	jalr	676(ra) # 800022f0 <wakeup>
  release(&log.lock);
    80004054:	8526                	mv	a0,s1
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	c60080e7          	jalr	-928(ra) # 80000cb6 <release>
}
    8000405e:	70e2                	ld	ra,56(sp)
    80004060:	7442                	ld	s0,48(sp)
    80004062:	74a2                	ld	s1,40(sp)
    80004064:	7902                	ld	s2,32(sp)
    80004066:	69e2                	ld	s3,24(sp)
    80004068:	6a42                	ld	s4,16(sp)
    8000406a:	6aa2                	ld	s5,8(sp)
    8000406c:	6121                	add	sp,sp,64
    8000406e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004070:	0001da97          	auipc	s5,0x1d
    80004074:	208a8a93          	add	s5,s5,520 # 80021278 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004078:	0001da17          	auipc	s4,0x1d
    8000407c:	1d0a0a13          	add	s4,s4,464 # 80021248 <log>
    80004080:	018a2583          	lw	a1,24(s4)
    80004084:	012585bb          	addw	a1,a1,s2
    80004088:	2585                	addw	a1,a1,1
    8000408a:	028a2503          	lw	a0,40(s4)
    8000408e:	fffff097          	auipc	ra,0xfffff
    80004092:	cfe080e7          	jalr	-770(ra) # 80002d8c <bread>
    80004096:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004098:	000aa583          	lw	a1,0(s5)
    8000409c:	028a2503          	lw	a0,40(s4)
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	cec080e7          	jalr	-788(ra) # 80002d8c <bread>
    800040a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800040aa:	40000613          	li	a2,1024
    800040ae:	05850593          	add	a1,a0,88
    800040b2:	05848513          	add	a0,s1,88
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	ca4080e7          	jalr	-860(ra) # 80000d5a <memmove>
    bwrite(to);  // write the log
    800040be:	8526                	mv	a0,s1
    800040c0:	fffff097          	auipc	ra,0xfffff
    800040c4:	dbe080e7          	jalr	-578(ra) # 80002e7e <bwrite>
    brelse(from);
    800040c8:	854e                	mv	a0,s3
    800040ca:	fffff097          	auipc	ra,0xfffff
    800040ce:	df2080e7          	jalr	-526(ra) # 80002ebc <brelse>
    brelse(to);
    800040d2:	8526                	mv	a0,s1
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	de8080e7          	jalr	-536(ra) # 80002ebc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040dc:	2905                	addw	s2,s2,1
    800040de:	0a91                	add	s5,s5,4
    800040e0:	02ca2783          	lw	a5,44(s4)
    800040e4:	f8f94ee3          	blt	s2,a5,80004080 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800040e8:	00000097          	auipc	ra,0x0
    800040ec:	c8c080e7          	jalr	-884(ra) # 80003d74 <write_head>
    install_trans(0); // Now install writes to home locations
    800040f0:	4501                	li	a0,0
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	cec080e7          	jalr	-788(ra) # 80003dde <install_trans>
    log.lh.n = 0;
    800040fa:	0001d797          	auipc	a5,0x1d
    800040fe:	1607ad23          	sw	zero,378(a5) # 80021274 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004102:	00000097          	auipc	ra,0x0
    80004106:	c72080e7          	jalr	-910(ra) # 80003d74 <write_head>
    8000410a:	bdf5                	j	80004006 <end_op+0x52>

000000008000410c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000410c:	1101                	add	sp,sp,-32
    8000410e:	ec06                	sd	ra,24(sp)
    80004110:	e822                	sd	s0,16(sp)
    80004112:	e426                	sd	s1,8(sp)
    80004114:	e04a                	sd	s2,0(sp)
    80004116:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004118:	0001d717          	auipc	a4,0x1d
    8000411c:	15c72703          	lw	a4,348(a4) # 80021274 <log+0x2c>
    80004120:	47f5                	li	a5,29
    80004122:	08e7c063          	blt	a5,a4,800041a2 <log_write+0x96>
    80004126:	84aa                	mv	s1,a0
    80004128:	0001d797          	auipc	a5,0x1d
    8000412c:	13c7a783          	lw	a5,316(a5) # 80021264 <log+0x1c>
    80004130:	37fd                	addw	a5,a5,-1
    80004132:	06f75863          	bge	a4,a5,800041a2 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004136:	0001d797          	auipc	a5,0x1d
    8000413a:	1327a783          	lw	a5,306(a5) # 80021268 <log+0x20>
    8000413e:	06f05a63          	blez	a5,800041b2 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004142:	0001d917          	auipc	s2,0x1d
    80004146:	10690913          	add	s2,s2,262 # 80021248 <log>
    8000414a:	854a                	mv	a0,s2
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	ab6080e7          	jalr	-1354(ra) # 80000c02 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004154:	02c92603          	lw	a2,44(s2)
    80004158:	06c05563          	blez	a2,800041c2 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000415c:	44cc                	lw	a1,12(s1)
    8000415e:	0001d717          	auipc	a4,0x1d
    80004162:	11a70713          	add	a4,a4,282 # 80021278 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004166:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004168:	4314                	lw	a3,0(a4)
    8000416a:	04b68d63          	beq	a3,a1,800041c4 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000416e:	2785                	addw	a5,a5,1
    80004170:	0711                	add	a4,a4,4
    80004172:	fec79be3          	bne	a5,a2,80004168 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004176:	0621                	add	a2,a2,8
    80004178:	060a                	sll	a2,a2,0x2
    8000417a:	0001d797          	auipc	a5,0x1d
    8000417e:	0ce78793          	add	a5,a5,206 # 80021248 <log>
    80004182:	97b2                	add	a5,a5,a2
    80004184:	44d8                	lw	a4,12(s1)
    80004186:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004188:	8526                	mv	a0,s1
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	dce080e7          	jalr	-562(ra) # 80002f58 <bpin>
    log.lh.n++;
    80004192:	0001d717          	auipc	a4,0x1d
    80004196:	0b670713          	add	a4,a4,182 # 80021248 <log>
    8000419a:	575c                	lw	a5,44(a4)
    8000419c:	2785                	addw	a5,a5,1
    8000419e:	d75c                	sw	a5,44(a4)
    800041a0:	a835                	j	800041dc <log_write+0xd0>
    panic("too big a transaction");
    800041a2:	00004517          	auipc	a0,0x4
    800041a6:	46e50513          	add	a0,a0,1134 # 80008610 <syscalls+0x1f0>
    800041aa:	ffffc097          	auipc	ra,0xffffc
    800041ae:	39e080e7          	jalr	926(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    800041b2:	00004517          	auipc	a0,0x4
    800041b6:	47650513          	add	a0,a0,1142 # 80008628 <syscalls+0x208>
    800041ba:	ffffc097          	auipc	ra,0xffffc
    800041be:	38e080e7          	jalr	910(ra) # 80000548 <panic>
  for (i = 0; i < log.lh.n; i++) {
    800041c2:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800041c4:	00878693          	add	a3,a5,8
    800041c8:	068a                	sll	a3,a3,0x2
    800041ca:	0001d717          	auipc	a4,0x1d
    800041ce:	07e70713          	add	a4,a4,126 # 80021248 <log>
    800041d2:	9736                	add	a4,a4,a3
    800041d4:	44d4                	lw	a3,12(s1)
    800041d6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800041d8:	faf608e3          	beq	a2,a5,80004188 <log_write+0x7c>
  }
  release(&log.lock);
    800041dc:	0001d517          	auipc	a0,0x1d
    800041e0:	06c50513          	add	a0,a0,108 # 80021248 <log>
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	ad2080e7          	jalr	-1326(ra) # 80000cb6 <release>
}
    800041ec:	60e2                	ld	ra,24(sp)
    800041ee:	6442                	ld	s0,16(sp)
    800041f0:	64a2                	ld	s1,8(sp)
    800041f2:	6902                	ld	s2,0(sp)
    800041f4:	6105                	add	sp,sp,32
    800041f6:	8082                	ret

00000000800041f8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800041f8:	1101                	add	sp,sp,-32
    800041fa:	ec06                	sd	ra,24(sp)
    800041fc:	e822                	sd	s0,16(sp)
    800041fe:	e426                	sd	s1,8(sp)
    80004200:	e04a                	sd	s2,0(sp)
    80004202:	1000                	add	s0,sp,32
    80004204:	84aa                	mv	s1,a0
    80004206:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004208:	00004597          	auipc	a1,0x4
    8000420c:	44058593          	add	a1,a1,1088 # 80008648 <syscalls+0x228>
    80004210:	0521                	add	a0,a0,8
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	960080e7          	jalr	-1696(ra) # 80000b72 <initlock>
  lk->name = name;
    8000421a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000421e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004222:	0204a423          	sw	zero,40(s1)
}
    80004226:	60e2                	ld	ra,24(sp)
    80004228:	6442                	ld	s0,16(sp)
    8000422a:	64a2                	ld	s1,8(sp)
    8000422c:	6902                	ld	s2,0(sp)
    8000422e:	6105                	add	sp,sp,32
    80004230:	8082                	ret

0000000080004232 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004232:	1101                	add	sp,sp,-32
    80004234:	ec06                	sd	ra,24(sp)
    80004236:	e822                	sd	s0,16(sp)
    80004238:	e426                	sd	s1,8(sp)
    8000423a:	e04a                	sd	s2,0(sp)
    8000423c:	1000                	add	s0,sp,32
    8000423e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004240:	00850913          	add	s2,a0,8
    80004244:	854a                	mv	a0,s2
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	9bc080e7          	jalr	-1604(ra) # 80000c02 <acquire>
  while (lk->locked) {
    8000424e:	409c                	lw	a5,0(s1)
    80004250:	cb89                	beqz	a5,80004262 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004252:	85ca                	mv	a1,s2
    80004254:	8526                	mv	a0,s1
    80004256:	ffffe097          	auipc	ra,0xffffe
    8000425a:	f1a080e7          	jalr	-230(ra) # 80002170 <sleep>
  while (lk->locked) {
    8000425e:	409c                	lw	a5,0(s1)
    80004260:	fbed                	bnez	a5,80004252 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004262:	4785                	li	a5,1
    80004264:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	6f4080e7          	jalr	1780(ra) # 8000195a <myproc>
    8000426e:	5d1c                	lw	a5,56(a0)
    80004270:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004272:	854a                	mv	a0,s2
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	a42080e7          	jalr	-1470(ra) # 80000cb6 <release>
}
    8000427c:	60e2                	ld	ra,24(sp)
    8000427e:	6442                	ld	s0,16(sp)
    80004280:	64a2                	ld	s1,8(sp)
    80004282:	6902                	ld	s2,0(sp)
    80004284:	6105                	add	sp,sp,32
    80004286:	8082                	ret

0000000080004288 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004288:	1101                	add	sp,sp,-32
    8000428a:	ec06                	sd	ra,24(sp)
    8000428c:	e822                	sd	s0,16(sp)
    8000428e:	e426                	sd	s1,8(sp)
    80004290:	e04a                	sd	s2,0(sp)
    80004292:	1000                	add	s0,sp,32
    80004294:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004296:	00850913          	add	s2,a0,8
    8000429a:	854a                	mv	a0,s2
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	966080e7          	jalr	-1690(ra) # 80000c02 <acquire>
  lk->locked = 0;
    800042a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042a8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800042ac:	8526                	mv	a0,s1
    800042ae:	ffffe097          	auipc	ra,0xffffe
    800042b2:	042080e7          	jalr	66(ra) # 800022f0 <wakeup>
  release(&lk->lk);
    800042b6:	854a                	mv	a0,s2
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	9fe080e7          	jalr	-1538(ra) # 80000cb6 <release>
}
    800042c0:	60e2                	ld	ra,24(sp)
    800042c2:	6442                	ld	s0,16(sp)
    800042c4:	64a2                	ld	s1,8(sp)
    800042c6:	6902                	ld	s2,0(sp)
    800042c8:	6105                	add	sp,sp,32
    800042ca:	8082                	ret

00000000800042cc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800042cc:	7179                	add	sp,sp,-48
    800042ce:	f406                	sd	ra,40(sp)
    800042d0:	f022                	sd	s0,32(sp)
    800042d2:	ec26                	sd	s1,24(sp)
    800042d4:	e84a                	sd	s2,16(sp)
    800042d6:	e44e                	sd	s3,8(sp)
    800042d8:	1800                	add	s0,sp,48
    800042da:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800042dc:	00850913          	add	s2,a0,8
    800042e0:	854a                	mv	a0,s2
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	920080e7          	jalr	-1760(ra) # 80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800042ea:	409c                	lw	a5,0(s1)
    800042ec:	ef99                	bnez	a5,8000430a <holdingsleep+0x3e>
    800042ee:	4481                	li	s1,0
  release(&lk->lk);
    800042f0:	854a                	mv	a0,s2
    800042f2:	ffffd097          	auipc	ra,0xffffd
    800042f6:	9c4080e7          	jalr	-1596(ra) # 80000cb6 <release>
  return r;
}
    800042fa:	8526                	mv	a0,s1
    800042fc:	70a2                	ld	ra,40(sp)
    800042fe:	7402                	ld	s0,32(sp)
    80004300:	64e2                	ld	s1,24(sp)
    80004302:	6942                	ld	s2,16(sp)
    80004304:	69a2                	ld	s3,8(sp)
    80004306:	6145                	add	sp,sp,48
    80004308:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000430a:	0284a983          	lw	s3,40(s1)
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	64c080e7          	jalr	1612(ra) # 8000195a <myproc>
    80004316:	5d04                	lw	s1,56(a0)
    80004318:	413484b3          	sub	s1,s1,s3
    8000431c:	0014b493          	seqz	s1,s1
    80004320:	bfc1                	j	800042f0 <holdingsleep+0x24>

0000000080004322 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004322:	1141                	add	sp,sp,-16
    80004324:	e406                	sd	ra,8(sp)
    80004326:	e022                	sd	s0,0(sp)
    80004328:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000432a:	00004597          	auipc	a1,0x4
    8000432e:	32e58593          	add	a1,a1,814 # 80008658 <syscalls+0x238>
    80004332:	0001d517          	auipc	a0,0x1d
    80004336:	05e50513          	add	a0,a0,94 # 80021390 <ftable>
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	838080e7          	jalr	-1992(ra) # 80000b72 <initlock>
}
    80004342:	60a2                	ld	ra,8(sp)
    80004344:	6402                	ld	s0,0(sp)
    80004346:	0141                	add	sp,sp,16
    80004348:	8082                	ret

000000008000434a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000434a:	1101                	add	sp,sp,-32
    8000434c:	ec06                	sd	ra,24(sp)
    8000434e:	e822                	sd	s0,16(sp)
    80004350:	e426                	sd	s1,8(sp)
    80004352:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004354:	0001d517          	auipc	a0,0x1d
    80004358:	03c50513          	add	a0,a0,60 # 80021390 <ftable>
    8000435c:	ffffd097          	auipc	ra,0xffffd
    80004360:	8a6080e7          	jalr	-1882(ra) # 80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004364:	0001d497          	auipc	s1,0x1d
    80004368:	04448493          	add	s1,s1,68 # 800213a8 <ftable+0x18>
    8000436c:	0001e717          	auipc	a4,0x1e
    80004370:	fdc70713          	add	a4,a4,-36 # 80022348 <ftable+0xfb8>
    if(f->ref == 0){
    80004374:	40dc                	lw	a5,4(s1)
    80004376:	cf99                	beqz	a5,80004394 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004378:	02848493          	add	s1,s1,40
    8000437c:	fee49ce3          	bne	s1,a4,80004374 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004380:	0001d517          	auipc	a0,0x1d
    80004384:	01050513          	add	a0,a0,16 # 80021390 <ftable>
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	92e080e7          	jalr	-1746(ra) # 80000cb6 <release>
  return 0;
    80004390:	4481                	li	s1,0
    80004392:	a819                	j	800043a8 <filealloc+0x5e>
      f->ref = 1;
    80004394:	4785                	li	a5,1
    80004396:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004398:	0001d517          	auipc	a0,0x1d
    8000439c:	ff850513          	add	a0,a0,-8 # 80021390 <ftable>
    800043a0:	ffffd097          	auipc	ra,0xffffd
    800043a4:	916080e7          	jalr	-1770(ra) # 80000cb6 <release>
}
    800043a8:	8526                	mv	a0,s1
    800043aa:	60e2                	ld	ra,24(sp)
    800043ac:	6442                	ld	s0,16(sp)
    800043ae:	64a2                	ld	s1,8(sp)
    800043b0:	6105                	add	sp,sp,32
    800043b2:	8082                	ret

00000000800043b4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800043b4:	1101                	add	sp,sp,-32
    800043b6:	ec06                	sd	ra,24(sp)
    800043b8:	e822                	sd	s0,16(sp)
    800043ba:	e426                	sd	s1,8(sp)
    800043bc:	1000                	add	s0,sp,32
    800043be:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800043c0:	0001d517          	auipc	a0,0x1d
    800043c4:	fd050513          	add	a0,a0,-48 # 80021390 <ftable>
    800043c8:	ffffd097          	auipc	ra,0xffffd
    800043cc:	83a080e7          	jalr	-1990(ra) # 80000c02 <acquire>
  if(f->ref < 1)
    800043d0:	40dc                	lw	a5,4(s1)
    800043d2:	02f05263          	blez	a5,800043f6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800043d6:	2785                	addw	a5,a5,1
    800043d8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800043da:	0001d517          	auipc	a0,0x1d
    800043de:	fb650513          	add	a0,a0,-74 # 80021390 <ftable>
    800043e2:	ffffd097          	auipc	ra,0xffffd
    800043e6:	8d4080e7          	jalr	-1836(ra) # 80000cb6 <release>
  return f;
}
    800043ea:	8526                	mv	a0,s1
    800043ec:	60e2                	ld	ra,24(sp)
    800043ee:	6442                	ld	s0,16(sp)
    800043f0:	64a2                	ld	s1,8(sp)
    800043f2:	6105                	add	sp,sp,32
    800043f4:	8082                	ret
    panic("filedup");
    800043f6:	00004517          	auipc	a0,0x4
    800043fa:	26a50513          	add	a0,a0,618 # 80008660 <syscalls+0x240>
    800043fe:	ffffc097          	auipc	ra,0xffffc
    80004402:	14a080e7          	jalr	330(ra) # 80000548 <panic>

0000000080004406 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004406:	7139                	add	sp,sp,-64
    80004408:	fc06                	sd	ra,56(sp)
    8000440a:	f822                	sd	s0,48(sp)
    8000440c:	f426                	sd	s1,40(sp)
    8000440e:	f04a                	sd	s2,32(sp)
    80004410:	ec4e                	sd	s3,24(sp)
    80004412:	e852                	sd	s4,16(sp)
    80004414:	e456                	sd	s5,8(sp)
    80004416:	0080                	add	s0,sp,64
    80004418:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000441a:	0001d517          	auipc	a0,0x1d
    8000441e:	f7650513          	add	a0,a0,-138 # 80021390 <ftable>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	7e0080e7          	jalr	2016(ra) # 80000c02 <acquire>
  if(f->ref < 1)
    8000442a:	40dc                	lw	a5,4(s1)
    8000442c:	06f05163          	blez	a5,8000448e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004430:	37fd                	addw	a5,a5,-1
    80004432:	0007871b          	sext.w	a4,a5
    80004436:	c0dc                	sw	a5,4(s1)
    80004438:	06e04363          	bgtz	a4,8000449e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000443c:	0004a903          	lw	s2,0(s1)
    80004440:	0094ca83          	lbu	s5,9(s1)
    80004444:	0104ba03          	ld	s4,16(s1)
    80004448:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000444c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004450:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004454:	0001d517          	auipc	a0,0x1d
    80004458:	f3c50513          	add	a0,a0,-196 # 80021390 <ftable>
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	85a080e7          	jalr	-1958(ra) # 80000cb6 <release>

  if(ff.type == FD_PIPE){
    80004464:	4785                	li	a5,1
    80004466:	04f90d63          	beq	s2,a5,800044c0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000446a:	3979                	addw	s2,s2,-2
    8000446c:	4785                	li	a5,1
    8000446e:	0527e063          	bltu	a5,s2,800044ae <fileclose+0xa8>
    begin_op();
    80004472:	00000097          	auipc	ra,0x0
    80004476:	ac8080e7          	jalr	-1336(ra) # 80003f3a <begin_op>
    iput(ff.ip);
    8000447a:	854e                	mv	a0,s3
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	2c4080e7          	jalr	708(ra) # 80003740 <iput>
    end_op();
    80004484:	00000097          	auipc	ra,0x0
    80004488:	b30080e7          	jalr	-1232(ra) # 80003fb4 <end_op>
    8000448c:	a00d                	j	800044ae <fileclose+0xa8>
    panic("fileclose");
    8000448e:	00004517          	auipc	a0,0x4
    80004492:	1da50513          	add	a0,a0,474 # 80008668 <syscalls+0x248>
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	0b2080e7          	jalr	178(ra) # 80000548 <panic>
    release(&ftable.lock);
    8000449e:	0001d517          	auipc	a0,0x1d
    800044a2:	ef250513          	add	a0,a0,-270 # 80021390 <ftable>
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	810080e7          	jalr	-2032(ra) # 80000cb6 <release>
  }
}
    800044ae:	70e2                	ld	ra,56(sp)
    800044b0:	7442                	ld	s0,48(sp)
    800044b2:	74a2                	ld	s1,40(sp)
    800044b4:	7902                	ld	s2,32(sp)
    800044b6:	69e2                	ld	s3,24(sp)
    800044b8:	6a42                	ld	s4,16(sp)
    800044ba:	6aa2                	ld	s5,8(sp)
    800044bc:	6121                	add	sp,sp,64
    800044be:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800044c0:	85d6                	mv	a1,s5
    800044c2:	8552                	mv	a0,s4
    800044c4:	00000097          	auipc	ra,0x0
    800044c8:	372080e7          	jalr	882(ra) # 80004836 <pipeclose>
    800044cc:	b7cd                	j	800044ae <fileclose+0xa8>

00000000800044ce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800044ce:	715d                	add	sp,sp,-80
    800044d0:	e486                	sd	ra,72(sp)
    800044d2:	e0a2                	sd	s0,64(sp)
    800044d4:	fc26                	sd	s1,56(sp)
    800044d6:	f84a                	sd	s2,48(sp)
    800044d8:	f44e                	sd	s3,40(sp)
    800044da:	0880                	add	s0,sp,80
    800044dc:	84aa                	mv	s1,a0
    800044de:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800044e0:	ffffd097          	auipc	ra,0xffffd
    800044e4:	47a080e7          	jalr	1146(ra) # 8000195a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800044e8:	409c                	lw	a5,0(s1)
    800044ea:	37f9                	addw	a5,a5,-2
    800044ec:	4705                	li	a4,1
    800044ee:	04f76763          	bltu	a4,a5,8000453c <filestat+0x6e>
    800044f2:	892a                	mv	s2,a0
    ilock(f->ip);
    800044f4:	6c88                	ld	a0,24(s1)
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	090080e7          	jalr	144(ra) # 80003586 <ilock>
    stati(f->ip, &st);
    800044fe:	fb840593          	add	a1,s0,-72
    80004502:	6c88                	ld	a0,24(s1)
    80004504:	fffff097          	auipc	ra,0xfffff
    80004508:	30c080e7          	jalr	780(ra) # 80003810 <stati>
    iunlock(f->ip);
    8000450c:	6c88                	ld	a0,24(s1)
    8000450e:	fffff097          	auipc	ra,0xfffff
    80004512:	13a080e7          	jalr	314(ra) # 80003648 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004516:	46e1                	li	a3,24
    80004518:	fb840613          	add	a2,s0,-72
    8000451c:	85ce                	mv	a1,s3
    8000451e:	05093503          	ld	a0,80(s2)
    80004522:	ffffd097          	auipc	ra,0xffffd
    80004526:	12e080e7          	jalr	302(ra) # 80001650 <copyout>
    8000452a:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000452e:	60a6                	ld	ra,72(sp)
    80004530:	6406                	ld	s0,64(sp)
    80004532:	74e2                	ld	s1,56(sp)
    80004534:	7942                	ld	s2,48(sp)
    80004536:	79a2                	ld	s3,40(sp)
    80004538:	6161                	add	sp,sp,80
    8000453a:	8082                	ret
  return -1;
    8000453c:	557d                	li	a0,-1
    8000453e:	bfc5                	j	8000452e <filestat+0x60>

0000000080004540 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004540:	7179                	add	sp,sp,-48
    80004542:	f406                	sd	ra,40(sp)
    80004544:	f022                	sd	s0,32(sp)
    80004546:	ec26                	sd	s1,24(sp)
    80004548:	e84a                	sd	s2,16(sp)
    8000454a:	e44e                	sd	s3,8(sp)
    8000454c:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000454e:	00854783          	lbu	a5,8(a0)
    80004552:	c3d5                	beqz	a5,800045f6 <fileread+0xb6>
    80004554:	84aa                	mv	s1,a0
    80004556:	89ae                	mv	s3,a1
    80004558:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000455a:	411c                	lw	a5,0(a0)
    8000455c:	4705                	li	a4,1
    8000455e:	04e78963          	beq	a5,a4,800045b0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004562:	470d                	li	a4,3
    80004564:	04e78d63          	beq	a5,a4,800045be <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004568:	4709                	li	a4,2
    8000456a:	06e79e63          	bne	a5,a4,800045e6 <fileread+0xa6>
    ilock(f->ip);
    8000456e:	6d08                	ld	a0,24(a0)
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	016080e7          	jalr	22(ra) # 80003586 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004578:	874a                	mv	a4,s2
    8000457a:	5094                	lw	a3,32(s1)
    8000457c:	864e                	mv	a2,s3
    8000457e:	4585                	li	a1,1
    80004580:	6c88                	ld	a0,24(s1)
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	2b8080e7          	jalr	696(ra) # 8000383a <readi>
    8000458a:	892a                	mv	s2,a0
    8000458c:	00a05563          	blez	a0,80004596 <fileread+0x56>
      f->off += r;
    80004590:	509c                	lw	a5,32(s1)
    80004592:	9fa9                	addw	a5,a5,a0
    80004594:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004596:	6c88                	ld	a0,24(s1)
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	0b0080e7          	jalr	176(ra) # 80003648 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800045a0:	854a                	mv	a0,s2
    800045a2:	70a2                	ld	ra,40(sp)
    800045a4:	7402                	ld	s0,32(sp)
    800045a6:	64e2                	ld	s1,24(sp)
    800045a8:	6942                	ld	s2,16(sp)
    800045aa:	69a2                	ld	s3,8(sp)
    800045ac:	6145                	add	sp,sp,48
    800045ae:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800045b0:	6908                	ld	a0,16(a0)
    800045b2:	00000097          	auipc	ra,0x0
    800045b6:	3ee080e7          	jalr	1006(ra) # 800049a0 <piperead>
    800045ba:	892a                	mv	s2,a0
    800045bc:	b7d5                	j	800045a0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800045be:	02451783          	lh	a5,36(a0)
    800045c2:	03079693          	sll	a3,a5,0x30
    800045c6:	92c1                	srl	a3,a3,0x30
    800045c8:	4725                	li	a4,9
    800045ca:	02d76863          	bltu	a4,a3,800045fa <fileread+0xba>
    800045ce:	0792                	sll	a5,a5,0x4
    800045d0:	0001d717          	auipc	a4,0x1d
    800045d4:	d2070713          	add	a4,a4,-736 # 800212f0 <devsw>
    800045d8:	97ba                	add	a5,a5,a4
    800045da:	639c                	ld	a5,0(a5)
    800045dc:	c38d                	beqz	a5,800045fe <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800045de:	4505                	li	a0,1
    800045e0:	9782                	jalr	a5
    800045e2:	892a                	mv	s2,a0
    800045e4:	bf75                	j	800045a0 <fileread+0x60>
    panic("fileread");
    800045e6:	00004517          	auipc	a0,0x4
    800045ea:	09250513          	add	a0,a0,146 # 80008678 <syscalls+0x258>
    800045ee:	ffffc097          	auipc	ra,0xffffc
    800045f2:	f5a080e7          	jalr	-166(ra) # 80000548 <panic>
    return -1;
    800045f6:	597d                	li	s2,-1
    800045f8:	b765                	j	800045a0 <fileread+0x60>
      return -1;
    800045fa:	597d                	li	s2,-1
    800045fc:	b755                	j	800045a0 <fileread+0x60>
    800045fe:	597d                	li	s2,-1
    80004600:	b745                	j	800045a0 <fileread+0x60>

0000000080004602 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004602:	00954783          	lbu	a5,9(a0)
    80004606:	14078363          	beqz	a5,8000474c <filewrite+0x14a>
{
    8000460a:	715d                	add	sp,sp,-80
    8000460c:	e486                	sd	ra,72(sp)
    8000460e:	e0a2                	sd	s0,64(sp)
    80004610:	fc26                	sd	s1,56(sp)
    80004612:	f84a                	sd	s2,48(sp)
    80004614:	f44e                	sd	s3,40(sp)
    80004616:	f052                	sd	s4,32(sp)
    80004618:	ec56                	sd	s5,24(sp)
    8000461a:	e85a                	sd	s6,16(sp)
    8000461c:	e45e                	sd	s7,8(sp)
    8000461e:	e062                	sd	s8,0(sp)
    80004620:	0880                	add	s0,sp,80
    80004622:	892a                	mv	s2,a0
    80004624:	8b2e                	mv	s6,a1
    80004626:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004628:	411c                	lw	a5,0(a0)
    8000462a:	4705                	li	a4,1
    8000462c:	02e78263          	beq	a5,a4,80004650 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004630:	470d                	li	a4,3
    80004632:	02e78563          	beq	a5,a4,8000465c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004636:	4709                	li	a4,2
    80004638:	10e79263          	bne	a5,a4,8000473c <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000463c:	0ec05e63          	blez	a2,80004738 <filewrite+0x136>
    int i = 0;
    80004640:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004642:	6b85                	lui	s7,0x1
    80004644:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004648:	6c05                	lui	s8,0x1
    8000464a:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000464e:	a851                	j	800046e2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004650:	6908                	ld	a0,16(a0)
    80004652:	00000097          	auipc	ra,0x0
    80004656:	254080e7          	jalr	596(ra) # 800048a6 <pipewrite>
    8000465a:	a85d                	j	80004710 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000465c:	02451783          	lh	a5,36(a0)
    80004660:	03079693          	sll	a3,a5,0x30
    80004664:	92c1                	srl	a3,a3,0x30
    80004666:	4725                	li	a4,9
    80004668:	0ed76463          	bltu	a4,a3,80004750 <filewrite+0x14e>
    8000466c:	0792                	sll	a5,a5,0x4
    8000466e:	0001d717          	auipc	a4,0x1d
    80004672:	c8270713          	add	a4,a4,-894 # 800212f0 <devsw>
    80004676:	97ba                	add	a5,a5,a4
    80004678:	679c                	ld	a5,8(a5)
    8000467a:	cfe9                	beqz	a5,80004754 <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    8000467c:	4505                	li	a0,1
    8000467e:	9782                	jalr	a5
    80004680:	a841                	j	80004710 <filewrite+0x10e>
      if(n1 > max)
    80004682:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	8b4080e7          	jalr	-1868(ra) # 80003f3a <begin_op>
      ilock(f->ip);
    8000468e:	01893503          	ld	a0,24(s2)
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	ef4080e7          	jalr	-268(ra) # 80003586 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000469a:	8756                	mv	a4,s5
    8000469c:	02092683          	lw	a3,32(s2)
    800046a0:	01698633          	add	a2,s3,s6
    800046a4:	4585                	li	a1,1
    800046a6:	01893503          	ld	a0,24(s2)
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	288080e7          	jalr	648(ra) # 80003932 <writei>
    800046b2:	84aa                	mv	s1,a0
    800046b4:	02a05f63          	blez	a0,800046f2 <filewrite+0xf0>
        f->off += r;
    800046b8:	02092783          	lw	a5,32(s2)
    800046bc:	9fa9                	addw	a5,a5,a0
    800046be:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800046c2:	01893503          	ld	a0,24(s2)
    800046c6:	fffff097          	auipc	ra,0xfffff
    800046ca:	f82080e7          	jalr	-126(ra) # 80003648 <iunlock>
      end_op();
    800046ce:	00000097          	auipc	ra,0x0
    800046d2:	8e6080e7          	jalr	-1818(ra) # 80003fb4 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800046d6:	049a9963          	bne	s5,s1,80004728 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800046da:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800046de:	0349d663          	bge	s3,s4,8000470a <filewrite+0x108>
      int n1 = n - i;
    800046e2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800046e6:	0004879b          	sext.w	a5,s1
    800046ea:	f8fbdce3          	bge	s7,a5,80004682 <filewrite+0x80>
    800046ee:	84e2                	mv	s1,s8
    800046f0:	bf49                	j	80004682 <filewrite+0x80>
      iunlock(f->ip);
    800046f2:	01893503          	ld	a0,24(s2)
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	f52080e7          	jalr	-174(ra) # 80003648 <iunlock>
      end_op();
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	8b6080e7          	jalr	-1866(ra) # 80003fb4 <end_op>
      if(r < 0)
    80004706:	fc04d8e3          	bgez	s1,800046d6 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    8000470a:	053a1763          	bne	s4,s3,80004758 <filewrite+0x156>
    8000470e:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004710:	60a6                	ld	ra,72(sp)
    80004712:	6406                	ld	s0,64(sp)
    80004714:	74e2                	ld	s1,56(sp)
    80004716:	7942                	ld	s2,48(sp)
    80004718:	79a2                	ld	s3,40(sp)
    8000471a:	7a02                	ld	s4,32(sp)
    8000471c:	6ae2                	ld	s5,24(sp)
    8000471e:	6b42                	ld	s6,16(sp)
    80004720:	6ba2                	ld	s7,8(sp)
    80004722:	6c02                	ld	s8,0(sp)
    80004724:	6161                	add	sp,sp,80
    80004726:	8082                	ret
        panic("short filewrite");
    80004728:	00004517          	auipc	a0,0x4
    8000472c:	f6050513          	add	a0,a0,-160 # 80008688 <syscalls+0x268>
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	e18080e7          	jalr	-488(ra) # 80000548 <panic>
    int i = 0;
    80004738:	4981                	li	s3,0
    8000473a:	bfc1                	j	8000470a <filewrite+0x108>
    panic("filewrite");
    8000473c:	00004517          	auipc	a0,0x4
    80004740:	f5c50513          	add	a0,a0,-164 # 80008698 <syscalls+0x278>
    80004744:	ffffc097          	auipc	ra,0xffffc
    80004748:	e04080e7          	jalr	-508(ra) # 80000548 <panic>
    return -1;
    8000474c:	557d                	li	a0,-1
}
    8000474e:	8082                	ret
      return -1;
    80004750:	557d                	li	a0,-1
    80004752:	bf7d                	j	80004710 <filewrite+0x10e>
    80004754:	557d                	li	a0,-1
    80004756:	bf6d                	j	80004710 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004758:	557d                	li	a0,-1
    8000475a:	bf5d                	j	80004710 <filewrite+0x10e>

000000008000475c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000475c:	7179                	add	sp,sp,-48
    8000475e:	f406                	sd	ra,40(sp)
    80004760:	f022                	sd	s0,32(sp)
    80004762:	ec26                	sd	s1,24(sp)
    80004764:	e84a                	sd	s2,16(sp)
    80004766:	e44e                	sd	s3,8(sp)
    80004768:	e052                	sd	s4,0(sp)
    8000476a:	1800                	add	s0,sp,48
    8000476c:	84aa                	mv	s1,a0
    8000476e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004770:	0005b023          	sd	zero,0(a1)
    80004774:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	bd2080e7          	jalr	-1070(ra) # 8000434a <filealloc>
    80004780:	e088                	sd	a0,0(s1)
    80004782:	c551                	beqz	a0,8000480e <pipealloc+0xb2>
    80004784:	00000097          	auipc	ra,0x0
    80004788:	bc6080e7          	jalr	-1082(ra) # 8000434a <filealloc>
    8000478c:	00aa3023          	sd	a0,0(s4)
    80004790:	c92d                	beqz	a0,80004802 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004792:	ffffc097          	auipc	ra,0xffffc
    80004796:	380080e7          	jalr	896(ra) # 80000b12 <kalloc>
    8000479a:	892a                	mv	s2,a0
    8000479c:	c125                	beqz	a0,800047fc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000479e:	4985                	li	s3,1
    800047a0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047a4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047a8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800047ac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800047b0:	00004597          	auipc	a1,0x4
    800047b4:	ef858593          	add	a1,a1,-264 # 800086a8 <syscalls+0x288>
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	3ba080e7          	jalr	954(ra) # 80000b72 <initlock>
  (*f0)->type = FD_PIPE;
    800047c0:	609c                	ld	a5,0(s1)
    800047c2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800047c6:	609c                	ld	a5,0(s1)
    800047c8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800047cc:	609c                	ld	a5,0(s1)
    800047ce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800047d2:	609c                	ld	a5,0(s1)
    800047d4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800047d8:	000a3783          	ld	a5,0(s4)
    800047dc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800047e0:	000a3783          	ld	a5,0(s4)
    800047e4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800047e8:	000a3783          	ld	a5,0(s4)
    800047ec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800047f0:	000a3783          	ld	a5,0(s4)
    800047f4:	0127b823          	sd	s2,16(a5)
  return 0;
    800047f8:	4501                	li	a0,0
    800047fa:	a025                	j	80004822 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800047fc:	6088                	ld	a0,0(s1)
    800047fe:	e501                	bnez	a0,80004806 <pipealloc+0xaa>
    80004800:	a039                	j	8000480e <pipealloc+0xb2>
    80004802:	6088                	ld	a0,0(s1)
    80004804:	c51d                	beqz	a0,80004832 <pipealloc+0xd6>
    fileclose(*f0);
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	c00080e7          	jalr	-1024(ra) # 80004406 <fileclose>
  if(*f1)
    8000480e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004812:	557d                	li	a0,-1
  if(*f1)
    80004814:	c799                	beqz	a5,80004822 <pipealloc+0xc6>
    fileclose(*f1);
    80004816:	853e                	mv	a0,a5
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	bee080e7          	jalr	-1042(ra) # 80004406 <fileclose>
  return -1;
    80004820:	557d                	li	a0,-1
}
    80004822:	70a2                	ld	ra,40(sp)
    80004824:	7402                	ld	s0,32(sp)
    80004826:	64e2                	ld	s1,24(sp)
    80004828:	6942                	ld	s2,16(sp)
    8000482a:	69a2                	ld	s3,8(sp)
    8000482c:	6a02                	ld	s4,0(sp)
    8000482e:	6145                	add	sp,sp,48
    80004830:	8082                	ret
  return -1;
    80004832:	557d                	li	a0,-1
    80004834:	b7fd                	j	80004822 <pipealloc+0xc6>

0000000080004836 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004836:	1101                	add	sp,sp,-32
    80004838:	ec06                	sd	ra,24(sp)
    8000483a:	e822                	sd	s0,16(sp)
    8000483c:	e426                	sd	s1,8(sp)
    8000483e:	e04a                	sd	s2,0(sp)
    80004840:	1000                	add	s0,sp,32
    80004842:	84aa                	mv	s1,a0
    80004844:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	3bc080e7          	jalr	956(ra) # 80000c02 <acquire>
  if(writable){
    8000484e:	02090d63          	beqz	s2,80004888 <pipeclose+0x52>
    pi->writeopen = 0;
    80004852:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004856:	21848513          	add	a0,s1,536
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	a96080e7          	jalr	-1386(ra) # 800022f0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004862:	2204b783          	ld	a5,544(s1)
    80004866:	eb95                	bnez	a5,8000489a <pipeclose+0x64>
    release(&pi->lock);
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	44c080e7          	jalr	1100(ra) # 80000cb6 <release>
    kfree((char*)pi);
    80004872:	8526                	mv	a0,s1
    80004874:	ffffc097          	auipc	ra,0xffffc
    80004878:	1a0080e7          	jalr	416(ra) # 80000a14 <kfree>
  } else
    release(&pi->lock);
}
    8000487c:	60e2                	ld	ra,24(sp)
    8000487e:	6442                	ld	s0,16(sp)
    80004880:	64a2                	ld	s1,8(sp)
    80004882:	6902                	ld	s2,0(sp)
    80004884:	6105                	add	sp,sp,32
    80004886:	8082                	ret
    pi->readopen = 0;
    80004888:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000488c:	21c48513          	add	a0,s1,540
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	a60080e7          	jalr	-1440(ra) # 800022f0 <wakeup>
    80004898:	b7e9                	j	80004862 <pipeclose+0x2c>
    release(&pi->lock);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	41a080e7          	jalr	1050(ra) # 80000cb6 <release>
}
    800048a4:	bfe1                	j	8000487c <pipeclose+0x46>

00000000800048a6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800048a6:	711d                	add	sp,sp,-96
    800048a8:	ec86                	sd	ra,88(sp)
    800048aa:	e8a2                	sd	s0,80(sp)
    800048ac:	e4a6                	sd	s1,72(sp)
    800048ae:	e0ca                	sd	s2,64(sp)
    800048b0:	fc4e                	sd	s3,56(sp)
    800048b2:	f852                	sd	s4,48(sp)
    800048b4:	f456                	sd	s5,40(sp)
    800048b6:	f05a                	sd	s6,32(sp)
    800048b8:	ec5e                	sd	s7,24(sp)
    800048ba:	1080                	add	s0,sp,96
    800048bc:	84aa                	mv	s1,a0
    800048be:	8b2e                	mv	s6,a1
    800048c0:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    800048c2:	ffffd097          	auipc	ra,0xffffd
    800048c6:	098080e7          	jalr	152(ra) # 8000195a <myproc>
    800048ca:	892a                	mv	s2,a0

  acquire(&pi->lock);
    800048cc:	8526                	mv	a0,s1
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	334080e7          	jalr	820(ra) # 80000c02 <acquire>
  for(i = 0; i < n; i++){
    800048d6:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    800048d8:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800048dc:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    800048e0:	09505263          	blez	s5,80004964 <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800048e4:	2184a783          	lw	a5,536(s1)
    800048e8:	21c4a703          	lw	a4,540(s1)
    800048ec:	2007879b          	addw	a5,a5,512
    800048f0:	02f71b63          	bne	a4,a5,80004926 <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    800048f4:	2204a783          	lw	a5,544(s1)
    800048f8:	c3d1                	beqz	a5,8000497c <pipewrite+0xd6>
    800048fa:	03092783          	lw	a5,48(s2)
    800048fe:	efbd                	bnez	a5,8000497c <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004900:	8552                	mv	a0,s4
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	9ee080e7          	jalr	-1554(ra) # 800022f0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000490a:	85a6                	mv	a1,s1
    8000490c:	854e                	mv	a0,s3
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	862080e7          	jalr	-1950(ra) # 80002170 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004916:	2184a783          	lw	a5,536(s1)
    8000491a:	21c4a703          	lw	a4,540(s1)
    8000491e:	2007879b          	addw	a5,a5,512
    80004922:	fcf709e3          	beq	a4,a5,800048f4 <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004926:	4685                	li	a3,1
    80004928:	865a                	mv	a2,s6
    8000492a:	faf40593          	add	a1,s0,-81
    8000492e:	05093503          	ld	a0,80(s2)
    80004932:	ffffd097          	auipc	ra,0xffffd
    80004936:	daa080e7          	jalr	-598(ra) # 800016dc <copyin>
    8000493a:	57fd                	li	a5,-1
    8000493c:	02f50463          	beq	a0,a5,80004964 <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004940:	21c4a783          	lw	a5,540(s1)
    80004944:	0017871b          	addw	a4,a5,1
    80004948:	20e4ae23          	sw	a4,540(s1)
    8000494c:	1ff7f793          	and	a5,a5,511
    80004950:	97a6                	add	a5,a5,s1
    80004952:	faf44703          	lbu	a4,-81(s0)
    80004956:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    8000495a:	2b85                	addw	s7,s7,1
    8000495c:	0b05                	add	s6,s6,1
    8000495e:	f97a93e3          	bne	s5,s7,800048e4 <pipewrite+0x3e>
    80004962:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    80004964:	21848513          	add	a0,s1,536
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	988080e7          	jalr	-1656(ra) # 800022f0 <wakeup>
  release(&pi->lock);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffc097          	auipc	ra,0xffffc
    80004976:	344080e7          	jalr	836(ra) # 80000cb6 <release>
  return i;
    8000497a:	a039                	j	80004988 <pipewrite+0xe2>
        release(&pi->lock);
    8000497c:	8526                	mv	a0,s1
    8000497e:	ffffc097          	auipc	ra,0xffffc
    80004982:	338080e7          	jalr	824(ra) # 80000cb6 <release>
        return -1;
    80004986:	5bfd                	li	s7,-1
}
    80004988:	855e                	mv	a0,s7
    8000498a:	60e6                	ld	ra,88(sp)
    8000498c:	6446                	ld	s0,80(sp)
    8000498e:	64a6                	ld	s1,72(sp)
    80004990:	6906                	ld	s2,64(sp)
    80004992:	79e2                	ld	s3,56(sp)
    80004994:	7a42                	ld	s4,48(sp)
    80004996:	7aa2                	ld	s5,40(sp)
    80004998:	7b02                	ld	s6,32(sp)
    8000499a:	6be2                	ld	s7,24(sp)
    8000499c:	6125                	add	sp,sp,96
    8000499e:	8082                	ret

00000000800049a0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049a0:	715d                	add	sp,sp,-80
    800049a2:	e486                	sd	ra,72(sp)
    800049a4:	e0a2                	sd	s0,64(sp)
    800049a6:	fc26                	sd	s1,56(sp)
    800049a8:	f84a                	sd	s2,48(sp)
    800049aa:	f44e                	sd	s3,40(sp)
    800049ac:	f052                	sd	s4,32(sp)
    800049ae:	ec56                	sd	s5,24(sp)
    800049b0:	e85a                	sd	s6,16(sp)
    800049b2:	0880                	add	s0,sp,80
    800049b4:	84aa                	mv	s1,a0
    800049b6:	892e                	mv	s2,a1
    800049b8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800049ba:	ffffd097          	auipc	ra,0xffffd
    800049be:	fa0080e7          	jalr	-96(ra) # 8000195a <myproc>
    800049c2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	23c080e7          	jalr	572(ra) # 80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049ce:	2184a703          	lw	a4,536(s1)
    800049d2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049d6:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049da:	02f71463          	bne	a4,a5,80004a02 <piperead+0x62>
    800049de:	2244a783          	lw	a5,548(s1)
    800049e2:	c385                	beqz	a5,80004a02 <piperead+0x62>
    if(pr->killed){
    800049e4:	030a2783          	lw	a5,48(s4)
    800049e8:	ebc9                	bnez	a5,80004a7a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049ea:	85a6                	mv	a1,s1
    800049ec:	854e                	mv	a0,s3
    800049ee:	ffffd097          	auipc	ra,0xffffd
    800049f2:	782080e7          	jalr	1922(ra) # 80002170 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049f6:	2184a703          	lw	a4,536(s1)
    800049fa:	21c4a783          	lw	a5,540(s1)
    800049fe:	fef700e3          	beq	a4,a5,800049de <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a02:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a04:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a06:	05505463          	blez	s5,80004a4e <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004a0a:	2184a783          	lw	a5,536(s1)
    80004a0e:	21c4a703          	lw	a4,540(s1)
    80004a12:	02f70e63          	beq	a4,a5,80004a4e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a16:	0017871b          	addw	a4,a5,1
    80004a1a:	20e4ac23          	sw	a4,536(s1)
    80004a1e:	1ff7f793          	and	a5,a5,511
    80004a22:	97a6                	add	a5,a5,s1
    80004a24:	0187c783          	lbu	a5,24(a5)
    80004a28:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a2c:	4685                	li	a3,1
    80004a2e:	fbf40613          	add	a2,s0,-65
    80004a32:	85ca                	mv	a1,s2
    80004a34:	050a3503          	ld	a0,80(s4)
    80004a38:	ffffd097          	auipc	ra,0xffffd
    80004a3c:	c18080e7          	jalr	-1000(ra) # 80001650 <copyout>
    80004a40:	01650763          	beq	a0,s6,80004a4e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a44:	2985                	addw	s3,s3,1
    80004a46:	0905                	add	s2,s2,1
    80004a48:	fd3a91e3          	bne	s5,s3,80004a0a <piperead+0x6a>
    80004a4c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a4e:	21c48513          	add	a0,s1,540
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	89e080e7          	jalr	-1890(ra) # 800022f0 <wakeup>
  release(&pi->lock);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffc097          	auipc	ra,0xffffc
    80004a60:	25a080e7          	jalr	602(ra) # 80000cb6 <release>
  return i;
}
    80004a64:	854e                	mv	a0,s3
    80004a66:	60a6                	ld	ra,72(sp)
    80004a68:	6406                	ld	s0,64(sp)
    80004a6a:	74e2                	ld	s1,56(sp)
    80004a6c:	7942                	ld	s2,48(sp)
    80004a6e:	79a2                	ld	s3,40(sp)
    80004a70:	7a02                	ld	s4,32(sp)
    80004a72:	6ae2                	ld	s5,24(sp)
    80004a74:	6b42                	ld	s6,16(sp)
    80004a76:	6161                	add	sp,sp,80
    80004a78:	8082                	ret
      release(&pi->lock);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	23a080e7          	jalr	570(ra) # 80000cb6 <release>
      return -1;
    80004a84:	59fd                	li	s3,-1
    80004a86:	bff9                	j	80004a64 <piperead+0xc4>

0000000080004a88 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004a88:	df010113          	add	sp,sp,-528
    80004a8c:	20113423          	sd	ra,520(sp)
    80004a90:	20813023          	sd	s0,512(sp)
    80004a94:	ffa6                	sd	s1,504(sp)
    80004a96:	fbca                	sd	s2,496(sp)
    80004a98:	f7ce                	sd	s3,488(sp)
    80004a9a:	f3d2                	sd	s4,480(sp)
    80004a9c:	efd6                	sd	s5,472(sp)
    80004a9e:	ebda                	sd	s6,464(sp)
    80004aa0:	e7de                	sd	s7,456(sp)
    80004aa2:	e3e2                	sd	s8,448(sp)
    80004aa4:	ff66                	sd	s9,440(sp)
    80004aa6:	fb6a                	sd	s10,432(sp)
    80004aa8:	f76e                	sd	s11,424(sp)
    80004aaa:	0c00                	add	s0,sp,528
    80004aac:	892a                	mv	s2,a0
    80004aae:	dea43c23          	sd	a0,-520(s0)
    80004ab2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	ea4080e7          	jalr	-348(ra) # 8000195a <myproc>
    80004abe:	84aa                	mv	s1,a0

  begin_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	47a080e7          	jalr	1146(ra) # 80003f3a <begin_op>

  if((ip = namei(path)) == 0){
    80004ac8:	854a                	mv	a0,s2
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	270080e7          	jalr	624(ra) # 80003d3a <namei>
    80004ad2:	c92d                	beqz	a0,80004b44 <exec+0xbc>
    80004ad4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	ab0080e7          	jalr	-1360(ra) # 80003586 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ade:	04000713          	li	a4,64
    80004ae2:	4681                	li	a3,0
    80004ae4:	e4840613          	add	a2,s0,-440
    80004ae8:	4581                	li	a1,0
    80004aea:	8552                	mv	a0,s4
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	d4e080e7          	jalr	-690(ra) # 8000383a <readi>
    80004af4:	04000793          	li	a5,64
    80004af8:	00f51a63          	bne	a0,a5,80004b0c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004afc:	e4842703          	lw	a4,-440(s0)
    80004b00:	464c47b7          	lui	a5,0x464c4
    80004b04:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b08:	04f70463          	beq	a4,a5,80004b50 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b0c:	8552                	mv	a0,s4
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	cda080e7          	jalr	-806(ra) # 800037e8 <iunlockput>
    end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	49e080e7          	jalr	1182(ra) # 80003fb4 <end_op>
  }
  return -1;
    80004b1e:	557d                	li	a0,-1
}
    80004b20:	20813083          	ld	ra,520(sp)
    80004b24:	20013403          	ld	s0,512(sp)
    80004b28:	74fe                	ld	s1,504(sp)
    80004b2a:	795e                	ld	s2,496(sp)
    80004b2c:	79be                	ld	s3,488(sp)
    80004b2e:	7a1e                	ld	s4,480(sp)
    80004b30:	6afe                	ld	s5,472(sp)
    80004b32:	6b5e                	ld	s6,464(sp)
    80004b34:	6bbe                	ld	s7,456(sp)
    80004b36:	6c1e                	ld	s8,448(sp)
    80004b38:	7cfa                	ld	s9,440(sp)
    80004b3a:	7d5a                	ld	s10,432(sp)
    80004b3c:	7dba                	ld	s11,424(sp)
    80004b3e:	21010113          	add	sp,sp,528
    80004b42:	8082                	ret
    end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	470080e7          	jalr	1136(ra) # 80003fb4 <end_op>
    return -1;
    80004b4c:	557d                	li	a0,-1
    80004b4e:	bfc9                	j	80004b20 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004b50:	8526                	mv	a0,s1
    80004b52:	ffffd097          	auipc	ra,0xffffd
    80004b56:	ecc080e7          	jalr	-308(ra) # 80001a1e <proc_pagetable>
    80004b5a:	8b2a                	mv	s6,a0
    80004b5c:	d945                	beqz	a0,80004b0c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b5e:	e6842d03          	lw	s10,-408(s0)
    80004b62:	e8045783          	lhu	a5,-384(s0)
    80004b66:	cfe5                	beqz	a5,80004c5e <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004b68:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b6a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004b6c:	6c85                	lui	s9,0x1
    80004b6e:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b72:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004b76:	6a85                	lui	s5,0x1
    80004b78:	a0b5                	j	80004be4 <exec+0x15c>
      panic("loadseg: address should exist");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	b3650513          	add	a0,a0,-1226 # 800086b0 <syscalls+0x290>
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	9c6080e7          	jalr	-1594(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
    80004b8a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004b8c:	8726                	mv	a4,s1
    80004b8e:	012c06bb          	addw	a3,s8,s2
    80004b92:	4581                	li	a1,0
    80004b94:	8552                	mv	a0,s4
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	ca4080e7          	jalr	-860(ra) # 8000383a <readi>
    80004b9e:	2501                	sext.w	a0,a0
    80004ba0:	24a49063          	bne	s1,a0,80004de0 <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004ba4:	012a893b          	addw	s2,s5,s2
    80004ba8:	03397563          	bgeu	s2,s3,80004bd2 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004bac:	02091593          	sll	a1,s2,0x20
    80004bb0:	9181                	srl	a1,a1,0x20
    80004bb2:	95de                	add	a1,a1,s7
    80004bb4:	855a                	mv	a0,s6
    80004bb6:	ffffc097          	auipc	ra,0xffffc
    80004bba:	4d4080e7          	jalr	1236(ra) # 8000108a <walkaddr>
    80004bbe:	862a                	mv	a2,a0
    if(pa == 0)
    80004bc0:	dd4d                	beqz	a0,80004b7a <exec+0xf2>
    if(sz - i < PGSIZE)
    80004bc2:	412984bb          	subw	s1,s3,s2
    80004bc6:	0004879b          	sext.w	a5,s1
    80004bca:	fcfcf0e3          	bgeu	s9,a5,80004b8a <exec+0x102>
    80004bce:	84d6                	mv	s1,s5
    80004bd0:	bf6d                	j	80004b8a <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004bd2:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bd6:	2d85                	addw	s11,s11,1
    80004bd8:	038d0d1b          	addw	s10,s10,56
    80004bdc:	e8045783          	lhu	a5,-384(s0)
    80004be0:	08fdd063          	bge	s11,a5,80004c60 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004be4:	2d01                	sext.w	s10,s10
    80004be6:	03800713          	li	a4,56
    80004bea:	86ea                	mv	a3,s10
    80004bec:	e1040613          	add	a2,s0,-496
    80004bf0:	4581                	li	a1,0
    80004bf2:	8552                	mv	a0,s4
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	c46080e7          	jalr	-954(ra) # 8000383a <readi>
    80004bfc:	03800793          	li	a5,56
    80004c00:	1cf51e63          	bne	a0,a5,80004ddc <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004c04:	e1042783          	lw	a5,-496(s0)
    80004c08:	4705                	li	a4,1
    80004c0a:	fce796e3          	bne	a5,a4,80004bd6 <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004c0e:	e3843603          	ld	a2,-456(s0)
    80004c12:	e3043783          	ld	a5,-464(s0)
    80004c16:	1ef66063          	bltu	a2,a5,80004df6 <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c1a:	e2043783          	ld	a5,-480(s0)
    80004c1e:	963e                	add	a2,a2,a5
    80004c20:	1cf66e63          	bltu	a2,a5,80004dfc <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c24:	85a6                	mv	a1,s1
    80004c26:	855a                	mv	a0,s6
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	7d4080e7          	jalr	2004(ra) # 800013fc <uvmalloc>
    80004c30:	e0a43423          	sd	a0,-504(s0)
    80004c34:	1c050763          	beqz	a0,80004e02 <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004c38:	e2043b83          	ld	s7,-480(s0)
    80004c3c:	df043783          	ld	a5,-528(s0)
    80004c40:	00fbf7b3          	and	a5,s7,a5
    80004c44:	18079e63          	bnez	a5,80004de0 <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c48:	e1842c03          	lw	s8,-488(s0)
    80004c4c:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004c50:	00098463          	beqz	s3,80004c58 <exec+0x1d0>
    80004c54:	4901                	li	s2,0
    80004c56:	bf99                	j	80004bac <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c58:	e0843483          	ld	s1,-504(s0)
    80004c5c:	bfad                	j	80004bd6 <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c5e:	4481                	li	s1,0
  iunlockput(ip);
    80004c60:	8552                	mv	a0,s4
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	b86080e7          	jalr	-1146(ra) # 800037e8 <iunlockput>
  end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	34a080e7          	jalr	842(ra) # 80003fb4 <end_op>
  p = myproc();
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	ce8080e7          	jalr	-792(ra) # 8000195a <myproc>
    80004c7a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004c7c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004c80:	6985                	lui	s3,0x1
    80004c82:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c84:	99a6                	add	s3,s3,s1
    80004c86:	77fd                	lui	a5,0xfffff
    80004c88:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004c8c:	6609                	lui	a2,0x2
    80004c8e:	964e                	add	a2,a2,s3
    80004c90:	85ce                	mv	a1,s3
    80004c92:	855a                	mv	a0,s6
    80004c94:	ffffc097          	auipc	ra,0xffffc
    80004c98:	768080e7          	jalr	1896(ra) # 800013fc <uvmalloc>
    80004c9c:	892a                	mv	s2,a0
    80004c9e:	e0a43423          	sd	a0,-504(s0)
    80004ca2:	e509                	bnez	a0,80004cac <exec+0x224>
  if(pagetable)
    80004ca4:	e1343423          	sd	s3,-504(s0)
    80004ca8:	4a01                	li	s4,0
    80004caa:	aa1d                	j	80004de0 <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004cac:	75f9                	lui	a1,0xffffe
    80004cae:	95aa                	add	a1,a1,a0
    80004cb0:	855a                	mv	a0,s6
    80004cb2:	ffffd097          	auipc	ra,0xffffd
    80004cb6:	96c080e7          	jalr	-1684(ra) # 8000161e <uvmclear>
  stackbase = sp - PGSIZE;
    80004cba:	7bfd                	lui	s7,0xfffff
    80004cbc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004cbe:	e0043783          	ld	a5,-512(s0)
    80004cc2:	6388                	ld	a0,0(a5)
    80004cc4:	c52d                	beqz	a0,80004d2e <exec+0x2a6>
    80004cc6:	e8840993          	add	s3,s0,-376
    80004cca:	f8840c13          	add	s8,s0,-120
    80004cce:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004cd0:	ffffc097          	auipc	ra,0xffffc
    80004cd4:	1b0080e7          	jalr	432(ra) # 80000e80 <strlen>
    80004cd8:	0015079b          	addw	a5,a0,1
    80004cdc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ce0:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004ce4:	13796263          	bltu	s2,s7,80004e08 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ce8:	e0043d03          	ld	s10,-512(s0)
    80004cec:	000d3a03          	ld	s4,0(s10)
    80004cf0:	8552                	mv	a0,s4
    80004cf2:	ffffc097          	auipc	ra,0xffffc
    80004cf6:	18e080e7          	jalr	398(ra) # 80000e80 <strlen>
    80004cfa:	0015069b          	addw	a3,a0,1
    80004cfe:	8652                	mv	a2,s4
    80004d00:	85ca                	mv	a1,s2
    80004d02:	855a                	mv	a0,s6
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	94c080e7          	jalr	-1716(ra) # 80001650 <copyout>
    80004d0c:	10054063          	bltz	a0,80004e0c <exec+0x384>
    ustack[argc] = sp;
    80004d10:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d14:	0485                	add	s1,s1,1
    80004d16:	008d0793          	add	a5,s10,8
    80004d1a:	e0f43023          	sd	a5,-512(s0)
    80004d1e:	008d3503          	ld	a0,8(s10)
    80004d22:	c909                	beqz	a0,80004d34 <exec+0x2ac>
    if(argc >= MAXARG)
    80004d24:	09a1                	add	s3,s3,8
    80004d26:	fb8995e3          	bne	s3,s8,80004cd0 <exec+0x248>
  ip = 0;
    80004d2a:	4a01                	li	s4,0
    80004d2c:	a855                	j	80004de0 <exec+0x358>
  sp = sz;
    80004d2e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004d32:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d34:	00349793          	sll	a5,s1,0x3
    80004d38:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8f90>
    80004d3c:	97a2                	add	a5,a5,s0
    80004d3e:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d42:	00148693          	add	a3,s1,1
    80004d46:	068e                	sll	a3,a3,0x3
    80004d48:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d4c:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004d50:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004d54:	f57968e3          	bltu	s2,s7,80004ca4 <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d58:	e8840613          	add	a2,s0,-376
    80004d5c:	85ca                	mv	a1,s2
    80004d5e:	855a                	mv	a0,s6
    80004d60:	ffffd097          	auipc	ra,0xffffd
    80004d64:	8f0080e7          	jalr	-1808(ra) # 80001650 <copyout>
    80004d68:	0a054463          	bltz	a0,80004e10 <exec+0x388>
  p->trapframe->a1 = sp;
    80004d6c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004d70:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d74:	df843783          	ld	a5,-520(s0)
    80004d78:	0007c703          	lbu	a4,0(a5)
    80004d7c:	cf11                	beqz	a4,80004d98 <exec+0x310>
    80004d7e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004d80:	02f00693          	li	a3,47
    80004d84:	a039                	j	80004d92 <exec+0x30a>
      last = s+1;
    80004d86:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004d8a:	0785                	add	a5,a5,1
    80004d8c:	fff7c703          	lbu	a4,-1(a5)
    80004d90:	c701                	beqz	a4,80004d98 <exec+0x310>
    if(*s == '/')
    80004d92:	fed71ce3          	bne	a4,a3,80004d8a <exec+0x302>
    80004d96:	bfc5                	j	80004d86 <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d98:	4641                	li	a2,16
    80004d9a:	df843583          	ld	a1,-520(s0)
    80004d9e:	158a8513          	add	a0,s5,344
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	0ac080e7          	jalr	172(ra) # 80000e4e <safestrcpy>
  oldpagetable = p->pagetable;
    80004daa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004dae:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004db2:	e0843783          	ld	a5,-504(s0)
    80004db6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004dba:	058ab783          	ld	a5,88(s5)
    80004dbe:	e6043703          	ld	a4,-416(s0)
    80004dc2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004dc4:	058ab783          	ld	a5,88(s5)
    80004dc8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004dcc:	85e6                	mv	a1,s9
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	cec080e7          	jalr	-788(ra) # 80001aba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004dd6:	0004851b          	sext.w	a0,s1
    80004dda:	b399                	j	80004b20 <exec+0x98>
    80004ddc:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004de0:	e0843583          	ld	a1,-504(s0)
    80004de4:	855a                	mv	a0,s6
    80004de6:	ffffd097          	auipc	ra,0xffffd
    80004dea:	cd4080e7          	jalr	-812(ra) # 80001aba <proc_freepagetable>
  return -1;
    80004dee:	557d                	li	a0,-1
  if(ip){
    80004df0:	d20a08e3          	beqz	s4,80004b20 <exec+0x98>
    80004df4:	bb21                	j	80004b0c <exec+0x84>
    80004df6:	e0943423          	sd	s1,-504(s0)
    80004dfa:	b7dd                	j	80004de0 <exec+0x358>
    80004dfc:	e0943423          	sd	s1,-504(s0)
    80004e00:	b7c5                	j	80004de0 <exec+0x358>
    80004e02:	e0943423          	sd	s1,-504(s0)
    80004e06:	bfe9                	j	80004de0 <exec+0x358>
  ip = 0;
    80004e08:	4a01                	li	s4,0
    80004e0a:	bfd9                	j	80004de0 <exec+0x358>
    80004e0c:	4a01                	li	s4,0
  if(pagetable)
    80004e0e:	bfc9                	j	80004de0 <exec+0x358>
  sz = sz1;
    80004e10:	e0843983          	ld	s3,-504(s0)
    80004e14:	bd41                	j	80004ca4 <exec+0x21c>

0000000080004e16 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e16:	7179                	add	sp,sp,-48
    80004e18:	f406                	sd	ra,40(sp)
    80004e1a:	f022                	sd	s0,32(sp)
    80004e1c:	ec26                	sd	s1,24(sp)
    80004e1e:	e84a                	sd	s2,16(sp)
    80004e20:	1800                	add	s0,sp,48
    80004e22:	892e                	mv	s2,a1
    80004e24:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004e26:	fdc40593          	add	a1,s0,-36
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	bf2080e7          	jalr	-1038(ra) # 80002a1c <argint>
    80004e32:	04054063          	bltz	a0,80004e72 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e36:	fdc42703          	lw	a4,-36(s0)
    80004e3a:	47bd                	li	a5,15
    80004e3c:	02e7ed63          	bltu	a5,a4,80004e76 <argfd+0x60>
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	b1a080e7          	jalr	-1254(ra) # 8000195a <myproc>
    80004e48:	fdc42703          	lw	a4,-36(s0)
    80004e4c:	01a70793          	add	a5,a4,26
    80004e50:	078e                	sll	a5,a5,0x3
    80004e52:	953e                	add	a0,a0,a5
    80004e54:	611c                	ld	a5,0(a0)
    80004e56:	c395                	beqz	a5,80004e7a <argfd+0x64>
    return -1;
  if(pfd)
    80004e58:	00090463          	beqz	s2,80004e60 <argfd+0x4a>
    *pfd = fd;
    80004e5c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004e60:	4501                	li	a0,0
  if(pf)
    80004e62:	c091                	beqz	s1,80004e66 <argfd+0x50>
    *pf = f;
    80004e64:	e09c                	sd	a5,0(s1)
}
    80004e66:	70a2                	ld	ra,40(sp)
    80004e68:	7402                	ld	s0,32(sp)
    80004e6a:	64e2                	ld	s1,24(sp)
    80004e6c:	6942                	ld	s2,16(sp)
    80004e6e:	6145                	add	sp,sp,48
    80004e70:	8082                	ret
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	bfcd                	j	80004e66 <argfd+0x50>
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	b7fd                	j	80004e66 <argfd+0x50>
    80004e7a:	557d                	li	a0,-1
    80004e7c:	b7ed                	j	80004e66 <argfd+0x50>

0000000080004e7e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e7e:	1101                	add	sp,sp,-32
    80004e80:	ec06                	sd	ra,24(sp)
    80004e82:	e822                	sd	s0,16(sp)
    80004e84:	e426                	sd	s1,8(sp)
    80004e86:	1000                	add	s0,sp,32
    80004e88:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	ad0080e7          	jalr	-1328(ra) # 8000195a <myproc>
    80004e92:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004e94:	0d050793          	add	a5,a0,208
    80004e98:	4501                	li	a0,0
    80004e9a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004e9c:	6398                	ld	a4,0(a5)
    80004e9e:	cb19                	beqz	a4,80004eb4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004ea0:	2505                	addw	a0,a0,1
    80004ea2:	07a1                	add	a5,a5,8
    80004ea4:	fed51ce3          	bne	a0,a3,80004e9c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004ea8:	557d                	li	a0,-1
}
    80004eaa:	60e2                	ld	ra,24(sp)
    80004eac:	6442                	ld	s0,16(sp)
    80004eae:	64a2                	ld	s1,8(sp)
    80004eb0:	6105                	add	sp,sp,32
    80004eb2:	8082                	ret
      p->ofile[fd] = f;
    80004eb4:	01a50793          	add	a5,a0,26
    80004eb8:	078e                	sll	a5,a5,0x3
    80004eba:	963e                	add	a2,a2,a5
    80004ebc:	e204                	sd	s1,0(a2)
      return fd;
    80004ebe:	b7f5                	j	80004eaa <fdalloc+0x2c>

0000000080004ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004ec0:	715d                	add	sp,sp,-80
    80004ec2:	e486                	sd	ra,72(sp)
    80004ec4:	e0a2                	sd	s0,64(sp)
    80004ec6:	fc26                	sd	s1,56(sp)
    80004ec8:	f84a                	sd	s2,48(sp)
    80004eca:	f44e                	sd	s3,40(sp)
    80004ecc:	f052                	sd	s4,32(sp)
    80004ece:	ec56                	sd	s5,24(sp)
    80004ed0:	0880                	add	s0,sp,80
    80004ed2:	8aae                	mv	s5,a1
    80004ed4:	8a32                	mv	s4,a2
    80004ed6:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ed8:	fb040593          	add	a1,s0,-80
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	e7c080e7          	jalr	-388(ra) # 80003d58 <nameiparent>
    80004ee4:	892a                	mv	s2,a0
    80004ee6:	12050c63          	beqz	a0,8000501e <create+0x15e>
    return 0;

  ilock(dp);
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	69c080e7          	jalr	1692(ra) # 80003586 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004ef2:	4601                	li	a2,0
    80004ef4:	fb040593          	add	a1,s0,-80
    80004ef8:	854a                	mv	a0,s2
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	b6e080e7          	jalr	-1170(ra) # 80003a68 <dirlookup>
    80004f02:	84aa                	mv	s1,a0
    80004f04:	c539                	beqz	a0,80004f52 <create+0x92>
    iunlockput(dp);
    80004f06:	854a                	mv	a0,s2
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	8e0080e7          	jalr	-1824(ra) # 800037e8 <iunlockput>
    ilock(ip);
    80004f10:	8526                	mv	a0,s1
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	674080e7          	jalr	1652(ra) # 80003586 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f1a:	4789                	li	a5,2
    80004f1c:	02fa9463          	bne	s5,a5,80004f44 <create+0x84>
    80004f20:	0444d783          	lhu	a5,68(s1)
    80004f24:	37f9                	addw	a5,a5,-2
    80004f26:	17c2                	sll	a5,a5,0x30
    80004f28:	93c1                	srl	a5,a5,0x30
    80004f2a:	4705                	li	a4,1
    80004f2c:	00f76c63          	bltu	a4,a5,80004f44 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004f30:	8526                	mv	a0,s1
    80004f32:	60a6                	ld	ra,72(sp)
    80004f34:	6406                	ld	s0,64(sp)
    80004f36:	74e2                	ld	s1,56(sp)
    80004f38:	7942                	ld	s2,48(sp)
    80004f3a:	79a2                	ld	s3,40(sp)
    80004f3c:	7a02                	ld	s4,32(sp)
    80004f3e:	6ae2                	ld	s5,24(sp)
    80004f40:	6161                	add	sp,sp,80
    80004f42:	8082                	ret
    iunlockput(ip);
    80004f44:	8526                	mv	a0,s1
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	8a2080e7          	jalr	-1886(ra) # 800037e8 <iunlockput>
    return 0;
    80004f4e:	4481                	li	s1,0
    80004f50:	b7c5                	j	80004f30 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004f52:	85d6                	mv	a1,s5
    80004f54:	00092503          	lw	a0,0(s2)
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	49a080e7          	jalr	1178(ra) # 800033f2 <ialloc>
    80004f60:	84aa                	mv	s1,a0
    80004f62:	c139                	beqz	a0,80004fa8 <create+0xe8>
  ilock(ip);
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	622080e7          	jalr	1570(ra) # 80003586 <ilock>
  ip->major = major;
    80004f6c:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004f70:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004f74:	4985                	li	s3,1
    80004f76:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	53e080e7          	jalr	1342(ra) # 800034ba <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004f84:	033a8a63          	beq	s5,s3,80004fb8 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f88:	40d0                	lw	a2,4(s1)
    80004f8a:	fb040593          	add	a1,s0,-80
    80004f8e:	854a                	mv	a0,s2
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	ce8080e7          	jalr	-792(ra) # 80003c78 <dirlink>
    80004f98:	06054b63          	bltz	a0,8000500e <create+0x14e>
  iunlockput(dp);
    80004f9c:	854a                	mv	a0,s2
    80004f9e:	fffff097          	auipc	ra,0xfffff
    80004fa2:	84a080e7          	jalr	-1974(ra) # 800037e8 <iunlockput>
  return ip;
    80004fa6:	b769                	j	80004f30 <create+0x70>
    panic("create: ialloc");
    80004fa8:	00003517          	auipc	a0,0x3
    80004fac:	72850513          	add	a0,a0,1832 # 800086d0 <syscalls+0x2b0>
    80004fb0:	ffffb097          	auipc	ra,0xffffb
    80004fb4:	598080e7          	jalr	1432(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    80004fb8:	04a95783          	lhu	a5,74(s2)
    80004fbc:	2785                	addw	a5,a5,1
    80004fbe:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004fc2:	854a                	mv	a0,s2
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	4f6080e7          	jalr	1270(ra) # 800034ba <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004fcc:	40d0                	lw	a2,4(s1)
    80004fce:	00003597          	auipc	a1,0x3
    80004fd2:	71258593          	add	a1,a1,1810 # 800086e0 <syscalls+0x2c0>
    80004fd6:	8526                	mv	a0,s1
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	ca0080e7          	jalr	-864(ra) # 80003c78 <dirlink>
    80004fe0:	00054f63          	bltz	a0,80004ffe <create+0x13e>
    80004fe4:	00492603          	lw	a2,4(s2)
    80004fe8:	00003597          	auipc	a1,0x3
    80004fec:	70058593          	add	a1,a1,1792 # 800086e8 <syscalls+0x2c8>
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	c86080e7          	jalr	-890(ra) # 80003c78 <dirlink>
    80004ffa:	f80557e3          	bgez	a0,80004f88 <create+0xc8>
      panic("create dots");
    80004ffe:	00003517          	auipc	a0,0x3
    80005002:	6f250513          	add	a0,a0,1778 # 800086f0 <syscalls+0x2d0>
    80005006:	ffffb097          	auipc	ra,0xffffb
    8000500a:	542080e7          	jalr	1346(ra) # 80000548 <panic>
    panic("create: dirlink");
    8000500e:	00003517          	auipc	a0,0x3
    80005012:	6f250513          	add	a0,a0,1778 # 80008700 <syscalls+0x2e0>
    80005016:	ffffb097          	auipc	ra,0xffffb
    8000501a:	532080e7          	jalr	1330(ra) # 80000548 <panic>
    return 0;
    8000501e:	84aa                	mv	s1,a0
    80005020:	bf01                	j	80004f30 <create+0x70>

0000000080005022 <sys_dup>:
{
    80005022:	7179                	add	sp,sp,-48
    80005024:	f406                	sd	ra,40(sp)
    80005026:	f022                	sd	s0,32(sp)
    80005028:	ec26                	sd	s1,24(sp)
    8000502a:	e84a                	sd	s2,16(sp)
    8000502c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000502e:	fd840613          	add	a2,s0,-40
    80005032:	4581                	li	a1,0
    80005034:	4501                	li	a0,0
    80005036:	00000097          	auipc	ra,0x0
    8000503a:	de0080e7          	jalr	-544(ra) # 80004e16 <argfd>
    return -1;
    8000503e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005040:	02054363          	bltz	a0,80005066 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005044:	fd843903          	ld	s2,-40(s0)
    80005048:	854a                	mv	a0,s2
    8000504a:	00000097          	auipc	ra,0x0
    8000504e:	e34080e7          	jalr	-460(ra) # 80004e7e <fdalloc>
    80005052:	84aa                	mv	s1,a0
    return -1;
    80005054:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005056:	00054863          	bltz	a0,80005066 <sys_dup+0x44>
  filedup(f);
    8000505a:	854a                	mv	a0,s2
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	358080e7          	jalr	856(ra) # 800043b4 <filedup>
  return fd;
    80005064:	87a6                	mv	a5,s1
}
    80005066:	853e                	mv	a0,a5
    80005068:	70a2                	ld	ra,40(sp)
    8000506a:	7402                	ld	s0,32(sp)
    8000506c:	64e2                	ld	s1,24(sp)
    8000506e:	6942                	ld	s2,16(sp)
    80005070:	6145                	add	sp,sp,48
    80005072:	8082                	ret

0000000080005074 <sys_read>:
{
    80005074:	7179                	add	sp,sp,-48
    80005076:	f406                	sd	ra,40(sp)
    80005078:	f022                	sd	s0,32(sp)
    8000507a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000507c:	fe840613          	add	a2,s0,-24
    80005080:	4581                	li	a1,0
    80005082:	4501                	li	a0,0
    80005084:	00000097          	auipc	ra,0x0
    80005088:	d92080e7          	jalr	-622(ra) # 80004e16 <argfd>
    return -1;
    8000508c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000508e:	04054163          	bltz	a0,800050d0 <sys_read+0x5c>
    80005092:	fe440593          	add	a1,s0,-28
    80005096:	4509                	li	a0,2
    80005098:	ffffe097          	auipc	ra,0xffffe
    8000509c:	984080e7          	jalr	-1660(ra) # 80002a1c <argint>
    return -1;
    800050a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050a2:	02054763          	bltz	a0,800050d0 <sys_read+0x5c>
    800050a6:	fd840593          	add	a1,s0,-40
    800050aa:	4505                	li	a0,1
    800050ac:	ffffe097          	auipc	ra,0xffffe
    800050b0:	992080e7          	jalr	-1646(ra) # 80002a3e <argaddr>
    return -1;
    800050b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050b6:	00054d63          	bltz	a0,800050d0 <sys_read+0x5c>
  return fileread(f, p, n);
    800050ba:	fe442603          	lw	a2,-28(s0)
    800050be:	fd843583          	ld	a1,-40(s0)
    800050c2:	fe843503          	ld	a0,-24(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	47a080e7          	jalr	1146(ra) # 80004540 <fileread>
    800050ce:	87aa                	mv	a5,a0
}
    800050d0:	853e                	mv	a0,a5
    800050d2:	70a2                	ld	ra,40(sp)
    800050d4:	7402                	ld	s0,32(sp)
    800050d6:	6145                	add	sp,sp,48
    800050d8:	8082                	ret

00000000800050da <sys_write>:
{
    800050da:	7179                	add	sp,sp,-48
    800050dc:	f406                	sd	ra,40(sp)
    800050de:	f022                	sd	s0,32(sp)
    800050e0:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050e2:	fe840613          	add	a2,s0,-24
    800050e6:	4581                	li	a1,0
    800050e8:	4501                	li	a0,0
    800050ea:	00000097          	auipc	ra,0x0
    800050ee:	d2c080e7          	jalr	-724(ra) # 80004e16 <argfd>
    return -1;
    800050f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050f4:	04054163          	bltz	a0,80005136 <sys_write+0x5c>
    800050f8:	fe440593          	add	a1,s0,-28
    800050fc:	4509                	li	a0,2
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	91e080e7          	jalr	-1762(ra) # 80002a1c <argint>
    return -1;
    80005106:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005108:	02054763          	bltz	a0,80005136 <sys_write+0x5c>
    8000510c:	fd840593          	add	a1,s0,-40
    80005110:	4505                	li	a0,1
    80005112:	ffffe097          	auipc	ra,0xffffe
    80005116:	92c080e7          	jalr	-1748(ra) # 80002a3e <argaddr>
    return -1;
    8000511a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000511c:	00054d63          	bltz	a0,80005136 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005120:	fe442603          	lw	a2,-28(s0)
    80005124:	fd843583          	ld	a1,-40(s0)
    80005128:	fe843503          	ld	a0,-24(s0)
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	4d6080e7          	jalr	1238(ra) # 80004602 <filewrite>
    80005134:	87aa                	mv	a5,a0
}
    80005136:	853e                	mv	a0,a5
    80005138:	70a2                	ld	ra,40(sp)
    8000513a:	7402                	ld	s0,32(sp)
    8000513c:	6145                	add	sp,sp,48
    8000513e:	8082                	ret

0000000080005140 <sys_close>:
{
    80005140:	1101                	add	sp,sp,-32
    80005142:	ec06                	sd	ra,24(sp)
    80005144:	e822                	sd	s0,16(sp)
    80005146:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005148:	fe040613          	add	a2,s0,-32
    8000514c:	fec40593          	add	a1,s0,-20
    80005150:	4501                	li	a0,0
    80005152:	00000097          	auipc	ra,0x0
    80005156:	cc4080e7          	jalr	-828(ra) # 80004e16 <argfd>
    return -1;
    8000515a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000515c:	02054463          	bltz	a0,80005184 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	7fa080e7          	jalr	2042(ra) # 8000195a <myproc>
    80005168:	fec42783          	lw	a5,-20(s0)
    8000516c:	07e9                	add	a5,a5,26
    8000516e:	078e                	sll	a5,a5,0x3
    80005170:	953e                	add	a0,a0,a5
    80005172:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005176:	fe043503          	ld	a0,-32(s0)
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	28c080e7          	jalr	652(ra) # 80004406 <fileclose>
  return 0;
    80005182:	4781                	li	a5,0
}
    80005184:	853e                	mv	a0,a5
    80005186:	60e2                	ld	ra,24(sp)
    80005188:	6442                	ld	s0,16(sp)
    8000518a:	6105                	add	sp,sp,32
    8000518c:	8082                	ret

000000008000518e <sys_fstat>:
{
    8000518e:	1101                	add	sp,sp,-32
    80005190:	ec06                	sd	ra,24(sp)
    80005192:	e822                	sd	s0,16(sp)
    80005194:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005196:	fe840613          	add	a2,s0,-24
    8000519a:	4581                	li	a1,0
    8000519c:	4501                	li	a0,0
    8000519e:	00000097          	auipc	ra,0x0
    800051a2:	c78080e7          	jalr	-904(ra) # 80004e16 <argfd>
    return -1;
    800051a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800051a8:	02054563          	bltz	a0,800051d2 <sys_fstat+0x44>
    800051ac:	fe040593          	add	a1,s0,-32
    800051b0:	4505                	li	a0,1
    800051b2:	ffffe097          	auipc	ra,0xffffe
    800051b6:	88c080e7          	jalr	-1908(ra) # 80002a3e <argaddr>
    return -1;
    800051ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800051bc:	00054b63          	bltz	a0,800051d2 <sys_fstat+0x44>
  return filestat(f, st);
    800051c0:	fe043583          	ld	a1,-32(s0)
    800051c4:	fe843503          	ld	a0,-24(s0)
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	306080e7          	jalr	774(ra) # 800044ce <filestat>
    800051d0:	87aa                	mv	a5,a0
}
    800051d2:	853e                	mv	a0,a5
    800051d4:	60e2                	ld	ra,24(sp)
    800051d6:	6442                	ld	s0,16(sp)
    800051d8:	6105                	add	sp,sp,32
    800051da:	8082                	ret

00000000800051dc <sys_link>:
{
    800051dc:	7169                	add	sp,sp,-304
    800051de:	f606                	sd	ra,296(sp)
    800051e0:	f222                	sd	s0,288(sp)
    800051e2:	ee26                	sd	s1,280(sp)
    800051e4:	ea4a                	sd	s2,272(sp)
    800051e6:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051e8:	08000613          	li	a2,128
    800051ec:	ed040593          	add	a1,s0,-304
    800051f0:	4501                	li	a0,0
    800051f2:	ffffe097          	auipc	ra,0xffffe
    800051f6:	86e080e7          	jalr	-1938(ra) # 80002a60 <argstr>
    return -1;
    800051fa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051fc:	10054e63          	bltz	a0,80005318 <sys_link+0x13c>
    80005200:	08000613          	li	a2,128
    80005204:	f5040593          	add	a1,s0,-176
    80005208:	4505                	li	a0,1
    8000520a:	ffffe097          	auipc	ra,0xffffe
    8000520e:	856080e7          	jalr	-1962(ra) # 80002a60 <argstr>
    return -1;
    80005212:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005214:	10054263          	bltz	a0,80005318 <sys_link+0x13c>
  begin_op();
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	d22080e7          	jalr	-734(ra) # 80003f3a <begin_op>
  if((ip = namei(old)) == 0){
    80005220:	ed040513          	add	a0,s0,-304
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	b16080e7          	jalr	-1258(ra) # 80003d3a <namei>
    8000522c:	84aa                	mv	s1,a0
    8000522e:	c551                	beqz	a0,800052ba <sys_link+0xde>
  ilock(ip);
    80005230:	ffffe097          	auipc	ra,0xffffe
    80005234:	356080e7          	jalr	854(ra) # 80003586 <ilock>
  if(ip->type == T_DIR){
    80005238:	04449703          	lh	a4,68(s1)
    8000523c:	4785                	li	a5,1
    8000523e:	08f70463          	beq	a4,a5,800052c6 <sys_link+0xea>
  ip->nlink++;
    80005242:	04a4d783          	lhu	a5,74(s1)
    80005246:	2785                	addw	a5,a5,1
    80005248:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000524c:	8526                	mv	a0,s1
    8000524e:	ffffe097          	auipc	ra,0xffffe
    80005252:	26c080e7          	jalr	620(ra) # 800034ba <iupdate>
  iunlock(ip);
    80005256:	8526                	mv	a0,s1
    80005258:	ffffe097          	auipc	ra,0xffffe
    8000525c:	3f0080e7          	jalr	1008(ra) # 80003648 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005260:	fd040593          	add	a1,s0,-48
    80005264:	f5040513          	add	a0,s0,-176
    80005268:	fffff097          	auipc	ra,0xfffff
    8000526c:	af0080e7          	jalr	-1296(ra) # 80003d58 <nameiparent>
    80005270:	892a                	mv	s2,a0
    80005272:	c935                	beqz	a0,800052e6 <sys_link+0x10a>
  ilock(dp);
    80005274:	ffffe097          	auipc	ra,0xffffe
    80005278:	312080e7          	jalr	786(ra) # 80003586 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000527c:	00092703          	lw	a4,0(s2)
    80005280:	409c                	lw	a5,0(s1)
    80005282:	04f71d63          	bne	a4,a5,800052dc <sys_link+0x100>
    80005286:	40d0                	lw	a2,4(s1)
    80005288:	fd040593          	add	a1,s0,-48
    8000528c:	854a                	mv	a0,s2
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	9ea080e7          	jalr	-1558(ra) # 80003c78 <dirlink>
    80005296:	04054363          	bltz	a0,800052dc <sys_link+0x100>
  iunlockput(dp);
    8000529a:	854a                	mv	a0,s2
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	54c080e7          	jalr	1356(ra) # 800037e8 <iunlockput>
  iput(ip);
    800052a4:	8526                	mv	a0,s1
    800052a6:	ffffe097          	auipc	ra,0xffffe
    800052aa:	49a080e7          	jalr	1178(ra) # 80003740 <iput>
  end_op();
    800052ae:	fffff097          	auipc	ra,0xfffff
    800052b2:	d06080e7          	jalr	-762(ra) # 80003fb4 <end_op>
  return 0;
    800052b6:	4781                	li	a5,0
    800052b8:	a085                	j	80005318 <sys_link+0x13c>
    end_op();
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	cfa080e7          	jalr	-774(ra) # 80003fb4 <end_op>
    return -1;
    800052c2:	57fd                	li	a5,-1
    800052c4:	a891                	j	80005318 <sys_link+0x13c>
    iunlockput(ip);
    800052c6:	8526                	mv	a0,s1
    800052c8:	ffffe097          	auipc	ra,0xffffe
    800052cc:	520080e7          	jalr	1312(ra) # 800037e8 <iunlockput>
    end_op();
    800052d0:	fffff097          	auipc	ra,0xfffff
    800052d4:	ce4080e7          	jalr	-796(ra) # 80003fb4 <end_op>
    return -1;
    800052d8:	57fd                	li	a5,-1
    800052da:	a83d                	j	80005318 <sys_link+0x13c>
    iunlockput(dp);
    800052dc:	854a                	mv	a0,s2
    800052de:	ffffe097          	auipc	ra,0xffffe
    800052e2:	50a080e7          	jalr	1290(ra) # 800037e8 <iunlockput>
  ilock(ip);
    800052e6:	8526                	mv	a0,s1
    800052e8:	ffffe097          	auipc	ra,0xffffe
    800052ec:	29e080e7          	jalr	670(ra) # 80003586 <ilock>
  ip->nlink--;
    800052f0:	04a4d783          	lhu	a5,74(s1)
    800052f4:	37fd                	addw	a5,a5,-1
    800052f6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052fa:	8526                	mv	a0,s1
    800052fc:	ffffe097          	auipc	ra,0xffffe
    80005300:	1be080e7          	jalr	446(ra) # 800034ba <iupdate>
  iunlockput(ip);
    80005304:	8526                	mv	a0,s1
    80005306:	ffffe097          	auipc	ra,0xffffe
    8000530a:	4e2080e7          	jalr	1250(ra) # 800037e8 <iunlockput>
  end_op();
    8000530e:	fffff097          	auipc	ra,0xfffff
    80005312:	ca6080e7          	jalr	-858(ra) # 80003fb4 <end_op>
  return -1;
    80005316:	57fd                	li	a5,-1
}
    80005318:	853e                	mv	a0,a5
    8000531a:	70b2                	ld	ra,296(sp)
    8000531c:	7412                	ld	s0,288(sp)
    8000531e:	64f2                	ld	s1,280(sp)
    80005320:	6952                	ld	s2,272(sp)
    80005322:	6155                	add	sp,sp,304
    80005324:	8082                	ret

0000000080005326 <sys_unlink>:
{
    80005326:	7151                	add	sp,sp,-240
    80005328:	f586                	sd	ra,232(sp)
    8000532a:	f1a2                	sd	s0,224(sp)
    8000532c:	eda6                	sd	s1,216(sp)
    8000532e:	e9ca                	sd	s2,208(sp)
    80005330:	e5ce                	sd	s3,200(sp)
    80005332:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005334:	08000613          	li	a2,128
    80005338:	f3040593          	add	a1,s0,-208
    8000533c:	4501                	li	a0,0
    8000533e:	ffffd097          	auipc	ra,0xffffd
    80005342:	722080e7          	jalr	1826(ra) # 80002a60 <argstr>
    80005346:	18054163          	bltz	a0,800054c8 <sys_unlink+0x1a2>
  begin_op();
    8000534a:	fffff097          	auipc	ra,0xfffff
    8000534e:	bf0080e7          	jalr	-1040(ra) # 80003f3a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005352:	fb040593          	add	a1,s0,-80
    80005356:	f3040513          	add	a0,s0,-208
    8000535a:	fffff097          	auipc	ra,0xfffff
    8000535e:	9fe080e7          	jalr	-1538(ra) # 80003d58 <nameiparent>
    80005362:	84aa                	mv	s1,a0
    80005364:	c979                	beqz	a0,8000543a <sys_unlink+0x114>
  ilock(dp);
    80005366:	ffffe097          	auipc	ra,0xffffe
    8000536a:	220080e7          	jalr	544(ra) # 80003586 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000536e:	00003597          	auipc	a1,0x3
    80005372:	37258593          	add	a1,a1,882 # 800086e0 <syscalls+0x2c0>
    80005376:	fb040513          	add	a0,s0,-80
    8000537a:	ffffe097          	auipc	ra,0xffffe
    8000537e:	6d4080e7          	jalr	1748(ra) # 80003a4e <namecmp>
    80005382:	14050a63          	beqz	a0,800054d6 <sys_unlink+0x1b0>
    80005386:	00003597          	auipc	a1,0x3
    8000538a:	36258593          	add	a1,a1,866 # 800086e8 <syscalls+0x2c8>
    8000538e:	fb040513          	add	a0,s0,-80
    80005392:	ffffe097          	auipc	ra,0xffffe
    80005396:	6bc080e7          	jalr	1724(ra) # 80003a4e <namecmp>
    8000539a:	12050e63          	beqz	a0,800054d6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000539e:	f2c40613          	add	a2,s0,-212
    800053a2:	fb040593          	add	a1,s0,-80
    800053a6:	8526                	mv	a0,s1
    800053a8:	ffffe097          	auipc	ra,0xffffe
    800053ac:	6c0080e7          	jalr	1728(ra) # 80003a68 <dirlookup>
    800053b0:	892a                	mv	s2,a0
    800053b2:	12050263          	beqz	a0,800054d6 <sys_unlink+0x1b0>
  ilock(ip);
    800053b6:	ffffe097          	auipc	ra,0xffffe
    800053ba:	1d0080e7          	jalr	464(ra) # 80003586 <ilock>
  if(ip->nlink < 1)
    800053be:	04a91783          	lh	a5,74(s2)
    800053c2:	08f05263          	blez	a5,80005446 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800053c6:	04491703          	lh	a4,68(s2)
    800053ca:	4785                	li	a5,1
    800053cc:	08f70563          	beq	a4,a5,80005456 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800053d0:	4641                	li	a2,16
    800053d2:	4581                	li	a1,0
    800053d4:	fc040513          	add	a0,s0,-64
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	926080e7          	jalr	-1754(ra) # 80000cfe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053e0:	4741                	li	a4,16
    800053e2:	f2c42683          	lw	a3,-212(s0)
    800053e6:	fc040613          	add	a2,s0,-64
    800053ea:	4581                	li	a1,0
    800053ec:	8526                	mv	a0,s1
    800053ee:	ffffe097          	auipc	ra,0xffffe
    800053f2:	544080e7          	jalr	1348(ra) # 80003932 <writei>
    800053f6:	47c1                	li	a5,16
    800053f8:	0af51563          	bne	a0,a5,800054a2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800053fc:	04491703          	lh	a4,68(s2)
    80005400:	4785                	li	a5,1
    80005402:	0af70863          	beq	a4,a5,800054b2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005406:	8526                	mv	a0,s1
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	3e0080e7          	jalr	992(ra) # 800037e8 <iunlockput>
  ip->nlink--;
    80005410:	04a95783          	lhu	a5,74(s2)
    80005414:	37fd                	addw	a5,a5,-1
    80005416:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000541a:	854a                	mv	a0,s2
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	09e080e7          	jalr	158(ra) # 800034ba <iupdate>
  iunlockput(ip);
    80005424:	854a                	mv	a0,s2
    80005426:	ffffe097          	auipc	ra,0xffffe
    8000542a:	3c2080e7          	jalr	962(ra) # 800037e8 <iunlockput>
  end_op();
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	b86080e7          	jalr	-1146(ra) # 80003fb4 <end_op>
  return 0;
    80005436:	4501                	li	a0,0
    80005438:	a84d                	j	800054ea <sys_unlink+0x1c4>
    end_op();
    8000543a:	fffff097          	auipc	ra,0xfffff
    8000543e:	b7a080e7          	jalr	-1158(ra) # 80003fb4 <end_op>
    return -1;
    80005442:	557d                	li	a0,-1
    80005444:	a05d                	j	800054ea <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005446:	00003517          	auipc	a0,0x3
    8000544a:	2ca50513          	add	a0,a0,714 # 80008710 <syscalls+0x2f0>
    8000544e:	ffffb097          	auipc	ra,0xffffb
    80005452:	0fa080e7          	jalr	250(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005456:	04c92703          	lw	a4,76(s2)
    8000545a:	02000793          	li	a5,32
    8000545e:	f6e7f9e3          	bgeu	a5,a4,800053d0 <sys_unlink+0xaa>
    80005462:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005466:	4741                	li	a4,16
    80005468:	86ce                	mv	a3,s3
    8000546a:	f1840613          	add	a2,s0,-232
    8000546e:	4581                	li	a1,0
    80005470:	854a                	mv	a0,s2
    80005472:	ffffe097          	auipc	ra,0xffffe
    80005476:	3c8080e7          	jalr	968(ra) # 8000383a <readi>
    8000547a:	47c1                	li	a5,16
    8000547c:	00f51b63          	bne	a0,a5,80005492 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005480:	f1845783          	lhu	a5,-232(s0)
    80005484:	e7a1                	bnez	a5,800054cc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005486:	29c1                	addw	s3,s3,16
    80005488:	04c92783          	lw	a5,76(s2)
    8000548c:	fcf9ede3          	bltu	s3,a5,80005466 <sys_unlink+0x140>
    80005490:	b781                	j	800053d0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	29650513          	add	a0,a0,662 # 80008728 <syscalls+0x308>
    8000549a:	ffffb097          	auipc	ra,0xffffb
    8000549e:	0ae080e7          	jalr	174(ra) # 80000548 <panic>
    panic("unlink: writei");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	29e50513          	add	a0,a0,670 # 80008740 <syscalls+0x320>
    800054aa:	ffffb097          	auipc	ra,0xffffb
    800054ae:	09e080e7          	jalr	158(ra) # 80000548 <panic>
    dp->nlink--;
    800054b2:	04a4d783          	lhu	a5,74(s1)
    800054b6:	37fd                	addw	a5,a5,-1
    800054b8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800054bc:	8526                	mv	a0,s1
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	ffc080e7          	jalr	-4(ra) # 800034ba <iupdate>
    800054c6:	b781                	j	80005406 <sys_unlink+0xe0>
    return -1;
    800054c8:	557d                	li	a0,-1
    800054ca:	a005                	j	800054ea <sys_unlink+0x1c4>
    iunlockput(ip);
    800054cc:	854a                	mv	a0,s2
    800054ce:	ffffe097          	auipc	ra,0xffffe
    800054d2:	31a080e7          	jalr	794(ra) # 800037e8 <iunlockput>
  iunlockput(dp);
    800054d6:	8526                	mv	a0,s1
    800054d8:	ffffe097          	auipc	ra,0xffffe
    800054dc:	310080e7          	jalr	784(ra) # 800037e8 <iunlockput>
  end_op();
    800054e0:	fffff097          	auipc	ra,0xfffff
    800054e4:	ad4080e7          	jalr	-1324(ra) # 80003fb4 <end_op>
  return -1;
    800054e8:	557d                	li	a0,-1
}
    800054ea:	70ae                	ld	ra,232(sp)
    800054ec:	740e                	ld	s0,224(sp)
    800054ee:	64ee                	ld	s1,216(sp)
    800054f0:	694e                	ld	s2,208(sp)
    800054f2:	69ae                	ld	s3,200(sp)
    800054f4:	616d                	add	sp,sp,240
    800054f6:	8082                	ret

00000000800054f8 <sys_open>:

uint64
sys_open(void)
{
    800054f8:	7131                	add	sp,sp,-192
    800054fa:	fd06                	sd	ra,184(sp)
    800054fc:	f922                	sd	s0,176(sp)
    800054fe:	f526                	sd	s1,168(sp)
    80005500:	f14a                	sd	s2,160(sp)
    80005502:	ed4e                	sd	s3,152(sp)
    80005504:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005506:	08000613          	li	a2,128
    8000550a:	f5040593          	add	a1,s0,-176
    8000550e:	4501                	li	a0,0
    80005510:	ffffd097          	auipc	ra,0xffffd
    80005514:	550080e7          	jalr	1360(ra) # 80002a60 <argstr>
    return -1;
    80005518:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000551a:	0c054063          	bltz	a0,800055da <sys_open+0xe2>
    8000551e:	f4c40593          	add	a1,s0,-180
    80005522:	4505                	li	a0,1
    80005524:	ffffd097          	auipc	ra,0xffffd
    80005528:	4f8080e7          	jalr	1272(ra) # 80002a1c <argint>
    8000552c:	0a054763          	bltz	a0,800055da <sys_open+0xe2>

  begin_op();
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	a0a080e7          	jalr	-1526(ra) # 80003f3a <begin_op>

  if(omode & O_CREATE){
    80005538:	f4c42783          	lw	a5,-180(s0)
    8000553c:	2007f793          	and	a5,a5,512
    80005540:	cbd5                	beqz	a5,800055f4 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005542:	4681                	li	a3,0
    80005544:	4601                	li	a2,0
    80005546:	4589                	li	a1,2
    80005548:	f5040513          	add	a0,s0,-176
    8000554c:	00000097          	auipc	ra,0x0
    80005550:	974080e7          	jalr	-1676(ra) # 80004ec0 <create>
    80005554:	892a                	mv	s2,a0
    if(ip == 0){
    80005556:	c951                	beqz	a0,800055ea <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005558:	04491703          	lh	a4,68(s2)
    8000555c:	478d                	li	a5,3
    8000555e:	00f71763          	bne	a4,a5,8000556c <sys_open+0x74>
    80005562:	04695703          	lhu	a4,70(s2)
    80005566:	47a5                	li	a5,9
    80005568:	0ce7eb63          	bltu	a5,a4,8000563e <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000556c:	fffff097          	auipc	ra,0xfffff
    80005570:	dde080e7          	jalr	-546(ra) # 8000434a <filealloc>
    80005574:	89aa                	mv	s3,a0
    80005576:	c565                	beqz	a0,8000565e <sys_open+0x166>
    80005578:	00000097          	auipc	ra,0x0
    8000557c:	906080e7          	jalr	-1786(ra) # 80004e7e <fdalloc>
    80005580:	84aa                	mv	s1,a0
    80005582:	0c054963          	bltz	a0,80005654 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005586:	04491703          	lh	a4,68(s2)
    8000558a:	478d                	li	a5,3
    8000558c:	0ef70463          	beq	a4,a5,80005674 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005590:	4789                	li	a5,2
    80005592:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005596:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000559a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000559e:	f4c42783          	lw	a5,-180(s0)
    800055a2:	0017c713          	xor	a4,a5,1
    800055a6:	8b05                	and	a4,a4,1
    800055a8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800055ac:	0037f713          	and	a4,a5,3
    800055b0:	00e03733          	snez	a4,a4
    800055b4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800055b8:	4007f793          	and	a5,a5,1024
    800055bc:	c791                	beqz	a5,800055c8 <sys_open+0xd0>
    800055be:	04491703          	lh	a4,68(s2)
    800055c2:	4789                	li	a5,2
    800055c4:	0af70f63          	beq	a4,a5,80005682 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    800055c8:	854a                	mv	a0,s2
    800055ca:	ffffe097          	auipc	ra,0xffffe
    800055ce:	07e080e7          	jalr	126(ra) # 80003648 <iunlock>
  end_op();
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	9e2080e7          	jalr	-1566(ra) # 80003fb4 <end_op>

  return fd;
}
    800055da:	8526                	mv	a0,s1
    800055dc:	70ea                	ld	ra,184(sp)
    800055de:	744a                	ld	s0,176(sp)
    800055e0:	74aa                	ld	s1,168(sp)
    800055e2:	790a                	ld	s2,160(sp)
    800055e4:	69ea                	ld	s3,152(sp)
    800055e6:	6129                	add	sp,sp,192
    800055e8:	8082                	ret
      end_op();
    800055ea:	fffff097          	auipc	ra,0xfffff
    800055ee:	9ca080e7          	jalr	-1590(ra) # 80003fb4 <end_op>
      return -1;
    800055f2:	b7e5                	j	800055da <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    800055f4:	f5040513          	add	a0,s0,-176
    800055f8:	ffffe097          	auipc	ra,0xffffe
    800055fc:	742080e7          	jalr	1858(ra) # 80003d3a <namei>
    80005600:	892a                	mv	s2,a0
    80005602:	c905                	beqz	a0,80005632 <sys_open+0x13a>
    ilock(ip);
    80005604:	ffffe097          	auipc	ra,0xffffe
    80005608:	f82080e7          	jalr	-126(ra) # 80003586 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000560c:	04491703          	lh	a4,68(s2)
    80005610:	4785                	li	a5,1
    80005612:	f4f713e3          	bne	a4,a5,80005558 <sys_open+0x60>
    80005616:	f4c42783          	lw	a5,-180(s0)
    8000561a:	dba9                	beqz	a5,8000556c <sys_open+0x74>
      iunlockput(ip);
    8000561c:	854a                	mv	a0,s2
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	1ca080e7          	jalr	458(ra) # 800037e8 <iunlockput>
      end_op();
    80005626:	fffff097          	auipc	ra,0xfffff
    8000562a:	98e080e7          	jalr	-1650(ra) # 80003fb4 <end_op>
      return -1;
    8000562e:	54fd                	li	s1,-1
    80005630:	b76d                	j	800055da <sys_open+0xe2>
      end_op();
    80005632:	fffff097          	auipc	ra,0xfffff
    80005636:	982080e7          	jalr	-1662(ra) # 80003fb4 <end_op>
      return -1;
    8000563a:	54fd                	li	s1,-1
    8000563c:	bf79                	j	800055da <sys_open+0xe2>
    iunlockput(ip);
    8000563e:	854a                	mv	a0,s2
    80005640:	ffffe097          	auipc	ra,0xffffe
    80005644:	1a8080e7          	jalr	424(ra) # 800037e8 <iunlockput>
    end_op();
    80005648:	fffff097          	auipc	ra,0xfffff
    8000564c:	96c080e7          	jalr	-1684(ra) # 80003fb4 <end_op>
    return -1;
    80005650:	54fd                	li	s1,-1
    80005652:	b761                	j	800055da <sys_open+0xe2>
      fileclose(f);
    80005654:	854e                	mv	a0,s3
    80005656:	fffff097          	auipc	ra,0xfffff
    8000565a:	db0080e7          	jalr	-592(ra) # 80004406 <fileclose>
    iunlockput(ip);
    8000565e:	854a                	mv	a0,s2
    80005660:	ffffe097          	auipc	ra,0xffffe
    80005664:	188080e7          	jalr	392(ra) # 800037e8 <iunlockput>
    end_op();
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	94c080e7          	jalr	-1716(ra) # 80003fb4 <end_op>
    return -1;
    80005670:	54fd                	li	s1,-1
    80005672:	b7a5                	j	800055da <sys_open+0xe2>
    f->type = FD_DEVICE;
    80005674:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005678:	04691783          	lh	a5,70(s2)
    8000567c:	02f99223          	sh	a5,36(s3)
    80005680:	bf29                	j	8000559a <sys_open+0xa2>
    itrunc(ip);
    80005682:	854a                	mv	a0,s2
    80005684:	ffffe097          	auipc	ra,0xffffe
    80005688:	010080e7          	jalr	16(ra) # 80003694 <itrunc>
    8000568c:	bf35                	j	800055c8 <sys_open+0xd0>

000000008000568e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000568e:	7175                	add	sp,sp,-144
    80005690:	e506                	sd	ra,136(sp)
    80005692:	e122                	sd	s0,128(sp)
    80005694:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005696:	fffff097          	auipc	ra,0xfffff
    8000569a:	8a4080e7          	jalr	-1884(ra) # 80003f3a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000569e:	08000613          	li	a2,128
    800056a2:	f7040593          	add	a1,s0,-144
    800056a6:	4501                	li	a0,0
    800056a8:	ffffd097          	auipc	ra,0xffffd
    800056ac:	3b8080e7          	jalr	952(ra) # 80002a60 <argstr>
    800056b0:	02054963          	bltz	a0,800056e2 <sys_mkdir+0x54>
    800056b4:	4681                	li	a3,0
    800056b6:	4601                	li	a2,0
    800056b8:	4585                	li	a1,1
    800056ba:	f7040513          	add	a0,s0,-144
    800056be:	00000097          	auipc	ra,0x0
    800056c2:	802080e7          	jalr	-2046(ra) # 80004ec0 <create>
    800056c6:	cd11                	beqz	a0,800056e2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800056c8:	ffffe097          	auipc	ra,0xffffe
    800056cc:	120080e7          	jalr	288(ra) # 800037e8 <iunlockput>
  end_op();
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	8e4080e7          	jalr	-1820(ra) # 80003fb4 <end_op>
  return 0;
    800056d8:	4501                	li	a0,0
}
    800056da:	60aa                	ld	ra,136(sp)
    800056dc:	640a                	ld	s0,128(sp)
    800056de:	6149                	add	sp,sp,144
    800056e0:	8082                	ret
    end_op();
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	8d2080e7          	jalr	-1838(ra) # 80003fb4 <end_op>
    return -1;
    800056ea:	557d                	li	a0,-1
    800056ec:	b7fd                	j	800056da <sys_mkdir+0x4c>

00000000800056ee <sys_mknod>:

uint64
sys_mknod(void)
{
    800056ee:	7135                	add	sp,sp,-160
    800056f0:	ed06                	sd	ra,152(sp)
    800056f2:	e922                	sd	s0,144(sp)
    800056f4:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	844080e7          	jalr	-1980(ra) # 80003f3a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800056fe:	08000613          	li	a2,128
    80005702:	f7040593          	add	a1,s0,-144
    80005706:	4501                	li	a0,0
    80005708:	ffffd097          	auipc	ra,0xffffd
    8000570c:	358080e7          	jalr	856(ra) # 80002a60 <argstr>
    80005710:	04054a63          	bltz	a0,80005764 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005714:	f6c40593          	add	a1,s0,-148
    80005718:	4505                	li	a0,1
    8000571a:	ffffd097          	auipc	ra,0xffffd
    8000571e:	302080e7          	jalr	770(ra) # 80002a1c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005722:	04054163          	bltz	a0,80005764 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005726:	f6840593          	add	a1,s0,-152
    8000572a:	4509                	li	a0,2
    8000572c:	ffffd097          	auipc	ra,0xffffd
    80005730:	2f0080e7          	jalr	752(ra) # 80002a1c <argint>
     argint(1, &major) < 0 ||
    80005734:	02054863          	bltz	a0,80005764 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005738:	f6841683          	lh	a3,-152(s0)
    8000573c:	f6c41603          	lh	a2,-148(s0)
    80005740:	458d                	li	a1,3
    80005742:	f7040513          	add	a0,s0,-144
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	77a080e7          	jalr	1914(ra) # 80004ec0 <create>
     argint(2, &minor) < 0 ||
    8000574e:	c919                	beqz	a0,80005764 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	098080e7          	jalr	152(ra) # 800037e8 <iunlockput>
  end_op();
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	85c080e7          	jalr	-1956(ra) # 80003fb4 <end_op>
  return 0;
    80005760:	4501                	li	a0,0
    80005762:	a031                	j	8000576e <sys_mknod+0x80>
    end_op();
    80005764:	fffff097          	auipc	ra,0xfffff
    80005768:	850080e7          	jalr	-1968(ra) # 80003fb4 <end_op>
    return -1;
    8000576c:	557d                	li	a0,-1
}
    8000576e:	60ea                	ld	ra,152(sp)
    80005770:	644a                	ld	s0,144(sp)
    80005772:	610d                	add	sp,sp,160
    80005774:	8082                	ret

0000000080005776 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005776:	7135                	add	sp,sp,-160
    80005778:	ed06                	sd	ra,152(sp)
    8000577a:	e922                	sd	s0,144(sp)
    8000577c:	e526                	sd	s1,136(sp)
    8000577e:	e14a                	sd	s2,128(sp)
    80005780:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005782:	ffffc097          	auipc	ra,0xffffc
    80005786:	1d8080e7          	jalr	472(ra) # 8000195a <myproc>
    8000578a:	892a                	mv	s2,a0
  
  begin_op();
    8000578c:	ffffe097          	auipc	ra,0xffffe
    80005790:	7ae080e7          	jalr	1966(ra) # 80003f3a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005794:	08000613          	li	a2,128
    80005798:	f6040593          	add	a1,s0,-160
    8000579c:	4501                	li	a0,0
    8000579e:	ffffd097          	auipc	ra,0xffffd
    800057a2:	2c2080e7          	jalr	706(ra) # 80002a60 <argstr>
    800057a6:	04054b63          	bltz	a0,800057fc <sys_chdir+0x86>
    800057aa:	f6040513          	add	a0,s0,-160
    800057ae:	ffffe097          	auipc	ra,0xffffe
    800057b2:	58c080e7          	jalr	1420(ra) # 80003d3a <namei>
    800057b6:	84aa                	mv	s1,a0
    800057b8:	c131                	beqz	a0,800057fc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800057ba:	ffffe097          	auipc	ra,0xffffe
    800057be:	dcc080e7          	jalr	-564(ra) # 80003586 <ilock>
  if(ip->type != T_DIR){
    800057c2:	04449703          	lh	a4,68(s1)
    800057c6:	4785                	li	a5,1
    800057c8:	04f71063          	bne	a4,a5,80005808 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800057cc:	8526                	mv	a0,s1
    800057ce:	ffffe097          	auipc	ra,0xffffe
    800057d2:	e7a080e7          	jalr	-390(ra) # 80003648 <iunlock>
  iput(p->cwd);
    800057d6:	15093503          	ld	a0,336(s2)
    800057da:	ffffe097          	auipc	ra,0xffffe
    800057de:	f66080e7          	jalr	-154(ra) # 80003740 <iput>
  end_op();
    800057e2:	ffffe097          	auipc	ra,0xffffe
    800057e6:	7d2080e7          	jalr	2002(ra) # 80003fb4 <end_op>
  p->cwd = ip;
    800057ea:	14993823          	sd	s1,336(s2)
  return 0;
    800057ee:	4501                	li	a0,0
}
    800057f0:	60ea                	ld	ra,152(sp)
    800057f2:	644a                	ld	s0,144(sp)
    800057f4:	64aa                	ld	s1,136(sp)
    800057f6:	690a                	ld	s2,128(sp)
    800057f8:	610d                	add	sp,sp,160
    800057fa:	8082                	ret
    end_op();
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	7b8080e7          	jalr	1976(ra) # 80003fb4 <end_op>
    return -1;
    80005804:	557d                	li	a0,-1
    80005806:	b7ed                	j	800057f0 <sys_chdir+0x7a>
    iunlockput(ip);
    80005808:	8526                	mv	a0,s1
    8000580a:	ffffe097          	auipc	ra,0xffffe
    8000580e:	fde080e7          	jalr	-34(ra) # 800037e8 <iunlockput>
    end_op();
    80005812:	ffffe097          	auipc	ra,0xffffe
    80005816:	7a2080e7          	jalr	1954(ra) # 80003fb4 <end_op>
    return -1;
    8000581a:	557d                	li	a0,-1
    8000581c:	bfd1                	j	800057f0 <sys_chdir+0x7a>

000000008000581e <sys_exec>:

uint64
sys_exec(void)
{
    8000581e:	7121                	add	sp,sp,-448
    80005820:	ff06                	sd	ra,440(sp)
    80005822:	fb22                	sd	s0,432(sp)
    80005824:	f726                	sd	s1,424(sp)
    80005826:	f34a                	sd	s2,416(sp)
    80005828:	ef4e                	sd	s3,408(sp)
    8000582a:	eb52                	sd	s4,400(sp)
    8000582c:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000582e:	08000613          	li	a2,128
    80005832:	f5040593          	add	a1,s0,-176
    80005836:	4501                	li	a0,0
    80005838:	ffffd097          	auipc	ra,0xffffd
    8000583c:	228080e7          	jalr	552(ra) # 80002a60 <argstr>
    return -1;
    80005840:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005842:	0c054a63          	bltz	a0,80005916 <sys_exec+0xf8>
    80005846:	e4840593          	add	a1,s0,-440
    8000584a:	4505                	li	a0,1
    8000584c:	ffffd097          	auipc	ra,0xffffd
    80005850:	1f2080e7          	jalr	498(ra) # 80002a3e <argaddr>
    80005854:	0c054163          	bltz	a0,80005916 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005858:	10000613          	li	a2,256
    8000585c:	4581                	li	a1,0
    8000585e:	e5040513          	add	a0,s0,-432
    80005862:	ffffb097          	auipc	ra,0xffffb
    80005866:	49c080e7          	jalr	1180(ra) # 80000cfe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000586a:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000586e:	89a6                	mv	s3,s1
    80005870:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005872:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005876:	00391513          	sll	a0,s2,0x3
    8000587a:	e4040593          	add	a1,s0,-448
    8000587e:	e4843783          	ld	a5,-440(s0)
    80005882:	953e                	add	a0,a0,a5
    80005884:	ffffd097          	auipc	ra,0xffffd
    80005888:	0fe080e7          	jalr	254(ra) # 80002982 <fetchaddr>
    8000588c:	02054a63          	bltz	a0,800058c0 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005890:	e4043783          	ld	a5,-448(s0)
    80005894:	c3b9                	beqz	a5,800058da <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005896:	ffffb097          	auipc	ra,0xffffb
    8000589a:	27c080e7          	jalr	636(ra) # 80000b12 <kalloc>
    8000589e:	85aa                	mv	a1,a0
    800058a0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800058a4:	cd11                	beqz	a0,800058c0 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800058a6:	6605                	lui	a2,0x1
    800058a8:	e4043503          	ld	a0,-448(s0)
    800058ac:	ffffd097          	auipc	ra,0xffffd
    800058b0:	128080e7          	jalr	296(ra) # 800029d4 <fetchstr>
    800058b4:	00054663          	bltz	a0,800058c0 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800058b8:	0905                	add	s2,s2,1
    800058ba:	09a1                	add	s3,s3,8
    800058bc:	fb491de3          	bne	s2,s4,80005876 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800058c0:	f5040913          	add	s2,s0,-176
    800058c4:	6088                	ld	a0,0(s1)
    800058c6:	c539                	beqz	a0,80005914 <sys_exec+0xf6>
    kfree(argv[i]);
    800058c8:	ffffb097          	auipc	ra,0xffffb
    800058cc:	14c080e7          	jalr	332(ra) # 80000a14 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800058d0:	04a1                	add	s1,s1,8
    800058d2:	ff2499e3          	bne	s1,s2,800058c4 <sys_exec+0xa6>
  return -1;
    800058d6:	597d                	li	s2,-1
    800058d8:	a83d                	j	80005916 <sys_exec+0xf8>
      argv[i] = 0;
    800058da:	0009079b          	sext.w	a5,s2
    800058de:	078e                	sll	a5,a5,0x3
    800058e0:	fd078793          	add	a5,a5,-48
    800058e4:	97a2                	add	a5,a5,s0
    800058e6:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800058ea:	e5040593          	add	a1,s0,-432
    800058ee:	f5040513          	add	a0,s0,-176
    800058f2:	fffff097          	auipc	ra,0xfffff
    800058f6:	196080e7          	jalr	406(ra) # 80004a88 <exec>
    800058fa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800058fc:	f5040993          	add	s3,s0,-176
    80005900:	6088                	ld	a0,0(s1)
    80005902:	c911                	beqz	a0,80005916 <sys_exec+0xf8>
    kfree(argv[i]);
    80005904:	ffffb097          	auipc	ra,0xffffb
    80005908:	110080e7          	jalr	272(ra) # 80000a14 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000590c:	04a1                	add	s1,s1,8
    8000590e:	ff3499e3          	bne	s1,s3,80005900 <sys_exec+0xe2>
    80005912:	a011                	j	80005916 <sys_exec+0xf8>
  return -1;
    80005914:	597d                	li	s2,-1
}
    80005916:	854a                	mv	a0,s2
    80005918:	70fa                	ld	ra,440(sp)
    8000591a:	745a                	ld	s0,432(sp)
    8000591c:	74ba                	ld	s1,424(sp)
    8000591e:	791a                	ld	s2,416(sp)
    80005920:	69fa                	ld	s3,408(sp)
    80005922:	6a5a                	ld	s4,400(sp)
    80005924:	6139                	add	sp,sp,448
    80005926:	8082                	ret

0000000080005928 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005928:	7139                	add	sp,sp,-64
    8000592a:	fc06                	sd	ra,56(sp)
    8000592c:	f822                	sd	s0,48(sp)
    8000592e:	f426                	sd	s1,40(sp)
    80005930:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	028080e7          	jalr	40(ra) # 8000195a <myproc>
    8000593a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000593c:	fd840593          	add	a1,s0,-40
    80005940:	4501                	li	a0,0
    80005942:	ffffd097          	auipc	ra,0xffffd
    80005946:	0fc080e7          	jalr	252(ra) # 80002a3e <argaddr>
    return -1;
    8000594a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000594c:	0e054063          	bltz	a0,80005a2c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005950:	fc840593          	add	a1,s0,-56
    80005954:	fd040513          	add	a0,s0,-48
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	e04080e7          	jalr	-508(ra) # 8000475c <pipealloc>
    return -1;
    80005960:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005962:	0c054563          	bltz	a0,80005a2c <sys_pipe+0x104>
  fd0 = -1;
    80005966:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000596a:	fd043503          	ld	a0,-48(s0)
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	510080e7          	jalr	1296(ra) # 80004e7e <fdalloc>
    80005976:	fca42223          	sw	a0,-60(s0)
    8000597a:	08054c63          	bltz	a0,80005a12 <sys_pipe+0xea>
    8000597e:	fc843503          	ld	a0,-56(s0)
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	4fc080e7          	jalr	1276(ra) # 80004e7e <fdalloc>
    8000598a:	fca42023          	sw	a0,-64(s0)
    8000598e:	06054963          	bltz	a0,80005a00 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005992:	4691                	li	a3,4
    80005994:	fc440613          	add	a2,s0,-60
    80005998:	fd843583          	ld	a1,-40(s0)
    8000599c:	68a8                	ld	a0,80(s1)
    8000599e:	ffffc097          	auipc	ra,0xffffc
    800059a2:	cb2080e7          	jalr	-846(ra) # 80001650 <copyout>
    800059a6:	02054063          	bltz	a0,800059c6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800059aa:	4691                	li	a3,4
    800059ac:	fc040613          	add	a2,s0,-64
    800059b0:	fd843583          	ld	a1,-40(s0)
    800059b4:	0591                	add	a1,a1,4
    800059b6:	68a8                	ld	a0,80(s1)
    800059b8:	ffffc097          	auipc	ra,0xffffc
    800059bc:	c98080e7          	jalr	-872(ra) # 80001650 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800059c0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800059c2:	06055563          	bgez	a0,80005a2c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800059c6:	fc442783          	lw	a5,-60(s0)
    800059ca:	07e9                	add	a5,a5,26
    800059cc:	078e                	sll	a5,a5,0x3
    800059ce:	97a6                	add	a5,a5,s1
    800059d0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800059d4:	fc042783          	lw	a5,-64(s0)
    800059d8:	07e9                	add	a5,a5,26
    800059da:	078e                	sll	a5,a5,0x3
    800059dc:	00f48533          	add	a0,s1,a5
    800059e0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800059e4:	fd043503          	ld	a0,-48(s0)
    800059e8:	fffff097          	auipc	ra,0xfffff
    800059ec:	a1e080e7          	jalr	-1506(ra) # 80004406 <fileclose>
    fileclose(wf);
    800059f0:	fc843503          	ld	a0,-56(s0)
    800059f4:	fffff097          	auipc	ra,0xfffff
    800059f8:	a12080e7          	jalr	-1518(ra) # 80004406 <fileclose>
    return -1;
    800059fc:	57fd                	li	a5,-1
    800059fe:	a03d                	j	80005a2c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005a00:	fc442783          	lw	a5,-60(s0)
    80005a04:	0007c763          	bltz	a5,80005a12 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005a08:	07e9                	add	a5,a5,26
    80005a0a:	078e                	sll	a5,a5,0x3
    80005a0c:	97a6                	add	a5,a5,s1
    80005a0e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005a12:	fd043503          	ld	a0,-48(s0)
    80005a16:	fffff097          	auipc	ra,0xfffff
    80005a1a:	9f0080e7          	jalr	-1552(ra) # 80004406 <fileclose>
    fileclose(wf);
    80005a1e:	fc843503          	ld	a0,-56(s0)
    80005a22:	fffff097          	auipc	ra,0xfffff
    80005a26:	9e4080e7          	jalr	-1564(ra) # 80004406 <fileclose>
    return -1;
    80005a2a:	57fd                	li	a5,-1
}
    80005a2c:	853e                	mv	a0,a5
    80005a2e:	70e2                	ld	ra,56(sp)
    80005a30:	7442                	ld	s0,48(sp)
    80005a32:	74a2                	ld	s1,40(sp)
    80005a34:	6121                	add	sp,sp,64
    80005a36:	8082                	ret
	...

0000000080005a40 <kernelvec>:
    80005a40:	7111                	add	sp,sp,-256
    80005a42:	e006                	sd	ra,0(sp)
    80005a44:	e40a                	sd	sp,8(sp)
    80005a46:	e80e                	sd	gp,16(sp)
    80005a48:	ec12                	sd	tp,24(sp)
    80005a4a:	f016                	sd	t0,32(sp)
    80005a4c:	f41a                	sd	t1,40(sp)
    80005a4e:	f81e                	sd	t2,48(sp)
    80005a50:	fc22                	sd	s0,56(sp)
    80005a52:	e0a6                	sd	s1,64(sp)
    80005a54:	e4aa                	sd	a0,72(sp)
    80005a56:	e8ae                	sd	a1,80(sp)
    80005a58:	ecb2                	sd	a2,88(sp)
    80005a5a:	f0b6                	sd	a3,96(sp)
    80005a5c:	f4ba                	sd	a4,104(sp)
    80005a5e:	f8be                	sd	a5,112(sp)
    80005a60:	fcc2                	sd	a6,120(sp)
    80005a62:	e146                	sd	a7,128(sp)
    80005a64:	e54a                	sd	s2,136(sp)
    80005a66:	e94e                	sd	s3,144(sp)
    80005a68:	ed52                	sd	s4,152(sp)
    80005a6a:	f156                	sd	s5,160(sp)
    80005a6c:	f55a                	sd	s6,168(sp)
    80005a6e:	f95e                	sd	s7,176(sp)
    80005a70:	fd62                	sd	s8,184(sp)
    80005a72:	e1e6                	sd	s9,192(sp)
    80005a74:	e5ea                	sd	s10,200(sp)
    80005a76:	e9ee                	sd	s11,208(sp)
    80005a78:	edf2                	sd	t3,216(sp)
    80005a7a:	f1f6                	sd	t4,224(sp)
    80005a7c:	f5fa                	sd	t5,232(sp)
    80005a7e:	f9fe                	sd	t6,240(sp)
    80005a80:	dcffc0ef          	jal	8000284e <kerneltrap>
    80005a84:	6082                	ld	ra,0(sp)
    80005a86:	6122                	ld	sp,8(sp)
    80005a88:	61c2                	ld	gp,16(sp)
    80005a8a:	7282                	ld	t0,32(sp)
    80005a8c:	7322                	ld	t1,40(sp)
    80005a8e:	73c2                	ld	t2,48(sp)
    80005a90:	7462                	ld	s0,56(sp)
    80005a92:	6486                	ld	s1,64(sp)
    80005a94:	6526                	ld	a0,72(sp)
    80005a96:	65c6                	ld	a1,80(sp)
    80005a98:	6666                	ld	a2,88(sp)
    80005a9a:	7686                	ld	a3,96(sp)
    80005a9c:	7726                	ld	a4,104(sp)
    80005a9e:	77c6                	ld	a5,112(sp)
    80005aa0:	7866                	ld	a6,120(sp)
    80005aa2:	688a                	ld	a7,128(sp)
    80005aa4:	692a                	ld	s2,136(sp)
    80005aa6:	69ca                	ld	s3,144(sp)
    80005aa8:	6a6a                	ld	s4,152(sp)
    80005aaa:	7a8a                	ld	s5,160(sp)
    80005aac:	7b2a                	ld	s6,168(sp)
    80005aae:	7bca                	ld	s7,176(sp)
    80005ab0:	7c6a                	ld	s8,184(sp)
    80005ab2:	6c8e                	ld	s9,192(sp)
    80005ab4:	6d2e                	ld	s10,200(sp)
    80005ab6:	6dce                	ld	s11,208(sp)
    80005ab8:	6e6e                	ld	t3,216(sp)
    80005aba:	7e8e                	ld	t4,224(sp)
    80005abc:	7f2e                	ld	t5,232(sp)
    80005abe:	7fce                	ld	t6,240(sp)
    80005ac0:	6111                	add	sp,sp,256
    80005ac2:	10200073          	sret
    80005ac6:	00000013          	nop
    80005aca:	00000013          	nop
    80005ace:	0001                	nop

0000000080005ad0 <timervec>:
    80005ad0:	34051573          	csrrw	a0,mscratch,a0
    80005ad4:	e10c                	sd	a1,0(a0)
    80005ad6:	e510                	sd	a2,8(a0)
    80005ad8:	e914                	sd	a3,16(a0)
    80005ada:	6d0c                	ld	a1,24(a0)
    80005adc:	7110                	ld	a2,32(a0)
    80005ade:	6194                	ld	a3,0(a1)
    80005ae0:	96b2                	add	a3,a3,a2
    80005ae2:	e194                	sd	a3,0(a1)
    80005ae4:	4589                	li	a1,2
    80005ae6:	14459073          	csrw	sip,a1
    80005aea:	6914                	ld	a3,16(a0)
    80005aec:	6510                	ld	a2,8(a0)
    80005aee:	610c                	ld	a1,0(a0)
    80005af0:	34051573          	csrrw	a0,mscratch,a0
    80005af4:	30200073          	mret
	...

0000000080005afa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005afa:	1141                	add	sp,sp,-16
    80005afc:	e422                	sd	s0,8(sp)
    80005afe:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005b00:	0c0007b7          	lui	a5,0xc000
    80005b04:	4705                	li	a4,1
    80005b06:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005b08:	c3d8                	sw	a4,4(a5)
}
    80005b0a:	6422                	ld	s0,8(sp)
    80005b0c:	0141                	add	sp,sp,16
    80005b0e:	8082                	ret

0000000080005b10 <plicinithart>:

void
plicinithart(void)
{
    80005b10:	1141                	add	sp,sp,-16
    80005b12:	e406                	sd	ra,8(sp)
    80005b14:	e022                	sd	s0,0(sp)
    80005b16:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005b18:	ffffc097          	auipc	ra,0xffffc
    80005b1c:	e16080e7          	jalr	-490(ra) # 8000192e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005b20:	0085171b          	sllw	a4,a0,0x8
    80005b24:	0c0027b7          	lui	a5,0xc002
    80005b28:	97ba                	add	a5,a5,a4
    80005b2a:	40200713          	li	a4,1026
    80005b2e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005b32:	00d5151b          	sllw	a0,a0,0xd
    80005b36:	0c2017b7          	lui	a5,0xc201
    80005b3a:	97aa                	add	a5,a5,a0
    80005b3c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005b40:	60a2                	ld	ra,8(sp)
    80005b42:	6402                	ld	s0,0(sp)
    80005b44:	0141                	add	sp,sp,16
    80005b46:	8082                	ret

0000000080005b48 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005b48:	1141                	add	sp,sp,-16
    80005b4a:	e406                	sd	ra,8(sp)
    80005b4c:	e022                	sd	s0,0(sp)
    80005b4e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005b50:	ffffc097          	auipc	ra,0xffffc
    80005b54:	dde080e7          	jalr	-546(ra) # 8000192e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005b58:	00d5151b          	sllw	a0,a0,0xd
    80005b5c:	0c2017b7          	lui	a5,0xc201
    80005b60:	97aa                	add	a5,a5,a0
  return irq;
}
    80005b62:	43c8                	lw	a0,4(a5)
    80005b64:	60a2                	ld	ra,8(sp)
    80005b66:	6402                	ld	s0,0(sp)
    80005b68:	0141                	add	sp,sp,16
    80005b6a:	8082                	ret

0000000080005b6c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005b6c:	1101                	add	sp,sp,-32
    80005b6e:	ec06                	sd	ra,24(sp)
    80005b70:	e822                	sd	s0,16(sp)
    80005b72:	e426                	sd	s1,8(sp)
    80005b74:	1000                	add	s0,sp,32
    80005b76:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	db6080e7          	jalr	-586(ra) # 8000192e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005b80:	00d5151b          	sllw	a0,a0,0xd
    80005b84:	0c2017b7          	lui	a5,0xc201
    80005b88:	97aa                	add	a5,a5,a0
    80005b8a:	c3c4                	sw	s1,4(a5)
}
    80005b8c:	60e2                	ld	ra,24(sp)
    80005b8e:	6442                	ld	s0,16(sp)
    80005b90:	64a2                	ld	s1,8(sp)
    80005b92:	6105                	add	sp,sp,32
    80005b94:	8082                	ret

0000000080005b96 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005b96:	1141                	add	sp,sp,-16
    80005b98:	e406                	sd	ra,8(sp)
    80005b9a:	e022                	sd	s0,0(sp)
    80005b9c:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005b9e:	479d                	li	a5,7
    80005ba0:	06a7c863          	blt	a5,a0,80005c10 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005ba4:	0001d717          	auipc	a4,0x1d
    80005ba8:	45c70713          	add	a4,a4,1116 # 80023000 <disk>
    80005bac:	972a                	add	a4,a4,a0
    80005bae:	6789                	lui	a5,0x2
    80005bb0:	97ba                	add	a5,a5,a4
    80005bb2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005bb6:	e7ad                	bnez	a5,80005c20 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005bb8:	00451793          	sll	a5,a0,0x4
    80005bbc:	0001f717          	auipc	a4,0x1f
    80005bc0:	44470713          	add	a4,a4,1092 # 80025000 <disk+0x2000>
    80005bc4:	6314                	ld	a3,0(a4)
    80005bc6:	96be                	add	a3,a3,a5
    80005bc8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005bcc:	6314                	ld	a3,0(a4)
    80005bce:	96be                	add	a3,a3,a5
    80005bd0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005bd4:	6314                	ld	a3,0(a4)
    80005bd6:	96be                	add	a3,a3,a5
    80005bd8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005bdc:	6318                	ld	a4,0(a4)
    80005bde:	97ba                	add	a5,a5,a4
    80005be0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005be4:	0001d717          	auipc	a4,0x1d
    80005be8:	41c70713          	add	a4,a4,1052 # 80023000 <disk>
    80005bec:	972a                	add	a4,a4,a0
    80005bee:	6789                	lui	a5,0x2
    80005bf0:	97ba                	add	a5,a5,a4
    80005bf2:	4705                	li	a4,1
    80005bf4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005bf8:	0001f517          	auipc	a0,0x1f
    80005bfc:	42050513          	add	a0,a0,1056 # 80025018 <disk+0x2018>
    80005c00:	ffffc097          	auipc	ra,0xffffc
    80005c04:	6f0080e7          	jalr	1776(ra) # 800022f0 <wakeup>
}
    80005c08:	60a2                	ld	ra,8(sp)
    80005c0a:	6402                	ld	s0,0(sp)
    80005c0c:	0141                	add	sp,sp,16
    80005c0e:	8082                	ret
    panic("free_desc 1");
    80005c10:	00003517          	auipc	a0,0x3
    80005c14:	b4050513          	add	a0,a0,-1216 # 80008750 <syscalls+0x330>
    80005c18:	ffffb097          	auipc	ra,0xffffb
    80005c1c:	930080e7          	jalr	-1744(ra) # 80000548 <panic>
    panic("free_desc 2");
    80005c20:	00003517          	auipc	a0,0x3
    80005c24:	b4050513          	add	a0,a0,-1216 # 80008760 <syscalls+0x340>
    80005c28:	ffffb097          	auipc	ra,0xffffb
    80005c2c:	920080e7          	jalr	-1760(ra) # 80000548 <panic>

0000000080005c30 <virtio_disk_init>:
{
    80005c30:	1101                	add	sp,sp,-32
    80005c32:	ec06                	sd	ra,24(sp)
    80005c34:	e822                	sd	s0,16(sp)
    80005c36:	e426                	sd	s1,8(sp)
    80005c38:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005c3a:	00003597          	auipc	a1,0x3
    80005c3e:	b3658593          	add	a1,a1,-1226 # 80008770 <syscalls+0x350>
    80005c42:	0001f517          	auipc	a0,0x1f
    80005c46:	4e650513          	add	a0,a0,1254 # 80025128 <disk+0x2128>
    80005c4a:	ffffb097          	auipc	ra,0xffffb
    80005c4e:	f28080e7          	jalr	-216(ra) # 80000b72 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005c52:	100017b7          	lui	a5,0x10001
    80005c56:	4398                	lw	a4,0(a5)
    80005c58:	2701                	sext.w	a4,a4
    80005c5a:	747277b7          	lui	a5,0x74727
    80005c5e:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005c62:	0ef71063          	bne	a4,a5,80005d42 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005c66:	100017b7          	lui	a5,0x10001
    80005c6a:	43dc                	lw	a5,4(a5)
    80005c6c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005c6e:	4705                	li	a4,1
    80005c70:	0ce79963          	bne	a5,a4,80005d42 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005c74:	100017b7          	lui	a5,0x10001
    80005c78:	479c                	lw	a5,8(a5)
    80005c7a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005c7c:	4709                	li	a4,2
    80005c7e:	0ce79263          	bne	a5,a4,80005d42 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005c82:	100017b7          	lui	a5,0x10001
    80005c86:	47d8                	lw	a4,12(a5)
    80005c88:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005c8a:	554d47b7          	lui	a5,0x554d4
    80005c8e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005c92:	0af71863          	bne	a4,a5,80005d42 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005c96:	100017b7          	lui	a5,0x10001
    80005c9a:	4705                	li	a4,1
    80005c9c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005c9e:	470d                	li	a4,3
    80005ca0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ca2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005ca4:	c7ffe6b7          	lui	a3,0xc7ffe
    80005ca8:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005cac:	8f75                	and	a4,a4,a3
    80005cae:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cb0:	472d                	li	a4,11
    80005cb2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cb4:	473d                	li	a4,15
    80005cb6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005cb8:	6705                	lui	a4,0x1
    80005cba:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005cbc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005cc0:	5bdc                	lw	a5,52(a5)
    80005cc2:	2781                	sext.w	a5,a5
  if(max == 0)
    80005cc4:	c7d9                	beqz	a5,80005d52 <virtio_disk_init+0x122>
  if(max < NUM)
    80005cc6:	471d                	li	a4,7
    80005cc8:	08f77d63          	bgeu	a4,a5,80005d62 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005ccc:	100014b7          	lui	s1,0x10001
    80005cd0:	47a1                	li	a5,8
    80005cd2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005cd4:	6609                	lui	a2,0x2
    80005cd6:	4581                	li	a1,0
    80005cd8:	0001d517          	auipc	a0,0x1d
    80005cdc:	32850513          	add	a0,a0,808 # 80023000 <disk>
    80005ce0:	ffffb097          	auipc	ra,0xffffb
    80005ce4:	01e080e7          	jalr	30(ra) # 80000cfe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005ce8:	0001d717          	auipc	a4,0x1d
    80005cec:	31870713          	add	a4,a4,792 # 80023000 <disk>
    80005cf0:	00c75793          	srl	a5,a4,0xc
    80005cf4:	2781                	sext.w	a5,a5
    80005cf6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005cf8:	0001f797          	auipc	a5,0x1f
    80005cfc:	30878793          	add	a5,a5,776 # 80025000 <disk+0x2000>
    80005d00:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005d02:	0001d717          	auipc	a4,0x1d
    80005d06:	37e70713          	add	a4,a4,894 # 80023080 <disk+0x80>
    80005d0a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005d0c:	0001e717          	auipc	a4,0x1e
    80005d10:	2f470713          	add	a4,a4,756 # 80024000 <disk+0x1000>
    80005d14:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005d16:	4705                	li	a4,1
    80005d18:	00e78c23          	sb	a4,24(a5)
    80005d1c:	00e78ca3          	sb	a4,25(a5)
    80005d20:	00e78d23          	sb	a4,26(a5)
    80005d24:	00e78da3          	sb	a4,27(a5)
    80005d28:	00e78e23          	sb	a4,28(a5)
    80005d2c:	00e78ea3          	sb	a4,29(a5)
    80005d30:	00e78f23          	sb	a4,30(a5)
    80005d34:	00e78fa3          	sb	a4,31(a5)
}
    80005d38:	60e2                	ld	ra,24(sp)
    80005d3a:	6442                	ld	s0,16(sp)
    80005d3c:	64a2                	ld	s1,8(sp)
    80005d3e:	6105                	add	sp,sp,32
    80005d40:	8082                	ret
    panic("could not find virtio disk");
    80005d42:	00003517          	auipc	a0,0x3
    80005d46:	a3e50513          	add	a0,a0,-1474 # 80008780 <syscalls+0x360>
    80005d4a:	ffffa097          	auipc	ra,0xffffa
    80005d4e:	7fe080e7          	jalr	2046(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    80005d52:	00003517          	auipc	a0,0x3
    80005d56:	a4e50513          	add	a0,a0,-1458 # 800087a0 <syscalls+0x380>
    80005d5a:	ffffa097          	auipc	ra,0xffffa
    80005d5e:	7ee080e7          	jalr	2030(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    80005d62:	00003517          	auipc	a0,0x3
    80005d66:	a5e50513          	add	a0,a0,-1442 # 800087c0 <syscalls+0x3a0>
    80005d6a:	ffffa097          	auipc	ra,0xffffa
    80005d6e:	7de080e7          	jalr	2014(ra) # 80000548 <panic>

0000000080005d72 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005d72:	7159                	add	sp,sp,-112
    80005d74:	f486                	sd	ra,104(sp)
    80005d76:	f0a2                	sd	s0,96(sp)
    80005d78:	eca6                	sd	s1,88(sp)
    80005d7a:	e8ca                	sd	s2,80(sp)
    80005d7c:	e4ce                	sd	s3,72(sp)
    80005d7e:	e0d2                	sd	s4,64(sp)
    80005d80:	fc56                	sd	s5,56(sp)
    80005d82:	f85a                	sd	s6,48(sp)
    80005d84:	f45e                	sd	s7,40(sp)
    80005d86:	f062                	sd	s8,32(sp)
    80005d88:	ec66                	sd	s9,24(sp)
    80005d8a:	e86a                	sd	s10,16(sp)
    80005d8c:	1880                	add	s0,sp,112
    80005d8e:	8a2a                	mv	s4,a0
    80005d90:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005d92:	00c52c03          	lw	s8,12(a0)
    80005d96:	001c1c1b          	sllw	s8,s8,0x1
    80005d9a:	1c02                	sll	s8,s8,0x20
    80005d9c:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005da0:	0001f517          	auipc	a0,0x1f
    80005da4:	38850513          	add	a0,a0,904 # 80025128 <disk+0x2128>
    80005da8:	ffffb097          	auipc	ra,0xffffb
    80005dac:	e5a080e7          	jalr	-422(ra) # 80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005db0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005db2:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005db4:	0001db97          	auipc	s7,0x1d
    80005db8:	24cb8b93          	add	s7,s7,588 # 80023000 <disk>
    80005dbc:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005dbe:	4a8d                	li	s5,3
    80005dc0:	a0b5                	j	80005e2c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005dc2:	00fb8733          	add	a4,s7,a5
    80005dc6:	975a                	add	a4,a4,s6
    80005dc8:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005dcc:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005dce:	0207c563          	bltz	a5,80005df8 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80005dd2:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    80005dd4:	0591                	add	a1,a1,4
    80005dd6:	19560c63          	beq	a2,s5,80005f6e <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80005dda:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005ddc:	0001f717          	auipc	a4,0x1f
    80005de0:	23c70713          	add	a4,a4,572 # 80025018 <disk+0x2018>
    80005de4:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005de6:	00074683          	lbu	a3,0(a4)
    80005dea:	fee1                	bnez	a3,80005dc2 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005dec:	2785                	addw	a5,a5,1
    80005dee:	0705                	add	a4,a4,1
    80005df0:	fe979be3          	bne	a5,s1,80005de6 <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005df4:	57fd                	li	a5,-1
    80005df6:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005df8:	00c05e63          	blez	a2,80005e14 <virtio_disk_rw+0xa2>
    80005dfc:	060a                	sll	a2,a2,0x2
    80005dfe:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005e02:	0009a503          	lw	a0,0(s3)
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	d90080e7          	jalr	-624(ra) # 80005b96 <free_desc>
      for(int j = 0; j < i; j++)
    80005e0e:	0991                	add	s3,s3,4
    80005e10:	ffa999e3          	bne	s3,s10,80005e02 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005e14:	0001f597          	auipc	a1,0x1f
    80005e18:	31458593          	add	a1,a1,788 # 80025128 <disk+0x2128>
    80005e1c:	0001f517          	auipc	a0,0x1f
    80005e20:	1fc50513          	add	a0,a0,508 # 80025018 <disk+0x2018>
    80005e24:	ffffc097          	auipc	ra,0xffffc
    80005e28:	34c080e7          	jalr	844(ra) # 80002170 <sleep>
  for(int i = 0; i < 3; i++){
    80005e2c:	f9040993          	add	s3,s0,-112
{
    80005e30:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005e32:	864a                	mv	a2,s2
    80005e34:	b75d                	j	80005dda <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005e36:	0001f697          	auipc	a3,0x1f
    80005e3a:	1ca6b683          	ld	a3,458(a3) # 80025000 <disk+0x2000>
    80005e3e:	96ba                	add	a3,a3,a4
    80005e40:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005e44:	0001d817          	auipc	a6,0x1d
    80005e48:	1bc80813          	add	a6,a6,444 # 80023000 <disk>
    80005e4c:	0001f697          	auipc	a3,0x1f
    80005e50:	1b468693          	add	a3,a3,436 # 80025000 <disk+0x2000>
    80005e54:	6290                	ld	a2,0(a3)
    80005e56:	963a                	add	a2,a2,a4
    80005e58:	00c65583          	lhu	a1,12(a2)
    80005e5c:	0015e593          	or	a1,a1,1
    80005e60:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005e64:	f9842603          	lw	a2,-104(s0)
    80005e68:	628c                	ld	a1,0(a3)
    80005e6a:	972e                	add	a4,a4,a1
    80005e6c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005e70:	20050593          	add	a1,a0,512
    80005e74:	0592                	sll	a1,a1,0x4
    80005e76:	95c2                	add	a1,a1,a6
    80005e78:	577d                	li	a4,-1
    80005e7a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005e7e:	00461713          	sll	a4,a2,0x4
    80005e82:	6290                	ld	a2,0(a3)
    80005e84:	963a                	add	a2,a2,a4
    80005e86:	03078793          	add	a5,a5,48
    80005e8a:	97c2                	add	a5,a5,a6
    80005e8c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005e8e:	629c                	ld	a5,0(a3)
    80005e90:	97ba                	add	a5,a5,a4
    80005e92:	4605                	li	a2,1
    80005e94:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005e96:	629c                	ld	a5,0(a3)
    80005e98:	97ba                	add	a5,a5,a4
    80005e9a:	4809                	li	a6,2
    80005e9c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005ea0:	629c                	ld	a5,0(a3)
    80005ea2:	97ba                	add	a5,a5,a4
    80005ea4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ea8:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005eac:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005eb0:	6698                	ld	a4,8(a3)
    80005eb2:	00275783          	lhu	a5,2(a4)
    80005eb6:	8b9d                	and	a5,a5,7
    80005eb8:	0786                	sll	a5,a5,0x1
    80005eba:	973e                	add	a4,a4,a5
    80005ebc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005ec0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005ec4:	6698                	ld	a4,8(a3)
    80005ec6:	00275783          	lhu	a5,2(a4)
    80005eca:	2785                	addw	a5,a5,1
    80005ecc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005ed0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ed4:	100017b7          	lui	a5,0x10001
    80005ed8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005edc:	004a2783          	lw	a5,4(s4)
    80005ee0:	02c79163          	bne	a5,a2,80005f02 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005ee4:	0001f917          	auipc	s2,0x1f
    80005ee8:	24490913          	add	s2,s2,580 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80005eec:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005eee:	85ca                	mv	a1,s2
    80005ef0:	8552                	mv	a0,s4
    80005ef2:	ffffc097          	auipc	ra,0xffffc
    80005ef6:	27e080e7          	jalr	638(ra) # 80002170 <sleep>
  while(b->disk == 1) {
    80005efa:	004a2783          	lw	a5,4(s4)
    80005efe:	fe9788e3          	beq	a5,s1,80005eee <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005f02:	f9042903          	lw	s2,-112(s0)
    80005f06:	20090713          	add	a4,s2,512
    80005f0a:	0712                	sll	a4,a4,0x4
    80005f0c:	0001d797          	auipc	a5,0x1d
    80005f10:	0f478793          	add	a5,a5,244 # 80023000 <disk>
    80005f14:	97ba                	add	a5,a5,a4
    80005f16:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005f1a:	0001f997          	auipc	s3,0x1f
    80005f1e:	0e698993          	add	s3,s3,230 # 80025000 <disk+0x2000>
    80005f22:	00491713          	sll	a4,s2,0x4
    80005f26:	0009b783          	ld	a5,0(s3)
    80005f2a:	97ba                	add	a5,a5,a4
    80005f2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005f30:	854a                	mv	a0,s2
    80005f32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	c60080e7          	jalr	-928(ra) # 80005b96 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005f3e:	8885                	and	s1,s1,1
    80005f40:	f0ed                	bnez	s1,80005f22 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005f42:	0001f517          	auipc	a0,0x1f
    80005f46:	1e650513          	add	a0,a0,486 # 80025128 <disk+0x2128>
    80005f4a:	ffffb097          	auipc	ra,0xffffb
    80005f4e:	d6c080e7          	jalr	-660(ra) # 80000cb6 <release>
}
    80005f52:	70a6                	ld	ra,104(sp)
    80005f54:	7406                	ld	s0,96(sp)
    80005f56:	64e6                	ld	s1,88(sp)
    80005f58:	6946                	ld	s2,80(sp)
    80005f5a:	69a6                	ld	s3,72(sp)
    80005f5c:	6a06                	ld	s4,64(sp)
    80005f5e:	7ae2                	ld	s5,56(sp)
    80005f60:	7b42                	ld	s6,48(sp)
    80005f62:	7ba2                	ld	s7,40(sp)
    80005f64:	7c02                	ld	s8,32(sp)
    80005f66:	6ce2                	ld	s9,24(sp)
    80005f68:	6d42                	ld	s10,16(sp)
    80005f6a:	6165                	add	sp,sp,112
    80005f6c:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f6e:	f9042503          	lw	a0,-112(s0)
    80005f72:	20050793          	add	a5,a0,512
    80005f76:	0792                	sll	a5,a5,0x4
  if(write)
    80005f78:	0001d817          	auipc	a6,0x1d
    80005f7c:	08880813          	add	a6,a6,136 # 80023000 <disk>
    80005f80:	00f80733          	add	a4,a6,a5
    80005f84:	019036b3          	snez	a3,s9
    80005f88:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80005f8c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005f90:	0b873823          	sd	s8,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f94:	7679                	lui	a2,0xffffe
    80005f96:	963e                	add	a2,a2,a5
    80005f98:	0001f697          	auipc	a3,0x1f
    80005f9c:	06868693          	add	a3,a3,104 # 80025000 <disk+0x2000>
    80005fa0:	6298                	ld	a4,0(a3)
    80005fa2:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005fa4:	0a878593          	add	a1,a5,168
    80005fa8:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005faa:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005fac:	6298                	ld	a4,0(a3)
    80005fae:	9732                	add	a4,a4,a2
    80005fb0:	45c1                	li	a1,16
    80005fb2:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005fb4:	6298                	ld	a4,0(a3)
    80005fb6:	9732                	add	a4,a4,a2
    80005fb8:	4585                	li	a1,1
    80005fba:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005fbe:	f9442703          	lw	a4,-108(s0)
    80005fc2:	628c                	ld	a1,0(a3)
    80005fc4:	962e                	add	a2,a2,a1
    80005fc6:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005fca:	0712                	sll	a4,a4,0x4
    80005fcc:	6290                	ld	a2,0(a3)
    80005fce:	963a                	add	a2,a2,a4
    80005fd0:	058a0593          	add	a1,s4,88
    80005fd4:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005fd6:	6294                	ld	a3,0(a3)
    80005fd8:	96ba                	add	a3,a3,a4
    80005fda:	40000613          	li	a2,1024
    80005fde:	c690                	sw	a2,8(a3)
  if(write)
    80005fe0:	e40c9be3          	bnez	s9,80005e36 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005fe4:	0001f697          	auipc	a3,0x1f
    80005fe8:	01c6b683          	ld	a3,28(a3) # 80025000 <disk+0x2000>
    80005fec:	96ba                	add	a3,a3,a4
    80005fee:	4609                	li	a2,2
    80005ff0:	00c69623          	sh	a2,12(a3)
    80005ff4:	bd81                	j	80005e44 <virtio_disk_rw+0xd2>

0000000080005ff6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ff6:	1101                	add	sp,sp,-32
    80005ff8:	ec06                	sd	ra,24(sp)
    80005ffa:	e822                	sd	s0,16(sp)
    80005ffc:	e426                	sd	s1,8(sp)
    80005ffe:	e04a                	sd	s2,0(sp)
    80006000:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006002:	0001f517          	auipc	a0,0x1f
    80006006:	12650513          	add	a0,a0,294 # 80025128 <disk+0x2128>
    8000600a:	ffffb097          	auipc	ra,0xffffb
    8000600e:	bf8080e7          	jalr	-1032(ra) # 80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006012:	10001737          	lui	a4,0x10001
    80006016:	533c                	lw	a5,96(a4)
    80006018:	8b8d                	and	a5,a5,3
    8000601a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000601c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006020:	0001f797          	auipc	a5,0x1f
    80006024:	fe078793          	add	a5,a5,-32 # 80025000 <disk+0x2000>
    80006028:	6b94                	ld	a3,16(a5)
    8000602a:	0207d703          	lhu	a4,32(a5)
    8000602e:	0026d783          	lhu	a5,2(a3)
    80006032:	06f70163          	beq	a4,a5,80006094 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006036:	0001d917          	auipc	s2,0x1d
    8000603a:	fca90913          	add	s2,s2,-54 # 80023000 <disk>
    8000603e:	0001f497          	auipc	s1,0x1f
    80006042:	fc248493          	add	s1,s1,-62 # 80025000 <disk+0x2000>
    __sync_synchronize();
    80006046:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000604a:	6898                	ld	a4,16(s1)
    8000604c:	0204d783          	lhu	a5,32(s1)
    80006050:	8b9d                	and	a5,a5,7
    80006052:	078e                	sll	a5,a5,0x3
    80006054:	97ba                	add	a5,a5,a4
    80006056:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006058:	20078713          	add	a4,a5,512
    8000605c:	0712                	sll	a4,a4,0x4
    8000605e:	974a                	add	a4,a4,s2
    80006060:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006064:	e731                	bnez	a4,800060b0 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006066:	20078793          	add	a5,a5,512
    8000606a:	0792                	sll	a5,a5,0x4
    8000606c:	97ca                	add	a5,a5,s2
    8000606e:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006070:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006074:	ffffc097          	auipc	ra,0xffffc
    80006078:	27c080e7          	jalr	636(ra) # 800022f0 <wakeup>

    disk.used_idx += 1;
    8000607c:	0204d783          	lhu	a5,32(s1)
    80006080:	2785                	addw	a5,a5,1
    80006082:	17c2                	sll	a5,a5,0x30
    80006084:	93c1                	srl	a5,a5,0x30
    80006086:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000608a:	6898                	ld	a4,16(s1)
    8000608c:	00275703          	lhu	a4,2(a4)
    80006090:	faf71be3          	bne	a4,a5,80006046 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006094:	0001f517          	auipc	a0,0x1f
    80006098:	09450513          	add	a0,a0,148 # 80025128 <disk+0x2128>
    8000609c:	ffffb097          	auipc	ra,0xffffb
    800060a0:	c1a080e7          	jalr	-998(ra) # 80000cb6 <release>
}
    800060a4:	60e2                	ld	ra,24(sp)
    800060a6:	6442                	ld	s0,16(sp)
    800060a8:	64a2                	ld	s1,8(sp)
    800060aa:	6902                	ld	s2,0(sp)
    800060ac:	6105                	add	sp,sp,32
    800060ae:	8082                	ret
      panic("virtio_disk_intr status");
    800060b0:	00002517          	auipc	a0,0x2
    800060b4:	73050513          	add	a0,a0,1840 # 800087e0 <syscalls+0x3c0>
    800060b8:	ffffa097          	auipc	ra,0xffffa
    800060bc:	490080e7          	jalr	1168(ra) # 80000548 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
