
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	add	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	80000086 <start>

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

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	sllw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	sllw	a5,a5,0x5
    80000048:	078e                	sll	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	add	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	c1478793          	add	a5,a5,-1004 # 80005c70 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	add	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	add	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e4878793          	add	a5,a5,-440 # 80000eee <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	add	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	add	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	add	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	add	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	b3a080e7          	jalr	-1222(ra) # 80000c46 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305c63          	blez	s3,8000016c <consolewrite+0x80>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	add	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	3b6080e7          	jalr	950(ra) # 800024dc <either_copyin>
    8000012e:	01550d63          	beq	a0,s5,80000148 <consolewrite+0x5c>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	796080e7          	jalr	1942(ra) # 800008cc <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addw	s2,s2,1
    80000140:	0485                	add	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
    80000146:	894e                	mv	s2,s3
  }
  release(&cons.lock);
    80000148:	00011517          	auipc	a0,0x11
    8000014c:	6e850513          	add	a0,a0,1768 # 80011830 <cons>
    80000150:	00001097          	auipc	ra,0x1
    80000154:	baa080e7          	jalr	-1110(ra) # 80000cfa <release>

  return i;
}
    80000158:	854a                	mv	a0,s2
    8000015a:	60a6                	ld	ra,72(sp)
    8000015c:	6406                	ld	s0,64(sp)
    8000015e:	74e2                	ld	s1,56(sp)
    80000160:	7942                	ld	s2,48(sp)
    80000162:	79a2                	ld	s3,40(sp)
    80000164:	7a02                	ld	s4,32(sp)
    80000166:	6ae2                	ld	s5,24(sp)
    80000168:	6161                	add	sp,sp,80
    8000016a:	8082                	ret
  for(i = 0; i < n; i++){
    8000016c:	4901                	li	s2,0
    8000016e:	bfe9                	j	80000148 <consolewrite+0x5c>

0000000080000170 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000170:	711d                	add	sp,sp,-96
    80000172:	ec86                	sd	ra,88(sp)
    80000174:	e8a2                	sd	s0,80(sp)
    80000176:	e4a6                	sd	s1,72(sp)
    80000178:	e0ca                	sd	s2,64(sp)
    8000017a:	fc4e                	sd	s3,56(sp)
    8000017c:	f852                	sd	s4,48(sp)
    8000017e:	f456                	sd	s5,40(sp)
    80000180:	f05a                	sd	s6,32(sp)
    80000182:	ec5e                	sd	s7,24(sp)
    80000184:	1080                	add	s0,sp,96
    80000186:	8aaa                	mv	s5,a0
    80000188:	8a2e                	mv	s4,a1
    8000018a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000018c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000190:	00011517          	auipc	a0,0x11
    80000194:	6a050513          	add	a0,a0,1696 # 80011830 <cons>
    80000198:	00001097          	auipc	ra,0x1
    8000019c:	aae080e7          	jalr	-1362(ra) # 80000c46 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a0:	00011497          	auipc	s1,0x11
    800001a4:	69048493          	add	s1,s1,1680 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a8:	00011917          	auipc	s2,0x11
    800001ac:	72090913          	add	s2,s2,1824 # 800118c8 <cons+0x98>
  while(n > 0){
    800001b0:	07305f63          	blez	s3,8000022e <consoleread+0xbe>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71463          	bne	a4,a5,800001e4 <consoleread+0x74>
      if(myproc()->killed){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	850080e7          	jalr	-1968(ra) # 80001a10 <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	efad                	bnez	a5,80000244 <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	05c080e7          	jalr	92(ra) # 8000222c <sleep>
    while(cons.r == cons.w){
    800001d8:	0984a783          	lw	a5,152(s1)
    800001dc:	09c4a703          	lw	a4,156(s1)
    800001e0:	fef700e3          	beq	a4,a5,800001c0 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e4:	00011717          	auipc	a4,0x11
    800001e8:	64c70713          	add	a4,a4,1612 # 80011830 <cons>
    800001ec:	0017869b          	addw	a3,a5,1
    800001f0:	08d72c23          	sw	a3,152(a4)
    800001f4:	07f7f693          	and	a3,a5,127
    800001f8:	9736                	add	a4,a4,a3
    800001fa:	01874703          	lbu	a4,24(a4)
    800001fe:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000202:	4691                	li	a3,4
    80000204:	06db8463          	beq	s7,a3,8000026c <consoleread+0xfc>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000208:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	faf40613          	add	a2,s0,-81
    80000212:	85d2                	mv	a1,s4
    80000214:	8556                	mv	a0,s5
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	270080e7          	jalr	624(ra) # 80002486 <either_copyout>
    8000021e:	57fd                	li	a5,-1
    80000220:	00f50763          	beq	a0,a5,8000022e <consoleread+0xbe>
      break;

    dst++;
    80000224:	0a05                	add	s4,s4,1
    --n;
    80000226:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80000228:	47a9                	li	a5,10
    8000022a:	f8fb93e3          	bne	s7,a5,800001b0 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	60250513          	add	a0,a0,1538 # 80011830 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	ac4080e7          	jalr	-1340(ra) # 80000cfa <release>

  return target - n;
    8000023e:	413b053b          	subw	a0,s6,s3
    80000242:	a811                	j	80000256 <consoleread+0xe6>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	add	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	aae080e7          	jalr	-1362(ra) # 80000cfa <release>
        return -1;
    80000254:	557d                	li	a0,-1
}
    80000256:	60e6                	ld	ra,88(sp)
    80000258:	6446                	ld	s0,80(sp)
    8000025a:	64a6                	ld	s1,72(sp)
    8000025c:	6906                	ld	s2,64(sp)
    8000025e:	79e2                	ld	s3,56(sp)
    80000260:	7a42                	ld	s4,48(sp)
    80000262:	7aa2                	ld	s5,40(sp)
    80000264:	7b02                	ld	s6,32(sp)
    80000266:	6be2                	ld	s7,24(sp)
    80000268:	6125                	add	sp,sp,96
    8000026a:	8082                	ret
      if(n < target){
    8000026c:	0009871b          	sext.w	a4,s3
    80000270:	fb677fe3          	bgeu	a4,s6,8000022e <consoleread+0xbe>
        cons.r--;
    80000274:	00011717          	auipc	a4,0x11
    80000278:	64f72a23          	sw	a5,1620(a4) # 800118c8 <cons+0x98>
    8000027c:	bf4d                	j	8000022e <consoleread+0xbe>

000000008000027e <consputc>:
{
    8000027e:	1141                	add	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80000286:	10000793          	li	a5,256
    8000028a:	00f50a63          	beq	a0,a5,8000029e <consputc+0x20>
    uartputc_sync(c);
    8000028e:	00000097          	auipc	ra,0x0
    80000292:	560080e7          	jalr	1376(ra) # 800007ee <uartputc_sync>
}
    80000296:	60a2                	ld	ra,8(sp)
    80000298:	6402                	ld	s0,0(sp)
    8000029a:	0141                	add	sp,sp,16
    8000029c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	54e080e7          	jalr	1358(ra) # 800007ee <uartputc_sync>
    800002a8:	02000513          	li	a0,32
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	542080e7          	jalr	1346(ra) # 800007ee <uartputc_sync>
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	538080e7          	jalr	1336(ra) # 800007ee <uartputc_sync>
    800002be:	bfe1                	j	80000296 <consputc+0x18>

00000000800002c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c0:	1101                	add	sp,sp,-32
    800002c2:	ec06                	sd	ra,24(sp)
    800002c4:	e822                	sd	s0,16(sp)
    800002c6:	e426                	sd	s1,8(sp)
    800002c8:	e04a                	sd	s2,0(sp)
    800002ca:	1000                	add	s0,sp,32
    800002cc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ce:	00011517          	auipc	a0,0x11
    800002d2:	56250513          	add	a0,a0,1378 # 80011830 <cons>
    800002d6:	00001097          	auipc	ra,0x1
    800002da:	970080e7          	jalr	-1680(ra) # 80000c46 <acquire>

  switch(c){
    800002de:	47d5                	li	a5,21
    800002e0:	0af48663          	beq	s1,a5,8000038c <consoleintr+0xcc>
    800002e4:	0297ca63          	blt	a5,s1,80000318 <consoleintr+0x58>
    800002e8:	47a1                	li	a5,8
    800002ea:	0ef48763          	beq	s1,a5,800003d8 <consoleintr+0x118>
    800002ee:	47c1                	li	a5,16
    800002f0:	10f49a63          	bne	s1,a5,80000404 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f4:	00002097          	auipc	ra,0x2
    800002f8:	23e080e7          	jalr	574(ra) # 80002532 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fc:	00011517          	auipc	a0,0x11
    80000300:	53450513          	add	a0,a0,1332 # 80011830 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	9f6080e7          	jalr	-1546(ra) # 80000cfa <release>
}
    8000030c:	60e2                	ld	ra,24(sp)
    8000030e:	6442                	ld	s0,16(sp)
    80000310:	64a2                	ld	s1,8(sp)
    80000312:	6902                	ld	s2,0(sp)
    80000314:	6105                	add	sp,sp,32
    80000316:	8082                	ret
  switch(c){
    80000318:	07f00793          	li	a5,127
    8000031c:	0af48e63          	beq	s1,a5,800003d8 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000320:	00011717          	auipc	a4,0x11
    80000324:	51070713          	add	a4,a4,1296 # 80011830 <cons>
    80000328:	0a072783          	lw	a5,160(a4)
    8000032c:	09872703          	lw	a4,152(a4)
    80000330:	9f99                	subw	a5,a5,a4
    80000332:	07f00713          	li	a4,127
    80000336:	fcf763e3          	bltu	a4,a5,800002fc <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033a:	47b5                	li	a5,13
    8000033c:	0cf48763          	beq	s1,a5,8000040a <consoleintr+0x14a>
      consputc(c);
    80000340:	8526                	mv	a0,s1
    80000342:	00000097          	auipc	ra,0x0
    80000346:	f3c080e7          	jalr	-196(ra) # 8000027e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034a:	00011797          	auipc	a5,0x11
    8000034e:	4e678793          	add	a5,a5,1254 # 80011830 <cons>
    80000352:	0a07a703          	lw	a4,160(a5)
    80000356:	0017069b          	addw	a3,a4,1
    8000035a:	0006861b          	sext.w	a2,a3
    8000035e:	0ad7a023          	sw	a3,160(a5)
    80000362:	07f77713          	and	a4,a4,127
    80000366:	97ba                	add	a5,a5,a4
    80000368:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000036c:	47a9                	li	a5,10
    8000036e:	0cf48563          	beq	s1,a5,80000438 <consoleintr+0x178>
    80000372:	4791                	li	a5,4
    80000374:	0cf48263          	beq	s1,a5,80000438 <consoleintr+0x178>
    80000378:	00011797          	auipc	a5,0x11
    8000037c:	5507a783          	lw	a5,1360(a5) # 800118c8 <cons+0x98>
    80000380:	0807879b          	addw	a5,a5,128
    80000384:	f6f61ce3          	bne	a2,a5,800002fc <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000388:	863e                	mv	a2,a5
    8000038a:	a07d                	j	80000438 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038c:	00011717          	auipc	a4,0x11
    80000390:	4a470713          	add	a4,a4,1188 # 80011830 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000039c:	00011497          	auipc	s1,0x11
    800003a0:	49448493          	add	s1,s1,1172 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003a4:	4929                	li	s2,10
    800003a6:	f4f70be3          	beq	a4,a5,800002fc <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	37fd                	addw	a5,a5,-1
    800003ac:	07f7f713          	and	a4,a5,127
    800003b0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b2:	01874703          	lbu	a4,24(a4)
    800003b6:	f52703e3          	beq	a4,s2,800002fc <consoleintr+0x3c>
      cons.e--;
    800003ba:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003be:	10000513          	li	a0,256
    800003c2:	00000097          	auipc	ra,0x0
    800003c6:	ebc080e7          	jalr	-324(ra) # 8000027e <consputc>
    while(cons.e != cons.w &&
    800003ca:	0a04a783          	lw	a5,160(s1)
    800003ce:	09c4a703          	lw	a4,156(s1)
    800003d2:	fcf71ce3          	bne	a4,a5,800003aa <consoleintr+0xea>
    800003d6:	b71d                	j	800002fc <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	45870713          	add	a4,a4,1112 # 80011830 <cons>
    800003e0:	0a072783          	lw	a5,160(a4)
    800003e4:	09c72703          	lw	a4,156(a4)
    800003e8:	f0f70ae3          	beq	a4,a5,800002fc <consoleintr+0x3c>
      cons.e--;
    800003ec:	37fd                	addw	a5,a5,-1
    800003ee:	00011717          	auipc	a4,0x11
    800003f2:	4ef72123          	sw	a5,1250(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f6:	10000513          	li	a0,256
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	e84080e7          	jalr	-380(ra) # 8000027e <consputc>
    80000402:	bded                	j	800002fc <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000404:	ee048ce3          	beqz	s1,800002fc <consoleintr+0x3c>
    80000408:	bf21                	j	80000320 <consoleintr+0x60>
      consputc(c);
    8000040a:	4529                	li	a0,10
    8000040c:	00000097          	auipc	ra,0x0
    80000410:	e72080e7          	jalr	-398(ra) # 8000027e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000414:	00011797          	auipc	a5,0x11
    80000418:	41c78793          	add	a5,a5,1052 # 80011830 <cons>
    8000041c:	0a07a703          	lw	a4,160(a5)
    80000420:	0017069b          	addw	a3,a4,1
    80000424:	0006861b          	sext.w	a2,a3
    80000428:	0ad7a023          	sw	a3,160(a5)
    8000042c:	07f77713          	and	a4,a4,127
    80000430:	97ba                	add	a5,a5,a4
    80000432:	4729                	li	a4,10
    80000434:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000438:	00011797          	auipc	a5,0x11
    8000043c:	48c7aa23          	sw	a2,1172(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000440:	00011517          	auipc	a0,0x11
    80000444:	48850513          	add	a0,a0,1160 # 800118c8 <cons+0x98>
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	f64080e7          	jalr	-156(ra) # 800023ac <wakeup>
    80000450:	b575                	j	800002fc <consoleintr+0x3c>

0000000080000452 <consoleinit>:

void
consoleinit(void)
{
    80000452:	1141                	add	sp,sp,-16
    80000454:	e406                	sd	ra,8(sp)
    80000456:	e022                	sd	s0,0(sp)
    80000458:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045a:	00008597          	auipc	a1,0x8
    8000045e:	bb658593          	add	a1,a1,-1098 # 80008010 <etext+0x10>
    80000462:	00011517          	auipc	a0,0x11
    80000466:	3ce50513          	add	a0,a0,974 # 80011830 <cons>
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	74c080e7          	jalr	1868(ra) # 80000bb6 <initlock>

  uartinit();
    80000472:	00000097          	auipc	ra,0x0
    80000476:	32c080e7          	jalr	812(ra) # 8000079e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047a:	00021797          	auipc	a5,0x21
    8000047e:	73678793          	add	a5,a5,1846 # 80021bb0 <devsw>
    80000482:	00000717          	auipc	a4,0x0
    80000486:	cee70713          	add	a4,a4,-786 # 80000170 <consoleread>
    8000048a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048c:	00000717          	auipc	a4,0x0
    80000490:	c6070713          	add	a4,a4,-928 # 800000ec <consolewrite>
    80000494:	ef98                	sd	a4,24(a5)
}
    80000496:	60a2                	ld	ra,8(sp)
    80000498:	6402                	ld	s0,0(sp)
    8000049a:	0141                	add	sp,sp,16
    8000049c:	8082                	ret

000000008000049e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049e:	7179                	add	sp,sp,-48
    800004a0:	f406                	sd	ra,40(sp)
    800004a2:	f022                	sd	s0,32(sp)
    800004a4:	ec26                	sd	s1,24(sp)
    800004a6:	e84a                	sd	s2,16(sp)
    800004a8:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004aa:	c219                	beqz	a2,800004b0 <printint+0x12>
    800004ac:	08054763          	bltz	a0,8000053a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004b0:	2501                	sext.w	a0,a0
    800004b2:	4881                	li	a7,0
    800004b4:	fd040693          	add	a3,s0,-48

  i = 0;
    800004b8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004ba:	2581                	sext.w	a1,a1
    800004bc:	00008617          	auipc	a2,0x8
    800004c0:	b8460613          	add	a2,a2,-1148 # 80008040 <digits>
    800004c4:	883a                	mv	a6,a4
    800004c6:	2705                	addw	a4,a4,1
    800004c8:	02b577bb          	remuw	a5,a0,a1
    800004cc:	1782                	sll	a5,a5,0x20
    800004ce:	9381                	srl	a5,a5,0x20
    800004d0:	97b2                	add	a5,a5,a2
    800004d2:	0007c783          	lbu	a5,0(a5)
    800004d6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004da:	0005079b          	sext.w	a5,a0
    800004de:	02b5553b          	divuw	a0,a0,a1
    800004e2:	0685                	add	a3,a3,1
    800004e4:	feb7f0e3          	bgeu	a5,a1,800004c4 <printint+0x26>

  if(sign)
    800004e8:	00088c63          	beqz	a7,80000500 <printint+0x62>
    buf[i++] = '-';
    800004ec:	fe070793          	add	a5,a4,-32
    800004f0:	00878733          	add	a4,a5,s0
    800004f4:	02d00793          	li	a5,45
    800004f8:	fef70823          	sb	a5,-16(a4)
    800004fc:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80000500:	02e05763          	blez	a4,8000052e <printint+0x90>
    80000504:	fd040793          	add	a5,s0,-48
    80000508:	00e784b3          	add	s1,a5,a4
    8000050c:	fff78913          	add	s2,a5,-1
    80000510:	993a                	add	s2,s2,a4
    80000512:	377d                	addw	a4,a4,-1
    80000514:	1702                	sll	a4,a4,0x20
    80000516:	9301                	srl	a4,a4,0x20
    80000518:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051c:	fff4c503          	lbu	a0,-1(s1)
    80000520:	00000097          	auipc	ra,0x0
    80000524:	d5e080e7          	jalr	-674(ra) # 8000027e <consputc>
  while(--i >= 0)
    80000528:	14fd                	add	s1,s1,-1
    8000052a:	ff2499e3          	bne	s1,s2,8000051c <printint+0x7e>
}
    8000052e:	70a2                	ld	ra,40(sp)
    80000530:	7402                	ld	s0,32(sp)
    80000532:	64e2                	ld	s1,24(sp)
    80000534:	6942                	ld	s2,16(sp)
    80000536:	6145                	add	sp,sp,48
    80000538:	8082                	ret
    x = -xx;
    8000053a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053e:	4885                	li	a7,1
    x = -xx;
    80000540:	bf95                	j	800004b4 <printint+0x16>

0000000080000542 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000542:	1101                	add	sp,sp,-32
    80000544:	ec06                	sd	ra,24(sp)
    80000546:	e822                	sd	s0,16(sp)
    80000548:	e426                	sd	s1,8(sp)
    8000054a:	1000                	add	s0,sp,32
    8000054c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054e:	00011797          	auipc	a5,0x11
    80000552:	3a07a123          	sw	zero,930(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    80000556:	00008517          	auipc	a0,0x8
    8000055a:	ac250513          	add	a0,a0,-1342 # 80008018 <etext+0x18>
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	02e080e7          	jalr	46(ra) # 8000058c <printf>
  printf(s);
    80000566:	8526                	mv	a0,s1
    80000568:	00000097          	auipc	ra,0x0
    8000056c:	024080e7          	jalr	36(ra) # 8000058c <printf>
  printf("\n");
    80000570:	00008517          	auipc	a0,0x8
    80000574:	b5850513          	add	a0,a0,-1192 # 800080c8 <digits+0x88>
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	014080e7          	jalr	20(ra) # 8000058c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000580:	4785                	li	a5,1
    80000582:	00009717          	auipc	a4,0x9
    80000586:	a6f72f23          	sw	a5,-1410(a4) # 80009000 <panicked>
  for(;;)
    8000058a:	a001                	j	8000058a <panic+0x48>

000000008000058c <printf>:
{
    8000058c:	7131                	add	sp,sp,-192
    8000058e:	fc86                	sd	ra,120(sp)
    80000590:	f8a2                	sd	s0,112(sp)
    80000592:	f4a6                	sd	s1,104(sp)
    80000594:	f0ca                	sd	s2,96(sp)
    80000596:	ecce                	sd	s3,88(sp)
    80000598:	e8d2                	sd	s4,80(sp)
    8000059a:	e4d6                	sd	s5,72(sp)
    8000059c:	e0da                	sd	s6,64(sp)
    8000059e:	fc5e                	sd	s7,56(sp)
    800005a0:	f862                	sd	s8,48(sp)
    800005a2:	f466                	sd	s9,40(sp)
    800005a4:	f06a                	sd	s10,32(sp)
    800005a6:	ec6e                	sd	s11,24(sp)
    800005a8:	0100                	add	s0,sp,128
    800005aa:	8a2a                	mv	s4,a0
    800005ac:	e40c                	sd	a1,8(s0)
    800005ae:	e810                	sd	a2,16(s0)
    800005b0:	ec14                	sd	a3,24(s0)
    800005b2:	f018                	sd	a4,32(s0)
    800005b4:	f41c                	sd	a5,40(s0)
    800005b6:	03043823          	sd	a6,48(s0)
    800005ba:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005be:	00011d97          	auipc	s11,0x11
    800005c2:	332dad83          	lw	s11,818(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005c6:	020d9b63          	bnez	s11,800005fc <printf+0x70>
  if (fmt == 0)
    800005ca:	040a0263          	beqz	s4,8000060e <printf+0x82>
  va_start(ap, fmt);
    800005ce:	00840793          	add	a5,s0,8
    800005d2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d6:	000a4503          	lbu	a0,0(s4)
    800005da:	14050f63          	beqz	a0,80000738 <printf+0x1ac>
    800005de:	4981                	li	s3,0
    if(c != '%'){
    800005e0:	02500a93          	li	s5,37
    switch(c){
    800005e4:	07000b93          	li	s7,112
  consputc('x');
    800005e8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005ea:	00008b17          	auipc	s6,0x8
    800005ee:	a56b0b13          	add	s6,s6,-1450 # 80008040 <digits>
    switch(c){
    800005f2:	07300c93          	li	s9,115
    800005f6:	06400c13          	li	s8,100
    800005fa:	a82d                	j	80000634 <printf+0xa8>
    acquire(&pr.lock);
    800005fc:	00011517          	auipc	a0,0x11
    80000600:	2dc50513          	add	a0,a0,732 # 800118d8 <pr>
    80000604:	00000097          	auipc	ra,0x0
    80000608:	642080e7          	jalr	1602(ra) # 80000c46 <acquire>
    8000060c:	bf7d                	j	800005ca <printf+0x3e>
    panic("null fmt");
    8000060e:	00008517          	auipc	a0,0x8
    80000612:	a1a50513          	add	a0,a0,-1510 # 80008028 <etext+0x28>
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	f2c080e7          	jalr	-212(ra) # 80000542 <panic>
      consputc(c);
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	c60080e7          	jalr	-928(ra) # 8000027e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000626:	2985                	addw	s3,s3,1
    80000628:	013a07b3          	add	a5,s4,s3
    8000062c:	0007c503          	lbu	a0,0(a5)
    80000630:	10050463          	beqz	a0,80000738 <printf+0x1ac>
    if(c != '%'){
    80000634:	ff5515e3          	bne	a0,s5,8000061e <printf+0x92>
    c = fmt[++i] & 0xff;
    80000638:	2985                	addw	s3,s3,1
    8000063a:	013a07b3          	add	a5,s4,s3
    8000063e:	0007c783          	lbu	a5,0(a5)
    80000642:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000646:	cbed                	beqz	a5,80000738 <printf+0x1ac>
    switch(c){
    80000648:	05778a63          	beq	a5,s7,8000069c <printf+0x110>
    8000064c:	02fbf663          	bgeu	s7,a5,80000678 <printf+0xec>
    80000650:	09978863          	beq	a5,s9,800006e0 <printf+0x154>
    80000654:	07800713          	li	a4,120
    80000658:	0ce79563          	bne	a5,a4,80000722 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065c:	f8843783          	ld	a5,-120(s0)
    80000660:	00878713          	add	a4,a5,8
    80000664:	f8e43423          	sd	a4,-120(s0)
    80000668:	4605                	li	a2,1
    8000066a:	85ea                	mv	a1,s10
    8000066c:	4388                	lw	a0,0(a5)
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	e30080e7          	jalr	-464(ra) # 8000049e <printint>
      break;
    80000676:	bf45                	j	80000626 <printf+0x9a>
    switch(c){
    80000678:	09578f63          	beq	a5,s5,80000716 <printf+0x18a>
    8000067c:	0b879363          	bne	a5,s8,80000722 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000680:	f8843783          	ld	a5,-120(s0)
    80000684:	00878713          	add	a4,a5,8
    80000688:	f8e43423          	sd	a4,-120(s0)
    8000068c:	4605                	li	a2,1
    8000068e:	45a9                	li	a1,10
    80000690:	4388                	lw	a0,0(a5)
    80000692:	00000097          	auipc	ra,0x0
    80000696:	e0c080e7          	jalr	-500(ra) # 8000049e <printint>
      break;
    8000069a:	b771                	j	80000626 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069c:	f8843783          	ld	a5,-120(s0)
    800006a0:	00878713          	add	a4,a5,8
    800006a4:	f8e43423          	sd	a4,-120(s0)
    800006a8:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006ac:	03000513          	li	a0,48
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	bce080e7          	jalr	-1074(ra) # 8000027e <consputc>
  consputc('x');
    800006b8:	07800513          	li	a0,120
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	bc2080e7          	jalr	-1086(ra) # 8000027e <consputc>
    800006c4:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c6:	03c95793          	srl	a5,s2,0x3c
    800006ca:	97da                	add	a5,a5,s6
    800006cc:	0007c503          	lbu	a0,0(a5)
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	bae080e7          	jalr	-1106(ra) # 8000027e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d8:	0912                	sll	s2,s2,0x4
    800006da:	34fd                	addw	s1,s1,-1
    800006dc:	f4ed                	bnez	s1,800006c6 <printf+0x13a>
    800006de:	b7a1                	j	80000626 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e0:	f8843783          	ld	a5,-120(s0)
    800006e4:	00878713          	add	a4,a5,8
    800006e8:	f8e43423          	sd	a4,-120(s0)
    800006ec:	6384                	ld	s1,0(a5)
    800006ee:	cc89                	beqz	s1,80000708 <printf+0x17c>
      for(; *s; s++)
    800006f0:	0004c503          	lbu	a0,0(s1)
    800006f4:	d90d                	beqz	a0,80000626 <printf+0x9a>
        consputc(*s);
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	b88080e7          	jalr	-1144(ra) # 8000027e <consputc>
      for(; *s; s++)
    800006fe:	0485                	add	s1,s1,1
    80000700:	0004c503          	lbu	a0,0(s1)
    80000704:	f96d                	bnez	a0,800006f6 <printf+0x16a>
    80000706:	b705                	j	80000626 <printf+0x9a>
        s = "(null)";
    80000708:	00008497          	auipc	s1,0x8
    8000070c:	91848493          	add	s1,s1,-1768 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000710:	02800513          	li	a0,40
    80000714:	b7cd                	j	800006f6 <printf+0x16a>
      consputc('%');
    80000716:	8556                	mv	a0,s5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	b66080e7          	jalr	-1178(ra) # 8000027e <consputc>
      break;
    80000720:	b719                	j	80000626 <printf+0x9a>
      consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b5a080e7          	jalr	-1190(ra) # 8000027e <consputc>
      consputc(c);
    8000072c:	8526                	mv	a0,s1
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b50080e7          	jalr	-1200(ra) # 8000027e <consputc>
      break;
    80000736:	bdc5                	j	80000626 <printf+0x9a>
  if(locking)
    80000738:	020d9163          	bnez	s11,8000075a <printf+0x1ce>
}
    8000073c:	70e6                	ld	ra,120(sp)
    8000073e:	7446                	ld	s0,112(sp)
    80000740:	74a6                	ld	s1,104(sp)
    80000742:	7906                	ld	s2,96(sp)
    80000744:	69e6                	ld	s3,88(sp)
    80000746:	6a46                	ld	s4,80(sp)
    80000748:	6aa6                	ld	s5,72(sp)
    8000074a:	6b06                	ld	s6,64(sp)
    8000074c:	7be2                	ld	s7,56(sp)
    8000074e:	7c42                	ld	s8,48(sp)
    80000750:	7ca2                	ld	s9,40(sp)
    80000752:	7d02                	ld	s10,32(sp)
    80000754:	6de2                	ld	s11,24(sp)
    80000756:	6129                	add	sp,sp,192
    80000758:	8082                	ret
    release(&pr.lock);
    8000075a:	00011517          	auipc	a0,0x11
    8000075e:	17e50513          	add	a0,a0,382 # 800118d8 <pr>
    80000762:	00000097          	auipc	ra,0x0
    80000766:	598080e7          	jalr	1432(ra) # 80000cfa <release>
}
    8000076a:	bfc9                	j	8000073c <printf+0x1b0>

000000008000076c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076c:	1101                	add	sp,sp,-32
    8000076e:	ec06                	sd	ra,24(sp)
    80000770:	e822                	sd	s0,16(sp)
    80000772:	e426                	sd	s1,8(sp)
    80000774:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80000776:	00011497          	auipc	s1,0x11
    8000077a:	16248493          	add	s1,s1,354 # 800118d8 <pr>
    8000077e:	00008597          	auipc	a1,0x8
    80000782:	8ba58593          	add	a1,a1,-1862 # 80008038 <etext+0x38>
    80000786:	8526                	mv	a0,s1
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	42e080e7          	jalr	1070(ra) # 80000bb6 <initlock>
  pr.locking = 1;
    80000790:	4785                	li	a5,1
    80000792:	cc9c                	sw	a5,24(s1)
}
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6105                	add	sp,sp,32
    8000079c:	8082                	ret

000000008000079e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079e:	1141                	add	sp,sp,-16
    800007a0:	e406                	sd	ra,8(sp)
    800007a2:	e022                	sd	s0,0(sp)
    800007a4:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a6:	100007b7          	lui	a5,0x10000
    800007aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ae:	f8000713          	li	a4,-128
    800007b2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b6:	470d                	li	a4,3
    800007b8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c4:	469d                	li	a3,7
    800007c6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ca:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ce:	00008597          	auipc	a1,0x8
    800007d2:	88a58593          	add	a1,a1,-1910 # 80008058 <digits+0x18>
    800007d6:	00011517          	auipc	a0,0x11
    800007da:	12250513          	add	a0,a0,290 # 800118f8 <uart_tx_lock>
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	3d8080e7          	jalr	984(ra) # 80000bb6 <initlock>
}
    800007e6:	60a2                	ld	ra,8(sp)
    800007e8:	6402                	ld	s0,0(sp)
    800007ea:	0141                	add	sp,sp,16
    800007ec:	8082                	ret

00000000800007ee <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ee:	1101                	add	sp,sp,-32
    800007f0:	ec06                	sd	ra,24(sp)
    800007f2:	e822                	sd	s0,16(sp)
    800007f4:	e426                	sd	s1,8(sp)
    800007f6:	1000                	add	s0,sp,32
    800007f8:	84aa                	mv	s1,a0
  push_off();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	400080e7          	jalr	1024(ra) # 80000bfa <push_off>

  if(panicked){
    80000802:	00008797          	auipc	a5,0x8
    80000806:	7fe7a783          	lw	a5,2046(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080e:	c391                	beqz	a5,80000812 <uartputc_sync+0x24>
    for(;;)
    80000810:	a001                	j	80000810 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000816:	0207f793          	and	a5,a5,32
    8000081a:	dfe5                	beqz	a5,80000812 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081c:	0ff4f513          	zext.b	a0,s1
    80000820:	100007b7          	lui	a5,0x10000
    80000824:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	472080e7          	jalr	1138(ra) # 80000c9a <pop_off>
}
    80000830:	60e2                	ld	ra,24(sp)
    80000832:	6442                	ld	s0,16(sp)
    80000834:	64a2                	ld	s1,8(sp)
    80000836:	6105                	add	sp,sp,32
    80000838:	8082                	ret

000000008000083a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000083a:	00008797          	auipc	a5,0x8
    8000083e:	7ca7a783          	lw	a5,1994(a5) # 80009004 <uart_tx_r>
    80000842:	00008717          	auipc	a4,0x8
    80000846:	7c672703          	lw	a4,1990(a4) # 80009008 <uart_tx_w>
    8000084a:	08f70063          	beq	a4,a5,800008ca <uartstart+0x90>
{
    8000084e:	7139                	add	sp,sp,-64
    80000850:	fc06                	sd	ra,56(sp)
    80000852:	f822                	sd	s0,48(sp)
    80000854:	f426                	sd	s1,40(sp)
    80000856:	f04a                	sd	s2,32(sp)
    80000858:	ec4e                	sd	s3,24(sp)
    8000085a:	e852                	sd	s4,16(sp)
    8000085c:	e456                	sd	s5,8(sp)
    8000085e:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000860:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000864:	00011a97          	auipc	s5,0x11
    80000868:	094a8a93          	add	s5,s5,148 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000086c:	00008497          	auipc	s1,0x8
    80000870:	79848493          	add	s1,s1,1944 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000874:	00008a17          	auipc	s4,0x8
    80000878:	794a0a13          	add	s4,s4,1940 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000880:	02077713          	and	a4,a4,32
    80000884:	cb15                	beqz	a4,800008b8 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    80000886:	00fa8733          	add	a4,s5,a5
    8000088a:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000088e:	2785                	addw	a5,a5,1
    80000890:	41f7d71b          	sraw	a4,a5,0x1f
    80000894:	01b7571b          	srlw	a4,a4,0x1b
    80000898:	9fb9                	addw	a5,a5,a4
    8000089a:	8bfd                	and	a5,a5,31
    8000089c:	9f99                	subw	a5,a5,a4
    8000089e:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a0:	8526                	mv	a0,s1
    800008a2:	00002097          	auipc	ra,0x2
    800008a6:	b0a080e7          	jalr	-1270(ra) # 800023ac <wakeup>
    
    WriteReg(THR, c);
    800008aa:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008ae:	409c                	lw	a5,0(s1)
    800008b0:	000a2703          	lw	a4,0(s4)
    800008b4:	fcf714e3          	bne	a4,a5,8000087c <uartstart+0x42>
  }
}
    800008b8:	70e2                	ld	ra,56(sp)
    800008ba:	7442                	ld	s0,48(sp)
    800008bc:	74a2                	ld	s1,40(sp)
    800008be:	7902                	ld	s2,32(sp)
    800008c0:	69e2                	ld	s3,24(sp)
    800008c2:	6a42                	ld	s4,16(sp)
    800008c4:	6aa2                	ld	s5,8(sp)
    800008c6:	6121                	add	sp,sp,64
    800008c8:	8082                	ret
    800008ca:	8082                	ret

00000000800008cc <uartputc>:
{
    800008cc:	7179                	add	sp,sp,-48
    800008ce:	f406                	sd	ra,40(sp)
    800008d0:	f022                	sd	s0,32(sp)
    800008d2:	ec26                	sd	s1,24(sp)
    800008d4:	e84a                	sd	s2,16(sp)
    800008d6:	e44e                	sd	s3,8(sp)
    800008d8:	e052                	sd	s4,0(sp)
    800008da:	1800                	add	s0,sp,48
    800008dc:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008de:	00011517          	auipc	a0,0x11
    800008e2:	01a50513          	add	a0,a0,26 # 800118f8 <uart_tx_lock>
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	360080e7          	jalr	864(ra) # 80000c46 <acquire>
  if(panicked){
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	7127a783          	lw	a5,1810(a5) # 80009000 <panicked>
    800008f6:	c391                	beqz	a5,800008fa <uartputc+0x2e>
    for(;;)
    800008f8:	a001                	j	800008f8 <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800008fa:	00008697          	auipc	a3,0x8
    800008fe:	70e6a683          	lw	a3,1806(a3) # 80009008 <uart_tx_w>
    80000902:	0016879b          	addw	a5,a3,1
    80000906:	41f7d71b          	sraw	a4,a5,0x1f
    8000090a:	01b7571b          	srlw	a4,a4,0x1b
    8000090e:	9fb9                	addw	a5,a5,a4
    80000910:	8bfd                	and	a5,a5,31
    80000912:	9f99                	subw	a5,a5,a4
    80000914:	00008717          	auipc	a4,0x8
    80000918:	6f072703          	lw	a4,1776(a4) # 80009004 <uart_tx_r>
    8000091c:	04f71363          	bne	a4,a5,80000962 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000920:	00011a17          	auipc	s4,0x11
    80000924:	fd8a0a13          	add	s4,s4,-40 # 800118f8 <uart_tx_lock>
    80000928:	00008917          	auipc	s2,0x8
    8000092c:	6dc90913          	add	s2,s2,1756 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000930:	00008997          	auipc	s3,0x8
    80000934:	6d898993          	add	s3,s3,1752 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85d2                	mv	a1,s4
    8000093a:	854a                	mv	a0,s2
    8000093c:	00002097          	auipc	ra,0x2
    80000940:	8f0080e7          	jalr	-1808(ra) # 8000222c <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000944:	0009a683          	lw	a3,0(s3)
    80000948:	0016879b          	addw	a5,a3,1
    8000094c:	41f7d71b          	sraw	a4,a5,0x1f
    80000950:	01b7571b          	srlw	a4,a4,0x1b
    80000954:	9fb9                	addw	a5,a5,a4
    80000956:	8bfd                	and	a5,a5,31
    80000958:	9f99                	subw	a5,a5,a4
    8000095a:	00092703          	lw	a4,0(s2)
    8000095e:	fcf70de3          	beq	a4,a5,80000938 <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000962:	00011917          	auipc	s2,0x11
    80000966:	f9690913          	add	s2,s2,-106 # 800118f8 <uart_tx_lock>
    8000096a:	96ca                	add	a3,a3,s2
    8000096c:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000970:	00008717          	auipc	a4,0x8
    80000974:	68f72c23          	sw	a5,1688(a4) # 80009008 <uart_tx_w>
      uartstart();
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	ec2080e7          	jalr	-318(ra) # 8000083a <uartstart>
      release(&uart_tx_lock);
    80000980:	854a                	mv	a0,s2
    80000982:	00000097          	auipc	ra,0x0
    80000986:	378080e7          	jalr	888(ra) # 80000cfa <release>
}
    8000098a:	70a2                	ld	ra,40(sp)
    8000098c:	7402                	ld	s0,32(sp)
    8000098e:	64e2                	ld	s1,24(sp)
    80000990:	6942                	ld	s2,16(sp)
    80000992:	69a2                	ld	s3,8(sp)
    80000994:	6a02                	ld	s4,0(sp)
    80000996:	6145                	add	sp,sp,48
    80000998:	8082                	ret

000000008000099a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000099a:	1141                	add	sp,sp,-16
    8000099c:	e422                	sd	s0,8(sp)
    8000099e:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009a0:	100007b7          	lui	a5,0x10000
    800009a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009a8:	8b85                	and	a5,a5,1
    800009aa:	cb81                	beqz	a5,800009ba <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009ac:	100007b7          	lui	a5,0x10000
    800009b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009b4:	6422                	ld	s0,8(sp)
    800009b6:	0141                	add	sp,sp,16
    800009b8:	8082                	ret
    return -1;
    800009ba:	557d                	li	a0,-1
    800009bc:	bfe5                	j	800009b4 <uartgetc+0x1a>

00000000800009be <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009be:	1101                	add	sp,sp,-32
    800009c0:	ec06                	sd	ra,24(sp)
    800009c2:	e822                	sd	s0,16(sp)
    800009c4:	e426                	sd	s1,8(sp)
    800009c6:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009c8:	54fd                	li	s1,-1
    800009ca:	a029                	j	800009d4 <uartintr+0x16>
      break;
    consoleintr(c);
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	8f4080e7          	jalr	-1804(ra) # 800002c0 <consoleintr>
    int c = uartgetc();
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	fc6080e7          	jalr	-58(ra) # 8000099a <uartgetc>
    if(c == -1)
    800009dc:	fe9518e3          	bne	a0,s1,800009cc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009e0:	00011497          	auipc	s1,0x11
    800009e4:	f1848493          	add	s1,s1,-232 # 800118f8 <uart_tx_lock>
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	25c080e7          	jalr	604(ra) # 80000c46 <acquire>
  uartstart();
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	e48080e7          	jalr	-440(ra) # 8000083a <uartstart>
  release(&uart_tx_lock);
    800009fa:	8526                	mv	a0,s1
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	2fe080e7          	jalr	766(ra) # 80000cfa <release>
}
    80000a04:	60e2                	ld	ra,24(sp)
    80000a06:	6442                	ld	s0,16(sp)
    80000a08:	64a2                	ld	s1,8(sp)
    80000a0a:	6105                	add	sp,sp,32
    80000a0c:	8082                	ret

0000000080000a0e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a0e:	1101                	add	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	e04a                	sd	s2,0(sp)
    80000a18:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a1a:	03451793          	sll	a5,a0,0x34
    80000a1e:	ebb9                	bnez	a5,80000a74 <kfree+0x66>
    80000a20:	84aa                	mv	s1,a0
    80000a22:	00025797          	auipc	a5,0x25
    80000a26:	5de78793          	add	a5,a5,1502 # 80026000 <end>
    80000a2a:	04f56563          	bltu	a0,a5,80000a74 <kfree+0x66>
    80000a2e:	47c5                	li	a5,17
    80000a30:	07ee                	sll	a5,a5,0x1b
    80000a32:	04f57163          	bgeu	a0,a5,80000a74 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a36:	6605                	lui	a2,0x1
    80000a38:	4585                	li	a1,1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	308080e7          	jalr	776(ra) # 80000d42 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a42:	00011917          	auipc	s2,0x11
    80000a46:	eee90913          	add	s2,s2,-274 # 80011930 <kmem>
    80000a4a:	854a                	mv	a0,s2
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	1fa080e7          	jalr	506(ra) # 80000c46 <acquire>
  r->next = kmem.freelist;
    80000a54:	01893783          	ld	a5,24(s2)
    80000a58:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a5a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a5e:	854a                	mv	a0,s2
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	29a080e7          	jalr	666(ra) # 80000cfa <release>
}
    80000a68:	60e2                	ld	ra,24(sp)
    80000a6a:	6442                	ld	s0,16(sp)
    80000a6c:	64a2                	ld	s1,8(sp)
    80000a6e:	6902                	ld	s2,0(sp)
    80000a70:	6105                	add	sp,sp,32
    80000a72:	8082                	ret
    panic("kfree");
    80000a74:	00007517          	auipc	a0,0x7
    80000a78:	5ec50513          	add	a0,a0,1516 # 80008060 <digits+0x20>
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	ac6080e7          	jalr	-1338(ra) # 80000542 <panic>

0000000080000a84 <freerange>:
{
    80000a84:	7179                	add	sp,sp,-48
    80000a86:	f406                	sd	ra,40(sp)
    80000a88:	f022                	sd	s0,32(sp)
    80000a8a:	ec26                	sd	s1,24(sp)
    80000a8c:	e84a                	sd	s2,16(sp)
    80000a8e:	e44e                	sd	s3,8(sp)
    80000a90:	e052                	sd	s4,0(sp)
    80000a92:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a94:	6785                	lui	a5,0x1
    80000a96:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a9a:	00e504b3          	add	s1,a0,a4
    80000a9e:	777d                	lui	a4,0xfffff
    80000aa0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa2:	94be                	add	s1,s1,a5
    80000aa4:	0095ee63          	bltu	a1,s1,80000ac0 <freerange+0x3c>
    80000aa8:	892e                	mv	s2,a1
    kfree(p);
    80000aaa:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aac:	6985                	lui	s3,0x1
    kfree(p);
    80000aae:	01448533          	add	a0,s1,s4
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	f5c080e7          	jalr	-164(ra) # 80000a0e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aba:	94ce                	add	s1,s1,s3
    80000abc:	fe9979e3          	bgeu	s2,s1,80000aae <freerange+0x2a>
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6942                	ld	s2,16(sp)
    80000ac8:	69a2                	ld	s3,8(sp)
    80000aca:	6a02                	ld	s4,0(sp)
    80000acc:	6145                	add	sp,sp,48
    80000ace:	8082                	ret

0000000080000ad0 <kinit>:
{
    80000ad0:	1141                	add	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ad8:	00007597          	auipc	a1,0x7
    80000adc:	59058593          	add	a1,a1,1424 # 80008068 <digits+0x28>
    80000ae0:	00011517          	auipc	a0,0x11
    80000ae4:	e5050513          	add	a0,a0,-432 # 80011930 <kmem>
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	0ce080e7          	jalr	206(ra) # 80000bb6 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af0:	45c5                	li	a1,17
    80000af2:	05ee                	sll	a1,a1,0x1b
    80000af4:	00025517          	auipc	a0,0x25
    80000af8:	50c50513          	add	a0,a0,1292 # 80026000 <end>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	f88080e7          	jalr	-120(ra) # 80000a84 <freerange>
}
    80000b04:	60a2                	ld	ra,8(sp)
    80000b06:	6402                	ld	s0,0(sp)
    80000b08:	0141                	add	sp,sp,16
    80000b0a:	8082                	ret

0000000080000b0c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b0c:	1101                	add	sp,sp,-32
    80000b0e:	ec06                	sd	ra,24(sp)
    80000b10:	e822                	sd	s0,16(sp)
    80000b12:	e426                	sd	s1,8(sp)
    80000b14:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b16:	00011497          	auipc	s1,0x11
    80000b1a:	e1a48493          	add	s1,s1,-486 # 80011930 <kmem>
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	126080e7          	jalr	294(ra) # 80000c46 <acquire>
  r = kmem.freelist;
    80000b28:	6c84                	ld	s1,24(s1)
  if(r)
    80000b2a:	c885                	beqz	s1,80000b5a <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b2c:	609c                	ld	a5,0(s1)
    80000b2e:	00011517          	auipc	a0,0x11
    80000b32:	e0250513          	add	a0,a0,-510 # 80011930 <kmem>
    80000b36:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	1c2080e7          	jalr	450(ra) # 80000cfa <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b40:	6605                	lui	a2,0x1
    80000b42:	4595                	li	a1,5
    80000b44:	8526                	mv	a0,s1
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	1fc080e7          	jalr	508(ra) # 80000d42 <memset>
  return (void*)r;
}
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	add	sp,sp,32
    80000b58:	8082                	ret
  release(&kmem.lock);
    80000b5a:	00011517          	auipc	a0,0x11
    80000b5e:	dd650513          	add	a0,a0,-554 # 80011930 <kmem>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	198080e7          	jalr	408(ra) # 80000cfa <release>
  if(r)
    80000b6a:	b7d5                	j	80000b4e <kalloc+0x42>

0000000080000b6c <count_free_mem>:
//Calculate free memory
uint64
count_free_mem(void)
{
    80000b6c:	1101                	add	sp,sp,-32
    80000b6e:	ec06                	sd	ra,24(sp)
    80000b70:	e822                	sd	s0,16(sp)
    80000b72:	e426                	sd	s1,8(sp)
    80000b74:	1000                	add	s0,sp,32
  acquire(&kmem.lock);//先把内存管理结构锁住，旁防止竞争条件出现
    80000b76:	00011497          	auipc	s1,0x11
    80000b7a:	dba48493          	add	s1,s1,-582 # 80011930 <kmem>
    80000b7e:	8526                	mv	a0,s1
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	0c6080e7          	jalr	198(ra) # 80000c46 <acquire>
  //统计空闲页数，乘上页大小PGSIZE就是空闲的内存字节数
  uint64 mem_bytes=0;
  // r是空闲页面的指针
  struct run *r=kmem.freelist;
    80000b88:	6c9c                	ld	a5,24(s1)
  while(r){
    80000b8a:	c785                	beqz	a5,80000bb2 <count_free_mem+0x46>
  uint64 mem_bytes=0;
    80000b8c:	4481                	li	s1,0
    mem_bytes += PGSIZE;
    80000b8e:	6705                	lui	a4,0x1
    80000b90:	94ba                	add	s1,s1,a4
    r=r->next;
    80000b92:	639c                	ld	a5,0(a5)
  while(r){
    80000b94:	fff5                	bnez	a5,80000b90 <count_free_mem+0x24>
  }
  release(&kmem.lock);
    80000b96:	00011517          	auipc	a0,0x11
    80000b9a:	d9a50513          	add	a0,a0,-614 # 80011930 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	15c080e7          	jalr	348(ra) # 80000cfa <release>
  return mem_bytes;
}
    80000ba6:	8526                	mv	a0,s1
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	add	sp,sp,32
    80000bb0:	8082                	ret
  uint64 mem_bytes=0;
    80000bb2:	4481                	li	s1,0
    80000bb4:	b7cd                	j	80000b96 <count_free_mem+0x2a>

0000000080000bb6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bb6:	1141                	add	sp,sp,-16
    80000bb8:	e422                	sd	s0,8(sp)
    80000bba:	0800                	add	s0,sp,16
  lk->name = name;
    80000bbc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bbe:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bc2:	00053823          	sd	zero,16(a0)
}
    80000bc6:	6422                	ld	s0,8(sp)
    80000bc8:	0141                	add	sp,sp,16
    80000bca:	8082                	ret

0000000080000bcc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bcc:	411c                	lw	a5,0(a0)
    80000bce:	e399                	bnez	a5,80000bd4 <holding+0x8>
    80000bd0:	4501                	li	a0,0
  return r;
}
    80000bd2:	8082                	ret
{
    80000bd4:	1101                	add	sp,sp,-32
    80000bd6:	ec06                	sd	ra,24(sp)
    80000bd8:	e822                	sd	s0,16(sp)
    80000bda:	e426                	sd	s1,8(sp)
    80000bdc:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bde:	6904                	ld	s1,16(a0)
    80000be0:	00001097          	auipc	ra,0x1
    80000be4:	e14080e7          	jalr	-492(ra) # 800019f4 <mycpu>
    80000be8:	40a48533          	sub	a0,s1,a0
    80000bec:	00153513          	seqz	a0,a0
}
    80000bf0:	60e2                	ld	ra,24(sp)
    80000bf2:	6442                	ld	s0,16(sp)
    80000bf4:	64a2                	ld	s1,8(sp)
    80000bf6:	6105                	add	sp,sp,32
    80000bf8:	8082                	ret

0000000080000bfa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bfa:	1101                	add	sp,sp,-32
    80000bfc:	ec06                	sd	ra,24(sp)
    80000bfe:	e822                	sd	s0,16(sp)
    80000c00:	e426                	sd	s1,8(sp)
    80000c02:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c04:	100024f3          	csrr	s1,sstatus
    80000c08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c0c:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c0e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c12:	00001097          	auipc	ra,0x1
    80000c16:	de2080e7          	jalr	-542(ra) # 800019f4 <mycpu>
    80000c1a:	5d3c                	lw	a5,120(a0)
    80000c1c:	cf89                	beqz	a5,80000c36 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	dd6080e7          	jalr	-554(ra) # 800019f4 <mycpu>
    80000c26:	5d3c                	lw	a5,120(a0)
    80000c28:	2785                	addw	a5,a5,1
    80000c2a:	dd3c                	sw	a5,120(a0)
}
    80000c2c:	60e2                	ld	ra,24(sp)
    80000c2e:	6442                	ld	s0,16(sp)
    80000c30:	64a2                	ld	s1,8(sp)
    80000c32:	6105                	add	sp,sp,32
    80000c34:	8082                	ret
    mycpu()->intena = old;
    80000c36:	00001097          	auipc	ra,0x1
    80000c3a:	dbe080e7          	jalr	-578(ra) # 800019f4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8085                	srl	s1,s1,0x1
    80000c40:	8885                	and	s1,s1,1
    80000c42:	dd64                	sw	s1,124(a0)
    80000c44:	bfe9                	j	80000c1e <push_off+0x24>

0000000080000c46 <acquire>:
{
    80000c46:	1101                	add	sp,sp,-32
    80000c48:	ec06                	sd	ra,24(sp)
    80000c4a:	e822                	sd	s0,16(sp)
    80000c4c:	e426                	sd	s1,8(sp)
    80000c4e:	1000                	add	s0,sp,32
    80000c50:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	fa8080e7          	jalr	-88(ra) # 80000bfa <push_off>
  if(holding(lk))
    80000c5a:	8526                	mv	a0,s1
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	f70080e7          	jalr	-144(ra) # 80000bcc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c64:	4705                	li	a4,1
  if(holding(lk))
    80000c66:	e115                	bnez	a0,80000c8a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c68:	87ba                	mv	a5,a4
    80000c6a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c6e:	2781                	sext.w	a5,a5
    80000c70:	ffe5                	bnez	a5,80000c68 <acquire+0x22>
  __sync_synchronize();
    80000c72:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c76:	00001097          	auipc	ra,0x1
    80000c7a:	d7e080e7          	jalr	-642(ra) # 800019f4 <mycpu>
    80000c7e:	e888                	sd	a0,16(s1)
}
    80000c80:	60e2                	ld	ra,24(sp)
    80000c82:	6442                	ld	s0,16(sp)
    80000c84:	64a2                	ld	s1,8(sp)
    80000c86:	6105                	add	sp,sp,32
    80000c88:	8082                	ret
    panic("acquire");
    80000c8a:	00007517          	auipc	a0,0x7
    80000c8e:	3e650513          	add	a0,a0,998 # 80008070 <digits+0x30>
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	8b0080e7          	jalr	-1872(ra) # 80000542 <panic>

0000000080000c9a <pop_off>:

void
pop_off(void)
{
    80000c9a:	1141                	add	sp,sp,-16
    80000c9c:	e406                	sd	ra,8(sp)
    80000c9e:	e022                	sd	s0,0(sp)
    80000ca0:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000ca2:	00001097          	auipc	ra,0x1
    80000ca6:	d52080e7          	jalr	-686(ra) # 800019f4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000caa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cae:	8b89                	and	a5,a5,2
  if(intr_get())
    80000cb0:	e78d                	bnez	a5,80000cda <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cb2:	5d3c                	lw	a5,120(a0)
    80000cb4:	02f05b63          	blez	a5,80000cea <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000cb8:	37fd                	addw	a5,a5,-1
    80000cba:	0007871b          	sext.w	a4,a5
    80000cbe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cc0:	eb09                	bnez	a4,80000cd2 <pop_off+0x38>
    80000cc2:	5d7c                	lw	a5,124(a0)
    80000cc4:	c799                	beqz	a5,80000cd2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cca:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cce:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cd2:	60a2                	ld	ra,8(sp)
    80000cd4:	6402                	ld	s0,0(sp)
    80000cd6:	0141                	add	sp,sp,16
    80000cd8:	8082                	ret
    panic("pop_off - interruptible");
    80000cda:	00007517          	auipc	a0,0x7
    80000cde:	39e50513          	add	a0,a0,926 # 80008078 <digits+0x38>
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	860080e7          	jalr	-1952(ra) # 80000542 <panic>
    panic("pop_off");
    80000cea:	00007517          	auipc	a0,0x7
    80000cee:	3a650513          	add	a0,a0,934 # 80008090 <digits+0x50>
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	850080e7          	jalr	-1968(ra) # 80000542 <panic>

0000000080000cfa <release>:
{
    80000cfa:	1101                	add	sp,sp,-32
    80000cfc:	ec06                	sd	ra,24(sp)
    80000cfe:	e822                	sd	s0,16(sp)
    80000d00:	e426                	sd	s1,8(sp)
    80000d02:	1000                	add	s0,sp,32
    80000d04:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d06:	00000097          	auipc	ra,0x0
    80000d0a:	ec6080e7          	jalr	-314(ra) # 80000bcc <holding>
    80000d0e:	c115                	beqz	a0,80000d32 <release+0x38>
  lk->cpu = 0;
    80000d10:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d14:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d18:	0f50000f          	fence	iorw,ow
    80000d1c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d20:	00000097          	auipc	ra,0x0
    80000d24:	f7a080e7          	jalr	-134(ra) # 80000c9a <pop_off>
}
    80000d28:	60e2                	ld	ra,24(sp)
    80000d2a:	6442                	ld	s0,16(sp)
    80000d2c:	64a2                	ld	s1,8(sp)
    80000d2e:	6105                	add	sp,sp,32
    80000d30:	8082                	ret
    panic("release");
    80000d32:	00007517          	auipc	a0,0x7
    80000d36:	36650513          	add	a0,a0,870 # 80008098 <digits+0x58>
    80000d3a:	00000097          	auipc	ra,0x0
    80000d3e:	808080e7          	jalr	-2040(ra) # 80000542 <panic>

0000000080000d42 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d42:	1141                	add	sp,sp,-16
    80000d44:	e422                	sd	s0,8(sp)
    80000d46:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d48:	ca19                	beqz	a2,80000d5e <memset+0x1c>
    80000d4a:	87aa                	mv	a5,a0
    80000d4c:	1602                	sll	a2,a2,0x20
    80000d4e:	9201                	srl	a2,a2,0x20
    80000d50:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d54:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d58:	0785                	add	a5,a5,1
    80000d5a:	fee79de3          	bne	a5,a4,80000d54 <memset+0x12>
  }
  return dst;
}
    80000d5e:	6422                	ld	s0,8(sp)
    80000d60:	0141                	add	sp,sp,16
    80000d62:	8082                	ret

0000000080000d64 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d64:	1141                	add	sp,sp,-16
    80000d66:	e422                	sd	s0,8(sp)
    80000d68:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d6a:	ca05                	beqz	a2,80000d9a <memcmp+0x36>
    80000d6c:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d70:	1682                	sll	a3,a3,0x20
    80000d72:	9281                	srl	a3,a3,0x20
    80000d74:	0685                	add	a3,a3,1
    80000d76:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d78:	00054783          	lbu	a5,0(a0)
    80000d7c:	0005c703          	lbu	a4,0(a1)
    80000d80:	00e79863          	bne	a5,a4,80000d90 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d84:	0505                	add	a0,a0,1
    80000d86:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000d88:	fed518e3          	bne	a0,a3,80000d78 <memcmp+0x14>
  }

  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	a019                	j	80000d94 <memcmp+0x30>
      return *s1 - *s2;
    80000d90:	40e7853b          	subw	a0,a5,a4
}
    80000d94:	6422                	ld	s0,8(sp)
    80000d96:	0141                	add	sp,sp,16
    80000d98:	8082                	ret
  return 0;
    80000d9a:	4501                	li	a0,0
    80000d9c:	bfe5                	j	80000d94 <memcmp+0x30>

0000000080000d9e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d9e:	1141                	add	sp,sp,-16
    80000da0:	e422                	sd	s0,8(sp)
    80000da2:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000da4:	02a5e563          	bltu	a1,a0,80000dce <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000da8:	fff6069b          	addw	a3,a2,-1
    80000dac:	ce11                	beqz	a2,80000dc8 <memmove+0x2a>
    80000dae:	1682                	sll	a3,a3,0x20
    80000db0:	9281                	srl	a3,a3,0x20
    80000db2:	0685                	add	a3,a3,1
    80000db4:	96ae                	add	a3,a3,a1
    80000db6:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000db8:	0585                	add	a1,a1,1
    80000dba:	0785                	add	a5,a5,1
    80000dbc:	fff5c703          	lbu	a4,-1(a1)
    80000dc0:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000dc4:	fed59ae3          	bne	a1,a3,80000db8 <memmove+0x1a>

  return dst;
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	add	sp,sp,16
    80000dcc:	8082                	ret
  if(s < d && s + n > d){
    80000dce:	02061713          	sll	a4,a2,0x20
    80000dd2:	9301                	srl	a4,a4,0x20
    80000dd4:	00e587b3          	add	a5,a1,a4
    80000dd8:	fcf578e3          	bgeu	a0,a5,80000da8 <memmove+0xa>
    d += n;
    80000ddc:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dde:	fff6069b          	addw	a3,a2,-1
    80000de2:	d27d                	beqz	a2,80000dc8 <memmove+0x2a>
    80000de4:	02069613          	sll	a2,a3,0x20
    80000de8:	9201                	srl	a2,a2,0x20
    80000dea:	fff64613          	not	a2,a2
    80000dee:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000df0:	17fd                	add	a5,a5,-1
    80000df2:	177d                	add	a4,a4,-1 # fff <_entry-0x7ffff001>
    80000df4:	0007c683          	lbu	a3,0(a5)
    80000df8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dfc:	fef61ae3          	bne	a2,a5,80000df0 <memmove+0x52>
    80000e00:	b7e1                	j	80000dc8 <memmove+0x2a>

0000000080000e02 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e02:	1141                	add	sp,sp,-16
    80000e04:	e406                	sd	ra,8(sp)
    80000e06:	e022                	sd	s0,0(sp)
    80000e08:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000e0a:	00000097          	auipc	ra,0x0
    80000e0e:	f94080e7          	jalr	-108(ra) # 80000d9e <memmove>
}
    80000e12:	60a2                	ld	ra,8(sp)
    80000e14:	6402                	ld	s0,0(sp)
    80000e16:	0141                	add	sp,sp,16
    80000e18:	8082                	ret

0000000080000e1a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e1a:	1141                	add	sp,sp,-16
    80000e1c:	e422                	sd	s0,8(sp)
    80000e1e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e20:	ce11                	beqz	a2,80000e3c <strncmp+0x22>
    80000e22:	00054783          	lbu	a5,0(a0)
    80000e26:	cf89                	beqz	a5,80000e40 <strncmp+0x26>
    80000e28:	0005c703          	lbu	a4,0(a1)
    80000e2c:	00f71a63          	bne	a4,a5,80000e40 <strncmp+0x26>
    n--, p++, q++;
    80000e30:	367d                	addw	a2,a2,-1
    80000e32:	0505                	add	a0,a0,1
    80000e34:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e36:	f675                	bnez	a2,80000e22 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e38:	4501                	li	a0,0
    80000e3a:	a809                	j	80000e4c <strncmp+0x32>
    80000e3c:	4501                	li	a0,0
    80000e3e:	a039                	j	80000e4c <strncmp+0x32>
  if(n == 0)
    80000e40:	ca09                	beqz	a2,80000e52 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e42:	00054503          	lbu	a0,0(a0)
    80000e46:	0005c783          	lbu	a5,0(a1)
    80000e4a:	9d1d                	subw	a0,a0,a5
}
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	add	sp,sp,16
    80000e50:	8082                	ret
    return 0;
    80000e52:	4501                	li	a0,0
    80000e54:	bfe5                	j	80000e4c <strncmp+0x32>

0000000080000e56 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e56:	1141                	add	sp,sp,-16
    80000e58:	e422                	sd	s0,8(sp)
    80000e5a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	86b2                	mv	a3,a2
    80000e60:	367d                	addw	a2,a2,-1
    80000e62:	00d05963          	blez	a3,80000e74 <strncpy+0x1e>
    80000e66:	0785                	add	a5,a5,1
    80000e68:	0005c703          	lbu	a4,0(a1)
    80000e6c:	fee78fa3          	sb	a4,-1(a5)
    80000e70:	0585                	add	a1,a1,1
    80000e72:	f775                	bnez	a4,80000e5e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e74:	873e                	mv	a4,a5
    80000e76:	9fb5                	addw	a5,a5,a3
    80000e78:	37fd                	addw	a5,a5,-1
    80000e7a:	00c05963          	blez	a2,80000e8c <strncpy+0x36>
    *s++ = 0;
    80000e7e:	0705                	add	a4,a4,1
    80000e80:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e84:	40e786bb          	subw	a3,a5,a4
    80000e88:	fed04be3          	bgtz	a3,80000e7e <strncpy+0x28>
  return os;
}
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	add	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e92:	1141                	add	sp,sp,-16
    80000e94:	e422                	sd	s0,8(sp)
    80000e96:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e98:	02c05363          	blez	a2,80000ebe <safestrcpy+0x2c>
    80000e9c:	fff6069b          	addw	a3,a2,-1
    80000ea0:	1682                	sll	a3,a3,0x20
    80000ea2:	9281                	srl	a3,a3,0x20
    80000ea4:	96ae                	add	a3,a3,a1
    80000ea6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ea8:	00d58963          	beq	a1,a3,80000eba <safestrcpy+0x28>
    80000eac:	0585                	add	a1,a1,1
    80000eae:	0785                	add	a5,a5,1
    80000eb0:	fff5c703          	lbu	a4,-1(a1)
    80000eb4:	fee78fa3          	sb	a4,-1(a5)
    80000eb8:	fb65                	bnez	a4,80000ea8 <safestrcpy+0x16>
    ;
  *s = 0;
    80000eba:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ebe:	6422                	ld	s0,8(sp)
    80000ec0:	0141                	add	sp,sp,16
    80000ec2:	8082                	ret

0000000080000ec4 <strlen>:

int
strlen(const char *s)
{
    80000ec4:	1141                	add	sp,sp,-16
    80000ec6:	e422                	sd	s0,8(sp)
    80000ec8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eca:	00054783          	lbu	a5,0(a0)
    80000ece:	cf91                	beqz	a5,80000eea <strlen+0x26>
    80000ed0:	0505                	add	a0,a0,1
    80000ed2:	87aa                	mv	a5,a0
    80000ed4:	86be                	mv	a3,a5
    80000ed6:	0785                	add	a5,a5,1
    80000ed8:	fff7c703          	lbu	a4,-1(a5)
    80000edc:	ff65                	bnez	a4,80000ed4 <strlen+0x10>
    80000ede:	40a6853b          	subw	a0,a3,a0
    80000ee2:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000ee4:	6422                	ld	s0,8(sp)
    80000ee6:	0141                	add	sp,sp,16
    80000ee8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eea:	4501                	li	a0,0
    80000eec:	bfe5                	j	80000ee4 <strlen+0x20>

0000000080000eee <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eee:	1141                	add	sp,sp,-16
    80000ef0:	e406                	sd	ra,8(sp)
    80000ef2:	e022                	sd	s0,0(sp)
    80000ef4:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	aee080e7          	jalr	-1298(ra) # 800019e4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000efe:	00008717          	auipc	a4,0x8
    80000f02:	10e70713          	add	a4,a4,270 # 8000900c <started>
  if(cpuid() == 0){
    80000f06:	c139                	beqz	a0,80000f4c <main+0x5e>
    while(started == 0)
    80000f08:	431c                	lw	a5,0(a4)
    80000f0a:	2781                	sext.w	a5,a5
    80000f0c:	dff5                	beqz	a5,80000f08 <main+0x1a>
      ;
    __sync_synchronize();
    80000f0e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f12:	00001097          	auipc	ra,0x1
    80000f16:	ad2080e7          	jalr	-1326(ra) # 800019e4 <cpuid>
    80000f1a:	85aa                	mv	a1,a0
    80000f1c:	00007517          	auipc	a0,0x7
    80000f20:	19c50513          	add	a0,a0,412 # 800080b8 <digits+0x78>
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	668080e7          	jalr	1640(ra) # 8000058c <printf>
    kvminithart();    // turn on paging
    80000f2c:	00000097          	auipc	ra,0x0
    80000f30:	0d8080e7          	jalr	216(ra) # 80001004 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f34:	00001097          	auipc	ra,0x1
    80000f38:	76e080e7          	jalr	1902(ra) # 800026a2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	d74080e7          	jalr	-652(ra) # 80005cb0 <plicinithart>
  }

  scheduler();        
    80000f44:	00001097          	auipc	ra,0x1
    80000f48:	00c080e7          	jalr	12(ra) # 80001f50 <scheduler>
    consoleinit();
    80000f4c:	fffff097          	auipc	ra,0xfffff
    80000f50:	506080e7          	jalr	1286(ra) # 80000452 <consoleinit>
    printfinit();
    80000f54:	00000097          	auipc	ra,0x0
    80000f58:	818080e7          	jalr	-2024(ra) # 8000076c <printfinit>
    printf("\n");
    80000f5c:	00007517          	auipc	a0,0x7
    80000f60:	16c50513          	add	a0,a0,364 # 800080c8 <digits+0x88>
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	628080e7          	jalr	1576(ra) # 8000058c <printf>
    printf("xv6 kernel is booting\n");
    80000f6c:	00007517          	auipc	a0,0x7
    80000f70:	13450513          	add	a0,a0,308 # 800080a0 <digits+0x60>
    80000f74:	fffff097          	auipc	ra,0xfffff
    80000f78:	618080e7          	jalr	1560(ra) # 8000058c <printf>
    printf("\n");
    80000f7c:	00007517          	auipc	a0,0x7
    80000f80:	14c50513          	add	a0,a0,332 # 800080c8 <digits+0x88>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	608080e7          	jalr	1544(ra) # 8000058c <printf>
    kinit();         // physical page allocator
    80000f8c:	00000097          	auipc	ra,0x0
    80000f90:	b44080e7          	jalr	-1212(ra) # 80000ad0 <kinit>
    kvminit();       // create kernel page table
    80000f94:	00000097          	auipc	ra,0x0
    80000f98:	2a0080e7          	jalr	672(ra) # 80001234 <kvminit>
    kvminithart();   // turn on paging
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	068080e7          	jalr	104(ra) # 80001004 <kvminithart>
    procinit();      // process table
    80000fa4:	00001097          	auipc	ra,0x1
    80000fa8:	970080e7          	jalr	-1680(ra) # 80001914 <procinit>
    trapinit();      // trap vectors
    80000fac:	00001097          	auipc	ra,0x1
    80000fb0:	6ce080e7          	jalr	1742(ra) # 8000267a <trapinit>
    trapinithart();  // install kernel trap vector
    80000fb4:	00001097          	auipc	ra,0x1
    80000fb8:	6ee080e7          	jalr	1774(ra) # 800026a2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fbc:	00005097          	auipc	ra,0x5
    80000fc0:	cde080e7          	jalr	-802(ra) # 80005c9a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fc4:	00005097          	auipc	ra,0x5
    80000fc8:	cec080e7          	jalr	-788(ra) # 80005cb0 <plicinithart>
    binit();         // buffer cache
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	ee6080e7          	jalr	-282(ra) # 80002eb2 <binit>
    iinit();         // inode cache
    80000fd4:	00002097          	auipc	ra,0x2
    80000fd8:	572080e7          	jalr	1394(ra) # 80003546 <iinit>
    fileinit();      // file table
    80000fdc:	00003097          	auipc	ra,0x3
    80000fe0:	4e4080e7          	jalr	1252(ra) # 800044c0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fe4:	00005097          	auipc	ra,0x5
    80000fe8:	dd2080e7          	jalr	-558(ra) # 80005db6 <virtio_disk_init>
    userinit();      // first user process
    80000fec:	00001097          	auipc	ra,0x1
    80000ff0:	cee080e7          	jalr	-786(ra) # 80001cda <userinit>
    __sync_synchronize();
    80000ff4:	0ff0000f          	fence
    started = 1;
    80000ff8:	4785                	li	a5,1
    80000ffa:	00008717          	auipc	a4,0x8
    80000ffe:	00f72923          	sw	a5,18(a4) # 8000900c <started>
    80001002:	b789                	j	80000f44 <main+0x56>

0000000080001004 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001004:	1141                	add	sp,sp,-16
    80001006:	e422                	sd	s0,8(sp)
    80001008:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000100a:	00008797          	auipc	a5,0x8
    8000100e:	0067b783          	ld	a5,6(a5) # 80009010 <kernel_pagetable>
    80001012:	83b1                	srl	a5,a5,0xc
    80001014:	577d                	li	a4,-1
    80001016:	177e                	sll	a4,a4,0x3f
    80001018:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000101a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000101e:	12000073          	sfence.vma
  sfence_vma();
}
    80001022:	6422                	ld	s0,8(sp)
    80001024:	0141                	add	sp,sp,16
    80001026:	8082                	ret

0000000080001028 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001028:	7139                	add	sp,sp,-64
    8000102a:	fc06                	sd	ra,56(sp)
    8000102c:	f822                	sd	s0,48(sp)
    8000102e:	f426                	sd	s1,40(sp)
    80001030:	f04a                	sd	s2,32(sp)
    80001032:	ec4e                	sd	s3,24(sp)
    80001034:	e852                	sd	s4,16(sp)
    80001036:	e456                	sd	s5,8(sp)
    80001038:	e05a                	sd	s6,0(sp)
    8000103a:	0080                	add	s0,sp,64
    8000103c:	84aa                	mv	s1,a0
    8000103e:	89ae                	mv	s3,a1
    80001040:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001042:	57fd                	li	a5,-1
    80001044:	83e9                	srl	a5,a5,0x1a
    80001046:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001048:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000104a:	04b7f263          	bgeu	a5,a1,8000108e <walk+0x66>
    panic("walk");
    8000104e:	00007517          	auipc	a0,0x7
    80001052:	08250513          	add	a0,a0,130 # 800080d0 <digits+0x90>
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	4ec080e7          	jalr	1260(ra) # 80000542 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000105e:	060a8663          	beqz	s5,800010ca <walk+0xa2>
    80001062:	00000097          	auipc	ra,0x0
    80001066:	aaa080e7          	jalr	-1366(ra) # 80000b0c <kalloc>
    8000106a:	84aa                	mv	s1,a0
    8000106c:	c529                	beqz	a0,800010b6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000106e:	6605                	lui	a2,0x1
    80001070:	4581                	li	a1,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	cd0080e7          	jalr	-816(ra) # 80000d42 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000107a:	00c4d793          	srl	a5,s1,0xc
    8000107e:	07aa                	sll	a5,a5,0xa
    80001080:	0017e793          	or	a5,a5,1
    80001084:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001088:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    8000108a:	036a0063          	beq	s4,s6,800010aa <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000108e:	0149d933          	srl	s2,s3,s4
    80001092:	1ff97913          	and	s2,s2,511
    80001096:	090e                	sll	s2,s2,0x3
    80001098:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000109a:	00093483          	ld	s1,0(s2)
    8000109e:	0014f793          	and	a5,s1,1
    800010a2:	dfd5                	beqz	a5,8000105e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010a4:	80a9                	srl	s1,s1,0xa
    800010a6:	04b2                	sll	s1,s1,0xc
    800010a8:	b7c5                	j	80001088 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010aa:	00c9d513          	srl	a0,s3,0xc
    800010ae:	1ff57513          	and	a0,a0,511
    800010b2:	050e                	sll	a0,a0,0x3
    800010b4:	9526                	add	a0,a0,s1
}
    800010b6:	70e2                	ld	ra,56(sp)
    800010b8:	7442                	ld	s0,48(sp)
    800010ba:	74a2                	ld	s1,40(sp)
    800010bc:	7902                	ld	s2,32(sp)
    800010be:	69e2                	ld	s3,24(sp)
    800010c0:	6a42                	ld	s4,16(sp)
    800010c2:	6aa2                	ld	s5,8(sp)
    800010c4:	6b02                	ld	s6,0(sp)
    800010c6:	6121                	add	sp,sp,64
    800010c8:	8082                	ret
        return 0;
    800010ca:	4501                	li	a0,0
    800010cc:	b7ed                	j	800010b6 <walk+0x8e>

00000000800010ce <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010ce:	57fd                	li	a5,-1
    800010d0:	83e9                	srl	a5,a5,0x1a
    800010d2:	00b7f463          	bgeu	a5,a1,800010da <walkaddr+0xc>
    return 0;
    800010d6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010d8:	8082                	ret
{
    800010da:	1141                	add	sp,sp,-16
    800010dc:	e406                	sd	ra,8(sp)
    800010de:	e022                	sd	s0,0(sp)
    800010e0:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010e2:	4601                	li	a2,0
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f44080e7          	jalr	-188(ra) # 80001028 <walk>
  if(pte == 0)
    800010ec:	c105                	beqz	a0,8000110c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010ee:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010f0:	0117f693          	and	a3,a5,17
    800010f4:	4745                	li	a4,17
    return 0;
    800010f6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010f8:	00e68663          	beq	a3,a4,80001104 <walkaddr+0x36>
}
    800010fc:	60a2                	ld	ra,8(sp)
    800010fe:	6402                	ld	s0,0(sp)
    80001100:	0141                	add	sp,sp,16
    80001102:	8082                	ret
  pa = PTE2PA(*pte);
    80001104:	83a9                	srl	a5,a5,0xa
    80001106:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000110a:	bfcd                	j	800010fc <walkaddr+0x2e>
    return 0;
    8000110c:	4501                	li	a0,0
    8000110e:	b7fd                	j	800010fc <walkaddr+0x2e>

0000000080001110 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    80001110:	1101                	add	sp,sp,-32
    80001112:	ec06                	sd	ra,24(sp)
    80001114:	e822                	sd	s0,16(sp)
    80001116:	e426                	sd	s1,8(sp)
    80001118:	1000                	add	s0,sp,32
    8000111a:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    8000111c:	1552                	sll	a0,a0,0x34
    8000111e:	03455493          	srl	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    80001122:	4601                	li	a2,0
    80001124:	00008517          	auipc	a0,0x8
    80001128:	eec53503          	ld	a0,-276(a0) # 80009010 <kernel_pagetable>
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	efc080e7          	jalr	-260(ra) # 80001028 <walk>
  if(pte == 0)
    80001134:	cd09                	beqz	a0,8000114e <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    80001136:	6108                	ld	a0,0(a0)
    80001138:	00157793          	and	a5,a0,1
    8000113c:	c38d                	beqz	a5,8000115e <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    8000113e:	8129                	srl	a0,a0,0xa
    80001140:	0532                	sll	a0,a0,0xc
  return pa+off;
}
    80001142:	9526                	add	a0,a0,s1
    80001144:	60e2                	ld	ra,24(sp)
    80001146:	6442                	ld	s0,16(sp)
    80001148:	64a2                	ld	s1,8(sp)
    8000114a:	6105                	add	sp,sp,32
    8000114c:	8082                	ret
    panic("kvmpa");
    8000114e:	00007517          	auipc	a0,0x7
    80001152:	f8a50513          	add	a0,a0,-118 # 800080d8 <digits+0x98>
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	3ec080e7          	jalr	1004(ra) # 80000542 <panic>
    panic("kvmpa");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f7a50513          	add	a0,a0,-134 # 800080d8 <digits+0x98>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3dc080e7          	jalr	988(ra) # 80000542 <panic>

000000008000116e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000116e:	715d                	add	sp,sp,-80
    80001170:	e486                	sd	ra,72(sp)
    80001172:	e0a2                	sd	s0,64(sp)
    80001174:	fc26                	sd	s1,56(sp)
    80001176:	f84a                	sd	s2,48(sp)
    80001178:	f44e                	sd	s3,40(sp)
    8000117a:	f052                	sd	s4,32(sp)
    8000117c:	ec56                	sd	s5,24(sp)
    8000117e:	e85a                	sd	s6,16(sp)
    80001180:	e45e                	sd	s7,8(sp)
    80001182:	0880                	add	s0,sp,80
    80001184:	8aaa                	mv	s5,a0
    80001186:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001188:	777d                	lui	a4,0xfffff
    8000118a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000118e:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    80001192:	99ae                	add	s3,s3,a1
    80001194:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001198:	893e                	mv	s2,a5
    8000119a:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000119e:	6b85                	lui	s7,0x1
    800011a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011a4:	4605                	li	a2,1
    800011a6:	85ca                	mv	a1,s2
    800011a8:	8556                	mv	a0,s5
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	e7e080e7          	jalr	-386(ra) # 80001028 <walk>
    800011b2:	c51d                	beqz	a0,800011e0 <mappages+0x72>
    if(*pte & PTE_V)
    800011b4:	611c                	ld	a5,0(a0)
    800011b6:	8b85                	and	a5,a5,1
    800011b8:	ef81                	bnez	a5,800011d0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011ba:	80b1                	srl	s1,s1,0xc
    800011bc:	04aa                	sll	s1,s1,0xa
    800011be:	0164e4b3          	or	s1,s1,s6
    800011c2:	0014e493          	or	s1,s1,1
    800011c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800011c8:	03390863          	beq	s2,s3,800011f8 <mappages+0x8a>
    a += PGSIZE;
    800011cc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ce:	bfc9                	j	800011a0 <mappages+0x32>
      panic("remap");
    800011d0:	00007517          	auipc	a0,0x7
    800011d4:	f1050513          	add	a0,a0,-240 # 800080e0 <digits+0xa0>
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	36a080e7          	jalr	874(ra) # 80000542 <panic>
      return -1;
    800011e0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011e2:	60a6                	ld	ra,72(sp)
    800011e4:	6406                	ld	s0,64(sp)
    800011e6:	74e2                	ld	s1,56(sp)
    800011e8:	7942                	ld	s2,48(sp)
    800011ea:	79a2                	ld	s3,40(sp)
    800011ec:	7a02                	ld	s4,32(sp)
    800011ee:	6ae2                	ld	s5,24(sp)
    800011f0:	6b42                	ld	s6,16(sp)
    800011f2:	6ba2                	ld	s7,8(sp)
    800011f4:	6161                	add	sp,sp,80
    800011f6:	8082                	ret
  return 0;
    800011f8:	4501                	li	a0,0
    800011fa:	b7e5                	j	800011e2 <mappages+0x74>

00000000800011fc <kvmmap>:
{
    800011fc:	1141                	add	sp,sp,-16
    800011fe:	e406                	sd	ra,8(sp)
    80001200:	e022                	sd	s0,0(sp)
    80001202:	0800                	add	s0,sp,16
    80001204:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001206:	86ae                	mv	a3,a1
    80001208:	85aa                	mv	a1,a0
    8000120a:	00008517          	auipc	a0,0x8
    8000120e:	e0653503          	ld	a0,-506(a0) # 80009010 <kernel_pagetable>
    80001212:	00000097          	auipc	ra,0x0
    80001216:	f5c080e7          	jalr	-164(ra) # 8000116e <mappages>
    8000121a:	e509                	bnez	a0,80001224 <kvmmap+0x28>
}
    8000121c:	60a2                	ld	ra,8(sp)
    8000121e:	6402                	ld	s0,0(sp)
    80001220:	0141                	add	sp,sp,16
    80001222:	8082                	ret
    panic("kvmmap");
    80001224:	00007517          	auipc	a0,0x7
    80001228:	ec450513          	add	a0,a0,-316 # 800080e8 <digits+0xa8>
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	316080e7          	jalr	790(ra) # 80000542 <panic>

0000000080001234 <kvminit>:
{
    80001234:	1101                	add	sp,sp,-32
    80001236:	ec06                	sd	ra,24(sp)
    80001238:	e822                	sd	s0,16(sp)
    8000123a:	e426                	sd	s1,8(sp)
    8000123c:	1000                	add	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	8ce080e7          	jalr	-1842(ra) # 80000b0c <kalloc>
    80001246:	00008717          	auipc	a4,0x8
    8000124a:	dca73523          	sd	a0,-566(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000124e:	6605                	lui	a2,0x1
    80001250:	4581                	li	a1,0
    80001252:	00000097          	auipc	ra,0x0
    80001256:	af0080e7          	jalr	-1296(ra) # 80000d42 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000125a:	4699                	li	a3,6
    8000125c:	6605                	lui	a2,0x1
    8000125e:	100005b7          	lui	a1,0x10000
    80001262:	10000537          	lui	a0,0x10000
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	f96080e7          	jalr	-106(ra) # 800011fc <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000126e:	4699                	li	a3,6
    80001270:	6605                	lui	a2,0x1
    80001272:	100015b7          	lui	a1,0x10001
    80001276:	10001537          	lui	a0,0x10001
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	f82080e7          	jalr	-126(ra) # 800011fc <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001282:	4699                	li	a3,6
    80001284:	6641                	lui	a2,0x10
    80001286:	020005b7          	lui	a1,0x2000
    8000128a:	02000537          	lui	a0,0x2000
    8000128e:	00000097          	auipc	ra,0x0
    80001292:	f6e080e7          	jalr	-146(ra) # 800011fc <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001296:	4699                	li	a3,6
    80001298:	00400637          	lui	a2,0x400
    8000129c:	0c0005b7          	lui	a1,0xc000
    800012a0:	0c000537          	lui	a0,0xc000
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	f58080e7          	jalr	-168(ra) # 800011fc <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012ac:	00007497          	auipc	s1,0x7
    800012b0:	d5448493          	add	s1,s1,-684 # 80008000 <etext>
    800012b4:	46a9                	li	a3,10
    800012b6:	80007617          	auipc	a2,0x80007
    800012ba:	d4a60613          	add	a2,a2,-694 # 8000 <_entry-0x7fff8000>
    800012be:	4585                	li	a1,1
    800012c0:	05fe                	sll	a1,a1,0x1f
    800012c2:	852e                	mv	a0,a1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f38080e7          	jalr	-200(ra) # 800011fc <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012cc:	4699                	li	a3,6
    800012ce:	4645                	li	a2,17
    800012d0:	066e                	sll	a2,a2,0x1b
    800012d2:	8e05                	sub	a2,a2,s1
    800012d4:	85a6                	mv	a1,s1
    800012d6:	8526                	mv	a0,s1
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	f24080e7          	jalr	-220(ra) # 800011fc <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012e0:	46a9                	li	a3,10
    800012e2:	6605                	lui	a2,0x1
    800012e4:	00006597          	auipc	a1,0x6
    800012e8:	d1c58593          	add	a1,a1,-740 # 80007000 <_trampoline>
    800012ec:	04000537          	lui	a0,0x4000
    800012f0:	157d                	add	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    800012f2:	0532                	sll	a0,a0,0xc
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	f08080e7          	jalr	-248(ra) # 800011fc <kvmmap>
}
    800012fc:	60e2                	ld	ra,24(sp)
    800012fe:	6442                	ld	s0,16(sp)
    80001300:	64a2                	ld	s1,8(sp)
    80001302:	6105                	add	sp,sp,32
    80001304:	8082                	ret

0000000080001306 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001306:	715d                	add	sp,sp,-80
    80001308:	e486                	sd	ra,72(sp)
    8000130a:	e0a2                	sd	s0,64(sp)
    8000130c:	fc26                	sd	s1,56(sp)
    8000130e:	f84a                	sd	s2,48(sp)
    80001310:	f44e                	sd	s3,40(sp)
    80001312:	f052                	sd	s4,32(sp)
    80001314:	ec56                	sd	s5,24(sp)
    80001316:	e85a                	sd	s6,16(sp)
    80001318:	e45e                	sd	s7,8(sp)
    8000131a:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000131c:	03459793          	sll	a5,a1,0x34
    80001320:	e795                	bnez	a5,8000134c <uvmunmap+0x46>
    80001322:	8a2a                	mv	s4,a0
    80001324:	892e                	mv	s2,a1
    80001326:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001328:	0632                	sll	a2,a2,0xc
    8000132a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000132e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001330:	6b05                	lui	s6,0x1
    80001332:	0735e263          	bltu	a1,s3,80001396 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001336:	60a6                	ld	ra,72(sp)
    80001338:	6406                	ld	s0,64(sp)
    8000133a:	74e2                	ld	s1,56(sp)
    8000133c:	7942                	ld	s2,48(sp)
    8000133e:	79a2                	ld	s3,40(sp)
    80001340:	7a02                	ld	s4,32(sp)
    80001342:	6ae2                	ld	s5,24(sp)
    80001344:	6b42                	ld	s6,16(sp)
    80001346:	6ba2                	ld	s7,8(sp)
    80001348:	6161                	add	sp,sp,80
    8000134a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000134c:	00007517          	auipc	a0,0x7
    80001350:	da450513          	add	a0,a0,-604 # 800080f0 <digits+0xb0>
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	1ee080e7          	jalr	494(ra) # 80000542 <panic>
      panic("uvmunmap: walk");
    8000135c:	00007517          	auipc	a0,0x7
    80001360:	dac50513          	add	a0,a0,-596 # 80008108 <digits+0xc8>
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	1de080e7          	jalr	478(ra) # 80000542 <panic>
      panic("uvmunmap: not mapped");
    8000136c:	00007517          	auipc	a0,0x7
    80001370:	dac50513          	add	a0,a0,-596 # 80008118 <digits+0xd8>
    80001374:	fffff097          	auipc	ra,0xfffff
    80001378:	1ce080e7          	jalr	462(ra) # 80000542 <panic>
      panic("uvmunmap: not a leaf");
    8000137c:	00007517          	auipc	a0,0x7
    80001380:	db450513          	add	a0,a0,-588 # 80008130 <digits+0xf0>
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	1be080e7          	jalr	446(ra) # 80000542 <panic>
    *pte = 0;
    8000138c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001390:	995a                	add	s2,s2,s6
    80001392:	fb3972e3          	bgeu	s2,s3,80001336 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001396:	4601                	li	a2,0
    80001398:	85ca                	mv	a1,s2
    8000139a:	8552                	mv	a0,s4
    8000139c:	00000097          	auipc	ra,0x0
    800013a0:	c8c080e7          	jalr	-884(ra) # 80001028 <walk>
    800013a4:	84aa                	mv	s1,a0
    800013a6:	d95d                	beqz	a0,8000135c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800013a8:	6108                	ld	a0,0(a0)
    800013aa:	00157793          	and	a5,a0,1
    800013ae:	dfdd                	beqz	a5,8000136c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013b0:	3ff57793          	and	a5,a0,1023
    800013b4:	fd7784e3          	beq	a5,s7,8000137c <uvmunmap+0x76>
    if(do_free){
    800013b8:	fc0a8ae3          	beqz	s5,8000138c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800013bc:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800013be:	0532                	sll	a0,a0,0xc
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	64e080e7          	jalr	1614(ra) # 80000a0e <kfree>
    800013c8:	b7d1                	j	8000138c <uvmunmap+0x86>

00000000800013ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013ca:	1101                	add	sp,sp,-32
    800013cc:	ec06                	sd	ra,24(sp)
    800013ce:	e822                	sd	s0,16(sp)
    800013d0:	e426                	sd	s1,8(sp)
    800013d2:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	738080e7          	jalr	1848(ra) # 80000b0c <kalloc>
    800013dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013de:	c519                	beqz	a0,800013ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013e0:	6605                	lui	a2,0x1
    800013e2:	4581                	li	a1,0
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	95e080e7          	jalr	-1698(ra) # 80000d42 <memset>
  return pagetable;
}
    800013ec:	8526                	mv	a0,s1
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	add	sp,sp,32
    800013f6:	8082                	ret

00000000800013f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013f8:	7179                	add	sp,sp,-48
    800013fa:	f406                	sd	ra,40(sp)
    800013fc:	f022                	sd	s0,32(sp)
    800013fe:	ec26                	sd	s1,24(sp)
    80001400:	e84a                	sd	s2,16(sp)
    80001402:	e44e                	sd	s3,8(sp)
    80001404:	e052                	sd	s4,0(sp)
    80001406:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001408:	6785                	lui	a5,0x1
    8000140a:	04f67863          	bgeu	a2,a5,8000145a <uvminit+0x62>
    8000140e:	8a2a                	mv	s4,a0
    80001410:	89ae                	mv	s3,a1
    80001412:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	6f8080e7          	jalr	1784(ra) # 80000b0c <kalloc>
    8000141c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000141e:	6605                	lui	a2,0x1
    80001420:	4581                	li	a1,0
    80001422:	00000097          	auipc	ra,0x0
    80001426:	920080e7          	jalr	-1760(ra) # 80000d42 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000142a:	4779                	li	a4,30
    8000142c:	86ca                	mv	a3,s2
    8000142e:	6605                	lui	a2,0x1
    80001430:	4581                	li	a1,0
    80001432:	8552                	mv	a0,s4
    80001434:	00000097          	auipc	ra,0x0
    80001438:	d3a080e7          	jalr	-710(ra) # 8000116e <mappages>
  memmove(mem, src, sz);
    8000143c:	8626                	mv	a2,s1
    8000143e:	85ce                	mv	a1,s3
    80001440:	854a                	mv	a0,s2
    80001442:	00000097          	auipc	ra,0x0
    80001446:	95c080e7          	jalr	-1700(ra) # 80000d9e <memmove>
}
    8000144a:	70a2                	ld	ra,40(sp)
    8000144c:	7402                	ld	s0,32(sp)
    8000144e:	64e2                	ld	s1,24(sp)
    80001450:	6942                	ld	s2,16(sp)
    80001452:	69a2                	ld	s3,8(sp)
    80001454:	6a02                	ld	s4,0(sp)
    80001456:	6145                	add	sp,sp,48
    80001458:	8082                	ret
    panic("inituvm: more than a page");
    8000145a:	00007517          	auipc	a0,0x7
    8000145e:	cee50513          	add	a0,a0,-786 # 80008148 <digits+0x108>
    80001462:	fffff097          	auipc	ra,0xfffff
    80001466:	0e0080e7          	jalr	224(ra) # 80000542 <panic>

000000008000146a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000146a:	1101                	add	sp,sp,-32
    8000146c:	ec06                	sd	ra,24(sp)
    8000146e:	e822                	sd	s0,16(sp)
    80001470:	e426                	sd	s1,8(sp)
    80001472:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001474:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001476:	00b67d63          	bgeu	a2,a1,80001490 <uvmdealloc+0x26>
    8000147a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000147c:	6785                	lui	a5,0x1
    8000147e:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001480:	00f60733          	add	a4,a2,a5
    80001484:	76fd                	lui	a3,0xfffff
    80001486:	8f75                	and	a4,a4,a3
    80001488:	97ae                	add	a5,a5,a1
    8000148a:	8ff5                	and	a5,a5,a3
    8000148c:	00f76863          	bltu	a4,a5,8000149c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001490:	8526                	mv	a0,s1
    80001492:	60e2                	ld	ra,24(sp)
    80001494:	6442                	ld	s0,16(sp)
    80001496:	64a2                	ld	s1,8(sp)
    80001498:	6105                	add	sp,sp,32
    8000149a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000149c:	8f99                	sub	a5,a5,a4
    8000149e:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014a0:	4685                	li	a3,1
    800014a2:	0007861b          	sext.w	a2,a5
    800014a6:	85ba                	mv	a1,a4
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	e5e080e7          	jalr	-418(ra) # 80001306 <uvmunmap>
    800014b0:	b7c5                	j	80001490 <uvmdealloc+0x26>

00000000800014b2 <uvmalloc>:
  if(newsz < oldsz)
    800014b2:	0ab66163          	bltu	a2,a1,80001554 <uvmalloc+0xa2>
{
    800014b6:	7139                	add	sp,sp,-64
    800014b8:	fc06                	sd	ra,56(sp)
    800014ba:	f822                	sd	s0,48(sp)
    800014bc:	f426                	sd	s1,40(sp)
    800014be:	f04a                	sd	s2,32(sp)
    800014c0:	ec4e                	sd	s3,24(sp)
    800014c2:	e852                	sd	s4,16(sp)
    800014c4:	e456                	sd	s5,8(sp)
    800014c6:	0080                	add	s0,sp,64
    800014c8:	8aaa                	mv	s5,a0
    800014ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014cc:	6785                	lui	a5,0x1
    800014ce:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014d0:	95be                	add	a1,a1,a5
    800014d2:	77fd                	lui	a5,0xfffff
    800014d4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d8:	08c9f063          	bgeu	s3,a2,80001558 <uvmalloc+0xa6>
    800014dc:	894e                	mv	s2,s3
    mem = kalloc();
    800014de:	fffff097          	auipc	ra,0xfffff
    800014e2:	62e080e7          	jalr	1582(ra) # 80000b0c <kalloc>
    800014e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800014e8:	c51d                	beqz	a0,80001516 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014ea:	6605                	lui	a2,0x1
    800014ec:	4581                	li	a1,0
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	854080e7          	jalr	-1964(ra) # 80000d42 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014f6:	4779                	li	a4,30
    800014f8:	86a6                	mv	a3,s1
    800014fa:	6605                	lui	a2,0x1
    800014fc:	85ca                	mv	a1,s2
    800014fe:	8556                	mv	a0,s5
    80001500:	00000097          	auipc	ra,0x0
    80001504:	c6e080e7          	jalr	-914(ra) # 8000116e <mappages>
    80001508:	e905                	bnez	a0,80001538 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000150a:	6785                	lui	a5,0x1
    8000150c:	993e                	add	s2,s2,a5
    8000150e:	fd4968e3          	bltu	s2,s4,800014de <uvmalloc+0x2c>
  return newsz;
    80001512:	8552                	mv	a0,s4
    80001514:	a809                	j	80001526 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001516:	864e                	mv	a2,s3
    80001518:	85ca                	mv	a1,s2
    8000151a:	8556                	mv	a0,s5
    8000151c:	00000097          	auipc	ra,0x0
    80001520:	f4e080e7          	jalr	-178(ra) # 8000146a <uvmdealloc>
      return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	70e2                	ld	ra,56(sp)
    80001528:	7442                	ld	s0,48(sp)
    8000152a:	74a2                	ld	s1,40(sp)
    8000152c:	7902                	ld	s2,32(sp)
    8000152e:	69e2                	ld	s3,24(sp)
    80001530:	6a42                	ld	s4,16(sp)
    80001532:	6aa2                	ld	s5,8(sp)
    80001534:	6121                	add	sp,sp,64
    80001536:	8082                	ret
      kfree(mem);
    80001538:	8526                	mv	a0,s1
    8000153a:	fffff097          	auipc	ra,0xfffff
    8000153e:	4d4080e7          	jalr	1236(ra) # 80000a0e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001542:	864e                	mv	a2,s3
    80001544:	85ca                	mv	a1,s2
    80001546:	8556                	mv	a0,s5
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	f22080e7          	jalr	-222(ra) # 8000146a <uvmdealloc>
      return 0;
    80001550:	4501                	li	a0,0
    80001552:	bfd1                	j	80001526 <uvmalloc+0x74>
    return oldsz;
    80001554:	852e                	mv	a0,a1
}
    80001556:	8082                	ret
  return newsz;
    80001558:	8532                	mv	a0,a2
    8000155a:	b7f1                	j	80001526 <uvmalloc+0x74>

000000008000155c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000155c:	7179                	add	sp,sp,-48
    8000155e:	f406                	sd	ra,40(sp)
    80001560:	f022                	sd	s0,32(sp)
    80001562:	ec26                	sd	s1,24(sp)
    80001564:	e84a                	sd	s2,16(sp)
    80001566:	e44e                	sd	s3,8(sp)
    80001568:	e052                	sd	s4,0(sp)
    8000156a:	1800                	add	s0,sp,48
    8000156c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000156e:	84aa                	mv	s1,a0
    80001570:	6905                	lui	s2,0x1
    80001572:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001574:	4985                	li	s3,1
    80001576:	a829                	j	80001590 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001578:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000157a:	00c79513          	sll	a0,a5,0xc
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	fde080e7          	jalr	-34(ra) # 8000155c <freewalk>
      pagetable[i] = 0;
    80001586:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000158a:	04a1                	add	s1,s1,8
    8000158c:	03248163          	beq	s1,s2,800015ae <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001590:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001592:	00f7f713          	and	a4,a5,15
    80001596:	ff3701e3          	beq	a4,s3,80001578 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000159a:	8b85                	and	a5,a5,1
    8000159c:	d7fd                	beqz	a5,8000158a <freewalk+0x2e>
      panic("freewalk: leaf");
    8000159e:	00007517          	auipc	a0,0x7
    800015a2:	bca50513          	add	a0,a0,-1078 # 80008168 <digits+0x128>
    800015a6:	fffff097          	auipc	ra,0xfffff
    800015aa:	f9c080e7          	jalr	-100(ra) # 80000542 <panic>
    }
  }
  kfree((void*)pagetable);
    800015ae:	8552                	mv	a0,s4
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	45e080e7          	jalr	1118(ra) # 80000a0e <kfree>
}
    800015b8:	70a2                	ld	ra,40(sp)
    800015ba:	7402                	ld	s0,32(sp)
    800015bc:	64e2                	ld	s1,24(sp)
    800015be:	6942                	ld	s2,16(sp)
    800015c0:	69a2                	ld	s3,8(sp)
    800015c2:	6a02                	ld	s4,0(sp)
    800015c4:	6145                	add	sp,sp,48
    800015c6:	8082                	ret

00000000800015c8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015c8:	1101                	add	sp,sp,-32
    800015ca:	ec06                	sd	ra,24(sp)
    800015cc:	e822                	sd	s0,16(sp)
    800015ce:	e426                	sd	s1,8(sp)
    800015d0:	1000                	add	s0,sp,32
    800015d2:	84aa                	mv	s1,a0
  if(sz > 0)
    800015d4:	e999                	bnez	a1,800015ea <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015d6:	8526                	mv	a0,s1
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	f84080e7          	jalr	-124(ra) # 8000155c <freewalk>
}
    800015e0:	60e2                	ld	ra,24(sp)
    800015e2:	6442                	ld	s0,16(sp)
    800015e4:	64a2                	ld	s1,8(sp)
    800015e6:	6105                	add	sp,sp,32
    800015e8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015ea:	6785                	lui	a5,0x1
    800015ec:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ee:	95be                	add	a1,a1,a5
    800015f0:	4685                	li	a3,1
    800015f2:	00c5d613          	srl	a2,a1,0xc
    800015f6:	4581                	li	a1,0
    800015f8:	00000097          	auipc	ra,0x0
    800015fc:	d0e080e7          	jalr	-754(ra) # 80001306 <uvmunmap>
    80001600:	bfd9                	j	800015d6 <uvmfree+0xe>

0000000080001602 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001602:	c679                	beqz	a2,800016d0 <uvmcopy+0xce>
{
    80001604:	715d                	add	sp,sp,-80
    80001606:	e486                	sd	ra,72(sp)
    80001608:	e0a2                	sd	s0,64(sp)
    8000160a:	fc26                	sd	s1,56(sp)
    8000160c:	f84a                	sd	s2,48(sp)
    8000160e:	f44e                	sd	s3,40(sp)
    80001610:	f052                	sd	s4,32(sp)
    80001612:	ec56                	sd	s5,24(sp)
    80001614:	e85a                	sd	s6,16(sp)
    80001616:	e45e                	sd	s7,8(sp)
    80001618:	0880                	add	s0,sp,80
    8000161a:	8b2a                	mv	s6,a0
    8000161c:	8aae                	mv	s5,a1
    8000161e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001620:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001622:	4601                	li	a2,0
    80001624:	85ce                	mv	a1,s3
    80001626:	855a                	mv	a0,s6
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	a00080e7          	jalr	-1536(ra) # 80001028 <walk>
    80001630:	c531                	beqz	a0,8000167c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001632:	6118                	ld	a4,0(a0)
    80001634:	00177793          	and	a5,a4,1
    80001638:	cbb1                	beqz	a5,8000168c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000163a:	00a75593          	srl	a1,a4,0xa
    8000163e:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001642:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001646:	fffff097          	auipc	ra,0xfffff
    8000164a:	4c6080e7          	jalr	1222(ra) # 80000b0c <kalloc>
    8000164e:	892a                	mv	s2,a0
    80001650:	c939                	beqz	a0,800016a6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001652:	6605                	lui	a2,0x1
    80001654:	85de                	mv	a1,s7
    80001656:	fffff097          	auipc	ra,0xfffff
    8000165a:	748080e7          	jalr	1864(ra) # 80000d9e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000165e:	8726                	mv	a4,s1
    80001660:	86ca                	mv	a3,s2
    80001662:	6605                	lui	a2,0x1
    80001664:	85ce                	mv	a1,s3
    80001666:	8556                	mv	a0,s5
    80001668:	00000097          	auipc	ra,0x0
    8000166c:	b06080e7          	jalr	-1274(ra) # 8000116e <mappages>
    80001670:	e515                	bnez	a0,8000169c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001672:	6785                	lui	a5,0x1
    80001674:	99be                	add	s3,s3,a5
    80001676:	fb49e6e3          	bltu	s3,s4,80001622 <uvmcopy+0x20>
    8000167a:	a081                	j	800016ba <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000167c:	00007517          	auipc	a0,0x7
    80001680:	afc50513          	add	a0,a0,-1284 # 80008178 <digits+0x138>
    80001684:	fffff097          	auipc	ra,0xfffff
    80001688:	ebe080e7          	jalr	-322(ra) # 80000542 <panic>
      panic("uvmcopy: page not present");
    8000168c:	00007517          	auipc	a0,0x7
    80001690:	b0c50513          	add	a0,a0,-1268 # 80008198 <digits+0x158>
    80001694:	fffff097          	auipc	ra,0xfffff
    80001698:	eae080e7          	jalr	-338(ra) # 80000542 <panic>
      kfree(mem);
    8000169c:	854a                	mv	a0,s2
    8000169e:	fffff097          	auipc	ra,0xfffff
    800016a2:	370080e7          	jalr	880(ra) # 80000a0e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016a6:	4685                	li	a3,1
    800016a8:	00c9d613          	srl	a2,s3,0xc
    800016ac:	4581                	li	a1,0
    800016ae:	8556                	mv	a0,s5
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	c56080e7          	jalr	-938(ra) # 80001306 <uvmunmap>
  return -1;
    800016b8:	557d                	li	a0,-1
}
    800016ba:	60a6                	ld	ra,72(sp)
    800016bc:	6406                	ld	s0,64(sp)
    800016be:	74e2                	ld	s1,56(sp)
    800016c0:	7942                	ld	s2,48(sp)
    800016c2:	79a2                	ld	s3,40(sp)
    800016c4:	7a02                	ld	s4,32(sp)
    800016c6:	6ae2                	ld	s5,24(sp)
    800016c8:	6b42                	ld	s6,16(sp)
    800016ca:	6ba2                	ld	s7,8(sp)
    800016cc:	6161                	add	sp,sp,80
    800016ce:	8082                	ret
  return 0;
    800016d0:	4501                	li	a0,0
}
    800016d2:	8082                	ret

00000000800016d4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016d4:	1141                	add	sp,sp,-16
    800016d6:	e406                	sd	ra,8(sp)
    800016d8:	e022                	sd	s0,0(sp)
    800016da:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016dc:	4601                	li	a2,0
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	94a080e7          	jalr	-1718(ra) # 80001028 <walk>
  if(pte == 0)
    800016e6:	c901                	beqz	a0,800016f6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016e8:	611c                	ld	a5,0(a0)
    800016ea:	9bbd                	and	a5,a5,-17
    800016ec:	e11c                	sd	a5,0(a0)
}
    800016ee:	60a2                	ld	ra,8(sp)
    800016f0:	6402                	ld	s0,0(sp)
    800016f2:	0141                	add	sp,sp,16
    800016f4:	8082                	ret
    panic("uvmclear");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	ac250513          	add	a0,a0,-1342 # 800081b8 <digits+0x178>
    800016fe:	fffff097          	auipc	ra,0xfffff
    80001702:	e44080e7          	jalr	-444(ra) # 80000542 <panic>

0000000080001706 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001706:	c6bd                	beqz	a3,80001774 <copyout+0x6e>
{
    80001708:	715d                	add	sp,sp,-80
    8000170a:	e486                	sd	ra,72(sp)
    8000170c:	e0a2                	sd	s0,64(sp)
    8000170e:	fc26                	sd	s1,56(sp)
    80001710:	f84a                	sd	s2,48(sp)
    80001712:	f44e                	sd	s3,40(sp)
    80001714:	f052                	sd	s4,32(sp)
    80001716:	ec56                	sd	s5,24(sp)
    80001718:	e85a                	sd	s6,16(sp)
    8000171a:	e45e                	sd	s7,8(sp)
    8000171c:	e062                	sd	s8,0(sp)
    8000171e:	0880                	add	s0,sp,80
    80001720:	8b2a                	mv	s6,a0
    80001722:	8c2e                	mv	s8,a1
    80001724:	8a32                	mv	s4,a2
    80001726:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001728:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000172a:	6a85                	lui	s5,0x1
    8000172c:	a015                	j	80001750 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000172e:	9562                	add	a0,a0,s8
    80001730:	0004861b          	sext.w	a2,s1
    80001734:	85d2                	mv	a1,s4
    80001736:	41250533          	sub	a0,a0,s2
    8000173a:	fffff097          	auipc	ra,0xfffff
    8000173e:	664080e7          	jalr	1636(ra) # 80000d9e <memmove>

    len -= n;
    80001742:	409989b3          	sub	s3,s3,s1
    src += n;
    80001746:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001748:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000174c:	02098263          	beqz	s3,80001770 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001750:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001754:	85ca                	mv	a1,s2
    80001756:	855a                	mv	a0,s6
    80001758:	00000097          	auipc	ra,0x0
    8000175c:	976080e7          	jalr	-1674(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    80001760:	cd01                	beqz	a0,80001778 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001762:	418904b3          	sub	s1,s2,s8
    80001766:	94d6                	add	s1,s1,s5
    80001768:	fc99f3e3          	bgeu	s3,s1,8000172e <copyout+0x28>
    8000176c:	84ce                	mv	s1,s3
    8000176e:	b7c1                	j	8000172e <copyout+0x28>
  }
  return 0;
    80001770:	4501                	li	a0,0
    80001772:	a021                	j	8000177a <copyout+0x74>
    80001774:	4501                	li	a0,0
}
    80001776:	8082                	ret
      return -1;
    80001778:	557d                	li	a0,-1
}
    8000177a:	60a6                	ld	ra,72(sp)
    8000177c:	6406                	ld	s0,64(sp)
    8000177e:	74e2                	ld	s1,56(sp)
    80001780:	7942                	ld	s2,48(sp)
    80001782:	79a2                	ld	s3,40(sp)
    80001784:	7a02                	ld	s4,32(sp)
    80001786:	6ae2                	ld	s5,24(sp)
    80001788:	6b42                	ld	s6,16(sp)
    8000178a:	6ba2                	ld	s7,8(sp)
    8000178c:	6c02                	ld	s8,0(sp)
    8000178e:	6161                	add	sp,sp,80
    80001790:	8082                	ret

0000000080001792 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001792:	caa5                	beqz	a3,80001802 <copyin+0x70>
{
    80001794:	715d                	add	sp,sp,-80
    80001796:	e486                	sd	ra,72(sp)
    80001798:	e0a2                	sd	s0,64(sp)
    8000179a:	fc26                	sd	s1,56(sp)
    8000179c:	f84a                	sd	s2,48(sp)
    8000179e:	f44e                	sd	s3,40(sp)
    800017a0:	f052                	sd	s4,32(sp)
    800017a2:	ec56                	sd	s5,24(sp)
    800017a4:	e85a                	sd	s6,16(sp)
    800017a6:	e45e                	sd	s7,8(sp)
    800017a8:	e062                	sd	s8,0(sp)
    800017aa:	0880                	add	s0,sp,80
    800017ac:	8b2a                	mv	s6,a0
    800017ae:	8a2e                	mv	s4,a1
    800017b0:	8c32                	mv	s8,a2
    800017b2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017b4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017b6:	6a85                	lui	s5,0x1
    800017b8:	a01d                	j	800017de <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017ba:	018505b3          	add	a1,a0,s8
    800017be:	0004861b          	sext.w	a2,s1
    800017c2:	412585b3          	sub	a1,a1,s2
    800017c6:	8552                	mv	a0,s4
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	5d6080e7          	jalr	1494(ra) # 80000d9e <memmove>

    len -= n;
    800017d0:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017d4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017d6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017da:	02098263          	beqz	s3,800017fe <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017de:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017e2:	85ca                	mv	a1,s2
    800017e4:	855a                	mv	a0,s6
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	8e8080e7          	jalr	-1816(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    800017ee:	cd01                	beqz	a0,80001806 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017f0:	418904b3          	sub	s1,s2,s8
    800017f4:	94d6                	add	s1,s1,s5
    800017f6:	fc99f2e3          	bgeu	s3,s1,800017ba <copyin+0x28>
    800017fa:	84ce                	mv	s1,s3
    800017fc:	bf7d                	j	800017ba <copyin+0x28>
  }
  return 0;
    800017fe:	4501                	li	a0,0
    80001800:	a021                	j	80001808 <copyin+0x76>
    80001802:	4501                	li	a0,0
}
    80001804:	8082                	ret
      return -1;
    80001806:	557d                	li	a0,-1
}
    80001808:	60a6                	ld	ra,72(sp)
    8000180a:	6406                	ld	s0,64(sp)
    8000180c:	74e2                	ld	s1,56(sp)
    8000180e:	7942                	ld	s2,48(sp)
    80001810:	79a2                	ld	s3,40(sp)
    80001812:	7a02                	ld	s4,32(sp)
    80001814:	6ae2                	ld	s5,24(sp)
    80001816:	6b42                	ld	s6,16(sp)
    80001818:	6ba2                	ld	s7,8(sp)
    8000181a:	6c02                	ld	s8,0(sp)
    8000181c:	6161                	add	sp,sp,80
    8000181e:	8082                	ret

0000000080001820 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001820:	c2dd                	beqz	a3,800018c6 <copyinstr+0xa6>
{
    80001822:	715d                	add	sp,sp,-80
    80001824:	e486                	sd	ra,72(sp)
    80001826:	e0a2                	sd	s0,64(sp)
    80001828:	fc26                	sd	s1,56(sp)
    8000182a:	f84a                	sd	s2,48(sp)
    8000182c:	f44e                	sd	s3,40(sp)
    8000182e:	f052                	sd	s4,32(sp)
    80001830:	ec56                	sd	s5,24(sp)
    80001832:	e85a                	sd	s6,16(sp)
    80001834:	e45e                	sd	s7,8(sp)
    80001836:	0880                	add	s0,sp,80
    80001838:	8a2a                	mv	s4,a0
    8000183a:	8b2e                	mv	s6,a1
    8000183c:	8bb2                	mv	s7,a2
    8000183e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001840:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001842:	6985                	lui	s3,0x1
    80001844:	a02d                	j	8000186e <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001846:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000184a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000184c:	37fd                	addw	a5,a5,-1
    8000184e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001852:	60a6                	ld	ra,72(sp)
    80001854:	6406                	ld	s0,64(sp)
    80001856:	74e2                	ld	s1,56(sp)
    80001858:	7942                	ld	s2,48(sp)
    8000185a:	79a2                	ld	s3,40(sp)
    8000185c:	7a02                	ld	s4,32(sp)
    8000185e:	6ae2                	ld	s5,24(sp)
    80001860:	6b42                	ld	s6,16(sp)
    80001862:	6ba2                	ld	s7,8(sp)
    80001864:	6161                	add	sp,sp,80
    80001866:	8082                	ret
    srcva = va0 + PGSIZE;
    80001868:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000186c:	c8a9                	beqz	s1,800018be <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    8000186e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001872:	85ca                	mv	a1,s2
    80001874:	8552                	mv	a0,s4
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	858080e7          	jalr	-1960(ra) # 800010ce <walkaddr>
    if(pa0 == 0)
    8000187e:	c131                	beqz	a0,800018c2 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001880:	417906b3          	sub	a3,s2,s7
    80001884:	96ce                	add	a3,a3,s3
    80001886:	00d4f363          	bgeu	s1,a3,8000188c <copyinstr+0x6c>
    8000188a:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000188c:	955e                	add	a0,a0,s7
    8000188e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001892:	daf9                	beqz	a3,80001868 <copyinstr+0x48>
    80001894:	87da                	mv	a5,s6
    80001896:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001898:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000189c:	96da                	add	a3,a3,s6
    8000189e:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018a0:	00f60733          	add	a4,a2,a5
    800018a4:	00074703          	lbu	a4,0(a4)
    800018a8:	df59                	beqz	a4,80001846 <copyinstr+0x26>
        *dst = *p;
    800018aa:	00e78023          	sb	a4,0(a5)
      dst++;
    800018ae:	0785                	add	a5,a5,1
    while(n > 0){
    800018b0:	fed797e3          	bne	a5,a3,8000189e <copyinstr+0x7e>
    800018b4:	14fd                	add	s1,s1,-1
    800018b6:	94c2                	add	s1,s1,a6
      --max;
    800018b8:	8c8d                	sub	s1,s1,a1
      dst++;
    800018ba:	8b3e                	mv	s6,a5
    800018bc:	b775                	j	80001868 <copyinstr+0x48>
    800018be:	4781                	li	a5,0
    800018c0:	b771                	j	8000184c <copyinstr+0x2c>
      return -1;
    800018c2:	557d                	li	a0,-1
    800018c4:	b779                	j	80001852 <copyinstr+0x32>
  int got_null = 0;
    800018c6:	4781                	li	a5,0
  if(got_null){
    800018c8:	37fd                	addw	a5,a5,-1
    800018ca:	0007851b          	sext.w	a0,a5
}
    800018ce:	8082                	ret

00000000800018d0 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018d0:	1101                	add	sp,sp,-32
    800018d2:	ec06                	sd	ra,24(sp)
    800018d4:	e822                	sd	s0,16(sp)
    800018d6:	e426                	sd	s1,8(sp)
    800018d8:	1000                	add	s0,sp,32
    800018da:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	2f0080e7          	jalr	752(ra) # 80000bcc <holding>
    800018e4:	c909                	beqz	a0,800018f6 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800018e6:	749c                	ld	a5,40(s1)
    800018e8:	00978f63          	beq	a5,s1,80001906 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800018ec:	60e2                	ld	ra,24(sp)
    800018ee:	6442                	ld	s0,16(sp)
    800018f0:	64a2                	ld	s1,8(sp)
    800018f2:	6105                	add	sp,sp,32
    800018f4:	8082                	ret
    panic("wakeup1");
    800018f6:	00007517          	auipc	a0,0x7
    800018fa:	8d250513          	add	a0,a0,-1838 # 800081c8 <digits+0x188>
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	c44080e7          	jalr	-956(ra) # 80000542 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001906:	4c98                	lw	a4,24(s1)
    80001908:	4785                	li	a5,1
    8000190a:	fef711e3          	bne	a4,a5,800018ec <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000190e:	4789                	li	a5,2
    80001910:	cc9c                	sw	a5,24(s1)
}
    80001912:	bfe9                	j	800018ec <wakeup1+0x1c>

0000000080001914 <procinit>:
{
    80001914:	715d                	add	sp,sp,-80
    80001916:	e486                	sd	ra,72(sp)
    80001918:	e0a2                	sd	s0,64(sp)
    8000191a:	fc26                	sd	s1,56(sp)
    8000191c:	f84a                	sd	s2,48(sp)
    8000191e:	f44e                	sd	s3,40(sp)
    80001920:	f052                	sd	s4,32(sp)
    80001922:	ec56                	sd	s5,24(sp)
    80001924:	e85a                	sd	s6,16(sp)
    80001926:	e45e                	sd	s7,8(sp)
    80001928:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000192a:	00007597          	auipc	a1,0x7
    8000192e:	8a658593          	add	a1,a1,-1882 # 800081d0 <digits+0x190>
    80001932:	00010517          	auipc	a0,0x10
    80001936:	01e50513          	add	a0,a0,30 # 80011950 <pid_lock>
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	27c080e7          	jalr	636(ra) # 80000bb6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001942:	00010917          	auipc	s2,0x10
    80001946:	42690913          	add	s2,s2,1062 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    8000194a:	00007b97          	auipc	s7,0x7
    8000194e:	88eb8b93          	add	s7,s7,-1906 # 800081d8 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    80001952:	8b4a                	mv	s6,s2
    80001954:	00006a97          	auipc	s5,0x6
    80001958:	6aca8a93          	add	s5,s5,1708 # 80008000 <etext>
    8000195c:	040009b7          	lui	s3,0x4000
    80001960:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001962:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	00016a17          	auipc	s4,0x16
    80001968:	004a0a13          	add	s4,s4,4 # 80017968 <tickslock>
      initlock(&p->lock, "proc");
    8000196c:	85de                	mv	a1,s7
    8000196e:	854a                	mv	a0,s2
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	246080e7          	jalr	582(ra) # 80000bb6 <initlock>
      char *pa = kalloc();
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	194080e7          	jalr	404(ra) # 80000b0c <kalloc>
    80001980:	85aa                	mv	a1,a0
      if(pa == 0)
    80001982:	c929                	beqz	a0,800019d4 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001984:	416904b3          	sub	s1,s2,s6
    80001988:	8491                	sra	s1,s1,0x4
    8000198a:	000ab783          	ld	a5,0(s5)
    8000198e:	02f484b3          	mul	s1,s1,a5
    80001992:	2485                	addw	s1,s1,1
    80001994:	00d4949b          	sllw	s1,s1,0xd
    80001998:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000199c:	4699                	li	a3,6
    8000199e:	6605                	lui	a2,0x1
    800019a0:	8526                	mv	a0,s1
    800019a2:	00000097          	auipc	ra,0x0
    800019a6:	85a080e7          	jalr	-1958(ra) # 800011fc <kvmmap>
      p->kstack = va;
    800019aa:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ae:	17090913          	add	s2,s2,368
    800019b2:	fb491de3          	bne	s2,s4,8000196c <procinit+0x58>
  kvminithart();
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	64e080e7          	jalr	1614(ra) # 80001004 <kvminithart>
}
    800019be:	60a6                	ld	ra,72(sp)
    800019c0:	6406                	ld	s0,64(sp)
    800019c2:	74e2                	ld	s1,56(sp)
    800019c4:	7942                	ld	s2,48(sp)
    800019c6:	79a2                	ld	s3,40(sp)
    800019c8:	7a02                	ld	s4,32(sp)
    800019ca:	6ae2                	ld	s5,24(sp)
    800019cc:	6b42                	ld	s6,16(sp)
    800019ce:	6ba2                	ld	s7,8(sp)
    800019d0:	6161                	add	sp,sp,80
    800019d2:	8082                	ret
        panic("kalloc");
    800019d4:	00007517          	auipc	a0,0x7
    800019d8:	80c50513          	add	a0,a0,-2036 # 800081e0 <digits+0x1a0>
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	b66080e7          	jalr	-1178(ra) # 80000542 <panic>

00000000800019e4 <cpuid>:
{
    800019e4:	1141                	add	sp,sp,-16
    800019e6:	e422                	sd	s0,8(sp)
    800019e8:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019ea:	8512                	mv	a0,tp
}
    800019ec:	2501                	sext.w	a0,a0
    800019ee:	6422                	ld	s0,8(sp)
    800019f0:	0141                	add	sp,sp,16
    800019f2:	8082                	ret

00000000800019f4 <mycpu>:
mycpu(void) {
    800019f4:	1141                	add	sp,sp,-16
    800019f6:	e422                	sd	s0,8(sp)
    800019f8:	0800                	add	s0,sp,16
    800019fa:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019fc:	2781                	sext.w	a5,a5
    800019fe:	079e                	sll	a5,a5,0x7
}
    80001a00:	00010517          	auipc	a0,0x10
    80001a04:	f6850513          	add	a0,a0,-152 # 80011968 <cpus>
    80001a08:	953e                	add	a0,a0,a5
    80001a0a:	6422                	ld	s0,8(sp)
    80001a0c:	0141                	add	sp,sp,16
    80001a0e:	8082                	ret

0000000080001a10 <myproc>:
myproc(void) {
    80001a10:	1101                	add	sp,sp,-32
    80001a12:	ec06                	sd	ra,24(sp)
    80001a14:	e822                	sd	s0,16(sp)
    80001a16:	e426                	sd	s1,8(sp)
    80001a18:	1000                	add	s0,sp,32
  push_off();
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	1e0080e7          	jalr	480(ra) # 80000bfa <push_off>
    80001a22:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a24:	2781                	sext.w	a5,a5
    80001a26:	079e                	sll	a5,a5,0x7
    80001a28:	00010717          	auipc	a4,0x10
    80001a2c:	f2870713          	add	a4,a4,-216 # 80011950 <pid_lock>
    80001a30:	97ba                	add	a5,a5,a4
    80001a32:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a34:	fffff097          	auipc	ra,0xfffff
    80001a38:	266080e7          	jalr	614(ra) # 80000c9a <pop_off>
}
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	60e2                	ld	ra,24(sp)
    80001a40:	6442                	ld	s0,16(sp)
    80001a42:	64a2                	ld	s1,8(sp)
    80001a44:	6105                	add	sp,sp,32
    80001a46:	8082                	ret

0000000080001a48 <forkret>:
{
    80001a48:	1141                	add	sp,sp,-16
    80001a4a:	e406                	sd	ra,8(sp)
    80001a4c:	e022                	sd	s0,0(sp)
    80001a4e:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    80001a50:	00000097          	auipc	ra,0x0
    80001a54:	fc0080e7          	jalr	-64(ra) # 80001a10 <myproc>
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	2a2080e7          	jalr	674(ra) # 80000cfa <release>
  if (first) {
    80001a60:	00007797          	auipc	a5,0x7
    80001a64:	f407a783          	lw	a5,-192(a5) # 800089a0 <first.1>
    80001a68:	eb89                	bnez	a5,80001a7a <forkret+0x32>
  usertrapret();
    80001a6a:	00001097          	auipc	ra,0x1
    80001a6e:	c50080e7          	jalr	-944(ra) # 800026ba <usertrapret>
}
    80001a72:	60a2                	ld	ra,8(sp)
    80001a74:	6402                	ld	s0,0(sp)
    80001a76:	0141                	add	sp,sp,16
    80001a78:	8082                	ret
    first = 0;
    80001a7a:	00007797          	auipc	a5,0x7
    80001a7e:	f207a323          	sw	zero,-218(a5) # 800089a0 <first.1>
    fsinit(ROOTDEV);
    80001a82:	4505                	li	a0,1
    80001a84:	00002097          	auipc	ra,0x2
    80001a88:	a42080e7          	jalr	-1470(ra) # 800034c6 <fsinit>
    80001a8c:	bff9                	j	80001a6a <forkret+0x22>

0000000080001a8e <allocpid>:
allocpid() {
    80001a8e:	1101                	add	sp,sp,-32
    80001a90:	ec06                	sd	ra,24(sp)
    80001a92:	e822                	sd	s0,16(sp)
    80001a94:	e426                	sd	s1,8(sp)
    80001a96:	e04a                	sd	s2,0(sp)
    80001a98:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001a9a:	00010917          	auipc	s2,0x10
    80001a9e:	eb690913          	add	s2,s2,-330 # 80011950 <pid_lock>
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	1a2080e7          	jalr	418(ra) # 80000c46 <acquire>
  pid = nextpid;
    80001aac:	00007797          	auipc	a5,0x7
    80001ab0:	ef878793          	add	a5,a5,-264 # 800089a4 <nextpid>
    80001ab4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ab6:	0014871b          	addw	a4,s1,1
    80001aba:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001abc:	854a                	mv	a0,s2
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	23c080e7          	jalr	572(ra) # 80000cfa <release>
}
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	60e2                	ld	ra,24(sp)
    80001aca:	6442                	ld	s0,16(sp)
    80001acc:	64a2                	ld	s1,8(sp)
    80001ace:	6902                	ld	s2,0(sp)
    80001ad0:	6105                	add	sp,sp,32
    80001ad2:	8082                	ret

0000000080001ad4 <proc_pagetable>:
{
    80001ad4:	1101                	add	sp,sp,-32
    80001ad6:	ec06                	sd	ra,24(sp)
    80001ad8:	e822                	sd	s0,16(sp)
    80001ada:	e426                	sd	s1,8(sp)
    80001adc:	e04a                	sd	s2,0(sp)
    80001ade:	1000                	add	s0,sp,32
    80001ae0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ae2:	00000097          	auipc	ra,0x0
    80001ae6:	8e8080e7          	jalr	-1816(ra) # 800013ca <uvmcreate>
    80001aea:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aec:	c121                	beqz	a0,80001b2c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001aee:	4729                	li	a4,10
    80001af0:	00005697          	auipc	a3,0x5
    80001af4:	51068693          	add	a3,a3,1296 # 80007000 <_trampoline>
    80001af8:	6605                	lui	a2,0x1
    80001afa:	040005b7          	lui	a1,0x4000
    80001afe:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b00:	05b2                	sll	a1,a1,0xc
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	66c080e7          	jalr	1644(ra) # 8000116e <mappages>
    80001b0a:	02054863          	bltz	a0,80001b3a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b0e:	4719                	li	a4,6
    80001b10:	05893683          	ld	a3,88(s2)
    80001b14:	6605                	lui	a2,0x1
    80001b16:	020005b7          	lui	a1,0x2000
    80001b1a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b1c:	05b6                	sll	a1,a1,0xd
    80001b1e:	8526                	mv	a0,s1
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	64e080e7          	jalr	1614(ra) # 8000116e <mappages>
    80001b28:	02054163          	bltz	a0,80001b4a <proc_pagetable+0x76>
}
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	60e2                	ld	ra,24(sp)
    80001b30:	6442                	ld	s0,16(sp)
    80001b32:	64a2                	ld	s1,8(sp)
    80001b34:	6902                	ld	s2,0(sp)
    80001b36:	6105                	add	sp,sp,32
    80001b38:	8082                	ret
    uvmfree(pagetable, 0);
    80001b3a:	4581                	li	a1,0
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	00000097          	auipc	ra,0x0
    80001b42:	a8a080e7          	jalr	-1398(ra) # 800015c8 <uvmfree>
    return 0;
    80001b46:	4481                	li	s1,0
    80001b48:	b7d5                	j	80001b2c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b4a:	4681                	li	a3,0
    80001b4c:	4605                	li	a2,1
    80001b4e:	040005b7          	lui	a1,0x4000
    80001b52:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b54:	05b2                	sll	a1,a1,0xc
    80001b56:	8526                	mv	a0,s1
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	7ae080e7          	jalr	1966(ra) # 80001306 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b60:	4581                	li	a1,0
    80001b62:	8526                	mv	a0,s1
    80001b64:	00000097          	auipc	ra,0x0
    80001b68:	a64080e7          	jalr	-1436(ra) # 800015c8 <uvmfree>
    return 0;
    80001b6c:	4481                	li	s1,0
    80001b6e:	bf7d                	j	80001b2c <proc_pagetable+0x58>

0000000080001b70 <proc_freepagetable>:
{
    80001b70:	1101                	add	sp,sp,-32
    80001b72:	ec06                	sd	ra,24(sp)
    80001b74:	e822                	sd	s0,16(sp)
    80001b76:	e426                	sd	s1,8(sp)
    80001b78:	e04a                	sd	s2,0(sp)
    80001b7a:	1000                	add	s0,sp,32
    80001b7c:	84aa                	mv	s1,a0
    80001b7e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b80:	4681                	li	a3,0
    80001b82:	4605                	li	a2,1
    80001b84:	040005b7          	lui	a1,0x4000
    80001b88:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b8a:	05b2                	sll	a1,a1,0xc
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	77a080e7          	jalr	1914(ra) # 80001306 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b94:	4681                	li	a3,0
    80001b96:	4605                	li	a2,1
    80001b98:	020005b7          	lui	a1,0x2000
    80001b9c:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b9e:	05b6                	sll	a1,a1,0xd
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	764080e7          	jalr	1892(ra) # 80001306 <uvmunmap>
  uvmfree(pagetable, sz);
    80001baa:	85ca                	mv	a1,s2
    80001bac:	8526                	mv	a0,s1
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	a1a080e7          	jalr	-1510(ra) # 800015c8 <uvmfree>
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6902                	ld	s2,0(sp)
    80001bbe:	6105                	add	sp,sp,32
    80001bc0:	8082                	ret

0000000080001bc2 <freeproc>:
{
    80001bc2:	1101                	add	sp,sp,-32
    80001bc4:	ec06                	sd	ra,24(sp)
    80001bc6:	e822                	sd	s0,16(sp)
    80001bc8:	e426                	sd	s1,8(sp)
    80001bca:	1000                	add	s0,sp,32
    80001bcc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bce:	6d28                	ld	a0,88(a0)
    80001bd0:	c509                	beqz	a0,80001bda <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	e3c080e7          	jalr	-452(ra) # 80000a0e <kfree>
  p->trapframe = 0;
    80001bda:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001bde:	68a8                	ld	a0,80(s1)
    80001be0:	c511                	beqz	a0,80001bec <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001be2:	64ac                	ld	a1,72(s1)
    80001be4:	00000097          	auipc	ra,0x0
    80001be8:	f8c080e7          	jalr	-116(ra) # 80001b70 <proc_freepagetable>
  p->pagetable = 0;
    80001bec:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bf0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bf4:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bf8:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001bfc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c00:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c04:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c08:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c0c:	0004ac23          	sw	zero,24(s1)
}
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6105                	add	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <allocproc>:
{
    80001c1a:	1101                	add	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	e04a                	sd	s2,0(sp)
    80001c24:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c26:	00010497          	auipc	s1,0x10
    80001c2a:	14248493          	add	s1,s1,322 # 80011d68 <proc>
    80001c2e:	00016917          	auipc	s2,0x16
    80001c32:	d3a90913          	add	s2,s2,-710 # 80017968 <tickslock>
    acquire(&p->lock);
    80001c36:	8526                	mv	a0,s1
    80001c38:	fffff097          	auipc	ra,0xfffff
    80001c3c:	00e080e7          	jalr	14(ra) # 80000c46 <acquire>
    if(p->state == UNUSED) {
    80001c40:	4c9c                	lw	a5,24(s1)
    80001c42:	cf81                	beqz	a5,80001c5a <allocproc+0x40>
      release(&p->lock);
    80001c44:	8526                	mv	a0,s1
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	0b4080e7          	jalr	180(ra) # 80000cfa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c4e:	17048493          	add	s1,s1,368
    80001c52:	ff2492e3          	bne	s1,s2,80001c36 <allocproc+0x1c>
  return 0;
    80001c56:	4481                	li	s1,0
    80001c58:	a0b9                	j	80001ca6 <allocproc+0x8c>
  p->pid = allocpid();
    80001c5a:	00000097          	auipc	ra,0x0
    80001c5e:	e34080e7          	jalr	-460(ra) # 80001a8e <allocpid>
    80001c62:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	ea8080e7          	jalr	-344(ra) # 80000b0c <kalloc>
    80001c6c:	892a                	mv	s2,a0
    80001c6e:	eca8                	sd	a0,88(s1)
    80001c70:	c131                	beqz	a0,80001cb4 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c72:	8526                	mv	a0,s1
    80001c74:	00000097          	auipc	ra,0x0
    80001c78:	e60080e7          	jalr	-416(ra) # 80001ad4 <proc_pagetable>
    80001c7c:	892a                	mv	s2,a0
    80001c7e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c80:	c129                	beqz	a0,80001cc2 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c82:	07000613          	li	a2,112
    80001c86:	4581                	li	a1,0
    80001c88:	06048513          	add	a0,s1,96
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	0b6080e7          	jalr	182(ra) # 80000d42 <memset>
  p->context.ra = (uint64)forkret;
    80001c94:	00000797          	auipc	a5,0x0
    80001c98:	db478793          	add	a5,a5,-588 # 80001a48 <forkret>
    80001c9c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c9e:	60bc                	ld	a5,64(s1)
    80001ca0:	6705                	lui	a4,0x1
    80001ca2:	97ba                	add	a5,a5,a4
    80001ca4:	f4bc                	sd	a5,104(s1)
}
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	60e2                	ld	ra,24(sp)
    80001caa:	6442                	ld	s0,16(sp)
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	6902                	ld	s2,0(sp)
    80001cb0:	6105                	add	sp,sp,32
    80001cb2:	8082                	ret
    release(&p->lock);
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	044080e7          	jalr	68(ra) # 80000cfa <release>
    return 0;
    80001cbe:	84ca                	mv	s1,s2
    80001cc0:	b7dd                	j	80001ca6 <allocproc+0x8c>
    freeproc(p);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	efe080e7          	jalr	-258(ra) # 80001bc2 <freeproc>
    release(&p->lock);
    80001ccc:	8526                	mv	a0,s1
    80001cce:	fffff097          	auipc	ra,0xfffff
    80001cd2:	02c080e7          	jalr	44(ra) # 80000cfa <release>
    return 0;
    80001cd6:	84ca                	mv	s1,s2
    80001cd8:	b7f9                	j	80001ca6 <allocproc+0x8c>

0000000080001cda <userinit>:
{
    80001cda:	1101                	add	sp,sp,-32
    80001cdc:	ec06                	sd	ra,24(sp)
    80001cde:	e822                	sd	s0,16(sp)
    80001ce0:	e426                	sd	s1,8(sp)
    80001ce2:	1000                	add	s0,sp,32
  p = allocproc();
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	f36080e7          	jalr	-202(ra) # 80001c1a <allocproc>
    80001cec:	84aa                	mv	s1,a0
  initproc = p;
    80001cee:	00007797          	auipc	a5,0x7
    80001cf2:	32a7b523          	sd	a0,810(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cf6:	03400613          	li	a2,52
    80001cfa:	00007597          	auipc	a1,0x7
    80001cfe:	cb658593          	add	a1,a1,-842 # 800089b0 <initcode>
    80001d02:	6928                	ld	a0,80(a0)
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	6f4080e7          	jalr	1780(ra) # 800013f8 <uvminit>
  p->sz = PGSIZE;
    80001d0c:	6785                	lui	a5,0x1
    80001d0e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d10:	6cb8                	ld	a4,88(s1)
    80001d12:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d16:	6cb8                	ld	a4,88(s1)
    80001d18:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d1a:	4641                	li	a2,16
    80001d1c:	00006597          	auipc	a1,0x6
    80001d20:	4cc58593          	add	a1,a1,1228 # 800081e8 <digits+0x1a8>
    80001d24:	15848513          	add	a0,s1,344
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	16a080e7          	jalr	362(ra) # 80000e92 <safestrcpy>
  p->cwd = namei("/");
    80001d30:	00006517          	auipc	a0,0x6
    80001d34:	4c850513          	add	a0,a0,1224 # 800081f8 <digits+0x1b8>
    80001d38:	00002097          	auipc	ra,0x2
    80001d3c:	1b2080e7          	jalr	434(ra) # 80003eea <namei>
    80001d40:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d44:	4789                	li	a5,2
    80001d46:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d48:	8526                	mv	a0,s1
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	fb0080e7          	jalr	-80(ra) # 80000cfa <release>
}
    80001d52:	60e2                	ld	ra,24(sp)
    80001d54:	6442                	ld	s0,16(sp)
    80001d56:	64a2                	ld	s1,8(sp)
    80001d58:	6105                	add	sp,sp,32
    80001d5a:	8082                	ret

0000000080001d5c <growproc>:
{
    80001d5c:	1101                	add	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	e04a                	sd	s2,0(sp)
    80001d66:	1000                	add	s0,sp,32
    80001d68:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	ca6080e7          	jalr	-858(ra) # 80001a10 <myproc>
    80001d72:	892a                	mv	s2,a0
  sz = p->sz;
    80001d74:	652c                	ld	a1,72(a0)
    80001d76:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d7a:	00904f63          	bgtz	s1,80001d98 <growproc+0x3c>
  } else if(n < 0){
    80001d7e:	0204cd63          	bltz	s1,80001db8 <growproc+0x5c>
  p->sz = sz;
    80001d82:	1782                	sll	a5,a5,0x20
    80001d84:	9381                	srl	a5,a5,0x20
    80001d86:	04f93423          	sd	a5,72(s2)
  return 0;
    80001d8a:	4501                	li	a0,0
}
    80001d8c:	60e2                	ld	ra,24(sp)
    80001d8e:	6442                	ld	s0,16(sp)
    80001d90:	64a2                	ld	s1,8(sp)
    80001d92:	6902                	ld	s2,0(sp)
    80001d94:	6105                	add	sp,sp,32
    80001d96:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d98:	00f4863b          	addw	a2,s1,a5
    80001d9c:	1602                	sll	a2,a2,0x20
    80001d9e:	9201                	srl	a2,a2,0x20
    80001da0:	1582                	sll	a1,a1,0x20
    80001da2:	9181                	srl	a1,a1,0x20
    80001da4:	6928                	ld	a0,80(a0)
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	70c080e7          	jalr	1804(ra) # 800014b2 <uvmalloc>
    80001dae:	0005079b          	sext.w	a5,a0
    80001db2:	fbe1                	bnez	a5,80001d82 <growproc+0x26>
      return -1;
    80001db4:	557d                	li	a0,-1
    80001db6:	bfd9                	j	80001d8c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001db8:	00f4863b          	addw	a2,s1,a5
    80001dbc:	1602                	sll	a2,a2,0x20
    80001dbe:	9201                	srl	a2,a2,0x20
    80001dc0:	1582                	sll	a1,a1,0x20
    80001dc2:	9181                	srl	a1,a1,0x20
    80001dc4:	6928                	ld	a0,80(a0)
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	6a4080e7          	jalr	1700(ra) # 8000146a <uvmdealloc>
    80001dce:	0005079b          	sext.w	a5,a0
    80001dd2:	bf45                	j	80001d82 <growproc+0x26>

0000000080001dd4 <fork>:
{
    80001dd4:	7139                	add	sp,sp,-64
    80001dd6:	fc06                	sd	ra,56(sp)
    80001dd8:	f822                	sd	s0,48(sp)
    80001dda:	f426                	sd	s1,40(sp)
    80001ddc:	f04a                	sd	s2,32(sp)
    80001dde:	ec4e                	sd	s3,24(sp)
    80001de0:	e852                	sd	s4,16(sp)
    80001de2:	e456                	sd	s5,8(sp)
    80001de4:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	c2a080e7          	jalr	-982(ra) # 80001a10 <myproc>
    80001dee:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	e2a080e7          	jalr	-470(ra) # 80001c1a <allocproc>
    80001df8:	c57d                	beqz	a0,80001ee6 <fork+0x112>
    80001dfa:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dfc:	048ab603          	ld	a2,72(s5)
    80001e00:	692c                	ld	a1,80(a0)
    80001e02:	050ab503          	ld	a0,80(s5)
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	7fc080e7          	jalr	2044(ra) # 80001602 <uvmcopy>
    80001e0e:	04054a63          	bltz	a0,80001e62 <fork+0x8e>
  np->sz = p->sz;
    80001e12:	048ab783          	ld	a5,72(s5)
    80001e16:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001e1a:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e1e:	058ab683          	ld	a3,88(s5)
    80001e22:	87b6                	mv	a5,a3
    80001e24:	058a3703          	ld	a4,88(s4)
    80001e28:	12068693          	add	a3,a3,288
    80001e2c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e30:	6788                	ld	a0,8(a5)
    80001e32:	6b8c                	ld	a1,16(a5)
    80001e34:	6f90                	ld	a2,24(a5)
    80001e36:	01073023          	sd	a6,0(a4)
    80001e3a:	e708                	sd	a0,8(a4)
    80001e3c:	eb0c                	sd	a1,16(a4)
    80001e3e:	ef10                	sd	a2,24(a4)
    80001e40:	02078793          	add	a5,a5,32
    80001e44:	02070713          	add	a4,a4,32
    80001e48:	fed792e3          	bne	a5,a3,80001e2c <fork+0x58>
  np->trapframe->a0 = 0;
    80001e4c:	058a3783          	ld	a5,88(s4)
    80001e50:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e54:	0d0a8493          	add	s1,s5,208
    80001e58:	0d0a0913          	add	s2,s4,208
    80001e5c:	150a8993          	add	s3,s5,336
    80001e60:	a00d                	j	80001e82 <fork+0xae>
    freeproc(np);
    80001e62:	8552                	mv	a0,s4
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	d5e080e7          	jalr	-674(ra) # 80001bc2 <freeproc>
    release(&np->lock);
    80001e6c:	8552                	mv	a0,s4
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	e8c080e7          	jalr	-372(ra) # 80000cfa <release>
    return -1;
    80001e76:	54fd                	li	s1,-1
    80001e78:	a8a9                	j	80001ed2 <fork+0xfe>
  for(i = 0; i < NOFILE; i++)
    80001e7a:	04a1                	add	s1,s1,8
    80001e7c:	0921                	add	s2,s2,8
    80001e7e:	01348b63          	beq	s1,s3,80001e94 <fork+0xc0>
    if(p->ofile[i])
    80001e82:	6088                	ld	a0,0(s1)
    80001e84:	d97d                	beqz	a0,80001e7a <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e86:	00002097          	auipc	ra,0x2
    80001e8a:	6cc080e7          	jalr	1740(ra) # 80004552 <filedup>
    80001e8e:	00a93023          	sd	a0,0(s2)
    80001e92:	b7e5                	j	80001e7a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e94:	150ab503          	ld	a0,336(s5)
    80001e98:	00002097          	auipc	ra,0x2
    80001e9c:	864080e7          	jalr	-1948(ra) # 800036fc <idup>
    80001ea0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea4:	4641                	li	a2,16
    80001ea6:	158a8593          	add	a1,s5,344
    80001eaa:	158a0513          	add	a0,s4,344
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	fe4080e7          	jalr	-28(ra) # 80000e92 <safestrcpy>
  np->mask=p->mask;//Child's trace_mask=Parent's trace_mask
    80001eb6:	168aa783          	lw	a5,360(s5)
    80001eba:	16fa2423          	sw	a5,360(s4)
  pid = np->pid;
    80001ebe:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001ec2:	4789                	li	a5,2
    80001ec4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001ec8:	8552                	mv	a0,s4
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	e30080e7          	jalr	-464(ra) # 80000cfa <release>
}
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	70e2                	ld	ra,56(sp)
    80001ed6:	7442                	ld	s0,48(sp)
    80001ed8:	74a2                	ld	s1,40(sp)
    80001eda:	7902                	ld	s2,32(sp)
    80001edc:	69e2                	ld	s3,24(sp)
    80001ede:	6a42                	ld	s4,16(sp)
    80001ee0:	6aa2                	ld	s5,8(sp)
    80001ee2:	6121                	add	sp,sp,64
    80001ee4:	8082                	ret
    return -1;
    80001ee6:	54fd                	li	s1,-1
    80001ee8:	b7ed                	j	80001ed2 <fork+0xfe>

0000000080001eea <reparent>:
{
    80001eea:	7179                	add	sp,sp,-48
    80001eec:	f406                	sd	ra,40(sp)
    80001eee:	f022                	sd	s0,32(sp)
    80001ef0:	ec26                	sd	s1,24(sp)
    80001ef2:	e84a                	sd	s2,16(sp)
    80001ef4:	e44e                	sd	s3,8(sp)
    80001ef6:	e052                	sd	s4,0(sp)
    80001ef8:	1800                	add	s0,sp,48
    80001efa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001efc:	00010497          	auipc	s1,0x10
    80001f00:	e6c48493          	add	s1,s1,-404 # 80011d68 <proc>
      pp->parent = initproc;
    80001f04:	00007a17          	auipc	s4,0x7
    80001f08:	114a0a13          	add	s4,s4,276 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f0c:	00016997          	auipc	s3,0x16
    80001f10:	a5c98993          	add	s3,s3,-1444 # 80017968 <tickslock>
    80001f14:	a029                	j	80001f1e <reparent+0x34>
    80001f16:	17048493          	add	s1,s1,368
    80001f1a:	03348363          	beq	s1,s3,80001f40 <reparent+0x56>
    if(pp->parent == p){
    80001f1e:	709c                	ld	a5,32(s1)
    80001f20:	ff279be3          	bne	a5,s2,80001f16 <reparent+0x2c>
      acquire(&pp->lock);
    80001f24:	8526                	mv	a0,s1
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	d20080e7          	jalr	-736(ra) # 80000c46 <acquire>
      pp->parent = initproc;
    80001f2e:	000a3783          	ld	a5,0(s4)
    80001f32:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f34:	8526                	mv	a0,s1
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	dc4080e7          	jalr	-572(ra) # 80000cfa <release>
    80001f3e:	bfe1                	j	80001f16 <reparent+0x2c>
}
    80001f40:	70a2                	ld	ra,40(sp)
    80001f42:	7402                	ld	s0,32(sp)
    80001f44:	64e2                	ld	s1,24(sp)
    80001f46:	6942                	ld	s2,16(sp)
    80001f48:	69a2                	ld	s3,8(sp)
    80001f4a:	6a02                	ld	s4,0(sp)
    80001f4c:	6145                	add	sp,sp,48
    80001f4e:	8082                	ret

0000000080001f50 <scheduler>:
{
    80001f50:	715d                	add	sp,sp,-80
    80001f52:	e486                	sd	ra,72(sp)
    80001f54:	e0a2                	sd	s0,64(sp)
    80001f56:	fc26                	sd	s1,56(sp)
    80001f58:	f84a                	sd	s2,48(sp)
    80001f5a:	f44e                	sd	s3,40(sp)
    80001f5c:	f052                	sd	s4,32(sp)
    80001f5e:	ec56                	sd	s5,24(sp)
    80001f60:	e85a                	sd	s6,16(sp)
    80001f62:	e45e                	sd	s7,8(sp)
    80001f64:	e062                	sd	s8,0(sp)
    80001f66:	0880                	add	s0,sp,80
    80001f68:	8792                	mv	a5,tp
  int id = r_tp();
    80001f6a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f6c:	00779b13          	sll	s6,a5,0x7
    80001f70:	00010717          	auipc	a4,0x10
    80001f74:	9e070713          	add	a4,a4,-1568 # 80011950 <pid_lock>
    80001f78:	975a                	add	a4,a4,s6
    80001f7a:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f7e:	00010717          	auipc	a4,0x10
    80001f82:	9f270713          	add	a4,a4,-1550 # 80011970 <cpus+0x8>
    80001f86:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f88:	4c0d                	li	s8,3
        c->proc = p;
    80001f8a:	079e                	sll	a5,a5,0x7
    80001f8c:	00010a17          	auipc	s4,0x10
    80001f90:	9c4a0a13          	add	s4,s4,-1596 # 80011950 <pid_lock>
    80001f94:	9a3e                	add	s4,s4,a5
        found = 1;
    80001f96:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f98:	00016997          	auipc	s3,0x16
    80001f9c:	9d098993          	add	s3,s3,-1584 # 80017968 <tickslock>
    80001fa0:	a899                	j	80001ff6 <scheduler+0xa6>
      release(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	d56080e7          	jalr	-682(ra) # 80000cfa <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fac:	17048493          	add	s1,s1,368
    80001fb0:	03348963          	beq	s1,s3,80001fe2 <scheduler+0x92>
      acquire(&p->lock);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	c90080e7          	jalr	-880(ra) # 80000c46 <acquire>
      if(p->state == RUNNABLE) {
    80001fbe:	4c9c                	lw	a5,24(s1)
    80001fc0:	ff2791e3          	bne	a5,s2,80001fa2 <scheduler+0x52>
        p->state = RUNNING;
    80001fc4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001fc8:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001fcc:	06048593          	add	a1,s1,96
    80001fd0:	855a                	mv	a0,s6
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	63e080e7          	jalr	1598(ra) # 80002610 <swtch>
        c->proc = 0;
    80001fda:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001fde:	8ade                	mv	s5,s7
    80001fe0:	b7c9                	j	80001fa2 <scheduler+0x52>
    if(found == 0) {
    80001fe2:	000a9a63          	bnez	s5,80001ff6 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fea:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fee:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001ff2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ffa:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ffe:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002002:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002004:	00010497          	auipc	s1,0x10
    80002008:	d6448493          	add	s1,s1,-668 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    8000200c:	4909                	li	s2,2
    8000200e:	b75d                	j	80001fb4 <scheduler+0x64>

0000000080002010 <sched>:
{
    80002010:	7179                	add	sp,sp,-48
    80002012:	f406                	sd	ra,40(sp)
    80002014:	f022                	sd	s0,32(sp)
    80002016:	ec26                	sd	s1,24(sp)
    80002018:	e84a                	sd	s2,16(sp)
    8000201a:	e44e                	sd	s3,8(sp)
    8000201c:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	9f2080e7          	jalr	-1550(ra) # 80001a10 <myproc>
    80002026:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	ba4080e7          	jalr	-1116(ra) # 80000bcc <holding>
    80002030:	c93d                	beqz	a0,800020a6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002032:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002034:	2781                	sext.w	a5,a5
    80002036:	079e                	sll	a5,a5,0x7
    80002038:	00010717          	auipc	a4,0x10
    8000203c:	91870713          	add	a4,a4,-1768 # 80011950 <pid_lock>
    80002040:	97ba                	add	a5,a5,a4
    80002042:	0907a703          	lw	a4,144(a5)
    80002046:	4785                	li	a5,1
    80002048:	06f71763          	bne	a4,a5,800020b6 <sched+0xa6>
  if(p->state == RUNNING)
    8000204c:	4c98                	lw	a4,24(s1)
    8000204e:	478d                	li	a5,3
    80002050:	06f70b63          	beq	a4,a5,800020c6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002054:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002058:	8b89                	and	a5,a5,2
  if(intr_get())
    8000205a:	efb5                	bnez	a5,800020d6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000205c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000205e:	00010917          	auipc	s2,0x10
    80002062:	8f290913          	add	s2,s2,-1806 # 80011950 <pid_lock>
    80002066:	2781                	sext.w	a5,a5
    80002068:	079e                	sll	a5,a5,0x7
    8000206a:	97ca                	add	a5,a5,s2
    8000206c:	0947a983          	lw	s3,148(a5)
    80002070:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002072:	2781                	sext.w	a5,a5
    80002074:	079e                	sll	a5,a5,0x7
    80002076:	00010597          	auipc	a1,0x10
    8000207a:	8fa58593          	add	a1,a1,-1798 # 80011970 <cpus+0x8>
    8000207e:	95be                	add	a1,a1,a5
    80002080:	06048513          	add	a0,s1,96
    80002084:	00000097          	auipc	ra,0x0
    80002088:	58c080e7          	jalr	1420(ra) # 80002610 <swtch>
    8000208c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000208e:	2781                	sext.w	a5,a5
    80002090:	079e                	sll	a5,a5,0x7
    80002092:	993e                	add	s2,s2,a5
    80002094:	09392a23          	sw	s3,148(s2)
}
    80002098:	70a2                	ld	ra,40(sp)
    8000209a:	7402                	ld	s0,32(sp)
    8000209c:	64e2                	ld	s1,24(sp)
    8000209e:	6942                	ld	s2,16(sp)
    800020a0:	69a2                	ld	s3,8(sp)
    800020a2:	6145                	add	sp,sp,48
    800020a4:	8082                	ret
    panic("sched p->lock");
    800020a6:	00006517          	auipc	a0,0x6
    800020aa:	15a50513          	add	a0,a0,346 # 80008200 <digits+0x1c0>
    800020ae:	ffffe097          	auipc	ra,0xffffe
    800020b2:	494080e7          	jalr	1172(ra) # 80000542 <panic>
    panic("sched locks");
    800020b6:	00006517          	auipc	a0,0x6
    800020ba:	15a50513          	add	a0,a0,346 # 80008210 <digits+0x1d0>
    800020be:	ffffe097          	auipc	ra,0xffffe
    800020c2:	484080e7          	jalr	1156(ra) # 80000542 <panic>
    panic("sched running");
    800020c6:	00006517          	auipc	a0,0x6
    800020ca:	15a50513          	add	a0,a0,346 # 80008220 <digits+0x1e0>
    800020ce:	ffffe097          	auipc	ra,0xffffe
    800020d2:	474080e7          	jalr	1140(ra) # 80000542 <panic>
    panic("sched interruptible");
    800020d6:	00006517          	auipc	a0,0x6
    800020da:	15a50513          	add	a0,a0,346 # 80008230 <digits+0x1f0>
    800020de:	ffffe097          	auipc	ra,0xffffe
    800020e2:	464080e7          	jalr	1124(ra) # 80000542 <panic>

00000000800020e6 <exit>:
{
    800020e6:	7179                	add	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	e84a                	sd	s2,16(sp)
    800020f0:	e44e                	sd	s3,8(sp)
    800020f2:	e052                	sd	s4,0(sp)
    800020f4:	1800                	add	s0,sp,48
    800020f6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020f8:	00000097          	auipc	ra,0x0
    800020fc:	918080e7          	jalr	-1768(ra) # 80001a10 <myproc>
    80002100:	89aa                	mv	s3,a0
  if(p == initproc)
    80002102:	00007797          	auipc	a5,0x7
    80002106:	f167b783          	ld	a5,-234(a5) # 80009018 <initproc>
    8000210a:	0d050493          	add	s1,a0,208
    8000210e:	15050913          	add	s2,a0,336
    80002112:	02a79363          	bne	a5,a0,80002138 <exit+0x52>
    panic("init exiting");
    80002116:	00006517          	auipc	a0,0x6
    8000211a:	13250513          	add	a0,a0,306 # 80008248 <digits+0x208>
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	424080e7          	jalr	1060(ra) # 80000542 <panic>
      fileclose(f);
    80002126:	00002097          	auipc	ra,0x2
    8000212a:	47e080e7          	jalr	1150(ra) # 800045a4 <fileclose>
      p->ofile[fd] = 0;
    8000212e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002132:	04a1                	add	s1,s1,8
    80002134:	01248563          	beq	s1,s2,8000213e <exit+0x58>
    if(p->ofile[fd]){
    80002138:	6088                	ld	a0,0(s1)
    8000213a:	f575                	bnez	a0,80002126 <exit+0x40>
    8000213c:	bfdd                	j	80002132 <exit+0x4c>
  begin_op();
    8000213e:	00002097          	auipc	ra,0x2
    80002142:	f9c080e7          	jalr	-100(ra) # 800040da <begin_op>
  iput(p->cwd);
    80002146:	1509b503          	ld	a0,336(s3)
    8000214a:	00001097          	auipc	ra,0x1
    8000214e:	7aa080e7          	jalr	1962(ra) # 800038f4 <iput>
  end_op();
    80002152:	00002097          	auipc	ra,0x2
    80002156:	002080e7          	jalr	2(ra) # 80004154 <end_op>
  p->cwd = 0;
    8000215a:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000215e:	00007497          	auipc	s1,0x7
    80002162:	eba48493          	add	s1,s1,-326 # 80009018 <initproc>
    80002166:	6088                	ld	a0,0(s1)
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	ade080e7          	jalr	-1314(ra) # 80000c46 <acquire>
  wakeup1(initproc);
    80002170:	6088                	ld	a0,0(s1)
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	75e080e7          	jalr	1886(ra) # 800018d0 <wakeup1>
  release(&initproc->lock);
    8000217a:	6088                	ld	a0,0(s1)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	b7e080e7          	jalr	-1154(ra) # 80000cfa <release>
  acquire(&p->lock);
    80002184:	854e                	mv	a0,s3
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	ac0080e7          	jalr	-1344(ra) # 80000c46 <acquire>
  struct proc *original_parent = p->parent;
    8000218e:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002192:	854e                	mv	a0,s3
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	b66080e7          	jalr	-1178(ra) # 80000cfa <release>
  acquire(&original_parent->lock);
    8000219c:	8526                	mv	a0,s1
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	aa8080e7          	jalr	-1368(ra) # 80000c46 <acquire>
  acquire(&p->lock);
    800021a6:	854e                	mv	a0,s3
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	a9e080e7          	jalr	-1378(ra) # 80000c46 <acquire>
  reparent(p);
    800021b0:	854e                	mv	a0,s3
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	d38080e7          	jalr	-712(ra) # 80001eea <reparent>
  wakeup1(original_parent);
    800021ba:	8526                	mv	a0,s1
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	714080e7          	jalr	1812(ra) # 800018d0 <wakeup1>
  p->xstate = status;
    800021c4:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800021c8:	4791                	li	a5,4
    800021ca:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800021ce:	8526                	mv	a0,s1
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	b2a080e7          	jalr	-1238(ra) # 80000cfa <release>
  sched();
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	e38080e7          	jalr	-456(ra) # 80002010 <sched>
  panic("zombie exit");
    800021e0:	00006517          	auipc	a0,0x6
    800021e4:	07850513          	add	a0,a0,120 # 80008258 <digits+0x218>
    800021e8:	ffffe097          	auipc	ra,0xffffe
    800021ec:	35a080e7          	jalr	858(ra) # 80000542 <panic>

00000000800021f0 <yield>:
{
    800021f0:	1101                	add	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	816080e7          	jalr	-2026(ra) # 80001a10 <myproc>
    80002202:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	a42080e7          	jalr	-1470(ra) # 80000c46 <acquire>
  p->state = RUNNABLE;
    8000220c:	4789                	li	a5,2
    8000220e:	cc9c                	sw	a5,24(s1)
  sched();
    80002210:	00000097          	auipc	ra,0x0
    80002214:	e00080e7          	jalr	-512(ra) # 80002010 <sched>
  release(&p->lock);
    80002218:	8526                	mv	a0,s1
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	ae0080e7          	jalr	-1312(ra) # 80000cfa <release>
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	64a2                	ld	s1,8(sp)
    80002228:	6105                	add	sp,sp,32
    8000222a:	8082                	ret

000000008000222c <sleep>:
{
    8000222c:	7179                	add	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	e44e                	sd	s3,8(sp)
    80002238:	1800                	add	s0,sp,48
    8000223a:	89aa                	mv	s3,a0
    8000223c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	7d2080e7          	jalr	2002(ra) # 80001a10 <myproc>
    80002246:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002248:	05250663          	beq	a0,s2,80002294 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	9fa080e7          	jalr	-1542(ra) # 80000c46 <acquire>
    release(lk);
    80002254:	854a                	mv	a0,s2
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	aa4080e7          	jalr	-1372(ra) # 80000cfa <release>
  p->chan = chan;
    8000225e:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002262:	4785                	li	a5,1
    80002264:	cc9c                	sw	a5,24(s1)
  sched();
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	daa080e7          	jalr	-598(ra) # 80002010 <sched>
  p->chan = 0;
    8000226e:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002272:	8526                	mv	a0,s1
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	a86080e7          	jalr	-1402(ra) # 80000cfa <release>
    acquire(lk);
    8000227c:	854a                	mv	a0,s2
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	9c8080e7          	jalr	-1592(ra) # 80000c46 <acquire>
}
    80002286:	70a2                	ld	ra,40(sp)
    80002288:	7402                	ld	s0,32(sp)
    8000228a:	64e2                	ld	s1,24(sp)
    8000228c:	6942                	ld	s2,16(sp)
    8000228e:	69a2                	ld	s3,8(sp)
    80002290:	6145                	add	sp,sp,48
    80002292:	8082                	ret
  p->chan = chan;
    80002294:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002298:	4785                	li	a5,1
    8000229a:	cd1c                	sw	a5,24(a0)
  sched();
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	d74080e7          	jalr	-652(ra) # 80002010 <sched>
  p->chan = 0;
    800022a4:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022a8:	bff9                	j	80002286 <sleep+0x5a>

00000000800022aa <wait>:
{
    800022aa:	715d                	add	sp,sp,-80
    800022ac:	e486                	sd	ra,72(sp)
    800022ae:	e0a2                	sd	s0,64(sp)
    800022b0:	fc26                	sd	s1,56(sp)
    800022b2:	f84a                	sd	s2,48(sp)
    800022b4:	f44e                	sd	s3,40(sp)
    800022b6:	f052                	sd	s4,32(sp)
    800022b8:	ec56                	sd	s5,24(sp)
    800022ba:	e85a                	sd	s6,16(sp)
    800022bc:	e45e                	sd	s7,8(sp)
    800022be:	0880                	add	s0,sp,80
    800022c0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	74e080e7          	jalr	1870(ra) # 80001a10 <myproc>
    800022ca:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	97a080e7          	jalr	-1670(ra) # 80000c46 <acquire>
    havekids = 0;
    800022d4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022d6:	4a11                	li	s4,4
        havekids = 1;
    800022d8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800022da:	00015997          	auipc	s3,0x15
    800022de:	68e98993          	add	s3,s3,1678 # 80017968 <tickslock>
    800022e2:	a845                	j	80002392 <wait+0xe8>
          pid = np->pid;
    800022e4:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022e8:	000b0e63          	beqz	s6,80002304 <wait+0x5a>
    800022ec:	4691                	li	a3,4
    800022ee:	03448613          	add	a2,s1,52
    800022f2:	85da                	mv	a1,s6
    800022f4:	05093503          	ld	a0,80(s2)
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	40e080e7          	jalr	1038(ra) # 80001706 <copyout>
    80002300:	02054d63          	bltz	a0,8000233a <wait+0x90>
          freeproc(np);
    80002304:	8526                	mv	a0,s1
    80002306:	00000097          	auipc	ra,0x0
    8000230a:	8bc080e7          	jalr	-1860(ra) # 80001bc2 <freeproc>
          release(&np->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	9ea080e7          	jalr	-1558(ra) # 80000cfa <release>
          release(&p->lock);
    80002318:	854a                	mv	a0,s2
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	9e0080e7          	jalr	-1568(ra) # 80000cfa <release>
}
    80002322:	854e                	mv	a0,s3
    80002324:	60a6                	ld	ra,72(sp)
    80002326:	6406                	ld	s0,64(sp)
    80002328:	74e2                	ld	s1,56(sp)
    8000232a:	7942                	ld	s2,48(sp)
    8000232c:	79a2                	ld	s3,40(sp)
    8000232e:	7a02                	ld	s4,32(sp)
    80002330:	6ae2                	ld	s5,24(sp)
    80002332:	6b42                	ld	s6,16(sp)
    80002334:	6ba2                	ld	s7,8(sp)
    80002336:	6161                	add	sp,sp,80
    80002338:	8082                	ret
            release(&np->lock);
    8000233a:	8526                	mv	a0,s1
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	9be080e7          	jalr	-1602(ra) # 80000cfa <release>
            release(&p->lock);
    80002344:	854a                	mv	a0,s2
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	9b4080e7          	jalr	-1612(ra) # 80000cfa <release>
            return -1;
    8000234e:	59fd                	li	s3,-1
    80002350:	bfc9                	j	80002322 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    80002352:	17048493          	add	s1,s1,368
    80002356:	03348463          	beq	s1,s3,8000237e <wait+0xd4>
      if(np->parent == p){
    8000235a:	709c                	ld	a5,32(s1)
    8000235c:	ff279be3          	bne	a5,s2,80002352 <wait+0xa8>
        acquire(&np->lock);
    80002360:	8526                	mv	a0,s1
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	8e4080e7          	jalr	-1820(ra) # 80000c46 <acquire>
        if(np->state == ZOMBIE){
    8000236a:	4c9c                	lw	a5,24(s1)
    8000236c:	f7478ce3          	beq	a5,s4,800022e4 <wait+0x3a>
        release(&np->lock);
    80002370:	8526                	mv	a0,s1
    80002372:	fffff097          	auipc	ra,0xfffff
    80002376:	988080e7          	jalr	-1656(ra) # 80000cfa <release>
        havekids = 1;
    8000237a:	8756                	mv	a4,s5
    8000237c:	bfd9                	j	80002352 <wait+0xa8>
    if(!havekids || p->killed){
    8000237e:	c305                	beqz	a4,8000239e <wait+0xf4>
    80002380:	03092783          	lw	a5,48(s2)
    80002384:	ef89                	bnez	a5,8000239e <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002386:	85ca                	mv	a1,s2
    80002388:	854a                	mv	a0,s2
    8000238a:	00000097          	auipc	ra,0x0
    8000238e:	ea2080e7          	jalr	-350(ra) # 8000222c <sleep>
    havekids = 0;
    80002392:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002394:	00010497          	auipc	s1,0x10
    80002398:	9d448493          	add	s1,s1,-1580 # 80011d68 <proc>
    8000239c:	bf7d                	j	8000235a <wait+0xb0>
      release(&p->lock);
    8000239e:	854a                	mv	a0,s2
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	95a080e7          	jalr	-1702(ra) # 80000cfa <release>
      return -1;
    800023a8:	59fd                	li	s3,-1
    800023aa:	bfa5                	j	80002322 <wait+0x78>

00000000800023ac <wakeup>:
{
    800023ac:	7139                	add	sp,sp,-64
    800023ae:	fc06                	sd	ra,56(sp)
    800023b0:	f822                	sd	s0,48(sp)
    800023b2:	f426                	sd	s1,40(sp)
    800023b4:	f04a                	sd	s2,32(sp)
    800023b6:	ec4e                	sd	s3,24(sp)
    800023b8:	e852                	sd	s4,16(sp)
    800023ba:	e456                	sd	s5,8(sp)
    800023bc:	0080                	add	s0,sp,64
    800023be:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023c0:	00010497          	auipc	s1,0x10
    800023c4:	9a848493          	add	s1,s1,-1624 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023c8:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023ca:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023cc:	00015917          	auipc	s2,0x15
    800023d0:	59c90913          	add	s2,s2,1436 # 80017968 <tickslock>
    800023d4:	a811                	j	800023e8 <wakeup+0x3c>
    release(&p->lock);
    800023d6:	8526                	mv	a0,s1
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	922080e7          	jalr	-1758(ra) # 80000cfa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800023e0:	17048493          	add	s1,s1,368
    800023e4:	03248063          	beq	s1,s2,80002404 <wakeup+0x58>
    acquire(&p->lock);
    800023e8:	8526                	mv	a0,s1
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	85c080e7          	jalr	-1956(ra) # 80000c46 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023f2:	4c9c                	lw	a5,24(s1)
    800023f4:	ff3791e3          	bne	a5,s3,800023d6 <wakeup+0x2a>
    800023f8:	749c                	ld	a5,40(s1)
    800023fa:	fd479ee3          	bne	a5,s4,800023d6 <wakeup+0x2a>
      p->state = RUNNABLE;
    800023fe:	0154ac23          	sw	s5,24(s1)
    80002402:	bfd1                	j	800023d6 <wakeup+0x2a>
}
    80002404:	70e2                	ld	ra,56(sp)
    80002406:	7442                	ld	s0,48(sp)
    80002408:	74a2                	ld	s1,40(sp)
    8000240a:	7902                	ld	s2,32(sp)
    8000240c:	69e2                	ld	s3,24(sp)
    8000240e:	6a42                	ld	s4,16(sp)
    80002410:	6aa2                	ld	s5,8(sp)
    80002412:	6121                	add	sp,sp,64
    80002414:	8082                	ret

0000000080002416 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002416:	7179                	add	sp,sp,-48
    80002418:	f406                	sd	ra,40(sp)
    8000241a:	f022                	sd	s0,32(sp)
    8000241c:	ec26                	sd	s1,24(sp)
    8000241e:	e84a                	sd	s2,16(sp)
    80002420:	e44e                	sd	s3,8(sp)
    80002422:	1800                	add	s0,sp,48
    80002424:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002426:	00010497          	auipc	s1,0x10
    8000242a:	94248493          	add	s1,s1,-1726 # 80011d68 <proc>
    8000242e:	00015997          	auipc	s3,0x15
    80002432:	53a98993          	add	s3,s3,1338 # 80017968 <tickslock>
    acquire(&p->lock);
    80002436:	8526                	mv	a0,s1
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	80e080e7          	jalr	-2034(ra) # 80000c46 <acquire>
    if(p->pid == pid){
    80002440:	5c9c                	lw	a5,56(s1)
    80002442:	01278d63          	beq	a5,s2,8000245c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002446:	8526                	mv	a0,s1
    80002448:	fffff097          	auipc	ra,0xfffff
    8000244c:	8b2080e7          	jalr	-1870(ra) # 80000cfa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002450:	17048493          	add	s1,s1,368
    80002454:	ff3491e3          	bne	s1,s3,80002436 <kill+0x20>
  }
  return -1;
    80002458:	557d                	li	a0,-1
    8000245a:	a821                	j	80002472 <kill+0x5c>
      p->killed = 1;
    8000245c:	4785                	li	a5,1
    8000245e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002460:	4c98                	lw	a4,24(s1)
    80002462:	00f70f63          	beq	a4,a5,80002480 <kill+0x6a>
      release(&p->lock);
    80002466:	8526                	mv	a0,s1
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	892080e7          	jalr	-1902(ra) # 80000cfa <release>
      return 0;
    80002470:	4501                	li	a0,0
}
    80002472:	70a2                	ld	ra,40(sp)
    80002474:	7402                	ld	s0,32(sp)
    80002476:	64e2                	ld	s1,24(sp)
    80002478:	6942                	ld	s2,16(sp)
    8000247a:	69a2                	ld	s3,8(sp)
    8000247c:	6145                	add	sp,sp,48
    8000247e:	8082                	ret
        p->state = RUNNABLE;
    80002480:	4789                	li	a5,2
    80002482:	cc9c                	sw	a5,24(s1)
    80002484:	b7cd                	j	80002466 <kill+0x50>

0000000080002486 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002486:	7179                	add	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	e052                	sd	s4,0(sp)
    80002494:	1800                	add	s0,sp,48
    80002496:	84aa                	mv	s1,a0
    80002498:	892e                	mv	s2,a1
    8000249a:	89b2                	mv	s3,a2
    8000249c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	572080e7          	jalr	1394(ra) # 80001a10 <myproc>
  if(user_dst){
    800024a6:	c08d                	beqz	s1,800024c8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024a8:	86d2                	mv	a3,s4
    800024aa:	864e                	mv	a2,s3
    800024ac:	85ca                	mv	a1,s2
    800024ae:	6928                	ld	a0,80(a0)
    800024b0:	fffff097          	auipc	ra,0xfffff
    800024b4:	256080e7          	jalr	598(ra) # 80001706 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024b8:	70a2                	ld	ra,40(sp)
    800024ba:	7402                	ld	s0,32(sp)
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	6942                	ld	s2,16(sp)
    800024c0:	69a2                	ld	s3,8(sp)
    800024c2:	6a02                	ld	s4,0(sp)
    800024c4:	6145                	add	sp,sp,48
    800024c6:	8082                	ret
    memmove((char *)dst, src, len);
    800024c8:	000a061b          	sext.w	a2,s4
    800024cc:	85ce                	mv	a1,s3
    800024ce:	854a                	mv	a0,s2
    800024d0:	fffff097          	auipc	ra,0xfffff
    800024d4:	8ce080e7          	jalr	-1842(ra) # 80000d9e <memmove>
    return 0;
    800024d8:	8526                	mv	a0,s1
    800024da:	bff9                	j	800024b8 <either_copyout+0x32>

00000000800024dc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024dc:	7179                	add	sp,sp,-48
    800024de:	f406                	sd	ra,40(sp)
    800024e0:	f022                	sd	s0,32(sp)
    800024e2:	ec26                	sd	s1,24(sp)
    800024e4:	e84a                	sd	s2,16(sp)
    800024e6:	e44e                	sd	s3,8(sp)
    800024e8:	e052                	sd	s4,0(sp)
    800024ea:	1800                	add	s0,sp,48
    800024ec:	892a                	mv	s2,a0
    800024ee:	84ae                	mv	s1,a1
    800024f0:	89b2                	mv	s3,a2
    800024f2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024f4:	fffff097          	auipc	ra,0xfffff
    800024f8:	51c080e7          	jalr	1308(ra) # 80001a10 <myproc>
  if(user_src){
    800024fc:	c08d                	beqz	s1,8000251e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024fe:	86d2                	mv	a3,s4
    80002500:	864e                	mv	a2,s3
    80002502:	85ca                	mv	a1,s2
    80002504:	6928                	ld	a0,80(a0)
    80002506:	fffff097          	auipc	ra,0xfffff
    8000250a:	28c080e7          	jalr	652(ra) # 80001792 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000250e:	70a2                	ld	ra,40(sp)
    80002510:	7402                	ld	s0,32(sp)
    80002512:	64e2                	ld	s1,24(sp)
    80002514:	6942                	ld	s2,16(sp)
    80002516:	69a2                	ld	s3,8(sp)
    80002518:	6a02                	ld	s4,0(sp)
    8000251a:	6145                	add	sp,sp,48
    8000251c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000251e:	000a061b          	sext.w	a2,s4
    80002522:	85ce                	mv	a1,s3
    80002524:	854a                	mv	a0,s2
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	878080e7          	jalr	-1928(ra) # 80000d9e <memmove>
    return 0;
    8000252e:	8526                	mv	a0,s1
    80002530:	bff9                	j	8000250e <either_copyin+0x32>

0000000080002532 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002532:	715d                	add	sp,sp,-80
    80002534:	e486                	sd	ra,72(sp)
    80002536:	e0a2                	sd	s0,64(sp)
    80002538:	fc26                	sd	s1,56(sp)
    8000253a:	f84a                	sd	s2,48(sp)
    8000253c:	f44e                	sd	s3,40(sp)
    8000253e:	f052                	sd	s4,32(sp)
    80002540:	ec56                	sd	s5,24(sp)
    80002542:	e85a                	sd	s6,16(sp)
    80002544:	e45e                	sd	s7,8(sp)
    80002546:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002548:	00006517          	auipc	a0,0x6
    8000254c:	b8050513          	add	a0,a0,-1152 # 800080c8 <digits+0x88>
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	03c080e7          	jalr	60(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002558:	00010497          	auipc	s1,0x10
    8000255c:	96848493          	add	s1,s1,-1688 # 80011ec0 <proc+0x158>
    80002560:	00015917          	auipc	s2,0x15
    80002564:	56090913          	add	s2,s2,1376 # 80017ac0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002568:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000256a:	00006997          	auipc	s3,0x6
    8000256e:	cfe98993          	add	s3,s3,-770 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002572:	00006a97          	auipc	s5,0x6
    80002576:	cfea8a93          	add	s5,s5,-770 # 80008270 <digits+0x230>
    printf("\n");
    8000257a:	00006a17          	auipc	s4,0x6
    8000257e:	b4ea0a13          	add	s4,s4,-1202 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002582:	00006b97          	auipc	s7,0x6
    80002586:	d26b8b93          	add	s7,s7,-730 # 800082a8 <states.0>
    8000258a:	a00d                	j	800025ac <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000258c:	ee06a583          	lw	a1,-288(a3)
    80002590:	8556                	mv	a0,s5
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	ffa080e7          	jalr	-6(ra) # 8000058c <printf>
    printf("\n");
    8000259a:	8552                	mv	a0,s4
    8000259c:	ffffe097          	auipc	ra,0xffffe
    800025a0:	ff0080e7          	jalr	-16(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025a4:	17048493          	add	s1,s1,368
    800025a8:	03248263          	beq	s1,s2,800025cc <procdump+0x9a>
    if(p->state == UNUSED)
    800025ac:	86a6                	mv	a3,s1
    800025ae:	ec04a783          	lw	a5,-320(s1)
    800025b2:	dbed                	beqz	a5,800025a4 <procdump+0x72>
      state = "???";
    800025b4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025b6:	fcfb6be3          	bltu	s6,a5,8000258c <procdump+0x5a>
    800025ba:	02079713          	sll	a4,a5,0x20
    800025be:	01d75793          	srl	a5,a4,0x1d
    800025c2:	97de                	add	a5,a5,s7
    800025c4:	6390                	ld	a2,0(a5)
    800025c6:	f279                	bnez	a2,8000258c <procdump+0x5a>
      state = "???";
    800025c8:	864e                	mv	a2,s3
    800025ca:	b7c9                	j	8000258c <procdump+0x5a>
  }
}
    800025cc:	60a6                	ld	ra,72(sp)
    800025ce:	6406                	ld	s0,64(sp)
    800025d0:	74e2                	ld	s1,56(sp)
    800025d2:	7942                	ld	s2,48(sp)
    800025d4:	79a2                	ld	s3,40(sp)
    800025d6:	7a02                	ld	s4,32(sp)
    800025d8:	6ae2                	ld	s5,24(sp)
    800025da:	6b42                	ld	s6,16(sp)
    800025dc:	6ba2                	ld	s7,8(sp)
    800025de:	6161                	add	sp,sp,80
    800025e0:	8082                	ret

00000000800025e2 <count_process>:

uint64
count_process(void){
    800025e2:	1141                	add	sp,sp,-16
    800025e4:	e422                	sd	s0,8(sp)
    800025e6:	0800                	add	s0,sp,16
  uint64 cnt=0;
  for(struct proc *p = proc; p < &proc[NPROC]; p++){
    800025e8:	0000f797          	auipc	a5,0xf
    800025ec:	78078793          	add	a5,a5,1920 # 80011d68 <proc>
  uint64 cnt=0;
    800025f0:	4501                	li	a0,0
  for(struct proc *p = proc; p < &proc[NPROC]; p++){
    800025f2:	00015697          	auipc	a3,0x15
    800025f6:	37668693          	add	a3,a3,886 # 80017968 <tickslock>
    if(p->state != UNUSED){
    800025fa:	4f98                	lw	a4,24(a5)
      cnt++;
    800025fc:	00e03733          	snez	a4,a4
    80002600:	953a                	add	a0,a0,a4
  for(struct proc *p = proc; p < &proc[NPROC]; p++){
    80002602:	17078793          	add	a5,a5,368
    80002606:	fed79ae3          	bne	a5,a3,800025fa <count_process+0x18>
    }
  }
  return cnt;
}
    8000260a:	6422                	ld	s0,8(sp)
    8000260c:	0141                	add	sp,sp,16
    8000260e:	8082                	ret

0000000080002610 <swtch>:
    80002610:	00153023          	sd	ra,0(a0)
    80002614:	00253423          	sd	sp,8(a0)
    80002618:	e900                	sd	s0,16(a0)
    8000261a:	ed04                	sd	s1,24(a0)
    8000261c:	03253023          	sd	s2,32(a0)
    80002620:	03353423          	sd	s3,40(a0)
    80002624:	03453823          	sd	s4,48(a0)
    80002628:	03553c23          	sd	s5,56(a0)
    8000262c:	05653023          	sd	s6,64(a0)
    80002630:	05753423          	sd	s7,72(a0)
    80002634:	05853823          	sd	s8,80(a0)
    80002638:	05953c23          	sd	s9,88(a0)
    8000263c:	07a53023          	sd	s10,96(a0)
    80002640:	07b53423          	sd	s11,104(a0)
    80002644:	0005b083          	ld	ra,0(a1)
    80002648:	0085b103          	ld	sp,8(a1)
    8000264c:	6980                	ld	s0,16(a1)
    8000264e:	6d84                	ld	s1,24(a1)
    80002650:	0205b903          	ld	s2,32(a1)
    80002654:	0285b983          	ld	s3,40(a1)
    80002658:	0305ba03          	ld	s4,48(a1)
    8000265c:	0385ba83          	ld	s5,56(a1)
    80002660:	0405bb03          	ld	s6,64(a1)
    80002664:	0485bb83          	ld	s7,72(a1)
    80002668:	0505bc03          	ld	s8,80(a1)
    8000266c:	0585bc83          	ld	s9,88(a1)
    80002670:	0605bd03          	ld	s10,96(a1)
    80002674:	0685bd83          	ld	s11,104(a1)
    80002678:	8082                	ret

000000008000267a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000267a:	1141                	add	sp,sp,-16
    8000267c:	e406                	sd	ra,8(sp)
    8000267e:	e022                	sd	s0,0(sp)
    80002680:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002682:	00006597          	auipc	a1,0x6
    80002686:	c4e58593          	add	a1,a1,-946 # 800082d0 <states.0+0x28>
    8000268a:	00015517          	auipc	a0,0x15
    8000268e:	2de50513          	add	a0,a0,734 # 80017968 <tickslock>
    80002692:	ffffe097          	auipc	ra,0xffffe
    80002696:	524080e7          	jalr	1316(ra) # 80000bb6 <initlock>
}
    8000269a:	60a2                	ld	ra,8(sp)
    8000269c:	6402                	ld	s0,0(sp)
    8000269e:	0141                	add	sp,sp,16
    800026a0:	8082                	ret

00000000800026a2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026a2:	1141                	add	sp,sp,-16
    800026a4:	e422                	sd	s0,8(sp)
    800026a6:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026a8:	00003797          	auipc	a5,0x3
    800026ac:	53878793          	add	a5,a5,1336 # 80005be0 <kernelvec>
    800026b0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026b4:	6422                	ld	s0,8(sp)
    800026b6:	0141                	add	sp,sp,16
    800026b8:	8082                	ret

00000000800026ba <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026ba:	1141                	add	sp,sp,-16
    800026bc:	e406                	sd	ra,8(sp)
    800026be:	e022                	sd	s0,0(sp)
    800026c0:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800026c2:	fffff097          	auipc	ra,0xfffff
    800026c6:	34e080e7          	jalr	846(ra) # 80001a10 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026ce:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026d0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026d4:	00005697          	auipc	a3,0x5
    800026d8:	92c68693          	add	a3,a3,-1748 # 80007000 <_trampoline>
    800026dc:	00005717          	auipc	a4,0x5
    800026e0:	92470713          	add	a4,a4,-1756 # 80007000 <_trampoline>
    800026e4:	8f15                	sub	a4,a4,a3
    800026e6:	040007b7          	lui	a5,0x4000
    800026ea:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800026ec:	07b2                	sll	a5,a5,0xc
    800026ee:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026f0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026f4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026f6:	18002673          	csrr	a2,satp
    800026fa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026fc:	6d30                	ld	a2,88(a0)
    800026fe:	6138                	ld	a4,64(a0)
    80002700:	6585                	lui	a1,0x1
    80002702:	972e                	add	a4,a4,a1
    80002704:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002706:	6d38                	ld	a4,88(a0)
    80002708:	00000617          	auipc	a2,0x0
    8000270c:	13c60613          	add	a2,a2,316 # 80002844 <usertrap>
    80002710:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002712:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002714:	8612                	mv	a2,tp
    80002716:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002718:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000271c:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002720:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002724:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002728:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000272a:	6f18                	ld	a4,24(a4)
    8000272c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002730:	692c                	ld	a1,80(a0)
    80002732:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002734:	00005717          	auipc	a4,0x5
    80002738:	95c70713          	add	a4,a4,-1700 # 80007090 <userret>
    8000273c:	8f15                	sub	a4,a4,a3
    8000273e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002740:	577d                	li	a4,-1
    80002742:	177e                	sll	a4,a4,0x3f
    80002744:	8dd9                	or	a1,a1,a4
    80002746:	02000537          	lui	a0,0x2000
    8000274a:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000274c:	0536                	sll	a0,a0,0xd
    8000274e:	9782                	jalr	a5
}
    80002750:	60a2                	ld	ra,8(sp)
    80002752:	6402                	ld	s0,0(sp)
    80002754:	0141                	add	sp,sp,16
    80002756:	8082                	ret

0000000080002758 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002758:	1101                	add	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80002762:	00015497          	auipc	s1,0x15
    80002766:	20648493          	add	s1,s1,518 # 80017968 <tickslock>
    8000276a:	8526                	mv	a0,s1
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	4da080e7          	jalr	1242(ra) # 80000c46 <acquire>
  ticks++;
    80002774:	00007517          	auipc	a0,0x7
    80002778:	8ac50513          	add	a0,a0,-1876 # 80009020 <ticks>
    8000277c:	411c                	lw	a5,0(a0)
    8000277e:	2785                	addw	a5,a5,1
    80002780:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002782:	00000097          	auipc	ra,0x0
    80002786:	c2a080e7          	jalr	-982(ra) # 800023ac <wakeup>
  release(&tickslock);
    8000278a:	8526                	mv	a0,s1
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	56e080e7          	jalr	1390(ra) # 80000cfa <release>
}
    80002794:	60e2                	ld	ra,24(sp)
    80002796:	6442                	ld	s0,16(sp)
    80002798:	64a2                	ld	s1,8(sp)
    8000279a:	6105                	add	sp,sp,32
    8000279c:	8082                	ret

000000008000279e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000279e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027a2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800027a4:	0807df63          	bgez	a5,80002842 <devintr+0xa4>
{
    800027a8:	1101                	add	sp,sp,-32
    800027aa:	ec06                	sd	ra,24(sp)
    800027ac:	e822                	sd	s0,16(sp)
    800027ae:	e426                	sd	s1,8(sp)
    800027b0:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    800027b2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800027b6:	46a5                	li	a3,9
    800027b8:	00d70d63          	beq	a4,a3,800027d2 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    800027bc:	577d                	li	a4,-1
    800027be:	177e                	sll	a4,a4,0x3f
    800027c0:	0705                	add	a4,a4,1
    return 0;
    800027c2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027c4:	04e78e63          	beq	a5,a4,80002820 <devintr+0x82>
  }
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	add	sp,sp,32
    800027d0:	8082                	ret
    int irq = plic_claim();
    800027d2:	00003097          	auipc	ra,0x3
    800027d6:	516080e7          	jalr	1302(ra) # 80005ce8 <plic_claim>
    800027da:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027dc:	47a9                	li	a5,10
    800027de:	02f50763          	beq	a0,a5,8000280c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    800027e2:	4785                	li	a5,1
    800027e4:	02f50963          	beq	a0,a5,80002816 <devintr+0x78>
    return 1;
    800027e8:	4505                	li	a0,1
    } else if(irq){
    800027ea:	dcf9                	beqz	s1,800027c8 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    800027ec:	85a6                	mv	a1,s1
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	aea50513          	add	a0,a0,-1302 # 800082d8 <states.0+0x30>
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	d96080e7          	jalr	-618(ra) # 8000058c <printf>
      plic_complete(irq);
    800027fe:	8526                	mv	a0,s1
    80002800:	00003097          	auipc	ra,0x3
    80002804:	50c080e7          	jalr	1292(ra) # 80005d0c <plic_complete>
    return 1;
    80002808:	4505                	li	a0,1
    8000280a:	bf7d                	j	800027c8 <devintr+0x2a>
      uartintr();
    8000280c:	ffffe097          	auipc	ra,0xffffe
    80002810:	1b2080e7          	jalr	434(ra) # 800009be <uartintr>
    if(irq)
    80002814:	b7ed                	j	800027fe <devintr+0x60>
      virtio_disk_intr();
    80002816:	00004097          	auipc	ra,0x4
    8000281a:	968080e7          	jalr	-1688(ra) # 8000617e <virtio_disk_intr>
    if(irq)
    8000281e:	b7c5                	j	800027fe <devintr+0x60>
    if(cpuid() == 0){
    80002820:	fffff097          	auipc	ra,0xfffff
    80002824:	1c4080e7          	jalr	452(ra) # 800019e4 <cpuid>
    80002828:	c901                	beqz	a0,80002838 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000282a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000282e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002830:	14479073          	csrw	sip,a5
    return 2;
    80002834:	4509                	li	a0,2
    80002836:	bf49                	j	800027c8 <devintr+0x2a>
      clockintr();
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	f20080e7          	jalr	-224(ra) # 80002758 <clockintr>
    80002840:	b7ed                	j	8000282a <devintr+0x8c>
}
    80002842:	8082                	ret

0000000080002844 <usertrap>:
{
    80002844:	1101                	add	sp,sp,-32
    80002846:	ec06                	sd	ra,24(sp)
    80002848:	e822                	sd	s0,16(sp)
    8000284a:	e426                	sd	s1,8(sp)
    8000284c:	e04a                	sd	s2,0(sp)
    8000284e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002850:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002854:	1007f793          	and	a5,a5,256
    80002858:	e3ad                	bnez	a5,800028ba <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000285a:	00003797          	auipc	a5,0x3
    8000285e:	38678793          	add	a5,a5,902 # 80005be0 <kernelvec>
    80002862:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	1aa080e7          	jalr	426(ra) # 80001a10 <myproc>
    8000286e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002870:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002872:	14102773          	csrr	a4,sepc
    80002876:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002878:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000287c:	47a1                	li	a5,8
    8000287e:	04f71c63          	bne	a4,a5,800028d6 <usertrap+0x92>
    if(p->killed)
    80002882:	591c                	lw	a5,48(a0)
    80002884:	e3b9                	bnez	a5,800028ca <usertrap+0x86>
    p->trapframe->epc += 4;
    80002886:	6cb8                	ld	a4,88(s1)
    80002888:	6f1c                	ld	a5,24(a4)
    8000288a:	0791                	add	a5,a5,4
    8000288c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000288e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002892:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002896:	10079073          	csrw	sstatus,a5
    syscall();
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	2e0080e7          	jalr	736(ra) # 80002b7a <syscall>
  if(p->killed)
    800028a2:	589c                	lw	a5,48(s1)
    800028a4:	ebc1                	bnez	a5,80002934 <usertrap+0xf0>
  usertrapret();
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	e14080e7          	jalr	-492(ra) # 800026ba <usertrapret>
}
    800028ae:	60e2                	ld	ra,24(sp)
    800028b0:	6442                	ld	s0,16(sp)
    800028b2:	64a2                	ld	s1,8(sp)
    800028b4:	6902                	ld	s2,0(sp)
    800028b6:	6105                	add	sp,sp,32
    800028b8:	8082                	ret
    panic("usertrap: not from user mode");
    800028ba:	00006517          	auipc	a0,0x6
    800028be:	a3e50513          	add	a0,a0,-1474 # 800082f8 <states.0+0x50>
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	c80080e7          	jalr	-896(ra) # 80000542 <panic>
      exit(-1);
    800028ca:	557d                	li	a0,-1
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	81a080e7          	jalr	-2022(ra) # 800020e6 <exit>
    800028d4:	bf4d                	j	80002886 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	ec8080e7          	jalr	-312(ra) # 8000279e <devintr>
    800028de:	892a                	mv	s2,a0
    800028e0:	c501                	beqz	a0,800028e8 <usertrap+0xa4>
  if(p->killed)
    800028e2:	589c                	lw	a5,48(s1)
    800028e4:	c3a1                	beqz	a5,80002924 <usertrap+0xe0>
    800028e6:	a815                	j	8000291a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028ec:	5c90                	lw	a2,56(s1)
    800028ee:	00006517          	auipc	a0,0x6
    800028f2:	a2a50513          	add	a0,a0,-1494 # 80008318 <states.0+0x70>
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	c96080e7          	jalr	-874(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028fe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002902:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	a4250513          	add	a0,a0,-1470 # 80008348 <states.0+0xa0>
    8000290e:	ffffe097          	auipc	ra,0xffffe
    80002912:	c7e080e7          	jalr	-898(ra) # 8000058c <printf>
    p->killed = 1;
    80002916:	4785                	li	a5,1
    80002918:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000291a:	557d                	li	a0,-1
    8000291c:	fffff097          	auipc	ra,0xfffff
    80002920:	7ca080e7          	jalr	1994(ra) # 800020e6 <exit>
  if(which_dev == 2)
    80002924:	4789                	li	a5,2
    80002926:	f8f910e3          	bne	s2,a5,800028a6 <usertrap+0x62>
    yield();
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	8c6080e7          	jalr	-1850(ra) # 800021f0 <yield>
    80002932:	bf95                	j	800028a6 <usertrap+0x62>
  int which_dev = 0;
    80002934:	4901                	li	s2,0
    80002936:	b7d5                	j	8000291a <usertrap+0xd6>

0000000080002938 <kerneltrap>:
{
    80002938:	7179                	add	sp,sp,-48
    8000293a:	f406                	sd	ra,40(sp)
    8000293c:	f022                	sd	s0,32(sp)
    8000293e:	ec26                	sd	s1,24(sp)
    80002940:	e84a                	sd	s2,16(sp)
    80002942:	e44e                	sd	s3,8(sp)
    80002944:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002946:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000294a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000294e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002952:	1004f793          	and	a5,s1,256
    80002956:	cb85                	beqz	a5,80002986 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002958:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000295c:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    8000295e:	ef85                	bnez	a5,80002996 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002960:	00000097          	auipc	ra,0x0
    80002964:	e3e080e7          	jalr	-450(ra) # 8000279e <devintr>
    80002968:	cd1d                	beqz	a0,800029a6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000296a:	4789                	li	a5,2
    8000296c:	06f50a63          	beq	a0,a5,800029e0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002970:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002974:	10049073          	csrw	sstatus,s1
}
    80002978:	70a2                	ld	ra,40(sp)
    8000297a:	7402                	ld	s0,32(sp)
    8000297c:	64e2                	ld	s1,24(sp)
    8000297e:	6942                	ld	s2,16(sp)
    80002980:	69a2                	ld	s3,8(sp)
    80002982:	6145                	add	sp,sp,48
    80002984:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002986:	00006517          	auipc	a0,0x6
    8000298a:	9e250513          	add	a0,a0,-1566 # 80008368 <states.0+0xc0>
    8000298e:	ffffe097          	auipc	ra,0xffffe
    80002992:	bb4080e7          	jalr	-1100(ra) # 80000542 <panic>
    panic("kerneltrap: interrupts enabled");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	9fa50513          	add	a0,a0,-1542 # 80008390 <states.0+0xe8>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	ba4080e7          	jalr	-1116(ra) # 80000542 <panic>
    printf("scause %p\n", scause);
    800029a6:	85ce                	mv	a1,s3
    800029a8:	00006517          	auipc	a0,0x6
    800029ac:	a0850513          	add	a0,a0,-1528 # 800083b0 <states.0+0x108>
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	bdc080e7          	jalr	-1060(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029bc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029c0:	00006517          	auipc	a0,0x6
    800029c4:	a0050513          	add	a0,a0,-1536 # 800083c0 <states.0+0x118>
    800029c8:	ffffe097          	auipc	ra,0xffffe
    800029cc:	bc4080e7          	jalr	-1084(ra) # 8000058c <printf>
    panic("kerneltrap");
    800029d0:	00006517          	auipc	a0,0x6
    800029d4:	a0850513          	add	a0,a0,-1528 # 800083d8 <states.0+0x130>
    800029d8:	ffffe097          	auipc	ra,0xffffe
    800029dc:	b6a080e7          	jalr	-1174(ra) # 80000542 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029e0:	fffff097          	auipc	ra,0xfffff
    800029e4:	030080e7          	jalr	48(ra) # 80001a10 <myproc>
    800029e8:	d541                	beqz	a0,80002970 <kerneltrap+0x38>
    800029ea:	fffff097          	auipc	ra,0xfffff
    800029ee:	026080e7          	jalr	38(ra) # 80001a10 <myproc>
    800029f2:	4d18                	lw	a4,24(a0)
    800029f4:	478d                	li	a5,3
    800029f6:	f6f71de3          	bne	a4,a5,80002970 <kerneltrap+0x38>
    yield();
    800029fa:	fffff097          	auipc	ra,0xfffff
    800029fe:	7f6080e7          	jalr	2038(ra) # 800021f0 <yield>
    80002a02:	b7bd                	j	80002970 <kerneltrap+0x38>

0000000080002a04 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a04:	1101                	add	sp,sp,-32
    80002a06:	ec06                	sd	ra,24(sp)
    80002a08:	e822                	sd	s0,16(sp)
    80002a0a:	e426                	sd	s1,8(sp)
    80002a0c:	1000                	add	s0,sp,32
    80002a0e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a10:	fffff097          	auipc	ra,0xfffff
    80002a14:	000080e7          	jalr	ra # 80001a10 <myproc>
  switch (n) {
    80002a18:	4795                	li	a5,5
    80002a1a:	0497e163          	bltu	a5,s1,80002a5c <argraw+0x58>
    80002a1e:	048a                	sll	s1,s1,0x2
    80002a20:	00006717          	auipc	a4,0x6
    80002a24:	ab870713          	add	a4,a4,-1352 # 800084d8 <states.0+0x230>
    80002a28:	94ba                	add	s1,s1,a4
    80002a2a:	409c                	lw	a5,0(s1)
    80002a2c:	97ba                	add	a5,a5,a4
    80002a2e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a30:	6d3c                	ld	a5,88(a0)
    80002a32:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a34:	60e2                	ld	ra,24(sp)
    80002a36:	6442                	ld	s0,16(sp)
    80002a38:	64a2                	ld	s1,8(sp)
    80002a3a:	6105                	add	sp,sp,32
    80002a3c:	8082                	ret
    return p->trapframe->a1;
    80002a3e:	6d3c                	ld	a5,88(a0)
    80002a40:	7fa8                	ld	a0,120(a5)
    80002a42:	bfcd                	j	80002a34 <argraw+0x30>
    return p->trapframe->a2;
    80002a44:	6d3c                	ld	a5,88(a0)
    80002a46:	63c8                	ld	a0,128(a5)
    80002a48:	b7f5                	j	80002a34 <argraw+0x30>
    return p->trapframe->a3;
    80002a4a:	6d3c                	ld	a5,88(a0)
    80002a4c:	67c8                	ld	a0,136(a5)
    80002a4e:	b7dd                	j	80002a34 <argraw+0x30>
    return p->trapframe->a4;
    80002a50:	6d3c                	ld	a5,88(a0)
    80002a52:	6bc8                	ld	a0,144(a5)
    80002a54:	b7c5                	j	80002a34 <argraw+0x30>
    return p->trapframe->a5;
    80002a56:	6d3c                	ld	a5,88(a0)
    80002a58:	6fc8                	ld	a0,152(a5)
    80002a5a:	bfe9                	j	80002a34 <argraw+0x30>
  panic("argraw");
    80002a5c:	00006517          	auipc	a0,0x6
    80002a60:	98c50513          	add	a0,a0,-1652 # 800083e8 <states.0+0x140>
    80002a64:	ffffe097          	auipc	ra,0xffffe
    80002a68:	ade080e7          	jalr	-1314(ra) # 80000542 <panic>

0000000080002a6c <fetchaddr>:
{
    80002a6c:	1101                	add	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	e04a                	sd	s2,0(sp)
    80002a76:	1000                	add	s0,sp,32
    80002a78:	84aa                	mv	s1,a0
    80002a7a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a7c:	fffff097          	auipc	ra,0xfffff
    80002a80:	f94080e7          	jalr	-108(ra) # 80001a10 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a84:	653c                	ld	a5,72(a0)
    80002a86:	02f4f863          	bgeu	s1,a5,80002ab6 <fetchaddr+0x4a>
    80002a8a:	00848713          	add	a4,s1,8
    80002a8e:	02e7e663          	bltu	a5,a4,80002aba <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a92:	46a1                	li	a3,8
    80002a94:	8626                	mv	a2,s1
    80002a96:	85ca                	mv	a1,s2
    80002a98:	6928                	ld	a0,80(a0)
    80002a9a:	fffff097          	auipc	ra,0xfffff
    80002a9e:	cf8080e7          	jalr	-776(ra) # 80001792 <copyin>
    80002aa2:	00a03533          	snez	a0,a0
    80002aa6:	40a00533          	neg	a0,a0
}
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6902                	ld	s2,0(sp)
    80002ab2:	6105                	add	sp,sp,32
    80002ab4:	8082                	ret
    return -1;
    80002ab6:	557d                	li	a0,-1
    80002ab8:	bfcd                	j	80002aaa <fetchaddr+0x3e>
    80002aba:	557d                	li	a0,-1
    80002abc:	b7fd                	j	80002aaa <fetchaddr+0x3e>

0000000080002abe <fetchstr>:
{
    80002abe:	7179                	add	sp,sp,-48
    80002ac0:	f406                	sd	ra,40(sp)
    80002ac2:	f022                	sd	s0,32(sp)
    80002ac4:	ec26                	sd	s1,24(sp)
    80002ac6:	e84a                	sd	s2,16(sp)
    80002ac8:	e44e                	sd	s3,8(sp)
    80002aca:	1800                	add	s0,sp,48
    80002acc:	892a                	mv	s2,a0
    80002ace:	84ae                	mv	s1,a1
    80002ad0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ad2:	fffff097          	auipc	ra,0xfffff
    80002ad6:	f3e080e7          	jalr	-194(ra) # 80001a10 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002ada:	86ce                	mv	a3,s3
    80002adc:	864a                	mv	a2,s2
    80002ade:	85a6                	mv	a1,s1
    80002ae0:	6928                	ld	a0,80(a0)
    80002ae2:	fffff097          	auipc	ra,0xfffff
    80002ae6:	d3e080e7          	jalr	-706(ra) # 80001820 <copyinstr>
  if(err < 0)
    80002aea:	00054763          	bltz	a0,80002af8 <fetchstr+0x3a>
  return strlen(buf);
    80002aee:	8526                	mv	a0,s1
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	3d4080e7          	jalr	980(ra) # 80000ec4 <strlen>
}
    80002af8:	70a2                	ld	ra,40(sp)
    80002afa:	7402                	ld	s0,32(sp)
    80002afc:	64e2                	ld	s1,24(sp)
    80002afe:	6942                	ld	s2,16(sp)
    80002b00:	69a2                	ld	s3,8(sp)
    80002b02:	6145                	add	sp,sp,48
    80002b04:	8082                	ret

0000000080002b06 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b06:	1101                	add	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	1000                	add	s0,sp,32
    80002b10:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	ef2080e7          	jalr	-270(ra) # 80002a04 <argraw>
    80002b1a:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b1c:	4501                	li	a0,0
    80002b1e:	60e2                	ld	ra,24(sp)
    80002b20:	6442                	ld	s0,16(sp)
    80002b22:	64a2                	ld	s1,8(sp)
    80002b24:	6105                	add	sp,sp,32
    80002b26:	8082                	ret

0000000080002b28 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b28:	1101                	add	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	1000                	add	s0,sp,32
    80002b32:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b34:	00000097          	auipc	ra,0x0
    80002b38:	ed0080e7          	jalr	-304(ra) # 80002a04 <argraw>
    80002b3c:	e088                	sd	a0,0(s1)
  return 0;
}
    80002b3e:	4501                	li	a0,0
    80002b40:	60e2                	ld	ra,24(sp)
    80002b42:	6442                	ld	s0,16(sp)
    80002b44:	64a2                	ld	s1,8(sp)
    80002b46:	6105                	add	sp,sp,32
    80002b48:	8082                	ret

0000000080002b4a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b4a:	1101                	add	sp,sp,-32
    80002b4c:	ec06                	sd	ra,24(sp)
    80002b4e:	e822                	sd	s0,16(sp)
    80002b50:	e426                	sd	s1,8(sp)
    80002b52:	e04a                	sd	s2,0(sp)
    80002b54:	1000                	add	s0,sp,32
    80002b56:	84ae                	mv	s1,a1
    80002b58:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	eaa080e7          	jalr	-342(ra) # 80002a04 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002b62:	864a                	mv	a2,s2
    80002b64:	85a6                	mv	a1,s1
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	f58080e7          	jalr	-168(ra) # 80002abe <fetchstr>
}
    80002b6e:	60e2                	ld	ra,24(sp)
    80002b70:	6442                	ld	s0,16(sp)
    80002b72:	64a2                	ld	s1,8(sp)
    80002b74:	6902                	ld	s2,0(sp)
    80002b76:	6105                	add	sp,sp,32
    80002b78:	8082                	ret

0000000080002b7a <syscall>:
[SYS_sysinfo] "sysinfo",
};

void
syscall(void)
{
    80002b7a:	7179                	add	sp,sp,-48
    80002b7c:	f406                	sd	ra,40(sp)
    80002b7e:	f022                	sd	s0,32(sp)
    80002b80:	ec26                	sd	s1,24(sp)
    80002b82:	e84a                	sd	s2,16(sp)
    80002b84:	e44e                	sd	s3,8(sp)
    80002b86:	1800                	add	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	e88080e7          	jalr	-376(ra) # 80001a10 <myproc>
    80002b90:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b92:	05853903          	ld	s2,88(a0)
    80002b96:	0a893783          	ld	a5,168(s2)
    80002b9a:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b9e:	37fd                	addw	a5,a5,-1
    80002ba0:	4759                	li	a4,22
    80002ba2:	04f76763          	bltu	a4,a5,80002bf0 <syscall+0x76>
    80002ba6:	00399713          	sll	a4,s3,0x3
    80002baa:	00006797          	auipc	a5,0x6
    80002bae:	94678793          	add	a5,a5,-1722 # 800084f0 <syscalls>
    80002bb2:	97ba                	add	a5,a5,a4
    80002bb4:	639c                	ld	a5,0(a5)
    80002bb6:	cf8d                	beqz	a5,80002bf0 <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();
    80002bb8:	9782                	jalr	a5
    80002bba:	06a93823          	sd	a0,112(s2)
    if(p->mask & (1 << num)){
    80002bbe:	1684a783          	lw	a5,360(s1)
    80002bc2:	4137d7bb          	sraw	a5,a5,s3
    80002bc6:	8b85                	and	a5,a5,1
    80002bc8:	c3b9                	beqz	a5,80002c0e <syscall+0x94>
      printf("%d: syscall %s -> %d\n",p->pid, syscall_names[num], p->trapframe->a0);
    80002bca:	6cb8                	ld	a4,88(s1)
    80002bcc:	098e                	sll	s3,s3,0x3
    80002bce:	00006797          	auipc	a5,0x6
    80002bd2:	92278793          	add	a5,a5,-1758 # 800084f0 <syscalls>
    80002bd6:	97ce                	add	a5,a5,s3
    80002bd8:	7b34                	ld	a3,112(a4)
    80002bda:	63f0                	ld	a2,192(a5)
    80002bdc:	5c8c                	lw	a1,56(s1)
    80002bde:	00006517          	auipc	a0,0x6
    80002be2:	81250513          	add	a0,a0,-2030 # 800083f0 <states.0+0x148>
    80002be6:	ffffe097          	auipc	ra,0xffffe
    80002bea:	9a6080e7          	jalr	-1626(ra) # 8000058c <printf>
    80002bee:	a005                	j	80002c0e <syscall+0x94>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002bf0:	86ce                	mv	a3,s3
    80002bf2:	15848613          	add	a2,s1,344
    80002bf6:	5c8c                	lw	a1,56(s1)
    80002bf8:	00006517          	auipc	a0,0x6
    80002bfc:	81050513          	add	a0,a0,-2032 # 80008408 <states.0+0x160>
    80002c00:	ffffe097          	auipc	ra,0xffffe
    80002c04:	98c080e7          	jalr	-1652(ra) # 8000058c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c08:	6cbc                	ld	a5,88(s1)
    80002c0a:	577d                	li	a4,-1
    80002c0c:	fbb8                	sd	a4,112(a5)
  }
}
    80002c0e:	70a2                	ld	ra,40(sp)
    80002c10:	7402                	ld	s0,32(sp)
    80002c12:	64e2                	ld	s1,24(sp)
    80002c14:	6942                	ld	s2,16(sp)
    80002c16:	69a2                	ld	s3,8(sp)
    80002c18:	6145                	add	sp,sp,48
    80002c1a:	8082                	ret

0000000080002c1c <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002c1c:	1101                	add	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c24:	fec40593          	add	a1,s0,-20
    80002c28:	4501                	li	a0,0
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	edc080e7          	jalr	-292(ra) # 80002b06 <argint>
    return -1;
    80002c32:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c34:	00054963          	bltz	a0,80002c46 <sys_exit+0x2a>
  exit(n);
    80002c38:	fec42503          	lw	a0,-20(s0)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	4aa080e7          	jalr	1194(ra) # 800020e6 <exit>
  return 0;  // not reached
    80002c44:	4781                	li	a5,0
}
    80002c46:	853e                	mv	a0,a5
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	6105                	add	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c50:	1141                	add	sp,sp,-16
    80002c52:	e406                	sd	ra,8(sp)
    80002c54:	e022                	sd	s0,0(sp)
    80002c56:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	db8080e7          	jalr	-584(ra) # 80001a10 <myproc>
}
    80002c60:	5d08                	lw	a0,56(a0)
    80002c62:	60a2                	ld	ra,8(sp)
    80002c64:	6402                	ld	s0,0(sp)
    80002c66:	0141                	add	sp,sp,16
    80002c68:	8082                	ret

0000000080002c6a <sys_fork>:

uint64
sys_fork(void)
{
    80002c6a:	1141                	add	sp,sp,-16
    80002c6c:	e406                	sd	ra,8(sp)
    80002c6e:	e022                	sd	s0,0(sp)
    80002c70:	0800                	add	s0,sp,16
  return fork();
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	162080e7          	jalr	354(ra) # 80001dd4 <fork>
}
    80002c7a:	60a2                	ld	ra,8(sp)
    80002c7c:	6402                	ld	s0,0(sp)
    80002c7e:	0141                	add	sp,sp,16
    80002c80:	8082                	ret

0000000080002c82 <sys_wait>:

uint64
sys_wait(void)
{
    80002c82:	1101                	add	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002c8a:	fe840593          	add	a1,s0,-24
    80002c8e:	4501                	li	a0,0
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	e98080e7          	jalr	-360(ra) # 80002b28 <argaddr>
    80002c98:	87aa                	mv	a5,a0
    return -1;
    80002c9a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002c9c:	0007c863          	bltz	a5,80002cac <sys_wait+0x2a>
  return wait(p);
    80002ca0:	fe843503          	ld	a0,-24(s0)
    80002ca4:	fffff097          	auipc	ra,0xfffff
    80002ca8:	606080e7          	jalr	1542(ra) # 800022aa <wait>
}
    80002cac:	60e2                	ld	ra,24(sp)
    80002cae:	6442                	ld	s0,16(sp)
    80002cb0:	6105                	add	sp,sp,32
    80002cb2:	8082                	ret

0000000080002cb4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cb4:	7179                	add	sp,sp,-48
    80002cb6:	f406                	sd	ra,40(sp)
    80002cb8:	f022                	sd	s0,32(sp)
    80002cba:	ec26                	sd	s1,24(sp)
    80002cbc:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cbe:	fdc40593          	add	a1,s0,-36
    80002cc2:	4501                	li	a0,0
    80002cc4:	00000097          	auipc	ra,0x0
    80002cc8:	e42080e7          	jalr	-446(ra) # 80002b06 <argint>
    80002ccc:	87aa                	mv	a5,a0
    return -1;
    80002cce:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002cd0:	0207c063          	bltz	a5,80002cf0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	d3c080e7          	jalr	-708(ra) # 80001a10 <myproc>
    80002cdc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cde:	fdc42503          	lw	a0,-36(s0)
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	07a080e7          	jalr	122(ra) # 80001d5c <growproc>
    80002cea:	00054863          	bltz	a0,80002cfa <sys_sbrk+0x46>
    return -1;
  return addr;
    80002cee:	8526                	mv	a0,s1
}
    80002cf0:	70a2                	ld	ra,40(sp)
    80002cf2:	7402                	ld	s0,32(sp)
    80002cf4:	64e2                	ld	s1,24(sp)
    80002cf6:	6145                	add	sp,sp,48
    80002cf8:	8082                	ret
    return -1;
    80002cfa:	557d                	li	a0,-1
    80002cfc:	bfd5                	j	80002cf0 <sys_sbrk+0x3c>

0000000080002cfe <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cfe:	7139                	add	sp,sp,-64
    80002d00:	fc06                	sd	ra,56(sp)
    80002d02:	f822                	sd	s0,48(sp)
    80002d04:	f426                	sd	s1,40(sp)
    80002d06:	f04a                	sd	s2,32(sp)
    80002d08:	ec4e                	sd	s3,24(sp)
    80002d0a:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d0c:	fcc40593          	add	a1,s0,-52
    80002d10:	4501                	li	a0,0
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	df4080e7          	jalr	-524(ra) # 80002b06 <argint>
    return -1;
    80002d1a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d1c:	06054563          	bltz	a0,80002d86 <sys_sleep+0x88>
  acquire(&tickslock);
    80002d20:	00015517          	auipc	a0,0x15
    80002d24:	c4850513          	add	a0,a0,-952 # 80017968 <tickslock>
    80002d28:	ffffe097          	auipc	ra,0xffffe
    80002d2c:	f1e080e7          	jalr	-226(ra) # 80000c46 <acquire>
  ticks0 = ticks;
    80002d30:	00006917          	auipc	s2,0x6
    80002d34:	2f092903          	lw	s2,752(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002d38:	fcc42783          	lw	a5,-52(s0)
    80002d3c:	cf85                	beqz	a5,80002d74 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d3e:	00015997          	auipc	s3,0x15
    80002d42:	c2a98993          	add	s3,s3,-982 # 80017968 <tickslock>
    80002d46:	00006497          	auipc	s1,0x6
    80002d4a:	2da48493          	add	s1,s1,730 # 80009020 <ticks>
    if(myproc()->killed){
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	cc2080e7          	jalr	-830(ra) # 80001a10 <myproc>
    80002d56:	591c                	lw	a5,48(a0)
    80002d58:	ef9d                	bnez	a5,80002d96 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002d5a:	85ce                	mv	a1,s3
    80002d5c:	8526                	mv	a0,s1
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	4ce080e7          	jalr	1230(ra) # 8000222c <sleep>
  while(ticks - ticks0 < n){
    80002d66:	409c                	lw	a5,0(s1)
    80002d68:	412787bb          	subw	a5,a5,s2
    80002d6c:	fcc42703          	lw	a4,-52(s0)
    80002d70:	fce7efe3          	bltu	a5,a4,80002d4e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002d74:	00015517          	auipc	a0,0x15
    80002d78:	bf450513          	add	a0,a0,-1036 # 80017968 <tickslock>
    80002d7c:	ffffe097          	auipc	ra,0xffffe
    80002d80:	f7e080e7          	jalr	-130(ra) # 80000cfa <release>
  return 0;
    80002d84:	4781                	li	a5,0
}
    80002d86:	853e                	mv	a0,a5
    80002d88:	70e2                	ld	ra,56(sp)
    80002d8a:	7442                	ld	s0,48(sp)
    80002d8c:	74a2                	ld	s1,40(sp)
    80002d8e:	7902                	ld	s2,32(sp)
    80002d90:	69e2                	ld	s3,24(sp)
    80002d92:	6121                	add	sp,sp,64
    80002d94:	8082                	ret
      release(&tickslock);
    80002d96:	00015517          	auipc	a0,0x15
    80002d9a:	bd250513          	add	a0,a0,-1070 # 80017968 <tickslock>
    80002d9e:	ffffe097          	auipc	ra,0xffffe
    80002da2:	f5c080e7          	jalr	-164(ra) # 80000cfa <release>
      return -1;
    80002da6:	57fd                	li	a5,-1
    80002da8:	bff9                	j	80002d86 <sys_sleep+0x88>

0000000080002daa <sys_kill>:

uint64
sys_kill(void)
{
    80002daa:	1101                	add	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002db2:	fec40593          	add	a1,s0,-20
    80002db6:	4501                	li	a0,0
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	d4e080e7          	jalr	-690(ra) # 80002b06 <argint>
    80002dc0:	87aa                	mv	a5,a0
    return -1;
    80002dc2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002dc4:	0007c863          	bltz	a5,80002dd4 <sys_kill+0x2a>
  return kill(pid);
    80002dc8:	fec42503          	lw	a0,-20(s0)
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	64a080e7          	jalr	1610(ra) # 80002416 <kill>
}
    80002dd4:	60e2                	ld	ra,24(sp)
    80002dd6:	6442                	ld	s0,16(sp)
    80002dd8:	6105                	add	sp,sp,32
    80002dda:	8082                	ret

0000000080002ddc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ddc:	1101                	add	sp,sp,-32
    80002dde:	ec06                	sd	ra,24(sp)
    80002de0:	e822                	sd	s0,16(sp)
    80002de2:	e426                	sd	s1,8(sp)
    80002de4:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002de6:	00015517          	auipc	a0,0x15
    80002dea:	b8250513          	add	a0,a0,-1150 # 80017968 <tickslock>
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	e58080e7          	jalr	-424(ra) # 80000c46 <acquire>
  xticks = ticks;
    80002df6:	00006497          	auipc	s1,0x6
    80002dfa:	22a4a483          	lw	s1,554(s1) # 80009020 <ticks>
  release(&tickslock);
    80002dfe:	00015517          	auipc	a0,0x15
    80002e02:	b6a50513          	add	a0,a0,-1174 # 80017968 <tickslock>
    80002e06:	ffffe097          	auipc	ra,0xffffe
    80002e0a:	ef4080e7          	jalr	-268(ra) # 80000cfa <release>
  return xticks;
}
    80002e0e:	02049513          	sll	a0,s1,0x20
    80002e12:	9101                	srl	a0,a0,0x20
    80002e14:	60e2                	ld	ra,24(sp)
    80002e16:	6442                	ld	s0,16(sp)
    80002e18:	64a2                	ld	s1,8(sp)
    80002e1a:	6105                	add	sp,sp,32
    80002e1c:	8082                	ret

0000000080002e1e <sys_trace>:

uint64 sys_trace(void){
    80002e1e:	1101                	add	sp,sp,-32
    80002e20:	ec06                	sd	ra,24(sp)
    80002e22:	e822                	sd	s0,16(sp)
    80002e24:	1000                	add	s0,sp,32
  int n;
  if(argint(0,&n)<0){
    80002e26:	fec40593          	add	a1,s0,-20
    80002e2a:	4501                	li	a0,0
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	cda080e7          	jalr	-806(ra) # 80002b06 <argint>
    return -1;
    80002e34:	57fd                	li	a5,-1
  if(argint(0,&n)<0){
    80002e36:	00054b63          	bltz	a0,80002e4c <sys_trace+0x2e>
  }
  myproc()->mask=n;
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	bd6080e7          	jalr	-1066(ra) # 80001a10 <myproc>
    80002e42:	fec42783          	lw	a5,-20(s0)
    80002e46:	16f52423          	sw	a5,360(a0)
  return 0;
    80002e4a:	4781                	li	a5,0
}
    80002e4c:	853e                	mv	a0,a5
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	6105                	add	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002e56:	7179                	add	sp,sp,-48
    80002e58:	f406                	sd	ra,40(sp)
    80002e5a:	f022                	sd	s0,32(sp)
    80002e5c:	1800                	add	s0,sp,48
  //从用户态读入一个指针，作为存放sysinfo的buffer
  uint64 addr;
  if(argaddr(0,&addr) < 0){
    80002e5e:	fe840593          	add	a1,s0,-24
    80002e62:	4501                	li	a0,0
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	cc4080e7          	jalr	-828(ra) # 80002b28 <argaddr>
    80002e6c:	87aa                	mv	a5,a0
    return -1;
    80002e6e:	557d                	li	a0,-1
  if(argaddr(0,&addr) < 0){
    80002e70:	0207cd63          	bltz	a5,80002eaa <sys_sysinfo+0x54>
  }
  //定义一个sysinfo结构的变量sinfo，记录系统调用的信息
  struct sysinfo sinfo;
  sinfo.freemem = count_free_mem();//计算空闲内存字节数
    80002e74:	ffffe097          	auipc	ra,0xffffe
    80002e78:	cf8080e7          	jalr	-776(ra) # 80000b6c <count_free_mem>
    80002e7c:	fca43c23          	sd	a0,-40(s0)
  sinfo.nproc = count_process();//计算正在运行的线程数
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	762080e7          	jalr	1890(ra) # 800025e2 <count_process>
    80002e88:	fea43023          	sd	a0,-32(s0)

  //就是复制sinfo的内容到用户态传来的地址
  // 使用copyout，结合当前进程的页表，获得进程传进来的指针（逻辑地址）对应的物理地址
  // 然后将 $sinfo 中的数据复制到该指针所指向的位置，供用户进程使用
  if(copyout(myproc()->pagetable, addr, (char*)&sinfo,sizeof(sinfo)) < 0){
    80002e8c:	fffff097          	auipc	ra,0xfffff
    80002e90:	b84080e7          	jalr	-1148(ra) # 80001a10 <myproc>
    80002e94:	46c1                	li	a3,16
    80002e96:	fd840613          	add	a2,s0,-40
    80002e9a:	fe843583          	ld	a1,-24(s0)
    80002e9e:	6928                	ld	a0,80(a0)
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	866080e7          	jalr	-1946(ra) # 80001706 <copyout>
    80002ea8:	957d                	sra	a0,a0,0x3f
    return -1;
  }
  return 0;
}
    80002eaa:	70a2                	ld	ra,40(sp)
    80002eac:	7402                	ld	s0,32(sp)
    80002eae:	6145                	add	sp,sp,48
    80002eb0:	8082                	ret

0000000080002eb2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002eb2:	7179                	add	sp,sp,-48
    80002eb4:	f406                	sd	ra,40(sp)
    80002eb6:	f022                	sd	s0,32(sp)
    80002eb8:	ec26                	sd	s1,24(sp)
    80002eba:	e84a                	sd	s2,16(sp)
    80002ebc:	e44e                	sd	s3,8(sp)
    80002ebe:	e052                	sd	s4,0(sp)
    80002ec0:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ec2:	00005597          	auipc	a1,0x5
    80002ec6:	7ae58593          	add	a1,a1,1966 # 80008670 <syscall_names+0xc0>
    80002eca:	00015517          	auipc	a0,0x15
    80002ece:	ab650513          	add	a0,a0,-1354 # 80017980 <bcache>
    80002ed2:	ffffe097          	auipc	ra,0xffffe
    80002ed6:	ce4080e7          	jalr	-796(ra) # 80000bb6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002eda:	0001d797          	auipc	a5,0x1d
    80002ede:	aa678793          	add	a5,a5,-1370 # 8001f980 <bcache+0x8000>
    80002ee2:	0001d717          	auipc	a4,0x1d
    80002ee6:	d0670713          	add	a4,a4,-762 # 8001fbe8 <bcache+0x8268>
    80002eea:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002eee:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ef2:	00015497          	auipc	s1,0x15
    80002ef6:	aa648493          	add	s1,s1,-1370 # 80017998 <bcache+0x18>
    b->next = bcache.head.next;
    80002efa:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002efc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002efe:	00005a17          	auipc	s4,0x5
    80002f02:	77aa0a13          	add	s4,s4,1914 # 80008678 <syscall_names+0xc8>
    b->next = bcache.head.next;
    80002f06:	2b893783          	ld	a5,696(s2)
    80002f0a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f0c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f10:	85d2                	mv	a1,s4
    80002f12:	01048513          	add	a0,s1,16
    80002f16:	00001097          	auipc	ra,0x1
    80002f1a:	480080e7          	jalr	1152(ra) # 80004396 <initsleeplock>
    bcache.head.next->prev = b;
    80002f1e:	2b893783          	ld	a5,696(s2)
    80002f22:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f24:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f28:	45848493          	add	s1,s1,1112
    80002f2c:	fd349de3          	bne	s1,s3,80002f06 <binit+0x54>
  }
}
    80002f30:	70a2                	ld	ra,40(sp)
    80002f32:	7402                	ld	s0,32(sp)
    80002f34:	64e2                	ld	s1,24(sp)
    80002f36:	6942                	ld	s2,16(sp)
    80002f38:	69a2                	ld	s3,8(sp)
    80002f3a:	6a02                	ld	s4,0(sp)
    80002f3c:	6145                	add	sp,sp,48
    80002f3e:	8082                	ret

0000000080002f40 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f40:	7179                	add	sp,sp,-48
    80002f42:	f406                	sd	ra,40(sp)
    80002f44:	f022                	sd	s0,32(sp)
    80002f46:	ec26                	sd	s1,24(sp)
    80002f48:	e84a                	sd	s2,16(sp)
    80002f4a:	e44e                	sd	s3,8(sp)
    80002f4c:	1800                	add	s0,sp,48
    80002f4e:	892a                	mv	s2,a0
    80002f50:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f52:	00015517          	auipc	a0,0x15
    80002f56:	a2e50513          	add	a0,a0,-1490 # 80017980 <bcache>
    80002f5a:	ffffe097          	auipc	ra,0xffffe
    80002f5e:	cec080e7          	jalr	-788(ra) # 80000c46 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f62:	0001d497          	auipc	s1,0x1d
    80002f66:	cd64b483          	ld	s1,-810(s1) # 8001fc38 <bcache+0x82b8>
    80002f6a:	0001d797          	auipc	a5,0x1d
    80002f6e:	c7e78793          	add	a5,a5,-898 # 8001fbe8 <bcache+0x8268>
    80002f72:	02f48f63          	beq	s1,a5,80002fb0 <bread+0x70>
    80002f76:	873e                	mv	a4,a5
    80002f78:	a021                	j	80002f80 <bread+0x40>
    80002f7a:	68a4                	ld	s1,80(s1)
    80002f7c:	02e48a63          	beq	s1,a4,80002fb0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f80:	449c                	lw	a5,8(s1)
    80002f82:	ff279ce3          	bne	a5,s2,80002f7a <bread+0x3a>
    80002f86:	44dc                	lw	a5,12(s1)
    80002f88:	ff3799e3          	bne	a5,s3,80002f7a <bread+0x3a>
      b->refcnt++;
    80002f8c:	40bc                	lw	a5,64(s1)
    80002f8e:	2785                	addw	a5,a5,1
    80002f90:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f92:	00015517          	auipc	a0,0x15
    80002f96:	9ee50513          	add	a0,a0,-1554 # 80017980 <bcache>
    80002f9a:	ffffe097          	auipc	ra,0xffffe
    80002f9e:	d60080e7          	jalr	-672(ra) # 80000cfa <release>
      acquiresleep(&b->lock);
    80002fa2:	01048513          	add	a0,s1,16
    80002fa6:	00001097          	auipc	ra,0x1
    80002faa:	42a080e7          	jalr	1066(ra) # 800043d0 <acquiresleep>
      return b;
    80002fae:	a8b9                	j	8000300c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fb0:	0001d497          	auipc	s1,0x1d
    80002fb4:	c804b483          	ld	s1,-896(s1) # 8001fc30 <bcache+0x82b0>
    80002fb8:	0001d797          	auipc	a5,0x1d
    80002fbc:	c3078793          	add	a5,a5,-976 # 8001fbe8 <bcache+0x8268>
    80002fc0:	00f48863          	beq	s1,a5,80002fd0 <bread+0x90>
    80002fc4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fc6:	40bc                	lw	a5,64(s1)
    80002fc8:	cf81                	beqz	a5,80002fe0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fca:	64a4                	ld	s1,72(s1)
    80002fcc:	fee49de3          	bne	s1,a4,80002fc6 <bread+0x86>
  panic("bget: no buffers");
    80002fd0:	00005517          	auipc	a0,0x5
    80002fd4:	6b050513          	add	a0,a0,1712 # 80008680 <syscall_names+0xd0>
    80002fd8:	ffffd097          	auipc	ra,0xffffd
    80002fdc:	56a080e7          	jalr	1386(ra) # 80000542 <panic>
      b->dev = dev;
    80002fe0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fe4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fe8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fec:	4785                	li	a5,1
    80002fee:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ff0:	00015517          	auipc	a0,0x15
    80002ff4:	99050513          	add	a0,a0,-1648 # 80017980 <bcache>
    80002ff8:	ffffe097          	auipc	ra,0xffffe
    80002ffc:	d02080e7          	jalr	-766(ra) # 80000cfa <release>
      acquiresleep(&b->lock);
    80003000:	01048513          	add	a0,s1,16
    80003004:	00001097          	auipc	ra,0x1
    80003008:	3cc080e7          	jalr	972(ra) # 800043d0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000300c:	409c                	lw	a5,0(s1)
    8000300e:	cb89                	beqz	a5,80003020 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003010:	8526                	mv	a0,s1
    80003012:	70a2                	ld	ra,40(sp)
    80003014:	7402                	ld	s0,32(sp)
    80003016:	64e2                	ld	s1,24(sp)
    80003018:	6942                	ld	s2,16(sp)
    8000301a:	69a2                	ld	s3,8(sp)
    8000301c:	6145                	add	sp,sp,48
    8000301e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003020:	4581                	li	a1,0
    80003022:	8526                	mv	a0,s1
    80003024:	00003097          	auipc	ra,0x3
    80003028:	ed4080e7          	jalr	-300(ra) # 80005ef8 <virtio_disk_rw>
    b->valid = 1;
    8000302c:	4785                	li	a5,1
    8000302e:	c09c                	sw	a5,0(s1)
  return b;
    80003030:	b7c5                	j	80003010 <bread+0xd0>

0000000080003032 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003032:	1101                	add	sp,sp,-32
    80003034:	ec06                	sd	ra,24(sp)
    80003036:	e822                	sd	s0,16(sp)
    80003038:	e426                	sd	s1,8(sp)
    8000303a:	1000                	add	s0,sp,32
    8000303c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000303e:	0541                	add	a0,a0,16
    80003040:	00001097          	auipc	ra,0x1
    80003044:	42a080e7          	jalr	1066(ra) # 8000446a <holdingsleep>
    80003048:	cd01                	beqz	a0,80003060 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000304a:	4585                	li	a1,1
    8000304c:	8526                	mv	a0,s1
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	eaa080e7          	jalr	-342(ra) # 80005ef8 <virtio_disk_rw>
}
    80003056:	60e2                	ld	ra,24(sp)
    80003058:	6442                	ld	s0,16(sp)
    8000305a:	64a2                	ld	s1,8(sp)
    8000305c:	6105                	add	sp,sp,32
    8000305e:	8082                	ret
    panic("bwrite");
    80003060:	00005517          	auipc	a0,0x5
    80003064:	63850513          	add	a0,a0,1592 # 80008698 <syscall_names+0xe8>
    80003068:	ffffd097          	auipc	ra,0xffffd
    8000306c:	4da080e7          	jalr	1242(ra) # 80000542 <panic>

0000000080003070 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003070:	1101                	add	sp,sp,-32
    80003072:	ec06                	sd	ra,24(sp)
    80003074:	e822                	sd	s0,16(sp)
    80003076:	e426                	sd	s1,8(sp)
    80003078:	e04a                	sd	s2,0(sp)
    8000307a:	1000                	add	s0,sp,32
    8000307c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000307e:	01050913          	add	s2,a0,16
    80003082:	854a                	mv	a0,s2
    80003084:	00001097          	auipc	ra,0x1
    80003088:	3e6080e7          	jalr	998(ra) # 8000446a <holdingsleep>
    8000308c:	c925                	beqz	a0,800030fc <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000308e:	854a                	mv	a0,s2
    80003090:	00001097          	auipc	ra,0x1
    80003094:	396080e7          	jalr	918(ra) # 80004426 <releasesleep>

  acquire(&bcache.lock);
    80003098:	00015517          	auipc	a0,0x15
    8000309c:	8e850513          	add	a0,a0,-1816 # 80017980 <bcache>
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	ba6080e7          	jalr	-1114(ra) # 80000c46 <acquire>
  b->refcnt--;
    800030a8:	40bc                	lw	a5,64(s1)
    800030aa:	37fd                	addw	a5,a5,-1
    800030ac:	0007871b          	sext.w	a4,a5
    800030b0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030b2:	e71d                	bnez	a4,800030e0 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030b4:	68b8                	ld	a4,80(s1)
    800030b6:	64bc                	ld	a5,72(s1)
    800030b8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800030ba:	68b8                	ld	a4,80(s1)
    800030bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030be:	0001d797          	auipc	a5,0x1d
    800030c2:	8c278793          	add	a5,a5,-1854 # 8001f980 <bcache+0x8000>
    800030c6:	2b87b703          	ld	a4,696(a5)
    800030ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030cc:	0001d717          	auipc	a4,0x1d
    800030d0:	b1c70713          	add	a4,a4,-1252 # 8001fbe8 <bcache+0x8268>
    800030d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030d6:	2b87b703          	ld	a4,696(a5)
    800030da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030e0:	00015517          	auipc	a0,0x15
    800030e4:	8a050513          	add	a0,a0,-1888 # 80017980 <bcache>
    800030e8:	ffffe097          	auipc	ra,0xffffe
    800030ec:	c12080e7          	jalr	-1006(ra) # 80000cfa <release>
}
    800030f0:	60e2                	ld	ra,24(sp)
    800030f2:	6442                	ld	s0,16(sp)
    800030f4:	64a2                	ld	s1,8(sp)
    800030f6:	6902                	ld	s2,0(sp)
    800030f8:	6105                	add	sp,sp,32
    800030fa:	8082                	ret
    panic("brelse");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	5a450513          	add	a0,a0,1444 # 800086a0 <syscall_names+0xf0>
    80003104:	ffffd097          	auipc	ra,0xffffd
    80003108:	43e080e7          	jalr	1086(ra) # 80000542 <panic>

000000008000310c <bpin>:

void
bpin(struct buf *b) {
    8000310c:	1101                	add	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	1000                	add	s0,sp,32
    80003116:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003118:	00015517          	auipc	a0,0x15
    8000311c:	86850513          	add	a0,a0,-1944 # 80017980 <bcache>
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	b26080e7          	jalr	-1242(ra) # 80000c46 <acquire>
  b->refcnt++;
    80003128:	40bc                	lw	a5,64(s1)
    8000312a:	2785                	addw	a5,a5,1
    8000312c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000312e:	00015517          	auipc	a0,0x15
    80003132:	85250513          	add	a0,a0,-1966 # 80017980 <bcache>
    80003136:	ffffe097          	auipc	ra,0xffffe
    8000313a:	bc4080e7          	jalr	-1084(ra) # 80000cfa <release>
}
    8000313e:	60e2                	ld	ra,24(sp)
    80003140:	6442                	ld	s0,16(sp)
    80003142:	64a2                	ld	s1,8(sp)
    80003144:	6105                	add	sp,sp,32
    80003146:	8082                	ret

0000000080003148 <bunpin>:

void
bunpin(struct buf *b) {
    80003148:	1101                	add	sp,sp,-32
    8000314a:	ec06                	sd	ra,24(sp)
    8000314c:	e822                	sd	s0,16(sp)
    8000314e:	e426                	sd	s1,8(sp)
    80003150:	1000                	add	s0,sp,32
    80003152:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003154:	00015517          	auipc	a0,0x15
    80003158:	82c50513          	add	a0,a0,-2004 # 80017980 <bcache>
    8000315c:	ffffe097          	auipc	ra,0xffffe
    80003160:	aea080e7          	jalr	-1302(ra) # 80000c46 <acquire>
  b->refcnt--;
    80003164:	40bc                	lw	a5,64(s1)
    80003166:	37fd                	addw	a5,a5,-1
    80003168:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000316a:	00015517          	auipc	a0,0x15
    8000316e:	81650513          	add	a0,a0,-2026 # 80017980 <bcache>
    80003172:	ffffe097          	auipc	ra,0xffffe
    80003176:	b88080e7          	jalr	-1144(ra) # 80000cfa <release>
}
    8000317a:	60e2                	ld	ra,24(sp)
    8000317c:	6442                	ld	s0,16(sp)
    8000317e:	64a2                	ld	s1,8(sp)
    80003180:	6105                	add	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003184:	1101                	add	sp,sp,-32
    80003186:	ec06                	sd	ra,24(sp)
    80003188:	e822                	sd	s0,16(sp)
    8000318a:	e426                	sd	s1,8(sp)
    8000318c:	e04a                	sd	s2,0(sp)
    8000318e:	1000                	add	s0,sp,32
    80003190:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003192:	00d5d59b          	srlw	a1,a1,0xd
    80003196:	0001d797          	auipc	a5,0x1d
    8000319a:	ec67a783          	lw	a5,-314(a5) # 8002005c <sb+0x1c>
    8000319e:	9dbd                	addw	a1,a1,a5
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	da0080e7          	jalr	-608(ra) # 80002f40 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031a8:	0074f713          	and	a4,s1,7
    800031ac:	4785                	li	a5,1
    800031ae:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031b2:	14ce                	sll	s1,s1,0x33
    800031b4:	90d9                	srl	s1,s1,0x36
    800031b6:	00950733          	add	a4,a0,s1
    800031ba:	05874703          	lbu	a4,88(a4)
    800031be:	00e7f6b3          	and	a3,a5,a4
    800031c2:	c69d                	beqz	a3,800031f0 <bfree+0x6c>
    800031c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031c6:	94aa                	add	s1,s1,a0
    800031c8:	fff7c793          	not	a5,a5
    800031cc:	8f7d                	and	a4,a4,a5
    800031ce:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800031d2:	00001097          	auipc	ra,0x1
    800031d6:	0d8080e7          	jalr	216(ra) # 800042aa <log_write>
  brelse(bp);
    800031da:	854a                	mv	a0,s2
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	e94080e7          	jalr	-364(ra) # 80003070 <brelse>
}
    800031e4:	60e2                	ld	ra,24(sp)
    800031e6:	6442                	ld	s0,16(sp)
    800031e8:	64a2                	ld	s1,8(sp)
    800031ea:	6902                	ld	s2,0(sp)
    800031ec:	6105                	add	sp,sp,32
    800031ee:	8082                	ret
    panic("freeing free block");
    800031f0:	00005517          	auipc	a0,0x5
    800031f4:	4b850513          	add	a0,a0,1208 # 800086a8 <syscall_names+0xf8>
    800031f8:	ffffd097          	auipc	ra,0xffffd
    800031fc:	34a080e7          	jalr	842(ra) # 80000542 <panic>

0000000080003200 <balloc>:
{
    80003200:	711d                	add	sp,sp,-96
    80003202:	ec86                	sd	ra,88(sp)
    80003204:	e8a2                	sd	s0,80(sp)
    80003206:	e4a6                	sd	s1,72(sp)
    80003208:	e0ca                	sd	s2,64(sp)
    8000320a:	fc4e                	sd	s3,56(sp)
    8000320c:	f852                	sd	s4,48(sp)
    8000320e:	f456                	sd	s5,40(sp)
    80003210:	f05a                	sd	s6,32(sp)
    80003212:	ec5e                	sd	s7,24(sp)
    80003214:	e862                	sd	s8,16(sp)
    80003216:	e466                	sd	s9,8(sp)
    80003218:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000321a:	0001d797          	auipc	a5,0x1d
    8000321e:	e2a7a783          	lw	a5,-470(a5) # 80020044 <sb+0x4>
    80003222:	cbc1                	beqz	a5,800032b2 <balloc+0xb2>
    80003224:	8baa                	mv	s7,a0
    80003226:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003228:	0001db17          	auipc	s6,0x1d
    8000322c:	e18b0b13          	add	s6,s6,-488 # 80020040 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003230:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003232:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003234:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003236:	6c89                	lui	s9,0x2
    80003238:	a831                	j	80003254 <balloc+0x54>
    brelse(bp);
    8000323a:	854a                	mv	a0,s2
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	e34080e7          	jalr	-460(ra) # 80003070 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003244:	015c87bb          	addw	a5,s9,s5
    80003248:	00078a9b          	sext.w	s5,a5
    8000324c:	004b2703          	lw	a4,4(s6)
    80003250:	06eaf163          	bgeu	s5,a4,800032b2 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80003254:	41fad79b          	sraw	a5,s5,0x1f
    80003258:	0137d79b          	srlw	a5,a5,0x13
    8000325c:	015787bb          	addw	a5,a5,s5
    80003260:	40d7d79b          	sraw	a5,a5,0xd
    80003264:	01cb2583          	lw	a1,28(s6)
    80003268:	9dbd                	addw	a1,a1,a5
    8000326a:	855e                	mv	a0,s7
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	cd4080e7          	jalr	-812(ra) # 80002f40 <bread>
    80003274:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003276:	004b2503          	lw	a0,4(s6)
    8000327a:	000a849b          	sext.w	s1,s5
    8000327e:	8762                	mv	a4,s8
    80003280:	faa4fde3          	bgeu	s1,a0,8000323a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003284:	00777693          	and	a3,a4,7
    80003288:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000328c:	41f7579b          	sraw	a5,a4,0x1f
    80003290:	01d7d79b          	srlw	a5,a5,0x1d
    80003294:	9fb9                	addw	a5,a5,a4
    80003296:	4037d79b          	sraw	a5,a5,0x3
    8000329a:	00f90633          	add	a2,s2,a5
    8000329e:	05864603          	lbu	a2,88(a2)
    800032a2:	00c6f5b3          	and	a1,a3,a2
    800032a6:	cd91                	beqz	a1,800032c2 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032a8:	2705                	addw	a4,a4,1
    800032aa:	2485                	addw	s1,s1,1
    800032ac:	fd471ae3          	bne	a4,s4,80003280 <balloc+0x80>
    800032b0:	b769                	j	8000323a <balloc+0x3a>
  panic("balloc: out of blocks");
    800032b2:	00005517          	auipc	a0,0x5
    800032b6:	40e50513          	add	a0,a0,1038 # 800086c0 <syscall_names+0x110>
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	288080e7          	jalr	648(ra) # 80000542 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032c2:	97ca                	add	a5,a5,s2
    800032c4:	8e55                	or	a2,a2,a3
    800032c6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800032ca:	854a                	mv	a0,s2
    800032cc:	00001097          	auipc	ra,0x1
    800032d0:	fde080e7          	jalr	-34(ra) # 800042aa <log_write>
        brelse(bp);
    800032d4:	854a                	mv	a0,s2
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	d9a080e7          	jalr	-614(ra) # 80003070 <brelse>
  bp = bread(dev, bno);
    800032de:	85a6                	mv	a1,s1
    800032e0:	855e                	mv	a0,s7
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	c5e080e7          	jalr	-930(ra) # 80002f40 <bread>
    800032ea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032ec:	40000613          	li	a2,1024
    800032f0:	4581                	li	a1,0
    800032f2:	05850513          	add	a0,a0,88
    800032f6:	ffffe097          	auipc	ra,0xffffe
    800032fa:	a4c080e7          	jalr	-1460(ra) # 80000d42 <memset>
  log_write(bp);
    800032fe:	854a                	mv	a0,s2
    80003300:	00001097          	auipc	ra,0x1
    80003304:	faa080e7          	jalr	-86(ra) # 800042aa <log_write>
  brelse(bp);
    80003308:	854a                	mv	a0,s2
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	d66080e7          	jalr	-666(ra) # 80003070 <brelse>
}
    80003312:	8526                	mv	a0,s1
    80003314:	60e6                	ld	ra,88(sp)
    80003316:	6446                	ld	s0,80(sp)
    80003318:	64a6                	ld	s1,72(sp)
    8000331a:	6906                	ld	s2,64(sp)
    8000331c:	79e2                	ld	s3,56(sp)
    8000331e:	7a42                	ld	s4,48(sp)
    80003320:	7aa2                	ld	s5,40(sp)
    80003322:	7b02                	ld	s6,32(sp)
    80003324:	6be2                	ld	s7,24(sp)
    80003326:	6c42                	ld	s8,16(sp)
    80003328:	6ca2                	ld	s9,8(sp)
    8000332a:	6125                	add	sp,sp,96
    8000332c:	8082                	ret

000000008000332e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000332e:	7179                	add	sp,sp,-48
    80003330:	f406                	sd	ra,40(sp)
    80003332:	f022                	sd	s0,32(sp)
    80003334:	ec26                	sd	s1,24(sp)
    80003336:	e84a                	sd	s2,16(sp)
    80003338:	e44e                	sd	s3,8(sp)
    8000333a:	e052                	sd	s4,0(sp)
    8000333c:	1800                	add	s0,sp,48
    8000333e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003340:	47ad                	li	a5,11
    80003342:	04b7fe63          	bgeu	a5,a1,8000339e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003346:	ff45849b          	addw	s1,a1,-12
    8000334a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000334e:	0ff00793          	li	a5,255
    80003352:	0ae7e463          	bltu	a5,a4,800033fa <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003356:	08052583          	lw	a1,128(a0)
    8000335a:	c5b5                	beqz	a1,800033c6 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000335c:	00092503          	lw	a0,0(s2)
    80003360:	00000097          	auipc	ra,0x0
    80003364:	be0080e7          	jalr	-1056(ra) # 80002f40 <bread>
    80003368:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000336a:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000336e:	02049713          	sll	a4,s1,0x20
    80003372:	01e75593          	srl	a1,a4,0x1e
    80003376:	00b784b3          	add	s1,a5,a1
    8000337a:	0004a983          	lw	s3,0(s1)
    8000337e:	04098e63          	beqz	s3,800033da <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003382:	8552                	mv	a0,s4
    80003384:	00000097          	auipc	ra,0x0
    80003388:	cec080e7          	jalr	-788(ra) # 80003070 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000338c:	854e                	mv	a0,s3
    8000338e:	70a2                	ld	ra,40(sp)
    80003390:	7402                	ld	s0,32(sp)
    80003392:	64e2                	ld	s1,24(sp)
    80003394:	6942                	ld	s2,16(sp)
    80003396:	69a2                	ld	s3,8(sp)
    80003398:	6a02                	ld	s4,0(sp)
    8000339a:	6145                	add	sp,sp,48
    8000339c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000339e:	02059793          	sll	a5,a1,0x20
    800033a2:	01e7d593          	srl	a1,a5,0x1e
    800033a6:	00b504b3          	add	s1,a0,a1
    800033aa:	0504a983          	lw	s3,80(s1)
    800033ae:	fc099fe3          	bnez	s3,8000338c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800033b2:	4108                	lw	a0,0(a0)
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	e4c080e7          	jalr	-436(ra) # 80003200 <balloc>
    800033bc:	0005099b          	sext.w	s3,a0
    800033c0:	0534a823          	sw	s3,80(s1)
    800033c4:	b7e1                	j	8000338c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800033c6:	4108                	lw	a0,0(a0)
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	e38080e7          	jalr	-456(ra) # 80003200 <balloc>
    800033d0:	0005059b          	sext.w	a1,a0
    800033d4:	08b92023          	sw	a1,128(s2)
    800033d8:	b751                	j	8000335c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800033da:	00092503          	lw	a0,0(s2)
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	e22080e7          	jalr	-478(ra) # 80003200 <balloc>
    800033e6:	0005099b          	sext.w	s3,a0
    800033ea:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033ee:	8552                	mv	a0,s4
    800033f0:	00001097          	auipc	ra,0x1
    800033f4:	eba080e7          	jalr	-326(ra) # 800042aa <log_write>
    800033f8:	b769                	j	80003382 <bmap+0x54>
  panic("bmap: out of range");
    800033fa:	00005517          	auipc	a0,0x5
    800033fe:	2de50513          	add	a0,a0,734 # 800086d8 <syscall_names+0x128>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	140080e7          	jalr	320(ra) # 80000542 <panic>

000000008000340a <iget>:
{
    8000340a:	7179                	add	sp,sp,-48
    8000340c:	f406                	sd	ra,40(sp)
    8000340e:	f022                	sd	s0,32(sp)
    80003410:	ec26                	sd	s1,24(sp)
    80003412:	e84a                	sd	s2,16(sp)
    80003414:	e44e                	sd	s3,8(sp)
    80003416:	e052                	sd	s4,0(sp)
    80003418:	1800                	add	s0,sp,48
    8000341a:	89aa                	mv	s3,a0
    8000341c:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000341e:	0001d517          	auipc	a0,0x1d
    80003422:	c4250513          	add	a0,a0,-958 # 80020060 <icache>
    80003426:	ffffe097          	auipc	ra,0xffffe
    8000342a:	820080e7          	jalr	-2016(ra) # 80000c46 <acquire>
  empty = 0;
    8000342e:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003430:	0001d497          	auipc	s1,0x1d
    80003434:	c4848493          	add	s1,s1,-952 # 80020078 <icache+0x18>
    80003438:	0001e697          	auipc	a3,0x1e
    8000343c:	6d068693          	add	a3,a3,1744 # 80021b08 <log>
    80003440:	a039                	j	8000344e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003442:	02090b63          	beqz	s2,80003478 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003446:	08848493          	add	s1,s1,136
    8000344a:	02d48a63          	beq	s1,a3,8000347e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000344e:	449c                	lw	a5,8(s1)
    80003450:	fef059e3          	blez	a5,80003442 <iget+0x38>
    80003454:	4098                	lw	a4,0(s1)
    80003456:	ff3716e3          	bne	a4,s3,80003442 <iget+0x38>
    8000345a:	40d8                	lw	a4,4(s1)
    8000345c:	ff4713e3          	bne	a4,s4,80003442 <iget+0x38>
      ip->ref++;
    80003460:	2785                	addw	a5,a5,1
    80003462:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003464:	0001d517          	auipc	a0,0x1d
    80003468:	bfc50513          	add	a0,a0,-1028 # 80020060 <icache>
    8000346c:	ffffe097          	auipc	ra,0xffffe
    80003470:	88e080e7          	jalr	-1906(ra) # 80000cfa <release>
      return ip;
    80003474:	8926                	mv	s2,s1
    80003476:	a03d                	j	800034a4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003478:	f7f9                	bnez	a5,80003446 <iget+0x3c>
    8000347a:	8926                	mv	s2,s1
    8000347c:	b7e9                	j	80003446 <iget+0x3c>
  if(empty == 0)
    8000347e:	02090c63          	beqz	s2,800034b6 <iget+0xac>
  ip->dev = dev;
    80003482:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003486:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000348a:	4785                	li	a5,1
    8000348c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003490:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003494:	0001d517          	auipc	a0,0x1d
    80003498:	bcc50513          	add	a0,a0,-1076 # 80020060 <icache>
    8000349c:	ffffe097          	auipc	ra,0xffffe
    800034a0:	85e080e7          	jalr	-1954(ra) # 80000cfa <release>
}
    800034a4:	854a                	mv	a0,s2
    800034a6:	70a2                	ld	ra,40(sp)
    800034a8:	7402                	ld	s0,32(sp)
    800034aa:	64e2                	ld	s1,24(sp)
    800034ac:	6942                	ld	s2,16(sp)
    800034ae:	69a2                	ld	s3,8(sp)
    800034b0:	6a02                	ld	s4,0(sp)
    800034b2:	6145                	add	sp,sp,48
    800034b4:	8082                	ret
    panic("iget: no inodes");
    800034b6:	00005517          	auipc	a0,0x5
    800034ba:	23a50513          	add	a0,a0,570 # 800086f0 <syscall_names+0x140>
    800034be:	ffffd097          	auipc	ra,0xffffd
    800034c2:	084080e7          	jalr	132(ra) # 80000542 <panic>

00000000800034c6 <fsinit>:
fsinit(int dev) {
    800034c6:	7179                	add	sp,sp,-48
    800034c8:	f406                	sd	ra,40(sp)
    800034ca:	f022                	sd	s0,32(sp)
    800034cc:	ec26                	sd	s1,24(sp)
    800034ce:	e84a                	sd	s2,16(sp)
    800034d0:	e44e                	sd	s3,8(sp)
    800034d2:	1800                	add	s0,sp,48
    800034d4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034d6:	4585                	li	a1,1
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	a68080e7          	jalr	-1432(ra) # 80002f40 <bread>
    800034e0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034e2:	0001d997          	auipc	s3,0x1d
    800034e6:	b5e98993          	add	s3,s3,-1186 # 80020040 <sb>
    800034ea:	02000613          	li	a2,32
    800034ee:	05850593          	add	a1,a0,88
    800034f2:	854e                	mv	a0,s3
    800034f4:	ffffe097          	auipc	ra,0xffffe
    800034f8:	8aa080e7          	jalr	-1878(ra) # 80000d9e <memmove>
  brelse(bp);
    800034fc:	8526                	mv	a0,s1
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	b72080e7          	jalr	-1166(ra) # 80003070 <brelse>
  if(sb.magic != FSMAGIC)
    80003506:	0009a703          	lw	a4,0(s3)
    8000350a:	102037b7          	lui	a5,0x10203
    8000350e:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003512:	02f71263          	bne	a4,a5,80003536 <fsinit+0x70>
  initlog(dev, &sb);
    80003516:	0001d597          	auipc	a1,0x1d
    8000351a:	b2a58593          	add	a1,a1,-1238 # 80020040 <sb>
    8000351e:	854a                	mv	a0,s2
    80003520:	00001097          	auipc	ra,0x1
    80003524:	b24080e7          	jalr	-1244(ra) # 80004044 <initlog>
}
    80003528:	70a2                	ld	ra,40(sp)
    8000352a:	7402                	ld	s0,32(sp)
    8000352c:	64e2                	ld	s1,24(sp)
    8000352e:	6942                	ld	s2,16(sp)
    80003530:	69a2                	ld	s3,8(sp)
    80003532:	6145                	add	sp,sp,48
    80003534:	8082                	ret
    panic("invalid file system");
    80003536:	00005517          	auipc	a0,0x5
    8000353a:	1ca50513          	add	a0,a0,458 # 80008700 <syscall_names+0x150>
    8000353e:	ffffd097          	auipc	ra,0xffffd
    80003542:	004080e7          	jalr	4(ra) # 80000542 <panic>

0000000080003546 <iinit>:
{
    80003546:	7179                	add	sp,sp,-48
    80003548:	f406                	sd	ra,40(sp)
    8000354a:	f022                	sd	s0,32(sp)
    8000354c:	ec26                	sd	s1,24(sp)
    8000354e:	e84a                	sd	s2,16(sp)
    80003550:	e44e                	sd	s3,8(sp)
    80003552:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    80003554:	00005597          	auipc	a1,0x5
    80003558:	1c458593          	add	a1,a1,452 # 80008718 <syscall_names+0x168>
    8000355c:	0001d517          	auipc	a0,0x1d
    80003560:	b0450513          	add	a0,a0,-1276 # 80020060 <icache>
    80003564:	ffffd097          	auipc	ra,0xffffd
    80003568:	652080e7          	jalr	1618(ra) # 80000bb6 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000356c:	0001d497          	auipc	s1,0x1d
    80003570:	b1c48493          	add	s1,s1,-1252 # 80020088 <icache+0x28>
    80003574:	0001e997          	auipc	s3,0x1e
    80003578:	5a498993          	add	s3,s3,1444 # 80021b18 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000357c:	00005917          	auipc	s2,0x5
    80003580:	1a490913          	add	s2,s2,420 # 80008720 <syscall_names+0x170>
    80003584:	85ca                	mv	a1,s2
    80003586:	8526                	mv	a0,s1
    80003588:	00001097          	auipc	ra,0x1
    8000358c:	e0e080e7          	jalr	-498(ra) # 80004396 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003590:	08848493          	add	s1,s1,136
    80003594:	ff3498e3          	bne	s1,s3,80003584 <iinit+0x3e>
}
    80003598:	70a2                	ld	ra,40(sp)
    8000359a:	7402                	ld	s0,32(sp)
    8000359c:	64e2                	ld	s1,24(sp)
    8000359e:	6942                	ld	s2,16(sp)
    800035a0:	69a2                	ld	s3,8(sp)
    800035a2:	6145                	add	sp,sp,48
    800035a4:	8082                	ret

00000000800035a6 <ialloc>:
{
    800035a6:	7139                	add	sp,sp,-64
    800035a8:	fc06                	sd	ra,56(sp)
    800035aa:	f822                	sd	s0,48(sp)
    800035ac:	f426                	sd	s1,40(sp)
    800035ae:	f04a                	sd	s2,32(sp)
    800035b0:	ec4e                	sd	s3,24(sp)
    800035b2:	e852                	sd	s4,16(sp)
    800035b4:	e456                	sd	s5,8(sp)
    800035b6:	e05a                	sd	s6,0(sp)
    800035b8:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ba:	0001d717          	auipc	a4,0x1d
    800035be:	a9272703          	lw	a4,-1390(a4) # 8002004c <sb+0xc>
    800035c2:	4785                	li	a5,1
    800035c4:	04e7f863          	bgeu	a5,a4,80003614 <ialloc+0x6e>
    800035c8:	8aaa                	mv	s5,a0
    800035ca:	8b2e                	mv	s6,a1
    800035cc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035ce:	0001da17          	auipc	s4,0x1d
    800035d2:	a72a0a13          	add	s4,s4,-1422 # 80020040 <sb>
    800035d6:	00495593          	srl	a1,s2,0x4
    800035da:	018a2783          	lw	a5,24(s4)
    800035de:	9dbd                	addw	a1,a1,a5
    800035e0:	8556                	mv	a0,s5
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	95e080e7          	jalr	-1698(ra) # 80002f40 <bread>
    800035ea:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035ec:	05850993          	add	s3,a0,88
    800035f0:	00f97793          	and	a5,s2,15
    800035f4:	079a                	sll	a5,a5,0x6
    800035f6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035f8:	00099783          	lh	a5,0(s3)
    800035fc:	c785                	beqz	a5,80003624 <ialloc+0x7e>
    brelse(bp);
    800035fe:	00000097          	auipc	ra,0x0
    80003602:	a72080e7          	jalr	-1422(ra) # 80003070 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003606:	0905                	add	s2,s2,1
    80003608:	00ca2703          	lw	a4,12(s4)
    8000360c:	0009079b          	sext.w	a5,s2
    80003610:	fce7e3e3          	bltu	a5,a4,800035d6 <ialloc+0x30>
  panic("ialloc: no inodes");
    80003614:	00005517          	auipc	a0,0x5
    80003618:	11450513          	add	a0,a0,276 # 80008728 <syscall_names+0x178>
    8000361c:	ffffd097          	auipc	ra,0xffffd
    80003620:	f26080e7          	jalr	-218(ra) # 80000542 <panic>
      memset(dip, 0, sizeof(*dip));
    80003624:	04000613          	li	a2,64
    80003628:	4581                	li	a1,0
    8000362a:	854e                	mv	a0,s3
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	716080e7          	jalr	1814(ra) # 80000d42 <memset>
      dip->type = type;
    80003634:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003638:	8526                	mv	a0,s1
    8000363a:	00001097          	auipc	ra,0x1
    8000363e:	c70080e7          	jalr	-912(ra) # 800042aa <log_write>
      brelse(bp);
    80003642:	8526                	mv	a0,s1
    80003644:	00000097          	auipc	ra,0x0
    80003648:	a2c080e7          	jalr	-1492(ra) # 80003070 <brelse>
      return iget(dev, inum);
    8000364c:	0009059b          	sext.w	a1,s2
    80003650:	8556                	mv	a0,s5
    80003652:	00000097          	auipc	ra,0x0
    80003656:	db8080e7          	jalr	-584(ra) # 8000340a <iget>
}
    8000365a:	70e2                	ld	ra,56(sp)
    8000365c:	7442                	ld	s0,48(sp)
    8000365e:	74a2                	ld	s1,40(sp)
    80003660:	7902                	ld	s2,32(sp)
    80003662:	69e2                	ld	s3,24(sp)
    80003664:	6a42                	ld	s4,16(sp)
    80003666:	6aa2                	ld	s5,8(sp)
    80003668:	6b02                	ld	s6,0(sp)
    8000366a:	6121                	add	sp,sp,64
    8000366c:	8082                	ret

000000008000366e <iupdate>:
{
    8000366e:	1101                	add	sp,sp,-32
    80003670:	ec06                	sd	ra,24(sp)
    80003672:	e822                	sd	s0,16(sp)
    80003674:	e426                	sd	s1,8(sp)
    80003676:	e04a                	sd	s2,0(sp)
    80003678:	1000                	add	s0,sp,32
    8000367a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000367c:	415c                	lw	a5,4(a0)
    8000367e:	0047d79b          	srlw	a5,a5,0x4
    80003682:	0001d597          	auipc	a1,0x1d
    80003686:	9d65a583          	lw	a1,-1578(a1) # 80020058 <sb+0x18>
    8000368a:	9dbd                	addw	a1,a1,a5
    8000368c:	4108                	lw	a0,0(a0)
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	8b2080e7          	jalr	-1870(ra) # 80002f40 <bread>
    80003696:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003698:	05850793          	add	a5,a0,88
    8000369c:	40d8                	lw	a4,4(s1)
    8000369e:	8b3d                	and	a4,a4,15
    800036a0:	071a                	sll	a4,a4,0x6
    800036a2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800036a4:	04449703          	lh	a4,68(s1)
    800036a8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800036ac:	04649703          	lh	a4,70(s1)
    800036b0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800036b4:	04849703          	lh	a4,72(s1)
    800036b8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800036bc:	04a49703          	lh	a4,74(s1)
    800036c0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800036c4:	44f8                	lw	a4,76(s1)
    800036c6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036c8:	03400613          	li	a2,52
    800036cc:	05048593          	add	a1,s1,80
    800036d0:	00c78513          	add	a0,a5,12
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	6ca080e7          	jalr	1738(ra) # 80000d9e <memmove>
  log_write(bp);
    800036dc:	854a                	mv	a0,s2
    800036de:	00001097          	auipc	ra,0x1
    800036e2:	bcc080e7          	jalr	-1076(ra) # 800042aa <log_write>
  brelse(bp);
    800036e6:	854a                	mv	a0,s2
    800036e8:	00000097          	auipc	ra,0x0
    800036ec:	988080e7          	jalr	-1656(ra) # 80003070 <brelse>
}
    800036f0:	60e2                	ld	ra,24(sp)
    800036f2:	6442                	ld	s0,16(sp)
    800036f4:	64a2                	ld	s1,8(sp)
    800036f6:	6902                	ld	s2,0(sp)
    800036f8:	6105                	add	sp,sp,32
    800036fa:	8082                	ret

00000000800036fc <idup>:
{
    800036fc:	1101                	add	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	1000                	add	s0,sp,32
    80003706:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003708:	0001d517          	auipc	a0,0x1d
    8000370c:	95850513          	add	a0,a0,-1704 # 80020060 <icache>
    80003710:	ffffd097          	auipc	ra,0xffffd
    80003714:	536080e7          	jalr	1334(ra) # 80000c46 <acquire>
  ip->ref++;
    80003718:	449c                	lw	a5,8(s1)
    8000371a:	2785                	addw	a5,a5,1
    8000371c:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000371e:	0001d517          	auipc	a0,0x1d
    80003722:	94250513          	add	a0,a0,-1726 # 80020060 <icache>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	5d4080e7          	jalr	1492(ra) # 80000cfa <release>
}
    8000372e:	8526                	mv	a0,s1
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6105                	add	sp,sp,32
    80003738:	8082                	ret

000000008000373a <ilock>:
{
    8000373a:	1101                	add	sp,sp,-32
    8000373c:	ec06                	sd	ra,24(sp)
    8000373e:	e822                	sd	s0,16(sp)
    80003740:	e426                	sd	s1,8(sp)
    80003742:	e04a                	sd	s2,0(sp)
    80003744:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003746:	c115                	beqz	a0,8000376a <ilock+0x30>
    80003748:	84aa                	mv	s1,a0
    8000374a:	451c                	lw	a5,8(a0)
    8000374c:	00f05f63          	blez	a5,8000376a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003750:	0541                	add	a0,a0,16
    80003752:	00001097          	auipc	ra,0x1
    80003756:	c7e080e7          	jalr	-898(ra) # 800043d0 <acquiresleep>
  if(ip->valid == 0){
    8000375a:	40bc                	lw	a5,64(s1)
    8000375c:	cf99                	beqz	a5,8000377a <ilock+0x40>
}
    8000375e:	60e2                	ld	ra,24(sp)
    80003760:	6442                	ld	s0,16(sp)
    80003762:	64a2                	ld	s1,8(sp)
    80003764:	6902                	ld	s2,0(sp)
    80003766:	6105                	add	sp,sp,32
    80003768:	8082                	ret
    panic("ilock");
    8000376a:	00005517          	auipc	a0,0x5
    8000376e:	fd650513          	add	a0,a0,-42 # 80008740 <syscall_names+0x190>
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	dd0080e7          	jalr	-560(ra) # 80000542 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000377a:	40dc                	lw	a5,4(s1)
    8000377c:	0047d79b          	srlw	a5,a5,0x4
    80003780:	0001d597          	auipc	a1,0x1d
    80003784:	8d85a583          	lw	a1,-1832(a1) # 80020058 <sb+0x18>
    80003788:	9dbd                	addw	a1,a1,a5
    8000378a:	4088                	lw	a0,0(s1)
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	7b4080e7          	jalr	1972(ra) # 80002f40 <bread>
    80003794:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003796:	05850593          	add	a1,a0,88
    8000379a:	40dc                	lw	a5,4(s1)
    8000379c:	8bbd                	and	a5,a5,15
    8000379e:	079a                	sll	a5,a5,0x6
    800037a0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037a2:	00059783          	lh	a5,0(a1)
    800037a6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037aa:	00259783          	lh	a5,2(a1)
    800037ae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037b2:	00459783          	lh	a5,4(a1)
    800037b6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037ba:	00659783          	lh	a5,6(a1)
    800037be:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037c2:	459c                	lw	a5,8(a1)
    800037c4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037c6:	03400613          	li	a2,52
    800037ca:	05b1                	add	a1,a1,12
    800037cc:	05048513          	add	a0,s1,80
    800037d0:	ffffd097          	auipc	ra,0xffffd
    800037d4:	5ce080e7          	jalr	1486(ra) # 80000d9e <memmove>
    brelse(bp);
    800037d8:	854a                	mv	a0,s2
    800037da:	00000097          	auipc	ra,0x0
    800037de:	896080e7          	jalr	-1898(ra) # 80003070 <brelse>
    ip->valid = 1;
    800037e2:	4785                	li	a5,1
    800037e4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037e6:	04449783          	lh	a5,68(s1)
    800037ea:	fbb5                	bnez	a5,8000375e <ilock+0x24>
      panic("ilock: no type");
    800037ec:	00005517          	auipc	a0,0x5
    800037f0:	f5c50513          	add	a0,a0,-164 # 80008748 <syscall_names+0x198>
    800037f4:	ffffd097          	auipc	ra,0xffffd
    800037f8:	d4e080e7          	jalr	-690(ra) # 80000542 <panic>

00000000800037fc <iunlock>:
{
    800037fc:	1101                	add	sp,sp,-32
    800037fe:	ec06                	sd	ra,24(sp)
    80003800:	e822                	sd	s0,16(sp)
    80003802:	e426                	sd	s1,8(sp)
    80003804:	e04a                	sd	s2,0(sp)
    80003806:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003808:	c905                	beqz	a0,80003838 <iunlock+0x3c>
    8000380a:	84aa                	mv	s1,a0
    8000380c:	01050913          	add	s2,a0,16
    80003810:	854a                	mv	a0,s2
    80003812:	00001097          	auipc	ra,0x1
    80003816:	c58080e7          	jalr	-936(ra) # 8000446a <holdingsleep>
    8000381a:	cd19                	beqz	a0,80003838 <iunlock+0x3c>
    8000381c:	449c                	lw	a5,8(s1)
    8000381e:	00f05d63          	blez	a5,80003838 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003822:	854a                	mv	a0,s2
    80003824:	00001097          	auipc	ra,0x1
    80003828:	c02080e7          	jalr	-1022(ra) # 80004426 <releasesleep>
}
    8000382c:	60e2                	ld	ra,24(sp)
    8000382e:	6442                	ld	s0,16(sp)
    80003830:	64a2                	ld	s1,8(sp)
    80003832:	6902                	ld	s2,0(sp)
    80003834:	6105                	add	sp,sp,32
    80003836:	8082                	ret
    panic("iunlock");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	f2050513          	add	a0,a0,-224 # 80008758 <syscall_names+0x1a8>
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	d02080e7          	jalr	-766(ra) # 80000542 <panic>

0000000080003848 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003848:	7179                	add	sp,sp,-48
    8000384a:	f406                	sd	ra,40(sp)
    8000384c:	f022                	sd	s0,32(sp)
    8000384e:	ec26                	sd	s1,24(sp)
    80003850:	e84a                	sd	s2,16(sp)
    80003852:	e44e                	sd	s3,8(sp)
    80003854:	e052                	sd	s4,0(sp)
    80003856:	1800                	add	s0,sp,48
    80003858:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000385a:	05050493          	add	s1,a0,80
    8000385e:	08050913          	add	s2,a0,128
    80003862:	a021                	j	8000386a <itrunc+0x22>
    80003864:	0491                	add	s1,s1,4
    80003866:	01248d63          	beq	s1,s2,80003880 <itrunc+0x38>
    if(ip->addrs[i]){
    8000386a:	408c                	lw	a1,0(s1)
    8000386c:	dde5                	beqz	a1,80003864 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000386e:	0009a503          	lw	a0,0(s3)
    80003872:	00000097          	auipc	ra,0x0
    80003876:	912080e7          	jalr	-1774(ra) # 80003184 <bfree>
      ip->addrs[i] = 0;
    8000387a:	0004a023          	sw	zero,0(s1)
    8000387e:	b7dd                	j	80003864 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003880:	0809a583          	lw	a1,128(s3)
    80003884:	e185                	bnez	a1,800038a4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003886:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000388a:	854e                	mv	a0,s3
    8000388c:	00000097          	auipc	ra,0x0
    80003890:	de2080e7          	jalr	-542(ra) # 8000366e <iupdate>
}
    80003894:	70a2                	ld	ra,40(sp)
    80003896:	7402                	ld	s0,32(sp)
    80003898:	64e2                	ld	s1,24(sp)
    8000389a:	6942                	ld	s2,16(sp)
    8000389c:	69a2                	ld	s3,8(sp)
    8000389e:	6a02                	ld	s4,0(sp)
    800038a0:	6145                	add	sp,sp,48
    800038a2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038a4:	0009a503          	lw	a0,0(s3)
    800038a8:	fffff097          	auipc	ra,0xfffff
    800038ac:	698080e7          	jalr	1688(ra) # 80002f40 <bread>
    800038b0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038b2:	05850493          	add	s1,a0,88
    800038b6:	45850913          	add	s2,a0,1112
    800038ba:	a021                	j	800038c2 <itrunc+0x7a>
    800038bc:	0491                	add	s1,s1,4
    800038be:	01248b63          	beq	s1,s2,800038d4 <itrunc+0x8c>
      if(a[j])
    800038c2:	408c                	lw	a1,0(s1)
    800038c4:	dde5                	beqz	a1,800038bc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800038c6:	0009a503          	lw	a0,0(s3)
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	8ba080e7          	jalr	-1862(ra) # 80003184 <bfree>
    800038d2:	b7ed                	j	800038bc <itrunc+0x74>
    brelse(bp);
    800038d4:	8552                	mv	a0,s4
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	79a080e7          	jalr	1946(ra) # 80003070 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038de:	0809a583          	lw	a1,128(s3)
    800038e2:	0009a503          	lw	a0,0(s3)
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	89e080e7          	jalr	-1890(ra) # 80003184 <bfree>
    ip->addrs[NDIRECT] = 0;
    800038ee:	0809a023          	sw	zero,128(s3)
    800038f2:	bf51                	j	80003886 <itrunc+0x3e>

00000000800038f4 <iput>:
{
    800038f4:	1101                	add	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	add	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003902:	0001c517          	auipc	a0,0x1c
    80003906:	75e50513          	add	a0,a0,1886 # 80020060 <icache>
    8000390a:	ffffd097          	auipc	ra,0xffffd
    8000390e:	33c080e7          	jalr	828(ra) # 80000c46 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003912:	4498                	lw	a4,8(s1)
    80003914:	4785                	li	a5,1
    80003916:	02f70363          	beq	a4,a5,8000393c <iput+0x48>
  ip->ref--;
    8000391a:	449c                	lw	a5,8(s1)
    8000391c:	37fd                	addw	a5,a5,-1
    8000391e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003920:	0001c517          	auipc	a0,0x1c
    80003924:	74050513          	add	a0,a0,1856 # 80020060 <icache>
    80003928:	ffffd097          	auipc	ra,0xffffd
    8000392c:	3d2080e7          	jalr	978(ra) # 80000cfa <release>
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6902                	ld	s2,0(sp)
    80003938:	6105                	add	sp,sp,32
    8000393a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000393c:	40bc                	lw	a5,64(s1)
    8000393e:	dff1                	beqz	a5,8000391a <iput+0x26>
    80003940:	04a49783          	lh	a5,74(s1)
    80003944:	fbf9                	bnez	a5,8000391a <iput+0x26>
    acquiresleep(&ip->lock);
    80003946:	01048913          	add	s2,s1,16
    8000394a:	854a                	mv	a0,s2
    8000394c:	00001097          	auipc	ra,0x1
    80003950:	a84080e7          	jalr	-1404(ra) # 800043d0 <acquiresleep>
    release(&icache.lock);
    80003954:	0001c517          	auipc	a0,0x1c
    80003958:	70c50513          	add	a0,a0,1804 # 80020060 <icache>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	39e080e7          	jalr	926(ra) # 80000cfa <release>
    itrunc(ip);
    80003964:	8526                	mv	a0,s1
    80003966:	00000097          	auipc	ra,0x0
    8000396a:	ee2080e7          	jalr	-286(ra) # 80003848 <itrunc>
    ip->type = 0;
    8000396e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003972:	8526                	mv	a0,s1
    80003974:	00000097          	auipc	ra,0x0
    80003978:	cfa080e7          	jalr	-774(ra) # 8000366e <iupdate>
    ip->valid = 0;
    8000397c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003980:	854a                	mv	a0,s2
    80003982:	00001097          	auipc	ra,0x1
    80003986:	aa4080e7          	jalr	-1372(ra) # 80004426 <releasesleep>
    acquire(&icache.lock);
    8000398a:	0001c517          	auipc	a0,0x1c
    8000398e:	6d650513          	add	a0,a0,1750 # 80020060 <icache>
    80003992:	ffffd097          	auipc	ra,0xffffd
    80003996:	2b4080e7          	jalr	692(ra) # 80000c46 <acquire>
    8000399a:	b741                	j	8000391a <iput+0x26>

000000008000399c <iunlockput>:
{
    8000399c:	1101                	add	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	1000                	add	s0,sp,32
    800039a6:	84aa                	mv	s1,a0
  iunlock(ip);
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	e54080e7          	jalr	-428(ra) # 800037fc <iunlock>
  iput(ip);
    800039b0:	8526                	mv	a0,s1
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	f42080e7          	jalr	-190(ra) # 800038f4 <iput>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6105                	add	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039c4:	1141                	add	sp,sp,-16
    800039c6:	e422                	sd	s0,8(sp)
    800039c8:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800039ca:	411c                	lw	a5,0(a0)
    800039cc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039ce:	415c                	lw	a5,4(a0)
    800039d0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039d2:	04451783          	lh	a5,68(a0)
    800039d6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039da:	04a51783          	lh	a5,74(a0)
    800039de:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039e2:	04c56783          	lwu	a5,76(a0)
    800039e6:	e99c                	sd	a5,16(a1)
}
    800039e8:	6422                	ld	s0,8(sp)
    800039ea:	0141                	add	sp,sp,16
    800039ec:	8082                	ret

00000000800039ee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039ee:	457c                	lw	a5,76(a0)
    800039f0:	0ed7e863          	bltu	a5,a3,80003ae0 <readi+0xf2>
{
    800039f4:	7159                	add	sp,sp,-112
    800039f6:	f486                	sd	ra,104(sp)
    800039f8:	f0a2                	sd	s0,96(sp)
    800039fa:	eca6                	sd	s1,88(sp)
    800039fc:	e8ca                	sd	s2,80(sp)
    800039fe:	e4ce                	sd	s3,72(sp)
    80003a00:	e0d2                	sd	s4,64(sp)
    80003a02:	fc56                	sd	s5,56(sp)
    80003a04:	f85a                	sd	s6,48(sp)
    80003a06:	f45e                	sd	s7,40(sp)
    80003a08:	f062                	sd	s8,32(sp)
    80003a0a:	ec66                	sd	s9,24(sp)
    80003a0c:	e86a                	sd	s10,16(sp)
    80003a0e:	e46e                	sd	s11,8(sp)
    80003a10:	1880                	add	s0,sp,112
    80003a12:	8baa                	mv	s7,a0
    80003a14:	8c2e                	mv	s8,a1
    80003a16:	8ab2                	mv	s5,a2
    80003a18:	84b6                	mv	s1,a3
    80003a1a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a1c:	9f35                	addw	a4,a4,a3
    return 0;
    80003a1e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a20:	08d76f63          	bltu	a4,a3,80003abe <readi+0xd0>
  if(off + n > ip->size)
    80003a24:	00e7f463          	bgeu	a5,a4,80003a2c <readi+0x3e>
    n = ip->size - off;
    80003a28:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a2c:	0a0b0863          	beqz	s6,80003adc <readi+0xee>
    80003a30:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a32:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a36:	5cfd                	li	s9,-1
    80003a38:	a82d                	j	80003a72 <readi+0x84>
    80003a3a:	020a1d93          	sll	s11,s4,0x20
    80003a3e:	020ddd93          	srl	s11,s11,0x20
    80003a42:	05890613          	add	a2,s2,88
    80003a46:	86ee                	mv	a3,s11
    80003a48:	963a                	add	a2,a2,a4
    80003a4a:	85d6                	mv	a1,s5
    80003a4c:	8562                	mv	a0,s8
    80003a4e:	fffff097          	auipc	ra,0xfffff
    80003a52:	a38080e7          	jalr	-1480(ra) # 80002486 <either_copyout>
    80003a56:	05950d63          	beq	a0,s9,80003ab0 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	614080e7          	jalr	1556(ra) # 80003070 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a64:	013a09bb          	addw	s3,s4,s3
    80003a68:	009a04bb          	addw	s1,s4,s1
    80003a6c:	9aee                	add	s5,s5,s11
    80003a6e:	0569f663          	bgeu	s3,s6,80003aba <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a72:	000ba903          	lw	s2,0(s7)
    80003a76:	00a4d59b          	srlw	a1,s1,0xa
    80003a7a:	855e                	mv	a0,s7
    80003a7c:	00000097          	auipc	ra,0x0
    80003a80:	8b2080e7          	jalr	-1870(ra) # 8000332e <bmap>
    80003a84:	0005059b          	sext.w	a1,a0
    80003a88:	854a                	mv	a0,s2
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	4b6080e7          	jalr	1206(ra) # 80002f40 <bread>
    80003a92:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a94:	3ff4f713          	and	a4,s1,1023
    80003a98:	40ed07bb          	subw	a5,s10,a4
    80003a9c:	413b06bb          	subw	a3,s6,s3
    80003aa0:	8a3e                	mv	s4,a5
    80003aa2:	2781                	sext.w	a5,a5
    80003aa4:	0006861b          	sext.w	a2,a3
    80003aa8:	f8f679e3          	bgeu	a2,a5,80003a3a <readi+0x4c>
    80003aac:	8a36                	mv	s4,a3
    80003aae:	b771                	j	80003a3a <readi+0x4c>
      brelse(bp);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	fffff097          	auipc	ra,0xfffff
    80003ab6:	5be080e7          	jalr	1470(ra) # 80003070 <brelse>
  }
  return tot;
    80003aba:	0009851b          	sext.w	a0,s3
}
    80003abe:	70a6                	ld	ra,104(sp)
    80003ac0:	7406                	ld	s0,96(sp)
    80003ac2:	64e6                	ld	s1,88(sp)
    80003ac4:	6946                	ld	s2,80(sp)
    80003ac6:	69a6                	ld	s3,72(sp)
    80003ac8:	6a06                	ld	s4,64(sp)
    80003aca:	7ae2                	ld	s5,56(sp)
    80003acc:	7b42                	ld	s6,48(sp)
    80003ace:	7ba2                	ld	s7,40(sp)
    80003ad0:	7c02                	ld	s8,32(sp)
    80003ad2:	6ce2                	ld	s9,24(sp)
    80003ad4:	6d42                	ld	s10,16(sp)
    80003ad6:	6da2                	ld	s11,8(sp)
    80003ad8:	6165                	add	sp,sp,112
    80003ada:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003adc:	89da                	mv	s3,s6
    80003ade:	bff1                	j	80003aba <readi+0xcc>
    return 0;
    80003ae0:	4501                	li	a0,0
}
    80003ae2:	8082                	ret

0000000080003ae4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ae4:	457c                	lw	a5,76(a0)
    80003ae6:	10d7e663          	bltu	a5,a3,80003bf2 <writei+0x10e>
{
    80003aea:	7159                	add	sp,sp,-112
    80003aec:	f486                	sd	ra,104(sp)
    80003aee:	f0a2                	sd	s0,96(sp)
    80003af0:	eca6                	sd	s1,88(sp)
    80003af2:	e8ca                	sd	s2,80(sp)
    80003af4:	e4ce                	sd	s3,72(sp)
    80003af6:	e0d2                	sd	s4,64(sp)
    80003af8:	fc56                	sd	s5,56(sp)
    80003afa:	f85a                	sd	s6,48(sp)
    80003afc:	f45e                	sd	s7,40(sp)
    80003afe:	f062                	sd	s8,32(sp)
    80003b00:	ec66                	sd	s9,24(sp)
    80003b02:	e86a                	sd	s10,16(sp)
    80003b04:	e46e                	sd	s11,8(sp)
    80003b06:	1880                	add	s0,sp,112
    80003b08:	8baa                	mv	s7,a0
    80003b0a:	8c2e                	mv	s8,a1
    80003b0c:	8ab2                	mv	s5,a2
    80003b0e:	8936                	mv	s2,a3
    80003b10:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b12:	00e687bb          	addw	a5,a3,a4
    80003b16:	0ed7e063          	bltu	a5,a3,80003bf6 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b1a:	00043737          	lui	a4,0x43
    80003b1e:	0cf76e63          	bltu	a4,a5,80003bfa <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b22:	0a0b0763          	beqz	s6,80003bd0 <writei+0xec>
    80003b26:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b28:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b2c:	5cfd                	li	s9,-1
    80003b2e:	a091                	j	80003b72 <writei+0x8e>
    80003b30:	02099d93          	sll	s11,s3,0x20
    80003b34:	020ddd93          	srl	s11,s11,0x20
    80003b38:	05848513          	add	a0,s1,88
    80003b3c:	86ee                	mv	a3,s11
    80003b3e:	8656                	mv	a2,s5
    80003b40:	85e2                	mv	a1,s8
    80003b42:	953a                	add	a0,a0,a4
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	998080e7          	jalr	-1640(ra) # 800024dc <either_copyin>
    80003b4c:	07950263          	beq	a0,s9,80003bb0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b50:	8526                	mv	a0,s1
    80003b52:	00000097          	auipc	ra,0x0
    80003b56:	758080e7          	jalr	1880(ra) # 800042aa <log_write>
    brelse(bp);
    80003b5a:	8526                	mv	a0,s1
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	514080e7          	jalr	1300(ra) # 80003070 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b64:	01498a3b          	addw	s4,s3,s4
    80003b68:	0129893b          	addw	s2,s3,s2
    80003b6c:	9aee                	add	s5,s5,s11
    80003b6e:	056a7663          	bgeu	s4,s6,80003bba <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b72:	000ba483          	lw	s1,0(s7)
    80003b76:	00a9559b          	srlw	a1,s2,0xa
    80003b7a:	855e                	mv	a0,s7
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	7b2080e7          	jalr	1970(ra) # 8000332e <bmap>
    80003b84:	0005059b          	sext.w	a1,a0
    80003b88:	8526                	mv	a0,s1
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	3b6080e7          	jalr	950(ra) # 80002f40 <bread>
    80003b92:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b94:	3ff97713          	and	a4,s2,1023
    80003b98:	40ed07bb          	subw	a5,s10,a4
    80003b9c:	414b06bb          	subw	a3,s6,s4
    80003ba0:	89be                	mv	s3,a5
    80003ba2:	2781                	sext.w	a5,a5
    80003ba4:	0006861b          	sext.w	a2,a3
    80003ba8:	f8f674e3          	bgeu	a2,a5,80003b30 <writei+0x4c>
    80003bac:	89b6                	mv	s3,a3
    80003bae:	b749                	j	80003b30 <writei+0x4c>
      brelse(bp);
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	4be080e7          	jalr	1214(ra) # 80003070 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003bba:	04cba783          	lw	a5,76(s7)
    80003bbe:	0127f463          	bgeu	a5,s2,80003bc6 <writei+0xe2>
      ip->size = off;
    80003bc2:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003bc6:	855e                	mv	a0,s7
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	aa6080e7          	jalr	-1370(ra) # 8000366e <iupdate>
  }

  return n;
    80003bd0:	000b051b          	sext.w	a0,s6
}
    80003bd4:	70a6                	ld	ra,104(sp)
    80003bd6:	7406                	ld	s0,96(sp)
    80003bd8:	64e6                	ld	s1,88(sp)
    80003bda:	6946                	ld	s2,80(sp)
    80003bdc:	69a6                	ld	s3,72(sp)
    80003bde:	6a06                	ld	s4,64(sp)
    80003be0:	7ae2                	ld	s5,56(sp)
    80003be2:	7b42                	ld	s6,48(sp)
    80003be4:	7ba2                	ld	s7,40(sp)
    80003be6:	7c02                	ld	s8,32(sp)
    80003be8:	6ce2                	ld	s9,24(sp)
    80003bea:	6d42                	ld	s10,16(sp)
    80003bec:	6da2                	ld	s11,8(sp)
    80003bee:	6165                	add	sp,sp,112
    80003bf0:	8082                	ret
    return -1;
    80003bf2:	557d                	li	a0,-1
}
    80003bf4:	8082                	ret
    return -1;
    80003bf6:	557d                	li	a0,-1
    80003bf8:	bff1                	j	80003bd4 <writei+0xf0>
    return -1;
    80003bfa:	557d                	li	a0,-1
    80003bfc:	bfe1                	j	80003bd4 <writei+0xf0>

0000000080003bfe <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003bfe:	1141                	add	sp,sp,-16
    80003c00:	e406                	sd	ra,8(sp)
    80003c02:	e022                	sd	s0,0(sp)
    80003c04:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c06:	4639                	li	a2,14
    80003c08:	ffffd097          	auipc	ra,0xffffd
    80003c0c:	212080e7          	jalr	530(ra) # 80000e1a <strncmp>
}
    80003c10:	60a2                	ld	ra,8(sp)
    80003c12:	6402                	ld	s0,0(sp)
    80003c14:	0141                	add	sp,sp,16
    80003c16:	8082                	ret

0000000080003c18 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c18:	7139                	add	sp,sp,-64
    80003c1a:	fc06                	sd	ra,56(sp)
    80003c1c:	f822                	sd	s0,48(sp)
    80003c1e:	f426                	sd	s1,40(sp)
    80003c20:	f04a                	sd	s2,32(sp)
    80003c22:	ec4e                	sd	s3,24(sp)
    80003c24:	e852                	sd	s4,16(sp)
    80003c26:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c28:	04451703          	lh	a4,68(a0)
    80003c2c:	4785                	li	a5,1
    80003c2e:	00f71a63          	bne	a4,a5,80003c42 <dirlookup+0x2a>
    80003c32:	892a                	mv	s2,a0
    80003c34:	89ae                	mv	s3,a1
    80003c36:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c38:	457c                	lw	a5,76(a0)
    80003c3a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c3c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c3e:	e79d                	bnez	a5,80003c6c <dirlookup+0x54>
    80003c40:	a8a5                	j	80003cb8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c42:	00005517          	auipc	a0,0x5
    80003c46:	b1e50513          	add	a0,a0,-1250 # 80008760 <syscall_names+0x1b0>
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	8f8080e7          	jalr	-1800(ra) # 80000542 <panic>
      panic("dirlookup read");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	b2650513          	add	a0,a0,-1242 # 80008778 <syscall_names+0x1c8>
    80003c5a:	ffffd097          	auipc	ra,0xffffd
    80003c5e:	8e8080e7          	jalr	-1816(ra) # 80000542 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c62:	24c1                	addw	s1,s1,16
    80003c64:	04c92783          	lw	a5,76(s2)
    80003c68:	04f4f763          	bgeu	s1,a5,80003cb6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c6c:	4741                	li	a4,16
    80003c6e:	86a6                	mv	a3,s1
    80003c70:	fc040613          	add	a2,s0,-64
    80003c74:	4581                	li	a1,0
    80003c76:	854a                	mv	a0,s2
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	d76080e7          	jalr	-650(ra) # 800039ee <readi>
    80003c80:	47c1                	li	a5,16
    80003c82:	fcf518e3          	bne	a0,a5,80003c52 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c86:	fc045783          	lhu	a5,-64(s0)
    80003c8a:	dfe1                	beqz	a5,80003c62 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c8c:	fc240593          	add	a1,s0,-62
    80003c90:	854e                	mv	a0,s3
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	f6c080e7          	jalr	-148(ra) # 80003bfe <namecmp>
    80003c9a:	f561                	bnez	a0,80003c62 <dirlookup+0x4a>
      if(poff)
    80003c9c:	000a0463          	beqz	s4,80003ca4 <dirlookup+0x8c>
        *poff = off;
    80003ca0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003ca4:	fc045583          	lhu	a1,-64(s0)
    80003ca8:	00092503          	lw	a0,0(s2)
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	75e080e7          	jalr	1886(ra) # 8000340a <iget>
    80003cb4:	a011                	j	80003cb8 <dirlookup+0xa0>
  return 0;
    80003cb6:	4501                	li	a0,0
}
    80003cb8:	70e2                	ld	ra,56(sp)
    80003cba:	7442                	ld	s0,48(sp)
    80003cbc:	74a2                	ld	s1,40(sp)
    80003cbe:	7902                	ld	s2,32(sp)
    80003cc0:	69e2                	ld	s3,24(sp)
    80003cc2:	6a42                	ld	s4,16(sp)
    80003cc4:	6121                	add	sp,sp,64
    80003cc6:	8082                	ret

0000000080003cc8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cc8:	711d                	add	sp,sp,-96
    80003cca:	ec86                	sd	ra,88(sp)
    80003ccc:	e8a2                	sd	s0,80(sp)
    80003cce:	e4a6                	sd	s1,72(sp)
    80003cd0:	e0ca                	sd	s2,64(sp)
    80003cd2:	fc4e                	sd	s3,56(sp)
    80003cd4:	f852                	sd	s4,48(sp)
    80003cd6:	f456                	sd	s5,40(sp)
    80003cd8:	f05a                	sd	s6,32(sp)
    80003cda:	ec5e                	sd	s7,24(sp)
    80003cdc:	e862                	sd	s8,16(sp)
    80003cde:	e466                	sd	s9,8(sp)
    80003ce0:	1080                	add	s0,sp,96
    80003ce2:	84aa                	mv	s1,a0
    80003ce4:	8b2e                	mv	s6,a1
    80003ce6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ce8:	00054703          	lbu	a4,0(a0)
    80003cec:	02f00793          	li	a5,47
    80003cf0:	02f70263          	beq	a4,a5,80003d14 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cf4:	ffffe097          	auipc	ra,0xffffe
    80003cf8:	d1c080e7          	jalr	-740(ra) # 80001a10 <myproc>
    80003cfc:	15053503          	ld	a0,336(a0)
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	9fc080e7          	jalr	-1540(ra) # 800036fc <idup>
    80003d08:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d0a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d0e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d10:	4b85                	li	s7,1
    80003d12:	a875                	j	80003dce <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d14:	4585                	li	a1,1
    80003d16:	4505                	li	a0,1
    80003d18:	fffff097          	auipc	ra,0xfffff
    80003d1c:	6f2080e7          	jalr	1778(ra) # 8000340a <iget>
    80003d20:	8a2a                	mv	s4,a0
    80003d22:	b7e5                	j	80003d0a <namex+0x42>
      iunlockput(ip);
    80003d24:	8552                	mv	a0,s4
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	c76080e7          	jalr	-906(ra) # 8000399c <iunlockput>
      return 0;
    80003d2e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d30:	8552                	mv	a0,s4
    80003d32:	60e6                	ld	ra,88(sp)
    80003d34:	6446                	ld	s0,80(sp)
    80003d36:	64a6                	ld	s1,72(sp)
    80003d38:	6906                	ld	s2,64(sp)
    80003d3a:	79e2                	ld	s3,56(sp)
    80003d3c:	7a42                	ld	s4,48(sp)
    80003d3e:	7aa2                	ld	s5,40(sp)
    80003d40:	7b02                	ld	s6,32(sp)
    80003d42:	6be2                	ld	s7,24(sp)
    80003d44:	6c42                	ld	s8,16(sp)
    80003d46:	6ca2                	ld	s9,8(sp)
    80003d48:	6125                	add	sp,sp,96
    80003d4a:	8082                	ret
      iunlock(ip);
    80003d4c:	8552                	mv	a0,s4
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	aae080e7          	jalr	-1362(ra) # 800037fc <iunlock>
      return ip;
    80003d56:	bfe9                	j	80003d30 <namex+0x68>
      iunlockput(ip);
    80003d58:	8552                	mv	a0,s4
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	c42080e7          	jalr	-958(ra) # 8000399c <iunlockput>
      return 0;
    80003d62:	8a4e                	mv	s4,s3
    80003d64:	b7f1                	j	80003d30 <namex+0x68>
  len = path - s;
    80003d66:	40998633          	sub	a2,s3,s1
    80003d6a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d6e:	099c5863          	bge	s8,s9,80003dfe <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003d72:	4639                	li	a2,14
    80003d74:	85a6                	mv	a1,s1
    80003d76:	8556                	mv	a0,s5
    80003d78:	ffffd097          	auipc	ra,0xffffd
    80003d7c:	026080e7          	jalr	38(ra) # 80000d9e <memmove>
    80003d80:	84ce                	mv	s1,s3
  while(*path == '/')
    80003d82:	0004c783          	lbu	a5,0(s1)
    80003d86:	01279763          	bne	a5,s2,80003d94 <namex+0xcc>
    path++;
    80003d8a:	0485                	add	s1,s1,1
  while(*path == '/')
    80003d8c:	0004c783          	lbu	a5,0(s1)
    80003d90:	ff278de3          	beq	a5,s2,80003d8a <namex+0xc2>
    ilock(ip);
    80003d94:	8552                	mv	a0,s4
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	9a4080e7          	jalr	-1628(ra) # 8000373a <ilock>
    if(ip->type != T_DIR){
    80003d9e:	044a1783          	lh	a5,68(s4)
    80003da2:	f97791e3          	bne	a5,s7,80003d24 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003da6:	000b0563          	beqz	s6,80003db0 <namex+0xe8>
    80003daa:	0004c783          	lbu	a5,0(s1)
    80003dae:	dfd9                	beqz	a5,80003d4c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003db0:	4601                	li	a2,0
    80003db2:	85d6                	mv	a1,s5
    80003db4:	8552                	mv	a0,s4
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	e62080e7          	jalr	-414(ra) # 80003c18 <dirlookup>
    80003dbe:	89aa                	mv	s3,a0
    80003dc0:	dd41                	beqz	a0,80003d58 <namex+0x90>
    iunlockput(ip);
    80003dc2:	8552                	mv	a0,s4
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	bd8080e7          	jalr	-1064(ra) # 8000399c <iunlockput>
    ip = next;
    80003dcc:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003dce:	0004c783          	lbu	a5,0(s1)
    80003dd2:	01279763          	bne	a5,s2,80003de0 <namex+0x118>
    path++;
    80003dd6:	0485                	add	s1,s1,1
  while(*path == '/')
    80003dd8:	0004c783          	lbu	a5,0(s1)
    80003ddc:	ff278de3          	beq	a5,s2,80003dd6 <namex+0x10e>
  if(*path == 0)
    80003de0:	cb9d                	beqz	a5,80003e16 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003de2:	0004c783          	lbu	a5,0(s1)
    80003de6:	89a6                	mv	s3,s1
  len = path - s;
    80003de8:	4c81                	li	s9,0
    80003dea:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003dec:	01278963          	beq	a5,s2,80003dfe <namex+0x136>
    80003df0:	dbbd                	beqz	a5,80003d66 <namex+0x9e>
    path++;
    80003df2:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003df4:	0009c783          	lbu	a5,0(s3)
    80003df8:	ff279ce3          	bne	a5,s2,80003df0 <namex+0x128>
    80003dfc:	b7ad                	j	80003d66 <namex+0x9e>
    memmove(name, s, len);
    80003dfe:	2601                	sext.w	a2,a2
    80003e00:	85a6                	mv	a1,s1
    80003e02:	8556                	mv	a0,s5
    80003e04:	ffffd097          	auipc	ra,0xffffd
    80003e08:	f9a080e7          	jalr	-102(ra) # 80000d9e <memmove>
    name[len] = 0;
    80003e0c:	9cd6                	add	s9,s9,s5
    80003e0e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e12:	84ce                	mv	s1,s3
    80003e14:	b7bd                	j	80003d82 <namex+0xba>
  if(nameiparent){
    80003e16:	f00b0de3          	beqz	s6,80003d30 <namex+0x68>
    iput(ip);
    80003e1a:	8552                	mv	a0,s4
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	ad8080e7          	jalr	-1320(ra) # 800038f4 <iput>
    return 0;
    80003e24:	4a01                	li	s4,0
    80003e26:	b729                	j	80003d30 <namex+0x68>

0000000080003e28 <dirlink>:
{
    80003e28:	7139                	add	sp,sp,-64
    80003e2a:	fc06                	sd	ra,56(sp)
    80003e2c:	f822                	sd	s0,48(sp)
    80003e2e:	f426                	sd	s1,40(sp)
    80003e30:	f04a                	sd	s2,32(sp)
    80003e32:	ec4e                	sd	s3,24(sp)
    80003e34:	e852                	sd	s4,16(sp)
    80003e36:	0080                	add	s0,sp,64
    80003e38:	892a                	mv	s2,a0
    80003e3a:	8a2e                	mv	s4,a1
    80003e3c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e3e:	4601                	li	a2,0
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	dd8080e7          	jalr	-552(ra) # 80003c18 <dirlookup>
    80003e48:	e93d                	bnez	a0,80003ebe <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e4a:	04c92483          	lw	s1,76(s2)
    80003e4e:	c49d                	beqz	s1,80003e7c <dirlink+0x54>
    80003e50:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e52:	4741                	li	a4,16
    80003e54:	86a6                	mv	a3,s1
    80003e56:	fc040613          	add	a2,s0,-64
    80003e5a:	4581                	li	a1,0
    80003e5c:	854a                	mv	a0,s2
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	b90080e7          	jalr	-1136(ra) # 800039ee <readi>
    80003e66:	47c1                	li	a5,16
    80003e68:	06f51163          	bne	a0,a5,80003eca <dirlink+0xa2>
    if(de.inum == 0)
    80003e6c:	fc045783          	lhu	a5,-64(s0)
    80003e70:	c791                	beqz	a5,80003e7c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e72:	24c1                	addw	s1,s1,16
    80003e74:	04c92783          	lw	a5,76(s2)
    80003e78:	fcf4ede3          	bltu	s1,a5,80003e52 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e7c:	4639                	li	a2,14
    80003e7e:	85d2                	mv	a1,s4
    80003e80:	fc240513          	add	a0,s0,-62
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	fd2080e7          	jalr	-46(ra) # 80000e56 <strncpy>
  de.inum = inum;
    80003e8c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e90:	4741                	li	a4,16
    80003e92:	86a6                	mv	a3,s1
    80003e94:	fc040613          	add	a2,s0,-64
    80003e98:	4581                	li	a1,0
    80003e9a:	854a                	mv	a0,s2
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	c48080e7          	jalr	-952(ra) # 80003ae4 <writei>
    80003ea4:	872a                	mv	a4,a0
    80003ea6:	47c1                	li	a5,16
  return 0;
    80003ea8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eaa:	02f71863          	bne	a4,a5,80003eda <dirlink+0xb2>
}
    80003eae:	70e2                	ld	ra,56(sp)
    80003eb0:	7442                	ld	s0,48(sp)
    80003eb2:	74a2                	ld	s1,40(sp)
    80003eb4:	7902                	ld	s2,32(sp)
    80003eb6:	69e2                	ld	s3,24(sp)
    80003eb8:	6a42                	ld	s4,16(sp)
    80003eba:	6121                	add	sp,sp,64
    80003ebc:	8082                	ret
    iput(ip);
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	a36080e7          	jalr	-1482(ra) # 800038f4 <iput>
    return -1;
    80003ec6:	557d                	li	a0,-1
    80003ec8:	b7dd                	j	80003eae <dirlink+0x86>
      panic("dirlink read");
    80003eca:	00005517          	auipc	a0,0x5
    80003ece:	8be50513          	add	a0,a0,-1858 # 80008788 <syscall_names+0x1d8>
    80003ed2:	ffffc097          	auipc	ra,0xffffc
    80003ed6:	670080e7          	jalr	1648(ra) # 80000542 <panic>
    panic("dirlink");
    80003eda:	00005517          	auipc	a0,0x5
    80003ede:	9c650513          	add	a0,a0,-1594 # 800088a0 <syscall_names+0x2f0>
    80003ee2:	ffffc097          	auipc	ra,0xffffc
    80003ee6:	660080e7          	jalr	1632(ra) # 80000542 <panic>

0000000080003eea <namei>:

struct inode*
namei(char *path)
{
    80003eea:	1101                	add	sp,sp,-32
    80003eec:	ec06                	sd	ra,24(sp)
    80003eee:	e822                	sd	s0,16(sp)
    80003ef0:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ef2:	fe040613          	add	a2,s0,-32
    80003ef6:	4581                	li	a1,0
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	dd0080e7          	jalr	-560(ra) # 80003cc8 <namex>
}
    80003f00:	60e2                	ld	ra,24(sp)
    80003f02:	6442                	ld	s0,16(sp)
    80003f04:	6105                	add	sp,sp,32
    80003f06:	8082                	ret

0000000080003f08 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f08:	1141                	add	sp,sp,-16
    80003f0a:	e406                	sd	ra,8(sp)
    80003f0c:	e022                	sd	s0,0(sp)
    80003f0e:	0800                	add	s0,sp,16
    80003f10:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f12:	4585                	li	a1,1
    80003f14:	00000097          	auipc	ra,0x0
    80003f18:	db4080e7          	jalr	-588(ra) # 80003cc8 <namex>
}
    80003f1c:	60a2                	ld	ra,8(sp)
    80003f1e:	6402                	ld	s0,0(sp)
    80003f20:	0141                	add	sp,sp,16
    80003f22:	8082                	ret

0000000080003f24 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f24:	1101                	add	sp,sp,-32
    80003f26:	ec06                	sd	ra,24(sp)
    80003f28:	e822                	sd	s0,16(sp)
    80003f2a:	e426                	sd	s1,8(sp)
    80003f2c:	e04a                	sd	s2,0(sp)
    80003f2e:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f30:	0001e917          	auipc	s2,0x1e
    80003f34:	bd890913          	add	s2,s2,-1064 # 80021b08 <log>
    80003f38:	01892583          	lw	a1,24(s2)
    80003f3c:	02892503          	lw	a0,40(s2)
    80003f40:	fffff097          	auipc	ra,0xfffff
    80003f44:	000080e7          	jalr	ra # 80002f40 <bread>
    80003f48:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f4a:	02c92603          	lw	a2,44(s2)
    80003f4e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f50:	00c05f63          	blez	a2,80003f6e <write_head+0x4a>
    80003f54:	0001e717          	auipc	a4,0x1e
    80003f58:	be470713          	add	a4,a4,-1052 # 80021b38 <log+0x30>
    80003f5c:	87aa                	mv	a5,a0
    80003f5e:	060a                	sll	a2,a2,0x2
    80003f60:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f62:	4314                	lw	a3,0(a4)
    80003f64:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f66:	0711                	add	a4,a4,4
    80003f68:	0791                	add	a5,a5,4
    80003f6a:	fec79ce3          	bne	a5,a2,80003f62 <write_head+0x3e>
  }
  bwrite(buf);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	fffff097          	auipc	ra,0xfffff
    80003f74:	0c2080e7          	jalr	194(ra) # 80003032 <bwrite>
  brelse(buf);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	fffff097          	auipc	ra,0xfffff
    80003f7e:	0f6080e7          	jalr	246(ra) # 80003070 <brelse>
}
    80003f82:	60e2                	ld	ra,24(sp)
    80003f84:	6442                	ld	s0,16(sp)
    80003f86:	64a2                	ld	s1,8(sp)
    80003f88:	6902                	ld	s2,0(sp)
    80003f8a:	6105                	add	sp,sp,32
    80003f8c:	8082                	ret

0000000080003f8e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f8e:	0001e797          	auipc	a5,0x1e
    80003f92:	ba67a783          	lw	a5,-1114(a5) # 80021b34 <log+0x2c>
    80003f96:	0af05663          	blez	a5,80004042 <install_trans+0xb4>
{
    80003f9a:	7139                	add	sp,sp,-64
    80003f9c:	fc06                	sd	ra,56(sp)
    80003f9e:	f822                	sd	s0,48(sp)
    80003fa0:	f426                	sd	s1,40(sp)
    80003fa2:	f04a                	sd	s2,32(sp)
    80003fa4:	ec4e                	sd	s3,24(sp)
    80003fa6:	e852                	sd	s4,16(sp)
    80003fa8:	e456                	sd	s5,8(sp)
    80003faa:	0080                	add	s0,sp,64
    80003fac:	0001ea97          	auipc	s5,0x1e
    80003fb0:	b8ca8a93          	add	s5,s5,-1140 # 80021b38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fb4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fb6:	0001e997          	auipc	s3,0x1e
    80003fba:	b5298993          	add	s3,s3,-1198 # 80021b08 <log>
    80003fbe:	0189a583          	lw	a1,24(s3)
    80003fc2:	014585bb          	addw	a1,a1,s4
    80003fc6:	2585                	addw	a1,a1,1
    80003fc8:	0289a503          	lw	a0,40(s3)
    80003fcc:	fffff097          	auipc	ra,0xfffff
    80003fd0:	f74080e7          	jalr	-140(ra) # 80002f40 <bread>
    80003fd4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003fd6:	000aa583          	lw	a1,0(s5)
    80003fda:	0289a503          	lw	a0,40(s3)
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	f62080e7          	jalr	-158(ra) # 80002f40 <bread>
    80003fe6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fe8:	40000613          	li	a2,1024
    80003fec:	05890593          	add	a1,s2,88
    80003ff0:	05850513          	add	a0,a0,88
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	daa080e7          	jalr	-598(ra) # 80000d9e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	fffff097          	auipc	ra,0xfffff
    80004002:	034080e7          	jalr	52(ra) # 80003032 <bwrite>
    bunpin(dbuf);
    80004006:	8526                	mv	a0,s1
    80004008:	fffff097          	auipc	ra,0xfffff
    8000400c:	140080e7          	jalr	320(ra) # 80003148 <bunpin>
    brelse(lbuf);
    80004010:	854a                	mv	a0,s2
    80004012:	fffff097          	auipc	ra,0xfffff
    80004016:	05e080e7          	jalr	94(ra) # 80003070 <brelse>
    brelse(dbuf);
    8000401a:	8526                	mv	a0,s1
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	054080e7          	jalr	84(ra) # 80003070 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004024:	2a05                	addw	s4,s4,1
    80004026:	0a91                	add	s5,s5,4
    80004028:	02c9a783          	lw	a5,44(s3)
    8000402c:	f8fa49e3          	blt	s4,a5,80003fbe <install_trans+0x30>
}
    80004030:	70e2                	ld	ra,56(sp)
    80004032:	7442                	ld	s0,48(sp)
    80004034:	74a2                	ld	s1,40(sp)
    80004036:	7902                	ld	s2,32(sp)
    80004038:	69e2                	ld	s3,24(sp)
    8000403a:	6a42                	ld	s4,16(sp)
    8000403c:	6aa2                	ld	s5,8(sp)
    8000403e:	6121                	add	sp,sp,64
    80004040:	8082                	ret
    80004042:	8082                	ret

0000000080004044 <initlog>:
{
    80004044:	7179                	add	sp,sp,-48
    80004046:	f406                	sd	ra,40(sp)
    80004048:	f022                	sd	s0,32(sp)
    8000404a:	ec26                	sd	s1,24(sp)
    8000404c:	e84a                	sd	s2,16(sp)
    8000404e:	e44e                	sd	s3,8(sp)
    80004050:	1800                	add	s0,sp,48
    80004052:	892a                	mv	s2,a0
    80004054:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004056:	0001e497          	auipc	s1,0x1e
    8000405a:	ab248493          	add	s1,s1,-1358 # 80021b08 <log>
    8000405e:	00004597          	auipc	a1,0x4
    80004062:	73a58593          	add	a1,a1,1850 # 80008798 <syscall_names+0x1e8>
    80004066:	8526                	mv	a0,s1
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	b4e080e7          	jalr	-1202(ra) # 80000bb6 <initlock>
  log.start = sb->logstart;
    80004070:	0149a583          	lw	a1,20(s3)
    80004074:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004076:	0109a783          	lw	a5,16(s3)
    8000407a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000407c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004080:	854a                	mv	a0,s2
    80004082:	fffff097          	auipc	ra,0xfffff
    80004086:	ebe080e7          	jalr	-322(ra) # 80002f40 <bread>
  log.lh.n = lh->n;
    8000408a:	4d30                	lw	a2,88(a0)
    8000408c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000408e:	00c05f63          	blez	a2,800040ac <initlog+0x68>
    80004092:	87aa                	mv	a5,a0
    80004094:	0001e717          	auipc	a4,0x1e
    80004098:	aa470713          	add	a4,a4,-1372 # 80021b38 <log+0x30>
    8000409c:	060a                	sll	a2,a2,0x2
    8000409e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040a0:	4ff4                	lw	a3,92(a5)
    800040a2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040a4:	0791                	add	a5,a5,4
    800040a6:	0711                	add	a4,a4,4
    800040a8:	fec79ce3          	bne	a5,a2,800040a0 <initlog+0x5c>
  brelse(buf);
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	fc4080e7          	jalr	-60(ra) # 80003070 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800040b4:	00000097          	auipc	ra,0x0
    800040b8:	eda080e7          	jalr	-294(ra) # 80003f8e <install_trans>
  log.lh.n = 0;
    800040bc:	0001e797          	auipc	a5,0x1e
    800040c0:	a607ac23          	sw	zero,-1416(a5) # 80021b34 <log+0x2c>
  write_head(); // clear the log
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	e60080e7          	jalr	-416(ra) # 80003f24 <write_head>
}
    800040cc:	70a2                	ld	ra,40(sp)
    800040ce:	7402                	ld	s0,32(sp)
    800040d0:	64e2                	ld	s1,24(sp)
    800040d2:	6942                	ld	s2,16(sp)
    800040d4:	69a2                	ld	s3,8(sp)
    800040d6:	6145                	add	sp,sp,48
    800040d8:	8082                	ret

00000000800040da <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040da:	1101                	add	sp,sp,-32
    800040dc:	ec06                	sd	ra,24(sp)
    800040de:	e822                	sd	s0,16(sp)
    800040e0:	e426                	sd	s1,8(sp)
    800040e2:	e04a                	sd	s2,0(sp)
    800040e4:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800040e6:	0001e517          	auipc	a0,0x1e
    800040ea:	a2250513          	add	a0,a0,-1502 # 80021b08 <log>
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	b58080e7          	jalr	-1192(ra) # 80000c46 <acquire>
  while(1){
    if(log.committing){
    800040f6:	0001e497          	auipc	s1,0x1e
    800040fa:	a1248493          	add	s1,s1,-1518 # 80021b08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040fe:	4979                	li	s2,30
    80004100:	a039                	j	8000410e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004102:	85a6                	mv	a1,s1
    80004104:	8526                	mv	a0,s1
    80004106:	ffffe097          	auipc	ra,0xffffe
    8000410a:	126080e7          	jalr	294(ra) # 8000222c <sleep>
    if(log.committing){
    8000410e:	50dc                	lw	a5,36(s1)
    80004110:	fbed                	bnez	a5,80004102 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004112:	5098                	lw	a4,32(s1)
    80004114:	2705                	addw	a4,a4,1
    80004116:	0027179b          	sllw	a5,a4,0x2
    8000411a:	9fb9                	addw	a5,a5,a4
    8000411c:	0017979b          	sllw	a5,a5,0x1
    80004120:	54d4                	lw	a3,44(s1)
    80004122:	9fb5                	addw	a5,a5,a3
    80004124:	00f95963          	bge	s2,a5,80004136 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004128:	85a6                	mv	a1,s1
    8000412a:	8526                	mv	a0,s1
    8000412c:	ffffe097          	auipc	ra,0xffffe
    80004130:	100080e7          	jalr	256(ra) # 8000222c <sleep>
    80004134:	bfe9                	j	8000410e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004136:	0001e517          	auipc	a0,0x1e
    8000413a:	9d250513          	add	a0,a0,-1582 # 80021b08 <log>
    8000413e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	bba080e7          	jalr	-1094(ra) # 80000cfa <release>
      break;
    }
  }
}
    80004148:	60e2                	ld	ra,24(sp)
    8000414a:	6442                	ld	s0,16(sp)
    8000414c:	64a2                	ld	s1,8(sp)
    8000414e:	6902                	ld	s2,0(sp)
    80004150:	6105                	add	sp,sp,32
    80004152:	8082                	ret

0000000080004154 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004154:	7139                	add	sp,sp,-64
    80004156:	fc06                	sd	ra,56(sp)
    80004158:	f822                	sd	s0,48(sp)
    8000415a:	f426                	sd	s1,40(sp)
    8000415c:	f04a                	sd	s2,32(sp)
    8000415e:	ec4e                	sd	s3,24(sp)
    80004160:	e852                	sd	s4,16(sp)
    80004162:	e456                	sd	s5,8(sp)
    80004164:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004166:	0001e497          	auipc	s1,0x1e
    8000416a:	9a248493          	add	s1,s1,-1630 # 80021b08 <log>
    8000416e:	8526                	mv	a0,s1
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	ad6080e7          	jalr	-1322(ra) # 80000c46 <acquire>
  log.outstanding -= 1;
    80004178:	509c                	lw	a5,32(s1)
    8000417a:	37fd                	addw	a5,a5,-1
    8000417c:	0007891b          	sext.w	s2,a5
    80004180:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004182:	50dc                	lw	a5,36(s1)
    80004184:	e7b9                	bnez	a5,800041d2 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004186:	04091e63          	bnez	s2,800041e2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000418a:	0001e497          	auipc	s1,0x1e
    8000418e:	97e48493          	add	s1,s1,-1666 # 80021b08 <log>
    80004192:	4785                	li	a5,1
    80004194:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004196:	8526                	mv	a0,s1
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	b62080e7          	jalr	-1182(ra) # 80000cfa <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041a0:	54dc                	lw	a5,44(s1)
    800041a2:	06f04763          	bgtz	a5,80004210 <end_op+0xbc>
    acquire(&log.lock);
    800041a6:	0001e497          	auipc	s1,0x1e
    800041aa:	96248493          	add	s1,s1,-1694 # 80021b08 <log>
    800041ae:	8526                	mv	a0,s1
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	a96080e7          	jalr	-1386(ra) # 80000c46 <acquire>
    log.committing = 0;
    800041b8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041bc:	8526                	mv	a0,s1
    800041be:	ffffe097          	auipc	ra,0xffffe
    800041c2:	1ee080e7          	jalr	494(ra) # 800023ac <wakeup>
    release(&log.lock);
    800041c6:	8526                	mv	a0,s1
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	b32080e7          	jalr	-1230(ra) # 80000cfa <release>
}
    800041d0:	a03d                	j	800041fe <end_op+0xaa>
    panic("log.committing");
    800041d2:	00004517          	auipc	a0,0x4
    800041d6:	5ce50513          	add	a0,a0,1486 # 800087a0 <syscall_names+0x1f0>
    800041da:	ffffc097          	auipc	ra,0xffffc
    800041de:	368080e7          	jalr	872(ra) # 80000542 <panic>
    wakeup(&log);
    800041e2:	0001e497          	auipc	s1,0x1e
    800041e6:	92648493          	add	s1,s1,-1754 # 80021b08 <log>
    800041ea:	8526                	mv	a0,s1
    800041ec:	ffffe097          	auipc	ra,0xffffe
    800041f0:	1c0080e7          	jalr	448(ra) # 800023ac <wakeup>
  release(&log.lock);
    800041f4:	8526                	mv	a0,s1
    800041f6:	ffffd097          	auipc	ra,0xffffd
    800041fa:	b04080e7          	jalr	-1276(ra) # 80000cfa <release>
}
    800041fe:	70e2                	ld	ra,56(sp)
    80004200:	7442                	ld	s0,48(sp)
    80004202:	74a2                	ld	s1,40(sp)
    80004204:	7902                	ld	s2,32(sp)
    80004206:	69e2                	ld	s3,24(sp)
    80004208:	6a42                	ld	s4,16(sp)
    8000420a:	6aa2                	ld	s5,8(sp)
    8000420c:	6121                	add	sp,sp,64
    8000420e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004210:	0001ea97          	auipc	s5,0x1e
    80004214:	928a8a93          	add	s5,s5,-1752 # 80021b38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004218:	0001ea17          	auipc	s4,0x1e
    8000421c:	8f0a0a13          	add	s4,s4,-1808 # 80021b08 <log>
    80004220:	018a2583          	lw	a1,24(s4)
    80004224:	012585bb          	addw	a1,a1,s2
    80004228:	2585                	addw	a1,a1,1
    8000422a:	028a2503          	lw	a0,40(s4)
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	d12080e7          	jalr	-750(ra) # 80002f40 <bread>
    80004236:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004238:	000aa583          	lw	a1,0(s5)
    8000423c:	028a2503          	lw	a0,40(s4)
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	d00080e7          	jalr	-768(ra) # 80002f40 <bread>
    80004248:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000424a:	40000613          	li	a2,1024
    8000424e:	05850593          	add	a1,a0,88
    80004252:	05848513          	add	a0,s1,88
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	b48080e7          	jalr	-1208(ra) # 80000d9e <memmove>
    bwrite(to);  // write the log
    8000425e:	8526                	mv	a0,s1
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	dd2080e7          	jalr	-558(ra) # 80003032 <bwrite>
    brelse(from);
    80004268:	854e                	mv	a0,s3
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	e06080e7          	jalr	-506(ra) # 80003070 <brelse>
    brelse(to);
    80004272:	8526                	mv	a0,s1
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	dfc080e7          	jalr	-516(ra) # 80003070 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000427c:	2905                	addw	s2,s2,1
    8000427e:	0a91                	add	s5,s5,4
    80004280:	02ca2783          	lw	a5,44(s4)
    80004284:	f8f94ee3          	blt	s2,a5,80004220 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004288:	00000097          	auipc	ra,0x0
    8000428c:	c9c080e7          	jalr	-868(ra) # 80003f24 <write_head>
    install_trans(); // Now install writes to home locations
    80004290:	00000097          	auipc	ra,0x0
    80004294:	cfe080e7          	jalr	-770(ra) # 80003f8e <install_trans>
    log.lh.n = 0;
    80004298:	0001e797          	auipc	a5,0x1e
    8000429c:	8807ae23          	sw	zero,-1892(a5) # 80021b34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042a0:	00000097          	auipc	ra,0x0
    800042a4:	c84080e7          	jalr	-892(ra) # 80003f24 <write_head>
    800042a8:	bdfd                	j	800041a6 <end_op+0x52>

00000000800042aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042aa:	1101                	add	sp,sp,-32
    800042ac:	ec06                	sd	ra,24(sp)
    800042ae:	e822                	sd	s0,16(sp)
    800042b0:	e426                	sd	s1,8(sp)
    800042b2:	e04a                	sd	s2,0(sp)
    800042b4:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042b6:	0001e717          	auipc	a4,0x1e
    800042ba:	87e72703          	lw	a4,-1922(a4) # 80021b34 <log+0x2c>
    800042be:	47f5                	li	a5,29
    800042c0:	08e7c063          	blt	a5,a4,80004340 <log_write+0x96>
    800042c4:	84aa                	mv	s1,a0
    800042c6:	0001e797          	auipc	a5,0x1e
    800042ca:	85e7a783          	lw	a5,-1954(a5) # 80021b24 <log+0x1c>
    800042ce:	37fd                	addw	a5,a5,-1
    800042d0:	06f75863          	bge	a4,a5,80004340 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800042d4:	0001e797          	auipc	a5,0x1e
    800042d8:	8547a783          	lw	a5,-1964(a5) # 80021b28 <log+0x20>
    800042dc:	06f05a63          	blez	a5,80004350 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800042e0:	0001e917          	auipc	s2,0x1e
    800042e4:	82890913          	add	s2,s2,-2008 # 80021b08 <log>
    800042e8:	854a                	mv	a0,s2
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	95c080e7          	jalr	-1700(ra) # 80000c46 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800042f2:	02c92603          	lw	a2,44(s2)
    800042f6:	06c05563          	blez	a2,80004360 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042fa:	44cc                	lw	a1,12(s1)
    800042fc:	0001e717          	auipc	a4,0x1e
    80004300:	83c70713          	add	a4,a4,-1988 # 80021b38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004304:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004306:	4314                	lw	a3,0(a4)
    80004308:	04b68d63          	beq	a3,a1,80004362 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000430c:	2785                	addw	a5,a5,1
    8000430e:	0711                	add	a4,a4,4
    80004310:	fec79be3          	bne	a5,a2,80004306 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004314:	0621                	add	a2,a2,8
    80004316:	060a                	sll	a2,a2,0x2
    80004318:	0001d797          	auipc	a5,0x1d
    8000431c:	7f078793          	add	a5,a5,2032 # 80021b08 <log>
    80004320:	97b2                	add	a5,a5,a2
    80004322:	44d8                	lw	a4,12(s1)
    80004324:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004326:	8526                	mv	a0,s1
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	de4080e7          	jalr	-540(ra) # 8000310c <bpin>
    log.lh.n++;
    80004330:	0001d717          	auipc	a4,0x1d
    80004334:	7d870713          	add	a4,a4,2008 # 80021b08 <log>
    80004338:	575c                	lw	a5,44(a4)
    8000433a:	2785                	addw	a5,a5,1
    8000433c:	d75c                	sw	a5,44(a4)
    8000433e:	a835                	j	8000437a <log_write+0xd0>
    panic("too big a transaction");
    80004340:	00004517          	auipc	a0,0x4
    80004344:	47050513          	add	a0,a0,1136 # 800087b0 <syscall_names+0x200>
    80004348:	ffffc097          	auipc	ra,0xffffc
    8000434c:	1fa080e7          	jalr	506(ra) # 80000542 <panic>
    panic("log_write outside of trans");
    80004350:	00004517          	auipc	a0,0x4
    80004354:	47850513          	add	a0,a0,1144 # 800087c8 <syscall_names+0x218>
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	1ea080e7          	jalr	490(ra) # 80000542 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004360:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004362:	00878693          	add	a3,a5,8
    80004366:	068a                	sll	a3,a3,0x2
    80004368:	0001d717          	auipc	a4,0x1d
    8000436c:	7a070713          	add	a4,a4,1952 # 80021b08 <log>
    80004370:	9736                	add	a4,a4,a3
    80004372:	44d4                	lw	a3,12(s1)
    80004374:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004376:	faf608e3          	beq	a2,a5,80004326 <log_write+0x7c>
  }
  release(&log.lock);
    8000437a:	0001d517          	auipc	a0,0x1d
    8000437e:	78e50513          	add	a0,a0,1934 # 80021b08 <log>
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	978080e7          	jalr	-1672(ra) # 80000cfa <release>
}
    8000438a:	60e2                	ld	ra,24(sp)
    8000438c:	6442                	ld	s0,16(sp)
    8000438e:	64a2                	ld	s1,8(sp)
    80004390:	6902                	ld	s2,0(sp)
    80004392:	6105                	add	sp,sp,32
    80004394:	8082                	ret

0000000080004396 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004396:	1101                	add	sp,sp,-32
    80004398:	ec06                	sd	ra,24(sp)
    8000439a:	e822                	sd	s0,16(sp)
    8000439c:	e426                	sd	s1,8(sp)
    8000439e:	e04a                	sd	s2,0(sp)
    800043a0:	1000                	add	s0,sp,32
    800043a2:	84aa                	mv	s1,a0
    800043a4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043a6:	00004597          	auipc	a1,0x4
    800043aa:	44258593          	add	a1,a1,1090 # 800087e8 <syscall_names+0x238>
    800043ae:	0521                	add	a0,a0,8
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	806080e7          	jalr	-2042(ra) # 80000bb6 <initlock>
  lk->name = name;
    800043b8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043bc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043c0:	0204a423          	sw	zero,40(s1)
}
    800043c4:	60e2                	ld	ra,24(sp)
    800043c6:	6442                	ld	s0,16(sp)
    800043c8:	64a2                	ld	s1,8(sp)
    800043ca:	6902                	ld	s2,0(sp)
    800043cc:	6105                	add	sp,sp,32
    800043ce:	8082                	ret

00000000800043d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043d0:	1101                	add	sp,sp,-32
    800043d2:	ec06                	sd	ra,24(sp)
    800043d4:	e822                	sd	s0,16(sp)
    800043d6:	e426                	sd	s1,8(sp)
    800043d8:	e04a                	sd	s2,0(sp)
    800043da:	1000                	add	s0,sp,32
    800043dc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043de:	00850913          	add	s2,a0,8
    800043e2:	854a                	mv	a0,s2
    800043e4:	ffffd097          	auipc	ra,0xffffd
    800043e8:	862080e7          	jalr	-1950(ra) # 80000c46 <acquire>
  while (lk->locked) {
    800043ec:	409c                	lw	a5,0(s1)
    800043ee:	cb89                	beqz	a5,80004400 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800043f0:	85ca                	mv	a1,s2
    800043f2:	8526                	mv	a0,s1
    800043f4:	ffffe097          	auipc	ra,0xffffe
    800043f8:	e38080e7          	jalr	-456(ra) # 8000222c <sleep>
  while (lk->locked) {
    800043fc:	409c                	lw	a5,0(s1)
    800043fe:	fbed                	bnez	a5,800043f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004400:	4785                	li	a5,1
    80004402:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	60c080e7          	jalr	1548(ra) # 80001a10 <myproc>
    8000440c:	5d1c                	lw	a5,56(a0)
    8000440e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004410:	854a                	mv	a0,s2
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	8e8080e7          	jalr	-1816(ra) # 80000cfa <release>
}
    8000441a:	60e2                	ld	ra,24(sp)
    8000441c:	6442                	ld	s0,16(sp)
    8000441e:	64a2                	ld	s1,8(sp)
    80004420:	6902                	ld	s2,0(sp)
    80004422:	6105                	add	sp,sp,32
    80004424:	8082                	ret

0000000080004426 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004426:	1101                	add	sp,sp,-32
    80004428:	ec06                	sd	ra,24(sp)
    8000442a:	e822                	sd	s0,16(sp)
    8000442c:	e426                	sd	s1,8(sp)
    8000442e:	e04a                	sd	s2,0(sp)
    80004430:	1000                	add	s0,sp,32
    80004432:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004434:	00850913          	add	s2,a0,8
    80004438:	854a                	mv	a0,s2
    8000443a:	ffffd097          	auipc	ra,0xffffd
    8000443e:	80c080e7          	jalr	-2036(ra) # 80000c46 <acquire>
  lk->locked = 0;
    80004442:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004446:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000444a:	8526                	mv	a0,s1
    8000444c:	ffffe097          	auipc	ra,0xffffe
    80004450:	f60080e7          	jalr	-160(ra) # 800023ac <wakeup>
  release(&lk->lk);
    80004454:	854a                	mv	a0,s2
    80004456:	ffffd097          	auipc	ra,0xffffd
    8000445a:	8a4080e7          	jalr	-1884(ra) # 80000cfa <release>
}
    8000445e:	60e2                	ld	ra,24(sp)
    80004460:	6442                	ld	s0,16(sp)
    80004462:	64a2                	ld	s1,8(sp)
    80004464:	6902                	ld	s2,0(sp)
    80004466:	6105                	add	sp,sp,32
    80004468:	8082                	ret

000000008000446a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000446a:	7179                	add	sp,sp,-48
    8000446c:	f406                	sd	ra,40(sp)
    8000446e:	f022                	sd	s0,32(sp)
    80004470:	ec26                	sd	s1,24(sp)
    80004472:	e84a                	sd	s2,16(sp)
    80004474:	e44e                	sd	s3,8(sp)
    80004476:	1800                	add	s0,sp,48
    80004478:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000447a:	00850913          	add	s2,a0,8
    8000447e:	854a                	mv	a0,s2
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	7c6080e7          	jalr	1990(ra) # 80000c46 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004488:	409c                	lw	a5,0(s1)
    8000448a:	ef99                	bnez	a5,800044a8 <holdingsleep+0x3e>
    8000448c:	4481                	li	s1,0
  release(&lk->lk);
    8000448e:	854a                	mv	a0,s2
    80004490:	ffffd097          	auipc	ra,0xffffd
    80004494:	86a080e7          	jalr	-1942(ra) # 80000cfa <release>
  return r;
}
    80004498:	8526                	mv	a0,s1
    8000449a:	70a2                	ld	ra,40(sp)
    8000449c:	7402                	ld	s0,32(sp)
    8000449e:	64e2                	ld	s1,24(sp)
    800044a0:	6942                	ld	s2,16(sp)
    800044a2:	69a2                	ld	s3,8(sp)
    800044a4:	6145                	add	sp,sp,48
    800044a6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044a8:	0284a983          	lw	s3,40(s1)
    800044ac:	ffffd097          	auipc	ra,0xffffd
    800044b0:	564080e7          	jalr	1380(ra) # 80001a10 <myproc>
    800044b4:	5d04                	lw	s1,56(a0)
    800044b6:	413484b3          	sub	s1,s1,s3
    800044ba:	0014b493          	seqz	s1,s1
    800044be:	bfc1                	j	8000448e <holdingsleep+0x24>

00000000800044c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044c0:	1141                	add	sp,sp,-16
    800044c2:	e406                	sd	ra,8(sp)
    800044c4:	e022                	sd	s0,0(sp)
    800044c6:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044c8:	00004597          	auipc	a1,0x4
    800044cc:	33058593          	add	a1,a1,816 # 800087f8 <syscall_names+0x248>
    800044d0:	0001d517          	auipc	a0,0x1d
    800044d4:	78050513          	add	a0,a0,1920 # 80021c50 <ftable>
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	6de080e7          	jalr	1758(ra) # 80000bb6 <initlock>
}
    800044e0:	60a2                	ld	ra,8(sp)
    800044e2:	6402                	ld	s0,0(sp)
    800044e4:	0141                	add	sp,sp,16
    800044e6:	8082                	ret

00000000800044e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800044e8:	1101                	add	sp,sp,-32
    800044ea:	ec06                	sd	ra,24(sp)
    800044ec:	e822                	sd	s0,16(sp)
    800044ee:	e426                	sd	s1,8(sp)
    800044f0:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800044f2:	0001d517          	auipc	a0,0x1d
    800044f6:	75e50513          	add	a0,a0,1886 # 80021c50 <ftable>
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	74c080e7          	jalr	1868(ra) # 80000c46 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004502:	0001d497          	auipc	s1,0x1d
    80004506:	76648493          	add	s1,s1,1894 # 80021c68 <ftable+0x18>
    8000450a:	0001e717          	auipc	a4,0x1e
    8000450e:	6fe70713          	add	a4,a4,1790 # 80022c08 <ftable+0xfb8>
    if(f->ref == 0){
    80004512:	40dc                	lw	a5,4(s1)
    80004514:	cf99                	beqz	a5,80004532 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004516:	02848493          	add	s1,s1,40
    8000451a:	fee49ce3          	bne	s1,a4,80004512 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000451e:	0001d517          	auipc	a0,0x1d
    80004522:	73250513          	add	a0,a0,1842 # 80021c50 <ftable>
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	7d4080e7          	jalr	2004(ra) # 80000cfa <release>
  return 0;
    8000452e:	4481                	li	s1,0
    80004530:	a819                	j	80004546 <filealloc+0x5e>
      f->ref = 1;
    80004532:	4785                	li	a5,1
    80004534:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004536:	0001d517          	auipc	a0,0x1d
    8000453a:	71a50513          	add	a0,a0,1818 # 80021c50 <ftable>
    8000453e:	ffffc097          	auipc	ra,0xffffc
    80004542:	7bc080e7          	jalr	1980(ra) # 80000cfa <release>
}
    80004546:	8526                	mv	a0,s1
    80004548:	60e2                	ld	ra,24(sp)
    8000454a:	6442                	ld	s0,16(sp)
    8000454c:	64a2                	ld	s1,8(sp)
    8000454e:	6105                	add	sp,sp,32
    80004550:	8082                	ret

0000000080004552 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004552:	1101                	add	sp,sp,-32
    80004554:	ec06                	sd	ra,24(sp)
    80004556:	e822                	sd	s0,16(sp)
    80004558:	e426                	sd	s1,8(sp)
    8000455a:	1000                	add	s0,sp,32
    8000455c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000455e:	0001d517          	auipc	a0,0x1d
    80004562:	6f250513          	add	a0,a0,1778 # 80021c50 <ftable>
    80004566:	ffffc097          	auipc	ra,0xffffc
    8000456a:	6e0080e7          	jalr	1760(ra) # 80000c46 <acquire>
  if(f->ref < 1)
    8000456e:	40dc                	lw	a5,4(s1)
    80004570:	02f05263          	blez	a5,80004594 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004574:	2785                	addw	a5,a5,1
    80004576:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004578:	0001d517          	auipc	a0,0x1d
    8000457c:	6d850513          	add	a0,a0,1752 # 80021c50 <ftable>
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	77a080e7          	jalr	1914(ra) # 80000cfa <release>
  return f;
}
    80004588:	8526                	mv	a0,s1
    8000458a:	60e2                	ld	ra,24(sp)
    8000458c:	6442                	ld	s0,16(sp)
    8000458e:	64a2                	ld	s1,8(sp)
    80004590:	6105                	add	sp,sp,32
    80004592:	8082                	ret
    panic("filedup");
    80004594:	00004517          	auipc	a0,0x4
    80004598:	26c50513          	add	a0,a0,620 # 80008800 <syscall_names+0x250>
    8000459c:	ffffc097          	auipc	ra,0xffffc
    800045a0:	fa6080e7          	jalr	-90(ra) # 80000542 <panic>

00000000800045a4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045a4:	7139                	add	sp,sp,-64
    800045a6:	fc06                	sd	ra,56(sp)
    800045a8:	f822                	sd	s0,48(sp)
    800045aa:	f426                	sd	s1,40(sp)
    800045ac:	f04a                	sd	s2,32(sp)
    800045ae:	ec4e                	sd	s3,24(sp)
    800045b0:	e852                	sd	s4,16(sp)
    800045b2:	e456                	sd	s5,8(sp)
    800045b4:	0080                	add	s0,sp,64
    800045b6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045b8:	0001d517          	auipc	a0,0x1d
    800045bc:	69850513          	add	a0,a0,1688 # 80021c50 <ftable>
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	686080e7          	jalr	1670(ra) # 80000c46 <acquire>
  if(f->ref < 1)
    800045c8:	40dc                	lw	a5,4(s1)
    800045ca:	06f05163          	blez	a5,8000462c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045ce:	37fd                	addw	a5,a5,-1
    800045d0:	0007871b          	sext.w	a4,a5
    800045d4:	c0dc                	sw	a5,4(s1)
    800045d6:	06e04363          	bgtz	a4,8000463c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045da:	0004a903          	lw	s2,0(s1)
    800045de:	0094ca83          	lbu	s5,9(s1)
    800045e2:	0104ba03          	ld	s4,16(s1)
    800045e6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800045ea:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800045ee:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800045f2:	0001d517          	auipc	a0,0x1d
    800045f6:	65e50513          	add	a0,a0,1630 # 80021c50 <ftable>
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	700080e7          	jalr	1792(ra) # 80000cfa <release>

  if(ff.type == FD_PIPE){
    80004602:	4785                	li	a5,1
    80004604:	04f90d63          	beq	s2,a5,8000465e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004608:	3979                	addw	s2,s2,-2
    8000460a:	4785                	li	a5,1
    8000460c:	0527e063          	bltu	a5,s2,8000464c <fileclose+0xa8>
    begin_op();
    80004610:	00000097          	auipc	ra,0x0
    80004614:	aca080e7          	jalr	-1334(ra) # 800040da <begin_op>
    iput(ff.ip);
    80004618:	854e                	mv	a0,s3
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	2da080e7          	jalr	730(ra) # 800038f4 <iput>
    end_op();
    80004622:	00000097          	auipc	ra,0x0
    80004626:	b32080e7          	jalr	-1230(ra) # 80004154 <end_op>
    8000462a:	a00d                	j	8000464c <fileclose+0xa8>
    panic("fileclose");
    8000462c:	00004517          	auipc	a0,0x4
    80004630:	1dc50513          	add	a0,a0,476 # 80008808 <syscall_names+0x258>
    80004634:	ffffc097          	auipc	ra,0xffffc
    80004638:	f0e080e7          	jalr	-242(ra) # 80000542 <panic>
    release(&ftable.lock);
    8000463c:	0001d517          	auipc	a0,0x1d
    80004640:	61450513          	add	a0,a0,1556 # 80021c50 <ftable>
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	6b6080e7          	jalr	1718(ra) # 80000cfa <release>
  }
}
    8000464c:	70e2                	ld	ra,56(sp)
    8000464e:	7442                	ld	s0,48(sp)
    80004650:	74a2                	ld	s1,40(sp)
    80004652:	7902                	ld	s2,32(sp)
    80004654:	69e2                	ld	s3,24(sp)
    80004656:	6a42                	ld	s4,16(sp)
    80004658:	6aa2                	ld	s5,8(sp)
    8000465a:	6121                	add	sp,sp,64
    8000465c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000465e:	85d6                	mv	a1,s5
    80004660:	8552                	mv	a0,s4
    80004662:	00000097          	auipc	ra,0x0
    80004666:	372080e7          	jalr	882(ra) # 800049d4 <pipeclose>
    8000466a:	b7cd                	j	8000464c <fileclose+0xa8>

000000008000466c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000466c:	715d                	add	sp,sp,-80
    8000466e:	e486                	sd	ra,72(sp)
    80004670:	e0a2                	sd	s0,64(sp)
    80004672:	fc26                	sd	s1,56(sp)
    80004674:	f84a                	sd	s2,48(sp)
    80004676:	f44e                	sd	s3,40(sp)
    80004678:	0880                	add	s0,sp,80
    8000467a:	84aa                	mv	s1,a0
    8000467c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000467e:	ffffd097          	auipc	ra,0xffffd
    80004682:	392080e7          	jalr	914(ra) # 80001a10 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004686:	409c                	lw	a5,0(s1)
    80004688:	37f9                	addw	a5,a5,-2
    8000468a:	4705                	li	a4,1
    8000468c:	04f76763          	bltu	a4,a5,800046da <filestat+0x6e>
    80004690:	892a                	mv	s2,a0
    ilock(f->ip);
    80004692:	6c88                	ld	a0,24(s1)
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	0a6080e7          	jalr	166(ra) # 8000373a <ilock>
    stati(f->ip, &st);
    8000469c:	fb840593          	add	a1,s0,-72
    800046a0:	6c88                	ld	a0,24(s1)
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	322080e7          	jalr	802(ra) # 800039c4 <stati>
    iunlock(f->ip);
    800046aa:	6c88                	ld	a0,24(s1)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	150080e7          	jalr	336(ra) # 800037fc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046b4:	46e1                	li	a3,24
    800046b6:	fb840613          	add	a2,s0,-72
    800046ba:	85ce                	mv	a1,s3
    800046bc:	05093503          	ld	a0,80(s2)
    800046c0:	ffffd097          	auipc	ra,0xffffd
    800046c4:	046080e7          	jalr	70(ra) # 80001706 <copyout>
    800046c8:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046cc:	60a6                	ld	ra,72(sp)
    800046ce:	6406                	ld	s0,64(sp)
    800046d0:	74e2                	ld	s1,56(sp)
    800046d2:	7942                	ld	s2,48(sp)
    800046d4:	79a2                	ld	s3,40(sp)
    800046d6:	6161                	add	sp,sp,80
    800046d8:	8082                	ret
  return -1;
    800046da:	557d                	li	a0,-1
    800046dc:	bfc5                	j	800046cc <filestat+0x60>

00000000800046de <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800046de:	7179                	add	sp,sp,-48
    800046e0:	f406                	sd	ra,40(sp)
    800046e2:	f022                	sd	s0,32(sp)
    800046e4:	ec26                	sd	s1,24(sp)
    800046e6:	e84a                	sd	s2,16(sp)
    800046e8:	e44e                	sd	s3,8(sp)
    800046ea:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800046ec:	00854783          	lbu	a5,8(a0)
    800046f0:	c3d5                	beqz	a5,80004794 <fileread+0xb6>
    800046f2:	84aa                	mv	s1,a0
    800046f4:	89ae                	mv	s3,a1
    800046f6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800046f8:	411c                	lw	a5,0(a0)
    800046fa:	4705                	li	a4,1
    800046fc:	04e78963          	beq	a5,a4,8000474e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004700:	470d                	li	a4,3
    80004702:	04e78d63          	beq	a5,a4,8000475c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004706:	4709                	li	a4,2
    80004708:	06e79e63          	bne	a5,a4,80004784 <fileread+0xa6>
    ilock(f->ip);
    8000470c:	6d08                	ld	a0,24(a0)
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	02c080e7          	jalr	44(ra) # 8000373a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004716:	874a                	mv	a4,s2
    80004718:	5094                	lw	a3,32(s1)
    8000471a:	864e                	mv	a2,s3
    8000471c:	4585                	li	a1,1
    8000471e:	6c88                	ld	a0,24(s1)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	2ce080e7          	jalr	718(ra) # 800039ee <readi>
    80004728:	892a                	mv	s2,a0
    8000472a:	00a05563          	blez	a0,80004734 <fileread+0x56>
      f->off += r;
    8000472e:	509c                	lw	a5,32(s1)
    80004730:	9fa9                	addw	a5,a5,a0
    80004732:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004734:	6c88                	ld	a0,24(s1)
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	0c6080e7          	jalr	198(ra) # 800037fc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000473e:	854a                	mv	a0,s2
    80004740:	70a2                	ld	ra,40(sp)
    80004742:	7402                	ld	s0,32(sp)
    80004744:	64e2                	ld	s1,24(sp)
    80004746:	6942                	ld	s2,16(sp)
    80004748:	69a2                	ld	s3,8(sp)
    8000474a:	6145                	add	sp,sp,48
    8000474c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000474e:	6908                	ld	a0,16(a0)
    80004750:	00000097          	auipc	ra,0x0
    80004754:	3ee080e7          	jalr	1006(ra) # 80004b3e <piperead>
    80004758:	892a                	mv	s2,a0
    8000475a:	b7d5                	j	8000473e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000475c:	02451783          	lh	a5,36(a0)
    80004760:	03079693          	sll	a3,a5,0x30
    80004764:	92c1                	srl	a3,a3,0x30
    80004766:	4725                	li	a4,9
    80004768:	02d76863          	bltu	a4,a3,80004798 <fileread+0xba>
    8000476c:	0792                	sll	a5,a5,0x4
    8000476e:	0001d717          	auipc	a4,0x1d
    80004772:	44270713          	add	a4,a4,1090 # 80021bb0 <devsw>
    80004776:	97ba                	add	a5,a5,a4
    80004778:	639c                	ld	a5,0(a5)
    8000477a:	c38d                	beqz	a5,8000479c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000477c:	4505                	li	a0,1
    8000477e:	9782                	jalr	a5
    80004780:	892a                	mv	s2,a0
    80004782:	bf75                	j	8000473e <fileread+0x60>
    panic("fileread");
    80004784:	00004517          	auipc	a0,0x4
    80004788:	09450513          	add	a0,a0,148 # 80008818 <syscall_names+0x268>
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	db6080e7          	jalr	-586(ra) # 80000542 <panic>
    return -1;
    80004794:	597d                	li	s2,-1
    80004796:	b765                	j	8000473e <fileread+0x60>
      return -1;
    80004798:	597d                	li	s2,-1
    8000479a:	b755                	j	8000473e <fileread+0x60>
    8000479c:	597d                	li	s2,-1
    8000479e:	b745                	j	8000473e <fileread+0x60>

00000000800047a0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047a0:	00954783          	lbu	a5,9(a0)
    800047a4:	14078363          	beqz	a5,800048ea <filewrite+0x14a>
{
    800047a8:	715d                	add	sp,sp,-80
    800047aa:	e486                	sd	ra,72(sp)
    800047ac:	e0a2                	sd	s0,64(sp)
    800047ae:	fc26                	sd	s1,56(sp)
    800047b0:	f84a                	sd	s2,48(sp)
    800047b2:	f44e                	sd	s3,40(sp)
    800047b4:	f052                	sd	s4,32(sp)
    800047b6:	ec56                	sd	s5,24(sp)
    800047b8:	e85a                	sd	s6,16(sp)
    800047ba:	e45e                	sd	s7,8(sp)
    800047bc:	e062                	sd	s8,0(sp)
    800047be:	0880                	add	s0,sp,80
    800047c0:	892a                	mv	s2,a0
    800047c2:	8b2e                	mv	s6,a1
    800047c4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047c6:	411c                	lw	a5,0(a0)
    800047c8:	4705                	li	a4,1
    800047ca:	02e78263          	beq	a5,a4,800047ee <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047ce:	470d                	li	a4,3
    800047d0:	02e78563          	beq	a5,a4,800047fa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800047d4:	4709                	li	a4,2
    800047d6:	10e79263          	bne	a5,a4,800048da <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047da:	0ec05e63          	blez	a2,800048d6 <filewrite+0x136>
    int i = 0;
    800047de:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800047e0:	6b85                	lui	s7,0x1
    800047e2:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800047e6:	6c05                	lui	s8,0x1
    800047e8:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800047ec:	a851                	j	80004880 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800047ee:	6908                	ld	a0,16(a0)
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	254080e7          	jalr	596(ra) # 80004a44 <pipewrite>
    800047f8:	a85d                	j	800048ae <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800047fa:	02451783          	lh	a5,36(a0)
    800047fe:	03079693          	sll	a3,a5,0x30
    80004802:	92c1                	srl	a3,a3,0x30
    80004804:	4725                	li	a4,9
    80004806:	0ed76463          	bltu	a4,a3,800048ee <filewrite+0x14e>
    8000480a:	0792                	sll	a5,a5,0x4
    8000480c:	0001d717          	auipc	a4,0x1d
    80004810:	3a470713          	add	a4,a4,932 # 80021bb0 <devsw>
    80004814:	97ba                	add	a5,a5,a4
    80004816:	679c                	ld	a5,8(a5)
    80004818:	cfe9                	beqz	a5,800048f2 <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    8000481a:	4505                	li	a0,1
    8000481c:	9782                	jalr	a5
    8000481e:	a841                	j	800048ae <filewrite+0x10e>
      if(n1 > max)
    80004820:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004824:	00000097          	auipc	ra,0x0
    80004828:	8b6080e7          	jalr	-1866(ra) # 800040da <begin_op>
      ilock(f->ip);
    8000482c:	01893503          	ld	a0,24(s2)
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	f0a080e7          	jalr	-246(ra) # 8000373a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004838:	8756                	mv	a4,s5
    8000483a:	02092683          	lw	a3,32(s2)
    8000483e:	01698633          	add	a2,s3,s6
    80004842:	4585                	li	a1,1
    80004844:	01893503          	ld	a0,24(s2)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	29c080e7          	jalr	668(ra) # 80003ae4 <writei>
    80004850:	84aa                	mv	s1,a0
    80004852:	02a05f63          	blez	a0,80004890 <filewrite+0xf0>
        f->off += r;
    80004856:	02092783          	lw	a5,32(s2)
    8000485a:	9fa9                	addw	a5,a5,a0
    8000485c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004860:	01893503          	ld	a0,24(s2)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	f98080e7          	jalr	-104(ra) # 800037fc <iunlock>
      end_op();
    8000486c:	00000097          	auipc	ra,0x0
    80004870:	8e8080e7          	jalr	-1816(ra) # 80004154 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004874:	049a9963          	bne	s5,s1,800048c6 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004878:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000487c:	0349d663          	bge	s3,s4,800048a8 <filewrite+0x108>
      int n1 = n - i;
    80004880:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004884:	0004879b          	sext.w	a5,s1
    80004888:	f8fbdce3          	bge	s7,a5,80004820 <filewrite+0x80>
    8000488c:	84e2                	mv	s1,s8
    8000488e:	bf49                	j	80004820 <filewrite+0x80>
      iunlock(f->ip);
    80004890:	01893503          	ld	a0,24(s2)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	f68080e7          	jalr	-152(ra) # 800037fc <iunlock>
      end_op();
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	8b8080e7          	jalr	-1864(ra) # 80004154 <end_op>
      if(r < 0)
    800048a4:	fc04d8e3          	bgez	s1,80004874 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    800048a8:	053a1763          	bne	s4,s3,800048f6 <filewrite+0x156>
    800048ac:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048ae:	60a6                	ld	ra,72(sp)
    800048b0:	6406                	ld	s0,64(sp)
    800048b2:	74e2                	ld	s1,56(sp)
    800048b4:	7942                	ld	s2,48(sp)
    800048b6:	79a2                	ld	s3,40(sp)
    800048b8:	7a02                	ld	s4,32(sp)
    800048ba:	6ae2                	ld	s5,24(sp)
    800048bc:	6b42                	ld	s6,16(sp)
    800048be:	6ba2                	ld	s7,8(sp)
    800048c0:	6c02                	ld	s8,0(sp)
    800048c2:	6161                	add	sp,sp,80
    800048c4:	8082                	ret
        panic("short filewrite");
    800048c6:	00004517          	auipc	a0,0x4
    800048ca:	f6250513          	add	a0,a0,-158 # 80008828 <syscall_names+0x278>
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	c74080e7          	jalr	-908(ra) # 80000542 <panic>
    int i = 0;
    800048d6:	4981                	li	s3,0
    800048d8:	bfc1                	j	800048a8 <filewrite+0x108>
    panic("filewrite");
    800048da:	00004517          	auipc	a0,0x4
    800048de:	f5e50513          	add	a0,a0,-162 # 80008838 <syscall_names+0x288>
    800048e2:	ffffc097          	auipc	ra,0xffffc
    800048e6:	c60080e7          	jalr	-928(ra) # 80000542 <panic>
    return -1;
    800048ea:	557d                	li	a0,-1
}
    800048ec:	8082                	ret
      return -1;
    800048ee:	557d                	li	a0,-1
    800048f0:	bf7d                	j	800048ae <filewrite+0x10e>
    800048f2:	557d                	li	a0,-1
    800048f4:	bf6d                	j	800048ae <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800048f6:	557d                	li	a0,-1
    800048f8:	bf5d                	j	800048ae <filewrite+0x10e>

00000000800048fa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800048fa:	7179                	add	sp,sp,-48
    800048fc:	f406                	sd	ra,40(sp)
    800048fe:	f022                	sd	s0,32(sp)
    80004900:	ec26                	sd	s1,24(sp)
    80004902:	e84a                	sd	s2,16(sp)
    80004904:	e44e                	sd	s3,8(sp)
    80004906:	e052                	sd	s4,0(sp)
    80004908:	1800                	add	s0,sp,48
    8000490a:	84aa                	mv	s1,a0
    8000490c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000490e:	0005b023          	sd	zero,0(a1)
    80004912:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	bd2080e7          	jalr	-1070(ra) # 800044e8 <filealloc>
    8000491e:	e088                	sd	a0,0(s1)
    80004920:	c551                	beqz	a0,800049ac <pipealloc+0xb2>
    80004922:	00000097          	auipc	ra,0x0
    80004926:	bc6080e7          	jalr	-1082(ra) # 800044e8 <filealloc>
    8000492a:	00aa3023          	sd	a0,0(s4)
    8000492e:	c92d                	beqz	a0,800049a0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004930:	ffffc097          	auipc	ra,0xffffc
    80004934:	1dc080e7          	jalr	476(ra) # 80000b0c <kalloc>
    80004938:	892a                	mv	s2,a0
    8000493a:	c125                	beqz	a0,8000499a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000493c:	4985                	li	s3,1
    8000493e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004942:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004946:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000494a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000494e:	00004597          	auipc	a1,0x4
    80004952:	af258593          	add	a1,a1,-1294 # 80008440 <states.0+0x198>
    80004956:	ffffc097          	auipc	ra,0xffffc
    8000495a:	260080e7          	jalr	608(ra) # 80000bb6 <initlock>
  (*f0)->type = FD_PIPE;
    8000495e:	609c                	ld	a5,0(s1)
    80004960:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004964:	609c                	ld	a5,0(s1)
    80004966:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000496a:	609c                	ld	a5,0(s1)
    8000496c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004970:	609c                	ld	a5,0(s1)
    80004972:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004976:	000a3783          	ld	a5,0(s4)
    8000497a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000497e:	000a3783          	ld	a5,0(s4)
    80004982:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004986:	000a3783          	ld	a5,0(s4)
    8000498a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000498e:	000a3783          	ld	a5,0(s4)
    80004992:	0127b823          	sd	s2,16(a5)
  return 0;
    80004996:	4501                	li	a0,0
    80004998:	a025                	j	800049c0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000499a:	6088                	ld	a0,0(s1)
    8000499c:	e501                	bnez	a0,800049a4 <pipealloc+0xaa>
    8000499e:	a039                	j	800049ac <pipealloc+0xb2>
    800049a0:	6088                	ld	a0,0(s1)
    800049a2:	c51d                	beqz	a0,800049d0 <pipealloc+0xd6>
    fileclose(*f0);
    800049a4:	00000097          	auipc	ra,0x0
    800049a8:	c00080e7          	jalr	-1024(ra) # 800045a4 <fileclose>
  if(*f1)
    800049ac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049b0:	557d                	li	a0,-1
  if(*f1)
    800049b2:	c799                	beqz	a5,800049c0 <pipealloc+0xc6>
    fileclose(*f1);
    800049b4:	853e                	mv	a0,a5
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	bee080e7          	jalr	-1042(ra) # 800045a4 <fileclose>
  return -1;
    800049be:	557d                	li	a0,-1
}
    800049c0:	70a2                	ld	ra,40(sp)
    800049c2:	7402                	ld	s0,32(sp)
    800049c4:	64e2                	ld	s1,24(sp)
    800049c6:	6942                	ld	s2,16(sp)
    800049c8:	69a2                	ld	s3,8(sp)
    800049ca:	6a02                	ld	s4,0(sp)
    800049cc:	6145                	add	sp,sp,48
    800049ce:	8082                	ret
  return -1;
    800049d0:	557d                	li	a0,-1
    800049d2:	b7fd                	j	800049c0 <pipealloc+0xc6>

00000000800049d4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049d4:	1101                	add	sp,sp,-32
    800049d6:	ec06                	sd	ra,24(sp)
    800049d8:	e822                	sd	s0,16(sp)
    800049da:	e426                	sd	s1,8(sp)
    800049dc:	e04a                	sd	s2,0(sp)
    800049de:	1000                	add	s0,sp,32
    800049e0:	84aa                	mv	s1,a0
    800049e2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049e4:	ffffc097          	auipc	ra,0xffffc
    800049e8:	262080e7          	jalr	610(ra) # 80000c46 <acquire>
  if(writable){
    800049ec:	02090d63          	beqz	s2,80004a26 <pipeclose+0x52>
    pi->writeopen = 0;
    800049f0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049f4:	21848513          	add	a0,s1,536
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	9b4080e7          	jalr	-1612(ra) # 800023ac <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a00:	2204b783          	ld	a5,544(s1)
    80004a04:	eb95                	bnez	a5,80004a38 <pipeclose+0x64>
    release(&pi->lock);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	2f2080e7          	jalr	754(ra) # 80000cfa <release>
    kfree((char*)pi);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	ffc080e7          	jalr	-4(ra) # 80000a0e <kfree>
  } else
    release(&pi->lock);
}
    80004a1a:	60e2                	ld	ra,24(sp)
    80004a1c:	6442                	ld	s0,16(sp)
    80004a1e:	64a2                	ld	s1,8(sp)
    80004a20:	6902                	ld	s2,0(sp)
    80004a22:	6105                	add	sp,sp,32
    80004a24:	8082                	ret
    pi->readopen = 0;
    80004a26:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a2a:	21c48513          	add	a0,s1,540
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	97e080e7          	jalr	-1666(ra) # 800023ac <wakeup>
    80004a36:	b7e9                	j	80004a00 <pipeclose+0x2c>
    release(&pi->lock);
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffc097          	auipc	ra,0xffffc
    80004a3e:	2c0080e7          	jalr	704(ra) # 80000cfa <release>
}
    80004a42:	bfe1                	j	80004a1a <pipeclose+0x46>

0000000080004a44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a44:	711d                	add	sp,sp,-96
    80004a46:	ec86                	sd	ra,88(sp)
    80004a48:	e8a2                	sd	s0,80(sp)
    80004a4a:	e4a6                	sd	s1,72(sp)
    80004a4c:	e0ca                	sd	s2,64(sp)
    80004a4e:	fc4e                	sd	s3,56(sp)
    80004a50:	f852                	sd	s4,48(sp)
    80004a52:	f456                	sd	s5,40(sp)
    80004a54:	f05a                	sd	s6,32(sp)
    80004a56:	ec5e                	sd	s7,24(sp)
    80004a58:	1080                	add	s0,sp,96
    80004a5a:	84aa                	mv	s1,a0
    80004a5c:	8b2e                	mv	s6,a1
    80004a5e:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004a60:	ffffd097          	auipc	ra,0xffffd
    80004a64:	fb0080e7          	jalr	-80(ra) # 80001a10 <myproc>
    80004a68:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffc097          	auipc	ra,0xffffc
    80004a70:	1da080e7          	jalr	474(ra) # 80000c46 <acquire>
  for(i = 0; i < n; i++){
    80004a74:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004a76:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a7a:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    80004a7e:	09505263          	blez	s5,80004b02 <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a82:	2184a783          	lw	a5,536(s1)
    80004a86:	21c4a703          	lw	a4,540(s1)
    80004a8a:	2007879b          	addw	a5,a5,512
    80004a8e:	02f71b63          	bne	a4,a5,80004ac4 <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    80004a92:	2204a783          	lw	a5,544(s1)
    80004a96:	c3d1                	beqz	a5,80004b1a <pipewrite+0xd6>
    80004a98:	03092783          	lw	a5,48(s2)
    80004a9c:	efbd                	bnez	a5,80004b1a <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004a9e:	8552                	mv	a0,s4
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	90c080e7          	jalr	-1780(ra) # 800023ac <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004aa8:	85a6                	mv	a1,s1
    80004aaa:	854e                	mv	a0,s3
    80004aac:	ffffd097          	auipc	ra,0xffffd
    80004ab0:	780080e7          	jalr	1920(ra) # 8000222c <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ab4:	2184a783          	lw	a5,536(s1)
    80004ab8:	21c4a703          	lw	a4,540(s1)
    80004abc:	2007879b          	addw	a5,a5,512
    80004ac0:	fcf709e3          	beq	a4,a5,80004a92 <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ac4:	4685                	li	a3,1
    80004ac6:	865a                	mv	a2,s6
    80004ac8:	faf40593          	add	a1,s0,-81
    80004acc:	05093503          	ld	a0,80(s2)
    80004ad0:	ffffd097          	auipc	ra,0xffffd
    80004ad4:	cc2080e7          	jalr	-830(ra) # 80001792 <copyin>
    80004ad8:	57fd                	li	a5,-1
    80004ada:	02f50463          	beq	a0,a5,80004b02 <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ade:	21c4a783          	lw	a5,540(s1)
    80004ae2:	0017871b          	addw	a4,a5,1
    80004ae6:	20e4ae23          	sw	a4,540(s1)
    80004aea:	1ff7f793          	and	a5,a5,511
    80004aee:	97a6                	add	a5,a5,s1
    80004af0:	faf44703          	lbu	a4,-81(s0)
    80004af4:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004af8:	2b85                	addw	s7,s7,1
    80004afa:	0b05                	add	s6,s6,1
    80004afc:	f97a93e3          	bne	s5,s7,80004a82 <pipewrite+0x3e>
    80004b00:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    80004b02:	21848513          	add	a0,s1,536
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	8a6080e7          	jalr	-1882(ra) # 800023ac <wakeup>
  release(&pi->lock);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffc097          	auipc	ra,0xffffc
    80004b14:	1ea080e7          	jalr	490(ra) # 80000cfa <release>
  return i;
    80004b18:	a039                	j	80004b26 <pipewrite+0xe2>
        release(&pi->lock);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffc097          	auipc	ra,0xffffc
    80004b20:	1de080e7          	jalr	478(ra) # 80000cfa <release>
        return -1;
    80004b24:	5bfd                	li	s7,-1
}
    80004b26:	855e                	mv	a0,s7
    80004b28:	60e6                	ld	ra,88(sp)
    80004b2a:	6446                	ld	s0,80(sp)
    80004b2c:	64a6                	ld	s1,72(sp)
    80004b2e:	6906                	ld	s2,64(sp)
    80004b30:	79e2                	ld	s3,56(sp)
    80004b32:	7a42                	ld	s4,48(sp)
    80004b34:	7aa2                	ld	s5,40(sp)
    80004b36:	7b02                	ld	s6,32(sp)
    80004b38:	6be2                	ld	s7,24(sp)
    80004b3a:	6125                	add	sp,sp,96
    80004b3c:	8082                	ret

0000000080004b3e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b3e:	715d                	add	sp,sp,-80
    80004b40:	e486                	sd	ra,72(sp)
    80004b42:	e0a2                	sd	s0,64(sp)
    80004b44:	fc26                	sd	s1,56(sp)
    80004b46:	f84a                	sd	s2,48(sp)
    80004b48:	f44e                	sd	s3,40(sp)
    80004b4a:	f052                	sd	s4,32(sp)
    80004b4c:	ec56                	sd	s5,24(sp)
    80004b4e:	e85a                	sd	s6,16(sp)
    80004b50:	0880                	add	s0,sp,80
    80004b52:	84aa                	mv	s1,a0
    80004b54:	892e                	mv	s2,a1
    80004b56:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b58:	ffffd097          	auipc	ra,0xffffd
    80004b5c:	eb8080e7          	jalr	-328(ra) # 80001a10 <myproc>
    80004b60:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b62:	8526                	mv	a0,s1
    80004b64:	ffffc097          	auipc	ra,0xffffc
    80004b68:	0e2080e7          	jalr	226(ra) # 80000c46 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b6c:	2184a703          	lw	a4,536(s1)
    80004b70:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b74:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b78:	02f71463          	bne	a4,a5,80004ba0 <piperead+0x62>
    80004b7c:	2244a783          	lw	a5,548(s1)
    80004b80:	c385                	beqz	a5,80004ba0 <piperead+0x62>
    if(pr->killed){
    80004b82:	030a2783          	lw	a5,48(s4)
    80004b86:	ebc9                	bnez	a5,80004c18 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b88:	85a6                	mv	a1,s1
    80004b8a:	854e                	mv	a0,s3
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	6a0080e7          	jalr	1696(ra) # 8000222c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b94:	2184a703          	lw	a4,536(s1)
    80004b98:	21c4a783          	lw	a5,540(s1)
    80004b9c:	fef700e3          	beq	a4,a5,80004b7c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ba0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ba2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ba4:	05505463          	blez	s5,80004bec <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004ba8:	2184a783          	lw	a5,536(s1)
    80004bac:	21c4a703          	lw	a4,540(s1)
    80004bb0:	02f70e63          	beq	a4,a5,80004bec <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bb4:	0017871b          	addw	a4,a5,1
    80004bb8:	20e4ac23          	sw	a4,536(s1)
    80004bbc:	1ff7f793          	and	a5,a5,511
    80004bc0:	97a6                	add	a5,a5,s1
    80004bc2:	0187c783          	lbu	a5,24(a5)
    80004bc6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bca:	4685                	li	a3,1
    80004bcc:	fbf40613          	add	a2,s0,-65
    80004bd0:	85ca                	mv	a1,s2
    80004bd2:	050a3503          	ld	a0,80(s4)
    80004bd6:	ffffd097          	auipc	ra,0xffffd
    80004bda:	b30080e7          	jalr	-1232(ra) # 80001706 <copyout>
    80004bde:	01650763          	beq	a0,s6,80004bec <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004be2:	2985                	addw	s3,s3,1
    80004be4:	0905                	add	s2,s2,1
    80004be6:	fd3a91e3          	bne	s5,s3,80004ba8 <piperead+0x6a>
    80004bea:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bec:	21c48513          	add	a0,s1,540
    80004bf0:	ffffd097          	auipc	ra,0xffffd
    80004bf4:	7bc080e7          	jalr	1980(ra) # 800023ac <wakeup>
  release(&pi->lock);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffc097          	auipc	ra,0xffffc
    80004bfe:	100080e7          	jalr	256(ra) # 80000cfa <release>
  return i;
}
    80004c02:	854e                	mv	a0,s3
    80004c04:	60a6                	ld	ra,72(sp)
    80004c06:	6406                	ld	s0,64(sp)
    80004c08:	74e2                	ld	s1,56(sp)
    80004c0a:	7942                	ld	s2,48(sp)
    80004c0c:	79a2                	ld	s3,40(sp)
    80004c0e:	7a02                	ld	s4,32(sp)
    80004c10:	6ae2                	ld	s5,24(sp)
    80004c12:	6b42                	ld	s6,16(sp)
    80004c14:	6161                	add	sp,sp,80
    80004c16:	8082                	ret
      release(&pi->lock);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	0e0080e7          	jalr	224(ra) # 80000cfa <release>
      return -1;
    80004c22:	59fd                	li	s3,-1
    80004c24:	bff9                	j	80004c02 <piperead+0xc4>

0000000080004c26 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c26:	df010113          	add	sp,sp,-528
    80004c2a:	20113423          	sd	ra,520(sp)
    80004c2e:	20813023          	sd	s0,512(sp)
    80004c32:	ffa6                	sd	s1,504(sp)
    80004c34:	fbca                	sd	s2,496(sp)
    80004c36:	f7ce                	sd	s3,488(sp)
    80004c38:	f3d2                	sd	s4,480(sp)
    80004c3a:	efd6                	sd	s5,472(sp)
    80004c3c:	ebda                	sd	s6,464(sp)
    80004c3e:	e7de                	sd	s7,456(sp)
    80004c40:	e3e2                	sd	s8,448(sp)
    80004c42:	ff66                	sd	s9,440(sp)
    80004c44:	fb6a                	sd	s10,432(sp)
    80004c46:	f76e                	sd	s11,424(sp)
    80004c48:	0c00                	add	s0,sp,528
    80004c4a:	892a                	mv	s2,a0
    80004c4c:	dea43c23          	sd	a0,-520(s0)
    80004c50:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c54:	ffffd097          	auipc	ra,0xffffd
    80004c58:	dbc080e7          	jalr	-580(ra) # 80001a10 <myproc>
    80004c5c:	84aa                	mv	s1,a0

  begin_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	47c080e7          	jalr	1148(ra) # 800040da <begin_op>

  if((ip = namei(path)) == 0){
    80004c66:	854a                	mv	a0,s2
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	282080e7          	jalr	642(ra) # 80003eea <namei>
    80004c70:	c92d                	beqz	a0,80004ce2 <exec+0xbc>
    80004c72:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	ac6080e7          	jalr	-1338(ra) # 8000373a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c7c:	04000713          	li	a4,64
    80004c80:	4681                	li	a3,0
    80004c82:	e4840613          	add	a2,s0,-440
    80004c86:	4581                	li	a1,0
    80004c88:	8552                	mv	a0,s4
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	d64080e7          	jalr	-668(ra) # 800039ee <readi>
    80004c92:	04000793          	li	a5,64
    80004c96:	00f51a63          	bne	a0,a5,80004caa <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c9a:	e4842703          	lw	a4,-440(s0)
    80004c9e:	464c47b7          	lui	a5,0x464c4
    80004ca2:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ca6:	04f70463          	beq	a4,a5,80004cee <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004caa:	8552                	mv	a0,s4
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	cf0080e7          	jalr	-784(ra) # 8000399c <iunlockput>
    end_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	4a0080e7          	jalr	1184(ra) # 80004154 <end_op>
  }
  return -1;
    80004cbc:	557d                	li	a0,-1
}
    80004cbe:	20813083          	ld	ra,520(sp)
    80004cc2:	20013403          	ld	s0,512(sp)
    80004cc6:	74fe                	ld	s1,504(sp)
    80004cc8:	795e                	ld	s2,496(sp)
    80004cca:	79be                	ld	s3,488(sp)
    80004ccc:	7a1e                	ld	s4,480(sp)
    80004cce:	6afe                	ld	s5,472(sp)
    80004cd0:	6b5e                	ld	s6,464(sp)
    80004cd2:	6bbe                	ld	s7,456(sp)
    80004cd4:	6c1e                	ld	s8,448(sp)
    80004cd6:	7cfa                	ld	s9,440(sp)
    80004cd8:	7d5a                	ld	s10,432(sp)
    80004cda:	7dba                	ld	s11,424(sp)
    80004cdc:	21010113          	add	sp,sp,528
    80004ce0:	8082                	ret
    end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	472080e7          	jalr	1138(ra) # 80004154 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	bfc9                	j	80004cbe <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffd097          	auipc	ra,0xffffd
    80004cf4:	de4080e7          	jalr	-540(ra) # 80001ad4 <proc_pagetable>
    80004cf8:	8b2a                	mv	s6,a0
    80004cfa:	d945                	beqz	a0,80004caa <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cfc:	e6842d03          	lw	s10,-408(s0)
    80004d00:	e8045783          	lhu	a5,-384(s0)
    80004d04:	cfe5                	beqz	a5,80004dfc <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d06:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d08:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004d0a:	6c85                	lui	s9,0x1
    80004d0c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d10:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004d14:	6a85                	lui	s5,0x1
    80004d16:	a0b5                	j	80004d82 <exec+0x15c>
      panic("loadseg: address should exist");
    80004d18:	00004517          	auipc	a0,0x4
    80004d1c:	b3050513          	add	a0,a0,-1232 # 80008848 <syscall_names+0x298>
    80004d20:	ffffc097          	auipc	ra,0xffffc
    80004d24:	822080e7          	jalr	-2014(ra) # 80000542 <panic>
    if(sz - i < PGSIZE)
    80004d28:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d2a:	8726                	mv	a4,s1
    80004d2c:	012c06bb          	addw	a3,s8,s2
    80004d30:	4581                	li	a1,0
    80004d32:	8552                	mv	a0,s4
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	cba080e7          	jalr	-838(ra) # 800039ee <readi>
    80004d3c:	2501                	sext.w	a0,a0
    80004d3e:	24a49063          	bne	s1,a0,80004f7e <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004d42:	012a893b          	addw	s2,s5,s2
    80004d46:	03397563          	bgeu	s2,s3,80004d70 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004d4a:	02091593          	sll	a1,s2,0x20
    80004d4e:	9181                	srl	a1,a1,0x20
    80004d50:	95de                	add	a1,a1,s7
    80004d52:	855a                	mv	a0,s6
    80004d54:	ffffc097          	auipc	ra,0xffffc
    80004d58:	37a080e7          	jalr	890(ra) # 800010ce <walkaddr>
    80004d5c:	862a                	mv	a2,a0
    if(pa == 0)
    80004d5e:	dd4d                	beqz	a0,80004d18 <exec+0xf2>
    if(sz - i < PGSIZE)
    80004d60:	412984bb          	subw	s1,s3,s2
    80004d64:	0004879b          	sext.w	a5,s1
    80004d68:	fcfcf0e3          	bgeu	s9,a5,80004d28 <exec+0x102>
    80004d6c:	84d6                	mv	s1,s5
    80004d6e:	bf6d                	j	80004d28 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d70:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d74:	2d85                	addw	s11,s11,1
    80004d76:	038d0d1b          	addw	s10,s10,56
    80004d7a:	e8045783          	lhu	a5,-384(s0)
    80004d7e:	08fdd063          	bge	s11,a5,80004dfe <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d82:	2d01                	sext.w	s10,s10
    80004d84:	03800713          	li	a4,56
    80004d88:	86ea                	mv	a3,s10
    80004d8a:	e1040613          	add	a2,s0,-496
    80004d8e:	4581                	li	a1,0
    80004d90:	8552                	mv	a0,s4
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	c5c080e7          	jalr	-932(ra) # 800039ee <readi>
    80004d9a:	03800793          	li	a5,56
    80004d9e:	1cf51e63          	bne	a0,a5,80004f7a <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004da2:	e1042783          	lw	a5,-496(s0)
    80004da6:	4705                	li	a4,1
    80004da8:	fce796e3          	bne	a5,a4,80004d74 <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004dac:	e3843603          	ld	a2,-456(s0)
    80004db0:	e3043783          	ld	a5,-464(s0)
    80004db4:	1ef66063          	bltu	a2,a5,80004f94 <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004db8:	e2043783          	ld	a5,-480(s0)
    80004dbc:	963e                	add	a2,a2,a5
    80004dbe:	1cf66e63          	bltu	a2,a5,80004f9a <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004dc2:	85a6                	mv	a1,s1
    80004dc4:	855a                	mv	a0,s6
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	6ec080e7          	jalr	1772(ra) # 800014b2 <uvmalloc>
    80004dce:	e0a43423          	sd	a0,-504(s0)
    80004dd2:	1c050763          	beqz	a0,80004fa0 <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004dd6:	e2043b83          	ld	s7,-480(s0)
    80004dda:	df043783          	ld	a5,-528(s0)
    80004dde:	00fbf7b3          	and	a5,s7,a5
    80004de2:	18079e63          	bnez	a5,80004f7e <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004de6:	e1842c03          	lw	s8,-488(s0)
    80004dea:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004dee:	00098463          	beqz	s3,80004df6 <exec+0x1d0>
    80004df2:	4901                	li	s2,0
    80004df4:	bf99                	j	80004d4a <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004df6:	e0843483          	ld	s1,-504(s0)
    80004dfa:	bfad                	j	80004d74 <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004dfc:	4481                	li	s1,0
  iunlockput(ip);
    80004dfe:	8552                	mv	a0,s4
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	b9c080e7          	jalr	-1124(ra) # 8000399c <iunlockput>
  end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	34c080e7          	jalr	844(ra) # 80004154 <end_op>
  p = myproc();
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	c00080e7          	jalr	-1024(ra) # 80001a10 <myproc>
    80004e18:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e1a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004e1e:	6985                	lui	s3,0x1
    80004e20:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004e22:	99a6                	add	s3,s3,s1
    80004e24:	77fd                	lui	a5,0xfffff
    80004e26:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e2a:	6609                	lui	a2,0x2
    80004e2c:	964e                	add	a2,a2,s3
    80004e2e:	85ce                	mv	a1,s3
    80004e30:	855a                	mv	a0,s6
    80004e32:	ffffc097          	auipc	ra,0xffffc
    80004e36:	680080e7          	jalr	1664(ra) # 800014b2 <uvmalloc>
    80004e3a:	892a                	mv	s2,a0
    80004e3c:	e0a43423          	sd	a0,-504(s0)
    80004e40:	e509                	bnez	a0,80004e4a <exec+0x224>
  if(pagetable)
    80004e42:	e1343423          	sd	s3,-504(s0)
    80004e46:	4a01                	li	s4,0
    80004e48:	aa1d                	j	80004f7e <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e4a:	75f9                	lui	a1,0xffffe
    80004e4c:	95aa                	add	a1,a1,a0
    80004e4e:	855a                	mv	a0,s6
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	884080e7          	jalr	-1916(ra) # 800016d4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e58:	7bfd                	lui	s7,0xfffff
    80004e5a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004e5c:	e0043783          	ld	a5,-512(s0)
    80004e60:	6388                	ld	a0,0(a5)
    80004e62:	c52d                	beqz	a0,80004ecc <exec+0x2a6>
    80004e64:	e8840993          	add	s3,s0,-376
    80004e68:	f8840c13          	add	s8,s0,-120
    80004e6c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e6e:	ffffc097          	auipc	ra,0xffffc
    80004e72:	056080e7          	jalr	86(ra) # 80000ec4 <strlen>
    80004e76:	0015079b          	addw	a5,a0,1
    80004e7a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e7e:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004e82:	13796263          	bltu	s2,s7,80004fa6 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e86:	e0043d03          	ld	s10,-512(s0)
    80004e8a:	000d3a03          	ld	s4,0(s10)
    80004e8e:	8552                	mv	a0,s4
    80004e90:	ffffc097          	auipc	ra,0xffffc
    80004e94:	034080e7          	jalr	52(ra) # 80000ec4 <strlen>
    80004e98:	0015069b          	addw	a3,a0,1
    80004e9c:	8652                	mv	a2,s4
    80004e9e:	85ca                	mv	a1,s2
    80004ea0:	855a                	mv	a0,s6
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	864080e7          	jalr	-1948(ra) # 80001706 <copyout>
    80004eaa:	10054063          	bltz	a0,80004faa <exec+0x384>
    ustack[argc] = sp;
    80004eae:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004eb2:	0485                	add	s1,s1,1
    80004eb4:	008d0793          	add	a5,s10,8
    80004eb8:	e0f43023          	sd	a5,-512(s0)
    80004ebc:	008d3503          	ld	a0,8(s10)
    80004ec0:	c909                	beqz	a0,80004ed2 <exec+0x2ac>
    if(argc >= MAXARG)
    80004ec2:	09a1                	add	s3,s3,8
    80004ec4:	fb8995e3          	bne	s3,s8,80004e6e <exec+0x248>
  ip = 0;
    80004ec8:	4a01                	li	s4,0
    80004eca:	a855                	j	80004f7e <exec+0x358>
  sp = sz;
    80004ecc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004ed0:	4481                	li	s1,0
  ustack[argc] = 0;
    80004ed2:	00349793          	sll	a5,s1,0x3
    80004ed6:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8f90>
    80004eda:	97a2                	add	a5,a5,s0
    80004edc:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004ee0:	00148693          	add	a3,s1,1
    80004ee4:	068e                	sll	a3,a3,0x3
    80004ee6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004eea:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004eee:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004ef2:	f57968e3          	bltu	s2,s7,80004e42 <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ef6:	e8840613          	add	a2,s0,-376
    80004efa:	85ca                	mv	a1,s2
    80004efc:	855a                	mv	a0,s6
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	808080e7          	jalr	-2040(ra) # 80001706 <copyout>
    80004f06:	0a054463          	bltz	a0,80004fae <exec+0x388>
  p->trapframe->a1 = sp;
    80004f0a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004f0e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f12:	df843783          	ld	a5,-520(s0)
    80004f16:	0007c703          	lbu	a4,0(a5)
    80004f1a:	cf11                	beqz	a4,80004f36 <exec+0x310>
    80004f1c:	0785                	add	a5,a5,1
    if(*s == '/')
    80004f1e:	02f00693          	li	a3,47
    80004f22:	a039                	j	80004f30 <exec+0x30a>
      last = s+1;
    80004f24:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004f28:	0785                	add	a5,a5,1
    80004f2a:	fff7c703          	lbu	a4,-1(a5)
    80004f2e:	c701                	beqz	a4,80004f36 <exec+0x310>
    if(*s == '/')
    80004f30:	fed71ce3          	bne	a4,a3,80004f28 <exec+0x302>
    80004f34:	bfc5                	j	80004f24 <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f36:	4641                	li	a2,16
    80004f38:	df843583          	ld	a1,-520(s0)
    80004f3c:	158a8513          	add	a0,s5,344
    80004f40:	ffffc097          	auipc	ra,0xffffc
    80004f44:	f52080e7          	jalr	-174(ra) # 80000e92 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f48:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f4c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004f50:	e0843783          	ld	a5,-504(s0)
    80004f54:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f58:	058ab783          	ld	a5,88(s5)
    80004f5c:	e6043703          	ld	a4,-416(s0)
    80004f60:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f62:	058ab783          	ld	a5,88(s5)
    80004f66:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f6a:	85e6                	mv	a1,s9
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	c04080e7          	jalr	-1020(ra) # 80001b70 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f74:	0004851b          	sext.w	a0,s1
    80004f78:	b399                	j	80004cbe <exec+0x98>
    80004f7a:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004f7e:	e0843583          	ld	a1,-504(s0)
    80004f82:	855a                	mv	a0,s6
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	bec080e7          	jalr	-1044(ra) # 80001b70 <proc_freepagetable>
  return -1;
    80004f8c:	557d                	li	a0,-1
  if(ip){
    80004f8e:	d20a08e3          	beqz	s4,80004cbe <exec+0x98>
    80004f92:	bb21                	j	80004caa <exec+0x84>
    80004f94:	e0943423          	sd	s1,-504(s0)
    80004f98:	b7dd                	j	80004f7e <exec+0x358>
    80004f9a:	e0943423          	sd	s1,-504(s0)
    80004f9e:	b7c5                	j	80004f7e <exec+0x358>
    80004fa0:	e0943423          	sd	s1,-504(s0)
    80004fa4:	bfe9                	j	80004f7e <exec+0x358>
  ip = 0;
    80004fa6:	4a01                	li	s4,0
    80004fa8:	bfd9                	j	80004f7e <exec+0x358>
    80004faa:	4a01                	li	s4,0
  if(pagetable)
    80004fac:	bfc9                	j	80004f7e <exec+0x358>
  sz = sz1;
    80004fae:	e0843983          	ld	s3,-504(s0)
    80004fb2:	bd41                	j	80004e42 <exec+0x21c>

0000000080004fb4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004fb4:	7179                	add	sp,sp,-48
    80004fb6:	f406                	sd	ra,40(sp)
    80004fb8:	f022                	sd	s0,32(sp)
    80004fba:	ec26                	sd	s1,24(sp)
    80004fbc:	e84a                	sd	s2,16(sp)
    80004fbe:	1800                	add	s0,sp,48
    80004fc0:	892e                	mv	s2,a1
    80004fc2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004fc4:	fdc40593          	add	a1,s0,-36
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	b3e080e7          	jalr	-1218(ra) # 80002b06 <argint>
    80004fd0:	04054063          	bltz	a0,80005010 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fd4:	fdc42703          	lw	a4,-36(s0)
    80004fd8:	47bd                	li	a5,15
    80004fda:	02e7ed63          	bltu	a5,a4,80005014 <argfd+0x60>
    80004fde:	ffffd097          	auipc	ra,0xffffd
    80004fe2:	a32080e7          	jalr	-1486(ra) # 80001a10 <myproc>
    80004fe6:	fdc42703          	lw	a4,-36(s0)
    80004fea:	01a70793          	add	a5,a4,26
    80004fee:	078e                	sll	a5,a5,0x3
    80004ff0:	953e                	add	a0,a0,a5
    80004ff2:	611c                	ld	a5,0(a0)
    80004ff4:	c395                	beqz	a5,80005018 <argfd+0x64>
    return -1;
  if(pfd)
    80004ff6:	00090463          	beqz	s2,80004ffe <argfd+0x4a>
    *pfd = fd;
    80004ffa:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ffe:	4501                	li	a0,0
  if(pf)
    80005000:	c091                	beqz	s1,80005004 <argfd+0x50>
    *pf = f;
    80005002:	e09c                	sd	a5,0(s1)
}
    80005004:	70a2                	ld	ra,40(sp)
    80005006:	7402                	ld	s0,32(sp)
    80005008:	64e2                	ld	s1,24(sp)
    8000500a:	6942                	ld	s2,16(sp)
    8000500c:	6145                	add	sp,sp,48
    8000500e:	8082                	ret
    return -1;
    80005010:	557d                	li	a0,-1
    80005012:	bfcd                	j	80005004 <argfd+0x50>
    return -1;
    80005014:	557d                	li	a0,-1
    80005016:	b7fd                	j	80005004 <argfd+0x50>
    80005018:	557d                	li	a0,-1
    8000501a:	b7ed                	j	80005004 <argfd+0x50>

000000008000501c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000501c:	1101                	add	sp,sp,-32
    8000501e:	ec06                	sd	ra,24(sp)
    80005020:	e822                	sd	s0,16(sp)
    80005022:	e426                	sd	s1,8(sp)
    80005024:	1000                	add	s0,sp,32
    80005026:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	9e8080e7          	jalr	-1560(ra) # 80001a10 <myproc>
    80005030:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005032:	0d050793          	add	a5,a0,208
    80005036:	4501                	li	a0,0
    80005038:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000503a:	6398                	ld	a4,0(a5)
    8000503c:	cb19                	beqz	a4,80005052 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000503e:	2505                	addw	a0,a0,1
    80005040:	07a1                	add	a5,a5,8
    80005042:	fed51ce3          	bne	a0,a3,8000503a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005046:	557d                	li	a0,-1
}
    80005048:	60e2                	ld	ra,24(sp)
    8000504a:	6442                	ld	s0,16(sp)
    8000504c:	64a2                	ld	s1,8(sp)
    8000504e:	6105                	add	sp,sp,32
    80005050:	8082                	ret
      p->ofile[fd] = f;
    80005052:	01a50793          	add	a5,a0,26
    80005056:	078e                	sll	a5,a5,0x3
    80005058:	963e                	add	a2,a2,a5
    8000505a:	e204                	sd	s1,0(a2)
      return fd;
    8000505c:	b7f5                	j	80005048 <fdalloc+0x2c>

000000008000505e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000505e:	715d                	add	sp,sp,-80
    80005060:	e486                	sd	ra,72(sp)
    80005062:	e0a2                	sd	s0,64(sp)
    80005064:	fc26                	sd	s1,56(sp)
    80005066:	f84a                	sd	s2,48(sp)
    80005068:	f44e                	sd	s3,40(sp)
    8000506a:	f052                	sd	s4,32(sp)
    8000506c:	ec56                	sd	s5,24(sp)
    8000506e:	0880                	add	s0,sp,80
    80005070:	8aae                	mv	s5,a1
    80005072:	8a32                	mv	s4,a2
    80005074:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005076:	fb040593          	add	a1,s0,-80
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	e8e080e7          	jalr	-370(ra) # 80003f08 <nameiparent>
    80005082:	892a                	mv	s2,a0
    80005084:	12050c63          	beqz	a0,800051bc <create+0x15e>
    return 0;

  ilock(dp);
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	6b2080e7          	jalr	1714(ra) # 8000373a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005090:	4601                	li	a2,0
    80005092:	fb040593          	add	a1,s0,-80
    80005096:	854a                	mv	a0,s2
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	b80080e7          	jalr	-1152(ra) # 80003c18 <dirlookup>
    800050a0:	84aa                	mv	s1,a0
    800050a2:	c539                	beqz	a0,800050f0 <create+0x92>
    iunlockput(dp);
    800050a4:	854a                	mv	a0,s2
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	8f6080e7          	jalr	-1802(ra) # 8000399c <iunlockput>
    ilock(ip);
    800050ae:	8526                	mv	a0,s1
    800050b0:	ffffe097          	auipc	ra,0xffffe
    800050b4:	68a080e7          	jalr	1674(ra) # 8000373a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050b8:	4789                	li	a5,2
    800050ba:	02fa9463          	bne	s5,a5,800050e2 <create+0x84>
    800050be:	0444d783          	lhu	a5,68(s1)
    800050c2:	37f9                	addw	a5,a5,-2
    800050c4:	17c2                	sll	a5,a5,0x30
    800050c6:	93c1                	srl	a5,a5,0x30
    800050c8:	4705                	li	a4,1
    800050ca:	00f76c63          	bltu	a4,a5,800050e2 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800050ce:	8526                	mv	a0,s1
    800050d0:	60a6                	ld	ra,72(sp)
    800050d2:	6406                	ld	s0,64(sp)
    800050d4:	74e2                	ld	s1,56(sp)
    800050d6:	7942                	ld	s2,48(sp)
    800050d8:	79a2                	ld	s3,40(sp)
    800050da:	7a02                	ld	s4,32(sp)
    800050dc:	6ae2                	ld	s5,24(sp)
    800050de:	6161                	add	sp,sp,80
    800050e0:	8082                	ret
    iunlockput(ip);
    800050e2:	8526                	mv	a0,s1
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	8b8080e7          	jalr	-1864(ra) # 8000399c <iunlockput>
    return 0;
    800050ec:	4481                	li	s1,0
    800050ee:	b7c5                	j	800050ce <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800050f0:	85d6                	mv	a1,s5
    800050f2:	00092503          	lw	a0,0(s2)
    800050f6:	ffffe097          	auipc	ra,0xffffe
    800050fa:	4b0080e7          	jalr	1200(ra) # 800035a6 <ialloc>
    800050fe:	84aa                	mv	s1,a0
    80005100:	c139                	beqz	a0,80005146 <create+0xe8>
  ilock(ip);
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	638080e7          	jalr	1592(ra) # 8000373a <ilock>
  ip->major = major;
    8000510a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000510e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80005112:	4985                	li	s3,1
    80005114:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80005118:	8526                	mv	a0,s1
    8000511a:	ffffe097          	auipc	ra,0xffffe
    8000511e:	554080e7          	jalr	1364(ra) # 8000366e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005122:	033a8a63          	beq	s5,s3,80005156 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80005126:	40d0                	lw	a2,4(s1)
    80005128:	fb040593          	add	a1,s0,-80
    8000512c:	854a                	mv	a0,s2
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	cfa080e7          	jalr	-774(ra) # 80003e28 <dirlink>
    80005136:	06054b63          	bltz	a0,800051ac <create+0x14e>
  iunlockput(dp);
    8000513a:	854a                	mv	a0,s2
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	860080e7          	jalr	-1952(ra) # 8000399c <iunlockput>
  return ip;
    80005144:	b769                	j	800050ce <create+0x70>
    panic("create: ialloc");
    80005146:	00003517          	auipc	a0,0x3
    8000514a:	72250513          	add	a0,a0,1826 # 80008868 <syscall_names+0x2b8>
    8000514e:	ffffb097          	auipc	ra,0xffffb
    80005152:	3f4080e7          	jalr	1012(ra) # 80000542 <panic>
    dp->nlink++;  // for ".."
    80005156:	04a95783          	lhu	a5,74(s2)
    8000515a:	2785                	addw	a5,a5,1
    8000515c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005160:	854a                	mv	a0,s2
    80005162:	ffffe097          	auipc	ra,0xffffe
    80005166:	50c080e7          	jalr	1292(ra) # 8000366e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000516a:	40d0                	lw	a2,4(s1)
    8000516c:	00003597          	auipc	a1,0x3
    80005170:	70c58593          	add	a1,a1,1804 # 80008878 <syscall_names+0x2c8>
    80005174:	8526                	mv	a0,s1
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	cb2080e7          	jalr	-846(ra) # 80003e28 <dirlink>
    8000517e:	00054f63          	bltz	a0,8000519c <create+0x13e>
    80005182:	00492603          	lw	a2,4(s2)
    80005186:	00003597          	auipc	a1,0x3
    8000518a:	6fa58593          	add	a1,a1,1786 # 80008880 <syscall_names+0x2d0>
    8000518e:	8526                	mv	a0,s1
    80005190:	fffff097          	auipc	ra,0xfffff
    80005194:	c98080e7          	jalr	-872(ra) # 80003e28 <dirlink>
    80005198:	f80557e3          	bgez	a0,80005126 <create+0xc8>
      panic("create dots");
    8000519c:	00003517          	auipc	a0,0x3
    800051a0:	6ec50513          	add	a0,a0,1772 # 80008888 <syscall_names+0x2d8>
    800051a4:	ffffb097          	auipc	ra,0xffffb
    800051a8:	39e080e7          	jalr	926(ra) # 80000542 <panic>
    panic("create: dirlink");
    800051ac:	00003517          	auipc	a0,0x3
    800051b0:	6ec50513          	add	a0,a0,1772 # 80008898 <syscall_names+0x2e8>
    800051b4:	ffffb097          	auipc	ra,0xffffb
    800051b8:	38e080e7          	jalr	910(ra) # 80000542 <panic>
    return 0;
    800051bc:	84aa                	mv	s1,a0
    800051be:	bf01                	j	800050ce <create+0x70>

00000000800051c0 <sys_dup>:
{
    800051c0:	7179                	add	sp,sp,-48
    800051c2:	f406                	sd	ra,40(sp)
    800051c4:	f022                	sd	s0,32(sp)
    800051c6:	ec26                	sd	s1,24(sp)
    800051c8:	e84a                	sd	s2,16(sp)
    800051ca:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051cc:	fd840613          	add	a2,s0,-40
    800051d0:	4581                	li	a1,0
    800051d2:	4501                	li	a0,0
    800051d4:	00000097          	auipc	ra,0x0
    800051d8:	de0080e7          	jalr	-544(ra) # 80004fb4 <argfd>
    return -1;
    800051dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051de:	02054363          	bltz	a0,80005204 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800051e2:	fd843903          	ld	s2,-40(s0)
    800051e6:	854a                	mv	a0,s2
    800051e8:	00000097          	auipc	ra,0x0
    800051ec:	e34080e7          	jalr	-460(ra) # 8000501c <fdalloc>
    800051f0:	84aa                	mv	s1,a0
    return -1;
    800051f2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051f4:	00054863          	bltz	a0,80005204 <sys_dup+0x44>
  filedup(f);
    800051f8:	854a                	mv	a0,s2
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	358080e7          	jalr	856(ra) # 80004552 <filedup>
  return fd;
    80005202:	87a6                	mv	a5,s1
}
    80005204:	853e                	mv	a0,a5
    80005206:	70a2                	ld	ra,40(sp)
    80005208:	7402                	ld	s0,32(sp)
    8000520a:	64e2                	ld	s1,24(sp)
    8000520c:	6942                	ld	s2,16(sp)
    8000520e:	6145                	add	sp,sp,48
    80005210:	8082                	ret

0000000080005212 <sys_read>:
{
    80005212:	7179                	add	sp,sp,-48
    80005214:	f406                	sd	ra,40(sp)
    80005216:	f022                	sd	s0,32(sp)
    80005218:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000521a:	fe840613          	add	a2,s0,-24
    8000521e:	4581                	li	a1,0
    80005220:	4501                	li	a0,0
    80005222:	00000097          	auipc	ra,0x0
    80005226:	d92080e7          	jalr	-622(ra) # 80004fb4 <argfd>
    return -1;
    8000522a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000522c:	04054163          	bltz	a0,8000526e <sys_read+0x5c>
    80005230:	fe440593          	add	a1,s0,-28
    80005234:	4509                	li	a0,2
    80005236:	ffffe097          	auipc	ra,0xffffe
    8000523a:	8d0080e7          	jalr	-1840(ra) # 80002b06 <argint>
    return -1;
    8000523e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005240:	02054763          	bltz	a0,8000526e <sys_read+0x5c>
    80005244:	fd840593          	add	a1,s0,-40
    80005248:	4505                	li	a0,1
    8000524a:	ffffe097          	auipc	ra,0xffffe
    8000524e:	8de080e7          	jalr	-1826(ra) # 80002b28 <argaddr>
    return -1;
    80005252:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005254:	00054d63          	bltz	a0,8000526e <sys_read+0x5c>
  return fileread(f, p, n);
    80005258:	fe442603          	lw	a2,-28(s0)
    8000525c:	fd843583          	ld	a1,-40(s0)
    80005260:	fe843503          	ld	a0,-24(s0)
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	47a080e7          	jalr	1146(ra) # 800046de <fileread>
    8000526c:	87aa                	mv	a5,a0
}
    8000526e:	853e                	mv	a0,a5
    80005270:	70a2                	ld	ra,40(sp)
    80005272:	7402                	ld	s0,32(sp)
    80005274:	6145                	add	sp,sp,48
    80005276:	8082                	ret

0000000080005278 <sys_write>:
{
    80005278:	7179                	add	sp,sp,-48
    8000527a:	f406                	sd	ra,40(sp)
    8000527c:	f022                	sd	s0,32(sp)
    8000527e:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005280:	fe840613          	add	a2,s0,-24
    80005284:	4581                	li	a1,0
    80005286:	4501                	li	a0,0
    80005288:	00000097          	auipc	ra,0x0
    8000528c:	d2c080e7          	jalr	-724(ra) # 80004fb4 <argfd>
    return -1;
    80005290:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005292:	04054163          	bltz	a0,800052d4 <sys_write+0x5c>
    80005296:	fe440593          	add	a1,s0,-28
    8000529a:	4509                	li	a0,2
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	86a080e7          	jalr	-1942(ra) # 80002b06 <argint>
    return -1;
    800052a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052a6:	02054763          	bltz	a0,800052d4 <sys_write+0x5c>
    800052aa:	fd840593          	add	a1,s0,-40
    800052ae:	4505                	li	a0,1
    800052b0:	ffffe097          	auipc	ra,0xffffe
    800052b4:	878080e7          	jalr	-1928(ra) # 80002b28 <argaddr>
    return -1;
    800052b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052ba:	00054d63          	bltz	a0,800052d4 <sys_write+0x5c>
  return filewrite(f, p, n);
    800052be:	fe442603          	lw	a2,-28(s0)
    800052c2:	fd843583          	ld	a1,-40(s0)
    800052c6:	fe843503          	ld	a0,-24(s0)
    800052ca:	fffff097          	auipc	ra,0xfffff
    800052ce:	4d6080e7          	jalr	1238(ra) # 800047a0 <filewrite>
    800052d2:	87aa                	mv	a5,a0
}
    800052d4:	853e                	mv	a0,a5
    800052d6:	70a2                	ld	ra,40(sp)
    800052d8:	7402                	ld	s0,32(sp)
    800052da:	6145                	add	sp,sp,48
    800052dc:	8082                	ret

00000000800052de <sys_close>:
{
    800052de:	1101                	add	sp,sp,-32
    800052e0:	ec06                	sd	ra,24(sp)
    800052e2:	e822                	sd	s0,16(sp)
    800052e4:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052e6:	fe040613          	add	a2,s0,-32
    800052ea:	fec40593          	add	a1,s0,-20
    800052ee:	4501                	li	a0,0
    800052f0:	00000097          	auipc	ra,0x0
    800052f4:	cc4080e7          	jalr	-828(ra) # 80004fb4 <argfd>
    return -1;
    800052f8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052fa:	02054463          	bltz	a0,80005322 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052fe:	ffffc097          	auipc	ra,0xffffc
    80005302:	712080e7          	jalr	1810(ra) # 80001a10 <myproc>
    80005306:	fec42783          	lw	a5,-20(s0)
    8000530a:	07e9                	add	a5,a5,26
    8000530c:	078e                	sll	a5,a5,0x3
    8000530e:	953e                	add	a0,a0,a5
    80005310:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005314:	fe043503          	ld	a0,-32(s0)
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	28c080e7          	jalr	652(ra) # 800045a4 <fileclose>
  return 0;
    80005320:	4781                	li	a5,0
}
    80005322:	853e                	mv	a0,a5
    80005324:	60e2                	ld	ra,24(sp)
    80005326:	6442                	ld	s0,16(sp)
    80005328:	6105                	add	sp,sp,32
    8000532a:	8082                	ret

000000008000532c <sys_fstat>:
{
    8000532c:	1101                	add	sp,sp,-32
    8000532e:	ec06                	sd	ra,24(sp)
    80005330:	e822                	sd	s0,16(sp)
    80005332:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005334:	fe840613          	add	a2,s0,-24
    80005338:	4581                	li	a1,0
    8000533a:	4501                	li	a0,0
    8000533c:	00000097          	auipc	ra,0x0
    80005340:	c78080e7          	jalr	-904(ra) # 80004fb4 <argfd>
    return -1;
    80005344:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005346:	02054563          	bltz	a0,80005370 <sys_fstat+0x44>
    8000534a:	fe040593          	add	a1,s0,-32
    8000534e:	4505                	li	a0,1
    80005350:	ffffd097          	auipc	ra,0xffffd
    80005354:	7d8080e7          	jalr	2008(ra) # 80002b28 <argaddr>
    return -1;
    80005358:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000535a:	00054b63          	bltz	a0,80005370 <sys_fstat+0x44>
  return filestat(f, st);
    8000535e:	fe043583          	ld	a1,-32(s0)
    80005362:	fe843503          	ld	a0,-24(s0)
    80005366:	fffff097          	auipc	ra,0xfffff
    8000536a:	306080e7          	jalr	774(ra) # 8000466c <filestat>
    8000536e:	87aa                	mv	a5,a0
}
    80005370:	853e                	mv	a0,a5
    80005372:	60e2                	ld	ra,24(sp)
    80005374:	6442                	ld	s0,16(sp)
    80005376:	6105                	add	sp,sp,32
    80005378:	8082                	ret

000000008000537a <sys_link>:
{
    8000537a:	7169                	add	sp,sp,-304
    8000537c:	f606                	sd	ra,296(sp)
    8000537e:	f222                	sd	s0,288(sp)
    80005380:	ee26                	sd	s1,280(sp)
    80005382:	ea4a                	sd	s2,272(sp)
    80005384:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005386:	08000613          	li	a2,128
    8000538a:	ed040593          	add	a1,s0,-304
    8000538e:	4501                	li	a0,0
    80005390:	ffffd097          	auipc	ra,0xffffd
    80005394:	7ba080e7          	jalr	1978(ra) # 80002b4a <argstr>
    return -1;
    80005398:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000539a:	10054e63          	bltz	a0,800054b6 <sys_link+0x13c>
    8000539e:	08000613          	li	a2,128
    800053a2:	f5040593          	add	a1,s0,-176
    800053a6:	4505                	li	a0,1
    800053a8:	ffffd097          	auipc	ra,0xffffd
    800053ac:	7a2080e7          	jalr	1954(ra) # 80002b4a <argstr>
    return -1;
    800053b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053b2:	10054263          	bltz	a0,800054b6 <sys_link+0x13c>
  begin_op();
    800053b6:	fffff097          	auipc	ra,0xfffff
    800053ba:	d24080e7          	jalr	-732(ra) # 800040da <begin_op>
  if((ip = namei(old)) == 0){
    800053be:	ed040513          	add	a0,s0,-304
    800053c2:	fffff097          	auipc	ra,0xfffff
    800053c6:	b28080e7          	jalr	-1240(ra) # 80003eea <namei>
    800053ca:	84aa                	mv	s1,a0
    800053cc:	c551                	beqz	a0,80005458 <sys_link+0xde>
  ilock(ip);
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	36c080e7          	jalr	876(ra) # 8000373a <ilock>
  if(ip->type == T_DIR){
    800053d6:	04449703          	lh	a4,68(s1)
    800053da:	4785                	li	a5,1
    800053dc:	08f70463          	beq	a4,a5,80005464 <sys_link+0xea>
  ip->nlink++;
    800053e0:	04a4d783          	lhu	a5,74(s1)
    800053e4:	2785                	addw	a5,a5,1
    800053e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053ea:	8526                	mv	a0,s1
    800053ec:	ffffe097          	auipc	ra,0xffffe
    800053f0:	282080e7          	jalr	642(ra) # 8000366e <iupdate>
  iunlock(ip);
    800053f4:	8526                	mv	a0,s1
    800053f6:	ffffe097          	auipc	ra,0xffffe
    800053fa:	406080e7          	jalr	1030(ra) # 800037fc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053fe:	fd040593          	add	a1,s0,-48
    80005402:	f5040513          	add	a0,s0,-176
    80005406:	fffff097          	auipc	ra,0xfffff
    8000540a:	b02080e7          	jalr	-1278(ra) # 80003f08 <nameiparent>
    8000540e:	892a                	mv	s2,a0
    80005410:	c935                	beqz	a0,80005484 <sys_link+0x10a>
  ilock(dp);
    80005412:	ffffe097          	auipc	ra,0xffffe
    80005416:	328080e7          	jalr	808(ra) # 8000373a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000541a:	00092703          	lw	a4,0(s2)
    8000541e:	409c                	lw	a5,0(s1)
    80005420:	04f71d63          	bne	a4,a5,8000547a <sys_link+0x100>
    80005424:	40d0                	lw	a2,4(s1)
    80005426:	fd040593          	add	a1,s0,-48
    8000542a:	854a                	mv	a0,s2
    8000542c:	fffff097          	auipc	ra,0xfffff
    80005430:	9fc080e7          	jalr	-1540(ra) # 80003e28 <dirlink>
    80005434:	04054363          	bltz	a0,8000547a <sys_link+0x100>
  iunlockput(dp);
    80005438:	854a                	mv	a0,s2
    8000543a:	ffffe097          	auipc	ra,0xffffe
    8000543e:	562080e7          	jalr	1378(ra) # 8000399c <iunlockput>
  iput(ip);
    80005442:	8526                	mv	a0,s1
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	4b0080e7          	jalr	1200(ra) # 800038f4 <iput>
  end_op();
    8000544c:	fffff097          	auipc	ra,0xfffff
    80005450:	d08080e7          	jalr	-760(ra) # 80004154 <end_op>
  return 0;
    80005454:	4781                	li	a5,0
    80005456:	a085                	j	800054b6 <sys_link+0x13c>
    end_op();
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	cfc080e7          	jalr	-772(ra) # 80004154 <end_op>
    return -1;
    80005460:	57fd                	li	a5,-1
    80005462:	a891                	j	800054b6 <sys_link+0x13c>
    iunlockput(ip);
    80005464:	8526                	mv	a0,s1
    80005466:	ffffe097          	auipc	ra,0xffffe
    8000546a:	536080e7          	jalr	1334(ra) # 8000399c <iunlockput>
    end_op();
    8000546e:	fffff097          	auipc	ra,0xfffff
    80005472:	ce6080e7          	jalr	-794(ra) # 80004154 <end_op>
    return -1;
    80005476:	57fd                	li	a5,-1
    80005478:	a83d                	j	800054b6 <sys_link+0x13c>
    iunlockput(dp);
    8000547a:	854a                	mv	a0,s2
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	520080e7          	jalr	1312(ra) # 8000399c <iunlockput>
  ilock(ip);
    80005484:	8526                	mv	a0,s1
    80005486:	ffffe097          	auipc	ra,0xffffe
    8000548a:	2b4080e7          	jalr	692(ra) # 8000373a <ilock>
  ip->nlink--;
    8000548e:	04a4d783          	lhu	a5,74(s1)
    80005492:	37fd                	addw	a5,a5,-1
    80005494:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005498:	8526                	mv	a0,s1
    8000549a:	ffffe097          	auipc	ra,0xffffe
    8000549e:	1d4080e7          	jalr	468(ra) # 8000366e <iupdate>
  iunlockput(ip);
    800054a2:	8526                	mv	a0,s1
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	4f8080e7          	jalr	1272(ra) # 8000399c <iunlockput>
  end_op();
    800054ac:	fffff097          	auipc	ra,0xfffff
    800054b0:	ca8080e7          	jalr	-856(ra) # 80004154 <end_op>
  return -1;
    800054b4:	57fd                	li	a5,-1
}
    800054b6:	853e                	mv	a0,a5
    800054b8:	70b2                	ld	ra,296(sp)
    800054ba:	7412                	ld	s0,288(sp)
    800054bc:	64f2                	ld	s1,280(sp)
    800054be:	6952                	ld	s2,272(sp)
    800054c0:	6155                	add	sp,sp,304
    800054c2:	8082                	ret

00000000800054c4 <sys_unlink>:
{
    800054c4:	7151                	add	sp,sp,-240
    800054c6:	f586                	sd	ra,232(sp)
    800054c8:	f1a2                	sd	s0,224(sp)
    800054ca:	eda6                	sd	s1,216(sp)
    800054cc:	e9ca                	sd	s2,208(sp)
    800054ce:	e5ce                	sd	s3,200(sp)
    800054d0:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800054d2:	08000613          	li	a2,128
    800054d6:	f3040593          	add	a1,s0,-208
    800054da:	4501                	li	a0,0
    800054dc:	ffffd097          	auipc	ra,0xffffd
    800054e0:	66e080e7          	jalr	1646(ra) # 80002b4a <argstr>
    800054e4:	18054163          	bltz	a0,80005666 <sys_unlink+0x1a2>
  begin_op();
    800054e8:	fffff097          	auipc	ra,0xfffff
    800054ec:	bf2080e7          	jalr	-1038(ra) # 800040da <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054f0:	fb040593          	add	a1,s0,-80
    800054f4:	f3040513          	add	a0,s0,-208
    800054f8:	fffff097          	auipc	ra,0xfffff
    800054fc:	a10080e7          	jalr	-1520(ra) # 80003f08 <nameiparent>
    80005500:	84aa                	mv	s1,a0
    80005502:	c979                	beqz	a0,800055d8 <sys_unlink+0x114>
  ilock(dp);
    80005504:	ffffe097          	auipc	ra,0xffffe
    80005508:	236080e7          	jalr	566(ra) # 8000373a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000550c:	00003597          	auipc	a1,0x3
    80005510:	36c58593          	add	a1,a1,876 # 80008878 <syscall_names+0x2c8>
    80005514:	fb040513          	add	a0,s0,-80
    80005518:	ffffe097          	auipc	ra,0xffffe
    8000551c:	6e6080e7          	jalr	1766(ra) # 80003bfe <namecmp>
    80005520:	14050a63          	beqz	a0,80005674 <sys_unlink+0x1b0>
    80005524:	00003597          	auipc	a1,0x3
    80005528:	35c58593          	add	a1,a1,860 # 80008880 <syscall_names+0x2d0>
    8000552c:	fb040513          	add	a0,s0,-80
    80005530:	ffffe097          	auipc	ra,0xffffe
    80005534:	6ce080e7          	jalr	1742(ra) # 80003bfe <namecmp>
    80005538:	12050e63          	beqz	a0,80005674 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000553c:	f2c40613          	add	a2,s0,-212
    80005540:	fb040593          	add	a1,s0,-80
    80005544:	8526                	mv	a0,s1
    80005546:	ffffe097          	auipc	ra,0xffffe
    8000554a:	6d2080e7          	jalr	1746(ra) # 80003c18 <dirlookup>
    8000554e:	892a                	mv	s2,a0
    80005550:	12050263          	beqz	a0,80005674 <sys_unlink+0x1b0>
  ilock(ip);
    80005554:	ffffe097          	auipc	ra,0xffffe
    80005558:	1e6080e7          	jalr	486(ra) # 8000373a <ilock>
  if(ip->nlink < 1)
    8000555c:	04a91783          	lh	a5,74(s2)
    80005560:	08f05263          	blez	a5,800055e4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005564:	04491703          	lh	a4,68(s2)
    80005568:	4785                	li	a5,1
    8000556a:	08f70563          	beq	a4,a5,800055f4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000556e:	4641                	li	a2,16
    80005570:	4581                	li	a1,0
    80005572:	fc040513          	add	a0,s0,-64
    80005576:	ffffb097          	auipc	ra,0xffffb
    8000557a:	7cc080e7          	jalr	1996(ra) # 80000d42 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000557e:	4741                	li	a4,16
    80005580:	f2c42683          	lw	a3,-212(s0)
    80005584:	fc040613          	add	a2,s0,-64
    80005588:	4581                	li	a1,0
    8000558a:	8526                	mv	a0,s1
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	558080e7          	jalr	1368(ra) # 80003ae4 <writei>
    80005594:	47c1                	li	a5,16
    80005596:	0af51563          	bne	a0,a5,80005640 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000559a:	04491703          	lh	a4,68(s2)
    8000559e:	4785                	li	a5,1
    800055a0:	0af70863          	beq	a4,a5,80005650 <sys_unlink+0x18c>
  iunlockput(dp);
    800055a4:	8526                	mv	a0,s1
    800055a6:	ffffe097          	auipc	ra,0xffffe
    800055aa:	3f6080e7          	jalr	1014(ra) # 8000399c <iunlockput>
  ip->nlink--;
    800055ae:	04a95783          	lhu	a5,74(s2)
    800055b2:	37fd                	addw	a5,a5,-1
    800055b4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055b8:	854a                	mv	a0,s2
    800055ba:	ffffe097          	auipc	ra,0xffffe
    800055be:	0b4080e7          	jalr	180(ra) # 8000366e <iupdate>
  iunlockput(ip);
    800055c2:	854a                	mv	a0,s2
    800055c4:	ffffe097          	auipc	ra,0xffffe
    800055c8:	3d8080e7          	jalr	984(ra) # 8000399c <iunlockput>
  end_op();
    800055cc:	fffff097          	auipc	ra,0xfffff
    800055d0:	b88080e7          	jalr	-1144(ra) # 80004154 <end_op>
  return 0;
    800055d4:	4501                	li	a0,0
    800055d6:	a84d                	j	80005688 <sys_unlink+0x1c4>
    end_op();
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	b7c080e7          	jalr	-1156(ra) # 80004154 <end_op>
    return -1;
    800055e0:	557d                	li	a0,-1
    800055e2:	a05d                	j	80005688 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055e4:	00003517          	auipc	a0,0x3
    800055e8:	2c450513          	add	a0,a0,708 # 800088a8 <syscall_names+0x2f8>
    800055ec:	ffffb097          	auipc	ra,0xffffb
    800055f0:	f56080e7          	jalr	-170(ra) # 80000542 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055f4:	04c92703          	lw	a4,76(s2)
    800055f8:	02000793          	li	a5,32
    800055fc:	f6e7f9e3          	bgeu	a5,a4,8000556e <sys_unlink+0xaa>
    80005600:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005604:	4741                	li	a4,16
    80005606:	86ce                	mv	a3,s3
    80005608:	f1840613          	add	a2,s0,-232
    8000560c:	4581                	li	a1,0
    8000560e:	854a                	mv	a0,s2
    80005610:	ffffe097          	auipc	ra,0xffffe
    80005614:	3de080e7          	jalr	990(ra) # 800039ee <readi>
    80005618:	47c1                	li	a5,16
    8000561a:	00f51b63          	bne	a0,a5,80005630 <sys_unlink+0x16c>
    if(de.inum != 0)
    8000561e:	f1845783          	lhu	a5,-232(s0)
    80005622:	e7a1                	bnez	a5,8000566a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005624:	29c1                	addw	s3,s3,16
    80005626:	04c92783          	lw	a5,76(s2)
    8000562a:	fcf9ede3          	bltu	s3,a5,80005604 <sys_unlink+0x140>
    8000562e:	b781                	j	8000556e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005630:	00003517          	auipc	a0,0x3
    80005634:	29050513          	add	a0,a0,656 # 800088c0 <syscall_names+0x310>
    80005638:	ffffb097          	auipc	ra,0xffffb
    8000563c:	f0a080e7          	jalr	-246(ra) # 80000542 <panic>
    panic("unlink: writei");
    80005640:	00003517          	auipc	a0,0x3
    80005644:	29850513          	add	a0,a0,664 # 800088d8 <syscall_names+0x328>
    80005648:	ffffb097          	auipc	ra,0xffffb
    8000564c:	efa080e7          	jalr	-262(ra) # 80000542 <panic>
    dp->nlink--;
    80005650:	04a4d783          	lhu	a5,74(s1)
    80005654:	37fd                	addw	a5,a5,-1
    80005656:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000565a:	8526                	mv	a0,s1
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	012080e7          	jalr	18(ra) # 8000366e <iupdate>
    80005664:	b781                	j	800055a4 <sys_unlink+0xe0>
    return -1;
    80005666:	557d                	li	a0,-1
    80005668:	a005                	j	80005688 <sys_unlink+0x1c4>
    iunlockput(ip);
    8000566a:	854a                	mv	a0,s2
    8000566c:	ffffe097          	auipc	ra,0xffffe
    80005670:	330080e7          	jalr	816(ra) # 8000399c <iunlockput>
  iunlockput(dp);
    80005674:	8526                	mv	a0,s1
    80005676:	ffffe097          	auipc	ra,0xffffe
    8000567a:	326080e7          	jalr	806(ra) # 8000399c <iunlockput>
  end_op();
    8000567e:	fffff097          	auipc	ra,0xfffff
    80005682:	ad6080e7          	jalr	-1322(ra) # 80004154 <end_op>
  return -1;
    80005686:	557d                	li	a0,-1
}
    80005688:	70ae                	ld	ra,232(sp)
    8000568a:	740e                	ld	s0,224(sp)
    8000568c:	64ee                	ld	s1,216(sp)
    8000568e:	694e                	ld	s2,208(sp)
    80005690:	69ae                	ld	s3,200(sp)
    80005692:	616d                	add	sp,sp,240
    80005694:	8082                	ret

0000000080005696 <sys_open>:

uint64
sys_open(void)
{
    80005696:	7131                	add	sp,sp,-192
    80005698:	fd06                	sd	ra,184(sp)
    8000569a:	f922                	sd	s0,176(sp)
    8000569c:	f526                	sd	s1,168(sp)
    8000569e:	f14a                	sd	s2,160(sp)
    800056a0:	ed4e                	sd	s3,152(sp)
    800056a2:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056a4:	08000613          	li	a2,128
    800056a8:	f5040593          	add	a1,s0,-176
    800056ac:	4501                	li	a0,0
    800056ae:	ffffd097          	auipc	ra,0xffffd
    800056b2:	49c080e7          	jalr	1180(ra) # 80002b4a <argstr>
    return -1;
    800056b6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056b8:	0c054063          	bltz	a0,80005778 <sys_open+0xe2>
    800056bc:	f4c40593          	add	a1,s0,-180
    800056c0:	4505                	li	a0,1
    800056c2:	ffffd097          	auipc	ra,0xffffd
    800056c6:	444080e7          	jalr	1092(ra) # 80002b06 <argint>
    800056ca:	0a054763          	bltz	a0,80005778 <sys_open+0xe2>

  begin_op();
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	a0c080e7          	jalr	-1524(ra) # 800040da <begin_op>

  if(omode & O_CREATE){
    800056d6:	f4c42783          	lw	a5,-180(s0)
    800056da:	2007f793          	and	a5,a5,512
    800056de:	cbd5                	beqz	a5,80005792 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800056e0:	4681                	li	a3,0
    800056e2:	4601                	li	a2,0
    800056e4:	4589                	li	a1,2
    800056e6:	f5040513          	add	a0,s0,-176
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	974080e7          	jalr	-1676(ra) # 8000505e <create>
    800056f2:	892a                	mv	s2,a0
    if(ip == 0){
    800056f4:	c951                	beqz	a0,80005788 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056f6:	04491703          	lh	a4,68(s2)
    800056fa:	478d                	li	a5,3
    800056fc:	00f71763          	bne	a4,a5,8000570a <sys_open+0x74>
    80005700:	04695703          	lhu	a4,70(s2)
    80005704:	47a5                	li	a5,9
    80005706:	0ce7eb63          	bltu	a5,a4,800057dc <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000570a:	fffff097          	auipc	ra,0xfffff
    8000570e:	dde080e7          	jalr	-546(ra) # 800044e8 <filealloc>
    80005712:	89aa                	mv	s3,a0
    80005714:	c565                	beqz	a0,800057fc <sys_open+0x166>
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	906080e7          	jalr	-1786(ra) # 8000501c <fdalloc>
    8000571e:	84aa                	mv	s1,a0
    80005720:	0c054963          	bltz	a0,800057f2 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005724:	04491703          	lh	a4,68(s2)
    80005728:	478d                	li	a5,3
    8000572a:	0ef70463          	beq	a4,a5,80005812 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000572e:	4789                	li	a5,2
    80005730:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005734:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005738:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000573c:	f4c42783          	lw	a5,-180(s0)
    80005740:	0017c713          	xor	a4,a5,1
    80005744:	8b05                	and	a4,a4,1
    80005746:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000574a:	0037f713          	and	a4,a5,3
    8000574e:	00e03733          	snez	a4,a4
    80005752:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005756:	4007f793          	and	a5,a5,1024
    8000575a:	c791                	beqz	a5,80005766 <sys_open+0xd0>
    8000575c:	04491703          	lh	a4,68(s2)
    80005760:	4789                	li	a5,2
    80005762:	0af70f63          	beq	a4,a5,80005820 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005766:	854a                	mv	a0,s2
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	094080e7          	jalr	148(ra) # 800037fc <iunlock>
  end_op();
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	9e4080e7          	jalr	-1564(ra) # 80004154 <end_op>

  return fd;
}
    80005778:	8526                	mv	a0,s1
    8000577a:	70ea                	ld	ra,184(sp)
    8000577c:	744a                	ld	s0,176(sp)
    8000577e:	74aa                	ld	s1,168(sp)
    80005780:	790a                	ld	s2,160(sp)
    80005782:	69ea                	ld	s3,152(sp)
    80005784:	6129                	add	sp,sp,192
    80005786:	8082                	ret
      end_op();
    80005788:	fffff097          	auipc	ra,0xfffff
    8000578c:	9cc080e7          	jalr	-1588(ra) # 80004154 <end_op>
      return -1;
    80005790:	b7e5                	j	80005778 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80005792:	f5040513          	add	a0,s0,-176
    80005796:	ffffe097          	auipc	ra,0xffffe
    8000579a:	754080e7          	jalr	1876(ra) # 80003eea <namei>
    8000579e:	892a                	mv	s2,a0
    800057a0:	c905                	beqz	a0,800057d0 <sys_open+0x13a>
    ilock(ip);
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	f98080e7          	jalr	-104(ra) # 8000373a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057aa:	04491703          	lh	a4,68(s2)
    800057ae:	4785                	li	a5,1
    800057b0:	f4f713e3          	bne	a4,a5,800056f6 <sys_open+0x60>
    800057b4:	f4c42783          	lw	a5,-180(s0)
    800057b8:	dba9                	beqz	a5,8000570a <sys_open+0x74>
      iunlockput(ip);
    800057ba:	854a                	mv	a0,s2
    800057bc:	ffffe097          	auipc	ra,0xffffe
    800057c0:	1e0080e7          	jalr	480(ra) # 8000399c <iunlockput>
      end_op();
    800057c4:	fffff097          	auipc	ra,0xfffff
    800057c8:	990080e7          	jalr	-1648(ra) # 80004154 <end_op>
      return -1;
    800057cc:	54fd                	li	s1,-1
    800057ce:	b76d                	j	80005778 <sys_open+0xe2>
      end_op();
    800057d0:	fffff097          	auipc	ra,0xfffff
    800057d4:	984080e7          	jalr	-1660(ra) # 80004154 <end_op>
      return -1;
    800057d8:	54fd                	li	s1,-1
    800057da:	bf79                	j	80005778 <sys_open+0xe2>
    iunlockput(ip);
    800057dc:	854a                	mv	a0,s2
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	1be080e7          	jalr	446(ra) # 8000399c <iunlockput>
    end_op();
    800057e6:	fffff097          	auipc	ra,0xfffff
    800057ea:	96e080e7          	jalr	-1682(ra) # 80004154 <end_op>
    return -1;
    800057ee:	54fd                	li	s1,-1
    800057f0:	b761                	j	80005778 <sys_open+0xe2>
      fileclose(f);
    800057f2:	854e                	mv	a0,s3
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	db0080e7          	jalr	-592(ra) # 800045a4 <fileclose>
    iunlockput(ip);
    800057fc:	854a                	mv	a0,s2
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	19e080e7          	jalr	414(ra) # 8000399c <iunlockput>
    end_op();
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	94e080e7          	jalr	-1714(ra) # 80004154 <end_op>
    return -1;
    8000580e:	54fd                	li	s1,-1
    80005810:	b7a5                	j	80005778 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80005812:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005816:	04691783          	lh	a5,70(s2)
    8000581a:	02f99223          	sh	a5,36(s3)
    8000581e:	bf29                	j	80005738 <sys_open+0xa2>
    itrunc(ip);
    80005820:	854a                	mv	a0,s2
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	026080e7          	jalr	38(ra) # 80003848 <itrunc>
    8000582a:	bf35                	j	80005766 <sys_open+0xd0>

000000008000582c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000582c:	7175                	add	sp,sp,-144
    8000582e:	e506                	sd	ra,136(sp)
    80005830:	e122                	sd	s0,128(sp)
    80005832:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005834:	fffff097          	auipc	ra,0xfffff
    80005838:	8a6080e7          	jalr	-1882(ra) # 800040da <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000583c:	08000613          	li	a2,128
    80005840:	f7040593          	add	a1,s0,-144
    80005844:	4501                	li	a0,0
    80005846:	ffffd097          	auipc	ra,0xffffd
    8000584a:	304080e7          	jalr	772(ra) # 80002b4a <argstr>
    8000584e:	02054963          	bltz	a0,80005880 <sys_mkdir+0x54>
    80005852:	4681                	li	a3,0
    80005854:	4601                	li	a2,0
    80005856:	4585                	li	a1,1
    80005858:	f7040513          	add	a0,s0,-144
    8000585c:	00000097          	auipc	ra,0x0
    80005860:	802080e7          	jalr	-2046(ra) # 8000505e <create>
    80005864:	cd11                	beqz	a0,80005880 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005866:	ffffe097          	auipc	ra,0xffffe
    8000586a:	136080e7          	jalr	310(ra) # 8000399c <iunlockput>
  end_op();
    8000586e:	fffff097          	auipc	ra,0xfffff
    80005872:	8e6080e7          	jalr	-1818(ra) # 80004154 <end_op>
  return 0;
    80005876:	4501                	li	a0,0
}
    80005878:	60aa                	ld	ra,136(sp)
    8000587a:	640a                	ld	s0,128(sp)
    8000587c:	6149                	add	sp,sp,144
    8000587e:	8082                	ret
    end_op();
    80005880:	fffff097          	auipc	ra,0xfffff
    80005884:	8d4080e7          	jalr	-1836(ra) # 80004154 <end_op>
    return -1;
    80005888:	557d                	li	a0,-1
    8000588a:	b7fd                	j	80005878 <sys_mkdir+0x4c>

000000008000588c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000588c:	7135                	add	sp,sp,-160
    8000588e:	ed06                	sd	ra,152(sp)
    80005890:	e922                	sd	s0,144(sp)
    80005892:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005894:	fffff097          	auipc	ra,0xfffff
    80005898:	846080e7          	jalr	-1978(ra) # 800040da <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000589c:	08000613          	li	a2,128
    800058a0:	f7040593          	add	a1,s0,-144
    800058a4:	4501                	li	a0,0
    800058a6:	ffffd097          	auipc	ra,0xffffd
    800058aa:	2a4080e7          	jalr	676(ra) # 80002b4a <argstr>
    800058ae:	04054a63          	bltz	a0,80005902 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800058b2:	f6c40593          	add	a1,s0,-148
    800058b6:	4505                	li	a0,1
    800058b8:	ffffd097          	auipc	ra,0xffffd
    800058bc:	24e080e7          	jalr	590(ra) # 80002b06 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058c0:	04054163          	bltz	a0,80005902 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800058c4:	f6840593          	add	a1,s0,-152
    800058c8:	4509                	li	a0,2
    800058ca:	ffffd097          	auipc	ra,0xffffd
    800058ce:	23c080e7          	jalr	572(ra) # 80002b06 <argint>
     argint(1, &major) < 0 ||
    800058d2:	02054863          	bltz	a0,80005902 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800058d6:	f6841683          	lh	a3,-152(s0)
    800058da:	f6c41603          	lh	a2,-148(s0)
    800058de:	458d                	li	a1,3
    800058e0:	f7040513          	add	a0,s0,-144
    800058e4:	fffff097          	auipc	ra,0xfffff
    800058e8:	77a080e7          	jalr	1914(ra) # 8000505e <create>
     argint(2, &minor) < 0 ||
    800058ec:	c919                	beqz	a0,80005902 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058ee:	ffffe097          	auipc	ra,0xffffe
    800058f2:	0ae080e7          	jalr	174(ra) # 8000399c <iunlockput>
  end_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	85e080e7          	jalr	-1954(ra) # 80004154 <end_op>
  return 0;
    800058fe:	4501                	li	a0,0
    80005900:	a031                	j	8000590c <sys_mknod+0x80>
    end_op();
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	852080e7          	jalr	-1966(ra) # 80004154 <end_op>
    return -1;
    8000590a:	557d                	li	a0,-1
}
    8000590c:	60ea                	ld	ra,152(sp)
    8000590e:	644a                	ld	s0,144(sp)
    80005910:	610d                	add	sp,sp,160
    80005912:	8082                	ret

0000000080005914 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005914:	7135                	add	sp,sp,-160
    80005916:	ed06                	sd	ra,152(sp)
    80005918:	e922                	sd	s0,144(sp)
    8000591a:	e526                	sd	s1,136(sp)
    8000591c:	e14a                	sd	s2,128(sp)
    8000591e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005920:	ffffc097          	auipc	ra,0xffffc
    80005924:	0f0080e7          	jalr	240(ra) # 80001a10 <myproc>
    80005928:	892a                	mv	s2,a0
  
  begin_op();
    8000592a:	ffffe097          	auipc	ra,0xffffe
    8000592e:	7b0080e7          	jalr	1968(ra) # 800040da <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005932:	08000613          	li	a2,128
    80005936:	f6040593          	add	a1,s0,-160
    8000593a:	4501                	li	a0,0
    8000593c:	ffffd097          	auipc	ra,0xffffd
    80005940:	20e080e7          	jalr	526(ra) # 80002b4a <argstr>
    80005944:	04054b63          	bltz	a0,8000599a <sys_chdir+0x86>
    80005948:	f6040513          	add	a0,s0,-160
    8000594c:	ffffe097          	auipc	ra,0xffffe
    80005950:	59e080e7          	jalr	1438(ra) # 80003eea <namei>
    80005954:	84aa                	mv	s1,a0
    80005956:	c131                	beqz	a0,8000599a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005958:	ffffe097          	auipc	ra,0xffffe
    8000595c:	de2080e7          	jalr	-542(ra) # 8000373a <ilock>
  if(ip->type != T_DIR){
    80005960:	04449703          	lh	a4,68(s1)
    80005964:	4785                	li	a5,1
    80005966:	04f71063          	bne	a4,a5,800059a6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000596a:	8526                	mv	a0,s1
    8000596c:	ffffe097          	auipc	ra,0xffffe
    80005970:	e90080e7          	jalr	-368(ra) # 800037fc <iunlock>
  iput(p->cwd);
    80005974:	15093503          	ld	a0,336(s2)
    80005978:	ffffe097          	auipc	ra,0xffffe
    8000597c:	f7c080e7          	jalr	-132(ra) # 800038f4 <iput>
  end_op();
    80005980:	ffffe097          	auipc	ra,0xffffe
    80005984:	7d4080e7          	jalr	2004(ra) # 80004154 <end_op>
  p->cwd = ip;
    80005988:	14993823          	sd	s1,336(s2)
  return 0;
    8000598c:	4501                	li	a0,0
}
    8000598e:	60ea                	ld	ra,152(sp)
    80005990:	644a                	ld	s0,144(sp)
    80005992:	64aa                	ld	s1,136(sp)
    80005994:	690a                	ld	s2,128(sp)
    80005996:	610d                	add	sp,sp,160
    80005998:	8082                	ret
    end_op();
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	7ba080e7          	jalr	1978(ra) # 80004154 <end_op>
    return -1;
    800059a2:	557d                	li	a0,-1
    800059a4:	b7ed                	j	8000598e <sys_chdir+0x7a>
    iunlockput(ip);
    800059a6:	8526                	mv	a0,s1
    800059a8:	ffffe097          	auipc	ra,0xffffe
    800059ac:	ff4080e7          	jalr	-12(ra) # 8000399c <iunlockput>
    end_op();
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	7a4080e7          	jalr	1956(ra) # 80004154 <end_op>
    return -1;
    800059b8:	557d                	li	a0,-1
    800059ba:	bfd1                	j	8000598e <sys_chdir+0x7a>

00000000800059bc <sys_exec>:

uint64
sys_exec(void)
{
    800059bc:	7121                	add	sp,sp,-448
    800059be:	ff06                	sd	ra,440(sp)
    800059c0:	fb22                	sd	s0,432(sp)
    800059c2:	f726                	sd	s1,424(sp)
    800059c4:	f34a                	sd	s2,416(sp)
    800059c6:	ef4e                	sd	s3,408(sp)
    800059c8:	eb52                	sd	s4,400(sp)
    800059ca:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059cc:	08000613          	li	a2,128
    800059d0:	f5040593          	add	a1,s0,-176
    800059d4:	4501                	li	a0,0
    800059d6:	ffffd097          	auipc	ra,0xffffd
    800059da:	174080e7          	jalr	372(ra) # 80002b4a <argstr>
    return -1;
    800059de:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059e0:	0c054a63          	bltz	a0,80005ab4 <sys_exec+0xf8>
    800059e4:	e4840593          	add	a1,s0,-440
    800059e8:	4505                	li	a0,1
    800059ea:	ffffd097          	auipc	ra,0xffffd
    800059ee:	13e080e7          	jalr	318(ra) # 80002b28 <argaddr>
    800059f2:	0c054163          	bltz	a0,80005ab4 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800059f6:	10000613          	li	a2,256
    800059fa:	4581                	li	a1,0
    800059fc:	e5040513          	add	a0,s0,-432
    80005a00:	ffffb097          	auipc	ra,0xffffb
    80005a04:	342080e7          	jalr	834(ra) # 80000d42 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a08:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005a0c:	89a6                	mv	s3,s1
    80005a0e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a10:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a14:	00391513          	sll	a0,s2,0x3
    80005a18:	e4040593          	add	a1,s0,-448
    80005a1c:	e4843783          	ld	a5,-440(s0)
    80005a20:	953e                	add	a0,a0,a5
    80005a22:	ffffd097          	auipc	ra,0xffffd
    80005a26:	04a080e7          	jalr	74(ra) # 80002a6c <fetchaddr>
    80005a2a:	02054a63          	bltz	a0,80005a5e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005a2e:	e4043783          	ld	a5,-448(s0)
    80005a32:	c3b9                	beqz	a5,80005a78 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a34:	ffffb097          	auipc	ra,0xffffb
    80005a38:	0d8080e7          	jalr	216(ra) # 80000b0c <kalloc>
    80005a3c:	85aa                	mv	a1,a0
    80005a3e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a42:	cd11                	beqz	a0,80005a5e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a44:	6605                	lui	a2,0x1
    80005a46:	e4043503          	ld	a0,-448(s0)
    80005a4a:	ffffd097          	auipc	ra,0xffffd
    80005a4e:	074080e7          	jalr	116(ra) # 80002abe <fetchstr>
    80005a52:	00054663          	bltz	a0,80005a5e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005a56:	0905                	add	s2,s2,1
    80005a58:	09a1                	add	s3,s3,8
    80005a5a:	fb491de3          	bne	s2,s4,80005a14 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a5e:	f5040913          	add	s2,s0,-176
    80005a62:	6088                	ld	a0,0(s1)
    80005a64:	c539                	beqz	a0,80005ab2 <sys_exec+0xf6>
    kfree(argv[i]);
    80005a66:	ffffb097          	auipc	ra,0xffffb
    80005a6a:	fa8080e7          	jalr	-88(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a6e:	04a1                	add	s1,s1,8
    80005a70:	ff2499e3          	bne	s1,s2,80005a62 <sys_exec+0xa6>
  return -1;
    80005a74:	597d                	li	s2,-1
    80005a76:	a83d                	j	80005ab4 <sys_exec+0xf8>
      argv[i] = 0;
    80005a78:	0009079b          	sext.w	a5,s2
    80005a7c:	078e                	sll	a5,a5,0x3
    80005a7e:	fd078793          	add	a5,a5,-48
    80005a82:	97a2                	add	a5,a5,s0
    80005a84:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005a88:	e5040593          	add	a1,s0,-432
    80005a8c:	f5040513          	add	a0,s0,-176
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	196080e7          	jalr	406(ra) # 80004c26 <exec>
    80005a98:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a9a:	f5040993          	add	s3,s0,-176
    80005a9e:	6088                	ld	a0,0(s1)
    80005aa0:	c911                	beqz	a0,80005ab4 <sys_exec+0xf8>
    kfree(argv[i]);
    80005aa2:	ffffb097          	auipc	ra,0xffffb
    80005aa6:	f6c080e7          	jalr	-148(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aaa:	04a1                	add	s1,s1,8
    80005aac:	ff3499e3          	bne	s1,s3,80005a9e <sys_exec+0xe2>
    80005ab0:	a011                	j	80005ab4 <sys_exec+0xf8>
  return -1;
    80005ab2:	597d                	li	s2,-1
}
    80005ab4:	854a                	mv	a0,s2
    80005ab6:	70fa                	ld	ra,440(sp)
    80005ab8:	745a                	ld	s0,432(sp)
    80005aba:	74ba                	ld	s1,424(sp)
    80005abc:	791a                	ld	s2,416(sp)
    80005abe:	69fa                	ld	s3,408(sp)
    80005ac0:	6a5a                	ld	s4,400(sp)
    80005ac2:	6139                	add	sp,sp,448
    80005ac4:	8082                	ret

0000000080005ac6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ac6:	7139                	add	sp,sp,-64
    80005ac8:	fc06                	sd	ra,56(sp)
    80005aca:	f822                	sd	s0,48(sp)
    80005acc:	f426                	sd	s1,40(sp)
    80005ace:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ad0:	ffffc097          	auipc	ra,0xffffc
    80005ad4:	f40080e7          	jalr	-192(ra) # 80001a10 <myproc>
    80005ad8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ada:	fd840593          	add	a1,s0,-40
    80005ade:	4501                	li	a0,0
    80005ae0:	ffffd097          	auipc	ra,0xffffd
    80005ae4:	048080e7          	jalr	72(ra) # 80002b28 <argaddr>
    return -1;
    80005ae8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005aea:	0e054063          	bltz	a0,80005bca <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005aee:	fc840593          	add	a1,s0,-56
    80005af2:	fd040513          	add	a0,s0,-48
    80005af6:	fffff097          	auipc	ra,0xfffff
    80005afa:	e04080e7          	jalr	-508(ra) # 800048fa <pipealloc>
    return -1;
    80005afe:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b00:	0c054563          	bltz	a0,80005bca <sys_pipe+0x104>
  fd0 = -1;
    80005b04:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b08:	fd043503          	ld	a0,-48(s0)
    80005b0c:	fffff097          	auipc	ra,0xfffff
    80005b10:	510080e7          	jalr	1296(ra) # 8000501c <fdalloc>
    80005b14:	fca42223          	sw	a0,-60(s0)
    80005b18:	08054c63          	bltz	a0,80005bb0 <sys_pipe+0xea>
    80005b1c:	fc843503          	ld	a0,-56(s0)
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	4fc080e7          	jalr	1276(ra) # 8000501c <fdalloc>
    80005b28:	fca42023          	sw	a0,-64(s0)
    80005b2c:	06054963          	bltz	a0,80005b9e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b30:	4691                	li	a3,4
    80005b32:	fc440613          	add	a2,s0,-60
    80005b36:	fd843583          	ld	a1,-40(s0)
    80005b3a:	68a8                	ld	a0,80(s1)
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	bca080e7          	jalr	-1078(ra) # 80001706 <copyout>
    80005b44:	02054063          	bltz	a0,80005b64 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b48:	4691                	li	a3,4
    80005b4a:	fc040613          	add	a2,s0,-64
    80005b4e:	fd843583          	ld	a1,-40(s0)
    80005b52:	0591                	add	a1,a1,4
    80005b54:	68a8                	ld	a0,80(s1)
    80005b56:	ffffc097          	auipc	ra,0xffffc
    80005b5a:	bb0080e7          	jalr	-1104(ra) # 80001706 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b5e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b60:	06055563          	bgez	a0,80005bca <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b64:	fc442783          	lw	a5,-60(s0)
    80005b68:	07e9                	add	a5,a5,26
    80005b6a:	078e                	sll	a5,a5,0x3
    80005b6c:	97a6                	add	a5,a5,s1
    80005b6e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b72:	fc042783          	lw	a5,-64(s0)
    80005b76:	07e9                	add	a5,a5,26
    80005b78:	078e                	sll	a5,a5,0x3
    80005b7a:	00f48533          	add	a0,s1,a5
    80005b7e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b82:	fd043503          	ld	a0,-48(s0)
    80005b86:	fffff097          	auipc	ra,0xfffff
    80005b8a:	a1e080e7          	jalr	-1506(ra) # 800045a4 <fileclose>
    fileclose(wf);
    80005b8e:	fc843503          	ld	a0,-56(s0)
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	a12080e7          	jalr	-1518(ra) # 800045a4 <fileclose>
    return -1;
    80005b9a:	57fd                	li	a5,-1
    80005b9c:	a03d                	j	80005bca <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b9e:	fc442783          	lw	a5,-60(s0)
    80005ba2:	0007c763          	bltz	a5,80005bb0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ba6:	07e9                	add	a5,a5,26
    80005ba8:	078e                	sll	a5,a5,0x3
    80005baa:	97a6                	add	a5,a5,s1
    80005bac:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005bb0:	fd043503          	ld	a0,-48(s0)
    80005bb4:	fffff097          	auipc	ra,0xfffff
    80005bb8:	9f0080e7          	jalr	-1552(ra) # 800045a4 <fileclose>
    fileclose(wf);
    80005bbc:	fc843503          	ld	a0,-56(s0)
    80005bc0:	fffff097          	auipc	ra,0xfffff
    80005bc4:	9e4080e7          	jalr	-1564(ra) # 800045a4 <fileclose>
    return -1;
    80005bc8:	57fd                	li	a5,-1
}
    80005bca:	853e                	mv	a0,a5
    80005bcc:	70e2                	ld	ra,56(sp)
    80005bce:	7442                	ld	s0,48(sp)
    80005bd0:	74a2                	ld	s1,40(sp)
    80005bd2:	6121                	add	sp,sp,64
    80005bd4:	8082                	ret
	...

0000000080005be0 <kernelvec>:
    80005be0:	7111                	add	sp,sp,-256
    80005be2:	e006                	sd	ra,0(sp)
    80005be4:	e40a                	sd	sp,8(sp)
    80005be6:	e80e                	sd	gp,16(sp)
    80005be8:	ec12                	sd	tp,24(sp)
    80005bea:	f016                	sd	t0,32(sp)
    80005bec:	f41a                	sd	t1,40(sp)
    80005bee:	f81e                	sd	t2,48(sp)
    80005bf0:	fc22                	sd	s0,56(sp)
    80005bf2:	e0a6                	sd	s1,64(sp)
    80005bf4:	e4aa                	sd	a0,72(sp)
    80005bf6:	e8ae                	sd	a1,80(sp)
    80005bf8:	ecb2                	sd	a2,88(sp)
    80005bfa:	f0b6                	sd	a3,96(sp)
    80005bfc:	f4ba                	sd	a4,104(sp)
    80005bfe:	f8be                	sd	a5,112(sp)
    80005c00:	fcc2                	sd	a6,120(sp)
    80005c02:	e146                	sd	a7,128(sp)
    80005c04:	e54a                	sd	s2,136(sp)
    80005c06:	e94e                	sd	s3,144(sp)
    80005c08:	ed52                	sd	s4,152(sp)
    80005c0a:	f156                	sd	s5,160(sp)
    80005c0c:	f55a                	sd	s6,168(sp)
    80005c0e:	f95e                	sd	s7,176(sp)
    80005c10:	fd62                	sd	s8,184(sp)
    80005c12:	e1e6                	sd	s9,192(sp)
    80005c14:	e5ea                	sd	s10,200(sp)
    80005c16:	e9ee                	sd	s11,208(sp)
    80005c18:	edf2                	sd	t3,216(sp)
    80005c1a:	f1f6                	sd	t4,224(sp)
    80005c1c:	f5fa                	sd	t5,232(sp)
    80005c1e:	f9fe                	sd	t6,240(sp)
    80005c20:	d19fc0ef          	jal	80002938 <kerneltrap>
    80005c24:	6082                	ld	ra,0(sp)
    80005c26:	6122                	ld	sp,8(sp)
    80005c28:	61c2                	ld	gp,16(sp)
    80005c2a:	7282                	ld	t0,32(sp)
    80005c2c:	7322                	ld	t1,40(sp)
    80005c2e:	73c2                	ld	t2,48(sp)
    80005c30:	7462                	ld	s0,56(sp)
    80005c32:	6486                	ld	s1,64(sp)
    80005c34:	6526                	ld	a0,72(sp)
    80005c36:	65c6                	ld	a1,80(sp)
    80005c38:	6666                	ld	a2,88(sp)
    80005c3a:	7686                	ld	a3,96(sp)
    80005c3c:	7726                	ld	a4,104(sp)
    80005c3e:	77c6                	ld	a5,112(sp)
    80005c40:	7866                	ld	a6,120(sp)
    80005c42:	688a                	ld	a7,128(sp)
    80005c44:	692a                	ld	s2,136(sp)
    80005c46:	69ca                	ld	s3,144(sp)
    80005c48:	6a6a                	ld	s4,152(sp)
    80005c4a:	7a8a                	ld	s5,160(sp)
    80005c4c:	7b2a                	ld	s6,168(sp)
    80005c4e:	7bca                	ld	s7,176(sp)
    80005c50:	7c6a                	ld	s8,184(sp)
    80005c52:	6c8e                	ld	s9,192(sp)
    80005c54:	6d2e                	ld	s10,200(sp)
    80005c56:	6dce                	ld	s11,208(sp)
    80005c58:	6e6e                	ld	t3,216(sp)
    80005c5a:	7e8e                	ld	t4,224(sp)
    80005c5c:	7f2e                	ld	t5,232(sp)
    80005c5e:	7fce                	ld	t6,240(sp)
    80005c60:	6111                	add	sp,sp,256
    80005c62:	10200073          	sret
    80005c66:	00000013          	nop
    80005c6a:	00000013          	nop
    80005c6e:	0001                	nop

0000000080005c70 <timervec>:
    80005c70:	34051573          	csrrw	a0,mscratch,a0
    80005c74:	e10c                	sd	a1,0(a0)
    80005c76:	e510                	sd	a2,8(a0)
    80005c78:	e914                	sd	a3,16(a0)
    80005c7a:	710c                	ld	a1,32(a0)
    80005c7c:	7510                	ld	a2,40(a0)
    80005c7e:	6194                	ld	a3,0(a1)
    80005c80:	96b2                	add	a3,a3,a2
    80005c82:	e194                	sd	a3,0(a1)
    80005c84:	4589                	li	a1,2
    80005c86:	14459073          	csrw	sip,a1
    80005c8a:	6914                	ld	a3,16(a0)
    80005c8c:	6510                	ld	a2,8(a0)
    80005c8e:	610c                	ld	a1,0(a0)
    80005c90:	34051573          	csrrw	a0,mscratch,a0
    80005c94:	30200073          	mret
	...

0000000080005c9a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c9a:	1141                	add	sp,sp,-16
    80005c9c:	e422                	sd	s0,8(sp)
    80005c9e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ca0:	0c0007b7          	lui	a5,0xc000
    80005ca4:	4705                	li	a4,1
    80005ca6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005ca8:	c3d8                	sw	a4,4(a5)
}
    80005caa:	6422                	ld	s0,8(sp)
    80005cac:	0141                	add	sp,sp,16
    80005cae:	8082                	ret

0000000080005cb0 <plicinithart>:

void
plicinithart(void)
{
    80005cb0:	1141                	add	sp,sp,-16
    80005cb2:	e406                	sd	ra,8(sp)
    80005cb4:	e022                	sd	s0,0(sp)
    80005cb6:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005cb8:	ffffc097          	auipc	ra,0xffffc
    80005cbc:	d2c080e7          	jalr	-724(ra) # 800019e4 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005cc0:	0085171b          	sllw	a4,a0,0x8
    80005cc4:	0c0027b7          	lui	a5,0xc002
    80005cc8:	97ba                	add	a5,a5,a4
    80005cca:	40200713          	li	a4,1026
    80005cce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cd2:	00d5151b          	sllw	a0,a0,0xd
    80005cd6:	0c2017b7          	lui	a5,0xc201
    80005cda:	97aa                	add	a5,a5,a0
    80005cdc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005ce0:	60a2                	ld	ra,8(sp)
    80005ce2:	6402                	ld	s0,0(sp)
    80005ce4:	0141                	add	sp,sp,16
    80005ce6:	8082                	ret

0000000080005ce8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ce8:	1141                	add	sp,sp,-16
    80005cea:	e406                	sd	ra,8(sp)
    80005cec:	e022                	sd	s0,0(sp)
    80005cee:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005cf0:	ffffc097          	auipc	ra,0xffffc
    80005cf4:	cf4080e7          	jalr	-780(ra) # 800019e4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cf8:	00d5151b          	sllw	a0,a0,0xd
    80005cfc:	0c2017b7          	lui	a5,0xc201
    80005d00:	97aa                	add	a5,a5,a0
  return irq;
}
    80005d02:	43c8                	lw	a0,4(a5)
    80005d04:	60a2                	ld	ra,8(sp)
    80005d06:	6402                	ld	s0,0(sp)
    80005d08:	0141                	add	sp,sp,16
    80005d0a:	8082                	ret

0000000080005d0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d0c:	1101                	add	sp,sp,-32
    80005d0e:	ec06                	sd	ra,24(sp)
    80005d10:	e822                	sd	s0,16(sp)
    80005d12:	e426                	sd	s1,8(sp)
    80005d14:	1000                	add	s0,sp,32
    80005d16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d18:	ffffc097          	auipc	ra,0xffffc
    80005d1c:	ccc080e7          	jalr	-820(ra) # 800019e4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d20:	00d5151b          	sllw	a0,a0,0xd
    80005d24:	0c2017b7          	lui	a5,0xc201
    80005d28:	97aa                	add	a5,a5,a0
    80005d2a:	c3c4                	sw	s1,4(a5)
}
    80005d2c:	60e2                	ld	ra,24(sp)
    80005d2e:	6442                	ld	s0,16(sp)
    80005d30:	64a2                	ld	s1,8(sp)
    80005d32:	6105                	add	sp,sp,32
    80005d34:	8082                	ret

0000000080005d36 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d36:	1141                	add	sp,sp,-16
    80005d38:	e406                	sd	ra,8(sp)
    80005d3a:	e022                	sd	s0,0(sp)
    80005d3c:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005d3e:	479d                	li	a5,7
    80005d40:	04a7cb63          	blt	a5,a0,80005d96 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005d44:	0001d717          	auipc	a4,0x1d
    80005d48:	2bc70713          	add	a4,a4,700 # 80023000 <disk>
    80005d4c:	972a                	add	a4,a4,a0
    80005d4e:	6789                	lui	a5,0x2
    80005d50:	97ba                	add	a5,a5,a4
    80005d52:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005d56:	eba1                	bnez	a5,80005da6 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005d58:	00451713          	sll	a4,a0,0x4
    80005d5c:	0001f797          	auipc	a5,0x1f
    80005d60:	2a47b783          	ld	a5,676(a5) # 80025000 <disk+0x2000>
    80005d64:	97ba                	add	a5,a5,a4
    80005d66:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005d6a:	0001d717          	auipc	a4,0x1d
    80005d6e:	29670713          	add	a4,a4,662 # 80023000 <disk>
    80005d72:	972a                	add	a4,a4,a0
    80005d74:	6789                	lui	a5,0x2
    80005d76:	97ba                	add	a5,a5,a4
    80005d78:	4705                	li	a4,1
    80005d7a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005d7e:	0001f517          	auipc	a0,0x1f
    80005d82:	29a50513          	add	a0,a0,666 # 80025018 <disk+0x2018>
    80005d86:	ffffc097          	auipc	ra,0xffffc
    80005d8a:	626080e7          	jalr	1574(ra) # 800023ac <wakeup>
}
    80005d8e:	60a2                	ld	ra,8(sp)
    80005d90:	6402                	ld	s0,0(sp)
    80005d92:	0141                	add	sp,sp,16
    80005d94:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d96:	00003517          	auipc	a0,0x3
    80005d9a:	b5250513          	add	a0,a0,-1198 # 800088e8 <syscall_names+0x338>
    80005d9e:	ffffa097          	auipc	ra,0xffffa
    80005da2:	7a4080e7          	jalr	1956(ra) # 80000542 <panic>
    panic("virtio_disk_intr 2");
    80005da6:	00003517          	auipc	a0,0x3
    80005daa:	b5a50513          	add	a0,a0,-1190 # 80008900 <syscall_names+0x350>
    80005dae:	ffffa097          	auipc	ra,0xffffa
    80005db2:	794080e7          	jalr	1940(ra) # 80000542 <panic>

0000000080005db6 <virtio_disk_init>:
{
    80005db6:	1101                	add	sp,sp,-32
    80005db8:	ec06                	sd	ra,24(sp)
    80005dba:	e822                	sd	s0,16(sp)
    80005dbc:	e426                	sd	s1,8(sp)
    80005dbe:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005dc0:	00003597          	auipc	a1,0x3
    80005dc4:	b5858593          	add	a1,a1,-1192 # 80008918 <syscall_names+0x368>
    80005dc8:	0001f517          	auipc	a0,0x1f
    80005dcc:	2e050513          	add	a0,a0,736 # 800250a8 <disk+0x20a8>
    80005dd0:	ffffb097          	auipc	ra,0xffffb
    80005dd4:	de6080e7          	jalr	-538(ra) # 80000bb6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dd8:	100017b7          	lui	a5,0x10001
    80005ddc:	4398                	lw	a4,0(a5)
    80005dde:	2701                	sext.w	a4,a4
    80005de0:	747277b7          	lui	a5,0x74727
    80005de4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005de8:	0ef71063          	bne	a4,a5,80005ec8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005dec:	100017b7          	lui	a5,0x10001
    80005df0:	43dc                	lw	a5,4(a5)
    80005df2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005df4:	4705                	li	a4,1
    80005df6:	0ce79963          	bne	a5,a4,80005ec8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dfa:	100017b7          	lui	a5,0x10001
    80005dfe:	479c                	lw	a5,8(a5)
    80005e00:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e02:	4709                	li	a4,2
    80005e04:	0ce79263          	bne	a5,a4,80005ec8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e08:	100017b7          	lui	a5,0x10001
    80005e0c:	47d8                	lw	a4,12(a5)
    80005e0e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e10:	554d47b7          	lui	a5,0x554d4
    80005e14:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e18:	0af71863          	bne	a4,a5,80005ec8 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e1c:	100017b7          	lui	a5,0x10001
    80005e20:	4705                	li	a4,1
    80005e22:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e24:	470d                	li	a4,3
    80005e26:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e28:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e2a:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e2e:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005e32:	8f75                	and	a4,a4,a3
    80005e34:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e36:	472d                	li	a4,11
    80005e38:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e3a:	473d                	li	a4,15
    80005e3c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e3e:	6705                	lui	a4,0x1
    80005e40:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e42:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e46:	5bdc                	lw	a5,52(a5)
    80005e48:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e4a:	c7d9                	beqz	a5,80005ed8 <virtio_disk_init+0x122>
  if(max < NUM)
    80005e4c:	471d                	li	a4,7
    80005e4e:	08f77d63          	bgeu	a4,a5,80005ee8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e52:	100014b7          	lui	s1,0x10001
    80005e56:	47a1                	li	a5,8
    80005e58:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005e5a:	6609                	lui	a2,0x2
    80005e5c:	4581                	li	a1,0
    80005e5e:	0001d517          	auipc	a0,0x1d
    80005e62:	1a250513          	add	a0,a0,418 # 80023000 <disk>
    80005e66:	ffffb097          	auipc	ra,0xffffb
    80005e6a:	edc080e7          	jalr	-292(ra) # 80000d42 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005e6e:	0001d717          	auipc	a4,0x1d
    80005e72:	19270713          	add	a4,a4,402 # 80023000 <disk>
    80005e76:	00c75793          	srl	a5,a4,0xc
    80005e7a:	2781                	sext.w	a5,a5
    80005e7c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005e7e:	0001f797          	auipc	a5,0x1f
    80005e82:	18278793          	add	a5,a5,386 # 80025000 <disk+0x2000>
    80005e86:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005e88:	0001d717          	auipc	a4,0x1d
    80005e8c:	1f870713          	add	a4,a4,504 # 80023080 <disk+0x80>
    80005e90:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005e92:	0001e717          	auipc	a4,0x1e
    80005e96:	16e70713          	add	a4,a4,366 # 80024000 <disk+0x1000>
    80005e9a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005e9c:	4705                	li	a4,1
    80005e9e:	00e78c23          	sb	a4,24(a5)
    80005ea2:	00e78ca3          	sb	a4,25(a5)
    80005ea6:	00e78d23          	sb	a4,26(a5)
    80005eaa:	00e78da3          	sb	a4,27(a5)
    80005eae:	00e78e23          	sb	a4,28(a5)
    80005eb2:	00e78ea3          	sb	a4,29(a5)
    80005eb6:	00e78f23          	sb	a4,30(a5)
    80005eba:	00e78fa3          	sb	a4,31(a5)
}
    80005ebe:	60e2                	ld	ra,24(sp)
    80005ec0:	6442                	ld	s0,16(sp)
    80005ec2:	64a2                	ld	s1,8(sp)
    80005ec4:	6105                	add	sp,sp,32
    80005ec6:	8082                	ret
    panic("could not find virtio disk");
    80005ec8:	00003517          	auipc	a0,0x3
    80005ecc:	a6050513          	add	a0,a0,-1440 # 80008928 <syscall_names+0x378>
    80005ed0:	ffffa097          	auipc	ra,0xffffa
    80005ed4:	672080e7          	jalr	1650(ra) # 80000542 <panic>
    panic("virtio disk has no queue 0");
    80005ed8:	00003517          	auipc	a0,0x3
    80005edc:	a7050513          	add	a0,a0,-1424 # 80008948 <syscall_names+0x398>
    80005ee0:	ffffa097          	auipc	ra,0xffffa
    80005ee4:	662080e7          	jalr	1634(ra) # 80000542 <panic>
    panic("virtio disk max queue too short");
    80005ee8:	00003517          	auipc	a0,0x3
    80005eec:	a8050513          	add	a0,a0,-1408 # 80008968 <syscall_names+0x3b8>
    80005ef0:	ffffa097          	auipc	ra,0xffffa
    80005ef4:	652080e7          	jalr	1618(ra) # 80000542 <panic>

0000000080005ef8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005ef8:	7119                	add	sp,sp,-128
    80005efa:	fc86                	sd	ra,120(sp)
    80005efc:	f8a2                	sd	s0,112(sp)
    80005efe:	f4a6                	sd	s1,104(sp)
    80005f00:	f0ca                	sd	s2,96(sp)
    80005f02:	ecce                	sd	s3,88(sp)
    80005f04:	e8d2                	sd	s4,80(sp)
    80005f06:	e4d6                	sd	s5,72(sp)
    80005f08:	e0da                	sd	s6,64(sp)
    80005f0a:	fc5e                	sd	s7,56(sp)
    80005f0c:	f862                	sd	s8,48(sp)
    80005f0e:	f466                	sd	s9,40(sp)
    80005f10:	f06a                	sd	s10,32(sp)
    80005f12:	0100                	add	s0,sp,128
    80005f14:	8a2a                	mv	s4,a0
    80005f16:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f18:	00c52c03          	lw	s8,12(a0)
    80005f1c:	001c1c1b          	sllw	s8,s8,0x1
    80005f20:	1c02                	sll	s8,s8,0x20
    80005f22:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005f26:	0001f517          	auipc	a0,0x1f
    80005f2a:	18250513          	add	a0,a0,386 # 800250a8 <disk+0x20a8>
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	d18080e7          	jalr	-744(ra) # 80000c46 <acquire>
  for(int i = 0; i < 3; i++){
    80005f36:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005f38:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005f3a:	0001db97          	auipc	s7,0x1d
    80005f3e:	0c6b8b93          	add	s7,s7,198 # 80023000 <disk>
    80005f42:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005f44:	4a8d                	li	s5,3
    80005f46:	a0b5                	j	80005fb2 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005f48:	00fb8733          	add	a4,s7,a5
    80005f4c:	975a                	add	a4,a4,s6
    80005f4e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005f52:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005f54:	0207c563          	bltz	a5,80005f7e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80005f58:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    80005f5a:	0591                	add	a1,a1,4
    80005f5c:	19560c63          	beq	a2,s5,800060f4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80005f60:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005f62:	0001f717          	auipc	a4,0x1f
    80005f66:	0b670713          	add	a4,a4,182 # 80025018 <disk+0x2018>
    80005f6a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005f6c:	00074683          	lbu	a3,0(a4)
    80005f70:	fee1                	bnez	a3,80005f48 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005f72:	2785                	addw	a5,a5,1
    80005f74:	0705                	add	a4,a4,1
    80005f76:	fe979be3          	bne	a5,s1,80005f6c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005f7a:	57fd                	li	a5,-1
    80005f7c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005f7e:	00c05e63          	blez	a2,80005f9a <virtio_disk_rw+0xa2>
    80005f82:	060a                	sll	a2,a2,0x2
    80005f84:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005f88:	0009a503          	lw	a0,0(s3)
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	daa080e7          	jalr	-598(ra) # 80005d36 <free_desc>
      for(int j = 0; j < i; j++)
    80005f94:	0991                	add	s3,s3,4
    80005f96:	ffa999e3          	bne	s3,s10,80005f88 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005f9a:	0001f597          	auipc	a1,0x1f
    80005f9e:	10e58593          	add	a1,a1,270 # 800250a8 <disk+0x20a8>
    80005fa2:	0001f517          	auipc	a0,0x1f
    80005fa6:	07650513          	add	a0,a0,118 # 80025018 <disk+0x2018>
    80005faa:	ffffc097          	auipc	ra,0xffffc
    80005fae:	282080e7          	jalr	642(ra) # 8000222c <sleep>
  for(int i = 0; i < 3; i++){
    80005fb2:	f9040993          	add	s3,s0,-112
{
    80005fb6:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005fb8:	864a                	mv	a2,s2
    80005fba:	b75d                	j	80005f60 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005fbc:	0001f717          	auipc	a4,0x1f
    80005fc0:	04473703          	ld	a4,68(a4) # 80025000 <disk+0x2000>
    80005fc4:	973e                	add	a4,a4,a5
    80005fc6:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005fca:	0001d517          	auipc	a0,0x1d
    80005fce:	03650513          	add	a0,a0,54 # 80023000 <disk>
    80005fd2:	0001f717          	auipc	a4,0x1f
    80005fd6:	02e70713          	add	a4,a4,46 # 80025000 <disk+0x2000>
    80005fda:	6314                	ld	a3,0(a4)
    80005fdc:	96be                	add	a3,a3,a5
    80005fde:	00c6d603          	lhu	a2,12(a3)
    80005fe2:	00166613          	or	a2,a2,1
    80005fe6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005fea:	f9842683          	lw	a3,-104(s0)
    80005fee:	6310                	ld	a2,0(a4)
    80005ff0:	97b2                	add	a5,a5,a2
    80005ff2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005ff6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005ffa:	0612                	sll	a2,a2,0x4
    80005ffc:	962a                	add	a2,a2,a0
    80005ffe:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006002:	00469793          	sll	a5,a3,0x4
    80006006:	630c                	ld	a1,0(a4)
    80006008:	95be                	add	a1,a1,a5
    8000600a:	6689                	lui	a3,0x2
    8000600c:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006010:	96ca                	add	a3,a3,s2
    80006012:	96aa                	add	a3,a3,a0
    80006014:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80006016:	6314                	ld	a3,0(a4)
    80006018:	96be                	add	a3,a3,a5
    8000601a:	4585                	li	a1,1
    8000601c:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000601e:	6314                	ld	a3,0(a4)
    80006020:	96be                	add	a3,a3,a5
    80006022:	4509                	li	a0,2
    80006024:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006028:	6314                	ld	a3,0(a4)
    8000602a:	97b6                	add	a5,a5,a3
    8000602c:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006030:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006034:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006038:	6714                	ld	a3,8(a4)
    8000603a:	0026d783          	lhu	a5,2(a3)
    8000603e:	8b9d                	and	a5,a5,7
    80006040:	0789                	add	a5,a5,2
    80006042:	0786                	sll	a5,a5,0x1
    80006044:	96be                	add	a3,a3,a5
    80006046:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    8000604a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000604e:	6718                	ld	a4,8(a4)
    80006050:	00275783          	lhu	a5,2(a4)
    80006054:	2785                	addw	a5,a5,1
    80006056:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000605a:	100017b7          	lui	a5,0x10001
    8000605e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006062:	004a2783          	lw	a5,4(s4)
    80006066:	02b79163          	bne	a5,a1,80006088 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000606a:	0001f917          	auipc	s2,0x1f
    8000606e:	03e90913          	add	s2,s2,62 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006072:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006074:	85ca                	mv	a1,s2
    80006076:	8552                	mv	a0,s4
    80006078:	ffffc097          	auipc	ra,0xffffc
    8000607c:	1b4080e7          	jalr	436(ra) # 8000222c <sleep>
  while(b->disk == 1) {
    80006080:	004a2783          	lw	a5,4(s4)
    80006084:	fe9788e3          	beq	a5,s1,80006074 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006088:	f9042483          	lw	s1,-112(s0)
    8000608c:	20048713          	add	a4,s1,512
    80006090:	0712                	sll	a4,a4,0x4
    80006092:	0001d797          	auipc	a5,0x1d
    80006096:	f6e78793          	add	a5,a5,-146 # 80023000 <disk>
    8000609a:	97ba                	add	a5,a5,a4
    8000609c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800060a0:	0001f917          	auipc	s2,0x1f
    800060a4:	f6090913          	add	s2,s2,-160 # 80025000 <disk+0x2000>
    800060a8:	a019                	j	800060ae <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    800060aa:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    800060ae:	8526                	mv	a0,s1
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	c86080e7          	jalr	-890(ra) # 80005d36 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800060b8:	0492                	sll	s1,s1,0x4
    800060ba:	00093783          	ld	a5,0(s2)
    800060be:	97a6                	add	a5,a5,s1
    800060c0:	00c7d703          	lhu	a4,12(a5)
    800060c4:	8b05                	and	a4,a4,1
    800060c6:	f375                	bnez	a4,800060aa <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800060c8:	0001f517          	auipc	a0,0x1f
    800060cc:	fe050513          	add	a0,a0,-32 # 800250a8 <disk+0x20a8>
    800060d0:	ffffb097          	auipc	ra,0xffffb
    800060d4:	c2a080e7          	jalr	-982(ra) # 80000cfa <release>
}
    800060d8:	70e6                	ld	ra,120(sp)
    800060da:	7446                	ld	s0,112(sp)
    800060dc:	74a6                	ld	s1,104(sp)
    800060de:	7906                	ld	s2,96(sp)
    800060e0:	69e6                	ld	s3,88(sp)
    800060e2:	6a46                	ld	s4,80(sp)
    800060e4:	6aa6                	ld	s5,72(sp)
    800060e6:	6b06                	ld	s6,64(sp)
    800060e8:	7be2                	ld	s7,56(sp)
    800060ea:	7c42                	ld	s8,48(sp)
    800060ec:	7ca2                	ld	s9,40(sp)
    800060ee:	7d02                	ld	s10,32(sp)
    800060f0:	6109                	add	sp,sp,128
    800060f2:	8082                	ret
  if(write)
    800060f4:	019037b3          	snez	a5,s9
    800060f8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    800060fc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006100:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006104:	f9042483          	lw	s1,-112(s0)
    80006108:	00449913          	sll	s2,s1,0x4
    8000610c:	0001f997          	auipc	s3,0x1f
    80006110:	ef498993          	add	s3,s3,-268 # 80025000 <disk+0x2000>
    80006114:	0009ba83          	ld	s5,0(s3)
    80006118:	9aca                	add	s5,s5,s2
    8000611a:	f8040513          	add	a0,s0,-128
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	ff2080e7          	jalr	-14(ra) # 80001110 <kvmpa>
    80006126:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000612a:	0009b783          	ld	a5,0(s3)
    8000612e:	97ca                	add	a5,a5,s2
    80006130:	4741                	li	a4,16
    80006132:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006134:	0009b783          	ld	a5,0(s3)
    80006138:	97ca                	add	a5,a5,s2
    8000613a:	4705                	li	a4,1
    8000613c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006140:	f9442783          	lw	a5,-108(s0)
    80006144:	0009b703          	ld	a4,0(s3)
    80006148:	974a                	add	a4,a4,s2
    8000614a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000614e:	0792                	sll	a5,a5,0x4
    80006150:	0009b703          	ld	a4,0(s3)
    80006154:	973e                	add	a4,a4,a5
    80006156:	058a0693          	add	a3,s4,88
    8000615a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000615c:	0009b703          	ld	a4,0(s3)
    80006160:	973e                	add	a4,a4,a5
    80006162:	40000693          	li	a3,1024
    80006166:	c714                	sw	a3,8(a4)
  if(write)
    80006168:	e40c9ae3          	bnez	s9,80005fbc <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000616c:	0001f717          	auipc	a4,0x1f
    80006170:	e9473703          	ld	a4,-364(a4) # 80025000 <disk+0x2000>
    80006174:	973e                	add	a4,a4,a5
    80006176:	4689                	li	a3,2
    80006178:	00d71623          	sh	a3,12(a4)
    8000617c:	b5b9                	j	80005fca <virtio_disk_rw+0xd2>

000000008000617e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000617e:	1101                	add	sp,sp,-32
    80006180:	ec06                	sd	ra,24(sp)
    80006182:	e822                	sd	s0,16(sp)
    80006184:	e426                	sd	s1,8(sp)
    80006186:	e04a                	sd	s2,0(sp)
    80006188:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000618a:	0001f517          	auipc	a0,0x1f
    8000618e:	f1e50513          	add	a0,a0,-226 # 800250a8 <disk+0x20a8>
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	ab4080e7          	jalr	-1356(ra) # 80000c46 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000619a:	0001f717          	auipc	a4,0x1f
    8000619e:	e6670713          	add	a4,a4,-410 # 80025000 <disk+0x2000>
    800061a2:	02075783          	lhu	a5,32(a4)
    800061a6:	6b18                	ld	a4,16(a4)
    800061a8:	00275683          	lhu	a3,2(a4)
    800061ac:	8ebd                	xor	a3,a3,a5
    800061ae:	8a9d                	and	a3,a3,7
    800061b0:	cab9                	beqz	a3,80006206 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800061b2:	0001d917          	auipc	s2,0x1d
    800061b6:	e4e90913          	add	s2,s2,-434 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061ba:	0001f497          	auipc	s1,0x1f
    800061be:	e4648493          	add	s1,s1,-442 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800061c2:	078e                	sll	a5,a5,0x3
    800061c4:	973e                	add	a4,a4,a5
    800061c6:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    800061c8:	20078713          	add	a4,a5,512
    800061cc:	0712                	sll	a4,a4,0x4
    800061ce:	974a                	add	a4,a4,s2
    800061d0:	03074703          	lbu	a4,48(a4)
    800061d4:	ef21                	bnez	a4,8000622c <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800061d6:	20078793          	add	a5,a5,512
    800061da:	0792                	sll	a5,a5,0x4
    800061dc:	97ca                	add	a5,a5,s2
    800061de:	7798                	ld	a4,40(a5)
    800061e0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800061e4:	7788                	ld	a0,40(a5)
    800061e6:	ffffc097          	auipc	ra,0xffffc
    800061ea:	1c6080e7          	jalr	454(ra) # 800023ac <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061ee:	0204d783          	lhu	a5,32(s1)
    800061f2:	2785                	addw	a5,a5,1
    800061f4:	8b9d                	and	a5,a5,7
    800061f6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800061fa:	6898                	ld	a4,16(s1)
    800061fc:	00275683          	lhu	a3,2(a4)
    80006200:	8a9d                	and	a3,a3,7
    80006202:	fcf690e3          	bne	a3,a5,800061c2 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006206:	10001737          	lui	a4,0x10001
    8000620a:	533c                	lw	a5,96(a4)
    8000620c:	8b8d                	and	a5,a5,3
    8000620e:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006210:	0001f517          	auipc	a0,0x1f
    80006214:	e9850513          	add	a0,a0,-360 # 800250a8 <disk+0x20a8>
    80006218:	ffffb097          	auipc	ra,0xffffb
    8000621c:	ae2080e7          	jalr	-1310(ra) # 80000cfa <release>
}
    80006220:	60e2                	ld	ra,24(sp)
    80006222:	6442                	ld	s0,16(sp)
    80006224:	64a2                	ld	s1,8(sp)
    80006226:	6902                	ld	s2,0(sp)
    80006228:	6105                	add	sp,sp,32
    8000622a:	8082                	ret
      panic("virtio_disk_intr status");
    8000622c:	00002517          	auipc	a0,0x2
    80006230:	75c50513          	add	a0,a0,1884 # 80008988 <syscall_names+0x3d8>
    80006234:	ffffa097          	auipc	ra,0xffffa
    80006238:	30e080e7          	jalr	782(ra) # 80000542 <panic>
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
